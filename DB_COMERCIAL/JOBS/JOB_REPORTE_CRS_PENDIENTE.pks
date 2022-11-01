-- Job que procesa los tickets para ser enviados por correo a ECUCERT. Dicho proceso se ejecuta cada 5 minutos 
-- consume proceso de CERT para actualizar el estado de vulnerabilidad y enviar el correo.

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
       job_name             => '"DB_COMERCIAL"."JOB_REPORTE_CRS_PENDIENTE"',
       job_type             => 'STORED_PROCEDURE',
       job_action           => 'DB_COMERCIAL.SPKG_CAMBIO_RAZON_SOCIAL.P_NOTIFICACION_PENDIENTE_CRS',
       number_of_arguments  =>  1,
       start_date           => SYSDATE, 
       repeat_interval      => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN;BYHOUR=23;BYMINUTE=0;BYSECOND=0', 
       end_date             =>  NULL,
       enabled              =>  FALSE,
       auto_drop            =>  FALSE,
       comments             => 'Generacion de reporte para CRS CD');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"DB_COMERCIAL"."JOB_REPORTE_CRS_PENDIENTE"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
             
     DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                   job_name                => '"DB_COMERCIAL"."JOB_REPORTE_CRS_PENDIENTE"', 
                   argument_position       => 1,
                   argument_value          => 'telcos');
      
    DBMS_SCHEDULER.enable(
             name => '"DB_COMERCIAL"."JOB_REPORTE_CRS_PENDIENTE"');
END;
/