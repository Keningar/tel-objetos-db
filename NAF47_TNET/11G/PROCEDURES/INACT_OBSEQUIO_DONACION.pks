create or replace procedure            INACT_OBSEQUIO_DONACION (cia_p         in varchar2,
                                                     tipo_p        in varchar2,
                                                     docu_p        in varchar2,
                                                     movimi_p      in varchar2,
                                                     interface_p   in varchar2,
                                                     time_stamp_p  in date,
                                                     msg_error_p   in out varchar2) Is
  --
  -- Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  -- tanto solo INactualiza deberia utilizarlo.
  -- La funcion especifica es la de actualizar los documentos de despacho
  -- generados por la facturacion

  -- Lee el documento de despacho que esta pendiente de actualizar.
  Cursor c_documento Is
  Select e.no_cia, e.centro, e.tipo_doc, e.periodo, e.ruta, e.no_docu,
         e.fecha,  e.observ1, e.tipo_cambio,
         e.tipo_refe, e.no_refe, tm.codigo_tercero,
         e.rowid rowid_me
    From arinme e, arinvtm tm
   Where e.no_cia     = cia_p
     And e.no_docu    = docu_p
     And e.tipo_doc   = tipo_p
     And e.estado     = 'P'
     And tm.no_cia    = e.no_cia
     And tm.tipo_m    = e.tipo_doc;
  --
  -- Lineas de detalle
  Cursor c_lineas_doc Is
  Select l.linea_ext,          l.linea,      l.bodega,
         l.no_arti,            l.ind_oferta, nvl(l.unidades,0) unidades,
	       nvl(l.monto,0) monto,
	       nvl(l.monto2,0) monto2,             --FEM
         nvl(l.monto_dol,0) monto_dol,
         nvl(l.monto2_dol,0) monto2_dol,     --FEM
         d.grupo, d.costo_estandar,
	       l.rowid rowid_ml,l.precio_venta
    From arinda d, arinml l, arinma a
   Where l.no_cia     = cia_p
     And l.no_docu    = docu_p
     And l.tipo_doc   = tipo_p
     And l.no_cia     = d.no_cia
     And l.no_arti    = d.no_arti
     And a.no_cia     = l.no_cia
     And a.bodega     = l.bodega
     And a.no_arti    = l.no_arti;
  --

  Cursor c_lotes (cia_c varchar2,  tip_c varchar2,  doc_c varchar2,
                  lin_c number,    cost  number  ) IS
  Select no_lote,                    nvl(unidades,0) unidades,
         nvl(unidades*cost,0) monto, ubicacion, fecha_vence
    From arinmo
   Where no_cia   = cia_c
     And no_docu  = doc_c
     And tipo_doc = tip_c
     And linea    = lin_c;
  --
  CURSOR c_ctaContrapartida (cia_c varchar2,  tip_c varchar2) IS
    Select cta_contrapartida
      from arinvtm
     Where no_cia = cia_c
       and tipo_m = tip_c;
  --
  CURSOR c_centroGasto (cia_c varchar2,  doc_c varchar2) IS
    Select centro_usuario
      From arinencobsdon
     Where no_cia  = cia_c
       and no_docu = doc_c;

  error_proceso      Exception;
  vtime_stamp        Date;
  rper               inlib.periodo_proceso_r;
  vfound             Boolean;
  vrctas             inlib.cuentas_contables_r;
  vcta_inv           arindc.cuenta%type;         -- cuenta de inventario
  vcta_cv            arindc.cuenta%type;         -- cuenta de costo de ventas
  vcta_co            arindc.cuenta%type;         -- cuenta de costo por oferta
  vcta_contrap       arindc.cuenta%type;         -- cuenta de contrapartida
  vtmov_ctaInv       arindc.tipo_mov%type;
  vtmov_ctaCosto     arindc.tipo_mov%type;
  vcosto_art         arinma.costo_uni%type:=0;
  vmov_tot           arinme.mov_tot%type;
  vmov_tot2          arinme.mov_tot%type;
  vmonto_lote        Number;
  vcentro_costo      arincc.centro_costo%type;
  vcentro_gasto      arincc.centro_costo%type;
  rd                 c_documento%rowtype;
  ln_costo2          arinma.costo_uni%type:=0;

Begin
  --vcentro_Cero := centro_costo.rellenad(cia_p, '0');
  vtime_stamp  := time_stamp_p;

  If interface_p is null then
   null;
  End if;

  -- Busca el documento a actualizar
  Open  c_documento;
  Fetch c_documento into rd;
  vfound := c_documento%Found;
  Close c_documento;

  --
  If not vfound Then
    msg_error_p := 'ERROR: No fue posible localizar la transaccion: '||docu_p;
    RAISE error_proceso;
  End If;

  -- define el vsigno de la actualizacion y la forma del detalle contable
  IF movimi_p = 'E' THEN
  	msg_error_p := 'El tipo de movimiento de entrada, no es valido en despachos';
  ELSE
    vtmov_ctaInv   := 'C';
    vtmov_ctaCosto := 'D';
  END IF;
  --
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);
  --
  If not vfound then
    msg_error_p := 'No existe o no esta configurado el periodo del proceso para la cia '||rd.no_cia||' el centro '||rd.centro;
    Raise Error_proceso;
  End If;

  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot  := 0;
  FOR i IN c_lineas_doc LOOP
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    IF not INLIB.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) THEN
      msg_error_p := 'Falta definir las cuentas contables, '||
                     'para bodega: '||i.bodega||'  grupo: '||i.grupo;
      RAISE error_proceso;
    END IF;
    -- determina el costo unitario del articulo
    vcosto_art := articulo.costo(cia_p, i.no_arti, i.bodega);
    Ln_costo2  := articulo.costo2(cia_p, i.no_arti, i.bodega);  --FEM

    vcosto_art := nvl(vcosto_art, 0);

    -- calcula el costo de la salida
    i.monto  := nvl(moneda.redondeo( i.unidades * vcosto_art, 'P'), 0);
    i.monto2 := nvl(moneda.redondeo( i.unidades * ln_costo2, 'P'), 0);

    IF rd.tipo_cambio > 0 THEN
      i.monto_dol := nvl(moneda.redondeo(i.monto / rd.tipo_cambio, 'D'), 0);
      i.monto2_dol := nvl(moneda.redondeo(i.monto2 / rd.tipo_cambio, 'D'), 0);
    ELSE
      i.monto_dol  := 0;
      i.monto2_dol := 0;
    END IF;

    vmov_tot   := nvl(vmov_tot,0) + i.monto;
    vmov_tot2  := nvl(vmov_tot2,0) + i.monto2;
    --
    -- calcula el costo del documento
    UPDATE arinml
       SET monto      = i.monto,
           monto_dol  = i.monto_dol,
           monto2     = i.monto2,
           monto2_dol = i.monto2_dol
     WHERE rowid = i.rowid_ml;
    --
    vcta_inv      := vrctas.cta_inventario;
    vcta_cv       := vrctas.cta_costo_venta;
    vcta_co       := vrctas.cta_costo_oferta;
    vcentro_costo := vrctas.centro_costo;

    -- Centro de Costo del solicitante
    Open  c_centroGasto(rd.no_cia, rd.no_docu);
    Fetch c_centroGasto into vcentro_gasto;
    Close c_centroGasto;

    -- Cuenta de Gasto para la Contrapartida
    Open  c_ctaContrapartida(rd.no_cia, rd.tipo_doc);
    Fetch c_ctaContrapartida into vcta_contrap;
    Close c_ctaContrapartida;

    -- Movimiento contable a la cuenta de inventario
    INinserta_dc(rd.no_cia,      rd.centro,     rd.tipo_doc,
                 rd.no_docu,     vtmov_ctaInv,  vcta_inv,
		        	   i.monto,        vcentro_costo, i.monto_dol,
				         rd.tipo_cambio, rd.codigo_tercero);

    IF nvl(i.ind_oferta, 'N') = 'S' THEN
      IF vcta_co IS NULL THEN
        msg_error_p := 'Falta definir cuenta contable de gasto por ofertas, '||
                       'para la bodega '||i.bodega||', grupo '||i.grupo;
        RAISE error_proceso;
      END IF;

    ELSE
      IF vcta_contrap IS NULL THEN
        msg_error_p := 'Falta definir cuenta contable de Gastos por Obsequios/Donaciones '||
                       'para el tipo de documento '||rd.tipo_doc;
        RAISE error_proceso;
      END IF;
      -- como es una salida del inventario por Obsequios/Donaciones, se genera un debito
      -- a la cuenta contable para los gastos
      INinserta_dc(rd.no_cia,      rd.centro,      rd.tipo_doc,
                   rd.no_docu,     vtmov_ctaCosto,  vcta_contrap, --vcta_cv,
			             i.monto,        vcentro_gasto,   i.monto_dol,
					         rd.tipo_cambio, rd.codigo_tercero);
    END IF;
    --
    -- Actualiza el monto y las unidades de las ventas en ARINMA (Maestro de articulos)
    -- Se manejara los Obsequios/Donaciones como si fuera un despacho por una venta realizada,
    -- tienen que aumentar las ventas ya que despues  esto se facturara por AutoConsumo.
    INActualiza_saldos_articulo (rd.no_cia, i.bodega, i.no_arti, 'DESPACHO',
                                 i.unidades, i.monto, rd.fecha, msg_error_p);
    IF msg_error_p is not null THEN
      RAISE error_proceso;
    END IF;

--- No actualiza el costo unitario del articulo pero si debe          ANR 27/04/2009
--- actualizar el monto 2 y el saldo valuado para todas las bodegas

    INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);


    -- Inserta en ARINMN la linea que se esta procesando
    INinserta_mn(rd.no_cia,         rd.centro,          rd.tipo_doc,
	               rd.no_docu,        rd.periodo,         rper.mes_proce,
		        	   rper.semana_proce, rper.indicador_sem, rd.ruta,
                 i.linea_ext,       i.bodega,           i.no_arti,
                 rd.fecha,          i.unidades,         i.monto,
                 null,              rd.tipo_refe,       rd.no_refe,
                 null,              vcosto_art,         --i.monto/i.unidades,
                 vtime_stamp,
                 vcentro_costo,     'N',                i.precio_venta,
                 i.monto2,          Ln_costo2);   --FEM

    -- actualiza (disminuye) las existencias para los lotes de cada articulo
    FOR j IN c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea, vcosto_art) LOOP
      vmonto_lote := moneda.redondeo(j.monto, 'P');
      UPDATE arinlo
         SET saldo_unidad   = nvl(saldo_unidad, 0) - j.unidades,
             saldo_contable = 0, ---nvl(saldo_contable, 0) - j.unidades, En lotes solamente se lleva por unidades, el costo se lo lleva en el detalle del articulo ANR 08/05/2009
             saldo_monto    = 0 --- nvl(saldo_monto, 0) - vmonto_lote En lotes solamente se lleva por unidades, el costo se lo lleva en el detalle del articulo ANR 08/05/2009
       WHERE no_cia    = rd.no_cia
		     AND bodega    = i.bodega
			   AND no_arti   = i.no_arti
			   AND no_lote   = j.no_lote;
      --
      IF (sql%rowcount = 0) THEN
        msg_error_p := 'No existe lote: '||j.no_lote||' articulo: '||i.no_arti||
                       ', despacho: '||rd.no_docu;
        RAISE error_proceso;
      END IF;
      --
      -- Inserta en ARINMT la linea que se esta procesando
      INSERT INTO arinmt(no_cia,   centro,    tipo_doc,    ano,
		                     ruta,     no_docu,   no_linea,    bodega,
						             no_arti,  no_lote,   unidades,
                         venta,
                         descuento)
                 VALUES (rd.no_cia,  rd.centro,   rd.tipo_doc,  rd.periodo,
					               rd.ruta,    rd.no_docu,  i.linea_ext,  i.bodega,
					               i.no_arti,  j.no_lote,   j.unidades,
                         0, --- vmonto_lote, En lotes solamente se lleva por unidades, el costo se lo lleva en el detalle del articulo ANR 08/05/2009
                         0);
    END LOOP;  -- lotes del articulo
  END LOOP;  -- lineas de articulos del movimiento
  --
  --
  -- Actualiza el estado del documento

  UPDATE arinme
     SET estado = 'D',
         mov_tot  = vmov_tot,
         mov_tot2 = vmov_tot2  --FEM
   WHERE no_cia  = rd.no_cia
     AND no_docu = rd.no_docu;

  UPDATE arinmeh
     SET mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2  --FEM
   WHERE no_cia  = rd.no_cia
     AND no_docu = rd.no_docu;
   --
EXCEPTION
  WHEN error_proceso THEN
     msg_error_p := NVL(msg_error_p, 'error_proceso en INACT_OBSEQUIO_DONACION');
     RETURN;
  WHEN OTHERS THEN
     msg_error_p := 'INACT_OBSEQUIO_DONACION : ' || SQLERRM;
     Return;
END INACT_OBSEQUIO_DONACION;