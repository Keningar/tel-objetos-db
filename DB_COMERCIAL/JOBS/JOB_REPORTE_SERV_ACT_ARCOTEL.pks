BEGIN 
dbms_scheduler.create_job('"JOB_REPORTE_SERV_ACT_ARCOTEL"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                        Lv_Prefijo_Empresa VARCHAR2(2) := ''TN'';
                        Lv_Mensaje_Error   VARCHAR2(4000);
                      BEGIN
                        DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.P_REPORTE_ARCOTEL_SERV_ACT(pv_prefijo_empresa => Lv_Prefijo_Empresa,
                                                                                       pv_mensaje_error   => Lv_Mensaje_Error);
                      END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('09-APR-2017 04.41.39.731978000 PM -05:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=1;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'JOB QUE MENSUALEMTE GENERA UN REPORTE DE SERVICIOS ACTIVOS PARA ARCOTEL'
);
sys.dbms_scheduler.set_attribute('"JOB_REPORTE_SERV_ACT_ARCOTEL"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_REPORTE_SERV_ACT_ARCOTEL"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_REPORTE_SERV_ACT_ARCOTEL"');
COMMIT; 
END; 
/ 