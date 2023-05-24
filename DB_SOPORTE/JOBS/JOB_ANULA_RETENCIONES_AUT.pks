BEGIN 
dbms_scheduler.create_job('"JOB_ANULA_RETENCIONES_AUT"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                               Lv_EmpresaCod            DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.EMPRESA_COD%TYPE  := ''10'';
                               Lv_MensajeError          VARCHAR2(4000);
                           BEGIN
                               DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_ANULA_RETENCIONES_AUT(
                               PV_EMPRESACOD      => Lv_EmpresaCod
                              );
                           END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('11-DEC-2022 10.46.52.775542000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=30;BYHOUR=21;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que anula retenciones automaticas"'
);
sys.dbms_scheduler.set_attribute('"JOB_ANULA_RETENCIONES_AUT"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''dd/mm/yyyy'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''dd/mm/yyyy'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''dd/mm/yyyy'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_ANULA_RETENCIONES_AUT"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_ANULA_RETENCIONES_AUT"');
COMMIT; 
END; 
/ 
