
BEGIN 
dbms_scheduler.create_job('"JOB_NOTIF_PREFAC_ELIMINADAS_TN"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
  --
  CURSOR GetFechaDesde(Cv_NumeroDeHoras NUMBER)
  IS
    SELECT CAST(TRUNC(SYSDATE) - ( Cv_NumeroDeHoras/24 )   AS TIMESTAMP WITH TIME ZONE)
      FROM DUAL;
  --
  CURSOR GetFechaHasta
  IS
    SELECT CAST(SYSDATE AS  TIMESTAMP WITH TIME ZONE)
    FROM DUAL;
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_PrefijoEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  Ln_NumeroDeHoras        NUMBER;
  Lv_EstadoPl             DB_FINANCIERO.INFO_PAGO_LINEA.ESTADO_PAGO_LINEA%TYPE;
  Lv_msnResult            VARCHAR2(500);
  Lv_messageError         VARCHAR2(500);
  Lt_FechaPeDesde         TIMESTAMP (6);
  Lt_FechaPeHasta         TIMESTAMP (6);
  Lv_CodigoPlantilla      VARCHAR2(100);
  Lv_Caracteristica       VARCHAR2(100);
  Lv_EstadoPreFac         VARCHAR2(100);
  --
BEGIN
  --
  Lv_PrefijoEmpresa         := ''TN'';
  Ln_NumeroDeHoras          :=  48;
  Lv_CodigoPlantilla        := ''ELI_PREFACTURAS'';
  Lv_Caracteristica         := ''NOTIFICACION_PREFACTURAS_ELIMINADAS'';
  Lv_EstadoPreFac           := ''Eliminado'';
  --
  Lrf_GetAdmiParamtrosDet   := NULL;
  --
  --Verifica prefijo de la empresa al cual se van a notificar los documentos eliminados.
  Lrf_GetAdmiParamtrosDet   := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(''EMPRESA_PREFIJO_PE'', ''Activo'',
                                                                       ''Activo'', ''EMPRESA_PE'',
                                                                       NULL, NULL, NULL);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
     Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
     --
     Lv_PrefijoEmpresa      := Lr_GetAdmiParamtrosDet.VALOR2;
     --
  END IF;
  --
  Lrf_GetAdmiParamtrosDet   := NULL;
  --
  Lr_GetAdmiParamtrosDet    := NULL;
  --
  --Verifica desde que fecha se obtendra los documentos a notificar por medio del numero de horas.
  Lrf_GetAdmiParamtrosDet   := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(''NUMERO_HORAS_ELI_PREFACTURAS'', ''Activo'',
                                                                       ''Activo'', ''NUMERO_HORAS_PE'',
                                                                       NULL, NULL, NULL);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
     Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
     --
     Ln_NumeroDeHoras       := Lr_GetAdmiParamtrosDet.VALOR2;
     --
  END IF;
  --
  Lrf_GetAdmiParamtrosDet   := NULL;
  --
  Lr_GetAdmiParamtrosDet    := NULL;
  --
  --Obtengo la fecha desde a partir del numero de horas.
  OPEN GetFechaDesde(Ln_NumeroDeHoras);
  FETCH GetFechaDesde INTO Lt_FechaPeDesde;
  CLOSE GetFechaDesde;
  --
  OPEN  GetFechaHasta;
  FETCH GetFechaHasta INTO Lt_FechaPeHasta;
  CLOSE GetFechaHasta;
  --
  --Llamada al procedimiento que notifica las pre facturas en estado eliminado
  --A partir de 48 horas atras hasta la fecha sea ejecutado.
   FNKG_NOTIFICACIONES.P_NOTIFICACION_PREFACTURAS(
                                              PV_PREFIJOEMPRESA   => Lv_PrefijoEmpresa,
                                              PT_FECHAPEDESDE     => Lt_FechaPeDesde,
                                              PT_FECHAPEHASTA     => Lt_FechaPeHasta,
                                              PV_ESTADOPREFAC     => Lv_EstadoPreFac,
                                              PV_CODIGOPLANTILLA  => Lv_CodigoPlantilla,
                                              PV_CARACTERISTICA   => Lv_Caracteristica,
                                              PV_MSNRESULT        => Lv_msnResult,
                                              PV_MESSAGEERROR     => Lv_messageError
  );
END;'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('05-JAN-2017 03.37.40.949024000 AM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYHOUR=18;BYMINUTE=0;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Se debe notificar al usuario las pre facturas que se encuentren en estado Eliminado, con un tiempo maximo de 48 horas'
);
sys.dbms_scheduler.set_attribute('"JOB_NOTIF_PREFAC_ELIMINADAS_TN"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_NOTIF_PREFAC_ELIMINADAS_TN"');
COMMIT; 
END; 
/ 