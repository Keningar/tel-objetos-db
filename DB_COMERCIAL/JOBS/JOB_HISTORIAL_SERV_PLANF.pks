BEGIN 
dbms_scheduler.create_job('"JOB_HISTORIAL_SERV_PLANF"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                PV_CODEMPRESA VARCHAR2(200);
                                PV_TIPO VARCHAR2(200);
                                PV_ESTADO VARCHAR2(200);
                                PV_STATUS VARCHAR2(200);
                                PV_MENSAJE VARCHAR2(200);
                              BEGIN
                                PV_CODEMPRESA := ''18'';
                                PV_TIPO := ''SOLICITUD PLANIFICACION'';
                                PV_ESTADO := ''PrePlanificada'';
                              
                                CMKG_HISTORIAL_SERV_PLANF.P_INSERTA_HISTORIAL(
                                  PV_CODEMPRESA => PV_CODEMPRESA,
                                  PV_TIPO => PV_TIPO,
                                  PV_ESTADO => PV_ESTADO,
                                  PV_STATUS => PV_STATUS,
                                  PV_MENSAJE => PV_MENSAJE
                                );
                                END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('11-DEC-2022 10.46.57.349993000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY;INTERVAL=5'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Los productos Netlife Assistance Pro y NetlifeCloud en estado Pendiente se activan y se registra en el historial del servicio'
);
sys.dbms_scheduler.set_attribute('"JOB_HISTORIAL_SERV_PLANF"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY=''�'' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY=''�'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_HISTORIAL_SERV_PLANF"');
COMMIT; 
END; 
/ 