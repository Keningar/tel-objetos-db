
BEGIN 
dbms_scheduler.create_job('"JOB_NUMERAR_FACT_INSTALACION"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                PV_PREFIJOEMPRESA DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE                                 := ''TN'';
                PV_FEEMISION VARCHAR2(11)                                                                      := TO_CHAR(SYSDATE, ''DD-MM-YYYY'');
                PV_CODIGOTIPODOCUMENTO DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := ''FAC'';
                PV_USRCREACION DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE                   := ''telcos_instalacion'';
                PV_ESTADOIMPRESIONFACT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE  := ''Pendiente'';
                PV_ESELECTRONICA DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_ELECTRONICA%TYPE               := ''S'';
                PN_IDDOCUMENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE                   := NULL;
                PV_MSNERROR VARCHAR2(4000)                                                                     := '''';
              BEGIN
                DB_FINANCIERO.FNCK_FACTURACION_MENSUAL_TN.P_NUMERAR_LOTE_POR_OFICINA( PV_PREFIJOEMPRESA       => PV_PREFIJOEMPRESA, 
                                                                                      PV_FEEMISION            => PV_FEEMISION, 
                                                                                      PV_CODIGOTIPODOCUMENTO  => PV_CODIGOTIPODOCUMENTO, 
                                                                                      PV_USRCREACION          => PV_USRCREACION, 
                                                                                      PV_ESTADOIMPRESIONFACT  => PV_ESTADOIMPRESIONFACT, 
                                                                                      PV_ESELECTRONICA        => PV_ESELECTRONICA, 
                                                                                      PN_IDDOCUMENTO          => PN_IDDOCUMENTO, 
                                                                                      PV_MSNERROR             => PV_MSNERROR );
              END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('08-AUG-2016 03.13.12.000000000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20;BYHOUR=23;BYMINUTE=30;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'JOB QUE NUMERA LAS FACTURAS DE INSTALACION  DE TN LUEGO QUE SE HAN GENERADO POR EL SCRIPT DE INSTALACION'
);
sys.dbms_scheduler.set_attribute('"JOB_NUMERAR_FACT_INSTALACION"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY='''' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY='''' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_NUMERAR_FACT_INSTALACION"');
COMMIT; 
END; 
/ 
