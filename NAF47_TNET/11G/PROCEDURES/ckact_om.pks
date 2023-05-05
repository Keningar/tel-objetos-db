create or replace PROCEDURE            ckact_om(pno_cia     IN VARCHAR2,
                                     pno_transa  IN NUMBER,
                                     pno_cta     IN VARCHAR2,
                                     msg_error_p IN OUT VARCHAR2) IS
  vfound        BOOLEAN;
  vnumero_ctrl  arckmm.numero_ctrl%TYPE;
  vnuevo_estado arckmm.estado%TYPE;
  --
  error_proceso EXCEPTION;
  Lv_Aniomes VARCHAR2(20);
  --
  CURSOR c_datos_mov IS
    SELECT mm.no_cta,
           mm.tipo_doc tipo_docu,
           mm.monto,
           mm.tipo_cambio,
           mm.fecha,
           mm.ano,
           mm.mes,
           mm.estado,
           mm.ind_otros_meses,
           td.formulario_ctrl,
           mm.ROWID
      FROM arckmm mm,
           arcktd td
     WHERE mm.no_cia = pno_cia
       AND mm.no_docu = pno_transa
       AND mm.no_cia = td.no_cia
       AND mm.tipo_doc = td.tipo_doc;
  --
  CURSOR c_datos_cta(pno_cta VARCHAR2) IS
    SELECT ano_proc,
           mes_proc
      FROM arckmc
     WHERE no_cia = pno_cia
       AND no_cta = pno_cta;
  --
  rmm  c_datos_mov%ROWTYPE;
  rcta c_datos_cta%ROWTYPE;
  --
  -- =======================
  -- PROCEDIMIENTOS
  --
  PROCEDURE valida_consistencia(msg_error_p IN OUT VARCHAR2) IS
    vdif    NUMBER;
    vlineas NUMBER;
    CURSOR c_cuadre IS
      SELECT SUM(1) lineas,
             SUM(DECODE(tipo_mov, 'D', NVL(monto_dc, 0), -nvl(monto_dc, 0))) dif
        FROM arckml
       WHERE no_cia = pno_cia
         AND no_docu = pno_transa;
    --
    CURSOR c_tc IS
      SELECT tipo_cambio
        FROM arckml
       WHERE no_cia = pno_cia
         AND no_docu = pno_transa
       GROUP BY tipo_cambio;
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
  OPEN c_datos_mov;
  FETCH c_datos_mov
    INTO rmm;
  vfound := c_datos_mov%FOUND;
  CLOSE c_datos_mov;
  IF NOT vfound THEN
    msg_error_p := 'No existe documento con la transaccion No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  IF rmm.tipo_docu IN ('CK', 'TR') THEN
    msg_error_p := 'El proced. CKACT_OM no puede procesar documentos tipo CK, TR';
    RAISE error_proceso;
  END IF;
  IF pno_cta IS NULL OR pno_cta != rmm.no_cta THEN
    msg_error_p := 'La cuenta de bancaria no coincide con la solicitud No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  IF rmm.estado != 'P' THEN
    msg_error_p := 'El documento no esta pendiente de actualizar, Transaccion No.' || pno_transa;
    RAISE error_proceso;
  END IF;
  --
  -- ---
  -- datos de la cuenta bancaria
  --
  OPEN c_datos_cta(rmm.no_cta);
  FETCH c_datos_cta
    INTO rcta;
  vfound := c_datos_cta%FOUND;
  CLOSE c_datos_cta;
  IF NOT vfound THEN
    msg_error_p := 'No existe la cuenta bancaria: ' || rmm.no_cta;
    RAISE error_proceso;
  END IF;
  --
  Lv_Aniomes := Rcta.Ano_Proc || LPAD(Rcta.Mes_Proc, 2, '0');
  --- se valida mes y anio (no se valida para documentos de meses cerrados) BVI 05/10/2012
  IF Lv_Aniomes <> TO_CHAR(Rmm.Fecha, 'YYYYMM') and rmm.ind_otros_meses = 'N' THEN
    Msg_Error_p := 'El año ' || Rcta.Ano_Proc || ' y mes ' || Rcta.Mes_Proc || ' de la fecha del proceso no corresponde al año y mes de la fecha del documento: ' || TO_CHAR(Rmm.Fecha, 'YYYY-MM');
    RAISE Error_Proceso;
  END IF;
  -- Verifica la fecha del movimiento con respecto mes en proceso de la cuenta
  IF ((rmm.ano * 100) + rmm.mes) > ((rcta.ano_proc * 100) + rcta.mes_proc) THEN
    -- No actualiza el movimiento porque es mayor al mes en proceso
    RETURN;
  ELSIF ((rmm.ano * 100) + rmm.mes) < ((rcta.ano_proc * 100) + rcta.mes_proc) THEN
    vnuevo_estado := 'M';
  ELSE
    vnuevo_estado := 'D';
  END IF;
  --
  -- verifica consistencia del documento
  valida_consistencia(msg_error_p);
  IF msg_error_p IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  -- ---
  -- Actualiza el saldo de la cuenta bancaria
  --
  CKactualiza_saldo_cta(pno_cia,
                        rmm.no_cta,
                        rmm.tipo_docu,
                        rmm.monto,
                        rmm.tipo_cambio,
                        'D', -- movimiento Diario
                        rmm.ano,
                        rmm.mes,
                        rmm.fecha,
                        msg_error_p);
  IF msg_error_p IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  -- ---
  -- Actualiza el estado del documento
  --
  IF rmm.formulario_ctrl IS NOT NULL THEN
    vnumero_ctrl := consecutivo.ck(pno_cia, rmm.ano, rmm.mes, rmm.no_cta, rmm.tipo_docu, 'SECUENCIA');
  ELSE
    vnumero_ctrl := NULL;
  END IF;
  -- Pone el documento como actualizado
  UPDATE arckmm
     SET estado            = vnuevo_estado,
         no_fisico         = NVL(TO_CHAR(vnumero_ctrl), no_fisico),
         numero_ctrl       = NVL(vnumero_ctrl, numero_ctrl),
         usuario_actualiza = upper(USER),
         fecha_actualiza   = TRUNC(SYSDATE)
   WHERE ROWID = rmm.rowid;
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := NVL(msg_error_p, 'ERROR en proced. ckact_om');
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := NVL(SQLERRM, 'ERROR en proced. ckact_om');
    RETURN;
END CKACT_OM;