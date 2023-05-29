BEGIN 
dbms_scheduler.create_job('"JOB_CREA_COMPROBANTE_ELECT"',
job_type=>'PLSQL_BLOCK', job_action=>
'     DECLARE
                                    Pv_MensaError VARCHAR2(500) := '''';
                                    Lv_ParametroFacturas   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := ''REPORTE_CARTERA'';
                                    Lv_ParametroNC         DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := ''DOCUMENTOS_NUM_FACTURA_SRI'';
                                    Lv_ParametroEstadosDoc DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := ''ESTADOS_DOC_NUM_FACTURA_SRI'';
                                    Lv_TipoFactura         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := ''FACTURAS'';
                                    Lv_TipoNC              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := ''NOTAS_DE_CREDITO'';
                                    Lv_CodigoNumeracionFac DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE := ''FACE'';
                                    Lv_CodigoNumeracionNC  DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE := ''NCE'';
                                    Lv_FechaEjecucion      VARCHAR2(1000);
                                BEGIN
                                    Lv_FechaEjecucion := TRIM(TO_CHAR(sysdate,''RRRR-MM-DD HH24:MI:SS''));
                                    --Se valida si es posible ejecutar el job de crea comprobantes.
                                    IF DB_FINANCIERO.FNCK_CONSULTS.F_GET_EJECUCION_COMPROBANTES (''PROCESOS_FACTURACION_MASIVA'') = 1 THEN
                                      DB_FINANCIERO.FNCK_TRANSACTION.P_REGULARIZAR_NUM_FACTURA_SRI(Lv_ParametroFacturas,
                                                                                                   Lv_ParametroEstadosDoc,
                                                                                                   Lv_TipoFactura,
                                                                                                   Lv_CodigoNumeracionFac,
                                                                                                   Pv_MensaError);
                                      DB_FINANCIERO.FNCK_TRANSACTION.P_REGULARIZAR_NUM_FACTURA_SRI(Lv_ParametroNC,
                                                                                                   Lv_ParametroEstadosDoc,
                                                                                                   Lv_TipoNC,
                                                                                                   Lv_CodigoNumeracionNC,
                                                                                                   Pv_MensaError);
                                      DB_FINANCIERO.FNCK_COM_ELECTRONICO.CREA_COMP_ELECTRONICO_MASIVO(Pv_FechaEjecucion => Lv_FechaEjecucion);
                                    END IF;
                                END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('01-SEP-2018 03.50.00.000000000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY;INTERVAL=5'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
NULL
);
sys.dbms_scheduler.set_attribute('"JOB_CREA_COMPROBANTE_ELECT"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_CREA_COMPROBANTE_ELECT"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_CREA_COMPROBANTE_ELECT"');
COMMIT; 
END; 
/ 