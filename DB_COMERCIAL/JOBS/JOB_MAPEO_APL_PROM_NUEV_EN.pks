BEGIN 
dbms_scheduler.create_job('"JOB_MAPEO_APL_PROM_NUEV_EN"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                    Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                                    Lv_TipoPromo      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                                    BEGIN
                                      Lv_CodigoEmpresa  := ''33'';
                                      Lv_TipoPromo      := ''PROM_MENS'';
                                      DB_COMERCIAl.CMKG_PROMOCIONES.P_MAPEO_APLICA_PROMO_NUEVOS(Pv_CodigoGrupoPromocion => Lv_TipoPromo,
                                                                                                Pv_CodEmpresa           => Lv_CodigoEmpresa,
                                                                                                Pv_TipoProceso          => ''NUEVO'');
                                  END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-APR-2023 02.27.05.136868000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=21;BYMINUTE=20;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que ejecuta Mapeo de Promociones para clientes Nuevos y aplica las promociones de mensualidad'
);
sys.dbms_scheduler.set_attribute('"JOB_MAPEO_APL_PROM_NUEV_EN"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY='''' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY='''' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_MAPEO_APL_PROM_NUEV_EN"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_MAPEO_APL_PROM_NUEV_EN"');
COMMIT; 
END; 
/ 
