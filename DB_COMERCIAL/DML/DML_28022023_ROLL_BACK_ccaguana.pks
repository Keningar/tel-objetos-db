
/**
 * DEBE EJECUTARSE EN DB_COMERCIAL.
 * Parametros para el catalogo movil Comercial
 * @author Carlos Caguana<jbroncano@telconet.ec>
 */

SET SERVEROUTPUT ON;
BEGIN
  DBMS_SCHEDULER.DROP_JOB(JOB_NAME => '"DB_COMERCIAL"."JOB_CATALOGOS_MOBILE"',
                          DEFER    => FALSE,
                          FORCE    => TRUE);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('El job aún no ha sido creado...');
END;

/


BEGIN
    DBMS_SCHEDULER.CREATE_JOB
    (
      job_name => '"DB_COMERCIAL"."JOB_CATALOGOS_MOBILE"',
      job_type => 'PLSQL_BLOCK',
      job_action => 'DECLARE
                      Lv_Error VARCHAR2(2000);
                      BEGIN
                          DB_COMERCIAL.CMKG_CATALOGOS_MOBILE.P_GENERA_JSON_CATALOGOS(''18'', NULL, Lv_Error) ;
                      END;',
      number_of_arguments => 0,
      start_date => NULL,
      repeat_interval => 'FREQ=HOURLY; INTERVAL=2',
      end_date => NULL,
      enabled => FALSE,
      auto_drop => FALSE,
      comments => 'Proceso para generar catalogos de TM-COMERCIAL.'
    );

    DBMS_SCHEDULER.SET_ATTRIBUTE
    (
       name => '"DB_COMERCIAL"."JOB_CATALOGOS_MOBILE"',
       attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF
    );

    DBMS_SCHEDULER.enable
    (
       name => '"DB_COMERCIAL"."JOB_CATALOGOS_MOBILE"'
    );
END;

/           