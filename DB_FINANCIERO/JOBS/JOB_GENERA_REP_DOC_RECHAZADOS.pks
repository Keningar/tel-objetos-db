BEGIN 
dbms_scheduler.create_job('"JOB_GENERA_REP_DOC_RECHAZADOS"',
job_type=>'PLSQL_BLOCK', job_action=>
'
        DECLARE
          LV_CODEMPRESA      VARCHAR2(10)  := '''';
          LV_PREFEMPRESA     VARCHAR2(10)  := '''';
          LC_ALIASPLANTILLA  DB_FINANCIERO.FNKG_TYPES.LR_ALIASPLANTILLA := null;
        BEGIN
          LV_CODEMPRESA      := 18;
          LV_PREFEMPRESA     := ''MD'';
          LC_ALIASPLANTILLA  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(''RPT_DOC_RECHAZA'');
          DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_REPORTE_DOC_RECHAZADOS
                              (
                                LV_CODEMPRESA,
                                LV_PREFEMPRESA,
                                REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','','')
                              );                                   
        END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.19.578461000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'ENVIO AUTOMATICO DIARIO DE NC AUTOMÁTICAS,PAGOS,ANTICIPOS QUE ESTAN ENLAZADOS A FACTURAS SIN GESTIÓN'
);
sys.dbms_scheduler.set_attribute('"JOB_GENERA_REP_DOC_RECHAZADOS"','NLS_ENV','NLS_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_TERRITORY=''ECUADOR'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''ECUADOR'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RRRR'' NLS_DATE_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH12:MI:SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD/MM/RRRR HH24:MI'' NLS_TIME_TZ_FORMAT=''HH12:MI:SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RRRR HH24:MI'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_GENERA_REP_DOC_RECHAZADOS"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_GENERA_REP_DOC_RECHAZADOS"');
COMMIT; 
END; 
/ 