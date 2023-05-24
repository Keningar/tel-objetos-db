BEGIN 
dbms_scheduler.create_job('"JOB_PROCESA_RECALCULO_EN"',
job_type=>'PLSQL_BLOCK', job_action=>
'
        DECLARE
          
          LV_CODEMPRESA          VARCHAR2(10)  := '''';
          LV_PREFEMPRESA         VARCHAR2(10)  := '''';
          LV_USUARIO             VARCHAR2(100) := '''';
          LV_APLICARECALCULO     VARCHAR2(10) := '''';
          LC_ALIASPLANTILLA      DB_FINANCIERO.FNKG_TYPES.LR_ALIASPLANTILLA := NULL;
          LN_IDSERVICIO          NUMBER := NULL;
          LV_TIPOPROCESO         VARCHAR2(100) := '''';
          LV_MENSAJE             VARCHAR2(100) := '''';
          LV_ERROR               VARCHAR2(100) := '''';
        BEGIN
          
          LV_CODEMPRESA      := ''33'';
          LV_PREFEMPRESA     := ''EN'';
          LV_USUARIO         := ''telcos_recalculo'';
          LC_ALIASPLANTILLA  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(''RPT_RECALCULO'');
          LV_TIPOPROCESO     := ''MASIVO'';
          
          DB_COMERCIAL.CMKG_BENEFICIOS.P_APLICA_RECALCULO
                              (
                                LV_CODEMPRESA,
                                LV_APLICARECALCULO
                              );
                              
          IF LV_APLICARECALCULO = ''S'' THEN                    
              DB_COMERCIAL.CMKG_BENEFICIOS.P_RECALCULO
                                  (
                                    LV_CODEMPRESA,
                                    LV_PREFEMPRESA,
                                    LV_USUARIO,
                                    REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','',''),
                                    LN_IDSERVICIO,
                                    LV_TIPOPROCESO,
                                    LV_MENSAJE,
                                    LV_ERROR
                                  ); 
          END IF;                  
        END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('01-APR-2023 11.27.16.446636000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=23;BYMINUTE=15;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'VERIFICA A DIARIO SI EXISTE UN CAMBIO DE PARAMETROS MODIFICADOS ESPECIFICOS POR ADULTO MAYOR PARA EJECUTAR PROCESO DE REC�LCULO EN'
);
sys.dbms_scheduler.set_attribute('"JOB_PROCESA_RECALCULO_EN"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY=''�'' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY=''�'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_PROCESA_RECALCULO_EN"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_PROCESA_RECALCULO_EN"');
COMMIT; 
END; 
/ 