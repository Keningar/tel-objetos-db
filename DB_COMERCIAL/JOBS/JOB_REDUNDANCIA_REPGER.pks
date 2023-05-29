BEGIN 
dbms_scheduler.create_job('"JOB_REDUNDANCIA_REPGER"',
job_type=>'PLSQL_BLOCK', job_action=>
'
			DECLARE
				/**
				  Comprueba si se generaros los reportes gerenciales correspondientes a la fecha actual.
				*/
				FUNCTION F_EXISTEN_REPORTES RETURN BOOLEAN IS
					REPORTES_ACTUALES NUMBER;
				BEGIN
					SELECT COUNT(*) INTO REPORTES_ACTUALES FROM DB_GENERAL.ADMI_PARAMETRO_DET apd
						INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB apc ON apc.ID_PARAMETRO = apd.PARAMETRO_ID
						WHERE apc.NOMBRE_PARAMETRO = ''REPORTES_GENERADOS''
							AND apd.VALOR1 = to_char(sysdate, ''DD'')   -- Dia
							AND apd.VALOR2 = to_char(sysdate, ''MM'')   -- Mes
							AND apd.VALOR3 = to_char(sysdate, ''YYYY'') -- Año
						ORDER BY apd.FE_CREACION DESC;	
					
					-- No hay problema con comprobar de esta forma porque siempre se generan ambos reportes
					RETURN REPORTES_ACTUALES > 0;
				END;
			BEGIN
				IF NOT F_EXISTEN_REPORTES() THEN
					dbms_scheduler.run_job (job_name => ''"DB_COMERCIAL"."JOB_REPGER_REPORTCOMERCIAL"'');
				END IF;
				
				-- Se suben los reportes pendientes (los que tengan estado GENERADO o ERROR_SUBIDA)
				DB_COMERCIAL.CMKG_REPORTES_GERENCIALES.P_SUBIR_REPORTES_PENDIENTES();
				-- Se notifican los reportes pendientes (los que tengan estado SUBIDO o ERROR_NOTIFICACION)
				DB_COMERCIAL.CMKG_REPORTES_GERENCIALES.P_NOTIFICAR_REP_PENDIENTES();
				
			EXCEPTION
					WHEN OTHERS THEN
						DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''DB_COMERCIAL'', 
										 ''DB_COMERCIAL.JOB_REDUNDANCIA_REPGER'',  
										 SQLCODE || '' -ERROR_STACK: ''
										 || DBMS_UTILITY.FORMAT_ERROR_STACK || '' - ERROR_BACKTRACE: '' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,  
										 NVL(SYS_CONTEXT( ''USERENV'',''HOST''), ''DB_COMERCIAL''),  
										 SYSDATE, 
										 NVL(SYS_CONTEXT(''USERENV'', ''IP_ADDRESS''), ''127.0.0.1'') );
			END;
		'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('21-JAN-2023 02.00.00.000000000 AM -05:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=21;BYHOUR=2;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Comprueba que se haya generado el reporte correspondiente a la fecha actual, si no, reintenta generarlo y subirlo.'
);
sys.dbms_scheduler.set_attribute('"JOB_REDUNDANCIA_REPGER"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY='''' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY='''' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_REDUNDANCIA_REPGER"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_REDUNDANCIA_REPGER"');
COMMIT; 
END; 
/ 
