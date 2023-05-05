create or replace PROCEDURE            inact_devconsumo (cia_p        IN varchar2,
                                              tipo_p       IN varchar2,
                                              docu_p       IN varchar2,
                                              movimi_p     IN varchar2,
                                              interface_p  IN varchar2,
                                              cta_docu_p   IN varchar2,
                                              time_stamp_p IN date,
                                              msg_error_p  IN OUT varchar2) Is
  --  Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  --  tanto solo INactualiza deberia utilizarlo.
  --  La funcion es actualizar documentos de produccion o
  --  devolucion de producciones

  -- Lee el documento de compra que esta pendiente de actualizar.
  CURSOR c_documento IS
    SELECT e.no_cia, e.centro, e.tipo_doc, e.no_docu,
           e.periodo, e.ruta,
           e.fecha, e.conduce,
           e.observ1, e.tipo_cambio,
           e.tipo_refe, e.no_refe,  e.c_costo_emplesol,
           e.rowid rowid_me
      FROM arinme e
     WHERE e.no_cia     = cia_p
       AND e.no_docu    = docu_p
       AND e.tipo_doc   = tipo_p
       AND e.estado     = 'P';
  --
  -- Lineas de compras
  CURSOR c_lineas_doc IS
    SELECT l.linea_ext, l.linea, l.bodega,
           l.no_arti,
           nvl(l.unidades,0) unidades,
           nvl(l.monto,0) monto,
           nvl(l.monto2,0) monto2,
           (nvl(l.monto,0) - nvl(l.descuento_l,0) + nvl(l.impuesto_l,0)) neto,
           nvl(l.monto_dol,0) monto_dol,
           nvl(l.monto2_dol,0) monto2_dol,
           d.grupo, d.costo_estandar, a.ult_costo,
           l.rowid rowid_ml,L.PRECIO_VENTA,l.centro_costo
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
  --
  CURSOR c_lotes ( cia_c  varchar2,     tip_c  varchar2,    doc_c  varchar2,
                   lin_c  number,       cost   number  ) IS
    SELECT no_lote, nvl(unidades,0) unidades,
           nvl(unidades*cost,0) monto,
           ubicacion, fecha_vence
      FROM arinmo
     WHERE no_cia   = cia_c
	     AND no_docu  = doc_c
	     AND tipo_doc = tip_c
	     AND linea    = lin_c ;

  Cursor c_cuenta(cia varchar2,docu varchar2) is
    SELECT cuenta FROM ARINTIPOCONSUMOINTER
    Where no_cia = cia and codigo in (Select tipo_ci from arinencconsumointer
                                       where no_cia = cia and no_docu_refe = docu);

  --
  error_proceso   EXCEPTION;
  vtime_stamp     date;
  rper            inlib.periodo_proceso_r;
  vfound          boolean;
  vcta_inv        arindc.cuenta%type;
  vcta_haber      arindc.cuenta%type;  -- cta del proveedor o del documento (si mov.no tiene prov)
  vtmov_ctaInv    arindc.tipo_mov%type;
  vtmov_ctaHaber  arindc.tipo_mov%type;
  vsigno          number(2);
  vcosto_art      arinma.costo_uni%type:=0;
  vmov_tot        arinme.mov_tot%type;
  vmov2_tot       arinme.mov_tot%type;    --FEM
  vmonto_lote     number;
  vCosto_unit_ml  arinma.ult_costo%type;
  vUlt_costo      arinma.ult_costo%type;
  vcta_cpartida   arindc.cuenta%type;
  vrctas          inlib.cuentas_contables_r;
  vcentro_costo   arincc.centro_costo%TYPE;
  vtercero_dc     arindc.codigo_tercero%type := NULL;
  rd              c_documento%ROWTYPE;
  Ln_costo2       arinma.costo_uni%type:=0;


BEGIN

  --
  vtime_stamp  := time_stamp_p;
  --
  /* llindao: no se debe validar pues la cuenta contrapartida 
              se lee desde el tipo de consumo
     20-06-2012
  
  IF cta_docu_p is null THEN
    msg_error_p := 'El tipo de documento NO tiene definida cuenta contable...';
    RAISE error_proceso;
  END IF;
  */
  -- Busca el documento a actualizar
  OPEN  c_documento;
  FETCH c_documento INTO rd;
  vfound := c_documento%FOUND;
  CLOSE c_documento;
  IF not vfound THEN
    msg_error_p := 'No fue posible localizar la transaccion: '||docu_p;
    RAISE error_proceso;
  END IF;
  -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);
  -- define el vsigno de la actualizacion y la forma del detalle contable
  open c_cuenta(cia_p,docu_p);
 fetch c_cuenta into vcta_haber;
close c_cuenta;

--  vcta_haber := cta_docu_p;

  IF movimi_p = 'E' THEN
    vsigno         := 1;
    vtmov_ctaInv   := 'D';
    vtmov_ctaHaber := 'C';
  ELSE
    vsigno         := -1;
    vtmov_ctaInv   := 'C';
    vtmov_ctaHaber := 'D';
  END IF;

  --
  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot := 0;
  FOR i IN c_lineas_doc LOOP
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    IF not INLIB.trae_cuenta_inventario(cia_p, i.grupo, i.bodega, vcta_inv) THEN
      msg_error_p := 'Falta definir la cuenta de inventario, '||
                     'para bodega: '||i.bodega||'  grupo: '||i.grupo;
      RAISE error_proceso;
    END IF;

    -- determina el costo unitario del articulo


    -- determina el costo unitario del articulo
    vcosto_art := articulo.costo(cia_p, i.no_arti, i.bodega);
    Ln_costo2  := articulo.costo2(cia_p, i.no_arti, i.bodega); --FEM

    vcosto_art := nvl(vcosto_art, 0);

    -- calcula el costo unitario para el documento
    vCosto_unit_ml := 0;
    IF i.unidades != 0 THEN
      vCosto_unit_ml := nvl(i.neto, 0) / nvl(i.unidades, 0);
    END IF;
    IF movimi_p = 'E' THEN
      vUlt_costo := vCosto_unit_ml;
    ELSE
      vUlt_costo := i.ult_costo;
    END IF;

   --- IF movimi_p = 'S' THEN

      -- calcula el costo de la salida
      i.monto  := nvl(moneda.redondeo( i.unidades * vcosto_art, 'P'), 0);
      i.monto2 := nvl(moneda.redondeo( i.unidades * Ln_costo2, 'P'), 0);

      If rd.tipo_cambio > 0 Then
        i.monto_dol  := nvl(moneda.redondeo(i.monto / rd.tipo_cambio, 'D'), 0);
        i.monto2_dol := nvl(moneda.redondeo(i.monto2 / rd.tipo_cambio, 'D'), 0);
      Else
        i.monto_dol := 0;
        i.monto2_dol := 0;
      End If;
      --
      -- calcula el costo del documento
      UPDATE arinml
         SET monto     = i.monto,
             monto_dol = i.monto_dol,
             monto2    = i.monto2,
             monto2_dol = i.monto2_dol
       WHERE rowid = i.rowid_ml;


    vmov_tot  := nvl(vmov_tot, 0)  + nvl(i.monto,0);
    vmov2_tot  := nvl(vmov2_tot, 0)  + nvl(i.monto2,0);

    --
    -- segun la legislacion colombiana, las cuentas contables usadas para contabilizar los movimientos
    -- de produccion, NO deben manejar tercero.
    IF cuenta_contable.acepta_tercero(cia_p, vcta_inv) THEN
      msg_error_p := 'La cuenta de Inventarios para los articulos en la bodega '||
                     i.bodega||' y grupo '||i.grupo||' no debe manejar terceros';
      RAISE error_proceso;
    END IF;

    IF cuenta_contable.acepta_tercero(cia_p, vcta_haber) THEN
      msg_error_p := 'La cuenta de contrapartida para el tipo de documento '||
                     rd.tipo_doc||' NO debe manejar terceros';
      RAISE error_proceso;
    END IF;

     IF not INLIB.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) THEN
       msg_error_p := 'Falta definir las cuentas contables, '||
                      'para bodega: '||i.bodega||'  grupo: '||i.grupo;
       RAISE error_proceso;
     END IF;
     --
     vcta_inv      := vrctas.cta_inventario;
     vcta_cpartida := vrctas.cta_contrapartida_requi;
     vcentro_costo := vrctas.centro_costo;

     -- movimiento contable a la cuenta de inventario
     INinserta_dc(rd.no_cia,      rd.centro,    rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaInv, vcta_inv,
		              i.monto,        vcentro_costo, i.monto_dol,
				          rd.tipo_cambio, vtercero_dc);
     --
     -- movimiento contable a la cuenta contrapartida
     INinserta_dc(rd.no_cia,      rd.centro,      rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaHaber, vcta_haber, --vcta_cpartida,
		              i.monto,        rd.c_costo_emplesol, i.monto_dol,
				          rd.tipo_cambio, vtercero_dc);

    --
    -- Actualiza el monto de las compra en ARINMA (Maestro de articulos),
    -- el costo unitario del articulo y el ultimo costo.
    INActualiza_saldos_articulo (rd.no_cia, i.bodega, i.no_arti, 'PRODUCCION',
                                 (i.unidades * vsigno), (i.monto * vsigno),
                                 Null, msg_error_p);
    IF msg_error_p is not null THEN
      RAISE error_proceso;
    END IF;

--- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
--- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas

    INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);

    -- Actualiza el Historico de produccion
    UPDATE arinhp
       SET unidades = nvl(unidades,0) + (i.unidades * vsigno),
           monto    = nvl(monto,0)    + (i.monto * vsigno)
     WHERE no_cia    = rd.no_cia
		   AND centro    = rd.centro
		   AND periodo   = rd.periodo
		   AND no_arti   = i.no_arti;
    --
    IF SQL%NotFound THEN
      INSERT INTO arinhp(no_cia, centro, periodo,  no_arti, unidades, monto)
                  VALUES(rd.no_cia,   rd.centro, rd.periodo,        i.no_arti, (i.unidades * vsigno), (i.monto * vsigno));
    END IF;

    -- Inserta en ARINMN la linea que se esta procesando
    INinserta_mn(rd.no_cia,     rd.centro,      rd.tipo_doc,       rd.no_docu,
                 rd.periodo,    rper.mes_proce, rper.semana_proce, rper.indicador_sem,
		       		   rd.ruta,       i.linea_ext,    i.bodega,          i.no_arti,
                 rd.fecha,      i.unidades,     i.monto,           null,
                 rd.tipo_refe,  rd.no_refe,     null,              vcosto_art, --i.monto/i.unidades,
                 vtime_stamp,   '000000000',    'N',               I.PRECIO_VENTA,
                 i.monto2,      Ln_costo2);

    -- se efectua las actualizaciones para el desglose de los lotes de articulos.
    For j in c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea, vcosto_art) Loop
      vmonto_lote := moneda.redondeo(j.monto, 'P');
      Update arinlo
         Set saldo_unidad   = nvl(saldo_unidad, 0) + (j.unidades * vsigno),
             saldo_contable = 0,---nvl(saldo_contable, 0) + (j.unidades * vsigno), valores en monto va en cero ANR 18/06/2009
             saldo_monto    = 0--- nvl(saldo_monto, 0) + (vmonto_lote * vsigno)
       Where no_cia = rd.no_cia
		     And bodega = i.bodega
			   And no_arti = i.no_arti
			   And no_lote = j.no_lote;
      --
      If (sql%rowcount = 0) Then
        Insert Into arinlo(no_cia,         bodega,
		                       no_arti,        no_lote,     ubicacion,   saldo_unidad,
							             saldo_contable, saldo_monto, salida_pend, costo_lote,
							             proceso_toma,   exist_prep,  costo_prep,
                           fecha_entrada,  fecha_vence, fecha_fin_cuarentena )
                    Values(rd.no_cia,      i.bodega,    i.no_arti,   j.no_lote,
                           j.ubicacion,    j.unidades,  0,0,---j.unidades,  vmonto_lote,valores en monto va en cero ANR 18/06/2009
                           0,        0,---      vmonto_lote / j.unidades, valores en monto va en cero ANR 18/06/2009
                           'N',
                           null,           null,         rd.fecha,   j.fecha_vence,
                           null);
      END IF;
      -- Inserta en ARINMT la linea que se esta procesando
      INSERT INTO arinmt(no_cia,   centro,    tipo_doc,  ano,
		                     ruta,     no_docu,   no_linea,  bodega,
						             no_arti,   no_lote,
						             unidades, venta,     descuento)
                  VALUES(rd.no_cia,  rd.centro,   rd.tipo_doc, rd.periodo,
   					             rd.ruta,    rd.no_docu,  i.linea_ext, i.bodega,
					               i.no_arti,   j.no_lote,
					               j.unidades, 0,           0);
    END LOOP;  -- lotes de articulos
  END LOOP; -- Lineas del documento
  --
  --
  -- Actualiza el estado del documento
  UPDATE arinme
     SET estado  = 'D',
         mov_tot  = vmov_tot,
         mov_tot2 = vmov2_tot  --FEM
   WHERE rowid = rd.rowid_me;

  UPDATE arinmeh
     SET mov_tot = vmov_tot,
         mov_tot2 = vmov2_tot  --FEM
     where no_cia = cia_p
     and   no_docu = docu_p;

EXCEPTION
  WHEN cuenta_contable.error THEN
       msg_error_p := cuenta_contable.ultimo_error;
       return;
  WHEN error_proceso THEN
       msg_error_p := NVL(msg_error_p, 'Error_proceso en Actualiza_produccion');
       return;
  WHEN others THEN
       msg_error_p := 'INACT_PRODUCCION '|| SQLERRM;
       return;
END;