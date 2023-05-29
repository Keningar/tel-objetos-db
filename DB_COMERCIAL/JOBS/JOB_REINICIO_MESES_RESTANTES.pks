BEGIN 
dbms_scheduler.create_job('"JOB_REINICIO_MESES_RESTANTES"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                                 PV_PREFIJOEMPRESA DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE:= ''TN'';
                                                 PV_ESTADOSERVICIO DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE      := ''Activo'';
                                                 PV_MENSAJEERROR VARCHAR2(1000);
                                               BEGIN
                                                 DB_COMERCIAL.COMEK_TRANSACTION.P_REINICIO_MESES_RESTANTES( PV_PREFIJOEMPRESA => PV_PREFIJOEMPRESA,
                                                                                                            PV_ESTADOSERVICIO => PV_ESTADOSERVICIO,
                                                                                                            PV_MENSAJEERROR   => PV_MENSAJEERROR );
                                               END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('30-SEP-2016 10.08.10.000000000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=1;BYHOUR=0;BYMINUTE=15;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'JOB QUE REINICIA LOS MESES RESTANTES CUANDO LOS SERVICIOS TIENEN FRECUENCIA IGUAL A UNO Y NO
                                                        TIENEN FACTURADO DICHO SERVICIO'
);
sys.dbms_scheduler.set_attribute('"JOB_REINICIO_MESES_RESTANTES"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY='''' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY='''' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_REINICIO_MESES_RESTANTES"');
COMMIT; 
END; 
/ 