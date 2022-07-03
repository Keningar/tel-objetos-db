-- Eliminar el Job de barrido de tareas tipo horas extras

BEGIN
    DBMS_SCHEDULER.DROP_JOB (
       job_name             => '"DB_HORAS_EXTRAS"."JOB_BARRIDO_TAREAS"'
       );

END;
/