BEGIN 
dbms_scheduler.create_job('"JOB_PIERDE_PROMO_MAPEO_NUEVOS"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                      Lv_CodigoEmpresa  VARCHAR2(2);
                                      Lv_TipoPromo      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                                      Lv_TipoProceso  VARCHAR2(20);
                                    BEGIN
                                      Lv_CodigoEmpresa := ''18'';
                                      Lv_TipoPromo     := ''PROM_MENS'';
                                      Lv_TipoProceso   := ''NUEVO'';
                                      DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_PIERDE(Lv_CodigoEmpresa,
                                                                                                 Lv_TipoPromo,
                                                                                                 Lv_TipoProceso);
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-APR-2023 04.03.00.518592000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=22;BYMINUTE=15;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que se ejecuta para evaluar el cumplimiento de las reglas para las promociones mapeadas.'
);
sys.dbms_scheduler.set_attribute('"JOB_PIERDE_PROMO_MAPEO_NUEVOS"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_PIERDE_PROMO_MAPEO_NUEVOS"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_PIERDE_PROMO_MAPEO_NUEVOS"');
COMMIT; 
END; 
/ 