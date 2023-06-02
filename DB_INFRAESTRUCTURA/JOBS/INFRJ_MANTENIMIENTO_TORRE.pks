--=======================================================================
--  Se crea Job para envio de notificaciones masivas de las torres a dar mantenimiento preventivo.
--=======================================================================

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"DB_INFRAESTRUCTURA"."INFRJ_MANTENIMIENTO_TORRE"',
            job_type => 'STORED_PROCEDURE',
            job_action => 'DB_INFRAESTRUCTURA.INKG_MANTENIMIENTO_TORRE.P_PROXIMO_MANTENIMIENTO',
            number_of_arguments => 2,
            start_date => TO_TIMESTAMP_TZ('2019-09-15 06:00:10.000000000 AMERICA/GUAYAQUIL','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'NOTIFICACIONES MASIVAS PARA MANTENIMIENTOS PREVENTIVOS DE TORRES');

    DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE( 
             job_name => '"DB_INFRAESTRUCTURA"."INFRJ_MANTENIMIENTO_TORRE"', 
             argument_position => 1, 
             argument_value => 'TRUNC(SYSDATE)');

    DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE( 
             job_name => '"DB_INFRAESTRUCTURA"."INFRJ_MANTENIMIENTO_TORRE"', 
             argument_position => 2, 
             argument_value => 'NULL');     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"DB_INFRAESTRUCTURA"."INFRJ_MANTENIMIENTO_TORRE"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);  
    
    DBMS_SCHEDULER.enable(
             name => '"DB_INFRAESTRUCTURA"."INFRJ_MANTENIMIENTO_TORRE"');
END;
/