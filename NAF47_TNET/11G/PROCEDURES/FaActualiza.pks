create or replace PROCEDURE            FaActualiza (no_cia_p     IN     varchar2,
                                                                                        tipo_doc_p   IN     varchar2,
                                                                                        no_factu_p   IN     varchar2,
                                                                                        msg_error    IN OUT varchar2,
                                                                                        origen_p     IN     varchar2 default 'FA') IS
  -- CONSTANTES
  kind_oferta     CONSTANT varchar2(1) := 'S';
  kind_venta      CONSTANT varchar2(1) := 'N';
  --
  --
  vlin_inv        number;
  vestado_ccmd    arccmd.estado%type;
  vdiario         arfamc.cod_diario%type;
  --
  error_proceso   exception;
  vmes_fact       arincd.mes_proce_fact%type;           -- mes en proceso
  vsem_fact       arincd.semana_proce_fact%type;        -- semana en proceso
  vind_sem_fact   arincd.indicador_sem_fact%type;       -- indicador de semana
  vact_Inventario arccru.fact_actualiza_Inv%type;
  td_cxc          arfact.tipo_doc_cxc%TYPE;             -- docto a generar en cxc
  td_inve         arfact.tipo_doc_inve%TYPE;            -- docto a generar en inve
  --a
  vtipo_venta     arccmd.tipo_venta%type := 'V';  -- Se envia el tipo de venta por concepto de varios.
  vExiste         Boolean;

  vdummy          varchar2(1);

  Lv_consignacion Arfact.ind_consignacion%type;
  Lv_autoconsumo  Arfact.ind_autoconsumo%type;

  Lv_tipo_doc     Arfact.tipo%type;
  Lv_pedido       varchar2(1) := '';
  --
  -- Encabezado de la factura
  CURSOR c_factura IS
    SELECT e.afecta_saldo, e.grupo, e.no_cliente,
           e.fecha, e.plazo, e.no_vendedor,
           nvl(e.total,0) total, e.centrod, e.periodo,
           e.ruta, e.tipo_cambio, e.rowid regid,
           e.moneda, e.monto_bienes, e.monto_serv,
           e.monto_exportac, e.no_fisico, e.serie_fisico, e.codigo_plazo, e.subcliente, e.origen,
           e.sub_total, e.impuesto, e.tipo_doc, c.razon_social, e.no_factu,e.no_pedido, e.bodega,
           e.cod_doctor --- POS
           ,nvl(e.monto_forma_pago,0) monto_forma_pago, e.no_autorizacion
      FROM arfafe e, arccmc c
     WHERE e.no_cia   = no_cia_p
       AND e.no_factu = no_factu_p
       AND e.tipo_doc = tipo_doc_p
       AND e.estado   = 'P'
       AND e.no_cia = c.no_cia
       AND e.no_cliente = c.no_cliente;
  --
  -- Codigo de Diario
  CURSOR c_diario IS
    SELECT cod_diario
      FROM arfamc
     WHERE no_cia   = no_cia_p;
  --
  -- Lineas de la factura
  CURSOR c_lineas_factura IS
    SELECT l.*, d.ind_lote
      FROM arfafl l, arinda d
     WHERE l.no_cia    = no_cia_p
       AND l.tipo_doc  = tipo_doc_p
       AND l.no_factu  = no_factu_p
       AND l.no_cia    = d.no_cia
       AND l.no_arti   = d.no_arti;

  Cursor C_Arfact Is
   select nvl(ind_consignacion,'N') consignacion, nvl(ind_autoconsumo,'N') autoconsumo
   from   arfact
   where  no_cia = no_cia_p
   and    tipo   = tipo_doc_p;

  --
  --
  CURSOR c_periodo (pCentro ArInCD.centro%type) IS
    SELECT mes_proce_fact, semana_proce_fact, indicador_sem_fact
      FROM arincd
     WHERE no_cia = no_cia_p
       AND centro = pCentro;
  --

  -- Verifica el documento a generar en CxC
   cursor c_tipo_doc_cxc is
    select 'X'
    from  arcctd
    where no_cia       = no_cia_p
      and tipo         = td_cxc
      and tipo_mov     = 'D'
      and factura      = 'S'
      and afecta_saldo = 'S'; ---- Siempre es un documento de credito que se configura ANR 23/06/2009
      ---and afecta_saldo = afecta_saldo_p;

  -- Verifica el documento a generar en Inventarios
   cursor c_tipo_doc_inve is
    select 'X'
    from  arinvtm
    where no_cia       = no_cia_p
      and tipo_m       = td_inve
      and movimi       = 'S'
      and ventas       = 'S';

  --- Recupero los plazos y los dividendos ANR 23/06/2009

   Cursor c_plazo (Lv_codigo Varchar2) is
      select dd_dividendo,dd_cuotas
      from  arccdividendo
      where no_cia = no_cia_p
      and   codigo = Lv_codigo
      Order by dd_dividendo;

   Cursor C_Dividendo (Lv_Codigo Varchar2) Is
      Select dividendo
      from   arccplazos
      where  NO_CIA = no_cia_p
      and    codigo = Lv_codigo;

   Cursor C_Formulario (Lv_centrod Varchar2, Lv_centrof Varchar2, Lv_tipo_doc Varchar2) Is
     select formulario
     from   arfaft
     where  no_cia   = no_cia_p
     and    centrod  = Lv_centrod
     and    centrof  = Lv_centrof
     and    tipo_doc = Lv_tipo_doc;

   --- Genera el numero de autorizacion del SRI ANR 18/08/2009

   Cursor C_Autorizacion (Lv_formulario Varchar2, Lv_tipo_doc Varchar2,
                          Lv_serie_fisico Varchar2, Lv_no_fisico Varchar2,
                          Ld_fecha Date) Is
    select autorizacion, fecha_hasta
    from   arccautcli
    where  no_cia          = no_cia_p
    and    formulario      = Lv_formulario
    and    tipo_doc_cxc    = Lv_tipo_doc
    and    nvl(estado,'I') = 'A'
    and    serie           = Lv_serie_fisico
    and    to_number(Lv_no_fisico) between inicio_bloque and fin_bloque
    and    trunc(Ld_fecha) between fecha_desde and fecha_hasta;

  CURSOR c_gravado_exento IS
    SELECT gravada, exento
      FROM arfafe
     WHERE no_cia   = no_cia_p
       AND no_factu = no_factu_p
       AND tipo_doc = tipo_doc_p;

  --
  Cursor C_Factura1 Is
   SELECT 'x'
     FROM ARFAFL_LOTE
     WHERE NO_CIA=no_cia_p
     AND NO_FACTU=no_factu_p;


  CURSOR C_LOTES IS
    SELECT L.NO_CIA,   L.CENTROD, L.NO_FACTU, L.BODEGA, L.NO_ARTI, L.NO_LINEA, L.NO_LOTE,
           L.UNIDADES, L.FECHA_VENCE, L.UBICACION
    FROM ARFAFL_LOTE L
    WHERE L.NO_CIA   = no_cia_p
      AND L.NO_FACTU = no_factu_p;

  CURSOR C_OTROS_DATOS (P_LINEA VARCHAR) IS
    Select PERIODO, RUTA, COSTO, CENTROD
    from ARFAFL
    WHERE NO_CIA =no_cia_p
      AND NO_FACTU=no_factu_p
      AND NO_LINEA = P_LINEA;

  -- REGISTROS
  ef        c_factura%ROWTYPE;
  ge        c_gravado_exento%ROWTYPE;
  --

  Ln_NumDividendos Number;
  Ln_Divisor       Number;
  Ln_DTotal        Number;
  Ln_RTotal        Number;

  Lv_formulario         Arcctd.formulario%type;
  Lv_autorizacion       Arfafe.no_autorizacion%type;
  Ld_fecha_autorizacion Arfafe.Fecha_Vigencia_Autoriz%type;

  Ln_monto_bienes    Arfafe.monto_bienes%type;
  Ln_monto_servicio  Arfafe.monto_serv%type;

  V_PERIODO          ARFAFL.PERIODO%TYPE;
  V_RUTA             ARFAFL.RUTA%TYPE;
  V_COSTO            ARFAFL.COSTO%TYPE;
  V_CENTRO           ARFAFL.CENTROD%TYPE;

  Ln_dividendo       Arccdividendo.dd_dividendo%type;
  Ln_cuotas          Arccdividendo.dd_cuotas%type;


BEGIN
  --
  moneda.inicializa_datos_redondeo(no_cia_p);
  --
  msg_error := Null;

  OPEN  c_factura;
  FETCH c_factura INTO ef;
  vExiste:=c_factura%found;
  close c_factura;
  if not vExiste THEN
    CLOSE c_factura;
    msg_error := 'Factura no existe';
    RAISE error_proceso;
  END IF;

     -- Genera dividendos de Facturacion ANR 23/06/2009
   If ef.codigo_plazo is null Then
     msg_error:='No existe el codigo de plazo para el documento: '||tipo_doc_p||' '||no_factu_p;
     raise error_proceso;
   end if;

    Open C_Dividendo (ef.codigo_plazo);
    Fetch C_Dividendo into Ln_NumDividendos;
    If C_Dividendo%notfound Then
     Close C_Dividendo;
     msg_error:='No existe dividendo para el codigo de plazo: '||ef.codigo_plazo;
     raise error_proceso;
    else
     Close C_Dividendo;
    end if;

    If Ln_NumDividendos = 0 Then
     msg_error:='El dividendo es cero,  para el codigo de plazo: '||ef.codigo_plazo||' No se puede procesar el documento: '||tipo_doc_p||' '||no_factu_p;
     raise error_proceso;
    end if;

     Ln_DTotal        := ef.total;
     Ln_NumDividendos := Nvl(Ln_NumDividendos, 1);
     Ln_Divisor       := Ln_NumDividendos;

     --- Verifica que existan configurados dividendos para el plazo ANR 02/12/2010
     Open C_Plazo (ef.codigo_plazo);
     Fetch C_Plazo into Ln_dividendo, Ln_cuotas;
     If C_plazo%notfound Then
        Close  C_plazo;
           msg_error:='Es necesario que configure los dividendos para el plazo: '||ef.codigo_plazo;
           raise error_proceso;
     else
        Close C_plazo;
     end if;

      FOR I IN C_PLAZO(ef.codigo_plazo) LOOP

      Ln_RTotal := Round(Nvl(Ln_DTotal,0)/Nvl(Ln_Divisor,1), 2);

      Begin
      Insert into Arfadividendos (no_cia, centrod, tipo_doc, no_factu, dividendo, valor, fecha_vence)
                          Values (no_cia_p, ef.centrod, tipo_doc_p, no_factu_p, i.dd_dividendo,Ln_RTotal, ef.fecha + i.dd_cuotas);

      Exception
      When others then
          msg_error:='Error al crear dividendo: '||no_factu_p||' Dividendo: '||i.dd_dividendo||' '||sqlerrm;
          raise error_proceso;
      End;

      Ln_DTotal  := Ln_DTotal - Ln_RTotal;
      Ln_Divisor := Ln_NumDividendos - I.dd_dividendo;

     END LOOP;
  --
  -- Obtiene el tipo de documento a generar en CxC e Inventarios
  td_cxc  :=INLIB.doc_cxc(no_cia_p,tipo_doc_p);
  td_inve :=INLIB.doc_inve(no_cia_p,tipo_doc_p);

  -- Chequea que el documento este igualmente declarado en CXC
  if td_cxc is not null then
    open c_tipo_doc_cxc;
    fetch c_tipo_doc_cxc into vdummy;
    vExiste:=c_tipo_doc_cxc%found;
    close c_tipo_doc_cxc;
    if not vExiste then
     msg_error:='FAactuliza: El tipo documento '||td_cxc||' (debito), no existe o esta diferente en CXC';
     raise error_proceso;
    end if;
  end if;

  Open C_Arfact;
  Fetch C_Arfact into Lv_consignacion, Lv_autoconsumo;
  If C_Arfact%notfound Then
   Close C_Arfact;
    msg_error := 'No existe tipo de documento: '||tipo_doc_p;
    RAISE error_proceso;
  else
   Close C_Arfact;
  end if;

  If ef.origen = 'FA' Then

      --- Emite el numero de autorizacion para el SRI ANR 18-08-2009

      Open C_Formulario (ef.centrod, ef.ruta, ef.tipo_doc);
      Fetch C_Formulario into Lv_formulario;
      If C_Formulario%notfound Then
       Close C_Formulario;
         msg_error:='No existe formulario configurado para centro dist: '||ef.centrod||' centro fact: '||ef.ruta||' tipo doc: '||ef.tipo_doc;
         raise error_proceso;
      else
       Close C_Formulario;

        --- Si es autoconsumo envio el tipo de documento de facturacion, caso contrario envio el tipo de documento
        --- de cuentas por cobrar ANR 14/10/2009

        If Lv_autoconsumo = 'S' then
         Lv_tipo_doc := tipo_doc_p;
        else
         Lv_tipo_doc := td_cxc;
        end if;
        
        -- si se genero por comprobante electronico ya no se recupera de secuencia
        if ef.no_autorizacion is null then
          Open C_Autorizacion (Lv_formulario, Lv_tipo_doc,
                               ef.serie_fisico, ef.no_fisico,
                               ef.fecha);
          Fetch C_Autorizacion into Lv_autorizacion, Ld_fecha_autorizacion;
          If C_Autorizacion%notfound Then
           Close C_Autorizacion;
             msg_error:='No existe autorizacion para el formulario: '||Lv_formulario||' T.doc. CxC: '||td_cxc||' serie: '||ef.serie_fisico||' no. fisico: '||ef.no_fisico||' fecha: '||ef.fecha;
             raise error_proceso;
          else
           Close C_Autorizacion;
          end if;
        else
          --
          Lv_autorizacion := ef.no_autorizacion;
          Ld_fecha_autorizacion := ef.fecha;
        end if;

      end if;

  end if;

  -- Chequea que el documento este igualmente declarado en Inve
  if td_inve is not null then
    open c_tipo_doc_inve;
    fetch c_tipo_doc_inve into vdummy;
    vExiste:=c_tipo_doc_inve%found;
    close c_tipo_doc_inve;
    if not vExiste then
       msg_error:='FAactualiza: El tipo documento '||td_inve||', no existe o esta diferente en Inventarios';
       raise error_proceso;
    end if;
  End if;


  IF nvl(ef.total,0) <= 0 THEN
     msg_error := 'El monto de la factura es 0';
     RAISE error_proceso;
  END IF;
  -- --
  --
  -- obtiene el periodo en proceso
  OPEN  c_periodo(ef.centrod);
  FETCH c_periodo INTO vmes_fact, vsem_fact, vind_sem_fact;
  IF c_periodo%notfound THEN
    CLOSE c_periodo;
    msg_error := 'El periodo en proceso no se encuentra definido para el centro';
    RAISE error_proceso;
  END IF;
  CLOSE c_periodo;
  --
  -- obtiene el indicador de si actualiza el inventario inmediatamente
  --- El inventario siempre debe ir actualizado, ya que el picking se encarga del despacho
  --- ANR 23/07/2009
  vAct_inventario := 'S';

  -- Crea documento para despachar en inventario
  -- se crea con el numero de trnsaccion de facturacion

 If Lv_autoconsumo != 'S' and ef.bodega != '0000' Then ---- Autoconsumo no genera inventarios

  Begin
  INSERT INTO arinme(no_cia, centro, tipo_doc, periodo, ruta,
              no_docu, estado, fecha, tipo_cambio,
              no_fisico, serie_fisico,
              tipo_refe, no_refe, serie_refe,no_docu_refe,
              origen,observ1)
       VALUES (
              no_cia_p, ef.centrod, td_inve, ef.periodo, ef.ruta,
              no_factu_p, 'P', ef.fecha, ef.tipo_cambio,
              ef.no_fisico, ef.serie_fisico,
              tipo_doc_p, ef.no_fisico, ef.serie_fisico,no_factu_p,
              'FA',
              Substr('Cliente '||ef.no_cliente||'-'||ef.subcliente||' '||ef.razon_social||' TipoDoc. '||ef.tipo_doc||' Transa.'||ef.no_factu||' Vend.'||ef.no_vendedor,1,400));
    Exception
    When Others Then
     msg_error := 'Error al crear cabecera de inventarios: '||td_inve||' '||no_factu_p||' '||sqlerrm;
     RAISE error_proceso;
    End;

  end if;

  -- ---
  -- procesa lineas de la factura
  --

  vlin_inv       := 0;
  ----vcontrol_estad := 'N';

  Ln_monto_bienes   := 0;
  Ln_monto_servicio := 0;

  FOR lf IN c_lineas_factura LOOP

  If lf.bodega != '0000' Then
   Ln_monto_bienes   := Ln_monto_bienes + (lf.total - lf.descuento);
  else
   Ln_monto_servicio := Ln_monto_servicio + (lf.total - lf.descuento);
  end if;
    --
  If lf.linea_art_promocion is null Then
    -- si no es un servicio entonces afecta en inventario
    IF lf.clase != '000' and Lv_autoconsumo != 'S' THEN ---- diferente de bonificacion
      -- inserta linea en inventario (pedido)
      vlin_inv  := vlin_inv + 1;
      FAactualiza_inv_ml(no_cia_p, ef.centrod, td_inve, ef.periodo,
                ef.ruta,no_factu_p, lf.no_linea, lf.no_linea, Lv_consignacion, lf.bodega, lf.clase,
                lf.categoria, lf.no_arti, lf.ind_lote, kind_venta,
                lf.pedido, lf.costo, Moneda.Redondeo(lf.pedido * lf.costo,'P'),Moneda.Redondeo(lf.pedido * lf.costo2,'P'),
                ef.tipo_cambio, ef.fecha, msg_error);
      IF msg_error is not null THEN
        RAISE error_proceso;
      END IF;
    END IF;
    ----IF (vcontrol_estad = 'S') THEN  --- siempre guarda las estadisticas
    --- Facturas de autoconsumo no se guardan en estadisticas de venta ANR 06/10/2009
      If lv_autoconsumo != 'S' Then
      FAestadistica_venta(lf.no_cia, lf.centrod, lf.clase, lf.categoria,
                     lf.no_arti, ef.grupo, ef.no_cliente, ef.no_vendedor,
                     ef.ruta, vsem_fact, vind_sem_fact, ef.periodo, vmes_fact,
                     'VEN', lf.costo, lf.costo2, lf.pedido, (lf.total - nvl(lf.imp_incluido,0)),
                     lf.descuento, lf.i_ven_n, lf.imp_incluido,
                     ef.moneda, ef.tipo_cambio,
                     ef.cod_doctor, --- POS
                     msg_error  );
          IF msg_error is not null THEN
            RAISE error_proceso;
          END IF;
      end if;
    end if;

    -- ---
    -- si hubo ofertas, las actualiza tambien
    --
    ---- Las ofertas se manejan en la misma linea de la factura ANR 23/07/2009
      IF (lf.linea_art_promocion is not null) THEN --- Es una bonificacion
       --
       -- si la oferta no corresponde a un servicio entonces afecta en inventario
       IF lf.clase != '000' and Lv_autoconsumo != 'S' THEN
         -- --
         -- Inserta linea en inventario por oferta
         vlin_inv := vlin_inv + 1;
         FAactualiza_inv_ml(no_cia_p, ef.centrod, td_inve, ef.periodo,
                     ef.ruta, no_factu_p, lf.no_linea, lf.no_linea, lv_consignacion, lf.bodega, lf.clase,--vclase_ofe,
                     lf.categoria, lf.no_arti,---vcate_ofe, lf.arti_ofe,
                     lf.ind_lote,---vind_lote_ofe,
                     kind_oferta,
                     lf.pedido,---,lf.cant_ofe,  --- el pedido ya tiene incluido la cantidad adicional ANR 30/07/2009
                     lf.costo,---lf.costo_ofe,
                     Moneda.Redondeo(lf.pedido  * lf.costo,'P'),Moneda.Redondeo(lf.pedido  * lf.costo2,'P'),
                     ef.tipo_cambio, ef.fecha, msg_error);
         IF msg_error is not null THEN
           RAISE error_proceso;
         END IF;
       END IF;

       --- Facturas de autoconsumo no se guardan en estadisticas de venta ANR 06/10/2009
      If lv_autoconsumo != 'S' Then
         FAestadistica_venta(lf.no_cia, lf.centrod, lf.clase, lf.categoria,---vclase_ofe, vcate_ofe,
                     lf.no_arti,----lf.arti_ofe,
                     ef.grupo, ef.no_cliente, ef.no_vendedor,
                     ef.ruta, vsem_fact, vind_sem_fact, ef.periodo, vmes_fact, --- El pedido ya tiene la cantidad adicional
                     'OFE', lf.costo, lf.costo2, lf.pedido,----lf.costo_ofe, lf.cant_ofe,
                     0, 0, 0, 0,
                     ef.moneda, ef.tipo_cambio,
                     ef.cod_doctor, --- POS
                     msg_error );
         IF msg_error is not null THEN
           RAISE error_proceso;
         END IF;
     end if;

     END IF;
  END LOOP;

  -- MNA 01/02/2010
  --- PREGUNTO SI LA TRANSACCI{ON TIENE LINEAS DE LOTES Y LAS SUBO A ARINMO DE ARINFL_LOTES
      Open C_Factura1;
       Fetch C_Factura1 into Lv_pedido;
       vExiste := C_Factura1%Found;
        Close C_Factura1;


 --- se anade la validacion de consignacion y pedido ANR 04/02/2010
  IF vExiste and ef.no_pedido is not null   THEN
    For LOTES IN C_LOTES lOOP

       Open C_OTROS_DATOS(LOTES.NO_LINEA);
       Fetch C_OTROS_DATOS INTO V_PERIODO, V_RUTA, V_COSTO, V_CENTRO;
       Close C_OTROS_DATOS;

       begin
       insert into arinmo(no_cia, centro, tipo_doc, periodo, ruta,
                   no_docu, linea, no_lote, unidades, monto,
                   ubicacion, fecha_vence)
            values(
                   no_cia_p, V_centro, tipo_doc_p, V_PERIODO, V_ruta,
                   no_factu_p, lotes.no_linea, lotes.no_lote, lotes.unidades, (lotes.unidades*v_costo),
                   loteS.ubicacion, LOTES.fecha_vence);
   Exception
   When Others then
        msg_error := 'Error al crear movimiento de lote '||no_factu_p||' '||lotes.no_linea||' '||lotes.no_lote||' '||sqlerrm;
        RAISE error_proceso;
   End;

    End Loop;
  END IF;


  -- Cambia el estado de la factura actualizada
  UPDATE arfafe
     SET estado = 'D',
         no_autorizacion = Lv_autorizacion,
         fecha_vigencia_autoriz = Ld_fecha_autorizacion,
         monto_bienes = Ln_monto_bienes,
         monto_serv   = Ln_monto_servicio
   WHERE rowid = ef.regid;

    --- Actualiza valores gravado y exento de ARFAFE ANR 08/09/2009
    fagravado_exento(no_cia_p, no_factu_p, tipo_doc_p, msg_error);
       IF msg_error IS NOT NULL THEN
          RAISE error_proceso;
       END IF;

  IF vlin_inv <= 0 THEN
    --
    -- Si no genero lineas, borra el encabezado.
     DELETE arinme
      WHERE no_cia   = no_cia_p
        AND tipo_doc = td_inve
        AND no_docu  = no_factu_p;
  ELSE
    -- Actualiza el total del documento en inventario
    UPDATE arinme e
       SET mov_tot = (SELECT sum(monto)
                        FROM arinml
                       WHERE no_cia   = e.no_cia
                         AND no_docu  = no_factu_p
                         AND tipo_doc = e.tipo_doc)
     WHERE no_cia   = no_cia_p
       AND tipo_doc = td_inve
       AND no_docu  = no_factu_p;
    --
    -- Determina si actualiza el inventario inmediatamente
    IF vAct_Inventario = 'S' THEN
      InActualiza( no_cia_p, td_inve, no_factu_p, msg_error);
      IF msg_error is not null THEN
        RAISE error_proceso;
      END IF;
    END IF;
  END IF;
  --
  -- registra el documento en cuenta por cobrar si afecta_saldo = 'S' y si el
  -- movimiento es de Facturacion y no del Punto de Ventas (PV) pues en ese caso
  -- las CxC se generan en el Cierre de Tienda del PV.
  IF  --- Solo se va a generar a CxC las facturas al por mayor de credito ANR 28/02/2011
     origen_p = 'FA' and lv_autoconsumo != 'S' and nvl(ef.afecta_saldo,'N') = 'S' THEN --- para autoconsumo no se genera a CxC ANR 14/10/2009
     OPEN  c_diario;
     FETCH c_diario INTO vdiario;
     IF c_diario%NOTFOUND OR vDiario IS NULL THEN
        CLOSE c_diario;
        msg_error := 'No se pudo obtener el codigo de diario de la compa?ia '||no_cia_p||
                     ' en Facturacion' ;
        RAISE error_proceso;
     END IF;
     CLOSE c_diario;
     vestado_ccmd := 'P';

     -- Genera el documento en Cuentas x Cobrar con el mismo de no de factura

    OPEN  c_gravado_exento;
    FETCH c_gravado_exento INTO ge;
    CLOSE c_gravado_exento;

     Begin
     INSERT INTO arccmd(no_cia, centro, tipo_doc, periodo, ruta, no_docu,
                        grupo, no_cliente, moneda, fecha, fecha_vence,
                        fecha_documento,
                        m_original, descuento, saldo, tipo_venta,
                        gravado, exento, monto_bienes, monto_serv, monto_exportac,
                        no_agente, estado, tipo_cambio,
                        total_ref, total_db, total_cr, origen, ano, mes, semana,
                        no_fisico, serie_fisico, cod_diario, no_docu_refe, usuario, sub_cliente,
                        tstamp, subtotal, tot_imp, no_autorizacion, fecha_vigencia_autoriz)
                VALUES (no_cia_p, ef.centrod, td_cxc, ef.periodo, ef.ruta, no_factu_p,
                        ef.grupo, ef.no_cliente, ef.moneda, ef.fecha, ef.fecha + nvl(ef.plazo, 0),
                        ef.fecha,
                        --- se resta el valor de forma de pago al contado ANR 28/02/2011
                        ef.total-ef.monto_forma_pago, 0, ef.total-ef.monto_forma_pago, vtipo_venta,
                        ge.gravada, ge.exento, ef.monto_bienes, ef.monto_serv, ef.monto_exportac,
                        ef.no_vendedor, vestado_ccmd,  ef.tipo_cambio,
                        0, 0, 0, 'FA', ef.periodo, vmes_fact, vsem_fact,
                        ef.no_fisico, ef.serie_fisico, vDiario,no_factu_p, user, ef.subcliente,
                        sysdate, ef.sub_total, ef.impuesto, Lv_autorizacion, Ld_fecha_autorizacion);

   Exception
   When Others then
        msg_error := 'Error al crear documento en CxC '||no_factu_p||' '||sqlerrm;
        RAISE error_proceso;
   End;

    --- Se crea el registro del impuesto ANR 08/10/2009

     Begin

         Insert Into Arccti (no_cia, grupo, no_cliente, tipo_doc, no_docu, no_refe, clave, porcentaje,
                             monto, codigo_tercero, base, comportamiento, aplica_cred_fiscal, ind_imp_ret,
                             id_sec, usuario_registra, tstamp)
          select b.no_cia, a.grupo, a.no_cliente, td_cxc, b.no_factu, b.no_factu, b.clave, b.porc_imp,
                 sum(b.monto_imp), b.codigo_tercero, sum(base), b.comportamiento, b.aplica_cred_fiscal,'I',
                 b.id_sec, user,
                 sysdate
          from   arfafe a, arfafli b
          where  b.no_cia   = no_cia_p
          and    b.no_factu = no_factu_p
          and    a.no_cia   = b.no_cia
          and    a.no_factu = b.no_factu
          group by b.no_cia, a.grupo, a.no_cliente, td_cxc, b.no_factu, b.no_factu, b.clave, b.porc_imp,
                 b.codigo_tercero, b.comportamiento, b.aplica_cred_fiscal,'I',
                 b.id_sec, user, sysdate;

     Exception
         When Others Then
            msg_error := 'Error al crear registro para el impuesto. Transaccion: '||no_factu_p||' '||sqlerrm;
            raise error_proceso;
     end;

   ccActualiza(no_cia_p, td_cxc, no_factu_p, msg_error);
   IF msg_error IS NOT NULL THEN
      RAISE error_proceso;
   END IF;
  END IF; -- factura de credito
  --
  --
EXCEPTION
  WHEN error_proceso THEN
     msg_error := 'FAACTUALIZA : '||msg_error;
     return;
  WHEN OTHERS THEN
     msg_error := 'FAACTUALIZA : '||sqlerrm;
     return;
END;