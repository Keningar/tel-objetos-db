create or replace PROCEDURE            CPAnula_ck(
  pCia         IN     varchar2,
  pTipo        IN     varchar2,
  pDocu        IN     varchar2,
  pMotivo      IN     varchar2,
  pmsg_error   IN OUT varchar2
) IS
  --
  -- Datos del doc a anular
  CURSOR c_datos_doc(pNo_docu arcpmd.no_docu%TYPE) IS
    SELECT a.no_prove, a.monto, a.saldo, a.moneda,
           a.bloqueado, a.anulado, a.tipo_cambio,
           a.no_fisico, a.serie_fisico,
           a.excentos, a.gravado, a.tipo_doc, a.usuario_anula,
           a.tot_db, a.tot_cr, a.descuento, a.monto_nominal,
           a.monto_bienes, a.monto_serv, a.monto_importac,
           a.t_camb_c_v, a.ind_act, a.rowid, b.tipo_mov
      FROM arcpmd a, arcptd b
     WHERE a.no_cia   = pcia
       AND a.no_docu  = pNo_docu
       AND b.no_cia   = a.no_cia
       AND b.tipo_doc = a.tipo_doc;
  --
  -- La fecha de anulacion es el ultimo dia del mes de proceso
  -- de la cuenta bancaria del cheque
  CURSOR c_fecha_anula(pNo_docu arcpmd.no_docu%TYPE) IS
    SELECT last_day(to_date(to_char(c.mes_proc, 'FM00')||to_char(c.ano_proc, 'FM0000'),'MMYYYY'))
      FROM arcpmd a, arckmm b, arckmc c
     WHERE a.no_cia  = pcia
       AND a.no_docu = pNo_docu
       AND b.no_cia  = a.no_cia
       AND b.no_docu = a.no_docu
       AND c.no_cia  = b.no_cia
       AND c.no_cta  = b.no_cta;
  --
  -- Obtener el documento de anulacion segun el tipo de mov del doc a anular
 CURSOR c_tipo_anulacion (pTipo_mov arcptd.tipo_mov%TYPE) IS
    SELECT tipo_doc, cod_diario, tipo_mov
      FROM arcptd
     WHERE no_cia        = pCia
       AND tipo_mov      = decode(pTipo_mov,'D','C','D')
       AND ind_anulacion = 'S';
  --
  rDocu          c_datos_doc%ROWTYPE;
  rAnula         c_tipo_anulacion%ROWTYPE;
  --
  error_proceso  EXCEPTION;
  --
  vNo_docu_anula arcpmd.no_docu%TYPE;
  vFecha_anula   DATE;
  --
  vExiste        BOOLEAN;
  --
BEGIN
  --
  -- trae datos del documento
  OPEN  c_datos_doc(pDocu);
  FETCH c_datos_doc INTO rDocu;
  vExiste := c_datos_doc%found;
  CLOSE c_datos_doc;
  IF NOT vExiste THEN
    pmsg_error := 'El documento '||pDocu||' no existe';
    RAISE error_proceso;
  END IF;

  -- Definir la fecha de anulacion.
  -- Ultimo dia del mes en proceso de la cuenta bancaria del cheque
  OPEN  c_fecha_anula(pDocu);
  FETCH c_fecha_anula INTO vFecha_anula;
  vExiste := c_fecha_anula%found;
  CLOSE c_fecha_anula;

  IF NOT vExiste THEN
    pmsg_error := 'No fue posible determinar la fecha de anulacion';
    RAISE error_proceso;
  END IF;

  --
  -- Caso: el cheque o la transferencia esta PENDIENTE.
  --       - Se eliminan las referencias y se marca como anulado
  IF rDocu.ind_act = 'P' THEN
    --
    -- Borra las referencias que tiene asociado el documento
    -- que se esta anulado, para evitar confusiones en el
    -- historial de documento
    DELETE arcprd
     WHERE no_cia  = pCia
       AND no_docu = pDocu;

    moneda.inicializa(pCia);
    --
    -- Marca el documento como anulado. Los montos se dejan en cero porque
    -- supuestamente queda "aplicado" y anulado, sin embargo no existe
    -- un doc de anulacion para balancear el saldo.
    UPDATE arcpmd
       SET ind_act       = 'A',
           anulado       = 'S',
           usuario_anula = USER,
           motivo_anula  = pMotivo,
           saldo         = 0,
           saldo_nominal = 0,
           monto         = 0,
           subtotal      = 0,
           tot_refer     = 0,
           tot_db        = 0,
           tot_cr        = 0,
           tot_dpp       = 0,
           excentos      = 0,
           detalle       = substr(detalle||' * Monto : '||to_char(monto),1, 100),
           ano_anulado   = to_number(to_char(vFecha_anula, 'YYYY')),
           mes_anulado   = to_number(to_char(vFecha_anula, 'MM'))
     WHERE rowid = rDocu.rowid;

  --
  -- Caso: El cheque ya fue APLICADO.
  --       - Generar una documento de anulacion, y hacer que el cheque lo referencie.
  --       - Debe tomarse en cuenta que la anulacion podria quedar Pendiente
  --         de aplicacion si Cheques esta en un mes posterior.
  --         Los cambios en las referencias, y los estados de los documentos
  --         afectados deben realizarse cuando que la anulacion sea aplicada.
  --         Debido a esto, parte del procedimiento de anulacion se paso a CPActualiza.
  ELSE

    -- Traer datos del tipo de documento de anulacion
    OPEN  c_tipo_anulacion(rDocu.tipo_mov);
    FETCH c_tipo_anulacion INTO rAnula;
    vExiste := c_tipo_anulacion%FOUND;
    CLOSE c_tipo_anulacion;

    IF NOT vExiste THEN
      pmsg_error := 'No fue posible encontrar el tipo de documento de anulacion para '||pTipo;
      RAISE error_proceso;
    END IF;

    --
    -- Registra el documento de anulacion en CxP
    -- El numero de control se asigna cuando se aplica la anulacion
    --
    vNo_docu_anula := Transa_Id.CP(pCia);

    -- En n_docu_a se guarda el documento que se esta anulando
    INSERT INTO arcpmd(no_cia, no_prove, tipo_doc,
                       no_docu, ind_act, fecha, subtotal,
                       monto, saldo, saldo_nominal,
                       tot_refer, tot_db, tot_cr,
                       tipo_cambio, moneda,
                       cod_diario, fecha_documento, origen,
                       detalle,
                       excentos, gravado, descuento,
                       monto_nominal,t_camb_c_v, monto_bienes,
                       monto_serv, monto_importac,
                       usuario_anula, motivo_anula, n_docu_a)
                VALUES(pcia, rDocu.no_prove, rAnula.tipo_doc,
                       vNo_docu_anula, 'P', vFecha_anula, rDocu.monto,
                       rDocu.monto, abs(rDocu.saldo), 0,
                       0, rDocu.tot_db, rDocu.tot_cr,
                       rDocu.tipo_cambio, rDocu.moneda,
                       rAnula.cod_diario, vFecha_anula, 'CP',
                       'Anulacion de '||rDocu.tipo_doc||' '||rDocu.no_fisico||
                           '  Serie : '||rDocu.serie_fisico||'  Transaccion : '||pDocu,
                       rDocu.excentos, rDocu.gravado, rDocu.descuento,
                       rDocu.monto_nominal, rDocu.t_camb_c_v, rDocu.monto_bienes,
                       rDocu.monto_serv, rDocu.monto_importac,
                       USER, pMotivo, pDocu);

    --
    -- Aplica la anulacion. Puede quedar pendiente si es de un mes posterior.
    -- CPActualiza se encarga de corregir el saldo y el estado de los docs afectados.
    CPActualiza(pCia, rDocu.no_prove, rAnula.tipo_doc, vNo_docu_anula, pmsg_error);
    IF pmsg_error IS NOT NULL THEN
      RAISE error_proceso;
    END IF;

  END IF; -- rDocu.ind_act = 'P'

EXCEPTION
  WHEN error_proceso THEN
    pmsg_error := 'CPANULA_CK: '||pmsg_error;
    RETURN;
  WHEN others THEN
    pmsg_error := 'CPANULA_CK: '||sqlerrm;
    RETURN;
END;


/*
CREATE OR REPLACE PROCEDURE CPAnula_ck(
  pCia         IN     varchar2,
  pTipo        IN     varchar2,
  pDocu        IN     varchar2,
  pMotivo      IN     varchar2,
  pmsg_error   IN OUT varchar2
) IS
  ---
  -- Datos del doc a anular
  CURSOR c_datos_doc(pNo_docu arcpmd.no_docu%TYPE) IS
    SELECT a.no_prove, a.monto, a.saldo, a.moneda,
           a.bloqueado, a.anulado, a.tipo_cambio,
           a.no_fisico, a.serie_fisico,
           a.excentos, a.gravado, a.tipo_doc, a.usuario_anula,
           a.tot_db, a.tot_cr, a.descuento, a.monto_nominal,
           a.monto_bienes, a.monto_serv, a.monto_importac,
           a.t_camb_c_v, a.ind_act, a.rowid, b.tipo_mov
      FROM arcpmd a, arcptd b
     WHERE a.no_cia   = pcia
       AND a.no_docu  = pNo_docu
       AND b.no_cia   = a.no_cia
       AND b.tipo_doc = a.tipo_doc;
  --
  -- La fecha de anulacion es el ultimo dia del mes de proceso
  -- de la cuenta bancaria del cheque
  CURSOR c_fecha_anula(pNo_docu arcpmd.no_docu%TYPE) IS
    SELECT last_day(to_date(to_char(c.mes_proc, 'FM00')||to_char(c.ano_proc, 'FM0000'),'MMYYYY'))
      FROM arcpmd a, arckmm b, arckmc c
     WHERE a.no_cia  = pcia
       AND a.no_docu = pNo_docu
       AND b.no_cia  = a.no_cia
       AND b.no_docu = a.no_docu
       AND c.no_cia  = b.no_cia
       AND c.no_cta  = b.no_cta;
  --
  -- Obtener el documento de anulacion segun el tipo de mov del doc a anular
 CURSOR c_tipo_anulacion (pTipo_mov arcptd.tipo_mov%TYPE) IS
    SELECT tipo_doc, cod_diario, tipo_mov
      FROM arcptd
     WHERE no_cia        = pCia
       AND tipo_mov      = decode(pTipo_mov,'D','C','D')
       AND ind_anulacion = 'S';
  --
  rDocu          c_datos_doc%ROWTYPE;
  rAnula         c_tipo_anulacion%ROWTYPE;
  --
  error_proceso  EXCEPTION;
  --
  vNo_docu_anula arcpmd.no_docu%TYPE;
  vFecha_anula   DATE;
  --
  vExiste        BOOLEAN;
  --
BEGIN
  --
  -- trae datos del documento
  OPEN  c_datos_doc(pDocu);
  FETCH c_datos_doc INTO rDocu;
  vExiste := c_datos_doc%found;
  CLOSE c_datos_doc;
  IF NOT vExiste THEN
    pmsg_error := 'El documento '||pDocu||' no existe';
    RAISE error_proceso;
  END IF;

  -- Definir la fecha de anulacion.
  -- Ultimo dia del mes en proceso de la cuenta bancaria del cheque
  OPEN  c_fecha_anula(pDocu);
  FETCH c_fecha_anula INTO vFecha_anula;
  vExiste := c_fecha_anula%found;
  CLOSE c_fecha_anula;

  IF NOT vExiste THEN
    pmsg_error := 'No fue posible determinar la fecha de anulacion';
    RAISE error_proceso;
  END IF;

  --
  -- Caso: el cheque o la transferencia esta PENDIENTE.
  --       - Se eliminan las referencias y se marca como anulado
  IF rDocu.ind_act = 'P' THEN
    --
    -- Borra las referencias que tiene asociado el documento
    -- que se esta anulado, para evitar confusiones en el
    -- historial de documento
    DELETE arcprd
     WHERE no_cia  = pCia
       AND no_docu = pDocu;

    moneda.inicializa(pCia);
    --
    -- Marca el documento como anulado. Los montos se dejan en cero porque
    -- supuestamente queda "aplicado" y anulado, sin embargo no existe
    -- un doc de anulacion para balancear el saldo.
    UPDATE arcpmd
       SET ind_act       = 'A',
           anulado       = 'S',
           usuario_anula = USER,
           motivo_anula  = pMotivo,
           saldo         = 0,
           saldo_nominal = 0,
           monto         = 0,
           subtotal      = 0,
           tot_refer     = 0,
           tot_db        = 0,
           tot_cr        = 0,
           tot_dpp       = 0,
           excentos      = 0,
           detalle       = substr(detalle||' * Monto : '||to_char(monto),1, 100),
           ano_anulado   = to_number(to_char(vFecha_anula, 'YYYY')),
           mes_anulado   = to_number(to_char(vFecha_anula, 'MM'))
     WHERE rowid = rDocu.rowid;

  --
  -- Caso: El cheque ya fue APLICADO.
  --       - Generar una documento de anulacion, y hacer que el cheque lo referencie.
  --       - Debe tomarse en cuenta que la anulacion podria quedar Pendiente
  --         de aplicacion si Cheques esta en un mes posterior.
  --         Los cambios en las referencias, y los estados de los documentos
  --         afectados deben realizarse cuando que la anulacion sea aplicada.
  --         Debido a esto, parte del procedimiento de anulacion se paso a CPActualiza.
  ELSE

    -- Traer datos del tipo de documento de anulacion
    OPEN  c_tipo_anulacion(rDocu.tipo_mov);
    FETCH c_tipo_anulacion INTO rAnula;
    vExiste := c_tipo_anulacion%FOUND;
    CLOSE c_tipo_anulacion;

    IF NOT vExiste THEN
      pmsg_error := 'No fue posible encontrar el tipo de documento de anulacion para '||pTipo;
      RAISE error_proceso;
    END IF;

    --
    -- Registra el documento de anulacion en CxP
    -- El numero de control se asigna cuando se aplica la anulacion
    --
    vNo_docu_anula := Transa_Id.CP(pCia);

    -- En n_docu_a se guarda el documento que se esta anulando
    INSERT INTO arcpmd(no_cia, no_prove, tipo_doc,
                       no_docu, ind_act, fecha, subtotal,
                       monto, saldo, saldo_nominal,
                       tot_refer, tot_db, tot_cr,
                       tipo_cambio, moneda,
                       cod_diario, fecha_documento, origen,
                       detalle,
                       excentos, gravado, descuento,
                       monto_nominal,t_camb_c_v, monto_bienes,
                       monto_serv, monto_importac,
                       usuario_anula, motivo_anula, n_docu_a)
                VALUES(pcia, rDocu.no_prove, rAnula.tipo_doc,
                       vNo_docu_anula, 'P', vFecha_anula, rDocu.monto,
                       rDocu.monto, abs(rDocu.saldo), 0,
                       0, rDocu.tot_db, rDocu.tot_cr,
                       rDocu.tipo_cambio, rDocu.moneda,
                       rAnula.cod_diario, vFecha_anula, 'CP',
                       'Anulacion de '||rDocu.tipo_doc||' '||rDocu.no_fisico||
                           '  Serie : '||rDocu.serie_fisico||'  Transaccion : '||pDocu,
                       rDocu.excentos, rDocu.gravado, rDocu.descuento,
                       rDocu.monto_nominal, rDocu.t_camb_c_v, rDocu.monto_bienes,
                       rDocu.monto_serv, rDocu.monto_importac,
                       USER, pMotivo, pDocu);

    --
    -- Aplica la anulacion. Puede quedar pendiente si es de un mes posterior.
    -- CPActualiza se encarga de corregir el saldo y el estado de los docs afectados.
    CPActualiza(pCia, rDocu.no_prove, rAnula.tipo_doc, vNo_docu_anula, pmsg_error);
    IF pmsg_error IS NOT NULL THEN
      RAISE error_proceso;
    END IF;

  END IF; -- rDocu.ind_act = 'P'

EXCEPTION
  WHEN error_proceso THEN
    pmsg_error := 'CPANULA_CK: '||pmsg_error||'2'||vNo_docu_anula;
    RETURN;
  WHEN others THEN
    pmsg_error := 'CPANULA_CK: '||sqlerrm||'2'||vNo_docu_anula;
    RETURN;
END;
*/