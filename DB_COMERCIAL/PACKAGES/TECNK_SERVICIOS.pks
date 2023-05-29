CREATE OR REPLACE PACKAGE DB_COMERCIAL.TECNK_SERVICIOS
AS
  --
  TYPE Lr_ListadoServicio IS RECORD(
   TOTAL_REGISTRO NUMBER);
    --
    TYPE Lt_Result IS TABLE OF Lr_ListadoServicio;
  --
TYPE Lrf_Result
IS
  REF
  CURSOR;

TYPE Lt_PametrosBind IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
    --
    /**
     * Documentación para TYPE 'Lt_ArrayAsociativo'.
     *
     * Tipo de datos para mapear los parámetros enviados en un array asociativo
     *
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.0 18-10-2017
     */
    TYPE Lt_ArrayAsociativo IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(30);
    --
    /**
     * Documentación para TYPE 'COMP_LISTADO_SERVICIO'.
     *
     * Método que sirve para retornar el listado de servicios de un punto.
     *
     * @since 1.12
     *
     * @author Germán Valenzuela <gvalenzuela@telconet.ec>
     * @version 1.13 15-07-2020 - En el query se suprime la parte que se obtiene el secuencial del grupo y
     *                            se suprime el order by por secuencial del grupo.
     *
     * @author Richard Cabrera <rcabrera@telconet.ec>
     * @version 1.14 02-12-2020 - Se hacen ajustes en el query para obtener tambien los servicios que tengan la caracteristica: ES_BACKUP is not null.
     *
     * @author Richard Cabrera <rcabrera@telconet.ec>
     * @version 1.15 04-12-2020 - Se ajusta el query para evitar duplicidad en servicios backup.
     *
     * @author Jeampier Carriel <jacarriel@telconet.ec>
     * @version 1.13 2021-12-15 - Se agrega variable Pv_ServiciosFTTxTN para filtro para Servicios FTTx de Clientes Telconet.
     */
    PROCEDURE COMP_LISTADO_SERVICIO(
    Pn_PlanBusquedaId               IN NUMBER,
    Pn_ProductoBusquedaId           IN NUMBER,
    Pv_LoginBusqueda                IN VARCHAR2,
    Pv_LoginForma                   IN VARCHAR2,
    Pv_TipoServicioBusqueda         IN VARCHAR2,
    Pn_PuntoBusquedaId              IN NUMBER,
    Pv_EstadoBusqueda               IN VARCHAR2,
    Pn_TipoMedioBusquedaId          IN VARCHAR2,
    Pn_ElementoBusquedaId           IN NUMBER,
    Pn_InterfaceElementoBusquedaId  IN NUMBER,
    Pn_start                        IN NUMBER,
    Pv_codEmpresa                   IN VARCHAR2,
    Pn_servicios                    IN VARCHAR2,
    Pv_ServiciosFTTxTN             	IN VARCHAR2,
    Pn_TotalRegistros   OUT NUMBER,
    Pv_MensaError       OUT VARCHAR2,
    Prf_Result          OUT Lrf_Result);
    --
   
    --OBTENER ID DETALLE SOLICITUD POR ID SERVICIO
    FUNCTION GET_ID_DET_SOLICITUD(
    Fn_IdServicio      IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_tipoSolicitud1  IN ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    Fv_tipoSolicitud2  IN ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    Fv_estadoSolicitud IN INFO_DETALLE_SOLICITUD.ESTADO%TYPE
    )
    RETURN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
   
    --OBTENER CARACTERISTICAS POR ID SERVICIO Y CARACTERISTICA
    FUNCTION GET_VALOR_SERVICIO_PROD_CARACT(
    Fn_IdServicio           IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_NombreCaracteristica IN
    ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE
    )
    RETURN VARCHAR2;

    --OBTENER CARACTERISTICAS POR ID SERVICIO Y CARACTERISTICA DE CANCELACIONES MASIVAS
    FUNCTION GET_VALOR_SERVICIO_CARACT_CM(
    Fn_IdServicio           IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_NombreCaracteristica IN
    ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE
    )
    RETURN VARCHAR2;
    
    --OBTENER CARACTERISTICA POR ID PERSONA EMPRESA ROL
    FUNCTION GET_VALOR_PER_EMP_ROL_CAR(
    Fn_IdPersonaEmpresaRolCaract  IN INFO_PERSONA_EMPRESA_ROL_CARAC.ID_PERSONA_EMPRESA_ROL_CARACT%TYPE,
    Fv_nombreTecnico              IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fn_idPersonaEmpresaRol        IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Fv_nombreCaracteristica       IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE
    )
    RETURN VARCHAR2;
    
    --OBTENER CARACTERISTICAS POR ID DETALLE ELEMENTO
    FUNCTION GET_VALOR_DETALLE_ELEMENTO(
    Fn_IdDetalleElemento  IN INFO_DETALLE_ELEMENTO.ID_DETALLE_ELEMENTO%TYPE
    )
    RETURN INFO_DETALLE_ELEMENTO.DETALLE_VALOR%TYPE;
    
    /**
     * GET_IP_SERVICIO
     *
     * Función que permite obtener la ip del servicio
     *
     * @author Kenneth Jimenez <kjimenez@telconet.ec>
     * @param number Fn_idServicio
     * @return string Lv_ipServicio
     */
    FUNCTION GET_IP_SERVICIO(Fn_idServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN INFO_IP.IP%TYPE;
    
    /**
     * GET_DATO_SUBRED_SERVICIO
     *
     * Función que permite obtener la ip del servicio
     *
     * @author Modificado: Allan Suarez C. <arsuarez@telconet.ec>
     * @version 1.1 2017-03-03 Se agrega consulta por tipo de subred seleccionado
     *
     * @author Kenneth Jimenez <kjimenez@telconet.ec>
     * @param number Fn_idServicio
     * @param number Pv_campoRetorno
     * @return string Lv_datoSubred
     */
    FUNCTION GET_DATO_SUBRED_SERVICIO(Fn_idServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_campoRetorno IN VARCHAR2
                                      ) RETURN DB_INFRAESTRUCTURA.INFO_SUBRED.SUBRED%TYPE;
    
    /**
     * GET_RD_ID
     *
     * Función que permite obtener la ip del servicio
     *
     * @author Kenneth Jimenez <kjimenez@telconet.ec>
     * @param number Fn_idServicio
     * @return string Lv_rdId
     */
    FUNCTION GET_RD_ID(Fn_idServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE;

    --OBTENER IP RESERVADA PARA PRODUCTOS Y PLANES DE IPS
    FUNCTION GET_IP_RESERVADA(
    Fn_IdServicio           IN INFO_SERVICIO.ID_SERVICIO%TYPE
    )
    RETURN DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE;
   
    --OBTENER TIPO DE FLUJO PARA SEGUIR
    FUNCTION GET_FLUJO_TECNICO(
    Fv_PrefijoEmpresa  IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fv_CodigoTipoMedio IN
    DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
    Fv_requiereInfoTec  IN ADMI_PRODUCTO.REQUIERE_INFO_TECNICA%TYPE,
    Fv_requiereInfoTec1 IN ADMI_PRODUCTO.REQUIERE_INFO_TECNICA%TYPE)
    RETURN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE;
   
    --OBTENER VALIDACION PARA MOSTRAR BOTONES TECNICOS
    FUNCTION GET_BOTONES(
    Fn_IdPlan          IN INFO_PLAN_CAB.ID_PLAN%TYPE,
    Fv_nombreProducto  IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fv_nombreProducto1 IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE
    )
    RETURN VARCHAR2;
   
    --OBTENER VALIDACION PARA MAC WIFI
    FUNCTION GET_VALIDACION_MAC_WIFI(
    Fn_IdServicio     IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_nombreProducto IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE
    )
    RETURN VARCHAR2;
   
    --OBTENER ESTADO SOLICITUD PLANIFICACION
    FUNCTION GET_ESTADO_SOLICITUD_PLANIFICA(
    Fn_IdServicio    IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_tipoSolicitud IN ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE
    )
    RETURN VARCHAR2;
   
    --OBTENER VALIDACION IP FIJA
    FUNCTION GET_VALIDACION_IP_FIJA(
    Fv_macWifi        IN INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Fn_IdPunto        IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_tipoReturn     IN VARCHAR2,
    Fv_estadoServicio IN INFO_SERVICIO.ESTADO%TYPE
    )
    RETURN VARCHAR2;
   
    --TIENE ENCUESTA O ACTA
    FUNCTION GET_ACTA_ENCUESTA(Fv_CodTipoDocumento IN
    DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fv_Modulo     IN DB_COMUNICACION.INFO_DOCUMENTO_RELACION.MODULO%TYPE,
    Fn_IdServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fn_IdDetalle  IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE DEFAULT NULL)
    RETURN VARCHAR2;

    /**
     * GET_OBSERVACION_DETALLE
     *
     * Función que permite obtener la observación del id del detalle enviado 
     *
     * @author Lizbeth Cruz<mlcruz@telconet.ec>
     * @param number Fn_IdDetalle
     * @return string Lv_Resultado

     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.1 10-01-2019 Se aumenta el tamaño para la cadena que retorna la función
     */
    FUNCTION GET_OBSERVACION_DETALLE(
    Fn_IdDetalle  IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE DEFAULT NULL)
    RETURN VARCHAR2;
    --
    --OBTENER CANTIDAD REAL POR PRODUCTO
    FUNCTION GET_CANTIDAD_USADA_PRODUCTO(
    Fv_NombreProducto IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fv_NombreProducto1 IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fn_Cantidad     IN INFO_SERVICIO.CANTIDAD%TYPE,
      Fn_IdServicio   IN INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN NUMBER;
    --
    FUNCTION GET_FECHA_CONFIRMACION(Fn_IdServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN VARCHAR2;
    --
    FUNCTION GET_COUNT_REFCURSOR(Prf_Result IN CLOB) RETURN NUMBER;
    --

    /**
     * FNC_GET_MEDIO_POR_PUNTO
     *
     * Función que devuelve el nombre de la ultima milla que está relacionada al punto del cliente
     * @author John Vera <javera@telconet.ec>
     * @param number Pn_IdPunto
     * @param string Pv_NomTecnico
     * @return string Lv_Descripcion
     */
    FUNCTION FNC_GET_MEDIO_POR_PUNTO(Pn_IdPunto    IN INFO_PUNTO.ID_PUNTO%TYPE,
                                     Pv_NomTecnico IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)  RETURN VARCHAR2;
   
    /**
     * FNC_GET_SERV_ELE_PTO
     *
     * Función que devuelve el/los servicios por elemento e interface (dslam, olt, radio, caja, splitter)
     * @author Francisco Adum <fadum@telconet.ec>
     * @param number Fn_IdElemento
     * @param number Fn_IdInterface
     * @return string Ln_idServicio
     */
    FUNCTION FNC_GET_SERV_ELE_PTO(Fn_IdElemento   IN INFO_ELEMENTO.ID_ELEMENTO%TYPE,
                                  Fn_IdInterface  IN INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE) RETURN VARCHAR2;

    /**
    * GET_ID_DET_SOL_PARAM_EST
    * @author Juan Lafuente <jlafuente@telconet.ec>
    * @version 1.0 29-10-2015
    * @since 1.0
    * @param  INFO_SERVICIO.ID_SERVICIO%TYPE                    Fn_IdServicio      
    * @param  ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE    Fv_tipoSolicitud   
    * @param  ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE          Fv_NombreParametro 
    * @param  ADMI_PARAMETRO_CAB.MODULO%TYPE                    Fv_ModuloParametro
    * @return INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE  id de la solicitud
    */
    FUNCTION GET_ID_DET_SOL_PARAM_EST( Fn_IdServicio      IN INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Fv_tipoSolicitud   IN ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                       Fv_NombreParametro IN ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                       Fv_ModuloParametro IN ADMI_PARAMETRO_CAB.MODULO%TYPE )
    RETURN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;


    /**
    * GET_ID_DETALLE_ULTIMA_SOL
    * Funcion que retorna el id_detalle de la ultima solicitud de planificacion o migracion que tenga el servicio
    * @author Richard Cabrera <rcabrera@telconet.ec>
    * @version 1.0 09-12-2015
    * @param  INFO_SERVICIO.ID_SERVICIO%TYPE Fn_IdServicio
    * @return DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE   id_detalle de la solicitud
    */
    FUNCTION GET_ID_DETALLE_ULTIMA_SOL(Fn_IdServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE;

    /**
     * F_GET_VALOR_DET_ELE_FILTROS
     * Funcion que retorna información acerca del cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @param  INFO_DETALLE_ELEMENTO.ELEMENTO_ID%TYPE    IN  Fn_ElementoId
     * @param  INFO_DETALLE_ELEMENTO.DETALLE_NOMBRE%TYPE IN  Fv_DetalleNombre
     * @param  INFO_DETALLE_ELEMENTO.ESTADO%TYPE         IN  Fv_Estado
     */
    FUNCTION F_GET_VALOR_DET_ELE_FILTROS( Fn_ElementoId     IN INFO_DETALLE_ELEMENTO.ELEMENTO_ID%TYPE,
                                          Fv_DetalleNombre  IN INFO_DETALLE_ELEMENTO.DETALLE_NOMBRE%TYPE,
                                          Fv_Estado         IN INFO_DETALLE_ELEMENTO.ESTADO%TYPE )
    RETURN INFO_DETALLE_ELEMENTO.DETALLE_VALOR%TYPE;

    /**
    * F_GET_BW_TOTAL_INTERFACE
    * Función que obtiene la capacidad total de los servicios de una interface
    *
    * @author Felix Caicedo <facaicedo@telconet.ec>
    * @version 1.0 18-06-2020
    *
    * @param DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE IN Fn_IdInterface
    *        VARCHAR2 IN Fv_TipoCapacidad
    * @return VARCHAR2
    */
    FUNCTION F_GET_BW_TOTAL_INTERFACE(
        Fn_IdInterface  IN  DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE,
        Fv_TipoCapacidad  IN  VARCHAR2
    )
    RETURN NUMBER;

    /**
     * P_WS_GET_ROL_CLIENTE
     * Funcion que retorna información acerca del cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @param  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE        IN Pv_EmpresaCod
     * @param  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE IN Pv_Identificacion
     * @param  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE                    IN Pv_Login
     * @param  DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE    IN Pv_SerieOnt
     * @param  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE     IN Pv_MacOnt
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_ROL_CLIENTE( Pv_EmpresaCod     IN DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                                    Pv_Identificacion IN DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                    Pv_Login          IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                    Pv_SerieOnt       IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE,
                                    Pv_MacOnt         IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                    Prf_Result        OUT Lrf_Result,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2 );

    /**
     * P_WS_GET_ROL_CLIENTE_EXT
     * Funcion que retorna información acerca del cliente segun los parametros enviados, y estados parametrizados
     * para extranet
     * @author Jose Bedon <jobedon@telconet.ec>
     * @version 1.0 22-04-2020
     *
     * @author Jean Pierre Nazareno Martinez <jnazareno@telconet.ec>
     * @version 1.1 14-02-2022 - Se parametrizan los estados del punto permitidos para la consulta del cliente.
     *
     * @param  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE        IN Pv_EmpresaCod
     * @param  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE IN Pv_Identificacion
     * @param  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE                    IN Pv_Login
     * @param  DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE    IN Pv_TipoRol
     * @param  DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE    IN Pv_SerieOnt
     * @param  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE     IN Pv_MacOnt
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_ROL_CLIENTE_EXT( Pv_EmpresaCod     IN DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                                        Pv_Identificacion IN DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                        Pv_Login          IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                        Pv_TipoRol        IN DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
                                        Pv_SerieOnt       IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE,
                                        Pv_MacOnt         IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                        Prf_Result        OUT Lrf_Result,
                                        Pv_Status         OUT VARCHAR2,
                                        Pv_Mensaje        OUT VARCHAR2 );

    /**
     * P_WS_GET_PUNTOS_CLIENTE
     * Funcion que retorna información acerca de puntos de un cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @param  DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE     IN Pv_EmpresaCod
     * @param  DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE IN Pn_RolCliente
     * @param  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE                  IN Pv_Login
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_PUNTOS_CLIENTE( Pv_EmpresaCod   IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                                       Pn_RolCliente   IN DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE,
                                       Pv_Login        IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                       Prf_Result      OUT Lrf_Result,
                                       Pv_Status       OUT VARCHAR2,
                                       Pv_Mensaje      OUT VARCHAR2 );

    /**
     * P_WS_GET_SERVICIOS_PTO_CLIENTE
     * Función que retorna información acerca de servicios delpunto de un cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @param  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE     IN  Pn_IdPuntoCliente
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     *
     * Costo = 14
     *
     * @author Ricardo Robles <rrobles@telconet.ec>
     * @version 1.2 17-06-2019 Se modifica la consulta para devolver el valor del servicio.
     *
     * @author Richard Cabrera <rcabrera@telconet.ec>
     * @version 1.3 06-06-20201 Se adicionan campos requeridos por consulta de Servicios con nueva red GPON-MPLS
     *
     */
    PROCEDURE P_WS_GET_SERVICIOS_PTO_CLIENTE( Pn_IdPuntoCliente   IN DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                              Prf_Result          OUT Lrf_Result,
                                              Pv_Status           OUT VARCHAR2,
                                              Pv_Mensaje          OUT VARCHAR2 );

    /**
     * P_WS_GET_INF_SERVICIO_INTERNET
     * Funcion que retorna información tecnica del servicio de internet del punto de un cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @param  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE     IN  Pn_IdServicioInternet
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_INF_SERVICIO_INTERNET( Pn_IdServicioInternet  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                              Prf_Result             OUT Lrf_Result,
                                              Pv_Status              OUT VARCHAR2,
                                              Pv_Mensaje             OUT VARCHAR2 );

    /**
     * P_WS_GET_IPS_POR_PUNTO
     * Funcion que retorna información acerca de Ips del punto de un cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @param  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE     IN  Pn_IdPuntoCliente
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_IPS_POR_PUNTO( Pn_IdPuntoCliente      IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                      Prf_Result             OUT Lrf_Result,
                                      Pv_Status              OUT VARCHAR2,
                                      Pv_Mensaje             OUT VARCHAR2);

    /**
     * P_WS_GET_CASOS_POR_PUNTO
     * Funcion que retorna información acerca de casos del punto de un cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @param  DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE   IN  Pv_Login
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_CASOS_POR_PUNTO( Pv_Login       IN DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE,
                                        Prf_Result     OUT Lrf_Result,
                                        Pv_Status      OUT VARCHAR2,
                                        Pv_Mensaje     OUT VARCHAR2 );

    /**
     * P_WS_GET_TAREAS_POR_PUNTO
     * Funcion que retorna información acerca de tareas del punto de un cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @param  DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE   IN  Pv_Login
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_TAREAS_POR_PUNTO( Pv_Login       IN DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE,
                                         Prf_Result     OUT Lrf_Result,
                                         Pv_Status      OUT VARCHAR2,
                                         Pv_Mensaje     OUT VARCHAR2 );

    /**
     * P_WS_GET_ONT_ID_POR_PUNTO
     * Funcion que retorna información acerca del ont id de un cliente segun los parametros enviados
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 20-10-2016
     * @author Lizbeth Cruz<mlcruz@telconet.ec>
     * @version 1.1 18-05-2018 Se modifica la consulta para obtener servicios Small Business 
     *                         Costo = 21
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.2 11-02-2019 Se modifica la consulta para obtener servicios TelcoHome
     *    
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.3 12-10-2021 Se parametrizan los nombres técnicos de los productos usados en la consulta
     * 
     * @param  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE   IN  Pv_Login
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_ONT_ID_POR_PUNTO( Pv_Login       IN  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                         Prf_Result     OUT Lrf_Result,
                                         Pv_Status      OUT VARCHAR2,
                                         Pv_Mensaje     OUT VARCHAR2 );

    /**
     * P_WS_GET_LOGINES_POR_OLT
     * Funcion que retorna información acerca de los logines asociados a un puerto del olt filtrado
     * mediante parametros
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 30-09-2016
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.1 20-10-2016   Se agrega validación para que solo se recupere información servicios con planes
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.2 18-05-2018 Se modifica la consulta para obtener servicios Small Business
     *                         Costo = 201
     *
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.3 11-02-2019 Se modifica la consulta para obtener servicios TelcoHome
     *
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.4 12-10-2021 Se parametrizan los nombres técnicos de los productos usados en la consulta
     * 
     * @param  DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE                       IN  Pv_Olt
     * @param  DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE   IN  Pv_PuertoOlt
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_WS_GET_LOGINES_POR_OLT( Pv_Olt         IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
                                        Pv_PuertoOlt   IN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
                                        Prf_Result     OUT Lrf_Result,
                                        Pv_Status      OUT VARCHAR2,
                                        Pv_Mensaje     OUT VARCHAR2 );

    /**
     * P_GET_SERVICIOS_MISMA_UM
     * Funcion que retorna información acerca de los servicios asociados a una misma UM segun los parametros enviados
     * 
     * @author Jesus Bozada <jbozada@telconet.ec>
     * @version 1.0 25-10-2016
     * @param  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID                                     IN Pn_PuntoId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_ID                    IN Pn_ElementoId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_ID          IN Pn_InterfaceElementoId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID            IN Pn_ElementoClienteId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID  IN Pn_InterfaceElementoClienteId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID                IN Pn_UltimaMillaId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.TERCERIZADORA_ID               IN Pn_TercerizadoraId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CONTENEDOR_ID         IN Pn_ElementoContenedorId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CONECTOR_ID           IN Pn_ElementoConectorId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID IN Pn_InterfaceElementoConectorId
     * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.TIPO_ENLACE                    IN Pv_TipoEnlace
     * @param  Lrf_Result OUT Prf_Result
     * @param  VARCHAR2   OUT Pv_Status
     * @param  VARCHAR2   OUT Pv_Mensaje
     */
    PROCEDURE P_GET_SERVICIOS_MISMA_UM( Pn_PuntoId                     IN DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                        Pn_ElementoId                  IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_ID%TYPE,
                                        Pn_InterfaceElementoId         IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_ID%TYPE,
                                        Pn_ElementoClienteId           IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE,
                                        Pn_InterfaceElementoClienteId  IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
                                        Pn_UltimaMillaId               IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE,             
                                        Pn_TercerizadoraId             IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.TERCERIZADORA_ID%TYPE,          
                                        Pn_ElementoContenedorId        IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CONTENEDOR_ID%TYPE,
                                        Pn_ElementoConectorId          IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CONECTOR_ID%TYPE,
                                        Pn_InterfaceElementoConectorId IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID%TYPE,
                                        Pv_TipoEnlace                  IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.TIPO_ENLACE%TYPE,
                                        Prf_Result                     OUT Lrf_Result,
                                        Pv_Status                      OUT VARCHAR2,
                                        Pv_Mensaje                     OUT VARCHAR2 );

  /**
    * GET_EXISTE_AS_PRIVADO

    * Función que permite obtener si un asprivado existe o no dentro de otro servicio ( internet mpls ) o dentro de otro
    * cliente ( l3mpls )
    * @param number    Fn_idPersonalRol   persona rol del cliente en sesion
    * @param varchar2  Fn_asPrivado       as privado a ser verficado
    * @param varchar2  Fn_tipoProducto    tipo de producto ( nombre tecnico - l3mpls/intmpls )
    * @return varchar2 Lv_existeAsPrivado Resultado de la funcion
    */
    FUNCTION GET_EXISTE_AS_PRIVADO(
      Fn_idPersonalRol IN  INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fn_asPrivado     VARCHAR2,
      Fn_tipoProducto  VARCHAR2
      )
    RETURN VARCHAR2;  

    /**
     * F_GET_SERVICIOS_LIBERA_FACTIB
     * Función que retorna el listado de servicios de los que se liberará los recursos de factibilidad con la información respectiva
     * Costo = 338
     * 
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.0 17-10-2017
     *
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.1 01-11-2017 Se modifica la consulta eliminando el filtro por estado del producto en TN y el filtro del estado 
     *                         del plan para MD para que incluso se liberen servicios cuyo producto o plan ya no se encuentre 'Activo'
     *
     * @param  Fv_CodigoEmpresa             IN VARCHAR2 Recibe el código de la empresa
     * @param  Fv_PrefijoEmpresa            IN VARCHAR2 Recibe el prefijo d ela empresa
     * @param  Fv_Region                    IN VARCHAR2 Recibe la región R1 y R2
     * @param  Fv_CodigoUltimaMilla         IN VARCHAR2 Recibe el código de la última milla del servicio
     * @param  Fn_DiasLiberaFactib          IN NUMBER Recibe el número de días mínimos de un servicio en factible
     * @param  Fn_TotalRegistros            OUT NUMBER Recibe el total de registros del listado de servicios
     * @return Frf_ServiciosLiberaFactib    OUT SYS_REFCURSOR Cursor que retorna el listado de servicios
     */
    FUNCTION F_GET_SERVICIOS_LIBERA_FACTIB(
                                            Fv_CodigoEmpresa        IN VARCHAR2,
                                            Fv_PrefijoEmpresa       IN VARCHAR2,
                                            Fv_Region               IN VARCHAR2,
                                            Fv_CodigoUltimaMilla    IN VARCHAR2,
                                            Fn_DiasLiberaFactib     IN NUMBER,
                                            Fn_TotalRegistros       OUT NUMBER)
    RETURN SYS_REFCURSOR;

    /**
     * F_GET_VALIDACION_IP_FIJA_TN
     *
     * Función que obtiene la información 
     * 
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.0 26-04-2018
     * 
     * @author Lizbeth Cruz <mlcruz@telconet.ec>
     * @version 1.1 24-04-2020 Se modifica la obtención de la información de ips para considerar los productos relacionados de Internet e ips
     *
     * @author Felix Caicedo <facaicedo@telconet.ec>
     * @version 1.2 08-07-2022 Se recibe el id del servicio, para validar las ip relacionadas con el servicio principal.
     *
     * @param  Fv_MacWifi                   IN INFO_SERVICIO_PROD_CARACT.VALOR%TYPE Recibe la mac wifi
     * @param  Fn_IdServicio                IN INFO_SERVICIO.ID_SERVICIO%TYPE       Recibe el id del servicio
     * @param  Fn_IdPunto                   IN INFO_PUNTO.ID_PUNTO%TYPE             Recibe el id del punto
     * @param  Fv_TipoReturn                IN VARCHAR2                             Recibe el tipo de return
     * @param  Fv_EstadoServicio            IN INFO_SERVICIO.ESTADO%TYPE            Recibe el estado del servicio
     * @param  Fn_IdProducto                IN ADMI_PRODUCTO.ID_PRODUCTO%TYPE       Recibe el id del producto asociado al servicio
     * @param  Fv_CodEmpresa                IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Recibe el id de la empresa
     * @return OUT VARCHAR2
     *
     */
    FUNCTION F_GET_VALIDACION_IP_FIJA_TN(
    Fv_MacWifi          IN INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Fn_IdServicio       IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fn_IdPunto          IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_TipoReturn       IN VARCHAR2,
    Fv_EstadoServicio   IN INFO_SERVICIO.ESTADO%TYPE,
    Fn_IdProducto       IN ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Fv_CodEmpresa       IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
    )
    RETURN VARCHAR2;

  /**
   * F_SPLIT_VARCHAR2
   * Función que obtiene el arreglo resultante de realizar el split de una cadena
   * 
   * @param  Fv_Cadena      IN VARCHAR2 Cadena a la que se buscará el delimitador
   * @param  Fv_Delimiter   IN VARCHAR2 Caracter que delimita la cadena
   * @return OUT VARCHAR2
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 03-10-2019
   *
   */
    FUNCTION F_SPLIT_VARCHAR2(  
      Fv_Cadena    IN  VARCHAR2,
      Fv_Delimiter IN  VARCHAR2)
    RETURN DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;

  /**
   * F_GET_CORREOS_LICENCIAS
   * Función que obtiene el correo asociado al punto para la activación de licencias
   *
   * @param  Fv_IdPunto             IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE Id del punto
   * @param  Fv_ObtienePrimerCorreo IN VARCHAR2 SI O NO se obtiene sólo el primer correo
   * @return OUT DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 03-10-2019
   *
   */
  FUNCTION F_GET_CORREOS_LICENCIAS(
    Fv_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_ObtienePrimerCorreo  IN VARCHAR2
    )
  RETURN DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;

  /**
   * P_GET_PTOS_INTERNET_X_OLT
   * Procedimiento que retorna el listado de puntos asociados a un plan de Internet en un determinado OLT
   *
   * @param  Pn_IdElementoOlt   IN NUMBER Recibe el id del elemento OLT
   * @param  Prf_Registros      OUT SYS_REFCURSOR Cursor que retorna el listado de servicios
   * @param  Pv_Status          OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError        OUT VARCHAR2 Mensaje de error
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 03-10-2019
   *
   * Costo = 421
   */
  PROCEDURE P_GET_PTOS_INTERNET_X_OLT(
      Pn_IdElementoOlt  IN NUMBER,
      Prf_Registros     OUT SYS_REFCURSOR,
      Pv_Status         OUT VARCHAR2,
      Pv_MsjError       OUT VARCHAR2);

  /**
   * P_GET_SERV_ADICS_I_PROTEGIDO
   * Procedimiento que retorna el listado de servicios adicionales de Internet Protegido de tecnología McAfee de un determinado punto
   *
   * @param  Pn_IdPunto     IN NUMBER Recibe el id del punto
   * @param  Prf_Registros  OUT SYS_REFCURSOR Cursor que retorna el listado de servicios
   * @param  Pv_Status      OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError    OUT VARCHAR2 Mensaje de error
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 03-10-2019
   *
   * Costo = 9
   */
  PROCEDURE P_GET_SERV_ADICS_I_PROTEGIDO(
    Pn_IdPunto      IN NUMBER,
    Prf_Registros   OUT SYS_REFCURSOR,
    Pv_Status       OUT VARCHAR2,
    Pv_MsjError     OUT VARCHAR2);

  /**
   * P_GET_OLTS_INICIO_CPM
   * Procedimiento que retorna el listado de olts que tienen solicitudes de cambio de plan masivo en estado Pendiente asociada a un servicio
   *
   * @param  Pv_RetornaDataOltsCpm      IN VARCHAR2 SI o NO se necesita la información de los olts
   * @param  Pv_RetornaTotalOltsCpm     IN VARCHAR2 SI o NO se necesita el total de olts
   * @param  Pn_IdOlt                   IN NUMBER Id del Olt
   * @param  Pn_Start                   IN NUMBER Inicio del rownum
   * @param  Pn_Limit                   IN NUMBER Fin del rownum
   * @param  Pv_Status                  OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error
   * @param  Prf_OltsCpm                OUT SYS_REFCURSOR Cursor que retorna el listado de olts
   * @param  Pn_TotalOltsCpm            OUT NUMBER Número total de olts
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 27-11-2019
   *
   * Costo = 204
   */
  PROCEDURE P_GET_OLTS_INICIO_CPM(
    Pv_RetornaDataOltsCpm   IN VARCHAR2,
    Pv_RetornaTotalOltsCpm  IN VARCHAR2,
    Pn_IdOlt                IN NUMBER,
    Pn_Start                IN NUMBER,
    Pn_Limit                IN NUMBER,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_OltsCpm             OUT SYS_REFCURSOR,
    Pn_TotalOltsCpm         OUT NUMBER);

  /**
   * P_GET_SERV_IPS_MIGRACION
   * Procedimiento que retorna el listado de servicios Ips tanto dentro del plan como adicionales en MD
   * y las Ips de los servicios Small Business e Ips Small Business en TN
   *
   * @param  Pn_IdElementoOlt           IN NUMBER Recibe el id del olt
   * @param  Pv_RetornaDataServicios    IN VARCHAR2 SI o NO se necesita la información de los servicios,
   * @param  Pv_RetornaTotalServicios   IN VARCHAR2 SI o NO se necesita el total de servicios,
   * @param  Pv_Status                  OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error
   * @param  Prf_ServiciosIps           OUT SYS_REFCURSOR Cursor que retorna el listado de servicios ips
   * @param  Pn_TotalServiciosIps       OUT NUMBER Número total de servicios Ips
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 28-10-2019
   *
   * Costo = 11
   */
  PROCEDURE P_GET_SERV_IPS_MIGRACION(
    Pn_IdElementoOlt            IN NUMBER,
    Pv_RetornaDataServicios     IN VARCHAR2,
    Pv_RetornaTotalServicios    IN VARCHAR2,
    Pv_Status                   OUT VARCHAR2,
    Pv_MsjError                 OUT VARCHAR2,
    Prf_ServiciosIps            OUT SYS_REFCURSOR,
    Pn_TotalServiciosIps        OUT NUMBER);

  /**
   * P_GET_PTOS_INTERNET_X_REINTEN
   * Procedimiento que retorna el listado de puntos asociados a un plan de Internet que no se activaron
   *
   * @param  Pn_IdElementoOlt   IN NUMBER Recibe el id del elemento OLT
   * @param  Prf_Registros      OUT SYS_REFCURSOR Cursor que retorna el listado de servicios
   * @param  Pv_Status          OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError        OUT VARCHAR2 Mensaje de error
   * 
   * @author Antonio Ayala <afayala@telconet.ec>
   * @version 1.0 18-11-2019
   *
   * Costo = 634
   */
  PROCEDURE P_GET_PTOS_INTERNET_X_REINTEN(
      Pn_IdElementoOlt  IN NUMBER,
      Prf_Registros     OUT SYS_REFCURSOR,
      Pv_Status         OUT VARCHAR2,
      Pv_MsjError       OUT VARCHAR2);

  /**
   * P_VALIDA_LINEA_CSV_CPM
   * Procedimiento para validar una línea de un archivo csv por cambio de plan masivo
   * 
   * @param Pv_ContenidoLinea       IN VARCHAR2 Contenido de la línea
   * @param Pv_DelimitadorCampo     IN VARCHAR2 Delimitador de los campos de la línea CSV
   * @param Pv_Status               OUT VARCHAR2 Status de la ejecución del procedimiento
   * @param Pv_TipoError            OUT VARCHAR2 Tipo de error de la línea
   * @param Pr_RegDataPorProcesar   OUT DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataPorProcesarCpm Registro para procesar el cambio de plan masivo
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 24-12-2019
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 21-01-2020 Se permite la subida de clientes ZTE para realizar el cambio de plan masivo
   *
   */
  PROCEDURE P_VALIDA_LINEA_CSV_CPM(
    Pv_ContenidoLinea           IN VARCHAR2,
    Pv_DelimitadorCampo         IN VARCHAR2,
    Pv_Status                   OUT VARCHAR2,
    Pv_TipoError                OUT VARCHAR2,
    Pr_RegDataPorProcesar       OUT DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataPorProcesarCpm);

  /**
   * P_GET_REINT_ADICS_I_PROTEGIDO
   * Procedimiento que retorna el listado de servicios adicionales de Internet Protegido de un determinado punto
   *
   * @param  Pn_IdPunto     IN NUMBER Recibe el id del punto
   * @param  Prf_Registros  OUT SYS_REFCURSOR Cursor que retorna el listado de servicios
   * @param  Pv_Status      OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError    OUT VARCHAR2 Mensaje de error
   * 
   * @author Antonio Ayala <afayala@telconet.ec>
   * @version 1.0 16-12-2019
   *
   * Costo = 10
   */
  PROCEDURE P_GET_REINT_ADICS_I_PROTEGIDO(
    Pn_IdPunto      IN NUMBER,
    Prf_Registros   OUT SYS_REFCURSOR,
    Pv_Status       OUT VARCHAR2,
    Pv_MsjError     OUT VARCHAR2);    

  /**
   * F_GET_ITEM_PROD_EN_PLAN
   * Función que verifica si un producto se encuentra como detalle de un plan
   *
   * @param  Fn_IdPlan              IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE Id del plan
   * @param  Fv_NombreTecnicoProd   IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE Nombre técnico del producto a verificar en el plan
   * @param  Fn_IdProducto          IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE Id del producto a verificar en el plan
   * @param  Fv_DescripcionProd     IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE Descripción del producto a verificar en el plan
   * @return OUT DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 11-06-2020
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 30-06-2020 Se agrega el parámetro Fv_DescripcionProd para buscar un producto con dicha descripción dentro de un plan
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.2 25-07-2020 Se elimina la creación del registro en la info_error por no obtener la información del item del plan,
   *                         ya que est podría pasar frecuentemente cuando el plan no tenga detalles dual band
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.3 13-01-2021 Se modifica función para excluir únicamente los detalles del plan en estado Eliminado con el fin de unificar 
   *                         la validación de esta función con la usada en Telcos+  
   *
   */
  FUNCTION F_GET_ITEM_PROD_EN_PLAN(
    Fn_IdPlan               IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Fv_NombreTecnicoProd    IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fn_IdProducto           IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Fv_DescripcionProd      IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE)
  RETURN DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE;

  /**
   * P_VERIF_DET_PLAN_W_Y_EXTENDER
   * Procedimiento que obtiene el detalle del Wifi y Extender dual band de un plan
   *
   * @param  Pn_IdPlan              IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE Id del plan
   * @param  Pv_Status              OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError            OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pv_PlanConDetalleWdb   OUT VARCHAR2 'SI' o 'NO' el Wifi dual band forma parte del plan
   * @param  Pv_PlanConDetalleEdb   OUT VARCHAR2 'SI' o 'NO' el Extender dual band forma parte del plan
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 11-06-2020
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 30-06-2020 Se agrega el parámetro Lv_DescripcionProducto por modificación de la función F_GET_ITEM_PROD_EN_PLAN
   *
   */
  PROCEDURE P_VERIF_DET_PLAN_W_Y_EXTENDER(  
    Pn_IdPlan               IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pv_PlanConDetalleWdb    OUT VARCHAR2,
    Pv_PlanConDetalleEdb    OUT VARCHAR2);

  /**
   * F_GET_PARAMS_SERVICIOS_MD
   * Función que obtiene los parámetros de diferentes opciones para servicios de MD
   *
   * @param  Fr_ParametroDetalleBusqueda IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE Registro con los parámetros de búsqueda
   * @return OUT DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 11-06-2020
   *
   */
  FUNCTION F_GET_PARAMS_SERVICIOS_MD(
    Fr_ParametroDetalleBusqueda IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE DEFAULT NULL)
  RETURN SYS_REFCURSOR;

  /**
   * P_VERIF_EQUIPOS_W_Y_EXTENDER
   * Procedimiento que verifica los equipos Wifi y Extender dual band de un servicio
   *
   * @param  Pv_VerificaEquipoWdb       IN VARCHAR2 'SI' o 'NO' hay que verificar el equipo Wifi Dual Band
   * @param  Pv_VerificaEquipoEdb       IN VARCHAR2 'SI' o 'NO' hay que verificar el equipo Extender Dual Band
   * @param  Pv_TecnologiaServicio      IN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE 'HUAWEI', 'TELLION', 'ZTE'
   * @param  Pv_NombreModeloOlt         IN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE 'MA5608T', 'EP-3116', 'C320', 'C610'
   * @param  Pv_NombreModeloOnt         IN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE Nombre del modelo del Ont que se 
   *                                                                                                           verificará
   * @param  Pn_IdInterfaceOnt          IN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE Id de la interface del ont
   * @param  Pv_Status                  OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pv_NecesitaCambiarWdb      OUT VARCHAR2 'SI' o 'NO' el servicio requiere el Wifi Dual Band
   * @param  Pv_NecesitaAgregarEdb      OUT VARCHAR2 'SI' o 'NO' el servicio requiere agregar el Extender dual band
   * @param  Pn_IdElementoSiguiente     OUT DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE 'SI' o 'NO' el servicio requiere agregar el Extender 
   *                                                                                          dual band
   * @param  Pn_IdInterfaceEleSiguiente OUT DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE 'SI' o 'NO' el servicio requiere 
   *                                                                                                              agregar el Extender dual band
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 12-06-2020
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 25-06-2020 Se agrega validación por tecnología del servicio, ya que ahora será usada desde el cambio de plan individual y no sólo
   *                         de la regularización de servicios Huawei y adicional se retorna la información del elemento atado en el siguiente enlace
   *
   */
  PROCEDURE P_VERIF_EQUIPOS_W_Y_EXTENDER(   
    Pv_VerificaEquipoWdb        IN VARCHAR2,
    Pv_VerificaEquipoEdb        IN VARCHAR2,
    Pv_TecnologiaServicio       IN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE,
    Pv_NombreModeloOlt          IN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    Pv_NombreModeloOnt          IN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    Pn_IdInterfaceOnt           IN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE,
    Pv_Status                   OUT VARCHAR2,
    Pv_MsjError                 OUT VARCHAR2,
    Pv_NecesitaCambiarWdb       OUT VARCHAR2,
    Pv_NecesitaAgregarEdb       OUT VARCHAR2,
    Pn_IdElementoSiguiente      OUT DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    Pn_IdInterfaceEleSiguiente  OUT DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE
  );

  /**
   * F_GET_SOL_VALIDA_DUAL_BAND
   * Función que obtiene la última SOLICITUD AGREGAR EQUIPO o SOLICITUD AGREGAR EQUIPO MASIVO que permite gestionar equipos Wifi o Extender Dual Band
   *
   * @param  Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id del servicio
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 16-06-2020
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 08-07-2020 Se modifica el procedimiento, ya que ahora se utilizará para servicios sin equipos Dual Band
   *
   */
  FUNCTION F_GET_SOL_VALIDA_DUAL_BAND(  
    Fn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  )
  RETURN SYS_REFCURSOR;

  /**
   * P_VALIDA_FLUJO_ANTIVIRUS
   * Procedimiento que valida el flujo de servicios de Internet Protegido
   *
   * @param  Pv_LoginPunto              IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE Login del punto
   * @param  Pv_OpcionConsulta          IN VARCHAR2 Opción desde la que se invoca el procedimiento 'CREAR_PLAN' o 'CLONAR_PLAN'
   * @param  Pv_Valor1ParamAntivirus    IN VARCHAR2 'NUEVO'
   * @param  Pv_Valor2LoginesAntivirus  IN VARCHAR2 'INDIVIDUAL' o 'MASIVO'
   * @param  Pv_Status                  OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pv_FlujoAntivirus          OUT VARCHAR2 'ANTERIOR' o 'NUEVO'
   * @param  Pv_ValorAntivirus          OUT VARCHAR2 'KASPERSKY'
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 30-06-2020
   *
   */
  PROCEDURE P_VALIDA_FLUJO_ANTIVIRUS(
    Pv_LoginPunto             IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    Pv_OpcionConsulta         IN VARCHAR2,
    Pv_Valor1ParamAntivirus   IN VARCHAR2,
    Pv_Valor2LoginesAntivirus IN VARCHAR2,
    Pv_Status                 OUT VARCHAR2,
    Pv_MsjError               OUT VARCHAR2,
    Pv_FlujoAntivirus         OUT VARCHAR2,
    Pv_ValorAntivirus         OUT VARCHAR2);

  /**
   * P_VERIFICA_CAMBIO_PLAN
   * Procedimiento que valida si el cambio de plan es permitudo
   *
   * @param  Pn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id del servicio
   * @param  Pn_IdPlanNuevo IN VARCHAR2 Id del plan al que se desea  cambiar
   * @param  Pv_Status      OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError    OUT VARCHAR2 Mensaje de error del procedimiento
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 30-06-2020
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 16-12-2021 Se agrega validación para que los planes que incluyen Wifi y Extender dual band con tecnología ZTE no continúen con
   *                         el flujo existente de Huawei. Además, se corrigen los caracteres especiales por las tildes correspondientes ya que 
   *                         nuevamente el paquete tiene caracteres especiales
   *
   * @author Emmanuel Martillo <emartillo@telconet.ec>
   * @version 1.2 03-03-2023 Se agrega parametro por codigo de empresa para busqueda de Informacion del Servicio a Verificar 
   *                         para ecuanet, pueda seguir el flujo de MD. 
   *
   */
  PROCEDURE P_VERIFICA_CAMBIO_PLAN(
    Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdPlanNuevo  IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pv_Status       OUT VARCHAR2,
    Pv_MsjError     OUT VARCHAR2 );

  /**
   * P_GET_PUNTOS_MD_ASOCIADOS
   * Procedimiento que realiza la búsqueda de logines MD que podrían asociarse a un servicio de TN
   *
   * @param  Pv_CedulaCliente       IN VARCHAR2 Cédula del cliente
   * @param  Pv_LoginPunto          IN VARCHAR2 Login del punto
   * @param  Pn_Start               IN NUMBER Inicio del rownum
   * @param  Pn_Limit               IN NUMBER Fin del rownum
   * @param  Pv_Status              OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError            OUT VARCHAR2 Mensaje de error
   * @param  Prf_PuntosMd           OUT SYS_REFCURSOR Cursor que retorna el listado de puntos
   * @param  Pn_TotalPuntosMd       OUT NUMBER Número total de puntos
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 19-07-2020
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 29-07-2020 Se agrega la obtención del ID_PERSONA_ROL de la consulta de puntos MD
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.2 20-09-2020 Se eliminan variables que no son usadas en el procedimiento
   *
   */
  PROCEDURE P_GET_PUNTOS_MD_ASOCIADOS(
    Pv_CedulaCliente    IN VARCHAR2,
    Pv_LoginPunto       IN VARCHAR2,
    Pn_Start            IN NUMBER,
    Pn_Limit            IN NUMBER,
    Pv_Status           OUT VARCHAR2,
    Pv_MsjError         OUT VARCHAR2,
    Prf_PuntosMd        OUT SYS_REFCURSOR,
    Pn_TotalPuntosMd    OUT NUMBER);

 /**
   * P_ENVIO_CORREO_CREA_SOL_PYL
   * Procedimiento que envía el correo a PYL por creación de una solicitud
   * 
   * @param Pr_DataGeneralCliente       IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataGeneralCliente Registro con la información del servicio
   * @param Pv_DescripcionSolicitud     IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE Descripción de la solicitud
   * @param Pv_Observacion              IN VARCHAR2 Observación del correo
   * @param Pv_Status                   OUT VARCHAR2 Status de la ejecución del procedimiento
   * @param Pv_MsjError                 OUT VARCHAR2 Mensaje de error de la ejecución del procedimiento
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 27-07-2020
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 24-09-2020 Se realiza validación para envío de correo por creación de solicitud de agregar equipo para servicios W + AP
   *
   */
  PROCEDURE P_ENVIO_CORREO_CREA_SOL_PYL(
    Pr_DataGeneralCliente   IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataGeneralCliente,
    Pv_DescripcionSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    Pv_Observacion          IN VARCHAR2,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2);
    
  /**
   * P_GET_PUNTOS_CORTE_MASIVO
   * Procedimiento que retorna el listado de puntos que se cortarán de acuerdo a los parámetros enviados
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 07-08-2020
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 08-09-2020 Se agregan a la consulta los filtros por tipo de documento(se considera usuario de creación para FAC Y FACP) 
   *                         y por fecha de creación del documento.
   *
   * @author Javier Hidalgo <jihidalgo@telconet.ec>
   * @version 1.2 12-09-2022 - Se agregan a la consulta filtros por identificaciones excluidas 
   *                            y por fecha de activación del servicio.
   *
   * @author Javier Hidalgo <jihidalgo@telconet.ec>
   * @version 1.3 15-11-2022 - Se agrega condicional y mejora en consulta para obtener puntos a cortar
   *                            para el proceso masivo.
   *
   * @author Jessenia Piloso <jpiloso@telconet.ec>
   * @version 1.4 15-03-2023 - Se cambio el procedimiento para insertar el Query de consulta de puntos de corte masivo de insert_error a insert_log .
   *
   * @author Andrea Orellana <adorellana@telconet.ec>
   * @version 1.5 16-04-2023 - Se agrega comillas simples en el ciclo ID por error al comparar varchar con number luego de la actualización de base a 19c.
   *
   * @param  Pcl_JsonFiltrosBusqueda    IN CLOB Json con los filtros para la consulta
   * @param  Pv_ConsultaTotalRegistros  IN VARCHAR2 'SI' o 'NO' se realiza consulta del total de registros
   * @param  Pv_Status                  OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error
   * @param  Pn_TotalRegistros          OUT NUMBER Total de registros
   * @param  Prf_Registros              OUT SYS_REFCURSOR Cursor que retorna el listado de registros
   *
   * Costo = 2355
   */
  PROCEDURE P_GET_PUNTOS_CORTE_MASIVO(
    Pcl_JsonFiltrosBusqueda   IN CLOB,
    Pv_ConsultaTotalRegistros IN VARCHAR2,
    Pv_Status                 OUT VARCHAR2,
    Pv_MsjError               OUT VARCHAR2,
    Pn_TotalRegistros         OUT NUMBER,
    Prf_Registros             OUT SYS_REFCURSOR);

  /**
   * P_GET_RESUMEN_CORTE_MASIVO
   * Procedimiento que retorna el conteo para el resumen previo
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 01-10-2021
   *
   * @author Javier Hidalgo <jihidalgo@telconet.ec>
   * @version 1.1 12-09-2022 - Se agregan a la consulta filtros por identificaciones excluidas 
   *                            y por fecha de activación del servicio.
   *
   * @author Jessenia Piloso <jpiloso@telconet.ec>
   * @version 1.2 15-03-2023 - Se cambio el procedimiento para insertar el Query de consulta de resumen de corte masivo de insert_error a insert_log .
   *
   *
   * @param  Pcl_JsonFiltrosBusqueda    IN CLOB Json con los filtros para la consulta
   * @param  Pv_Status                  OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error
   * @param  Prf_Registros              OUT SYS_REFCURSOR Cursor que retorna la información de conteo
   *
   */
  PROCEDURE P_GET_RESUMEN_CORTE_MASIVO(
    Pcl_JsonFiltrosBusqueda   IN CLOB,
    Pv_Status                 OUT VARCHAR2,
    Pv_MsjError               OUT VARCHAR2,
    Prf_Registros             OUT SYS_REFCURSOR);

  /**
   * P_VERIFICA_TECNOLOGIA_DB
   * Procedimiento que verifica si la tecnología está permitida para los dual band
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 15-09-2020
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 31-03-2021 Se modifica función para permitir buscar los modelos por tipo de ont y no sólo los modelos Wifi Dual Band,
   *                         así como los modelos de extenders permitidos para cada uno
   *
   * @param  Pv_MarcaOlt                    IN VARCHAR2 Marca del olt
   * @param  Pv_ModeloOlt                   IN VARCHAR2 Modelo del olt
   * @param  Pv_TipoOnt                     IN VARCHAR2 Tipo de ont
   * @param  Pn_IdServicioInternet          IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id del servicio de Internet
   * @param  Pv_Status                      OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError                    OUT VARCHAR2 Mensaje de error
   * @param  Pv_ModelosEquiposOntXTipoOnt   OUT VARCHAR2 Modelos de onts que no son Wifi Dual Band y que permiten conectar un extender
   * @param  Pv_ModelosEquiposEdbXTipoOnt   OUT VARCHAR2 Modelos de extenders que están conectados a onts que no son Wifi Dual Band
   * @param  Pv_ModelosEquiposWdb           OUT VARCHAR2 Modelos de equipos Wifi Dual Band
   * @param  Pv_ModelosEquiposEdb           OUT VARCHAR2 Mensaje de equipos Extender Dual Band
   *
   */
  PROCEDURE P_VERIFICA_TECNOLOGIA_DB(
    Pv_MarcaOlt                     IN VARCHAR2,
    Pv_ModeloOlt                    IN VARCHAR2,
    Pv_TipoOnt                      IN VARCHAR2,
    Pn_IdServicioInternet           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pv_Status                       OUT VARCHAR2,
    Pv_MsjError                     OUT VARCHAR2,
    Pv_ModelosEquiposOntXTipoOnt    OUT VARCHAR2,
    Pv_ModelosEquiposEdbXTipoOnt    OUT VARCHAR2,
    Pv_ModelosEquiposWdb            OUT VARCHAR2,
    Pv_ModelosEquiposEdb            OUT VARCHAR2);

  /**
   * P_VERIFICA_EQUIPO_ENLAZADO
   * Procedimiento que verifica si un equipo está enlazado o no
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 15-09-2020
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 31-03-2021 Se modifica función para permitir buscar el equipo enlazado en caso de ser V5 y se agrega el parámetro 
   *                         Pv_TieneAlgunEquipoEnlazado para saber si existe algún equipo del cliente conectado en el servicio
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.2 26-01-2022 Se modifica función para permitir buscar los tipos de equipos parametrizados, ya sea WIFI DUAL BAND, EXTENDER DUAL BAND,
   *                         ONT V5 y ONT ZTE PARA EXTENDER
   *
   * @param  Pn_IdServicioInternet      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id del servicio de Internet
   * @param  Pn_IdInterfaceElementoIni  IN NUMBER Id de la interface del elemento inicial para realizar búsqueda de enlace
   * @param  Pv_TipoEquipoABuscar       IN VARCHAR2 Tipo de equipo a buscar
   * @param  Pv_ModeloEquipoABuscar     IN VARCHAR2 Modelo de equipo a buscar
   * @param  Pv_ProcesoEjecutante       IN VARCHAR2 Tipo de proceso que ejecuta
   * @param  Pv_Status                  OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error
   * @param  Pv_InfoEquipoEncontrado    OUT VARCHAR2 Información del equipo encontrado
   * @param  Pcl_TrazaElementos         OUT CLOB Traza de los elementos
   *
   */
  PROCEDURE P_VERIFICA_EQUIPO_ENLAZADO(
    Pn_IdServicioInternet         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdInterfaceElementoIni     IN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE,
    Pv_TipoEquipoABuscar          IN VARCHAR2,
    Pv_ModeloEquipoABuscar        IN VARCHAR2,
    Pv_ProcesoEjecutante          IN VARCHAR2,
    Pv_Status                     OUT VARCHAR2,
    Pv_MsjError                   OUT VARCHAR2,
    Pv_TieneAlgunEquipoEnlazado   OUT VARCHAR2,
    Pv_InfoEquipoEncontrado       OUT VARCHAR2,
    Pcl_TrazaElementos            OUT CLOB);

  
  /**
   * P_WS_GET_CONSULTA_SUBSCRIBER
   * Procedimiento de consultas por login de usuario con servicios de kaspersky
   * 
   * 
   * @param Pv_Login    		            IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE login usuario
   * @param Pv_Observacion              IN VARCHAR2 login
   * @param Pv_Status                   OUT VARCHAR2 Status de la ejecución del procedimiento
   * @param Pv_MsjError                 OUT VARCHAR2 Mensaje de error de la ejecución del procedimiento
   * 
   * @author Kevin Ortiz <kcortiz@telconet.ec>
   * @version 1.0 27-08-2020
   *
   */
    PROCEDURE P_WS_GET_CONSULTA_SUBSCRIBER(Pv_Login    IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                Prf_Result  OUT Lrf_Result,
                                Pv_Status   OUT VARCHAR2,
                                Pv_Mensaje  OUT VARCHAR2);
                                
  /**
   * P_WS_PUT_SUBSCRIBER
   * Procedimiento de cambio de estado de productos kaspersky a través de suscriber_id
   * 
   * 
   * @param Pv_Login    		            IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE estado 
   * @param Pv_Observacion              IN VARCHAR2 ID_SUBSCRIBER
   * @param Pv_Status                   OUT VARCHAR2 Status de la ejecución del procedimiento
   * @param Pv_MsjError                 OUT VARCHAR2 Mensaje de error de la ejecución del procedimiento
   * 
   * @author Kevin Ortiz <kcortiz@telconet.ec>
   * @version 1.0 27-08-2020
   *
   */
                               
    PROCEDURE P_WS_PUT_SUBSCRIBER(Pn_ID_SUBSCRIBER  IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                  Pv_Origen_Act     IN  VARCHAR2,
                                  Pv_User           IN  VARCHAR2,                
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2);

  /**
   * F_GET_ULT_SERV_ADIC_X_PUNTO
   * Función que obtiene un servicio adicional de acuerdo a los parámetros enviados
   *
   * @param  Fn_IdPunto             IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE Id del punto
   * @param  Fv_NombreTecnicoProd   IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE Nombre técnico del producto a verificar en el punto
   * @param  Fv_EstadoServicio      IN VARCHAR2 Estado del servicio
   * @param  Fv_ProcesoEjecutante   IN VARCHAR2 Nombre del proceso que invoca la función
   * @return OUT DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 13-01-2021
   *
   */
  FUNCTION F_GET_ULT_SERV_ADIC_X_PUNTO(
    Fn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_NombreTecnicoProd    IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fv_EstadoServicio       IN VARCHAR2,
    Fv_ProcesoEjecutante    IN VARCHAR2)
  RETURN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;

  /**
   * P_GET_REGISTRO_SPC
   * Función que obtiene un servicio adicional de acuerdo a los parámetros enviados
   *
   * @param  Pn_IdSpc                       IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT%TYPE Id del registro
   * @param  Pn_IdServicio                  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Id del servicio
   * @param  Pv_DescripcionCaracteristica   IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE Descripción de la característica
   * @param  Pv_ValorSpc                    IN DB_COMERCIAL.ADMI_CARACTERISTICA.VALOR%TYPE Valor de la característica asociada al servicio
   * @param  Pv_EstadoSpc                   IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO%TYPE Estado de la característica asociada al servicio
   * @param  Pv_OrdenarDescPorIdSpc         IN VARCHAR2 'SI' o 'NO' se ordena descendentemente por el campo ID_SERVICIO_PROD_CARACT
   * @param  Pv_Status                      OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                    OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pr_RegistroSpc                 OUT VARCHAR2 Registro de la INFO_SERVICIO_PROD_CARACT
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 18-01-2021
   *
   */
  PROCEDURE P_GET_REGISTRO_SPC(
    Pn_IdSpc                      IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT%TYPE,
    Pn_IdServicio                 IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pv_DescripcionCaracteristica  IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_ValorSpc                   IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Pv_EstadoSpc                  IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO%TYPE,
    Pv_OrdenarDescPorIdSpc        IN VARCHAR2,
    Pv_Status                     OUT VARCHAR2,
    Pv_MsjError                   OUT VARCHAR2,
    Pr_RegistroSpc                OUT DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE);

  /**
     *
     *  Documentación para el procedimiento P_ROOLBACK_TRASLADO_SERVICIO.
     *  Metodo encargado de realizar roolback para el proceso de traslado de servicios
     * @param Pcl_Request    IN   CLOB Recibe json request
     * [
     *   listadoServicios    := listado de servicios del punto de origen,
     *   intIdPuntoCliente   := id del punto de destino,
     *   intIdPuntoOrigen    := id del punto de origen,
     *   strIpCreacion       := ip de creación
     *   strUsuarioCreacion  := usuario de creación
     *
     * ]
     *
     * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
     * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
     *
     * @author Ivan Mata <imata@telconet.ec>
     * @version 1.0 12-03-2021
     *
     */
    PROCEDURE P_ROLLBACK_TRASLADO_SERVICIO(Pcl_Request  IN  CLOB,
                                           Pv_Status    OUT VARCHAR2,
                                           Pv_Mensaje   OUT VARCHAR2);

   /**
   * F_GET_ID_DET_SOL_CARACT_VALIDA
   * Función que retorna el id del detalle solicitud característica
   *
   * @param  Fn_IdSolicitud             IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE Recibe el id de la solicitud
   * @param  Fn_IdServicio              IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Recibe el id del servicio
   * @param  Fv_CampoBusqueda           IN VARCHAR2 Nombre del campo por el cual se va a realizar la búsqueda
   * @param  Fv_DescripcionCaract       IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE Descripción de la característica
   * @param  Fv_ValorDetSolCaract       IN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.VALOR%TYPE Valor del detalle solicitud característica
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 14-04-2021
   *
   */
  FUNCTION F_GET_ID_DET_SOL_CARACT_VALIDA(
    Fn_IdSolicitud              IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    Fn_IdServicio               IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_CampoBusqueda            IN VARCHAR2,
    Fv_DescripcionCaract        IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Fv_ValorDetSolCaract        IN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.VALOR%TYPE)
  RETURN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE;

   /**
   * P_GET_INFO_GESTION_SIMULTANEA
   * Procedimiento que retorna el listado de puntos asociados a un plan de Internet en un determinado OLT
   *
   * @param  Pn_IdSolicitud                 IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD Recibe el id de la solicitud a gestionarse
   * @param  Pv_ParamProdGestionSimultanea  IN VARCHAR2 Parametro por el cual se filtrará los productos
   * @param  Pv_OpcionGestionSimultanea     IN VARCHAR2 Opción desde la que se invoca al procedimiento
   * @param  Pv_Status                      OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MsjError                    OUT VARCHAR2 Mensaje de error
   * @param  Prf_RegistrosGestionSimultanea OUT SYS_REFCURSOR Cursor que retorna el listado de servicios
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 08-04-2021
   *
   * Costo = 39
   */
  PROCEDURE P_GET_INFO_GESTION_SIMULTANEA(
    Pn_IdSolicitud                  IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    Pv_ParamProdGestionSimultanea   IN VARCHAR2,
    Pv_OpcionGestionSimultanea      IN VARCHAR2,
    Pv_Status                       OUT VARCHAR2,
    Pv_MsjError                     OUT VARCHAR2,
    Prf_RegistrosGestionSimultanea  OUT SYS_REFCURSOR);

  /**
   * P_GET_INFOCLIENTE_INTERNET_WS
   * Función que obtiene la información de cliente y el servicio de Internet de acuerdo a los parámetros enviados en el json
   *
   * @param  Pcl_JsonFiltrosBusqueda    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status                  OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Prf_Registros              OUT SYS_REFCURSOR Cursor con los registros de la consulta
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 04-06-2021
   *
   * @author Jonathan Burgos <jsburgos@telconet.ec>
   * @version 1.0 13-04-2023 Cambio en consulta dinamica para poder usar USING y anidar las variables de la consulta.
   *                         Se agrega validacion con parametro de filtro maximo para permitir solo un filtro en cada request siempre y cuando
   *                         se cambie el valor del parametro Ln_NumParamsMaximo mayor a 1.
   *
   */
  PROCEDURE P_GET_INFOCLIENTE_INTERNET_WS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_Registros           OUT SYS_REFCURSOR);

  /**
   * P_GET_INFOCLIENTE_PUNTO_WS
   * Función que obtiene la información del punto de acuerdo a los parámetros enviados en el json
   *
   * @param  Pcl_JsonFiltrosBusqueda    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status                  OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Prf_Registros              OUT SYS_REFCURSOR Cursor con los registros de la consulta
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 04-06-2021
   *
   */
  PROCEDURE P_GET_INFOCLIENTE_PUNTO_WS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_Registros           OUT SYS_REFCURSOR);

  /**
   * P_GET_INFOCLIENTE_SERVICIO_WS
   * Función que obtiene la información de los servicios de acuerdo a los parámetros enviados en el json
   *
   * @param  Pcl_JsonFiltrosBusqueda    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status                  OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Prf_Registros              OUT SYS_REFCURSOR Cursor con los registros de la consulta
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 04-06-2021
   *
   */
  PROCEDURE P_GET_INFOCLIENTE_SERVICIO_WS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_Registros           OUT SYS_REFCURSOR);

  /**
   * P_GET_RESPUESTA_INFOCLIENTE_WS
   * Función que obtiene la respuesta en formato json de la consulta de la información de cliente, puntos y servicios en estado Activo e In-Corte
   *
   * @param  Pcl_JsonFiltrosBusqueda    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status                  OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pcl_JsonRespuesta          OUT CLOB Respuesta en formato json de la consulta
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 04-06-2021
   *
   */
  PROCEDURE P_GET_RESPUESTA_INFOCLIENTE_WS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pcl_JsonRespuesta       OUT CLOB);

  /**
   * P_GET_INFOCLIENTE_INTERNET_ACS
   * Función que obtiene la información de cliente, el servicio de Internet y demás información de acuerdo a los parámetros enviados en el json
   *
   * @param  Pcl_JsonFiltrosBusqueda    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status                  OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Prf_Registros              OUT SYS_REFCURSOR Cursor con los registros de la consulta
   *
   * @author Jesús Bozada <jbozada@telconet.ec>
   * @version 1.0 21-08-2021
   *
   * @author Jesús Bozada <jbozada@telconet.ec>
   * @version 1.1 24-10-2021   Se agrega filtrado por empresa y se retornan nuevos campos de información solicitados
   *
   * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
   * @version 1.2 28-02-2023   Se agrega filtrado por empresa ECUANET para la busqueda de parametros.
   *
   */
  PROCEDURE P_GET_INFOCLIENTE_INTERNET_ACS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_Registros           OUT SYS_REFCURSOR);

    /**
   * P_GET_INFOCLIENTE_ACS
   * Función que obtiene la información de cliente para la implementación de la nueva plataforma unificada ACS
   *
   * @param  Pcl_JsonFiltrosBusqueda    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status                  OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_MsjError                OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pcl_JsonRespuesta          OUT CLOB Respuesta en formato json de la consulta
   *
   * @author Jesús Bozada <jbozada@telconet.ec>
   * @version 1.0 20-08-2021
   *
   * @author Jesús Bozada <jbozada@telconet.ec>
   * @version 1.1 24-10-2021   Se agrega filtrado por empresa y se retornan nuevos campos de información solicitados
   *
   */
  PROCEDURE P_GET_INFOCLIENTE_ACS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pcl_JsonRespuesta       OUT CLOB);

  END
  TECNK_SERVICIOS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.TECNK_SERVICIOS
AS

/**
    * COMP_LISTADO_SERVICIO
    * @author Jesus Bozada <jbozada@telconet.ec>
    * @version 1.1 03-06-2016    Se agrega validacion de empresaCod a valores que deben ser recuperar clientes TN (vrf,vlan,as_privado)
    *
    * @author Jesus Bozada <jbozada@telconet.ec>
    * @version 1.2 20-02-2017    Se agrega recuperación de solicitud para agregar equipo SmartWifi
    *
    * @author Francisco Adum <fadum@netlife.net.ec>
    * @version 1.3 06-07-2017    Se agrega recuperacion de caracteristica [ipv4] que indica si el cliente tiene ipv4 publica.
    *
    * @author Lizbeth Cruz <mlcruz@telconet.ec>
    * @version 1.4 08-12-2017    Se realizan modificaciones para flujo de producto Internet Small Business
    *
    * @since 1.1
    *
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.4 21-01-2018    Se valida el campo tipo orden si es C se setea el campo como un tipo Orden: Cambio Tipo Medio.
    *
    * @author Lizbeth Cruz <mlcruz@telconet.ec>
    * @version 1.5 25-04-2018    Se realizan modificaciones para flujo de producto Ip Adicional para el Internet Small Business
    *
    * @author Jesús Bozada <jbozada@telconet.ec>
    * @version 1.6 05-11-2018    Se realizan modificaciones para flujo de empresa TNP
    *
    * @author Lizbeth Cruz <mlcruz@telconet.ec>
    * @version 1.7 08-02-2019    Se realizan modificaciones para flujo de producto TelcoHome
    *
    * @author Lizbeth Cruz <mlcruz@telconet.ec>
    * @version 1.8 09-07-2019    Se agrega la consulta de la solicitud de migración en estado PendienteExtender para servicios 
    *                            que necesiten agregar el equipo Extender Dual Band
    *
    * @author David Leon <mdleon@telconet.ec>
    * @version 1.9 05-08-2019    Se realizan modificaciones para el producto L3MPLS SDWAN
    *
    * @author Felix Caicedo <facaicedo@telconet.ec>
    * @version 1.10 05-03-2020   Se realizan modificaciones para la busqueda por producto, tipo orden y por tipo de medio.
    *                            Se cambio el tipo de dato de la variable Pn_TipoMedioBusquedaId de NUMBER a VARCHAR2
    *
    * @author Lizbeth Cruz <mlcruz@telconet.ec>
    * @version 1.11 27-04-2020   Se envía el parámetro del id del producto en lugar del nombre técnico a la función F_GET_VALIDACION_IP_FIJA_TN
    *
    * @author Lizbeth Cruz <mlcruz@telconet.ec>
    * @version 1.12 12-05-2020   Se agrega la obtención de la marca del elemento para validar olts por marca y no por modelo por cambios de zte
    *
    * @author Jeampier Carriel <jacarriel@telconet.ec>
    * @version 1.13 2021-12-15 - Se agrega variable Pv_ServiciosFTTxTN para filtro para Servicios FTTx de Clientes Telconet.
    *
    * @author Manuel Carpio <mcarpio@telconet.ec>
    * @version 1.13 2021-12-15 - Se agrega los servicios DATOS SAFECITY a la consulta de servicios para ingreso de solicitud de cambio linea PON.
    *
    * @param  NUMBER        Pn_PlanBusquedaId              
    * @param  NUMBER        Pn_ProductoBusquedaId         
    * @param  VARCHAR2      Pv_LoginBusqueda            
    * @param  VARCHAR2      Pv_TipoServicioBusqueda     
    * @param  NUMBER        Pn_PuntoBusquedaId            
    * @param  VARCHAR2      Pv_EstadoBusqueda           
    * @param  VARCHAR2      Pn_TipoMedioBusquedaId         
    * @param  NUMBER        Pn_ElementoBusquedaId          
    * @param  NUMBER        Pn_InterfaceElementoBusquedaId 
    * @param  NUMBER        Pn_start          
    * @param  VARCHAR2      Pv_codEmpresa   
    * @param  VARCHAR2      Pn_servicios
    * @param  VARCHAR2      Pv_ServiciosFTTxTN      
    * @param  NUMBER        Pn_TotalRegistros   OUT
    * @param  VARCHAR2      Pv_MensaError       OUT
    * @param  Lrf_Result    Prf_Result          OUT  
    *
    * @since 1.0
    */
PROCEDURE COMP_LISTADO_SERVICIO(
    Pn_PlanBusquedaId              IN NUMBER,
    Pn_ProductoBusquedaId          IN NUMBER,
    Pv_LoginBusqueda               IN VARCHAR2,
    Pv_LoginForma                  IN VARCHAR2,
    Pv_TipoServicioBusqueda        IN VARCHAR2,
    Pn_PuntoBusquedaId             IN NUMBER,
    Pv_EstadoBusqueda              IN VARCHAR2,
    Pn_TipoMedioBusquedaId         IN VARCHAR2,
    Pn_ElementoBusquedaId          IN NUMBER,
    Pn_InterfaceElementoBusquedaId IN NUMBER,
    Pn_start                       IN NUMBER,
    Pv_codEmpresa                  IN VARCHAR2,
    Pn_servicios                   IN VARCHAR2,
    Pv_ServiciosFTTxTN             IN VARCHAR2,
    Pn_TotalRegistros OUT NUMBER,
    Pv_MensaError     OUT VARCHAR2,
    Prf_Result        OUT Lrf_Result )
IS
  --
  Lrf_Count Lrf_Result;
  Lrf_CountRefCursor Lt_Result;
  Lv_Query CLOB;
  --
  Lv_QueryCount CLOB;
  --
  Lv_QueryAllColumns CLOB;
  --
  Lv_LimitAllColumns CLOB;
  --
  Lv_LimitCount CLOB;
  --
  Ln_Counter NUMBER := 0;
  --
BEGIN
  --
  Lv_QueryCount      := 'SELECT SERVICIO.ID_SERVICIO TOTAL ';
  Lv_QueryAllColumns :=
  'SELECT * FROM (SELECT ROWNUM ID_QUERY,                      
SERVICIO.ID_SERVICIO,                      
SERVICIO.PUNTO_ID,                      
SERVICIO.ESTADO,                      
SERVICIO.TIPO_ORDEN, 
SERVICIO.LOGIN_AUX,
SERVICIO.DESCRIPCION_PRESENTA_FACTURA,
TECNICO.TIPO_ENLACE,
CASE SERVICIO.TIPO_ORDEN                         
WHEN ''N'' THEN                           
''Nueva''                         
WHEN ''R'' THEN                           
''Reubicacion''                         
WHEN ''T''  THEN                           
''Traslado''
WHEN ''C''  THEN 
''Cambio Tipo Medio''                         
ELSE                           
NULL                       
END TIPO_ORDEN_COMPLETO,                      
SERVICIO.CANTIDAD CANTIDAD_REAL,                      
PUNTO.LOGIN,
PUNTO.PUNTO_COBERTURA_ID,
ORDEN.NUMERO_ORDEN_TRABAJO,                      
PROD.ID_PRODUCTO,                      
PROD.NOMBRE_TECNICO,                      
PROD.DESCRIPCION_PRODUCTO,     
PROD1.REQUIERE_INFO_TECNICA,                 
PROD1.ID_PRODUCTO AS ID_PRODUCTO1,                      
PROD1.DESCRIPCION_PRODUCTO AS DESCRIPCION_PRODUCTO1,                      
PROD1.NOMBRE_TECNICO AS NOMBRE_TECNICO1,                      
EG.COD_EMPRESA,                      
EG.PREFIJO,              
PER.ID_PERSONA_ROL AS ID_PERSONA_EMPRESA_ROL,
PERSONA.ID_PERSONA,                      
PERSONA.NOMBRES,                      
PERSONA.APELLIDOS,                      
PERSONA.RAZON_SOCIAL,                      
CASE                         
WHEN PERSONA.RAZON_SOCIAL IS NOT NULL THEN                         
PERSONA.RAZON_SOCIAL                          
ELSE                         
PERSONA.NOMBRES || '' '' || PERSONA.APELLIDOS                      
END NOMBRE_COMPLETO,                      
PLANC.ID_PLAN,                      
PLANC.NOMBRE_PLAN,                      
ELEMENTO.ID_ELEMENTO,  
CASE PROD.NOMBRE_TECNICO 
    WHEN ''INTERNET'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
    WHEN ''L3MPLS'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
	WHEN ''L3MPLS SDWAN'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
    WHEN ''DATOS SAFECITY'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
    ELSE                        
    ''''                      
END NOMBRE_MODELO_ELEMENTO,
CASE PROD1.NOMBRE_TECNICO 
    WHEN ''INTERNET'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
    WHEN ''L3MPLS'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
	WHEN ''L3MPLS SDWAN'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO	
    WHEN ''INTERNET SMALL BUSINESS'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
    WHEN ''TELCOHOME'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
    WHEN ''DATOS SAFECITY'' THEN                         
        MODELO.NOMBRE_MODELO_ELEMENTO
    ELSE                        
    ''''                      
END NOMBRE_MODELO_ELEMENTO_PROD,
MARCA.NOMBRE_MARCA_ELEMENTO,
ELEMENTO.NOMBRE_ELEMENTO ,                      
IP.IP,                      
PUERTO.NOMBRE_INTERFACE_ELEMENTO,                      
PUERTO.ID_INTERFACE_ELEMENTO,                      
UM.NOMBRE_TIPO_MEDIO,         
UM.CODIGO_TIPO_MEDIO,             
TECNK_SERVICIOS.GET_ID_DET_SOLICITUD(SERVICIO.ID_SERVICIO, ''SOLICITUD CAMBIO EQUIPO'', ''SOLICITUD CAMBIO DE MODEM INMEDIATO'', ''AsignadoTarea'') SOLICITUD_CAMBIO_ELEMENTO,                      
TECNK_SERVICIOS.GET_ID_DET_SOLICITUD(SERVICIO.ID_SERVICIO, ''SOLICITUD CAMBIO LINEA PON'', NULL, ''Aprobada'') SOLICITUD_CAMBIO_LINEA_PON,
TECNK_SERVICIOS.GET_ID_DET_SOLICITUD(SERVICIO.ID_SERVICIO, ''SOLICITUD MIGRACION'', NULL, ''Asignada'') SOLICITUD_MIGRACION,
TECNK_SERVICIOS.GET_ID_DET_SOLICITUD(SERVICIO.ID_SERVICIO, ''SOLICITUD MIGRACION'', NULL, ''PendienteExtender'') SOLICITUD_MIGRACION_EXTENDER,                      
TECNK_SERVICIOS.GET_ID_DET_SOLICITUD(SERVICIO.ID_SERVICIO, ''SOLICITUD AGREGAR EQUIPO'', NULL, ''Asignada'') SOLICITUD_AGREGAR_EQUIPO,                      
TECNK_SERVICIOS.GET_ID_DET_SOLICITUD(SERVICIO.ID_SERVICIO, ''SOLICITUD PLANIFICACION'', NULL, ''Asignada'') SOLICITUD_PLANIFICACION,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''CAPACIDAD1'') CAPACIDAD1,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''CAPACIDAD2'') CAPACIDAD2,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''PERFIL'') PERFIL,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC'') MAC,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''CAPACIDAD-INT1'') CAPACIDAD_INT1,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''CAPACIDAD-INT2'') CAPACIDAD_INT2,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''CAPACIDAD-PROM1'') CAPACIDAD_PROM1,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''CAPACIDAD-PROM2'') CAPACIDAD_PROM2,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''NUMERO PC'') NUMERO_PC,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC WIFI'') MAC_WIFI,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''USUARIO'') USUARIO,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''DOMINIO'') DOMINIO,                      
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MIGRADO'') MIGRADO,  
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''IPV4'') IPV4,
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''SERVICIO_HEREDADO'') SERVICIO_HEREDADO,
TECNK_SERVICIOS.GET_RD_ID(SERVICIO.ID_SERVICIO) RD_ID,  
CASE EG.COD_EMPRESA 
    WHEN ''10'' THEN                         
        TECNK_SERVICIOS.GET_VALOR_DETALLE_ELEMENTO(TECNK_SERVICIOS.GET_VALOR_PER_EMP_ROL_CAR(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''VLAN''),PROD1.NOMBRE_TECNICO,0,'''')) 
    ELSE                        
    ''''                      
END VLAN,
CASE EG.COD_EMPRESA 
    WHEN ''10'' THEN                         
        TECNK_SERVICIOS.GET_VALOR_DETALLE_ELEMENTO(TECNK_SERVICIOS.GET_VALOR_PER_EMP_ROL_CAR(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''VLAN_LAN''),PROD1.NOMBRE_TECNICO,NULL,''VLAN_LAN'')) 
    ELSE                        
    ''''                      
END VLAN_LAN,
CASE EG.COD_EMPRESA 
    WHEN ''10'' THEN                         
        TECNK_SERVICIOS.GET_VALOR_DETALLE_ELEMENTO(TECNK_SERVICIOS.GET_VALOR_PER_EMP_ROL_CAR(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''VLAN_WAN''),PROD1.NOMBRE_TECNICO,NULL,''VLAN_WAN'')) 
    ELSE                        
    ''''                      
END VLAN_WAN,
CASE EG.COD_EMPRESA 
    WHEN ''10'' THEN                         
        TECNK_SERVICIOS.GET_VALOR_PER_EMP_ROL_CAR(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''VRF''),PROD1.NOMBRE_TECNICO,0,'''')
    ELSE                        
    ''''                      
END VRF,
CASE EG.COD_EMPRESA 
    WHEN ''10'' THEN                         
        TECNK_SERVICIOS.GET_VALOR_PER_EMP_ROL_CAR(0,PROD1.NOMBRE_TECNICO,PER.ID_PERSONA_ROL,''AS_PRIVADO'')  
    ELSE                        
    ''''                      
END AS_PRIVADO,
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''PROTOCOLO_ENRUTAMIENTO'')  PROTOCOLO,
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''DEFAULT_GATEWAY'') DEFAULT_GATEWAY,    
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''CACTI'') CACTI,
TECNK_SERVICIOS.GET_IP_SERVICIO(SERVICIO.ID_SERVICIO) IP_SERVICIO,
TECNK_SERVICIOS.GET_DATO_SUBRED_SERVICIO(SERVICIO.ID_SERVICIO,''SUBRED'') SUBRED_SERVICIO,
TECNK_SERVICIOS.GET_DATO_SUBRED_SERVICIO(SERVICIO.ID_SERVICIO,''GATEWAY'') GW_SUBRED_SERVICIO,
TECNK_SERVICIOS.GET_DATO_SUBRED_SERVICIO(SERVICIO.ID_SERVICIO,''MASCARA'') MASCARA_SUBRED_SERVICIO,
TECNK_SERVICIOS.GET_DATO_SUBRED_SERVICIO(SERVICIO.ID_SERVICIO,''TIPO'') TIPO_SUBRED,
TECNK_SERVICIOS.GET_IP_RESERVADA(SERVICIO.ID_SERVICIO ) IP_RESERVADA,     
TECNK_SERVICIOS.GET_FLUJO_TECNICO(EG.PREFIJO, UM.CODIGO_TIPO_MEDIO,PROD.REQUIERE_INFO_TECNICA, PROD1.REQUIERE_INFO_TECNICA) FLUJO_TECNICO,                      
TECNK_SERVICIOS.GET_BOTONES(PLANC.ID_PLAN,PROD.NOMBRE_TECNICO,PROD1.NOMBRE_TECNICO) BOTONES,                      
TECNK_SERVICIOS.GET_VALIDACION_MAC_WIFI(SERVICIO.ID_SERVICIO, PROD.NOMBRE_TECNICO) REQUIERE_MAC,                      
TECNK_SERVICIOS.GET_ESTADO_SOLICITUD_PLANIFICA(SERVICIO.ID_SERVICIO, ''SOLICITUD PLANIFICACION'') ESTADO_SOLICITUD_PLANIFICACION, 
TECNK_SERVICIOS.GET_ESTADO_SOLICITUD_PLANIFICA(SERVICIO.ID_SERVICIO, ''SOLICITUD MIGRACION TUNEL IP A L3MPLS'') ESTADO_SOLICITUD_MIGRA_TUNEL,
TECNK_SERVICIOS.GET_ESTADO_SOLICITUD_PLANIFICA(SERVICIO.ID_SERVICIO, ''SOLICITUD MIGRACION ANILLO'') ESTADO_SOLICITUD_MIGRA_ANI,
TECNK_SERVICIOS.GET_ESTADO_SOLICITUD_PLANIFICA(SERVICIO.ID_SERVICIO, ''SOLICITUD CAMBIO ULTIMA MILLA'') ESTADO_SOLICITUD_CAMBIO_UM,
CASE EG.COD_EMPRESA 
    WHEN ''10'' THEN
        TECNK_SERVICIOS.F_GET_VALIDACION_IP_FIJA_TN(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                    SERVICIO.ID_SERVICIO,
                                                    SERVICIO.PUNTO_ID, 
                                                    ''TIENE IP FIJA'', 
                                                    SERVICIO.ESTADO,
                                                    PROD1.ID_PRODUCTO,
                                                    EG.COD_EMPRESA)   
    WHEN ''26'' THEN
        TECNK_SERVICIOS.F_GET_VALIDACION_IP_FIJA_TN(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                    SERVICIO.ID_SERVICIO,
                                                    SERVICIO.PUNTO_ID, 
                                                    ''TIENE IP FIJA'', 
                                                    SERVICIO.ESTADO,
                                                    PROD1.ID_PRODUCTO,
                                                    EG.COD_EMPRESA)   
    ELSE                        
        TECNK_SERVICIOS.GET_VALIDACION_IP_FIJA( TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                SERVICIO.PUNTO_ID, 
                                                ''TIENE IP FIJA'', 
                                                SERVICIO.ESTADO)                   
END TIENE_IP_FIJA,
CASE EG.COD_EMPRESA 
    WHEN ''10'' THEN
        TECNK_SERVICIOS.F_GET_VALIDACION_IP_FIJA_TN(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                    SERVICIO.ID_SERVICIO,
                                                    SERVICIO.PUNTO_ID, 
                                                    ''MAC IP FIJA'',
                                                    SERVICIO.ESTADO,
                                                    PROD1.ID_PRODUCTO,
                                                    EG.COD_EMPRESA)     
    WHEN ''26'' THEN
        TECNK_SERVICIOS.F_GET_VALIDACION_IP_FIJA_TN(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                    SERVICIO.ID_SERVICIO,
                                                    SERVICIO.PUNTO_ID, 
                                                    ''MAC IP FIJA'',
                                                    SERVICIO.ESTADO,
                                                    PROD1.ID_PRODUCTO,
                                                    EG.COD_EMPRESA)                     
    ELSE                        
        TECNK_SERVICIOS.GET_VALIDACION_IP_FIJA( TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                SERVICIO.PUNTO_ID, 
                                                ''MAC IP FIJA'', 
                                                SERVICIO.ESTADO)                   
END MAC_IP_FIJA,
CASE EG.COD_EMPRESA 
    WHEN ''10'' THEN
        TECNK_SERVICIOS.F_GET_VALIDACION_IP_FIJA_TN(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                    SERVICIO.ID_SERVICIO,
                                                    SERVICIO.PUNTO_ID, 
                                                    ''REF SERVICIO'',
                                                    SERVICIO.ESTADO,
                                                    PROD1.ID_PRODUCTO,
                                                    EG.COD_EMPRESA)
    WHEN ''26'' THEN
        TECNK_SERVICIOS.F_GET_VALIDACION_IP_FIJA_TN(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                    SERVICIO.ID_SERVICIO,
                                                    SERVICIO.PUNTO_ID, 
                                                    ''REF SERVICIO'',
                                                    SERVICIO.ESTADO,
                                                    PROD1.ID_PRODUCTO,
                                                    EG.COD_EMPRESA)     
    ELSE                        
        TECNK_SERVICIOS.GET_VALIDACION_IP_FIJA( TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC''), 
                                                SERVICIO.PUNTO_ID, 
                                                ''REF SERVICIO'', 
                                                SERVICIO.ESTADO)
END REF_SERVICIO,                           
TECNK_SERVICIOS.GET_CANTIDAD_USADA_PRODUCTO(PROD.NOMBRE_TECNICO, PROD1.NOMBRE_TECNICO,SERVICIO.CANTIDAD,SERVICIO.ID_SERVICIO) CANTIDAD,                      
TECNK_SERVICIOS.GET_ACTA_ENCUESTA(''ACTA'', ''TECNICO'', SERVICIO.ID_SERVICIO,TECNK_SERVICIOS.GET_ID_DETALLE_ULTIMA_SOL(SERVICIO.ID_SERVICIO)) TIENE_ACTA,
TECNK_SERVICIOS.GET_ACTA_ENCUESTA(''ENC'', ''TECNICO'', SERVICIO.ID_SERVICIO,TECNK_SERVICIOS.GET_ID_DETALLE_ULTIMA_SOL(SERVICIO.ID_SERVICIO)) TIENE_ENCUESTA,
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''ES_BACKUP'') REF_BACKUP,
TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''FIREWALL_DC'') FIREWALL_DC ';

Lv_Query :=
  'FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO           
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
AND (PLAND.ESTADO) = (PLANC.ESTADO) ) ) '
  ;
  --
  IF Pv_ServiciosFTTxTN IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND TECNICO.ULTIMA_MILLA_ID in ( ' || Pv_ServiciosFTTxTN || ')';
    --
  ELSE
   	IF Pn_PuntoBusquedaId IS NOT NULL THEN
    --
    	Lv_Query := Lv_Query || ' AND SERVICIO.PUNTO_ID = ' || Pn_PuntoBusquedaId;
    --
  	END IF;
  END IF;
  --
  IF Pn_PuntoBusquedaId IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND SERVICIO.PUNTO_ID = ' || Pn_PuntoBusquedaId;
    --
  END IF;
  --
  IF Pn_ProductoBusquedaId IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND ( ' ||
                '( SERVICIO.PRODUCTO_ID IS NOT NULL AND PROD1.ID_PRODUCTO = ' || Pn_ProductoBusquedaId || ') OR ' || 
                '( SERVICIO.PLAN_ID IS NOT NULL AND PROD.ID_PRODUCTO = ' || Pn_ProductoBusquedaId || ') )';
    --
  END IF;
  --
  IF Pv_LoginBusqueda IS NOT NULL THEN
    --
    IF Pv_LoginForma IS NOT NULL THEN
        IF Pv_LoginForma = 'Igual que' THEN
            Lv_Query := Lv_Query || ' AND PUNTO.LOGIN = ''' || Pv_LoginBusqueda || '''';
        ELSE
            Lv_Query := Lv_Query || ' AND UPPER(PUNTO.LOGIN) LIKE ''' || Pv_LoginBusqueda || '''';
        END IF;
    ELSE
        Lv_Query := Lv_Query || ' AND UPPER(PUNTO.LOGIN) LIKE ''%' || UPPER(Pv_LoginBusqueda) || '%''';
    END IF;
    --
  END IF;
  --
  IF Pv_TipoServicioBusqueda IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND SERVICIO.TIPO_ORDEN = ''' || Pv_TipoServicioBusqueda || '''';
    --
  END IF;
  --
  IF Pn_PlanBusquedaId IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND PLANC.ID_PLAN = ' || Pn_PlanBusquedaId;
    --
  END IF;
  --
  IF Pn_TipoMedioBusquedaId IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND UM.NOMBRE_TIPO_MEDIO = ''' || Pn_TipoMedioBusquedaId || '''';
    --
  END IF;
  --
  IF Pv_EstadoBusqueda IS NOT NULL THEN
    --
    IF UPPER(Pv_EstadoBusqueda) != UPPER('TODOS') THEN
      Lv_Query := Lv_Query || ' AND SERVICIO.ESTADO = ''' || Pv_EstadoBusqueda || '''';
    END IF;
    --
  ELSE
    Lv_Query := Lv_Query || ' AND SERVICIO.ESTADO = SERVICIO.ESTADO ';
  END IF;
  --
  IF Pn_ElementoBusquedaId IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND TECNICO.SERVICIO_ID IN (' || TECNK_SERVICIOS.FNC_GET_SERV_ELE_PTO(Pn_ElementoBusquedaId,Pn_InterfaceElementoBusquedaId) || ')';
    --
  END IF;
  --
  IF Pv_codEmpresa IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND EG.COD_EMPRESA = ' || Pv_codEmpresa;
    --
  END IF;  
  --
  IF Pn_servicios IS NOT NULL THEN
  --
    Lv_Query := Lv_Query || ' AND SERVICIO.ID_SERVICIO IN (' || Pn_servicios || ')';
  --
  END IF;  
  --
  IF Pn_servicios IS NULL THEN
      --
      IF Pn_start          IS NOT NULL THEN
        Lv_LimitAllColumns := ' ) TB WHERE TB.ID_QUERY >= ' || Pn_start ||
        ' AND TB.ID_QUERY <= ' || (Pn_start + 10);
      ELSE
        Lv_LimitAllColumns := ' ) TB ';
      END IF;
  ELSE
  
    Lv_LimitAllColumns := ' ) TB ';
  
  END IF; 
  --
  Lv_QueryAllColumns := Lv_QueryAllColumns || Lv_Query || Lv_LimitAllColumns;
  Lv_QueryCount      := Lv_QueryCount || Lv_Query;
  --
  --
 
  OPEN Prf_Result FOR Lv_QueryAllColumns;
  --
  Pn_TotalRegistros := TECNK_SERVICIOS.GET_COUNT_REFCURSOR(Lv_QueryCount);
EXCEPTION
WHEN OTHERS THEN
  Pv_MensaError := 'ERROR PROCEDURE: ' || SQLERRM;
END COMP_LISTADO_SERVICIO;

--
/*
* Funcion que sirve para obtener el id de cualquier solicitud
* que un servicio pueda tener
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.1 28-08-2015
* @since 1.0
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.2 21-01-2016
* @since 1.1
* @author Felix Caicedo <facaicedo@telconet.ec>
* @version 1.3 03-11-2022 - Se agrega limite para la consulta de las solicitudes por cambio de modem inmediato.
* @since 1.2
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE                    Fn_IdServicio       id del servicio
* @param  ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE    Fv_tipoSolicitud1   tipo de solicitud
* @param  ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE    Fv_tipoSolicitud1   tipo de solicitud
* @param  INFO_DETALLE_SOLICITUD.ESTADO%TYPE                Fv_estadoSolicitud  estado de solicitud que se requiere buscar
* @return INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE  id de la solicitud
*/
FUNCTION GET_ID_DET_SOLICITUD(
    Fn_IdServicio      IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_tipoSolicitud1  IN ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    Fv_tipoSolicitud2  IN ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    Fv_estadoSolicitud IN INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
  RETURN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE
IS
  --
  Ln_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
  --
  Lv_QueryDetalleSolicitud VARCHAR2(1000) := '';
  Lv_QueryLimit            VARCHAR2(100)  := '';
  Lv_EstadoActivo          VARCHAR2(6)    := 'Activo';
  --
BEGIN
  --
  Lv_QueryDetalleSolicitud := 'SELECT IDS.ID_DETALLE_SOLICITUD FROM
                              ADMI_TIPO_SOLICITUD ATP,
                              INFO_DETALLE_SOLICITUD IDS,
                              INFO_SERVICIO ISERV
                              WHERE ISERV.ID_SERVICIO     = IDS.SERVICIO_ID
                              AND ATP.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
                              AND ATP.ESTADO            = :Bv_EstadoActivo
                              AND ISERV.ID_SERVICIO     = :Bn_IdServicio
                              AND IDS.ESTADO            = :Bv_estadoSolicitud ';
  --
  IF Fv_tipoSolicitud1 = 'SOLICITUD CAMBIO DE MODEM INMEDIATO' OR Fv_tipoSolicitud2 = 'SOLICITUD CAMBIO DE MODEM INMEDIATO' THEN
    Lv_QueryLimit := 'AND ROWNUM <= 1';
  END IF;

  IF Fv_tipoSolicitud1 IS NOT NULL AND Fv_tipoSolicitud2 IS NOT NULL THEN
    --
    Lv_QueryDetalleSolicitud := Lv_QueryDetalleSolicitud || ' AND ATP.DESCRIPCION_SOLICITUD IN (:Bv_tipoSolicitud1, :Bv_tipoSolicitud2) ' || Lv_QueryLimit;
    --
    EXECUTE IMMEDIATE Lv_QueryDetalleSolicitud INTO Ln_IdDetalleSolicitud USING Lv_EstadoActivo, Fn_IdServicio, Fv_estadoSolicitud, Fv_tipoSolicitud1, Fv_tipoSolicitud2;
    --
  ELSIF Fv_tipoSolicitud1 IS NOT NULL THEN
    --
    Lv_QueryDetalleSolicitud := Lv_QueryDetalleSolicitud || ' AND ATP.DESCRIPCION_SOLICITUD IN (:Bv_tipoSolicitud1) ' || Lv_QueryLimit;
    --
    EXECUTE IMMEDIATE Lv_QueryDetalleSolicitud INTO Ln_IdDetalleSolicitud USING Lv_EstadoActivo, Fn_IdServicio, Fv_estadoSolicitud, Fv_tipoSolicitud1;
    --
  END IF;
  --
  RETURN Ln_IdDetalleSolicitud;
  --
  EXCEPTION WHEN NO_DATA_FOUND THEN
  --
  RETURN NULL;
  --
  WHEN OTHERS THEN
  --
  RETURN NULL;
  --
END GET_ID_DET_SOLICITUD;
--

/*
* Funcion que sirve para obtener la ip reservada para el servicio en caso de existir
* @author Jesus Bozada <jbozada@telconet.ec>
* @version 1.0 17-04-2015
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE             Fn_IdServicio              id del servicio
* @return DB_INFRAESTRUCTURA.INFO_IP.IPR%TYPE        valor de la ip
*/
FUNCTION GET_IP_RESERVADA(
    Fn_IdServicio           IN INFO_SERVICIO.ID_SERVICIO%TYPE
    )
    RETURN DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE
IS
Lv_Ip VARCHAR2(20) := '';
BEGIN

begin
SELECT
      IP.ip
      INTO Lv_Ip
    FROM
      DB_INFRAESTRUCTURA.INFO_IP IP
    WHERE
      IP.SERVICIO_ID = Fn_IdServicio
    AND IP.ESTADO   = 'Reservada';
 exception
 when others then
 Lv_Ip :='';
  end;
return Lv_Ip;
END GET_IP_RESERVADA;

--
/*
* Funcion que sirve para obtener el valor del servicio producto caracteristica
* de cualquier caracteristica que se necesite
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
*
* @author Felix Caicedo <facaicedo@telconet.ec>
* @version 1.1 02/02/2021 - Obtener las ultimas caracteristicas ingresadas de la CAPACIDAD1 Y CAPACIDAD2 del servicio, cuando este tenga mas de un registro.
*
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE                         Fn_IdServicio              id del servicio
* @param  ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE    Fv_NombreCaracteristica    nombre de la caracteristica
* @return INFO_SERVICIO_PROD_CARACT.VALOR%TYPE                   valor de la caracteristica
*/
--
FUNCTION GET_VALOR_SERVICIO_PROD_CARACT(
    Fn_IdServicio           IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_NombreCaracteristica IN
    ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_getValorServicioProdCaract (Cn_idServicio
    INFO_SERVICIO.ID_SERVICIO%TYPE, Cv_descripcionCaracteristica
    ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  IS
    SELECT
      ISPC.VALOR
    FROM
      INFO_SERVICIO ISERV,
      INFO_SERVICIO_PROD_CARACT ISPC,
      ADMI_PRODUCTO_CARACTERISTICA APC,
      ADMI_PRODUCTO AP,
      ADMI_CARACTERISTICA AC
    WHERE
      ISPC.SERVICIO_ID                   = ISERV.ID_SERVICIO
    AND ISPC.ESTADO                      = 'Activo'
    AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
    AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
    AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
    AND AC.ESTADO                        = 'Activo'
    AND ISERV.ID_SERVICIO                = Cn_idServicio
    AND AC.DESCRIPCION_CARACTERISTICA    = Cv_descripcionCaracteristica
    ORDER BY ISPC.ID_SERVICIO_PROD_CARACT DESC;
  Lv_valorServicioProdCaract INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
  --
BEGIN
  --
  IF C_getValorServicioProdCaract%ISOPEN THEN
    CLOSE C_getValorServicioProdCaract;
  END IF;
  --
  OPEN C_getValorServicioProdCaract(Fn_IdServicio,Fv_NombreCaracteristica);
  --
  FETCH
    C_getValorServicioProdCaract
  INTO
    Lv_valorServicioProdCaract;
  --
  CLOSE C_getValorServicioProdCaract;
  --
  IF Lv_valorServicioProdCaract IS NULL THEN
    Lv_valorServicioProdCaract  := NULL;
  END IF;
  --
  RETURN Lv_valorServicioProdCaract;
END GET_VALOR_SERVICIO_PROD_CARACT;

/**
* GET_VALOR_SERVICIO_PRD_CARACT_MD
*
* Funcion que sirve para obtener el valor del servicio producto caracteristica para procesos de
* cancelaciones masivas y de cualquier caracteristica que se necesite
* @author Jonathan Burgos <jsburgos@telconet.ec>
* @version 1.0 14-11-2022
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE                         Fn_IdServicio              id del servicio
* @param  ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE    Fv_NombreCaracteristica    nombre de la caracteristica
* @return INFO_SERVICIO_PROD_CARACT.VALOR%TYPE                   valor de la caracteristica
*/

FUNCTION GET_VALOR_SERVICIO_CARACT_CM(
    Fn_IdServicio           IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_NombreCaracteristica IN
    ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_getValorServicioProdCaract (Cn_idServicio
    INFO_SERVICIO.ID_SERVICIO%TYPE, Cv_descripcionCaracteristica
    ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  IS
    SELECT VALOR FROM (
        SELECT
          ISPC.VALOR,
          ISPC.ESTADO ISPC_ESTADO,
          AC.ESTADO AC_ESTADO,
          ISPC.USR_ULT_MOD,
          ISPC.FE_ULT_MOD
        FROM
          db_comercial.INFO_SERVICIO ISERV,
          db_comercial.INFO_SERVICIO_PROD_CARACT ISPC,
          db_comercial.ADMI_PRODUCTO_CARACTERISTICA APC,
          db_comercial.ADMI_PRODUCTO AP,
          db_comercial.ADMI_CARACTERISTICA AC
        WHERE
          ISPC.SERVICIO_ID                   = ISERV.ID_SERVICIO
        AND (ISPC.ESTADO = 'Activo' or (ISPC.ESTADO = 'Eliminado' and ISPC.USR_ULT_MOD = 'cancelMasiva'))
        AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
        AND APC.PRODUCTO_ID                  = AP.ID_PRODUCTO
        AND APC.CARACTERISTICA_ID            = AC.ID_CARACTERISTICA
        AND AC.ESTADO = 'Activo'
        AND ISERV.ID_SERVICIO                = Cn_idServicio
        AND AC.DESCRIPCION_CARACTERISTICA    = Cv_descripcionCaracteristica
        ORDER BY ISPC.FE_ULT_MOD DESC
        ) DATOS
        WHERE ROWNUM <= 1;
  Lv_valorServicioProdCaract INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
  --
BEGIN
  --
  IF C_getValorServicioProdCaract%ISOPEN THEN
    CLOSE C_getValorServicioProdCaract;
  END IF;
  --
  OPEN C_getValorServicioProdCaract(Fn_IdServicio,Fv_NombreCaracteristica);
  --
  FETCH
    C_getValorServicioProdCaract
  INTO
    Lv_valorServicioProdCaract;
  --
  CLOSE C_getValorServicioProdCaract;
  --
  IF Lv_valorServicioProdCaract IS NULL THEN
    Lv_valorServicioProdCaract  := NULL;
  END IF;
  --
  RETURN Lv_valorServicioProdCaract;
END GET_VALOR_SERVICIO_CARACT_CM;

/**
* GET_DATO_SUBRED_SERVICIO
*
* Función que permite obtener la ip del servicio
*
* @author Kenneth Jimenez <kjimenez@telconet.ec>
* @param number Fn_idServicio
* @param number Pv_campoRetorno
* @return string Lv_datoSubred
*/
FUNCTION GET_DATO_SUBRED_SERVICIO(
                                   Fn_idServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Pv_campoRetorno IN VARCHAR2
                                  ) RETURN DB_INFRAESTRUCTURA.INFO_SUBRED.SUBRED%TYPE
IS
--
  CURSOR C_getDatoSubred(Cn_idServicio  INFO_SERVICIO.ID_SERVICIO%TYPE,
                         Cv_campoRetorno IN VARCHAR2
                        )
  IS
    SELECT 
      CASE Cv_campoRetorno 
      WHEN 'SUBRED' THEN                         
          SUBRED.SUBRED
      WHEN 'MASCARA' THEN                         
          SUBRED.MASCARA
      WHEN 'GATEWAY' THEN
          SUBRED.GATEWAY
      WHEN 'TIPO' THEN
          SUBRED.TIPO
      ELSE                        
          NULL                      
      END DATO_SUBRED
    FROM DB_INFRAESTRUCTURA.INFO_IP IP, DB_INFRAESTRUCTURA.INFO_SUBRED SUBRED
    WHERE IP.SERVICIO_ID = Cn_idServicio
    AND IP.SUBRED_ID  = SUBRED.ID_SUBRED
    AND IP.ESTADO = 'Activo';
--
  Lv_datoSubred DB_INFRAESTRUCTURA.INFO_SUBRED.SUBRED%TYPE;
--
BEGIN
  IF C_getDatoSubred%ISOPEN THEN
    CLOSE C_getDatoSubred;
  END IF;
  --
  OPEN C_getDatoSubred(Fn_idServicio,Pv_campoRetorno);
  --
  FETCH
    C_getDatoSubred
  INTO
    Lv_datoSubred;
  --
  CLOSE C_getDatoSubred;
  --
  IF Lv_datoSubred IS NULL THEN
    Lv_datoSubred  := NULL;
  END IF;
--
  RETURN Lv_datoSubred;
--
END GET_DATO_SUBRED_SERVICIO;
--

/**
* GET_IP_SERVICIO
*
* Función que permite obtener la ip del servicio
*
* @author Kenneth Jimenez <kjimenez@telconet.ec>
* @param number Fn_idServicio
* @return string Lv_ipServicio
*/
FUNCTION GET_IP_SERVICIO(Fn_idServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN INFO_IP.IP%TYPE
IS
--
  CURSOR C_getIpServicio(Cn_idServicio  INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT  IP
    FROM DB_INFRAESTRUCTURA.INFO_IP
    WHERE SERVICIO_ID = Cn_idServicio
    AND ESTADO = 'Activo';
--
  Lv_ipServicio INFO_IP.IP%TYPE;
--
BEGIN
  IF C_getIpServicio%ISOPEN THEN
    CLOSE C_getIpServicio;
  END IF;
  --
  OPEN C_getIpServicio(Fn_idServicio);
  --
  FETCH
    C_getIpServicio
  INTO
    Lv_ipServicio;
  --
  CLOSE C_getIpServicio;
  --
  IF Lv_ipServicio IS NULL THEN
    Lv_ipServicio  := NULL;
  END IF;
--
  RETURN Lv_ipServicio;
--
END GET_IP_SERVICIO;

--
/*
* Funcion que sirve para obtener el valor del persona empresa rol caract por id
* @author Francisco Adum <fadum@telconet.ec>
* @version 1.0 09-04-2016
*
* @author Allan Suarez <arsuarez@telconet.ec>
* @version 1.1 26-02-2018 - Se agrega validacion para que soporte productos con nombre tecnico CONCINTER ( Concentradores de Interconexion )
*
* @author Allan Suarez <arsuarez@telconet.ec>
* @version 1.2 18-04-2018 - Se agrega validacion para que soporte productos con nombre tecnico DATOSDC
*
* @author David Leon <mdleon@telconet.ec>
* @version 1.3 05-08-2019 - Se agrega validacion para que soporte productos con nombre tecnico L3MPLS SDWAN
*
* @author David Leon <mdleon@telconet.ec>
* @version 1.4 04-09-2019 - Se agrega validacion para que soporte productos con nombre tecnico DATOS DC SDWAN Y INTERNET DC SDWAN
*
* @param  INFO_PERSONA_EMPRESA_ROL_CARAC.ID_PERSONA_EMPRESA_ROL_CARACT%TYPE   Fn_IdPersonaEmpresaRolCaract  id persona empresa rol caract
* @return INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE valor de info persona empresa rol caract
*/
--
FUNCTION GET_VALOR_PER_EMP_ROL_CAR(
    Fn_IdPersonaEmpresaRolCaract  IN INFO_PERSONA_EMPRESA_ROL_CARAC.ID_PERSONA_EMPRESA_ROL_CARACT%TYPE,
    Fv_nombreTecnico              IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fn_idPersonaEmpresaRol        IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Fv_nombreCaracteristica       IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_getValorPerEmpRolCarById (Cn_idPersonaEmpresaRolCaract INFO_PERSONA_EMPRESA_ROL_CARAC.ID_PERSONA_EMPRESA_ROL_CARACT%TYPE)
  IS
    SELECT VALOR
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC
    WHERE ID_PERSONA_EMPRESA_ROL_CARACT = Cn_idPersonaEmpresaRolCaract;
  --
  CURSOR C_getValorPerEmpRolCar (Cn_idPersonaEmpresaRol INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                                Cv_nombreCaracteristica ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  IS
    SELECT IPERC.VALOR 
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
    WHERE IPERC.CARACTERISTICA_ID = CARACT.ID_CARACTERISTICA
    AND CARACT.DESCRIPCION_CARACTERISTICA = Cv_nombreCaracteristica
    AND IPERC.PERSONA_EMPRESA_ROL_ID = Cn_idPersonaEmpresaRol
    AND IPERC.ESTADO = 'Activo';
  --
  Lv_valorPerEmpRolCar INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE;
  --
BEGIN
  --
  IF Fn_idPersonaEmpresaRol > 0 THEN
    IF C_getValorPerEmpRolCar%ISOPEN THEN
        CLOSE C_getValorPerEmpRolCar;
      END IF;
      --
      OPEN C_getValorPerEmpRolCar(Fn_idPersonaEmpresaRol,Fv_nombreCaracteristica);
      --
      FETCH
        C_getValorPerEmpRolCar
      INTO
        Lv_valorPerEmpRolCar;
      --
      CLOSE C_getValorPerEmpRolCar;
      --
      IF Lv_valorPerEmpRolCar IS NULL THEN
        Lv_valorPerEmpRolCar  := NULL;
      END IF;
  ELSE
    IF Fv_nombreTecnico = 'L3MPLS' or Fv_nombreTecnico = 'L3MPLS SDWAN' or Fv_nombreTecnico = 'CONCINTER' or Fv_nombreTecnico = 'DATOSDC' or Fv_nombreTecnico = 'INTERNETDC' 
        or Fv_nombreTecnico = 'DATOS DC SDWAN' or Fv_nombreTecnico = 'INTERNET DC SDWAN' THEN
      IF C_getValorPerEmpRolCarById%ISOPEN THEN
        CLOSE C_getValorPerEmpRolCarById;
      END IF;
      --
      OPEN C_getValorPerEmpRolCarById(Fn_IdPersonaEmpresaRolCaract);
      --
      FETCH
        C_getValorPerEmpRolCarById
      INTO
        Lv_valorPerEmpRolCar;
      --
      CLOSE C_getValorPerEmpRolCarById;
      --
      IF Lv_valorPerEmpRolCar IS NULL THEN
        Lv_valorPerEmpRolCar  := NULL;
      END IF;
    ELSE 
      Lv_valorPerEmpRolCar := Fn_IdPersonaEmpresaRolCaract;
    END IF;
  END IF;
  
  --
  RETURN Lv_valorPerEmpRolCar;
END GET_VALOR_PER_EMP_ROL_CAR;
--

--
/*
* Funcion que sirve para obtener el valor del persona empresa rol caract por id
* @author Francisco Adum <fadum@telconet.ec>
* @version 1.0 09-04-2016
* @param  INFO_PERSONA_EMPRESA_ROL_CARAC.ID_PERSONA_EMPRESA_ROL_CARACT%TYPE   Fn_IdPersonaEmpresaRolCaract  id persona empresa rol caract
* @return INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE valor de info persona empresa rol caract
*/
--
FUNCTION GET_VALOR_DETALLE_ELEMENTO(
    Fn_IdDetalleElemento           IN INFO_DETALLE_ELEMENTO.ID_DETALLE_ELEMENTO%TYPE)
  RETURN INFO_DETALLE_ELEMENTO.DETALLE_VALOR%TYPE
IS
  --
  CURSOR C_getValorDetalleElemento (Cn_idDetalleElemento INFO_DETALLE_ELEMENTO.ID_DETALLE_ELEMENTO%TYPE)
  IS
    SELECT DETALLE_VALOR
    FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
    WHERE ID_DETALLE_ELEMENTO = Cn_idDetalleElemento;
  Lv_valorDetalleElemento INFO_DETALLE_ELEMENTO.DETALLE_VALOR%TYPE;
  --
BEGIN
  --
  IF C_getValorDetalleElemento%ISOPEN THEN
    CLOSE C_getValorDetalleElemento;
  END IF;
  --
  OPEN C_getValorDetalleElemento(Fn_IdDetalleElemento);
  --
  FETCH
    C_getValorDetalleElemento
  INTO
    Lv_valorDetalleElemento;
  --
  CLOSE C_getValorDetalleElemento;
  --
  IF Lv_valorDetalleElemento IS NULL THEN
    Lv_valorDetalleElemento  := NULL;
  END IF;
  --
  RETURN Lv_valorDetalleElemento;
END GET_VALOR_DETALLE_ELEMENTO;
--

--
/*
* Funcion que sirve para obtener el flujo tecnico para el servicio
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
*
* @author Allan Suarez <arsuarez@telconet.ec>
* @version 1.1 21-09-2017 - Se agrega validacion para validar que si el Producto tiene marca de requiere info tecnica (SI)
*                           muestre por default el flujo de acuerdo a la empresa a la cual pertence el dueño del servicio
*                           en caso de que no tenga una ultima milla definida
* @param  INFO_EMPRESA_GRUPO.PREFIJO%TYPE                             Fv_PrefijoEmpresa     prefijo de la empresa
* @param  DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE   Fv_CodigoTipoMedio    id de la empresa
* @return DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE                   prefijo de la empresa
*/
--
FUNCTION GET_FLUJO_TECNICO(
    Fv_PrefijoEmpresa  IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fv_CodigoTipoMedio IN
    DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
    Fv_requiereInfoTec  IN ADMI_PRODUCTO.REQUIERE_INFO_TECNICA%TYPE,
    Fv_requiereInfoTec1 IN ADMI_PRODUCTO.REQUIERE_INFO_TECNICA%TYPE)
  RETURN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE
IS
  CURSOR C_getFlujoTecnico(Cv_prefijoEmpresa INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Cv_codigoTipoMedio
    DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE)
  IS
    SELECT
      VALOR3
    FROM
      DB_GENERAL.ADMI_PARAMETRO_DET
    WHERE
      VALOR1  =Cv_prefijoEmpresa
    AND VALOR2=Cv_codigoTipoMedio
    AND ESTADO='Activo';
  Lv_valor3 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE;
BEGIN
  --
  IF C_getFlujoTecnico%ISOPEN THEN
    CLOSE C_getFlujoTecnico;
  END IF;
  --
  OPEN C_getFlujoTecnico(Fv_PrefijoEmpresa,Fv_CodigoTipoMedio);
  --
  FETCH
    C_getFlujoTecnico
  INTO
    Lv_valor3;
  --
  CLOSE C_getFlujoTecnico;
  --
  IF Lv_valor3 IS NULL THEN
    IF Fv_requiereInfoTec = 'NO' OR Fv_requiereInfoTec1 = 'NO' THEN
      Lv_valor3 := Fv_PrefijoEmpresa;
    ELSIF Fv_requiereInfoTec1 = 'SI' THEN --PRODUCTO
      Lv_valor3 := Fv_PrefijoEmpresa;
    ELSE
      Lv_valor3  := null;
    END IF;
  END IF;
  --
  RETURN Lv_valor3;
END GET_FLUJO_TECNICO;
/*
* Funcion que sirve para obtener si el registro debe mostrar
* los botones unicamente para el producto preferencial
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
*
* @author Lizbeth Cruz <mlcruz@telconet.ec>
* @version 1.1 07-04-2017 - Se modifica la función para que se muestre los botones para el producto preferencial CAMARA IP perteneciente al paquete
*                           de NETLIFECAM
*
* @param  INFO_PLAN_CAB.ID_PLAN%TYPE          Fn_IdPlan            id del plan
* @param  ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE   Fv_nombreProducto    nombre tecnico del producto
* @param  ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE   Fv_nombreProducto1   nombre tecnico del producto
* @return VARCHAR2                            valor que depende del producto
*/
--
FUNCTION GET_BOTONES(
    Fn_IdPlan          IN INFO_PLAN_CAB.ID_PLAN%TYPE,
    Fv_nombreProducto  IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fv_nombreProducto1 IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_getCountProductoByPlan(Cn_idPlan INFO_PLAN_CAB.ID_PLAN%TYPE)
  IS
    SELECT
      COUNT(PROD.ID_PRODUCTO)
    FROM
      INFO_PLAN_CAB PLANC,
      INFO_PLAN_DET PLAND,
      ADMI_PRODUCTO PROD
    WHERE
      PLANC.ID_PLAN       = PLAND.PLAN_ID
    AND PLAND.PRODUCTO_ID = PROD.ID_PRODUCTO
    AND PLANC.ID_PLAN     = Cn_idPlan;
  Ln_countProducto VARCHAR2(5);
  Lv_botones       VARCHAR2(5);
BEGIN
  IF C_getCountProductoByPlan%ISOPEN THEN
    CLOSE C_getCountProductoByPlan;
  END IF;
  --
  OPEN C_getCountProductoByPlan(Fn_IdPlan);
  --
  FETCH
    C_getCountProductoByPlan
  INTO
    Ln_countProducto;
  --
  CLOSE C_getCountProductoByPlan;
  --
  IF ((Ln_countProducto > 1 AND Fn_IdPlan IS NOT NULL AND Fv_nombreProducto='INTERNET') OR 
     (Ln_countProducto > 1 AND Fn_IdPlan IS NOT NULL AND Fv_nombreProducto='CAMARA IP')) THEN
    Lv_botones         := 'SI';
  ELSIF Ln_countProducto=1 AND Fn_IdPlan IS NOT NULL THEN
    Lv_botones         := 'SI';
  ELSIF Fn_IdPlan      IS NULL AND Fv_nombreProducto1 IS NOT NULL THEN
    Lv_botones         := 'SI';
  ELSE
    Lv_botones := 'NO';
  END IF;
  --
  RETURN Lv_botones;
END GET_BOTONES;
--
/*
* Funcion que sirve para indicar si el servicio requiere mac wifi
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE      Fn_IdServicio        id del servicio
* @param  ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE   Fv_nombreProducto    nombre tecnico del producto
* @return VARCHAR2                            valor (SI/NO)
*/
--
FUNCTION GET_VALIDACION_MAC_WIFI(
    Fn_IdServicio     IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_nombreProducto IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE )
  RETURN VARCHAR2
IS
  Lv_valorServicioProdCaract INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
  Lv_requiereMac VARCHAR2(5);
BEGIN
  IF Fv_nombreProducto          = 'IP' THEN
    Lv_valorServicioProdCaract :=
    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(Fn_IdServicio,'MAC');
    IF Lv_valorServicioProdCaract IS NULL THEN
      Lv_requiereMac              := 'NO';
      Lv_valorServicioProdCaract  :=
      TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(Fn_IdServicio,'MAC WIFI');
      IF Lv_valorServicioProdCaract IS NULL THEN
        Lv_requiereMac              := 'SI';
      END IF;
    ELSE
      Lv_requiereMac := 'NO';
    END IF;
  --
  ELSIF Fv_nombreProducto = 'INTERNET' THEN
        Lv_valorServicioProdCaract :=
    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(Fn_IdServicio,'MAC');
    IF Lv_valorServicioProdCaract IS NULL THEN
      Lv_requiereMac              := 'NO';
      Lv_valorServicioProdCaract  :=
      TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(Fn_IdServicio,'MAC WIFI');
      IF Lv_valorServicioProdCaract IS NULL THEN
        Lv_requiereMac              := 'SI';
      END IF;
    ELSE
      Lv_requiereMac := 'NO';
    END IF;
  --
  ELSE
    Lv_requiereMac := 'NO';
  --
  END IF;
  --
  RETURN Lv_requiereMac;
END GET_VALIDACION_MAC_WIFI;
--
/*
* Funcion que sirve para obtener el estado de la solicitud de planificacion
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
*
* @author Allan Suarez <arsuarez@telconet.ec>
* @versio 1.1 19-07-2016 - Se modifica funcion para que siempre se devuelva el ultimo estado de las solicitudes de tipo CAMBIO ULTIMA MILLA 
*                          asociadas al servicio
*
* @author Walther Joao Gaibor <wgaibor@telconet.ec>
* @version 1.2 28-10-2016 - Se modifica el filtro de la consulta al momento de obtener ID_DETALLE_SOLICITUD se consulta 
*                           el maximo id_detalle_solicitud en base a la descripcion de solicitud.
*
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE                   Fn_IdServicio    id del servicio
* @param  ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE   Fv_tipoSolicitud tipo de solicitud
* @return VARCHAR2                                         valor del estado
*/
--
FUNCTION GET_ESTADO_SOLICITUD_PLANIFICA(
    Fn_IdServicio    IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_tipoSolicitud IN ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE )
  RETURN VARCHAR2
IS
  --
  CURSOR C_getSolicitudPlanificacion (Cn_idServicio
    INFO_SERVICIO.ID_SERVICIO%TYPE, Cv_tipoSolicitud
    ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE)
  IS
    SELECT
      IDS.ESTADO
    FROM
      INFO_DETALLE_SOLICITUD IDS,
      ADMI_TIPO_SOLICITUD ATS
    WHERE
      IDS.TIPO_SOLICITUD_ID       = ATS.ID_TIPO_SOLICITUD
    AND ATS.DESCRIPCION_SOLICITUD = Cv_tipoSolicitud
    AND ATS.ESTADO                = 'Activo'
    AND IDS.SERVICIO_ID           = Cn_idServicio
    AND IDS.ID_DETALLE_SOLICITUD  = (SELECT MAX(ID_DETALLE_SOLICITUD)
                                     FROM INFO_DETALLE_SOLICITUD IDS,
                                          ADMI_TIPO_SOLICITUD ATS
                                     WHERE IDS.TIPO_SOLICITUD_ID   = ATS.ID_TIPO_SOLICITUD
                                     AND ATS.DESCRIPCION_SOLICITUD = Cv_tipoSolicitud
                                     AND ATS.ESTADO                = 'Activo'
                                     AND SERVICIO_ID               = Cn_idServicio);
  Lv_estadoSolicitud INFO_DETALLE_SOLICITUD.ESTADO%TYPE;
BEGIN
  --
  IF C_getSolicitudPlanificacion%ISOPEN THEN
    CLOSE C_getSolicitudPlanificacion;
  END IF;
  --
  OPEN C_getSolicitudPlanificacion(Fn_IdServicio,Fv_tipoSolicitud);
  --
  FETCH
    C_getSolicitudPlanificacion
  INTO
    Lv_estadoSolicitud;
  --
  CLOSE C_getSolicitudPlanificacion;
  --
  IF Lv_estadoSolicitud IS NULL THEN
    Lv_estadoSolicitud  := NULL;
  END IF;
  --
  RETURN Lv_estadoSolicitud;
END GET_ESTADO_SOLICITUD_PLANIFICA ;
--
/*
* Funcion que sirve para obtener los datos necesarios para las ips fijas
* @author Francisco Adum <fadum@telconet.ec>
* @version 1.0 29-10-2014
*
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 17-09-2015
*
* @author Jesus Bozada    <jbozada@telconet.ec>
* @version 1.1 28-02-2019 Se agrega estado Pendiente para poder procesar Traslado de equipos EXTENDER DUAL BAND
* @since 1.0
*
* @param  INFO_SERVICIO_PROD_CARACT.VALOR%TYPE  Fv_macWifi          valor de la mac wifi
* @param  INFO_PUNTO.ID_PUNTO%TYPE              Fn_IdPunto          id del punto
* @param  VARCHAR2                              Fv_tipoReturn       valor del tipo de return
* @param  INFO_SERVICIO.ESTADO%TYPE             Fv_estadoServicio   estado del servicio
* @return VARCHAR2                              valor
*/
--
FUNCTION GET_VALIDACION_IP_FIJA(
    Fv_macWifi        IN INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Fn_IdPunto        IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_tipoReturn     IN VARCHAR2,
    Fv_estadoServicio IN INFO_SERVICIO.ESTADO%TYPE )
  RETURN VARCHAR2
IS
  CURSOR C_getServActivosByPuntoPlan(Cn_idPunto INFO_PUNTO.ID_PUNTO%TYPE,
    Cv_nombreProducto ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)
  IS
    SELECT
      SERV.ID_SERVICIO
    FROM
      INFO_SERVICIO SERV,
      INFO_PLAN_CAB PLANC,
      INFO_PLAN_DET PLAND,
      ADMI_PRODUCTO PROD
    WHERE
      SERV.PLAN_ID          = PLANC.ID_PLAN
    AND PLANC.ID_PLAN       = PLAND.PLAN_ID
    AND PLAND.PRODUCTO_ID   = PROD.ID_PRODUCTO
    AND PROD.NOMBRE_TECNICO = Cv_nombreProducto
    AND (SERV.ESTADO        = 'Activo' OR SERV.ESTADO = 'Trasladado')
    AND SERV.PUNTO_ID       = Cn_idPunto;
  CURSOR C_getServIntActivosByPuntoProd(Cn_idPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT
      SERV.ID_SERVICIO
    FROM
      INFO_SERVICIO SERV,
      ADMI_PRODUCTO PROD
    WHERE
      SERV.PRODUCTO_ID      = PROD.ID_PRODUCTO
    AND PROD.NOMBRE_TECNICO = 'IP'
    AND SERV.ESTADO         = 'Activo'
    AND SERV.PUNTO_ID       = Cn_idPunto;
  Lv_servicioIpFijaPlan VARCHAR2(10);
  Lv_servicioIpFijaProd VARCHAR2(10);
  Lv_servicioInternet   VARCHAR2(10);
  Lv_tieneIpFija        VARCHAR2(100);
  Lv_macIpFija          VARCHAR2(100);
  Lv_servicioRefIpFija  VARCHAR2(100);
BEGIN
  --
  IF C_getServActivosByPuntoPlan%ISOPEN THEN
    CLOSE C_getServActivosByPuntoPlan;
  END IF;
  --
  OPEN C_getServActivosByPuntoPlan(Fn_IdPunto,'IP');
  --
  FETCH
    C_getServActivosByPuntoPlan
  INTO
    Lv_servicioIpFijaPlan;
  --
  CLOSE C_getServActivosByPuntoPlan;
  --
  --
  IF C_getServActivosByPuntoPlan%ISOPEN THEN
    CLOSE C_getServActivosByPuntoPlan;
  END IF;
  --
  OPEN C_getServActivosByPuntoPlan(Fn_IdPunto,'INTERNET');
  --
  FETCH
    C_getServActivosByPuntoPlan
  INTO
    Lv_servicioInternet;
  --
  CLOSE C_getServActivosByPuntoPlan;
  --
  --
  IF C_getServIntActivosByPuntoProd%ISOPEN THEN
    CLOSE C_getServIntActivosByPuntoProd;
  END IF;
  --
  OPEN C_getServIntActivosByPuntoProd(Fn_IdPunto);
  --
  FETCH
    C_getServIntActivosByPuntoProd
  INTO
    Lv_servicioIpFijaProd;
  --
  CLOSE C_getServIntActivosByPuntoProd;
  --
  IF Fv_estadoServicio        = 'Asignada' THEN
    IF Lv_servicioIpFijaPlan IS NULL AND Lv_servicioIpFijaProd IS NULL THEN
      IF Lv_servicioInternet IS NULL THEN
        Lv_tieneIpFija       := '0';
        Lv_macIpFija         := 'Servicio sin Plan Activo';
        Lv_servicioRefIpFija := '0';
      ELSE
        Lv_tieneIpFija := '0';
        IF Fv_macWifi  IS NULL THEN
          Lv_macIpFija := 'Servicio sin Mac Wifi';
        ELSE
          Lv_macIpFija := Fv_macWifi;
        END IF;
        Lv_servicioRefIpFija := Lv_servicioInternet;
      END IF;
    ELSE
      Lv_tieneIpFija       := '1';
      Lv_macIpFija         := '';
      Lv_servicioRefIpFija := Lv_servicioInternet;
    END IF;
  ELSIF Fv_estadoServicio = 'Activo' OR Fv_estadoServicio = 'Pendiente' OR Fv_estadoServicio = 'PendienteAp' THEN
    Lv_tieneIpFija       := '0';
    Lv_macIpFija         := Fv_macWifi;
    Lv_servicioRefIpFija := Lv_servicioInternet;
  END IF;
  IF Fv_tipoReturn = 'TIENE IP FIJA' THEN
    RETURN Lv_tieneIpFija;
  ELSIF Fv_tipoReturn = 'MAC IP FIJA' THEN
    RETURN Lv_macIpFija;
  ELSE
    RETURN Lv_servicioRefIpFija;
  END IF;
END GET_VALIDACION_IP_FIJA;
--
/*
* Funcion que sirve para obtener si el servicio dispone de un documento activo por
* el tipo de documento en el instalaciones y migraciones.
*
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
* @author Juan Lafuente <jlafuente@telconet.ec>
* @version 1.1 20-11-2014
* @author Richard Cabrera <rcabrera@telconet.ec>
* @version 1.2 04-12-2015
* @param  DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL.CODIGO_TIPO_DOCUMENTO%TYPE Fv_CodTipoDocumento    tipo de documento
* @param  DB_COMUNICACION.INFO_DOCUMENTO_RELACION.MODULO%TYPE               Fv_Modulo              modulo
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE                                    Fn_IdServicio          id del servicio
* @param  DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE                           Fn_IdDetalle           id detalle
* @return VARCHAR2                                                          valor (TRUE/FALSE)
*/
--
FUNCTION GET_ACTA_ENCUESTA(
    Fv_CodTipoDocumento IN
    DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fv_Modulo     IN DB_COMUNICACION.INFO_DOCUMENTO_RELACION.MODULO%TYPE,
    Fn_IdServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fn_IdDetalle  IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE DEFAULT NULL)
  RETURN VARCHAR2
IS
  CURSOR C_GetActaEncuesta(Cv_CodTipoDocumento
    DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL.CODIGO_TIPO_DOCUMENTO%TYPE,
    Cv_Modulo DB_COMUNICACION.INFO_DOCUMENTO_RELACION.MODULO%TYPE,
    Cn_IdServicio INFO_SERVICIO.ID_SERVICIO%TYPE,
    Cn_IdDetalle  INFO_DETALLE.ID_DETALLE%TYPE)
  IS
    SELECT
      IDC.*
    FROM
      DB_COMUNICACION.INFO_DOCUMENTO_RELACION IDR,
      DB_COMUNICACION.INFO_DOCUMENTO IDC,
      DB_GENERAL.ADMI_TIPO_DOCUMENTO_GENERAL ATDG
    WHERE
      IDR.DOCUMENTO_ID             = IDC.ID_DOCUMENTO
    AND ATDG.ID_TIPO_DOCUMENTO     = IDC.TIPO_DOCUMENTO_GENERAL_ID
    AND ATDG.CODIGO_TIPO_DOCUMENTO = Cv_CodTipoDocumento
    AND IDR.MODULO                 = Cv_Modulo
    AND IDR.SERVICIO_ID            = Cn_IdServicio
    AND IDR.DETALLE_ID             = Cn_IdDetalle
    AND IDR.ESTADO                 = 'Activo';
  --
  Lc_ActaEncuesta C_GetActaEncuesta%ROWTYPE;
  Lb_Resultado VARCHAR2(5) := 'TRUE';
BEGIN
  --
  IF C_GetActaEncuesta%ISOPEN THEN
    CLOSE C_GetActaEncuesta;
  END IF;
  --
  OPEN C_GetActaEncuesta(Fv_CodTipoDocumento,Fv_Modulo, Fn_IdServicio,Fn_IdDetalle);
  --
  FETCH
    C_GetActaEncuesta
  INTO
    Lc_ActaEncuesta;
  --
  IF C_GetActaEncuesta%NOTFOUND THEN
    --
    Lb_Resultado := 'FALSE';
    --
  END IF;
  --
  CLOSE C_GetActaEncuesta;
  --
  RETURN Lb_Resultado;
END GET_ACTA_ENCUESTA;
--

FUNCTION GET_OBSERVACION_DETALLE(
    Fn_IdDetalle  IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE DEFAULT NULL)
  RETURN VARCHAR2
IS
  Lv_Resultado VARCHAR2(4000) := '';
BEGIN
  SELECT
    NVL(D.OBSERVACION,'') INTO Lv_Resultado
  FROM
    DB_SOPORTE.INFO_DETALLE D 
  WHERE
    D.ID_DETALLE            = Fn_IdDetalle;
  --
  RETURN Lv_Resultado;
END GET_OBSERVACION_DETALLE;


/*
* Funcion que sirve para obtener la fecha de confirmacion del servicio
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE     Fn_IdServicio          id del servicio
* @return VARCHAR2                           fecha
*/
--
FUNCTION GET_FECHA_CONFIRMACION(
    Fn_IdServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_GetFechaConfirmacionServ(Cn_IdServicio
    INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT
      NVL2(TO_CHAR(MAX(servicio.fe_creacion), 'DD-MM-YYYY'), TO_CHAR(MAX(
      servicio.fe_creacion), 'DD-MM-YYYY'), TO_CHAR(SYSDATE, 'DD-MM-YYYY'))
      FECHA_CONFIRMACION
    FROM
      info_servicio_historial servicio
    WHERE
      servicio.estado = 'Activo'
    AND
      (
        upper(servicio.observacion) LIKE upper('%confirmo%')
      OR upper(servicio.observacion) LIKE upper(
        '%Se Activo el Servicio Traslado%')
      OR upper(servicio.observacion) LIKE upper(
        '%Se Activo el Servicio Reubicado%')
      )
    AND servicio_id = Cn_IdServicio;
  --
  Lc_FechaConfirmacionServ C_GetFechaConfirmacionServ%ROWTYPE;
  Lv_FechaConfirmacionServ VARCHAR2(10) := '';
  --
BEGIN
  --
  IF C_GetFechaConfirmacionServ%ISOPEN THEN
    CLOSE C_GetFechaConfirmacionServ;
  END IF;
  --
  OPEN C_GetFechaConfirmacionServ(Fn_IdServicio);
  --
  FETCH
    C_GetFechaConfirmacionServ
  INTO
    Lc_FechaConfirmacionServ;
  --
  Lv_FechaConfirmacionServ := Lc_FechaConfirmacionServ.FECHA_CONFIRMACION;
  --
  CLOSE C_GetFechaConfirmacionServ;
  --
  RETURN Lv_FechaConfirmacionServ;
END GET_FECHA_CONFIRMACION;
--
/*
* Funcion que sirve para obtener el total de los registros consultados
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
* @param  CLOB  Prf_Result    sql que se consulta
* @return NUMBER              cantidad de registros
*/
--
FUNCTION GET_COUNT_REFCURSOR(
    Prf_Result IN CLOB)
  RETURN NUMBER
IS
  Lrf_Count Lrf_Result;
  Lt_RefCursor Lt_Result;
BEGIN
  --
  OPEN Lrf_Count FOR Prf_Result;
  --
  FETCH
    Lrf_Count BULK COLLECT
  INTO
    Lt_RefCursor;
  --
  RETURN Lt_RefCursor.COUNT;
  --
END GET_COUNT_REFCURSOR;
--
/*
* Funcion que sirve para obtener los datos necesarios para las ips fijas
* @author Francisco Adum <fadum@telconet.ec>
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 29-10-2014
* @param  ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE   Fv_NombreProducto       nombre tecnico del producto
* @param  ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE   Fv_NombreProducto1      nombre tecnico del producto
* @param  INFO_SERVICIO.CANTIDAD%TYPE         Fn_Cantidad             cantidad del servicio
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE      Fn_IdServicio           id del servicio
* @return NUMBER                              cantidad de registros
*/
--
FUNCTION GET_CANTIDAD_USADA_PRODUCTO(
    Fv_NombreProducto  IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fv_NombreProducto1 IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fn_Cantidad        IN INFO_SERVICIO.CANTIDAD%TYPE,
    Fn_IdServicio      IN INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_getCountCaracteristicas (Cn_idServicio
    INFO_SERVICIO.ID_SERVICIO%TYPE, Cv_descripcionCaracteristica
    ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  IS
    SELECT
      COUNT (ISPC.ID_SERVICIO_PROD_CARACT) CONT
    FROM
      INFO_SERVICIO_PROD_CARACT ISPC,
      ADMI_PRODUCTO_CARACTERISTICA APC,
      ADMI_CARACTERISTICA AC
    WHERE
      ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
    AND APC.CARACTERISTICA_ID          = AC.ID_CARACTERISTICA
    AND AC.DESCRIPCION_CARACTERISTICA  = Cv_descripcionCaracteristica
    AND ISPC.ESTADO                   IN ('Activo','In-Corte')
    AND ISPC.SERVICIO_ID               = Cn_idServicio;
  --
  --
  CURSOR C_getCountIp (Cn_idServicio INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT
      COUNT(IP.ID_IP) CONT
    FROM
      DB_INFRAESTRUCTURA.INFO_IP IP
    WHERE
      IP.SERVICIO_ID = Cn_idServicio
    AND IP.ESTADO   IN ('Activo','In-Corte');
  --
  --
  Ln_contCaractCorreo  NUMBER;
  Ln_contCaractDominio NUMBER;
  Ln_contIp            NUMBER;
  --
BEGIN
  --CONTAR CARACTERISTICAS PARA EL CORREO
  IF C_getCountCaracteristicas%ISOPEN THEN
    CLOSE C_getCountCaracteristicas;
  END IF;
  --
  OPEN C_getCountCaracteristicas(Fn_IdServicio,'USUARIO');
  --
  FETCH
    C_getCountCaracteristicas
  INTO
    Ln_contCaractCorreo;
  --
  CLOSE C_getCountCaracteristicas;
  --
  --CONTAR CARACTERISTICAS PARA EL DOMINIO
  --
  IF C_getCountCaracteristicas%ISOPEN THEN
    CLOSE C_getCountCaracteristicas;
  END IF;
  --
  OPEN C_getCountCaracteristicas(Fn_IdServicio,'DOMINIO');
  --
  FETCH
    C_getCountCaracteristicas
  INTO
    Ln_contCaractDominio;
  --
  CLOSE C_getCountCaracteristicas;
  --
  --CONTAR IP
  --
  IF C_getCountIp%ISOPEN THEN
    CLOSE C_getCountIp;
  END IF;
  --
  OPEN C_getCountIp(Fn_IdServicio);
  --
  FETCH
    C_getCountIp
  INTO
    Ln_contIp;
  --
  CLOSE C_getCountIp;
  --
  --LOGICA
  --
  IF Fv_NombreProducto='CORREO' OR Fv_NombreProducto='SMTP AUTENTICADO' OR
    Fv_NombreProducto1='CORREO' OR Fv_NombreProducto='SMTP AUTENTICADO' THEN
    RETURN Ln_contCaractCorreo;
  END IF;
  IF Fv_NombreProducto='DOMINIO' OR Fv_NombreProducto='HOSTING' OR
    Fv_NombreProducto ='SITIO WEB' OR Fv_NombreProducto1='CORREO' OR
    Fv_NombreProducto ='SMTP AUTENTICADO' OR Fv_NombreProducto1='SITIO WEB' OR
    Fv_NombreProducto1 = 'DOMINIO'
    THEN
    RETURN Ln_contCaractDominio;
  END IF;
  IF Fv_NombreProducto='IP' OR Fv_NombreProducto='IP' THEN
    RETURN Ln_contIp;
  END IF;
  RETURN 0;
  --
END GET_CANTIDAD_USADA_PRODUCTO;
--


FUNCTION FNC_GET_MEDIO_POR_PUNTO(Pn_IdPunto    IN INFO_PUNTO.ID_PUNTO%TYPE,
                                 Pv_NomTecnico IN ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)  RETURN VARCHAR2
                                       
IS
  --
  CURSOR C_GetDescPlan( Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_NomTecnico ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)
  IS
    SELECT TM.CODIGO_TIPO_MEDIO
    FROM INFO_SERVICIO ISR,
      INFO_PLAN_CAB IPC,
      INFO_PLAN_DET IPD,
      ADMI_PRODUCTO AP,
      INFO_SERVICIO_TECNICO ST,
      ADMI_TIPO_MEDIO TM
    WHERE ISR.PLAN_ID     = IPC.ID_PLAN
    AND IPC.ID_PLAN       = IPD.PLAN_ID
    AND IPD.PRODUCTO_ID   = AP.ID_PRODUCTO
    AND AP.NOMBRE_TECNICO = Cv_NomTecnico
    AND ISR.PUNTO_ID      = Cn_IdPunto
    AND ISR.ID_SERVICIO   = ST.SERVICIO_ID
    AND ST.ULTIMA_MILLA_ID = TM.ID_TIPO_MEDIO;

  CURSOR C_GetDescProducto(  Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_NomTecnico ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE)
  IS
    SELECT
    TM.CODIGO_TIPO_MEDIO
    FROM INFO_SERVICIO ISR,
      INFO_SERVICIO_TECNICO SRT,
      ADMI_TIPO_MEDIO TM,
      ADMI_PRODUCTO AP
    WHERE ISR.PRODUCTO_ID = AP.ID_PRODUCTO
    AND AP.NOMBRE_TECNICO = Cv_NomTecnico
    AND AP.ESTADO         = 'Activo'     
    AND ISR.PUNTO_ID      = Cn_IdPunto
    AND ISR.ID_SERVICIO   = SRT.SERVICIO_ID
    AND SRT.ULTIMA_MILLA_ID = TM.ID_TIPO_MEDIO;
  --
  Lv_Descripcion VARCHAR2(1000) := NULL;
BEGIN
  --
  IF C_GetDescPlan%ISOPEN THEN
    --
    CLOSE C_GetDescPlan;
    --
  END IF;
  --
  OPEN C_GetDescPlan( Pn_IdPunto, Pv_NomTecnico);
  --
  FETCH C_GetDescPlan INTO Lv_Descripcion;
  --
  IF C_GetDescPlan%NOTFOUND THEN
    --
    Lv_Descripcion := NULL;
    --
    IF C_GetDescProducto%ISOPEN THEN
      --
      CLOSE C_GetDescProducto;
      --
    END IF;
    --
    OPEN C_GetDescProducto( Pn_IdPunto, Pv_NomTecnico);
    --
    FETCH C_GetDescProducto INTO Lv_Descripcion;
    --
    CLOSE C_GetDescProducto;
    --
  END IF;
  --
  CLOSE C_GetDescPlan;
  --
  RETURN Lv_Descripcion;
  --
 
 
END FNC_GET_MEDIO_POR_PUNTO;

--
FUNCTION FNC_GET_SERV_ELE_PTO(Fn_IdElemento   IN INFO_ELEMENTO.ID_ELEMENTO%TYPE,
                                              Fn_IdInterface  IN INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE) RETURN VARCHAR2
IS
  --
  CURSOR C_GetTipoElemento( Cn_IdElemento INFO_ELEMENTO.ID_ELEMENTO%TYPE)
  IS
    SELECT ATE.NOMBRE_TIPO_ELEMENTO
    FROM INFO_ELEMENTO IE,
    ADMI_MODELO_ELEMENTO AME,
    ADMI_TIPO_ELEMENTO ATE
    WHERE IE.ID_ELEMENTO = Cn_IdElemento
    AND IE.MODELO_ELEMENTO_ID = AME.ID_MODELO_ELEMENTO
    AND AME.TIPO_ELEMENTO_ID = ATE.ID_TIPO_ELEMENTO;
  --
  CURSOR C_GetServicioPorConector(Cn_IdElemento INFO_ELEMENTO.ID_ELEMENTO%TYPE, Cn_IdInterface INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE)
  IS
    SELECT LISTAGG(IST.SERVICIO_ID,',') WITHIN GROUP (ORDER BY IST.SERVICIO_ID)
    FROM INFO_SERVICIO_TECNICO IST
    WHERE IST.ELEMENTO_CONECTOR_ID = Cn_IdElemento
    AND IST.INTERFACE_ELEMENTO_CONECTOR_ID = NVL(Cn_IdInterface,IST.INTERFACE_ELEMENTO_CONECTOR_ID);
  --
  CURSOR C_GetServicioPorContenedor(Cn_IdElemento INFO_ELEMENTO.ID_ELEMENTO%TYPE)
  IS
    SELECT LISTAGG(IST.SERVICIO_ID,',') WITHIN GROUP (ORDER BY IST.SERVICIO_ID)
    FROM INFO_SERVICIO_TECNICO IST
    WHERE IST.ELEMENTO_CONTENEDOR_ID = Cn_IdElemento;
  --
  CURSOR C_GetServicioPorElemento(Cn_IdElemento INFO_ELEMENTO.ID_ELEMENTO%TYPE, Cn_IdInterface INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE)
  IS
    SELECT LISTAGG(IST.SERVICIO_ID,',') WITHIN GROUP (ORDER BY IST.SERVICIO_ID)
    FROM INFO_SERVICIO_TECNICO IST
    WHERE IST.ELEMENTO_ID = Cn_IdElemento
    AND IST.INTERFACE_ELEMENTO_ID = NVL(Cn_IdInterface,IST.INTERFACE_ELEMENTO_ID);
  --
  Lv_tipoElemento VARCHAR2(25) := NULL;
  Lv_idServicios   VARCHAR2(1000) := NULL;
  BEGIN
 
  --
  IF C_GetTipoElemento%ISOPEN THEN
    --
    CLOSE C_GetTipoElemento;
    --
  END IF;
  --
 
  OPEN C_GetTipoElemento(Fn_IdElemento);
  --
  FETCH C_GetTipoElemento INTO Lv_tipoElemento;
  --
  CLOSE C_GetTipoElemento;
 
 
  IF Lv_tipoElemento IN ('SPLITTER','CASSETTE') THEN
 
    IF C_GetServicioPorConector%ISOPEN THEN
      --
      CLOSE C_GetServicioPorConector;
      --
    END IF;
    --
   
    OPEN C_GetServicioPorConector(Fn_IdElemento,Fn_IdInterface);
    --
    FETCH C_GetServicioPorConector INTO Lv_idServicios;
    --
    CLOSE C_GetServicioPorConector;
   
  ELSIF Lv_tipoElemento = 'CAJA DISPERSION' THEN
 
    IF C_GetServicioPorContenedor%ISOPEN THEN
      --
      CLOSE C_GetServicioPorContenedor;
      --
    END IF;
    --
   
    OPEN C_GetServicioPorContenedor(Fn_IdElemento);
    --
    FETCH C_GetServicioPorContenedor INTO Lv_idServicios;
    --
    CLOSE C_GetServicioPorContenedor;
 
  ELSIF Lv_tipoElemento IN ('DSLAM','OLT','RADIO','SWITCH')  THEN
 
    IF C_GetServicioPorElemento%ISOPEN THEN
      --
      CLOSE C_GetServicioPorElemento;
      --
    END IF;
    --
   
    OPEN C_GetServicioPorElemento(Fn_IdElemento,Fn_IdInterface);
    --
    FETCH C_GetServicioPorElemento INTO Lv_idServicios;
    --
    CLOSE C_GetServicioPorElemento;
   
  END IF;
  --
  RETURN Lv_idServicios;
 

END FNC_GET_SERV_ELE_PTO;
--

--
/*
* Funcion que sirve para obtener el id de cualquier solicitud
* de un servicio basado en los estados definidos como admi_parametros
* @author Juan Lafuente <jlafuente@telconet.ec>
* @version 1.0 29-10-2015
* @since 1.0
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE                    Fn_IdServicio       id del servicio
* @param  ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE    Fv_tipoSolicitud    tipo de solicitud
* @param  ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE          Fv_NombreParametro  nombre de la cabecera del parametro
* @param  ADMI_PARAMETRO_CAB.MODULO%TYPE                    Fv_ModuloParametro  modulo al cual pertenece el parametro
* @return INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE  id de la solicitud
*/
FUNCTION GET_ID_DET_SOL_PARAM_EST(
    Fn_IdServicio      IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_tipoSolicitud   IN ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    Fv_NombreParametro IN ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Fv_ModuloParametro IN ADMI_PARAMETRO_CAB.MODULO%TYPE)
  RETURN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE
IS
  --
  Ln_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
  --
  Lv_QueryDetalleSolicitud VARCHAR2(1000) := '';
  Lv_EstadoActivo          VARCHAR2(6)    := 'Activo';
  --
  Lv_EstadoParametro       VARCHAR2(6)    := 'Activo';
  Lv_EstadoParametroDet    VARCHAR2(6)    := 'Activo';
  --
BEGIN
  --
  Lv_QueryDetalleSolicitud := 'SELECT IDS.ID_DETALLE_SOLICITUD FROM '
                              || 'ADMI_TIPO_SOLICITUD ATP, '
                              || 'INFO_DETALLE_SOLICITUD IDS, '
                              || 'INFO_SERVICIO ISERV '
                              || 'WHERE ISERV.ID_SERVICIO   = IDS.SERVICIO_ID '
                              || 'AND ATP.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID '
                              || 'AND ATP.ESTADO            = :Bv_EstadoActivo '
                              || 'AND ISERV.ID_SERVICIO     = :Bn_IdServicio '
                              || 'AND IDS.ESTADO            IN ( SELECT PDET.VALOR1 '
                                                             || 'FROM ADMI_PARAMETRO_DET PDET '
                                                             || 'WHERE PDET.PARAMETRO_ID = '
                                                             || '      (SELECT PCAB.Id_Parametro '
                                                             || '       FROM ADMI_PARAMETRO_CAB PCAB '
                                                             || '       WHERE PCAB.NOMBRE_PARAMETRO = :Bv_NombreParametro '
                                                             || '         AND PCAB.MODULO           = :Bv_ModuloParametro '
                                                             || '         AND PCAB.ESTADO           = :Bv_EstadoParametro) '
                                                             || 'AND PDET.ESTADO = :Bv_EstadoParametroDet)';
          
  --
  IF Fv_tipoSolicitud IS NOT NULL THEN
    --
    Lv_QueryDetalleSolicitud := Lv_QueryDetalleSolicitud || ' AND ATP.DESCRIPCION_SOLICITUD IN (:Bv_tipoSolicitud1)';
    --
    EXECUTE IMMEDIATE Lv_QueryDetalleSolicitud
    INTO Ln_IdDetalleSolicitud
    USING Lv_EstadoActivo, Fn_IdServicio, Fv_NombreParametro, Fv_ModuloParametro, Lv_EstadoParametro,Lv_EstadoParametroDet, Fv_tipoSolicitud;
    --
  END IF;
  --
  RETURN Ln_IdDetalleSolicitud;
  --
  EXCEPTION WHEN NO_DATA_FOUND THEN
  --
  RETURN NULL;
  --
END GET_ID_DET_SOL_PARAM_EST;
--

/**
* GET_ID_DETALLE_ULTIMA_SOL
* Funcion que retorna el id_detalle de la ultima solicitud de planificacion o migracion que tenga el servicio
* @author Richard Cabrera <rcabrera@telconet.ec>
* @version 1.0 09-12-2015
*
* @author Jesus Bozada <jbozada@telconet.ec>
* @version 1.1 10-08-2016   Se agrega funcion MAX para obtener el id de la ultima tarea generada sobre la ultima solicitud del servicio
*
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE Fn_IdServicio
* @return DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE   id_detalle de la solicitud
*/
FUNCTION GET_ID_DETALLE_ULTIMA_SOL(Fn_IdServicio      IN INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE
IS
  --
  Ln_IdDetalle DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE;
  --
  Lv_QueryDetalle VARCHAR2(2000) := '';
  --
BEGIN
  --
  Lv_QueryDetalle := ' SELECT MAX(INFO_DETALLE.ID_DETALLE)
                        FROM DB_SOPORTE.INFO_DETALLE INFO_DETALLE
                        WHERE INFO_DETALLE.DETALLE_SOLICITUD_ID =
                          (SELECT INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD
                          FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD INFO_DETALLE_SOLICITUD
                          WHERE INFO_DETALLE_SOLICITUD.FE_CREACION =
                            (SELECT  MAX(INFO_DETALLE_SOLICITUD2.FE_CREACION)
                            FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD INFO_DETALLE_SOLICITUD2
                            WHERE INFO_DETALLE_SOLICITUD2.SERVICIO_ID=:Bv_Servicio
                            AND INFO_DETALLE_SOLICITUD2.TIPO_SOLICITUD_ID IN
                              (SELECT ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD
                              FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ADMI_TIPO_SOLICITUD
                              WHERE ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD IN (SELECT valor1
                              FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE parametro_id IN
                               (SELECT id_parametro FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                                WHERE nombre_parametro = ''TIPOS DE SOLICITUDES''))
                              )) AND INFO_DETALLE_SOLICITUD.SERVICIO_ID=:Bv_Servicio) ';

    --
    EXECUTE IMMEDIATE Lv_QueryDetalle
    INTO Ln_IdDetalle
    USING Fn_IdServicio,Fn_IdServicio;
    --

  --
  RETURN Ln_IdDetalle;
  --
EXCEPTION
  WHEN NO_DATA_FOUND THEN
  --
    RETURN NULL;

  WHEN OTHERS THEN
  --
    RETURN NULL;
  --
END GET_ID_DETALLE_ULTIMA_SOL;

/**
* GET_RD_ID
*
* Función que permite obtener la ip del servicio
*
* @author Kenneth Jimenez <kjimenez@telconet.ec>
* @param number Fn_idServicio
* @return string Lv_rdId
*/
FUNCTION GET_RD_ID(Fn_idServicio IN INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE
IS
--
  CURSOR C_getRdId(Cn_idServicio  INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT IPERCRDID.VALOR
    FROM INFO_PERSONA_EMPRESA_ROL_CARAC IPERCRDID, 
         INFO_PERSONA_EMPRESA_ROL_CARAC IPERCVRF,
         INFO_SERVICIO SERV,
         ADMI_PRODUCTO AP,
         ADMI_CARACTERISTICA AC
    WHERE IPERCVRF.VALOR = TECNK_SERVICIOS.GET_VALOR_PER_EMP_ROL_CAR(TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERV.ID_SERVICIO,'VRF'),AP.NOMBRE_TECNICO,0,'')
    AND SERV.ID_SERVICIO = Cn_idServicio
    AND SERV.PRODUCTO_ID = AP.ID_PRODUCTO
    AND IPERCVRF.PERSONA_EMPRESA_ROL_CARAC_ID = IPERCRDID.PERSONA_EMPRESA_ROL_CARAC_ID
    AND IPERCRDID.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
    AND AC.DESCRIPCION_CARACTERISTICA = 'RD_ID'
    AND IPERCVRF.ESTADO = 'Activo';
--
  Lv_rdId INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE;
--
BEGIN
  IF C_getRdId%ISOPEN THEN
    CLOSE C_getRdId;
  END IF;
  --
  OPEN C_getRdId(Fn_idServicio);
  --
  FETCH
    C_getRdId
  INTO
    Lv_rdId;
  --
  CLOSE C_getRdId;
  --
  IF Lv_rdId IS NULL THEN
    Lv_rdId  := NULL;
  END IF;
--
  RETURN Lv_rdId;
--
END GET_RD_ID;


/**
 * F_GET_VALOR_DET_ELE_FILTROS
 * Funcion que retorna información acerca del cliente segun los parametros enviados
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 30-09-2016
 * @param  INFO_DETALLE_ELEMENTO.ELEMENTO_ID%TYPE    IN  Fn_ElementoId
 * @param  INFO_DETALLE_ELEMENTO.DETALLE_NOMBRE%TYPE IN  Fv_DetalleNombre
 * @param  INFO_DETALLE_ELEMENTO.ESTADO%TYPE         IN  Fv_Estado
 */
FUNCTION F_GET_VALOR_DET_ELE_FILTROS( Fn_ElementoId    IN INFO_DETALLE_ELEMENTO.ELEMENTO_ID%TYPE,
                                      Fv_DetalleNombre IN INFO_DETALLE_ELEMENTO.DETALLE_NOMBRE%TYPE,
                                      Fv_Estado        IN INFO_DETALLE_ELEMENTO.ESTADO%TYPE )
  RETURN INFO_DETALLE_ELEMENTO.DETALLE_VALOR%TYPE
IS
  --
  Lv_Query        VARCHAR2(1000) := '';
  Lv_valorDetalle VARCHAR2(100)  := '';
  --
BEGIN
  --
  Lv_Query := 'SELECT DETALLE_VALOR                   
                FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO  DETELE                   
                WHERE DETELE.ELEMENTO_ID = :Bn_ElementoId                   
                AND DETELE.DETALLE_NOMBRE = :Bv_DetalleNombre ';
  --
  IF Fv_Estado IS NOT NULL THEN
    --
    Lv_Query := Lv_Query || ' AND DETELE.ESTADO = :Bv_Estado AND ROWNUM<=1';
    --
    EXECUTE IMMEDIATE Lv_Query INTO Lv_valorDetalle USING Fn_ElementoId, Fv_DetalleNombre, Fv_Estado;
    --
  ELSE
    --
    Lv_Query := Lv_Query || ' AND ROWNUM<=1';
    --
    EXECUTE IMMEDIATE Lv_Query INTO Lv_valorDetalle USING Fn_ElementoId, Fv_DetalleNombre;
    --
  END IF;
  --
  RETURN Lv_valorDetalle;
  --
EXCEPTION
WHEN NO_DATA_FOUND THEN
  --
  RETURN NULL;
  --
WHEN OTHERS THEN
  --
  RETURN NULL;
  --
END F_GET_VALOR_DET_ELE_FILTROS;

--
/**
* Función que obtiene la capacidad total de los servicios de una interface
*
* @author Felix Caicedo <facaicedo@telconet.ec>
* @version 1.0 18-06-2020
*
* @param DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE IN Fn_IdInterface
* @return NUMBER
*/
--
FUNCTION F_GET_BW_TOTAL_INTERFACE(
        Fn_IdInterface  IN  DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE,
        Fv_TipoCapacidad  IN  VARCHAR2)
  RETURN NUMBER
IS
    --
    Lv_Estado                       VARCHAR2(15)   := 'Activo';
    Lv_ParametroEstadosServicios    VARCHAR2(45)   := 'ESTADOS_SERVICIOS_BW_INTERFACE';
    Lv_ParametroProductosNot        VARCHAR2(45)   := 'PRODUCTOS_NO_PERMITIDOS_BW_INTERFACE';
    Ln_TotalCapacidad               NUMBER         := 0;

    CURSOR C_getCapacidadTotalInterface(Fn_IdInterface DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE,
                                        Fv_TipoCapacidad VARCHAR2)
    IS
        SELECT
            NVL(SUM(INFO.CAPACIDAD),0) TOTAL_CAPACIDAD
        FROM (
            SELECT
                TRIM(DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SER.ID_SERVICIO,Fv_TipoCapacidad)) CAPACIDAD
            FROM
                DB_COMERCIAL.INFO_SERVICIO SER
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO         TEC ON SER.ID_SERVICIO = TEC.SERVICIO_ID
            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO                 PRO ON SER.PRODUCTO_ID = PRO.ID_PRODUCTO
            WHERE TEC.INTERFACE_ELEMENTO_ID = Fn_IdInterface
            AND EXISTS
            (
                SELECT 1 FROM DB_GENERAL.ADMI_PARAMETRO_DET PARA_EST
                WHERE PARA_EST.PARAMETRO_ID = (
                    SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                    WHERE NOMBRE_PARAMETRO = Lv_ParametroEstadosServicios AND ESTADO = Lv_Estado AND ROWNUM = 1 )
                AND PARA_EST.ESTADO = Lv_Estado AND PARA_EST.VALOR1 = SER.ESTADO
            )
            AND NOT EXISTS
            (
                SELECT 1 FROM DB_GENERAL.ADMI_PARAMETRO_DET PARA_PRO
                WHERE PARA_PRO.PARAMETRO_ID = (
                    SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                    WHERE NOMBRE_PARAMETRO = Lv_ParametroProductosNot AND ESTADO = Lv_Estado AND ROWNUM = 1 )
                AND PARA_PRO.ESTADO = Lv_Estado AND PARA_PRO.VALOR1 = SER.PRODUCTO_ID
            )
            AND NOT EXISTS
            (
                SELECT 1
                FROM (
                    SELECT
                        TRIM(DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SER.ID_SERVICIO,Fv_TipoCapacidad)) CAPACIDAD
                    FROM
                        DB_COMERCIAL.INFO_SERVICIO SER
                    INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO         TEC ON SER.ID_SERVICIO = TEC.SERVICIO_ID
                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO                 PRO ON SER.PRODUCTO_ID = PRO.ID_PRODUCTO
                    WHERE TEC.INTERFACE_ELEMENTO_ID = Fn_IdInterface
                    AND EXISTS
                    (
                        SELECT 1 FROM DB_GENERAL.ADMI_PARAMETRO_DET PARA_EST
                        WHERE PARA_EST.PARAMETRO_ID = (
                            SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                            WHERE NOMBRE_PARAMETRO = Lv_ParametroEstadosServicios AND ESTADO = Lv_Estado AND ROWNUM = 1 )
                        AND PARA_EST.ESTADO = Lv_Estado AND PARA_EST.VALOR1 = SER.ESTADO
                    )
                    AND NOT EXISTS
                    (
                        SELECT 1 FROM DB_GENERAL.ADMI_PARAMETRO_DET PARA_PRO
                        WHERE PARA_PRO.PARAMETRO_ID = (
                            SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                            WHERE NOMBRE_PARAMETRO = Lv_ParametroProductosNot AND ESTADO = Lv_Estado AND ROWNUM = 1 )
                        AND PARA_PRO.ESTADO = Lv_Estado AND PARA_PRO.VALOR1 = SER.PRODUCTO_ID
                    )
                ) CAP
                WHERE TRIM(TRANSLATE(CAP.CAPACIDAD, '0123456789', ' ')) IS NOT NULL
            )
        ) INFO;
    --
BEGIN
    --
    IF C_getCapacidadTotalInterface%ISOPEN THEN
        CLOSE C_getCapacidadTotalInterface;
    END IF;
    --
    OPEN C_getCapacidadTotalInterface(Fn_IdInterface,Fv_TipoCapacidad);
    --
    FETCH
        C_getCapacidadTotalInterface
    INTO
        Ln_TotalCapacidad;
    --
    CLOSE C_getCapacidadTotalInterface;
    --
    IF Ln_TotalCapacidad IS NULL THEN
      Ln_TotalCapacidad  := 0;
    END IF;
    --
    RETURN Ln_TotalCapacidad;
END F_GET_BW_TOTAL_INTERFACE;

/**
 * P_WS_GET_ROL_CLIENTE
 * Funcion que retorna información acerca del cliente segun los parametros enviados
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 30-09-2016
 *
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.1 15-12-2016    Se agrega un nivel de filtrado de rol del cliente en el query para recuperar informacion
 *                            del cliente consultado
 *
 * @author Héctor Lozano <hlozano@telconet.ec>
 * @version 1.2 06-12-2018    Se agrega el campo OFICINA_ID, para ser consultado en el query principal. 
 *
 * @param  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE         IN Pv_EmpresaCod
 * @param  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE  IN Pv_Identificacion
 * @param  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE                     IN Pv_Login
 * @param  DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE     IN Pv_SerieOnt
 * @param  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE      IN Pv_MacOnt
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_WS_GET_ROL_CLIENTE( Pv_EmpresaCod     IN DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                                Pv_Identificacion IN DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                Pv_Login          IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                Pv_SerieOnt       IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE,
                                Pv_MacOnt         IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                Prf_Result        OUT Lrf_Result,
                                Pv_Status         OUT VARCHAR2,
                                Pv_Mensaje        OUT VARCHAR2 )
IS
  Lv_EstadoActivo    VARCHAR2(15)   := 'Activo';
  Lv_EstadoInCorte   VARCHAR2(15)   := 'In-Corte';
  Lv_EstadoEnPruebas VARCHAR2(15)   := 'EnPruebas';
  Lv_EstadoEnVerifi  VARCHAR2(15)   := 'EnVerificacion';
  Lv_DescRol         VARCHAR2(7)    := 'Cliente';
  Lv_RowNum          NUMBER         := 1;
  Lv_CaractOnt       VARCHAR2(30)   := 'MAC ONT';
  Lv_Query           VARCHAR2(5000) := '';
  Lv_SelectA         VARCHAR2(1000)  := '';
  Lv_SelectB         VARCHAR2(1000)  := '';
  Lv_SelectC         VARCHAR2(1000)  := '';
  Lv_FromA           VARCHAR2(1000)  := '';
  Lv_FromB           VARCHAR2(1000)  := '';
  Lv_FromC           VARCHAR2(1000)  := '';
  Lv_FromD           VARCHAR2(1000)  := '';
  Lv_FromE           VARCHAR2(1000)  := '';
  Lv_WhereA          VARCHAR2(1000)  := '';
  Lv_WhereB          VARCHAR2(1000)  := '';
  Lv_WhereC          VARCHAR2(1000)  := '';
  Lv_WhereD          VARCHAR2(1000)  := '';
  Lv_WhereE          VARCHAR2(1000)  := '';
  Lv_WhereF          VARCHAR2(1000)  := '';
BEGIN
  Lv_SelectA := 'SELECT DB_COMERCIAL.PERSONA_EMPRESA_ROL.ID_PERSONA_ROL ID_PERSONA_ROL,        
                PERSONA_EMPRESA_ROL.OFICINA_ID OFICINA_ID,                       
                PERSONA.IDENTIFICACION_CLIENTE IDENTIFICACION_CLIENTE,                                                
                CASE                                                  
                WHEN PERSONA.RAZON_SOCIAL IS NOT NULL                                                  
                THEN PERSONA.RAZON_SOCIAL                                                  
                ELSE PERSONA.NOMBRES                                                    
                || '' ''                                                    
                || PERSONA.APELLIDOS                                                
                END NOMBRES, ';
  Lv_SelectB := ''''' LOGIN ';
  Lv_SelectC := 'PUNTO.LOGIN LOGIN ';
  Lv_FromA   := 'FROM DB_COMERCIAL.INFO_PERSONA PERSONA                                             
                 INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_EMPRESA_ROL 
                 ON PERSONA.ID_PERSONA = PERSONA_EMPRESA_ROL.PERSONA_ID                                             
                 INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL 
                 ON PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID = EMPRESA_ROL.ID_EMPRESA_ROL                                             
                 INNER JOIN DB_COMERCIAL.ADMI_ROL ROL ON EMPRESA_ROL.ROL_ID = ROL.ID_ROL 
                 INNER JOIN DB_COMERCIAL.ADMI_TIPO_ROL TIPO_ROL ON TIPO_ROL.ID_TIPO_ROL = ROL.TIPO_ROL_ID ';
  Lv_FromB   := 'INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO 
                 ON PUNTO.PERSONA_EMPRESA_ROL_ID = PERSONA_EMPRESA_ROL.ID_PERSONA_ROL ';
  Lv_FromC   := 'INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO ON SERVICIO.PUNTO_ID = PUNTO.ID_PUNTO ';
  Lv_FromD   := 'INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO 
                 ON SERVICIO_TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO                                             
                 INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO_ONT 
                 ON ELEMENTO_ONT.ID_ELEMENTO = SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID ';
  Lv_FromE   := 'INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SERVICIO_PROD_C 
                 ON SERVICIO_PROD_C.SERVICIO_ID = SERVICIO.ID_SERVICIO                                             
                 INNER JOIN ADMI_PRODUCTO_CARACTERISTICA PROD_CARACT 
                 ON PROD_CARACT.ID_PRODUCTO_CARACTERISITICA = SERVICIO_PROD_C.PRODUCTO_CARACTERISITICA_ID                                             
                 INNER JOIN ADMI_CARACTERISTICA CARACT ON CARACT.ID_CARACTERISTICA = PROD_CARACT.CARACTERISTICA_ID ';
  Lv_WhereA  := 'WHERE EMPRESA_ROL.EMPRESA_COD = :paramEmpresaCod                                              
                 AND PERSONA_EMPRESA_ROL.ESTADO = :paramEstadoActivo                                              
                 AND TIPO_ROL.DESCRIPCION_TIPO_ROL = :paramDescRol ';
  Lv_WhereB  := 'AND PERSONA.IDENTIFICACION_CLIENTE = :paramIdentificacion ';
  Lv_WhereC  := 'AND PUNTO.ESTADO IN (:paramEstadoActivo4,:paramEstadoInCorte2)                                              
                 AND PUNTO.LOGIN = :paramLogin ';
  Lv_WhereD  := 'AND SERVICIO.PLAN_ID IS NOT NULL                                              
                 AND SERVICIO.ESTADO IN (:paramEstadoActivo5 , :paramEstadoInCorte3 , :paramEstadoEnPruebas , :paramEnVerificacion) ';
  Lv_WhereE  := 'AND ELEMENTO_ONT.ESTADO        = :paramEstadoActivo2                                              
                 AND ELEMENTO_ONT.SERIE_FISICA  = :paramSerioOnt                                              
                 AND ROWNUM                    <= :paramRowNum ';
  Lv_WhereF  := 'AND CARACT.DESCRIPCION_CARACTERISTICA = :paramCaractOnt                                              
                 AND PERSONA_EMPRESA_ROL.ESTADO = :paramEstadoActivo2                                              
                 AND SERVICIO_PROD_C.ESTADO     = :paramEstadoActivo3                                              
                 AND SERVICIO_PROD_C.VALOR      = :paramMacOnt                                              
                 AND ROWNUM                    <= :paramRowNum ';

  IF Pv_Identificacion IS NOT NULL THEN
    Lv_Query           := Lv_SelectA || Lv_SelectB || Lv_FromA || Lv_WhereA || Lv_WhereB;
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Pv_Identificacion;
  ELSIF Pv_Login IS NOT NULL THEN
    Lv_Query     := Lv_SelectA || Lv_SelectC || Lv_FromA || Lv_FromB || Lv_WhereA || Lv_WhereC;
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Lv_EstadoActivo, Lv_EstadoInCorte, Pv_Login;
  ELSIF Pv_SerieOnt IS NOT NULL THEN
    Lv_Query        := Lv_SelectA || Lv_SelectC || Lv_FromA || Lv_FromB || Lv_FromC || Lv_FromD || Lv_WhereA || Lv_WhereD || Lv_WhereE;
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Lv_EstadoActivo, Lv_EstadoInCorte, 
                                       Lv_EstadoEnPruebas, Lv_EstadoEnVerifi, Lv_EstadoActivo, Pv_SerieOnt, Lv_RowNum;
  ELSE
    Lv_Query := Lv_SelectA || Lv_SelectC || Lv_FromA || Lv_FromB || Lv_FromC || Lv_FromE || Lv_WhereA || Lv_WhereD || Lv_WhereF;
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Lv_EstadoActivo, Lv_EstadoInCorte, Lv_EstadoEnPruebas, 
                                       Lv_EstadoEnVerifi, Lv_CaractOnt, Lv_EstadoActivo, Lv_EstadoActivo, Pv_MacOnt, Lv_RowNum;
  END IF;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_ROL_CLIENTE;

/**
 * P_WS_GET_ROL_CLIENTE_EXT
 * Funcion que retorna información acerca del cliente segun los parametros enviados, y estados parametrizados
 * para extranet
 * @author Jose Bedon <jobedon@telconet.ec>
 * @version 1.0 22-04-2020
 *
 * @author Jean Pierre Nazareno Martinez <jnazareno@telconet.ec>
 * @version 1.1 14-02-2022 - Se parametrizan los estados del punto permitidos para la consulta del cliente.
 *
 * @param  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE         IN Pv_EmpresaCod
 * @param  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE  IN Pv_Identificacion
 * @param  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE                     IN Pv_Login
 * @param  DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE     IN Pv_TipoRol
 * @param  DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE     IN Pv_SerieOnt
 * @param  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE      IN Pv_MacOnt
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_WS_GET_ROL_CLIENTE_EXT( Pv_EmpresaCod     IN DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                                    Pv_Identificacion IN DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                    Pv_Login          IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                    Pv_TipoRol        IN DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
                                    Pv_SerieOnt       IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE,
                                    Pv_MacOnt         IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                    Prf_Result        OUT Lrf_Result,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2 )
IS
  Lv_EstadoActivo    VARCHAR2(15)   := 'Activo';
  Lv_EstadoInCorte   VARCHAR2(15)   := 'In-Corte';
  Lv_EstadoEnPruebas VARCHAR2(15)   := 'EnPruebas';
  Lv_EstadoEnVerifi  VARCHAR2(15)   := 'EnVerificacion';
  Lv_DescRol         VARCHAR2(7)    := 'Cliente';
  Lv_ParamEstadosPun VARCHAR2(40)   := 'ESTADOS_PUNTO_P_WS_GET_ROL_CLIENTE_EXT';
  Lv_RowNum          NUMBER         := 1;
  Lv_CaractOnt       VARCHAR2(30)   := 'MAC ONT';
  Lv_Query           VARCHAR2(7000) := '';
  Lv_SelectA         VARCHAR2(1000)  := '';
  Lv_SelectB         VARCHAR2(1000)  := '';
  Lv_SelectC         VARCHAR2(1000)  := '';
  Lv_FromA           VARCHAR2(1000)  := '';
  Lv_FromB           VARCHAR2(1000)  := '';
  Lv_FromC           VARCHAR2(1000)  := '';
  Lv_FromD           VARCHAR2(1000)  := '';
  Lv_FromE           VARCHAR2(1000)  := '';
  Lv_WhereA          VARCHAR2(2000)  := '';
  Lv_WhereB          VARCHAR2(1000)  := '';
  Lv_WhereC          VARCHAR2(1000)  := '';
  Lv_WhereD          VARCHAR2(1000)  := '';
  Lv_WhereE          VARCHAR2(1000)  := '';
  Lv_WhereF          VARCHAR2(1000)  := '';
  Lv_WhereG          VARCHAR2(1000)  := '';
  Lv_Order           VARCHAR2(1000)  := '';
BEGIN
  Lv_SelectA := 'SELECT DB_COMERCIAL.PERSONA_EMPRESA_ROL.ID_PERSONA_ROL ID_PERSONA_ROL,        
                PERSONA_EMPRESA_ROL.OFICINA_ID OFICINA_ID,                       
                PERSONA.IDENTIFICACION_CLIENTE IDENTIFICACION_CLIENTE,                                                
                CASE                                                  
                WHEN PERSONA.RAZON_SOCIAL IS NOT NULL                                                  
                THEN PERSONA.RAZON_SOCIAL                                                  
                ELSE PERSONA.NOMBRES                                                    
                || '' ''                                                    
                || PERSONA.APELLIDOS                                                
                END NOMBRES,
                PERSONA_EMPRESA_ROL.ESTADO, ';
  Lv_SelectB := ''''' LOGIN ';
  Lv_SelectC := 'PUNTO.LOGIN LOGIN ';
  Lv_FromA   := 'FROM DB_COMERCIAL.INFO_PERSONA PERSONA                                             
                 INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_EMPRESA_ROL 
                 ON PERSONA.ID_PERSONA = PERSONA_EMPRESA_ROL.PERSONA_ID                                             
                 INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL 
                 ON PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID = EMPRESA_ROL.ID_EMPRESA_ROL                                             
                 INNER JOIN DB_COMERCIAL.ADMI_ROL ROL ON EMPRESA_ROL.ROL_ID = ROL.ID_ROL 
                 INNER JOIN DB_COMERCIAL.ADMI_TIPO_ROL TIPO_ROL ON TIPO_ROL.ID_TIPO_ROL = ROL.TIPO_ROL_ID ';
  Lv_FromB   := 'INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO 
                 ON PUNTO.PERSONA_EMPRESA_ROL_ID = PERSONA_EMPRESA_ROL.ID_PERSONA_ROL ';
  Lv_FromC   := 'INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO ON SERVICIO.PUNTO_ID = PUNTO.ID_PUNTO ';
  Lv_FromD   := 'INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO 
                 ON SERVICIO_TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO                                             
                 INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO_ONT 
                 ON ELEMENTO_ONT.ID_ELEMENTO = SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID ';
  Lv_FromE   := 'INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SERVICIO_PROD_C 
                 ON SERVICIO_PROD_C.SERVICIO_ID = SERVICIO.ID_SERVICIO                                             
                 INNER JOIN ADMI_PRODUCTO_CARACTERISTICA PROD_CARACT 
                 ON PROD_CARACT.ID_PRODUCTO_CARACTERISITICA = SERVICIO_PROD_C.PRODUCTO_CARACTERISITICA_ID                                             
                 INNER JOIN ADMI_CARACTERISTICA CARACT ON CARACT.ID_CARACTERISTICA = PROD_CARACT.CARACTERISTICA_ID ';
  Lv_WhereA  := 'WHERE EMPRESA_ROL.EMPRESA_COD = :paramEmpresaCod                                              
                 AND (PERSONA_EMPRESA_ROL.ESTADO = :paramEstadoActivo                                              
                  OR PERSONA_EMPRESA_ROL.ESTADO IN (SELECT REGEXP_SUBSTR(EST.ESTADOS, ''[^,]+'', 1, LEVEL) AS ESTADO
                    FROM
                      (SELECT APD.VALOR1 AS ESTADOS
                      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                      WHERE APD.DESCRIPCION = ''ESTADOS_EMPRESA_ROL''
                      AND APD.PARAMETRO_ID  =
                        (SELECT APC.ID_PARAMETRO
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                        WHERE APC.NOMBRE_PARAMETRO = ''EXTRANET_WS_INFOCLIENTE''
                        )
                      ) EST
                      CONNECT BY REGEXP_SUBSTR(EST.ESTADOS, ''[^,]+'', 1, LEVEL) IS NOT NULL
                 ) ) 
                 AND (TIPO_ROL.DESCRIPCION_TIPO_ROL = :paramDescRol 
                  OR TIPO_ROL.DESCRIPCION_TIPO_ROL  IN 
                    (SELECT REGEXP_SUBSTR(EST.ESTADOS, ''[^,]+'', 1, LEVEL) AS ESTADO 
                    FROM 
                      (SELECT APD.VALOR1 AS ESTADOS 
                      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD 
                      WHERE APD.DESCRIPCION = ''ROLES_CLIENTES'' 
                      AND APD.PARAMETRO_ID  = 
                        (SELECT APC.ID_PARAMETRO 
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC 
                        WHERE APC.NOMBRE_PARAMETRO = ''EXTRANET_WS_INFOCLIENTE'' 
                        ) 
                      ) EST 
                      CONNECT BY REGEXP_SUBSTR(EST.ESTADOS, ''[^,]+'', 1, LEVEL) IS NOT NULL 
                    ) ) 
                 AND EXISTS (SELECT 1 FROM INFO_PUNTO IPT WHERE IPT.PERSONA_EMPRESA_ROL_ID = PERSONA_EMPRESA_ROL.ID_PERSONA_ROL) ';
  Lv_WhereB  := 'AND PERSONA.IDENTIFICACION_CLIENTE = :paramIdentificacion ';
  Lv_WhereC  := 'AND PUNTO.ESTADO IN (SELECT DET.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB, DB_GENERAL.ADMI_PARAMETRO_DET DET 
                                        WHERE CAB.NOMBRE_PARAMETRO = :paramEstadosPunto
                                        AND CAB.ESTADO             = :paramEstadoActivo4
                                        AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                        AND DET.ESTADO             = :paramEstadoActivo6)                                              
                 AND PUNTO.LOGIN = :paramLogin ';
  Lv_WhereD  := 'AND SERVICIO.PLAN_ID IS NOT NULL                                              
                 AND SERVICIO.ESTADO IN (:paramEstadoActivo5 , :paramEstadoInCorte3 , :paramEstadoEnPruebas , :paramEnVerificacion) ';
  Lv_WhereE  := 'AND ELEMENTO_ONT.ESTADO        = :paramEstadoActivo2                                              
                 AND ELEMENTO_ONT.SERIE_FISICA  = :paramSerioOnt                                              
                 AND ROWNUM                    <= :paramRowNum ';
  Lv_WhereF  := 'AND CARACT.DESCRIPCION_CARACTERISTICA = :paramCaractOnt                                              
                 AND PERSONA_EMPRESA_ROL.ESTADO = :paramEstadoActivo2                                              
                 AND SERVICIO_PROD_C.ESTADO     = :paramEstadoActivo3                                              
                 AND SERVICIO_PROD_C.VALOR      = :paramMacOnt                                              
                 AND ROWNUM                    <= :paramRowNum ';

  Lv_WhereG  := ' AND TIPO_ROL.DESCRIPCION_TIPO_ROL = :paramTipoRol  ';

  Lv_Order   :=  ' ORDER BY PERSONA_EMPRESA_ROL.ESTADO ';

  IF Pv_Identificacion IS NOT NULL THEN
  
     IF Pv_TipoRol IS NOT NULL THEN
       
        Lv_Query          := Lv_SelectA || Lv_SelectB || Lv_FromA || Lv_WhereA || Lv_WhereB || Lv_WhereG|| Lv_Order;
     
        OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Pv_Identificacion, Pv_TipoRol;
    
     ELSE
    
        Lv_Query           := Lv_SelectA || Lv_SelectB || Lv_FromA || Lv_WhereA || Lv_WhereB;
     
        OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Pv_Identificacion;
    
    END IF;  

  ELSIF Pv_Login IS NOT NULL THEN
    Lv_Query     := Lv_SelectA || Lv_SelectC || Lv_FromA || Lv_FromB || Lv_WhereA || Lv_WhereC;
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Lv_ParamEstadosPun, Lv_EstadoActivo, Lv_EstadoActivo, Pv_Login;
  ELSIF Pv_SerieOnt IS NOT NULL THEN
    Lv_Query        := Lv_SelectA || Lv_SelectC || Lv_FromA || Lv_FromB || Lv_FromC || Lv_FromD || Lv_WhereA || Lv_WhereD || Lv_WhereE;
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Lv_EstadoActivo, Lv_EstadoInCorte, 
                                       Lv_EstadoEnPruebas, Lv_EstadoEnVerifi, Lv_EstadoActivo, Pv_SerieOnt, Lv_RowNum;
  ELSE
    Lv_Query := Lv_SelectA || Lv_SelectC || Lv_FromA || Lv_FromB || Lv_FromC || Lv_FromE || Lv_WhereA || Lv_WhereD || Lv_WhereF;
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_DescRol, Lv_EstadoActivo, Lv_EstadoInCorte, Lv_EstadoEnPruebas, 
                                       Lv_EstadoEnVerifi, Lv_CaractOnt, Lv_EstadoActivo, Lv_EstadoActivo, Pv_MacOnt, Lv_RowNum;
  END IF;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_ROL_CLIENTE_EXT;

/**
 * P_WS_GET_PUNTOS_CLIENTE
 * Funcion que retorna información acerca de puntos de un cliente segun los parametros enviados
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 30-09-2016
 *
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.1 15-10-2018 Se modifica recuperación de correos del cliente y se agrega parámetro nuevo SALDO del punto del cliente
 * @since 1.0
 * 
 * @author Jose Bedon <jobedon@telconet.ec>
 * @version 1.2 20-04-2020 Se parametrizan estados permitidos para los puntos
 *
 * @param  VARCHAR2   IN Pv_EmpresaCod
 * @param  NUMBER     IN Pn_RolCliente
 * @param  VARCHAR2   IN Pv_Login
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_WS_GET_PUNTOS_CLIENTE(  Pv_EmpresaCod IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                                    Pn_RolCliente IN DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE,
                                    Pv_Login      IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                    Prf_Result    OUT Lrf_Result,
                                    Pv_Status     OUT VARCHAR2,
                                    Pv_Mensaje    OUT VARCHAR2 )
IS
  Lv_EstadoActivo  VARCHAR2(15)   := 'Activo';
  Lv_EstadoInCorte VARCHAR2(15)   := 'In-Corte';
  Lv_Query         VARCHAR2(4000) := '';
  Lv_Where         VARCHAR2(50)   := '';
BEGIN 
  Lv_Query := ' SELECT PUNTO.ID_PUNTO ID_PUNTO,                  
                PUNTO.LOGIN LOGIN,                  
                PUNTO.DIRECCION,                  
                JURI.NOMBRE_JURISDICCION ,                  
                PUNTO.ESTADO,                  
                PUNTO.LONGITUD,                  
                PUNTO.LATITUD,                  
                SECTOR.NOMBRE_SECTOR SECTOR,                  
                CANTON.NOMBRE_CANTON CIUDAD,                  
                ( SELECT LISTAGG(INFO_PUNTO_FORMA_CONTACTO.VALOR, '';'')                  
                WITHIN GROUP (ORDER BY INFO_PUNTO_FORMA_CONTACTO.PUNTO_ID)                  
                FROM INFO_PUNTO_FORMA_CONTACTO, ADMI_FORMA_CONTACTO                  
                WHERE   PUNTO.ID_PUNTO     = INFO_PUNTO_FORMA_CONTACTO.PUNTO_ID                 
                AND INFO_PUNTO_FORMA_CONTACTO.FORMA_CONTACTO_ID = ADMI_FORMA_CONTACTO.ID_FORMA_CONTACTO AND 
                DESCRIPCION_FORMA_CONTACTO IN (''Telefono Movil'',''Telefono Fijo'',''Telefono Movil Claro'',
                ''Telefono Movil Movistar'',''Telefono Movil CNT'',''Telefono Traslado''                 
                ) AND rownum <=2) TELEFONOS,                 
                NVL(TRIM(DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(PUNTO.ID_PUNTO, ''MAIL'')),'''')  CORREOS,
                TRIM(TO_CHAR(TRUNC(NVL(DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_SALDO_CLIENTE_BY_PUNTO(PUNTO.ID_PUNTO), 0),2),''99999999990D99'')) SALDO
                FROM DB_COMERCIAL.INFO_PUNTO PUNTO                
                LEFT JOIN DB_COMERCIAL.ADMI_SECTOR SECTOR ON SECTOR.ID_SECTOR = PUNTO.SECTOR_ID                
                LEFT JOIN DB_COMERCIAL.admi_parroquia PARROQUIA ON SECTOR.PARROQUIA_ID = PARROQUIA.id_parroquia                 
                LEFT JOIN DB_COMERCIAL.ADMI_CANTON CANTON ON PARROQUIA.canton_id = CANTON.ID_CANTON                 
                LEFT JOIN DB_INFRAESTRUCTURA.admi_jurisdiccion JURI ON punto.punto_cobertura_id = JURI.ID_JURISDICCION                
                JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER  ON IPER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
                JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
                WHERE IER.EMPRESA_COD        = :paramEmpresaCod                
                AND (
                  PUNTO.ESTADO IN (:paramEstadoActivo,:paramEstadoInCorte)                
                  OR PUNTO.ESTADO IN (SELECT REGEXP_SUBSTR(EST.ESTADOS, ''[^,]+'', 1, LEVEL) AS ESTADO
                    FROM
                      (SELECT APD.VALOR1 AS ESTADOS
                      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                      WHERE APD.DESCRIPCION = ''ESTADOS_PUNTO''
                      AND APD.PARAMETRO_ID  =
                        (SELECT APC.ID_PARAMETRO
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                        WHERE APC.NOMBRE_PARAMETRO = ''EXTRANET_WS_INFOCLIENTE''
                        )
                      ) EST
                      CONNECT BY REGEXP_SUBSTR(EST.ESTADOS, ''[^,]+'', 1, LEVEL) IS NOT NULL)
                )
                AND PUNTO.PERSONA_EMPRESA_ROL_ID= :paramRolCliente ';
  Lv_Where    := 'AND PUNTO.LOGIN= :paramLogin ';
  IF Pv_Login IS NULL THEN
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_EstadoInCorte, Pn_RolCliente;
  ELSE
    Lv_Query := Lv_Query || Lv_Where;
    OPEN Prf_Result FOR Lv_Query USING Pv_EmpresaCod, Lv_EstadoActivo, Lv_EstadoInCorte, Pn_RolCliente, Pv_Login;
  END IF;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_PUNTOS_CLIENTE;
/**
 * P_WS_GET_SERVICIOS_PTO_CLIENTE
 * Funcion que retorna información acerca de servicios delpunto de un cliente segun los parametros enviados
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 30-09-2016
 *
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.1 20-04-2018   Se agrega campo Nombre Tecnico para incluir servicios Small business
 * @since 1.0
 * 
 * @author Jose Bedon <jobedon@telconet.ec>
 * @version 1.2 20-04-2020 Se parametrizan estados permitidos para los servicios
 * 
 * @author Richard Cabrera <rcabrera@telconet.ec>
 * @version 1.3 06-06-20201 Se adicionan campos requeridos por consulta de Servicios con nueva red GPON-MPLS
 *
 * @param  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE     IN  Pn_IdPuntoCliente
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_WS_GET_SERVICIOS_PTO_CLIENTE( Pn_IdPuntoCliente IN DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                          Prf_Result        OUT Lrf_Result,
                                          Pv_Status         OUT VARCHAR2,
                                          Pv_Mensaje        OUT VARCHAR2 )
IS
  Lv_EstadoActivo  VARCHAR2(15)   := 'Activo';
  Lv_EstadoInCorte VARCHAR2(15)   := 'In-Corte';
  Ln_IdPlanCero    NUMBER         := 0;
  Lv_Query         CLOB;
BEGIN
  Lv_Query := ' SELECT SERVICIO.ID_SERVICIO,
              PROD.CODIGO_PRODUCTO,
              SERVICIO.PUNTO_ID,
              CASE                    
              WHEN PROD1.ID_PRODUCTO IS NOT NULL                    
              THEN PROD1.ID_PRODUCTO                    
              ELSE PROD.ID_PRODUCTO                  
              END ID_PRODUCTO,
              (SERVICIO.PRECIO_VENTA*SERVICIO.CANTIDAD) PRECIO,                  
              SERVICIO.ESTADO,                  
              CASE                    
              WHEN PROD1.DESCRIPCION_PRODUCTO IS NOT NULL                    
              THEN PROD1.DESCRIPCION_PRODUCTO                    
              ELSE PROD.DESCRIPCION_PRODUCTO                  
              END DESCRIPCION_PRODUCTO,
              CASE                    
              WHEN PROD1.CODIGO_PRODUCTO IS NOT NULL                    
              THEN PROD1.CODIGO_PRODUCTO                    
              ELSE PROD.CODIGO_PRODUCTO                  
              END CODIGO_PRODUCTO,
              PLANC.ID_PLAN,
              PLANC.NOMBRE_PLAN,                  
              UM.NOMBRE_TIPO_MEDIO,
              PROD1.NOMBRE_TECNICO,
              SERVICIO.LOGIN_AUX,
              (SELECT CODIGO_PLAN FROM DB_COMERCIAL.INFO_PLAN_CAB where ID_PLAN=PLANC.ID_PLAN)CODIGO_PLAN,
              
              (NVL((SELECT ISPC.VALOR FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC WHERE ISPC.SERVICIO_ID = SERVICIO.ID_SERVICIO AND ISPC.ESTADO = ''Activo''
              AND ISPC.PRODUCTO_CARACTERISITICA_ID = (SELECT ID_PRODUCTO_CARACTERISITICA 
              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC WHERE APC.PRODUCTO_ID = (CASE                    
                                                                                          WHEN PROD1.ID_PRODUCTO IS NOT NULL                    
                                                                                          THEN PROD1.ID_PRODUCTO                    
                                                                                          ELSE PROD.ID_PRODUCTO                  
                                                                                          END) 
              AND APC.ESTADO = ''Activo'' 
              AND APC.CARACTERISTICA_ID = (SELECT AC.ID_CARACTERISTICA FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC 
              WHERE AC.DESCRIPCION_CARACTERISTICA = ''TIPO_RED'' AND AC.ESTADO = ''Activo''))),''MPLS'')) SERVICIO,
              
              (SELECT IP FROM DB_INFRAESTRUCTURA.INFO_IP WHERE ID_IP = (SELECT MAX(ID_IP) 
              FROM DB_INFRAESTRUCTURA.INFO_IP WHERE SERVICIO_ID = SERVICIO.ID_SERVICIO)) IP_SERVICIO,
              
              (NVL((SELECT ISPC.VALOR FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC WHERE ISPC.SERVICIO_ID = SERVICIO.ID_SERVICIO AND ISPC.ESTADO = ''Activo''
              AND ISPC.PRODUCTO_CARACTERISITICA_ID = (SELECT ID_PRODUCTO_CARACTERISITICA 
              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC WHERE APC.PRODUCTO_ID = (CASE                    
                                                                                          WHEN PROD1.ID_PRODUCTO IS NOT NULL                    
                                                                                          THEN PROD1.ID_PRODUCTO                    
                                                                                          ELSE PROD.ID_PRODUCTO                  
                                                                                          END) 
              AND APC.ESTADO = ''Activo'' 
              AND APC.CARACTERISTICA_ID = (SELECT AC.ID_CARACTERISTICA FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC 
              WHERE AC.DESCRIPCION_CARACTERISTICA = ''MAC CLIENTE'' AND AC.ESTADO = ''Activo''))),'''')) MAC_SERVICIO              
                            
              FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO                
              LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TECNICO ON TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO                
              LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO UM ON UM.ID_TIPO_MEDIO = TECNICO.ULTIMA_MILLA_ID                
              LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLANC ON PLANC.ID_PLAN = SERVICIO.PLAN_ID                
              LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET PLAND ON PLAND.PLAN_ID = PLANC.ID_PLAN                
              LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD ON PROD.ID_PRODUCTO = PLAND.PRODUCTO_ID                
              LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD1 ON PROD1.ID_PRODUCTO    = SERVICIO.PRODUCTO_ID                
              WHERE (SERVICIO.ESTADO IN (:paramEstadoActivo,:paramEstadoInCorte)                
                OR SERVICIO.ESTADO IN (SELECT REGEXP_SUBSTR(EST.ESTADOS, ''[^,]+'', 1, LEVEL) AS ESTADO
                    FROM
                      (SELECT APD.VALOR1 AS ESTADOS
                      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                      WHERE APD.DESCRIPCION = ''ESTADOS_SERVICIO''
                      AND APD.PARAMETRO_ID  =
                        (SELECT APC.ID_PARAMETRO
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                        WHERE APC.NOMBRE_PARAMETRO = ''EXTRANET_WS_INFOCLIENTE''
                        )
                      ) EST
                      CONNECT BY REGEXP_SUBSTR(EST.ESTADOS, ''[^,]+'', 1, LEVEL) IS NOT NULL)
              )
              AND ( SERVICIO.PLAN_ID IS NULL                
              OR ( SERVICIO.PLAN_ID   > :paramIdPlanCero                
              AND (PLAND.ESTADO)      = (PLANC.ESTADO) ) )                
              AND SERVICIO.PUNTO_ID   = :paramPuntoId ';
  OPEN Prf_Result FOR Lv_Query USING Lv_EstadoActivo, Lv_EstadoInCorte, Ln_IdPlanCero, Pn_IdPuntoCliente;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_SERVICIOS_PTO_CLIENTE;
/**
 * P_WS_GET_INF_SERVICIO_INTERNET
 * Funcion que retorna información tecnica del servicio de internet del punto de un cliente segun los parametros enviados
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 30-09-2016
 * @author Francisco Adum <fadum@netlife.net.ec>
 * @version 1.1 06-07-2017  Se agrega valor de [ipv4] para saber si el cliente tiene asignada una ipv4 publica
 * @author Jesús Bozada <jbozada@telconet.ec>
 * @version 1.2 16-09-2019  Se agregan parámetros promocionales de BW para ser utilizados en operaciones técnicas del negocio
 * @param  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE     IN  Pn_IdServicioInternet
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_WS_GET_INF_SERVICIO_INTERNET( Pn_IdServicioInternet IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                          Prf_Result            OUT Lrf_Result,
                                          Pv_Status             OUT VARCHAR2,
                                          Pv_Mensaje            OUT VARCHAR2 )
IS
  Lv_EstadoActivo  VARCHAR2(15)   := 'Activo';
  Lv_EstadoInCorte VARCHAR2(15)   := 'In-Corte';
  Ln_IdPlanCero    NUMBER         := 0;
  Lv_Query         VARCHAR2(5000) := '';
BEGIN
  Lv_Query := ' SELECT SERVICIO.ID_SERVICIO,                    
              ELEMENTO.NOMBRE_ELEMENTO elemento,                                       
              IP.IP ip_elemento,                                     
              MODELO.NOMBRE_MODELO_ELEMENTO modelo_elemento,                 
              MARCA.NOMBRE_MARCA_ELEMENTO marca_elemento,                 
              PUERTO.NOMBRE_INTERFACE_ELEMENTO interface_elemento,                    
              CONTENEDOR.NOMBRE_ELEMENTO elemento_contenedor,                 
              CONECTOR.NOMBRE_ELEMENTO elemento_conector,                 
              INTERFACE_CONECTOR.NOMBRE_INTERFACE_ELEMENTO interface_elemento_conector,                 
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''INDICE CLIENTE'') indice_cliente,                 
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''LINE-PROFILE-NAME'') line_profile,
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''PERFIL'') perfil,
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''SPID'') service_port,                 
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''GEM-PORT'') gemport,                 
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''TRAFFIC-TABLE'') traffic_table,
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''LINE-PROFILE-NAME-PROMO'') line_profile_promo,
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''GEM-PORT-PROMO'') gemport_promo,                
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''TRAFFIC-TABLE-PROMO'') traffic_table_promo,
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''PERFIL-PROMO'') perfil_promo,
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''VLAN'') vlan,                 
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''IPV4'') ipv4,                 
              ELEMENTO_CLIENTE.SERIE_FISICA serie_ont,                 
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC ONT'') mac_ont,                 
              MODELO_CLIENTE.NOMBRE_MODELO_ELEMENTO modelo_ont,                 
              MARCA_CLIENTE.NOMBRE_MARCA_ELEMENTO marca_ont,                 
              TECNK_SERVICIOS.F_GET_VALOR_DET_ELE_FILTROS(ELEMENTO.ID_ELEMENTO,''APROVISIONAMIENTO_IP'','''') APROVISIONAMIENTO                 
              FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO                            
              LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TECNICO 
                ON TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO                     
              LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO 
                ON ELEMENTO.ID_ELEMENTO = TECNICO.ELEMENTO_ID                            
              LEFT JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO PUERTO 
                ON PUERTO.ID_INTERFACE_ELEMENTO = TECNICO.INTERFACE_ELEMENTO_ID                     
              LEFT JOIN DB_INFRAESTRUCTURA.INFO_IP IP 
                ON IP.ELEMENTO_ID = ELEMENTO.ID_ELEMENTO                            
              LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO 
                ON MODELO.ID_MODELO_ELEMENTO = ELEMENTO.MODELO_ELEMENTO_ID                 
              LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA 
                ON MODELO.MARCA_ELEMENTO_ID = MARCA.ID_MARCA_ELEMENTO                 
              LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CONTENEDOR 
                ON CONTENEDOR.ID_ELEMENTO = TECNICO.ELEMENTO_CONTENEDOR_ID                 
              LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CONECTOR 
                ON CONECTOR.ID_ELEMENTO = TECNICO.ELEMENTO_CONECTOR_ID                 
              LEFT JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_CONECTOR 
                ON INTERFACE_CONECTOR.ID_INTERFACE_ELEMENTO = TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID                     
              LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO_CLIENTE 
                ON ELEMENTO_CLIENTE.ID_ELEMENTO = TECNICO.ELEMENTO_CLIENTE_ID                 
              LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_CLIENTE 
                ON MODELO_CLIENTE.ID_MODELO_ELEMENTO = ELEMENTO_CLIENTE.MODELO_ELEMENTO_ID                 
              LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_CLIENTE 
                ON MODELO_CLIENTE.MARCA_ELEMENTO_ID = MARCA_CLIENTE.ID_MARCA_ELEMENTO                 
              WHERE SERVICIO.ID_SERVICIO = :paramIdServicioInternet ';
  OPEN Prf_Result FOR Lv_Query USING Pn_IdServicioInternet;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_INF_SERVICIO_INTERNET;
/**
 * P_WS_GET_IPS_POR_PUNTO
 * Funcion que retorna información acerca de Ips del punto de un cliente segun los parametros enviados
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 30-09-2016
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.1 20-10-2016      Se agrego validacion para recuperar MAC de ip de manera correcta
 * @param  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE     IN  Pn_IdPuntoCliente
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_WS_GET_IPS_POR_PUNTO( Pn_IdPuntoCliente IN DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                  Prf_Result        OUT Lrf_Result,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2 )
IS
  Lv_EstadoActivo  VARCHAR2(15)   := 'Activo';
  Lv_EstadoInCorte VARCHAR2(15)   := 'In-Corte';
  Ln_IdPlanCero    NUMBER         := 0;
  Lv_Query         VARCHAR2(1500) := '';
BEGIN
  Lv_Query := ' SELECT IP.IP,                    
              CASE                      
              WHEN TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC'') IS NOT NULL                      
              THEN TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC'')                      
              ELSE TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''MAC ONT'')                    
              END MAC,                    
              IP.MASCARA,                    
              TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''SCOPE'') SCOPE_IP,                    
              CASE                    
              WHEN TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''SCOPE'') IS NULL                    
              THEN TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO.ID_SERVICIO,''POOL IP'')                    
              ELSE ''''                  
              END POOL_IP                  
              FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO                  
              INNER JOIN DB_INFRAESTRUCTURA.INFO_IP IP                  
              ON IP.SERVICIO_ID      = SERVICIO.ID_SERVICIO                  
              WHERE SERVICIO.ESTADO IN (:paramEstadoActivo , :paramEstadoInCorte)                  
              AND IP.ESTADO          = :paramEstadoActivo2                  
              AND SERVICIO.PUNTO_ID  = :paramIdPuntoCliente ';
  OPEN Prf_Result FOR Lv_Query USING Lv_EstadoActivo, Lv_EstadoInCorte, Lv_EstadoActivo, Pn_IdPuntoCliente;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_IPS_POR_PUNTO;
/**
 * P_WS_GET_CASOS_POR_PUNTO
 * Funcion que retorna información acerca de casos del punto de un cliente segun los parametros enviados
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 30-09-2016
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.1 20-10-2016     Se agrega codigo para retornar el ID de los casos encontrados
 * @param  DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE   IN  Pv_Login
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_WS_GET_CASOS_POR_PUNTO( Pv_Login   IN DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE,
                                    Prf_Result OUT Lrf_Result,
                                    Pv_Status  OUT VARCHAR2,
                                    Pv_Mensaje OUT VARCHAR2 )
IS
  Ln_RowNum NUMBER         := 5;
  Lv_Query  VARCHAR2(1500) := '';
BEGIN
  Lv_Query := ' SELECT * FROM (SELECT  B.ID_CASO, B.NUMERO_CASO,                    
              B.TITULO_INI CASO,                    
              E.ESTADO,                    
              TO_CHAR(B.FE_CREACION,''dd/mm/yyyy hh24:mi'') FE_CREACION,                    
              TO_CHAR(B.FE_CIERRE,''dd/mm/yyyy hh24:mi'') FE_CIERRE                                     
              FROM INFO_CASO B,                    
              INFO_DETALLE_HIPOTESIS C,                    
              INFO_DETALLE D,                    
              INFO_PARTE_AFECTADA A,                    
              INFO_CASO_HISTORIAL E                  
              WHERE B.ID_CASO            = C.CASO_ID                  
              AND C.ID_DETALLE_HIPOTESIS = D.DETALLE_HIPOTESIS_ID                  
              AND D.ID_DETALLE           = A.DETALLE_ID                  
              AND B.ID_CASO              = E.CASO_ID                  
              AND E.ID_CASO_HISTORIAL    =                    
              (SELECT MAX(ID_CASO_HISTORIAL)                    
              FROM INFO_CASO_HISTORIAL                    
              WHERE CASO_ID = B.ID_CASO                    
              )                  
              AND A.AFECTADO_NOMBRE = :paramLogin                  
              ORDER BY B.FE_CREACION DESC)                  
              WHERE ROWNUM           <= :paramRowNum ';
  OPEN Prf_Result FOR Lv_Query USING Pv_Login, Ln_RowNum;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_CASOS_POR_PUNTO;
/**
 * P_WS_GET_TAREAS_POR_PUNTO
 * Funcion que retorna información acerca de tareas del punto de un cliente segun los parametros enviados
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 30-09-2016
 * @param  DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE   IN  Pv_Login
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_WS_GET_TAREAS_POR_PUNTO( Pv_Login    IN DB_SOPORTE.INFO_PARTE_AFECTADA.AFECTADO_NOMBRE%TYPE,
                                     Prf_Result  OUT Lrf_Result,
                                     Pv_Status   OUT VARCHAR2,
                                     Pv_Mensaje  OUT VARCHAR2 )
IS
  Ln_RowNum NUMBER         := 5;
  Lv_Query  VARCHAR2(3000) := '';
BEGIN
  Lv_Query := ' SELECT INFORMACION_TAREA.ID_COMUNICACION NUMERO_TAREA,                  
              INFORMACION_TAREA.nombre_TAREA TAREA,                  
              TO_CHAR(INFORMACION_TAREA.FE_CREACION,''dd/mm/yyyy hh24:mi'') FE_CREACION,                  
              CASE                    
              WHEN HISTORIAL_TAREA.ESTADO = ''Finalizada'' or HISTORIAL_TAREA.ESTADO = ''Cancelada''                    
              THEN                     
              TO_CHAR(HISTORIAL_TAREA.FE_CREACION,''dd/mm/yyyy hh24:mi'')                    
              ELSE ''''                  
              END FE_FINALIZACION,                  
              HISTORIAL_TAREA.ESTADO ESTADO                
              FROM                  
              (SELECT TAREA.ID_TAREA,                    
              COMUNICACION.DESCRIPCION_COMUNICACION ,                    
              COMUNICACION.ID_COMUNICACION,                    
              TAREA.nombre_TAREA,                    
              DETALLE.FE_CREACION,                    
              (SELECT MAX(DETALLE_HISTORIAL.ID_DETALLE_HISTORIAL)                    
              FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL DETALLE_HISTORIAL                    
              WHERE DETALLE_HISTORIAL.DETALLE_ID=DETALLE.ID_DETALLE                     
              ) ID_DETALLE_HISTORIAL                  
              FROM DB_SOPORTE.INFO_DETALLE DETALLE                  
              INNER JOIN DB_SOPORTE.Admi_tarea tarea                  
              ON DETALLE.TAREA_ID=tarea.id_tarea                  
              INNER JOIN DB_COMUNICACION.INFO_COMUNICACION COMUNICACION                  
              ON COMUNICACION.DETALLE_ID = DETALLE.ID_DETALLE                  
              INNER JOIN DB_SOPORTE.INFO_PARTE_AFECTADA PARTEAFECTADA                  
              ON PARTEAFECTADA.DETALLE_ID=DETALLE.ID_DETALLE                  
              WHERE AFECTADO_NOMBRE      = :paramLogin                  
              ORDER BY DETALLE.FE_CREACION DESC                  
              ) INFORMACION_TAREA                
              LEFT JOIN DB_SOPORTE.INFO_DETALLE_HISTORIAL HISTORIAL_TAREA                
              ON HISTORIAL_TAREA.ID_DETALLE_HISTORIAL = INFORMACION_TAREA.ID_DETALLE_HISTORIAL                
              WHERE ROWNUM                           <= :paramRowNum ';
  OPEN Prf_Result FOR Lv_Query USING Pv_Login, Ln_RowNum;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_TAREAS_POR_PUNTO;

PROCEDURE P_WS_GET_ONT_ID_POR_PUNTO( Pv_Login       IN  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                     Prf_Result     OUT Lrf_Result,
                                     Pv_Status      OUT VARCHAR2,
                                     Pv_Mensaje     OUT VARCHAR2 )
IS
  Lcl_Query                     CLOB;
  Lv_NombreParametroTecnicoWs   VARCHAR2(28) := 'PARAMS_WEB_SERVICES_TECNICO';
  Lv_NombresTecnInternetWs      VARCHAR2(36) := 'NOMBRES_TECNICOS_PRODS_INTERNET_OSS';
  Lv_ValorProductoPlan          VARCHAR2(14) := 'PRODUCTO_PLAN';
  Lv_ValorProducto              VARCHAR2(9) := 'PRODUCTO';
  Lv_DescCaract                 VARCHAR2(15) := 'INDICE CLIENTE';
  Lv_EstadoActivo               VARCHAR2(15) := 'Activo';
  Lv_EstadoInCorte              VARCHAR2(15) := 'In-Corte';
BEGIN
    Lcl_Query :=   'SELECT SPC.VALOR ONT_ID
                    FROM DB_COMERCIAL.INFO_SERVICIO S 
                    INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO 
                    ON S.PUNTO_ID = PUNTO.ID_PUNTO
                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PC
                    ON PC.ID_PLAN = S.PLAN_ID
                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET PD 
                    ON PD.PLAN_ID = PC.ID_PLAN
                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO P 
                    ON P.ID_PRODUCTO = PD.PRODUCTO_ID
                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO P1 
                    ON P1.ID_PRODUCTO = S.PRODUCTO_ID
                    INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC 
                    ON SPC.SERVICIO_ID = S.ID_SERVICIO
                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PRODCARACT 
                    ON PRODCARACT.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID 
                    INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACTERISTICA
                    ON CARACTERISTICA.ID_CARACTERISTICA = PRODCARACT.CARACTERISTICA_ID
                    WHERE (PRODCARACT.PRODUCTO_ID = P.ID_PRODUCTO OR PRODCARACT.PRODUCTO_ID = P1.ID_PRODUCTO)
                    AND (
                        P.NOMBRE_TECNICO IN (SELECT DET.VALOR3
                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                    ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
                                                    WHERE CAB.NOMBRE_PARAMETRO = :paramNombreParamTecnicoWs1
                                                    AND DET.VALOR1             = :paramNombresTecnInternetWs1
                                                    AND DET.VALOR2             = :paramProductoPlan
                                                    AND CAB.ESTADO             = :paramEstadoActivo1
                                                    AND DET.ESTADO             = :paramEstadoActivo2)
                        OR
                        P1.NOMBRE_TECNICO IN (SELECT DET.VALOR3
                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                    ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
                                                    WHERE CAB.NOMBRE_PARAMETRO = :paramNombreParamTecnicoWs1
                                                    AND DET.VALOR1             = :paramNombresTecnInternetWs1
                                                    AND DET.VALOR2             = :paramProducto
                                                    AND CAB.ESTADO             = :paramEstadoActivo3
                                                    AND DET.ESTADO             = :paramEstadoActivo4)
                    )
                    AND S.ESTADO                                 IN (:paramEstadoActivo, :paramEstadoInCorte)
                    AND SPC.ESTADO                               = :paramEstadoActivo5
                    AND PUNTO.LOGIN                              = :paramLogin
                    AND CARACTERISTICA.DESCRIPCION_CARACTERISTICA= :paramDescCaract ';
  OPEN Prf_Result FOR Lcl_Query 
  USING Lv_NombreParametroTecnicoWs, Lv_NombresTecnInternetWs, Lv_ValorProductoPlan, Lv_EstadoActivo, Lv_EstadoActivo,
        Lv_NombreParametroTecnicoWs, Lv_NombresTecnInternetWs, Lv_ValorProducto, Lv_EstadoActivo, Lv_EstadoActivo,
        Lv_EstadoActivo, Lv_EstadoInCorte, Lv_EstadoActivo, Pv_Login, Lv_DescCaract;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_ONT_ID_POR_PUNTO;

PROCEDURE P_WS_GET_LOGINES_POR_OLT( Pv_Olt       IN DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
                                    Pv_PuertoOlt IN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
                                    Prf_Result   OUT Lrf_Result,
                                    Pv_Status    OUT VARCHAR2,
                                    Pv_Mensaje   OUT VARCHAR2 )
IS
  Lcl_Query                     CLOB;
  Lv_NombreParametroTecnicoWs   VARCHAR2(28) := 'PARAMS_WEB_SERVICES_TECNICO';
  Lv_NombresTecnInternetWs      VARCHAR2(36) := 'NOMBRES_TECNICOS_PRODS_INTERNET_OSS';
  Lv_ValorProductoPlan          VARCHAR2(14) := 'PRODUCTO_PLAN';
  Lv_ValorProducto              VARCHAR2(9) := 'PRODUCTO';
  Lv_EstadoConnected            VARCHAR2(15) := 'connected';
  Lv_EstadoActivo               VARCHAR2(15) := 'Activo';
  Lv_EstadoInCorte              VARCHAR2(15) := 'In-Corte';
BEGIN
  Lcl_Query := 'SELECT CAJA.NOMBRE_ELEMENTO CAJA,                    
                SPLITTER.NOMBRE_ELEMENTO SPLITTER_L2,                    
                LISTAGG(PUNTO.LOGIN , '';'')
                WITHIN GROUP (ORDER BY PUNTO.LOGIN) LOGINES       
                FROM DB_COMERCIAL.INFO_PUNTO PUNTO                  
                INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO                  
                ON PUNTO.ID_PUNTO=SERVICIO.PUNTO_ID 
                LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
                ON SERVICIO.PLAN_ID = PLAN_CAB.ID_PLAN 
                LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                ON PLAN_CAB.ID_PLAN = PLAN_DET.PLAN_ID 
                LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                ON PLAN_DET.PRODUCTO_ID = PRODUCTO.ID_PRODUCTO 
                LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO1 
                ON PRODUCTO1.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO                  
                ON SERVICIO_TECNICO.SERVICIO_ID=SERVICIO.ID_SERVICIO                  
                INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT                  
                ON SERVICIO_TECNICO.ELEMENTO_ID=OLT.ID_ELEMENTO                  
                INNER JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO PUERTO_OLT                  
                ON SERVICIO_TECNICO.INTERFACE_ELEMENTO_ID=PUERTO_OLT.ID_INTERFACE_ELEMENTO                  
                INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CAJA                  
                ON SERVICIO_TECNICO.ELEMENTO_CONTENEDOR_ID=CAJA.ID_ELEMENTO                  
                INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO SPLITTER                  
                ON SERVICIO_TECNICO.ELEMENTO_CONECTOR_ID =SPLITTER.ID_ELEMENTO                  
                WHERE (
                    PRODUCTO.NOMBRE_TECNICO IN (SELECT DET.VALOR3
                                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
                                                WHERE CAB.NOMBRE_PARAMETRO = :paramNombreParamTecnicoWs1
                                                AND DET.VALOR1             = :paramNombresTecnInternetWs1
                                                AND DET.VALOR2             = :paramProductoPlan
                                                AND CAB.ESTADO             = :paramEstadoActivo1
                                                AND DET.ESTADO             = :paramEstadoActivo2)
                    OR
                    PRODUCTO1.NOMBRE_TECNICO IN (SELECT DET.VALOR3
                                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
                                                WHERE CAB.NOMBRE_PARAMETRO = :paramNombreParamTecnicoWs1
                                                AND DET.VALOR1             = :paramNombresTecnInternetWs1
                                                AND DET.VALOR2             = :paramProducto
                                                AND CAB.ESTADO             = :paramEstadoActivo3
                                                AND DET.ESTADO             = :paramEstadoActivo4)
                )
                AND OLT.NOMBRE_ELEMENTO                  = :paramNombreOlt                  
                AND OLT.ESTADO                           = :paramEstadoActivo5                  
                AND PUERTO_OLT.NOMBRE_INTERFACE_ELEMENTO = :paramPuertoOlt                  
                AND PUERTO_OLT.ESTADO                    = :paramEstadoConnected                  
                AND SERVICIO.ESTADO                     IN (:paramEstadoInCorte, :paramEstadoActivo6)
                GROUP BY CAJA.NOMBRE_ELEMENTO , SPLITTER.NOMBRE_ELEMENTO ';
  OPEN Prf_Result FOR Lcl_Query 
  USING Lv_NombreParametroTecnicoWs, Lv_NombresTecnInternetWs, Lv_ValorProductoPlan, Lv_EstadoActivo, Lv_EstadoActivo,
        Lv_NombreParametroTecnicoWs, Lv_NombresTecnInternetWs, Lv_ValorProducto, Lv_EstadoActivo, Lv_EstadoActivo,
        Pv_Olt, Lv_EstadoActivo, Pv_PuertoOlt, Lv_EstadoConnected, 
        Lv_EstadoInCorte,Lv_EstadoActivo;
  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';
EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_WS_GET_LOGINES_POR_OLT;

/**
 * P_GET_SERVICIOS_MISMA_UM
 * Funcion que retorna información acerca de los servicios asociados a una misma UM segun los parametros enviados
 * 
 * @author Jesus Bozada <jbozada@telconet.ec>
 * @version 1.0 25-10-2016
 * @param  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID                                     IN Pn_PuntoId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_ID                    IN Pn_ElementoId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_ID          IN Pn_InterfaceElementoId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID            IN Pn_ElementoClienteId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID  IN Pn_InterfaceElementoClienteId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID                IN Pn_UltimaMillaId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.TERCERIZADORA_ID               IN Pn_TercerizadoraId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CONTENEDOR_ID         IN Pn_ElementoContenedorId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CONECTOR_ID           IN Pn_ElementoConectorId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID IN Pn_InterfaceElementoConectorId
 * @param  DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.TIPO_ENLACE                    IN Pv_TipoEnlace
 * @param  Lrf_Result OUT Prf_Result
 * @param  VARCHAR2   OUT Pv_Status
 * @param  VARCHAR2   OUT Pv_Mensaje
 */
PROCEDURE P_GET_SERVICIOS_MISMA_UM( Pn_PuntoId                     IN DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                    Pn_ElementoId                  IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_ID%TYPE,
                                    Pn_InterfaceElementoId         IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_ID%TYPE,
                                    Pn_ElementoClienteId           IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE,
                                    Pn_InterfaceElementoClienteId  IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
                                    Pn_UltimaMillaId               IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE,             
                                    Pn_TercerizadoraId             IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.TERCERIZADORA_ID%TYPE,          
                                    Pn_ElementoContenedorId        IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CONTENEDOR_ID%TYPE,
                                    Pn_ElementoConectorId          IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.ELEMENTO_CONECTOR_ID%TYPE,
                                    Pn_InterfaceElementoConectorId IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID%TYPE,
                                    Pv_TipoEnlace                  IN DB_INFRAESTRUCTURA.INFO_SERVICIO_TECNICO.TIPO_ENLACE%TYPE,
                                    Prf_Result                     OUT Lrf_Result,
                                    Pv_Status                      OUT VARCHAR2,
                                    Pv_Mensaje                     OUT VARCHAR2 )

IS

  Lv_Query               VARCHAR2(3000) := '';
  Lv_EstadoConnected     VARCHAR2(15)   := 'connected';
  Lv_EstadoActivo        VARCHAR2(15)   := 'Activo';
  Lv_EstadoEnPruebas     VARCHAR2(15)   := 'EnPruebas';
  Ln_curid               NUMBER;
  Ln_Ret                 NUMBER;
  Ln_contador            BINARY_INTEGER := 0;
  Lrf_PametrosBindName   Lt_PametrosBind;
  Lrf_PametrosBindVars   Lt_PametrosBind;

BEGIN

  -- Se genera Numero del cursor Sql
  Ln_curid := DBMS_SQL.OPEN_CURSOR;
    
  Lv_Query := 'SELECT SERVTEC.SERVICIO_ID
               FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVTEC,
               DB_COMERCIAL.INFO_SERVICIO SERVICIOS
               WHERE SERVTEC.ELEMENTO_ID                  = :paramElementoId
               AND SERVTEC.INTERFACE_ELEMENTO_ID          = :paramInterfaceElementoId ';

  Ln_contador                       := Ln_contador + 1;
  Lrf_PametrosBindName(Ln_contador) := 'paramElementoId';
  Lrf_PametrosBindVars(Ln_contador) := Pn_ElementoId;
  Ln_contador                       := Ln_contador + 1;
  Lrf_PametrosBindName(Ln_contador) := 'paramInterfaceElementoId'; 
  Lrf_PametrosBindVars(Ln_contador) := Pn_InterfaceElementoId;

  IF Pn_ElementoClienteId IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVTEC.ELEMENTO_CLIENTE_ID = :paramElementoClienteId ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramElementoClienteId'; 
    Lrf_PametrosBindVars(Ln_contador) := Pn_ElementoClienteId;
  END IF;
  IF Pn_InterfaceElementoClienteId IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVTEC.INTERFACE_ELEMENTO_CLIENTE_ID = :paramIntElementoClienteId ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramIntElementoClienteId'; 
    Lrf_PametrosBindVars(Ln_contador) := Pn_InterfaceElementoClienteId;
  END IF;
  IF Pn_UltimaMillaId IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVTEC.ULTIMA_MILLA_ID = :paramUltimaMillaId ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramUltimaMillaId'; 
    Lrf_PametrosBindVars(Ln_contador) := Pn_UltimaMillaId;
  END IF;
  IF Pn_TercerizadoraId IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVTEC.TERCERIZADORA_ID = :paramTercerizadoraId ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramTercerizadoraId'; 
    Lrf_PametrosBindVars(Ln_contador) := Pn_TercerizadoraId;
  END IF;
  IF Pn_ElementoContenedorId IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVTEC.ELEMENTO_CONTENEDOR_ID = :paramElementoContenedorId ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramElementoContenedorId'; 
    Lrf_PametrosBindVars(Ln_contador) := Pn_ElementoContenedorId;
  END IF;
  IF Pn_ElementoConectorId IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVTEC.ELEMENTO_CONECTOR_ID = :paramElementoConectorId ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramElementoConectorId'; 
    Lrf_PametrosBindVars(Ln_contador) := Pn_ElementoConectorId;
  END IF;
  IF Pn_InterfaceElementoConectorId IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVTEC.INTERFACE_ELEMENTO_CONECTOR_ID = :paramIntElementoConectorId ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramIntElementoConectorId'; 
    Lrf_PametrosBindVars(Ln_contador) := Pn_InterfaceElementoConectorId;
  END IF;
  IF Pv_TipoEnlace IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVTEC.TIPO_ENLACE = :paramTipoEnlace ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramTipoEnlace'; 
    Lrf_PametrosBindVars(Ln_contador) := Pv_TipoEnlace;
  END IF;

  Lv_Query :=  Lv_Query || 'AND SERVTEC.SERVICIO_ID = SERVICIOS.ID_SERVICIO ';

  Lv_Query :=  Lv_Query || 'AND SERVICIOS.ESTADO IN (:paramEstadoActivo, :paramEstadoEnPruebas) ';

  Ln_contador                       := Ln_contador + 1;
  Lrf_PametrosBindName(Ln_contador) := 'paramEstadoActivo'; 
  Lrf_PametrosBindVars(Ln_contador) := Lv_EstadoActivo;

  Ln_contador                       := Ln_contador + 1;
  Lrf_PametrosBindName(Ln_contador) := 'paramEstadoEnPruebas'; 
  Lrf_PametrosBindVars(Ln_contador) := Lv_EstadoEnPruebas;

  IF Pn_PuntoId IS NOT NULL THEN
    Lv_Query :=  Lv_Query || 'AND SERVICIOS.PUNTO_ID = :paramPuntoId ';
    Ln_contador := Ln_contador + 1;
    Lrf_PametrosBindName(Ln_contador) := 'paramPuntoId'; 
    Lrf_PametrosBindVars(Ln_contador) := Pn_PuntoId;
  END IF;

  DBMS_SQL.PARSE(Ln_curid, Lv_Query, DBMS_SQL.NATIVE);

  FOR Ln_IdxJ IN 1 .. Lrf_PametrosBindVars.COUNT LOOP
    DBMS_SQL.BIND_VARIABLE(Ln_curid, Lrf_PametrosBindName(Ln_IdxJ), Lrf_PametrosBindVars(Ln_IdxJ));
  END LOOP;
 
  Ln_Ret     := DBMS_SQL.EXECUTE(Ln_curid);
  Prf_Result := DBMS_SQL.TO_REFCURSOR(Ln_curid);

  Pv_Status  := 'OK';
  Pv_Mensaje := 'OK';

EXCEPTION
WHEN OTHERS THEN
  Pv_Status  := 'ERROR';
  Pv_Mensaje := SQLERRM;
END P_GET_SERVICIOS_MISMA_UM;

/**
 * GET_EXISTE_AS_PRIVADO
 *
 * Función que permite obtener si un asprivado existe o no dentro de otro servicio ( internet mpls ) o dentro de otro
 * cliente ( l3mpls )
 *
 * @author Allan Suarez <arsuarez@telconet.ec>
 * @version 1.1 06-03-2017 Se agrega validacion para que valide por cliente la existencia de asprivado
 * 
 * Costo : 7 ( Para opcion de busqueda de L3MPLS )
 *        10 ( Para opcion de busqueda de INTMPLS )
 *        Ambas opciones realizan diferentes tipo de busqueda a como esta concebida la estructura para cada producto
 *
 * @param number    Fn_idPersonalRol   persona rol del cliente en sesion
 * @param varchar2  Fn_asPrivado       as privado a ser verficado
 * @param varchar2  Fn_tipoProducto    tipo de producto ( nombre tecnico - l3mpls/intmpls )
 * @return varchar2 Lv_existeAsPrivado Resultado de la funcion
 */
FUNCTION GET_EXISTE_AS_PRIVADO(Fn_idPersonalRol IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                               Fn_asPrivado VARCHAR2,
                               Fn_tipoProducto VARCHAR2)
                               RETURN VARCHAR2
IS

  Lv_existeAsPrivado VARCHAR2(2) := null;
--
BEGIN
  
  CASE Fn_tipoProducto
    
    WHEN 'L3MPLS' THEN
    
      SELECT 
        CASE COUNT(*) 
          WHEN 0 THEN 'NO'
          ELSE 'SI' 
        END EXISTE_AS INTO Lv_existeAsPrivado
      FROM 
        DB_COMERCIAL.admi_caracteristica c,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC ipec,
        DB_COMERCIAL.info_persona_empresa_rol er,
        DB_COMERCIAL.info_persona p
      WHERE c.ID_CARACTERISTICA        = ipec.caracteristica_id
      AND ipec.PERSONA_EMPRESA_ROL_ID  = er.ID_PERSONA_ROL
      AND c.DESCRIPCION_CARACTERISTICA = 'AS_PRIVADO'
      AND er.persona_id                = p.id_persona
      AND IPEC.VALOR                   = TO_CHAR(Fn_asPrivado)
      AND c.estado                     = 'Activo'
      AND ipec.estado                  = 'Activo'
      AND er.ID_PERSONA_ROL           <> Fn_idPersonalRol;
      
    WHEN 'INTMPLS' THEN
    
      SELECT 
        CASE COUNT(*) 
          WHEN 0 THEN 'NO'
          ELSE 'SI' 
        END EXISTE_AS INTO Lv_existeAsPrivado
      FROM 
        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
        DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
        DB_COMERCIAL.ADMI_CARACTERISTICA C,
        DB_COMERCIAL.ADMI_PRODUCTO P,
        DB_COMERCIAL.INFO_SERVICIO S,
        DB_COMERCIAL.INFO_PUNTO PU
      WHERE C.DESCRIPCION_CARACTERISTICA   = 'AS_PRIVADO'
      AND P.NOMBRE_TECNICO                 = 'INTMPLS'
      AND APC.CARACTERISTICA_ID            = C.ID_CARACTERISTICA
      AND APC.PRODUCTO_ID                  = P.ID_PRODUCTO
      AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
      AND ISPC.SERVICIO_ID                 = S.ID_SERVICIO
      AND S.PUNTO_ID                       = PU.ID_PUNTO
      AND PU.PERSONA_EMPRESA_ROL_ID        <> Fn_idPersonalRol
      AND ISPC.VALOR                       = TO_CHAR(Fn_asPrivado) 
      AND ISPC.ESTADO                      = 'Activo'; 
    
  END CASE;
  
  RETURN Lv_existeAsPrivado;
--
END GET_EXISTE_AS_PRIVADO;

FUNCTION F_GET_SERVICIOS_LIBERA_FACTIB(
                                        Fv_CodigoEmpresa        IN VARCHAR2,
                                        Fv_PrefijoEmpresa       IN VARCHAR2,
                                        Fv_Region               IN VARCHAR2,
                                        Fv_CodigoUltimaMilla    IN VARCHAR2,
                                        Fn_DiasLiberaFactib     IN NUMBER,
                                        Fn_TotalRegistros       OUT NUMBER)
RETURN SYS_REFCURSOR
IS
  Lv_SelectPrincipal VARCHAR2(4000);
  Lv_SelectCountPrincipal VARCHAR2(4000);
  Lv_Select VARCHAR2(4000);
  Lcl_ConsultaPrincipal CLOB;
  Lcl_ConsultaCountPrincipal CLOB;
  Lv_FromJoin VARCHAR2(4000);
  Lv_Where VARCHAR2(4000);
  Lv_WherePrincipal VARCHAR2(4000);
  Lv_EstadoFactible VARCHAR2(8) := 'Factible';
  Lv_EstadoPreFactible VARCHAR2(15) := 'PreFactibilidad';
  Lv_DescripcionSolicitud VARCHAR2(22) := 'SOLICITUD FACTIBILIDAD';
  Lv_InternetYDatos VARCHAR2(16) := 'INTERNET Y DATOS';
  Lv_Internet VARCHAR2(8) := 'INTERNET';
  Lv_L3mpls VARCHAR2(6) := 'L3MPLS';
  Lv_L3mplsSdwan VARCHAR2(14) := 'L3MPLS SDWAN';
  Lv_InternetDedicado VARCHAR2(17) := 'INTERNET DEDICADO';
  Lt_ArrayParamsBind TECNK_SERVICIOS.Lt_ArrayAsociativo;
  Lv_NombreParamBind VARCHAR2(30);
  Ln_IdCursor NUMBER;
  Ln_NumExecPrincipal NUMBER;
  Ln_IdCursorCount NUMBER;
  Ln_NumExecCount NUMBER;
  Lrf_ConsultaPrincipal SYS_REFCURSOR;
  Lrf_ConsultaCount SYS_REFCURSOR;

  BEGIN
    Fn_TotalRegistros       := 0;
    Lv_SelectCountPrincipal := 'SELECT COUNT(DISTINCT ID_SERVICIO) AS TOTAL_REGISTROS ';
    Lv_SelectPrincipal  := 'SELECT DISTINCT SERVICIOS.ID_SERVICIO,
                            SERVICIOS.ID_SERVICIO_TECNICO,
                            SERVICIOS.EMPRESA_COD,
                            SERVICIOS.REGION,
                            SERVICIOS.JURISDICCION,
                            SERVICIOS.CIUDAD,
                            SERVICIOS.CODIGO_TIPO_MEDIO,
                            SERVICIOS.USR_VENDEDOR,
                            SERVICIOS.CLIENTE,
                            SERVICIOS.LOGIN,
                            SERVICIOS.ID_DETALLE_SOLICITUD,
                            TO_CHAR(SERVICIOS.FECHA_FACTIBILIDAD, ''DD/MM/YYYY HH24:MI:SS'') AS FECHA_FACTIBILIDAD,
                            ROUND((SYSDATE -TRUNC(SERVICIOS.FECHA_FACTIBILIDAD)),2) AS DIAS_FACTIBLES,
                            SERVICIOS.AUTOMATICA ';

    Lv_Select           := 'SELECT SERVICIO.ID_SERVICIO,
                            SERVICIO_TECNICO.ID_SERVICIO_TECNICO,
                            ER.EMPRESA_COD,
                            CANTON.REGION,
                            JURISDICCION.NOMBRE_JURISDICCION AS JURISDICCION,
                            CANTON.NOMBRE_CANTON AS CIUDAD,
                            MEDIO.CODIGO_TIPO_MEDIO,
                            SERVICIO.USR_VENDEDOR ,
                            CASE
                              WHEN PERSONA.RAZON_SOCIAL IS NOT NULL
                              THEN PERSONA.RAZON_SOCIAL
                              ELSE CONCAT(CONCAT (NVL(PERSONA.NOMBRES, ''''),''''), NVL(PERSONA.APELLIDOS, ''''))
                            END         AS CLIENTE,
                            PUNTO.LOGIN AS LOGIN,
                            SOLICITUD.ID_DETALLE_SOLICITUD,
                            (SELECT MAX(SERVICIO_HISTORIAL.FE_CREACION)
                            FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SERVICIO_HISTORIAL
                            WHERE SERVICIO_HISTORIAL.SERVICIO_ID=SERVICIO.ID_SERVICIO
                            AND SERVICIO_HISTORIAL.ESTADO       = :Lv_EstadoFactible
                            ) AS FECHA_FACTIBILIDAD,
                            (SELECT
                              CASE
                                WHEN COUNT(*) >0
                                THEN ''NO''
                                ELSE ''SI''
                              END
                            FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                            WHERE SERVICIO_ID=SERVICIO.ID_SERVICIO
                            AND ESTADO       = :Lv_EstadoPreFactible
                            ) AS AUTOMATICA ';

    Lv_FromJoin         := 'FROM DB_COMERCIAL.INFO_PUNTO PUNTO
                            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                            ON PUNTO.PERSONA_EMPRESA_ROL_ID=PER.ID_PERSONA_ROL
                            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER
                            ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
                            INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
                            ON PER.PERSONA_ID =PERSONA.ID_PERSONA
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
                            ON PUNTO.PUNTO_COBERTURA_ID =JURISDICCION.ID_JURISDICCION
                            INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
                            ON PUNTO.ID_PUNTO =SERVICIO.PUNTO_ID
                            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
                            ON SERVICIO_TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO MEDIO
                            ON MEDIO.ID_TIPO_MEDIO = SERVICIO_TECNICO.ULTIMA_MILLA_ID
                            INNER JOIN DB_GENERAL.ADMI_SECTOR SECTOR
                            ON SECTOR.ID_SECTOR = PUNTO.SECTOR_ID
                            INNER JOIN DB_GENERAL.ADMI_PARROQUIA PARROQUIA
                            ON PARROQUIA.ID_PARROQUIA = SECTOR.PARROQUIA_ID
                            INNER JOIN DB_GENERAL.ADMI_CANTON CANTON
                            ON CANTON.ID_CANTON = PARROQUIA.CANTON_ID 
                            INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD
                            ON SOLICITUD.SERVICIO_ID = SERVICIO.ID_SERVICIO
                            INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOLICITUD
                            ON TIPO_SOLICITUD.ID_TIPO_SOLICITUD = SOLICITUD.TIPO_SOLICITUD_ID ';

    Lv_Where            := 'WHERE SERVICIO.ESTADO = :Lv_EstadoFactible 
                            AND SERVICIO_TECNICO.ULTIMA_MILLA_ID IS NOT NULL
                            AND SOLICITUD.SERVICIO_ID = SERVICIO.ID_SERVICIO
                            AND SOLICITUD.ESTADO = :Lv_EstadoFactible
                            AND TIPO_SOLICITUD.DESCRIPCION_SOLICITUD = :Lv_DescripcionSolicitud ';

    Lt_ArrayParamsBind('Lv_EstadoFactible')         := Lv_EstadoFactible;
    Lt_ArrayParamsBind('Lv_EstadoPreFactible')      := Lv_EstadoPreFactible;
    Lt_ArrayParamsBind('Lv_DescripcionSolicitud')   := Lv_DescripcionSolicitud;
    IF Fv_CodigoEmpresa IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND ER.EMPRESA_COD = :Fv_CodigoEmpresa ';
      Lt_ArrayParamsBind('Fv_CodigoEmpresa') := Fv_CodigoEmpresa;
    END IF;

    IF Fv_Region IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND CANTON.REGION = :Fv_Region ';
      Lt_ArrayParamsBind('Fv_Region') := Fv_Region;
    END IF;

    IF Fv_PrefijoEmpresa IS NOT NULL THEN
      IF Fv_PrefijoEmpresa = 'TN' THEN
        Lv_SelectPrincipal := Lv_SelectPrincipal || ', SERVICIOS.NOMBRE_SERVICIO ';
          
        Lv_Select     := Lv_Select || ', PRODUCTO.DESCRIPCION_PRODUCTO AS NOMBRE_SERVICIO ';
        Lv_FromJoin   := Lv_FromJoin || 'INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO 
                                         ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID ';
        Lv_Where      := Lv_Where || 'AND (PRODUCTO.GRUPO = :Lv_InternetYDatos OR PRODUCTO.GRUPO = :Lv_Internet ) 
                                      AND PRODUCTO.REQUIERE_INFO_TECNICA = :Lv_RquiereInfoTecnica
                                      AND (PRODUCTO.NOMBRE_TECNICO = :Lv_Internet OR PRODUCTO.NOMBRE_TECNICO = :Lv_L3mpls OR PRODUCTO.NOMBRE_TECNICO = :Lv_L3mplsSdwan)
                                      AND (PRODUCTO.SUBGRUPO = :Lv_InternetDedicado OR SUBGRUPO = :Lv_L3mpls ) ';
        Lt_ArrayParamsBind('Lv_InternetYDatos') := Lv_InternetYDatos;
        Lt_ArrayParamsBind('Lv_Internet') := Lv_Internet;
        Lt_ArrayParamsBind('Lv_RquiereInfoTecnica') := 'SI';
        Lt_ArrayParamsBind('Lv_L3mpls') := Lv_L3mpls;
        Lt_ArrayParamsBind('Lv_InternetDedicado') := Lv_InternetDedicado;
		Lt_ArrayParamsBind('Lv_L3mplsSdwan') := Lv_L3mplsSdwan;
      ELSE 
        IF Fv_PrefijoEmpresa = 'MD' THEN
          Lv_SelectPrincipal := Lv_SelectPrincipal || ', SERVICIOS.NOMBRE_SERVICIO ';

          Lv_Select     := Lv_Select || ', PLAN_CAB.NOMBRE_PLAN AS NOMBRE_SERVICIO ';
          Lv_FromJoin   := Lv_FromJoin || 'INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB 
                                           ON PLAN_CAB.ID_PLAN = SERVICIO.PLAN_ID 
                                           INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                                           ON PLAN_DET.PLAN_ID = PLAN_CAB.ID_PLAN
                                           INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                           ON PRODUCTO.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID ';
          Lv_Where      := Lv_Where || 'AND PRODUCTO.GRUPO = :Lv_Internet ';
          Lt_ArrayParamsBind('Lv_Internet') := Lv_Internet;
        END IF;
      END IF;
    END IF;

    IF Fv_CodigoUltimaMilla IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND MEDIO.CODIGO_TIPO_MEDIO = :Fv_CodigoUltimaMilla ';
      Lt_ArrayParamsBind('Fv_CodigoUltimaMilla') := Fv_CodigoUltimaMilla;
    END IF;

    IF Fn_DiasLiberaFactib IS NOT NULL THEN
      Lv_WherePrincipal := Lv_WherePrincipal || ' SERVICIOS_REPORTE.DIAS_FACTIBLES >= :Fn_DiasLiberaFactib AND ';
      Lt_ArrayParamsBind('Fn_DiasLiberaFactib') := Fn_DiasLiberaFactib;
    END IF;


    IF TRIM(Lv_WherePrincipal) IS NOT NULL THEN
      Lv_WherePrincipal := 'WHERE ' || RTRIM(Lv_WherePrincipal,'AND ') || ' ';
    END IF;

    Lcl_ConsultaPrincipal := 'SELECT SERVICIOS_REPORTE.*, ROUND(SERVICIOS_REPORTE.DIAS_FACTIBLES) AS DIAS_FACTIBLES_REPORTE FROM ( ' ||
                              Lv_SelectPrincipal || ' FROM (' || Lv_Select || Lv_FromJoin || Lv_Where || ') SERVICIOS ) SERVICIOS_REPORTE ' || 
                              Lv_WherePrincipal;
    Lcl_ConsultaCountPrincipal := Lv_SelectCountPrincipal || ' FROM (' || Lcl_ConsultaPrincipal || ') ';
    Ln_IdCursorCount := DBMS_SQL.OPEN_CURSOR();
    DBMS_SQL.PARSE(Ln_IdCursorCount, Lcl_ConsultaCountPrincipal, DBMS_SQL.NATIVE);
    Lv_NombreParamBind := Lt_ArrayParamsBind.FIRST;
    WHILE (Lv_NombreParamBind IS NOT NULL) LOOP
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursorCount, Lv_NombreParamBind, Lt_ArrayParamsBind(Lv_NombreParamBind));
      Lv_NombreParamBind := Lt_ArrayParamsBind.NEXT(Lv_NombreParamBind);
    END LOOP;
    Ln_NumExecCount := DBMS_SQL.EXECUTE(Ln_IdCursorCount);
    Lrf_ConsultaCount := DBMS_SQL.TO_REFCURSOR(Ln_IdCursorCount);
    FETCH Lrf_ConsultaCount INTO Fn_TotalRegistros;

    
    Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
    DBMS_SQL.PARSE(Ln_IdCursor, Lcl_ConsultaPrincipal, DBMS_SQL.NATIVE);
    Lv_NombreParamBind := Lt_ArrayParamsBind.FIRST;
    WHILE (Lv_NombreParamBind IS NOT NULL) LOOP
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, Lv_NombreParamBind, Lt_ArrayParamsBind(Lv_NombreParamBind));
      Lv_NombreParamBind := Lt_ArrayParamsBind.NEXT(Lv_NombreParamBind);
    END LOOP;
    Ln_NumExecPrincipal     := DBMS_SQL.EXECUTE(Ln_IdCursor);
    Lrf_ConsultaPrincipal   := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
    RETURN Lrf_ConsultaPrincipal;
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.F_GET_SERVICIOS_LIBERA_FACTIB', 
                                          'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
    RETURN NULL;
END F_GET_SERVICIOS_LIBERA_FACTIB;
--
FUNCTION F_GET_VALIDACION_IP_FIJA_TN(
    Fv_MacWifi          IN INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Fn_IdServicio       IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fn_IdPunto          IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_TipoReturn       IN VARCHAR2,
    Fv_EstadoServicio   IN INFO_SERVICIO.ESTADO%TYPE,
    Fn_IdProducto       IN ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Fv_CodEmpresa       IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN VARCHAR2
IS
  Lv_ServicioIpFijaProd         VARCHAR2(10);
  Lv_ServicioInternet           VARCHAR2(10);
  Lv_TieneIpFija                VARCHAR2(100);
  Lv_MacIpFija                  VARCHAR2(100);
  Lv_ServicioRefIpFija          VARCHAR2(100);
  Lv_CaracteristicaRelacion     VARCHAR2(100);
  Ln_IdProdInternet             DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
  Lv_NombreParamTnGpon          VARCHAR2(21) := 'PARAMS_PRODS_TN_GPON';
  Lv_NombreValor1ParamTnGpon    VARCHAR2(35) := 'PRODUCTOS_RELACIONADOS_INTERNET_IP';
  Lv_EstadoActivo               VARCHAR2(6) := 'Activo';
  Lv_NombreParamEstado          VARCHAR2(100) := 'PROM_ESTADOS_BAJA_SERV';
  Lv_DescripParamEstado         VARCHAR2(100) := 'PROM_ESTADOS_BAJA_SERV';
  Ln_Rownum                     NUMBER(10) := 1;
  Lv_Select                     VARCHAR2(1000);
  Lv_From                       VARCHAR2(3000);
  Lv_Rownum                     VARCHAR2(1000);
  Lv_Query                      VARCHAR2(4000);
  Lv_QueryServiciosIni          VARCHAR2(4000);
  Lv_QueryServicios             VARCHAR2(4000);
  Lv_QueryCaractServ            VARCHAR2(4000);
  Lv_QueryAndSerPri             VARCHAR2(4000);
  Lv_QueryAndIpFija             VARCHAR2(4000);
BEGIN
  Lv_QueryCaractServ    := 'SELECT DET.VALOR7 
                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                            WHERE CAB.NOMBRE_PARAMETRO = :Cv_NombreParametro
                            AND CAB.ESTADO = :Cv_EstadoActivo
                            AND DET.VALOR1 = :Cv_DescripcionPar
                            AND DET.ESTADO = :Cv_EstadoActivo
                            AND DET.VALOR2 = :Cn_IdProductoInt
                            AND ROWNUM <= :Cn_Rownum ';
  Lv_QueryServiciosIni  := 'SELECT TO_CHAR(SERV.ID_SERVICIO)
                            FROM DB_COMERCIAL.INFO_SERVICIO SERV
                            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
                            ON SERV.PRODUCTO_ID     = PROD.ID_PRODUCTO
                            WHERE SERV.ESTADO       = :Cv_EstadoActivo
                            AND SERV.PUNTO_ID       = :Cn_IdPunto ';
  Lv_QueryAndSerPri     := ' AND ( SERV.ID_SERVICIO = COALESCE(TO_NUMBER(REGEXP_SUBSTR(
                             DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(:strIdSerIp,:strDescripCaractRel),
                            ''^\d+'')),0) OR SERV.ID_SERVICIO = :strIdSerIp ) ';
  Lv_QueryAndIpFija     := ' SELECT SER.ID_SERVICIO
                             FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT CAR, DB_COMERCIAL.INFO_SERVICIO SER,
                                DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC, DB_COMERCIAL.ADMI_PRODUCTO PRO,
                                DB_COMERCIAL.ADMI_CARACTERISTICA C,
                                DB_GENERAL.ADMI_PARAMETRO_DET DET, DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                             WHERE PC.ID_PRODUCTO_CARACTERISITICA = CAR.PRODUCTO_CARACTERISITICA_ID
                                AND PRO.ID_PRODUCTO = PC.PRODUCTO_ID
                                AND SER.ID_SERVICIO = CAR.SERVICIO_ID
                                AND C.ID_CARACTERISTICA = PC.CARACTERISTICA_ID
                                AND CAB.ID_PARAMETRO = DET.PARAMETRO_ID
                                AND C.DESCRIPCION_CARACTERISTICA = DET.VALOR7
                                AND PRO.ID_PRODUCTO = COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR3,''^\d+'')),0)
                                AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(CAR.VALOR,''^\d+'')),0) = :Cn_IdServicio
                                AND CAB.NOMBRE_PARAMETRO = :Cv_NombreParametro
                                AND DET.VALOR1 = :Cv_DescripcionPar
                                AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR2,''^\d+'')),0) = :Cn_IdProductoInt
                                AND CAR.ESTADO = :Cv_EstadoActivo
                                AND CAB.ESTADO = :Cv_EstadoActivo
                                AND DET.ESTADO = :Cv_EstadoActivo
                                AND NOT EXISTS (
                                  SELECT 1 FROM DB_GENERAL.ADMI_PARAMETRO_DET DET_EST, DB_GENERAL.ADMI_PARAMETRO_CAB CAB_EST
                                  WHERE CAB_EST.NOMBRE_PARAMETRO = :Cv_NombreParametroEstado
                                    AND DET_EST.DESCRIPCION = :Cv_DescripcionParEstado
                                    AND CAB_EST.ESTADO = :Cv_EstadoActivo
                                    AND DET_EST.ESTADO = :Cv_EstadoActivo
                                    AND SER.ESTADO = DET_EST.VALOR1
                                ) ';
  Lv_QueryServicios     := '';

  Lv_Select             := 'SELECT PROD_PRINCIPAL.ID_PRODUCTO AS ID_PROD_INTERNET ';
  Lv_From               := 'FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM
                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                            ON PARAM_DET.PARAMETRO_ID = PARAM.ID_PARAMETRO
                            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_PRINCIPAL
                            ON PROD_PRINCIPAL.ID_PRODUCTO = COALESCE(TO_NUMBER(REGEXP_SUBSTR(PARAM_DET.VALOR2,''^\d+'')),0) 
                            WHERE PARAM.NOMBRE_PARAMETRO    = :Cv_NombreParametro
                            AND PARAM.ESTADO                = :Cv_EstadoActivo1
                            AND PARAM_DET.VALOR1            = :Cv_Valor1Parametro
                            AND PARAM_DET.ESTADO            = :Cv_EstadoActivo2
                            AND PARAM_DET.EMPRESA_COD       = :Cv_CodEmpresa1
                            AND PROD_PRINCIPAL.ESTADO       = :Cv_EstadoActivo3
                            AND PROD_PRINCIPAL.EMPRESA_COD  = :Cv_CodEmpresa2 ';
  Lv_Rownum             := 'AND ROWNUM = :Cn_Rownum ';
  Lv_Query              := Lv_Select || Lv_From || 
                           'AND (COALESCE(TO_NUMBER(REGEXP_SUBSTR(PARAM_DET.VALOR2,''^\d+'')),0) = :Cn_IdProducto1
                                 OR COALESCE(TO_NUMBER(REGEXP_SUBSTR(PARAM_DET.VALOR3,''^\d+'')),0) = :Cn_IdProducto2) ' ||
                           Lv_Rownum;
  BEGIN
    EXECUTE IMMEDIATE Lv_Query INTO Ln_IdProdInternet 
    USING Lv_NombreParamTnGpon, Lv_EstadoActivo, Lv_NombreValor1ParamTnGpon, Lv_EstadoActivo, Fv_CodEmpresa, Lv_EstadoActivo,
          Fv_CodEmpresa, Fn_IdProducto, Fn_IdProducto, Ln_Rownum;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    Ln_IdProdInternet := NULL;
  WHEN OTHERS THEN
    Ln_IdProdInternet := NULL;
  END;

  IF Ln_IdProdInternet IS NOT NULL THEN
    BEGIN
      EXECUTE IMMEDIATE Lv_QueryCaractServ INTO Lv_CaracteristicaRelacion 
      USING Lv_NombreParamTnGpon, Lv_EstadoActivo, Lv_NombreValor1ParamTnGpon, Lv_EstadoActivo, Ln_IdProdInternet, Ln_Rownum;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      Lv_CaracteristicaRelacion := NULL;
    WHEN OTHERS THEN
      Lv_CaracteristicaRelacion := NULL;
    END;

    IF Lv_CaracteristicaRelacion IS NULL THEN
        Lv_QueryServicios := Lv_QueryServiciosIni || ' AND PROD.ID_PRODUCTO  = :Cn_IdProducto ' || Lv_Rownum;
        BEGIN
          EXECUTE IMMEDIATE Lv_QueryServicios INTO Lv_ServicioInternet
          USING Lv_EstadoActivo, Fn_IdPunto, Ln_IdProdInternet, Ln_Rownum;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_ServicioInternet := NULL;
        WHEN OTHERS THEN
          Lv_ServicioInternet := NULL;
        END;
    ELSE
        Lv_QueryServicios := Lv_QueryServiciosIni || ' AND PROD.ID_PRODUCTO  = :Cn_IdProducto ' || Lv_QueryAndSerPri || Lv_Rownum;
        BEGIN
          EXECUTE IMMEDIATE Lv_QueryServicios INTO Lv_ServicioInternet
          USING Lv_EstadoActivo, Fn_IdPunto, Ln_IdProdInternet, Fn_IdServicio, Lv_CaracteristicaRelacion, Fn_IdServicio, Ln_Rownum;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_ServicioInternet := NULL;
        WHEN OTHERS THEN
          Lv_ServicioInternet := NULL;
        END;
    END IF;

    IF Fv_EstadoServicio = 'Asignada' THEN
      IF Lv_CaracteristicaRelacion IS NULL THEN
        Lv_QueryServicios :=  Lv_QueryServiciosIni 
                              || ' AND PROD.ID_PRODUCTO IN 
                                   (SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(PARAM_DET.VALOR3,''^\d+'')),0) AS ID_PROD_IP '
                              ||   Lv_From 
                              || ' AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(PARAM_DET.VALOR2,''^\d+'')),0) = :Cn_IdProductoInternet) '
                              || Lv_Rownum;
        BEGIN
          EXECUTE IMMEDIATE Lv_QueryServicios INTO Lv_ServicioIpFijaProd
          USING Lv_EstadoActivo, Fn_IdPunto, Lv_NombreParamTnGpon, Lv_EstadoActivo, Lv_NombreValor1ParamTnGpon, Lv_EstadoActivo, 
                Fv_CodEmpresa, Lv_EstadoActivo, Fv_CodEmpresa, Ln_IdProdInternet, Ln_Rownum;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_ServicioIpFijaProd := NULL;
        WHEN OTHERS THEN
          Lv_ServicioIpFijaProd := NULL;
        END;
      ELSE
        Lv_QueryServicios :=  Lv_QueryServiciosIni
                              || ' AND SERV.ID_SERVICIO IN ( '
                              ||   Lv_QueryAndIpFija
                              || ' ) '
                              || Lv_Rownum;
        BEGIN
          EXECUTE IMMEDIATE Lv_QueryServicios INTO Lv_ServicioIpFijaProd
          USING Lv_EstadoActivo, Fn_IdPunto, Fn_IdServicio, Lv_NombreParamTnGpon, Lv_NombreValor1ParamTnGpon, Ln_IdProdInternet,
                Lv_EstadoActivo, Lv_EstadoActivo, Lv_EstadoActivo, Lv_NombreParamEstado, Lv_DescripParamEstado, Lv_EstadoActivo,
                Lv_EstadoActivo, Ln_Rownum;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          Lv_ServicioIpFijaProd := NULL;
        WHEN OTHERS THEN
          Lv_ServicioIpFijaProd := NULL;
        END;
      END IF;
      IF Lv_ServicioInternet IS NULL AND Lv_ServicioIpFijaProd IS NULL THEN
        IF Lv_ServicioInternet IS NULL THEN
          Lv_TieneIpFija       := '0';
          Lv_MacIpFija         := 'Servicio sin Producto Principal Activo';
          Lv_ServicioRefIpFija := '0';
        ELSE
          Lv_TieneIpFija := '0';
          IF Fv_MacWifi IS NULL THEN
            Lv_MacIpFija := 'Servicio sin Mac Wifi';
          ELSE
            Lv_MacIpFija := Fv_MacWifi;
          END IF;
            Lv_ServicioRefIpFija := Lv_ServicioInternet;
        END IF;
      ELSE
        Lv_TieneIpFija       := '1';
        Lv_MacIpFija         := '';
        Lv_ServicioRefIpFija := Lv_ServicioInternet;
      END IF;
    ELSIF Fv_EstadoServicio = 'Activo' THEN
      Lv_TieneIpFija       := '0';
      Lv_MacIpFija         := Fv_MacWifi;
      Lv_ServicioRefIpFija := Lv_ServicioInternet;
    END IF;
  ELSE
    Lv_TieneIpFija       := '0';
    Lv_MacIpFija         := 'Servicio sin Ip';
    Lv_ServicioRefIpFija := '0';
  END IF;

  IF Fv_TipoReturn = 'TIENE IP FIJA' THEN
    RETURN Lv_TieneIpFija;
  ELSIF Fv_TipoReturn = 'MAC IP FIJA' THEN
    RETURN Lv_MacIpFija;
  ELSE
    RETURN Lv_ServicioRefIpFija;
  END IF;
END F_GET_VALIDACION_IP_FIJA_TN;

  FUNCTION F_SPLIT_VARCHAR2(
    Fv_Cadena    IN  VARCHAR2,
    Fv_Delimiter IN  VARCHAR2)
  RETURN DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar
  IS
    Lt_ArrayData DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;
  BEGIN
    FOR Lr_CurrentRow IN (
      WITH TEST AS
        (SELECT Fv_Cadena FROM DUAL)
        SELECT REGEXP_SUBSTR(Fv_Cadena, '[^' || Fv_Delimiter || ']+', 1, ROWNUM) SPLIT
        FROM TEST
        CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE(Fv_Cadena, '[^' || Fv_Delimiter || ']+'))  + 1)
    LOOP
      Lt_ArrayData(Lt_ArrayData.COUNT) := Lr_CurrentRow.SPLIT;
    END LOOP;
    RETURN Lt_ArrayData;
  EXCEPTION
  WHEN OTHERS THEN
    RETURN Lt_ArrayData;
  END F_SPLIT_VARCHAR2;

  FUNCTION F_GET_CORREOS_LICENCIAS(
    Fv_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, 
    Fv_ObtienePrimerCorreo  IN VARCHAR2)
    RETURN DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar
  IS
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lt_ArrayCorreosSplitComa        DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;
    Lt_ArrayCorreosSplitPuntoYComa  DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;
    Li_IndxCorreosSplitComa         PLS_INTEGER;
    Li_IndxCorreosSplitPuntoYComa   PLS_INTEGER;
    Lv_ValorCorreoSplitComa         VARCHAR2(4000);
    Lv_ValorCorreoSplitPuntoYComa   VARCHAR2(4000);
    Lv_ExpRegularCorreo             VARCHAR2(4000) := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$';
    Lv_CorreoLicencias              VARCHAR2(4000);
    Lt_ArrayCorreos                 DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;
    Ln_ContadorCorreos              NUMBER := 0;
    Lv_Exit                         VARCHAR2(2);
    Lv_Exit1                        VARCHAR2(2);
    Lv_Exit2                        VARCHAR2(2);
    Lr_RegInfoCorreoCliente         DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoCorreoCliente;
    Lt_TInfoCorreoCliente           DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoCorreoCliente;
    Ln_IndxInfoCorreoCliente        NUMBER;
    CURSOR Lc_GetCorreoLicencias(Cv_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS 
      SELECT CONTACTO ,
        (instr(CONTACTO,';') +
         instr(CONTACTO,',' ))  TIENESEPARADOR
      FROM (
         (SELECT DISTINCT EMAIL_ENVIO AS CONTACTO,
           3                          AS ORDEN
         FROM
           (SELECT REGEXP_REPLACE(EMAIL_ENVIO,'(^[[:space:]]*|[[:space:]]*$)') AS EMAIL_ENVIO,
             ROW_NUMBER() OVER (ORDER BY EMAIL_ENVIO) rno
           FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL
           WHERE PUNTO_ID   = Cv_IdPunto
           AND EMAIL_ENVIO IS NOT NULL
           ORDER BY EMAIL_ENVIO ASC
           )
         )
       UNION ALL
         (SELECT DISTINCT REGEXP_REPLACE(IPFC.VALOR,'(^[[:space:]]*|[[:space:]]*$)') AS CONTACTO,
           2                                                                         AS ORDEN
         FROM DB_COMERCIAL.INFO_PUNTO IP,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_COMERCIAL.INFO_PERSONA IPR,
           DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC,
           DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
         WHERE IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
         AND IPER.PERSONA_ID             = IPR.ID_PERSONA
         AND IPR.ID_PERSONA              = IPFC.PERSONA_ID
         AND IPFC.FORMA_CONTACTO_ID      = AFC.ID_FORMA_CONTACTO
         AND IPFC.ESTADO                 = Lv_EstadoActivo
         AND AFC.ESTADO                  = Lv_EstadoActivo
         AND AFC.CODIGO                 IN
           (SELECT CODIGO
           FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO
           WHERE DESCRIPCION_FORMA_CONTACTO LIKE 'Correo%'
           )
         AND IP.ID_PUNTO = Cv_IdPunto
         )
       UNION ALL
         (SELECT DISTINCT REGEXP_REPLACE(IPFC.VALOR,'(^[[:space:]]*|[[:space:]]*$)') AS CONTACTO,
           1                                                                         AS ORDEN
         FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO IPFC,
           DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
         WHERE IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
         AND AFC.CODIGO              IN
           (SELECT CODIGO
           FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO
           WHERE DESCRIPCION_FORMA_CONTACTO LIKE 'Correo%'
           )
         AND IPFC.ESTADO   = Lv_EstadoActivo
         AND AFC.ESTADO    = Lv_EstadoActivo
         AND IPFC.PUNTO_ID = Cv_IdPunto
         ) )
       WHERE CONTACTO IS NOT NULL
       GROUP BY CONTACTO
       ORDER BY MIN(ORDEN) ASC;
  BEGIN
    Lv_Exit := 'NO';
    OPEN Lc_GetCorreoLicencias(Fv_IdPunto);
    LOOP
      FETCH Lc_GetCorreoLicencias BULK COLLECT INTO Lt_TInfoCorreoCliente LIMIT 100;
      Ln_IndxInfoCorreoCliente := Lt_TInfoCorreoCliente.FIRST;
      WHILE (Ln_IndxInfoCorreoCliente IS NOT NULL AND Lv_Exit = 'NO')       
      LOOP 
        Lr_RegInfoCorreoCliente := Lt_TInfoCorreoCliente(Ln_IndxInfoCorreoCliente);
        Lv_Exit                 := 'NO';
        IF Lr_RegInfoCorreoCliente.TIENESEPARADOR IS NOT NULL AND Lr_RegInfoCorreoCliente.TIENESEPARADOR > 0 THEN
          Lt_ArrayCorreosSplitComa    := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(Lr_RegInfoCorreoCliente.CONTACTO, ',');
          Li_IndxCorreosSplitComa     := Lt_ArrayCorreosSplitComa.FIRST;
          Lv_Exit1                    := 'NO';
          WHILE (Li_IndxCorreosSplitComa IS NOT NULL AND Lv_Exit1 = 'NO')
          LOOP
            Lv_ValorCorreoSplitComa           := TRIM(Lt_ArrayCorreosSplitComa(Li_IndxCorreosSplitComa));
            Lt_ArrayCorreosSplitPuntoYComa    := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(Lv_ValorCorreoSplitComa, ';');
            Li_IndxCorreosSplitPuntoYComa     := Lt_ArrayCorreosSplitPuntoYComa.FIRST;
            Lv_Exit2                          := 'NO';
            WHILE (Li_IndxCorreosSplitPuntoYComa IS NOT NULL AND Lv_Exit2 = 'NO')
            LOOP
              Lv_ValorCorreoSplitPuntoYComa := TRIM(Lt_ArrayCorreosSplitPuntoYComa(Li_IndxCorreosSplitPuntoYComa));
              IF Lv_ValorCorreoSplitPuntoYComa IS NOT NULL AND REGEXP_LIKE(Lv_ValorCorreoSplitPuntoYComa, Lv_ExpRegularCorreo) THEN
                Lt_ArrayCorreos(Ln_ContadorCorreos) := Lv_ValorCorreoSplitPuntoYComa;
                Ln_ContadorCorreos                  := Ln_ContadorCorreos + 1;
                IF Fv_ObtienePrimerCorreo = 'SI' THEN
                  Lv_CorreoLicencias      := Lv_ValorCorreoSplitPuntoYComa;
                  Lv_Exit2                := 'SI';
                END IF;
              END IF;
              Li_IndxCorreosSplitPuntoYComa := Lt_ArrayCorreosSplitPuntoYComa.NEXT(Li_IndxCorreosSplitPuntoYComa);
            END LOOP;
            IF (Fv_ObtienePrimerCorreo = 'SI' AND Lv_CorreoLicencias IS NOT NULL) THEN
              Lv_Exit1 := 'SI';
            END IF;
            Li_IndxCorreosSplitComa := Lt_ArrayCorreosSplitComa.NEXT(Li_IndxCorreosSplitComa);
          END LOOP;
        ELSE
          IF Lr_RegInfoCorreoCliente.CONTACTO IS NOT NULL AND REGEXP_LIKE(TRIM(Lr_RegInfoCorreoCliente.CONTACTO), Lv_ExpRegularCorreo) THEN
            Lt_ArrayCorreos(Ln_ContadorCorreos) := TRIM(Lr_RegInfoCorreoCliente.CONTACTO);
            Ln_ContadorCorreos                  := Ln_ContadorCorreos + 1;
            Lv_CorreoLicencias                  := TRIM(Lr_RegInfoCorreoCliente.CONTACTO);
          END IF;
        END IF;
        Ln_IndxInfoCorreoCliente := Lt_TInfoCorreoCliente.NEXT(Ln_IndxInfoCorreoCliente);
        IF (Fv_ObtienePrimerCorreo = 'SI' AND Lv_CorreoLicencias IS NOT NULL) THEN
          Lv_Exit := 'SI';
        END IF;
      END LOOP;
      EXIT WHEN (Lc_GetCorreoLicencias%NOTFOUND OR Lv_Exit = 'SI');
    END LOOP;
    CLOSE Lc_GetCorreoLicencias;
    RETURN Lt_ArrayCorreos;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'TECNK_SERVICIOS.F_GET_CORREOS_LICENCIAS', 
                                            SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                                            ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END F_GET_CORREOS_LICENCIAS;

  PROCEDURE P_GET_PTOS_INTERNET_X_OLT(  
    Pn_IdElementoOlt    IN NUMBER,
    Prf_Registros       OUT SYS_REFCURSOR,
    Pv_Status           OUT VARCHAR2,
    Pv_MsjError         OUT VARCHAR2)
  AS
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_EstadoInCorte            VARCHAR2(8) := 'In-Corte';
    Lv_EstadoEnPruebas          VARCHAR2(9) := 'EnPruebas';
    Lv_EstadoEnVerificacion     VARCHAR2(14) := 'EnVerificacion';
    Lv_EstadoEliminado          VARCHAR2(9) := 'Eliminado';
    Lv_NombreTecnicoInternet    VARCHAR2(8) := 'INTERNET';
    Lv_CodEmpresa               VARCHAR2(2) := '18';
    Lv_TipoRolCliente           VARCHAR2(7) := 'Cliente';
    Lv_ParamAntivirus           VARCHAR2(27) := 'ANTIVIRUS_PLANES_Y_PRODS_MD';
    Lv_SuscriberId              VARCHAR2(12) := 'SUSCRIBER_ID';
    Lv_CaractAntivirus          VARCHAR2(9) := 'ANTIVIRUS';
    Lv_Nuevo                    VARCHAR2(5) := 'NUEVO';
    Lv_Anterior                 VARCHAR2(8) := 'ANTERIOR';
    Ln_Rownum                   NUMBER := 1;
    Lv_InfoCliente              VARCHAR2(4000);
    Lv_SelectPrincipal          VARCHAR2(4000);
    Lcl_Select                  CLOB;
    Lcl_FromJoin                CLOB;
    Lv_Where                    VARCHAR2(4000);
    Lv_WherePrincipal           VARCHAR2(4000);
    Lcl_ConsultaPrincipal       CLOB;
    BEGIN
      Lv_SelectPrincipal      := '  SELECT ID_ELEMENTO,
                                    NOMBRE_ELEMENTO,
                                    ID_PUNTO,
                                    LOGIN,
                                    USR_VENDEDOR_PTO,
                                    ID_PERSONA_ROL,
                                    IDENTIFICACION_CLIENTE,
                                    NOMBRES,
                                    APELLIDOS,
                                    RAZON_SOCIAL,
                                    CLIENTE,
                                    NOMBRE_JURISDICCION,
                                    ID_SERVICIO_INTERNET,
                                    TIPO_ORDEN_INTERNET,
                                    ESTADO_SERVICIO_INTERNET,
                                    USR_VENDEDOR_SERVICIO_INTERNET,
                                    ID_PTO_FACT_SERVICIO_INTERNET,
                                    ID_UM_SERVICIO_INTERNET,
                                    ID_PLAN,
                                    NOMBRE_PLAN,
                                    ID_ITEM_INTERNET,
                                    ID_PROD_INTERNET,
                                    DESCRIPCION_PROD_INTERNET,
                                    ID_ITEM_I_PROTEGIDO,
                                    ESTADO_PLAN_DET_I_PROTEGIDO,
                                    ID_PROD_I_PROTEGIDO,
                                    DESCRIPCION_PROD_I_PROTEGIDO,
                                    VALOR_SPC_SUSCRIBER_ID,
                                    VALOR_SPC_ANTIVIRUS,
                                    CANTIDAD_SERVICIOS_ADICIONALES ';
      Lcl_Select              := '  SELECT DISTINCT OLT.ID_ELEMENTO,
                                    OLT.NOMBRE_ELEMENTO,
                                    INFO_CLIENTE.ID_PUNTO,
                                    INFO_CLIENTE.LOGIN,
                                    INFO_CLIENTE.USR_VENDEDOR_PTO,
                                    INFO_CLIENTE.ID_PERSONA_ROL,
                                    INFO_CLIENTE.IDENTIFICACION_CLIENTE,
                                    INFO_CLIENTE.NOMBRES,
                                    INFO_CLIENTE.APELLIDOS,
                                    INFO_CLIENTE.RAZON_SOCIAL,
                                    INFO_CLIENTE.CLIENTE,
                                    INFO_CLIENTE.NOMBRE_JURISDICCION,
                                    SERVICIO_INTERNET.ID_SERVICIO AS ID_SERVICIO_INTERNET,
                                    SERVICIO_INTERNET.TIPO_ORDEN  AS TIPO_ORDEN_INTERNET,
                                    SERVICIO_INTERNET.ESTADO  AS ESTADO_SERVICIO_INTERNET,
                                    SERVICIO_INTERNET.USR_VENDEDOR  AS USR_VENDEDOR_SERVICIO_INTERNET,
                                    SERVICIO_INTERNET.PUNTO_FACTURACION_ID AS ID_PTO_FACT_SERVICIO_INTERNET,
                                    SERVICIO_TECNICO_INTERNET.ULTIMA_MILLA_ID AS ID_UM_SERVICIO_INTERNET,
                                    PLAN_CAB.ID_PLAN,
                                    PLAN_CAB.NOMBRE_PLAN,
                                    PLAN_DET_INTERNET.ID_ITEM                   AS ID_ITEM_INTERNET,
                                    PRODUCTO_PLAN_INTERNET.ID_PRODUCTO          AS ID_PROD_INTERNET,
                                    PRODUCTO_PLAN_INTERNET.DESCRIPCION_PRODUCTO AS DESCRIPCION_PROD_INTERNET,
                                    DET_PLAN_I_PROTEGIDO.ID_ITEM_I_PROTEGIDO,
                                    DET_PLAN_I_PROTEGIDO.ESTADO_PLAN_DET_I_PROTEGIDO,
                                    DET_PLAN_I_PROTEGIDO.ID_PROD_I_PROTEGIDO,
                                    DET_PLAN_I_PROTEGIDO.DESCRIPCION_PROD_I_PROTEGIDO,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET.ID_SERVICIO, :paramSuscriberId) 
                                    AS VALOR_SPC_SUSCRIBER_ID,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET.ID_SERVICIO, :paramCaractAntivirus) 
                                    AS VALOR_SPC_ANTIVIRUS,
                                    ( SELECT DISTINCT COUNT(DISTINCT SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO)
                                    FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_ADIC_I_PROTEGIDO
                                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                    ON PRODUCTO.ID_PRODUCTO = SERVICIO_ADIC_I_PROTEGIDO.PRODUCTO_ID
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                    ON PARAM_DET.VALOR3 = PRODUCTO.DESCRIPCION_PRODUCTO
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                    ON PARAM_CAB.ID_PARAMETRO  = PARAM_DET.PARAMETRO_ID
                                    WHERE SERVICIO_ADIC_I_PROTEGIDO.ESTADO IN (:paramEstadoActivoAdic1, :paramEstadoInCorteAdic)
                                    AND TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, 
                                                                                       :paramSuscriberIdAdic) IS NULL
                                    AND TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, 
                                                                                       :paramCaractAntivirusAdic) IS NULL
                                    AND SERVICIO_ADIC_I_PROTEGIDO.PUNTO_ID = ID_PUNTO
                                    AND PARAM_CAB.NOMBRE_PARAMETRO  = :paramAntivirusAdic
                                    AND PARAM_CAB.ESTADO = :paramEstadoActivoAdic2
                                    AND PARAM_DET.VALOR1 = :paramAnteriorAdic
                                    AND PARAM_DET.ESTADO = :paramEstadoActivoAdic3
                                    ) AS CANTIDAD_SERVICIOS_ADICIONALES,
                                    ROW_NUMBER() OVER (PARTITION BY OLT.ID_ELEMENTO, INFO_CLIENTE.ID_PUNTO, INFO_CLIENTE.ID_PERSONA_ROL 
                                                       ORDER BY SERVICIO_INTERNET.ID_SERVICIO DESC) RN_SERVICIO ';

      Lv_InfoCliente          := ' (SELECT *
                                    FROM
                                      (SELECT PUNTO.ID_PUNTO,
                                        PUNTO.LOGIN,
                                        PUNTO.USR_VENDEDOR AS USR_VENDEDOR_PTO,
                                        PER.ID_PERSONA_ROL,
                                        PERSONA.IDENTIFICACION_CLIENTE IDENTIFICACION_CLIENTE,
                                        PERSONA.NOMBRES,
                                        PERSONA.APELLIDOS,
                                        PERSONA.RAZON_SOCIAL,
                                        CASE
                                          WHEN PERSONA.RAZON_SOCIAL IS NOT NULL
                                          THEN DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.RAZON_SOCIAL)
                                          ELSE DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.NOMBRES)
                                            || '' ''
                                            || DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.APELLIDOS)
                                        END CLIENTE,
                                        JURISDICCION.NOMBRE_JURISDICCION,
                                        ROW_NUMBER() OVER (PARTITION BY PUNTO.ID_PUNTO ORDER BY PER.ID_PERSONA_ROL DESC) RN
                                      FROM DB_COMERCIAL.INFO_PUNTO PUNTO
                                      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                                      ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
                                      INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
                                      ON PERSONA.ID_PERSONA = PER.PERSONA_ID
                                      INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER
                                      ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
                                      INNER JOIN DB_COMERCIAL.ADMI_ROL ROL
                                      ON ROL.ID_ROL = ER.ROL_ID
                                      INNER JOIN DB_COMERCIAL.ADMI_TIPO_ROL TIPO_ROL
                                      ON TIPO_ROL.ID_TIPO_ROL           = ROL.TIPO_ROL_ID
                                      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
                                      ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID
                                      WHERE PER.ESTADO                  = :paramEstadoActivo1
                                      AND ER.EMPRESA_COD                = :paramCodEmpresa1
                                      AND TIPO_ROL.DESCRIPCION_TIPO_ROL = :paramTipoRolCliente
                                      )
                                    WHERE RN = :paramRownum1
                                    ) 
                                    INFO_CLIENTE ';
  
      Lcl_FromJoin            := '  FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_INTERNET
                                    INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO_INTERNET
                                    ON SERVICIO_TECNICO_INTERNET.SERVICIO_ID = SERVICIO_INTERNET.ID_SERVICIO
                                    INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
                                    ON OLT.ID_ELEMENTO = SERVICIO_TECNICO_INTERNET.ELEMENTO_ID
                                    INNER JOIN ' || Lv_InfoCliente || '
                                    ON INFO_CLIENTE.ID_PUNTO = SERVICIO_INTERNET.PUNTO_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
                                    ON PLAN_CAB.ID_PLAN = SERVICIO_INTERNET.PLAN_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET_INTERNET
                                    ON PLAN_DET_INTERNET.PLAN_ID = PLAN_CAB.ID_PLAN
                                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO_PLAN_INTERNET
                                    ON PRODUCTO_PLAN_INTERNET.ID_PRODUCTO     = PLAN_DET_INTERNET.PRODUCTO_ID 
                                    LEFT JOIN
                                      (SELECT PLAN_CAB.ID_PLAN,
                                        PLAN_DET.ID_ITEM              AS ID_ITEM_I_PROTEGIDO,
                                        PLAN_DET.ESTADO               AS ESTADO_PLAN_DET_I_PROTEGIDO,
                                        PRODUCTO.ID_PRODUCTO          AS ID_PROD_I_PROTEGIDO,
                                        PRODUCTO.DESCRIPCION_PRODUCTO AS DESCRIPCION_PROD_I_PROTEGIDO
                                      FROM DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
                                      INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                                      ON PLAN_DET.PLAN_ID = PLAN_CAB.ID_PLAN
                                      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                      ON PRODUCTO.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
                                      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                      ON PARAM_DET.VALOR3 = PRODUCTO.DESCRIPCION_PRODUCTO
                                      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                      ON PARAM_CAB.ID_PARAMETRO                              = PARAM_DET.PARAMETRO_ID
                                      WHERE PLAN_DET.ESTADO                                 <> :paramEstadoEliminado1
                                      AND PARAM_CAB.NOMBRE_PARAMETRO                         = :paramParametroAntivirus
                                      AND PARAM_CAB.ESTADO                                   = :paramEstadoActivo2
                                      AND PARAM_DET.VALOR1                                   = :paramNuevo
                                      AND PARAM_DET.ESTADO                                   = :paramEstadoActivo3
                                      ) DET_PLAN_I_PROTEGIDO ON DET_PLAN_I_PROTEGIDO.ID_PLAN = PLAN_CAB.ID_PLAN ';
  
      Lv_Where                := '  WHERE SERVICIO_INTERNET.ESTADO  IN (:paramEstadoActivo4, :paramEstadoInCorte, 
                                    :paramEstadoEnPruebas, :paramEnVerificacion)
                                    AND PLAN_DET_INTERNET.ESTADO <> :paramEstadoEliminado2
                                    AND PRODUCTO_PLAN_INTERNET.NOMBRE_TECNICO = :paramNombreTecnicoInternet
                                    AND PRODUCTO_PLAN_INTERNET.ESTADO         = :paramEstadoActivo5
                                    AND PRODUCTO_PLAN_INTERNET.EMPRESA_COD    = :paramCodEmpresa2 
                                    AND OLT.ID_ELEMENTO = :Pn_IdElementoOlt ';
      Lv_WherePrincipal       := '  WHERE RN_SERVICIO = :paramRownum2 
                                    AND ((ID_ITEM_I_PROTEGIDO        IS NOT NULL
                                    AND VALOR_SPC_SUSCRIBER_ID       IS NULL
                                    AND VALOR_SPC_ANTIVIRUS          IS NULL )
                                    OR CANTIDAD_SERVICIOS_ADICIONALES > 0 ) '; 
      Lcl_ConsultaPrincipal := Lv_SelectPrincipal || ' FROM (' || Lcl_Select || Lcl_FromJoin || Lv_Where || ') ' || Lv_WherePrincipal;

      OPEN Prf_Registros FOR Lcl_ConsultaPrincipal 
      USING Lv_SuscriberId, Lv_CaractAntivirus, 
            Lv_EstadoActivo, Lv_EstadoInCorte, Lv_SuscriberId, Lv_CaractAntivirus, Lv_ParamAntivirus, Lv_EstadoActivo, Lv_Anterior, Lv_EstadoActivo,
            Lv_EstadoActivo, Lv_CodEmpresa, Lv_TipoRolCliente, Ln_Rownum, 
            Lv_EstadoEliminado, Lv_ParamAntivirus, Lv_EstadoActivo, Lv_Nuevo, Lv_EstadoActivo,
            Lv_EstadoActivo, Lv_EstadoInCorte, Lv_EstadoEnPruebas, Lv_EstadoEnVerificacion, Lv_EstadoEliminado,
            Lv_NombreTecnicoInternet, Lv_EstadoActivo, Lv_CodEmpresa, Pn_IdElementoOlt, Ln_Rownum;
      Pv_Status                := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      Prf_Registros             := NULL;
      Pv_Status                 := 'ERROR';
      Pv_MsjError               := 'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                    || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'TECNK_SERVICIOS.P_GET_PTOS_INTERNET_X_OLT', 
                                            Pv_MsjError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_PTOS_INTERNET_X_OLT;

  PROCEDURE P_GET_SERV_ADICS_I_PROTEGIDO(
    Pn_IdPunto      IN NUMBER,
    Prf_Registros   OUT SYS_REFCURSOR,
    Pv_Status       OUT VARCHAR2,
    Pv_MsjError     OUT VARCHAR2)
  AS
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_EstadoInCorte            VARCHAR2(8) := 'In-Corte';
    Lv_ParamAntivirus           VARCHAR2(27) := 'ANTIVIRUS_PLANES_Y_PRODS_MD';
    Lv_CantidadDisp             VARCHAR2(21) := 'CANTIDAD DISPOSITIVOS';
    Lv_SuscriberId              VARCHAR2(12) := 'SUSCRIBER_ID';
    Lv_Anterior                 VARCHAR2(8) := 'ANTERIOR';
    Lv_IProtegido               VARCHAR2(12) := 'I. PROTEGIDO';
    Lv_CaractAntivirus          VARCHAR2(9) := 'ANTIVIRUS';
    Lv_SelectPrincipal          VARCHAR2(4000);
    Lv_Select                   VARCHAR2(4000);
    Lcl_FromJoin                CLOB;
    Lv_Where                    VARCHAR2(4000);
    Lv_WherePrincipal           VARCHAR2(4000);
    Lcl_ConsultaPrincipal       CLOB;
    BEGIN
      Lv_SelectPrincipal      := '  SELECT ID_SERVICIO,
                                    ID_PUNTO,
                                    LOGIN,
                                    ID_PRODUCTO,
                                    DESCRIPCION_PRODUCTO,
                                    PRECIO_VENTA_SERVICIO,
                                    ESTADO_SERVICIO,
                                    (
                                    CASE
                                      WHEN INSTR(DESCRIPCION_PRODUCTO, :paramIProtegido) = 0
                                      THEN 1
                                      ELSE COALESCE(TO_NUMBER(REGEXP_SUBSTR(VALOR_SPC_CANT_DISP,''^\d+'')),0)
                                    END) AS CANT_DISPOSITIVOS ';
      Lv_Select               := '  SELECT DISTINCT SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO,
                                    PUNTO.ID_PUNTO,
                                    PUNTO.LOGIN,
                                    PRODUCTO.ID_PRODUCTO,
                                    PRODUCTO.DESCRIPCION_PRODUCTO,
                                    SERVICIO_ADIC_I_PROTEGIDO.PRECIO_VENTA AS PRECIO_VENTA_SERVICIO,
                                    SERVICIO_ADIC_I_PROTEGIDO.ESTADO AS ESTADO_SERVICIO,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, :paramSuscriberId) 
                                    AS VALOR_SPC_SUSCRIBER_ID,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, :paramCaractAntivirus) 
                                    AS VALOR_SPC_ANTIVIRUS,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, :paramCantidadDisp) 
                                    AS VALOR_SPC_CANT_DISP ';
  
      Lcl_FromJoin            := '  FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_ADIC_I_PROTEGIDO
                                    INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
                                    ON PUNTO.ID_PUNTO = SERVICIO_ADIC_I_PROTEGIDO.PUNTO_ID
                                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                    ON PRODUCTO.ID_PRODUCTO = SERVICIO_ADIC_I_PROTEGIDO.PRODUCTO_ID
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                    ON PARAM_DET.VALOR3 = PRODUCTO.DESCRIPCION_PRODUCTO
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                    ON PARAM_CAB.ID_PARAMETRO = PARAM_DET.PARAMETRO_ID ';
  
      Lv_Where                := '  WHERE SERVICIO_ADIC_I_PROTEGIDO.ESTADO                           
                                    IN (:paramEstadoActivo1, :paramEstadoInCorte)
                                    AND PARAM_CAB.NOMBRE_PARAMETRO                                    = :paramAntivirus
                                    AND PARAM_CAB.ESTADO                                              = :paramEstadoActivo2
                                    AND PARAM_DET.VALOR1                                              = :paramAnterior
                                    AND PARAM_DET.ESTADO                                              = :paramEstadoActivo3 ';

      Lv_WherePrincipal       := '  WHERE ID_PUNTO = :paramIdPunto 
                                    AND VALOR_SPC_SUSCRIBER_ID IS NULL
                                    AND VALOR_SPC_ANTIVIRUS IS NULL ';
      Lcl_ConsultaPrincipal :=  Lv_SelectPrincipal || ' FROM (' || Lv_Select || Lcl_FromJoin || Lv_Where || ') ' || Lv_WherePrincipal;
  
      OPEN Prf_Registros FOR Lcl_ConsultaPrincipal 
      USING Lv_IProtegido, Lv_SuscriberId, Lv_CaractAntivirus, Lv_CantidadDisp, Lv_EstadoActivo, Lv_EstadoInCorte, Lv_ParamAntivirus, 
            Lv_EstadoActivo, Lv_Anterior, Lv_EstadoActivo, Pn_IdPunto;
      Pv_Status                := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      Prf_Registros             := NULL;
      Pv_Status                 := 'ERROR';
      Pv_MsjError               := 'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                    || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'TECNK_SERVICIOS.P_GET_SERV_ADICS_I_PROTEGIDO', 
                                            Pv_MsjError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_SERV_ADICS_I_PROTEGIDO;

  PROCEDURE P_GET_OLTS_INICIO_CPM(
    Pv_RetornaDataOltsCpm   IN VARCHAR2,
    Pv_RetornaTotalOltsCpm  IN VARCHAR2,
    Pn_IdOlt                IN NUMBER,
    Pn_Start                IN NUMBER,
    Pn_Limit                IN NUMBER,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_OltsCpm             OUT SYS_REFCURSOR,
    Pn_TotalOltsCpm         OUT NUMBER)
  AS
    Lv_TipoOlt                  VARCHAR2(3) := 'OLT';
    Lv_EstadoEliminado          VARCHAR2(9) := 'Eliminado';
    Lv_EstadoPendiente          VARCHAR2(9) := 'Pendiente';
    Lv_DescripcionSolCpm        VARCHAR2(28) := 'SOLICITUD CAMBIO PLAN MASIVO';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_DetalleMiddleware        VARCHAR2(10) := 'MIDDLEWARE';
    Lv_Si                       VARCHAR2(2) := 'SI';
    Lv_DetalleAprovisionaIp     VARCHAR2(20) := 'APROVISIONAMIENTO_IP';
    Lv_Cnr                      VARCHAR2(3) := 'CNR';
    Lv_DetalleCpmMd             VARCHAR2(21) := 'CAMBIO_PLAN_MASIVO_MD';
    Lv_Fin                      VARCHAR2(3) := 'FIN';
    Lv_SelectCount              VARCHAR2(4000);
    Lv_Select                   VARCHAR2(4000);
    Lcl_FromJoin                CLOB;
    Lv_WhereAdicional           VARCHAR2(4000);
    Lv_GroupBy                  VARCHAR2(4000);
    Lcl_ConsultaPrincipal       CLOB;
    Lcl_ConsultaTotalOltsCpm    CLOB;
    Lc_TotalOltsCpm             SYS_REFCURSOR;
    Ln_LimitConsulta      NUMBER;
    Ln_StartConsulta      NUMBER;
    BEGIN
      Lv_SelectCount    := 'SELECT COUNT(DISTINCT ID_ELEMENTO) ';
      Lv_Select         := 'SELECT DISTINCT OLT.ID_ELEMENTO,
                            OLT.NOMBRE_ELEMENTO,
                            OLT.ESTADO,
                            COUNT(DISTINCT SOL.ID_DETALLE_SOLICITUD) AS NUM_LOGINES ';
      Lcl_FromJoin      := 'FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_OLT
                            ON MODELO_OLT.ID_MODELO_ELEMENTO = OLT.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_OLT
                            ON TIPO_OLT.ID_TIPO_ELEMENTO = MODELO_OLT.TIPO_ELEMENTO_ID
                            INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL
                            ON SOL.ELEMENTO_ID = OLT.ID_ELEMENTO
                            INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL
                            ON TIPO_SOL.ID_TIPO_SOLICITUD       = SOL.TIPO_SOLICITUD_ID
                            WHERE TIPO_OLT.NOMBRE_TIPO_ELEMENTO = :paramTipoOlt
                            AND OLT.ESTADO                      <> :paramEstadoEliminado
                            AND SOL.ESTADO                      = :paramEstadoPendiente
                            AND TIPO_SOL.DESCRIPCION_SOLICITUD  = :paramDescripcionSolCpm
                            AND TIPO_SOL.ESTADO                 = :paramEstadoActivo1
                            AND DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.INFRF_GET_DETALLE_VALOR( :paramDetalleMiddleware, 
                                                                                                OLT.ID_ELEMENTO, 
                                                                                                :paramEstadoActivo2) = :paramSi
                            AND DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.INFRF_GET_DETALLE_VALOR( :paramDetalleAprovisionaIp, 
                                                                                                OLT.ID_ELEMENTO, 
                                                                                                :paramEstadoActivo3) = :paramCnr
                            AND (DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.INFRF_GET_DETALLE_VALOR(:paramDetalleCpmMd1, 
                                                                                                OLT.ID_ELEMENTO, 
                                                                                                :paramEstadoActivo4) IS NULL
                            OR DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.INFRF_GET_DETALLE_VALOR(  :paramDetalleCpmMd2, 
                                                                                                OLT.ID_ELEMENTO, 
                                                                                                :paramEstadoActivo5) = :paramFin) ';
      
      IF Pn_IdOlt IS NOT NULL AND Pn_IdOlt > 0 THEN
        Lv_WhereAdicional := 'AND OLT.ID_ELEMENTO = :paramIdOlt ';
      END IF;

      Lv_GroupBy        := 'GROUP BY OLT.ID_ELEMENTO,
                              OLT.NOMBRE_ELEMENTO,
                              OLT.ESTADO ';

      IF Pv_RetornaDataOltsCpm = 'SI' THEN
        Lcl_ConsultaPrincipal := Lv_Select || Lcl_FromJoin || Lv_WhereAdicional || Lv_GroupBy;
        IF Pn_Limit IS NOT NULL AND Pn_Limit > 0 THEN
          Lcl_ConsultaPrincipal := 'SELECT a.*, rownum AS doctrine_rownum '
                                   || 'FROM (' || Lcl_ConsultaPrincipal || ') a WHERE rownum <= :Ln_LimitConsulta ';
          Ln_LimitConsulta      := Pn_Start + Pn_Limit;
          IF Pn_Start IS NOT NULL AND Pn_Start > 0 THEN
            Lcl_ConsultaPrincipal := 'SELECT * FROM (' || Lcl_ConsultaPrincipal || ') WHERE doctrine_rownum >= :Ln_StartConsulta ';
            Ln_StartConsulta := Pn_Start + 1;
          END IF;
        END IF;

        IF Ln_LimitConsulta IS NOT NULL AND Ln_LimitConsulta > 0 AND Ln_StartConsulta IS NOT NULL AND Ln_StartConsulta > 0 THEN 
          IF Pn_IdOlt IS NOT NULL AND Pn_IdOlt > 0 THEN
            OPEN Prf_OltsCpm FOR Lcl_ConsultaPrincipal 
            USING Lv_TipoOlt, Lv_EstadoEliminado, Lv_EstadoPendiente, Lv_DescripcionSolCpm, Lv_EstadoActivo, Lv_DetalleMiddleware, Lv_EstadoActivo,
                  Lv_Si, Lv_DetalleAprovisionaIp, Lv_EstadoActivo, Lv_Cnr, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_Fin,
                  Pn_IdOlt, Ln_LimitConsulta, Ln_StartConsulta;
          ELSE
            OPEN Prf_OltsCpm FOR Lcl_ConsultaPrincipal 
            USING Lv_TipoOlt, Lv_EstadoEliminado, Lv_EstadoPendiente, Lv_DescripcionSolCpm, Lv_EstadoActivo, Lv_DetalleMiddleware, Lv_EstadoActivo,
                  Lv_Si, Lv_DetalleAprovisionaIp, Lv_EstadoActivo, Lv_Cnr, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_Fin,
                  Ln_LimitConsulta, Ln_StartConsulta;
          END IF;
        ELSIF Ln_LimitConsulta IS NOT NULL AND Ln_LimitConsulta > 0 THEN
          IF Pn_IdOlt IS NOT NULL AND Pn_IdOlt > 0 THEN
            OPEN Prf_OltsCpm FOR Lcl_ConsultaPrincipal 
            USING Lv_TipoOlt, Lv_EstadoEliminado, Lv_EstadoPendiente, Lv_DescripcionSolCpm, Lv_EstadoActivo, Lv_DetalleMiddleware, Lv_EstadoActivo,
                  Lv_Si, Lv_DetalleAprovisionaIp, Lv_EstadoActivo, Lv_Cnr, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_Fin,
                  Pn_IdOlt, Ln_LimitConsulta;
          ELSE
            OPEN Prf_OltsCpm FOR Lcl_ConsultaPrincipal 
            USING Lv_TipoOlt, Lv_EstadoEliminado, Lv_EstadoPendiente, Lv_DescripcionSolCpm, Lv_EstadoActivo, Lv_DetalleMiddleware, Lv_EstadoActivo,
                  Lv_Si, Lv_DetalleAprovisionaIp, Lv_EstadoActivo, Lv_Cnr, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_Fin,
                  Ln_LimitConsulta;
          END IF;
        ELSE
          IF Pn_IdOlt IS NOT NULL AND Pn_IdOlt > 0 THEN
            OPEN Prf_OltsCpm FOR Lcl_ConsultaPrincipal 
            USING Lv_TipoOlt, Lv_EstadoEliminado, Lv_EstadoPendiente, Lv_DescripcionSolCpm, Lv_EstadoActivo, Lv_DetalleMiddleware, Lv_EstadoActivo,
                  Lv_Si, Lv_DetalleAprovisionaIp, Lv_EstadoActivo, Lv_Cnr, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_Fin,
                  Pn_IdOlt;
          ELSE
            OPEN Prf_OltsCpm FOR Lcl_ConsultaPrincipal 
            USING Lv_TipoOlt, Lv_EstadoEliminado, Lv_EstadoPendiente, Lv_DescripcionSolCpm, Lv_EstadoActivo, Lv_DetalleMiddleware, Lv_EstadoActivo,
                  Lv_Si, Lv_DetalleAprovisionaIp, Lv_EstadoActivo, Lv_Cnr, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_Fin;
          END IF;
        END IF;
      ELSE
        Prf_OltsCpm := NULL;
      END IF;

      IF Pv_RetornaTotalOltsCpm = 'SI' THEN
        Lcl_ConsultaTotalOltsCpm := Lv_SelectCount || 'FROM (' || Lv_Select || Lcl_FromJoin || Lv_WhereAdicional || Lv_GroupBy || ')';
        IF Pn_IdOlt IS NOT NULL AND Pn_IdOlt > 0 THEN
          OPEN Lc_TotalOltsCpm FOR Lcl_ConsultaTotalOltsCpm 
          USING Lv_TipoOlt, Lv_EstadoEliminado, Lv_EstadoPendiente, Lv_DescripcionSolCpm, Lv_EstadoActivo, Lv_DetalleMiddleware, Lv_EstadoActivo, 
                Lv_Si, Lv_DetalleAprovisionaIp, Lv_EstadoActivo, Lv_Cnr, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_Fin,
                Pn_IdOlt;
        ELSE
          OPEN Lc_TotalOltsCpm FOR Lcl_ConsultaTotalOltsCpm 
          USING Lv_TipoOlt, Lv_EstadoEliminado, Lv_EstadoPendiente, Lv_DescripcionSolCpm, Lv_EstadoActivo, Lv_DetalleMiddleware, Lv_EstadoActivo, 
                Lv_Si, Lv_DetalleAprovisionaIp, Lv_EstadoActivo, Lv_Cnr, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_DetalleCpmMd, Lv_EstadoActivo, Lv_Fin;
        END IF;
        FETCH Lc_TotalOltsCpm INTO Pn_TotalOltsCpm;
        CLOSE Lc_TotalOltsCpm;
      ELSE
        Pn_TotalOltsCpm := 0;
      END IF;
      Pv_Status                := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      Prf_OltsCpm       := NULL;
      Pn_TotalOltsCpm   := 0;
      Pv_Status         := 'ERROR';
      Pv_MsjError       := 'No se ha podido realizar la consulta de manera correcta. Por favor comuníquese con Sistemas';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'TECNK_SERVICIOS.P_GET_OLTS_INICIO_CPM', 
                                            'Error al obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_OLTS_INICIO_CPM;

  PROCEDURE P_GET_SERV_IPS_MIGRACION(
    Pn_IdElementoOlt            IN NUMBER,
    Pv_RetornaDataServicios     IN VARCHAR2,
    Pv_RetornaTotalServicios    IN VARCHAR2,
    Pv_Status                   OUT VARCHAR2,
    Pv_MsjError                 OUT VARCHAR2,
    Prf_ServiciosIps            OUT SYS_REFCURSOR,
    Pn_TotalServiciosIps        OUT NUMBER)
  AS
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_EstadoInCorte            VARCHAR2(8) := 'In-Corte';
    Lv_Si                       VARCHAR2(2) := 'SI';
    Lv_No                       VARCHAR2(2) := 'NO';
    Lv_CaractEdicionLimitada    VARCHAR2(16) := 'EDICION LIMITADA';
    Lv_TipoElementoOlt          VARCHAR2(3) := 'OLT';
    Lv_NombreTecnicoSb          VARCHAR2(23) := 'INTERNET SMALL BUSINESS';
    Lv_NombreTecnicoIpSb        VARCHAR2(4) := 'IPSB';
    Lv_NombreTecnicoIp          VARCHAR2(2) := 'IP';
    Lv_DelimitadorConcatIp      VARCHAR2(3) := '***';
    Lv_Rownum                   NUMBER := 1;
    Lc_TotalServiciosIps        SYS_REFCURSOR;
    Lcl_InfoServiciosInternet   CLOB;
    Lcl_ServiciosInternetConIp  CLOB;
    Lcl_ServiciosAdicionalesIp  CLOB;
    Lcl_ConsultaPrincipal       CLOB;
    Lcl_ConsultaTotalServicios  CLOB;
    BEGIN
      Lcl_InfoServiciosInternet := 'WITH INFO_SERVICIOS_INTERNET_X_OLT AS
                                    ( SELECT DISTINCT PUNTO.ID_PUNTO,
                                      PUNTO.LOGIN,
                                      SERVICIO_INTERNET.ID_SERVICIO,
                                      SERVICIO_INTERNET.ESTADO           AS ESTADO_SERVICIO,
                                      SERVICIO_INTERNET.CANTIDAD         AS CANTIDAD_SERVICIO,
                                      PROD_SERVICIO.ID_PRODUCTO          AS ID_PROD_SERVICIO_INTERNET,
                                      PROD_SERVICIO.DESCRIPCION_PRODUCTO AS DESCRIP_PROD_SERVICIO_INTERNET,
                                      PLAN_CAB.ID_PLAN                   AS ID_PLAN_SERVICIO_INTERNET,
                                      PLAN_CAB.NOMBRE_PLAN               AS NOMBRE_PLAN_SERVICIO_INTERNET,
                                      DET_PLAN_IP.ID_ITEM_IP_PLAN,
                                      DET_PLAN_IP.CANTIDAD_IP_PLAN,
                                      DET_PLAN_IP.ID_PROD_IP_PLAN,
                                      DET_PLAN_IP.DESCRIPCION_PROD_IP_PLAN,
                                      CASE
                                        WHEN PLAN_CAB.ID_PLAN IS NOT NULL
                                        THEN NVL(
                                          (SELECT INFO_PLAN_CARACT.VALOR
                                          FROM DB_COMERCIAL.INFO_PLAN_CARACTERISTICA INFO_PLAN_CARACT
                                          INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
                                          ON CARACT.ID_CARACTERISTICA           = INFO_PLAN_CARACT.CARACTERISTICA_ID
                                          WHERE INFO_PLAN_CARACT.PLAN_ID        = PLAN_CAB.ID_PLAN
                                          AND INFO_PLAN_CARACT.VALOR            = :paramSi
                                          AND INFO_PLAN_CARACT.ESTADO           = PLAN_CAB.ESTADO
                                          AND CARACT.DESCRIPCION_CARACTERISTICA = :paramCaractEdicionLimitada
                                          AND CARACT.ESTADO                     = :paramEstadoActivo1
                                          AND ROWNUM                            = :paramRownum1
                                          ), :paramNo1)
                                        ELSE :paramNo2
                                      END AS ES_PLAN_EDICION_LIMITADA
                                    FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
                                    INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_OLT
                                    ON MODELO_OLT.ID_MODELO_ELEMENTO = OLT.MODELO_ELEMENTO_ID
                                    INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_OLT
                                    ON TIPO_OLT.ID_TIPO_ELEMENTO = MODELO_OLT.TIPO_ELEMENTO_ID
                                    INNER JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_OLT
                                    ON INTERFACE_OLT.ELEMENTO_ID = OLT.ID_ELEMENTO
                                    INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO_INTERNET
                                    ON SERVICIO_TECNICO_INTERNET.ELEMENTO_ID = OLT.ID_ELEMENTO
                                    INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO_INTERNET
                                    ON SERVICIO_INTERNET.ID_SERVICIO = SERVICIO_TECNICO_INTERNET.SERVICIO_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
                                    ON PUNTO.ID_PUNTO = SERVICIO_INTERNET.PUNTO_ID
                                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
                                    ON PLAN_CAB.ID_PLAN = SERVICIO_INTERNET.PLAN_ID
                                    LEFT JOIN
                                      (SELECT PLAN_DET.ID_ITEM AS ID_ITEM_IP_PLAN,
                                        PLAN_DET.PLAN_ID,
                                        PLAN_DET.ESTADO                AS ESTADO_PLAN_DET_IP,
                                        PLAN_DET.CANTIDAD_DETALLE      AS CANTIDAD_IP_PLAN,
                                        PROD_PLAN.ID_PRODUCTO          AS ID_PROD_IP_PLAN,
                                        PROD_PLAN.DESCRIPCION_PRODUCTO AS DESCRIPCION_PROD_IP_PLAN
                                      FROM DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                                      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_PLAN
                                      ON PROD_PLAN.ID_PRODUCTO              = PLAN_DET.PRODUCTO_ID
                                      WHERE PROD_PLAN.NOMBRE_TECNICO        = :paramNombreTecnicoIp1
                                      ) DET_PLAN_IP ON (DET_PLAN_IP.PLAN_ID = PLAN_CAB.ID_PLAN
                                    AND PLAN_CAB.ESTADO                     = DET_PLAN_IP.ESTADO_PLAN_DET_IP)
                                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_SERVICIO
                                    ON PROD_SERVICIO.ID_PRODUCTO                        = SERVICIO_INTERNET.PRODUCTO_ID
                                    WHERE OLT.ID_ELEMENTO                               = :paramIdElementoOlt
                                    AND TIPO_OLT.NOMBRE_TIPO_ELEMENTO                   = :paramTipoElementoOlt
                                    AND SERVICIO_TECNICO_INTERNET.INTERFACE_ELEMENTO_ID = INTERFACE_OLT.ID_INTERFACE_ELEMENTO
                                    AND (SERVICIO_INTERNET.ESTADO                       = :paramEstadoActivo2
                                    OR SERVICIO_INTERNET.ESTADO                         = :paramEstadoInCorte1)
                                    AND (PLAN_CAB.ID_PLAN                              IS NOT NULL
                                    OR (PROD_SERVICIO.ID_PRODUCTO                      IS NOT NULL
                                    AND PROD_SERVICIO.NOMBRE_TECNICO                    = :paramNombreTecnicoSb))
                                    ) ';
   
      Lcl_ServiciosInternetConIp := ' 
                                    SELECT DISTINCT INFO_SERVICIOS_INTERNET_CON_IP.ID_PUNTO,
                                    INFO_SERVICIOS_INTERNET_CON_IP.LOGIN,
                                    INFO_SERVICIOS_INTERNET_CON_IP.ID_SERVICIO,
                                    INFO_SERVICIOS_INTERNET_CON_IP.ESTADO_SERVICIO,
                                    (SELECT CONCAT(INFO_IP_SERVICIO.ID_IP, CONCAT(:paramDelimitadorConcatIp1, INFO_IP_SERVICIO.IP))
                                    FROM DB_INFRAESTRUCTURA.INFO_IP INFO_IP_SERVICIO
                                    WHERE INFO_IP_SERVICIO.SERVICIO_ID = INFO_SERVICIOS_INTERNET_CON_IP.ID_SERVICIO
                                    AND INFO_IP_SERVICIO.ESTADO        = :paramEstadoActivo3
                                    AND ROWNUM                         = :paramRownum2
                                    )                                                             AS INFORMACION_IP_SERVICIO,
                                    INFO_SERVICIOS_INTERNET_CON_IP.ID_PROD_SERVICIO_INTERNET      AS ID_PRODUCTO_SERVICIO,
                                    INFO_SERVICIOS_INTERNET_CON_IP.DESCRIP_PROD_SERVICIO_INTERNET AS DESCRIPCION_PRODUCTO_SERVICIO,
                                    INFO_SERVICIOS_INTERNET_CON_IP.ID_PLAN_SERVICIO_INTERNET      AS ID_PLAN_SERVICIO,
                                    INFO_SERVICIOS_INTERNET_CON_IP.NOMBRE_PLAN_SERVICIO_INTERNET  AS NOMBRE_PLAN_SERVICIO,
                                    INFO_SERVICIOS_INTERNET_CON_IP.ID_ITEM_IP_PLAN,
                                    INFO_SERVICIOS_INTERNET_CON_IP.ID_PROD_IP_PLAN,
                                    INFO_SERVICIOS_INTERNET_CON_IP.DESCRIPCION_PROD_IP_PLAN,
                                    CASE
                                      WHEN INFO_SERVICIOS_INTERNET_CON_IP.ID_PLAN_SERVICIO_INTERNET IS NOT NULL
                                      THEN INFO_SERVICIOS_INTERNET_CON_IP.NOMBRE_PLAN_SERVICIO_INTERNET
                                      ELSE INFO_SERVICIOS_INTERNET_CON_IP.DESCRIP_PROD_SERVICIO_INTERNET
                                    END AS DESCRIPCION_PLAN_PRODUCTO,
                                    CASE
                                      WHEN INFO_SERVICIOS_INTERNET_CON_IP.ID_PLAN_SERVICIO_INTERNET IS NOT NULL
                                      THEN INFO_SERVICIOS_INTERNET_CON_IP.ID_PROD_IP_PLAN
                                      ELSE INFO_SERVICIOS_INTERNET_CON_IP.ID_PROD_SERVICIO_INTERNET
                                    END AS ID_PRODUCTO_IP_SERVICIO,
                                    CASE
                                      WHEN INFO_SERVICIOS_INTERNET_CON_IP.ID_PLAN_SERVICIO_INTERNET IS NOT NULL
                                      THEN NVL(INFO_SERVICIOS_INTERNET_CON_IP.CANTIDAD_IP_PLAN, 0)
                                      ELSE NVL(INFO_SERVICIOS_INTERNET_CON_IP.CANTIDAD_SERVICIO,0)
                                    END AS CANTIDAD_IPS
                                  FROM INFO_SERVICIOS_INTERNET_X_OLT INFO_SERVICIOS_INTERNET_CON_IP
                                  WHERE ( (ID_PLAN_SERVICIO_INTERNET IS NOT NULL
                                  AND ID_ITEM_IP_PLAN                IS NOT NULL
                                  AND ES_PLAN_EDICION_LIMITADA        = :paramNo3)
                                  OR (ID_PROD_SERVICIO_INTERNET      IS NOT NULL) ) ';

      Lcl_ServiciosAdicionalesIp := ' 
                                    SELECT DISTINCT INFO_PTOS_INTERNET_X_OLT.ID_PUNTO,
                                    INFO_PTOS_INTERNET_X_OLT.LOGIN,
                                    SERVICIOS_IPS_ADICIONALES.ID_SERVICIO,
                                    SERVICIOS_IPS_ADICIONALES.ESTADO AS ESTADO_SERVICIO,
                                    (SELECT CONCAT(INFO_IP_SERVICIO.ID_IP, CONCAT(:paramDelimitadorConcatIp2, INFO_IP_SERVICIO.IP))
                                    FROM DB_INFRAESTRUCTURA.INFO_IP INFO_IP_SERVICIO
                                    WHERE INFO_IP_SERVICIO.SERVICIO_ID = SERVICIOS_IPS_ADICIONALES.ID_SERVICIO
                                    AND INFO_IP_SERVICIO.ESTADO        = :paramEstadoActivo4
                                    AND ROWNUM                         = :paramRownum3
                                    )                                         AS INFORMACION_IP_SERVICIO,
                                    PROD_IP_ADICIONAL.ID_PRODUCTO             AS ID_PRODUCTO_SERVICIO,
                                    PROD_IP_ADICIONAL.DESCRIPCION_PRODUCTO    AS DESCRIPCION_PRODUCTO_SERVICIO,
                                    NULL                                      AS ID_PLAN_SERVICIO,
                                    NULL                                      AS NOMBRE_PLAN_SERVICIO,
                                    NULL                                      AS ID_ITEM_IP_PLAN,
                                    NULL                                      AS ID_PROD_IP_PLAN,
                                    NULL                                      AS DESCRIPCION_PROD_IP_PLAN,
                                    PROD_IP_ADICIONAL.DESCRIPCION_PRODUCTO    AS DESCRIPCION_PLAN_PRODUCTO,
                                    PROD_IP_ADICIONAL.ID_PRODUCTO             AS ID_PRODUCTO_IP_SERVICIO,
                                    NVL(SERVICIOS_IPS_ADICIONALES.CANTIDAD,0) AS CANTIDAD_IPS
                                  FROM INFO_SERVICIOS_INTERNET_X_OLT INFO_PTOS_INTERNET_X_OLT
                                  INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIOS_IPS_ADICIONALES
                                  ON SERVICIOS_IPS_ADICIONALES.PUNTO_ID = INFO_PTOS_INTERNET_X_OLT.ID_PUNTO
                                  INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_IP_ADICIONAL
                                  ON PROD_IP_ADICIONAL.ID_PRODUCTO        = SERVICIOS_IPS_ADICIONALES.PRODUCTO_ID
                                  WHERE (SERVICIOS_IPS_ADICIONALES.ESTADO = :paramEstadoActivo5
                                  OR SERVICIOS_IPS_ADICIONALES.ESTADO     = :paramEstadoInCorte2)
                                  AND (PROD_IP_ADICIONAL.NOMBRE_TECNICO   = :paramNombreTecnicoIp1
                                  OR PROD_IP_ADICIONAL.NOMBRE_TECNICO     = :paramNombreTecnicoIpSb) ';
      IF Pv_RetornaDataServicios = 'SI' THEN
        Lcl_ConsultaPrincipal := Lcl_InfoServiciosInternet || Lcl_ServiciosInternetConIp || ' UNION ' || Lcl_ServiciosAdicionalesIp;
        OPEN Prf_ServiciosIps FOR Lcl_ConsultaPrincipal 
        USING Lv_Si, Lv_CaractEdicionLimitada, Lv_EstadoActivo, Lv_Rownum, Lv_No, Lv_No, Lv_NombreTecnicoIp, Pn_IdElementoOlt, Lv_TipoElementoOlt,
              Lv_EstadoActivo, Lv_EstadoInCorte, Lv_NombreTecnicoSb, Lv_DelimitadorConcatIp, Lv_EstadoActivo, Lv_Rownum, Lv_No, 
              Lv_DelimitadorConcatIp, Lv_EstadoActivo, Lv_Rownum, Lv_EstadoActivo, Lv_EstadoInCorte, Lv_NombreTecnicoIp, Lv_NombreTecnicoIpSb;
      ELSE
        Prf_ServiciosIps := NULL;
      END IF;
      IF Pv_RetornaTotalServicios = 'SI' THEN
        Lcl_ConsultaTotalServicios := Lcl_InfoServiciosInternet || ' SELECT NVL(SUM(CANTIDAD_IPS),0) AS TOTAL_IPS FROM (' 
                                      || Lcl_ServiciosInternetConIp || ' UNION ' || Lcl_ServiciosAdicionalesIp || ') ';
        OPEN Lc_TotalServiciosIps FOR Lcl_ConsultaTotalServicios 
        USING Lv_Si, Lv_CaractEdicionLimitada, Lv_EstadoActivo, Lv_Rownum, Lv_No, Lv_No, Lv_NombreTecnicoIp, Pn_IdElementoOlt, Lv_TipoElementoOlt,
              Lv_EstadoActivo, Lv_EstadoInCorte, Lv_NombreTecnicoSb, Lv_DelimitadorConcatIp, Lv_EstadoActivo, Lv_Rownum, Lv_No, 
              Lv_DelimitadorConcatIp, Lv_EstadoActivo, Lv_Rownum, Lv_EstadoActivo, Lv_EstadoInCorte, Lv_NombreTecnicoIp, Lv_NombreTecnicoIpSb;
        FETCH Lc_TotalServiciosIps INTO Pn_TotalServiciosIps;
        CLOSE Lc_TotalServiciosIps;
      ELSE
        Pn_TotalServiciosIps := 0;
      END IF;
      Pv_Status                := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      Prf_ServiciosIps          := NULL;
      Pn_TotalServiciosIps := 0;
      Pv_Status                 := 'ERROR';
      Pv_MsjError               := 'No se ha podido realizar la consulta de manera correcta. Por favor comuníquese con Sistemas';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'TECNK_SERVICIOS.P_GET_SERV_IPS_MIGRACION', 
                                            'Error al obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_SERV_IPS_MIGRACION;

  PROCEDURE P_GET_PTOS_INTERNET_X_REINTEN( 
    Pn_IdElementoOlt    IN NUMBER,
    Prf_Registros       OUT SYS_REFCURSOR,
    Pv_Status           OUT VARCHAR2,
    Pv_MsjError         OUT VARCHAR2)
  AS
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_EstadoInCorte            VARCHAR2(8) := 'In-Corte';
    Lv_EstadoEnPruebas          VARCHAR2(9) := 'EnPruebas';
    Lv_EstadoEnVerificacion     VARCHAR2(14) := 'EnVerificacion';
    Lv_EstadoEliminado          VARCHAR2(9) := 'Eliminado';
    Lv_NombreTecnicoInternet    VARCHAR2(8) := 'INTERNET';
    Lv_CodEmpresa               VARCHAR2(2) := '18';
    Lv_TipoRolCliente           VARCHAR2(7) := 'Cliente';
    Lv_ParamAntivirus           VARCHAR2(27) := 'ANTIVIRUS_PLANES_Y_PRODS_MD';
    Lv_SuscriberId              VARCHAR2(12) := 'SUSCRIBER_ID';
    Lv_CaractAntivirus          VARCHAR2(9) := 'ANTIVIRUS';
    Lv_Nuevo                    VARCHAR2(5) := 'NUEVO';
    Lv_Anterior                 VARCHAR2(8) := 'ANTERIOR';
    Lv_NumReintentos            VARCHAR2(17):= 'NUMERO REINTENTOS';
    Lv_EstadoPendiente          VARCHAR2(9) := 'Pendiente';
    Ln_Rownum                   NUMBER := 1;
    Lv_InfoCliente              VARCHAR2(4000);
    Lv_SelectPrincipal          VARCHAR2(4000);
    Lcl_Select                  CLOB;
    Lcl_FromJoin                CLOB;
    Lv_Where                    VARCHAR2(4000);
    Lv_WherePrincipal           VARCHAR2(4000);
    Lcl_ConsultaPrincipal       CLOB;
    BEGIN
      Lv_SelectPrincipal      := '  SELECT ID_ELEMENTO,
                                    NOMBRE_ELEMENTO,
                                    ID_PUNTO,
                                    LOGIN,
                                    USR_VENDEDOR_PTO,
                                    ID_PERSONA_ROL,
                                    IDENTIFICACION_CLIENTE,
                                    NOMBRES,
                                    APELLIDOS,
                                    RAZON_SOCIAL,
                                    CLIENTE,
                                    NOMBRE_JURISDICCION,
                                    ID_SERVICIO_INTERNET,
                                    TIPO_ORDEN_INTERNET,
                                    ESTADO_SERVICIO_INTERNET,
                                    USR_VENDEDOR_SERVICIO_INTERNET,
                                    ID_PTO_FACT_SERVICIO_INTERNET,
                                    ID_UM_SERVICIO_INTERNET,
                                    ID_PLAN,
                                    NOMBRE_PLAN,
                                    ID_ITEM_INTERNET,
                                    ID_PROD_INTERNET,
                                    DESCRIPCION_PROD_INTERNET,
                                    ID_ITEM_I_PROTEGIDO,
                                    ESTADO_PLAN_DET_I_PROTEGIDO,
                                    ID_PROD_I_PROTEGIDO,
                                    DESCRIPCION_PROD_I_PROTEGIDO,
                                    VALOR_SPC_SUSCRIBER_ID,
                                    VALOR_SPC_ANTIVIRUS,
                                    CANTIDAD_SERVICIOS_ADICIONALES ';
      Lcl_Select              := '  SELECT DISTINCT OLT.ID_ELEMENTO,
                                    OLT.NOMBRE_ELEMENTO,
                                    INFO_CLIENTE.ID_PUNTO,
                                    INFO_CLIENTE.LOGIN,
                                    INFO_CLIENTE.USR_VENDEDOR_PTO,
                                    INFO_CLIENTE.ID_PERSONA_ROL,
                                    INFO_CLIENTE.IDENTIFICACION_CLIENTE,
                                    INFO_CLIENTE.NOMBRES,
                                    INFO_CLIENTE.APELLIDOS,
                                    INFO_CLIENTE.RAZON_SOCIAL,
                                    INFO_CLIENTE.CLIENTE,
                                    INFO_CLIENTE.NOMBRE_JURISDICCION,
                                    SERVICIO_INTERNET.ID_SERVICIO AS ID_SERVICIO_INTERNET,
                                    SERVICIO_INTERNET.TIPO_ORDEN  AS TIPO_ORDEN_INTERNET,
                                    SERVICIO_INTERNET.ESTADO  AS ESTADO_SERVICIO_INTERNET,
                                    SERVICIO_INTERNET.USR_VENDEDOR  AS USR_VENDEDOR_SERVICIO_INTERNET,
                                    SERVICIO_INTERNET.PUNTO_FACTURACION_ID AS ID_PTO_FACT_SERVICIO_INTERNET,
                                    SERVICIO_TECNICO_INTERNET.ULTIMA_MILLA_ID AS ID_UM_SERVICIO_INTERNET,
                                    PLAN_CAB.ID_PLAN,
                                    PLAN_CAB.NOMBRE_PLAN,
                                    PLAN_DET_INTERNET.ID_ITEM                   AS ID_ITEM_INTERNET,
                                    PRODUCTO_PLAN_INTERNET.ID_PRODUCTO          AS ID_PROD_INTERNET,
                                    PRODUCTO_PLAN_INTERNET.DESCRIPCION_PRODUCTO AS DESCRIPCION_PROD_INTERNET,
                                    DET_PLAN_I_PROTEGIDO.ID_ITEM_I_PROTEGIDO,
                                    DET_PLAN_I_PROTEGIDO.ESTADO_PLAN_DET_I_PROTEGIDO,
                                    DET_PLAN_I_PROTEGIDO.ID_PROD_I_PROTEGIDO,
                                    DET_PLAN_I_PROTEGIDO.DESCRIPCION_PROD_I_PROTEGIDO,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET.ID_SERVICIO, :paramSuscriberId) 
                                    AS VALOR_SPC_SUSCRIBER_ID,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET.ID_SERVICIO, :paramCaractAntivirus) 
                                    AS VALOR_SPC_ANTIVIRUS,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET.ID_SERVICIO, :paramNumReintentos) 
                                    AS VALOR_SPC_REINTENTOS,
                                    ( SELECT DISTINCT COUNT(DISTINCT SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO)
                                    FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_ADIC_I_PROTEGIDO
                                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                    ON PRODUCTO.ID_PRODUCTO = SERVICIO_ADIC_I_PROTEGIDO.PRODUCTO_ID
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                    ON PARAM_DET.VALOR3 = PRODUCTO.DESCRIPCION_PRODUCTO
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                    ON PARAM_CAB.ID_PARAMETRO  = PARAM_DET.PARAMETRO_ID
                                    WHERE SERVICIO_ADIC_I_PROTEGIDO.ESTADO IN (:paramEstadoPendienteAdic1)
                                    AND TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, 
                                                                                       :paramSuscriberIdAdic) IS NULL
                                    AND TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, 
                                                                                       :paramCaractAntivirusAdic) IS NULL
                                    AND SERVICIO_ADIC_I_PROTEGIDO.PUNTO_ID = ID_PUNTO
                                    AND PARAM_CAB.NOMBRE_PARAMETRO  = :paramAntivirusAdic
                                    AND PARAM_CAB.ESTADO = :paramEstadoActivoAdic2
                                    AND PARAM_DET.VALOR1 = :paramAnteriorAdic
                                    AND PARAM_DET.ESTADO = :paramEstadoActivoAdic3
                                    ) AS CANTIDAD_SERVICIOS_ADICIONALES,
                                    ROW_NUMBER() OVER (PARTITION BY OLT.ID_ELEMENTO, INFO_CLIENTE.ID_PUNTO, INFO_CLIENTE.ID_PERSONA_ROL 
                                                       ORDER BY SERVICIO_INTERNET.ID_SERVICIO DESC) RN_SERVICIO ';

      Lv_InfoCliente          := ' (SELECT *
                                    FROM
                                      (SELECT PUNTO.ID_PUNTO,
                                        PUNTO.LOGIN,
                                        PUNTO.USR_VENDEDOR AS USR_VENDEDOR_PTO,
                                        PER.ID_PERSONA_ROL,
                                        PERSONA.IDENTIFICACION_CLIENTE IDENTIFICACION_CLIENTE,
                                        PERSONA.NOMBRES,
                                        PERSONA.APELLIDOS,
                                        PERSONA.RAZON_SOCIAL,
                                        CASE
                                          WHEN PERSONA.RAZON_SOCIAL IS NOT NULL
                                          THEN DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.RAZON_SOCIAL)
                                          ELSE DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.NOMBRES)
                                            || '' ''
                                            || DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.APELLIDOS)
                                        END CLIENTE,
                                        JURISDICCION.NOMBRE_JURISDICCION,
                                        ROW_NUMBER() OVER (PARTITION BY PUNTO.ID_PUNTO ORDER BY PER.ID_PERSONA_ROL DESC) RN
                                      FROM DB_COMERCIAL.INFO_PUNTO PUNTO
                                      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                                      ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
                                      INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
                                      ON PERSONA.ID_PERSONA = PER.PERSONA_ID
                                      INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER
                                      ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
                                      INNER JOIN DB_COMERCIAL.ADMI_ROL ROL
                                      ON ROL.ID_ROL = ER.ROL_ID
                                      INNER JOIN DB_COMERCIAL.ADMI_TIPO_ROL TIPO_ROL
                                      ON TIPO_ROL.ID_TIPO_ROL           = ROL.TIPO_ROL_ID
                                      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
                                      ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID
                                      WHERE PER.ESTADO                  = :paramEstadoActivo1
                                      AND ER.EMPRESA_COD                = :paramCodEmpresa1
                                      AND TIPO_ROL.DESCRIPCION_TIPO_ROL = :paramTipoRolCliente
                                      )
                                    WHERE RN = :paramRownum1
                                    ) 
                                    INFO_CLIENTE ';
  
      Lcl_FromJoin            := '  FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_INTERNET
                                    INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO_INTERNET
                                    ON SERVICIO_TECNICO_INTERNET.SERVICIO_ID = SERVICIO_INTERNET.ID_SERVICIO
                                    INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
                                    ON OLT.ID_ELEMENTO = SERVICIO_TECNICO_INTERNET.ELEMENTO_ID
                                    INNER JOIN ' || Lv_InfoCliente || '
                                    ON INFO_CLIENTE.ID_PUNTO = SERVICIO_INTERNET.PUNTO_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
                                    ON PLAN_CAB.ID_PLAN = SERVICIO_INTERNET.PLAN_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET_INTERNET
                                    ON PLAN_DET_INTERNET.PLAN_ID = PLAN_CAB.ID_PLAN
                                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO_PLAN_INTERNET
                                    ON PRODUCTO_PLAN_INTERNET.ID_PRODUCTO     = PLAN_DET_INTERNET.PRODUCTO_ID 
                                    LEFT JOIN
                                      (SELECT PLAN_CAB.ID_PLAN,
                                        PLAN_DET.ID_ITEM              AS ID_ITEM_I_PROTEGIDO,
                                        PLAN_DET.ESTADO               AS ESTADO_PLAN_DET_I_PROTEGIDO,
                                        PRODUCTO.ID_PRODUCTO          AS ID_PROD_I_PROTEGIDO,
                                        PRODUCTO.DESCRIPCION_PRODUCTO AS DESCRIPCION_PROD_I_PROTEGIDO
                                      FROM DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
                                      INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                                      ON PLAN_DET.PLAN_ID = PLAN_CAB.ID_PLAN
                                      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                      ON PRODUCTO.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
                                      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                      ON PARAM_DET.VALOR3 = PRODUCTO.DESCRIPCION_PRODUCTO
                                      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                      ON PARAM_CAB.ID_PARAMETRO                              = PARAM_DET.PARAMETRO_ID
                                      WHERE PLAN_DET.ESTADO                                 <> :paramEstadoEliminado1
                                      AND PARAM_CAB.NOMBRE_PARAMETRO                         = :paramParametroAntivirus
                                      AND PARAM_CAB.ESTADO                                   = :paramEstadoActivo2
                                      AND PARAM_DET.VALOR1                                   = :paramNuevo
                                      AND PARAM_DET.ESTADO                                   = :paramEstadoActivo3
                                      ) DET_PLAN_I_PROTEGIDO ON DET_PLAN_I_PROTEGIDO.ID_PLAN = PLAN_CAB.ID_PLAN ';
  
      Lv_Where                := '  WHERE SERVICIO_INTERNET.ESTADO  IN (:paramEstadoActivo4, :paramEstadoInCorte, 
                                    :paramEstadoEnPruebas, :paramEnVerificacion)
                                    AND PLAN_DET_INTERNET.ESTADO <> :paramEstadoEliminado2
                                    AND PRODUCTO_PLAN_INTERNET.NOMBRE_TECNICO = :paramNombreTecnicoInternet
                                    AND PRODUCTO_PLAN_INTERNET.ESTADO         = :paramEstadoActivo5
                                    AND PRODUCTO_PLAN_INTERNET.EMPRESA_COD    = :paramCodEmpresa2 
                                    AND OLT.ID_ELEMENTO = :Pn_IdElementoOlt ';
      Lv_WherePrincipal       := '  WHERE RN_SERVICIO = :paramRownum2 
                                    AND ((ID_ITEM_I_PROTEGIDO        IS NOT NULL
                                    AND VALOR_SPC_SUSCRIBER_ID       IS NULL
                                    AND VALOR_SPC_REINTENTOS         IS NOT NULL )
                                    OR CANTIDAD_SERVICIOS_ADICIONALES > 0 ) '; 
      Lcl_ConsultaPrincipal := Lv_SelectPrincipal || ' FROM (' || Lcl_Select || Lcl_FromJoin || Lv_Where || ') ' || Lv_WherePrincipal;
      
            
      OPEN Prf_Registros FOR Lcl_ConsultaPrincipal 
      USING Lv_SuscriberId, Lv_CaractAntivirus, Lv_NumReintentos, 
            Lv_EstadoPendiente, Lv_SuscriberId, Lv_CaractAntivirus, Lv_ParamAntivirus, Lv_EstadoActivo, Lv_Anterior, Lv_EstadoActivo,
            Lv_EstadoActivo, Lv_CodEmpresa, Lv_TipoRolCliente, Ln_Rownum, 
            Lv_EstadoEliminado, Lv_ParamAntivirus, Lv_EstadoActivo, Lv_Nuevo, Lv_EstadoActivo,
            Lv_EstadoActivo, Lv_EstadoInCorte, Lv_EstadoEnPruebas, Lv_EstadoEnVerificacion, Lv_EstadoEliminado,
            Lv_NombreTecnicoInternet, Lv_EstadoActivo, Lv_CodEmpresa, Pn_IdElementoOlt, Ln_Rownum;
      Pv_Status                := 'OK';
      
    EXCEPTION
    WHEN OTHERS THEN
      Prf_Registros             := NULL;
      Pv_Status                 := 'ERROR';
      Pv_MsjError               := 'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                    || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'TECNK_SERVICIOS.P_GET_PTOS_INTERNET_X_OLT', 
                                            Pv_MsjError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_PTOS_INTERNET_X_REINTEN;
  
  PROCEDURE P_GET_REINT_ADICS_I_PROTEGIDO(
    Pn_IdPunto      IN NUMBER,
    Prf_Registros   OUT SYS_REFCURSOR,
    Pv_Status       OUT VARCHAR2,
    Pv_MsjError     OUT VARCHAR2)
  AS
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_EstadoPendiente          VARCHAR2(9) := 'Pendiente';
    Lv_ParamAntivirus           VARCHAR2(27) := 'ANTIVIRUS_PLANES_Y_PRODS_MD';
    Lv_CantidadDisp             VARCHAR2(21) := 'CANTIDAD DISPOSITIVOS';
    Lv_SuscriberId              VARCHAR2(12) := 'SUSCRIBER_ID';
    Lv_Anterior                 VARCHAR2(8) := 'ANTERIOR';
    Lv_IProtegido               VARCHAR2(12) := 'I. PROTEGIDO';
    Lv_CaractAntivirus          VARCHAR2(9) := 'ANTIVIRUS';
    Lv_SelectPrincipal          VARCHAR2(4000);
    Lv_Select                   VARCHAR2(4000);
    Lcl_FromJoin                CLOB;
    Lv_Where                    VARCHAR2(4000);
    Lv_WherePrincipal           VARCHAR2(4000);
    Lcl_ConsultaPrincipal       CLOB;
    BEGIN
      Lv_SelectPrincipal      := '  SELECT ID_SERVICIO,
                                    ID_PUNTO,
                                    LOGIN,
                                    ID_PRODUCTO,
                                    DESCRIPCION_PRODUCTO,
                                    PRECIO_VENTA_SERVICIO,
                                    ESTADO_SERVICIO,
                                    (
                                    CASE
                                      WHEN INSTR(DESCRIPCION_PRODUCTO, :paramIProtegido) = 0
                                      THEN 1
                                      ELSE COALESCE(TO_NUMBER(REGEXP_SUBSTR(VALOR_SPC_CANT_DISP,''^\d+'')),0)
                                    END) AS CANT_DISPOSITIVOS ';
      Lv_Select               := '  SELECT DISTINCT SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO,
                                    PUNTO.ID_PUNTO,
                                    PUNTO.LOGIN,
                                    PRODUCTO.ID_PRODUCTO,
                                    PRODUCTO.DESCRIPCION_PRODUCTO,
                                    SERVICIO_ADIC_I_PROTEGIDO.PRECIO_VENTA AS PRECIO_VENTA_SERVICIO,
                                    SERVICIO_ADIC_I_PROTEGIDO.ESTADO AS ESTADO_SERVICIO,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, :paramSuscriberId) 
                                    AS VALOR_SPC_SUSCRIBER_ID,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, :paramCaractAntivirus) 
                                    AS VALOR_SPC_ANTIVIRUS,
                                    TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_ADIC_I_PROTEGIDO.ID_SERVICIO, :paramCantidadDisp) 
                                    AS VALOR_SPC_CANT_DISP ';
  
      Lcl_FromJoin            := '  FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_ADIC_I_PROTEGIDO
                                    INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
                                    ON PUNTO.ID_PUNTO = SERVICIO_ADIC_I_PROTEGIDO.PUNTO_ID
                                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                    ON PRODUCTO.ID_PRODUCTO = SERVICIO_ADIC_I_PROTEGIDO.PRODUCTO_ID
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                    ON PARAM_DET.VALOR3 = PRODUCTO.DESCRIPCION_PRODUCTO
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                    ON PARAM_CAB.ID_PARAMETRO = PARAM_DET.PARAMETRO_ID ';
  
      Lv_Where                := '  WHERE SERVICIO_ADIC_I_PROTEGIDO.ESTADO                           
                                    IN (:paramEstadoPendiente)
                                    AND PARAM_CAB.NOMBRE_PARAMETRO                                    = :paramAntivirus
                                    AND PARAM_CAB.ESTADO                                              = :paramEstadoActivo2
                                    AND PARAM_DET.VALOR1                                              = :paramAnterior
                                    AND PARAM_DET.ESTADO                                              = :paramEstadoActivo3 ';

      Lv_WherePrincipal       := '  WHERE ID_PUNTO = :paramIdPunto 
                                    AND VALOR_SPC_SUSCRIBER_ID IS NULL
                                    AND VALOR_SPC_ANTIVIRUS IS NULL ';
      Lcl_ConsultaPrincipal :=  Lv_SelectPrincipal || ' FROM (' || Lv_Select || Lcl_FromJoin || Lv_Where || ') ' || Lv_WherePrincipal;
        
      OPEN Prf_Registros FOR Lcl_ConsultaPrincipal 
      USING Lv_IProtegido, Lv_SuscriberId, Lv_CaractAntivirus, Lv_CantidadDisp, Lv_EstadoPendiente, Lv_ParamAntivirus, 
            Lv_EstadoActivo, Lv_Anterior, Lv_EstadoActivo, Pn_IdPunto;
      Pv_Status                := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      Prf_Registros             := NULL;
      Pv_Status                 := 'ERROR';
      Pv_MsjError               := 'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                    || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'TECNK_SERVICIOS.P_GET_REINT_ADICS_I_PROTEGIDO', 
                                            Pv_MsjError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_REINT_ADICS_I_PROTEGIDO;

  PROCEDURE P_VALIDA_LINEA_CSV_CPM(
    Pv_ContenidoLinea           IN VARCHAR2,
    Pv_DelimitadorCampo         IN VARCHAR2,
    Pv_Status                   OUT VARCHAR2,
    Pv_TipoError                OUT VARCHAR2,
    Pr_RegDataPorProcesar       OUT DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataPorProcesarCpm)
  AS
    Ln_Rownum                       NUMBER := 1;
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_AplicaCpm                    VARCHAR2(10) := 'APLICA_CPM';
    Lv_No                           VARCHAR2(2) := 'NO';
    Lv_NombreTecnicoInternet        VARCHAR2(8) := 'INTERNET';
    Lv_EstadoCancel                 VARCHAR2(6) := 'Cancel';
    Lv_EstadoAnulado                VARCHAR2(7) := 'Anulado';
    Lv_EstadoEliminado              VARCHAR2(9) := 'Eliminado';
    Lv_EstadoTrasladado             VARCHAR2(10) := 'Trasladado';
    Lv_Reubicado                    VARCHAR2(9) := 'Reubicado';
    Lv_Rechazada                    VARCHAR2(9) := 'Rechazada';
    Lv_SolicitudCpm                 VARCHAR2(28) := 'SOLICITUD CAMBIO PLAN MASIVO';
    Lv_EstadoFallo                  VARCHAR2(5) := 'Fallo';
    Lv_EstadoPendiente              VARCHAR2(9) := 'Pendiente';
    Lv_NombreParamValoresEquipos    VARCHAR2(19) := 'VALORES_EQUIPOS_CPM';
    Lv_Masivo                       VARCHAR2(6) := 'MASIVO';
    Lv_Cliente                      VARCHAR2(7) := 'Cliente';
    Lv_PreCliente                   VARCHAR2(11) := 'Pre-Cliente';
    Lv_CodEmpresa                   VARCHAR2(2) := '18';
    Lv_NombreParamConsulta          VARCHAR2(100);

    CURSOR Lc_GetPlan(Cv_IdPlan DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    IS
      SELECT PLAN_CAB.ID_PLAN, PLAN_CAB.TIPO,
      NVL((
        SELECT INFO_PLAN_CARACT.VALOR
        FROM DB_COMERCIAL.INFO_PLAN_CARACTERISTICA INFO_PLAN_CARACT
        INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
        ON CARACT.ID_CARACTERISTICA           = INFO_PLAN_CARACT.CARACTERISTICA_ID
        WHERE INFO_PLAN_CARACT.PLAN_ID        = PLAN_CAB.ID_PLAN
        AND INFO_PLAN_CARACT.ESTADO           = Lv_EstadoActivo
        AND CARACT.DESCRIPCION_CARACTERISTICA = Lv_AplicaCpm
        AND CARACT.ESTADO                     = Lv_EstadoActivo
        AND ROWNUM                            = Ln_Rownum
        ), Lv_No) AS APLICA_CPM
      FROM DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
      WHERE PLAN_CAB.ID_PLAN = Cv_IdPlan
      AND ROWNUM = Ln_Rownum;
    CURSOR Lc_GetPunto(Cv_LoginPunto DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE)
    IS
      SELECT PUNTO.ID_PUNTO
      FROM DB_COMERCIAL.INFO_PUNTO PUNTO
      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
      ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
      ON PERSONA.ID_PERSONA = PER.PERSONA_ID
      INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER
      ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
      INNER JOIN DB_GENERAL.ADMI_ROL ROL
      ON ROL.ID_ROL = ER.ROL_ID
      INNER JOIN DB_GENERAL.ADMI_TIPO_ROL TIPO_ROL
      ON TIPO_ROL.ID_TIPO_ROL = ROL.TIPO_ROL_ID
      WHERE PUNTO.LOGIN = Cv_LoginPunto
      AND (TIPO_ROL.DESCRIPCION_TIPO_ROL = Lv_Cliente OR TIPO_ROL.DESCRIPCION_TIPO_ROL = Lv_PreCliente)
      AND ER.EMPRESA_COD = Lv_CodEmpresa
      AND ROWNUM = Ln_Rownum;
    CURSOR Lc_GetOlt(Cv_NombreOlt DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE)
    IS
      SELECT OLT.ID_ELEMENTO, MARCA_OLT.NOMBRE_MARCA_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_OLT
      ON MODELO_OLT.ID_MODELO_ELEMENTO = OLT.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_OLT
      ON MARCA_OLT.ID_MARCA_ELEMENTO = MODELO_OLT.MARCA_ELEMENTO_ID
      WHERE OLT.NOMBRE_ELEMENTO = Cv_NombreOlt
      AND OLT.ESTADO = Lv_EstadoActivo
      AND ROWNUM = Ln_Rownum;
    CURSOR Lc_GetServicioPorIdPunto(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT SERVICIO.ID_SERVICIO, SERVICIO.PRECIO_VENTA, SERVICIO.FRECUENCIA_PRODUCTO, PLAN_CAB.ID_PLAN, PLAN_CAB.TIPO
      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
      INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_CAB
      ON PLAN_CAB.ID_PLAN = SERVICIO.PLAN_ID
      INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
      ON PLAN_DET.PLAN_ID = PLAN_CAB.ID_PLAN
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
      ON PROD.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
      WHERE PROD.NOMBRE_TECNICO = Lv_NombreTecnicoInternet
      AND SERVICIO.ESTADO NOT IN (Lv_EstadoCancel, Lv_EstadoAnulado, Lv_EstadoEliminado, Lv_EstadoTrasladado, Lv_Reubicado, Lv_Rechazada)
      AND SERVICIO.PUNTO_ID = Cn_IdPunto
      AND ROWNUM = Ln_Rownum;
    CURSOR Lc_GetCountSolicitudesCpm(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT COUNT(DISTINCT SOLICITUD.ID_DETALLE_SOLICITUD)
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOLICITUD
      ON TIPO_SOLICITUD.ID_TIPO_SOLICITUD = SOLICITUD.TIPO_SOLICITUD_ID
      WHERE SOLICITUD.SERVICIO_ID = Cn_IdServicio
      AND TIPO_SOLICITUD.DESCRIPCION_SOLICITUD = Lv_SolicitudCpm
      AND TIPO_SOLICITUD.ESTADO = Lv_EstadoActivo
      AND (SOLICITUD.ESTADO = Lv_EstadoFallo OR SOLICITUD.ESTADO = Lv_EstadoPendiente);
    CURSOR Lc_GetServicioTecnico(Cn_IdOlt DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
                                 Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT SERVICIO_TECNICO.ID_SERVICIO_TECNICO
      FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
      WHERE SERVICIO_TECNICO.ELEMENTO_ID = Cn_IdOlt
      AND SERVICIO_TECNICO.SERVICIO_ID = Cn_IdServicio
      AND ROWNUM = Ln_Rownum;

    CURSOR Lc_GetVerificaValoresEquipo(Cv_ValorEquipo DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT CAB.NOMBRE_PARAMETRO,
      NVL((SELECT DET.ID_PARAMETRO_DET
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      AND DET.VALOR1         = Lv_Masivo
      AND DET.VALOR2         = Cv_ValorEquipo
      AND DET.ESTADO         = Lv_EstadoActivo
      ),0) AS ID_DET_VALOR_EQUIPO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      WHERE CAB.NOMBRE_PARAMETRO = Lv_NombreParamValoresEquipos
      AND CAB.ESTADO             = Lv_EstadoActivo;

    Lv_VerificaValorEquipo          VARCHAR2(2) := 'NO';
    Ln_IdDetValorEquipoPermitido    NUMBER;
    Ln_IndxTCamposXLineaCsv         NUMBER;
    Lt_TCamposXLineaCsv             DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;
    Lv_NombreOltCsv                 DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE;
    Lv_LoginPuntoCsv                DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Lv_IdPlanNuevoCsv               VARCHAR2(500);
    Ln_IdPlanNuevoCsv               DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE;
    Lv_ValorEquipoCsv               VARCHAR2(500);
    Ln_IdPlanNuevo                  DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE;
    Lv_TipoPlanNuevo                DB_COMERCIAL.INFO_PLAN_CAB.TIPO%TYPE;
    Lv_AplicaCpmPlanNuevo           VARCHAR2(100);
    Ln_IdPunto                      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Ln_IdOlt                        DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE;
    Lv_MarcaOlt                     DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE;
    Ln_IdServicio                   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Ln_PrecioVenta                  DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE;
    Ln_FrecuenciaProducto           DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE;
    Ln_IdPlanViejo                  DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE;
    Lv_TipoPlanViejo                DB_COMERCIAL.INFO_PLAN_CAB.TIPO%TYPE;
    Ln_CountSolicitudesCpm          NUMBER;
    Ln_IdServicioTecnico            DB_COMERCIAL.INFO_SERVICIO_TECNICO.ID_SERVICIO_TECNICO%TYPE;
    Lv_ContinuaValidacion           VARCHAR2(2) := 'NO';
  BEGIN
    Lt_TCamposXLineaCsv       := DB_COMERCIAL.TECNK_SERVICIOS.F_SPLIT_VARCHAR2(Pv_ContenidoLinea, Pv_DelimitadorCampo);
    Ln_IndxTCamposXLineaCsv   := 0;
    Lv_NombreOltCsv           := '';
    IF Lt_TCamposXLineaCsv.EXISTS(Ln_IndxTCamposXLineaCsv) THEN
      Lv_NombreOltCsv := TRIM(Lt_TCamposXLineaCsv(Ln_IndxTCamposXLineaCsv));
    END IF;
    Ln_IndxTCamposXLineaCsv   := Ln_IndxTCamposXLineaCsv + 1;
    Lv_LoginPuntoCsv          := '';
    IF Lt_TCamposXLineaCsv.EXISTS(Ln_IndxTCamposXLineaCsv) THEN
      Lv_LoginPuntoCsv := TRIM(Lt_TCamposXLineaCsv(Ln_IndxTCamposXLineaCsv));
    END IF;
    Ln_IndxTCamposXLineaCsv   := Ln_IndxTCamposXLineaCsv + 1;
    Lv_IdPlanNuevoCsv         := '';
    IF Lt_TCamposXLineaCsv.EXISTS(Ln_IndxTCamposXLineaCsv) THEN
      Lv_IdPlanNuevoCsv := TRIM(Lt_TCamposXLineaCsv(Ln_IndxTCamposXLineaCsv));
    END IF;
    Ln_IndxTCamposXLineaCsv   := Ln_IndxTCamposXLineaCsv + 1;
    Lv_ValorEquipoCsv         := '';
    IF Lt_TCamposXLineaCsv.EXISTS(Ln_IndxTCamposXLineaCsv) THEN
      Lv_ValorEquipoCsv         := TRIM(Lt_TCamposXLineaCsv(Ln_IndxTCamposXLineaCsv));
      Lv_VerificaValorEquipo    := 'SI';
    ELSE
      Lv_ValorEquipoCsv   := '';
    END IF;
    IF Lv_NombreOltCsv IS NOT NULL AND Lv_LoginPuntoCsv IS NOT NULL AND Lv_IdPlanNuevoCsv IS NOT NULL THEN
      Ln_IdPlanNuevoCsv     := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lv_IdPlanNuevoCsv,'^\d+')),0);
      --Empieza a procesarlo
      Ln_IdPlanNuevo          := 0;
      Lv_TipoPlanNuevo        := '';
      Lv_AplicaCpmPlanNuevo   := '';
      OPEN Lc_GetPlan(Ln_IdPlanNuevoCsv);
      FETCH Lc_GetPlan INTO Ln_IdPlanNuevo, Lv_TipoPlanNuevo, Lv_AplicaCpmPlanNuevo;
      CLOSE Lc_GetPlan;
      IF Ln_IdPlanNuevo IS NOT NULL AND Ln_IdPlanNuevo > 0 THEN
        Ln_IdPunto := 0;
        OPEN Lc_GetPunto(Lv_LoginPuntoCsv);
        FETCH Lc_GetPunto INTO Ln_IdPunto;
        CLOSE Lc_GetPunto;
        IF Ln_IdPunto IS NOT NULL AND Ln_IdPunto > 0 THEN
          Ln_IdOlt    := 0;
          Lv_MarcaOlt := '';
          OPEN Lc_GetOlt(Lv_NombreOltCsv);
          FETCH Lc_GetOlt INTO Ln_IdOlt, Lv_MarcaOlt;
          CLOSE Lc_GetOlt;
          IF Ln_IdOlt IS NOT NULL AND Ln_IdOlt > 0 THEN
            IF Lv_MarcaOlt = 'HUAWEI' OR Lv_MarcaOlt = 'TELLION' OR Lv_MarcaOlt = 'ZTE' THEN
              Lv_ContinuaValidacion := 'SI';
            ELSE
            --Caso contrario de la validación de la marca del olt
              Pv_Status     := 'ERROR';
              Pv_TipoError  := 'ErrorValidaMarcaOlt';
            END IF;
            --Fin de la validación de la marca del olt
          ELSE
          --Caso contrario de la validación del id del olt
            Pv_Status     := 'ERROR';
            Pv_TipoError  := 'ErrorValidaIdOlt';
          END IF;
          --Fin de la validación del id del olt
        ELSE
        --Caso contrario de la validación del id del punto
          Pv_Status     := 'ERROR';
          Pv_TipoError  := 'ErrorValidaIdPunto';
        END IF;
        --Fin de la validación del id del punto
      ELSE
      --Caso contrario de la validación del id del plan nuevo
        Pv_Status     := 'ERROR';
        Pv_TipoError  := 'ErrorValidaIdPlanNuevo';
      END IF;
      --Fin de la validación del id del plan nuevo
    ELSE
    --Caso contrario de la validación del id del plan nuevo
      Pv_Status     := 'ERROR';
      Pv_TipoError  := 'ErrorValidaDataCsv';
    END IF;
    --Fin de la validación del nombre del olt, login del punto y id del plan nuevo

    IF Lv_ContinuaValidacion = 'SI' THEN
      Lv_ContinuaValidacion := 'NO';
      Ln_IdServicio         := 0;
      Ln_PrecioVenta        := 0;
      Ln_FrecuenciaProducto := 0;
      Ln_IdPlanViejo        := 0;
      Lv_TipoPlanViejo      := '';
      OPEN Lc_GetServicioPorIdPunto(Ln_IdPunto);
      FETCH Lc_GetServicioPorIdPunto INTO Ln_IdServicio, Ln_PrecioVenta, Ln_FrecuenciaProducto, Ln_IdPlanViejo, Lv_TipoPlanViejo;
      CLOSE Lc_GetServicioPorIdPunto;
      IF Ln_IdServicio IS NOT NULL AND Ln_IdServicio > 0 THEN
        Ln_CountSolicitudesCpm := 0;
        OPEN Lc_GetCountSolicitudesCpm(Ln_IdServicio);
        FETCH Lc_GetCountSolicitudesCpm INTO Ln_CountSolicitudesCpm;
        CLOSE Lc_GetCountSolicitudesCpm;
        IF Ln_CountSolicitudesCpm IS NOT NULL AND Ln_CountSolicitudesCpm > 0 THEN
          Pv_Status     := 'ERROR';
          Pv_TipoError  := 'ErrorValidaCountSolicitudesCpm';
        ELSE
        --Caso contrario de la validación del conteo de solicitudes de cambio de plan masivo
          IF Lv_TipoPlanViejo = Lv_TipoPlanNuevo THEN
            IF Lv_AplicaCpmPlanNuevo = 'SI' THEN
              Lv_ContinuaValidacion := 'SI';
            ELSE
            --Caso contrario de la validación de si aplica el cambio de plan masivo
              Pv_Status     := 'ERROR';
              Pv_TipoError  := 'ErrorValidaAplicaCpm';
            END IF;
            --Fin de la validación de si aplica el cambio de plan masivo
          ELSE
          --Caso contrario de la validación de comparación de tipos de planes
            Pv_Status     := 'ERROR';
            Pv_TipoError  := 'ErrorValidaTipoPlanes';
          END IF;
          --Fin de la validación de de comparación de tipos de planes
        END IF;
        --Fin de la validación del conteo de solicitudes de cambio de plan masivo
      ELSE
      --Caso contrario de la validación del id del servicio
        Pv_Status     := 'ERROR';
        Pv_TipoError  := 'ErrorValidaIdServicio';
      END IF;
      --Fin de la validación del id del servicio
    END IF;

    IF Lv_ContinuaValidacion = 'SI' THEN
      Lv_ContinuaValidacion := 'NO';
      Ln_IdServicioTecnico := 0;
      OPEN Lc_GetServicioTecnico(Ln_IdOlt, Ln_IdServicio);
      FETCH Lc_GetServicioTecnico INTO Ln_IdServicioTecnico;
      CLOSE Lc_GetServicioTecnico;
      IF Ln_IdServicioTecnico IS NOT NULL AND Ln_IdServicioTecnico > 0 THEN
        IF Lv_VerificaValorEquipo = 'SI' AND Lv_ValorEquipoCsv IS NOT NULL THEN
          OPEN Lc_GetVerificaValoresEquipo(Lv_ValorEquipoCsv);
          FETCH Lc_GetVerificaValoresEquipo INTO Lv_NombreParamConsulta, Ln_IdDetValorEquipoPermitido;
          CLOSE Lc_GetVerificaValoresEquipo;
          IF Ln_IdDetValorEquipoPermitido IS NOT NULL AND Ln_IdDetValorEquipoPermitido > 0 THEN
            Pv_Status                                   := 'OK';
            Pv_TipoError                                := '';
            Pr_RegDataPorProcesar                       := NULL;
            Pr_RegDataPorProcesar.ID_SERVICIO           := Ln_IdServicio;
            Pr_RegDataPorProcesar.LOGIN                 := Lv_LoginPuntoCsv;
            Pr_RegDataPorProcesar.PRECIO_VENTA          := Ln_PrecioVenta;
            Pr_RegDataPorProcesar.FRECUENCIA_PRODUCTO   := Ln_FrecuenciaProducto;
            Pr_RegDataPorProcesar.ID_PLAN_NUEVO         := Ln_IdPlanNuevo;
            Pr_RegDataPorProcesar.ID_PLAN_VIEJO         := Ln_IdPlanViejo;
            Pr_RegDataPorProcesar.ID_OLT                := Ln_IdOlt;
            Pr_RegDataPorProcesar.NOMBRE_OLT            := Lv_NombreOltCsv;
            Pr_RegDataPorProcesar.VALOR_EQUIPO          := Lv_ValorEquipoCsv;
          ELSE
          --Caso contrario de la validación de verificar el valor del equipo
            Pv_Status     := 'ERROR';
            Pv_TipoError  := 'ErrorValidaValorEquipo';
          END IF;
          --Fin de la validación de verificar el valor del equipo
        ELSE
        --Caso contrario de la validación de si es necesario verificar el valor del equipo
          Pv_Status                                 := 'OK';
          Pv_TipoError                              := '';
          Pr_RegDataPorProcesar                     := NULL;
          Pr_RegDataPorProcesar.ID_SERVICIO         := Ln_IdServicio;
          Pr_RegDataPorProcesar.LOGIN               := Lv_LoginPuntoCsv;
          Pr_RegDataPorProcesar.PRECIO_VENTA        := Ln_PrecioVenta;
          Pr_RegDataPorProcesar.FRECUENCIA_PRODUCTO := Ln_FrecuenciaProducto;
          Pr_RegDataPorProcesar.ID_PLAN_NUEVO       := Ln_IdPlanNuevo;
          Pr_RegDataPorProcesar.ID_PLAN_VIEJO       := Ln_IdPlanViejo;
          Pr_RegDataPorProcesar.ID_OLT              := Ln_IdOlt;
          Pr_RegDataPorProcesar.NOMBRE_OLT          := Lv_NombreOltCsv;
          Pr_RegDataPorProcesar.VALOR_EQUIPO        := Lv_ValorEquipoCsv;
        END IF;
        --Fin de la validación de si es necesario verificar el valor del equipo
      ELSE
      --Caso contrario de la validación de si aplica el cambio de plan masivo
        Pv_Status     := 'ERROR';
        Pv_TipoError  := 'ErrorValidaIdServicioTecnico';
      END IF;
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status               := 'ERROR';
    Pv_TipoError            := 'ErrorDesconocido';
    Pr_RegDataPorProcesar   := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'TECNK_SERVICIOS.P_VALIDA_LINEA_CSV_CPM', 
                                            'Error en la validación de la línea del archivo CSV para el cambio de plan masivo ' || SQLCODE 
                                            || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_VALIDA_LINEA_CSV_CPM;

  FUNCTION F_GET_ITEM_PROD_EN_PLAN( 
    Fn_IdPlan               IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Fv_NombreTecnicoProd    IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fn_IdProducto           IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    Fv_DescripcionProd      IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE)
  RETURN DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE
  IS
    Ln_IdItemPlanDet    DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE;
    Lv_Query            VARCHAR2(4000);
    Lv_Rownum           VARCHAR2(1000);
    Ln_Rownum           NUMBER(10) := 1;
    Lv_EstadoEliminado  VARCHAR2(9) := 'Eliminado';
  BEGIN
    Lv_Rownum   := 'AND ROWNUM = :paramRownum ';
    Lv_Query    := 'SELECT PLAN_DET.ID_ITEM
                    FROM DB_COMERCIAL.INFO_PLAN_CAB PLAN
                    INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                    ON PLAN_DET.PLAN_ID = PLAN.ID_PLAN
                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
                    ON PROD.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
                    WHERE PLAN.ID_PLAN = :paramIdPlan
                    AND PLAN_DET.ESTADO <> :paramEstadoEliminado ';
    IF Fv_NombreTecnicoProd IS NOT NULL THEN
      Lv_Query := Lv_Query || ' AND PROD.NOMBRE_TECNICO = :paramNombreTecnicoProd ' || Lv_Rownum;
      EXECUTE IMMEDIATE Lv_Query INTO Ln_IdItemPlanDet USING Fn_IdPlan, Lv_EstadoEliminado, Fv_NombreTecnicoProd, Ln_Rownum;
    ELSIF Fn_IdProducto IS NOT NULL THEN
      Lv_Query := Lv_Query || ' AND PROD.ID_PRODUCTO = :paramIdProducto ' || Lv_Rownum;
      EXECUTE IMMEDIATE Lv_Query INTO Ln_IdItemPlanDet USING Fn_IdPlan, Lv_EstadoEliminado, Fn_IdProducto, Ln_Rownum;
    ELSIF Fv_DescripcionProd IS NOT NULL THEN
      Lv_Query := Lv_Query || ' AND PROD.DESCRIPCION_PRODUCTO = :paramDescripcionProducto ' || Lv_Rownum;
      EXECUTE IMMEDIATE Lv_Query INTO Ln_IdItemPlanDet USING Fn_IdPlan, Lv_EstadoEliminado, Fv_DescripcionProd, Ln_Rownum;
    ELSE
      Lv_Query := Lv_Query || Lv_Rownum;
      EXECUTE IMMEDIATE Lv_Query INTO Ln_IdItemPlanDet USING Fn_IdPlan, Lv_EstadoEliminado, Ln_Rownum;
    END IF;
    RETURN Ln_IdItemPlanDet;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'TECNK_SERVICIOS.F_GET_ITEM_PROD_EN_PLAN', 
                                            'Error al verificar los detalles del plan ' || Fn_IdPlan || ' - ' 
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  END F_GET_ITEM_PROD_EN_PLAN;

  PROCEDURE P_VERIF_DET_PLAN_W_Y_EXTENDER(  
    Pn_IdPlan               IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pv_PlanConDetalleWdb    OUT VARCHAR2,
    Pv_PlanConDetalleEdb    OUT VARCHAR2
  )
  AS
    Lv_PlanConDetalleWdb    VARCHAR2(2) := 'NO';
    Lv_PlanConDetalleEdb    VARCHAR2(2) := 'NO';
    Ln_IdItemWdb            DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE;
    Ln_IdItemEdb            DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE;
    Lv_NombreTecnicoWdb     DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE := 'WIFI_DUAL_BAND';
    Lv_NombreTecnicoEdb     DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE := 'EXTENDER_DUAL_BAND';
  BEGIN
    Ln_IdItemWdb    := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_ITEM_PROD_EN_PLAN(Pn_IdPlan, Lv_NombreTecnicoWdb, NULL, NULL);
    Ln_IdItemEdb    := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_ITEM_PROD_EN_PLAN(Pn_IdPlan, Lv_NombreTecnicoEdb, NULL, NULL);
    IF Ln_IdItemWdb IS NOT NULL THEN
      Lv_PlanConDetalleWdb := 'SI';
    END IF;
    IF Ln_IdItemEdb IS NOT NULL THEN
      Lv_PlanConDetalleEdb := 'SI';
    END IF;
    Pv_Status               := 'OK';
    Pv_PlanConDetalleWdb    := Lv_PlanConDetalleWdb;
    Pv_PlanConDetalleEdb    := Lv_PlanConDetalleEdb;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status               := 'ERROR';
    Pv_MsjError             := 'No se ha podido verificar los detalles del plan asociado al servicio';
    Pv_PlanConDetalleWdb    := 'NO';
    Pv_PlanConDetalleEdb    := 'NO';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'TECNK_SERVICIOS.P_VERIF_DET_PLAN_W_Y_EXTENDER', 
                                            'Error al verificar los detalles Wifi y Extender Dual Band del plan ' || Pn_IdPlan || ' - ' 
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_VERIF_DET_PLAN_W_Y_EXTENDER;

  FUNCTION F_GET_PARAMS_SERVICIOS_MD(
    Fr_ParametroDetalleBusqueda IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE DEFAULT NULL
  )
  RETURN SYS_REFCURSOR
  IS
    Lv_NombreParamsServiciosMd  VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lcl_Query                   CLOB;
    Lrf_ParamsDetsServiciosMd   SYS_REFCURSOR;
  BEGIN

    Lcl_Query   := 'SELECT PARAM_DET.*
                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                    ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                    WHERE PARAM_CAB.NOMBRE_PARAMETRO = ''' || Lv_NombreParamsServiciosMd || '''
                    AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                    AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || ''' '; 

    IF Fr_ParametroDetalleBusqueda.VALOR1 IS NOT NULL THEN
      Lcl_Query := Lcl_Query || ' AND PARAM_DET.VALOR1 = ''' || Fr_ParametroDetalleBusqueda.VALOR1 || ''' ';
    END IF;

    IF Fr_ParametroDetalleBusqueda.VALOR2 IS NOT NULL THEN
      Lcl_Query := Lcl_Query || ' AND PARAM_DET.VALOR2 = ''' || Fr_ParametroDetalleBusqueda.VALOR2 || ''' ';
    END IF;

    IF Fr_ParametroDetalleBusqueda.VALOR3 IS NOT NULL THEN
      Lcl_Query := Lcl_Query || ' AND PARAM_DET.VALOR3 = ''' || Fr_ParametroDetalleBusqueda.VALOR3 || ''' ';
    END IF;

    IF Fr_ParametroDetalleBusqueda.VALOR4 IS NOT NULL THEN
      Lcl_Query := Lcl_Query || ' AND PARAM_DET.VALOR4 = ''' || Fr_ParametroDetalleBusqueda.VALOR4 || ''' ';
    END IF;

    IF Fr_ParametroDetalleBusqueda.VALOR5 IS NOT NULL THEN
      Lcl_Query := Lcl_Query || ' AND PARAM_DET.VALOR5 = ''' || Fr_ParametroDetalleBusqueda.VALOR5 || ''' ';
    END IF;

    IF Fr_ParametroDetalleBusqueda.VALOR6 IS NOT NULL THEN
      Lcl_Query := Lcl_Query || ' AND PARAM_DET.VALOR6 = ''' || Fr_ParametroDetalleBusqueda.VALOR6 || ''' ';
    END IF;

    IF Fr_ParametroDetalleBusqueda.VALOR7 IS NOT NULL THEN
      Lcl_Query := Lcl_Query || ' AND PARAM_DET.VALOR7 = ''' || Fr_ParametroDetalleBusqueda.VALOR7 || ''' ';
    END IF;
    OPEN Lrf_ParamsDetsServiciosMd FOR Lcl_Query;
    RETURN Lrf_ParamsDetsServiciosMd;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD', 
                                            'Error al consultar los detalles del parámetro PARAMETROS_ASOCIADOS_A_SERVICIOS_MD - ' 
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  END F_GET_PARAMS_SERVICIOS_MD;

  PROCEDURE P_VERIF_EQUIPOS_W_Y_EXTENDER(   
    Pv_VerificaEquipoWdb        IN VARCHAR2,
    Pv_VerificaEquipoEdb        IN VARCHAR2,
    Pv_TecnologiaServicio       IN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE,
    Pv_NombreModeloOlt          IN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    Pv_NombreModeloOnt          IN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    Pn_IdInterfaceOnt           IN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE,
    Pv_Status                   OUT VARCHAR2,
    Pv_MsjError                 OUT VARCHAR2,
    Pv_NecesitaCambiarWdb       OUT VARCHAR2,
    Pv_NecesitaAgregarEdb       OUT VARCHAR2,
    Pn_IdElementoSiguiente      OUT DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    Pn_IdInterfaceEleSiguiente  OUT DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE
  )
  AS
    Lr_ParametroDetalleBusqueda DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lv_ModelosEquipos           VARCHAR2(15) := 'MODELOS_EQUIPOS';
    Lv_ModelosOltEquiposdb      VARCHAR2(29) := 'MODELOS_OLT_EQUIPOS_DUAL_BAND';
    Lv_TecnologiaPermitidadb    VARCHAR2(2);
    Lv_TipoEquipoWdb            VARCHAR2(14) := 'WIFI DUAL BAND';
    Lv_TipoEquipoEdb            VARCHAR2(18) := 'EXTENDER DUAL BAND';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_NombreModeloElementoFin  DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE;
    Lrf_BusquedaEquipoWdb       SYS_REFCURSOR;
    Lrf_BusquedaEquipoEdb       SYS_REFCURSOR;
    Lr_RespuestaBusqEquipodb    DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Ln_IdElementoSiguiente      DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE;
    Ln_IdInterfaceEleSiguiente  DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE;
    CURSOR Lc_GetInfoFinEnlace(Cv_IdInterfaceElementoIni INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE)
    IS
      SELECT ELEMENTO_FIN.ID_ELEMENTO AS ID_ELEMENTO_SIGUIENTE, 
        INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO AS ID_INTERFACE_ELE_SIGUIENTE,
        MODELO_ELEMENTO_FIN.NOMBRE_MODELO_ELEMENTO AS NOMBRE_MODELO_ELEMENTO_FIN
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE
      INNER JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_ELEMENTO
      ON INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO = ENLACE.INTERFACE_ELEMENTO_FIN_ID
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO_FIN
      ON ELEMENTO_FIN.ID_ELEMENTO = INTERFACE_ELEMENTO.ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ELEMENTO_FIN
      ON MODELO_ELEMENTO_FIN.ID_MODELO_ELEMENTO = ELEMENTO_FIN.MODELO_ELEMENTO_ID
      WHERE ENLACE.ESTADO = Lv_EstadoActivo
      AND ENLACE.INTERFACE_ELEMENTO_INI_ID = Cv_IdInterfaceElementoIni
      AND ROWNUM = 1;
  BEGIN
    Lr_RespuestaBusqEquipodb            := NULL;
    Lr_ParametroDetalleBusqueda         := NULL;
    Lr_ParametroDetalleBusqueda.VALOR1  := Lv_ModelosOltEquiposdb;
    Lr_ParametroDetalleBusqueda.VALOR2  := Pv_TecnologiaServicio;
    Lr_ParametroDetalleBusqueda.VALOR3  := Pv_NombreModeloOlt;
    Lr_ParametroDetalleBusqueda.VALOR4  := NULL;
    Lr_ParametroDetalleBusqueda.VALOR5  := NULL;
    Lrf_BusquedaEquipoWdb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
    FETCH Lrf_BusquedaEquipoWdb INTO Lr_RespuestaBusqEquipodb;
    IF Lr_RespuestaBusqEquipodb.ID_PARAMETRO_DET IS NOT NULL THEN 
      Lv_TecnologiaPermitidadb := 'SI';
    ELSE
      Lv_TecnologiaPermitidadb := 'NO';
    END IF;

    IF Pv_VerificaEquipoWdb IS NOT NULL AND Pv_VerificaEquipoWdb = 'SI' AND Lv_TecnologiaPermitidadb = 'SI' THEN
      Lr_RespuestaBusqEquipodb            := NULL;
      Lr_ParametroDetalleBusqueda         := NULL;
      Lr_ParametroDetalleBusqueda.VALOR1  := Lv_ModelosEquipos;
      Lr_ParametroDetalleBusqueda.VALOR2  := Pv_TecnologiaServicio;
      Lr_ParametroDetalleBusqueda.VALOR3  := Pv_NombreModeloOlt;
      Lr_ParametroDetalleBusqueda.VALOR4  := Lv_TipoEquipoWdb;
      Lr_ParametroDetalleBusqueda.VALOR5  := Pv_NombreModeloOnt;
      Lrf_BusquedaEquipoWdb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
      FETCH Lrf_BusquedaEquipoWdb INTO Lr_RespuestaBusqEquipodb;
      IF Lr_RespuestaBusqEquipodb.ID_PARAMETRO_DET IS NOT NULL THEN 
        Pv_NecesitaCambiarWdb := 'NO';
      ELSE
        Pv_NecesitaCambiarWdb := 'SI';
      END IF;
    ELSE
      Pv_NecesitaCambiarWdb   := 'NO';
    END IF;

    IF Pv_VerificaEquipoEdb IS NOT NULL AND Pv_VerificaEquipoEdb = 'SI' AND Lv_TecnologiaPermitidadb = 'SI' THEN
      OPEN Lc_GetInfoFinEnlace(Pn_IdInterfaceOnt);
      FETCH Lc_GetInfoFinEnlace INTO Ln_IdElementoSiguiente, Ln_IdInterfaceEleSiguiente, Lv_NombreModeloElementoFin;
      CLOSE Lc_GetInfoFinEnlace;
      IF Lv_NombreModeloElementoFin IS NOT NULL THEN
        Lr_RespuestaBusqEquipodb            := NULL;
        Lr_ParametroDetalleBusqueda         := NULL;
        Lr_ParametroDetalleBusqueda.VALOR1  := Lv_ModelosEquipos;
        Lr_ParametroDetalleBusqueda.VALOR2  := Pv_TecnologiaServicio;
        Lr_ParametroDetalleBusqueda.VALOR3  := Pv_NombreModeloOlt;
        Lr_ParametroDetalleBusqueda.VALOR4  := Lv_TipoEquipoEdb;
        Lr_ParametroDetalleBusqueda.VALOR5  := Lv_NombreModeloElementoFin;
        Lrf_BusquedaEquipoEdb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
        FETCH Lrf_BusquedaEquipoEdb INTO Lr_RespuestaBusqEquipodb;
        IF Lr_RespuestaBusqEquipodb.ID_PARAMETRO_DET IS NOT NULL THEN 
          Pv_NecesitaAgregarEdb := 'NO';
        ELSE
          Pv_NecesitaAgregarEdb := 'SI';
        END IF;
      ELSE
        Pv_NecesitaAgregarEdb := 'SI';
      END IF;
    ELSE
      Pv_NecesitaAgregarEdb := 'NO';
    END IF;
    Pv_Status   := 'OK';
    Pn_IdElementoSiguiente      := Ln_IdElementoSiguiente;
    Pn_IdInterfaceEleSiguiente  := Ln_IdInterfaceEleSiguiente;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status                   := 'ERROR';
    Pv_NecesitaCambiarWdb       := '';
    Pv_NecesitaAgregarEdb       := '';
    Pv_MsjError                 := 'No se ha podido verificar los equipos del servicio';
    Pn_IdElementoSiguiente      := NULL;
    Pn_IdInterfaceEleSiguiente  := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'TECNK_SERVICIOS.P_VERIF_EQUIPOS_W_Y_EXTENDER', 
                                            'No se ha podido verificar los equipos del servicio con ID INTERFACE ONT ' || Pn_IdInterfaceOnt || ' - ' 
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_VERIF_EQUIPOS_W_Y_EXTENDER;

  FUNCTION F_GET_SOL_VALIDA_DUAL_BAND(  
    Fn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  )
  RETURN SYS_REFCURSOR
  IS
    Lv_SolAgregarEquipo             VARCHAR2(24) := 'SOLICITUD AGREGAR EQUIPO';
    Lv_SolAgregarEquipoMasivo       VARCHAR2(31) := 'SOLICITUD AGREGAR EQUIPO MASIVO';
    Lv_EstadoPrePlanificada         VARCHAR2(14) := 'PrePlanificada';
    Lv_EstadoPlanificada            VARCHAR2(11) := 'Planificada';
    Lv_EstadoDetenido               VARCHAR2(8) := 'Detenido';
    Lv_EstadoReplanificada          VARCHAR2(13) := 'Replanificada';
    Lv_EstadoAsignadoTarea          VARCHAR2(13) := 'AsignadoTarea';
    Lv_EstadoAsignada               VARCHAR2(8) := 'Asignada';
    Lv_CaractTecnicaWdb             VARCHAR2(14) := 'WIFI DUAL BAND';
    Lv_CaractTecnicaEdb             VARCHAR2(18) := 'EXTENDER DUAL BAND';
    Ln_Rownum                       NUMBER := 1;
    Lcl_Query                       CLOB;
    Lrf_InfoSolValida               SYS_REFCURSOR;
  BEGIN
    Lcl_Query   := 'SELECT *
                    FROM 
                    (
                        SELECT DISTINCT SOLICITUD_VALIDA.ID_DETALLE_SOLICITUD, TIPO_SOLICITUD.DESCRIPCION_SOLICITUD, 
                        SOLICITUD_VALIDA.ESTADO AS ESTADO_SOLICITUD, 
                        SOLICITUD_VALIDA.USR_CREACION, SOLICITUD_VALIDA.FE_CREACION
                        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD_VALIDA
                        INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOLICITUD
                        ON TIPO_SOLICITUD.ID_TIPO_SOLICITUD = SOLICITUD_VALIDA.TIPO_SOLICITUD_ID
                        INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT
                        ON SOL_CARACT.DETALLE_SOLICITUD_ID = SOLICITUD_VALIDA.ID_DETALLE_SOLICITUD
                        INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
                        ON CARACT.ID_CARACTERISTICA = SOL_CARACT.CARACTERISTICA_ID
                        WHERE SOLICITUD_VALIDA.SERVICIO_ID = :paramIdServicio
                        AND TIPO_SOLICITUD.DESCRIPCION_SOLICITUD IN (:paramAgregarEquipo, :paramAgregarEquipoMasivo )
                        AND SOLICITUD_VALIDA.ESTADO IN (:paramPrePlanificada, :paramPlanificada, :paramDetenido, 
                                                        :paramReplanificada, :paramAsignadoTarea, :paramAsignada)
                        AND SOL_CARACT.ESTADO IN (:paramPrePlanificada1, :paramPlanificada1, :paramDetenido1, 
                                                  :paramReplanificada1, :paramAsignadoTarea1, :paramAsignada1)  
                        AND CARACT.DESCRIPCION_CARACTERISTICA IN (:paramCaractWdb, :paramCaractEdb)                                                               
                        ORDER BY SOLICITUD_VALIDA.FE_CREACION DESC
                    )
                    WHERE ROWNUM = :paramRownum ';
    OPEN Lrf_InfoSolValida FOR Lcl_Query
    USING Fn_IdServicio, Lv_SolAgregarEquipo, Lv_SolAgregarEquipoMasivo,
          Lv_EstadoPrePlanificada, Lv_EstadoPlanificada, Lv_EstadoDetenido, Lv_EstadoReplanificada, Lv_EstadoAsignadoTarea, Lv_EstadoAsignada,
          Lv_EstadoPrePlanificada, Lv_EstadoPlanificada, Lv_EstadoDetenido, Lv_EstadoReplanificada, Lv_EstadoAsignadoTarea, Lv_EstadoAsignada, 
          Lv_CaractTecnicaWdb, Lv_CaractTecnicaEdb, Ln_Rownum;
    RETURN Lrf_InfoSolValida;
  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'TECNK_SERVICIOS.F_GET_SOL_VALIDA_DUAL_BAND', 
                                            'Error al obtener la solicitud válida para gestionar equipos W del servicio ' || Fn_IdServicio || ' - ' 
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  END F_GET_SOL_VALIDA_DUAL_BAND;

  PROCEDURE P_VALIDA_FLUJO_ANTIVIRUS(
    Pv_LoginPunto             IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    Pv_OpcionConsulta         IN VARCHAR2,
    Pv_Valor1ParamAntivirus   IN VARCHAR2,
    Pv_Valor2LoginesAntivirus IN VARCHAR2,
    Pv_Status                 OUT VARCHAR2,
    Pv_MsjError               OUT VARCHAR2,
    Pv_FlujoAntivirus         OUT VARCHAR2,
    Pv_ValorAntivirus         OUT VARCHAR2)
  AS
    Lv_NombreParamAntivirus     VARCHAR2(27) := 'ANTIVIRUS_PLANES_Y_PRODS_MD';
    Lv_NombreParamLoginesPiloto VARCHAR2(24) := 'LOGINES_PILOTO_KASPERSKY';
    Lv_CodEmpresa               VARCHAR2(2)  := '18';
    Lv_EstadoActivo             VARCHAR2(6)  := 'Activo';
    Lv_ValorAmbiente            VARCHAR2(300);
    Lv_Valor1ParamAntivirus     VARCHAR2(300);
    Lv_Valor2LoginesAntivirus   VARCHAR2(300);
    Ln_IdParametroDetPiloto     DB_GENERAL.ADMI_PARAMETRO_DET.ID_PARAMETRO_DET%TYPE;
    CURSOR Lc_GetInfoDetAntivirus( Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                                    Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE, 
                                    Cv_CodEmpresa DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT DET.VALOR2,
        DET.VALOR6
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND DET.EMPRESA_COD        = Cv_CodEmpresa
      AND DET.VALOR1             = Cv_Valor1
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;
    CURSOR Lc_GetInfoDetLoginesPiloto( Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                                        Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE, 
                                        Cv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE, 
                                        Cv_CodEmpresa DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT DET.ID_PARAMETRO_DET
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND DET.EMPRESA_COD        = Cv_CodEmpresa
      AND DET.VALOR1             = Cv_Valor1
      AND DET.VALOR2             = Cv_Valor2
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;
  BEGIN
    IF Pv_Valor1ParamAntivirus IS NOT NULL THEN
      Lv_Valor1ParamAntivirus  := Pv_Valor1ParamAntivirus;
    ELSE
      Lv_Valor1ParamAntivirus := 'NUEVO';
    END IF;
    IF Pv_Valor2LoginesAntivirus IS NOT NULL THEN
      Lv_Valor2LoginesAntivirus  := Pv_Valor2LoginesAntivirus;
    ELSE
      Lv_Valor2LoginesAntivirus := 'INDIVIDUAL';
    END IF;
    OPEN Lc_GetInfoDetAntivirus(Lv_NombreParamAntivirus, Lv_Valor1ParamAntivirus, Lv_CodEmpresa);
    FETCH Lc_GetInfoDetAntivirus INTO Pv_ValorAntivirus, Lv_ValorAmbiente;
    CLOSE Lc_GetInfoDetAntivirus;
    IF Pv_OpcionConsulta  IS NOT NULL THEN
      IF Pv_OpcionConsulta = 'CREAR_PLAN' OR Pv_OpcionConsulta = 'CLONAR_PLAN' THEN
        Pv_FlujoAntivirus := 'NUEVO';
      ELSE
        Pv_FlujoAntivirus := 'ANTERIOR';
      END IF;
    END IF;
    IF Pv_FlujoAntivirus IS NULL OR Pv_FlujoAntivirus <> 'NUEVO' THEN
      IF Lv_ValorAmbiente  IS NOT NULL THEN
        IF Lv_ValorAmbiente = 'PILOTO' THEN
          IF Pv_LoginPunto IS NOT NULL THEN
            OPEN Lc_GetInfoDetLoginesPiloto(Lv_NombreParamLoginesPiloto, Pv_LoginPunto, Lv_Valor2LoginesAntivirus, Lv_CodEmpresa);
            FETCH Lc_GetInfoDetLoginesPiloto INTO Ln_IdParametroDetPiloto;
            CLOSE Lc_GetInfoDetLoginesPiloto;
            IF Ln_IdParametroDetPiloto IS NOT NULL THEN
              Pv_FlujoAntivirus := 'NUEVO';
            ELSE
              Pv_FlujoAntivirus := 'ANTERIOR';
            END IF;
          ELSE
            Pv_FlujoAntivirus := 'ANTERIOR';
          END IF;
        ELSIF Lv_ValorAmbiente = 'PRODUCCION' THEN
          Pv_FlujoAntivirus   := 'NUEVO';
        ELSE
          Pv_FlujoAntivirus := 'ANTERIOR';
        END IF;
      ELSE
        Pv_FlujoAntivirus := 'ANTERIOR';
      END IF;
    END IF;
    Pv_Status := 'OK';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'No se ha podido validar la información del antivirus';
  END P_VALIDA_FLUJO_ANTIVIRUS;

  PROCEDURE P_VERIFICA_CAMBIO_PLAN(
      Pn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Pn_IdPlanNuevo    IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
      Pv_Status         OUT VARCHAR2,
      Pv_MsjError       OUT VARCHAR2)
  AS
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Lv_PlanConDetalleWdb            VARCHAR2(2);
    Lv_PlanConDetalleEdb            VARCHAR2(2);
    Lv_NecesitaCambiarWdb           VARCHAR2(2);
    Lv_NecesitaAgregarEdb           VARCHAR2(2);
    Lr_RegClienteAVerificar         DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataClientesVerificaEquipos;
    Lr_SolValidaEquiposDualBand     DB_INFRAESTRUCTURA.INKG_TYPES.Lr_SolValidaGestionEquipos;
    Lrf_SolValidaGestionEquipos     SYS_REFCURSOR;
    Lv_NombreTecnicoInternet        VARCHAR2(8)  := 'INTERNET';
    Lv_TipoOlt                      VARCHAR2(3)  := 'OLT';
    Lv_CodEmpresaMD                 VARCHAR2(2)  := '18';
    Lv_CodEmpresaEN                 VARCHAR2(2)  := '33';
    Lv_EstadoActivo                 VARCHAR2(6)  := 'Activo';
    Lv_DescripcionProducto          VARCHAR2(23) := 'I. PROTEGIDO MULTI PAID';
    Lv_FlujoAntivirus               VARCHAR2(20);
    Lv_ValorAntivirus               VARCHAR2(20);
    Lv_ExistenIPMPAdicionales       VARCHAR2(2);
    Ln_IndxServsAdicIProtegidoXPto  NUMBER;
    Lrf_ServsAdicIProtegidoXPto     SYS_REFCURSOR;
    Lt_TServIProtegidoAdicsXPto     DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ServIProtegidoAdicsXPto;
    Ln_IdItemIPMP                   DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE;
    Ln_IdElementoSiguiente          DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE;
    Ln_IdInterfaceEleSiguiente      DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE;
    Le_Exception                    EXCEPTION;
    Lv_ModelosOltEquiposdb          VARCHAR2(29) := 'MODELOS_OLT_EQUIPOS_DUAL_BAND';
    Lv_PermitidoWYExtenderEnPlanes  VARCHAR2(300);
    Lv_TecnologiaPermitidaDb        VARCHAR2(2);   
    Lrf_BusquedaTecnologiaDb        SYS_REFCURSOR;
    Lr_ParametroDetalleBusqueda     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lr_RespuestaBusqTecnologiaDb    DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    --SE MODIFICA CURSOR PARA QUE RECIBA UN VARCHAR2 COMO BANDERA DE EMPRESA PARA QUE ECUANET SIGA EL FLUJO DE MEGADATOS
    CURSOR Lc_GetInfoServicioAVerificar(Lv_CodEmpresa IN VARCHAR2)
    IS
      SELECT DISTINCT SERVICIO_INTERNET.ID_SERVICIO,
        SERVICIO_INTERNET.TIPO_ORDEN,
        SERVICIO_INTERNET.ESTADO AS ESTADO_SERVICIO,
        PUNTO.ID_PUNTO,
        PUNTO.LOGIN,
        NVL(PERSONA.NOMBRES || ' ' || PERSONA.APELLIDOS, PERSONA.RAZON_SOCIAL) AS CLIENTE,
        NVL(JURISDICCION.NOMBRE_JURISDICCION, '') AS NOMBRE_JURISDICCION,
        PLAN.ID_PLAN,
        PLAN.NOMBRE_PLAN,
        OLT.ID_ELEMENTO                                         AS ID_OLT,
        OLT.NOMBRE_ELEMENTO                                     AS NOMBRE_OLT,
        MARCA_OLT.NOMBRE_MARCA_ELEMENTO                         AS NOMBRE_MARCA_OLT,
        MODELO_OLT.NOMBRE_MODELO_ELEMENTO                       AS NOMBRE_MODELO_OLT,
        ONT.ID_ELEMENTO                                         AS ID_ONT,
        ONT.NOMBRE_ELEMENTO                                     AS NOMBRE_ONT,
        MODELO_ONT.NOMBRE_MODELO_ELEMENTO                       AS NOMBRE_MODELO_ONT,
        SERVICIO_TECNICO_INTERNET.INTERFACE_ELEMENTO_CLIENTE_ID AS ID_INTERFACE_ONT
      FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_INTERNET
      INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
      ON PUNTO.ID_PUNTO = SERVICIO_INTERNET.PUNTO_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
      ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
      ON PERSONA.ID_PERSONA = PER.PERSONA_ID
      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
      ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID
      INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN
      ON PLAN.ID_PLAN = SERVICIO_INTERNET.PLAN_ID
      INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
      ON PLAN_DET.PLAN_ID = PLAN.ID_PLAN
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_INTERNET_EN_PLAN
      ON PROD_INTERNET_EN_PLAN.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
      INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO_INTERNET
      ON SERVICIO_TECNICO_INTERNET.SERVICIO_ID = SERVICIO_INTERNET.ID_SERVICIO
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
      ON OLT.ID_ELEMENTO = SERVICIO_TECNICO_INTERNET.ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_OLT
      ON MODELO_OLT.ID_MODELO_ELEMENTO = OLT.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_OLT
      ON TIPO_OLT.ID_TIPO_ELEMENTO = MODELO_OLT.TIPO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_OLT
      ON MARCA_OLT.ID_MARCA_ELEMENTO = MODELO_OLT.MARCA_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ONT
      ON ONT.ID_ELEMENTO = SERVICIO_TECNICO_INTERNET.ELEMENTO_CLIENTE_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ONT
      ON MODELO_ONT.ID_MODELO_ELEMENTO = ONT.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_ONT
      ON MARCA_ONT.ID_MARCA_ELEMENTO           = MODELO_ONT.MARCA_ELEMENTO_ID
      WHERE SERVICIO_INTERNET.ID_SERVICIO      = Pn_IdServicio
      AND PLAN_DET.ESTADO                      = PLAN.ESTADO
      AND PROD_INTERNET_EN_PLAN.NOMBRE_TECNICO = Lv_NombreTecnicoInternet
      AND PROD_INTERNET_EN_PLAN.ESTADO         = Lv_EstadoActivo
      AND PROD_INTERNET_EN_PLAN.EMPRESA_COD    = Lv_CodEmpresa
      AND TIPO_OLT.NOMBRE_TIPO_ELEMENTO        = Lv_TipoOlt;
  BEGIN
  --BUSCA POR EMPRESA ECUANET
    OPEN Lc_GetInfoServicioAVerificar(Lv_CodEmpresaMD);
    FETCH Lc_GetInfoServicioAVerificar INTO Lr_RegClienteAVerificar;
    CLOSE Lc_GetInfoServicioAVerificar;
    --VALIDACION POR SERVICIO MEDIANTE ID_SERVICIO
    IF Lr_RegClienteAVerificar.ID_SERVICIO IS  NULL THEN
    --INGRESA Y BUSCA POR EMPRESA ECUANET
       OPEN Lc_GetInfoServicioAVerificar(Lv_CodEmpresaEN);
       FETCH Lc_GetInfoServicioAVerificar INTO Lr_RegClienteAVerificar;
       CLOSE Lc_GetInfoServicioAVerificar;
    END IF;
    IF Lr_RegClienteAVerificar.ID_SERVICIO IS NOT NULL THEN
      Lv_ExistenIPMPAdicionales            := 'NO';
      Ln_IdItemIPMP                        := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_ITEM_PROD_EN_PLAN( Pn_IdPlanNuevo, 
                                                                                                    NULL, 
                                                                                                    NULL, 
                                                                                                    Lv_DescripcionProducto);
      DB_COMERCIAL.TECNK_SERVICIOS.P_VALIDA_FLUJO_ANTIVIRUS(Lr_RegClienteAVerificar.LOGIN, 
                                                            NULL, 
                                                            NULL, 
                                                            NULL, 
                                                            Lv_Status, 
                                                            Lv_MsjError, 
                                                            Lv_FlujoAntivirus, 
                                                            Lv_ValorAntivirus);
      IF Lv_Status = 'ERROR' THEN
        RAISE Le_Exception;
      END IF;
      IF Lv_FlujoAntivirus IS NOT NULL AND Lv_FlujoAntivirus <> 'NUEVO' AND Ln_IdItemIPMP IS NOT NULL THEN
        DB_COMERCIAL.TECNK_SERVICIOS.P_GET_SERV_ADICS_I_PROTEGIDO(Lr_RegClienteAVerificar.ID_PUNTO, 
                                                                  Lrf_ServsAdicIProtegidoXPto, 
                                                                  Lv_Status, 
                                                                  Lv_MsjError);
        LOOP
          FETCH Lrf_ServsAdicIProtegidoXPto BULK COLLECT
          INTO Lt_TServIProtegidoAdicsXPto LIMIT 100;
          Ln_IndxServsAdicIProtegidoXPto        := Lt_TServIProtegidoAdicsXPto.FIRST;
          WHILE (Ln_IndxServsAdicIProtegidoXPto IS NOT NULL)
          LOOP
            Lv_ExistenIPMPAdicionales      := 'SI';
            Ln_IndxServsAdicIProtegidoXPto := Lt_TServIProtegidoAdicsXPto.NEXT(Ln_IndxServsAdicIProtegidoXPto);
          END LOOP;
          EXIT
        WHEN Lrf_ServsAdicIProtegidoXPto%NOTFOUND;
        END LOOP;
        CLOSE Lrf_ServsAdicIProtegidoXPto;
        --Si el cliente está trabajando bajo el flujo McAfee debe seguir validándose esta información.
        IF Lv_ExistenIPMPAdicionales = 'SI' THEN
          Lv_MsjError               := 'Cambio de Plan no permitido porque el cliente tiene contratado MCAFEE como producto adicional.';
          RAISE Le_Exception;
        END IF;
      END IF;

      --Se verifica si la tecnología es permitida para equipos Dual Band y si está permitido validar equipos W y Extender en planes
      Lr_RespuestaBusqTecnologiaDb       := NULL;
      Lr_ParametroDetalleBusqueda        := NULL;
      Lr_ParametroDetalleBusqueda.VALOR1 := Lv_ModelosOltEquiposdb;
      Lr_ParametroDetalleBusqueda.VALOR2 := Lr_RegClienteAVerificar.NOMBRE_MARCA_OLT;
      Lr_ParametroDetalleBusqueda.VALOR3 := Lr_RegClienteAVerificar.NOMBRE_MODELO_OLT;
      Lr_ParametroDetalleBusqueda.VALOR4 := NULL;
      Lr_ParametroDetalleBusqueda.VALOR5 := NULL;
      Lrf_BusquedaTecnologiaDb           := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
      FETCH Lrf_BusquedaTecnologiaDb INTO Lr_RespuestaBusqTecnologiaDb;
      IF Lr_RespuestaBusqTecnologiaDb.ID_PARAMETRO_DET IS NOT NULL THEN
        Lv_TecnologiaPermitidaDb          := 'SI';
        Lv_PermitidoWYExtenderEnPlanes    := Lr_RespuestaBusqTecnologiaDb.VALOR4;
      ELSE
        Lv_TecnologiaPermitidaDb := 'NO';
      END IF;

      IF Lv_TecnologiaPermitidaDb = 'SI' AND Lv_PermitidoWYExtenderEnPlanes = 'SI' THEN
        DB_COMERCIAL.TECNK_SERVICIOS.P_VERIF_DET_PLAN_W_Y_EXTENDER( Pn_IdPlanNuevo, 
                                                                    Lv_Status, 
                                                                    Lv_MsjError, 
                                                                    Lv_PlanConDetalleWdb, 
                                                                    Lv_PlanConDetalleEdb);
        IF Lv_Status = 'OK' THEN
          --Se verifica si el plan tiene el detalle del producto Wifi Dual Band y Extender Dual Band
          IF Lv_PlanConDetalleWdb = 'SI' OR Lv_PlanConDetalleEdb = 'SI' THEN
            --Se verifica si el servicio necesita un cambio a Wifi Dual Band y/o necesite agregar Extender Dual Band
            DB_COMERCIAL.TECNK_SERVICIOS.P_VERIF_EQUIPOS_W_Y_EXTENDER(Lv_PlanConDetalleWdb, 
                                                                      Lv_PlanConDetalleEdb, 
                                                                      Lr_RegClienteAVerificar.NOMBRE_MARCA_OLT, 
                                                                      Lr_RegClienteAVerificar.NOMBRE_MODELO_OLT, 
                                                                      Lr_RegClienteAVerificar.NOMBRE_MODELO_ONT, 
                                                                      Lr_RegClienteAVerificar.ID_INTERFACE_ONT, 
                                                                      Lv_Status, 
                                                                      Lv_MsjError, 
                                                                      Lv_NecesitaCambiarWdb, 
                                                                      Lv_NecesitaAgregarEdb,
                                                                      Ln_IdElementoSiguiente,
                                                                      Ln_IdInterfaceEleSiguiente);
            IF Lv_Status = 'OK' THEN
              --Servicios de clientes que necesitan cambiar al Wifi Dual Band y/o necesitan agregar el extender Dual Band
              IF Lv_NecesitaCambiarWdb       = 'SI' OR Lv_NecesitaAgregarEdb = 'SI' THEN
                Lr_SolValidaEquiposDualBand := NULL;
                Lrf_SolValidaGestionEquipos := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_SOL_VALIDA_DUAL_BAND(Pn_IdServicio);
                FETCH Lrf_SolValidaGestionEquipos INTO Lr_SolValidaEquiposDualBand;
                CLOSE Lrf_SolValidaGestionEquipos;
                IF Lr_SolValidaEquiposDualBand.ID_DETALLE_SOLICITUD IS NOT NULL AND Lr_SolValidaEquiposDualBand.ESTADO_SOLICITUD = 'Asignada' THEN
                  Lv_MsjError := 'Tienes una solicitud en estado Asignada, no se puede hacer el cambio de plan '
                                  || 'hasta que no se gestione dicha solicitud';
                  RAISE Le_Exception;
                END IF;
              END IF;
            ELSE
              --Servicios a los que no se les puede verificar los equipos
              Lv_MsjError := 'No se ha podido verificar los equipos del servicio que desea cambiar de plan';
              RAISE Le_Exception;
            END IF;
          END IF;
        ELSE
          Lv_MsjError := 'No se ha podido verificar los detalles del plan al que se desea cambiar';
          RAISE Le_Exception;
        END IF;
      END IF;
    ELSE
      Lv_MsjError := 'No se ha podido obtener la información técnica del servicio que desea cambiar de plan';
      RAISE Le_Exception;
    END IF;
    Pv_Status := 'OK';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := Lv_MsjError;
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'Ha ocurrido un error inesperado al intentar validar el cambio de plan';
  END P_VERIFICA_CAMBIO_PLAN;

  PROCEDURE P_GET_PUNTOS_MD_ASOCIADOS(
    Pv_CedulaCliente    IN VARCHAR2,
    Pv_LoginPunto       IN VARCHAR2,
    Pn_Start            IN NUMBER,
    Pn_Limit            IN NUMBER,
    Pv_Status           OUT VARCHAR2,
    Pv_MsjError         OUT VARCHAR2,
    Prf_PuntosMd        OUT SYS_REFCURSOR,
    Pn_TotalPuntosMd    OUT NUMBER)
  AS
    Lv_NombreTecnicoInternet    VARCHAR2(8) := 'INTERNET';
    Lv_TipoOlt                  VARCHAR2(3) := 'OLT';
    Lv_CodEmpresaTn             VARCHAR2(2) := '10';
    Lv_CodEmpresaMd             VARCHAR2(2) := '18';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_NombreParamServiciosTn   VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_TN';
    Lv_Valor1PuntoMdAsociado    VARCHAR2(35) := 'PUNTO_MD_ASOCIADO';
    Lv_Valor2EstadosServicios   VARCHAR2(37) := 'ESTADOS_SERVICIOS_PUNTOS_ASOCIADOS_MD';
    Lv_Valor2TipoNegocio        VARCHAR2(37) := 'TIPO_NEGOCIO_PERMITIDO';
    Lv_SelectCount              VARCHAR2(4000);
    Lv_Select                   VARCHAR2(4000);
    Lv_SelectValidaTipoNegocio  VARCHAR2(4000);
    Lv_SelectTieneAdicionales   VARCHAR2(4000);
    Lcl_FromJoin                CLOB;
    Lv_Where                    VARCHAR2(4000);
    Lv_WhereAdicional           VARCHAR2(4000);
    Lcl_ConsultaPrincipal       CLOB;
    Lcl_ConsultaTotalPuntosMd   CLOB;
    Lc_TotalPuntosMd            SYS_REFCURSOR;
    Ln_LimitConsulta            NUMBER;
    Ln_StartConsulta            NUMBER;
    BEGIN
      IF Pv_CedulaCliente IS NOT NULL OR Pv_LoginPunto IS NOT NULL THEN
        Lv_SelectCount              := 'SELECT COUNT(DISTINCT ID_SERVICIO) ';
        Lv_Select                   := 'SELECT DISTINCT 
                                        PER.ID_PERSONA_ROL, 
                                        SERVICIO_INTERNET.ID_SERVICIO,
                                        PUNTO.ID_PUNTO,
                                        PUNTO.LOGIN,
                                        PLAN.NOMBRE_PLAN,
                                        TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO,
                                        SERVICIO_INTERNET.ESTADO AS ESTADO_SERVICIO '; 
        Lv_SelectValidaTipoNegocio  := ', ( SELECT
                                            CASE
                                              WHEN COUNT(PARAM_DET.ID_PARAMETRO_DET) > 0
                                              THEN ''SI''
                                              ELSE ''NO''
                                            END
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                            ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                            WHERE PARAM_CAB.NOMBRE_PARAMETRO = ''' || Lv_NombreParamServiciosTn || '''
                                            AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                                            AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || ''' 
                                            AND PARAM_DET.VALOR1 = ''' || Lv_Valor1PuntoMdAsociado || '''
                                            AND PARAM_DET.VALOR2 = ''' || Lv_Valor2TipoNegocio || '''
                                            AND PARAM_DET.VALOR3 = TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO
                                            AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresaTn || ''' ) AS TIPO_NEGOCIO_PERMITIDO ';

        Lv_SelectTieneAdicionales   := ', ( SELECT
                                            CASE
                                              WHEN COUNT(SERVICIO_ADICIONAL.ID_SERVICIO) > 0
                                              THEN ''SI''
                                              ELSE ''NO''
                                            END
                                            FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_ADICIONAL
                                            WHERE SERVICIO_ADICIONAL.PUNTO_ID = PUNTO.ID_PUNTO
                                            AND SERVICIO_ADICIONAL.ESTADO = ''' || Lv_EstadoActivo || '''
                                            AND SERVICIO_ADICIONAL.PRODUCTO_ID IS NOT NULL) AS TIENE_SERVICIOS_ADICIONALES ';

        Lcl_FromJoin                := 'FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO_INTERNET
                                        INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
                                        ON PUNTO.ID_PUNTO = SERVICIO_INTERNET.PUNTO_ID
                                        INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO TIPO_NEGOCIO
                                        ON TIPO_NEGOCIO.ID_TIPO_NEGOCIO = PUNTO.TIPO_NEGOCIO_ID
                                        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                                        ON PER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
                                        INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
                                        ON PERSONA.ID_PERSONA = PER.PERSONA_ID
                                        INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN
                                        ON PLAN.ID_PLAN = SERVICIO_INTERNET.PLAN_ID
                                        INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                                        ON PLAN_DET.PLAN_ID = PLAN.ID_PLAN
                                        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_INTERNET_EN_PLAN
                                        ON PROD_INTERNET_EN_PLAN.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
                                        INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO_INTERNET
                                        ON SERVICIO_TECNICO_INTERNET.SERVICIO_ID = SERVICIO_INTERNET.ID_SERVICIO
                                        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
                                        ON OLT.ID_ELEMENTO = SERVICIO_TECNICO_INTERNET.ELEMENTO_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_OLT
                                        ON MODELO_OLT.ID_MODELO_ELEMENTO = OLT.MODELO_ELEMENTO_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_OLT
                                        ON TIPO_OLT.ID_TIPO_ELEMENTO = MODELO_OLT.TIPO_ELEMENTO_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_OLT
                                        ON MARCA_OLT.ID_MARCA_ELEMENTO = MODELO_OLT.MARCA_ELEMENTO_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ONT
                                        ON ONT.ID_ELEMENTO = SERVICIO_TECNICO_INTERNET.ELEMENTO_CLIENTE_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ONT
                                        ON MODELO_ONT.ID_MODELO_ELEMENTO = ONT.MODELO_ELEMENTO_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_ONT
                                        ON MARCA_ONT.ID_MARCA_ELEMENTO           = MODELO_ONT.MARCA_ELEMENTO_ID ';
        Lv_Where                    := 'WHERE PLAN_DET.ESTADO                    = PLAN.ESTADO
                                        AND PROD_INTERNET_EN_PLAN.NOMBRE_TECNICO = ''' || Lv_NombreTecnicoInternet || '''
                                        AND PROD_INTERNET_EN_PLAN.ESTADO         = ''' || Lv_EstadoActivo || '''
                                        AND PROD_INTERNET_EN_PLAN.EMPRESA_COD    = ''' || Lv_CodEmpresaMd || '''
                                        AND TIPO_OLT.NOMBRE_TIPO_ELEMENTO        = ''' || Lv_TipoOlt || '''
                                        AND SERVICIO_INTERNET.ESTADO IN (
                                          SELECT DET.VALOR3
                                          FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                                          INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
                                          ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                                          WHERE CAB.NOMBRE_PARAMETRO = ''' || Lv_NombreParamServiciosTn || '''
                                          AND CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                                          AND DET.VALOR1 = ''' || Lv_Valor1PuntoMdAsociado || '''
                                          AND DET.VALOR2 = ''' || Lv_Valor2EstadosServicios || '''
                                          AND DET.ESTADO = ''' || Lv_EstadoActivo || '''
                                          AND DET.EMPRESA_COD = ''' || Lv_CodEmpresaTn || ''' ) ';

        IF Pv_CedulaCliente IS NOT NULL THEN
          Lv_WhereAdicional := 'AND PERSONA.IDENTIFICACION_CLIENTE = ''' || Pv_CedulaCliente || ''' ';
        END IF;

        IF Pv_LoginPunto IS NOT NULL THEN
          Lv_WhereAdicional := 'AND UPPER(PUNTO.LOGIN) LIKE ''' || UPPER(Pv_LoginPunto) || '%'' ';
        END IF;

        Lcl_ConsultaPrincipal := Lv_Select || Lv_SelectValidaTipoNegocio || Lv_SelectTieneAdicionales 
                                 || Lcl_FromJoin || Lv_Where || Lv_WhereAdicional;
        IF Pn_Limit IS NOT NULL AND Pn_Limit > 0 THEN
          Ln_LimitConsulta      := Pn_Start + Pn_Limit;
          Lcl_ConsultaPrincipal := 'SELECT a.*, rownum AS doctrine_rownum '
                                   || 'FROM (' || Lcl_ConsultaPrincipal || ') a WHERE rownum <= ' || Ln_LimitConsulta;
          IF Pn_Start IS NOT NULL AND Pn_Start > 0 THEN
            Ln_StartConsulta      := Pn_Start + 1;
            Lcl_ConsultaPrincipal := 'SELECT * FROM (' || Lcl_ConsultaPrincipal || ') WHERE doctrine_rownum >= ' || Ln_StartConsulta;
          END IF;
        END IF;
        OPEN Prf_PuntosMd FOR Lcl_ConsultaPrincipal;

        Lcl_ConsultaTotalPuntosMd := Lv_SelectCount || 'FROM (' || Lv_Select || Lcl_FromJoin || Lv_Where || Lv_WhereAdicional || ')';
        OPEN Lc_TotalPuntosMd FOR Lcl_ConsultaTotalPuntosMd;
        FETCH Lc_TotalPuntosMd INTO Pn_TotalPuntosMd;
        CLOSE Lc_TotalPuntosMd;
      ELSE
        Prf_PuntosMd        := NULL;
        Pv_Status           := 'ERROR';
        Pv_MsjError         := 'Por favor ingrese la cédula del cliente o el login del punto para realizar la búsqueda';
        Pn_TotalPuntosMd    := 0;
      END IF;
      Pv_Status                := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      Prf_PuntosMd      := NULL;
      Pn_TotalPuntosMd  := 0;
      Pv_Status         := 'ERROR';
      Pv_MsjError       := 'No se ha podido realizar la consulta de manera correcta. Por favor comuníquese con Sistemas';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'TECNK_SERVICIOS.P_GET_PUNTOS_MD_ASOCIADOS', 
                                            'Error al obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_PUNTOS_MD_ASOCIADOS;

  PROCEDURE P_ENVIO_CORREO_CREA_SOL_PYL(
    Pr_DataGeneralCliente   IN DB_INFRAESTRUCTURA.INKG_TYPES.Lr_DataGeneralCliente,
    Pv_DescripcionSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    Pv_Observacion          IN VARCHAR2,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2)
  AS
    Lv_Asunto                       VARCHAR2(200);
    Lv_Remitente                    VARCHAR2(50) := 'notificacionesnetlife@netlife.info.ec';
    Lv_PlantillaInicial             VARCHAR2(4000);
    Lv_PlantillaCorreo              VARCHAR2(32767);
    Lr_GetAliasPlantillaCorreo      DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  BEGIN
    --Envío de correo a PYL por creación de la solicitud de agregar equipo
    Lr_GetAliasPlantillaCorreo  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('AGREGAEQUIPOPYL');
    Lv_PlantillaInicial         := Lr_GetAliasPlantillaCorreo.PLANTILLA;
    Lv_PlantillaCorreo          := Lv_PlantillaInicial;
    IF Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS IS NOT NULL THEN
      Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS := REPLACE(Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS, ';', ',') || ',';
    ELSE 
      Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS := Lv_Remitente || ',';
    END IF;
    Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ descripcionTipoSolicitud }}', Pv_DescripcionSolicitud);
    Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ cliente }}', Pr_DataGeneralCliente.CLIENTE);
    Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ login }}', Pr_DataGeneralCliente.LOGIN);
    Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ nombreJurisdiccion }}', Pr_DataGeneralCliente.NOMBRE_JURISDICCION);
    Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ tipoPlanOProducto }}', Pr_DataGeneralCliente.TIPO_SERVICIO);
    IF Pr_DataGeneralCliente.TIPO_SERVICIO = 'Producto' THEN
      Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ nombrePlanOProducto }}', Pr_DataGeneralCliente.DESCRIPCION_PRODUCTO);
    ELSE
      Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ nombrePlanOProducto }}', Pr_DataGeneralCliente.NOMBRE_PLAN);
    END IF;
    Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ observacion | raw }}', Pv_Observacion);
    Lv_PlantillaCorreo  := REPLACE(Lv_PlantillaCorreo, '{{ estadoServicio }}', Pr_DataGeneralCliente.ESTADO_SERVICIO);
    IF Pr_DataGeneralCliente.TIPO_ORDEN = 'T' THEN
      Lv_Asunto := 'GENERACION DE TRASLADO + CAMBIO DE EQUIPO - ' || Pv_DescripcionSolicitud || ' - ' || Pr_DataGeneralCliente.LOGIN;
    ELSE
      Lv_Asunto := 'Creacion ' || Pv_DescripcionSolicitud || ' - ' || Pr_DataGeneralCliente.LOGIN;
    END IF;

    UTL_MAIL.SEND ( SENDER      => Lv_Remitente,
                    RECIPIENTS  => Lr_GetAliasPlantillaCorreo.ALIAS_CORREOS,
                    SUBJECT     => Lv_Asunto,
                    MESSAGE     => SUBSTR(Lv_PlantillaCorreo, 1, 32767),
                    MIME_TYPE   => 'text/html; charset=iso-8859-1');
    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'No se ha podido enviar el correo por la solicitud del login ' || Pr_DataGeneralCliente.LOGIN;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'TECNK_SERVICIOS.P_ENVIO_CORREO_CREA_SOL_PYL', 
                                            'No se ha podido enviar el correo por la solicitud del login ' || Pr_DataGeneralCliente.LOGIN
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ENVIO_CORREO_CREA_SOL_PYL;

  PROCEDURE P_GET_PUNTOS_CORTE_MASIVO(
    Pcl_JsonFiltrosBusqueda   IN CLOB,
    Pv_ConsultaTotalRegistros IN VARCHAR2,
    Pv_Status                 OUT VARCHAR2,
    Pv_MsjError               OUT VARCHAR2,
    Pn_TotalRegistros         OUT NUMBER,
    Prf_Registros             OUT SYS_REFCURSOR)
  AS    
    Lv_CodEmpresa               VARCHAR2(2);
    Lv_FechaCreacionDoc         VARCHAR2(10);
    Lv_TiposDocumentos          VARCHAR2(100);
    Lv_NumDocsAbiertos          VARCHAR2(10);
    Lv_ValorMontoCartera        VARCHAR2(10);
    Ln_ValorMinMontoCartera     NUMBER := 5;
    Lv_IdTipoNegocio            VARCHAR2(10);
    Lv_ValorClienteCanal        VARCHAR2(20);
    Lv_NombreUltimaMilla        VARCHAR2(20);
    Lv_IdCicloFacturacion       VARCHAR2(10);
    Lcl_WhereCtaTarjBancos      CLOB;
    Lv_IdsOficinas              VARCHAR2(32767);
    Lv_IdsFormasPago            VARCHAR2(1000);
    Lv_IdsFpConCtaTarjBancos    VARCHAR2(1000);
    Lv_IdsFpSinCtaTarjBancos    VARCHAR2(1000);
    Lv_ParamIdFpCtaTarjBancos   VARCHAR2(300);
    Lv_ValorCuentaTarjeta       VARCHAR2(100);
    Lv_EsTarjeta                VARCHAR2(1);
    Lv_IdsTiposCuentaTarjeta    VARCHAR2(4000);
    Lv_IdsBancos                VARCHAR2(32767);
    Lv_Start                    VARCHAR2(10);
    Ln_Start                    NUMBER;
    Ln_StartConsulta            NUMBER;
    Lv_Limit                    VARCHAR2(10);
    Ln_Limit                    NUMBER;
    Ln_LimitConsulta            NUMBER;
    Lcl_JsonFiltrosBusqueda     CLOB;
    Lv_SelectCount              VARCHAR2(4000);
    Lv_Select                   VARCHAR2(4000);
    Lcl_FromJoin                CLOB;
    Lcl_Where                   CLOB;
    Lv_WhereFiltrosDocs         VARCHAR2(4000);
    Lcl_QueryCount              CLOB;
    Lcl_QueryFinal              CLOB;
    Lcl_QueryDocs               CLOB;
    Lv_OrderBy                  VARCHAR2(4000);
    Lv_MsjError                 VARCHAR2(4000);
    Le_Exception                EXCEPTION;
    Lv_ClienteCanal             VARCHAR2(13) := 'Cliente Canal';
    Lrf_PuntosCorteMasivo       SYS_REFCURSOR;
    Lv_ParamCabNombreParametro  VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_ParamDetCorteMasivo      VARCHAR2(13) := 'CORTE_MASIVO';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_ParamIdsFpCtaTarjBancos  VARCHAR2(38) := 'IDS_FORMAS_PAGO_CUENTA_TARJETA_BANCOS';
    Lv_FechaLimAct              VARCHAR2(100);
    Lv_IdentExcluidas           VARCHAR2(1000);
    Ln_IdentExcluidas_count     NUMBER;
    Ln_IteradorI                NUMBER;
    Lcl_WhereIdentExcluidas     CLOB;
    Lv_Proceso                  VARCHAR2(50);

  BEGIN
    Pn_TotalRegistros         := 0;
    Lcl_JsonFiltrosBusqueda   := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_CodEmpresa             := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strCodEmpresa'));
    Lv_FechaCreacionDoc       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strFechaCreacionDoc'));
    Lv_TiposDocumentos        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strTiposDocumentos'));
    Lv_NumDocsAbiertos        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strNumDocsAbiertos'));
    Lv_ValorMontoCartera      := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorMontoCartera'));
    Lv_IdTipoNegocio          := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdTipoNegocio'));
    Lv_ValorClienteCanal      := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorClienteCanal'));
    Lv_NombreUltimaMilla      := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strNombreUltimaMilla'));
    Lv_IdCicloFacturacion     := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdCicloFacturacion'));
    Lv_IdsOficinas            := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsOficinas'));
    Lv_IdsFormasPago          := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsFormasPago'));
    Lv_ValorCuentaTarjeta     := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorCuentaTarjeta'));
    Lv_IdsTiposCuentaTarjeta  := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsTiposCuentaTarjeta'));
    Lv_IdsBancos              := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsBancos'));
    Lv_Start                  := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strStart'));
    Lv_Limit                  := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strLimit'));
    Lv_FechaLimAct            := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strFechaLimActivacion'));
    Ln_IdentExcluidas_Count   := APEX_JSON.GET_COUNT(p_path => 'arrayFinalIdExcluidas');
    Lv_Proceso                := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strProceso'));
    Ln_IteradorI := 1;

    IF Ln_IdentExcluidas_Count > 0 THEN
        -- AGREGO IDENTIFICACIONES A TABLA TEMPORAL
        WHILE (Ln_IteradorI <= Ln_IdentExcluidas_Count)
        LOOP
            Lv_IdentExcluidas := '';
            Lv_IdentExcluidas := APEX_JSON.GET_VARCHAR2(p_path => 'arrayFinalIdExcluidas[%d]', p0 => Ln_IteradorI);

            EXECUTE IMMEDIATE 'INSERT INTO DB_COMERCIAL.TMP_IDENTIFICACIONES_EXCLUIDAS (IDENTIFICACION_CLIENTE) VALUES   
                                ('''|| Lv_IdentExcluidas || ''')';
            Ln_IteradorI := Ln_IteradorI + 1;
        END LOOP;
        COMMIT;
    END IF;

    IF Lv_CodEmpresa IS NULL THEN
      Lv_MsjError := 'No se ha enviado el parámetro obligatorio del código de la empresa';
      RAISE Le_Exception;
    END IF;

    IF Lv_FechaCreacionDoc IS NULL THEN
      Lv_MsjError := 'No se ha enviado el parámetro obligatorio de la fecha de creación del documento';
      RAISE Le_Exception;
    END IF;

    IF Lv_TiposDocumentos IS NULL THEN
      Lv_MsjError := 'No se ha enviado el parámetro obligatorio del tipo de documento';
      RAISE Le_Exception;
    END IF;

    IF Lv_Start IS NOT NULL THEN
      Ln_Start := TO_NUMBER(Lv_Start, '9999999999');
    ELSE
      Ln_Start := 0;
    END IF;

    IF Lv_Limit IS NOT NULL THEN
      Ln_Limit := TO_NUMBER(Lv_Limit, '99999');
    ELSE
      Ln_Limit := 0;
    END IF;

    Lv_SelectCount  := ' SELECT VISTA_CORTE_MASIVO.ID_PUNTO ';
    --SE AGREGA COLUMNA FECHA DE ACTIVACION                      
    Lv_Select       := ' SELECT VISTA_CORTE_MASIVO.ID_PUNTO,
                          VISTA_CORTE_MASIVO.LOGIN,
                          VISTA_CORTE_MASIVO.NOMBRE_CLIENTE,
                          VISTA_CORTE_MASIVO.NOMBRE_OFICINA,
                          VISTA_CORTE_MASIVO.SALDO,
                          VISTA_CORTE_MASIVO.DESCRIPCION_FORMA_PAGO,
                          VISTA_CORTE_MASIVO.DESCRIPCION_BANCO,
                          VISTA_CORTE_MASIVO.DESCRIPCION_CUENTA,
                          VISTA_CORTE_MASIVO.NOMBRE_TIPO_NEGOCIO,
                          VISTA_CORTE_MASIVO.ULTIMA_MILLA,
                          TO_CHAR(F_ACTIVACION_TABLE.FE_CREACION, ''DD/MM/YYYY'') AS FECHA_ACTIVACION ';

    --SE AGREGA JOIN PARA TOMAR EN CUENTA LA FECHA DE ACTIVACION                      
    Lcl_FromJoin    := ' FROM DB_COMERCIAL.VISTA_PM_CORTE_FAC_ABI VISTA_CORTE_MASIVO 
                            INNER JOIN (SELECT IPP.ID_PUNTO, SERV_HIS.FE_CREACION 
                                        FROM DB_COMERCIAL.INFO_PUNTO IPP
                                        LEFT JOIN (SELECT INS.PUNTO_ID, MIN(TRUNC(ISH.FE_CREACION)) AS FE_CREACION
                                                    FROM DB_COMERCIAL.INFO_SERVICIO INS
                                                    JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON INS.ID_SERVICIO = ISH.SERVICIO_ID
                                                    WHERE ISH.ESTADO = ''Activo''
                                                    AND ISH.ACCION IN (''feOrigenCambioRazonSocial'', ''feOrigServicioTrasladado'', ''confirmarServicio'')
                                                    GROUP BY INS.PUNTO_ID 
                                                    ORDER BY INS.PUNTO_ID) SERV_HIS
                                        ON IPP.ID_PUNTO = SERV_HIS.PUNTO_ID) F_ACTIVACION_TABLE 
                         ON F_ACTIVACION_TABLE.ID_PUNTO = VISTA_CORTE_MASIVO.ID_PUNTO ';
    Lcl_Where       := ' WHERE VISTA_CORTE_MASIVO.EMPRESA_COD = ''' || Lv_CodEmpresa || ''' ';
    Lv_OrderBy      := ' ORDER BY NOMBRE_CLIENTE ASC ';

    ---FILTRO DE FECHA DE ACTIVACION
    IF Lv_FechaLimAct IS NOT NULL AND LENGTH(Lv_FechaLimAct) = 10 THEN
        Lcl_FromJoin    := ' FROM DB_COMERCIAL.VISTA_PM_CORTE_FAC_ABI VISTA_CORTE_MASIVO 
                            INNER JOIN (SELECT IPP.ID_PUNTO, SERV_HIS.FE_CREACION 
                                        FROM DB_COMERCIAL.INFO_PUNTO IPP
                                        LEFT JOIN (SELECT INS.PUNTO_ID, MIN(TRUNC(ISH.FE_CREACION)) AS FE_CREACION
                                                    FROM DB_COMERCIAL.INFO_SERVICIO INS
                                                    JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON INS.ID_SERVICIO = ISH.SERVICIO_ID
                                                    WHERE ISH.ESTADO = ''Activo''
                                                    AND ISH.ACCION IN (''feOrigenCambioRazonSocial'', ''feOrigServicioTrasladado'', ''confirmarServicio'')
                                                    GROUP BY INS.PUNTO_ID 
                                                    ORDER BY INS.PUNTO_ID) SERV_HIS
                                        ON IPP.ID_PUNTO = SERV_HIS.PUNTO_ID
                                        WHERE TO_DATE(TO_CHAR(TO_DATE(NVL(SERV_HIS.FE_CREACION, LAST_DAY(TO_DATE(''' || Lv_FechaLimAct || ''', ''YYYY-MM-DD''))), ''DD-MM-YY''), ''YYYY-MM-DD''), ''YYYY-MM-DD'') <= LAST_DAY(TO_DATE(''' || Lv_FechaLimAct || ''', ''YYYY-MM-DD''))) F_ACTIVACION_TABLE
                         ON F_ACTIVACION_TABLE.ID_PUNTO = VISTA_CORTE_MASIVO.ID_PUNTO ';

    END IF;

    -- SI SE NECESITA EXPORTAR/MASIVO AUMENTA COLUMNAS
    IF Lv_Proceso IS NOT NULL THEN
        -- SI SE NECESITA EXPORTAR
        IF UPPER(Lv_Proceso) = 'EXPORTACION' THEN
            Lv_Select := Lv_Select || ',  PERSONA_TABLE.IDENTIFICACION_CLIENTE, CASE WHEN (SELECT DISTINCT PERSONA_TABLE.IDENTIFICACION_CLIENTE FROM DB_COMERCIAL.TMP_IDENTIFICACIONES_EXCLUIDAS TEMP_TABLE WHERE TEMP_TABLE.IDENTIFICACION_CLIENTE = PERSONA_TABLE.IDENTIFICACION_CLIENTE) IS NOT NULL THEN ''SI'' ELSE ''NO'' END AS ES_EXCLUIDO ';
            Lcl_FromJoin := Lcl_FromJoin || ' INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA_TABLE ON VISTA_CORTE_MASIVO.ID_PERSONA = PERSONA_TABLE.ID_PERSONA ';
        -- SI SE NECESITA CORTAR MASIVO X LOTE
        ELSE
            Lv_Select := Lv_Select || ',  NULL AS IDENTIFICACION_CLIENTE, ''NO'' AS ES_EXCLUIDO ';
            -- FILTRO DE IDENTIFICACIONES EXCLUIDAS
            IF Ln_IdentExcluidas_Count > 0 THEN
                Lcl_WhereIdentExcluidas := ' AND VISTA_CORTE_MASIVO.ID_PERSONA NOT IN (SELECT INFOP.ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA INFOP'
                                                                                      || ' WHERE INFOP.IDENTIFICACION_CLIENTE IN (SELECT IEX.IDENTIFICACION_CLIENTE FROM DB_COMERCIAL.TMP_IDENTIFICACIONES_EXCLUIDAS IEX)) ';   
                Lcl_Where := Lcl_Where || Lcl_WhereIdentExcluidas;
            END IF;
        END IF;
    -- SI SOLO CONSULTA PARA GRID    
    ELSE
        -- FILTRO DE IDENTIFICACIONES EXCLUIDAS
        IF Ln_IdentExcluidas_Count > 0 THEN
            Lcl_WhereIdentExcluidas := ' AND VISTA_CORTE_MASIVO.ID_PERSONA NOT IN (SELECT INFOP.ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA INFOP'
                                                                                  || ' WHERE INFOP.IDENTIFICACION_CLIENTE IN (SELECT IEX.IDENTIFICACION_CLIENTE FROM DB_COMERCIAL.TMP_IDENTIFICACIONES_EXCLUIDAS IEX)) ';   
            Lcl_Where := Lcl_Where || Lcl_WhereIdentExcluidas;
        END IF;
    END IF;

    IF Lv_FechaCreacionDoc IS NOT NULL AND Lv_TiposDocumentos IS NOT NULL THEN
      Lv_WhereFiltrosDocs := 'WHERE 
                                  TO_DATE(FE_CREACION_DOCUMENTO, ''YYYY-MM-DD'') <= TO_DATE(''' || Lv_FechaCreacionDoc || ''', ''YYYY-MM-DD'' )
                                  AND CODIGO_TIPO_DOCUMENTO IN ( 
                                    SELECT regexp_substr(''' || Lv_TiposDocumentos || ''', ''[^,]+'', 1, LEVEL) COD_TIPO_DOC
                                    FROM DUAL
                                    CONNECT BY LEVEL <= length(''' || Lv_TiposDocumentos || ''') 
                                    - length(REPLACE(''' || Lv_TiposDocumentos || ''', '','', '''')) + 1 ) ';
    ELSIF Lv_FechaCreacionDoc IS NOT NULL THEN
      Lv_WhereFiltrosDocs := 'WHERE 
                                  TO_DATE(FE_CREACION_DOCUMENTO, ''YYYY-MM-DD'') 
                                  <= TO_DATE(''' || Lv_FechaCreacionDoc || ''', ''YYYY-MM-DD'' ) ';
    ELSE
      Lv_WhereFiltrosDocs := 'WHERE 
                                  CODIGO_TIPO_DOCUMENTO IN ( 
                                    SELECT regexp_substr(''' || Lv_TiposDocumentos || ''', ''[^,]+'', 1, LEVEL) COD_TIPO_DOC
                                    FROM DUAL
                                    CONNECT BY LEVEL <= length(''' || Lv_TiposDocumentos || ''') 
                                    - length(REPLACE(''' || Lv_TiposDocumentos || ''', '','', '''')) + 1 ) ';
    END IF;

    IF Lv_NumDocsAbiertos IS NOT NULL THEN
      Lcl_QueryDocs := 'SELECT DISTINCT PUNTO_ID
                        FROM DB_FINANCIERO.VISTA_DOCUMENTOS_CORTE_MASIVO '
                        || Lv_WhereFiltrosDocs || ' 
                        GROUP BY PUNTO_ID  
                        HAVING COUNT(ID_DOCUMENTO) >= ' || Lv_NumDocsAbiertos || ' ';
    ELSE
      Lcl_QueryDocs := 'SELECT DISTINCT PUNTO_ID
                        FROM DB_FINANCIERO.VISTA_DOCUMENTOS_CORTE_MASIVO '
                        || Lv_WhereFiltrosDocs;

    END IF;                        

    Lcl_FromJoin := Lcl_FromJoin || ' INNER JOIN (' || Lcl_QueryDocs || ') T_PUNTOS_DOCS
                                      ON T_PUNTOS_DOCS.PUNTO_ID = VISTA_CORTE_MASIVO.ID_PUNTO ';

    IF Lv_ValorMontoCartera IS NOT NULL THEN
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.SALDO >= ' || Lv_ValorMontoCartera || ' ';
    ELSE
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.SALDO > ' || Ln_ValorMinMontoCartera || ' ';
    END IF;

    IF Lv_IdTipoNegocio IS NOT NULL THEN
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ID_TIPO_NEGOCIO = ' || Lv_IdTipoNegocio || ' ';
    END IF;

    IF Lv_ValorClienteCanal IS NOT NULL AND Lv_ValorClienteCanal <> 'Todos' THEN
      IF Lv_ValorClienteCanal = 'S' THEN 
        Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ROL = ''' || Lv_ClienteCanal || ''' ';
      ELSE
        Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ROL <> ''' || Lv_ClienteCanal || ''' ';
      END IF;
    END IF;

    IF Lv_NombreUltimaMilla IS NOT NULL THEN
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ULTIMA_MILLA = ''' || Lv_NombreUltimaMilla || ''' ';
    END IF;

    IF Lv_IdCicloFacturacion IS NOT NULL AND Lv_IdCicloFacturacion <> '0' THEN
      Lcl_Where := Lcl_Where || ' AND VISTA_CORTE_MASIVO.CICLO_ID = ''' || Lv_IdCicloFacturacion || ''' ';
    END IF;

    IF Lv_IdsOficinas IS NOT NULL THEN
      Lcl_Where := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ID_OFICINA IN ('|| Lv_IdsOficinas ||') ';
    END IF;

    IF Lv_IdsFormasPago IS NOT NULL THEN
      FOR CURRENT_ROW IN
      ( WITH TEST AS
      (SELECT Lv_IdsFormasPago FROM DUAL
      )
    SELECT REGEXP_SUBSTR(Lv_IdsFormasPago, '[^,]+', 1, ROWNUM) SPLIT
    FROM TEST
      CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE(Lv_IdsFormasPago, '[^,]+')) + 1
      )
      LOOP
        SELECT NVL((SELECT DET.VALOR3
                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
                    ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                    WHERE CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
                    AND CAB.ESTADO = Lv_EstadoActivo
                    AND DET.VALOR1 = Lv_ParamDetCorteMasivo
                    AND DET.VALOR2 = Lv_ParamIdsFpCtaTarjBancos
                    AND DET.VALOR3 = CURRENT_ROW.SPLIT
                    AND DET.ESTADO = Lv_EstadoActivo),'') AS ID_PARAM_CTA_TARJ_BANCOS
        INTO Lv_ParamIdFpCtaTarjBancos
        FROM DB_GENERAL.ADMI_FORMA_PAGO
        WHERE ID_FORMA_PAGO = CURRENT_ROW.SPLIT;
        IF(Lv_ParamIdFpCtaTarjBancos IS NOT NULL) THEN
          Lv_IdsFpConCtaTarjBancos := Lv_IdsFpConCtaTarjBancos || '' || Lv_ParamIdFpCtaTarjBancos || ', ';
        ELSE
          Lv_IdsFpSinCtaTarjBancos := Lv_IdsFpSinCtaTarjBancos || '' || CURRENT_ROW.SPLIT || ', ';
        END IF;
      END LOOP;

      IF Lv_IdsFpConCtaTarjBancos IS NOT NULL THEN 
        Lv_IdsFpConCtaTarjBancos := RTRIM(Lv_IdsFpConCtaTarjBancos,', ');
      END IF;

      IF Lv_IdsFpSinCtaTarjBancos IS NOT NULL THEN 
        Lv_IdsFpSinCtaTarjBancos := RTRIM(Lv_IdsFpSinCtaTarjBancos,', ');
      END IF;
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ID_FORMA_PAGO IN ( ' || Lv_IdsFormasPago || ') ';
    END IF;

    IF Lv_IdsFpConCtaTarjBancos IS NOT NULL THEN
      Lv_EsTarjeta := '';
      IF Lv_ValorCuentaTarjeta IS NOT NULL THEN
        IF Lv_ValorCuentaTarjeta = 'Tarjeta' THEN
          Lv_EsTarjeta  := 'S';
          Lcl_WhereCtaTarjBancos    := Lcl_WhereCtaTarjBancos  || ' AND VISTA_CORTE_MASIVO.ES_TARJETA = ''' || Lv_EsTarjeta || ''' ';
        ELSIF Lv_ValorCuentaTarjeta = 'Cuenta' THEN
          Lv_EsTarjeta  := 'N';
          Lcl_WhereCtaTarjBancos    := Lcl_WhereCtaTarjBancos  || ' AND VISTA_CORTE_MASIVO.ES_TARJETA = ''' || Lv_EsTarjeta || ''' ';
        END IF;
      END IF;

      IF Lv_IdsTiposCuentaTarjeta IS NOT NULL THEN
        Lcl_WhereCtaTarjBancos  := Lcl_WhereCtaTarjBancos || ' AND VISTA_CORTE_MASIVO.TIPO_CUENTA_ID IN (' || Lv_IdsTiposCuentaTarjeta || ') ';
      END IF;

      IF Lv_IdsBancos IS NOT NULL THEN
        Lcl_WhereCtaTarjBancos  := Lcl_WhereCtaTarjBancos || ' AND VISTA_CORTE_MASIVO.BANCO_ID IN (' || Lv_IdsBancos || ') ';
      END IF;
    END IF;

    IF Lv_IdsFpConCtaTarjBancos IS NOT NULL AND Lv_IdsFpSinCtaTarjBancos IS NOT NULL THEN
      Lcl_Where  := Lcl_Where || ' AND (' ||
                                            '( ' ||
                                                ' VISTA_CORTE_MASIVO.ID_FORMA_PAGO IN ( ' || Lv_IdsFpConCtaTarjBancos || ') ' ||
                                                Lcl_WhereCtaTarjBancos ||
                                            ') ' ||
                                            ' OR ' ||
                                            ' VISTA_CORTE_MASIVO.ID_FORMA_PAGO IN ( ' || Lv_IdsFpSinCtaTarjBancos || ') ' ||
                                      ') ';
    ELSIF Lv_IdsFpConCtaTarjBancos IS NOT NULL AND Lv_IdsFpSinCtaTarjBancos IS NULL THEN
      Lcl_Where  := Lcl_Where || Lcl_WhereCtaTarjBancos;
    END IF;

    Lcl_QueryFinal := Lv_Select || Lcl_FromJoin || Lcl_Where || Lv_OrderBy;
    Lcl_QueryCount := Lv_SelectCount || Lcl_FromJoin || Lcl_Where;
    IF Ln_Limit IS NOT NULL AND Ln_Limit > 0 THEN
      Ln_LimitConsulta  := Ln_Limit + Ln_Start;
      Lcl_QueryFinal    := 'SELECT a.*, rownum AS doctrine_rownum FROM (' || Lcl_QueryFinal || ') a WHERE rownum <= ' || Ln_LimitConsulta || ' ';
      IF Ln_Start IS NOT NULL AND Ln_Start > 0 THEN
        Ln_StartConsulta := Ln_Start + 1;
        Lcl_QueryFinal := 'SELECT * FROM (' || Lcl_QueryFinal || ') WHERE doctrine_rownum >= ' || Ln_StartConsulta || ' ';
      END IF;
    END IF;

    DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Lv_CodEmpresa,
                         '1',
                         'P_GET_PUNTOS_CORTE_MASIVO',
                         'DB_COMERCIAL.TECNK_SERVICIOS',
                         'P_GET_PUNTOS_CORTE_MASIVO',
                         'Ejecutando procedure principal P_GET_PUNTOS_CORTE_MASIVO',
                         'Seguimiento',
                         Lcl_QueryFinal,
                         'Sin parámetros',
                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL')); 
    OPEN Lrf_PuntosCorteMasivo FOR Lcl_QueryFinal;
    Pv_Status         := 'OK';
    IF Pv_ConsultaTotalRegistros = 'SI' THEN
      Pn_TotalRegistros := DB_COMERCIAL.TECNK_SERVICIOS.GET_COUNT_REFCURSOR(Lcl_QueryCount);
    ELSE
      Pn_TotalRegistros := 0;
    END IF;
    Prf_Registros     := Lrf_PuntosCorteMasivo;

  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status         := 'ERROR';
    Pv_MsjError       := Lv_MsjError;
    Pn_TotalRegistros := 0;
    Prf_Registros     := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_GET_PUNTOS_CORTE_MASIVO',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status         := 'ERROR';
    Pv_MsjError       := 'No se ha podido realizar la consulta de manera correcta';            
    Pn_TotalRegistros := 0;
    Prf_Registros     := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_GET_PUNTOS_CORTE_MASIVO',
                                          'Error al obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_PUNTOS_CORTE_MASIVO;

  PROCEDURE P_GET_RESUMEN_CORTE_MASIVO(
    Pcl_JsonFiltrosBusqueda   IN CLOB,
    Pv_Status                 OUT VARCHAR2,
    Pv_MsjError               OUT VARCHAR2,
    Prf_Registros             OUT SYS_REFCURSOR)
  AS    
    Lv_CodEmpresa               VARCHAR2(2);
    Lv_FechaCreacionDoc         VARCHAR2(10);
    Lv_TiposDocumentos          VARCHAR2(100);
    Lv_NumDocsAbiertos          VARCHAR2(10);
    Lv_ValorMontoCartera        VARCHAR2(10);
    Ln_ValorMinMontoCartera     NUMBER := 5;
    Lv_IdTipoNegocio            VARCHAR2(10);
    Lv_ValorClienteCanal        VARCHAR2(20);
    Lv_NombreUltimaMilla        VARCHAR2(20);
    Lv_IdCicloFacturacion       VARCHAR2(10);
    Lcl_WhereCtaTarjBancos      CLOB;
    Lv_IdsOficinas              VARCHAR2(32767);
    Lv_IdsFormasPago            VARCHAR2(1000);
    Lv_IdsFpConCtaTarjBancos    VARCHAR2(1000);
    Lv_IdsFpSinCtaTarjBancos    VARCHAR2(1000);
    Lv_ParamIdFpCtaTarjBancos   VARCHAR2(300);
    Lv_ValorCuentaTarjeta       VARCHAR2(100);
    Lv_EsTarjeta                VARCHAR2(1);
    Lv_IdsTiposCuentaTarjeta    VARCHAR2(4000);
    Lv_IdsBancos                VARCHAR2(32767);
    Lv_Start                    VARCHAR2(10);
    Ln_Start                    NUMBER;
    Lv_Limit                    VARCHAR2(10);
    Ln_Limit                    NUMBER;
    Lcl_JsonFiltrosBusqueda     CLOB;
    Lv_Select                   VARCHAR2(4000);
    Lcl_FromJoin                CLOB;
    Lcl_Where                   CLOB;
    Lv_WhereDocsAbiertos        VARCHAR2(4000);
    Lcl_QueryFinal              CLOB;
    Lv_MsjError                 VARCHAR2(4000);
    Le_Exception                EXCEPTION;
    Lv_ClienteCanal             VARCHAR2(13) := 'Cliente Canal';
    Lrf_ResumenCorteMasivo      SYS_REFCURSOR;
    Lv_ParamCabNombreParametro  VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_ParamDetCorteMasivo      VARCHAR2(13) := 'CORTE_MASIVO';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
    Lv_ParamIdsFpCtaTarjBancos  VARCHAR2(38) := 'IDS_FORMAS_PAGO_CUENTA_TARJETA_BANCOS';
    Lv_ParamDetTiposDocs        VARCHAR2(20) := 'TIPOS_DE_DOCUMENTOS';
    Lv_ParamDetDocResumenPrevio VARCHAR2(25) := 'PERMITIDO_RESUMEN_PREVIO';
    Lv_FechaLimAct              VARCHAR2(100);
    Lv_IdentExcluidas           VARCHAR2(1000);
    Ln_IdentExcluidas_count     NUMBER;
    Ln_IteradorI                NUMBER;
    Lcl_WhereIdentExcluidas     CLOB;

  BEGIN
    Lcl_JsonFiltrosBusqueda   := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_CodEmpresa             := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strCodEmpresa'));
    Lv_FechaCreacionDoc       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strFechaCreacionDoc'));
    Lv_TiposDocumentos        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strTiposDocumentos'));
    Lv_NumDocsAbiertos        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strNumDocsAbiertos'));
    Lv_ValorMontoCartera      := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorMontoCartera'));
    Lv_IdTipoNegocio          := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdTipoNegocio'));
    Lv_ValorClienteCanal      := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorClienteCanal'));
    Lv_NombreUltimaMilla      := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strNombreUltimaMilla'));
    Lv_IdCicloFacturacion     := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdCicloFacturacion'));
    Lv_IdsOficinas            := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsOficinas'));
    Lv_IdsFormasPago          := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsFormasPago'));
    Lv_ValorCuentaTarjeta     := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strValorCuentaTarjeta'));
    Lv_IdsTiposCuentaTarjeta  := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsTiposCuentaTarjeta'));
    Lv_IdsBancos              := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdsBancos'));
    Lv_Start                  := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strStart'));
    Lv_Limit                  := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strLimit'));
    Lv_FechaLimAct            := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strFechaLimActivacion'));
    Ln_IdentExcluidas_Count   := APEX_JSON.GET_COUNT(p_path => 'arrayFinalIdExcluidas');
    Ln_IteradorI := 1;

    IF Ln_IdentExcluidas_Count > 0 THEN
        -- AGREGO IDENTIFICACIONES A TABLA TEMPORAL
        WHILE (Ln_IteradorI <= Ln_IdentExcluidas_Count)
        LOOP
            Lv_IdentExcluidas := '';
            Lv_IdentExcluidas := APEX_JSON.GET_VARCHAR2(p_path => 'arrayFinalIdExcluidas[%d]', p0 => Ln_IteradorI);

            EXECUTE IMMEDIATE 'INSERT INTO DB_COMERCIAL.TMP_IDENTIFICACIONES_EXCLUIDAS (IDENTIFICACION_CLIENTE) VALUES   
                                ('''|| Lv_IdentExcluidas || ''')';
            Ln_IteradorI := Ln_IteradorI + 1;
        END LOOP;
        COMMIT;
    END IF;

    IF Lv_CodEmpresa IS NULL THEN
      Lv_MsjError := 'No se ha enviado el parámetro obligatorio del código de la empresa';
      RAISE Le_Exception;
    END IF;

    IF Lv_FechaCreacionDoc IS NULL THEN
      Lv_MsjError := 'No se ha enviado el parámetro obligatorio de la fecha de creación del documento';
      RAISE Le_Exception;
    END IF;

    IF Lv_TiposDocumentos IS NULL THEN
      Lv_MsjError := 'No se ha enviado el parámetro obligatorio del tipo de documento';
      RAISE Le_Exception;
    END IF;

    IF Lv_Start IS NOT NULL THEN
      Ln_Start := TO_NUMBER(Lv_Start, '9999999999');
    ELSE
      Ln_Start := 0;
    END IF;

    IF Lv_Limit IS NOT NULL THEN
      Ln_Limit := TO_NUMBER(Lv_Limit, '99999');
    ELSE
      Ln_Limit := 0;
    END IF;

    Lv_Select       := 'SELECT DISTINCT VISTA_DOCS_CORTE_MASIVO.PUNTO_ID, VISTA_DOCS_CORTE_MASIVO.CODIGO_TIPO_DOCUMENTO, 
                        PRIORIDAD_CODIGOS_DOCS.PRIORIDAD_CONTEO ';
    Lcl_FromJoin    := 'FROM DB_FINANCIERO.VISTA_DOCUMENTOS_CORTE_MASIVO VISTA_DOCS_CORTE_MASIVO 
                        INNER JOIN DB_COMERCIAL.VISTA_PM_CORTE_FAC_ABI VISTA_CORTE_MASIVO 
                        ON VISTA_CORTE_MASIVO.ID_PUNTO = VISTA_DOCS_CORTE_MASIVO.PUNTO_ID 
                        INNER JOIN
                        (SELECT PARAM_DET.VALOR4 AS CODIGO_TIPO_DOC,
                          PARAM_DET.VALOR7       AS PRIORIDAD_CONTEO
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                        ON PARAM_DET.PARAMETRO_ID                                          = PARAM_CAB.ID_PARAMETRO
                        WHERE PARAM_CAB.NOMBRE_PARAMETRO                                   = ''' || Lv_ParamCabNombreParametro || ''' 
                        AND PARAM_CAB.ESTADO                                               = ''' || Lv_EstadoActivo || ''' 
                        AND PARAM_DET.VALOR1                                               = ''' || Lv_ParamDetCorteMasivo || ''' 
                        AND PARAM_DET.VALOR2                                               = ''' || Lv_ParamDetTiposDocs || ''' 
                        AND PARAM_DET.VALOR5                                               = ''' || Lv_ParamDetDocResumenPrevio || ''' 
                        AND PARAM_DET.ESTADO                                               = ''' || Lv_EstadoActivo || ''' 
                        ) PRIORIDAD_CODIGOS_DOCS 
                        ON PRIORIDAD_CODIGOS_DOCS.CODIGO_TIPO_DOC = VISTA_DOCS_CORTE_MASIVO.CODIGO_TIPO_DOCUMENTO ';
    Lcl_Where       := 'WHERE VISTA_CORTE_MASIVO.EMPRESA_COD = ''' || Lv_CodEmpresa || ''' 
                        AND TO_DATE(VISTA_DOCS_CORTE_MASIVO.FE_CREACION_DOCUMENTO, ''YYYY-MM-DD'') 
                            <= TO_DATE(''' || Lv_FechaCreacionDoc || ''', ''YYYY-MM-DD'' )
                        AND VISTA_DOCS_CORTE_MASIVO.CODIGO_TIPO_DOCUMENTO IN ( 
                            SELECT regexp_substr(''' || Lv_TiposDocumentos || ''', ''[^,]+'', 1, LEVEL) COD_TIPO_DOC
                            FROM DUAL
                            CONNECT BY LEVEL <= length(''' || Lv_TiposDocumentos || ''') 
                            - length(REPLACE(''' || Lv_TiposDocumentos || ''', '','', '''')) + 1 ) ';

    ---FILTRO DE IDENTIFICACIONES EXCLUIDAS
    IF Ln_IdentExcluidas_Count > 0 THEN
        Lcl_WhereIdentExcluidas := ' AND VISTA_CORTE_MASIVO.ID_PERSONA NOT IN (SELECT INFOP.ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA INFOP'
                                                                              || ' WHERE INFOP.IDENTIFICACION_CLIENTE IN (SELECT IEX.IDENTIFICACION_CLIENTE FROM DB_COMERCIAL.TMP_IDENTIFICACIONES_EXCLUIDAS IEX)) ';   
        Lcl_Where  := Lcl_Where || Lcl_WhereIdentExcluidas;
    END IF;

    ---FILTRO DE FECHA DE ACTIVACION
    IF Lv_FechaLimAct IS NOT NULL AND LENGTH(Lv_FechaLimAct) = 10 THEN
        Lcl_FromJoin    := Lcl_FromJoin || ' INNER JOIN (SELECT IPP.ID_PUNTO, SERV_HIS.FE_CREACION 
                                        FROM DB_COMERCIAL.INFO_PUNTO IPP
                                        LEFT JOIN (SELECT INS.PUNTO_ID, MIN(TRUNC(ISH.FE_CREACION)) AS FE_CREACION
                                                    FROM DB_COMERCIAL.INFO_SERVICIO INS
                                                    JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON INS.ID_SERVICIO = ISH.SERVICIO_ID
                                                    WHERE ISH.ESTADO = ''Activo''
                                                    AND ISH.ACCION IN (''feOrigenCambioRazonSocial'', ''feOrigServicioTrasladado'', ''confirmarServicio'')
                                                    GROUP BY INS.PUNTO_ID 
                                                    ORDER BY INS.PUNTO_ID) SERV_HIS
                                        ON IPP.ID_PUNTO = SERV_HIS.PUNTO_ID
                                        WHERE TO_DATE(TO_CHAR(TO_DATE(NVL(SERV_HIS.FE_CREACION, LAST_DAY(TO_DATE(''' || Lv_FechaLimAct || ''', ''YYYY-MM-DD''))), ''DD-MM-YY''), ''YYYY-MM-DD''), ''YYYY-MM-DD'') <= LAST_DAY(TO_DATE(''' || Lv_FechaLimAct || ''', ''YYYY-MM-DD''))) F_ACTIVACION_TABLE
                         ON F_ACTIVACION_TABLE.ID_PUNTO = VISTA_CORTE_MASIVO.ID_PUNTO ';

    END IF;

    IF Lv_NumDocsAbiertos IS NOT NULL THEN
      Lv_Select             := Lv_Select || ', COUNT(VISTA_DOCS_CORTE_MASIVO.ID_DOCUMENTO) OVER (PARTITION BY VISTA_DOCS_CORTE_MASIVO.PUNTO_ID) 
                                               AS NUM_DOCS_ABIERTOS_X_PUNTO ';
      Lv_WhereDocsAbiertos  := 'WHERE NUM_DOCS_ABIERTOS_X_PUNTO >= ' || Lv_NumDocsAbiertos || ' ';
    END IF;                        

    IF Lv_ValorMontoCartera IS NOT NULL THEN
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.SALDO >= ' || Lv_ValorMontoCartera || ' ';
    ELSE
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.SALDO > ' || Ln_ValorMinMontoCartera || ' ';
    END IF;

    IF Lv_IdTipoNegocio IS NOT NULL THEN
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ID_TIPO_NEGOCIO = ' || Lv_IdTipoNegocio || ' ';
    END IF;

    IF Lv_ValorClienteCanal IS NOT NULL AND Lv_ValorClienteCanal <> 'Todos' THEN
      IF Lv_ValorClienteCanal = 'S' THEN 
        Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ROL = ''' || Lv_ClienteCanal || ''' ';
      ELSE
        Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ROL <> ''' || Lv_ClienteCanal || ''' ';
      END IF;
    END IF;

    IF Lv_NombreUltimaMilla IS NOT NULL THEN
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ULTIMA_MILLA = ''' || Lv_NombreUltimaMilla || ''' ';
    END IF;

    IF Lv_IdCicloFacturacion IS NOT NULL AND Lv_IdCicloFacturacion <> '0' THEN
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.CICLO_ID = ' || Lv_IdCicloFacturacion || ' ';
    END IF;

    IF Lv_IdsOficinas IS NOT NULL THEN
      Lcl_Where := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ID_OFICINA IN ('|| Lv_IdsOficinas ||') ';
    END IF;

    IF Lv_IdsFormasPago IS NOT NULL THEN
      FOR CURRENT_ROW IN
      ( WITH TEST AS
      (SELECT Lv_IdsFormasPago FROM DUAL
      )
    SELECT REGEXP_SUBSTR(Lv_IdsFormasPago, '[^,]+', 1, ROWNUM) SPLIT
    FROM TEST
      CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE(Lv_IdsFormasPago, '[^,]+')) + 1
      )
      LOOP
        SELECT NVL((SELECT DET.VALOR3
                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
                    ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                    WHERE CAB.NOMBRE_PARAMETRO = Lv_ParamCabNombreParametro
                    AND CAB.ESTADO = Lv_EstadoActivo
                    AND DET.VALOR1 = Lv_ParamDetCorteMasivo
                    AND DET.VALOR2 = Lv_ParamIdsFpCtaTarjBancos
                    AND DET.VALOR3 = CURRENT_ROW.SPLIT
                    AND DET.ESTADO = Lv_EstadoActivo),'') AS ID_PARAM_CTA_TARJ_BANCOS
        INTO Lv_ParamIdFpCtaTarjBancos
        FROM DB_GENERAL.ADMI_FORMA_PAGO
        WHERE ID_FORMA_PAGO = CURRENT_ROW.SPLIT;
        IF(Lv_ParamIdFpCtaTarjBancos IS NOT NULL) THEN
          Lv_IdsFpConCtaTarjBancos := Lv_IdsFpConCtaTarjBancos || '' || Lv_ParamIdFpCtaTarjBancos || ', ';
        ELSE
          Lv_IdsFpSinCtaTarjBancos := Lv_IdsFpSinCtaTarjBancos || '' || CURRENT_ROW.SPLIT || ', ';
        END IF;
      END LOOP;

      IF Lv_IdsFpConCtaTarjBancos IS NOT NULL THEN 
        Lv_IdsFpConCtaTarjBancos := RTRIM(Lv_IdsFpConCtaTarjBancos,', ');
      END IF;

      IF Lv_IdsFpSinCtaTarjBancos IS NOT NULL THEN 
        Lv_IdsFpSinCtaTarjBancos := RTRIM(Lv_IdsFpSinCtaTarjBancos,', ');
      END IF;
      Lcl_Where  := Lcl_Where || ' AND VISTA_CORTE_MASIVO.ID_FORMA_PAGO IN ( ' || Lv_IdsFormasPago || ') ';
    END IF;

    IF Lv_IdsFpConCtaTarjBancos IS NOT NULL THEN
      Lv_EsTarjeta := '';
      IF Lv_ValorCuentaTarjeta IS NOT NULL THEN
        IF Lv_ValorCuentaTarjeta = 'Tarjeta' THEN
          Lv_EsTarjeta  := 'S';
          Lcl_WhereCtaTarjBancos    := Lcl_WhereCtaTarjBancos  || ' AND VISTA_CORTE_MASIVO.ES_TARJETA = ''' || Lv_EsTarjeta || ''' ';
        ELSIF Lv_ValorCuentaTarjeta = 'Cuenta' THEN
          Lv_EsTarjeta  := 'N';
          Lcl_WhereCtaTarjBancos    := Lcl_WhereCtaTarjBancos  || ' AND VISTA_CORTE_MASIVO.ES_TARJETA = ''' || Lv_EsTarjeta || ''' ';
        END IF;
      END IF;

      IF Lv_IdsTiposCuentaTarjeta IS NOT NULL THEN
        Lcl_WhereCtaTarjBancos  := Lcl_WhereCtaTarjBancos || ' AND VISTA_CORTE_MASIVO.TIPO_CUENTA_ID IN (' || Lv_IdsTiposCuentaTarjeta || ') ';
      END IF;

      IF Lv_IdsBancos IS NOT NULL THEN
        Lcl_WhereCtaTarjBancos  := Lcl_WhereCtaTarjBancos || ' AND VISTA_CORTE_MASIVO.BANCO_ID IN (' || Lv_IdsBancos || ') ';
      END IF;
    END IF;

    IF Lv_IdsFpConCtaTarjBancos IS NOT NULL AND Lv_IdsFpSinCtaTarjBancos IS NOT NULL THEN
      Lcl_Where  := Lcl_Where || ' AND (' ||
                                            '( ' ||
                                                ' VISTA_CORTE_MASIVO.ID_FORMA_PAGO IN ( ' || Lv_IdsFpConCtaTarjBancos || ') ' ||
                                                Lcl_WhereCtaTarjBancos ||
                                            ') ' ||
                                            ' OR ' ||
                                            ' VISTA_CORTE_MASIVO.ID_FORMA_PAGO IN ( ' || Lv_IdsFpSinCtaTarjBancos || ') ' ||
                                      ') ';
    ELSIF Lv_IdsFpConCtaTarjBancos IS NOT NULL AND Lv_IdsFpSinCtaTarjBancos IS NULL THEN
      Lcl_Where  := Lcl_Where || Lcl_WhereCtaTarjBancos;
    END IF;

    Lcl_QueryFinal := ' SELECT COUNT(PUNTO_ID) AS NUM_PUNTOS,
                        CODIGO_TIPO_DOCUMENTO 
                        FROM
                        (
                          SELECT PUNTO_ID,
                          CODIGO_TIPO_DOCUMENTO,
                          ROW_NUMBER() OVER (PARTITION BY PUNTO_ID ORDER BY PRIORIDAD_CONTEO ASC) AS RN 
                          FROM (' || Lv_Select || Lcl_FromJoin || Lcl_Where || ') ' ||
                          Lv_WhereDocsAbiertos || ' 
                        ) 
                        WHERE RN = 1
                        GROUP BY CODIGO_TIPO_DOCUMENTO ';

    DB_GENERAL.GNRLPCK_UTIL.P_INSERT_LOG(Lv_CodEmpresa,
                         '1',
                         'P_GET_RESUMEN_CORTE_MASIVO',
                         'DB_COMERCIAL.TECNK_SERVICIOS',
                         'P_GET_RESUMEN_CORTE_MASIVO',
                         'Ejecutando procedure principal P_GET_RESUMEN_CORTE_MASIVO',
                         'Seguimiento',
                         Lcl_QueryFinal,
                         'Sin parámetros',
                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL')); 

    OPEN Lrf_ResumenCorteMasivo FOR Lcl_QueryFinal;
    Pv_Status         := 'OK';
    Prf_Registros     := Lrf_ResumenCorteMasivo;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status         := 'ERROR';
    Pv_MsjError       := Lv_MsjError;
    Prf_Registros     := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_GET_RESUMEN_CORTE_MASIVO',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status         := 'ERROR';
    Pv_MsjError       := 'No se ha podido realizar la consulta de manera correcta';            
    Prf_Registros     := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_GET_RESUMEN_CORTE_MASIVO',
                                          'Error al obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_RESUMEN_CORTE_MASIVO;

  PROCEDURE P_VERIFICA_TECNOLOGIA_DB(
    Pv_MarcaOlt                     IN VARCHAR2,
    Pv_ModeloOlt                    IN VARCHAR2,
    Pv_TipoOnt                      IN VARCHAR2,
    Pn_IdServicioInternet           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pv_Status                       OUT VARCHAR2,
    Pv_MsjError                     OUT VARCHAR2,
    Pv_ModelosEquiposOntXTipoOnt    OUT VARCHAR2,
    Pv_ModelosEquiposEdbXTipoOnt    OUT VARCHAR2,
    Pv_ModelosEquiposWdb            OUT VARCHAR2,
    Pv_ModelosEquiposEdb            OUT VARCHAR2)
  AS
    CURSOR Lc_GetInfoServicioTecnico(Cv_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT ELEMENTO.NOMBRE_ELEMENTO, MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO, MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO,
      ST.INTERFACE_ELEMENTO_CONECTOR_ID
      FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ST
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
      ON ELEMENTO.ID_ELEMENTO = ST.ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ELEMENTO
      ON MODELO_ELEMENTO.ID_MODELO_ELEMENTO = ELEMENTO.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_ELEMENTO
      ON MARCA_ELEMENTO.ID_MARCA_ELEMENTO = MODELO_ELEMENTO.MARCA_ELEMENTO_ID
      WHERE ST.SERVICIO_ID  = Cv_IdServicio;
    Lr_InfoServicioTecnico          Lc_GetInfoServicioTecnico%ROWTYPE;
    Lv_MarcaElementoSt              DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE;
    Lv_ModeloElementoSt             DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE;
    Lv_ModelosOltEquiposdb          VARCHAR2(29) := 'MODELOS_OLT_EQUIPOS_DUAL_BAND';
    Lv_ModelosEquipos               VARCHAR2(200) := 'MODELOS_EQUIPOS';
    Lv_ModelosExtendersPorOnt       VARCHAR2(26) := 'MODELOS_EXTENDERS_POR_ONT';
    Lrf_BusquedaEquipodb            SYS_REFCURSOR;
    Lr_ParametroDetalleBusqueda     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lr_RespuestaBusqEquipodb        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Lv_ModelosEquiposOntXTipoOnt    VARCHAR2(4000);
    Lv_ModelosEquiposEdbXTipoOnt    VARCHAR2(4000);
    Lv_ModelosEquiposWdb            VARCHAR2(4000);
    Lv_ModelosEquiposEdb            VARCHAR2(4000);
    Le_Exception                    EXCEPTION;
    TYPE Lt_ParametrosDet           IS TABLE OF DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lt_RespuestaBusqEquipodb        Lt_ParametrosDet;
    Ln_IndxRespuestaBusqEquipodb    NUMBER;
    Lv_TecnologiaPermitida          VARCHAR2(2);
    Lv_PermitidoWYExtenderEnPlanes  VARCHAR2(300);
  BEGIN
    IF Pv_MarcaOlt IS NOT NULL AND Pv_ModeloOlt IS NOT NULL THEN
      Lv_MarcaElementoSt  := Pv_MarcaOlt;
      Lv_ModeloElementoSt := Pv_ModeloOlt;
    ELSE
      IF Pn_IdServicioInternet IS NULL OR Pn_IdServicioInternet = 0 THEN
        Lv_MsjError := 'No se ha enviado el ID del servicio de Internet. Por favor consultar con el Dep. de Sistemas!';
        RAISE Le_Exception;
      END IF;
      
      OPEN Lc_GetInfoServicioTecnico(Pn_IdServicioInternet);
      FETCH Lc_GetInfoServicioTecnico INTO Lr_InfoServicioTecnico;
      IF Lc_GetInfoServicioTecnico%FOUND THEN
        Lv_MarcaElementoSt  := Lr_InfoServicioTecnico.NOMBRE_MARCA_ELEMENTO;
        Lv_ModeloElementoSt := Lr_InfoServicioTecnico.NOMBRE_MODELO_ELEMENTO;
      ELSE
        Lv_MsjError := 'No se ha podido obtener la información técnica del Servicio de Internet contratado.';
        RAISE Le_Exception;
      END IF;
      CLOSE Lc_GetInfoServicioTecnico;
    END IF;
    
    Lr_RespuestaBusqEquipodb           := NULL;
    Lr_ParametroDetalleBusqueda        := NULL;
    Lr_ParametroDetalleBusqueda.VALOR1 := Lv_ModelosOltEquiposdb;
    Lr_ParametroDetalleBusqueda.VALOR2 := Lv_MarcaElementoSt;
    Lr_ParametroDetalleBusqueda.VALOR3 := Lv_ModeloElementoSt;
    Lr_ParametroDetalleBusqueda.VALOR4 := NULL;
    Lr_ParametroDetalleBusqueda.VALOR5 := NULL;
    Lrf_BusquedaEquipodb              := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
    FETCH Lrf_BusquedaEquipodb BULK COLLECT INTO Lt_RespuestaBusqEquipodb LIMIT 1;
    Ln_IndxRespuestaBusqEquipodb    := Lt_RespuestaBusqEquipodb.FIRST;
    WHILE (Ln_IndxRespuestaBusqEquipodb IS NOT NULL)
    LOOP
      Lr_RespuestaBusqEquipodb          := Lt_RespuestaBusqEquipodb(Ln_IndxRespuestaBusqEquipodb);
      Lv_TecnologiaPermitida            := 'SI';
      Lv_PermitidoWYExtenderEnPlanes    := Lr_RespuestaBusqEquipodb.VALOR4;
      Ln_IndxRespuestaBusqEquipodb      := Lt_RespuestaBusqEquipodb.NEXT(Ln_IndxRespuestaBusqEquipodb);
    END LOOP;

    IF Lv_TecnologiaPermitida = 'SI' THEN
      Lv_Status := 'OK';
      IF Pv_TipoOnt IS NOT NULL THEN
        Lr_RespuestaBusqEquipodb           := NULL;
        Lr_ParametroDetalleBusqueda        := NULL;
        Lr_ParametroDetalleBusqueda.VALOR1 := Lv_ModelosEquipos;
        Lr_ParametroDetalleBusqueda.VALOR2 := Lv_MarcaElementoSt;
        Lr_ParametroDetalleBusqueda.VALOR3 := Lv_ModeloElementoSt;
        Lr_ParametroDetalleBusqueda.VALOR4 := Pv_TipoOnt;
        Lr_ParametroDetalleBusqueda.VALOR5 := NULL;
        Lrf_BusquedaEquipodb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
        FETCH Lrf_BusquedaEquipodb BULK COLLECT INTO Lt_RespuestaBusqEquipodb LIMIT 100;
        Ln_IndxRespuestaBusqEquipodb    := Lt_RespuestaBusqEquipodb.FIRST;
        WHILE (Ln_IndxRespuestaBusqEquipodb IS NOT NULL)
        LOOP
          Lr_RespuestaBusqEquipodb      := Lt_RespuestaBusqEquipodb(Ln_IndxRespuestaBusqEquipodb);
          IF Lv_ModelosEquiposOntXTipoOnt IS NULL THEN
            Lv_ModelosEquiposOntXTipoOnt := Lr_RespuestaBusqEquipodb.VALOR5;
          ELSE
            Lv_ModelosEquiposOntXTipoOnt := Lv_ModelosEquiposOntXTipoOnt || ', ' || Lr_RespuestaBusqEquipodb.VALOR5;
          END IF;
          Ln_IndxRespuestaBusqEquipodb  := Lt_RespuestaBusqEquipodb.NEXT(Ln_IndxRespuestaBusqEquipodb);
        END LOOP;

        Lr_RespuestaBusqEquipodb           := NULL;
        Lr_ParametroDetalleBusqueda        := NULL;
        Lr_ParametroDetalleBusqueda.VALOR1 := Lv_ModelosExtendersPorOnt;
        Lr_ParametroDetalleBusqueda.VALOR2 := Lv_MarcaElementoSt;
        Lr_ParametroDetalleBusqueda.VALOR3 := Pv_TipoOnt;
        Lr_ParametroDetalleBusqueda.VALOR4 := NULL;
        Lr_ParametroDetalleBusqueda.VALOR5 := NULL;
        Lrf_BusquedaEquipodb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
        FETCH Lrf_BusquedaEquipodb BULK COLLECT INTO Lt_RespuestaBusqEquipodb LIMIT 100;
        Ln_IndxRespuestaBusqEquipodb    := Lt_RespuestaBusqEquipodb.FIRST;
        WHILE (Ln_IndxRespuestaBusqEquipodb IS NOT NULL)
        LOOP
          Lr_RespuestaBusqEquipodb      := Lt_RespuestaBusqEquipodb(Ln_IndxRespuestaBusqEquipodb);
          IF Lv_ModelosEquiposEdbXTipoOnt IS NULL THEN
            Lv_ModelosEquiposEdbXTipoOnt := Lr_RespuestaBusqEquipodb.VALOR5;
          ELSE
            Lv_ModelosEquiposEdbXTipoOnt := Lv_ModelosEquiposEdbXTipoOnt || ', ' || Lr_RespuestaBusqEquipodb.VALOR5;
          END IF;
          Ln_IndxRespuestaBusqEquipodb  := Lt_RespuestaBusqEquipodb.NEXT(Ln_IndxRespuestaBusqEquipodb);
        END LOOP;
      END IF;

      Lr_RespuestaBusqEquipodb           := NULL;
      Lr_ParametroDetalleBusqueda        := NULL;
      Lr_ParametroDetalleBusqueda.VALOR1 := Lv_ModelosEquipos;
      Lr_ParametroDetalleBusqueda.VALOR2 := Lv_MarcaElementoSt;
      Lr_ParametroDetalleBusqueda.VALOR3 := Lv_ModeloElementoSt;
      Lr_ParametroDetalleBusqueda.VALOR4 := 'WIFI DUAL BAND';
      Lr_ParametroDetalleBusqueda.VALOR5 := NULL;
      Lrf_BusquedaEquipodb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
      FETCH Lrf_BusquedaEquipodb BULK COLLECT INTO Lt_RespuestaBusqEquipodb LIMIT 100;
      Ln_IndxRespuestaBusqEquipodb    := Lt_RespuestaBusqEquipodb.FIRST;
      WHILE (Ln_IndxRespuestaBusqEquipodb IS NOT NULL)
      LOOP
        Lr_RespuestaBusqEquipodb      := Lt_RespuestaBusqEquipodb(Ln_IndxRespuestaBusqEquipodb);
        IF Lv_ModelosEquiposWdb IS NULL THEN
          Lv_ModelosEquiposWdb := Lr_RespuestaBusqEquipodb.VALOR5;
        ELSE
          Lv_ModelosEquiposWdb := Lv_ModelosEquiposWdb || ', ' || Lr_RespuestaBusqEquipodb.VALOR5;
        END IF;
        Ln_IndxRespuestaBusqEquipodb  := Lt_RespuestaBusqEquipodb.NEXT(Ln_IndxRespuestaBusqEquipodb);
      END LOOP;

      Lr_RespuestaBusqEquipodb           := NULL;
      Lr_ParametroDetalleBusqueda        := NULL;
      Lr_ParametroDetalleBusqueda.VALOR1 := Lv_ModelosEquipos;
      Lr_ParametroDetalleBusqueda.VALOR2 := Lv_MarcaElementoSt;
      Lr_ParametroDetalleBusqueda.VALOR3 := Lv_ModeloElementoSt;
      Lr_ParametroDetalleBusqueda.VALOR4 := 'EXTENDER DUAL BAND';
      Lr_ParametroDetalleBusqueda.VALOR5 := NULL;
      Lrf_BusquedaEquipodb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
      FETCH Lrf_BusquedaEquipodb BULK COLLECT INTO Lt_RespuestaBusqEquipodb LIMIT 100;
      Ln_IndxRespuestaBusqEquipodb    := Lt_RespuestaBusqEquipodb.FIRST;
      WHILE (Ln_IndxRespuestaBusqEquipodb IS NOT NULL)
      LOOP
        Lr_RespuestaBusqEquipodb      := Lt_RespuestaBusqEquipodb(Ln_IndxRespuestaBusqEquipodb);
        IF Lv_ModelosEquiposEdb IS NULL THEN
          Lv_ModelosEquiposEdb := Lr_RespuestaBusqEquipodb.VALOR5;
        ELSE
          Lv_ModelosEquiposEdb := Lv_ModelosEquiposEdb || ', ' || Lr_RespuestaBusqEquipodb.VALOR5;
        END IF;
        Ln_IndxRespuestaBusqEquipodb  := Lt_RespuestaBusqEquipodb.NEXT(Ln_IndxRespuestaBusqEquipodb);
      END LOOP;
      Lv_MsjError := Lv_MarcaElementoSt || '|' || Lv_ModeloElementoSt || '|' || Lv_PermitidoWYExtenderEnPlanes ;
    ELSE
      Lv_Status   := 'ERROR';
      Lv_MsjError := 'No está permitido para la tecnología del Servicio de Internet contratado';
    END IF;
    Pv_Status                       := Lv_Status;
    Pv_MsjError                     := Lv_MsjError;
    Pv_ModelosEquiposOntXTipoOnt    := Lv_ModelosEquiposOntXTipoOnt;
    Pv_ModelosEquiposEdbXTipoOnt    := Lv_ModelosEquiposEdbXTipoOnt;
    Pv_ModelosEquiposWdb            := Lv_ModelosEquiposWdb;
    Pv_ModelosEquiposEdb            := Lv_ModelosEquiposEdb;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status                       := 'ERROR';
    Pv_MsjError                     := Lv_MsjError;
    Pv_ModelosEquiposOntXTipoOnt    := Lv_ModelosEquiposOntXTipoOnt;
    Pv_ModelosEquiposEdbXTipoOnt    := Lv_ModelosEquiposEdbXTipoOnt;
    Pv_ModelosEquiposWdb            := Lv_ModelosEquiposWdb;
    Pv_ModelosEquiposEdb            := Lv_ModelosEquiposEdb;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_VERIFICA_TECNOLOGIA_DB', 
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status                       := 'ERROR';
    Lv_MsjError                     := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                       || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_MsjError                     := 'Ha ocurrido un error al verificar la tecnología Dual Band. Por favor consultar con el Dep. de Sistemas!';
    Pv_ModelosEquiposOntXTipoOnt    := Lv_ModelosEquiposOntXTipoOnt;
    Pv_ModelosEquiposEdbXTipoOnt    := Lv_ModelosEquiposEdbXTipoOnt;
    Pv_ModelosEquiposWdb            := Lv_ModelosEquiposWdb;
    Pv_ModelosEquiposEdb            := Lv_ModelosEquiposEdb;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_VERIFICA_TECNOLOGIA_DB',
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    
  END P_VERIFICA_TECNOLOGIA_DB;

  PROCEDURE P_VERIFICA_EQUIPO_ENLAZADO(
    Pn_IdServicioInternet         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pn_IdInterfaceElementoIni     IN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE,
    Pv_TipoEquipoABuscar          IN VARCHAR2,
    Pv_ModeloEquipoABuscar        IN VARCHAR2,
    Pv_ProcesoEjecutante          IN VARCHAR2,
    Pv_Status                     OUT VARCHAR2,
    Pv_MsjError                   OUT VARCHAR2,
    Pv_TieneAlgunEquipoEnlazado   OUT VARCHAR2,
    Pv_InfoEquipoEncontrado       OUT VARCHAR2,
    Pcl_TrazaElementos            OUT CLOB)
  AS
    Lv_EstadoActivo VARCHAR2(6) := 'Activo';
    CURSOR Lc_GetInfoServicioTecnico(Cv_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT ELEMENTO.NOMBRE_ELEMENTO, MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO, MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO,
      ST.INTERFACE_ELEMENTO_CONECTOR_ID
      FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ST
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
      ON ELEMENTO.ID_ELEMENTO = ST.ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ELEMENTO
      ON MODELO_ELEMENTO.ID_MODELO_ELEMENTO = ELEMENTO.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_ELEMENTO
      ON MARCA_ELEMENTO.ID_MARCA_ELEMENTO = MODELO_ELEMENTO.MARCA_ELEMENTO_ID
      WHERE ST.SERVICIO_ID  = Cv_IdServicio;
    CURSOR Lc_GetNumEnlacesXInterfaceIni(Cv_IdInterfaceElementoIni DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE)
    IS
      SELECT COUNT(DISTINCT ENLACE.ID_ENLACE)
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE
      WHERE ENLACE.ESTADO                  = Lv_EstadoActivo
      AND ENLACE.INTERFACE_ELEMENTO_INI_ID = Cv_IdInterfaceElementoIni;
    CURSOR Lc_GetEnlaceXInterfaceIni(Cv_IdInterfaceElementoIni DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE)
    IS
      SELECT ENLACE.ID_ENLACE,
        ENLACE.INTERFACE_ELEMENTO_INI_ID,
        ENLACE.INTERFACE_ELEMENTO_FIN_ID
      FROM DB_INFRAESTRUCTURA.INFO_ENLACE ENLACE
      WHERE ENLACE.ESTADO                  = Lv_EstadoActivo
      AND ENLACE.INTERFACE_ELEMENTO_INI_ID = Cv_IdInterfaceElementoIni;
    CURSOR Lc_GetElementoXInterface(Cv_IdInterfaceElemento INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE)
    IS
      SELECT ELEMENTO.ID_ELEMENTO,
        ELEMENTO.NOMBRE_ELEMENTO,
        INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO,
        INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO,
        MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO,
        TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_ELEMENTO
      INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEMENTO
      ON ELEMENTO.ID_ELEMENTO = INTERFACE_ELEMENTO.ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ELEMENTO
      ON MODELO_ELEMENTO.ID_MODELO_ELEMENTO = ELEMENTO.MODELO_ELEMENTO_ID
      INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_ELEMENTO
      ON TIPO_ELEMENTO.ID_TIPO_ELEMENTO              = MODELO_ELEMENTO.TIPO_ELEMENTO_ID
      WHERE INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO = Cv_IdInterfaceElemento;
    Lv_ModelosEquipos           VARCHAR2(200) := 'MODELOS_EQUIPOS';
    Lv_ModelosOltEquiposdb      VARCHAR2(29) := 'MODELOS_OLT_EQUIPOS_DUAL_BAND';
    Lv_TiposEquipos             VARCHAR2(14) := 'TIPOS_EQUIPOS';
    Lv_EsTipoEquipoParam        VARCHAR2(2);
    Lv_ConsultarASistemas       VARCHAR2(2) := 'SI';
    Lrf_BusquedaEquipodb        SYS_REFCURSOR;
    Lr_ParametroDetalleBusqueda DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lr_RespuestaBusqEquipodb    DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lv_ContinuaVerificacion     VARCHAR2(2);
    Lr_InfoServicioTecnico      Lc_GetInfoServicioTecnico%ROWTYPE;
    Lr_ElementoXInterface       Lc_GetElementoXInterface%ROWTYPE;
    Lr_EnlaceXInterfaceIni      Lc_GetEnlaceXInterfaceIni%ROWTYPE;
    Ln_IdInterfaceElementoIni   DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE;
    Ln_IdInterfaceElementoFin   DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE;
    Ln_NumEnlacesXInterfaceIni  NUMBER;
    Ln_ContadorEnlaces          NUMBER;
    Lv_MarcaElementoSt          DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE;
    Lv_ModeloElementoSt         DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE;
    Lv_Status                   VARCHAR2(5);
    Lv_MsjError                 VARCHAR2(4000);
    Lv_TieneAlgunEquipoEnlazado VARCHAR2(2) := 'NO';
    Lcl_TrazaElementos          CLOB;
    Lv_InfoEquipoEncontrado     VARCHAR2(4000);
    Le_Exception                EXCEPTION;
  BEGIN
    IF Pn_IdServicioInternet IS NULL OR Pn_IdServicioInternet = 0 THEN
      Lv_MsjError := 'No se ha enviado el ID del servicio de Internet';
      RAISE Le_Exception;
    END IF;

    IF Pv_TipoEquipoABuscar IS NULL THEN
      Lv_MsjError := 'No se ha enviado el tipo de equipo a buscar en los enlaces del servicio';
      RAISE Le_Exception;
    END IF;
    
    OPEN Lc_GetInfoServicioTecnico(Pn_IdServicioInternet);
    FETCH Lc_GetInfoServicioTecnico INTO Lr_InfoServicioTecnico;
    IF Lc_GetInfoServicioTecnico%FOUND THEN
      Lv_MarcaElementoSt  := Lr_InfoServicioTecnico.NOMBRE_MARCA_ELEMENTO;
      Lv_ModeloElementoSt := Lr_InfoServicioTecnico.NOMBRE_MODELO_ELEMENTO;
      IF Pn_IdInterfaceElementoIni IS NULL OR Pn_IdInterfaceElementoIni = 0 THEN
        Ln_IdInterfaceElementoIni := Lr_InfoServicioTecnico.INTERFACE_ELEMENTO_CONECTOR_ID;
      ELSE
        Ln_IdInterfaceElementoIni := Pn_IdInterfaceElementoIni;
      END IF;
    ELSE
      Lv_MsjError := 'No se ha podido obtener la información técnica del Servicio de Internet contratado';
      RAISE Le_Exception;
    END IF;
    CLOSE Lc_GetInfoServicioTecnico;

    Lr_RespuestaBusqEquipodb           := NULL;
    Lr_ParametroDetalleBusqueda        := NULL;
    Lr_ParametroDetalleBusqueda.VALOR1 := Lv_TiposEquipos;
    Lr_ParametroDetalleBusqueda.VALOR2 := Lv_MarcaElementoSt;
    Lr_ParametroDetalleBusqueda.VALOR3 := Lv_ModeloElementoSt;
    Lr_ParametroDetalleBusqueda.VALOR4 := Pv_TipoEquipoABuscar;
    Lr_ParametroDetalleBusqueda.VALOR5 := NULL;
    Lrf_BusquedaEquipodb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
    FETCH Lrf_BusquedaEquipodb INTO Lr_RespuestaBusqEquipodb;
    IF Lr_RespuestaBusqEquipodb.ID_PARAMETRO_DET IS NOT NULL THEN
      Lv_EsTipoEquipoParam := 'SI';
    ELSIF Pv_ModeloEquipoABuscar IS NULL THEN
      Lv_MsjError           := 'El tipo de equipo ' || Pv_TipoEquipoABuscar || ' no está permitido para la tecnología ' 
                               || Lv_MarcaElementoSt || ' del servicio de Internet contratado';
      Lv_ConsultarASistemas := 'NO';
      RAISE Le_Exception;
    ELSE
      Lv_EsTipoEquipoParam := 'NO';
    END IF;

    Ln_ContadorEnlaces                   := 0;
    IF Lv_EsTipoEquipoParam = 'SI' THEN
      Lr_RespuestaBusqEquipodb           := NULL;
      Lr_ParametroDetalleBusqueda        := NULL;
      Lr_ParametroDetalleBusqueda.VALOR1 := Lv_ModelosOltEquiposdb;
      Lr_ParametroDetalleBusqueda.VALOR2 := Lv_MarcaElementoSt;
      Lr_ParametroDetalleBusqueda.VALOR3 := Lv_ModeloElementoSt;
      Lr_ParametroDetalleBusqueda.VALOR4 := NULL;
      Lr_ParametroDetalleBusqueda.VALOR5 := NULL;
      Lrf_BusquedaEquipodb              := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
      FETCH Lrf_BusquedaEquipodb INTO Lr_RespuestaBusqEquipodb;
      IF Lr_RespuestaBusqEquipodb.ID_PARAMETRO_DET IS NOT NULL THEN
        Lv_ContinuaVerificacion := 'SI';
      ELSE
        Lv_ContinuaVerificacion := 'NO';
      END IF;
    ELSE
      Lv_ContinuaVerificacion := 'SI';
    END IF;
    IF Lv_ContinuaVerificacion = 'SI' THEN
      LOOP
        Lr_RespuestaBusqEquipodb    := NULL;
        Lr_ParametroDetalleBusqueda := NULL;
        Lv_InfoEquipoEncontrado     := '';
        Ln_NumEnlacesXInterfaceIni  := 0;
        Lr_ElementoXInterface       := NULL;
        Ln_ContadorEnlaces          := Ln_ContadorEnlaces + 1;
        OPEN Lc_GetNumEnlacesXInterfaceIni(Ln_IdInterfaceElementoIni);
        FETCH Lc_GetNumEnlacesXInterfaceIni INTO Ln_NumEnlacesXInterfaceIni;
        CLOSE Lc_GetNumEnlacesXInterfaceIni;
        IF Ln_NumEnlacesXInterfaceIni > 1 THEN
          IF Lc_GetElementoXInterface%ISOPEN THEN
            CLOSE Lc_GetElementoXInterface;
          END IF;
          OPEN Lc_GetElementoXInterface(Ln_IdInterfaceElementoIni);
          FETCH Lc_GetElementoXInterface INTO Lr_ElementoXInterface;
          IF Lc_GetElementoXInterface%FOUND THEN
            Lv_MsjError := 'La interface ' || Lr_ElementoXInterface.NOMBRE_INTERFACE_ELEMENTO || ' del elemento ' 
                           || Lr_ElementoXInterface.NOMBRE_ELEMENTO || ' tiene ' || Ln_NumEnlacesXInterfaceIni || ' enlaces.';
          ELSE
            Lv_MsjError := 'Ha ocurrido un error al obtener la información del elemento asociado a la INTERFACE INICIAL con ID '
                           || Ln_IdInterfaceElementoIni || ' que tiene ' || Ln_NumEnlacesXInterfaceIni || ' enlaces.';
          END IF;
          CLOSE Lc_GetElementoXInterface;
          RAISE Le_Exception;
        ELSIF Ln_NumEnlacesXInterfaceIni = 0 THEN
          Lv_Status                       := 'OK';
          Lv_ContinuaVerificacion         := 'NO';
        ELSE
          IF Lc_GetEnlaceXInterfaceIni%ISOPEN THEN
            CLOSE Lc_GetEnlaceXInterfaceIni;
          END IF;
          OPEN Lc_GetEnlaceXInterfaceIni(Ln_IdInterfaceElementoIni);
          FETCH Lc_GetEnlaceXInterfaceIni INTO Lr_EnlaceXInterfaceIni;
          IF Lc_GetEnlaceXInterfaceIni%FOUND THEN
            Ln_IdInterfaceElementoFin := Lr_EnlaceXInterfaceIni.INTERFACE_ELEMENTO_FIN_ID;
            OPEN Lc_GetElementoXInterface(Ln_IdInterfaceElementoFin);
            FETCH Lc_GetElementoXInterface INTO Lr_ElementoXInterface;
            IF Lc_GetElementoXInterface%FOUND THEN
              Lv_TieneAlgunEquipoEnlazado := 'SI';
              IF Lv_EsTipoEquipoParam = 'SI' THEN
                IF Pv_ProcesoEjecutante IS NOT NULL THEN
                  Lv_ModelosEquipos := Lv_ModelosEquipos || '_' || Pv_ProcesoEjecutante;
                END IF;
                Lr_ParametroDetalleBusqueda.VALOR1 := Lv_ModelosEquipos;
                Lr_ParametroDetalleBusqueda.VALOR2 := Lv_MarcaElementoSt;
                Lr_ParametroDetalleBusqueda.VALOR3 := Lv_ModeloElementoSt;
                Lr_ParametroDetalleBusqueda.VALOR4 := Pv_TipoEquipoABuscar;
                Lr_ParametroDetalleBusqueda.VALOR5 := Lr_ElementoXInterface.NOMBRE_MODELO_ELEMENTO;
                Lrf_BusquedaEquipodb               := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
                FETCH Lrf_BusquedaEquipodb INTO Lr_RespuestaBusqEquipodb;
                IF Lr_RespuestaBusqEquipodb.ID_PARAMETRO_DET IS NOT NULL THEN
                  Lv_Status               := 'OK';
                  Lv_ContinuaVerificacion := 'NO';
                  Lv_InfoEquipoEncontrado := Lr_ElementoXInterface.ID_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_TIPO_ELEMENTO || ',' 
                                             || Lr_ElementoXInterface.NOMBRE_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_MODELO_ELEMENTO || ',' 
                                             || Lr_ElementoXInterface.ID_INTERFACE_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_INTERFACE_ELEMENTO;
                ELSE
                  Lv_ContinuaVerificacion := 'SI';
                END IF;
              ELSIF Lr_ElementoXInterface.NOMBRE_TIPO_ELEMENTO = Pv_TipoEquipoABuscar 
                AND Lr_ElementoXInterface.NOMBRE_MODELO_ELEMENTO = Pv_ModeloEquipoABuscar THEN
                Lv_Status               := 'OK';
                Lv_ContinuaVerificacion := 'NO';
                Lv_InfoEquipoEncontrado := Lr_ElementoXInterface.ID_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_TIPO_ELEMENTO || ',' 
                                           || Lr_ElementoXInterface.NOMBRE_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_MODELO_ELEMENTO || ',' 
                                           || Lr_ElementoXInterface.ID_INTERFACE_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_INTERFACE_ELEMENTO;
              ELSE
                Lv_ContinuaVerificacion := 'SI';
              END IF;
              IF Lcl_TrazaElementos IS NULL THEN
                Lcl_TrazaElementos := Lr_ElementoXInterface.ID_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_TIPO_ELEMENTO || ',' 
                                      || Lr_ElementoXInterface.NOMBRE_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_MODELO_ELEMENTO || ',' 
                                      || Lr_ElementoXInterface.NOMBRE_INTERFACE_ELEMENTO;
              ELSE
                Lcl_TrazaElementos := Lcl_TrazaElementos || ';' || Lr_ElementoXInterface.ID_ELEMENTO || ',' 
                                      || Lr_ElementoXInterface.NOMBRE_TIPO_ELEMENTO || ',' 
                                      || Lr_ElementoXInterface.NOMBRE_ELEMENTO || ',' || Lr_ElementoXInterface.NOMBRE_MODELO_ELEMENTO || ',' 
                                      || Lr_ElementoXInterface.NOMBRE_INTERFACE_ELEMENTO;
              END IF;
              Ln_IdInterfaceElementoIni := Ln_IdInterfaceElementoFin;
            ELSE
              Lv_MsjError := 'Ha ocurrido un error al obtener la información del elemento asociado a la INTERFACE FINAL CON ID '
                             || Ln_IdInterfaceElementoIni;
              RAISE Le_Exception;
            END IF;
            CLOSE Lc_GetElementoXInterface;
            IF Ln_ContadorEnlaces      > 20 THEN
              Lv_Status               := 'ERROR';
              Lv_MsjError             := 'No se ha podido obtener el equipo, posiblemente error en la data de los enlaces';
              Lv_ContinuaVerificacion := 'NO';
            END IF;
          ELSE
            Lv_MsjError := 'Ha ocurrido un error al obtener la información del enlace asociado a la INTERFACE INICIAL CON ID '
                           || Ln_IdInterfaceElementoIni;
            RAISE Le_Exception;
          END IF;
          CLOSE Lc_GetEnlaceXInterfaceIni;
        END IF;
        EXIT
      WHEN Lv_ContinuaVerificacion = 'NO';
      END LOOP;
    ELSE
      Lv_Status := 'OK';
    END IF;
    Pv_Status                   := Lv_Status;
    Pv_MsjError                 := Lv_MsjError;
    Pv_TieneAlgunEquipoEnlazado := Lv_TieneAlgunEquipoEnlazado;
    Pv_InfoEquipoEncontrado     := Lv_InfoEquipoEncontrado;
    Pcl_TrazaElementos          := Lcl_TrazaElementos;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status                   := 'ERROR';
    IF Lv_ConsultarASistemas = 'SI' THEN
      Pv_MsjError := Lv_MsjError || '. Por favor consultar con el Dep. de Sistemas!';
    ELSE
      Pv_MsjError := Lv_MsjError;
    END IF;
    Pv_TieneAlgunEquipoEnlazado := Lv_TieneAlgunEquipoEnlazado;
    Pv_InfoEquipoEncontrado     := Lv_InfoEquipoEncontrado;
    Pcl_TrazaElementos          := Lcl_TrazaElementos;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_VERIFICA_EQUIPO_ENLAZADO', 
                                          'No se ha podido verificar el equipo enlazado - ' || Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status                   := 'ERROR';
    Lv_MsjError                 := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '
                                    || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_MsjError                 := 'Ha ocurrido un error al verificar el equipo enlazado. Por favor consultar con el Dep. de Sistemas!';
    Pv_TieneAlgunEquipoEnlazado := Lv_TieneAlgunEquipoEnlazado;
    Pv_InfoEquipoEncontrado     := Lv_InfoEquipoEncontrado;
    Pcl_TrazaElementos          := Lcl_TrazaElementos;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_VERIFICA_EQUIPO_ENLAZADO',
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_VERIFICA_EQUIPO_ENLAZADO;

PROCEDURE P_WS_GET_CONSULTA_SUBSCRIBER(Pv_Login    IN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                        Prf_Result  OUT Lrf_Result,
                                        Pv_Status   OUT VARCHAR2,
                                        Pv_Mensaje  OUT VARCHAR2)
                                
  IS
    
    Lv_Query           VARCHAR2(7000)  := '';
    Lv_Select          VARCHAR2(1000)  := '';
    Lv_From            VARCHAR2(1000)  := '';
    Lv_WhereAndJoin    VARCHAR2(7000)  := '';
    Lv_Union           VARCHAR2(1000)  := '';
    Lv_SelectA         VARCHAR2(1000)  := '';
    Lv_FromA           VARCHAR2(1000)  := '';
    Lv_WhereAndJoinA   VARCHAR2(7000)  := '';
  
  BEGIN
  
    Lv_Select   := ' 
                    SELECT    ISPC.VALOR, ISPC.ESTADO,
                    (CASE WHEN ISER.PRODUCTO_ID IS NOT NULL AND ISER.PLAN_ID IS NULL THEN''ADICIONAL''
                    END)TIPO ';
                       
                       
    Lv_From     := '  
                 FROM DB_COMERCIAL.INFO_PERSONA IP  ';               
                       
    Lv_WhereAndJoin := ' 
                 JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IP.ID_PERSONA = IPER.PERSONA_ID
                 JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
                 JOIN DB_COMERCIAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
                 JOIN DB_COMERCIAL.ADMI_TIPO_ROL ATR ON ATR.ID_TIPO_ROL = AR.TIPO_ROL_ID
                 JOIN DB_COMERCIAL.INFO_PUNTO IPUN ON IPUN.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                 JOIN DB_COMERCIAL.INFO_SERVICIO ISER ON ISER.PUNTO_ID = IPUN.ID_PUNTO
                 JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC ON ISPC.SERVICIO_ID = ISER.ID_SERVICIO
                 JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISPC.PRODUCTO_CARACTERISITICA_ID
                 JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
                WHERE ISER.PRODUCTO_ID = (SELECT ID_PRODUCTO FROM DB_COMERCIAL.ADMI_PRODUCTO WHERE DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO=''I. PROTEGIDO MULTI PAID'')
                 AND AC.DESCRIPCION_CARACTERISTICA=''SUSCRIBER_ID''
                 AND ATR.DESCRIPCION_TIPO_ROL       = ''Cliente''
                 AND IER.EMPRESA_COD                = ''18''
                 AND IPUN.LOGIN                     = '''||Pv_Login||''' ';
                 
    Lv_Union := ' UNION ';
    
    Lv_SelectA := '
                   SELECT   ISPC.VALOR, ISPC.ESTADO,
                     (CASE WHEN IPD.PRODUCTO_ID IS NOT NULL AND IPD.PLAN_ID IS NOT NULL THEN ''PLAN''
                   END)TIPO ';
              
    Lv_FromA := '
                   FROM DB_COMERCIAL.INFO_PERSONA IP ';
              
    Lv_WhereAndJoinA := '   
                   JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IP.ID_PERSONA = IPER.PERSONA_ID
                   JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
                   JOIN DB_COMERCIAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
                   JOIN DB_COMERCIAL.ADMI_TIPO_ROL ATR ON ATR.ID_TIPO_ROL = AR.TIPO_ROL_ID
                   JOIN DB_COMERCIAL.INFO_PUNTO IPUN ON IPUN.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                   JOIN DB_COMERCIAL.INFO_SERVICIO ISER ON ISER.PUNTO_ID = IPUN.ID_PUNTO
                   JOIN DB_COMERCIAL.INFO_PLAN_CAB IPC ON IPC.ID_PLAN = ISER.PLAN_ID
                   JOIN DB_COMERCIAL.INFO_PLAN_DET IPD ON IPD.PLAN_ID = IPC.ID_PLAN
                   JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC ON ISPC.SERVICIO_ID = ISER.ID_SERVICIO
                   JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISPC.PRODUCTO_CARACTERISITICA_ID
                   JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
                    WHERE IPD.PRODUCTO_ID = (SELECT APCI.PRODUCTO_ID FROM DB_COMERCIAL.ADMI_CARACTERISTICA A 
                    JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APCI ON APCI.CARACTERISTICA_ID = A.ID_CARACTERISTICA 
                    JOIN DB_COMERCIAL.ADMI_PRODUCTO APT ON APT.ID_PRODUCTO = APCI.PRODUCTO_ID 
                    WHERE A.DESCRIPCION_CARACTERISTICA = ''MIGRADO_A_KASPERSKY'' AND APT.ESTADO = ''Activo'')
                   AND AC.DESCRIPCION_CARACTERISTICA=''SUSCRIBER_ID''
                   AND IER.EMPRESA_COD = ''18''
                   AND ATR.DESCRIPCION_TIPO_ROL=''Cliente''
                   AND IPUN.LOGIN='''||Pv_Login||''' ';
  
    Lv_Query := Lv_Select|| Lv_From|| Lv_WhereAndJoin|| Lv_Union|| Lv_SelectA || Lv_FromA|| Lv_WhereAndJoinA;
  
    OPEN Prf_Result FOR Lv_Query;
  
    Pv_Status   := 'OK';
    Pv_Mensaje := 'OK';
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_WS_GET_CONSULTA_SUBSCRIBER',
                                          'Error al obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  
  END P_WS_GET_CONSULTA_SUBSCRIBER;


PROCEDURE P_WS_PUT_SUBSCRIBER(Pn_ID_SUBSCRIBER  IN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                              Pv_Origen_Act     IN  VARCHAR2,
                              Pv_User           IN  VARCHAR2,
                              Pv_Status         OUT VARCHAR2,
                              Pv_Mensaje        OUT VARCHAR2)
        
                                
                             IS
    
    
                            CURSOR C_SERVICIO_CARACTERISTICA(Cv_IdSuscriber VARCHAR2)
                            IS
                          SELECT ISPC.ID_SERVICIO_PROD_CARACT,
                                ISPC.SERVICIO_ID ,
                                ISPC.ESTADO,
                                ISPC.PRODUCTO_CARACTERISITICA_ID
                              FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
                              JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
                              ON APC.ID_PRODUCTO_CARACTERISITICA = ISPC.PRODUCTO_CARACTERISITICA_ID
                              JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
                              ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
                              JOIN DB_COMERCIAL.INFO_SERVICIO ISER
                              ON ISER.ID_SERVICIO = ISPC.SERVICIO_ID 
                              WHERE APC.PRODUCTO_ID   =
                                (SELECT ADMI_PRODUCTO.ID_PRODUCTO
                                FROM ADMI_PRODUCTO
                                WHERE ADMI_PRODUCTO.DESCRIPCION_PRODUCTO='I. PROTEGIDO MULTI PAID'
                                )
                            AND ac.DESCRIPCION_CARACTERISTICA = 'SUSCRIBER_ID'
                            AND ISER.ESTADO = 'Activo'
                            AND ISPC.ESTADO = 'Pendiente'
                            AND ISPC.VALOR                    = Cv_IdSuscriber;
                            
        
           
                            CURSOR C_CORREO_ELECTRONICO
                            IS
                              SELECT APD.VALOR1,
                                APD.VALOR2
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                              JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
                              ON APC.ID_PARAMETRO       = APD.PARAMETRO_ID
                              WHERE APC.NOMBRE_PARAMETRO='CORREO_SUBSCRIBER'
                              AND APC.ESTADO            ='Activo'
                              AND APD.ESTADO            ='Activo';
                                  
                            CURSOR C_ORIGEN_APROVISIONAMIENTO
                            IS
                              SELECT APC.ID_PRODUCTO_CARACTERISITICA
                              FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
                              JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
                              ON APC.CARACTERISTICA_ID         = AC.ID_CARACTERISTICA
                              WHERE DESCRIPCION_CARACTERISTICA = 'ORIGEN APROVISIONAMIENTO KASPERSKY';
                              
                            CURSOR C_ORIGEN_ACTIVACION
                            IS
                              SELECT APC.ID_PRODUCTO_CARACTERISITICA
                              FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
                              JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
                              ON APC.CARACTERISTICA_ID         = AC.ID_CARACTERISTICA
                              WHERE DESCRIPCION_CARACTERISTICA = 'ORIGEN ACTIVACION KASPERSKY';
           
          Lv_User                    VARCHAR2(20);
          Lr_ServicioCaracteristica  C_SERVICIO_CARACTERISTICA%ROWTYPE;
          Lr_infoCorreos             C_CORREO_ELECTRONICO%ROWTYPE;
          Ln_IdServicioHistorial     DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE;
          Ln_IdServicioProCart       DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT%TYPE;
          Ln_IdCaracteristicaAprov   C_ORIGEN_APROVISIONAMIENTO%ROWTYPE;
          Ln_IdCaracteristicaAct     C_ORIGEN_ACTIVACION%ROWTYPE;
          Ln_IdCaracteristica        NUMBER;          
          Lv_Asunto                  VARCHAR2(300):= 'Notificacion de sistema';
          Lv_MensajeError            VARCHAR2(2000);
          Le_Errors                  EXCEPTION;
          
          
         
   
  BEGIN  
          
          
         IF C_SERVICIO_CARACTERISTICA%ISOPEN THEN CLOSE C_SERVICIO_CARACTERISTICA; END IF;
         OPEN C_SERVICIO_CARACTERISTICA(Pn_ID_SUBSCRIBER);
         FETCH C_SERVICIO_CARACTERISTICA INTO Lr_ServicioCaracteristica;
        
           IF C_SERVICIO_CARACTERISTICA%FOUND THEN
           
              IF Lr_ServicioCaracteristica.ESTADO = 'Pendiente' THEN
                 UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT 
                  SET ESTADO='Activo' 
                 WHERE ID_SERVICIO_PROD_CARACT = Lr_ServicioCaracteristica.ID_SERVICIO_PROD_CARACT;
                                             
                 
                 UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SET ESTADO = 'Activo' WHERE
                 ID_SERVICIO_PROD_CARACT = (SELECT
                            ispc.ID_SERVICIO_PROD_CARACT
                        FROM
                            db_comercial.info_servicio                  s,
                            db_comercial.info_servicio_prod_caract      ispc,
                            db_comercial.admi_producto_caracteristica   apc,
                            db_comercial.admi_caracteristica            ac
                        WHERE
                            s.id_servicio = ispc.servicio_id
                            AND ispc.producto_caracterisitica_id = apc.id_producto_caracterisitica
                            AND apc.caracteristica_id = ac.id_caracteristica
                            AND ac.descripcion_caracteristica = 'SUSCRIBER_ID'
                            AND ispc.valor = ''||Pn_ID_SUBSCRIBER||''
                            AND ispc.estado = 'Pendiente');                
                
                 Ln_IdServicioHistorial := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                INSERT
                 INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                 (
                  ID_SERVICIO_HISTORIAL,
                  SERVICIO_ID,
                  USR_CREACION,
                  FE_CREACION,
                  IP_CREACION,
                  ESTADO,
                  MOTIVO_ID,
                  OBSERVACION,
                  ACCION
                 )
                 VALUES
                 (
                  Ln_IdServicioHistorial,
                  Lr_ServicioCaracteristica.SERVICIO_ID,
                  Pv_User,
                  SYSDATE,
                  '00.00.0.0',
                  (SELECT ESTADO FROM DB_COMERCIAL.INFO_SERVICIO WHERE ID_SERVICIO = Lr_ServicioCaracteristica.SERVICIO_ID),
                  NULL,
                  'Cliente activa licencia IPMP via GMS',
                  NULL 
                 );
                 -- PROD CARACT

                IF C_ORIGEN_ACTIVACION%ISOPEN THEN CLOSE C_ORIGEN_ACTIVACION; END IF;
                OPEN C_ORIGEN_ACTIVACION;
                FETCH C_ORIGEN_ACTIVACION INTO Ln_IdCaracteristicaAct;
                
                Ln_IdCaracteristica := DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL;
               
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
                  Ln_IdCaracteristica,
                  Lr_ServicioCaracteristica.SERVICIO_ID,
                  Ln_IdCaracteristicaAct.ID_PRODUCTO_CARACTERISITICA,
                  (SELECT NVL(ORIGEN,'WEB') FROM DB_COMERCIAL.INFO_SERVICIO WHERE ID_SERVICIO =  Lr_ServicioCaracteristica.SERVICIO_ID),
                  SYSDATE,
                  null,
                  Pv_User,
                  null,
                  'Activo',
                  Lr_ServicioCaracteristica.PRODUCTO_CARACTERISITICA_ID 
                 );
                 
                 -- CREACION DE CARACTERISTICA DE APROVISIONAMIENTO
                 
                 IF C_ORIGEN_APROVISIONAMIENTO%ISOPEN THEN CLOSE C_ORIGEN_APROVISIONAMIENTO; END IF;
                OPEN C_ORIGEN_APROVISIONAMIENTO;
                FETCH C_ORIGEN_APROVISIONAMIENTO INTO Ln_IdCaracteristicaAprov;
                
                Ln_IdCaracteristica := DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL;
               
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
                  Ln_IdCaracteristica,
                  Lr_ServicioCaracteristica.SERVICIO_ID,
                  Ln_IdCaracteristicaAprov.ID_PRODUCTO_CARACTERISITICA,
                  Pv_Origen_Act,
                  SYSDATE,
                  SYSDATE,
                  Pv_User,
                  Pv_User,
                  'Activo',
                  Lr_ServicioCaracteristica.PRODUCTO_CARACTERISITICA_ID 
                 );
            
                 
              ELSIF Lr_ServicioCaracteristica.ESTADO = 'Activo' THEN
                 Lv_MensajeError := 'El SuscriberId ya se encuentra en estado Activo';
                 RAISE Le_Errors;

              ELSE
                 Lv_MensajeError := 'No es posible realizar la activación del SubscriberId se encuentra en estado: '||Lr_ServicioCaracteristica.ESTADO;
                 RAISE Le_Errors; 
              
             END IF;
           
          
           ELSE
                IF C_CORREO_ELECTRONICO%ISOPEN THEN CLOSE C_CORREO_ELECTRONICO; END IF;
                OPEN C_CORREO_ELECTRONICO;
                FETCH C_CORREO_ELECTRONICO INTO Lr_infoCorreos;
           
                    IF C_CORREO_ELECTRONICO%FOUND THEN
                
                        UTL_MAIL.SEND(
                           SENDER       => Lr_infoCorreos.VALOR1,
                           RECIPIENTS   => Lr_infoCorreos.VALOR2,
                           SUBJECT      => Lv_Asunto,
                           MESSAGE      => 
                        '<html>
                             <head>
                               <meta meta http-equiv=”Content-Type” content=”text/html; charset=UTF-8" /> 
                               <meta content="width=device-width, initial-scale=1" name="viewport"> 
                               <meta name="x-apple-disable-message-reformatting"> 
                               <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
                               <meta content="telephone=no" name="format-detection"> 
                             </head>

                               <body style="background-color: #F8F9FD;" >
                                 <div>
                                    <h2 style="text-align: center;">Estimado usuario</h2> 
                                     <p style="text-align: center;">
                                         Se informa que no se pudo realizar la activacion del servicio del cliente relacionado al
                                         suscriber ID <br>'||Pn_ID_SUBSCRIBER||'
                                     </p>
                                 </div>
                               </body>
                           </html>' ,  
                           MIME_TYPE    => 'text/html; charset=UTF-8'
                        );
                        
                         
                         
                    END IF; 
                   
                 CLOSE C_CORREO_ELECTRONICO;
                 Lv_MensajeError := 'No se encontró SubscriberId';
                 RAISE Le_Errors;
               
             END IF;
        
          CLOSE C_SERVICIO_CARACTERISTICA;

        
        commit;
            
    Pv_Status   := 'OK';
    Pv_Mensaje := 'OK';
    
  EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := Lv_MensajeError;
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_WS_PUT_SUBSCRIBER',
                                          'Error No se pudo cambiar el estado del suscriberId - ' || SQLCODE || ' - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  
  END  P_WS_PUT_SUBSCRIBER;

  FUNCTION F_GET_ULT_SERV_ADIC_X_PUNTO( 
    Fn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_NombreTecnicoProd    IN DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    Fv_EstadoServicio       IN VARCHAR2,
    Fv_ProcesoEjecutante    IN VARCHAR2)
  RETURN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  IS
    Ln_IdServicio               DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Lv_Query                    VARCHAR2(4000);
    Ln_Rownum                   NUMBER(10) := 1;
    Lv_NombreParam              VARCHAR2(38):= 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_Valor1EstadosServicios   VARCHAR2(50) := 'ESTADOS_SERVICIOS_PROD_ADICIONALES_A_CONSIDERAR';
    Lv_Valor2TipoBusqServicios  VARCHAR2(30) := 'BUSQUEDA_POR_NOMBRE_TECNICO';
    Lv_Valor3ProcesoServicios   VARCHAR2(21) := 'CAMBIO_PLAN_MASIVO';
    Lv_EstadoActivo             VARCHAR2(6) := 'Activo';
  BEGIN
    IF Fn_IdPunto IS NOT NULL AND Fv_NombreTecnicoProd IS NOT NULL THEN
      IF Fv_EstadoServicio IS NOT NULL THEN
        Lv_Query  := 'SELECT ID_SERVICIO
                      FROM (SELECT SERVICIO.ID_SERVICIO
                            FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
                            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
                            ON PROD.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                            WHERE SERVICIO.PUNTO_ID = :paramIdPunto 
                            AND PROD.NOMBRE_TECNICO = :paramNombreTecnicoProd
                            AND SERVICIO.ESTADO = :paramEstadoServicio 
                            ORDER BY SERVICIO.ID_SERVICIO DESC)
                      WHERE ROWNUM = :paramRownum ';
        EXECUTE IMMEDIATE Lv_Query INTO Ln_IdServicio USING Fn_IdPunto, Fv_NombreTecnicoProd, Fv_EstadoServicio, Ln_Rownum;
      ELSIF Fv_ProcesoEjecutante IS NOT NULL THEN
        Lv_Query  := 'SELECT ID_SERVICIO
                      FROM (SELECT SERVICIO.ID_SERVICIO
                            FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
                            INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
                            ON PROD.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                            WHERE SERVICIO.PUNTO_ID = :paramIdPunto 
                            AND PROD.NOMBRE_TECNICO = :paramNombreTecnicoProd
                            AND SERVICIO.ESTADO IN (
                                                    SELECT PARAM_DET.VALOR5
                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                    ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                    WHERE PARAM_CAB.NOMBRE_PARAMETRO = :paramNombreParam
                                                    AND PARAM_CAB.ESTADO = :paramEstadoActivo1
                                                    AND PARAM_DET.VALOR1 = :paramValor1EstadosServicios
                                                    AND PARAM_DET.VALOR2 = :paramValor2TipoBusqServicios
                                                    AND PARAM_DET.VALOR3 = :paramValor3ProcesoServicios
                                                    AND PARAM_DET.VALOR4 = PROD.NOMBRE_TECNICO
                                                    AND PARAM_DET.ESTADO = :paramEstadoActivo2
                                                   )
                            ORDER BY SERVICIO.ID_SERVICIO DESC)
                      WHERE ROWNUM = :paramRownum ';
        EXECUTE IMMEDIATE Lv_Query INTO Ln_IdServicio USING Fn_IdPunto, Fv_NombreTecnicoProd, Lv_NombreParam,  Lv_EstadoActivo, 
                                                            Lv_Valor1EstadosServicios, Lv_Valor2TipoBusqServicios, 
                                                            Lv_Valor3ProcesoServicios, Lv_EstadoActivo, Ln_Rownum;
      END IF;
    ELSE
      Ln_IdServicio := NULL;
    END IF;
    RETURN Ln_IdServicio;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                            'TECNK_SERVICIOS.F_GET_ULT_SERV_ADIC_X_PUNTO', 
                                            'Error al intentar obtener el último servicio adicional por punto ' || Fn_IdPunto || ' , nombre técnico ' 
                                            || Fv_NombreTecnicoProd
                                            || ' , estado servicio: ' || Fv_EstadoServicio || ' , proceso ejecutante: ' || Fv_ProcesoEjecutante 
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  END F_GET_ULT_SERV_ADIC_X_PUNTO;

  PROCEDURE P_GET_REGISTRO_SPC(
    Pn_IdSpc                      IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT%TYPE,
    Pn_IdServicio                 IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Pv_DescripcionCaracteristica  IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_ValorSpc                   IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    Pv_EstadoSpc                  IN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO%TYPE,
    Pv_OrdenarDescPorIdSpc        IN VARCHAR2,
    Pv_Status                     OUT VARCHAR2,
    Pv_MsjError                   OUT VARCHAR2,
    Pr_RegistroSpc                OUT DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE)
  IS
    Lcl_Query       CLOB;
    Ln_Rownum       NUMBER := 1;
    Lrf_Spc         SYS_REFCURSOR;
    Lr_Spc          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lv_EstadoSpc    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ESTADO%TYPE;
    Lv_EstadoActivo VARCHAR2(6) := 'Activo';
  BEGIN
    Lr_Spc := NULL;
    IF Pv_EstadoSpc IS NOT NULL THEN
      Lv_EstadoSpc := Pv_EstadoSpc;
    ELSE
      Lv_EstadoSpc := 'Activo';
    END IF;  
    
    Lcl_Query := 'SELECT SPC.*
                  FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
                  INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC
                  ON SPC.SERVICIO_ID = SERVICIO.ID_SERVICIO
                  INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
                  ON APC.ID_PRODUCTO_CARACTERISITICA =  SPC.PRODUCTO_CARACTERISITICA_ID
                  INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
                  ON PROD.ID_PRODUCTO = APC.PRODUCTO_ID
                  INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
                  ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
                  WHERE SERVICIO.ID_SERVICIO = ' || Pn_IdServicio || '  
                  AND SPC.ESTADO = ''' || Lv_EstadoSpc || ''' 
                  AND APC.ESTADO = ''' || Lv_EstadoActivo || ''' 
                  AND CARACT.DESCRIPCION_CARACTERISTICA = ''' || Pv_DescripcionCaracteristica || ''' 
                  AND CARACT.ESTADO = ''' || Lv_EstadoActivo || ''' ';

    IF Pv_ValorSpc IS NOT NULL THEN 
      Lcl_Query := ' AND SPC.VALOR = ' || Pv_ValorSpc;
    END IF;

    IF Pn_IdSpc IS NOT NULL THEN 
      Lcl_Query := ' AND SPC.ID_SERVICIO_PROD_CARACT = ' || Pn_IdSpc;
    END IF;

    IF Pv_OrdenarDescPorIdSpc IS NOT NULL AND Pv_OrdenarDescPorIdSpc = 'SI' THEN 
      Lcl_Query := 'SELECT *
                    FROM (' || Lcl_Query || '
                              ORDER BY SPC.ID_SERVICIO_PROD_CARACT DESC
                         )
                    WHERE ROWNUM = ' || Ln_Rownum || '
                    ' ;
      OPEN Lrf_Spc FOR Lcl_Query;
    ELSE
      Lcl_Query := Lcl_Query || ' AND ROWNUM = ' || Ln_Rownum;
      OPEN Lrf_Spc FOR Lcl_Query;
    END IF;
    FETCH Lrf_Spc INTO Pr_RegistroSpc;
    CLOSE Lrf_Spc;
    
    Pv_Status     := 'OK';
    Pv_MsjError   := '';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status   := 'ERROR';
    Pv_MsjError := 'No se ha podido obtener el registro de la característica asociada al servicio';
  END P_GET_REGISTRO_SPC;


  PROCEDURE P_ROLLBACK_TRASLADO_SERVICIO(Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2) IS
  
    
     Ln_IdPuntoDestino            NUMBER;
     Ln_IdPuntoOrigen             NUMBER;
     Lv_UsrCreacion               NUMBER;
     Ln_Cantidad                  NUMBER:=0;
     Ln_Contador                  NUMBER:=0;
     Ln_Contador_1                NUMBER:=1;
     Lv_IpCreacion                VARCHAR2(15);
     Lv_Mensaje                   VARCHAR2(1000);
     Le_Errors                    EXCEPTION;
     
     Ln_ListadoServicios          apex_t_varchar2;
     
     CURSOR C_LIST_SERVICIOS_PT_DESTINO(Cn_IdPuntoDestino NUMBER) IS
        SELECT ISER.ID_SERVICIO FROM DB_COMERCIAL.INFO_SERVICIO ISER WHERE ISER.PUNTO_ID=Cn_IdPuntoDestino;
        
     CURSOR C_EXISTE_DETALLE_SOLICITUD(Cn_IdServicio NUMBER)IS
        SELECT COUNT(*) Cantidad
          FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
         WHERE IDS.SERVICIO_ID = Cn_IdServicio;

   BEGIN


      APEX_JSON.PARSE(Pcl_Request);
        Ln_ListadoServicios          := APEX_JSON.find_paths_like(p_return_path => 'listadoServicios[%]' );
        Ln_IdPuntoDestino            := APEX_JSON.get_number(p_path => 'intIdPuntoCliente');
        Ln_IdPuntoOrigen             := APEX_JSON.get_number(p_path => 'intIdPuntoOrigen');
        Lv_IpCreacion                := APEX_JSON.get_varchar2(p_path => 'strIpCreacion');
        Lv_UsrCreacion               := APEX_JSON.get_varchar2(p_path => 'strUsuarioCreacion');
      
      
      ----------- INFO PUNTO ORIGEN -----------
      
         Ln_Contador:=Ln_ListadoServicios.COUNT;
         IF Ln_Contador > 0 THEN
         
           WHILE Ln_Contador_1 <= Ln_Contador LOOP
           
              UPDATE DB_COMERCIAL.INFO_SERVICIO ISER 
               SET ISER.ESTADO='Activo' 
              WHERE ISER.PUNTO_ID=Ln_IdPuntoOrigen AND ISER.ID_SERVICIO=(apex_json.get_number(p_path => Ln_ListadoServicios(Ln_Contador_1)));
              
              Ln_Contador_1 := Ln_Contador_1+1;
           
           END LOOP;
         
         END IF;
         

      ----------- INFO PUNTO DESTINO -----------
        UPDATE DB_COMERCIAL.INFO_SERVICIO ISER 
          SET ISER.ESTADO='Rechazada' 
         WHERE ISER.PUNTO_ID=Ln_IdPuntoDestino;
        
        UPDATE DB_COMERCIAL.INFO_ORDEN_TRABAJO IOT 
          SET IOT.ESTADO='Rechazada' 
         WHERE IOT.PUNTO_ID = Ln_IdPuntoDestino;
         
        
        FOR Ln_IdServicios IN C_LIST_SERVICIOS_PT_DESTINO(Ln_IdPuntoDestino)
        LOOP
        
              UPDATE DB_COMERCIAL.INFO_SERVICIO_TECNICO IST 
               SET IST.ELEMENTO_ID=NULL,IST.INTERFACE_ELEMENTO_ID=NULL,IST.ULTIMA_MILLA_ID=NULL,
               IST.ELEMENTO_CONTENEDOR_ID=NULL,IST.ELEMENTO_CONECTOR_ID=NULL,IST.INTERFACE_ELEMENTO_CONECTOR_ID=NULL,
               ELEMENTO_CLIENTE_ID= NULL ,INTERFACE_ELEMENTO_CLIENTE_ID=NULL
              WHERE IST.SERVICIO_ID = Ln_IdServicios.ID_SERVICIO;
              
              
              UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC 
                SET ISPC.ESTADO='Rechazada' 
               WHERE ISPC.SERVICIO_ID=Ln_IdServicios.ID_SERVICIO;
              
              INSERT 
                INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                (
                   ID_SERVICIO_HISTORIAL,
                   SERVICIO_ID,
                   USR_CREACION,
                   FE_CREACION,
                   IP_CREACION,
                   ESTADO,
                   MOTIVO_ID,
                   OBSERVACION,
                   ACCION
                )
                VALUES
                (
                   DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                   Ln_IdServicios.ID_SERVICIO,
                   Lv_UsrCreacion,
                   SYSDATE,
                   Lv_IpCreacion,
                   'Rechazada',
                   NULL,
                   'Rechazada por proceso de rollback del ws de extranet',
                   NULL
                );
                
                
                 IF C_EXISTE_DETALLE_SOLICITUD%ISOPEN THEN
                  CLOSE C_EXISTE_DETALLE_SOLICITUD;
                 END IF;
                 
                 OPEN C_EXISTE_DETALLE_SOLICITUD(Ln_IdServicios.ID_SERVICIO);
                 FETCH C_EXISTE_DETALLE_SOLICITUD INTO Ln_Cantidad;
                
                
                  IF(Ln_Cantidad>0) THEN
                
                      UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD  IDS 
                       SET IDS.ESTADO='Rechazada'
                      WHERE IDS.SERVICIO_ID = Ln_IdServicios.ID_SERVICIO;
                   
                      INSERT 
                       INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                       (
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
                       ) 
                       VALUES 
                       (
                        DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                        (SELECT ID_DETALLE_SOLICITUD FROM INFO_DETALLE_SOLICITUD WHERE SERVICIO_ID=1704446),
                        'Rechazada',
                        NULL,
                        NULL,
                        'Rechazada por proceso de rollback del ws de extranet',
                        Lv_UsrCreacion,
                        SYSDATE,
                        Lv_IpCreacion,
                        NULL
                       );
                   
                
                  END IF;
                
                 CLOSE C_EXISTE_DETALLE_SOLICITUD;
              
              
        END LOOP;
        
        Pv_Status   := 'OK';
        Pv_Mensaje  := 'Se realizó el proceso de rollback exitosamente';
        
        COMMIT;

  
  EXCEPTION
    WHEN Le_Errors THEN
       Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_ROLLBACK_TRASLADO_SERVICIO',
                                          'Error al realizar el proceso de rollback'
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  
  END P_ROLLBACK_TRASLADO_SERVICIO;

  FUNCTION F_GET_ID_DET_SOL_CARACT_VALIDA(
    Fn_IdSolicitud              IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    Fn_IdServicio               IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fv_CampoBusqueda            IN VARCHAR2,
    Fv_DescripcionCaract        IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Fv_ValorDetSolCaract        IN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.VALOR%TYPE)
  RETURN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE
  IS
    Lv_ValorParamAsocServiciosMd    VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_ValorEstadosSolAbiertas      VARCHAR2(29) := 'ESTADOS_SOLICITUDES_ABIERTAS';
    CURSOR Lc_GetDetSolCaract(  Cn_IdSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Cv_ValorDetSolCaract DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.VALOR%TYPE)
    IS
      SELECT DISTINCT DET_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOLICITUD
      ON TIPO_SOLICITUD.ID_TIPO_SOLICITUD = SOLICITUD.TIPO_SOLICITUD_ID
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DET_SOL_CARACT
      ON DET_SOL_CARACT.DETALLE_SOLICITUD_ID = SOLICITUD.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
      ON DET_SOL_CARACT.CARACTERISTICA_ID = CARACT.ID_CARACTERISTICA
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_SOL_ABIERTAS
      ON PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR2 = TIPO_SOLICITUD.DESCRIPCION_SOLICITUD
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_MD
      ON PARAM_CAB_MD.ID_PARAMETRO = PARAM_DET_ESTADOS_SOL_ABIERTAS.PARAMETRO_ID
      WHERE SOLICITUD.ID_DETALLE_SOLICITUD = Cn_IdSolicitud
      AND TIPO_SOLICITUD.ESTADO = Lv_EstadoActivo
      AND CARACT.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
      AND DET_SOL_CARACT.VALOR = Cv_ValorDetSolCaract
      AND CARACT.ESTADO = Lv_EstadoActivo
      AND PARAM_CAB_MD.NOMBRE_PARAMETRO = Lv_ValorParamAsocServiciosMd
      AND PARAM_CAB_MD.ESTADO = Lv_EstadoActivo 
      AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR2 = TIPO_SOLICITUD.DESCRIPCION_SOLICITUD
      AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR1 = Lv_ValorEstadosSolAbiertas
      AND PARAM_DET_ESTADOS_SOL_ABIERTAS.ESTADO = Lv_EstadoActivo
      AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR3 = DET_SOL_CARACT.ESTADO;

    CURSOR Lc_GetDetSolCaractXIdServicio(   Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                            Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                            Cv_ValorDetSolCaract DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.VALOR%TYPE)
    IS
      SELECT DISTINCT DET_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOLICITUD
      ON TIPO_SOLICITUD.ID_TIPO_SOLICITUD = SOLICITUD.TIPO_SOLICITUD_ID
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DET_SOL_CARACT
      ON DET_SOL_CARACT.DETALLE_SOLICITUD_ID = SOLICITUD.ID_DETALLE_SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
      ON DET_SOL_CARACT.CARACTERISTICA_ID = CARACT.ID_CARACTERISTICA
      WHERE SOLICITUD.SERVICIO_ID = Cn_IdServicio
      AND TIPO_SOLICITUD.ESTADO = Lv_EstadoActivo
      AND CARACT.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
      AND DET_SOL_CARACT.VALOR = Cv_ValorDetSolCaract
      AND CARACT.ESTADO = Lv_EstadoActivo
      AND SOLICITUD.ESTADO IN ( SELECT PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR3
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_MD
                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_SOL_ABIERTAS
                                ON PARAM_DET_ESTADOS_SOL_ABIERTAS.PARAMETRO_ID = PARAM_CAB_MD.ID_PARAMETRO 
                                WHERE PARAM_CAB_MD.NOMBRE_PARAMETRO = Lv_ValorParamAsocServiciosMd
                                AND PARAM_CAB_MD.ESTADO = Lv_EstadoActivo 
                                AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR1 = Lv_ValorEstadosSolAbiertas
                                AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR2 = TIPO_SOLICITUD.DESCRIPCION_SOLICITUD
                                AND PARAM_DET_ESTADOS_SOL_ABIERTAS.ESTADO = Lv_EstadoActivo)
      AND DET_SOL_CARACT.ESTADO IN (SELECT PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR3
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_MD
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_SOL_ABIERTAS
                                    ON PARAM_DET_ESTADOS_SOL_ABIERTAS.PARAMETRO_ID = PARAM_CAB_MD.ID_PARAMETRO 
                                    WHERE PARAM_CAB_MD.NOMBRE_PARAMETRO = Lv_ValorParamAsocServiciosMd
                                    AND PARAM_CAB_MD.ESTADO = Lv_EstadoActivo 
                                    AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR1 = Lv_ValorEstadosSolAbiertas
                                    AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR2 = TIPO_SOLICITUD.DESCRIPCION_SOLICITUD
                                    AND PARAM_DET_ESTADOS_SOL_ABIERTAS.ESTADO = Lv_EstadoActivo);

    Ln_IdDetSolCaract DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE;
  BEGIN
    IF Fv_CampoBusqueda = 'ID_SOLICITUD' AND Fn_IdSolicitud IS NOT NULL THEN 
      IF Lc_GetDetSolCaract%ISOPEN THEN
        CLOSE Lc_GetDetSolCaract;
      END IF;
      OPEN Lc_GetDetSolCaract(Fn_IdSolicitud, Fv_DescripcionCaract, Fv_ValorDetSolCaract);
      FETCH
        Lc_GetDetSolCaract
      INTO
        Ln_IdDetSolCaract;
      CLOSE Lc_GetDetSolCaract;
      IF Ln_IdDetSolCaract IS NULL THEN
        Ln_IdDetSolCaract  := NULL;
      END IF;
    ELSIF Fv_CampoBusqueda = 'ID_SERVICIO' AND Fn_IdServicio IS NOT NULL THEN
      IF Lc_GetDetSolCaractXIdServicio%ISOPEN THEN
        CLOSE Lc_GetDetSolCaractXIdServicio;
      END IF;

      OPEN Lc_GetDetSolCaractXIdServicio(Fn_IdServicio, Fv_DescripcionCaract, Fv_ValorDetSolCaract);
      FETCH
        Lc_GetDetSolCaractXIdServicio
      INTO
        Ln_IdDetSolCaract;
      CLOSE Lc_GetDetSolCaractXIdServicio;
      IF Ln_IdDetSolCaract IS NULL THEN
        Ln_IdDetSolCaract  := NULL;
      END IF;
    ELSE
      Ln_IdDetSolCaract  := NULL;
    END IF;
    RETURN Ln_IdDetSolCaract;
  END F_GET_ID_DET_SOL_CARACT_VALIDA;

  PROCEDURE P_GET_INFO_GESTION_SIMULTANEA(
    Pn_IdSolicitud                  IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    Pv_ParamProdGestionSimultanea   IN VARCHAR2,
    Pv_OpcionGestionSimultanea      IN VARCHAR2,
    Pv_Status                       OUT VARCHAR2,
    Pv_MsjError                     OUT VARCHAR2,
    Prf_RegistrosGestionSimultanea  OUT SYS_REFCURSOR)
  IS
    Lv_MsjError                     VARCHAR2(4000);
    Le_Exception                    EXCEPTION;
    Lv_ParamProdGestionSimultanea   VARCHAR2(200);
    Lv_ValorParamAsocServiciosMd    VARCHAR2(36) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_ValorGestionPyl              VARCHAR2(23) := 'GESTION_PYL_SIMULTANEA';
    Lv_ValorServicioGestionado      VARCHAR2(20) := 'SERVICIO_GESTIONADO';
    Lv_ValorServicioSimultaneo      VARCHAR2(36) := 'SERVICIO_GESTIONADO_SIMULTANEAMENTE';
    Lv_NombreTecnicoInternet        VARCHAR2(8) := 'INTERNET';
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_CodEmpresa                   VARCHAR2(2) := '18';
    Lv_ValorEstadosSolAbiertas      VARCHAR2(29) := 'ESTADOS_SOLICITUDES_ABIERTAS';
    Lv_ValorEstadosServiciosIn      VARCHAR2(21) := 'ESTADOS_SERVICIOS_IN';
    Lv_ValorEstadosServiciosNotIn   VARCHAR2(25) := 'ESTADOS_SERVICIOS_NOT_IN';
    Lv_CaractMotivoCreacionSol      VARCHAR2(26) := 'MOTIVO_CREACION_SOLICITUD';
    Lv_ValorMotivoCreacionSol       VARCHAR2(32) := 'CAMBIO ONT POR AGREGAR EXTENDER';
    Lv_CampoBusqueda                VARCHAR2(15) := 'ID_SOLICITUD';
    Lcl_SelectParamsGs              CLOB;
    Lcl_FromJoinParamsGs            CLOB;
    Lcl_WhereParamsGs               CLOB;
    Lcl_QueryParamsGs               CLOB;
    Lcl_QuerySolGestionada          CLOB;
    Lcl_QuerySolsSimultaneas        CLOB;
    Lcl_Query                       CLOB;
  BEGIN
    IF Pn_IdSolicitud IS NULL THEN
      Lv_MsjError   := 'No se ha enviado el parámetro con el ID de la solicitud que el usuario está gestionando para obtener '
                        || 'las que deben gestionarse simultáneamente';
      RAISE Le_Exception;
    END IF;

    IF Pv_ParamProdGestionSimultanea IS NOT NULL THEN 
      Lv_ParamProdGestionSimultanea := Pv_ParamProdGestionSimultanea;
    ELSE
      Lv_ParamProdGestionSimultanea := 'ID_PRODUCTO';
    END IF;

    Lcl_SelectParamsGs      := 'SELECT PARAMS_PYL_SERVICIO_GESTIONADO.VALOR3 AS OPCION_GESTION_SIMULTANEA, 
                                PARAMS_PYL_SERVICIO_GESTIONADO.VALOR6 AS TIPO_SOL_SERVICIO_GESTIONADO,
                                PARAMS_PYL_SERVICIO_SIMULTANEO.VALOR6 AS TIPO_SOL_SERVICIO_SIMULTANEO ';
    Lcl_FromJoinParamsGs    := 'FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAMETRO_MD
                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAMS_PYL_SERVICIO_GESTIONADO
                                ON PARAMS_PYL_SERVICIO_GESTIONADO.PARAMETRO_ID = PARAMETRO_MD.ID_PARAMETRO
                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAMS_PYL_SERVICIO_SIMULTANEO
                                ON PARAMS_PYL_SERVICIO_SIMULTANEO.PARAMETRO_ID = PARAMETRO_MD.ID_PARAMETRO ';
    Lcl_WhereParamsGs       := 'WHERE PARAMETRO_MD.NOMBRE_PARAMETRO = ''' || Lv_ValorParamAsocServiciosMd || '''
                                AND PARAMETRO_MD.ESTADO = ''' || Lv_EstadoActivo || '''
                                AND PARAMS_PYL_SERVICIO_GESTIONADO.VALOR1= ''' || Lv_ValorGestionPyl || '''  
                                AND PARAMS_PYL_SERVICIO_GESTIONADO.VALOR2= ''' || Lv_ValorServicioGestionado || '''
                                AND PARAMS_PYL_SERVICIO_GESTIONADO.ESTADO = ''' || Lv_EstadoActivo || '''
                                AND PARAMS_PYL_SERVICIO_SIMULTANEO.VALOR1= ''' || Lv_ValorGestionPyl || '''
                                AND PARAMS_PYL_SERVICIO_SIMULTANEO.VALOR2= ''' || Lv_ValorServicioSimultaneo || '''
                                AND PARAMS_PYL_SERVICIO_SIMULTANEO.ESTADO = ''' || Lv_EstadoActivo || '''
                                AND PARAMS_PYL_SERVICIO_GESTIONADO.VALOR7 = PARAMS_PYL_SERVICIO_SIMULTANEO.VALOR7 ';

    IF Lv_ParamProdGestionSimultanea IS NOT NULL AND Lv_ParamProdGestionSimultanea = 'ID_PRODUCTO' THEN
      Lcl_SelectParamsGs    := Lcl_SelectParamsGs || 
                               ',PROD_GESTIONADO.ID_PRODUCTO AS ID_PROD_GESTIONADO, PROD_GESTIONADO.DESCRIPCION_PRODUCTO AS DESCRIP_PROD_GESTIONADO, 
                                PROD_SIMULTANEO.ID_PRODUCTO AS ID_PROD_SIMULTANEO, PROD_SIMULTANEO.DESCRIPCION_PRODUCTO AS DESCRIP_PROD_SIMULTANEO ';
      Lcl_FromJoinParamsGs  := Lcl_FromJoinParamsGs || 
                               'INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_GESTIONADO
                                ON PROD_GESTIONADO.ID_PRODUCTO = COALESCE(TO_NUMBER(REGEXP_SUBSTR(PARAMS_PYL_SERVICIO_GESTIONADO.VALOR5,''^\d+'')),0)
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_SIMULTANEO
                                ON PROD_SIMULTANEO.ID_PRODUCTO = COALESCE(TO_NUMBER(REGEXP_SUBSTR(PARAMS_PYL_SERVICIO_SIMULTANEO.VALOR5,''^\d+'')),0) 
                                ';
      Lcl_WhereParamsGs     := Lcl_WhereParamsGs || 
                               'AND PARAMS_PYL_SERVICIO_GESTIONADO.VALOR4 = ''' || Lv_ParamProdGestionSimultanea || ''' 
                                AND PARAMS_PYL_SERVICIO_SIMULTANEO.VALOR4 = ''' || Lv_ParamProdGestionSimultanea || ''' ';
    END IF;

    IF Pv_OpcionGestionSimultanea IS NOT NULL THEN
      Lcl_WhereParamsGs := Lcl_WhereParamsGs || 'AND PARAMS_PYL_SERVICIO_GESTIONADO.VALOR3 = ''' || Pv_OpcionGestionSimultanea || ''' ';
    END IF;


    Lcl_QueryParamsGs           := Lcl_SelectParamsGs || Lcl_FromJoinParamsGs || Lcl_WhereParamsGs;


    Lcl_QuerySolGestionada      := 'SELECT SOL_GESTIONADA.ID_DETALLE_SOLICITUD AS ID_SOL_GESTIONADA,
                                    TIPO_SOL_GESTIONADA.ID_TIPO_SOLICITUD AS ID_TIPO_SOL_GESTIONADA,
                                    TIPO_SOL_GESTIONADA.DESCRIPCION_SOLICITUD AS DESCRIP_TIPO_SOL_GESTIONADA,
                                    SERVICIO_GESTIONADO.ID_SERVICIO AS ID_SERVICIO_GESTIONADO,
                                    SERVICIO_GESTIONADO.PLAN_ID AS ID_PLAN_SERVICIO_GESTIONADO,
                                    PLAN_SERVICIO_GESTIONADO.NOMBRE_PLAN AS PLAN_SERVICIO_GESTIONADO,
                                    SERVICIO_GESTIONADO.PRODUCTO_ID AS ID_PROD_SERVICIO_GESTIONADO,
                                    PROD_SERVICIO_GESTIONADO.DESCRIPCION_PRODUCTO AS PROD_SERVICIO_GESTIONADO,
                                    CASE                         
                                      WHEN SERVICIO_GESTIONADO.PLAN_ID IS NOT NULL THEN                         
                                      ( SELECT ID_PRODUCTO
                                        FROM DB_COMERCIAL.ADMI_PRODUCTO
                                        WHERE NOMBRE_TECNICO = ''' || Lv_NombreTecnicoInternet || '''     
                                        AND ESTADO = ''' || Lv_EstadoActivo || ''' 
                                        AND EMPRESA_COD = ''' || Lv_CodEmpresa || '''  
                                      )                     
                                    ELSE                         
                                      SERVICIO_GESTIONADO.PRODUCTO_ID                    
                                    END AS ID_PROD_SERVICIO_GESTIONADO_GS,
                                    PUNTO_GESTIONADO.ID_PUNTO AS ID_PUNTO_GESTIONADO,
                                    JURISDICCION.ID_JURISDICCION AS ID_JURISDICCION_PUNTO,
                                    JURISDICCION.CUPO AS CUPO_JURISDICCION_PUNTO 
                                    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_GESTIONADA
                                    INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL_GESTIONADA
                                    ON TIPO_SOL_GESTIONADA.ID_TIPO_SOLICITUD = SOL_GESTIONADA.TIPO_SOLICITUD_ID
                                    INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO_GESTIONADO
                                    ON SERVICIO_GESTIONADO.ID_SERVICIO = SOL_GESTIONADA.SERVICIO_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO_GESTIONADO
                                    ON PUNTO_GESTIONADO.ID_PUNTO = SERVICIO_GESTIONADO.PUNTO_ID
                                    INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
                                    ON JURISDICCION.ID_JURISDICCION = PUNTO_GESTIONADO.PUNTO_COBERTURA_ID
                                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_SERVICIO_GESTIONADO
                                    ON PLAN_SERVICIO_GESTIONADO.ID_PLAN = SERVICIO_GESTIONADO.PLAN_ID
                                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_SERVICIO_GESTIONADO
                                    ON PROD_SERVICIO_GESTIONADO.ID_PRODUCTO = SERVICIO_GESTIONADO.PRODUCTO_ID
                                    WHERE TIPO_SOL_GESTIONADA.ESTADO = ''' || Lv_EstadoActivo || ''' ';
    

    Lcl_QuerySolsSimultaneas    := 'SELECT DISTINCT SOL_SIMULTANEA.ID_DETALLE_SOLICITUD AS ID_SOL_SIMULTANEA,
                                    SOL_SIMULTANEA.ESTADO AS ESTADO_SOL_SIMULTANEA,
                                    TIPO_SOL_SIMULTANEA.ID_TIPO_SOLICITUD AS ID_TIPO_SOL_SIMULTANEA,
                                    TIPO_SOL_SIMULTANEA.DESCRIPCION_SOLICITUD AS DESCRIP_TIPO_SOL_SIMULTANEA,
                                    SERVICIO_SIMULTANEO.ID_SERVICIO AS ID_SERVICIO_SIMULTANEO,
                                    SERVICIO_SIMULTANEO.ESTADO AS ESTADO_SERVICIO_SIMULTANEO,
                                    SERVICIO_SIMULTANEO.PLAN_ID AS ID_PLAN_SERVICIO_SIMULTANEO,
                                    PLAN_SERVICIO_SIMULTANEO.NOMBRE_PLAN AS PLAN_SERVICIO_SIMULTANEO,
                                    SERVICIO_SIMULTANEO.PRODUCTO_ID AS ID_PROD_SERVICIO_SIMULTANEO,
                                    PROD_SERVICIO_SIMULTANEO.DESCRIPCION_PRODUCTO AS PROD_SERVICIO_SIMULTANEO,
                                    CASE                         
                                      WHEN SERVICIO_SIMULTANEO.PLAN_ID IS NOT NULL THEN                         
                                      ( SELECT ID_PRODUCTO
                                        FROM DB_COMERCIAL.ADMI_PRODUCTO
                                        WHERE NOMBRE_TECNICO = ''' || Lv_NombreTecnicoInternet || '''     
                                        AND ESTADO = ''' || Lv_EstadoActivo || ''' 
                                        AND EMPRESA_COD = ''' || Lv_CodEmpresa || ''' 
                                      )                     
                                    ELSE                         
                                      SERVICIO_SIMULTANEO.PRODUCTO_ID                    
                                    END AS ID_PROD_SERVICIO_SIMULTANEO_GS,
                                    SERVICIO_SIMULTANEO.PUNTO_ID AS ID_PUNTO_SIMULTANEO
                                    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL_SIMULTANEA
                                    INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO_SIMULTANEO
                                    ON SERVICIO_SIMULTANEO.ID_SERVICIO = SOL_SIMULTANEA.SERVICIO_ID
                                    INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL_SIMULTANEA
                                    ON TIPO_SOL_SIMULTANEA.ID_TIPO_SOLICITUD = SOL_SIMULTANEA.TIPO_SOLICITUD_ID
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET_ESTADOS_SOL_ABIERTAS
                                    ON PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR2 = TIPO_SOL_SIMULTANEA.DESCRIPCION_SOLICITUD
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_MD
                                    ON PARAM_CAB_MD.ID_PARAMETRO = PARAM_DET_ESTADOS_SOL_ABIERTAS.PARAMETRO_ID 
                                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN_SERVICIO_SIMULTANEO
                                    ON PLAN_SERVICIO_SIMULTANEO.ID_PLAN = SERVICIO_SIMULTANEO.PLAN_ID
                                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_SERVICIO_SIMULTANEO
                                    ON PROD_SERVICIO_SIMULTANEO.ID_PRODUCTO = SERVICIO_SIMULTANEO.PRODUCTO_ID
                                    WHERE TIPO_SOL_SIMULTANEA.ESTADO = ''' || Lv_EstadoActivo || ''' 
                                    AND PARAM_CAB_MD.NOMBRE_PARAMETRO = ''' || Lv_ValorParamAsocServiciosMd || '''
                                    AND PARAM_CAB_MD.ESTADO = ''' || Lv_EstadoActivo || '''
                                    AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR2 = TIPO_SOL_SIMULTANEA.DESCRIPCION_SOLICITUD
                                    AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR1 = ''' || Lv_ValorEstadosSolAbiertas || '''
                                    AND PARAM_DET_ESTADOS_SOL_ABIERTAS.ESTADO = ''' || Lv_EstadoActivo || ''' 
                                    AND PARAM_DET_ESTADOS_SOL_ABIERTAS.VALOR3 = SOL_SIMULTANEA.ESTADO ';

   
    Lcl_Query                   := 'WITH 
                                    T_PARAMS_GS AS (' ||  Lcl_QueryParamsGs || ' ),
                                    T_INFO_SOL_SERV_GESTIONADA AS ( ' || Lcl_QuerySolGestionada || ' ), 
                                    T_INFO_SOLS_SERVS_SIMULTANEAS AS ( ' || Lcl_QuerySolsSimultaneas || ' ) 
                                    SELECT INFO_SOL_SERV_GESTIONADA.ID_SOL_GESTIONADA,
                                    INFO_SOL_SERV_GESTIONADA.DESCRIP_TIPO_SOL_GESTIONADA,
                                    INFO_SOL_SERV_GESTIONADA.ID_PLAN_SERVICIO_GESTIONADO,
                                    INFO_SOLS_SERVS_SIMULTANEAS.ID_SERVICIO_SIMULTANEO,
                                    INFO_SOLS_SERVS_SIMULTANEAS.ID_PLAN_SERVICIO_SIMULTANEO,
                                    INFO_SOLS_SERVS_SIMULTANEAS.ID_PROD_SERVICIO_SIMULTANEO,
                                    CASE
                                      WHEN INFO_SOLS_SERVS_SIMULTANEAS.ID_PLAN_SERVICIO_SIMULTANEO IS NOT NULL THEN                         
                                      INFO_SOLS_SERVS_SIMULTANEAS.PLAN_SERVICIO_SIMULTANEO
                                    ELSE
                                      INFO_SOLS_SERVS_SIMULTANEAS.PROD_SERVICIO_SIMULTANEO                    
                                    END AS DESCRIP_SERVICIO_SIMULTANEO,
                                    INFO_SOLS_SERVS_SIMULTANEAS.ESTADO_SERVICIO_SIMULTANEO,
                                    INFO_SOLS_SERVS_SIMULTANEAS.ID_SOL_SIMULTANEA,
                                    INFO_SOLS_SERVS_SIMULTANEAS.DESCRIP_TIPO_SOL_SIMULTANEA,
                                    INFO_SOLS_SERVS_SIMULTANEAS.ESTADO_SOL_SIMULTANEA,
                                    NVL(
                                    DB_COMERCIAL.TECNK_SERVICIOS.F_GET_ID_DET_SOL_CARACT_VALIDA(INFO_SOLS_SERVS_SIMULTANEAS.ID_SOL_SIMULTANEA, 
                                                                                                INFO_SOLS_SERVS_SIMULTANEAS.ID_SERVICIO_SIMULTANEO, 
                                                                                                ''' || Lv_CampoBusqueda || ''', 
                                                                                                ''' || Lv_CaractMotivoCreacionSol || ''', 
                                                                                                ''' || Lv_ValorMotivoCreacionSol || ''')
                                    , 0)
                                    AS ID_DET_SOL_CARACT_CAMBIO_X_EXT,
                                    INFO_SOL_SERV_GESTIONADA.ID_PUNTO_GESTIONADO,
                                    INFO_SOL_SERV_GESTIONADA.ID_JURISDICCION_PUNTO,
                                    INFO_SOL_SERV_GESTIONADA.CUPO_JURISDICCION_PUNTO,
                                    PARAMS_GS.OPCION_GESTION_SIMULTANEA
                                    FROM T_INFO_SOL_SERV_GESTIONADA INFO_SOL_SERV_GESTIONADA
                                    INNER JOIN T_INFO_SOLS_SERVS_SIMULTANEAS INFO_SOLS_SERVS_SIMULTANEAS
                                    ON INFO_SOLS_SERVS_SIMULTANEAS.ID_PUNTO_SIMULTANEO = INFO_SOL_SERV_GESTIONADA.ID_PUNTO_GESTIONADO
                                    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_SERVICIO_SIMULTANEO_GS
                                    ON PROD_SERVICIO_SIMULTANEO_GS.ID_PRODUCTO = INFO_SOLS_SERVS_SIMULTANEAS.ID_PROD_SERVICIO_SIMULTANEO_GS
                                    INNER JOIN T_PARAMS_GS PARAMS_GS 
                                    ON PARAMS_GS.ID_PROD_GESTIONADO = INFO_SOL_SERV_GESTIONADA.ID_PROD_SERVICIO_GESTIONADO_GS
                                    WHERE INFO_SOL_SERV_GESTIONADA.ID_SOL_GESTIONADA = ' || Pn_IdSolicitud || '
                                    AND INFO_SOLS_SERVS_SIMULTANEAS.ID_SOL_SIMULTANEA <>  ' || Pn_IdSolicitud || '
                                    AND PARAMS_GS.TIPO_SOL_SERVICIO_GESTIONADO = INFO_SOL_SERV_GESTIONADA.DESCRIP_TIPO_SOL_GESTIONADA
                                    AND PARAMS_GS.ID_PROD_SIMULTANEO = INFO_SOLS_SERVS_SIMULTANEAS.ID_PROD_SERVICIO_SIMULTANEO_GS
                                    AND PARAMS_GS.TIPO_SOL_SERVICIO_SIMULTANEO = INFO_SOLS_SERVS_SIMULTANEAS.DESCRIP_TIPO_SOL_SIMULTANEA 
                                    AND 
                                    (
                                      (
                                        INFO_SOLS_SERVS_SIMULTANEAS.ESTADO_SERVICIO_SIMULTANEO IN 
                                        (
                                            SELECT ESTADOS_SERVICIOS_IN.VALOR3
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_MD_ESTADOS_IN
                                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET ESTADOS_SERVICIOS_IN
                                            ON ESTADOS_SERVICIOS_IN.PARAMETRO_ID = PARAM_CAB_MD_ESTADOS_IN.ID_PARAMETRO
                                            WHERE PARAM_CAB_MD_ESTADOS_IN.NOMBRE_PARAMETRO = ''' || Lv_ValorParamAsocServiciosMd || '''
                                            AND PARAM_CAB_MD_ESTADOS_IN.ESTADO = ''' || Lv_EstadoActivo || '''
                                            AND ESTADOS_SERVICIOS_IN.VALOR1 = ''' || Lv_ValorEstadosServiciosIn || '''
                                            AND ESTADOS_SERVICIOS_IN.VALOR2 = PROD_SERVICIO_SIMULTANEO_GS.NOMBRE_TECNICO
                                            AND ESTADOS_SERVICIOS_IN.ESTADO = ''' || Lv_EstadoActivo || '''
                                        )
                                      )
                                      OR
                                      (
                                        INFO_SOLS_SERVS_SIMULTANEAS.ESTADO_SERVICIO_SIMULTANEO NOT IN 
                                        (   SELECT ESTADOS_SERVICIOS_NOT_IN.VALOR3
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB_MD_ESTADOS_NOT_IN
                                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET ESTADOS_SERVICIOS_NOT_IN
                                            ON ESTADOS_SERVICIOS_NOT_IN.PARAMETRO_ID = PARAM_CAB_MD_ESTADOS_NOT_IN.ID_PARAMETRO
                                            WHERE PARAM_CAB_MD_ESTADOS_NOT_IN.NOMBRE_PARAMETRO = ''' || Lv_ValorParamAsocServiciosMd || '''
                                            AND PARAM_CAB_MD_ESTADOS_NOT_IN.ESTADO = ''' || Lv_EstadoActivo || '''
                                            AND ESTADOS_SERVICIOS_NOT_IN.VALOR1 = ''' || Lv_ValorEstadosServiciosNotIn || '''
                                            AND ESTADOS_SERVICIOS_NOT_IN.VALOR2 = PROD_SERVICIO_SIMULTANEO_GS.NOMBRE_TECNICO
                                            AND ESTADOS_SERVICIOS_NOT_IN.ESTADO = ''' || Lv_EstadoActivo || '''
                                        )
                                      )
                                    ) ';

    IF Pv_OpcionGestionSimultanea IS NOT NULL THEN 
      Lcl_Query := Lcl_Query || ' AND PARAMS_GS.OPCION_GESTION_SIMULTANEA = ''' || Pv_OpcionGestionSimultanea || ''' ';
    END IF;

    OPEN Prf_RegistrosGestionSimultanea FOR Lcl_Query;
    Pv_Status     := 'OK';
    Pv_MsjError   := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status                       := 'ERROR';
    Pv_MsjError                     := Lv_MsjError;
    Prf_RegistrosGestionSimultanea  := NULL;
  WHEN OTHERS THEN
    Pv_Status                       := 'ERROR';
    Pv_MsjError                     := 'No se ha podido obtener los registros con la información de la gestión simultánea';
    Prf_RegistrosGestionSimultanea  := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_GET_INFO_GESTION_SIMULTANEA',
                                          'No se ha podido obtener los registros con la información de la gestión simultánea  - ' 
                                          || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                          || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_INFO_GESTION_SIMULTANEA;

  PROCEDURE P_GET_INFOCLIENTE_INTERNET_WS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_Registros           OUT SYS_REFCURSOR)
  AS
    Lv_PrefijoEmpresa               VARCHAR2(2);
    Lv_CodEmpresa                   DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
    Lv_Identificacion               DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE;
    Lv_Login                        DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Lv_SerieOnt                     DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE;
    Lv_MacOnt                       DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_TipoRol                      DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE;
    Lv_NombreParamGeneral           VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ParamsWebServices            VARCHAR2(24) := 'PARAMETROS_WEB_SERVICES';
    Lv_NombreWebService             VARCHAR2(20) := 'INFORMACION_CLIENTE';
    Lv_ParamTiposRol                VARCHAR2(21) := 'TIPOS_ROL_PERMITIDOS';
    Lv_ParamEstadosPer              VARCHAR2(39) := 'ESTADOS_PERSONA_EMPRESA_ROL_PERMITIDOS';
    Lv_ParamEstadosOntServInternet  VARCHAR2(32) := 'ESTADOS_ONT_INTERNET_PERMITIDOS';
    Lv_ParamEstadosServInternet     VARCHAR2(37) := 'ESTADOS_SERVICIO_INTERNET_PERMITIDOS';
    Lv_ParamNombresTecnInternet     VARCHAR2(37) := 'NOMBRES_TECNICOS_INTERNET_PERMITIDOS';
    Lv_DescripCaractMacOnt          VARCHAR2(8) := 'MAC ONT';
    Lv_EstadoEliminado              VARCHAR2(9) := 'Eliminado';
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_NumParamsMaximo              VARCHAR2(10);
    Ln_NumParamsMaximo              NUMBER;
    Ln_NumParamsRequest             NUMBER := 0;
    Lcl_JsonFiltrosBusqueda         CLOB;
    Lcl_Select                      CLOB;
    Lcl_From                        CLOB;
    Lcl_Join                        CLOB;
    Lcl_Where                       CLOB;
    Lcl_ConsultaPrincipal           CLOB;
    Le_Exception                    EXCEPTION;
    Lv_MsjError                     VARCHAR2(4000);
  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_CodEmpresa           := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strCodEmpresa'));
    Lv_Identificacion       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdentificacion'));
    Lv_Login                := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strLogin'));
    Lv_SerieOnt             := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strSerieOnt'));
    Lv_MacOnt               := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strMacOnt'));
    Lv_TipoRol              := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strTipoRol'));
    Lv_PrefijoEmpresa       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strPrefijoEmpresa'));
    Lv_NumParamsMaximo      := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strNumParamsMaximo'));
    
    IF Lv_Identificacion IS NULL AND Lv_Login IS NULL AND Lv_SerieOnt IS NULL AND Lv_MacOnt IS NULL THEN
      Lv_MsjError := 'No se ha enviado alguno de los parámetros obligatorios para obtener la información del cliente';
      RAISE Le_Exception;
    END IF;
    
    IF Lv_CodEmpresa IS NULL THEN
      Lv_MsjError := 'No se ha enviado el parámetro obligatorio del código de la empresa';
      RAISE Le_Exception;
    END IF;
    
    IF Lv_PrefijoEmpresa IS NULL THEN
      Lv_MsjError := 'No se ha obtenido de manera correcta el prefijo de la empresa';
      RAISE Le_Exception;
    END IF;

    IF Lv_NumParamsMaximo IS NOT NULL THEN
      Ln_NumParamsMaximo    := TO_NUMBER(Lv_NumParamsMaximo,'9999999999999');
    ELSE
      Ln_NumParamsMaximo    := 1;
    END IF;
    
    Lv_NombreParamGeneral := Lv_NombreParamGeneral || Lv_PrefijoEmpresa;
    
    Lcl_Select      := 'SELECT DISTINCT PERSONA_EMPRESA_ROL.ID_PERSONA_ROL,
                        PERSONA_EMPRESA_ROL.ESTADO AS ESTADO_PERSONA_ROL,
                        PERSONA_EMPRESA_ROL.OFICINA_ID,
                        PERSONA.ID_PERSONA, 
                        PERSONA.IDENTIFICACION_CLIENTE,                                                
                        CASE                                                  
                        WHEN PERSONA.RAZON_SOCIAL IS NOT NULL                                                  
                        THEN PERSONA.RAZON_SOCIAL                                                  
                        ELSE DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.NOMBRES)
                        || '' '' 
                        || DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.APELLIDOS)
                        END CLIENTE, 
                        PUNTO.ID_PUNTO,
                        SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_INTERNET,
                        SERVICIO_INTERNET_X_PUNTO.ID_PRODUCTO_INTERNET,
                        SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_TECNICO_INTERNET ';

    Lcl_From        := 'FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_EMPRESA_ROL                                          
                        INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA    
                        ON PERSONA.ID_PERSONA = PERSONA_EMPRESA_ROL.PERSONA_ID                                             
                        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL 
                        ON PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID = EMPRESA_ROL.ID_EMPRESA_ROL                                             
                        INNER JOIN DB_COMERCIAL.ADMI_ROL ROL 
                        ON EMPRESA_ROL.ROL_ID = ROL.ID_ROL 
                        INNER JOIN DB_COMERCIAL.ADMI_TIPO_ROL TIPO_ROL 
                        ON TIPO_ROL.ID_TIPO_ROL = ROL.TIPO_ROL_ID 
                        LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
                        ON PUNTO.PERSONA_EMPRESA_ROL_ID = PERSONA_EMPRESA_ROL.ID_PERSONA_ROL 
                        LEFT JOIN 
                        (
                            SELECT DISTINCT SERVICIO.PUNTO_ID, SERVICIO.ID_SERVICIO AS ID_SERVICIO_INTERNET,
                            SERVICIO_TECNICO.ID_SERVICIO_TECNICO AS ID_SERVICIO_TECNICO_INTERNET,
                            CASE WHEN SERVICIO.PLAN_ID IS NOT NULL THEN
                              PROD_PLAN.ID_PRODUCTO
                            ELSE
                              PRODUCTO.ID_PRODUCTO
                            END AS ID_PRODUCTO_INTERNET,
                            ONT.SERIE_FISICA AS SERIE_ONT
                            FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
                            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
                            ON SERVICIO_TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO 
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ONT
                            ON ONT.ID_ELEMENTO = SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID 
                            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN
                            ON PLAN.ID_PLAN = SERVICIO.PLAN_ID
                            LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                            ON PLAN_DET.PLAN_ID = PLAN.ID_PLAN 
                            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_PLAN
                            ON PROD_PLAN.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID 
                            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                            ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                            WHERE SERVICIO.ESTADO 
                            IN 
                            (   SELECT DISTINCT PARAM_DET.VALOR4
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                WHERE PARAM_CAB.NOMBRE_PARAMETRO =  :a
                                AND PARAM_CAB.ESTADO = :b
                                AND PARAM_DET.VALOR1 = :c
                                AND PARAM_DET.VALOR2 = :d
                                AND PARAM_DET.VALOR3 = :e
                                AND PARAM_DET.ESTADO = :f
                                AND PARAM_DET.EMPRESA_COD = :g
                            )
                            AND 
                            (
                                (
                                    PLAN.ID_PLAN IS NOT NULL
                                    AND PLAN_DET.ESTADO <> :h
                                    AND PROD_PLAN.NOMBRE_TECNICO IN (SELECT DISTINCT PARAM_DET.VALOR4
                                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                                    ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                                    WHERE PARAM_CAB.NOMBRE_PARAMETRO =  :i
                                                                    AND PARAM_CAB.ESTADO = :j
                                                                    AND PARAM_DET.VALOR1 = :k
                                                                    AND PARAM_DET.VALOR2 = :l
                                                                    AND PARAM_DET.VALOR3 = :m
                                                                    AND PARAM_DET.ESTADO = :n
                                                                    AND PARAM_DET.EMPRESA_COD = :o)
                                )
                                OR
                                (
                                    PRODUCTO.ID_PRODUCTO IS NOT NULL
                                    AND PRODUCTO.NOMBRE_TECNICO IN (SELECT DISTINCT PARAM_DET.VALOR4
                                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                                    ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                                    WHERE PARAM_CAB.NOMBRE_PARAMETRO =  :p
                                                                    AND PARAM_CAB.ESTADO = :q
                                                                    AND PARAM_DET.VALOR1 = :r
                                                                    AND PARAM_DET.VALOR2 = :s
                                                                    AND PARAM_DET.VALOR3 = :t
                                                                    AND PARAM_DET.ESTADO = :u
                                                                    AND PARAM_DET.EMPRESA_COD = :v)
                                )
                            )
                            AND ONT.ESTADO IN ( SELECT DISTINCT PARAM_DET.VALOR4
                                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                WHERE PARAM_CAB.NOMBRE_PARAMETRO =  :w
                                                AND PARAM_CAB.ESTADO = :x
                                                AND PARAM_DET.VALOR1 = :y
                                                AND PARAM_DET.VALOR2 = :z
                                                AND PARAM_DET.VALOR3 = :a1
                                                AND PARAM_DET.ESTADO = :b1
                                                AND PARAM_DET.EMPRESA_COD = :c1) 
                        ) SERVICIO_INTERNET_X_PUNTO
                        ON SERVICIO_INTERNET_X_PUNTO.PUNTO_ID = PUNTO.ID_PUNTO ';

    Lcl_Where       := 'WHERE EMPRESA_ROL.EMPRESA_COD = :d1
                        AND PERSONA_EMPRESA_ROL.ESTADO IN ( SELECT DISTINCT PARAM_DET.VALOR4
                                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                            ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                            WHERE PARAM_CAB.NOMBRE_PARAMETRO =  :e1
                                                            AND PARAM_CAB.ESTADO = :f1
                                                            AND PARAM_DET.VALOR1 = :g1
                                                            AND PARAM_DET.VALOR2 = :h1
                                                            AND PARAM_DET.VALOR3 = :i1
                                                            AND PARAM_DET.ESTADO = :j1
                                                            AND PARAM_DET.EMPRESA_COD = :k1 ) 
                        ';

    IF Lv_Identificacion IS NOT NULL THEN
      Lcl_Where := Lcl_Where || 'AND PERSONA.IDENTIFICACION_CLIENTE = :l1 ';
      IF Lv_TipoRol IS NOT NULL THEN
        Lcl_Where   := Lcl_Where || 'AND TIPO_ROL.DESCRIPCION_TIPO_ROL = :m1 ';
      ELSE
        Lcl_Where   := Lcl_Where || 'AND TIPO_ROL.DESCRIPCION_TIPO_ROL IN ( SELECT DISTINCT PARAM_DET.VALOR4
                                                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                                            ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                                            WHERE PARAM_CAB.NOMBRE_PARAMETRO =  :n1
                                                                            AND PARAM_CAB.ESTADO = :o1
                                                                            AND PARAM_DET.VALOR1 = :p1
                                                                            AND PARAM_DET.VALOR2 = :q1
                                                                            AND PARAM_DET.VALOR3 = :r1
                                                                            AND PARAM_DET.ESTADO = :s1
                                                                            AND PARAM_DET.EMPRESA_COD = :t1 ) ';
      END IF;
      Ln_NumParamsRequest   := Ln_NumParamsRequest + 1;
    END IF;
    
    IF Lv_Login IS NOT NULL THEN
      Lcl_Where := Lcl_Where || 'AND PUNTO.LOGIN = :u1 ';
      Ln_NumParamsRequest   := Ln_NumParamsRequest + 1;
    END IF;

    IF (Lv_SerieOnt IS NOT NULL OR Lv_MacOnt IS NOT NULL) THEN
      IF Lv_SerieOnt IS NOT NULL THEN
        Lcl_Where := Lcl_Where || 'AND SERVICIO_INTERNET_X_PUNTO.SERIE_ONT = :v1 ';
        Ln_NumParamsRequest := Ln_NumParamsRequest + 1;
      END IF;

      IF Lv_MacOnt IS NOT NULL THEN
        Lcl_Join    := Lcl_Join || ' INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC_MAC_ONT
                                     ON SPC_MAC_ONT.SERVICIO_ID = SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_INTERNET
                                     INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC_MAC_ONT
                                     ON APC_MAC_ONT.ID_PRODUCTO_CARACTERISITICA = SPC_MAC_ONT.PRODUCTO_CARACTERISITICA_ID
                                     INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_MAC_ONT 
                                     ON CARACT_MAC_ONT.ID_CARACTERISTICA = APC_MAC_ONT.CARACTERISTICA_ID ';
        Lcl_Where   := Lcl_Where || 'AND CARACT_MAC_ONT.DESCRIPCION_CARACTERISTICA = :w1 
                                 AND SPC_MAC_ONT.ESTADO = :x1 
                                 AND SPC_MAC_ONT.VALOR = :y1 ';
        Ln_NumParamsRequest := Ln_NumParamsRequest + 1;
      END IF;
    END IF;

    IF Ln_NumParamsRequest > Ln_NumParamsMaximo THEN
      Lv_MsjError   := 'Se han enviado ' || Ln_NumParamsRequest || ' filtro(s) de búsqueda. Para esta consulta solo se tiene permitido '
                       || Ln_NumParamsMaximo || ' filtro(s).';
      RAISE Le_Exception;
    END IF;

    IF Ln_NumParamsMaximo <> 1 THEN
        Lv_MsjError   := 'El numero maximo de filtro(s) es distinto de 1 . No se pueden realizar busquedas con mas de un filtro.';
      RAISE Le_Exception;
    END IF;
    
    Lcl_ConsultaPrincipal := Lcl_Select || Lcl_From || Lcl_Join || Lcl_Where;
    
    
    IF Lv_Identificacion IS NOT NULL AND 
       Lv_TipoRol IS NOT NULL THEN
       OPEN Prf_Registros FOR Lcl_ConsultaPrincipal USING Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_EstadoEliminado,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosOntServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosPer,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_Identificacion,
                                                       Lv_TipoRol;
    ELSIF Lv_Identificacion IS NOT NULL AND
       Lv_TipoRol IS NULL THEN
       OPEN Prf_Registros FOR Lcl_ConsultaPrincipal USING Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_EstadoEliminado,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosOntServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosPer,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_Identificacion,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamTiposRol,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa;
    ELSIF Lv_Login IS NOT NULL THEN
       OPEN Prf_Registros FOR Lcl_ConsultaPrincipal USING Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_EstadoEliminado,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosOntServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosPer,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_Login;
    ELSIF Lv_SerieOnt IS NOT NULL THEN
       OPEN Prf_Registros FOR Lcl_ConsultaPrincipal USING Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_EstadoEliminado,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosOntServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosPer,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_SerieOnt;
    ELSIF Lv_MacOnt IS NOT NULL THEN
       OPEN Prf_Registros FOR Lcl_ConsultaPrincipal USING Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_EstadoEliminado,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamNombresTecnInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosOntServInternet,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_CodEmpresa,
                                                       Lv_NombreParamGeneral,
                                                       Lv_EstadoActivo,
                                                       Lv_ParamsWebServices,
                                                       Lv_NombreWebService,
                                                       Lv_ParamEstadosPer,
                                                       Lv_EstadoActivo,
                                                       Lv_CodEmpresa,
                                                       Lv_DescripCaractMacOnt,
                                                       Lv_EstadoActivo,
                                                       Lv_MacOnt;
    END IF;

    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status           := 'ERROR';
    Pv_MsjError         := Lv_MsjError;
    Prf_Registros       := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_INTERNET_WS', 
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Lv_MsjError         := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_MsjError         := 'No se ha podido realizar correctamente la consulta del cliente. Por favor consultar con Sistemas!';
    Prf_Registros       := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_INTERNET_WS',
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_INFOCLIENTE_INTERNET_WS;

  PROCEDURE P_GET_INFOCLIENTE_PUNTO_WS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_Registros           OUT SYS_REFCURSOR)
  AS
    Lv_PrefijoEmpresa               VARCHAR2(2);
    Lv_CodEmpresa                   DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
    Ln_IdPunto                      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Lv_NombreParamGeneral           VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ParamsWebServices            VARCHAR2(24) := 'PARAMETROS_WEB_SERVICES';
    Lv_NombreWebService             VARCHAR2(20) := 'INFORMACION_CLIENTE';
    Lv_ParamDescripcionTelefonos    VARCHAR2(49) := 'DESCRIPCIONES_FORMA_CONTACTO_TELEFONO_PERMITIDOS';
    Lv_DescripcionMail              VARCHAR2(4) := 'MAIL';
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lcl_JsonFiltrosBusqueda         CLOB;
    Lcl_Query                       CLOB;
    Le_Exception                    EXCEPTION;
    Lv_MsjError                     VARCHAR2(4000);
  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_CodEmpresa           := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strCodEmpresa'));
    Lv_PrefijoEmpresa       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strPrefijoEmpresa'));
    Ln_IdPunto              := TRIM(APEX_JSON.GET_NUMBER(p_path => 'intIdPunto'));
    
    IF Lv_CodEmpresa IS NULL OR Lv_PrefijoEmpresa IS NULL OR Ln_IdPunto IS NULL THEN
      Lv_MsjError := 'No se han enviado los parámetros obligatorios para obtener la información del punto';
      RAISE Le_Exception;
    END IF;
    
    Lv_NombreParamGeneral := Lv_NombreParamGeneral || Lv_PrefijoEmpresa;
    
    Lcl_Query   := 'SELECT DISTINCT PUNTO.ID_PUNTO,
                    PUNTO.LOGIN,
                    PUNTO.ESTADO AS ESTADO_PUNTO,
                    DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PUNTO.DIRECCION) AS DIRECCION,
                    PUNTO.LONGITUD,                  
                    PUNTO.LATITUD, 
                    JURISDICCION.NOMBRE_JURISDICCION,
                    SECTOR.NOMBRE_SECTOR,                                                
                    CANTON.NOMBRE_CANTON, 
                    (   SELECT LISTAGG(PUNTO_FORMA_CONTACTO.VALOR, '';'')                  
                        WITHIN GROUP (ORDER BY PUNTO_FORMA_CONTACTO.PUNTO_ID)                  
                        FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PUNTO_FORMA_CONTACTO
                        INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO FORMA_CONTACTO
                        ON FORMA_CONTACTO.ID_FORMA_CONTACTO = PUNTO_FORMA_CONTACTO.FORMA_CONTACTO_ID
                        WHERE PUNTO_FORMA_CONTACTO.PUNTO_ID = PUNTO.ID_PUNTO                
                        AND FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO 
                        IN
                        (
                            SELECT DISTINCT PARAM_DET.VALOR4
                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                            ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                            WHERE PARAM_CAB.NOMBRE_PARAMETRO =  ''' || Lv_NombreParamGeneral || '''
                            AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                            AND PARAM_DET.VALOR1 = ''' || Lv_ParamsWebServices || '''
                            AND PARAM_DET.VALOR2 = ''' || Lv_NombreWebService || '''
                            AND PARAM_DET.VALOR3 = ''' || Lv_ParamDescripcionTelefonos || '''
                            AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                            AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresa || '''
                        )
                        AND ROWNUM <=2) 
                    AS TELEFONOS,
                    NVL(TRIM(DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO( PUNTO.ID_PUNTO, 
                                                                                            ''' || Lv_DescripcionMail || ''' )), '''') AS CORREOS,
                    TRUNC(NVL(DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_SALDO_CLIENTE_BY_PUNTO(PUNTO.ID_PUNTO), 0),2) AS SALDO,
                    ATN.NOMBRE_TIPO_NEGOCIO
                    FROM DB_COMERCIAL.INFO_PUNTO PUNTO
                    INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
                    ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID 
                    INNER JOIN DB_GENERAL.ADMI_SECTOR SECTOR 
                    ON SECTOR.ID_SECTOR = PUNTO.SECTOR_ID 
                    INNER JOIN DB_GENERAL.ADMI_PARROQUIA PARROQUIA 
                    ON SECTOR.PARROQUIA_ID = PARROQUIA.ID_PARROQUIA                 
                    INNER JOIN DB_GENERAL.ADMI_CANTON CANTON 
                    ON PARROQUIA.CANTON_ID = CANTON.ID_CANTON 
                    INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO ATN
                    ON ATN.ID_TIPO_NEGOCIO = PUNTO.TIPO_NEGOCIO_ID
                    WHERE PUNTO.ID_PUNTO = ' || Ln_IdPunto || ' ';
    OPEN Prf_Registros FOR Lcl_Query;
    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status           := 'ERROR';
    Pv_MsjError         := Lv_MsjError;
    Prf_Registros       := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_PUNTO_WS', 
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Lv_MsjError         := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_MsjError         := 'No se ha podido realizar correctamente la consulta del punto. Por favor consultar con Sistemas!';
    Prf_Registros       := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_PUNTO_WS',
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_INFOCLIENTE_PUNTO_WS;

  PROCEDURE P_GET_INFOCLIENTE_SERVICIO_WS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_Registros           OUT SYS_REFCURSOR)
  AS
    Lv_PrefijoEmpresa               VARCHAR2(2);
    Lv_CodEmpresa                   DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
    Ln_IdPunto                      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Lv_NombreParamGeneral           VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ParamsWebServices            VARCHAR2(24) := 'PARAMETROS_WEB_SERVICES';
    Lv_NombreWebService             VARCHAR2(20) := 'INFORMACION_CLIENTE';
    Lv_ParamEstadosServicios        VARCHAR2(28) := 'ESTADOS_SERVICIO_PERMITIDOS';
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_EstadoEliminado              VARCHAR2(9) := 'Eliminado';
    Lcl_JsonFiltrosBusqueda         CLOB;
    Lcl_Query                       CLOB;
    Le_Exception                    EXCEPTION;
    Lv_MsjError                     VARCHAR2(4000);
  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_CodEmpresa           := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strCodEmpresa'));
    Lv_PrefijoEmpresa       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strPrefijoEmpresa'));
    Ln_IdPunto              := TRIM(APEX_JSON.GET_NUMBER(p_path => 'intIdPunto'));
    
    IF Lv_CodEmpresa IS NULL OR Lv_PrefijoEmpresa IS NULL OR Ln_IdPunto IS NULL THEN
      Lv_MsjError := 'No se han enviado los parámetros obligatorios para obtener la información del punto';
      RAISE Le_Exception;
    END IF;
    
    Lv_NombreParamGeneral := Lv_NombreParamGeneral || Lv_PrefijoEmpresa;
    
    Lcl_Query   := 'SELECT DISTINCT SERVICIO.ID_SERVICIO,
                    CASE WHEN SERVICIO.PLAN_ID IS NOT NULL THEN
                      PROD_PLAN.ID_PRODUCTO
                    ELSE
                      PRODUCTO.ID_PRODUCTO
                    END AS ID_PROD_PLAN_PRODUCTO,
                    CASE WHEN SERVICIO.PLAN_ID IS NOT NULL THEN
                      PROD_PLAN.CODIGO_PRODUCTO
                    ELSE
                      PRODUCTO.CODIGO_PRODUCTO
                    END AS CODIGO_PROD_PLAN_PRODUCTO,
                    PLAN.CODIGO_PLAN,
                    CASE WHEN SERVICIO.PLAN_ID IS NOT NULL THEN
                      PROD_PLAN.DESCRIPCION_PRODUCTO
                    ELSE
                      PRODUCTO.DESCRIPCION_PRODUCTO
                    END AS DESCRIPCION_PROD_PLAN_PRODUCTO,
                    UM.NOMBRE_TIPO_MEDIO,
                    PLAN.ID_PLAN,
                    PLAN.NOMBRE_PLAN,
                    SERVICIO.ESTADO AS ESTADO_SERVICIO,
                    SERVICIO.LOGIN_AUX,
                    (SERVICIO.PRECIO_VENTA*SERVICIO.CANTIDAD) AS PRECIO 
                    FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
                    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
                    ON SERVICIO_TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO 
                    LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO UM 
                    ON UM.ID_TIPO_MEDIO = SERVICIO_TECNICO.ULTIMA_MILLA_ID 
                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN
                    ON PLAN.ID_PLAN = SERVICIO.PLAN_ID
                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                    ON PLAN_DET.PLAN_ID = PLAN.ID_PLAN 
                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_PLAN
                    ON PROD_PLAN.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID 
                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                    ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID 
                    WHERE SERVICIO.PUNTO_ID = ' || Ln_IdPunto || ' 
                    AND SERVICIO.ESTADO 
                    IN 
                    (   SELECT DISTINCT PARAM_DET.VALOR4
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                        ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                        WHERE PARAM_CAB.NOMBRE_PARAMETRO =  ''' || Lv_NombreParamGeneral || '''
                        AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                        AND PARAM_DET.VALOR1 = ''' || Lv_ParamsWebServices || '''
                        AND PARAM_DET.VALOR2 = ''' || Lv_NombreWebService || '''
                        AND PARAM_DET.VALOR3 = ''' || Lv_ParamEstadosServicios || '''
                        AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                        AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresa || '''
                    )
                    AND 
                    (
                        (
                            PLAN.ID_PLAN IS NOT NULL
                            AND PLAN_DET.ESTADO <> ''' || Lv_EstadoEliminado || '''
                        )
                        OR
                        (
                            PRODUCTO.ID_PRODUCTO IS NOT NULL
                        )
                    ) ';
    OPEN Prf_Registros FOR Lcl_Query;
    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status           := 'ERROR';
    Pv_MsjError         := Lv_MsjError;
    Prf_Registros       := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_SERVICIO_WS', 
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Lv_MsjError         := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_MsjError         := 'No se ha podido realizar correctamente la consulta del punto. Por favor consultar con Sistemas!';
    Prf_Registros       := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_SERVICIO_WS',
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_INFOCLIENTE_SERVICIO_WS;

  PROCEDURE P_GET_RESPUESTA_INFOCLIENTE_WS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pcl_JsonRespuesta       OUT CLOB)
  AS
    Lv_PrefijoEmpresa               VARCHAR2(2);
    Lv_CodEmpresa                   DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Lv_StatusOK                     VARCHAR2(2) := 'OK';
    Lv_MensajeOK                    VARCHAR2(2) := 'OK';
    Lv_StatusError                  VARCHAR2(5) := 'ERROR';
    Lv_EscribioInfoCliente          VARCHAR2(2) := 'NO';

    Lv_TieneInfoCliente             VARCHAR2(2) := 'NO';
    Ln_IdServicioDataTenica         DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;

    Lrf_RegistrosClienteInternet    SYS_REFCURSOR;
    Ln_IndxRegInfoClienteInternet   NUMBER;
    Lr_RegInfoClienteInternetWs     DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoClienteInternetWs;
    Lt_TRegInfoClienteInternetWs    DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoClienteInternetWs;
    Lv_TieneServicioInternet        VARCHAR2(2) := 'NO';

    Lv_TienePuntosCliente           VARCHAR2(2);
    Lrf_RegistrosClientePunto       SYS_REFCURSOR;
    Ln_IndxRegInfoClientePunto      NUMBER;
    Lr_RegInfoClientePuntoWs        DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoClientePuntoWs;
    Lt_TRegInfoClientePuntoWs       DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoClientePuntoWs;

    Lv_CorreosPer                   VARCHAR2(4000);
    Lv_CicloFacturacionPer          VARCHAR2(50);
    Lv_FormaPagoPer                 VARCHAR2(60);
    Lv_NumeroContratoPer            VARCHAR2(1000);
    Lv_TipoCuentaPer                VARCHAR2(1000);
    Ld_FechaMaximaPagoPer           DATE;
    Lv_FechaMaximaPagoPer           VARCHAR2(20);
    Lv_FechaEmision                 VARCHAR2(20);
    Lv_FechaCreacion                VARCHAR2(20);
    Ln_SaldoPer                     NUMBER;
    Ln_ValorPendienteTotalPer       NUMBER;

    Lv_TieneServiciosXPunto         VARCHAR2(2);
    Lrf_RegistrosClienteServicios   SYS_REFCURSOR;
    Ln_IndxRegInfoClienteServicios  NUMBER;
    Lr_RegInfoClienteServiciosWs    DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoClienteServicioWs;
    Lt_TRegInfoClienteServiciosWs   DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoClienteServicioWs;
    Lv_TieneCaractsServicioXPunto   VARCHAR2(2);
    Lcl_CaractsServicioXPunto       CLOB;

    Ln_IndxRegInfoDataTecnica       NUMBER;
    Lr_RegInfoDataTecnicaWs         DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoDataTecnicaWs;
    Lt_TRegInfoDataTecnicaWs        DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoDataTecnicaWs;

    Lrf_CursorFacturasPunto         SYS_REFCURSOR;
    Ln_NumFacturas                  NUMBER;
    Ln_IndxRegFacturasXPunto        NUMBER;
    Lr_RegInfoFacturaXPuntoWs       DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoFacturaPuntoWs;
    Lt_TRegInfoFacturaXPuntoWs      DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoFacturaPuntoWs;

    Lrf_DescripcionProdFactura      SYS_REFCURSOR;
    Lv_DescripcionProdFactura       VARCHAR2(4000);

    Lrf_CursorPagosPunto            SYS_REFCURSOR;
    Ln_NumPagos                     NUMBER;
    Ln_IndxRegPagosXPunto           NUMBER;
    Lr_RegInfoPagoXPuntoWs          DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoPagoPuntoWs;
    Lt_TRegInfoPagoXPuntoWs         DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoPagoPuntoWs;

    Lrf_CursorCasosPunto            SYS_REFCURSOR;
    Ln_IndxRegCasoXPunto            NUMBER;
    Lr_RegInfoCasoXPuntoWs          DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoCasoPuntoWs;
    Lt_TRegInfoCasoXPuntoWs         DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoCasoPuntoWs;

    Lrf_CursorTareasPunto           SYS_REFCURSOR;
    Ln_IndxRegTareaXPunto           NUMBER;
    Lr_RegInfoTareaXPuntoWs         DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoTareaPuntoWs;
    Lt_TRegInfoTareaXPuntoWs        DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoTareaPuntoWs;

    Lrf_CursorIpsPunto              SYS_REFCURSOR;
    Ln_IndxRegIpXPunto              NUMBER;
    Lr_RegInfoIpXPuntoWs            DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoIpPuntoWs;
    Lt_TRegInfoIpXPuntoWs           DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoIpPuntoWs;

    Lcl_DataTecnica                 CLOB;
    Lrf_RegistrosDataTecnica        SYS_REFCURSOR;
    Lcl_PuntosClienteRespuesta      CLOB;
    Lcl_ServiciosXPuntoRespuesta    CLOB;
    Lcl_JsonFiltrosBusquedaXPunto   CLOB;
    Lcl_JsonRespuesta               CLOB;
    Lcl_JsonFiltrosBusqueda         CLOB;
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_VisibleComercial             VARCHAR2(2) := 'SI';

    Lv_ProductoKonibit              VARCHAR2(2) := 'NO';
    Lv_RespuestaKonibit             VARCHAR2(20);
    Lrf_FechaFirmaContrato          SYS_REFCURSOR;
    Lv_FechaActivacion              VARCHAR2(20);
    
    Lv_NombreParamGeneral           VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ParamsWebServices            VARCHAR2(24) := 'PARAMETROS_WEB_SERVICES';
    Lv_NombreWebService             VARCHAR2(20) := 'INFORMACION_CLIENTE';
    Lv_NumMaximoFactWebService      VARCHAR2(32) := 'NUM_MAXIMO_FACTURAS_CONSULTADAS';
    Lv_NumMaximoPagosWebService     VARCHAR2(29) := 'NUM_MAXIMO_PAGOS_CONSULTADOS';
    Lv_BusquedasPermitXAplicativo   VARCHAR2(36) := 'BUSQUEDAS_PERMITIDAS_POR_APLICATIVO';
    Ln_IndxArrayData                NUMBER;
    Lt_ArrayData                    DB_INFRAESTRUCTURA.INKG_TYPES.Lt_ArrayOfVarchar;

    CURSOR Lc_GetNumValor4Parametro(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                                    Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE, 
                                    Cv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE, 
                                    Cv_Valor3 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
                                    Cv_CodEmpresa DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR4,'^\d+')),1) AS VALOR
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND DET.EMPRESA_COD        = Cv_CodEmpresa
      AND DET.VALOR1             = Cv_Valor1
      AND DET.VALOR2             = Cv_Valor2
      AND DET.VALOR3             = Cv_Valor3
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;

    CURSOR Lc_GetCorreosPersona(Cn_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
    IS
      SELECT LISTAGG(PERSONA_FORMA_CONTACTO.VALOR,',') WITHIN GROUP (ORDER BY PERSONA_FORMA_CONTACTO.VALOR ) CORREOS
      FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO PERSONA_FORMA_CONTACTO
      INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO FORMA_CONTACTO
      ON FORMA_CONTACTO.ID_FORMA_CONTACTO = PERSONA_FORMA_CONTACTO.FORMA_CONTACTO_ID
      WHERE FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO = 'Correo Electronico'
      AND PERSONA_FORMA_CONTACTO.PERSONA_ID = Cn_IdPersona
      AND PERSONA_FORMA_CONTACTO.ESTADO = Lv_EstadoActivo
      AND FORMA_CONTACTO.ESTADO = Lv_EstadoActivo;

    CURSOR Lc_GetSaldoPer(Cv_IdentificacionCliente DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                          Cv_CodEmpresa VARCHAR2)
    IS
      SELECT SUM(VISTA_ESTADO_CUENTA.SALDO) AS SALDO_TOTAL
      FROM DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO VISTA_ESTADO_CUENTA
      INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
      ON PUNTO.ID_PUNTO = VISTA_ESTADO_CUENTA.PUNTO_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_EMPRESA_ROL
      ON PERSONA_EMPRESA_ROL.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
      INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
      ON PERSONA.ID_PERSONA = PERSONA_EMPRESA_ROL.PERSONA_ID
      INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL
      ON EMPRESA_ROL.ID_EMPRESA_ROL = PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID
      WHERE EMPRESA_ROL.EMPRESA_COD = Cv_CodEmpresa
      AND PERSONA.IDENTIFICACION_CLIENTE = Cv_IdentificacionCliente
      GROUP BY PERSONA.ID_PERSONA, PERSONA.IDENTIFICACION_CLIENTE, PERSONA.RAZON_SOCIAL, PERSONA.NOMBRES, PERSONA.APELLIDOS;

    CURSOR Lc_GetSumaValorPendientePer(Cv_IdentificacionCliente DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                       Cv_CodEmpresa VARCHAR2)
    IS
      SELECT SUM(PAGO_LINEA.VALOR_PAGO_LINEA) AS VALOR_PENDIENTE_TOTAL
      FROM DB_FINANCIERO.INFO_PAGO_LINEA PAGO_LINEA
      INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
      ON PERSONA.ID_PERSONA = PAGO_LINEA.PERSONA_ID
      WHERE PAGO_LINEA.EMPRESA_ID = Cv_CodEmpresa
      AND PERSONA.IDENTIFICACION_CLIENTE = Cv_IdentificacionCliente
      AND PAGO_LINEA.ESTADO_PAGO_LINEA = 'Pendiente';

    CURSOR Lc_GetCaracteristicasPlan(Cn_IdPlan      DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
                                     Cn_IdProducto  DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE)
    IS
      SELECT PROD.DESCRIPCION_PRODUCTO, CARACT.DESCRIPCION_CARACTERISTICA,
        REPLACE(PLAN_PROD_CARACT.VALOR, chr(34), '') AS VALOR
      FROM DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
      ON PROD.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID 
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
      ON APC.PRODUCTO_ID = PROD.ID_PRODUCTO
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
      ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
      INNER JOIN DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT PLAN_PROD_CARACT
      ON PLAN_PROD_CARACT.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA 
      WHERE APC.VISIBLE_COMERCIAL = Lv_VisibleComercial
      AND PLAN_PROD_CARACT.VALOR IS NOT NULL 
      AND APC.ESTADO = Lv_EstadoActivo 
      AND PLAN_DET.ID_ITEM = PLAN_PROD_CARACT.PLAN_DET_ID 
      AND PLAN_PROD_CARACT.ESTADO = Lv_EstadoActivo
      AND PLAN_DET.PLAN_ID = Cn_IdPlan 
      AND PROD.ID_PRODUCTO = Cn_IdProducto;

    CURSOR Lc_GetCaracteristicasProd(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT CARACT.DESCRIPCION_CARACTERISTICA,
        REPLACE(SPC.VALOR, chr(34), '') AS VALOR
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
      ON APC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID
      INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
      ON PROD.ID_PRODUCTO = APC.PRODUCTO_ID 
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
      ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
      WHERE SPC.SERVICIO_ID = Cn_IdServicio
      AND APC.ESTADO = Lv_EstadoActivo
      AND SPC.ESTADO  = Lv_EstadoActivo
      AND APC.VISIBLE_COMERCIAL = Lv_VisibleComercial;

    CURSOR Lc_GetConsultasPorAplicativo(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                                        Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE, 
                                        Cv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE, 
                                        Cv_Valor3 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
                                        Cv_Valor4 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE,
                                        Cv_CodEmpresa DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT DET.VALOR5 AS CONSULTA_PERMITIDA
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND DET.EMPRESA_COD        = Cv_CodEmpresa
      AND DET.VALOR1             = Cv_Valor1
      AND DET.VALOR2             = Cv_Valor2
      AND DET.VALOR3             = Cv_Valor3
      AND DET.VALOR4             = Cv_Valor4
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;

    Lv_Aplicativo                   VARCHAR2(200);
    Lt_ArrayConsultasXAplicativo    DB_COMERCIAL.TECNK_SERVICIOS.Lt_ArrayAsociativo;

  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_CodEmpresa       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strCodEmpresa'));
    Lv_PrefijoEmpresa   := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strPrefijoEmpresa'));
    Lv_Aplicativo       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strAplicativo'));

    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object; -- {
    DB_COMERCIAL.TECNK_SERVICIOS.P_GET_INFOCLIENTE_INTERNET_WS( Pcl_JsonFiltrosBusqueda,
                                                                Lv_Status,
                                                                Lv_MsjError,
                                                                Lrf_RegistrosClienteInternet);
    IF Lv_Status = 'OK' THEN
      Lv_Status             := '';
      Lv_MsjError           := '';
      Lv_NombreParamGeneral := Lv_NombreParamGeneral || Lv_PrefijoEmpresa;

      IF Lv_Aplicativo IS NOT NULL THEN 
        IF Lc_GetConsultasPorAplicativo%ISOPEN THEN
        CLOSE Lc_GetConsultasPorAplicativo;
        END IF;
        FOR I_GetConsultasPorAplicativo IN Lc_GetConsultasPorAplicativo(Lv_NombreParamGeneral, Lv_ParamsWebServices, Lv_NombreWebService, 
                                          Lv_BusquedasPermitXAplicativo, Lv_Aplicativo, Lv_CodEmpresa)
        LOOP
          Lt_ArrayConsultasXAplicativo(I_GetConsultasPorAplicativo.CONSULTA_PERMITIDA) := I_GetConsultasPorAplicativo.CONSULTA_PERMITIDA;
        END LOOP;
      END IF;

      IF Lc_GetNumValor4Parametro%ISOPEN THEN
      CLOSE Lc_GetNumValor4Parametro;
      END IF;
      OPEN Lc_GetNumValor4Parametro(Lv_NombreParamGeneral, Lv_ParamsWebServices, Lv_NombreWebService, Lv_NumMaximoFactWebService, Lv_CodEmpresa);
      FETCH Lc_GetNumValor4Parametro INTO Ln_NumFacturas;
      CLOSE Lc_GetNumValor4Parametro;

      IF Lc_GetNumValor4Parametro%ISOPEN THEN
      CLOSE Lc_GetNumValor4Parametro;
      END IF;
      OPEN Lc_GetNumValor4Parametro(Lv_NombreParamGeneral, Lv_ParamsWebServices, Lv_NombreWebService, Lv_NumMaximoPagosWebService, Lv_CodEmpresa);
      FETCH Lc_GetNumValor4Parametro INTO Ln_NumPagos;
      CLOSE Lc_GetNumValor4Parametro;

      IF Ln_NumFacturas IS NULL THEN 
        Ln_NumFacturas := 1;
      END IF;

      IF Ln_NumPagos IS NULL THEN 
        Ln_NumPagos := 1;
      END IF;

      Lv_TienePuntosCliente := '';
      LOOP
        FETCH Lrf_RegistrosClienteInternet BULK COLLECT
        INTO Lt_TRegInfoClienteInternetWs LIMIT 100;
        Ln_IndxRegInfoClienteInternet := Lt_TRegInfoClienteInternetWs.FIRST;
        WHILE (Ln_IndxRegInfoClienteInternet IS NOT NULL)
        LOOP
          Lv_TieneInfoCliente         := 'SI';
          Lr_RegInfoClienteInternetWs := Lt_TRegInfoClienteInternetWs(Ln_IndxRegInfoClienteInternet);
          IF Lr_RegInfoClienteInternetWs.ID_SERVICIO_INTERNET IS NOT NULL THEN
            Lv_TieneServicioInternet := 'SI';
            IF Lv_EscribioInfoCliente = 'NO' THEN
              APEX_JSON.write('strStatus', Lv_StatusOK);
              APEX_JSON.write('strMensaje', Lv_MensajeOK);
              APEX_JSON.open_object('arrayData'); -- arrayData {
              APEX_JSON.write('cliente', Lr_RegInfoClienteInternetWs.CLIENTE);
              APEX_JSON.write('identificacion', Lr_RegInfoClienteInternetWs.IDENTIFICACION_CLIENTE);
              IF Lc_GetCorreosPersona%ISOPEN THEN
                CLOSE Lc_GetCorreosPersona;
              END IF;
              OPEN Lc_GetCorreosPersona(Lr_RegInfoClienteInternetWs.ID_PERSONA);
              FETCH Lc_GetCorreosPersona INTO Lv_CorreosPer;
              CLOSE Lc_GetCorreosPersona;
              APEX_JSON.write('correos', Lv_CorreosPer);

              APEX_JSON.write('id_oficina', TO_CHAR(Lr_RegInfoClienteInternetWs.OFICINA_ID));

              Lv_CicloFacturacionPer    := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_INFO_CLIENTE_CICLOFAC('CICLO_FACTURACION', 
                                                                                                           Lr_RegInfoClienteInternetWs.ID_PERSONA_ROL);
              APEX_JSON.write('ciclo_facturacion', Lv_CicloFacturacionPer);

              Lv_FormaPagoPer           := DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(Lr_RegInfoClienteInternetWs.ID_PERSONA_ROL, NULL);
              APEX_JSON.write('forma_pago', Lv_FormaPagoPer);

              Lv_NumeroContratoPer      := DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI('NUMERO_CONTRATO', 
                                                                                                          Lr_RegInfoClienteInternetWs.ID_PERSONA_ROL, 
                                                                                                          Lr_RegInfoClienteInternetWs.ESTADO_PERSONA_ROL);
              APEX_JSON.write('contrato', Lv_NumeroContratoPer);

              Lv_TipoCuentaPer          := DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI('DESCRIPCION_CUENTA', 
                                                                                                          Lr_RegInfoClienteInternetWs.ID_PERSONA_ROL, 
                                                                                                          Lr_RegInfoClienteInternetWs.ESTADO_PERSONA_ROL);
              APEX_JSON.write('tipo_cuenta', Lv_TipoCuentaPer);

              Ld_FechaMaximaPagoPer     := DB_FINANCIERO.FNCK_FACTURACION.F_WS_FECHA_PAGO_FACTURA(Lr_RegInfoClienteInternetWs.ID_PERSONA_ROL,
                                                                                                    Lv_CodEmpresa);
              IF Ld_FechaMaximaPagoPer IS NOT NULL THEN
                Lv_FechaMaximaPagoPer  := TO_CHAR(Ld_FechaMaximaPagoPer, 'YYYY-MM-DD HH24:MI:SS');
              END IF;
              APEX_JSON.write('fecha_maxima_pago', Lv_FechaMaximaPagoPer);

              Ln_SaldoPer := 0;
              IF Lc_GetSaldoPer%ISOPEN THEN
                CLOSE Lc_GetSaldoPer;
              END IF;
              OPEN Lc_GetSaldoPer(Lr_RegInfoClienteInternetWs.IDENTIFICACION_CLIENTE, Lv_CodEmpresa);
              FETCH Lc_GetSaldoPer INTO Ln_SaldoPer;
              CLOSE Lc_GetSaldoPer;

              Ln_ValorPendienteTotalPer := 0;
              IF Lc_GetSumaValorPendientePer%ISOPEN THEN
                CLOSE Lc_GetSumaValorPendientePer;
              END IF;
              OPEN Lc_GetSumaValorPendientePer(Lr_RegInfoClienteInternetWs.IDENTIFICACION_CLIENTE, Lv_CodEmpresa);
              FETCH Lc_GetSumaValorPendientePer INTO Ln_ValorPendienteTotalPer;
              CLOSE Lc_GetSumaValorPendientePer;

              IF (Ln_SaldoPer IS NOT NULL AND Ln_ValorPendienteTotalPer IS NOT NULL) THEN
                Ln_SaldoPer := ROUND(Ln_SaldoPer - Ln_ValorPendienteTotalPer, 4) ;
              END IF;
              APEX_JSON.write('deuda_total', Ln_SaldoPer);
              APEX_JSON.open_array('puntos'); -- puntos: [
              Lv_EscribioInfoCliente := 'SI';
            END IF;
            
            Lcl_JsonFiltrosBusquedaXPunto   := '{
                                                    "strCodEmpresa": "' || Lv_CodEmpresa || '",
                                                    "strPrefijoEmpresa": "' || Lv_PrefijoEmpresa || '",
                                                    "intIdPunto": ' || Lr_RegInfoClienteInternetWs.ID_PUNTO || '
                                                }';
            DB_COMERCIAL.TECNK_SERVICIOS.P_GET_INFOCLIENTE_PUNTO_WS(Lcl_JsonFiltrosBusquedaXPunto,
                                                                    Lv_Status,
                                                                    Lv_MsjError,
                                                                    Lrf_RegistrosClientePunto);
            IF Lv_Status = 'OK' THEN
              Lv_Status                 := '';
              Lv_MsjError               := '';
              --Lv_TieneDataTecnicaXPunto := '';
              --Lcl_InfoDataTecnica       := '';
              LOOP
                FETCH Lrf_RegistrosClientePunto BULK COLLECT
                INTO Lt_TRegInfoClientePuntoWs LIMIT 100;
                Ln_IndxRegInfoClientePunto := Lt_TRegInfoClientePuntoWs.FIRST;
                WHILE (Ln_IndxRegInfoClientePunto IS NOT NULL)
                LOOP
                  Lv_TieneServiciosXPunto       := '';
                  Lcl_ServiciosXPuntoRespuesta  := '';
                  Lr_RegInfoClientePuntoWs      := Lt_TRegInfoClientePuntoWs(Ln_IndxRegInfoClientePunto);
                  APEX_JSON.open_object; -- {
                  APEX_JSON.write('id_punto', TO_CHAR(Lr_RegInfoClientePuntoWs.ID_PUNTO));
                  APEX_JSON.write('login', Lr_RegInfoClientePuntoWs.LOGIN );
                  APEX_JSON.write('cobertura', Lr_RegInfoClientePuntoWs.NOMBRE_JURISDICCION);
                  APEX_JSON.write('direccion', Lr_RegInfoClientePuntoWs.DIRECCION);
                  APEX_JSON.write('ciudad', Lr_RegInfoClientePuntoWs.NOMBRE_CANTON);
                  APEX_JSON.write('sector', Lr_RegInfoClientePuntoWs.NOMBRE_SECTOR);
                  APEX_JSON.write('longitud', Lr_RegInfoClientePuntoWs.LONGITUD);
                  APEX_JSON.write('latitud', Lr_RegInfoClientePuntoWs.LATITUD);
                  APEX_JSON.write('estado', Lr_RegInfoClientePuntoWs.ESTADO_PUNTO);
                  APEX_JSON.write('telefonos', Lr_RegInfoClientePuntoWs.TELEFONOS);
                  APEX_JSON.write('correos', Lr_RegInfoClientePuntoWs.CORREOS);
                  APEX_JSON.write('saldo', TRIM(TO_CHAR(Lr_RegInfoClientePuntoWs.SALDO,'99999999990D99')));
                  APEX_JSON.open_array('servicios'); -- servicios: [
                  DB_COMERCIAL.TECNK_SERVICIOS.P_GET_INFOCLIENTE_SERVICIO_WS(   Lcl_JsonFiltrosBusquedaXPunto,
                                                                                Lv_Status,
                                                                                Lv_MsjError,
                                                                                Lrf_RegistrosClienteServicios);
                  IF Lv_Status = 'OK' THEN
                    Lv_Status     := '';
                    Lv_MsjError   := '';
                    LOOP
                      FETCH Lrf_RegistrosClienteServicios BULK COLLECT
                      INTO Lt_TRegInfoClienteServiciosWs LIMIT 100;
                      Ln_IndxRegInfoClienteServicios := Lt_TRegInfoClienteServiciosWs.FIRST;
                      WHILE (Ln_IndxRegInfoClienteServicios IS NOT NULL)
                      LOOP
                        Lv_TieneCaractsServicioXPunto   := '';
                        Lcl_CaractsServicioXPunto       := '';
                        Lr_RegInfoClienteServiciosWs    := Lt_TRegInfoClienteServiciosWs(Ln_IndxRegInfoClienteServicios);

                        APEX_JSON.open_object; -- {
                        APEX_JSON.write('id_servicio', TO_CHAR(Lr_RegInfoClienteServiciosWs.ID_SERVICIO));
                        APEX_JSON.write('codigo_producto', Lr_RegInfoClienteServiciosWs.CODIGO_PROD_PLAN_PRODUCTO);
                        
                        IF (Lr_RegInfoClienteServiciosWs.ID_SERVICIO = Lr_RegInfoClienteInternetWs.ID_SERVICIO_INTERNET
                            AND Lr_RegInfoClienteServiciosWs.ID_PROD_PLAN_PRODUCTO = Lr_RegInfoClienteInternetWs.ID_PRODUCTO_INTERNET) THEN
                          IF Lr_RegInfoClienteServiciosWs.ID_PLAN IS NOT NULL THEN
                            APEX_JSON.write('cod_plan', Lr_RegInfoClienteServiciosWs.CODIGO_PLAN);
                          END IF;
                          Ln_IdServicioDataTenica   := Lr_RegInfoClienteServiciosWs.ID_SERVICIO;
                        END IF;

                        APEX_JSON.write('producto', Lr_RegInfoClienteServiciosWs.DESCRIPCION_PROD_PLAN_PRODUCTO);
                        APEX_JSON.write('ultima_milla', Lr_RegInfoClienteServiciosWs.NOMBRE_TIPO_MEDIO);
                        APEX_JSON.write('id_plan', TO_CHAR(Lr_RegInfoClienteServiciosWs.ID_PLAN));
                        APEX_JSON.write('plan', Lr_RegInfoClienteServiciosWs.NOMBRE_PLAN);
                        

                        APEX_JSON.open_array('caracteristicas'); -- caracteristicas: [
                        APEX_JSON.open_array; -- [
                        IF Lr_RegInfoClienteServiciosWs.ID_PLAN IS NOT NULL THEN
                          FOR I_GetCaracteristicasPlan IN Lc_GetCaracteristicasPlan(Lr_RegInfoClienteServiciosWs.ID_PLAN,
                                                                                    Lr_RegInfoClienteServiciosWs.ID_PROD_PLAN_PRODUCTO)
                          LOOP
                            APEX_JSON.open_object; -- {
                            APEX_JSON.write('nombre', I_GetCaracteristicasPlan.DESCRIPCION_CARACTERISTICA);
                            APEX_JSON.write('valor', I_GetCaracteristicasPlan.VALOR);
                            APEX_JSON.close_object; -- } caracteristica
                          END LOOP;

                        ELSE
                          FOR I_GetCaracteristicasProd IN Lc_GetCaracteristicasProd(Lr_RegInfoClienteServiciosWs.ID_SERVICIO)
                          LOOP
                            APEX_JSON.open_object; -- {
                            APEX_JSON.write('nombre', I_GetCaracteristicasProd.DESCRIPCION_CARACTERISTICA);
                            APEX_JSON.write('valor', I_GetCaracteristicasProd.VALOR);
                            APEX_JSON.close_object; -- } caracteristica
                          END LOOP;
                        END IF;

                        APEX_JSON.close_array; -- ]
                        APEX_JSON.close_array; -- ] caracteristicas

                        APEX_JSON.write('estado', Lr_RegInfoClienteServiciosWs.ESTADO_SERVICIO);
                        APEX_JSON.write('login_aux', Lr_RegInfoClienteServiciosWs.LOGIN_AUX);
                        APEX_JSON.write('valor', Lr_RegInfoClienteServiciosWs.PRECIO);
                        APEX_JSON.close_object; -- } servicio
                        IF Lv_ProductoKonibit = 'NO' THEN 
                          Lv_RespuestaKonibit := DB_INFRAESTRUCTURA.INFRKG_KONIBIT.F_SERVICIO_CARACTERISTICA(Lr_RegInfoClienteServiciosWs.ID_SERVICIO,
                                                                                                             'KONIBIT');
                          IF Lv_RespuestaKonibit = 'True' THEN
                            Lv_ProductoKonibit := 'SI';
                          END IF;
                        END IF;
                        Lv_TieneServiciosXPunto         := 'SI';
                        Ln_IndxRegInfoClienteServicios  := Lt_TRegInfoClienteServiciosWs.NEXT(Ln_IndxRegInfoClienteServicios);
                      END LOOP;
                      EXIT
                      WHEN Lrf_RegistrosClienteServicios%NOTFOUND;
                    END LOOP;
                    CLOSE Lrf_RegistrosClienteServicios;
                  END IF;
                  APEX_JSON.close_array; -- ] servicios

                  APEX_JSON.open_object('data_tecnica'); -- data_tecnica {
                  IF Ln_IdServicioDataTenica IS NOT NULL THEN
                    DB_COMERCIAL.TECNK_SERVICIOS.P_WS_GET_INF_SERVICIO_INTERNET(  Ln_IdServicioDataTenica,
                                                                                  Lrf_RegistrosDataTecnica,
                                                                                  Lv_Status,
                                                                                  Lv_MsjError
                                                                               );
                    IF Lv_Status = 'OK' THEN
                      Lv_Status   := '';
                      Lv_MsjError := '';
                      LOOP
                        FETCH Lrf_RegistrosDataTecnica BULK COLLECT
                        INTO Lt_TRegInfoDataTecnicaWs LIMIT 100;
                        Ln_IndxRegInfoDataTecnica := Lt_TRegInfoDataTecnicaWs.FIRST;
                        WHILE (Ln_IndxRegInfoDataTecnica IS NOT NULL)
                        LOOP
                          Lr_RegInfoDataTecnicaWs     := Lt_TRegInfoDataTecnicaWs(Ln_IndxRegInfoDataTecnica);

                          APEX_JSON.write('elemento', Lr_RegInfoDataTecnicaWs.ELEMENTO);
                          APEX_JSON.write('ip_elemento', Lr_RegInfoDataTecnicaWs.IP_ELEMENTO);
                          APEX_JSON.write('modelo_elemento', Lr_RegInfoDataTecnicaWs.MODELO_ELEMENTO);
                          APEX_JSON.write('marca_elemento', Lr_RegInfoDataTecnicaWs.MARCA_ELEMENTO);
                          APEX_JSON.write('interface_elemento', Lr_RegInfoDataTecnicaWs.INTERFACE_ELEMENTO);
                          APEX_JSON.write('elemento_contenedor', Lr_RegInfoDataTecnicaWs.ELEMENTO_CONTENEDOR);
                          APEX_JSON.write('elemento_conector', Lr_RegInfoDataTecnicaWs.ELEMENTO_CONECTOR);
                          APEX_JSON.write('interface_elemento_conector', Lr_RegInfoDataTecnicaWs.INTERFACE_ELEMENTO_CONECTOR );
                          APEX_JSON.write('indice_cliente', Lr_RegInfoDataTecnicaWs.INDICE_CLIENTE);
                          IF Lr_RegInfoDataTecnicaWs.LINE_PROFILE IS NOT NULL THEN
                            APEX_JSON.write('line_profile', Lr_RegInfoDataTecnicaWs.LINE_PROFILE);
                          ELSE
                            APEX_JSON.write('line_profile', Lr_RegInfoDataTecnicaWs.PERFIL);
                          END IF;
                          APEX_JSON.write('service_port', Lr_RegInfoDataTecnicaWs.SERVICE_PORT);
                          APEX_JSON.write('gemport', Lr_RegInfoDataTecnicaWs.GEMPORT);
                          APEX_JSON.write('traffic_table', Lr_RegInfoDataTecnicaWs.TRAFFIC_TABLE);
                          IF Lr_RegInfoDataTecnicaWs.LINE_PROFILE_PROMO IS NOT NULL THEN
                            APEX_JSON.write('line_profile_promo', Lr_RegInfoDataTecnicaWs.LINE_PROFILE_PROMO);
                          ELSE
                            APEX_JSON.write('line_profile_promo', Lr_RegInfoDataTecnicaWs.PERFIL_PROMO);
                          END IF;
                          APEX_JSON.write('gemport_promo', Lr_RegInfoDataTecnicaWs.GEMPORT_PROMO);
                          APEX_JSON.write('traffic_table_promo', Lr_RegInfoDataTecnicaWs.TRAFFIC_TABLE_PROMO);
                          APEX_JSON.write('vlan', Lr_RegInfoDataTecnicaWs.VLAN);
                          APEX_JSON.write('serial_ont', Lr_RegInfoDataTecnicaWs.SERIE_ONT);
                          APEX_JSON.write('mac_ont', Lr_RegInfoDataTecnicaWs.MAC_ONT);
                          APEX_JSON.write('modelo_ont', Lr_RegInfoDataTecnicaWs.MODELO_ONT);
                          APEX_JSON.write('marca_ont', Lr_RegInfoDataTecnicaWs.MARCA_ONT);
                          APEX_JSON.write('tipo_aprovisionamiento', Lr_RegInfoDataTecnicaWs.APROVISIONAMIENTO);
                          APEX_JSON.write('ipv4', Lr_RegInfoDataTecnicaWs.IPV4);
                          Ln_IndxRegInfoDataTecnica := Lt_TRegInfoDataTecnicaWs.NEXT(Ln_IndxRegInfoDataTecnica);
                        END LOOP;
                        EXIT
                        WHEN Lrf_RegistrosDataTecnica%NOTFOUND;
                      END LOOP;
                      CLOSE Lrf_RegistrosDataTecnica;
                    END IF;
                  END IF;
                  APEX_JSON.close_object; -- } data_tecnica
                  
                  APEX_JSON.open_array('facturas'); -- facturas: [
                  IF Lt_ArrayConsultasXAplicativo.EXISTS('FACTURAS') THEN
                    DB_FINANCIERO.FNCK_FACTURACION.P_WS_ULTIMAS_FACTURAS_X_PUNTO( Lr_RegInfoClientePuntoWs.ID_PUNTO,
                                                                                  Ln_NumFacturas,
                                                                                  Lrf_CursorFacturasPunto,
                                                                                  Lv_Status,
                                                                                  Lv_MsjError);
                    IF Lv_Status = 'OK' THEN
                      Lv_Status   := '';
                      Lv_MsjError := '';
                      LOOP
                        FETCH Lrf_CursorFacturasPunto BULK COLLECT
                        INTO Lt_TRegInfoFacturaXPuntoWs LIMIT 100;
                        Ln_IndxRegFacturasXPunto := Lt_TRegInfoFacturaXPuntoWs.FIRST;
                        WHILE (Ln_IndxRegFacturasXPunto IS NOT NULL)
                        LOOP
                          Lr_RegInfoFacturaXPuntoWs := Lt_TRegInfoFacturaXPuntoWs(Ln_IndxRegFacturasXPunto);
                          APEX_JSON.open_object; -- {
                          APEX_JSON.write('id_documento', TO_CHAR(Lr_RegInfoFacturaXPuntoWs.ID_DOCUMENTO));
                          APEX_JSON.write('numero_factura_sri', Lr_RegInfoFacturaXPuntoWs.NUMERO_FACTURA_SRI);
                          APEX_JSON.write('valor_total', Lr_RegInfoFacturaXPuntoWs.VALOR_TOTAL);
                          APEX_JSON.write('estado_impresion_fact', Lr_RegInfoFacturaXPuntoWs.ESTADO_IMPRESION_FACT);

                          Lv_FechaEmision := '';
                          IF Lr_RegInfoFacturaXPuntoWs.FE_EMISION IS NOT NULL THEN
                            Lv_FechaEmision  := TO_CHAR(Lr_RegInfoFacturaXPuntoWs.FE_EMISION, 'DD-MON-YYYY');
                          END IF;
                          APEX_JSON.write('fe_emision', Lv_FechaEmision);

                          Lv_DescripcionProdFactura := '';
                          DB_FINANCIERO.FNCK_FACTURACION.P_DESCRI_PRODUCTOS_X_FACTURA(  Lr_RegInfoFacturaXPuntoWs.ID_DOCUMENTO,
                                                                                        Lrf_DescripcionProdFactura,
                                                                                        Lv_Status,
                                                                                        Lv_MsjError); 
                          IF Lv_Status = 'OK' THEN
                            Lv_Status   := '';
                            Lv_MsjError := '';
                            LOOP
                              FETCH Lrf_DescripcionProdFactura BULK COLLECT INTO Lt_ArrayData LIMIT 100;
                              Ln_IndxArrayData := Lt_ArrayData.FIRST;
                              WHILE (Ln_IndxArrayData IS NOT NULL)
                              LOOP
                                Lv_DescripcionProdFactura := Lt_ArrayData(Ln_IndxArrayData);
                                Ln_IndxArrayData          := Lt_ArrayData.NEXT(Ln_IndxArrayData);
                              END LOOP;
                              EXIT WHEN Lrf_DescripcionProdFactura%NOTFOUND;
                            END LOOP;
                            CLOSE Lrf_DescripcionProdFactura;
                          END IF;
                          APEX_JSON.write('descripcion_producto', Lv_DescripcionProdFactura);
                          APEX_JSON.close_object; -- } factura
                          Ln_IndxRegFacturasXPunto  := Lt_TRegInfoFacturaXPuntoWs.NEXT(Ln_IndxRegFacturasXPunto);
                        END LOOP;
                        EXIT
                      WHEN Lrf_CursorFacturasPunto%NOTFOUND;
                      END LOOP;
                      CLOSE Lrf_CursorFacturasPunto;
                    END IF;
                  END IF;
                  APEX_JSON.close_array; -- ] facturas

                  APEX_JSON.open_array('pagos'); -- pagos: [
                  IF Lt_ArrayConsultasXAplicativo.EXISTS('PAGOS') THEN
                    DB_FINANCIERO.FNCK_FACTURACION.P_WS_ULTIMOS_PAGOS_X_PUNTO(Lr_RegInfoClientePuntoWs.ID_PUNTO,
                                                                              Ln_NumPagos,
                                                                              Lrf_CursorPagosPunto,
                                                                              Lv_Status,
                                                                              Lv_MsjError);
                    IF Lv_Status = 'OK' THEN
                      Lv_Status   := '';
                      Lv_MsjError := '';
                      LOOP
                        FETCH Lrf_CursorPagosPunto BULK COLLECT
                        INTO Lt_TRegInfoPagoXPuntoWs LIMIT 100;
                        Ln_IndxRegPagosXPunto := Lt_TRegInfoPagoXPuntoWs.FIRST;
                        WHILE (Ln_IndxRegPagosXPunto IS NOT NULL)
                        LOOP
                          Lr_RegInfoPagoXPuntoWs := Lt_TRegInfoPagoXPuntoWs(Ln_IndxRegPagosXPunto);
                          APEX_JSON.open_object; -- {
                          APEX_JSON.write('numero_pago', Lr_RegInfoPagoXPuntoWs.NUMERO_PAGO);
                          APEX_JSON.write('valor_total', Lr_RegInfoPagoXPuntoWs.VALOR_TOTAL);
                          APEX_JSON.write('estado_pago', Lr_RegInfoPagoXPuntoWs.ESTADO_PAGO);
                          Lv_FechaCreacion := '';
                          IF Lr_RegInfoPagoXPuntoWs.FE_CREACION IS NOT NULL THEN
                            Lv_FechaCreacion := TO_CHAR(Lr_RegInfoPagoXPuntoWs.FE_CREACION, 'DD-MON-YYYY HH24:MI:SS');
                          END IF;
                          APEX_JSON.write('fe_creacion', Lv_FechaCreacion);
                          APEX_JSON.close_object; -- } pago
                          Ln_IndxRegPagosXPunto  := Lt_TRegInfoPagoXPuntoWs.NEXT(Ln_IndxRegPagosXPunto);
                        END LOOP;
                        EXIT
                      WHEN Lrf_CursorPagosPunto%NOTFOUND;
                      END LOOP;
                      CLOSE Lrf_CursorPagosPunto;
                    END IF;
                  END IF;
                  APEX_JSON.close_array; -- ] pagos

                  Lv_FechaActivacion := '';
                  DB_FINANCIERO.FNCK_FACTURACION.P_WS_FECHA_FIRMA_CONTRATO( Lr_RegInfoClientePuntoWs.ID_PUNTO,
                                                                            Lrf_FechaFirmaContrato,
                                                                            Lv_Status,
                                                                            Lv_MsjError);

                  IF Lv_Status = 'OK' THEN
                    Lv_Status   := '';
                    Lv_MsjError := '';
                    LOOP
                      FETCH Lrf_FechaFirmaContrato BULK COLLECT INTO Lt_ArrayData LIMIT 100;
                      Ln_IndxArrayData := Lt_ArrayData.FIRST;
                      WHILE (Ln_IndxArrayData IS NOT NULL)
                      LOOP
                        Lv_FechaActivacion := Lt_ArrayData(Ln_IndxArrayData);
                        Ln_IndxArrayData := Lt_ArrayData.NEXT(Ln_IndxArrayData);
                      END LOOP;
                      EXIT WHEN Lrf_FechaFirmaContrato%NOTFOUND;
                    END LOOP;
                  END IF;
                  APEX_JSON.write('fecha_activacion', Lv_FechaActivacion);

                  APEX_JSON.write('tipo_negocio', Lr_RegInfoClientePuntoWs.NOMBRE_TIPO_NEGOCIO);
                  
                  APEX_JSON.open_array('ip_fija'); -- ip_fija: [
                  DB_COMERCIAL.TECNK_SERVICIOS.P_WS_GET_IPS_POR_PUNTO(  Lr_RegInfoClientePuntoWs.ID_PUNTO,
                                                                        Lrf_CursorIpsPunto,
                                                                        Lv_Status,
                                                                        Lv_MsjError);
                  IF Lv_Status = 'OK' THEN
                    Lv_Status   := '';
                    Lv_MsjError := '';
                    LOOP
                      FETCH Lrf_CursorIpsPunto BULK COLLECT
                      INTO Lt_TRegInfoIpXPuntoWs LIMIT 100;
                      Ln_IndxRegIpXPunto := Lt_TRegInfoIpXPuntoWs.FIRST;
                      WHILE (Ln_IndxRegIpXPunto IS NOT NULL)
                      LOOP
                        Lr_RegInfoIpXPuntoWs := Lt_TRegInfoIpXPuntoWs(Ln_IndxRegIpXPunto);
                        APEX_JSON.open_object; -- {
                        APEX_JSON.write('valor', Lr_RegInfoIpXPuntoWs.IP);
                        APEX_JSON.write('mac', Lr_RegInfoIpXPuntoWs.MAC);
                        APEX_JSON.write('mascara', Lr_RegInfoIpXPuntoWs.MASCARA );
                        APEX_JSON.write('scope', Lr_RegInfoIpXPuntoWs.SCOPE_IP);
                        APEX_JSON.write('pool_ip', Lr_RegInfoIpXPuntoWs.POOL_IP);
                        APEX_JSON.close_object; -- } ip
                        Ln_IndxRegIpXPunto  := Lt_TRegInfoIpXPuntoWs.NEXT(Ln_IndxRegIpXPunto);
                      END LOOP;
                      EXIT
                    WHEN Lrf_CursorIpsPunto%NOTFOUND;
                    END LOOP;
                    CLOSE Lrf_CursorIpsPunto;
                  END IF;
                  APEX_JSON.close_array; -- ] ip_fija

                  APEX_JSON.open_array('casos'); -- casos: [
                  IF Lt_ArrayConsultasXAplicativo.EXISTS('CASOS') THEN
                    DB_COMERCIAL.TECNK_SERVICIOS.P_WS_GET_CASOS_POR_PUNTO(Lr_RegInfoClientePuntoWs.LOGIN,
                                                                          Lrf_CursorCasosPunto,
                                                                          Lv_Status,
                                                                          Lv_MsjError);
                    IF Lv_Status = 'OK' THEN
                      Lv_Status   := '';
                      Lv_MsjError := '';
                      LOOP
                        FETCH Lrf_CursorCasosPunto BULK COLLECT
                        INTO Lt_TRegInfoCasoXPuntoWs LIMIT 100;
                        Ln_IndxRegCasoXPunto := Lt_TRegInfoCasoXPuntoWs.FIRST;
                        WHILE (Ln_IndxRegCasoXPunto IS NOT NULL)
                        LOOP
                          Lr_RegInfoCasoXPuntoWs := Lt_TRegInfoCasoXPuntoWs(Ln_IndxRegCasoXPunto);
                          APEX_JSON.open_object; -- {
                          APEX_JSON.write('id_caso', TO_CHAR(Lr_RegInfoCasoXPuntoWs.ID_CASO));
                          APEX_JSON.write('numero_caso', Lr_RegInfoCasoXPuntoWs.NUMERO_CASO);
                          APEX_JSON.write('caso', Lr_RegInfoCasoXPuntoWs.CASO);
                          APEX_JSON.write('estado', Lr_RegInfoCasoXPuntoWs.ESTADO);
                          APEX_JSON.write('fecha_creacion', Lr_RegInfoCasoXPuntoWs.FE_CREACION);
                          APEX_JSON.write('fecha_cierre', Lr_RegInfoCasoXPuntoWs.FE_CIERRE);
                          APEX_JSON.close_object; -- } pago
                          Ln_IndxRegCasoXPunto  := Lt_TRegInfoCasoXPuntoWs.NEXT(Ln_IndxRegCasoXPunto);
                        END LOOP;
                        EXIT
                      WHEN Lrf_CursorCasosPunto%NOTFOUND;
                      END LOOP;
                      CLOSE Lrf_CursorCasosPunto;
                    END IF;
                  END IF;
                  APEX_JSON.close_array; -- ] casos

                  APEX_JSON.open_array('tareas'); -- tareas: [
                  IF Lt_ArrayConsultasXAplicativo.EXISTS('TAREAS') THEN
                    DB_COMERCIAL.TECNK_SERVICIOS.P_WS_GET_TAREAS_POR_PUNTO(   Lr_RegInfoClientePuntoWs.LOGIN,
                                                                              Lrf_CursorTareasPunto,
                                                                              Lv_Status,
                                                                              Lv_MsjError);
                    IF Lv_Status = 'OK' THEN
                      Lv_Status   := '';
                      Lv_MsjError := '';
                      LOOP
                        FETCH Lrf_CursorTareasPunto BULK COLLECT
                        INTO Lt_TRegInfoTareaXPuntoWs LIMIT 100;
                        Ln_IndxRegTareaXPunto := Lt_TRegInfoTareaXPuntoWs.FIRST;
                        WHILE (Ln_IndxRegTareaXPunto IS NOT NULL)
                        LOOP
                          Lr_RegInfoTareaXPuntoWs := Lt_TRegInfoTareaXPuntoWs(Ln_IndxRegTareaXPunto);
                          APEX_JSON.open_object; -- {
                          APEX_JSON.write('numero_tarea', Lr_RegInfoTareaXPuntoWs.NUMERO_TAREA);
                          APEX_JSON.write('tarea', Lr_RegInfoTareaXPuntoWs.TAREA);
                          APEX_JSON.write('estado', Lr_RegInfoTareaXPuntoWs.ESTADO);
                          APEX_JSON.write('fecha_creacion', Lr_RegInfoTareaXPuntoWs.FE_CREACION);
                          APEX_JSON.write('fecha_finalizacion', Lr_RegInfoTareaXPuntoWs.FE_FINALIZACION);
                          APEX_JSON.close_object; -- } tarea
                          Ln_IndxRegTareaXPunto  := Lt_TRegInfoTareaXPuntoWs.NEXT(Ln_IndxRegTareaXPunto);
                        END LOOP;
                        EXIT
                      WHEN Lrf_CursorTareasPunto%NOTFOUND;
                      END LOOP;
                      CLOSE Lrf_CursorTareasPunto;
                    END IF;
                  END IF;
                  APEX_JSON.close_array; -- ] tareas

                  APEX_JSON.close_object; -- } punto
                  Lv_TienePuntosCliente := 'SI';
                  Ln_IndxRegInfoClientePunto := Lt_TRegInfoClientePuntoWs.NEXT(Ln_IndxRegInfoClientePunto);
                END LOOP;
                EXIT
                WHEN Lrf_RegistrosClientePunto%NOTFOUND;
              END LOOP;
              CLOSE Lrf_RegistrosClientePunto;
            END IF;
          END IF;
          Ln_IndxRegInfoClienteInternet := Lt_TRegInfoClienteInternetWs.NEXT(Ln_IndxRegInfoClienteInternet);
        END LOOP;
        EXIT
        WHEN Lrf_RegistrosClienteInternet%NOTFOUND;
      END LOOP;
      CLOSE Lrf_RegistrosClienteInternet;

      IF Lv_EscribioInfoCliente = 'SI' THEN
        APEX_JSON.close_array; -- ] puntos
        APEX_JSON.write('producto_konibit', Lv_ProductoKonibit);
        APEX_JSON.close_object; -- } data
      ELSIF Lv_TieneInfoCliente = 'NO' THEN
        APEX_JSON.write('strStatus', Lv_StatusError);
        APEX_JSON.write('strMensaje', 'No existe información del cliente consultado.');
      ELSIF Lv_TieneServicioInternet = 'NO' THEN
        APEX_JSON.write('strStatus', Lv_StatusError);
        APEX_JSON.write('strMensaje', 'No existe servicio de Internet asociado a los puntos del cliente consultado.');
        APEX_JSON.write('arrayData', '');
      END IF;
    ELSE
      APEX_JSON.write('strStatus', Lv_StatusError);
      APEX_JSON.write('strMensaje', Lv_MsjError);
    END IF;
    APEX_JSON.close_object; -- }
    Lcl_JsonRespuesta := apex_json.get_clob_output;
    APEX_JSON.free_output;
    Pv_Status           := 'OK';
    Pv_MsjError         := '';
    Pcl_JsonRespuesta   := Lcl_JsonRespuesta;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Lv_MsjError         := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_MsjError         := 'No se ha podido realizar correctamente la consulta. Por favor consultar con Sistemas!';
    Pcl_JsonRespuesta   := '{"strStatus":"' || Pv_Status || '","strMensaje":"' || Pv_MsjError || '"}';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'TECNK_SERVICIOS.P_GET_RESPUESTA_INFOCLIENTE_WS',
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_RESPUESTA_INFOCLIENTE_WS;

  PROCEDURE P_GET_INFOCLIENTE_INTERNET_ACS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Prf_Registros           OUT SYS_REFCURSOR)
  AS
    Lv_CodEmpresa                   DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
    Lv_Identificacion               DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE;
    Lv_Login                        DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Lv_SerieOnt                     DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE;
    Lv_MacOnt                       DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_TipoRol                      DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE;
    Lv_NombreParamGeneral           VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ParamsWebServices            VARCHAR2(30) := 'PARAMETROS_WEB_SERVICES_ACS';
    Lv_NombreWebService             VARCHAR2(20) := 'INFORMACION_CLIENTE';
    Lv_ParamEstadosPer              VARCHAR2(39) := 'ESTADOS_PERSONA_EMPRESA_ROL_PERMITIDOS';
    Lv_ParamEstadosOntServInternet  VARCHAR2(32) := 'ESTADOS_ONT_INTERNET_PERMITIDOS';
    Lv_ParamEstadosServInternet     VARCHAR2(37) := 'ESTADOS_SERVICIO_INTERNET_PERMITIDOS';
    Lv_ParamNombresTecnInternet     VARCHAR2(37) := 'NOMBRES_TECNICOS_INTERNET_PERMITIDOS';
    Lv_ParamDescripcionTelefonos    VARCHAR2(49) := 'DESCRIPCIONES_FORMA_CONTACTO_TELEFONO_PERMITIDOS';
    Lv_ParamDescripcionCorreo       VARCHAR2(49) := 'Correo Electronico';
    Lv_DescripCaractMacOnt          VARCHAR2(8)  := 'MAC ONT';
    Lv_DescripCaractIndiceCliente   VARCHAR2(20) := 'INDICE CLIENTE';
    Lv_DescripCaractLineProfile     VARCHAR2(20) := 'LINE-PROFILE-NAME';
    Lv_DescripCaractVlan            VARCHAR2(20) := 'VLAN';
    Lv_EstadoEliminado              VARCHAR2(9)  := 'Eliminado';
    Lv_EstadoActivo                 VARCHAR2(6)  := 'Activo';
    Lcl_JsonFiltrosBusqueda         CLOB;
    Lcl_Select                      CLOB;
    Lcl_From                        CLOB;
    Lcl_Join                        CLOB;
    Lcl_Where                       CLOB;
    Lcl_ConsultaPrincipal           CLOB;
    Le_Exception                    EXCEPTION;
    Lv_MsjError                     VARCHAR2(4000);
  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_CodEmpresa           := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strCodEmpresa'));
    Lv_Identificacion       := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strIdentificacion'));
    Lv_Login                := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strLogin'));
    Lv_SerieOnt             := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strSerieOnt'));
    Lv_MacOnt               := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strMacOnt'));
    Lv_TipoRol              := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strTipoRol'));
    IF Lv_Identificacion IS NULL AND Lv_Login IS NULL AND Lv_SerieOnt IS NULL AND Lv_MacOnt IS NULL THEN
      Lv_MsjError := 'No se ha enviado alguno de los parámetros obligatorios para obtener la información del cliente';
      RAISE Le_Exception;
    END IF;

    IF Lv_CodEmpresa = '18' THEN
      Lv_NombreParamGeneral := Lv_NombreParamGeneral || 'MD';
    ELSIF Lv_CodEmpresa = '33' THEN
      Lv_NombreParamGeneral := Lv_NombreParamGeneral || 'EN';
    ELSE
      Lv_NombreParamGeneral := Lv_NombreParamGeneral || 'TN';
    END IF;

    Lcl_Select      := 'SELECT DISTINCT PERSONA_EMPRESA_ROL.ID_PERSONA_ROL,
                        PERSONA.IDENTIFICACION_CLIENTE,
                        CASE
                        WHEN PERSONA.RAZON_SOCIAL IS NOT NULL
                        THEN PERSONA.RAZON_SOCIAL
                        ELSE DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.NOMBRES)
                        || '' ''
                        || DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.APELLIDOS)
                        END CLIENTE,
                        SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_INTERNET,
                        TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_INTERNET, '''
                                                                       || Lv_DescripCaractMacOnt || ''') MAC_ONT,
                        TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_INTERNET, '''
                                                                       || Lv_DescripCaractIndiceCliente || ''') ONT_ID,
                        SERVICIO_INTERNET_X_PUNTO.IP_OLT,
                        (SELECT LISTAGG(PUNTO_FORMA_CONTACTO.VALOR, '','')
                            WITHIN GROUP (ORDER BY PUNTO_FORMA_CONTACTO.PUNTO_ID)
                            FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PUNTO_FORMA_CONTACTO
                            INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO FORMA_CONTACTO
                            ON FORMA_CONTACTO.ID_FORMA_CONTACTO = PUNTO_FORMA_CONTACTO.FORMA_CONTACTO_ID
                            WHERE PUNTO_FORMA_CONTACTO.PUNTO_ID = PUNTO.ID_PUNTO
                            AND FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO
                            IN
                            (
                                SELECT DISTINCT PARAM_DET.VALOR4
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                WHERE PARAM_CAB.NOMBRE_PARAMETRO =  ''' || Lv_NombreParamGeneral || '''
                                AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                                AND PARAM_DET.VALOR1 = ''' || Lv_ParamsWebServices || '''
                                AND PARAM_DET.VALOR2 = ''' || Lv_NombreWebService || '''
                                AND PARAM_DET.VALOR3 = ''' || Lv_ParamDescripcionTelefonos || '''
                                AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                                AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresa || '''
                            )
                            AND ROWNUM <=2)
                        AS TELEFONOS,
                        (SELECT LISTAGG(PERSONA_FORMA_CONTACTO.VALOR,'','') WITHIN GROUP (ORDER BY PERSONA_FORMA_CONTACTO.VALOR ) CORREOS
                            FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO PERSONA_FORMA_CONTACTO
                            INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO FORMA_CONTACTO
                            ON FORMA_CONTACTO.ID_FORMA_CONTACTO = PERSONA_FORMA_CONTACTO.FORMA_CONTACTO_ID
                            WHERE FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO = ''' || Lv_ParamDescripcionCorreo || '''
                            AND PERSONA_FORMA_CONTACTO.PERSONA_ID = PERSONA.ID_PERSONA
                            AND PERSONA_FORMA_CONTACTO.ESTADO =  ''' || Lv_EstadoActivo || '''
                            AND FORMA_CONTACTO.ESTADO =  ''' || Lv_EstadoActivo || ''')
                        AS CORREOS,
                        JURISDICCION.NOMBRE_JURISDICCION AS NOMBRE_JURISDICCION,
                        SERVICIO_INTERNET_X_PUNTO.NOMBRE_MARCA_ELEMENTO AS NOMBRE_MARCA_ELEMENTO,
                        SERVICIO_INTERNET_X_PUNTO.ESTADO_SERVICIO_INTERNET AS ESTADO_SERVICIO_INTERNET,
                        SERVICIO_INTERNET_X_PUNTO.SERIE_ONT AS SERIE_ONT,
                        SERVICIO_INTERNET_X_PUNTO.NOMBRE_OLT AS NOMBRE_OLT,
                        SERVICIO_INTERNET_X_PUNTO.INTERFACE_ELEMENTO AS INTERFACE_ELEMENTO,
                        CANTON.NOMBRE_CANTON AS NOMBRE_CANTON,
                        PUNTO.LOGIN AS LOGIN,
                        TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_INTERNET, '''
                                                                       || Lv_DescripCaractLineProfile || ''') LINE_PROFILE,
                        DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PUNTO.DIRECCION) AS DIRECCION,
                        PUNTO.LONGITUD AS LONGITUD,
                        PUNTO.LATITUD AS LATITUD,
                        ATN.NOMBRE_TIPO_NEGOCIO AS NOMBRE_TIPO_NEGOCIO,
                        SERVICIO_INTERNET_X_PUNTO.NOMBRE_PLAN AS NOMBRE_PLAN,
                        SERVICIO_INTERNET_X_PUNTO.DESCRIPCION_PRODUCTO AS NOMBRE_PRODUCTO,
                        SERVICIO_INTERNET_X_PUNTO.LOGIN_AUX_SERVICIO_INTERNET AS LOGIN_AUX_SERVICIO_INTERNET,
                        TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_INTERNET, '''
                                                                       || Lv_DescripCaractVlan || ''') VLAN ';

    Lcl_From        := 'FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_EMPRESA_ROL
                        INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
                        ON PERSONA.ID_PERSONA = PERSONA_EMPRESA_ROL.PERSONA_ID
                        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL
                        ON PERSONA_EMPRESA_ROL.EMPRESA_ROL_ID = EMPRESA_ROL.ID_EMPRESA_ROL
                        INNER JOIN DB_COMERCIAL.ADMI_ROL ROL
                        ON EMPRESA_ROL.ROL_ID = ROL.ID_ROL
                        INNER JOIN DB_COMERCIAL.ADMI_TIPO_ROL TIPO_ROL
                        ON TIPO_ROL.ID_TIPO_ROL = ROL.TIPO_ROL_ID
                        INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
                        ON PUNTO.PERSONA_EMPRESA_ROL_ID = PERSONA_EMPRESA_ROL.ID_PERSONA_ROL
                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
                        ON JURISDICCION.ID_JURISDICCION = PUNTO.PUNTO_COBERTURA_ID
                        INNER JOIN DB_GENERAL.ADMI_SECTOR SECTOR
                        ON SECTOR.ID_SECTOR = PUNTO.SECTOR_ID
                        INNER JOIN DB_GENERAL.ADMI_PARROQUIA PARROQUIA
                        ON SECTOR.PARROQUIA_ID = PARROQUIA.ID_PARROQUIA
                        INNER JOIN DB_GENERAL.ADMI_CANTON CANTON
                        ON PARROQUIA.CANTON_ID = CANTON.ID_CANTON
                        INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO ATN
                        ON ATN.ID_TIPO_NEGOCIO = PUNTO.TIPO_NEGOCIO_ID
                        INNER JOIN
                        (
                            SELECT DISTINCT SERVICIO.PUNTO_ID, SERVICIO.ID_SERVICIO AS ID_SERVICIO_INTERNET,
                            SERVICIO_TECNICO.ID_SERVICIO_TECNICO AS ID_SERVICIO_TECNICO_INTERNET,
                            PROD_PLAN.ID_PRODUCTO AS ID_PRODUCTO_INTERNET,
                            ONT.SERIE_FISICA AS SERIE_ONT,
                            IP.IP AS IP_OLT,
                            MARCA_ONT.NOMBRE_MARCA_ELEMENTO AS NOMBRE_MARCA_ELEMENTO,
                            SERVICIO.ESTADO as ESTADO_SERVICIO_INTERNET,
                            OLT.NOMBRE_ELEMENTO AS NOMBRE_OLT,
                            INTERFACE_OLT.NOMBRE_INTERFACE_ELEMENTO AS INTERFACE_ELEMENTO,
                            PLAN.NOMBRE_PLAN AS NOMBRE_PLAN,
                            PRODUCTO_SERVICIO.DESCRIPCION_PRODUCTO AS DESCRIPCION_PRODUCTO,
                            SERVICIO.LOGIN_AUX as LOGIN_AUX_SERVICIO_INTERNET
                            FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
                            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
                            ON SERVICIO_TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO
                            LEFT JOIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_OLT
                            ON INTERFACE_OLT.ID_INTERFACE_ELEMENTO = SERVICIO_TECNICO.INTERFACE_ELEMENTO_ID
                            LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO OLT
                            ON OLT.ID_ELEMENTO = SERVICIO_TECNICO.ELEMENTO_ID
                            LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO ONT
                            ON ONT.ID_ELEMENTO = SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID
                            LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_ONT
                            ON MODELO_ONT.ID_MODELO_ELEMENTO = ONT.MODELO_ELEMENTO_ID
                            LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA_ONT
                            ON MARCA_ONT.ID_MARCA_ELEMENTO = MODELO_ONT.MARCA_ELEMENTO_ID
                            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO_SERVICIO
                            ON PRODUCTO_SERVICIO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
                            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN
                            ON PLAN.ID_PLAN = SERVICIO.PLAN_ID
                            LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET PLAN_DET
                            ON PLAN_DET.PLAN_ID = PLAN.ID_PLAN
                            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD_PLAN
                            ON PROD_PLAN.ID_PRODUCTO = PLAN_DET.PRODUCTO_ID
                            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                            ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
                            LEFT JOIN DB_INFRAESTRUCTURA.INFO_IP IP
                            ON IP.ELEMENTO_ID = SERVICIO_TECNICO.ELEMENTO_ID
                            WHERE SERVICIO.ESTADO
                            IN
                            (   SELECT DISTINCT PARAM_DET.VALOR4
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                WHERE PARAM_CAB.NOMBRE_PARAMETRO =  ''' || Lv_NombreParamGeneral || '''
                                AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                                AND PARAM_DET.VALOR1 = ''' || Lv_ParamsWebServices || '''
                                AND PARAM_DET.VALOR2 = ''' || Lv_NombreWebService || '''
                                AND PARAM_DET.VALOR3 = ''' || Lv_ParamEstadosServInternet || '''
                                AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                                AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresa || '''
                            )
                            AND
                            ((PLAN.ID_PLAN IS NOT NULL
                            AND PLAN_DET.ESTADO <> ''' || Lv_EstadoEliminado || ''') OR (PRODUCTO_SERVICIO.ID_PRODUCTO IS NOT NULL
                            AND PRODUCTO_SERVICIO.ESTADO <> ''' || Lv_EstadoEliminado || '''))
                            AND ((PROD_PLAN.NOMBRE_TECNICO IN ( SELECT DISTINCT PARAM_DET.VALOR4
                                                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                              INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                              ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                              WHERE PARAM_CAB.NOMBRE_PARAMETRO =  ''' || Lv_NombreParamGeneral || '''
                                                              AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                                                              AND PARAM_DET.VALOR1 = ''' || Lv_ParamsWebServices || '''
                                                              AND PARAM_DET.VALOR2 = ''' || Lv_NombreWebService || '''
                                                              AND PARAM_DET.VALOR3 = ''' || Lv_ParamNombresTecnInternet || '''
                                                              AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                                                              AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresa || ''') OR
                                 (PRODUCTO_SERVICIO.NOMBRE_TECNICO IN ( SELECT DISTINCT PARAM_DET.VALOR4
                                                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                              INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                              ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                              WHERE PARAM_CAB.NOMBRE_PARAMETRO =  ''' || Lv_NombreParamGeneral || '''
                                                              AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                                                              AND PARAM_DET.VALOR1 = ''' || Lv_ParamsWebServices || '''
                                                              AND PARAM_DET.VALOR2 = ''' || Lv_NombreWebService || '''
                                                              AND PARAM_DET.VALOR3 = ''' || Lv_ParamNombresTecnInternet || '''
                                                              AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                                                              AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresa || '''))))
                            AND ((ONT.ESTADO IN ( SELECT DISTINCT PARAM_DET.VALOR4
                                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                WHERE PARAM_CAB.NOMBRE_PARAMETRO =  ''' || Lv_NombreParamGeneral || '''
                                                AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                                                AND PARAM_DET.VALOR1 = ''' || Lv_ParamsWebServices || '''
                                                AND PARAM_DET.VALOR2 = ''' || Lv_NombreWebService || '''
                                                AND PARAM_DET.VALOR3 = ''' || Lv_ParamEstadosOntServInternet || '''
                                                AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                                                AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresa || ''') ) OR (ONT.ESTADO IS NULL))
                            AND ((IP.ESTADO = ''' || Lv_EstadoActivo || ''' ) OR (IP.ESTADO IS NULL))
                        ) SERVICIO_INTERNET_X_PUNTO
                        ON SERVICIO_INTERNET_X_PUNTO.PUNTO_ID = PUNTO.ID_PUNTO ';

    Lcl_Where       := 'WHERE EMPRESA_ROL.EMPRESA_COD = ''' || Lv_CodEmpresa || '''
                        AND PERSONA_EMPRESA_ROL.ESTADO IN ( SELECT DISTINCT PARAM_DET.VALOR4
                                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARAM_CAB
                                                            INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET PARAM_DET
                                                            ON PARAM_DET.PARAMETRO_ID = PARAM_CAB.ID_PARAMETRO
                                                            WHERE PARAM_CAB.NOMBRE_PARAMETRO =  ''' || Lv_NombreParamGeneral || '''
                                                            AND PARAM_CAB.ESTADO = ''' || Lv_EstadoActivo || '''
                                                            AND PARAM_DET.VALOR1 = ''' || Lv_ParamsWebServices || '''
                                                            AND PARAM_DET.VALOR2 = ''' || Lv_NombreWebService || '''
                                                            AND PARAM_DET.VALOR3 = ''' || Lv_ParamEstadosPer || '''
                                                            AND PARAM_DET.ESTADO = ''' || Lv_EstadoActivo || '''
                                                            AND PARAM_DET.EMPRESA_COD = ''' || Lv_CodEmpresa || ''')
                        ';
     Lcl_Where   := Lcl_Where || 'AND TIPO_ROL.DESCRIPCION_TIPO_ROL = ''' || Lv_TipoRol || ''' ';

    IF Lv_Identificacion IS NOT NULL THEN
      Lcl_Where := Lcl_Where || 'AND PERSONA.IDENTIFICACION_CLIENTE = ''' || Lv_Identificacion || ''' ';
    END IF;

    IF Lv_Login IS NOT NULL THEN
      Lcl_Where := Lcl_Where || 'AND PUNTO.LOGIN = ''' || Lv_Login || ''' ';
    END IF;

    IF (Lv_SerieOnt IS NOT NULL OR Lv_MacOnt IS NOT NULL) THEN
      IF Lv_SerieOnt IS NOT NULL THEN
        Lcl_Where := Lcl_Where || 'AND SERVICIO_INTERNET_X_PUNTO.SERIE_ONT = ''' || Lv_SerieOnt || ''' ';
      END IF;

      IF Lv_MacOnt IS NOT NULL THEN
        Lcl_Join    := Lcl_Join || ' INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC_MAC_ONT
                                     ON SPC_MAC_ONT.SERVICIO_ID = SERVICIO_INTERNET_X_PUNTO.ID_SERVICIO_INTERNET
                                     INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC_MAC_ONT
                                     ON APC_MAC_ONT.ID_PRODUCTO_CARACTERISITICA = SPC_MAC_ONT.PRODUCTO_CARACTERISITICA_ID
                                     INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_MAC_ONT
                                     ON CARACT_MAC_ONT.ID_CARACTERISTICA = APC_MAC_ONT.CARACTERISTICA_ID ';
        Lcl_Where   := Lcl_Where || 'AND CARACT_MAC_ONT.DESCRIPCION_CARACTERISTICA = ''' || Lv_DescripCaractMacOnt || '''
                                     AND SPC_MAC_ONT.ESTADO = ''' || Lv_EstadoActivo || '''
                                     AND SPC_MAC_ONT.VALOR = ''' || Lv_MacOnt || ''' ';
      END IF;
    END IF;

    Lcl_ConsultaPrincipal := Lcl_Select || Lcl_From || Lcl_Join || Lcl_Where;
    OPEN Prf_Registros FOR Lcl_ConsultaPrincipal;
    Pv_Status   := 'OK';
    Pv_MsjError := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status           := 'ERROR';
    Pv_MsjError         := Lv_MsjError;
    Prf_Registros       := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_INTERNET_ACS',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Lv_MsjError         := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_MsjError         := 'No se ha podido realizar correctamente la consulta del cliente. Por favor consultar con Sistemas!';
    Prf_Registros       := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_INTERNET_ACS',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_INFOCLIENTE_INTERNET_ACS;

  PROCEDURE P_GET_INFOCLIENTE_ACS(
    Pcl_JsonFiltrosBusqueda IN CLOB,
    Pv_Status               OUT VARCHAR2,
    Pv_MsjError             OUT VARCHAR2,
    Pcl_JsonRespuesta       OUT CLOB)
  AS
    Lv_Status                       VARCHAR2(5);
    Lv_MsjError                     VARCHAR2(4000);
    Lv_StatusOK                     VARCHAR2(2) := 'OK';
    Lv_MensajeOK                    VARCHAR2(2) := 'OK';
    Lv_StatusError                  VARCHAR2(5) := 'ERROR';
    Lv_TieneInfoCliente             VARCHAR2(2) := 'NO';
    Lrf_RegistrosClienteInternet    SYS_REFCURSOR;
    Ln_IndxRegInfoClienteInternet   NUMBER;
    Lr_RegInfoClienteInternetWs     DB_INFRAESTRUCTURA.INKG_TYPES.Lr_InfoClienteInternetWsAcs;
    Lt_TRegInfoClienteInternetWs    DB_INFRAESTRUCTURA.INKG_TYPES.Lt_InfoClienteInternetWsAcs;
    Lcl_JsonRespuesta               CLOB;
    Lcl_JsonFiltrosBusqueda         CLOB;
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';

  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonFiltrosBusqueda;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object; -- {
    DB_COMERCIAL.TECNK_SERVICIOS.P_GET_INFOCLIENTE_INTERNET_ACS( Pcl_JsonFiltrosBusqueda,
                                                                 Lv_Status,
                                                                 Lv_MsjError,
                                                                 Lrf_RegistrosClienteInternet);
    IF Lv_Status = 'OK' THEN
      APEX_JSON.open_array('arrayData'); -- arrayData [
      LOOP
        FETCH Lrf_RegistrosClienteInternet BULK COLLECT
        INTO Lt_TRegInfoClienteInternetWs LIMIT 100;
        Ln_IndxRegInfoClienteInternet := Lt_TRegInfoClienteInternetWs.FIRST;
        WHILE (Ln_IndxRegInfoClienteInternet IS NOT NULL)
        LOOP
          Lr_RegInfoClienteInternetWs := Lt_TRegInfoClienteInternetWs(Ln_IndxRegInfoClienteInternet);
          IF Lr_RegInfoClienteInternetWs.ID_SERVICIO_INTERNET IS NOT NULL THEN
            Lv_TieneInfoCliente         := 'SI';
            APEX_JSON.open_object; -- {
            APEX_JSON.write('marca_ont', Lr_RegInfoClienteInternetWs.NOMBRE_MARCA_ELEMENTO, true);
            APEX_JSON.write('ont_id', Lr_RegInfoClienteInternetWs.ONT_ID, true);
            APEX_JSON.write('ip_olt', Lr_RegInfoClienteInternetWs.IP_OLT, true);
            APEX_JSON.write('contactos_telefonicos', Lr_RegInfoClienteInternetWs.TELEFONOS, true);
            APEX_JSON.write('nombre_jurisdiccion', Lr_RegInfoClienteInternetWs.NOMBRE_JURISDICCION, true);
            APEX_JSON.write('id_servicio', Lr_RegInfoClienteInternetWs.ID_SERVICIO_INTERNET, true);
            APEX_JSON.write('estado_servicio', Lr_RegInfoClienteInternetWs.ESTADO_SERVICIO_INTERNET, true);
            APEX_JSON.write('mac_ont', Lr_RegInfoClienteInternetWs.MAC_ONT, true);
            APEX_JSON.write('serial_ont', Lr_RegInfoClienteInternetWs.SERIE_ONT, true);
            APEX_JSON.write('olt', Lr_RegInfoClienteInternetWs.NOMBRE_OLT, true);
            APEX_JSON.write('interface_elemento', Lr_RegInfoClienteInternetWs.INTERFACE_ELEMENTO, true);
            APEX_JSON.write('ciudad', Lr_RegInfoClienteInternetWs.NOMBRE_CANTON, true);
            APEX_JSON.write('login', Lr_RegInfoClienteInternetWs.LOGIN, true);
            APEX_JSON.write('line_profile', Lr_RegInfoClienteInternetWs.LINE_PROFILE, true);
            APEX_JSON.write('identificacion', Lr_RegInfoClienteInternetWs.IDENTIFICACION_CLIENTE, true);
            APEX_JSON.write('nombre_completo', Lr_RegInfoClienteInternetWs.CLIENTE, true);
            APEX_JSON.write('correos', Lr_RegInfoClienteInternetWs.CORREOS, true);
            APEX_JSON.write('direccion', Lr_RegInfoClienteInternetWs.DIRECCION, true);
            APEX_JSON.write('longitud', Lr_RegInfoClienteInternetWs.LONGITUD, true);
            APEX_JSON.write('latitud', Lr_RegInfoClienteInternetWs.LATITUD, true);
            APEX_JSON.write('tipo_servicio', Lr_RegInfoClienteInternetWs.NOMBRE_TIPO_NEGOCIO, true);
            APEX_JSON.write('nombre_plan', Lr_RegInfoClienteInternetWs.NOMBRE_PLAN, true);
            APEX_JSON.write('nombre_producto', Lr_RegInfoClienteInternetWs.NOMBRE_PRODUCTO, true);
            APEX_JSON.write('login_aux', Lr_RegInfoClienteInternetWs.LOGIN_AUX_SERVICIO_INTERNET, true);
            APEX_JSON.write('vlan', Lr_RegInfoClienteInternetWs.VLAN, true);
            APEX_JSON.close_object; -- } data_tecnica
          END IF;
          Ln_IndxRegInfoClienteInternet := Lt_TRegInfoClienteInternetWs.NEXT(Ln_IndxRegInfoClienteInternet);
        END LOOP;
        EXIT
        WHEN Lrf_RegistrosClienteInternet%NOTFOUND;
      END LOOP;
      CLOSE Lrf_RegistrosClienteInternet;
      APEX_JSON.close_array; -- ] arrayData
      IF Lv_TieneInfoCliente = 'SI' THEN
        APEX_JSON.write('strStatus', Lv_Statusok);
        APEX_JSON.write('strMensaje', Lv_MensajeOK);
      ELSIF Lv_TieneInfoCliente = 'NO' THEN
        APEX_JSON.write('strStatus', Lv_StatusError);
        APEX_JSON.write('strMensaje', 'No existe información del cliente consultado.');
      END IF;
    ELSE
      APEX_JSON.write('strStatus', Lv_StatusError);
      APEX_JSON.write('strMensaje', Lv_MsjError);
    END IF;
    APEX_JSON.close_object; -- }
    Lcl_JsonRespuesta := apex_json.get_clob_output;
    APEX_JSON.free_output;
    Pv_Status           := 'OK';
    Pv_MsjError         := '';
    Pcl_JsonRespuesta   := Lcl_JsonRespuesta;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Lv_MsjError         := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_MsjError         := 'No se ha podido realizar correctamente la consulta. Por favor consultar con Sistemas!';
    Pcl_JsonRespuesta   := '{"strStatus":"' || Pv_Status || '","strMensaje":"' || Pv_MsjError || '"}';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'TECNK_SERVICIOS.P_GET_INFOCLIENTE_ACS',
                                          Lv_MsjError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_INFOCLIENTE_ACS;

END TECNK_SERVICIOS;
/