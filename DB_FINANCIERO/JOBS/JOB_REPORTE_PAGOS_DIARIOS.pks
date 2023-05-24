BEGIN 
dbms_scheduler.create_job('"JOB_REPORTE_PAGOS_DIARIOS"',
job_type=>'PLSQL_BLOCK', job_action=>
'
DECLARE
  LV_TIPDOC                                     VARCHAR2(1000):='''';
  LV_ESTPUNTO                                   VARCHAR2(1000):='''';
  LV_ESTPAGO                                    VARCHAR2(1000):='''';
  LV_FORMPAGO                                   VARCHAR2(1000):='''';
  LV_FECCREADESD                                  VARCHAR2(50):='''';
  LV_FECCREAHAST                                  VARCHAR2(50):='''';
  LC_ALIASPLANTILLA DB_FINANCIERO.FNKG_TYPES.LR_ALIASPLANTILLA:=null;
  LV_USUARIO                                     VARCHAR2(100):='''';
  LV_PREFEMPRESA                                 VARCHAR2(100):='''';
  LV_CODEMPRESA                                         NUMBER:='''';
BEGIN
  LV_TIPDOC         := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_PARM_CONF(''TIPO_DOCUMENTO'');
  LV_ESTPUNTO       := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_PARM_CONF(''ESTADO_PUNTO'');
  LV_ESTPAGO        := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_PARM_CONF(''ESTADO_PAGO'');
  LV_FORMPAGO       := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_PARM_CONF(''FORMA_PAGO'');
  LV_FECCREADESD    := TO_CHAR(SYSDATE-1,''DD/MM/YYYY'');
  LV_FECCREAHAST    := TO_CHAR(SYSDATE,''DD/MM/YYYY'');
  LC_ALIASPLANTILLA := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_PARM_CONF(''CONF_ALIA_PLANT''));
  LV_USUARIO        := ''JOB_DIARIO'';
  LV_PREFEMPRESA    := ''MD'';
  LV_CODEMPRESA     := 18;
  DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.P_REPORTE_COBRANZAS
                      (
                          NVL(LV_TIPDOC,''PAG''),
                          NULL,
                          NULL,
                          NULL,
                          LV_ESTPAGO,
                          LV_FECCREADESD,
                          LV_FECCREAHAST,
                          LV_FORMPAGO,
                          NULL,
                          NULL,
                          LV_ESTPUNTO,
                          LV_CODEMPRESA,
                          LV_USUARIO,
                          LV_PREFEMPRESA,
                          REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','',''),
                          NULL,
                          NULL,
                          NULL,
                          NULL
                      );
  DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.P_GUARDA_EJECUCION_JOB(LV_PREFEMPRESA,
                                                               LV_TIPDOC,
                                                               REPLACE(LC_ALIASPLANTILLA.ALIAS_CORREOS,'';'','',''),
                                                               LV_USUARIO,
                                                               ''TIPO DE DOC: ''||LV_TIPDOC||
                                                               '', ESTADO DE DOC: ''||LV_ESTPAGO||
                                                               '', FORMA DE PAGO: ''||LV_FORMPAGO||
                                                               '', ESTADO DEL PUNTO: ''||LV_ESTPUNTO||
                                                               '', FECHA DESDE: ''||LV_FECCREADESD||
                                                               '', FECHA HASTA ''||LV_FECCREAHAST);
END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-AUG-2017 02.21.46.982807000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN;BYHOUR=1;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'REPORTE PARA EL ENVIO AUTOMATICO DIARIO DEL REPORTE DE PAGOS'
);
sys.dbms_scheduler.set_attribute('"JOB_REPORTE_PAGOS_DIARIOS"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_REPORTE_PAGOS_DIARIOS"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_REPORTE_PAGOS_DIARIOS"');
COMMIT; 
END; 
/ 
