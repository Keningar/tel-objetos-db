BEGIN 
dbms_scheduler.create_job('"JOB_CUENTAS_CONTABLES"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
  PN_TIPOCUENTACONTABLEID ADMI_CUENTA_CONTABLE.TIPO_CUENTA_CONTABLE_ID%TYPE;
  PN_EMPRESACOD           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
  PV_CUENTA               VARCHAR2(200);
  PV_DESCRIPCION          VARCHAR2(200);
BEGIN
  --Cuentas contables Facturas
  PN_TIPOCUENTACONTABLEID := 7;
  PN_EMPRESACOD           := ''10'';
  PV_CUENTA               := ''4210101'';
  PV_DESCRIPCION          := ''PRODUCTO'';
  DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_CTA_CONTABLE( PN_TIPOCUENTACONTABLEID,
                                                                   PN_EMPRESACOD,
                                                                   PV_CUENTA,
                                                                   PV_DESCRIPCION );
  --
  --Cuentas contables NC
  PN_TIPOCUENTACONTABLEID := 36;
  PN_EMPRESACOD           := ''10'';
  PV_CUENTA               := ''4210102'';
  PV_DESCRIPCION          := ''PRODUCTOS_NC'';
  DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_CTA_CONTABLE( PN_TIPOCUENTACONTABLEID,
                                                                   PN_EMPRESACOD,
                                                                   PV_CUENTA,
                                                                   PV_DESCRIPCION );
END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('06-JAN-2017 04.55.18.194174000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=0;BYMINUTE=10;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para la creacion de cuentas contables faltantes por nuevos productos'
);
sys.dbms_scheduler.set_attribute('"JOB_CUENTAS_CONTABLES"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_CUENTAS_CONTABLES"');
COMMIT; 
END; 
/ 