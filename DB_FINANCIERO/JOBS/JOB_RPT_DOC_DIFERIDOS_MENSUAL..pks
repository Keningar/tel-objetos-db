BEGIN 
dbms_scheduler.create_job('"JOB_RPT_DOC_DIFERIDOS_MENSUAL"',
job_type=>'PLSQL_BLOCK', job_action=>
'
    DECLARE
      
      LV_FECHADESDE     VARCHAR2(100) :='''';
      LV_FECHAHASTA     VARCHAR2(100) :='''';
      LV_CODEMPRESA     NUMBER        :='''';
      LV_PREFEMPRESA    VARCHAR2(100) :='''';
      LV_USUARIO        VARCHAR2(100) :='''';
      LC_ALIASPLANTILLA DB_FINANCIERO.FNKG_TYPES.LR_ALIASPLANTILLA:=null;
      LV_TIPDOC         VARCHAR2(100) :='''';
      
    BEGIN
      
      LV_FECHADESDE     := TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE,-1),''MM''),''DD/MM/YYYY'');
      LV_FECHAHASTA     := TO_CHAR(TRUNC(SYSDATE,''MM''),''DD/MM/YYYY'');
      LV_CODEMPRESA     := 18;
      LV_PREFEMPRESA    := ''MD'';
      LV_USUARIO        := ''JOB_MENSUAL'';
      LC_ALIASPLANTILLA := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(''RPT_DIFERIDOS'');
      LV_TIPDOC         := ''PAG'';
      
      DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.P_REPORTE_NCI_DIFERIDOS
                          (
                              LV_FECHADESDE,
                              LV_FECHAHASTA,
                              LV_CODEMPRESA,
                              LV_USUARIO,
                              LV_PREFEMPRESA,
                              REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','','')
                          );
      DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.P_REPORTE_NDI_DIFERIDOS
                          (
                            LV_FECHADESDE,
                            LV_FECHAHASTA,
                            LV_CODEMPRESA,
                            LV_USUARIO,
                            LV_PREFEMPRESA,
                            REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','','')
                          );   
      DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.P_REPORTE_NDI_PAG_DIFERIDOS
                          (
                            LV_FECHADESDE,
                            LV_FECHAHASTA,
                            LV_CODEMPRESA,
                            LV_USUARIO,
                            LV_PREFEMPRESA,
                            REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','','')
                          );  
      DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.P_GUARDA_EJECUCION_JOB(LV_PREFEMPRESA,
                                                                  LV_TIPDOC,
                                                                  REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','',''),
                                                                  LV_USUARIO,
                                                                  ''Ejecuci�n reporte de documentos NCI y NDI diferidos'',
                                                                  ''DB_FINANCIERO'' );                                                               
    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('11-DEC-2022 10.46.55.923145000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=1;BYHOUR=12;BYMINUTE=30;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'ENVIO AUTOMATICO MENSUAL DE REPORTES DE DOCUMENTOS NCI Y NDI DIFERIDOS'
);
sys.dbms_scheduler.set_attribute('"JOB_RPT_DOC_DIFERIDOS_MENSUAL"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_RPT_DOC_DIFERIDOS_MENSUAL"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_RPT_DOC_DIFERIDOS_MENSUAL"');
COMMIT; 
END; 
/ 