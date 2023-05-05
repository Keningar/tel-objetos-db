create or replace PROCEDURE            INprorratea_montos (
  no_cia_p       IN     varchar2,
  tipo_doc_p     IN     varchar2,
  no_docu_p      IN     varchar2,
  msg_error_p    IN OUT varchar2
) IS
  -- --
  -- Este procedimiento calcula los campos de descuento_l y imp_ventas_l
  -- de la tabla arinml en moneda nominal.  Estos campos corresponden al descuento y al
  -- impuesto de ventas por linea.  Estos campos solo se calcula para las
  -- lineas que sean de un documento compra.
  -- El procedimiento recibe como parametro el numero de compa?ia y el
  -- tipo de documento que se va a actualizar.  Si se quieren actualizar
  -- todos los tipos el valor de tipo_d debe ser '*'.  Si docu es '*' se
  -- actualizan todos los documentos de tipo tipo_d, de lo contrario se
  -- actualizaria el numero de documento docu.
  --
  -- El descuento por linea
  -- se calcula de la forma = (monto de la linea * descuento total)
  --                          -------------------------------------
  --                                   Total de las lineas
  --
  -- El impuesto de ventas se calcula de la forma =
  --
  --     =  0                                    si el articulo no paga
  --                                             impuesto de ventas
  --
  --     =  monto de la linea * impuesto total   si el articulo paga
  --        ----------------------------------   impuesto de ventas
  --        Monto Total de las Lineas de art con I.V.
  --
  --
  -- REQUIERE:
  --   1. Que el procedimiento principal (INactualiza) haya inicilizado el paquete
  --      moneda.
  --
  -- *****
  --
  error_proceso         EXCEPTION;
  --
  -- Definicion de Cursores
  -- ======================
  -- ---
  -- Encabezado de la compra a procesar
  CURSOR c_compras IS
     SELECT decode(e.moneda_refe_cxp, 'P', nvl(e.descuento,0), nvl(e.descuento,0) * e.tipo_cambio) total_desc,
            nvl(e.mov_tot,0)    total_lin,
            e.moneda_refe_cxp   moneda, e.tipo_cambio tipo_cambio
       FROM arinme e
      WHERE e.no_cia     = no_cia_p
        AND e.no_docu    = no_docu_p
        AND e.tipo_doc   = tipo_doc_p;
  --
  -- Lineas de la compra
  CURSOR c_lineas_doc(pcia       varchar2,   ptipo_doc  varchar2,
                      pno_docu   varchar2  ) IS
    SELECT l.linea, nvl(l.monto,0)  monto_linea,
           l.rowid rowid_ml
      FROM arinml l
      WHERE l.no_cia     = pcia
        AND l.no_docu    = pno_docu
        AND l.tipo_doc   = ptipo_doc;
  --
  -- Obtiene los impuestos asociados al documento y los convierte a nominal
  CURSOR c_imp_doc (pcia       varchar2,    ptipo_doc  varchar2,
                    pno_docu   varchar2,    pMoneda    varchar2,
                    pTCambio   number     ) IS
    SELECT clave, porcentaje, codigo_tercero, comportamiento,
           decode(pMoneda, 'P', monto, moneda.redondeo(monto*pTCambio, 'P')) monto,
           decode(pMoneda, 'P', base, moneda.redondeo(base*pTCambio, 'P')) base
      FROM arinri
     WHERE no_cia   = pcia
       AND no_docu  = pno_docu
       AND tipo_doc = ptipo_doc;
  --
  -- Calcula el monto total de las lineas a las que aplica un
  -- Imp. particular (pclave)
  CURSOR c_tot_lineas_iv (pcia       varchar2,     ptipo_doc  varchar2,
                          pno_docu   varchar2,     pclave     varchar2 ) IS
    SELECT sum(nvl(ml.monto,0))
      FROM arinml ml, arinia ia
     WHERE ml.no_cia          = pcia
       AND ml.no_docu         = pno_docu
       AND ml.tipo_doc        = ptipo_doc
       AND nvl(ml.ind_iv,'N') = 'S'
       AND ia.no_cia          = ml.no_cia
       AND ia.no_arti         = ml.no_arti
       AND ia.clave           = pclave;
  --
  -- Lineas del documento que llevan un impuesto especifico
  CURSOR c_lineas_iv (pcia       varchar2,  ptipo_doc  varchar2,
                      pno_docu   varchar2,  pclave     varchar2 ) IS
    SELECT ml.linea,  nvl(ml.monto,0) monto_linea,
           ml.rowid rowid_ml
      FROM arinml ml, arinia ia
     WHERE ml.no_cia           = pcia
       AND ml.no_docu         = pno_docu
       AND ml.tipo_doc        = ptipo_doc
       AND nvl(ml.ind_iv,'N') = 'S'
       AND ia.no_cia          = ml.no_cia
       AND ia.no_arti         = ml.no_arti
       AND ia.clave           = pclave;
  --
  rd                 c_compras%ROWTYPE;
  vfound             boolean;
  vtot_lin_aux       arinme.mov_tot%type;
  vdescto_lin        arinme.mov_tot%type;
  vimpuesto_lin      arinme.mov_tot%type;
  vimpuesto_lin_inc  arinme.mov_tot%type;
  vbase_lin          arinme.mov_tot%type;
  vprecision_descto  number;
  vprecision_imp_v   number;
  vprecision_base_v  number;
  --
  vtot_imp_distrib   arinme.mov_tot%type;

BEGIN -- Calcula_Monto_Lineas
  OPEN  c_compras;
  FETCH c_compras INTO rd;
  vfound := c_compras%FOUND;
  CLOSE c_compras;
  IF vfound THEN
    --
    -- Inicializa los campos de las lineas del documento
    UPDATE arinml
       SET impuesto_l          = 0,
	         impuesto_l_incluido = 0,
           descuento_l         = 0
     WHERE no_cia   = no_cia_p
       AND no_docu  = no_docu_p
       AND tipo_doc = tipo_doc_p;
    --
    -- --
    -- prorratea el descuento
    IF rd.total_desc > 0  THEN
      vtot_lin_aux := nvl(rd.total_lin,0);
      FOR lc IN c_lineas_doc(no_cia_p, tipo_doc_p, no_docu_p) LOOP
        vdescto_lin := moneda.redondea_prorrateo(
                       nvl( rd.total_desc * (lc.monto_linea / vtot_lin_aux), 0),
                       'P',
                       vprecision_descto );
        UPDATE arinml
           SET descuento_l  = nvl(vdescto_lin,0)
         WHERE rowid = lc.rowid_ml
           AND monto > 0;
      END LOOP;
    END IF;
    --
    -- --
    -- Prorratea los impuestos del documento
    --
    FOR r_imp IN c_imp_doc(no_cia_p, tipo_doc_p, no_docu_p, rd.moneda, rd.tipo_cambio) LOOP
      --
      vtot_lin_aux := 0;
      OPEN  c_tot_lineas_iv (no_cia_p, tipo_doc_p, no_docu_p, r_imp.clave);
      FETCH c_tot_lineas_iv INTO vtot_lin_aux;
      CLOSE c_tot_lineas_iv;
      --
      vtot_lin_aux  := nvl(vtot_lin_aux,0);
      IF vtot_lin_aux = 0 AND r_imp.monto != 0 THEN
        msg_error_p := 'No existe ningun articulo al que le corresponda el impuesto: '||r_imp.clave;
        RAISE error_proceso;
      ELSIF vtot_lin_aux > 0 THEN
        vprecision_imp_v  := 0;
        vtot_imp_distrib  := 0;
        FOR lc IN c_lineas_iv(no_cia_p, tipo_doc_p, no_docu_p, r_imp.clave) LOOP
          IF r_imp.comportamiento = 'E' THEN
            vimpuesto_lin     := moneda.redondea_prorrateo(
                                 nvl(r_imp.monto * (lc.monto_linea / vtot_lin_aux), 0),
                                 'P',
                                 vprecision_imp_v);
            vImpuesto_Lin_Inc := 0;
	    ELSE
            vImpuesto_Lin_Inc  := moneda.redondea_prorrateo(
                                  nvl(r_imp.monto * (lc.monto_linea / vtot_lin_aux), 0),
                                  'P',
                                  vprecision_imp_v);
   	      vImpuesto_Lin      := 0;
	    END IF;
          vbase_lin        := moneda.redondea_prorrateo(
                              nvl(r_imp.base * (lc.monto_linea / vtot_lin_aux), 0),
                              'P',
                              vprecision_base_v);
          vimpuesto_lin      := NVL(vimpuesto_lin, 0);
          vimpuesto_lin_inc  := NVL(vimpuesto_lin_inc, 0);
          vtot_imp_distrib   := NVL(vtot_imp_distrib,0) + vimpuesto_lin + vimpuesto_lin_inc;
          --
          INSERT INTO  arinmli(no_cia,         no_docu,    linea,
		                   clave,          monto,      base,
		      	       codigo_tercero, porcentaje)
               VALUES (no_cia_p,       no_docu_p,            lc.linea,
          		     r_imp.clave,
			     decode(r_imp.comportamiento,'E', vimpuesto_lin, vimpuesto_lin_inc),
			     vbase_lin,      r_imp.codigo_tercero, r_imp.porcentaje);
          --
          UPDATE arinml
             SET impuesto_l          = nvl(impuesto_l,0)          + vimpuesto_lin,
	           impuesto_l_incluido = nvl(impuesto_l_incluido,0) + vimpuesto_lin_inc
           WHERE rowid = lc.rowid_ml;
        END LOOP; -- lineas
        --
        IF abs(vtot_imp_distrib - r_imp.monto) > 0.01 THEN
          msg_error_p := 'El impuesto '||r_imp.clave||
                         'no pudo ser prorrateado completamente por una diferencia de '||abs(vtot_imp_distrib - r_imp.monto);
          RAISE error_proceso;
        END IF;
      END IF;
    END LOOP; -- impuesto a nivel de documento
    --
  END IF;
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := NVL( 'INPRORRATEA_MONTOS : '||msg_error_p, 'ERROR EN CALCULA_MONTO_LINEAS');
  WHEN OTHERS THEN
    msg_error_p := 'INPRORRATEA_MONTOS : '||SQLERRM;
END;