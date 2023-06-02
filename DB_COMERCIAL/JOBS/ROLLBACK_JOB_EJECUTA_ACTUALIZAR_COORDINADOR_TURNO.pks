/**
 * Eliminación de Job JOB_EJECUTA_ACTUALIZAR_COORDINADOR_TURNO 
 * 
 * @author Daniel Guzmán <ddguzman@telconet.ec>
 * @version 1.0 11-01-2023 
 */

BEGIN
  DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_COMERCIAL"."JOB_EJECUTA_ACTUALIZAR_COORDINADOR_TURNO"',
                          defer    => false,
                          force    => true);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR AL ELIMINAR JOB');
END;