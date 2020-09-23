BEGIN
    DBMS_SCHEDULER.DROP_JOB(job_name => '"DB_HORAS_EXTRAS"."JOB_SOLICITUDES_HE_AUTORIZADAS"',
                                defer => false,
                                force => false);
END;

/
