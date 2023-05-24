
BEGIN 
dbms_scheduler.create_job('"JOB_EJECUTA_SOL_DIFERIDO"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                    Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                                    Lv_UsrCreacion    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE;
                                    BEGIN
                                      Lv_CodigoEmpresa := ''18'';
                                      Lv_UsrCreacion   := ''telcos_diferido'';
                                      DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.P_OBTIENE_GRUPOS_PROC_DIFERIDO( Pv_Empresa     => Lv_CodigoEmpresa,
                                                                                                         Pv_UsrCreacion => Lv_UsrCreacion);
                                  END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('11-DEC-2022 10.46.53.384161000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=20;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que ejecuta las solicitudes de diferidos de facturas por emergencia sanitaria.'
);
sys.dbms_scheduler.set_attribute('"JOB_EJECUTA_SOL_DIFERIDO"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_EJECUTA_SOL_DIFERIDO"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_EJECUTA_SOL_DIFERIDO"');
COMMIT; 
END; 
/ 