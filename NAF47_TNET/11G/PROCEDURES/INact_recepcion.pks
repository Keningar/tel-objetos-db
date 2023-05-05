create or replace PROCEDURE            INact_recepcion (cia_p        IN varchar2,
                                             tipo_p       IN varchar2,
                                             docu_p       IN varchar2,
                                             movimi_p     IN varchar2,
                                             interface_p  IN varchar2,
                                             time_stamp_p IN date,
                                             msg_error_p  IN OUT varchar2) IS
   --
   --  Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
   --  tanto solo INactualiza deberia utilizarlo.
   --  Este proceso se encarga de actualizar documentos de despacho
   --  generados por la facturacion

   -- Lee el documento de compra que esta pendiente de actualizar.
   CURSOR c_documento IS
     SELECT e.no_cia, e.centro, e.tipo_doc, e.periodo, e.ruta, e.no_docu,
            e.fecha, e.conduce,
            e.observ1, e.tipo_cambio,
            e.no_docu_refe, e.tipo_refe,   -- Con estos campos se constata si el doc. es de credito o contado
            e.no_refe, tm.codigo_tercero,
            e.rowid rowid_me
     FROM   arinme e, arinvtm tm
     WHERE   e.no_cia     = cia_p
        and  e.no_docu    = docu_p
        and  e.tipo_doc   = tipo_p
        and  e.estado     = 'P'
        AND  tm.no_cia    = e.no_cia
        AND  tm.tipo_m    = e.tipo_doc;
   --
   -- Lineas de compras
   Cursor c_lineas_doc Is
   Select l.linea_ext, l.linea, l.bodega, l.no_arti, l.ind_oferta,
          nvl(l.unidades,0) unidades,
          nvl(l.monto,0) monto,
          nvl(l.monto2,0) monto2,
          nvl(l.monto_dol,0) monto_dol,
          nvl(l.monto2_dol,0) monto2_dol,
          d.grupo, d.costo_estandar, g.metodo_costo,
          L.precio_venta
     From arinda d, arinml l,grupos g
    Where l.no_cia     = cia_p
      and l.no_docu    = docu_p
      and l.tipo_doc   = tipo_p
      and l.no_cia     = d.no_cia
      and l.no_arti    = d.no_arti
      and g.no_cia     = d.no_cia
      and g.grupo      = d.grupo;
   --
   Cursor c_lotes (cia_c varchar2,    tip_c varchar2,    doc_c varchar2,
                   lin_c number----,      cost  number
                   ) Is
    Select no_lote, nvl(unidades,0) unidades,  ----nvl(unidades*cost,0)
          0 monto,
          ubicacion, fecha_vence
      From arinmo
     Where no_cia   = cia_c
       And no_docu  = doc_c
       And tipo_doc = tip_c
       And linea    = lin_c;
   --
  Cursor c_afecta_saldo (cia_c varchar2,  no_factu_c varchar2)  is
    Select nvl(afecta_saldo,'N') afecta_saldo
      from arfafe
     Where no_cia = cia_c
       and no_factu = no_factu_c;
  --
  Cursor c_vendedor_centro (cia_c varchar2,  no_factu_c varchar2)  is
    Select centro_costo
    from arintb
    Where no_cia = cia_c
    and codigo in (Select no_vendedor
                     from arfafe
                    Where no_cia = cia_c
                      and no_factu = no_factu_c);


   error_proceso   EXCEPTION;
   vtime_stamp     date;
   rper            inlib.periodo_proceso_r;
   vfound          boolean;
   vrctas          inlib.cuentas_contables_r;
   vcta_inv        arindc.cuenta%type;         -- cuenta de inventario

   vcta_cv         arindc.cuenta%type;         -- cuenta de costo de ventas

   vtmov_ctaInv    arindc.tipo_mov%type;
   vtmov_ctaCosto  arindc.tipo_mov%type;
   vtercero_dc     arindc.codigo_tercero%type:=null;
   vcosto_art      number;
   vmonto_lote     number;
   vcentro_costo   arincc.centro_costo%TYPE;

   rd              c_documento%ROWTYPE;
   vv_afecta       varchar2(1) := 'N';
   vccosto_vendedor arincc.centro_costo%TYPE;
   ln_costo2       number(17,2):=0;

   vmov_tot        arinme.mov_tot%type;
   vmov_tot2       arinme.mov_tot%type;  --FEM

BEGIN

   --
   vtime_stamp   :=  time_stamp_p;
   -- Busca el documento a actualizar
   OPEN c_documento;
   FETCH c_documento INTO rd;
   vfound := c_documento%FOUND;
   CLOSE c_documento;
   IF NOT vfound THEN
      msg_error_p := 'ERROR: No fue posible localizar la transaccion: '||docu_p;
      raise error_proceso;
   END IF;
   --
   -- trae el periodo en proceso
   vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);
   -- define el vsigno de la actualizacion y la forma del detalle contable
   if movimi_p = 'S' then
      msg_error_p := 'El tipo de movimiento de salida, no es valido en recepciones';
   else
      vtmov_ctaInv   := 'D';
      vtmov_ctaCosto := 'C';
   end if;
   --
   -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  --

   FOR i IN c_lineas_doc LOOP
      --
      -- determina el costo unitario del articulo
      ----vcosto_art := 0; --- Se debe utilizar el costo que se graba en la transaccion de ARINML ANR 13/07/2009
      vcosto_art := articulo.costo(cia_p, i.no_arti, i.bodega);
      vcosto_art := nvl(vcosto_art,0);
      Ln_costo2  := articulo.costo2(cia_p, i.no_arti, i.bodega); --FEM

    IF rd.tipo_cambio > 0 THEN
      i.monto_dol := nvl(moneda.redondeo(i.monto / rd.tipo_cambio, 'D'), 0);
      i.monto2_dol := nvl(moneda.redondeo(i.monto2 / rd.tipo_cambio, 'D'), 0);
    ELSE
      i.monto_dol := 0;
      i.monto2_dol := 0;
    END IF;

      vmov_tot  := nvl(vmov_tot,0) + i.monto;
      vmov_tot2 := nvl(vmov_tot2,0) + i.monto2;  --FEM

      -- Actualiza el monto y las unidades de las ventas en ARINMA (Maestro de articulos)
      -- Como es una devolucion o anulacion de factura, tienen que disminuir las ventas
      INActualiza_saldos_articulo (rd.no_cia, i.bodega, i.no_arti, 'RECEPCION',
                                   i.unidades, i.monto, Null, msg_error_p);
      IF msg_error_p is not null THEN
        RAISE error_proceso;
      END IF;

      --- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
      --- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas
      INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);

      -- Inserta en ARINMN la linea que se esta procesando
      INinserta_mn(rd.no_cia,          rd.centro,          rd.tipo_doc,
                   rd.no_docu,        rd.periodo,         rper.mes_proce,
                   rper.semana_proce, rper.indicador_sem, rd.ruta,
                   i.linea_ext,       i.bodega,           i.no_arti,
                   rd.fecha,          i.unidades,         i.monto,
                   null,              rd.tipo_refe,       rd.no_refe,
                   null,              vcosto_art,  --i.monto/i.unidades,
                   vtime_stamp,
                   null,              i.ind_oferta,       i.precio_venta,
                   i.monto2,          Ln_costo2);
	    --
      -- Trae la cuenta de inventario para el grupo contable y bodega
      -- que se esta procesando en esta linea.
      If NOT INLIB.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) then
         msg_error_p := 'Falta definir las cuentas contables, '||
                        'para bodega: '||i.bodega||'  grupo: '||i.grupo;
         raise error_proceso;
      End if;
      --
      -- Se obtiene las cuentas contables de Inventario y Costo de Venta
      vcta_inv      := vrctas.cta_inventario;
      vcta_cv       := vrctas.cta_costo_venta;

      --
      Open  c_afecta_saldo(rd.no_cia, rd.no_docu_refe);
      Fetch c_afecta_saldo into vv_afecta;
      Close c_afecta_saldo;

      If vcta_cv is null Then
         msg_error_p := 'No esta configurado cuenta de costpo de Venta, para grupo: '||i.grupo||' bodega: '||i.bodega;
         raise error_proceso;
      end if;
      --
      Open  c_vendedor_centro(rd.no_cia, rd.no_docu_refe);
      Fetch c_vendedor_centro into vccosto_vendedor;
      Close c_vendedor_centro;
      --
      -- Se obtiene el centro de costo relacionado a la Division del vendedor
      vcentro_costo := vrctas.centro_costo;
      --
      -- Movimiento contable a la cuenta de Inventario
      INinserta_dc(rd.no_cia,      rd.centro,     rd.tipo_doc,
                   rd.no_docu,     vtmov_ctaInv,  vcta_inv,
                   i.monto,        vcentro_costo,
                   i.monto_dol,
                   rd.tipo_cambio, vtercero_dc);
      --
      -- Movimiento contable a la cuenta de Costo de Venta (contrapartida)  ---Devoluciones (contrapartida)
      INinserta_dc(rd.no_cia,      rd.centro,         rd.tipo_doc,
                   rd.no_docu,     vtmov_ctaCosto,    vcta_cv, --vcta_dv,
                   i.monto,        nvl(vccosto_vendedor,vcentro_costo),
                   i.monto_dol,
                   rd.tipo_cambio, vtercero_dc);
       --
       --
      for j in c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea----, vcosto_art
      ) loop
         vmonto_lote := moneda.redondeo(j.monto, 'P');
         update arinlo
            set saldo_unidad   = nvl(saldo_unidad, 0)   + (j.unidades),
                saldo_contable = 0,
                saldo_monto    = 0
            where no_cia    = rd.no_cia
			  and bodega    = i.bodega
			  and no_arti   = i.no_arti
			  and no_lote   = j.no_lote;
         IF (sql%rowcount = 0) THEN
           Insert into arinlo(no_cia,         bodega,
		                      no_arti,        no_lote,     ubicacion,           saldo_unidad,
					           		  saldo_contable, saldo_monto, salida_pend,         costo_lote,
           							  proceso_toma,   exist_prep,  costo_prep,
							            fecha_entrada,  fecha_vence, fecha_fin_cuarentena )
                   values (
                           rd.no_cia,  i.bodega,
						               i.no_arti,  j.no_lote,     j.ubicacion, j.unidades,
						               0,0,0,0,
						               'N',        null,          null,
                           rd.fecha,   j.fecha_vence, null);
         END IF;
         -- Inserta en ARINMT la linea que se esta procesando
         insert into arinmt(no_cia,    centro,     tipo_doc, ano,      ruta,
		                        no_docu,   no_linea,   bodega,   no_arti,  no_lote,
                            unidades,  venta,      descuento)
                    values (rd.no_cia,  rd.centro,   rd.tipo_doc, rd.periodo,
    						            rd.ruta,    rd.no_docu,  i.linea_ext, i.bodega,
    					              i.no_arti,  j.no_lote,	 j.unidades, 0,--- vmonto_lote,   VALORES EN MONTO VA EN CERO ANR 18/06/2009
                            0);
      End loop;  -- lotes
   End loop;  -- lineas de articulos del movimiento
   --
   --
   -- Actualiza el estado del documento
  UPDATE arinme
     SET estado = 'D',
         mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2  --FEM
   WHERE rowid = rd.rowid_me;

  Update arinmeh
     SET mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2  --FEM
   where no_cia = cia_p
   and   no_docu = docu_p;

   --
EXCEPTION
  WHEN error_proceso THEN
     msg_error_p := NVL(msg_error_p, 'error_proceso en Actualiza_recepcion');
     RETURN;
  WHEN OTHERS THEN
     msg_error_p := 'INACT_RECEPCION: ' || SQLERRM;
     RETURN;
END;