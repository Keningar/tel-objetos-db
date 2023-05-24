BEGIN 
dbms_scheduler.create_job('"FACTURACIONMASIVATN"',
job_type=>'PLSQL_BLOCK', job_action=>
'/* Formatted on 01/07/2016 3:41:47 (QP5 v5.163.1008.3004) */
                  DECLARE
                 --Antes 0 H 15 Min
                 PV_PREFIJOEMPRESA DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE    := ''TN'';
                 PV_ESTADOSERVICIO DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE          := ''Activo'';
                 PN_IDSERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE         := NULL;
                 PN_MESESRESTANTES DB_COMERCIAL.INFO_SERVICIO.MESES_RESTANTES%TYPE := 1;
                 PV_LLAMADOPROCEDURE VARCHAR2(4)                                   := ''JOB'';
                 PV_FECHAREINICIOCONTEO VARCHAR2(11);
                 PV_MENSAJEERROR VARCHAR2(4000);
                 PN_EMPRESACOD VARCHAR2(2);
                 PV_ESPREPAGO VARCHAR2(1);                 
                 BEGIN
                 PN_EMPRESACOD := ''10'';
                 PV_ESPREPAGO := ''S'';
                 DB_COMERCIAL.COMEK_TRANSACTION.COMEP_CONTEO_FRECUENCIAS(
                                                  PV_PREFIJOEMPRESA      => PV_PREFIJOEMPRESA,
                                                  PV_ESTADOSERVICIO      => PV_ESTADOSERVICIO,
                                                  PN_IDSERVICIO          => PN_IDSERVICIO,
                                                  PN_MESESRESTANTES      => PN_MESESRESTANTES,
                                                  PV_LLAMADOPROCEDURE    => PV_LLAMADOPROCEDURE,
                                                  PV_FECHAREINICIOCONTEO => PV_FECHAREINICIOCONTEO,
                                                  PV_MENSAJEERROR        => PV_MENSAJEERROR
                                                ); 
                 FNCK_FACTURACION_MENSUAL_TN.P_FACTURACION_MENSUAL(
                                                                   PN_EMPRESACOD => PN_EMPRESACOD,
                                                                   PV_ESPREPAGO => PV_ESPREPAGO
                                                                  );
                 --rollback;
                 END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('01-SEP-2016 12.00.06.000000000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=MONTHLY;BYMONTHDAY=1;BYHOUR=0;BYMINUTE=15;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para ejecutar la facturacion mensual TELCONET'
);
sys.dbms_scheduler.set_attribute('"FACTURACIONMASIVATN"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"FACTURACIONMASIVATN"');
COMMIT; 
END; 
/ 