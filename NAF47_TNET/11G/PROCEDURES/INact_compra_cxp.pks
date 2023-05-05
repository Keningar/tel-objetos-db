create or replace PROCEDURE            INact_compra_cxp (
  pcia           IN     VARCHAR2,
  ptipo_doc_inv  IN     VARCHAR2,
  pno_docu_inv   IN     VARCHAR2,
  pmsg_error     IN OUT VARCHAR2
) IS
  -- ---
  -- Este procedimiento genera facturas (compras) y notas de debito (devoluciones)
  -- a Cuentas por Pagar y actualiza los saldos de los proveedores.
  --
  -- ****
  --
  -- Definicion de Cursores
  -- ======================
  CURSOR c_documento IS
    SELECT e.no_docu, e.fecha,
           to_number(to_char(e.fecha,'YYYY')) ano_doc,
           to_number(to_char(e.fecha,'MM'))   mes_doc,
           e.no_prove, e.tipo_refe, e.no_refe, e.serie_refe,
           e.tipo_cambio, e.moneda_refe_cxp,
           (decode(e.moneda_refe_cxp, 'P', e.mov_tot, moneda.redondeo(e.mov_tot/e.tipo_cambio, 'D')) -
              nvl(e.descuento,0) + nvl(e.imp_ventas,0)) total_doc,
           nvl(e.imp_ventas,0) impuestos, m.movimi,
           e.imp_ventas tot_imp, e.imp_incluido tot_imp_incluido,
           e.monto_bienes, e.monto_serv, e.monto_importac, e.n_docu_d,
           e.no_fisico, e.serie_fisico
      FROM arinme e, arinvtm m
     WHERE e.no_cia   = pcia
       AND e.no_docu  = pno_docu_inv
       AND e.tipo_doc = ptipo_doc_inv
       AND e.estado   = 'P'
       AND e.no_cia   = m.no_cia
       AND e.tipo_doc = m.tipo_m;
  --
  CURSOR c_datos_prove(pcia VARCHAR2, pno_prove VARCHAR2) IS
    SELECT nvl(plazo_c, 0)
      FROM arcpmp
     WHERE no_cia   = pcia
       AND no_prove = pno_prove;
  --
  -- Obtiene el tipo de movimiento (Debito,Credito) del documento
  CURSOR c_tipo_doc_cp(ptipo_refe VARCHAR2) IS
    SELECT tipo_mov
      FROM arcptd
     WHERE no_cia   = pcia
       AND tipo_doc = ptipo_refe;
  --
  --
   CURSOR c_codigo_diario(pTipo_refe arinme.tipo_refe%type) IS
    SELECT cod_diario
      FROM arcptd
     WHERE no_cia   = pCia
       AND tipo_doc = pTipo_refe;

  --
  -- Obtenemos el mes y ano en proceso de CXP
  CURSOR c_periodo_cp IS
    SELECT mes_proc, ano_proc
      FROM arcpct
     WHERE no_cia = pcia;

  --
  -- Datos de la factura que genero la entrada referenciada
  -- La factura/NC se graba en cxp con el mismo numero del doc que lo origino
  CURSOR c_refe_factu (pNo_docu_D arinme.no_docu%TYPE) IS
    SELECT b.tipo_doc,  b.no_docu,      b.moneda,  b.saldo,
           b.no_fisico, b.serie_fisico, b.ind_act, b.anulado,
           b.no_prove
      FROM arinme a, arcpmd b
     WHERE a.no_cia      = pCia
       AND a.no_docu     = pNo_docu_D
       AND b.no_cia  (+) = a.no_cia
       AND b.no_docu (+) = a.no_docu;

  -- Calcula el monto gravado y el monto excento basado en las columnas
  -- impuesto_l e impuesto_l_incluido de arinml. Si alguna de tiene valor
  -- se considera que es gravada. En caso contrario, se toma la linea
  -- como monto excento.
  CURSOR c_gravado (pNo_docu arinme.no_docu%TYPE,
                    pMoneda  arinme.moneda_refe_cxp%TYPE) IS
    SELECT nvl(sum(decode(pMoneda, 'P', monto, monto_dol)), 0) gravado
      FROM arinml
     WHERE no_cia  = pCia
       AND no_docu = pNo_docu
       AND ( (impuesto_l          IS NOT NULL AND impuesto_l          > 0) OR
             (impuesto_l_incluido IS NOT NULL AND impuesto_l_incluido > 0) );

  CURSOR c_excentos (pNo_docu arinme.no_docu%TYPE,
                     pMoneda  arinme.moneda_refe_cxp%TYPE) IS
    SELECT nvl(sum(decode(pMoneda, 'P', monto, monto_dol)), 0) excentos
      FROM arinml
     WHERE no_cia  = pCia
       AND no_docu = pNo_docu
       AND (impuesto_l          IS NULL OR impuesto_l          = 0)
       AND (impuesto_l_incluido IS NULL OR impuesto_l_incluido = 0);
  --
  --
  rDoc           c_documento%ROWTYPE;
  rFactu         c_refe_factu%ROWTYPE;
  --
  vFound         BOOLEAN;
  --
  vplazo         arcpmp.plazo_c%TYPE;
  vfecha_vence   DATE;
  vtipo_doc_mov  arcptd.tipo_mov%TYPE;
  vcod_diario    arinmc.cod_Diario%TYPE;
  vano_proc_cxp  arcpct.ano_proc%TYPE;
  vmes_proc_cxp  arcpct.mes_proc%TYPE;
  vind_om        arcpmd.ind_otros_meses%TYPE;
  --
  vsaldo         arcpmd.saldo%TYPE;
  vtot_refer     arcpmd.tot_refer%TYPE;
  vMonto_refe    arcprd.monto_refe%TYPE;
  vGravado       arcpmd.gravado%TYPE;
  vExcentos      arcpmd.excentos%TYPE;
  --
  error_proceso  EXCEPTION;
  --


BEGIN -- Genera_docs_CXP
  --
  OPEN  c_documento;
  FETCH c_documento INTO rdoc;
  vfound := c_documento%FOUND;
  CLOSE c_documento;
  --
  IF NOT vfound THEN
    pmsg_error := 'No existe el documento de compra para registrar en CxP';
    RAISE error_proceso;
  END IF;
  --
  OPEN  c_tipo_doc_cp(rdoc.tipo_refe);
  FETCH c_tipo_doc_cp INTO vtipo_doc_mov;
  CLOSE c_tipo_doc_cp;
  --
  OPEN  c_codigo_diario(rdoc.tipo_refe);
  FETCH c_codigo_diario INTO vCod_diario;
  CLOSE c_codigo_diario;
  --
  OPEN  c_periodo_cp;
  FETCH c_periodo_cp INTO vmes_proc_cxp, vano_proc_cxp;
  CLOSE c_periodo_cp;
  --
  IF ((vano_proc_cxp*100) + vmes_proc_cxp) > ((rdoc.ano_doc * 100) + rdoc.mes_doc) THEN
    vind_om := 'S';
  ELSE
    vind_om := 'N';
  END IF;
  --
  IF vtipo_doc_mov = 'C' THEN
    -- Factura (entrada de compras)
    OPEN  c_datos_prove(pcia, rdoc.no_prove);
    FETCH c_datos_prove INTO vplazo;
    vfound := c_datos_prove%FOUND;
    CLOSE c_datos_prove;

    IF NOT vfound THEN
      pmsg_error := 'El proveedor: '||rdoc.no_prove||' no esta definido';
      RAISE error_proceso;
    END IF;

    vsaldo       := rdoc.total_doc;
    vtot_refer   := 0;
    vfecha_vence := rdoc.fecha + vplazo;

  ELSE -- Debito (Devolucion)
    vsaldo         := -1*rdoc.total_doc; -- En la moneda de la devolucion
    vtot_refer     := 0;                 -- En la moneda de la devolucion
    vMonto_refe    := 0;                 -- En la moneda de la factura referenciada
    vfecha_vence   := NULL;

    --
    -- Trae los datos de la factura que genero la entrada de compras a devolver
    -- para insertar la referencia de la NC.
    IF rdoc.n_docu_d IS NOT NULL THEN

      -- Datos de la entrada de compras referenciada
    	OPEN  c_refe_factu(rdoc.n_docu_d);
    	FETCH c_refe_factu INTO rFactu;
    	vFound := c_refe_factu%FOUND;
    	CLOSE c_refe_factu;

      IF NOT vFound THEN
        pmsg_error := 'No se encontro en la entrada referenciada '||
                      ptipo_doc_inv||' '||rdoc.no_fisico||'-'||rdoc.serie_fisico;
        RAISE error_proceso;
      END IF;

      IF rFactu.no_prove IS NULL THEN
        pmsg_error := 'La entrada referenciada no afecto CxP';
        RAISE error_proceso;
      END IF;

      IF rFactu.no_prove <> rdoc.no_prove THEN
        pmsg_error := 'El proveedor de la devolucion ('||rdoc.no_prove||
                      ') no coincide con el de la entrada ('||rFactu.no_prove||')';
        RAISE error_proceso;
      END IF;

      IF rFactu.no_docu IS NULL THEN
        pmsg_error := 'No se encontro en CxP la factura generada por la entrada '||
                      ptipo_doc_inv||' '||rdoc.no_fisico||'-'||rdoc.serie_fisico;
        RAISE error_proceso;
      END IF;

      -- Calcula el saldo y el monto de la referencia
      IF (rFactu.ind_act         <> 'P') AND
      	 (nvl(rFactu.anulado,'N') = 'N') AND
      	 (rFactu.saldo            >  0 ) THEN

        -- Calcula el monto referenciado en la moneda de la factura
        IF rdoc.moneda_refe_cxp <> rFactu.moneda THEN

      	  IF rdoc.moneda_refe_cxp = 'P' THEN
      	  	-- La Factura en Dolares, la Devolucion en Nominal
      	  	-- vsaldo y vtot_refer en la moneda de la devolucion
      	  	-- vtot_refer en la moneda de la factura
          	vsaldo      := least(moneda.redondeo(rFactu.saldo*rdoc.tipo_cambio, 'P') - rDoc.total_doc, 0);
          	vtot_refer  := least(moneda.redondeo(rFactu.saldo*rdoc.tipo_cambio, 'P'),  rDoc.total_doc);

      	    vMonto_refe := least(rFactu.saldo, moneda.redondeo(rDoc.total_doc/rdoc.tipo_cambio, 'D'));
  	      ELSE
      	  	-- La factura en nominal, la devolucion en dolares
          	vsaldo      := least(moneda.redondeo(rFactu.saldo/rdoc.tipo_cambio, 'D') - rDoc.total_doc, 0);
          	vtot_refer  := least(moneda.redondeo(rFactu.saldo/rdoc.tipo_cambio, 'D'),  rDoc.total_doc);

      	    vMonto_refe := least(rFactu.saldo, moneda.redondeo(rDoc.total_doc*rdoc.tipo_cambio, 'P'));
    	    END IF;

      	ELSE -- La factura y la devolucion son de la misma moneda
        	vsaldo      := least(rFactu.saldo - rDoc.total_doc, 0);
        	vtot_refer  := least(rFactu.saldo,  rDoc.total_doc);
        	vMonto_refe := vtot_refer;
  	    END IF;

      END IF;

    END IF;

  END IF;

  --
  -- Trae el monto gravado y el monto excento
  OPEN  c_gravado(pno_docu_inv, rdoc.moneda_refe_cxp);
  FETCH c_gravado INTO vGravado;
  CLOSE c_gravado;

  OPEN  c_excentos(pno_docu_inv, rdoc.moneda_refe_cxp);
  FETCH c_excentos INTO vExcentos;
  CLOSE c_excentos;

  --
  -- Crea el documento en CxP
  INSERT INTO arcpmd(no_cia,        no_docu,          no_prove,    tipo_compra,
              tipo_doc,             ind_act,          ind_otros_meses,
              fecha,                fecha_documento,  fecha_vence,
	      fecha_vence_original, subtotal,         monto,
	      saldo,                moneda,           tipo_cambio,
	      t_camb_c_v,           tot_db,           tot_cr,
	      no_fisico,            serie_fisico,     cod_diario,
	      monto_bienes,         monto_serv,       monto_importac,
	      tot_imp, 			        tot_imp_especial, origen,
	      tot_refer,            gravado,          excentos,
	      plazo_c, detalle, factura_eventual)
       VALUES(pcia,              pno_docu_inv,                  rdoc.no_prove,   'B',
              rdoc.tipo_refe,    'P',                           vind_om,
              rdoc.fecha,        rdoc.fecha,                    vfecha_vence,
              vfecha_vence,      rdoc.total_doc-rdoc.impuestos, rdoc.total_doc,
	      vsaldo,            rdoc.moneda_refe_cxp,          rdoc.tipo_cambio,
	      'V',               0,                  			      0,
	      rdoc.no_refe,      rdoc.serie_refe,      		      vcod_Diario,
	      rdoc.monto_bienes, rdoc.monto_serv,               rdoc.monto_importac,
	      rdoc.tot_imp,      rdoc.tot_imp_incluido,         'IN',
	      vtot_refer,        vGravado,                      vExcentos,
	      vplazo, 'RECEPCION DE MERCADERIA. TRANSACCION INVENTARIOS: '||ptipo_doc_inv||' '||pno_docu_inv,'N');

  --
  -- Insertamos los impuestos asociados al documento
  INSERT INTO arcpti (no_cia,   no_docu,        no_prove,
                      tipo_doc, clave,          porcentaje,
	                    monto,  	ind_imp_ret,    aplica_cred_fiscal,
		                  base,     codigo_tercero, comportamiento,
		                  id_sec,   no_refe )
       SELECT pcia,           pno_docu_inv,   rdoc.no_prove,
	            rdoc.tipo_refe, clave,          porcentaje,
			        monto,          ind_imp_ret,    nvl(aplica_cred_Fiscal, 'S'),
  			      base,           codigo_tercero, comportamiento,
 			        id_sec,         pno_docu_inv
         FROM arinri
        WHERE no_cia   = pcia
          AND no_docu  = pno_docu_inv
          AND tipo_doc = ptipo_doc_inv;

  --
  -- Inserta una referencia a la factura de la entrada de compras que se va a devolver
  -- Si la factura esta pendiente, o anulada, no se genera referencia
  IF (vtipo_doc_mov   = 'D') AND (rFactu.no_docu IS NOT NULL)    AND
  	 (rFactu.ind_act <> 'P') AND (nvl(rFactu.anulado,'N') = 'N') AND
  	 (vtot_refer      >  0 ) THEN

    INSERT INTO arcprd(no_cia, tipo_doc, no_docu, tipo_refe, no_refe,
                       monto, descuento_pp, monto_refe, moneda_refe, fec_aplic,
                       mes, ano)
                VALUES(pCia, rdoc.tipo_refe, pno_docu_inv, rFactu.tipo_doc, rFactu.no_docu,
                       vtot_refer, 0, vMonto_refe, rFactu.moneda, rdoc.fecha,
                       to_char(rdoc.fecha, 'MM'), to_char(rdoc.fecha, 'YYYY'));

  END IF;


EXCEPTION
  WHEN error_proceso THEN
    pmsg_error := 'INACT_COMPRA_CXP : '||pmsg_error;
    RETURN;
  WHEN OTHERS THEN
    pmsg_error := 'INACT_COMPRA_CXP : '||sqlerrm;
    RETURN;
END;