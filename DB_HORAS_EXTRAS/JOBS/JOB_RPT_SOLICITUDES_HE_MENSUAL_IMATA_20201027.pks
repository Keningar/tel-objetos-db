/**
 * JOB_RPT_SOLICITUDES_HE_MENSUAL
 *
 * Job que se ejecuta para el envio mensual a gerencia del reporte general y detallado de solicitudes autorizadas.
 * 
 * @author Ivan Mata <imata@telconet.ec>
 * @since 1.0 15-07-2020
 */

BEGIN
    BEGIN
        DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_HORAS_EXTRAS"."JOB_RPT_SOLICITUDES_HE_MENSUAL"',
                                defer    => false,
                                force    => true);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EL JOB AÚN NO HA SIDO CREADO');
    END;
    
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"DB_HORAS_EXTRAS"."JOB_RPT_SOLICITUDES_HE_MENSUAL"',
            job_type => 'PLSQL_BLOCK',
            job_action => '
            DECLARE

                  Lv_EmpresaCod         VARCHAR2(2):=''10'';
                  Lv_Remitente          VARCHAR2(100):=''notificaciones_sistemas@telconet.ec''; 
                  Lv_Asunto             VARCHAR2(300):=''Reporte de solicitudes de horas extras autorizadas'';            

            BEGIN

                    DB_HORAS_EXTRAS.HEKG_HORASEXTRAS_TRANSACCION.P_REPORTE_AUTORIZACIONES
                                      (
                                        Lv_EmpresaCod,
                                        Lv_Remitente,
                                        Lv_Asunto
                                      );             

            END;',
                           
    number_of_arguments => 0,            
    repeat_interval     => 'FREQ=MONTHLY; INTERVAL=1; BYMONTHDAY=21;BYHOUR=0;BYMINUTE=1',
    end_date            => NULL,
    enabled             => TRUE,
    auto_drop           => FALSE,
    comments            => 'Job que se ejecuta para el envio de reporte de solucitudes autorizadas');
                           
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
         name      => '"DB_HORAS_EXTRAS"."JOB_RPT_SOLICITUDES_HE_MENSUAL"', 
         attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
             
    
    DBMS_SCHEDULER.enable(
         name => '"DB_HORAS_EXTRAS"."JOB_RPT_SOLICITUDES_HE_MENSUAL"');

    DBMS_OUTPUT.PUT_LINE('Job creado satisfactoriamente...');

END;
/
