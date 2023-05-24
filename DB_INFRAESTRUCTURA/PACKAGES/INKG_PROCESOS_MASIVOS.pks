CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS
AS
  PROCEDURE P_VALIDAR_CAB_ID(
    Pn_IdCab                 IN  NUMBER,
    Pt_TregsDataCabecerasPm  IN  DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATACABECERASPM,
    Pv_Existe                OUT VARCHAR2)
  AS
  Lv_Mensaje                VARCHAR2(4000);
  Ln_IndxRegDataCabecerasPm NUMBER := 0;
  Lr_RegInfoDataCabecerasPm DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LR_DATACABECERASPM;
  BEGIN
    Pv_Existe := 'NO';
    Ln_IndxRegDataCabecerasPm := Pt_TregsDataCabecerasPm.FIRST;
    WHILE (Ln_IndxRegDataCabecerasPm IS NOT NULL)
    LOOP
      Lr_RegInfoDataCabecerasPm  := Pt_TregsDataCabecerasPm(Ln_IndxRegDataCabecerasPm);
      IF Lr_RegInfoDataCabecerasPm.Id_Cab =  Pn_IdCab THEN
        Pv_Existe := 'SI';
      END IF;
      Ln_IndxRegDataCabecerasPm := Pt_TregsDataCabecerasPm.NEXT(Ln_IndxRegDataCabecerasPm);
    END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Existe       := 'NO';
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_VALIDAR_CAB_ID',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_VALIDAR_CAB_ID;

  PROCEDURE P_OBTENER_CABECERAS_PM(
    Pv_TipoProceso      IN VARCHAR2,
    Pv_EmpresaCod       IN VARCHAR2,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_Response        OUT CLOB,
    Pn_CantidadCab      OUT NUMBER)
  AS
    Lv_EstadoActivo                 VARCHAR2(6)  := 'Activo';
    Lv_EstadoPendiente              VARCHAR2(9)  := 'Pendiente';
    Lv_EstadoProcesando             VARCHAR2(15) := 'Procesando';
    Lv_Mensaje                      VARCHAR2(4000);
    Lv_QueryExec                    VARCHAR2(1500);
    Lcl_Select                      CLOB;
    Lcl_From                        CLOB;
    Lcl_Join                        CLOB;
    Lcl_Where                       CLOB;
    Lv_NombreParametro              VARCHAR2(50) := 'EMPRESAS_CORTE_REAC_MASIVO';
  BEGIN
    Lcl_Select      := 'SELECT LISTAGG(CAB.ID_PROCESO_MASIVO_CAB, '','') 
                          WITHIN GROUP (ORDER BY CAB.FE_CREACION),
                          COUNT(*)';
    Lcl_From        := 'FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB CAB ';

    Lcl_Join      := 'INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                        ON PARAM_DET.VALOR2 = CAB.TIPO_PROCESO
                      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                        ON PARAM_CAB.ID_PARAMETRO = PARAM_DET.PARAMETRO_ID ';

    Lcl_Where       := 'WHERE PARAM_CAB.NOMBRE_PARAMETRO = ''' || Lv_NombreParametro || '''
                       AND PARAM_DET.VALOR1             = ''' || Pv_TipoProceso || '''
                       AND PARAM_DET.VALOR3             = ''' || Pv_EmpresaCod || '''
                       AND PARAM_CAB.ESTADO             = ''' || Lv_EstadoActivo || '''
                       AND PARAM_DET.ESTADO             = ''' || Lv_EstadoActivo || '''
                       AND CAB.ESTADO                   IN (''' || Lv_EstadoPendiente || ''', ''' || Lv_EstadoProcesando || ''')
                       AND CAB.EMPRESA_ID               = (SELECT EMP_GRUPO.COD_EMPRESA FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP_GRUPO
                                                           WHERE EMP_GRUPO.PREFIJO = ''' || Pv_EmpresaCod || ''') ';

    Lv_QueryExec := Lcl_Select || Lcl_From || Lcl_Join || Lcl_Where;
    EXECUTE IMMEDIATE Lv_QueryExec INTO Pcl_Response, Pn_CantidadCab;
    Pv_Status   := 'OK';
    Pv_Mensaje  := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Pn_CantidadCab  := 0;
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se han podido recuperar correctamente las cabeceras de procesos masivos. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_OBTENER_CABECERAS_PM',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTENER_CABECERAS_PM;

  PROCEDURE P_ACTUALIZAR_CABECERAS_PM(
    Pcl_Cabeceras       IN  CLOB,
    Pv_EstadoNuevo      IN  VARCHAR2,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2)
  AS
    Lv_Mensaje VARCHAR2(4000) := 'Error al actualizar cabeceras';
  BEGIN
    EXECUTE IMMEDIATE 'UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB ' || 
                      'SET DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO = :v1 ' ||
                      'WHERE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB In ('||Pcl_Cabeceras||')'
    USING Pv_EstadoNuevo;
    COMMIT;
    Pv_Status   := 'OK';
    Pv_Mensaje  := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se han podido actualizar correctamente las cabeceras de procesos masivos. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_CABECERAS_PM',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZAR_CABECERAS_PM;

  PROCEDURE P_ACTUALIZAR_DETALLES_PM(
    Pcl_Cabeceras       IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2)
  AS
    Lv_EstadoProcesando VARCHAR2(15)   := 'Procesando';
    Lv_EstadoPendiente  VARCHAR2(15)   := 'Pendiente';
    Lv_EstadoFallo      VARCHAR2(9)    := 'Fallo';
    Ln_IntentosMaximos  NUMBER         := 0;
    Lv_Mensaje          VARCHAR2(4000) := 'Error al actualizar detalle';
  BEGIN
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_CANTIDAD_INTENTOS(Ln_IntentosMaximos);
    EXECUTE IMMEDIATE 'UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET ' || 
                      'SET DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO = :v1 ' ||
                      'WHERE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.PROCESO_MASIVO_CAB_ID In ('||Pcl_Cabeceras||')' ||
                      'AND DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO In (:v2, :v3) ' ||
                      'AND (DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.CANTIDAD_INTENTOS Is Null Or DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.CANTIDAD_INTENTOS < :v4)'
    USING Lv_EstadoProcesando, Lv_EstadoPendiente, Lv_EstadoFallo, Ln_IntentosMaximos;
    COMMIT;
    Pv_Status   := 'OK';
    Pv_Mensaje  := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se han podido actualizar correctamente los detalles de procesos masivos. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_DETALLES_PM',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZAR_DETALLES_PM;

  PROCEDURE P_ACTUALIZA_REGULARIZA_CAB_PM
  AS
    Lv_Mensaje VARCHAR2(4000) := 'Error al actualizar cabeceras en procesamiento';
    Ln_IntentosMaximos  NUMBER := 0;
    Ln_CantidadDetalles NUMBER := 0;
  BEGIN
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_CANTIDAD_INTENTOS(Ln_IntentosMaximos);
    FOR cabecera IN
    (SELECT id_proceso_masivo_cab,
      cantidad_puntos
    FROM db_infraestructura.info_proceso_masivo_cab
    WHERE tipo_proceso = 'CortarCliente' AND estado = 'Procesando'
    )
    loop
      SELECT count(*)
      INTO Ln_CantidadDetalles
      FROM db_infraestructura.info_proceso_masivo_det
      WHERE proceso_masivo_cab_id = cabecera.id_proceso_masivo_cab
      AND ((estado               IN ('Finalizada', 'In-Corte'))
      OR (estado                  = 'Fallo'
      AND cantidad_intentos      IS NOT NULL
      AND cantidad_intentos       = Ln_IntentosMaximos) );
      IF Ln_CantidadDetalles = cabecera.cantidad_puntos THEN
        UPDATE db_infraestructura.info_proceso_masivo_cab
        SET estado = 'Finalizada'
        WHERE id_proceso_masivo_cab = cabecera.id_proceso_masivo_cab;
        COMMIT;
      END IF;
    END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_ACTUALIZA_REGULARIZA_CAB_PM',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZA_REGULARIZA_CAB_PM;

  PROCEDURE P_INSERT_INFO_SERVICIO_HISTO(
    Pr_InfoServicioHisto   IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE,
    Pv_MsjResultado        OUT VARCHAR2)
  IS
  BEGIN
    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
    (ID_SERVICIO_HISTORIAL,
     SERVICIO_ID,
     USR_CREACION,
     FE_CREACION,
     IP_CREACION,
     ESTADO,
     MOTIVO_ID,
     OBSERVACION,
     ACCION)
    VALUES
    (Pr_InfoServicioHisto.Id_Servicio_Historial,
     Pr_InfoServicioHisto.Servicio_Id,
     Pr_InfoServicioHisto.Usr_Creacion,
     Pr_InfoServicioHisto.Fe_Creacion,
     Pr_InfoServicioHisto.Ip_Creacion,
     Pr_InfoServicioHisto.Estado,
     Pr_InfoServicioHisto.Motivo_Id,
     Pr_InfoServicioHisto.Observacion,
     Pr_InfoServicioHisto.Accion
    );
    Pv_MsjResultado := '';
  EXCEPTION
  WHEN OTHERS THEN  
    Pv_MsjResultado := 'Error en P_INSERT_INFO_SERVICIO_HISTO - ' || SQLERRM;
  END P_INSERT_INFO_SERVICIO_HISTO;

  PROCEDURE P_ACTUALIZA_INCONSISTENCIA_PM(
    Pcl_Cabeceras       IN  CLOB)
  AS
    Lv_Mensaje VARCHAR2(4000) := 'Error al actualizar inconsistencias';
  BEGIN
    EXECUTE IMMEDIATE ' UPDATE db_infraestructura.info_proceso_masivo_det pmd
                        SET pmd.estado                   =''Finalizada'',
                          pmd.observacion                =''Servicio de Internet con Estado Trasladado, se finaliza registro autom�ticamente''
                        WHERE pmd.id_proceso_masivo_det IN
                          (SELECT db_infraestructura.info_proceso_masivo_det.id_proceso_masivo_det
                          FROM db_infraestructura.info_proceso_masivo_det,
                            db_infraestructura.info_servicio,
                            db_comercial.info_plan_cab ipc,
                            db_comercial.info_plan_det ipd,
                            db_comercial.admi_producto ap
                          WHERE info_proceso_masivo_det.proceso_masivo_cab_id IN ('||Pcl_Cabeceras||')
                          AND info_proceso_masivo_det.punto_id                 = info_servicio.punto_id
                          AND info_servicio.plan_id                            = ipc.id_plan
                          AND ipc.id_plan                                      = ipd.plan_id
                          AND ipd.producto_id                                  = ap.id_producto
                          AND ap.nombre_tecnico                                = ''INTERNET''
                          AND info_servicio.estado                             = ''Trasladado''
                          )';
    COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_ACTUALIZA_INCONSISTENCIA_PM',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZA_INCONSISTENCIA_PM;

  PROCEDURE P_OBTENER_DETALLES_PM(
    Pcl_Cabeceras       IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Prf_Registros       OUT SYS_REFCURSOR)
  AS
    Lv_Mensaje                      VARCHAR2(4000);
    Lcl_Select                      CLOB;
    Lcl_From                        CLOB;
    Lcl_Join                        CLOB;
    Lcl_Where                       CLOB;
    Lcl_ConsultaPrincipal           CLOB;
    Lv_EstadoActivo                 VARCHAR2(20) := 'Activo';
    Lv_EstadoPendiente              VARCHAR2(20) := 'Pendiente';
    Lv_EstadoFallo                  VARCHAR2(20) := 'Fallo';
    Lv_EstadoInCorte                VARCHAR2(20) := 'In-Corte';
    Lv_NombreTecnicoIp              VARCHAR2(20) := 'IP';
    Lv_EmpresaMd                    VARCHAR2(20) := '18';
    Ln_CantidadIntentosMax          VARCHAR2(20) := 0;
  BEGIN
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_CANTIDAD_INTENTOS(Ln_CantidadIntentosMax);
    Lcl_Select      := 'SELECT CAB.ID_PROCESO_MASIVO_CAB AS ID_CAB,
                        MD.ID_PROCESO_MASIVO_DET       AS ID_DET,
                        CAB.TIPO_PROCESO               AS TIPO_PROCESO,
                        MD.ESTADO                      AS ESTADO,
                        P.ID_PUNTO                     AS PUNTO_ID,
                        P.LOGIN                        AS LOGIN,
                        CASE
                          WHEN IEG.PREFIJO = ''TN''
                          THEN REPLACE(DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''Grupo Negocio''),''TN'','''')
                          ELSE ATN.NOMBRE_TIPO_NEGOCIO
                        END                          AS TIPO_NEGOCIO,
                        IEG.PREFIJO                  AS PREFIJO_EMPRESA,
                        E.ID_ELEMENTO                AS ELEMENTO_ID,
                        E.NOMBRE_ELEMENTO            AS NOMBRE_ELEMENTO_OLT,
                        ECLI.SERIE_FISICA            AS SERIE_ONT,
                        ST.ELEMENTO_CLIENTE_ID       AS ELEMENTO_CLIENTE_ID,
                        S.ID_SERVICIO                AS SERVICIO_ID,
                        S.ESTADO                     AS SERVICIO_ESTADO,
                        P.ESTADO                     AS PUNTO_ESTADO,
                        ST.ID_SERVICIO_TECNICO       AS SERVICIO_TECNICO_ID,
                        ME.ID_MODELO_ELEMENTO        AS MODELO_ELEMENTO_ID,
                        ME.NOMBRE_MODELO_ELEMENTO    AS MODELO_ELEMENTO_NOMBRE,
                        MARCAE.NOMBRE_MARCA_ELEMENTO AS MARCA_ELEMENTO_NOMBRE,
                        (CAB.TIPO_PROCESO
                        || ME.NOMBRE_MODELO_ELEMENTO) AS ACCION,
                        (SELECT
                          (SELECT MENSAJE
                          FROM DB_COMUNICACION.INFO_DOCUMENTO D
                          WHERE D.TAREA_INTERFACE_MODELO_TRA_ID = RS.TAREA_INTERFACE_MODELO_TRA_ID
                          )
                        FROM DB_SEGURIDAD.SIST_ACCION SA
                        INNER JOIN DB_SEGURIDAD.SEGU_RELACION_SISTEMA RS
                        ON SA.ID_ACCION        = RS.ACCION_ID
                        WHERE SA.NOMBRE_ACCION = LOWER(SUBSTR(CAB.TIPO_PROCESO, 1,1 ))
                          ||SUBSTR(CAB.TIPO_PROCESO, 2,LENGTH(CAB.TIPO_PROCESO))
                          || ME.NOMBRE_MODELO_ELEMENTO
                        AND ROWNUM = 1
                        ) AS SCRIPT,
                        IP.IP,
                        IE.NOMBRE_INTERFACE_ELEMENTO                                                                   AS PUERTO,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''PERFIL'')            AS CARACT_PERFIL,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''INDICE CLIENTE'')    AS CARACT_INDICE,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''MAC ONT'')           AS CARACT_MAC,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''SPID'')              AS SPID,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''VLAN'')              AS VLAN,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''GEM-PORT'')          AS GEMPORT,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''TRAFFIC-TABLE'')     AS TRAFFIC,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''LINE-PROFILE-NAME'') AS PROFILE_NAME,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''SERVICE-PROFILE'')   AS SERVICE,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''CAPACIDAD1'')        AS CAPACIDAD_UP,
                        DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(S.ID_SERVICIO,''CAPACIDAD2'')        AS CAPACIDAD_DOWN,
                        CASE
                          WHEN MARCAE.NOMBRE_MARCA_ELEMENTO = ''ZTE''
                          THEN NVL(
                            (SELECT COUNT(DISTINCT SERVICIO_IP_ADIC.ID_SERVICIO)
                            FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_IP_ADIC
                            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO_IP
                            ON PRODUCTO_IP.ID_PRODUCTO = SERVICIO_IP_ADIC.PRODUCTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_IP IP
                            ON IP.SERVICIO_ID                 = SERVICIO_IP_ADIC.ID_SERVICIO
                            WHERE SERVICIO_IP_ADIC.PUNTO_ID   = S.PUNTO_ID
                            AND SERVICIO_IP_ADIC.ESTADO       = S.ESTADO
                            AND IP.ESTADO                     = ''' || Lv_EstadoActivo || '''
                            AND SERVICIO_IP_ADIC.ID_SERVICIO <> S.ID_SERVICIO
                            AND PRODUCTO_IP.NOMBRE_TECNICO    = ''' || Lv_NombreTecnicoIp || '''
                            AND PRODUCTO_IP.ESTADO            = ''' || Lv_EstadoActivo || '''
                            AND PRODUCTO_IP.EMPRESA_COD       = ''' || Lv_EmpresaMd || '''
                            ), 0)
                          ELSE 0
                        END AS IP_FIJAS_ADICIONALES ';
    Lcl_From      := 'FROM DB_COMERCIAL.INFO_SERVICIO S ';
    Lcl_Join      := 'INNER JOIN DB_COMERCIAL.INFO_PUNTO P
                      ON S.PUNTO_ID = P.ID_PUNTO
                      INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO ATN
                      ON P.TIPO_NEGOCIO_ID = ATN.ID_TIPO_NEGOCIO
                      INNER JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET MD
                      ON S.PUNTO_ID = MD.PUNTO_ID
                      LEFT JOIN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB CAB
                      ON MD.PROCESO_MASIVO_CAB_ID = CAB.ID_PROCESO_MASIVO_CAB
                      LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
                      ON COALESCE(TO_NUMBER(REGEXP_SUBSTR(IEG.COD_EMPRESA,''^\d+'')),0) = CAB.EMPRESA_ID
                      LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ST
                      ON S.ID_SERVICIO = ST.SERVICIO_ID
                      LEFT JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IE
                      ON ST.INTERFACE_ELEMENTO_ID = IE.ID_INTERFACE_ELEMENTO
                      LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO E
                      ON ST.ELEMENTO_ID = E.ID_ELEMENTO
                      LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ECLI
                      ON ST.ELEMENTO_CLIENTE_ID = ECLI.ID_ELEMENTO
                      LEFT JOIN DB_INFRAESTRUCTURA.INFO_IP IP
                      ON E.ID_ELEMENTO = IP.ELEMENTO_ID
                      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO ME
                      ON E.MODELO_ELEMENTO_ID = ME.ID_MODELO_ELEMENTO
                      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCAE
                      ON MARCAE.ID_MARCA_ELEMENTO     = ME.MARCA_ELEMENTO_ID ';
    Lcl_Where     := 'WHERE MD.PROCESO_MASIVO_CAB_ID IN ('|| Pcl_Cabeceras || ')
                      AND MD.ESTADO                  IN (''' || Lv_EstadoPendiente || ''', ''' || LV_EstadoFallo || ''')
                      AND (MD.CANTIDAD_INTENTOS IS NULL OR MD.CANTIDAD_INTENTOS < ' || Ln_CantidadIntentosMax ||')
                      AND S.ESTADO                   IN(''' || Lv_EstadoInCorte || ''',''' || Lv_EstadoActivo || ''')
                      AND ( (MD.SERVICIO_ID          IS NOT NULL
                      AND S.ID_SERVICIO               = MD.SERVICIO_ID)
                      OR (S.ID_SERVICIO               = DB_COMERCIAL.GET_ID_SERVICIO_PREF(P.ID_PUNTO)) )
                      ORDER BY NOMBRE_ELEMENTO_OLT,PREFIJO_EMPRESA,TIPO_PROCESO,ESTADO ASC ';

    Lcl_ConsultaPrincipal := Lcl_Select || Lcl_From || Lcl_Join || Lcl_Where;
    OPEN Prf_Registros FOR Lcl_ConsultaPrincipal;
    Pv_Status   := 'OK';
    Pv_Mensaje  := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se ha podido realizar correctamente la consulta de detalles de procesos masivos. Por favor consultar con Sistemas!';
    Prf_Registros   := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_OBTENER_DETALLES_PM',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTENER_DETALLES_PM;

  PROCEDURE P_OBTENER_DETALLES_INFO_PM(
    Pn_IdProcesoMasivoDet   IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE,
    Pn_IdPunto              OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_CantidadIntentos     OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.CANTIDAD_INTENTOS%TYPE)
  AS
    Lv_Mensaje                      VARCHAR2(4000);
    Lv_QueryExec                    VARCHAR2(1000);
    Lcl_Select                      CLOB;
    Lcl_From                        CLOB;
    Lcl_Where                       CLOB;
  BEGIN
    Lcl_Select      := 'SELECT DET.PUNTO_ID, DET.CANTIDAD_INTENTOS ';
    Lcl_From        := 'FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET DET ';

    Lcl_Where       := 'WHERE DET.ID_PROCESO_MASIVO_DET = ' || Pn_IdProcesoMasivoDet;

    Lv_QueryExec := Lcl_Select || Lcl_From || Lcl_Where;
    EXECUTE IMMEDIATE Lv_QueryExec INTO Pn_IdPunto, Pn_CantidadIntentos;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_OBTENER_DETALLES_INFO_PM',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTENER_DETALLES_INFO_PM;

  PROCEDURE P_OBTENER_PM(
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_JsonResponse    OUT CLOB)
  AS
    Lv_EstadoPendiente              VARCHAR2(15) := 'Pendiente';
    Lv_EstadoProcesando             VARCHAR2(15) := 'Procesando';
    Lv_EstadoActivo                 VARCHAR2(15) := 'Activo';
    Lv_UsrCreacion                  VARCHAR2(20) := 'procesosmasivos';
    Lv_IpCreacion                   VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    Ln_IndxRegListadoMiddleware     NUMBER := 0;
    Ln_IndxRegDataCabecerasPm       NUMBER := 0;
    Lr_RegInfoServicioMiddleware    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LR_INFOSERVICIOMIDDLEWARE;
    Lt_TRegsInfoServicioMiddleware  DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_INFOSERVICIOMIDDLEWARE;
    Lr_RegInfoDataCabecerasPm       DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LR_DATACABECERASPM;
    Lt_TRegsDataCabecerasPm         DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATACABECERASPM;
    Lt_TRegsDataCabecerasPmTmp      DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATACABECERASPM;
    Lrf_RegistrosServicioMw         SYS_REFCURSOR;
    Lv_TipoProceso                  VARCHAR2(20);
    Lv_EmpresaCod                   VARCHAR2(2);
    Lv_Opcion                       VARCHAR2(20);
    Lv_EmpresaPrefijo               VARCHAR2(10) := '';
    Lv_NombreElementoOlt            DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE := '';
    Lv_IpElemento                   DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE := '';
    Lv_Status                       VARCHAR2(5);
    Lv_Mensaje                      VARCHAR2(4000);
    Lv_OltAnterior                  DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE := 'INICIO';
    Lv_CadenaVacia                  VARCHAR2(8) := 'STR_RPLC';
    Lcl_JsonResponseCab             CLOB;
    Le_Exception                    EXCEPTION;
    Lv_Existe                       VARCHAR2(2) := 'NO';
    Lv_StatusReverso                VARCHAR2(5);
    Lv_MensajeReverso               VARCHAR2(4000);
    Ln_CantidadCab                  NUMBER := 0;
    Lv_NombreParametro              VARCHAR2(200)  := 'PARAMETROS_PROCESOS_MASIVOS_TELCOS';
    Lv_DatosMw                      VARCHAR2(200)  := 'DATOS_MW';
    Lv_ComandoConfiguracion         VARCHAR2(2) := 'NO';
    Lv_EjecutaComando               VARCHAR2(2) := 'NO';
    CURSOR C_OBTENERPARAMMW IS
      SELECT NVL(VALOR2, 'NO'), NVL(VALOR3, 'NO') FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE ESTADO = Lv_EstadoActivo AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
          WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_EstadoActivo AND ROWNUM = 1)
      AND DESCRIPCION = Lv_DatosMw AND ROWNUM = 1;
  BEGIN
    OPEN C_OBTENERPARAMMW;
    FETCH C_OBTENERPARAMMW INTO Lv_ComandoConfiguracion, Lv_EjecutaComando;
    CLOSE C_OBTENERPARAMMW;
    APEX_JSON.PARSE(Pcl_JsonRequest);
    Lv_TipoProceso          := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoProceso'));
    Lv_EmpresaCod           := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'empresaCod'));
    Lv_Opcion               := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'opcion'));
    IF Lv_TipoProceso IS NULL OR Lv_EmpresaCod IS NULL OR Lv_Opcion IS NULL THEN
      Lv_Mensaje := 'No se han enviado los par�metros obligatorios';
      RAISE Le_Exception;
    END IF;
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_ARRAY('olts');
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZA_REGULARIZA_CAB_PM;
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_OBTENER_CABECERAS_PM(
      Lv_TipoProceso,
      Lv_EmpresaCod,
      Lv_Status,
      Lv_Mensaje,
      Lcl_JsonResponseCab,
      Ln_CantidadCab);
    IF Lv_Status = 'OK' AND Lcl_JsonResponseCab IS NOT NULL THEN
      DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_CABECERAS_PM(
        Lcl_JsonResponseCab,
        Lv_EstadoProcesando,
        Lv_Status,
        Lv_Mensaje);
      IF Lv_Status = 'OK' THEN
        DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZA_INCONSISTENCIA_PM(
          Lcl_JsonResponseCab);
        DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_OBTENER_DETALLES_PM(
          Lcl_JsonResponseCab,
          Lv_Status,
          Lv_Mensaje,
          Lrf_RegistrosServicioMw);
        IF Lv_Status = 'OK' THEN
          DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_DETALLES_PM(
            Lcl_JsonResponseCab,
            Lv_Status,
            Lv_Mensaje);
          IF Lv_Status = 'OK' THEN
            LOOP
              FETCH Lrf_RegistrosServicioMw BULK COLLECT
              INTO Lt_TRegsInfoServicioMiddleware LIMIT 1000;
              Ln_IndxRegListadoMiddleware := Lt_TRegsInfoServicioMiddleware.FIRST;
              WHILE (Ln_IndxRegListadoMiddleware IS NOT NULL)
              LOOP
                Lr_RegInfoServicioMiddleware := Lt_TRegsInfoServicioMiddleware(Ln_IndxRegListadoMiddleware);
                Lv_NombreElementoOlt         := Lr_RegInfoServicioMiddleware.NOMBRE_ELEMENTO_OLT;
                IF Lv_OltAnterior <> Lv_NombreElementoOlt THEN
                  IF (Lv_OltAnterior != 'INICIO') THEN
                    APEX_JSON.CLOSE_ARRAY;
                    APEX_JSON.CLOSE_OBJECT;
                    APEX_JSON.OPEN_ARRAY('idsPmCab');
                    Ln_IndxRegDataCabecerasPm := Lt_TRegsDataCabecerasPm.FIRST;
                    WHILE (Ln_IndxRegDataCabecerasPm IS NOT NULL)
                    LOOP
                      Lr_RegInfoDataCabecerasPm  := Lt_TRegsDataCabecerasPm(Ln_IndxRegDataCabecerasPm);
                      APEX_JSON.WRITE(Lr_RegInfoDataCabecerasPm.ID_CAB);
                      Ln_IndxRegDataCabecerasPm := Lt_TRegsDataCabecerasPm.NEXT(Ln_IndxRegDataCabecerasPm);
                    END LOOP;
                    APEX_JSON.CLOSE_ARRAY;
                    APEX_JSON.WRITE('nombreOlt', Lv_OltAnterior, TRUE);
                    APEX_JSON.WRITE('tipoProceso', Lv_TipoProceso, TRUE);
                    APEX_JSON.WRITE('estado', 'EN_COLA');
                    APEX_JSON.WRITE('observacion', Lv_CadenaVacia, TRUE);
                    APEX_JSON.OPEN_OBJECT('response');
                    APEX_JSON.CLOSE_OBJECT;
                    APEX_JSON.WRITE('prefijoEmpresa', Lv_EmpresaPrefijo, TRUE);
                    APEX_JSON.CLOSE_OBJECT;
                    Lt_TRegsDataCabecerasPm := Lt_TRegsDataCabecerasPmTmp;
                  END IF;
                  APEX_JSON.OPEN_OBJECT;
                  APEX_JSON.OPEN_OBJECT('request');
                  APEX_JSON.WRITE('opcion', Lv_Opcion, TRUE);
                  Lv_EmpresaPrefijo := Lr_RegInfoServicioMiddleware.PREFIJO_EMPRESA;
                  Lv_OltAnterior    := Lv_NombreElementoOlt;
                  Lv_IpElemento     := Lr_RegInfoServicioMiddleware.IP;
                  APEX_JSON.WRITE('empresa', Lv_EmpresaPrefijo, TRUE);
                  APEX_JSON.WRITE('usrCreacion', Lv_UsrCreacion, TRUE);
                  APEX_JSON.WRITE('ipCreacion', Lv_IpCreacion, TRUE);
                  APEX_JSON.WRITE('comandoConfiguracion', Lv_ComandoConfiguracion, TRUE);
                  APEX_JSON.WRITE('ejecutaComando', Lv_EjecutaComando, TRUE);
                  APEX_JSON.OPEN_OBJECT('datos_elemento');
                  APEX_JSON.WRITE('nombre_elemento', Lv_NombreElementoOlt, TRUE);
                  APEX_JSON.WRITE('ip_elemento', Lv_IpElemento, TRUE);
                  APEX_JSON.CLOSE_OBJECT;
                  APEX_JSON.OPEN_OBJECT('cambio_plan');
                  APEX_JSON.WRITE('gem_port_nuevo', Lv_CadenaVacia, TRUE);
                  APEX_JSON.WRITE('line_profile_nuevo', Lv_CadenaVacia, TRUE);
                  APEX_JSON.WRITE('tipo_negocio_nuevo', Lv_CadenaVacia, TRUE);
                  APEX_JSON.WRITE('traffic_table_nuevo', Lv_CadenaVacia, TRUE);
                  APEX_JSON.WRITE('vlan_nuevo', Lv_CadenaVacia, TRUE);
                  APEX_JSON.CLOSE_OBJECT;
                  APEX_JSON.OPEN_ARRAY('datos_cliente');
                END IF;
                DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_VALIDAR_CAB_ID(
                  Lr_RegInfoServicioMiddleware.ID_CAB,
                  Lt_TRegsDataCabecerasPm,
                  Lv_Existe );
                IF Lv_Existe = 'NO' THEN
                  Lr_RegInfoDataCabecerasPm := NULL;
                  Lr_RegInfoDataCabecerasPm.ID_CAB := Lr_RegInfoServicioMiddleware.ID_CAB;
                  Lt_TRegsDataCabecerasPm(Lt_TRegsDataCabecerasPm.COUNT) := Lr_RegInfoDataCabecerasPm;
                END IF;
                APEX_JSON.OPEN_OBJECT;
                APEX_JSON.WRITE('puerto',               NVL(Lr_RegInfoServicioMiddleware.PUERTO, Lv_CadenaVacia),        TRUE);
                APEX_JSON.WRITE('ont_id',               NVL(Lr_RegInfoServicioMiddleware.CARACT_INDICE, Lv_CadenaVacia), TRUE);
                APEX_JSON.WRITE('spid',                 NVL(Lr_RegInfoServicioMiddleware.SPID, Lv_CadenaVacia),          TRUE);
                APEX_JSON.WRITE('service_profile',      NVL(Lr_RegInfoServicioMiddleware.SERVICE, Lv_CadenaVacia),       TRUE);
                APEX_JSON.WRITE('gemport',              NVL(Lr_RegInfoServicioMiddleware.GEMPORT, Lv_CadenaVacia),       TRUE);
                APEX_JSON.WRITE('vlan',                 NVL(Lr_RegInfoServicioMiddleware.VLAN, Lv_CadenaVacia),          TRUE);
                APEX_JSON.WRITE('traffic_table',        NVL(Lr_RegInfoServicioMiddleware.TRAFFIC, Lv_CadenaVacia),       TRUE);
                APEX_JSON.WRITE('line_profile',         NVL(Lr_RegInfoServicioMiddleware.PROFILE_NAME, Lv_CadenaVacia),  TRUE);
                APEX_JSON.WRITE('serie_ont',            NVL(Lr_RegInfoServicioMiddleware.SERIE_ONT, Lv_CadenaVacia),     TRUE);
                APEX_JSON.WRITE('mac_ont',              NVL(Lr_RegInfoServicioMiddleware.CARACT_MAC, Lv_CadenaVacia),    TRUE);
                APEX_JSON.WRITE('tipo_negocio_actual',  NVL(Lr_RegInfoServicioMiddleware.TIPO_NEGOCIO, Lv_CadenaVacia),  TRUE);
                APEX_JSON.WRITE('id_servicio',          NVL(Lr_RegInfoServicioMiddleware.SERVICIO_ID, 0),   TRUE);
                APEX_JSON.WRITE('login',                NVL(Lr_RegInfoServicioMiddleware.LOGIN, Lv_CadenaVacia),         TRUE);
                APEX_JSON.WRITE('proceso_det_id',       NVL(Lr_RegInfoServicioMiddleware.ID_DET, 0),        TRUE);
                APEX_JSON.WRITE('accion',               NVL(Lr_RegInfoServicioMiddleware.ACCION, Lv_CadenaVacia),        TRUE);
                APEX_JSON.WRITE('capacidad_up',         NVL(Lr_RegInfoServicioMiddleware.CAPACIDAD_UP, Lv_CadenaVacia),  TRUE);
                APEX_JSON.WRITE('capacidad_down',       NVL(Lr_RegInfoServicioMiddleware.CAPACIDAD_DOWN, Lv_CadenaVacia),       TRUE);
                APEX_JSON.WRITE('ip_fijas_activas',     NVL(Lr_RegInfoServicioMiddleware.IP_FIJAS_ADICIONALES, 0), TRUE);
                APEX_JSON.CLOSE_OBJECT;
                Ln_IndxRegListadoMiddleware  := Lt_TRegsInfoServicioMiddleware.NEXT(Ln_IndxRegListadoMiddleware);
              END LOOP;
              EXIT
            WHEN Lrf_RegistrosServicioMw%NOTFOUND;
            END LOOP;
            CLOSE Lrf_RegistrosServicioMw;
            IF Lv_OltAnterior != 'INICIO' THEN
              APEX_JSON.CLOSE_ARRAY;
              APEX_JSON.CLOSE_OBJECT;
              APEX_JSON.OPEN_ARRAY('idsPmCab');
              Ln_IndxRegDataCabecerasPm := Lt_TRegsDataCabecerasPm.FIRST;
              WHILE (Ln_IndxRegDataCabecerasPm IS NOT NULL)
              LOOP
                Lr_RegInfoDataCabecerasPm  := Lt_TRegsDataCabecerasPm(Ln_IndxRegDataCabecerasPm);
                APEX_JSON.WRITE(Lr_RegInfoDataCabecerasPm.Id_Cab);
                Ln_IndxRegDataCabecerasPm := Lt_TRegsDataCabecerasPm.NEXT(Ln_IndxRegDataCabecerasPm);
              END LOOP;
              APEX_JSON.CLOSE_ARRAY;
              APEX_JSON.WRITE('nombreOlt', Lv_OltAnterior, TRUE);
              APEX_JSON.WRITE('tipoProceso', Lv_TipoProceso, TRUE);
              APEX_JSON.WRITE('estado', 'EN_COLA', TRUE);
              APEX_JSON.WRITE('observacion', Lv_CadenaVacia, TRUE);
              APEX_JSON.OPEN_OBJECT('response');
              APEX_JSON.CLOSE_OBJECT;
              APEX_JSON.WRITE('prefijoEmpresa', Lv_EmpresaPrefijo, TRUE);
              APEX_JSON.CLOSE_OBJECT;
              Lt_TRegsDataCabecerasPm := Lt_TRegsDataCabecerasPmTmp;
            END IF;
          ELSE
            DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_CABECERAS_PM(
              Lcl_JsonResponseCab,
              Lv_EstadoPendiente,
              Lv_StatusReverso,
              Lv_MensajeReverso);
          END IF;
        ELSE
          DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_CABECERAS_PM(
            Lcl_JsonResponseCab,
            Lv_EstadoPendiente,
            Lv_StatusReverso,
            Lv_MensajeReverso);
        END IF;
      END IF;
    END IF;
    Pv_Status           := Lv_Status;
    Pv_Mensaje          := Lv_Mensaje;
    APEX_JSON.CLOSE_ARRAY;
    APEX_JSON.WRITE('cantidad', Ln_CantidadCab, TRUE);
    APEX_JSON.CLOSE_OBJECT;
    Pcl_JsonResponse    := REPLACE(APEX_JSON.GET_CLOB_OUTPUT,Lv_CadenaVacia,'');
    APEX_JSON.FREE_OUTPUT;
  EXCEPTION
  WHEN Le_Exception THEN
    Pcl_JsonResponse    := '{}';
    Pv_Status           := 'ERROR';
    Pv_Mensaje          := Lv_Mensaje;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
      'Telcos+', 
      'INKG_PROCESOS_MASIVOS.P_OBTENER_PM', 
      Lv_Mensaje, 
      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
      SYSDATE, 
      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pcl_JsonResponse    := '{}';
    Pv_Status           := 'ERROR';
    Lv_Mensaje          := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje          := 'No se ha podido realizar correctamente la consulta. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
      'Telcos+', 
      'INKG_PROCESOS_MASIVOS.P_OBTENER_PM',
      Lv_Mensaje, 
      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
      SYSDATE, 
      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTENER_PM;

  PROCEDURE P_PROCESAR_MW (
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_JsonResponse    OUT CLOB)
  AS
    Lv_NombreParametro      VARCHAR2(200)  := 'PARAMETROS_PROCESOS_MASIVOS_TELCOS';
    Lv_Datos                VARCHAR2(200)  := 'DATOS_MW';
    Lv_Estado               VARCHAR2(30)   := 'Activo';
    Lv_ValorUno             VARCHAR2(4000);
    Lcl_Headers             CLOB;
    Ln_CodeRequest          NUMBER;
    Lv_Aplicacion           VARCHAR2(50) := 'application/json';
    Lv_Charset              VARCHAR2(50) := 'UTF-8';
    Lv_UsuarioCreacion      VARCHAR2(20) := 'procesosmasivos';
    Lv_IpCreacion           VARCHAR2(20) := '127.0.0.1';
    Lv_Error                VARCHAR2(4000);
    Lv_EstadoWs             VARCHAR2(10);
    Le_Error                EXCEPTION;
    CURSOR C_OBTENERDATOS IS
      SELECT VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
          WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
      AND DESCRIPCION = Lv_Datos AND ROWNUM = 1;
  BEGIN
    OPEN C_OBTENERDATOS;
    FETCH C_OBTENERDATOS INTO Lv_ValorUno;
    CLOSE C_OBTENERDATOS;
    Pv_Status  := 'ERROR';
    Pv_Mensaje := 'Problemas al ejecutar el Ws de Middleware para ejecutar el procesamiento de clientes.';

    DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE_BR(Pv_Url             => Lv_ValorUno,
                                                 Pcl_Mensaje        => Pcl_JsonRequest,
                                                 Pv_Application     => Lv_Aplicacion,
                                                 Pv_Charset         => Lv_Charset,
                                                 Pv_UrlFileDigital  => NULL,
                                                 Pv_PassFileDigital => NULL,
                                                 Pcl_Respuesta      => Pcl_JsonResponse,
                                                 Pv_Error           => Lv_Error);
                  
    IF Lv_Error IS NOT NULL THEN
      Lv_EstadoWs := 'ERROR';
    ELSE
      Lv_EstadoWs := 'OK';
    END IF;

    IF Lv_EstadoWs = 'OK' AND INSTR(Pcl_JsonResponse, 'status') != 0 AND 
      INSTR(Pcl_JsonResponse, 'datos_cliente') != 0 AND INSTR(Pcl_JsonResponse, 'mensaje') != 0  THEN
      APEX_JSON.PARSE(Pcl_JsonResponse);
      Pv_Status  := APEX_JSON.GET_VARCHAR2(P_PATH => 'status');
      Pv_Mensaje := APEX_JSON.GET_VARCHAR2(P_PATH => 'mensaje');
    END IF;

    IF Pv_Status <> 'OK' THEN
      Pv_Mensaje := 'MENSAJE: '||Pv_Mensaje;
      RAISE Le_Error;
    END IF;

  EXCEPTION
  WHEN Le_Error THEN
    Pcl_JsonResponse := '{}';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_PROCESAR_MW',
                                         SUBSTR(Pv_Mensaje || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
  WHEN OTHERS THEN
    Pcl_JsonResponse := '{}';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_PROCESAR_MW',
                                         SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
  END P_PROCESAR_MW;

  PROCEDURE P_OBTENER_SERV_ADIC_PUNTO(
    Pn_PuntoId       IN NUMBER,
    Pv_Estado        IN VARCHAR2,
    Pv_OpIntProt     IN VARCHAR2,
    Prf_Registros    OUT SYS_REFCURSOR)
  AS
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_QueryExec                    CLOB;
    Lcl_Select                      CLOB;
    Lcl_Where                       CLOB;
    Lv_NombreParametro              VARCHAR2(50)  := 'SERVICIOS_ADICIONALES_FACTURAR';
    Lv_NombreTecnico                VARCHAR2(50)  := 'NOMBRE_TECNICO';
    Lv_NombreProducto               VARCHAR2(50)  := 'PRODUCTO';
    Lv_NombreParametroAmbiente      VARCHAR2(100) := 'ANTIVIRUS_PLANES_Y_PRODS_MD';
    Lv_TipoProceso                  VARCHAR2(10)  := 'MASIVO';
    Lv_Piloto                       VARCHAR2(10)  := 'PILOTO';
    Lv_Produccion                   VARCHAR2(15)  := 'PRODUCCION';
    Lv_NombreParametroLogines       VARCHAR2(30)  := 'LOGINES_PILOTO_KASPERSKY';
    Lv_CaractSuscriber              VARCHAR2(30)  := 'SUSCRIBER_ID';
    Lv_UsuarioCreacion              VARCHAR2(20)  := 'procesosmasivos';
    Lv_IpCreacion                   VARCHAR2(20)  := '127.0.0.1';
  BEGIN
    Lcl_Select      := 'SELECT DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO
                        FROM DB_COMERCIAL.INFO_SERVICIO, 
                         (SELECT ADMI_PRODUCTO.ID_PRODUCTO 
                         FROM DB_COMERCIAL.ADMI_PRODUCTO, 
                           (SELECT DESCRIPCION, 
                             VALOR1, 
                             VALOR2, 
                             EMPRESA_COD 
                           FROM DB_GENERAL.ADMI_PARAMETRO_DET 
                           WHERE PARAMETRO_ID = 
                            (SELECT ID_PARAMETRO 
                             FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
                             WHERE NOMBRE_PARAMETRO='''||Lv_NombreParametro||''' 
                             ) 
                           ) PRODUCTOSFACT 
                         WHERE ADMI_PRODUCTO.EMPRESA_COD        = PRODUCTOSFACT. EMPRESA_COD 
                         AND (PRODUCTOSFACT.DESCRIPCION         = '''||Lv_NombreTecnico||''' 
                         AND ADMI_PRODUCTO.NOMBRE_TECNICO       = PRODUCTOSFACT.VALOR2) 
                         OR (PRODUCTOSFACT.DESCRIPCION          = '''||Lv_NombreProducto||''' 
                         AND ADMI_PRODUCTO.DESCRIPCION_PRODUCTO = PRODUCTOSFACT.VALOR1 
                         AND ADMI_PRODUCTO.NOMBRE_TECNICO       = PRODUCTOSFACT.VALOR2) 
                        ) PRODUCTOS_MD 
                        WHERE INFO_SERVICIO.PRODUCTO_ID = PRODUCTOS_MD.ID_PRODUCTO 
                        AND INFO_SERVICIO.PUNTO_ID      = '||Pn_PuntoId||'
                        AND INFO_SERVICIO.ESTADO        = '''||Pv_Estado||''' ';
    Lcl_Where       :=  'AND NOT EXISTS (
                         SELECT PARAMETRO_CAB_AMBIENTE.ID_PARAMETRO 
                         FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAMETRO_CAB_AMBIENTE 
                         INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAMETRO_DET_AMBIENTE 
                         ON PARAMETRO_CAB_AMBIENTE.ID_PARAMETRO = PARAMETRO_DET_AMBIENTE.PARAMETRO_ID 
                         WHERE PARAMETRO_CAB_AMBIENTE.NOMBRE_PARAMETRO = '''||Lv_NombreParametroAmbiente||'''  
                         AND PARAMETRO_CAB_AMBIENTE.ESTADO = '''||Lv_EstadoActivo||''' 
                         AND PARAMETRO_DET_AMBIENTE.ESTADO = '''||Lv_EstadoActivo||''' 
                         AND PARAMETRO_DET_AMBIENTE.VALOR1 = '''||Lv_TipoProceso||''' 
                         AND (
                              (PARAMETRO_DET_AMBIENTE.VALOR6 = '''||Lv_Piloto||'''
                               AND EXISTS ( 
                                 SELECT PARAMETRO_CAB_LOGINES.ID_PARAMETRO 
                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAMETRO_CAB_LOGINES 
                                 INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAMETRO_DET_LOGINES 
                                 ON PARAMETRO_CAB_LOGINES.ID_PARAMETRO = PARAMETRO_DET_LOGINES.PARAMETRO_ID 
                                 INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO 
                                 ON PUNTO.LOGIN = PARAMETRO_DET_LOGINES.VALOR1 
                                 WHERE PUNTO.ID_PUNTO = INFO_SERVICIO.PUNTO_ID 
                                 AND PARAMETRO_CAB_LOGINES.NOMBRE_PARAMETRO = '''||Lv_NombreParametroLogines||''' 
                                 AND PARAMETRO_CAB_LOGINES.ESTADO = '''||Lv_EstadoActivo||''' 
                                 AND PARAMETRO_DET_LOGINES.ESTADO = '''||Lv_EstadoActivo||''' 
                                 AND PARAMETRO_DET_LOGINES.VALOR2 = '''||Lv_TipoProceso||''' 
                                 AND PARAMETRO_DET_LOGINES.VALOR1 = PUNTO.LOGIN)) 
                              OR 
                              (PARAMETRO_DET_AMBIENTE.VALOR6 = '''||Lv_Produccion||''') 
                              ) ';
    IF Pv_OpIntProt = 'cortarLicencias' THEN
      Lcl_Where       :=  Lcl_Where || ' AND EXISTS (
                            SELECT SPC.ID_SERVICIO_PROD_CARACT
                            FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC 
                            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC 
                            ON APC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID 
                            INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT 
                            ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID 
                            WHERE SPC.SERVICIO_ID = ID_SERVICIO 
                            AND APC.PRODUCTO_ID = PRODUCTO_ID 
                            AND CARACT.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractSuscriber||''' 
                            AND SPC.ESTADO = '''||Lv_EstadoActivo||''' 
                            AND APC.ESTADO = '''||Lv_EstadoActivo||''' ) 
                            )';
    END IF;
    Lv_QueryExec := Lcl_Select || Lcl_Where;
    OPEN Prf_Registros FOR Lv_QueryExec;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_OBTENER_SERV_ADIC_PUNTO',
                                         SUBSTR('Pn_PuntoId: '||Pn_PuntoId||SQLCODE || ' -ERROR- ' || SQLERRM ,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
  END P_OBTENER_SERV_ADIC_PUNTO;

  PROCEDURE P_RECUPERA_SERV_ADIC_INT_PRO(
    Pn_PuntoId           IN NUMBER,
    Pv_Estado            IN VARCHAR2,
    Pv_Descripcion       IN VARCHAR2,
    Pv_LikeDescripcion   IN VARCHAR2,
    Pv_DescCaractServ    IN VARCHAR2,
    Prf_Registros        OUT SYS_REFCURSOR)
  AS
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_QueryExec                    CLOB;
    Lv_UsuarioCreacion              VARCHAR2(20)  := 'procesosmasivos';
    Lv_IpCreacion                   VARCHAR2(20)  := '127.0.0.1';
  BEGIN
    Lv_QueryExec := 'SELECT DISTINCT SERVICIO.ID_SERVICIO, SERVICIO.ESTADO AS ESTADO_SERVICIO, 
                      PRODUCTO.ID_PRODUCTO, PRODUCTO.DESCRIPCION_PRODUCTO, ''PRODUCTO'' AS TIPO_SERVICIO 
                      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO 
                      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO 
                      ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                      WHERE SERVICIO.PUNTO_ID = '''||Pn_PuntoId||'''
                      AND SERVICIO.ESTADO = '''||Pv_Estado||'''  ';
    IF Pv_Descripcion IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || ' AND PRODUCTO.DESCRIPCION_PRODUCTO = '''||Pv_Descripcion||''' ';
    END IF;
    IF Pv_LikeDescripcion IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '  AND PRODUCTO.DESCRIPCION_PRODUCTO LIKE '''||Pv_LikeDescripcion||'%''  ';
    END IF;
    IF Pv_DescCaractServ IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '  AND EXISTS ( 
                                          SELECT SPC.ID_SERVICIO_PROD_CARACT 
                                          FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC 
                                          INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC 
                                          ON APC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID 
                                          INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT 
                                          ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID 
                                          WHERE SPC.SERVICIO_ID = SERVICIO.ID_SERVICIO 
                                          AND SPC.ESTADO = '''||Lv_EstadoActivo||''' 
                                          AND APC.PRODUCTO_ID = PRODUCTO.ID_PRODUCTO 
                                          AND CARACT.DESCRIPCION_CARACTERISTICA = '''||Pv_DescCaractServ||''' 
                                          AND APC.ESTADO = '''||Lv_EstadoActivo||''' ) ';
    END IF;
    OPEN Prf_Registros FOR Lv_QueryExec;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_RECUPERA_SERV_ADIC_INT_PRO',
                                         SUBSTR('Pn_PuntoId: '||Pn_PuntoId||SQLCODE || ' -ERROR- ' || SQLERRM ,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
  END P_RECUPERA_SERV_ADIC_INT_PRO;

  PROCEDURE P_RECUPERA_SERV_ADIC_KONIBIT(
    Pn_PuntoId           IN NUMBER,
    Pv_Estado            IN VARCHAR2,
    Pv_Descripcion       IN VARCHAR2,
    Pv_LikeDescripcion   IN VARCHAR2,
    Pv_DescCaractServ    IN VARCHAR2,
    Prf_Registros        OUT SYS_REFCURSOR)
  AS
    Lv_EstadoActivo    VARCHAR2(6) := 'Activo';
    Lv_QueryExec       CLOB;
    Lv_UsuarioCreacion VARCHAR2(20)  := 'procesosmasivos';
    Lv_IpCreacion      VARCHAR2(20)  := '127.0.0.1';
  BEGIN
    Lv_QueryExec := 'SELECT DISTINCT SERVICIO.ID_SERVICIO, SERVICIO.ESTADO AS ESTADO_SERVICIO, 
                      PRODUCTO.ID_PRODUCTO, PRODUCTO.DESCRIPCION_PRODUCTO, ''PRODUCTO'' AS TIPO_SERVICIO 
                      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO 
                      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO 
                      ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                      WHERE SERVICIO.PUNTO_ID = '''||Pn_PuntoId||'''
                      AND SERVICIO.ESTADO = '''||Pv_Estado||'''  ';
    IF Pv_Descripcion IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || ' AND PRODUCTO.DESCRIPCION_PRODUCTO = '''||Pv_Descripcion||''' ';
    END IF;
    IF Pv_LikeDescripcion IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '  AND PRODUCTO.DESCRIPCION_PRODUCTO LIKE '''||Pv_LikeDescripcion||'%''  ';
    END IF;
    IF Pv_DescCaractServ IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '  AND EXISTS ( 
                                         SELECT 1
                                         FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
                                         DB_COMERCIAL.ADMI_CARACTERISTICA AC
                                         WHERE APC.PRODUCTO_ID             = PRODUCTO.ID_PRODUCTO
                                         AND AC.ID_CARACTERISTICA          = APC.CARACTERISTICA_ID
                                         AND APC.ESTADO                    = '''||Lv_EstadoActivo||'''
                                         AND AC.ESTADO                     = '''||Lv_EstadoActivo||'''
                                         AND AC.DESCRIPCION_CARACTERISTICA = '''||Pv_DescCaractServ||''') ';
    END IF;
    OPEN Prf_Registros FOR Lv_QueryExec;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_RECUPERA_SERV_ADIC_KONIBIT',
                                         SUBSTR('Pn_PuntoId: '||Pn_PuntoId||SQLCODE || ' -ERROR- ' || SQLERRM ,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
  END P_RECUPERA_SERV_ADIC_KONIBIT;

  PROCEDURE P_RECUPERA_SERV_PLAN_INT_PRO(
    Pn_IdServicio             IN NUMBER,
    Pv_Descripcion            IN VARCHAR2,
    Pv_LikeDescripcion        IN VARCHAR2,
    Pv_NombreTecnicoProducto  IN VARCHAR2,
    Pv_DescCaractServ         IN VARCHAR2,
    Prf_Registros             OUT SYS_REFCURSOR)
  AS
    Lv_EstadoActivo                 VARCHAR2(6)  := 'Activo';
    Lv_EstadoEliminado              VARCHAR2(10) := 'Eliminado';
    Lv_Proceso                      VARCHAR2(10) := 'MASIVO';
    Lv_AmbientePiloto               VARCHAR2(10) := 'PILOTO';
    LV_AmbienteProduccion           VARCHAR2(15) := 'PRODUCCION';
    Lv_QueryExec                    CLOB;
    Lv_UsuarioCreacion              VARCHAR2(20)  := 'procesosmasivos';
    Lv_IpCreacion                   VARCHAR2(20)  := '127.0.0.1';
    Lv_NombreParametro              VARCHAR2(30)  := ';ANTIVIRUS_PLANES_Y_PRODS_MD';
    Lv_NombreParametroKasper        VARCHAR2(30)  := 'LOGINES_PILOTO_KASPERSKY';
  BEGIN
    Lv_QueryExec    := 'SELECT DISTINCT SERVICIO.ID_SERVICIO, SERVICIO.ESTADO AS ESTADO_SERVICIO, 
                        PRODUCTO.ID_PRODUCTO, PRODUCTO.DESCRIPCION_PRODUCTO, ''PLAN'' AS TIPO_SERVICIO 
                        FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO 
                        INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB 
                        ON PLAN_CAB.ID_PLAN = SERVICIO.PLAN_ID 
                        INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET 
                        ON PLAN_DET.PLAN_ID = PLAN_CAB.ID_PLAN 
                        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO 
                        ON PRODUCTO.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID 
                        WHERE SERVICIO.ID_SERVICIO = '''||Pn_IdServicio||''' 
                        AND PLAN_DET.ESTADO <> '''||Lv_EstadoEliminado||'''  
                        AND EXISTS (
                            SELECT PARAMETRO_CAB_AMBIENTE.ID_PARAMETRO 
                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAMETRO_CAB_AMBIENTE 
                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAMETRO_DET_AMBIENTE 
                            ON PARAMETRO_CAB_AMBIENTE.ID_PARAMETRO = PARAMETRO_DET_AMBIENTE.PARAMETRO_ID 
                            WHERE PARAMETRO_CAB_AMBIENTE.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' 
                            AND PARAMETRO_CAB_AMBIENTE.ESTADO = '''||Lv_EstadoActivo||''' 
                            AND PARAMETRO_DET_AMBIENTE.ESTADO = '''||Lv_EstadoActivo||''' 
                            AND PARAMETRO_DET_AMBIENTE.VALOR1 = '''||Lv_Proceso||''' 
                            AND (
                                 (PARAMETRO_DET_AMBIENTE.VALOR6 = '''||Lv_AmbientePiloto||''' 
                                  AND EXISTS ( 
                                    SELECT PARAMETRO_CAB_LOGINES.ID_PARAMETRO 
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAMETRO_CAB_LOGINES 
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAMETRO_DET_LOGINES 
                                    ON PARAMETRO_CAB_LOGINES.ID_PARAMETRO = PARAMETRO_DET_LOGINES.PARAMETRO_ID 
                                    INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO 
                                    ON PUNTO.LOGIN = PARAMETRO_DET_LOGINES.VALOR1 
                                    WHERE PUNTO.ID_PUNTO = SERVICIO.PUNTO_ID 
                                    AND PARAMETRO_CAB_LOGINES.NOMBRE_PARAMETRO = '''||Lv_NombreParametroKasper||''' 
                                    AND PARAMETRO_CAB_LOGINES.ESTADO = '''||Lv_EstadoActivo||''' 
                                    AND PARAMETRO_DET_LOGINES.ESTADO = '''||Lv_EstadoActivo||''' 
                                    AND PARAMETRO_DET_LOGINES.VALOR2 = '''||Lv_Proceso||''' 
                                    AND PARAMETRO_DET_LOGINES.VALOR1 = PUNTO.LOGIN)) 
                                 OR 
                                 (PARAMETRO_DET_AMBIENTE.VALOR6 = '''||LV_AmbienteProduccion||''') 
                                 )
                         ) ';
    IF Pv_Descripcion IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || ' AND PRODUCTO.DESCRIPCION_PRODUCTO = '''||Pv_Descripcion||''' ';
    END IF;
    IF Pv_LikeDescripcion IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '  AND PRODUCTO.DESCRIPCION_PRODUCTO LIKE '''||Pv_LikeDescripcion||'%''  ';
    END IF;
    IF Pv_DescCaractServ IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '  AND EXISTS ( 
                                          SELECT SPC.ID_SERVICIO_PROD_CARACT 
                                          FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC 
                                          INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC 
                                          ON APC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID 
                                          INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT 
                                          ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID 
                                          WHERE SPC.SERVICIO_ID = SERVICIO.ID_SERVICIO 
                                          AND SPC.ESTADO = '''||Lv_EstadoActivo||''' 
                                          AND APC.PRODUCTO_ID = PRODUCTO.ID_PRODUCTO 
                                          AND CARACT.DESCRIPCION_CARACTERISTICA = '''||Pv_DescCaractServ||''' 
                                          AND APC.ESTADO = '''||Lv_EstadoActivo||''' ) ';
    END IF;
    OPEN Prf_Registros FOR Lv_QueryExec;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_RECUPERA_SERV_PLAN_INT_PRO',
                                         SUBSTR('Pn_IdServicio: '||Pn_IdServicio||' - '||SQLCODE || ' -ERROR- ' || SQLERRM ,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
  END P_RECUPERA_SERV_PLAN_INT_PRO;

  PROCEDURE P_RECUPERA_SERV_PLAN_KONIBIT (
    Pn_IdServicio             IN NUMBER,
    Pv_Descripcion            IN VARCHAR2,
    Pv_LikeDescripcion        IN VARCHAR2,
    Pv_NombreTecnicoProducto  IN VARCHAR2,
    Pv_DescCaractServ         IN VARCHAR2,
    Prf_Registros             OUT SYS_REFCURSOR)
  AS
    Lv_EstadoActivo    VARCHAR2(6)  := 'Activo';
    Lv_EstadoEliminado VARCHAR2(10) := 'Eliminado';
    Lv_QueryExec       CLOB;
    Lv_UsuarioCreacion VARCHAR2(20) := 'procesosmasivos';
    Lv_IpCreacion      VARCHAR2(20) := '127.0.0.1';
  BEGIN
    Lv_QueryExec    := 'SELECT DISTINCT SERVICIO.ID_SERVICIO, SERVICIO.ESTADO AS ESTADO_SERVICIO, 
                        PRODUCTO.ID_PRODUCTO, PRODUCTO.DESCRIPCION_PRODUCTO, ''PLAN'' AS TIPO_SERVICIO 
                        FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO 
                        INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB 
                        ON PLAN_CAB.ID_PLAN = SERVICIO.PLAN_ID 
                        INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET 
                        ON PLAN_DET.PLAN_ID = PLAN_CAB.ID_PLAN 
                        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO 
                        ON PRODUCTO.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID 
                        WHERE SERVICIO.ID_SERVICIO = '''||Pn_IdServicio||''' 
                        AND PLAN_DET.ESTADO <> '''||Lv_EstadoEliminado||''' ';
    IF Pv_Descripcion IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || ' AND PRODUCTO.DESCRIPCION_PRODUCTO = '''||Pv_Descripcion||''' ';
    END IF;
    IF Pv_LikeDescripcion IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '  AND PRODUCTO.DESCRIPCION_PRODUCTO LIKE '''||Pv_LikeDescripcion||'%''  ';
    END IF;
    IF Pv_NombreTecnicoProducto IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '   AND PRODUCTO.NOMBRE_TECNICO = '''||Pv_NombreTecnicoProducto||'%''  ';
    END IF;
    IF Pv_DescCaractServ IS NOT NULL THEN
      Lv_QueryExec := Lv_QueryExec || '  AND EXISTS ( 
                                         SELECT 1
                                         FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
                                         DB_COMERCIAL.ADMI_CARACTERISTICA AC
                                         WHERE APC.PRODUCTO_ID             = PRODUCTO.ID_PRODUCTO
                                         AND AC.ID_CARACTERISTICA          = APC.CARACTERISTICA_ID
                                         AND APC.ESTADO                    = '''||Lv_EstadoActivo||'''
                                         AND AC.ESTADO                     = '''||Lv_EstadoActivo||'''
                                         AND AC.DESCRIPCION_CARACTERISTICA = '''||Pv_DescCaractServ||''') ';
    END IF;
    OPEN Prf_Registros FOR Lv_QueryExec;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_RECUPERA_SERV_PLAN_KONIBIT',
                                         SUBSTR('Pn_IdServicio: '||Pn_IdServicio||' - '||SQLCODE || ' -ERROR- ' || SQLERRM ,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
  END P_RECUPERA_SERV_PLAN_KONIBIT;

  PROCEDURE P_ACTUALIZAR_SERVICIOS_PUNTO(
    Pv_Estado_Nuevo     IN VARCHAR2,
    Pv_Estado_Actual    IN VARCHAR2,
    Pv_OpIntProt        IN VARCHAR2,
    Pn_Punto_Id         IN NUMBER,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2)
  AS
    Lv_EstadoActivo                 VARCHAR2(9)  := 'Activo';
    Lv_QueryExec                    CLOB;
    Lv_Mensaje                      VARCHAR2(4000) := 'Error al actualizar detalle';
    Lv_NombreParametroAmbiente      VARCHAR2(100) := 'ANTIVIRUS_PLANES_Y_PRODS_MD';
    Lv_TipoProceso                  VARCHAR2(10)  := 'MASIVO';
    Lv_Piloto                       VARCHAR2(10)  := 'PILOTO';
    Lv_Produccion                   VARCHAR2(15)  := 'PRODUCCION';
    Lv_NombreParametroLogines       VARCHAR2(30)  := 'LOGINES_PILOTO_KASPERSKY';
    Lv_CaractSuscriber              VARCHAR2(30)  := 'SUSCRIBER_ID';
  BEGIN
    Lv_QueryExec := 'UPDATE DB_COMERCIAL.INFO_SERVICIO SET ESTADO = '''||Pv_Estado_Nuevo||''' WHERE PUNTO_ID = '''||
                    Pn_Punto_Id||''' and ESTADO = '''||Pv_Estado_Actual||''' ';
    IF Pv_OpIntProt = 'cortarLicencias' THEN
      Lv_QueryExec :=  Lv_QueryExec || '  AND ( 
						  (PRODUCTO_ID IS NULL) 
						   OR 
						  (PRODUCTO_ID IS NOT NULL 
						   AND 
						 (
						  NOT EXISTS (
						    SELECT PARAMETRO_CAB_AMBIENTE.ID_PARAMETRO 
						    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAMETRO_CAB_AMBIENTE 
						    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAMETRO_DET_AMBIENTE 
						    ON PARAMETRO_CAB_AMBIENTE.ID_PARAMETRO = PARAMETRO_DET_AMBIENTE.PARAMETRO_ID 
						    WHERE PARAMETRO_CAB_AMBIENTE.NOMBRE_PARAMETRO = '''||Lv_NombreParametroAmbiente||''' 
						    AND PARAMETRO_CAB_AMBIENTE.ESTADO = '''||Lv_EstadoActivo||''' 
						    AND PARAMETRO_DET_AMBIENTE.ESTADO = '''||Lv_EstadoActivo||''' 
						    AND PARAMETRO_DET_AMBIENTE.VALOR1 = '''||Lv_TipoProceso||''' 
						    AND (
						         (PARAMETRO_DET_AMBIENTE.VALOR6 = '''||Lv_Piloto||''' 
						          AND EXISTS ( 
						            SELECT PARAMETRO_CAB_LOGINES.ID_PARAMETRO 
						            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAMETRO_CAB_LOGINES 
						            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAMETRO_DET_LOGINES 
						            ON PARAMETRO_CAB_LOGINES.ID_PARAMETRO = PARAMETRO_DET_LOGINES.PARAMETRO_ID 
						            INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO 
						            ON PUNTO.LOGIN = PARAMETRO_DET_LOGINES.VALOR1 
						            WHERE PUNTO.ID_PUNTO = PUNTO_ID 
						            AND PARAMETRO_CAB_LOGINES.NOMBRE_PARAMETRO = '''||Lv_NombreParametroLogines||''' 
						            AND PARAMETRO_CAB_LOGINES.ESTADO = '''||Lv_EstadoActivo||''' 
						            AND PARAMETRO_DET_LOGINES.ESTADO = '''||Lv_EstadoActivo||''' 
						            AND PARAMETRO_DET_LOGINES.VALOR2 = '''||Lv_TipoProceso||''' 
						            AND PARAMETRO_DET_LOGINES.VALOR1 = PUNTO.LOGIN)) 
						         OR 
						         (PARAMETRO_DET_AMBIENTE.VALOR6 = '''||Lv_Produccion||''') 
						        )
						  AND EXISTS (
						    SELECT SPC.ID_SERVICIO_PROD_CARACT 
						    FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC 
						    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC 
						    ON APC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID 
						    INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT 
						    ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID 
						    WHERE SPC.SERVICIO_ID = ID_SERVICIO 
						    AND APC.PRODUCTO_ID = PRODUCTO_ID 
						    AND CARACT.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractSuscriber||''' 
						    AND SPC.ESTADO = '''||Lv_EstadoActivo||''' 
						    AND APC.ESTADO = '''||Lv_EstadoActivo||''' ) 
						    )
						  )
						  )
						 )';
    END IF;
    EXECUTE IMMEDIATE  Lv_QueryExec;
    Pv_Status   := 'OK';
    Pv_Mensaje  := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Lv_Mensaje      := 'Pn_Punto_Id: '||Pn_Punto_Id||' Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se han podido actualizar correctamente los servicios del punto. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_SERVICIOS_PUNTO',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZAR_SERVICIOS_PUNTO;

  PROCEDURE P_ACTUALIZAR_DETALLE_PM(
    Pv_Estado           IN VARCHAR2,
    Pv_Usuario          IN VARCHAR2,
    Pv_Observacion      IN VARCHAR2,
    Pn_IpDetPm          IN NUMBER ,
    Pn_PuntoId          IN NUMBER,
    Pn_CantidadIntentos IN NUMBER,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2)
  AS
    Lv_Mensaje VARCHAR2(4000) := 'Error al actualizar detalle';
  BEGIN
    EXECUTE IMMEDIATE 'UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET SET ESTADO = :v1, ' || 
                      'USR_ULT_MOD = :v2, FE_ULT_MOD = :v3, OBSERVACION = :v4, CANTIDAD_INTENTOS= NVL(:V5, CANTIDAD_INTENTOS) ' ||
                      'WHERE ID_PROCESO_MASIVO_DET = :v6 AND PUNTO_ID = :v7 '
    USING Pv_Estado, Pv_Usuario, SYSDATE, Pv_Observacion, Pn_CantidadIntentos, Pn_IpDetPm, Pn_PuntoId;
    Pv_Status   := 'OK';
    Pv_Mensaje  := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Lv_Mensaje      := 'Pn_PuntoId : '||Pn_PuntoId||' Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se han podido actualizar correctamente los detalles de procesos masivos. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_DETALLE_PM',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZAR_DETALLE_PM;

  PROCEDURE P_EJECUTA_PROCESO_LOGICO(
    Pn_IdServicio          IN NUMBER,
    Pv_TipoServicio        IN VARCHAR2,
    Pv_Accion              IN VARCHAR2,
    Pv_EstadoServicio      IN VARCHAR2,
    Pv_ObservacionHist     IN VARCHAR2,
    Pb_RequiereCaract      IN BOOLEAN,
    Pn_IdProducto          IN NUMBER,
    Pv_DescripcionCaract   IN VARCHAR2,
    Pv_Valor               IN VARCHAR2)
  AS
  Lv_UsuarioCreacion      VARCHAR2(20) := 'procesosmasivos';
  Lv_IpCreacion           VARCHAR2(20) := '127.0.0.1';
  Lv_AccionTmp            VARCHAR2(20) := '';
  Lv_EstadoActivo         VARCHAR2(20) := 'Activo';
  Lv_Mensaje              VARCHAR2(4000) := 'Activo';
  BEGIN
    IF Pv_TipoServicio = 'PRODUCTO' THEN
      EXECUTE IMMEDIATE 'UPDATE DB_COMERCIAL.INFO_SERVICIO SET ESTADO = :V1 WHERE ID_SERVICIO = :V2  '
      USING Pv_EstadoServicio, Pn_IdServicio;
      Lv_AccionTmp := Pv_Accion;
    END IF;
    EXECUTE IMMEDIATE 'INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL(ID_SERVICIO_HISTORIAL, 
                       SERVICIO_ID, ACCION, ESTADO, OBSERVACION, USR_CREACION, FE_CREACION, IP_CREACION) 
				               SELECT DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, :v1, :v2, :v3, :v4, :v5, :v6, :v7 FROM DUAL '                      
    USING Pn_IdServicio, Lv_AccionTmp, Pv_EstadoServicio, Pv_ObservacionHist, Lv_UsuarioCreacion, SYSDATE, Lv_IpCreacion;
    IF Pb_RequiereCaract = TRUE THEN
      EXECUTE IMMEDIATE 'INSERT INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT(ID_SERVICIO_PROD_CARACT, 
                          SERVICIO_ID, PRODUCTO_CARACTERISITICA_ID, VALOR, FE_CREACION, USR_CREACION, ESTADO) 
                          SELECT DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL, 
                          :v1, 
                          (SELECT ID_PRODUCTO_CARACTERISITICA 
                           FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC 
                           INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACTERISTICA 
                           ON CARACTERISTICA.ID_CARACTERISTICA = APC.CARACTERISTICA_ID 
                           WHERE APC.ESTADO = :v2 
                           AND APC.PRODUCTO_ID = :v3 
                           AND CARACTERISTICA.DESCRIPCION_CARACTERISTICA = :v4 
                           AND ROWNUM = 1 
                           ), 
                           :v5, :v6, :v7, :v8 FROM DUAL '
      USING Pn_IdServicio, Lv_EstadoActivo, Pn_IdProducto, Pv_DescripcionCaract, Pv_Valor, SYSDATE, Lv_UsuarioCreacion, Lv_EstadoActivo;
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_Mensaje      := 'Pn_IdServicio : '||Pn_IdServicio||' Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' ||
                       DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_Ejecuta_Proceso_Logico',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_EJECUTA_PROCESO_LOGICO;

  PROCEDURE P_GESTIONAR_SERV_INT_PROT(
    Pn_PuntoId      IN NUMBER,
    Pn_IdServicio   IN NUMBER,
    Pv_OpIntProt    IN VARCHAR2,
    Pv_Status       OUT VARCHAR2,
    Pv_Mensaje      OUT VARCHAR2)
  AS
    Lv_Mensaje                       VARCHAR2(4000):= 'Error al actualizar detalle';
    Lb_IngresaHistoError             BOOLEAN       := FALSE;
    Lv_MensajeHistoError             VARCHAR2(300) := '';
    Lv_TipoProceso                   VARCHAR2(30)  := '';
    Lv_EstadoActualServAdi           VARCHAR2(10)  := '';
    Lv_EstadoNuevoServAdi            VARCHAR2(10)  := '';
    Lv_ObsHistoServErrorToken        VARCHAR2(300) := '';
    Lv_ObsHistoServErrorWs           VARCHAR2(300) := '';
    Lv_ObservacionProcesoLogico      VARCHAR2(300) := '';
    Lv_DescCaractProcesoLogico       VARCHAR2(100) := '';
    Lv_AccionProcesoLogico           VARCHAR2(50)  := '';
    Lv_DescripcionProducto           VARCHAR2(100) := '';
    Lv_LikeDescripcionProducto       VARCHAR2(25)  := NULL;
    Lv_DescCaracServicio             VARCHAR2(25)  := '';
    Lv_EstadoActivo                  VARCHAR2(10)  := 'Activo';
    Lv_EstadoInCorte                 VARCHAR2(10)  := 'In-Corte';
    Lrf_RegistrosServAdicPto         SYS_REFCURSOR;
    Lrf_RegistrosServPlanPto         SYS_REFCURSOR;
    Lr_RegDataServiciosAdicPunto     DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LR_DATASERVICIOSADICPUNTO;
    Lt_TableServiciosAdicPunto       DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATASERVICIOSADICPUNTO;
    Ln_IndxDataServiciosPunto        NUMBER := 0;
    Lt_TableServiciosPunto           DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATASERVICIOSADICPUNTO;
    Lv_Gateway              VARCHAR2(30)   := 'Telcos';
    Lv_Token                VARCHAR2(200)  := '';
    Lv_User                 VARCHAR2(30);
    Lv_Url                  VARCHAR2(300);
    Lv_Opcion               VARCHAR2(100);
    Lv_Service              VARCHAR2(30);
    Lv_Method               VARCHAR2(30);
    Lv_UrlToken             VARCHAR2(300);
    Lv_Name                 VARCHAR2(30);
    Lv_OriginId             VARCHAR2(30);
    Lv_TipoOriginId         VARCHAR2(30);
    Lv_NombreParametro      VARCHAR2(200)  := 'PARAMETROS_PROCESOS_MASIVOS_TELCOS';
    Lv_DatosToken           VARCHAR2(200)  := 'DATOS_WS_TOKEN';
    Lv_DatosTelcos          VARCHAR2(200)  := 'DATOS_WS_TELCOS';
    Lcl_Headers             CLOB;
    Lcl_Request             CLOB;
    Lcl_Response            CLOB;
    Lcl_ResponseToken       CLOB;
    Lcl_ResponseServicios   CLOB;
    Ln_CodeRequest          NUMBER;
    Ln_CodeRequestToken     NUMBER;
    Ln_StatusToken          NUMBER;
    Lv_Aplicacion           VARCHAR2(50) := 'application/json';
    Lv_UsuarioCreacion      VARCHAR2(20) := 'procesosmasivos';
    Lv_IpCreacion           VARCHAR2(20) := '127.0.0.1';
    Lv_MsgResult            VARCHAR2(4000);
    CURSOR C_OBTENERDATOSTOKEN IS
      SELECT VALOR1, VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7 FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE ESTADO = Lv_EstadoActivo AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
          WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_EstadoActivo AND ROWNUM = 1)
       AND DESCRIPCION = Lv_DatosToken AND ROWNUM = 1;
    CURSOR C_OBTENERDATOSTELCOS IS
      SELECT VALOR1, VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE ESTADO = Lv_EstadoActivo AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
          WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_EstadoActivo AND ROWNUM = 1)
      AND DESCRIPCION = Lv_DatosTelcos AND ROWNUM = 1;
  BEGIN
    Pv_Status  := 'OK';
    Pv_Mensaje := '';
    IF Pv_OpIntProt = 'cortarLicencias' THEN
      Lv_AccionProcesoLogico      := 'cortarCliente';
      Lv_TipoProceso              := 'CORTE MASIVO';
      Lv_EstadoActualServAdi      := Lv_EstadoActivo;
      Lv_EstadoNuevoServAdi       := Lv_EstadoInCorte;                                
      Lv_ObsHistoServErrorToken   := 'Internet Protegido no pudo ser cortado ya que existieron problemas al generar Token';
      Lv_ObsHistoServErrorWs      := 'Internet Protegido no pudo ser cortado ya que existieron problemas al ejecutar el web service';
      Lv_ObservacionProcesoLogico := 'Se ha realizado el corte del Internet Protegido de manera l�gica';
      Lv_DescCaractProcesoLogico  := 'ERROR_CORTE_INTERNET_PROTEGIDO';
      Lv_DescripcionProducto      := 'I. PROTEGIDO MULTI PAID';
      Lv_DescCaracServicio        := 'SUSCRIBER_ID';
    END IF;
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_RECUPERA_SERV_ADIC_INT_PRO(
      Pn_PuntoId,
      Lv_EstadoActualServAdi,
      Lv_DescripcionProducto,
      Lv_LikeDescripcionProducto,
      Lv_DescCaracServicio,
      Lrf_RegistrosServAdicPto);
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_RECUPERA_SERV_PLAN_INT_PRO(
      Pn_IdServicio,
      Lv_DescripcionProducto,
      Lv_LikeDescripcionProducto,
      NULL,
      Lv_DescCaracServicio,
      Lrf_RegistrosServPlanPto);
    LOOP
      FETCH Lrf_RegistrosServAdicPto BULK COLLECT
      INTO Lt_TableServiciosAdicPunto LIMIT 10;
      Ln_IndxDataServiciosPunto := Lt_TableServiciosAdicPunto.FIRST;
      WHILE (Ln_IndxDataServiciosPunto IS NOT NULL)
      LOOP
        Lr_RegDataServiciosAdicPunto  := Lt_TableServiciosAdicPunto(Ln_IndxDataServiciosPunto);
        Lt_TableServiciosPunto(Lt_TableServiciosPunto.COUNT) := Lr_RegDataServiciosAdicPunto;
        Ln_IndxDataServiciosPunto := Lt_TableServiciosAdicPunto.NEXT(Ln_IndxDataServiciosPunto);
      END LOOP;
      EXIT WHEN Lrf_RegistrosServAdicPto%NOTFOUND;
    END LOOP;
    CLOSE Lrf_RegistrosServAdicPto;
    LOOP
      FETCH Lrf_RegistrosServPlanPto BULK COLLECT
      INTO Lt_TableServiciosAdicPunto LIMIT 10;
      Ln_IndxDataServiciosPunto := Lt_TableServiciosAdicPunto.FIRST;
      WHILE (Ln_IndxDataServiciosPunto IS NOT NULL)
      LOOP
        Lr_RegDataServiciosAdicPunto  := Lt_TableServiciosAdicPunto(Ln_IndxDataServiciosPunto);
        Lt_TableServiciosPunto(Lt_TableServiciosPunto.COUNT) := Lr_RegDataServiciosAdicPunto;
        Ln_IndxDataServiciosPunto := Lt_TableServiciosAdicPunto.NEXT(Ln_IndxDataServiciosPunto);
      END LOOP;
      EXIT WHEN Lrf_RegistrosServPlanPto%NOTFOUND;
    END LOOP;
    CLOSE Lrf_RegistrosServPlanPto;
    IF Lt_TableServiciosPunto.COUNT > 0 THEN
      OPEN C_OBTENERDATOSTOKEN;
      FETCH C_OBTENERDATOSTOKEN INTO Lv_Name, Lv_Service, Lv_Method, Lv_User, Lv_UrlToken, Lv_OriginId, Lv_TipoOriginId;
      CLOSE C_OBTENERDATOSTOKEN;
      OPEN C_OBTENERDATOSTELCOS;
      FETCH C_OBTENERDATOSTELCOS INTO Lv_Url, Lv_Opcion;
      CLOSE C_OBTENERDATOSTELCOS;
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.OPEN_OBJECT('headers');
      APEX_JSON.WRITE('Content-Type', Lv_Aplicacion);
      APEX_JSON.WRITE('Accept', Lv_Aplicacion);
      APEX_JSON.CLOSE_OBJECT;
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
      Lcl_Request := '{
                          "user": "' || Lv_User || '",
                          "gateway": "' || Lv_Gateway || '",
                          "service": "' || Lv_Service || '",
                          "method": "' || Lv_Method || '",
                          "source": {
                              "name": "' || Lv_Name || '",
                              "originID": "' || Lv_OriginId || '",
                              "tipoOriginID": "' || Lv_TipoOriginId || '"
                          }
                        }';
      Ln_StatusToken  := 500;
      Lv_MsgResult    := 'Problemas al generar el Token.';
      DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_UrlToken,Lcl_Headers,Lcl_Request,Ln_CodeRequestToken,Lv_MsgResult,Lcl_ResponseToken);
      IF Ln_CodeRequestToken = 0 AND INSTR(Lcl_ResponseToken, 'status') != 0 AND INSTR(Lcl_ResponseToken, 'message') != 0
        AND INSTR(Lcl_ResponseToken, 'token') != 0 THEN
          APEX_JSON.PARSE(Lcl_ResponseToken);
          Ln_StatusToken  := APEX_JSON.GET_NUMBER(P_PATH => 'status');
          Lv_MsgResult    := APEX_JSON.GET_VARCHAR2(P_PATH => 'message');
          Lv_Token        := APEX_JSON.GET_VARCHAR2(P_PATH => 'token');
      END IF;
      IF Ln_StatusToken = 200 THEN
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_ARRAY();
        Ln_IndxDataServiciosPunto := Lt_TableServiciosPunto.FIRST;
        WHILE (Ln_IndxDataServiciosPunto IS NOT NULL)
        LOOP
          Lr_RegDataServiciosAdicPunto  := Lt_TableServiciosPunto(Ln_IndxDataServiciosPunto);
          APEX_JSON.OPEN_OBJECT();
          APEX_JSON.WRITE('idServicio'         , Lr_RegDataServiciosAdicPunto.ID_SERVICIO);
          APEX_JSON.WRITE('estadoServicio'     , Lr_RegDataServiciosAdicPunto.ESTADO_SERVICIO);
          APEX_JSON.WRITE('idProducto'         , Lr_RegDataServiciosAdicPunto.ID_PRODUCTO);
          APEX_JSON.WRITE('descripcionProducto', Lr_RegDataServiciosAdicPunto.DESCRIPCION_PRODUCTO);
          APEX_JSON.WRITE('tipoServicio'       , Lr_RegDataServiciosAdicPunto.TIPO_SERVICIO);
          APEX_JSON.CLOSE_OBJECT;
          Ln_IndxDataServiciosPunto := Lt_TableServiciosPunto.NEXT(Ln_IndxDataServiciosPunto);
        END LOOP;
        APEX_JSON.CLOSE_ARRAY;
        Lcl_ResponseServicios := APEX_JSON.GET_CLOB_OUTPUT;
        Lcl_Request   := '{
                            "op": "' || Pv_OpIntProt || '",
                            "user": "' || Lv_User || '",
                            "token": "' || Lv_Token || '",
                            "data": {
                                "codEmpresa": "' || '18' || '",
                                "tipoProceso": "' || Lv_TipoProceso || '",
                                "idServicioInternet": "' || Pn_IdServicio || '",
                                "idPunto": "' || Pn_PuntoId || '",
                                "servicios": ' || Lcl_ResponseServicios || '
                            },
                            "source": {
                                "name": "' || Lv_Name || '",
                                "originID": "' || Lv_OriginId || '",
                                "tipoOriginID": "' || Lv_TipoOriginId || '"
                            },
                            "usrCreacion": "' || Lv_UsuarioCreacion || '",
                            "ipCreacion": "' || Lv_IpCreacion || '"
                          }';
        Pv_Status  := 'ERROR';
        Pv_Mensaje := 'Problemas al ejecutar el Ws de Telcos para ejecutar el procesamiento de servicios I. Protegido del cliente.';
        DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_Url,Lcl_Headers,Lcl_Request,Ln_CodeRequest,Lv_MsgResult,Lcl_Response);
        IF Ln_CodeRequest = 0 AND INSTR(Lcl_Response, 'status') != 0 AND INSTR(Lcl_Response, 'mensaje') != 0 THEN
            APEX_JSON.PARSE(Lcl_Response);
            Pv_Status     := APEX_JSON.GET_VARCHAR2(P_PATH => 'status');
            Pv_Mensaje    := 'Ejecutado ws correctamente';
            Lv_MsgResult  := APEX_JSON.GET_VARCHAR2(P_PATH => 'data');
            IF Pv_Status = 'OK' THEN
              FOR I IN 1 .. APEX_JSON.GET_COUNT ('data') LOOP
                IF Lv_TipoProceso = 'CORTE MASIVO' AND  APEX_JSON.GET_VARCHAR2('data[%d].status', I) = 'ERROR' THEN
                  Pv_Status  := 'ERROR';
                  Pv_Mensaje := 'Alguno de los servicios Internet Protegido no se pudo gestionar de manera correcta';
                  DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_EJECUTA_PROCESO_LOGICO(
                    APEX_JSON.GET_VARCHAR2('data[%d].idServicio', I),
                    APEX_JSON.GET_VARCHAR2('data[%d].tipoServicio', I),
                    Lv_AccionProcesoLogico,
                    Lv_EstadoNuevoServAdi,
                    Lv_ObservacionProcesoLogico,
                    TRUE,
                    TO_NUMBER(APEX_JSON.GET_VARCHAR2('data[%d].idProducto', I)),
                    Lv_DescCaractProcesoLogico,
                    'SI');
                END IF;
              END LOOP;
            ELSE
              Pv_Status  := 'ERROR';
              Pv_Mensaje := 'Existieron problemas al gestionar los servicios Internet Protegido por error en el web service de Telcos+';
              Lb_IngresaHistoError := TRUE;
              Lv_MensajeHistoError := Lv_ObsHistoServErrorWs;
            END IF;
        ELSE
          Pv_Status  := 'ERROR';
          Pv_Mensaje := 'No se ha podido obtener la respuesta del web service de Telcos+';
          Lb_IngresaHistoError := TRUE;
          Lv_MensajeHistoError := 'No se ha podido obtener la respuesta del web service de Telcos+';
        END IF;
      ELSE
        Pv_Status  := 'ERROR';
        Pv_Mensaje := 'Existieron problemas al gestionar los servicios Internet Protegido por errores al generar el token. '|| Lv_MsgResult;
        Lb_IngresaHistoError := TRUE;
        Lv_MensajeHistoError := Lv_ObsHistoServErrorToken;
      END IF;
      APEX_JSON.FREE_OUTPUT;
      IF Lb_IngresaHistoError = TRUE THEN
        Ln_IndxDataServiciosPunto := Lt_TableServiciosPunto.FIRST;
        WHILE (Ln_IndxDataServiciosPunto IS NOT NULL)
        LOOP
          Lr_RegDataServiciosAdicPunto  := Lt_TableServiciosPunto(Ln_IndxDataServiciosPunto);
          EXECUTE IMMEDIATE 'INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL(ID_SERVICIO_HISTORIAL, 
                             SERVICIO_ID, ESTADO, OBSERVACION, USR_CREACION, FE_CREACION, IP_CREACION) 
                             SELECT DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, 
                             :v1, :v2, :v3, :v4, :v5, :ipCreacion FROM DUAL '
          USING Lr_RegDataServiciosAdicPunto.ID_SERVICIO, Lr_RegDataServiciosAdicPunto.ESTADO_SERVICIO,
             Lv_MensajeHistoError, Lv_UsuarioCreacion, SYSDATE, Lv_IpCreacion;
          DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_EJECUTA_PROCESO_LOGICO(
            Lr_RegDataServiciosAdicPunto.ID_SERVICIO,
            Lr_RegDataServiciosAdicPunto.TIPO_SERVICIO,
            Lv_AccionProcesoLogico,
            Lv_EstadoNuevoServAdi,
            Lv_ObservacionProcesoLogico,
            TRUE,
            Lr_RegDataServiciosAdicPunto.ID_PRODUCTO,
            Lv_DescCaractProcesoLogico,
            'SI');
          Ln_IndxDataServiciosPunto := Lt_TableServiciosPunto.NEXT(Ln_IndxDataServiciosPunto);
        END LOOP;
      END IF;
      COMMIT;
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Lv_Mensaje      := 'Pn_PuntoId : '||Pn_PuntoId||' Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' ||
                       DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se han podido procesar correctamente los servicios Internet Protegido. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_GESTIONAR_SERV_INT_PROT',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GESTIONAR_SERV_INT_PROT;

  PROCEDURE P_GESTIONAR_SERV_KONIBIT(
    Pn_PuntoId      IN NUMBER,
    Pn_IdServicio   IN NUMBER,
    Pv_OpIntProt    IN VARCHAR2)
  AS
    Lv_Mensaje                       VARCHAR2(4000):= 'Error al actualizar detalle';
    Lv_TipoProceso                   VARCHAR2(30)  := '';
    Lv_EstadoNuevoServAdi            VARCHAR2(10)  := '';
    Lv_DescripcionProducto           VARCHAR2(100) := '';
    Lv_LikeDescripcionProducto       VARCHAR2(25)  := '';
    Lv_DescCaracServicio             VARCHAR2(25)  := 'KONIBIT';
    Lv_EstadoInCorte                 VARCHAR2(10)  := 'In-Corte';
    Lrf_RegistrosServAdicPto         SYS_REFCURSOR;
    Lrf_RegistrosServPlanPto         SYS_REFCURSOR;
    Lr_RegDataServiciosAdicPunto     DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LR_DATASERVICIOSADICPUNTO;
    Lt_TableServiciosAdicPunto       DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATASERVICIOSADICPUNTO;
    Ln_IndxDataServiciosPunto        NUMBER := 0;
    Lt_TableServiciosPunto           DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATASERVICIOSADICPUNTO;
    Lv_UsuarioCreacion      VARCHAR2(20) := 'procesosmasivos';
    Lv_IpCreacion           VARCHAR2(20) := '127.0.0.1';
    Lv_MsgResult            VARCHAR2(4000);
  BEGIN
    IF Pv_OpIntProt = 'cortarLicencias' THEN
      Lv_TipoProceso        := 'CORTAR';
      Lv_EstadoNuevoServAdi := Lv_EstadoInCorte;                                
    END IF;
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_RECUPERA_SERV_ADIC_KONIBIT(Pn_PuntoId,
                                                                          Lv_EstadoNuevoServAdi,
                                                                          Lv_DescripcionProducto,
                                                                          Lv_LikeDescripcionProducto,
                                                                          Lv_DescCaracServicio,
                                                                          Lrf_RegistrosServAdicPto);
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_RECUPERA_SERV_PLAN_KONIBIT(Pn_IdServicio,
                                                                          Lv_DescripcionProducto,
                                                                          Lv_LikeDescripcionProducto,
                                                                          NULL,
                                                                          Lv_DescCaracServicio,
                                                                          Lrf_RegistrosServPlanPto);
    LOOP
      FETCH Lrf_RegistrosServAdicPto BULK COLLECT
      INTO Lt_TableServiciosAdicPunto LIMIT 10;
      Ln_IndxDataServiciosPunto := Lt_TableServiciosAdicPunto.FIRST;
      WHILE (Ln_IndxDataServiciosPunto IS NOT NULL)
      LOOP
        Lr_RegDataServiciosAdicPunto  := Lt_TableServiciosAdicPunto(Ln_IndxDataServiciosPunto);
        Lt_TableServiciosPunto(Lt_TableServiciosPunto.COUNT) := Lr_RegDataServiciosAdicPunto;
        Ln_IndxDataServiciosPunto := Lt_TableServiciosAdicPunto.NEXT(Ln_IndxDataServiciosPunto);
      END LOOP;
      EXIT WHEN Lrf_RegistrosServAdicPto%NOTFOUND;
    END LOOP;
    CLOSE Lrf_RegistrosServAdicPto;
    LOOP
      FETCH Lrf_RegistrosServPlanPto BULK COLLECT
      INTO Lt_TableServiciosAdicPunto LIMIT 10;
      Ln_IndxDataServiciosPunto := Lt_TableServiciosAdicPunto.FIRST;
      WHILE (Ln_IndxDataServiciosPunto IS NOT NULL)
      LOOP
        Lr_RegDataServiciosAdicPunto  := Lt_TableServiciosAdicPunto(Ln_IndxDataServiciosPunto);
        Lt_TableServiciosPunto(Lt_TableServiciosPunto.COUNT) := Lr_RegDataServiciosAdicPunto;
        Ln_IndxDataServiciosPunto := Lt_TableServiciosAdicPunto.NEXT(Ln_IndxDataServiciosPunto);
      END LOOP;
      EXIT WHEN Lrf_RegistrosServPlanPto%NOTFOUND;
    END LOOP;
    CLOSE Lrf_RegistrosServPlanPto;
    IF Lt_TableServiciosPunto.COUNT > 0 THEN
      Ln_IndxDataServiciosPunto := Lt_TableServiciosPunto.FIRST;
      WHILE (Ln_IndxDataServiciosPunto IS NOT NULL)
      LOOP
        Lr_RegDataServiciosAdicPunto  := Lt_TableServiciosPunto(Ln_IndxDataServiciosPunto);
        DB_INFRAESTRUCTURA.INFRKG_KONIBIT.P_ENVIA_NOTIFICACION(
          Lr_RegDataServiciosAdicPunto.Id_Servicio,
          Lv_TipoProceso,
          'MASIVO',
          Lv_UsuarioCreacion,
          Lv_IpCreacion,
          Lv_MsgResult);
        Ln_IndxDataServiciosPunto := Lt_TableServiciosPunto.NEXT(Ln_IndxDataServiciosPunto);
      END LOOP;
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_Mensaje      := 'Pn_PuntoId : '||Pn_PuntoId||' Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' ||
                       DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_GESTIONAR_SERV_KONIBIT',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GESTIONAR_SERV_KONIBIT;

  PROCEDURE P_PROCESAR_TELCOS (
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2)
  AS
    Lv_TipoProcesoCorte        VARCHAR2(15)   := 'CortarCliente';
    Lv_EstadoActivo            VARCHAR2(30)   := 'Activo';
    Lv_EstadoInCorte           VARCHAR2(30)   := 'In-Corte';
    Lv_EstadoOk                VARCHAR2(30)   := 'OK';
    Lv_EstadoFallo             VARCHAR2(30)   := 'Fallo';
    Lv_EstadoItem              VARCHAR2(30)   := '';
    Lv_EstadoDetallePm         VARCHAR2(10)   := '';
    Lv_EstadoNuevoPm           VARCHAR2(30);
    Lv_EstadoActualPm          VARCHAR2(30);
    Lv_ObservacionHistorial    VARCHAR2(2000);
    Lv_ObservacionHistorialTmp VARCHAR2(2000);
    Lv_OpInternetProtegido     VARCHAR2(20);
    Lv_StatusMw                VARCHAR2(20);
    Ln_IdPunto                 NUMBER;
    Ln_IdDetPm                 NUMBER;
    Ln_IdSecHist               NUMBER;
    Ln_IdServicioTmp           NUMBER := 0;
    Lv_UsuarioCreacion         VARCHAR2(20) := 'procesosmasivos';
    Lv_IpCreacion              VARCHAR2(20) := '127.0.0.1';
    Lcl_JsonFiltrosBusqueda    CLOB;
    Lv_TipoProceso             VARCHAR2(20);
    Lv_MsjResultado            VARCHAR2(2000);
    Lv_EmpresaMd               VARCHAR2(2) := 'MD';
    Lv_EmpresaEn               VARCHAR2(2) := 'EN';
    Lv_PrefijoEmpresa          VARCHAR2(2);
    Lv_Status                  VARCHAR2(5);
    Lv_Mensaje                 VARCHAR2(4000);
    Ln_CantidadIntentos        DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.CANTIDAD_INTENTOS%TYPE := 0;
    Lrf_RegistrosServiciosPto  SYS_REFCURSOR;
    Lr_RegDataServiciosPunto   DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LR_DATASERVICIOSPUNTO;
    Lt_TableDataServiciosPunto DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATASERVICIOSPUNTO;
    Ln_IndxDataServiciosPunto  NUMBER := 0;
    Lr_InfoServicioHistorial   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Ln_IndxDataServiciosKonibit NUMBER := 0;
    Lt_TableServiciosKonibit    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.Lt_DataServiciosKonibit;
    Lr_RegServicioKonibit       DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.Lr_DataServiciosKonibit;
  BEGIN
    Lcl_Jsonfiltrosbusqueda := Pcl_JsonRequest;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_TipoProceso    := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoProceso'));
    Lv_PrefijoEmpresa := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'prefijoEmpresa'));
    Lv_StatusMw := APEX_JSON.GET_VARCHAR2 ('response.status');
    IF Lv_StatusMw IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE ('Lv_Tipoproceso: ' || Lv_TipoProceso);
      IF Lv_TipoProceso = Lv_TipoProcesoCorte THEN
        Lv_ObservacionHistorial := 'El servicio se corto exitosamente';
        Lv_EstadoNuevoPm        := Lv_EstadoInCorte;
        Lv_EstadoActualPm       := Lv_EstadoActivo;
        Lv_OpInternetProtegido  := 'cortarLicencias';
      END IF;
      IF APEX_JSON.GET_COUNT ('response.datos_cliente') > 0 THEN
        FOR I IN 1 .. APEX_JSON.GET_COUNT ('response.datos_cliente') LOOP
          Lv_ObservacionHistorialTmp:= Lv_ObservacionHistorial;
          Ln_IndxDataServiciosPunto := 0;
          Ln_IdSecHist              := 0;
          Ln_IdDetPm                := APEX_JSON.GET_NUMBER ('response.datos_cliente[%d].idProcesoDet', I);
          Lv_EstadoItem             := APEX_JSON.GET_VARCHAR2 ('response.datos_cliente[%d].status', I);
          Ln_IdServicioTmp          := APEX_JSON.GET_NUMBER ('response.datos_cliente[%d].idServicio', I);
          DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_OBTENER_DETALLES_INFO_PM(
            Ln_IdDetPm,
            Ln_IdPunto,
            Ln_CantidadIntentos);
          IF Lv_EstadoItem = Lv_EstadoOk THEN
            Lr_InfoServicioHistorial                        := NULL;
            Ln_IdSecHist                                    := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
            Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := Ln_IdSecHist;
            Lr_InfoServicioHistorial.SERVICIO_ID            := Ln_IdServicioTmp;
            Lr_InfoServicioHistorial.USR_CREACION           := Lv_UsuarioCreacion;
            Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
            Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
            Lr_InfoServicioHistorial.ESTADO                 := Lv_EstadoNuevoPm;
            Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
            Lr_InfoServicioHistorial.OBSERVACION            := Lv_ObservacionHistorialTmp;
            Lr_InfoServicioHistorial.ACCION                 := NULL;
            DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_MsjResultado);
            IF Lv_PrefijoEmpresa = Lv_EmpresaMd THEN
              DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_OBTENER_SERV_ADIC_PUNTO(
                Ln_IdPunto,
                Lv_EstadoActualPm,
                Lv_OpInternetProtegido,
                Lrf_RegistrosServiciosPto);
              DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_SERVICIOS_PUNTO(
                Lv_EstadoNuevoPm,
                Lv_EstadoActualPm,
                Lv_OpInternetProtegido,
                Ln_IdPunto,
                Lv_Status,
                Lv_Mensaje);
              Lv_MsjResultado := '';
              LOOP
                FETCH Lrf_RegistrosServiciosPto BULK COLLECT
                INTO Lt_TableDataServiciosPunto LIMIT 10;
                Ln_IndxDataServiciosPunto := Lt_TableDataServiciosPunto.FIRST;
                WHILE (Ln_IndxDataServiciosPunto IS NOT NULL)
                LOOP
                  Lr_RegDataServiciosPunto                        := Lt_TableDataServiciosPunto(Ln_IndxDataServiciosPunto);
                  Lr_InfoServicioHistorial                        := NULL;
                  Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
                  Lr_InfoServicioHistorial.SERVICIO_ID            := Lr_RegDataServiciosPunto.Id_Servicio;
                  Lr_InfoServicioHistorial.USR_CREACION           := Lv_UsuarioCreacion;
                  Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
                  Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
                  Lr_InfoServicioHistorial.ESTADO                 := Lv_EstadoNuevoPm;
                  Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
                  Lr_InfoServicioHistorial.OBSERVACION            := Lv_ObservacionHistorialTmp;
                  Lr_InfoServicioHistorial.ACCION                 := NULL;
                  DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_MsjResultado);
                  Ln_IndxDataServiciosPunto  := Lt_TableDataServiciosPunto.NEXT(Ln_IndxDataServiciosPunto);
                  END LOOP;
                EXIT
                WHEN Lrf_RegistrosServiciosPto%NOTFOUND;
              END LOOP;
              UPDATE DB_COMERCIAL.INFO_PUNTO
              SET ESTADO   = Lv_EstadoNuevoPm ,
              USR_ULT_MOD  = Lv_UsuarioCreacion ,
              FE_ULT_MOD   = SYSDATE
              WHERE ID_PUNTO = Ln_IdPunto;
            END IF;
            IF Lv_PrefijoEmpresa = Lv_EmpresaEn THEN
              UPDATE DB_COMERCIAL.INFO_PUNTO
              SET ESTADO   = Lv_EstadoNuevoPm ,
              USR_ULT_MOD  = Lv_UsuarioCreacion ,
              FE_ULT_MOD   = SYSDATE
              WHERE ID_PUNTO = Ln_IdPunto;

               UPDATE DB_COMERCIAL.INFO_SERVICIO 
              SET ESTADO = Lv_EstadoNuevoPm 
              WHERE PUNTO_ID = Ln_IdPunto 
              AND ESTADO = Lv_EstadoActualPm;
            END IF;
          ELSE
            Lv_ObservacionHistorialTmp := APEX_JSON.GET_VARCHAR2 ('response.datos_cliente[%d].mensaje', I);
          END IF;
          Lv_EstadoDetallePm := '';
          IF Lv_EstadoItem = Lv_EstadoOk THEN
            Lv_EstadoDetallePm := Lv_EstadoNuevoPm;
          ELSE
            Lv_EstadoDetallePm := Lv_EstadoFallo;
            IF Ln_CantidadIntentos IS NULL THEN
              Ln_CantidadIntentos := 1;
            ELSE
              Ln_CantidadIntentos := Ln_CantidadIntentos + 1;
            END IF;
          END IF;
          DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_DETALLE_PM(
            Lv_EstadoDetallePm,
            Lv_UsuarioCreacion,
            Lv_ObservacionHistorialTmp,
            Ln_IdDetPm,
            Ln_IdPunto,
            Ln_CantidadIntentos,
            Lv_Status,
            Lv_Mensaje);
          COMMIT;
          IF Lv_EstadoItem = Lv_EstadoOk THEN
          IF Lv_PrefijoEmpresa = Lv_EmpresaMd THEN
            DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_GESTIONAR_SERV_INT_PROT(
              Ln_IdPunto,
              Ln_IdServicioTmp,
              Lv_OpInternetProtegido,
              Lv_Status,
              Lv_Mensaje);
              IF Lv_Status = 'ERROR' THEN
                EXECUTE IMMEDIATE 'UPDATE INFO_PROCESO_MASIVO_DET 
                                  SET USR_ULT_MOD = :v1, FE_ULT_MOD = :v2, OBSERVACION = :v3 
                                  WHERE ID_PROCESO_MASIVO_DET = :v4 AND PUNTO_ID = :v5 '
                USING Lv_UsuarioCreacion, SYSDATE, Lv_ObservacionHistorial||' '||Lv_Mensaje, Ln_IdDetPm, Ln_IdPunto;
              END IF;
            END IF;
            IF Lv_TipoProceso = 'CortarCliente' THEN
              DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.P_ACTUALIZA_INFORMACION_CORTE(
                Ln_IdServicioTmp,
                Ln_IdSecHist,
                'CORTE',
                'Caracter�stica ingresada desde un corte masivo con el �ltimo historial '||
                'In-Corte v�lido para la cancelaci�n masiva',
                Lv_UsuarioCreacion,
                Lv_IpCreacion,
                Lv_Status,
                Lv_Mensaje);
            END IF;
            COMMIT;
            Lr_RegServicioKonibit := NULL;
            Lr_RegServicioKonibit.Id_Punto    := Ln_IdPunto;
            Lr_RegServicioKonibit.Id_Servicio := Ln_IdServicioTmp;
            Lr_RegServicioKonibit.Operacion   := Lv_OpInternetProtegido;
            Lt_TableServiciosKonibit(Lt_TableServiciosKonibit.COUNT) := Lr_RegServicioKonibit;
          END IF;
          COMMIT;
        END LOOP;
        IF Lt_TableServiciosKonibit.COUNT > 0 THEN
          Ln_IndxDataServiciosKonibit := Lt_TableServiciosKonibit.FIRST;
          WHILE (Ln_IndxDataServiciosKonibit IS NOT NULL)
          LOOP
            Lr_RegServicioKonibit  := Lt_TableServiciosKonibit(Ln_IndxDataServiciosKonibit);
            DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_GESTIONAR_SERV_KONIBIT(
              Lr_RegServicioKonibit.Id_Punto,
              Lr_RegServicioKonibit.Id_Servicio,
              Lr_RegServicioKonibit.Operacion);
            Ln_IndxDataServiciosKonibit := Lt_TableServiciosKonibit.NEXT(Ln_IndxDataServiciosKonibit);
          END LOOP;
        END IF;
      END IF;
    ELSE
      IF APEX_JSON.GET_COUNT ('request.datos_cliente') > 0 THEN
        FOR I IN 1 .. APEX_JSON.GET_COUNT ('request.datos_cliente') LOOP
          Ln_IdDetPm                := APEX_JSON.GET_NUMBER ('request.datos_cliente[%d].proceso_det_id', I);
          DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_OBTENER_DETALLES_INFO_PM(
            Ln_IdDetPm,
            Ln_IdPunto,
            Ln_CantidadIntentos);
          IF Ln_CantidadIntentos IS NULL THEN
            Ln_CantidadIntentos := 1;
          ELSE
            Ln_CantidadIntentos := Ln_CantidadIntentos + 1;
          END IF;
          Lv_ObservacionHistorial := 'No se ha podido obtener correctamente la respuesta del middleware';
          DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_ACTUALIZAR_DETALLE_PM(
            Lv_EstadoFallo,
            Lv_UsuarioCreacion,
            Lv_ObservacionHistorial,
            Ln_IdDetPm,
            Ln_IdPunto,
            Ln_CantidadIntentos,
            Lv_Status,
            Lv_Mensaje);
        END LOOP;
        COMMIT;
      END IF;
    END IF;
    Pv_Status := 'OK';
    Pv_Mensaje := 'Proceso termin� de ejecutarse';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status := 'ERROR';
    Pv_Mensaje := 'Ocurri� un error no controlado en la ejecuci�n';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_PROCESAR_TELCOS',
                                         SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
  END P_PROCESAR_TELCOS;

  PROCEDURE P_PROCESAR_CABECERAS_PM (Pcl_JsonRequest     IN CLOB)
  AS
    Lv_UsuarioCreacion       VARCHAR2(20) := 'procesosmasivos';
    Lv_IpCreacion            VARCHAR2(20) := '127.0.0.1';
    Ln_IdCabPm               NUMBER;
    Ln_CantidadDetalles      NUMBER := 0;
    Ln_CantidadIntentosMax   NUMBER := 0;
  BEGIN
    DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.P_CANTIDAD_INTENTOS(Ln_CantidadIntentosMax);
    APEX_JSON.PARSE(Pcl_JsonRequest);
    IF APEX_JSON.GET_COUNT ('idsPmCab') > 0 THEN
      FOR I IN 1 .. APEX_JSON.GET_COUNT ('idsPmCab') LOOP
        Ln_IdCabPm                := APEX_JSON.GET_NUMBER ('idsPmCab[%d]', I);

        SELECT COUNT(*) INTO Ln_CantidadDetalles
        FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB CAB,
          DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET DET
        WHERE CAB.ID_PROCESO_MASIVO_CAB = DET.PROCESO_MASIVO_CAB_ID
        AND CAB.ID_PROCESO_MASIVO_CAB   = Ln_IdCabPm
        AND CAB.ESTADO                 IN ('Pendiente', 'Procesando')
        AND (DET.ESTADO                IN ('Procesando', 'Pendiente')
        OR (DET.ESTADO                  = 'Fallo'
        AND (DET.CANTIDAD_INTENTOS     IS NULL
        OR DET.CANTIDAD_INTENTOS        < Ln_CantidadIntentosMax)));
        IF Ln_CantidadDetalles = 0 THEN
          UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
          SET DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO = 'Finalizada'
          WHERE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB = Ln_IdCabPm;
        END IF;
      END LOOP;
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'INKG_PROCESOS_MASIVOS.P_PROCESAR_CABECERAS_PM',
                                         SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                         LV_USUARIOCREACION,
                                         SYSDATE,
                                         Lv_IpCreacion);
  END P_PROCESAR_CABECERAS_PM;

  PROCEDURE P_CANTIDAD_INTENTOS(
    Pn_CantidadIntentos OUT NUMBER)
  AS
    Lv_Mensaje              VARCHAR2(4000) := '';
    Lv_EstadoActivo         VARCHAR2(10)   := 'Activo';
    Lv_NombreParametro      VARCHAR2(200)  := 'PARAMETROS_PROCESOS_MASIVOS_TELCOS';
    Lv_DatosReintento       VARCHAR2(200)  := 'CANTIDAD_INTENTOS_MAX';
    Lv_CantidadIntentos     VARCHAR2(2)    := '';
    CURSOR C_OBTENERCANTIDADINTENTOS IS
      SELECT NVL(VALOR1, '0') FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE ESTADO = Lv_EstadoActivo AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
          WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_EstadoActivo AND ROWNUM = 1)
      AND DESCRIPCION = Lv_DatosReintento AND ROWNUM = 1;
  BEGIN
    Pn_CantidadIntentos := 0;
    OPEN C_OBTENERCANTIDADINTENTOS;
    FETCH C_OBTENERCANTIDADINTENTOS INTO Lv_CantidadIntentos;
    CLOSE C_OBTENERCANTIDADINTENTOS;
    Pn_CantidadIntentos := TO_NUMBER(Lv_CantidadIntentos, '9999');
  EXCEPTION
  WHEN OTHERS THEN
    Pn_CantidadIntentos := 0;
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_PROCESOS_MASIVOS.P_CANTIDAD_INTENTOS',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_CANTIDAD_INTENTOS;
END INKG_PROCESOS_MASIVOS;
/

CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS
AS

/*
  * Documentaci�n para TYPE 'Lr_InfoServicioMiddleware'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente al servicio de internet middleware
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 05-09-2022
  */
  TYPE Lr_InfoServicioMiddleware IS RECORD
  (
    Id_Cab                  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
    Id_Det                  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE,
    Tipo_Proceso            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
    Estado                  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE,
    Punto_Id                DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Login                   DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    Tipo_Negocio            VARCHAR2(100),
    Prefijo_Empresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Elemento_Id             DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    Nombre_Elemento_Olt     DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    Serie_Ont               DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE,
    Elemento_Cliente_Id     DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE,
    Servicio_Id             DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Servicio_Estado         DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    Punto_Estado            DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
    Servicio_Tecnico_Id     DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ID_SERVICIO_TECNICO%TYPE,
    Modelo_Elemento_Id      DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.ID_MODELO_ELEMENTO%TYPE,
    Modelo_Elemento_Nombre  DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    Marca_Elemento_Nombre   DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE,
    Accion                  VARCHAR2(100),
    Script                  DB_COMUNICACION.INFO_DOCUMENTO.MENSAJE%TYPE,
    Ip                      DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE,
    Puerto                  DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
    Caract_Perfil           DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Caract_Indice           DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Caract_Mac              DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Spid                    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Vlan                    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Gemport                 DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Traffic                 DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Profile_Name            DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Service                 DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Capacidad_Up            DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Capacidad_Down          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Ip_Fijas_Adicionales    NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoServicioMiddleware'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al servicio de internet middleware
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 06-09-2022
  */
  TYPE Lt_InfoServicioMiddleware
  IS
    TABLE OF Lr_InfoServicioMiddleware INDEX BY PLS_INTEGER;  
    
 /*
  * Documentaci�n para TYPE 'Lr_DataServiciosKonibit'.
  *
  * Tipo de datos para servicios konibit de un punto
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 20-10-2022
  */
  TYPE Lr_DataServiciosKonibit IS RECORD
  (
    Id_Punto                  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Id_Servicio               DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Operacion                 VARCHAR2(30)
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataServiciosKonibit'.
  * Tabla para almacenar la data enviada con la informaci�n de servicios konibit de punto
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 20-10-2022
  */
  TYPE Lt_DataServiciosKonibit  IS
    TABLE OF Lr_DataServiciosKonibit INDEX BY PLS_INTEGER;
    
 /*
  * Documentaci�n para TYPE 'Lr_DataCabecerasPm'.
  *
  * Tipo de datos para el registro de cabeceras de PM
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 07-09-2022
  */
  TYPE Lr_DataCabecerasPM IS RECORD
  (
    Id_Cab NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataCabecerasPm'.
  * Tabla para almacenar la data enviada con la informaci�n de cabeceras PM
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 07-09-2022
  */
  TYPE Lt_DataCabecerasPm
  IS
    TABLE OF Lr_DataCabecerasPm INDEX BY PLS_INTEGER;
    
 /*
  * Documentaci�n para TYPE 'Lr_DataServiciosPunto'.
  *
  * Tipo de datos para servicios de un punto
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 07-09-2022
  */
  TYPE Lr_DataServiciosPunto IS RECORD
  (
    Id_Servicio      NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataServiciosPunto'.
  * Tabla para almacenar la data enviada con la informaci�n de servicios de punto
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 07-09-2022
  */
  TYPE Lt_DataServiciosPunto
  IS
    TABLE OF Lr_DataServiciosPunto INDEX BY PLS_INTEGER;
    
/*
  * Documentaci�n para TYPE 'Lr_DataServiciosAdicPunto'.
  *
  * Tipo de datos para servicios adicionales de un punto
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 07-09-2022
  */
  TYPE Lr_DataServiciosAdicPunto IS RECORD
  (
    Id_Servicio               DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Estado_Servicio           DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    Id_Producto               DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Descripcion_Producto      DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    Tipo_Servicio             VARCHAR2(10)
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataServiciosAdicPunto'.
  * Tabla para almacenar la data enviada con la informaci�n de servicios adicionales de punto
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 07-09-2022
  */
  TYPE Lt_DataServiciosAdicPunto  IS
    TABLE OF Lr_DataServiciosAdicPunto INDEX BY PLS_INTEGER;

  /**
   * P_Obtener_Detalles_Info_Pm
   * Procedimiento que genera json con informaci�n de detalles de procesos masivos
   *
   * @param  Pn_IdProcesoMasivoDet IN  Db_Infraestructura.Info_Proceso_Masivo_Det.Id_Proceso_Masivo_Det%Type    Id detalle proceso masivo
   * @param  Pn_IdPunto            OUT Db_Comercial.Info_Punto.Id_Punto%Type                                    Id punto del servicio procesado
   * @param  Pn_CantidadIntentos   Out Db_Infraestructura.Info_Proceso_Masivo_Det.Cantidad_Intentos%Type        Cantidad de reintentos de ejecuci�n
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_OBTENER_DETALLES_INFO_PM(
    Pn_IdProcesoMasivoDet   IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE,
    Pn_IdPunto              OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_CantidadIntentos     OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.CANTIDAD_INTENTOS%TYPE);
    
  /**
   * Documentaci�n para PROCEDURE 'P_INSERT_INFO_SERVICIO_HISTO'.
   *
   * Procedimiento que inserta registro en la tabla de historial de servicio INFO_SERVICIO_HISTORIAL
   *
   * PARAMETROS:
   * @Param Pr_InfoServicioHisto     IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE  Recibe un registro con la informaci�n necesaria para ingresar
   * @Param Pv_MsjResultado         OUT  VARCHAR2                                      Devuelve un mensaje del resultado de ejecuci�n
   * 
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 02-07-2019
   */
  PROCEDURE P_INSERT_INFO_SERVICIO_HISTO(
    Pr_InfoServicioHisto   IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE,
    Pv_MsjResultado        OUT VARCHAR2);
    
  /**
   * P_VALIDAR_CAB_ID
   * Procedimiento que valida las cabeceras en listado de cabs
   *
   * @param  Pn_IdCab                   IN  NUMBER    IdCab a validar en listado
   * @param  Pt_TRegsDataCabecerasPm    IN  DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.Lt_DataCabecerasPm  Listado de IdCab's actuales
   * @param  Pv_Existe                  OUT VARCHAR2  Existe o no IdCab
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_VALIDAR_CAB_ID(
    Pn_IdCab                 IN  NUMBER,
    Pt_TregsDataCabecerasPm  IN  DB_INFRAESTRUCTURA.INKG_PROCESOS_MASIVOS.LT_DATACABECERASPM,
    Pv_Existe                OUT VARCHAR2);
    
  /**
   * P_OBTENER_CABECERAS_PM
   * Procedimiento que obtiene las cabeceras de procesos masivos a procesar en estado Pendiente
   *
   * @param  Pv_TipoProceso     IN VARCHAR2  Tipo proceso con el cual se realizar� la consulta
   * @param  Pv_EmpresaCod      IN VARCHAR2  Tipo proceso con el cual se realizar� la consulta
   * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pcl_Response       OUT CLOB      Respuesta en formato json de la consulta
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   * @author Jessenia Piloso <jpiloso@telconet.ec>
   * @version 1.8 07-03-2023     Se incluye validaciones para considerar a la empresa de Ecuanet en el proceso masivo de corte.
   *
   *
   */
  PROCEDURE P_OBTENER_CABECERAS_PM(
    Pv_TipoProceso      IN VARCHAR2,
    Pv_EmpresaCod       IN VARCHAR2,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_Response        OUT CLOB,
    Pn_CantidadCab      OUT NUMBER);
    
  /**
   * P_OBTENER_DETALLES_PM
   * Procedimiento que obtiene las cabeceras de procesos masivos a procesar en estado Pendiente
   *
   * @param  Pcl_Cabeceras      IN  CLOB           Tipo proceso con el cual se realizar� la consulta
   * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
   * @param  Prf_Registros      OUT SYS_REFCURSOR  Respuesta en formato json de la consulta
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_OBTENER_DETALLES_PM(
    Pcl_Cabeceras       IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Prf_Registros       OUT SYS_REFCURSOR);

  /**
   * P_ACTUALIZA_INCONSISTENCIA_PM
   * Procedimiento que actualiza procesos masivos con inconsistencias en estado de servicio de internet
   *
   * @param  Pcl_Cabeceras      IN  CLOB           Tipo proceso con el cual se realizar� la consulta
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 24-10-2022
   *
   */
  PROCEDURE P_ACTUALIZA_INCONSISTENCIA_PM(
    Pcl_Cabeceras       IN  CLOB);

  /**
   * P_ACTUALIZA_REGULARIZA_CAB_PM
   * Procedimiento que actualiza procesos masivos cab que han finalizado todos sus detalles y a�n se
   * encuentran con estado Procesando
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 10-01-2022
   *
   */
  PROCEDURE P_ACTUALIZA_REGULARIZA_CAB_PM;


  /**
   * P_Obtener_Serv_Adic_Punto
   * Procedimiento que obtiene los productos adicionales solicitados
   *
   * @param  Pn_PuntoId      IN  Number         Id Punto del cliente procesado
   * @param  Pv_Estado       IN  VARCHAR2       Estado de servicios a buscar
   * @param  Pv_OpIntProt    IN  VARCHAR2       Operaci�n ejecutada
   * @param  Prf_Registros   OUT SYS_REFCURSOR  Respuesta de informaci�n consultada
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_OBTENER_SERV_ADIC_PUNTO(
    Pn_PuntoId       IN NUMBER,
    Pv_Estado        IN VARCHAR2,
    Pv_OpIntProt     IN VARCHAR2,
    Prf_Registros    OUT SYS_REFCURSOR);

  /**
   * P_Ejecuta_Proceso_Logico
   * Procedimiento que ejecuta operaciones l�gicas en el servicio procesado
   *
   * @param  Pn_IdServicio          IN  Number           Id servicio del cliente procesado
   * @param  Pv_TipoServicio        IN  Varchar2         Tipo de servicio procesado
   * @param  Pv_Accion              IN  Varchar2         Accion a setear
   * @param  Pv_EstadoServicio      IN  Varchar2         Estado de servicio a actualizar
   * @param  Pv_ObservacionHist     IN  Varchar2         Observaci�n a ingresar
   * @param  Pb_RequiereCaract      IN  Boolean          Bandera que indica si requiere creaci�n de caracteristica o no
   * @param  Pn_IdProducto          IN  Number           Id producto del servicio del cliente procesado
   * @param  Pv_DescripcionCaract   IN  Varchar2         Descripci�n de caracteristica a usar
   * @param  Pv_Valor               IN  Varchar2         Valor de caracteristica a setear  
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_EJECUTA_PROCESO_LOGICO( 
    Pn_IdServicio          IN NUMBER,
    Pv_TipoServicio        IN VARCHAR2,
    Pv_Accion              IN VARCHAR2,
    Pv_EstadoServicio      IN VARCHAR2,
    Pv_ObservacionHist     IN VARCHAR2,
    Pb_RequiereCaract      IN BOOLEAN,
    Pn_IdProducto          IN NUMBER,
    Pv_DescripcionCaract   IN VARCHAR2,
    Pv_Valor               IN VARCHAR2);
    
  /**
   * P_Actualizar_Cabeceras_Pm
   * Procedimiento que actualiza las cabeceras de procesos masivos a procesar en estado Procesando
   *
   * @param  Pcl_Cabeceras      IN  CLOB           Tipo proceso con el cual se realizar� la actualizaci�n
   * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_ACTUALIZAR_CABECERAS_PM(
    Pcl_Cabeceras       IN CLOB,
    Pv_EstadoNuevo      IN VARCHAR2,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2);
    
  /**
   * P_Actualizar_Detalles_Pm
   * Procedimiento que actualiza las detalles de procesos masivos a procesar en estado Procesando
   *
   * @param  Pcl_Cabeceras      IN  CLOB           Tipo proceso con el cual se realizar� la actualizaci�n
   * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_ACTUALIZAR_DETALLES_PM(
    Pcl_Cabeceras       IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2);
    
  /**
   * P_Actualizar_Detalle_Pm
   * Procedimiento que actualiza las detalles de procesos masivos a procesar en estado Procesando
   *
   * @param  Pv_Estado           IN  Varchar2      Estado a colocar el proceso masivo
   * @param  Pv_Usuario          IN  Varchar2      Usuario de modificaci�n
   * @param  Pv_Observacion      IN  Varchar2      Observaci�n de PM
   * @param  Pn_IpDetPm          IN  Number        Id detalle PM
   * @param  Pn_PuntoId          IN  Number        Id de punto de proceso masivo detalle
   * @param  Pn_CantidadIntentos IN  Number        Cantidad de intentos de ejecuci�n
   * @param  Pv_Status           OUT VARCHAR2      Estado del procedimiento
   * @param  Pv_Mensaje          OUT VARCHAR2      Mensaje de error del procedimiento
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_ACTUALIZAR_DETALLE_PM(
    Pv_Estado           IN VARCHAR2,
    Pv_Usuario          IN VARCHAR2,
    Pv_Observacion      IN VARCHAR2,
    Pn_IpDetPm          IN NUMBER,
    Pn_PuntoId          IN NUMBER,
    Pn_CantidadIntentos IN NUMBER,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2);
    
  /**
   * P_Gestionar_Serv_Int_Prot
   * Procedimiento que gestiona los servicios de internet protegido
   *
   * @param  Pn_PuntoId         IN  Number        Id Punto del cliente a procesar
   * @param  Pn_IdServicio      IN  Number        Id Servicio de internet del cliente a procesar
   * @param  Pv_OpIntProt       IN  Varchar2      Operaci�n procesada
   * @param  Pv_Status          OUT VARCHAR2      Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2      Mensaje de error del procedimiento
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_GESTIONAR_SERV_INT_PROT(
    Pn_PuntoId      IN NUMBER,
    Pn_IdServicio   IN NUMBER,
    Pv_OpIntProt    IN VARCHAR2,
    Pv_Status       OUT VARCHAR2,
    Pv_Mensaje      OUT VARCHAR2);

  /**
   * P_Gestionar_Serv_Konibit
   * Procedimiento que gestiona los servicios konibit
   *
   * @param  Pn_PuntoId         IN  Number        Id Punto del cliente a procesar
   * @param  Pn_IdServicio      IN  Number        Id Servicio de internet del cliente a procesar
   * @param  Pv_OpIntProt       IN  Varchar2      Operaci�n procesada
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_GESTIONAR_SERV_KONIBIT(
    Pn_PuntoId      IN NUMBER,
    Pn_IdServicio   IN NUMBER,
    Pv_OpIntProt    IN VARCHAR2);

  /**
   * P_Recupera_Serv_Adic_Int_Pro
   * Procedimiento que recupera servicios adicionales de internet protegido
   *
   * @param  Pn_PuntoId           IN  Number             Id Punto del cliente a procesar
   * @param  Pv_Estado            IN  Varchar2           Estado a consultar
   * @param  Pv_Descripcion       IN  Varchar2           Descripci�n de producto a consultar
   * @param  Pv_LikeDescripcion   IN  Varchar2           Like Descripci�n de producto a consultar
   * @param  Pv_DescCaractServ    IN  Varchar2           Descripcion caracteristica servicio
   * @param  Prf_Registros        OUT Sys_Refcursor      Informaci�n recuperada
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_RECUPERA_SERV_ADIC_INT_PRO(
    Pn_PuntoId           IN NUMBER,
    Pv_Estado            IN VARCHAR2,
    Pv_Descripcion       IN VARCHAR2,
    Pv_LikeDescripcion   IN VARCHAR2,
    Pv_DescCaractServ    IN VARCHAR2,
    Prf_Registros        OUT SYS_REFCURSOR);
    
  /**
   * P_Recupera_Serv_Adic_Konibit
   * Procedimiento que recupera servicios adicionales konibit
   *
   * @param  Pn_PuntoId           IN  Number             Id Punto del cliente a procesar
   * @param  Pv_Estado            IN  Varchar2           Estado a consultar
   * @param  Pv_Descripcion       IN  Varchar2           Descripci�n de producto a consultar
   * @param  Pv_LikeDescripcion   IN  Varchar2           Like Descripci�n de producto a consultar
   * @param  Pv_DescCaractServ    IN  Varchar2           Descripcion caracteristica servicio
   * @param  Prf_Registros        OUT Sys_Refcursor      Informaci�n recuperada
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_RECUPERA_SERV_ADIC_KONIBIT(
    Pn_PuntoId           IN NUMBER,
    Pv_Estado            IN VARCHAR2,
    Pv_Descripcion       IN VARCHAR2,
    Pv_LikeDescripcion   IN VARCHAR2,
    Pv_DescCaractServ    IN VARCHAR2,
    Prf_Registros        OUT SYS_REFCURSOR);
    
  /**
   * P_Recupera_Serv_Plan_Int_Pro
   * Procedimiento que recupera servicios en plan de internet protegido
   *
   * @param  Pn_IdServicio              IN  Number          Id servicio del cliente a procesar
   * @param  Pv_Descripcion             IN  Varchar2        Descripci�n de producto a consultar
   * @param  Pv_LikeDescripcion         IN  Varchar2        Like Descripci�n de producto a consultar
   * @param  Pv_NombreTecnicoProducto   IN  Varchar2        Nombre T�cnico del producto a revisar
   * @param  Pv_DescCaractServ          IN  Varchar2        Descripcion caracteristica servicio
   * @param  Prf_Registros              OUT Sys_Refcursor   Informaci�n recuperada
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_RECUPERA_SERV_PLAN_INT_PRO(
    Pn_IdServicio             IN NUMBER,
    Pv_Descripcion            IN VARCHAR2,
    Pv_LikeDescripcion        IN VARCHAR2,
    Pv_NombreTecnicoProducto  IN VARCHAR2,
    Pv_DescCaractServ         IN VARCHAR2,
    Prf_Registros             OUT SYS_REFCURSOR);
    
  /**
   * P_Recupera_Serv_Plan_Konibit
   * Procedimiento que recupera servicios en plan de konibit
   *
   * @param  Pn_IdServicio              IN  Number          Id servicio del cliente a procesar
   * @param  Pv_Descripcion             IN  Varchar2        Descripci�n de producto a consultar
   * @param  Pv_LikeDescripcion         IN  Varchar2        Like Descripci�n de producto a consultar
   * @param  Pv_NombreTecnicoProducto   IN  Varchar2        Nombre T�cnico del producto a revisar
   * @param  Pv_DescCaractServ          IN  Varchar2        Descripcion caracteristica servicio
   * @param  Prf_Registros              OUT Sys_Refcursor   Informaci�n recuperada
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_RECUPERA_SERV_PLAN_KONIBIT(
    Pn_IdServicio             IN NUMBER,
    Pv_Descripcion            IN VARCHAR2,
    Pv_LikeDescripcion        IN VARCHAR2,
    Pv_NombreTecnicoProducto  IN VARCHAR2,
    Pv_DescCaractServ         IN VARCHAR2,
    Prf_Registros             OUT SYS_REFCURSOR);
    
  /**
   * P_Actualizar_Servicios_Punto
   * Procedimiento que actualiza las detalles de procesos masivos a procesar en estado Procesando
   *
   * @param  Pv_Estado_Nuevo    IN  Varchar2       Estado nuevo de servicios
   * @param  Pv_Estado_Actual   IN  Varchar2       Estado Actual de servicios
   * @param  Pv_OpIntProt       IN  Varchar2       Operaci�n ejecutada en el proceso
   * @param  Pn_Punto_Id        IN  Number         Punto Id que tiene servicios adicionales a actualizar
   * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 12-09-2022
   *
   */
  PROCEDURE P_ACTUALIZAR_SERVICIOS_PUNTO(
    Pv_Estado_Nuevo     IN VARCHAR2,
    Pv_Estado_Actual    IN VARCHAR2,
    Pv_OpIntProt        IN VARCHAR2,
    Pn_Punto_Id         IN NUMBER,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2);
    
  /**
   * P_OBTENER_PM
   * Procedimiento que obtiene la respuesta en formato json utilizado posteriormente en consultas de MW
   *
   * @param  Pcl_JsonRequest    IN CLOB Par�metros por los cu�les se realizar� la consulta
   * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pcl_JsonResponse   OUT CLOB Respuesta en formato json de la consulta
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_OBTENER_PM(
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_JsonResponse    OUT CLOB);
    
  /**
   * P_PROCESAR_MW
   * Procedimiento que procesa la informaci�n de clientes de1 olt en MW
   *
   * @param  Pcl_JsonRequest    IN CLOB Par�metros por los cu�les se realizar� la consulta
   * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pcl_JsonResponse   OUT CLOB Respuesta en formato json de la consulta
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_PROCESAR_MW (
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_JsonResponse    OUT CLOB);

  /**
   * P_PROCESAR_TELCOS
   * Procedimiento que procesa la informaci�n de clientes de1 olt en TELCOS
   *
   * @param  Pcl_JsonRequest    IN CLOB Par�metros por los cu�les se realizar� la consulta
   * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   * @author Jessenia Piloso <jpiloso@telconet.ec>
   * @version 1.8 07-03-2023     Se incluye validaciones para considerar a la empresa de Ecuanet en el proceso masivo de corte.
   *
   */
  PROCEDURE P_PROCESAR_TELCOS (
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2);
      
  /**
   * P_PROCESAR_CABECERAS_PM
   * Procedimiento que procesa la informaci�n de clientes de1 olt en TELCOS
   *
   * @param  Pcl_JsonRequest    IN CLOB Par�metros por los cu�les se realizar� la consulta
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 05-09-2022
   *
   */
  PROCEDURE P_PROCESAR_CABECERAS_PM (PCL_JSONREQUEST     IN CLOB);
  
  /**
   * P_CANTIDAD_INTENTOS
   * Procedimiento que obtiene la cantidad m�xima de intentos parametrizada
   *
   * @param  Pn_CantidadIntentos    OUT NUMBER Cantidad m�xima de intentos parametrizada
   *
   * @author Jes�s Bozada <jbozada@telconet.ec>
   * @version 1.0 26-09-2022
   *
   */
  PROCEDURE P_CANTIDAD_INTENTOS(Pn_CantidadIntentos OUT NUMBER);

END INKG_PROCESOS_MASIVOS;
/