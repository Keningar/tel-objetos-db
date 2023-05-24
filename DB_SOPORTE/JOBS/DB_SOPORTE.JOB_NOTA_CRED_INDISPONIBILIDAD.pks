BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
      ,start_date      => TO_TIMESTAMP_TZ('2023/05/14 02:04:25.628170 America/Guayaquil','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=MINUTELY;INTERVAL=30'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'DECLARE   
            PV_MENSAJE_RESPUESTA VARCHAR2(500);
				BEGIN						   
				DB_SOPORTE.SPKG_SOPORTE.P_CREA_NC_POR_INDISPONIBILIDAD(Pv_Error => PV_MENSAJE_RESPUESTA);
			   END;'
      ,comments        => 'Proceso para realiza la creacion de notas de credito por indisponibilidad'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_FULL);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD'
     ,attribute => 'STORE_OUTPUT'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'DB_SOPORTE.JOB_NOTA_CRED_INDISPONIBILIDAD');
END;
/
