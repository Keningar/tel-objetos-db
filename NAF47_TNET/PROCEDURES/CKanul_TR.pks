CREATE OR REPLACE PROCEDURE NAF47_TNET.CKanul_TR(pno_cia     IN VARCHAR2,
                                      pno_transa  IN VARCHAR2,
                                      pno_cta     IN VARCHAR2,
                                      msg_error_p IN OUT VARCHAR2) IS
  vfound     BOOLEAN;
  vf_anula   arckmm.fecha_anulado%TYPE;
  vtot_monto NUMBER;
  --
  error_proceso EXCEPTION;
  --
  CURSOR c_datos_ce IS
    SELECT no_cta,
           tipo_docu,
           fecha,
           monto,
           tot_ref,
           beneficiario,
           moneda_cta,
           tipo_cambio,
           cheque,
           no_prove,
           id_prov_orden,
           ind_con,
           TO_CHAR(fecha, 'RRRR') ano,
           TO_CHAR(fecha, 'MM') mes,
           ind_act,
           NVL(emitido, 'N') emitido,
           NVL(anulado, 'X') anulado,
           ROWID
      FROM arckce
     WHERE no_cia = pno_cia
       AND no_secuencia = pno_transa;
  --
  CURSOR c_datos_mm IS
    SELECT estado,
           conciliado,
           mes,
           ano,
           ROWID
      FROM arckmm
     WHERE no_cia = pno_cia
       AND no_docu = pno_transa;
  --
  CURSOR c_datos_cta(pno_cta VARCHAR2) IS
    SELECT ano_proc,
           mes_proc
      FROM arckmc
     WHERE no_cia = pno_cia
       AND no_cta = pno_cta;
  --
  CURSOR c_doc_cxp(pno_cta VARCHAR2) IS
    SELECT no_docu,
           tipo_doc,
           monto
      FROM arcpmd
     WHERE no_cia = pno_cia
       AND no_secuencia = pno_transa
       AND no_cta = pno_cta;
  -- llindao: 2012-09-21
  CURSOR C_SALDO_OC_LOCAL(Cv_NoOrdenCompra VARCHAR2,
                          Cv_NoCia         VARCHAR2) IS
    SELECT A.NO_CIA,
           A.NO_ORDEN,
           A.VALOR_PAGADO
      FROM TAPORDEE A
     WHERE A.NO_ORDEN = Cv_NoOrdenCompra
       AND A.NO_CIA = Cv_NoCia;
  -- llindao: 2012-09-21
  CURSOR C_ORDEN_COMPRA_LOCAL(Cv_NoDocumento   VARCHAR2,
                              Cv_TipoDocumento VARCHAR2,
                              Cv_NoCia         VARCHAR2) IS
    SELECT A.COMPANIA,
           A.NO_DOCUMENTO_ORIGEN,
           A.NO_DOCUMENTO,
           SUM(A.MONTO) MONTO
      FROM CK_DOCUMENTO_ORIGEN A
     WHERE A.NO_DOCUMENTO = Cv_NoDocumento
       AND A.TIPO_DOCUMENTO = Cv_TipoDocumento
       AND A.COMPANIA = Cv_NoCia
     GROUP BY A.COMPANIA,
              A.NO_DOCUMENTO_ORIGEN,
              A.NO_DOCUMENTO;
  -- llindao: 2012-09-21
  CURSOR C_FACTURAS_ORDENES(Cv_NoDocumento   VARCHAR2,
                            Cv_TipoDocumento VARCHAR2,
                            Cv_NoCia         VARCHAR2) IS
    SELECT A.COMPANIA,
           A.NO_DOCUMENTO_ORIGEN,
           A.NO_DOCUMENTO,
           SUM(ROUND((A.MONTO * ((C.MONTO * 100) / B.MONTO_NOMINAL)) / 100, 2)) MONTO
      FROM CP_DOCUMENTO_ORIGEN A,
           ARCPMD              B,
           ARCKRD              C,
           ARCKCE              D
     WHERE A.NO_DOCUMENTO = B.NO_DOCU
       AND A.TIPO_DOCUMENTO = B.TIPO_DOC
       AND A.COMPANIA = B.NO_CIA
       AND B.NO_DOCU = C.NO_REFE
       AND B.TIPO_DOC = C.TIPO_REFE
       AND B.NO_CIA = C.NO_CIA
       AND C.NO_SECUENCIA = D.NO_SECUENCIA
       AND C.TIPO_DOCU = D.TIPO_DOCU
       AND C.NO_CIA = D.NO_CIA
       AND D.NO_SECUENCIA = Cv_NoDocumento
       AND D.TIPO_DOCU = Cv_TipoDocumento
       AND D.NO_CIA = Cv_NoCia
       AND B.IND_ACT IN ('D', 'M', 'A') -- SOLO ESTOS ESTADOS POR COMP ELECTRONICOS
       AND B.ANULADO != 'S'
     GROUP BY A.COMPANIA,
           A.NO_DOCUMENTO_ORIGEN,
           A.NO_DOCUMENTO;
  -- llindao: 2012-09-21
  Lr_Saldo    C_SALDO_OC_LOCAL%ROWTYPE := NULL;
  Lb_EsOrigen BOOLEAN := FALSE;
  --
  vrce  c_datos_ce%ROWTYPE;
  vrmm  c_datos_mm%ROWTYPE;
  vrcta c_datos_cta%ROWTYPE;
BEGIN
  ---
  -- Obtiene los datos de la transferencia
  OPEN c_datos_ce;
  FETCH c_datos_ce
    INTO vrce;
  vfound := c_datos_ce%FOUND;
  CLOSE c_datos_ce;
  IF NOT vfound THEN
    msg_error_p := 'El no existe el documento  ';
    RAISE error_proceso;
  END IF;
  IF pno_cta IS NULL OR pno_cta != vrce.no_cta THEN
    msg_error_p := 'La cuenta de bancaria no coincide con la solicitud No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  --
  -- Validaciones sobre la transferencia
  IF NVL(vrce.anulado, '*') = 'A' THEN
    msg_error_p := 'La transferencia ya fue anulada';
    RAISE error_proceso;
  END IF;
  IF NVL(vrce.ind_act, '*') = 'P' THEN
    msg_error_p := 'La transferencia aun esta pendiente';
    RAISE error_proceso;
  END IF;
  -- Documento esta Actualizado
  OPEN c_datos_mm;
  FETCH c_datos_mm
    INTO vrmm;
  vfound := c_datos_mm%FOUND;
  CLOSE c_datos_mm;
  IF vfound IS NULL THEN
    msg_error_p := 'El documento no existe';
    RAISE error_proceso;
  END IF;
  --
  -- Validaciones sobre la transferencia
  IF NVL(vrmm.conciliado, '*') = 'S' THEN
    msg_error_p := 'La transferencia no se puede anular porque ya fue conciliada';
    RAISE error_proceso;
  END IF;
  --
  -- Obtiene el a?o y mes en proceso de la cuenta
  OPEN c_datos_cta(vrce.no_cta);
  FETCH c_datos_cta
    INTO vrcta;
  CLOSE c_datos_cta;
  ---
  -- Fecha de anulacion de la transferencia
  vf_anula := last_day(TO_DATE('01' || LPAD(TO_CHAR(vrcta.mes_proc), 2, '0') || TO_CHAR(vrcta.ano_proc), 'ddmmrrrr'));
  -- Actualiza el ARCKMM con
  --   1. Estado en anulado
  --   2. La fecha de anulacion de la transferencia
  UPDATE arckmm
     SET estado        = 'A',
         fecha_anulado = vf_anula
   WHERE ROWID = vrmm.rowid;

  -- Actualiza el ARCKCE
  UPDATE arckce
     SET anulado       = 'A',
         fecha_anulado = vf_anula
   WHERE ROWID = vrce.rowid;
  -- --
  -- Actualiza el saldo de la cuenta bancaria
  CKactualiza_saldo_cta(pno_cia, vrce.no_cta, vrce.tipo_docu, (-vrce.monto), vrce.tipo_cambio, vrce.ind_act, vrce.ano, vrce.mes, vrce.fecha, msg_error_p);
  IF msg_error_p IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  ---
  -- Si el movimiento ya fue generado a Contabilidad se debe
  -- reversar la distribucion contable
  IF NVL(vrce.ind_con, '*') = 'P' THEN
    -- Actualiza el ARCKCL
    -- Pone ind_con en X para indicar que las lineas de ese cheque
    -- fueron anuladas
    UPDATE arckcl
       SET ind_con = 'X'
     WHERE no_cia = pno_cia
       AND no_secuencia = pno_transa;
    --
    UPDATE arckce
       SET ind_con = 'G'
     WHERE ROWID = vrce.rowid;
  ELSIF NVL(vrce.ind_con, '*') = 'G' THEN
    -- Actualiza el ARCKCL
    -- 1. Inserta de nuevo las lineas de la distribucion contable
    -- pero con el tipo de movimiento inverso y con indicador de
    -- contabilizado Pendiente
    INSERT INTO arckcl
      (no_cia,
       tipo_docu,
       cod_cont,
       centro_costo,
       codigo_tercero,
       tipo_mov,
       monto_dc,
       monto,
       monto_dol,
       moneda,
       no_secuencia,
       tipo_cambio,
       modificable,
       ind_con)
      SELECT no_cia,
             tipo_docu,
             cod_cont,
             centro_costo,
             codigo_tercero,
             DECODE(tipo_mov, 'D', 'C', 'D'),
             monto_dc,
             monto,
             monto_dol,
             moneda,
             no_secuencia,
             tipo_cambio,
             modificable,
             'P'
        FROM arckcl
       WHERE no_cia = pno_cia
         AND no_secuencia = pno_transa
         AND ind_con = 'G';
    --
    -- Pone de nuevo el ind_con como Pendiente, en ARCKCE
    UPDATE arckce
       SET ind_con = 'P'
     WHERE ROWID = vrce.rowid;
  END IF; --else
  --
  -------------------------------------------------------
  -- llindao: reverso de valores de ordenes de compras --
  -------------------------------------------------------
    IF vrce.no_prove IS NOT NULL THEN
    -- llindao: 03/09/2012
    -- Actualziacion de Ordenes de Compras Locales
    FOR Lr_Origen IN C_ORDEN_COMPRA_LOCAL(pno_transa, vrce.tipo_docu, pno_cia) LOOP
      -- se verifica saldo de Orden de compra.
      IF C_SALDO_OC_LOCAL%ISOPEN THEN
        CLOSE C_SALDO_OC_LOCAL;
      END IF;
      OPEN C_SALDO_OC_LOCAL(Lr_Origen.No_Documento_Origen, Lr_Origen.Compania);
      FETCH C_SALDO_OC_LOCAL
        INTO Lr_Saldo;
      IF C_SALDO_OC_LOCAL%NOTFOUND THEN
        Lr_Saldo.Valor_Pagado := 0;
      END IF;
      CLOSE C_SALDO_OC_LOCAL;

      --llindao 2013-02-27
      -- se rebaja el valor que se habia pagado para que sea vuelto a pagar.
      IF Lr_Saldo.Valor_Pagado < Lr_Origen.Monto THEN
        --msg_error_p := 'Saldo Orden Compra:' || Lr_Saldo.Valor_Pago || ' no cubre valor de Pago.';
        msg_error_p := 'El valor pagado ' || Lr_Saldo.Valor_Pagado || ' de la Orden Compra:' || Lr_Saldo.No_Orden || ' no cubre valor a devolver: ' || Lr_Origen.Monto || ' correspondiente al Documento ' || Lr_Origen.No_Documento;
        RAISE error_proceso;
      END IF;

      UPDATE TAPORDEE A
         SET A.VALOR_PAGADO = A.VALOR_PAGADO - Lr_Origen.Monto
       WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
         AND A.NO_CIA = Lr_Origen.Compania;
      --
      Lb_EsOrigen := TRUE;
      --
    END LOOP;

    -- ACTUAZIACION DE SALDO PAGADO ORDEN COMPRA

    -- llindao: 03/09/2012
    -- Actualziacion de Ordenes de Compras Locales accesando por facturas relacionadas al cheque
    FOR Lr_Origen IN C_FACTURAS_ORDENES(pno_transa, vrce.tipo_docu, pno_cia) LOOP
      -- se verifica saldo de Orden de compra.
      IF C_SALDO_OC_LOCAL%ISOPEN THEN
        CLOSE C_SALDO_OC_LOCAL;
      END IF;
      OPEN C_SALDO_OC_LOCAL(Lr_Origen.No_Documento_Origen, Lr_Origen.Compania);
      FETCH C_SALDO_OC_LOCAL
        INTO Lr_Saldo;
      IF C_SALDO_OC_LOCAL%NOTFOUND THEN
        Lr_Saldo.Valor_Pagado := 0;
      END IF;
      CLOSE C_SALDO_OC_LOCAL;

      --llindao 2013-02-27
      --se devuelve el valor pagado a la orden de compra para volver a ser referenciado en otro cheque
      IF Lr_Saldo.Valor_Pagado < Lr_Origen.Monto THEN
        msg_error_p := 'El Valor Pagado ' || Lr_Saldo.Valor_Pagado || ' de la Orden Compra:' || Lr_Saldo.No_Orden || ' no cubre valor a devolver: ' || Lr_Origen.Monto || ' correspondiente al Documento ' || Lr_Origen.No_Documento;
        RAISE error_proceso;
      END IF;

      UPDATE TAPORDEE A
         SET A.VALOR_PAGADO = A.VALOR_PAGADO - Lr_Origen.Monto
       WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
         AND A.NO_CIA = Lr_Origen.Compania;
    END LOOP;

    /* MNAVARRETE  26/11/2015  Esta sentencias estan duplicando el documento de anulacion AO
       se deja sentencias al final como originalmente estaba el proceso.
    CPanula_ck(pno_cia, vrce.tipo_docu, pno_transa, 'ANULACION DE CK', msg_error_p);
    IF msg_error_p IS NOT NULL THEN
      RAISE error_proceso;
    END IF;  */

  ELSIF vrce.id_prov_orden IS NOT NULL THEN
    -- llindao: 03/09/2012
    -- Actualziacion de Ordenes de Compras Locales
    FOR Lr_Origen IN C_ORDEN_COMPRA_LOCAL(pno_transa, vrce.tipo_docu, pno_cia) LOOP
      -- se verifica saldo de Orden de compra.
      IF C_SALDO_OC_LOCAL%ISOPEN THEN
        CLOSE C_SALDO_OC_LOCAL;
      END IF;
      OPEN C_SALDO_OC_LOCAL(Lr_Origen.No_Documento_Origen, Lr_Origen.Compania);
      FETCH C_SALDO_OC_LOCAL
        INTO Lr_Saldo;
      IF C_SALDO_OC_LOCAL%NOTFOUND THEN
        Lr_Saldo.Valor_Pagado := 0;
      END IF;
      CLOSE C_SALDO_OC_LOCAL;
      --
      --llindao 2013-02027
      --se devuelve el valor de pago de la ordend de compra para que pueda ser referenciado en otro cheque
      IF (Lr_Saldo.Valor_Pagado) < Lr_Origen.Monto THEN
        msg_error_p := 'El valor pagado ' || Lr_Saldo.Valor_Pagado || ' de la Orden Compra:' || Lr_Saldo.No_Orden || ' no cubre valor a devolver: ' || Lr_Origen.Monto || ' correspondiente al Documento ' || Lr_Origen.No_Documento;
        RAISE error_proceso;
      END IF;

      UPDATE TAPORDEE A
         SET A.VALOR_PAGADO = A.VALOR_PAGADO - Lr_Origen.Monto
       WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
         AND A.NO_CIA = Lr_Origen.Compania;
      --
      Lb_EsOrigen := TRUE;
      --
    END LOOP;
  END IF; -- fin reverso de valores de proveedor

  -- Anula los movimientos en CxP
  vtot_monto := 0;
  FOR r IN c_doc_cxp(vrce.no_cta) LOOP
    vtot_monto := NVL(vtot_monto, 0) + NVL(r.monto, 0);
    CPanula_ck(pno_cia, r.tipo_doc, r.no_docu, 'ANULACION DE TR', msg_error_p);
    IF msg_error_p IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
  END LOOP;


  IF vtot_monto != 0 AND vtot_monto != vrce.monto THEN
    msg_error_p := 'El monto total anulado en CxP difiere del total de la transa.' || pno_transa;
    RAISE error_proceso;
  END IF;
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := 'CKANUL_TR : ' || msg_error_p;
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := 'CKANUL_TR : ' || SQLERRM;
    RETURN;
END CKanul_TR;
/