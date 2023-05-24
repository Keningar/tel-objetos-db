BEGIN 
dbms_scheduler.create_job('"JOB_NOTIFICA_TRANSFERENCIA"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN 
                             --
                             NAF47_TNET.INKG_TRANSFERENCIAS.P_NOTIFICACION_TRANSFERENCIA;
                             --
                           END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('01-FEB-2021 12.00.00.024445000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para generaci�n de notificaciones a jefes de bodegas por transferencias pendientes de recibir'
);
sys.dbms_scheduler.set_attribute('"JOB_NOTIFICA_TRANSFERENCIA"','NLS_ENV','NLS_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_TERRITORY=''ECUADOR'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''ECUADOR'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RRRR'' NLS_DATE_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH12:MI:SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD/MM/RRRR HH24:MI'' NLS_TIME_TZ_FORMAT=''HH12:MI:SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RRRR HH24:MI'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_NOTIFICA_TRANSFERENCIA"');
COMMIT; 
END; 
/ 