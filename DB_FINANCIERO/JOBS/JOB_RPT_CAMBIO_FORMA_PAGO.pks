
BEGIN 
dbms_scheduler.create_job('"JOB_RPT_CAMBIO_FORMA_PAGO"',
job_type=>'PLSQL_BLOCK', job_action=>
' DECLARE
                                Lv_PrejifoEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE   := ''MD'';
                                Lv_CodigoPlantilla     DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE     := ''CAMB_FORMPAG'';
                                Lv_MensajeError        VARCHAR2(4000);
                            BEGIN
                                 DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.P_NOTIF_CAMBIO_FORMA_PAGO( Lv_PrejifoEmpresa,
                                                                                                 Lv_CodigoPlantilla,Lv_MensajeError);
                            END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.18.460145000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=23;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que se ejecuta para enviar reporte de cambios de forma de pago.'
);
sys.dbms_scheduler.set_attribute('"JOB_RPT_CAMBIO_FORMA_PAGO"','NLS_ENV','NLS_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_TERRITORY=''ECUADOR'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''ECUADOR'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RRRR'' NLS_DATE_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH12:MI:SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD/MM/RRRR HH12:MI:SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH12:MI:SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RRRR HH12:MI:SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_RPT_CAMBIO_FORMA_PAGO"');
COMMIT; 
END; 
/ 
