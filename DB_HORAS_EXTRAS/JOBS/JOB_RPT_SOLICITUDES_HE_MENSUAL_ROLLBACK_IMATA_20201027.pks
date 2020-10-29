BEGIN
    DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_HORAS_EXTRAS"."JOB_RPT_SOLICITUDES_HE_MENSUAL"',
                                defer => false,
                                force => false);
END;

/

