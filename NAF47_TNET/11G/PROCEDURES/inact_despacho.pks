create or replace PROCEDURE            inact_despacho (cia_p        IN varchar2,
                                            tipo_p       IN varchar2,
                                            docu_p       IN varchar2,
                                            movimi_p     IN varchar2,
                                            interface_p  IN varchar2,
                                            time_stamp_p IN date,
                                            msg_error_p  IN OUT varchar2) IS
  --
  -- Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  -- tanto solo INactualiza deberia utilizarlo.
  -- La funcion especifica es la de actualizar los documentos de despacho
  -- generados por la facturacion

  -- Lee el documento de despacho que esta pendiente de actualizar.
  CURSOR c_documento IS
    SELECT e.no_cia, e.centro, e.tipo_doc, e.periodo, e.ruta, e.no_docu,
           e.fecha,  e.observ1, e.tipo_cambio,
           e.tipo_refe, e.no_refe, tm.codigo_tercero,
           e.rowid rowid_me
      FROM arinme e, arinvtm tm
     WHERE e.no_cia     = cia_p
       AND e.no_docu    = docu_p
       AND e.tipo_doc   = tipo_p
       AND e.estado     = 'P'
       AND tm.no_cia    = e.no_cia
       AND tm.tipo_m    = e.tipo_doc;
  --
  -- Lineas de compras
  CURSOR c_lineas_doc IS
    SELECT l.linea_ext,
           l.linea,
           l.bodega,
           l.no_arti,
           l.ind_oferta,
           nvl(l.unidades,0) unidades,
           nvl(l.monto,0) monto,
            nvl(l.monto2,0) monto2,
           nvl(l.monto_dol,0) monto_dol,
           nvl(l.monto2_dol,0) monto2_dol,
           d.grupo,
           d.costo_estandar,
           l.rowid rowid_ml,
           l.precio_venta
      FROM arinda d, arinml l, arinma a
     WHERE l.no_cia     = cia_p
       AND l.no_docu    = docu_p
       AND l.tipo_doc   = tipo_p
       AND l.no_cia     = d.no_cia
       AND l.no_arti    = d.no_arti
       AND -- join con arinma
           a.no_cia     = l.no_cia
       AND a.bodega     = l.bodega
       AND a.no_arti    = l.no_arti;
  --
  CURSOR c_lotes ( cia_c varchar2,    tip_c varchar2,    doc_c varchar2,
                   lin_c number
                   ) IS
    SELECT no_lote,                    nvl(unidades,0) unidades,
           0 monto,
           ubicacion, fecha_vence
      FROM arinmo
     WHERE no_cia   = cia_c
       AND no_docu  = doc_c
       AND tipo_doc = tip_c
       AND linea    = lin_c ;

  Cursor C_Arfafe Is
  Select *
  From   Arfafe
  Where  no_cia   = cia_p
  And    no_factu = docu_p;

  --
  rd              C_documento%Rowtype;
  Ln_costo2       arinma.costo_uni%type := 0;
  error_proceso   Exception;
  vtime_stamp     Date;
  rper            inlib.periodo_proceso_r;
  vfound          Boolean;
  vrctas          inlib.cuentas_contables_r;
  vcta_inv        arindc.cuenta%type;         -- cuenta de inventario
  vcta_cv         arindc.cuenta%type;         -- cuenta de costo de ventas
  vtmov_ctaInv    arindc.tipo_mov%type;
  vtmov_ctaCosto  arindc.tipo_mov%type;
  vcosto_art      arinma.costo_uni%type := 0;
  vmov_tot        arinme.mov_tot%type;
  vmov_tot2       arinme.mov_tot%type;  --FEM
  vmonto_lote     Number;
  vcentro_costo   arincc.centro_costo%TYPE;
  Lv_cc           arcgceco.centro%type;

  Fact            C_Arfafe%rowtype;

BEGIN
  --
  If interface_p is null then
     Null;
  End If;
  --
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
  IF movimi_p = 'E' THEN
    msg_error_p := 'El tipo de movimiento de entrada, no es valido en despachos';
  ELSE
    vtmov_ctaInv   := 'C';
    vtmov_ctaCosto := 'D';
  END IF;
  --
  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me,       rper.mes_proce,
                      rper.semana_proce, rper.indicador_sem);
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
    Ln_costo2  := articulo.costo2(cia_p, i.no_arti, i.bodega); --FEM
    vcosto_art := nvl(vcosto_art, 0);

    -- calcula el costo de la salida
     IF rd.tipo_cambio > 0 THEN
      i.monto_dol := nvl(moneda.redondeo(i.monto / rd.tipo_cambio, 'D'), 0);
      i.monto2_dol := nvl(moneda.redondeo(i.monto2 / rd.tipo_cambio, 'D'), 0);
    ELSE
      i.monto_dol := 0;
      i.monto2_dol := 0;
    END IF;
    vmov_tot  := nvl(vmov_tot,0) + i.monto;
    vmov_tot2 := nvl(vmov_tot2,0) + i.monto2;  --FEM
    --
    -- calcula el costo del documento
    UPDATE arinml
       SET monto      = i.monto,
           monto_dol  = i.monto_dol,
           monto2     = i.monto2,
           monto2_dol = i.monto2_dol
     WHERE rowid = i.rowid_ml;
    --
    vcta_inv  := vrctas.cta_inventario;
    vcta_cv   := vrctas.cta_costo_venta;
/*
    Open C_Arfafe;
    Fetch C_Arfafe into Fact;
    If C_Arfafe%notfound Then
     Close C_Arfafe;
      msg_error_p := 'No existe el registro de facturacion para el documento: '||docu_p;
      raise error_proceso;
    else
     Close C_Arfafe;
    end if;
*/

   /*If cuenta_contable.acepta_cc (rd.no_cia, vcta_inv) THEN
				Lv_cc := CC_CCOSTO_SUBCLIENTE(rd.no_cia, Fact.grupo, Fact.no_cliente, Fact.subcliente);
				If Lv_cc is null Then
					msg_error_p := 'El cliente: '||Fact.grupo||' '||Fact.no_cliente||' subcliente: '||Fact.subcliente||' no tiene configurado centro de costos';
					raise error_proceso;
				else
					vcentro_costo := Lv_cc;
			  end if;
		 else
				vcentro_costo := centro_costo.rellenad(rd.no_cia, '0');
		 End if;*/

    --- centro de costo debe ser llamado de grupos, arincc ANR 10/01/2011
     If cuenta_contable.acepta_cc (rd.no_cia, vcta_inv) THEN
				vcentro_costo :=  vrctas.centro_costo;
		 else
				vcentro_costo := centro_costo.rellenad(rd.no_cia, '0');
		 End if;


    --
    -- Movimiento contable a la cuenta de inventario
    INinserta_dc(rd.no_cia,      rd.centro,     rd.tipo_doc,
                 rd.no_docu,     vtmov_ctaInv,  vcta_inv,
                 i.monto,        vcentro_costo,  i.monto_dol,
                 rd.tipo_cambio, rd.codigo_tercero);
       IF vcta_cv IS NULL THEN
        msg_error_p := 'Falta definir cuenta contable de Costo de ventas, '||
                       'para la bodega '||i.bodega||', grupo '||i.grupo;
        RAISE error_proceso;
      END IF;

    --- recupera el centro de costos del subcliente ANR 05/03/2010

   /* If cuenta_contable.acepta_cc (rd.no_cia, vcta_cv) THEN
				Lv_cc := CC_CCOSTO_SUBCLIENTE(rd.no_cia, Fact.grupo, Fact.no_cliente, Fact.subcliente);
				If Lv_cc is null Then
					msg_error_p := 'El cliente: '||Fact.grupo||' '||Fact.no_cliente||' subcliente: '||Fact.subcliente||' no tiene configurado centro de costos';
					raise error_proceso;
				else
					vcentro_costo := Lv_cc;
			  end if;
		 else
				vcentro_costo := centro_costo.rellenad(rd.no_cia, '0');
		 End if;*/

    --- centro de costo debe ser llamado de grupos, arincc ANR 10/01/2011
     If cuenta_contable.acepta_cc (rd.no_cia, vcta_cv) THEN
				vcentro_costo :=  vrctas.centro_costo;
		 else
				vcentro_costo := centro_costo.rellenad(rd.no_cia, '0');
		 End if;



      -- como es una salida del inventario por una venta normal, se genera un debito
      -- a la cuenta contable de costo de ventas
      INinserta_dc(rd.no_cia,      rd.centro,      rd.tipo_doc,
                   rd.no_docu,     vtmov_ctaCosto, vcta_cv,
                   i.monto,        vcentro_Costo,  i.monto_dol,
                   rd.tipo_cambio, rd.codigo_tercero);

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

    -- Inserta en ARINMN la linea que se esta procesando
    INinserta_mn(rd.no_cia,         rd.centro,          rd.tipo_doc,
                 rd.no_docu,        rd.periodo,         rper.mes_proce,
                 rper.semana_proce, rper.indicador_sem, rd.ruta,
                 i.linea_ext,       i.bodega,           i.no_arti,
                 rd.fecha,          i.unidades,         i.monto,
                 null,              rd.tipo_refe,       rd.no_refe,
                 null,              vcosto_art,  --i.monto/i.unidades,
                 vtime_stamp,
                 '000000000',       'N',                i.precio_venta,
                 i.monto2,          Ln_costo2);  --i.monto2); --FEM
    -- actualiza (disminuye) las existencias para los lotes de cada articulo
    FOR j IN c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea----, vcosto_art
    ) LOOP
      vmonto_lote := moneda.redondeo(j.monto, 'P');
      UPDATE arinlo
         SET saldo_unidad   = nvl(saldo_unidad, 0) - j.unidades,
             saldo_contable = 0,
             saldo_monto    = 0
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
      INSERT INTO arinmt(no_cia,   centro,    tipo_doc, ano,
                         ruta,     no_docu,   no_linea, bodega,
                         no_arti,  no_lote,
                         unidades, venta,     descuento )
                  VALUES(rd.no_cia,  rd.centro,   rd.tipo_doc, rd.periodo,
                         rd.ruta,    rd.no_docu,  i.linea_ext, i.bodega,
                       i.no_arti,   j.no_lote,
                         j.unidades, 0,0);
    END LOOP;  -- lotes del articulo
  END LOOP;  -- lineas de articulos del movimiento
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


EXCEPTION
  WHEN error_proceso THEN
     msg_error_p := NVL(msg_error_p, 'error_proceso en Actualiza_despacho');
     RETURN;
  WHEN OTHERS THEN
     msg_error_p := 'ACTUALIZA_DESPACHO : ' || SQLERRM;
     RETURN;
END;