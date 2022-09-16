/*
 * DROP DEL JOB 'JOB_CAD_CRED_LINKS'
 */
SET SERVEROUTPUT ON;
BEGIN
  DBMS_SCHEDULER.DROP_JOB(JOB_NAME => '"DB_COMERCIAL"."JOB_CAD_CRED_LINKS"',
                          DEFER    => FALSE,
                          FORCE    => TRUE);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('El job aún no ha sido creado...');
END;
/
