CREATE OR REPLACE PACKAGE DB_COMUNICACION.CUKG_CONSULTS AS
/**
 * Documentación para F_GET_PARAMS_NOTIF_MASIVA
 * Función que obtiene los parámetros que fueron configurados en el envío masivo
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 18/09/2017
 *
 * @param Fn_IdNotifMasiva  IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOTIF_MASIVA_ID%TYPE Recibe el id de la notificación masiva
 * @param Fn_Tipo           IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.TIPO%TYPE Recibe el tipo de parámetro de envío masivo
 * @param Fv_Estado         IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.ESTADO%TYPE Recibe el estado del parámetro del envío masivo
 * @return SYS_REFCURSOR
 */
FUNCTION F_GET_PARAMS_NOTIF_MASIVA(
  Fn_IdNotifMasiva    IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOTIF_MASIVA_ID%TYPE,
  Fn_Tipo             IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.TIPO%TYPE,
  Fv_Estado           IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.ESTADO%TYPE )
RETURN SYS_REFCURSOR;

/**
 * Documentación para F_GET_VALOR_PARAM_NOTIF_MASIVA
 * Función que obtiene el valor de un parámetro de la notificación masiva
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 26/09/2017
 *
 * @param Fn_IdNotifMasiva  IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOTIF_MASIVA_ID%TYPE Recibe el id de la notificación masiva
 * @param Fv_Nombre         IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOMBRE%TYPE Recibe el nombre de parámetro de envío masivo
 * @param Fv_Estado         IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.ESTADO%TYPE Recibe el estado del parámetro del envío masivo
 * @return SYS_REFCURSOR
 */
FUNCTION F_GET_VALOR_PARAM_NOTIF_MASIVA(
  Fn_IdNotifMasiva    IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOTIF_MASIVA_ID%TYPE,
  Fv_Nombre           IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOMBRE%TYPE,
  Fv_Estado           IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.ESTADO%TYPE)
RETURN VARCHAR2;

/**
 * Documentación para P_GET_SERVICIOS_NOTIF_MASIVA
 * Procedimiento que retorna el listado de los clientes con los servicios para el listado del envío masivo
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 20/09/2017
 *
 * @param Fv_DestinatariosCorreo        IN VARCHAR2 Recibe 'S' si se desea obtener los destinatarios del envío masivo que se quiere realizar
 * @param Pn_Start                      IN NUMBER Inicio del rownum
 * @param Pn_Limit                      IN NUMBER Fin del rownum
 * @param Pv_Grupo                      IN VARCHAR2 Recibe el nombre del grupo de un producto
 * @param Pv_Subgrupo                   IN VARCHAR2 Recibe el nombre del subgrupo de un producto
 * @param Pn_IdElementoNodo             IN NUMBER Recibe el id del elemento nodo
 * @param Pn_IdElementoSwitch           IN NUMBER Recibe el id del elemento switch
 * @param Pv_EstadoServicio             IN VARCHAR2 Recibe el estado del servicio
 * @param Pv_EstadoPunto                IN VARCHAR2 Recibe el estado del punto
 * @param Pv_EstadoCliente              IN VARCHAR2 Recibe el estado del cliente
 * @param Pv_ClientesVIP                IN VARCHAR2 Recibe 'S' si se desea filtrar sólo por clientes que son VIP o 'N' para excluir a los clientes VIP
 * @param Pv_UsrCreacionFactura         IN VARCHAR2 Recibe el usuario de creación de facturas mensuales o proporcionales
 * @param Pn_NumFacturasAbiertas        IN NUMBER Recibe el número mínimo de facturas abiertas
 * @param Pv_PuntosFacturacion          IN VARCHAR2 Recibe 'S' si se desea filtrar sólo por puntos de facturación
 * @param Pv_IdsTiposNegocio            IN VARCHAR2 Recibe los ids del tipo de negocio concatenados con ,
 * @param Pv_IdsOficinas                IN VARCHAR2 Recibe los ids de las oficinas concatenados con ,
 * @param Pn_IdFormaPago                IN NUMBER Recibe el id de la forma de pago
 * @param Pv_NombreFormaPago            IN VARCHAR2 Recibe el nombre de la forma de pago
 * @param Pv_IdsBancosTarjetas          IN VARCHAR2 Recibe los ids de los bancos o tarjetas concatenados con ,
 * @param Pv_FechaDesdeFactura          IN VARCHAR2 Recibe la fecha desde la que comparará la fecha de autorización de las facturas
 * @param Pv_FechaHastaFactura          IN VARCHAR2 Recibe la fecha hasta la que comparará la fecha de autorización de las facturas
 * @param Pv_SaldoPendientePago         IN VARCHAR2 Recibe 'S' si se desea filtrar sólo a los clientes con saldo pendiente de pago
 * @param Pf_ValorSaldoPendientePago    IN FLOAT Recibe el valor mínimo para comparar el saldo pendiente de un cliente
 * @param Pv_IdsTiposContactos          IN VARCHAR2 Recibe los ids de la empresa rol asociados a un tipo de contacto
 * @param Pv_VariablesNotificacion      IN VARCHAR2 Recibe los nombres de las variables que se encuentran en la plantilla de la notificación
 * @param Pn_TotalRegistros             OUT NUMBER Recibe el total de registros 
 * @param Prf_ListadoEnvioMasivo        OUT SYS_REFCURSOR Cursor que retorna el listado del envío masivo
 *
 */
PROCEDURE P_GET_SERVICIOS_NOTIF_MASIVA(
                                        Pv_DestinatariosCorreo        IN VARCHAR2,
                                        Pn_Start                      IN NUMBER,
                                        Pn_Limit                      IN NUMBER,
                                        Pv_Grupo                      IN VARCHAR2,
                                        Pv_Subgrupo                   IN VARCHAR2, 
                                        Pn_IdElementoNodo             IN NUMBER, 
                                        Pn_IdElementoSwitch           IN NUMBER, 
                                        Pv_EstadoServicio             IN VARCHAR2,
                                        Pv_EstadoPunto                IN VARCHAR2,
                                        Pv_EstadoCliente              IN VARCHAR2,
                                        Pv_ClientesVIP                IN VARCHAR2,
                                        Pv_UsrCreacionFactura         IN VARCHAR2,
                                        Pn_NumFacturasAbiertas        IN NUMBER, 
                                        Pv_PuntosFacturacion          IN VARCHAR2, 
                                        Pv_IdsTiposNegocio            IN VARCHAR2, 
                                        Pv_IdsOficinas                IN VARCHAR2, 
                                        Pn_IdFormaPago                IN VARCHAR2, 
                                        Pv_NombreFormaPago            IN VARCHAR2,
                                        Pv_IdsBancosTarjetas          IN VARCHAR2,
                                        Pv_FechaDesdeFactura          IN VARCHAR2,
                                        Pv_FechaHastaFactura          IN VARCHAR2,
                                        Pv_SaldoPendientePago         IN VARCHAR2,
                                        Pf_ValorSaldoPendientePago    IN FLOAT,
                                        Pv_IdsTiposContactos          IN VARCHAR2,
                                        Pv_VariablesNotificacion      IN VARCHAR2,
                                        Pn_TotalRegistros             OUT NUMBER,
                                        Prf_ListadoEnvioMasivo        OUT SYS_REFCURSOR);

/**
 * Documentación para F_GET_ALIAS_PLANTILLA
 * Función que obtiene los alias asociados a una plantilla
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 24/09/2017
 *
 * @param Fv_CodigoPlantilla  IN  DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE Recibe el código de la plantilla
 * @return DB_COMUNICACION.CUKG_TYPES.Lr_AliasPlantilla
 */
FUNCTION F_GET_ALIAS_PLANTILLA(
  Fv_CodigoPlantilla IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
RETURN DB_COMUNICACION.CUKG_TYPES.Lr_AliasPlantilla;

/**
 * Documentación para F_GET_PLANTILLA_NOTIF_MASIVA
 * Función que obtiene un cursor de la plantilla que se desea enviar
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 24/09/2017
 *
 * @param Fn_IdNotifMasiva IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE Recibe el id de la plantilla
 * @return SYS_REFCURSOR
 */
FUNCTION F_GET_PLANTILLA_NOTIF_MASIVA(
  Fn_IdNotifMasiva IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE)
RETURN SYS_REFCURSOR;

/**
 * Documentación para F_GET_COUNT_TAREAS
 * Función que obtiene la cantidad de tareas asociadas a un id_detalle
 * 
 * @author Jean Pierre Nazareno <jnazareno@telconet.ec>
 * @version 1.0 03/10/2019
 *
 * @param Fn_IdDetalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE
 * @return NUMBER
 */
FUNCTION F_GET_COUNT_TAREAS(Fn_IdDetalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
  RETURN NUMBER;
  
  /**
   * Documentación para P_GET_IMAGENES_POR_CRITERIOS
   * Proceso que obtiene las imágenes según los criterios ingresados
   * 
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 02-03-2022
   *
   * @param Pcl_Request
   * @param Pv_Status
   * @param Pv_Mensaje
   * @param Pcl_Response
   */
  PROCEDURE P_GET_IMAGENES_POR_CRITERIOS(Pcl_Request       IN  CLOB,
                                         Pv_Status         OUT VARCHAR2,
                                         Pv_Mensaje        OUT VARCHAR2,
                                         Pcl_Response      OUT CLOB,
                                         Pn_TotalRegistros OUT NUMBER);

END CUKG_CONSULTS;
/
CREATE OR REPLACE PACKAGE BODY DB_COMUNICACION.CUKG_CONSULTS AS

FUNCTION F_GET_PARAMS_NOTIF_MASIVA(
    Fn_IdNotifMasiva    IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOTIF_MASIVA_ID%TYPE,
    Fn_Tipo             IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.TIPO%TYPE,
    Fv_Estado           IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.ESTADO%TYPE )
  RETURN SYS_REFCURSOR
IS
  --
  Lrf_InfoNotifMasivaParam SYS_REFCURSOR;
  --
BEGIN
  OPEN Lrf_InfoNotifMasivaParam FOR SELECT INMP.*
                                FROM DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM INMP 
                                WHERE INMP.NOTIF_MASIVA_ID = Fn_IdNotifMasiva
                                AND INMP.TIPO = Fn_Tipo 
                                AND INMP.ESTADO = Fv_Estado;
  --
  RETURN Lrf_InfoNotifMasivaParam;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_CONSULTS.F_GET_PARAMS_NOTIF_MASIVA', 
                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                        || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  --
END F_GET_PARAMS_NOTIF_MASIVA;

FUNCTION F_GET_VALOR_PARAM_NOTIF_MASIVA(
  Fn_IdNotifMasiva    IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOTIF_MASIVA_ID%TYPE,
  Fv_Nombre           IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOMBRE%TYPE,
  Fv_Estado           IN DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.ESTADO%TYPE)
  RETURN VARCHAR2
IS
  Lv_ValorParam  VARCHAR2(300):= NULL;
BEGIN

  SELECT 
  INMP.VALOR INTO Lv_ValorParam
  FROM 
  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM INMP
  WHERE 
  INMP.NOTIF_MASIVA_ID  = Fn_IdNotifMasiva
  AND INMP.NOMBRE       = Fv_Nombre
  AND INMP.ESTADO       = Fv_Estado;
  
  RETURN Lv_ValorParam;
  
END;

PROCEDURE P_GET_SERVICIOS_NOTIF_MASIVA(
                                        Pv_DestinatariosCorreo        IN VARCHAR2,
                                        Pn_Start                      IN NUMBER,
                                        Pn_Limit                      IN NUMBER,
                                        Pv_Grupo                      IN VARCHAR2,
                                        Pv_Subgrupo                   IN VARCHAR2, 
                                        Pn_IdElementoNodo             IN NUMBER, 
                                        Pn_IdElementoSwitch           IN NUMBER, 
                                        Pv_EstadoServicio             IN VARCHAR2,
                                        Pv_EstadoPunto                IN VARCHAR2,
                                        Pv_EstadoCliente              IN VARCHAR2,
                                        Pv_ClientesVIP                IN VARCHAR2, 
                                        Pv_UsrCreacionFactura         IN VARCHAR2,
                                        Pn_NumFacturasAbiertas        IN NUMBER, 
                                        Pv_PuntosFacturacion          IN VARCHAR2, 
                                        Pv_IdsTiposNegocio            IN VARCHAR2, 
                                        Pv_IdsOficinas                IN VARCHAR2, 
                                        Pn_IdFormaPago                IN VARCHAR2, 
                                        Pv_NombreFormaPago            IN VARCHAR2,
                                        Pv_IdsBancosTarjetas          IN VARCHAR2,
                                        Pv_FechaDesdeFactura          IN VARCHAR2,
                                        Pv_FechaHastaFactura          IN VARCHAR2,
                                        Pv_SaldoPendientePago         IN VARCHAR2,
                                        Pf_ValorSaldoPendientePago    IN FLOAT,
                                        Pv_IdsTiposContactos          IN VARCHAR2,
                                        Pv_VariablesNotificacion      IN VARCHAR2,
                                        Pn_TotalRegistros             OUT NUMBER,
                                        Prf_ListadoEnvioMasivo        OUT SYS_REFCURSOR )
IS
  Lv_UsrCreacion VARCHAR2(15) := 'DB_COMUNICACION';
BEGIN
  Prf_ListadoEnvioMasivo := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_SERVICIOS_NOTIF_MASIVA(  Pv_DestinatariosCorreo,
                                                                                        Pn_Start,
                                                                                        Pn_Limit,
                                                                                        Pv_Grupo,
                                                                                        Pv_Subgrupo, 
                                                                                        Pn_IdElementoNodo, 
                                                                                        Pn_IdElementoSwitch, 
                                                                                        Pv_EstadoServicio,
                                                                                        Pv_EstadoPunto,
                                                                                        Pv_EstadoCliente,
                                                                                        Pv_ClientesVIP, 
                                                                                        Pv_UsrCreacionFactura,
                                                                                        Pn_NumFacturasAbiertas, 
                                                                                        Pv_PuntosFacturacion, 
                                                                                        Pv_IdsTiposNegocio, 
                                                                                        Pv_IdsOficinas, 
                                                                                        Pn_IdFormaPago, 
                                                                                        Pv_NombreFormaPago,
                                                                                        Pv_IdsBancosTarjetas,
                                                                                        Pv_FechaDesdeFactura,
                                                                                        Pv_FechaHastaFactura,
                                                                                        Pv_SaldoPendientePago,
                                                                                        Pf_ValorSaldoPendientePago,
                                                                                        Pv_IdsTiposContactos,
                                                                                        Pv_VariablesNotificacion,
                                                                                        Pn_TotalRegistros           );
EXCEPTION
WHEN OTHERS THEN
    --
    Prf_ListadoEnvioMasivo := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'CUKG_CONSULTS.P_GET_SERVICIOS_NOTIF_MASIVA', 
                                          'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );


END P_GET_SERVICIOS_NOTIF_MASIVA;

FUNCTION F_GET_ALIAS_PLANTILLA(
    Fv_CodigoPlantilla IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
  RETURN DB_COMUNICACION.CUKG_TYPES.Lr_AliasPlantilla
IS
  --
  CURSOR C_GetAliasPlantilla(Cv_CodigoPlantilla
    DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
  IS
    SELECT
      LISTAGG (TRIM(AA.VALOR), ';') WITHIN GROUP (
    ORDER BY
      AA.VALOR) CORREOS,
      AP.ID_PLANTILLA
    FROM
      DB_COMUNICACION.ADMI_PLANTILLA AP,
      DB_COMUNICACION.INFO_ALIAS_PLANTILLA IAP,
      DB_COMUNICACION.ADMI_ALIAS AA
    WHERE
      AP.CODIGO = Cv_CodigoPlantilla
    AND AP.ID_PLANTILLA = IAP.PLANTILLA_ID
    AND IAP.ALIAS_ID    = AA.ID_ALIAS
    AND IAP.ESTADO <> 'Eliminado'
    AND AP.ESTADO <> 'Eliminado'
    AND AA.ESTADO <> 'Eliminado'
    GROUP BY
      AP.ID_PLANTILLA;
  --
  Lc_GetAliasPlantilla C_GetAliasPlantilla%ROWTYPE;
  --
BEGIN
  --
  IF C_GetAliasPlantilla%ISOPEN THEN
    --
    CLOSE C_GetAliasPlantilla;
    --
  END IF;
  --
  OPEN C_GetAliasPlantilla(Fv_CodigoPlantilla);
  --
  FETCH
    C_GetAliasPlantilla
  INTO
    Lc_GetAliasPlantilla;
  --
  CLOSE C_GetAliasPlantilla;
  --
  RETURN Lc_GetAliasPlantilla;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_CONSULTS.F_GET_ALIAS_PLANTILLA', 
                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                        || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END F_GET_ALIAS_PLANTILLA;

FUNCTION F_GET_PLANTILLA_NOTIF_MASIVA(
    Fn_IdNotifMasiva IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE)
  RETURN SYS_REFCURSOR
IS
  --
  Lrf_Plantilla SYS_REFCURSOR;
  --
BEGIN
  OPEN Lrf_Plantilla FOR SELECT INM.NOMBRE_JOB,INM.ASUNTO,INM.TIPO,AP.NOMBRE_PLANTILLA,AP.CODIGO,AP.PLANTILLA
                         FROM DB_COMUNICACION.INFO_NOTIF_MASIVA INM
                         INNER JOIN DB_COMUNICACION.ADMI_PLANTILLA AP
                         ON AP.ID_PLANTILLA = INM.PLANTILLA_ID
                         WHERE INM.ID_NOTIF_MASIVA = Fn_IdNotifMasiva;
  --
  RETURN Lrf_Plantilla;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_CONSULTS.F_GET_PLANTILLA_NOTIF_MASIVA', 
                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                        || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  --
END F_GET_PLANTILLA_NOTIF_MASIVA;

  FUNCTION F_GET_COUNT_TAREAS(Fn_IdDetalle IN DB_SOPORTE.INFO_DETALLE.ID_DETALLE%TYPE)
  RETURN NUMBER
  IS
    Ln_Total NUMBER := 0;
  BEGIN

    SELECT COUNT(*) INTO Ln_Total
    FROM DB_COMUNICACION.INFO_COMUNICACION INFC
    WHERE INFC.DETALLE_ID = Fn_IdDetalle
    AND (SELECT INFDH.ESTADO 
            FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL INFDH 
            WHERE INFDH.ID_DETALLE_HISTORIAL = (SELECT MAX(INFDH2.ID_DETALLE_HISTORIAL) 
                                                FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL INFDH2 
                                                WHERE INFDH2.DETALLE_ID = Fn_IdDetalle)) 
                                                  NOT IN ('Finalizada', 'Cancelada', 'Anulada', 'Rechazada')
    AND INFC.ESTADO = 'Activo';
    
    RETURN Ln_Total;
    
  END F_GET_COUNT_TAREAS;
                                           
  PROCEDURE P_GET_IMAGENES_POR_CRITERIOS(Pcl_Request       IN  CLOB,
                                         Pv_Status         OUT VARCHAR2,
                                         Pv_Mensaje        OUT VARCHAR2,
                                         Pcl_Response      OUT CLOB,
                                         Pn_TotalRegistros OUT NUMBER) IS
                                         
    CURSOR C_GetInfoTipoElemento IS
      SELECT
        Ate.Id_Tipo_Elemento, Ate.Nombre_Tipo_Elemento
      FROM
        Db_Infraestructura.Admi_Tipo_Elemento Ate
      WHERE
          Ate.Estado = 'Activo'
        AND Es_De = 'BACKBONE'
      ORDER BY
        Ate.Nombre_Tipo_Elemento ASC;
        
    CURSOR C_GetInfoTipoElementoPorId(Cn_Id_Tipo_Elemento Number) IS
      SELECT
        Ate.Id_Tipo_Elemento, Ate.Nombre_Tipo_Elemento
      FROM
        Db_Infraestructura.Admi_Tipo_Elemento Ate
      WHERE
          Ate.Id_Tipo_Elemento = Cn_Id_Tipo_Elemento;        
    
    CURSOR C_GetValoresEvaluacionTrabajo IS    
      SELECT
        Pd.Id_Parametro_Det,
        Pd.Descripcion,
        Pd.Valor1,
        Pd.Valor2,
        Pd.Valor3,
        Pd.Valor4,
        Pd.Valor5,
        Pd.Estado,
        Pd.Valor6,
        Pd.Valor7,
        Pd.Observacion
      FROM
        Db_General.Admi_Parametro_Det Pd,
        Db_General.Admi_Parametro_Cab Pc
      WHERE
          Pc.Id_Parametro = Pd.Parametro_Id
        AND Pc.Nombre_Parametro = 'VALORES_EVALUACION_TRABAJO'
        AND Pc.Estado = 'Activo'
        AND Pd.Estado = 'Activo' 
      ORDER BY
        Pd.Valor3;
        
    CURSOR C_GetCronFotosObligatorias IS
      SELECT
        Pd.Id_Parametro_Det,
        Pd.Descripcion,
        Pd.Valor1,
        Pd.Valor2,
        Pd.Valor3,
        Pd.Valor4,
        Pd.Valor5,
        Pd.Estado,
        Pd.Valor6,
        Pd.Valor7,
        Pd.Observacion
      FROM
        Db_General.Admi_Parametro_Det Pd,
        Db_General.Admi_Parametro_Cab Pc
      WHERE
          Pc.Id_Parametro = Pd.Parametro_Id
        AND Pc.Nombre_Parametro = 'CRONOLOGIA_FOTOS_OBLIGATORIAS'
        AND Pc.Estado = 'Activo'
        AND Pd.Estado = 'Activo';
    
    CURSOR C_GetImagenesAntesDespues(Cv_NombreFotoAntes Varchar2,Cv_Login Varchar2) IS
      SELECT
        Infd.Id_Documento,
        Infd.Nombre_Documento,
        Infd.Ubicacion_Fisica_Documento,
        Infdr.Id_Documento_Relacion,
        Infdr.Estado_Evaluacion,
        Infdr.Evaluacion_Trabajo
      FROM
        Db_Comunicacion.Info_Documento          Infd,
        Db_Comunicacion.Info_Documento_Relacion Infdr
      WHERE
        Infd.Nombre_Documento LIKE Cv_NombreFotoAntes
        AND Infd.Usr_Creacion = Cv_Login
        AND Infdr.Documento_Id = Infd.Id_Documento
        ORDER BY INFD.ID_DOCUMENTO DESC ;
                                         
    Lcl_QuerySelect       CLOB;
    Lcl_QueryFrom         CLOB;
    Lcl_QueryWhere        CLOB;
    Lcl_QueryOrderBy      CLOB;
    Lcl_Query             CLOB;
    Lcl_QueryCount        CLOB;
    Lv_FechaDesde         VARCHAR2(25);
    Lv_FechaHasta         VARCHAR2(25);
    Lv_TipoElemento       VARCHAR2(100);
    Lv_ModeloElemento     VARCHAR2(100);
    Lv_Elemento           VARCHAR2(100);
    Lv_EstadoEvaluacion   VARCHAR2(100);
    Lv_Login              VARCHAR2(100);
    Lv_TipoSoporte        VARCHAR2(100);
    Lv_NumeroSoporte      VARCHAR2(100);
    Lv_FechaDesdeSoporte  VARCHAR2(25);
    Lv_FechaHastaSoporte  VARCHAR2(25);
    Lv_Empresa            VARCHAR2(10);
    Lv_Departamento       VARCHAR2(100);
    Lv_RegionSesion       VARCHAR2(100);
    Lv_Identificacion     VARCHAR2(25);
    Lv_Nombres            VARCHAR2(100);
    Lv_Apellidos          VARCHAR2(100);
    Lv_RazonSocial        VARCHAR2(35);
    Lv_CronFotoAntes      VARCHAR2(35);
    Lv_CronFotoDespues    VARCHAR2(35);
    Lv_UsuarioSesion      VARCHAR2(100);
    Lv_StyleForm          VARCHAR2(100);
    Lv_UrlImagenAntes     VARCHAR2(500);
    Lv_NombreFotoAntes    VARCHAR2(100);
    Lv_ContAdicImagen     VARCHAR2(2000);
    Lv_InfoEvalImagen     VARCHAR2(3000);
    Ln_IdTipoElemento     NUMBER;
    Ln_CuentaReg          NUMBER;
    Ln_Contador           NUMBER := 0;
    Ln_CantCaracteres     NUMBER := 0;
    Ln_TotalImagenes      NUMBER := 0;
    Ln_Inicio             NUMBER;
    Ln_Pagina             NUMBER;
    Ln_Limite             NUMBER;
    Lb_Role292_5557       BOOLEAN;
    Lrf_CantImagenes      SYS_REFCURSOR;
    Lrf_Imagenes          SYS_REFCURSOR;
    Lt_Imagenes           CUKG_TYPES.Ltr_Imagenes;
    Lt_CantidadImagenes   CUKG_TYPES.Ltr_CantidadImagenes;
    Li_Cont               PLS_INTEGER;
    Lc_CronologiaFotos    C_GetCronFotosObligatorias%ROWTYPE;
    Lc_ImagenesAntes      C_GetImagenesAntesDespues%ROWTYPE;
    Lc_TipoElemento       C_GetInfoTipoElementoPorId%ROWTYPE;
    Lcl_Response          Clob;
  BEGIN
    
    APEX_JSON.PARSE(Pcl_Request);
    Lv_FechaDesde := APEX_JSON.get_varchar2('fechaDesde');
    Lv_FechaHasta := APEX_JSON.get_varchar2('fechaHasta');
    Lv_TipoElemento := APEX_JSON.get_varchar2('tipoElemento');
    Lv_ModeloElemento := APEX_JSON.get_varchar2('modeloElemento');
    Lv_Elemento := APEX_JSON.get_varchar2('elemento');
    Lv_EstadoEvaluacion := APEX_JSON.get_varchar2('strEstadoEvaluacion');
    Lv_Login := APEX_JSON.get_varchar2('login');
    Lv_TipoSoporte := APEX_JSON.get_varchar2('tipoSoporte');
    Lv_NumeroSoporte := APEX_JSON.get_varchar2('numeroSoporte');
    Lv_FechaDesdeSoporte := APEX_JSON.get_varchar2('fechaDesdeSoporte');
    Lv_FechaHastaSoporte := APEX_JSON.get_varchar2('fechaHastaSoporte');
    Lv_Empresa := APEX_JSON.get_varchar2('empresa');
    Lv_Departamento := APEX_JSON.get_varchar2('departamento');
    Lv_RegionSesion := APEX_JSON.get_varchar2('strRegionSession');
    Lv_Identificacion := APEX_JSON.get_varchar2('identificacion');
    Lv_Nombres := APEX_JSON.get_varchar2('nombres');
    Lv_Apellidos := APEX_JSON.get_varchar2('apellidos');
    Lv_RazonSocial := APEX_JSON.get_varchar2('razonSocial');
    Lb_Role292_5557 := APEX_JSON.get_boolean('role292_5557');
    Lv_UsuarioSesion := APEX_JSON.get_varchar2('usuarioSesion');
    Ln_Limite := APEX_JSON.get_varchar2('limite');
    Ln_Inicio := APEX_JSON.get_varchar2('inicio');
    Ln_Pagina := APEX_JSON.get_varchar2('pagina');
    
    DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryOrderBy, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_Response, TRUE); 
    DBMS_LOB.CREATETEMPORARY(Lcl_QueryCount, TRUE); 
  
    DBMS_LOB.APPEND(Lcl_QuerySelect,'SELECT DISTINCT
                                        Ido.Id_Documento,
                                        Ipe.Nombres,
                                        Ipe.Apellidos,
                                        Ido.Nombre_Documento,
                                        Ido.Fe_Creacion,
                                        Ido.Ubicacion_Fisica_Documento Url_Imagen,
                                        Ido.Latitud,
                                        Ido.Longitud,
                                        Ipe.Login,
                                        Idr.Id_Documento_Relacion,
                                        Idr.Tipo_Elemento_Id,
                                        Idr.Estado_Evaluacion,
                                        Idr.Evaluacion_Trabajo,
                                        Idr.Usr_Evaluacion,
                                        Idr.Porcentaje_Evaluacion_Base,
                                        Idr.Porcentaje_Evaluado,
                                        Concat(Ip.Nombres, Concat('' '', Ip.Apellidos)) Nombre_Evaluador,
                                        Ic.Numero_Caso,
                                        Ie.Id_Elemento,
                                        Ate.Id_Tipo_Elemento,
                                        Ate.Nombre_Tipo_Elemento,
                                        Ico.Id_Comunicacion Numero_Tarea ');
    DBMS_LOB.APPEND(Lcl_QueryFrom,'FROM
                                      Db_Comunicacion.Info_Documento                 Ido
                                      LEFT JOIN Db_General.Admi_Tipo_Documento_General         Atdg ON Ido.Tipo_Documento_General_Id = Atdg.Id_Tipo_Documento, Db_Comunicacion.
                                      Info_Documento_Relacion        Idr
                                      LEFT JOIN Db_Comercial.Info_Persona                      Ip ON Ip.Login = Idr.Usr_Evaluacion
                                      LEFT JOIN Db_Soporte.Info_Caso                           Ic ON Ic.Id_Caso = Idr.Caso_Id
                                      LEFT JOIN Db_Infraestructura.Info_Elemento               Ie ON Idr.Elemento_Id = Ie.Id_Elemento
                                      LEFT JOIN Db_Infraestructura.Admi_Modelo_Elemento        Ame ON Ame.Id_Modelo_Elemento = Ie.Modelo_Elemento_Id
                                      LEFT JOIN Db_Infraestructura.Admi_Tipo_Elemento          Ate ON Ate.Id_Tipo_Elemento = Ame.Tipo_Elemento_Id
                                      LEFT JOIN Db_Infraestructura.Info_Empresa_Elemento_Ubica Ieeu ON Ieeu.Elemento_Id = Ie.Id_Elemento
                                      LEFT JOIN Db_Infraestructura.Info_Ubicacion              Iu ON Iu.Id_Ubicacion = Ieeu.Ubicacion_Id
                                      LEFT JOIN Db_General.Admi_Parroquia                      Apa ON Apa.Id_Parroquia = Iu.Parroquia_Id
                                      LEFT JOIN Db_General.Admi_Canton                         Ac ON Ac.Id_Canton = Apa.Canton_Id
                                      LEFT JOIN Db_Soporte.Info_Detalle                        Idt ON ( Idr.Detalle_Id = Idt.Id_Detalle
                                                                                 OR Idr.Actividad_Id = Idt.Id_Detalle )
                                      LEFT JOIN Db_Comunicacion.Info_Comunicacion              Ico ON Ico.Detalle_Id = Idt.Id_Detalle ');
            
    DBMS_LOB.APPEND(Lcl_QueryWhere,'WHERE Ido.Id_Documento = Idr.Documento_Id
                                       AND ido.estado <> ''Eliminado''
                                       AND idr.estado <> ''Eliminado'' ');

    DBMS_LOB.APPEND(Lcl_QueryOrderBy, 'ORDER BY ido.fe_Creacion DESC');
    
    IF Lv_FechaDesde IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ido.fe_Creacion >= To_Date('':fechaDesde'',''rrrr-mm-dd hh24:mi:ss'') ',':fechaDesde',Lv_FechaDesde));
    END IF;
    
    IF Lv_FechaHasta IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ido.fe_Creacion <= To_Date('':fechaHasta'',''rrrr-mm-dd hh24:mi:ss'') + 1 ',':fechaHasta',Lv_FechaHasta));
    END IF;
    
    IF Lv_TipoElemento IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ate.Id_Tipo_Elemento = :tipoElemento ',':tipoElemento',Lv_TipoElemento));
    END IF;

    IF Lv_ModeloElemento IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ame.Id_Modelo_Elemento = :modeloElemento ',':modeloElemento',Lv_ModeloElemento));
    END IF;

    IF Lv_Elemento IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND Ie.Id_Elemento = :elemento ',':elemento',Lv_Elemento));
    END IF;    

    IF Lv_EstadoEvaluacion IS NOT NULL THEN
      IF Lv_EstadoEvaluacion = 'Pendiente' THEN
        DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND (idr.Estado_Evaluacion = '':strEstadoEvaluacion'' 
                                                 OR (idr.Estado_Evaluacion IS NULL 
                                                    AND (idr.caso_Id IS NOT NULL 
                                                      OR idr.elemento_Id IS NOT NULL))) ',':strEstadoEvaluacion',Lv_EstadoEvaluacion));
      ELSE
        DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND idr.Estado_Evaluacion = '':strEstadoEvaluacion'' ',':strEstadoEvaluacion',Lv_EstadoEvaluacion));
      END IF;      
    END IF;
            
    IF Lv_Login IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryFrom,', DB_COMERCIAL.Info_Servicio infs,
                                      DB_COMERCIAL.Info_Punto infp ');
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND idr.servicio_Id = infs.id_servicio
                                              AND infs.punto_Id = infp.id_punto
                                              AND infp.login like ''%:login%'' ',':login',lower(Lv_Login)));                                      
    END IF;

    IF Lv_TipoSoporte IS NOT NULL THEN
      IF Lv_TipoSoporte = 'caso' THEN
        
        IF Lv_NumeroSoporte IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ic.numero_Caso = '':caso'' ',':caso',Lv_NumeroSoporte));
        END IF;
        
        IF Lv_FechaDesdeSoporte IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ic.fe_Creacion >= To_Date('':fechaDesdeSoporte'',''rrrr-mm-dd'') ',':fechaDesdeSoporte',Lv_FechaDesdeSoporte));
        END IF;
        
        IF Lv_FechaHastaSoporte IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ic.fe_Creacion <= To_Date('':fechaHastaSoporte'',''rrrr-mm-dd'') + 1 ',':fechaHastaSoporte',Lv_FechaHastaSoporte));
        END IF;
        
        IF Lv_Empresa IS NOT NULL AND Lv_Empresa <> '0' THEN 
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ic.empresa_Cod = '':empresa'' ',':empresa',Lv_Empresa));
        END IF;
        
        IF Lv_Departamento IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryFrom,', DB_SOPORTE.Info_Detalle_Hipotesis idh,
                                          DB_SOPORTE.Info_Caso_Asignacion ica ');
                                          
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ic.id_caso = idh.caso_Id 
                                                  AND idh.id_detalle_hipotesis = ( SELECT MAX(idhMax.id)  
                                                                 FROM DB_SOPORTE.Info_Detalle_Hipotesis idhMax
                                                                 WHERE idhMax.caso_Id = idh.caso_Id )
                                                  AND idh.id_detalle_hipotesis = ica.detalle_Hipotesis_Id
                                                  AND ica.asignado_Id = :departamento ',':departamento',Lv_Departamento));      
                                      
        END IF;
      END IF;
      IF Lv_TipoSoporte = 'tarea' THEN
        
        IF Lv_NumeroSoporte IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ico.id_comunicacion = :tarea ',':tarea',Lv_NumeroSoporte));
        END IF;
        
        IF Lv_FechaDesdeSoporte IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND idt.fe_Creacion >= To_Date('':fechaDesdeSoporte'',''rrrr-mm-dd'') ',':fechaDesdeSoporte',Lv_FechaDesdeSoporte));
        END IF;
        
        IF Lv_FechaHastaSoporte IS NOT NULL THEN
          DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND idt.fe_Creacion <= To_Date('':fechaHastaSoporte'',''rrrr-mm-dd'') + 1 ',':fechaHastaSoporte',Lv_FechaHastaSoporte));
        END IF;
        
        IF Lv_Empresa IS NOT NULL AND Lv_Empresa <> '0' THEN        
          DBMS_LOB.APPEND(Lcl_QueryFrom,', DB_SOPORTE.Info_Detalle_Asignacion ida ');
          DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Idt.Id_Detalle = ida.detalle_Id '); 
          IF Lv_Departamento IS NOT NULL THEN
            DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ida.asignado_Id = :departamento ',':departamento',Lv_Departamento));
          ELSE
            DBMS_LOB.APPEND(Lcl_QueryFrom,', DB_GENERAL.Admi_Departamento ad ');
            DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ad.id_departamento = ida.asignado_Id 
                                                    AND ad.empresa_Cod = '':empresa'' ',':empresa',Lv_Empresa));
          END IF;
        END IF;
        
      END IF;
    END IF;
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,'AND ( ( Atdg.Descripcion_Tipo_Documento = ''IMAGENES''
                                    AND Atdg.Estado = ''Activo'')
                                      OR ( Ido.Tipo_Documento_Id IN (
                                        SELECT
                                          Atd.Id_Tipo_Documento
                                        FROM
                                          Db_Comunicacion.Admi_Tipo_Documento Atd
                                        WHERE
                                          ( Atd.Extension_Tipo_Documento = ''JPEG''
                                            OR Atd.Extension_Tipo_Documento = ''JPG''
                                            OR Atd.Extension_Tipo_Documento = ''PNG'' )
                                            AND Atd.Estado = ''Activo''
                                          ) ) ) ');
        
    DBMS_LOB.APPEND(Lcl_QueryFrom,', Db_Comercial.Info_Persona Ipe
                                      LEFT JOIN Db_Comercial.Info_Persona_Empresa_Rol Iper ON ( Ipe.Id_Persona = Iper.Persona_Id
                                                                                            AND Iper.Estado <> ''Eliminado'' )
                                      LEFT JOIN Db_Comercial.Info_Oficina_Grupo Iog ON Iog.Id_Oficina = Iper.Oficina_Id
                                      LEFT JOIN Db_General.Admi_Canton Aca ON Aca.Id_Canton = Iog.Canton_Id ');
    
    DBMS_LOB.APPEND(Lcl_QueryWhere,'AND Ipe.Login = Ido.Usr_Creacion
                                    AND Ipe.Estado <> ''Eliminado'' ');
                                    
    IF Lv_RegionSesion IS NOT NULL THEN    
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ( Aca.region = '':strRegionSession'' 
                                              OR (Ac.region = '':strRegionSession'' 
                                                AND idr.elemento_Id IS NOT NULL)) ',':strRegionSession',Lv_RegionSesion));
    END IF;
    
    IF Lv_Identificacion IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ip.identificacion_Cliente = :identificacion ',':identificacion',Lv_Identificacion));
    END IF;
    
    IF Lv_Nombres IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ip.nombres like ''%:nombres%'' ',':nombres',UPPER(Lv_Nombres)));
    END IF;
    
    IF Lv_Apellidos IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ip.apellidos like ''%:apellidos%'' ',':apellidos',UPPER(Lv_Apellidos)));
    END IF;
    
    IF Lv_RazonSocial IS NOT NULL THEN
      DBMS_LOB.APPEND(Lcl_QueryWhere,REPLACE('AND ip.razonSocial like ''%:razonSocial%'' ',':razonSocial',UPPER(Lv_RazonSocial)));
    END IF;
    
    
    DBMS_LOB.APPEND(Lcl_QueryCount,'select count(1) cantidad from (');
    DBMS_LOB.APPEND(Lcl_QueryCount,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_QueryCount,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_QueryCount,Lcl_QueryWhere);
    DBMS_LOB.APPEND(Lcl_QueryCount,Lcl_QueryOrderBy);
    DBMS_LOB.APPEND(Lcl_QueryCount, ')');
    
    OPEN Lrf_CantImagenes FOR Lcl_QueryCount;
    
    LOOP
      FETCH Lrf_CantImagenes BULK COLLECT INTO Lt_CantidadImagenes LIMIT 1;
      Li_Cont := Lt_CantidadImagenes.FIRST;
      WHILE (Li_Cont IS NOT NULL) LOOP
        Ln_TotalImagenes := Lt_CantidadImagenes(Li_Cont).Cantidad_Registros;
        Li_Cont:= Lt_CantidadImagenes.NEXT(Li_Cont);
      END LOOP;
      EXIT WHEN Lrf_CantImagenes%NOTFOUND;
    END LOOP;
    
    DBMS_LOB.APPEND(Lcl_Query,'select * from ( select ROWNUM rn,tabla.* from (');
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
    DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryOrderBy);
    DBMS_LOB.APPEND(Lcl_Query, REPLACE(REPLACE(') tabla where ROWNUM <= :limit ) where rn >= :inicio',':limit',(Ln_Limite*Ln_Pagina)),':inicio',(Ln_Inicio+1)));
    
    OPEN Lrf_Imagenes FOR Lcl_Query;
    
    OPEN C_GetCronFotosObligatorias;
    FETCH C_GetCronFotosObligatorias INTO Lc_CronologiaFotos;
    CLOSE C_GetCronFotosObligatorias;
    
    Lv_CronFotoAntes := NVL(Lc_CronologiaFotos.Valor1,'ANTES');
    Lv_CronFotoDespues := NVL(Lc_CronologiaFotos.Valor2,'DESPUES');
    
    LOOP
      FETCH Lrf_Imagenes BULK COLLECT INTO Lt_Imagenes LIMIT 25;
      Li_Cont := Lt_Imagenes.FIRST;
      WHILE (Li_Cont IS NOT NULL) LOOP
        DBMS_LOB.APPEND(Lcl_Response,'{');
        DBMS_LOB.APPEND(Lcl_Response,'"intIdImagen":'||Lt_Imagenes(Li_Cont).Id_Documento||',');
        DBMS_LOB.APPEND(Lcl_Response,'"strPersonaNombre":"'||INITCAP(LOWER(Lt_Imagenes(Li_Cont).Nombres))||' '||INITCAP(LOWER(Lt_Imagenes(Li_Cont).Apellidos))||'",');
        DBMS_LOB.APPEND(Lcl_Response,'"strNombreImagen":"'||Lt_Imagenes(Li_Cont).Nombre_Documento||'_'||Lt_Imagenes(Li_Cont).Id_Documento_Relacion||'",');
        Lv_ContAdicImagen := '';
        IF Lt_Imagenes(Li_Cont).Numero_Caso IS NOT NULL THEN
          Lv_ContAdicImagen := '<div class=''fila''><div class=''label''> Número Caso:</div><div class=''descripcion''>'||Lt_Imagenes(Li_Cont).Numero_Caso||'</div></div>';
        END IF;
        IF Lt_Imagenes(Li_Cont).Numero_Tarea IS NOT NULL THEN
          Lv_ContAdicImagen := '<div class=''fila''><div class=''label''> Número Tarea:</div><div class=''descripcion''>'||Lt_Imagenes(Li_Cont).Numero_Tarea||'</div></div>';
        END IF;
        DBMS_LOB.APPEND(Lcl_Response,'"strContenidoAdicImagen":"'||Lv_ContAdicImagen||'",');
        Lv_InfoEvalImagen := '';
        IF (Lt_Imagenes(Li_Cont).Id_Elemento IS NOT NULL 
          OR Lt_Imagenes(Li_Cont).Numero_Caso IS NOT NULL 
            OR Lt_Imagenes(Li_Cont).Numero_Tarea IS NOT NULL)
              AND Lt_Imagenes(Li_Cont).Estado_Evaluacion IS NOT NULL THEN
          Ln_IdTipoElemento := NVL(Lt_Imagenes(Li_Cont).Id_Tipo_Elemento,0);
          Lv_EstadoEvaluacion := NVL(Lt_Imagenes(Li_Cont).Estado_Evaluacion,'Pendiente'); 
          DBMS_LOB.APPEND(Lcl_Response,'"strEstadoEvaluacion":"'||Lv_EstadoEvaluacion||'",');
          Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Estado de Auditoría:</div><div class=''descripcion'' id=''estadoEvaluacion''>'||Lv_EstadoEvaluacion||'</div></div>';
          IF Lv_EstadoEvaluacion = 'Auditada' THEN
            IF Lt_Imagenes(Li_Cont).Tipo_Elemento_Id IS NOT NULL THEN
              OPEN C_GetInfoTipoElementoPorId(Lt_Imagenes(Li_Cont).Tipo_Elemento_Id);
              FETCH C_GetInfoTipoElementoPorId INTO Lc_TipoElemento;
              CLOSE C_GetInfoTipoElementoPorId;
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Tipo Elemento:</div><div class=''descripcion''>'||Lc_TipoElemento.Nombre_Tipo_Elemento||'</div></div>';
            END IF;
            IF Lt_Imagenes(Li_Cont).Porcentaje_Evaluado IS NOT NULL THEN
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Porcentaje Base:</div><div class=''descripcion'' id=''porcentajeBase''>'||Lt_Imagenes(Li_Cont).Porcentaje_Evaluacion_Base||'%</div></div>';
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Porcentaje Obtenido:</div><div class=''descripcion'' id=''porcentajeObtenido''>'||Lt_Imagenes(Li_Cont).Porcentaje_Evaluado||'%</div></div>';
            END IF;
            IF Lt_Imagenes(Li_Cont).Evaluacion_Trabajo IS NOT NULL THEN
               Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Evaluación Trabajo:</div><div class=''descripcion''>'||Lt_Imagenes(Li_Cont).Evaluacion_Trabajo||'</div></div>';
            END IF;
            IF Lt_Imagenes(Li_Cont).Nombre_Evaluador IS NOT NULL THEN
               Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Evaluador:</div><div class=''descripcion''>'||INITCAP(LOWER(Lt_Imagenes(Li_Cont).Nombre_Evaluador))||'</div></div>';
            END IF;
          ELSIF Lb_Role292_5557 
            AND (Lv_EstadoEvaluacion = 'Pendiente' 
              OR (Lv_EstadoEvaluacion = 'En Proceso' AND Lt_Imagenes(Li_Cont).Usr_Evaluacion = Lv_UsuarioSesion)) THEN
              Lv_StyleForm := '';
              IF Lv_EstadoEvaluacion = 'Pendiente' THEN
                Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div align=''center''><span class=''height20px''><a id=''btnEvaluar'' href=''javascript:void(0);'' onclick=''iniciarEvaluacion('||Lt_Imagenes(Li_Cont).Id_Documento_Relacion||')'' class=''button-crud''>Evaluar</a></span></div>';
                Lv_StyleForm := 'style=''display:none''';
              ELSE
                Lv_StyleForm := 'style=''display:block''';
              END IF;
              
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<form id=''formularioEvaluacion_'||Lt_Imagenes(Li_Cont).Id_Documento_Relacion||''' name=''formularioEvaluacion_'||Lt_Imagenes(Li_Cont).Id_Documento_Relacion||''' '||Lv_StyleForm||' >';
              IF INSTR(Lt_Imagenes(Li_Cont).Nombre_Documento,Lv_CronFotoDespues) > 0 THEN
                IF Lt_Imagenes(Li_Cont).Porcentaje_Evaluado IS NOT NULL THEN
                  Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Porcentaje Base:</div><div class=''descripcion'' id=''porcentajeBase''>'||Lt_Imagenes(Li_Cont).Porcentaje_Evaluacion_Base||'%</div></div>';
                  Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Porcentaje Obtenido:</div><div class=''descripcion'' id=''porcentajeObtenido''>'||Lt_Imagenes(Li_Cont).Porcentaje_Evaluado||'%</div></div>';
                END IF;
              ELSE
                 Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Tipo Elemento:</div><div class=''descripcion''>';
                Ln_CuentaReg := 1;
                FOR i in C_GetInfoTipoElemento LOOP
                  IF Ln_CuentaReg = 1 THEN
                    Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<select name=''tipoElementoEvaluacion'' required><option value=''''>Seleccione...</option>';
                  END IF;
                  Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<option value='''||i.Id_Tipo_Elemento||''' ';
                  IF  i.Id_Tipo_Elemento = Ln_IdTipoElemento THEN
                    Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'selected=''selected'' ';
                  END IF;
                  Lv_InfoEvalImagen := Lv_InfoEvalImagen ||' > '||INITCAP(LOWER(i.Nombre_Tipo_Elemento))||'</option>';
                  Ln_CuentaReg := Ln_CuentaReg + 1;
                END LOOP;
                Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'</select>';
                Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'</div></div>';
              END IF;
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Evaluación Trabajo:</div><div class=''descripcion''>';
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<select name=''evaluacionTrabajo''><option value=''''>Seleccione...</option>';  
              FOR i in C_GetValoresEvaluacionTrabajo LOOP
                 Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<option value='''||i.valor1||''' > '||i.valor2;
              END LOOP;
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'</select></div></div><br>';
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div align=''center''><span class=''height20px''><a href=''javascript:void(0);'' onclick=''evaluarTrabajo('||Lt_Imagenes(Li_Cont).Id_Documento_Relacion||')'' class=''button-crud''>Guardar Evaluación</a></span></div>';
              Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'</form>';
          ELSIF Lv_EstadoEvaluacion = 'En Proceso' 
            AND Lt_Imagenes(Li_Cont).Usr_Evaluacion <> Lv_UsuarioSesion 
              AND Lt_Imagenes(Li_Cont).Nombre_Evaluador IS NOT NULL THEN
               Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'<div class=''fila''><div class=''label''>Evaluador:</div><div class=''descripcion''>'||INITCAP(LOWER(Lt_Imagenes(Li_Cont).Nombre_Evaluador))||'</div></div>';
          ELSE
            Lv_InfoEvalImagen := Lv_InfoEvalImagen ||'';
          END IF;            
        END IF;
        DBMS_LOB.APPEND(Lcl_Response,'"strInfoEvaluacionImg":"'||Lv_InfoEvalImagen||'",');
        Lv_NombreFotoAntes := '';
        IF INSTR(Lt_Imagenes(Li_Cont).Nombre_Documento,Lv_CronFotoDespues) > 0 THEN
          Lv_NombreFotoAntes := REPLACE(Lt_Imagenes(Li_Cont).Nombre_Documento,Lv_CronFotoDespues,Lv_CronFotoAntes);
          IF Lv_NombreFotoAntes IS NOT NULL THEN
            Lv_NombreFotoAntes := substr(Lv_NombreFotoAntes, 
                                                    0, 
                                                    INSTR(Lv_NombreFotoAntes, 
                                                      '_', 
                                                      (INSTR(Lv_NombreFotoAntes, 
                                                        '_')+1)));

          END IF;
        END IF;
        IF Lv_NombreFotoAntes IS NOT NULL THEN
          Lv_NombreFotoAntes := Lv_NombreFotoAntes||'%';
        END IF;
            
        OPEN C_GetImagenesAntesDespues(Lv_NombreFotoAntes,Lt_Imagenes(Li_Cont).Login);
        FETCH C_GetImagenesAntesDespues INTO Lc_ImagenesAntes;
        CLOSE C_GetImagenesAntesDespues;
        
        IF Lc_ImagenesAntes.Id_Documento IS NOT NULL THEN
          Lv_UrlImagenAntes := Lc_ImagenesAntes.Ubicacion_Fisica_Documento;
        END IF;
        DBMS_LOB.APPEND(Lcl_Response,'"strUrlImagen":"'||Lt_Imagenes(Li_Cont).Url_Imagen||'",');
        DBMS_LOB.APPEND(Lcl_Response,'"strUrlImagenAntes":"'||Lv_UrlImagenAntes||'",');
        DBMS_LOB.APPEND(Lcl_Response,'"strPersonaLogin":"'||Lt_Imagenes(Li_Cont).Login||'",');
        DBMS_LOB.APPEND(Lcl_Response,'"strFechaCreacion":"'||TO_CHAR(Lt_Imagenes(Li_Cont).Fe_Creacion,'DD Mon YYYY')||'",');
        DBMS_LOB.APPEND(Lcl_Response,'"strLongitud":"'||Lt_Imagenes(Li_Cont).Longitud||'",');
        DBMS_LOB.APPEND(Lcl_Response,'"strLatitud":"'||Lt_Imagenes(Li_Cont).Latitud||'"');
        DBMS_LOB.APPEND(Lcl_Response,'}|');
        Li_Cont:= Lt_Imagenes.NEXT(Li_Cont);
      END LOOP;
      EXIT WHEN Lrf_Imagenes%NOTFOUND;
    END LOOP;
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Consulta exitosa';    
    Pcl_Response := Lcl_Response;
    Pn_TotalRegistros := Ln_TotalImagenes;
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_GET_IMAGENES_POR_CRITERIOS;

END CUKG_CONSULTS;
/
