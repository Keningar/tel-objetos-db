create or replace procedure            INACT_INGRESO_CANJE (cia_p         in varchar2,
                                                 tipo_p        in varchar2,
                                                 docu_p        in varchar2,
                                                 movimi_p      in varchar2,
                                                 interface_p   in varchar2,
                                                 cta_docu_p    in varchar2,
                                                 time_stamp_p  in date,
                                                 msg_error_p   in Out varchar2) IS
  --
  -- Creado por Jorge Heredia
  -- Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  -- tanto solo INactualiza deberia utilizarlo.
  -- La funcion especifica es la de actualizar los documentos generados
  -- por INGRESO POR CANJE.

  -- Lee el documento de Baja por mal estado que esta pendiente de actualizar.
  CURSOR c_documento IS
    SELECT e.no_cia, e.centro, e.tipo_doc, e.periodo, e.ruta, e.no_docu,
           e.fecha,  e.observ1, e.tipo_cambio,
           e.tipo_refe, e.no_refe,e.c_costo_emplesol, e.tipo_doc_d , e.n_docu_d,
           e.rowid rowid_me
      FROM arinme e
     WHERE e.no_cia     = cia_p
       AND e.no_docu    = docu_p
       AND e.tipo_doc   = tipo_p
       AND e.estado     = 'P';

  -- Lineas de Baja
  CURSOR c_lineas_doc IS
    SELECT l.linea_ext, l.linea,   l.bodega,     l.no_arti, l.ind_oferta, nvl(l.unidades,0) unidades,
			     nvl(l.monto,0) monto,   nvl(l.monto_dol,0) monto_dol,
           d.grupo,     d.costo_estandar, l.bodega_local,
			     l.rowid rowid_ml, l.precio_venta, monto2
      FROM arinda d, arinml l
     WHERE l.no_cia     = cia_p
	     AND l.no_docu    = docu_p
	     AND l.tipo_doc   = tipo_p
	     AND l.no_cia     = d.no_cia
	     AND l.no_arti    = d.no_arti;

  -- Selecciona Costos y otros datos del articulo en la bodega origen
  Cursor c_costo (cia_c           varchar2,
                  bodega_orig_c   varchar2,
                  arti_c          varchar2) Is
    Select m.costo_uni, d.costo_estandar, d.ind_lote, m.afecta_costo, m.costo2
      From arinda d, arinma m
     Where m.no_cia    = cia_c
       And m.bodega    = bodega_orig_c
       And m.no_arti   = arti_c
       And d.no_cia    = m.no_cia
       And d.no_arti   = m.no_arti;
     --
  Cursor c_grupo_contable(cia_c  grupos.no_cia%type,
                         grupo_c   grupos.grupo%type) Is
  Select grupo, metodo_costo
    From grupos
   Where no_cia = cia_c
     And grupo  = grupo_c;
   --

  Cursor c_lotes ( cia_c    varchar2,
                   tip_c    varchar2,
                   doc_c    varchar2,
                   lin_c    number,
                   cost     number) Is
  Select no_lote, nvl(unidades,0) unidades, nvl(unidades*cost,0) monto, ubicacion, fecha_vence
    From arinmo
   Where no_cia   = cia_c
     And no_docu  = doc_c
     And tipo_doc = tip_c
     And linea    = lin_c;


  error_proceso      Exception;
  vtime_stamp        Date;
  rper               inlib.periodo_proceso_r;
  vfound             Boolean;
  vrctas             inlib.cuentas_contables_r;
  vcta_inv           arindc.cuenta%type;         -- cuenta de inventario
  vcta_cpartida      arindc.cuenta%type;         -- cuenta de costo de ventas
  vcta_co            arindc.cuenta%type;         -- cuenta de costo por oferta
  vtmov_ctaInv       arindc.tipo_mov%type;
  vtmov_ctaCosto     arindc.tipo_mov%type;
  vmov_tot           arinme.mov_tot%type;
  vmov2_tot          arinme.mov_tot%type;
  vmonto_lote        Number;
  vcentro_costo      arincc.centro_costo%Type;
  vtercero           argemt.codigo_tercero%type:= Null;
  fechaL             arinlo.fecha_entrada%type;


  vcosto_unit        arinma.costo_uni%type:= Null;
  vcosto2_unit       arinma.costo_uni%type:= Null;
  vcosto_u_L         arinlo.costo_lote%type;
  vtotal_lin         arinml.monto%type;
  vtotal2_lin        arinml.monto%type;  --FEM
  vtotal_lin_dol     arinml.monto_dol%type;
  vtotal2_lin_dol    arinml.monto_dol%type;  --FEM
  rd                 c_documento%rowtype;
  rcosto             c_costo%rowtype;
  rmc                c_grupo_contable%rowtype;


Begin
  ---
  vtime_stamp  := time_stamp_p;
  ---
  If interface_p is null then
   Null;
  End If;

  -- Busca el documento a actualizar
  Open c_documento;
  Fetch c_documento Into rd;
  vfound := c_documento%Found;
  Close c_documento;

  If not vfound Then
    msg_error_p := 'ERROR: No fue posible localizar la transaccion: '||docu_p;
    Raise error_proceso;
  End If;

  -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);

  -- define el vsigno de la actualizacion y la forma del detalle contable
  vcta_cpartida := cta_docu_p;

  If movimi_p = 'S' Then
  	msg_error_p := 'El tipo de movimiento de Salida, no es valido en este tipo de documento';
    Raise error_proceso;
  Else
    vtmov_ctaInv   := 'D';
    vtmov_ctaCosto := 'C';
  End If;

  -- Crea el documento en el historico de encabezado de documento basado en ARINME
  INcrea_encabezado_h(rd.rowid_me,
                      rper.mes_proce,
                      rper.semana_proce,
                      rper.indicador_sem);
  --
  vmov_tot  := 0;
  --
  For i in c_lineas_doc Loop  -- lineas de articulos del movimiento
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    If not inlib.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) then
      msg_error_p := 'Falta definir las cuentas contables, '||'para bodega: '||i.bodega||'  grupo: '||i.grupo;
      Raise error_proceso;
    End If;

    -- ***************************
    -- COSTOS
    -- ***************************
    -- Obtiene el metodo de costeo para el grupo del articulo actual.
    If rmc.grupo is Null Or rmc.grupo != i.grupo then
      rmc.grupo := null;
      ---
      Open c_grupo_contable(cia_p, i.grupo);
      Fetch c_grupo_contable into rmc;
      Close c_grupo_contable;
      ---
      If rmc.grupo is null then
        msg_error_p := 'No existe el grupo contable: '||i.grupo;
        Raise error_proceso;
      End If;
      ---
    End If;

    -- Recupera el costo unitario del articulo en la bodega origen
    -- y Verifica la existencia del articulo en bodega destino
    Open c_costo(cia_p,  i.bodega_local, i.no_arti);
    Fetch c_costo Into rcosto;
    vfound := c_costo%Found;
    Close c_costo;

    --
    If not vfound Then
      msg_error_p := 'ERROR: El articulo '||i.no_arti||' no existe '|| 'en la bodega '|| i.bodega_local ||'-';
      Raise error_proceso;
    End If;

    -- crea el articulo en la Bod. mal estado en arinma
    increa_articulo(cia_p,
                    i.bodega,
                    i.no_arti,
                    rcosto.afecta_costo,
                    msg_error_p);
    --
    If msg_error_p is not null Then
      Raise error_proceso;
    End If;

    --se desea colocar el costo de arinda standard (cost_e)para las transacciones
    If (rmc.metodo_costo = 'P') Then
      vcosto_unit := nvl(rcosto.costo_uni,0);
      vcosto2_unit := nvl(rcosto.costo2,0);
      vcosto_u_L  := vcosto_unit;
    Else
      If (rmc.metodo_costo = 'E') and (rcosto.costo_estandar is null) Then
        msg_error_p := 'El articulo '|| i.no_arti ||' no tiene definido costo estandar';
        Raise error_proceso;
      End If;
      ---
      vcosto_unit := nvl(rcosto.costo_estandar,0);
      vcosto2_unit := nvl(rcosto.costo2,0);
      vcosto_u_L  := vcosto_unit;
      ---
    End If;

    vtotal_lin := moneda.redondeo(nvl(abs(i.unidades * vcosto_unit), 0), 'P');
    vtotal2_lin := moneda.redondeo(nvl(abs(i.unidades * vcosto2_unit), 0), 'P'); --FEM

    vtotal_lin_dol := moneda.redondeo(nvl(vtotal_lin / rd.tipo_cambio,0), 'D');
    vtotal2_lin_dol := moneda.redondeo(nvl(vtotal2_lin / rd.tipo_cambio,0), 'D'); --FEM

    vmov_tot   := nvl(vmov_tot,0) + vtotal_lin;
    vmov2_tot   := nvl(vmov2_tot,0) + vtotal2_lin;

    -- Actualiza el precio de salida para el articulo en el detalle
    Update arinml
       Set monto      = vtotal_lin,
           monto_dol  = vtotal_lin_dol,
           monto2     = vtotal2_lin,
           monto2_dol = vtotal2_lin_dol
     Where Rowid = i.rowid_ml;

    -- Actualiza saldos del inventario. (Bod. mal estado)
    INActualiza_saldos_articulo (cia_p,
                                 i.bodega ,
                                 i.no_arti,
                                 'TRASLADO',
                                 i.unidades,
                                 nvl(vtotal_lin,0),
                                 rd.fecha,
                                 msg_error_p);

    If msg_error_p is not null Then
      Raise error_proceso;
    End If;

--- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
--- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas

    INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);


	  --
    vcta_inv  := vrctas.cta_inventario;
    vcta_co   := vrctas.cta_costo_oferta;
    vcentro_costo := vrctas.centro_costo;

    -- Movimiento contable a la cuenta de inventario(Mov. Credito)
    INinserta_dc(rd.no_cia,        rd.centro,       rd.tipo_doc,
                 rd.no_docu,       vtmov_ctaInv,    vcta_inv,
		        	   vtotal_lin,       vcentro_costo,
                 vtotal_lin_dol,   rd.tipo_cambio,  vtercero);

    -- como es una salida del inventario por Baja por mal estado, se genera un debito
    -- a la cuenta contable de contrapartida asociada al tipo de documento
    INinserta_dc(rd.no_cia,        rd.centro,          rd.tipo_doc,
                 rd.no_docu,       vtmov_ctaCosto,     vcta_cpartida,
	               vtotal_lin,       rd.c_costo_emplesol,
                 vtotal_lin_dol,   rd.tipo_cambio,     vtercero);

    -- Inserta en ARINMN la linea que se esta procesando
    -- (Inventarios) Historico de detalle de lineas del Inventario
    INinserta_mn(rd.no_cia,         rd.centro,          rd.tipo_doc,
	               rd.no_docu,        rd.periodo,         rper.mes_proce,
		        	   rper.semana_proce, rper.indicador_sem, rd.ruta,
                 i.linea,           i.bodega,           i.no_arti,
                 rd.fecha,          i.unidades,         vtotal_lin,
                 null,              rd.tipo_refe,       rd.no_refe,
                 null,              vcosto_unit,        --vtotal_lin/i.unidades,
                 vtime_stamp,
                 '000000000',       'N',                i.precio_venta,
                 vtotal2_lin,       vcosto2_unit);  --vtotal2_lin);

    -- actualiza (disminuye) las existencias para los lotes de cada articulo
    -- Comentado por Manuel Yuquilima 26-mar-2009
    --For j in c_lotes(rd.no_cia, rd.tipo_doc_d, rd.n_docu_d, i.linea, vcosto_unit) Loop  -- lotes del articulo
    For j in c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea, vcosto_unit) Loop  -- lotes del articulo
        ---
        vmonto_lote := moneda.redondeo(j.monto, 'P');
			  ---
        -- AUMENTA existencia en bodega destino
        Update arinlo
           Set saldo_unidad   = nvl(saldo_unidad, 0)   + (j.unidades),
               saldo_contable = 0,---,nvl(saldo_contable, 0) + (j.unidades),
               saldo_monto    = 0---nvl(saldo_monto, 0)    + (vmonto_lote)
         Where no_cia    = rd.no_cia
           And bodega    = i.bodega
           And no_arti   = i.no_arti
           And no_lote   = j.no_lote;

        If (sql%rowcount = 0) Then
           Insert Into arinlo(no_cia,       bodega,
                              no_arti,             no_lote,
                              ubicacion,           saldo_unidad,  saldo_contable,
                              saldo_monto,         salida_pend,   costo_lote,
                              proceso_toma,        exist_prep,    costo_prep,
                              fecha_entrada,       fecha_vence,   fecha_fin_cuarentena)
             VALUES( rd.no_cia,           i.bodega,
                     i.no_arti,           j.no_lote,
                     NULL,         j.unidades,   0, --- j.unidades, valores en monto va en cero ANR 18/06/2009
                     0,0,0,--vmonto_lote,         0,             vmonto_lote / j.unidades,
                     'N',                 null,          null,
                     fechaL,              j.fecha_vence, null);
       END IF;
    END LOOP;  -- lotes del articulo
  END LOOP;  -- lineas de articulos del movimiento

  -- Actualiza el estado del documento
  Update arinme
     Set estado = 'D',
         mov_tot = vmov_tot,
         mov_tot2 = vmov2_tot  --FEM
   Where rowid = rd.rowid_me;

  Update arinmeh
     Set mov_tot = vmov_tot,
         mov_tot2 = vmov2_tot  --FEM
   Where no_cia =  rd.no_cia
     And no_docu =  rd.no_docu;

Exception
  When error_proceso Then
     msg_error_p := nvl(msg_error_p, 'error_proceso en INACT_INGRESO_CANJE');
     Return;
  When OThers Then
     msg_error_p := 'ACTUALIZA_INGRESO_CANJE : ' || Sqlerrm;
     Return;
End INACT_INGRESO_CANJE;