BEGIN 
dbms_scheduler.create_job('"JOB_P_CALCULO_COMISION_MANTENI"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                                 PV_PREFIJOEMPRESA DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE:= ''TN'';
                                                 PV_ESTADOSERVICIO DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE      := ''Activo'';
                                                 PV_MENSAJEERROR VARCHAR2(1000);
                                                 PN_CONTADORCOMMIT NUMBER := 500;
                                               BEGIN
                                                 DB_COMERCIAL.COMEK_TRANSACTION.P_CALCULO_COMISION_MANTENIMI( PV_PREFIJOEMPRESA => PV_PREFIJOEMPRESA,
                                                                                                              PV_ESTADOSERVICIO => PV_ESTADOSERVICIO,
                                                                                                              PN_CONTADORCOMMIT => PN_CONTADORCOMMIT,
                                                                                                              PV_MENSAJEERROR   => PV_MENSAJEERROR );
                                               END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('30-MAY-2017 11.09.20.000000000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=1,21;BYHOUR=23;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que calcula la comision en mantenimiento en Plantillas de Comisionistas en servicios Activos con fecha de                                                          activacion mayor a 12 meses'
);
sys.dbms_scheduler.set_attribute('"JOB_P_CALCULO_COMISION_MANTENI"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_P_CALCULO_COMISION_MANTENI"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_P_CALCULO_COMISION_MANTENI"');
COMMIT; 
END; 
/ 