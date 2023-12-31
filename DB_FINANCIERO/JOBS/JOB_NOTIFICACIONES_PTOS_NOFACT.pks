BEGIN 
dbms_scheduler.create_job('"JOB_NOTIFICACIONES_PTOS_NOFACT"',
job_type=>'PLSQL_BLOCK', job_action=>
' DECLARE
                                Lv_PrejifoEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE   := ''TN'';
                                Lv_CodigoPlantilla     DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE     := ''PTOS_NOFACT'';
                                Lv_MensajeError        VARCHAR2(4000);
                            BEGIN
                                 DB_FINANCIERO.FNKG_NOTIFICACIONES.P_NOTIF_PTOS_NOFACTURADOS( Lv_PrejifoEmpresa,Lv_CodigoPlantilla,Lv_MensajeError);
                            END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('11-DEC-2022 10.46.54.147915000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=6;BYHOUR=0;BYMINUTE=30;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'JOB QUE NOTIFICA LOS PUNTOS NO FACTURADOS'
);
sys.dbms_scheduler.set_attribute('"JOB_NOTIFICACIONES_PTOS_NOFACT"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_NOTIFICACIONES_PTOS_NOFACT"');
COMMIT; 
END; 
/ 