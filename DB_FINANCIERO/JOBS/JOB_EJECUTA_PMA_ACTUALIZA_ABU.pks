BEGIN 
dbms_scheduler.create_job('"JOB_EJECUTA_PMA_ACTUALIZA_ABU"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
							 	Pv_UrlFile    	VARCHAR2(600);
							    Pv_EmpresaCod 	VARCHAR2(600);
							    Pv_User		 	VARCHAR2(600);
							    Pv_IpUsuario	VARCHAR2(600);
							    Pv_Status     	VARCHAR2(600);
							    Pv_Mensaje   	VARCHAR2(600);
							    Lv_MsjResultado VARCHAR2(2000);
							   CURSOR C_GetDocumentos
							    IS
							    	SELECT ipmc.ID_PROCESO_MASIVO_CAB, ipmc.ESTADO, ipmc.IDS_BANCOS_TARJETAS, 
							    		   ipmc.USR_CREACION, ipmc.IP_CREACION, ipmc.EMPRESA_ID, ipmc.IDS_OFICINAS 
									FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB ipmc
									WHERE ipmc.TIPO_PROCESO = ''ArchivoTarjetasAbu''
									AND ipmc.ESTADO  = ''Pendiente''
									AND rownum <= 1;
							
							     Lr_Documento         C_GetDocumentos%ROWTYPE;
							     
							BEGIN
							IF DB_FINANCIERO.FNCK_CONSULTS.F_GET_ESTADO_EJECUCION_JOB(''ACTUALIZACION_TC_ABU_MD'') = 0 THEN  
							
							 FOR list_documentos IN  C_GetDocumentos
								LOOP
									DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_PROCESA_ACTUALIZA_ABU(
											 list_documentos.IDS_BANCOS_TARJETAS,
											 list_documentos.ID_PROCESO_MASIVO_CAB,
							      			 list_documentos.EMPRESA_ID, 
							      			 list_documentos.USR_CREACION,
							      			 list_documentos.IP_CREACION, 
							      			 list_documentos.IDS_OFICINAS,
							      			 Pv_Status, 
							      			 Pv_Mensaje,
							      			 Lv_MsjResultado);
										IF Pv_Mensaje = ''Error'' THEN
											UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB ipmc 
 											SET ipmc.ESTADO = ''ERROR'', ipmc.FE_ULT_MOD = SYSTIMESTAMP
											WHERE ipmc.ID_PROCESO_MASIVO_CAB = list_documentos.ID_PROCESO_MASIVO_CAB;
										END IF;
								
								END LOOP; 
								END IF;
							END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('01-DEC-2022 12.14.30.000000000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MINUTELY;INTERVAL=5'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
NULL
);
sys.dbms_scheduler.set_attribute('"JOB_EJECUTA_PMA_ACTUALIZA_ABU"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_EJECUTA_PMA_ACTUALIZA_ABU"');
COMMIT; 
END; 
/ 