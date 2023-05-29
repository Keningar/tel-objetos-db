BEGIN 
dbms_scheduler.create_job('"JOB_FACTURACION_MASIVA_EN"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
  PN_EMPRESACOD            VARCHAR2 (2);
  PV_DESCRIPCIONIMPUESTO   VARCHAR2 (50);
  PV_TIPOFACTURACION       VARCHAR2 (200);
  Lv_TipoPromo             DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE;
  Ln_IdServicio            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL;
  Lv_JobProceso            VARCHAR2 (200);
  Lv_MsjResultado          VARCHAR2(4000);
  Lv_IpCreacion            VARCHAR2(16);
BEGIN
  PN_EMPRESACOD          := ''33'';
  PV_DESCRIPCIONIMPUESTO := ''IVA 12%'';
  PV_TIPOFACTURACION     := NULL;
  Lv_TipoPromo           := ''PROM_MENS'';
  Ln_IdServicio          := NULL;
  Lv_JobProceso          := ''JobFacturacion'';
  Lv_IpCreacion          := (NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), ''127.0.0.1''));
 DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''Telcos+'',''CMKG_PROMOCIONES.P_EJECUTA_MAPEO_MENSUAL'', ''Inicio de ejecucion P_EJECUTA_MAPEO_MENSUAL'',
''telcos_job_fact_en'',SYSDATE, NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), Lv_IpCreacion));
  DB_COMERCIAL.CMKG_PROMOCIONES.P_EJECUTA_MAPEO_MENSUAL(Pv_Empresa   => PN_EMPRESACOD,
                                                        Pv_TipoPromo => Lv_TipoPromo);
 DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''Telcos+'',''CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_PIERDE'', 
 ''Inicio de ejecucion P_OBTIENE_GRUPOS_PROC_PIERDE por Pv_TipoProceso: NUEVO'',''telcos_job_fact_en'',SYSDATE, 
 NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), Lv_IpCreacion));
  DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_PIERDE(Pv_Empresa => PN_EMPRESACOD, Pv_TipoPromo => Lv_TipoPromo, Pv_TipoProceso => ''NUEVO''); 
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''Telcos+'',''CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_PIERDE'', 
 ''Inicio de ejecucion P_OBTIENE_GRUPOS_PROC_PIERDE por Pv_TipoProceso: EXISTENTE'',''telcos_job_fact_en'',SYSDATE,
 NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), Lv_IpCreacion));
 DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_PIERDE(Pv_Empresa => PN_EMPRESACOD,Pv_TipoPromo => Lv_TipoPromo,Pv_TipoProceso => ''EXISTENTE'');
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''Telcos+'',''CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_MAPEO'', 
''Inicio de ejecucion P_OBTIENE_GRUPOS_PROC_MAPEO'',''telcos_job_fact_en'',SYSDATE, NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), Lv_IpCreacion)); 
  DB_COMERCIAL.CMKG_PROMOCIONES.P_OBTIENE_GRUPOS_PROC_MAPEO(Pv_CodigoGrupoPromocion => Lv_TipoPromo, Pv_CodEmpresa    => PN_EMPRESACOD,
                                                            Pv_TipoProceso          => ''EXISTENTE'', Pv_JobProceso   => Lv_JobProceso); 
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''Telcos+'', ''CMKG_PROMOCIONES.P_APLICA_PROMOCION'', 
''Inicio de ejecucion P_APLICA_PROMOCION'',''telcos_job_fact_en'',SYSDATE, NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), Lv_IpCreacion));
  DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   => PN_EMPRESACOD, Pv_TipoPromo    => Lv_TipoPromo,
  Pn_IdServicio   => Ln_IdServicio, Pv_TipoProceso  => ''EXISTENTE'', Pv_JobProceso   => Lv_JobProceso, Pv_MsjResultado => Lv_MsjResultado);
  DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   => PN_EMPRESACOD, Pv_TipoPromo    => Lv_TipoPromo,
  Pn_IdServicio   => Ln_IdServicio, Pv_TipoProceso  => ''NUEVO'', Pv_JobProceso   => Lv_JobProceso, Pv_MsjResultado => Lv_MsjResultado);
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''Telcos+'',''FNCK_FACTURACION_MENSUAL_EN.P_FACTURACION_MENSUAL'', 
''Inicio de ejecucion P_FACTURACION_MENSUAL'',''telcos_job_fact_en'',SYSDATE, NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), Lv_IpCreacion)); 
  DB_FINANCIERO.FNCK_FACTURACION_MENSUAL_EN.P_FACTURACION_MENSUAL (PN_EMPRESACOD  => PN_EMPRESACOD,
                                         PV_DESCRIPCIONIMPUESTO => PV_DESCRIPCIONIMPUESTO, PV_TIPOFACTURACION  => PV_TIPOFACTURACION);
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''Telcos+'',''FNCK_FACTURACION_MENSUAL_EN.P_FACTURACION_MENSUAL'', 
''Fin de ejecucion P_FACTURACION_MENSUAL'',''telcos_job_fact_en'',SYSDATE, NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), Lv_IpCreacion));
END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('02-APR-2023 02.27.20.982520000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=0;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Proceso para ejecutar la facturacion mensual de ECUANET'
);
sys.dbms_scheduler.set_attribute('"JOB_FACTURACION_MASIVA_EN"','NLS_ENV','NLS_LANGUAGE=''SPANISH'' NLS_TERRITORY=''SPAIN'' NLS_CURRENCY='''' NLS_ISO_CURRENCY=''SPAIN'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD/MM/RR'' NLS_DATE_LANGUAGE=''SPANISH'' NLS_SORT=''SPANISH'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD/MM/RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD/MM/RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY='''' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.set_attribute('"JOB_FACTURACION_MASIVA_EN"','logging_level',DBMS_SCHEDULER.LOGGING_FULL);
dbms_scheduler.enable('"JOB_FACTURACION_MASIVA_EN"');
COMMIT; 
END; 
/ 
