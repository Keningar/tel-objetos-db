CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_FOX_PREMIUM AS

    /*--- TYPES DEL PAQUETE ---*/
    TYPE T_ARRAY_OF_VARCHAR IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

  /**
   * Record necesario en los par�metros para la creaci�n de solicitudes de instalaci�n.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 23-11-2018
   *     REQUEST_URL          => URL del WS consumir.
   *     REQUEST_METHOD       => M�todo del WS a consumir.
   *     HEADER_AUTHORIZATION => Cabecera Authorization del Request a consumir.
   *     URL_FILE_DIGITAL     => (Oracle Wallet) Ruta del archivo de certificado.
   *     PASSWD_FILE_DIGITAL  => (Oracle Wallet) Contrase�a del archivo del certificado.
   *     KEY_STATUS_OK        => Tag que contiene el valor booleano por respuesta true en caso de �xito. *Requerido*
   *     KEY_VALUE_OK         => Tag y valor que se eval�a por un texto. tag=valor
   *     KEYS_ERROR           => Tags de error mapeados para poder obtener los mensajes de error. tagError|tagError2|..|tagErrorN
   */
  TYPE Lr_ConsumoWebService IS RECORD (
        REQUEST_URL          VARCHAR2(3000),
        REQUEST_METHOD       VARCHAR2(3000),
        HEADER_AUTHORIZATION VARCHAR2(3000),
        URL_FILE_DIGITAL     VARCHAR2(3000),
        PASSWD_FILE_DIGITAL  VARCHAR2(3000),
        KEY_STATUS_OK        VARCHAR2(3000),
        KEY_VALUE_OK         VARCHAR2(3000),
        KEYS_ERROR           VARCHAR2(3000)
    );

    /**
     * Funci�n que devuelve la configuraci�n para el consumo del WS de FOX.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 17-12-2018
     */
    FUNCTION F_GET_WS_CLEAR_CACHE (Pv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE DEFAULT 'CONFIGURACION_WS_CLEAR_CACHE')
    RETURN DB_COMERCIAL.CMKG_FOX_PREMIUM.Lr_ConsumoWebService;

    /**
     * Procedimiento que realiza las validaciones necesarias para para consumir o no el WS de Toolbox.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 11-12-2018
     *
     */
    PROCEDURE P_PROCESA_CLEAR_CACHE_TOOLBOX(Pn_IdServicio     IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                            Pv_EstadoAnterior IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE DEFAULT 'Telcos1',
                                            Pv_EstadoNuevo    IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE DEFAULT 'Telcos2',
                                            Pn_ProductoId     IN  DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE,
                                            Pv_Mensaje        OUT VARCHAR2);

    /**
     * Procedimiento que obtiene la informaci�n necesaria para el webService de ToolBox y posteriormente realiza el consumo.
     * Crea historial por �xito o error.
     * Si la petici�n tiene errores, se crea un proceso masivo seg�n la bandera Pv_CreaProcMasivo para posteriormente hacer un reintento.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 11-12-2018
     */
    PROCEDURE P_CLEAR_CACHE_TOOLBOX (Pv_SubscriberId    IN  VARCHAR2,
                                     Pn_IdServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_EstadoServicio  IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                     Pv_CreaProcMasivo  IN  VARCHAR2 DEFAULT 'S',
                                     Pr_ConfiguracionWS IN  DB_COMERCIAL.CMKG_FOX_PREMIUM.Lr_ConsumoWebService,
                                     Pv_UsrCreacion     IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.USR_CREACION%TYPE DEFAULT 'telcosFox',
                                     Pv_IpCreacion      IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.IP_CREACION%TYPE  DEFAULT '127.0.0.1',
                                     Pv_Mensaje         OUT VARCHAR2);

    /**
     * Procedimiento que realiza el consumo de un WS.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 11-12-2018
     */
    PROCEDURE P_CONSUME_WEB_SERVICE (Pv_Url             IN  VARCHAR2,
                                     Pv_Method          IN  VARCHAR2,
                                     Pcl_Body           IN  CLOB,
                                     Pv_ContentType     IN  VARCHAR2,
                                     Pv_Charset         IN  VARCHAR2,
                                     Pv_Authorization   IN  VARCHAR2,
                                     Pv_UrlFileDigital  IN  VARCHAR2,
                                     Pv_PassFileDigital IN  VARCHAR2,
                                     Pcl_Response       OUT CLOB,
                                     Pv_Error           OUT VARCHAR2);

    /**
     * Funci�n que realiza el split de una cadena.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 12-12-2018
     */
    FUNCTION F_SPLIT_VARCHAR2 (Pv_String    IN  VARCHAR2,
                             Pv_Delimiter IN  VARCHAR2)
    RETURN DB_COMERCIAL.CMKG_FOX_PREMIUM.T_ARRAY_OF_VARCHAR;

    /**
     * Procedimiento que crea los procesos masivos por error en el consumo de fox.
     * Flujo del PMA:
     *               1) Pendiente  => Cuando se crea el registro por alg�n error.
     *               2) Finalizado => Cuando se realiza el reintento al WS.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 13-12-2018
     */
    PROCEDURE P_CREA_PMA_X_ERROR (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                  Pv_SubscriberId  IN  VARCHAR2,
                                  Pv_TipoProceso   IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE DEFAULT 'ReintentoFox',
                                  Pv_Mensaje       OUT VARCHAR2);

    /**
     * Procedimiento que valida una respuesta de fox premium
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @since 12-12-2018
     * @version 1.0
     */
    FUNCTION F_VALIDA_RESPUESTA_FOX_PREMIUM (Pcl_JsonResponse  IN  CLOB,
                                             Pv_KeyStatusOK    IN  VARCHAR2,
                                             Pv_KeyValueOK     IN  VARCHAR2,
                                             Pv_KeysError      IN  VARCHAR2)
    RETURN VARCHAR2;

    /**
     * Procedimiento que es llamado desde "DB_COMERCIAL"."JOB_REPROCESA_FOX_PREMIUM"
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 14-12-2018
     */
    PROCEDURE P_JOB_CLEAR_CACHE_TOOLBOX (Pv_TipoProceso IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE DEFAULT 'ReintentoFox',
                                         Pv_EstadoCab   IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE DEFAULT 'Pendiente',
                                         Pv_EstadoDet   IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE DEFAULT 'Pendiente',
                                         Pd_FeProceso   IN  DATE DEFAULT TRUNC(SYSDATE),
                                         Pv_Mensaje     OUT VARCHAR2);

END CMKG_FOX_PREMIUM;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_FOX_PREMIUM AS
    PROCEDURE P_PROCESA_CLEAR_CACHE_TOOLBOX(Pn_IdServicio     IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                            Pv_EstadoAnterior IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE DEFAULT 'Telcos1',
                                            Pv_EstadoNuevo    IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE DEFAULT 'Telcos2',
                                            Pn_ProductoId     IN  DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE,
                                            Pv_Mensaje        OUT VARCHAR2)
    AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        Le_NoAplicaProceso       EXCEPTION;
        Ln_Bandera               NUMBER := 0;
        Lv_SubscriberId          VARCHAR2(100);
        Lr_InfoServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
        Lr_Configuracion         DB_COMERCIAL.CMKG_FOX_PREMIUM.Lr_ConsumoWebService;

        --COSTO DE QUERY 2
        CURSOR C_GetProductoFox (Cn_ProductoId       DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE,
                                 Cv_NombreTecnicoFox VARCHAR2 DEFAULT 'FOXPREMIUM',
                                 Cv_EstadoEliminado  VARCHAR2 DEFAULT 'Eliminado')
        IS
            SELECT COUNT(*) AS TOTAL
              FROM DB_COMERCIAL.ADMI_PRODUCTO AP
             WHERE AP.ID_PRODUCTO = Cn_ProductoId
               AND NOMBRE_TECNICO = Cv_NombreTecnicoFox
               AND ESTADO <> Cv_EstadoEliminado;

        --COSTO QUERY 3
        CURSOR C_EstadosPermitidos (Cv_EstadoAnterior  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                    Cv_EstadoNuevo     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                    Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE DEFAULT 'ESTADOS_PERMITIDOS_CLEAR_CACHE',
                                    Cv_EstadoActivo    VARCHAR2 DEFAULT 'Activo')
        IS
            SELECT DET.ID_PARAMETRO_DET
              FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                   DB_GENERAL.ADMI_PARAMETRO_DET DET
             WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
               AND CAB.ESTADO = Cv_EstadoActivo
               AND CAB.ID_PARAMETRO = DET.PARAMETRO_ID
               AND DET.ESTADO = Cv_EstadoActivo
               AND VALOR1 = Cv_EstadoAnterior
               AND VALOR2 = Cv_EstadoNuevo;

        
        CURSOR C_GetSubscriberFox (Cn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Cn_ProductoId     DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE,
                                   Cv_Caracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE DEFAULT 'SSID_FOX',
                                   Cv_EstadoActivo   VARCHAR2 DEFAULT 'Activo')
        IS
            SELECT ISPC.VALOR
              FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
                   DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                   DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
             WHERE APC.PRODUCTO_ID = Cn_ProductoId
               AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
               AND AC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
               AND AC.ESTADO = Cv_EstadoActivo
               AND APC.ESTADO = Cv_EstadoActivo
               AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
               AND ISPC.SERVICIO_ID = Cn_IdServicio
               AND ISPC.ESTADO = Cv_EstadoActivo;
    BEGIN
        --Si el origen no es telcos, se realizan las validaciones de estados y producto.
        IF Pv_EstadoNuevo = Pv_EstadoAnterior THEN
            RAISE Le_NoAplicaProceso;
        END IF;

        --Se verifica que el servicio sea un producto Fox Premium
        IF Pn_ProductoId IS NULL THEN
            RAISE Le_NoAplicaProceso;
        END IF;

        OPEN  C_GetProductoFox (Cn_ProductoId => Pn_ProductoId);
        FETCH C_GetProductoFox INTO Ln_Bandera;
        CLOSE C_GetProductoFox;

        IF NVL(Ln_Bandera, 0) = 0 THEN
            RAISE Le_NoAplicaProceso;
        END IF;

        Ln_Bandera := 0;
        --Se validan los estados permitidos para el consumo del ws
        OPEN  C_EstadosPermitidos (Cv_EstadoAnterior => Pv_EstadoAnterior,
                                   Cv_EstadoNuevo    => Pv_EstadoNuevo);
        FETCH C_EstadosPermitidos INTO Ln_Bandera;
        CLOSE C_EstadosPermitidos;

        IF NVL (Ln_Bandera, 0) = 0 THEN
            RAISE Le_NoAplicaProceso;
        END IF;

        OPEN  C_GetSubscriberFox (Cn_IdServicio  => Pn_IdServicio,
                                  Cn_ProductoId  => Pn_ProductoId);
        FETCH C_GetSubscriberFox INTO Lv_SubscriberId;
        CLOSE C_GetSubscriberFox;

        --Se Obtiene la configuraci�n del WS.
        Lr_Configuracion := DB_COMERCIAL.CMKG_FOX_PREMIUM.F_GET_WS_CLEAR_CACHE;

        --Si se obtiene el usuario, se realiza el consumo clearCache.
        --Caso contrario, se escribe en el historial que no se ha encontrado un usuario activo.
        IF Lv_SubscriberId IS NOT NULL THEN
            DB_COMERCIAL.CMKG_FOX_PREMIUM.P_CLEAR_CACHE_TOOLBOX(Pv_SubscriberId    => Lv_SubscriberId,
                                                                Pn_IdServicio      => Pn_IdServicio,
                                                                Pv_EstadoServicio  => Pv_EstadoNuevo,
                                                                Pr_ConfiguracionWS => Lr_Configuracion,
                                                                Pv_CreaProcMasivo  => 'S',
                                                                Pv_Mensaje         => Pv_Mensaje);
        ELSE
            Lr_InfoServicioHistorial := NULL;
            Lr_InfoServicioHistorial.SERVICIO_ID  := Pn_IdServicio;
            Lr_InfoServicioHistorial.ESTADO       := Pv_EstadoNuevo;
            Lr_InfoServicioHistorial.USR_CREACION := 'telcosFox';
            Lr_InfoServicioHistorial.FE_CREACION  := SYSDATE;
            Lr_InfoServicioHistorial.IP_CREACION  := '127.0.0.1';
            Lr_InfoServicioHistorial.OBSERVACION  := 'No es posible establecer la comunicaci�n con Netlifeplay debido a que no tiene un usuario Activo.';
            DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Pr_servicioHistorial => Lr_InfoServicioHistorial,
                                                                       Lv_MensaError        => Pv_Mensaje);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN Le_NoAplicaProceso THEN
            Pv_Mensaje := NULL;
        WHEN OTHERS THEN
            ROLLBACK;
            Pv_Mensaje := 'Ha ocurrido un error inesperado: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos-FoxPremium',
                                                 'CMKG_FOX_PREMIUM.P_PROCESA_CLEAR_CACHE_TOOLBOX',
                                                 Pv_Mensaje,
                                                 'telcosFox',
                                                 SYSDATE, 
                                                 '127.0.0.1');
    END P_PROCESA_CLEAR_CACHE_TOOLBOX;

    PROCEDURE P_CLEAR_CACHE_TOOLBOX (Pv_SubscriberId    IN  VARCHAR2,
                                     Pn_IdServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_EstadoServicio  IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                     Pv_CreaProcMasivo  IN  VARCHAR2 DEFAULT 'S',
                                     Pr_ConfiguracionWS IN  DB_COMERCIAL.CMKG_FOX_PREMIUM.Lr_ConsumoWebService,
                                     Pv_UsrCreacion     IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.USR_CREACION%TYPE DEFAULT 'telcosFox',
                                     Pv_IpCreacion      IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.IP_CREACION%TYPE DEFAULT '127.0.0.1',
                                     Pv_Mensaje         OUT VARCHAR2)
    AS

        Lv_Url              VARCHAR2(3000) := Pr_ConfiguracionWS.REQUEST_URL;
        Lv_Method           VARCHAR2(3000) := Pr_ConfiguracionWS.REQUEST_METHOD;
        Lv_Authorization    VARCHAR2(3000) := Pr_ConfiguracionWS.HEADER_AUTHORIZATION;
        Lv_UrlFileDigital   VARCHAR2(3000) := Pr_ConfiguracionWS.URL_FILE_DIGITAL;
        Lv_PassFileDigital  VARCHAR2(3000) := Pr_ConfiguracionWS.PASSWD_FILE_DIGITAL;
        Lv_KeyStatusOK      VARCHAR2(3000) := Pr_ConfiguracionWS.KEY_STATUS_OK;
        Lv_KeyValueOK       VARCHAR2(3000) := Pr_ConfiguracionWS.KEY_VALUE_OK;
        Lv_KeysError        VARCHAR2(3000) := Pr_ConfiguracionWS.KEYS_ERROR;
        Lcl_Response        CLOB;
        Lv_MensajeError     VARCHAR2(3000) := NULL;
        Lv_ValidadorJson    VARCHAR2(3000) := NULL;
        Lv_BanderaError     VARCHAR2(1) := 'S';
        Le_Exception        EXCEPTION;

        Lr_InfoServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;

    BEGIN

        IF Lv_Url IS NULL OR Lv_Method IS NULL THEN
            Pv_Mensaje := 'No se ha encontrado una configuraci�n v�lida para la comunicaci�n con Toolbox (Netlifeplay).';
            RAISE Le_Exception;
        END IF;

        --Se reemplaza el {subscriber_id}
        Lv_Url := REPLACE(Lv_Url, '{subscriber_id}', Pv_SubscriberId);

        DB_COMERCIAL.CMKG_FOX_PREMIUM.P_CONSUME_WEB_SERVICE (Pv_Url             => Lv_Url,
                                                             Pv_Method          => Lv_Method,
                                                             Pcl_Body           => NULL,
                                                             Pv_ContentType     => NULL,
                                                             Pv_Charset         => NULL,
                                                             Pv_Authorization   => Lv_Authorization,
                                                             Pv_UrlFileDigital  => Lv_UrlFileDigital,
                                                             Pv_PassFileDigital => Lv_PassFileDigital,
                                                             Pcl_Response       => Lcl_Response,
                                                             Pv_Error           => Lv_MensajeError);

        --Si no es null, se valida el cuerpo del json de respuesta
        IF Lcl_Response IS NOT NULL THEN
            Lv_ValidadorJson := DB_COMERCIAL.CMKG_FOX_PREMIUM.F_VALIDA_RESPUESTA_FOX_PREMIUM (Pcl_JsonResponse  => Lcl_Response,
                                                                                              Pv_KeyStatusOK    => Lv_KeyStatusOK,
                                                                                              Pv_KeyValueOK     => Lv_KeyValueOK,
                                                                                              Pv_KeysError      => Lv_KeysError);
            IF Lv_ValidadorJson  IS NOT NULL THEN
                Lv_MensajeError := Lv_MensajeError || ':' || Lv_ValidadorJson;
            END IF;
        ELSE
            Lv_MensajeError := 'Error al obtener una respuesta de Toolbox (Netlifeplay). ' || Lv_MensajeError;
        END IF;

        --Si ocurri� un error al realizar la petici�n del WS, escribe historial en el servicio y crea el proceso masivo.
        Lr_InfoServicioHistorial              := NULL;
        IF Lv_MensajeError IS NOT NULL THEN
            Lr_InfoServicioHistorial.OBSERVACION  := 'No es posible establecer la comunicaci�n con Netlifeplay: El usuario no ha sido actualizado.'
                                                     || Lv_MensajeError;

            IF 'S' = Pv_CreaProcMasivo THEN
                --Se crea el Proceso Masivo para el reintento por error de conexi�n.
                DB_COMERCIAL.CMKG_FOX_PREMIUM.P_CREA_PMA_X_ERROR (Pn_IdServicio    => Pn_IdServicio,
                                                                  Pv_SubscriberId  => Pv_SubscriberId,
                                                                  Pv_TipoProceso   => 'ReintentoFox',
                                                                  Pv_Mensaje       => Pv_Mensaje);
                IF Pv_Mensaje IS NOT NULL THEN
                    RAISE Le_Exception;
                END IF;
            END IF;
        ELSE
            Lr_InfoServicioHistorial.OBSERVACION  := 'Se ha realizado la actualizaci�n en Netlifeplay de manera satisfactoria.';
        END IF;

        Lr_InfoServicioHistorial.SERVICIO_ID  := Pn_IdServicio;
        Lr_InfoServicioHistorial.ESTADO       := Pv_EstadoServicio;
        Lr_InfoServicioHistorial.USR_CREACION := Pv_UsrCreacion;
        Lr_InfoServicioHistorial.FE_CREACION  := SYSDATE;
        Lr_InfoServicioHistorial.IP_CREACION  := Pv_IpCreacion;
        DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Pr_servicioHistorial => Lr_InfoServicioHistorial,
                                                                   Lv_MensaError        => Pv_Mensaje);

        IF Pv_Mensaje IS NOT NULL THEN
            Pv_Mensaje := 'Error al crear el historial del servicio: ' || Pn_IdServicio || ' ' || Pv_Mensaje;
            RAISE Le_Exception;
        END IF;

        Pv_Mensaje:= Pv_Mensaje || ' ' ||Lv_MensajeError;
        COMMIT;
    EXCEPTION
        WHEN Le_Exception THEN
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos-FoxPremium',
                                                 'CMKG_FOX_PREMIUM.P_CLEAR_CACHE_TOOLBOX',
                                                 Pv_Mensaje,
                                                 Pv_UsrCreacion,
                                                 SYSDATE, 
                                                 Pv_IpCreacion);
        WHEN OTHERS THEN
            ROLLBACK;
            Pv_Mensaje := 'Ha ocurrido un error inesperado: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos-FoxPremium',
                                                 'CMKG_FOX_PREMIUM.P_CLEAR_CACHE_TOOLBOX',
                                                 Pv_Mensaje,
                                                 Pv_UsrCreacion,
                                                 SYSDATE, 
                                                 Pv_IpCreacion);
    END P_CLEAR_CACHE_TOOLBOX;

    PROCEDURE P_CONSUME_WEB_SERVICE (Pv_Url             IN  VARCHAR2,
                                     Pv_Method          IN  VARCHAR2,
                                     Pcl_Body           IN  CLOB,
                                     Pv_ContentType     IN  VARCHAR2,
                                     Pv_Charset         IN  VARCHAR2,
                                     Pv_Authorization   IN  VARCHAR2,
                                     Pv_UrlFileDigital  IN  VARCHAR2,
                                     Pv_PassFileDigital IN  VARCHAR2,
                                     Pcl_Response       OUT CLOB,
                                     Pv_Error           OUT VARCHAR2)
    AS
        Lhttp_Request   UTL_HTTP.REQ;
        Lhttp_Response  UTL_HTTP.RESP; 
        Lv_Respuesta    CLOB;
        Lv_Response     CLOB;
        Le_Exception    EXCEPTION;
    BEGIN

        --Se fija el wallet para peticiones HTTPS
        IF Pv_UrlFileDigital IS NOT NULL AND Pv_PassFileDigital IS NOT NULL THEN
            UTL_HTTP.set_wallet(Pv_UrlFileDigital, Pv_PassFileDigital);
        END IF;

        --Se crea la petici�n
        Lhttp_Request := UTL_HTTP.BEGIN_REQUEST(Pv_Url, Pv_Method);

        --Se agregan las cabeceras necesarias.
        IF Pv_ContentType IS NOT NULL THEN
            UTL_HTTP.SET_HEADER(Lhttp_Request, 'content-type', Pv_ContentType);
        END IF;

        IF Pv_Authorization IS NOT NULL THEN
            UTL_HTTP.SET_HEADER(Lhttp_Request, 'Authorization', Pv_Authorization);
        END IF;

        IF Pcl_Body IS NOT NULL THEN
            UTL_HTTP.SET_HEADER(Lhttp_Request, 'Content-Length', length(Pcl_Body));
            UTL_HTTP.WRITE_TEXT(Lhttp_Request, Pcl_Body);
        END IF;

        IF Pv_Charset IS NOT NULL THEN
            UTL_HTTP.SET_BODY_CHARSET(Lhttp_Request, Pv_Charset);
        END IF;

        Lhttp_Response := UTL_HTTP.GET_RESPONSE(Lhttp_Request);

        IF Lhttp_Response.STATUS_CODE <> 200 THEN
            Pcl_Response := NULL;
            Pv_Error     := 'Problemas al realizar la petici�n. STATUS_CODE:' || Lhttp_Response.STATUS_CODE;
            RAISE Le_Exception;
        END IF;

        BEGIN
            --Se obtiene la respuesta y se la escribe en una variable.
            LOOP
              UTL_HTTP.READ_LINE(Lhttp_Response, Lv_Response);
              Lv_Respuesta := Lv_Respuesta || Lv_Response;
            END LOOP;
            UTL_HTTP.END_RESPONSE(Lhttp_Response);
        EXCEPTION
            WHEN UTL_HTTP.END_OF_BODY THEN
                UTL_HTTP.END_RESPONSE(Lhttp_Response);
        END;

        Pcl_Response := Lv_Respuesta;
    EXCEPTION
        WHEN Le_Exception THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Oracle-WebService',
                                                 'CMKG_FOX_PREMIUM.P_CONSUME_WEB_SERVICE',
                                                 Pv_Error ||
                                                 ' ERROR: Pv_Url ' || Pv_Url ||
                                                 ' Pv_Method: ' || Pv_Method ||
                                                 ' Pv_Authorization: ' || Pv_Authorization,
                                                 'Oracle',
                                                 SYSDATE,
                                                 '127.0.0.1');
        WHEN OTHERS THEN
            Pv_Error := 'Error inesperado al realizar la petici�n entre servidores.';

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Oracle-WebService',
                                                 'CMKG_FOX_PREMIUM.P_CONSUME_WEB_SERVICE', 
                                                 ' ERROR: URL ' || Pv_Url || 
                                                 ' METHOD: ' || Pv_Method || 
                                                 ' AUTHORIZATION: ' || Pv_Authorization ||
                                                 ' STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                 'Oracle',
                                                 SYSDATE,
                                                 '127.0.0.1');
    END P_CONSUME_WEB_SERVICE;

    FUNCTION F_VALIDA_RESPUESTA_FOX_PREMIUM (Pcl_JsonResponse  IN  CLOB,
                                             Pv_KeyStatusOK    IN  VARCHAR2,
                                             Pv_KeyValueOK     IN  VARCHAR2,
                                             Pv_KeysError      IN  VARCHAR2)
    RETURN VARCHAR2
    AS
        Lv_RespuestaError  VARCHAR2(3000) := NULL;
        La_Array           DB_COMERCIAL.CMKG_FOX_PREMIUM.T_ARRAY_OF_VARCHAR;
        Ln_IndiceSeparador NUMBER;
        Lv_KeyMessageOK    VARCHAR2(250);
        Lv_ValueMessageOK  VARCHAR2(250);
        Li_Indice          PLS_INTEGER;
    BEGIN
        APEX_JSON.PARSE(Pcl_JsonResponse); 

        --Se obtiene el cuerpo del mensaje por respuesta OK
        Ln_IndiceSeparador := INSTR (Pv_KeyValueOK, '=');
        Lv_KeyMessageOK    := SUBSTR(Pv_KeyValueOK, 1, Ln_IndiceSeparador - 1);
        Lv_ValueMessageOK  := SUBSTR(Pv_KeyValueOK, Ln_IndiceSeparador + 1);

        IF APEX_JSON.GET_BOOLEAN(P_PATH=> Pv_KeyStatusOK) AND
           NVL(APEX_JSON.GET_VARCHAR2(P_PATH=> Lv_KeyMessageOK),'NULL') = NVL(Lv_ValueMessageOK,'NULL') THEN
            Lv_RespuestaError := NULL;
        ELSE
            La_Array          := DB_COMERCIAL.CMKG_FOX_PREMIUM.F_SPLIT_VARCHAR2(Pv_String    => Pv_KeysError,
                                                                                Pv_Delimiter => '|');
            --Se obtiene el error
            Li_Indice := La_Array.FIRST;
            WHILE (Li_Indice IS NOT NULL)
            LOOP
              Lv_RespuestaError := NVL(Lv_RespuestaError,'') || APEX_JSON.GET_VARCHAR2(P_PATH=> La_Array(Li_Indice)) || ' ';
              Li_Indice         := La_Array.NEXT(Li_Indice);
            END LOOP;

            IF TRIM(Lv_RespuestaError) IS NULL THEN
                Lv_RespuestaError := 'Error inesperado en la comunicaci�n.';
            END IF;
        END IF;
        RETURN TRIM(Lv_RespuestaError);
    EXCEPTION
        WHEN OTHERS THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos-FoxPremium',
                                                 'CMKG_FOX_PREMIUM.F_VALIDA_RESPUESTA_FOX_PREMIUM',
                                                 SUBSTR(Pcl_JsonResponse || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || 
                                                        DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 3999),
                                                 'telcosFox',
                                                 SYSDATE,
                                                 '127.0.0.1');
            RETURN 'Error inesperado al leer la respuesta de Toolbox (Netlifeplay).';
    END F_VALIDA_RESPUESTA_FOX_PREMIUM;

    FUNCTION F_SPLIT_VARCHAR2 (Pv_String    IN  VARCHAR2,
                             Pv_Delimiter IN  VARCHAR2)
    RETURN DB_COMERCIAL.CMKG_FOX_PREMIUM.T_ARRAY_OF_VARCHAR
    IS
        La_Array DB_COMERCIAL.CMKG_FOX_PREMIUM.T_ARRAY_OF_VARCHAR;
    BEGIN
        FOR Lr_CurrentRow IN (
          WITH TEST AS
            (SELECT Pv_String FROM DUAL)
            SELECT REGEXP_SUBSTR(Pv_String, '[^' || Pv_Delimiter || ']+', 1, ROWNUM) SPLIT
            FROM TEST
            CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE(Pv_String, '[^' || Pv_Delimiter || ']+'))  + 1)
        LOOP
          La_Array(La_Array.COUNT) := Lr_CurrentRow.SPLIT;
        END LOOP;

        RETURN La_Array;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN La_Array;
    END F_SPLIT_VARCHAR2;

    PROCEDURE P_CREA_PMA_X_ERROR (Pn_IdServicio    IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                  Pv_SubscriberId  IN  VARCHAR2,
                                  Pv_TipoProceso   IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE DEFAULT 'ReintentoFox',
                                  Pv_Mensaje       OUT VARCHAR2)
    AS
        --Costo del query 4
        CURSOR C_GetPMCab (Cv_TipoProceso     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                           Cv_EstadoPendiente VARCHAR2)
        IS
            SELECT ID_PROCESO_MASIVO_CAB
              FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB CAB
             WHERE CAB.TIPO_PROCESO = Cv_TipoProceso
               AND CAB.ESTADO = Cv_EstadoPendiente
               AND TRUNC(CAB.FE_CREACION) = TRUNC(SYSDATE);

        Ln_PMCabExistente  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
        Ln_PMDetExistente  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;
        Lv_EstadoPendiente VARCHAR2(15) := 'Pendiente';
        Lv_UsrCreacion     VARCHAR2(15) := 'telcosFox';
        Lv_IpCreacion      VARCHAR2(15) := '127.0.0.1';

        --Costo del query 4
        CURSOR C_GetPMDet (Cn_PMCabId    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.PROCESO_MASIVO_CAB_ID%TYPE,
                           Cn_ServicioId DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.SERVICIO_ID%TYPE)
        IS
            SELECT ID_PROCESO_MASIVO_DET
              FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET DET
             WHERE DET.PROCESO_MASIVO_CAB_ID = Cn_PMCabId
               AND SERVICIO_ID = Cn_ServicioId;
    BEGIN
        OPEN  C_GetPMCab (Cv_TipoProceso     => Pv_TipoProceso,
                          Cv_EstadoPendiente => Lv_EstadoPendiente);
        FETCH C_GetPMCab INTO Ln_PMCabExistente;
        CLOSE C_GetPMCab;

        IF NVL(Ln_PMCabExistente, 0) = 0 THEN
            --Si no existe el proceso masivo, se crea uno.
            Ln_PMCabExistente := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;

            INSERT INTO  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
                        (ID_PROCESO_MASIVO_CAB,
                         TIPO_PROCESO,
                         ESTADO,
                         FE_CREACION,
                         USR_CREACION,
                         IP_CREACION)
                 VALUES (Ln_PMCabExistente,
                         Pv_TipoProceso,
                         Lv_EstadoPendiente,
                         SYSDATE,
                         Lv_UsrCreacion,
                         Lv_IpCreacion);
        END IF;

        --Se verifica la existencia del PMDet para no insertarlo nuevamente.
        OPEN  C_GetPMDet (Cn_PMCabId     => Ln_PMCabExistente,
                          Cn_ServicioId  => Pn_IdServicio);
        FETCH C_GetPMDet INTO Ln_PMDetExistente;
        CLOSE C_GetPMDet;

        IF NVL(Ln_PMDetExistente, 0) = 0 THEN
            --Si no existe el detalle, se crea con el idServicio y subscriberId
            INSERT INTO  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
                        (ID_PROCESO_MASIVO_DET,
                         PROCESO_MASIVO_CAB_ID,
                         PUNTO_ID, --Campo obligatorio, se inserta el Servicio_id
                         SERVICIO_ID,
                         LOGIN,
                         ESTADO,
                         OBSERVACION,
                         USR_CREACION,
                         FE_CREACION,
                         IP_CREACION)
                 VALUES (DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL,
                         Ln_PMCabExistente,
                         Pn_IdServicio,  --Campo obligatorio, se inserta el Servicio_id
                         Pn_IdServicio,
                         Pv_SubscriberId,
                         Lv_EstadoPendiente,
                         'Se crea el registro para realizar el reintento.',
                         Lv_UsrCreacion,
                         SYSDATE,
                         Lv_IpCreacion);
        END IF;

        Pv_Mensaje := NULL;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            Pv_Mensaje := 'Error al crear el proceso masivo de reintentos: ServicioId:' || Pn_IdServicio || ' SubscriberId:' || Pv_SubscriberId ||
                           DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos-FoxPremium',
                                                 'CMKG_FOX_PREMIUM.P_CREA_PMA_X_ERROR',
                                                 Pv_Mensaje,
                                                 Lv_UsrCreacion,
                                                 SYSDATE,
                                                 Lv_IpCreacion);
    END P_CREA_PMA_X_ERROR;

    PROCEDURE P_JOB_CLEAR_CACHE_TOOLBOX (Pv_TipoProceso IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE DEFAULT 'ReintentoFox',
                                         Pv_EstadoCab   IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE DEFAULT 'Pendiente',
                                         Pv_EstadoDet   IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE DEFAULT 'Pendiente',
                                         Pd_FeProceso   IN  DATE DEFAULT TRUNC(SYSDATE),
                                         Pv_Mensaje     OUT VARCHAR2)
    AS
        Lv_UsrCreacion   VARCHAR2(15)   := 'JobFoxPremium';
        Lv_IpCreacion    VARCHAR2(15)   := '127.0.0.1';
        Lv_CabeceraAct   VARCHAR2(1)    := 'N';
        Lv_Estado        VARCHAR2(15)   := 'Finalizada';
        Lv_Pendiente     VARCHAR2(15)   := 'Pendiente';
        Lv_Finalizada    VARCHAR2(15)   := 'Finalizada';
        Lv_Observacion   VARCHAR2(4000) := NULL;
        Lv_SubscriberId  VARCHAR2(100)  := NULL;
        Ln_IdServicio    NUMBER         := NULL;
        Lr_Configuracion DB_COMERCIAL.CMKG_FOX_PREMIUM.Lr_ConsumoWebService;
        Le_GenException  EXCEPTION;

        --Se obtienen todos los servicios que no se realiz� correctamente el m�todo clearCache
        --Costo del query 9
        CURSOR C_GetServiciosFox (Cv_EstadoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
                                  Cv_EstadoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE,
                                  Cv_TipoProceso DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                  Cd_FeProceso   DATE)
        IS
            SELECT CAB.ID_PROCESO_MASIVO_CAB,
                   DET.ID_PROCESO_MASIVO_DET,
                   DET.SERVICIO_ID,
                   LOGIN AS SUBSCRIBER_ID,
                   ISER.ESTADO
              FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB CAB,
                   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET DET,
                   DB_COMERCIAL.INFO_SERVICIO ISER
             WHERE CAB.ESTADO = Cv_EstadoCab
               AND DET.ESTADO = Cv_EstadoDet
               AND CAB.TIPO_PROCESO = Cv_TipoProceso
               AND CAB.FE_CREACION >= TRUNC(Cd_FeProceso)
               AND DET.PROCESO_MASIVO_CAB_ID = CAB.ID_PROCESO_MASIVO_CAB
               AND ISER.ID_SERVICIO = DET.SERVICIO_ID;

    BEGIN
        --Se Obtiene la configuraci�n del WS.
        Lr_Configuracion := DB_COMERCIAL.CMKG_FOX_PREMIUM.F_GET_WS_CLEAR_CACHE;
        IF Lr_Configuracion.REQUEST_URL IS NULL THEN
            Pv_Mensaje   := 'No se encontr� una configuraci�n v�lida para el consumo del WS.';
            RAISE Le_GenException;
        END IF;

        --Se recorren los servicios que no se procesaron correctamente
        FOR Lr_ServicioFox IN C_GetServiciosFox (Cv_EstadoCab   => Pv_EstadoCab,
                                                 Cv_EstadoDet   => Pv_EstadoDet,
                                                 Cv_TipoProceso => Pv_TipoProceso,
                                                 Cd_FeProceso   => Pd_FeProceso)
        LOOP
            BEGIN
                Pv_Mensaje      := NULL;
                Lv_Observacion  := NULL;
                Lv_SubscriberId := Lr_ServicioFox.SUBSCRIBER_ID;
                Ln_IdServicio   := Lr_ServicioFox.SERVICIO_ID;
                IF Lr_ServicioFox.SUBSCRIBER_ID IS NOT NULL THEN
                    DB_COMERCIAL.CMKG_FOX_PREMIUM.P_CLEAR_CACHE_TOOLBOX(Pv_SubscriberId    => TO_CHAR(Lr_ServicioFox.SUBSCRIBER_ID),
                                                                        Pn_IdServicio      => Lr_ServicioFox.SERVICIO_ID,
                                                                        Pv_EstadoServicio  => Lr_ServicioFox.ESTADO,
                                                                        Pv_CreaProcMasivo  => 'N',
                                                                        Pr_ConfiguracionWS => Lr_Configuracion,
                                                                        Pv_UsrCreacion     => Lv_UsrCreacion,
                                                                        Pv_Mensaje         => Pv_Mensaje);
                END IF;

                --Se procesa el Proceso Masivo Cab.
                UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
                   SET ESTADO = Lv_Finalizada,
                       FE_ULT_MOD = SYSDATE,
                       USR_ULT_MOD = Lv_UsrCreacion
                 WHERE ID_PROCESO_MASIVO_CAB = Lr_ServicioFox.ID_PROCESO_MASIVO_CAB
                   AND ESTADO = Lv_Pendiente;

                Lv_Estado := Lv_Finalizada;
                IF Pv_Mensaje IS NOT NULL THEN
                    Lv_Estado      := 'Error';
                    Lv_Observacion := '| Ha ocurrido un error en el proceso: ' || Pv_Mensaje;
                END IF;

                UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
                   SET ESTADO = Lv_Estado,
                       FE_ULT_MOD = SYSDATE,
                       USR_ULT_MOD = Lv_UsrCreacion,
                       OBSERVACION = SUBSTR(OBSERVACION || Lv_Observacion, 1, 3999)
                 WHERE ID_PROCESO_MASIVO_DET = Lr_ServicioFox.ID_PROCESO_MASIVO_DET
                   AND ESTADO = Lv_Pendiente;

                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK;
                    Pv_Mensaje := 'Error al reprocesar el consumo del clearCache: Pv_SubscriberId: ' || Lv_SubscriberId ||
                                  'Pn_IdServicio: ' || Ln_IdServicio ||
                                   DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos-FoxPremium',
                                                         'CMKG_FOX_PREMIUM.P_JOB_CLEAR_CACHE_TOOLBOX',
                                                         Pv_Mensaje,
                                                         Lv_UsrCreacion,
                                                         SYSDATE,
                                                         Lv_IpCreacion);
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            Pv_Mensaje := 'Error al reprocesar el consumo del clearCache: ' ||
                           DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' :' || Pv_Mensaje;

            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos-FoxPremium',
                                                 'CMKG_FOX_PREMIUM.P_JOB_CLEAR_CACHE_TOOLBOX',
                                                 Pv_Mensaje,
                                                 Lv_UsrCreacion,
                                                 SYSDATE,
                                                 Lv_IpCreacion);
    END P_JOB_CLEAR_CACHE_TOOLBOX;

    FUNCTION F_GET_WS_CLEAR_CACHE (Pv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE DEFAULT 'CONFIGURACION_WS_CLEAR_CACHE')
    RETURN DB_COMERCIAL.CMKG_FOX_PREMIUM.Lr_ConsumoWebService
    IS
        Lr_Retorno          DB_COMERCIAL.CMKG_FOX_PREMIUM.Lr_ConsumoWebService;
        Lv_OracleWallet     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE := NULL;
        Ln_IndiceSeparador  NUMBER;
        Le_Exception        EXCEPTION;

        CURSOR C_GetConfiguracion (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                   Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE DEFAULT 'Activo')
        IS
            SELECT DET.VALOR1, DET.VALOR2, DET.VALOR3, DET.VALOR4, DET.VALOR5, DET.VALOR6, DET.VALOR7
              FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                   DB_GENERAL.ADMI_PARAMETRO_DET DET
             WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
               AND CAB.ESTADO = Cv_EstadoActivo
               AND CAB.ID_PARAMETRO = DET.PARAMETRO_ID
               AND DET.ESTADO = Cv_EstadoActivo;
    BEGIN

        --Se obtiene la configuraci�n de la URL para saber a qu� ambiente apuntar.
        OPEN  C_GetConfiguracion (Cv_NombreParametro => Pv_NombreParametro);
        FETCH C_GetConfiguracion INTO Lr_Retorno.REQUEST_URL,
                                      Lr_Retorno.HEADER_AUTHORIZATION,
                                      Lr_Retorno.REQUEST_METHOD,
                                      Lr_Retorno.KEY_STATUS_OK,
                                      Lr_Retorno.KEY_VALUE_OK,
                                      Lr_Retorno.KEYS_ERROR,
                                      Lv_OracleWallet;
        CLOSE C_GetConfiguracion;

        IF Lr_Retorno.REQUEST_URL IS NULL OR Lr_Retorno.REQUEST_METHOD IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene el directorio y clave para el OracleWallet
        IF Lv_OracleWallet IS NOT NULL THEN
            --Se obtiene el cuerpo del mensaje por respuesta OK
            Ln_IndiceSeparador             := INSTR (Lv_OracleWallet, '</separador>');
            Lr_Retorno.URL_FILE_DIGITAL    := SUBSTR(Lv_OracleWallet, 1, Ln_IndiceSeparador - 1);
            Lr_Retorno.PASSWD_FILE_DIGITAL := SUBSTR(Lv_OracleWallet, Ln_IndiceSeparador + 1);
        END IF;

        RETURN Lr_Retorno;
    EXCEPTION
        WHEN OTHERS THEN
            Lr_Retorno.REQUEST_URL := NULL;
            RETURN Lr_Retorno;
    END F_GET_WS_CLEAR_CACHE;

END CMKG_FOX_PREMIUM;
/