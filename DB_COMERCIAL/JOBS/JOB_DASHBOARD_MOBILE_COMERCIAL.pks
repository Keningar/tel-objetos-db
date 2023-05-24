BEGIN 
dbms_scheduler.create_job('"JOB_DASHBOARD_MOBILE_COMERCIAL"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                      PV_EMPRESA VARCHAR2(200);
                      PV_DESCRIPCION VARCHAR2(200);
                      PV_ERROR VARCHAR2(200);
                      BEGIN
                      PV_EMPRESA := ''18'';
                      PV_DESCRIPCION := NULL;
                        DB_COMERCIAL.CMKG_DASHBOARD_COMERCIAL.P_GENERA_JSON_DASHBOARD(
                          PV_EMPRESA => PV_EMPRESA,
                          PV_DESCRIPCION => PV_DESCRIPCION,
                          PV_ERROR => PV_ERROR
                        );
                      /* Legacy output:
                    DBMS_OUTPUT.PUT_LINE(''PV_ERROR = '' || PV_ERROR);
                    */
                      END;'
, number_of_arguments=>0,
start_date=>NULL, repeat_interval=> 
'FREQ=HOURLY; INTERVAL=1'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para generar data para dashboard de TM-COMERCIAL.'
);
sys.dbms_scheduler.set_attribute('"JOB_DASHBOARD_MOBILE_COMERCIAL"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
COMMIT; 
END; 
/ 