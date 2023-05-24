
BEGIN 
dbms_scheduler.create_job('"JOB_FACTURACION_CLOUD_TN"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                            PN_EMPRESACOD      VARCHAR2(2);
                            PV_NOMBRE_PRODUCTO VARCHAR2(300);
                            PV_MENSAJE         VARCHAR2(1000);
                          BEGIN
                            PN_EMPRESACOD := ''10'';
                            PV_NOMBRE_PRODUCTO := ''COU LINEAS TELEFONIA FIJA'';
                            --
                            DB_COMERCIAL.COMEK_TRANSACTION.P_CONSUMO_WS_NETVOICE( PN_EMPRESACOD, PV_MENSAJE );
                            commit;
                            DB_FINANCIERO.FNCK_FACTURACION_CLOUD_TN.P_FACTURACION_CLOUD( PV_NOMBRE_PRODUCTO, PN_EMPRESACOD );
                            commit;    
                            PV_NOMBRE_PRODUCTO := null;
                            PV_NOMBRE_PRODUCTO := ''CLOUD IAAS PUBLIC'';
                            --
                            DB_FINANCIERO.FNCK_FACTURACION_CLOUD_TN.P_FACTURACION_CLOUD( PV_NOMBRE_PRODUCTO, PN_EMPRESACOD );
                            commit;    
                          END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('11-DEC-2022 10.46.53.631340000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=3;BYHOUR=0;BYMINUTE=30;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para ejecutar la facturacion de servicios  cloud form para clientes de TN'
);
sys.dbms_scheduler.set_attribute('"JOB_FACTURACION_CLOUD_TN"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_FACTURACION_CLOUD_TN"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_FACTURACION_CLOUD_TN"');
COMMIT; 
END; 
/ 
