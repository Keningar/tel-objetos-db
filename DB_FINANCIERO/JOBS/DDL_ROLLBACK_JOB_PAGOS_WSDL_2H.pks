/*
 * DROP DEL JOB 'JOB_PAGOS_WSDL_2H'
 */
SET SERVEROUTPUT ON;
BEGIN
  DBMS_SCHEDULER.DROP_JOB(JOB_NAME => '"DB_FINANCIERO"."JOB_PAGOS_WSDL_2H"',
                            DEFER    => FALSE,
                            FORCE    => TRUE);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('El job aún no ha sido creado...');
END;
/