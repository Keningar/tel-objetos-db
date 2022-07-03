-- Eliminar el Job de barrido de tareas para departamentos de la lista administrativo

BEGIN
    DBMS_SCHEDULER.DROP_JOB (
       job_name             => '"DB_HORAS_EXTRAS"."JOB_GENERA_HE_VERI_TAREAS_ADMI"'
       );

END;
/