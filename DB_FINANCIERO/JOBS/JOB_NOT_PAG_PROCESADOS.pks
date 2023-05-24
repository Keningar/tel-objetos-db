BEGIN 
dbms_scheduler.create_job('"JOB_NOT_PAG_PROCESADOS"',
job_type=>'PLSQL_BLOCK', job_action=>
' DECLARE
                              PV_CODEMPRESA      VARCHAR2(5);
                              PV_PREFIJOEMPRESA  VARCHAR2(5);
                              PV_CODIGOPLANTILLA VARCHAR2(15);
                            BEGIN
                              PV_PREFIJOEMPRESA     := ''TN'';
                              PV_CODEMPRESA         := ''10'';
                              PV_CODIGOPLANTILLA    := ''PAG_AUT_PROC'';
                              DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_RPT_PAG_AUT_PPROCESADOS(
                                PV_CODEMPRESA         => PV_CODEMPRESA,
                                PV_PREFIJOEMPRESA     => PV_PREFIJOEMPRESA,
                                PV_CODIGOPLANTILLA    => PV_CODIGOPLANTILLA
                              );
                            END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('11-DEC-2022 10.46.54.434684000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=22;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'JOB QUE GENERA Y ENVIA REPORTE DE PAGOS AUTOMATICOS PROCESADOS.'
);
sys.dbms_scheduler.set_attribute('"JOB_NOT_PAG_PROCESADOS"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY=''�'' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY=''�'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_NOT_PAG_PROCESADOS"');
COMMIT; 
END; 
/ 
