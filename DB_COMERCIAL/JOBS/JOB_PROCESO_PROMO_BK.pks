BEGIN 
dbms_scheduler.create_job('"JOB_PROCESO_PROMO_BK"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN
                                      DB_COMERCIAL.CMKG_PROMOCIONES_BK.P_PROCESO_PROMO_BK;
                                  END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.27.123914000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=05;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que ejecuta el proceso de respaldo de los procesos de promoción de Ancho de Banda'
);
sys.dbms_scheduler.set_attribute('"JOB_PROCESO_PROMO_BK"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_PROCESO_PROMO_BK"');
COMMIT; 
END; 
/ 