BEGIN 
dbms_scheduler.create_job('"JOB_RENOVAR_LICENCIAS_OFF365"',
job_type=>'PLSQL_BLOCK', job_action=>
' DECLARE
                                                          PV_PREFIJO_EMPRESA VARCHAR2(2);
                                                          PV_EMPRESA_COD     VARCHAR2(2);
                                                          PV_USR_CREACION    VARCHAR2(25);
                                                          PV_IP              VARCHAR2(25);
                                                        BEGIN
                                                          PV_PREFIJO_EMPRESA  := ''MD'';
                                                          PV_EMPRESA_COD      := ''18'';
                                                          PV_USR_CREACION     := ''telcos_renova'';
                                                          PV_IP               := ''127.0.0.1'';
                                                          DB_COMERCIAL.CMKG_LICENCIAOFFICE365.P_RENOVAR_LICOFFICE365(
                                                            PV_PREFIJOEMPRESA => PV_PREFIJO_EMPRESA,
                                                            PV_EMPRESACOD     => PV_EMPRESA_COD,
                                                            PV_USRCREACION    => PV_USR_CREACION,
                                                            PV_IP             => PV_IP
                                                          );
                                                        END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.25.954398000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=1;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso la renovaci�n de licencias Office 365 para aquellos servicios con producto NetlifeCloud para MD'
);
sys.dbms_scheduler.set_attribute('"JOB_RENOVAR_LICENCIAS_OFF365"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_RENOVAR_LICENCIAS_OFF365"');
COMMIT; 
END; 
/ 