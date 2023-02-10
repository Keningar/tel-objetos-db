/**
 * Documentacion para el job JOB_REINICIA_SECUENCIAS_CASOS
 *
 * Job que ejecuta el procedimiento P_REINICIAR_SECUENCIAS_CASOS que se encuentra en el paquete DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION y que reinicia las secuencias según
 * el tipo de caso con frecuencia diaria a las 00:00:00
 *
 * @author Jorge Gomez <jigomez@telconet.ec>
 * @version 1.0
 * @since 26-01-2023
 */
BEGIN
   BEGIN
        DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_SOPORTE"."JOB_REINICIA_SECUENCIAS_CASOS"',
                                defer    => false,
                                force    => true);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EL JOB DB_SOPORTE.JOB_REINICIA_SECUENCIAS_CASOS AÚN NO HA SIDO CREADO');
    END;

    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"DB_SOPORTE"."JOB_REINICIA_SECUENCIAS_CASOS"',
            job_type => 'STORED_PROCEDURE',
            job_action => 'DB_SOPORTE.SPKG_CASOS_INSERT_TRANSACCION.P_REINICIAR_SECUENCIAS_CASOS',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-06-06 00:00:00.000000000 AMERICA/GUAYAQUIL','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0',
            end_date => NULL,
            enabled => false,
            auto_drop => FALSE,
            comments => 'Job que se ejecuta diariamente y reinicia las secuencias según el tipo de caso');
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"DB_SOPORTE"."JOB_REINICIA_SECUENCIAS_CASOS"',
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
  
    
    DBMS_SCHEDULER.enable(
             name => '"DB_SOPORTE"."JOB_REINICIA_SECUENCIAS_CASOS"');
END;

/
