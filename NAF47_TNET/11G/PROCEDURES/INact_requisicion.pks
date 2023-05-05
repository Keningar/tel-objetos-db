create or replace PROCEDURE            INact_requisicion (cia_p        IN varchar2,
                                               tipo_p       IN varchar2,
                                               docu_p       IN varchar2,
                                               movimi_p     IN varchar2,
                                               interface_p  IN varchar2,
                                               cta_docu_p   IN varchar2,
                                               time_stamp_p IN date,
                                               msg_error_p  IN OUT varchar2) Is
  -- Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  -- tanto solo INactualiza deberia utilizarlo.
  -- La funcion es actualizar las requisciones que disminuyen el inventario

  -- Lee el documento de compra que esta pendiente de actualizar.
  CURSOR c_documento IS
    SELECT e.no_cia, e.centro, e.tipo_doc, e.no_docu,
           e.periodo, e.ruta,
           e.fecha, e.conduce,
           e.observ1, e.tipo_cambio,
           e.tipo_refe, e.no_refe, e.c_costo_emplesol,
           e.rowid rowid_me,
           e.id_presupuesto --FEM 
      FROM arinme e
     WHERE e.no_cia     = cia_p
       AND e.no_docu    = docu_p
       AND e.tipo_doc   = tipo_p
       AND e.estado     = 'P';

  -- Lineas de requisiciones
  CURSOR c_lineas_doc IS
    SELECT l.linea_ext, l.linea, l.bodega,
           l.no_arti,
           nvl(l.unidades,0) unidades,
           nvl(l.monto,0) monto,
           nvl(l.monto2,0) monto2,  --FEM
           nvl(l.monto_dol,0) monto_dol,
           nvl(l.monto2_dol,0) monto2_dol,  --FEM
           l.centro_costo,l.precio_venta,
          ---- nvl(ind_control_activo_fijo,'N') ind_control_activo_fijo,
           d.grupo, d.costo_estandar, g.metodo_costo, l.rowid rowid_ml
      FROM arinda d, arinml l, grupos g
     WHERE l.no_cia     = cia_p
      AND l.no_docu    = docu_p
      AND l.tipo_doc   = tipo_p
      AND l.no_cia     = d.no_cia
      AND l.no_arti    = d.no_arti
      AND g.no_cia     = d.no_cia
      AND g.grupo      = d.grupo;
      
  Cursor C_cuenta_partida (Cn_presupuesto in number)is
  select a.cuenta_contable, a.centro_costo
     from arprem a
     where no_cia = cia_p
       and id_presupuesto = Cn_presupuesto;
  

  --
  ---- Puede ser que este configurado varios tipos de activo
  /*Cursor C_Lineas_activo Is
   select a.ctavo, b.no_arti, d.bodega, b.serie, b.tipo
   from   arafmt a, inv_solicrequi_arti_acti b, arinme c, arinml d
   where  b.no_cia = cia_p
   and    c.no_docu = docu_p
   and    c.tipo_doc = tipo_p
   and    a.no_cia = b.no_cia
   and    a.tipo = b.tipo
   and    b.no_cia = c.no_cia
   and    b.centro = c.centro
   and    b.numero_solicitud = c.numero_solicitud
   and    c.no_cia = d.no_cia
   and    c.no_docu = d.no_docu;*/


  CURSOR c_lotes ( cia_c varchar2,    tip_c varchar2,    doc_c varchar2,
                   lin_c number,      cost  number  ) IS
    SELECT no_lote, nvl(unidades,0) unidades,
           nvl(unidades*cost,0) monto,
           ubicacion, fecha_vence
      FROM arinmo
     WHERE no_cia   = cia_c
	     AND no_docu  = doc_c
	     AND tipo_doc = tip_c
	     AND linea    = lin_c ;

  error_proceso   Exception;
  vtime_stamp     Date;
  rper            inlib.periodo_proceso_r;
  vfound          Boolean;
  vtmov_ctaInv    arindc.tipo_mov%type;
  vtmov_ctaHaber  arindc.tipo_mov%type;
  vcta_inv        arindc.cuenta%type;         -- cuenta de inventario
  vcta_cpartida   arindc.cuenta%type;         -- cuenta de costo de ventas
  vrctas          inlib.cuentas_contables_r;
  vcentro_costo   arincc.centro_costo%type;   -- centro de costo de inventarios
  vsigno_consumo  Number(2);
  vsignoaux       Number(2);
  vcosto_art      arinma.costo_uni%type :=0;
  vcosto2_art     arinma.costo_uni%type :=0;
  vmov_tot        arinme.mov_tot%type;
  vmov2_tot       arinme.mov_tot%type;
  vmonto_lote     Number;
--  vcentro_cero    arindc.centro_costo%type;
  vtercero_dc     arindc.codigo_tercero%type:= Null;
  rd              c_documento%rowtype;
  Ln_costo2       Arinda.costo2_unitario%type:=0;
  Lv_centro_costo  arprem.centro_costo%type:=null;
  Lv_cuenta_conta  arprem.cuenta_contable%type:=null;
  Lv_centro_contra arprem.centro_costo%type:=null;

 --- Ln_costo_activo Arinda.costo_unitario%type;


Begin
  --

  --
  vtime_stamp   := time_stamp_p;

  If interface_p is null or cta_docu_p is null then
   Null;
  End If;

  -- Busca el documento a actualizar
  Open c_documento;
  Fetch c_documento Into rd;
  vfound := c_documento%Found;
  Close c_documento;

  If not vfound Then
    msg_error_p := 'No fue posible localizar la transaccion: '||docu_p;
    Raise error_proceso;
  End If;

  -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);

  -- define el vsigno de la actualizacion y la forma del detalle contable
  -- vcta_haber := cta_docu_p;
  If movimi_p = 'E' Then
    vsigno_consumo := -1;
    vtmov_ctaInv   := 'D';
    vtmov_ctaHaber := 'C';
  Else
    vsigno_consumo :=  1;
    vtmov_ctaInv   := 'C';
    vtmov_ctaHaber := 'D';
  End If;

  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot  := 0;
  vmov2_tot := 0;
  --
  For i in c_lineas_doc Loop

    -- determina el costo unitario del articulo
    vcosto_art := articulo.costo(cia_p, i.no_arti, i.bodega);
    Ln_costo2 := articulo.costo2(cia_p, i.no_arti, i.bodega);

      vcosto2_art := Ln_costo2;

      vcosto_art := nvl(vcosto_art, 0);
      vcosto2_art := nvl(vcosto2_art, 0);

      -- calcula el costo de la salida
      i.monto := nvl(moneda.redondeo( i.unidades * vcosto_art, 'P'), 0);
      i.monto2 := nvl(moneda.redondeo( i.unidades * vcosto2_art, 'P'), 0);

      IF rd.tipo_cambio > 0 THEN
        i.monto_dol := nvl(moneda.redondeo(i.monto / rd.tipo_cambio, 'D'), 0);
        i.monto2_dol := nvl(moneda.redondeo(i.monto2 / rd.tipo_cambio, 'D'), 0);
      ELSE
        i.monto_dol := 0;
        i.monto2_dol := 0;
      END IF;
      --
      -- calcula el costo del documento
      UPDATE arinml
         SET monto      = i.monto,
             monto_dol  = i.monto_dol,
             monto2     = i.monto2,
             monto2_dol = i.monto2_dol
       WHERE rowid = i.rowid_ml;

     vmov_tot  := nvl(vmov_tot,0) + nvl(i.monto,0);
     vmov2_tot := nvl(vmov2_tot,0) + nvl(i.monto2,0);

     -- Trae la cuenta de inventario para el grupo contable y bodega
     -- que se esta procesando en esta linea.
     IF not INLIB.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) THEN
       msg_error_p := 'Falta definir las cuentas contables, para bodega: '||i.bodega||'  grupo: '||i.grupo;
       RAISE error_proceso;
     END IF;
     
     --FEM 04-2012 Codigo Partida Presupuestaria
     --Se agrega para que en caso de tener partida presupuestaria
     --el cuadre contable sea Inv x Partida Presupuestaria.
  
     If rd.id_presupuesto is not null then
       ---
       Open C_cuenta_partida(rd.id_presupuesto);
       Fetch C_cuenta_partida into Lv_cuenta_conta, Lv_centro_costo;
       Close C_cuenta_partida;
       ---
       vcta_cpartida     := Lv_cuenta_conta;
       Lv_centro_contra  := Lv_centro_costo;
     else
       ---
       vcta_cpartida     := vrctas.cta_contrapartida_requi;
       Lv_centro_contra  := rd.c_costo_emplesol;
       ---
     End if;
     --FIN FEM
     --
     vcta_inv       := vrctas.cta_inventario;
     vcentro_costo  := vrctas.centro_costo;

     If  vcta_inv is null THEN
        msg_error_p := 'Debe configurar la cuenta de inventario para el grupo: '||i.grupo||' bodega: '||i.bodega;
        Raise error_proceso;
     elsif vcta_cpartida is null THEN
        msg_error_p := 'Debe configurar la cuenta contrapartida de requisiciones, para el grupo: '||i.grupo||' bodega: '||i.bodega;
        Raise error_proceso;
     elsif vcentro_costo  is null THEN
        msg_error_p := 'Debe configurar el centro de costos para la cuenta de inventarios, para el grupo: '||i.grupo||' bodega: '||i.bodega;
        Raise error_proceso;
     end if;

     --- Solo debe contabilizar las cuentas contables pertenecientes a inventarios
     --- No considerar lo de activos fijos ANR 26/11/2010

    --- If i.ind_control_activo_fijo = 'N' then

     -- movimiento contable a la cuenta de inventario
     INinserta_dc(rd.no_cia,      rd.centro,    rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaInv, vcta_inv,
		              i.monto,        vcentro_costo, i.monto_dol,
				          rd.tipo_cambio, vtercero_dc);

     ---end if;

     -- movimiento contable a la cuenta contrapartida
     INinserta_dc(rd.no_cia,      rd.centro,      rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaHaber, vcta_cpartida,
		              i.monto,        Lv_centro_contra, i.monto_dol,
				          rd.tipo_cambio, vtercero_dc);

     -- Actualiza los campos de consumo del articulo en ARINMA (Maestro
     -- de articulos)
     INActualiza_saldos_articulo (rd.no_cia, i.bodega, i.no_arti, 'CONSUMO',
                                  (i.unidades * vsigno_consumo), (i.monto * vsigno_consumo),
                                  Null, msg_error_p);

     IF msg_error_p is not null THEN
       RAISE error_proceso;
     END IF;

--- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
--- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas

    INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);



     --
       BEGIN
       INSERT INTO arinhc(no_cia,    centro,  ano,
                          semana,    ind_sem,  no_arti, centro_costo,
                          unidades,  monto)
                   VALUES(rd.no_cia,            rd.centro,                 rd.periodo,
                          rper.semana_proce,    rper.indicador_sem,             i.no_arti,     vcentro_costo,
                          (i.unidades * vsigno_consumo), (i.monto * vsigno_consumo));
      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
      -- Actualiza el Historico de Consumo.
     UPDATE arinhc
        SET unidades  = nvl(unidades,0) + (i.unidades * vsigno_consumo),
            monto     = nvl(monto,0)    + (i.monto * vsigno_consumo)
      WHERE no_cia    = rd.no_cia
		    AND centro    = rd.centro
		    AND ano       = rd.periodo
		    AND semana    = rper.semana_proce
		    AND ind_sem   = rper.indicador_sem
		    AND centro_costo  = i.centro_costo
		    AND no_arti   = i.no_arti;
      WHEN OTHERS THEN
         msg_error_p := 'Error al crear registro de requisicion para articulo: '||i.no_arti||' '||sqlerrm;
        Raise error_proceso;
      END;
     --
     -- Inserta en ARINMN la linea que se esta procesando
     INinserta_mn(rd.no_cia,         rd.centro,          rd.tipo_doc,
	                rd.no_docu,        rd.periodo,         rper.mes_proce,
                  rper.semana_proce, rper.indicador_sem, rd.ruta,
                  i.linea_ext,       i.bodega,           i.no_arti,
                  rd.fecha,          i.unidades,         i.monto,
                  null,              rd.tipo_refe,       rd.no_refe,
                  null,              vcosto_art, --i.monto/i.unidades,
                  vtime_stamp,
                  i.centro_costo,    'N',                i.precio_venta,
                  i.monto2,          Ln_costo2);  --i.monto2);  --FEM
     --
     -- el signo del movimiento de lotes es inverso al del arinma.cons_xx
     vsignoaux := vsigno_consumo * -1;

     For j in c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea, vcosto_art) Loop
       vmonto_lote := moneda.redondeo(j.monto, 'P');
       update arinlo
          set saldo_unidad   = nvl(saldo_unidad, 0)   + (j.unidades * vsignoaux),
              saldo_contable = 0,---nvl(saldo_contable, 0) + (j.unidades * vsignoaux),  VALORES EN MONTO VA EN CERO ANR 18/06/2009
              saldo_monto    = 0---nvl(saldo_monto, 0)    + (vmonto_lote * vsignoaux)
        where no_cia    = rd.no_cia
		      and bodega    = i.bodega
			    and no_arti   = i.no_arti
			    and no_lote   = j.no_lote;

       If (sql%rowcount = 0) Then
           ---
           If movimi_p = 'E' Then
              msg_error_p := 'No existe lote: '||j.no_lote||' articulo: '||i.no_arti||
                             ', devol. de requisicion :'||rd.no_docu;
              raise error_proceso;
           End if;
           ---
           Insert Into arinlo(no_cia,         bodega,         no_arti,        no_lote,
                              ubicacion,      saldo_unidad,   saldo_contable, saldo_monto,
                              salida_pend,    costo_lote,     proceso_toma,   exist_prep,
                              costo_prep,     fecha_entrada,  fecha_vence,    fecha_fin_cuarentena)
                      values (rd.no_cia,      i.bodega,       i.no_arti,      j.no_lote,
                              j.ubicacion,    (j.unidades*vsignoaux), 0,0,
                              0,  0,
                                'N',
                              null,           null,           rd.fecha,       j.fecha_vence,
                              null);
           ---
        End If;

        -- Inserta en ARINMT la linea que se esta procesando
        Insert Into arinmt(no_cia,   centro,    tipo_doc,     ano,
		                       ruta,     no_docu,   no_linea,     bodega,
						               no_arti,  no_lote,   unidades,     venta,
                           descuento )
                   values (rd.no_cia,  rd.centro,   rd.tipo_doc, rd.periodo,
    					             rd.ruta,    rd.no_docu,  i.linea_ext, i.bodega,
    				               i.no_arti,  j.no_lote,	  j.unidades,  0,
                           0);
      End Loop;  -- lotes por linea
   End Loop; -- Lineas del documento


 /* --- Al final se contabiliza con el mismo movimiento de la cuenta de inventarios
  --- las cuentas contables de activos fijos

     For i in C_Lineas_activo Loop

     If   i.ctavo is null THEN
      msg_error_p := 'Debe configurar la cuenta de activo para la serie: '||i.serie||' tipo de activo: '||i.tipo||' articulo: '||i.no_arti;
      Raise error_proceso;
     end if;


     --- Cada articulo que es activo fijo ingresa individualmente al costo del inventario
     Ln_costo_activo := articulo.costo(cia_p, i.no_arti, i.bodega);

     -- movimiento contable a la cuenta de inventario
     INinserta_dc(rd.no_cia,      rd.centro,    rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaInv, i.ctavo,
		              Ln_costo_activo,        vcentro_costo, Ln_costo_activo,
				          rd.tipo_cambio, vtercero_dc);

     end loop;

*/
--- Verifico que el asiento contable cuadre ANR 26/11/2010

If inverifica_conta(cia_p, docu_p, msg_error_p) then
   raise Error_proceso;
end if;

   -- Actualiza el estado del documento
   Update arinme
      Set estado  = 'D',
          mov_tot = vmov_tot,
          mov_tot2 = vmov2_tot  --FEM
    Where no_cia  = rd.no_cia
      And no_docu = rd.no_docu;

   Update arinmeh
      Set mov_tot = vmov_tot,
          mov_tot2 = vmov2_tot  --FEM
    Where no_cia  = rd.no_cia
      And no_docu = rd.no_docu;

Exception
  When error_proceso Then
     msg_error_p := nvl(msg_error_p, 'error_proceso en Actualiza requisiciones');
     Return;
  When Others Then
     msg_error_p := 'INACT_REQUISICION: '|| SQLERRM;
     Return;
End;