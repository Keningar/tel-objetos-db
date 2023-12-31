
BEGIN 
dbms_scheduler.create_job('"JOB_CLIENTE_SIN_DEUDA"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
  Pv_MensajeError VARCHAR2(3000) := '''';
BEGIN
  DB_COMERCIAL.COMEK_TRANSACTION.P_CLIENTE_SIN_DEUDA(Pv_MensajeError);
END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-JUL-2017 03.10.15.000000000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY;INTERVAL=5'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Se finalizan todas las solicitudes de preplanificacion cuando el cliente ya no posee deuda'
);
sys.dbms_scheduler.set_attribute('"JOB_CLIENTE_SIN_DEUDA"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_CLIENTE_SIN_DEUDA"');
COMMIT; 
END; 
/ 