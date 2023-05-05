CREATE OR REPLACE package            IN_PROCESAR_MIGRACION is

  -- Author  : LLINDAO
  -- Created : 20/09/2011 11:24:07
  -- Purpose :

  -- Public type declarations
  --type <TypeName> is <Datatype>;

  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

  procedure IN_VENTAS ( Pv_NoCia        in     VARCHAR2,
                        Pv_NoCentro     in     VARCHAR2,
                        Pd_FechaProceso in     DATE,
                        Pv_MensajeError in out VARCHAR2 );

end IN_PROCESAR_MIGRACION;
/


CREATE OR REPLACE package body            IN_PROCESAR_MIGRACION is
  procedure Procesar_encabezado( pCia          in arinme.No_Cia%type,
                                 pCentro       in arinme.centro%type,
                                 pTipo         in arinme.tipo_doc%type,
                                 pdocu         in arinme.No_Docu%type,
                                 pno_fisico    in arinme.no_fisico%type,
                                 pserie_fisico in arinme.serie_fisico%type,
                                 pPeriodo      in arinme.Periodo%type,
                                 pObserv       in arinme.observ1%type,
                                 pTC           in arinme.tipo_Cambio%type,
                                 pTipoRef      in arinme.Tipo_Refe%type,
                                 pno_refe      in arinme.no_refe%type,
                                 pserie_refe   in arinme.serie_refe%type,
                                 pno_docu_refe in arinme.no_docu_refe%type,
                                 pTotal        in arinme.mov_tot%type,
                                 pTotal2       in arinme.mov_tot%type,
                                 Pv_error      out varchar2) IS

    --
    Cursor c_dia_proceso is
      Select DIA_PROCESO
        from ARINCD
       Where NO_CIA = pCia --:global.compania
         and CENTRO = pCentro; --:global.centro;
    --
    vd_dia_proceso  arincd.dia_proceso%type;

  begin
    -- Se obtiene el dia de Proceso
    Open  c_dia_proceso;
    Fetch c_dia_proceso into vd_dia_proceso;
    Close c_dia_proceso;

    -- registra el encabezado del movimiento
    insert into arinme
              ( No_Cia,       Centro,    Tipo_Doc,    Periodo,
                Ruta,         No_Docu,   Fecha,       Fecha_aplicacion,
                Estado,       Observ1,   Tipo_Cambio, No_Fisico,
                Serie_Fisico, Tipo_Refe, no_refe,     serie_refe,
                no_docu_refe, usuario,   mov_tot,     mov_tot2,
                origen)
       values ( pCia,          pCentro,  pTipo,          pPeriodo,
                '0000',        pDocu,    vd_dia_proceso, SYSDATE, -- to_char(pFecha,'DD/MM/YYYY hh24:mm:ss'),
                'P',           pobserv,  pTC,            pno_fisico,
                pserie_fisico, pTipoRef, pno_refe,       pserie_refe,
                pno_docu_refe, user,     pTotal,         pTotal2,
                'MI');

  exception
    when others then
      Pv_Error := 'Error al crear cabecera. Tipo doc: '||PTipo||' Docu: '||PDocu||' '||sqlerrm;
  end Procesar_encabezado;

  -- ============================================== --
  procedure Procesar_Linea (pno_cia     in varchar2,
                            pcentro     in varchar2,
                            pperiodo    in varchar2,
                            ptipo_doc   in varchar2,
                            pno_docu    in varchar2,
                            pLinea      in number,
                            pArticulo   in varchar2,
                            pUnidades   in number,
                            pTotal      in number,
                            pTotal2     in number,
                            pTotal_dol  in number,
                            pTotal2_dol in number,
                            ptipocambio in number,
                            Pv_Error    out varchar2) is

    Cursor c_bod_principal is
      Select codigo from arinbo
       where no_cia = pno_cia--:global.compania
         and centro = pcentro--:global.centro
         and principal = 'S';

    Cursor  C_clase_categ (v_arti varchar2) is
      Select clase, categoria from arinda
       Where no_cia = pno_cia--:global.compania
         and no_arti = v_arti;
    --
    vruta             arinml.ruta%type := '0000';
    vv_cod_bodega     arinbo.codigo%type;
    vv_cod_arti       arinda.no_arti%type;
    --
    vclase            arinda.clase%type;
    vcategoria        arinda.categoria%type;

  begin

    Open  C_clase_categ(pArticulo);
    Fetch C_clase_categ into vclase,vcategoria;
    Close C_clase_categ;

    Open  c_bod_principal;
    Fetch c_bod_principal into vv_cod_bodega;
    Close c_bod_principal;
    --
    insert into arinml
              ( no_cia,    centro,      tipo_doc,    periodo,
                ruta,      no_docu,     linea,       linea_ext,
                bodega,    no_arti,     unidades,    monto,
                monto_dol, tipo_cambio, ind_iv,      clase,
                categoria, time_stamp,  descuento_l, impuesto_l,
                monto2,    monto2_dol )
       values ( pno_cia,         pcentro,     ptipo_doc, pperiodo,
                vruta,           pno_docu,    pLinea,    pLinea,
                vv_cod_bodega,   pArticulo,   pUnidades, abs(pTotal),
                abs(ptotal_dol), ptipocambio, 'N',       vclase,
                vcategoria,       sysdate,     0,         0,
                abs(ptotal2),    abs(ptotal2_dol));
  exception
    when others then
      Pv_Error := 'Error al crear detalle. Tipo doc: '||PTipo_doc||' Docu: '||Pno_Docu||' Articulo: '||vv_cod_arti||' '||sqlerrm;
  end Procesar_Linea;

  -- =========================== --
  -- Proceso de lotes por lineas --
  -- =========================== --
  procedure procesar_linea_lote( ciap     in varchar2,
                                 cenp     in varchar2,
                                 tdocp    in varchar2,
                                 perp     in varchar2,
                                 rutap    in varchar2,
                                 docup    in varchar2,
                                 lineap   in number,
                                 lotep    in varchar2,
                                 unip     in number,
                                 ubicp    in varchar2,
                                 fechavp  in date,
                                 Pv_Error out varchar2 ) is
  begin
    -- Registra la linea del lote en el movimiento del mes (ARINMO)
    Insert into arinmo
              ( no_cia, centro,  tipo_doc, periodo,
                ruta,   no_docu, linea,    no_lote,
                unidades, monto, ubicacion, fecha_vence )
        values( ciap,  cenp,  tdocp,  perp,
                rutap, docup, lineap, lotep,
                unip,  0,     ubicp,  fechavp );---montop, valores se guardan con cero  ANR 01/05/2009
  exception
    when others then
      Pv_Error := 'Error al crear detalle de lote. Tipo doc: '||tdocp||' Docu: '||docup||' lote: '||lotep||' '||sqlerrm;
  end procesar_linea_lote;

  -- ================== --
  -- procesar por lotes --
  -- ================== --
  procedure procesar_lote ( pno_cia        Varchar2,
                            pcentro        Varchar2,
                            ptipo_doc      Varchar2,
                            pbodega        Varchar2,
                            pno_docu       Varchar2,
                            pperiodo       Varchar2,
                            pruta          Varchar2,
                            pLinea         Varchar2,
                            particulo      Varchar2,
                            pcantidad      Number,
                            pcantidad_desp in out number,
                            perror         in out varchar2) IS

    Cursor C_Disponible_Total (c_bodega varchar2, c_articulo varchar2)is
      Select Sum(nvl(saldo_unidad, 0) - nvl(salida_pend, 0)) Disponible
        from arinlo
       where no_cia = pno_cia --:global.compania
         and bodega   = c_bodega
         and no_arti  = c_articulo
         and nvl(saldo_unidad, 0) - nvl(salida_pend, 0) > 0
         and fecha_vence > trunc(sysdate)
       order by fecha_vence;

    Cursor C_Disponible_Lote (c_bodega varchar2, c_articulo varchar2)is
      Select no_lote,  ubicacion,  fecha_vence,  saldo_unidad, nvl(costo_lote,0) costo_lote,
             nvl(saldo_unidad, 0) - nvl(salida_pend, 0) disponible
        from arinlo
       where no_cia = pno_cia --:global.compania
         and bodega   = c_bodega
         and no_arti  = c_articulo
         and nvl(saldo_unidad, 0) - nvl(salida_pend, 0) > 0
         and fecha_vence > trunc(sysdate)
       order by fecha_vence;
    --
    v_cant_disponible arinmo.unidades%type;  -- Cantidad total de articulos en los lotes
    v_cant_canjear    arinmo.unidades%type;  -- Cantidad de articulos por asignar
    v_cantidad_desp   arinmo.unidades%type;  -- Cantidad de articulos ya asignados para luego
    v_unid_asigna     arinmo.unidades%type;  -- Cantidad de articulos asociados a cada lote ARINMO

  begin
    /* Eleccion de lotes a utilizar y preasignacion de acuerdo al saldo existente
     Saldo Disponible(Saldo_real - Pendiente) de articulos de una bodega  */
    v_cant_canjear := pcantidad;
    --
    Open  C_Disponible_Total(pbodega, particulo);
    Fetch C_Disponible_Total into v_cant_disponible;
    Close C_Disponible_Total;
    v_cant_disponible := nvl(v_cant_disponible,0);

    IF nvl(v_cant_disponible,0) <= 0  Then
      perror := 'No existe stock para esta operacion';
    End if;

    IF nvl(v_cant_disponible,0) < nvl(pcantidad,0)  Then
      perror := 'Sin stock suficiente, no se procesa el ariculo: '|| particulo ;
    End if;

    IF (perror is null) and ((v_cant_disponible >= pcantidad)) Then
      v_cant_canjear := pcantidad; -- Variable para ir disminuyendo las unidades ya asignadas por lote
      v_cantidad_desp := 0;

      For i in C_Disponible_Lote(pbodega, particulo)  Loop
        -- Verifico cantidad a asignar de acuerdo a lo disponible por lote
        -- Verifico cantidad a asignar de acuerdo a lo disponible por lote
        If i.disponible  >=  v_cant_canjear   Then
          v_unid_asigna := v_cant_canjear;
          v_cant_canjear := nvl(v_cant_canjear,0) - nvl(v_unid_asigna,0);
        End if;

        If i.disponible  <   v_cant_canjear   Then
          v_unid_asigna := i.disponible;
          v_cant_canjear := nvl(v_cant_canjear,0) - nvl(v_unid_asigna,0);
        End if;

        If v_unid_asigna > 0 Then
          --Mov. Salida Lotes
          insert into arinmo
                    ( no_cia,    centro,  tipo_doc,    periodo,
                      ruta,      no_docu, linea,       no_lote,
                      unidades,  monto,   descuento_l, imp_ventas_l,
                      ubicacion, fecha_vence)
             values ( pno_cia,            pcentro,  ptipo_doc, pperiodo,
                      pruta,              pno_docu, pLinea,    i.no_lote,
                      abs(v_unid_asigna), 0,        0,         0,
                      i.ubicacion,        i.fecha_vence);---v_monto,    EN MONTOS EL VALOR EN LOTES VA EN CERO ANR 18/06/2009

          update arinlo
             set salida_pend = nvl(salida_pend,0) + abs(v_unid_asigna)
           where no_cia  = pno_cia--:global.compania
             and bodega  = pbodega
             and no_arti = particulo
             and no_lote = i.no_lote;

          v_cantidad_desp := nvl(v_cantidad_desp,0) + nvl(v_unid_asigna,0);
        End if;

        If v_cant_canjear <= 0  then
          exit;
        end If;
      End Loop;
    End if;   -- (perror is null)
    pcantidad_desp := nvl(v_cantidad_desp,0);
  end procesar_lote;

  -- ============================================= --
  -- Verifica la existencia de articulos en Arinda --
  -- ============================================= --
  procedure IN_VENTAS ( Pv_NoCia        in     VARCHAR2,
                        Pv_NoCentro     in     VARCHAR2,
                        Pd_FechaProceso in     DATE,
                        Pv_MensajeError in out VARCHAR2 ) is

    Cursor C_existe_articulo is --(vFecha date) is
      select decode(tipo_doc, '01','Tipo doc. Factura de la transaccion  ',
                              '02','Tipo doc. Nota de Venta de la transaccion  ',
                              '03','Tipo doc. Devolucion de la transaccion  ') || no_docu
                              ||'  en la linea  '|| linea  ||'  articulo  '|| no_arti
        from migra_arinml
       where no_cia = Pv_NoCia    --:global.compania
         and centro = Pv_NoCentro --:global.centro
         and no_arti in ( ( select no_arti
                              from migra_arinml
                             where no_cia = Pv_NoCia --:global.compania
                               and no_docu in (select no_docu
                                                 from migra_arinme
                                                Where no_cia = Pv_NoCia    --:global.compania
                                                  and centro = Pv_NoCentro --:global.centro
                                                  and to_char(fecha,'yyyymmdd') = Pd_FechaProceso --vFecha
                                                  and estado = 'P')
                             minus
                            select codigo_anterior
                              from arinda
                             where no_cia = Pv_NoCia --:global.compania
                               and codigo_anterior in ( select no_arti
                                                          from migra_arinml
                                                         where no_cia = Pv_NoCia--:global.compania
                                                           and no_docu in (select no_docu
                                                                             from migra_arinme
                                                                             where no_cia = Pv_NoCia    --:global.compania
                                                                               and centro = Pv_NoCentro --:global.centro
                                                                               and to_char(fecha,'yyyymmdd') = Pd_FechaProceso--vfecha
                                                                               and estado = 'p'))) )
                                                           and rownum = 1
                                                         order by no_docu, linea;

    -- Tipo de documento de 'Despacho de Factura DF' = '01'
    Cursor C_cabecera_despacho (vFecha date) is
      Select no_cia, centro, tipo_doc, periodo, ruta, no_docu, estado,
             fecha, no_fisico, serie_fisico, conduce, observ1,
             imp_ventas, imp_incluido, imp_especial, no_prove,
             tipo_refe, no_refe, serie_refe, no_docu_refe, descuento,
             mov_tot, tot_art_iv, moneda_refe_cxp, tipo_cambio,
             monto_digitado_compra,
             monto_bienes,
             monto_importac,
             monto_serv,
             origen,
             tipo_doc_d,            n_docu_d,
             fecha_ent, hora_ent,
             ind_completa, orden_compra,
             fec_emision_despacho, fec_llegada_despacho,
             transporte,
             nota_credito,            valor_ncredito,
             art_rotos,
             comentarios,
             no_pedido_cobol,
             bodega_local,
             ind_transferido,
             respon_stand,
             usuario,
             impuesto,
             descuento_c,
             numero_solicitud,
             fecha_aplicacion,
             emple_solic,
             c_costo_emplesol,
             no_cliente,
             vendedor,
             aplica_guia_rem,
             reclamo_proveedor,
             mov_tot2
        from migra_arinme
       Where no_cia = Pv_NoCia --:global.compania
         and centro = Pv_NoCentro --:global.centro
         and trunc(fecha) <= Pd_FechaProceso-- vFecha
         and tipo_doc in ('01')
         and estado = 'P'
        ORDER BY NO_DOCU DESC ;

    -- Tipo de documento de 'Despacho de Nota de Venta = '02'
    Cursor C_cabecera_despachoN (vFecha date) is
      Select no_cia, centro, tipo_doc, periodo, ruta, no_docu, estado,
             fecha, no_fisico, serie_fisico,
             conduce, observ1,
             imp_ventas,
             imp_incluido,
             imp_especial,
             no_prove, tipo_refe, no_refe, serie_refe, no_docu_refe,
             descuento,
             mov_tot,
             tot_art_iv,
             moneda_refe_cxp,
             tipo_cambio,
             monto_digitado_compra,
             monto_bienes,
             monto_importac,
             monto_serv,
             origen,
             tipo_doc_d, n_docu_d,
             fecha_ent, hora_ent,
             ind_completa,
             orden_compra,
             fec_emision_despacho, fec_llegada_despacho,
             transporte,
             nota_credito, valor_ncredito,
             art_rotos,
             comentarios,
             no_pedido_cobol,
             bodega_local,
             ind_transferido,
             respon_stand,
             usuario,
             impuesto,
             descuento_c,
             numero_solicitud,
             fecha_aplicacion,
             emple_solic,
             c_costo_emplesol,
             no_cliente,
             vendedor,
             aplica_guia_rem,
             reclamo_proveedor,
             mov_tot2
        from migra_arinme
       Where no_cia = Pv_NoCia --:global.compania
         and centro = Pv_NoCentro --:global.centro
         and trunc(fecha) <= Pd_FechaProceso --vFecha
         and tipo_doc in ('02') and estado = 'P';

    -- Tipo de documento de 'Devolucion de Factura DV' = '03'
    Cursor C_cabecera_devolucion is-- (vFecha date) is
      Select no_cia, centro, tipo_doc, periodo, ruta, no_docu, estado,
             fecha, no_fisico, serie_fisico,
             conduce, observ1,
             imp_ventas,
             imp_incluido,
             imp_especial,
             no_prove,
             tipo_refe, no_refe, serie_refe, no_docu_refe,
             descuento,
             mov_tot,
             tot_art_iv,
             moneda_refe_cxp,
             tipo_cambio,
             monto_digitado_compra,
             monto_bienes,
             monto_importac,
             monto_serv,
             origen,
             tipo_doc_d,
             n_docu_d,
             fecha_ent,
             hora_ent,
             ind_completa,
             orden_compra,
             fec_emision_despacho, fec_llegada_despacho,
             transporte,
             nota_credito, valor_ncredito,
             art_rotos,
             comentarios,
             no_pedido_cobol,
             bodega_local,
             ind_transferido,
             respon_stand,
             usuario,
             impuesto,
             descuento_c,
             numero_solicitud, fecha_aplicacion,
             emple_solic,            c_costo_emplesol,
             no_cliente,
             vendedor,
             aplica_guia_rem,
             reclamo_proveedor,
             mov_tot2
        from migra_arinme
       Where no_cia = Pv_NoCia --:global.compania
         and centro = Pv_NoCentro --:global.centro
         and trunc(fecha) <= Pd_FechaProceso --vFecha
         and tipo_doc in ('03') and estado = 'P';
    ------------------------------------------------------------------
    -- Obtengo la suma del detalle
    Cursor C_existe_detalle (vtipo_doc varchar2, vNo_docu varchar2) is
      Select sum(monto) from migra_arinml
       Where no_cia   = Pv_NoCia --:global.compania
         and centro   = Pv_NoCentro --:global.centro
         and tipo_doc = vtipo_doc
         and no_docu  = vNo_docu;

    -- Controla que exista detalle
    Cursor C_Detalle (vtipo_doc varchar2, vNo_docu varchar2) is
      Select no_cia, centro, tipo_doc, periodo, ruta, no_docu,
             linea, linea_ext, bodega, no_arti, ind_iv, unidades,
             monto, descuento_l, impuesto_l,
             tipo_cambio, monto_dol,
             ind_oferta,
             no_orden, linea_orden,
             centro_costo,
             impuesto_l_incluido,
             danados,
             bodega_local,
             precio_venta,
             cantidad_eq,
             unidad_eq,
             unidad_empaque,
             cantidad_empaque,
             codigo_alterno,
             impuestos_costo,
             clase,
             categoria,
             reconoce_reclamoprov,
             confirma_reclamoprov,
             time_stamp,
             monto2,
             monto2_dol from migra_arinml
       where no_cia   = Pv_NoCia --:global.compania
         and centro   = Pv_NoCentro --:global.centro
         and tipo_doc = vtipo_doc
         and no_docu  = vNo_docu;

    ------------------------------------------------------------------
    -- Recuperacion de tipo de documento para 'Despacho de Factura'
    Cursor C_tipo_despachoF is
      Select tipo_doc_inve
        from arfact
       where no_cia         = Pv_NoCia --:global.compania
         and ind_fac_dev    = 'F'
         and tipo_mov       = 'D'
         and afecta_saldo   = 'N'
         and pedido         = 'N'
         and ind_nota_venta ='N';

    -- Recuperacion de tipo de documento para 'Despacho de Nota de Venta'
    Cursor C_tipo_despachoN is
      Select tipo_doc_inve
        from arfact
       where no_cia         = Pv_NoCia --:global.compania
         and ind_fac_dev    = 'F'
         and tipo_mov       = 'D'
         and afecta_saldo   = 'N'
         and ind_nota_venta ='S';

    -- Recuperacion de tipos de documento para 'Devolucion de Factura'
    Cursor C_tipo_despachoD is
      Select tipo_doc_inve
        from ARFACT
       where no_cia = Pv_NoCia --:global.compania
         and ind_fac_dev = 'D';

    Cursor C_Lote (Lv_Arti Varchar2) Is
     select nvl(ind_lote,'N')
       from Arinda
      where no_cia = Pv_NoCia --:global.compania
        and no_arti = Lv_arti;

    Cursor C_Lote_Bodega (Lv_Bodega Varchar2, Lv_arti Varchar2, Lv_lote Varchar2) Is
     select fecha_vence, ubicacion
       from arinlo
      where no_cia  = Pv_NoCia --:global.compania
        and bodega  = Lv_Bodega
        and no_arti = Lv_arti
        and no_lote = Lv_lote;

    Cursor  C_cod_arti (v_arti varchar2) is
      Select no_arti
        from arinda
       where no_cia = Pv_NoCia --:global.compania
         and codigo_anterior = v_arti;

    Cursor C_Bodega Is  -- Recupera la bodega principal dependiendo al centro
      select codigo
        from arinbo
       where no_cia = Pv_NoCia --:global.compania
         and nvl(principal,'N') = 'S'
         and centro = Pv_NoCentro; --:global.centro;
    --
    vExiste_arti    boolean;
    mensaje_existe  varchar2(500) := null;
    vTipo_Despacho  arfact.tipo_doc_inve%type;
    vTipo_DespachoN arfact.tipo_doc_inve%type;
    vTipo_Devoluc   arfact.tipo_doc_inve%type;
    vNo_docu        arinme.no_docu%type;
    v_docu_migra    arinme.no_docu%type;
    vLinea          number := 1;
    --mensaje_error   varchar2(500) := null;
    error_proceso   exception;
    vTotal          number(17,6);
    vFound          boolean;
    --Pv_MensajeError      varchar2(500) := null;

    Ln_costo2       Arinma.costo2%type    := 0;
    vcosto_art      Arinma.costo_uni%type := 0;
    Lv_lote         Arinda.ind_lote%type;
    Ld_fecha_vence  Arinmo.fecha_vence%type;
    Lv_ubicacion    Arinmo.ubicacion%type;
    vv_cod_arti     arinda.no_arti%type;
    Lv_bodega       Arinbo.codigo%type;
    ln_cantidad_desp Number;

  BEGIN
    Open  C_existe_articulo;--(:uno.fecha);
    Fetch C_existe_articulo into mensaje_existe;
    vExiste_arti := C_existe_articulo%found;
    Close C_existe_articulo;

    Open C_Bodega;
    Fetch C_Bodega into Lv_bodega;
    If C_Bodega%notfound Then
       Close C_Bodega;
       Pv_MensajeError := 'Bodega principal no existe para compania y centro escogido';
       raise error_proceso;
    else
       Close C_Bodega;
    end if;

    --
    If not vExiste_arti Then

      -- ***************************************
      -- Procesamiento de Devolucion de Factura
      -- ***************************************
      Open  C_tipo_despachoD;
      Fetch C_tipo_despachoD into vTipo_Devoluc;
      Close C_tipo_despachoD;
      --
      For i in C_cabecera_devolucion Loop --(:uno.fecha) Loop
        vLinea := 1;
        Open  C_existe_detalle(i.tipo_doc, i.no_docu);
        Fetch C_existe_detalle into vTotal;
        vFound := C_existe_detalle%found;
        Close C_existe_detalle;

        -- Confirmo la existencia de detalle para la transaccion
        If vFound then
          -- Creacion de transaccion en Arinme
          vNo_docu := Transa_Id.Inv(Pv_NoCia); --:global.compania);

          PROCESAR_ENCABEZADO( Pv_NoCia, --:global.compania,
                               Pv_NoCentro, --:global.centro,
                               vTipo_Devoluc,
                               vNo_docu,
                               nvl(i.no_fisico,'000000'),
                               i.serie_fisico,  -- serie
                               i.periodo,
                               'Transaccion generada por Proceso de Carga de Ventas'||i.observ1,
                               1,  --vTipoCambio,
                               i.tipo_refe, --:uno.tipo_doc,  -- tipo_ref
                               i.no_refe,
                               i.serie_refe,
                               i.no_docu_refe,
                               i.mov_tot,
                               i.mov_tot2,
                               Pv_MensajeError);  -- docu_ref

          If Pv_MensajeError is not null then
            raise error_proceso;
          end if;

          vcosto_art:= 0;
          Ln_costo2 := 0;
          vLinea    := 1;

          For j in  C_Detalle(i.tipo_doc,i.no_docu) Loop
            Open  C_cod_arti(j.no_arti);
            Fetch C_cod_arti into vv_cod_arti;
            If C_cod_arti%notfound Then
              Close C_cod_arti;
              Pv_MensajeError := 'Devolucion. Codigo de articulo no existe: '||j.no_arti;
              raise error_proceso;
            else
              Close C_cod_arti;
              If vv_cod_arti is null Then
                Pv_MensajeError := 'Devolucion. Codigo no existe para articulo: '||j.no_arti;
                raise error_proceso;
               end if;
            end if;

            vcosto_art := articulo.costo( Pv_NoCia, vv_cod_arti, lv_bodega); --:global.compania,  --- se recupera el costo y costo 2 del articulo ANR 05/05/2009
            Ln_costo2  := articulo.costo2(Pv_NoCia, vv_cod_arti, lv_bodega); --:global.compania,

            j.monto  := nvl(moneda.redondeo( j.unidades * vcosto_art, 'P'), 0);
            j.monto2 := nvl(moneda.redondeo( j.unidades * Ln_costo2, 'P'), 0);

            j.monto_dol  := nvl(moneda.redondeo( j.unidades * vcosto_art, 'P'), 0);
            j.monto2_dol := nvl(moneda.redondeo( j.unidades * Ln_costo2, 'P'), 0);

            PROCESAR_LINEA( Pv_NoCia, --:global.compania,
                            Pv_NoCentro, --:global.centro,
                            i.periodo,
                            vTipo_Devoluc,
                            vNo_docu,
                            vLinea,
                            vv_cod_arti,
                            j.unidades,
                            j.monto,
                            j.monto2,
                            j.monto_dol,
                            j.monto2_dol,
                            1,
                            Pv_MensajeError);    -- vTipoCambio);

            If Pv_MensajeError is not null then
              raise error_proceso;
            end if;

            Open C_Lote (vv_cod_arti);
            Fetch C_Lote into Lv_lote;
            If C_Lote%notfound Then
              Close C_Lote;
              Lv_lote := 'N';
            else
              Close C_Lote;
            end if;

            If Lv_lote = 'L' Then
              Open C_Lote_Bodega (lv_bodega, vv_cod_arti, 'MIGRA');
              Fetch C_Lote_Bodega into Ld_fecha_vence, Lv_ubicacion;
              If C_Lote_Bodega%notfound Then
                Close C_Lote_Bodega;
                Lv_ubicacion   := null;
                Ld_fecha_vence := add_months(sysdate,2); --- Como no viene informacion de fecha de vencimiento se asume esto ANR
              else
                Close C_Lote_Bodega;
              end if;

              Procesar_linea_lote( Pv_NoCia, --:global.compania,
                                   Pv_NoCentro, --:global.centro,
                                   vTipo_Devoluc,
                                   i.periodo,
                                   '0000',
                                   vNo_Docu,
                                   vlinea,
                                   'MIGRA',  --- El lote se carga con MIGRA porque no existe codigo de lote en la carga ANR 05/05/2009
                                   j.unidades,
                                   --0, --- El valor se carga con cero porque en los lotes no se lleva el costo, el costo se lo lleva en el detalle del articulo ANR 05/05/2009
                                   Lv_ubicacion,
                                   Ld_fecha_vence,
                                   Pv_MensajeError);

              If Pv_MensajeError is not null then
                raise error_proceso;
              end if;-- fin mensaje error
            end if;-- fin es lote

            vLinea := vLinea + 1;
          End Loop; -- fin detalle documento
        End if;   -- vFound
        --
        v_docu_migra := i.no_docu;
        Pv_MensajeError := null;
        --
        /* INHABILITADO POR LLINDAO PARA EVITAR LA ACTUALIZACION DE LOS DOCUMENTOS A MIGRAR MASIVAMENTE
        INactualiza( Pv_NoCia, --:global.compania,
                     vTipo_Devoluc,
                     vNo_docu,
                     Pv_MensajeError);
        --
        If Pv_MensajeError is not null then
          raise error_proceso;
        else*/
          Update migra_arinme
             Set estado = 'D'
           Where no_cia = Pv_NoCia    --:global.compania
             and centro = Pv_NoCentro --:global.centro
             and no_docu = v_docu_migra;

          -- llindao: actualizacion termporal para que no los tome el proceso de
          --          actualizacion que ejecuta el usuario
          Update arinme
             set estado = 'D'  --FEM
           where no_docu  = vNo_docu
             and tipo_doc = vTipo_Devoluc
             and centro   = Pv_NoCentro
             and no_cia   = Pv_NoCia;
        /*
        End if;*/
      End Loop; -- C_cabecera_devolucion

      --
      -- **************************************
      -- Procesamiento de Despacho de Facturas
      -- **************************************
      Open  C_tipo_despachoF;
      Fetch C_tipo_despachoF into vTipo_Despacho;
      Close C_tipo_despachoF;
      --
      For i in C_cabecera_despacho(Pd_FechaProceso) Loop --:uno.fecha) Loop
        vLinea := 1;
        Open  C_existe_detalle(i.tipo_doc, i.no_docu);
        Fetch C_existe_detalle into vTotal;
        vFound := C_existe_detalle%found;
        Close C_existe_detalle;

        -- confirmo la existencia de detalle para la transaccion
        If vFound then
          -- Creacion de transaccion en Arinme
          vNo_docu := Transa_Id.Inv(Pv_NoCia); --:global.compania);

          PROCESAR_ENCABEZADO( Pv_NoCia, --:global.compania,
                               Pv_NoCentro, --:global.centro,
                               vTipo_Despacho,
                               vNo_docu,
                               nvl(i.no_fisico,'000000'),
                               i.serie_fisico,  -- serie
                               i.periodo,
                               'Transaccion generada por Proceso de Carga de Ventas. '||i.observ1,
                               1,  --vTipoCambio,
                               i.tipo_refe, --:uno.tipo_doc,  -- tipo_ref
                               i.no_refe,
                               i.serie_refe,
                               i.no_docu_refe,
                               0, --i.mov_tot,
                               0,
                               Pv_MensajeError);  --i.mov_tot2);  -- docu_ref

          If Pv_MensajeError is not null then
            raise error_proceso;
          end if;

          vcosto_art := 0;
          Ln_costo2  := 0;
          vLinea     := 1;

          For j in  C_Detalle(i.tipo_doc, i.no_docu) Loop
            Open  C_cod_arti(j.no_arti);
            Fetch C_cod_arti into vv_cod_arti;
            If C_cod_arti%notfound Then
              Close C_cod_arti;
              Pv_MensajeError := 'Despacho. Codigo de articulo no existe: '||j.no_arti;
              raise error_proceso;
            else
              Close C_cod_arti;
              If vv_cod_arti is null Then
                Pv_MensajeError := 'Despacho. Codigo no existe para articulo: '||j.no_arti;
                raise error_proceso;
              end if;
            end if;

            vcosto_art := articulo.costo(Pv_NoCia, vv_cod_arti, Lv_bodega); --:global.compania,  -- se recupera el costo y costo 2 del articulo ANR 05/05/2009
            Ln_costo2  := articulo.costo2(Pv_NoCia, vv_cod_arti, Lv_bodega); --:global.compania,

            j.monto  := nvl(moneda.redondeo( j.unidades * vcosto_art, 'P'), 0);
            j.monto2 := nvl(moneda.redondeo( j.unidades * Ln_costo2, 'P'), 0);

            j.monto_dol  := nvl(moneda.redondeo( j.unidades * vcosto_art, 'P'), 0);
            j.monto2_dol := nvl(moneda.redondeo( j.unidades * Ln_costo2, 'P'), 0);

            PROCESAR_LINEA( Pv_NoCia,--:global.compania,
                            Pv_NoCentro, --:global.centro,
                            i.periodo,
                            vTipo_Despacho,
                            vNo_docu,
                            vLinea,
                            vv_cod_arti, --j.no_arti,
                            j.unidades,
                            j.monto,
                            j.monto2,
                            j.monto_dol,
                            j.monto2_dol,
                            1,
                            Pv_MensajeError);    -- vTipoCambio);

            If Pv_MensajeError is not null then
              raise error_proceso;
            end if;

            Open C_Lote (vv_cod_arti);
            Fetch C_Lote into Lv_lote;
            If C_Lote%notfound Then
              Close C_Lote;
              Lv_lote := 'N';
            else
              Close C_Lote;
            end if;

            If Lv_lote = 'L' Then
              Open C_Lote_Bodega (Lv_bodega, vv_cod_arti, 'MIGRA');
              Fetch C_Lote_Bodega into Ld_fecha_vence, Lv_ubicacion;
              If C_Lote_Bodega%notfound Then
                Close C_Lote_Bodega;
                Lv_ubicacion   := null;
                Ld_fecha_vence := add_months(sysdate,2); --- Como no viene informacion de fecha de vencimiento se asume esto ANR
              else
                Close C_Lote_Bodega;
              end if;
              ----------------------------------------------------
              ---DEBE VERIFICAR EL LOTE ADECUADO PARA DESPACHAR---
              ----------------------------------------------------
              ln_cantidad_desp := 0;
              PROCESAR_LOTE ( Pv_NoCia, --:global.compania,
                              Pv_NoCentro, --:global.centro,
                              vTipo_Despacho,
                              Lv_bodega,
                              vNo_Docu,
                              i.periodo,
                              '0000',
                              vlinea,
                              vv_cod_arti,
                              j.unidades,
                              ln_cantidad_desp,
                              Pv_MensajeError );

              If Pv_MensajeError is not null then
                raise error_proceso;
              end if;

              If nvl(ln_cantidad_desp,0) != nvl(j.unidades,0) then
                Pv_MensajeError := 'Existencia en Lotes insuficiente...No_Docu:'||vNo_Docu||
                                   ',No_arti:'||vv_cod_arti||
                                   ',Disponible:'||nvl(ln_cantidad_desp,0)||
                                   ',Requerido:'||nvl(j.unidades,0);
                raise error_proceso;
              end if;

            end if;
            --
            vLinea := vLinea + 1;

          End Loop;--FIN DE DETALLE DE FACTURAS
          --
        End if;   -- vFound
        --

        v_docu_migra := i.no_docu;
        Pv_MensajeError := null;
        /* inhabilitado por llindao para evitar las actualizaciones de estas migraciones
        INactualiza( Pv_NoCia,--:global.compania,
                     vTipo_Despacho,
                     vNo_docu,
                     Pv_MensajeError);
        --
        If Pv_MensajeError is not null then
          RAISE error_proceso;
        else*/
          Update migra_arinme
             Set estado = 'D'
           Where no_cia  = Pv_NoCia --:global.compania
             and centro  = Pv_NoCentro --:global.centro
             and no_docu = v_docu_migra;

          -- llindao: actualizacion termporal para que no los tome el proceso de
          --          actualizacion que ejecuta el usuario
          Update arinme
             set estado = 'D'  --FEM
           where no_docu  = vNo_docu
             and tipo_doc = vTipo_Despacho
             and centro   = Pv_NoCentro
             and no_cia   = Pv_NoCia;
          --
        /*End if;  */
            --
      End Loop; -- C_cabecera_despacho
      --
      -- Message('Proceso en ejecucion..',no_acknowledge);synchronize;

      -- ***********************************************
      -- Procesamiento de Despacho de Nota de Venta
      -- ***********************************************

      Open  C_tipo_despachoN;
      Fetch C_tipo_despachoN into vTipo_DespachoN;
      Close C_tipo_despachoN;
      --
      For i in C_cabecera_despachoN(Pd_FechaProceso) Loop --:uno.fecha) Loop
        vLinea := 1;
        Open  C_existe_detalle(i.tipo_doc, i.no_docu);
        Fetch C_existe_detalle into vTotal;
        vFound := C_existe_detalle%found;
        Close C_existe_detalle;

        -- Confirmo la existencia de detalle para la transaccion
        If vFound then
          -- Creacion de transaccion en Arinme
          vNo_docu := Transa_Id.Inv(Pv_NoCia); --:global.compania);

          PROCESAR_ENCABEZADO( Pv_NoCia, --:global.compania,
                               Pv_NoCentro, --:global.centro,
                               vTipo_DespachoN,
                               vNo_docu,
                               nvl(i.no_fisico,'000000'),
                               i.serie_fisico,
                               i.periodo,
                               'Transaccion generada por Proceso de Carga de Ventas. '||i.observ1,
                               1,  --vTipoCambio,
                               i.tipo_refe, --:uno.tipo_doc,  -- tipo_ref
                               i.no_refe,
                               i.serie_refe,
                               i.no_docu_refe,
                               i.mov_tot,
                               i.mov_tot2,
                               Pv_MensajeError);  -- docu_ref

          If Pv_MensajeError is not null then
            raise error_proceso;
          end if;

          vcosto_art:= 0;
          Ln_costo2 := 0;
          vLinea    := 1;

          For j in  C_Detalle(i.tipo_doc, i.no_docu) Loop
            Open  C_cod_arti(j.no_arti);
            Fetch C_cod_arti into vv_cod_arti;
            If C_cod_arti%notfound Then
              Close C_cod_arti;
              Pv_MensajeError := 'Nota venta. Codigo de articulo no existe: '||j.no_arti;
              raise error_proceso;
            else
              Close C_cod_arti;
              If vv_cod_arti is null Then
                Pv_MensajeError := 'Nota de venta. Codigo no existe para articulo: '||j.no_arti;
                raise error_proceso;
              end if;
            end if;

            vcosto_art := articulo.costo(Pv_NoCia, vv_cod_arti, lv_bodega); --:global.compania,   --- se recupera el costo y costo 2 del articulo ANR 05/05/2009
            Ln_costo2  := articulo.costo2( Pv_NoCia, vv_cod_arti, lv_bodega); --:global.compania,

            j.monto  := nvl(moneda.redondeo( j.unidades * vcosto_art, 'P'), 0);
            j.monto2 := nvl(moneda.redondeo( j.unidades * Ln_costo2, 'P'), 0);

            j.monto_dol  := nvl(moneda.redondeo( j.unidades * vcosto_art, 'P'), 0);
            j.monto2_dol := nvl(moneda.redondeo( j.unidades * Ln_costo2, 'P'), 0);

            PROCESAR_LINEA( Pv_NoCia, --:global.compania,
                            Pv_NoCentro, --:global.centro,
                            i.periodo,
                            vTipo_DespachoN,
                            vNo_docu,
                            vLinea,
                            vv_cod_arti,
                            j.unidades,
                            j.monto,
                            j.monto2,
                            j.monto_dol,
                            j.monto2_dol,
                            1,
                            Pv_MensajeError);    -- vTipoCambio);

            If Pv_MensajeError is not null then
              raise error_proceso;
            end if;

            Open C_Lote (vv_cod_arti);
            Fetch C_Lote into Lv_lote;
            If C_Lote%notfound Then
              Close C_Lote;
              Lv_lote := 'N';
            else
              Close C_Lote;
            end if;
            --
            If Lv_lote = 'L' Then
              ----------------------------------------------------
              ---DEBE VERIFICAR EL LOTE ADECUADO PARA DESPACHAR---
              ----------------------------------------------------
              ln_cantidad_desp := 0;
              PROCESAR_LOTE ( Pv_NoCia, --:global.compania,
                              Pv_NoCentro, --:global.centro,
                              vTipo_DespachoN,
                              Lv_bodega,
                              vNo_Docu,
                              i.periodo,
                              '0000',
                              vlinea,
                              vv_cod_arti,
                              j.unidades,
                              ln_cantidad_desp,
                              Pv_MensajeError );

              If Pv_MensajeError is not null then
                raise error_proceso;
              end if;

              If nvl(ln_cantidad_desp,0) != nvl(j.unidades,0) then
                Pv_MensajeError := 'Existencia en Lotes insuficiente...No_Docu:'||vNo_Docu||
                                   ',No_arti:'||vv_cod_arti||
                                   ',Disponible:'||nvl(ln_cantidad_desp,0)||
                                   ',Requerido:'||nvl(j.unidades,0);
                raise error_proceso;
              end if;

            end if;
            --
            vLinea := vLinea + 1;
          End Loop;
          --
        End if;   -- vFound
        --
        v_docu_migra := i.no_docu;
        Pv_MensajeError := null;
        --
        /* inhabilitado por llindao para evitar actualziar los docuymentos migrados
        INactualiza( Pv_NoCia, --:global.compania,
                     vTipo_DespachoN,
                     vNo_docu,
                     Pv_MensajeError);
        --
        If Pv_MensajeError is not null then
          raise error_proceso;
        else*/
          Update migra_arinme
             Set estado = 'D'
           Where no_cia = Pv_NoCia --:global.compania
             and centro = Pv_NoCentro --:global.centro
             and no_docu = v_docu_migra;
             --
          -- llindao: actualizacion termporal para que no los tome el proceso de
          --          actualizacion que ejecuta el usuario
          Update arinme
             set estado = 'D'  --FEM
           where no_docu  = vNo_docu
             and tipo_doc = vTipo_DespachoN
             and centro   = Pv_NoCentro
             and no_cia   = Pv_NoCia;
        /*
        End if;*/
      End Loop; -- C_cabecera_despacho
      --
    Else
      Pv_MensajeError := 'Se encontro el siguiente error ..'||mensaje_existe;
    END IF;
    --
  exception
    when error_proceso then null;
    when others then
      Pv_MensajeError := 'Error al cargar datos de ventas y devoluciones. '||SQLERRM;
  end IN_VENTAS;

end IN_PROCESAR_MIGRACION;
/
