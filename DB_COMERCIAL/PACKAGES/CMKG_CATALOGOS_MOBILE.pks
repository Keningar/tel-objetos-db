CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CATALOGOS_MOBILE
AS
    /**
      * Documentación para el procedimiento P_GENERA_JSON_CATALOGOS
      *
      * Método que se encarga de generar el JSON de cada uno de los catálogos y cargalos en la tabla
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 07-08-2018
      *
      * @author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.1 16-16-2019 - Se modifica el procedimiento para que solo puedan enviar los productos que utiliza el TM-COMERCIAL
      *
      */
    PROCEDURE P_GENERA_JSON_CATALOGOS(Pv_Empresa     IN  VARCHAR2,
                                      Pv_Descripcion IN  VARCHAR2,
                                      Pv_Error       OUT VARCHAR2);

    /**
      * Función que se encarga de generar el JSON de catalogo de productos
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 07-08-2018
      *
      * @author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.1 16-10-2019 - Se modifica el procedimiento par aque solo se puedan enviar los productos
      *                           que se encuentren especificados en admi_parametros
      */
    FUNCTION F_GENERA_JSON_PRODUCTOS(Pv_Empresa     IN  VARCHAR2,
                                     Pv_Descripcion IN  VARCHAR2,
                                     Pv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de catalogo de puntos de cobertura
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 03-10-2018
      */
    FUNCTION F_GENERA_JSON_COBERTURA(Fv_Empresa     IN  VARCHAR2,
                                     Fv_Descripcion IN  VARCHAR2,
                                     Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los canales de venta
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 14-02-2019
      *
      * author Edgar Holguin <eholguin@telconet.ec>
      * @version 1.1 24-07-2019 Se unifican cursores por medio del uso de sentencia JOIN. Se agregan validaciones para obtener el json original.
      */
    FUNCTION F_GENERA_JSON_CANALES(Fv_Empresa     IN  VARCHAR2,
                                   Fv_Descripcion IN  VARCHAR2,
                                   Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los TIPO DE CUENTA/BANCOS
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 18-02-2019
      *
      * author Edgar Holguin <eholguin@telconet.ec>
      * @version 1.1 24-07-2019 Se unifican cursores por medio del uso de sentencia JOIN.Se agregan validaciones para obtener el json original.
      */
    FUNCTION F_GENERA_JSON_TIPO_CUENTA(Fv_Empresa     IN  VARCHAR2,
                                       Fv_Descripcion IN  VARCHAR2,
                                       Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los TIPO DE NEGOCIO
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 19-02-2019
      */
    FUNCTION F_GENERA_JSON_TIPO_NEGOCIO(Fv_Empresa     IN  VARCHAR2,
                                        Fv_Descripcion IN  VARCHAR2,
                                        Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los TIPO DE CONTRATO
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 19-02-2019
      */
    FUNCTION F_GENERA_JSON_TIPO_CONTRATO(Fv_Empresa     IN  VARCHAR2,
                                         Fv_Descripcion IN  VARCHAR2,
                                         Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los DOCUMENTOS OBLIGATORIOS
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 24-04-2019
      *
      * author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
      * @version 1.1 20-06-2020 Adición de consultas de documentos obligatorios para persona jurídica
      */
    FUNCTION F_GENERA_JSON_DOC_OBLIGATORIOS(Fv_Empresa     IN  VARCHAR2,
                                            Fv_Descripcion IN  VARCHAR2,
                                            Fv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de elemento por empresa y tipo.
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Holguin <eholguin@telconet.ec>
      * @version 1.0 19-07-2019
      *
      * Se agrega condicion para la empresa ecuanet obtenga edicios de mega
      * author Carlos Caguana <ccaguana@telconet.ec>
      * @version 1.1 10-03-2023
      */

    FUNCTION F_GENERA_JSON_ELEMENTOS (Fv_Empresa  IN  VARCHAR2)
    RETURN CLOB;

    /**
   * Documentacion para la funcion F_GET_VARCHAR_CLEAN
   * Funcion que limpia ciertos caracteres especiales de lña cadena enviada cono parámetro.
   * @param Fv_Cadena IN VARCHAR2   Recibe la cadena a limpiar
   * @return             VARCHAR2   Retorna cadena sin caracteres especiales
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 31-07-2019
   */
  FUNCTION F_GET_VARCHAR_CLEAN(
      Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2;

    /**
      * Función que se encarga de generar el JSON de catálogo de productos que se presentarán por empresa
      *
      * Costo Del Query C_Productos:       11
      * Costo Del Query C_Caracteristica:  25
      *
      * @author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 16-10-2019
      *
      * @author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
      * @version 1.1 05-04-2020 Implementación para obtener información de servicios adicionales parametrizados.
      *
      */
    FUNCTION F_GENERA_JSON_PRODUCTOS_DISP(Pv_Empresa     IN  VARCHAR2,
                                          Pv_Descripcion IN  VARCHAR2,
                                          Pv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de catalogo de productos que se presentaran por empresa
      *
      * @author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 16-10-2019
      */
    FUNCTION F_GENERA_JSON_PARAMETROS(Pv_Empresa     IN  VARCHAR2,
                                      Pv_Descripcion IN  VARCHAR2,
                                      Pv_Error       IN  VARCHAR2)
    RETURN CLOB;

    /**
      * Función que se encarga de generar el JSON de los tipos de promociones aplicables para planes y productos adicionales
      *
      * @author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
      * @version 1.0 26-11-2020
      */
    FUNCTION F_GENERA_JSON_PROMOCIONES(Pv_Empresa     IN  VARCHAR2,
                                       Pv_Descripcion IN  VARCHAR2,
                                       Pv_Error       IN  VARCHAR2)
    RETURN CLOB;
    
    /**
      * Función que se encarga de obtener los estados de los puntos
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_ESTADOS_PUNTO
    RETURN CLOB;
    
    /**
      * Función que se encarga de obtener la última milla
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_ULTIMA_MILLA
    RETURN CLOB;
    
    /**
      * Función que se encarga de obtener los estados del servicio
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_ESTADOS_SERVICIO
    RETURN CLOB;
    
    /**
      * Función que se encarga de obtener los estados del servicio
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_TIPO_SOLICITUD
    RETURN CLOB;

    /**
      * Función que se encarga de obtener los motivos hal
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Walther Joao Gaibor C. <wgaibor@telconet.ec>
      * @version 1.0 07-10-2021
      */
    FUNCTION F_GENERA_JSON_MOTIVO_HAL
    RETURN CLOB;

END CMKG_CATALOGOS_MOBILE;
/
