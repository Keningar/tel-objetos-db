BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
      ,start_date      => TO_TIMESTAMP_TZ('2017/01/19 22:07:10.233239 America/Guayaquil','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=DAILY;BYHOUR=7;BYMINUTE=0;BYSECOND=0'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'DECLARE
  --
  CURSOR GetFechaDesde(Cv_NumeroDeHoras NUMBER)
  IS
    SELECT CAST(TRUNC(SYSDATE) - ( Cv_NumeroDeHoras/24 )   AS TIMESTAMP WITH TIME ZONE)
      FROM DUAL;

  --
  CURSOR GetFechaHasta
  IS
    SELECT CAST(SYSDATE AS  TIMESTAMP WITH TIME ZONE)
    FROM DUAL;
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_PrefijoEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  Ln_NumeroDeHoras        NUMBER;
  Lv_msnResult            VARCHAR2(500);
  Lv_messageError         VARCHAR2(500);
  Lt_FechaPeDesde         TIMESTAMP (6);
  Lt_FechaPeHasta         TIMESTAMP (6);
  Lv_CodigoPlantilla      VARCHAR2(100);
  Lv_Caracteristica       VARCHAR2(100);
  Lv_EstadoPreFac         VARCHAR2(100);
  --
BEGIN
  --
  Lv_PrefijoEmpresa  := ''TN'';
  Ln_NumeroDeHoras   :=  24;
  Lv_CodigoPlantilla := ''NOT_PREFAC_PROP'';
  Lv_Caracteristica  := ''NOTIFICACION_PREFACTURAS_PROPORCIONALES'';
  Lv_EstadoPreFac    := ''Pendiente'';
  --
  Lrf_GetAdmiParamtrosDet := NULL;
  --
  --Verifica prefijo de la empresa al cual se van a notificar los documentos eliminados.
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(''EMPRESA_PREFIJO_PP'', ''Activo'',
                                                                     ''Activo'', ''EMPRESA_PP'',
                                                                      NULL, NULL, NULL);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
     Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
     --
     Lv_PrefijoEmpresa := Lr_GetAdmiParamtrosDet.VALOR2;
     --
  END IF;
  --
  Lrf_GetAdmiParamtrosDet := NULL;
  --
  Lr_GetAdmiParamtrosDet := NULL;
  --
  --Verifica desde que fecha se obtendra los documentos a notificar por medio del numero de horas.
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(''TIEMPO_FACTURAS_PROPORCIONALES'', ''Activo'',
                                                                     ''Activo'', ''NUMERO_HORAS_PP'',
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
  --Obtengo la fecha desde a partir del numero de horas.
  OPEN GetFechaDesde(Ln_NumeroDeHoras);
  FETCH GetFechaDesde INTO Lt_FechaPeDesde;
  CLOSE GetFechaDesde;
  --
  OPEN  GetFechaHasta;
  FETCH GetFechaHasta INTO Lt_FechaPeHasta;
  CLOSE GetFechaHasta;
  --
  --Llamada al procedimiento que notifica las pre facturas proporcionales creadas en el periodo de tiempo
  --enviado como parametro.

   FNKG_NOTIFICACIONES.P_NOTIFICACION_PREFACTURAS(
                                              PV_PREFIJOEMPRESA   => Lv_PrefijoEmpresa,
                                              PT_FECHAPEDESDE     => Lt_FechaPeDesde,
                                              PT_FECHAPEHASTA     => Lt_FechaPeHasta,
                                              PV_ESTADOPREFAC     => Lv_EstadoPreFac,
                                              PV_CODIGOPLANTILLA  => Lv_CodigoPlantilla,
                                              PV_CARACTERISTICA   => Lv_Caracteristica,
                                              PV_MSNRESULT        => Lv_msnResult,
                                              PV_MESSAGEERROR     => Lv_messageError
  );

END;'
      ,comments        => 'EJECUTA ENVIO DE NOTIFICACION DE FACTURAS PROPORCIONALES'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP'
     ,attribute => 'STORE_OUTPUT'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'DB_FINANCIERO.JOB_NOTIFICACION_PREFAC_PROP');
END;
/
