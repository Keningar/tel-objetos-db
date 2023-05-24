BEGIN 
dbms_scheduler.create_job('"CONTABILIZACION_MASIVA_NDI"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
  PV_CODEMPRESA VARCHAR2(2);
  PV_PREFIJO VARCHAR2(5);
  PV_CODIGOTIPODOCUMENTO VARCHAR2(4);
  PV_TIPOPROCESO VARCHAR2(200);
  PV_IDDOCUMENTO NUMBER;
  PV_FECHAPROCESO VARCHAR2(200);
BEGIN
  PV_CODEMPRESA := ''10'';
  PV_PREFIJO := ''TN'';
  PV_CODIGOTIPODOCUMENTO := ''NDI'';
  PV_TIPOPROCESO := ''MASIVO'';
  PV_IDDOCUMENTO := NULL;
  PV_FECHAPROCESO := NULL;
  FNKG_CONTABILIZAR_NDI.P_CONTABILIZAR(
    PV_CODEMPRESA => PV_CODEMPRESA,
    PV_PREFIJO => PV_PREFIJO,
    PV_CODIGOTIPODOCUMENTO => PV_CODIGOTIPODOCUMENTO,
    PV_TIPOPROCESO => PV_TIPOPROCESO,
    PV_IDDOCUMENTO => PV_IDDOCUMENTO,
    PV_FECHAPROCESO => PV_FECHAPROCESO
  );
--rollback;
END;
'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('04-MAY-2018 01.00.00.024445000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para generar los asientos en el NAF, que corresponde a las NDI por motivo'
);
sys.dbms_scheduler.set_attribute('"CONTABILIZACION_MASIVA_NDI"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"CONTABILIZACION_MASIVA_NDI"');
COMMIT; 
END; 
/ 