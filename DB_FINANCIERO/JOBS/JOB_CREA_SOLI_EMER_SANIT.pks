BEGIN 
dbms_scheduler.create_job('"JOB_CREA_SOLI_EMER_SANIT"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
                                      Lv_CodigoEmpresa      VARCHAR2(2);
                                      Lv_Estado             VARCHAR2(3200);
                                      Lv_SolicitudNci       VARCHAR2(3200);
                                      Ln_IdPunto            DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
                                      Lv_MsjResultado       VARCHAR2(4000);
                                      Ln_IdProcesoMasivoCab NUMBER;
                                    BEGIN
                                      Lv_CodigoEmpresa  := ''18'';
                                      Lv_SolicitudNci   := ''EjecutarEmerSanit'';
                                      Lv_Estado         := ''Pendiente'';
                                      Ln_IdPunto        := NULL;
                                      DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI(Pv_TipoPma            => Lv_SolicitudNci,
                                                                                                Pv_CodEmpresa         => Lv_CodigoEmpresa,
                                                                                                Pv_Estado             => Lv_Estado,
                                                                                                Pn_IdPunto            => Ln_IdPunto,
                                                                                                Pv_MsjResultado       => Lv_MsjResultado,
                                                                                                Pn_IdProcesoMasivoCab => Ln_IdProcesoMasivoCab);
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-MAY-2023 02.04.26.814680000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY;INTERVAL=5'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso que ejecuta los procesos masivos para la creación de solicitues por NCI de diferidos por emergencia 
sanitaria.'
);
sys.dbms_scheduler.set_attribute('"JOB_CREA_SOLI_EMER_SANIT"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_CREA_SOLI_EMER_SANIT"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_CREA_SOLI_EMER_SANIT"');
COMMIT; 
END; 
/ 