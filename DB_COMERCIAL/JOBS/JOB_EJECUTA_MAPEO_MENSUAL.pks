BEGIN 
dbms_scheduler.create_job('"JOB_EJECUTA_MAPEO_MENSUAL"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                      Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                                      Lv_TipoPromocion  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                                      Ln_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
                                      Lv_MsjResultado   VARCHAR2(4000);
                                    BEGIN
                                      Lv_CodigoEmpresa := ''18'';
                                      Lv_TipoPromocion := ''PROM_MENS'';
                                      Ln_IdServicio    := NULL;
                                      DB_COMERCIAL.CMKG_PROMOCIONES.P_EJECUTA_MAPEO_MENSUAL(Pv_Empresa   => Lv_CodigoEmpresa, 
                                                                                            Pv_TipoPromo => Lv_TipoPromocion);
                                      DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_PIERDE(Pv_Empresa   => Lv_CodigoEmpresa,
                                                                                                 Pv_TipoPromo => Lv_TipoPromocion,
                                                                                                 Pv_TipoProceso  => ''EXISTENTE'');
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-APR-2023 04.03.00.386085000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=22;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"JCLASS_365"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que se ejecuta para el mapeo mensual de promociones Definidas (Clientes Existentes) e Indefinidas (Clientes Existentes y Nuevos).'
);
sys.dbms_scheduler.set_attribute('"JOB_EJECUTA_MAPEO_MENSUAL"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_EJECUTA_MAPEO_MENSUAL"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_EJECUTA_MAPEO_MENSUAL"');
COMMIT; 
END; 
/ 