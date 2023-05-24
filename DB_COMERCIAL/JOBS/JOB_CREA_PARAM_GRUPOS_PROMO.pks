BEGIN 
dbms_scheduler.create_job('"JOB_CREA_PARAM_GRUPOS_PROMO"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
            
                                    Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;                                   
                                    
                                    BEGIN
                                    
                                      Lv_CodigoEmpresa := ''18'';                                     
                                  
                                      DB_COMERCIAL.CMKG_CICLOS_FACTURACION.P_CREA_PARAM_GRUPOS_PROMO(Pv_CodEmpresa   => Lv_CodigoEmpresa );
                                                                                       
                                  END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.18.337745000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=23;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que permite parametrizar los grupos de clientes a procesarse en el mapeo promocional por banco_tipo_cuenta_id y por ciclo de Facturacion'
);
sys.dbms_scheduler.set_attribute('"JOB_CREA_PARAM_GRUPOS_PROMO"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_CREA_PARAM_GRUPOS_PROMO"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_CREA_PARAM_GRUPOS_PROMO"');
COMMIT; 
END; 
/ 