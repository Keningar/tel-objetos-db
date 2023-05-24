BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
      ,start_date      => TO_TIMESTAMP_TZ('2022/12/13 11:00:00.000000 America/Guayaquil','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=DAILY;BYHOUR=23;BYMINUTE=45'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'BEGIN DB_COMERCIAL.CMKG_INACT_CORREOS_PERSONALES.P_INACTIVAR_CORREOS_PERSONALES; END;'
      ,comments        => 'Job de inactivación de correos electrónicos personales de empleados.'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES'
     ,attribute => 'STORE_OUTPUT'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'DB_COMERCIAL.JOB_INAC_CORREOS_PERSONALES');
END;
/
