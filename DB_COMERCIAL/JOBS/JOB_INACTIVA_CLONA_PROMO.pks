BEGIN 
dbms_scheduler.create_job('"JOB_INACTIVA_CLONA_PROMO"',
job_type=>'PLSQL_BLOCK', job_action=>
'BEGIN
                                      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_EJECUTA_PM_PROMOCIONES(''InactivarPromo'',''AnulacionWeb'',''18'',''Pendiente'');
                                      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_EJECUTA_PM_PROMOCIONES(''InactPromoVigente'',''InactivacionJob'',''18'',''Pendiente'');
                                      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_EJECUTA_CLONAR_PROMOCIONES(''ClonarPromo'',''18'',''Pendiente'');
                                    END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('18-JUN-2021 01.06.50.280277000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY;INTERVAL=5'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que ejecuta procesos masivos de Inactivaci�n y clonaci�n de Promociones'
);
sys.dbms_scheduler.set_attribute('"JOB_INACTIVA_CLONA_PROMO"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY=''�'' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY=''�'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_INACTIVA_CLONA_PROMO"');
COMMIT; 
END; 
/ 