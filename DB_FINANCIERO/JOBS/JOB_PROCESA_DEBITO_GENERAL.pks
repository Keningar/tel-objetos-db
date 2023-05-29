
BEGIN 
dbms_scheduler.create_job('"JOB_PROCESA_DEBITO_GENERAL"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
  Lv_Mensaje   VARCHAR2(400);
BEGIN
  DB_FINANCIERO.FNKG_CONSULTA_DETALLES_DEBITOS.P_PROCESA_DEBITO_GENERAL(''JobProcesaDeb'', Lv_Mensaje);
END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('11-DEC-2022 10.46.54.524382000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=20;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Anula las cabeceras de los d�bitos (diario de valores en 0 y un rango establecido de d�bitos no procesados.)'
);
sys.dbms_scheduler.set_attribute('"JOB_PROCESA_DEBITO_GENERAL"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_PROCESA_DEBITO_GENERAL"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_PROCESA_DEBITO_GENERAL"');
COMMIT; 
END; 
/ 