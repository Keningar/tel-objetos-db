SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION AS

  /**
   * Documentación para el procedimiento 'P_PARSEO_JSON_SOLICITUD'.
   *
   * Método encargado de parsear el JSON para actualizar la solicitud de una solución DC.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-05-2020
   */
  PROCEDURE P_PARSEO_JSON_SOLICITUD(Pcl_Request IN  CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_SOLICITUD_SOL'.
   *
   * Método encargado de actualizar la solicitud creada por los servicios de una solución DC.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 11-05-2020
   */
  PROCEDURE P_ACTUALIZAR_SOLICITUD_SOL(Pcl_Request IN  CLOB,
                                       Pv_Status   OUT VARCHAR2,
                                       Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_DETALLE_SOL_HIST'
   *
   * Método encargado de guardar un registro en la 'INFO_DETALLE_SOL_HIST' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request      IN  CLOB Recibe json request
   * @param Pn_IdDetalleHist OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status        OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje       OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_GUARDAR_DETALLE_SOL_HIST(Pcl_Request      IN  CLOB,
                                       Pn_IdDetalleHist OUT NUMBER,
                                       Pv_Status        OUT VARCHAR2,
                                       Pv_Mensaje       OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_GUARDAR_DETALLE_SOLICITUD'
   *
   * Método encargado de guardar un registro en la 'INFO_DETALLE_SOLICITUD' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request    IN  CLOB Recibe json request
   * @param Pn_IdSolicitud OUT NUMBER Retorna el id del registro creado.
   * @param Pv_Status      OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje     OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_GUARDAR_DETALLE_SOLICITUD(Pcl_Request    IN  CLOB,
                                        Pn_IdSolicitud OUT NUMBER,
                                        Pv_Status      OUT VARCHAR2,
                                        Pv_Mensaje     OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_ACTUALIZAR_DETALLE_SOLICITUD'.
   *
   * Método encargado de actualizar un registro en la 'INFO_DETALLE_SOLICITUD' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Karen Rodríguez Véliz <kyrodriguez@telconet.ec>
   * @version 1.0 01-02-2020
   */
  PROCEDURE P_ACTUALIZAR_DETALLE_SOLICITUD(Pcl_Request IN  CLOB,
                                           Pv_Status   OUT VARCHAR2,
                                           Pv_Mensaje  OUT VARCHAR2);

  /**
   * Documentación para el procedimiento 'P_CAMBIAR_ESTADO_PLANIF_SOL'.
   *
   * Método encargado de actualizar estado de la 'INFO_DETALLE_SOL_PLANIF' del esquema 'DB_COMERCIAL'.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacción.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacción.
   *
   * @author Andrés Montero H. <amontero@telconet.ec>
   * @version 1.0 20-05-2022
   */
  PROCEDURE P_CAMBIAR_ESTADO_PLANIF_SOL(Pcl_Request IN  CLOB,
                                           Pv_Status   OUT VARCHAR2,
                                           Pv_Mensaje  OUT VARCHAR2);

END CMKG_SOLICITUD_TRANSACCION;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION AS
----
----
  PROCEDURE P_PARSEO_JSON_SOLICITUD(Pcl_Request IN  CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2)
  IS

    CURSOR C_ObtenerSolicitudFact(Cn_ServicioId      NUMBER,
                                  Cv_EstadoSolicitud VARCHAR2,
                                  Cv_TipoSolicitud   VARCHAR2)
    IS
    SELECT ID_DETALLE_SOLICITUD
      FROM
        DB_COMERCIAL.ADMI_TIPO_SOLICITUD    ATS,
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
      WHERE
        ATS.ID_TIPO_SOLICITUD         = IDS.TIPO_SOLICITUD_ID
        AND ATS.DESCRIPCION_SOLICITUD = Cv_TipoSolicitud
        AND IDS.ESTADO                = Cv_EstadoSolicitud
        AND IDS.SERVICIO_ID           = Cn_ServicioId;

    Lt_JsonIndex     APEX_JSON.T_VALUES;
    Lcl_Request      CLOB;
    Lv_UsrCreacion   VARCHAR2(30);
    Lv_IpCreacion    VARCHAR2(30);
    Ln_IdServicio    NUMBER;
    Le_Exception     EXCEPTION;
    Lv_Status        VARCHAR2(50);
    Lv_Mensaje       VARCHAR2(3000);
    Lv_EstadoSolAnt  VARCHAR2(100);
    Lv_TipoSolicitud VARCHAR2(100);
    Ln_IdDetalleSol  NUMBER;

  BEGIN

    IF C_ObtenerSolicitudFact%ISOPEN THEN
      CLOSE C_ObtenerSolicitudFact;
    END IF;

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    Lv_UsrCreacion  := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion' , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion   := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'  , P_VALUES => Lt_JsonIndex);
    Ln_IdServicio   := APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'  , P_VALUES => Lt_JsonIndex);

    IF Lv_UsrCreacion IS NULL THEN
      Lv_UsrCreacion := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.usrCreacion' , P_VALUES => Lt_JsonIndex);
    END IF;

    IF Lv_IpCreacion IS NULL THEN
      Lv_IpCreacion := APEX_JSON.GET_VARCHAR2(P_PATH  => 'dataSolicitud.ipCreacion'  , P_VALUES => Lt_JsonIndex);
    END IF;

    IF Ln_IdServicio IS NULL THEN
      Ln_IdServicio := APEX_JSON.GET_VARCHAR2(P_PATH  => 'dataSolicitud.servicioId'  , P_VALUES => Lt_JsonIndex);
    END IF;

    --Id del detalle de solicitud a Actualizar.
    Ln_IdDetalleSol := APEX_JSON.GET_NUMBER(P_PATH   => 'dataSolicitud.solicitud.idDetalleSolicitud',P_VALUES => Lt_JsonIndex);

    IF Ln_IdDetalleSol IS NULL THEN

      --Estado de la solicitud a buscar.
      Lv_EstadoSolAnt  := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.estadoSolAnt'  , P_VALUES => Lt_JsonIndex);
      Lv_TipoSolicitud := APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.tipoSolicitud' , P_VALUES => Lt_JsonIndex);

      OPEN C_ObtenerSolicitudFact(Ln_IdServicio,Lv_EstadoSolAnt,Lv_TipoSolicitud);
        FETCH C_ObtenerSolicitudFact INTO Ln_IdDetalleSol;
      CLOSE C_ObtenerSolicitudFact;

    END IF;

    --Json para actualizar la solicitud de factiblidad.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('usrCreacion'    , Lv_UsrCreacion);
    APEX_JSON.WRITE('ipCreacion'     , Lv_IpCreacion);
    APEX_JSON.WRITE('estado'         , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.estado' , P_VALUES => Lt_JsonIndex));

    APEX_JSON.OPEN_OBJECT('servicioHistorial');
      APEX_JSON.WRITE('servicioId'  , Ln_IdServicio);
      APEX_JSON.WRITE('observacion' , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.servicioHistorial.observacion',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('motivoId'    , APEX_JSON.GET_NUMBER(P_PATH   => 'dataSolicitud.servicioHistorial.motivoId',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('accion'      , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.servicioHistorial.accion',
        P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;

    APEX_JSON.OPEN_OBJECT('solicitud');
      APEX_JSON.WRITE('idDetalleSolicitud'  , Ln_IdDetalleSol);
      APEX_JSON.WRITE('motivoId'            , APEX_JSON.GET_NUMBER(P_PATH   => 'dataSolicitud.solicitud.motivoId',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('precioDescuento'     , APEX_JSON.GET_NUMBER(P_PATH   => 'dataSolicitud.solicitud.precioDescuento',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('porcentajeDescuento' , APEX_JSON.GET_NUMBER(P_PATH   => 'dataSolicitud.solicitud.porcentajeDescuento',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('tipoDocumento'       , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.solicitud.tipoDocumento',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('observacion'         , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.solicitud.observacion',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('usrRechazo'          , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.solicitud.usrRechazo',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('feRechazo'           , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.solicitud.feRechazo',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('detalleProcesoId'    , APEX_JSON.GET_NUMBER(P_PATH   => 'dataSolicitud.solicitud.detalleProcesoId',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('feEjecucion'         , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.solicitud.feEjecucion',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('elementoId'          , APEX_JSON.GET_NUMBER(P_PATH   => 'dataSolicitud.solicitud.elementoId',
        P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;

    APEX_JSON.OPEN_OBJECT('historialSolicitud');
      APEX_JSON.WRITE('feIniPlan'   , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.historialSolicitud.feIniPlan',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('feFinPlan'   , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.historialSolicitud.feFinPlan',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('observacion' , APEX_JSON.GET_VARCHAR2(P_PATH => 'dataSolicitud.historialSolicitud.observacion',
        P_VALUES => Lt_JsonIndex));
      APEX_JSON.WRITE('motivoId'    , APEX_JSON.GET_NUMBER(P_PATH   => 'dataSolicitud.historialSolicitud.motivoId',
        P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;

    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    --Actualizamos la solicitud.
    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_ACTUALIZAR_SOLICITUD_SOL(Lcl_Request,Lv_Status,Lv_Mensaje);
    IF Lv_Status = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar la solicitud.');
      RAISE Le_Exception;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_PARSEO_JSON_SOLICITUD;
----
----
  PROCEDURE P_ACTUALIZAR_SOLICITUD_SOL(Pcl_Request IN  CLOB,
                                       Pv_Status   OUT VARCHAR2,
                                       Pv_Mensaje  OUT VARCHAR2)
  IS

    Lt_JsonIndex           APEX_JSON.T_VALUES;
    Le_Exception           EXCEPTION;
    Lv_Status              VARCHAR2(50);
    Lv_Mensaje             VARCHAR2(3000);
    Ln_Total               NUMBER;
    Ln_ServicioId          NUMBER;
    Ln_IdDetalleSolicitud  NUMBER;
    Ln_IdDetalleHist       NUMBER;
    Ln_IdServicioHist      NUMBER;
    Lv_UsuarioCreacion     VARCHAR2(30);
    Lv_IpCreacion          VARCHAR2(30);
    Lv_Estado              VARCHAR2(30);
    Lcl_Request            CLOB;
    Lb_HabilitaCommit      BOOLEAN;

  BEGIN

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);

    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'Json vacio.';
      RAISE Le_Exception;
    END IF;

    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'servicioHistorial' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'No se encuentran datos dentro del atributo servicioHistorial.';
      RAISE Le_Exception;
    END IF;

    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'solicitud' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'No se encuentran datos dentro del atributo solicitud.';
      RAISE Le_Exception;
    END IF;

    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => 'historialSolicitud' , P_VALUES => Lt_JsonIndex);

    IF Ln_Total < 1 OR Ln_Total IS NULL THEN
      Lv_Mensaje := 'No se encuentran datos dentro del atributo historialSolicitud.';
      RAISE Le_Exception;
    END IF;    

    --Datos principales.
    Lb_HabilitaCommit     := APEX_JSON.GET_BOOLEAN(P_PATH  => 'habilitaCommit' , P_VALUES => Lt_JsonIndex);
    Lv_Estado             := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'         , P_VALUES => Lt_JsonIndex);
    Lv_UsuarioCreacion    := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'    , P_VALUES => Lt_JsonIndex);
    Lv_IpCreacion         := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'     , P_VALUES => Lt_JsonIndex);
    Ln_ServicioId         := APEX_JSON.GET_NUMBER(P_PATH   => 'servicioHistorial.servicioId' , P_VALUES => Lt_JsonIndex);
    Ln_IdDetalleSolicitud := APEX_JSON.GET_NUMBER(P_PATH   => 'solicitud.idDetalleSolicitud' , P_VALUES => Lt_JsonIndex);

    IF Lb_HabilitaCommit IS NULL THEN
      Lb_HabilitaCommit := FALSE;
    END IF;

    --Json para actualizar el detalle de la solicitud.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idDetalleSolicitud'  , Ln_IdDetalleSolicitud);
    APEX_JSON.WRITE('estado'              , Lv_Estado);
    APEX_JSON.WRITE('motivoId'            , APEX_JSON.GET_NUMBER(P_PATH   => 'solicitud.motivoId' ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('precioDescuento'     , APEX_JSON.GET_NUMBER(P_PATH   => 'solicitud.precioDescuento' ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('porcentajeDescuento' , APEX_JSON.GET_NUMBER(P_PATH   => 'solicitud.porcentajeDescuento',P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('tipoDocumento'       , APEX_JSON.GET_VARCHAR2(P_PATH => 'solicitud.tipoDocumento' ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('observacion'         , APEX_JSON.GET_VARCHAR2(P_PATH => 'solicitud.observacion' ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('usrRechazo'          , APEX_JSON.GET_VARCHAR2(P_PATH => 'solicitud.usrRechazo' ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('feRechazo'           , APEX_JSON.GET_VARCHAR2(P_PATH => 'solicitud.feRechazo' ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('detalleProcesoId'    , APEX_JSON.GET_NUMBER(P_PATH   => 'solicitud.detalleProcesoId',P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('feEjecucion'         , APEX_JSON.GET_VARCHAR2(P_PATH => 'solicitud.feEjecucion',P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('elementoId'          , APEX_JSON.GET_NUMBER(P_PATH   => 'solicitud.elementoId',P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_ACTUALIZAR_DETALLE_SOLICITUD(Lcl_Request,Lv_Status,Lv_Mensaje);

    IF Lv_Status  = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar el detalle de solicitud.');
      RAISE Le_Exception;
    END IF;

    --Json para crear el historial de la solicitud.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('detalleSolicitudId', Ln_IdDetalleSolicitud);
    APEX_JSON.WRITE('estado'            , Lv_Estado);
    APEX_JSON.WRITE('usrCreacion'       , Lv_UsuarioCreacion);
    APEX_JSON.WRITE('ipCreacion'        , Lv_IpCreacion);
    APEX_JSON.WRITE('feIniPlan'         , APEX_JSON.GET_VARCHAR2(P_PATH => 'historialSolicitud.feIniPlan'  ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('feFinPlan'         , APEX_JSON.GET_VARCHAR2(P_PATH => 'historialSolicitud.feFinPlan'  ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('observacion'       , APEX_JSON.GET_VARCHAR2(P_PATH => 'historialSolicitud.observacion',P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('motivoId'          , APEX_JSON.GET_VARCHAR2(P_PATH => 'historialSolicitud.motivoId'   ,P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_GUARDAR_DETALLE_SOL_HIST(Lcl_Request,Ln_IdDetalleHist,Lv_Status,Lv_Mensaje);

    IF Lv_Status  = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear el historial de la solicitud.');
      RAISE Le_Exception;
    END IF;

    --Json para actualizar el servicio.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idServicio' , Ln_ServicioId);
    APEX_JSON.WRITE('estado'     , Lv_Estado);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION.P_ACTUALIZAR_SERVICIO(Lcl_Request,Lv_Status,Lv_Mensaje);

    IF Lv_Status  = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al actualizar el servicio.');
      RAISE Le_Exception;
    END IF;

    --Json para crear el historial del servicio.
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('servicioId'  , Ln_ServicioId);
    APEX_JSON.WRITE('estado'      , Lv_Estado);
    APEX_JSON.WRITE('usrCreacion' , Lv_UsuarioCreacion);
    APEX_JSON.WRITE('ipCreacion'  , Lv_IpCreacion);
    APEX_JSON.WRITE('motivoId'    , APEX_JSON.GET_NUMBER(P_PATH   => 'servicioHistorial.motivoId',P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('observacion' , APEX_JSON.GET_VARCHAR2(P_PATH => 'servicioHistorial.observacion',P_VALUES => Lt_JsonIndex));
    APEX_JSON.WRITE('accion'      , APEX_JSON.GET_VARCHAR2(P_PATH => 'servicioHistorial.accion',P_VALUES => Lt_JsonIndex));
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION.P_GUARDAR_SERVICIO_HISTORIAL(Lcl_Request,Ln_IdServicioHist,Lv_Status,Lv_Mensaje);

    IF Lv_Status  = 'ERROR' THEN
      Lv_Mensaje := NVL(Lv_Mensaje,'Error al crear el historial del servicio.');
      RAISE Le_Exception;
    END IF;

    IF Lb_HabilitaCommit THEN
      COMMIT;
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ACTUALIZAR_SOLICITUD_SOL;
----
----
  PROCEDURE P_GUARDAR_DETALLE_SOL_HIST(Pcl_Request      IN  CLOB,
                                       Pn_IdDetalleHist OUT NUMBER,
                                       Pv_Status        OUT VARCHAR2,
                                       Pv_Mensaje       OUT VARCHAR2)
  IS

    Ln_IdSolicitudHist NUMBER;
    Le_Exception       EXCEPTION;
    Lv_Mensaje         VARCHAR2(3000);

  BEGIN

    APEX_JSON.PARSE(Pcl_Request);

    IF APEX_JSON.GET_NUMBER(P_PATH   => 'detalleSolicitudId') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion')        IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')             IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion')        IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion')         IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (solicitudId,observacion,estado,usrCreacion,ipCreacion)';
      RAISE Le_Exception;
    END IF;

    Ln_IdSolicitudHist := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;

    INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST (
      ID_SOLICITUD_HISTORIAL,
      DETALLE_SOLICITUD_ID,
      ESTADO,
      FE_INI_PLAN,
      FE_FIN_PLAN,
      OBSERVACION,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION,
      MOTIVO_ID
    ) VALUES (
      Ln_idSolicitudHist,
      APEX_JSON.GET_NUMBER(P_PATH   => 'detalleSolicitudId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'feIniPlan'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'feFinPlan'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      SYSDATE,
      APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'motivoId')
    );

    Pv_Status        := 'OK';
    Pv_Mensaje       := 'Transación exitosa';
    Pn_IdDetalleHist :=  Ln_IdSolicitudHist;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status        := 'ERROR';
      Pv_Mensaje       :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdDetalleHist :=  0;
    WHEN OTHERS THEN
      Pv_Status        := 'ERROR';
      Pv_Mensaje       :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdDetalleHist :=  0;

  END P_GUARDAR_DETALLE_SOL_HIST;
----
----
  PROCEDURE P_GUARDAR_DETALLE_SOLICITUD(Pcl_Request    IN  CLOB,
                                        Pn_IdSolicitud OUT NUMBER,
                                        Pv_Status      OUT VARCHAR2,
                                        Pv_Mensaje     OUT VARCHAR2)
  IS

    Ln_IdSolicitud  NUMBER;
    Le_Exception    EXCEPTION;
    Lv_Mensaje      VARCHAR2(3000);

  BEGIN

    APEX_JSON.PARSE(Pcl_Request);

    IF APEX_JSON.GET_NUMBER(P_PATH    => 'servicioId')      IS NULL OR
       APEX_JSON.GET_NUMBER(P_PATH    => 'tipoSolicitudId') IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH  => 'estado')          IS NULL OR
       APEX_JSON.GET_VARCHAR2(P_PATH  => 'usrCreacion')     IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (servicioId,tipoSolicitudId,estado,usrCreacion)';
      RAISE Le_Exception;
    END IF;

    Ln_idSolicitud := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL;

    INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD (
      ID_DETALLE_SOLICITUD,
      SERVICIO_ID,
      TIPO_SOLICITUD_ID,
      MOTIVO_ID,
      USR_CREACION,
      FE_CREACION,
      PRECIO_DESCUENTO,
      PORCENTAJE_DESCUENTO,
      TIPO_DOCUMENTO,
      OBSERVACION,
      ESTADO,
      USR_RECHAZO,
      FE_RECHAZO,
      DETALLE_PROCESO_ID,
      FE_EJECUCION,
      ELEMENTO_ID
    ) VALUES (
      Ln_idSolicitud,
      APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'tipoSolicitudId'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'motivoId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion'),
      SYSDATE,
      APEX_JSON.GET_NUMBER(P_PATH   => 'precioDescuento'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'porcentajeDescuento'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoDocumento'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'usrRechazo'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'feRechazo'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'detalleProcesoId'),
      APEX_JSON.GET_VARCHAR2(P_PATH => 'feEjecucion'),
      APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId')
    );

    Pv_Status      := 'OK';
    Pv_Mensaje     := 'Transación exitosa';
    Pn_IdSolicitud :=  Ln_IdSolicitud;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status      := 'ERROR';
      Pv_Mensaje     :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdSolicitud :=  0;
    WHEN OTHERS THEN
      Pv_Status      := 'ERROR';
      Pv_Mensaje     :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
      Pn_IdSolicitud :=  0;

  END P_GUARDAR_DETALLE_SOLICITUD;
----
----
  PROCEDURE P_ACTUALIZAR_DETALLE_SOLICITUD(Pcl_Request IN  CLOB,
                                           Pv_Status   OUT VARCHAR2,
                                           Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursores Locales
    CURSOR C_ExisteDetalleSolicitud(Cn_IdDetalleSolicitud NUMBER)
    IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD
      WHERE ID_DETALLE_SOLICITUD = Cn_IdDetalleSolicitud;

    --Variables Locales.
    Lv_Mensaje                 VARCHAR2(3000);
    Le_Exception               EXCEPTION;
    Ln_IdDetalleSolicitud      NUMBER;
    Ln_ExisteDetalleSolicitud  NUMBER;

  BEGIN

    IF C_ExisteDetalleSolicitud%ISOPEN THEN
      CLOSE C_ExisteDetalleSolicitud;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdDetalleSolicitud := APEX_JSON.GET_NUMBER(P_PATH => 'idDetalleSolicitud');

    --Validación.
    IF Ln_IdDetalleSolicitud IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idDetalleSolicitud)';
      RAISE Le_Exception;
    END IF;

    OPEN C_ExisteDetalleSolicitud(Ln_IdDetalleSolicitud);
      FETCH C_ExisteDetalleSolicitud INTO Ln_ExisteDetalleSolicitud;
    CLOSE C_ExisteDetalleSolicitud;

    IF Ln_ExisteDetalleSolicitud < 1 THEN
      Lv_Mensaje := 'No existe la solicitud con el id('||Ln_IdDetalleSolicitud||')';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
      SET SERVICIO_ID          = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'servicioId')          , SERVICIO_ID),
          TIPO_SOLICITUD_ID    = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'tipoSolicitudId')     , TIPO_SOLICITUD_ID),
          MOTIVO_ID            = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'motivoId')            , MOTIVO_ID),
          PRECIO_DESCUENTO     = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'precioDescuento')     , PRECIO_DESCUENTO),
          PORCENTAJE_DESCUENTO = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'porcentajeDescuento') , PORCENTAJE_DESCUENTO),
          TIPO_DOCUMENTO       = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoDocumento')       , TIPO_DOCUMENTO),
          OBSERVACION          = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion')         , OBSERVACION),
          ESTADO               = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'estado')              , ESTADO),
          USR_RECHAZO          = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'usrRechazo')          , USR_RECHAZO),
          FE_RECHAZO           = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'feRechazo')           , FE_RECHAZO),
          DETALLE_PROCESO_ID   = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'detalleProcesoId')    , DETALLE_PROCESO_ID),
          FE_EJECUCION         = NVL(APEX_JSON.GET_VARCHAR2(P_PATH => 'feEjecucion')         , FE_EJECUCION),
          ELEMENTO_ID          = NVL(APEX_JSON.GET_NUMBER(P_PATH   => 'elementoId')          , ELEMENTO_ID)
    WHERE ID_DETALLE_SOLICITUD = Ln_IdDetalleSolicitud;

    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_ACTUALIZAR_DETALLE_SOLICITUD;



  PROCEDURE P_CAMBIAR_ESTADO_PLANIF_SOL(Pcl_Request IN  CLOB,
                                           Pv_Status   OUT VARCHAR2,
                                           Pv_Mensaje  OUT VARCHAR2)
  IS
    --Cursores Locales
    CURSOR C_GetDetalleSolPlanif(Cn_IdDetalleSolPlanif NUMBER)
    IS
      SELECT DSP.ID_DETALLE_SOL_PLANIF, DS.ID_DETALLE_SOLICITUD, DS.ESTADO 
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF DSP 
      JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS ON DS.ID_DETALLE_SOLICITUD = DSP.DETALLE_SOLICITUD_ID
      WHERE DSP.ID_DETALLE_SOL_PLANIF = Cn_IdDetalleSolPlanif;

    CURSOR C_CantidadPlanifActivas(Cn_IdDetalleSolicitud NUMBER)
    IS
      SELECT COUNT(*) FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF SP
      WHERE SP.DETALLE_SOLICITUD_ID = Cn_IdDetalleSolicitud AND SP.ESTADO NOT IN ('Finalizada','Cancelada','Anulada');

    CURSOR C_GetUltimoDetPlanifHist(Cn_idDetalleSolPla DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ID_DETALLE_SOL_PLANIF%TYPE)
    IS
      SELECT idh1.* FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST idh1
      WHERE
      ID_DETALLE_SOL_PLANIF_HIST =
      (
            SELECT MAX(idh.ID_DETALLE_SOL_PLANIF_HIST)
            FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST idh WHERE idh.DETALLE_SOL_PLANIF_ID = Cn_idDetalleSolPla
      );

    CURSOR C_GetPenultimoDetPlanHist(Cn_idDetalleSolPla DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ID_DETALLE_SOL_PLANIF%TYPE)
    IS
      SELECT * FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST idh1
      WHERE
      ID_DETALLE_SOL_PLANIF_HIST =
      (
        SELECT MIN(idh1.ID_DETALLE_SOL_PLANIF_HIST)
        FROM 
        (SELECT *
            FROM (
              SELECT idh.ID_DETALLE_SOL_PLANIF_HIST
                  FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST idh
                  WHERE  idh.DETALLE_SOL_PLANIF_ID = Cn_idDetalleSolPla
                  ORDER BY idh.ID_DETALLE_SOL_PLANIF_HIST DESC
              ) WHERE rownum <= 2) idh1
      );

    CURSOR C_GetUltimoDetSolHist(Cn_idDetalleSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    IS
      SELECT idh1.* FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST idh1
      WHERE
      ID_SOLICITUD_HISTORIAL =
      (
            SELECT MAX(idh.ID_SOLICITUD_HISTORIAL)
            FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST idh WHERE idh.DETALLE_SOLICITUD_ID = Cn_idDetalleSolicitud
      );

    CURSOR C_GetPenultimoDetSolHist(Cn_idDetalleSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    IS
      SELECT * FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST idh1
      WHERE
      ID_SOLICITUD_HISTORIAL =
      (
        SELECT MIN(idh1.ID_SOLICITUD_HISTORIAL)
        FROM 
        (SELECT *
            FROM (
              SELECT idh.ID_SOLICITUD_HISTORIAL
                  FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST idh
                  WHERE  idh.DETALLE_SOLICITUD_ID = Cn_idDetalleSolicitud
                  ORDER BY idh.ID_SOLICITUD_HISTORIAL DESC
              ) WHERE rownum <= 2) idh1
      );

    --Variables Locales.
    Lv_Mensaje                VARCHAR2(3000);
    Le_Exception              EXCEPTION;
    Ln_IdDetalleSolPlanif     NUMBER;
    Ln_IdDetalleSolicitud     NUMBER;
    Lv_EstadoSolicitud        VARCHAR2(20);
    Lv_Estado                 VARCHAR2(20);
    Lv_Accion                 VARCHAR2(40);
    Lv_UsrCreacion            VARCHAR2(40);
    Lv_Observacion            VARCHAR2(3000);
    Lv_IpCreacion             VARCHAR2(20);

    Ln_ExistePlanifActivas    NUMBER := 0;

    Lc_RequestDetalleSol      CLOB;
    Lv_StatusDetalleSol       VARCHAR2(200);
    Lv_MensajeDetalleSol      VARCHAR2(200);

    Lc_RequestDetSolHist      CLOB;
    Lv_StatusDetSolHist       VARCHAR2(200);
    Lv_MensajeDetSolHist      VARCHAR2(200);

    Ln_IdDetalleSolHist       NUMBER := 0;

    Lr_InfoDetSolPlaHistAnt DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST%ROWTYPE;
    Lr_InfoDetSolPlaHistUlt DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST%ROWTYPE;
    Lr_InfoDetalleSolHistAnt DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lr_InfoDetalleSolHistUlt DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
  BEGIN

    IF C_GetDetalleSolPlanif%ISOPEN THEN
      CLOSE C_GetDetalleSolPlanif;
    END IF;
    IF C_CantidadPlanifActivas%ISOPEN THEN
      CLOSE C_CantidadPlanifActivas;
    END IF;

    --Parse del JSON.
    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdDetalleSolPlanif := APEX_JSON.GET_NUMBER(P_PATH => 'idDetalleSolPlanif');
    Lv_Estado             := APEX_JSON.GET_VARCHAR2(P_PATH => 'estado');
    Lv_Accion             := APEX_JSON.GET_VARCHAR2(P_PATH => 'accion');
    Lv_UsrCreacion        := APEX_JSON.GET_VARCHAR2(P_PATH => 'usrCreacion');
    Lv_IpCreacion         := APEX_JSON.GET_VARCHAR2(P_PATH => 'ipCreacion');
    Lv_Observacion        := APEX_JSON.GET_VARCHAR2(P_PATH => 'observacion');

    --Validación.
    IF Ln_IdDetalleSolPlanif IS NULL THEN
      Lv_Mensaje := 'Ningún valor puede ir nulo (idDetalleSolPlanif)';
      RAISE Le_Exception;
    END IF;

    OPEN C_GetDetalleSolPlanif(Ln_IdDetalleSolPlanif);
      FETCH C_GetDetalleSolPlanif INTO Ln_IdDetalleSolPlanif, Ln_IdDetalleSolicitud, Lv_EstadoSolicitud;
    CLOSE C_GetDetalleSolPlanif;

    IF Ln_IdDetalleSolPlanif IS NULL THEN
      Lv_Mensaje := 'No existe la planificación de solicitud con el id('||Ln_IdDetalleSolPlanif||')';
      RAISE Le_Exception;
    END IF;

    IF Lv_Accion = 'CAMBIAR_ESTADO' THEN

      --ACTUALIZA LA PLANIFICACION DE LA SOLICITUD
      UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF
        SET 
            ESTADO               = NVL(Lv_Estado     , ESTADO),
            USR_ULT_MOD          = NVL(Lv_UsrCreacion , USR_ULT_MOD),
            FE_ULT_MOD           = SYSDATE
      WHERE ID_DETALLE_SOL_PLANIF = Ln_IdDetalleSolPlanif;

      --INGRESA HISTORIAL EN LA PLANIFICACION DE LA SOLICITUD
      INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST (
        ID_DETALLE_SOL_PLANIF_HIST,
        DETALLE_SOL_PLANIF_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        OBSERVACION,
        ESTADO
      ) VALUES (
        DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_PLANIF_HI.NEXTVAL,
        Ln_IdDetalleSolPlanif,
        Lv_UsrCreacion,
        SYSDATE,
        Lv_IpCreacion,
        Lv_Observacion,
        Lv_Estado
      );

      --CONSULTA LAS PLANIFICACIONES ACTIVAS
      OPEN C_CantidadPlanifActivas(Ln_IdDetalleSolicitud);
        FETCH C_CantidadPlanifActivas INTO Ln_ExistePlanifActivas;
      CLOSE C_CantidadPlanifActivas;

      --SI LA SOLICITUD YA NO TIENE PLANIFICACIONES ACTIVAS SE FINALIZA SOLICITUD
      IF Ln_ExistePlanifActivas < 1 THEN

          --CAMBIA ESTADO A SOLICITUD
          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('idDetalleSolicitud'  , Ln_IdDetalleSolicitud);
          APEX_JSON.WRITE('estado', Lv_Estado);
          APEX_JSON.CLOSE_OBJECT;
          Lc_RequestDetalleSol := APEX_JSON.GET_CLOB_OUTPUT;
          APEX_JSON.FREE_OUTPUT;

          DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_ACTUALIZAR_DETALLE_SOLICITUD(Lc_RequestDetalleSol, Lv_StatusDetalleSol, Lv_MensajeDetalleSol);

          --INGRESA HISTORIAL EN SOLICITUD
          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('detalleSolicitudId', Ln_IdDetalleSolicitud);
          APEX_JSON.WRITE('estado'            , Lv_Estado);
          APEX_JSON.WRITE('usrCreacion'       , Lv_UsrCreacion);
          APEX_JSON.WRITE('ipCreacion'        , Lv_IpCreacion);
          APEX_JSON.WRITE('observacion'       , Lv_Observacion);
          APEX_JSON.CLOSE_OBJECT;
          Lc_RequestDetSolHist := APEX_JSON.GET_CLOB_OUTPUT;
          APEX_JSON.FREE_OUTPUT;

          DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION.P_GUARDAR_DETALLE_SOL_HIST(
            Lc_RequestDetSolHist,Ln_IdDetalleSolHist,Lv_StatusDetSolHist,Lv_MensajeDetSolHist);

      END IF;
    ELSIF  Lv_Accion = 'REVERSAR' THEN

      --CONSULTAR PENULTIMO ESTADO DE PLANIFICACION DE SOLICITUD
      OPEN C_GetPenultimoDetPlanHist(Ln_IdDetalleSolPlanif);
      FETCH C_GetPenultimoDetPlanHist INTO Lr_InfoDetSolPlaHistAnt;
      CLOSE C_GetPenultimoDetPlanHist;
      --ELIMINAR HISTORIAL DE PLANIFICACION DE SOLICITUD
      OPEN C_GetUltimoDetPlanifHist(Ln_IdDetalleSolPlanif);
      FETCH C_GetUltimoDetPlanifHist INTO Lr_InfoDetSolPlaHistUlt;
      CLOSE C_GetUltimoDetPlanifHist;

      DELETE FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST WHERE ID_DETALLE_SOL_PLANIF_HIST = Lr_InfoDetSolPlaHistUlt.ID_DETALLE_SOL_PLANIF_HIST;

      --ACTUALIZAR PLANIFICACION DE SOLICITUD
      UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF SET 
            ESTADO = Lr_InfoDetSolPlaHistAnt.ESTADO,
            FE_ULT_MOD = Lr_InfoDetSolPlaHistAnt.FE_CREACION,
            USR_ULT_MOD = Lr_InfoDetSolPlaHistAnt.USR_CREACION
      WHERE ID_DETALLE_SOL_PLANIF = Ln_IdDetalleSolPlanif;

      IF UPPER(Lv_EstadoSolicitud) = 'FINALIZADA' THEN
            --CONSULTAR PENULTIMO HISTORIAL DE SOLICITUD
            OPEN C_GetPenultimoDetSolHist(Ln_IdDetalleSolicitud);
            FETCH C_GetPenultimoDetSolHist INTO Lr_InfoDetalleSolHistAnt;
            CLOSE C_GetPenultimoDetSolHist;
            --CONSULTAR ULTIMO HISTORIAL DE SOLICITUD
            OPEN C_GetUltimoDetSolHist(Ln_IdDetalleSolicitud);
            FETCH C_GetUltimoDetSolHist INTO Lr_InfoDetalleSolHistUlt;
            CLOSE C_GetUltimoDetSolHist;

            --ELIMINAR HISTORIAL DE SOLICITUD
            DELETE FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST WHERE ID_SOLICITUD_HISTORIAL = Lr_InfoDetalleSolHistUlt.ID_SOLICITUD_HISTORIAL;

            --ACTUALIZAR SOLICITUD
            UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD SET 
            ESTADO = Lr_InfoDetalleSolHistAnt.ESTADO
            WHERE ID_DETALLE_SOLICITUD = Ln_IdDetalleSolicitud;
      END IF;

    END IF;
    
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transación exitosa';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(Lv_Mensaje||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje :=  SUBSTR(SQLERRM   ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,3000);

  END P_CAMBIAR_ESTADO_PLANIF_SOL;

----
----
END CMKG_SOLICITUD_TRANSACCION;
/
