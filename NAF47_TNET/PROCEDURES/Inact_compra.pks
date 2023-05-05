create or replace PROCEDURE            Inact_compra(cia_p          in Varchar2,
                                         tipo_p         in Varchar2,
                                         docu_p         in Varchar2,
                                         movimi_p       in Varchar2,
                                         interface_p    in Varchar2,
                                         cta_docu_p     in Varchar2,
                                         cta_docu_dol_p in Varchar2,
                                         time_stamp_p   in Date,
                                         msg_error_p    in out Varchar2) Is
  --
  --  Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  --  tanto solo INactualiza deberia utilizarlo.
  --  La funcion especifica es la de actualizar los documentos de compras,
  --  aumentando el inventario y registrandro la factura en el modulo
  --  de cuentas por pagar.

  -- Lee el documento de compra que esta pendiente de actualizar.
  Cursor c_documento Is
    Select e.no_cia,
           e.centro,
           e.tipo_doc,
           e.periodo,
           e.ruta,
           e.no_docu,
           e.fecha,
           e.no_prove        proveedor,
           e.orden_compra,
           e.tipo_refe,
           e.no_refe,
           e.moneda_refe_cxp moneda,
           e.observ1,
           e.tipo_cambio,
           p.codigo_tercero,
           e.rowid           rowid_me
      From arinme e, arcpmp p
     Where e.no_cia = cia_p
       And e.no_docu = docu_p
       And e.tipo_doc = tipo_p
       And e.estado = 'P'
          -- outer join para el caso de que el movimiento no tenga proveedor.
       And p.no_cia(+) = e.no_cia
       And p.no_prove(+) = e.no_prove;
  --
  -- Lineas de compras
  Cursor c_lineas_doc Is
    Select l.linea_ext,
           l.linea,
           l.bodega,
           l.no_arti,
           nvl(l.unidades, 0) unidades,
           nvl(l.monto, 0) monto,
           nvl(l.monto_dol, 0) monto_dol,
           (nvl(l.monto, 0) - nvl(l.descuento_l, 0) + nvl(l.impuesto_l, 0)) neto,
           (nvl(l.monto2, 0) - nvl(l.descuento_l, 0) + nvl(l.impuesto_l, 0)) neto2,
           nvl(l.impuesto_l, 0) imp_ventas,
           nvl(l.impuesto_l_incluido, 0) imp_incluido,
           nvl(l.descuento_l, 0) descuento_l,
           l.no_orden,
           l.linea_orden,
           d.grupo,
           d.costo_estandar,
           a.costo_uni,
           a.ult_costo,
           nvl(a.afecta_costo, 'N') afecta_costo,
           l.precio_venta,
           l.monto2
      From arinda d, arinml l, arinma a
     Where l.no_cia = cia_p
       And l.no_docu = docu_p
       And l.tipo_doc = tipo_p
       And l.no_cia = d.no_cia
       And l.no_arti = d.no_arti
          -- join con arinma
       And a.no_cia = l.no_cia
       And a.bodega = l.bodega
       And a.no_arti = l.no_arti;
  --
  -- Obtiene lineas de lotes para cada linea de articulo
  Cursor c_lotes(pCia   Varchar2,
                 pTipo  Varchar2,
                 pDocu  Varchar2,
                 pLinea Number,
                 pCosto Number) Is
    Select no_lote,
           nvl(unidades, 0) unidades,
           nvl(unidades * pCosto, 0) monto,
           ubicacion,
           fecha_vence
      From arinmo
     Where no_cia = pCia
       And no_docu = pDocu
       And tipo_doc = pTipo
       And linea = pLinea;
  --
  -- Obtiene los impuestos asociados al documento
  Cursor c_imp(pCia varchar2, pDocu varchar2, pLinea number) Is
    Select clave, codigo_tercero, id_sec, sum(monto) monto_imp
      From arinmli
     Where no_cia = pcia
       And no_docu = pdocu
       And linea = plinea
     Group By clave, codigo_tercero, id_sec;

  -- Verifica si el Articulo tiene Secuencia para actualizar en ARINDA
  Cursor c_control_sec(particulo varchar2) Is
    Select 'X'
      From arinda
     Where no_cia = cia_p
       and no_arti = particulo
       and control_secuencia = 'S';

  --MNAVARRETE 05/11/2009 se incluye para recuperar centro de costo de la bodega
  CURSOR c_centroCosto IS
    Select c.centro_costo
      From arinml l, arinda d, grupos g, arincc c
     Where l.no_cia = cia_p
       and l.no_docu = docu_p
       and l.no_cia = d.no_cia
       and l.no_arti = d.no_arti
       and l.no_cia = g.no_cia
       and d.grupo = g.grupo
       and g.no_cia = c.no_cia
       and g.grupo = c.grupo
       and c.bodega = l.bodega
       and rownum = 1;

  -- llindao: valida Numeros de Series
  CURSOR C_PRODUCTO_SERIE IS
    SELECT A.NO_ARTI, A.LINEA, A.UNIDADES, COUNT(B.SERIE) CANTIDAD
      FROM ARINML A, INV_DOCUMENTO_SERIE B, ARINDA C
     WHERE A.NO_ARTI = C.NO_ARTI
       AND A.NO_CIA = C.NO_CIA
       AND A.NO_DOCU = B.ID_DOCUMENTO(+)
       AND A.LINEA = B.LINEA(+)
       AND A.NO_CIA = B.COMPANIA(+)
       AND A.NO_DOCU = docu_p
       AND A.NO_CIA = cia_p
       AND C.IND_REQUIERE_SERIE = 'S'
     GROUP BY A.NO_ARTI, A.LINEA, A.UNIDADES
    HAVING((A.UNIDADES != COUNT(B.SERIE)) OR (A.UNIDADES + COUNT(B.SERIE) = 0));
  --
  Lr_ProductoSerie C_PRODUCTO_SERIE%ROWTYPE := NULL;

  -- vmmoreno: validacion de ordenes de compras que no valide la diferencia entre unidades ingresadas y número de series.
  Cursor C_Parametro_Serie is
    SELECT A.PARAMETRO
      FROM NAF47_TNET.GE_PARAMETROS A, NAF47_TNET.GE_GRUPOS_PARAMETROS B
     WHERE A.ID_EMPRESA = B.ID_EMPRESA
       AND A.ID_APLICACION = B.ID_APLICACION
       AND A.ID_GRUPO_PARAMETRO = B.ID_GRUPO_PARAMETRO
       AND A.ID_EMPRESA = cia_p
       AND A.ID_APLICACION = 'IN'
       AND A.PARAMETRO = tipo_p
       AND A.ESTADO = 'A';

  --
  vx        Char(1);
  vencontro Boolean;
  rd        c_documento%rowtype;
  error_proceso exception;
  vtime_stamp      date;
  rper             inlib.periodo_proceso_r;
  vfound           boolean;
  vafecta_costo    boolean;
  vmonto_neto      number;
  vmonto_neto2     number := 0; --FEM
  vmonto_lote      number;
  vsigno_compra    number(2);
  vtmov_ctaInv     arindc.tipo_mov%type;
  vtmov_ctaImp     arindc.tipo_mov%type;
  vtmov_ctaProve   arindc.tipo_mov%type;
  vcta_inv         arindc.cuenta%type;
  vcta_prove       arindc.cuenta%type; -- cta del proveedor o del documento (si mov.no tiene prov)
  vmonto_cta_prove arindc.monto%type;
  vmonto_dc        arindc.monto%type;
  vmonto_dc_dol    arindc.monto_dol%type;
  vcosto_unit_ml   arinma.costo_uni%type := 0;
  vcosto2_unit_ml  arinma.costo2%type := 0;
  vcc_cero         arincc.centro_costo%TYPE;
  vcc_compra       arincc.centro_costo%TYPE;
  vccentro         arincc.centro_costo%TYPE;
  vtercero_dc      arcpmp.codigo_tercero%type;
  vcta_imp         arcgms.cuenta%type;

  vmov_tot  number := 0;
  vmov_tot2 number := 0;

  v_parametro_serie varchar2(3);

BEGIN
  ---
  moneda.inicializa_datos_redondeo(cia_p);
  ---

  -- llindao: se valida el numeros de serie

  --vmmoreno
  /*Se parametriza el tipo de documento Compras para que que no valide cuando existe diferencias entre unidades ingresadas y número de series.
  22-04-2021*/

  IF C_PARAMETRO_SERIE%ISOPEN THEN
    CLOSE C_PARAMETRO_SERIE;
  END IF;
  OPEN C_PARAMETRO_SERIE;
  FETCH C_PARAMETRO_SERIE
    INTO v_parametro_serie;
  CLOSE C_PARAMETRO_SERIE;
  --
  IF v_parametro_serie <> tipo_p THEN
    IF C_PRODUCTO_SERIE%ISOPEN THEN
      CLOSE C_PRODUCTO_SERIE;
    END IF;
    OPEN C_PRODUCTO_SERIE;
    FETCH C_PRODUCTO_SERIE
      INTO Lr_ProductoSerie;
  
    IF C_PRODUCTO_SERIE%FOUND THEN
      msg_error_p := 'Existe productos con diferencias entre unidades ingresadas y Numeros de series, favor revisar...';
      Raise Error_proceso;
    END IF;
    CLOSE C_PRODUCTO_SERIE;
  END IF;
  --

  vtime_stamp := time_stamp_p;
  vcc_cero    := centro_costo.rellenad(cia_p, '0');
  If interface_p = 'IM' and cta_docu_p is null then
    msg_error_p := 'El tipo de documento NO tiene definida cuenta contable...';
    Raise Error_proceso;
  End If;
  --
  -- Busca centro de costo para cuenta de Compras
  Open c_centroCosto;
  Fetch c_centroCosto
    Into vcc_compra;
  Close c_centroCosto;

  -- Busca el documento a actualizar
  Open c_documento;
  Fetch c_documento
    Into rd;
  vfound := c_documento%Found;
  Close c_documento;
  If Not vfound Then
    msg_error_p := 'No fue posible encontrar la transaccion: ' || docu_p;
    Raise error_proceso;
  End If;
  --
  -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);

  If vfound Then
    Null;
  End If;
  --
  -- define el signo de la actualizacion y la forma del detalle contable
  If movimi_p = 'E' Then
    vsigno_compra  := 1;
    vtmov_ctaInv   := 'D';
    vtmov_ctaImp   := 'D';
    vtmov_ctaProve := 'C';
  Else
    vsigno_compra  := -1;
    vtmov_ctaInv   := 'C';
    vtmov_ctaImp   := 'C';
    vtmov_ctaProve := 'D';
  End If;
  --
  vcta_prove       := Null;
  vmonto_cta_prove := 0;
  --
  If interface_p = 'IM' Then
    --
    -- Si el movimiento es de compras en importaciones , se obtiene la cuenta contable que se
    -- asocio al documento . Esta cuenta ira como contracuenta de la de inventario
    vcta_prove := cta_docu_p;
  Elsif rd.proveedor is null Then
    --
    -- Si el movimiento es de compra pero sin proveedor, utiliza la cuenta de contrapartida del
    -- tipo de documento.
    If rd.moneda = 'P' Then
      vcta_prove := cta_docu_p;
    Else
      -- rd.moneda = 'D'
      vcta_prove := cta_docu_dol_p;
    End If;
  
    If vcta_prove is null Then
      msg_error_p := 'Falta definir la cuenta de contrapartida para el documento ' ||
                     rd.tipo_refe;
      Raise error_proceso;
    End If;
  Else
    --
    -- Si el movimiento es de compras desde inventario, se obtiene la cuenta
    -- contable del proveedor (cxp) que ira como contracuenta de inventario
    --
    vcta_prove := cta_docu_p;
  End If;
  --
  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me,
                      rper.mes_proce,
                      rper.semana_proce,
                      rper.indicador_sem);
  --
  -- procesa las lineas de la compras.
  For i in c_lineas_doc Loop
    ---
    If i.no_arti is not null Then
      --- Actualiza arinda dias de entrega del articulo
      inact_articulo(cia_p, i.no_arti, rd.orden_compra, rd.fecha);
      -- Actualiza Arinda en caso de que el articulo tenga un control secuencia = 'S'
      Open C_control_sec(i.no_arti);
      fetch c_control_sec
        into vx;
      vencontro := c_control_sec%found;
      close c_control_sec;
      If vencontro Then
        INACT_CONTROL_SECUENCIA(cia_p, i.no_orden, i.no_arti);
      End if;
    End If;
    ---
  
    -- Trae la cuenta de inventario para la clase y bodega que se esta
    -- procesando en esta linea.
    vcta_inv := Null;
    If i.no_arti is not null Then
      If not
          inlib.trae_cuenta_inventario(cia_p, i.grupo, i.bodega, vcta_inv) Then
        msg_error_p := 'Falta definir la cuenta de inventario, ' ||
                       'para bodega: ' || i.bodega || '  grupo: ' ||
                       i.grupo;
        Raise error_proceso;
      End If;
    End If;
  
    -- Pregunta si el articulo tiene el indicador de afecta el costo,
    -- si el articulo no pertenece al inventario entonces por defecto
    -- si afecta.
    If i.no_arti is not null Then
      vafecta_costo := (i.afecta_costo = 'S');
    Else
      vafecta_costo := True;
    End If;
  
    -- El monto a generar a la cuenta de inventario depende si el articulo
    -- afecta o no el costo.
    If vafecta_costo Then
      vmonto_neto  := i.neto;
      vmonto_neto2 := i.neto2;
    Else
      vmonto_neto  := i.neto - i.imp_ventas - i.imp_incluido;
      vmonto_neto2 := i.neto2 - i.imp_ventas - i.imp_incluido;
    End If;
  
    vmov_tot  := vmonto_neto + vmov_tot;
    vmov_tot2 := vmonto_neto2 + vmov_tot2;
  
    -- calcula el costo unitario para el documento
    --
    If i.unidades != 0 Then
      vcosto_unit_ml  := nvl(vmonto_neto, 0) / nvl(i.unidades, 0);
      vcosto2_unit_ml := nvl(vmonto_neto2, 0) / nvl(i.unidades, 0);
    else
      -- determina el costo unitario del articulo
      vcosto_unit_ml  := articulo.costo(cia_p, i.no_arti, i.bodega);
      vcosto2_unit_ml := articulo.costo2(cia_p, i.no_arti, i.bodega);
    End If;
  
    -- acumula el movimiento a la cuenta del proveedor o puente
    -- (el impuesto esta incluido)
    vmonto_cta_prove := vmonto_cta_prove + nvl(i.neto, 0);
    vmonto_dc_dol    := moneda.redondeo(vmonto_neto / rd.tipo_cambio, 'D');
    --
  
    If cuenta_contable.acepta_tercero(rd.no_cia, vcta_inv) Then
      vTercero_Dc := rd.codigo_tercero;
    Else
      vTercero_Dc := Null;
    End If;
    --
    If cuenta_contable.acepta_cc(rd.no_cia, vcta_inv) Then
      vccentro := vcc_compra;
    Else
      vccentro := vcc_cero;
    End if;
    --
    INinserta_dc(rd.no_cia,
                 rd.centro,
                 rd.tipo_doc,
                 rd.no_docu,
                 vtmov_ctaInv,
                 vcta_inv,
                 vmonto_neto,
                 vccentro,
                 vmonto_dc_dol,
                 rd.tipo_cambio,
                 vTercero_Dc);
    --
    If not vafecta_costo Then
    
      -- Genera el detalle contable por Impuestos
      For ri in c_imp(rd.no_cia, rd.no_docu, i.linea) Loop
        ---
        vmonto_dc     := ri.monto_imp;
        vmonto_dc_dol := moneda.redondeo(ri.monto_imp / rd.tipo_cambio, 'D');
        vCta_Imp      := Impuesto.cta_contable(rd.no_cia,
                                               ri.clave,
                                               ri.id_sec);
        ---
        If cuenta_contable.acepta_tercero(rd.no_cia, vcta_imp) Then
          vTercero_Dc := ri.codigo_tercero;
        Else
          vTercero_Dc := Null;
        End If;
        --
        If cuenta_contable.acepta_cc(rd.no_cia, vcta_imp) Then
          vccentro := vcc_compra;
        Else
          vccentro := vcc_cero;
        End if;
        --
        INinserta_dc(rd.no_cia,
                     rd.centro,
                     rd.tipo_doc,
                     rd.no_docu,
                     vtmov_ctaImp,
                     vcta_imp,
                     vmonto_dc,
                     vccentro,
                     vmonto_dc_dol,
                     rd.tipo_cambio,
                     vTercero_dc);
      End Loop;
    End If;
    --
    --
    If i.no_arti is not null Then
    
      -- Inserta en ARINMN la linea que se esta procesando
      Ininserta_mn(rd.no_cia,
                   rd.centro,
                   rd.tipo_doc,
                   rd.no_docu,
                   rd.periodo,
                   rper.mes_proce,
                   rper.semana_proce,
                   rper.indicador_sem,
                   rd.ruta,
                   i.linea_ext,
                   i.bodega,
                   i.no_arti,
                   rd.fecha,
                   i.unidades,
                   i.monto,
                   i.descuento_l,
                   rd.tipo_refe,
                   rd.no_refe,
                   rd.proveedor,
                   vcosto_unit_ml,
                   vtime_stamp,
                   '000000000',
                   'N',
                   i.precio_venta,
                   vmonto_neto2,
                   vcosto2_unit_ml);
    
      /**** NOTA IMPORTANTE: El orden de los procedimientos siempre va a ser:
            INCOSTO_UNI (SI ES ENTRADA DE COMPRAS, ENTRADA REORDENAMIENTO, ENTRADA IMPORTACION)
            INACTUALIZA_SALDOS_ARTICULOS (PARA TODOS LOS CASOS)
            INCOSTO_ACTUALIZA (PARA TODOS LOS CASOS)
            ANR 16/06/2010
      ****/
    
      If movimi_p = 'E' Then
      
        UPDATE arinma
           SET activo = 'S', fec_u_comp = rd.fecha ---- Actualiza fecha de ultima compra, esta parte es parecida a como se la hace en Importaciones ANR 16/06/2009
         WHERE no_cia = rd.no_cia
           AND bodega = i.bodega
           AND no_arti = i.no_arti;
      
        ---- costo unitario se actualiza si es una entrada de compra local
        INcosto_Uni(rd.no_cia,
                    i.bodega,
                    i.no_arti,
                    i.unidades,
                    vcosto_unit_ml,
                    vcosto2_unit_ml,
                    msg_error_p);
        If msg_error_p is not null Then
          Raise error_proceso;
        End If;
      
      End If;
    
      --- Actualiza el stock en ARINMA con las unidades ingresadas
      INactualiza_saldos_articulo(rd.no_cia,
                                  i.bodega,
                                  i.no_arti,
                                  'COMPRA',
                                  (i.unidades * vsigno_compra),
                                  (vmonto_neto * vsigno_compra),
                                  Null,
                                  msg_error_p);
    
      If msg_error_p is not null Then
        Raise error_proceso;
      End If;
    
      --- Actualiza el stock valuado del inventario en base a los costos calculados
    
      INCOSTO_ACTUALIZA(rd.no_cia, i.no_arti);
    
      If rd.proveedor is not null Then
        -- Actualiza el Historico de compras por proveedor.
        Update arinho
           Set unidades = nvl(unidades, 0) + (i.unidades * vsigno_compra),
               monto    = nvl(monto, 0) + (vmonto_neto * vsigno_compra)
         Where no_cia = rd.no_cia
           And centro = rd.centro
           And ano = rper.ano_proce
           And semana = rper.semana_proce
           And ind_sem = rper.indicador_sem
           And no_prove = rd.proveedor
           And no_arti = i.no_arti;
        --
        If Sql%NotFound Then
          Insert Into arinho
            (no_cia,
             centro,
             ano,
             semana,
             ind_sem,
             no_prove,
             no_arti,
             unidades,
             monto)
          Values
            (rd.no_cia,
             rd.centro,
             rper.ano_proce,
             rper.semana_proce,
             rper.indicador_sem,
             rd.proveedor,
             i.no_arti,
             (i.unidades * vsigno_compra),
             (vmonto_neto * vsigno_compra));
        End If;
      End If; --Historico de compras por proveedor.
    
    End If;
    --
    -- Procesa lotes
    --
    For j in c_lotes(rd.no_cia,
                     rd.tipo_doc,
                     rd.no_docu,
                     i.linea,
                     vcosto_unit_ml) LOOP
      vmonto_lote := moneda.redondeo(j.monto, 'P');
      UPDATE arinlo
         SET saldo_unidad   = nvl(saldo_unidad, 0) +
                              (j.unidades * vsigno_compra),
             saldo_contable = 0,
             saldo_monto    = 0
       WHERE no_cia = rd.no_cia
         AND bodega = i.bodega
         AND no_arti = i.no_arti
         AND no_lote = j.no_lote;
      --
      IF sql%rowcount = 0 THEN
        INSERT INTO arinlo
          (no_cia,
           bodega,
           no_arti,
           no_lote,
           ubicacion,
           saldo_unidad,
           saldo_contable,
           saldo_monto,
           salida_pend,
           costo_lote,
           proceso_toma,
           exist_prep,
           costo_prep,
           fecha_entrada,
           fecha_vence,
           fecha_fin_cuarentena)
        VALUES
          (rd.no_cia,
           i.bodega,
           i.no_arti,
           j.no_lote,
           j.ubicacion,
           j.unidades,
           0,
           0,
           0,
           0,
           'N',
           null,
           null,
           rd.fecha,
           j.fecha_vence,
           null);
      END IF;
      --
      -- Inserta en ARINMT la linea que se esta procesando
      Insert Into arinmt
        (no_cia,
         centro,
         tipo_doc,
         ano,
         ruta,
         no_docu,
         no_linea,
         bodega,
         no_arti,
         no_lote,
         unidades,
         venta,
         descuento)
      values
        (rd.no_cia,
         rd.centro,
         rd.tipo_doc,
         rd.periodo,
         rd.ruta,
         rd.no_docu,
         i.linea_ext,
         i.bodega,
         i.no_arti,
         j.no_lote,
         j.unidades,
         0,
         0);
    End Loop; -- lotes de las lineas
  --
  End Loop; -- Lineas del documento
  --
  -- genera movimiento contable (cuenta del proveedor o cuenta puente importaciones)
  -- Inserta la contrapartida de la cuenta de inventario
  vmonto_dc_dol := moneda.redondeo(vmonto_cta_prove / rd.tipo_cambio, 'D');

  If cuenta_contable.acepta_tercero(rd.no_cia, vcta_prove) Then
    vTercero_Dc := rd.codigo_tercero;
  Else
    vTercero_Dc := Null;
  End If;
  --
  If cuenta_contable.acepta_cc(rd.no_cia, vcta_prove) Then
    vccentro := vcc_compra;
  Else
    vccentro := vcc_cero;
  End if;
  --
  ininserta_dc(rd.no_cia,
               rd.centro,
               rd.tipo_doc,
               rd.no_docu,
               vtmov_ctaProve,
               vcta_prove,
               vmonto_cta_prove,
               vccentro,
               vmonto_dc_dol,
               rd.tipo_cambio,
               vtercero_dc);
  --

  --- Genera el registro a CxP en estado pendiente ANR 26/08/2010

  /* llindao: No debe generar Factura, esta se ingresa manualmente
   INact_compra_cxp (cia_p, tipo_p, docu_p, msg_error_p);
  
       If msg_error_p is not null Then
         Raise error_proceso;
       End If;
  */

  -- Actualiza el estado del documento
  Update arinme
     Set estado = 'D', mov_tot = vmov_tot, mov_tot2 = vmov_tot2
   Where rowid = rd.rowid_me;

  Update arinmeh
     SET mov_tot = vmov_tot, mov_tot2 = vmov_tot2
   where no_cia = cia_p
     and no_docu = docu_p;
  --

  --- Actualiza informacion en modulo de compras
  If rd.orden_compra is not null Then
    INACT_ORDEN_COMPRA(rd.no_cia, rd.proveedor, rd.orden_compra);
  end if;

Exception
  When error_proceso Then
    msg_error_p := NVL(msg_error_p, 'error_proceso en Actualiza compras');
    return;
  When Others Then
    msg_error_p := 'INACT_COMPRA : ' || sqlerrm;
    return;
End;