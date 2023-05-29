BEGIN 
dbms_scheduler.create_job('"JOB_INACTIVA_VIGENCIA_PROMO"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                      Lv_Observacion      VARCHAR2(500);
                                      Lv_Usuario          VARCHAR2(500);
                                      Lv_IpCreacion       VARCHAR2(500);
                                      Lv_TipoPma          VARCHAR2(500);
                                      Lv_MsjResultado     VARCHAR2(4000);
                                      Lv_IdGrupos         VARCHAR2(500);
                                      Ln_IdMotivo         DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE;
                                      Lv_CodigoEmpresa    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
                       
                                    BEGIN
                                      Lv_Observacion     := ''Inactivación automática por fechas de vigencias'';
                                      Lv_Usuario         := ''telcos'';
                                      Lv_IpCreacion      := ''172.17.0.1'';
                                      Lv_TipoPma         := ''InactivaJob'';
                                      Lv_CodigoEmpresa   := ''18'';
                                      Lv_IdGrupos        := ''N'';
                                      Ln_IdMotivo        := ''0'';
                                      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_CREA_PM_PROMOCIONES(Lv_IdGrupos,Ln_IdMotivo,Lv_Observacion,Lv_Usuario,''18'',Lv_IpCreacion,Lv_TipoPma,Lv_MsjResultado);
                                      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_EJECUTA_PM_PROMOCIONES(''InactivaJob'',''InactivacionJob'',''18'',''Pendiente'');
                                     
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.19.529473000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que ejecuta procesos masivos de Inactivación de Promociones por fecha de vigencia'
);
sys.dbms_scheduler.set_attribute('"JOB_INACTIVA_VIGENCIA_PROMO"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_INACTIVA_VIGENCIA_PROMO"');
COMMIT; 
END; 
/ 