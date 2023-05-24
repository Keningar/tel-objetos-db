CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_SOLICITUD_CONSULTA AS

  /*
  * Documentaci�n para TYPE 'Gr_Solicitud'.
  * Type para solicitudes
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 18-10-2021
  */
  TYPE Gr_Solicitud IS RECORD (
      ID_DETALLE_SOLICITUD DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
      ID_PUNTO DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      ESTADO_PUNTO DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
      NOMBRE_SECTOR  DB_COMERCIAL.ADMI_SECTOR.NOMBRE_SECTOR%TYPE,
      NOMBRE_PARROQUIA  DB_COMERCIAL.ADMI_PARROQUIA.NOMBRE_PARROQUIA%TYPE,
      NOMBRE_CANTON DB_COMERCIAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
      ID_PERSONA DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
      RAZON_SOCIAL DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      NOMBRES DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
      APELLIDOS DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
      USR_VENDEDOR DB_COMERCIAL.INFO_PUNTO.USR_VENDEDOR%TYPE,
      LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      NOMBRE_JURISDICCION DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
      LONGITUD DB_COMERCIAL.INFO_PUNTO.LONGITUD%TYPE,
      LATITUD DB_COMERCIAL.INFO_PUNTO.LATITUD%TYPE,
      DIRECCION DB_COMERCIAL.INFO_PUNTO.DIRECCION%TYPE,
      RUTA_CROQUIS DB_COMERCIAL.INFO_PUNTO.RUTA_CROQUIS%TYPE,
      FE_CREACION VARCHAR2(20),
      ESTADO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
      DESCRIPCION_SOLICITUD DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
      OBSERVACION DB_COMERCIAL.INFO_PUNTO.OBSERVACION%TYPE,
      NOMBRE_VENDEDOR VARCHAR2(2000),
      OBSERVACION_SOLICITUD DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
      MOTIVO_ID DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
      ID_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      ESTADO_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      TIPO_ORDEN DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE,
      TERCERIZADORA_ID DB_COMERCIAL.INFO_SERVICIO_TECNICO.TERCERIZADORA_ID%TYPE,
      ID_SERVICIO_TECNICO DB_COMERCIAL.INFO_SERVICIO_TECNICO.ID_SERVICIO_TECNICO%TYPE,
      ULTIMA_MILLA_ID DB_COMERCIAL.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE,
      NUMERO_ROW NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Gr_AsignadosSolicitud'.
  * Type para asignados de solicitudes
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 02-12-2021

  * Documentaci�n para TYPE 'Gr_AsignadosSolicitud'.
  * Se agrego el campo observacion
  * @author Andr�s Montero H. <lardila@telconet.ec>
  * @version 1.1 20-10-2022
  */


  TYPE Gr_AsignadosSolicitud IS RECORD (
      DETALLE_SOLICITUD_ID DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.DETALLE_SOLICITUD_ID%TYPE,
      ID_DETALLE_SOL_PLANIF DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ID_DETALLE_SOL_PLANIF%TYPE,
      ASIGNADO_ID DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ASIGNADO_ID%TYPE,
      FE_INI_PLAN VARCHAR2(20),
      FE_FIN_PLAN VARCHAR2(20),
      OBSERVACION VARCHAR2(4000),
      NOMBRE_ASIGNADO VARCHAR2(1000),
      TIPO_ASIGNADO DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.TIPO_ASIGNADO%TYPE,
      ESTADO DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ESTADO%TYPE,
      ESTADO_TAREA VARCHAR2(20),
      NUMERO_TAREA NUMBER,
      ORIGEN VARCHAR2(2),
      NUMERO_ROW NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Gr_InfoDetalleSolicitud'.
  * Type para solicitud
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 02-12-2021
  */
  TYPE Gr_InfoDetalleSolicitud IS RECORD (
      ID_DETALLE_SOLICITUD DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
      SERVICIO_ID DB_COMERCIAL.INFO_DETALLE_SOLICITUD.SERVICIO_ID%TYPE,
      TIPO_SOLICITUD_ID DB_COMERCIAL.INFO_DETALLE_SOLICITUD.TIPO_SOLICITUD_ID%TYPE,
      DESCRIPCION_SOLICITUD DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
      MOTIVO_ID DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
      NOMBRE_MOTIVO DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
      USR_CREACION DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE,
      FE_CREACION VARCHAR2(20),
      PRECIO_DESCUENTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PRECIO_DESCUENTO%TYPE,
      PORCENTAJE_DESCUENTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE,
      TIPO_DOCUMENTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.TIPO_DOCUMENTO%TYPE,
      OBSERVACION DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
      ESTADO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
      USR_RECHAZO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_RECHAZO%TYPE,
      FE_RECHAZO VARCHAR2(20),
      DETALLE_PROCESO_ID DB_COMERCIAL.INFO_DETALLE_SOLICITUD.DETALLE_PROCESO_ID%TYPE,
      FE_EJECUCION VARCHAR2(20),
      ELEMENTO_ID DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ELEMENTO_ID%TYPE,
      NUMERO_ROW NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Gr_PlanificacionesSolicitud'.
  * Type para inspecciones de solicitud
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 28-04-2022
  */
  TYPE Gr_PlanificacionesSolicitud IS RECORD (
      ID_DETALLE_SOL_PLANIF DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ID_DETALLE_SOL_PLANIF%TYPE,
      ASIGNADO_ID DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ASIGNADO_ID%TYPE,
      TIPO_ASIGNADO DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.TIPO_ASIGNADO%TYPE,
      TAREA_ID DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.TAREA_ID%TYPE,
      FE_INI_PLAN VARCHAR2(20),
      FE_FIN_PLAN VARCHAR2(20),
      USR_CREACION  DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.USR_CREACION%TYPE,
      FE_CREACION VARCHAR2(20),
      ESTADO  DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ESTADO%TYPE,
      MOTIVO_ID  DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.MOTIVO_ID%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Gr_CaracteristicasSolicitud'.
  * Type para caracteristicas de solicitud de inspecci�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 29-04-2022
  */
  TYPE Gr_CaracteristicasSolicitud IS RECORD (
      ID_SOLICITUD_CARACTERISTICA DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE,
      CARACTERISTICA_ID DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.CARACTERISTICA_ID%TYPE,
      DESCRIPCION_CARACTERISTICA DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
      VALOR DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.VALOR%TYPE,
      ESTADO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE,
      USR_CREACION  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.USR_CREACION%TYPE,
      FE_CREACION VARCHAR2(20)
  );

  /*
  * Documentaci�n para TYPE 'Gr_SolicitudInspeccionHist'.
  * Type para historial de solicitud de inspecci�n
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 17-01-2021
  */
  TYPE Gr_SolicitudInspeccionHist IS RECORD (
      ID_DETALLE_SOL_PLANIF_HIST DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST.ID_DETALLE_SOL_PLANIF_HIST%TYPE,
      FE_CREACION VARCHAR2(20),
      NOMBRE_ASIGNADO VARCHAR2(500),
      OBSERVACION DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST.OBSERVACION%TYPE,
      USR_CREACION DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST.USR_CREACION%TYPE,
      ESTADO DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST.ESTADO%TYPE,
      NUMERO_ROW NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Gr_Items'.
  * Type para obtener items tipo varchar2
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 06-05-2021
  */
  TYPE Gr_Items IS RECORD (
      ITEM VARCHAR2(2000)
  );

  /*
  * Documentaci�n para TYPE 'Gr_PlanificacionesAsociadas'.
  * Type para obtener planificaciones asociadas
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 17-06-2022
  */
  TYPE Gr_PlanificacionesAsociadas IS RECORD (
      DETALLE_SOLICITUD_ID DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
      SOLICITUD_ESTADO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
      PLANIFICACION_ID DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ID_DETALLE_SOL_PLANIF%TYPE,
      PLANIFICACION_ESTADO DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.ESTADO%TYPE,
      TAREA_ID DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.TAREA_ID%TYPE,
      COMUNICACION_ID DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
      TAREA_ESTADO DB_SOPORTE.INFO_DETALLE_HISTORIAL.ESTADO%TYPE
  );
  /*
  * Documentaci�n para PROCEDURE 'P_GET_SOLICITUDES'.
  * Procedimiento que obtiene las tareas seg�n los par�metros recibidos
  *
  * PARAMETROS:
  * @Param VARCHAR2 IN  Pcl_Json          -> parametros enviados por json
  * @Param VARCHAR2 OUT Pcl_JsonRespuesta -> respuesta de registros en formato json
  * @Param VARCHAR2 OUT Pn_Total          -> total de registros
  * @Param VARCHAR2 OUT Pv_Status         -> estado de ejecuci�n
  * @Param VARCHAR2 OUT Pv_Message        -> mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 18-10-2021
  */
  PROCEDURE P_GET_SOLICITUDES(Pcl_Json          IN  CLOB,
                             Pcl_JsonRespuesta OUT CLOB,
                             Pn_Total          OUT NUMBER,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Message        OUT VARCHAR2);
 /*
  * Documentaci�n para PROCEDURE 'P_GET_ASIGNADOS_SOL_INSPECCION'.
  * Procedimiento que obtiene los asignados de una solicitud de inspecci�n
  *
  * PARAMETROS:
  * @Param VARCHAR2 IN  Pcl_Json          -> parametros enviados por json
  * @Param VARCHAR2 OUT Pcl_JsonRespuesta -> respuesta de registros en formato json
  * @Param VARCHAR2 OUT Pn_Total          -> total de registros
  * @Param VARCHAR2 OUT Pv_Status         -> estado de ejecuci�n
  * @Param VARCHAR2 OUT Pv_Message        -> mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 18-10-2021
  */
  PROCEDURE P_GET_ASIGNADOS_SOL_INSPECCION(Pcl_Json IN  CLOB,
                             Pcl_JsonRespuesta OUT CLOB,
                             Pn_Total          OUT NUMBER,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Message        OUT VARCHAR2);
 /*
  * Documentaci�n para PROCEDURE 'P_GET_HISTORIAL_SOL_INSPECCION'.
  * Procedimiento que obtiene el historial de una solicitud de inspecci�n
  *
  * PARAMETROS:
  * @Param VARCHAR2 IN  Pcl_Json          -> parametros enviados por json
  * @Param VARCHAR2 OUT Pcl_JsonRespuesta -> respuesta de registros en formato json
  * @Param VARCHAR2 OUT Pn_Total          -> total de registros
  * @Param VARCHAR2 OUT Pv_Status         -> estado de ejecuci�n
  * @Param VARCHAR2 OUT Pv_Message        -> mensaje de respuesta
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 18-10-2021
  */
  PROCEDURE P_GET_HISTORIAL_SOL_INSPECCION(Pcl_Json          IN  CLOB,
                             Pcl_JsonRespuesta OUT CLOB,
                             Pn_Total          OUT NUMBER,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Message        OUT VARCHAR2);
 /*
  * Documentaci�n para PROCEDURE 'P_CONSULTAR_SOLICITUD'.
  * Procedimiento que obtiene las inspecciones asignadas a un empleado
  *
  * PARAMETROS:
  * @Param CLOB IN  Pcl_Request          -> parametros enviados por json
  * @Param VARCHAR2 OUT Pv_Status         -> estado de ejecuci�n
  * @Param VARCHAR2 OUT Pv_Message        -> mensaje de respuesta
  * @Param SYS_REFCURSOR OUT Pcl_Response -> respuesta de registros
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 29-04-2021
  */
  PROCEDURE P_CONSULTAR_SOLICITUD(Pcl_Request          IN  CLOB,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Mensaje        OUT VARCHAR2,
                             Pcl_Response OUT CLOB);
 /*
  * Documentaci�n para PROCEDURE 'P_CONSULTAR_SOLIC_ASOCIADAS'.
  * Procedimiento que obtiene las planificaciones de una solicitud
  *
  * PARAMETROS:
  * @Param CLOB IN  Pcl_Request          -> parametros enviados por json
  * @Param VARCHAR2 OUT Pv_Status         -> estado de ejecuci�n
  * @Param VARCHAR2 OUT Pv_Message        -> mensaje de respuesta
  * @Param SYS_REFCURSOR OUT Pcl_Response -> respuesta de registros
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 17-06-2022
  */
  PROCEDURE P_CONSULTAR_SOLIC_ASOCIADAS(Pcl_Request          IN  CLOB,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Mensaje        OUT VARCHAR2,
                             Pcl_Response OUT CLOB);
 /*
  * Documentaci�n para FUNCTION 'F_GET_NOMBRE_ASIGNADO'.
  * Funci�n que obtiene nombre del asignado por id y tipo de asignado
  *
  * PARAMETROS:
  * @Param VARCHAR2 IN  Pv_tipoAsignado          -> tipo de asignado (Cuadrilla o empleado)
  * @Param VARCHAR2 IN  Pv_idAsignado          -> id del asignado
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 18-10-2021
  */
  FUNCTION F_GET_NOMBRE_ASIGNADO(
      Pv_tipoAsignado DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.TIPO_ASIGNADO%TYPE,
      Pv_idAsignado NUMBER) RETURN VARCHAR2;
 /*
  * Documentaci�n para FUNCTION 'F_GET_ID_PUNTO_SOL_INSP'.
  * Funci�n que obtiene el id del punto asociado a una solicitud de inspecci�n
  *
  * PARAMETROS:
  * @Param NUMBER IN  Pv_idSolicitud -> id de la solicitud
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 18-10-2021
  */
FUNCTION F_GET_ID_PUNTO_SOL_INSP(
  Pv_idSolicitud NUMBER) RETURN VARCHAR2;

 /*
  * Documentaci�n para FUNCTION 'F_GET_PARAMETROS_SOLICITUDES'.
  * Funci�n que obtiene parametros de las solicitudes de inspecci�n
  *
  * PARAMETROS:
  * @Param VARCHAR2 IN  Pv_descripcion -> descripci�n de par�metro det
  * @Param VARCHAR2 IN  Pv_nombreParam -> nombre de par�metro
  * @author Andr�s Montero H. <amontero@telconet.ec>
  * @version 1.0 18-10-2021
  */
FUNCTION F_GET_PARAMETROS_SOLICITUDES(
    Pv_descripcion VARCHAR2,
    Pv_nombreParam VARCHAR2) RETURN VARCHAR2;

END CMKG_SOLICITUD_CONSULTA;

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_SOLICITUD_CONSULTA AS

  PROCEDURE P_GET_SOLICITUDES(Pcl_Json          IN  CLOB,
                             Pcl_JsonRespuesta OUT CLOB,
                             Pn_Total          OUT NUMBER,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Message        OUT VARCHAR2) IS

      Lrf_ReporteTareas        SYS_REFCURSOR;
      Lrf_JsonSolicitudes      SYS_REFCURSOR;
      Lv_QuerySelect           CLOB;
      Lv_QuerySelectServ       VARCHAR2(2000);
      Lv_QueryfromIni          VARCHAR2(1000) := '';
      Lv_QueryfromFin          VARCHAR2(1000) := '';
      Lv_LeftJoinInfoServicio  VARCHAR2(1000) := '';
      Lv_QueryfromServ         VARCHAR2(1000) := '';
      Lv_QueryfromServTec      VARCHAR2(100) := '';
      Lv_FromInsp              VARCHAR2(1000) := '';
      Lv_QueryWhere            VARCHAR2(3000) := '';
      Lv_QueryWhereServ        VARCHAR2(4000) := '';
      Lv_QueryWhereServAdic    VARCHAR2(500)  := '';
      Lv_OrderBy               VARCHAR2(100) := '';
      Lcl_QuerySolicitudes     CLOB;
      Lcl_QuerySolicitudesInsp CLOB;
      Lcl_QueryFinal           CLOB;
      Lcl_QueryFinalOrderBy    CLOB;
      Lr_JsonSolicitudes        Gr_Solicitud;
      Lf_Archivo                UTL_FILE.FILE_TYPE;
      Lv_FromAdicional          VARCHAR2(1000) := '';
      Lv_QueryFromInspNoLogin   VARCHAR2(2000) := '';
      Lv_QueryWhereInspNoLogin  VARCHAR2(2000) := '';

      TYPE T_Array_solicitudes IS TABLE OF Gr_Solicitud INDEX BY BINARY_INTEGER;
      Lt_Solicitudes T_Array_solicitudes;
      Lt_Indice_sol       NUMBER := 1;

      --Variables de apoyo
      Lv_Estados              VARCHAR2(700)   := '''PrePlanificada'','||'''Planificada'','||'''Replanificada'','||
                                                 '''Rechazada'','||'''Detenido'','||'''AsignadoTarea'','||'''Asignada''';
      Lv_EstadosSolMigracion VARCHAR2(700)    := '''PrePlanificada'','||'''AsignadoTarea'','||'''Planificada'','||'''Replanificada''';
      Lv_EstadosOtrasSol     VARCHAR2(700)    := '''PrePlanificada'','||'''Planificada'','||'''Replanificada'','||
                                                 '''Detenido'','||'''AsignadoTarea'','||'''Asignada''';
      Lv_TipoSolicitudes    VARCHAR2(1000)    := '''SOLICITUD PLANIFICACION'','||
                                                 '''SOLICITUD INSPECCION'','||
                                                 '''SOLICITUD REUBICACION'','||
                                                 '''SOLICITUD CAMBIO EQUIPO'','||
                                                 '''SOLICITUD RETIRO EQUIPO'','||
                                                 '''SOLICITUD MIGRACION'','||
                                                 '''SOLICITUD AGREGAR EQUIPO'','||
                                                 '''SOLICITUD AGREGAR EQUIPO MASIVO'','||
                                                 '''SOLICITUD CAMBIO EQUIPO POR SOPORTE'','||
                                                 '''SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO'','||
                                                 '''SOLICITUD DE INSTALACION CABLEADO ETHERNET''';

      Lv_OtrosTiposSolicitudes VARCHAR2(1000) := '''SOLICITUD CAMBIO EQUIPO'','||
                                                 '''SOLICITUD RETIRO EQUIPO'','||
                                                 '''SOLICITUD PLANIFICACION'','||
                                                 '''SOLICITUD AGREGAR EQUIPO'','||
                                                 '''SOLICITUD AGREGAR EQUIPO MASIVO'','||
                                                 '''SOLICITUD CAMBIO EQUIPO POR SOPORTE'','||
                                                 '''SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO'','||
                                                 '''SOLICITUD DE INSTALACION CABLEADO ETHERNET''';
      Lv_OtrosTiposSolicitudesIds VARCHAR2(100) := '';

      Lv_EstadosSolicitudCambioEq VARCHAR2(200)  :='''Activo'','||'''Cancelado''';

      Lv_SolicitudesPlanificacion      VARCHAR2(200) := '''SOLICITUD PLANIFICACION'','||
                                                        '''SOLICITUD MIGRACION'','||
                                                        '''SOLICITUD REUBICACION'','||
                                                        '''SOLICITUD DE INSTALACION CABLEADO ETHERNET''';
      Lv_SolicitudesPlanificacionIds VARCHAR2(100) := '';

      Lv_SolicitudesCambioEquipo  VARCHAR2(200)      := '''SOLICITUD CAMBIO EQUIPO'','||
                                                        '''SOLICITUD RETIRO EQUIPO'','||
                                                        '''SOLICITUD AGREGAR EQUIPO'','||
                                                        '''SOLICITUD AGREGAR EQUIPO MASIVO'','||
                                                        '''SOLICITUD CAMBIO EQUIPO POR SOPORTE'','||
                                                        '''SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO''';

      Lv_SolicitudesCambioEquipoIds VARCHAR2(100) := '';

      Lv_SolicitudPlanificacion  VARCHAR2(200)  := 'SOLICITUD PLANIFICACION';
      Lv_SolicitudInspeccion     VARCHAR2(200)  := 'SOLICITUD INSPECCION';
      Lv_CaracteristicaLoginInsp VARCHAR2(200)  := 'LOGIN_INSPECCION';

      --Filtros para el Query dinamico
      Lv_FeDesdePLanif            VARCHAR2(20);
      Lv_FeHastaPLanif            VARCHAR2(20);
      Lv_Login                    VARCHAR2(100);
      Lv_DescripcionPunto         VARCHAR2(200);
      Lv_EstadoPunto              VARCHAR2(100);
      Lv_Vendedor                 VARCHAR2(500);
      Lv_Ciudad                   VARCHAR2(200);
      Lv_Estado                   VARCHAR2(200);
      Lv_TipoSolicitud            VARCHAR2(200);
      Lv_IdSector                 VARCHAR2(50);
      Lv_Identificacion           VARCHAR2(50);
      Lv_Nombres                  VARCHAR2(200);
      Lv_Apellidos                VARCHAR2(200);
      Lv_UltimaMilla              VARCHAR2(50);
      Lv_PrefijoEmpresa           VARCHAR2(50);
      Lv_ArrayTipoOrden           VARCHAR2(100);
      Lv_ArrayDescProd            VARCHAR2(500);
      Lv_ArrayDescProdException   VARCHAR2(500);
      Lv_Grupo                    VARCHAR2(200);
      Lv_Region                   VARCHAR2(100);
      Lv_ProdAdicional            VARCHAR2(200);
      Lv_CodEmpresa               VARCHAR2(100);
      Ln_IdTipoSolicitudConsult   NUMBER;
      Lv_PermiteVerInspecciones   VARCHAR2(3);
      Lv_LimiteConsulta           NUMBER;
      Lv_Json                     VARCHAR2(4000);
      Lv_Codigo                   VARCHAR2(30) := ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
      Lv_EsConsulta               VARCHAR2(3);
      Lv_Start                    VARCHAR2(10);
      Lv_Limit                    VARCHAR2(10);
      Ln_cantFilConsultCoor       NUMBER;
      Lv_NombreParamFiltroTipoSol VARCHAR2(100);
      Lv_NombreParamFiltroNombTec VARCHAR2(100);
      Lv_ArrayFiltroConsultCoor   VARCHAR2(500);
      Lv_TotalFiltroConsultCoor   NUMBER;
      Lv_TipoSolicitudPerfilCoor  VARCHAR2(500);
      Lv_ArrayTipoOrdenPerfilCoor VARCHAR2(500);
      Le_Exception EXCEPTION;

    BEGIN

      apex_json.parse(Pcl_Json);

      Lv_Start           := apex_json.get_varchar2('start');
      Lv_Limit           := apex_json.get_varchar2('limit');

      --Parseo del Json de Tareas.
      Lv_FeDesdePLanif            := apex_json.get_varchar2('fechaDesdePlanif');
      Lv_FeHastaPLanif            := apex_json.get_varchar2('fechaHastaPlanif');
      Lv_Login                    := apex_json.get_varchar2('login');
      Lv_DescripcionPunto         := apex_json.get_varchar2('descripcionPunto');
      Lv_EstadoPunto              := apex_json.get_varchar2('estadoPunto');
      Lv_Vendedor                 := apex_json.get_varchar2('vendedor');
      Lv_Ciudad                   := apex_json.get_varchar2('ciudad');
      Lv_Estado                   := apex_json.get_varchar2('estado');
      Lv_TipoSolicitud            := apex_json.get_varchar2('tipoSolicitud');
      Lv_IdSector                 := apex_json.get_varchar2('idSector');
      Lv_Identificacion           := apex_json.get_varchar2('identificacion');
      Lv_Nombres                  := apex_json.get_varchar2('nombres');
      Lv_Apellidos                := apex_json.get_varchar2('apellidos');
      Lv_UltimaMilla              := apex_json.get_varchar2('ultimaMilla');
      Lv_PrefijoEmpresa           := apex_json.get_varchar2('prefijoEmpresa');
      Lv_ArrayTipoOrden           := apex_json.get_varchar2('arrayTipoOrden');
      Lv_ArrayDescProd            := apex_json.get_varchar2('arrayDescripcionProducto');
      Lv_ArrayDescProdException   := apex_json.get_varchar2('arrayDescripcionProductoExcepcion');
      Lv_Grupo                    := apex_json.get_varchar2('grupo');
      Lv_Region                   := apex_json.get_varchar2('region');
      Lv_ProdAdicional            := apex_json.get_varchar2('prodAdicional');
      Lv_CodEmpresa               := apex_json.get_varchar2('codEmpresa');

      Lv_ArrayFiltroConsultCoor   := apex_json.get_varchar2('arrayFiltrosConsultaCoordinar');
      Lv_TotalFiltroConsultCoor   := apex_json.get_number('intNumTotalFiltrosConsultaCoordinar');
      Lv_TipoSolicitudPerfilCoor  := apex_json.get_varchar2('tipoSolicitudPerfilesCoordinar');
      Lv_ArrayTipoOrdenPerfilCoor := apex_json.get_varchar2('arrayTipoOrdenPerfilesCoordinar');

      --BUSCA LOS IDS DE LAS SOLICITUDES
      Lv_OtrosTiposSolicitudesIds := DB_COMERCIAL.CMKG_SOLICITUD_CONSULTA.F_GET_PARAMETROS_SOLICITUDES('OtrosTiposSolicitudes',
                                                                                                       'TIPOS_SOLICITUD_GRID_PLANIFICACION_COORDINAR');
      Lv_SolicitudesPlanificacionIds := DB_COMERCIAL.CMKG_SOLICITUD_CONSULTA.F_GET_PARAMETROS_SOLICITUDES('SolicitudesPlanificacion',
                                                                                                          'TIPOS_SOLICITUD_GRID_PLANIFICACION_COORDINAR');
      Lv_SolicitudesCambioEquipoIds := DB_COMERCIAL.CMKG_SOLICITUD_CONSULTA.F_GET_PARAMETROS_SOLICITUDES('SolicitudesCambioEquipo',
                                                                                                         'TIPOS_SOLICITUD_GRID_PLANIFICACION_COORDINAR');
      Lv_PermiteVerInspecciones     := DB_COMERCIAL.CMKG_SOLICITUD_CONSULTA.F_GET_PARAMETROS_SOLICITUDES('PermiteVerInspecciones'||
                                                                                                          UPPER(Lv_PrefijoEmpresa),
                                                                                                         'TIPOS_SOLICITUD_GRID_PLANIFICACION_COORDINAR');
      Lv_LimiteConsulta             := DB_COMERCIAL.CMKG_SOLICITUD_CONSULTA.F_GET_PARAMETROS_SOLICITUDES('LIMITE CONSULTA SOLICITUDES',
                                                                                                   'LIMITE_CONSULTA_SOLICITUDES_TELCOS');
     Lv_QuerySelect := ' SELECT ' ||
                       ' ds.id_detalle_solicitud AS iddetallesolicitud, '||
                       ' p.id_punto AS idpunto, '||
                       ' p.estado AS estadopunto, '||
                       ' se.nombre_sector, ' ||
                       ' pa.nombre_parroquia, ' ||
                       ' ca.nombre_canton, ' ||
                       ' pe.id_persona AS id_persona, '||
                       ' pe.razon_social, ' ||
                       ' pe.nombres, ' ||
                       ' pe.apellidos, ' ||
                       ' p.usr_vendedor,' ||
                       ' p.login, ' ||
                       ' aj.nombre_jurisdiccion, ' ||
                       ' p.longitud, ' ||
                       ' p.latitud, ' ||
                       ' p.direccion, ' ||
                       ' p.ruta_croquis AS rutacroquis, ' ||
                       'TO_CHAR(ds.FE_CREACION,''RRRR-MM-DD HH24:MI'') AS feCreacion,'||
                       ' ds.estado, ' ||
                       ' ts.descripcion_solicitud, '||
                       ' p.observacion AS observacion, ' ||
                       q'[CONCAT(peVend.nombres,CONCAT(' ',peVend.apellidos)) AS nombrevendedor, ]' ||
                       ' ds.observacion AS observacion_solicitud, '||
                       ' ds.motivo_id as motivoId, '
                       ;
     Lv_QuerySelectServ := 
                       ' s.id_servicio AS idservicio, '||
                       ' s.estado AS estadoservicio, ' ||
                       ' s.tipo_orden, ' ||
                       ' st.tercerizadora_id, ' ||
                       ' st.id_servicio_tecnico AS idserviciotecnico, '||
                       ' st.ultima_milla_id ';

       Lv_QueryfromIni :=  ' FROM ' ||
                           ' DB_COMERCIAL.Admi_Tipo_Solicitud ts, ';

      Lv_QueryfromServ :=  ' DB_COMERCIAL.Info_Servicio s , ';
      Lv_QueryfromServTec := ' DB_COMERCIAL.Info_Servicio_Tecnico st, ';
      Lv_QueryfromFin  :=
                            'DB_COMERCIAL.Info_Detalle_Solicitud ds, '||
                            'DB_COMERCIAL.Info_Persona pe, '||
                            'DB_COMERCIAL.Info_Persona_Empresa_Rol per, '||
                            'DB_COMERCIAL.Info_Empresa_Rol er, '||
                            'DB_COMERCIAL.Admi_Rol ar, '||
                            'DB_COMERCIAL.Admi_Tipo_Rol atr, '||
                            'DB_INFRAESTRUCTURA.Admi_Jurisdiccion aj, '||
                            'DB_COMERCIAL.Admi_Sector se, '||
                            'DB_COMERCIAL.Admi_Parroquia pa, '||
                            'DB_COMERCIAL.Admi_Canton ca, '||
                            'DB_COMERCIAL.Info_Punto p ' 
                            ||
                            'LEFT JOIN DB_COMERCIAL.Info_Persona peVend ON peVend.login = p.usr_vendedor '
                            ;
        Lv_QueryWhere :=    'WHERE ' ||
                            ' ts.id_tipo_solicitud = ds.tipo_Solicitud_Id ';

        Lv_QueryWhereServ := ' AND s.punto_id = p.id_punto '||
                             ' AND s.id_servicio = ds.servicio_id '||
                             ' AND st.servicio_id = s.id_servicio ';

        Lv_QueryFromInspNoLogin := ' FROM db_comercial.info_detalle_solicitud      ds '||
                                  ' JOIN db_comercial.admi_tipo_solicitud    ts ON ts.id_tipo_solicitud = ds.tipo_solicitud_id ' ||
                                  ' LEFT JOIN db_comercial.info_punto p ON p.id_punto = db_comercial.cmkg_solicitud_consulta.F_GET_ID_PUNTO_SOL_INSP(ds.id_detalle_solicitud)  ' || 
                                  ' LEFT JOIN db_comercial.info_persona_empresa_rol per ON p.persona_empresa_rol_id = per.id_persona_rol  ' || 
                                  ' LEFT JOIN db_comercial.info_empresa_rol er ON per.empresa_rol_id = er.id_empresa_rol  ' || 
                                  ' LEFT JOIN db_comercial.info_persona pevend ON pevend.login = p.usr_vendedor  ' || 
                                  ' LEFT JOIN db_comercial.admi_sector se ON p.sector_id = se.id_sector ' || 
                                  ' LEFT JOIN db_comercial.admi_parroquia pa ON se.parroquia_id = pa.id_parroquia ' || 
                                  ' LEFT JOIN db_comercial.admi_canton ca ON pa.canton_id = ca.id_canton ' || 
                                  ' LEFT JOIN db_infraestructura.admi_jurisdiccion aj ON aj.id_jurisdiccion = p.punto_cobertura_id ' || 
                                  ' LEFT JOIN db_comercial.admi_rol ar ON er.rol_id = ar.id_rol ' || 
                                  ' LEFT JOIN db_comercial.info_persona pe ON per.persona_id = pe.id_persona ' || 
                                  ' LEFT JOIN db_comercial.admi_tipo_rol atr ON ar.tipo_rol_id = atr.id_tipo_rol ';

        Lv_QueryWhereInspNoLogin := ' WHERE ' ||
                                    '1=1 ';

      IF Lv_FeDesdePLanif IS NOT NULL THEN
          Lv_FeDesdePLanif := TO_CHAR(TO_dATE(Lv_FeDesdePLanif,'RRRR-MM-DD'),'RRRR-MM-DD');
          Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ds.FE_CREACION,''RRRR-MM-DD'') >= :paramFechaCreacionD';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramFechaCreacionD',''''||Lv_FeDesdePLanif||'''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND TO_CHAR(ds.FE_CREACION,''RRRR-MM-DD'') >= :paramFechaCreacionD';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramFechaCreacionD',''''||Lv_FeDesdePLanif||'''');
      END IF;

      IF Lv_FeHastaPLanif IS NOT NULL THEN
          Lv_FeHastaPLanif := TO_CHAR(TO_dATE(Lv_FeHastaPLanif,'RRRR-MM-DD'),'RRRR-MM-DD');
          Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(ds.FE_CREACION,''RRRR-MM-DD'') <= :paramFechaCreacionH';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramFechaCreacionH',''''||Lv_FeHastaPLanif||'''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND TO_CHAR(ds.FE_CREACION,''RRRR-MM-DD'') <= :paramFechaCreacionH';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramFechaCreacionH',''''||Lv_FeHastaPLanif||'''');
      END IF;

      IF Lv_Login IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere || ' AND UPPER(p.login) like UPPER(:paramLogin) ';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramLogin',''''||Lv_Login||'%''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin || ' AND UPPER(p.login) like UPPER(:paramLogin) ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramLogin',''''||Lv_Login||'%''');
      END IF;

      IF Lv_DescripcionPunto IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(p.descripcion_Punto) like UPPER(:paramDescripcionPunto) ';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDescripcionPunto','''%'||Lv_DescripcionPunto||'%''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND UPPER(p.descripcion_Punto) like UPPER(:paramDescripcionPunto) ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramDescripcionPunto','''%'||Lv_DescripcionPunto||'%''');
      END IF;

      IF Lv_EstadoPunto IS NOT NULL AND UPPER(Lv_EstadoPunto) <> 'TODOS'  THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND p.estado = :paramEstadoPunto ';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadoPunto',''''||Lv_EstadoPunto||'''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND p.estado = :paramEstadoPunto ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramEstadoPunto',''''||Lv_EstadoPunto||'''');
      END IF;

      IF Lv_Vendedor IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||q'[ AND CONCAT(LOWER(peVend.nombres),CONCAT(' ',LOWER(peVend.apellidos))) like LOWER(:paramVendedor) ]';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramVendedor','''%'||Lv_Vendedor||'%''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||
                                      q'[ AND CONCAT(LOWER(peVend.nombres),CONCAT(' ',LOWER(peVend.apellidos))) like LOWER(:paramVendedor) ]';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramVendedor','''%'||Lv_Vendedor||'%''');
      END IF;

      IF Lv_Ciudad IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(ca.nombre_Canton) IN (:paramCiudad) ';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramCiudad',Lv_Ciudad);
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND UPPER(ca.nombre_Canton) IN (:paramCiudad) ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramCiudad',Lv_Ciudad);
      END IF;

      IF Lv_Estado IS NOT NULL THEN
          IF INSTR(Lv_Estados,Lv_Estado) > 0 THEN
            Lv_QueryWhereServ := Lv_QueryWhereServ ||' AND (ds.estado = :paramEstado) ';
            Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramEstado',''''||Lv_Estado||'''');
            Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND (ds.estado = :paramEstado) ';
            Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramEstado',''''||Lv_Estado||'''');
          ELSE
            IF Lv_TipoSolicitud = 'SOLICITUD MIGRACION' THEN
              Lv_QueryWhereServ := Lv_QueryWhereServ ||' AND (ds.estado IN (:paramEstados) )  ';
              Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramEstados',Lv_EstadosSolMigracion);

            ELSIF Lv_TipoSolicitud = 'SOLICITUD PLANIFICACION' OR
                  Lv_TipoSolicitud = 'SOLICITUD CAMBIO EQUIPO' OR
                  Lv_TipoSolicitud = 'SOLICITUD RETIRO EQUIPO' OR
                  Lv_TipoSolicitud = 'SOLICITUD AGREGAR EQUIPO' OR
                  Lv_TipoSolicitud = 'SOLICITUD AGREGAR EQUIPO MASIVO' OR
                  Lv_TipoSolicitud = 'SOLICITUD REUBICACION' OR
                  Lv_TipoSolicitud = 'SOLICITUD CAMBIO EQUIPO POR SOPORTE' OR
                  Lv_TipoSolicitud = 'SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO' OR
                  Lv_TipoSolicitud = 'SOLICITUD DE INSTALACION CABLEADO ETHERNET' 
             THEN
               Lv_QueryWhereServ := Lv_QueryWhereServ ||' AND (ds.estado IN (:paramEstados) )  ';
               Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramEstados',Lv_EstadosOtrasSol);

             ELSIF Lv_ArrayFiltroConsultCoor IS NULL THEN
                Lv_QueryWhereServ :=  Lv_QueryWhereServ ||
                                 ' AND ( (ts.descripcion_Solicitud = :paramTipoSolicitude AND ds.estado IN (:paramEstadoPers) ) OR ' ||
                                 '(ds.tipo_solicitud_id IN (:paramTipoSolici) AND ds.estado IN (:paramEstadoPerso))) ';
                Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramTipoSolicitude',''''||'SOLICITUD MIGRACION'||'''');
                Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramTipoSolici',Lv_OtrosTiposSolicitudesIds);
                Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramEstadoPerso',Lv_EstadosOtrasSol);
                Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramEstadoPers',Lv_EstadosSolMigracion);
            END IF;
          END IF;
      END IF;

      IF Lv_ArrayFiltroConsultCoor IS NOT NULL THEN
        Lv_LeftJoinInfoServicio := Lv_LeftJoinInfoServicio || ' LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO prod ON prod.ID_PRODUCTO = s.PRODUCTO_ID ,  ';
        IF Lv_Estado IS NULL OR INSTR(Lv_Estados,Lv_Estado) <= 0 THEN
                Lv_QueryWhereServ := Lv_QueryWhereServ ||' AND (ds.estado IN (:paramEstadosSolPerfilesCoord) )  ';
               Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramEstadosSolPerfilesCoord',Lv_EstadosOtrasSol);
        END IF;

        Lv_QueryWhereServ := Lv_QueryWhereServ ||' AND ( ';--Validaci�n 1
        Lv_QueryWhereServ := Lv_QueryWhereServ ||'        (s.PRODUCTO_ID = prod.ID_PRODUCTO ';--Validaci�n 2
        Lv_QueryWhereServ := Lv_QueryWhereServ ||'         AND ( ';--Validaci�n 3

        apex_json.parse('{"data":'||Lv_ArrayFiltroConsultCoor||'}');
        Ln_cantFilConsultCoor := apex_json.get_count(p_path => 'data');

        Lv_NombreParamFiltroTipoSol := '';
        Lv_NombreParamFiltroNombTec := '';

        IF Ln_cantFilConsultCoor > 0 THEN
          FOR j IN 1 .. Ln_cantFilConsultCoor LOOP

                  Lv_NombreParamFiltroTipoSol := ':filtroTipoSol'||j;
                  Lv_NombreParamFiltroNombTec := ':filtroNombreTecnico'||j;

                  Lv_QueryWhereServ := Lv_QueryWhereServ || ' ( ts.DESCRIPCION_SOLICITUD = '||Lv_NombreParamFiltroTipoSol ||
                                                            ' AND prod.NOMBRE_TECNICO = '||Lv_NombreParamFiltroNombTec||' ) ';
                  Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,Lv_NombreParamFiltroTipoSol, 
                                                ''''||apex_json.get_varchar2(p_path => 'data[%d].tipoSolicitud',p0 => j)||'''');
                  Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,Lv_NombreParamFiltroNombTec, 
                                                ''''||apex_json.get_varchar2(p_path => 'data[%d].nombreTecnicoProd',p0 => j)||'''');

                  IF j < Ln_cantFilConsultCoor THEN
                    Lv_QueryWhereServ := Lv_QueryWhereServ || ' OR ';
                  END IF;

          END LOOP;
        END IF;

        Lv_QueryWhereServ := Lv_QueryWhereServ ||'         ) ';--Validaci�n 3
        Lv_QueryWhereServ := Lv_QueryWhereServ ||'        ) ';--Validaci�n 2

        IF (Lv_TipoSolicitudPerfilCoor IS NOT NULL) THEN
          Lv_QueryWhereServAdic := '';
          IF INSTR(Lv_TipoSolicitudes,Lv_TipoSolicitudPerfilCoor) > 0 THEN
            Lv_QueryWhereServAdic := Lv_QueryWhereServAdic || '  ts.DESCRIPCION_SOLICITUD = :paramTipoSolicitudPerfilCoord AND  ';
            Lv_QueryWhereServAdic := REPLACE(Lv_QueryWhereServAdic,':paramTipoSolicitudPerfilCoord',''''||Lv_TipoSolicitudPerfilCoor||'''' );
          END IF;

          IF ( Lv_TipoSolicitudPerfilCoor = 'SOLICITUD CAMBIO EQUIPO' OR
                Lv_TipoSolicitudPerfilCoor = 'SOLICITUD RETIRO EQUIPO' OR
                Lv_TipoSolicitudPerfilCoor = 'SOLICITUD AGREGAR EQUIPO' OR
                Lv_TipoSolicitudPerfilCoor = 'SOLICITUD AGREGAR EQUIPO MASIVO' OR
                Lv_TipoSolicitudPerfilCoor = 'SOLICITUD CAMBIO EQUIPO POR SOPORTE' OR
                Lv_TipoSolicitudPerfilCoor = 'SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO' )
          THEN
                Lv_QueryWhereServAdic := Lv_QueryWhereServAdic || '   per.ESTADO IN (:paramEstadoPerPerfilCoord) AND   ';
                Lv_QueryWhereServAdic := REPLACE(Lv_QueryWhereServAdic,':paramEstadoPerPerfilCoord',Lv_EstadosSolicitudCambioEq );

          ELSIF ( Lv_TipoSolicitudPerfilCoor = 'SOLICITUD PLANIFICACION' OR
                  Lv_TipoSolicitudPerfilCoor = 'SOLICITUD MIGRACION' ) THEN

                Lv_QueryWhereServAdic := Lv_QueryWhereServAdic || '   per.ESTADO = :paramEstadoPerPerfilCoord AND  ';
                Lv_QueryWhereServAdic := REPLACE(Lv_QueryWhereServAdic,':paramEstadoPerPerfilCoord',''''||'Activo'||'''' );
          END IF;

          IF Lv_ArrayTipoOrdenPerfilCoor IS NOT NULL THEN

              Lv_QueryWhereServAdic := Lv_QueryWhereServAdic || '   s.TIPO_ORDEN in (:tipoOrdenPerfilesCoordinar) AND  ';
              Lv_QueryWhereServAdic := REPLACE(Lv_QueryWhereServAdic,':tipoOrdenPerfilesCoordinar',Lv_ArrayTipoOrdenPerfilCoor );
          END IF;

          IF ( UPPER(Lv_TipoSolicitudPerfilCoor) =  UPPER(Lv_SolicitudPlanificacion) AND 
             (Lv_ProdAdicional IS NULL OR UPPER(Lv_ProdAdicional) <> 'SI') ) THEN
            Lv_QueryWhereServAdic := Lv_QueryWhereServAdic || '   s.ESTADO = ds.ESTADO AND  ';
          END IF;

          IF Lv_QueryWhereServAdic IS NOT NULL THEN
            Lv_QueryWhereServ := Lv_QueryWhereServ || ' OR (' || RTRIM(Lv_QueryWhereServAdic, 'AND ') || ') ';
          END IF;

        END IF;
        Lv_QueryWhereServ := Lv_QueryWhereServ || '     ) ';--Validaci�n 1

        IF Lv_TipoSolicitud IS NOT NULL AND INSTR(Lv_TipoSolicitudes,Lv_TipoSolicitud) > 0 THEN
          Lv_QueryWhereServ := Lv_QueryWhereServ || 'AND ts.DESCRIPCION_SOLICITUD = :paramTipoSolFiltroPerfilCoord ';
          Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramTipoSolFiltroPerfilCoord',''''||Lv_TipoSolicitud||'''' );
        END IF;

      ELSIF Lv_TipoSolicitud IS NOT NULL THEN

          --CONSULTA EL ID DEL TIPO DE SOLICITUD
          SELECT ID_TIPO_SOLICITUD INTO Ln_IdTipoSolicitudConsult FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD WHERE DESCRIPCION_SOLICITUD = Lv_TipoSolicitud;

          IF INSTR(Lv_TipoSolicitudes,Lv_TipoSolicitud) > 0 THEN

            IF Lv_TipoSolicitud <> 'SOLICITUD INSPECCION' THEN
              Lv_QueryWhere := Lv_QueryWhere ||' AND ts.descripcion_Solicitud = :paramTipoSolicitud  ';
              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramTipoSolicitud',''''||Lv_TipoSolicitud||'''');
            ELSE
              Lv_QueryWhere := Lv_QueryWhere ||' AND ds.tipo_solicitud_id = :paramIdTipoSolicitud  ';
              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramIdTipoSolicitud',Ln_IdTipoSolicitudConsult);
              Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND ds.tipo_solicitud_id = :paramIdTipoSolicitud  ';
              Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramIdTipoSolicitud',Ln_IdTipoSolicitudConsult);

            END IF;

          END IF;

          IF Lv_TipoSolicitud = 'SOLICITUD CAMBIO EQUIPO' OR
          Lv_TipoSolicitud = 'SOLICITUD RETIRO EQUIPO' OR
          Lv_TipoSolicitud = 'SOLICITUD AGREGAR EQUIPO' OR
          Lv_TipoSolicitud = 'SOLICITUD AGREGAR EQUIPO MASIVO' OR
          Lv_TipoSolicitud = 'SOLICITUD CAMBIO EQUIPO POR SOPORTE' OR
          Lv_TipoSolicitud = 'SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO' THEN
               Lv_QueryWhere := Lv_QueryWhere ||' AND per.estado IN (:paramEstadoPer) ';
               Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadoPer',Lv_EstadosSolicitudCambioEq);
          ELSIF Lv_TipoSolicitud = 'SOLICITUD PLANIFICACION' OR Lv_TipoSolicitud = 'SOLICITUD MIGRACION' THEN
               Lv_QueryWhere := Lv_QueryWhere ||' AND per.estado = :paramEstadoPer ';
               Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramEstadoPer',''''||'Activo'||'''');
          END IF;
      ELSE

          Lv_QueryWhereServ :=  Lv_QueryWhereServ ||
                                ' AND ( (ds.tipo_solicitud_id IN (:paramTipoSolicitudes) AND per.estado = :paramEstadoPer ) OR ' ||
                                '(ds.tipo_solicitud_id IN (:paramTipoSolicitu) AND per.estado IN (:paramEstadoPe))) ';

          Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramTipoSolicitudes',Lv_SolicitudesPlanificacionIds);
          Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramEstadoPer',''''||'Activo'||'''');
          Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramTipoSolicitu',Lv_SolicitudesCambioEquipoIds);
          Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramEstadoPe',Lv_EstadosSolicitudCambioEq);
      END IF;

      IF Lv_IdSector IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND se.id_sector = :paramIdSector ';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramIdSector',Lv_IdSector);
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND se.id_sector = :paramIdSector ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramIdSector',Lv_IdSector);
      END IF;

      IF Lv_Identificacion IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND pe.identificacion_Cliente = :paramIdentificacion  ';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramIdentificacion',''''||Lv_Identificacion||'''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND pe.identificacion_Cliente = :paramIdentificacion  ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramIdentificacion',''''||Lv_Identificacion||'''');
      END IF;

      IF Lv_Nombres IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(pe.nombres) like UPPER(:paramNombres)   ';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramNombres','''%'||Lv_Nombres||'%''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND UPPER(pe.nombres) like UPPER(:paramNombres)   ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramNombres','''%'||Lv_Nombres||'%''');
      END IF;

      IF Lv_Apellidos IS NOT NULL THEN
          Lv_QueryWhere := Lv_QueryWhere ||' AND UPPER(pe.apellidos) like UPPER(:paramApellidos) ';
          Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramApellidos','''%'||Lv_Apellidos||'%''');
          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND UPPER(pe.apellidos) like UPPER(:paramApellidos) ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramApellidos','''%'||Lv_Apellidos||'%''');
      END IF;

      IF Lv_UltimaMilla IS NOT NULL THEN
          Lv_QueryWhereServ := Lv_QueryWhereServ ||' AND st.ultima_Milla_Id = :paramUltimaMilla ';
          Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramUltimaMilla',Lv_UltimaMilla);
      END IF;

      --Si el TIPO DE ORDEN viene en el arreglo se filtra por esa tipo de orden
      IF Lv_PrefijoEmpresa = 'MD' AND Lv_ArrayTipoOrden IS NOT NULL THEN
            Lv_QueryWhereServ := Lv_QueryWhereServ ||' AND s.tipo_Orden  in (:tipoOrden) ';
            Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':tipoOrden',Lv_ArrayTipoOrden);
      END IF;

      IF Lv_PrefijoEmpresa = 'TN' THEN

        IF  Lv_ArrayDescProd IS NOT NULL THEN
            Lv_QueryfromServ := Lv_QueryfromServ || ' DB_COMERCIAL.ADMI_PRODUCTO prod,  ';
            Lv_QueryWhereServ:= Lv_QueryWhereServ || ' AND s.PRODUCTO_ID = prod.ID_PRODUCTO AND prod.DESCRIPCION_PRODUCTO IN(:descripcionProducto) ';
            Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':descripcionProducto',Lv_ArrayDescProd);
        END IF;

        IF  Lv_ArrayDescProdException IS NOT NULL THEN
          Lv_QueryfromServ := Lv_QueryfromServ ||' DB_COMERCIAL.ADMI_PRODUCTO prod,  ';
          Lv_QueryWhereServ :=Lv_QueryWhereServ ||' AND s.PRODUCTO_ID = prod.ID_PRODUCTO AND prod.DESCRIPCION_PRODUCTO NOT IN(:descripcionProducto) ';
          Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':descripcionProducto',Lv_ArrayDescProdException);
        END IF;

      END IF;

      IF Lv_Grupo = 'DATACENTER' AND Lv_Region IS NOT NULL THEN

              Lv_FromAdicional := Lv_FromAdicional ||
                          '  DB_COMERCIAL.INFO_OFICINA_GRUPO oficina, ' ||
                          '  DB_COMERCIAL.ADMI_CANTON canton, ' ||
                          ' DB_COMERCIAL.ADMI_PROVINCIA provincia, ' ||
                          '  DB_COMERCIAL.ADMI_REGION region,  ';
              Lv_QueryWhere := Lv_QueryWhere ||  ' AND aj.oficina_Id  = oficina.id_oficina '||
              ' AND oficina.canton_Id    = canton.id_canton' ||
              ' AND canton.provincia_Id  = provincia.id_provincia'||
              ' AND provincia.region_Id  = region.id_region '||
              ' AND region.nombre_Region = :region ';
              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':region',''''||Lv_Region||'''');

              Lv_QueryFromInspNoLogin := Lv_QueryFromInspNoLogin  || 
                                        ' LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO oficina ON aj.oficina_Id  = oficina.id_oficina  ' || 
                                        ' LEFT JOIN DB_COMERCIAL.ADMI_CANTON canton ON oficina.canton_Id    = canton.id_canton  ' || 
                                        ' LEFT JOIN DB_COMERCIAL.ADMI_PROVINCIA provincia ON canton.provincia_Id  = provincia.id_provincia  ' || 
                                        ' LEFT JOIN DB_COMERCIAL.ADMI_REGION region ON provincia.region_Id  = region.id_region ';
              Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND region.nombre_Region = :region  ';
              Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':region',''''||Lv_Region||'''');

      END IF;

      IF (Lv_TipoSolicitud = Lv_SolicitudPlanificacion AND (Lv_ProdAdicional IS NULL OR UPPER(Lv_ProdAdicional) <> 'SI' )) THEN

          Lv_QueryWhereServ := Lv_QueryWhereServ || ' AND s.estado = ds.estado ';

      ELSIF ((Lv_TipoSolicitud IS NULL) AND (Lv_ProdAdicional IS NULL OR UPPER(Lv_ProdAdicional) <> 'SI' ) 
                                        AND Lv_ArrayFiltroConsultCoor IS NULL ) THEN
          Lv_QueryWhereServ := Lv_QueryWhereServ || ' AND (( s.estado = ds.estado AND ts.descripcion_Solicitud = :paramTipoSoli ) OR ' ||
                                  ' (s.estado <> ds.estado AND ts.descripcion_Solicitud <> :paramTipoSoli)) ';
          Lv_QueryWhereServ := REPLACE(Lv_QueryWhereServ,':paramTipoSoli',''''||Lv_SolicitudPlanificacion||'''');
      END IF;

      Lv_QueryWhere := Lv_QueryWhere ||
                                  'AND p.persona_Empresa_Rol_Id = per.id_persona_rol ' ||
                                  'AND per.empresa_Rol_Id = er.id_empresa_rol ' ||
                                  'AND er.rol_Id = ar.id_rol ' ||
                                  'AND per.persona_Id = pe.id_persona ' ||
                                  'AND p.sector_Id = se.id_sector ' ||
                                  'AND se.parroquia_Id = pa.id_parroquia ' ||
                                  'AND pa.canton_Id = ca.id_canton ' ||
                                  'AND aj.id_jurisdiccion = p.punto_Cobertura_Id ' ||
                                  'AND er.empresa_Cod = :paramCodEmpresa ' ||
                                  'AND ar.tipo_Rol_Id = atr.id_tipo_rol ' ||
                                  'AND atr.descripcion_Tipo_Rol = :paramDescripcionTipoRol ';

      Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramCodEmpresa', ''''||Lv_CodEmpresa||'''');
      Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramDescripcionTipoRol',''''||'Cliente'||'''');

      IF Lv_LeftJoinInfoServicio IS NOT NULL THEN
          Lv_QueryfromServ := RTRIM(Lv_QueryfromServ,', ');
      END IF;

      Lcl_QuerySolicitudes := Lv_QuerySelect     ||
                              Lv_QuerySelectServ ||
                              Lv_QueryfromIni    ||
                              Lv_QueryfromServ   ||
                              Lv_LeftJoinInfoServicio ||
                              Lv_QueryfromServTec ||
                              Lv_FromAdicional   ||
                              Lv_QueryfromFin    ||
                              Lv_QueryWhere      ||
                              Lv_QueryWhereServ ;

      Lv_QuerySelectServ := ' null AS idservicio, '||
                            q'['' AS estadoservicio, ]'||
                            q'['' AS tipo_orden, ]'||
                            ' null AS tercerizadora_id, '||
                            ' null AS idserviciotecnico, '||
                            ' null AS ultima_milla_id ';

      IF Lv_TipoSolicitud IS NULL THEN

          SELECT ID_TIPO_SOLICITUD INTO Ln_IdTipoSolicitudConsult 
          FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD WHERE DESCRIPCION_SOLICITUD = Lv_SolicitudInspeccion;

          Lv_QueryWhereInspNoLogin := Lv_QueryWhereInspNoLogin ||' AND ds.tipo_solicitud_id = :paramIdTipoSolicitud  ';
          Lv_QueryWhereInspNoLogin := REPLACE(Lv_QueryWhereInspNoLogin,':paramIdTipoSolicitud',Ln_IdTipoSolicitudConsult);

      END IF;

      Lv_FromInsp := ' DB_COMERCIAL.INFO_DETALLE_SOL_CARACT dsc, '||
                     ' DB_COMERCIAL.ADMI_CARACTERISTICA ac, ';

      Lcl_QuerySolicitudesInsp := Lv_QuerySelect ||
                                  Lv_QuerySelectServ ||
                                  Lv_QueryFromInspNoLogin ||
                                  Lv_QueryWhereInspNoLogin;

      Lv_OrderBy := ' ORDER BY SOL.FECREACION DESC ';
      IF UPPER(TRIM(Lv_PermiteVerInspecciones)) = 'N' THEN
          Lcl_QueryFinal := 'SELECT * FROM ( '|| Lcl_QuerySolicitudes ||  ' ) SOL ' ;
      ELSE      
        IF Lv_TipoSolicitud IS NULL THEN
            Lcl_QueryFinal := 'SELECT * FROM ( ('|| Lcl_QuerySolicitudes || 
                                        '  ) UNION (' || 
                                        Lcl_QuerySolicitudesInsp || ')  ) SOL ' ;
        ELSIF Lv_TipoSolicitud = 'SOLICITUD INSPECCION' THEN
            Lcl_QueryFinal := 'SELECT * FROM ( '|| Lcl_QuerySolicitudesInsp || '  ) SOL ' ;
        ELSE
            Lcl_QueryFinal := 'SELECT * FROM ( '|| Lcl_QuerySolicitudes ||  ' ) SOL ' ;
        END IF;
      END IF;
      Lcl_QueryFinalOrderBy :=  Lcl_QueryFinal || Lv_OrderBy;


          Lv_Json := SUBSTR(Lcl_QueryFinalOrderBy,0,3000);
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_GET_SOLICITUDES',
                                                Lv_Codigo||'|1- '||Lv_Json,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

          Lv_Json := NULL;
          Lv_Json := SUBSTR(Lcl_QueryFinalOrderBy,3001,6000);
          IF Lv_Json IS NOT NULL THEN
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                          'P_GET_SOLICITUDES',
                                            Lv_Codigo||'|2- '||Lv_Json,
                                            'DB_COMERCIAL',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;

          Lv_Json := NULL;
          Lv_Json := SUBSTR(Lcl_QueryFinalOrderBy,6001,8000);
          IF Lv_Json IS NOT NULL THEN
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                          'P_GET_SOLICITUDES',
                                            Lv_Codigo||'|3- '||Lv_Json,
                                            'DB_COMERCIAL',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;


      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ('||Lcl_QueryFinal ||')' INTO Pn_Total;

      IF Lv_Start IS NOT NULL AND Lv_Limit IS NOT NULL THEN

          Lv_Limit :=  Lv_Start + Lv_Limit;

          Lcl_QueryFinalOrderBy := 'SELECT RESULTADO.* '||
                                  'FROM (SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                          'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA '||
                                        'WHERE ROWNUM <= :intFin) RESULTADO '||
                            'WHERE RESULTADO.NUMERO_ROWNUM > :intInicio ';

          Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intFin'   ,Lv_Limit);
          Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intInicio',Lv_Start);
      ELSE
          IF Lv_Limit IS NOT NULL THEN
              Lcl_QueryFinalOrderBy := 'SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                      'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA '||
                                'WHERE ROWNUM <= :intFin ';

              Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intFin',Lv_Limit);
          ELSE

              Lcl_QueryFinalOrderBy := 'SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                      'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA ';
          END IF;
      END IF;

      OPEN Lrf_JsonSolicitudes FOR Lcl_QueryFinalOrderBy;
         FETCH Lrf_JsonSolicitudes BULK COLLECT INTO Lt_Solicitudes LIMIT TRUNC(Lv_LimiteConsulta);
      CLOSE Lrf_JsonSolicitudes;

      Pcl_JsonRespuesta:= '[';
      WHILE Lt_Indice_sol <= Lt_Solicitudes.COUNT LOOP

        IF MOD((Lt_Solicitudes(Lt_Indice_sol).NUMERO_ROW-1),Lv_Start) = 0 THEN
          dbms_lob.append(Pcl_JsonRespuesta,'{');
        ELSE
          dbms_lob.append(Pcl_JsonRespuesta,',{');
        END IF;

        dbms_lob.append(Pcl_JsonRespuesta,
            '"idDetalleSolicitud":"'||Lt_Solicitudes(Lt_Indice_sol).ID_DETALLE_SOLICITUD||'",'||            
            '"idServicio":"'||Lt_Solicitudes(Lt_Indice_sol).ID_SERVICIO||'",'||
            '"idPunto":"'||Lt_Solicitudes(Lt_Indice_sol).ID_PUNTO||'",'||
            '"estadoPunto":"'||Lt_Solicitudes(Lt_Indice_sol).ESTADO_PUNTO||'",'||
            '"tercerizadoraId":"'||Lt_Solicitudes(Lt_Indice_sol).TERCERIZADORA_ID||'",'||
            '"idServicioTecnico":"'||Lt_Solicitudes(Lt_Indice_sol).ID_SERVICIO_TECNICO||'",'||
            '"nombreSector":"'||Lt_Solicitudes(Lt_Indice_sol).NOMBRE_SECTOR||'",'||
            '"nombreParroquia":"'||Lt_Solicitudes(Lt_Indice_sol).NOMBRE_PARROQUIA||'",'||
            '"nombreCanton":"'||Lt_Solicitudes(Lt_Indice_sol).NOMBRE_CANTON||'",'||
            '"id_persona":"'||Lt_Solicitudes(Lt_Indice_sol).ID_PERSONA||'",'||
            '"razonSocial":"'||REPLACE(Lt_Solicitudes(Lt_Indice_sol).RAZON_SOCIAL,'"','')||'",'||
            '"nombres":"'||Lt_Solicitudes(Lt_Indice_sol).NOMBRES||'",'||
            '"apellidos":"'||Lt_Solicitudes(Lt_Indice_sol).APELLIDOS||'",'||
            '"usrVendedor":"'||REPLACE(Lt_Solicitudes(Lt_Indice_sol).USR_VENDEDOR,'"','')||'",'||
            '"login":"'||Lt_Solicitudes(Lt_Indice_sol).LOGIN||'",'||
            '"tipoOrden":"'||Lt_Solicitudes(Lt_Indice_sol).TIPO_ORDEN||'",'||
            '"estadoServicio":"'||Lt_Solicitudes(Lt_Indice_sol).ESTADO_SERVICIO||'",'||
            '"nombreJurisdiccion":"'||REPLACE(Lt_Solicitudes(Lt_Indice_sol).NOMBRE_JURISDICCION,'"','')||'",'||
            '"longitud":"'||Lt_Solicitudes(Lt_Indice_sol).LONGITUD||'",'||
            '"latitud":"'||Lt_Solicitudes(Lt_Indice_sol).LATITUD||'",'||
            '"direccion":"'||REPLACE(Lt_Solicitudes(Lt_Indice_sol).DIRECCION,'"','')||'",'||
            '"rutaCroquis":"'||Lt_Solicitudes(Lt_Indice_sol).RUTA_CROQUIS||'",'||
            '"feCreacion":"'||Lt_Solicitudes(Lt_Indice_sol).FE_CREACION||'",'||
            '"estado":"'||Lt_Solicitudes(Lt_Indice_sol).ESTADO||'",'||
            '"descripcionSolicitud":"'||Lt_Solicitudes(Lt_Indice_sol).DESCRIPCION_SOLICITUD||'",'||
            '"observacion":"'||REPLACE(Lt_Solicitudes(Lt_Indice_sol).OBSERVACION,'"','')||'",'||
            '"nombreVendedor":"'||REPLACE(Lt_Solicitudes(Lt_Indice_sol).NOMBRE_VENDEDOR,'"','')||'",'||
            '"ultimaMillaId":"'||Lt_Solicitudes(Lt_Indice_sol).ULTIMA_MILLA_ID||'",'||
            '"observacion_solicitud":"'||REPLACE(Lt_Solicitudes(Lt_Indice_sol).OBSERVACION_SOLICITUD,'"','')||'",'||
            '"motivoId":"'||Lt_Solicitudes(Lt_Indice_sol).MOTIVO_ID||'"'||
        '}');
        Lt_Indice_sol := Lt_Indice_sol + 1;
      END LOOP;

      dbms_lob.append(Pcl_JsonRespuesta,']');

      --Mensaje de respuesta
      Pv_Status  := 'ok';
      Pv_Message := 'Proceso ejecutado correctamente';

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_GET_SOLICITUDES',
                                                Pv_Message,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    EXCEPTION

      WHEN Le_Exception THEN

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_GET_SOLICITUDES',
                                                Pv_Message,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

      WHEN OTHERS THEN

          Pv_Status  := 'fail';
          Pv_Message := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;
          Lv_Codigo  := Lv_Codigo || Lv_EsConsulta;

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_GET_SOLICITUDES',
                                                Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

          Lv_Json := SUBSTR(Pcl_Json,0,3000);
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_GET_SOLICITUDES',
                                                Lv_Codigo||'|1- '||Lv_Json,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

          Lv_Json := NULL;
          Lv_Json := SUBSTR(Pcl_Json,3001,6000);
          IF Lv_Json IS NOT NULL THEN
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                          'P_GET_SOLICITUDES',
                                            Lv_Codigo||'|2- '||Lv_Json,
                                            'DB_COMERCIAL',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;

          Lv_Json := NULL;
          Lv_Json := SUBSTR(Pcl_Json,6001,8000);
          IF Lv_Json IS NOT NULL THEN
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                          'P_GET_SOLICITUDES',
                                            Lv_Codigo||'|3- '||Lv_Json,
                                            'DB_COMERCIAL',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
          END IF;

  END P_GET_SOLICITUDES;

  PROCEDURE P_GET_HISTORIAL_SOL_INSPECCION(Pcl_Json          IN  CLOB,
                             Pcl_JsonRespuesta OUT CLOB,
                             Pn_Total          OUT NUMBER,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Message        OUT VARCHAR2) IS

      --Variables para el query din�mico
      Lrf_ReporteTareas        SYS_REFCURSOR;
      Lrf_JsonSolicitudes      SYS_REFCURSOR;
      Lv_QuerySelect           CLOB;
      Lv_From                  VARCHAR2(1000) := '';
      Lv_QueryWhere            VARCHAR2(3000) := '';
      Lcl_QueryFinalOrderBy    CLOB;

      TYPE T_Array_historialSolicitud IS TABLE OF Gr_SolicitudInspeccionHist INDEX BY BINARY_INTEGER;
      Lt_AsignadosSolicitud T_Array_historialSolicitud;
      Lt_Indice_sol       NUMBER := 1;

      --Filtros para el Query dinamico
      Lv_IdSolPlanif            VARCHAR2(20);
      Lv_Estado                 VARCHAR2(20);
      Lv_Json                   VARCHAR2(4000);
      Lv_Start                  VARCHAR2(10);
      Lv_Limit                  VARCHAR2(10);

    BEGIN

      apex_json.parse(Pcl_Json);

      --Parseo del Json.
      Lv_Start              := apex_json.get_varchar2('start');
      Lv_Limit              := apex_json.get_varchar2('limit');
      Lv_IdSolPlanif        := apex_json.get_varchar2('idSolPlanif');
      Lv_Estado             := apex_json.get_varchar2('estado');

      IF Lv_IdSolPlanif IS NOT NULL THEN

          --Creaci�n del Query.
          Lv_QuerySelect        := ' SELECT ' ||
                                  ' asigsH.ID_DETALLE_SOL_PLANIF_HIST AS idDetalleSolPlanifHist, '||
                                  ' TO_CHAR(asigsH.FE_CREACION,''DD-MM-RRRR HH24:MI'') AS feCreacion, '||
                                  ' CMKG_SOLICITUD_CONSULTA.F_GET_NOMBRE_ASIGNADO ( asigs.TIPO_ASIGNADO, asigsH.ASIGNADO_ID ) AS nombreAsignado, '||
                                  ' asigsH.OBSERVACION AS observacion, '||
                                  ' asigsH.USR_CREACION AS usrCreacion, '||
                                  ' asigsH.ESTADO AS estado ';

          Lv_From               := ' FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF asigs, DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF_HIST asigsH  ';

          Lv_QueryWhere         := ' WHERE ' ||
                                  ' asigsH.DETALLE_SOL_PLANIF_ID = asigs.ID_DETALLE_SOL_PLANIF ' ||
                                  ' AND asigs.ID_DETALLE_SOL_PLANIF = :paramIdDetSolPlanif ';
          Lv_QueryWhere         := REPLACE(Lv_QueryWhere,':paramIdDetSolPlanif',Lv_IdSolPlanif);

          Lcl_QueryFinalOrderBy := Lv_QuerySelect ||
                                  Lv_From ||
                                  Lv_QueryWhere || ' ORDER BY asigsH.FE_CREACION DESC ';

          EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ('||Lcl_QueryFinalOrderBy ||')' INTO Pn_Total;
          --Se agrega rango para pagineo
          IF Lv_Start IS NOT NULL AND Lv_Limit IS NOT NULL THEN
              Lv_Limit :=  Lv_Start + Lv_Limit;
              Lcl_QueryFinalOrderBy := 'SELECT RESULTADO.* '||
                                      'FROM (SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                              'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA '||
                                            'WHERE ROWNUM <= :intFin) RESULTADO '||
                                'WHERE RESULTADO.NUMERO_ROWNUM > :intInicio ';
              Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intFin'   ,Lv_Limit);
              Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intInicio',Lv_Start);
          ELSE
              IF Lv_Limit IS NOT NULL THEN
                  Lcl_QueryFinalOrderBy := 'SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                           'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA '||
                                           'WHERE ROWNUM <= :intFin ';
                  Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intFin',Lv_Limit);
              END IF;
          END IF;

          --Ejecuta el query
          OPEN Lrf_JsonSolicitudes FOR Lcl_QueryFinalOrderBy;
            FETCH Lrf_JsonSolicitudes BULK COLLECT INTO Lt_AsignadosSolicitud LIMIT 1000;
          CLOSE Lrf_JsonSolicitudes;

          Pcl_JsonRespuesta:= '[';

          --Recorre resultado del query ejecutado
          WHILE Lt_Indice_sol <= Lt_AsignadosSolicitud.COUNT LOOP

            IF MOD((Lt_AsignadosSolicitud(Lt_Indice_sol).NUMERO_ROW-1),Lv_Start) = 0 THEN
              dbms_lob.append(Pcl_JsonRespuesta,'{');
            ELSE
              dbms_lob.append(Pcl_JsonRespuesta,',{');
            END IF;

            dbms_lob.append(Pcl_JsonRespuesta,
                '"idSolPlanifHist":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).ID_DETALLE_SOL_PLANIF_HIST||'",'||      
                '"feCreacion":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).FE_CREACION||'",'||
                '"usrCreacion":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).USR_CREACION||'",'||
                '"nombreAsignado":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).NOMBRE_ASIGNADO||'",'||
                '"observacion":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).OBSERVACION||'",'||
                '"estado":"'||REPLACE(Lt_AsignadosSolicitud(Lt_Indice_sol).ESTADO,'"','')||'"'||
            '}');
            Lt_Indice_sol := Lt_Indice_sol + 1;
          END LOOP;

          dbms_lob.append(Pcl_JsonRespuesta,']');
          Pv_Status  := 'ok';
          Pv_Message := 'Consulta ejecutada correctamente';
      ELSE
          Pv_Status  := 'fail';
          Pv_Message := 'Error: No se encontro id de solicitud para realizar la consulta.';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                               'P_GET_HISTORIAL_SOL_INSPECCION',
                                               Pv_Message,
                                               'DB_COMERCIAL',
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
          Pv_Status  := 'fail';
          Pv_Message := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_GET_HISTORIAL_SOL_INSPECCION',
                                                'Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_GET_HISTORIAL_SOL_INSPECCION;


  PROCEDURE P_GET_ASIGNADOS_SOL_INSPECCION(Pcl_Json          IN  CLOB,
                             Pcl_JsonRespuesta OUT CLOB,
                             Pn_Total          OUT NUMBER,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Message        OUT VARCHAR2) IS

      --Variables para el query din�mico
      Lrf_ReporteTareas        SYS_REFCURSOR;
      Lrf_JsonSolicitudes      SYS_REFCURSOR;
      Lv_QuerySelect           CLOB;
      Lv_From                  VARCHAR2(1000) := '';
      Lv_QueryWhere            VARCHAR2(3000) := '';
      Lcl_QueryFinalOrderBy    CLOB;

      TYPE T_Array_asignadosSolicitud IS TABLE OF Gr_AsignadosSolicitud INDEX BY BINARY_INTEGER;
      Lt_AsignadosSolicitud T_Array_asignadosSolicitud;
      Lt_Indice_sol       NUMBER := 1;

      --Filtros para el Query dinamico
      Lv_IdSolicitud            VARCHAR2(20);
      Lv_Estado                 VARCHAR2(20);
      Lv_Json                   VARCHAR2(4000);
      Lv_Start                  VARCHAR2(10);
      Lv_Limit                  VARCHAR2(10);

    BEGIN

      apex_json.parse(Pcl_Json);

      --Parseo del Json.
      Lv_Start              := apex_json.get_varchar2('start');
      Lv_Limit              := apex_json.get_varchar2('limit');
      Lv_IdSolicitud        := apex_json.get_varchar2('idSolicitud');
      Lv_Estado             := apex_json.get_varchar2('estado');

      IF Lv_IdSolicitud IS NOT NULL THEN

          Lv_QuerySelect        := ' SELECT ' ||
                                  ' asigs.DETALLE_SOLICITUD_ID AS idDetalleSolicitud, '||
                                  ' asigs.ID_DETALLE_SOL_PLANIF AS idDetalleSolPlanif, '||
                                  ' asigs.ASIGNADO_ID AS idasignado, '||
                                  ' TO_CHAR(asigs.FE_INI_PLAN,''DD-MM-RRRR HH24:MI'') AS feInicio,'||
                                  ' TO_CHAR(asigs.FE_FIN_PLAN,''DD-MM-RRRR HH24:MI'') AS feFin,'||
                                  ' DBMS_LOB.substr(idet.OBSERVACION, 3000) AS observacion,'||                                  
                                  ' CMKG_SOLICITUD_CONSULTA.F_GET_NOMBRE_ASIGNADO ( asigs.TIPO_ASIGNADO, asigs.ASIGNADO_ID ) AS nombreAsignado, '||
                                  ' asigs.TIPO_ASIGNADO AS tipoAsignado, '||
                                  ' asigs.ESTADO AS estado, ' ||
                                  ' DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(asigs.TAREA_ID) AS estadoTarea, ' ||
                                  ' asigs.TAREA_ID AS numeroTarea, ' ||
                                  q'[ 'bd' AS origen ]';

          Lv_From               := ' FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF asigs, '||
                                   ' DB_SOPORTE.INFO_DETALLE idet, '|| 
                                   ' DB_COMUNICACION.INFO_COMUNICACION ic ';
          Lv_QueryWhere         := ' WHERE ' ||
                                  ' asigs.DETALLE_SOLICITUD_ID = :paramIdSolicitud '||
                                  ' AND ic.DETALLE_ID = idet.ID_DETALLE '||
                                  ' AND asigs.TAREA_ID = ic.ID_COMUNICACION ';
          Lv_QueryWhere         := REPLACE(Lv_QueryWhere,':paramIdSolicitud',Lv_IdSolicitud);

          IF Lv_Estado IS NOT NULL THEN
              Lv_QueryWhere         := ' AND asigs.ESTADO = :paramEstado ';
              Lv_QueryWhere         := REPLACE(Lv_QueryWhere,':paramEstado',Lv_Estado);
          END IF;

          Lcl_QueryFinalOrderBy := Lv_QuerySelect ||
                                  Lv_From ||
                                  Lv_QueryWhere || ' ORDER BY asigs.FE_CREACION DESC ';

          EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ('||Lcl_QueryFinalOrderBy ||')' INTO Pn_Total;
          --Se agrega rango para pagineo
          IF Lv_Start IS NOT NULL AND Lv_Limit IS NOT NULL THEN
              Lv_Limit :=  Lv_Start + Lv_Limit;
              Lcl_QueryFinalOrderBy := 'SELECT RESULTADO.* '||
                                      'FROM (SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                              'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA '||
                                            'WHERE ROWNUM <= :intFin) RESULTADO '||
                                'WHERE RESULTADO.NUMERO_ROWNUM > :intInicio ';
              Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intFin'   ,Lv_Limit);
              Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intInicio',Lv_Start);
          ELSE
              IF Lv_Limit IS NOT NULL THEN
                  Lcl_QueryFinalOrderBy := 'SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                          'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA '||
                                    'WHERE ROWNUM <= :intFin ';
                  Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intFin',Lv_Limit);
              END IF;
          END IF;

          --Ejecuta el query
          OPEN Lrf_JsonSolicitudes FOR Lcl_QueryFinalOrderBy;
            FETCH Lrf_JsonSolicitudes BULK COLLECT INTO Lt_AsignadosSolicitud LIMIT 1000;
          CLOSE Lrf_JsonSolicitudes;

          Pcl_JsonRespuesta:= '[';

          --Recorre resultado del query ejecutado
          WHILE Lt_Indice_sol <= Lt_AsignadosSolicitud.COUNT LOOP

            IF MOD((Lt_AsignadosSolicitud(Lt_Indice_sol).NUMERO_ROW-1),Lv_Start) = 0 THEN
              dbms_lob.append(Pcl_JsonRespuesta,'{');
            ELSE
              dbms_lob.append(Pcl_JsonRespuesta,',{');
            END IF;

            dbms_lob.append(Pcl_JsonRespuesta,
                '"idSol":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).DETALLE_SOLICITUD_ID||'",'||
                '"idSolPlanif":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).ID_DETALLE_SOL_PLANIF||'",'||
                '"idAsignado":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).ASIGNADO_ID||'",'||            
                '"feInicio":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).FE_INI_PLAN||'",'||
                '"feFin":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).FE_FIN_PLAN||'",'||
                '"observacion":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).OBSERVACION||'",'||
                '"nombreAsignado":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).NOMBRE_ASIGNADO||'",'||
                '"tipoAsignado":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).TIPO_ASIGNADO||'",'||
                '"estado":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).ESTADO||'",'||
                '"estadoTarea":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).ESTADO_TAREA||'",'||
                '"numeroTarea":"'||Lt_AsignadosSolicitud(Lt_Indice_sol).NUMERO_TAREA||'",'||
                '"origen":"'||REPLACE(Lt_AsignadosSolicitud(Lt_Indice_sol).ORIGEN,'"','')||'"'||
            '}');
            Lt_Indice_sol := Lt_Indice_sol + 1;
          END LOOP;

          dbms_lob.append(Pcl_JsonRespuesta,']');

          --Mensaje de respuesta
          Pv_Status  := 'ok';
          Pv_Message := 'Consulta ejecutada correctamente';
      ELSE
          Pv_Status  := 'fail';
          Pv_Message := 'Error: No se encontro id de solicitud para realizar la consulta.';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                               'P_GET_ASIGNADOS_SOL_INSPECCION',
                                               Pv_Message,
                                               'DB_COMERCIAL',
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      END IF;
    EXCEPTION

      WHEN OTHERS THEN

          Pv_Status  := 'fail';
          Pv_Message := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_GET_ASIGNADOS_SOL_INSPECCION',
                                                'Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_GET_ASIGNADOS_SOL_INSPECCION;


FUNCTION F_GET_NOMBRE_ASIGNADO(
    Pv_tipoAsignado DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF.TIPO_ASIGNADO%TYPE,
    Pv_idAsignado NUMBER
    )
    RETURN VARCHAR2
  IS

    Le_Exception        EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_Resultado        VARCHAR2(4000);
    Lv_Query            VARCHAR2(1000);

  BEGIN
    --
    Lv_Resultado := '';
    --
    IF Pv_idAsignado IS NOT NULL THEN
      IF UPPER(Pv_tipoAsignado) = 'CUADRILLA' THEN
          SELECT NOMBRE_CUADRILLA INTO Lv_Resultado 
          FROM DB_SOPORTE.ADMI_CUADRILLA WHERE ID_CUADRILLA = Pv_idAsignado ;
      ELSIF UPPER(Pv_tipoAsignado) = 'EMPLEADO' THEN
          SELECT NOMBRES || ' ' || APELLIDOS INTO Lv_Resultado 
          FROM DB_COMERCIAL.INFO_PERSONA WHERE ID_PERSONA = Pv_idAsignado ;
      END IF;
    END IF;    
    --
  RETURN Lv_Resultado;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'CMKG_SOLICITUD_CONSULTA',
                                            'F_GET_NOMBRE_ASIGNADO',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_NOMBRE_ASIGNADO;


FUNCTION F_GET_ID_PUNTO_SOL_INSP(Pv_idSolicitud NUMBER)
    RETURN VARCHAR2
  IS
    --
    Le_Exception        EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_Resultado        VARCHAR2(4000);
    Lv_Query            VARCHAR2(1000);
    Lv_tipoSolicitud    VARCHAR2(500);
    Lv_login            VARCHAR2(200);
    --
  BEGIN
    Lv_Resultado := '';
    Lv_tipoSolicitud := '';
    
    SELECT ts.DESCRIPCION_SOLICITUD into Lv_tipoSolicitud FROM db_comercial.info_detalle_solicitud ds
    JOIN db_comercial.admi_tipo_solicitud ts 
    ON ts.id_tipo_solicitud = ds.tipo_solicitud_id
    where ds.ID_DETALLE_SOLICITUD = Pv_idSolicitud;
                
    
    IF Pv_idSolicitud IS NOT NULL THEN

        IF (Lv_tipoSolicitud <> 'SOLICITUD INSPECCION') THEN

          SELECT dsc.valor INTO Lv_login 
          FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT dsc
          JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac ON ac.id_caracteristica = dsc.caracteristica_id
          WHERE 
          dsc.detalle_solicitud_id = Pv_idSolicitud
          AND ac.descripcion_caracteristica = 'LOGIN_INSPECCION'
          AND dsc.valor IS NOT NULL;
        ELSE

          SELECT dsc.valor INTO Lv_login 
          FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT_DET dsc
          JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac ON ac.id_caracteristica = dsc.caracteristica_id
          WHERE 
          dsc.detalle_solicitud_id = Pv_idSolicitud
          AND ac.descripcion_caracteristica = 'LOGIN_INSPECCION'
          AND dsc.valor IS NOT NULL;
          
        END IF;


        IF Lv_login IS NOT NULL THEN
            SELECT MAX(id_punto) INTO Lv_Resultado
            FROM DB_COMERCIAL.INFO_PUNTO pto
            WHERE pto.LOGIN = Lv_login;
        END IF; 
    END IF;    

  RETURN Lv_Resultado;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'CMKG_SOLICITUD_CONSULTA',
                                            'F_GET_ID_PUNTO_SOL_INSP',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_ID_PUNTO_SOL_INSP;



FUNCTION F_GET_PARAMETROS_SOLICITUDES(
    Pv_descripcion VARCHAR2,
    Pv_nombreParam VARCHAR2
    )
    RETURN VARCHAR2
  IS
    type Ln_array IS VARRAY(20) OF INTEGER;
    type Lv_array IS VARRAY(50) OF VARCHAR2(100);
    Le_Exception        EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_Resultado        VARCHAR2(4000);
    Lv_Query            VARCHAR2(1000);
    Lv_OtrosTiposSolicitudesIds VARCHAR2(100);
    La_arrayOtrosTipoSolicitudes Ln_array;
    La_arrayParametroStr Lv_array;
    Lp_i PLS_INTEGER;
  BEGIN
    Lv_Resultado := '';
    IF Pv_descripcion IS NOT NULL THEN
      select VALOR2 BULK COLLECT into La_arrayParametroStr 
      from DB_GENERAL.ADMI_PARAMETRO_CAB cab 
      JOIN  DB_GENERAL.ADMI_PARAMETRO_DET det ON det.PARAMETRO_ID = cab.ID_PARAMETRO 
      where cab.NOMBRE_PARAMETRO = Pv_nombreParam AND det.DESCRIPCION = Pv_descripcion 
      AND det.ESTADO= 'Activo';

      Lp_i := La_arrayParametroStr.FIRST;
      WHILE (Lp_i IS NOT NULL)
      LOOP
        Lv_OtrosTiposSolicitudesIds := Lv_OtrosTiposSolicitudesIds || La_arrayParametroStr(Lp_i)  || ', ';
        Lp_i := La_arrayParametroStr.NEXT(Lp_i);
      END LOOP;

      Lv_Resultado := RTRIM(Lv_OtrosTiposSolicitudesIds,', ');
    END IF;    

  RETURN Lv_Resultado;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '';
    WHEN OTHERS THEN
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'CMKG_SOLICITUD_CONSULTA',
                                            'F_GET_PARAMETROS_SOLICITUDES',
                                            Lv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                            '127.0.0.1')
                                          );
      RETURN '';
  --
  END F_GET_PARAMETROS_SOLICITUDES;


  PROCEDURE P_CONSULTAR_SOLICITUD(Pcl_Request          IN  CLOB,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Mensaje        OUT VARCHAR2,
                             Pcl_Response OUT CLOB) IS

      Lrf_ReporteTareas        SYS_REFCURSOR;
      Lrf_JsonSolicitudes      SYS_REFCURSOR;
      Lrf_JsonEstados          SYS_REFCURSOR;
      Lrf_JsonCaracSolicitudes SYS_REFCURSOR;
      Lrf_JsonPlanifSolicitudes SYS_REFCURSOR;

      Lv_JsonCaracSolicitudes  CLOB;
      Lv_JsonPlanifSolicitudes CLOB;
      Lv_JsonEstados           CLOB;
      Lv_QuerySelect           CLOB;
      Lv_From                  VARCHAR2(1000) := '';
      Lv_QueryWhere            VARCHAR2(3000) := '';
      Lcl_QueryEstados         CLOB;
      Lcl_QueryFinalOrderBy    CLOB;
      Lcl_QueryCaracteristicas CLOB;
      Lcl_QueryPlanificaciones CLOB;

      TYPE T_Array_infoDetalleSolicitud IS TABLE OF Gr_InfoDetalleSolicitud INDEX BY BINARY_INTEGER;
      Lt_InfoDetalleSolicitud T_Array_infoDetalleSolicitud;

      TYPE T_Array_caracSolicitud IS TABLE OF Gr_CaracteristicasSolicitud INDEX BY BINARY_INTEGER;
      Lt_CaracteristicasSolicitud T_Array_caracSolicitud;

      TYPE T_Array_planifSolicitud IS TABLE OF Gr_PlanificacionesSolicitud INDEX BY BINARY_INTEGER;
      Lt_PlanificacionesSolicitud T_Array_planifSolicitud;

      TYPE T_Array_Estados IS TABLE OF Gr_Items INDEX BY BINARY_INTEGER;
      Lt_Estados T_Array_Estados;

      Lt_Indice_sol        NUMBER := 1;
      Lt_Indice_sol_carac  NUMBER := 1;
      Lt_Indice_sol_planif NUMBER := 1;

      Ln_cantTareasPlanif NUMBER;

      Lv_FechaDesdeDate TIMESTAMP;
      Lv_FechaHastaDate TIMESTAMP;

      Lv_IdDetalleSolicitud     VARCHAR2(20);
      Lv_ServicioId             VARCHAR2(20);
      Lv_TipoSolicitudId        VARCHAR2(20);
      Lv_MotivoId               VARCHAR2(20);
      Lv_Estado                 VARCHAR2(200);
      Lv_TareasPlanificadas     CLOB;
      Lv_FechaDesde             VARCHAR2(24);
      Lv_FechaHasta             VARCHAR2(24);
      Lv_RequiereCaract         VARCHAR2(20);
      Lv_EsInspeccion           VARCHAR2(20);
      Lv_RequiereDetallePlanif  VARCHAR2(20);
      Lv_IntervaloFechaConsulta VARCHAR2(20);

      Le_Errors                 EXCEPTION;

      Lv_valor                  VARCHAR2(4000);
      Lv_Json                   VARCHAR2(4000);
      Lv_Start                  VARCHAR2(10);
      Lv_Limit                  VARCHAR2(10);

    BEGIN

      apex_json.parse(Pcl_Request);

      --Parseo del Json.
      Lv_Start                  := apex_json.get_varchar2('offset');
      Lv_Limit                  := apex_json.get_varchar2('limit');
      Lv_IdDetalleSolicitud     := apex_json.get_varchar2('idDetalleSolicitud');
      Lv_ServicioId             := apex_json.get_varchar2('servicioId');
      Lv_TipoSolicitudId        := apex_json.get_varchar2('tipoSolicitudId');
      Lv_MotivoId               := apex_json.get_varchar2('motivoId');
      Lv_Estado                 := apex_json.get_varchar2('estados');
      Lv_FechaDesde             := apex_json.get_varchar2('fechaDesde');
      Lv_FechaHasta             := apex_json.get_varchar2('fechaHasta');
      Lv_RequiereCaract         := apex_json.get_varchar2('requiereCaracteristicas');
      Lv_EsInspeccion           := apex_json.get_varchar2('esInspeccion');
      Lv_RequiereDetallePlanif  := apex_json.get_varchar2('requiereDetallePlanificacion');
      Lv_IntervaloFechaConsulta := apex_json.get_number('intervaloFechaConsulta');
      Ln_cantTareasPlanif       := apex_json.get_count(p_path => 'tareasPlanificadas');

      IF Lv_Start IS NULL THEN
        Lv_Start := '1';
      END IF; 
      IF Lv_Limit IS NULL THEN
        Lv_Limit := '10';
      END IF;

      IF Lv_IdDetalleSolicitud IS NULL AND Lv_ServicioId IS NULL AND Lv_TipoSolicitudId IS NULL AND (Ln_cantTareasPlanif IS NULL OR Ln_cantTareasPlanif <=0 ) THEN
          Pv_Mensaje := 'ERROR: Debe enviar al menos uno de los siguientes par�metros idDetalleSolicitud, servicioId, tareasPlanificadas y tipoSolicitudId';
          RAISE Le_Errors;
      END IF;

      IF Lv_IntervaloFechaConsulta IS NULL THEN
          Lv_IntervaloFechaConsulta := 1;
      END IF;

      IF Lv_FechaDesde IS NULL THEN
          Lv_FechaDesdeDate := SYSTIMESTAMP - TO_NUMBER(Lv_IntervaloFechaConsulta, '9999');
      ELSE
          Lv_FechaDesdeDate := TO_TIMESTAMP(UPPER(Lv_FechaDesde),'RRRR-MM-DD HH24:MI:SS');
      END IF;

      IF Lv_FechaHasta IS NULL THEN
          Lv_FechaHastaDate := SYSTIMESTAMP;
      END IF;

      IF Lv_RequiereCaract IS NULL THEN
          Lv_RequiereCaract := 'false';
      END IF;
      
      IF Lv_EsInspeccion IS NULL THEN
         Lv_EsInspeccion := 'false';
      END IF;

      IF Lv_RequiereDetallePlanif IS NULL THEN
          Lv_RequiereDetallePlanif := 'false';
      END IF;

      IF Lv_Estado IS NULL THEN
          Pv_Mensaje := 'ERROR: Debe enviar al menos un estado';
          RAISE Le_Errors;
      END IF;

      IF INSTR(Lv_Estado,',') <= 0 THEN
          Pv_Mensaje := 'ERROR: Debe enviar los estados separados por coma';
          RAISE Le_Errors;
      END IF;

    --OBTIENE LOS ESTADOS ENVIADOS
      Lcl_QueryEstados := q'[SELECT REGEXP_SUBSTR(']'||Lv_Estado||q'[', '[^,]+', 1, level) AS parts ]'||
                          ' FROM dual '||
                          q'[ CONNECT BY REGEXP_SUBSTR(']'||Lv_Estado||q'[', '[^,]+', 1, level) IS NOT NULL ]';

      OPEN Lrf_JsonEstados FOR Lcl_QueryEstados;
        FETCH Lrf_JsonEstados BULK COLLECT INTO Lt_Estados LIMIT 10;
      CLOSE Lrf_JsonEstados;

      Lv_Estado := '';
      WHILE Lt_Indice_sol <= Lt_Estados.COUNT LOOP
        IF Lv_Estado IS NOT NULL THEN
            Lv_Estado :=  Lv_Estado || q'[,']' || Lt_Estados(Lt_Indice_sol).ITEM||q'[']';
        ELSE
            Lv_Estado := q'[']' || Lt_Estados(Lt_Indice_sol).ITEM||q'[']';
        END IF;
        Lt_Indice_sol := Lt_Indice_sol + 1;
      END LOOP;

      --OBTIENE LAS TAREAS PLANIFICADAS
      Lv_TareasPlanificadas := '';
      IF Ln_cantTareasPlanif > 0 THEN

        FOR j IN 1 .. Ln_cantTareasPlanif LOOP
            IF j = 1 THEN
                Lv_TareasPlanificadas := apex_json.get_varchar2(p_path => 'tareasPlanificadas[%d]',p0 => j);
            ELSE
                Lv_TareasPlanificadas := Lv_TareasPlanificadas|| ',' || apex_json.get_varchar2(p_path => 'tareasPlanificadas[%d]',p0 => j);
            END IF;
        END LOOP;
      END IF;

      Lt_Indice_sol := 1;

          --Creaci�n del Query.
          Lv_QuerySelect        := ' SELECT ' ||
                                   ' SOL.ID_DETALLE_SOLICITUD, '||
                                   ' SOL.SERVICIO_ID, '||
                                   ' SOL.TIPO_SOLICITUD_ID, '||
                                   ' TSOL.DESCRIPCION_SOLICITUD, '||
                                   ' SOL.MOTIVO_ID, '||
                                   ' MOT.NOMBRE_MOTIVO, '||
                                   ' SOL.USR_CREACION, '||
                                   'TO_CHAR(SOL.FE_CREACION,''RRRR-MM-DD HH24:MI:SS'') FE_CREACION,'||
                                   ' SOL.PRECIO_DESCUENTO, '||
                                   ' SOL.PORCENTAJE_DESCUENTO, '||
                                   ' SOL.TIPO_DOCUMENTO, '||
                                   ' SOL.OBSERVACION, '||
                                   ' SOL.ESTADO, '||
                                   ' SOL.USR_RECHAZO, '||
                                   'TO_CHAR(SOL.FE_RECHAZO,''RRRR-MM-DD HH24:MI:SS'') FE_RECHAZO,'||
                                   ' SOL.DETALLE_PROCESO_ID, '||
                                   'TO_CHAR(SOL.FE_EJECUCION,''RRRR-MM-DD HH24:MI:SS'') FE_EJECUCION,'||
                                   ' SOL.ELEMENTO_ID '
                                   ;
          Lv_From               := ' FROM '||
                                   ' DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL '||
                                   ' LEFT JOIN DB_GENERAL.ADMI_MOTIVO MOT ON MOT.ID_MOTIVO=SOL.MOTIVO_ID '||
                                   ' LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TSOL ON TSOL.ID_TIPO_SOLICITUD=SOL.TIPO_SOLICITUD_ID ';
          Lv_QueryWhere         := ' WHERE '||
                                   ' 1=1 ';

          IF Lv_IdDetalleSolicitud IS NOT NULL THEN 
              Lv_QueryWhere         :=  Lv_QueryWhere || ' AND SOL.ID_DETALLE_SOLICITUD = :paramIdDetalleSolicitud ';
              Lv_QueryWhere         := REPLACE(Lv_QueryWhere,':paramIdDetalleSolicitud',Lv_IdDetalleSolicitud);
          END IF;
          IF Lv_ServicioId IS NOT NULL THEN 
              Lv_QueryWhere         := Lv_QueryWhere || ' AND SOL.SERVICIO_ID = :paramServicioId ';
              Lv_QueryWhere         := REPLACE(Lv_QueryWhere,':paramServicioId',Lv_ServicioId);
          END IF;
          IF Lv_TipoSolicitudId IS NOT NULL THEN 
              Lv_QueryWhere         := Lv_QueryWhere || ' AND SOL.TIPO_SOLICITUD_ID = :paramTipoSolicitudId ';
              Lv_QueryWhere         := REPLACE(Lv_QueryWhere,':paramTipoSolicitudId',Lv_TipoSolicitudId);
          END IF;
          IF Lv_MotivoId IS NOT NULL THEN 
              Lv_QueryWhere         := Lv_QueryWhere ||  ' AND SOL.MOTIVO_ID = :paramMotivoId ';
              Lv_QueryWhere         := REPLACE(Lv_QueryWhere,':paramMotivoId',Lv_MotivoId);
          END IF;
          IF Lv_Estado IS NOT NULL THEN 
              Lv_QueryWhere         := Lv_QueryWhere || ' AND SOL.ESTADO IN (:paramEstados) ';
              Lv_QueryWhere         := REPLACE(Lv_QueryWhere,':paramEstados',Lv_Estado);
          END IF;
          IF Lv_FechaDesdeDate IS NOT NULL THEN
              Lv_FechaDesde := TO_CHAR(Lv_FechaDesdeDate,'RRRR-MM-DD HH24:MI:SS');
              Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(SOL.FE_CREACION,''RRRR-MM-DD HH24:MI:SS'') >= :feDesde';
              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feDesde',''''||Lv_FechaDesde||'''');
          END IF;
          IF Lv_FechaHastaDate IS NOT NULL THEN
              Lv_FechaHasta := TO_CHAR(Lv_FechaHastaDate,'RRRR-MM-DD HH24:MI:SS');
              Lv_QueryWhere := Lv_QueryWhere ||' AND TO_CHAR(SOL.FE_CREACION,''RRRR-MM-DD HH24:MI:SS'') <= :feHasta';
              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':feHasta',''''||Lv_FechaHasta||'''');
          END IF;
          IF Lv_TareasPlanificadas IS NOT NULL THEN 
              Lv_QueryWhere := Lv_QueryWhere || ' AND SOL.ID_DETALLE_SOLICITUD IN ('||
                                                ' SELECT  SOLP.DETALLE_SOLICITUD_ID FROM '||
                                                ' DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF SOLP ' ||
                                                ' WHERE SOLP.TAREA_ID IN ( :paramTareasPlanif ) ) ';
              Lv_QueryWhere := REPLACE(Lv_QueryWhere,':paramTareasPlanif',Lv_TareasPlanificadas);
          END IF;

          Lcl_QueryFinalOrderBy := Lv_QuerySelect ||
                                  Lv_From ||
                                  Lv_QueryWhere || ' ORDER BY SOL.FE_CREACION DESC ';

          --Se agrega rango para pagineo
          IF Lv_Start IS NOT NULL AND Lv_Limit IS NOT NULL THEN

              Lv_Limit :=  Lv_Start + Lv_Limit;

              Lcl_QueryFinalOrderBy := 'SELECT RESULTADO.* '||
                                      'FROM (SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                              'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA '||
                                            'WHERE ROWNUM <= :intFin) RESULTADO '||
                                'WHERE RESULTADO.NUMERO_ROWNUM > :intInicio ';

              Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intFin'   ,Lv_Limit);
              Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intInicio',Lv_Start);

          ELSE

              IF Lv_Limit IS NOT NULL THEN

                  Lcl_QueryFinalOrderBy := 'SELECT CONSULTA.*, ROWNUM AS NUMERO_ROWNUM '||
                                          'FROM ('||Lcl_QueryFinalOrderBy||') CONSULTA '||
                                    'WHERE ROWNUM <= :intFin ';

                  Lcl_QueryFinalOrderBy := REPLACE(Lcl_QueryFinalOrderBy,':intFin',Lv_Limit);

              END IF;

          END IF;
          


          --Ejecuta el query
          OPEN Lrf_JsonSolicitudes FOR Lcl_QueryFinalOrderBy;
            FETCH Lrf_JsonSolicitudes BULK COLLECT INTO Lt_InfoDetalleSolicitud LIMIT 1000;
          CLOSE Lrf_JsonSolicitudes;

          Pcl_Response:= '[';

          --Recorre resultado del query ejecutado
          WHILE Lt_Indice_sol <= Lt_InfoDetalleSolicitud.COUNT LOOP

            IF MOD((Lt_InfoDetalleSolicitud(Lt_Indice_sol).NUMERO_ROW-1),Lv_Start) = 0 THEN
              dbms_lob.append(Pcl_Response,'{');
            ELSE
              dbms_lob.append(Pcl_Response,',{');
            END IF;

            --CONSULTA CARACTERISTICAS DE LA SOLICITUD
            Lv_JsonCaracSolicitudes := '[';
            Lt_Indice_sol_carac     := 1;

            IF Lv_RequiereCaract = 'true' THEN
                Lcl_QueryCaracteristicas := 'SELECT DSC.ID_SOLICITUD_CARACTERISTICA, '||
                                            '  DSC.CARACTERISTICA_ID, '||
                                            '  CARAC.DESCRIPCION_CARACTERISTICA, '||
                                            '  DSC.VALOR, '||
                                            '  DSC.ESTADO, '||
                                            '  DSC.USR_CREACION, '||
                                            'TO_CHAR(DSC.FE_CREACION,''RRRR-MM-DD HH24:MI:SS'') FE_CREACION ';
                IF Lv_EsInspeccion = 'true' THEN
                    Lcl_QueryCaracteristicas := Lcl_QueryCaracteristicas || ' FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT_DET DSC '||
                                            '      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ON CARAC.ID_CARACTERISTICA = DSC.CARACTERISTICA_ID '||
                                            ' WHERE '||
                                            ' DSC.ESTADO = :paramEstadoCaractSolicitud' ||
                                           ' AND DSC.DETALLE_SOLICITUD_ID = :paramIdDetalleSolicitud ';
                ELSE
                    Lcl_QueryCaracteristicas := Lcl_QueryCaracteristicas ||' FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC '||
                                            '      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ON CARAC.ID_CARACTERISTICA = DSC.CARACTERISTICA_ID '||
                                            ' WHERE '||
                                            ' DSC.ESTADO = :paramEstadoCaractSolicitud' ||
                                            ' AND DSC.DETALLE_SOLICITUD_ID = :paramIdDetalleSolicitud ';
                END IF;
                                            
                Lcl_QueryCaracteristicas := REPLACE(Lcl_QueryCaracteristicas,':paramIdDetalleSolicitud',
                                                    Lt_InfoDetalleSolicitud(Lt_Indice_sol).ID_DETALLE_SOLICITUD);
                Lcl_QueryCaracteristicas := REPLACE(Lcl_QueryCaracteristicas,':paramEstadoCaractSolicitud',''''||'Activo'||'''');
                
                

  
              
                OPEN Lrf_JsonCaracSolicitudes FOR Lcl_QueryCaracteristicas;
                  FETCH Lrf_JsonCaracSolicitudes BULK COLLECT INTO Lt_CaracteristicasSolicitud LIMIT 1000;
                CLOSE Lrf_JsonCaracSolicitudes;

                --Recorre resultado del query ejecutado
                WHILE Lt_Indice_sol_carac <= Lt_CaracteristicasSolicitud.COUNT LOOP

                    IF Lt_Indice_sol_carac = 1 THEN
                      dbms_lob.append(Lv_JsonCaracSolicitudes,'{');
                    ELSE
                      dbms_lob.append(Lv_JsonCaracSolicitudes,',{');
                    END IF;

                    --VERIFICA SI LA CARACTERISTICA ES DE PRODUCTO_INSPECCION ENTONCES CAMBIA EN EL VALOR LAS COMILLAS DOBLES POR COMILLAS SIMPLES
                    Lv_valor := Lt_CaracteristicasSolicitud(Lt_Indice_sol_carac).VALOR;
                    IF Lt_CaracteristicasSolicitud(Lt_Indice_sol_carac).DESCRIPCION_CARACTERISTICA = 'PRODUCTO_INSPECCION' THEN
                        Lv_valor := REPLACE(Lv_valor,'"','''');
                    END IF;

                    dbms_lob.append(Lv_JsonCaracSolicitudes,
                        '"idSolicitudCaracteristica":"'||Lt_CaracteristicasSolicitud(Lt_Indice_sol_carac).ID_SOLICITUD_CARACTERISTICA||'",'||
                        '"caracteristicaId":"'||Lt_CaracteristicasSolicitud(Lt_Indice_sol_carac).CARACTERISTICA_ID||'",'||
                        '"caracteristicaDesc":"'||Lt_CaracteristicasSolicitud(Lt_Indice_sol_carac).DESCRIPCION_CARACTERISTICA||'",'||
                        '"valor":"'||Lv_valor||'",'||
                        '"estado":"'||Lt_CaracteristicasSolicitud(Lt_Indice_sol_carac).ESTADO||'",'||
                        '"usrCreacion":"'||Lt_CaracteristicasSolicitud(Lt_Indice_sol_carac).USR_CREACION||'",'||
                        '"feCreacion":"'||Lt_CaracteristicasSolicitud(Lt_Indice_sol_carac).FE_CREACION||'"'||
                    '}');

                    Lt_Indice_sol_carac := Lt_Indice_sol_carac + 1;

                END LOOP;

            END IF;
            dbms_lob.append(Lv_JsonCaracSolicitudes,']');

            --CONSULTA LAS PLANIFICACIONES DE LA SOLICITUD
            Lv_JsonPlanifSolicitudes := '[';
            Lt_Indice_sol_planif     := 1;

            IF Lv_RequiereDetallePlanif = 'true' THEN
                Lcl_QueryPlanificaciones := 'SELECT IDSP.ID_DETALLE_SOL_PLANIF, '||
                                            '  IDSP.ASIGNADO_ID, '||
                                            '  IDSP.TIPO_ASIGNADO, '||
                                            '  IDSP.TAREA_ID, '||
                                            ' TO_CHAR(IDSP.FE_INI_PLAN,''RRRR-MM-DD HH24:MI:SS'') FE_INI_PLAN, '||
                                            ' TO_CHAR(IDSP.FE_FIN_PLAN,''RRRR-MM-DD HH24:MI:SS'') FE_FIN_PLAN, '||
                                            '  IDSP.USR_CREACION, '||
                                            ' TO_CHAR(IDSP.FE_CREACION,''RRRR-MM-DD HH24:MI:SS'') FE_CREACION, '||
                                            '  IDSP.ESTADO, '||
                                            '  IDSP.MOTIVO_ID '||
                                            ' FROM DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF IDSP '||
                                            ' WHERE '||
                                            ' IDSP.DETALLE_SOLICITUD_ID = :paramDetalleSolicitudId ';
                Lcl_QueryPlanificaciones := REPLACE(Lcl_QueryPlanificaciones,':paramDetalleSolicitudId',
                                                    Lt_InfoDetalleSolicitud(Lt_Indice_sol).ID_DETALLE_SOLICITUD);

                OPEN Lrf_JsonPlanifSolicitudes FOR Lcl_QueryPlanificaciones;
                  FETCH Lrf_JsonPlanifSolicitudes BULK COLLECT INTO Lt_PlanificacionesSolicitud LIMIT 1000;
                CLOSE Lrf_JsonPlanifSolicitudes;

                --Recorre resultado del query ejecutado
                WHILE Lt_Indice_sol_planif <= Lt_PlanificacionesSolicitud.COUNT LOOP

                    IF Lt_Indice_sol_planif = 1 THEN
                      dbms_lob.append(Lv_JsonPlanifSolicitudes,'{');
                    ELSE
                      dbms_lob.append(Lv_JsonPlanifSolicitudes,',{');
                    END IF;

                    dbms_lob.append(Lv_JsonPlanifSolicitudes,
                        '"idDetalleSolPlanif":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).ID_DETALLE_SOL_PLANIF||'",'||
                        '"asignadoId":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).ASIGNADO_ID||'",'||
                        '"tipoAsignado":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).TIPO_ASIGNADO||'",'||
                        '"tareaId":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).TAREA_ID||'",'||
                        '"feIniPlan":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).FE_INI_PLAN||'",'||
                        '"feFinPlan":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).FE_FIN_PLAN||'",'||
                        '"usrCreacion":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).USR_CREACION||'",'||
                        '"feCreacion":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).FE_CREACION||'",'||
                        '"estado":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).ESTADO||'",'||
                        '"motivoId":"'||Lt_PlanificacionesSolicitud(Lt_Indice_sol_planif).MOTIVO_ID||'"'||
                    '}');

                    Lt_Indice_sol_planif := Lt_Indice_sol_planif + 1;

                END LOOP;
            END IF;
            dbms_lob.append(Lv_JsonPlanifSolicitudes,']');
            dbms_lob.append(Pcl_Response,
                '"idDetalleSolicitud":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).ID_DETALLE_SOLICITUD||'",'||
                '"servicioId":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).SERVICIO_ID||'",'||
                '"tipoSolicitudId":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).TIPO_SOLICITUD_ID||'",'||            
                '"tipoSolicitudDesc":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).DESCRIPCION_SOLICITUD||'",'||
                '"motivoId":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).MOTIVO_ID||'",'||
                '"motivoDesc":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).NOMBRE_MOTIVO||'",'||
                '"usrCreacion":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).USR_CREACION||'",'||
                '"feCreacion":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).FE_CREACION||'",'||
                '"precioDescuento":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).PRECIO_DESCUENTO||'",'||
                '"porcentajeDescuento":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).PORCENTAJE_DESCUENTO||'",'||
                '"tipoDocumento":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).TIPO_DOCUMENTO||'",'||
                '"observacion":"'||REPLACE( REPLACE(Lt_InfoDetalleSolicitud(Lt_Indice_sol).OBSERVACION, chr(12),' '),chr(10),' ')||'",'||
                '"estado":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).ESTADO||'",'||
                '"usrRechazo":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).USR_RECHAZO||'",'||
                '"feRechazo":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).FE_RECHAZO||'",'||
                '"detalleProcesoId":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).DETALLE_PROCESO_ID||'",'||
                '"feEjecucion":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).FE_EJECUCION||'",'||
                '"elementoId":"'||Lt_InfoDetalleSolicitud(Lt_Indice_sol).ELEMENTO_ID||'",'||
                '"caracteristicas":'||Lv_JsonCaracSolicitudes||','||
                '"planificaciones":'||Lv_JsonPlanifSolicitudes||''||
            '}');
            Lt_Indice_sol := Lt_Indice_sol + 1;
          END LOOP;

          dbms_lob.append(Pcl_Response,']');
          DBMS_OUTPUT.PUT_LINE(Pcl_Response);

          --Mensaje de respuesta
          Pv_Status  := 'ok';
          Pv_Mensaje := 'Consulta ejecutada correctamente';

    EXCEPTION
      WHEN Le_Errors THEN
          Pv_Status  := 'ERROR';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_CONSULTAR_SOLICITUD',
                                                Pv_Mensaje,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      WHEN OTHERS THEN
          Pv_Status  := 'fail';
          Pv_Mensaje := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_CONSULTAR_SOLICITUD',
                                                'Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  END P_CONSULTAR_SOLICITUD;

  PROCEDURE P_CONSULTAR_SOLIC_ASOCIADAS(Pcl_Request          IN  CLOB,
                             Pv_Status         OUT VARCHAR2,
                             Pv_Mensaje        OUT VARCHAR2,
                             Pcl_Response OUT CLOB) IS

      Lrf_JsonSolicitudes       SYS_REFCURSOR;
      Lrf_JsonParametros        SYS_REFCURSOR;
      Lv_Query                  CLOB;
      Lv_QueryParametros        CLOB;
      Lv_QueryAdicional         CLOB;
      TYPE T_Array_planifAsociadas IS TABLE OF Gr_PlanificacionesAsociadas INDEX BY BINARY_INTEGER;
      Lt_detallesPlanificacion  T_Array_planifAsociadas;
      TYPE T_Array_Parametros IS TABLE OF Gr_Items INDEX BY BINARY_INTEGER;
      Lt_Parametros             T_Array_Parametros;
      Lt_Indice_sol             NUMBER := 1;
      Lv_IdDetalleSolicitud     VARCHAR2(20);
      Lv_ServicioId             VARCHAR2(20);
      Lv_TipoSolicitudId        VARCHAR2(20);
      Le_Errors                 EXCEPTION;
      Lv_Json                   VARCHAR2(4000);
      Lv_Parametros             VARCHAR2(2000);
      Ln_cantParametros         NUMBER := 0;
      Lv_diasInterConsulta      VARCHAR2(20);
      Lv_FechaDesdeDate         TIMESTAMP;
      Lv_FechaDesde             VARCHAR2(100);

    BEGIN
      apex_json.parse(Pcl_Request);

      Lv_IdDetalleSolicitud := apex_json.get_varchar2('solicitudId');
      Lv_TipoSolicitudId    := apex_json.get_varchar2('tipoSolicitudId');
      Lt_Indice_sol         := 1;

      IF Lv_IdDetalleSolicitud IS NULL AND Lv_TipoSolicitudId IS NULL THEN
          Pv_Mensaje := 'ERROR: Debe enviar al menos uno de los siguientes par�metros solicitudId y tipoSolicitudId';
          RAISE Le_Errors;
      END IF;

      Lv_QueryParametros := 'SELECT VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_CAB cab '||
                            ' JOIN DB_GENERAL.ADMI_PARAMETRO_DET det ON det.PARAMETRO_ID = cab.ID_PARAMETRO '||
                            'WHERE '||
                            q'[cab.NOMBRE_PARAMETRO = 'INSP_CALC_PARAM_INI' ]'||
                            q'[ AND det.DESCRIPCION = 'PARAMETROS_CONSULTAS' ]';
      --Ejecuta el query
      OPEN Lrf_JsonParametros FOR Lv_QueryParametros;
        FETCH Lrf_JsonParametros BULK COLLECT INTO Lt_Parametros LIMIT 1000;
      CLOSE Lrf_JsonParametros;

      WHILE Lt_Indice_sol <= Lt_Parametros.COUNT LOOP
            Lv_Parametros := Lt_Parametros(Lt_Indice_sol).ITEM;
      Lt_Indice_sol := Lt_Indice_sol + 1;
      END LOOP;

      apex_json.parse(Lv_Parametros);
      Lv_diasInterConsulta := apex_json.get_varchar2('diasIntervaloConsultaSolicitudesProp');

      IF Lv_diasInterConsulta IS NULL THEN 
          Lv_diasInterConsulta := '4';
      END IF;

      Lv_FechaDesdeDate := SYSTIMESTAMP - TO_NUMBER(Lv_diasInterConsulta, '99999');
      Lv_QueryAdicional := ' AND TO_CHAR(SOLP.FE_CREACION,''RRRR-MM-DD HH24:MI:SS'') >= :feDesde ';
      Lv_FechaDesde := TO_CHAR(Lv_FechaDesdeDate,'RRRR-MM-DD HH24:MI:SS');
      Lv_QueryAdicional := REPLACE(Lv_QueryAdicional,':feDesde',''''||Lv_FechaDesde||'''');

      Lt_Indice_sol := 1;

      Lv_Query := ' SELECT SOLP.DETALLE_SOLICITUD_ID, SOL.ESTADO SOLICITUD_ESTADO, SOLP.ID_DETALLE_SOL_PLANIF PLANIFICACION_ID, '||
                  '     SOLP.ESTADO PLANIFICACION_ESTADO, '||
                  '    (SELECT UNIQUE IDET.TAREA_ID FROM DB_COMUNICACION.INFO_COMUNICACION COM ' ||
                  '    JOIN DB_SOPORTE.INFO_DETALLE IDET ON IDET.ID_DETALLE = COM.DETALLE_ID ' ||
                  '    WHERE COM.ID_COMUNICACION = SOLP.TAREA_ID) TAREA_ID, '||
                  '    SOLP.TAREA_ID COMUNICACION_ID, '||
                  '    DB_SOPORTE.SPKG_ASIGNACION_SOLICITUD.F_ESTADO_TAREA_POR_TAREA(SOLP.TAREA_ID) TAREA_ESTADO '||
                  '  FROM '||
                  '    DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL '||
                  '    JOIN DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF SOLP ON SOLP.DETALLE_SOLICITUD_ID = SOL.ID_DETALLE_SOLICITUD '||
                  '    JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOLC ON SOLC.DETALLE_SOLICITUD_ID = SOL.ID_DETALLE_SOLICITUD ' ||
                  '  WHERE '||
                  '    SOLC.VALOR = ( ' ||
                  '        SELECT UNIQUE SOLC.VALOR '||
                  '        FROM '||
                  '          DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL '||
                  '          JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOLC ON SOLC.DETALLE_SOLICITUD_ID = SOL.ID_DETALLE_SOLICITUD '||
                  '          JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ON CARAC.ID_CARACTERISTICA = SOLC.CARACTERISTICA_ID '||
                  '        WHERE '||
                  '          SOL.ID_DETALLE_SOLICITUD = :paramIdDetalleSolicitud '||
                  '          AND SOL.TIPO_SOLICITUD_ID = :paramTipoSolicitudId '||
                  q'[          AND CARAC.DESCRIPCION_CARACTERISTICA = 'NUMERO_PROPUESTA_INSPECCION' ]'||
                  '    ) '||
                  Lv_QueryAdicional ;
        Lv_Query := REPLACE(Lv_Query,':paramIdDetalleSolicitud',Lv_IdDetalleSolicitud);
        Lv_Query := REPLACE(Lv_Query,':paramTipoSolicitudId',Lv_TipoSolicitudId);

        OPEN Lrf_JsonSolicitudes FOR Lv_Query;
          FETCH Lrf_JsonSolicitudes BULK COLLECT INTO Lt_detallesPlanificacion LIMIT 1000;
        CLOSE Lrf_JsonSolicitudes;

        Pcl_Response:= '[';

        WHILE Lt_Indice_sol <= Lt_detallesPlanificacion.COUNT LOOP

          IF Lt_Indice_sol = 1 THEN
            dbms_lob.append(Pcl_Response,'{');
          ELSE
            dbms_lob.append(Pcl_Response,',{');
          END IF;

          dbms_lob.append(Pcl_Response,
              '"solicitudId":"'||Lt_detallesPlanificacion(Lt_Indice_sol).DETALLE_SOLICITUD_ID||'",'||
              '"solicitudEstado":"'||Lt_detallesPlanificacion(Lt_Indice_sol).SOLICITUD_ESTADO||'",'||
              '"planificacionId":"'||Lt_detallesPlanificacion(Lt_Indice_sol).PLANIFICACION_ID||'",'||            
              '"planificacionEstado":"'||Lt_detallesPlanificacion(Lt_Indice_sol).PLANIFICACION_ESTADO||'",'||
              '"tareaId":"'||Lt_detallesPlanificacion(Lt_Indice_sol).TAREA_ID||'",'||
              '"comunicacionId":"'||Lt_detallesPlanificacion(Lt_Indice_sol).COMUNICACION_ID||'",'||
              '"tareaEstado":"'||Lt_detallesPlanificacion(Lt_Indice_sol).TAREA_ESTADO||'"'||
          '}');
          Lt_Indice_sol := Lt_Indice_sol + 1;
        END LOOP;

        dbms_lob.append(Pcl_Response,']');

        Pv_Status  := 'ok';
        Pv_Mensaje := 'Consulta ejecutada correctamente';

    EXCEPTION
      WHEN Le_Errors THEN
          Pv_Status  := 'ERROR';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_CONSULTAR_SOLIC_ASOCIADAS',
                                                Pv_Mensaje,
                                                'DB_COMERCIAL',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      WHEN OTHERS THEN
          Pv_Status  := 'fail';
          Pv_Mensaje := 'Error: '||SQLCODE ||' ERROR_STACK -'||DBMS_UTILITY.FORMAT_ERROR_STACK||
                        ' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_SOLICITUD_CONSULTA',
                                              'P_CONSULTAR_SOLIC_ASOCIADAS',
                                              Pv_Mensaje,
                                              'DB_COMERCIAL',
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_CONSULTAR_SOLIC_ASOCIADAS;

END CMKG_SOLICITUD_CONSULTA;
/
