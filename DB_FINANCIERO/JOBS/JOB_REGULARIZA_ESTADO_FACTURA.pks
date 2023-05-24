
BEGIN 
dbms_scheduler.create_job('"JOB_REGULARIZA_ESTADO_FACTURA"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                      
                                      Lv_CodigoEmpresa           VARCHAR2(200);
                                      Lv_EstadoActivo            VARCHAR2(200);
                                      Lv_EstadoCerrado           VARCHAR2(200);
                                      CURSOR C_ObtieneEmpresa
                                      IS
                                        SELECT COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO WHERE PREFIJO IN (''TN'',''MD'');
                                    BEGIN
                                      FOR Lr_ObtieneEmpresa IN C_ObtieneEmpresa() 
                                      LOOP
                                        BEGIN
                                          Lv_CodigoEmpresa            := Lr_ObtieneEmpresa.COD_EMPRESA;
                                          Lv_EstadoActivo             :=''Activo'';
                                          Lv_EstadoCerrado            :=''Cerrado'';
                                          FNKG_REGULARIZACIONES.P_REGULARIZAR_ESTADOS_FACTURAS(Lv_CodigoEmpresa,Lv_EstadoActivo);
                                          FNKG_REGULARIZACIONES.P_REGULARIZAR_ESTADOS_FACTURAS(Lv_CodigoEmpresa,Lv_EstadoCerrado);
                                        END;
                                      END LOOP;
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.18.102139000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=22;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que se ejecuta para actualizar el estado de facturas a cerrado'
);
sys.dbms_scheduler.set_attribute('"JOB_REGULARIZA_ESTADO_FACTURA"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_REGULARIZA_ESTADO_FACTURA"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_REGULARIZA_ESTADO_FACTURA"');
COMMIT; 
END; 
/ 
