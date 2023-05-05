create or replace procedure            INACT_REVEGRESO_CANJE(cia_p         IN varchar2,
                                                  tipo_p        IN varchar2,
                                                  docu_p        IN varchar2,
                                                  movimi_p      IN varchar2,
                                                  interface_p   IN varchar2,
                                                  cta_docu_p    IN varchar2,
                                                  time_stamp_p  IN date,
                                                  msg_error_p   IN OUT varchar2) Is
 -- Decalaracion de cursores
 -- Lee el documento de Baja por mal estado que esta pendiente de actualizar.
 CURSOR c_documento IS
  SELECT e.no_cia, e.centro, e.tipo_doc, e.periodo, e.ruta, e.no_docu,
         e.fecha,  e.observ1, e.tipo_cambio,
         e.tipo_refe, e.no_refe,e.c_costo_emplesol,
         e.rowid rowid_me
    FROM arinme e
   WHERE e.no_cia     = cia_p
     AND e.no_docu    = docu_p
     AND e.tipo_doc   = tipo_p
     AND e.estado     = 'P';
 --
 CURSOR c_lineas_doc IS
  SELECT l.linea_ext, l.linea,   l.bodega,     l.no_arti, l.ind_oferta, nvl(l.unidades,0) unidades,
  	     nvl(l.monto,0) monto,   nvl(l.monto_dol,0) monto_dol, d.grupo, d.costo_estandar, l.bodega_local,
         l.rowid rowid_ml,l.precio_venta
    FROM arinda d, arinml l
   WHERE l.no_cia   = cia_p
     AND l.no_docu  = docu_p
     AND l.tipo_doc = tipo_p
     AND l.no_cia   = d.no_cia
     AND l.no_arti  = d.no_arti;

 -- Selecciona Costos y otros datos del articulo en la bodega origen
 CURSOR c_costo (cia_c varchar2, bodega_orig_c varchar2, arti_c varchar2) Is
  SELECT m.costo_uni, d.costo_estandar, d.ind_lote, m.afecta_costo, m.costo2
    FROM arinda d, ARINMA M
   WHERE m.no_cia    = cia_c
     AND m.bodega    = bodega_orig_c
     AND m.no_arti   = arti_c
     AND d.no_cia    = m.no_cia
     AND d.no_arti   = m.no_arti;
 --
 CURSOR c_grupo_contable(cia_c  grupos.no_cia%type,
                         grupo_c   grupos.grupo%type) Is
   SELECT grupo, metodo_costo
     FROM grupos
    WHERE no_cia  = cia_c
      AND grupo   = grupo_c;

 -- Declaracion de variables locales
 error_proceso    Exception;
 vtime_stamp      date;
 rper             inlib.periodo_proceso_r;
 vfound           boolean;
 vrctas           inlib.cuentas_contables_r;
 vcta_inv         arindc.cuenta%type;         -- cuenta de inventario
 vcta_cpartida    arindc.cuenta%type;         -- cuenta de costo de ventas
 vcta_co          arindc.cuenta%type;         -- cuenta de costo por oferta
 vtmov_ctaInv     arindc.tipo_mov%type;
 vtmov_ctaCosto   arindc.tipo_mov%type;
 vmov_tot         arinme.mov_tot%type;
 vmov2_tot        arinme.mov_tot%type;  --FEM
 vcentro_costo    arincc.centro_costo%type;
 vtercero         argemt.codigo_tercero%type:=Null;
 vcosto_unit      arinma.costo_uni%type := 0;
 vcosto2_unit     arinma.costo_uni%type := 0;
 vcosto_u_L       arinlo.costo_lote%type;
 vtotal_lin       arinml.monto%type;
 vtotal2_lin      arinml.monto%type;
 vtotal_lin_dol   arinml.monto_dol%type;
 vtotal2_lin_dol  arinml.monto_dol%type;
 rd               c_documento%ROWTYPE;
 rcosto           c_costo%ROWTYPE;
 rmc              c_grupo_contable%ROWTYPE;

BEGIN
 --
 vtime_stamp  := time_stamp_p;
 -- Busca el documento a actualizar
 If interface_p is null then
  Null;
 End If;

 OPEN  c_documento;
 FETCH c_documento INTO rd;
 vfound := c_documento%FOUND;
 CLOSE c_documento;

 IF not vfound THEN
  msg_error_p := 'ERROR: No fue posible localizar la transaccion: '||docu_p;
  RAISE error_proceso;
 END IF;

 -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);
  -- define el vsigno de la actualizacion y la forma del detalle contable
  vcta_cpartida := cta_docu_p;

  IF movimi_p = 'S' THEN
  	msg_error_p := 'El tipo de movimiento de Salida, no es valido en este tipo de documento';
    RAISE error_proceso;
  ELSE
    vtmov_ctaInv   := 'D';
    vtmov_ctaCosto := 'C';
  END IF;
  -- Crea el documento en el historico de encabezado de documento basado en ARINME
  INcrea_encabezado_h(rd.rowid_me,
                      rper.mes_proce,
                      rper.semana_proce,
                      rper.indicador_sem);
  --
  vmov_tot  := 0;
  vmov2_tot  := 0;
  --
  For i in c_lineas_doc Loop-- lineas de articulos del movimiento
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    If not inlib.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) Then
       msg_error_p := 'Falta definir las cuentas contables, para bodega: '||i.bodega||'  grupo: '||i.grupo;
       Raise Error_proceso;
    End If;

   --*********
   --COSTOS
   --*********
   -- Obtiene el metodo de costeo para el grupo del articulo actual.
    IF rmc.grupo is null or rmc.grupo != i.grupo THEN
     rmc.grupo := null;
     OPEN  c_grupo_contable(cia_p, i.grupo);
     FETCH c_grupo_contable INTO rmc;
     CLOSE c_grupo_contable;

     IF rmc.grupo is null THEN
       msg_error_p := 'No existe el grupo contable: '||i.grupo;
       RAISE error_proceso;
     END IF;
    END IF;
    -- Recupera el costo unitario del articulo en la bodega origen
    -- y Verifica la existencia del articulo en bodega destino
    OPEN  c_costo(cia_p,  i.bodega, i.no_arti);
    FETCH c_costo INTO rcosto;
    vfound := c_costo%FOUND;
    CLOSE c_costo;

    If not vfound Then
       msg_error_p := 'ERROR: El articulo '||i.no_arti||' no existe '|| 'en la bodega '|| i.bodega;
       Raise Error_proceso;
    End If;

    --crea el articulo en la Bod. Principal en arinma
    INCrea_Articulo(cia_p,  i.bodega, i.no_arti, rcosto.afecta_costo, msg_error_p);

    If msg_error_p is not null Then
      Raise error_proceso;
    End If;

    --se desea colocar el costo de arinda standard (cost_e)para las transacciones
    If (rmc.metodo_costo = 'P') Then
      vcosto_unit := nvl(rcosto.costo_uni,0);
      vcosto_u_L  := vcosto_unit;
    Else
     If (rmc.metodo_costo = 'E') and (rcosto.costo_estandar is null) Then
       msg_error_p := 'El articulo '|| i.no_arti ||' no tiene definido costo estandar';
       Raise error_proceso;
     End If;
       vcosto_unit := nvl(rcosto.costo_estandar,0);
       vcosto_u_L  := vcosto_unit;
    End If;

    vcosto2_unit := nvl(rcosto.costo2,0);

    vtotal_lin     := moneda.redondeo(nvl(abs(i.unidades * vcosto_unit), 0), 'P');
    vtotal2_lin     := moneda.redondeo(nvl(abs(i.unidades * vcosto2_unit), 0), 'P');

    vtotal_lin_dol := moneda.redondeo(nvl(vtotal_lin / rd.tipo_cambio,0), 'D');
    vtotal2_lin_dol := moneda.redondeo(nvl(vtotal2_lin / rd.tipo_cambio,0), 'D');

    vmov_tot       := nvl(vmov_tot,0) + vtotal_lin;
    vmov2_tot       := nvl(vmov2_tot,0) + vtotal2_lin;

    -- Actualiza el precio de salida para el articulo en el detalle
    UPDATE arinml
       SET monto      = vtotal_lin,
           monto_dol  = vtotal_lin_dol,
           monto2     = vtotal2_lin,
           monto2_dol = vtotal2_lin_dol
     WHERE rowid = i.rowid_ml;

    -- Actualiza saldos del inventario. (Bod. Principal)
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
    INinserta_dc(rd.no_cia,         rd.centro,       rd.tipo_doc,
                 rd.no_docu,        vtmov_ctaInv,    vcta_inv,
		        	   vtotal_lin,        vcentro_costo,
                 vtotal_lin_dol,    rd.tipo_cambio,  vtercero);

    -- como es una salida del inventario por Baja por mal estado, se genera un debito
    -- a la cuenta contable de contrapartida asociada al tipo de documento
    INinserta_dc(rd.no_cia,         rd.centro,      rd.tipo_doc,
                 rd.no_docu,        vtmov_ctaCosto, vcta_cpartida,
	               vtotal_lin,        rd.c_costo_emplesol,
                 vtotal_lin_dol,    rd.tipo_cambio, vtercero);

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
                 vtotal2_lin,       vcosto2_unit);    --vtotal2_lin); --- FEM
  --
  END LOOP;
  -- Actualiza el estado del documento
  UPDATE arinme
     SET estado   = 'D',
         mov_tot  = vmov_tot,
         mov_tot2 = vmov2_tot  --FEM
   WHERE rowid = rd.rowid_me;

  UPDATE arinmeh
     SET mov_tot  = vmov_tot,
         mov_tot2 = vmov2_tot  --FEM
   WHERE no_cia   = rd.no_cia
     AND no_docu  = rd.no_docu;
---
Exception
  When error_proceso Then
     msg_error_p := nvl(msg_error_p, 'error_proceso en INACT_REVEGRESO_CANJE');
     Return;
  When Others Then
     msg_error_p := 'ACTUALIZA_EGRESO_REVERSO_CANJE : ' || Sqlerrm;
     Return;
END INACT_REVEGRESO_CANJE;