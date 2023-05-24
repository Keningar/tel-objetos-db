BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
      ,start_date      => TO_TIMESTAMP_TZ('2023/05/19 23:00:00.000000 America/Guayaquil','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=DAILY;INTERVAL=3'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'DECLARE
  --
 CURSOR C_GetFechaPLDescartar(Cn_NumeroDeHORAS NUMBER)
  IS
    SELECT CAST(SYSDATE - ( Cn_NumeroDeHORAS/24 )   AS TIMESTAMP WITH TIME ZONE)
  FROM DUAL;
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_EmpresaId            DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE;
  Ln_NumeroDeHoras        NUMBER;
  Lv_EstadoPl             DB_FINANCIERO.INFO_PAGO_LINEA.ESTADO_PAGO_LINEA%TYPE;
  Lv_msnResult            VARCHAR2(200);
  Lv_messageError         VARCHAR2(200);
  Lt_FechaPLDescartar     TIMESTAMP (6);
  --
BEGIN
  --
  Lv_EmpresaId      := ''18'';
  Ln_NumeroDeHoras  :=  24;
  Lv_EstadoPl       := ''Pendiente'';
  --
  Lrf_GetAdmiParamtrosDet := NULL;
  --
  --Verifica que la empresa al cual se va a descartar pagos en linea
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(''EMPRESA_DESCARTAR_PL'', ''Activo'',
                                                                     ''Activo'', ''EMPRESA_PL'',
                                                                      NULL, NULL, NULL);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
     Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
     --
     Lv_EmpresaId := Lr_GetAdmiParamtrosDet.VALOR2;
     --
  END IF;
  --
  Lrf_GetAdmiParamtrosDet := NULL;
  --
  Lr_GetAdmiParamtrosDet := NULL;
  --
  --Verifica el numero de horas maximo a descartar los pagos en linea
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(''NUMERO_HORAS_DESCARTAR_PL'', ''Activo'',
                                                                     ''Activo'', ''NUMERO_HORAS_PL'',
                                                                      NULL, NULL, NULL);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
     Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
     --
     Ln_NumeroDeHoras := Lr_GetAdmiParamtrosDet.VALOR2;
     --
  END IF;
  --
  Lrf_GetAdmiParamtrosDet := NULL;
  --
  Lr_GetAdmiParamtrosDet := NULL;
  --
  --Verifica el estado de los pagos en linea a descartar
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(''ESTADO_DESCARTAR_PL'', ''Activo'',
                                                                     ''Activo'', ''ESTADO_PL'',
                                                                      NULL, NULL, NULL);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
     Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
     --
     Lv_EstadoPl := Lr_GetAdmiParamtrosDet.VALOR2;
     --
  END IF;
  --
  Lrf_GetAdmiParamtrosDet   := NULL;
  --
  Lr_GetAdmiParamtrosDet    := NULL;
  --
  --Obtengo la fecha a descartar por medio del numero de horas.
  OPEN  C_GetFechaPLDescartar(Ln_NumeroDeHoras);
  FETCH C_GetFechaPLDescartar INTO Lt_FechaPLDescartar;
  CLOSE C_GetFechaPLDescartar;

  --Llamada al procedimiento que Regulariza los pagos en linea que se encuentran en estado Pendiente
  --Que tengan un tiempo maximo de 24 horas.
           FNCK_CONSULTS.P_DESCARTA_PAGO_LINEA(
                                                PV_EMPRESAID        => Lv_EmpresaId,
                                                PT_FECHAPLDESCARTAR => Lt_FechaPLDescartar,
                                                PV_ESTADOPL         => Lv_EstadoPl,
                                                PV_MSNRESULT        => Lv_msnResult,
                                                PV_MESSAGEERROR     => Lv_messageError
                                              );

END;'
      ,comments        => 'Se deben dar de baja los pagos en linea que se encuentran en estado "Pendiente" en la tabla INFO_PAGO_LINEA, los mismos para darse de baja deben tener un tiempo maximo de 24 horas.'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_FULL);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA'
     ,attribute => 'STORE_OUTPUT'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'DB_FINANCIERO.DESCARTA_PAGOS_EN_LINEA');
END;
/
