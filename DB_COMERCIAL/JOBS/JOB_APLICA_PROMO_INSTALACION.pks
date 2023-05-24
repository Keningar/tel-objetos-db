BEGIN 
dbms_scheduler.create_job('"JOB_APLICA_PROMO_INSTALACION"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
            
                       Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                       Lv_TipoPromo      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                       Ln_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL;
                       Lv_MsjResultado   VARCHAR2(4000);
                                    
                     BEGIN
                                    
                       Lv_CodigoEmpresa := ''18'';
                       Lv_TipoPromo     := ''PROM_INS'';
                       Ln_IdServicio    := NULL;
                       DB_COMERCIAL.CMKG_PROMOCIONES.P_PIERDE_PROMO_MAPEO(Pv_Empresa   => Lv_CodigoEmpresa,
                                                                          Pv_TipoPromo => Lv_TipoPromo,
                                                                          Pv_TipoProceso => ''INSTALACION'');                                      
                       DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   => Lv_CodigoEmpresa,
                                                                        Pv_TipoPromo    => Lv_TipoPromo,
                                                                        Pn_IdServicio   => Ln_IdServicio,
                                                                        Pv_MsjResultado => Lv_MsjResultado);
                       IF TRIM(Lv_MsjResultado) IS NOT NULL and Lv_MsjResultado!=''OK'' THEN
                         ROLLBACK;
                       ELSE
                         COMMIT;
                       END IF;
                       DB_FINANCIERO.FNCK_TRANSACTION.P_FACTURACION_SOLICITUDES(''N''); 
                     END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-APR-2023 04.03.00.326458000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=22;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para aplicar promociones para Instalaciones.'
);
sys.dbms_scheduler.set_attribute('"JOB_APLICA_PROMO_INSTALACION"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_APLICA_PROMO_INSTALACION"');
COMMIT; 
END; 
/ 