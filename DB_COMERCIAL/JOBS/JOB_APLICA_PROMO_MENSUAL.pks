BEGIN 
dbms_scheduler.create_job('"JOB_APLICA_PROMO_MENSUAL"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                    Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                                    Lv_TipoPromo      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                                    Ln_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL;
                                    Lv_MsjResultado   VARCHAR2(4000);
                                    Lv_JobProceso     VARCHAR2 (200);
                                    BEGIN
                                      Lv_CodigoEmpresa := ''18'';
                                      Lv_TipoPromo     := ''PROM_MENS'';
                                      Ln_IdServicio    := NULL;
                                      Lv_JobProceso    := ''JobDiario'';
                                      DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   => Lv_CodigoEmpresa,
                                                                                       Pv_TipoPromo    => Lv_TipoPromo,
                                                                                       Pn_IdServicio   => Ln_IdServicio,
                                                                                       Pv_TipoProceso  => ''NUEVO'',
                                                                                       Pv_JobProceso   => Lv_JobProceso,
                                                                                       Pv_MsjResultado => Lv_MsjResultado);
                                  END;'
, number_of_arguments=>0,
start_date=>NULL, repeat_interval=> 
'FREQ=DAILY;BYHOUR=23;BYMINUTE=30;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que se ejecuta para aplicar las promociones de mensualidad'
);
sys.dbms_scheduler.set_attribute('"JOB_APLICA_PROMO_MENSUAL"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_APLICA_PROMO_MENSUAL"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
COMMIT; 
END; 
/