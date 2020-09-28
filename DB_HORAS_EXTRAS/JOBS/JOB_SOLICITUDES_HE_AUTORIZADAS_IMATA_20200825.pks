/**
 * JOB_RPT_SOLICITUDES_HE_AUTORIZADAS
 *
 * Job que ejecuta para el envio diario de notificaciones a los empleados indicando que la solicitud
 * ya se encuentra autorizada
 * 
 * @author Ivan Mata <imata@telconet.ec>
 * @since 1.0 25-08-2020
 */

BEGIN
    BEGIN
        DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_HORAS_EXTRAS"."JOB_SOLICITUDES_HE_AUTORIZADAS"',
                                defer    => false,
                                force    => true);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EL JOB AÚN NO HA SIDO CREADO');
    END;
    
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"DB_HORAS_EXTRAS"."JOB_SOLICITUDES_HE_AUTORIZADAS"',
            job_type => 'PLSQL_BLOCK',
            job_action => '
                            DECLARE

       
                                      Lv_Empresa_Cod           VARCHAR2(2):=''10'';
                                      Lv_Remitente             VARCHAR2(100):=''notificaciones_sistemas@telconet.ec''; 
                                      Lv_Asunto                VARCHAR2(300):=''Reporte de solicitud autorizada'';
 
                             BEGIN
 
                                    DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_ENVIO_MAIL_HE
                                                       (
                                                         Lv_Empresa_Cod,
                                                         Lv_Remitente,
                                                         Lv_Asunto
                                                        );
                                      

                             END;',
                           
    number_of_arguments => 0,            
    REPEAT_INTERVAL     => 'FREQ=DAILY;BYHOUR=23;BYMINUTE=15;BYSECOND=0',
    end_date            => NULL,
    enabled             => TRUE,
    auto_drop           => FALSE,
    comments            => 'Job que se ejecuta para el envio de reporte de solucitudes autorizadas al empleado');
                           
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
         name      => '"DB_HORAS_EXTRAS"."JOB_SOLICITUDES_HE_AUTORIZADAS"', 
         attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
             
    
    DBMS_SCHEDULER.enable(
         name => '"DB_HORAS_EXTRAS"."JOB_SOLICITUDES_HE_AUTORIZADAS"');

    DBMS_OUTPUT.PUT_LINE('Job creado satisfactoriamente...');

END;
/
