CREATE OR REPLACE PROCEDURE NAF47_TNET.CKANUL_CHEQ(pno_cia     IN VARCHAR2,
                                        pno_transa  IN NUMBER,
                                        pno_cta     IN VARCHAR2,
                                        msg_error_p IN OUT VARCHAR2) IS
  --
  CURSOR c_datos_ce IS
    SELECT no_cta,
           tipo_docu,
           fecha,
           monto,
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
           ind_retencion,
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

  -- Ver si la compania usa retenciones incluidas. Guatemala
  CURSOR c_usa_ret IS
    SELECT 'x'
      FROM arcppr
     WHERE no_cia = pNo_cia;
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

  --
  vrce  c_datos_ce%ROWTYPE;
  vrmm  c_datos_mm%ROWTYPE;
  vrcta c_datos_cta%ROWTYPE;
  --
  vfound   BOOLEAN;
  vf_anula arckmm.fecha_anulado%TYPE;
  --
  error_proceso EXCEPTION;
  --
  vTemp VARCHAR2(1);
  --
  -- llindao: 2012-09-21
  Lr_Saldo    C_SALDO_OC_LOCAL%ROWTYPE := NULL;
  Lb_EsOrigen BOOLEAN := FALSE;

BEGIN
  -- --
  -- Obtiene los datos del cheque
  OPEN c_datos_ce;
  FETCH c_datos_ce
    INTO vrce;
  vfound := c_datos_ce%FOUND;
  CLOSE c_datos_ce;
  IF NOT vfound THEN
    msg_error_p := 'No existe en Cheques el documento con transaccion ' || pno_transa;
    RAISE error_proceso;
  END IF;
  IF pno_cta IS NULL OR pno_cta != vrce.no_cta THEN
    msg_error_p := 'La cuenta de bancaria no coincide con la solicitud No. ' || pno_transa;
    RAISE error_proceso;
  END IF;
  -- ---
  -- Validaciones sobre el cheque
  IF NVL(vrce.emitido, '*') = 'N' THEN
    msg_error_p := 'El cheque aun no ha sido emitido';
    RAISE error_proceso;
  END IF;
  IF NVL(vrce.anulado, '*') = 'A' THEN
    msg_error_p := 'El cheque ya fue anulado';
    RAISE error_proceso;
  END IF;
  -- --
  -- Obtiene el a?o y mes en proceso de la cuenta
  OPEN c_datos_cta(vrce.no_cta);
  FETCH c_datos_cta
    INTO vrcta;
  CLOSE c_datos_cta;
  -- --
  -- Fecha de anulacion del cheque
  vf_anula := last_day(TO_DATE('01' ||
                               LPAD(TO_CHAR(vrcta.mes_proc), 2, '0') ||
                               TO_CHAR(vrcta.ano_proc),
                               'DDMMRRRR'));

  --vf_anula := TRUNC(SYSDATE);

  -- --
  -- Verifica si el cheque ya fue actualizado
  IF (vrce.ind_act = 'P') THEN
    -- Cheque NO actualizado
    -- Crea el movimiento en ARCKMM con
    --   1. Estado en Anulado
    --   2. Conciliado como 'S'
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
       fecha_anulado,
       mes,
       ano,
       moneda_cta,
       tipo_cambio,
       no_fisico,
       serie_fisico,
       ind_con)
    VALUES
      (pno_cia,
       vrce.no_cta,
       'C',
       vrce.tipo_docu,
       pno_transa,
       vrce.fecha,
       vrce.beneficiario,
       vrce.monto,
       'A',
       'S',
       vf_anula,
       vrcta.mes_proc,
       vrcta.ano_proc,
       vrce.moneda_cta,
       vrce.tipo_cambio,
       vrce.cheque,
       '0',
       'G');
    --
    --  Actualiza el cheque en ARCKCE con
    --  1. Anulado en 'A'
    --  2. ind_actualizado en D
    UPDATE arckce
       SET anulado       = 'A',
           ind_act       = 'D',
           fecha_anulado = vf_anula
     WHERE ROWID = vrce.rowid;
  ELSE
    -- --
    -- Cheque Actualizado
    --
    OPEN c_datos_mm;
    FETCH c_datos_mm
      INTO vrmm;
    vfound := c_datos_mm%FOUND;
    CLOSE c_datos_mm;
    IF vfound IS NULL THEN
      msg_error_p := ' El no existe en MM el documento, transa ' || pno_transa;
      RAISE error_proceso;
    END IF;
    IF NVL(vrmm.conciliado, '*') = 'S' THEN
      msg_error_p := 'El cheque no se puede anular porque ya fue conciliado';
      RAISE error_proceso;
    END IF;
    --
    -- Actualiza el ARCKMM con
    UPDATE arckmm
       SET estado        = 'A',
           fecha_anulado = vf_anula
     WHERE ROWID = vrmm.rowid;
    --
    -- Actualiza ARCKCE (anulado, ubicacion)
    UPDATE arckce
       SET anulado       = 'A',
           ubicacion     = 'A',
           fecha_anulado = vf_anula
     WHERE ROWID = vrce.rowid;
    -- --
    -- Actualiza el saldo de la cuenta bancaria
    CKactualiza_saldo_cta(pno_cia, vrce.no_cta, vrce.tipo_docu, (-vrce.monto), vrce.tipo_cambio, vrce.ind_act, vrce.ano, vrce.mes, vrce.fecha, msg_error_p);
    IF msg_error_p IS NOT NULL THEN
      RAISE error_proceso;
    END IF;

  END IF;
  --
  -- --
  -- Actualiza ubicacion fisica del cheque, insertando movimiento de anulacion
  INSERT INTO arckuf
    (no_cia,
     no_cta,
     tipo_doc,
     cheque,
     fecha_ubic,
     ubicacion,
     observacion,
     usuario,
     no_secuencia)
  VALUES
    (pno_cia,
     vrce.no_cta,
     vrce.tipo_docu,
     vrce.cheque,
     SYSDATE,
     'A',
     'CHEQUE ANULADO',
     USER,
     pno_transa);
  -- ---
  -- Si el movimiento ya fue generado a Contabilidad se debe
  -- reversar la distribucion contable
  --
  IF NVL(vrce.ind_con, '*') = 'P' THEN
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
    -- Inserta de nuevo las lineas de la distribucion contable
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
    -- Pone de nuevo el ind_con como Pendiente de contabilizar
    UPDATE arckce
       SET ind_con = 'P'
     WHERE ROWID = vrce.rowid;
  END IF;
  --
  -- --
  -- Actualiza las cuentas por pagar del proveedor
  IF vrce.no_prove IS NOT NULL THEN
    -- llindao: 03/09/2012
    -- Actualziaci�n de Ordenes de Compras Locales
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
    -- Actualziaci�n de Ordenes de Compras Locales accesando por facturas relacionadas al cheque
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

    CPanula_ck(pno_cia, vrce.tipo_docu, pno_transa, 'ANULACION DE CK', msg_error_p);
    IF msg_error_p IS NOT NULL THEN
      RAISE error_proceso;
    END IF;

  ELSIF vrce.id_prov_orden IS NOT NULL THEN
    -- llindao: 03/09/2012
    -- Actualziaci�n de Ordenes de Compras Locales
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
    
    /*  MNAVARRETE 03/12/2015 para los casos en quw existe proveedor de la orden  */
    CPanula_ck(pno_cia, vrce.tipo_docu, pno_transa, 'ANULACION DE CK', msg_error_p);
    IF msg_error_p IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
    
  END IF; -- fin pago factura de proveedor
  --
  --
  -- Retenciones incluidas - Guatemala.
  -- Revisar si la compania maneja retenciones incluidas
  OPEN c_usa_ret;
  FETCH c_usa_ret
    INTO vTemp;
  vFound := c_usa_ret%FOUND;
  CLOSE c_usa_ret;
  --
  -- Si la compa?ia no esta definida en ARCPPR
  -- se supone que NO maneja las retenciones incluidas de Guatemala
  IF vFound AND (vrce.ind_retencion = 'S') THEN
    --
    -- Si se anula un cheque que se uso para el pago de retenciones,
    -- las boletas (arcbbo) regresan al estado de Impresas ('I'),
    -- y se limpian los campos no_cta, cheque, y no_secuencia
    -- para las boletas pagadas con ese cheque
    UPDATE arcbbo
       SET estatus_boleta = 'I', -- Boleta Impresa
           no_cta         = NULL,
           cheque         = NULL,
           no_secuencia   = NULL
     WHERE no_cia = pNo_cia
       AND no_secuencia = pNo_transa
       AND cheque IS NOT NULL
       AND cheque = vrce.cheque
       AND estatus_boleta IS NOT NULL -- que la retencion ya ha sido generada
       AND estatus_boleta <> 'X'; -- y el doc que la genero no haya sido anulado

  END IF;

EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := 'CKANUL_CHEQ: ' || NVL(msg_error_p, 'ERROR en CKANUL_CHEQ');
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := 'CKANUL_CHEQ: ' || NVL(SQLERRM, 'ERROR en la anulacion de cheques');
    RETURN;
END CKANUL_CHEQ;
/