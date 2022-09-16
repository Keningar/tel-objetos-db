-- Job que evalua las credenciales y las inactiva . Dicho proceso se ejecuta cada 5 minutos 

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
       job_name             => '"DB_COMERCIAL"."JOB_CAD_CRED_LINKS"',
       job_type             => 'STORED_PROCEDURE',
       job_action           => 'DB_COMERCIAL.CMKG_TAREAS_PROGRAMADAS.P_CADUCA_CREDENCIALES_LINK_BCO',
       number_of_arguments  =>  0,
       start_date           =>  NULL,
       repeat_interval      => 'FREQ=MINUTELY;INTERVAL=5',
       end_date             =>  NULL,
       enabled              =>  FALSE,
       auto_drop            =>  FALSE,
       comments             => 'Procesamiento de caducidad de las credendiales proceso link bancario');

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"DB_COMERCIAL"."JOB_CAD_CRED_LINKS"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
    DBMS_SCHEDULER.enable(
             name => '"DB_COMERCIAL"."JOB_CAD_CRED_LINKS"');
END;
/