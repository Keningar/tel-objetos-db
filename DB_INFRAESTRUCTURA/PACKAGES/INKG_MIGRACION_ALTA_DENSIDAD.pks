CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD
AS
  /*
  * Documentación para TYPE 'Lr_InfoServiciosMigracion'.
  *
  * Tipo de datos para el retorno de la información correspondiente a los servicios a migrar
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  */
TYPE LR_INFOSERVICIOSMIGRACION
IS
  RECORD
  (
    IDSERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    IDPUNTO DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
    ESTADOSERVICIO DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    LOGINAUX DB_COMERCIAL.INFO_SERVICIO.LOGIN_AUX%TYPE,
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    IDPRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    NOMBRETECNICO DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    DESCRIPCIONPRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    IDPRODUCTOUNO DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    NOMBRETECNICOUNO DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    DESCRIPCIONPRODUCTOUNO DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    CODEMPRESA DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    PREFIJO DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    NOMBRECOMPLETO VARCHAR2(1000),
    IDPLAN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    NOMBREPLAN DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
    IDELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBREMARCAELEMENTO DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE,
    NOMBREELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    IP DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE,
    NOMBREINTERFACEELEMENTO DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
    IDINTERFACEELEMENTO DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE,
    TIPOPRODUCTO VARCHAR2(50),
    REFIDSERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ACTUALIZASPID VARCHAR2(10),
    SPID DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    LINEPROFILENAME DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE );
  /*
  * Documentación para TYPE 'Lt_InfoServiciosMigracion'.
  *
  * Tabla para almacenar la data enviada con la información correspondiente a las cabeceras de migración
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  */
TYPE LT_INFOSERVICIOSMIGRACION
IS
  TABLE OF LR_INFOSERVICIOSMIGRACION INDEX BY PLS_INTEGER;
  /*
  * Documentación para TYPE 'Lr_ElementosMigraOlt'.
  *
  * Tipo de datos para el retorno de la información correspondiente a los elementos a migrar
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  */
TYPE LR_ELEMENTOSMIGRAOLT
IS
  RECORD
  (
    IDELEMENTOA DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    IDELEMENTOB DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE );
  /*
  * Documentación para TYPE 'Lt_ElementosMigraOlt'.
  *
  * Tabla para almacenar la data enviada con la información correspondiente a los elementos a migrar
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  */
TYPE LT_ELEMENTOSMIGRAOLT
IS
  TABLE OF LR_ELEMENTOSMIGRAOLT INDEX BY PLS_INTEGER;
  /*
  * Documentación para TYPE 'Lr_InfoCabeceraMigracion'.
  *
  * Tipo de datos para el retorno de la información correspondiente a las cabeceras de migración
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  */
TYPE LR_INFOCABECERAMIGRACION
IS
  RECORD
  (
    IDMIGRACIONCAB DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.ID_MIGRACION_CAB%TYPE,
    ESTADO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.ESTADO%TYPE );
  /*
  * Documentación para TYPE 'Lt_InfoCabeceraMigracion'.
  *
  * Tabla para almacenar la data enviada con la información correspondiente a las cabeceras de migración
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  */
TYPE LT_INFOCABECERAMIGRACION
IS
  TABLE OF LR_INFOCABECERAMIGRACION INDEX BY PLS_INTEGER;
  /*
  * Documentación para TYPE 'Lr_InfoDetalleMigracion'.
  *
  * Tipo de datos para el retorno de la información correspondiente a los detalles de migración
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  */
TYPE LR_INFODETALLEMIGRACION
IS
  RECORD
  (
    IDMIGRACIONDET DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ID_MIGRACION_DET%TYPE,
    MIGRACIONCABID DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.MIGRACION_CAB_ID%TYPE,
    TIPOREGISTRO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.TIPO_REGISTRO%TYPE,
    OLTORDENMIGRACION DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.OLT_ORDEN_MIGRACION%TYPE,
    OLTVALORNUMERICO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.OLT_VALOR_NUMERICO%TYPE,
    ELEMENTOA DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ELEMENTO_A%TYPE,
    TIPOELEMENTOA DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.TIPO_ELEMENTO_A%TYPE,
    INTERFACEELEMENTOA DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.INTERFACE_ELEMENTO_A%TYPE,
    CLASETIPOMEDIO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.CLASE_TIPO_MEDIO%TYPE,
    BUFFER DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.BUFFER%TYPE,
    HILO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.HILO%TYPE,
    ELEMENTOB DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ELEMENTO_B%TYPE,
    TIPOELEMENTOB DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.TIPO_ELEMENTO_B%TYPE,
    INTERFACEELEMENTOB DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.INTERFACE_ELEMENTO_B%TYPE,
    ESTADO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ESTADO%TYPE,
    OBSERVACION DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.OBSERVACION%TYPE,
    USRCREACION DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.USR_CREACION%TYPE,
    FECREACION DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.FE_CREACION%TYPE,
    USRULTMOD DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.USR_ULT_MOD%TYPE,
    FEULTMOD DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.FE_ULT_MOD%TYPE);
  /*
  * Documentación para TYPE 'Lt_InfoDetalleMigracion'.
  *
  * Tabla para almacenar la data enviada con la información correspondiente a los detalles de migración
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  */
TYPE LT_INFODETALLEMIGRACION
IS
  TABLE OF LR_INFODETALLEMIGRACION INDEX BY PLS_INTEGER;

/**
  * Documentacion para el procedimiento P_WEB_SERVICE_BR
  *
  * Método encargado del consumo de webservice con request y response de gran tamaño (BIG REQUEST), se creo este
  * método para evitar alguna afectación con procesos que usaban el método anterior existente
  *
  * @param Pv_Url             IN  NUMBER   Recibe la url del webservice
  * @param Pcl_Mensaje        IN  VARCHAR2 Recibe el mensaje en formato JSON,XML,ETC
  * @param Pv_Application     IN  VARCHAR2 Recibe el content type por ejemplo (application/json)
  * @param Pv_Charset         IN  VARCHAR2 Recibe el charset en el que se envia el mensaje
  * @param Pv_UrlFileDigital  IN  VARCHAR2 Ruta del certificado digital
  * @param Pv_PassFileDigital IN  VARCHAR2 contraseña para acceder al certificado digital
  * @param Pn_TimeOut         IN  NUMBER   Timeout de proceso
  * @param Pv_Respuesta       OUT VARCHAR2 Retorna la respuesta del webservice
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 10-11-2022
  * 
  * @author Jesús Bozada
  * @version 1.1 13-12-2022  Se quita lína con "UTL_HTTP.set_persistent_conn_support" ya que causa problemas al
  *                          comunicarnos con WS GDA y utilizar el header  'Transfer-Encoding', 'chunked'
  */ 
  PROCEDURE P_WEB_SERVICE_BR(
      Pv_Url             IN  VARCHAR2,
      Pcl_Mensaje        IN  CLOB,
      Pv_Application     IN  VARCHAR2,
      Pv_Charset         IN  VARCHAR2,
      Pv_UrlFileDigital  IN  VARCHAR2,
      Pv_PassFileDigital IN  VARCHAR2,
      Pn_TimeOut         IN  NUMBER,
      Pcl_Respuesta      OUT CLOB,
      Pv_Error           OUT VARCHAR2);
  /**
  * P_OBTENER_CAB_MIGRACION
  * Procedimiento que obtiene la respuesta en formato json utilizado posteriormente en el proceso
  *
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  * @param  Prf_Registros      OUT SYS_REFCURSOR  Respuesta en formato json de la consulta
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 31-01-2023
  *
  */
  PROCEDURE P_OBTENER_CABECERAS(
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PRF_REGISTROS OUT SYS_REFCURSOR);
  /**
  * Procedimeinto que permite actualizar los estado de la tabla de datos adiocionales de migracion y cabecera
  *
  * @param  PV_ESTADO_ERR_CAB   IN  VARCHAR2  Estado de error o Pendiente de la cabecera de migracion
  * @param  PV_MENSAJE_CAB      IN VARCHAR2  Mensaje del proceso
  * @param  PV_TIPO_CAB         IN VARCHAR2  Tipo de cabecera ReportePrevio
  * @param  PV_ESTADO_CAB       IN VARCHAR2  Estado Ok de la cabecera de migracion
  * @param  PV_ESTADO_DATA_ERR  IN VARCHAR2  Estado Error de la cabecera de tabla de datos adicionales de migracion
  * @param  PV_MENSAJE_DATA     IN VARCHAR2  Mensaje del proceso para actualizar tabla de datos adicionales de migracion
  * @param  PV_TIPO_DATA        IN VARCHAR2  Tipo de cabecera tabla de datos adicionales de migracion ReportePrevio ReportePosterior
  * @param  PV_ESTADO_DATA      IN VARCHAR2  Estado de table detalle de migracion
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_ACTUALIZA_TABLA_MIGRACION(
      PV_ESTADO_ERR_CAB  VARCHAR2,
      PV_MENSAJE_CAB     VARCHAR2,
      PV_TIPO_CAB        VARCHAR2,
      PV_ESTADO_CAB      VARCHAR2,
      PV_ESTADO_DATA_ERR VARCHAR2,
      PV_MENSAJE_DATA    VARCHAR2,
      PV_TIPO_DATA       VARCHAR2,
      PV_ESTADO_DATA     VARCHAR2 );
  /**
  * P_ACTUALIZAR_DETALLES
  * Procedimiento que actualiza los detalles de migración a procesar en estado enviado por parámetro
  *
  * @param  Pn_IdMigracionCab  IN  NUMBER         Id de cabecera del proceso
  * @param  Pv_TipoRegistro    IN  VARCHAR2       Tipo registro
  * @param  Pv_EstadoActual    IN  VARCHAR2       Estado Actual
  * @param  Pv_EstadoNuevo     IN  VARCHAR2       Estado Nuevo
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 31-01-2023
  *
  */
  PROCEDURE P_ACTUALIZAR_DETALLES(
      PN_IDMIGRACIONCAB IN NUMBER,
      PV_TIPOREGISTRO   IN VARCHAR2,
      PV_ESTADOACTUAL   IN VARCHAR2,
      PV_ESTADONUEVO    IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_ACTUALIZAR_DETALLE
  * Procedimiento que actualiza el detalle de migración a procesar en estado enviado por parámetro
  *
  * @param  Pn_IdMigracionDet  IN  NUMBER         Id de cabecera del proceso
  * @param  Pv_TipoRegistro    IN  VARCHAR2       Tipo registro
  * @param  Pv_EstadoActual    IN  VARCHAR2       Estado Actual
  * @param  Pv_EstadoNuevo     IN  VARCHAR2       Estado Nuevo
  * @param  Pv_Observacion     IN  VARCHAR2       Observacion a registrar
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 31-01-2023
  *
  */
  PROCEDURE P_ACTUALIZAR_DETALLE(
      PN_IDMIGRACIONDET IN NUMBER,
      PV_TIPOREGISTRO   IN VARCHAR2,
      PV_ESTADOACTUAL   IN VARCHAR2,
      PV_ESTADONUEVO    IN VARCHAR2,
      PV_OBSERVACION    IN VARCHAR2);
  /**
  * P_OBTENER_CARACT_MW
  * Procedimiento que obtiene perfiles de WS GDA con información de perfiles ZTE
  *
  * @param  Pv_Status          OUT  VARCHAR2    Estado de proceso
  * @param  Pv_Mensaje         OUT  VARCHAR2    Mensaje de proceso
  * @param  Pcl_JsonResponse   OUT  CLOB        Json con respuesta de proceso
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 31-01-2023
  *
  */
  PROCEDURE P_OBTENER_CARACT_MW(
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PCL_JSONRESPONSE OUT CLOB);
  /**
  * P_OBTENER_CAB_MIGRACION
  * Procedimiento que obtiene la respuesta en formato json utilizado posteriormente en el proceso
  *
  * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
  * @param  Pcl_JsonResponse   OUT CLOB Respuesta en formato json de la consulta
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 31-01-2023
  *
  */
  PROCEDURE P_OBTENER_CAB_MIGRACION(
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PCL_JSONRESPONSE OUT CLOB);
  /**
  * P_ACTUALIZAR_CABECERA
  * Procedimiento que actualiza las cabeceras de migración a procesar en estado enviado por parámetro
  *
  * @param  Pn_IdMigracionCab  IN NUMBER          Id de cabecera
  * @param  Pv_EstadoNuevo     IN  VARCHAR2       Estado nuevo a registrar
  * @param  Pv_Observacion     IN  VARCHAR2       Observación a registrar
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  *
  */
  PROCEDURE P_ACTUALIZAR_CABECERA(
      PN_IDMIGRACIONCAB IN NUMBER,
      PV_ESTADONUEVO    IN VARCHAR2,
      PV_OBSERVACION    IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_INFO_AGRUPAMIENTO
  * Procedimiento que actualiza las cabeceras de migración a procesar en estado enviado por parámetro
  *
  * @param  Pv_TipoRegistro         IN  VARCHAR2    Tipo registro a recuperar información
  * @param  Pn_CantidadAgrupamiento OUT NUMBER      Mensaje de error del procedimiento
  * @param  Pv_CampoHilos           OUT VARCHAR2    Nombre de campo a registrar en json de respuesta
  * @param  Pv_EstadoNuevo          OUT VARCHAR2    Nuevo estado a colocar en detalle
  * @param  Pv_EstadoActual         OUT VARCHAR2    Estado actual a colocar en detalle
  * @param  Pv_EstadoError          OUT VARCHAR2    Estado error a colocar en detalle
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  *
  */
  PROCEDURE P_INFO_AGRUPAMIENTO(
      PV_TIPOREGISTRO IN VARCHAR2,
      PN_CANTIDADAGRUPAMIENTO OUT NUMBER,
      PV_CAMPOHILOS OUT VARCHAR2,
      PV_ESTADONUEVO OUT VARCHAR2,
      PV_ESTADOACTUAL OUT VARCHAR2,
      PV_ESTADOERROR OUT VARCHAR2);
  /**
  * P_AGRUPAR_DETALLES
  * Procedimiento que agrupa los detalles de migración a procesar en estado enviado por parámetro
  *
  * @param  Pcl_JsonRequest    IN  CLOB           Parámetros por los cuáles se realizará la consulta
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  * @param  Pcl_JsonResponse   OUT CLOB Respuesta en formato json de la consulta
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  *
  */
  PROCEDURE P_AGRUPAR_DETALLES(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PCL_JSONRESPONSE OUT CLOB);
  /**
  * P_PROCESAR_OLTS
  * Procedimiento que actualiza las cabeceras de migración a procesar en estado enviado por parámetro
  *
  * @param  Pcl_JsonRequest    IN  CLOB           Parámetros por los cuáles se realizará la consulta
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  *
  */
  PROCEDURE P_PROCESAR_OLTS(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_REVERSAR_CAB_MIGRACION
  * Procedimiento que reversa la cabecera de migración enviada por parámetro
  *
  * @param  Pcl_JsonRequest    IN  CLOB           Parámetros por los cuáles se realizará e
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  *
  */
  PROCEDURE P_REVERSAR_CAB_MIGRACION(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_PROCESAR_SPLITTERS
  * Procedimiento que actualiza los detalles de migración a procesar
  *
  * @param  Pcl_JsonRequest    IN  CLOB           Parámetros por los cuáles se realizará la consulta
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  *
  */
  PROCEDURE P_PROCESAR_SPLITTERS(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_PROCESAR_SCOPES
  * Procedimiento que actualiza los detalles de migración a procesar
  *
  * @param  Pcl_JsonRequest    IN  CLOB           Parámetros por los cuáles se realizará la consulta
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jonathan Burgos <jsburgos@telconet.ec>
  * @version 1.0 03-02-2023
  *
  */
  PROCEDURE P_PROCESAR_SCOPES(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_PROCESAR_ENLACES
  * Procedimiento que actualiza los detalles de migración a procesar
  *
  * @param  Pcl_JsonRequest    IN  CLOB           Parámetros por los cuáles se realizará la consulta
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.1 17-03-2023   Se agrega condición IF al momento de actualizar estado de interface fin
  *                           en la eliminación de un enlace existen dentro del proceso de migración de enlace
  *
  */
  PROCEDURE P_PROCESAR_ENLACES(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_PROCESAR_CLIENTES
  * Procedimiento que actualiza los detalles de migración a procesar
  *
  * @param  Pcl_JsonRequest    IN  CLOB           Parámetros por los cuáles se realizará la consulta
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 08-02-2023
  *
  */
  PROCEDURE P_PROCESAR_CLIENTES(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_REVERSAR_CLIENTES
  * Procedimiento que actualiza los detalles de migración a reversar
  *
  * @param  Pn_IdMigracion     IN  NUMBER         Id de cabecera de migración a reversar
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 08-02-2023
  *
  */
  PROCEDURE P_REVERSAR_CLIENTES(
      PN_IDMIGRACION IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_REVERSAR_ENLACES
  * Procedimiento que actualiza los detalles de migración a reversar
  *
  * @param  Pn_IdMigracion     IN  NUMBER         Id de cabecera de migración a reversar
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 08-02-2023
  *
  */
  PROCEDURE P_REVERSAR_ENLACES(
      PN_IDMIGRACION IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_OBTENER_DETALLES_MIGRACION
  * Procedimiento que obtiene las cabeceras de procesos masivos a procesar en estado Pendiente
  *
  * @param  Pn_IdCabecera      IN  NUMBER         Id de cabecera del proceso
  * @param  Pv_TipoRegistro    IN  VARCHAR2       Tipo registro
  * @param  Pv_Estado          IN  VARCHAR2       Estado del detalle
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  * @param  Prf_Registros      OUT SYS_REFCURSOR  Respuesta en formato json de la consulta
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 05-09-2022
  *
  */
  PROCEDURE P_OBTENER_DETALLES_MIGRACION(
      PN_IDCABECERA   IN NUMBER,
      PV_TIPOREGISTRO IN VARCHAR2,
      PV_ESTADO       IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PRF_REGISTROS OUT SYS_REFCURSOR);
  /**
  * P_OBTENER_SERVICIOS
  * Procedimiento que obtiene los servicios asociados a una linea pon
  *
  * @param  Pn_ElementoBusquedaId          IN  NUMBER         Id de olt
  * @param  Pn_InterfaceElementoBusquedaId IN  NUMBER         Id de puerto pon
  * @param  Pn_TotalRegistros              OUT NUMBER         Total de registros encontrados
  * @param  Pv_MensaError                  OUT VARCHAR2       Mensaje de error del procedimiento
  * @param  Prf_Result                     OUT SYS_REFCURSOR  Respuesta con clientes encontrados
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 09-09-2022
  *
  */
  PROCEDURE P_OBTENER_SERVICIOS(
      PN_ELEMENTOBUSQUEDAID          IN NUMBER,
      PN_INTERFACEELEMENTOBUSQUEDAID IN NUMBER,
      PN_TOTALREGISTROS OUT NUMBER,
      PV_MENSAERROR OUT VARCHAR2,
      PRF_RESULT OUT SYS_REFCURSOR);
  /**
  * P_ACTUALIZA_SPID
  * Procedimiento que actualiza el SPID de servicios
  *
  * @param  Pn_IdServicio          IN  NUMBER         Id Servicio
  * @param  Pv_NombreMarcaElemento IN  VARCHAR2       Nombre marca elemento
  * @param  Pv_EstadoServicio      IN  VARCHAR2       Estado Servicio
  * @param  Pn_ValorNumerico       IN  NUMBER         Valor numérico a usar para calcular el nuevo SPID en HW, para ZTE se usan parametrizaciones
  * @param  Pv_Status              OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje             OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 09-09-2022
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.1 23-05-2023 - Se agrega validación de spid para los servicios safecity.
  *
  */
  PROCEDURE P_ACTUALIZA_SPID(
      PN_IDSERVICIO          IN NUMBER,
      PV_NOMBREMARCAELEMENTO IN VARCHAR2,
      PV_ESTADOSERVICIO      IN VARCHAR2,
      PN_VALORNUMERICO       IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_ACTUALIZA_CARACT_ZTE
  * Procedimiento que actualiza las caracteristicas ZTE de servicios
  *
  * @param  PCL_JSONCARACT         IN  CLOB           Id Servicio
  * @param  Pn_IdServicio          IN  NUMBER         Id Servicio
  * @param  Pv_EstadoServicio      IN  VARCHAR2       Estado Servicio
  * @param  Pv_LinePofile          IN  VARCHAR2       Valor de line profile name del cliente
  * @param  Pv_EsPlan              IN  VARCHAR2       Bandera para saber si es plan
  * @param  Pv_Status              OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje             OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 09-09-2022
  *
  */
  PROCEDURE P_ACTUALIZA_CARACT_ZTE(
      PCL_JSONCARACT    IN CLOB,
      PN_IDSERVICIO     IN NUMBER,
      PV_ESTADOSERVICIO IN VARCHAR2,
      PV_LINEPROFILE    IN VARCHAR2,
      PV_ESPLAN         IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2 );
  /**
  * P_REVERSA_SPID
  * Procedimiento que reversa el SPID de servicios
  *
  * @param  Pn_IdServicio          IN  NUMBER         Id Servicio
  * @param  Pv_EstadoServicio      IN  VARCHAR2       Estado Servicio
  * @param  Pv_Status              OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje             OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 09-09-2022
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.1 23-05-2023 - Se agrega reverso de spid para los servicios safecity.
  *
  */
  PROCEDURE P_REVERSA_SPID(
      PN_IDSERVICIO     IN NUMBER,
      PV_ESTADOSERVICIO IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_REVERSA_CARACT_ZTE
  * Procedimiento que reversa las caracteristicas ZTE de servicios
  *
  * @param  Pn_IdServicio          IN  NUMBER         Id Servicio
  * @param  Pv_EstadoServicio      IN  VARCHAR2       Estado Servicio
  * @param  Pv_Status              OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje             OUT VARCHAR2       Mensaje de error del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 09-09-2022
  *
  */
  PROCEDURE P_REVERSA_CARACT_ZTE(
      PN_IDSERVICIO     IN NUMBER,
      PV_ESTADOSERVICIO IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_INSERTAR_DATA
  * Procedimiento que inserta registro en tabla DATA de migración Alta Densidad
  *
  * @param  Pr_InfoBufferHilo              IN  DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA%ROWTYPE    Objecto con información a ingresar
  * @param  Pv_Status                      OUT VARCHAR2                                         Mensaje de error del procedimiento
  * @param  Pv_Mensaje                     OUT VARCHAR2                                         Respuesta del procedimiento
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 09-09-2022
  *
  */
  PROCEDURE P_INSERTAR_DATA(
      PR_INFOBUFFERHILO IN DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA%ROWTYPE,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * P_VALIDAR_CAB_MIGRACION
  * Procedimiento que valida los detalles de una cabecera que está en proceso de migración
  *
  * @param  Pcl_JsonRequest    IN  CLOB           Parámetros por los cuáles se realizará la consulta
  * @param  Pv_Status          OUT VARCHAR2       Estado del procedimiento
  * @param  Pv_Mensaje         OUT VARCHAR2       Mensaje de error del procedimiento
  * @param  Pcl_JsonResponse   OUT CLOB           Respuesta en formato json de la consulta
  *
  * @author Jesús Bozada <jbozada@telconet.ec>
  * @version 1.0 03-02-2023
  *
  */
  PROCEDURE P_VALIDAR_CAB_MIGRACION(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PCL_JSONRESPONSE OUT CLOB);
  /**
  * Procedimiento que permite reemplazar el id del elemento de las subredes para los
  * servicios SAFECITY
  *
  * @param  Pn_IdOltAnterior IN  NUMBER ID del OLT que se va a reemplazar
  * @param  Pn_IdOltNuevo    IN  NUMBER ID del nuevo OLT
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Leonardo Mero
  * @version 1.0 - 07-02-2023 - Version inicial
  *
  */
  PROCEDURE P_MIGRACION_OLT_SAFECITY(
      PN_IDOLTANTERIOR IN NUMBER,
      PN_IDOLTNUEVO    IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimiento que permite hacer el reverso y reemplazar el id del elemento de las subredes para los
  * servicios SAFECITY
  *
  * @param  Pn_IdOltAnterior IN  NUMBER ID del OLT que se va a reemplazar
  * @param  Pn_IdOltNuevo    IN  NUMBER ID del nuevo OLT
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Leonardo Mero
  * @version 1.0 - 07-02-2023 - Version inicial
  *
  */
  PROCEDURE P_ROLLBACK_OLT_SAFECITY(
      PN_IDOLTANTERIOR IN NUMBER,
      PN_IDOLTNUEVO    IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimiento que realiza el cambio y actualizacion del elemento para las subredes delos
  * servicios SAFECITY
  *
  * @param  Pn_IdOltAnterior IN  NUMBER ID del OLT que se va a reemplazar
  * @param  Pn_IdOltNuevo    IN  NUMBER ID del nuevo OLT
  * @params Pv_Opcion        IN VARCHAR2 Opcion del proceso
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Leonardo Mero
  * @version 1.0 - 07-02-2023 - Version inicial
  *
  */
  PROCEDURE P_CAMBIAR_OLT_SUBRED(
      PN_IDOLTANTERIOR IN NUMBER,
      PN_IDOLTNUEVO    IN NUMBER,
      PV_OPCION        IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimeinto que permite el cambio de de la subred del servicio
  *
  * @param  Pn_Idservicio IN  NUMBER ID del servicio
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Leonardo Mero
  * @version 1.0 - 07-02-2023 - Version inicial
  *
  * @author Jenniffer Mujica
  * @version 1.1 - 24-04-2023 - Se agrega los parametros para la validacion de los servicios safecity.
  * 
  * Se anade parametros marca de olt inicial y final
  *
  * @param  Pv_MarcaOltIni IN  VARCHAR2 Marca olt inicial
  * @param  Pv_MarcaOltFin IN  VARCHAR2 Marca olt final
  */
  PROCEDURE P_MIGRACION_SERVICIOS_SAFECITY(
      PN_IDSERVICIO IN NUMBER,
      PN_IDELEMENTOINI IN NUMBER,
      PN_IDELEMENTOFIN IN NUMBER,
      PV_MARCAOLTINI IN  VARCHAR2,
      PV_MARCAOLTFIN IN  VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2 );
  --
  /**
  * Procedimeinto que permite el reverso de de la subred del servicio
  *
  * @param  Pn_Idservicio IN  NUMBER ID del servicio
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Leonardo Mero
  * @version 1.0 - 07-02-2023 - Version inicial
  *
  * @author Jenniffer Mujica
  * @version 1.1 - 24-04-2023 - Se agrega los parametros para la validacion de los servicios safecity.
  * 
  * Se anade parametros marca de olt inicial y final
  *
  * @param  Pv_MarcaOltIni IN  VARCHAR2 Marca olt inicial
  * @param  Pv_MarcaOltFin IN  VARCHAR2 Marca olt final
  */
  --
  PROCEDURE P_ROLLBACK_SERVICIOS_SAFECITY(
      PN_IDSERVICIO IN NUMBER,
      PN_IDELEMENTOINI IN NUMBER,
      PN_IDELEMENTOFIN IN NUMBER,
      PV_MARCAOLTINI IN  VARCHAR2,
      PV_MARCAOLTFIN IN  VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2 );
  /**
  * Procedimeinto que permite el cambio de de la subred del servicio y la subred privada
  * del punto
  *
  * @param  Pn_Idservicio IN  NUMBER ID del servicio
  * @params Pv_Opcion        IN VARCHAR2 Opcion del proceso
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Leonardo Mero
  * @version 1.0 - 07-02-2023 - Version inicial
  *
  */
  PROCEDURE P_ACTUALIZAR_SUBRED_SERVICIO(
      PN_IDSERVICIO IN NUMBER,
      PV_OPCION     IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2 );
  /**
  * Procedimeinto que permite validar los archivos cargados en la opcion de migracion olt alta densidad
  *
  * @param  Pv_UsrCreacion   IN  VARCHAR2  Usuario creacion
  * @param  Pv_Status        OUT VARCHAR2  estado del proceso OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  * @author Jonathan Burgos
  * @version 2.0 - 13-03-2023 - Se agrega control de excepcion para casos en donde no se envie informacion en la validacion de registros duplicados.
  *
  */
  PROCEDURE P_UPLOAD_CSV_MIGRACION_OLT(
      PV_USRCREACION IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimiento que permite ejecutar y enviar por correo los reportes previo a la migracion olt alta densidad
  * data tecnica e informacion de los enlaces
  *
  * @param  Pv_UsrConsulta   IN  VARCHAR2  Usuario de consulta
  * @param  Pv_Status        OUT VARCHAR2  estado del proceso OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_ENVIA_REPORTE_PREV_MIGRACION(
      PV_USRCONSULTA IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimeinto que crear el reporte previo y posterior de la data tecnica migrada y anterior.
  *
  * @param  Pv_UsrConsulta   IN  VARCHAR2  Usuario de consulta
  * @param  Pv_TipoReporte   IN VARCHAR2 Tipo de reporte, ReportePrevio o ReportePosterior
  * @param  Pv_Status        OUT VARCHAR2  estado del proceso OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_REPORTE_MIGRA_PREV_DATA_TECN(
      PV_USRCONSULTA IN VARCHAR2,
      PV_TIPOREPORTE IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimeinto que crear el reporte previo de la informacion de los enlaces del olt.
  *
  * @param  Pv_UsrConsulta   IN  VARCHAR2  Usuario de consulta
  * @param  Pv_Status        OUT VARCHAR2  estado del proceso OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Leonardo Mero
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_REPORTE_MIGRA_PREV_ENLACE(
      PV_USRCONSULTA IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Funcion de retorna las caracteristicas del servicio por medio del id servicio y el nombre de la
  * caracteristica
  *
  * @param   FN_ID_SERVICIO     IN NUMBER ID del servicio
  * @params  FV_CARACTERISTICA  IN VARCHAR2 nombre de la caracteristica
  * @return  VARCHAR2           valor de la caracteristica
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  FUNCTION F_GET_CARACTERISTICA_SRV(
      FN_ID_SERVICIO    IN NUMBER,
      FV_CARACTERISTICA IN VARCHAR2)
    RETURN VARCHAR2;
  /**
  * Funcion para validar cadenas de tipo string con pipe como separador
  *
  * @param   FV_CADENA        IN  NUMBER  cadena string
  * @return  VARCHAR2         validacion de la cadena
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  FUNCTION F_GET_VALIDACION_CADENA(
      FV_CADENA IN VARCHAR2)
    RETURN VARCHAR2;
  /**
  * Procedimeinto que permite validar el estado de la migracion olt alta densidad
  *
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_VALIDA_ESTADO_MIGRACION(
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2 );
  /**
  * Procedimiento que permite reversar los scope asociados a la migracion que se envie como
  * parametro
  *
  * @param  PN_MIGRACION_CAB_ID   IN NUMBER     Id de la cabecera de tabla de migracion olt alta densidad
  * @param  PV_ERROR              OUT VARCHAR2  OK || ERROR
  * @param  PV_MENSAJE            OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_REVERSAR_SCOPES(
      PN_MIGRACION_CAB_ID IN NUMBER,
      PV_ERROR OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimiento que permite reversar la informacion del olt enviado como
  * parametro
  *
  * @param  PV_NOMBRE_OLT         IN  VARCHAR2  Nombre del olt migrado
  * @param  PV_IP_OLT             IN  VARCHAR2  IP del olt migrado
  * @param  PV_STATUS             OUT VARCHAR2  OK || ERROR
  * @param  PV_MENSAJE            OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_REVERSO_POR_ELEMENTO(
      PV_NOMBRE_OLT IN VARCHAR2,
      PV_IP_OLT     IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimiento que permite reversar los splitter asociados a la migracion que se envie como
  * parametro
  *
  * @param  PN_MIGRACION_CAB_ID   IN NUMBER     Id de la cabecera de tabla de migracion olt alta densidad
  * @param  PV_ERROR              OUT VARCHAR2  OK || ERROR
  * @param  PV_MENSAJE            OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_REVERSAR_SPLITTERS(
      PN_MIGRACION_CAB_ID IN NUMBER,
      PV_ERROR OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);
  /**
  * Procedimiento que permite reversar los olts asociados a la migracion que se envie como
  * parametro
  *
  * @param  PN_MIGRACION_CAB_ID   IN NUMBER     Id de la cabecera de tabla de migracion olt alta densidad
  * @param  PV_ERROR              OUT VARCHAR2  OK || ERROR
  * @param  PV_MENSAJE            OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jonathan Burgos
  * @version 1.0 - 14-02-2023 - Version inicial
  *
  */
  PROCEDURE P_REVERSAR_OLTS(
      PN_MIGRACION_CAB_ID IN NUMBER,
      PV_ERROR OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2);

  /**
  *
  * Procedimiento para realizar el cosumo de los WS de NW durante la migracion de los OLTs
  *
  * @param  Pn_Idoltanterior IN  NUMBER ID del OLT al que se librera la configuracion
  *
  * @author Leonardo Mero
  * @version 1.0 - 07-02-2023 - Version inicial
  */
  PROCEDURE P_WS_NETWORKING(
      PN_IDOLTANTERIOR IN NUMBER);

  /**
  * Procedimeinto que inserta nueva caracteristica,
  * registra historial del servicio.
  *
  * @param  Pn_Id_Servicio IN  NUMBER Id del servicio
  * @param  Pv_Caracteristica IN  VARCHAR2 Caracteristica a actualizar
  * @param  Pv_Valor_Nuevo IN VARCHAR2  Valor Nuevo de la caracteristica
  * @param  Pb_ValidaMensaje IN BOOLEAN Recibe instrucción que cambiar el mensaje a guardar dek historial de servicio.
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jenniffer Mujica
  * @version 1.0 - 05-04-2023 - Version inicial
  *
  */
  PROCEDURE P_INSERTAR_CARACT_SAFECITY(
    PN_ID_SERVICIO IN NUMBER,
    PV_CARACTERISTICA IN VARCHAR2,
    PV_VALOR_NUEVO IN VARCHAR2,
    PB_VALIDAMENSAJE IN BOOLEAN,
    PV_STATUS OUT VARCHAR2,
    PV_MENSAJE OUT VARCHAR2);

  /**
  * Procedimeinto que permite actualizar caracteristica
  * de los servicio con producto Datos Gpon, Safe Video 
  * Analytics Cam, Wifi Gpon
  *
  * @param  Pn_Idservicio IN  NUMBER ID del servicio
  * @param  Pv_Opcion        IN VARCHAR2, Migracion o rollback
  * @param  Pv_Status        OUT VARCHAR2  OK || ERROR
  * @param  Pv_Mensaje       OUT VARCHAR2  Mensaje del proceso
  *
  * @author Jenniffer Mujica
  * @version 1.0 - 05-04-2023 - Version inicial
  *
  */
  PROCEDURE P_ACTUALIZAR_CARACT_SAFECITY(
    PN_IDSERVICIO IN NUMBER,
    PN_IDELEMENTOINI IN NUMBER,
    PN_IDELEMENTOFIN IN NUMBER,
    PV_OPCION IN VARCHAR2,
    PV_STATUS OUT VARCHAR2,
    PV_MENSAJE OUT VARCHAR2 );

END INKG_MIGRACION_ALTA_DENSIDAD;
/


CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD
AS

  PROCEDURE P_WEB_SERVICE_BR(Pv_Url             IN  VARCHAR2,
                          Pcl_Mensaje        IN  CLOB,
                          Pv_Application     IN  VARCHAR2,
                          Pv_Charset         IN  VARCHAR2,
                          Pv_UrlFileDigital  IN  VARCHAR2,
                          Pv_PassFileDigital IN  VARCHAR2,
                          Pn_TimeOut         IN  NUMBER,
                          Pcl_Respuesta      OUT CLOB,
                          Pv_Error           OUT VARCHAR2) AS
    
    Lhttp_Request   UTL_HTTP.REQ;
    Lhttp_Response  UTL_HTTP.RESP; 
    Lv_Respuesta    CLOB;
    Lv_Response     CLOB;
    Ln_LongitudReq   NUMBER;
    Ln_LongitudIdeal NUMBER:= 32767;
    Ln_Offset        NUMBER:= 1;
    Ln_Buffer        VARCHAR2(2000);
    Ln_Amount        NUMBER := 2000;
    l_buffer   varchar2(2000);
  BEGIN
    dbms_lob.createtemporary(Lv_Respuesta, TRUE);
    dbms_lob.createtemporary(Lv_Response, TRUE);
    -- TIME OUT
    UTL_HTTP.set_transfer_timeout(Pn_TimeOut);
    UTL_HTTP.set_wallet(Pv_UrlFileDigital, Pv_PassFileDigital);
    Lhttp_Request := UTL_HTTP.BEGIN_REQUEST(Pv_Url, 'POST');
    UTL_HTTP.SET_HEADER(Lhttp_Request, 'content-type', Pv_Application);
    UTL_HTTP.SET_BODY_CHARSET(Lhttp_Request, Pv_Charset);
    Ln_LongitudReq  := length(Pcl_Mensaje);
    UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
    WHILE (Ln_Offset < Ln_LongitudReq) LOOP
      DBMS_LOB.READ(Pcl_Mensaje, 
                    Ln_Amount,
                    Ln_Offset,
                    Ln_Buffer);
      UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
      Ln_Offset := Ln_Offset + Ln_Amount;
    END LOOP;
    Lhttp_Response := UTL_HTTP.GET_RESPONSE(Lhttp_Request);
    BEGIN
      LOOP
        utl_http.read_text(Lhttp_Response, l_buffer, 2000);
        dbms_lob.writeappend (Lv_Response, length(l_buffer), l_buffer);
      END LOOP;
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        utl_http.end_response(Lhttp_Response);
    END;
    Pcl_Respuesta := Lv_Response;
    DBMS_LOB.FREETEMPORARY(Lv_Response);
    DBMS_LOB.FREETEMPORARY(Lv_Respuesta);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
    'INKG_MIGRACION_ALTA_DENSIDAD.P_WEB_SERVICE_BR-RESPUESTA',
    dbms_lob.substr(Pcl_Respuesta,4000,1), 'jbozada', SYSDATE, '127.0.0.1');
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Error := 'Error en el proceso INKG_MIGRACION_ALTA_DENSIDAD.P_WEB_SERVICE_BR ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('INKG_MIGRACION_ALTA_DENSIDAD',
                                           'INKG_MIGRACION_ALTA_DENSIDAD.P_WEB_SERVICE_BR', 
                                           SQLERRM, 
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_GENERAL'), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_WEB_SERVICE_BR;

  PROCEDURE P_OBTENER_SERVICIOS(
      PN_ELEMENTOBUSQUEDAID          IN NUMBER,
      PN_INTERFACEELEMENTOBUSQUEDAID IN NUMBER,
      PN_TOTALREGISTROS OUT NUMBER,
      PV_MENSAERROR OUT VARCHAR2,
      PRF_RESULT OUT SYS_REFCURSOR)
  IS
    LV_QUERY CLOB;
    LV_QUERYCOUNT CLOB;
    LV_QUERYALLCOLUMNS CLOB;
    LV_LIMITALLCOLUMNS CLOB;
    LV_LIMITCOUNT CLOB;
    LN_COUNTER NUMBER := 0;
  BEGIN
    LV_QUERYCOUNT      := 'SELECT SERVICIO.ID_SERVICIO TOTAL ';
    LV_QUERYALLCOLUMNS :=
    'SELECT * FROM (SELECT SERVICIO.ID_SERVICIO,                            
SERVICIO.PUNTO_ID,                            
SERVICIO.ESTADO,                            
SERVICIO.LOGIN_AUX,      
PUNTO.LOGIN,      
PROD.ID_PRODUCTO,                            
PROD.NOMBRE_TECNICO,                            
PROD.DESCRIPCION_PRODUCTO,           
PROD1.ID_PRODUCTO AS ID_PRODUCTO1,                            
PROD1.DESCRIPCION_PRODUCTO AS DESCRIPCION_PRODUCTO1,                            
PROD1.NOMBRE_TECNICO AS NOMBRE_TECNICO1,                            
EG.COD_EMPRESA,                            
EG.PREFIJO,                    
CASE                               
WHEN PERSONA.RAZON_SOCIAL IS NOT NULL THEN                               
PERSONA.RAZON_SOCIAL                                
ELSE                               
PERSONA.NOMBRES || '' '' || PERSONA.APELLIDOS                            
END NOMBRE_COMPLETO,                            
PLANC.ID_PLAN,                            
PLANC.NOMBRE_PLAN,                            
ELEMENTO.ID_ELEMENTO,        
MARCA.NOMBRE_MARCA_ELEMENTO,      
ELEMENTO.NOMBRE_ELEMENTO ,                            
IP.IP,                            
PUERTO.NOMBRE_INTERFACE_ELEMENTO,                            
PUERTO.ID_INTERFACE_ELEMENTO,      
PARAMETROS.VALOR1 TIPO_PRODUCTO,      
CASE EG.COD_EMPRESA           
WHEN ''10'' THEN              
DB_COMERCIAL.TECNK_SERVICIOS.F_GET_VALIDACION_IP_FIJA_TN(DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''),                                                           
SERVICIO.ID_SERVICIO,                                                          
SERVICIO.PUNTO_ID,                                                           
''REF SERVICIO'',                                                          
SERVICIO.ESTADO,                                                          
PROD1.ID_PRODUCTO,                                                          
EG.COD_EMPRESA)          
WHEN ''26'' THEN              
DB_COMERCIAL.TECNK_SERVICIOS.F_GET_VALIDACION_IP_FIJA_TN(DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''),                                                           
SERVICIO.ID_SERVICIO,                                                          
SERVICIO.PUNTO_ID,                                                           
''REF SERVICIO'',                                                          
SERVICIO.ESTADO,                                                          
PROD1.ID_PRODUCTO,                                                          
EG.COD_EMPRESA)               
ELSE                                      
DB_COMERCIAL.TECNK_SERVICIOS.GET_VALIDACION_IP_FIJA( DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''),                                                       
SERVICIO.PUNTO_ID,                                                       
''REF SERVICIO'',                                                       
SERVICIO.ESTADO)      
END REF_SERVICIO,      
PARAMETROS.VALOR4 ActualizaSpid,      
DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''SPID'') SPID ,      
DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''LINE-PROFILE-NAME'') LINE_PROFILE_NAME '
    ;
    LV_QUERY :=
    'FROM (select VALOR1, VALOR2, VALOR3, VALOR4 from DB_GENERAL.ADMI_PARAMETRO_DET        
where parametro_id = (SELECT Id_Parametro           
FROM DB_GENERAL.ADMI_PARAMETRO_CAB           
WHERE Nombre_Parametro=''PARAMETROS_MIGRACION_ALTA_DENSIDAD''           
AND estado            =''Activo''          
) and descripcion = ''NOMBRES_TECNICOS'' and estado = ''Activo'') PARAMETROS,          
DB_COMERCIAL.INFO_SERVICIO SERVICIO      
LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TECNICO ON TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO          
LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO ON ELEMENTO.ID_ELEMENTO = TECNICO.ELEMENTO_ID                 
LEFT JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO PUERTO ON PUERTO.ID_INTERFACE_ELEMENTO = TECNICO.INTERFACE_ELEMENTO_ID          
LEFT JOIN DB_INFRAESTRUCTURA.INFO_IP IP ON IP.ELEMENTO_ID = ELEMENTO.ID_ELEMENTO                 
LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO UM ON UM.ID_TIPO_MEDIO = TECNICO.ULTIMA_MILLA_ID                 
LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO ON MODELO.ID_MODELO_ELEMENTO = ELEMENTO.MODELO_ELEMENTO_ID       
LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA ON MARCA.ID_MARCA_ELEMENTO = MODELO.MARCA_ELEMENTO_ID                           
LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUNTO ON PUNTO.ID_PUNTO = SERVICIO.PUNTO_ID                 
LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLANC ON PLANC.ID_PLAN = SERVICIO.PLAN_ID                 
LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET PLAND ON PLAND.PLAN_ID = PLANC.ID_PLAN                 
LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD ON PROD.ID_PRODUCTO = PLAND.PRODUCTO_ID                 
LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD1 ON PROD1.ID_PRODUCTO = SERVICIO.PRODUCTO_ID                 
LEFT JOIN DB_COMERCIAL.INFO_ORDEN_TRABAJO ORDEN ON ORDEN.ID_ORDEN_TRABAJO = SERVICIO.ORDEN_TRABAJO_ID                 
LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID                 
LEFT JOIN DB_COMERCIAL.INFO_PERSONA PERSONA ON PERSONA.ID_PERSONA = PER.PERSONA_ID                 
LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID                 
LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EG ON EG.COD_EMPRESA = ER.EMPRESA_COD         
WHERE SERVICIO.ESTADO <> ''Eliminado''                   
AND ( SERVICIO.PLAN_ID IS NULL                        
OR ( SERVICIO.PLAN_ID > 0                            
AND (PLAND.ESTADO) = (PLANC.ESTADO) ) )       
AND ((PROD.NOMBRE_TECNICO = PARAMETROS.VALOR2 AND PROD.DESCRIPCION_PRODUCTO = NVL(PARAMETROS.VALOR3, PROD.DESCRIPCION_PRODUCTO)) OR      
(PROD1.NOMBRE_TECNICO = PARAMETROS.VALOR2 AND PROD1.DESCRIPCION_PRODUCTO = NVL(PARAMETROS.VALOR3, PROD1.DESCRIPCION_PRODUCTO)))'
    ;
    LV_QUERY           := LV_QUERY || ' AND SERVICIO.ESTADO NOT IN (select VALOR1 from DB_GENERAL.ADMI_PARAMETRO_DET        
where parametro_id = (SELECT Id_Parametro           
FROM DB_GENERAL.ADMI_PARAMETRO_CAB           
WHERE Nombre_Parametro=''PARAMETROS_MIGRACION_ALTA_DENSIDAD''           
AND estado            =''Activo''          
) and descripcion = ''ESTADO_NO_CONSIDERADOS'' and estado = ''Activo'')';
    LV_QUERY           := LV_QUERY || ' AND TECNICO.ELEMENTO_ID = ' || PN_ELEMENTOBUSQUEDAID || ' AND TECNICO.INTERFACE_ELEMENTO_ID = '|| PN_INTERFACEELEMENTOBUSQUEDAID ||' ';
    LV_LIMITALLCOLUMNS := ' ) TB ';
    LV_QUERYALLCOLUMNS := LV_QUERYALLCOLUMNS || LV_QUERY || LV_LIMITALLCOLUMNS;
    LV_QUERYCOUNT      := LV_QUERYCOUNT || LV_QUERY;
    OPEN PRF_RESULT FOR LV_QUERYALLCOLUMNS;
    PN_TOTALREGISTROS := DB_COMERCIAL.TECNK_SERVICIOS.GET_COUNT_REFCURSOR(LV_QUERYCOUNT);
  EXCEPTION
  WHEN OTHERS THEN
    PV_MENSAERROR := 'ERROR PROCEDURE: ' || SQLERRM;
  END P_OBTENER_SERVICIOS;
  PROCEDURE P_ACTUALIZAR_CABECERA(
      PN_IDMIGRACIONCAB IN NUMBER,
      PV_ESTADONUEVO    IN VARCHAR2,
      PV_OBSERVACION    IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  AS
    LV_MENSAJE   VARCHAR2(4000) := 'Error al actualizar cabecera';
    LV_USRULTMOD VARCHAR2(100)  := 'migracion';
    LV_IPULTMOD  VARCHAR2(15)   := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
  BEGIN
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
    SET DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.ESTADO             = PV_ESTADONUEVO,
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.OBSERVACION          = NVL(PV_OBSERVACION,DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.OBSERVACION),
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.USR_ULT_MOD          = LV_USRULTMOD,
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.FE_ULT_MOD           = SYSDATE,
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.IP_ULT_MOD           = LV_IPULTMOD
    WHERE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB.ID_MIGRACION_CAB = PN_IDMIGRACIONCAB;
    BEGIN
      INSERT
      INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_HIST
        (
          ID_MIGRACION_HIST,
          MIGRACION_CAB_ID,
          ESTADO,
          OBSERVACION,
          USR_CREACION,
          FE_CREACION
        )
        VALUES
        (
          DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_HIST.NEXTVAL,
          PN_IDMIGRACIONCAB,
          PV_ESTADONUEVO,
          PV_OBSERVACION,
          LV_USRULTMOD,
          SYSDATE
        );
    EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJE := 'Error inesperado al insertar historial' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END;
    COMMIT;
    PV_STATUS  := 'OK';
    PV_MENSAJE := '';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := 'No se han podido actualizar correctamente las cabeceras de migración. Por favor consultar con Sistemas!';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZAR_CABECERA;
  PROCEDURE P_ACTUALIZAR_DETALLES
    (
      PN_IDMIGRACIONCAB IN NUMBER,
      PV_TIPOREGISTRO   IN VARCHAR2,
      PV_ESTADOACTUAL   IN VARCHAR2,
      PV_ESTADONUEVO    IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LV_MENSAJE VARCHAR2
    (
      4000
    )
                               := 'Error al actualizar detalles';
    LV_USRULTMOD VARCHAR2(100) := 'migracion';
  BEGIN
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
    SET DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ESTADO             = PV_ESTADONUEVO,
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.USR_ULT_MOD          = LV_USRULTMOD,
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.FE_ULT_MOD           = SYSDATE
    WHERE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.MIGRACION_CAB_ID = PN_IDMIGRACIONCAB
    AND DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.TIPO_REGISTRO      = PV_TIPOREGISTRO
    AND DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ESTADO             = PV_ESTADOACTUAL;
    COMMIT;
    PV_STATUS  := 'OK';
    PV_MENSAJE := '';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := 'No se han podido actualizar correctamente los detalles de migración. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLES', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZAR_DETALLES;
  PROCEDURE P_ACTUALIZAR_DETALLE(
      PN_IDMIGRACIONDET IN NUMBER,
      PV_TIPOREGISTRO   IN VARCHAR2,
      PV_ESTADOACTUAL   IN VARCHAR2,
      PV_ESTADONUEVO    IN VARCHAR2,
      PV_OBSERVACION    IN VARCHAR2)
  AS
    LV_MENSAJE   VARCHAR2(4000) := 'Error al actualizar detalle';
    LV_USRULTMOD VARCHAR2(100)  := 'migracion';
  BEGIN
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
    SET DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ESTADO             = PV_ESTADONUEVO,
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.OBSERVACION          = NVL(PV_OBSERVACION,DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.OBSERVACION),
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.USR_ULT_MOD          = LV_USRULTMOD,
      DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.FE_ULT_MOD           = SYSDATE
    WHERE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ID_MIGRACION_DET = PN_IDMIGRACIONDET
    AND DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.TIPO_REGISTRO      = PV_TIPOREGISTRO
    AND DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET.ESTADO             = PV_ESTADOACTUAL;
  END P_ACTUALIZAR_DETALLE;
  PROCEDURE P_OBTENER_CABECERAS(
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PRF_REGISTROS OUT SYS_REFCURSOR)
  AS
    LV_MENSAJE VARCHAR2(4000);
    LCL_SELECT CLOB;
    LCL_FROM CLOB;
    LCL_WHERE CLOB;
    LCL_CONSULTAPRINCIPAL CLOB;
    LV_ESTADOPENDIENTE VARCHAR2(20) := 'Pendiente';
    LV_TIPO            VARCHAR2(10) := 'MIGRACION';
  BEGIN
    LCL_SELECT            := 'SELECT CAB.ID_MIGRACION_CAB AS ID_CAB, CAB.ESTADO AS ESTADO ';
    LCL_FROM              := 'FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB CAB ';
    LCL_WHERE             := 'WHERE CAB.ESTADO LIKE  ''' || LV_ESTADOPENDIENTE || '%''                                                                                           
AND CAB.TIPO = ''' || LV_TIPO || '''                                                                                          
ORDER BY CAB.FE_CREACION ASC ';
    LCL_CONSULTAPRINCIPAL := LCL_SELECT || LCL_FROM || LCL_WHERE;
    OPEN PRF_REGISTROS FOR LCL_CONSULTAPRINCIPAL;
    PV_STATUS  := 'OK';
    PV_MENSAJE := '';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS     := 'ERROR';
    LV_MENSAJE    := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE    := 'No se ha podido realizar correctamente la consulta de cabeceras de migración. Por favor consultar con Sistemas!';
    PRF_REGISTROS := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_CABECERAS', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTENER_CABECERAS;
  PROCEDURE P_OBTENER_DETALLES_MIGRACION(
      PN_IDCABECERA   IN NUMBER,
      PV_TIPOREGISTRO IN VARCHAR2,
      PV_ESTADO       IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PRF_REGISTROS OUT SYS_REFCURSOR)
  AS
    LV_MENSAJE VARCHAR2(4000);
    LCL_SELECT CLOB;
    LCL_FROM CLOB;
    LCL_WHERE CLOB;
    LCL_CONSULTAPRINCIPAL CLOB;
  BEGIN
    LCL_SELECT            := 'SELECT * ';
    LCL_FROM              := 'FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET DET ';
    LCL_WHERE             := 'WHERE DET.MIGRACION_CAB_ID = '|| PN_IDCABECERA || '                                                                                 
AND DET.TIPO_REGISTRO = '''|| PV_TIPOREGISTRO || '''                                                                                 
AND DET.ESTADO = '''|| PV_ESTADO || '''                                                                                  
ORDER BY DET.ID_MIGRACION_DET ASC ';
    LCL_CONSULTAPRINCIPAL := LCL_SELECT || LCL_FROM || LCL_WHERE;
    OPEN PRF_REGISTROS FOR LCL_CONSULTAPRINCIPAL;
    PV_STATUS  := 'OK';
    PV_MENSAJE := '';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS     := 'ERROR';
    LV_MENSAJE    := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE    := 'No se ha podido realizar correctamente la consulta de detalles de cabeceras. Por favor consultar con Sistemas!';
    PRF_REGISTROS := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_DETALLES_MIGRACION', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTENER_DETALLES_MIGRACION;
  PROCEDURE P_OBTENER_CAB_MIGRACION(
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PCL_JSONRESPONSE OUT CLOB)
  AS
    LV_ESTADONUEVO             VARCHAR2(30) := '';
    LV_USRCREACION             VARCHAR2(100):= 'migracion';
    LV_IPCREACION              VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LN_INDXREGLISTADOCABECERAS NUMBER       := 0;
    LR_REGINFOCABECERAMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_INFOCABECERAMIGRACION;
    LT_TREGSINFOCABECERAMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_INFOCABECERAMIGRACION;
    LRF_REGISTROSCABECERA SYS_REFCURSOR;
    LV_STATUS  VARCHAR2(5);
    LV_MENSAJE VARCHAR2(4000);
    LCL_JSONRESPONSECAB CLOB;
    LV_STATUSREVERSO  VARCHAR2(5);
    LV_MENSAJEREVERSO VARCHAR2(4000);
  BEGIN
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.OPEN_ARRAY('cabeceras');
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_CABECERAS( LV_STATUS, LV_MENSAJE, LRF_REGISTROSCABECERA);
    IF LV_STATUS = 'OK' THEN
      LOOP
        FETCH LRF_REGISTROSCABECERA BULK COLLECT
        INTO LT_TREGSINFOCABECERAMIGRACION LIMIT 100;
        LN_INDXREGLISTADOCABECERAS        := LT_TREGSINFOCABECERAMIGRACION.FIRST;
        WHILE (LN_INDXREGLISTADOCABECERAS IS NOT NULL)
        LOOP
          LR_REGINFOCABECERAMIGRACION := LT_TREGSINFOCABECERAMIGRACION(LN_INDXREGLISTADOCABECERAS);
          LV_ESTADONUEVO              := LR_REGINFOCABECERAMIGRACION.ESTADO;
          IF LV_ESTADONUEVO            = 'Pendiente' THEN
            LV_ESTADONUEVO            := 'EnCola';
          END IF;
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LR_REGINFOCABECERAMIGRACION.IDMIGRACIONCAB, LV_ESTADONUEVO, 'Se colocan en cola las migraciones pendientes', LV_STATUS, LV_MENSAJE);
          IF LV_STATUS = 'OK' THEN
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('idMigracionCab', LR_REGINFOCABECERAMIGRACION.IDMIGRACIONCAB, TRUE);
            APEX_JSON.WRITE('estado', LV_ESTADONUEVO, TRUE);
            APEX_JSON.CLOSE_OBJECT;
          END IF;
          LN_INDXREGLISTADOCABECERAS := LT_TREGSINFOCABECERAMIGRACION.NEXT(LN_INDXREGLISTADOCABECERAS);
        END LOOP;
        EXIT
      WHEN LRF_REGISTROSCABECERA%NOTFOUND;
      END LOOP;
      CLOSE LRF_REGISTROSCABECERA;
    END IF;
    APEX_JSON.CLOSE_ARRAY;
    APEX_JSON.CLOSE_OBJECT;
    PV_STATUS        := LV_STATUS;
    PV_MENSAJE       := LV_MENSAJE;
    PCL_JSONRESPONSE := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
  EXCEPTION
  WHEN OTHERS THEN
    PCL_JSONRESPONSE := '{}';
    PV_STATUS        := 'ERROR';
    LV_MENSAJE       := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE       := 'No se ha podido realizar correctamente la consulta. Por favor consultar con Sistemas!';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_CAB_MIGRACION', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTENER_CAB_MIGRACION;
  PROCEDURE P_PROCESAR_OLTS(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  AS
    CURSOR C_GETOLTSMIGRAR (CN_IDMIGRACAB NUMBER)
    IS
      SELECT
        (SELECT ID_ELEMENTO
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
        WHERE NOMBRE_ELEMENTO = ELEMENTO_A
        AND ESTADO            = 'Activo'
        AND ROWNUM           <=1
        ) ID_ELEMENTO_A,
      (SELECT ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE NOMBRE_ELEMENTO = ELEMENTO_B
      AND ESTADO            = 'Activo'
      AND ROWNUM           <=1
      ) ID_ELEMENTO_B
    FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
    WHERE MIGRACION_CAB_ID=CN_IDMIGRACAB
    AND TIPO_REGISTRO     ='OLT'
    GROUP BY ELEMENTO_A,
      ELEMENTO_B;
    LV_ESTADOACTIVO         VARCHAR2(30) := 'Activo';
    LV_ESTADOCONNECTED      VARCHAR2(30) := 'connected';
    LV_ESTADONOTCONNECT     VARCHAR2(30) := 'not connect';
    LV_ESTADOPROCESANDOOLTS VARCHAR2(30) := 'ProcesandoOlts';
    LV_ESTADOPROCESANDODET  VARCHAR2(30) := 'Procesando';
    LV_ESTADOPENDIENTE      VARCHAR2(30) := 'Pendiente';
    LV_ESTADOOKOLTS         VARCHAR2(30) := 'OkOlts';
    LV_ESTADOOKOLTSDET      VARCHAR2(30) := 'Ok';
    LV_ESTADOMIGRADO        VARCHAR2(30) := 'Migrado';
    LV_ESTADOOK             VARCHAR2(30) := 'OK';
    LV_TIPOREGISTRO         VARCHAR2(30) := 'OLT';
    LV_ESTADOFALLOOLTS      VARCHAR2(30) := 'FalloOlts';
    LV_ESTADOERROROLTS      VARCHAR2(30) := 'ErrorOlts';
    LV_ESTADOERROROLTSDET   VARCHAR2(30) := 'Error';
    LV_USRCREACION          VARCHAR2(100):= 'migracion';
    LV_IPCREACION           VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LN_IDMIGRACIONCAB      NUMBER;
    LN_IDENLACE            NUMBER;
    LN_IDINTERFACEELEMENTO NUMBER;
    LB_EXISTIOERROR        BOOLEAN := FALSE;
    LV_STATUS              VARCHAR2(5);
    LV_MENSAJE             VARCHAR2(4000);
    LV_MENSAJEEX           VARCHAR2(4000);
    LE_EXCEPTION_REG       EXCEPTION;
    LRF_REGISTROSDETALLES SYS_REFCURSOR;
    LN_INDXREGLISTADODETALLES NUMBER := 0;
    LN_ID_INT_ELE_NUEVO       NUMBER := 0;
    LR_INFOENLACEREG DB_INFRAESTRUCTURA.INFO_ENLACE%ROWTYPE;
    LR_REGINFODETALLEMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_INFODETALLEMIGRACION;
    LT_TREGSINFODETALLEMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_INFODETALLEMIGRACION;
    LR_REGELEMENTOSMIGRAOLT DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_ELEMENTOSMIGRAOLT;
    LT_TREGSELEMENTOSMIGRAOLT DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_ELEMENTOSMIGRAOLT;
    LN_INDXREGELEMENTOSMIGRAOLT   NUMBER  := 0;
    LN_ITEMOLTMIGRADO             NUMBER  := 0;
    LB_EJECUTARROLLBACKOLT        BOOLEAN := FALSE;
    LN_IDX_TREGSELEMENTOSMIGRAOLT NUMBER;
  BEGIN
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONREQUEST;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    LN_IDMIGRACIONCAB := TRIM(APEX_JSON.GET_NUMBER(P_PATH => 'idMigracionCab'));
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOPROCESANDOOLTS, 'Se comienzan a procesar los registros de OLTS', LV_STATUS, LV_MENSAJE);
    IF LV_STATUS = 'OK' THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_DETALLES_MIGRACION( LN_IDMIGRACIONCAB, LV_TIPOREGISTRO, LV_ESTADOPENDIENTE, LV_STATUS, LV_MENSAJE, LRF_REGISTROSDETALLES);
      IF LV_STATUS = 'OK' THEN
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLES( LN_IDMIGRACIONCAB, LV_TIPOREGISTRO, LV_ESTADOPENDIENTE, LV_ESTADOPROCESANDODET, LV_STATUS, LV_MENSAJE);
        IF LV_STATUS = 'OK' THEN
          LOOP
            FETCH LRF_REGISTROSDETALLES BULK COLLECT
            INTO LT_TREGSINFODETALLEMIGRACION LIMIT 100;
            LN_INDXREGLISTADODETALLES        := LT_TREGSINFODETALLEMIGRACION.FIRST;
            WHILE (LN_INDXREGLISTADODETALLES IS NOT NULL)
            LOOP
              BEGIN
                LV_MENSAJEEX               := '';
                LR_REGINFODETALLEMIGRACION := LT_TREGSINFODETALLEMIGRACION(LN_INDXREGLISTADODETALLES);
                LN_IDENLACE                := NULL;
                LR_INFOENLACEREG           := NULL;
                LN_IDINTERFACEELEMENTO     := NULL;
                LN_ID_INT_ELE_NUEVO        := NULL;
                BEGIN
                  SELECT DB_INFRAESTRUCTURA.INFO_ENLACE.ID_ENLACE,
                    DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO
                  INTO LN_IDENLACE,
                    LN_IDINTERFACEELEMENTO
                  FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO,
                    DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO,
                    DB_INFRAESTRUCTURA.INFO_ENLACE
                  WHERE DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO                       = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
                  AND DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_INI_ID             = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO
                  AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO                     = LR_REGINFODETALLEMIGRACION.ELEMENTOA
                  AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO = LR_REGINFODETALLEMIGRACION.INTERFACEELEMENTOA
                  AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO                    = LV_ESTADOCONNECTED
                  AND DB_INFRAESTRUCTURA.INFO_ENLACE.ESTADO                                = LV_ESTADOACTIVO;
                EXCEPTION
                WHEN OTHERS THEN
                  IF SQLCODE = -1422 THEN
                    LV_MENSAJEEX  := 'Existe más de un registro';
                  ELSIF SQLCODE = 100 THEN
                    LV_MENSAJEEX  := 'No existe información';
                  ELSE
                    LV_MENSAJEEX  := 'Existe un error';
                  END IF;
                  LV_MENSAJEEX := SUBSTR(LV_MENSAJEEX|| ' al recuperar enlace con el elementoA e interfaceElementoA como elemento inicio, '||
                                         'interfaceElementoA con estado connected, estado de enlace Activo. ' ||
                                         ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
                  RAISE LE_EXCEPTION_REG;
                END;
                IF LN_IDENLACE IS NULL THEN
                  LV_MENSAJEEX := 'No existe enlace con el elementoA e interfaceElementoA como elemento inicio, '||
                                  'interfaceElementoA con estado connected, estado de enlace Activo.';
                  RAISE LE_EXCEPTION_REG;
                END IF;
                UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
                SET ESTADO                                                             = LV_ESTADOMIGRADO,
                  FE_ULT_MOD                                                           = SYSDATE,
                  USR_ULT_MOD                                                          = LV_USRCREACION
                WHERE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO = LN_IDINTERFACEELEMENTO;
                UPDATE DB_INFRAESTRUCTURA.INFO_ENLACE
                SET ESTADO      = LV_ESTADOMIGRADO
                WHERE ID_ENLACE = LN_IDENLACE;
                SELECT ID_ENLACE,
                  INTERFACE_ELEMENTO_INI_ID,
                  INTERFACE_ELEMENTO_FIN_ID,
                  TIPO_MEDIO_ID,
                  CAPACIDAD_INPUT,
                  UNIDAD_MEDIDA_INPUT,
                  CAPACIDAD_OUTPUT,
                  UNIDAD_MEDIDA_OUTPUT,
                  CAPACIDAD_INI_FIN,
                  UNIDAD_MEDIDA_UP,
                  CAPACIDAD_FIN_INI,
                  UNIDAD_MEDIDA_DOWN,
                  TIPO_ENLACE,
                  ESTADO,
                  USR_CREACION,
                  FE_CREACION,
                  IP_CREACION,
                  BUFFER_HILO_ID
                INTO LR_INFOENLACEREG
                FROM DB_INFRAESTRUCTURA.INFO_ENLACE
                WHERE DB_INFRAESTRUCTURA.INFO_ENLACE.ID_ENLACE = LN_IDENLACE;
                BEGIN
                  SELECT IIEL.ID_INTERFACE_ELEMENTO
                  INTO LN_ID_INT_ELE_NUEVO
                  FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IELE,
                    DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IIEL
                  WHERE IELE.ID_ELEMENTO             = IIEL.ELEMENTO_ID
                  AND IELE.NOMBRE_ELEMENTO           = LR_REGINFODETALLEMIGRACION.ELEMENTOB
                  AND IELE.ESTADO                    = LV_ESTADOACTIVO
                  AND IIEL.NOMBRE_INTERFACE_ELEMENTO = LR_REGINFODETALLEMIGRACION.INTERFACEELEMENTOB
                  AND IIEL.ESTADO                    = LV_ESTADONOTCONNECT;
                EXCEPTION
                WHEN OTHERS THEN
                  IF SQLCODE = -1422 THEN
                    LV_MENSAJEEX  := 'Existe más de un registro';
                  ELSIF SQLCODE = 100 THEN
                    LV_MENSAJEEX  := 'No existe información';
                  ELSE
                    LV_MENSAJEEX  := 'Existe un error';
                  END IF;
                  LV_MENSAJEEX := SUBSTR(LV_MENSAJEEX|| ' al recuperar interfaceElementoB con estado not connect '||
                                         'asociada a un elementoB con estado Activo. ' ||
                                         ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
                  RAISE LE_EXCEPTION_REG;
                END;
                IF LN_ID_INT_ELE_NUEVO IS NULL THEN 
                  LV_MENSAJEEX := 'No existe interfaceElementoB con estado not connect asociada a un elementoB con estado Activo.';
                  RAISE LE_EXCEPTION_REG;
                END IF;
                INSERT
                INTO DB_INFRAESTRUCTURA.INFO_ENLACE
                  (
                    ID_ENLACE,
                    INTERFACE_ELEMENTO_INI_ID,
                    INTERFACE_ELEMENTO_FIN_ID,
                    TIPO_MEDIO_ID,
                    CAPACIDAD_INPUT,
                    UNIDAD_MEDIDA_INPUT,
                    CAPACIDAD_OUTPUT,
                    UNIDAD_MEDIDA_OUTPUT,
                    CAPACIDAD_INI_FIN,
                    UNIDAD_MEDIDA_UP,
                    CAPACIDAD_FIN_INI,
                    UNIDAD_MEDIDA_DOWN,
                    TIPO_ENLACE,
                    ESTADO,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    BUFFER_HILO_ID
                  )
                  VALUES
                  (
                    DB_INFRAESTRUCTURA.SEQ_INFO_ENLACE.NEXTVAL,
                    LN_ID_INT_ELE_NUEVO,
                    LR_INFOENLACEREG.INTERFACE_ELEMENTO_FIN_ID,
                    LR_INFOENLACEREG.TIPO_MEDIO_ID,
                    LR_INFOENLACEREG.CAPACIDAD_INPUT,
                    LR_INFOENLACEREG.UNIDAD_MEDIDA_INPUT,
                    LR_INFOENLACEREG.CAPACIDAD_OUTPUT,
                    LR_INFOENLACEREG.UNIDAD_MEDIDA_OUTPUT,
                    LR_INFOENLACEREG.CAPACIDAD_INI_FIN,
                    LR_INFOENLACEREG.UNIDAD_MEDIDA_UP,
                    LR_INFOENLACEREG.CAPACIDAD_FIN_INI,
                    LR_INFOENLACEREG.UNIDAD_MEDIDA_DOWN,
                    LR_INFOENLACEREG.TIPO_ENLACE,
                    LV_ESTADOACTIVO,
                    LV_USRCREACION,
                    SYSDATE,
                    LV_IPCREACION,
                    LR_INFOENLACEREG.BUFFER_HILO_ID
                  );
                UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
                SET ESTADO                  = LV_ESTADOCONNECTED
                WHERE ID_INTERFACE_ELEMENTO = LN_ID_INT_ELE_NUEVO;
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LR_REGINFODETALLEMIGRACION.IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDODET, LV_ESTADOOKOLTSDET, 'Olt procesado correctamente');
                COMMIT;
              EXCEPTION
              WHEN LE_EXCEPTION_REG THEN
                ROLLBACK;
                LB_EXISTIOERROR := TRUE;
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LR_REGINFODETALLEMIGRACION.IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDODET, LV_ESTADOERROROLTSDET, LV_MENSAJEEX);
                COMMIT;
              WHEN OTHERS THEN
                LV_MENSAJEEX := SUBSTR('Se presentó un error al actualizar el detalle de olt: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
                ROLLBACK;
                LB_EXISTIOERROR := TRUE;
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LR_REGINFODETALLEMIGRACION.IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDODET, LV_ESTADOERROROLTSDET, LV_MENSAJEEX);
                COMMIT;
              END;
              LN_INDXREGLISTADODETALLES := LT_TREGSINFODETALLEMIGRACION.NEXT(LN_INDXREGLISTADODETALLES);
            END LOOP;
            EXIT
          WHEN LRF_REGISTROSDETALLES%NOTFOUND;
          END LOOP;
          CLOSE LRF_REGISTROSDETALLES;
          IF LB_EXISTIOERROR THEN
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOERROROLTS, SUBSTR('Se presentaron errores al  procesar los detalles de Olts: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000), LV_STATUS, LV_MENSAJE);
          ELSE
            FOR R_OLT IN C_GETOLTSMIGRAR(LN_IDMIGRACIONCAB)
            LOOP
              DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_MIGRACION_OLT_SAFECITY( R_OLT.ID_ELEMENTO_A, R_OLT.ID_ELEMENTO_B, LV_STATUS, LV_MENSAJE);
              IF LV_STATUS = 'OK' THEN
                COMMIT;
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_WS_NETWORKING( R_OLT.ID_ELEMENTO_A);
                LN_ITEMOLTMIGRADO                            := LN_ITEMOLTMIGRADO + 1;
                LR_REGELEMENTOSMIGRAOLT                      := NULL;
                LR_REGELEMENTOSMIGRAOLT.IDELEMENTOA          := R_OLT.ID_ELEMENTO_A;
                LR_REGELEMENTOSMIGRAOLT.IDELEMENTOB          := R_OLT.ID_ELEMENTO_B;
                LT_TREGSELEMENTOSMIGRAOLT(LN_ITEMOLTMIGRADO) := LR_REGELEMENTOSMIGRAOLT;
              ELSE
                ROLLBACK;
                LB_EJECUTARROLLBACKOLT                 := TRUE;
                IF LN_ITEMOLTMIGRADO                    > 0 THEN
                  LN_IDX_TREGSELEMENTOSMIGRAOLT        := LT_TREGSELEMENTOSMIGRAOLT.FIRST;
                  WHILE (LN_IDX_TREGSELEMENTOSMIGRAOLT IS NOT NULL)
                  LOOP
                    LR_REGELEMENTOSMIGRAOLT := LT_TREGSELEMENTOSMIGRAOLT (LN_IDX_TREGSELEMENTOSMIGRAOLT);
                    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ROLLBACK_OLT_SAFECITY( LR_REGELEMENTOSMIGRAOLT.IDELEMENTOA, LR_REGELEMENTOSMIGRAOLT.IDELEMENTOB, LV_STATUS, LV_MENSAJE);
                    LN_IDX_TREGSELEMENTOSMIGRAOLT := LT_TREGSELEMENTOSMIGRAOLT.NEXT(LN_IDX_TREGSELEMENTOSMIGRAOLT);
                  END LOOP;
                END IF;
                EXIT;
              END IF;
            END LOOP;
            IF LB_EJECUTARROLLBACKOLT THEN
              DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOERROROLTS, SUBSTR('Se presentaron errores al  procesar las migraciones de Olts referente a GPON-MPLS: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000), LV_STATUS, LV_MENSAJE);
            ELSE
              DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOOKOLTS, 'Registros de Olts procesados correctamente', LV_STATUS, LV_MENSAJE);
            END IF;
          END IF;
        ELSE
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOFALLOOLTS, SUBSTR('Se presentó un error al actualizar los detalles de Olts: '||LV_MENSAJE,0,4000), LV_STATUS, LV_MENSAJE);
        END IF;
      ELSE
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOFALLOOLTS, SUBSTR('Se presentó un error al obtener los detalles de Olts: '||LV_MENSAJE,0,4000), LV_STATUS, LV_MENSAJE);
      END IF;
    ELSE
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOFALLOOLTS, 'Ocurrio un error al procesar la cabecera: '|| LV_MENSAJE, LV_STATUS, LV_MENSAJE);
    END IF;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Proceso terminó de ejecutarse';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Ocurrió un error no controlado en la ejecución';
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOERROROLTS, 'Ocurrio un error al procesar la cabecera: '|| LV_MENSAJE, LV_STATUS, LV_MENSAJE);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_PROCESAR_OLTS', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
  END P_PROCESAR_OLTS;
  PROCEDURE P_REVERSAR_CAB_MIGRACION(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  AS
    CURSOR C_GETOLTSMIGRAR (CN_IDMIGRACAB NUMBER)
    IS
      SELECT
        (SELECT ID_ELEMENTO
        FROM INFO_ELEMENTO
        WHERE NOMBRE_ELEMENTO = ELEMENTO_A
        AND ESTADO            = 'Migrado'
        AND ROWNUM           <=1
        ) ID_ELEMENTO
    FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
    WHERE MIGRACION_CAB_ID=CN_IDMIGRACAB
    AND TIPO_REGISTRO     ='OLT'
    GROUP BY ELEMENTO_A;
    LV_ESTADOACTIVO         VARCHAR2(30) := 'Activo';
    LV_ESTADOCONNECTED      VARCHAR2(30) := 'connected';
    LV_ESTADONOTCONNECT     VARCHAR2(30) := 'not connect';
    LV_ESTADOPROCESANDOOLTS VARCHAR2(30) := 'ProcesandoOlts';
    LV_ESTADOPROCESANDODET  VARCHAR2(30) := 'Procesando';
    LV_ESTADOPENDIENTE      VARCHAR2(30) := 'Pendiente';
    LV_ESTADOOKOLTS         VARCHAR2(30) := 'OkOlts';
    LV_ESTADOOKOLTSDET      VARCHAR2(30) := 'Ok';
    LV_ESTADOMIGRADO        VARCHAR2(30) := 'Migrado';
    LV_ESTADOOK             VARCHAR2(30) := 'OK';
    LV_TIPOREGISTRO         VARCHAR2(30) := 'OLT';
    LV_ESTADOFALLOOLTS      VARCHAR2(30) := 'FalloOlts';
    LV_ESTADOERROROLTS      VARCHAR2(30) := 'ErrorReverso';
    LV_ESTADOERROROLTSDET   VARCHAR2(30) := 'Error';
    LV_USRCREACION          VARCHAR2(100):= 'migracion';
    LV_IPCREACION           VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LN_IDMIGRACIONCAB      NUMBER;
    LV_ESTADOCABREQUEST    VARCHAR2(50) := '';
    LN_IDENLACE            NUMBER;
    LN_IDINTERFACEELEMENTO NUMBER;
    LB_EXISTIOERROR        BOOLEAN := FALSE;
    LV_STATUS              VARCHAR2(50);
    LV_MENSAJE             VARCHAR2(4000);
    LV_MENSAJEEX           VARCHAR2(4000) := '';
    LRF_REGISTROSDETALLES SYS_REFCURSOR;
    LN_INDXREGLISTADODETALLES NUMBER := 0;
    LN_ID_INT_ELE_NUEVO       NUMBER := 0;
    LR_INFOENLACEREG DB_INFRAESTRUCTURA.INFO_ENLACE%ROWTYPE;
    LR_REGINFODETALLEMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_INFODETALLEMIGRACION;
    LT_TREGSINFODETALLEMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_INFODETALLEMIGRACION;
    LR_REGELEMENTOSMIGRAOLT DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_ELEMENTOSMIGRAOLT;
    LT_TREGSELEMENTOSMIGRAOLT DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_ELEMENTOSMIGRAOLT;
    LR_INFOMIGRAADDATA DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA%ROWTYPE := NULL;
    LN_INDXREGELEMENTOSMIGRAOLT NUMBER                               := 0;
    LN_ITEMOLTMIGRADO           NUMBER                               := 0;
    LB_EXISTIERONERRORES        BOOLEAN                              := FALSE;
  BEGIN
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONREQUEST;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    LN_IDMIGRACIONCAB   := TRIM(APEX_JSON.GET_NUMBER(P_PATH => 'idMigracionCab'));
    LV_ESTADOCABREQUEST := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'));
    IF LV_ESTADOCABREQUEST = 'ProcesandoReverso' THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_SCOPES( LN_IDMIGRACIONCAB, LV_STATUS, LV_MENSAJE);
      IF LV_STATUS                          != 'OK' THEN
        LV_MENSAJEEX                        := SUBSTR(LV_MENSAJEEX || ' - ' || LV_MENSAJE,0,4000);
        LB_EXISTIERONERRORES                := TRUE;
        LR_INFOMIGRAADDATA                  := NULL;
        LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
        LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'SCOPES';
        LR_INFOMIGRAADDATA.LOGIN            := NULL;
        LR_INFOMIGRAADDATA.ESTADO           := 'Error';
        LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJE,0,4000);
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
      END IF;
    END IF;
    LV_STATUS             := '';
    LV_MENSAJE            := '';
    IF LV_ESTADOCABREQUEST = 'ProcesandoReverso' OR LV_ESTADOCABREQUEST = 'ErrorClientes' THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_CLIENTES( LN_IDMIGRACIONCAB, LV_STATUS, LV_MENSAJE);
      IF LV_STATUS                          != 'OK' THEN
        LV_MENSAJEEX                        := SUBSTR(LV_MENSAJEEX || ' - ' || LV_MENSAJE,0,4000);
        LB_EXISTIERONERRORES                := TRUE;
        LR_INFOMIGRAADDATA                  := NULL;
        LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
        LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'CLIENTES';
        LR_INFOMIGRAADDATA.LOGIN            := NULL;
        LR_INFOMIGRAADDATA.ESTADO           := 'Error';
        LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJE,0,4000);
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
      END IF;
    END IF;
    LV_STATUS             := '';
    LV_MENSAJE            := '';
    IF LV_ESTADOCABREQUEST = 'ErrorEnlaces' THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_ENLACES( LN_IDMIGRACIONCAB, LV_STATUS, LV_MENSAJE);
      IF LV_STATUS                          != 'OK' THEN
        LV_MENSAJEEX                        := SUBSTR(LV_MENSAJEEX || ' - ' || LV_MENSAJE,0,4000);
        LR_INFOMIGRAADDATA                  := NULL;
        LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
        LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'ENLACES';
        LR_INFOMIGRAADDATA.LOGIN            := NULL;
        LR_INFOMIGRAADDATA.ESTADO           := 'Error';
        LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJE,0,4000);
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
      END IF;
    END IF;
    LV_STATUS             := '';
    LV_MENSAJE            := '';
    IF LV_ESTADOCABREQUEST = 'ProcesandoReverso' OR LV_ESTADOCABREQUEST = 'ErrorSplitters' THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_SPLITTERS( LN_IDMIGRACIONCAB, LV_STATUS, LV_MENSAJE);
      IF LV_STATUS != 'OK' THEN
        LV_MENSAJEEX                        := SUBSTR(LV_MENSAJEEX || ' - ' || LV_MENSAJE,0,4000);
        LB_EXISTIERONERRORES                := TRUE;
        LR_INFOMIGRAADDATA                  := NULL;
        LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
        LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'SPLITTERS';
        LR_INFOMIGRAADDATA.LOGIN            := NULL;
        LR_INFOMIGRAADDATA.ESTADO           := 'Error';
        LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJE,0,4000);
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
      END IF;
    END IF;
    LV_STATUS             := '';
    LV_MENSAJE            := '';
    IF LV_ESTADOCABREQUEST = 'ProcesandoReverso' OR LV_ESTADOCABREQUEST = 'ErrorOlts' THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_OLTS( LN_IDMIGRACIONCAB, LV_STATUS, LV_MENSAJE);
      IF LV_STATUS                          != 'OK' THEN
        LV_MENSAJEEX                        := SUBSTR(LV_MENSAJEEX || ' - ' || LV_MENSAJE,0,4000);
        LB_EXISTIERONERRORES                := TRUE;
        LR_INFOMIGRAADDATA                  := NULL;
        LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
        LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'OLTS';
        LR_INFOMIGRAADDATA.LOGIN            := NULL;
        LR_INFOMIGRAADDATA.ESTADO           := 'Error';
        LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJE,0,4000);
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
      END IF;
    END IF;
    FOR R_OLT IN C_GETOLTSMIGRAR(LN_IDMIGRACIONCAB)
    LOOP
      IF R_OLT.ID_ELEMENTO IS NOT NULL THEN
        UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO
        SET ESTADO        = 'Activo'
        WHERE ID_ELEMENTO = R_OLT.ID_ELEMENTO;
        COMMIT;
      END IF;
    END LOOP;
    IF LB_EXISTIERONERRORES THEN
      PV_STATUS := 'ReversadoConErrores';
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, PV_STATUS , 'Ocurrio un error al reversar la cabecera: '|| LV_MENSAJEEX, LV_STATUS, LV_MENSAJE);
    ELSE
      PV_STATUS := 'Reversado';
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, PV_STATUS, 'Se reversó correctamente la cabecera.', LV_STATUS, LV_MENSAJE);
    END IF;
    PV_MENSAJE := 'Proceso terminó de ejecutarse';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS    := 'ReversadoConErrores';
    PV_MENSAJE   := 'Ocurrió un error no controlado en la ejecución';
    LV_MENSAJEEX := SUBSTR(LV_MENSAJEEX || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000);
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, PV_STATUS, 'Ocurrio un error al procesar la cabecera: '|| LV_MENSAJEEX, LV_STATUS, LV_MENSAJE);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_CAB_MIGRACION', LV_MENSAJEEX , LV_USRCREACION, SYSDATE, LV_IPCREACION);
  END P_REVERSAR_CAB_MIGRACION;
  PROCEDURE P_REVERSAR_CLIENTES(
      PN_IDMIGRACION IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  AS
    LV_TIPOREGISTRO   VARCHAR2(15) := 'OLT';
    LN_IDMIGRACIONDET NUMBER       := 0;
    CURSOR C_GET_CLIENTES_MIGRADOS (CN_MIGRACION_CAB_ID NUMBER)
    IS
      SELECT ELEMENTO_A      AS NOMBRE_OLT_ANTERIOR,
        INTERFACE_ELEMENTO_A AS PON_ANTERIOR,
        ELEMENTO_B           AS NOMBRE_OLT_MIGRADO,
        INTERFACE_ELEMENTO_B AS PON_MIGRADO,
        ID_MIGRACION_DET
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
      WHERE MIGRACION_CAB_ID = CN_MIGRACION_CAB_ID
      AND TIPO_REGISTRO      = LV_TIPOREGISTRO;
    CURSOR C_GETINTERFACE (CV_NOMBREELEMENTO VARCHAR2, CV_NUMEROINTERFACE VARCHAR2)
    IS
      SELECT DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID,
        DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO,
        DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO
      WHERE DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO                       = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.MODELO_ELEMENTO_ID                  = DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.ID_MODELO_ELEMENTO
      AND DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.MARCA_ELEMENTO_ID            = DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.ID_MARCA_ELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO                     = CV_NOMBREELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO = CV_NUMEROINTERFACE
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO                             IN ('Activo', 'Migrado')
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO                   IN ('connected', 'not connect', 'Migrado');
    LV_MENSAJE   VARCHAR2(4000)                                                 := '';
    LV_MENSAJEEX VARCHAR2(4000)                                                 := '';
    LC_GET_CLIENTES_MIGRADOS C_GET_CLIENTES_MIGRADOS%ROWTYPE;
    LR_INFOINFERFACEINI C_GETINTERFACE%ROWTYPE := NULL;
    LR_INFOINFERFACEFIN C_GETINTERFACE%ROWTYPE := NULL;
    LN_CANTIDADCLIENTES NUMBER                 := 0;
    LV_IPCREACION       VARCHAR2(20)           := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LV_USRCREACION      VARCHAR2(100)          := 'migracion';
    LV_STATUS           VARCHAR2(5);
    LE_EXCEPTION        EXCEPTION;
    LB_EXISTIOERROR     BOOLEAN := FALSE;
    LV_MENSAJEMIGRACION VARCHAR2(4000);
    LR_INFOMIGRAADDATA DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA%ROWTYPE := NULL;
    LN_IDMIGRACIONCAB   NUMBER;
    LV_ESTADOCONNECTED  VARCHAR2(30) := 'connected';
    LV_ESTADONOTCONNECT VARCHAR2(30) := 'not connect';
    LV_ESTADOPROCESANDO VARCHAR2(30) := 'Procesando';
    LV_ESTADOERROR      VARCHAR2(30) := 'ErrorReverso';
    LV_ESTADOACTIVO     VARCHAR2(30) := 'Activo';
    LV_ESTADOOK         VARCHAR2(30) := 'OkReverso';
    LRF_REGISTROSSERVICIOS SYS_REFCURSOR;
    LR_REGINFOSERVICIOSMIGRA DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_INFOSERVICIOSMIGRACION;
    LT_TREGSINFOSERVICIOSMIGRA DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_INFOSERVICIOSMIGRACION;
    LN_INDXREGLISTADOSERVICIOS NUMBER := 0;
  BEGIN
    LV_MENSAJE:='';
    FOR LC_GET_CLIENTES_MIGRADOS IN C_GET_CLIENTES_MIGRADOS(PN_IDMIGRACION)
    LOOP
      LN_IDMIGRACIONDET := LC_GET_CLIENTES_MIGRADOS.ID_MIGRACION_DET;
      BEGIN
        OPEN C_GETINTERFACE (LC_GET_CLIENTES_MIGRADOS.NOMBRE_OLT_ANTERIOR, LC_GET_CLIENTES_MIGRADOS.PON_ANTERIOR);
        FETCH C_GETINTERFACE INTO LR_INFOINFERFACEINI;
        CLOSE C_GETINTERFACE;
        OPEN C_GETINTERFACE (LC_GET_CLIENTES_MIGRADOS.NOMBRE_OLT_MIGRADO, LC_GET_CLIENTES_MIGRADOS.PON_MIGRADO);
        FETCH C_GETINTERFACE INTO LR_INFOINFERFACEFIN;
        CLOSE C_GETINTERFACE;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_SERVICIOS( LR_INFOINFERFACEFIN.ELEMENTO_ID, LR_INFOINFERFACEFIN.ID_INTERFACE_ELEMENTO, LN_CANTIDADCLIENTES, LV_MENSAJE, LRF_REGISTROSSERVICIOS);
        LOOP
          FETCH LRF_REGISTROSSERVICIOS BULK COLLECT
          INTO LT_TREGSINFOSERVICIOSMIGRA LIMIT 100;
          LN_INDXREGLISTADOSERVICIOS        := LT_TREGSINFOSERVICIOSMIGRA.FIRST;
          WHILE (LN_INDXREGLISTADOSERVICIOS IS NOT NULL)
          LOOP
            BEGIN
              LV_MENSAJEMIGRACION      := 'OK';
              LV_STATUS                := '';
              LV_MENSAJE               := '';
              LR_REGINFOSERVICIOSMIGRA := LT_TREGSINFOSERVICIOSMIGRA(LN_INDXREGLISTADOSERVICIOS);
              UPDATE DB_COMERCIAL.INFO_SERVICIO_TECNICO
              SET ELEMENTO_ID                                      = LR_INFOINFERFACEINI.ELEMENTO_ID,
                INTERFACE_ELEMENTO_ID                              = LR_INFOINFERFACEINI.ID_INTERFACE_ELEMENTO
              WHERE DB_COMERCIAL.INFO_SERVICIO_TECNICO.SERVICIO_ID = LR_REGINFOSERVICIOSMIGRA.IDSERVICIO;
              IF LR_INFOINFERFACEFIN.NOMBRE_MARCA_ELEMENTO         = 'ZTE' AND LR_REGINFOSERVICIOSMIGRA.TIPOPRODUCTO = 'GPON' AND LR_REGINFOSERVICIOSMIGRA.ACTUALIZASPID = 'SI' THEN
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSA_CARACT_ZTE( LR_REGINFOSERVICIOSMIGRA.IDSERVICIO, LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO, LV_STATUS, LV_MENSAJE);
                IF LV_STATUS           = 'ERROR' THEN
                  LV_MENSAJEMIGRACION := LV_MENSAJE;
                  RAISE LE_EXCEPTION;
                END IF;
              END IF;
              IF LR_REGINFOSERVICIOSMIGRA.ACTUALIZASPID = 'SI' AND LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO IN ('EnPruebas','EnVerificacion','In-Corte','Activo') THEN
                IF LR_REGINFOSERVICIOSMIGRA.SPID       IS NOT NULL THEN
                  DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSA_SPID( LR_REGINFOSERVICIOSMIGRA.IDSERVICIO, LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO, LV_STATUS, LV_MENSAJE);
                  IF LV_STATUS           = 'ERROR' THEN
                    LV_MENSAJEMIGRACION := LV_MENSAJE;
                    RAISE LE_EXCEPTION;
                  END IF;
                ELSE
                  LV_MENSAJEMIGRACION := 'No existe caracteristica SPID en el servicio a reservar.';
                  RAISE LE_EXCEPTION;
                END IF;
              END IF;
              IF LR_REGINFOSERVICIOSMIGRA.TIPOPRODUCTO = 'GPON-MPLS' THEN
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ROLLBACK_SERVICIOS_SAFECITY( LR_REGINFOSERVICIOSMIGRA.IDSERVICIO,
                                                                                                LR_INFOINFERFACEINI.ELEMENTO_ID,
                                                                                                LR_INFOINFERFACEFIN.ELEMENTO_ID,
                                                                                                LR_INFOINFERFACEINI.NOMBRE_MARCA_ELEMENTO,
                                                                                                LR_INFOINFERFACEFIN.NOMBRE_MARCA_ELEMENTO,
                                                                                                LV_STATUS,
                                                                                                LV_MENSAJE );
                IF LV_STATUS           = 'ERROR' THEN
                  LV_MENSAJEMIGRACION := LV_MENSAJE;
                  RAISE LE_EXCEPTION;
                END IF;
              END IF;
              INSERT
              INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                (
                  ID_SERVICIO_HISTORIAL,
                  SERVICIO_ID,
                  USR_CREACION,
                  FE_CREACION,
                  IP_CREACION,
                  ESTADO,
                  OBSERVACION
                )
                VALUES
                (
                  DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                  LR_REGINFOSERVICIOSMIGRA.IDSERVICIO,
                  LV_USRCREACION,
                  SYSDATE,
                  LV_IPCREACION,
                  LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO,
                  'Reversado correctamente.'
                );
              COMMIT;
            EXCEPTION
            WHEN LE_EXCEPTION THEN
              ROLLBACK;
              LB_EXISTIOERROR                     := TRUE;
              LR_INFOMIGRAADDATA                  := NULL;
              LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
              LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
              LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'CLIENTE-REVERSO';
              LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_REGINFOSERVICIOSMIGRA.IDSERVICIO;
              LR_INFOMIGRAADDATA.LOGIN            := NVL(LR_REGINFOSERVICIOSMIGRA.LOGIN,'') ||','||NVL(LR_REGINFOSERVICIOSMIGRA.LOGINAUX,'');
              LR_INFOMIGRAADDATA.ESTADO           := 'Error';
              LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJEMIGRACION,0,4000);
              DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
              COMMIT;
            WHEN OTHERS THEN
              LB_EXISTIOERROR := TRUE;
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_CLIENTES', SUBSTR('Se presentó un error al migrar cliente:  IdServicio : '||LR_REGINFOSERVICIOSMIGRA.IDSERVICIO||' '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
              LV_MENSAJEMIGRACION := SUBSTR('Se presentó un error al migrar cliente:  - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
              ROLLBACK;
              LR_INFOMIGRAADDATA                  := NULL;
              LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
              LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
              LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'CLIENTE-REVERSO';
              LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_REGINFOSERVICIOSMIGRA.IDSERVICIO;
              LR_INFOMIGRAADDATA.LOGIN            := NVL(LR_REGINFOSERVICIOSMIGRA.LOGIN,'') ||','||NVL(LR_REGINFOSERVICIOSMIGRA.LOGINAUX,'');
              LR_INFOMIGRAADDATA.ESTADO           := 'Error';
              LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJEMIGRACION,0,4000);
              DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
              COMMIT;
            END;
            LN_INDXREGLISTADOSERVICIOS := LT_TREGSINFOSERVICIOSMIGRA.NEXT(LN_INDXREGLISTADOSERVICIOS);
          END LOOP;
          EXIT
        WHEN LRF_REGISTROSSERVICIOS%NOTFOUND;
        END LOOP;
        CLOSE LRF_REGISTROSSERVICIOS;
        IF LB_EXISTIOERROR THEN
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE(LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, 'Existieron errores en reversos de ciertos servicios en el puerto pon.');
        ELSE
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE(LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOOK, 'Clientes reversado correctamente en el puerto pon');
        END IF;
        COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
        LV_MENSAJEEX := SUBSTR('Se presentó un error al actualizar el detalle de clientes: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_CLIENTES', SUBSTR('Se presentó un error al migrar cliente. - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
        ROLLBACK;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, LV_MENSAJEEX);
        COMMIT;
      END;
    END LOOP;
    IF LB_EXISTIOERROR THEN
      PV_STATUS  := 'ERROR';
      PV_MENSAJE := 'Ocurrieron errores durante la ejecución.';
    ELSE
      PV_STATUS  := 'OK';
      PV_MENSAJE := 'Proceso Ejecutado correctamente.';
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Ocurrió un error no controlado en la ejecución';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_CLIENTES', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
  END P_REVERSAR_CLIENTES;
  PROCEDURE P_REVERSAR_ENLACES
    (
      PN_IDMIGRACION IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    CURSOR C_GET_REVERSO_ENLACES
      (
        CN_IDMIGRACIONCABECERA NUMBER
      )
    IS
      SELECT TIPO_PROCESO,
        MIGRACION_DET_ID,
        IDENTIFICADOR,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
      WHERE MIGRACION_CAB_ID = CN_IDMIGRACIONCABECERA
      AND TIPO_PROCESO LIKE 'ENLACE_%';
    LV_MENSAJE   VARCHAR2 ( 4000 ) := '';
    LV_MENSAJEEX VARCHAR2(4000)    := '';
    LC_GET_REVERSO_ENLACES C_GET_REVERSO_ENLACES%ROWTYPE;
    LV_IPCREACION  VARCHAR2(20)  := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LV_USRCREACION VARCHAR2(100) := 'migracion';
  BEGIN
    FOR LC_GET_REVERSO_ENLACES IN C_GET_REVERSO_ENLACES(PN_IDMIGRACION)
    LOOP
      BEGIN
        IF LC_GET_REVERSO_ENLACES.TIPO_PROCESO = 'ENLACE_INTERFACE' THEN
          UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
          SET ESTADO                  = LC_GET_REVERSO_ENLACES.ESTADO
          WHERE ID_INTERFACE_ELEMENTO = LC_GET_REVERSO_ENLACES.IDENTIFICADOR;
        ELSE
          UPDATE DB_INFRAESTRUCTURA.INFO_ENLACE
          SET ESTADO      = LC_GET_REVERSO_ENLACES.ESTADO
          WHERE ID_ENLACE = LC_GET_REVERSO_ENLACES.IDENTIFICADOR;
        END IF;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE(LC_GET_REVERSO_ENLACES.MIGRACION_DET_ID, 'ENLACE', 'OK', 'ReversoOk', 'Se reversó el enlace correctamente.');
      EXCEPTION
      WHEN OTHERS THEN
        LV_MENSAJEEX := SUBSTR('Se presentó un error al reversar el detalle de enlaces: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_ENLACES', LV_MENSAJEEX, LV_USRCREACION, SYSDATE, LV_IPCREACION);
        ROLLBACK;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE(LC_GET_REVERSO_ENLACES.MIGRACION_DET_ID, 'ENLACE', 'OK', 'ReversoError', LV_MENSAJEEX);
        COMMIT;
      END;
    END LOOP;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Proceso terminado.';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Ocurrió un error no controlado en la ejecución';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSAR_ENLACES', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
  END P_REVERSAR_ENLACES;
  PROCEDURE P_INFO_AGRUPAMIENTO(
      PV_TIPOREGISTRO IN VARCHAR2,
      PN_CANTIDADAGRUPAMIENTO OUT NUMBER,
      PV_CAMPOHILOS OUT VARCHAR2,
      PV_ESTADONUEVO OUT VARCHAR2,
      PV_ESTADOACTUAL OUT VARCHAR2,
      PV_ESTADOERROR OUT VARCHAR2 )
  AS
    LV_MENSAJE              VARCHAR2 ( 4000 ) := '';
    LV_ESTADOACTIVO         VARCHAR2(10)      := 'Activo';
    LV_NOMBREPARAMETRO      VARCHAR2(200)     := 'PARAMETROS_MIGRACION_ALTA_DENSIDAD';
    LV_DATOSREINTENTO       VARCHAR2(200)     := 'CANTIDAD_AGRUPAMIENTO_';
    LV_CANTIDADAGRUPAMIENTO VARCHAR2(4)       := '';
    LV_CAMPOHILOS           VARCHAR2(100)     := '';
    CURSOR C_OBTENERCANTIDADAGRUPAMIENTO
    IS
      SELECT NVL(VALOR1, '1'),
        VALOR2,
        VALOR3,
        VALOR4,
        VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE ESTADO     = LV_ESTADOACTIVO
      AND PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = LV_NOMBREPARAMETRO
        AND ESTADO             = LV_ESTADOACTIVO
        AND ROWNUM             = 1
        )
    AND DESCRIPCION = LV_DATOSREINTENTO
      || PV_TIPOREGISTRO
    AND ROWNUM = 1;
  BEGIN
    PN_CANTIDADAGRUPAMIENTO := 1;
    OPEN C_OBTENERCANTIDADAGRUPAMIENTO;
    FETCH C_OBTENERCANTIDADAGRUPAMIENTO
    INTO LV_CANTIDADAGRUPAMIENTO,
      PV_CAMPOHILOS,
      PV_ESTADONUEVO,
      PV_ESTADOACTUAL,
      PV_ESTADOERROR;
    CLOSE C_OBTENERCANTIDADAGRUPAMIENTO;
    PN_CANTIDADAGRUPAMIENTO := TO_NUMBER(LV_CANTIDADAGRUPAMIENTO,'999999');
  EXCEPTION
  WHEN OTHERS THEN
    PN_CANTIDADAGRUPAMIENTO := 1;
    PV_CAMPOHILOS           := '';
    PV_ESTADONUEVO          := '';
    PV_ESTADOACTUAL         := '';
    PV_ESTADOERROR          := '';
    LV_MENSAJE              := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_INFO_AGRUPAMIENTO', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_INFO_AGRUPAMIENTO;
  PROCEDURE P_VALIDAR_CAB_MIGRACION(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PCL_JSONRESPONSE OUT CLOB)
  AS
    LV_STATUS             VARCHAR2(10);
    LV_MENSAJE            VARCHAR2(4000);
    LV_CAMPOHILOS         VARCHAR2(100) := '';
    LV_IPCREACION         VARCHAR2(20)  := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LV_ESTADOERROR        VARCHAR2(100) := '';
    LV_ESTADONUEVO        VARCHAR2(100) := '';
    LV_USRCREACION        VARCHAR2(100) := 'migracion';
    LV_TIPOREGISTRO       VARCHAR2(30)  := '';
    LV_ESTADOACTUAL       VARCHAR2(100) := '';
    LV_ESTADOREQUEST      VARCHAR2(100) := '';
    LV_TIPOPROCESO        VARCHAR2(100) := '';
    LV_NOMBREOLT          VARCHAR2(250) := '';
    LN_CANTCLICONERROR    NUMBER        := 0;
    LN_CANTCLICONERRORPON NUMBER        := 0;
    LN_CANTMAXCLICONERROR NUMBER        := 0;
    LN_IDMIGRACIONCAB     NUMBER;
    LRF_REGISTROSDETALLES SYS_REFCURSOR;
    LN_CANTIDADAGRUPAMIENTO NUMBER;
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LN_INDXREGLISTADODETALLES NUMBER := 0;
    LN_CANTIDADTOTAL          NUMBER := 0;
    LN_CANTIDADOK             NUMBER := 0;
    LN_CANTIDADERROR          NUMBER := 0;
    LNTOTALFINALIZADOS        NUMBER := 0;
    LNIDCABREPORTE            NUMBER := 0;
    LR_REGINFODETALLEMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_INFODETALLEMIGRACION;
    LT_TREGSINFODETALLEMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_INFODETALLEMIGRACION;
    CURSOR C_GETCANTIDADMIGRACIONDET (CN_IDMIGRACIONCAB NUMBER, CV_TIPOREGISTRO VARCHAR2, CV_ESTADO VARCHAR2)
    IS
      SELECT NVL(COUNT(*),0)
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
      WHERE MIGRACION_CAB_ID=CN_IDMIGRACIONCAB
      AND TIPO_REGISTRO     =CV_TIPOREGISTRO
      AND ESTADO            = NVL(CV_ESTADO,ESTADO);
    CURSOR C_GETESTADOSNUEVOS (CV_ESTADO VARCHAR2)
    IS
      SELECT VALOR2,
        VALOR3
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
        AND ESTADO            ='Activo'
        )
    AND DESCRIPCION = 'ESTADOS_CABECERAS'
    AND VALOR1      = CV_ESTADO;
    CURSOR C_GETCANTCLICONERROR (CN_IDMIGRACIONCAB NUMBER)
    IS
      SELECT NVL(COUNT(*),0)
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
      WHERE MIGRACION_CAB_ID=CN_IDMIGRACIONCAB
      AND TIPO_PROCESO      ='CLIENTE'
      AND ESTADO            = 'Error';
   CURSOR C_GETCANTCLICONERRORPON (CN_IDMIGRACIONCAB NUMBER)
    IS
      SELECT NVL(COUNT(*),0)
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
      WHERE MIGRACION_CAB_ID=CN_IDMIGRACIONCAB
      AND TIPO_PROCESO      ='CLIENTE-PON'
      AND ESTADO            = 'Error';
    CURSOR C_GETCANTMAXCLICONERROR
    IS
      SELECT TO_NUMBER(VALOR1,'999999')
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
        AND ESTADO            ='Activo'
        )
    AND DESCRIPCION = 'MAXIMA_CANTIDAD_CLIENTES_CON_ERROR';
    CURSOR C_GETOLTSMIGRAR (CN_IDMIGRACAB NUMBER)
    IS
      SELECT
        (SELECT ID_ELEMENTO
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
        WHERE NOMBRE_ELEMENTO = ELEMENTO_A
        AND ESTADO            = 'Activo'
        AND ROWNUM           <=1
        ) ID_ELEMENTO
    FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
    WHERE MIGRACION_CAB_ID=CN_IDMIGRACAB
    AND TIPO_REGISTRO     ='OLT'
    GROUP BY ELEMENTO_A;
    CURSOR C_GETOLTSREPORTE (CN_IDMIGRACAB NUMBER)
    IS
      SELECT
        (SELECT ID_ELEMENTO
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
        WHERE NOMBRE_ELEMENTO = ELEMENTO_B
        AND ESTADO            = 'Activo'
        AND ROWNUM           <=1
        ) ID_ELEMENTO
    FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
    WHERE MIGRACION_CAB_ID=CN_IDMIGRACAB
    AND TIPO_REGISTRO     ='OLT'
    GROUP BY ELEMENTO_B;
  BEGIN
    PCL_JSONRESPONSE        := PCL_JSONREQUEST;
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONREQUEST;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    LN_IDMIGRACIONCAB := TRIM(APEX_JSON.GET_NUMBER(P_PATH => 'idMigracionCab'));
    LV_TIPOREGISTRO   := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoRegistro'));
    LV_TIPOPROCESO    := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoProceso'));
    LV_ESTADOACTUAL   := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'));
    LV_ESTADOREQUEST  := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'estado'));
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idMigracionCab', LN_IDMIGRACIONCAB, TRUE);
    OPEN C_GETCANTIDADMIGRACIONDET (LN_IDMIGRACIONCAB, LV_TIPOREGISTRO, NULL);
    FETCH C_GETCANTIDADMIGRACIONDET INTO LN_CANTIDADTOTAL;
    CLOSE C_GETCANTIDADMIGRACIONDET;
    OPEN C_GETCANTIDADMIGRACIONDET (LN_IDMIGRACIONCAB, LV_TIPOREGISTRO, 'Ok');
    FETCH C_GETCANTIDADMIGRACIONDET INTO LN_CANTIDADOK;
    CLOSE C_GETCANTIDADMIGRACIONDET;
    OPEN C_GETCANTIDADMIGRACIONDET (LN_IDMIGRACIONCAB, LV_TIPOREGISTRO, 'Error');
    FETCH C_GETCANTIDADMIGRACIONDET INTO LN_CANTIDADERROR;
    CLOSE C_GETCANTIDADMIGRACIONDET;
    LNTOTALFINALIZADOS := LN_CANTIDADOK + LN_CANTIDADERROR;
    IF LN_CANTIDADTOTAL = LNTOTALFINALIZADOS THEN
      OPEN C_GETESTADOSNUEVOS (LV_ESTADOACTUAL);
      FETCH C_GETESTADOSNUEVOS INTO LV_ESTADONUEVO, LV_ESTADOERROR;
      CLOSE C_GETESTADOSNUEVOS;
      IF LN_CANTIDADTOTAL = LN_CANTIDADOK THEN
        LV_ESTADOACTUAL  := LV_ESTADONUEVO;
      ELSE
        IF LV_TIPOPROCESO IS NOT NULL AND LV_TIPOPROCESO = 'CLIENTE' THEN
          OPEN C_GETCANTMAXCLICONERROR;
          FETCH C_GETCANTMAXCLICONERROR INTO LN_CANTMAXCLICONERROR;
          CLOSE C_GETCANTMAXCLICONERROR;
          OPEN C_GETCANTCLICONERROR (LN_IDMIGRACIONCAB);
          FETCH C_GETCANTCLICONERROR INTO LN_CANTCLICONERROR;
          CLOSE C_GETCANTCLICONERROR;
          OPEN C_GETCANTCLICONERRORPON (LN_IDMIGRACIONCAB);
          FETCH C_GETCANTCLICONERRORPON INTO LN_CANTCLICONERRORPON;
          CLOSE C_GETCANTCLICONERRORPON;
          IF LN_CANTCLICONERRORPON > 0 OR LN_CANTCLICONERROR > LN_CANTMAXCLICONERROR THEN
            LV_ESTADOACTUAL    := LV_ESTADOERROR;
          ELSE
            LV_ESTADOACTUAL := LV_ESTADONUEVO;
          END IF;
        ELSE
          LV_ESTADOACTUAL := LV_ESTADOERROR;
        END IF;
      END IF;
    END IF;
    IF LV_ESTADOREQUEST != LV_ESTADOACTUAL THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOACTUAL, 'Se actualiza el estado de la cabecera por finalización de procesamiento.', LV_STATUS, LV_MENSAJE);
      IF LV_ESTADOACTUAL = 'Migrado' OR LV_ESTADOACTUAL = 'MigradoConErrores' THEN
        FOR R_OLT IN C_GETOLTSMIGRAR(LN_IDMIGRACIONCAB)
        LOOP
          UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO
          SET ESTADO        = 'Migrado'
          WHERE ID_ELEMENTO = R_OLT.ID_ELEMENTO;
          COMMIT;
        END LOOP;
        LNIDCABREPORTE := DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_CAB.NEXTVAL;
        INSERT
        INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
          (
            ID_MIGRACION_CAB,
            NOMBRE,
            TIPO,
            ESTADO,
            OBSERVACION,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            USR_ULT_MOD,
            FE_ULT_MOD,
            IP_ULT_MOD
          )
          VALUES
          (
            LNIDCABREPORTE,
            'REPORTE_POST_MIGRACION_'
            ||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),
            'ReporteMigracion',
            'Pendiente',
            NULL,
            LV_USRCREACION,
            SYSDATE,
            LV_IPCREACION,
            NULL,
            NULL,
            NULL
          );
        COMMIT;
        FOR R_OLT IN C_GETOLTSREPORTE
        (
          LN_IDMIGRACIONCAB
        )
        LOOP
          SELECT NOMBRE_ELEMENTO
          INTO LV_NOMBREOLT
          FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
          WHERE ID_ELEMENTO = R_OLT.ID_ELEMENTO
          AND ESTADO        = 'Activo';
          INSERT
          INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
            (
              ID_MIGRACION_ERROR,
              MIGRACION_CAB_ID,
              TIPO_PROCESO,
              IDENTIFICADOR,
              INFORMACION,
              ESTADO,
              OBSERVACION,
              USR_CREACION,
              FE_CREACION
            )
            VALUES
            (
              DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_DATA.NEXTVAL,
              LNIDCABREPORTE,
              'ReportePosterior',
              R_OLT.ID_ELEMENTO,
              LV_NOMBREOLT,
              'Pendiente',
              'Pendiente ejecutar',
              LV_USRCREACION,
              SYSDATE
            );
          COMMIT;
        END LOOP;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REPORTE_MIGRA_PREV_DATA_TECN( LV_USRCREACION, 'ReportePosterior', LV_STATUS, LV_MENSAJE);
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZA_TABLA_MIGRACION( PV_ESTADO_ERR_CAB => 'Ok', PV_MENSAJE_CAB => 'Se ha enviado correo con los reportes adjuntos posterior a la migracion olt alta densidad', PV_TIPO_CAB => 'ReporteMigracion', PV_ESTADO_CAB => 'Pendiente', PV_ESTADO_DATA_ERR => 'Ok', PV_MENSAJE_DATA => 'Ok', PV_TIPO_DATA => 'ReportePosterior', PV_ESTADO_DATA => 'Pendiente');
      END IF;
    END IF;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Proceso terminó de ejecutarse';
    APEX_JSON.WRITE('estado', LV_ESTADOACTUAL, TRUE);
    APEX_JSON.CLOSE_OBJECT;
    PCL_JSONRESPONSE := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
  EXCEPTION
  WHEN OTHERS THEN
    APEX_JSON.WRITE('estado', LV_ESTADOREQUEST, TRUE);
    APEX_JSON.CLOSE_OBJECT;
    PCL_JSONRESPONSE := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    PCL_JSONRESPONSE := '{}';
    PV_STATUS        := 'ERROR';
    LV_MENSAJE       := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE       := 'No se ha podido realizar correctamente la validación.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_VALIDAR_CAB_MIGRACION', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_VALIDAR_CAB_MIGRACION;
  PROCEDURE P_AGRUPAR_DETALLES
    (
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PCL_JSONRESPONSE OUT CLOB
    )
  AS
    LV_STATUS VARCHAR2
    (
      5
    )
    ;
    LV_MENSAJE        VARCHAR2(4000);
    LV_CAMPOHILOS     VARCHAR2(100) := '';
    LV_IPCREACION     VARCHAR2(20)  := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LV_ESTADOERROR    VARCHAR2(100) := '';
    LV_ESTADONUEVO    VARCHAR2(100) := '';
    LV_USRCREACION    VARCHAR2(100) := 'migracion';
    LV_TIPOREGISTRO   VARCHAR2(30)  := '';
    LV_ESTADOACTUAL   VARCHAR2(100) := '';
    LN_CANTIDADITEMS  NUMBER        := 0;
    LN_IDMIGRACIONCAB NUMBER;
    LRF_REGISTROSDETALLES SYS_REFCURSOR;
    LN_CANTIDADAGRUPAMIENTO NUMBER;
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LN_INDXREGLISTADODETALLES NUMBER := 0;
    LR_REGINFODETALLEMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_INFODETALLEMIGRACION;
    LT_TREGSINFODETALLEMIGRACION DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_INFODETALLEMIGRACION;
  BEGIN
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONREQUEST;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    LN_IDMIGRACIONCAB := TRIM(APEX_JSON.GET_NUMBER(P_PATH => 'idMigracionCab'));
    LV_TIPOREGISTRO   := TRIM(APEX_JSON.GET_VARCHAR2(P_PATH => 'tipoRegistro'));
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idMigracionCab', LN_IDMIGRACIONCAB, TRUE);
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INFO_AGRUPAMIENTO(LV_TIPOREGISTRO, LN_CANTIDADAGRUPAMIENTO, LV_CAMPOHILOS, LV_ESTADONUEVO, LV_ESTADOACTUAL, LV_ESTADOERROR);
    APEX_JSON.OPEN_ARRAY(LV_CAMPOHILOS);
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADONUEVO, 'Se agrupan registros de '|| LV_TIPOREGISTRO, LV_STATUS, LV_MENSAJE);
    IF LV_STATUS = 'OK' THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_DETALLES_MIGRACION( LN_IDMIGRACIONCAB, LV_TIPOREGISTRO, LV_ESTADOACTUAL, LV_STATUS, LV_MENSAJE, LRF_REGISTROSDETALLES);
      IF LV_STATUS = 'OK' THEN
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLES( LN_IDMIGRACIONCAB, LV_TIPOREGISTRO, LV_ESTADOACTUAL, 'Procesando', LV_STATUS, LV_MENSAJE);
        IF LV_STATUS = 'OK' THEN
          LOOP
            FETCH LRF_REGISTROSDETALLES BULK COLLECT
            INTO LT_TREGSINFODETALLEMIGRACION LIMIT 200;
            LN_INDXREGLISTADODETALLES        := LT_TREGSINFODETALLEMIGRACION.FIRST;
            WHILE (LN_INDXREGLISTADODETALLES IS NOT NULL)
            LOOP
              LR_REGINFODETALLEMIGRACION := LT_TREGSINFODETALLEMIGRACION(LN_INDXREGLISTADODETALLES);
              LN_CANTIDADITEMS           := LN_CANTIDADITEMS + 1;
              IF LN_CANTIDADITEMS         = 1 THEN
                APEX_JSON.OPEN_OBJECT;
                APEX_JSON.OPEN_ARRAY('migracionDetItems');
              END IF;
              APEX_JSON.WRITE(LR_REGINFODETALLEMIGRACION.IDMIGRACIONDET);
              IF LN_CANTIDADITEMS = LN_CANTIDADAGRUPAMIENTO THEN
                APEX_JSON.CLOSE_ARRAY;
                APEX_JSON.CLOSE_OBJECT;
                LN_CANTIDADITEMS := 0;
              END IF;
              LN_INDXREGLISTADODETALLES := LT_TREGSINFODETALLEMIGRACION.NEXT(LN_INDXREGLISTADODETALLES);
            END LOOP;
            EXIT
          WHEN LRF_REGISTROSDETALLES%NOTFOUND;
          END LOOP;
          CLOSE LRF_REGISTROSDETALLES;
          IF LN_CANTIDADITEMS > 0 THEN
            APEX_JSON.CLOSE_ARRAY;
            APEX_JSON.CLOSE_OBJECT;
            LN_CANTIDADITEMS := 0;
          END IF;
        ELSE
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOERROR, SUBSTR('Se presentó un error al actualizar los detalles, '||LV_MENSAJE,0,4000), LV_STATUS, LV_MENSAJE);
        END IF;
      ELSE
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOERROR, SUBSTR('Se presentó un error al obtener los detalles: '||LV_MENSAJE,0,4000), LV_STATUS, LV_MENSAJE);
      END IF;
    ELSE
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( LN_IDMIGRACIONCAB, LV_ESTADOERROR, 'Ocurrio un error al procesar la cabecera: '|| LV_MENSAJE, LV_STATUS, LV_MENSAJE);
    END IF;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Proceso terminó de ejecutarse';
    APEX_JSON.CLOSE_ARRAY;
    APEX_JSON.CLOSE_OBJECT;
    PV_STATUS        := LV_STATUS;
    PV_MENSAJE       := LV_MENSAJE;
    PCL_JSONRESPONSE := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
  EXCEPTION
  WHEN OTHERS THEN
    PCL_JSONRESPONSE := '{}';
    PV_STATUS        := 'ERROR';
    LV_MENSAJE       := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE       := 'No se ha podido realizar correctamente el agrupamiento de detalles: '||LV_TIPOREGISTRO;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_AGRUPAR_DETALLES', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_AGRUPAR_DETALLES;
  PROCEDURE P_PROCESAR_SPLITTERS(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  AS
    CURSOR C_GETINFOELEMENTO (CV_NOMBRE_ELE_ANT VARCHAR2)
    IS
      SELECT IEL.ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IEL,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE
      WHERE IEL.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
      AND AME.TIPO_ELEMENTO_ID     = ATE.ID_TIPO_ELEMENTO
      AND IEL.NOMBRE_ELEMENTO      = CV_NOMBRE_ELE_ANT
      AND ATE.NOMBRE_TIPO_ELEMENTO = 'SPLITTER'
      AND IEL.ESTADO               = 'Activo';
    CURSOR C_GETMIGRACIONDET (CN_IDMIGRACIONDET NUMBER)
    IS
      SELECT AD_DET.ELEMENTO_A,
        AD_DET.ELEMENTO_B
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET AD_DET
      WHERE AD_DET.ID_MIGRACION_DET   = CN_IDMIGRACIONDET
      AND AD_DET.ESTADO               = 'Procesando';
    LV_ESTADOPROCESANDO VARCHAR2(30) := 'Procesando';
    LV_ESTADOOK         VARCHAR2(30) := 'Ok';
    LV_TIPOREGISTRO     VARCHAR2(30) := 'SPLITTER';
    LV_ESTADOERROR      VARCHAR2(30) := 'ErrorSplitters';
    LV_ESTADOERRORDET   VARCHAR2(30) := 'Error';
    LV_USRCREACION      VARCHAR2(100):= 'migracion';
    LV_IPCREACION       VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LN_IDMIGRACIONCAB NUMBER;
    LB_EXISTIOERROR   BOOLEAN := FALSE;
    LV_STATUS         VARCHAR2(5);
    LV_MENSAJE        VARCHAR2(4000);
    LV_MENSAJEEX      VARCHAR2(4000);
    LR_INFOELEMENTO C_GETINFOELEMENTO%ROWTYPE;
    LR_INFOMIGRACIONDET C_GETMIGRACIONDET%ROWTYPE;
    LN_IDELEMENTO     NUMBER := 0;
    LN_IDMIGRACIONDET NUMBER := 0;
  BEGIN
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONREQUEST;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    LN_IDMIGRACIONCAB := TRIM(APEX_JSON.GET_NUMBER(P_PATH => 'idMigracionCab'));
    FOR I IN 1 .. APEX_JSON.GET_COUNT ('hilosSplitters')
    LOOP
      FOR J IN 1 .. APEX_JSON.GET_COUNT ('hilosSplitters[%d].migracionDetItems', I)
      LOOP
        LN_IDMIGRACIONDET := APEX_JSON.GET_NUMBER ('hilosSplitters[%d].migracionDetItems[%d]', I, J);
        BEGIN
          OPEN C_GETMIGRACIONDET (LN_IDMIGRACIONDET);
          FETCH C_GETMIGRACIONDET INTO LR_INFOMIGRACIONDET;
          CLOSE C_GETMIGRACIONDET;
          OPEN C_GETINFOELEMENTO (LR_INFOMIGRACIONDET.ELEMENTO_A);
          FETCH C_GETINFOELEMENTO INTO LR_INFOELEMENTO;
          IF C_GETINFOELEMENTO%FOUND THEN
            LN_IDELEMENTO := LR_INFOELEMENTO.ID_ELEMENTO;
          ELSE
            LN_IDELEMENTO := 0;
          END IF;
          CLOSE C_GETINFOELEMENTO;
          IF LN_IDELEMENTO > 0 THEN
            UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO
            SET NOMBRE_ELEMENTO = LR_INFOMIGRACIONDET.ELEMENTO_B
            WHERE ID_ELEMENTO   = LN_IDELEMENTO;
            INSERT
            INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO
              (
                ID_HISTORIAL,
                ELEMENTO_ID,
                ESTADO_ELEMENTO,
                CAPACIDAD,
                OBSERVACION,
                USR_CREACION,
                FE_CREACION,
                IP_CREACION
              )
              VALUES
              (
                DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
                LN_IDELEMENTO,
                'Activo',
                NULL,
                'Se actualizó el nombre el elemento correctamente. Nombre anterior: '
                || LR_INFOMIGRACIONDET.ELEMENTO_A
                || ', Nombre Nuevo: '
                || LR_INFOMIGRACIONDET.ELEMENTO_B,
                LV_USRCREACION,
                SYSDATE,
                LV_IPCREACION
              );
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOOK, 'Splitter procesado correctamente.');
          ELSE
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERRORDET, 'No existe elementoA con estado Activo.');
          END IF;
          COMMIT;
        EXCEPTION
        WHEN OTHERS THEN
          LV_MENSAJEEX := SUBSTR('Se presentó un error al actualizar el detalle de splitter: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
          ROLLBACK;
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERRORDET, LV_MENSAJEEX);
          COMMIT;
        END;
      END LOOP;
    END LOOP;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Proceso terminó de ejecutarse';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Ocurrió un error no controlado en la ejecución';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_PROCESAR_SPLITTERS', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
  END P_PROCESAR_SPLITTERS;
  PROCEDURE P_PROCESAR_SCOPES
    (
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LV_ESTADOPROCESANDO VARCHAR2
    (
      50
    )
                             := 'Procesando';
    LV_ESTADOOK          VARCHAR2(30) := 'Ok';
    LV_TIPOREGISTRO      VARCHAR2(30) := 'SCOPE';
    LV_TIPO_REGISTRO_OLT VARCHAR2(30) := 'OLT';
    LV_ESTADO_ACTIVO     VARCHAR2(30) := 'Activo';
    LV_ESTADOERROR       VARCHAR2(30) := 'Error';
    LV_USRCREACION       VARCHAR2(100):= 'migracion';
    LV_IPCREACION        VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LN_IDMIGRACIONCAB NUMBER;
    LB_EXISTIOERROR   BOOLEAN := FALSE;
    LV_STATUS         VARCHAR2(5);
    LV_MENSAJE        VARCHAR2(4000);
    LV_MENSAJEEX      VARCHAR2(4000);
    LN_IDELEMENTO     NUMBER := 0;
    LN_IDMIGRACIONDET NUMBER := 0;
    LV_SCOPE_A        VARCHAR2(150);
    LV_SCOPE_B        VARCHAR2(150);
    CURSOR C_GET_SCOPES_MIGRA (CN_MIGRA_CAB_ID NUMBER, CN_MIGRA_DET_ID NUMBER)
    IS
      SELECT ELEMENTO_A,
        ELEMENTO_B
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
      WHERE MIGRACION_CAB_ID = CN_MIGRA_CAB_ID
      AND ID_MIGRACION_DET   = CN_MIGRA_DET_ID
      AND ESTADO             = LV_ESTADOPROCESANDO;
    CURSOR C_GET_OLT_BY_SCOPE (CV_NOMBRE_SCOPE VARCHAR2)
    IS
      SELECT ELEMENTO_ID
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE DETALLE_NOMBRE = LV_TIPOREGISTRO
      AND DETALLE_VALOR    = CV_NOMBRE_SCOPE
      GROUP BY ELEMENTO_ID;
    CURSOR C_GET_NOMBRE_ELEMENTO(CN_ELEMENTO_ID NUMBER)
    IS
      SELECT NOMBRE_ELEMENTO NOMBRE_OLT_A
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE ID_ELEMENTO = CN_ELEMENTO_ID
      AND ESTADO        = LV_ESTADO_ACTIVO;
    CURSOR C_GET_ELEMENTO_B_MIGRAR (CN_MIGRA_CAB_ID NUMBER, CV_ELEMENTO_A VARCHAR2)
    IS
      SELECT IE.ID_ELEMENTO ELEMENTO_B
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET DET,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO IE
      WHERE DET.ELEMENTO_B     = IE.NOMBRE_ELEMENTO
      AND DET.MIGRACION_CAB_ID = CN_MIGRA_CAB_ID
      AND DET.TIPO_REGISTRO    = LV_TIPO_REGISTRO_OLT
      AND DET.ELEMENTO_A       = CV_ELEMENTO_A
      GROUP BY IE.ID_ELEMENTO;
    CURSOR C_GET_VALIDA_OLT_EXISTE (CN_MIGRA_CAB_ID NUMBER, CV_ELEMENTO_A VARCHAR2)
    IS
      SELECT COUNT(1) AS COUNT_REG
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
      WHERE MIGRACION_CAB_ID = CN_MIGRA_CAB_ID
      AND TIPO_REGISTRO      = LV_TIPO_REGISTRO_OLT
      AND ELEMENTO_A         = CV_ELEMENTO_A;
    CURSOR C_GET_INFO_MIGRA_SCOPE(CN_ELEMENTO_OLT_ID NUMBER, CV_NOMBRE_SCOPE_A VARCHAR2)
    IS
      SELECT ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID  = CN_ELEMENTO_OLT_ID
      AND DETALLE_NOMBRE = LV_TIPOREGISTRO
      AND DETALLE_VALOR  = CV_NOMBRE_SCOPE_A;
    CURSOR C_GET_INFO_MIGRA_REFSUBRED (CN_ELEMENTO_OLT_ID NUMBER, CN_REF_DETALLE_ELEMENTO_ID NUMBER)
    IS
      SELECT ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID       = CN_ELEMENTO_OLT_ID
      AND DETALLE_NOMBRE      = 'SUBRED'
      AND ID_DETALLE_ELEMENTO = CN_REF_DETALLE_ELEMENTO_ID;
    CURSOR C_GET_INFO_MIGRA_SUBRED (CN_ID_SUBRED NUMBER)
    IS
      SELECT ID_SUBRED,
        RED_ID,
        SUBRED,
        MASCARA,
        GATEWAY,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        ELEMENTO_ID,
        NOTIFICACION,
        IP_INICIAL,
        IP_FINAL,
        IP_DISPONIBLE,
        TIPO,
        USO,
        SUBRED_ID,
        EMPRESA_COD,
        PREFIJO_ID,
        CANTON_ID,
        VERSION_IP,
        ANILLO
      FROM DB_INFRAESTRUCTURA.INFO_SUBRED
      WHERE ID_SUBRED = CN_ID_SUBRED;
    CURSOR C_GET_INFO_MIGRA_SUBRED_PRIMA (CN_ELEMENTO_OLT_ID NUMBER, CN_REF_DETALLE_ELEMENTO_ID NUMBER)
    IS
      SELECT ID_DETALLE_ELEMENTO,
            ELEMENTO_ID,
            DETALLE_NOMBRE,
            DETALLE_VALOR,
            DETALLE_DESCRIPCION,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            REF_DETALLE_ELEMENTO_ID,
            ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID           = CN_ELEMENTO_OLT_ID
      AND DETALLE_NOMBRE          = 'SUBRED PRIMARIA'
      AND REF_DETALLE_ELEMENTO_ID = CN_REF_DETALLE_ELEMENTO_ID;
    CURSOR C_GET_INFO_MIGRA_TIPO_SCOPE (CN_ELEMENTO_OLT_ID NUMBER, CN_REF_DETALLE_ELEMENTO_ID NUMBER)
    IS
      SELECT ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID           = CN_ELEMENTO_OLT_ID
      AND DETALLE_NOMBRE          = 'TIPO SCOPE'
      AND REF_DETALLE_ELEMENTO_ID = CN_REF_DETALLE_ELEMENTO_ID;
    CURSOR C_GET_INFO_MIGRA_SUBRED_TAG (CN_SUBRED_ID NUMBER)
    IS
      SELECT ID_SUBRED_TAG,
        SUBRED_ID,
        TAG_ID,
        USR_CREACION,
        FE_CREACION,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_SUBRED_TAG
      WHERE SUBRED_ID = CN_SUBRED_ID;
    CURSOR C_GET_ESTADO_ELEMENTO (CN_ELEMENTO_ID NUMBER)
    IS
      SELECT ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE ID_ELEMENTO = CN_ELEMENTO_ID;
    CURSOR C_VALIDA_ESTADO_SUBRED(CN_MIGRACION_CAB NUMBER, CN_ID_SUBRED NUMBER) IS
        SELECT COUNT(NOMBRE_SCOPE) AS COUNT_REG
        FROM 
        (SELECT ID_SUBRED,
          (SELECT EEE.DETALLE_VALOR
          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO EEE
          WHERE REF_DETALLE_ELEMENTO_ID=REFERENCIA_DETALLE_ELEMENTO_ID
          AND DETALLE_NOMBRE           = 'SCOPE'
          ) AS NOMBRE_SCOPE,
          (SELECT RRR.DETALLE_VALOR
          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO RRR
          WHERE REF_DETALLE_ELEMENTO_ID=REFERENCIA_DETALLE_ELEMENTO_ID
          AND DETALLE_NOMBRE           = 'TIPO SCOPE'
          ) AS TIPO_SCOPE,
          IP_SCOPE_INI,
          IP_SCOPE_FIN,
          ESTADO_RED,
          (SELECT NOMBRE_POLICY FROM DB_INFRAESTRUCTURA.ADMI_POLICY WHERE ID_POLICY=POLICESCOPE
          ) AS NOMBRE_POLICY
        FROM
          (SELECT ISD.ID_SUBRED AS ID_SUBRED,
            ISD.ESTADO          AS ESTADO_RED,
            ISD.IP_INICIAL      AS IP_SCOPE_INI,
            ISD.IP_FINAL        AS IP_SCOPE_FIN,
            ISD.NOTIFICACION    AS POLICESCOPE,
            (SELECT WWW.ID_DETALLE_ELEMENTO
            FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO WWW
            WHERE WWW.ELEMENTO_ID=IDE.ELEMENTO_ID
            AND WWW.DETALLE_VALOR= TO_CHAR(ISD.ID_SUBRED)
            ) AS REFERENCIA_DETALLE_ELEMENTO_ID
          FROM DB_INFRAESTRUCTURA.INFO_SUBRED ISD,
            DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE
          WHERE IDE.ELEMENTO_ID  IN (SELECT IE.ID_ELEMENTO
                                         FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET IMD,
                                              DB_INFRAESTRUCTURA.INFO_ELEMENTO IE
                                        WHERE IMD.ELEMENTO_A = IE.NOMBRE_ELEMENTO
                                        AND IMD.TIPO_REGISTRO = 'OLT'
                                        AND MIGRACION_CAB_ID = CN_MIGRACION_CAB
                                        GROUP BY IE.ID_ELEMENTO)
          AND IDE.DETALLE_NOMBRE IN ('SUBRED')
          AND IDE.DETALLE_VALOR   = ISD.ID_SUBRED
          )
        )
        WHERE ESTADO_RED    = 'Activo'
        AND NOMBRE_SCOPE IS NOT NULL
        AND ID_SUBRED = CN_ID_SUBRED;
    LC_GET_OLT_BY_SCOPE C_GET_OLT_BY_SCOPE%ROWTYPE;
    LC_GET_NOMBRE_ELEMENTO C_GET_NOMBRE_ELEMENTO%ROWTYPE;
    LC_GET_ELEMENTO_B_MIGRAR C_GET_ELEMENTO_B_MIGRAR%ROWTYPE;
    LC_GET_INFO_MIGRA_SCOPE C_GET_INFO_MIGRA_SCOPE%ROWTYPE;
    LC_GET_INFO_MIGRA_REFSUBRED C_GET_INFO_MIGRA_REFSUBRED%ROWTYPE;
    LC_GET_INFO_MIGRA_SUBRED C_GET_INFO_MIGRA_SUBRED%ROWTYPE;
    LC_GET_INFO_MIGRA_SUBRED_PRIMA C_GET_INFO_MIGRA_SUBRED_PRIMA%ROWTYPE;
    LC_GET_MIGRA_SUBRED_PRIMA_I C_GET_INFO_MIGRA_SUBRED_PRIMA%ROWTYPE;
    LC_GET_INFO_MIGRA_TIPO_SCOPE C_GET_INFO_MIGRA_TIPO_SCOPE%ROWTYPE;
    LC_GET_MIGRA_TIPO_SCOPE_I C_GET_INFO_MIGRA_TIPO_SCOPE%ROWTYPE;
    LC_GET_INFO_MIGRA_SUBRED_TAG C_GET_INFO_MIGRA_SUBRED_TAG%ROWTYPE;
    LC_GET_ESTADO_ELEMENTO C_GET_ESTADO_ELEMENTO%ROWTYPE;
    LE_EXCEPTION_REG        EXCEPTION;
    LN_EXISTE_ELEMENTO      NUMBER := 0;
    LV_MSJ_ERR              VARCHAR2(2000);
    LV_STATUS_ERR           VARCHAR2(2000);
    LN_ID_SUBRED            NUMBER := 0;
    LN_ID_DETALLE_ELEMENTO  NUMBER := 0;
    LN_ID_DET_ELEMENTO_NEXT NUMBER := 0;
    LN_COUNT_MIGRA_EXIST    NUMBER := 0;
    LN_COUNT_MIGRA_SCOPE    NUMBER := 0;
    LN_VALIDA_SUBRED        NUMBER := 0;
  BEGIN
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONREQUEST;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    LN_IDMIGRACIONCAB := TRIM(APEX_JSON.GET_NUMBER(P_PATH => 'idMigracionCab'));
    FOR I IN 1 .. APEX_JSON.GET_COUNT ('hilosScopes')
    LOOP
      FOR J IN 1 .. APEX_JSON.GET_COUNT ('hilosScopes[%d].migracionDetItems', I)
      LOOP
        LN_IDMIGRACIONDET := APEX_JSON.GET_NUMBER ('hilosScopes[%d].migracionDetItems[%d]', I, J);
        BEGIN
          OPEN C_GET_SCOPES_MIGRA(LN_IDMIGRACIONCAB,LN_IDMIGRACIONDET);
          FETCH C_GET_SCOPES_MIGRA INTO LV_SCOPE_A, LV_SCOPE_B;
          CLOSE C_GET_SCOPES_MIGRA;
          LN_COUNT_MIGRA_EXIST := 0;
          FOR LC_GET_OLT_BY_SCOPE IN C_GET_OLT_BY_SCOPE(LV_SCOPE_A)
          LOOP
            OPEN C_GET_NOMBRE_ELEMENTO(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID);
            FETCH C_GET_NOMBRE_ELEMENTO INTO LC_GET_NOMBRE_ELEMENTO;
            CLOSE C_GET_NOMBRE_ELEMENTO;
            OPEN C_GET_VALIDA_OLT_EXISTE(LN_IDMIGRACIONCAB,LC_GET_NOMBRE_ELEMENTO.NOMBRE_OLT_A);
            FETCH C_GET_VALIDA_OLT_EXISTE INTO LN_EXISTE_ELEMENTO;
            CLOSE C_GET_VALIDA_OLT_EXISTE;
            IF LN_EXISTE_ELEMENTO = 0 THEN
              LV_MENSAJE         := 'NO EXISTE EL ELEMENTO OLT '|| LC_GET_NOMBRE_ELEMENTO.NOMBRE_OLT_A ||' ASOCIADO AL SCOPE ORIGEN ' || LV_SCOPE_A ||' EN LA TABLA DE DETALLE DE MIGRACION.';
              RAISE LE_EXCEPTION_REG;
            END IF;
            FOR LC_GET_INFO_MIGRA_SCOPE IN C_GET_INFO_MIGRA_SCOPE(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID, LV_SCOPE_A) LOOP
                OPEN C_GET_INFO_MIGRA_REFSUBRED(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_INFO_MIGRA_SCOPE.REF_DETALLE_ELEMENTO_ID);
                FETCH C_GET_INFO_MIGRA_REFSUBRED INTO LC_GET_INFO_MIGRA_REFSUBRED;
                CLOSE C_GET_INFO_MIGRA_REFSUBRED;
                OPEN C_GET_INFO_MIGRA_SUBRED(LC_GET_INFO_MIGRA_REFSUBRED.DETALLE_VALOR);
                FETCH C_GET_INFO_MIGRA_SUBRED INTO LC_GET_INFO_MIGRA_SUBRED;
                CLOSE C_GET_INFO_MIGRA_SUBRED;
                OPEN C_GET_INFO_MIGRA_SUBRED_PRIMA(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_INFO_MIGRA_SCOPE.REF_DETALLE_ELEMENTO_ID);
                FETCH C_GET_INFO_MIGRA_SUBRED_PRIMA INTO LC_GET_INFO_MIGRA_SUBRED_PRIMA;
                CLOSE C_GET_INFO_MIGRA_SUBRED_PRIMA;
                OPEN C_GET_INFO_MIGRA_TIPO_SCOPE(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_INFO_MIGRA_SCOPE.REF_DETALLE_ELEMENTO_ID);
                FETCH C_GET_INFO_MIGRA_TIPO_SCOPE INTO LC_GET_INFO_MIGRA_TIPO_SCOPE;
                CLOSE C_GET_INFO_MIGRA_TIPO_SCOPE;
                FOR LC_GET_ELEMENTO_B_MIGRAR IN C_GET_ELEMENTO_B_MIGRAR(LN_IDMIGRACIONCAB,LC_GET_NOMBRE_ELEMENTO.NOMBRE_OLT_A)
                LOOP
                    BEGIN
                      LN_ID_SUBRED := DB_INFRAESTRUCTURA.SEQ_INFO_SUBRED.NEXTVAL;
                      INSERT
                      INTO DB_INFRAESTRUCTURA.INFO_SUBRED
                        (
                          ID_SUBRED,
                          RED_ID,
                          SUBRED,
                          MASCARA,
                          GATEWAY,
                          USR_CREACION,
                          FE_CREACION,
                          IP_CREACION,
                          ESTADO,
                          ELEMENTO_ID,
                          NOTIFICACION,
                          IP_INICIAL,
                          IP_FINAL,
                          IP_DISPONIBLE,
                          TIPO,
                          USO,
                          SUBRED_ID,
                          EMPRESA_COD,
                          PREFIJO_ID,
                          CANTON_ID,
                          VERSION_IP,
                          ANILLO
                        )
                        VALUES
                        (
                          LN_ID_SUBRED,
                          LC_GET_INFO_MIGRA_SUBRED.RED_ID,
                          LC_GET_INFO_MIGRA_SUBRED.SUBRED,
                          LC_GET_INFO_MIGRA_SUBRED.MASCARA,
                          LC_GET_INFO_MIGRA_SUBRED.GATEWAY,
                          LV_USRCREACION,
                          SYSDATE,
                          LV_IPCREACION,
                          LC_GET_INFO_MIGRA_SUBRED.ESTADO,
                          LC_GET_ELEMENTO_B_MIGRAR.ELEMENTO_B,
                          LC_GET_INFO_MIGRA_SUBRED.NOTIFICACION,
                          LC_GET_INFO_MIGRA_SUBRED.IP_INICIAL,
                          LC_GET_INFO_MIGRA_SUBRED.IP_FINAL,
                          LC_GET_INFO_MIGRA_SUBRED.IP_DISPONIBLE,
                          LC_GET_INFO_MIGRA_SUBRED.TIPO,
                          LC_GET_INFO_MIGRA_SUBRED.USO,
                          LC_GET_INFO_MIGRA_SUBRED.SUBRED_ID,
                          LC_GET_INFO_MIGRA_SUBRED.EMPRESA_COD,
                          LC_GET_INFO_MIGRA_SUBRED.PREFIJO_ID,
                          LC_GET_INFO_MIGRA_SUBRED.CANTON_ID,
                          LC_GET_INFO_MIGRA_SUBRED.VERSION_IP,
                          LC_GET_INFO_MIGRA_SUBRED.ANILLO
                        );
                      LN_ID_DETALLE_ELEMENTO := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;
                      INSERT
                      INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                        (
                          ID_DETALLE_ELEMENTO,
                          ELEMENTO_ID,
                          DETALLE_NOMBRE,
                          DETALLE_VALOR,
                          DETALLE_DESCRIPCION,
                          USR_CREACION,
                          FE_CREACION,
                          IP_CREACION,
                          REF_DETALLE_ELEMENTO_ID,
                          ESTADO
                        )
                        VALUES
                        (
                          LN_ID_DETALLE_ELEMENTO,
                          LC_GET_ELEMENTO_B_MIGRAR.ELEMENTO_B,
                          LC_GET_INFO_MIGRA_REFSUBRED.DETALLE_NOMBRE,
                          LN_ID_SUBRED,
                          LC_GET_INFO_MIGRA_REFSUBRED.DETALLE_DESCRIPCION,
                          LV_USRCREACION,
                          SYSDATE,
                          LV_IPCREACION,
                          LC_GET_INFO_MIGRA_REFSUBRED.REF_DETALLE_ELEMENTO_ID,
                          LC_GET_INFO_MIGRA_REFSUBRED.ESTADO
                        );
                      LN_ID_DET_ELEMENTO_NEXT := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;
                      INSERT
                      INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                        (
                          ID_DETALLE_ELEMENTO,
                          ELEMENTO_ID,
                          DETALLE_NOMBRE,
                          DETALLE_VALOR,
                          DETALLE_DESCRIPCION,
                          USR_CREACION,
                          FE_CREACION,
                          IP_CREACION,
                          REF_DETALLE_ELEMENTO_ID,
                          ESTADO
                        )
                        VALUES
                        (
                          LN_ID_DET_ELEMENTO_NEXT,
                          LC_GET_ELEMENTO_B_MIGRAR.ELEMENTO_B,
                          LC_GET_INFO_MIGRA_SCOPE.DETALLE_NOMBRE,
                          LV_SCOPE_B,
                          LC_GET_INFO_MIGRA_SCOPE.DETALLE_DESCRIPCION,
                          LV_USRCREACION,
                          SYSDATE,
                          LV_IPCREACION,
                          LN_ID_DETALLE_ELEMENTO,
                          LC_GET_INFO_MIGRA_SCOPE.ESTADO
                        );
                      FOR LC_GET_MIGRA_SUBRED_PRIMA_I IN C_GET_INFO_MIGRA_SUBRED_PRIMA(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_INFO_MIGRA_SCOPE.REF_DETALLE_ELEMENTO_ID) LOOP  
                          LN_ID_DET_ELEMENTO_NEXT := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;
                          INSERT
                          INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                            (
                              ID_DETALLE_ELEMENTO,
                              ELEMENTO_ID,
                              DETALLE_NOMBRE,
                              DETALLE_VALOR,
                              DETALLE_DESCRIPCION,
                              USR_CREACION,
                              FE_CREACION,
                              IP_CREACION,
                              REF_DETALLE_ELEMENTO_ID,
                              ESTADO
                            )
                            VALUES
                            (
                              LN_ID_DET_ELEMENTO_NEXT,
                              LC_GET_ELEMENTO_B_MIGRAR.ELEMENTO_B,
                              LC_GET_MIGRA_SUBRED_PRIMA_I.DETALLE_NOMBRE,
                              LC_GET_MIGRA_SUBRED_PRIMA_I.DETALLE_VALOR,
                              LC_GET_MIGRA_SUBRED_PRIMA_I.DETALLE_DESCRIPCION,
                              LV_USRCREACION,
                              SYSDATE,
                              LV_IPCREACION,
                              LN_ID_DETALLE_ELEMENTO,
                              LC_GET_MIGRA_SUBRED_PRIMA_I.ESTADO
                            );
                      END LOOP;
                      FOR LC_GET_MIGRA_TIPO_SCOPE_I IN C_GET_INFO_MIGRA_TIPO_SCOPE(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_INFO_MIGRA_SCOPE.REF_DETALLE_ELEMENTO_ID) LOOP
                          LN_ID_DET_ELEMENTO_NEXT := DB_INFRAESTRUCTURA.SEQ_INFO_DETALLE_ELEMENTO.NEXTVAL;
                          INSERT
                          INTO DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                            (
                              ID_DETALLE_ELEMENTO,
                              ELEMENTO_ID,
                              DETALLE_NOMBRE,
                              DETALLE_VALOR,
                              DETALLE_DESCRIPCION,
                              USR_CREACION,
                              FE_CREACION,
                              IP_CREACION,
                              REF_DETALLE_ELEMENTO_ID,
                              ESTADO
                            )
                            VALUES
                            (
                              LN_ID_DET_ELEMENTO_NEXT,
                              LC_GET_ELEMENTO_B_MIGRAR.ELEMENTO_B,
                              LC_GET_MIGRA_TIPO_SCOPE_I.DETALLE_NOMBRE,
                              LC_GET_MIGRA_TIPO_SCOPE_I.DETALLE_VALOR,
                              LC_GET_MIGRA_TIPO_SCOPE_I.DETALLE_DESCRIPCION,
                              LV_USRCREACION,
                              SYSDATE,
                              LV_IPCREACION,
                              LN_ID_DETALLE_ELEMENTO,
                              LC_GET_MIGRA_TIPO_SCOPE_I.ESTADO
                            );
                      END LOOP;  
                      FOR LC_GET_INFO_MIGRA_SUBRED_TAG IN C_GET_INFO_MIGRA_SUBRED_TAG
                      (
                        LC_GET_INFO_MIGRA_SUBRED.ID_SUBRED
                      )
                      LOOP
                        INSERT
                        INTO DB_INFRAESTRUCTURA.INFO_SUBRED_TAG
                          (
                            ID_SUBRED_TAG,
                            SUBRED_ID,
                            TAG_ID,
                            USR_CREACION,
                            FE_CREACION,
                            ESTADO
                          )
                          VALUES
                          (
                            DB_INFRAESTRUCTURA.SEQ_INFO_SUBRED_TAG.NEXTVAL,
                            LN_ID_SUBRED,
                            LC_GET_INFO_MIGRA_SUBRED_TAG.TAG_ID,
                            LV_USRCREACION,
                            SYSDATE,
                            LC_GET_INFO_MIGRA_SUBRED_TAG.ESTADO
                          );
                      END LOOP;
                      OPEN C_GET_ESTADO_ELEMENTO(LC_GET_ELEMENTO_B_MIGRAR.ELEMENTO_B);
                      FETCH C_GET_ESTADO_ELEMENTO INTO LC_GET_ESTADO_ELEMENTO;
                      CLOSE C_GET_ESTADO_ELEMENTO;
                      INSERT
                      INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO
                        (
                          ID_HISTORIAL,
                          ELEMENTO_ID,
                          ESTADO_ELEMENTO,
                          OBSERVACION,
                          USR_CREACION,
                          FE_CREACION,
                          IP_CREACION
                        )
                        VALUES
                        (
                          DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
                          LC_GET_ELEMENTO_B_MIGRAR.ELEMENTO_B,
                          LC_GET_ESTADO_ELEMENTO.ESTADO,
                          'Se ingreso el Scope: '
                          ||LV_SCOPE_B,
                          LV_USRCREACION,
                          SYSDATE,
                          LV_IPCREACION
                        );
                    EXCEPTION
                        WHEN OTHERS THEN
                            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_PROCESAR_SCOPES-INSERTS', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
                    END;
                END LOOP;
                OPEN C_VALIDA_ESTADO_SUBRED(LN_IDMIGRACIONCAB,LC_GET_INFO_MIGRA_SUBRED.ID_SUBRED);
                FETCH C_VALIDA_ESTADO_SUBRED INTO LN_VALIDA_SUBRED;
                CLOSE C_VALIDA_ESTADO_SUBRED;
                IF LN_VALIDA_SUBRED > 0 THEN
                    UPDATE DB_INFRAESTRUCTURA.INFO_SUBRED
                    SET ESTADO      = 'Migrado'
                    WHERE ID_SUBRED = LC_GET_INFO_MIGRA_SUBRED.ID_SUBRED;
                    UPDATE DB_INFRAESTRUCTURA.INFO_SUBRED_TAG
                    SET ESTADO            = 'Migrado'
                    WHERE SUBRED_ID       = LC_GET_INFO_MIGRA_SUBRED.ID_SUBRED;
                END IF;
                LN_COUNT_MIGRA_EXIST := LN_COUNT_MIGRA_EXIST + 1;        
            END LOOP;
          END LOOP;
          IF LN_COUNT_MIGRA_EXIST > 0 THEN
            UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
            SET VALOR   = LV_SCOPE_B
            WHERE VALOR = LV_SCOPE_A
            AND ESTADO  = LV_ESTADO_ACTIVO;
            P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOOK, 'Scope procesado correctamente');
            COMMIT;
          ELSE
            P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, 'Se presentó un error al actualizar el detalle de scopes: No se encontraron olt asociados con el elmento scope '||LV_SCOPE_A ||' en la info_detalle_elemento.');
            COMMIT;
          END IF;
        EXCEPTION
        WHEN LE_EXCEPTION_REG THEN
          LV_MENSAJEEX := SUBSTR('Se presentó un error al actualizar el detalle de scopes: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
          ROLLBACK;
          P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, LV_MENSAJEEX);
          COMMIT;
        WHEN OTHERS THEN
          LV_MENSAJEEX := SUBSTR('Se presentó un error al actualizar el detalle de scopes: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
          ROLLBACK;
          P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, LV_MENSAJEEX);
          COMMIT;
        END;
      END LOOP;
    END LOOP;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Proceso terminó de ejecutarse';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Ocurrió un error no controlado en la ejecución';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_PROCESAR_SCOPES', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
  END P_PROCESAR_SCOPES;
  PROCEDURE P_PROCESAR_ENLACES(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  AS
    CURSOR C_GETMIGRACIONDET (CN_IDMIGRACIONDET NUMBER)
    IS
      SELECT AD_DET.ELEMENTO_A,
        AD_DET.INTERFACE_ELEMENTO_A,
        AD_DET.ELEMENTO_B,
        AD_DET.INTERFACE_ELEMENTO_B,
        AD_DET.CLASE_TIPO_MEDIO,
        AD_DET.BUFFER,
        AD_DET.HILO
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET AD_DET
      WHERE AD_DET.ID_MIGRACION_DET = CN_IDMIGRACIONDET
      AND AD_DET.ESTADO             = 'Procesando';
    CURSOR C_GETINTERFACE (CV_NOMBREELEMENTO VARCHAR2, CV_NUMEROINTERFACE VARCHAR2)
    IS
      SELECT DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
      WHERE DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO                       = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO                     = CV_NOMBREELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO = CV_NUMEROINTERFACE
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO                              = 'Activo'
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO                   IN ('connected', 'not connect');
    CURSOR C_GETENLACE (CV_NOMBREELEMENTO VARCHAR2, CV_NUMEROINTERFACE VARCHAR2)
    IS
      SELECT DB_INFRAESTRUCTURA.INFO_ENLACE.ID_ENLACE,
        DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_INI_ID,
        DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_FIN_ID,
        DB_INFRAESTRUCTURA.INFO_ENLACE.BUFFER_HILO_ID
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_ENLACE
      WHERE DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO                       = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
      AND DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_INI_ID             = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO                     = CV_NOMBREELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO = CV_NUMEROINTERFACE
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO                    = 'connected'
      AND DB_INFRAESTRUCTURA.INFO_ENLACE.ESTADO                                = 'Activo';
    CURSOR C_GETENLACEFIN (CV_NOMBREELEMENTO VARCHAR2, CV_NUMEROINTERFACE VARCHAR2)
    IS
      SELECT DB_INFRAESTRUCTURA.INFO_ENLACE.ID_ENLACE,
        DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_INI_ID,
        DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_FIN_ID,
        DB_INFRAESTRUCTURA.INFO_ENLACE.BUFFER_HILO_ID
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_ENLACE
      WHERE DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO                       = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
      AND DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_FIN_ID             = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO                     = CV_NOMBREELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO = CV_NUMEROINTERFACE
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO                    = 'connected'
      AND DB_INFRAESTRUCTURA.INFO_ENLACE.ESTADO                                = 'Activo';
    CURSOR C_GETBUFFERHILO (CV_NOMBRECLASETIPOMEDIO VARCHAR2, CV_NUMEROBUFFER VARCHAR2, CV_COLORBUFFER VARCHAR2, CV_NUMEROHILO VARCHAR2, CV_COLORHILO VARCHAR2)
    IS
      SELECT DB_INFRAESTRUCTURA.INFO_BUFFER_HILO.ID_BUFFER_HILO
      FROM DB_INFRAESTRUCTURA.INFO_BUFFER_HILO,
        DB_INFRAESTRUCTURA.ADMI_BUFFER,
        DB_INFRAESTRUCTURA.ADMI_HILO,
        DB_INFRAESTRUCTURA.ADMI_CLASE_TIPO_MEDIO
      WHERE DB_INFRAESTRUCTURA.INFO_BUFFER_HILO.BUFFER_ID                  = DB_INFRAESTRUCTURA.ADMI_BUFFER.ID_BUFFER
      AND DB_INFRAESTRUCTURA.INFO_BUFFER_HILO.HILO_ID                      = DB_INFRAESTRUCTURA.ADMI_HILO.ID_HILO
      AND DB_INFRAESTRUCTURA.ADMI_HILO.CLASE_TIPO_MEDIO_ID                 = DB_INFRAESTRUCTURA.ADMI_CLASE_TIPO_MEDIO.ID_CLASE_TIPO_MEDIO
      AND DB_INFRAESTRUCTURA.ADMI_CLASE_TIPO_MEDIO.NOMBRE_CLASE_TIPO_MEDIO = CV_NOMBRECLASETIPOMEDIO
      AND DB_INFRAESTRUCTURA.ADMI_BUFFER.NUMERO_BUFFER                     = CV_NUMEROBUFFER
      AND DB_INFRAESTRUCTURA.ADMI_BUFFER.COLOR_BUFFER                      = CV_COLORBUFFER
      AND DB_INFRAESTRUCTURA.ADMI_HILO.NUMERO_HILO                         = CV_NUMEROHILO
      AND DB_INFRAESTRUCTURA.ADMI_HILO.COLOR_HILO                          = CV_COLORHILO
      AND DB_INFRAESTRUCTURA.INFO_BUFFER_HILO.EMPRESA_COD                  = '18';
    LV_ESTADOPROCESANDO VARCHAR2(30)                                      := 'Procesando';
    LV_ESTADOOK         VARCHAR2(30)                                      := 'Ok';
    LV_TIPOREGISTRO     VARCHAR2(30)                                      := 'ENLACE';
    LV_ESTADOERROR      VARCHAR2(30)                                      := 'Error';
    LV_ESTADONOTCONNECT VARCHAR2(30)                                      := 'not connect';
    LV_ESTADOCONNECTED  VARCHAR2(30)                                      := 'connected';
    LV_ESTADOACTIVO     VARCHAR2(30)                                      := 'Activo';
    LV_ESTADOMIGRADO    VARCHAR2(30)                                      := 'Migrado';
    LV_USRCREACION      VARCHAR2(100)                                     := 'migracion';
    LV_IPCREACION       VARCHAR2(20)                                      := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LN_IDMIGRACIONCAB   NUMBER;
    LB_EXISTIOERROR     BOOLEAN := FALSE;
    LV_STATUS           VARCHAR2(5);
    LV_MENSAJE          VARCHAR2(4000);
    LV_MENSAJEEX        VARCHAR2(4000);
    LN_IDELEMENTO       NUMBER                    := 0;
    LN_IDMIGRACIONDET   NUMBER                    := 0;
    LN_IDBUFFERHILO     NUMBER                    := 0;
    LN_IDENLACENUEVO    NUMBER                    := 0;
    LB_CREARENLACE      BOOLEAN                   := FALSE;
    LR_INFOMIGRACIONDET C_GETMIGRACIONDET%ROWTYPE := NULL;
    LR_INFOBUFFERHILO C_GETBUFFERHILO%ROWTYPE     := NULL;
    LR_INFOINFERFACEINI C_GETINTERFACE%ROWTYPE    := NULL;
    LR_INFOINFERFACEFIN C_GETINTERFACE%ROWTYPE    := NULL;
    LR_INFOENLACEINI C_GETENLACE%ROWTYPE          := NULL;
    LR_INFOENLACEFIN C_GETENLACEFIN%ROWTYPE       := NULL;
    LT_ARRAYSPLITBUFFER DB_INFRAESTRUCTURA.INKG_TYPES.LT_ARRAYOFVARCHAR;
    LT_ARRAYSPLITHILO DB_INFRAESTRUCTURA.INKG_TYPES.LT_ARRAYOFVARCHAR;
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LV_USRCREACIONMIGRACION VARCHAR2(100)                            := 'MIGRACION';
    LR_INFOMIGRAADDATA DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA%ROWTYPE := NULL;
  BEGIN
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONREQUEST;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    LN_IDMIGRACIONCAB := TRIM(APEX_JSON.GET_NUMBER(P_PATH => 'idMigracionCab'));
    FOR I IN 1 .. APEX_JSON.GET_COUNT ('hilosEnlaces')
    LOOP
      FOR J IN 1 .. APEX_JSON.GET_COUNT ('hilosEnlaces[%d].migracionDetItems', I)
      LOOP
        LN_IDMIGRACIONDET   := APEX_JSON.GET_NUMBER ('hilosEnlaces[%d].migracionDetItems[%d]', I, J);
        LR_INFOMIGRACIONDET := NULL;
        LR_INFOBUFFERHILO   := NULL;
        LR_INFOINFERFACEINI := NULL;
        LR_INFOINFERFACEFIN := NULL;
        LR_INFOENLACEINI    := NULL;
        LR_INFOENLACEFIN    := NULL;
        LB_CREARENLACE      := FALSE;
        BEGIN
          OPEN C_GETMIGRACIONDET (LN_IDMIGRACIONDET);
          FETCH C_GETMIGRACIONDET INTO LR_INFOMIGRACIONDET;
          CLOSE C_GETMIGRACIONDET;
          LT_ARRAYSPLITBUFFER := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LR_INFOMIGRACIONDET.BUFFER, ',');
          LT_ARRAYSPLITHILO   := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LR_INFOMIGRACIONDET.HILO, ',');
          OPEN C_GETBUFFERHILO (LR_INFOMIGRACIONDET.CLASE_TIPO_MEDIO, LT_ARRAYSPLITBUFFER(0), LT_ARRAYSPLITBUFFER(1), LT_ARRAYSPLITHILO(0), LT_ARRAYSPLITHILO(1));
          FETCH C_GETBUFFERHILO INTO LR_INFOBUFFERHILO;
          CLOSE C_GETBUFFERHILO;
          OPEN C_GETINTERFACE (LR_INFOMIGRACIONDET.ELEMENTO_A, LR_INFOMIGRACIONDET.INTERFACE_ELEMENTO_A);
          FETCH C_GETINTERFACE INTO LR_INFOINFERFACEINI;
          CLOSE C_GETINTERFACE;
          OPEN C_GETINTERFACE (LR_INFOMIGRACIONDET.ELEMENTO_B, LR_INFOMIGRACIONDET.INTERFACE_ELEMENTO_B);
          FETCH C_GETINTERFACE INTO LR_INFOINFERFACEFIN;
          CLOSE C_GETINTERFACE;
          OPEN C_GETENLACE (LR_INFOMIGRACIONDET.ELEMENTO_A, LR_INFOMIGRACIONDET.INTERFACE_ELEMENTO_A);
          FETCH C_GETENLACE INTO LR_INFOENLACEINI;
          IF C_GETENLACE%FOUND THEN
            IF LR_INFOBUFFERHILO.ID_BUFFER_HILO != LR_INFOENLACEINI.BUFFER_HILO_ID OR LR_INFOENLACEINI.INTERFACE_ELEMENTO_FIN_ID != LR_INFOINFERFACEFIN.ID_INTERFACE_ELEMENTO THEN
              IF LR_INFOINFERFACEFIN.ID_INTERFACE_ELEMENTO != LR_INFOENLACEINI.INTERFACE_ELEMENTO_FIN_ID THEN
                UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
                SET ESTADO                           = LV_ESTADONOTCONNECT
                WHERE ID_INTERFACE_ELEMENTO          = LR_INFOENLACEINI.INTERFACE_ELEMENTO_FIN_ID;
                LR_INFOMIGRAADDATA                  := NULL;
                LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
                LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
                LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'ENLACE_INTERFACE';
                LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_INFOENLACEINI.INTERFACE_ELEMENTO_FIN_ID;
                LR_INFOMIGRAADDATA.ESTADO           := LV_ESTADOCONNECTED;
                LR_INFOMIGRAADDATA.OBSERVACION      := 'Registro actualizado a not connect. Se utilizará en caso de reverso.';
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
              END IF;
              UPDATE DB_INFRAESTRUCTURA.INFO_ENLACE
              SET ESTADO                           = LV_ESTADOMIGRADO
              WHERE ID_ENLACE                      = LR_INFOENLACEINI.ID_ENLACE;
              LR_INFOMIGRAADDATA                  := NULL;
              LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
              LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
              LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'ENLACE_ENLACE';
              LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_INFOENLACEINI.ID_ENLACE;
              LR_INFOMIGRAADDATA.ESTADO           := LV_ESTADOACTIVO;
              LR_INFOMIGRAADDATA.OBSERVACION      := 'Registro actualizado a Migrado. Se utilizará en caso de reverso.';
              DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
              LB_CREARENLACE := TRUE;
            END IF;
          ELSE
            LB_CREARENLACE := TRUE;
          END IF;
          CLOSE C_GETENLACE;
          IF LR_INFOINFERFACEINI.ESTADO          = 'not connect' THEN
            LR_INFOMIGRAADDATA                  := NULL;
            LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
            LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
            LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'ENLACE_INTERFACE';
            LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_INFOINFERFACEINI.ID_INTERFACE_ELEMENTO;
            LR_INFOMIGRAADDATA.ESTADO           := LR_INFOINFERFACEINI.ESTADO;
            LR_INFOMIGRAADDATA.OBSERVACION      := 'Registro actualizado a connected. Se utilizará en caso de reverso.';
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
            UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
            SET ESTADO                  = LV_ESTADOCONNECTED
            WHERE ID_INTERFACE_ELEMENTO = LR_INFOINFERFACEINI.ID_INTERFACE_ELEMENTO;
          END IF;
          IF LR_INFOINFERFACEFIN.ESTADO          = 'not connect' THEN
            LR_INFOMIGRAADDATA                  := NULL;
            LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
            LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
            LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'ENLACE_INTERFACE';
            LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_INFOINFERFACEFIN.ID_INTERFACE_ELEMENTO;
            LR_INFOMIGRAADDATA.ESTADO           := LR_INFOINFERFACEFIN.ESTADO;
            LR_INFOMIGRAADDATA.OBSERVACION      := 'Registro actualizado a connected. Se utilizará en caso de reverso.';
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
            UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
            SET ESTADO                  = LV_ESTADOCONNECTED
            WHERE ID_INTERFACE_ELEMENTO = LR_INFOINFERFACEFIN.ID_INTERFACE_ELEMENTO;
          END IF;
          IF LB_CREARENLACE THEN
            OPEN C_GETENLACEFIN (LR_INFOMIGRACIONDET.ELEMENTO_B, LR_INFOMIGRACIONDET.INTERFACE_ELEMENTO_B);
            FETCH C_GETENLACEFIN INTO LR_INFOENLACEFIN;
            IF C_GETENLACEFIN%FOUND THEN
              UPDATE DB_INFRAESTRUCTURA.INFO_ENLACE
              SET ESTADO                           = LV_ESTADOMIGRADO
              WHERE ID_ENLACE                      = LR_INFOENLACEFIN.ID_ENLACE;
              LR_INFOMIGRAADDATA                  := NULL;
              LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
              LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
              LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'ENLACE_ENLACE';
              LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_INFOENLACEFIN.ID_ENLACE;
              LR_INFOMIGRAADDATA.ESTADO           := LV_ESTADOACTIVO;
              LR_INFOMIGRAADDATA.OBSERVACION      := 'Registro actualizado a Migrado. Se utilizará en caso de reverso.';
              DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
            END IF;
            CLOSE C_GETENLACEFIN;
            LN_IDENLACENUEVO := DB_INFRAESTRUCTURA.SEQ_INFO_ENLACE.NEXTVAL;
            INSERT
            INTO DB_INFRAESTRUCTURA.INFO_ENLACE
              (
                ID_ENLACE,
                INTERFACE_ELEMENTO_INI_ID,
                INTERFACE_ELEMENTO_FIN_ID,
                TIPO_MEDIO_ID,
                CAPACIDAD_INPUT,
                UNIDAD_MEDIDA_INPUT,
                CAPACIDAD_OUTPUT,
                UNIDAD_MEDIDA_OUTPUT,
                CAPACIDAD_INI_FIN,
                UNIDAD_MEDIDA_UP,
                CAPACIDAD_FIN_INI,
                UNIDAD_MEDIDA_DOWN,
                TIPO_ENLACE,
                ESTADO,
                USR_CREACION,
                FE_CREACION,
                IP_CREACION,
                BUFFER_HILO_ID
              )
              VALUES
              (
                LN_IDENLACENUEVO,
                LR_INFOINFERFACEINI.ID_INTERFACE_ELEMENTO,
                LR_INFOINFERFACEFIN.ID_INTERFACE_ELEMENTO,
                1,
                1,
                'BPS',
                1,
                'BPS',
                1,
                'BPS',
                1,
                'BPS',
                'PRINCIPAL',
                LV_ESTADOACTIVO,
                LV_USRCREACIONMIGRACION,
                SYSDATE,
                LV_IPCREACION,
                LR_INFOBUFFERHILO.ID_BUFFER_HILO
              );
            LR_INFOMIGRAADDATA                  := NULL;
            LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
            LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
            LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'ENLACE_ENLACE';
            LR_INFOMIGRAADDATA.IDENTIFICADOR    := LN_IDENLACENUEVO;
            LR_INFOMIGRAADDATA.ESTADO           := LV_ESTADOMIGRADO;
            LR_INFOMIGRAADDATA.OBSERVACION      := 'Registro creado en Activo. Se utilizará en caso de reverso.';
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
          END IF;
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE(LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOOK, 'Enlace procesado correctamente');
          COMMIT;
        EXCEPTION
        WHEN OTHERS THEN
          LV_MENSAJEEX := SUBSTR('Se presentó un error al actualizar el detalle de enlaces: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
          ROLLBACK;
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, LV_MENSAJEEX);
          COMMIT;
        END;
      END LOOP;
    END LOOP;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Proceso terminó de ejecutarse';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Ocurrió un error no controlado en la ejecución';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_PROCESAR_ENLACES', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
  END P_PROCESAR_ENLACES;
  PROCEDURE P_OBTENER_CARACT_MW
    (
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2,
      PCL_JSONRESPONSE OUT CLOB
    )
  AS
    LV_NOMBREPARAMETRO VARCHAR2
    (
      200
    )
                           := 'PARAMETROS_MIGRACION_ALTA_DENSIDAD';
    LV_DATOS    VARCHAR2(200) := 'DATOS_MW';
    LV_ESTADO   VARCHAR2(30)  := 'Activo';
    LV_VALORUNO VARCHAR2(200);
    LCL_HEADERS CLOB;
    LCL_JSONREQUEST CLOB;
    LN_CODEREQUEST               NUMBER;
    LV_APLICACION                VARCHAR2(50) := 'application/json';
    LV_CHARSET                   VARCHAR2(50) := 'UTF-8';
    LV_USUARIOCREACION           VARCHAR2(20) := 'Migracion';
    LV_IPCREACION                VARCHAR2(20) := '127.0.0.1';
    LV_ERROR                     VARCHAR2(4000);
    LV_ESTADOWS                  VARCHAR2(10);
    LE_ERROR                     EXCEPTION;
    LV_VALOREJECUTACOMANDO       VARCHAR2(10);
    LV_VALORCOMANDOCONFIGURACION VARCHAR2(10);
    LV_VALORTIMEOUT VARCHAR2(10);
    CURSOR C_OBTENERDATOS
    IS
      SELECT VALOR1,
        VALOR2,
        VALOR3,
        VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE ESTADO     = LV_ESTADO
      AND PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = LV_NOMBREPARAMETRO
        AND ESTADO             = LV_ESTADO
        AND ROWNUM             = 1
        )
    AND DESCRIPCION = LV_DATOS
    AND ROWNUM      = 1;
  BEGIN
    OPEN C_OBTENERDATOS;
    FETCH C_OBTENERDATOS
    INTO LV_VALORUNO,
      LV_VALORCOMANDOCONFIGURACION,
      LV_VALOREJECUTACOMANDO,
      LV_VALORTIMEOUT;
    CLOSE C_OBTENERDATOS;
    PV_STATUS       := 'ERROR';
    PV_MENSAJE      := 'Problemas al ejecutar el Ws de Middleware.';
    LCL_JSONREQUEST := '{                                              
"opcion": "MIGRACION_PLANES_ZTE",                                              
"ejecutaComando": "'||LV_VALOREJECUTACOMANDO||'",                                              
"usrCreacion": "'||LV_USUARIOCREACION||'",                                              
"ipCreacion": "'||LV_IPCREACION||'",                                              
"comandoConfiguracion": "'||LV_VALORCOMANDOCONFIGURACION||'",                                              
"empresa": "MD"                                              
}';
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_WEB_SERVICE_BR(
    PV_URL => LV_VALORUNO, 
    PCL_MENSAJE => LCL_JSONREQUEST, 
    PV_APPLICATION => LV_APLICACION, 
    PV_CHARSET => LV_CHARSET, 
    PV_URLFILEDIGITAL => NULL, 
    PV_PASSFILEDIGITAL => NULL, 
    Pn_TimeOut => TO_NUMBER(LV_VALORTIMEOUT, '9999'),
    PCL_RESPUESTA => PCL_JSONRESPONSE, 
    PV_ERROR => LV_ERROR);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
    'INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_CARACT_MW-INFO',
    SUBSTR(LV_VALORUNO||' - '||LV_VALORTIMEOUT||' - JSON REQUEST: '||dbms_lob.substr(LCL_JSONREQUEST,4000,1)||
    LV_ERROR ||' - JSON RESPONSE: '||dbms_lob.substr(PCL_JSONRESPONSE,4000,1),0,4000), 
    LV_USUARIOCREACION, SYSDATE, LV_IPCREACION);
    IF LV_ERROR   IS NOT NULL THEN
      LV_ESTADOWS := 'ERROR';
    ELSE
      LV_ESTADOWS := 'OK';
    END IF;
    IF LV_ESTADOWS = 'OK' AND INSTR(PCL_JSONRESPONSE, 'status') != 0 AND INSTR(PCL_JSONRESPONSE, 'datos') != 0 AND INSTR(PCL_JSONRESPONSE, 'opcion') != 0 THEN
      APEX_JSON.PARSE(PCL_JSONRESPONSE);
      PV_STATUS  := APEX_JSON.GET_VARCHAR2(P_PATH => 'status');
      PV_MENSAJE := APEX_JSON.GET_VARCHAR2(P_PATH => 'mensaje');
    END IF;
    IF PV_STATUS <> 'OK' THEN
      PV_MENSAJE := 'MENSAJE: '||PV_MENSAJE ||LV_ERROR;
      RAISE LE_ERROR;
    END IF;
  EXCEPTION
  WHEN LE_ERROR THEN
    PCL_JSONRESPONSE := '{}';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_CARACT_MW', SUBSTR(PV_MENSAJE || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USUARIOCREACION, SYSDATE, LV_IPCREACION);
  WHEN OTHERS THEN
    PCL_JSONRESPONSE := '{}';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_CARACT_MW', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USUARIOCREACION, SYSDATE, LV_IPCREACION);
  END P_OBTENER_CARACT_MW;
  PROCEDURE P_PROCESAR_CLIENTES(
      PCL_JSONREQUEST IN CLOB,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2 )
  AS
    CURSOR C_GETMIGRACIONDET ( CN_IDMIGRACIONDET NUMBER )
    IS
      SELECT AD_DET.ELEMENTO_A,
        AD_DET.INTERFACE_ELEMENTO_A,
        AD_DET.ELEMENTO_B,
        AD_DET.INTERFACE_ELEMENTO_B,
        AD_DET.CLASE_TIPO_MEDIO,
        AD_DET.BUFFER,
        AD_DET.HILO,
        AD_DET.OLT_VALOR_NUMERICO
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET AD_DET
      WHERE AD_DET.ID_MIGRACION_DET = CN_IDMIGRACIONDET
      AND AD_DET.ESTADO             = 'Procesando';
    CURSOR C_GETINTERFACE (CV_NOMBREELEMENTO VARCHAR2, CV_NUMEROINTERFACE VARCHAR2)
    IS
      SELECT DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID,
        DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO,
        DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO
      WHERE DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO                       = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.MODELO_ELEMENTO_ID                  = DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.ID_MODELO_ELEMENTO
      AND DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.MARCA_ELEMENTO_ID            = DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.ID_MARCA_ELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO                     = CV_NOMBREELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO = CV_NUMEROINTERFACE
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO                              = 'Activo'
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO                   IN ('connected', 'not connect', 'Migrado');
    LV_STATUS         VARCHAR2(5);
    LV_MENSAJE        VARCHAR2(4000);
    LV_MENSAJEEX      VARCHAR2(4000);
    LV_ESTADOOK       VARCHAR2(30) := 'Ok';
    LE_EXCEPTION      EXCEPTION;
    LE_EXCEPTIONPON   EXCEPTION;
    LN_IDELEMENTO     NUMBER        := 0;
    LV_IPCREACION     VARCHAR2(20)  := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LV_USRCREACION    VARCHAR2(100) := 'migracion';
    LV_ESTADOERROR    VARCHAR2(30)  := 'Error';
    LV_ESTADOACTIVO   VARCHAR2(30)  := 'Activo';
    LV_TIPOREGISTRO   VARCHAR2(30)  := 'OLT';
    LB_EXISTIOERROR   BOOLEAN       := FALSE;
    LV_ESTADOACTUAL   VARCHAR2(100) := '';
    LN_IDBUFFERHILO   NUMBER        := 0;
    LV_ESTADOMIGRADO  VARCHAR2(30)  := 'Migrado';
    LN_IDMIGRACIONCAB NUMBER;
    LN_IDMIGRACIONDET NUMBER                                         := 0;
    LR_INFOMIGRAADDATA DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA%ROWTYPE := NULL;
    LV_ESTADOCONNECTED  VARCHAR2(30)                                  := 'connected';
    LV_ESTADONOTCONNECT VARCHAR2(30)                                  := 'not connect';
    LV_ESTADOPROCESANDO VARCHAR2(30)                                  := 'Procesando';
    LV_MENSAJEMIGRACION VARCHAR2(4000);
    LR_INFOMIGRACIONDET C_GETMIGRACIONDET%ROWTYPE := NULL;
    LR_INFOINFERFACEINI C_GETINTERFACE%ROWTYPE    := NULL;
    LR_INFOINFERFACEFIN C_GETINTERFACE%ROWTYPE    := NULL;
    LN_CANTIDADCLIENTES     NUMBER                    := 0;
    LV_USRCREACIONMIGRACION VARCHAR2(100)             := 'MIGRACION';
    LV_ESPLAN               VARCHAR2(100)             := '';
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LCL_JSONZTE CLOB;
    LRF_REGISTROSSERVICIOS SYS_REFCURSOR;
    LR_REGINFOSERVICIOSMIGRA DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_INFOSERVICIOSMIGRACION;
    LT_TREGSINFOSERVICIOSMIGRA DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_INFOSERVICIOSMIGRACION;
    LN_INDXREGLISTADOSERVICIOS NUMBER := 0;
  BEGIN
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONREQUEST;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    LN_IDMIGRACIONCAB := TRIM(APEX_JSON.GET_NUMBER(P_PATH => 'idMigracionCab'));
    FOR I IN 1 .. APEX_JSON.GET_COUNT ('hilosClientes')
    LOOP
      FOR J IN 1 .. APEX_JSON.GET_COUNT ('hilosClientes[%d].migracionDetItems', I)
      LOOP
        LN_IDMIGRACIONDET   := APEX_JSON.GET_NUMBER ('hilosClientes[%d].migracionDetItems[%d]', I, J);
        LR_INFOMIGRACIONDET := NULL;
        LR_INFOINFERFACEINI := NULL;
        LR_INFOINFERFACEFIN := NULL;
        LB_EXISTIOERROR     := FALSE;
        BEGIN
          OPEN C_GETMIGRACIONDET (LN_IDMIGRACIONDET);
          FETCH C_GETMIGRACIONDET INTO LR_INFOMIGRACIONDET;
          CLOSE C_GETMIGRACIONDET;
          OPEN C_GETINTERFACE (LR_INFOMIGRACIONDET.ELEMENTO_A, LR_INFOMIGRACIONDET.INTERFACE_ELEMENTO_A);
          FETCH C_GETINTERFACE INTO LR_INFOINFERFACEINI;
          CLOSE C_GETINTERFACE;
          OPEN C_GETINTERFACE (LR_INFOMIGRACIONDET.ELEMENTO_B, LR_INFOMIGRACIONDET.INTERFACE_ELEMENTO_B);
          FETCH C_GETINTERFACE INTO LR_INFOINFERFACEFIN;
          CLOSE C_GETINTERFACE;
          IF LR_INFOINFERFACEFIN.NOMBRE_MARCA_ELEMENTO = 'ZTE' AND LCL_JSONZTE IS NULL OR LCL_JSONZTE = '{}' THEN
              DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_CARACT_MW ( LV_STATUS, LV_MENSAJE, LCL_JSONZTE);
              IF LCL_JSONZTE        IS NULL OR LCL_JSONZTE = '{}' THEN
                LV_MENSAJEMIGRACION := 'WS GDA no devolvió información. '||LV_MENSAJE;
                RAISE LE_EXCEPTIONPON;
              END IF;
              DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG('18',
                         '1',
                         'P_PROCESAR_CLIENTES',
                         'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD',
                         'P_PROCESAR_CLIENTES',
                         'Ejecutando procedure P_PROCESAR_CLIENTES',
                         'DataZte',
                         LCL_JSONZTE,
                         'Sin parámetros',
                         LV_USRCREACION
                        );  
          END IF;
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_OBTENER_SERVICIOS( LR_INFOINFERFACEINI.ELEMENTO_ID, LR_INFOINFERFACEINI.ID_INTERFACE_ELEMENTO, LN_CANTIDADCLIENTES, LV_MENSAJE, LRF_REGISTROSSERVICIOS);
          LOOP
            FETCH LRF_REGISTROSSERVICIOS BULK COLLECT
            INTO LT_TREGSINFOSERVICIOSMIGRA LIMIT 100;
            LN_INDXREGLISTADOSERVICIOS        := LT_TREGSINFOSERVICIOSMIGRA.FIRST;
            WHILE (LN_INDXREGLISTADOSERVICIOS IS NOT NULL)
            LOOP
              BEGIN
                LV_MENSAJEMIGRACION      := 'OK';
                LV_STATUS                := '';
                LV_MENSAJE               := '';
                LR_REGINFOSERVICIOSMIGRA := LT_TREGSINFOSERVICIOSMIGRA(LN_INDXREGLISTADOSERVICIOS);
                UPDATE DB_COMERCIAL.INFO_SERVICIO_TECNICO
                SET ELEMENTO_ID                                      = LR_INFOINFERFACEFIN.ELEMENTO_ID,
                  INTERFACE_ELEMENTO_ID                              = LR_INFOINFERFACEFIN.ID_INTERFACE_ELEMENTO
                WHERE DB_COMERCIAL.INFO_SERVICIO_TECNICO.SERVICIO_ID = LR_REGINFOSERVICIOSMIGRA.IDSERVICIO;
                IF LR_INFOINFERFACEFIN.NOMBRE_MARCA_ELEMENTO         = 'ZTE'
                AND LR_REGINFOSERVICIOSMIGRA.TIPOPRODUCTO = 'GPON'
                AND LR_REGINFOSERVICIOSMIGRA.ACTUALIZASPID = 'SI' 
                AND LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO IN ('EnPruebas','EnVerificacion','In-Corte','Activo') THEN
                  IF LR_REGINFOSERVICIOSMIGRA.LINEPROFILENAME IS NOT NULL THEN
                    IF LR_REGINFOSERVICIOSMIGRA.IDPLAN        IS NOT NULL THEN
                      LV_ESPLAN := 'SI';
                    ELSE
                      LV_ESPLAN := 'NO';
                    END IF;
                    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZA_CARACT_ZTE( LCL_JSONZTE, LR_REGINFOSERVICIOSMIGRA.IDSERVICIO, LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO, LR_REGINFOSERVICIOSMIGRA.LINEPROFILENAME, LV_ESPLAN, LV_STATUS, LV_MENSAJE);
                    IF LV_STATUS           = 'ERROR' THEN
                      LV_MENSAJEMIGRACION := LV_MENSAJE;
                      RAISE LE_EXCEPTION;
                    END IF;
                  ELSE
                    LV_MENSAJEMIGRACION := 'No existe caracteristica LINE-PROFILE-NAME en el servicio.';
                    RAISE LE_EXCEPTION;
                  END IF;
                END IF;
                IF LR_REGINFOSERVICIOSMIGRA.ACTUALIZASPID = 'SI' AND LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO IN ('EnPruebas','EnVerificacion','In-Corte','Activo') THEN
                  IF LR_REGINFOSERVICIOSMIGRA.SPID       IS NOT NULL THEN
                    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZA_SPID( LR_REGINFOSERVICIOSMIGRA.IDSERVICIO, LR_INFOINFERFACEFIN.NOMBRE_MARCA_ELEMENTO, LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO, LR_INFOMIGRACIONDET.OLT_VALOR_NUMERICO, LV_STATUS, LV_MENSAJE);
                    IF LV_STATUS           = 'ERROR' THEN
                      LV_MENSAJEMIGRACION := LV_MENSAJE;
                      RAISE LE_EXCEPTION;
                    END IF;
                  ELSE
                    LV_MENSAJEMIGRACION := 'No existe caracteristica SPID en el servicio.';
                    RAISE LE_EXCEPTION;
                  END IF;
                END IF;
                IF LR_REGINFOSERVICIOSMIGRA.TIPOPRODUCTO = 'GPON-MPLS' THEN
                  DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_MIGRACION_SERVICIOS_SAFECITY( LR_REGINFOSERVICIOSMIGRA.IDSERVICIO,
                                                                                                  LR_INFOINFERFACEINI.ELEMENTO_ID,
                                                                                                  LR_INFOINFERFACEFIN.ELEMENTO_ID,
                                                                                                  LR_INFOINFERFACEINI.NOMBRE_MARCA_ELEMENTO,
                                                                                                  LR_INFOINFERFACEFIN.NOMBRE_MARCA_ELEMENTO,
                                                                                                  LV_STATUS,
                                                                                                  LV_MENSAJE );
                  IF LV_STATUS           = 'ERROR' THEN
                    LV_MENSAJEMIGRACION := LV_MENSAJE;
                    RAISE LE_EXCEPTION;
                  END IF;
                END IF;
                INSERT
                INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL,
                    SERVICIO_ID,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    ESTADO,
                    OBSERVACION
                  )
                  VALUES
                  (
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    LR_REGINFOSERVICIOSMIGRA.IDSERVICIO,
                    LV_USRCREACION,
                    SYSDATE,
                    LV_IPCREACION,
                    LR_REGINFOSERVICIOSMIGRA.ESTADOSERVICIO,
                    'Migrado correctamente.'
                  );
                COMMIT;
              EXCEPTION
              WHEN LE_EXCEPTION THEN
                ROLLBACK;
                LB_EXISTIOERROR                     := TRUE;
                LR_INFOMIGRAADDATA                  := NULL;
                LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
                LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
                LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'CLIENTE';
                LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_REGINFOSERVICIOSMIGRA.IDSERVICIO;
                LR_INFOMIGRAADDATA.LOGIN            := NVL(LR_REGINFOSERVICIOSMIGRA.LOGIN,'') ||','||NVL(LR_REGINFOSERVICIOSMIGRA.LOGINAUX,'');
                LR_INFOMIGRAADDATA.ESTADO           := 'Error';
                LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJEMIGRACION,0,4000);
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
                COMMIT;
              WHEN OTHERS THEN
                LV_MENSAJEEX := SUBSTR('Se presentó un error al migrar cliente:  - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
                ROLLBACK;
                LB_EXISTIOERROR := TRUE;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_PROCESAR_CLIENTES', SUBSTR('Se presentó un error al migrar cliente:  IdServicio : '||LR_REGINFOSERVICIOSMIGRA.IDSERVICIO||' '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
                LV_MENSAJEMIGRACION                 := LV_MENSAJEEX;
                LR_INFOMIGRAADDATA                  := NULL;
                LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
                LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
                LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'CLIENTE';
                LR_INFOMIGRAADDATA.IDENTIFICADOR    := LR_REGINFOSERVICIOSMIGRA.IDSERVICIO;
                LR_INFOMIGRAADDATA.LOGIN            := NVL(LR_REGINFOSERVICIOSMIGRA.LOGIN,'') ||','||NVL(LR_REGINFOSERVICIOSMIGRA.LOGINAUX,'');
                LR_INFOMIGRAADDATA.ESTADO           := 'Error';
                LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJEMIGRACION,0,4000);
                DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
                COMMIT;
              END;
              LN_INDXREGLISTADOSERVICIOS := LT_TREGSINFOSERVICIOSMIGRA.NEXT(LN_INDXREGLISTADOSERVICIOS);
            END LOOP;
            EXIT
          WHEN LRF_REGISTROSSERVICIOS%NOTFOUND;
          END LOOP;
          CLOSE LRF_REGISTROSSERVICIOS;
          IF LB_EXISTIOERROR THEN
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE(LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, 'Existieron errores en ciertos servicios en el puerto pon.');
          ELSE
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE(LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOOK, 'Clientes procesados correctamente en el puerto pon');
          END IF;
          COMMIT;
        EXCEPTION
        WHEN LE_EXCEPTIONPON THEN
            ROLLBACK;
            LB_EXISTIOERROR                     := TRUE;
            LR_INFOMIGRAADDATA                  := NULL;
            LR_INFOMIGRAADDATA.MIGRACION_CAB_ID := LN_IDMIGRACIONCAB;
            LR_INFOMIGRAADDATA.MIGRACION_DET_ID := LN_IDMIGRACIONDET;
            LR_INFOMIGRAADDATA.TIPO_PROCESO     := 'CLIENTE-PON';
            LR_INFOMIGRAADDATA.ESTADO           := 'Error';
            LR_INFOMIGRAADDATA.OBSERVACION      := SUBSTR(LV_MENSAJEMIGRACION,0,4000);
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA( LR_INFOMIGRAADDATA, LV_STATUS, LV_MENSAJE);
            DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE(LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, LV_MENSAJEMIGRACION);
            COMMIT;
        WHEN OTHERS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_PROCESAR_CLIENTES', SUBSTR('Se presentó un error al migrar cliente. - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
          LV_MENSAJEEX := SUBSTR('Se presentó un error al actualizar el detalle de clientes: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000);
          ROLLBACK;
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOPROCESANDO, LV_ESTADOERROR, LV_MENSAJEEX);
          COMMIT;
        END;
      END LOOP;
    END LOOP;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Proceso terminó de ejecutarse';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Ocurrió un error no controlado en la ejecución';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_PROCESAR_CLIENTES', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), LV_USRCREACION, SYSDATE, LV_IPCREACION);
  END P_PROCESAR_CLIENTES;
  PROCEDURE P_ACTUALIZA_SPID
    (
      PN_IDSERVICIO          IN NUMBER,
      PV_NOMBREMARCAELEMENTO IN VARCHAR2,
      PV_ESTADOSERVICIO      IN VARCHAR2,
      PN_VALORNUMERICO       IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LV_MENSAJE VARCHAR2
    (
      4000
    )
                                       := 'Error al actualizar detalles';
    LV_MENSAJEHISTORIAL VARCHAR2(4000) := '';
    LV_MENSAJEEX VARCHAR2(4000) := '';
    LV_USRCREACION      VARCHAR2(100)  := 'migracion';
    LR_SERVICIOPRODCARACT DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    LR_SERVICIOPRODCARACTONT DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    LE_EXCEPTION_REG EXCEPTION;
    LV_VALOR VARCHAR2(25) := '';
    LV_VALOR_DOS VARCHAR2(25) := '';
    LV_VALOR_SPID2 VARCHAR2(25) := '';
    LV_VALOR_SPID3 VARCHAR2(25) := '';
    LV_VALOR_SPID4 VARCHAR2(25) := '';
    LV_VALOR_TCONT VARCHAR2(25) := '';
    LV_VALORONT VARCHAR2(25) := '';
    LN_ID_SPID_ADMIN NUMBER;
    LN_ID_PRO_CAR_SPID_ADMIN NUMBER;
    LV_VALOR_SPID_ADMIN_ANT VARCHAR2(25) := '';
    LV_CARACT_TIPO_RED VARCHAR2(25) := 'TIPO_RED';
    LV_CARACT_SPID_ADMIN VARCHAR2(25) := 'SPID ADMIN';
    LV_CARACT_TCONT VARCHAR2(25) := 'T-CONT';
    LV_CARACT_TCONT_ADMIN VARCHAR2(25) := 'T-CONT-ADMIN';
    LV_VALOR_CARACT VARCHAR2(25);
    CURSOR C_GETSPIDNUEVO (CV_SPIDACTUAL VARCHAR2)
    IS
      SELECT VALOR2, VALOR3, VALOR4, VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
        AND ESTADO            ='Activo'
        )
    AND DESCRIPCION = 'SPID-ZTE'
    AND VALOR1      =CV_SPIDACTUAL;
    --
    CURSOR C_GETCARACTSERV (CN_IDSERVICIO NUMBER, CV_CARACT VARCHAR2)
    IS
      SELECT ISPC.VALOR
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = CN_IDSERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND AC.DESCRIPCION_CARACTERISTICA    = CV_CARACT;
    --
    CURSOR C_GETIDSPIDADMIN (CN_IDSERVICIO NUMBER)
    IS
      SELECT ISPC.ID_SERVICIO_PROD_CARACT, ISPC.PRODUCTO_CARACTERISITICA_ID, ISPC.VALOR
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = CN_IDSERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND AC.DESCRIPCION_CARACTERISTICA    = LV_CARACT_SPID_ADMIN;
  BEGIN
    BEGIN
      SELECT ISPC.*
      INTO LR_SERVICIOPRODCARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'SPID';
    EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJEEX := 'Existieron problemas con la característica SPID Activa en el cliente, favor regularizar. ';
      RAISE LE_EXCEPTION_REG;
    END;
    BEGIN
      SELECT ISPC.*
      INTO LR_SERVICIOPRODCARACTONT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'INDICE CLIENTE';
    EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJEEX := 'Existieron problemas con la característica ONT ID Activa en el cliente, favor regularizar. ';
      RAISE LE_EXCEPTION_REG;
    END;
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
    SET ISPC.ESTADO                    = 'Migrado'
    WHERE ISPC.ID_SERVICIO_PROD_CARACT = LR_SERVICIOPRODCARACT.ID_SERVICIO_PROD_CARACT;
    --
    IF C_GETIDSPIDADMIN%ISOPEN THEN
    CLOSE C_GETIDSPIDADMIN;
    END IF;
    OPEN C_GETIDSPIDADMIN (LR_SERVICIOPRODCARACT.SERVICIO_ID);
    FETCH C_GETIDSPIDADMIN INTO LN_ID_SPID_ADMIN, LN_ID_PRO_CAR_SPID_ADMIN, LV_VALOR_SPID_ADMIN_ANT;
    CLOSE C_GETIDSPIDADMIN;
    IF LN_ID_SPID_ADMIN IS NOT NULL THEN
      UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
      SET ISPC.ESTADO                    = 'Migrado'
      WHERE ISPC.ID_SERVICIO_PROD_CARACT = LN_ID_SPID_ADMIN;
    END IF;
    --
    IF PV_NOMBREMARCAELEMENTO          = 'HUAWEI' THEN
      LV_VALOR                        := TO_CHAR(TO_NUMBER(LR_SERVICIOPRODCARACT.VALOR) + PN_VALORNUMERICO);
      IF LN_ID_SPID_ADMIN IS NOT NULL THEN
        LV_VALOR_DOS                  := TO_CHAR(TO_NUMBER(LV_VALOR_SPID_ADMIN_ANT) + PN_VALORNUMERICO);
      END IF;
    ELSE
      LV_VALORONT := LR_SERVICIOPRODCARACTONT.VALOR;
      IF LR_SERVICIOPRODCARACTONT.VALOR = '0' THEN
        LV_VALORONT := '100';
        UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
        SET ISPC.VALOR                    = LV_VALORONT
        WHERE ISPC.ID_SERVICIO_PROD_CARACT = LR_SERVICIOPRODCARACTONT.ID_SERVICIO_PROD_CARACT;
      END IF;
      OPEN C_GETSPIDNUEVO (LV_VALORONT);
      FETCH C_GETSPIDNUEVO INTO LV_VALOR, LV_VALOR_SPID2, LV_VALOR_SPID3, LV_VALOR_SPID4;
      CLOSE C_GETSPIDNUEVO;
      IF LN_ID_SPID_ADMIN IS NOT NULL THEN
        LV_VALOR_DOS := LV_VALOR;
      END IF;
      --
      LV_VALOR_CARACT := NULL;
      IF C_GETCARACTSERV%ISOPEN THEN
      CLOSE C_GETCARACTSERV;
      END IF;
      OPEN C_GETCARACTSERV(LR_SERVICIOPRODCARACT.SERVICIO_ID,LV_CARACT_TIPO_RED);
      FETCH C_GETCARACTSERV INTO LV_VALOR_CARACT;
      CLOSE C_GETCARACTSERV;
      IF LV_VALOR_CARACT IS NOT NULL AND REPLACE(LV_VALOR_CARACT, '_', '-') = 'GPON-MPLS' THEN
        --
        LV_VALOR_CARACT := NULL;
        IF C_GETCARACTSERV%ISOPEN THEN
        CLOSE C_GETCARACTSERV;
        END IF;
        OPEN C_GETCARACTSERV(LR_SERVICIOPRODCARACT.SERVICIO_ID,LV_CARACT_TCONT);
        FETCH C_GETCARACTSERV INTO LV_VALOR_CARACT;
        CLOSE C_GETCARACTSERV;
        IF LV_VALOR_CARACT IS NOT NULL AND LV_VALOR_CARACT = '2' THEN
          LV_VALOR := LV_VALOR_SPID2;
        ELSIF LV_VALOR_CARACT IS NOT NULL AND LV_VALOR_CARACT = '3' THEN
          LV_VALOR := LV_VALOR_SPID3;
        ELSIF LV_VALOR_CARACT IS NOT NULL AND LV_VALOR_CARACT = '4' THEN
          LV_VALOR := LV_VALOR_SPID4;
        END IF;
        --
        IF LN_ID_SPID_ADMIN IS NOT NULL THEN
          LV_VALOR_CARACT := NULL;
          IF C_GETCARACTSERV%ISOPEN THEN
          CLOSE C_GETCARACTSERV;
          END IF;
          OPEN C_GETCARACTSERV(LR_SERVICIOPRODCARACT.SERVICIO_ID,LV_CARACT_TCONT_ADMIN);
          FETCH C_GETCARACTSERV INTO LV_VALOR_CARACT;
          CLOSE C_GETCARACTSERV;
          IF LV_VALOR_CARACT IS NOT NULL AND LV_VALOR_CARACT = '2' THEN
            LV_VALOR_DOS := LV_VALOR_SPID2;
          ELSIF LV_VALOR_CARACT IS NOT NULL AND LV_VALOR_CARACT = '3' THEN
            LV_VALOR_DOS := LV_VALOR_SPID3;
          ELSIF LV_VALOR_CARACT IS NOT NULL AND LV_VALOR_CARACT = '4' THEN
            LV_VALOR_DOS := LV_VALOR_SPID4;
          END IF;
        END IF;
      END IF;
      --
    END IF;
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
      (
        ID_SERVICIO_PROD_CARACT,
        SERVICIO_ID,
        PRODUCTO_CARACTERISITICA_ID,
        VALOR,
        FE_CREACION,
        FE_ULT_MOD,
        USR_CREACION,
        USR_ULT_MOD,
        ESTADO,
        REF_SERVICIO_PROD_CARACT_ID
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
        LR_SERVICIOPRODCARACT.SERVICIO_ID,
        LR_SERVICIOPRODCARACT.PRODUCTO_CARACTERISITICA_ID,
        LV_VALOR,
        SYSDATE,
        NULL,
        LV_USRCREACION,
        NULL,
        'Activo',
        NULL
      );
    --
    IF LN_ID_SPID_ADMIN IS NOT NULL THEN
      INSERT
      INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
        (
          ID_SERVICIO_PROD_CARACT,
          SERVICIO_ID,
          PRODUCTO_CARACTERISITICA_ID,
          VALOR,
          FE_CREACION,
          FE_ULT_MOD,
          USR_CREACION,
          USR_ULT_MOD,
          ESTADO,
          REF_SERVICIO_PROD_CARACT_ID
        )
        VALUES
        (
          DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
          LR_SERVICIOPRODCARACT.SERVICIO_ID,
          LN_ID_PRO_CAR_SPID_ADMIN,
          LV_VALOR_DOS,
          SYSDATE,
          NULL,
          LV_USRCREACION,
          NULL,
          'Activo',
          NULL
        );
    END IF;
    --
    LV_MENSAJEHISTORIAL := 'Migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>SPID Anterior</b>: ';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || LR_SERVICIOPRODCARACT.VALOR || '<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>SPID Nuevo</b>: ';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || LV_VALOR || '<br>';
    IF LN_ID_SPID_ADMIN IS NOT NULL THEN
      LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>SPID ADMIN Anterior</b>: ';
      LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || LV_VALOR_SPID_ADMIN_ANT || '<br>';
      LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>SPID ADMIN Nuevo</b>: ';
      LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || LV_VALOR_DOS || '<br>';
    END IF;
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        LR_SERVICIOPRODCARACT.SERVICIO_ID,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Spid migrado correctamente.';
  EXCEPTION
  WHEN LE_EXCEPTION_REG THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := LV_MENSAJEEX;
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := 'No se han podido actualizar el spid correctamente.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZA_SPID', LV_MENSAJE, LV_USRCREACION, SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZA_SPID;
  PROCEDURE P_REVERSA_SPID
    (
      PN_IDSERVICIO     IN NUMBER,
      PV_ESTADOSERVICIO IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LV_MENSAJE VARCHAR2
    (
      4000
    )
                                       := 'Error al reversar detalles';
    LV_MENSAJEHISTORIAL VARCHAR2(4000) := '';
    LV_USRCREACION      VARCHAR2(100)  := 'migracion';
    LR_SERVICIOPRODCARACT DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    LR_SERVICIOPRODCARACTONT DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    LV_MENSAJEEX           VARCHAR2(4000);
    LE_EXCEPTION_REG EXCEPTION;
    LV_VALOR VARCHAR2(25) := '';
  BEGIN
    BEGIN
      SELECT ISPC.*
      INTO LR_SERVICIOPRODCARACTONT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'INDICE CLIENTE';
    EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJEEX := 'Existieron problemas con la característica ONT ID Activa en el cliente, favor regularizar. ';
      RAISE LE_EXCEPTION_REG;
    END;
    IF LR_SERVICIOPRODCARACTONT.VALOR = '100' THEN
        UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
        SET ISPC.VALOR                    = '0'
        WHERE ISPC.ID_SERVICIO_PROD_CARACT = LR_SERVICIOPRODCARACTONT.ID_SERVICIO_PROD_CARACT;
      END IF;
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO                    = 'Reversado'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT IN
      (SELECT ISPC.ID_SERVICIO_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    IN ('SPID','SPID ADMIN')
      AND ROWNUM                          <=2
      );
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO                    = 'Activo'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT IN
      (SELECT ISPC.ID_SERVICIO_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Migrado'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    IN ('SPID','SPID ADMIN')
      AND ROWNUM                          <=2
      );
    LV_MENSAJEHISTORIAL := 'Reverso de migración de Data SPID';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Spid reversado correctamente.';
  EXCEPTION
  WHEN LE_EXCEPTION_REG THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := LV_MENSAJEEX ||' Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := 'No se han podido reversar el spid correctamente.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSA_SPID', LV_MENSAJE, LV_USRCREACION, SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := 'No se han podido reversar el spid correctamente.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSA_SPID', LV_MENSAJE, LV_USRCREACION, SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_REVERSA_SPID;
  PROCEDURE P_REVERSA_CARACT_ZTE
    (
      PN_IDSERVICIO     IN NUMBER,
      PV_ESTADOSERVICIO IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LV_MENSAJE VARCHAR2
    (
      4000
    )
                                       := 'Error al reversar detalles';
    LV_MENSAJEHISTORIAL VARCHAR2(4000) := '';
    LV_USRCREACION      VARCHAR2(100)  := 'migracion';
    LR_SERVICIOPRODCARACT DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    LV_VALOR VARCHAR2(25) := '';
  BEGIN
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO                    = 'Reversado'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT =
      (SELECT ISPC.ID_SERVICIO_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.USR_CREACION                = LV_USRCREACION
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'PACKAGE ID'
      AND ROWNUM                          <=1
      );
    LV_MENSAJEHISTORIAL := 'Reverso de migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>PACKAGE ID Reversado</b>. ';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO                    = 'Reversado'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT =
      (SELECT ISPC.ID_SERVICIO_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.USR_CREACION                = LV_USRCREACION
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'CLIENT CLASS'
      AND ROWNUM                          <=1
      );
    LV_MENSAJEHISTORIAL := 'Reverso de migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>CLIENT CLASS Reversado</b>. ';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO                    = 'Reversado'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT =
      (SELECT ISPC.ID_SERVICIO_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.USR_CREACION                = LV_USRCREACION
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'CAPACIDAD1'
      AND ROWNUM                          <=1
      );
    LV_MENSAJEHISTORIAL := 'Reverso de migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>CAPACIDAD1 Reversada</b>. ';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO                    = 'Reversado'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT =
      (SELECT ISPC.ID_SERVICIO_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Activo'
      AND ISPC.USR_CREACION                = LV_USRCREACION
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'CAPACIDAD2'
      AND ROWNUM                          <=1
      );
    LV_MENSAJEHISTORIAL := 'Reverso de migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>CAPACIDAD2 Reversada</b>. ';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET ESTADO = 'Activo'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT in
      (SELECT ISPC.ID_SERVICIO_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Migrado'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'CAPACIDAD1'
      );

    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET ESTADO = 'Activo'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT in
      (SELECT ISPC.ID_SERVICIO_PROD_CARACT
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
      AND ISPC.ESTADO                      = 'Migrado'
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
      AND AC.ESTADO                        = 'Activo'
      AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
      AND AC.DESCRIPCION_CARACTERISTICA    = 'CAPACIDAD2'
      );
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Caracteristicas ZTE reversadas correctamente.';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := 'No se han podido reversar caracteristicas ZTE correctamente.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_REVERSA_CARACT_ZTE', LV_MENSAJE, LV_USRCREACION, SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_REVERSA_CARACT_ZTE;
  PROCEDURE P_ACTUALIZA_CARACT_ZTE
    (
      PCL_JSONCARACT    IN CLOB,
      PN_IDSERVICIO     IN NUMBER,
      PV_ESTADOSERVICIO IN VARCHAR2,
      PV_LINEPROFILE    IN VARCHAR2,
      PV_ESPLAN         IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LV_MENSAJE VARCHAR2
    (
      4000
    )
                                                                   := '';
    LV_MENSAJEHISTORIAL VARCHAR2(4000)                             := '';
    LV_MENSAJEEX        VARCHAR2(4000)                             := '';
    LV_USRCREACION      VARCHAR2(100)                              := 'migracion';
    LR_PCPCK DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA%ROWTYPE     := NULL;
    LR_PCCLIENTE DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA%ROWTYPE := NULL;
    LR_PCCAPA1 DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA%ROWTYPE := NULL;
    LR_PCCAPA2 DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA%ROWTYPE := NULL;
    LV_LINEPROFILEWS VARCHAR2(25)                                  := '';
    LV_PACKDID       VARCHAR2(25)                                  := NULL;
    LV_CLIENTECLASS  VARCHAR2(25)                                  := NULL;
    LV_CAPACIDAD1    VARCHAR2(25)                                  := NULL;
    LV_CAPACIDAD2    VARCHAR2(25)                                  := NULL;
    LN_ID_PRODUCTO   NUMBER                                        := NULL;
    LCL_JSONFILTROSBUSQUEDA CLOB;
    LE_EXCEPTION_REG EXCEPTION;
    CURSOR C_GETSPIDNUEVO (CV_SPIDACTUAL VARCHAR2)
    IS
      SELECT VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
        AND ESTADO            ='Activo'
        )
    AND DESCRIPCION = 'SPID-ZTE'
    AND VALOR1      =CV_SPIDACTUAL;
  BEGIN
    LCL_JSONFILTROSBUSQUEDA := PCL_JSONCARACT;
    APEX_JSON.PARSE(LCL_JSONFILTROSBUSQUEDA);
    FOR I IN 1 .. APEX_JSON.GET_COUNT ('datos')
    LOOP
      LV_LINEPROFILEWS   := APEX_JSON.GET_VARCHAR2 ('datos[%d].line_profile', I);
      IF LV_LINEPROFILEWS = PV_LINEPROFILE THEN
        LV_PACKDID       := APEX_JSON.GET_VARCHAR2 ('datos[%d].pckid', I);
        LV_CLIENTECLASS  := APEX_JSON.GET_VARCHAR2 ('datos[%d].client_class', I);
        EXIT;
      END IF;
    END LOOP;
    IF LV_PACKDID IS NULL OR LV_CLIENTECLASS IS NULL THEN
      LV_MENSAJEEX := 'No se encontró información de line_profile del cliente en información devuelta por WS.';
      RAISE LE_EXCEPTION_REG;
    END IF;
    IF PV_ESPLAN      = 'SI' THEN
      LN_ID_PRODUCTO := 63;
    ELSE
      SELECT DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID
      INTO LN_ID_PRODUCTO
      FROM DB_COMERCIAL.INFO_SERVICIO
      WHERE DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO = PN_IDSERVICIO;
    END IF;
    BEGIN
      SELECT APC.*
      INTO LR_PCPCK
      FROM ADMI_PRODUCTO_CARACTERISTICA APC,
        ADMI_PRODUCTO AP,
        ADMI_CARACTERISTICA AC
      WHERE APC.PRODUCTO_ID             = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID         = AC.ID_CARACTERISTICA
      AND AC.ESTADO                     = 'Activo'
      AND AC.DESCRIPCION_CARACTERISTICA = 'PACKAGE ID'
      AND AP.ID_PRODUCTO                = LN_ID_PRODUCTO;
    EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJEEX := 'Existieron problemas al recuperar característica PACKAGE ID.';
      RAISE LE_EXCEPTION_REG;
    END;
    BEGIN
      SELECT APC.*
      INTO LR_PCCLIENTE
      FROM ADMI_PRODUCTO_CARACTERISTICA APC,
        ADMI_PRODUCTO AP,
        ADMI_CARACTERISTICA AC
      WHERE APC.PRODUCTO_ID                    = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID                = AC.ID_CARACTERISTICA
      AND AC.ESTADO                            = 'Activo'
      AND AC.DESCRIPCION_CARACTERISTICA        = 'CLIENT CLASS'
      AND AP.ID_PRODUCTO                       = LN_ID_PRODUCTO;
    EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJEEX := 'Existieron problemas al recuperar característica CLIENT CLASS.';
      RAISE LE_EXCEPTION_REG;
    END;
    BEGIN
      SELECT APC.*
      INTO LR_PCCAPA1
      FROM ADMI_PRODUCTO_CARACTERISTICA APC,
        ADMI_PRODUCTO AP,
        ADMI_CARACTERISTICA AC
      WHERE APC.PRODUCTO_ID                    = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID                = AC.ID_CARACTERISTICA
      AND AC.ESTADO                            = 'Activo'
      AND AC.DESCRIPCION_CARACTERISTICA        = 'CAPACIDAD1'
      AND AP.ID_PRODUCTO                       = LN_ID_PRODUCTO;
    EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJEEX := 'Existieron problemas al recuperar característica CAPACIDAD1.';
      RAISE LE_EXCEPTION_REG;
    END;
    BEGIN
      SELECT APC.*
      INTO LR_PCCAPA2
      FROM ADMI_PRODUCTO_CARACTERISTICA APC,
        ADMI_PRODUCTO AP,
        ADMI_CARACTERISTICA AC
      WHERE APC.PRODUCTO_ID                    = AP.ID_PRODUCTO
      AND APC.CARACTERISTICA_ID                = AC.ID_CARACTERISTICA
      AND AC.ESTADO                            = 'Activo'
      AND AC.DESCRIPCION_CARACTERISTICA        = 'CAPACIDAD2'
      AND AP.ID_PRODUCTO                       = LN_ID_PRODUCTO;
    EXCEPTION
    WHEN OTHERS THEN
      LV_MENSAJEEX := 'Existieron problemas al recuperar característica CAPACIDAD2.';
      RAISE LE_EXCEPTION_REG;
    END;
    IF LR_PCPCK.ID_PRODUCTO_CARACTERISITICA IS NULL OR LR_PCCLIENTE.ID_PRODUCTO_CARACTERISITICA IS NULL OR
    LR_PCCAPA1.ID_PRODUCTO_CARACTERISITICA IS NULL OR LR_PCCAPA2.ID_PRODUCTO_CARACTERISITICA IS NULL THEN
      LV_MENSAJEEX := 'No se han podido actualizar las caracteristicas correctamente. '||
                      'No tiene PACKAGE ID ó CLIENT CLASS ó CAPACIDAD1 ó CAPACIDAD2.';
      RAISE LE_EXCEPTION_REG;
    END IF;

    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET ESTADO = 'Migrado'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.SERVICIO_ID = PN_IDSERVICIO AND
    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.PRODUCTO_CARACTERISITICA_ID = LR_PCCAPA1.ID_PRODUCTO_CARACTERISITICA AND
    ESTADO = 'Activo';

    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET ESTADO = 'Migrado'
    WHERE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.SERVICIO_ID = PN_IDSERVICIO AND
    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.PRODUCTO_CARACTERISITICA_ID = LR_PCCAPA2.ID_PRODUCTO_CARACTERISITICA AND
    ESTADO = 'Activo';

    IF PV_ESPLAN      = 'SI' THEN
      BEGIN
        SELECT DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT.VALOR
        INTO LV_CAPACIDAD1
      FROM DB_COMERCIAL.INFO_SERVICIO ,
        DB_COMERCIAL.INFO_PLAN_DET,
        DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT
      WHERE DB_COMERCIAL.INFO_PLAN_DET.PLAN_ID                               = DB_COMERCIAL.INFO_SERVICIO.PLAN_ID
      AND DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT.PLAN_DET_ID                 = DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM
      AND DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT.PRODUCTO_CARACTERISITICA_ID = LR_PCCAPA1.ID_PRODUCTO_CARACTERISITICA
      AND DB_COMERCIAL.INFO_PLAN_DET.PRODUCTO_ID                             = LN_ID_PRODUCTO
      AND DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO                             = PN_IDSERVICIO;
      EXCEPTION
      WHEN OTHERS THEN
        LV_MENSAJEEX := 'Existieron problemas al recuperar el valor de característica CAPACIDAD1.';
        RAISE LE_EXCEPTION_REG;
      END;
      BEGIN
        SELECT DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT.VALOR
        INTO LV_CAPACIDAD2
      FROM DB_COMERCIAL.INFO_SERVICIO ,
        DB_COMERCIAL.INFO_PLAN_DET,
        DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT
      WHERE DB_COMERCIAL.INFO_PLAN_DET.PLAN_ID                               = DB_COMERCIAL.INFO_SERVICIO.PLAN_ID
      AND DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT.PLAN_DET_ID                 = DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM
      AND DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT.PRODUCTO_CARACTERISITICA_ID = LR_PCCAPA2.ID_PRODUCTO_CARACTERISITICA
      AND DB_COMERCIAL.INFO_PLAN_DET.PRODUCTO_ID                             = LN_ID_PRODUCTO
      AND DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO                             = PN_IDSERVICIO;
      EXCEPTION
      WHEN OTHERS THEN
        LV_MENSAJEEX := 'Existieron problemas al recuperar el valor de característica CAPACIDAD2.';
        RAISE LE_EXCEPTION_REG;
      END;
      IF LV_CAPACIDAD1 IS NULL OR LV_CAPACIDAD2 IS NULL THEN
        LV_MENSAJEEX := 'No se encontró información de CAPACIDAD1 ó CAPACIDAD2 del plan del cliente en información de Telcos.';
        RAISE LE_EXCEPTION_REG;
      END IF;
    ELSE
      BEGIN
        SELECT DET_VELOCIDAD_PERFIL.VALOR4 AS CAPACIDAD
        INTO LV_CAPACIDAD1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB_VELOCIDAD_PERFIL
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET_VELOCIDAD_PERFIL
        ON DET_VELOCIDAD_PERFIL.PARAMETRO_ID = CAB_VELOCIDAD_PERFIL.ID_PARAMETRO
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET_PLANES_TN_EQUIV_PERFIL
        ON DET_PLANES_TN_EQUIV_PERFIL.VALOR1 = DET_VELOCIDAD_PERFIL.VALOR2
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB_PLANES_TN_EQUIV_PERFIL
        ON CAB_PLANES_TN_EQUIV_PERFIL.ID_PARAMETRO = DET_PLANES_TN_EQUIV_PERFIL.PARAMETRO_ID
        where CAB_VELOCIDAD_PERFIL.NOMBRE_PARAMETRO = 'MAPEO_VELOCIDAD_PERFIL'
        AND CAB_PLANES_TN_EQUIV_PERFIL.NOMBRE_PARAMETRO = 'MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2'
        AND DET_VELOCIDAD_PERFIL.VALOR3 IN ('INTERNET SMALL BUSINESS', 'TELCOHOME')
        AND CAB_VELOCIDAD_PERFIL.ESTADO = 'Activo'
        AND CAB_PLANES_TN_EQUIV_PERFIL.ESTADO = 'Activo'
        AND DET_PLANES_TN_EQUIV_PERFIL.ESTADO = 'Activo'
        AND DET_VELOCIDAD_PERFIL.ESTADO = 'Activo'
        AND DET_VELOCIDAD_PERFIL.EMPRESA_COD='10'
        AND DET_PLANES_TN_EQUIV_PERFIL.EMPRESA_COD='10'
        AND DET_PLANES_TN_EQUIV_PERFIL.VALOR3 = PV_LINEPROFILE;
      EXCEPTION
      WHEN OTHERS THEN
        LV_MENSAJEEX := 'Existieron problemas al recuperar el valor de característica CAPACIDAD1.';
        RAISE LE_EXCEPTION_REG;
      END;
      BEGIN
        SELECT DET_VELOCIDAD_PERFIL.VALOR4 AS CAPACIDAD
        INTO LV_CAPACIDAD2
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB_VELOCIDAD_PERFIL
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET_VELOCIDAD_PERFIL
        ON DET_VELOCIDAD_PERFIL.PARAMETRO_ID = CAB_VELOCIDAD_PERFIL.ID_PARAMETRO
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET_PLANES_TN_EQUIV_PERFIL
        ON DET_PLANES_TN_EQUIV_PERFIL.VALOR1 = DET_VELOCIDAD_PERFIL.VALOR2
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CAB_PLANES_TN_EQUIV_PERFIL
        ON CAB_PLANES_TN_EQUIV_PERFIL.ID_PARAMETRO = DET_PLANES_TN_EQUIV_PERFIL.PARAMETRO_ID
        where CAB_VELOCIDAD_PERFIL.NOMBRE_PARAMETRO = 'MAPEO_VELOCIDAD_PERFIL'
        AND CAB_PLANES_TN_EQUIV_PERFIL.NOMBRE_PARAMETRO = 'MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2'
        AND DET_VELOCIDAD_PERFIL.VALOR3 IN ('INTERNET SMALL BUSINESS', 'TELCOHOME')
        AND CAB_VELOCIDAD_PERFIL.ESTADO = 'Activo'
        AND CAB_PLANES_TN_EQUIV_PERFIL.ESTADO = 'Activo'
        AND DET_PLANES_TN_EQUIV_PERFIL.ESTADO = 'Activo'
        AND DET_VELOCIDAD_PERFIL.ESTADO = 'Activo'
        AND DET_VELOCIDAD_PERFIL.EMPRESA_COD='10'
        AND DET_PLANES_TN_EQUIV_PERFIL.EMPRESA_COD='10'
        AND DET_PLANES_TN_EQUIV_PERFIL.VALOR3 = PV_LINEPROFILE;
      EXCEPTION
      WHEN OTHERS THEN
        LV_MENSAJEEX := 'Existieron problemas al recuperar el valor de característica CAPACIDAD2.';
        RAISE LE_EXCEPTION_REG;
      END;
      IF LV_CAPACIDAD1 IS NULL OR LV_CAPACIDAD2 IS NULL THEN
        LV_MENSAJEEX := 'No se encontró información de CAPACIDAD1 ó CAPACIDAD2 del producto del cliente en información de Telcos.';
        RAISE LE_EXCEPTION_REG;
      END IF;
    END IF;
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
      (
        ID_SERVICIO_PROD_CARACT,
        SERVICIO_ID,
        PRODUCTO_CARACTERISITICA_ID,
        VALOR,
        FE_CREACION,
        FE_ULT_MOD,
        USR_CREACION,
        USR_ULT_MOD,
        ESTADO,
        REF_SERVICIO_PROD_CARACT_ID
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
        PN_IDSERVICIO,
        LR_PCCAPA1.ID_PRODUCTO_CARACTERISITICA,
        LV_CAPACIDAD1,
        SYSDATE,
        NULL,
        LV_USRCREACION,
        NULL,
        'Activo',
        NULL
      );
    LV_MENSAJEHISTORIAL := 'Migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>CAPACIDAD1 Nueva</b>: ';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || LV_CAPACIDAD1 || '<br>';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
      INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
      (
        ID_SERVICIO_PROD_CARACT,
        SERVICIO_ID,
        PRODUCTO_CARACTERISITICA_ID,
        VALOR,
        FE_CREACION,
        FE_ULT_MOD,
        USR_CREACION,
        USR_ULT_MOD,
        ESTADO,
        REF_SERVICIO_PROD_CARACT_ID
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
        PN_IDSERVICIO,
        LR_PCCAPA2.ID_PRODUCTO_CARACTERISITICA,
        LV_CAPACIDAD2,
        SYSDATE,
        NULL,
        LV_USRCREACION,
        NULL,
        'Activo',
        NULL
      );
    LV_MENSAJEHISTORIAL := 'Migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>CAPACIDAD2 Nueva</b>: ';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || LV_CAPACIDAD2 || '<br>';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
      (
        ID_SERVICIO_PROD_CARACT,
        SERVICIO_ID,
        PRODUCTO_CARACTERISITICA_ID,
        VALOR,
        FE_CREACION,
        FE_ULT_MOD,
        USR_CREACION,
        USR_ULT_MOD,
        ESTADO,
        REF_SERVICIO_PROD_CARACT_ID
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
        PN_IDSERVICIO,
        LR_PCPCK.ID_PRODUCTO_CARACTERISITICA,
        LV_PACKDID,
        SYSDATE,
        NULL,
        LV_USRCREACION,
        NULL,
        'Activo',
        NULL
      );
    LV_MENSAJEHISTORIAL := 'Migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>PACKAGE ID Nuevo</b>: ';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || LV_PACKDID || '<br>';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
      (
        ID_SERVICIO_PROD_CARACT,
        SERVICIO_ID,
        PRODUCTO_CARACTERISITICA_ID,
        VALOR,
        FE_CREACION,
        FE_ULT_MOD,
        USR_CREACION,
        USR_ULT_MOD,
        ESTADO,
        REF_SERVICIO_PROD_CARACT_ID
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
        PN_IDSERVICIO,
        LR_PCCLIENTE.ID_PRODUCTO_CARACTERISITICA,
        LV_CLIENTECLASS,
        SYSDATE,
        NULL,
        LV_USRCREACION,
        NULL,
        'Activo',
        NULL
      );
    LV_MENSAJEHISTORIAL := 'Migración de Data<br>';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || '<b>CLIENT CLASS Nuevo</b>: ';
    LV_MENSAJEHISTORIAL := LV_MENSAJEHISTORIAL || LV_CLIENTECLASS || '<br>';
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      (
        ID_SERVICIO_HISTORIAL,
        SERVICIO_ID,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
        PN_IDSERVICIO,
        LV_USRCREACION,
        SYSDATE,
        '127.0.0.1',
        PV_ESTADOSERVICIO,
        LV_MENSAJEHISTORIAL
      );
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Caracteristicas ZTE migradas correctamente.';
  EXCEPTION
  WHEN LE_EXCEPTION_REG THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := LV_MENSAJEEX ||' Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := LV_MENSAJEEX;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZA_CARACT_ZTE', LV_MENSAJE, LV_USRCREACION, SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    COMMIT;
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := 'No se han podido actualizar las caracteristicas correctamente.';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZA_CARACT_ZTE', LV_MENSAJE, LV_USRCREACION, SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ACTUALIZA_CARACT_ZTE;
  PROCEDURE P_INSERTAR_DATA
    (
      PR_INFOBUFFERHILO IN DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA%ROWTYPE,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LV_MENSAJE VARCHAR2
    (
      4000
    )
                                 := 'Error al insertar data';
    LV_USRCREACION VARCHAR2(100) := 'migracion';
    LV_IPULTMOD    VARCHAR2(15)  := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
  BEGIN
    INSERT
    INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
      (
        ID_MIGRACION_ERROR,
        MIGRACION_CAB_ID,
        MIGRACION_DET_ID,
        TIPO_PROCESO,
        IDENTIFICADOR,
        INFORMACION,
        LINEA,
        LOGIN,
        ESTADO,
        OBSERVACION,
        USR_CREACION,
        FE_CREACION
      )
      VALUES
      (
        DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_DATA.NEXTVAL,
        PR_INFOBUFFERHILO.MIGRACION_CAB_ID,
        PR_INFOBUFFERHILO.MIGRACION_DET_ID,
        PR_INFOBUFFERHILO.TIPO_PROCESO,
        PR_INFOBUFFERHILO.IDENTIFICADOR,
        PR_INFOBUFFERHILO.INFORMACION,
        PR_INFOBUFFERHILO.LINEA,
        PR_INFOBUFFERHILO.LOGIN,
        PR_INFOBUFFERHILO.ESTADO,
        PR_INFOBUFFERHILO.OBSERVACION,
        LV_USRCREACION,
        SYSDATE
      );
    COMMIT;
    PV_STATUS  := 'OK';
    PV_MENSAJE := '';
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    LV_MENSAJE := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PV_MENSAJE := 'No se han podido insertar correctamente la información en tabla de datos.';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_DATA', LV_MENSAJE, LV_USRCREACION, SYSDATE, LV_IPULTMOD );
  END P_INSERTAR_DATA;
  PROCEDURE P_MIGRACION_OLT_SAFECITY
    (
      PN_IDOLTANTERIOR IN NUMBER,
      PN_IDOLTNUEVO    IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
  BEGIN
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_CAMBIAR_OLT_SUBRED( PN_IDOLTANTERIOR => PN_IDOLTANTERIOR, PN_IDOLTNUEVO => PN_IDOLTNUEVO, PV_OPCION => 'MIGRACION', PV_STATUS => PV_STATUS, PV_MENSAJE => PV_MENSAJE);
  END P_MIGRACION_OLT_SAFECITY;
  PROCEDURE P_ROLLBACK_OLT_SAFECITY
    (
      PN_IDOLTANTERIOR IN NUMBER,
      PN_IDOLTNUEVO    IN NUMBER,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
  BEGIN
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_CAMBIAR_OLT_SUBRED( PN_IDOLTANTERIOR => PN_IDOLTANTERIOR, PN_IDOLTNUEVO => PN_IDOLTNUEVO, PV_OPCION => 'ROLLBACK', PV_STATUS => PV_STATUS, PV_MENSAJE => PV_MENSAJE);
  END P_ROLLBACK_OLT_SAFECITY;
  PROCEDURE P_CAMBIAR_OLT_SUBRED
    (
      PN_IDOLTANTERIOR IN NUMBER,
      PN_IDOLTNUEVO    IN NUMBER,
      PV_OPCION        IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LN_ID_ELEMENTO_NUEVO    NUMBER       := PN_IDOLTNUEVO;
    LN_ID_ELEMENTO_BUSCAR   NUMBER       := PN_IDOLTANTERIOR;
    LV_ESTADO_ACTUALIZAR    VARCHAR2(20) := 'Migrado';
    LV_USER                 VARCHAR2(20) := 'telcos_migra';
    LV_IP_CRECION           VARCHAR2(20) := '127.0.0.1';
    LV_DETALLE_ELE_ANTERIOR VARCHAR2(20);
    LV_DETALLE_ELE_NUEVO    VARCHAR2(20);
    LV_ESTADO_SUBRED        VARCHAR2(20);
    LV_SUBRED_ESTADO        VARCHAR2(20);
    LE_CONTINUAR            EXCEPTION;
    LE_EXECPTION            EXCEPTION;
    LN_SUBRED_ID_NUEVO      NUMBER;
    LN_INDEX                NUMBER;
    CURSOR C_ELEMENTO (CN_ELEMENTO_ID NUMBER)
    IS
      SELECT ELE.ID_ELEMENTO,
        ELE.NOMBRE_ELEMENTO,
        MODELE.NOMBRE_MODELO_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE
      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELE
      ON MODELE.ID_MODELO_ELEMENTO = ELE.MODELO_ELEMENTO_ID
      WHERE ELE.ID_ELEMENTO        = CN_ELEMENTO_ID;
    LC_ELEMENTO C_ELEMENTO%ROWTYPE;
    -- Cursor para validar la caracteristica MULTIPLATAFORMA del OLT
    CURSOR C_DETALLE_ELEMENTO (CN_ELEMENTO_IF NUMBER)
    IS
      SELECT DETALLE_VALOR
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID  = CN_ELEMENTO_IF
      AND DETALLE_NOMBRE = 'MULTIPLATAFORMA';
    LC_DETALLE_ELEMENTO C_DETALLE_ELEMENTO%ROWTYPE;
    CURSOR C_SUBREDES_ELEMENTO (CN_ELEMENTO_ID NUMBER)
    IS
      SELECT SUB.ID_SUBRED,
        SUB.RED_ID,
        SUB.SUBRED,
        SUB.MASCARA,
        SUB.GATEWAY,
        SUB.ESTADO,
        SUB.ELEMENTO_ID,
        SUB.NOTIFICACION,
        SUB.IP_INICIAL,
        SUB.IP_FINAL,
        SUB.IP_DISPONIBLE,
        SUB.TIPO,
        SUB.USO,
        SUB.SUBRED_ID,
        SUB.EMPRESA_COD,
        SUB.PREFIJO_ID,
        SUB.CANTON_ID,
        SUB.VERSION_IP,
        SUB.ANILLO
      FROM DB_INFRAESTRUCTURA.INFO_SUBRED SUB
      WHERE EXISTS
        (SELECT 1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
          DB_GENERAL.ADMI_PARAMETRO_DET DET
        WHERE SUB.ELEMENTO_ID    = CN_ELEMENTO_ID
        AND CAB.NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
        AND CAB.MODULO           = 'TECNICO'
        AND CAB.ESTADO           = 'Activo'
        AND CAB.ID_PARAMETRO     = DET.PARAMETRO_ID
        AND SUB.USO              = DET.VALOR1
        AND SUB.ESTADO           = DET.VALOR3
        AND DET.ESTADO           = 'Activo'
        )
    ORDER BY RED_ID ASC ;
  TYPE LTL_SUBREDES_ELEMENTO
IS
  TABLE OF C_SUBREDES_ELEMENTO%ROWTYPE;
  LR_SUBREDES_ELEMENTO LTL_SUBREDES_ELEMENTO;
  LE_BULKERRORS EXCEPTION;
  PRAGMA EXCEPTION_INIT(LE_BULKERRORS, -24381);
  CURSOR C_GET_SUBRED_ID (CN_ELEMENTO_ID NUMBER, CN_SUBRED_ID NUMBER)
  IS
    SELECT SUB.ID_SUBRED
    FROM DB_INFRAESTRUCTURA.INFO_SUBRED SUB ,
      DB_INFRAESTRUCTURA.INFO_SUBRED SUB2
    WHERE SUB.SUBRED    = SUB2.SUBRED
    AND SUB.USO         = SUB2.USO
    AND SUB.ESTADO      = SUB2.ESTADO
    AND SUB.ELEMENTO_ID = CN_ELEMENTO_ID
    AND SUB2.ID_SUBRED  = CN_SUBRED_ID;
  -- === Fin Cursores ===
BEGIN
  IF PV_OPCION             = 'ROLLBACK' THEN
    LV_ESTADO_SUBRED      := 'Migrado';
    LN_ID_ELEMENTO_NUEVO  := PN_IDOLTANTERIOR;
    LN_ID_ELEMENTO_BUSCAR := PN_IDOLTNUEVO;
    LV_ESTADO_ACTUALIZAR  := 'Eliminado';
  END IF;
-- Se ingresa el historial para el elemento anterior
INSERT
INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO VALUES
  (
    DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
    PN_IDOLTANTERIOR,
    'Activo',
    NULL,
    'Inicia el proceso de '
    ||PV_OPCION
    ||' para el elemento',
    LV_USER,
    SYSDATE,
    LV_IP_CRECION
  );
-- Se ingresa el historial para el elemento nuevo
INSERT
INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO VALUES
  (
    DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
    PN_IDOLTNUEVO,
    'Activo',
    NULL,
    'Inicia el proceso de '
    ||PV_OPCION
    ||' para el elemento',
    LV_USER,
    SYSDATE,
    LV_IP_CRECION
  );
-- Verificamos si el OLT es MULTIPLATAFORMA
IF C_DETALLE_ELEMENTO%ISOPEN THEN
  CLOSE C_DETALLE_ELEMENTO;
END IF;
OPEN C_DETALLE_ELEMENTO(LN_ID_ELEMENTO_BUSCAR);
FETCH C_DETALLE_ELEMENTO INTO LC_DETALLE_ELEMENTO;
LV_DETALLE_ELE_ANTERIOR := LC_DETALLE_ELEMENTO.DETALLE_VALOR;
CLOSE C_DETALLE_ELEMENTO;
IF LV_DETALLE_ELE_ANTERIOR IS NULL THEN
  LV_DETALLE_ELE_ANTERIOR  := 'NO';
END IF;
-- Verificamos si el OLT es MULTIPLATAFORMA
IF C_DETALLE_ELEMENTO%ISOPEN THEN
  CLOSE C_DETALLE_ELEMENTO;
END IF;
OPEN C_DETALLE_ELEMENTO(LN_ID_ELEMENTO_NUEVO);
FETCH C_DETALLE_ELEMENTO INTO LC_DETALLE_ELEMENTO;
LV_DETALLE_ELE_NUEVO := LC_DETALLE_ELEMENTO.DETALLE_VALOR;
CLOSE C_DETALLE_ELEMENTO;
IF LV_DETALLE_ELE_NUEVO IS NULL THEN
  LV_DETALLE_ELE_NUEVO  := 'NO';
END IF;
--Validamos que ambos OLTs sea MULTIPLATAFORMA
IF LV_DETALLE_ELE_NUEVO != 'SI' AND LV_DETALLE_ELE_ANTERIOR != 'SI' THEN
  PV_MENSAJE            :='No se realizo la migracion del OLTs SAFECITY debido a que los OLTs no son multiplaforma';
  RAISE LE_CONTINUAR;
END IF;
IF C_SUBREDES_ELEMENTO%ISOPEN THEN
  CLOSE C_SUBREDES_ELEMENTO;
END IF;
IF C_GET_SUBRED_ID%ISOPEN THEN
  CLOSE C_GET_SUBRED_ID;
END IF;
OPEN C_SUBREDES_ELEMENTO(LN_ID_ELEMENTO_BUSCAR);
LOOP
  FETCH C_SUBREDES_ELEMENTO BULK COLLECT INTO LR_SUBREDES_ELEMENTO LIMIT 30000;
  LN_INDEX        := LR_SUBREDES_ELEMENTO.FIRST;
  WHILE (LN_INDEX IS NOT NULL AND LN_INDEX <= LR_SUBREDES_ELEMENTO.COUNT)
  LOOP
    --
    LN_SUBRED_ID_NUEVO := NULL;
    LV_SUBRED_ESTADO   := NULL;
    OPEN C_GET_SUBRED_ID(LN_ID_ELEMENTO_NUEVO, LR_SUBREDES_ELEMENTO(LN_INDEX).SUBRED_ID);
    FETCH C_GET_SUBRED_ID INTO LN_SUBRED_ID_NUEVO;
    CLOSE C_GET_SUBRED_ID;
    --
    IF LN_SUBRED_ID_NUEVO IS NULL THEN
      LN_SUBRED_ID_NUEVO  := LR_SUBREDES_ELEMENTO(LN_INDEX).SUBRED_ID;
      LV_SUBRED_ESTADO    := LR_SUBREDES_ELEMENTO(LN_INDEX).ESTADO;
    END IF;
    --
    IF PV_OPCION = 'MIGRACION' THEN
      INSERT
      INTO DB_INFRAESTRUCTURA.INFO_SUBRED VALUES
        (
          DB_INFRAESTRUCTURA.SEQ_INFO_SUBRED.NEXTVAL,
          LR_SUBREDES_ELEMENTO(LN_INDEX).RED_ID,
          LR_SUBREDES_ELEMENTO(LN_INDEX).SUBRED,
          LR_SUBREDES_ELEMENTO(LN_INDEX).MASCARA,
          LR_SUBREDES_ELEMENTO(LN_INDEX).GATEWAY,
          LV_USER,
          SYSDATE,
          LV_IP_CRECION,
          LR_SUBREDES_ELEMENTO(LN_INDEX).ESTADO,
          LN_ID_ELEMENTO_NUEVO,
          LR_SUBREDES_ELEMENTO(LN_INDEX).NOTIFICACION,
          LR_SUBREDES_ELEMENTO(LN_INDEX).IP_INICIAL,
          LR_SUBREDES_ELEMENTO(LN_INDEX).IP_FINAL,
          LR_SUBREDES_ELEMENTO(LN_INDEX).IP_DISPONIBLE,
          LR_SUBREDES_ELEMENTO(LN_INDEX).TIPO,
          LR_SUBREDES_ELEMENTO(LN_INDEX).USO,
          LN_SUBRED_ID_NUEVO,
          LR_SUBREDES_ELEMENTO(LN_INDEX).EMPRESA_COD,
          LR_SUBREDES_ELEMENTO(LN_INDEX).PREFIJO_ID,
          LR_SUBREDES_ELEMENTO(LN_INDEX).CANTON_ID,
          LR_SUBREDES_ELEMENTO(LN_INDEX).VERSION_IP,
          LR_SUBREDES_ELEMENTO(LN_INDEX).ANILLO
        );
    END IF;
    --
    IF PV_OPCION = 'ROLLBACK' THEN
      UPDATE DB_INFRAESTRUCTURA.INFO_SUBRED
      SET ESTADO       = LV_SUBRED_ESTADO
      WHERE ID_SUBRED IN
        (SELECT SUB.ID_SUBRED
        FROM DB_INFRAESTRUCTURA.INFO_SUBRED SUB,
          DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
          DB_GENERAL.ADMI_PARAMETRO_DET DET
        WHERE SUB.ELEMENTO_ID    = LN_ID_ELEMENTO_NUEVO
        AND CAB.NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
        AND CAB.MODULO           = 'TECNICO'
        AND CAB.ESTADO           = 'Activo'
        AND CAB.ID_PARAMETRO     = DET.PARAMETRO_ID
        AND DET.DESCRIPCION      = 'Parametros Subredes'
        AND DET.VALOR1           = SUB.USO
        AND SUB.ESTADO           = LV_ESTADO_SUBRED
        AND DET.ESTADO           = 'Activo'
        );
    END IF;
    LN_INDEX:=LN_INDEX + 1;
  END LOOP;
  EXIT
WHEN C_SUBREDES_ELEMENTO%NOTFOUND;
END LOOP;
CLOSE C_SUBREDES_ELEMENTO;
--
--
UPDATE DB_INFRAESTRUCTURA.INFO_SUBRED
SET ESTADO       = LV_ESTADO_ACTUALIZAR
WHERE ID_SUBRED IN
  (SELECT SUB.ID_SUBRED
  FROM DB_INFRAESTRUCTURA.INFO_SUBRED SUB,
    DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
    DB_GENERAL.ADMI_PARAMETRO_DET DET
  WHERE SUB.ELEMENTO_ID    = LN_ID_ELEMENTO_BUSCAR
  AND CAB.NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
  AND CAB.MODULO           = 'TECNICO'
  AND CAB.ESTADO           = 'Activo'
  AND CAB.ID_PARAMETRO     = DET.PARAMETRO_ID
  AND DET.DESCRIPCION      = 'Parametros Subredes'
  AND DET.VALOR1           = SUB.USO
  AND DET.VALOR3           = SUB.ESTADO
  AND DET.ESTADO           = 'Activo'
  );
--
--
PV_STATUS  := 'OK';
PV_MENSAJE := 'Proceso realizado exitosamente';
--Se ingresa el historial del elemento aterior
INSERT
INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO VALUES
  (
    DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
    PN_IDOLTANTERIOR,
    'Activo',
    NULL,
    PV_OPCION
    ||': Se actualizaron las subredes del elemento.',
    LV_USER,
    SYSDATE,
    LV_IP_CRECION
  );
--Se ingresa el historial del elemento nuevo
INSERT
INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO VALUES
  (
    DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
    PN_IDOLTNUEVO,
    'Activo',
    NULL,
    PV_OPCION
    ||': Se actualizan las subredes del elemento.',
    LV_USER,
    SYSDATE,
    LV_IP_CRECION
  );
--
EXCEPTION
WHEN LE_CONTINUAR THEN
  PV_STATUS := 'OK';
WHEN LE_EXECPTION THEN
  PV_STATUS := 'ERROR';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_Cambiar_Olt_Subred', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
WHEN LE_BULKERRORS THEN
  PV_STATUS  := 'ERROR';
  PV_MENSAJE := 'No se pudo realizar la clonacion de las subredes';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_Cambiar_Olt_Subred', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
WHEN OTHERS THEN
  PV_STATUS  := 'ERROR';
  PV_MENSAJE := 'Error: '||SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_Cambiar_Olt_Subred', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  --
END P_CAMBIAR_OLT_SUBRED;
--
--
--
PROCEDURE P_MIGRACION_SERVICIOS_SAFECITY
  (
    PN_IDSERVICIO IN NUMBER,
    PN_IDELEMENTOINI IN NUMBER,
    PN_IDELEMENTOFIN IN NUMBER,
    PV_MARCAOLTINI IN  VARCHAR2,
    PV_MARCAOLTFIN IN  VARCHAR2,
    PV_STATUS OUT VARCHAR2,
    PV_MENSAJE OUT VARCHAR2
  )
AS
  LE_CONTINUAR             EXCEPTION;
BEGIN
  IF PV_MARCAOLTINI = 'HUAWEI' AND PV_MARCAOLTFIN = 'ZTE' THEN
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CARACT_SAFECITY( PN_IDSERVICIO => PN_IDSERVICIO,
                                                                                  PN_IDELEMENTOINI => PN_IDELEMENTOINI,
                                                                                  PN_IDELEMENTOFIN => PN_IDELEMENTOFIN,
                                                                                  PV_OPCION => 'MIGRACION',
                                                                                  PV_STATUS => PV_STATUS,
                                                                                  PV_MENSAJE => PV_MENSAJE);
    IF PV_STATUS  = 'ERROR' THEN
      RAISE LE_CONTINUAR;
    END IF;
  END IF;
  DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_SUBRED_SERVICIO( PN_IDSERVICIO => PN_IDSERVICIO, PV_OPCION => 'MIGRACION', PV_STATUS => PV_STATUS, PV_MENSAJE => PV_MENSAJE);
EXCEPTION
  WHEN LE_CONTINUAR THEN
    PV_STATUS := 'ERROR';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_MIGRACION_SERVICIOS_SAFECITY', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Error: '||SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_MIGRACION_SERVICIOS_SAFECITY', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_MIGRACION_SERVICIOS_SAFECITY;
--
PROCEDURE P_ROLLBACK_SERVICIOS_SAFECITY
  (
    PN_IDSERVICIO IN NUMBER,
    PN_IDELEMENTOINI IN NUMBER,
    PN_IDELEMENTOFIN IN NUMBER,
    PV_MARCAOLTINI IN  VARCHAR2,
    PV_MARCAOLTFIN IN  VARCHAR2,
    PV_STATUS OUT VARCHAR2,
    PV_MENSAJE OUT VARCHAR2
  )
AS
  LE_CONTINUAR             EXCEPTION;
BEGIN
  IF PV_MARCAOLTINI = 'HUAWEI' AND PV_MARCAOLTFIN = 'ZTE' THEN
    DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CARACT_SAFECITY( PN_IDSERVICIO => PN_IDSERVICIO,
                                                                                  PN_IDELEMENTOINI => PN_IDELEMENTOINI,
                                                                                  PN_IDELEMENTOFIN => PN_IDELEMENTOFIN,
                                                                                  PV_OPCION => 'ROLLBACK',
                                                                                  PV_STATUS => PV_STATUS,
                                                                                  PV_MENSAJE => PV_MENSAJE);
    IF PV_STATUS  = 'ERROR' THEN
      RAISE LE_CONTINUAR;
    END IF;
  END IF;
  DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_SUBRED_SERVICIO( PN_IDSERVICIO => PN_IDSERVICIO, PV_OPCION => 'ROLLBACK', PV_STATUS => PV_STATUS, PV_MENSAJE => PV_MENSAJE);
EXCEPTION
  WHEN LE_CONTINUAR THEN
    PV_STATUS := 'ERROR';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_ROLLBACK_SERVICIOS_SAFECITY', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Error: '||SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_ROLLBACK_SERVICIOS_SAFECITY', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_ROLLBACK_SERVICIOS_SAFECITY;
--
PROCEDURE P_ACTUALIZAR_SUBRED_SERVICIO
  (
    PN_IDSERVICIO IN NUMBER,
    PV_OPCION     IN VARCHAR2,
    PV_STATUS OUT VARCHAR2,
    PV_MENSAJE OUT VARCHAR2
  )
AS
  -- === Variables ===
  --
  LE_CONTINUAR             EXCEPTION;
  LE_EXECPTION             EXCEPTION;
  LV_USER                  VARCHAR2(20) := 'telcos_migra';
  LV_ESTADO_ACTUALIZAR     VARCHAR2(20) := 'Eliminado';
  LV_ESTADO_BUSCAR         VARCHAR2(20) := 'Migrado';
  LV_IP_CRECION            VARCHAR2(20) := '127.0.0.1';
  LN_NOMBRE_TECNICO        VARCHAR2(20);
  LV_CARACTERISTICA        NUMBER;
  LN_PERSONA_EMPRESA_ROL   NUMBER;
  LN_ID_PERSONA_CARAC      NUMBER;
  LN_SUBRED_SERVICIO       NUMBER;
  LN_PRODUCTO_ID           NUMBER;
  LV_USO_SUBRED            VARCHAR2(20);
  LN_SUBRED_NUEVA          NUMBER;
  LN_SUBRED_ACTUAL         NUMBER;
  LV_SUBRED_SUBRED         VARCHAR2(20);
  LV_ESTADO_SERVICIO       VARCHAR2(30);
  LN_ID_IP                 NUMBER;
  LN_ELEMENTO_ID           NUMBER;
  LV_IP                    VARCHAR2(20);
  LV_ESTADO                VARCHAR2(20);
  LV_MASCARA               VARCHAR2(20);
  LV_GATEWAY               VARCHAR2(20);
  LV_TIPO_IP               VARCHAR2(20);
  LV_VERSION_IP            VARCHAR2(20);
  LN_INTERFACE_ELEMENTO_ID NUMBER;
  LN_REF_IP_ID             NUMBER;
  -- === Fin Variables ===
  -- === Cursores ===
  CURSOR C_PRODUCTO_SERVICIO(CN_SERVICIO_ID NUMBER)
  IS
    SELECT PRO.*
    FROM ADMI_PRODUCTO PRO
    LEFT JOIN INFO_SERVICIO SERV
    ON SERV.PRODUCTO_ID    = PRO.ID_PRODUCTO
    WHERE SERV.ID_SERVICIO = CN_SERVICIO_ID;
  LC_PRODUCTO_SERVICIO C_PRODUCTO_SERVICIO%ROWTYPE;
  --
  CURSOR C_INFO_SERVICIO( CN_SERVICIO_ID NUMBER)
  IS
    SELECT SERVICIO.ID_SERVICIO,
      SERVICIO.PRODUCTO_ID,
      SERVICIO.ESTADO AS ESTADO_SERVICIO,
      IP.*,
      SUBRED.ID_SUBRED,
      PUNTO.PERSONA_EMPRESA_ROL_ID
    FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
    LEFT JOIN DB_INFRAESTRUCTURA.INFO_IP IP
    ON IP.SERVICIO_ID = SERVICIO.ID_SERVICIO
    LEFT JOIN DB_INFRAESTRUCTURA.INFO_SUBRED SUBRED
    ON SUBRED.ID_SUBRED = IP.SUBRED_ID
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
    ON PUNTO.ID_PUNTO          = SERVICIO.PUNTO_ID
    WHERE SERVICIO.ID_SERVICIO = CN_SERVICIO_ID
    AND IP.ESTADO             IN ('Activo','Reservada');
  LC_INFO_SERVICIO C_INFO_SERVICIO%ROWTYPE;
  --
  CURSOR C_SUBRED(CN_ID_SUBRED NUMBER, CV_ESTADO VARCHAR2)
  IS
    SELECT ID_SUBRED,
      SUBRED,
      USO
    FROM DB_INFRAESTRUCTURA.INFO_SUBRED
    WHERE ID_SUBRED = CN_ID_SUBRED
    AND ESTADO      = CV_ESTADO;
  LC_SUBRED C_SUBRED%ROWTYPE;
  --
  CURSOR C_SUBRED_NUEVA(CV_SUBRED VARCHAR2, CV_USO VARCHAR2)
  IS
    SELECT ID_SUBRED
    FROM DB_INFRAESTRUCTURA.INFO_SUBRED
    WHERE SUBRED = CV_SUBRED
    AND USO      = CV_USO
    AND ESTADO   = 'Ocupado';
  LC_SUBRED_NUEVA C_SUBRED_NUEVA%ROWTYPE;
  --
  CURSOR C_CARAC_SUBRED_PRIVADA(CN_PERSONA_EMPRESA_ROL NUMBER, CV_SUBRED VARCHAR2)
  IS
    SELECT PERSONA_EMPRESA_ROL_CARAC.*
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC PERSONA_EMPRESA_ROL_CARAC
    LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CAR
    ON CAR.DESCRIPCION_CARACTERISTICA                      = 'SUBRED_PRIVADA'
    WHERE PERSONA_EMPRESA_ROL_CARAC.PERSONA_EMPRESA_ROL_ID = CN_PERSONA_EMPRESA_ROL
    AND PERSONA_EMPRESA_ROL_CARAC.CARACTERISTICA_ID        = CAR.ID_CARACTERISTICA
    AND PERSONA_EMPRESA_ROL_CARAC.VALOR                    = CV_SUBRED;
  LC_CARAC_SUBRED_PRIVADA C_CARAC_SUBRED_PRIVADA%ROWTYPE;
  -- === Fin Cursores ===
BEGIN
  -- Validamos los productos que no guardan IP
  IF C_PRODUCTO_SERVICIO%ISOPEN THEN
    CLOSE C_PRODUCTO_SERVICIO;
  END IF;
  OPEN C_PRODUCTO_SERVICIO (PN_IDSERVICIO);
  FETCH C_PRODUCTO_SERVICIO INTO LC_PRODUCTO_SERVICIO;
  LN_NOMBRE_TECNICO := LC_PRODUCTO_SERVICIO.NOMBRE_TECNICO;
  CLOSE C_PRODUCTO_SERVICIO;
  --
  IF LN_NOMBRE_TECNICO = 'DATOS SAFECITY' OR LN_NOMBRE_TECNICO = 'SAFECITYWIFI' OR LN_NOMBRE_TECNICO = 'SAFECITYSWPOE' THEN
    PV_MENSAJE        := 'El servicio no requerie de configurar subred';
    RAISE LE_CONTINUAR;
  END IF;
  --
  IF C_INFO_SERVICIO%ISOPEN THEN
    CLOSE C_INFO_SERVICIO;
  END IF;
  OPEN C_INFO_SERVICIO(PN_IDSERVICIO);
  FETCH C_INFO_SERVICIO INTO LC_INFO_SERVICIO;
  LN_SUBRED_SERVICIO     := LC_INFO_SERVICIO.SUBRED_ID;
  LN_PRODUCTO_ID         := LC_INFO_SERVICIO.PRODUCTO_ID;
  LV_ESTADO_SERVICIO     := LC_INFO_SERVICIO.ESTADO_SERVICIO;
  LN_PERSONA_EMPRESA_ROL := LC_INFO_SERVICIO.PERSONA_EMPRESA_ROL_ID;
  -- Datos IP
  LN_ID_IP                 := LC_INFO_SERVICIO.ID_IP;
  LN_ELEMENTO_ID           := LC_INFO_SERVICIO.ELEMENTO_ID;
  LV_IP                    := LC_INFO_SERVICIO.IP;
  LV_ESTADO                := LC_INFO_SERVICIO.ESTADO;
  LV_MASCARA               := LC_INFO_SERVICIO.MASCARA;
  LV_GATEWAY               := LC_INFO_SERVICIO.GATEWAY;
  LV_TIPO_IP               := LC_INFO_SERVICIO.TIPO_IP;
  LV_VERSION_IP            := LC_INFO_SERVICIO.VERSION_IP;
  LN_INTERFACE_ELEMENTO_ID := LC_INFO_SERVICIO.INTERFACE_ELEMENTO_ID;
  LN_REF_IP_ID             := LC_INFO_SERVICIO.REF_IP_ID;
  CLOSE C_INFO_SERVICIO;
  --
  --
  IF LN_SUBRED_SERVICIO IS NULL THEN
    PV_MENSAJE          := 'Error: No se pudo encontrar la subred del servicio '||PN_IDSERVICIO|| ' - '||SQLERRM;
    RAISE LE_EXECPTION;
  END IF;
  --
  IF C_SUBRED%ISOPEN THEN
    CLOSE C_SUBRED;
  END IF;
  --
  --
  IF PV_OPCION        = 'ROLLBACK' THEN
    LV_ESTADO_BUSCAR := 'Eliminado';
  END IF;
  --
  OPEN C_SUBRED(LN_SUBRED_SERVICIO, LV_ESTADO_BUSCAR);
  FETCH C_SUBRED INTO LC_SUBRED;
  LN_SUBRED_ACTUAL := LC_SUBRED.ID_SUBRED;
  LV_SUBRED_SUBRED := LC_SUBRED.SUBRED;
  LV_USO_SUBRED    := LC_SUBRED.USO;
  CLOSE C_SUBRED;
  --
  IF LN_SUBRED_SERVICIO IS NULL THEN
    PV_MENSAJE          := 'Error: No se pudo encontrar la subred'||LN_SUBRED_SERVICIO|| ' en estado '||LV_ESTADO_BUSCAR;
    RAISE LE_EXECPTION;
  END IF;
  --
  IF C_SUBRED_NUEVA%ISOPEN THEN
    CLOSE C_SUBRED_NUEVA;
  END IF;
  OPEN C_SUBRED_NUEVA(LV_SUBRED_SUBRED, LV_USO_SUBRED);
  FETCH C_SUBRED_NUEVA INTO LC_SUBRED_NUEVA;
  LN_SUBRED_NUEVA := LC_SUBRED_NUEVA.ID_SUBRED;
  CLOSE C_SUBRED_NUEVA;
  --
  IF LN_SUBRED_NUEVA IS NULL THEN
    PV_MENSAJE       := 'Error: No se pudo encontrar la nueva subred para el servicio '||PN_IDSERVICIO|| ' - '||SQLERRM;
    RAISE LE_EXECPTION;
  END IF;
  --
  UPDATE INFO_IP SET ESTADO = LV_ESTADO_ACTUALIZAR WHERE ID_IP = LN_ID_IP;
  --
  --
  --
  INSERT
  INTO DB_INFRAESTRUCTURA.INFO_IP VALUES
    (
      DB_INFRAESTRUCTURA.SEQ_INFO_IP.NEXTVAL,
      LN_ELEMENTO_ID,
      LV_IP,
      LV_USER,
      SYSDATE,
      LV_IP_CRECION,
      LV_ESTADO,
      LN_SUBRED_NUEVA,
      LV_MASCARA,
      LV_GATEWAY,
      LV_TIPO_IP,
      LV_VERSION_IP,
      PN_IDSERVICIO,
      LN_INTERFACE_ELEMENTO_ID,
      LN_REF_IP_ID
    );
  --
  --
  --
  IF C_CARAC_SUBRED_PRIVADA%ISOPEN THEN
    CLOSE C_CARAC_SUBRED_PRIVADA;
  END IF;
  OPEN C_CARAC_SUBRED_PRIVADA(LN_PERSONA_EMPRESA_ROL, TO_CHAR(LN_SUBRED_SERVICIO));
  FETCH C_CARAC_SUBRED_PRIVADA INTO LC_CARAC_SUBRED_PRIVADA;
  LN_ID_PERSONA_CARAC := LC_CARAC_SUBRED_PRIVADA.ID_PERSONA_EMPRESA_ROL_CARACT;
  LV_CARACTERISTICA   := LC_CARAC_SUBRED_PRIVADA.CARACTERISTICA_ID;
  CLOSE C_CARAC_SUBRED_PRIVADA;
  --
  IF LN_ID_PERSONA_CARAC IS NOT NULL THEN
    UPDATE INFO_PERSONA_EMPRESA_ROL_CARAC
    SET ESTADO                          = LV_ESTADO_ACTUALIZAR,
      USR_ULT_MOD                       = LV_USER,
      FE_ULT_MOD                        = SYSDATE
    WHERE ID_PERSONA_EMPRESA_ROL_CARACT = LN_ID_PERSONA_CARAC;
  END IF;
  --
  IF LV_CARACTERISTICA IS NULL THEN
    LV_CARACTERISTICA  := 1110;
  END IF;
  --
  INSERT
  INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC VALUES
    (
      DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL,
      LN_PERSONA_EMPRESA_ROL,
      LV_CARACTERISTICA,
      TO_CHAR(LN_SUBRED_NUEVA),
      SYSDATE,
      NULL,
      LV_USER,
      NULL,
      LV_IP_CRECION,
      'Activo',
      NULL
    );
  --
  PV_STATUS  := 'OK';
  PV_MENSAJE := 'Se actualizo la subred de la info IP del servicio: '||PN_IDSERVICIO;
  --
  INSERT
  INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL VALUES
    (
      DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
      PN_IDSERVICIO,
      LV_USER,
      SYSDATE,
      LV_IP_CRECION,
      LV_ESTADO_SERVICIO,
      NULL,
      PV_OPCION
      ||': Se realizo la actualizacion a la subred: '
      ||LN_SUBRED_NUEVA
      ||' para el servicio.',
      NULL
    );
  --
EXCEPTION
WHEN LE_CONTINUAR THEN
  PV_STATUS := 'OK';
WHEN LE_EXECPTION THEN
  PV_STATUS := 'ERROR';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_Actualizar_Subred_Servicio', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
WHEN OTHERS THEN
  PV_STATUS  := 'ERROR';
  PV_MENSAJE := 'Error: '||SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_Actualizar_Subred_Servicio', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_ACTUALIZAR_SUBRED_SERVICIO;
PROCEDURE P_INSERTA_MIGRA_DATA_ERROR
  (
    PN_MIGRACION_CAB_ID IN NUMBER,
    PV_TIPO_PROCESO     IN VARCHAR2,
    PN_LINEA            IN NUMBER,
    PV_ESTADO           IN VARCHAR2,
    PV_OBSERVACION      IN VARCHAR2,
    PV_USR_CREACION     IN VARCHAR2
  )
IS
BEGIN
  INSERT
  INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
    (
      ID_MIGRACION_ERROR,
      MIGRACION_CAB_ID,
      TIPO_PROCESO,
      LINEA,
      ESTADO,
      OBSERVACION,
      USR_CREACION,
      FE_CREACION
    )
    VALUES
    (
      DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_DATA.NEXTVAL,
      PN_MIGRACION_CAB_ID,
      PV_TIPO_PROCESO,
      PN_LINEA,
      PV_ESTADO,
      PV_OBSERVACION,
      PV_USR_CREACION,
      SYSDATE
    );
  COMMIT;
END P_INSERTA_MIGRA_DATA_ERROR;
PROCEDURE P_UPLOAD_CSV_MIGRACION_OLT
  (
    PV_USRCREACION IN VARCHAR2,
    PV_STATUS OUT VARCHAR2,
    PV_MENSAJE OUT VARCHAR2
  )
AS
  LV_PARAMETRO_MIGRACION VARCHAR2
  (
    100
  )
                                 := 'MIGRACION_OLT_ALTA_DENSIDAD';
  LV_ESTADO_ACTIVO VARCHAR2(150) := 'Activo';
  CURSOR C_GET_ARCHIVOS_CARGADOS
  IS
    SELECT INFORMACION AS ARCHIVO,
      IDENTIFICADOR    AS ID_DOCUMENTO
    FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
    WHERE MIGRACION_CAB_ID IN
      (SELECT ID_MIGRACION_CAB
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
      WHERE ESTADO = 'Pendiente'
      AND TIPO     = 'ArchivosMigracion'
      )
  AND ESTADO = 'Cargado'
  ORDER BY IDENTIFICADOR ASC;
  CURSOR LC_GETVALORESPARAMSXVALOR1(CV_NOMBREPARAMETRO DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, CV_VALOR1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
  IS
    SELECT DET.VALOR2,
      DET.VALOR3
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
    ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
    WHERE CAB.NOMBRE_PARAMETRO = CV_NOMBREPARAMETRO
    AND CAB.ESTADO             = LV_ESTADO_ACTIVO
    AND DET.VALOR1             = CV_VALOR1
    AND DET.ESTADO             = LV_ESTADO_ACTIVO;
  CURSOR LC_GETDATAARCHIVOCSV(CN_IDDOCUMENTO NUMBER)
  IS
    SELECT UBICACION_LOGICA_DOCUMENTO,
      UBICACION_FISICA_DOCUMENTO,
      NOMBRE_DOCUMENTO
    FROM DB_COMUNICACION.INFO_DOCUMENTO
    WHERE ID_DOCUMENTO = CN_IDDOCUMENTO;
  CURSOR C_GET_NOMBRE_ARCHIVO(CV_ELEMENTO VARCHAR2)
  IS
    SELECT NOMBRE_DOCUMENTO
    FROM DB_COMUNICACION.INFO_DOCUMENTO
    WHERE ID_DOCUMENTO IN
      (SELECT IDENTIFICADOR AS ID_DOCUMENTO
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
      WHERE MIGRACION_CAB_ID IN
        (SELECT ID_MIGRACION_CAB
        FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
        WHERE ESTADO = 'Pendiente'
        AND TIPO     = 'ArchivosMigracion'
        )
    AND ESTADO       = 'Cargado'
    AND INFORMACION IN(CV_ELEMENTO)
      );
    CURSOR C_GET_PARAM_NUM_PIPE(CV_ELEMENTO VARCHAR2)
    IS
      SELECT VALOR3 AS NUM_PIPE
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = LV_PARAMETRO_MIGRACION
        )
    AND VALOR1 = 'NUMERO_PIPE'
    AND VALOR2 = CV_ELEMENTO;
    CURSOR C_COUNT_PIPE_LINEA(CV_CADENA VARCHAR2)
    IS
      SELECT LENGTH(CV_CADENA) - LENGTH(REPLACE(CV_CADENA,'|')) COUNT_PIPE
      FROM DUAL;
    CURSOR C_GET_CAMPO_VACIO(CV_CADENA VARCHAR2)
    IS
      SELECT DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_VALIDACION_CADENA(CV_CADENA) AS VALOR
      FROM DUAL;
    CURSOR C_GET_NUM_ELEMENTO(CV_NOMBRE_ELEMENTO VARCHAR2)
    IS
      SELECT COUNT(1) AS COUNT_REG
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE NOMBRE_ELEMENTO = CV_NOMBRE_ELEMENTO
      AND ESTADO                   = LV_ESTADO_ACTIVO;
    CURSOR C_GET_INFO_ELEMENTO(CV_NOMBRE_ELEMENTO VARCHAR2)
    IS
      SELECT ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE NOMBRE_ELEMENTO = CV_NOMBRE_ELEMENTO
      AND ESTADO                   = LV_ESTADO_ACTIVO;
    CURSOR C_GET_INTERFACE_ELEMENTO(CV_ID_ELEMENTO NUMBER, CV_NOMBRE_INTERFACE_ELEMENTO VARCHAR2, CV_ESTADO VARCHAR2)
    IS
      SELECT COUNT(1) COUNT_REG
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
      WHERE ELEMENTO_ID             = CV_ID_ELEMENTO
      AND NOMBRE_INTERFACE_ELEMENTO = CV_NOMBRE_INTERFACE_ELEMENTO
      AND ESTADO                    = CV_ESTADO;
    CURSOR C_GET_TIPO_NOMBRE_ELEMENTO(CN_ID_ELEMENTO NUMBER)
    IS
      SELECT TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_ELEMENTO
      WHERE ELEMENTO.MODELO_ELEMENTO_ID = MODELO.ID_MODELO_ELEMENTO
      AND MODELO.TIPO_ELEMENTO_ID       = TIPO_ELEMENTO.ID_TIPO_ELEMENTO
      AND ELEMENTO.ID_ELEMENTO          = CN_ID_ELEMENTO;
    CURSOR C_GET_ENLACE_INTERFACE(CV_ID_ELEMENTO NUMBER, CV_NOMBRE_INTERFACE_ELEMENTO VARCHAR2)
    IS
      SELECT ID_INTERFACE_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
      WHERE ELEMENTO_ID             = CV_ID_ELEMENTO
      AND NOMBRE_INTERFACE_ELEMENTO = CV_NOMBRE_INTERFACE_ELEMENTO
      AND (ESTADO                   = 'connected'
      OR ESTADO                     = 'not connect');
    CURSOR C_GET_CLASE_TIPO_MEDIO_COUNT(CV_CLASE_TIPO_MEDIO VARCHAR2)
    IS
      SELECT COUNT(1) COUNT_DATA
      FROM DB_INFRAESTRUCTURA.ADMI_CLASE_TIPO_MEDIO C
      WHERE ESTADO                  = LV_ESTADO_ACTIVO
      AND C.NOMBRE_CLASE_TIPO_MEDIO = TRIM(CV_CLASE_TIPO_MEDIO);
    CURSOR C_GET_BUFFER_COUNT(CV_BUFFER VARCHAR2)
    IS
      SELECT COUNT(1) COUNT_DATA
      FROM DB_INFRAESTRUCTURA.ADMI_BUFFER BUFFER_ELEMENTO
      WHERE BUFFER_ELEMENTO.ESTADO = LV_ESTADO_ACTIVO
      AND BUFFER_ELEMENTO.NUMERO_BUFFER
        ||','
        ||BUFFER_ELEMENTO.COLOR_BUFFER = TRIM(CV_BUFFER);
    CURSOR C_GET_HILO_COUNT(CV_HILO VARCHAR2)
    IS
      SELECT COUNT(1) COUNT_DATA
      FROM DB_INFRAESTRUCTURA.ADMI_HILO HILO
      WHERE HILO.ESTADO = LV_ESTADO_ACTIVO
      AND HILO.NUMERO_HILO
        ||','
        ||HILO.COLOR_HILO = TRIM(CV_HILO);
    CURSOR C_GET_COUNT_SPLITE_COMA(CV_CADENA VARCHAR2)
    IS
      SELECT LENGTH(CV_CADENA) - LENGTH(REPLACE(CV_CADENA,',')) COUNT_PIPE
      FROM DUAL;
    CURSOR LC_GETVALORESPARAMSGENERAL(CV_NOMBREPARAMETRO DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      SELECT DET.VALOR1,
        DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = CV_NOMBREPARAMETRO
      AND CAB.ESTADO             = LV_ESTADO_ACTIVO
      AND DET.ESTADO             = LV_ESTADO_ACTIVO;
    CURSOR C_GET_EXISTS_SCOPE(CV_NOMBRE_SCOPE VARCHAR2, CN_MIGRACION_CAB NUMBER)
    IS
    SELECT COUNT(NOMBRE_SCOPE) AS COUNT_REG
        FROM 
        (SELECT ID_SUBRED,
          (SELECT EEE.DETALLE_VALOR
          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO EEE
          WHERE REF_DETALLE_ELEMENTO_ID=REFERENCIA_DETALLE_ELEMENTO_ID
          AND DETALLE_NOMBRE           = 'SCOPE'
          ) AS NOMBRE_SCOPE,
          (SELECT RRR.DETALLE_VALOR
          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO RRR
          WHERE REF_DETALLE_ELEMENTO_ID=REFERENCIA_DETALLE_ELEMENTO_ID
          AND DETALLE_NOMBRE           = 'TIPO SCOPE'
          ) AS TIPO_SCOPE,
          IP_SCOPE_INI,
          IP_SCOPE_FIN,
          ESTADO_RED,
          (SELECT NOMBRE_POLICY FROM DB_INFRAESTRUCTURA.ADMI_POLICY WHERE ID_POLICY=POLICESCOPE
          ) AS NOMBRE_POLICY
        FROM
          (SELECT ISD.ID_SUBRED AS ID_SUBRED,
            ISD.ESTADO          AS ESTADO_RED,
            ISD.IP_INICIAL      AS IP_SCOPE_INI,
            ISD.IP_FINAL        AS IP_SCOPE_FIN,
            ISD.NOTIFICACION    AS POLICESCOPE,
            (SELECT WWW.ID_DETALLE_ELEMENTO
            FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO WWW
            WHERE WWW.ELEMENTO_ID=IDE.ELEMENTO_ID
            AND WWW.DETALLE_VALOR= TO_CHAR(ISD.ID_SUBRED)
            ) AS REFERENCIA_DETALLE_ELEMENTO_ID
          FROM DB_INFRAESTRUCTURA.INFO_SUBRED ISD,
            DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE
          WHERE IDE.ELEMENTO_ID  IN (SELECT ELEMENTO_ID
                                         FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO 
                                        WHERE DETALLE_NOMBRE = 'SCOPE'
                                        AND DETALLE_VALOR = CV_NOMBRE_SCOPE
                                        GROUP BY ELEMENTO_ID)
          AND IDE.DETALLE_NOMBRE IN ('SUBRED')
          AND IDE.DETALLE_VALOR   = ISD.ID_SUBRED
          )
        )
        WHERE ESTADO_RED    = LV_ESTADO_ACTIVO
        AND NOMBRE_SCOPE IS NOT NULL
        AND NOMBRE_SCOPE = CV_NOMBRE_SCOPE;
    CURSOR C_GET_MIGRACION_CAB
    IS
      SELECT ID_MIGRACION_CAB
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
      WHERE TIPO = 'ArchivosMigracion'
      AND ESTADO = 'Pendiente';
  TYPE REG_FILES
IS
  RECORD
  (
    ELEMENTO  VARCHAR2(50),
    CONTENIDO VARCHAR2(4000),
    LINEA     NUMBER,
    ESTADO    VARCHAR2(50) );
TYPE TAB_REG_FILES
IS
  TABLE OF REG_FILES INDEX BY PLS_INTEGER;
  LB_TAB_REG_FILES TAB_REG_FILES;
  LB_TAB_REG_DUP_FILES TAB_REG_FILES;
  LB_TAB_REG_SPLITTERS TAB_REG_FILES;
  LB_TAB_REG_OLTS TAB_REG_FILES;
  LB_TAB_REG_ENLACE TAB_REG_FILES;
  LC_GET_ARCHIVOS_CARGADOS C_GET_ARCHIVOS_CARGADOS%ROWTYPE;
  LR_REGGETVALORESPARAMSXVALOR1 LC_GETVALORESPARAMSXVALOR1%ROWTYPE;
  LR_REGGETDATAARCHIVOCSV LC_GETDATAARCHIVOCSV%ROWTYPE;
  LC_GET_PARAM_NUM_PIPE C_GET_PARAM_NUM_PIPE%ROWTYPE;
  LC_COUNT_PIPE_LINEA C_COUNT_PIPE_LINEA%ROWTYPE;
  LC_GET_NUM_ELEMENTO C_GET_NUM_ELEMENTO%ROWTYPE;
  LC_GET_INFO_ELEMENTO C_GET_INFO_ELEMENTO%ROWTYPE;
  LC_GET_INTERFACE_ELEMENTO C_GET_INTERFACE_ELEMENTO%ROWTYPE;
  LC_GET_TIPO_NOMBRE_ELEMENTO C_GET_TIPO_NOMBRE_ELEMENTO%ROWTYPE;
  LC_GET_ENLACE_INTERFACE C_GET_ENLACE_INTERFACE%ROWTYPE;
  LR_REGGETVALORESPARAMSGENERAL LC_GETVALORESPARAMSGENERAL%ROWTYPE;
  LV_MENSAJE                    VARCHAR2(4000);
  LV_FORMATO_URL_ARCHIVO_HTTPS  VARCHAR2(300);
  LV_FORMATO_URL_ARCHIVO_HTTP   VARCHAR2(300);
  LV_URL_NFS_ARCHIVO_CSV        VARCHAR2(1500);
  LV_URL_NFS_HTTP_ARCHIVO_CSV   VARCHAR2(1500);
  LV_NOMBREPARAMMAPEOURLHTTPS   VARCHAR2(24) := 'MAPEO_URLS_HTTPS_A_HTTP';
  LV_VALOR1URLMSGUARDARARCHIVOS VARCHAR2(24) := 'URL_MS_GUARDAR_ARCHIVOS';
  LV_CONTENIDO_LINEA            VARCHAR2(4000);
  LV_CAMPO_VACIO                VARCHAR2(2000);
  LUH_HTTP_REQUEST UTL_HTTP.REQ;
  LUH_HTTP_RESPONSE UTL_HTTP.RESP;
  LBL_CSV CLOB;
  LE_EXCEPTION            EXCEPTION;
  LN_LINEA                NUMBER := 0;
  LN_ITERATOR             NUMBER := 0;
  LN_REG_DUP              NUMBER := 0;
  LN_COUNT_ERR            NUMBER := 0;
  LV_NOMBRE_DOCUMENTO     VARCHAR2(150);
  LV_ELEMENTO_ORIGEN      VARCHAR2(150);
  LV_ELEMENTO_ORIGEN_ANT  VARCHAR2(150);
  LV_ELEMENTO_DESTINO_ANT VARCHAR2(150);
  LV_INTERFACE_ORIGEN     VARCHAR2(150);
  LV_ELEMENTO_DESTINO     VARCHAR2(150);
  LV_INTERFACE_DESTINO    VARCHAR2(150);
  LN_EXISTE_ELEMENTO      NUMBER;
  LV_ESTADO_CONNECTED     VARCHAR2(25) := 'connected';
  LV_ESTADO_NOT_CONNECTED VARCHAR2(25) := 'not connect';
  LV_ELEMENTO_OLT         VARCHAR2(50) := 'OLT';
  LV_ELEMENTO_SPLITTER    VARCHAR2(50) := 'SPLITTER';
  LV_ELEMENTO_ENLACE      VARCHAR2(50) := 'ENLACE';
  LV_ELEMENTO_SCOPE       VARCHAR2(50) := 'SCOPE';
  LT_TCAMPOSXLINEACSV DB_INFRAESTRUCTURA.INKG_TYPES.LT_ARRAYOFVARCHAR;
  LT_TCAMPOSXLINEACSVDUP DB_INFRAESTRUCTURA.INKG_TYPES.LT_ARRAYOFVARCHAR;
  LF_ARCHIVOPROCESOMASIVO UTL_FILE.FILE_TYPE;
  LV_DIRECTORIOBASEDATOS     VARCHAR2(50);
  LV_RUTADIRECTORIOBASEDATOS VARCHAR2(300);
  LV_NOMBREARCHIVOCORREO     VARCHAR2(500);
  LV_NOMBREARCHIVOCORREOZIP  VARCHAR2(500);
  LV_GZIP                    VARCHAR2(500);
  LV_NOMBREPARAMETRODIRCSV   VARCHAR2(100) := 'DIRECTORIO_BD_ARCHIVOS_TEMPORALES';
  LN_MIGRACION_CAB           NUMBER;
  LV_TIPO_PROCESO_ERR        VARCHAR2(50)  := 'ValidacionArchivo';
  LV_ESTADO_ERR              VARCHAR2(50)  := 'Error';
  LV_USR_CREACION            VARCHAR2(100) := PV_USRCREACION;
  LV_MENSAJE_ERR             VARCHAR2(2000);
  LR_GETALIASPLANTILLACORREO DB_FINANCIERO.FNKG_TYPES.LR_ALIASPLANTILLA;
  LV_PLANTILLA               VARCHAR2(4000);
  LV_PARAMETRO_NOTIFICACINES VARCHAR2(100) := 'MIGRA_NOTIFICACIONES';
  LV_NOTI_ERR                VARCHAR2(100) := 'NOTIFICACIONES_ERR';
  LV_OLT_ASUNTO              VARCHAR2(2000);
  LV_REMITENTE               VARCHAR2(1000);
  LV_ASUNTO                  VARCHAR2(1000);
  CURSOR C_GET_REMITENTE_ASUNTO (CV_PARAMETRO_REPORTE VARCHAR2)
  IS
    SELECT VALOR3 REMITENTE,
      VALOR4 ASUNTO
    FROM DB_GENERAL.ADMI_PARAMETRO_DET
    WHERE PARAMETRO_ID IN
      (SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
      AND ESTADO             = LV_ESTADO_ACTIVO
      )
  AND VALOR1 = LV_PARAMETRO_NOTIFICACINES
  AND VALOR2 = CV_PARAMETRO_REPORTE;
  LC_GET_REMITENTE_ASUNTO C_GET_REMITENTE_ASUNTO%ROWTYPE;
  CURSOR LC_GETCONFIGNFSMIGRAAD
  IS
    SELECT TO_CHAR(CODIGO_APP) AS CODIGO_APP,
      TO_CHAR(CODIGO_PATH)     AS CODIGO_PATH
    FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS
    WHERE APLICACION ='TelcosWeb'
    AND SUBMODULO    = 'MigracionOltAltaDensidad'
    AND EMPRESA      ='MD';
  LV_RESPUESTAGUARDARARCHIVO VARCHAR2(4000);
  LV_URLMICROSERVICIONFS     VARCHAR2(500);
  LV_CODIGOAPPCORTEMASIVO    VARCHAR2(20);
  LV_CODIGOPATHCORTEMASIVO   VARCHAR2(20);
  LN_CODEGUARDARARCHIVO      NUMBER;
  LN_COUNTARCHIVOSGUARDADOS  NUMBER;
  LV_PATHGUARDARARCHIVO      VARCHAR2(4000);
  LN_IDDOCUMENTO DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
  LR_GETCONFIGNFSMIGRAAD LC_GETCONFIGNFSMIGRAAD%ROWTYPE;
  LV_NOMBREPARAMURLMICRONFS VARCHAR2(33) := 'URL_MICROSERVICIO_NFS';
  LE_EXCEPTION_NFS          EXCEPTION;
  LN_IDX_TAB_REG_FILES      NUMBER;
  LN_IDX_REG_FILES_OLT  NUMBER;
  LN_IDX_REG_FILES_ENLACE  NUMBER;
  LN_IDX_TAB_REG_SPLITTERS  NUMBER;
  LN_IDX_TAB_REG_DUP_FILES  NUMBER;
  LN_DUP_INTER_INI  NUMBER;
  LN_DUP_INTER_FIN  NUMBER;
BEGIN
  OPEN C_GET_MIGRACION_CAB;
  FETCH C_GET_MIGRACION_CAB INTO LN_MIGRACION_CAB;
  CLOSE C_GET_MIGRACION_CAB;
  IF LN_MIGRACION_CAB IS NULL THEN
    LV_MENSAJE        := 'No se ha podido encontrar cabecera de migracion olt alta densidad.';
    RAISE LE_EXCEPTION;
  END IF;
  OPEN LC_GETVALORESPARAMSXVALOR1(LV_NOMBREPARAMMAPEOURLHTTPS, LV_VALOR1URLMSGUARDARARCHIVOS);
  FETCH LC_GETVALORESPARAMSXVALOR1 INTO LR_REGGETVALORESPARAMSXVALOR1;
  CLOSE LC_GETVALORESPARAMSXVALOR1;
  LV_FORMATO_URL_ARCHIVO_HTTPS    := LR_REGGETVALORESPARAMSXVALOR1.VALOR2;
  LV_FORMATO_URL_ARCHIVO_HTTP     := LR_REGGETVALORESPARAMSXVALOR1.VALOR3;
  IF LV_FORMATO_URL_ARCHIVO_HTTPS IS NULL OR LV_FORMATO_URL_ARCHIVO_HTTP IS NULL THEN
    LV_MENSAJE                    := 'No se ha podido obtener el mapeo para la url del archivo';
    RAISE LE_EXCEPTION;
  END IF;
  OPEN LC_GETVALORESPARAMSGENERAL(LV_NOMBREPARAMETRODIRCSV);
  FETCH LC_GETVALORESPARAMSGENERAL INTO LR_REGGETVALORESPARAMSGENERAL;
  CLOSE LC_GETVALORESPARAMSGENERAL;
  LV_DIRECTORIOBASEDATOS     := LR_REGGETVALORESPARAMSGENERAL.VALOR1;
  LV_RUTADIRECTORIOBASEDATOS := LR_REGGETVALORESPARAMSGENERAL.VALOR2;
  OPEN C_GET_REMITENTE_ASUNTO(LV_NOTI_ERR);
  FETCH C_GET_REMITENTE_ASUNTO INTO LC_GET_REMITENTE_ASUNTO;
  CLOSE C_GET_REMITENTE_ASUNTO;
  LV_REMITENTE    := LC_GET_REMITENTE_ASUNTO.REMITENTE;
  LV_ASUNTO       := LC_GET_REMITENTE_ASUNTO.ASUNTO;
  IF LV_REMITENTE IS NULL OR LV_ASUNTO IS NULL THEN
    LV_MENSAJE    := 'No se ha podido obtener el remitente y/o el asunto del correo con el archivo adjunto de cambio de plan masivo';
    RAISE LE_EXCEPTION;
  END IF;
  --TEC_REPORTE_PREV
  LR_REGGETVALORESPARAMSGENERAL := NULL;
  OPEN LC_GETVALORESPARAMSGENERAL(LV_NOMBREPARAMURLMICRONFS);
  FETCH LC_GETVALORESPARAMSGENERAL INTO LR_REGGETVALORESPARAMSGENERAL;
  CLOSE LC_GETVALORESPARAMSGENERAL;
  LV_URLMICROSERVICIONFS    := LR_REGGETVALORESPARAMSGENERAL.VALOR1;
  IF LV_URLMICROSERVICIONFS IS NULL THEN
    LV_MENSAJE              := 'No se ha podido obtener la URL del NFS';
    RAISE LE_EXCEPTION;
  END IF;
  OPEN LC_GETCONFIGNFSMIGRAAD;
  FETCH LC_GETCONFIGNFSMIGRAAD INTO LR_GETCONFIGNFSMIGRAAD;
  CLOSE LC_GETCONFIGNFSMIGRAAD;
  LV_CODIGOAPPCORTEMASIVO    := LR_GETCONFIGNFSMIGRAAD.CODIGO_APP;
  LV_CODIGOPATHCORTEMASIVO   := LR_GETCONFIGNFSMIGRAAD.CODIGO_PATH;
  IF LV_CODIGOAPPCORTEMASIVO IS NULL OR LV_CODIGOPATHCORTEMASIVO IS NULL THEN
    LV_MENSAJE               := 'No se ha podido obtener la configuraci¿n de la ruta NFS';
    RAISE LE_EXCEPTION;
  END IF;
  FOR LC_GET_ARCHIVOS_CARGADOS IN C_GET_ARCHIVOS_CARGADOS
  LOOP
    LN_LINEA := 0;
    OPEN LC_GETDATAARCHIVOCSV(LC_GET_ARCHIVOS_CARGADOS.ID_DOCUMENTO);
    FETCH LC_GETDATAARCHIVOCSV INTO LR_REGGETDATAARCHIVOCSV;
    CLOSE LC_GETDATAARCHIVOCSV;
    LV_URL_NFS_ARCHIVO_CSV      := LR_REGGETDATAARCHIVOCSV.UBICACION_FISICA_DOCUMENTO;
    LV_URL_NFS_HTTP_ARCHIVO_CSV := REPLACE(LV_URL_NFS_ARCHIVO_CSV, LV_FORMATO_URL_ARCHIVO_HTTPS, LV_FORMATO_URL_ARCHIVO_HTTP);
    DBMS_LOB.CREATETEMPORARY(LBL_CSV, FALSE);
    LUH_HTTP_REQUEST  := UTL_HTTP.BEGIN_REQUEST(LV_URL_NFS_HTTP_ARCHIVO_CSV);
    LUH_HTTP_RESPONSE := UTL_HTTP.GET_RESPONSE(LUH_HTTP_REQUEST);
    BEGIN
      LOOP
        UTL_HTTP.READ_LINE(LUH_HTTP_RESPONSE, LBL_CSV);
        LV_CONTENIDO_LINEA                      := '';
        LV_CONTENIDO_LINEA                      := REPLACE(REPLACE(LBL_CSV, CHR(10), ''), CHR(13), '');
        LN_LINEA                                := LN_LINEA + 1;
        LB_TAB_REG_FILES(LN_ITERATOR).ELEMENTO  := LC_GET_ARCHIVOS_CARGADOS.ARCHIVO;
        LB_TAB_REG_FILES(LN_ITERATOR).CONTENIDO := LV_CONTENIDO_LINEA;
        LB_TAB_REG_FILES(LN_ITERATOR).LINEA     := LN_LINEA;
        LB_TAB_REG_FILES(LN_ITERATOR).ESTADO    := 'Registrado';
        LN_ITERATOR                             := LN_ITERATOR + 1;
      END LOOP;
      UTL_HTTP.END_RESPONSE(LUH_HTTP_RESPONSE);
    EXCEPTION
    WHEN UTL_HTTP.END_OF_BODY THEN
      UTL_HTTP.END_RESPONSE(LUH_HTTP_RESPONSE);
    END;
  END LOOP;
  IF LN_ITERATOR = 0 THEN
    LV_MENSAJE  := 'No se han encontrado registros en los archivos de migracion.';
    RAISE LE_EXCEPTION;
  END IF;
  LN_IDX_TAB_REG_FILES        := LB_TAB_REG_FILES.FIRST;
  WHILE (LN_IDX_TAB_REG_FILES IS NOT NULL)
  LOOP
    IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_OLT AND LV_OLT_ASUNTO IS NULL THEN
      LT_TCAMPOSXLINEACSV                             := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO, '|');
      LV_ELEMENTO_ORIGEN                              := LT_TCAMPOSXLINEACSV(1);
      LV_OLT_ASUNTO                                   := LV_ELEMENTO_ORIGEN;
    END IF;
    IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO      = LV_ELEMENTO_SPLITTER THEN
      LB_TAB_REG_SPLITTERS(LN_IDX_TAB_REG_FILES).ELEMENTO  := LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO;
      LB_TAB_REG_SPLITTERS(LN_IDX_TAB_REG_FILES).CONTENIDO := LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO;
      LB_TAB_REG_SPLITTERS(LN_IDX_TAB_REG_FILES).LINEA     := LN_IDX_TAB_REG_FILES + 1;
      LB_TAB_REG_SPLITTERS(LN_IDX_TAB_REG_FILES).ESTADO    := 'Registrado';
    END IF;
    LN_IDX_TAB_REG_FILES := LB_TAB_REG_FILES.NEXT(LN_IDX_TAB_REG_FILES);
  END LOOP;

  LN_IDX_REG_FILES_OLT := LB_TAB_REG_FILES.FIRST;
  WHILE (LN_IDX_REG_FILES_OLT IS NOT NULL)
  LOOP
    IF LB_TAB_REG_FILES(LN_IDX_REG_FILES_OLT).ELEMENTO      = LV_ELEMENTO_OLT THEN
      LB_TAB_REG_OLTS(LN_IDX_REG_FILES_OLT).ELEMENTO  := LB_TAB_REG_FILES(LN_IDX_REG_FILES_OLT).ELEMENTO;
      LB_TAB_REG_OLTS(LN_IDX_REG_FILES_OLT).CONTENIDO := LB_TAB_REG_FILES(LN_IDX_REG_FILES_OLT).CONTENIDO;
      LB_TAB_REG_OLTS(LN_IDX_REG_FILES_OLT).LINEA     := LN_IDX_REG_FILES_OLT + 1;
      LB_TAB_REG_OLTS(LN_IDX_REG_FILES_OLT).ESTADO    := 'Registrado';
    END IF;
    LN_IDX_REG_FILES_OLT := LB_TAB_REG_FILES.NEXT(LN_IDX_REG_FILES_OLT);
  END LOOP;

  LN_IDX_REG_FILES_ENLACE := LB_TAB_REG_FILES.FIRST;
  WHILE (LN_IDX_REG_FILES_ENLACE IS NOT NULL)
  LOOP
    IF LB_TAB_REG_FILES(LN_IDX_REG_FILES_ENLACE).ELEMENTO      = LV_ELEMENTO_ENLACE THEN
      LB_TAB_REG_ENLACE(LN_IDX_REG_FILES_ENLACE).ELEMENTO  := LB_TAB_REG_FILES(LN_IDX_REG_FILES_ENLACE).ELEMENTO;
      LB_TAB_REG_ENLACE(LN_IDX_REG_FILES_ENLACE).CONTENIDO := LB_TAB_REG_FILES(LN_IDX_REG_FILES_ENLACE).CONTENIDO;
      LB_TAB_REG_ENLACE(LN_IDX_REG_FILES_ENLACE).LINEA     := LN_IDX_REG_FILES_ENLACE + 1;
      LB_TAB_REG_ENLACE(LN_IDX_REG_FILES_ENLACE).ESTADO    := 'Registrado';
    END IF;
    LN_IDX_REG_FILES_ENLACE := LB_TAB_REG_FILES.NEXT(LN_IDX_REG_FILES_ENLACE);
  END LOOP;


  LV_ELEMENTO_ORIGEN      := NULL;
  LV_NOMBREARCHIVOCORREO  := 'REPORTE_ERRORES_ARCHIVOS_MIGRACION_OLT_'||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')||'.csv';
  LF_ARCHIVOPROCESOMASIVO := UTL_FILE.FOPEN(LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREO, 'w', 5000);
  UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,'NOMBRE_ARCHIVO|LOG_ERROR|LINEA_ERROR|COLUMNA_ERROR');
  LB_TAB_REG_DUP_FILES        := LB_TAB_REG_FILES;
  LN_IDX_TAB_REG_FILES        := LB_TAB_REG_FILES.FIRST;
  WHILE (LN_IDX_TAB_REG_FILES IS NOT NULL)
  LOOP
    OPEN C_GET_NOMBRE_ARCHIVO(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO);
    FETCH C_GET_NOMBRE_ARCHIVO INTO LV_NOMBRE_DOCUMENTO;
    CLOSE C_GET_NOMBRE_ARCHIVO;
    LN_REG_DUP                      := 0;
    LN_IDX_TAB_REG_DUP_FILES        := LB_TAB_REG_DUP_FILES.FIRST;
    WHILE (LN_IDX_TAB_REG_DUP_FILES IS NOT NULL)
    LOOP
      IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO = LB_TAB_REG_DUP_FILES(LN_IDX_TAB_REG_DUP_FILES).CONTENIDO THEN
        LN_REG_DUP                                       := LN_REG_DUP + 1;
      END IF;
      LN_IDX_TAB_REG_DUP_FILES := LB_TAB_REG_DUP_FILES.NEXT(LN_IDX_TAB_REG_DUP_FILES);
    END LOOP;
    IF LN_REG_DUP > 1 THEN
      LV_MENSAJE := LV_NOMBRE_DOCUMENTO||'|'||'REGISTRO DUPLICADO'|| '|'||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|0';
      UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
      LN_COUNT_ERR := LN_COUNT_ERR + 1;
      P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ESTADO := 'Error';
    END IF;
    LC_GET_PARAM_NUM_PIPE := NULL;
    OPEN C_GET_PARAM_NUM_PIPE(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO);
    FETCH C_GET_PARAM_NUM_PIPE INTO LC_GET_PARAM_NUM_PIPE;
    CLOSE C_GET_PARAM_NUM_PIPE;
    LC_COUNT_PIPE_LINEA := NULL;
    OPEN C_COUNT_PIPE_LINEA(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO);
    FETCH C_COUNT_PIPE_LINEA INTO LC_COUNT_PIPE_LINEA;
    CLOSE C_COUNT_PIPE_LINEA;
    IF LC_GET_PARAM_NUM_PIPE.NUM_PIPE != LC_COUNT_PIPE_LINEA.COUNT_PIPE THEN
      LV_MENSAJE                      := LV_NOMBRE_DOCUMENTO|| '|' ||'FORMATO DE COLUMNAS DIFERENTE - SE HAN ENCONTRADO MAS CAMPOS EN EL REGISTRO'|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|'||LC_COUNT_PIPE_LINEA.COUNT_PIPE;
      UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
      LN_COUNT_ERR := LN_COUNT_ERR + 1;
      P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ESTADO := 'Error';
    END IF;
    LV_CAMPO_VACIO := NULL;
    OPEN C_GET_CAMPO_VACIO(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO);
    FETCH C_GET_CAMPO_VACIO INTO LV_CAMPO_VACIO;
    CLOSE C_GET_CAMPO_VACIO;
    IF LV_CAMPO_VACIO IS NOT NULL THEN
      LV_MENSAJE      := LV_NOMBRE_DOCUMENTO|| '|' || LV_CAMPO_VACIO || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|0';
      UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
      LN_COUNT_ERR := LN_COUNT_ERR + 1;
      P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ESTADO := 'Error';
    END IF;
    IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ESTADO <> 'Error' THEN
    IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_OLT THEN
      LT_TCAMPOSXLINEACSV                             := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO, '|');
      LV_ELEMENTO_ORIGEN                              := LT_TCAMPOSXLINEACSV(1);
      LV_INTERFACE_ORIGEN                             := LT_TCAMPOSXLINEACSV(2);
      LV_ELEMENTO_DESTINO                             := LT_TCAMPOSXLINEACSV(3);
      LV_INTERFACE_DESTINO                            := LT_TCAMPOSXLINEACSV(4);

      LN_IDX_REG_FILES_OLT                      := LB_TAB_REG_OLTS.FIRST;
      LN_DUP_INTER_INI := 0;
      LN_DUP_INTER_FIN := 0;
      WHILE (LN_IDX_REG_FILES_OLT IS NOT NULL)
      LOOP
        LT_TCAMPOSXLINEACSVDUP   := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_OLTS(LN_IDX_REG_FILES_OLT).CONTENIDO, '|');
        BEGIN
            IF LV_ELEMENTO_ORIGEN = LT_TCAMPOSXLINEACSVDUP(1) AND LV_INTERFACE_ORIGEN = LT_TCAMPOSXLINEACSVDUP(2) THEN
                LN_DUP_INTER_INI := LN_DUP_INTER_INI + 1;
            END IF;
            IF LV_ELEMENTO_DESTINO = LT_TCAMPOSXLINEACSVDUP(3) AND LV_INTERFACE_DESTINO = LT_TCAMPOSXLINEACSVDUP(4) THEN
                LN_DUP_INTER_FIN := LN_DUP_INTER_FIN + 1;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_UPLOAD_CSV_MIGRACION_OLT', SUBSTR(SQLCODE || ' -ERROR- ' || 'ERROR DUPLICIDAD OLT' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,4000), LV_USR_CREACION, SYSDATE, '127.0.0.0');
        END;
        LN_IDX_REG_FILES_OLT := LB_TAB_REG_OLTS.NEXT(LN_IDX_REG_FILES_OLT);
      END LOOP;

      IF LN_DUP_INTER_INI > 1 THEN
          LV_MENSAJE                          := LV_NOMBRE_DOCUMENTO|| '|' || 'LA INTERFACE ORIGEN '|| LV_INTERFACE_ORIGEN || ' SE ENCUENTRA REPETIDA '|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|3';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
          LN_DUP_INTER_INI := 0;
      END IF;

      IF LN_DUP_INTER_FIN > 1 THEN
          LV_MENSAJE                          := LV_NOMBRE_DOCUMENTO|| '|' || 'LA INTERFACE DESTINO '|| LV_INTERFACE_ORIGEN || ' SE ENCUENTRA REPETIDA '|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|5';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
          LN_DUP_INTER_FIN := 0;
      END IF;

      OPEN C_GET_NUM_ELEMENTO(LV_ELEMENTO_ORIGEN);
      FETCH C_GET_NUM_ELEMENTO INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_NUM_ELEMENTO;
      IF LN_EXISTE_ELEMENTO = 0 THEN
        LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE EL ELEMENTO OLT ORIGEN '|| LV_ELEMENTO_ORIGEN || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|2';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSIF LN_EXISTE_ELEMENTO = 2 THEN
        LV_MENSAJE            := LV_NOMBRE_DOCUMENTO|| '|' || 'ELEMENTO OLT ORIGEN REPETIDO '|| LV_ELEMENTO_ORIGEN || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|2';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSE
        LC_GET_INFO_ELEMENTO      := NULL;
        LC_GET_INTERFACE_ELEMENTO := NULL;
        OPEN C_GET_INFO_ELEMENTO(LV_ELEMENTO_ORIGEN);
        FETCH C_GET_INFO_ELEMENTO INTO LC_GET_INFO_ELEMENTO;
        CLOSE C_GET_INFO_ELEMENTO;
        OPEN C_GET_INTERFACE_ELEMENTO(LC_GET_INFO_ELEMENTO.ID_ELEMENTO, LV_INTERFACE_ORIGEN, LV_ESTADO_CONNECTED);
        FETCH C_GET_INTERFACE_ELEMENTO INTO LC_GET_INTERFACE_ELEMENTO;
        CLOSE C_GET_INTERFACE_ELEMENTO;
        IF LC_GET_INTERFACE_ELEMENTO.COUNT_REG = 0 THEN
          LV_MENSAJE                          := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE LA INTERFACE ORIGEN '|| LV_INTERFACE_ORIGEN || ' O NO SE ENCUENTRA EN ESTADO '||LV_ESTADO_CONNECTED|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|3';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        END IF;
      END IF;
      OPEN C_GET_NUM_ELEMENTO(LV_ELEMENTO_DESTINO);
      FETCH C_GET_NUM_ELEMENTO INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_NUM_ELEMENTO;
      IF LN_EXISTE_ELEMENTO = 0 THEN
        LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE EL ELEMENTO OLT DESTINO '|| LV_ELEMENTO_DESTINO || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|4';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSIF LN_EXISTE_ELEMENTO = 2 THEN
        LV_MENSAJE            := LV_NOMBRE_DOCUMENTO|| '|' || 'ELEMENTO OLT DESTINO REPETIDO '|| LV_ELEMENTO_DESTINO || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|4';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSE
        LC_GET_INFO_ELEMENTO      := NULL;
        LC_GET_INTERFACE_ELEMENTO := NULL;
        OPEN C_GET_INFO_ELEMENTO(LV_ELEMENTO_DESTINO);
        FETCH C_GET_INFO_ELEMENTO INTO LC_GET_INFO_ELEMENTO;
        CLOSE C_GET_INFO_ELEMENTO;
        OPEN C_GET_INTERFACE_ELEMENTO(LC_GET_INFO_ELEMENTO.ID_ELEMENTO, LV_INTERFACE_DESTINO, LV_ESTADO_NOT_CONNECTED);
        FETCH C_GET_INTERFACE_ELEMENTO INTO LC_GET_INTERFACE_ELEMENTO;
        CLOSE C_GET_INTERFACE_ELEMENTO;
        IF LC_GET_INTERFACE_ELEMENTO.COUNT_REG = 0 THEN
          LV_MENSAJE                          := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE LA INTERFACE DESTINO '|| LV_INTERFACE_DESTINO ||' O NO SE ENCUENTRA EN ESTADO '||LV_ESTADO_NOT_CONNECTED|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|5';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        END IF;
      END IF;
    END IF;
    IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_SPLITTER THEN
      LT_TCAMPOSXLINEACSV                             := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO, '|');
      LV_ELEMENTO_ORIGEN                              := LT_TCAMPOSXLINEACSV(0);
      OPEN C_GET_NUM_ELEMENTO(LV_ELEMENTO_ORIGEN);
      FETCH C_GET_NUM_ELEMENTO INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_NUM_ELEMENTO;
      IF LN_EXISTE_ELEMENTO = 0 THEN
        LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE EL ELEMENTO SPLITTER ORIGEN '|| LV_ELEMENTO_ORIGEN || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|1';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSIF LN_EXISTE_ELEMENTO = 2 THEN
        LV_MENSAJE            := LV_NOMBRE_DOCUMENTO|| '|' || 'ELEMENTO SPLITTER ORIGEN REPETIDO '|| LV_ELEMENTO_ORIGEN || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|1';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      END IF;
    END IF;
    IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_ENLACE THEN
      LT_TCAMPOSXLINEACSV                             := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO, '|');
      LV_ELEMENTO_ORIGEN                              := LT_TCAMPOSXLINEACSV(1);
      LV_ELEMENTO_DESTINO                             := LT_TCAMPOSXLINEACSV(7);
      LV_ELEMENTO_ORIGEN_ANT                          := NULL;
      LV_ELEMENTO_DESTINO_ANT                         := NULL;

      LN_IDX_REG_FILES_ENLACE                      := LB_TAB_REG_ENLACE.FIRST;
      LN_DUP_INTER_INI := 0;
      LN_DUP_INTER_FIN := 0;
      WHILE (LN_IDX_REG_FILES_ENLACE IS NOT NULL)
      LOOP
        LT_TCAMPOSXLINEACSVDUP   := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_ENLACE(LN_IDX_REG_FILES_ENLACE).CONTENIDO, '|');
        BEGIN
            IF LV_ELEMENTO_ORIGEN = LT_TCAMPOSXLINEACSVDUP(1) AND LT_TCAMPOSXLINEACSV(2) = LT_TCAMPOSXLINEACSVDUP(2) THEN
                LN_DUP_INTER_INI := LN_DUP_INTER_INI + 1;
            END IF;
            IF LV_ELEMENTO_DESTINO = LT_TCAMPOSXLINEACSVDUP(7) AND LT_TCAMPOSXLINEACSV(8) = LT_TCAMPOSXLINEACSVDUP(8) THEN
                LN_DUP_INTER_FIN := LN_DUP_INTER_FIN + 1;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_UPLOAD_CSV_MIGRACION_OLT', SUBSTR(SQLCODE || ' -ERROR- ' || 'ERROR DUPLICIDAD ENLACE ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,4000), LV_USR_CREACION, SYSDATE, '127.0.0.0');
        END;
        LN_IDX_REG_FILES_ENLACE := LB_TAB_REG_ENLACE.NEXT(LN_IDX_REG_FILES_ENLACE);
      END LOOP;

      IF LN_DUP_INTER_INI > 1 THEN
          LV_MENSAJE                          := LV_NOMBRE_DOCUMENTO|| '|' || 'LA INTERFACE ORIGEN '|| LT_TCAMPOSXLINEACSV(2) || ' SE ENCUENTRA REPETIDA '|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|3';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
          LN_DUP_INTER_INI := 0;
      END IF;

      IF LN_DUP_INTER_FIN > 1 THEN
          LV_MENSAJE                          := LV_NOMBRE_DOCUMENTO|| '|' || 'LA INTERFACE DESTINO '|| LT_TCAMPOSXLINEACSV(8) || ' SE ENCUENTRA REPETIDA '|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|9';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
          LN_DUP_INTER_FIN := 0;
      END IF;

      IF LT_TCAMPOSXLINEACSV(0)                        = LV_ELEMENTO_SPLITTER OR LT_TCAMPOSXLINEACSV(6) = LV_ELEMENTO_SPLITTER THEN
        LN_IDX_TAB_REG_SPLITTERS                      := LB_TAB_REG_SPLITTERS.FIRST;
        WHILE (LN_IDX_TAB_REG_SPLITTERS               IS NOT NULL)
        LOOP
          LT_TCAMPOSXLINEACSVDUP   := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_SPLITTERS(LN_IDX_TAB_REG_SPLITTERS).CONTENIDO, '|');
          IF LT_TCAMPOSXLINEACSV(0) = LV_ELEMENTO_SPLITTER AND LV_ELEMENTO_ORIGEN = LT_TCAMPOSXLINEACSVDUP(1) THEN
            LV_ELEMENTO_ORIGEN_ANT := LT_TCAMPOSXLINEACSVDUP(0);
          END IF;
          IF LT_TCAMPOSXLINEACSV(6)  = LV_ELEMENTO_SPLITTER AND TRIM(LV_ELEMENTO_DESTINO) = TRIM(LT_TCAMPOSXLINEACSVDUP(1)) THEN
            LV_ELEMENTO_DESTINO_ANT := LT_TCAMPOSXLINEACSVDUP(0);
          END IF;
          LN_IDX_TAB_REG_SPLITTERS := LB_TAB_REG_SPLITTERS.NEXT(LN_IDX_TAB_REG_SPLITTERS);
        END LOOP;
        IF LV_ELEMENTO_ORIGEN_ANT IS NULL AND LT_TCAMPOSXLINEACSV(0) = LV_ELEMENTO_SPLITTER THEN
          LV_MENSAJE              := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE MAPEO ENTRE EL SPLITTER ORIGEN CON EL SPLITTER ANTERIOR '|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|8';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        ELSIF LV_ELEMENTO_ORIGEN_ANT IS NOT NULL THEN
          LV_ELEMENTO_ORIGEN         := LV_ELEMENTO_ORIGEN_ANT;
        END IF;
        IF LV_ELEMENTO_DESTINO_ANT IS NULL AND LT_TCAMPOSXLINEACSV(6) = LV_ELEMENTO_SPLITTER THEN
          LV_MENSAJE               := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE MAPEO ENTRE EL SPLITTER DESTINO CON EL SPLITTER ANTERIOR '|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|8';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        ELSIF LV_ELEMENTO_DESTINO_ANT IS NOT NULL THEN
          LV_ELEMENTO_DESTINO         := LV_ELEMENTO_DESTINO_ANT;
        END IF;
      END IF;
      OPEN C_GET_NUM_ELEMENTO(LV_ELEMENTO_ORIGEN);
      FETCH C_GET_NUM_ELEMENTO INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_NUM_ELEMENTO;
      IF LN_EXISTE_ELEMENTO = 0 THEN
        LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE EL ELEMENTO ORIGEN '|| LV_ELEMENTO_ORIGEN || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|2';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSIF LN_EXISTE_ELEMENTO = 2 THEN
        LV_MENSAJE            := LV_NOMBRE_DOCUMENTO|| '|' || 'ELEMENTO REPETIDO '|| LV_ELEMENTO_ORIGEN || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|2';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSE
        LC_GET_INFO_ELEMENTO := NULL;
        OPEN C_GET_INFO_ELEMENTO(LV_ELEMENTO_ORIGEN);
        FETCH C_GET_INFO_ELEMENTO INTO LC_GET_INFO_ELEMENTO;
        CLOSE C_GET_INFO_ELEMENTO;
        LC_GET_TIPO_NOMBRE_ELEMENTO := NULL;
        OPEN C_GET_TIPO_NOMBRE_ELEMENTO(LC_GET_INFO_ELEMENTO.ID_ELEMENTO);
        FETCH C_GET_TIPO_NOMBRE_ELEMENTO INTO LC_GET_TIPO_NOMBRE_ELEMENTO;
        CLOSE C_GET_TIPO_NOMBRE_ELEMENTO;
        IF LC_GET_TIPO_NOMBRE_ELEMENTO.NOMBRE_TIPO_ELEMENTO <> LT_TCAMPOSXLINEACSV(0) THEN
          LV_MENSAJE                                        := LV_NOMBRE_DOCUMENTO|| '|' || 'EL TIPO ELEMENTO ORIGEN DIFERENTE AL ESPECIFICADO '|| LT_TCAMPOSXLINEACSV(0) || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|1';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        END IF;
        LC_GET_ENLACE_INTERFACE := NULL;
        OPEN C_GET_ENLACE_INTERFACE(LC_GET_INFO_ELEMENTO.ID_ELEMENTO, LT_TCAMPOSXLINEACSV(2));
        FETCH C_GET_ENLACE_INTERFACE INTO LC_GET_ENLACE_INTERFACE;
        CLOSE C_GET_ENLACE_INTERFACE;
        IF LC_GET_ENLACE_INTERFACE.ID_INTERFACE_ELEMENTO IS NULL THEN
          LV_MENSAJE                                     := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE LA INTERFAZ ORIGEN ESPECIFICADA '|| LT_TCAMPOSXLINEACSV(2) || ' O NO SE ENCUENTRA EN ESTADO connected O not connect' || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|3';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        END IF;
      END IF;
      OPEN C_GET_CLASE_TIPO_MEDIO_COUNT(LT_TCAMPOSXLINEACSV(3));
      FETCH C_GET_CLASE_TIPO_MEDIO_COUNT INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_CLASE_TIPO_MEDIO_COUNT;
      IF LN_EXISTE_ELEMENTO = 0 THEN
        LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE VALOR DE CLASE TIPO MEDIO ESPECIFICADO '|| LT_TCAMPOSXLINEACSV(3) || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|4';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      END IF;
      OPEN C_GET_COUNT_SPLITE_COMA(LT_TCAMPOSXLINEACSV(4));
      FETCH C_GET_COUNT_SPLITE_COMA INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_COUNT_SPLITE_COMA;
      IF LN_EXISTE_ELEMENTO = 1 THEN
        OPEN C_GET_BUFFER_COUNT(LT_TCAMPOSXLINEACSV(4));
        FETCH C_GET_BUFFER_COUNT INTO LN_EXISTE_ELEMENTO;
        CLOSE C_GET_BUFFER_COUNT;
        IF LN_EXISTE_ELEMENTO = 0 THEN
          LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE VALOR DEL BUFFER ESPECIFICADO '|| LT_TCAMPOSXLINEACSV(4) || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|5';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        END IF;
      ELSE
        LV_MENSAJE := LV_NOMBRE_DOCUMENTO|| '|' || 'MAL FORMATO PARA EL VALOR DE BUFFER '|| LT_TCAMPOSXLINEACSV(4) || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|5';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      END IF;
      OPEN C_GET_COUNT_SPLITE_COMA(LT_TCAMPOSXLINEACSV(5));
      FETCH C_GET_COUNT_SPLITE_COMA INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_COUNT_SPLITE_COMA;
      IF LN_EXISTE_ELEMENTO = 1 THEN
        OPEN C_GET_HILO_COUNT(LT_TCAMPOSXLINEACSV(5));
        FETCH C_GET_HILO_COUNT INTO LN_EXISTE_ELEMENTO;
        CLOSE C_GET_HILO_COUNT;
        IF LN_EXISTE_ELEMENTO = 0 THEN
          LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE VALOR DEL HILO ESPECIFICADO '|| LT_TCAMPOSXLINEACSV(5) || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|6';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        END IF;
      ELSE
        LV_MENSAJE := LV_NOMBRE_DOCUMENTO|| '|' || 'MAL FORMATO PARA EL VALOR DE HILO '|| LT_TCAMPOSXLINEACSV(5) || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|6';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      END IF;
      OPEN C_GET_NUM_ELEMENTO(LV_ELEMENTO_DESTINO);
      FETCH C_GET_NUM_ELEMENTO INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_NUM_ELEMENTO;
      IF LN_EXISTE_ELEMENTO = 0 THEN
        LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE EL ELEMENTO DESTINO '|| LV_ELEMENTO_DESTINO || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|8';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSIF LN_EXISTE_ELEMENTO = 2 THEN
        LV_MENSAJE            := LV_NOMBRE_DOCUMENTO|| '|' || 'ELEMENTO REPETIDO '|| LV_ELEMENTO_DESTINO || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|8';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      ELSE
        LC_GET_INFO_ELEMENTO := NULL;
        OPEN C_GET_INFO_ELEMENTO(LV_ELEMENTO_DESTINO);
        FETCH C_GET_INFO_ELEMENTO INTO LC_GET_INFO_ELEMENTO;
        CLOSE C_GET_INFO_ELEMENTO;
        LC_GET_TIPO_NOMBRE_ELEMENTO := NULL;
        OPEN C_GET_TIPO_NOMBRE_ELEMENTO(LC_GET_INFO_ELEMENTO.ID_ELEMENTO);
        FETCH C_GET_TIPO_NOMBRE_ELEMENTO INTO LC_GET_TIPO_NOMBRE_ELEMENTO;
        CLOSE C_GET_TIPO_NOMBRE_ELEMENTO;
        IF LC_GET_TIPO_NOMBRE_ELEMENTO.NOMBRE_TIPO_ELEMENTO <> LT_TCAMPOSXLINEACSV(6) THEN
          LV_MENSAJE                                        := LV_NOMBRE_DOCUMENTO|| '|' || 'EL TIPO ELEMENTO DESTINO DIFERENTE AL ESPECIFICADO '|| LT_TCAMPOSXLINEACSV(6) || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|7';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        END IF;
        LC_GET_ENLACE_INTERFACE := NULL;
        OPEN C_GET_ENLACE_INTERFACE(LC_GET_INFO_ELEMENTO.ID_ELEMENTO, LT_TCAMPOSXLINEACSV(8));
        FETCH C_GET_ENLACE_INTERFACE INTO LC_GET_ENLACE_INTERFACE;
        CLOSE C_GET_ENLACE_INTERFACE;
        IF LC_GET_ENLACE_INTERFACE.ID_INTERFACE_ELEMENTO IS NULL THEN
          LV_MENSAJE                                     := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE LA INTERFAZ DESTINO ESPECIFICADA '|| LT_TCAMPOSXLINEACSV(8) || ' O NO SE ENCUENTRA EN ESTADO connected O not connect' || '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|9';
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
          LN_COUNT_ERR := LN_COUNT_ERR + 1;
          P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
        END IF;
      END IF;
    END IF;
    IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_SCOPE THEN
      LT_TCAMPOSXLINEACSV                             := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO, '|');
      LV_ELEMENTO_ORIGEN                              := LT_TCAMPOSXLINEACSV(0);
      OPEN C_GET_EXISTS_SCOPE(LV_ELEMENTO_ORIGEN, LN_MIGRACION_CAB);
      FETCH C_GET_EXISTS_SCOPE INTO LN_EXISTE_ELEMENTO;
      CLOSE C_GET_EXISTS_SCOPE;
      IF LN_EXISTE_ELEMENTO = 0 THEN
        LV_MENSAJE         := LV_NOMBRE_DOCUMENTO|| '|' || 'NO EXISTE EL ELEMENTO SCOPE '|| LV_ELEMENTO_ORIGEN ||' O NO TIENE SUBRED EN ESTADO ACTIVO. '|| '|' ||LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA||'|1';
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_MENSAJE);
        LN_COUNT_ERR := LN_COUNT_ERR + 1;
        P_INSERTA_MIGRA_DATA_ERROR ( PN_MIGRACION_CAB_ID => LN_MIGRACION_CAB, PV_TIPO_PROCESO => LV_TIPO_PROCESO_ERR, PN_LINEA => LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).LINEA, PV_ESTADO => LV_ESTADO_ERR, PV_OBSERVACION => LV_MENSAJE, PV_USR_CREACION => LV_USR_CREACION);
      END IF;
    END IF;
    END IF;
    LN_IDX_TAB_REG_FILES := LB_TAB_REG_FILES.NEXT(LN_IDX_TAB_REG_FILES);
  END LOOP;
  UTL_FILE.FCLOSE(LF_ARCHIVOPROCESOMASIVO);
  IF LN_COUNT_ERR > 0 THEN
    BEGIN
      LV_RESPUESTAGUARDARARCHIVO    := DB_GENERAL.GNRLPCK_UTIL.F_GUARDAR_ARCHIVO_NFS( LV_URLMICROSERVICIONFS, LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO, LV_NOMBREARCHIVOCORREO, NULL, LV_CODIGOAPPCORTEMASIVO, LV_CODIGOPATHCORTEMASIVO);
      IF LV_RESPUESTAGUARDARARCHIVO IS NULL THEN
        LV_MENSAJE                  := 'No se ha podido guardar el archivo de manera correcta en el NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      APEX_JSON.PARSE(LV_RESPUESTAGUARDARARCHIVO);
      LN_CODEGUARDARARCHIVO    := APEX_JSON.GET_NUMBER('code');
      IF LN_CODEGUARDARARCHIVO IS NULL OR LN_CODEGUARDARARCHIVO <> 200 THEN
        LV_MENSAJE             := 'Ha ocurrido alg¿n error al generar el archivo en el NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      LN_COUNTARCHIVOSGUARDADOS    := APEX_JSON.GET_COUNT(P_PATH => 'data');
      IF LN_COUNTARCHIVOSGUARDADOS IS NULL THEN
        LV_MENSAJE                 := 'No se ha generado correctamente la ruta del archivo en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      IF LN_COUNTARCHIVOSGUARDADOS <> 1 THEN
        LV_MENSAJE                 := 'Ha ocurrido un error inesperado al generar el archivo en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      FOR I IN 1 .. LN_COUNTARCHIVOSGUARDADOS
      LOOP
        LV_PATHGUARDARARCHIVO := APEX_JSON.GET_VARCHAR2(P_PATH => 'data[%d].pathFile', P0 => I);
      END LOOP;
      IF LV_PATHGUARDARARCHIVO IS NULL THEN
        LV_MENSAJE             := 'No se ha podido obtener la ruta en la que se encuentra el archivo generado en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      LN_IDDOCUMENTO := DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
      INSERT
      INTO DB_COMUNICACION.INFO_DOCUMENTO
        (
          ID_DOCUMENTO,
          NOMBRE_DOCUMENTO,
          UBICACION_LOGICA_DOCUMENTO,
          UBICACION_FISICA_DOCUMENTO,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          MENSAJE,
          EMPRESA_COD
        )
        VALUES
        (
          LN_IDDOCUMENTO,
          'Archivo generado por consulta previo a la migracion olt alta densidad',
          LV_NOMBREARCHIVOCORREO,
          LV_PATHGUARDARARCHIVO,
          LV_USR_CREACION,
          SYSDATE,
          '127.0.0.1',
          'Guardado',
          'Documento que se genera al exportar consulta en el reporte previo a la migracion olt alta densidad',
          '18'
        );
      COMMIT;
    EXCEPTION
        WHEN LE_EXCEPTION_NFS THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_UPLOAD_CSV_MIGRACION_OLT->ENVIO_NFS', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR : ' || LV_MENSAJE||' '||LV_RESPUESTAGUARDARARCHIVO, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        WHEN OTHERS THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_UPLOAD_CSV_MIGRACION_OLT->ENVIO_NFS', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR : ' || SQLERRM||' '||LV_RESPUESTAGUARDARARCHIVO, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END;
    LV_MENSAJE     := 'ERROR';
    LV_MENSAJE_ERR := 'Se han encontrado errores en los archivos de migracion olt alta densidad.';
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
    SET ESTADO             = 'Error',
      OBSERVACION          = 'Se han encontrado errores en los archivos de migracion.'
    WHERE ID_MIGRACION_CAB = LN_MIGRACION_CAB;
    COMMIT;
    LV_ASUNTO                                   := REPLACE(LV_ASUNTO, '{{NOMBRE_OLT}}', LV_OLT_ASUNTO);
    LR_GETALIASPLANTILLACORREO                  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('OLT_MIGRA_ERR');
    LV_PLANTILLA                                := LR_GETALIASPLANTILLACORREO.PLANTILLA;
    IF LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS IS NOT NULL THEN
      LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS  := REPLACE(LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, ';', ',') || ',';
    ELSE
      LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS := LV_REMITENTE || ',';
    END IF;
    IF LV_PLANTILLA IS NULL THEN
      LV_MENSAJE    := 'No se ha podido obtener la plantilla del correo enviado al procesar un archivo csv';
      RAISE LE_EXCEPTION;
    END IF;
    LV_PLANTILLA              := REPLACE(LV_PLANTILLA, '{{NOMBRE_OLT}}', LV_OLT_ASUNTO);
    LV_GZIP                   := 'gzip ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO;
    LV_NOMBREARCHIVOCORREOZIP := LV_NOMBREARCHIVOCORREO || '.gz';
    DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(LV_GZIP));
    BEGIN
      DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(LV_REMITENTE, LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, LV_ASUNTO, LV_PLANTILLA, LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREOZIP);
    EXCEPTION
    WHEN OTHERS THEN
      UTL_MAIL.SEND ( SENDER => LV_REMITENTE, RECIPIENTS => LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, SUBJECT => LV_ASUNTO, MESSAGE => SUBSTR(LV_PLANTILLA, 1, 32767), MIME_TYPE => 'text/html; charset=iso-8859-1');
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_UPLOAD_CSV_MIGRACION_OLT->ENVIO_CORREO', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END;
    UTL_FILE.FREMOVE(LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREOZIP);
  ELSE
    LN_IDX_TAB_REG_FILES        := LB_TAB_REG_FILES.FIRST;
    WHILE (LN_IDX_TAB_REG_FILES IS NOT NULL)
    LOOP
      LT_TCAMPOSXLINEACSV                               := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).CONTENIDO, '|');
      IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_OLT THEN
        INSERT
        INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
          (
            ID_MIGRACION_DET,
            MIGRACION_CAB_ID,
            TIPO_REGISTRO,
            OLT_ORDEN_MIGRACION,
            OLT_VALOR_NUMERICO,
            ELEMENTO_A,
            INTERFACE_ELEMENTO_A,
            ELEMENTO_B,
            INTERFACE_ELEMENTO_B,
            ESTADO,
            USR_CREACION,
            FE_CREACION
          )
          VALUES
          (
            DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_DET.NEXTVAL,
            LN_MIGRACION_CAB,
            LV_ELEMENTO_OLT,
            TO_NUMBER(LT_TCAMPOSXLINEACSV(0)),
            TO_NUMBER(LT_TCAMPOSXLINEACSV(5)),
            LT_TCAMPOSXLINEACSV(1),
            LT_TCAMPOSXLINEACSV(2),
            LT_TCAMPOSXLINEACSV(3),
            LT_TCAMPOSXLINEACSV(4),
            'Pendiente',
            LV_USR_CREACION,
            SYSDATE
          );
      END IF;
      IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_SPLITTER THEN
        INSERT
        INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
          (
            ID_MIGRACION_DET,
            MIGRACION_CAB_ID,
            TIPO_REGISTRO,
            ELEMENTO_A,
            ELEMENTO_B,
            ESTADO,
            USR_CREACION,
            FE_CREACION
          )
          VALUES
          (
            DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_DET.NEXTVAL,
            LN_MIGRACION_CAB,
            LV_ELEMENTO_SPLITTER,
            LT_TCAMPOSXLINEACSV(0),
            LT_TCAMPOSXLINEACSV(1),
            'Pendiente',
            LV_USR_CREACION,
            SYSDATE
          );
      END IF;
      IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_SCOPE THEN
        INSERT
        INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
          (
            ID_MIGRACION_DET,
            MIGRACION_CAB_ID,
            TIPO_REGISTRO,
            ELEMENTO_A,
            ELEMENTO_B,
            ESTADO,
            USR_CREACION,
            FE_CREACION
          )
          VALUES
          (
            DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_DET.NEXTVAL,
            LN_MIGRACION_CAB,
            LV_ELEMENTO_SCOPE,
            LT_TCAMPOSXLINEACSV(0),
            LT_TCAMPOSXLINEACSV(1),
            'Pendiente',
            LV_USR_CREACION,
            SYSDATE
          );
      END IF;
      IF LB_TAB_REG_FILES(LN_IDX_TAB_REG_FILES).ELEMENTO = LV_ELEMENTO_ENLACE THEN
        INSERT
        INTO DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
          (
            ID_MIGRACION_DET,
            MIGRACION_CAB_ID,
            TIPO_REGISTRO,
            TIPO_ELEMENTO_A,
            ELEMENTO_A,
            INTERFACE_ELEMENTO_A,
            CLASE_TIPO_MEDIO,
            BUFFER,
            HILO,
            TIPO_ELEMENTO_B,
            ELEMENTO_B,
            INTERFACE_ELEMENTO_B,
            ESTADO,
            USR_CREACION,
            FE_CREACION
          )
          VALUES
          (
            DB_INFRAESTRUCTURA.SEQ_INFO_MIGRA_AD_DET.NEXTVAL,
            LN_MIGRACION_CAB,
            LV_ELEMENTO_ENLACE,
            LT_TCAMPOSXLINEACSV(0),
            LT_TCAMPOSXLINEACSV(1),
            LT_TCAMPOSXLINEACSV(2),
            LT_TCAMPOSXLINEACSV(3),
            LT_TCAMPOSXLINEACSV(4),
            LT_TCAMPOSXLINEACSV(5),
            LT_TCAMPOSXLINEACSV(6),
            LT_TCAMPOSXLINEACSV(7),
            LT_TCAMPOSXLINEACSV(8),
            'Pendiente',
            LV_USR_CREACION,
            SYSDATE
          );
      END IF;
      LN_IDX_TAB_REG_FILES := LB_TAB_REG_FILES.NEXT(LN_IDX_TAB_REG_FILES);
    END LOOP;
    COMMIT;
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
    SET TIPO               = 'MIGRACION',
      ESTADO               = 'Pendiente'
    WHERE ID_MIGRACION_CAB = LN_MIGRACION_CAB;
    COMMIT;
    LV_MENSAJE     := 'OK';
    LV_MENSAJE_ERR := 'Se ha enviado a ejecutar el proceso de migracion exitosamente.';
  END IF;
  UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
  SET ESTADO             = 'Procesado'
  WHERE MIGRACION_CAB_ID = LN_MIGRACION_CAB
  AND TIPO_PROCESO       = 'Archivo'
  AND ESTADO             = 'Cargado';
  COMMIT;
  PV_STATUS  := LV_MENSAJE;
  PV_MENSAJE := LV_MENSAJE_ERR;
EXCEPTION
WHEN LE_EXCEPTION THEN
  PV_STATUS  := 'ERROR';
  PV_MENSAJE := LV_MENSAJE;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_UPLOAD_CSV_MIGRACION_OLT', SUBSTR(SQLCODE || ' -ERROR- ' || PV_MENSAJE || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,4000), LV_USR_CREACION, SYSDATE, '127.0.0.0');
  IF LN_MIGRACION_CAB IS NOT NULL THEN
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
    SET ESTADO             = 'Error',
      OBSERVACION          = PV_MENSAJE
    WHERE ID_MIGRACION_CAB = LN_MIGRACION_CAB;
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
    SET ESTADO             = 'Procesado'
    WHERE MIGRACION_CAB_ID = LN_MIGRACION_CAB
    AND TIPO_PROCESO       = 'Archivo'
    AND ESTADO             = 'Cargado';
    COMMIT;
  END IF;
WHEN OTHERS THEN
  PV_STATUS  := 'ERROR';
  PV_MENSAJE := 'Se han encontrado errores al validar los archivos de migracion, se notificará por correo electrónico el detalle de los mismos.';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_UPLOAD_CSV_MIGRACION_OLT', SUBSTR(SQLCODE || ' -ERROR- ' || PV_MENSAJE || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,4000), LV_USR_CREACION, SYSDATE, '127.0.0.0');
  IF LN_MIGRACION_CAB IS NOT NULL THEN
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
    SET ESTADO             = 'Error',
      OBSERVACION          = PV_MENSAJE
    WHERE ID_MIGRACION_CAB = LN_MIGRACION_CAB;
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
    SET ESTADO             = 'Procesado'
    WHERE MIGRACION_CAB_ID = LN_MIGRACION_CAB
    AND TIPO_PROCESO       = 'Archivo'
    AND ESTADO             = 'Cargado';
    COMMIT;
  END IF;
END P_UPLOAD_CSV_MIGRACION_OLT;
FUNCTION F_GET_CARACTERISTICA_SRV(
    FN_ID_SERVICIO    IN NUMBER,
    FV_CARACTERISTICA IN VARCHAR2)
  RETURN VARCHAR2
IS
  CURSOR C_GET_CARACTERISTICA
  IS
  SELECT ISPC.VALOR
    FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
    WHERE SERVICIO_ID                = FN_ID_SERVICIO
    AND ESTADO                       = 'Activo'
    AND PRODUCTO_CARACTERISITICA_ID IN
      (SELECT APC.ID_PRODUCTO_CARACTERISITICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
      WHERE AC.ID_CARACTERISTICA     = APC.CARACTERISTICA_ID
      AND DESCRIPCION_CARACTERISTICA = FV_CARACTERISTICA
      AND APC.PRODUCTO_ID           IN
        (SELECT ID_PRODUCTO
        FROM DB_COMERCIAL.ADMI_PRODUCTO
        WHERE NOMBRE_TECNICO IN (SELECT VALOR2 AS NOMBRE_TECNICO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID IN
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
        AND ESTADO             = 'Activo'
        )
      AND VALOR1 IN('PRODUCTO_MD','PRODUCTO_TN'))
        AND ESTADO                 = 'Activo'
        AND EMPRESA_COD            IN (10,18)
        )
      );
    LV_CARACTERISTICA VARCHAR2(450);
    LV_MENSAJEERROR   VARCHAR2(4000);
  BEGIN
    OPEN C_GET_CARACTERISTICA;
    FETCH C_GET_CARACTERISTICA INTO LV_CARACTERISTICA;
    CLOSE C_GET_CARACTERISTICA;
    IF LV_CARACTERISTICA IS NULL THEN
      LV_CARACTERISTICA  := 'N/A';
    END IF;
    RETURN LV_CARACTERISTICA;
  EXCEPTION
  WHEN OTHERS THEN
    LV_CARACTERISTICA := 'ERROR';
    LV_MENSAJEERROR   := SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_CARACTERISTICA_SRV', LV_MENSAJEERROR, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN LV_CARACTERISTICA;
  END F_GET_CARACTERISTICA_SRV;
  PROCEDURE P_REPORTE_MIGRA_PREV_ENLACE(
      PV_USRCONSULTA IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  AS
    LV_MENSAJE            VARCHAR2(4000);
    LV_BANDERA_SALIR      VARCHAR2(10) := 'NO';
    LV_BANDERA_SALIR_SP   VARCHAR2(10) := 'NO';
    LN_ITERACION          NUMBER       := 0;
    LN_ITERACION_SP       NUMBER       := 0;
    LN_INTERFACE_ELEMENTO NUMBER;
    LV_CADENA             VARCHAR2(4000);
    LF_ARCHIVOPROCESOMASIVO UTL_FILE.FILE_TYPE;
    LV_DIRECTORIOBASEDATOS     VARCHAR2(50);
    LV_RUTADIRECTORIOBASEDATOS VARCHAR2(300);
    LV_NOMBREARCHIVOCORREO     VARCHAR2(500);
    LV_NOMBREARCHIVOCORREOZIP  VARCHAR2(500);
    LV_GZIP                    VARCHAR2(500);
    LV_NOMBREPARAMETRODIRCSV   VARCHAR2(100) := 'DIRECTORIO_BD_ARCHIVOS_TEMPORALES';
    LE_EXCEPTION               EXCEPTION;
    LE_EXCEPTION_NFS           EXCEPTION;
    LV_STATUS                  VARCHAR2(150);
    LV_MENSAJE_ERR             VARCHAR2(4000);
    LV_USR_CONSULTA            VARCHAR2(150) := PV_USRCONSULTA;
    LR_GETALIASPLANTILLACORREO DB_FINANCIERO.FNKG_TYPES.LR_ALIASPLANTILLA;
    LV_PLANTILLA               VARCHAR2(4000);
    LV_PARAMETRO_NOTIFICACINES VARCHAR2(100) := 'MIGRA_NOTIFICACIONES';
    LV_NOTI_PREV_ENLACE        VARCHAR2(100) := 'NOTIFICACIONES_PREV_ENLACE';
    LV_OLT_ASUNTO              VARCHAR2(2000);
    LV_REMITENTE               VARCHAR2(1000);
    LV_ASUNTO                  VARCHAR2(1000);
    CURSOR C_GET_INTERFACE_ELEMETO(CN_ELEMENTO_ID NUMBER)
    IS
      SELECT ID_INTERFACE_ELEMENTO,
        NOMBRE_INTERFACE_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
      WHERE ELEMENTO_ID = CN_ELEMENTO_ID
      AND ESTADO        = 'connected';
    CURSOR C_DATO_ELEMENTO(CN_ELEMENTO_ID NUMBER)
    IS
      SELECT ATE.NOMBRE_TIPO_ELEMENTO,
        IE.NOMBRE_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE
      WHERE IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
      AND AME.TIPO_ELEMENTO_ID    = ATE.ID_TIPO_ELEMENTO
      AND IE.ID_ELEMENTO          = CN_ELEMENTO_ID;
    CURSOR C_GET_INTERFAZ_FIN(CN_INTERFACE_INI_ID NUMBER)
    IS
      SELECT IE.INTERFACE_ELEMENTO_FIN_ID INTERFACE_FIN_ID
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE IE
      WHERE IE.INTERFACE_ELEMENTO_INI_ID = CN_INTERFACE_INI_ID
      AND IE.ESTADO                      = 'Activo'
      AND EXISTS
        (SELECT 1
        FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IIE
        WHERE IIE.ID_INTERFACE_ELEMENTO = IE.INTERFACE_ELEMENTO_FIN_ID
        AND IIE.ESTADO                  = 'connected'
        );
    CURSOR C_GET_INTERFACE_SPLITTER (CN_INTERFACE_INI_ID NUMBER)
    IS
      SELECT INTERFACE_ELEMENTO_FIN_ID INTERFACE_FIN_ID
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE IE
      WHERE IE.INTERFACE_ELEMENTO_INI_ID = CN_INTERFACE_INI_ID
      AND IE.ESTADO                      = 'Activo'
      AND EXISTS
        (SELECT 1
        FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IIE
        WHERE IIE.ID_INTERFACE_ELEMENTO = IE.INTERFACE_ELEMENTO_FIN_ID
        AND IIE.ESTADO                  = 'connected'
        );
    CURSOR C_GET_ELEMENTO_CONECTADO(CN_INTERFACE_INI_ID NUMBER)
    IS
      SELECT ATE.NOMBRE_TIPO_ELEMENTO TIPO_ELEMENTO_DESTINO,
        IE.NOMBRE_ELEMENTO NOMBRE_ELEMENTO_DESTINO,
        ITE.NOMBRE_INTERFACE_ELEMENTO INTERFACE_ELEMENTO_DESTINO,
        ITE.ID_INTERFACE_ELEMENTO INTERFACE_PADRE_ID,
        IE.ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO ITE,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
        DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO ATE
      WHERE ITE.ELEMENTO_ID         = IE.ID_ELEMENTO
      AND IE.MODELO_ELEMENTO_ID     = AME.ID_MODELO_ELEMENTO
      AND AME.TIPO_ELEMENTO_ID      = ATE.ID_TIPO_ELEMENTO
      AND ITE.ID_INTERFACE_ELEMENTO = CN_INTERFACE_INI_ID;
    CURSOR C_GET_NIVEL_ELEMENTO (CN_INTERFACE_INI_ID NUMBER)
    IS
      SELECT ITE.ID_INTERFACE_ELEMENTO,
        IDE.DETALLE_NOMBRE,
        IDE.DETALLE_VALOR NIVEL,
        IE.ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO ITE,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
        DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE
      WHERE ITE.ELEMENTO_ID         = IE.ID_ELEMENTO
      AND IE.ID_ELEMENTO            = IDE.ELEMENTO_ID
      AND ITE.ID_INTERFACE_ELEMENTO = CN_INTERFACE_INI_ID;
    CURSOR LC_GETVALORESPARAMSGENERAL(CV_NOMBREPARAMETRO DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      SELECT DET.VALOR1,
        DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = CV_NOMBREPARAMETRO
      AND CAB.ESTADO             = 'Activo'
      AND DET.ESTADO             = 'Activo';
    CURSOR C_GET_OLT_MIGRACION
    IS
      SELECT IDENTIFICADOR AS ELEMENTO_ID,
        INFORMACION
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
      WHERE MIGRACION_CAB_ID IN
        (SELECT ID_MIGRACION_CAB
        FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
        WHERE TIPO = 'ReporteMigracion'
        AND ESTADO = 'Pendiente'
        )
    AND TIPO_PROCESO = 'ReportePrevio'
    AND ESTADO       = 'Pendiente';
    CURSOR C_GET_REMITENTE_ASUNTO (CV_PARAMETRO_REPORTE VARCHAR2)
    IS
      SELECT VALOR3 REMITENTE,
        VALOR4 ASUNTO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID IN
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
        AND ESTADO             = 'Activo'
        )
    AND VALOR1 = LV_PARAMETRO_NOTIFICACINES
    AND VALOR2 = CV_PARAMETRO_REPORTE;
    CURSOR LC_GETCONFIGNFSMIGRAAD
    IS
      SELECT TO_CHAR(CODIGO_APP) AS CODIGO_APP,
        TO_CHAR(CODIGO_PATH)     AS CODIGO_PATH
      FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS
      WHERE APLICACION ='TelcosWeb'
      AND SUBMODULO    = 'MigracionOltAltaDensidad'
      AND EMPRESA      ='MD';
    CURSOR C_GET_MAX_ITERACIONES
    IS
      SELECT TO_NUMBER(VALOR2,'99999') MAX_ITERACIONES
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID IN
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
        AND ESTADO             = 'Activo'
        )
    AND VALOR1 = 'MAX_ITERACIONES_ENLACE';
    LN_MAX_ITERACIONES_ENLACE  NUMBER;
    LV_RESPUESTAGUARDARARCHIVO VARCHAR2(4000);
    LV_URLMICROSERVICIONFS     VARCHAR2(500);
    LV_CODIGOAPPCORTEMASIVO    VARCHAR2(20);
    LV_CODIGOPATHCORTEMASIVO   VARCHAR2(20);
    LN_CODEGUARDARARCHIVO      NUMBER;
    LN_COUNTARCHIVOSGUARDADOS  NUMBER;
    LV_PATHGUARDARARCHIVO      VARCHAR2(4000);
    LN_IDDOCUMENTO DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    LR_GETCONFIGNFSMIGRAAD LC_GETCONFIGNFSMIGRAAD%ROWTYPE;
    LV_NOMBREPARAMURLMICRONFS VARCHAR2(33) := 'URL_MICROSERVICIO_NFS';
    LC_GET_INTERFACE_ELEMETO C_GET_INTERFACE_ELEMETO%ROWTYPE;
    LC_DATO_ELEMENTO C_DATO_ELEMENTO%ROWTYPE;
    LC_GET_INTERFAZ_FIN C_GET_INTERFAZ_FIN%ROWTYPE;
    LC_GET_ELEMENTO_CONECTADO C_GET_ELEMENTO_CONECTADO%ROWTYPE;
    LC_GET_NIVEL_ELEMENTO C_GET_NIVEL_ELEMENTO%ROWTYPE;
    LC_GET_INTERFACE_SPLITTER C_GET_INTERFACE_SPLITTER%ROWTYPE;
    LR_REGGETVALORESPARAMSGENERAL LC_GETVALORESPARAMSGENERAL%ROWTYPE;
    LC_GET_OLT_MIGRACION C_GET_OLT_MIGRACION%ROWTYPE;
    LC_GET_REMITENTE_ASUNTO C_GET_REMITENTE_ASUNTO%ROWTYPE;
  BEGIN
    OPEN C_GET_MAX_ITERACIONES;
    FETCH C_GET_MAX_ITERACIONES INTO LN_MAX_ITERACIONES_ENLACE;
    CLOSE C_GET_MAX_ITERACIONES;
    IF LN_MAX_ITERACIONES_ENLACE IS NULL THEN
      LV_MENSAJE    := 'No se ha podido obtener el parametro para el maximo de iteraciones en el reporte previo de enlace.';
      RAISE LE_EXCEPTION;
    END IF;
    OPEN LC_GETVALORESPARAMSGENERAL(LV_NOMBREPARAMETRODIRCSV);
    FETCH LC_GETVALORESPARAMSGENERAL INTO LR_REGGETVALORESPARAMSGENERAL;
    CLOSE LC_GETVALORESPARAMSGENERAL;
    LV_DIRECTORIOBASEDATOS     := LR_REGGETVALORESPARAMSGENERAL.VALOR1;
    LV_RUTADIRECTORIOBASEDATOS := LR_REGGETVALORESPARAMSGENERAL.VALOR2;
    OPEN C_GET_REMITENTE_ASUNTO(LV_NOTI_PREV_ENLACE);
    FETCH C_GET_REMITENTE_ASUNTO INTO LC_GET_REMITENTE_ASUNTO;
    CLOSE C_GET_REMITENTE_ASUNTO;
    LV_REMITENTE    := LC_GET_REMITENTE_ASUNTO.REMITENTE;
    LV_ASUNTO       := LC_GET_REMITENTE_ASUNTO.ASUNTO;
    IF LV_REMITENTE IS NULL OR LV_ASUNTO IS NULL THEN
      LV_MENSAJE    := 'No se ha podido obtener el remitente y/o el asunto del correo con el archivo adjunto de cambio de plan masivo';
      RAISE LE_EXCEPTION;
    END IF;
    -- ENLACE_REPORTE_PREV
    LR_REGGETVALORESPARAMSGENERAL := NULL;
    OPEN LC_GETVALORESPARAMSGENERAL(LV_NOMBREPARAMURLMICRONFS);
    FETCH LC_GETVALORESPARAMSGENERAL INTO LR_REGGETVALORESPARAMSGENERAL;
    CLOSE LC_GETVALORESPARAMSGENERAL;
    LV_URLMICROSERVICIONFS    := LR_REGGETVALORESPARAMSGENERAL.VALOR1;
    IF LV_URLMICROSERVICIONFS IS NULL THEN
      LV_MENSAJE              := 'No se ha podido obtener la URL del NFS';
      RAISE LE_EXCEPTION;
    END IF;
    OPEN LC_GETCONFIGNFSMIGRAAD;
    FETCH LC_GETCONFIGNFSMIGRAAD INTO LR_GETCONFIGNFSMIGRAAD;
    CLOSE LC_GETCONFIGNFSMIGRAAD;
    LV_CODIGOAPPCORTEMASIVO    := LR_GETCONFIGNFSMIGRAAD.CODIGO_APP;
    LV_CODIGOPATHCORTEMASIVO   := LR_GETCONFIGNFSMIGRAAD.CODIGO_PATH;
    IF LV_CODIGOAPPCORTEMASIVO IS NULL OR LV_CODIGOPATHCORTEMASIVO IS NULL THEN
      LV_MENSAJE               := 'No se ha podido obtener la configuraci¿n de la ruta NFS';
      RAISE LE_EXCEPTION;
    END IF;
    LV_NOMBREARCHIVOCORREO  := 'REPORTE_ENLACE_PREVIO_'||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')||'.csv';
    LF_ARCHIVOPROCESOMASIVO := UTL_FILE.FOPEN(LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREO, 'w', 5000);
    UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,'TIPO_ELEMENTO_A|NOMBRE_ELEMENTO_A|INTERFACE_ELEMENTO_A|TIPO_ELEMENTO_B|NOMBRE_ELEMENTO_B|INTERFACE_ELEMENTO_B');
    FOR LC_GET_OLT_MIGRACION IN C_GET_OLT_MIGRACION
    LOOP
      IF LV_OLT_ASUNTO IS NULL THEN
        LV_OLT_ASUNTO  := LC_GET_OLT_MIGRACION.INFORMACION;
      ELSE
        LV_OLT_ASUNTO := LV_OLT_ASUNTO||' - '||LC_GET_OLT_MIGRACION.INFORMACION;
      END IF;
      FOR LC_GET_INTERFACE_ELEMETO IN C_GET_INTERFACE_ELEMETO(LC_GET_OLT_MIGRACION.ELEMENTO_ID)
      LOOP
        LN_INTERFACE_ELEMENTO := LC_GET_INTERFACE_ELEMETO.ID_INTERFACE_ELEMENTO;
        LV_BANDERA_SALIR      := 'NO';
        LN_ITERACION          := 0;
        WHILE LV_BANDERA_SALIR = 'NO'
        LOOP
          OPEN C_GET_INTERFAZ_FIN(LN_INTERFACE_ELEMENTO);
          FETCH C_GET_INTERFAZ_FIN INTO LC_GET_INTERFAZ_FIN;
          CLOSE C_GET_INTERFAZ_FIN;
          OPEN C_GET_ELEMENTO_CONECTADO(LN_INTERFACE_ELEMENTO);
          FETCH C_GET_ELEMENTO_CONECTADO INTO LC_GET_ELEMENTO_CONECTADO;
          CLOSE C_GET_ELEMENTO_CONECTADO;
          LV_CADENA             := LC_GET_ELEMENTO_CONECTADO.TIPO_ELEMENTO_DESTINO|| '|' || LC_GET_ELEMENTO_CONECTADO.NOMBRE_ELEMENTO_DESTINO|| '|' || LC_GET_ELEMENTO_CONECTADO.INTERFACE_ELEMENTO_DESTINO;
          LN_INTERFACE_ELEMENTO := LC_GET_INTERFAZ_FIN.INTERFACE_FIN_ID;
          OPEN C_GET_INTERFAZ_FIN(LN_INTERFACE_ELEMENTO);
          FETCH C_GET_INTERFAZ_FIN INTO LC_GET_INTERFAZ_FIN;
          CLOSE C_GET_INTERFAZ_FIN;
          OPEN C_GET_ELEMENTO_CONECTADO(LN_INTERFACE_ELEMENTO);
          FETCH C_GET_ELEMENTO_CONECTADO INTO LC_GET_ELEMENTO_CONECTADO;
          CLOSE C_GET_ELEMENTO_CONECTADO;
          LV_CADENA             := LV_CADENA || '|'||LC_GET_ELEMENTO_CONECTADO.TIPO_ELEMENTO_DESTINO|| '|' || LC_GET_ELEMENTO_CONECTADO.NOMBRE_ELEMENTO_DESTINO|| '|' || LC_GET_ELEMENTO_CONECTADO.INTERFACE_ELEMENTO_DESTINO;
          LN_INTERFACE_ELEMENTO := LC_GET_INTERFAZ_FIN.INTERFACE_FIN_ID;
          UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_CADENA);
          IF LC_GET_ELEMENTO_CONECTADO.TIPO_ELEMENTO_DESTINO = 'SPLITTER' THEN
            OPEN C_GET_NIVEL_ELEMENTO(LC_GET_ELEMENTO_CONECTADO.INTERFACE_PADRE_ID);
            FETCH C_GET_NIVEL_ELEMENTO INTO LC_GET_NIVEL_ELEMENTO;
            CLOSE C_GET_NIVEL_ELEMENTO;
            IF LC_GET_NIVEL_ELEMENTO.NIVEL = '2' THEN
              LV_BANDERA_SALIR            := 'SI';
            ELSE
              FOR LC_GET_INTERFACE_SPLITTER IN C_GET_INTERFACE_SPLITTER(LC_GET_ELEMENTO_CONECTADO.INTERFACE_PADRE_ID)
              LOOP
                LN_INTERFACE_ELEMENTO    := LC_GET_INTERFACE_SPLITTER.INTERFACE_FIN_ID;
                LV_BANDERA_SALIR_SP      := 'NO';
                LN_ITERACION_SP          := 0;
                WHILE LV_BANDERA_SALIR_SP = 'NO'
                LOOP
                  OPEN C_GET_INTERFAZ_FIN(LN_INTERFACE_ELEMENTO);
                  FETCH C_GET_INTERFAZ_FIN INTO LC_GET_INTERFAZ_FIN;
                  CLOSE C_GET_INTERFAZ_FIN;
                  OPEN C_GET_ELEMENTO_CONECTADO(LN_INTERFACE_ELEMENTO);
                  FETCH C_GET_ELEMENTO_CONECTADO INTO LC_GET_ELEMENTO_CONECTADO;
                  CLOSE C_GET_ELEMENTO_CONECTADO;
                  LV_CADENA             := LC_GET_ELEMENTO_CONECTADO.TIPO_ELEMENTO_DESTINO|| '|' || LC_GET_ELEMENTO_CONECTADO.NOMBRE_ELEMENTO_DESTINO|| '|' || LC_GET_ELEMENTO_CONECTADO.INTERFACE_ELEMENTO_DESTINO;
                  LN_INTERFACE_ELEMENTO := LC_GET_INTERFAZ_FIN.INTERFACE_FIN_ID;
                  OPEN C_GET_INTERFAZ_FIN(LN_INTERFACE_ELEMENTO);
                  FETCH C_GET_INTERFAZ_FIN INTO LC_GET_INTERFAZ_FIN;
                  CLOSE C_GET_INTERFAZ_FIN;
                  OPEN C_GET_ELEMENTO_CONECTADO(LN_INTERFACE_ELEMENTO);
                  FETCH C_GET_ELEMENTO_CONECTADO INTO LC_GET_ELEMENTO_CONECTADO;
                  CLOSE C_GET_ELEMENTO_CONECTADO;
                  LV_CADENA             := LV_CADENA || '|'||LC_GET_ELEMENTO_CONECTADO.TIPO_ELEMENTO_DESTINO|| '|' || LC_GET_ELEMENTO_CONECTADO.NOMBRE_ELEMENTO_DESTINO|| '|' || LC_GET_ELEMENTO_CONECTADO.INTERFACE_ELEMENTO_DESTINO;
                  LN_INTERFACE_ELEMENTO := LC_GET_INTERFAZ_FIN.INTERFACE_FIN_ID;
                  UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,LV_CADENA);
                  IF LC_GET_ELEMENTO_CONECTADO.TIPO_ELEMENTO_DESTINO = 'SPLITTER' THEN
                    OPEN C_GET_NIVEL_ELEMENTO(LC_GET_ELEMENTO_CONECTADO.INTERFACE_PADRE_ID);
                    FETCH C_GET_NIVEL_ELEMENTO INTO LC_GET_NIVEL_ELEMENTO;
                    CLOSE C_GET_NIVEL_ELEMENTO;
                    IF LC_GET_NIVEL_ELEMENTO.NIVEL = '2' THEN
                      LV_BANDERA_SALIR_SP         := 'SI';
                    END IF;
                  END IF;
                  LN_ITERACION_SP       := LN_ITERACION_SP + 1;
                  IF LN_ITERACION_SP     > LN_MAX_ITERACIONES_ENLACE THEN
                    LV_BANDERA_SALIR_SP := 'SI';
                  END IF;
                END LOOP;
              END LOOP;
              IF LV_BANDERA_SALIR_SP = 'SI' THEN
                LV_BANDERA_SALIR    := 'SI';
              END IF;
            END IF;
          END IF;
          LN_ITERACION       := LN_ITERACION + 1;
          IF LN_ITERACION     > LN_MAX_ITERACIONES_ENLACE THEN
            LV_BANDERA_SALIR := 'SI';
          END IF;
        END LOOP;
      END LOOP;
    END LOOP;
    UTL_FILE.FCLOSE(LF_ARCHIVOPROCESOMASIVO);
    BEGIN
      LV_RESPUESTAGUARDARARCHIVO    := DB_GENERAL.GNRLPCK_UTIL.F_GUARDAR_ARCHIVO_NFS( LV_URLMICROSERVICIONFS, LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO, LV_NOMBREARCHIVOCORREO, NULL, LV_CODIGOAPPCORTEMASIVO, LV_CODIGOPATHCORTEMASIVO);
      IF LV_RESPUESTAGUARDARARCHIVO IS NULL THEN
        LV_MENSAJE                  := 'No se ha podido guardar el archivo de manera correcta en el NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      APEX_JSON.PARSE(LV_RESPUESTAGUARDARARCHIVO);
      LN_CODEGUARDARARCHIVO    := APEX_JSON.GET_NUMBER('code');
      IF LN_CODEGUARDARARCHIVO IS NULL OR LN_CODEGUARDARARCHIVO <> 200 THEN
        LV_MENSAJE             := 'Ha ocurrido alg¿n error al generar el archivo en el NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      LN_COUNTARCHIVOSGUARDADOS    := APEX_JSON.GET_COUNT(P_PATH => 'data');
      IF LN_COUNTARCHIVOSGUARDADOS IS NULL THEN
        LV_MENSAJE                 := 'No se ha generado correctamente la ruta del archivo en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      IF LN_COUNTARCHIVOSGUARDADOS <> 1 THEN
        LV_MENSAJE                 := 'Ha ocurrido un error inesperado al generar el archivo en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      FOR I IN 1 .. LN_COUNTARCHIVOSGUARDADOS
      LOOP
        LV_PATHGUARDARARCHIVO := APEX_JSON.GET_VARCHAR2(P_PATH => 'data[%d].pathFile', P0 => I);
      END LOOP;
      IF LV_PATHGUARDARARCHIVO IS NULL THEN
        LV_MENSAJE             := 'No se ha podido obtener la ruta en la que se encuentra el archivo generado en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      LN_IDDOCUMENTO := DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
      INSERT
      INTO DB_COMUNICACION.INFO_DOCUMENTO
        (
          ID_DOCUMENTO,
          NOMBRE_DOCUMENTO,
          UBICACION_LOGICA_DOCUMENTO,
          UBICACION_FISICA_DOCUMENTO,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          MENSAJE,
          EMPRESA_COD
        )
        VALUES
        (
          LN_IDDOCUMENTO,
          'Archivo generado por consulta previo a la migracion olt alta densidad',
          LV_NOMBREARCHIVOCORREO,
          LV_PATHGUARDARARCHIVO,
          PV_USRCONSULTA,
          SYSDATE,
          '127.0.0.1',
          'Guardado',
          'Documento que se genera al exportar consulta en el reporte previo a la migracion olt alta densidad',
          '18'
        );
      COMMIT;
    EXCEPTION
        WHEN LE_EXCEPTION_NFS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REPORTE_MIGRA_PREV_ENLACE->ENVIO_NFS', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR : ' || LV_MENSAJE||' '||LV_RESPUESTAGUARDARARCHIVO, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        WHEN OTHERS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REPORTE_MIGRA_PREV_ENLACE->ENVIO_NFS', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR : ' || SQLERRM||' '||LV_RESPUESTAGUARDARARCHIVO, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END;
    LV_MENSAJE                                  := '';
    LV_ASUNTO                                   := REPLACE(LV_ASUNTO, '{{NOMBRE_OLT}}', LV_OLT_ASUNTO);
    LR_GETALIASPLANTILLACORREO                  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('OLT_MIGRA_PREV');
    LV_PLANTILLA                                := LR_GETALIASPLANTILLACORREO.PLANTILLA;
    IF LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS IS NOT NULL THEN
      LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS  := REPLACE(LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, ';', ',') || ',';
    ELSE
      LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS := LV_REMITENTE || ',';
    END IF;
    IF LV_PLANTILLA IS NULL THEN
      LV_MENSAJE    := 'No se ha podido obtener la plantilla del correo enviado al procesar un archivo csv';
      RAISE LE_EXCEPTION;
    END IF;
    LV_PLANTILLA              := REPLACE(LV_PLANTILLA, '{{NOMBRE_OLT}}', LV_OLT_ASUNTO);
    LV_GZIP                   := 'gzip ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO;
    LV_NOMBREARCHIVOCORREOZIP := LV_NOMBREARCHIVOCORREO || '.gz';
    DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(LV_GZIP));
    BEGIN
      DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(LV_REMITENTE, LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, LV_ASUNTO, LV_PLANTILLA, LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREOZIP);
    EXCEPTION
    WHEN OTHERS THEN
      UTL_MAIL.SEND ( SENDER => LV_REMITENTE, RECIPIENTS => LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, SUBJECT => LV_ASUNTO, MESSAGE => SUBSTR(LV_PLANTILLA, 1, 32767), MIME_TYPE => 'text/html; charset=iso-8859-1');
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REPORTE_MIGRA_PREV_ENLACE->ENVIO_CORREO', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END;
    UTL_FILE.FREMOVE(LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREOZIP);
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'OK';
  EXCEPTION
  WHEN LE_EXCEPTION THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'ERROR : '||LV_MENSAJE;
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'ERROR : '||SQLERRM || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_REPORTE_MIGRA_PREV_ENLACE;
  PROCEDURE P_REPORTE_MIGRA_PREV_DATA_TECN
    (
      PV_USRCONSULTA IN VARCHAR2,
      PV_TIPOREPORTE IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  AS
    LV_MENSAJE VARCHAR2
    (
      450
    )
    ;
    LF_ARCHIVOPROCESOMASIVO UTL_FILE.FILE_TYPE;
    LV_DIRECTORIOBASEDATOS     VARCHAR2(50);
    LV_RUTADIRECTORIOBASEDATOS VARCHAR2(300);
    LV_NOMBREARCHIVOCORREO     VARCHAR2(500);
    LV_NOMBREARCHIVOCORREOZIP  VARCHAR2(500);
    LV_GZIP                    VARCHAR2(500);
    LV_NOMBREPARAMETRODIRCSV   VARCHAR2(100) := 'DIRECTORIO_BD_ARCHIVOS_TEMPORALES';
    LV_NOMBREPARAMURLMICRONFS  VARCHAR2(33)  := 'URL_MICROSERVICIO_NFS';
    LV_CODEMPRESATN            VARCHAR2(14)  := '10';
    LV_CODEMPRESAMD            VARCHAR2(14)  := '18';
    LV_SEPARADOR               VARCHAR2(5)   := '|';
    LN_CONTADORREG             NUMBER        := 0;
    LV_MSJERROR                VARCHAR2(4000);
    LV_USRCONSULTA             VARCHAR2(25) := PV_USRCONSULTA;
    LE_EXCEPTION               EXCEPTION;
    LR_GETALIASPLANTILLACORREO DB_FINANCIERO.FNKG_TYPES.LR_ALIASPLANTILLA;
    LV_PLANTILLA                VARCHAR2(4000);
    LV_PARAMETRO_NOTIFICACIONES VARCHAR2(100) := 'MIGRA_NOTIFICACIONES';
    LV_NOTI_PARAMETRO           VARCHAR2(100);
    LV_OLT_ASUNTO               VARCHAR2(2000);
    LV_REMITENTE                VARCHAR2(1000);
    LV_ASUNTO                   VARCHAR2(1000);
    CURSOR C_GET_REMITENTE_ASUNTO (CV_PARAMETRO_REPORTE VARCHAR2)
    IS
      SELECT VALOR3 REMITENTE,
        VALOR4 ASUNTO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID IN
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
        AND ESTADO             = 'Activo'
        )
    AND VALOR1 = LV_PARAMETRO_NOTIFICACIONES
    AND VALOR2 = CV_PARAMETRO_REPORTE;
    CURSOR LC_GETVALORESPARAMSGENERAL(CV_NOMBREPARAMETRO DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      SELECT DET.VALOR1,
        DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = CV_NOMBREPARAMETRO
      AND CAB.ESTADO             = 'Activo'
      AND DET.ESTADO             = 'Activo';
    CURSOR C_GET_OLT_MIGRACION
    IS
      SELECT IDENTIFICADOR AS VALOR,
        INFORMACION
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
      WHERE MIGRACION_CAB_ID IN
        (SELECT ID_MIGRACION_CAB
        FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
        WHERE TIPO = 'ReporteMigracion'
        AND ESTADO = 'Pendiente'
        )
    AND TIPO_PROCESO = PV_TIPOREPORTE
    AND ESTADO       = 'Pendiente';
    CURSOR C_DATA_TECNICA_OLT (CN_ID_ELEMENTO NUMBER)
    IS
      SELECT ELEMENTO.ID_ELEMENTO,
        SERVICIO.ID_SERVICIO,
        ELEMENTO.NOMBRE_ELEMENTO,
        MODELO.NOMBRE_MODELO_ELEMENTO,
        MARCA.NOMBRE_MARCA_ELEMENTO,
        ELEMENTO_IP.IP,
        INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO,
        PUNTO.LOGIN,
        (DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_CARACTERISTICA_SRV(SERVICIO.ID_SERVICIO,'INDICE CLIENTE')) ONT_ID,
        (DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_CARACTERISTICA_SRV(SERVICIO.ID_SERVICIO,'LINE-PROFILE-NAME')) LINE_PROFILE_NAME,
        (DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_CARACTERISTICA_SRV(SERVICIO.ID_SERVICIO,'SPID')) SERVICE_PORT_ID,
        (DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_CARACTERISTICA_SRV(SERVICIO.ID_SERVICIO,'GEM-PORT')) GEM_PORT,
        (DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_CARACTERISTICA_SRV(SERVICIO.ID_SERVICIO,'TRAFFIC-TABLE')) TRAFFIC_TABLE,
        (DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_CARACTERISTICA_SRV(SERVICIO.ID_SERVICIO,'VLAN')) VLAN,
        (SELECT DETALLE_VALOR
        FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
        WHERE ELEMENTO_ID  = ELEMENTO.ID_ELEMENTO
        AND DETALLE_NOMBRE = 'APROVISIONAMIENTO_IP'
        ) APROVISIONAMIENTO_IP_ELEMENTO,
      (SELECT NOMBRE_TIPO_MEDIO
      FROM DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO
      WHERE ID_TIPO_MEDIO = TECNICO.ULTIMA_MILLA_ID
      ) ULTIMA_MILLA,
      (SELECT NOMBRE_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE ID_ELEMENTO = TECNICO.ELEMENTO_CONTENEDOR_ID
      ) NOMBRE_ELEMENTO_CONTENEDOR,
      (SELECT NOMBRE_INTERFACE_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
      WHERE ID_INTERFACE_ELEMENTO = TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID
      ) INTERFACE_ELEMENTO_CONECTOR,
      (SELECT
        (SELECT
          (SELECT BUFFER.NUMERO_BUFFER
            ||', '
            ||BUFFER.COLOR_BUFFER
          FROM DB_INFRAESTRUCTURA.INFO_BUFFER_HILO BUFFER_HILO,
            DB_INFRAESTRUCTURA.ADMI_BUFFER BUFFER
          WHERE BUFFER_HILO.BUFFER_ID    = BUFFER.ID_BUFFER
          AND BUFFER_HILO.ESTADO         = 'Activo'
          AND BUFFER.ESTADO              = 'Activo'
          AND BUFFER_HILO.ID_BUFFER_HILO = ENLACE.BUFFER_HILO_ID
          ) BUFFER
        FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE
        WHERE ENLACE.INTERFACE_ELEMENTO_FIN_ID = ENLACE_INFO.INTERFACE_ELEMENTO_INI_ID
        AND ENLACE.ESTADO                      = 'Activo'
        ) BUFFER
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE_INFO
      WHERE ENLACE_INFO.INTERFACE_ELEMENTO_FIN_ID = TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID
      AND ENLACE_INFO.ESTADO                      = 'Activo'
      AND EXISTS
        (SELECT 1
        FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE_FIN
        WHERE ENLACE_FIN.INTERFACE_ELEMENTO_FIN_ID = ENLACE_INFO.INTERFACE_ELEMENTO_INI_ID
        AND ESTADO                                 = 'Activo'
        )
      ) BUFFER_DATA,
      (SELECT
        (SELECT
          (SELECT HILO.NUMERO_HILO
            ||', '
            ||HILO.COLOR_HILO
          FROM DB_INFRAESTRUCTURA.INFO_BUFFER_HILO BUFFER_HILO,
            DB_INFRAESTRUCTURA.ADMI_HILO HILO
          WHERE BUFFER_HILO.HILO_ID      = HILO.ID_HILO
          AND BUFFER_HILO.ESTADO         = 'Activo'
          AND HILO.ESTADO                = 'Activo'
          AND BUFFER_HILO.ID_BUFFER_HILO = ENLACE.BUFFER_HILO_ID
          ) BUFFER
        FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE
        WHERE ENLACE.INTERFACE_ELEMENTO_FIN_ID = ENLACE_INFO.INTERFACE_ELEMENTO_INI_ID
        AND ENLACE.ESTADO                      = 'Activo'
        ) BUFFER
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE_INFO
      WHERE ENLACE_INFO.INTERFACE_ELEMENTO_FIN_ID = TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID
      AND ENLACE_INFO.ESTADO                      = 'Activo'
      AND EXISTS
        (SELECT 1
        FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE_FIN
        WHERE ENLACE_FIN.INTERFACE_ELEMENTO_FIN_ID = ENLACE_INFO.INTERFACE_ELEMENTO_INI_ID
        AND ESTADO                                 = 'Activo'
        )
      ) HILO,
      (SELECT
        (SELECT
          (SELECT CLASE_TIPO_MEDIO.NOMBRE_CLASE_TIPO_MEDIO
          FROM DB_INFRAESTRUCTURA.INFO_BUFFER_HILO BUFFER_HILO,
            DB_INFRAESTRUCTURA.ADMI_HILO HILO,
            DB_INFRAESTRUCTURA.ADMI_CLASE_TIPO_MEDIO CLASE_TIPO_MEDIO
          WHERE BUFFER_HILO.HILO_ID      = HILO.ID_HILO
          AND HILO.CLASE_TIPO_MEDIO_ID   = CLASE_TIPO_MEDIO.ID_CLASE_TIPO_MEDIO
          AND BUFFER_HILO.ESTADO         = 'Activo'
          AND HILO.ESTADO                = 'Activo'
          AND BUFFER_HILO.ID_BUFFER_HILO = ENLACE.BUFFER_HILO_ID
          ) BUFFER
        FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE
        WHERE ENLACE.INTERFACE_ELEMENTO_FIN_ID = ENLACE_INFO.INTERFACE_ELEMENTO_INI_ID
        AND ENLACE.ESTADO                      = 'Activo'
        ) BUFFER
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE_INFO
      WHERE ENLACE_INFO.INTERFACE_ELEMENTO_FIN_ID = TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID
      AND ENLACE_INFO.ESTADO                      = 'Activo'
      AND EXISTS
        (SELECT 1
        FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE_FIN
        WHERE ENLACE_FIN.INTERFACE_ELEMENTO_FIN_ID = ENLACE_INFO.INTERFACE_ELEMENTO_INI_ID
        AND ESTADO                                 = 'Activo'
        )
      ) CLASE_TIPO_MEDIO,
      SERVICIO.ESTADO,
      CASE
        WHEN PLAN_CAB.NOMBRE_PLAN IS NULL
        THEN PROD.DESCRIPCION_PRODUCTO
        ELSE PLAN_CAB.NOMBRE_PLAN
      END NOMBRE_PRODUCTO_PLAN
      --PROD.NOMBRE_TECNICO
    FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
    INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO
    ON MODELO.ID_MODELO_ELEMENTO = ELEMENTO.MODELO_ELEMENTO_ID
    INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA
    ON MARCA.ID_MARCA_ELEMENTO = MODELO.MARCA_ELEMENTO_ID
    INNER JOIN DB_INFRAESTRUCTURA.INFO_IP ELEMENTO_IP
    ON ELEMENTO_IP.ELEMENTO_ID = ELEMENTO.ID_ELEMENTO
    INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TECNICO
    ON TECNICO.ELEMENTO_ID = ELEMENTO.ID_ELEMENTO
    INNER JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_ELEMENTO
    ON INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO = TECNICO.INTERFACE_ELEMENTO_ID
    INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
    ON SERVICIO.ID_SERVICIO = TECNICO.SERVICIO_ID
    INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
    ON PUNTO.ID_PUNTO = SERVICIO.PUNTO_ID
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
    ON PLAN_DET.PLAN_ID = SERVICIO.PLAN_ID
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
    ON PLAN_CAB.ID_PLAN = PLAN_DET.PLAN_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO P
    ON P.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
    ON PROD.ID_PRODUCTO        = SERVICIO.PRODUCTO_ID
    WHERE ELEMENTO.ID_ELEMENTO = CN_ID_ELEMENTO--2171565
    AND ((P.NOMBRE_TECNICO    IN
      (SELECT VALOR2 AS NOMBRE_TECNICO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID IN
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
        AND ESTADO             = 'Activo'
        )
      AND VALOR1 = 'PRODUCTO_MD'
      )
    AND P.ESTADO              = 'Activo'
    AND P.EMPRESA_COD         = LV_CODEMPRESAMD
    AND PLAN_DET.ESTADO      <> 'Eliminado')
    OR ((PROD.NOMBRE_TECNICO IN
      (SELECT VALOR2 AS NOMBRE_TECNICO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID IN
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
        AND ESTADO             = 'Activo'
        )
      AND VALOR1 = 'PRODUCTO_TN'
      )
    OR PROD.DESCRIPCION_PRODUCTO = 'SAFE ANALYTICS CAM')
    AND PROD.ESTADO              = 'Activo'
    AND PROD.EMPRESA_COD         IN(LV_CODEMPRESATN,LV_CODEMPRESAMD)))
    AND SERVICIO.ESTADO NOT     IN
      (SELECT VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID IN
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
        AND ESTADO             = 'Activo'
        )
      AND VALOR1 = 'ESTADO_SERVICIO'
      );
    CURSOR LC_GETCONFIGNFSMIGRAAD
    IS
      SELECT TO_CHAR(CODIGO_APP) AS CODIGO_APP,
        TO_CHAR(CODIGO_PATH)     AS CODIGO_PATH
      FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS
      WHERE APLICACION ='TelcosWeb'
      AND SUBMODULO    = 'MigracionOltAltaDensidad'
      AND EMPRESA      ='MD';
    LV_PARAMSGUARDARARCHIVO    VARCHAR2(4000);
    LV_RESPUESTAGUARDARARCHIVO VARCHAR2(4000);
    LV_URLMICROSERVICIONFS     VARCHAR2(500);
    LV_CODIGOAPPCORTEMASIVO    VARCHAR2(20);
    LV_CODIGOPATHCORTEMASIVO   VARCHAR2(20);
    LN_CODEGUARDARARCHIVO      NUMBER;
    LN_COUNTARCHIVOSGUARDADOS  NUMBER;
    LV_PATHGUARDARARCHIVO      VARCHAR2(4000);
    LN_IDDOCUMENTO DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    LE_EXCEPTION_NFS EXCEPTION;
    LC_GET_ELEMENTO_OLT C_GET_OLT_MIGRACION%ROWTYPE;
    LC_DATA_TECNICA_OLT C_DATA_TECNICA_OLT%ROWTYPE;
    LC_GET_REMITENTE_ASUNTO C_GET_REMITENTE_ASUNTO%ROWTYPE;
    LR_REGGETVALORESPARAMSGENERAL LC_GETVALORESPARAMSGENERAL%ROWTYPE;
    LR_GETCONFIGNFSMIGRAAD LC_GETCONFIGNFSMIGRAAD%ROWTYPE;
    LV_REPORTE_PREVIO_OP VARCHAR2(50) := 'ReportePrevio';
    LV_TIPO_PLANTILLA    VARCHAR2(50);
  BEGIN
    IF PV_TIPOREPORTE         = LV_REPORTE_PREVIO_OP THEN
      LV_NOTI_PARAMETRO      := 'NOTIFICACIONES_PREV_TECNICA';
      LV_NOMBREARCHIVOCORREO := 'REPORTE_DATA_TECNICA_PREVIO_'||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')||'.csv';
      LV_TIPO_PLANTILLA      := 'OLT_MIGRA_PREV';
    ELSE
      LV_NOTI_PARAMETRO      := 'NOTIFICACIONES_POST_TECNICA';
      LV_NOMBREARCHIVOCORREO := 'REPORTE_DATA_TECNICA_MIGRADO_'||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')||'.csv';
      LV_TIPO_PLANTILLA      := 'OLT_MIGRA_POST';
    END IF;
    OPEN LC_GETVALORESPARAMSGENERAL(LV_NOMBREPARAMETRODIRCSV);
    FETCH LC_GETVALORESPARAMSGENERAL INTO LR_REGGETVALORESPARAMSGENERAL; --Lv_Directorio, Lv_RutaDirectorio;
    CLOSE LC_GETVALORESPARAMSGENERAL;
    LV_DIRECTORIOBASEDATOS    := LR_REGGETVALORESPARAMSGENERAL.VALOR1;
    IF LV_DIRECTORIOBASEDATOS IS NULL THEN
      LV_MSJERROR             := 'No se ha podido obtener el directorio para guardar los archivos csv';
      RAISE LE_EXCEPTION;
    END IF;
    LV_RUTADIRECTORIOBASEDATOS    := LR_REGGETVALORESPARAMSGENERAL.VALOR2;
    IF LV_RUTADIRECTORIOBASEDATOS IS NULL THEN
      LV_MSJERROR                 := 'No se ha podido obtener la rura del directorio para guardar los archivos csv';
      RAISE LE_EXCEPTION;
    END IF;
    LR_REGGETVALORESPARAMSGENERAL := NULL;
    OPEN LC_GETVALORESPARAMSGENERAL(LV_NOMBREPARAMURLMICRONFS);
    FETCH LC_GETVALORESPARAMSGENERAL INTO LR_REGGETVALORESPARAMSGENERAL;
    CLOSE LC_GETVALORESPARAMSGENERAL;
    LV_URLMICROSERVICIONFS    := LR_REGGETVALORESPARAMSGENERAL.VALOR1;
    IF LV_URLMICROSERVICIONFS IS NULL THEN
      LV_MSJERROR             := 'No se ha podido obtener la URL del NFS';
      RAISE LE_EXCEPTION;
    END IF;
    OPEN LC_GETCONFIGNFSMIGRAAD;
    FETCH LC_GETCONFIGNFSMIGRAAD INTO LR_GETCONFIGNFSMIGRAAD;
    CLOSE LC_GETCONFIGNFSMIGRAAD;
    LV_CODIGOAPPCORTEMASIVO    := LR_GETCONFIGNFSMIGRAAD.CODIGO_APP;
    LV_CODIGOPATHCORTEMASIVO   := LR_GETCONFIGNFSMIGRAAD.CODIGO_PATH;
    IF LV_CODIGOAPPCORTEMASIVO IS NULL OR LV_CODIGOPATHCORTEMASIVO IS NULL THEN
      LV_MSJERROR              := 'No se ha podido obtener la configuraci¿n de la ruta NFS';
      RAISE LE_EXCEPTION;
    END IF;
    OPEN C_GET_REMITENTE_ASUNTO(LV_NOTI_PARAMETRO);
    FETCH C_GET_REMITENTE_ASUNTO INTO LC_GET_REMITENTE_ASUNTO;
    CLOSE C_GET_REMITENTE_ASUNTO;
    LV_REMITENTE    := LC_GET_REMITENTE_ASUNTO.REMITENTE;
    LV_ASUNTO       := LC_GET_REMITENTE_ASUNTO.ASUNTO;
    IF LV_REMITENTE IS NULL OR LV_ASUNTO IS NULL THEN
      LV_MENSAJE    := 'No se ha podido obtener el remitente y/o el asunto del correo con el archivo adjunto de cambio de plan masivo';
      RAISE LE_EXCEPTION;
    END IF;
    LF_ARCHIVOPROCESOMASIVO := UTL_FILE.FOPEN(LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREO, 'w', 5000);
    UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO,'NOMBRE_ELEMENTO|NOMBRE_MODELO|NOMBRE_MARCA|IP|INTERFACE_ELEMENTO|LOGIN|ONT_ID|LINE_PROFILE_NAME|SERVICE_PORT_ID|GEM_PORT|TRAFFIC_TABLE|VLAN|APROVISIONAMIENTO_IP_ELEMENTO|ULTIMA_MILLA|NOMBRE_ELEMENTO_CONTENEDOR|INTERFACE_ELEMENTO_CONECTOR|BUFFER|HILO|CLASE_TIPO_MEDIO|ESTADO|NOMBRE_PRODUCTO_PLAN');
    FOR LC_GET_ELEMENTO_OLT IN C_GET_OLT_MIGRACION
    LOOP
      IF LV_OLT_ASUNTO IS NULL THEN
        LV_OLT_ASUNTO  := LC_GET_ELEMENTO_OLT.INFORMACION;
      ELSE
        LV_OLT_ASUNTO := LV_OLT_ASUNTO||' - '||LC_GET_ELEMENTO_OLT.INFORMACION;
      END IF;
      FOR LC_DATA_TECNICA_OLT IN C_DATA_TECNICA_OLT(LC_GET_ELEMENTO_OLT.VALOR)
      LOOP
        UTL_FILE.PUT_LINE(LF_ARCHIVOPROCESOMASIVO, LC_DATA_TECNICA_OLT.NOMBRE_ELEMENTO || LV_SEPARADOR || LC_DATA_TECNICA_OLT.NOMBRE_MODELO_ELEMENTO || LV_SEPARADOR || LC_DATA_TECNICA_OLT.NOMBRE_MARCA_ELEMENTO || LV_SEPARADOR || LC_DATA_TECNICA_OLT.IP || LV_SEPARADOR || LC_DATA_TECNICA_OLT.NOMBRE_INTERFACE_ELEMENTO || LV_SEPARADOR || LC_DATA_TECNICA_OLT.LOGIN || LV_SEPARADOR || LC_DATA_TECNICA_OLT.ONT_ID || LV_SEPARADOR || LC_DATA_TECNICA_OLT.LINE_PROFILE_NAME || LV_SEPARADOR || LC_DATA_TECNICA_OLT.SERVICE_PORT_ID || LV_SEPARADOR || LC_DATA_TECNICA_OLT.GEM_PORT || LV_SEPARADOR || LC_DATA_TECNICA_OLT.TRAFFIC_TABLE || LV_SEPARADOR || LC_DATA_TECNICA_OLT.VLAN || LV_SEPARADOR || LC_DATA_TECNICA_OLT.APROVISIONAMIENTO_IP_ELEMENTO || LV_SEPARADOR || LC_DATA_TECNICA_OLT.ULTIMA_MILLA || LV_SEPARADOR || LC_DATA_TECNICA_OLT.NOMBRE_ELEMENTO_CONTENEDOR || LV_SEPARADOR || LC_DATA_TECNICA_OLT.INTERFACE_ELEMENTO_CONECTOR || LV_SEPARADOR || LC_DATA_TECNICA_OLT.BUFFER_DATA || LV_SEPARADOR ||
        LC_DATA_TECNICA_OLT.HILO || LV_SEPARADOR || LC_DATA_TECNICA_OLT.CLASE_TIPO_MEDIO || LV_SEPARADOR || LC_DATA_TECNICA_OLT.ESTADO || LV_SEPARADOR || LC_DATA_TECNICA_OLT.NOMBRE_PRODUCTO_PLAN);
        LN_CONTADORREG := LN_CONTADORREG + 1;
      END LOOP;
    END LOOP;
    UTL_FILE.FCLOSE(LF_ARCHIVOPROCESOMASIVO);
    IF LN_CONTADORREG = 0 THEN
      LV_MSJERROR    := 'No se han encontrado datos para los olt seleccionados';
      RAISE LE_EXCEPTION;
    END IF;
    LV_ASUNTO                                   := REPLACE(LV_ASUNTO, '{{NOMBRE_OLT}}', LV_OLT_ASUNTO);
    LR_GETALIASPLANTILLACORREO                  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(LV_TIPO_PLANTILLA);
    LV_PLANTILLA                                := LR_GETALIASPLANTILLACORREO.PLANTILLA;
    IF LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS IS NOT NULL THEN
      LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS  := REPLACE(LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, ';', ',') || ',';
    ELSE
      LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS := LV_REMITENTE || ',';
    END IF;
    IF LV_PLANTILLA IS NULL THEN
      LV_MENSAJE    := 'No se ha podido obtener la plantilla del correo enviado al procesar un archivo csv';
      RAISE LE_EXCEPTION;
    END IF;
    BEGIN
      LV_PARAMSGUARDARARCHIVO       := 'URL NFS: ' || LV_URLMICROSERVICIONFS || ', RUTA_DIRECTORIO: ' || LV_RUTADIRECTORIOBASEDATOS 
                                        || ', NOMBRE_ARCHIVO: ' || LV_NOMBREARCHIVOCORREO || ', CODIGO_APP: ' 
                                        || LV_CODIGOAPPCORTEMASIVO || ', CODIGO_PATH: ' || LV_CODIGOPATHCORTEMASIVO;
      LV_RESPUESTAGUARDARARCHIVO    := DB_GENERAL.GNRLPCK_UTIL.F_GUARDAR_ARCHIVO_NFS( LV_URLMICROSERVICIONFS, LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO, LV_NOMBREARCHIVOCORREO, NULL, LV_CODIGOAPPCORTEMASIVO, LV_CODIGOPATHCORTEMASIVO);
      IF LV_RESPUESTAGUARDARARCHIVO IS NULL THEN
        LV_MSJERROR                 := 'No se ha podido guardar el archivo de manera correcta en el NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      APEX_JSON.PARSE(LV_RESPUESTAGUARDARARCHIVO);
      LN_CODEGUARDARARCHIVO    := APEX_JSON.GET_NUMBER('code');
      IF LN_CODEGUARDARARCHIVO IS NULL OR LN_CODEGUARDARARCHIVO <> 200 THEN
        LV_MSJERROR            := 'Ha ocurrido alg¿n error al generar el archivo en el NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      LN_COUNTARCHIVOSGUARDADOS    := APEX_JSON.GET_COUNT(P_PATH => 'data');
      IF LN_COUNTARCHIVOSGUARDADOS IS NULL THEN
        LV_MSJERROR                := 'No se ha generado correctamente la ruta del archivo en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      IF LN_COUNTARCHIVOSGUARDADOS <> 1 THEN
        LV_MSJERROR                := 'Ha ocurrido un error inesperado al generar el archivo en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      FOR I IN 1 .. LN_COUNTARCHIVOSGUARDADOS
      LOOP
        LV_PATHGUARDARARCHIVO := APEX_JSON.GET_VARCHAR2(P_PATH => 'data[%d].pathFile', P0 => I);
      END LOOP;
      IF LV_PATHGUARDARARCHIVO IS NULL THEN
        LV_MSJERROR            := 'No se ha podido obtener la ruta en la que se encuentra el archivo generado en el servidor NFS. Por favor consulte al Dep. de Sistemas!';
        RAISE LE_EXCEPTION_NFS;
      END IF;
      LN_IDDOCUMENTO := DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL;
      INSERT
      INTO DB_COMUNICACION.INFO_DOCUMENTO
        (
          ID_DOCUMENTO,
          NOMBRE_DOCUMENTO,
          UBICACION_LOGICA_DOCUMENTO,
          UBICACION_FISICA_DOCUMENTO,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          MENSAJE,
          EMPRESA_COD
        )
        VALUES
        (
          LN_IDDOCUMENTO,
          'Archivo generado por consulta previo a la migracion olt alta densidad',
          LV_NOMBREARCHIVOCORREO,
          LV_PATHGUARDARARCHIVO,
          LV_USRCONSULTA,
          SYSDATE,
          '127.0.0.1',
          'Guardado',
          'Documento que se genera al exportar consulta en el reporte previo a la migracion olt alta densidad',
          '18'
        );
      COMMIT;
    EXCEPTION
        WHEN LE_EXCEPTION_NFS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REPORTE_MIGRA_PREV_DATA_TECN->ENVIO_NFS', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR : ' || LV_MSJERROR ||
          '-- PARAMETROS GUARDAR EN NFS->' || LV_PARAMSGUARDARARCHIVO ||
          ' -- RESPUESTA GUARDAR EN NFS->' || LV_RESPUESTAGUARDARARCHIVO,
          'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        WHEN OTHERS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REPORTE_MIGRA_PREV_DATA_TECN->ENVIO_NFS', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR_STACK: ' ||
          DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || 
          '-- PARAMETROS GUARDAR EN NFS->' || LV_PARAMSGUARDARARCHIVO ||
          ' -- RESPUESTA GUARDAR EN NFS->' || LV_RESPUESTAGUARDARARCHIVO,
          'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END;
    LV_PLANTILLA              := REPLACE(LV_PLANTILLA, '{{NOMBRE_OLT}}', LV_OLT_ASUNTO);
    LV_GZIP                   := 'gzip ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO;
    LV_NOMBREARCHIVOCORREOZIP := LV_NOMBREARCHIVOCORREO || '.gz';
    DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(LV_GZIP));
    BEGIN
      DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(LV_REMITENTE, LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, LV_ASUNTO, LV_PLANTILLA, LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREOZIP);
    EXCEPTION
    WHEN OTHERS THEN
      UTL_MAIL.SEND ( SENDER => LV_REMITENTE, RECIPIENTS => LR_GETALIASPLANTILLACORREO.ALIAS_CORREOS, SUBJECT => LV_ASUNTO, MESSAGE => SUBSTR(LV_PLANTILLA, 1, 32767), MIME_TYPE => 'text/html; charset=iso-8859-1');
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_REPORTE_MIGRA_PREV_DATA_TECN->ENVIO_CORREO', 'No se ha podido enviar el archivo en la ruta ' || LV_RUTADIRECTORIOBASEDATOS || LV_NOMBREARCHIVOCORREO || ' ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END;
    UTL_FILE.FREMOVE(LV_DIRECTORIOBASEDATOS, LV_NOMBREARCHIVOCORREOZIP);
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'OK';
  EXCEPTION
  WHEN LE_EXCEPTION THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'ERROR : '||LV_MSJERROR;
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'ERROR : '||SQLERRM || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_REPORTE_MIGRA_PREV_DATA_TECN;
  PROCEDURE P_ACTUALIZA_TABLA_MIGRACION
    (
      PV_ESTADO_ERR_CAB  VARCHAR2,
      PV_MENSAJE_CAB     VARCHAR2,
      PV_TIPO_CAB        VARCHAR2,
      PV_ESTADO_CAB      VARCHAR2,
      PV_ESTADO_DATA_ERR VARCHAR2,
      PV_MENSAJE_DATA    VARCHAR2,
      PV_TIPO_DATA       VARCHAR2,
      PV_ESTADO_DATA     VARCHAR2
    )
  IS
  BEGIN
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
    SET ESTADO    = PV_ESTADO_ERR_CAB,
      OBSERVACION = PV_MENSAJE_CAB
    WHERE TIPO    = PV_TIPO_CAB
    AND ESTADO    = PV_ESTADO_CAB;
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DATA
    SET ESTADO              = PV_ESTADO_DATA_ERR,
      OBSERVACION           = PV_MENSAJE_DATA
    WHERE MIGRACION_CAB_ID IN
      (SELECT ID_MIGRACION_CAB
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
      WHERE TIPO = PV_TIPO_CAB
      AND ESTADO = PV_ESTADO_ERR_CAB
      )
    AND TIPO_PROCESO = PV_TIPO_DATA
    AND ESTADO       = PV_ESTADO_DATA;
    COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR: '||SQLERRM);
  END;
  PROCEDURE P_ENVIA_REPORTE_PREV_MIGRACION(
      PV_USRCONSULTA IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  AS
    LE_EXCEPTION    EXCEPTION;
    LV_STATUS       VARCHAR2(150);
    LV_MENSAJE      VARCHAR2(4000);
    LV_USR_CONSULTA VARCHAR2(150) := PV_USRCONSULTA;
  BEGIN
    P_REPORTE_MIGRA_PREV_DATA_TECN( PV_USRCONSULTA => LV_USR_CONSULTA, PV_TIPOREPORTE => 'ReportePrevio', PV_STATUS => LV_STATUS, PV_MENSAJE => LV_MENSAJE);
    IF LV_STATUS = 'ERROR' THEN
      RAISE LE_EXCEPTION;
    END IF;
    LV_STATUS  := NULL;
    LV_MENSAJE := NULL;
    P_REPORTE_MIGRA_PREV_ENLACE( PV_USRCONSULTA => LV_USR_CONSULTA, PV_STATUS => LV_STATUS, PV_MENSAJE => LV_MENSAJE);
    IF LV_STATUS = 'ERROR' THEN
      RAISE LE_EXCEPTION;
    END IF;
    P_ACTUALIZA_TABLA_MIGRACION( PV_ESTADO_ERR_CAB => 'Ok', PV_MENSAJE_CAB => 'Se ha enviado correo con los reportes adjuntos previo a la migracion olt alta densidad', PV_TIPO_CAB => 'ReporteMigracion', PV_ESTADO_CAB => 'Pendiente', PV_ESTADO_DATA_ERR => 'Ok', PV_MENSAJE_DATA => 'Ok', PV_TIPO_DATA => 'ReportePrevio', PV_ESTADO_DATA => 'Pendiente');
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'OK';
  EXCEPTION
  WHEN LE_EXCEPTION THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'ERROR : '||LV_MENSAJE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_ENVIA_REPORTE_PREV_MIGRACION', SUBSTR(SQLCODE || ' -ERROR- ' || PV_MENSAJE,0,4000), LV_USR_CONSULTA, SYSDATE, '127.0.0.0');
    P_ACTUALIZA_TABLA_MIGRACION( PV_ESTADO_ERR_CAB => 'Error', PV_MENSAJE_CAB => PV_MENSAJE, PV_TIPO_CAB => 'ReporteMigracion', PV_ESTADO_CAB => 'Pendiente', PV_ESTADO_DATA_ERR => 'Error', PV_MENSAJE_DATA => 'Error', PV_TIPO_DATA => 'ReportePrevio', PV_ESTADO_DATA => 'Pendiente');
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ENVIA_REPORTE_PREV_MIGRACION', SUBSTR(SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    P_ACTUALIZA_TABLA_MIGRACION( PV_ESTADO_ERR_CAB => 'Error', PV_MENSAJE_CAB => PV_MENSAJE, PV_TIPO_CAB => 'ReporteMigracion', PV_ESTADO_CAB => 'Pendiente', PV_ESTADO_DATA_ERR => 'Error', PV_MENSAJE_DATA => 'Error', PV_TIPO_DATA => 'ReportePrevio', PV_ESTADO_DATA => 'Pendiente');
  END P_ENVIA_REPORTE_PREV_MIGRACION;
  FUNCTION F_GET_VALIDACION_CADENA(
      FV_CADENA IN VARCHAR2)
    RETURN VARCHAR2
  IS
    CURSOR C_COUNT_PIPE(CV_CADENA VARCHAR2)
    IS
      SELECT LENGTH(CV_CADENA) - LENGTH(REPLACE(CV_CADENA,'|')) COUNT_PIPE
      FROM DUAL;
    LV_CADENA        VARCHAR2(4000) := FV_CADENA;
    LV_MENSAJE       VARCHAR2(4000);
    LV_SEPARADOR     VARCHAR2(1) := '|';
    LN_PIPE_ITERATOR NUMBER;
    LN_COUNT_CADENA  NUMBER;
    LE_EXCEPTION     EXCEPTION;
  BEGIN
    OPEN C_COUNT_PIPE(LV_CADENA);
    FETCH C_COUNT_PIPE INTO LN_PIPE_ITERATOR;
    CLOSE C_COUNT_PIPE;
    IF LN_PIPE_ITERATOR = 0 THEN
      LV_MENSAJE       := 'LA CADENA NO TIENE EL FORMATO DE PIPE PERMITIDO, NO SE HAN ENCONTRADO CADENAS ENLAZADAS POR PIPE.';
      RAISE LE_EXCEPTION;
    END IF;
    FOR I IN 1 .. LN_PIPE_ITERATOR + 1
    LOOP
      SELECT INSTR(LV_CADENA,LV_SEPARADOR) INTO LN_COUNT_CADENA FROM DUAL;
      IF LN_COUNT_CADENA = 1 OR LN_COUNT_CADENA IS NULL THEN
        IF LV_MENSAJE   IS NULL THEN
          LV_MENSAJE    := 'NO SE HA ENCONTRADO REGISTRO EN LA COLUMNA '|| I;
        ELSE
          LV_MENSAJE := LV_MENSAJE ||' - NO SE HA ENCONTRADO REGISTRO EN LA COLUMNA '|| I;
        END IF;
      END IF;
      SELECT SUBSTR(LV_CADENA,LN_COUNT_CADENA+1,LENGTH(LV_CADENA))
      INTO LV_CADENA
      FROM DUAL;
    END LOOP;
    RETURN LV_MENSAJE;
  EXCEPTION
  WHEN LE_EXCEPTION THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_VALIDACION_CADENA', LV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN LV_MENSAJE;
  WHEN OTHERS THEN
    LV_MENSAJE := 'ERROR';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.F_GET_VALIDACION_CADENA', 'ERROR ORACLE: '||SQLERRM, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN LV_MENSAJE;
  END F_GET_VALIDACION_CADENA;
  PROCEDURE P_VALIDA_ESTADO_MIGRACION(
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  IS
    CURSOR C_VALIDA_ESTADO
    IS
      SELECT COUNT(1) AS COUNT_REG
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
      WHERE TIPO     IN ('ArchivosMigracion','MIGRACION')
      AND ESTADO NOT IN ('MigradoConErrores','ReversadoConErrores','Migrado','Reversado','Error');
    LV_STATUS  VARCHAR2(25);
    LV_MENSAJE VARCHAR2(2000);
    LN_VALIDA  NUMBER := 0;
  BEGIN
    OPEN C_VALIDA_ESTADO;
    FETCH C_VALIDA_ESTADO INTO LN_VALIDA;
    CLOSE C_VALIDA_ESTADO;
    IF LN_VALIDA  = 0 THEN
      LV_STATUS  := 'OK';
      LV_MENSAJE := 'OK';
    ELSE
      LV_STATUS  := 'EN_EJECUCION';
      LV_MENSAJE := 'Existe una migracion en curso, por favor espere o intentelo mas tarde.';
    END IF;
    PV_STATUS  := LV_STATUS;
    PV_MENSAJE := LV_MENSAJE;
  EXCEPTION
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'ERROR: '||SQLERRM;
  END P_VALIDA_ESTADO_MIGRACION;
  PROCEDURE P_REVERSO_POR_ELEMENTO(
      PV_NOMBRE_OLT IN VARCHAR2,
      PV_IP_OLT     IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  IS
    LV_USR_CREACION       VARCHAR2(100):= 'migracion';
    LV_IP_CREACION        VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    LV_IP_OLT             VARCHAR2(25) := PV_IP_OLT;
    LV_NOMBRE_OLT         VARCHAR2(50) := PV_NOMBRE_OLT;
    LV_ESTADO_MIGRADO     VARCHAR2(25) := 'Migrado';
    LV_ESTADO_MIGRADO_ERR VARCHAR2(25) := 'MigradoConErrores';
    LV_ESTADO_REVERSO     VARCHAR2(25) := 'PendienteReverso';
    LV_ESTADO_OK          VARCHAR2(25) := 'Ok';
    LV_TIPO_REG_OLT       VARCHAR2(25) := 'OLT';
    LV_TIPO_REG_ENLACE    VARCHAR2(25) := 'ENLACE';
    LV_TIPO_REG_SCOPE     VARCHAR2(25) := 'SCOPE';
    LE_EXCEPTION          EXCEPTION;
    LV_MENSAJE_ERR        VARCHAR2(4000);
    LN_MAX_MIGRA_CAB_ID   NUMBER;
    LN_EXISTS_OLT_MIGRA   NUMBER;
    CURSOR C_GET_MAX_ID_CAB
    IS
      SELECT MAX(ID_MIGRACION_CAB) AS MAX_ID
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
      WHERE ESTADO IN (LV_ESTADO_MIGRADO,LV_ESTADO_MIGRADO_ERR);
    CURSOR C_GET_INFO_ELEMENTO (CV_NOMBRE_ELEMENTO VARCHAR2)
    IS
      SELECT IE.NOMBRE_ELEMENTO,
        IP.IP
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO IE,
        DB_INFRAESTRUCTURA.INFO_IP IP
      WHERE IE.ID_ELEMENTO   = IP.ELEMENTO_ID
      AND IE.NOMBRE_ELEMENTO = CV_NOMBRE_ELEMENTO;
    CURSOR C_GET_EXISTS_OLT_MIGRA (CV_NOMBRE_OLT VARCHAR2, CN_MIGRACION_CAB_ID NUMBER)
    IS
      SELECT COUNT(1) AS COUNT_REG
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
      WHERE MIGRACION_CAB_ID = CN_MIGRACION_CAB_ID
      AND TIPO_REGISTRO      = LV_TIPO_REG_OLT
      AND ELEMENTO_B         = CV_NOMBRE_OLT;
    LC_GET_INFO_ELEMENTO C_GET_INFO_ELEMENTO%ROWTYPE;
  BEGIN
    IF LV_NOMBRE_OLT IS NULL THEN
      LV_MENSAJE_ERR := 'El nombre del elemento enviado como parametro se encuentra vacio.';
      RAISE LE_EXCEPTION;
    END IF;
    IF LV_IP_OLT     IS NULL THEN
      LV_MENSAJE_ERR := 'La ip del del elemento enviado como parametro se encuentra vacio.';
      RAISE LE_EXCEPTION;
    END IF;
    OPEN C_GET_INFO_ELEMENTO(LV_NOMBRE_OLT);
    FETCH C_GET_INFO_ELEMENTO INTO LC_GET_INFO_ELEMENTO;
    CLOSE C_GET_INFO_ELEMENTO;
    IF LC_GET_INFO_ELEMENTO.NOMBRE_ELEMENTO IS NULL THEN
      LV_MENSAJE_ERR                        := 'El elemento enviado '||LV_NOMBRE_OLT||' no existe.';
      RAISE LE_EXCEPTION;
    END IF;
    IF LC_GET_INFO_ELEMENTO.IP <> LV_IP_OLT THEN
      LV_MENSAJE_ERR           := 'La ip del elemento enviado '||LV_IP_OLT||' es diferente a la ip del elemento registrado '||LC_GET_INFO_ELEMENTO.IP;
      RAISE LE_EXCEPTION;
    END IF;
    OPEN C_GET_MAX_ID_CAB;
    FETCH C_GET_MAX_ID_CAB INTO LN_MAX_MIGRA_CAB_ID;
    CLOSE C_GET_MAX_ID_CAB;
    IF LN_MAX_MIGRA_CAB_ID = 0 OR LN_MAX_MIGRA_CAB_ID IS NULL THEN
      LV_MENSAJE_ERR      := 'No se ha encontrado cabecera en estado Migrado.';
      RAISE LE_EXCEPTION;
    END IF;
    OPEN C_GET_EXISTS_OLT_MIGRA(LV_NOMBRE_OLT,LN_MAX_MIGRA_CAB_ID);
    FETCH C_GET_EXISTS_OLT_MIGRA INTO LN_EXISTS_OLT_MIGRA;
    CLOSE C_GET_EXISTS_OLT_MIGRA;
    IF LN_EXISTS_OLT_MIGRA = 0 OR LN_EXISTS_OLT_MIGRA IS NULL THEN
      LV_MENSAJE_ERR      := 'No se ha el elemento olt '||LV_NOMBRE_OLT||' dentro del ultimo proceso de migracion.';
      RAISE LE_EXCEPTION;
    END IF;
    UPDATE DB_INFRAESTRUCTURA.INFO_MIGRA_AD_CAB
    SET ESTADO             = LV_ESTADO_REVERSO
    WHERE ID_MIGRACION_CAB = LN_MAX_MIGRA_CAB_ID;
    COMMIT;
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Se ha enviando a ejecutar el proceso de rollback.';
  EXCEPTION
  WHEN LE_EXCEPTION THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'ERROR: '|| LV_MENSAJE_ERR;
  WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'ERROR: '||SQLERRM;
  END P_REVERSO_POR_ELEMENTO;
  PROCEDURE P_REVERSAR_SCOPES(
      PN_MIGRACION_CAB_ID IN NUMBER,
      PV_ERROR OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  IS
    LV_STATUS         VARCHAR2(50);
    LN_MIGRA_CAB_ID   NUMBER := PN_MIGRACION_CAB_ID;
    LN_IDMIGRACIONDET NUMBER;
    LV_TIPOREGISTRO   VARCHAR2(15) := 'SCOPE';
    LV_ESTADO         VARCHAR2(30) := 'Activo';
    LV_ESTADOOK       VARCHAR2(30) := 'Ok';
    LV_ESTADOERROR    VARCHAR2(30) := 'Error';
    LV_MENSAJE        VARCHAR2(4000);
    LN_COUNT_MIGRA    NUMBER;
    LN_COUNT_REVER    NUMBER;
    CURSOR C_GET_SCOPE_MIGRADOS (CN_MIGRACION_CAB_ID NUMBER)
    IS
      SELECT ELEMENTO_A AS NOMBRE_SCOPE_ANTERIOR,
        ELEMENTO_B      AS NOMBRE_SCOPE_MIGRADO,
        ID_MIGRACION_DET
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
      WHERE MIGRACION_CAB_ID = CN_MIGRACION_CAB_ID
      AND TIPO_REGISTRO      = LV_TIPOREGISTRO
      AND ESTADO             = LV_ESTADOOK;
    CURSOR C_GET_INFO_MIGRA_SCOPE(CN_ELEMENTO_OLT_ID NUMBER, CV_NOMBRE_SCOPE_A VARCHAR2)
    IS
      SELECT ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID  = CN_ELEMENTO_OLT_ID
      AND DETALLE_NOMBRE = LV_TIPOREGISTRO
      AND DETALLE_VALOR  = CV_NOMBRE_SCOPE_A;
    CURSOR C_GET_OLT_BY_SCOPE (CV_NOMBRE_SCOPE VARCHAR2)
    IS
      SELECT ELEMENTO_ID
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE DETALLE_NOMBRE = LV_TIPOREGISTRO
      AND DETALLE_VALOR    = CV_NOMBRE_SCOPE
      GROUP BY ELEMENTO_ID;
    CURSOR C_GET_INFO_MIGRA_REFSUBRED (CN_ELEMENTO_OLT_ID NUMBER, CN_REF_DETALLE_ELEMENTO_ID NUMBER)
    IS
      SELECT ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID       = CN_ELEMENTO_OLT_ID
      AND DETALLE_NOMBRE      = 'SUBRED'
      AND ID_DETALLE_ELEMENTO = CN_REF_DETALLE_ELEMENTO_ID;
    CURSOR C_GET_INFO_MIGRA_SUBRED (CN_ID_SUBRED NUMBER)
    IS
      SELECT ID_SUBRED,
        RED_ID,
        SUBRED,
        MASCARA,
        GATEWAY,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        ESTADO,
        ELEMENTO_ID,
        NOTIFICACION,
        IP_INICIAL,
        IP_FINAL,
        IP_DISPONIBLE,
        TIPO,
        USO,
        SUBRED_ID,
        EMPRESA_COD,
        PREFIJO_ID,
        CANTON_ID,
        VERSION_IP,
        ANILLO
      FROM DB_INFRAESTRUCTURA.INFO_SUBRED
      WHERE ID_SUBRED = CN_ID_SUBRED;
    CURSOR C_GET_INFO_MIGRA_SUBRED_PRIMA (CN_ELEMENTO_OLT_ID NUMBER, CN_REF_DETALLE_ELEMENTO_ID NUMBER)
    IS
      SELECT ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID           = CN_ELEMENTO_OLT_ID
      AND DETALLE_NOMBRE          = 'SUBRED PRIMARIA'
      AND REF_DETALLE_ELEMENTO_ID = CN_REF_DETALLE_ELEMENTO_ID;
    CURSOR C_GET_INFO_MIGRA_TIPO_SCOPE (CN_ELEMENTO_OLT_ID NUMBER, CN_REF_DETALLE_ELEMENTO_ID NUMBER)
    IS
      SELECT ID_DETALLE_ELEMENTO,
        ELEMENTO_ID,
        DETALLE_NOMBRE,
        DETALLE_VALOR,
        DETALLE_DESCRIPCION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        REF_DETALLE_ELEMENTO_ID,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID           = CN_ELEMENTO_OLT_ID
      AND DETALLE_NOMBRE          = 'TIPO SCOPE'
      AND REF_DETALLE_ELEMENTO_ID = CN_REF_DETALLE_ELEMENTO_ID;
    CURSOR C_GET_INFO_MIGRA_SUBRED_TAG (CN_SUBRED_ID NUMBER)
    IS
      SELECT ID_SUBRED_TAG,
        SUBRED_ID,
        TAG_ID,
        USR_CREACION,
        FE_CREACION,
        ESTADO
      FROM DB_INFRAESTRUCTURA.INFO_SUBRED_TAG
      WHERE SUBRED_ID = CN_SUBRED_ID;
    CURSOR C_VALIDA_ESTADO_SUBRED(CN_ID_ELEMENTO NUMBER, CV_SCOPE VARCHAR2) IS
        SELECT  ID_SUBRED,
                NOMBRE_SCOPE,
                TIPO_SCOPE,
                IP_SCOPE_INI,
                IP_SCOPE_FIN,
                ESTADO_RED,
                NOMBRE_POLICY
        FROM 
        (SELECT ID_SUBRED,
          (SELECT EEE.DETALLE_VALOR
          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO EEE
          WHERE REF_DETALLE_ELEMENTO_ID=REFERENCIA_DETALLE_ELEMENTO_ID
          AND DETALLE_NOMBRE           = 'SCOPE'
          ) AS NOMBRE_SCOPE,
          (SELECT RRR.DETALLE_VALOR
          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO RRR
          WHERE REF_DETALLE_ELEMENTO_ID=REFERENCIA_DETALLE_ELEMENTO_ID
          AND DETALLE_NOMBRE           = 'TIPO SCOPE'
          ) AS TIPO_SCOPE,
          IP_SCOPE_INI,
          IP_SCOPE_FIN,
          ESTADO_RED,
          (SELECT NOMBRE_POLICY FROM DB_INFRAESTRUCTURA.ADMI_POLICY WHERE ID_POLICY=POLICESCOPE
          ) AS NOMBRE_POLICY
        FROM
          (SELECT ISD.ID_SUBRED AS ID_SUBRED,
            ISD.ESTADO          AS ESTADO_RED,
            ISD.IP_INICIAL      AS IP_SCOPE_INI,
            ISD.IP_FINAL        AS IP_SCOPE_FIN,
            ISD.NOTIFICACION    AS POLICESCOPE,
            (SELECT WWW.ID_DETALLE_ELEMENTO
            FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO WWW
            WHERE WWW.ELEMENTO_ID=IDE.ELEMENTO_ID
            AND WWW.DETALLE_VALOR= TO_CHAR(ISD.ID_SUBRED)
            ) AS REFERENCIA_DETALLE_ELEMENTO_ID
          FROM DB_INFRAESTRUCTURA.INFO_SUBRED ISD,
            DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO IDE
          WHERE IDE.ELEMENTO_ID  = CN_ID_ELEMENTO
          AND IDE.DETALLE_NOMBRE IN ('SUBRED')
          AND IDE.DETALLE_VALOR   = ISD.ID_SUBRED
          )
        )
        WHERE NOMBRE_SCOPE IS NOT NULL
        AND NOMBRE_SCOPE = CV_SCOPE
        AND ESTADO_RED = 'Migrado';
    LC_GET_SCOPE_MIGRADOS C_GET_SCOPE_MIGRADOS%ROWTYPE;
    LC_GET_OLT_BY_SCOPE C_GET_OLT_BY_SCOPE%ROWTYPE;
    LC_GET_INFO_MIGRA_SCOPE C_GET_INFO_MIGRA_SCOPE%ROWTYPE;
    LC_GET_INFO_MIGRA_REFSUBRED C_GET_INFO_MIGRA_REFSUBRED%ROWTYPE;
    LC_GET_INFO_MIGRA_SUBRED C_GET_INFO_MIGRA_SUBRED%ROWTYPE;
    LC_GET_INFO_MIGRA_SUBRED_PRIMA C_GET_INFO_MIGRA_SUBRED_PRIMA%ROWTYPE;
    LC_GET_INFO_MIGRA_TIPO_SCOPE C_GET_INFO_MIGRA_TIPO_SCOPE%ROWTYPE;
    LC_GET_INFO_MIGRA_SUBRED_TAG C_GET_INFO_MIGRA_SUBRED_TAG%ROWTYPE;
    LC_VALIDA_ESTADO_SUBRED C_VALIDA_ESTADO_SUBRED%ROWTYPE;
  BEGIN
    FOR LC_GET_SCOPE_MIGRADOS IN C_GET_SCOPE_MIGRADOS(LN_MIGRA_CAB_ID)
    LOOP
      LN_IDMIGRACIONDET := LC_GET_SCOPE_MIGRADOS.ID_MIGRACION_DET;
      BEGIN
        LN_COUNT_REVER := 0;
        LN_COUNT_MIGRA := 0;
        FOR LC_GET_OLT_BY_SCOPE IN C_GET_OLT_BY_SCOPE(LC_GET_SCOPE_MIGRADOS.NOMBRE_SCOPE_MIGRADO)
        LOOP
          FOR LC_GET_INFO_MIGRA_SCOPE IN C_GET_INFO_MIGRA_SCOPE(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID, LC_GET_SCOPE_MIGRADOS.NOMBRE_SCOPE_MIGRADO) LOOP
              OPEN C_GET_INFO_MIGRA_REFSUBRED(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_INFO_MIGRA_SCOPE.REF_DETALLE_ELEMENTO_ID);
              FETCH C_GET_INFO_MIGRA_REFSUBRED INTO LC_GET_INFO_MIGRA_REFSUBRED;
              CLOSE C_GET_INFO_MIGRA_REFSUBRED;
              OPEN C_GET_INFO_MIGRA_SUBRED(LC_GET_INFO_MIGRA_REFSUBRED.DETALLE_VALOR);
              FETCH C_GET_INFO_MIGRA_SUBRED INTO LC_GET_INFO_MIGRA_SUBRED;
              CLOSE C_GET_INFO_MIGRA_SUBRED;
              OPEN C_GET_INFO_MIGRA_SUBRED_PRIMA(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_INFO_MIGRA_SCOPE.REF_DETALLE_ELEMENTO_ID);
              FETCH C_GET_INFO_MIGRA_SUBRED_PRIMA INTO LC_GET_INFO_MIGRA_SUBRED_PRIMA;
              CLOSE C_GET_INFO_MIGRA_SUBRED_PRIMA;
              OPEN C_GET_INFO_MIGRA_TIPO_SCOPE(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_INFO_MIGRA_SCOPE.REF_DETALLE_ELEMENTO_ID);
              FETCH C_GET_INFO_MIGRA_TIPO_SCOPE INTO LC_GET_INFO_MIGRA_TIPO_SCOPE;
              CLOSE C_GET_INFO_MIGRA_TIPO_SCOPE;
              DELETE
              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
              WHERE ID_DETALLE_ELEMENTO = LC_GET_INFO_MIGRA_SCOPE.ID_DETALLE_ELEMENTO;
              DELETE
              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
              WHERE ID_DETALLE_ELEMENTO = LC_GET_INFO_MIGRA_SUBRED_PRIMA.ID_DETALLE_ELEMENTO;
              DELETE
              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
              WHERE ID_DETALLE_ELEMENTO = LC_GET_INFO_MIGRA_TIPO_SCOPE.ID_DETALLE_ELEMENTO;
              DELETE
              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
              WHERE ID_DETALLE_ELEMENTO = LC_GET_INFO_MIGRA_REFSUBRED.ID_DETALLE_ELEMENTO;
              DELETE
              FROM DB_INFRAESTRUCTURA.INFO_SUBRED_TAG
              WHERE SUBRED_ID = LC_GET_INFO_MIGRA_SUBRED.ID_SUBRED;
              DELETE
              FROM DB_INFRAESTRUCTURA.INFO_SUBRED
              WHERE ID_SUBRED = LC_GET_INFO_MIGRA_SUBRED.ID_SUBRED;
              LN_COUNT_REVER := LN_COUNT_REVER + 1;
          END LOOP;
        END LOOP;
        FOR LC_GET_OLT_BY_SCOPE IN C_GET_OLT_BY_SCOPE(LC_GET_SCOPE_MIGRADOS.NOMBRE_SCOPE_ANTERIOR)
        LOOP
          OPEN C_VALIDA_ESTADO_SUBRED(LC_GET_OLT_BY_SCOPE.ELEMENTO_ID,LC_GET_SCOPE_MIGRADOS.NOMBRE_SCOPE_ANTERIOR);
          FETCH C_VALIDA_ESTADO_SUBRED INTO LC_VALIDA_ESTADO_SUBRED;
          CLOSE C_VALIDA_ESTADO_SUBRED;
          IF LC_VALIDA_ESTADO_SUBRED.ID_SUBRED IS NOT NULL THEN
              UPDATE DB_INFRAESTRUCTURA.INFO_SUBRED
              SET ESTADO      = 'Activo'
              WHERE ID_SUBRED = LC_VALIDA_ESTADO_SUBRED.ID_SUBRED;
              UPDATE DB_INFRAESTRUCTURA.INFO_SUBRED_TAG
              SET ESTADO      = 'Activo'
              WHERE SUBRED_ID = LC_VALIDA_ESTADO_SUBRED.ID_SUBRED;
              LN_COUNT_MIGRA := LN_COUNT_MIGRA + 1;
          END IF;
        END LOOP;
        IF LN_COUNT_REVER > 0 AND LN_COUNT_MIGRA > 0 THEN
          UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
          SET VALOR   = LC_GET_SCOPE_MIGRADOS.NOMBRE_SCOPE_ANTERIOR
          WHERE VALOR = LC_GET_SCOPE_MIGRADOS.NOMBRE_SCOPE_MIGRADO
          AND ESTADO  = 'Activo';
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOOK, LV_ESTADOOK, 'Scope ha reversado el scope correctamente.');
          COMMIT;
        ELSE
          DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOOK, LV_ESTADOERROR, 'Se presento un error reversar el scope: '||LC_GET_SCOPE_MIGRADOS.NOMBRE_SCOPE_MIGRADO);
          COMMIT;
        END IF;
        COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LN_IDMIGRACIONDET, LV_TIPOREGISTRO, LV_ESTADOOK, LV_ESTADOERROR, SUBSTR('Se presentó un error al realizar el reverso de scopes: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000));
        COMMIT;
      END;
    END LOOP;
    PV_ERROR   := 'OK';
    PV_MENSAJE := 'Se ha ejecutado correctamente.';
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    PV_ERROR   := 'ERROR';
    PV_MENSAJE := 'ERROR: '||SQLERRM;
  END P_REVERSAR_SCOPES;
  PROCEDURE P_REVERSAR_OLTS(
      PN_MIGRACION_CAB_ID IN NUMBER,
      PV_ERROR OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2)
  IS
    LV_ESTADO             VARCHAR2(50);
    LV_REG_OLT            VARCHAR2(50) := 'OLT';
    LV_ESTADO_OK          VARCHAR2(10) := 'Ok';
    LV_ESTADO_OKREVERSO   VARCHAR2(10) := 'Ok';
    LV_ESTADO_MIGRADO     VARCHAR2(10) := 'Migrado';
    LV_ESTADO_REVERSADO   VARCHAR2(25) := 'Reversado';
    LV_ESTADO_NOT_CONNECT VARCHAR2(25) := 'not connect';
    LV_ESTADO_CONNECTED   VARCHAR2(10) := 'connected';
    LV_ESTADO_ACTIVO      VARCHAR2(10) := 'Activo';
    LV_ESTADO_ERROR       VARCHAR2(10) := 'Error';
    LN_MIGRACION_CAB_ID   NUMBER       := PN_MIGRACION_CAB_ID;
    LN_MIGRACION_DET_ID   NUMBER;
    LE_REG_EXCEPTION      EXCEPTION;
    LV_USRCREACION        VARCHAR2(100):= 'Migracion';
    LV_IPCREACION         VARCHAR2(20) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    CURSOR C_GET_INFO_OLT_MIGRADOS (CN_MIGRACION_CAB_ID NUMBER)
    IS
      SELECT ELEMENTO_A AS NOMBRE_OLT_ANTERIOR,
        INTERFACE_ELEMENTO_A,
        ELEMENTO_B AS NOMBRE_OLT_MIGRADO,
        INTERFACE_ELEMENTO_B,
        ID_MIGRACION_DET ID_DETALLE
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
      WHERE MIGRACION_CAB_ID = CN_MIGRACION_CAB_ID
      AND TIPO_REGISTRO      = LV_REG_OLT;
    CURSOR C_GET_DATA_OLT (CV_NOMBRE_OLT VARCHAR2, CV_INTERFACE VARCHAR2, CV_ESTADO_INTERFACE VARCHAR2, CV_ESTADO_ENLACE VARCHAR2)
    IS
      SELECT DB_INFRAESTRUCTURA.INFO_ENLACE.ID_ENLACE,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO ESTADO_INFO_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_ENLACE.ESTADO ESTADO_INFO_ENLACE
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO,
        DB_INFRAESTRUCTURA.INFO_ENLACE
      WHERE DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO                       = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID
      AND DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_INI_ID             = DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO
      AND DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO                     = CV_NOMBRE_OLT
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO = CV_INTERFACE
      AND DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ESTADO                    = CV_ESTADO_INTERFACE
      AND DB_INFRAESTRUCTURA.INFO_ENLACE.ESTADO                                = CV_ESTADO_ENLACE;
    CURSOR C_GET_INFO_ENLACE (CN_ENLACE_ID NUMBER)
    IS
      SELECT ID_ENLACE,
        INTERFACE_ELEMENTO_INI_ID,
        INTERFACE_ELEMENTO_FIN_ID,
        TIPO_MEDIO_ID,
        CAPACIDAD_INPUT,
        UNIDAD_MEDIDA_INPUT,
        CAPACIDAD_OUTPUT,
        UNIDAD_MEDIDA_OUTPUT,
        CAPACIDAD_INI_FIN,
        UNIDAD_MEDIDA_UP,
        CAPACIDAD_FIN_INI,
        UNIDAD_MEDIDA_DOWN,
        TIPO_ENLACE,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        BUFFER_HILO_ID
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE
      WHERE ID_ENLACE = CN_ENLACE_ID;
    CURSOR C_GETOLTSMIGRAR (CN_IDMIGRACAB NUMBER)
    IS
      SELECT
        (SELECT ID_ELEMENTO
        FROM INFO_ELEMENTO
        WHERE NOMBRE_ELEMENTO = ELEMENTO_A
        AND ESTADO            = 'Activo'
        AND ROWNUM           <=1
        ) ID_ELEMENTO_A,
      (SELECT ID_ELEMENTO
      FROM INFO_ELEMENTO
      WHERE NOMBRE_ELEMENTO = ELEMENTO_B
      AND ESTADO            = 'Activo'
      AND ROWNUM           <=1
      ) ID_ELEMENTO_B
    FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
    WHERE MIGRACION_CAB_ID=CN_IDMIGRACAB
    AND TIPO_REGISTRO     ='OLT'
    GROUP BY ELEMENTO_A,
      ELEMENTO_B;
    LC_GET_INFO_OLT_MIGRADOS C_GET_INFO_OLT_MIGRADOS%ROWTYPE;
    LC_GET_DATA_OLT_ANT C_GET_DATA_OLT%ROWTYPE;
    LC_GET_DATA_OLT_MIG C_GET_DATA_OLT%ROWTYPE;
    LC_GET_INFO_ENLACE C_GET_INFO_ENLACE%ROWTYPE;
    LR_REGELEMENTOSMIGRAOLT DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LR_ELEMENTOSMIGRAOLT;
    LT_TREGSELEMENTOSMIGRAOLT DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.LT_ELEMENTOSMIGRAOLT;
    LN_INDXREGELEMENTOSMIGRAOLT NUMBER        := 0;
    LN_ITEMOLTMIGRADO           NUMBER        := 0;
    LB_EJECUTARROLLBACKOLT      BOOLEAN       := FALSE;
    LV_ESTADOERROROLTS          VARCHAR2(300) := 'ErrorReverso';
    LV_ESTADOOKOLTS             VARCHAR2(300) := 'OkReverso';
    LV_STATUS                   VARCHAR2(5);
    LV_MENSAJE                  VARCHAR2(4000);
  BEGIN
    FOR LC_GET_INFO_OLT_MIGRADOS IN C_GET_INFO_OLT_MIGRADOS(LN_MIGRACION_CAB_ID)
    LOOP
      BEGIN
        LC_GET_DATA_OLT_MIG := NULL;
        OPEN C_GET_DATA_OLT(LC_GET_INFO_OLT_MIGRADOS.NOMBRE_OLT_MIGRADO,LC_GET_INFO_OLT_MIGRADOS.INTERFACE_ELEMENTO_B,LV_ESTADO_CONNECTED,LV_ESTADO_ACTIVO);
        FETCH C_GET_DATA_OLT INTO LC_GET_DATA_OLT_MIG;
        CLOSE C_GET_DATA_OLT;
        IF LC_GET_DATA_OLT_MIG.ID_ENLACE IS NULL THEN
          LV_MENSAJE                     := 'No existe informacion del elemento olt migrado '||LC_GET_INFO_OLT_MIGRADOS.NOMBRE_OLT_MIGRADO||' : '||LC_GET_INFO_OLT_MIGRADOS.INTERFACE_ELEMENTO_B||' - '||LV_ESTADO_CONNECTED||' - '||LV_ESTADO_ACTIVO;
          RAISE LE_REG_EXCEPTION;
        END IF;
        -- SACAMOS EL ENLACE MIGRADO
        LC_GET_INFO_ENLACE := NULL;
        OPEN C_GET_INFO_ENLACE (LC_GET_DATA_OLT_MIG.ID_ENLACE);
        FETCH C_GET_INFO_ENLACE INTO LC_GET_INFO_ENLACE;
        CLOSE C_GET_INFO_ENLACE;
        IF LC_GET_INFO_ENLACE.ID_ENLACE IS NULL THEN
          LV_MENSAJE                    := 'No existe informacion del enlace relacionado al elemento olt migrado '||LC_GET_INFO_OLT_MIGRADOS.NOMBRE_OLT_MIGRADO;
          RAISE LE_REG_EXCEPTION;
        END IF;
        UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
        SET ESTADO                  = LV_ESTADO_NOT_CONNECT
        WHERE ID_INTERFACE_ELEMENTO = LC_GET_DATA_OLT_MIG.ID_INTERFACE_ELEMENTO;
        UPDATE DB_INFRAESTRUCTURA.INFO_ENLACE
        SET ESTADO      = LV_ESTADO_REVERSADO
        WHERE ID_ENLACE = LC_GET_DATA_OLT_MIG.ID_ENLACE;
        LC_GET_DATA_OLT_ANT := NULL;
        OPEN C_GET_DATA_OLT(LC_GET_INFO_OLT_MIGRADOS.NOMBRE_OLT_ANTERIOR,LC_GET_INFO_OLT_MIGRADOS.INTERFACE_ELEMENTO_A,LV_ESTADO_MIGRADO,LV_ESTADO_MIGRADO);
        FETCH C_GET_DATA_OLT INTO LC_GET_DATA_OLT_ANT;
        CLOSE C_GET_DATA_OLT;
        IF LC_GET_DATA_OLT_ANT.ID_ENLACE IS NULL THEN
          LV_MENSAJE                     := 'No existe informacion del elemento olt anterior '||LC_GET_INFO_OLT_MIGRADOS.NOMBRE_OLT_ANTERIOR||' : '||LC_GET_INFO_OLT_MIGRADOS.INTERFACE_ELEMENTO_A||' - '||LV_ESTADO_MIGRADO||' - '||LV_ESTADO_MIGRADO;
          RAISE LE_REG_EXCEPTION;
        END IF;
        UPDATE DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
        SET ESTADO                  = LV_ESTADO_CONNECTED
        WHERE ID_INTERFACE_ELEMENTO = LC_GET_DATA_OLT_ANT.ID_INTERFACE_ELEMENTO;
        INSERT
        INTO DB_INFRAESTRUCTURA.INFO_ENLACE
          (
            ID_ENLACE,
            INTERFACE_ELEMENTO_INI_ID,
            INTERFACE_ELEMENTO_FIN_ID,
            TIPO_MEDIO_ID,
            CAPACIDAD_INPUT,
            UNIDAD_MEDIDA_INPUT,
            CAPACIDAD_OUTPUT,
            UNIDAD_MEDIDA_OUTPUT,
            CAPACIDAD_INI_FIN,
            UNIDAD_MEDIDA_UP,
            CAPACIDAD_FIN_INI,
            UNIDAD_MEDIDA_DOWN,
            TIPO_ENLACE,
            ESTADO,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            BUFFER_HILO_ID
          )
          VALUES
          (
            DB_INFRAESTRUCTURA.SEQ_INFO_ENLACE.NEXTVAL,
            LC_GET_DATA_OLT_ANT.ID_INTERFACE_ELEMENTO,
            LC_GET_INFO_ENLACE.INTERFACE_ELEMENTO_FIN_ID,
            LC_GET_INFO_ENLACE.TIPO_MEDIO_ID,
            LC_GET_INFO_ENLACE.CAPACIDAD_INPUT,
            LC_GET_INFO_ENLACE.UNIDAD_MEDIDA_INPUT,
            LC_GET_INFO_ENLACE.CAPACIDAD_OUTPUT,
            LC_GET_INFO_ENLACE.UNIDAD_MEDIDA_OUTPUT,
            LC_GET_INFO_ENLACE.CAPACIDAD_INI_FIN,
            LC_GET_INFO_ENLACE.UNIDAD_MEDIDA_UP,
            LC_GET_INFO_ENLACE.CAPACIDAD_FIN_INI,
            LC_GET_INFO_ENLACE.UNIDAD_MEDIDA_DOWN,
            LC_GET_INFO_ENLACE.TIPO_ENLACE,
            LV_ESTADO_ACTIVO,
            LV_USRCREACION,
            SYSDATE,
            LV_IPCREACION,
            LC_GET_INFO_ENLACE.BUFFER_HILO_ID
          );
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LC_GET_INFO_OLT_MIGRADOS.ID_DETALLE, LV_REG_OLT, LV_ESTADO_OK, LV_ESTADO_OK, 'Se ha reversado el olt correctamente.');
        COMMIT;
      EXCEPTION
      WHEN LE_REG_EXCEPTION THEN
        ROLLBACK;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LC_GET_INFO_OLT_MIGRADOS.ID_DETALLE, LV_REG_OLT, LV_ESTADO_OK, LV_ESTADO_ERROR, 'Se presento un error reversar el olt: '||LC_GET_INFO_OLT_MIGRADOS.NOMBRE_OLT_MIGRADO||'. '||LV_MENSAJE);
        COMMIT;
      WHEN OTHERS THEN
        ROLLBACK;
        LV_MENSAJE := 'ERROR: '||SQLERRM;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LC_GET_INFO_OLT_MIGRADOS.ID_DETALLE, LV_REG_OLT, LV_ESTADO_OK, LV_ESTADO_ERROR, 'Se presento un error reversar el olt: '||LC_GET_INFO_OLT_MIGRADOS.NOMBRE_OLT_MIGRADO||'. '||LV_MENSAJE);
        COMMIT;
      END;
    END LOOP;
    FOR R_OLT IN C_GETOLTSMIGRAR
    (
      PN_MIGRACION_CAB_ID
    )
    LOOP
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ROLLBACK_OLT_SAFECITY
      (
        R_OLT.ID_ELEMENTO_A, R_OLT.ID_ELEMENTO_B, LV_STATUS, LV_MENSAJE
      )
      ;
      IF LV_STATUS = 'OK' THEN
        COMMIT;
        LN_ITEMOLTMIGRADO                            := LN_ITEMOLTMIGRADO + 1;
        LR_REGELEMENTOSMIGRAOLT                      := NULL;
        LR_REGELEMENTOSMIGRAOLT.IDELEMENTOA          := R_OLT.ID_ELEMENTO_A;
        LR_REGELEMENTOSMIGRAOLT.IDELEMENTOB          := R_OLT.ID_ELEMENTO_B;
        LT_TREGSELEMENTOSMIGRAOLT(LN_ITEMOLTMIGRADO) := LR_REGELEMENTOSMIGRAOLT;
      ELSE
        ROLLBACK;
        LB_EJECUTARROLLBACKOLT := TRUE;
      END IF;
    END LOOP;
    IF LB_EJECUTARROLLBACKOLT THEN
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( PN_MIGRACION_CAB_ID, LV_ESTADOERROROLTS, SUBSTR('Se presentaron errores al reversar las migraciones de Olts referente a GPON-MPLS: '||LV_MENSAJE || ' - '||SQLCODE || ' - ERROR - ' || SQLERRM,0,4000), LV_STATUS, LV_MENSAJE);
    ELSE
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_CABECERA( PN_MIGRACION_CAB_ID, LV_ESTADOOKOLTS, 'Registros de Olts reversados correctamente', LV_STATUS, LV_MENSAJE);
    END IF;
    PV_ERROR   := 'OK';
    PV_MENSAJE := 'OK';
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    PV_ERROR   := 'ERROR';
    PV_MENSAJE := 'ERROR: '||SQLERRM;
  END P_REVERSAR_OLTS;
  PROCEDURE P_REVERSAR_SPLITTERS
    (
      PN_MIGRACION_CAB_ID IN NUMBER,
      PV_ERROR OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2
    )
  IS
    LV_ESTADO           VARCHAR2(50);
    LV_MENSAJE          VARCHAR2(2000);
    LV_REG_SPLITTER     VARCHAR2(50) := 'SPLITTER';
    LV_ESTADO_OK        VARCHAR2(10) := 'Ok';
    LV_ESTADO_OKREVERSO VARCHAR2(15) := 'OkReverso';
    LV_ESTADO_ACTIVO    VARCHAR2(15) := 'Activo';
    LV_ESTADO_ERROR     VARCHAR2(15) := 'ErrorReverso';
    LN_MIGRACION_CAB_ID NUMBER       := PN_MIGRACION_CAB_ID;
    LN_MIGRACION_DET_ID NUMBER;
    LE_REG_EXCEPTION    EXCEPTION;
    CURSOR C_GET_ROLLBACK_SPLITTER (CN_MIGRACION_CAB_ID NUMBER)
    IS
      SELECT ELEMENTO_A  AS NOMBRE_SPLITTER_ANTERIOR,
        ELEMENTO_B       AS NOMBRE_SPLITTER_MIGRADO,
        ID_MIGRACION_DET AS ID_DETALLE
      FROM DB_INFRAESTRUCTURA.INFO_MIGRA_AD_DET
      WHERE MIGRACION_CAB_ID = CN_MIGRACION_CAB_ID
      AND TIPO_REGISTRO      = LV_REG_SPLITTER
      AND ESTADO             = LV_ESTADO_OK;
    CURSOR C_GET_SPLITTER (CV_NOMBRE_ELEMENTO VARCHAR2)
    IS
      SELECT ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE NOMBRE_ELEMENTO = CV_NOMBRE_ELEMENTO
      AND ESTADO            = LV_ESTADO_ACTIVO;
    LC_GET_ROLLBACK_SPLITTER C_GET_ROLLBACK_SPLITTER%ROWTYPE;
    LC_GET_SPLITTER C_GET_SPLITTER%ROWTYPE;
  BEGIN
    FOR LC_GET_ROLLBACK_SPLITTER IN C_GET_ROLLBACK_SPLITTER(LN_MIGRACION_CAB_ID)
    LOOP
      BEGIN
        LC_GET_SPLITTER := NULL;
        OPEN C_GET_SPLITTER(LC_GET_ROLLBACK_SPLITTER.NOMBRE_SPLITTER_MIGRADO);
        FETCH C_GET_SPLITTER INTO LC_GET_SPLITTER;
        CLOSE C_GET_SPLITTER;
        IF LC_GET_SPLITTER.ID_ELEMENTO IS NULL THEN
          LV_MENSAJE                   := 'No existe el elemento '||LC_GET_ROLLBACK_SPLITTER.NOMBRE_SPLITTER_MIGRADO;
          RAISE LE_REG_EXCEPTION;
        END IF;
        UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO
        SET NOMBRE_ELEMENTO = LC_GET_ROLLBACK_SPLITTER.NOMBRE_SPLITTER_ANTERIOR
        WHERE ID_ELEMENTO   = LC_GET_SPLITTER.ID_ELEMENTO;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LC_GET_ROLLBACK_SPLITTER.ID_DETALLE, LV_REG_SPLITTER, LV_ESTADO_OK, LV_ESTADO_OKREVERSO, 'Se ha reversado el splitter correctamente.');
        COMMIT;
      EXCEPTION
      WHEN LE_REG_EXCEPTION THEN
        ROLLBACK;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LC_GET_ROLLBACK_SPLITTER.ID_DETALLE, LV_REG_SPLITTER, LV_ESTADO_OK, LV_ESTADO_ERROR, 'Se presento un error reversar el splitter: '||LC_GET_ROLLBACK_SPLITTER.NOMBRE_SPLITTER_MIGRADO||'. '||LV_MENSAJE);
        COMMIT;
      WHEN OTHERS THEN
        ROLLBACK;
        LV_MENSAJE := 'ERROR: '||SQLERRM;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_ACTUALIZAR_DETALLE( LC_GET_ROLLBACK_SPLITTER.ID_DETALLE, LV_REG_SPLITTER, LV_ESTADO_OK, LV_ESTADO_ERROR, 'Se presento un error reversar el splitter: '||LC_GET_ROLLBACK_SPLITTER.NOMBRE_SPLITTER_MIGRADO||'. '||LV_MENSAJE);
        COMMIT;
      END;
    END LOOP;
    PV_ERROR   := 'OK';
    PV_MENSAJE := 'Proceso ejecutado correctamente.';
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    PV_ERROR   := 'ERROR';
    PV_MENSAJE := 'ERROR: '||SQLERRM;
  END P_REVERSAR_SPLITTERS;

  PROCEDURE P_WS_NETWORKING(
      PN_IDOLTANTERIOR IN NUMBER )
    AS
    -- ==Variables ==
    LV_NOMBRE_PE        VARCHAR2 ( 50 ) ;
    LV_NOMBRE_OLT       VARCHAR2(50);
    LV_URL              VARCHAR2(100);
    LV_URL2             VARCHAR2(100);
    LV_ACCION           VARCHAR2(10);
    LV_ACCION2          VARCHAR2(10);
    LV_AMBIENTE         VARCHAR2(10);
    LV_DETALLE_ELEMENTO VARCHAR2(20);
    LV_USER_NAME        VARCHAR2(20) := 'telcos_migra';
    LV_USER_IP          VARCHAR2(20) := '127.0.0.1';
    LV_APLICACION       VARCHAR2(50) := 'application/json';
    LN_STATUS_CODE      NUMBER;
    LN_CONTADOR         NUMBER;
    LN_ID_PE            NUMBER;
    LV_ERROR            VARCHAR2(500);
    LV_STATUS           VARCHAR2(10);
    LV_SERVICIO_WS      VARCHAR2(10);
    LV_MENSAJE          VARCHAR2(200);
    type ARRAY_T IS       varray(2) OF VARCHAR2(10);
    LA_ACCION ARRAY_T := ARRAY_T('cancelar','eliminar');
    LCL_REQUEST CLOB;
    LCL_RESPONSE CLOB;
    -- == Cursores ==
    CURSOR C_GET_NOMBRE_ELEMENTO (CN_ELEMENTO_ID NUMBER)
    IS
      SELECT NOMBRE_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO
      WHERE ID_ELEMENTO = CN_ELEMENTO_ID;
    LC_GET_NOMBRE_ELEMENTO C_GET_NOMBRE_ELEMENTO%ROWTYPE;
    --
    --
    CURSOR C_GET_PE_ASIGNADO (CN_ELEMENTO_ID NUMBER)
    IS
      SELECT DETALLE_VALOR
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
      WHERE ELEMENTO_ID  = CN_ELEMENTO_ID
      AND DETALLE_NOMBRE = 'PE_ASIGNADO'
      AND ESTADO         = 'Activo';
    LC_GET_PE_ASIGNADO C_GET_PE_ASIGNADO%ROWTYPE;
    --
    --
    CURSOR C_GET_PARAMETROS_WS
    IS
      SELECT PARAMETRO.*
      FROM DB_GENERAL.ADMI_PARAMETRO_DET PARAMETRO
      WHERE PARAMETRO_ID =
        (SELECT DB_GENERAL.ADMI_PARAMETRO_CAB.ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
        )
    AND DESCRIPCION = 'Parametros Consumo NW'
    AND ESTADO      = 'Activo';
    LC_GET_PARAMETROS_WS C_GET_PARAMETROS_WS%ROWTYPE;
    --
    --
    -- Cursor para validar la caracteristica MULTIPLATAFORMA del OLT
    CURSOR C_DETALLE_ELEMENTO (CN_ELEMENTO_ID NUMBER)
    IS
      SELECT DETALLE_ELEMENTO.*
      FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DETALLE_ELEMENTO
      WHERE ELEMENTO_ID  = CN_ELEMENTO_ID
      AND DETALLE_NOMBRE = 'MULTIPLATAFORMA';
    LC_DETALLE_ELEMENTO C_DETALLE_ELEMENTO%ROWTYPE;
    --
    --
  BEGIN
    --
    -- Verificamos si el OLT es MULTIPLATAFORMA
    IF C_DETALLE_ELEMENTO%ISOPEN THEN
      CLOSE C_DETALLE_ELEMENTO;
    END IF;
  OPEN C_DETALLE_ELEMENTO(PN_IDOLTANTERIOR);
  FETCH C_DETALLE_ELEMENTO INTO LC_DETALLE_ELEMENTO;
  LV_DETALLE_ELEMENTO := LC_DETALLE_ELEMENTO.DETALLE_VALOR;
  CLOSE C_DETALLE_ELEMENTO;
  IF LV_DETALLE_ELEMENTO IS NULL THEN
    LV_DETALLE_ELEMENTO  := 'NO';
  END IF;
  --
  --Validamos que ambos OLTs sea MULTIPLATAFORMA
  IF LV_DETALLE_ELEMENTO != 'SI' THEN
    LV_MENSAJE           :='No se realiza el consumo a los WS de NW debido a que el OLT no es multiplaforma';
    RETURN;
  END IF;
  --
  IF C_GET_NOMBRE_ELEMENTO%ISOPEN THEN
    CLOSE C_GET_NOMBRE_ELEMENTO;
  END IF;
  OPEN C_GET_NOMBRE_ELEMENTO(PN_IDOLTANTERIOR);
  FETCH C_GET_NOMBRE_ELEMENTO INTO LC_GET_NOMBRE_ELEMENTO;
  LV_NOMBRE_OLT := LC_GET_NOMBRE_ELEMENTO.NOMBRE_ELEMENTO;
  CLOSE C_GET_NOMBRE_ELEMENTO;
  --
  --
  IF C_GET_PE_ASIGNADO%ISOPEN THEN
    CLOSE C_GET_PE_ASIGNADO;
  END IF;
  OPEN C_GET_PE_ASIGNADO(PN_IDOLTANTERIOR);
  FETCH C_GET_PE_ASIGNADO INTO LC_GET_PE_ASIGNADO;
  LN_ID_PE := LC_GET_PE_ASIGNADO.DETALLE_VALOR;
  CLOSE C_GET_PE_ASIGNADO;
  --
  --
  IF C_GET_NOMBRE_ELEMENTO%ISOPEN THEN
    CLOSE C_GET_NOMBRE_ELEMENTO;
  END IF;
  OPEN C_GET_NOMBRE_ELEMENTO(LN_ID_PE);
  FETCH C_GET_NOMBRE_ELEMENTO INTO LC_GET_NOMBRE_ELEMENTO;
  LV_NOMBRE_PE := LC_GET_NOMBRE_ELEMENTO.NOMBRE_ELEMENTO;
  CLOSE C_GET_NOMBRE_ELEMENTO;
  --
  --
  IF C_GET_PARAMETROS_WS%ISOPEN THEN
    CLOSE C_GET_PARAMETROS_WS;
  END IF;
  OPEN C_GET_PARAMETROS_WS();
  FETCH C_GET_PARAMETROS_WS INTO LC_GET_PARAMETROS_WS;
  LV_AMBIENTE    := LC_GET_PARAMETROS_WS.VALOR1;
  LV_SERVICIO_WS := LC_GET_PARAMETROS_WS.VALOR2;
  LV_ACCION      := LC_GET_PARAMETROS_WS.VALOR3;
  LV_URL         := LC_GET_PARAMETROS_WS.VALOR4;
  LV_ACCION2     := LC_GET_PARAMETROS_WS.VALOR5;
  LV_URL2        := LC_GET_PARAMETROS_WS.VALOR6;
  CLOSE C_GET_PARAMETROS_WS;
  --

  LN_CONTADOR := LA_ACCION.COUNT;
  FOR I IN 1 .. LN_CONTADOR
    LOOP
      --
      IF LA_ACCION ( I ) = 'eliminar' THEN
        LV_URL          := LV_URL2;
        LV_ACCION       := LV_ACCION2;
      END IF;
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT; --Abrir el request
      APEX_JSON.write('accion', LV_ACCION);
      APEX_JSON.OPEN_OBJECT('data'); -- Abrir data
      APEX_JSON.write('tipo_ejecucion', LV_AMBIENTE);
      APEX_JSON.write('pe', LV_NOMBRE_PE);
      APEX_JSON.write('id_olt', PN_IDOLTANTERIOR);
      APEX_JSON.write('olt', LV_NOMBRE_OLT);
      APEX_JSON.CLOSE_OBJECT;                  -- Cerrar data
      APEX_JSON.OPEN_OBJECT('data-auditoria'); -- Abrir data-auditoria
      APEX_JSON.write('servicio', LV_SERVICIO_WS);
      APEX_JSON.write('login_aux', '');
      APEX_JSON.write('user_name', LV_USER_NAME);
      APEX_JSON.write('user_ip', LV_USER_IP);
      APEX_JSON.CLOSE_OBJECT; -- Cerrar data-auditoria
      APEX_JSON.CLOSE_OBJECT; -- Cerrar el request
      LCL_REQUEST := APEX_JSON.GET_CLOB_OUTPUT;
      --
      -- Consumo del WS
      DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(PV_URL => LV_URL, PCL_MENSAJE => LCL_REQUEST, PV_APPLICATION => LV_APLICACION, PV_CHARSET => 'UTF-8', PV_URLFILEDIGITAL => NULL, PV_PASSFILEDIGITAL => NULL, PCL_RESPUESTA => LCL_RESPONSE, PV_ERROR => LV_ERROR);
      --
      APEX_JSON.PARSE(LCL_RESPONSE);
      LN_STATUS_CODE := APEX_JSON.GET_NUMBER(P_PATH => 'status');
      LV_MENSAJE     := APEX_JSON.GET_VARCHAR2(P_PATH => 'message');
      --
      LV_STATUS       := 'OK';
      IF LCL_RESPONSE IS NULL OR LN_STATUS_CODE != 200 THEN
        LV_STATUS     := 'ERROR';
        LV_MENSAJE    := 'Ha ocurrido un error al realizar el consumo al WS de Networking: '||LV_MENSAJE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_WS_NETWORKING', LV_MENSAJE, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), sysdate, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      END IF;
      --Ingresar la respuesta del WS al historial del elemento
      --
      INSERT
      INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO VALUES
        (
          DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,
          PN_IDOLTANTERIOR,
          'Activo',
          NULL,
          'Consumo del WS de NW '
          ||LV_ACCION
          ||' '
          ||LV_STATUS
          ||' '
          ||LN_STATUS_CODE
          ||' : '
          ||LV_MENSAJE,
          LV_USER_NAME,
          sysdate,
          LV_USER_IP
        );

    END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    LV_MENSAJE := 'Error: '||SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'INKG_MIGRACION_ALTA_DENSIDAD.P_WS_NETWORKING', LV_MENSAJE, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), sysdate, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_WS_NETWORKING;

  PROCEDURE P_INSERTAR_CARACT_SAFECITY 
    (
      PN_ID_SERVICIO IN NUMBER,
      PV_CARACTERISTICA IN VARCHAR2,
      PV_VALOR_NUEVO IN VARCHAR2,
      PB_VALIDAMENSAJE IN BOOLEAN,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2 
    ) 
  AS 
  --
    LE_EXECPTION             EXCEPTION;
    LV_ESTADO                VARCHAR2(20) := 'Activo';
    LV_ESTADO_ELIMINADO      VARCHAR2(20) := 'Eliminado';
    LV_USRCREACION           VARCHAR2(100):= 'Migracion';
    LV_IP_CRECION            VARCHAR2(20) := '127.0.0.1';
    LV_MENSAJEHISTORIAL      VARCHAR2(4000) := '';
    LV_VALOR_ANTERIOR        VARCHAR2(20);
    --
    CURSOR C_CARACT_SERVICIO(CV_CARACT VARCHAR2)
    IS
      SELECT ISPC.*
          FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
            DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
            DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
            DB_COMERCIAL.ADMI_PRODUCTO AP,
            DB_COMERCIAL.ADMI_CARACTERISTICA AC
          WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
          AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
          AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
          AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
          AND AC.ESTADO                        = LV_ESTADO
          AND ISPC.ESTADO                      = LV_ESTADO
          AND ISERV.ID_SERVICIO                = PN_ID_SERVICIO
          AND AC.DESCRIPCION_CARACTERISTICA    = CV_CARACT;
    LC_CARACT_SERVICIO C_CARACT_SERVICIO%ROWTYPE;
    --
  BEGIN
    IF C_CARACT_SERVICIO%ISOPEN THEN
    CLOSE C_CARACT_SERVICIO;
    END IF;
    OPEN C_CARACT_SERVICIO(PV_CARACTERISTICA);
    FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
    LV_VALOR_ANTERIOR := LC_CARACT_SERVICIO.VALOR;
    CLOSE C_CARACT_SERVICIO;
    --
    IF LC_CARACT_SERVICIO.ID_SERVICIO_PROD_CARACT IS NULL THEN
      PV_MENSAJE := 'No se encontró información de la característica' || PV_CARACTERISTICA || 'del servicio';
      RAISE LE_EXECPTION;
    END IF;
    --
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT 
        SET ESTADO   = LV_ESTADO_ELIMINADO,
        USR_ULT_MOD  = LV_USRCREACION, 
        FE_ULT_MOD   = SYSDATE
    WHERE ID_SERVICIO_PROD_CARACT = LC_CARACT_SERVICIO.ID_SERVICIO_PROD_CARACT
    AND SERVICIO_ID = PN_ID_SERVICIO;
    --
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    (
      ID_SERVICIO_PROD_CARACT,
      SERVICIO_ID,
      PRODUCTO_CARACTERISITICA_ID,
      VALOR,
      FE_CREACION,
      FE_ULT_MOD,
      USR_CREACION,
      USR_ULT_MOD,
      ESTADO,
      REF_SERVICIO_PROD_CARACT_ID
    )
    VALUES
    (
      DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
      PN_ID_SERVICIO,
      LC_CARACT_SERVICIO.PRODUCTO_CARACTERISITICA_ID,
      PV_VALOR_NUEVO,
      SYSDATE,
      NULL,
      LV_USRCREACION,
      NULL,
      LV_ESTADO,
      NULL
    );
    --
    IF (PB_VALIDAMENSAJE) THEN
      LV_MENSAJEHISTORIAL := 'Se actualiza la característica '|| '<b>' || PV_CARACTERISTICA ||'</b>' || ' por migración de OLT Alta Densidad:<br>';
    ELSE
      LV_MENSAJEHISTORIAL := 'Se reversa la característica ' || '<b>' || PV_CARACTERISTICA ||'</b>' || ' por rollback de migración de OLT Alta Densidad:<br>';
    END IF;
    ----REGISTRAR HISTORIAL
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
    (
      ID_SERVICIO_HISTORIAL,
      SERVICIO_ID,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION,
      ESTADO,
      OBSERVACION
    )
    VALUES
    (
      DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
      PN_ID_SERVICIO,
      LV_USRCREACION,
      SYSDATE,
      LV_IP_CRECION,
      LV_ESTADO,
      LV_MENSAJEHISTORIAL ||'<b>Anterior</b>: '|| LV_VALOR_ANTERIOR || '<br><b>Nueva</b>: '|| PV_VALOR_NUEVO || '<br>'
    );
    PV_STATUS  := 'OK';
    PV_MENSAJE := 'Características migradas correctamente.';
  EXCEPTION
    WHEN LE_EXECPTION THEN
    PV_STATUS := 'ERROR';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_INSERTAR_CARACT_SAFECITY', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    WHEN OTHERS THEN
    PV_STATUS  := 'ERROR';
    PV_MENSAJE := 'Error: '||SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_INSERTAR_CARACT_SAFECITY', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_INSERTAR_CARACT_SAFECITY;

  PROCEDURE P_ACTUALIZAR_CARACT_SAFECITY 
    (
      PN_IDSERVICIO IN NUMBER,
      PN_IDELEMENTOINI IN NUMBER,
      PN_IDELEMENTOFIN IN NUMBER,
      PV_OPCION IN VARCHAR2,
      PV_STATUS OUT VARCHAR2,
      PV_MENSAJE OUT VARCHAR2 
    ) 
  AS 
  --
    LE_CONTINUAR             EXCEPTION;
    LV_ESTADO                VARCHAR2(20) := 'Activo';
    LV_PARAMETRO_VELOCIDAD   VARCHAR2(50) := 'MAPEO_VELOCIDAD_TRAFFIC_TABLE_GPON';
    LV_TRAFFIC_TABLE         VARCHAR2(20) := 'TRAFFIC-TABLE';
    LV_TRAFFIC_TABLE_ADMIN   VARCHAR2(20) := 'TRAFFIC-TABLE-ADMIN';
    LV_TCONT                 VARCHAR2(20) := 'T-CONT';
    LV_TCONT_ADMIN           VARCHAR2(20) := 'T-CONT-ADMIN';
    LV_VLAN                  VARCHAR2(20) := 'VLAN';
    LV_VLAN_ADMIN            VARCHAR2(20) := 'VLAN ADMIN';
    LV_VLAN_SSID             VARCHAR2(20) := 'VLAN SSID';
    LV_GEM_PORT              VARCHAR2(20) := 'GEM-PORT';
    LV_GEM_PORT_ADMIN        VARCHAR2(20) := 'GEM-PORT-ADMIN';
    LB_BOOLEAN               BOOLEAN      :=  FALSE;
    LN_NOMBRE_TECNICO        VARCHAR2(30);
    LN_VALOR_VELOCIDAD       VARCHAR2(20);
    LN_VALOR_ANTERIOR_VELOCIDAD VARCHAR2(20);
    LV_VALOR_CARACT_TCONT    VARCHAR2(20);
    LV_VALOR_VLAN            VARCHAR2(20);
    LV_VALOR_CARACT_VLAN     VARCHAR2(20);
    LN_ID_DETALLE_ELE        NUMBER;
    LN_ID_ELEMENTO           NUMBER;
    --
    CURSOR C_ELEM_PROD_SERVICIO(CN_SERVICIO_ID NUMBER)
    IS
      SELECT IEE.ID_ELEMENTO, IEE.NOMBRE_ELEMENTO, AMRE.NOMBRE_MARCA_ELEMENTO, AME.NOMBRE_MODELO_ELEMENTO,
      PRO.NOMBRE_TECNICO FROM DB_COMERCIAL.INFO_SERVICIO ISS
      INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO IST ON IST.SERVICIO_ID = ISS.ID_SERVICIO
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON ISS.PRODUCTO_ID  = PRO.ID_PRODUCTO
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO IEE ON IEE.ID_ELEMENTO = IST.ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME ON AME.ID_MODELO_ELEMENTO = IEE.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO AMRE ON AMRE.ID_MARCA_ELEMENTO = AME.MARCA_ELEMENTO_ID
      WHERE ISS.ID_SERVICIO = CN_SERVICIO_ID
      AND ISS.ESTADO = LV_ESTADO
      AND PRO.ESTADO = LV_ESTADO
      AND AME.ESTADO = LV_ESTADO
      AND IEE.ESTADO = LV_ESTADO
      AND AMRE.ESTADO = LV_ESTADO;
    LC_ELE_PROD_SERV C_ELEM_PROD_SERVICIO%ROWTYPE;
    --
    CURSOR C_CARACT_SERVICIO(CV_CARACT VARCHAR2)
    IS
      SELECT ISPC.*
          FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
            DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
            DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
            DB_COMERCIAL.ADMI_PRODUCTO AP,
            DB_COMERCIAL.ADMI_CARACTERISTICA AC
          WHERE ISPC.SERVICIO_ID               = ISERV.ID_SERVICIO
          AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
          AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
          AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
          AND AC.ESTADO                        = LV_ESTADO
          AND ISPC.ESTADO                      = LV_ESTADO
          AND ISERV.ID_SERVICIO                = PN_IDSERVICIO
          AND AC.DESCRIPCION_CARACTERISTICA    = CV_CARACT;
    LC_CARACT_SERVICIO C_CARACT_SERVICIO%ROWTYPE;
    --
    CURSOR C_PARAMETRO_VELOCIDAD(CN_VALOR VARCHAR2)
    IS
      SELECT ID_PARAMETRO_DET, VALOR1, VALOR2, VALOR3 FROM DB_GENERAL.ADMI_PARAMETRO_DET 
      WHERE PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
                            WHERE NOMBRE_PARAMETRO = LV_PARAMETRO_VELOCIDAD
                            AND ESTADO = LV_ESTADO)
      AND DESCRIPCION = LV_PARAMETRO_VELOCIDAD
      AND (VALOR1 = CN_VALOR OR VALOR2 = CN_VALOR OR VALOR3 = CN_VALOR);
    LC_PARAMETRO_VELOCIDAD C_PARAMETRO_VELOCIDAD%ROWTYPE;
    --
    CURSOR C_DETALLE_ELEMENTO(CV_ID_DET_ELE VARCHAR2)
    IS
      SELECT DET.*
          FROM DB_COMERCIAL.INFO_DETALLE_ELEMENTO DET
          WHERE DET.ID_DETALLE_ELEMENTO = CV_ID_DET_ELE;
    LC_DETALLE_ELEMENTO C_DETALLE_ELEMENTO%ROWTYPE;
    --
    CURSOR C_ID_DETALLE_ELEMENTO(CN_ELEMENTO_ID NUMBER,CV_DETALLE_NOMBRE VARCHAR2,CV_DETALLE_VALOR VARCHAR2)
    IS
      SELECT DET.ID_DETALLE_ELEMENTO
          FROM DB_COMERCIAL.INFO_DETALLE_ELEMENTO DET
          WHERE DET.ELEMENTO_ID    = CN_ELEMENTO_ID
            AND DET.DETALLE_NOMBRE = CV_DETALLE_NOMBRE
            AND DET.DETALLE_VALOR  = CV_DETALLE_VALOR
            AND DET.ESTADO         = LV_ESTADO;
    --
  BEGIN
    --
    IF C_ELEM_PROD_SERVICIO%ISOPEN THEN
      CLOSE C_ELEM_PROD_SERVICIO;
    END IF;
    OPEN C_ELEM_PROD_SERVICIO (PN_IDSERVICIO);
    FETCH C_ELEM_PROD_SERVICIO INTO LC_ELE_PROD_SERV;
    LN_NOMBRE_TECNICO := LC_ELE_PROD_SERV.NOMBRE_TECNICO;
    CLOSE C_ELEM_PROD_SERVICIO;
    --
    IF PV_OPCION  = 'MIGRACION' THEN
      LB_BOOLEAN := TRUE;
    END IF;
    --
    IF LN_NOMBRE_TECNICO = 'SAFECITYDATOS' OR LN_NOMBRE_TECNICO = 'SAFECITYWIFI' OR LN_NOMBRE_TECNICO = 'DATOS SAFECITY' THEN
      ---***TRAFFIC TABLE***---
      IF C_CARACT_SERVICIO%ISOPEN THEN
      CLOSE C_CARACT_SERVICIO;
      END IF;
      OPEN C_CARACT_SERVICIO(LV_TRAFFIC_TABLE);
      FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
      LN_VALOR_ANTERIOR_VELOCIDAD := LC_CARACT_SERVICIO.VALOR;
      CLOSE C_CARACT_SERVICIO;
      --
      IF LN_VALOR_ANTERIOR_VELOCIDAD IS NULL THEN
        PV_MENSAJE := 'No se encontró información de la característica ' || LV_TRAFFIC_TABLE ||' del servicio';
        RAISE LE_CONTINUAR;
      END IF;
      --
      IF C_PARAMETRO_VELOCIDAD%ISOPEN THEN
      CLOSE C_PARAMETRO_VELOCIDAD;
      END IF;
      OPEN C_PARAMETRO_VELOCIDAD(LN_VALOR_ANTERIOR_VELOCIDAD);
      FETCH C_PARAMETRO_VELOCIDAD INTO LC_PARAMETRO_VELOCIDAD;
      CLOSE C_PARAMETRO_VELOCIDAD;
      IF PV_OPCION = 'MIGRACION' THEN
        LN_VALOR_VELOCIDAD := LC_PARAMETRO_VELOCIDAD.VALOR3;
      ELSE
        IF LN_NOMBRE_TECNICO = 'DATOS SAFECITY' THEN
          LN_VALOR_VELOCIDAD := LC_PARAMETRO_VELOCIDAD.VALOR1;
        ELSE
            LN_VALOR_VELOCIDAD := LC_PARAMETRO_VELOCIDAD.VALOR2;
        END IF;
      END IF;
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_CARACT_SAFECITY(PN_IDSERVICIO, LV_TRAFFIC_TABLE, LN_VALOR_VELOCIDAD, LB_BOOLEAN, PV_STATUS, PV_MENSAJE);
      IF PV_STATUS           = 'ERROR' THEN
        RAISE LE_CONTINUAR;
      END IF;
      ---***GEM-PORT***---
      IF PV_OPCION = 'MIGRACION' THEN
        IF C_CARACT_SERVICIO%ISOPEN THEN
        CLOSE C_CARACT_SERVICIO;
        END IF;
        OPEN C_CARACT_SERVICIO(LV_TCONT);
        FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
        LV_VALOR_CARACT_TCONT := LC_CARACT_SERVICIO.VALOR;
        CLOSE C_CARACT_SERVICIO;
        --
        IF LV_VALOR_CARACT_TCONT IS NULL THEN
          PV_MENSAJE := 'No se encontró información de la característica ' || LV_TCONT ||' del servicio';
          RAISE LE_CONTINUAR;
        END IF;
      ELSE
        IF LN_NOMBRE_TECNICO = 'SAFECITYWIFI' THEN
            IF C_CARACT_SERVICIO%ISOPEN THEN
            CLOSE C_CARACT_SERVICIO;
            END IF;
            OPEN C_CARACT_SERVICIO(LV_VLAN_SSID);
            FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
            LV_VALOR_CARACT_VLAN := LC_CARACT_SERVICIO.VALOR;
            CLOSE C_CARACT_SERVICIO;
            --
            IF LV_VALOR_CARACT_VLAN IS NULL THEN
              PV_MENSAJE := 'No se encontró información de la característica ' || LV_VLAN_SSID ||' del servicio';
              RAISE LE_CONTINUAR;
            END IF;
        ELSE
            IF C_CARACT_SERVICIO%ISOPEN THEN
            CLOSE C_CARACT_SERVICIO;
            END IF;
            OPEN C_CARACT_SERVICIO(LV_VLAN);
            FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
            LV_VALOR_CARACT_VLAN := LC_CARACT_SERVICIO.VALOR;
            CLOSE C_CARACT_SERVICIO;
            --
            IF LV_VALOR_CARACT_VLAN IS NULL THEN
              PV_MENSAJE := 'No se encontró información de la característica ' || LV_VLAN ||' del servicio';
              RAISE LE_CONTINUAR;
            END IF;
        END IF;
        --
        SELECT ID_DETALLE_ELEMENTO, DETALLE_VALOR INTO LN_ID_DETALLE_ELE, LV_VALOR_VLAN
        FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
        WHERE ID_DETALLE_ELEMENTO = LV_VALOR_CARACT_VLAN;
        --
        LV_VALOR_CARACT_TCONT := LV_VALOR_VLAN;
      END IF; 
      DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_CARACT_SAFECITY(PN_IDSERVICIO, LV_GEM_PORT, LV_VALOR_CARACT_TCONT, LB_BOOLEAN, PV_STATUS, PV_MENSAJE);
      IF PV_STATUS  = 'ERROR' THEN
        RAISE LE_CONTINUAR;
      END IF;
      --
      IF LN_NOMBRE_TECNICO = 'SAFECITYWIFI' THEN
        ---***TRAFFIC TABLE-ADMIN***---
        IF C_CARACT_SERVICIO%ISOPEN THEN
        CLOSE C_CARACT_SERVICIO;
        END IF;
        OPEN C_CARACT_SERVICIO(LV_TRAFFIC_TABLE_ADMIN);
        FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
        LN_VALOR_ANTERIOR_VELOCIDAD := LC_CARACT_SERVICIO.VALOR;
        CLOSE C_CARACT_SERVICIO;
        --
        IF LN_VALOR_ANTERIOR_VELOCIDAD IS NULL THEN
          PV_MENSAJE := 'No se encontró información de la característica ' || LV_TRAFFIC_TABLE_ADMIN ||' del servicio';
          RAISE LE_CONTINUAR;
        END IF;
        --
        IF C_PARAMETRO_VELOCIDAD%ISOPEN THEN
        CLOSE C_PARAMETRO_VELOCIDAD;
        END IF;
        OPEN C_PARAMETRO_VELOCIDAD(LN_VALOR_ANTERIOR_VELOCIDAD);
        FETCH C_PARAMETRO_VELOCIDAD INTO LC_PARAMETRO_VELOCIDAD;
        CLOSE C_PARAMETRO_VELOCIDAD;
        IF PV_OPCION = 'MIGRACION' THEN
          LN_VALOR_VELOCIDAD := LC_PARAMETRO_VELOCIDAD.VALOR3;
        ELSE
          LN_VALOR_VELOCIDAD := LC_PARAMETRO_VELOCIDAD.VALOR2;
        END IF; 
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_CARACT_SAFECITY(PN_IDSERVICIO, LV_TRAFFIC_TABLE_ADMIN, LN_VALOR_VELOCIDAD, LB_BOOLEAN, PV_STATUS, PV_MENSAJE);
        IF PV_STATUS           = 'ERROR' THEN
          RAISE LE_CONTINUAR;
        END IF;
        ---***GEM-PORT-ADMIN***---
        IF PV_OPCION = 'MIGRACION' THEN
          IF C_CARACT_SERVICIO%ISOPEN THEN
          CLOSE C_CARACT_SERVICIO;
          END IF;
          OPEN C_CARACT_SERVICIO(LV_TCONT_ADMIN);
          FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
          LV_VALOR_CARACT_TCONT := LC_CARACT_SERVICIO.VALOR;
          CLOSE C_CARACT_SERVICIO;
          --
          IF LV_VALOR_CARACT_TCONT IS NULL THEN
            PV_MENSAJE := 'No se encontró información de la característica ' || LV_TCONT_ADMIN ||' del servicio';
            RAISE LE_CONTINUAR;
          END IF;
        ELSE
          IF C_CARACT_SERVICIO%ISOPEN THEN
          CLOSE C_CARACT_SERVICIO;
          END IF;
          OPEN C_CARACT_SERVICIO(LV_VLAN_ADMIN);
          FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
          LV_VALOR_CARACT_VLAN := LC_CARACT_SERVICIO.VALOR;
          CLOSE C_CARACT_SERVICIO;
          --
          IF LV_VALOR_CARACT_VLAN IS NULL THEN
            PV_MENSAJE := 'No se encontró información de la característica ' || LV_VLAN_ADMIN ||' del servicio';
            RAISE LE_CONTINUAR;
          END IF;
          --
          SELECT ID_DETALLE_ELEMENTO, DETALLE_VALOR INTO LN_ID_DETALLE_ELE, LV_VALOR_VLAN
          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
          WHERE ID_DETALLE_ELEMENTO = LV_VALOR_CARACT_VLAN;
          --
          LV_VALOR_CARACT_TCONT := LV_VALOR_VLAN;              
        END IF;
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_CARACT_SAFECITY(PN_IDSERVICIO, LV_GEM_PORT_ADMIN, LV_VALOR_CARACT_TCONT, LB_BOOLEAN, PV_STATUS, PV_MENSAJE);
        IF PV_STATUS  = 'ERROR' THEN
          RAISE LE_CONTINUAR;
        END IF;
        ---***ACTUALIZAR VLAN***---
        IF PV_OPCION = 'MIGRACION' THEN
          LN_ID_ELEMENTO := PN_IDELEMENTOFIN;
        ELSE
          LN_ID_ELEMENTO := PN_IDELEMENTOINI;
        END IF;
        ---***VLAN-SSID***---
        LV_VALOR_CARACT_VLAN := NULL;
        IF C_CARACT_SERVICIO%ISOPEN THEN
        CLOSE C_CARACT_SERVICIO;
        END IF;
        OPEN C_CARACT_SERVICIO(LV_VLAN_SSID);
        FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
        LV_VALOR_CARACT_VLAN := LC_CARACT_SERVICIO.VALOR;
        CLOSE C_CARACT_SERVICIO;
        IF LV_VALOR_CARACT_VLAN IS NULL THEN
          PV_MENSAJE := 'No se encontró información de la característica ' || LV_VLAN_SSID ||' del servicio';
          RAISE LE_CONTINUAR;
        END IF;
        --
        IF C_DETALLE_ELEMENTO%ISOPEN THEN
        CLOSE C_DETALLE_ELEMENTO;
        END IF;
        OPEN C_DETALLE_ELEMENTO(LV_VALOR_CARACT_VLAN);
        FETCH C_DETALLE_ELEMENTO INTO LC_DETALLE_ELEMENTO;
        CLOSE C_DETALLE_ELEMENTO;
        --
        LN_ID_DETALLE_ELE := NULL;
        IF C_ID_DETALLE_ELEMENTO%ISOPEN THEN
        CLOSE C_ID_DETALLE_ELEMENTO;
        END IF;
        OPEN C_ID_DETALLE_ELEMENTO(LN_ID_ELEMENTO,LC_DETALLE_ELEMENTO.DETALLE_NOMBRE,LC_DETALLE_ELEMENTO.DETALLE_VALOR);
        FETCH C_ID_DETALLE_ELEMENTO INTO LN_ID_DETALLE_ELE;
        CLOSE C_ID_DETALLE_ELEMENTO;
        IF LN_ID_DETALLE_ELE IS NULL THEN
          PV_MENSAJE := 'No se encontró el detalle de elemento de la ' || LV_VLAN_SSID ||' del nuevo elemento';
          RAISE LE_CONTINUAR;
        END IF;
        --
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_CARACT_SAFECITY(PN_IDSERVICIO, LV_VLAN_SSID, LN_ID_DETALLE_ELE, LB_BOOLEAN, PV_STATUS, PV_MENSAJE);
        IF PV_STATUS  = 'ERROR' THEN
          RAISE LE_CONTINUAR;
        END IF;
        --
        ---***VLAN-ADMIN***---
        LV_VALOR_CARACT_VLAN := NULL;
        IF C_CARACT_SERVICIO%ISOPEN THEN
        CLOSE C_CARACT_SERVICIO;
        END IF;
        OPEN C_CARACT_SERVICIO(LV_VLAN_ADMIN);
        FETCH C_CARACT_SERVICIO INTO LC_CARACT_SERVICIO;
        LV_VALOR_CARACT_VLAN := LC_CARACT_SERVICIO.VALOR;
        CLOSE C_CARACT_SERVICIO;
        IF LV_VALOR_CARACT_VLAN IS NULL THEN
          PV_MENSAJE := 'No se encontró información de la característica ' || LV_VLAN_ADMIN ||' del servicio';
          RAISE LE_CONTINUAR;
        END IF;
        --
        IF C_DETALLE_ELEMENTO%ISOPEN THEN
        CLOSE C_DETALLE_ELEMENTO;
        END IF;
        OPEN C_DETALLE_ELEMENTO(LV_VALOR_CARACT_VLAN);
        FETCH C_DETALLE_ELEMENTO INTO LC_DETALLE_ELEMENTO;
        CLOSE C_DETALLE_ELEMENTO;
        --
        LN_ID_DETALLE_ELE := NULL;
        IF C_ID_DETALLE_ELEMENTO%ISOPEN THEN
        CLOSE C_ID_DETALLE_ELEMENTO;
        END IF;
        OPEN C_ID_DETALLE_ELEMENTO(LN_ID_ELEMENTO,LC_DETALLE_ELEMENTO.DETALLE_NOMBRE,LC_DETALLE_ELEMENTO.DETALLE_VALOR);
        FETCH C_ID_DETALLE_ELEMENTO INTO LN_ID_DETALLE_ELE;
        CLOSE C_ID_DETALLE_ELEMENTO;
        IF LN_ID_DETALLE_ELE IS NULL THEN
          PV_MENSAJE := 'No se encontró el detalle de elemento de la ' || LV_VLAN_ADMIN ||' del nuevo elemento';
          RAISE LE_CONTINUAR;
        END IF;
        --
        DB_INFRAESTRUCTURA.INKG_MIGRACION_ALTA_DENSIDAD.P_INSERTAR_CARACT_SAFECITY(PN_IDSERVICIO, LV_VLAN_ADMIN, LN_ID_DETALLE_ELE, LB_BOOLEAN, PV_STATUS, PV_MENSAJE);
        IF PV_STATUS  = 'ERROR' THEN
          RAISE LE_CONTINUAR;
        END IF;
        --
      END IF;
    END IF;
    --
    PV_STATUS := 'OK';
    PV_MENSAJE := 'OK';
  --
EXCEPTION
  WHEN LE_CONTINUAR THEN
  PV_STATUS := 'ERROR';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_ACTUALIZAR_CARACT_SAFECITY', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  --
  WHEN OTHERS THEN
  PV_STATUS  := 'ERROR';
  PV_MENSAJE := 'Error: '||SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'Inkg_Migracion_Alta_Densidad.P_ACTUALIZAR_CARACT_SAFECITY', PV_MENSAJE, 'migracion', SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_ACTUALIZAR_CARACT_SAFECITY;
--
END INKG_MIGRACION_ALTA_DENSIDAD;
/
