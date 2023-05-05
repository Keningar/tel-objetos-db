create or replace procedure            INACT_BAJA_MAL_ESTADO (cia_p         in varchar2,
                                                   tipo_p        in varchar2,
                                                   docu_p        in varchar2,
                                                   movimi_p      in varchar2,
                                                   interface_p   in varchar2,
                                                   cta_docu_p    in varchar2,
                                                   time_stamp_p  in date,
                                                   msg_error_p   in out varchar2) Is
  --
  -- Creado por Jorge Heredia
  -- Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  -- tanto solo INactualiza deberia utilizarlo.
  -- La funcion especifica es la de actualizar los documentos generados
  -- por Baja por mal estado.

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

  -- Lineas de Baja
  CURSOR c_lineas_doc IS
    SELECT l.linea_ext, l.linea,   l.bodega,     l.no_arti, l.ind_oferta, nvl(l.unidades,0) unidades,
			     nvl(l.monto,0) monto,
			     nvl(l.monto2,0) monto2,
           nvl(l.monto_dol,0) monto_dol,
           nvl(l.monto2_dol,0) monto2_dol,
           d.grupo,     d.costo_estandar, a.costo_uni,
			     l.rowid rowid_ml,l.precio_venta
      FROM arinda d, arinml l, arinma a
     WHERE l.no_cia     = cia_p
	     AND l.no_docu    = docu_p
	     AND l.tipo_doc   = tipo_p
	     AND l.no_cia     = d.no_cia
	     AND l.no_arti    = d.no_arti
	     AND a.no_cia     = l.no_cia
	     AND a.bodega     = l.bodega
	     AND a.no_arti    = l.no_arti;

  CURSOR c_lotes ( cia_c varchar2,    tip_c varchar2,    doc_c varchar2,
                   lin_c number,      cost  number  ) IS
    SELECT no_lote,                    nvl(unidades,0) unidades,
           nvl(unidades*cost,0) monto, ubicacion, fecha_vence
      FROM arinmo
     WHERE no_cia   = cia_c
       AND no_docu  = doc_c
       AND tipo_doc = tip_c
       AND linea    = lin_c ;

  error_proceso   Exception;
  vtime_stamp     Date;
  rper            inlib.periodo_proceso_r;
  vfound          Boolean;
  vrctas          inlib.cuentas_contables_r;
  vcta_inv        arindc.cuenta%type;         -- cuenta de inventario
  vcta_cpartida   arindc.cuenta%type;         -- cuenta de costo de ventas
  vcta_co         arindc.cuenta%type;         -- cuenta de costo por oferta
  vtmov_ctaInv    arindc.tipo_mov%type;
  vtmov_ctaCosto  arindc.tipo_mov%type;
  vcosto_art      number;
  vmov_tot        arinme.mov_tot%type;
  vmov2_tot       arinme.mov_tot%type;
  vmonto_lote     number;
  vcentro_costo   arincc.centro_costo%TYPE;
  vtercero        argemt.codigo_tercero%type := NULL;
  rd              c_documento%ROWTYPE;
  ln_costo2       arinma.costo_uni%type := NULL;

BEGIN
  --
  If interface_p is null then
    Null;
  End If;

  vtime_stamp  := time_stamp_p;
  -- Busca el documento a actualizar
  OPEN  c_documento;
  FETCH c_documento INTO rd;
  vfound := c_documento%FOUND;
  CLOSE c_documento;

  IF not vfound THEN
    msg_error_p := 'ERROR: No fue posible localizar la transaccion: '||docu_p;
    RAISE error_proceso;
  END IF;
  --
  -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);
  -- define el vsigno de la actualizacion y la forma del detalle contable
  vcta_cpartida := cta_docu_p;

  IF movimi_p = 'E' THEN
  	msg_error_p := 'El tipo de movimiento de entrada, no es valido en este tipo de documento';
  ELSE
    vtmov_ctaInv   := 'C';
    vtmov_ctaCosto := 'D';
  END IF;
  --
  -- Crea el documento en el historico de encabezado de documento basado en ARINME
  INcrea_encabezado_h(rd.rowid_me,       rper.mes_proce,
                      rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot  := 0;
  vmov2_tot  := 0;
  --
  FOR i IN c_lineas_doc LOOP  -- lineas de articulos del movimiento
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    IF not INLIB.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) THEN
      msg_error_p := 'Falta definir las cuentas contables, '||
                     'para bodega: '||i.bodega||'  grupo: '||i.grupo;
      RAISE error_proceso;
    END IF;
    -- determina el costo unitario del articulo a su precio actual
    vcosto_art := articulo.costo_mal_estado(cia_p, i.no_arti, i.bodega, ln_costo2);
    vcosto_art := nvl(vcosto_art, 0);
    Ln_costo2  := articulo.costo2(cia_p, i.no_arti, i.bodega);

    -- calcula el costo de la salida con el precio actual del articulo
    i.monto := nvl(moneda.redondeo( i.unidades * vcosto_art, 'P'), 0);
    i.monto2 := nvl(moneda.redondeo( i.unidades * Ln_costo2, 'P'), 0);
    --
    If rd.tipo_cambio > 0 Then
      i.monto_dol := nvl(moneda.redondeo(i.monto / rd.tipo_cambio, 'D'), 0);
      i.monto2_dol := nvl(moneda.redondeo(i.monto2 / rd.tipo_cambio, 'D'), 0);
    Else
      i.monto_dol := 0;
      i.monto2_dol := 0;
    End If;

    -- Acumula el total de las lineas del detalle
    vmov_tot   := nvl(vmov_tot,0) + i.monto;
    vmov2_tot   := nvl(vmov2_tot,0) + i.monto2;
    --
    -- Actualiza el precio de salida para el articulo en el detalle
    UPDATE arinml
       SET monto      = i.monto,
           monto_dol  = i.monto_dol,
           monto2     = i.monto2,
           monto2_dol = i.monto2_dol
     WHERE rowid = i.rowid_ml;
    --
    vcta_inv  := vrctas.cta_inventario;
    vcta_co   := vrctas.cta_costo_oferta;
    vcentro_costo := vrctas.centro_costo;
    --
    -- Movimiento contable a la cuenta de inventario(Mov. Credito)
    INinserta_dc(rd.no_cia,      rd.centro,     rd.tipo_doc,
                 rd.no_docu,     vtmov_ctaInv,  vcta_inv,
		        	   i.monto,        vcentro_costo,
                 i.monto_dol,    rd.tipo_cambio, vtercero);

    -- como es una salida del inventario por Baja por mal estado, se genera un debito
    -- a la cuenta contable de contrapartida asociada al tipo de documento
    INinserta_dc(rd.no_cia,      rd.centro,      rd.tipo_doc,
                 rd.no_docu,     vtmov_ctaCosto, vcta_cpartida,
	               i.monto,        rd.c_costo_emplesol,
                 i.monto_dol,    rd.tipo_cambio, vtercero);

    -- *********************************************************
    --
    --
    -- Actualiza el monto y las unidades de las ventas en ARINMA (Maestro de articulos)
    -- Como es un despacho por una venta realizada, tienen que aumentar las ventas
    INActualiza_saldos_articulo (rd.no_cia, i.bodega, i.no_arti, 'DESPACHO',
                                 i.unidades, i.monto, rd.fecha, msg_error_p);
    IF msg_error_p is not null THEN
      RAISE error_proceso;
    END IF;

    --- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
    --- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas

    INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);

    --
    --
    -- Inserta en ARINMN la linea que se esta procesando
    -- (Inventarios) Historico de detalle de lineas del Inventario
    INinserta_mn(rd.no_cia,         rd.centro,          rd.tipo_doc,
	               rd.no_docu,        rd.periodo,         rper.mes_proce,
		        	   rper.semana_proce, rper.indicador_sem, rd.ruta,
                 i.linea_ext,       i.bodega,           i.no_arti,
                 rd.fecha,          i.unidades,         i.monto,
                 null,              rd.tipo_refe,       rd.no_refe,
                 null,              vcosto_art,         -- i.monto/i.unidades,
                 vtime_stamp,
                 '000000000',       'N',                i.precio_venta,
                 i.monto2,          Ln_costo2);  --FEM

    -- actualiza (disminuye) las existencias para los lotes de cada articulo
    FOR j IN c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea, vcosto_art) LOOP  -- lotes del articulo

      vmonto_lote := moneda.redondeo(j.monto, 'P');
      UPDATE arinlo
         SET saldo_unidad   = nvl(saldo_unidad, 0) - j.unidades,
             saldo_contable = 0, ---nvl(saldo_contable, 0) - j.unidades, valores en monto va en cero ANR 18/06/2009
             saldo_monto    = 0 ---nvl(saldo_monto, 0) - vmonto_lote
       WHERE no_cia   = rd.no_cia
		     AND bodega   = i.bodega
			   AND no_arti  = i.no_arti
			   AND no_lote  = j.no_lote;
      --
      IF (sql%rowcount = 0) THEN
        msg_error_p := 'No existe lote: '||j.no_lote||' articulo: '||i.no_arti||
                       ', por Obserquios/Donaciones: '||rd.no_docu;
        RAISE error_proceso;
      END IF;
      --
    END LOOP;  -- lotes del articulo

  END LOOP;  -- lineas de articulos del movimiento
  --
  --
  -- Actualiza el estado del documento
  UPDATE arinme
     SET estado = 'D',
         mov_tot = vmov_tot,
         mov_tot2 = vmov2_tot
   WHERE rowid = rd.rowid_me;

  UPDATE arinmeh
     SET mov_tot = vmov_tot,
         mov_tot2 = vmov2_tot
   WHERE no_cia = rd.no_cia
     AND no_docu = rd.no_docu;
   --
Exception
  WHEN error_proceso THEN
     msg_error_p := NVL(msg_error_p, 'error_proceso en INAct_Baja_mal_estado');
     RETURN;
  WHEN OTHERS THEN
     msg_error_p := 'INACT_BAJA_MAL_ESTADO : ' || SQLERRM;
     RETURN;
END INACT_BAJA_MAL_ESTADO;