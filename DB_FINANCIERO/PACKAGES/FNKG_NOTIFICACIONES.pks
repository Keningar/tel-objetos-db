CREATE EDITIONABLE PACKAGE               FNKG_NOTIFICACIONES
AS
  --
  /**
  * Documentacion para el procedimiento P_NOTIFICAR_FACTURACION_MASIVA
  *
  * M�todo que env�a un correo notificando a los usuarios de la creaci�n de los documentos facturados.
  *
  * @param Pv_CuerpoMensaje    IN CLOB  Texto que ser� colocado como cuerpo del mensaje a notificar
  * @param Pv_CodigoPlantilla  IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla con la cual se va a enviar el correo
  * @param Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  C�digo de la empresa de la cual va a ser notificada
  * @param Pv_MensajeError     OUT VARCHAR2  Retorna un mensaje de error en caso de existir
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 10-02-2017
  */
  PROCEDURE P_NOTIFICAR_FACTURACION_MASIVA(
      Pv_CuerpoMensaje    IN CLOB,
      Pv_CodigoPlantilla  IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_MensajeError     OUT VARCHAR2);


  /**
   * Documentacion para el procedimiento P_NOTIF_PROCESO_MASIVO_DEBITOS
   *
   * M�todo que env�a un correo notificando a los usuarios de la finalizacion del proceso masivo de debitos pendientes.
   *
   * @param Pv_CuerpoMensaje   IN  CLOB Texto que ser� colocado como cuerpo del mensaje a notificar
   * @param Pv_CodigoPlantilla IN  DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE - C�digo de la plantilla con la cual se va a enviar el correo
   * @param Pv_From            IN  VARCHAR2 Recibe el usuario que envia el correo
   * @param Pv_Subject         IN  VARCHAR2 Recibe el subject del correo
   * @param Pv_Replace         IN  VARCHAR2 Recibe el valor a remplazar en la plantilla,
   * @param Pv_MimeType        IN  VARCHAR2 Recibe el charset en el que se envia el correo
   * @param Pv_MensajeError    OUT VARCHAR2 Retorna un mensaje de error en caso de existir
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 25-09-2017
   */
  PROCEDURE P_NOTIF_PROCESO_MASIVO_DEBITOS(
      Pv_CuerpoMensaje   IN  CLOB,
      Pv_CodigoPlantilla IN  DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
      Pv_From            IN  VARCHAR2,
      Pv_Subject         IN  VARCHAR2,
      Pv_Replace         IN  VARCHAR2,
      Pv_MimeType        IN  VARCHAR2,
      Pv_MensajeError    OUT VARCHAR2);


  /**
  * Documentacion para el procedimiento P_NOTIF_DOCUMENTOS_RECHAZADOS
  *
  * Procedimiento que env�a un correo notificando a los usuarios de los documentos rechazados existentes.
  * Costo del query 39
  *
  * @param Pv_PrejifoEmpresa             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Prefijo de la empresa de la cual se va a obtener 
  *                                                                                          los documentos
  * @param Pv_CodigoPlantilla            IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla con la cual se va a enviar el correo
  * @param Pv_DescripcionCaracteristica  IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE  Texto con la caracter�stica que se 
  *                                                                                                           desea buscar
  * @param Pv_MensajeError               OUT VARCHAR2  Retorna un mensaje de error en caso de existir
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.00 26-12-2016
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 18-01-2018  Se agrega filtro para que se consulte s�lo documentos que posean detalle.
  */
  PROCEDURE P_NOTIF_DOCUMENTOS_RECHAZADOS(
    Pv_PrejifoEmpresa            IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_DescripcionCaracteristica IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_MensajeError              OUT VARCHAR2);



  --
  /**
  * Documentacion para el procedimiento P_ENVIO_NOTIFICACION_DOCUMENTO
  *
  * M�todo que env�a un correo notificando a los usuarios de la creaci�n de documentos dependiendo de los par�metros enviados al procedure
  *
  * @param Pv_EmpresaId              IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Id de la empresa de la cual se va a obtener los documentos
  * @param Pv_NombreDocumento        IN DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE  Nombre de los documentos se van a notificar
  * @param Pv_CodigoPlantilla        IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla con la cual se va a enviar el correo
  * @param Pv_UsuarioCreacion        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE Usuario de creacion de los documentos
  * @param Pv_ConNumDocSri           IN VARCHAR2  Si se desea obtener documentos que tengan n�mero de SRI
  * @param Pv_Caracteristica         IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE  Texto con la caracter�stica que se desea 
  *                                                                                                       buscar
  * @param Pt_FechaAutorizacionDesde IN TIMESTAMP  Par�metro que indica desde que fecha se desea obtener los documentos 
  * @param Pt_FechaAutorizacionHasta IN TIMESTAMP  Par�metro que indica hasta que fecha se desea obtener los documentos 
  * @param Pv_MensajeError           OUT VARCHAR2  Retorna un mensaje de error en caso de existir
  *
  * COSTO QUERY: 29
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 21-12-2016
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 13-03-2018 - Se modifica para que en los parametros de Pt_FechaAutorizacionDesde y Pt_FechaAutorizacionHasta se consulte 
  * por FeEmision de la Factura y ya no por FeAutorizacion.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.2 07-10-2019 Se modifica tipo de dato para campos de fecha debido a que consulta se realiza con respecto a FE_EMISION del documento.
  */
  PROCEDURE P_ENVIO_NOTIFICACION_DOCUMENTO(
      Pv_EmpresaId              IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
      Pv_NombreDocumento        IN DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
      Pv_CodigoPlantilla        IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
      Pv_UsuarioCreacion        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pv_ConNumDocSri           IN VARCHAR2,
      Pv_Caracteristica         IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
      Pt_FechaAutorizacionDesde IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
      Pt_FechaAutorizacionHasta IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
      Pv_MensajeError           OUT VARCHAR2);
  --
  /**
  * Documentaci�n para PROCEDURE 'P_NOTIFICACION_PREFACTURAS'.
  *
  * Procedure que envia notificacion por correo de las Pre facturas que han sido eliminadas
  * a partir de 2 dias atras.
  *
  *
  * COSTO QUERY del Cursor C_GetCaracteristica: 2
  *                        C_GetPreFacturasEliminadas 43
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 20-11-2016
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 09-01-2016 Se adapta procedimiento para envio de facturas proporcionales, se renombra procedimiento.
  *                         Se modifica query para obtener descripci�n del documento, a partir del primer detalle.
  * PARAMETROS:
  * @param Pv_PrefijoEmpresa  IN   DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE Prefijo de la Empresa
  * @param Pt_FechaPeDesde    IN   TIMESTAMP  Se�ala desde que fecha se obtendran los documentos 
  * @param Pt_FechaPeHasta    IN   TIMESTAMP  Se�ala hasta que fecha se obtendran los documentos 
  * @param Pv_EstadoPrefac    IN   VARCHAR2   Indica el estado de las prefacturas.
  * @param Pv_CodigoPlantilla IN   DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE Codigo de la plantilla 
  * @param Pv_Caracteristica  IN   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE  Descripcion de la caracterisitica que se aspira buscar.  
  * @param Pv_MsnResult       OUT  VARCHAR2   (Mensaje)
  * @param Pv_MessageError    OUT  VARCHAR2    Mensaje de error en caso de existir. 
  * 
  */
  PROCEDURE P_NOTIFICACION_PREFACTURAS( 
    Pv_PrefijoEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pt_FechaPeDesde     IN  TIMESTAMP,
    Pt_FechaPeHasta     IN  TIMESTAMP,
    Pv_EstadoPrefac     IN  VARCHAR2,
    Pv_CodigoPlantilla  IN  DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_Caracteristica   IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_MsnResult        OUT VARCHAR2,
    Pv_MessageError     OUT VARCHAR2);
  --

  /**
  * Documentacion para el procedimiento P_NOTIF_PAGOS_DEPOSITABLES
  *
  * Procedimiento que env�a notificaci�n de pagos depositables no procesados.
  * Costo del query 39
  *
  * @param Pv_PrefijoEmpresa             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Prefijo de la empresa de la cual se va a obtener 
  *                                                                                          los documentos
  * @param Pv_CodigoPlantilla            IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla con la cual se va a enviar el correo
  * @param Pv_NombreParametroCab         IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE  Nombre de par�metro habilitado para env�o 
  *                                                                                              de noitificaci�n de pagos depositables.
  * @param Pv_EstadoDeposito             IN DB_FINANCIERO.INFO_DEPOSITO.ESTADO%TYPE  Estado del dep�sito.
  *
  * @param Pv_MensajeError               OUT VARCHAR2  Retorna un mensaje de error en caso de existir
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 02-02-2017
  */
  PROCEDURE P_NOTIF_PAGOS_DEPOSITABLES(
    Pv_PrefijoEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_NombreParametroCab        IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Pv_EstadoDeposito            IN  VARCHAR2,
    Pv_MensajeError              OUT VARCHAR2);

  /*
  * Documentaci�n para TYPE 'T_ClientesFacturar'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 15-08-2019
  */
  TYPE T_PtoNoFacturado IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_PtosNoFacturados INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para el procedimiento P_GET_PTOS_NOFACTURADOS
  *
  * Procedimiento que retorna cursor de puntos no facturados.
  *
  * Costo del query 94218
  *
  * @param Pv_PrejifoEmpresa             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Prefijo de la empresa.
  * @param Pr_ParamFechaDesde            IN IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE  Par�metro  para rango de fecha fin .
  * @param Pr_ParamFechaHasta            IN IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE  Par�metro  para rango de fecha de inicio .
  * @param Prf_PtosNoFacturados          OUT VARCHAR2  Retorna cursor de puntos no facturados.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 15-08-2019
  */

  PROCEDURE P_GET_PTOS_NOFACTURADOS(
    Pv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pr_ParamFechaDesde    IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Pr_ParamFechaHasta    IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Prf_PtosNoFacturados  OUT SYS_REFCURSOR);

  /**
  * Documentaci�n para el procedimiento P_NOTIF_PTOS_NOFACTURADOS
  *
  * Procedimiento que realiza env�o de notificaci�n de puntos no facturados.
  *
  * @param Pv_PrefijoEmpresa             IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE  Prefijo de la empresa.
  * @param Pv_CodigoPlantilla            IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla .
  * @param Pv_MensajeError               OUT VARCHAR2  Retorna un mensaje de error en caso de existir.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 15-08-2019
  */
  PROCEDURE P_NOTIF_PTOS_NOFACTURADOS(
    Pv_PrefijoEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_MensajeError              OUT VARCHAR2);

  /*
  * Documentaci�n para TYPE 'T_PtosFacturarInst'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 12-06-2020
  */
  TYPE T_PtosFacturarInst IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_PtosFacturarInst INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para el procedimiento P_GET_PTOS_NOFACTURADOS_INST
  *
  * Procedimiento que retorna cursor de puntos no facturados.
  *
  * Costo del query 96216
  *
  * @param Pv_CodEmpresa             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  C�digo de la empresa.
  * @param Prf_PtosNoFacturados      OUT VARCHAR2  Retorna cursor de puntos no facturados.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 15-08-2019
  */
  PROCEDURE P_GET_PTOS_NOFACTURADOS_INST(
    Pv_CodEmpresa         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Prf_PtosNoFacturados  OUT SYS_REFCURSOR);

  /**
  * Documentaci�n para el procedimiento P_RPT_PTOS_NOFACTURADOS_INST
  *
  * Procedimiento que realiza env�o de reporte de puntos a considerar en proceso de facturaci�n de instalaci�n.
  *
  * @param Pv_EmpresaCod             IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Codigo de la empresa.
  * @param Pv_CodigoPlantilla            IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla .
  * @param Pv_MensajeError               OUT VARCHAR2  Retorna un mensaje de error en caso de existir.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 12-06-2020
  */
  PROCEDURE P_RPT_PTOS_NOFACTURADOS_INST(
    Pv_EmpresaCod                IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_MensajeError              OUT VARCHAR2);

END FNKG_NOTIFICACIONES;
/

CREATE EDITIONABLE PACKAGE BODY               FNKG_NOTIFICACIONES
AS
  --
  PROCEDURE P_NOTIFICAR_FACTURACION_MASIVA(
      Pv_CuerpoMensaje    IN CLOB,
      Pv_CodigoPlantilla  IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
      Pv_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_MensajeError     OUT VARCHAR2)
  IS
    --
    Lc_GetAliasPlantilla           DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lr_GetAdmiParametrosDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_GetAdmiParametrosDet       SYS_REFCURSOR;
    Lcl_MessageMail                CLOB;
    Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE           := 'Activo';
    Lv_NombreCabeceraNotificacion  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'NOTIFICACIONES_FINANCIERAS';
    Lv_NombreCabeceraEnvioCorreo   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'ENVIO_CORREO';
    Lex_Exception                  EXCEPTION;
    --
  BEGIN
    --
    --Verifica que pueda enviar correo
    Lrf_GetAdmiParametrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreCabeceraEnvioCorreo, 
                                                                         Lv_EstadoActivo, 
                                                                         Lv_EstadoActivo, 
                                                                         Pv_CodigoPlantilla, 
                                                                         'SI', 
                                                                          NULL, 
                                                                          NULL);
    --
    FETCH
      Lrf_GetAdmiParametrosDet
    INTO
      Lr_GetAdmiParametrosDet;
    --
    CLOSE Lrf_GetAdmiParametrosDet;
    --
    --
    --VERIFICA SI ESTA ACTIVADO PARA ENVIAR CORREO
    IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
      --
      Lrf_GetAdmiParametrosDet := NULL;
      --
      Lr_GetAdmiParametrosDet := NULL;
      --
      --Obtiene los parametros para el envio de correo
      Lrf_GetAdmiParametrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreCabeceraEnvioCorreo, 
                                                                           Lv_EstadoActivo, 
                                                                           Lv_EstadoActivo,
                                                                           Pv_CodigoPlantilla || '_FROM_SUBJECT', 
                                                                           NULL, 
                                                                           NULL, 
                                                                           NULL );
      --
      FETCH
        Lrf_GetAdmiParametrosDet
      INTO
        Lr_GetAdmiParametrosDet;
      --
      CLOSE Lrf_GetAdmiParametrosDet;
      --
      --
      Lc_GetAliasPlantilla := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla);
      --
      --
      IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NOT NULL AND
        Lc_GetAliasPlantilla.PLANTILLA            IS NOT NULL AND
        Lr_GetAdmiParametrosDet.VALOR2            IS NOT NULL AND
        Lr_GetAdmiParametrosDet.VALOR3            IS NOT NULL AND
        Lc_GetAliasPlantilla.ALIAS_CORREOS        IS NOT NULL THEN
        --
        -- SE OBTIENE EL CUERPO QUE SERA ENVIADO EN EL CORREO
        Lcl_MessageMail := NULL;
        Lcl_MessageMail := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lc_GetAliasPlantilla.PLANTILLA,
                                                                      '{{ informacionFacs|raw }}', 
                                                                      Pv_CuerpoMensaje);
        --
        --Envia correo
        DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_GetAdmiParametrosDet.VALOR2, 
                                                Lc_GetAliasPlantilla.ALIAS_CORREOS,
                                                Lr_GetAdmiParametrosDet.VALOR3,
                                                SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                'text/html; charset=UTF-8',
                                                Pv_MensajeError);
        --
        --
        IF TRIM(Pv_MensajeError) IS NOT NULL THEN
          --
          Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
      END IF;--Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET ...
      --
    END IF; --Lrf_GetAdmiParamtrosDet
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_NOTIFICACIONES.P_NOTIFICAR_FACTURACION_MASIVA', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    Pv_MensajeError := 'Error en FNKG_NOTIFICACIONES.P_NOTIFICAR_FACTURACION_MASIVA - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                       || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_NOTIFICACIONES.P_NOTIFICAR_FACTURACION_MASIVA', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
    --
  END P_NOTIFICAR_FACTURACION_MASIVA;
  --
  --
  /*
    NOTIFICACION DE LOS PROCESOS MASIVOS DE DEBITOS PENDIENTES
  */
  PROCEDURE P_NOTIF_PROCESO_MASIVO_DEBITOS(Pv_CuerpoMensaje   IN  CLOB,
                                           Pv_CodigoPlantilla IN  DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
                                           Pv_From            IN  VARCHAR2,
                                           Pv_Subject         IN  VARCHAR2,
                                           Pv_Replace         IN  VARCHAR2,
                                           Pv_MimeType        IN  VARCHAR2,
                                           Pv_MensajeError    OUT VARCHAR2) IS

  Lc_GetAliasPlantilla  DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  Lcl_MessageMail       CLOB;
  Lex_Exception         EXCEPTION;

  BEGIN

    Lc_GetAliasPlantilla := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla);

    -- Se obtiene el cuerpo que sera enviado en el correo
    Lcl_MessageMail := NULL;
    Lcl_MessageMail := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lc_GetAliasPlantilla.PLANTILLA,
                                                                  Pv_Replace,
                                                                  Pv_CuerpoMensaje);

    --Envia correo
    DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Pv_From,
                                            Lc_GetAliasPlantilla.ALIAS_CORREOS,
                                            Pv_Subject,
                                            Lcl_MessageMail,
                                            Pv_MimeType,
                                            Pv_MensajeError);

    IF TRIM(Pv_MensajeError) IS NOT NULL THEN
      Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
      RAISE Lex_Exception;
    END IF;

  EXCEPTION

    WHEN Lex_Exception THEN

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNKG_NOTIFICACIONES.P_NOTIF_PROCESO_MASIVO_DEBITOS',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );

    WHEN OTHERS THEN

      Pv_MensajeError := 'Error en FNKG_NOTIFICACIONES.P_NOTIF_PROCESO_MASIVO_DEBITOS - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK
                       || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNKG_NOTIFICACIONES.P_NOTIF_PROCESO_MASIVO_DEBITOS',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );

  END P_NOTIF_PROCESO_MASIVO_DEBITOS;
  --
  --
  PROCEDURE P_NOTIF_DOCUMENTOS_RECHAZADOS(
    Pv_PrejifoEmpresa            IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_DescripcionCaracteristica IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_MensajeError              OUT VARCHAR2) IS

  CURSOR C_GetParametro(Cv_NombreParamCab VARCHAR2, Cv_EstadoParametroCab VARCHAR2, Cv_EstadoParametroDet VARCHAR2, Cv_Valor1 VARCHAR2, 
                        Cv_Valor2 VARCHAR2, Cv_Valor3 VARCHAR2, Cv_Valor4 VARCHAR2, Cv_Valor5 VARCHAR2, Cv_EmpresaCod VARCHAR2)
  IS
    SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
      DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
    AND APC.ESTADO           = NVL(Cv_EstadoParametroCab, APC.ESTADO)
    AND APD.ESTADO           = NVL(Cv_EstadoParametroDet, APD.ESTADO)
    AND APC.NOMBRE_PARAMETRO = NVL(Cv_NombreParamCab, APC.NOMBRE_PARAMETRO)
    AND APD.VALOR1           = NVL(Cv_Valor1, APD.VALOR1)
    AND APD.VALOR2           = NVL(Cv_Valor2, APD.VALOR2)
    AND APD.VALOR3           = NVL(Cv_Valor3, APD.VALOR3)
    AND APD.VALOR4           = NVL(Cv_Valor4, APD.VALOR4)
    AND APD.VALOR5           = NVL(Cv_Valor5, APD.VALOR5)
    AND APD.EMPRESA_COD      = NVL(Cv_EmpresaCod, APD.EMPRESA_COD);

  CURSOR C_GetCaracteristica(Cv_EstadoActivo DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE, 
                             Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  IS
    SELECT AC.ID_CARACTERISTICA                                   
    FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
    WHERE AC.ESTADO                   = Cv_EstadoActivo
    AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica;

  Lr_GetAdmiParametrosDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lrf_GetAdmiParametrosDet       SYS_REFCURSOR;
  Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                        := 'Activo';
  Lv_NombreParametroCab          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'NOTIFICACION_DOCUMENTOS_RECHAZADOS';
  Lv_PrefijoEmpresa              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE                        := Pv_PrejifoEmpresa;
  Lr_Parametro                   C_GetParametro%ROWTYPE;
  Lv_ParamEstadosDocumentos      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'ESTADO_DOCUMENTO_RECHAZADO';
  Lv_TiposDocumentosRechazados   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'TIPOS_DOCUMENTOS_RECHAZADOS';
  Lv_ValidacionFechas            DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'VALIDACION_FECHAS_NOTIFICACION';
  Lv_FechaDesde                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := 'VALIDACION_FECHA_DESDE';
  Lv_FechaHasta                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := 'VALIDACION_FECHA_HASTA';
  Lv_ValorActivo                 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                        := 'S';
  Lv_DescipcionCaracteristica    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := Pv_DescripcionCaracteristica;
  Lcl_Query                      CLOB                                                             := '';
  Lrf_GetDocumentosRechazados    SYS_REFCURSOR;
  Lr_DocumentosRechazados        DB_FINANCIERO.FNKG_TYPES.Lr_DocumentosRechazados;
  Lr_GetAliasPlantilla           DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  Lcl_TableDocumento             CLOB;
  Lv_CodigoPlantilla             DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE                       := Pv_CodigoPlantilla;
  Lv_Datosmail                   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := Lv_CodigoPlantilla || '_HEADERS';
  Lv_NombreCabeceraEnviocorreo   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := Lv_CodigoPlantilla || '_HEADERS';
  Lr_GetCaracteristica           C_GetCaracteristica%ROWTYPE;
  Lr_InfoDocumentoFinancieroHis  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
  Lr_InfoDocumentoCaracteristica DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
  Le_Exception                  EXCEPTION;
  Lv_ObservacionHistorialDoc     DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE;
  Lv_UsuarioHistorial            DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE;
  Ln_CounterCommit               NUMBER                                                           := 0;
  Lcl_MessageMail                CLOB;
  Lv_MimeType                    VARCHAR2(50)                                                     := 'text/html; charset=UTF-8';
  BEGIN

     --Verifica que pueda enviar correo para los documentos rechazados
    Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreParametroCab, 
                                                                                       Lv_EstadoActivo, 
                                                                                       Lv_EstadoActivo, 
                                                                                       Lv_NombreParametroCab, 
                                                                                       Lv_PrefijoEmpresa, 
                                                                                       Lv_ValorActivo, 
                                                                                       NULL);

    FETCH
      Lrf_GetAdmiParametrosDet
    INTO
      Lr_GetAdmiParametrosDet;
    CLOSE Lrf_GetAdmiParametrosDet;

    IF Lr_GetAdmiParametrosDet.parametro_id IS NOT NULL THEN
      Lv_UsuarioHistorial        := Lr_GetAdmiParametrosDet.valor4;
      Lv_ObservacionHistorialDoc := Lr_GetAdmiParametrosDet.valor5;

      Lcl_Query :='WITH estados_rechazados AS
                     (SELECT b.valor2
                     FROM DB_GENERAL.admi_parametro_cab a
                     JOIN DB_GENERAL.admi_parametro_det b
                     ON (a.id_parametro       = b.parametro_id)
                     WHERE a.nombre_parametro = '''||Lv_ParamEstadosDocumentos||'''
                     AND b.valor1             = '''||Lv_ParamEstadosDocumentos||'''
                     AND empresa_cod          = '''||Lr_GetAdmiParametrosDet.Empresa_Cod||'''
                     AND a.estado             = '''||Lv_EstadoActivo||'''
                     AND b.estado             = '''||Lv_EstadoActivo||'''
                     ),
                     tipos_documentos_rechazados AS
                     (SELECT b.valor2
                     FROM DB_GENERAL.admi_parametro_cab a
                     JOIN DB_GENERAL.admi_parametro_det b
                     ON (a.id_parametro       = b.parametro_id)
                     WHERE a.nombre_parametro = '''||Lv_TiposDocumentosRechazados||'''
                     AND b.valor1             = '''||Lv_TiposDocumentosRechazados||'''
                     AND empresa_cod          = '''||Lr_GetAdmiParametrosDet.Empresa_Cod||'''
                     AND a.estado             = '''||Lv_EstadoActivo||'''
                     AND b.estado             = '''||Lv_EstadoActivo||'''
                     )
                   SELECT TO_CHAR(IDFC.FE_CREACION,''dd/mm/yyyy hh24:mi:ss'') AS FECHA_CREACION,
                     TO_CHAR(IDFC.FE_EMISION,''dd/mm/yyyy hh24:mi:ss'')       AS FECHA_EMISION,
                     ATDF.CODIGO_TIPO_DOCUMENTO,
                     ATDF.NOMBRE_TIPO_DOCUMENTO,
                     IDFC.ID_DOCUMENTO,
                     IDFC.NUMERO_FACTURA_SRI,
                     IOG.NOMBRE_OFICINA,
                     DBMS_XMLGEN.CONVERT( DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_VARCHAR_VALID_XML_VALUE(DFD.OBSERVACIONES_FACTURA_DETALLE) ) '
                     ||'OBSERVACION,
                     CASE
                       WHEN TRIM(IPE.RAZON_SOCIAL) IS NOT NULL
                       THEN DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(TRIM(IPE.RAZON_SOCIAL))
                       ELSE DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(CONCAT(TRIM(IPE.NOMBRES), CONCAT('' '', 
                                                                                                                          TRIM(IPE.APELLIDOS)))) '
                     ||'END CLIENTE,
                     IP.LOGIN as PUNTO_CLIENTE,
                     DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(CONCAT(TRIM(IPEV.NOMBRES), CONCAT('' '', TRIM(IPEV.APELLIDOS)))) ' 
                     ||'VENDEDOR,
                     IP.USR_VENDEDOR,
                     IDFC.SUBTOTAL SUB_TOTAL,
                     IDFC.SUBTOTAL_CON_IMPUESTO SUB_TOTAL_CON_IMPUESTO ,
                     IDFC.SUBTOTAL_DESCUENTO SUB_TOTAL_DESCUENTO,
                     IDFC.VALOR_TOTAL VALOR_TOTAL,
                     DBMS_XMLGEN.CONVERT( DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_VARCHAR_VALID_XML_VALUE(MCE.INFORMACION_ADICIONAL)) ' 
                     ||'MOTIVO_RECHAZO,
                     IDFC.ESTADO_IMPRESION_FACT as ESTADO_DOCUMENTO
                   FROM DB_COMERCIAL.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                   JOIN DB_COMERCIAL.INFO_DOCUMENTO_FINANCIERO_DET IDFD
                   ON (IDFC.ID_DOCUMENTO = IDFD.DOCUMENTO_ID)
                   INNER JOIN DB_COMERCIAL.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                   ON (IDFC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO)
                   INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
                   ON (IDFC.OFICINA_ID = IOG.ID_OFICINA)
                   INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
                   ON (IOG.EMPRESA_ID = IEG.COD_EMPRESA)
                   INNER JOIN DB_COMERCIAL.INFO_PUNTO IP
                   ON (IP.ID_PUNTO = IDFC.PUNTO_ID)
                   INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                   ON (IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL)
                   INNER JOIN DB_COMERCIAL.INFO_PERSONA IPE
                   ON (IPER.PERSONA_ID = IPE.ID_PERSONA)
                   INNER JOIN DB_COMERCIAL.INFO_PERSONA IPEV
                   ON (IP.USR_VENDEDOR = IPEV.LOGIN)
                   LEFT OUTER JOIN
                     (SELECT *
                     FROM
                       (SELECT IDFD.*,
                         ROW_NUMBER() OVER (PARTITION BY DOCUMENTO_ID ORDER BY PRECIO_VENTA_FACPRO_DETALLE DESC) RN
                       FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
                       )
                     WHERE RN = 1
                     ) DFD
                   ON DFD.DOCUMENTO_ID = idfc.ID_DOCUMENTO
                   LEFT OUTER JOIN
                     (SELECT *
                     FROM
                       (SELECT IMCE.*,
                         ROW_NUMBER() OVER (PARTITION BY DOCUMENTO_ID ORDER BY ID_MSN_COMP_ELEC DESC) RN
                       FROM DB_FINANCIERO.INFO_MENSAJE_COMP_ELEC IMCE
                       )
                     WHERE RN = 1
                     ) MCE
                   ON MCE.DOCUMENTO_ID               = IDFC.ID_DOCUMENTO
                   WHERE IDFC.ESTADO_IMPRESION_FACT IN
                     ( SELECT * FROM estados_rechazados
                     )
                   AND IEG.PREFIJO                 ='''||Lv_PrefijoEmpresa||'''
                   AND IDFD.DOCUMENTO_ID IS NOT NULL
                   AND ATDF.CODIGO_TIPO_DOCUMENTO IN
                     (SELECT * FROM tipos_documentos_rechazados
                     )
                   AND NOT EXISTS
                     (SELECT CARACTERISTICA_ID
                     FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA
                     WHERE ID_DOCUMENTO_CARACTERISTICA =
                       (SELECT MAX(IDC_S.ID_DOCUMENTO_CARACTERISTICA)
                       FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_S
                       JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
                       ON AC.ID_CARACTERISTICA           = IDC_S.CARACTERISTICA_ID
                       WHERE IDC_S.DOCUMENTO_ID          = IDFC.ID_DOCUMENTO
                       AND AC.ESTADO                     = '''||Lv_EstadoActivo||'''
                       AND AC.DESCRIPCION_CARACTERISTICA = '''||Lv_DescipcionCaracteristica||'''
                       AND IDC_S.ESTADO                  = '''||Lv_EstadoActivo||'''
                       AND IDC_S.VALOR                   = '''||Lv_ValorActivo||'''
                       )
                     )';

      --Se valida si esta activo el filtro por fecha desde
      Lr_Parametro :=null;
      OPEN C_GetParametro(Lv_ValidacionFechas, Lv_EstadoActivo, Lv_EstadoActivo, Lv_FechaDesde, Lv_ValorActivo, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);

      FETCH C_GetParametro INTO Lr_Parametro;
      CLOSE C_GetParametro;
      IF Lr_Parametro.valor1 IS NOT NULL THEN
        Lcl_Query := Lcl_Query ||'  AND idfc.fe_emision >= (SYSDATE - NUMTODSINTERVAL('||Lr_Parametro.valor3||','''||Lr_Parametro.valor4||'''))';
      END IF;

      --Se valida si esta activo el filtro por fecha hasta
      Lr_Parametro :=NULL;
      OPEN C_GetParametro(Lv_ValidacionFechas, Lv_EstadoActivo, Lv_EstadoActivo, Lv_FechaHasta, Lv_ValorActivo, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);

      FETCH C_GetParametro INTO Lr_Parametro;
      CLOSE C_GetParametro;
      IF Lr_Parametro.valor1 IS NOT NULL THEN
        Lcl_Query := Lcl_Query ||'  AND idfc.fe_emision <= (SYSDATE - NUMTODSINTERVAL('||Lr_Parametro.valor3||','''||Lr_Parametro.valor4||'''))';
      END IF;

      --Se obtiene los parametros para enviar el correo
      OPEN C_GetParametro(Lv_NombreCabeceraEnvioCorreo, Lv_EstadoActivo, Lv_EstadoActivo, Lv_DatosMail, NULL, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);

      FETCH C_GetParametro INTO Lr_Parametro;
      CLOSE C_GetParametro;

      --Se obtiene el alias y la plantilla donde se enviara la notificacion   
      Lr_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_CodigoPlantilla);

      -- SE CONSULTA QUE EXISTA LA CARACTERISTICA DE LA NOTIFICACION A REALIZAR
      IF C_GetCaracteristica%ISOPEN THEN

        CLOSE C_GetCaracteristica;

      END IF;

      OPEN C_GetCaracteristica( Lv_EstadoActivo, Lv_DescipcionCaracteristica );

      FETCH C_GetCaracteristica INTO Lr_GetCaracteristica;

      CLOSE C_GetCaracteristica;

      --Si no esta configurado la plantilla con alias y el parametro con los datos del remitente y asunto
      --no se enviara la notificacion
      IF Lr_Parametro.ID_PARAMETRO_DET     IS NOT NULL AND
        Lr_GetAliasPlantilla.PLANTILLA     IS NOT NULL AND
        Lr_Parametro.VALOR2                IS NOT NULL AND
        Lr_Parametro.VALOR3                IS NOT NULL AND
        Lr_GetAliasPlantilla.ALIAS_CORREOS IS NOT NULL THEN

        DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);

        --Se obtiene los documentos que se encuentran rechazados y se los procesa
        IF Lrf_GetDocumentosRechazados%ISOPEN THEN
          CLOSE Lrf_GetDocumentosRechazados;
        END IF;

        OPEN Lrf_GetDocumentosRechazados FOR Lcl_Query;

        LOOP

          FETCH Lrf_GetDocumentosRechazados INTO Lr_DocumentosRechazados;
          EXIT WHEN Lrf_GetDocumentosRechazados%NOTFOUND;

          --Concatena las fila del documento a notificar.
          DBMS_LOB.APPEND(Lcl_TableDocumento, '<tr><td> ' ||
                         Lr_DocumentosRechazados.FECHA_CREACION || ' </td><td> ' ||
                         Lr_DocumentosRechazados.FECHA_EMISION || ' </td><td> ' ||
                         Lr_DocumentosRechazados.NOMBRE_OFICINA || ' </td><td> ' ||
                         Lr_DocumentosRechazados.CODIGO_TIPO_DOCUMENTO || ' </td><td> ' ||
                         Lr_DocumentosRechazados.NUMERO_FACTURA_SRI || ' </td><td> ' ||
                         Lr_DocumentosRechazados.OBSERVACION || ' </td><td> ' ||
                         Lr_DocumentosRechazados.CLIENTE || ' </td><td> ' ||
                         Lr_DocumentosRechazados.PUNTO_CLIENTE || ' </td><td> ' ||
                         Lr_DocumentosRechazados.VENDEDOR || ' </td><td> ' ||
                         Lr_DocumentosRechazados.SUB_TOTAL || ' </td><td> ' ||
                         Lr_DocumentosRechazados.SUB_TOTAL_CON_IMPUESTO || ' </td><td> ' ||
                         Lr_DocumentosRechazados.SUB_TOTAL_DESCUENTO || ' </td><td> ' ||
                         Lr_DocumentosRechazados.VALOR_TOTAL || ' </td><td> ' ||
                         Lr_DocumentosRechazados.MOTIVO_RECHAZO || ' </td></tr>');

          -- SE INSERTA LA CARACTERISTICA DEL DOCUMENTO NOTIFICADO
          IF Lr_GetCaracteristica.ID_CARACTERISTICA IS NOT NULL AND Lr_GetCaracteristica.ID_CARACTERISTICA > 0 THEN

            Pv_MensajeError                                            := NULL;
            Lr_InfoDocumentoCaracteristica                             := NULL;
            Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Lr_DocumentosRechazados.ID_DOCUMENTO;
            Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Lr_GetCaracteristica.ID_CARACTERISTICA;
            Lr_InfoDocumentoCaracteristica.VALOR                       := Lv_ValorActivo;
            Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
            Lr_InfoDocumentoCaracteristica.USR_CREACION                := Lv_UsuarioHistorial;
            Lr_InfoDocumentoCaracteristica.IP_CREACION                 := NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1');
            Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;

            DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT( Lr_InfoDocumentoCaracteristica, Pv_MensajeError );


            IF TRIM(Pv_MensajeError) IS NOT NULL THEN

              Pv_MensajeError := 'Hubo un error al guardar la caracteristica del documento ' || Lr_DocumentosRechazados.ID_DOCUMENTO || ' - ' 
                                 || Pv_MensajeError;

              RAISE Le_Exception;

            END IF;


            --SE INSERTA EL HISTORIAL DEL DOCUMENTO NOTIFICADO
            Pv_MensajeError                                      := NULL;
            Lr_InfoDocumentoFinancieroHis                        := NULL;
            Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
            Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID           := Lr_DocumentosRechazados.ID_DOCUMENTO;
            lr_infodocumentofinancierohis.FE_CREACION            := SYSDATE;
            Lr_InfoDocumentoFinancieroHis.USR_CREACION           := Lv_UsuarioHistorial;
            Lr_InfoDocumentoFinancieroHis.ESTADO                 := Lr_DocumentosRechazados.ESTADO_DOCUMENTO;
            Lr_InfoDocumentoFinancieroHis.OBSERVACION            := Lv_ObservacionHistorialDoc;

            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis, Pv_MensajeError);

            IF TRIM(Pv_MensajeError) IS NOT NULL THEN

              Pv_MensajeError := 'Hubo un error al guardar el historial del documento ' || Lr_DocumentosRechazados.ID_DOCUMENTO || ' - ' 
                                 || Pv_MensajeError;
              RAISE Le_Exception;

            END IF;

            Ln_CounterCommit := Ln_CounterCommit + 1;

            IF Ln_CounterCommit >= 50 THEN

              Ln_CounterCommit := 0;
              Lcl_MessageMail  := NULL;
              Lcl_MessageMail  := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA, 
                                                                            '{{ plRechazados | raw }}', 
                                                                            Lcl_TableDocumento);
              --Envia correo
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR2, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lr_Parametro.VALOR3,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);


              IF TRIM(Pv_MensajeError) IS NOT NULL THEN

                Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;          
                RAISE Le_Exception;

              END IF;

              DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
              Lcl_TableDocumento := '';
              DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);
              COMMIT;

            END IF;

          ELSE

            Pv_MensajeError := 'No se encontr� la caracter�stica en la tabla DB_COMERCIAL.ADMI_CARACTERISTICA en estado Activo';
            RAISE Le_Exception;

          END IF;
        END LOOP;
        CLOSE Lrf_GetDocumentosRechazados;

        --En caso de que el contador no haya llegado a 50 se envia los documentos obtenidos hasta el momento
        IF Ln_CounterCommit < 50 AND Ln_CounterCommit > 0 THEN

          Lcl_MessageMail := NULL;
          Lcl_MessageMail := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA,
                                                                        '{{ plRechazados | raw }}', 
                                                                        Lcl_TableDocumento);   
          --Envia correo
          DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR2, 
                                                  Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                  Lr_Parametro.VALOR3,
                                                  SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                  Lv_MimeType,
                                                  Pv_MensajeError);

          IF TRIM(Pv_MensajeError) IS NOT NULL THEN
            Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
            RAISE Le_Exception;
          END IF;

          DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
          Lcl_TableDocumento := '';
          COMMIT;
        END IF;

      END IF;

    END IF;

  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_NOTIF_DOCUMENTOS_RECHAZADOS', 
                                            Pv_MensajeError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );

    WHEN OTHERS THEN
      ROLLBACK;
      Pv_MensajeError := 'Error en FNCK_NOTIFICACIONES.P_NOTIF_DOCUMENTOS_RECHAZADOS - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_NOTIF_DOCUMENTOS_RECHAZADOS', 
                                            Pv_MensajeError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_NOTIF_DOCUMENTOS_RECHAZADOS;

  PROCEDURE P_ENVIO_NOTIFICACION_DOCUMENTO(
      Pv_EmpresaId              IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
      Pv_NombreDocumento        IN DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
      Pv_CodigoPlantilla        IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
      Pv_UsuarioCreacion        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pv_ConNumDocSri           IN VARCHAR2,
      Pv_Caracteristica         IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
      Pt_FechaAutorizacionDesde IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
      Pt_FechaAutorizacionHasta IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
      Pv_MensajeError           OUT VARCHAR2)
  IS
    --
    CURSOR C_GetCaracteristica(Cv_EstadoActivo DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE, 
                               Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      --
      SELECT AC.ID_CARACTERISTICA                                   
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE AC.ESTADO                   = Cv_EstadoActivo
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica;
    --
    Lc_GetAliasPlantilla           DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lr_GetAdmiParametrosDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_GetAdmiParametrosDet       SYS_REFCURSOR;
    Lcl_MessageMail                CLOB;
    Lcl_TableDocumento             CLOB;
    Ln_CounterCommit               NUMBER                                                  := 0;
    Lcl_Query                      CLOB                                                    := '';
    Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE               := 'Activo';
    Lv_NombreCabeceraNotificacion  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE     := 'NOTIFICACIONES_FINANCIERAS';
    Lv_NombreCabeceraEnvioCorreo   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE     := 'ENVIO_CORREO';
    Lcl_ObservacionHistorialDoc    DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE := 'La factura ha sido notificada al usuario';
    Lc_GetDocumentosFinancieros    SYS_REFCURSOR;
    Lr_GetNotificacionDocumento    DB_FINANCIERO.FNKG_TYPES.Lr_NotificacionDocumentos;
    Lr_InfoDocumentoFinancieroHis  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Lr_InfoDocumentoCaracteristica DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
    Lex_Exception                  EXCEPTION;
    Lr_GetCaracteristica           C_GetCaracteristica%ROWTYPE;
    --
  BEGIN
    --
    -- ESTRUCTURA INICIAL DEL QUERY DONDE SE OBTIENE LA INFORMACION QUE SER� RETORNADA POR LA CONSULTA
    Lcl_Query := 'SELECT                 
                    DFC.ID_DOCUMENTO,                 
                    TDF.CODIGO_TIPO_DOCUMENTO CODIGO_TIPO_DOCUMENTO,                 
                    SUBSTR (DFC.FE_CREACION, 1, 10) FE_CREACION,                 
                    DFC.SUBTOTAL SUB_TOTAL,                 
                    DFC.SUBTOTAL_CON_IMPUESTO SUB_TOTAL_CON_IMPUESTO ,                 
                    DFC.SUBTOTAL_DESCUENTO SUB_TOTAL_DESCUENTO,                 
                    DFC.VALOR_TOTAL VALOR_TOTAL,                 
                    PO.DESCRIPCION_PUNTO DESCRIPCION_PUNTO,                 
                    PO.LOGIN LOGIN,                 
                    CASE                   
                      WHEN TRIM(PE.RAZON_SOCIAL) IS NOT NULL THEN                     
                        DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(TRIM(PE.RAZON_SOCIAL))
                      ELSE
                        DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(CONCAT(TRIM(PE.NOMBRES), CONCAT('' '', TRIM(PE.APELLIDOS))))
                    END CLIENTE,                 
                    OG.NOMBRE_OFICINA NOMBRE_OFICINA,                 
                    DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(CONCAT(TRIM(PV.NOMBRES), CONCAT('' '', TRIM(PV.APELLIDOS)))) '
                    || 'VENDEDOR, '
                    || 'DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DFD.OBSERVACIONES_FACTURA_DETALLE) OBSERVACION,                 
                    DFC.NUMERO_FACTURA_SRI NUMERO_DOCUMENTO,                 
                    DFC.ESTADO_IMPRESION_FACT ESTADO_DOCUMENTO               
                FROM                 
                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB DFC               
                LEFT OUTER JOIN
                (
                    SELECT *
                    FROM                     
                    (                       
                        SELECT IDFD.*,                         
                               ROW_NUMBER() OVER (PARTITION BY DOCUMENTO_ID ORDER BY                         
                               PRECIO_VENTA_FACPRO_DETALLE DESC) RN                       
                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD                     
                    )                   
                    WHERE RN = 1                 
                ) DFD               
                ON                 
                DFD.DOCUMENTO_ID = DFC.ID_DOCUMENTO               
                INNER JOIN DB_COMERCIAL.INFO_PUNTO PO               
                ON                 
                PO.ID_PUNTO = DFC.PUNTO_ID               
                INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER               
                ON                 
                PER.ID_PERSONA_ROL = PO.PERSONA_EMPRESA_ROL_ID               
                INNER JOIN DB_COMERCIAL.INFO_PERSONA PE               
                ON                 
                PE.ID_PERSONA = PER.PERSONA_ID               
                INNER JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDF               
                ON                 
                TDF.ID_TIPO_DOCUMENTO = DFC.TIPO_DOCUMENTO_ID               
                INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OG               
                ON                 
                OG.ID_OFICINA = DFC.OFICINA_ID               
                INNER JOIN DB_COMERCIAL.INFO_PERSONA PV               
                ON                 
                PV.LOGIN = PO.USR_VENDEDOR               
                WHERE DFC.ESTADO_IMPRESION_FACT IN (                 
                SELECT APD.VALOR1                 
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC                 
                JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD                 
                ON                   
                APC.ID_PARAMETRO = APD.PARAMETRO_ID                 
                WHERE APC.ESTADO             = ''' || Lv_EstadoActivo || '''                 
                AND APD.ESTADO               = ''' || Lv_EstadoActivo || '''                 
                AND APC.NOMBRE_PARAMETRO     = ''' || Lv_NombreCabeceraNotificacion || '''                 
                AND APD.DESCRIPCION          = ''ESTADOS_' || Pv_NombreDocumento || '''               
                )               
                AND TDF.CODIGO_TIPO_DOCUMENTO IN (
                SELECT APD.VALOR1                 
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD                 
                ON                   
                APC.ID_PARAMETRO = APD.PARAMETRO_ID                 
                WHERE APC.ESTADO             = ''' || Lv_EstadoActivo || '''
                AND APD.ESTADO               = ''' || Lv_EstadoActivo || '''
                AND APC.NOMBRE_PARAMETRO     = ''' || Lv_NombreCabeceraNotificacion || '''
                AND APD.DESCRIPCION          = ''' || Pv_NombreDocumento || '''
                )               
                AND OG.EMPRESA_ID            = ''' || Pv_EmpresaId || ''' ';
    --
    --
    -- SI LA VARIABLE 'Pv_ConNumDocSri' VIENE CON VALOR 'S' QUIERE DECIR QUE SE CONSULTARAN DOCUMENTOS QUE CONTENGAN NUMERO DE SRI
    IF TRIM(Pv_ConNumDocSri) IS NOT NULL THEN
      --
      IF TRIM(Pv_ConNumDocSri) = 'S' THEN
        --
        Lcl_Query := Lcl_Query || ' AND DFC.NUMERO_FACTURA_SRI IS NOT NULL ';
        --
      ELSE
        --
        Lcl_Query := Lcl_Query || ' AND DFC.NUMERO_FACTURA_SRI IS NULL ';
        --
      END IF;
      --
    ELSE
      --
      Lcl_Query := Lcl_Query || ' AND DFC.NUMERO_FACTURA_SRI IS NULL ';
      --
    END IF;-- TRIM(Pv_ConNumDocSri) IS NOT NULL
    --
    --
    -- SI LA VARIABLE 'Pt_FechaAutorizacionDesde' NO ES NULA SE CONSULTA POR UNA FECHA INICIAL DE EMISION DE LOS DOCUMENTOS ELECTRONICOS
    IF TRIM(Pt_FechaAutorizacionDesde) IS NOT NULL THEN
      --
      Lcl_Query := Lcl_Query || ' AND DFC.FE_EMISION >= ''' || Pt_FechaAutorizacionDesde || ''' ';
      --
    END IF;--TRIM(Pt_FechaAutorizacionDesde) IS NOT NULL
    --
    --
    -- SI LA VARIABLE 'Pt_FechaAutorizacionHasta' NO ES NULA SE CONSULTA HASTA UNA FECHA FINAL DE EMISION DE LOS DOCUMENTOS ELECTRONICOS
    IF TRIM(Pt_FechaAutorizacionHasta) IS NOT NULL THEN
      --
      Lcl_Query := Lcl_Query || ' AND DFC.FE_EMISION < '''||Pt_FechaAutorizacionHasta||''' ';
      --
    END IF;--TRIM(Pt_FechaAutorizacionHasta) IS NOT NULL
    --
    --
    -- SI LA VARIABLE 'Pv_UsuarioCreacion' NO ES NULA SE CONSULTA POR USUARIO DE CREACION DE LOS DOCUMENTOS
    IF TRIM(Pv_UsuarioCreacion) IS NOT NULL THEN
      --
      Lcl_Query := Lcl_Query || ' AND DFC.USR_CREACION = ''' || Pv_UsuarioCreacion || ''' ';
      --
    END IF;--TRIM(Pv_UsuarioCreacion) IS NOT NULL
    --
    --
    -- SI LA VARIABLE 'Pv_Caracteristica' NO ES NULA SE CONSULTA SI LOS DOCUMENTOS TIENEN ASOCIADO LA CARACTERISTICA ENVIADA COMO PARAMETRO
    IF TRIM(Pv_Caracteristica) IS NOT NULL THEN
      --
      Lcl_Query := Lcl_Query || ' AND NOT EXISTS                                
                                  (                                  
                                    SELECT NULL                                  
                                    FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA                                  
                                    WHERE ID_DOCUMENTO_CARACTERISTICA =                                    
                                    (                                      
                                        SELECT MAX(IDC_S.ID_DOCUMENTO_CARACTERISTICA)                                      
                                        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_S
                                        JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
                                        ON AC.ID_CARACTERISTICA = IDC_S.CARACTERISTICA_ID
                                        WHERE IDC_S.DOCUMENTO_ID          = DFC.ID_DOCUMENTO 
                                        AND AC.ESTADO                     = ''' || Lv_EstadoActivo || '''
                                        AND AC.DESCRIPCION_CARACTERISTICA = ''' || Pv_Caracteristica || '''
                                        AND IDC_S.ESTADO                  = ''' || Lv_EstadoActivo || '''
                                        AND IDC_S.VALOR                   = ''S''
                                    )                                
                                  ) ';
      --
    END IF;--TRIM(Pv_Caracteristica) IS NOT NULL
    --
    --
    --Verifica que pueda enviar correo
    Lrf_GetAdmiParametrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreCabeceraEnvioCorreo, 
                                                                         Lv_EstadoActivo, 
                                                                         Lv_EstadoActivo, 
                                                                         Pv_CodigoPlantilla, 
                                                                         'SI', 
                                                                          NULL, 
                                                                          NULL);
    --
    FETCH
      Lrf_GetAdmiParametrosDet
    INTO
      Lr_GetAdmiParametrosDet;
    --
    CLOSE Lrf_GetAdmiParametrosDet;
    --
    --
    --VERIFICA SI ESTA ACTIVADO PARA ENVIAR CORREO
    IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
      --
      Lrf_GetAdmiParametrosDet := NULL;
      --
      Lr_GetAdmiParametrosDet := NULL;
      --
      --Obtiene los parametros para el envio de correo
      Lrf_GetAdmiParametrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreCabeceraEnvioCorreo, 
                                                                           Lv_EstadoActivo, 
                                                                           Lv_EstadoActivo,
                                                                           Pv_CodigoPlantilla || '_FROM_SUBJECT', 
                                                                           NULL, 
                                                                           NULL, 
                                                                           NULL );
      --
      FETCH
        Lrf_GetAdmiParametrosDet
      INTO
        Lr_GetAdmiParametrosDet;
      --
      CLOSE Lrf_GetAdmiParametrosDet;
      --
      --
      Lc_GetAliasPlantilla := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla);
      --
      --
      IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NOT NULL AND
        Lc_GetAliasPlantilla.PLANTILLA            IS NOT NULL AND
        Lr_GetAdmiParametrosDet.VALOR2            IS NOT NULL AND
        Lr_GetAdmiParametrosDet.VALOR3            IS NOT NULL AND
        Lc_GetAliasPlantilla.ALIAS_CORREOS        IS NOT NULL THEN
        --
        --
        DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);
        --
        --
        -- SE CONSULTA QUE EXISTA LA CARACTERISTICA DE LA NOTIFICACION A REALIZAR
        IF C_GetCaracteristica%ISOPEN THEN
          --
          CLOSE C_GetCaracteristica;
          --
        END IF;
        --
        OPEN C_GetCaracteristica( Lv_EstadoActivo, Pv_Caracteristica );
        --
        FETCH C_GetCaracteristica INTO Lr_GetCaracteristica;
        --
        CLOSE C_GetCaracteristica;
        --
        --
        -- SE PREGUNTA SI ESTA ABIERTO EL CURSOR 'Lc_GetDocumentosFinancieros'
        IF Lc_GetDocumentosFinancieros%ISOPEN THEN
          CLOSE Lc_GetDocumentosFinancieros;
        END IF;
        --
        -- SE ABRE EL CURSOR 'Lc_GetDocumentosFinancieros' Y SE EMPIEZAN A RECORRER LOS DOCUMENTOS ENCONTRADOS
        OPEN Lc_GetDocumentosFinancieros FOR Lcl_Query;
        --
        LOOP
          --
          FETCH
            Lc_GetDocumentosFinancieros
          INTO
            Lr_GetNotificacionDocumento;
          EXIT
          WHEN Lc_GetDocumentosFinancieros%NOTFOUND;
          --
          --
          -- SE VERIFICA SI EXISTE UN DOCUMENTO A NOTIFICAR
          IF Lr_GetNotificacionDocumento.ID_DOCUMENTO IS NOT NULL AND Lr_GetNotificacionDocumento.ID_DOCUMENTO > 0 THEN
            --
            --Concatena las fila del documento a notificar.
            DBMS_LOB.APPEND(Lcl_TableDocumento, '<tr><td> ' ||
            Lr_GetNotificacionDocumento.FE_CREACION || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.NOMBRE_OFICINA || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.CODIGO_TIPO_DOCUMENTO || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.NUMERO_DOCUMENTO || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.OBSERVACION || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.CLIENTE || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.LOGIN || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.VENDEDOR || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.SUB_TOTAL || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.SUB_TOTAL_CON_IMPUESTO || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.SUB_TOTAL_DESCUENTO || ' </td><td> ' ||
            Lr_GetNotificacionDocumento.VALOR_TOTAL || ' </td></tr>');
            --
            --
            -- SE VERIFICA SI SE ENCONTRO REGISTRO DE LA CARACTERISTICA A RELACIONAR CON CADA DOCUMENTO NOTIFICADO
            IF Lr_GetCaracteristica.ID_CARACTERISTICA IS NOT NULL AND Lr_GetCaracteristica.ID_CARACTERISTICA > 0 THEN
              --
              -- SE INSERTA LA CARACTERISTICA DEL DOCUMENTO NOTIFICADO
              Pv_MensajeError                                            := NULL;
              Lr_InfoDocumentoCaracteristica                             := NULL;
              Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
              Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Lr_GetNotificacionDocumento.ID_DOCUMENTO;
              Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Lr_GetCaracteristica.ID_CARACTERISTICA;
              Lr_InfoDocumentoCaracteristica.VALOR                       := 'S';
              Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
              Lr_InfoDocumentoCaracteristica.USR_CREACION                := 'telcos';
              Lr_InfoDocumentoCaracteristica.IP_CREACION                 := '127.0.0.1';
              Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;
              --
              DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT( Lr_InfoDocumentoCaracteristica, Pv_MensajeError );
              --
              --
              IF TRIM(Pv_MensajeError) IS NOT NULL THEN
                --
                Pv_MensajeError := 'Hubo un error al guardar la caracteristica del documento ' || Lr_GetNotificacionDocumento.ID_DOCUMENTO || ' - ' 
                                   || Pv_MensajeError;
                --
                RAISE Lex_Exception;
                --
              END IF;
              --
              --
              -- SE INSERTA EL HISTORIAL DEL DOCUMENTO NOTIFICADO
              Pv_MensajeError                                      := NULL;
              Lr_InfoDocumentoFinancieroHis                        := NULL;
              Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
              Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID           := Lr_GetNotificacionDocumento.ID_DOCUMENTO;
              Lr_InfoDocumentoFinancieroHis.FE_CREACION            := SYSDATE;
              Lr_InfoDocumentoFinancieroHis.USR_CREACION           := 'telcos';
              Lr_InfoDocumentoFinancieroHis.ESTADO                 := Lr_GetNotificacionDocumento.ESTADO_DOCUMENTO;
              Lr_InfoDocumentoFinancieroHis.OBSERVACION            := Lcl_ObservacionHistorialDoc;
              --
              DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis, Pv_MensajeError);
              --
              --
              IF TRIM(Pv_MensajeError) IS NOT NULL THEN
                --
                Pv_MensajeError := 'Hubo un error al guardar el historial del documento ' || Lr_GetNotificacionDocumento.ID_DOCUMENTO || ' - ' 
                                   || Pv_MensajeError;
                --
                RAISE Lex_Exception;
                --
              END IF;
              --
              --
              Ln_CounterCommit := Ln_CounterCommit + 1;
              --
              --
              -- SE CONSULTA SI EL NUMERO DE DOCUMENTOS ENCONTRADOS SON IGUALES O MAYORES QUE 100 PARA ENVIAR EL RESPECTIVO MAIL Y GUARDAR EL
              -- HISTORIAL Y CARACTERISTICA RESPECTIVA POR CADA DOCUMENTO
              IF Ln_CounterCommit >= 100 THEN
                --
                Ln_CounterCommit := 0;
                --
                --
                -- SE OBTIENE EL CUERPO QUE SERA ENVIADO EN EL CORREO
                Lcl_MessageMail := NULL;
                Lcl_MessageMail := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lc_GetAliasPlantilla.PLANTILLA, 
                                                                              '{{ documentos|raw }}', 
                                                                              Lcl_TableDocumento);
                --
                --Envia correo
                DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_GetAdmiParametrosDet.VALOR2, 
                                                        Lc_GetAliasPlantilla.ALIAS_CORREOS,
                                                        Lr_GetAdmiParametrosDet.VALOR3,
                                                        SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                        'text/html; charset=UTF-8',
                                                        Pv_MensajeError);
                --
                --
                IF TRIM(Pv_MensajeError) IS NOT NULL THEN
                  --
                  Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
                  --
                  RAISE Lex_Exception;
                  --
                END IF;
                --
                --
                DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
                --
                Lcl_TableDocumento := '';
                --
                DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);
                --
                --
                COMMIT;
                --
              END IF;
              --
            ELSE
              --
              Pv_MensajeError := 'No se encontr� la caracter�stica en la tabla DB_COMERCIAL.ADMI_CARACTERISTICA en estado Activo';
              --
              RAISE Lex_Exception;
              --
            END IF;--Lr_GetCaracteristica.ID_CARACTERISTICA IS NOT NULL AND Lr_GetCaracteristica.ID_CARACTERISTICA > 0
            --
          END IF;--Lr_GetNotificacionDocumento.ID_DOCUMENTO IS NOT NULL AND Lr_GetNotificacionDocumento.ID_DOCUMENTO   > 0
          --
        END LOOP;
        --
        CLOSE Lc_GetDocumentosFinancieros;
        --
        --
        -- SI TERMINA EL LAZO Y LOS DOCUMENTOS ENCONTRADOS SON MENORES QUE 100 PERO MAYORES QUE CERO SE ENVIA EL CORREO RESPECTIVO Y SE GUARDA EL 
        -- HISTORIAL Y CARACTERISTICA POR CADA DOCUMENTO
        IF Ln_CounterCommit < 100 AND Ln_CounterCommit > 0 THEN
          --
          --
          -- SE OBTIENE EL CUERPO QUE SERA ENVIADO EN EL CORREO
          Lcl_MessageMail := NULL;
          Lcl_MessageMail := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{ documentos|raw }}', Lcl_TableDocumento);
          --
          --
          -- Envia correo
          DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_GetAdmiParametrosDet.VALOR2, 
                                                  Lc_GetAliasPlantilla.ALIAS_CORREOS,
                                                  Lr_GetAdmiParametrosDet.VALOR3,
                                                  SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                  'text/html; charset=UTF-8',
                                                  Pv_MensajeError);
          --
          --
          IF TRIM(Pv_MensajeError) IS NOT NULL THEN
            --
            Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
          --
          DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
          --
          Lcl_TableDocumento := '';
          --
          COMMIT;
          --
        END IF;
        --
      END IF;--Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET ...
      --
    END IF; --Lrf_GetAdmiParamtrosDet
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_ENVIO_NOTIFICACION_DOCUMENTO', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MensajeError := 'Error en FNCK_CONSULTS.P_ENVIO_NOTIFICACION_DOCUMENTO - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                       || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_ENVIO_NOTIFICACION_DOCUMENTO', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
    --
  END P_ENVIO_NOTIFICACION_DOCUMENTO;
  --
  PROCEDURE P_NOTIFICACION_PREFACTURAS( 
    Pv_PrefijoEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pt_FechaPeDesde     IN  TIMESTAMP,
    Pt_FechaPeHasta     IN  TIMESTAMP,
    Pv_EstadoPrefac     IN  VARCHAR2,
    Pv_CodigoPlantilla  IN  DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_Caracteristica   IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Pv_MsnResult        OUT VARCHAR2,
    Pv_MessageError     OUT VARCHAR2)
  IS
    --
    CURSOR C_GetCaracteristica(Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                               Cv_EstadoActivo DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE )
    IS
      --
      SELECT AC.ID_CARACTERISTICA                                   
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND   AC.ESTADO                     = Cv_EstadoActivo;
    --
    CURSOR C_GetPreFacturasEliminadas(Cv_PrefijoEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                                      Cv_Caracteristica   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                      Ct_FechaPeDesde     TIMESTAMP,
                                      Ct_FechaPeHasta     TIMESTAMP,
                                      Cv_EstadoPrefac     VARCHAR2,
                                      Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                      Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      WITH TMP_FACTURAS AS (SELECT
                            IDFC.ID_DOCUMENTO,
                            IDFD.ID_DOC_DETALLE,
                            TRUNC(IDFC.FE_CREACION) FE_CREACION,
                            IOG.NOMBRE_OFICINA NOMBRE_OFICINA,
                            ATDF.NOMBRE_TIPO_DOCUMENTO DOCUMENTO,
                            IDFC.OBSERVACION OBSERVACION,
                            IPR.IDENTIFICACION_CLIENTE CLIENTE,
                            IP.LOGIN LOGIN,
                            IP.USR_VENDEDOR VENDEDOR,
                            NVL(ROUND(IDFC.SUBTOTAL, 4), 0)           SUBTOTAL,
                            NVL(ROUND(IDFI.VALOR_IMPUESTO, 4), 0)     IMPUESTO,
                            NVL(ROUND(IDFC.SUBTOTAL_DESCUENTO, 4), 0) SUBTOTAL_DESCUENTO,
                            NVL(ROUND(IDFC.VALOR_TOTAL, 4), 0) TOTAL
                      FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD,
                            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
                            DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG,
                            DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
                            DB_COMERCIAL.INFO_PUNTO IP,
                            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                            DB_COMERCIAL.INFO_PERSONA IPR,
                            DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                      WHERE IDFC.OFICINA_ID               = IOG.ID_OFICINA
                      AND   IDFC.ID_DOCUMENTO             = IDFD.DOCUMENTO_ID
                      AND   IDFD.ID_DOC_DETALLE           = IDFI.DETALLE_DOC_ID
                      AND   IOG.EMPRESA_ID                = IEG.COD_EMPRESA
                      AND   IEG.PREFIJO                   = Cv_PrefijoEmpresa
                      AND   IDFC.PUNTO_ID                 = IP.ID_PUNTO
                      AND   IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL
                      AND   IPER.PERSONA_ID               = IPR.ID_PERSONA
                      AND   IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
                      AND   ATDF.CODIGO_TIPO_DOCUMENTO    IN  (SELECT APD.VALOR1
                                                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                                     DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                                WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                                                AND   APD.VALOR2           =  'SI'
                                                                AND   APD.ESTADO           =  Cv_EstadoActivo
                                                                AND   APD.VALOR5           =  Cv_PrefijoEmpresa
                                                                AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
                      AND IDFC.ID_DOCUMENTO           NOT IN  (SELECT IDC.DOCUMENTO_ID 
                                                                FROM   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
                                                                       DB_COMERCIAL.ADMI_CARACTERISTICA AC
                                                                WHERE  IDC.CARACTERISTICA_ID         = AC.ID_CARACTERISTICA
                                                                AND    AC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica)
                      AND IDFC.ESTADO_IMPRESION_FACT    =  Cv_EstadoPrefac
                      AND IDFC.NUMERO_FACTURA_SRI       IS NULL 
                      AND IDFC.FE_CREACION              >= Ct_FechaPeDesde
                      AND IDFC.FE_CREACION              <= Ct_FechaPeHasta
      )
      SELECT 
          TMP_FACTURAS.ID_DOCUMENTO,
          TMP_FACTURAS.FE_CREACION,
          TMP_FACTURAS.NOMBRE_OFICINA,
          TMP_FACTURAS.DOCUMENTO,
          DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DFD.OBSERVACIONES_FACTURA_DETALLE) OBSERVACION,
          TMP_FACTURAS.CLIENTE,
          TMP_FACTURAS.LOGIN,
          TMP_FACTURAS.VENDEDOR,
          SUM(ROUND(TMP_FACTURAS.SUBTOTAL, 4)) SUBTOTAL,
          SUM(ROUND(TMP_FACTURAS.IMPUESTO, 4)) IMPUESTO,
          SUM(ROUND(TMP_FACTURAS.SUBTOTAL_DESCUENTO, 4)) DESCUENTO,
          SUM(ROUND(TMP_FACTURAS.TOTAL, 4)) TOTAL
      FROM TMP_FACTURAS
      LEFT OUTER JOIN
      (
          SELECT *
          FROM                     
          (                       
              SELECT IDFD.*,                         
                     ROW_NUMBER() OVER (PARTITION BY DOCUMENTO_ID ORDER BY                         
                     PRECIO_VENTA_FACPRO_DETALLE DESC) RN                       
              FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD                     
          )                   
          WHERE RN = 1                 
      ) DFD               
      ON                 
      DFD.DOCUMENTO_ID = TMP_FACTURAS.ID_DOCUMENTO
      GROUP BY  TMP_FACTURAS.ID_DOCUMENTO,
                TMP_FACTURAS.FE_CREACION,
                TMP_FACTURAS.NOMBRE_OFICINA,
                TMP_FACTURAS.DOCUMENTO,
                DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(DFD.OBSERVACIONES_FACTURA_DETALLE),
                TMP_FACTURAS.CLIENTE,
                TMP_FACTURAS.LOGIN,
                TMP_FACTURAS.VENDEDOR;
    --
    Lv_MsnError                     VARCHAR2(2000);
    Lv_NombreCabCorreoPrefacturas   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE  := 'ENVIO_CORREO_PREFACTURAS';
    Lv_EstadoActivo                 DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE            := 'Activo';
    Lv_NombreParametro              DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE  := 'DOCUMENTOS_PE';
    Lc_GetAliasPlantilla            FNKG_TYPES.Lr_AliasPlantilla; 
    Lr_GetAdmiParamtrosDet          DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_GetAdmiParamtrosDet         SYS_REFCURSOR;
    Lr_PreFacturasEliminadas        C_GetPreFacturasEliminadas%ROWTYPE := NULL;
    Lr_GetCaracteristica            C_GetCaracteristica%ROWTYPE        := NULL;
    Lr_InfoDocumentoFinancieroHist  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Lr_InfoDocumentoCaracteristica  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
    Lcl_ObservacionHistDoc          DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE := 'Documento eliminado fue notificado correctamente al usuario';
    Lv_ParametroVerifica3           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE := NULL;    
    Lv_ParametroVerifica4           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE := NULL;
    Lv_ParamValor2                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := NULL; 
    Lv_ParamValor3                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE := NULL;    
    Lv_ParamValor4                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE := NULL; 
    Lv_NombreTablaContenido         VARCHAR2(100)                             := '{{ DocumentosEliminados | raw }}' ; 
    Lcl_MessageMail                 CLOB;
    Lcl_TablePrefacturasEliminadas  CLOB;
    Ln_CounterPreEliminadas         NUMBER := 0;
    Le_Exception                    EXCEPTION;
    --
  BEGIN
    --
    DBMS_LOB.CREATETEMPORARY(Lcl_TablePrefacturasEliminadas, TRUE);
    --
    IF Pv_Caracteristica = 'NOTIFICACION_PREFACTURAS_PROPORCIONALES' THEN
      --
      Lv_NombreCabCorreoPrefacturas   := 'ENVIO_NOTIFICACION_PREFACTURAS_PROPORCIONALES';
      Lv_NombreParametro              := 'DOCUMENTOS_PP';
      Lcl_ObservacionHistDoc          := 'Prefactura proporcional fue notificada correctamente al usuario';
      --
    END IF;
     --Obtiene caracteristica a notificar
    IF C_GetCaracteristica%ISOPEN THEN
      CLOSE C_GetCaracteristica;
    END IF;
    --
    OPEN C_GetCaracteristica( Pv_Caracteristica, Lv_EstadoActivo );
    --
    FETCH C_GetCaracteristica INTO Lr_GetCaracteristica;
    --
    CLOSE C_GetCaracteristica;
    --Obtiene las pre facturas que se han eliminado a partir de 2 dias atras.
    IF C_GetPreFacturasEliminadas%ISOPEN THEN
      CLOSE C_GetPreFacturasEliminadas;
    END IF;
    --
    OPEN C_GetPreFacturasEliminadas( Pv_PrefijoEmpresa, Pv_Caracteristica,  Pt_FechaPeDesde, 
                                     Pt_FechaPeHasta,   Pv_EstadoPrefac,    Lv_EstadoActivo, 
                                     Lv_NombreParametro );
    --
    LOOP
      --
      FETCH C_GetPreFacturasEliminadas INTO Lr_PreFacturasEliminadas;
      --
      EXIT
    WHEN C_GetPreFacturasEliminadas%NOTFOUND;
      --
      IF Lr_PreFacturasEliminadas.ID_DOCUMENTO       IS NOT NULL AND 
         Lr_PreFacturasEliminadas.FE_CREACION        IS NOT NULL AND 
         Lr_PreFacturasEliminadas.NOMBRE_OFICINA     IS NOT NULL AND 
         Lr_PreFacturasEliminadas.CLIENTE            IS NOT NULL AND 
         Lr_PreFacturasEliminadas.LOGIN              IS NOT NULL THEN
          --
          --Concatena las fila del Documento ELiminado.
          DBMS_LOB.APPEND(Lcl_TablePrefacturasEliminadas, '<tr><td> ' 
                          || Lr_PreFacturasEliminadas.FE_CREACION 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.NOMBRE_OFICINA 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.DOCUMENTO 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.OBSERVACION 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.CLIENTE 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.LOGIN 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.VENDEDOR 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.SUBTOTAL 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.IMPUESTO 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.DESCUENTO 
                          || ' </td><td> ' 
                          || Lr_PreFacturasEliminadas.TOTAL );
          --
          -- SE INSERTA CARACTERISTICA DEL DOCUMENTO A NOTIFICAR
          IF Lr_GetCaracteristica.ID_CARACTERISTICA IS NOT NULL  AND
             Lr_GetCaracteristica.ID_CARACTERISTICA > 0          THEN
             --
              Lv_MsnError                                                := NULL;
              Lr_InfoDocumentoCaracteristica                             := NULL;
              Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
              Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Lr_PreFacturasEliminadas.ID_DOCUMENTO;
              Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Lr_GetCaracteristica.ID_CARACTERISTICA;
              Lr_InfoDocumentoCaracteristica.VALOR                       := 'S';
              Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
              Lr_InfoDocumentoCaracteristica.USR_CREACION                := 'telcos';
              Lr_InfoDocumentoCaracteristica.IP_CREACION                 := '127.0.0.1';
              Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;
              --
              DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT( Lr_InfoDocumentoCaracteristica, Lv_MsnError );
              --
              IF TRIM(Lv_MsnError) IS NOT NULL THEN
                --
                Pv_MsnResult := 'Hubo un error al guardar la caracteristica del documento ' || Lr_PreFacturasEliminadas.ID_DOCUMENTO || ' - ' 
                                || Lv_MsnError;
                --
                RAISE Le_Exception;
                --
              END IF;
              --
              --Insertamos en la historial INFO_DOC_FINANCIERO_HISTORIAL.
              Lv_MsnError                                           := NULL;
              Lr_InfoDocumentoFinancieroHist                        := NULL;
              Lr_InfoDocumentoFinancieroHist.ID_DOCUMENTO_HISTORIAL := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
              Lr_InfoDocumentoFinancieroHist.DOCUMENTO_ID           := Lr_PreFacturasEliminadas.ID_DOCUMENTO;
              Lr_InfoDocumentoFinancieroHist.FE_CREACION            := SYSDATE;
              Lr_InfoDocumentoFinancieroHist.USR_CREACION           := 'telcos';
              Lr_InfoDocumentoFinancieroHist.OBSERVACION            := Lcl_ObservacionHistDoc;

              IF Pv_Caracteristica = 'NOTIFICACION_PREFACTURAS_PROPORCIONALES' THEN
                --
                Lr_InfoDocumentoFinancieroHist.ESTADO               := 'Pendiente';

                --
              ELSE -- NOTIFICACION_PREFACTURAS_ELIMINADAS
                --
                Lr_InfoDocumentoFinancieroHist.ESTADO               := 'Eliminado';
                --
              END IF;
              --
              DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHist, Lv_MsnError);
              --
              Ln_CounterPreEliminadas := Ln_CounterPreEliminadas + 1;
              --
              IF TRIM(Lv_MsnError) IS NOT NULL THEN
                --
                Pv_MsnResult := 'Ocurrio un error al tratar de guardar el historial de la cabecera del documento ' || Lr_PreFacturasEliminadas.ID_DOCUMENTO || ' - ' 
                                   || Lv_MsnError;
                --
                RAISE Le_Exception;
                --
              END IF;
              --
          ELSE
              --
              Pv_MsnResult  := 'No se encontro caracteristica en la tabla DB_COMERCIAL.ADMI_CARACTERISTICA con estado Activo';
              --
              RAISE Le_Exception;
              --
          END IF;
        --
      END IF;
      --
    END LOOP;
    --
    CLOSE C_GetPreFacturasEliminadas;
    --
    IF Ln_CounterPreEliminadas > 0 THEN
      --
      Lrf_GetAdmiParamtrosDet := NULL;
      --
      --VERIFICA QUE PUEDA ENVIAR EL CORREO

      IF Pv_Caracteristica = 'NOTIFICACION_PREFACTURAS_PROPORCIONALES' THEN
        --
        Lv_ParametroVerifica3   := 'NULL';
        Lv_ParametroVerifica4   := 'NULL';
        Lv_ParamValor2          := 'notificaciones_telcos@telconet.ec';
        Lv_ParamValor3          := 'Notificacion Pre facturas proporcionales';
        Lv_ParamValor4          := 'NO';
        Lv_NombreTablaContenido := '{{ factProporcionales | raw }}';
        --
      END IF;

      Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_NombreCabCorreoPrefacturas, Lv_EstadoActivo, 
                                                                         Lv_EstadoActivo, Pv_CodigoPlantilla, 
                                                                         'SI', Lv_ParametroVerifica3, Lv_ParametroVerifica4);
      --
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --VERIFICA SI ESTA ACTIVADO PARA ENVIAR CORREO
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
        --
        Lrf_GetAdmiParamtrosDet := NULL;
        --
        Lr_GetAdmiParamtrosDet := NULL;
        --
        --OBTIENE LOS PARAMETROS PARA EL ENVIO DE CORREO.
        Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_NombreCabCorreoPrefacturas, Lv_EstadoActivo, Lv_EstadoActivo, 
                                                                           Pv_CodigoPlantilla || '_FROM_SUBJECT', Lv_ParamValor2, Lv_ParamValor3,
                                                                           Lv_ParamValor4);
        --
        FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
        --
        CLOSE Lrf_GetAdmiParamtrosDet;
        --
        Lc_GetAliasPlantilla := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla);
        --

        IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND 
           Lc_GetAliasPlantilla.PLANTILLA          IS NOT NULL AND 
           Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL AND 
           Lc_GetAliasPlantilla.ALIAS_CORREOS      IS NOT NULL THEN
          --
          Lcl_MessageMail := FNCK_CONSULTS.F_CLOB_REPLACE(Lc_GetAliasPlantilla.PLANTILLA, Lv_NombreTablaContenido, 
                                                          Lcl_TablePrefacturasEliminadas);
          --Envia correo
          FNCK_CONSULTS.P_SEND_MAIL(Lr_GetAdmiParamtrosDet.VALOR2, Lc_GetAliasPlantilla.ALIAS_CORREOS, 
                                    Lr_GetAdmiParamtrosDet.VALOR3, SUBSTR(Lcl_MessageMail, 1, 32767),
                                    'text/html; charset=UTF-8', Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN
            --
            Pv_MsnResult := 'No se pudo notificar por correo - ' || Lv_MsnError;
            --
          ELSE
            --
            Pv_MsnResult            := 'Se notific� correctamente al usuario: ' || Ln_CounterPreEliminadas || 
                                      ' documento(s) .';
            Ln_CounterPreEliminadas := 0;
            --
          END IF;
          --
        END IF; --Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET ...
        --
        DBMS_LOB.FREETEMPORARY(Lcl_TablePrefacturasEliminadas);
        Lcl_TablePrefacturasEliminadas := '';
        --
      END IF; --Lrf_GetAdmiParamtrosDet
      --
    ELSE
      --
      IF Pv_Caracteristica = 'NOTIFICACION_PREFACTURAS_PROPORCIONALES' THEN
        --
        Pv_MsnResult := 'No existen Prefacturas proporcionales creadas para mostrar.';

        --
      ELSE -- NOTIFICACION_PREFACTURAS_ELIMINADAS
        --
        Pv_MsnResult := 'No existen Documentos eliminados a partir de 48 horas atras.';
        --
      END IF;
      --
    END IF; --Ln_CounterPreEliminadas
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_CONSULTS.P_NOTIFICACION_PREFACTURAS_ELI', 
                                          Pv_MsnResult || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MessageError := 'Error en FNCK_CONSULTS.P_NOTIFICACION_DF - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                        || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'FNCK_CONSULTS.P_NOTIFICACION_PREFACTURAS_ELI', Pv_MessageError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_NOTIFICACION_PREFACTURAS;

  --

  PROCEDURE P_NOTIF_PAGOS_DEPOSITABLES(
    Pv_PrefijoEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_NombreParametroCab        IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Pv_EstadoDeposito            IN  VARCHAR2,
    Pv_MensajeError              OUT VARCHAR2)
  IS
    --
    CURSOR C_GetCaracteristica(Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                               Cv_EstadoCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE )
    IS
      --
      SELECT AC.ID_CARACTERISTICA                                   
      FROM   DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE  AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND    AC.ESTADO                     = Cv_EstadoCaracteristica;
    --

    CURSOR C_GetDepositos(Cv_PrejifoEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                          Cv_EstadoDeposito            IN  VARCHAR2)
    IS
      --
      SELECT
            IDE.ID_DEPOSITO,
            IDE.NO_CUENTA_BANCO_NAF,
            IDE.NO_CUENTA_CONTABLE_NAF,
            TO_CHAR(ROUND(NVL(IDE.VALOR, 0), 4), '9999999990D99') VALOR,
            IDE.FE_CREACION,
            IDE.ESTADO,
            IDE.USR_CREACION
      FROM  DB_FINANCIERO.INFO_DEPOSITO     IDE
      JOIN  DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IDE.EMPRESA_ID = IEG.COD_EMPRESA
      WHERE IDE.ESTADO  = Cv_EstadoDeposito
      AND   IEG.PREFIJO = Cv_PrejifoEmpresa
      ORDER BY IDE.FE_CREACION DESC; 
    --

    CURSOR C_GetPagosDepositables(Cn_DepositoId  IN DB_FINANCIERO.INFO_DEPOSITO.ID_DEPOSITO%TYPE)
    IS
      --
      SELECT
            IP.LOGIN,
            IPC.NUMERO_PAGO,
            AFP.DESCRIPCION_FORMA_PAGO,
            IPC.ESTADO_PAGO,
            DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPD.COMENTARIO) COMENTARIO,
            TO_CHAR(ROUND(NVL(IPD.VALOR_PAGO, 0), 4), '9999999990D99') VALOR_PAGO
      FROM  INFO_PAGO_DET IPD
      JOIN  INFO_PAGO_CAB IPC              ON IPC.ID_PAGO       = IPD.PAGO_ID
      JOIN  INFO_PUNTO IP                  ON IP.ID_PUNTO       = IPC.PUNTO_ID
      JOIN  DB_GENERAL.ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO = IPD.FORMA_PAGO_ID
      WHERE IPD.DEPOSITO_PAGO_ID = Cn_DepositoId;

      Lr_DepositosPendientes         C_GetDepositos%ROWTYPE                                        := NULL;
      Lr_PagosDepositables           C_GetPagosDepositables%ROWTYPE                                := NULL;
      Lr_GetCaracteristica           C_GetCaracteristica%ROWTYPE                                   := NULL;
      Lr_GetAdmiParametrosDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
      Lv_ValorActivo                 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE                     := 'SI';
      Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                     := 'Activo';
      Lr_GetAliasPlantilla           DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
      Lv_MimeType                    VARCHAR2(50)                                                  := 'text/html; charset=UTF-8';
      Lv_NombreTablaContenido        VARCHAR2(100)                                                 := '{{ pagosDepositables | raw }}' ;
      Lv_Remitente                   VARCHAR2(100)                                                 := 'notificaciones_telcos@telconet.ec';
      Lv_titulo                      VARCHAR2(200)                                                 := 'NOTIFICACION PAGOS DEPOSITABLES NO PROCESADOS';
      Ln_TotalPago                   NUMBER                                                        := 0;
      Ln_CounterRow                  NUMBER                                                        := 0;
      Lrf_GetAdmiParametrosDet       SYS_REFCURSOR;
      Lcl_TablePagosDepositables     CLOB;
      Lcl_MessageMail                CLOB;
      Le_Exception                   EXCEPTION;

      BEGIN

        --Se obtiene el alias y la plantilla donde se enviara la notificacion   
        Lr_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla);

        Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Pv_NombreParametroCab, 
                                                                                           Lv_EstadoActivo, 
                                                                                           Lv_EstadoActivo, 
                                                                                           Pv_CodigoPlantilla, 
                                                                                           Pv_PrefijoEmpresa, 
                                                                                           Lv_ValorActivo, 
                                                                                           'NULL');

        FETCH
          Lrf_GetAdmiParametrosDet
        INTO
          Lr_GetAdmiParametrosDet;
        CLOSE Lrf_GetAdmiParametrosDet;


        IF Lr_GetAdmiParametrosDet.PARAMETRO_ID     IS NOT NULL AND 
           Lr_GetAliasPlantilla.PLANTILLA           IS NOT NULL THEN

          DBMS_LOB.CREATETEMPORARY(Lcl_TablePagosDepositables, TRUE);

          --Obtiene dep�sitos con el estado enviado como par�metro.

          IF C_GetDepositos%ISOPEN THEN
            CLOSE C_GetDepositos;
          END IF;
          --
          FOR Lr_DepositosPendientes IN C_GetDepositos(Pv_PrefijoEmpresa ,Pv_EstadoDeposito)
          --
          LOOP
            --
            --Obteniendo informaci�n del dep�sito.

            DBMS_LOB.APPEND(Lcl_TablePagosDepositables,
                           '
                            <tr>
                            <td colspan="2">
                              <table class = "cssTable"  align="center" >
                                <tr><th colspan="6" class = "cssTable" align="center">  DEPOSITO </th></tr>
                                <tr>
                                    <th> No Cuenta Banco </th>
                                    <th> No Cuenta Contable</th>
                                    <th> Valor <br></th>
                                    <th> Fecha Creaci&oacute;n<br></th>
                                    <th> Usuario Creaci&oacute;n<br></th>
                                    <th> Estado<br></th>
                                </tr>
                           '
                           ); 

            DBMS_LOB.APPEND(Lcl_TablePagosDepositables, '<tr><td> ' 
                            || Lr_DepositosPendientes.NO_CUENTA_BANCO_NAF 
                            || ' </td><td> ' 
                            || Lr_DepositosPendientes.NO_CUENTA_CONTABLE_NAF 
                            || ' </td><td> ' 
                            || Lr_DepositosPendientes.VALOR 
                            || ' </td><td> ' 
                            || Lr_DepositosPendientes.FE_CREACION 
                            || ' </td><td> ' 
                            || Lr_DepositosPendientes.USR_CREACION
                            || ' </td><td> ' 
                            || Lr_DepositosPendientes.ESTADO 
                            || '</td></tr> ' 
                            || '<tr>
                                  <table class = "cssTable"  align="center" >
                                    <tr>
                                      <th> Login </th>
                                      <th> No Pago</th>
                                      <th> Forma de Pago <br></th>
                                      <th> Estado Pago<br></th>
                                      <th> Comentario<br></th>
                                      <th> Valor Pago<br></th>
                                    </tr>');

            IF C_GetPagosDepositables%ISOPEN THEN
              CLOSE C_GetPagosDepositables;
            END IF;
            --
            FOR Lr_PagosDepositables IN C_GetPagosDepositables(Lr_DepositosPendientes.ID_DEPOSITO)
            --
            LOOP
              --
              DBMS_LOB.APPEND(Lcl_TablePagosDepositables, '<tr><td> ' 
                              || Lr_PagosDepositables.LOGIN 
                              || ' </td><td> ' 
                              || Lr_PagosDepositables.NUMERO_PAGO 
                              || ' </td><td> ' 
                              || Lr_PagosDepositables.DESCRIPCION_FORMA_PAGO 
                              || ' </td><td> ' 
                              || Lr_PagosDepositables.ESTADO_PAGO 
                              || ' </td><td> ' 
                              || Lr_PagosDepositables.COMENTARIO 
                              || ' </td><td> ' 
                              || Lr_PagosDepositables.VALOR_PAGO
                              || '</td></tr> ');

              Ln_TotalPago := ROUND(NVL(Ln_TotalPago, 0), 4)  + ROUND(NVL(Lr_PagosDepositables.VALOR_PAGO, 0), 4); 

            END LOOP;

            DBMS_LOB.APPEND(Lcl_TablePagosDepositables, 
                            '<tr><th colspan="5" class = "cssTable" align="rigth">Total</th> <td>'|| TO_CHAR(ROUND(Ln_TotalPago, 4), '9999999990D99')||'</td></tr>');
            Ln_TotalPago := 0;

            DBMS_LOB.APPEND(Lcl_TablePagosDepositables, '</table></tr></table></td></tr></br>');

            Ln_CounterRow := Ln_CounterRow + 1;

            IF Ln_CounterRow >= 5 THEN
              Ln_CounterRow := 0;
              Lcl_MessageMail  := NULL;
              Lcl_MessageMail  := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA, 
                                                                             Lv_NombreTablaContenido, 
                                                                             Lcl_TablePagosDepositables);
              --Envia correo
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lv_Remitente, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lv_titulo,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);

              IF TRIM(Pv_MensajeError) IS NOT NULL THEN

                Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;          
                RAISE Le_Exception;

              END IF;

              DBMS_LOB.FREETEMPORARY(Lcl_TablePagosDepositables);

              Lcl_TablePagosDepositables := '';

              DBMS_LOB.CREATETEMPORARY(Lcl_TablePagosDepositables, TRUE);


            END IF;

          END LOOP;

          -- 

          IF Ln_CounterRow < 5 AND Ln_CounterRow > 0 THEN
            --
            --
            -- SE OBTIENE EL CUERPO QUE SERA ENVIADO EN EL CORREO
              Lcl_MessageMail  := NULL;
              Lcl_MessageMail  := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA, 
                                                                             Lv_NombreTablaContenido, 
                                                                             Lcl_TablePagosDepositables);
              --Envia correo
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lv_Remitente, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lv_titulo,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);
            --
            --
            IF TRIM(Pv_MensajeError) IS NOT NULL THEN
              --
              Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
              --
              RAISE Le_Exception;
              --
            END IF;
            --
            --
            DBMS_LOB.FREETEMPORARY(Lcl_TablePagosDepositables);
            --
            Lcl_TablePagosDepositables := '';

          END IF;

        END IF;

  EXCEPTION
    WHEN Le_Exception THEN

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_NOTIF_PAGOS_DEPOSITABLES', 
                                            Pv_MensajeError||SQLERRM, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );

  END P_NOTIF_PAGOS_DEPOSITABLES;

  PROCEDURE P_GET_PTOS_NOFACTURADOS(
    Pv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pr_ParamFechaDesde    IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Pr_ParamFechaHasta    IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Prf_PtosNoFacturados  OUT SYS_REFCURSOR)
  IS
    Lcl_Query                 CLOB ;
    Lv_InfoError              VARCHAR2(3000);
    Lv_EstadoActivo           DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
  BEGIN

      Lcl_Query :='SELECT DISTINCT(IPT.LOGIN)         AS PUNTO_CLIENTE,
                          IPTA.LOGIN                  AS PUNTO_AFECTADO,
                          APR.DESCRIPCION_PRODUCTO    AS PRODUCTO,
                    CASE
                      WHEN TRIM(IPE.RAZON_SOCIAL) IS NOT NULL
                      THEN DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(TRIM(IPE.RAZON_SOCIAL))
                      ELSE DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(CONCAT(TRIM(IPE.NOMBRES), CONCAT('' '', 
                                                                                                                         TRIM(IPE.APELLIDOS)))) '
                    ||'END CLIENTE,
                    NVL(IPE.IDENTIFICACION_CLIENTE,'' '') AS IDENTIFICACION_CLIENTE,
                    CASE
                      WHEN TRIM(IPER.ES_PREPAGO) = ''S''
                      THEN ''MENSUAL''
                      ELSE ''POSTPAGO''
                    END TIPO
                    FROM DB_COMERCIAL.INFO_SERVICIO   ISE
                    JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL   ISH  ON ISE.ID_SERVICIO            = ISH.SERVICIO_ID
                    JOIN DB_COMERCIAL.ADMI_PRODUCTO             APR  ON ISE.PRODUCTO_ID            = APR.ID_PRODUCTO
                    JOIN DB_COMERCIAL.INFO_PUNTO                IPTA ON IPTA.ID_PUNTO              = ISE.PUNTO_ID
                    JOIN DB_COMERCIAL.INFO_PUNTO                IPT  ON IPT.ID_PUNTO               = ISE.PUNTO_FACTURACION_ID
                    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  IPER ON IPT.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                    JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.ID_PERSONA = IPER.PERSONA_ID
                    WHERE ISH.ACCION = ''conteoFrecuencia'' ';
      IF Pr_ParamFechaDesde.valor1 IS NOT NULL THEN
        Lcl_Query := Lcl_Query ||'  AND ISH.FE_CREACION >= (SYSDATE - NUMTODSINTERVAL('||Pr_ParamFechaDesde.valor3||','''||Pr_ParamFechaDesde.valor4||''' )) ';
      END IF;

      IF Pr_ParamFechaHasta.valor1 IS NOT NULL THEN
        Lcl_Query := Lcl_Query ||'  AND ISH.FE_CREACION <= (SYSDATE - NUMTODSINTERVAL('||Pr_ParamFechaHasta.valor3||','''||Pr_ParamFechaHasta.valor4||''' )) ';
      END IF;

      Lcl_Query := Lcl_Query ||'
      AND IPER.ES_PREPAGO <> ''M''
      AND (SELECT IEG.PREFIJO 
           FROM DB_COMERCIAL.INFO_PUNTO IPT,
                DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
          WHERE IPT.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
          AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
          AND IER.EMPRESA_COD = IEG.COD_EMPRESA
          AND IPT.ID_PUNTO = ISE.PUNTO_ID) = '''||Pv_PrefijoEmpresa||'''    
          AND ISE.ID_SERVICIO NOT IN(
                                    SELECT ISE2.ID_SERVICIO FROM DB_COMERCIAL.INFO_SERVICIO   ISE2
                                    JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL   ISH2 ON ISE2.ID_SERVICIO = ISH2.SERVICIO_ID
                                    WHERE ISH2.ACCION = ''reinicioConteo'' ';

      IF Pr_ParamFechaDesde.valor1 IS NOT NULL THEN
        Lcl_Query := Lcl_Query ||'  AND ISH.FE_CREACION >= (SYSDATE - NUMTODSINTERVAL('||Pr_ParamFechaDesde.valor3||','''||Pr_ParamFechaDesde.valor4||'''))';
      END IF;

      IF Pr_ParamFechaHasta.valor1 IS NOT NULL THEN
        Lcl_Query := Lcl_Query ||'  AND ISH.FE_CREACION <= (SYSDATE - NUMTODSINTERVAL('||Pr_ParamFechaHasta.valor3||','''||Pr_ParamFechaHasta.valor4||'''))';
      END IF;

      Lcl_Query   := Lcl_Query ||'
                                    AND (SELECT IEG.PREFIJO 
                                         FROM DB_COMERCIAL.INFO_PUNTO IPT,
                                            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                                            DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                                            DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
                                         WHERE IPT.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                                         AND IPER.EMPRESA_ROL_ID          = IER.ID_EMPRESA_ROL
                                         AND IER.EMPRESA_COD              = IEG.COD_EMPRESA
                                         AND IPT.ID_PUNTO                 = ISE2.PUNTO_ID )='''||Pv_PrefijoEmpresa||'''
                                         AND ISH2.USR_CREACION            = ''telcos'')
           AND ISE.ESTADO              = '''||Lv_EstadoActivo||'''
           AND ISE.MESES_RESTANTES     = 0
           AND ISE.ES_VENTA            = ''S''
           AND ISE.PRECIO_VENTA        > 0 
           AND ISE.FRECUENCIA_PRODUCTO > 0 ';

    OPEN Prf_PtosNoFacturados FOR Lcl_Query;

    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError := 'Error en FNCK_NOTIFICACIONES.P_GET_PTOS_NOFACTURADOS - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_GET_PTOS_NOFACTURADOS', 
                                            Lv_InfoError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_GET_PTOS_NOFACTURADOS;

  PROCEDURE P_NOTIF_PTOS_NOFACTURADOS(
    Pv_PrefijoEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_MensajeError              OUT VARCHAR2) IS

  -- Costo del query: 4
  CURSOR C_GetParametro(Cv_NombreParamCab VARCHAR2, Cv_EstadoParametroCab VARCHAR2, Cv_EstadoParametroDet VARCHAR2, Cv_Valor1 VARCHAR2, 
                        Cv_Valor2 VARCHAR2, Cv_Valor3 VARCHAR2, Cv_Valor4 VARCHAR2, Cv_Valor5 VARCHAR2, Cv_EmpresaCod VARCHAR2)
  IS
    SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
      DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
    AND APC.ESTADO           = NVL(Cv_EstadoParametroCab, APC.ESTADO)
    AND APD.ESTADO           = NVL(Cv_EstadoParametroDet, APD.ESTADO)
    AND APC.NOMBRE_PARAMETRO = NVL(Cv_NombreParamCab, APC.NOMBRE_PARAMETRO)
    AND APD.VALOR1           = NVL(Cv_Valor1, APD.VALOR1)
    AND APD.VALOR2           = NVL(Cv_Valor2, APD.VALOR2)
    AND APD.VALOR3           = NVL(Cv_Valor3, APD.VALOR3)
    AND APD.VALOR4           = NVL(Cv_Valor4, APD.VALOR4)
    AND APD.VALOR5           = NVL(Cv_Valor5, APD.VALOR5)
    AND APD.EMPRESA_COD      = NVL(Cv_EmpresaCod, APD.EMPRESA_COD);



  Lr_GetAdmiParametrosDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lrf_GetAdmiParametrosDet       SYS_REFCURSOR;
  Lrf_GetPtosNoFacturados        SYS_REFCURSOR; 
  Lv_NombreParametroCab          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'RPT_PTOS_FACT_INSTALACION';
  Lv_PrefijoEmpresa              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE                        := Pv_PrefijoEmpresa;
  Lr_Parametro                   C_GetParametro%ROWTYPE;
  Lr_ParamFechaDesde             C_GetParametro%ROWTYPE;
  Lr_ParamFechaHasta             C_GetParametro%ROWTYPE;
  Lr_ParametroFeDesde            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lr_ParametroFeHasta            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_ValidacionFechas            DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'FECHAS_NOTIFICACION_PTOSNOFACT';
  Lv_FechaDesde                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := 'VALIDACION_FECHA_DESDE';
  Lv_FechaHasta                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := 'VALIDACION_FECHA_HASTA';
  Lv_ValorActivo                 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                        := 'S';
  Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                        := 'Activo';
  Lr_PtosNoFacturados            T_PtoNoFacturado;
  Lr_GetAliasPlantilla           DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  Lr_PtoNoFacturado              DB_FINANCIERO.FNKG_TYPES.Lr_PtosNoFacturados;
  Lcl_TableDocumento             CLOB;
  Lv_CodigoPlantilla             DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE                       := Pv_CodigoPlantilla;
  Lv_Datosmail                   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := Lv_CodigoPlantilla || '_HEADERS';
  Lv_NombreCabeceraEnviocorreo   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := Lv_CodigoPlantilla || '_HEADERS';
  Le_Exception                   EXCEPTION;
  Ln_Indsx                       NUMBER;
  Ln_CounterCommit               NUMBER                                                           := 0;
  Lcl_MessageMail                CLOB;
  Lv_MimeType                    VARCHAR2(50)                                                     := 'text/html; charset=UTF-8';
  BEGIN
     --Verifica que pueda enviar correo para los puntos no facturados
    Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreParametroCab, 
                                                                                       Lv_EstadoActivo, 
                                                                                       Lv_EstadoActivo, 
                                                                                       Lv_NombreParametroCab, 
                                                                                       Lv_PrefijoEmpresa, 
                                                                                       Lv_ValorActivo, 
                                                                                       NULL);

    FETCH
      Lrf_GetAdmiParametrosDet
    INTO
      Lr_GetAdmiParametrosDet;
    CLOSE Lrf_GetAdmiParametrosDet;

    IF Lr_GetAdmiParametrosDet.parametro_id IS NOT NULL THEN

      --Se valida si esta activo el filtro por fecha desde
      Lr_ParamFechaDesde :=NULL;
      OPEN C_GetParametro(Lv_ValidacionFechas, Lv_EstadoActivo, Lv_EstadoActivo, Lv_FechaDesde, Lv_ValorActivo, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);

      FETCH C_GetParametro INTO Lr_ParamFechaDesde;
      CLOSE C_GetParametro;

      --Se valida si esta activo el filtro por fecha hasta
      Lr_ParamFechaHasta :=NULL;
      OPEN C_GetParametro(Lv_ValidacionFechas, Lv_EstadoActivo, Lv_EstadoActivo, Lv_FechaHasta, Lv_ValorActivo, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);

      FETCH C_GetParametro INTO Lr_ParamFechaHasta;
      CLOSE C_GetParametro;

      Lr_ParametroFeDesde.VALOR1 := Lr_ParamFechaDesde.VALOR1;
      Lr_ParametroFeDesde.VALOR3 := Lr_ParamFechaDesde.VALOR3;
      Lr_ParametroFeDesde.VALOR4 := Lr_ParamFechaDesde.VALOR4;

      Lr_ParametroFeHasta.VALOR1 := Lr_ParamFechaHasta.VALOR1;
      Lr_ParametroFeHasta.VALOR3 := Lr_ParamFechaHasta.VALOR3;
      Lr_ParametroFeHasta.VALOR4 := Lr_ParamFechaHasta.VALOR4;

      --Se obtiene los par�metros para enviar el correo
      OPEN C_GetParametro(Lv_NombreCabeceraEnvioCorreo, Lv_EstadoActivo, Lv_EstadoActivo, Lv_DatosMail, NULL, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);

      FETCH C_GetParametro INTO Lr_Parametro;
      CLOSE C_GetParametro;

      --Se obtiene el alias y la plantilla donde se enviar� la notificaci�n   
      Lr_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_CodigoPlantilla);    
      --Si no esta configurado la plantilla con alias y el par�metro con los datos del remitente y asunto
      --no se enviar� la notificaci�n
      IF Lr_Parametro.ID_PARAMETRO_DET     IS NOT NULL AND
        Lr_GetAliasPlantilla.PLANTILLA     IS NOT NULL AND
        Lr_Parametro.VALOR2                IS NOT NULL AND
        Lr_Parametro.VALOR3                IS NOT NULL AND
        Lr_GetAliasPlantilla.ALIAS_CORREOS IS NOT NULL THEN

        DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);

        IF Lrf_GetPtosNoFacturados%ISOPEN THEN
          CLOSE Lrf_GetPtosNoFacturados;
        END IF;

        DB_FINANCIERO.FNKG_NOTIFICACIONES.P_GET_PTOS_NOFACTURADOS(Pv_PrefijoEmpresa,
                                                                  Lr_ParametroFeDesde,
                                                                  Lr_ParametroFeHasta,
                                                                  Lrf_GetPtosNoFacturados);      
        LOOP

          FETCH Lrf_GetPtosNoFacturados BULK COLLECT INTO Lr_PtosNoFacturados LIMIT 1000;
          Ln_Indsx := Lr_PtosNoFacturados.FIRST;
          WHILE (Ln_Indsx IS NOT NULL)
            LOOP
              Lr_PtoNoFacturado:=Lr_PtosNoFacturados(Ln_Indsx);
              DBMS_LOB.APPEND(Lcl_TableDocumento, '<tr><td> ' ||
                             NVL(Lr_PtoNoFacturado.TIPO,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.CLIENTE,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PUNTO_CLIENTE,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PUNTO_AFECTADO,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PRODUCTO,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.IDENTIFICACION_CLIENTE,'''') || ' </td></tr>');
              Ln_Indsx := Lr_PtosNoFacturados.NEXT(Ln_Indsx);
            END LOOP;


            Ln_CounterCommit := Ln_CounterCommit + 1;

            IF Ln_CounterCommit >= 50 THEN

              Ln_CounterCommit := 0;
              Lcl_MessageMail  := NULL;
              Lcl_MessageMail  := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA, 
                                                                            '{{ plPtosNoFact | raw }}', 
                                                                            Lcl_TableDocumento);
              --Env�a correo
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR2, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lr_Parametro.VALOR3,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);


              IF TRIM(Pv_MensajeError) IS NOT NULL THEN

                Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;          
                RAISE Le_Exception;

              END IF;

              DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
              Lcl_TableDocumento := '';
              DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);
              COMMIT;

            END IF;           

            EXIT
              WHEN Lrf_GetPtosNoFacturados%notfound;

        END LOOP;
        CLOSE Lrf_GetPtosNoFacturados;

        --En caso de que el contador no haya llegado a 50 se env�a los documentos obtenidos hasta el momento
        IF Ln_CounterCommit < 50 AND Ln_CounterCommit > 0 THEN

          Lcl_MessageMail := NULL;
          Lcl_MessageMail := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA,
                                                                        '{{ plPtosNoFact | raw }}', 
                                                                        Lcl_TableDocumento);   
          --Env�a correo
          DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR2, 
                                                  Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                  Lr_Parametro.VALOR3,
                                                  SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                  Lv_MimeType,
                                                  Pv_MensajeError);

          IF TRIM(Pv_MensajeError) IS NOT NULL THEN
            Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
            RAISE Le_Exception;
          END IF;

          DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
          Lcl_TableDocumento := '';
          COMMIT;
        END IF;

      END IF;

    END IF;
  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_NOTIF_PTOS_NOFACTURADOS', 
                                            Pv_MensajeError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );

    WHEN OTHERS THEN
      ROLLBACK;
      Pv_MensajeError := 'Error en FNCK_NOTIFICACIONES.P_NOTIF_PTOS_NOFACTURADOS - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_NOTIF_PTOS_NOFACTURADOS', 
                                            Pv_MensajeError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_NOTIF_PTOS_NOFACTURADOS;

  PROCEDURE P_GET_PTOS_NOFACTURADOS_INST(
    Pv_CodEmpresa         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Prf_PtosNoFacturados  OUT SYS_REFCURSOR)
  IS
    Lcl_Query                 CLOB ;
    Lv_InfoError              VARCHAR2(3000);
    Lv_EstadoActivo           DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
  BEGIN

      Lcl_Query :=' SELECT
                    DISTINCT(ISE.PUNTO_FACTURACION_ID),
                    CASE
                      WHEN TRIM(IPE.RAZON_SOCIAL) IS NOT NULL
                      THEN DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(TRIM(IPE.RAZON_SOCIAL))
                      ELSE DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(CONCAT(TRIM(IPE.NOMBRES), CONCAT('' '', 
                                                                                                                         TRIM(IPE.APELLIDOS)))) END CLIENTE,
                    (SELECT IPTA.LOGIN FROM DB_COMERCIAL.INFO_PUNTO IPTA WHERE IPTA.ID_PUNTO = ISE.PUNTO_ID) AS PUNTO_CLIENTE,
                    APR.DESCRIPCION_PRODUCTO AS PRODUCTO,  
                    (IP.LOGIN) AS PTO_FACTURACION, 
                    IPDA.GASTO_ADMINISTRATIVO,
                    ISE.TIPO_ORDEN, 
                    IPE.PAGA_IVA, 
                    ISE.ESTADO,
                    ISH.ESTADO AS ESTADO_HIST,
                    ISE.CANTIDAD,
                    ISE.ES_VENTA,
                    ATN.CODIGO_TIPO_NEGOCIO,
                    ISE.FRECUENCIA_PRODUCTO,
                    AR.DESCRIPCION_ROL,
                    ISE.PRECIO_VENTA,
                    ISE.PRECIO_INSTALACION,
                    '' '' AS GENERA_FACTURA
                    FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH 
                    JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO=ISH.SERVICIO_ID 
                    LEFT JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO=ISE.PUNTO_FACTURACION_ID
                    JOIN DB_COMERCIAL.ADMI_PRODUCTO APR  ON ISE.PRODUCTO_ID = APR.ID_PRODUCTO
                    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID = IP.ID_PUNTO 
                    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID 
                    JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.ID_PERSONA = IPER.PERSONA_ID 
                    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID 
                    JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO ATN ON ATN.ID_TIPO_NEGOCIO = IP.TIPO_NEGOCIO_ID 
                    JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID 
                    WHERE IER.EMPRESA_COD = '''||Pv_CodEmpresa||'''   
                    AND ( UPPER(DBMS_LOB.SUBSTR(ISH.OBSERVACION)) LIKE ''%CONFIRMO%'' OR  ISH.ACCION = ''confirmarServicio'' )
                    AND ISH.FE_CREACION >= TRUNC(SYSDATE)
                    AND ISE.PRECIO_INSTALACION > 0 

                    UNION 

                    SELECT
                    NVL(ISE.PUNTO_FACTURACION_ID,0) AS PUNTO_FACTURACION_ID,
                    CASE
                      WHEN TRIM(IPE.RAZON_SOCIAL) IS NOT NULL
                      THEN DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(TRIM(IPE.RAZON_SOCIAL))
                      ELSE DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(CONCAT(TRIM(IPE.NOMBRES), CONCAT('' '', 
                                                                                                                         TRIM(IPE.APELLIDOS)))) END CLIENTE,
                    (SELECT IPTA.LOGIN FROM DB_COMERCIAL.INFO_PUNTO IPTA WHERE IPTA.ID_PUNTO = ISE.PUNTO_ID) AS PUNTO_CLIENTE,
                    APR.DESCRIPCION_PRODUCTO AS PRODUCTO,  
                    '' '' AS PTO_FACTURACION, 
                    IPDA.GASTO_ADMINISTRATIVO,
                    ISE.TIPO_ORDEN, 
                    IPE.PAGA_IVA, 
                    ISE.ESTADO,
                    ISH.ESTADO AS ESTADO_HIST,
                    ISE.CANTIDAD,
                    ISE.ES_VENTA,
                    ATN.CODIGO_TIPO_NEGOCIO,
                    ISE.FRECUENCIA_PRODUCTO,
                    AR.DESCRIPCION_ROL,
                    ISE.PRECIO_VENTA,
                    ISE.PRECIO_INSTALACION,
                    '' '' AS GENERA_FACTURA
                    FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH 
                    JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO=ISH.SERVICIO_ID 
                    LEFT JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.ID_PUNTO=ISE.PUNTO_ID
                    JOIN DB_COMERCIAL.ADMI_PRODUCTO APR  ON ISE.PRODUCTO_ID = APR.ID_PRODUCTO
                    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID = IP.ID_PUNTO 
                    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID 
                    JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.ID_PERSONA = IPER.PERSONA_ID 
                    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID 
                    JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO ATN ON ATN.ID_TIPO_NEGOCIO = IP.TIPO_NEGOCIO_ID 
                    JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID 
                    WHERE IER.EMPRESA_COD = '''||Pv_CodEmpresa||'''   
                    AND ( UPPER(DBMS_LOB.SUBSTR(ISH.OBSERVACION)) LIKE ''%CONFIRMO%'' OR  ISH.ACCION = ''confirmarServicio'' )
                    AND ISH.FE_CREACION >= TRUNC(SYSDATE)
                    AND ISE.PRECIO_INSTALACION > 0 
                    AND ISE.PUNTO_FACTURACION_ID IS NULL ';

    OPEN Prf_PtosNoFacturados FOR Lcl_Query;

    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError := 'Error en FNCK_NOTIFICACIONES.P_GET_PTOS_NOFACTURADOS_INST - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_GET_PTOS_NOFACTURADOS_INST', 
                                            Lv_InfoError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_GET_PTOS_NOFACTURADOS_INST;

  PROCEDURE P_RPT_PTOS_NOFACTURADOS_INST(
    Pv_EmpresaCod                IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_MensajeError              OUT VARCHAR2) IS

  -- Costo del query: 4
  CURSOR C_GetParametro(Cv_NombreParamCab VARCHAR2, Cv_EstadoParametroCab VARCHAR2, Cv_EstadoParametroDet VARCHAR2, Cv_Valor1 VARCHAR2, 
                        Cv_Valor2 VARCHAR2, Cv_Valor3 VARCHAR2, Cv_Valor4 VARCHAR2, Cv_Valor5 VARCHAR2, Cv_EmpresaCod VARCHAR2)
  IS
    SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4,APD.VALOR5
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
      DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
    AND APC.ESTADO           = NVL(Cv_EstadoParametroCab, APC.ESTADO)
    AND APD.ESTADO           = NVL(Cv_EstadoParametroDet, APD.ESTADO)
    AND APC.NOMBRE_PARAMETRO = NVL(Cv_NombreParamCab, APC.NOMBRE_PARAMETRO)
    AND APD.VALOR1           = NVL(Cv_Valor1, APD.VALOR1)
    AND APD.VALOR2           = NVL(Cv_Valor2, APD.VALOR2)
    AND APD.VALOR3           = NVL(Cv_Valor3, APD.VALOR3)
    AND APD.VALOR4           = NVL(Cv_Valor4, APD.VALOR4)
    AND APD.VALOR5           = NVL(Cv_Valor5, APD.VALOR5)
    AND APD.EMPRESA_COD      = NVL(Cv_EmpresaCod, APD.EMPRESA_COD);

  Lrf_GetAdmiParametrosDet       SYS_REFCURSOR;
  Lrf_GetPtosNoFacturados        SYS_REFCURSOR; 
  Lv_NombreParametroCab          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'RPT_PTOS_FACT_INSTALACION';
  Lr_Parametro                   C_GetParametro%ROWTYPE;
  Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                        := 'Activo';
  Lr_PtosNoFacturados            T_PtosFacturarInst;
  Lr_GetAliasPlantilla           DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  Lr_PtoNoFacturado              DB_FINANCIERO.FNKG_TYPES.Lr_PtosFacturarInst;
  Lcl_TableDocumento             CLOB;
  Lv_CodigoPlantilla             DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE                       := Pv_CodigoPlantilla;
  Lv_Datosmail                   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := 'PTOS_FACT_INST';
  Le_Exception                   EXCEPTION;
  Ln_Indsx                       NUMBER;
  Ln_CounterCommit               NUMBER                                                           := 0;
  Lcl_MessageMail                CLOB;
  Lv_MimeType                    VARCHAR2(50)                                                     := 'text/html; charset=UTF-8';
  Lv_GeneraFactura               VARCHAR2(2)                                                      := 'Si';
  BEGIN      
      --Se obtiene los par�metros para enviar el correo
      OPEN C_GetParametro(Lv_NombreParametroCab, Lv_EstadoActivo, Lv_EstadoActivo, Lv_DatosMail, NULL, NULL, NULL, NULL,Pv_EmpresaCod);

      FETCH C_GetParametro INTO Lr_Parametro;
      CLOSE C_GetParametro;

      --Se obtiene el alias y la plantilla donde se enviar� la notificaci�n   
      Lr_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_CodigoPlantilla);    
      --Si no esta configurado la plantilla con alias y el par�metro con los datos del remitente y asunto
      --no se enviar� la notificaci�n
      IF Lr_Parametro.ID_PARAMETRO_DET     IS NOT NULL AND
        Lr_GetAliasPlantilla.PLANTILLA     IS NOT NULL AND
        Lr_Parametro.VALOR2                IS NOT NULL AND
        Lr_Parametro.VALOR3                IS NOT NULL AND
        Lr_GetAliasPlantilla.ALIAS_CORREOS IS NOT NULL THEN

        DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);

        IF Lrf_GetPtosNoFacturados%ISOPEN THEN
          CLOSE Lrf_GetPtosNoFacturados;
        END IF;

        DB_FINANCIERO.FNKG_NOTIFICACIONES.P_GET_PTOS_NOFACTURADOS_INST(Pv_EmpresaCod,Lrf_GetPtosNoFacturados);      
        LOOP

          FETCH Lrf_GetPtosNoFacturados BULK COLLECT INTO Lr_PtosNoFacturados LIMIT 1000;
          Ln_Indsx := Lr_PtosNoFacturados.FIRST;
          WHILE (Ln_Indsx IS NOT NULL)
            LOOP
              Lr_PtoNoFacturado:=Lr_PtosNoFacturados(Ln_Indsx);
              IF
                    Lr_PtoNoFacturado.PUNTO_FACTURACION_ID = 0         OR
                    Lr_PtoNoFacturado.TIPO_ORDEN          <> 'N'       OR
                    Lr_PtoNoFacturado.ESTADO              <> 'Activo'  OR
                    Lr_PtoNoFacturado.ESTADO_HIST         <> 'Activo'  OR
                    Lr_PtoNoFacturado.CANTIDAD            <= 0         OR
                    Lr_PtoNoFacturado.ES_VENTA            <> 'S'       OR
                    Lr_PtoNoFacturado.FRECUENCIA_PRODUCTO < 1          OR
                    Lr_PtoNoFacturado.DESCRIPCION_ROL     <> 'Cliente' OR
                    Lr_PtoNoFacturado.PRECIO_VENTA        <= 0         OR    
                    Lr_PtoNoFacturado.PRECIO_INSTALACION  <= 0         THEN
                    Lv_GeneraFactura := 'No';
              END IF;

              DBMS_LOB.APPEND(Lcl_TableDocumento, '<tr><td> ' ||
                             NVL(Lr_PtoNoFacturado.CLIENTE,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PUNTO_CLIENTE,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PRODUCTO,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PTO_FACTURACION,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.ESTADO,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.TIPO_ORDEN,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PAGA_IVA,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.CODIGO_TIPO_NEGOCIO,'''') || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PRECIO_VENTA,0) || ' </td><td> ' ||
                             NVL(Lr_PtoNoFacturado.PRECIO_INSTALACION,0) || ' </td><td> ' ||
                             Lv_GeneraFactura || ' </td></tr>');
              Ln_Indsx := Lr_PtosNoFacturados.NEXT(Ln_Indsx);
              Lv_GeneraFactura := 'Si';
            END LOOP;


            Ln_CounterCommit := Ln_CounterCommit + 1;

            IF Ln_CounterCommit >= 50 THEN

              Ln_CounterCommit := 0;
              Lcl_MessageMail  := NULL;
              Lcl_MessageMail  := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA, 
                                                                            '{{ plPtosFacturar | raw }}', 
                                                                            Lcl_TableDocumento);
              --Env�a correo
            IF Lr_Parametro.VALOR5 = 'N' THEN
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR2, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lr_Parametro.VALOR3,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);
            ELSE
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR4, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lr_Parametro.VALOR3,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);
            END IF;


              IF TRIM(Pv_MensajeError) IS NOT NULL THEN

                Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;          
                RAISE Le_Exception;

              END IF;

              DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
              Lcl_TableDocumento := '';
              DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);
              COMMIT;

            END IF;           

            EXIT
              WHEN Lrf_GetPtosNoFacturados%notfound;

        END LOOP;
        CLOSE Lrf_GetPtosNoFacturados;

        --En caso de que el contador no haya llegado a 50 se env�a los documentos obtenidos hasta el momento
        IF Ln_CounterCommit < 50 AND Ln_CounterCommit > 0 THEN

          Lcl_MessageMail := NULL;
          Lcl_MessageMail := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA,
                                                                        '{{ plPtosFacturar | raw }}', 
                                                                        Lcl_TableDocumento);   
          --Env�a correo
            IF Lr_Parametro.VALOR5 = 'N' THEN
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR2, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lr_Parametro.VALOR3,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);
            ELSE
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR4, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lr_Parametro.VALOR3,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);
            END IF;

          IF TRIM(Pv_MensajeError) IS NOT NULL THEN
            Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
            RAISE Le_Exception;
          END IF;

          DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
          Lcl_TableDocumento := '';
          COMMIT;
        END IF;

      END IF;
  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_RPT_PTOS_NOFACTURADOS_INST', 
                                            Pv_MensajeError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );

    WHEN OTHERS THEN
      ROLLBACK;
      Pv_MensajeError := 'Error en FNCK_NOTIFICACIONES.P_RPT_PTOS_NOFACTURADOS_INST - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_NOTIFICACIONES.P_RPT_PTOS_NOFACTURADOS_INST', 
                                            Pv_MensajeError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_RPT_PTOS_NOFACTURADOS_INST;


END FNKG_NOTIFICACIONES;
/