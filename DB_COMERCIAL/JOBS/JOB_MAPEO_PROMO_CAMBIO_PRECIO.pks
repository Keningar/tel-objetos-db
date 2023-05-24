BEGIN 
dbms_scheduler.create_job('"JOB_MAPEO_PROMO_CAMBIO_PRECIO"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                     Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                                     Lv_TipoPromo      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                                     Lv_TipoProceso    VARCHAR2(200);
                                    BEGIN
                                      Lv_CodigoEmpresa   := ''18'';
                                      Lv_TipoPromo       := ''PROM_MENS'';
                                      Lv_TipoProceso     := ''EXISTENTE'';
                                      DB_COMERCIAL.CMKG_PROMOCIONES.P_MAPEO_CAMBIO_PRECIO(Pv_CodigoGrupoPromocion   => Lv_TipoPromo,
                                                                                       Pv_TipoProceso            => Lv_TipoProceso ,
                                                                                       Pv_CodEmpresa             => Lv_CodigoEmpresa);
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.18.643436000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=23;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que ejecuta proceso de Mapeo de Promociones para Netlife'
);
sys.dbms_scheduler.set_attribute('"JOB_MAPEO_PROMO_CAMBIO_PRECIO"','NLS_ENV','NLS_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_TERRITORY=''ECUADOR'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''ECUADOR'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RRRR'' NLS_DATE_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH12:MI:SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD/MM/RRRR HH24:MI'' NLS_TIME_TZ_FORMAT=''HH12:MI:SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RRRR HH24:MI'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_MAPEO_PROMO_CAMBIO_PRECIO"');
COMMIT; 
END; 
/ 