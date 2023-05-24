
BEGIN 
dbms_scheduler.create_job('"JOB_GENERA_REPORTE_REUB_EN"',
job_type=>'PLSQL_BLOCK', job_action=>
'
        DECLARE
          
          LV_FECHA           VARCHAR2(50)  := '''';
          LV_CODEMPRESA      VARCHAR2(10)  := '''';
          LV_PREFEMPRESA     VARCHAR2(10)  := '''';
          LV_USUARIO         VARCHAR2(100) := '''';
          LC_ALIASPLANTILLA  DB_FINANCIERO.FNKG_TYPES.LR_ALIASPLANTILLA := null;
        BEGIN
          
          LV_FECHA           := SYSDATE-1;
          LV_CODEMPRESA      := 33;
          LV_PREFEMPRESA     := ''EN'';
          LV_USUARIO         := ''telcos_reubica'';
          LC_ALIASPLANTILLA  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(''RPT_REUBICACION'');
    
          DB_FINANCIERO.FNCK_TRANSACTION.P_REPORTE_REUBICACION
                              (
                                LV_FECHA,
                                LV_CODEMPRESA,
                                LV_PREFEMPRESA,
                                LV_USUARIO,
                                REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','','')
                              );
    
          DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.P_GUARDA_EJECUCION_JOB(LV_PREFEMPRESA,
                                                                      '''',
                                                                      REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','',''),
                                                                      LV_USUARIO,
                                                                      ''Ejecuci�n reporte de Fact y Nc emitidas por reubicaci�n'',
                                                                      ''DB_FINANCIERO'' );                                    
    
        END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-APR-2023 03.57.31.160828000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'ENVIO AUTOMATICO DIARIO DE REPORTE DE FACTURA Y NC EMITIDAS POR REUBICACION EN'
);
sys.dbms_scheduler.set_attribute('"JOB_GENERA_REPORTE_REUB_EN"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY=''�'' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY=''�'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_GENERA_REPORTE_REUB_EN"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_GENERA_REPORTE_REUB_EN"');
COMMIT; 
END; 
/ 
