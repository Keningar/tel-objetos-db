BEGIN 
dbms_scheduler.create_job('"JOB_MAP_APL_PROM_NUEVOS_ALCANC"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                    Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                                    Lv_TipoPromo      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                                    BEGIN
                                    
                                      Lv_CodigoEmpresa := ''18'';
                                      Lv_TipoPromo     := ''PROM_MENS'';
                                      DB_COMERCIAl.CMKG_PROMOCIONES.P_MAPEO_APLICA_PROMO_NUEVOS(Pv_CodigoGrupoPromocion => Lv_TipoPromo,
                                                                                                Pv_CodEmpresa           => Lv_CodigoEmpresa,
                                                                                                Pv_TipoProceso          => ''NUEVO'',
                                                                                                Pv_Alcance              => ''ALCANCE'');
                                  END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-APR-2023 04.03.00.808194000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=23;BYMINUTE=20;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que ejecuta Mapeo de Promociones para clientes Nuevos y aplica las promociones de mensualidad'
);
sys.dbms_scheduler.set_attribute('"JOB_MAP_APL_PROM_NUEVOS_ALCANC"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_MAP_APL_PROM_NUEVOS_ALCANC"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_MAP_APL_PROM_NUEVOS_ALCANC"');
COMMIT; 
END; 
/ 