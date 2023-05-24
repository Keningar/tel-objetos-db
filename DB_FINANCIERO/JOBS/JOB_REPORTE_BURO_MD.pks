BEGIN 
dbms_scheduler.create_job('"JOB_REPORTE_BURO_MD"',
job_type=>'PLSQL_BLOCK', job_action=>
' DECLARE
			PV_HOST VARCHAR2(50);
			PV_PATHFILELOGGER VARCHAR2(1000);
			PV_NAMEFILELOGGER VARCHAR2(1000);
			PV_PREFIJOEMPRESA VARCHAR2(50);
			PV_IPSESSION VARCHAR2(100);
			PV_USUARIOSESSION VARCHAR2(100);
			PV_VALORCLIENTESBUENOS VARCHAR2(100);
			PV_VALORCLIENTESMALOS VARCHAR2(100);
			PV_DIRECTORIOUPLOAD VARCHAR2(1000);
						    PV_AMBIENTE VARCHAR2(50);
			PV_EMAILUSRSESION VARCHAR2(250);
		      BEGIN
			PV_HOST                 := ''scripts-telcos.telconet.ec'';
			PV_PATHFILELOGGER       := ''/home/scripts-telcos/md/financiero/logs/reportes-buro-credito'';
			PV_NAMEFILELOGGER       := ''reportes-buro-credito'';
			PV_PREFIJOEMPRESA       := ''MD'';
			PV_IPSESSION            := ''127.0.0.1'';
			PV_USUARIOSESSION       := ''telcos_crontab'';
			PV_VALORCLIENTESBUENOS  := ''50'';
			PV_VALORCLIENTESMALOS   := ''20'';
			PV_DIRECTORIOUPLOAD     := ''/home/telcos/web/public/uploads/reportesBuro'';
			PV_AMBIENTE             := ''CRONTAB'';
			PV_EMAILUSRSESION       := '''';
			DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.P_GEN_REPORTE_BURO(
			  PV_HOST                => PV_HOST,
			  PV_PATHFILELOGGER      => PV_PATHFILELOGGER,
			  PV_NAMEFILELOGGER      => PV_NAMEFILELOGGER,
			  PV_PREFIJOEMPRESA      => PV_PREFIJOEMPRESA,
			  PV_IPSESSION           => PV_IPSESSION,
			  PV_USUARIOSESSION      => PV_USUARIOSESSION,
			  PV_VALORCLIENTESBUENOS => PV_VALORCLIENTESBUENOS,
			  PV_VALORCLIENTESMALOS  => PV_VALORCLIENTESMALOS,
						      PV_DIRECTORIOUPLOAD    => PV_DIRECTORIOUPLOAD,
			  PV_AMBIENTE            => PV_AMBIENTE,
			  PV_EMAILUSRSESION      => PV_EMAILUSRSESION
			);
		      END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('14-SEP-2017 09.56.05.072321000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=1;BYHOUR=0;BYMINUTE=30;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para generar el reporte de buro de la empresa MD'
);
sys.dbms_scheduler.set_attribute('"JOB_REPORTE_BURO_MD"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_REPORTE_BURO_MD"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.set_attribute('"JOB_REPORTE_BURO_MD"','raise_events',511);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','dba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_FAILED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','dba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_BROKEN',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','dba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_SCH_LIM_REACHED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','dba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_CHAIN_STALLED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','dba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_OVER_MAX_DUR',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','jfmartinez@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_FAILED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','jfmartinez@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_BROKEN',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','jfmartinez@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_SCH_LIM_REACHED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','jfmartinez@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_CHAIN_STALLED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','jfmartinez@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_OVER_MAX_DUR',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','gvillalba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_FAILED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','gvillalba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_BROKEN',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','gvillalba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_SCH_LIM_REACHED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','gvillalba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_CHAIN_STALLED',NULL);
dbms_scheduler.add_job_email_notification('"JOB_REPORTE_BURO_MD"','gvillalba@telconet.ec','dba@telconet.ec','Oracle Scheduler Job Notification - %job_owner%.%job_name%.%job_subname% %event_type%',
'Job: %job_owner%.%job_name%.%job_subname%
Event: %event_type%
Date: %event_timestamp%
Log id: %log_id%
Job class: %job_class_name%
Run count: %run_count%
Failure count: %failure_count%
Retry count: %retry_count%
Error code: %error_code%
Error message:
%error_message%
'
,'JOB_OVER_MAX_DUR',NULL);
dbms_scheduler.enable('"JOB_REPORTE_BURO_MD"');
COMMIT; 
END; 
/ 