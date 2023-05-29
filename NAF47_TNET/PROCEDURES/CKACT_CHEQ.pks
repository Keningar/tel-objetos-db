CREATE OR REPLACE PROCEDURE NAF47_TNET.CKACT_CHEQ(pno_cia     IN VARCHAR2,
                                       pno_transa  IN NUMBER,
                                       pno_cta     IN VARCHAR2,
                                       msg_error_p IN OUT VARCHAR2) IS
  --
  vno_docu_cxp arcpmd.no_docu%TYPE;
  vcod_diario  arcpmd.cod_diario%TYPE;
  vfound       BOOLEAN;
  --
  vmonto    arcpmd.monto%TYPE;
  vSubtotal arcpmd.subtotal%TYPE;
  vSaldo    arcpmd.saldo%TYPE;
  --
  error_proceso EXCEPTION;
  Lv_Aniomes VARCHAR2(20);
  --
  CURSOR c_datos_cheque IS
    SELECT ce.no_cta,
           ce.no_secuencia,
           ce.tipo_docu,
           ce.cheque,
           ce.serie_fisico,
           ce.fecha,
           ce.beneficiario,
           ce.no_prove,
           ce.monto,
           ce.tot_ref,
           ce.tipo_cambio,
           ce.moneda_cta,
           TO_CHAR(ce.fecha, 'RRRR') ano,
           TO_CHAR(ce.fecha, 'MM') mes,
           ce.ind_act,
           ce.ind_retencion,
           NVL(ce.emitido, 'N') emitido,
           NVL(ce.anulado, 'X') anulado,
           NVL(ce.tot_dpp, 0) tot_dpp,
           ce.numero_ctrl,
           ce.ROWID,
           ce.id_prov_orden
      FROM arckce ce
     WHERE ce.no_cia = pno_cia
       AND ce.no_secuencia = pno_transa;
  --
  CURSOR c_datos_cta(pno_cta VARCHAR2) IS
    SELECT ano_proc,
           mes_proc,
           cod_diariom
      FROM arckmc
     WHERE no_cia = pno_cia
       AND no_cta = pno_cta;

  CURSOR c_diario(pTipo VARCHAR2) IS
    SELECT cod_diario
      FROM arcptd
     WHERE no_cia = pNo_cia
       AND tipo_doc = pTipo;
  -- llindao: 2012-09-21
  CURSOR C_SALDO_OC_LOCAL(Cv_NoOrdenCompra VARCHAR2,
                          Cv_NoCia         VARCHAR2) IS
    SELECT A.NO_CIA,
           A.NO_ORDEN,
           (A.TOTAL - A.VALOR_PAGADO) VALOR_PAGO
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
  --
  rce c_datos_cheque%ROWTYPE;
  rcta c_datos_cta%ROWTYPE;
  -- llindao: 2012-09-21
  Lr_Saldo    C_SALDO_OC_LOCAL%ROWTYPE := NULL;
  Lb_EsOrigen BOOLEAN := FALSE;
  --
  -- =======================
  -- PROCEDIMIENTOS INTERNOS
  --
  PROCEDURE valida_consistencia(msg_error_p IN OUT VARCHAR2) IS
    --
    vdif    NUMBER;
    vlineas NUMBER;
    --
    CURSOR c_cuadre IS
      SELECT SUM(1) lineas,
             SUM(DECODE(tipo_mov, 'D', NVL(monto_dc, 0), -nvl(monto_dc, 0))) dif
        FROM arckcl
       WHERE no_cia = pno_cia
         AND no_secuencia = pno_transa;
    --
    CURSOR c_tc IS
      SELECT tipo_cambio
        FROM arckcl
       WHERE no_cia = pno_cia
         AND no_secuencia = pno_transa
       GROUP BY tipo_cambio;
    --
  BEGIN
    -- valida detalle contable
    vlineas := 0;
    OPEN c_cuadre;
    FETCH c_cuadre
      INTO vlineas,
           vdif;
    CLOSE c_cuadre;
    IF (NVL(vlineas, 0) < 2 OR NVL(vdif, 0) != 0) THEN
      msg_error_p := 'Detalle contable descuadrado, transa.' || TO_CHAR(pno_transa);
      RETURN;
    END IF;
    -- valida tipos de cambio
    vlineas := 0;
    FOR l IN c_tc LOOP
      vlineas := NVL(vlineas, 0) + 1;
    END LOOP;
    IF NVL(vlineas, 0) > 1 THEN
      msg_error_p := 'Detalle contable con varios tipos de cambios, transa.' || TO_CHAR(pno_transa);
      RETURN;
    END IF;
  END;
  --
  --
BEGIN
  -- trae datos del documento
  OPEN c_datos_cheque;
  FETCH c_datos_cheque
    INTO rce;
  vfound := c_datos_cheque%FOUND;
  CLOSE c_datos_cheque;
  IF NOT vfound THEN
    msg_error_p := 'No existe cheque con la transaccion No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  IF rce.tipo_docu != 'CK' THEN
    msg_error_p := 'El proced. CKACT_CHEQ solo procesa doc. de tipo CK';
    RAISE error_proceso;
  END IF;
  IF pno_cta IS NULL OR pno_cta != rce.no_cta THEN
    msg_error_p := 'La cuenta de bancaria no coincide con la solicitud No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  IF rce.ind_act != 'P' THEN
    msg_error_p := 'El documento ya estaba actualizado, solicitud No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  IF rce.tipo_docu = 'CK' AND rce.emitido = 'N' THEN
    msg_error_p := 'El cheque no ha sido emitido, solicitud No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  IF rce.anulado = 'A' THEN
    msg_error_p := 'El documento esta anulado, solicitud No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  --
  -- ---
  -- datos de la cuenta bancaria
  --
  OPEN c_datos_cta(rce.no_cta);
  FETCH c_datos_cta
    INTO rcta;
  vfound := c_datos_cta%FOUND;
  CLOSE c_datos_cta;
  IF NOT vfound THEN
    msg_error_p := 'No existe la cuenta bancaria: ' || rce.no_cta;
    RAISE error_proceso;
  END IF;
  -- yoveri: 2012/09/21
  Lv_Aniomes := Rcta.Ano_Proc || LPAD(Rcta.Mes_Proc, 2, '0');

  IF Lv_Aniomes <> TO_CHAR(Rce.Fecha, 'YYYYMM') THEN
    Msg_Error_p := 'El año ' || Rcta.Ano_Proc || ' y mes ' || Rcta.Mes_Proc || ' de la fecha del proceso no corresponde al año y mes de la fecha del cheque: ' || TO_CHAR(Rce.Fecha, 'YYYY-MM');
    RAISE Error_Proceso;
  END IF;

  -- Verifica la fecha del cheque con respecto mes en proceso de la cuenta
  IF ((rce.ano * 100) + rce.mes) > ((rcta.ano_proc * 100) + rcta.mes_proc) THEN
    -- No actualiza el cheque porque es mayor al mes en proceso
    RETURN;
  END IF;
  -- verifica consistencia del documento
  valida_consistencia(msg_error_p);
  IF msg_error_p IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  -- ---
  -- Crea el movimiento en la tabla mensual de movimiento
  --
  INSERT INTO arckmm
    (no_cia,
     no_cta,
     procedencia,
     tipo_doc,
     no_docu,
     fecha,
     beneficiario,
     monto,
     estado,
     conciliado,
     mes,
     ano,
     ind_con,
     moneda_cta,
     tipo_cambio,
     no_fisico,
     serie_fisico,
     descuento_pp,
     numero_ctrl)
  VALUES
    (pno_cia,
     rce.no_cta,
     'C',
     rce.tipo_docu,
     pno_transa,
     rce.fecha,
     rce.beneficiario,
     rce.monto,
     'D',
     'N',
     rcta.mes_proc,
     rcta.ano_proc,
     'P',
     rce.moneda_cta,
     rce.tipo_cambio,
     rce.cheque,
     rce.serie_fisico,
     rce.tot_dpp,
     rce.numero_ctrl);
  -- ---
  -- Actualiza el saldo de la cuenta bancaria
  CKactualiza_saldo_cta(pno_cia,
                        rce.no_cta,
                        rce.tipo_docu,
                        rce.monto,
                        rce.tipo_cambio,
                        'D', -- movimiento del diario
                        rce.ano,
                        rce.mes,
                        rce.fecha,
                        msg_error_p);
  IF msg_error_p IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  --
  -- ---
  -- Si el cheque es a proveedor, registra el documento en CxP
  --
  IF rce.no_prove IS NOT NULL THEN
  
    -- llindao: 03/09/2012
    -- Actualziación de Ordenes de Compras Locales
    FOR Lr_Origen IN C_ORDEN_COMPRA_LOCAL(rce.no_secuencia, rce.tipo_docu, pno_cia) LOOP
      -- se verifica saldo de Orden de compra.
      IF C_SALDO_OC_LOCAL%ISOPEN THEN
        CLOSE C_SALDO_OC_LOCAL;
      END IF;
      OPEN C_SALDO_OC_LOCAL(Lr_Origen.No_Documento_Origen, Lr_Origen.Compania);
      FETCH C_SALDO_OC_LOCAL
        INTO Lr_Saldo;
      IF C_SALDO_OC_LOCAL%NOTFOUND THEN
        Lr_Saldo.Valor_Pago := 0;
      END IF;
      CLOSE C_SALDO_OC_LOCAL;
    
      --emunoz 19022013
      --Se rebaja las retenciones debido a que la relacion de cheque con fact. esta por el neto a pagar (Total Factura - Retenciones)
    
      IF Lr_Saldo.Valor_Pago < Lr_Origen.Monto 
        AND abs(Lr_Saldo.Valor_Pago - Lr_Origen.Monto) > 0.03 THEN
        --msg_error_p := 'Saldo Orden Compra:' || Lr_Saldo.Valor_Pago || ' no cubre valor de Pago.';
        msg_error_p := 'El Saldo ' || Lr_Saldo.Valor_Pago || ' de la Orden Compra:' || Lr_Saldo.No_Orden || ' no cubre valor de Pago: ' || Lr_Origen.Monto || ' correspondiente al Documento ' || Lr_Origen.No_Documento;
        RAISE error_proceso;
      END IF;
    
      UPDATE TAPORDEE A
         SET A.VALOR_PAGADO = A.VALOR_PAGADO + Lr_Origen.Monto
       WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
         AND A.NO_CIA = Lr_Origen.Compania;
      --
      Lb_EsOrigen := TRUE;
      --
    END LOOP;
  
    --IF NOT Lb_EsOrigen THEN
    -- ES CHEQUE POR FACTURA
    vNo_docu_cxp := pno_transa;
  
    --Obtiene el codigo de diario del documento CK que esta definido en CxP
    OPEN c_diario(rce.tipo_docu);
    FETCH c_diario
      INTO vCod_diario;
    CLOSE c_diario;
  
    IF vCod_diario IS NULL THEN
      msg_error_p := 'El tipo documento ' || rce.tipo_docu || ' no tiene codigo de diario definido en los Tipos de Documento de Cuentas por Pagar';
      RAISE error_proceso;
    END IF;
    -- ACTUAZIACION DE SALDO PAGADO ORDEN COMPRA
  
    -- llindao: 03/09/2012
    -- Actualziación de Ordenes de Compras Locales accesando por facturas relacionadas al cheque 
    FOR Lr_Origen IN C_FACTURAS_ORDENES(rce.no_secuencia, rce.tipo_docu, pno_cia) LOOP
      -- se verifica saldo de Orden de compra.
      IF C_SALDO_OC_LOCAL%ISOPEN THEN
        CLOSE C_SALDO_OC_LOCAL;
      END IF;
      OPEN C_SALDO_OC_LOCAL(Lr_Origen.No_Documento_Origen, Lr_Origen.Compania);
      FETCH C_SALDO_OC_LOCAL
        INTO Lr_Saldo;
      IF C_SALDO_OC_LOCAL%NOTFOUND THEN
        Lr_Saldo.Valor_Pago := 0;
      END IF;
      CLOSE C_SALDO_OC_LOCAL;
      --emunoz 19022013
      --Se rebaja las retenciones debido a que la relacion de cheque con fact. esta por el neto a pagar (Total Factura - Retenciones)
    
      IF (Lr_Saldo.Valor_Pago) < Lr_Origen.Monto 
         AND abs(Lr_Saldo.Valor_Pago - Lr_Origen.Monto) > 0.03 THEN
        --msg_error_p := 'Saldo Orden Compra:' || Lr_Saldo.Valor_Pago || ' no cubre valor de Pago: '||Lr_Origen.Monto;
        msg_error_p := 'El Saldo ' || Lr_Saldo.Valor_Pago || ' de la Orden Compra:' || Lr_Saldo.No_Orden || ' no cubre valor de Pago: ' || Lr_Origen.Monto || ' correspondiente al Documento ' || Lr_Origen.No_Documento;
        RAISE error_proceso;
      END IF;
    
      UPDATE TAPORDEE A
         SET A.VALOR_PAGADO = A.VALOR_PAGADO + Lr_Origen.Monto
       WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
         AND A.NO_CIA = Lr_Origen.Compania;
    END LOOP;
  
    --
    vMonto    := rce.monto + NVL(rce.tot_dpp, 0);
    vSubtotal := vMonto;
    vSaldo    := NVL(rce.tot_ref, 0) - vMonto;
    -- crea un documento en CxP pendiente de actualizar
    INSERT INTO arcpmd
      (no_cia,
       no_prove,
       tipo_doc,
       no_docu,
       ind_act,
       fecha,
       subtotal,
       monto,
       saldo,
       tot_refer,
       tot_db,
       tot_cr,
       tipo_cambio,
       moneda,
       cod_diario,
       no_cta,
       no_secuencia,
       fecha_documento,
       no_fisico,
       serie_fisico,
       tot_dpp,
       origen,
       excentos)
    VALUES
      (pno_cia,
       rce.no_prove,
       rce.tipo_docu,
       vno_docu_cxp,
       'P',
       rce.fecha,
       vSubtotal,
       vMonto,
       vSaldo,
       rce.tot_ref,
       0,
       0,
       rce.tipo_cambio,
       rce.moneda_cta,
       vcod_diario,
       rce.no_cta,
       pno_transa,
       rce.fecha,
       rce.cheque,
       rce.serie_fisico,
       rce.tot_dpp,
       'CK',
       vMonto);
    --
    INSERT INTO arcprd
      (no_cia,
       tipo_doc,
       no_docu,
       tipo_refe,
       no_refe,
       monto,
       descuento_pp,
       monto_refe,
       moneda_refe,
       fec_aplic,
       ano,
       mes,
       no_prove,
       id_forma_pago)
      SELECT rd.no_cia,
             rd.tipo_docu,
             vno_docu_cxp,
             rd.tipo_refe,
             rd.no_refe,
             rd.monto,
             NVL(rd.descuento_pp, 0),
             rd.monto_refe,
             rd.moneda_refe,
             ce.fecha,
             TO_CHAR(ce.fecha, 'RRRR'),
             TO_CHAR(ce.fecha, 'MM'),
             ce.no_prove,
             rd.id_forma_pago
        FROM arckrd rd,
             arckce ce
       WHERE rd.no_cia = pno_cia
         AND rd.no_secuencia = pno_transa
         AND ce.no_cia = rd.no_cia
         AND ce.tipo_docu = rd.tipo_docu
         AND ce.no_secuencia = rd.no_secuencia;
    --
    -- Actualiza en CxP
    CPactualiza(pno_cia, rce.no_prove, rce.tipo_docu, vno_docu_cxp, msg_error_p);
    IF msg_error_p IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
    --END IF; -- FIN CHEQUE POR FACTURAS
  
  ELSIF rce.id_prov_orden IS NOT NULL THEN
    -- llindao: 03/09/2012
    -- Actualziación de Ordenes de Compras Locales
    FOR Lr_Origen IN C_ORDEN_COMPRA_LOCAL(rce.no_secuencia, rce.tipo_docu, pno_cia) LOOP
      -- se verifica saldo de Orden de compra.
      IF C_SALDO_OC_LOCAL%ISOPEN THEN
        CLOSE C_SALDO_OC_LOCAL;
      END IF;
      OPEN C_SALDO_OC_LOCAL(Lr_Origen.No_Documento_Origen, Lr_Origen.Compania);
      FETCH C_SALDO_OC_LOCAL
        INTO Lr_Saldo;
      IF C_SALDO_OC_LOCAL%NOTFOUND THEN
        Lr_Saldo.Valor_Pago := 0;
      END IF;
      CLOSE C_SALDO_OC_LOCAL;
      --
      --emunoz 19022013
      --Se rebaja las retenciones debido a que la relacion de cheque con fact. esta por el neto a pagar (Total Factura - Retenciones)
      IF (Lr_Saldo.Valor_Pago) < Lr_Origen.Monto 
        AND abs(Lr_Saldo.Valor_Pago - Lr_Origen.Monto) > 0.03 THEN
        msg_error_p := 'El Saldo ' || Lr_Saldo.Valor_Pago || ' de la Orden Compra:' || Lr_Saldo.No_Orden || ' no cubre valor de Pago: ' || Lr_Origen.Monto || ' correspondiente al Documento ' || Lr_Origen.No_Documento;
        RAISE error_proceso;
      END IF;
    
      UPDATE TAPORDEE A
         SET A.VALOR_PAGADO = A.VALOR_PAGADO + Lr_Origen.Monto
       WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
         AND A.NO_CIA = Lr_Origen.Compania;
      --
      Lb_EsOrigen := TRUE;
      --
    END LOOP;
  
  END IF; -- cheque a proveedor
  -- ---
  -- Actualiza el estado del documento
  --
  UPDATE arckce
     SET ind_act              = 'D',
         usuario_modificacion = USER,
         fecha_actualiza      = TRUNC(SYSDATE)
   WHERE ROWID = rce.rowid;
  --
  -- Si la solicitud de pago es por Retencion (caso Guatemala) actualiza datos
  -- de las boletas de retencion pagadas con ese cheque.
  IF rce.ind_retencion = 'S' THEN
    UPDATE arcbbo
       SET cheque         = rce.cheque,
           estatus_boleta = 'C' -- cancelada al fisco.
     WHERE no_cia = pno_cia
       AND no_cta = rce.no_cta
       AND no_secuencia = rce.no_secuencia;
  END IF;
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := NVL(msg_error_p, 'EN CKACT_CHEQ');
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := NVL(SQLERRM, 'EN CKACT_CHEQ');
    RETURN;
END CKACT_CHEQ;
 
/