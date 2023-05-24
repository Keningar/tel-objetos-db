BEGIN 
dbms_scheduler.create_job('"FACTURASXDETALLEPRODUCTO"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
  Pt_Dia_Actual NUMBER(2);
  Pt_Fe_Emision_Ini VARCHAR2(100);
  Pt_Fe_Emision_Fin VARCHAR2(100);
  BEGIN
  --Obtenemos las fechas actuales
  SELECT
  to_number(TO_CHAR(sysdate,''dd'')),
  TO_CHAR(trunc(sysdate, ''mm''),''DD/MM/YYYY''),
  TO_CHAR(trunc(last_day(sysdate)),''DD/MM/YYYY'')
  INTO
  Pt_Dia_Actual,
  Pt_Fe_Emision_Ini,
  Pt_Fe_Emision_Fin
  FROM DUAL;
  --Verificacion del dia 1 del proceso del mes siguiente, para procesar las pendientes del dia anterior
  IF Pt_Dia_Actual=1 THEN
  select
  TO_CHAR(trunc(sysdate,''MM''),''DD/MM/YYYY'')
  INTO
  Pt_Fe_Emision_Ini
  from dual;
  END IF;
  --Llamada del procedure
  FNCK_FACTURACION_DETALLES.P_FACTURACION_DETALLE
  (
  ''MD'',
  Pt_Fe_Emision_Ini,
  Pt_Fe_Emision_Fin,
  ''A'',
  NULL
  );
  END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('04-MAY-2018 12.00.00.000000000 AM -05:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'Freq=DAILY;ByHour=23;ByMinute=0;BySecond=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Me permite generar el detalle de la factura por producto'
);
sys.dbms_scheduler.set_attribute('"FACTURASXDETALLEPRODUCTO"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"FACTURASXDETALLEPRODUCTO"');
COMMIT; 
END; 
/ 