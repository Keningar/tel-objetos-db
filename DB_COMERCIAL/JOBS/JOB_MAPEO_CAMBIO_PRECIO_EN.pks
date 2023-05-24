BEGIN 
dbms_scheduler.create_job('"JOB_MAPEO_CAMBIO_PRECIO_EN"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                   
                                     Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                                     Lv_TipoPromo      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                                     Lv_TipoProceso    VARCHAR2(200);
                              
                                    BEGIN
                                       
                                      Lv_CodigoEmpresa   := ''33'';
                                      Lv_TipoPromo       := ''PROM_MENS'';
                                      Lv_TipoProceso     := ''EXISTENTE'';
                                      DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PRECIO(Pv_CodigoGrupoPromocion   => Lv_TipoPromo,
                                                                                          Pv_TipoProceso            => Lv_TipoProceso ,
                                                                                          Pv_CodEmpresa             => Lv_CodigoEmpresa);
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-APR-2023 02.27.16.100231000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=23;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que ejecuta proceso de Mapeo de Promociones para Netlife'
);
sys.dbms_scheduler.set_attribute('"JOB_MAPEO_CAMBIO_PRECIO_EN"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY=''�'' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY=''�'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_MAPEO_CAMBIO_PRECIO_EN"');
COMMIT; 
END; 
/ 