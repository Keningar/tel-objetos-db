
BEGIN 
dbms_scheduler.create_job('"JOB_REPORTE_OS_REINGRESADOS"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                      
                                      Lv_CodigoEmpresa  VARCHAR2(2);
                                    BEGIN
                                      Lv_CodigoEmpresa := ''18'';
                                      
                                      DB_COMERCIAL.CMKG_REINGRESO.P_REPORTE_REINGRESO(Lv_CodigoEmpresa);
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.19.819574000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=00;BYMINUTE=00;BYSECOND=00'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que genera un reporte de todos los servicios reingresados que se convirtieron 
                                    en OT el día anterior.'
);
sys.dbms_scheduler.set_attribute('"JOB_REPORTE_OS_REINGRESADOS"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY='''' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY='''' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_REPORTE_OS_REINGRESADOS"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_REPORTE_OS_REINGRESADOS"');
COMMIT; 
END; 
/ 