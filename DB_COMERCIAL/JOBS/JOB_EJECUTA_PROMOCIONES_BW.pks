BEGIN 
dbms_scheduler.create_job('"JOB_EJECUTA_PROMOCIONES_BW"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                Lv_TipoProcesoAplicar VARCHAR2(50) := ''APLICAR'';
                           BEGIN
                                DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_EJECUTAR_PROMOCIONES_BW(Pv_Tipo => Lv_TipoProcesoAplicar);
                           END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('17-FEB-2022 10.00.00.000000000 PM AMERICA/BOGOTA','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY;INTERVAL=30;'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que se ejecuta para verificar si existe un proceso de promoci�n de ancho de banda por iniciar.'
);
sys.dbms_scheduler.set_attribute('"JOB_EJECUTA_PROMOCIONES_BW"','NLS_ENV','NLS_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_TERRITORY=''ECUADOR'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''ECUADOR'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RRRR'' NLS_DATE_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH12:MI:SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD/MM/RRRR HH12:MI:SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH12:MI:SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RRRR HH12:MI:SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_EJECUTA_PROMOCIONES_BW"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_EJECUTA_PROMOCIONES_BW"');
COMMIT; 
END; 
/ 