CREATE OR REPLACE PACKAGE DB_COMUNICACION.CUKG_TRANSACTIONS AS
/**
 * Documentación para P_INSERT_INFO_NOTIF_MASIVA
 * Procedimiento que inserta el registro de un nuevo envío masivo y devuelve un mensaje en caso de haber ocurrido un error al insertar
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 14/09/2017
 *
 * @param Pr_InfoNotifMasiva    IN  DB_COMUNICACION.INFO_NOTIF_MASIVA%ROWTYPE Recibe un objeto con el registro que se desea insertar
 * @param Pv_MsnError           OUT VARCHAR2 Devuelve el mensaje de error
 *
 */
PROCEDURE P_INSERT_INFO_NOTIF_MASIVA(
  Pr_InfoNotifMasiva    IN  DB_COMUNICACION.INFO_NOTIF_MASIVA%ROWTYPE,
  Pv_MsnError           OUT VARCHAR2);

/**
 * Documentación para P_INSERT_INFO_NOTIF_MASIVA_PAR
 * Procedimiento que inserta los registros con los parámetros de búsqueda y envío configuradas para el envío masivo
 *
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 14/09/2017
 *
 * @param Pr_InfoNotifMasivaParam   IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM%ROWTYPE Recibe un objeto con el registro que se desea insertar
 * @param Pv_MsnError               OUT VARCHAR2 Devuelve el mensaje de error
 *
 */
PROCEDURE P_INSERT_INFO_NOTIF_MASIVA_PAR(
  Pr_InfoNotifMasivaParam   IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM%ROWTYPE,
  Pv_MsnError               OUT VARCHAR2);


/**
 * Documentación para P_INSERT_INFO_NOTIF_MASIV_HIST
 * Procedimiento que inserta el registro del hostorial de un envío masivo y devuelve un mensaje en caso de haber ocurrido un error al insertar
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 27/09/2017
 *
 * @param Pr_InfoNotifMasiva    IN  DB_COMUNICACION.INFO_NOTIF_MASIVA%ROWTYPE Recibe un objeto con el registro que se desea insertar
 * @param Pv_MsnError           OUT VARCHAR2 Devuelve el mensaje de error
 *
 */
PROCEDURE P_INSERT_INFO_NOTIF_MASIV_HIST(
  Pr_InfoNotifMasivaHist    IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_HIST%ROWTYPE,
  Pv_MsnError               OUT VARCHAR2);

/**
 * Documentación para P_INSERT_INFO_NOTIF_MASIVA_LOG
 * Procedimiento que inserta el registro de la ejeución de un nuevo envío masivo y devuelve un mensaje en caso de haber ocurrido un error al insertar
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 25/09/2017
 *
 * @param Pr_InfoNotifMasivaLog     IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG%ROWTYPE Recibe un objeto con el registro que se desea insertar
 * @param Pv_MsnError               OUT VARCHAR2 Devuelve el mensaje de error
 *
 */
PROCEDURE P_INSERT_INFO_NOTIF_MASIVA_LOG(
  Pr_InfoNotifMasivaLog     IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG%ROWTYPE,
  Pv_MsnError               OUT VARCHAR2);

/**
 * Documentación para P_INSERT_INFO_NOTIF_M_LOG_DET
 * Procedimiento que inserta el registro con la información del destinatario del envío masivo que se está ejecutando 
 * y devuelve un mensaje en caso de haber ocurrido un error al insertar
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 25/09/2017
 *
 * @param Pr_InfoNotifMasivaLogDet  IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG_DET%ROWTYPE Recibe un objeto con el registro que se desea insertar
 * @param Pv_MsnError               OUT VARCHAR2 Devuelve el mensaje de error
 *
 */
PROCEDURE P_INSERT_INFO_NOTIF_M_LOG_DET(  
  Pr_InfoNotifMasivaLogDet    IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG_DET%ROWTYPE,
  Pv_MsnError                 OUT VARCHAR2);

/**
 * Documentación para P_SEND_MAIL
 * Función que devuelve el contenido con el valor reemplazado de acuerdo a los parámetros enviados
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 25/09/2017
 *
 * @param Pv_From IN CLOB Recibe el usuario que envía el correo
 * @param Pv_To IN VARCHAR2 Recibe el/los usuario(s) destinatarios del correo
 * @param Pv_Subject IN VARCHAR2 Recibe el subject del correo
 * @param Pv_Message IN VARCHAR2 Recibe el cuerpo del mensaje
 * @param Pv_MimeType IN VARCHAR2 Recibe el charset en el que se envía el correo
 * @param Pv_MsnError OUT VARCHAR2 Retorna un mensaje de error
 * @return CLOB
 */
  PROCEDURE P_SEND_MAIL(
      Pv_From       IN  VARCHAR2,
      Pv_To         IN  VARCHAR2,
      Pv_Subject    IN  VARCHAR2,
      Pv_Message    IN  VARCHAR2,
      Pv_MimeType   IN  VARCHAR2,
      Pv_MsnError   OUT VARCHAR2);

/**
 * Documentación para P_ENVIO_NOTIF_MASIVA
 * Procedimiento que enviará las notificaciones de acuerdo a los parámetros de búsqueda y envío de la notificación masiva configurada
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 15/10/2017
 *
 * @param Pn_IdNotifMasiva      IN  DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE Recibe el id de la notificación masiva
 * @param Pv_MsnError           OUT VARCHAR2 Devuelve el mensaje de error
 *
 */
PROCEDURE P_ENVIO_NOTIF_MASIVA(
  Pn_IdNotifMasiva      IN  DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE,
  Pv_MsnError           OUT VARCHAR2);

/**
 * Documentación para P_CREA_JOB_NOTIF_MASIVA
 * Procedimiento que realiza la configuración y creación de un envío masivo
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 14/09/2017
 * 
 * @param Pv_InfoFiltros                IN VARCHAR2 Recibe la información de los parámetros seleccionada en formato HTML
 * @param Pv_Grupo                      IN VARCHAR2 Recibe el nombre del grupo de un producto
 * @param Pv_Subgrupo                   IN VARCHAR2 Recibe el nombre del subgrupo de un producto
 * @param Pn_IdElementoNodo             IN NUMBER Recibe el id del elemento nodo
 * @param Pn_IdElementoSwitch           IN NUMBER Recibe el id del elemento switch
 * @param Pv_EstadoServicio             IN VARCHAR2 Recibe el estado del servicio
 * @param Pv_EstadoPunto                IN VARCHAR2 Recibe el estado del punto
 * @param Pv_EstadoCliente              IN VARCHAR2 Recibe el estado del cliente
 * @param Pv_ClientesVIP                IN VARCHAR2 Recibe 'S' si se desea filtrar sólo por clientes que son VIP o 'N' para excluir a los clientes VIP
 * @param Pv_UsrCreacionFactura         IN VARCHAR2 Recibe el usuario de creación de la factura
 * @param Pn_NumFacturasAbiertas        IN NUMBER Recibe el número mínimo de facturas abiertas
 * @param Pv_PuntosFacturacion          IN VARCHAR2 Recibe 'S' si se desea filtrar sólo por puntos de facturación
 * @param Pv_IdsTiposNegocio            IN VARCHAR2 Recibe los ids del tipo de negocio concatenados con ,
 * @param Pv_IdsOficinas                IN VARCHAR2 Recibe los ids de las oficinas concatenados con ,
 * @param Pv_IdFormaPago                IN VARCHAR2 Recibe el id de la forma de pago
 * @param Pv_NombreFormaPago            IN VARCHAR2 Recibe el nombre de la forma de pago
 * @param Pv_IdsBancosTarjetas          IN VARCHAR2 Recibe los ids de los bancos o tarjetas concatenados con ,
 * @param Pv_FechaDesdeFactura          IN VARCHAR2 Recibe la fecha desde la que comparará la fecha de autorización de las facturas
 * @param Pv_FechaHastaFactura          IN VARCHAR2 Recibe la fecha hasta la que comparará la fecha de autorización de las facturas
 * @param Pv_SaldoPendientePago         IN VARCHAR2 Recibe 'S' si se desea filtrar sólo a los clientes con saldo pendiente de pago
 * @param Pf_ValorSaldoPendientePago    IN FLOAT Recibe el valor mínimo para comparar el saldo pendiente de un cliente
 * @param Pn_IdPlantilla                IN VARCHAR2 Recibe el id de la plantilla que se desea enviar
 * @param Pv_IdsTipoContacto            IN VARCHAR2 Recibe los ids de los tipos de contacto del punto a los que se enviará la plantilla
 * @param Pv_Asunto                     IN VARCHAR2 Recibe el asunto del envío de la plantilla
 * @param Pv_TipoEnvio                  IN VARCHAR2 Recibe el tipo de envío que se realizará: inmediato, programado, recurrente
 * @param Pv_FechaHoraProgramada        IN VARCHAR2 Recibe la fecha y hora cuando el envío es programado
 * @param Pv_FechaEjecucionDesde        IN VARCHAR2 Recibe la fecha desde la que se empezará a ejecutar un envío recurrente
 * @param Pv_HoraEjecucion              IN VARCHAR2 Recibe la hora en la que se ejecutará el envío recurrente
 * @param Pv_Periodicidad               IN VARCHAR2 Recibe la periodicidad: Diaria, Mensual, Anual
 * @param Pn_NumeroDia                  IN NUMBER Recibe el día del mes en que se ejecutará un envío recurrente mensual
 * @param Pv_UsrCreacion                IN VARCHAR2 Recibe el usuario de creación
 * @param Pv_IpCreacion                 IN VARCHAR2 Recibe la IP de creación
 * @param Pv_MsnError                   OUT VARCHAR2 Devuelve el mensaje de error
 */
PROCEDURE P_CREA_JOB_NOTIF_MASIVA(  
                                    Pv_InfoFiltros                IN VARCHAR2,
                                    Pv_Grupo                      IN VARCHAR2,
                                    Pv_Subgrupo                   IN VARCHAR2, 
                                    Pn_IdElementoNodo             IN VARCHAR2, 
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
                                    Pv_IdFormaPago                IN VARCHAR2, 
                                    Pv_NombreFormaPago            IN VARCHAR2,
                                    Pv_IdsBancosTarjetas          IN VARCHAR2,
                                    Pv_FechaDesdeFactura          IN VARCHAR2,
                                    Pv_FechaHastaFactura          IN VARCHAR2,
                                    Pv_SaldoPendientePago         IN VARCHAR2,
                                    Pf_ValorSaldoPendientePago    IN FLOAT,
                                    Pn_IdPlantilla                IN NUMBER,
                                    Pv_IdsTipoContacto            IN VARCHAR2,
                                    Pv_Asunto                     IN VARCHAR2,
                                    Pv_TipoEnvio                  IN VARCHAR2,
                                    Pv_FechaHoraProgramada        IN VARCHAR2,
                                    Pv_FechaEjecucionDesde        IN VARCHAR2,
                                    Pv_HoraEjecucion              IN VARCHAR2,
                                    Pv_Periodicidad               IN VARCHAR2,
                                    Pn_NumeroDia                  IN NUMBER,
                                    Pv_UsrCreacion                IN VARCHAR2,
                                    Pv_IpCreacion                 IN VARCHAR2,
                                    Pv_MsnError                   OUT VARCHAR2);

/**
 * Documentación para P_CREA_JOB
 * Procedimiento que realiza la configuración y creación de un envío masivo
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 14/09/2017
 * 
 * @param Pn_IdNotifMasiva      IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE Recibe el id de la notificación masiva que se desea enviar
 * @param Pv_NombreJob          IN DB_COMUNICACION.INFO_NOTIF_MASIVA.NOMBRE_JOB%TYPE Recibe el nombre del job que se desea crear para el envío masivo
 * @param Pt_FechaStartJob      IN TIMESTAMP Fecha y hora en la que se empezará con la ejecución del job
 * @param Pv_RepeatInterval     IN VARCHAR2 Recibe la configuración del intervalo que ejecutará el job
 * @param Pv_MsnError           OUT VARCHAR2 Devuelve el mensaje de error
 */
PROCEDURE P_CREA_JOB(
                        Pn_IdNotifMasiva    IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE,
                        Pv_NombreJob        IN DB_COMUNICACION.INFO_NOTIF_MASIVA.NOMBRE_JOB%TYPE, 
                        Pt_FechaStartJob    IN TIMESTAMP, 
                        Pv_RepeatInterval   IN VARCHAR2,
                        Pv_MsnError         OUT VARCHAR2);       

/**
 * Documentación para P_ELIMINA_JOB_NOTIF_MASIVA
 * Procedimiento que realiza la eliminación del envío masivo
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 28/09/2017
 * 
 * @param Pn_IdNotifMasiva      IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE Recibe el id de la notificación masiva que se desea enviar
 * @param Pv_Observacion        IN VARCHAR2 Observación del historial
 * @param Pv_UsrCreacion        IN VARCHAR2 Usuario de Creación
 * @param Pv_MsnError           OUT VARCHAR2 Devuelve el mensaje de error
 */
PROCEDURE P_ELIMINA_JOB_NOTIF_MASIVA(
                                    Pn_IdNotifMasiva    IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE,
                                    Pv_Observacion      IN VARCHAR2,
                                    Pv_UsrCreacion      IN VARCHAR2,
                                    Pv_MsnError         OUT VARCHAR2);


/**
 * Documentación para P_ELIMINA_JOB
 * Procedimiento que realiza la eliminación del job del envío masivo
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 28/09/2017
 * 
 * @param Pv_NombreJob      IN VARCHAR2 Recibe el nombre del job
 * @param Pv_MsnError       OUT VARCHAR2 Devuelve el mensaje de error
 */
PROCEDURE P_ELIMINA_JOB(
                        Pv_NombreJob    IN DB_COMUNICACION.INFO_NOTIF_MASIVA.NOMBRE_JOB%TYPE,
                        Pv_MsnError     OUT VARCHAR2);

/**
 * Documentación para P_ELIMINA_ENVIO_MASIVO_AUT
 * Procedimiento que realiza la eliminación automática de los jobs del envío masivo
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 28/09/2017
 */
PROCEDURE P_ELIMINA_ENVIO_MASIVO_AUT;

/**
 * Documentación para P_ACTUALIZA_AUDIT_ELEMENTOS
 * Procedimiento que realiza la actualización automática del estado de 'En Proceso' a 'Pendiente' de la evaluación de imágenes de elementos 
 * luego de 1 día de permanecer en estado 'En Proceso' para que pueda ser evaluada nuevamente
 * 
 * @author Lizbeth Cruz <mlcruz@telconet.ec>
 * @version 1.0 09/11/2017
 */
PROCEDURE P_ACTUALIZA_AUDIT_ELEMENTOS;

    /**
   * Documentacion para P_ENVIA_CTA_CORREO_GENERADO
   * Procedimiento que gestiona el envio de mail con las credenciales y cuenta de correo creada
   *
   * @author Sofia Fernandez <sfernandez@telconet.ec>
   * @version 1.0 06/03/2018
   *
   * @param Pv_Login         IN VARCHAR2,
   * @param Pv_Password      IN VARCHAR2,
   * @param Pv_Correo        IN VARCHAR2,
   * @param Pn_PersonaId     IN VARCHAR2,
   * @param Pv_PrefijoEmpresa IN VARCHAR2
   * @param Pv_MensajeError OUT VARCHAR2  
   */

    PROCEDURE P_ENVIA_CTA_CORREO_GENERADO(Pv_Login          IN VARCHAR2,
                                          Pv_Password       IN VARCHAR2,
                                          Pv_Correo         IN VARCHAR2 ,
                                          Pn_PersonaId      IN NUMBER,
                                          Pv_PrefijoEmpresa IN VARCHAR2,
                                          Pv_MensajeError  OUT VARCHAR2);  


END CUKG_TRANSACTIONS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMUNICACION.CUKG_TRANSACTIONS AS

PROCEDURE P_INSERT_INFO_NOTIF_MASIVA( Pr_InfoNotifMasiva  IN  DB_COMUNICACION.INFO_NOTIF_MASIVA%ROWTYPE,
                                      Pv_MsnError         OUT VARCHAR2)
IS
BEGIN

  INSERT
  INTO
    DB_COMUNICACION.INFO_NOTIF_MASIVA
    (
      ID_NOTIF_MASIVA,
      PLANTILLA_ID,
      NOMBRE_JOB,
      ASUNTO,
      TIPO,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      Pr_InfoNotifMasiva.ID_NOTIF_MASIVA,
      Pr_InfoNotifMasiva.PLANTILLA_ID,
      Pr_InfoNotifMasiva.NOMBRE_JOB,
      Pr_InfoNotifMasiva.ASUNTO,
      Pr_InfoNotifMasiva.TIPO,
      Pr_InfoNotifMasiva.ESTADO,
      Pr_InfoNotifMasiva.USR_CREACION,
      Pr_InfoNotifMasiva.FE_CREACION,
      Pr_InfoNotifMasiva.IP_CREACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIVA', 
                                        'Error al insertar el registro' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_INSERT_INFO_NOTIF_MASIVA;

PROCEDURE P_INSERT_INFO_NOTIF_MASIVA_PAR(   Pr_InfoNotifMasivaParam IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM%ROWTYPE,
                                            Pv_MsnError             OUT VARCHAR2)
IS
BEGIN

  INSERT
  INTO
    DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM
    (
      ID_NOTIF_MASIVA_PARAM,
      NOTIF_MASIVA_ID,
      TIPO,
      NOMBRE,
      VALOR,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      Pr_InfoNotifMasivaParam.ID_NOTIF_MASIVA_PARAM,
      Pr_InfoNotifMasivaParam.NOTIF_MASIVA_ID,
      Pr_InfoNotifMasivaParam.TIPO,
      Pr_InfoNotifMasivaParam.NOMBRE,
      Pr_InfoNotifMasivaParam.VALOR,
      Pr_InfoNotifMasivaParam.ESTADO,
      Pr_InfoNotifMasivaParam.USR_CREACION,
      Pr_InfoNotifMasivaParam.FE_CREACION,
      Pr_InfoNotifMasivaParam.IP_CREACION
    );

EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIVA_PAR', 
                                        'Error al insertar el registro' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_INSERT_INFO_NOTIF_MASIVA_PAR;


PROCEDURE P_INSERT_INFO_NOTIF_MASIV_HIST(   Pr_InfoNotifMasivaHist  IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_HIST%ROWTYPE,
                                            Pv_MsnError             OUT VARCHAR2)
IS
BEGIN

  INSERT
  INTO
    DB_COMUNICACION.INFO_NOTIF_MASIVA_HIST
    (
      ID_NOTIF_MASIVA_HIST,
      NOTIF_MASIVA_ID,
      OBSERVACION,
      ACCION,
      ESTADO_ENVIO_MASIVO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      Pr_InfoNotifMasivaHist.ID_NOTIF_MASIVA_HIST,
      Pr_InfoNotifMasivaHist.NOTIF_MASIVA_ID,
      Pr_InfoNotifMasivaHist.OBSERVACION,
      Pr_InfoNotifMasivaHist.ACCION,
      Pr_InfoNotifMasivaHist.ESTADO_ENVIO_MASIVO,
      Pr_InfoNotifMasivaHist.USR_CREACION,
      Pr_InfoNotifMasivaHist.FE_CREACION,
      Pr_InfoNotifMasivaHist.IP_CREACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIV_HIST', 
                                        'Error al insertar el registro' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_INSERT_INFO_NOTIF_MASIV_HIST;


PROCEDURE P_INSERT_INFO_NOTIF_MASIVA_LOG(   Pr_InfoNotifMasivaLog   IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG%ROWTYPE,
                                            Pv_MsnError             OUT VARCHAR2)
IS
BEGIN

  INSERT
  INTO
    DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG
    (
      ID_NOTIF_MASIVA_LOG,
      NOTIF_MASIVA_ID,
      NUM_ENVIADOS,
      NUM_PROCESADOS,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      Pr_InfoNotifMasivaLog.ID_NOTIF_MASIVA_LOG,
      Pr_InfoNotifMasivaLog.NOTIF_MASIVA_ID,
      Pr_InfoNotifMasivaLog.NUM_ENVIADOS,
      Pr_InfoNotifMasivaLog.NUM_PROCESADOS,
      Pr_InfoNotifMasivaLog.ESTADO,
      Pr_InfoNotifMasivaLog.USR_CREACION,
      Pr_InfoNotifMasivaLog.FE_CREACION,
      Pr_InfoNotifMasivaLog.IP_CREACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIVA_LOG', 
                                        'Error al insertar el registro' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_INSERT_INFO_NOTIF_MASIVA_LOG;


PROCEDURE P_INSERT_INFO_NOTIF_M_LOG_DET(  Pr_InfoNotifMasivaLogDet    IN  DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG_DET%ROWTYPE,
                                          Pv_MsnError                 OUT VARCHAR2)
IS
BEGIN

  INSERT
  INTO
    DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG_DET
    (
      ID_NOTIF_MASIVA_LOG_DET,
      NOTIF_MASIVA_LOG_ID,
      NOMBRES,
      CORREO,
      TIPO_CONTACTO,
      LOGIN,
      ESTADO,
      OBSERVACION,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION
    )
    VALUES
    (
      Pr_InfoNotifMasivaLogDet.ID_NOTIF_MASIVA_LOG_DET,
      Pr_InfoNotifMasivaLogDet.NOTIF_MASIVA_LOG_ID,
      Pr_InfoNotifMasivaLogDet.NOMBRES,
      Pr_InfoNotifMasivaLogDet.CORREO,
      Pr_InfoNotifMasivaLogDet.TIPO_CONTACTO,
      Pr_InfoNotifMasivaLogDet.LOGIN,
      Pr_InfoNotifMasivaLogDet.ESTADO,
      Pr_InfoNotifMasivaLogDet.OBSERVACION,
      Pr_InfoNotifMasivaLogDet.USR_CREACION,
      Pr_InfoNotifMasivaLogDet.FE_CREACION,
      Pr_InfoNotifMasivaLogDet.IP_CREACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_M_LOG_DET', 
                                        'Error al insertar el registro' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_INSERT_INFO_NOTIF_M_LOG_DET;

PROCEDURE P_SEND_MAIL(
    Pv_From         IN  VARCHAR2,
    Pv_To           IN  VARCHAR2,
    Pv_Subject      IN  VARCHAR2,
    Pv_Message      IN  VARCHAR2,
    Pv_MimeType     IN  VARCHAR2,
    Pv_MsnError     OUT VARCHAR2)
IS
  --
BEGIN
  --
  UTL_MAIL.SEND (   SENDER      => Pv_From, 
                    RECIPIENTS  => Pv_To, 
                    SUBJECT     => Pv_Subject,
                    MESSAGE     => Pv_Message, 
                    MIME_TYPE   => Pv_MimeType );
  --
EXCEPTION
WHEN OTHERS THEN
  --
  Pv_MsnError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
END P_SEND_MAIL;

PROCEDURE P_ENVIO_NOTIF_MASIVA( Pn_IdNotifMasiva    IN  DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE,
                                Pv_MsnError         OUT VARCHAR2)
IS
  Lv_UsrCreacion VARCHAR2(15) := 'envio_masivo_tn';
  Lv_Grupo VARCHAR2(50);
  Lv_Subgrupo VARCHAR2(50);
  Ln_IdElementoNodo NUMBER;
  Ln_IdElementoSwitch NUMBER;
  Lv_EstadoServicio VARCHAR2(30);
  Lv_EstadoPunto VARCHAR2(30);
  Lv_EstadoCliente VARCHAR2(30);
  Lv_ClientesVIP VARCHAR2(1);
  Lv_UsrCreacionFactura VARCHAR2(20);
  Ln_NumFacturasAbiertas NUMBER;
  Lv_PuntosFacturacion VARCHAR2(1);
  Lv_IdsTiposNegocio VARCHAR2(300);
  Lv_IdsOficinas VARCHAR2(300);
  Ln_IdFormaPago NUMBER;
  Lv_NombreFormaPago VARCHAR2(60);
  Lv_IdsBancosTarjetas VARCHAR2(300);
  Lv_FechaDesdeFactura VARCHAR2(10);
  Lv_FechaHastaFactura VARCHAR2(10);
  Lv_SaldoPendientePago VARCHAR2(1);
  Lf_ValorSaldoPendientePago FLOAT;
  Lv_IdsTiposContactos VARCHAR2(300);
  Ln_TotalRegistros NUMBER := 0;
  Ln_IndxEnvioMasivoDest NUMBER;
  Lcl_ContenidoPlantilla CLOB;
  Le_Exception EXCEPTION;
  Ln_ContEnviados NUMBER := 0;
  Ln_ContNoEnviados NUMBER := 0;
  Ln_ContProcesados NUMBER := 0;

  Lrf_GetParamsNotifMasiva SYS_REFCURSOR;
  Lr_GetParamNotifMasiva DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM%ROWTYPE;
  Lt_ArrayParamsBusq DB_COMUNICACION.CUKG_TYPES.Lt_ArrayAsociativo;

  Lv_VariablesNotificacion VARCHAR2(300);
  Lrf_ParamsVars SYS_REFCURSOR;
  Lr_GetParamsVars DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;

  Lrf_NotifMasivaPlantilla SYS_REFCURSOR;
  Lr_GetNotifMasivaPlantilla DB_COMUNICACION.CUKG_TYPES.Lr_NotifEnvioMasivoPlantilla;
  Ln_InstrParamVar PLS_INTEGER;
  Lr_GetAliasPlantilla DB_COMUNICACION.CUKG_TYPES.Lr_AliasPlantilla;

  Lrf_EnvioMasivoDestinatarios SYS_REFCURSOR;
  Lt_EnvioMasivoDestinatarios DB_COMUNICACION.CUKG_TYPES.Lt_EnvioMasivo;
  Lr_EnvioMasivoDestinatarios DB_COMUNICACION.CUKG_TYPES.Lr_EnvioMasivo;

  Lr_InfoNotifMasivaHist DB_COMUNICACION.INFO_NOTIF_MASIVA_HIST%ROWTYPE;
  Lr_InfoNotifMasivaLog DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG%ROWTYPE;
  Lr_InfoNotifMasivaLogDet DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG_DET%ROWTYPE;
  Lv_EstadoEnvio VARCHAR2(15);
  Lv_MensajeErrorEnvio VARCHAR2(4000);
  Lv_Remitente VARCHAR2(50) := 'notificaciones_envio_tn@telconet.ec';
  CURSOR C_GetParamIdsTiposContacto(Cn_IdNotifMasiva DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM.NOTIF_MASIVA_ID%TYPE)
    IS
      SELECT INMP.VALOR
      FROM DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM INMP 
      WHERE INMP.NOTIF_MASIVA_ID = Cn_IdNotifMasiva
      AND INMP.NOMBRE = 'idsTipoContacto'
      AND INMP.TIPO = 'ENVIO' 
      AND INMP.ESTADO = 'Activo';
    --
  Lr_GetParamIdsTiposContacto C_GetParamIdsTiposContacto%ROWTYPE;

BEGIN
  Lrf_GetParamsNotifMasiva  := NULL;
  Lrf_GetParamsNotifMasiva  := DB_COMUNICACION.CUKG_CONSULTS.F_GET_PARAMS_NOTIF_MASIVA( Pn_IdNotifMasiva, 'BUSQUEDA', 'Activo');

  LOOP
    --
    FETCH
      Lrf_GetParamsNotifMasiva
    INTO
      Lr_GetParamNotifMasiva;
    --
    EXIT
      WHEN Lrf_GetParamsNotifMasiva%NOTFOUND;
      Lt_ArrayParamsBusq(Lr_GetParamNotifMasiva.NOMBRE)  := Lr_GetParamNotifMasiva.VALOR;
  END LOOP;
  CLOSE Lrf_GetParamsNotifMasiva;

  IF ( Lt_ArrayParamsBusq.EXISTS('grupo') AND Lt_ArrayParamsBusq('grupo') IS NOT NULL) THEN
    Lv_Grupo := Lt_ArrayParamsBusq('grupo');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('subgrupo') AND Lt_ArrayParamsBusq('subgrupo') IS NOT NULL) THEN
    Lv_Subgrupo := Lt_ArrayParamsBusq('subgrupo');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('idElementoNodo') AND Lt_ArrayParamsBusq('idElementoNodo') IS NOT NULL) THEN
    Ln_IdElementoNodo := Lt_ArrayParamsBusq('idElementoNodo');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('idElementoSwitch') AND Lt_ArrayParamsBusq('idElementoSwitch') IS NOT NULL) THEN
    Ln_IdElementoSwitch := Lt_ArrayParamsBusq('idElementoSwitch');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('estadoServicio') AND Lt_ArrayParamsBusq('estadoServicio') IS NOT NULL) THEN
    Lv_EstadoServicio := Lt_ArrayParamsBusq('estadoServicio');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('estadoPunto') AND Lt_ArrayParamsBusq('estadoPunto') IS NOT NULL) THEN
    Lv_EstadoPunto := Lt_ArrayParamsBusq('estadoPunto');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('estadoCliente') AND Lt_ArrayParamsBusq('estadoCliente') IS NOT NULL) THEN
    Lv_EstadoCliente := Lt_ArrayParamsBusq('estadoCliente');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('clientesVIP') AND Lt_ArrayParamsBusq('clientesVIP') IS NOT NULL) THEN
    Lv_ClientesVIP := Lt_ArrayParamsBusq('clientesVIP');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('usrCreacionFactura') AND Lt_ArrayParamsBusq('usrCreacionFactura') IS NOT NULL) THEN
    Lv_UsrCreacionFactura := Lt_ArrayParamsBusq('usrCreacionFactura');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('numFacturasAbiertas') AND Lt_ArrayParamsBusq('numFacturasAbiertas') IS NOT NULL) THEN
    Ln_NumFacturasAbiertas := Lt_ArrayParamsBusq('numFacturasAbiertas');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('puntosFacturacion') AND Lt_ArrayParamsBusq('puntosFacturacion') IS NOT NULL) THEN
    Lv_PuntosFacturacion := Lt_ArrayParamsBusq('puntosFacturacion');
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('idsTiposNegocio') AND Lt_ArrayParamsBusq('idsTiposNegocio') IS NOT NULL) THEN
    Lv_IdsTiposNegocio := Lt_ArrayParamsBusq('idsTiposNegocio') ;
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('idsOficinas') AND Lt_ArrayParamsBusq('idsOficinas') IS NOT NULL) THEN
    Lv_IdsOficinas := Lt_ArrayParamsBusq('idsOficinas') ;
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('idFormaPago') AND Lt_ArrayParamsBusq('idFormaPago') IS NOT NULL) THEN
    Ln_IdFormaPago := Lt_ArrayParamsBusq('idFormaPago') ;
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('nombreFormaPago') AND Lt_ArrayParamsBusq('nombreFormaPago') IS NOT NULL) THEN
    Lv_NombreFormaPago := Lt_ArrayParamsBusq('nombreFormaPago') ;
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('idsBancosTarjetas') AND Lt_ArrayParamsBusq('idsBancosTarjetas') IS NOT NULL) THEN
    Lv_IdsBancosTarjetas := Lt_ArrayParamsBusq('idsBancosTarjetas') ;
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('fechaDesdeFactura') AND Lt_ArrayParamsBusq('fechaDesdeFactura') IS NOT NULL) THEN
    Lv_FechaDesdeFactura := Lt_ArrayParamsBusq('fechaDesdeFactura') ;
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('fechaHastaFactura') AND Lt_ArrayParamsBusq('fechaHastaFactura') IS NOT NULL) THEN
    Lv_FechaHastaFactura := Lt_ArrayParamsBusq('fechaHastaFactura') ;
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('saldoPendientePago') AND Lt_ArrayParamsBusq('saldoPendientePago') IS NOT NULL) THEN
    Lv_SaldoPendientePago := Lt_ArrayParamsBusq('saldoPendientePago') ;
  END IF;

  IF ( Lt_ArrayParamsBusq.EXISTS('valorSaldoPendientePago') AND Lt_ArrayParamsBusq('valorSaldoPendientePago') IS NOT NULL) THEN
    Lf_ValorSaldoPendientePago := Lt_ArrayParamsBusq('valorSaldoPendientePago') ;
  END IF;


  OPEN C_GetParamIdsTiposContacto(Pn_IdNotifMasiva);
  --
  FETCH C_GetParamIdsTiposContacto INTO Lr_GetParamIdsTiposContacto;
  --
  CLOSE C_GetParamIdsTiposContacto;

  IF Lr_GetParamIdsTiposContacto.VALOR IS NOT NULL THEN
      --
    Lv_IdsTiposContactos := Lr_GetParamIdsTiposContacto.VALOR;
  END IF;

  Lrf_NotifMasivaPlantilla := NULL;
  Lrf_NotifMasivaPlantilla := DB_COMUNICACION.CUKG_CONSULTS.F_GET_PLANTILLA_NOTIF_MASIVA(Pn_IdNotifMasiva);
  FETCH Lrf_NotifMasivaPlantilla INTO Lr_GetNotifMasivaPlantilla;

  Lr_GetAliasPlantilla := DB_COMUNICACION.CUKG_CONSULTS.F_GET_ALIAS_PLANTILLA(Lr_GetNotifMasivaPlantilla.CODIGO);

  Lrf_ParamsVars  := NULL;
  Lrf_ParamsVars  := DB_GENERAL.GNRLPCK_UTIL.F_GET_PARAMS_DETS( 'VARIABLES_NOTIFICACION_ENVIO_MASIVO' );

  LOOP
    --
    FETCH
      Lrf_ParamsVars
    INTO
      Lr_GetParamsVars;
    --
    EXIT
      WHEN Lrf_ParamsVars%NOTFOUND;
      Ln_InstrParamVar := DB_COMUNICACION.CUKG_UTILS.F_CLOB_INSTR(Lr_GetNotifMasivaPlantilla.PLANTILLA, '{{ ' || Lr_GetParamsVars.VALOR1 || ' }}' );
      IF Ln_InstrParamVar > 0 THEN
        Lv_VariablesNotificacion := Lv_VariablesNotificacion || Lr_GetParamsVars.VALOR1 || ',';
      END IF;
  END LOOP;

  IF TRIM(Lv_VariablesNotificacion) IS NOT NULL THEN
    Lv_VariablesNotificacion := TRIM(TRAILING ',' FROM Lv_VariablesNotificacion );
  END IF;

  Lr_InfoNotifMasivaLog                       := NULL;
  Lr_InfoNotifMasivaLog.ID_NOTIF_MASIVA_LOG   := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_LOG.NEXTVAL;
  Lr_InfoNotifMasivaLog.NOTIF_MASIVA_ID       := Pn_IdNotifMasiva;
  Lr_InfoNotifMasivaLog.NUM_ENVIADOS          := 0;
  Lr_InfoNotifMasivaLog.NUM_PROCESADOS        := 0;
  Lr_InfoNotifMasivaLog.ESTADO                := 'Pendiente';
  Lr_InfoNotifMasivaLog.USR_CREACION          := Lv_UsrCreacion;
  Lr_InfoNotifMasivaLog.FE_CREACION           := SYSDATE;
  Lr_InfoNotifMasivaLog.IP_CREACION           := '127.0.0.1';

  DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIVA_LOG(Lr_InfoNotifMasivaLog, Pv_MsnError);


  Lrf_EnvioMasivoDestinatarios := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_SERVICIOS_NOTIF_MASIVA('S',
                                                                                            NULL,
                                                                                            NULL,
                                                                                            Lv_Grupo,
                                                                                            Lv_Subgrupo, 
                                                                                            Ln_IdElementoNodo, 
                                                                                            Ln_IdElementoSwitch, 
                                                                                            Lv_EstadoServicio,
                                                                                            Lv_EstadoPunto,
                                                                                            Lv_EstadoCliente,
                                                                                            Lv_ClientesVIP, 
                                                                                            Lv_UsrCreacionFactura,
                                                                                            Ln_NumFacturasAbiertas, 
                                                                                            Lv_PuntosFacturacion, 
                                                                                            Lv_IdsTiposNegocio, 
                                                                                            Lv_IdsOficinas, 
                                                                                            Ln_IdFormaPago, 
                                                                                            Lv_NombreFormaPago,
                                                                                            Lv_IdsBancosTarjetas,
                                                                                            Lv_FechaDesdeFactura,
                                                                                            Lv_FechaHastaFactura,
                                                                                            Lv_SaldoPendientePago,
                                                                                            Lf_ValorSaldoPendientePago,
                                                                                            Lv_IdsTiposContactos,
                                                                                            Lv_VariablesNotificacion,
                                                                                            Ln_TotalRegistros           );
  LOOP
    IF TRIM(Pv_MsnError) IS NOT NULL THEN
      Pv_MsnError := Pv_MsnError || ' - Error al insertar el registro de ejecución del envío masivo';
      RAISE Le_Exception;
    END IF;
    FETCH Lrf_EnvioMasivoDestinatarios BULK COLLECT INTO Lt_EnvioMasivoDestinatarios LIMIT 500;
    EXIT WHEN Lt_EnvioMasivoDestinatarios.COUNT = 0; 


    FOR Ln_IndxEnvioMasivoDest IN 1 .. Lt_EnvioMasivoDestinatarios.COUNT 
    LOOP
      Lr_EnvioMasivoDestinatarios := Lt_EnvioMasivoDestinatarios(Ln_IndxEnvioMasivoDest);
      Lcl_ContenidoPlantilla := DB_COMUNICACION.CUKG_UTILS.F_CLOB_REPLACE_VARS( Lr_EnvioMasivoDestinatarios,
                                                                                Lr_GetNotifMasivaPlantilla.PLANTILLA,
                                                                                Lv_VariablesNotificacion
                                                                             );


      Lv_MensajeErrorEnvio := '';
      Lv_EstadoEnvio := 'Procesado';
      Ln_ContProcesados := Ln_ContProcesados +1;
      BEGIN
        DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL(  Lv_Remitente, 
                                                        Lr_EnvioMasivoDestinatarios.CORREO,
                                                        Lr_GetNotifMasivaPlantilla.ASUNTO,
                                                        SUBSTR(Lcl_ContenidoPlantilla, 1, 32767), 
                                                        'text/html; charset=UTF-8',
                                                        Lv_MensajeErrorEnvio);
        IF TRIM(Lv_MensajeErrorEnvio) IS NOT NULL THEN
          Lv_EstadoEnvio    := 'No Enviado';
          Ln_ContNoEnviados := Ln_ContNoEnviados+1;
        ELSE
          Lv_EstadoEnvio    := 'Enviado';
          Ln_ContEnviados   := Ln_ContEnviados +1;
        END IF;
      EXCEPTION
      WHEN OTHERS THEN
          Lv_EstadoEnvio    := 'No Enviado';
      END;
      IF Lr_GetAliasPlantilla.ALIAS_CORREOS IS NOT NULL THEN
        BEGIN
          DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL(Lv_Remitente, 
                                                        Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                        Lr_GetNotifMasivaPlantilla.ASUNTO,
                                                        SUBSTR(Lcl_ContenidoPlantilla, 1, 32767), 
                                                        'text/html; charset=UTF-8',
                                                        Lv_MensajeErrorEnvio);
        EXCEPTION
        WHEN OTHERS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 
                                                'CUKG_TRANSACTIONS.P_ENVIO_NOTIF_MASIVA', 
                                                'ERROR AL ENVIAR CORREO AL ALIAS' || Lr_GetAliasPlantilla.ALIAS_CORREOS || ' - ' 
                                                || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion),
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        END;
      END IF;

      Lr_InfoNotifMasivaLogDet                          := NULL;
      Lr_InfoNotifMasivaLogDet.ID_NOTIF_MASIVA_LOG_DET  := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_LOG_DET.NEXTVAL;
      Lr_InfoNotifMasivaLogDet.NOTIF_MASIVA_LOG_ID      := Lr_InfoNotifMasivaLog.ID_NOTIF_MASIVA_LOG;
      Lr_InfoNotifMasivaLogDet.NOMBRES                  := Lr_EnvioMasivoDestinatarios.NOMBRES_CONTACTO;
      Lr_InfoNotifMasivaLogDet.CORREO                   := Lr_EnvioMasivoDestinatarios.CORREO;
      Lr_InfoNotifMasivaLogDet.TIPO_CONTACTO            := Lr_EnvioMasivoDestinatarios.TIPO_CONTACTO;
      Lr_InfoNotifMasivaLogDet.LOGIN                    := Lr_EnvioMasivoDestinatarios.LOGIN;
      Lr_InfoNotifMasivaLogDet.ESTADO                   := Lv_EstadoEnvio;
      Lr_InfoNotifMasivaLogDet.OBSERVACION              := Lv_MensajeErrorEnvio;
      Lr_InfoNotifMasivaLogDet.USR_CREACION             := Lv_UsrCreacion;
      Lr_InfoNotifMasivaLogDet.FE_CREACION              := SYSDATE; 
      Lr_InfoNotifMasivaLogDet.IP_CREACION              := '127.0.0.1';

      DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_M_LOG_DET(Lr_InfoNotifMasivaLogDet, Pv_MsnError);

      IF TRIM(Pv_MsnError) IS NOT NULL THEN
        Pv_MsnError := Pv_MsnError || ' - Error al insertar el registro del detalle de la ejecución del envío masivo';
        RAISE Le_Exception;
      END IF;

      COMMIT;
    END LOOP;
  END LOOP;
  CLOSE Lrf_EnvioMasivoDestinatarios;
  UPDATE DB_COMUNICACION.INFO_NOTIF_MASIVA_LOG 
  SET NUM_ENVIADOS = Ln_ContEnviados, 
      NUM_NO_ENVIADOS = Ln_ContNoEnviados,
      NUM_PROCESADOS = Ln_ContProcesados, 
      ESTADO = 'Ejecutado'
  WHERE ID_NOTIF_MASIVA_LOG = Lr_InfoNotifMasivaLog.ID_NOTIF_MASIVA_LOG;

  IF Lr_GetNotifMasivaPlantilla.TIPO = 'INMEDIATO' OR Lr_GetNotifMasivaPlantilla.TIPO = 'PROGRAMADO' THEN
    UPDATE DB_COMUNICACION.INFO_NOTIF_MASIVA
    SET ESTADO = 'Finalizado'
    WHERE ID_NOTIF_MASIVA = Pn_IdNotifMasiva;

    Lr_InfoNotifMasivaHist                        := NULL;
    Lr_InfoNotifMasivaHist.ID_NOTIF_MASIVA_HIST   := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_HIST.NEXTVAL;
    Lr_InfoNotifMasivaHist.NOTIF_MASIVA_ID        := Pn_IdNotifMasiva;
    Lr_InfoNotifMasivaHist.OBSERVACION            := 'Se finaliza el Job del envio masivo ' || 'JOB_NOTIF_' || Pn_IdNotifMasiva;
    Lr_InfoNotifMasivaHist.ACCION                 := 'finalizar';
    Lr_InfoNotifMasivaHist.ESTADO_ENVIO_MASIVO    := 'Finalizado';
    Lr_InfoNotifMasivaHist.USR_CREACION           := Lv_UsrCreacion;
    Lr_InfoNotifMasivaHist.FE_CREACION            := SYSDATE;
    Lr_InfoNotifMasivaHist.IP_CREACION            := '127.0.0.1';

    DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIV_HIST(Lr_InfoNotifMasivaHist, Pv_MsnError);

    IF TRIM(Pv_MsnError) IS NOT NULL THEN
      Pv_MsnError := Pv_MsnError || ' - Error al insertar el registro del historial del envío masivo';
      RAISE Le_Exception;
    END IF;

  END IF;

  COMMIT;
  --
EXCEPTION
WHEN Le_Exception THEN
  --
  ROLLBACK;
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_ENVIO_NOTIF_MASIVA', 
                                        Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_ENVIO_NOTIF_MASIVA', 
                                        'Error al insertar el registro' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_ENVIO_NOTIF_MASIVA;

PROCEDURE P_CREA_JOB_NOTIF_MASIVA(
                                    Pv_InfoFiltros                IN VARCHAR2,
                                    Pv_Grupo                      IN VARCHAR2,
                                    Pv_Subgrupo                   IN VARCHAR2, 
                                    Pn_IdElementoNodo             IN VARCHAR2, 
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
                                    Pv_IdFormaPago                IN VARCHAR2, 
                                    Pv_NombreFormaPago            IN VARCHAR2,
                                    Pv_IdsBancosTarjetas          IN VARCHAR2,
                                    Pv_FechaDesdeFactura          IN VARCHAR2,
                                    Pv_FechaHastaFactura          IN VARCHAR2,
                                    Pv_SaldoPendientePago         IN VARCHAR2,
                                    Pf_ValorSaldoPendientePago    IN FLOAT,
                                    Pn_IdPlantilla                IN NUMBER,
                                    Pv_IdsTipoContacto            IN VARCHAR2,
                                    Pv_Asunto                     IN VARCHAR2,
                                    Pv_TipoEnvio                  IN VARCHAR2,
                                    Pv_FechaHoraProgramada        IN VARCHAR2,
                                    Pv_FechaEjecucionDesde        IN VARCHAR2,
                                    Pv_HoraEjecucion              IN VARCHAR2,
                                    Pv_Periodicidad               IN VARCHAR2,
                                    Pn_NumeroDia                  IN NUMBER,
                                    Pv_UsrCreacion                IN VARCHAR2,
                                    Pv_IpCreacion                 IN VARCHAR2,
                                    Pv_MsnError                   OUT VARCHAR2)
IS
  Lr_InfoNotifMasiva DB_COMUNICACION.INFO_NOTIF_MASIVA%ROWTYPE;
  Lr_InfoNotifMasivaHist DB_COMUNICACION.INFO_NOTIF_MASIVA_HIST%ROWTYPE;
  Lr_InfoNotifMasivaParam DB_COMUNICACION.INFO_NOTIF_MASIVA_PARAM%ROWTYPE;
  Lr_ArrayParamsBusq DB_COMUNICACION.CUKG_TYPES.Lt_ArrayAsociativo;
  Lr_ArrayParamsEnvio DB_COMUNICACION.CUKG_TYPES.Lt_ArrayAsociativo;
  Lv_IndexParamsBusq VARCHAR2(30);
  Lv_IndexParamsEnvio VARCHAR2(30);
  Lv_RepeatInterval VARCHAR2(100);
  Lv_HoraRecurrente VARCHAR2(2);
  Lv_MinsRecurrente VARCHAR2(2);
  Lt_FechaStartJob TIMESTAMP(6);
  Ln_PlsIntHoraMin PLS_INTEGER;
  Ln_ContJob NUMBER := 0;
  Le_Exception EXCEPTION;
  Lv_Asunto VARCHAR2(78) := '';
  Lv_InfoFiltros VARCHAR2(4000);
BEGIN

  SELECT UNISTR(replace(replace(Pv_Asunto,'\u','\'),'"',''))  INTO Lv_Asunto
  FROM DUAL;

  SELECT UNISTR(replace(replace(Pv_InfoFiltros,'\u','\'),'"',''))  INTO Lv_InfoFiltros
  FROM DUAL;

  Lr_InfoNotifMasiva                    := NULL;
  Lr_InfoNotifMasiva.ID_NOTIF_MASIVA    := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA.NEXTVAL;
  Lr_InfoNotifMasiva.PLANTILLA_ID       := Pn_IdPlantilla;
  Lr_InfoNotifMasiva.NOMBRE_JOB         := 'JOB_NOTIF_' || Lr_InfoNotifMasiva.ID_NOTIF_MASIVA;
  Lr_InfoNotifMasiva.ASUNTO             := Lv_Asunto;
  Lr_InfoNotifMasiva.TIPO               := Pv_TipoEnvio;
  Lr_InfoNotifMasiva.ESTADO             := 'Pendiente';
  Lr_InfoNotifMasiva.USR_CREACION       := Pv_UsrCreacion;
  Lr_InfoNotifMasiva.FE_CREACION        := SYSDATE;
  Lr_InfoNotifMasiva.IP_CREACION        := Pv_IpCreacion;

  DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIVA(Lr_InfoNotifMasiva, Pv_MsnError);

  IF TRIM(Pv_MsnError) IS NOT NULL THEN
    Pv_MsnError := Pv_MsnError || ' - Error al insertar el registro de envío masivo';
    RAISE Le_Exception;
  END IF;

  Lr_InfoNotifMasivaHist                        := NULL;
  Lr_InfoNotifMasivaHist.ID_NOTIF_MASIVA_HIST   := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_HIST.NEXTVAL;
  Lr_InfoNotifMasivaHist.NOTIF_MASIVA_ID        := Lr_InfoNotifMasiva.ID_NOTIF_MASIVA;
  Lr_InfoNotifMasivaHist.OBSERVACION            := 'Se crea el Job del envio masivo ' || 'JOB_NOTIF_' || Lr_InfoNotifMasiva.ID_NOTIF_MASIVA 
                                                   || ' PARAMETROS' || Lv_InfoFiltros;
  Lr_InfoNotifMasivaHist.ACCION                 := 'crear';
  Lr_InfoNotifMasivaHist.ESTADO_ENVIO_MASIVO    := 'Pendiente';
  Lr_InfoNotifMasivaHist.USR_CREACION           := Pv_UsrCreacion;
  Lr_InfoNotifMasivaHist.FE_CREACION            := SYSDATE;
  Lr_InfoNotifMasivaHist.IP_CREACION            := Pv_IpCreacion;

  DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIV_HIST(Lr_InfoNotifMasivaHist, Pv_MsnError);

  IF TRIM(Pv_MsnError) IS NOT NULL THEN
    Pv_MsnError := Pv_MsnError || ' - Error al insertar el registro del historial del envío masivo';
    RAISE Le_Exception;
  END IF;

  Lr_ArrayParamsBusq('grupo')                   := Pv_Grupo;
  Lr_ArrayParamsBusq('subgrupo')                := Pv_Subgrupo;
  Lr_ArrayParamsBusq('idElementoNodo')          := Pn_IdElementoNodo;
  Lr_ArrayParamsBusq('idElementoSwitch')        := Pn_IdElementoSwitch;
  Lr_ArrayParamsBusq('estadoServicio')          := Pv_EstadoServicio;
  Lr_ArrayParamsBusq('estadoPunto')             := Pv_EstadoPunto;
  Lr_ArrayParamsBusq('estadoCliente')           := Pv_EstadoCliente;
  Lr_ArrayParamsBusq('clientesVIP')             := Pv_ClientesVIP;
  Lr_ArrayParamsBusq('usrCreacionFactura')      := Pv_UsrCreacionFactura;
  Lr_ArrayParamsBusq('numFacturasAbiertas')     := Pn_NumFacturasAbiertas;
  Lr_ArrayParamsBusq('puntosFacturacion')       := Pv_PuntosFacturacion;
  Lr_ArrayParamsBusq('idsTiposNegocio')         := Pv_IdsTiposNegocio;
  Lr_ArrayParamsBusq('idsOficinas')             := Pv_IdsOficinas;
  Lr_ArrayParamsBusq('idFormaPago')             := Pv_IdFormaPago;
  Lr_ArrayParamsBusq('nombreFormaPago')         := Pv_NombreFormaPago;
  Lr_ArrayParamsBusq('idsBancosTarjetas')       := Pv_IdsBancosTarjetas;
  Lr_ArrayParamsBusq('fechaDesdeFactura')       := Pv_FechaDesdeFactura;
  Lr_ArrayParamsBusq('fechaHastaFactura')       := Pv_FechaHastaFactura;
  Lr_ArrayParamsBusq('saldoPendientePago')      := Pv_SaldoPendientePago;
  Lr_ArrayParamsBusq('valorSaldoPendientePago') := Pf_ValorSaldoPendientePago;


  Lv_IndexParamsBusq := Lr_ArrayParamsBusq.FIRST;
  WHILE (Lv_IndexParamsBusq IS NOT NULL) 
    LOOP
      IF ( Lr_ArrayParamsBusq(Lv_IndexParamsBusq) IS NOT NULL AND Lr_ArrayParamsBusq(Lv_IndexParamsBusq) <> '0') THEN
        Lr_InfoNotifMasivaParam                       := NULL;
        Lr_InfoNotifMasivaParam.ID_NOTIF_MASIVA_PARAM := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_PARAM.NEXTVAL;
        Lr_InfoNotifMasivaParam.NOTIF_MASIVA_ID       := Lr_InfoNotifMasiva.ID_NOTIF_MASIVA;
        Lr_InfoNotifMasivaParam.TIPO                  := 'BUSQUEDA';
        Lr_InfoNotifMasivaParam.NOMBRE                := Lv_IndexParamsBusq;
        Lr_InfoNotifMasivaParam.VALOR                 := Lr_ArrayParamsBusq(Lv_IndexParamsBusq);
        Lr_InfoNotifMasivaParam.ESTADO                := 'Activo';
        Lr_InfoNotifMasivaParam.USR_CREACION          := Pv_UsrCreacion;
        Lr_InfoNotifMasivaParam.FE_CREACION           := SYSDATE;
        Lr_InfoNotifMasivaParam.IP_CREACION           := Pv_IpCreacion;
        DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIVA_PAR(Lr_InfoNotifMasivaParam, Pv_MsnError);
        IF TRIM(Pv_MsnError) IS NOT NULL THEN
          Pv_MsnError := Pv_MsnError || ' - Error al insertar el parámetro de búsqueda para el envío masivo';
          RAISE Le_Exception;
        END IF;
      END IF;
      Lv_IndexParamsBusq := Lr_ArrayParamsBusq.NEXT(Lv_IndexParamsBusq);
    END LOOP;

    Lv_RepeatInterval                       := NULL;
    Lt_FechaStartJob                        := NULL;
    Lr_ArrayParamsEnvio('idsTipoContacto')  := Pv_IdsTipoContacto;
    IF Pv_TipoEnvio = 'PROGRAMADO' THEN
        Lr_ArrayParamsEnvio('fechaHoraProgramada')  := Pv_FechaHoraProgramada;
      Lt_FechaStartJob                              := TO_TIMESTAMP_TZ(Pv_FechaHoraProgramada,'YYYY-MM-DD HH24:MI');
    ELSE 
      IF Pv_TipoEnvio = 'RECURRENTE' THEN
        Lr_ArrayParamsEnvio('fechaEjecucionDesde')    := Pv_FechaEjecucionDesde;
        Lr_ArrayParamsEnvio('horaEjecucion')          := Pv_HoraEjecucion;
        Lr_ArrayParamsEnvio('periodicidad')           := Pv_Periodicidad;
        Lt_FechaStartJob                              := TO_TIMESTAMP_TZ(Pv_FechaEjecucionDesde,'YYYY-MM-DD');
        Lv_RepeatInterval                             := 'FREQ=' || Pv_Periodicidad || ';';
        IF Pv_Periodicidad = 'MONTHLY' THEN
          Lr_ArrayParamsEnvio('numeroDia')    := Pn_NumeroDia;
          Lv_RepeatInterval                   := Lv_RepeatInterval || 'BYMONTHDAY=' || Pn_NumeroDia || ';';
        END IF;

        Lv_HoraRecurrente := NULL;
        Lv_MinsRecurrente := NULL;
        Ln_PlsIntHoraMin  := INSTR(Pv_HoraEjecucion, ':');
        IF Ln_PlsIntHoraMin > 0 THEN
          Lv_HoraRecurrente := SUBSTR(Pv_HoraEjecucion, 1, Ln_PlsIntHoraMin-1);
          Lv_MinsRecurrente := SUBSTR(Pv_HoraEjecucion, Ln_PlsIntHoraMin + 1);
        END IF;

        IF Lv_HoraRecurrente IS NOT NULL AND Lv_MinsRecurrente IS NOT NULL THEN 
          Lv_RepeatInterval := Lv_RepeatInterval || 'BYHOUR=' || Lv_HoraRecurrente || ';BYMINUTE=' || Lv_MinsRecurrente || ';BYSECOND=0';
        ELSE
          Pv_MsnError := 'Error al obtener el intervalo de repetición';
          RAISE Le_Exception;
        END IF;
      END IF;
    END IF;


  Lv_IndexParamsEnvio := Lr_ArrayParamsEnvio.FIRST;
  WHILE (Lv_IndexParamsEnvio IS NOT NULL) 
    LOOP
      IF Lr_ArrayParamsEnvio(Lv_IndexParamsEnvio) IS NOT NULL THEN
        Lr_InfoNotifMasivaParam                       := NULL;
        Lr_InfoNotifMasivaParam.ID_NOTIF_MASIVA_PARAM := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_PARAM.NEXTVAL;
        Lr_InfoNotifMasivaParam.NOTIF_MASIVA_ID       := Lr_InfoNotifMasiva.ID_NOTIF_MASIVA;
        Lr_InfoNotifMasivaParam.TIPO                  := 'ENVIO';
        Lr_InfoNotifMasivaParam.NOMBRE                := Lv_IndexParamsEnvio;
        Lr_InfoNotifMasivaParam.VALOR                 := Lr_ArrayParamsEnvio(Lv_IndexParamsEnvio);
        Lr_InfoNotifMasivaParam.ESTADO                := 'Activo';
        Lr_InfoNotifMasivaParam.USR_CREACION          := Pv_UsrCreacion;
        Lr_InfoNotifMasivaParam.FE_CREACION           := SYSDATE;
        Lr_InfoNotifMasivaParam.IP_CREACION           := Pv_IpCreacion;
        DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIVA_PAR(Lr_InfoNotifMasivaParam, Pv_MsnError);
        IF TRIM(Pv_MsnError) IS NOT NULL THEN
          Pv_MsnError := Pv_MsnError || ' - Error al insertar el parámetro de envío masivo';
          RAISE Le_Exception;
        END IF;
      END IF;
      Lv_IndexParamsEnvio := Lr_ArrayParamsEnvio.NEXT(Lv_IndexParamsEnvio);
    END LOOP;
    COMMIT;


    DB_COMUNICACION.CUKG_TRANSACTIONS.P_CREA_JOB(   Lr_InfoNotifMasiva.ID_NOTIF_MASIVA,
                                                    Lr_InfoNotifMasiva.NOMBRE_JOB,
                                                    Lt_FechaStartJob, 
                                                    Lv_RepeatInterval,
                                                    Pv_MsnError);
    IF TRIM(Pv_MsnError) IS NOT NULL THEN
      Pv_MsnError := Pv_MsnError || ' - Error al intentar crear el job desde la configuración de envío masivo';
      RAISE Le_Exception;
    END IF;

    SELECT COUNT(*) INTO Ln_ContJob
    FROM USER_SCHEDULER_JOBS
    WHERE JOB_NAME = Lr_InfoNotifMasiva.NOMBRE_JOB;
    IF Ln_ContJob = 1 THEN
      UPDATE DB_COMUNICACION.INFO_NOTIF_MASIVA SET ESTADO = 'Configurado'
      WHERE ID_NOTIF_MASIVA = Lr_InfoNotifMasiva.ID_NOTIF_MASIVA AND ESTADO = 'Pendiente';

      Lr_InfoNotifMasivaHist                        := NULL;
      Lr_InfoNotifMasivaHist.ID_NOTIF_MASIVA_HIST   := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_HIST.NEXTVAL;
      Lr_InfoNotifMasivaHist.NOTIF_MASIVA_ID        := Lr_InfoNotifMasiva.ID_NOTIF_MASIVA;
      Lr_InfoNotifMasivaHist.OBSERVACION            := 'Se configura el Job del envio masivo ' || 'JOB_NOTIF_' || Lr_InfoNotifMasiva.ID_NOTIF_MASIVA;
      Lr_InfoNotifMasivaHist.ACCION                 := 'configurar';
      Lr_InfoNotifMasivaHist.ESTADO_ENVIO_MASIVO    := 'Configurado';
      Lr_InfoNotifMasivaHist.USR_CREACION           := Pv_UsrCreacion;
      Lr_InfoNotifMasivaHist.FE_CREACION            := SYSDATE;
      Lr_InfoNotifMasivaHist.IP_CREACION            := Pv_IpCreacion;

      DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIV_HIST(Lr_InfoNotifMasivaHist, Pv_MsnError);

      IF TRIM(Pv_MsnError) IS NOT NULL THEN
        Pv_MsnError := Pv_MsnError || ' - Error al insertar el registro del historial del envío masivo';
        RAISE Le_Exception;
      END IF;

      COMMIT;
    ELSE
      Pv_MsnError := ' Error al obtener el job del envío masivo ' || Lr_InfoNotifMasiva.NOMBRE_JOB;
      RAISE Le_Exception;
    END IF;

EXCEPTION
WHEN Le_Exception THEN
  --
  ROLLBACK;
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_CREA_JOB_NOTIF_MASIVA', 
                                        Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
--
WHEN OTHERS THEN
  --
  ROLLBACK;
  --
  Pv_MsnError := 'Error al crear y configurar el JOB';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_CREA_JOB_NOTIF_MASIVA', 
                                        Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
--
END P_CREA_JOB_NOTIF_MASIVA;

PROCEDURE P_CREA_JOB(
                        Pn_IdNotifMasiva    IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE,
                        Pv_NombreJob        IN DB_COMUNICACION.INFO_NOTIF_MASIVA.NOMBRE_JOB%TYPE, 
                        Pt_FechaStartJob    IN TIMESTAMP, 
                        Pv_RepeatInterval   IN VARCHAR2,
                        Pv_MsnError         OUT VARCHAR2)
IS
Lr_InfoNotifMasivaHist DB_COMUNICACION.INFO_NOTIF_MASIVA_HIST%ROWTYPE;
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
          job_name => '"DB_COMUNICACION"."' || Pv_NombreJob || '"',
          job_type => 'PLSQL_BLOCK',
          job_action => ' DECLARE
                            Lv_MensajeError VARCHAR2(4000)  := '''';
                            Ln_IdNotifMasiva NUMBER         := ' ||  Pn_IdNotifMasiva || '; 
                          BEGIN
                            DB_COMUNICACION.CUKG_TRANSACTIONS.P_ENVIO_NOTIF_MASIVA( Pn_IdNotifMasiva    => Ln_IdNotifMasiva, 
                                                                                    Pv_MsnError         => Lv_MensajeError);
                          END;',
          number_of_arguments => 0,
          start_date => Pt_FechaStartJob,
          repeat_interval => Pv_RepeatInterval,
          job_class => 'DEFAULT_JOB_CLASS',
          end_date => NULL,
          enabled => FALSE,
          auto_drop => FALSE,
          comments => 'Job creado para el envío masivo de notificaciones en TN');

  DBMS_SCHEDULER.SET_ATTRIBUTE( 
           name => '"DB_COMUNICACION"."' || Pv_NombreJob || '"', 
           attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);

  DBMS_SCHEDULER.enable(
           name => '"DB_COMUNICACION"."' || Pv_NombreJob || '"');


EXCEPTION
WHEN OTHERS THEN
  --
  UPDATE DB_COMUNICACION.INFO_NOTIF_MASIVA SET ESTADO = 'Fallo'
  WHERE ID_NOTIF_MASIVA = Pn_IdNotifMasiva AND ESTADO = 'Pendiente';

  Lr_InfoNotifMasivaHist                        := NULL;
  Lr_InfoNotifMasivaHist.ID_NOTIF_MASIVA_HIST   := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_HIST.NEXTVAL;
  Lr_InfoNotifMasivaHist.NOTIF_MASIVA_ID        := Pn_IdNotifMasiva;
  Lr_InfoNotifMasivaHist.OBSERVACION            := 'Hubo un fallo al intentar crear el Job del envio masivo ' || 'JOB_NOTIF_' || Pn_IdNotifMasiva;
  Lr_InfoNotifMasivaHist.ACCION                 := 'fallo';
  Lr_InfoNotifMasivaHist.ESTADO_ENVIO_MASIVO    := 'Fallo';
  Lr_InfoNotifMasivaHist.USR_CREACION           := 'envio_masivo_tn';
  Lr_InfoNotifMasivaHist.FE_CREACION            := SYSDATE;
  Lr_InfoNotifMasivaHist.IP_CREACION            := '127.0.0.1';

  DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIV_HIST(Lr_InfoNotifMasivaHist, Pv_MsnError);

  COMMIT;

  Pv_MsnError := 'Error al crear el JOB '  || Pv_NombreJob;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_CREA_JOB', 
                                        Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_CREA_JOB;


PROCEDURE P_ELIMINA_JOB_NOTIF_MASIVA(
                                    Pn_IdNotifMasiva    IN DB_COMUNICACION.INFO_NOTIF_MASIVA.ID_NOTIF_MASIVA%TYPE,
                                    Pv_Observacion      IN VARCHAR2,
                                    Pv_UsrCreacion      IN VARCHAR2,
                                    Pv_MsnError         OUT VARCHAR2)
IS
  Lr_InfoNotifMasivaHist DB_COMUNICACION.INFO_NOTIF_MASIVA_HIST%ROWTYPE;
  Lv_NombreJob VARCHAR2(30) := '';
  Le_Exception EXCEPTION;
BEGIN
  Lv_NombreJob := 'JOB_NOTIF_' || Pn_IdNotifMasiva;
  DB_COMUNICACION.CUKG_TRANSACTIONS.P_ELIMINA_JOB(  Lv_NombreJob,
                                                    Pv_MsnError);
  IF TRIM(Pv_MsnError) IS NOT NULL THEN
    Pv_MsnError := Pv_MsnError || ' - Error al intentar eliminar el job del envío masivo ' || Lv_NombreJob;
    RAISE Le_Exception;
  END IF;

  UPDATE DB_COMUNICACION.INFO_NOTIF_MASIVA SET ESTADO = 'Eliminado'
  WHERE ID_NOTIF_MASIVA = Pn_IdNotifMasiva;

  Lr_InfoNotifMasivaHist                        := NULL;
  Lr_InfoNotifMasivaHist.ID_NOTIF_MASIVA_HIST   := DB_COMUNICACION.SEQ_INFO_NOTIF_MASIVA_HIST.NEXTVAL;
  Lr_InfoNotifMasivaHist.NOTIF_MASIVA_ID        := Pn_IdNotifMasiva;
  Lr_InfoNotifMasivaHist.OBSERVACION            := Pv_Observacion || Lv_NombreJob;
  Lr_InfoNotifMasivaHist.ACCION                 := 'eliminar';
  Lr_InfoNotifMasivaHist.ESTADO_ENVIO_MASIVO    := 'Eliminado';
  Lr_InfoNotifMasivaHist.USR_CREACION           := Pv_UsrCreacion;
  Lr_InfoNotifMasivaHist.FE_CREACION            := SYSDATE;
  Lr_InfoNotifMasivaHist.IP_CREACION            := '127.0.0.1';

  DB_COMUNICACION.CUKG_TRANSACTIONS.P_INSERT_INFO_NOTIF_MASIV_HIST(Lr_InfoNotifMasivaHist, Pv_MsnError);


  IF TRIM(Pv_MsnError) IS NOT NULL THEN
    Pv_MsnError := Pv_MsnError || ' - Error al eliminar el registro del historial del envío masivo '|| Lv_NombreJob;
    RAISE Le_Exception;
  END IF;

  COMMIT;
EXCEPTION
WHEN Le_Exception THEN
  --
  ROLLBACK;
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_ELIMINA_JOB_NOTIF_MASIVA', 
                                        Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );


WHEN OTHERS THEN  
  ROLLBACK;
  Pv_MsnError := 'Error al eliminar el envío masivo '  || Lv_NombreJob;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_ELIMINA_JOB_NOTIF_MASIVA', 
                                        Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_ELIMINA_JOB_NOTIF_MASIVA;


PROCEDURE P_ELIMINA_JOB(
                        Pv_NombreJob    IN DB_COMUNICACION.INFO_NOTIF_MASIVA.NOMBRE_JOB%TYPE,
                        Pv_MsnError     OUT VARCHAR2)
IS
  Ln_ExisteJob NUMBER;
BEGIN
  SELECT COUNT(*) INTO Ln_ExisteJob 
  FROM user_scheduler_jobs
  WHERE job_name = Pv_NombreJob;

  IF Ln_ExisteJob = 1 THEN

    DBMS_SCHEDULER.DROP_JOB(job_name    => Pv_NombreJob, 
                            defer       => false, 
                            force       => true);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  --  
  Pv_MsnError := 'Error al eliminar el JOB '  || Pv_NombreJob;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_ELIMINA_JOB', 
                                        Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_ELIMINA_JOB;


PROCEDURE P_ELIMINA_ENVIO_MASIVO_AUT
IS
  CURSOR Lc_GetEnviosMasivos
  IS
    --
    SELECT INM.ID_NOTIF_MASIVA
    FROM DB_COMUNICACION.INFO_NOTIF_MASIVA INM
    WHERE INM.TIPO IN ('INMEDIATO','PROGRAMADO')
    AND INM.ESTADO IN ('Finalizado','Pendiente');
  Lv_Observacion VARCHAR(100) := 'Eliminación Automática del envío masivo ';
  Lv_MsnError VARCHAR(4000);
  Lv_NombreJob VARCHAR(30);
BEGIN

  FOR I_GetEnviosMasivos IN Lc_GetEnviosMasivos
  LOOP
    Lv_NombreJob := 'JOB_NOTIF' || I_GetEnviosMasivos.ID_NOTIF_MASIVA;
    DB_COMUNICACION.CUKG_TRANSACTIONS.P_ELIMINA_JOB_NOTIF_MASIVA(I_GetEnviosMasivos.ID_NOTIF_MASIVA,
                                                             Lv_Observacion,
                                                             'envio_masivo_tn',
                                                             Lv_MsnError);
  END LOOP;

EXCEPTION
WHEN OTHERS THEN
  --  
  Lv_MsnError := 'Error al eliminar JOBS automaticamente '  || 'JOB_NOTIF' || Lv_NombreJob;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_ELIMINA_ENVIO_MASIVO_AUT', 
                                        Lv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_ELIMINA_ENVIO_MASIVO_AUT;


PROCEDURE P_ACTUALIZA_AUDIT_ELEMENTOS
IS
  CURSOR Lc_GetEvaluacionesEnProceso
  IS
    --
    SELECT IDR.ID_DOCUMENTO_RELACION
    FROM DB_COMUNICACION.INFO_DOCUMENTO_RELACION IDR
    WHERE IDR.ESTADO_EVALUACION = 'En Proceso'
    AND IDR.FE_INICIO_EVALUACION <= (CURRENT_TIMESTAMP -1);

BEGIN

  FOR I_GetEvaluacionesEnProceso IN Lc_GetEvaluacionesEnProceso
  LOOP
    UPDATE DB_COMUNICACION.INFO_DOCUMENTO_RELACION 
    SET ESTADO_EVALUACION = 'Pendiente' 
    WHERE ID_DOCUMENTO_RELACION = I_GetEvaluacionesEnProceso.ID_DOCUMENTO_RELACION;
    COMMIT;
  END LOOP;
EXCEPTION
WHEN OTHERS THEN
  --  
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CUKG_TRANSACTIONS.P_ACTUALIZA_AUDIT_ELEMENTOS', 
                                        SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

END P_ACTUALIZA_AUDIT_ELEMENTOS;

PROCEDURE P_ENVIA_CTA_CORREO_GENERADO(Pv_Login          IN VARCHAR2,
                                      Pv_Password       IN VARCHAR2,
                                      Pv_Correo         IN VARCHAR2 ,
                                      Pn_PersonaId      IN NUMBER,
                                      Pv_PrefijoEmpresa IN VARCHAR2,
                                      Pv_MensajeError OUT VARCHAR2)IS                               


  CURSOR C_GETPLANTILLA(Cv_CodPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE, 
                        Cv_Estado Varchar2) IS
      SELECT PLANTILLA
       FROM DB_COMUNICACION.ADMI_PLANTILLA 
      WHERE ESTADO <> Cv_Estado
        AND CODIGO = Cv_CodPlantilla;

   CURSOR C_FORMA_CONTACTO (Cv_DescFormaContacto DB_COMUNICACION.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE,
                            Cv_Estado Varchar2)IS
    SELECT ID_FORMA_CONTACTO 
      FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO 
     WHERE DESCRIPCION_FORMA_CONTACTO = Cv_DescFormaContacto
       AND ESTADO <>  Cv_Estado;       

  CURSOR C_CONTACTO (Cv_Estado Varchar2,
                     Cn_FormaContactoId DB_COMUNICACION.INFO_PERSONA_FORMA_CONTACTO.FORMA_CONTACTO_ID%TYPE) IS
    SELECT VALOR 
      FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO 
    WHERE PERSONA_ID        = Pn_PersonaId
      AND ESTADO           <> Cv_Estado
      AND FORMA_CONTACTO_ID = Cn_FormaContactoId;


   CURSOR C_NOMBRE_EMPRESA (Cv_Estado Varchar2)IS 
     SELECT NOMBRE_EMPRESA 
       FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
      WHERE PREFIJO = Pv_PrefijoEmpresa
        AND ESTADO  <> Cv_Estado;


--
  Lc_Plantilla         C_GetPlantilla%ROWTYPE;
  Lv_MessageMail       VARCHAR2(4000);
  Lv_Asunto            VARCHAR2(200):= 'Creación  de cuenta Telcos+';
  Lv_MailDestinatario  VARCHAR2(4000);
  Lv_Estado            VARCHAR2(10):= 'Eliminado'; 
  Lv_DescFormaContacto DB_COMUNICACION.ADMI_FORMA_CONTACTO.DESCRIPCION_FORMA_CONTACTO%TYPE:= 'Correo Electronico'; 
  Lv_CodPlantilla      DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE:= 'CREA_CTA_CORREO';
  Ln_IdFormaContacto   DB_COMUNICACION.ADMI_FORMA_CONTACTO.ID_FORMA_CONTACTO%TYPE;
  Lc_Contacto          C_CONTACTO%ROWTYPE;
  Lv_NombreEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.NOMBRE_EMPRESA%TYPE;

  Lex_Exception                     EXCEPTION;

BEGIN

    IF C_GetPlantilla%ISOPEN THEN CLOSE C_GetPlantilla; END IF;
    OPEN C_GetPlantilla(Lv_CodPlantilla,
                        Lv_Estado);
    FETCH C_GetPlantilla INTO Lc_Plantilla;
    IF C_GetPlantilla%NOTFOUND THEN
     CLOSE C_GetPlantilla;
     RAISE Lex_Exception;
    END IF;
    CLOSE C_GetPlantilla;

    IF C_FORMA_CONTACTO%ISOPEN THEN CLOSE C_FORMA_CONTACTO; END IF;
    OPEN C_FORMA_CONTACTO(Lv_DescFormaContacto,
                          Lv_Estado);
    FETCH C_FORMA_CONTACTO INTO Ln_IdFormaContacto;
    IF C_FORMA_CONTACTO%NOTFOUND THEN
      CLOSE C_FORMA_CONTACTO;
      RAISE Lex_Exception;
    ELSE
      IF C_CONTACTO%ISOPEN THEN CLOSE C_CONTACTO; END IF;
      FOR Lc_Contacto IN C_CONTACTO(Lv_Estado, Ln_IdFormaContacto)LOOP
        Lv_MailDestinatario:= Lc_Contacto.Valor||';'||Lv_MailDestinatario;
      END LOOP; 
    END IF;
    CLOSE C_FORMA_CONTACTO;

    IF C_NOMBRE_EMPRESA%ISOPEN THEN CLOSE C_NOMBRE_EMPRESA; END IF;
    OPEN C_NOMBRE_EMPRESA(Lv_Estado);
    FETCH C_NOMBRE_EMPRESA INTO Lv_NombreEmpresa;
    CLOSE C_NOMBRE_EMPRESA;

    --

    Lv_MessageMail := REPLACE(Lc_Plantilla.PLANTILLA,'{{ strLogin }}', Pv_Login);
    Lv_MessageMail := REPLACE(Lv_MessageMail,        '{{ strContrasena }}', Pv_Password);

    Lv_MessageMail := REPLACE(Lv_MessageMail,        '{{ strNombreEmpresa }}', NVL(Lv_NombreEmpresa,NULL));

    DBMS_OUTPUT.PUT_LINE(Lv_MessageMail);
    --
    UTL_MAIL.SEND (SENDER => 'notificaciones_telcos@telconet.ec', 
                   RECIPIENTS =>Lv_MailDestinatario, 
                   SUBJECT => Lv_Asunto,
                   MESSAGE => Lv_MessageMail,
                   MIME_TYPE => 'text/html; charset=UTF-8' );

    --
    EXCEPTION
    WHEN Lex_Exception THEN
         Pv_MensajeError:= 'Error';
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                              'CUKG_TRANSACTIONS.P_ENVIA_CTA_CORREO_GENERADO',
                                              'Error CUKG_TRANSACTIONS.P_ENVIA_CTA_CORREO_GENERADO Lex_Exception',
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

                                              --
    WHEN OTHERS THEN
         Pv_MensajeError:= 'Error';
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
           DBMS_OUTPUT.PUT_LINE('');
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                              'CUKG_TRANSACTIONS.P_ENVIA_CTA_CORREO_GENERADO',
                                              'Error CUKG_TRANSACTIONS.P_ENVIA_CTA_CORREO_GENERADO: '||SQLCODE ||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMUNICACION'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
-- 
 END P_ENVIA_CTA_CORREO_GENERADO;

END CUKG_TRANSACTIONS;
/