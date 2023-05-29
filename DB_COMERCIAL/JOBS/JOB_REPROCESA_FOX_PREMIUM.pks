BEGIN 
dbms_scheduler.create_job('"JOB_REPROCESA_FOX_PREMIUM"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE Lv_Mensaje VARCHAR2(4000); BEGIN DB_COMERCIAL.CMKG_FOX_PREMIUM.P_JOB_CLEAR_CACHE_TOOLBOX(Pv_Mensaje => Lv_Mensaje); END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-DEC-2018 11.50.00.000000000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=23;BYMINUTE=50;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que realiza el reproceso para limpiar la caché de un usuario FOX PREMIUM en Toolbox. Se reprocesan aquellos que tuvieron problemas en su primer intento'
);
sys.dbms_scheduler.set_attribute('"JOB_REPROCESA_FOX_PREMIUM"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_REPROCESA_FOX_PREMIUM"');
COMMIT; 
END; 
/ 