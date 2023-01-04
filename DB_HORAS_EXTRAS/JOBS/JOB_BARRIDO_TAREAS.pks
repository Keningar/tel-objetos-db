/**
 * JOB_BARRIDO_TAREAS
 *
 * Job que se ejecuta diariamente para el barrido de tareas tipo proceso horas extras 
 * 
 * @author Katherine POrtugal <kportugal@telconet.ec>
 * @since 1.0 15-05-2021
 */

BEGIN
    BEGIN
        DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_HORAS_EXTRAS"."JOB_BARRIDO_TAREAS"',
                                defer    => false,
                                force    => true);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EL JOB AÚN NO HA SIDO CREADO');
    END;
    
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"DB_HORAS_EXTRAS"."JOB_BARRIDO_TAREAS"',
            job_type => 'PLSQL_BLOCK',
            job_action => '
            DECLARE

                  Pv_Error          VARCHAR2(500);          

            BEGIN

                    DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_GENERA_HE_VERIFICACION
                                      (Pv_Error => Pv_Error );             

            END;',
                           
    number_of_arguments => 0,            
    repeat_interval     => 'FREQ=DAILY;BYHOUR=00;BYMINUTE=01;BYSECOND=00',
    end_date            => NULL,
    enabled             => FALSE,
    auto_drop           => FALSE,
    comments            => 'Job que se ejecuta diariamente para el barrido de tareas tipo proceso horas extras ');
                           
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
         name      => '"DB_HORAS_EXTRAS"."JOB_BARRIDO_TAREAS"', 
         attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
             
    
    DBMS_SCHEDULER.enable(
         name => '"DB_HORAS_EXTRAS"."JOB_BARRIDO_TAREAS"');

    DBMS_OUTPUT.PUT_LINE('Job creado satisfactoriamente...');

END;
/
