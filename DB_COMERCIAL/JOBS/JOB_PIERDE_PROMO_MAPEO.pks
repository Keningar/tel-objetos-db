BEGIN 
dbms_scheduler.create_job('"JOB_PIERDE_PROMO_MAPEO"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                      CURSOR C_DiaFacturacion(Cv_CodigoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
                                      IS
                                        SELECT COUNT(FE_INICIO) AS VALOR
                                        FROM DB_FINANCIERO.ADMI_CICLO
                                        WHERE EMPRESA_COD                                 = Cv_CodigoEmpresa
                                        AND TO_NUMBER(TO_CHAR(FE_INICIO, ''DD''), ''99'') = TO_NUMBER(TO_CHAR(SYSDATE, ''DD''), ''99'');
                                      Lv_CodigoEmpresa  VARCHAR2(2);
                                      Lv_TipoPromo      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
                                      Lv_TipoProceso    VARCHAR2(20);
                                      Ln_DiaCiclo       NUMBER := 0;
                                    BEGIN
                                      Lv_CodigoEmpresa := ''18'';
                                      Lv_TipoPromo     := ''PROM_MENS'';
                                      Lv_TipoProceso   := ''EXISTENTE'';
                                      IF C_DiaFacturacion%ISOPEN THEN
                                        CLOSE C_DiaFacturacion;
                                      END IF;
                                      OPEN  C_DiaFacturacion(Lv_CodigoEmpresa);
                                      FETCH C_DiaFacturacion INTO Ln_DiaCiclo;
                                      CLOSE C_DiaFacturacion;
                                      IF Ln_DiaCiclo = 0 THEN
                                        DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_PIERDE(Pv_Empresa     => Lv_CodigoEmpresa,
                                                                                                   Pv_TipoPromo   => Lv_TipoPromo,
                                                                                                   Pv_TipoProceso => Lv_TipoProceso);
                                      END IF;
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.19.147573000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que se ejecuta para evaluar el cumplimiento de las reglas para las promociones mapeadas.'
);
sys.dbms_scheduler.set_attribute('"JOB_PIERDE_PROMO_MAPEO"','NLS_ENV','NLS_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_TERRITORY=''ECUADOR'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''ECUADOR'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RRRR'' NLS_DATE_LANGUAGE=''LATIN AMERICAN SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH12:MI:SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD/MM/RRRR HH24:MI'' NLS_TIME_TZ_FORMAT=''HH12:MI:SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RRRR HH24:MI'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_PIERDE_PROMO_MAPEO"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_PIERDE_PROMO_MAPEO"');
COMMIT; 
END; 
/ 