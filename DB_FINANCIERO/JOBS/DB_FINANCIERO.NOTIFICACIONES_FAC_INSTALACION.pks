BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
      ,start_date      => TO_TIMESTAMP_TZ('2022/12/11 22:46:56.110690 America/Guayaquil','yyyy/mm/dd hh24:mi:ss.ff tzr')
      ,repeat_interval => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN;BYHOUR=8;BYMINUTE=30;BYSECOND=0'
      ,end_date        => NULL
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'PLSQL_BLOCK'
      ,job_action      => 'DECLARE
  --
  CURSOR C_GetTimestamp(Cn_NumeroDeHORAS NUMBER)
  IS
    --
    SELECT (SYSDATE - ( Cn_NumeroDeHORAS/24 )) FROM DUAL;
  --
  Lv_EmpresaId              DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE                  := ''10'';
  Lv_NombreDocumento        DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE                   := ''FACTURAS_INSTALACION'';
  Lv_CodigoPlantilla        DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE                       := ''FAC_INST_ACTIVA'';
  Lv_UsuarioCreacion        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE    := ''telcos_instalacion'';
  Lv_ConNumDocSri           VARCHAR2(2)                                                      := ''S'';
  Lv_Caracteristica         DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := ''NOTIFICACION_FACT_INSTALACION'';
  Lt_FechaAutorizacionDesde DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE;
  Lt_FechaAutorizacionHasta DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE;
  Lv_MensajeError           VARCHAR2(3000);
  Lt_FechaDesde             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE;
  Ln_NumeroDeHoras          NUMBER; 
  Lrf_GetAdmiParametrosDet  SYS_REFCURSOR;
  Lr_GetAdmiParametrosDet   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  --
BEGIN
  --
  IF Lt_FechaAutorizacionDesde IS NULL THEN
    --
    --Verifica el numero de horas maximo para consultar los documentos
    Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(''NOTIFICACIONES_FINANCIERAS'', 
                                                                                     ''Activo'', 
                                                                                     ''Activo'', 
                                                                                     ''TIEMPO_FACTURAS_INSTALACION'', 
                                                                                      NULL, 
                                                                                      NULL, 
                                                                                      NULL);
    --
    FETCH Lrf_GetAdmiParametrosDet INTO Lr_GetAdmiParametrosDet;
    --
    CLOSE Lrf_GetAdmiParametrosDet;
    --
    IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lr_GetAdmiParametrosDet.VALOR2 IS NOT NULL THEN
      --
      Ln_NumeroDeHoras := Lr_GetAdmiParametrosDet.VALOR2;
      --
    END IF;
    --
    IF Ln_NumeroDeHoras IS NOT NULL AND Ln_NumeroDeHoras > 0 THEN
      --
      IF C_GetTimestamp%ISOPEN THEN
        CLOSE C_GetTimestamp;
      END IF;
      --
      OPEN  C_GetTimestamp(Ln_NumeroDeHoras);
      FETCH C_GetTimestamp INTO Lt_FechaDesde;
      CLOSE C_GetTimestamp;
      --
    END IF;
    --
  ELSE
    --
    Lt_FechaDesde := Lt_FechaAutorizacionDesde;
    --
  END IF;
  --
  DB_FINANCIERO.FNKG_NOTIFICACIONES.P_ENVIO_NOTIFICACION_DOCUMENTO( Pv_EmpresaId              => Lv_EmpresaId, 
                                                                    Pv_NombreDocumento        => Lv_NombreDocumento, 
                                                                    Pv_CodigoPlantilla        => Lv_CodigoPlantilla, 
                                                                    Pv_UsuarioCreacion        => Lv_UsuarioCreacion, 
                                                                    Pv_ConNumDocSri           => Lv_ConNumDocSri,
                                                                    Pv_Caracteristica         => Lv_Caracteristica,
                                                                    Pt_FechaAutorizacionDesde => Lt_FechaDesde, 
                                                                    Pt_FechaAutorizacionHasta => Lt_FechaAutorizacionHasta,
                                                                    Pv_MensajeError           => Lv_MensajeError );
  --
END;'
      ,comments        => 'JOB QUE NOTIFICA LAS FACTURAS DE INSTALACION QUE HAN SIDO AUTORIZADAS Y QUE NO HAYAN SIDO NOTIFICADAS CON
                                    ANTERIORIDAD PARA TELCONET'
    );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'RESTARTABLE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'LOGGING_LEVEL'
     ,value     => SYS.DBMS_SCHEDULER.LOGGING_OFF);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'STOP_ON_WINDOW_CLOSE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'JOB_PRIORITY'
     ,value     => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'AUTO_DROP'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'RESTART_ON_RECOVERY'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'RESTART_ON_FAILURE'
     ,value     => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
    ( name      => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION'
     ,attribute => 'STORE_OUTPUT'
     ,value     => FALSE);

  SYS.DBMS_SCHEDULER.ENABLE
    (name                  => 'DB_FINANCIERO.NOTIFICACIONES_FAC_INSTALACION');
END;
/
