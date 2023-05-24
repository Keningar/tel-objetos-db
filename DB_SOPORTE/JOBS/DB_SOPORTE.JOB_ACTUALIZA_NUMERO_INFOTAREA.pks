BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
      ,start_date      => TO_TIMESTAMP_TZ('2023/05/14 02:04:19.206915 America/Guayaquil','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'DECLARE
			  	 PV_MENSAJE_RESPUESTA VARCHAR2(200);
			   BEGIN
			     DB_SOPORTE.SPKG_INFO_TAREA.P_REINICIAR_NUMERACION(
			         PV_MENSAJE_RESPUESTA => PV_MENSAJE_RESPUESTA
			     );
			   END;'
      ,comments        => 'SE EJECUTA PARA ACTUALIZAR LA SECUENCIA DE NUMERACION PARA TABLA INFO TAREA'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA'
     ,attribute => 'STORE_OUTPUT'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'DB_SOPORTE.JOB_ACTUALIZA_NUMERO_INFOTAREA');
END;
/
