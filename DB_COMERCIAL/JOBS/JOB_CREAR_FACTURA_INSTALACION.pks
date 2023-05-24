BEGIN 
dbms_scheduler.create_job('"JOB_CREAR_FACTURA_INSTALACION"',
job_type=>'PLSQL_BLOCK', job_action=>
' DECLARE
                              Lv_CodigoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                              Lv_MsjResultado   VARCHAR2(4000);
                            BEGIN  
                               Lv_CodigoEmpresa := ''18'';
                               IF DB_FINANCIERO.FNCK_CONSULTS.F_GET_EJECUCION_COMPROBANTES (''PROCESOS_FACTURACION_INSTALACION'') = 1 THEN
                                 DB_COMERCIAL.COMEK_TRANSACTION.P_FACT_INSTALACION_X_PARAMETRO(Lv_CodigoEmpresa);
                                 DB_COMERCIAL.COMEK_TRANSACTION.P_OBTIENE_PUNTOS_ADICIONALES(Lv_CodigoEmpresa,Lv_MsjResultado);
                               END IF; 
                            END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('07-AUG-2016 09.06.05.000000000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY;INTERVAL=2'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'JOB QUE CREA LAS FACTURAS DE INSTALACION DE LOS CONTRATOS EN ESTADO PENDIENTE'
);
sys.dbms_scheduler.set_attribute('"JOB_CREAR_FACTURA_INSTALACION"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_CREAR_FACTURA_INSTALACION"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_CREAR_FACTURA_INSTALACION"');
COMMIT; 
END; 
/ 