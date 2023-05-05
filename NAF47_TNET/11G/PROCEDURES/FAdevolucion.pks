create or replace PROCEDURE            FAdevolucion (no_cia_p     in     varchar2,
                                          tipo_doc_p   in     varchar2,
                                          no_factu_p   in     varchar2,
                                          msg_error_p  in out varchar2,
                                          origen_p     in     varchar2 default 'FA') IS
  --
  -- CONSTANTES

  kind_venta      CONSTANT VARCHAR2(1) := 'N';

  --
  vmes_fact       arincd.mes_proce_fact%type;
  vsem_fact       arfaev.semana%type;
  vind_sem_fact   arfaev.ind_sem%type;
  --
  vcontrol_estad  arinca.control_estad%type;
  vclase_ant      arinda.clase%type;
  vcosto          arinml.monto%type;
  vlin_inv        number;
  vdoc_devol_inve arinvtm.tipo_m%type;
  vdoc_orig_inve  arinvtm.tipo_m%type;
  vLote_arti      VARCHAR2(1) := 'N';
  --
  vExiste         Boolean;
  --
  error_proceso   EXCEPTION;
  --
  CURSOR c_periodo (pCentro arincd.centro%type) IS
    SELECT mes_proce_fact, semana_proce_fact, indicador_sem_fact
      FROM arincd
     WHERE no_cia = no_cia_p
       AND centro = pCentro;
  --
  -- Encabezado de la Devolucion
  CURSOR c_doc_devol IS
    SELECT e.centrod,    e.afecta_saldo,
           e.grupo,      e.no_cliente,
           e.fecha,      e.plazo,      e.no_vendedor,
           nvl(e.total,0) total,       e.periodo,
           e.ruta,       e.tipo_cambio,e.monto_bienes,
           e.monto_serv, e.monto_exportac,
           e.moneda,     e.no_fisico,    e.serie_fisico,
           e.tipo_doc_d, e.n_factu_d,  e.ruta_d, f.tipo_doc_cxc, e.origen,
           e.rowid regid
      FROM arfafe e, arfact f
     WHERE e.no_cia   = no_cia_p
       AND e.no_factu = no_factu_p
       AND e.estado   = 'P'
       AND e.no_cia = f.no_cia
       AND e.tipo_doc = f.tipo;
  --
  -- Lineas de la devolucion
  CURSOR c_lineas_devol IS
    SELECT l.*, d.ind_lote
      FROM arfafl l, arinda d
     WHERE l.no_cia    = no_cia_p
       AND l.no_factu  = no_factu_p
       AND l.no_cia    = d.no_cia
       AND l.no_arti   = d.no_arti;
  --
  -- Encabezado de la factura (original)
  CURSOR c_factura(ptipo_doc  arfafe.tipo_doc%type,
                   pno_factu  arfafe.no_factu%type) IS
    SELECT e.grupo, e.no_cliente, e.no_fisico, e.serie_fisico,
           e.rowid regid, nvl(f.ind_autoconsumo,'N') autoconsumo,
           NO_DOCU_REFE_CONSIGNA --- numero para la consignacion ANR 18/03/2010
      FROM arfafe e, arfact f
     WHERE e.no_cia    = no_cia_p
       AND e.no_factu  = pno_factu
       AND (e.ind_anu_dev is null or e.ind_anu_dev = 'D')
       AND e.no_cia = f.no_cia
       AND e.tipo_doc = f.tipo;
  --
  CURSOR c_clase(pclase varchar2) IS
    SELECT control_estad
      FROM arinca
     WHERE no_cia  = no_cia_p
       AND codigo  = pclase;

  -- Obtiene los datos del documento que se creara en inventarios
  -- por la devolucion
  CURSOR c_datos_tipo_doc (pdocto in varchar2) IS
    SELECT interface, movimi,ventas
      FROM arinvtm
     WHERE no_cia     = no_cia_p
       AND tipo_m     = pdocto;
  --
  CURSOR c_doc_inve_orig (refe_p in varchar2) is
    SELECT  tipo_doc
      FROM  arinme
     WHERE  no_cia = no_cia_p
       AND  no_docu= refe_p;
  --
  CURSOR c_centro_factu (pCentroF arccru.codigo%type) IS
    SELECT nvl(fact_actualiza_inv,'N') fact_actualiza_inv,
       nvl(tipo,'P') tipo
      FROM arccru
     WHERE no_cia = no_cia_p
       AND codigo = pCentroF;
  --
  --
  CURSOR c_lote_arti(pno_arti varchar2) IS
    Select ind_lote from arinda
     Where no_cia = no_cia_p
       and no_arti = pno_arti;

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

 --
  vact_inventario arccru.fact_actualiza_inv%type;
  vtipo           arccru.tipo%type;
  ef              c_doc_devol%ROWTYPE;         -- devolucion
  efo             c_factura%ROWTYPE;           -- factura de la que se devuelve
  rtd             c_datos_tipo_doc%rowtype;

  Lv_autorizacion       arccmd.no_autorizacion%type;
  Ld_fecha_autorizacion arccmd.fecha_vigencia_autoriz%type;

  Lv_formulario         arfaft.formulario%type;

BEGIN
  msg_error_p := NULL;
  --
  moneda.inicializa_datos_redondeo(no_cia_p);
  --
  OPEN  c_doc_devol;
  FETCH c_doc_devol INTO ef;
  IF c_doc_devol%notfound THEN
    CLOSE c_doc_devol;
    msg_error_p := 'NO existe el documento de devolucion: '||no_factu_p;
    RAISE error_proceso;
  END IF;
  CLOSE c_doc_devol;
  --

  If ef.origen = 'FA' Then

      Open C_Formulario (ef.centrod, ef.ruta, tipo_doc_p);
      Fetch C_Formulario into Lv_formulario;
      If C_Formulario%notfound Then
       Close C_Formulario;
         msg_error_p:='No existe formulario configurado para centro dist: '||ef.centrod||' centro fact: '||ef.ruta||' tipo doc: '||tipo_doc_p;
         raise error_proceso;
      else
       Close C_Formulario;
      end if;

      Open C_Autorizacion (Lv_formulario, ef.tipo_doc_cxc,
                           ef.serie_fisico, ef.no_fisico,
                           ef.fecha);
      Fetch C_Autorizacion into Lv_autorizacion, Ld_fecha_autorizacion;
      If C_Autorizacion%notfound Then
       Close C_Autorizacion;
         msg_error_p:='No existe autorizacion para el formulario: '||Lv_formulario||' T.doc. CxC: '||ef.tipo_doc_cxc||' serie: '||ef.serie_fisico||' no. fisico: '||ef.no_fisico||' fecha: '||ef.fecha;
         raise error_proceso;
      else
       Close C_Autorizacion;
      end if;

  end if;

  -- --
  -- obtiene el periodo en proceso
  OPEN  c_periodo(ef.centrod);
  FETCH c_periodo INTO vmes_fact, vsem_fact, vind_sem_fact;
  IF c_periodo%notfound THEN
    CLOSE c_periodo;
    msg_error_p := 'No se pudo obtener el periodo en proceso';
    RAISE error_proceso;
  END IF;
  CLOSE c_periodo;
  --
  -- Referencia de factura
  IF ef.n_factu_d is not null THEN
    --
    -- la devolucion es referenciada a una factura
    OPEN c_factura(ef.tipo_doc_d, ef.n_factu_d);
    FETCH c_factura INTO efo;
    IF c_factura%notfound THEN
      CLOSE c_factura;
      msg_error_p := 'NO pudo localizar la factura original';
      RAISE error_proceso;
    END IF;
    CLOSE c_factura;
  END IF;
  --

 --- Si la factura original es de autoconsumo no se puede hacer devoluciones ANR 14/10/2009

 If efo.autoconsumo = 'S' Then
     msg_error_p :='No se puede hacer devoluciones, para una factura de autoconsumo';
    raise error_proceso;
 end if;


 -- obtiene el tipo de ruta o centro de facturacion, asi como el indicador de si actualiza el movimiento
  -- en Inventarios de forma automatica.
  OPEN  c_centro_factu(ef.ruta);
  FETCH c_centro_factu INTO vAct_Inventario, vtipo;
  CLOSE c_centro_factu;
  -- ---
  -- Obtiene el documento para generar la devolucion en inventarios
  vdoc_devol_inve :=INLIB.doc_inve(no_cia_p,tipo_doc_p);
  if vdoc_devol_inve is null then
    msg_error_p :='Documento de devolucion a generar en Inventarios, originado por un '||tipo_doc_p||' no gha sido definido';
    raise error_proceso;
  end if;

  OPEN  c_datos_tipo_doc(vdoc_devol_inve);
  FETCH c_datos_tipo_doc INTO rtd;
  vExiste:=c_datos_tipo_doc%found;
  CLOSE c_datos_tipo_doc;

  IF not vExiste then
    msg_error_p := 'Tipo de movimiento a generar en la devolucion de inventario no existe';
    RAISE error_proceso;
  ELSIF rtd.movimi != 'E' THEN
    msg_error_p := 'Tipo de movimiento de la devolucion  en inventario debe ser de entrada';
    RAISE error_proceso;
  ELSIF rtd.ventas !='S' THEN
    msg_error_p := 'El docto de devolucion inventario debe ser de venta';
    RAISE error_proceso;
  ELSIF rtd.interface !='FA' THEN
    msg_error_p := 'El docto de devolucion en inventario debe tener interface con facturacion';
    RAISE error_proceso;
  END IF;
  --
  -- Crea documento para la recepcion en inventario
  IF ef.n_factu_d is not null THEN
    OPEN  c_doc_inve_orig(ef.n_factu_d);
    FETCH c_doc_inve_orig INTO vdoc_orig_inve;
    vExiste := c_doc_inve_orig%FOUND;
    CLOSE c_doc_inve_orig;
    IF not vExiste then
      msg_error_p:='Docto originado desde la facturacion, a anular en Inventario no existe';
      RAISE error_proceso;
    END IF;
  END IF;
  Begin
  INSERT INTO arinme(no_cia,       centro, tipo_doc,
                     periodo,      ruta,   no_docu,
                     estado,       fecha,
                     no_fisico,    serie_fisico, tipo_cambio,
                     tipo_refe,    no_refe,     serie_refe,
                     no_docu_refe, origen )  -- El doc. de devolucion
              VALUES(no_cia_p, ef.centrod, vdoc_devol_inve, ef.periodo, ef.ruta,
                     no_factu_p, 'P', ef.fecha,
                     ef.no_fisico,    ef.serie_fisico,  ef.tipo_cambio,
                     vdoc_orig_inve,  ef.no_fisico, ef.serie_fisico,
                     ef.n_factu_d,    'FA');
  Exception
  When Others Then
      msg_error_p:='Error al crear registro de cabecera de inventarios '||no_factu_p||' '||sqlerrm;
      RAISE error_proceso;
  End;

  -- ---
  -- procesa lineas de la devolucion
  --
  vlin_inv       := 0;
  vcontrol_estad := 'S';

  FOR lf IN c_lineas_devol LOOP
      IF vclase_ant is null or lf.clase != vclase_ant THEN
        -- determina si lleva estadisticas sobre el articulo
        vclase_ant := lf.clase;
        OPEN  c_clase(lf.clase);
        FETCH c_clase INTO vcontrol_estad;
        IF c_clase%NOTFOUND then
          CLOSE c_clase;
          msg_error_p := 'No existe la clase o linea de articulo: '||lf.clase;
          RAISE error_proceso;
        END IF;
        CLOSE c_clase;
      END IF;
      --
      Open  c_lote_arti (lf.no_arti);
      Fetch c_lote_arti into vLote_arti;
      Close c_lote_arti;
      --
      -- En la linea de la factura, aumenta la cantidad de articulos
      -- devueltos, siempre y cuando la devolucion haya sido con referencia
      IF ef.n_factu_d is not null THEN
        UPDATE arfafl
           SET un_devol = nvl(un_devol, 0) + abs(lf.pedido),
               tstamp = sysdate
         WHERE no_cia    = no_cia_p
           AND no_factu  = ef.n_factu_d
           AND no_linea  = lf.no_linea_d;
        IF sql%rowcount != 1 THEN
          msg_error_p := 'ERROR Al tratar de actualizar las devol. del articulo: '||lf.no_arti||
                         ', en la linea: '||to_char(lf.no_linea_d);
          RAISE error_proceso;
        END IF;
      END IF;
      --
      -- si no es un servico entonces afecta en inventario
      IF lf.clase != '000' THEN
        vlin_inv  := vlin_inv + 1;
        -- inserta linea en inventario
        vcosto    := ABS( nvl(Moneda.Redondeo(lf.pedido * lf.costo,'P'),0) );
        FAInserta_inv_ml (no_cia_p,         ef.centrod,     vdoc_devol_inve,
                           ef.periodo,      ef.ruta,        no_factu_p,
                           lf.no_linea,     lf.bodega,
                           lf.clase,        lf.categoria,   lf.no_arti,
                           vLote_arti,      kind_venta,
                           ABS(lf.pedido),  lf.costo,       vcosto,   lf.costo2,
                           ef.tipo_cambio,  ef.fecha,
                           msg_error_p);

        IF msg_error_p is not null THEN
          RAISE error_proceso;
        END IF;
      END IF;

      If efo.no_docu_refe_consigna is not null Then

      --- Debe actualizar las lineas de consignacion co lo devuelto ANR 18/03/2010
       Update arindetconsignacli
--         set uni_devueltas = nvl(uni_devueltas,0) + ABS(lf.pedido)
          set uni_facturadas = nvl(uni_facturadas,0) - ABS(lf.pedido)
       where no_cia  = no_cia_p
         and no_docu = efo.no_docu_refe_consigna
         and no_arti = lf.no_arti;

     end if;


      --
      --- Todos aplican control estadistico ANR 06/10/2009

    --- Facturas de autoconsumo no se guardan en estadisticas de venta ANR 06/10/2009
    /*** Para que se generen en estadisticas de venta las devoluciones sin referencia a facturas
         se anade nvl en autoconsumo y en ef.ruta_d se anade nvl ANR 21/06/2010 ****/
    If nvl(efo.autoconsumo,'N') != 'S' and lf.clase != '000' Then
        FAestadistica_venta(no_cia_p,          lf.centrod,
                            lf.clase,          lf.categoria,    lf.no_arti,
                            ef.grupo,          ef.no_cliente,   ef.no_vendedor,
                            nvl(ef.ruta_d,ef.ruta),         vsem_fact,       vind_sem_fact,
                            ef.periodo,        vmes_fact,
                            'DEV',             lf.costo,   lf.costo2,
                            abs(lf.pedido),    abs(lf.total) - abs(nvl(lf.imp_incluido,0)),
                            lf.descuento,      -- con signo negativo
                            lf.i_ven_n,        lf.imp_incluido,  -- con signo negativo
                            ef.moneda,         ef.tipo_cambio,
                            NULL,
                            msg_error_p  );


        IF msg_error_p is not null THEN
          RAISE error_proceso;
        END IF;
    End if;


  END LOOP;  -- lineas de la devolucion

    --- Actualiza valores gravado y exento de ARFAFE ANR 08/09/2009
    fagravado_exento(no_cia_p, no_factu_p, tipo_doc_p, msg_error_p);
       IF msg_error_p IS NOT NULL THEN
          RAISE error_proceso;
       END IF;

  --
  IF vlin_inv <= 0 THEN
    DELETE arinme
     WHERE no_cia   = no_cia_p
       AND no_docu  = no_factu_p;
  ELSE
    -- Actualiza el total del documento en inventario
    UPDATE arinme e
       SET (mov_tot) = (SELECT sum(monto)
                          FROM arinml
                         WHERE no_cia   = e.no_cia
                           AND no_docu  = e.no_docu)
     WHERE no_cia   = no_cia_p
       AND no_docu  = no_factu_p;
    --
    -- Los documentos generados desde cajas del POS (tipo = P), deben actualizarse automaticamente
    -- en Inventarios. Los demas documentos, quedan pendientes para su correspondiente revision en la
    -- recepcion de Inventarios.

    -- Martha Navarrete 24 Julio 2009
    -- Se comentarea pues todo documento debe ir actualizado a Inventarios, los despachos se manejan en nuevas pantallas
    -- de Picking por lo cual esta validacion no se utilizara.
      InActualiza( no_cia_p, vdoc_devol_inve, no_factu_p, msg_error_p);
      IF msg_error_p is not null THEN
        RAISE error_proceso;
      END IF;
    --END IF;
  END IF;
  --
  -- --
  -- pone el indicador de la factura original con Devoluciones
  UPDATE arfafe
     SET ind_anu_dev = 'D',
         tstamp = sysdate
   WHERE rowid = efo.regid;
  --
  -- Si el origen del movimiento es Facturacion (FA) y la factura es a credito,
  -- genera el respectivo movimiento a CxC. Para cuando el origen de la factura es
  -- el Punto de Venta (PV) no se hace la generacion a CxC, pues esto ya se hizo en
  -- el Cierre de Tienda del PV.
  IF ef.afecta_saldo = 'S' AND
   NVL(ef.Total,0) != 0 AND origen_p = 'FA' THEN
    FAdevolucion_cxc(no_cia_p,      tipo_doc_p, no_factu_p,
                     ef.no_fisico,  ef.serie_fisico, ef.fecha,
                     abs(ef.total), ef.monto_bienes,
                     ef.monto_serv, ef.monto_exportac,  ef.tipo_cambio,
                     ef.periodo,    vmes_fact,   vsem_fact,
                     ef.tipo_doc_d, ef.n_factu_d, Lv_autorizacion, Ld_fecha_autorizacion,
                     msg_error_p );
    IF msg_error_p is not null THEN
      RAISE error_proceso;
    END IF;
  END IF;
  --
  -- --
  -- Cambia el estado del documento devolucion a actualizado

  UPDATE arfafe
     SET estado = 'D',
         no_autorizacion = Lv_autorizacion,
         fecha_vigencia_autoriz = Ld_fecha_autorizacion,
         tstamp = sysdate
   WHERE rowid = ef.regid;
  ---

  IF msg_error_p is not null THEN
    RAISE error_Proceso;
  END IF;

EXCEPTION
  WHEN error_proceso THEN
       msg_error_p := nvl(msg_error_p, 'ERROR: En actualiza_devolucion');
       return;
  WHEN others THEN
       msg_error_p := 'FAdevolucion: '||SQLERRM(SQLCODE);
       return;
END;