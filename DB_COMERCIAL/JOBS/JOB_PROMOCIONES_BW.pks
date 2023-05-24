BEGIN 
dbms_scheduler.create_job('"JOB_PROMOCIONES_BW"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                    Lcl_Mensaje  CLOB;
                                  BEGIN
        DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PIERDE_PROMO_BW(''18'',''PROM_BW'');
                                      DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PROCESO_MASIVO_BW(''EXISTENTE'',NULL,''Activo'',Lcl_Mensaje);
                                  END;'
, number_of_arguments=>0,
start_date=>NULL, repeat_interval=> 
'FREQ=DAILY;BYHOUR=00;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que ejecuta los proceso para promociones de Ancho de Banda de cliente Nuevos y Existentes'
);
sys.dbms_scheduler.set_attribute('"JOB_PROMOCIONES_BW"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
COMMIT; 
END; 
/ 