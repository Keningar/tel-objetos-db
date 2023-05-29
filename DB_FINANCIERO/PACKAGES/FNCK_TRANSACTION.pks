CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_TRANSACTION
AS
  --
  /**
  * Documentacion para el procedimiento P_UPDATE_DOC_FINAN_BY_COMP
  *
  * Procedimiento que actualiza la información de los comprobantes electronicos del TELCOS+ que coincidan con el documento autorizado del portal de 
  * facturación en el nombre, valor, número de establecimiento, punto de emision, secuencial y empresa.
  *
  * @param Pv_MensajeError OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 30-01-2017
  */
  PROCEDURE P_UPDATE_DOC_FINAN_BY_COMP(
      Pv_MensajeError OUT VARCHAR2 );
  --
  --
--
/**
* Documentacion para el procedimiento P_INSERT_INFO_PAGO_HISTORIAL
*
* Método que inserta registros en la tabla INFO_PAGO_HISTORIAL
*
* @param Pr_InfoPagoLineaHist IN DB_FINANCIERO.INFO_PAGO_LINEA_HISTORIAL%ROWTYPE Objecto con la información que se debe ingresar
* @param Pv_MsnError OUT VARCHAR2 Retorna un mensaje de error en caso de existir
*
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.0 16-11-2016
*/
PROCEDURE P_INSERT_INFO_PAGO_HISTORIAL( 
Pr_InfoPagoLineaHist IN DB_FINANCIERO.INFO_PAGO_LINEA_HISTORIAL%ROWTYPE,
Pv_MsnError          OUT VARCHAR2); 
--      
  /**
* Documentacion para el procedimiento P_ACTIVA_FAC_POR_ANULA_NC
* Método que activa la factura asociada a la nota de credito siempre y cuando su estado sea Cerrado y su saldo sea mayar a cero.
*
* @param Pn_IdDoc                    IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE     Se envía el id del documento
* @param Pv_User                     IN VARCHAR2                                            Se envía el usuario que realiza la activacion
* @param Pv_MsnError                 IN VARCHAR2                                            Retorna un mensaje de error en caso de existir uno
*
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.0 18-10-2016
*/
PROCEDURE P_ACTIVA_FAC_POR_ANULA_NC(
    Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_User        IN VARCHAR2,
    Pv_MsnError   OUT VARCHAR2);
    --
  /**
  * Documentacion para procedure P_REGULARIZAR_NUM_FACTURA_SRI
  *
  * Verifica que existan facturas con numero de secuencia repetidos y las regulariza para luego generar el comprobante electrónico respectivo
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0
  * @since 07-04-2016
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 - Se modifica el procedure para que regularice las facturas repetidas sin tomar en cuenta la primera que se encuentra duplicada.
  * @since 28-04-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 25-11-2016 - Se modifica el procedure para que regularice las facturas repetidas tomando en cuenta el tipo de empresa y el tipo de
  *                           documento. 
  *                           Si no se encuentra la numeración respectiva se actualiza el documento dejándolo sin numeración.
  *                           Se guarda el historial respectivo de la actualización del documento.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.3 05-08-2020 - Se modifica el procedure se le agregan parámetros de entreda Pv_ParametroTiposDoc, Pv_ParametroEstadosDoc, Pv_TiposDocumentos
  *                           para identificar las facturas de las notas de créditos.
  *
  * @param Pv_ParametroTiposDoc   IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE (parámetro para obtener los documentos según el tipo)
  * @param Pv_ParametroEstadosDoc IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE (parámetro para obtener los estados según el documento)
  * @param Pv_TiposDocumentos     IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE ('FACTURAS' ó 'NOTAS_DE_CREDITO')
  * @param Pv_CodigoNumeracion    IN DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE ('FACE' ó 'NCE')
  * @param Pv_MensaError OUT VARCHAR2 Retorna un mensaje de error en caso de existir uno
  * 
  * @author Leonela Burgos <mlburgos@telconet.ec>
  * @version 1.4 21-04-2023 - Se agrego la condicion de fecha para que solo sea 2 dias de verificacion de las facturas y facturas enviadas al SRI
  *
  */
  PROCEDURE P_REGULARIZAR_NUM_FACTURA_SRI(Pv_ParametroTiposDoc   IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                          Pv_ParametroEstadosDoc IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                          Pv_TiposDocumentos     IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                          Pv_CodigoNumeracion    IN DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE,
                                          Pv_MensaError          OUT VARCHAR2);

  /**
   * Procedimiento que realiza el reverso del contrato según el parámetro.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 18-10-2018
   */
  PROCEDURE P_REVERSO_CONTRATO_X_PARAMETRO (Pv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE);

  /**
   * Procedimiento que crea las notas de crédito por reverso del contrato.
   * Anula los servicios ligados al punto en que se generó la factura de instalación que no se ha pagado.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 18-10-2018
   */
  PROCEDURE P_CREA_NC_X_FACT_INSTALACION(Pv_CaractContrato IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                         Pv_CaractVigencia IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                         Pn_IdMotivo       IN  DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE,
                                         Pv_Observacion    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
                                         Pv_UsrCreacion    IN  VARCHAR2,
                                         Pv_EmpresaCod     IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_Mensaje        OUT VARCHAR2);

  /**
   * Procedimiento que realiza el reverso de los servicios relacionados al punto que se le creó la factura de instalación.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 23-11-2018
   */
  PROCEDURE P_REVERSO_SERVICIOS (Pn_PuntoId       IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                 Pv_EstadoReverso IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                 Pv_UsrCreacion   IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.USR_CREACION%TYPE,
                                 Pv_Mensaje       OUT VARCHAR2);

  /**
   * Procedimiento que numera las notas de crédito según corresponda.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 18-10-2018
   */
  PROCEDURE P_NUMERA_NOTA_CREDITO (Pn_DocumentoId    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                   Pv_PrefijoEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                   Pv_ObsHistorial   IN  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE,
                                   Pv_UsrCreacion    IN  VARCHAR2,
                                   Pv_Mensaje        OUT VARCHAR2);
    --
    --
  PROCEDURE FINP_ANULAPAGO(
      Pn_IdPago      IN  INFO_PAGO_CAB.ID_PAGO%TYPE,
      Pv_User        IN  VARCHAR2,
      Pn_IdMotivo    IN  ADMI_MOTIVO.ID_MOTIVO%TYPE,
      Pv_Observacion IN  VARCHAR2,
      Pv_MsnError    OUT VARCHAR2);
    --
  PROCEDURE P_PROCESAR_ERROR_IVA(
    PV_EMPRESA_COD  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    PN_ID_DOCUMENTO IN NUMBER,
    PV_ESTADO       IN VARCHAR2,
    PV_USUARIO      IN VARCHAR2,
    PV_MENSAJE      OUT VARCHAR2);
  /**/
  PROCEDURE INSERT_ERROR(
      Pv_Aplicacion   IN INFO_ERROR.APLICACION%TYPE,
      Pv_Proceso      IN INFO_ERROR.PROCESO%TYPE,
      Pv_DetalleError IN INFO_ERROR.DETALLE_ERROR%TYPE);
  --
  PROCEDURE INSERT_ANEXO_TRANSACCIONAL(
      Pv_Mes                IN VARCHAR2,
      Pv_Anio               IN VARCHAR2,
      Pv_AnexoTransaccional IN CLOB,
      Pv_UsrCreacion        IN VARCHAR2,
      Pv_EmpresaCod         IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE);
  --
  PROCEDURE INSERT_INFO_DOC_FINANCIERO_CAB(
      Pr_InfoDocumentoFinancieroCab IN  INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
      Pv_MsnError                   OUT VARCHAR2);
  --
  PROCEDURE INSERT_INFO_DOC_FINANCIERO_DET(
      Pr_InfoDocumentoFinancieroDet IN  INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE,
      Pv_MsnError                   OUT VARCHAR2);
  --
  PROCEDURE INSERT_INFO_DOC_FINANCIERO_IMP(
      Pr_InfoDocumentoFinancieroImp IN  INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE,
      Pv_MsnError                   OUT VARCHAR2);
  --
  PROCEDURE INSERT_INFO_DOC_FINANCIERO_HST(
      Pr_InfoDocumentoHistorial IN  INFO_DOCUMENTO_HISTORIAL%ROWTYPE,
      Pv_MsnError               OUT VARCHAR2);
  --
  type R_DocumentosSecuencia IS RECORD(
   documento DB_FINANCIERO.INFO_TMP_SECUENCIA_DOCS.ID_DOCUMENTO%type,
   secuencia DB_FINANCIERO.INFO_TMP_SECUENCIA_DOCS.SECUENCIA%type,
   estado DB_FINANCIERO.INFO_TMP_PRODUCTOS.ESTADO_IMPRESION_FACT%type
  );
  --
  type lstSecuenciaDocumentosType is table of R_DocumentosSecuencia;
        
  --    
  PROCEDURE INSERT_INFO_DOC_FINAN_HST_MAS(
      Pr_DocumentosAsociados IN lstSecuenciaDocumentosType,
      Pv_MsnError               OUT VARCHAR2);
  --
  /**
  * Documentacion para el procedimiento UPDATE_INFO_DOC_FINANCIERO_CAB
  * Actualiza la cabecera de la factura y devuelve un mensaje en caso de haber ocurrido un error al actualizar
  * @param Pn_IdDocumento                      IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Recibe el id documento al actualizar
  * @param Pr_InfoDocumentoFinancieroCab       IN  INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE            Recibe un objeto de la INFO_DOCUMENTO_FINANCIERO_CAB
  * @param Pv_MsnError                         OUT VARCHAR2                                         Devuelve el mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 22-09-2016 - Se agrega la nueva columna que debe ser actualizada 'DESCUENTO_COMPENSACION'
  */
  PROCEDURE UPDATE_INFO_DOC_FINANCIERO_CAB(
      Pn_IdDocumento                IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pr_InfoDocumentoFinancieroCab IN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
      Pv_MsnError OUT VARCHAR2);

  PROCEDURE UPDATE_INFO_DOC_FINANCIERO_IMP(
      PN_ID_DOC_IMP                 IN  INFO_DOCUMENTO_FINANCIERO_IMP.ID_DOC_IMP%TYPE,
      PR_INFO_DOC_FINANCIERO_IMP    IN  INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE,
      PV_MENSAJE                    OUT VARCHAR2);
  --
  PROCEDURE INSERT_INFO_PAGO_CAB(
      Pr_InfoPagoCab IN  INFO_PAGO_CAB%ROWTYPE,
      Pv_MsnError    OUT VARCHAR2);
  --
  PROCEDURE INSERT_INFO_PAGO_DET(
      Pr_InfoPagoDet  IN  INFO_PAGO_DET%ROWTYPE,
      Pv_MsnError     OUT VARCHAR2);
  --
  PROCEDURE INSERT_INFO_PAGO_HIST(
      Pr_InfoPagoHist  IN  INFO_PAGO_HISTORIAL%ROWTYPE,
      Pv_MsnError     OUT VARCHAR2);
  --
  PROCEDURE UPDATE_ADMI_NUMERACION(
      Pn_IdNumeracion   IN  ADMI_NUMERACION.ID_NUMERACION%TYPE,
      Pr_AdmiNumeracion IN  ADMI_NUMERACION%ROWTYPE,
      Pv_MsnError       OUT VARCHAR2);
  --
  PROCEDURE P_DELETE_DOCUMENTO_FINANCIERO(
    Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_MsnError   OUT VARCHAR2);
  --
  PROCEDURE INSERT_INFO_CICLO_FACTURACION(
      Pr_InfoCicloFacturacion   IN  INFO_CICLO_FACTURADO%ROWTYPE,
      Pv_MsnError               OUT VARCHAR2);
  --
  PROCEDURE UPDATE_INFO_CICLO_FACTURACION(
      Pn_IdEjeFacturacion     IN  INFO_CICLO_FACTURADO.ID_CICLO_FACTURADO%TYPE,
      Pr_InfoCicloFacturacion IN  INFO_CICLO_FACTURADO%ROWTYPE,
      Pv_MsnError             OUT VARCHAR2);
  --
 /**
  * Procedimiento que itera las solicitudes que deben ser facturadas según el parámetro 'FACTURACION_SOLICITUDES'
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.0
  * @since 30-08-2018
  * Versión inicial
  */
  PROCEDURE P_FACTURACION_SOLICITUDES (Pv_ProcesoAutomatico VARCHAR2 DEFAULT 'N');

  /**
  * Documentacion para el procedimiento P_GENERAR_FACTURAS_SOLICITUD
  *
  * Método que genera las facturas dependiendo del estado y la descripcion de la solicitud que han ingresado 
  *
  * @param Pv_Estado IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE Se envía el estado del Servicio 
  * @param Pv_DescripcionSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE Se envía la descripción de la Solicitud
  * @param Pv_MsnError OUT VARCHAR2 Retorna un mensaje de error en caso de existir 
  *
  * @author Edson Franco <efranco@telconet.ec> 
  * @version 1.0 12-12-2015 
  * @author Edson Franco <efranco@telconet.ec> 
  * @version 1.1 21-09-2015 - Se agrega las variables 'Pv_UsrCreacion' y 'Pn_MotivoId' para realizar una consulta más específica de las facturas que
  *                           se deben crear
  * @author Edson Franco <efranco@telconet.ec> 
  * @version 1.2 12-01-2017 - Se modifica la función para agregar el plan de instalacion 'INSTALACION HOME' cuando se cree una factura por
  *                           solicitud 'SOLICITUD INSTALACION GRATIS' para MD
  * @author Edson Franco <efranco@telconet.ec> 
  * @version 1.3 24-02-2017 - Al agregar la característica de 'FECHA_VIGENCIA' a la factura de instalación se corrige el formato de fecha guardado
  *                           en el campo valor. El formato usado es 'DD-MM-YYYY'
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.4 31-07-2017 - Se realizan ajustes para setear una descripcion unica en las facturas para las
  *                           solicitudes de Demo
  * @author Edgar Holguín   <eholguin@telconet.ec>
  * @version 1.5 13-12-2017 - Se agrega seteo de campo SERVICIO_ID en creación del detalle de la factura.
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.6
  * @since 30-08-2018
  * Se modifica el procedimiento para que pueda ser llamado por cualquier solicitud y así lea el producto o plan y descripción de sus parámetros.
  * Se agrega la funcionalidad para clonar las características de tipo facturable de la solicitud al documento financiero.
  * Se modifica la creación del info_Servicio_historial almacenando el estado real de la solicitud en caso de generar factura en subtotal 0.
  * Se agrega el parámetro Pv_EmpresaCod para discriminar las solicitudes por empresa.
  * Se elimina toda lógica del proceso de facturación de contrato digital debido a que este proceso es genérico para cualquier tipo de solicitud.
  * 
  * @author Luis Lindao   <llindao@telconet.ec>
  * @version 1.7 17-01-2019 - Se asigna como fecha de emisión el dia anterior porque proceso procesa los generado el día anterior
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.8 20-09-2019 - Se trunca el valor de descuento a 2 decimales.
  * 
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.9 19-10-2020 - Se modifica a forma dinámica el query que obtiene Solicitudes de Clientes, y se valida para agregar sentencia 
  *                           que obtiene registros por solicitudes facturación por reubicación.
  *                         - Se agrega cursor C_ObtieneCaractSolFact para obtener el id_caracteristica de la solicitud de factura por reubicación.
  *                         - Se agrega cursor C_ObtieneNumTareaReub para obtener el número de tarea mediante la solicitud y concatenar a la 
  *                           observación del documento.
  * Costo query C_ObtieneCaractSolFact: 2
  * Costo query C_ObtieneNumTareaReub: 5
  * 
  *
  * @version 2.0  12-03-2020
  * @author José Candelario <jcandelario@telconet.ec>
  * Se realizan cambios en query que obtiene las solicitudes de los Clientes, se agrega filtro que el servicio no cuente con una 
  * caracteristica de Reingreso de OS automática.
  *
  * @version 2.1  12-12-2022
  * @author Gustavo Narea <gnarea@telconet.ec>
  * Se verifica si el rol del consumidor del servicio a facturar no sea Cliente Canal
  *
  * @version 2.2  06-03-2022
  * @author Hector Lozano <hlozano@telconet.ec>
  * Se agrega prefijo de empresa Ecuanet en validacion para numerar facturas por solicitud.
  */
  PROCEDURE P_GENERAR_FACTURAS_SOLICITUD(
      Pv_Estado               IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
      Pv_UsrCreacion          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pn_MotivoId             IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
      Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_EstadoServicio       IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ESTADO%TYPE DEFAULT NULL,
      Pv_MsnError             OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para el procedimiento P_INSERT_INFO_DOCUMENTO_CARACT
  *
  * Método que inserta registros en la tabla INFO_DOCUMENTO_CARACTERISTICA
  *
  * @param Pr_InfoDocumentoCaract IN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE  Objecto con la información que se debe ingresar
  * @param Pv_MsnError OUT VARCHAR2 Retorna un mensaje de error en caso de existir 
  *
  * @author Edson Franco <efranco@telconet.ec> 
  * @version 1.0 21-09-2015
  * @author Luis Lindao <llindao@telconet.ec> 
  * @version 1.0 06-02-2018 -  Se modifica para cambiar ref-cursor a cursor y considerar parametro fecha contabiliza que determina 
  *                            si la consulta es por fecha_emision o fecha_autorizacion
  */
  PROCEDURE P_INSERT_INFO_DOCUMENTO_CARACT(
      Pr_InfoDocumentoCaract IN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE,
      Pv_MsnError OUT VARCHAR2);

  /**
   * Procedimiento que actualiza un registro de la tabla INFO_DOCUMENTO_CARACTERISTICA.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 24-09-2018
   * Versión inicial.
   */
  PROCEDURE P_UPDATE_INFO_DOCUMENTO_CARACT(Pr_InfoDocumentoCaract IN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE,
                                           Pv_MsnError            OUT VARCHAR2);

  --
  --

  /**
   * Función que devuelve el valor final de la observación.
   * Se envía por parámetro la cadena de la plantilla por ejemplo: 'PLANTILLA PRUEBA POR %VALOR%'
   *    Donde 'VALOR' es la descripción de una característica activa ligada a la solicitud.
   *          '%'     es el delimitador para identificar la descripción de la característica a buscar.
   * Si la característica no existe, se muestra el valor vacío.
   * Si no existe el delimitador, se devuelve la misma cadena.
   * Si el número de coincidencias del delimitador es impar, significa que una etiqueta no está cerrada, por lo cual devuelve la misma plantilla.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 25-10-2018
   *
   * @param Pv_Plantilla           IN   La cadena de texto de la plantilla.
   * @param Pn_DetalleSolicitudId  IN   El id de la solicitud a la cual debe estar ligada a las características de la plantilla.
   * @param Pv_Estado              IN   El estado de la cacterística a buscar.
   */
  FUNCTION F_GET_OBSERVACION_X_PLANTILLA(Pv_Plantilla          IN  VARCHAR2,
                                         Pn_DetalleSolicitudId IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                         Pv_Estado             IN  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE DEFAULT 'Activo')
    RETURN VARCHAR2;

  /**
   * Procedimiento que Obtiene la información del parámetro ('FACTURACION_SOLICITUDES') en base al nombre de una solicitud específica
   * para determinar el plan, producto a facturar y la descripción del producto para el detalle de la factura.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 13-08-2018
   *
   * @param Pv_NombreSolicitud      IN  Nombre de la solicitud para buscar en la tabla de parámetros.
   * @param Pv_EmpresaCod           IN  Código de la empresa para buscar en la tabla de parámetros.
   * @param Pn_PlanId               OUT Id del plan a ser facturado resultado de la búsqueda en la tabla de parámetros.
   * @param Pn_ProductoId           OUT Id del producto a ser facturado resultado de la búsqueda en la tabla de parámetros.
   * @param Pv_ObservacionFactura   OUT Observación del detalle ser facturado resultado de la búsqueda en la tabla de parámetros.
   */
  PROCEDURE P_BUSCA_INFORMACION_SOLICITUD(Pv_NombreSolicitud    IN  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                          Pv_EmpresaCod         IN  DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                          Pn_PlanId             OUT DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
                                          Pn_ProductoId         OUT DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
                                          Pv_ObservacionFactura OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE);

 /**
  * Procedimiento que clona las características de la tabla INFO_DETALLE_SOL_CARAC a la tabla INFO_DOCUMENTO_CARACTERISTICA
  * Es mandatorio que el estado de la solicitud sea 'Facturable' para poder ser clonada.
  * La característica clonada en la INFO_DOCUMENTO_CARACTERISTICA se crea con estado 'Activo' para ser visualizada en Telcos.
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.0
  * @since 15-08-2018
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.1
  * @since 06-09-2019 Se agrega clonado de características no facturables de una solicitud como características del documento financiero.
  *
  * @param Pn_DetalleSolicitudId           IN  Id de la solicitud que contiene las características a ser clonadas.
  * @param Pr_InfoDocumentoFinancieroDet   IN  Registro de la INFO_DOCUMENTO_FINANCIERO_DET a insertar por defecto.
  * @param Pv_PagaIva                      IN  Bandera si el cliente aplica IVA o no. (S/N).
  * @param Pv_Mensaje                      OUT Mensaje de error en caso de existir.
  */
  PROCEDURE P_CLONAR_SOLICITUD_CARAC (Pn_DetalleSolicitudId         IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                      Pr_InfoDocumentoFinancieroDet IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE,
                                      Pv_PagaIva                    IN  VARCHAR2,
                                      Pv_Mensaje                    OUT VARCHAR2);

  /**
   * Procedimiento que crea el registro en la INFO_DOCUMENTO_FINANCIERO_DET y en INFO_DOCUMENTO_FINANCIERO_IMP según corresponda.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 30-09-2018
   */
  PROCEDURE P_CREA_DOCUMENTO_DETALLE_IMP (Pr_InfoDocumentoFinancieroDet IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE,
                                          Pv_PagaIva                    IN  VARCHAR2,
                                          Pv_Mensaje                    OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_UPDATE_DOC_CONTABILIZAR
  *
  * Procedimiento que realiza actualiza la columna de CONTABILIZADO con el valor de 'N' para poder reprocesar la información de dichos documentos,
  * adicional escribe un historial con lo realizado.
  *
  * @param Pv_Prefijo                 IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE  (Prefijo de la empresa que va a reprocesar la informacion)
  * @param Pv_CodigoTipoDocumento     IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE (Código de los documentos a 
  *                                                                                                               actualizar)
  * @param Pv_ActualizarContabilizado IN VARCHAR2  (Parámetro que indica si se debe actualizar la columna de CONTABILIZADO)
  * @param Pv_FeProcesar              IN VARCHAR2  (Fecha en la que se van a consultar los documentos)
  * @param Pv_UsrCreacion             IN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE  (Usuario quien realiza la acción)
  * @param Pv_TipoProceso             IN OUT VARCHAR2  (Tipo de proceso que se va a realizar con los documentos a actualizar)
  * @param Pv_MensajeError            OUT VARCHAR2  (Texto con el mensaje de error en caso de existir)
  *
  * @author Edson Franco <efranco@telconet.ec> 
  * @version 1.0 22-02-2017
  *
  * @author Luis Lindao <llindao@telconet.ec> 
  * @version 1.1 04-03-2018 -  Se modifica para corregir where que filtra por fecha de emisión o fecha contabilización 
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.2 05-03-2018 - Se modifica para cambiar DECODE por CASE pues la condicion contraria del DECODE no presenta el resultado requerido
*/
  PROCEDURE P_UPDATE_DOC_CONTABILIZAR(
      Pv_Prefijo                 IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_CodigoTipoDocumento     IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_ActualizarContabilizado IN VARCHAR2,
      Pv_FeProcesar              IN VARCHAR2,
      Pv_UsrCreacion             IN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE,
      Pv_TipoProceso             IN OUT VARCHAR2,
      Pv_MensajeError            OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para el procedimiento P_REPROCESAMIENTO_CONTABLE
  *
  * Método que realiza el reprocesamiento de la información migrada al NAF que no haya sido mayorizada
  *
  * @param Pv_CodEmpresa              IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (Código de la empresa que va a reprocesar la informacion)
  * @param Pv_Prefijo                 IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE  (Prefijo de la empresa que va a reprocesar la informacion)
  * @param Pv_CodigoTipoDocumento     IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE (Código de los documentos a 
  *                                                                                                               actualizar)
  * @param Pv_CodigoDiario            IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.COD_DIARIO%TYPE  (Código de diario con el cual se asienta el
  *                                                                                                  registro en la contabilidad)
  * @param Pv_ActualizarContabilizado IN VARCHAR2  (Parámetro que indica si se debe actualizar la columna de CONTABILIZADO)
  * @param Pv_FeProcesar              IN VARCHAR2  (Fecha en la que se van a consultar los documentos)
  * @param Pv_UsrCreacion             IN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE  (Usuario quien realiza la acción)
  * @param Pv_TipoProceso             IN OUT VARCHAR2  (Tipo de proceso que se va a realizar con los documentos a actualizar)
  * @param Pv_MensajeError            OUT VARCHAR2  (Texto con el mensaje de error en caso de existir)
  *
  * @author Edson Franco <efranco@telconet.ec> 
  * @version 1.0 23-02-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 20-03-2017 - Se actualiza el procedimiento 'NAF47_TNET.GEK_MIGRACION.P_ELIMINA_MIGRA_CG' enviando 'NULL' al parámetro 
  *                           'Pv_NumeroAsiento' el cual es usado para eliminar un documento específico de las tablas de migracion del NAF.
  */
  PROCEDURE P_REPROCESAMIENTO_CONTABLE(
    Pv_CodEmpresa              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo                 IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento     IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_CodigoDiario            IN  DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.COD_DIARIO%TYPE,
    Pv_ActualizarContabilizado IN  VARCHAR2,
    Pv_FeProcesar              IN  VARCHAR2,
    Pv_UsrCreacion             IN  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE,
    Pv_TipoProceso             IN  OUT VARCHAR2,
    Pv_MensajeError            OUT VARCHAR2);


  /**
  * Documentacion para el procedimiento P_GEN_CARGO_REPROCESO
  *
  * Método que realiza la generación de solicitudes de cargo por reproceso a los clientes correspondientes.
  *
  * @param Pv_PrefijoEmpresa          IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE  (Prefijo de la empresa que va a reprocesar la informacion)
  * @param Pv_EstadoDebitoDet         IN  DB_FINANCIERO.INFO_DEBITO_DET.ESTADO%TYPE (Estado del débito)
  * @param Pv_ParametroDebitos        IN  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE  (Número de intentos de débitos fallidos)
  * @param Pv_MensajeError            OUT VARCHAR2  (Texto con el mensaje de error en caso de existir)
  *
  * @author Edgar Holguin <eholguin@telconet.ec> 
  * @version 1.0 22-03-2017
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 20-05-2021 - Se elimina cursor C_GetCountSolReproceso por motivo de validación que aumenta el tiempo de respuesta en la lógica.  
  *                           Se elimina código correspondiente a la lógica del cursor que obtenía un count de las solicitudes del cliente.
  *                         - Se modifica cursor C_ClientesConCargoReproceso para obtener los clientes validando las solicitudes ligadas
  *                           en los estados permitidos. Se parametriza los estados permitidos.
  *                         - Se mueve afuera del bucle la lógica de los cursores que guardan el mismo valor para mejorar procesamiento en tiempos
  *                           de respuesta.
  *
  * Costo query C_ClientesConCargoReproceso: 24
  *
  */
  PROCEDURE P_GEN_CARGO_REPROCESO
  (
      Pv_PrefijoEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_EstadoDebitoDet  IN  DB_FINANCIERO.INFO_DEBITO_DET.ESTADO%TYPE,
      Pv_ParametroDebitos IN  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
      Pv_MensajeError     OUT VARCHAR2
  );

  /**
  * Documentacion para el procedimiento P_EJEC_CARGO_REPROCESO
  *
  * Procedimiento que ejecuta la generación de solicitudes por cargo de reproceso de débito.
  *
  * @param Pv_MensajeError            OUT VARCHAR2  (Texto con el mensaje de error en caso de existir)
  *
  * @author Edgar Holguin <eholguin@telconet.ec> 
  * @version 1.0 22-03-2017
  */  
  PROCEDURE P_EJEC_CARGO_REPROCESO
  (
      Pv_MensajeError     OUT VARCHAR2
  );

    /**
    * Documentacion para el procedimiento P_INSERT_INFO_REPORTE_HIST
    *
    * Método que inserta registros en la tabla INFO_REPORTE_HISTORIAL
    *
    * @param Pr_InfoReporteHist IN DB_FINANCIERO.INFO_REPORTE_HISTORIAL%ROWTYPE Objeto con la información que se debe ingresar
    *
    * @author Edgar Holguin <eholguin@telconet.ec>
    * @version 1.0 09-09-2017
    */
    PROCEDURE P_INSERT_INFO_REPORTE_HIST(
      Pr_InfoReporteHist IN DB_FINANCIERO.INFO_REPORTE_HISTORIAL%ROWTYPE);

    /**
    * Documentacion para el procedimiento P_UPDATE_INFO_REPORTE_HIST
    *
    * Método que actualiza un registro en la tabla INFO_REPORTE_HISTORIAL según el id enviado como parámetro.
    *
    * @param Pn_IdReporteHistorial IN DB_FINANCIERO.INFO_REPORTE_HISTORIAL.ID_REPORTE_HISTORIAL%TYPE Id del reporte.
    *
    * @author Edgar Holguin <eholguin@telconet.ec>
    * @version 1.0 09-09-2017
    */
    PROCEDURE P_UPDATE_INFO_REPORTE_HIST(
      Pn_IdReporteHistorial IN DB_FINANCIERO.INFO_REPORTE_HISTORIAL.ID_REPORTE_HISTORIAL%TYPE);
	  
	  /**
  * Documentacion para el procedimiento P_API_INTERFAZ_FACTURACION_TNP
  *
  * Método que ejecuta el consumo de webservice de impresora fiscal Panama
  *
  * @param Pn_IdDocumento  IN N INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Id del documento.
  * @param Pv_CodEmpresa   IN IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Id de la empresa.
  * @param Pv_CodigoError  OUT Varchar2.
  * @param Pv_MensajeError OUT Varchar2.
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 10-05-2018
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.1 01-02-2019 - Se modifica la generación de JSON debido a que se habilitó para Panamá la Facturación de Planes y actualmente
  *                           considera solo Facturas de Productos.
  *                           Se escapan caracteres especiales en el JSON ya que las tildes estan devolviendo en la respuesta :
  *                           CODE-0052 ERROR EN LA FORMACION DEL JSON
  */
  PROCEDURE P_API_INTERFAZ_FACTURACION_TNP(Pn_IdDocumento  IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                           Pv_CodEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pv_CodigoError  OUT Varchar2,
                                           Pv_MensajeError OUT Varchar2); 

  /**
  * Documentacion para el procedimiento P_API_CIERRE_FISCAL_TNP
  *
  * Método que ejecuta el consumo de webservice de impresora fiscal para la generación del
  * Reporte de Cierre Fiscal X o Cierre Fiscal Z para la empresa Telconet Panamá.
  *
  * @param Pv_TipoCierre      IN  Varchar2 Tipo de Cierre Fiscal : Cierre Fiscal X o Cierre Fiscal Z
  * @param Pv_CodEmpresa      IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Codigo de la empresa.
  * @param Pv_PrefijoEmpresa  IN  INFO_EMPRESA_GRUPO.PREFIJO%TYPE Prefijo de la empresa en sesion, 
  * @param Pv_UsuarioSession  IN  VARCHAR2 Usuario que genera reporte de Cierre Fiscal
  * @param Pv_EmailUsrSesion  IN  VARCHAR2 Correo del Usuario que genera reporte
  * @param Pv_CodigoError     OUT Varchar2.
  * @param Pv_MensajeError    OUT Varchar2.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.0 29-01-2019
  */
  PROCEDURE P_API_CIERRE_FISCAL_TNP(Pv_TipoCierre        IN  Varchar2,
                                    Pv_CodEmpresa        IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pv_PrefijoEmpresa    IN  INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                                    Pv_UsuarioSession    IN  VARCHAR2,
                                    Pv_EmailUsrSesion    IN  VARCHAR2,
                                    Pv_CodigoError       OUT Varchar2,
                                    Pv_MensajeError      OUT Varchar2); 

  /**
  * Documentacion para el procedimiento P_GENERA_NC_SOLICITUDES
  *
  * Método que ejecuta la generación de notas de crédito para facturas que poseen dicha característica. 
  *
  * @param Pv_CodEmpresa   IN IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Id de la empresa.
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 27-09-2018
  */
  PROCEDURE P_GENERA_NC_SOLICITUDES(Pv_CodEmpresa  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE);

  /*
  * Documentación para TYPE 'T_FacturasPto'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.00 06-09-2019
  */
  TYPE T_FacturasPto IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_FacturasPto INDEX BY PLS_INTEGER;

  /**
  * Documentación para el procedimiento P_GET_FACTURAS_BY_PTO_CARACT_ID
  * Procedimiento que retorna el listado de facturas asocidas al punto enviado como parámetro.
  *
  * @param  Pn_PuntoId           DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                          Recibe el id del punto.
  * @param  Pn_CaracteristicaId  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE        Recibe el id de la característica a consultar.
  * @param  Pv_UsrCreacion       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE  Recibe el usuario de creación.
  * @param  Pv_Mensaje                                                                          Mensaje de salida.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 06-09-2019
  */

 PROCEDURE P_MARCAR_FACTURAS_PUNTO (Pn_PuntoId          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                    Pn_CaracteristicaId IN DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
                                    Pv_UsrCreacion      IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                    Pv_Mensaje          OUT VARCHAR2);

 /**
  * Documentación para TYPE 'Lr_RegistrosSolicitudes'.
  *  
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 19-10-2020
  */
  TYPE Lr_RegistrosSolicitudes IS RECORD (
    ID_DETALLE_SOLICITUD DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    SERVICIO_ID          DB_COMERCIAL.INFO_DETALLE_SOLICITUD.SERVICIO_ID%TYPE,
    PRECIO_DESCUENTO     DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PRECIO_DESCUENTO%TYPE,
    PORCENTAJE_DESCUENTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE,
    USR_CREACION         DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE);

 /**
  * Documentación para TYPE 'T_RegistrosSolicitudes'. 
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 19-10-2020
  */                     
  TYPE T_RegistrosSolicitudes IS TABLE OF Lr_RegistrosSolicitudes INDEX BY PLS_INTEGER;

  /**
   * Documentación para el procedimiento P_GENERA_NC_SOLICITUDES_REUB
   *
   * Procedimiento que ejecuta la generación de notas de crédito por solictud de Nc por reubicación. 
   *
   * Costo query C_GetFacturasCaractNcReub: 110
   * Costo query C_GetIdMotivo: 9
   * Costo query C_GetValorPorCaract: 6
   * Costo query C_GetTipoDocIdNc: 1
   *
   * @param Pv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Id de la empresa).
   * @param Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE     (Prefijo de la empresa).
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 20-10-2020
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.1 06-09-2021 - Se elimina la búsqueda por estado Activo del cursor C_GetIdMotivo, 
   *                           el cual obtiene el id motivo de la solicitud de NC por Reubicación.
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.2 19-05-2023 - Se insertan logs, para monitorear el proceso de crear Notas de Crédito por Reubicación.
   *
   */
  PROCEDURE P_GENERA_NC_SOLICITUDES_REUB(Pv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE);

  /**
  * Documentación para el procedimiento P_CLONAR_CARACT_NC_REUB.
  *
  * Procedimiento que clona las características de la tabla INFO_DETALLE_SOL_CARAC a la tabla INFO_DOCUMENTO_CARACTERISTICA.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0
  * @since 28-10-2020
  * 
  * Costo query C_ObtieneCaracteristicas: 4
  *
  * @param Pn_DetalleSolicitudId IN  Id de la solicitud que contiene las características a ser clonadas.
  * @param Pn_IdDocumento        IN  Id documento de la Nota de crédito.
  * @param Pv_Mensaje            OUT Mensaje de error en caso de existir.
  */
  PROCEDURE P_CLONAR_CARACT_NC_REUB(Pn_DetalleSolicitudId IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                    Pn_IdDocumento        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                    Pv_Mensaje            OUT VARCHAR2);

  /**
  * Documentación para el procedimiento P_REPORTE_REUBICACION.
  *
  * Procedimiento que ejecuta la generación de reporte de facturas y notas de crédito emitidas por el
  * proceso de reubicación MD. 
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 29-10-2020
  *
  * Costo query C_DocumentosEmitidos: 101
  *
  * @param Pv_FechaReporte    IN VARCHAR2   (Fecha de reporte). 
  * @param Pv_EmpresaCod      IN VARCHAR2   (Id de la empresa).
  * @param Pv_PrefijoEmpresa  IN VARCHAR2   (Prefijo de la empresa).
  * @param Pv_UsuarioCreacion IN VARCHAR2   (Usuario que ejecuta el proceso).
  * @param Pv_EmailUsuario    IN VARCHAR2   (Correo a quien se envía reporte).
  */
  PROCEDURE P_REPORTE_REUBICACION(Pv_FechaReporte    IN VARCHAR2,
                                  Pv_EmpresaCod      IN VARCHAR2,
                                  Pv_PrefijoEmpresa  IN VARCHAR2,
                                  Pv_UsuarioCreacion IN VARCHAR2,
                                  Pv_EmailUsuario    IN VARCHAR2);

  /**
  * Documentación para el función F_GET_VALORES_REPORTE_NC_REUB.
  *
  * Función que se encarga de obtener los valores de Nc mediante el tipo de consulta enviado, correspondiente
  * al proceso de reubicación para MD. 
  * 
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 29-10-2020
  *
  * Costo query C_GetValoresNcReub: 5
  * Costo query C_GetCaractNcReub:  4
  *
  * @param Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  (Id de documento). 
  * @param Fv_TipoConsulta IN VARCHAR2   (Tipo de consulta).
  * @param RETURN VARCHAR2
  */
  FUNCTION F_GET_VALORES_REPORTE_NC_REUB(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                         Fv_TipoConsulta IN VARCHAR2)
  RETURN VARCHAR2;

  /**
  * Documentación para el procedimiento P_CREA_NOTA_CREDITO_REUB.
  *
  * Procedimiento que se encarga de generar nota de crédito para el proceso de reubicación.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0
  * @since 30-10-2020
  *
  * @param  Pn_IdDocumento         IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE             Recibe el ID_DOCUMENTO
  * @param  Pn_TipoDocumentoId     IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE   Recibe el CODIGO_TIPO_DOCUMENTO
  * @param  Pn_IdMotivo            IN  ADMI_MOTIVO.ID_MOTIVO%TYPE                                  Recibe el ID_MOTIVO
  * @param  Pv_ValorOriginal       IN  VARCHAR2                                                    Recibe un Y o N para hacer la NC por valor original
  * @param  Pv_PorcentajeServicio  IN  VARCHAR2                                                    Recibe un Y o N para hacer la NC por % del servicio
  * @param  Pn_Porcentaje          IN  NUMBER                                                      Recibe el porcentaje
  * @param  Pn_IdOficina           IN  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE                          Recibe la ID_OFICINA
  * @param  Pn_IdEmpresa           IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE                         Recibe el COD_EMPRESA
  * @param  Pn_IdDocumentoNC       OUT INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE             Retorna el ID de la nota de crédito
  * @param  Pv_MessageError        OUT VARCHAR2                                                    Recibe un mensaje de error en caso de existir
  */
  PROCEDURE P_CREA_NOTA_CREDITO_REUB(Pn_IdDocumento        IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                     Pn_TipoDocumentoId    IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                     Pn_IdMotivo           IN ADMI_MOTIVO.ID_MOTIVO%TYPE,
                                     Pv_ValorOriginal      IN VARCHAR2,
                                     Pv_PorcentajeServicio IN VARCHAR2,
                                     Pn_Porcentaje         IN NUMBER,
                                     Pn_IdOficina          IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                     Pn_IdEmpresa          IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pn_IdDocumentoNC      OUT INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                     Pv_MessageError       OUT VARCHAR2);

  /**
  * Documentación para el procedimiento P_RECHAZA_SOLICTUDES_REUB.
  *
  * Procedimiento que se encarga de obtener las solicitudes de factura y/o nota crédito por reubicación MD ligadas 
  * a tarea que poseen estado de 'Anulada', 'Rechazada', 'Cancelada', para actualizar la solicitud a "Rechazada".
  * 
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 04-11-2020
  * 
  * Costo query C_ObtieneSolicitudesReub: 430
  *
  * @param Pv_EmpresaCod  IN DB_SOPORTE.INFO_COMUNICACION.EMPRESA_COD%TYPE  (Id de la empresa). 
  * @param Pv_UsrCreacion IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE  (Usuario que ejecuta el proceso).
  */                                      
  PROCEDURE P_RECHAZA_SOLICITUDES_REUB(Pv_EmpresaCod  IN DB_SOPORTE.INFO_COMUNICACION.EMPRESA_COD%TYPE,
                                       Pv_UsrCreacion IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE);
 
  /**
  * Documentacion para el procedimiento P_GENERAR_FAC_SOLI_X_SERVICIO
  *
  * Método que genera las facturas por el servicio dependiendo del estado y la descripcion de la solicitud que han ingresado.
  *
  * Costo del Query C_SolicitudesClientes: 126
  * Costo del Query C_GetProducto: 4
  * Costo del Query C_GetLogin: 5
  * Costo del Query C_ObtieneInfoServ: 3
  * Costo del Query C_DatosNumeracion: 4
  *
  * PARAMETROS:
  * @Param Pn_IdServicio           IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE  Id servicio mandatorio.
  * @Param Pv_Estado               IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE  Estado 'Pendiente'.
  * @Param Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE  Descripción de la solicitud Móvil ó Web.
  * @Param Pv_UsrCreacion          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE  Usuario transaccional.
  * @Param Pn_MotivoId             IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE  Motivo de la transacción.
  * @Param Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Código de la empresa.
  * @Param Pv_MsnError             OUT VARCHAR2  Variabe de salida de los errores controlados.
  * 
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-03-2020
  */
  PROCEDURE P_GENERAR_FAC_SOLI_X_SERVICIO(Pn_IdServicio           IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                          Pv_Estado               IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                          Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                          Pv_UsrCreacion          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                          Pn_MotivoId             IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
                                          Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                          Pv_MsnError             OUT VARCHAR2);
  --                                        
  PROCEDURE P_ELIMINAR_DATA_TEMP_MAS(Pv_IdTmpDatos DB_FINANCIERO.INFO_TMP_PRODUCTOS.UUID%TYPE, Pv_MsnError OUT VARCHAR2);

END FNCK_TRANSACTION;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_TRANSACTION
AS
  --
  Gv_UsrProcesoMasivo VARCHAR2(4000) := '@';
  --

  PROCEDURE P_UPDATE_DOC_FINAN_BY_COMP(
      Pv_MensajeError OUT VARCHAR2 )
  IS
    --
    --CURSOR QUE OBTIENE LOS COMPROBANTES A REGULARIZAR
    --COSTO QUERY: 4150
    CURSOR C_GetComprobanteRegularizar(Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                       Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                       Cv_DescripcionEstado DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                       Cv_ValorParametro  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                       Cv_EsElectronica DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_ELECTRONICA%TYPE,
                                       Cn_EstadoDocumento DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_DOC_ID%TYPE,
                                       Cv_UsrCreacionNotIn DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                       Cv_DescripcionTiempo DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE)
    IS
      --
      SELECT
        ICE.ID_COMP_ELECTRONICO,
        ICE.DOCUMENTO_ID,
        IDE.NUMERO_AUTORIZACION,
        IDE.FE_AUTORIZACION,
        IDE.CLAVE_ACCESO
      FROM
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      ON
        IOG.ID_OFICINA = IDFC.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      ON
        IEG.COD_EMPRESA = IOG.EMPRESA_ID
      JOIN DB_COMPROBANTES.ADMI_EMPRESA AE
      ON
        AE.CODIGO = IEG.PREFIJO
      JOIN DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO ICE
      ON
        ICE.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
      JOIN DB_COMPROBANTES.INFO_DOCUMENTO IDE
      ON
        IDE.NOMBRE = ICE.NOMBRE_COMPROBANTE
      WHERE
        IDFC.ESTADO_IMPRESION_FACT IN
        (
          SELECT
            VALOR2
          FROM
            DB_GENERAL.ADMI_PARAMETRO_DET
          WHERE
            PARAMETRO_ID =
            (
              SELECT
                ID_PARAMETRO
              FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
              WHERE
                ESTADO             = Cv_EstadoActivo
              AND NOMBRE_PARAMETRO = Cv_NombreParametro
            )
          AND ESTADO      = Cv_EstadoActivo
          AND DESCRIPCION = Cv_DescripcionEstado
          AND VALOR1      = Cv_ValorParametro
        )
      AND IDFC.ES_ELECTRONICA = Cv_EsElectronica
      AND IDE.ESTADO_DOC_ID   = Cn_EstadoDocumento
      AND IDFC.USR_CREACION  <> Cv_UsrCreacionNotIn
      AND IDE.VALOR           = IDFC.VALOR_TOTAL
      AND IEG.ESTADO          = Cv_EstadoActivo
      AND IDE.ESTABLECIMIENTO = DB_FINANCIERO.FNCK_CONSULTS.F_GET_SECUENCIAL_DOCUMENTO(NULL, IDFC.NUMERO_FACTURA_SRI, 'ESTABLECIMIENTO')
      AND IDE.PUNTO_EMISION   = DB_FINANCIERO.FNCK_CONSULTS.F_GET_SECUENCIAL_DOCUMENTO(NULL, IDFC.NUMERO_FACTURA_SRI, 'PUNTO_EMISION')
      AND IDE.SECUENCIAL      = DB_FINANCIERO.FNCK_CONSULTS.F_GET_SECUENCIAL_DOCUMENTO(NULL, IDFC.NUMERO_FACTURA_SRI, 'SECUENCIAL')
      AND IDFC.FE_CREACION >= SYSDATE       - NVL (
        (
          SELECT
            VALOR2
          FROM
            DB_GENERAL.ADMI_PARAMETRO_DET
          WHERE
            PARAMETRO_ID =
            (
              SELECT
                ID_PARAMETRO
              FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
              WHERE
                ESTADO             = Cv_EstadoActivo
              AND NOMBRE_PARAMETRO = Cv_NombreParametro
            )
          AND ESTADO      = Cv_EstadoActivo
          AND DESCRIPCION = Cv_DescripcionTiempo
          AND VALOR1      = Cv_ValorParametro
        )
        , 0 );
      --
    --
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                         := 'Activo';
    Lv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE            := 'JOB_REGULARIZA_COMPROBANTE_ELECTRONICO';
    Lv_DescripcionEstado DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE               := 'ESTADOS_COMPROBANTES_DOCUMENTO';
    Lv_ValorParametro  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                      := 'NOMBRE_DOCUMENTO';
    Lv_EsElectronica DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_ELECTRONICA%TYPE  := 'S';
    Ln_EstadoDocumento DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_DOC_ID%TYPE              := 5;
    Lv_UsrCreacionNotIn DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE := 'telcos_migracion';
    Lv_DescripcionTiempo DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE               := 'TIEMPO_DIAS';
    Ln_ContadorCommit NUMBER                                                          := 0;
    --
  BEGIN
    --
    FOR I_GetComprobanteRegularizar IN C_GetComprobanteRegularizar(Lv_EstadoActivo,
                                                                   Lv_NombreParametro,
                                                                   Lv_DescripcionEstado,
                                                                   Lv_ValorParametro,
                                                                   Lv_EsElectronica,
                                                                   Ln_EstadoDocumento,
                                                                   Lv_UsrCreacionNotIn,
                                                                   Lv_DescripcionTiempo)
    LOOP
      --
      --ACTUALIZO EL COMPROBANTE ELECTRONICO
      UPDATE
        DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO
      SET
        ESTADO                  = 5,
        DETALLE                 = 'Autorizado',
        NUMERO_AUTORIZACION     = I_GetComprobanteRegularizar.NUMERO_AUTORIZACION,
        FE_AUTORIZACION         = I_GetComprobanteRegularizar.FE_AUTORIZACION,
        CLAVE_ACCESO            = I_GetComprobanteRegularizar.CLAVE_ACCESO,
        COMPROBANTE_ELECTRONICO = NULL
      WHERE
        ID_COMP_ELECTRONICO = I_GetComprobanteRegularizar.ID_COMP_ELECTRONICO;
      --
      --
      --ACTUALIZO EL DOCUMENTO FINANCIERO
      UPDATE
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
      SET
        ESTADO_IMPRESION_FACT = 'Activo',
        NUMERO_AUTORIZACION   = I_GetComprobanteRegularizar.NUMERO_AUTORIZACION,
        FE_AUTORIZACION       = I_GetComprobanteRegularizar.FE_AUTORIZACION
      WHERE
        ID_DOCUMENTO = I_GetComprobanteRegularizar.DOCUMENTO_ID;
      --
      --
      --GUARDO EL MENSAJE INFORMATIVO DEL DOCUMENTO REGULARIZADO EN LA TABLA DE MENSAJES ELECTRONICOS
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_MESSAGE_COMP_ELEC( 'INFORMATIVO', 
                                                                        'Envio al SRI',
                                                                        'Se envio a consultar el estado del comprobante al SRI',
                                                                        I_GetComprobanteRegularizar.DOCUMENTO_ID, 
                                                                        SYSDATE );
      --
      Ln_ContadorCommit := Ln_ContadorCommit + 1;
      --
      --
      IF Ln_ContadorCommit = 5000 THEN
        --
        COMMIT;
        --
        Ln_ContadorCommit := 0;
        --
      END IF;
      --
    END LOOP;
    --
    --
    IF Ln_ContadorCommit < 5000 THEN
      --
      COMMIT;
      --
    END IF;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Pv_MensajeError := 'Error al actualizar los comprobantes electronicos ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_TRANSACTION.P_UPDATE_DOC_FINAN_BY_COMP', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_UPDATE_DOC_FINAN_BY_COMP;
  --
  --
--
/**
* Documentacion para el procedimiento INSERT_INFO_PAGO_HISTORIAL
* Insert en pago en linea que va a ser descartado y devuelve un mensaje en caso de haber ocurrido un error al insertar
* @param Pr_InfoPagoLineaHist                IN  INFO_PAGO_LINEA_HISTORIAL%ROWTYPE Recibe un objeto como INFO_PAGO_LINEA_HISTORIAL
* @param Pv_MsnError                         OUT VARCHAR2                          Devuelve el mensaje de error
*
*/
PROCEDURE P_INSERT_INFO_PAGO_HISTORIAL(  
  Pr_InfoPagoLineaHist IN DB_FINANCIERO.INFO_PAGO_LINEA_HISTORIAL%ROWTYPE,
  Pv_MsnError          OUT VARCHAR2)
IS
BEGIN
  --
  INSERT
  INTO
    DB_FINANCIERO.INFO_PAGO_LINEA_HISTORIAL
    (
      ID_PAGO_LINEA_HIST,  
      PAGO_LINEA_ID,
      CANAL_PAGO_LINEA_ID,
      EMPRESA_ID,          
      PERSONA_ID,         
      VALOR_PAGO_LINEA,
      NUMERO_REFERENCIA,
      ESTADO_PAGO_LINEA,
      OBSERVACION,
      PROCESO,
      USR_CREACION,
      FE_CREACION         
    )
    VALUES
    (
      Pr_InfoPagoLineaHist.ID_PAGO_LINEA_HIST,
      Pr_InfoPagoLineaHist.PAGO_LINEA_ID,
      Pr_InfoPagoLineaHist.CANAL_PAGO_LINEA_ID,
      Pr_InfoPagoLineaHist.EMPRESA_ID,
      Pr_InfoPagoLineaHist.PERSONA_ID,
      Pr_InfoPagoLineaHist.VALOR_PAGO_LINEA,
      Pr_InfoPagoLineaHist.NUMERO_REFERENCIA,
      Pr_InfoPagoLineaHist.ESTADO_PAGO_LINEA,
      Pr_InfoPagoLineaHist.OBSERVACION,
      Pr_InfoPagoLineaHist.PROCESO,
      Pr_InfoPagoLineaHist.USR_CREACION,
      Pr_InfoPagoLineaHist.FE_CREACION
    );
	--
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR(
  'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_PAGO_HISTORIAL',
  SQLERRM);
  --
END P_INSERT_INFO_PAGO_HISTORIAL;
--
PROCEDURE P_ACTIVA_FAC_POR_ANULA_NC(
    Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_User        IN VARCHAR2,
    Pv_MsnError   OUT VARCHAR2)
AS
  --
  Ln_saldoFactura NUMBER := NULL;
  Lv_observacion  VARCHAR2(100);
  Lv_codigo       VARCHAR2(2);
  Lv_MsnError     VARCHAR(1000);
  Lr_InfoDocumentoFinancieroFac INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lr_InfoDocumentoFinancieroNc INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lr_InfoDocumentoFinancieroHis DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
  Lex_Exception EXCEPTION;
  --
BEGIN
  --
  Lr_InfoDocumentoFinancieroFac := NULL;
  Lr_InfoDocumentoFinancieroNc  := NULL;
  --Consulto a la nota de credito para recuperar el id de la factura
  Lr_InfoDocumentoFinancieroNc := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento, NULL);
  --
  IF Lr_InfoDocumentoFinancieroNc.REFERENCIA_DOCUMENTO_ID IS NOT NULL THEN
    --Obtiene el saldo de la factura
    FNCK_CONSULTS.P_SALDO_X_FACTURA( Lr_InfoDocumentoFinancieroNc.REFERENCIA_DOCUMENTO_ID, NULL, Ln_saldoFactura, Lv_MsnError);
    --
    IF Lv_MsnError IS NOT NULL THEN
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    IF Ln_saldoFactura IS NULL THEN
      Ln_saldoFactura  := 0;
    END IF;
    -- Si el saldo de la factura es mayor 0 (saldo a favor). Se Activa Factura
    IF Ln_saldoFactura > 0 THEN
      --Recupero la factura vinculada a la nota de credito
      Lr_InfoDocumentoFinancieroFac := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroNc.REFERENCIA_DOCUMENTO_ID, NULL);
      --
      IF Lr_InfoDocumentoFinancieroFac.ESTADO_IMPRESION_FACT = 'Cerrado' THEN
        --
        UPDATE INFO_DOCUMENTO_FINANCIERO_CAB
        SET ESTADO_IMPRESION_FACT = 'Activo'
        WHERE ID_DOCUMENTO        = Lr_InfoDocumentoFinancieroNc.REFERENCIA_DOCUMENTO_ID;
        --
        COMMIT;
        --
        Lv_observacion:= 'Documento activado por la anulacion de Nota de Credito No. ' || Lr_InfoDocumentoFinancieroNc.NUMERO_FACTURA_SRI;
        Pv_MsnError   := '00';
        --
      END IF;
      --
    ELSE
      --
      Lv_observacion:= 'Saldo de la factura insuficiente para activarla. ';
      Pv_MsnError   := '02';
      --
    END IF;
    -- Con la informacion de cabecera se inserta el historial
    Lr_InfoDocumentoFinancieroHis                       := NULL;
    Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:= DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
    Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          := Lr_InfoDocumentoFinancieroNc.REFERENCIA_DOCUMENTO_ID;
    Lr_InfoDocumentoFinancieroHis.FE_CREACION           := SYSDATE;
    Lr_InfoDocumentoFinancieroHis.USR_CREACION          := Pv_User;
    Lr_InfoDocumentoFinancieroHis.ESTADO                := 'Activo';
    Lr_InfoDocumentoFinancieroHis.OBSERVACION           := Lv_observacion;
    --
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis, Lv_MsnError);
    --
    IF Lv_MsnError IS NOT NULL THEN
      --
      Lv_MsnError := Lv_MsnError || ' - Error al insertar el historial de la cabecera de la factura';
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
  END IF;
  --
EXCEPTION
WHEN Lex_Exception THEN
  ROLLBACK;
  FNCK_TRANSACTION.INSERT_ERROR('Telcos+', 'FNCK_TRANSACTION.P_ACTIVA_FAC_POR_ANULA_NC', SQLERRM);
  Pv_MsnError := 'No se realizó la activación de la Factura.';
  --
END P_ACTIVA_FAC_POR_ANULA_NC;
  --
  --
  PROCEDURE P_REGULARIZAR_NUM_FACTURA_SRI(Pv_ParametroTiposDoc   IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                          Pv_ParametroEstadosDoc IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                          Pv_TiposDocumentos     IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                          Pv_CodigoNumeracion    IN DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE,
                                          Pv_MensaError          OUT VARCHAR2)
  AS
    --
    --CONSULTA EL DOCUMENTO FINANCIERO DE LA CABECERA
    CURSOR C_GetDocumentoFinanciero(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      --
      SELECT ID_DOCUMENTO, ESTADO_IMPRESION_FACT
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
      WHERE ID_DOCUMENTO = Cn_IdDocumento;
    --
    --VALIDA QUE EL DOCUMENTO QUE SE VA A CAMBIAR LA NUMERACION ESTE EN ESTADO PENDIENTE Y NO POSEA COMPROBANTE ELECTRONICO
    --COSTO QUERY: 7
    CURSOR C_ValidacionDocumento(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                 Cv_ParametroDocEstados DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_ValorDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                 Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE)
    IS
      --
      SELECT IDFC.ID_DOCUMENTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      LEFT JOIN DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO ICE
      ON IDFC.ID_DOCUMENTO           = ICE.DOCUMENTO_ID
      WHERE IDFC.ID_DOCUMENTO        = Cn_IdDocumento
      AND ICE.DOCUMENTO_ID           IS NULL
      AND IDFC.ESTADO_IMPRESION_FACT IN ( SELECT APD.VALOR1
                                          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                          JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                          ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
                                          WHERE APD.ESTADO           = Cv_EstadoActivo
                                          AND APC.ESTADO             = Cv_EstadoActivo
                                          AND APC.NOMBRE_PARAMETRO   = Cv_ParametroDocEstados
                                          AND APD.DESCRIPCION        = Cv_ValorDocumentos);
    --
    --OBTIENE LOS NUMEROS DE DOCUMENTOS REPETIDOS
    --COSTO QUERY: 3237
    --COSTO QUERY: 10461
    CURSOR C_GetNumeroDocSriRepetidos(Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                      Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                      Cv_DescripcionDetalle DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                      Cv_ValorDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                      Cv_ParametroDocEstados DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      --
      SELECT COUNT(DOCUMENTOS_REGULARIZAR.ID_DOCUMENTO) as CONTADOR, DOCUMENTOS_REGULARIZAR.NUMERO_FACTURA_SRI
      FROM 
      (
        SELECT IDFC.ID_DOCUMENTO, IDFC.OFICINA_ID, IDFC.NUMERO_FACTURA_SRI
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
        ON IOG.ID_OFICINA = IDFC.OFICINA_ID AND IOG.EMPRESA_ID = Cv_CodEmpresa
        JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
        ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
        WHERE IDFC.ESTADO_IMPRESION_FACT IN ( SELECT APD.VALOR1
                                              FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                              JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                              ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
                                              WHERE APD.ESTADO           = Cv_EstadoActivo
                                              AND APC.ESTADO             = Cv_EstadoActivo
                                              AND APC.NOMBRE_PARAMETRO   = Cv_ParametroDocEstados
                                              AND APD.DESCRIPCION        = Cv_ValorDocumentos)
        AND IDFC.FE_CREACION >= SYSDATE-2
        AND IDFC.FE_CREACION <= SYSDATE
        AND ATDF.CODIGO_TIPO_DOCUMENTO IN
          (SELECT APD.VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
          ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
          WHERE APD.ESTADO           = Cv_EstadoActivo
          AND APC.ESTADO             = Cv_EstadoActivo
          AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro
          AND APD.DESCRIPCION        = Cv_DescripcionDetalle
          AND APD.VALOR2             = Cv_ValorDocumentos
          )
        AND IDFC.NUMERO_FACTURA_SRI IS NOT NULL
        AND IDFC.ID_DOCUMENTO NOT IN 
          (SELECT IDFC_S.ID_DOCUMENTO
          FROM DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO ICE
          JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_S
          ON IDFC_S.ID_DOCUMENTO = ICE.DOCUMENTO_ID
          JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG_S
          ON IOG_S.ID_OFICINA = IDFC_S.OFICINA_ID AND IOG_S.EMPRESA_ID = Cv_CodEmpresa
          JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_S
          ON ATDF_S.ID_TIPO_DOCUMENTO = IDFC_S.TIPO_DOCUMENTO_ID
          WHERE IDFC_S.NUMERO_FACTURA_SRI = IDFC.NUMERO_FACTURA_SRI
          AND IDFC_S.FE_CREACION >= SYSDATE-2
          AND IDFC_S.FE_CREACION <= SYSDATE
          AND ATDF_S.CODIGO_TIPO_DOCUMENTO IN
          (SELECT APD.VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
          ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
          WHERE APD.ESTADO           = Cv_EstadoActivo
          AND APC.ESTADO             = Cv_EstadoActivo
          AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro
          AND APD.DESCRIPCION        = Cv_DescripcionDetalle
          AND APD.VALOR2             = Cv_ValorDocumentos
          ) )
          ORDER BY IDFC.FE_CREACION DESC
         ) DOCUMENTOS_REGULARIZAR
    GROUP BY DOCUMENTOS_REGULARIZAR.NUMERO_FACTURA_SRI
    HAVING COUNT(DOCUMENTOS_REGULARIZAR.ID_DOCUMENTO) >= 2
    ORDER BY DOCUMENTOS_REGULARIZAR.NUMERO_FACTURA_SRI;
    --
    Lv_EsOficinaFacturacion         DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE             := 'S';
    Lv_EsMatriz                     DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE                          := 'S';
    Lv_FacturaElectronica           DB_COMERCIAL.INFO_EMPRESA_GRUPO.FACTURA_ELECTRONICO%TYPE                := 'S';
    Lv_EstadoFactura                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE  := 'Pendiente';
    Lv_EstadoActivo                 DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                               := 'Activo';
    Lv_NombreParametro              DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                     := 'REPORTE_CARTERA';
    Lv_DescripcionDetalle           DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE                          := 'DOCUMENTOS_NORMALES';
    Lv_ValorFacturas                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                               := 'FACTURAS';
    Lv_CodigoNumeracion             DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE                                := 'FACE';
    Lv_ActualizarDocumento          VARCHAR2(2)                                                             := 'N';
    Lv_ObservacionHistorial         DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE                 := '';
    Lr_InfoDocumentoFinancieroHis   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Ln_ContadorFacturaRepetidas     NUMBER;
    Ln_IntIdOficina                 NUMBER;
    Ln_IntIdDocumento               NUMBER;
    Ln_IntIdPunto                   NUMBER;
    Lv_NumeracionUno                VARCHAR2(3);
    Lv_NumeracionDos                VARCHAR2(3);
    Lv_StrSecuencia                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
    Lex_Exception                   EXCEPTION;
    Lr_AdmiNumeracion               DB_FINANCIERO.FNKG_TYPES.Lr_AdmiNumeracion;
    Lr_DocumentoValidado            C_ValidacionDocumento%ROWTYPE;
    Lr_InfoDocumentoFinancieroCab   C_GetDocumentoFinanciero%ROWTYPE;
    Lrf_CursorEmpresasElectronica   DB_FINANCIERO.FNCK_CONSULTS.C_InfoEmpresaGrupo;
    Lrf_CursorDocumentosRepetidos   DB_FINANCIERO.FNCK_CONSULTS.C_DocumentosRepetidos;
    Lrf_VerificarDocsRepetidos      DB_FINANCIERO.FNCK_CONSULTS.C_DocumentosRepetidos;
    Lr_GetDocumentosRepetidas       DB_FINANCIERO.FNCK_CONSULTS.Lr_InfoDocumentosRepetidos;
    Lr_GetEmpresasElectronica       DB_FINANCIERO.FNCK_CONSULTS.Lr_InfoEmpresaGrupo;
    --
  BEGIN
    --
    --SE CONSULTAN LAS EMPRESAS QUE REALIZAN DOCUMENTOS ELECTRONICOS
    Lrf_CursorEmpresasElectronica := DB_FINANCIERO.FNCK_CONSULTS.F_GET_EMPRESA_ELECTRONICAS(Lv_EstadoActivo, Lv_FacturaElectronica);
    --
    LOOP
      --
      FETCH Lrf_CursorEmpresasElectronica INTO Lr_GetEmpresasElectronica;
      EXIT WHEN Lrf_CursorEmpresasElectronica%NOTFOUND;
      --
      IF C_GetNumeroDocSriRepetidos%ISOPEN THEN
        --
        CLOSE C_GetNumeroDocSriRepetidos;
        --
      END IF;
      --
      --SE CONSULTAN LOS NUMEROS DE DOCUMENTOS REPETIDOS POR EMPRESA
      FOR I_GetNumeroDocSriRepetidos IN C_GetNumeroDocSriRepetidos(Lr_GetEmpresasElectronica.COD_EMPRESA,
                                                                   Lv_EstadoActivo,
                                                                   Pv_ParametroTiposDoc,
                                                                   Lv_DescripcionDetalle,
                                                                   Pv_TiposDocumentos,
                                                                   Pv_ParametroEstadosDoc)
      LOOP
        --
        --CONSULTA TODOS LOS DOCUMENTOS CON LA NUMERACION REPETIDA ENCONTRADA PARA SER REGULARIZADA EXCEPTO EL PRIMER DOCUMENTO QUE SE CREO CON DICHA
        --NUMERACION
        Lrf_CursorDocumentosRepetidos := NULL;
        Lrf_CursorDocumentosRepetidos := DB_FINANCIERO.FNCK_CONSULTS.F_GET_DOCUMENTOS_REPETIDOS(Lr_GetEmpresasElectronica.COD_EMPRESA,
                                                                                                Lv_EstadoActivo,
                                                                                                Pv_ParametroTiposDoc,
                                                                                                Lv_DescripcionDetalle,
                                                                                                Pv_TiposDocumentos,
                                                                                                I_GetNumeroDocSriRepetidos.NUMERO_FACTURA_SRI,
                                                                                                NULL);
        --
        LOOP
          --
          FETCH Lrf_CursorDocumentosRepetidos INTO Lr_GetDocumentosRepetidas;
          EXIT WHEN Lrf_CursorDocumentosRepetidos%NOTFOUND;
          --
          Lr_AdmiNumeracion           := NULL;
          Lv_StrSecuencia             := I_GetNumeroDocSriRepetidos.NUMERO_FACTURA_SRI;
          Ln_IntIdOficina             := Lr_GetDocumentosRepetidas.OFICINA_ID;
          Ln_IntIdDocumento           := Lr_GetDocumentosRepetidas.ID_DOCUMENTO;
          Ln_IntIdPunto               := Lr_GetDocumentosRepetidas.PUNTO_ID;
          Lv_NumeracionUno            := SUBSTR(Lv_StrSecuencia, 1, 3);
          Lv_NumeracionDos            := SUBSTR(Lv_StrSecuencia, 5, 3);
          Ln_ContadorFacturaRepetidas := I_GetNumeroDocSriRepetidos.CONTADOR;
          Lv_ObservacionHistorial     := 'Se actualiza numeracion del documento. Numeracion Inicial(' || Lv_StrSecuencia || '). ';
          --
          --
          IF C_ValidacionDocumento%ISOPEN THEN
            --
            CLOSE C_ValidacionDocumento;
            --
          END IF;
          --
          --VALIDA QUE EL DOCUMENTO ESTE EN ESTADO PENDIENTE Y NO TENGA COMPROBANTE ELECTRONICO
          OPEN C_ValidacionDocumento(Ln_IntIdDocumento,
                                     Pv_ParametroEstadosDoc,
                                     Pv_TiposDocumentos,
                                     Lv_EstadoActivo);
          --
          FETCH C_ValidacionDocumento INTO Lr_DocumentoValidado;
          --
          CLOSE C_ValidacionDocumento;
          --
          --
          IF Lr_DocumentoValidado.ID_DOCUMENTO IS NOT NULL AND Lr_DocumentoValidado.ID_DOCUMENTO > 0 THEN
            --
            --INGRESA AL LAZO MIENTRA EXISTAN DOCUMENTOS CON NUMERACION REPETIDA
            WHILE Ln_ContadorFacturaRepetidas > 0
            LOOP
              --
              Ln_ContadorFacturaRepetidas := 0;
              --
              --OBTIENE LA NUMERACION DEL DOCUMENTO
              Lr_AdmiNumeracion := NULL;
              Lr_AdmiNumeracion := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_NUMERACION( Lv_EstadoActivo,
                                                                                      Lr_GetEmpresasElectronica.COD_EMPRESA,
                                                                                      Ln_IntIdOficina,
                                                                                      Lv_NumeracionUno,
                                                                                      Lv_NumeracionDos,
                                                                                      Pv_CodigoNumeracion,
                                                                                      Lv_EsOficinaFacturacion,
                                                                                      Lv_EsMatriz,
                                                                                      Lr_GetEmpresasElectronica.PREFIJO );
              --
              --SI TIENE NUMERACION INGRESA A BUSCAR A LA SECUENCIA QUE SERÁ ACTUALIZADA EN EL DOCUMENTO
              IF Lr_AdmiNumeracion.ID_NUMERACION IS NOT NULL AND Lr_AdmiNumeracion.ID_NUMERACION > 0 THEN
                --
                IF TRIM(Lr_AdmiNumeracion.SECUENCIA) IS NOT NULL AND TRIM(Lr_AdmiNumeracion.NUMERACION_UNO) IS NOT NULL 
                   AND TRIM(Lr_AdmiNumeracion.NUMERACION_DOS) IS NOT NULL THEN
                  --
                  Lv_StrSecuencia := TRIM(Lr_AdmiNumeracion.NUMERACION_UNO) || '-' || TRIM(Lr_AdmiNumeracion.NUMERACION_DOS) || '-' || 
                                     LPAD(TRIM(Lr_AdmiNumeracion.SECUENCIA), 9, '0');
                  --
                  --
                  Lv_ObservacionHistorial := Lv_ObservacionHistorial || 'Numeración Actualizada(' || Lv_StrSecuencia || ').';
                  --
                  --
                  UPDATE DB_COMERCIAL.ADMI_NUMERACION AN
                  SET SECUENCIA = (Lr_AdmiNumeracion.SECUENCIA + 1)
                  WHERE AN.ID_NUMERACION = Lr_AdmiNumeracion.ID_NUMERACION;
                  --
                ELSE
                  --
                  Lv_StrSecuencia := '';
                  --
                END IF;
                --
              ELSE
                --
                Lv_StrSecuencia := '';
                --
              END IF;
              --
              --
              Lv_ActualizarDocumento := 'N';
              --
              --
              IF TRIM(Lv_StrSecuencia) IS NOT NULL THEN
                --
                -- SE VERIFICA QUE NO EXISTAN DOCUMENTOS CON EL NUEVO SECUENCIAL HA ACTUALIZAR
                Lrf_VerificarDocsRepetidos := NULL;
                Lrf_VerificarDocsRepetidos := DB_FINANCIERO.FNCK_CONSULTS.F_GET_DOCUMENTOS_REPETIDOS(Lr_GetEmpresasElectronica.COD_EMPRESA,
                                                                                                     Lv_EstadoActivo,
                                                                                                     Pv_ParametroTiposDoc,
                                                                                                     Lv_DescripcionDetalle,
                                                                                                     Pv_TiposDocumentos,
                                                                                                     Lv_StrSecuencia,
                                                                                                     Ln_IntIdDocumento);
                --
                LOOP
                  --
                  FETCH Lrf_VerificarDocsRepetidos INTO Lr_GetDocumentosRepetidas;
                  EXIT WHEN Lrf_VerificarDocsRepetidos%NOTFOUND;
                  --
                  Ln_ContadorFacturaRepetidas := Ln_ContadorFacturaRepetidas + 1;
                  --
                END LOOP;
                --
                --
                IF Ln_ContadorFacturaRepetidas = 0 THEN
                  --
                  Lv_ActualizarDocumento := 'S';
                  --
                END IF;
                --
              ELSE
                --
                Lv_ActualizarDocumento := 'S';
                --
              END IF;
              --
              --
              IF TRIM(Lv_ActualizarDocumento) = 'S' THEN
 
                IF C_GetDocumentoFinanciero%ISOPEN THEN
                --
                  CLOSE C_GetDocumentoFinanciero;
                --
                END IF;
                --
                --OBTIENE EL ID_DOCUMENTO Y EL ESTADO_IMPRESION_FACT DEL DOCUMENTO A CONSULTAR
                OPEN C_GetDocumentoFinanciero(Ln_IntIdDocumento);
                --
                FETCH C_GetDocumentoFinanciero INTO Lr_InfoDocumentoFinancieroCab;
                --
                CLOSE C_GetDocumentoFinanciero;
                --
                --ACTUALIZACION DEL DOCUMENTO CON EL NUEVO SECUENCIAL
                UPDATE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                SET IDFC.NUMERO_FACTURA_SRI = Lv_StrSecuencia
                WHERE IDFC.ID_DOCUMENTO     = Ln_IntIdDocumento;
                --
                --
                --SE INSERTA HISTORIAL DE LA ACTUALIZACION DE LA NUMERACION DEL DOCUMENTO
                Pv_MensaError                                        := NULL;
                Lr_InfoDocumentoFinancieroHis                        := NULL;
                Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
                Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID           := Ln_IntIdDocumento;
                Lr_InfoDocumentoFinancieroHis.FE_CREACION            := SYSDATE;
                Lr_InfoDocumentoFinancieroHis.USR_CREACION           := 'telcos';
                Lr_InfoDocumentoFinancieroHis.ESTADO                 := TRIM(Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT);
                Lr_InfoDocumentoFinancieroHis.OBSERVACION            := Lv_ObservacionHistorial;
                --
                DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis, Pv_MensaError);
                --
                --
                BEGIN
                  --
                  IF TRIM(Pv_MensaError) IS NOT NULL THEN
                    --
                    Pv_MensaError := Pv_MensaError || ' - Error al insertar el historial de la cabecera de la factura';
                    --
                    RAISE Lex_Exception;
                    --
                  END IF;
                  --
                EXCEPTION
                WHEN Lex_Exception THEN
                  --
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                        'FNCK_TRANSACTION.P_REGULARIZAR_NUM_FACTURA_SRI', 
                                                        Pv_MensaError, 
                                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                                        SYSDATE, 
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                  --
                END;
                --
              END IF;--TRIM(Lv_ActualizarDocumento) = 'S'
              --
            END LOOP;--WHILE Ln_ContadorFacturaRepetidas > 1
            --
          ELSE
            --
            IF Ln_IntIdDocumento IS NOT NULL AND Ln_IntIdDocumento > 0 THEN
              --
              IF C_GetDocumentoFinanciero%ISOPEN THEN
                --
                CLOSE C_GetDocumentoFinanciero;
                --
              END IF;
              --
              --OBTIENE EL ID_DOCUMENTO Y EL ESTADO_IMPRESION_FACT DEL DOCUMENTO A CONSULTAR
              OPEN C_GetDocumentoFinanciero(Ln_IntIdDocumento);
              --
              FETCH C_GetDocumentoFinanciero INTO Lr_InfoDocumentoFinancieroCab;
              --
              CLOSE C_GetDocumentoFinanciero;
              --
              --
              IF Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO IS NOT NULL AND Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO > 0 THEN
                --
                IF TRIM(Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT) IS NOT NULL THEN
                  --
                  --SE INSERTA HISTORIAL DE LA ACTUALIZACION DE LA NUMERACION DEL DOCUMENTO
                  Pv_MensaError                                        := NULL;
                  Lr_InfoDocumentoFinancieroHis                        := NULL;
                  Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
                  Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID           := Ln_IntIdDocumento;
                  Lr_InfoDocumentoFinancieroHis.FE_CREACION            := SYSDATE;
                  Lr_InfoDocumentoFinancieroHis.USR_CREACION           := 'telcos';
                  Lr_InfoDocumentoFinancieroHis.ESTADO                 := TRIM(Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT);
                  Lr_InfoDocumentoFinancieroHis.OBSERVACION            := 'No se puede actualizar la numeracion debido a que no cumple el documento '
                                                                          || 'la validacion de estar en estado Pendiente y no tener comprobante '
                                                                          || 'electronico.';
                  --
                  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis, Pv_MensaError);
                  --
                  --
                  BEGIN
                    --
                    IF TRIM(Pv_MensaError) IS NOT NULL THEN
                      --
                      Pv_MensaError := Pv_MensaError || ' - Error al insertar el historial de la cabecera de la factura';
                      --
                      RAISE Lex_Exception;
                      --
                    END IF;
                    --
                  EXCEPTION
                  WHEN Lex_Exception THEN
                    --
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                          'FNCK_TRANSACTION.P_REGULARIZAR_NUM_FACTURA_SRI', 
                                                          Pv_MensaError, 
                                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                                          SYSDATE, 
                                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                    --
                  END;
                  --
                END IF;--TRIM(Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT) IS NOT NULL
                --
              END IF;--Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO IS NOT NULL AND Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO > 0
              --
            END IF;--Ln_IntIdDocumento IS NOT NULL AND Ln_IntIdDocumento > 0
            --
          END IF;--Ln_IntIdDocumento.ID_DOCUMENTO IS NOT NULL AND Ln_IntIdDocumento.ID_DOCUMENTO > 0
          --
        END LOOP;--LOOP
        --
      END LOOP;--FOR I_GetNumeroDocSriRepetidos IN C_GetNumeroDocSriRepetidos
      --
    END LOOP;--SE CONSULTAN LAS EMPRESAS QUE REALIZAN DOCUMENTOS ELECTRONICOS
    --
    --
    COMMIT;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MensaError := 'No se pudo regularizar las facturas con numeracion del SRI repetida' || SQLCODE || ' -ERROR- ' || SQLERRM;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_TRANSACTION.P_REGULARIZAR_NUM_FACTURA_SRI', 
                                          Pv_MensaError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_REGULARIZAR_NUM_FACTURA_SRI;
  --
  --

  PROCEDURE P_REVERSO_CONTRATO_X_PARAMETRO (Pv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
    TYPE                 Lt_AdmiParametroDet IS REF CURSOR RETURN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_AdmiParametroDet Lt_AdmiParametroDet;
    Lr_AdmiParametroDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lv_Mensaje           VARCHAR2(1000) := '';
    Ln_IdMotivo          DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE;
  BEGIN
    Lrf_AdmiParametroDet := DB_GENERAL.GNRLPCK_UTIL.F_GET_PARAMS_DETS(Pv_NombreParametro);
    LOOP
        FETCH Lrf_AdmiParametroDet INTO Lr_AdmiParametroDet;
        EXIT WHEN Lrf_AdmiParametroDet%NOTFOUND;

        SELECT ID_MOTIVO INTO Ln_IdMotivo FROM DB_GENERAL.ADMI_MOTIVO WHERE NOMBRE_MOTIVO = Lr_AdmiParametroDet.VALOR4;

        DB_FINANCIERO.FNCK_TRANSACTION.P_CREA_NC_X_FACT_INSTALACION(Pv_CaractContrato => Lr_AdmiParametroDet.VALOR2,
                                                                    Pv_CaractVigencia => Lr_AdmiParametroDet.VALOR3,
                                                                    Pn_IdMotivo       => Ln_IdMotivo,
                                                                    Pv_Observacion    => Lr_AdmiParametroDet.VALOR5,
                                                                    Pv_UsrCreacion    => Lr_AdmiParametroDet.VALOR6,
                                                                    Pv_EmpresaCod     => Lr_AdmiParametroDet.EMPRESA_COD,
                                                                    Pv_Mensaje        => Lv_Mensaje);
    END LOOP;
    CLOSE Lrf_AdmiParametroDet;
  EXCEPTION
    WHEN OTHERS THEN
        UTL_MAIL.SEND(sender     => 'notificaciones_telcos@telconet.ec', 
                      recipients => 'sistemas-financiero@telconet.ec', 
                      subject    => 'Error al crear Nota de Crédito', 
                      MESSAGE    => '<p>Ocurrio el siguiente error: '  || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' ||
                                                                          DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' </p>',
                      mime_type  => 'text/html; charset=UTF-8' );
  END P_REVERSO_CONTRATO_X_PARAMETRO;

  PROCEDURE P_CREA_NC_X_FACT_INSTALACION(Pv_CaractContrato IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                         Pv_CaractVigencia IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                         Pn_IdMotivo       IN  DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE,
                                         Pv_Observacion    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
                                         Pv_UsrCreacion    IN  VARCHAR2,
                                         Pv_EmpresaCod     IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_Mensaje        OUT VARCHAR2)
  IS
    --Se obtienen las facturas que tengan la característica según el tipo de contrato (WEB/MOVIL) y que su fecha de vigencia sea hoy.
    CURSOR C_ObtieneFactInstalacion (Cv_EstadoActivo   VARCHAR2,
                                     Cv_Valor          DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE,
                                     Cv_CaractContrato DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                     Cv_CaractVigencia DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                     Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE) IS
        SELECT CAB.ID_DOCUMENTO, CAB.OFICINA_ID
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB CAB,
               DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
               DB_COMERCIAL.ADMI_CARACTERISTICA AC
         WHERE CAB.ID_DOCUMENTO = IDC.DOCUMENTO_ID
           AND IDC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
           AND AC.DESCRIPCION_CARACTERISTICA = Cv_CaractContrato
           AND AC.ESTADO = Cv_EstadoActivo
           AND IDC.VALOR = Cv_Valor
           AND IDC.ESTADO = Cv_EstadoActivo
           AND CAB.ESTADO_IMPRESION_FACT = Cv_EstadoActivo
           AND 0 < (SELECT COUNT(*)
                      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC2,
                           DB_COMERCIAL.ADMI_CARACTERISTICA AC2
                     WHERE IDC2.DOCUMENTO_ID = CAB.ID_DOCUMENTO
                       AND IDC2.ESTADO = Cv_EstadoActivo
                       AND IDC2.CARACTERISTICA_ID = AC2.ID_CARACTERISTICA
                       AND AC2.DESCRIPCION_CARACTERISTICA = Cv_CaractVigencia
                       AND AC2.ESTADO = Cv_EstadoActivo
                       AND IDC2.VALOR = TO_CHAR(SYSDATE,'DD-MM-YYYY')
                   )
           AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(CAB.PUNTO_ID,NULL) = Cv_PrefijoEmpresa;

    --COSTO DEL QUERY 7
    --Cursor que obtiene el punto al que se le está realizando la factura de instalación.
    CURSOR C_GetPuntoInstalado (Pn_DocumentoId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE) IS
        SELECT DISTINCT SER.PUNTO_ID
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET DET,
               DB_COMERCIAL.INFO_SERVICIO SER
         WHERE DET.DOCUMENTO_ID = Pn_DocumentoId
           AND SER.ID_SERVICIO = DET.SERVICIO_ID;
    Ln_PuntoFacturado        DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;

    --COSTO DEL QUERY 9
    --Cursor que verifica si el punto tiene un historial de servicio Preplanificado.
    CURSOR C_GetPuntoHistPreplanificado (Pn_DocumentoId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE) IS
        SELECT DISTINCT SER.PUNTO_ID
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET DET,
               DB_COMERCIAL.INFO_SERVICIO SER,
               DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
         WHERE DET.DOCUMENTO_ID = Pn_DocumentoId
           AND SER.ID_SERVICIO = DET.SERVICIO_ID
           AND SER.ID_SERVICIO = ISH.SERVICIO_ID
           AND ISH.ESTADO = 'PrePlanificada';
    Ln_PuntoHistPreplanificado        DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Ln_ResultPuntoHistPreplan         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;


    Lv_EstadoActivo          VARCHAR2(15) := 'Activo';
    Lv_Valor                 DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE := 'S';
    Lr_AdmiTipoDocFinanciero DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE := NULL;
    Ln_ValorTotal            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Ln_IdDocumentoNC         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Lv_Observacion           VARCHAR2(3000);
    Lbool_Done               BOOLEAN;
    Lv_Mensaje               VARCHAR2(2000);
    Lv_Excepcion             DB_FINANCIERO.INFO_ERROR.DETALLE_ERROR%TYPE;
    Lv_PrefijoEmpresa        DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
    Lv_AplicaProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE;
    Le_Exception             EXCEPTION;
    Ln_Contador              NUMBER := 0;
    Lv_ObservacionHistorial  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE := 'Se aprueba la N/C automáticamente: Rechazo de contrato web';
    Lv_EstadoReverso         VARCHAR2(15) := 'Eliminado';
    Lr_ServicioHistorial     DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;

  BEGIN
    Lr_AdmiTipoDocFinanciero := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(NULL, 'NC');
    SELECT PREFIJO INTO Lv_PrefijoEmpresa FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO WHERE COD_EMPRESA = Pv_EmpresaCod;

    --Se obtienen las facturas que tengan la característica según el tipo de contrato (WEB/MOVIL) y que su fecha de vigencia sea hoy.
    FOR Lr_FactInstalacion IN C_ObtieneFactInstalacion(Cv_EstadoActivo   => Lv_EstadoActivo,
                                                       Cv_Valor          => Lv_Valor,
                                                       Cv_CaractContrato => Pv_CaractContrato,
                                                       Cv_CaractVigencia => Pv_CaractVigencia,
                                                       Cv_PrefijoEmpresa => Lv_PrefijoEmpresa)
    LOOP
        --Se Verifica si el punto tiene un servicio con historial Preplanificado
        OPEN  C_GetPuntoHistPreplanificado (Pn_DocumentoId => Lr_FactInstalacion.ID_DOCUMENTO);
        FETCH C_GetPuntoHistPreplanificado INTO Ln_ResultPuntoHistPreplan;
        IF C_GetPuntoHistPreplanificado%NOTFOUND THEN
            Ln_PuntoHistPreplanificado := 0;
        ELSE
           Ln_PuntoHistPreplanificado := Ln_ResultPuntoHistPreplan;
        END IF;
        CLOSE C_GetPuntoHistPreplanificado;

        IF Ln_PuntoHistPreplanificado = 0 THEN
        
            BEGIN
                Ln_Contador  := Ln_Contador + 1;
                Lv_Mensaje   := NULL;
                Lv_Excepcion := NULL;

                --Se crea la nota de crédito en estado pendiente y sin numeración por el valor total.
                DB_FINANCIERO.FNCK_CONSULTS.P_CREA_NOTA_CREDITO(Pn_IdDocumento         => Lr_FactInstalacion.ID_DOCUMENTO,
                                                                Pn_TipoDocumentoId     => Lr_AdmiTipoDocFinanciero.ID_TIPO_DOCUMENTO,
                                                                Pv_Observacion         => Pv_Observacion,
                                                                Pn_IdMotivo            => Pn_IdMotivo,
                                                                Pv_UsrCreacion         => Pv_UsrCreacion,
                                                                Pv_Estado              => 'Pendiente',
                                                                Pv_ValorOriginal       => 'Y',
                                                                Pv_PorcentajeServicio  => 'N',
                                                                Pn_Porcentaje          => 100,
                                                                Pv_ProporcionalPorDias => 'N',
                                                                Pv_FechaInicio         => NULL,
                                                                Pv_FechaFin            => NULL,
                                                                Pn_IdOficina           => Lr_FactInstalacion.OFICINA_ID,
                                                                Pn_IdEmpresa           => Pv_EmpresaCod,
                                                                Pn_ValorTotal          => Ln_ValorTotal,
                                                                Pn_IdDocumentoNC       => Ln_IdDocumentoNC,
                                                                Pv_ObservacionCreacion => Lv_Observacion,
                                                                Pbool_Done             => Lbool_Done,
                                                                Pv_MessageError        => Lv_Mensaje);
                IF Lv_Mensaje IS NOT NULL AND Lbool_Done = FALSE THEN
                    Lv_Excepcion := 'Error al crear N/C por instalación: Pn_IdDocumento (Factura):' || Lr_FactInstalacion.ID_DOCUMENTO ||
                                    'Pv_CaractContrato:' || Pv_CaractContrato || ' Pv_CaractVigencia:' || Pv_CaractVigencia ||
                                    ' Lv_Observacion: ' || Lv_Observacion || ' Lv_Mensaje: ' || Lv_Mensaje;
                    RAISE Le_Exception;
                END IF;

                Lv_AplicaProceso := DB_GENERAL.GNRLPCK_UTIL.F_EMPRESA_APLICA_PROCESO('NUMERACION_AUTOMATICA_NOTA_CREDITO', Pv_EmpresaCod);
                IF TRIM(Lv_AplicaProceso) = 'S' THEN
                    --Se numero automáticamente la nota de crédito.
                    DB_FINANCIERO.FNCK_TRANSACTION.P_NUMERA_NOTA_CREDITO(Pn_DocumentoId    => Ln_IdDocumentoNC,
                                                                         Pv_PrefijoEmpresa => Lv_PrefijoEmpresa,
                                                                         Pv_ObsHistorial   => Lv_ObservacionHistorial,
                                                                         Pv_UsrCreacion    => Pv_UsrCreacion,
                                                                         Pv_Mensaje        => Lv_Excepcion);
                    IF Lv_Excepcion IS NOT NULL THEN
                        Lv_Excepcion := 'Error al numerar N/C por instalación: Pn_IdDocumento (Factura):' || Lr_FactInstalacion.ID_DOCUMENTO ||
                                        'Pv_CaractContrato:' || Pv_CaractContrato || ' Pv_CaractVigencia:' || Pv_CaractVigencia ||
                                        ' Lv_Observacion: ' || Lv_Observacion || ' Lv_Mensaje: ' || Lv_Excepcion;
                        RAISE Le_Exception;
                    END IF;
                END IF;

                --Se realiza el reverso de TODAS LAS ÓRDENES DE SERVICIO del punto al que pertenece el SERVICIO que se había facturado.
                OPEN  C_GetPuntoInstalado (Pn_DocumentoId => Lr_FactInstalacion.ID_DOCUMENTO);
                FETCH C_GetPuntoInstalado INTO Ln_PuntoFacturado;
                CLOSE C_GetPuntoInstalado;

                Lv_Mensaje := NULL;
            
                --Se anulan los servicios dependientes a la factura de instalación creada inicialmente.
                DB_FINANCIERO.FNCK_TRANSACTION.P_REVERSO_SERVICIOS (Pn_PuntoId       => Ln_PuntoFacturado,
                                                                    Pv_EstadoReverso => Lv_EstadoReverso,
                                                                    Pv_UsrCreacion   => Pv_UsrCreacion,
                                                                    Pv_Mensaje       => Lv_Excepcion);

                IF Lv_Excepcion IS NOT NULL THEN
                    Lv_Excepcion := 'Error al realizar el reverso de los servicios del punto: ' ||
                                    'PUNTO_ID:' || Ln_PuntoFacturado || ' ID_DOCUMENTO:' || Lr_FactInstalacion.ID_DOCUMENTO ||
                                    ' |' || Lv_Mensaje;
                    RAISE Le_Exception;
                END IF;

                IF Ln_Contador >= 5000 THEN
                    COMMIT;
                    Ln_Contador := 0;
                END IF;
            EXCEPTION
                WHEN Le_Exception THEN
                    ROLLBACK;
                    Ln_Contador := 0;
                    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('JOB_CREA_NC_RECHAZO_CONTRATO',
                                                                'FNCK_TRANSACTION.P_CREA_NC_X_FACT_INSTALACION',
                                                                Lv_Excepcion);
            END;
        ELSE
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('JOB_CREA_NC_RECHAZO_CONTRATO',
                                                        'FNCK_TRANSACTION.P_CREA_NC_X_FACT_INSTALACION',
                                                        'No procede el reverso de instalación porque existe un Historial de Preplanificado ' ||
                                                         '- PuntoId: ' || Ln_PuntoHistPreplanificado);   
        END IF; 
    END LOOP;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('JOB_CREA_NC_RECHAZO_CONTRATO',
                                                    'FNCK_TRANSACTION.P_CREA_NC_X_FACT_INSTALACION',
                                                    'Error al crear la N/C por instalacion  - ' || SQLCODE || ' - ERROR_STACK: ' ||
                                                    DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' ||
                                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  END P_CREA_NC_X_FACT_INSTALACION;

  PROCEDURE P_REVERSO_SERVICIOS (Pn_PuntoId       IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                 Pv_EstadoReverso IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                 Pv_UsrCreacion   IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.USR_CREACION%TYPE,
                                 Pv_Mensaje       OUT VARCHAR2)
  IS
    --COSTO DEL QUERY 5
    --Cursor que obtiene los servicios relacionados a un punto.
    CURSOR C_GetServXAnular (Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
        SELECT ID_SERVICIO
          FROM DB_COMERCIAL.INFO_SERVICIO ISER
         WHERE ISER.PUNTO_ID = Cn_PuntoId;

    Lr_ServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lv_Mensaje           VARCHAR2(500);
    Le_Exception         EXCEPTION;
  BEGIN
        Pv_Mensaje := NULL;
        FOR Lr_ServXAnular IN C_GetServXAnular (Cn_PuntoId => Pn_PuntoId)
        LOOP
            UPDATE DB_COMERCIAL.INFO_SERVICIO SET ESTADO = Pv_EstadoReverso
             WHERE ID_SERVICIO = Lr_ServXAnular.ID_SERVICIO;
            --Inserto el historial en cada servicio anulado.
            Lr_ServicioHistorial                       := NULL;
            Lr_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
            Lr_ServicioHistorial.ESTADO                := Pv_EstadoReverso;
            Lr_ServicioHistorial.USR_CREACION          := Pv_UsrCreacion;
            Lr_ServicioHistorial.IP_CREACION           := '127.0.0.1';
            Lr_ServicioHistorial.OBSERVACION           := 'Se elimina el servicio debido a que ' ||
                                                          'no se realiza el pago de la factura de instalación del punto.';
            Lr_ServicioHistorial.SERVICIO_ID           := Lr_ServXAnular.ID_SERVICIO;
            DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lr_ServicioHistorial, Lv_Mensaje);

            IF Lv_Mensaje IS NOT NULL THEN
                Lv_Mensaje := 'ID_SERVICIO: ' || Lr_ServXAnular.ID_SERVICIO || ' ' || Lv_Mensaje;
                RAISE Le_Exception;
            END IF;
        END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
        Pv_Mensaje := Lv_Mensaje;
  END P_REVERSO_SERVICIOS;

  PROCEDURE P_NUMERA_NOTA_CREDITO (Pn_DocumentoId    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                   Pv_PrefijoEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                   Pv_ObsHistorial   IN  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE,
                                   Pv_UsrCreacion    IN  VARCHAR2,
                                   Pv_Mensaje        OUT VARCHAR2)
  IS
    Lrf_Numeracion                  DB_FINANCIERO.FNKG_TYPES.Lrf_AdmiNumeracion;
    Lv_MsnError                     VARCHAR2(1000);
    Lr_AdmiNumeracion               DB_FINANCIERO.FNKG_TYPES.Lr_AdmiNumeracion;
    --HISTORIAL DE LA NOTA DE CRÉDITO
    Lr_InfoDocumentoFinancieroHis   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    --NOTA DE CRÉDITO
    Lr_InfoDocumentoFinancieroCab   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lv_Numeracion                   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
    Lv_Secuencia                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
    Lv_EstadoAprobada               VARCHAR2(15) := 'Aprobada';
    Le_Error                        EXCEPTION;
    Le_NoAplica                     EXCEPTION;
  BEGIN

    Lrf_Numeracion:= DB_FINANCIERO.FNCK_CONSULTS.F_GET_NUMERACION(Pv_PrefijoEmpresa,'S','S',NULL,'NCE');
    --Se recorre la numeración obtenida.
    FETCH Lrf_Numeracion INTO Lr_AdmiNumeracion;
    Lv_Secuencia := LPAD(Lr_AdmiNumeracion.SECUENCIA,9,'0');
    Lv_Numeracion:= Lr_AdmiNumeracion.NUMERACION_UNO || '-'||Lr_AdmiNumeracion.NUMERACION_DOS||'-'||Lv_Secuencia;
    --Se cierra la numeración
    CLOSE Lrf_Numeracion;

    Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO         := Pn_DocumentoId;
    Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI   := Lv_Numeracion;
    Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:= Lv_EstadoAprobada;
    Lr_InfoDocumentoFinancieroCab.FE_EMISION           := TRUNC(SYSDATE);

    --Se actualiza los valores de la cabecera
    FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Lv_MsnError);
    IF Lv_MsnError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;

    --Se incrementa la numeración
    Lr_AdmiNumeracion.SECUENCIA:=Lr_AdmiNumeracion.SECUENCIA+1;
    FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lr_AdmiNumeracion.ID_NUMERACION,Lr_AdmiNumeracion,Lv_MsnError);
    IF Lv_MsnError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;

    --Se inserta EL HISTORIAL
    Lr_InfoDocumentoFinancieroHis                       := NULL;
    Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:= DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
    Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
    Lr_InfoDocumentoFinancieroHis.FE_CREACION           := SYSDATE;
    Lr_InfoDocumentoFinancieroHis.USR_CREACION          := Pv_UsrCreacion;
    Lr_InfoDocumentoFinancieroHis.ESTADO                := Lv_EstadoAprobada;
    Lr_InfoDocumentoFinancieroHis.OBSERVACION           := Pv_ObsHistorial;
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Lv_MsnError);
    IF Lv_MsnError IS NOT NULL THEN
        RAISE Le_Error;
    END IF;
  EXCEPTION
    WHEN Le_NoAplica THEN
        Pv_Mensaje := NULL;
    WHEN Le_Error THEN
        ROLLBACK;
        Pv_Mensaje := Lv_MsnError;
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Telcos',
                                                    'FNCK_TRANSACTION.P_NUMERA_NOTA_CREDITO',
                                                    'Error al numerar la N/C  - ' || Lv_MsnError);
    WHEN OTHERS THEN
        ROLLBACK;
        Pv_Mensaje := 'Error al numerar la N/C  - ' || SQLCODE || ' - ERROR_STACK: ' ||
                                                    DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' ||
                                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Telcos', 'FNCK_TRANSACTION.P_NUMERA_NOTA_CREDITO', Pv_Mensaje);
  END P_NUMERA_NOTA_CREDITO;

PROCEDURE FINP_ANULAPAGO(
		Pn_IdPago      IN INFO_PAGO_CAB.ID_PAGO%TYPE,
		Pv_User        IN VARCHAR2,
		Pn_IdMotivo    IN ADMI_MOTIVO.ID_MOTIVO%TYPE,
		Pv_Observacion IN VARCHAR2,
		Pv_MsnError   OUT VARCHAR2)
AS
	--
	CURSOR C_GetInfoPagos(Cn_IdPago INFO_PAGO_CAB.ID_PAGO%TYPE)
	IS
		SELECT * FROM INFO_PAGO_CAB WHERE ID_PAGO = Cn_IdPago;
	--
	CURSOR C_GetInfoPagodet(Cn_IdPago INFO_PAGO_CAB.ID_PAGO%TYPE)
	IS
		SELECT PD.REFERENCIA_ID FROM INFO_PAGO_DET PD WHERE PD.PAGO_ID = Cn_IdPago;
	--
	CURSOR C_DocumentoFinancCab(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
	IS
		SELECT  *
			FROM INFO_DOCUMENTO_FINANCIERO_CAB DFC
			WHERE DFC.ID_DOCUMENTO = Cn_IdDocumento;
	--
	Ln_IdReferencia NUMBER := 0;
	Lc_DocumentoFinacCab C_DocumentoFinancCab%ROWTYPE;
	Lc_InfoPagoCab C_GetInfoPagos%ROWTYPE;
	--
	Lv_ComentarioPago INFO_PAGO_CAB.COMENTARIO_PAGO%TYPE := NULL;
	--
BEGIN
	--
	IF C_GetInfoPagos%ISOPEN THEN
		CLOSE C_GetInfoPagos;
	END IF;
	--
	OPEN C_GetInfoPagos(Pn_IdPago);
	--
	FETCH C_GetInfoPagos INTO Lc_InfoPagoCab;
	--
	CLOSE C_GetInfoPagos;
	--
	--
	--verifica que el tipo de documento sea de tipo anticipo, anticipo sin cliente, anticipo por cruce
	IF Lc_InfoPagoCab.TIPO_DOCUMENTO_ID NOT IN (3, 4, 10) THEN
		---
		FOR IPD IN C_GetInfoPagodet(Pn_IdPago)
		LOOP
			--
			IF C_DocumentoFinancCab%ISOPEN THEN
				CLOSE C_DocumentoFinancCab;
			END IF;
			--
			OPEN C_DocumentoFinancCab(IPD.REFERENCIA_ID);
			--
			FETCH C_DocumentoFinancCab INTO Lc_DocumentoFinacCab;
			--
			CLOSE C_DocumentoFinancCab;
			--
			--verifica si el pago esta relacionado a una factura para guardar el historial del documento
			IF Lc_DocumentoFinacCab.ID_DOCUMENTO IS NOT NULL THEN
				--
				INSERT
					INTO INFO_DOCUMENTO_HISTORIAL
						(
							ID_DOCUMENTO_HISTORIAL,
							DOCUMENTO_ID,
							FE_CREACION,
							USR_CREACION,
							ESTADO,
							OBSERVACION
						)
						VALUES
						(
							SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL,
							Lc_DocumentoFinacCab.ID_DOCUMENTO,
							SYSDATE,
							Pv_User,
							'Activo',
							'Documento activado por la anulacion del pago No. '
							|| Lc_InfoPagoCab.NUMERO_PAGO
						);
				--
			END IF;
			--
			UPDATE INFO_DOCUMENTO_FINANCIERO_CAB
				SET ESTADO_IMPRESION_FACT = 'Activo'
				WHERE ID_DOCUMENTO        = IPD.REFERENCIA_ID;
			--
		END LOOP;
		--
	END IF;
	--
	--valida que el comentario de pago sea nulo, guarda la observacion escrita desde la opcion
	IF Lc_InfoPagoCab.COMENTARIO_PAGO IS NULL THEN
		--
		Lv_ComentarioPago := 'Motivo Anulacion: ' || Pv_Observacion;
		--
	ELSE
		--por falso, concatena el nuevo comentario al actual guardado en la base
		Lv_ComentarioPago := Lc_InfoPagoCab.COMENTARIO_PAGO || ' ; Motivo Anulacion: ' || Pv_Observacion;
		--
	END IF;
	--
	UPDATE INFO_PAGO_CAB
		SET ESTADO_PAGO  = 'Anulado',
			MOTIVO_ID       = Pn_IdMotivo,
			FE_ULT_MOD      = SYSDATE,
			USR_ULT_MOD     = Pv_User,
			COMENTARIO_PAGO = Lv_ComentarioPago
		WHERE ID_PAGO    = Pn_IdPago;
	--
	UPDATE INFO_PAGO_DET
		SET ESTADO    = 'Anulado',
			FE_ULT_MOD   = SYSDATE,
			USR_ULT_MOD  = Pv_User
		WHERE PAGO_ID = Pn_IdPago;
	--
	COMMIT;
	--
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	FNCK_TRANSACTION.INSERT_ERROR( 'TELCOS - ANULACION PAGOS', 'FNCK_TRANSACTION.FINP_ANULAPAGO', SQLERRM);
	Pv_MsnError := 'Error en FNCK_TRANSACTION.FINP_ANULAPAGO - ' || SQLERRM;
	--
END FINP_ANULAPAGO;
--

/**
  * Documentacion para el procedimiento P_PROCESAR_ERROR_IVA
  * Re-procesa los IVA mal calculados para los documentos rechazados FAC y FACP unicamente
  * @param PV_EMPRESA_COD      IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Tipo de dato correspondiente al código de la empresa.
  * @param PN_ID_DOCUMENTO     IN  NUMBER El id del documento. En caso que sea NULL, se realiza el proceso para todos los documentos (Aplica JOB).
  * @param PV_ESTADO           IN  VARCHAR2 El estado para realizar el filtro.
  * @param PV_USUARIO          IN  VARCHAR2 El usuario que realiza la transacción.
  * @param PV_MENSAJE          OUT VARCHAR2 El mensaje que se muestra al usuario en caso de error.
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 21-07-2015
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 04-10-2017 - Se implementa lógica para reajustar las facturas por IVA e ICE.
  *                           Se agregan los parámetros PN_ID_DOCUMENTO, PV_ESTADO, PV_USUARIO y PV_MENSAJE.
  *                           El proceso puede ser llamado desde el JOB PROCESAR_RECHAZADOS_IVA y desde funcionalidad del TELCOS.
  *                           El proceso puede ser ejecutado por empresa.
  *                           El proceso escribe en la tabla INFO_DOCUMENTO_HISTORIAL
  */

PROCEDURE P_PROCESAR_ERROR_IVA(
    PV_EMPRESA_COD  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    PN_ID_DOCUMENTO IN NUMBER,
    PV_ESTADO       IN VARCHAR2,
    PV_USUARIO      IN VARCHAR2,
    PV_MENSAJE      OUT VARCHAR2)
AS
  --Variables locales
  Ln_IdDocDetalle   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE;
  Ln_Iva            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE;
  LN_VALOR_IMPUESTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE;
  Ln_Total          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
  Ln_BanderaTotal   VARCHAR2(200);
  Ln_Porcentaje     NUMBER;
  LD_FE_EMISION     DATE;
  LN_IMPUESTO       NUMBER;
  LN_SUBTOTAL       NUMBER;
  LR_DOC_FINAN_CAB  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  LR_DOC_FINAN_IMP  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
  LR_DOCUMENTO_HIST DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
  LV_MENSAJE        VARCHAR2(200) := '';
  LE_ERROR          EXCEPTION;

  --Variables comprobantes electronicos
  PV_RUCEMPRESA VARCHAR2(200);
  PCLOB_COMPROBANTE CLOB;
  PV_NOMBRECOMPROBANTE     VARCHAR2(200);
  PV_NOMBRETIPOCOMPROBANTE VARCHAR2(200);
  PV_ANIO                  VARCHAR2(200);
  PV_MES                   VARCHAR2(200);
  PV_DIA                   VARCHAR2(200);

  --Listado de documentos a procesar
  --Los tipos de documentos 1| FACTURA , 5| FACTURA PROPORCIONAL y 6| NC unicamente procesados
  --SI TRAE ID_DOCUMENTO, HAGO EL FILTRO
  CURSOR Lc_Documentos(CD_FE_EMISION VARCHAR2, CN_ID_DOCUMENTO NUMBER, CV_ESTADO VARCHAR2)
  IS
    SELECT DISTINCT
      idfc.ID_DOCUMENTO,
      idfc.SUBTOTAL,
      idfc.SUBTOTAL_DESCUENTO,
      idfc.FE_EMISION,
      idfc.TIPO_DOCUMENTO_ID,
      idfc.VALOR_TOTAL,
      idfc.NUMERO_FACTURA_SRI
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc
    JOIN DB_FINANCIERO.INFO_MENSAJE_COMP_ELEC imce ON imce.DOCUMENTO_ID=idfc.ID_DOCUMENTO
    JOIN DB_COMERCIAL.INFO_PUNTO ip ON ip.ID_PUNTO=idfc.PUNTO_ID
    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=ip.PERSONA_EMPRESA_ROL_ID
    JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IPER.OFICINA_ID
    WHERE idfc.ESTADO_IMPRESION_FACT = CV_ESTADO
    AND idfc.TIPO_DOCUMENTO_ID       IN (1,5,6)
    AND TRUNC(idfc.FE_EMISION)       >= NVL(CD_FE_EMISION, trunc(SYSDATE, 'mm'))
    AND idfc.VALOR_TOTAL             > 0
    AND imce.INFORMACION_ADICIONAL   LIKE 'El valor en Impuesto%'
    AND idfc.ID_DOCUMENTO            = NVL(CN_ID_DOCUMENTO, idfc.ID_DOCUMENTO)
    AND IOG.EMPRESA_ID               = PV_EMPRESA_COD
    ORDER BY idfc.FE_EMISION,idfc.NUMERO_FACTURA_SRI;

  --Listado de detalles de documento
  --Parametrizar el valor correspondiente al impuesto en estado Activo
  CURSOR Lc_Detalles(Cn_IdDocumento NUMBER)
  IS
    SELECT ID_DOC_DETALLE,
           PRECIO_VENTA_FACPRO_DETALLE,
           CANTIDAD,
           DESCUENTO_FACPRO_DETALLE
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET
    WHERE DOCUMENTO_ID              = Cn_IdDocumento
    AND PRECIO_VENTA_FACPRO_DETALLE > 0;

  CURSOR LC_DETALLE_IMPUESTOS (CN_DETALLE_ID NUMBER)
  IS
    SELECT IDFI.IMPUESTO_ID,
      IDFI.VALOR_IMPUESTO,
      AI.PRIORIDAD,
      IDFI.ID_DOC_IMP,
      IDFI.PORCENTAJE,
      AI.TIPO_IMPUESTO
    FROM INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      ADMI_IMPUESTO AI
    WHERE IDFI.DETALLE_DOC_ID = CN_DETALLE_ID
    AND IDFI.IMPUESTO_ID      = AI.ID_IMPUESTO
    ORDER BY AI.PRIORIDAD ASC;

BEGIN
  --Se inicializa la bandera del cambio con N
  Ln_BanderaTotal:='N';

  --Se obtiene en porcentaje del IVA
  Ln_Porcentaje:=FNCK_FACTURACION_MENSUAL.F_OBTENER_IMPUESTO('IVA');

  --SE OBTIENE LA FECHA PARA HACER EL FILTRO, CASO CONTRARIO SE FIJA EN NULL Y APLICA PARA TODOS LOS DOCUMENTOS DEL MES.
  IF(PN_ID_DOCUMENTO IS NOT NULL) THEN
    SELECT TRUNC(FE_EMISION) INTO LD_FE_EMISION FROM INFO_DOCUMENTO_FINANCIERO_CAB WHERE ID_DOCUMENTO = PN_ID_DOCUMENTO;
  ELSE
    LD_FE_EMISION := NULL;
  END IF;

  FOR Lc_Documento IN Lc_Documentos(LD_FE_EMISION, PN_ID_DOCUMENTO, PV_ESTADO)
  LOOP
    LR_DOCUMENTO_HIST.OBSERVACION := 'REAJUSTE DEL IMPUESTO: Valor total inicial: ' || LC_DOCUMENTO.VALOR_TOTAL;
    --Ya tengo los datos de cabeceras completos
    --Accedo a los detalles para hacer el cambio del iva por detalle
    --dbms_output.put_line('Se va a procesar: '||Lc_Documento.ID_DOCUMENTO);

    --Se inicializa por cada documento
    Ln_BanderaTotal:='N';

    FOR Lc_Detalle IN Lc_Detalles (Lc_Documento.ID_DOCUMENTO)
    LOOP
      --BUSCO LOS IMPUESTOS RELACIONADOS AL DETALLE SIENDO IVA o ICE
      LN_IMPUESTO := 0;
      LN_SUBTOTAL := NVL(Lc_Detalle.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(Lc_Detalle.CANTIDAD, 0) - NVL(Lc_Detalle.DESCUENTO_FACPRO_DETALLE, 0);
      FOR LC_DET_IMP IN LC_DETALLE_IMPUESTOS (Lc_Detalle.id_doc_detalle)
      LOOP
        --SI ES ICE SE EJECUTA PRIMERO, DEBIDO A QUE EL ICE SE APLICA AL SUBTOTAL
        IF (LC_DET_IMP.TIPO_IMPUESTO = 'ICE') THEN
            LN_IMPUESTO                   := ROUND(LN_SUBTOTAL * LC_DET_IMP.PORCENTAJE / 100, 2);
            LR_DOCUMENTO_HIST.OBSERVACION := LR_DOCUMENTO_HIST.OBSERVACION || '| Se procesa detalle ICE: '
                                             || LN_IMPUESTO || ' antes: ' || LC_DET_IMP.VALOR_IMPUESTO;
        --SI ES IVA SE EJECUTA AL FINAL, DEBIDO A QUE EL IVA ES APLICADO AL SUBTOTAL + ICE
        ELSIF (LC_DET_IMP.TIPO_IMPUESTO = 'IVA') THEN
            LN_IMPUESTO                   := ROUND((LN_SUBTOTAL + LN_IMPUESTO)* LC_DET_IMP.PORCENTAJE / 100, 2);
            LR_DOCUMENTO_HIST.OBSERVACION := LR_DOCUMENTO_HIST.OBSERVACION || '| Se procesa detalle IVA: '
                                             || LN_IMPUESTO || ' antes: ' || LC_DET_IMP.VALOR_IMPUESTO;
        --SI NO CORRESPONDE A UN IMPUESTO ESTABLECIDO
        ELSE
            LN_IMPUESTO                   := LC_DET_IMP.VALOR_IMPUESTO;
        END IF;

      --Con el detalle de iva obtenido verifico si es menor al que ya esta registrado y guardo si es asi
      --dbms_output.put_line( 'Detalle a modificar: '||Lc_Detalle.id_doc_detalle || ' Impuesto modificado: ' || Ln_IdDocImp );

        IF (LC_DET_IMP.ID_DOC_IMP > 0) THEN
          --Actualizo el valor del Impuesto
          LR_DOC_FINAN_IMP.USR_ULT_MOD    := PV_USUARIO;
          LR_DOC_FINAN_IMP.FE_ULT_MOD     := SYSDATE;
          LR_DOC_FINAN_IMP.VALOR_IMPUESTO := NVL(LN_IMPUESTO, 0);
          FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_IMP (PN_ID_DOC_IMP              => LC_DET_IMP.ID_DOC_IMP,
                                                           PR_INFO_DOC_FINANCIERO_IMP => LR_DOC_FINAN_IMP,
                                                           PV_MENSAJE                 => LV_MENSAJE);
          IF (LV_MENSAJE IS NOT NULL AND LV_MENSAJE != '') THEN
            RAISE LE_ERROR;
          END IF;
          --Se actualiza el valor de la bandera ya que se modifico un registro
          Ln_BanderaTotal:='S';
        END IF;
      END LOOP;
    END LOOP;
    --Si la bandera es S se debe modificar la cabecera
    --dbms_output.put_line('Ln_BanderaTotal: '||Ln_BanderaTotal);
    IF (Ln_BanderaTotal='S') THEN

      --dbms_output.put_line('Modificado: '||Lc_Documento.ID_DOCUMENTO);

      --Despues de hacer el update hago las sumatorias para la cabecera modificar los valores
      SELECT ROUND(SUM(IDFI.VALOR_IMPUESTO), 2) AS IMPUESTO INTO LN_VALOR_IMPUESTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
      LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI
      ON IDFI.DETALLE_DOC_ID =IDFD.ID_DOC_DETALLE
      WHERE IDFD.DOCUMENTO_ID=Lc_Documento.ID_DOCUMENTO;

      --Cuando obtengo la sumatoria del iva debo actualizar valor iva y total
      Ln_Total := ROUND((NVL(Lc_Documento.subtotal, 0) - NVL(Lc_Documento.subtotal_descuento, 0)) + NVL(LN_VALOR_IMPUESTO, 0), 2);
      --dbms_output.put_line('Cabecera modificada: '||Lc_Documento.ID_DOCUMENTO|| ' valor total: '|| Ln_Total);
      LR_DOC_FINAN_CAB.SUBTOTAL_CON_IMPUESTO := LN_VALOR_IMPUESTO;
      LR_DOC_FINAN_CAB.VALOR_TOTAL           := Ln_Total;
      FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento                => Lc_Documento.ID_DOCUMENTO,
                                                      Pr_InfoDocumentoFinancieroCab => LR_DOC_FINAN_CAB,
                                                      Pv_MsnError                   => LV_MENSAJE);
      IF (LV_MENSAJE IS NOT NULL AND LV_MENSAJE != '') THEN
        RAISE LE_ERROR;
      END IF;

      --ESCRIBO EL HISTORIAL DEL DOCUMENTO
      LR_DOCUMENTO_HIST.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
      LR_DOCUMENTO_HIST.DOCUMENTO_ID           := Lc_Documento.ID_DOCUMENTO;
      LR_DOCUMENTO_HIST.FE_CREACION            := SYSDATE;
      LR_DOCUMENTO_HIST.USR_CREACION           := PV_USUARIO;
      LR_DOCUMENTO_HIST.ESTADO                 := PV_ESTADO;
      LR_DOCUMENTO_HIST.OBSERVACION            := LR_DOCUMENTO_HIST.OBSERVACION || '| Valor total final: ' || Ln_Total;
      FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Pr_InfoDocumentoHistorial => LR_DOCUMENTO_HIST,
                                                      Pv_MsnError               => LV_MENSAJE);
      IF (LV_MENSAJE IS NOT NULL AND LV_MENSAJE != '') THEN
        RAISE LE_ERROR;
      END IF;

      --Re-genera el comprobante electronico
      DB_FINANCIERO.FNCK_COM_ELECTRONICO.COMP_ELEC_CAB(Lc_Documento.id_documento,
                                                       PV_EMPRESA_COD,
                                                       Lc_Documento.tipo_documento_id,
                                                       PV_USUARIO,
                                                       'UPDATE',
                                                       PV_RUCEMPRESA,
                                                       PCLOB_COMPROBANTE,
                                                       PV_NOMBRECOMPROBANTE,
                                                       PV_NOMBRETIPOCOMPROBANTE,
                                                       PV_ANIO,
                                                       PV_MES,
                                                       PV_DIA,
                                                       LV_MENSAJE);
      IF (LV_MENSAJE IS NOT NULL AND LV_MENSAJE != '') THEN
        RAISE LE_ERROR;
      END IF;
      COMMIT;

    END IF;

  END LOOP;
  EXCEPTION
    WHEN LE_ERROR THEN
      PV_MENSAJE := 'Ha ocurrido un error inesperado.';
      ROLLBACK;
    WHEN OTHERS THEN
      PV_MENSAJE := 'Ha ocurrido un error inesperado.';
      ROLLBACK;
      FNCK_TRANSACTION.INSERT_ERROR ('FNCK_TRANSACTION', 'FNCK_TRANSACTION.P_PROCESAR_ERROR_IVA', SQLERRM);
END P_PROCESAR_ERROR_IVA;

--
PROCEDURE INSERT_ERROR(
		Pv_Aplicacion    IN INFO_ERROR.APLICACION%TYPE,
		Pv_Proceso       IN INFO_ERROR.PROCESO%TYPE,
		Pv_DetalleError  IN INFO_ERROR.DETALLE_ERROR%TYPE)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	--
	INSERT
		INTO INFO_ERROR
			(
				ID_ERROR,
				APLICACION,
				PROCESO,
				DETALLE_ERROR,
				FE_CREACION
			)
			VALUES
			(
				SEQ_INFO_ERROR.NEXTVAL,
				Pv_Aplicacion,
				Pv_Proceso,
				Pv_DetalleError,
				SYSDATE
			);
	--
	COMMIT;
	--
END INSERT_ERROR;
--
--
PROCEDURE INSERT_ANEXO_TRANSACCIONAL
	(
		Pv_Mes                IN VARCHAR2,
		Pv_Anio               IN VARCHAR2,
		Pv_AnexoTransaccional IN CLOB,
		Pv_UsrCreacion        IN VARCHAR2,
		Pv_EmpresaCod         IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
	)
IS
BEGIN
	--
	/*INSERT
		INTO INFO_ANEXO_TRANSACCIONAL
			(
				ID_ANEXO_TRANSACCIONAL,
				MES,
				ANIO,
				ANEXO_TRANSACIONAL,
				TOTAL_VENTAS,
				FE_CREACION,
				USR_CREACION,
				EMPRESA_COD
			)
			VALUES
			(
				SEQ_ANEXO_TRANSACCIONAL.NEXTVAL,
				Pv_Mes,
				Pv_Anio,
				SYS.XMLTYPE.CREATEXML(Pv_AnexoTransaccional),
				FNCK_CONSULTS.GET_TOTAL_VENTAS(Pv_EmpresaCod, TRIM('01-' || 
                                Pv_Mes || '-' || Pv_Anio), TRIM(TO_CHAR(LAST_DAY(TO_DATE('01-' || 
                                Pv_Mes || '-' || Pv_Anio, 'DD-MM-YYYY')), 'DD-MM-YYYY'))),
				SYSDATE,
				Pv_UsrCreacion,
				Pv_EmpresaCod
			);*/NULL;
	--
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	FNCK_TRANSACTION.INSERT_ERROR( 'TELCOS - ATS', 'FNCK_TRANSACTION.INSERT_ANEXO_TRANSACCIONAL', SQLERRM);
	--
END INSERT_ANEXO_TRANSACCIONAL;
--
/**
  * Documentacion para el procedimiento INSERT_INFO_DOC_FINANCIERO_CAB
  * Insert la cabecera de la factura y devuelve un mensaje en caso de haber ocurrido un error al insertar
  * @param Pr_InfoDocumentoFinancieroCab       IN  INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE Recibe un objeto como INFO_DOCUMENTO_FINANCIERO_CAB
  * @param Pv_MsnError                         OUT VARCHAR2                              Devuelve el mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  * @author Gina Villalba <gvillalba@telconet.ec>
  * Se agrega el campo 'DESCUENTO_COMPENSACION', para almanecar el valor de compensacion
  * @version 1.1 30-09-2016
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * Se Agrega el campo RANGO_CONSUMO, para almacenar el rango según el ciclo
  * @version 1.2 25-10-2017
  */
PROCEDURE INSERT_INFO_DOC_FINANCIERO_CAB
            (
              Pr_InfoDocumentoFinancieroCab IN  INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
              Pv_MsnError                   OUT VARCHAR2
            )
IS
BEGIN
  --
  INSERT
  INTO
    INFO_DOCUMENTO_FINANCIERO_CAB
    (
      ID_DOCUMENTO,
      OFICINA_ID,
      PUNTO_ID,
      TIPO_DOCUMENTO_ID,
      NUMERO_FACTURA_SRI,
      SUBTOTAL,
      SUBTOTAL_CERO_IMPUESTO,
      SUBTOTAL_CON_IMPUESTO,
      SUBTOTAL_DESCUENTO,
      VALOR_TOTAL,
      ENTREGO_RETENCION_FTE,
      ESTADO_IMPRESION_FACT,
      ES_AUTOMATICA,
      PRORRATEO,
      REACTIVACION,
      RECURRENTE,
      COMISIONA,
      FE_CREACION,
      FE_EMISION,
      USR_CREACION,
      SUBTOTAL_ICE,
      NUM_FACT_MIGRACION,
      OBSERVACION,
      REFERENCIA_DOCUMENTO_ID,
      LOGIN_MD,
      ES_ELECTRONICA,
      NUMERO_AUTORIZACION,
      FE_AUTORIZACION,
      CONTABILIZADO,
      MES_CONSUMO,
      ANIO_CONSUMO,
      RANGO_CONSUMO,
      SUBTOTAL_SERVICIOS,
      IMPUESTOS_SERVICIOS,
      SUBTOTAL_BIENES,
      IMPUESTOS_BIENES,
      DESCUENTO_COMPENSACION
    )
    VALUES
    (
      Pr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,
      Pr_InfoDocumentoFinancieroCab.OFICINA_ID,
      Pr_InfoDocumentoFinancieroCab.PUNTO_ID,
      Pr_InfoDocumentoFinancieroCab.TIPO_DOCUMENTO_ID,
      Pr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI,
      Pr_InfoDocumentoFinancieroCab.SUBTOTAL,
      Pr_InfoDocumentoFinancieroCab.SUBTOTAL_CERO_IMPUESTO,
      Pr_InfoDocumentoFinancieroCab.SUBTOTAL_CON_IMPUESTO,
      Pr_InfoDocumentoFinancieroCab.SUBTOTAL_DESCUENTO,
      Pr_InfoDocumentoFinancieroCab.VALOR_TOTAL,
      Pr_InfoDocumentoFinancieroCab.ENTREGO_RETENCION_FTE,
      Pr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT,
      Pr_InfoDocumentoFinancieroCab.ES_AUTOMATICA,
      Pr_InfoDocumentoFinancieroCab.PRORRATEO,
      Pr_InfoDocumentoFinancieroCab.REACTIVACION,
      Pr_InfoDocumentoFinancieroCab.RECURRENTE,
      Pr_InfoDocumentoFinancieroCab.COMISIONA,
      Pr_InfoDocumentoFinancieroCab.FE_CREACION,
      Pr_InfoDocumentoFinancieroCab.FE_EMISION,
      Pr_InfoDocumentoFinancieroCab.USR_CREACION,
      Pr_InfoDocumentoFinancieroCab.SUBTOTAL_ICE,
      Pr_InfoDocumentoFinancieroCab.NUM_FACT_MIGRACION,
      Pr_InfoDocumentoFinancieroCab.OBSERVACION,
      Pr_InfoDocumentoFinancieroCab.REFERENCIA_DOCUMENTO_ID,
      Pr_InfoDocumentoFinancieroCab.LOGIN_MD,
      Pr_InfoDocumentoFinancieroCab.ES_ELECTRONICA,
      Pr_InfoDocumentoFinancieroCab.NUMERO_AUTORIZACION,
      Pr_InfoDocumentoFinancieroCab.FE_AUTORIZACION,
      Pr_InfoDocumentoFinancieroCab.CONTABILIZADO,
      Pr_InfoDocumentoFinancieroCab.MES_CONSUMO,
      Pr_InfoDocumentoFinancieroCab.ANIO_CONSUMO,
      Pr_InfoDocumentoFinancieroCab.RANGO_CONSUMO,
      Pr_InfoDocumentoFinancieroCab.SUBTOTAL_SERVICIOS,
      Pr_InfoDocumentoFinancieroCab.IMPUESTOS_SERVICIOS,
      Pr_InfoDocumentoFinancieroCab.SUBTOTAL_BIENES,
      Pr_InfoDocumentoFinancieroCab.IMPUESTOS_BIENES,
      Pr_InfoDocumentoFinancieroCab.DESCUENTO_COMPENSACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR
  (
    'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB',
    SQLERRM
  )
  ;
  --
END INSERT_INFO_DOC_FINANCIERO_CAB;
--
/**
  * Documentacion para el procedimiento INSERT_INFO_DOC_FINANCIERO_DET
  * Insert los detalles de la factura y devuelve un mensaje en caso de haber ocurrido un error al insertar
  * @param Pr_InfoDocumentoFinancieroDet       IN  INSERT_INFO_DOC_FINANCIERO_DET%ROWTYPE Recibe un objeto como INSERT_INFO_DOC_FINANCIERO_DET
  * @param Pv_MsnError                         OUT VARCHAR2                              Devuelve el mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  *
  * @author Edgar Holguín <eholguín@telconet.ec>
  * @version 1.1 07-12-2017 Se agrega seteo del campo SERVICIO_ID que hace referencia al id del servicio a facturar.
  */
PROCEDURE INSERT_INFO_DOC_FINANCIERO_DET
            (
              Pr_InfoDocumentoFinancieroDet IN  INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE, 
              Pv_MsnError                   OUT VARCHAR2
            )
IS
BEGIN
  --
  INSERT
  INTO
    INFO_DOCUMENTO_FINANCIERO_DET
    (
      ID_DOC_DETALLE,
      DOCUMENTO_ID,
      PLAN_ID,
      PUNTO_ID,
      CANTIDAD,
      PRECIO_VENTA_FACPRO_DETALLE,
      PORCETANJE_DESCUENTO_FACPRO,
      DESCUENTO_FACPRO_DETALLE,
      VALOR_FACPRO_DETALLE,
      COSTO_FACPRO_DETALLE,
      OBSERVACIONES_FACTURA_DETALLE,
      FE_CREACION,
      FE_ULT_MOD,
      USR_CREACION,
      USR_ULT_MOD,
      EMPRESA_ID,
      OFICINA_ID,
      PRODUCTO_ID,
      MOTIVO_ID,
      PAGO_DET_ID,
      SERVICIO_ID
    )
    VALUES
    (
      Pr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE,
      Pr_InfoDocumentoFinancieroDet.DOCUMENTO_ID,
      Pr_InfoDocumentoFinancieroDet.PLAN_ID,
      Pr_InfoDocumentoFinancieroDet.PUNTO_ID,
      Pr_InfoDocumentoFinancieroDet.CANTIDAD,
      Pr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE,
      Pr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO,
      Pr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE,
      Pr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE,
      Pr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE,
      Pr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE,
      Pr_InfoDocumentoFinancieroDet.FE_CREACION,
      Pr_InfoDocumentoFinancieroDet.FE_ULT_MOD,
      Pr_InfoDocumentoFinancieroDet.USR_CREACION,
      Pr_InfoDocumentoFinancieroDet.USR_ULT_MOD,
      Pr_InfoDocumentoFinancieroDet.EMPRESA_ID,
      Pr_InfoDocumentoFinancieroDet.OFICINA_ID,
      Pr_InfoDocumentoFinancieroDet.PRODUCTO_ID,
      Pr_InfoDocumentoFinancieroDet.MOTIVO_ID,
      Pr_InfoDocumentoFinancieroDet.PAGO_DET_ID,
      Pr_InfoDocumentoFinancieroDet.SERVICIO_ID
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR
  (
    'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET',
    SQLERRM
  )
  ;
  --
END INSERT_INFO_DOC_FINANCIERO_DET;
--
/**
  * Documentacion para el procedimiento INSERT_INFO_DOC_FINANCIERO_IMP
  *  Insert los impuestos de la factura y devuelve un mensaje en caso de haber ocurrido un error al insertar
  * @param Pr_InfoDocumentoFinancieroImp       IN  INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE Recibe un objeto como INSERT_INFO_DOC_FINANCIERO_IMP
  * @param Pv_MsnError                         OUT VARCHAR2                              Devuelve el mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  */
PROCEDURE INSERT_INFO_DOC_FINANCIERO_IMP
            (
              Pr_InfoDocumentoFinancieroImp IN  INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE, 
              Pv_MsnError                   OUT VARCHAR2
            )
IS
BEGIN
  --
  INSERT
  INTO
    INFO_DOCUMENTO_FINANCIERO_IMP
    (
      ID_DOC_IMP,
      DETALLE_DOC_ID,
      IMPUESTO_ID,
      VALOR_IMPUESTO,
      PORCENTAJE,
      FE_CREACION,
      FE_ULT_MOD,
      USR_CREACION,
      USR_ULT_MOD
    )
    VALUES
    (
      Pr_InfoDocumentoFinancieroImp.ID_DOC_IMP,
      Pr_InfoDocumentoFinancieroImp.DETALLE_DOC_ID,
      Pr_InfoDocumentoFinancieroImp.IMPUESTO_ID,
      Pr_InfoDocumentoFinancieroImp.VALOR_IMPUESTO,
      Pr_InfoDocumentoFinancieroImp.PORCENTAJE,
      Pr_InfoDocumentoFinancieroImp.FE_CREACION,
      Pr_InfoDocumentoFinancieroImp.FE_ULT_MOD,
      Pr_InfoDocumentoFinancieroImp.USR_CREACION,
      Pr_InfoDocumentoFinancieroImp.USR_ULT_MOD
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR
  (
    'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP',
    SQLERRM
  )
  ;
  --
END INSERT_INFO_DOC_FINANCIERO_IMP;
--
/**
  * Documentacion para el procedimiento INSERT_INFO_DOC_FINANCIERO_HST
  * Inserta el historial de la factura y devuelve un mensaje en caso de haber ocurrido un error al insertar
  * @param Pr_InfoDocumentoHistorial           IN  INSERT_INFO_DOC_FINANCIERO_HST%ROWTYPE Recibe un objeto como INSERT_INFO_DOC_FINANCIERO_IMP
  * @param Pv_MsnError                         OUT VARCHAR2                              Devuelve el mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  */
PROCEDURE INSERT_INFO_DOC_FINANCIERO_HST
          (
            Pr_InfoDocumentoHistorial IN  INFO_DOCUMENTO_HISTORIAL%ROWTYPE, 
            Pv_MsnError               OUT VARCHAR2
          )
IS
BEGIN
  --
  INSERT
  INTO
    INFO_DOCUMENTO_HISTORIAL
    (
      ID_DOCUMENTO_HISTORIAL,
      DOCUMENTO_ID,
      MOTIVO_ID,
      FE_CREACION,
      USR_CREACION,
      ESTADO,
      OBSERVACION
    )
    VALUES
    (
      Pr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL,
      Pr_InfoDocumentoHistorial.DOCUMENTO_ID,
      Pr_InfoDocumentoHistorial.MOTIVO_ID,
      Pr_InfoDocumentoHistorial.FE_CREACION,
      Pr_InfoDocumentoHistorial.USR_CREACION,
      Pr_InfoDocumentoHistorial.ESTADO,
      Pr_InfoDocumentoHistorial.OBSERVACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR
  (
    'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP',
    SQLERRM
  )
  ;
END INSERT_INFO_DOC_FINANCIERO_HST;

/**
  * Documentacion para el procedimiento INSERT_INFO_DOC_FINAN_HST_MAS
  * Inserta el historial de la factura y devuelve un mensaje en caso de haber ocurrido un error al insertar
  * @param Pr_InfoDocumentoHistorial           IN  INSERT_INFO_DOC_FINANCIERO_HST%ROWTYPE Recibe un objeto como INSERT_INFO_DOC_FINANCIERO_IMP
  * @param Pv_MsnError                         OUT VARCHAR2                              Devuelve el mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  */
PROCEDURE INSERT_INFO_DOC_FINAN_HST_MAS
          (
            Pr_DocumentosAsociados IN lstSecuenciaDocumentosType,
            Pv_MsnError               OUT VARCHAR2
          ) IS
          
         LE_FORALL_EXCEPT EXCEPTION;
         PRAGMA EXCEPTION_INIT(LE_FORALL_EXCEPT, -24381);

BEGIN
  --
  FORALL idx_ IN Pr_DocumentosAsociados.FIRST..Pr_DocumentosAsociados.LAST SAVE EXCEPTIONS
  INSERT INTO INFO_DOCUMENTO_HISTORIAL
    (
      ID_DOCUMENTO_HISTORIAL,
      DOCUMENTO_ID,
      MOTIVO_ID,
      FE_CREACION,
      USR_CREACION,
      ESTADO,
      OBSERVACION
    )
    VALUES
    (
      Pr_DocumentosAsociados(idx_).secuencia,--*
      Pr_DocumentosAsociados(idx_).DOCUMENTO,
      NULL,
      SYSDATE,
      'telcos',
      Pr_DocumentosAsociados(idx_).ESTADO,
      '[Proceso contable OK | Tipo proceso: MASIVO]'
    );
  --
EXCEPTION
WHEN LE_FORALL_EXCEPT THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR
  (
    'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_DOC_FINAN_HST_MAS',
    SQLERRM
  )
  ;
END INSERT_INFO_DOC_FINAN_HST_MAS;
--
  PROCEDURE UPDATE_INFO_DOC_FINANCIERO_CAB(
      Pn_IdDocumento                IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pr_InfoDocumentoFinancieroCab IN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
      Pv_MsnError OUT VARCHAR2)
  IS
    --
  BEGIN
    --
    UPDATE INFO_DOCUMENTO_FINANCIERO_CAB
    SET OFICINA_ID            = NVL(Pr_InfoDocumentoFinancieroCab.OFICINA_ID, OFICINA_ID),
      PUNTO_ID                = NVL(Pr_InfoDocumentoFinancieroCab.PUNTO_ID, PUNTO_ID),
      TIPO_DOCUMENTO_ID       = NVL(Pr_InfoDocumentoFinancieroCab.TIPO_DOCUMENTO_ID, TIPO_DOCUMENTO_ID),
      NUMERO_FACTURA_SRI      = NVL(Pr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI, NUMERO_FACTURA_SRI),
      SUBTOTAL                = NVL(Pr_InfoDocumentoFinancieroCab.SUBTOTAL, SUBTOTAL),
      SUBTOTAL_CERO_IMPUESTO  = NVL(Pr_InfoDocumentoFinancieroCab.SUBTOTAL_CERO_IMPUESTO, SUBTOTAL_CERO_IMPUESTO),
      SUBTOTAL_CON_IMPUESTO   = NVL(Pr_InfoDocumentoFinancieroCab.SUBTOTAL_CON_IMPUESTO, SUBTOTAL_CON_IMPUESTO),
      SUBTOTAL_DESCUENTO      = NVL(Pr_InfoDocumentoFinancieroCab.SUBTOTAL_DESCUENTO, SUBTOTAL_DESCUENTO),
      VALOR_TOTAL             = NVL(Pr_InfoDocumentoFinancieroCab.VALOR_TOTAL,VALOR_TOTAL),
      ENTREGO_RETENCION_FTE   = NVL(Pr_InfoDocumentoFinancieroCab.ENTREGO_RETENCION_FTE,ENTREGO_RETENCION_FTE),
      ESTADO_IMPRESION_FACT   = NVL(Pr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT,ESTADO_IMPRESION_FACT),
      ES_AUTOMATICA           = NVL(Pr_InfoDocumentoFinancieroCab.ES_AUTOMATICA,ES_AUTOMATICA),
      PRORRATEO               = NVL(Pr_InfoDocumentoFinancieroCab.PRORRATEO,PRORRATEO),
      REACTIVACION            = NVL(Pr_InfoDocumentoFinancieroCab.REACTIVACION,REACTIVACION),
      RECURRENTE              = NVL(Pr_InfoDocumentoFinancieroCab.RECURRENTE,RECURRENTE),
      COMISIONA               = NVL(Pr_InfoDocumentoFinancieroCab.COMISIONA,COMISIONA),
      FE_CREACION             = NVL(Pr_InfoDocumentoFinancieroCab.FE_CREACION,FE_CREACION),
      FE_EMISION              = NVL(Pr_InfoDocumentoFinancieroCab.FE_EMISION,FE_EMISION),
      USR_CREACION            = NVL(Pr_InfoDocumentoFinancieroCab.USR_CREACION,USR_CREACION),
      SUBTOTAL_ICE            = NVL(Pr_InfoDocumentoFinancieroCab.SUBTOTAL_ICE,SUBTOTAL_ICE),
      NUM_FACT_MIGRACION      = NVL(Pr_InfoDocumentoFinancieroCab.NUM_FACT_MIGRACION, NUM_FACT_MIGRACION),
      OBSERVACION             = NVL(Pr_InfoDocumentoFinancieroCab.OBSERVACION, OBSERVACION),
      REFERENCIA_DOCUMENTO_ID = NVL(Pr_InfoDocumentoFinancieroCab.REFERENCIA_DOCUMENTO_ID, REFERENCIA_DOCUMENTO_ID),
      LOGIN_MD                = NVL(Pr_InfoDocumentoFinancieroCab.LOGIN_MD, LOGIN_MD),
      ES_ELECTRONICA          = NVL(Pr_InfoDocumentoFinancieroCab.ES_ELECTRONICA, ES_ELECTRONICA),
      NUMERO_AUTORIZACION     = NVL(Pr_InfoDocumentoFinancieroCab.NUMERO_AUTORIZACION, NUMERO_AUTORIZACION),
      FE_AUTORIZACION         = NVL(Pr_InfoDocumentoFinancieroCab.FE_AUTORIZACION, FE_AUTORIZACION),
      CONTABILIZADO           = NVL(Pr_InfoDocumentoFinancieroCab.CONTABILIZADO, CONTABILIZADO),
      SUBTOTAL_SERVICIOS      = NVL(Pr_InfoDocumentoFinancieroCab.SUBTOTAL_SERVICIOS, SUBTOTAL_SERVICIOS),
      IMPUESTOS_SERVICIOS     = NVL(Pr_InfoDocumentoFinancieroCab.IMPUESTOS_SERVICIOS, IMPUESTOS_SERVICIOS),
      SUBTOTAL_BIENES         = NVL(Pr_InfoDocumentoFinancieroCab.SUBTOTAL_BIENES, SUBTOTAL_BIENES),
      IMPUESTOS_BIENES        = NVL(Pr_InfoDocumentoFinancieroCab.IMPUESTOS_BIENES, IMPUESTOS_BIENES),
      DESCUENTO_COMPENSACION  = NVL(Pr_InfoDocumentoFinancieroCab.DESCUENTO_COMPENSACION, DESCUENTO_COMPENSACION)
    WHERE ID_DOCUMENTO        = Pn_IdDocumento;
    --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsnError := SQLERRM;
    FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB', SQLERRM ) ;
    --
  END UPDATE_INFO_DOC_FINANCIERO_CAB;

  /**
   * Documentación para UPDATE_INFO_DOC_FINANCIERO_IMP
   * Procedimiento que realiza el UPDATE en la tabla INFO_DOCUMENTO_FINANCIERO_CAB
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0 06-10-2017 Versión inicial
   **/
  PROCEDURE UPDATE_INFO_DOC_FINANCIERO_IMP(
      PN_ID_DOC_IMP                 IN  INFO_DOCUMENTO_FINANCIERO_IMP.ID_DOC_IMP%TYPE,
      PR_INFO_DOC_FINANCIERO_IMP    IN  INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE,
      PV_MENSAJE                    OUT VARCHAR2)
  IS
  BEGIN
    UPDATE INFO_DOCUMENTO_FINANCIERO_IMP
    SET DETALLE_DOC_ID = NVL(PR_INFO_DOC_FINANCIERO_IMP.DETALLE_DOC_ID, DETALLE_DOC_ID),
      IMPUESTO_ID      = NVL(PR_INFO_DOC_FINANCIERO_IMP.IMPUESTO_ID, IMPUESTO_ID),
      VALOR_IMPUESTO   = NVL(PR_INFO_DOC_FINANCIERO_IMP.VALOR_IMPUESTO, VALOR_IMPUESTO),
      PORCENTAJE       = NVL(PR_INFO_DOC_FINANCIERO_IMP.PORCENTAJE, PORCENTAJE),
      FE_CREACION      = NVL(PR_INFO_DOC_FINANCIERO_IMP.FE_CREACION, FE_CREACION),
      FE_ULT_MOD       = NVL(PR_INFO_DOC_FINANCIERO_IMP.FE_ULT_MOD, FE_ULT_MOD),
      USR_CREACION     = NVL(PR_INFO_DOC_FINANCIERO_IMP.USR_CREACION, USR_CREACION),
      USR_ULT_MOD      = NVL(PR_INFO_DOC_FINANCIERO_IMP.USR_ULT_MOD, USR_ULT_MOD)
    WHERE ID_DOC_IMP   = PN_ID_DOC_IMP;
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    PV_MENSAJE := SQLERRM;
    FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_IMP', SQLERRM ) ;
  END UPDATE_INFO_DOC_FINANCIERO_IMP;
--
/**
  * Documentacion para el procedimiento INSERT_INFO_PAGO_CAB
  * Iserta la cabecera del pago
  * @param Pr_InfoPagoCab                      IN  INFO_PAGO_CAB%ROWTYPE    Recibe la cabecera del pago
  * @param Pv_MsnError                         OUT VARCHAR2                 Retorna un mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  */
PROCEDURE INSERT_INFO_PAGO_CAB(
    Pr_InfoPagoCab IN  INFO_PAGO_CAB%ROWTYPE,
    Pv_MsnError    OUT VARCHAR2)
IS
  --
BEGIN
  --
  INSERT
  INTO
    INFO_PAGO_CAB
    (
      ID_PAGO,
      PUNTO_ID,
      OFICINA_ID,
      NUMERO_PAGO,
      VALOR_TOTAL,
      FE_ELIMINACION,
      ESTADO_PAGO,
      COMENTARIO_PAGO,
      FE_CREACION,
      FE_ULT_MOD,
      USR_CREACION,
      USR_ULT_MOD,
      EMPRESA_ID,
      TIPO_DOCUMENTO_ID,
      DEBITO_DET_ID,
      RECAUDACION_ID,
      NUM_PAGO_MIGRACION,
      FE_CRUCE,
      USR_CRUCE,
      ANTICIPO_ID,
      PAGO_LINEA_ID,
      LOGIN_MD,
      PAGO_ID,
      MOTIVO_ID
    )
    VALUES
    (
      Pr_InfoPagoCab.ID_PAGO,
      Pr_InfoPagoCab.PUNTO_ID,
      Pr_InfoPagoCab.OFICINA_ID,
      Pr_InfoPagoCab.NUMERO_PAGO,
      Pr_InfoPagoCab.VALOR_TOTAL,
      Pr_InfoPagoCab.FE_ELIMINACION,
      Pr_InfoPagoCab.ESTADO_PAGO,
      Pr_InfoPagoCab.COMENTARIO_PAGO,
      Pr_InfoPagoCab.FE_CREACION,
      Pr_InfoPagoCab.FE_ULT_MOD,
      Pr_InfoPagoCab.USR_CREACION,
      Pr_InfoPagoCab.USR_ULT_MOD,
      Pr_InfoPagoCab.EMPRESA_ID,
      Pr_InfoPagoCab.TIPO_DOCUMENTO_ID,
      Pr_InfoPagoCab.DEBITO_DET_ID,
      Pr_InfoPagoCab.RECAUDACION_ID,
      Pr_InfoPagoCab.NUM_PAGO_MIGRACION,
      Pr_InfoPagoCab.FE_CRUCE,
      Pr_InfoPagoCab.USR_CRUCE,
      Pr_InfoPagoCab.ANTICIPO_ID,
      Pr_InfoPagoCab.PAGO_LINEA_ID,
      Pr_InfoPagoCab.LOGIN_MD,
      Pr_InfoPagoCab.PAGO_ID,
      Pr_InfoPagoCab.MOTIVO_ID
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_PAGO_CAB', SQLERRM ) ;
  --
END INSERT_INFO_PAGO_CAB;
--
/**
  * Documentacion para el procedimiento INSERT_INFO_PAGO_DET
  * Iserta el registro envia en Pr_InfoPagoDet
  * @param Pr_InfoPagoDet  IN  INFO_PAGO_DET%ROWTYPE  Recibe un registro de la INFO_PAGO_DET
  * @param Pv_MsnError     OUT VARCHAR2               Retorna un mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 23-04-2021 Se modifica para agregar nuevo campo Tipo proceso para identificar los ANTC a contabilizar.  
  */
PROCEDURE INSERT_INFO_PAGO_DET
  (
    Pr_InfoPagoDet  IN  INFO_PAGO_DET%ROWTYPE,
    Pv_MsnError     OUT VARCHAR2
  )
IS
BEGIN
  --
  INSERT
  INTO
    INFO_PAGO_DET
    (
      ID_PAGO_DET,
      PAGO_ID,
      FORMA_PAGO_ID,
      REFERENCIA_ID,
      VALOR_PAGO,
      BANCO_TIPO_CUENTA_ID,
      NUMERO_REFERENCIA,
      FE_APLICACION,
      ESTADO,
      COMENTARIO,
      DEPOSITADO,
      DEPOSITO_PAGO_ID,
      NUMERO_CUENTA_BANCO,
      FE_CREACION,
      FE_ULT_MOD,
      USR_CREACION,
      USR_ULT_MOD,
      BANCO_CTA_CONTABLE_ID,
      FE_DEPOSITO,
      TIPO_PROCESO -- se agrega nuevo campo creado en la tabla
    )
    VALUES
    (
      Pr_InfoPagoDet.ID_PAGO_DET,
      Pr_InfoPagoDet.PAGO_ID,
      Pr_InfoPagoDet.FORMA_PAGO_ID,
      Pr_InfoPagoDet.REFERENCIA_ID,
      Pr_InfoPagoDet.VALOR_PAGO,
      Pr_InfoPagoDet.BANCO_TIPO_CUENTA_ID,
      Pr_InfoPagoDet.NUMERO_REFERENCIA,
      Pr_InfoPagoDet.FE_APLICACION,
      Pr_InfoPagoDet.ESTADO,
      Pr_InfoPagoDet.COMENTARIO,
      Pr_InfoPagoDet.DEPOSITADO,
      Pr_InfoPagoDet.DEPOSITO_PAGO_ID,
      Pr_InfoPagoDet.NUMERO_CUENTA_BANCO,
      Pr_InfoPagoDet.FE_CREACION,
      Pr_InfoPagoDet.FE_ULT_MOD,
      Pr_InfoPagoDet.USR_CREACION,
      Pr_InfoPagoDet.USR_ULT_MOD,
      Pr_InfoPagoDet.BANCO_CTA_CONTABLE_ID,
      Pr_InfoPagoDet.FE_DEPOSITO,
      NVL(Pr_InfoPagoDet.Tipo_Proceso,'Pago')
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_PAGO_DET', SQLERRM ) ;
  --
END INSERT_INFO_PAGO_DET;
--
/**
  * Documentacion para el procedimiento INSERT_INFO_PAGO_HIST
  * Iserta el registro envia en Pr_InfoPagoHist
  * @param Pr_InfoPagoHist  IN  INFO_PAGO_HISTORIAL%ROWTYPE  Recibe un registro de la INFO_PAGO_HISTORIAL
  * @param Pv_MsnError     OUT VARCHAR2               Retorna un mensaje de error
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 14-09-2015
  */
PROCEDURE INSERT_INFO_PAGO_HIST
  (
    Pr_InfoPagoHist  IN  INFO_PAGO_HISTORIAL%ROWTYPE,
    Pv_MsnError     OUT VARCHAR2
  )
IS
BEGIN
  --
  INSERT
  INTO
    INFO_PAGO_HISTORIAL
    (
      ID_PAGO_HISTORIAL,
      PAGO_ID,
      FE_CREACION,
      USR_CREACION,
      ESTADO,
      OBSERVACION
    )
    VALUES
    (
      Pr_InfoPagoHist.ID_PAGO_HISTORIAL,
      Pr_InfoPagoHist.PAGO_ID,
      Pr_InfoPagoHist.FE_CREACION,
      Pr_InfoPagoHist.USR_CREACION,
      Pr_InfoPagoHist.ESTADO,
      Pr_InfoPagoHist.OBSERVACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_PAGO_HIST', SQLERRM ) ;
  --
END INSERT_INFO_PAGO_HIST;
--
/**
  * Documentacion para el procedimiento UPDATE_ADMI_NUMERACION
  * Actualiza la secuencia de la numeracion segun el id numeracion  
  * @param Pn_IdNumeracion   IN  ADMI_NUMERACION.ID_NUMERACION%TYPE Recibe el id numeracion
  * @param Pr_AdmiNumeracion IN  ADMI_NUMERACION%ROWTYPE            Recibe el registro de la ADMI_NUMERACION
  * @param Pv_MsnError     OUT VARCHAR2                             Retorna un mensaje de error
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 15-11-2014
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 29-12-2015 - Se agregan los campos 'PROCESOS_AUTOMATICOS' y 'TIPO_ID' que fueron agregados a la tabla
  *                           'ADMI_NUMERACION'
  */
PROCEDURE UPDATE_ADMI_NUMERACION
  (
    Pn_IdNumeracion   IN  ADMI_NUMERACION.ID_NUMERACION%TYPE,
    Pr_AdmiNumeracion IN  ADMI_NUMERACION%ROWTYPE,
    Pv_MsnError       OUT VARCHAR2
  )
IS
  --
BEGIN
  --
  UPDATE
    ADMI_NUMERACION
  SET
    EMPRESA_ID           = NVL(Pr_AdmiNumeracion.EMPRESA_ID, EMPRESA_ID),
    OFICINA_ID           = NVL(Pr_AdmiNumeracion.OFICINA_ID, OFICINA_ID),
    DESCRIPCION          = NVL(Pr_AdmiNumeracion.DESCRIPCION, DESCRIPCION),
    CODIGO               = NVL(Pr_AdmiNumeracion.CODIGO, CODIGO),
    NUMERACION_UNO       = NVL(Pr_AdmiNumeracion.NUMERACION_UNO, NUMERACION_UNO),
    NUMERACION_DOS       = NVL(Pr_AdmiNumeracion.NUMERACION_DOS, NUMERACION_DOS),
    SECUENCIA            = NVL(Pr_AdmiNumeracion.SECUENCIA, SECUENCIA),
    FE_CREACION          = NVL(Pr_AdmiNumeracion.FE_CREACION, FE_CREACION),
    USR_CREACION         = NVL(Pr_AdmiNumeracion.USR_CREACION, USR_CREACION),
    FE_ULT_MOD           = NVL(Pr_AdmiNumeracion.FE_ULT_MOD, FE_ULT_MOD),
    USR_ULT_MOD          = NVL(Pr_AdmiNumeracion.USR_ULT_MOD, USR_ULT_MOD),
    TABLA                = NVL(Pr_AdmiNumeracion.TABLA, TABLA),
    ESTADO               = NVL(Pr_AdmiNumeracion.ESTADO, ESTADO),
    NUMERO_AUTORIZACION  = NVL(Pr_AdmiNumeracion.NUMERO_AUTORIZACION, NUMERO_AUTORIZACION),
    PROCESOS_AUTOMATICOS = NVL(Pr_AdmiNumeracion.PROCESOS_AUTOMATICOS, PROCESOS_AUTOMATICOS),
    TIPO_ID              = NVL(Pr_AdmiNumeracion.TIPO_ID, TIPO_ID)
  WHERE
    ID_NUMERACION = Pn_IdNumeracion;
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION', SQLERRM ) ;
  --
END UPDATE_ADMI_NUMERACION;
--
/**
  * Documentacion para el procedimiento P_DELETE_DOCUMENTO_FINANCIERO
  * Elimina un documento financiero solo si nunca ha tenido un comprobante electronico
  * @param Pn_IdDocumento   IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE   Recibe el ID del documento que se requiera eliminar
  * @param Pv_MsnError      OUT VARCHAR2                                          Retorna un mensaje de error en caso de existir uno
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 20-02-2015
  */
PROCEDURE P_DELETE_DOCUMENTO_FINANCIERO(
    Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_MsnError OUT VARCHAR2)
IS
BEGIN
  --Elimina el historial
  DELETE
  FROM
    INFO_DOCUMENTO_HISTORIAL
  WHERE
    DOCUMENTO_ID = Pn_IdDocumento;
  --Elimina los impuestos
  DELETE
  FROM
    INFO_DOCUMENTO_FINANCIERO_IMP
  WHERE
    DETALLE_DOC_ID IN
    (
      SELECT
        ID_DOC_DETALLE
      FROM
        INFO_DOCUMENTO_FINANCIERO_DET
      WHERE
        DOCUMENTO_ID = Pn_IdDocumento
    );
  --Elimina los detalles
  DELETE
  FROM
    INFO_DOCUMENTO_FINANCIERO_DET
  WHERE
    DOCUMENTO_ID = Pn_IdDocumento;
  --Elimina la cabecera del documento
  DELETE
  FROM
    INFO_DOCUMENTO_FINANCIERO_CAB
  WHERE
    ID_DOCUMENTO = Pn_IdDocumento;
  --
  COMMIT;
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION', Pv_MsnError );
  --
END P_DELETE_DOCUMENTO_FINANCIERO;
--
/**
  * Documentacion para el procedimiento INSERT_INFO_CICLO_FACTURACION
  * Inserta el registro de la ejecucion del ciclo
  * @param Pr_InfoCicloFacturacion  IN  INFO_CICLO_FACTURADO%ROWTYPE  Recibe un registro de la INFO_CICLO_FACTURADO
  * @param Pv_MsnError              OUT VARCHAR2                      Retorna un mensaje de error
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 25-02-2016
  */
PROCEDURE INSERT_INFO_CICLO_FACTURACION(
    Pr_InfoCicloFacturacion   IN  INFO_CICLO_FACTURADO%ROWTYPE,
    Pv_MsnError               OUT VARCHAR2)
IS
BEGIN
  --
  INSERT
  INTO
    INFO_CICLO_FACTURADO
    (
      ID_CICLO_FACTURADO,
      CICLO_ID,
      EMPRESA_COD,
      MES_FACTURADO,
      ANIO_FACTURADO,
      FE_EJE_INICIO,
      USR_CREACION,
      PROCESO
    )
    VALUES
    (
      Pr_InfoCicloFacturacion.ID_CICLO_FACTURADO,
      Pr_InfoCicloFacturacion.CICLO_ID,
      Pr_InfoCicloFacturacion.EMPRESA_COD,
      Pr_InfoCicloFacturacion.MES_FACTURADO,
      Pr_InfoCicloFacturacion.ANIO_FACTURADO,
      Pr_InfoCicloFacturacion.FE_EJE_INICIO,
      Pr_InfoCicloFacturacion.USR_CREACION,
      Pr_InfoCicloFacturacion.PROCESO
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.INSERT_INFO_CICLO_FACTURACION', SQLERRM ) ;
  --
END INSERT_INFO_CICLO_FACTURACION;
--
/**
  * Documentacion para el procedimiento UPDATE_INFO_CICLO_FACTURACION
  * Actualiza la cabecera de la factura y devuelve un mensaje en caso de haber ocurrido un error al actualizar
  * @param Pn_IdEjeFacturacion      IN  INFO_CICLO_FACTURADO.ID_EJE_FACTURACION%TYPE  Recibe el id_eje_ciclo para actualizar
  * @param Pr_InfoCicloFacturacion  IN  INFO_CICLO_FACTURADO%ROWTYPE                  Recibe un objeto de la INFO_CICLO_FACTURADO         
  * @param Pv_MsnError              OUT VARCHAR2                                      Devuelve el mensaje de error
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 25-02-2016
  */
PROCEDURE UPDATE_INFO_CICLO_FACTURACION(
    Pn_IdEjeFacturacion     IN  INFO_CICLO_FACTURADO.ID_CICLO_FACTURADO%TYPE,
    Pr_InfoCicloFacturacion IN  INFO_CICLO_FACTURADO%ROWTYPE,
    Pv_MsnError             OUT VARCHAR2)
IS
  --
BEGIN
  --
  UPDATE
    INFO_CICLO_FACTURADO
  SET
    CICLO_ID              = NVL(Pr_InfoCicloFacturacion.CICLO_ID, CICLO_ID),
    EMPRESA_COD           = NVL(Pr_InfoCicloFacturacion.EMPRESA_COD, EMPRESA_COD),
    MES_FACTURADO         = NVL(Pr_InfoCicloFacturacion.MES_FACTURADO, MES_FACTURADO),
    ANIO_FACTURADO        = NVL(Pr_InfoCicloFacturacion.ANIO_FACTURADO, ANIO_FACTURADO),
    FE_EJE_INICIO         = NVL(Pr_InfoCicloFacturacion.FE_EJE_INICIO, FE_EJE_INICIO),
    FE_EJE_FIN            = NVL(Pr_InfoCicloFacturacion.FE_EJE_FIN, FE_EJE_FIN),
    USR_CREACION          = NVL(Pr_InfoCicloFacturacion.USR_CREACION, USR_CREACION)
  WHERE
    ID_CICLO_FACTURADO = Pn_IdEjeFacturacion;
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.UPDATE_INFO_CICLO_FACTURACION', SQLERRM ) ;
  --
END UPDATE_INFO_CICLO_FACTURACION;
  --
  --

  PROCEDURE P_FACTURACION_SOLICITUDES (Pv_ProcesoAutomatico VARCHAR2 DEFAULT 'N')
  IS
      Lv_MensajeError         VARCHAR2(50) := '';
      Lv_NombreParamProceso   VARCHAR2(50) := 'FACTURACION_SOLICITUDES';
      Lv_EstadoPendiente      DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Pendiente';
      Lv_EstadoActivo         VARCHAR2(15) := 'Activo';
      Ln_MotivoId             NUMBER := NULL;

      CURSOR C_ObtieneSolicitudes (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                   Cv_Modulo          DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE,
                                   Cv_Proceso         DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE,
                                   Cv_EstadoCab       DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                   Cv_EstadoDet       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                   Cv_Valor6          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR6%TYPE)
      IS
        SELECT DISTINCT
            DET.VALOR1,
            DET.EMPRESA_COD,
            DET.VALOR5
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
            DB_GENERAL.ADMI_PARAMETRO_DET DET
        WHERE
            CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
            AND CAB.MODULO = Cv_Modulo
            AND CAB.PROCESO = Cv_Proceso
            AND CAB.ESTADO = Cv_EstadoCab
            AND CAB.ID_PARAMETRO = DET.PARAMETRO_ID
            AND DET.ESTADO = Cv_EstadoDet
            AND DET.VALOR6 = Cv_Valor6;
  BEGIN
      FOR Lr_Solicitudes IN C_ObtieneSolicitudes (Cv_NombreParametro => Lv_NombreParamProceso,
                                                  Cv_Modulo          => 'FINANCIERO',
                                                  Cv_Proceso         => Lv_NombreParamProceso,
                                                  Cv_EstadoCab       => Lv_EstadoActivo,
                                                  Cv_EstadoDet       => Lv_EstadoActivo,
                                                  Cv_Valor6          => Pv_ProcesoAutomatico)
      LOOP
        IF Gv_UsrProcesoMasivo = '@' THEN
           Gv_UsrProcesoMasivo := '{'||Lr_Solicitudes.VALOR5||'}';
        ELSE
           Gv_UsrProcesoMasivo := Gv_UsrProcesoMasivo||'{'||Lr_Solicitudes.VALOR5||'}';
        END IF;
        --
        DB_FINANCIERO.FNCK_TRANSACTION.P_GENERAR_FACTURAS_SOLICITUD(Pv_Estado               => Lv_EstadoPendiente,
                                                                    Pv_DescripcionSolicitud => Lr_Solicitudes.VALOR1,
                                                                    Pv_UsrCreacion          => Lr_Solicitudes.VALOR5,
                                                                    Pn_MotivoId             => Ln_MotivoId,
                                                                    Pv_EmpresaCod           => Lr_Solicitudes.EMPRESA_COD,
                                                                    Pv_MsnError             => Lv_MensajeError);
      END LOOP;
  END P_FACTURACION_SOLICITUDES;

  PROCEDURE P_GENERAR_FACTURAS_SOLICITUD(
      Pv_Estado               IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
      Pv_UsrCreacion          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pn_MotivoId             IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
      Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_EstadoServicio       IN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ESTADO%TYPE DEFAULT NULL,
      Pv_MsnError             OUT VARCHAR2)
  IS

    --Costo: 126
    CURSOR C_SolicitudesClientes( Cv_Estado               DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE, 
                                  Cn_TipoSolicitudId      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE, 
                                  Cn_MotivoId             DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
                                  Cv_PrefijoEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    IS
      SELECT IDS.ID_DETALLE_SOLICITUD,
        IDS.SERVICIO_ID,
        IDS.PRECIO_DESCUENTO,
        IDS.PORCENTAJE_DESCUENTO,
        IDS.USR_CREACION
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
           DB_COMERCIAL.INFO_SERVICIO ISER
      WHERE IDS.ESTADO          = Cv_Estado
      AND IDS.MOTIVO_ID = NVL(Cn_MotivoId, IDS.MOTIVO_ID)
      AND IDS.TIPO_SOLICITUD_ID = Cn_TipoSolicitudId
      AND ISER.ID_SERVICIO = IDS.SERVICIO_ID
      AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(NVL(ISER.PUNTO_FACTURACION_ID,ISER.PUNTO_ID),NULL) = Cv_PrefijoEmpresa
      AND NOT EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'ID_SERVICIO_REINGRESO'
                      AND DBISC.SERVICIO_ID                 = ISER.ID_SERVICIO
                      AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA);

      --
      CURSOR C_GetProducto(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
      IS
      SELECT APO.DESCRIPCION_PRODUCTO
      FROM DB_COMERCIAL.ADMI_PRODUCTO APO
      WHERE APO.ID_PRODUCTO =
        (SELECT ISE.PRODUCTO_ID
        FROM DB_COMERCIAL.INFO_SERVICIO ISE
        WHERE ISE.ID_SERVICIO = Cn_IdServicio
        );
      --
      CURSOR C_GetLogin(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
      IS
      SELECT IPU.LOGIN
      FROM DB_COMERCIAL.INFO_PUNTO IPU
      WHERE IPU.ID_PUNTO =
        (SELECT ISE.PUNTO_ID
        FROM DB_COMERCIAL.INFO_SERVICIO ISE
        WHERE ISE.ID_SERVICIO = Cn_IdServicio
        );

      --CURSOR QUE OBTIENE LA INFORMACIÓN DEL SERVICIO.
      --COSTO DEL QUERY 3
      CURSOR C_ObtieneInfoServ (Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
      IS
        SELECT ESTADO
          FROM DB_COMERCIAL.INFO_SERVICIO
         WHERE ID_SERVICIO = Cn_IdServicio;
      Lr_ObtieneInfoServ C_ObtieneInfoServ%ROWTYPE;
      --
      --Cursor que obtiene el id de la caracteristica de solicitud facturación por reubicación. 
      CURSOR C_ObtieneCaractSolFact(Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                    Cv_Estado            DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE) 
      IS
       SELECT ID_CARACTERISTICA
         FROM DB_COMERCIAL.ADMI_CARACTERISTICA
       WHERE 
         DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
         AND ESTADO                 = Cv_Estado;
      --
      --Cursor que obtiene el valor(numero_tarea) para agregar en la observación   
      CURSOR C_ObtieneNumTareaReub (Cn_DetalleSolicitudId DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                    Cv_DescripcionCaract  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                    Cv_Estado            DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE) 
      IS
        SELECT IDSC.VALOR
         FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC,
               DB_COMERCIAL.ADMI_CARACTERISTICA AC
         WHERE IDSC.DETALLE_SOLICITUD_ID     = Cn_DetalleSolicitudId
           AND IDSC.CARACTERISTICA_ID        = AC.ID_CARACTERISTICA
           AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
           AND AC.ESTADO = Cv_Estado;
      --
      --Cursor que revisa que no se debe facturar a Clientes Canal
      --Costo: 7
      CURSOR C_EsClienteAFacturar(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
      IS
        SELECT  'S' 
          FROM DB_COMERCIAL.INFO_PUNTO IPO 
          INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON IPO.ID_PUNTO = ISE.PUNTO_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPERO ON IPO.PERSONA_EMPRESA_ROL_ID = IPERO.ID_PERSONA_ROL
          INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IERO ON IPERO.EMPRESA_ROL_ID = IERO.ID_EMPRESA_ROL
          INNER JOIN DB_COMERCIAL.ADMI_ROL ARO ON ARO.ID_ROL = IERO.ROL_ID
          WHERE ISE.ID_SERVICIO = Cn_IdServicio 
          AND ARO.DESCRIPCION_ROL <> 'Cliente Canal';

      Lv_MessageError VARCHAR2(2000);
      Lv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
      Lv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
      Ln_OficinaId DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
      Ln_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
      Ln_PlanId DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE;
      Ln_ProductoId DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
      Lv_descripcionProducto DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE;
      Lv_login DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
      Ln_ProductoTempId       DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE := 0;
      Ln_PlanTempId           DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE := 0;
      Ln_ValorInstalacion     NUMBER        := 0;
      Ln_Subtotal             NUMBER        := 0;
      Ln_Descuento            NUMBER        := 0;
      Ln_PorcentajeDescuento  NUMBER        := 0;
      Ln_SubtotalConImpuesto  NUMBER        := 0;
      Ln_SubtotalConDescuento NUMBER        := 0;
      Ln_SubtotalDescuento    NUMBER        := 0;
      Ln_ValorTotal           NUMBER        := 0;
      Lv_ObservacionPlantilla DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE := '';
      Lv_ObservacionDetalle   VARCHAR2(1000) := '';
      Ln_IdPuntoFacturacion DB_COMERCIAL.INFO_SERVICIO.PUNTO_FACTURACION_ID%TYPE;
      Lv_Compensacion VARCHAR2(5)                                             := '';
      Lv_PagaIva      VARCHAR2(5)                                             := '';
      Lv_EstadoIva    VARCHAR2(10)                                            := 'Activo';
      Lv_MesConsumo          VARCHAR2(3)                                               := TO_CHAR(SYSDATE, 'MM');
      Lv_AnioConsumo         VARCHAR2(5)                                               := TO_CHAR(SYSDATE, 'YYYY');
      Ln_IdOficinaNumeracion NUMBER;
      Lr_Numeracion DB_FINANCIERO.FNKG_TYPES.Lrf_AdmiNumeracion;
      Lr_AdmiNumeracion DB_FINANCIERO.FNKG_TYPES.Lr_AdmiNumeracion;
      Lv_EsMatriz DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE                          := 'S';
      Lv_EsOficinaFacturacion DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE := 'S';
      Lv_CodigoNumeracion DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE                        := 'FACE';
      Lv_Numeracion         VARCHAR2(20)                                                          := '';
      Lv_Secuencia          VARCHAR2(20)                                                          := '';
      Ln_ContadorCommit     NUMBER                                                                := 0;
      Lr_InfoDocumentoFinancieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
      Lr_InfoDocumentoFinancieroDet DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
      Lr_InfoDocumentoFinancieroImp DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
      Lr_InfoDocumentoFinancieroHis DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
      Lr_InfoDocumentoCaracteristica DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
      Lr_DetalleSolHistorial DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
      Lo_ServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
      Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                                := 'Activo';
      Lv_TipoImpuestoCompensacion DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE                  := 'COM';
      Lex_Exception EXCEPTION;
      Ln_ValorCompensado DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE := 0;
      Ln_TipoSolicitudId DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE;
      --
      Lv_Consulta                VARCHAR2(4000);
      Lv_CadenaSelect            VARCHAR2(4000);
      Lv_CadenaFrom              VARCHAR2(4000);
      Lv_CadenaWhere             VARCHAR2(4000);        
      Lrf_GetSolicitudesClientes SYS_REFCURSOR;  
      Ln_Limit                   CONSTANT PLS_INTEGER DEFAULT 5000;
      Le_SolicitudesClientes     T_RegistrosSolicitudes;
      Ln_Indx                    NUMBER;
      Lr_CaractSolFact           C_ObtieneCaractSolFact%ROWTYPE;
      Lv_NumTareaReubicacion     VARCHAR2(50) := '';
      Ln_BanderaClienteFacturar  VARCHAR2(10) := '';

    BEGIN

      --Se obtiene el ID del tipo de solicitud y el prefijo de la empresa.
      SELECT ID_TIPO_SOLICITUD INTO Ln_TipoSolicitudId
        FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
       WHERE DESCRIPCION_SOLICITUD = Pv_DescripcionSolicitud
         AND ESTADO = Lv_EstadoActivo;

      SELECT PREFIJO INTO Lv_PrefijoEmpresa
        FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
       WHERE COD_EMPRESA = Pv_EmpresaCod;

      --Se obtiene DE LOS PARÁMETROS LA INFORMACIÓN REFERENTE A ESA SOLICITUD ESPECÍFICA.
      P_BUSCA_INFORMACION_SOLICITUD(Pv_NombreSolicitud    => Pv_DescripcionSolicitud,
                                    Pv_EmpresaCod         => Pv_EmpresaCod,
                                    Pn_PlanId             => Ln_PlanTempId,
                                    Pn_ProductoId         => Ln_ProductoTempId,
                                    Pv_ObservacionFactura => Lv_ObservacionPlantilla);
      --
      IF C_ObtieneCaractSolFact%ISOPEN THEN
        CLOSE C_ObtieneCaractSolFact;
      END IF;
      --
      IF Lrf_GetSolicitudesClientes%ISOPEN THEN    
        CLOSE Lrf_GetSolicitudesClientes;    
      END IF;
      --
      Lv_CadenaSelect := 
        ' SELECT IDS.ID_DETALLE_SOLICITUD,IDS.SERVICIO_ID,IDS.PRECIO_DESCUENTO,IDS.PORCENTAJE_DESCUENTO,IDS.USR_CREACION ';

      Lv_CadenaFrom   := 
        ' FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS, DB_COMERCIAL.INFO_SERVICIO ISER ';  

      Lv_CadenaWhere  := 
        ' WHERE IDS.ESTADO            = '''||Pv_Estado||''' '
        ||' AND IDS.TIPO_SOLICITUD_ID = '||Ln_TipoSolicitudId||' '
        ||' AND ISER.ID_SERVICIO      = IDS.SERVICIO_ID '
        ||' AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(NVL(ISER.PUNTO_FACTURACION_ID,ISER.PUNTO_ID),NULL) '
        ||' = '''||Lv_PrefijoEmpresa||''' '; 

      IF Pn_MotivoId IS NULL THEN
        Lv_CadenaWhere := Lv_CadenaWhere || ' AND IDS.MOTIVO_ID = NVL(NULL, IDS.MOTIVO_ID) '; 
      ELSE
        Lv_CadenaWhere := Lv_CadenaWhere || ' AND IDS.MOTIVO_ID = NVL('||Pn_MotivoId||', IDS.MOTIVO_ID) ';
      END IF;  

      IF Pv_DescripcionSolicitud = 'SOLICITUD FACTURACION POR REUBICACION' THEN

        Lv_CadenaFrom := Lv_CadenaFrom 
          ||', DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC, DB_COMERCIAL.ADMI_CARACTERISTICA AC, '
          ||' DB_COMUNICACION.INFO_COMUNICACION IFC, DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH ' ;

        Lv_CadenaWhere := Lv_CadenaWhere
          ||' AND IDS.ID_DETALLE_SOLICITUD      = IDSC.DETALLE_SOLICITUD_ID AND AC.ID_CARACTERISTICA = IDSC.CARACTERISTICA_ID '
          ||' AND AC.DESCRIPCION_CARACTERISTICA = ''NUMERO_TAREA_REUBICACION'' AND IDSC.VALOR = IFC.ID_COMUNICACION ' 
          ||' AND IFC.DETALLE_ID                = IDH.DETALLE_ID               AND IDH.ESTADO = ''Finalizada'' ';

      END IF; 

      Lv_Consulta := Lv_CadenaSelect || Lv_CadenaFrom || Lv_CadenaWhere ;
      --

      OPEN Lrf_GetSolicitudesClientes FOR Lv_Consulta;
      LOOP
      FETCH Lrf_GetSolicitudesClientes BULK COLLECT INTO Le_SolicitudesClientes LIMIT Ln_Limit;
        --
        Ln_Indx := Le_SolicitudesClientes.FIRST;
        --
        EXIT WHEN Le_SolicitudesClientes.COUNT = 0;
        --
       WHILE (Ln_Indx IS NOT NULL)  
       LOOP
        --Se reemplaza el texto que proviene en %VALOR% de la plantilla por el valor a presentarse.
        Lv_ObservacionDetalle := F_GET_OBSERVACION_X_PLANTILLA(Pv_Plantilla          => Lv_ObservacionPlantilla,
                                                               Pn_DetalleSolicitudId => Le_SolicitudesClientes(Ln_Indx).ID_DETALLE_SOLICITUD,
                                                               Pv_Estado             => Lv_EstadoActivo);

        --Valida si es por solicitud de reubicación consulte el número de la tarea enlazada para agregarla a la observación.                                                     
        IF Pv_DescripcionSolicitud = 'SOLICITUD FACTURACION POR REUBICACION' THEN
            --
            IF C_ObtieneNumTareaReub%ISOPEN THEN    
                CLOSE C_ObtieneNumTareaReub;    
            END IF;
            --
            OPEN C_ObtieneNumTareaReub(Le_SolicitudesClientes(Ln_Indx).ID_DETALLE_SOLICITUD,'NUMERO_TAREA_REUBICACION',Lv_EstadoActivo);
                FETCH C_ObtieneNumTareaReub INTO Lv_NumTareaReubicacion;
            CLOSE C_ObtieneNumTareaReub;

            Lv_ObservacionDetalle := Lv_ObservacionDetalle || Lv_NumTareaReubicacion;

        END IF;
        --
        -- Obtener la información correspondiente al servicio a facturar
        DB_FINANCIERO.FNCK_CONSULTS.P_GET_INFO_SERVICIO_A_FACTURAR( Le_SolicitudesClientes(Ln_Indx).SERVICIO_ID, 
                                                                    Lv_EmpresaCod, 
                                                                    Lv_PrefijoEmpresa, 
                                                                    Ln_OficinaId, 
                                                                    Ln_IdPuntoFacturacion,
                                                                    Ln_IdPunto, 
                                                                    Ln_PlanId, 
                                                                    Ln_ProductoId,
                                                                    Lv_Compensacion,
                                                                    Lv_PagaIva,
                                                                    Lv_MessageError );
        --
        --
        Ln_PorcentajeDescuento  := Le_SolicitudesClientes(Ln_Indx).PORCENTAJE_DESCUENTO;
        Ln_Subtotal             := Le_SolicitudesClientes(Ln_Indx).PRECIO_DESCUENTO;
        Ln_Descuento            := TRUNC((Ln_Subtotal * NVL(Ln_PorcentajeDescuento, 0))/100,2);
        Ln_SubtotalConDescuento := Ln_Subtotal - Ln_Descuento;
        --
        --
        IF C_EsClienteAFacturar%ISOPEN THEN    
          CLOSE C_EsClienteAFacturar;    
        END IF;
        OPEN C_EsClienteAFacturar(Le_SolicitudesClientes(Ln_Indx).SERVICIO_ID);
        FETCH C_EsClienteAFacturar INTO Ln_BanderaClienteFacturar;
        IF C_EsClienteAFacturar%NOTFOUND THEN
          Ln_BanderaClienteFacturar := 'N';
        END IF;
        CLOSE C_EsClienteAFacturar;
        --
        --
        IF Ln_SubtotalConDescuento > 0 AND Ln_BanderaClienteFacturar='S' THEN
          --SI INGRESA POR EL FLUJO DE DEMOS, SE LLENA DINÁMICAMENTE LA OBSERVACIÓN.
          IF Pv_DescripcionSolicitud = 'SOLICITUD REQUERIMIENTOS DE CLIENTES'
            AND Le_SolicitudesClientes(Ln_Indx).USR_CREACION = 'telcos_pma_demos' THEN

              --Obtengo el producto
              OPEN C_GetProducto(Le_SolicitudesClientes(Ln_Indx).SERVICIO_ID);
              FETCH C_GetProducto INTO Lv_descripcionProducto;
              CLOSE C_GetProducto;

              --Obtengo el login
              OPEN C_GetLogin(Le_SolicitudesClientes(Ln_Indx).SERVICIO_ID);
              FETCH C_GetLogin INTO Lv_login;
              CLOSE C_GetLogin;

              Lv_ObservacionDetalle  := 'DEMO '||Lv_descripcionProducto||' - '||Lv_login;
              Lv_descripcionProducto := '';
              Lv_login               := '';
          --SI NO ES NINGÚN CASO ANTES MENCIONADO, BUSCA PLAN_ID, PRODUCTO_ID Y OBSERVACIÓN EN LOS PARÁMETROS.
          ELSE
            --SI OBTIENE UN PLAN, SE VACÍA EL PRODUCTO Y SE FIJA EL NUEVO PLAN
            IF NVL(Ln_PlanTempId, 0) != 0 THEN
                Ln_ProductoId := NULL;
                Ln_PlanId     := Ln_PlanTempId;
            --SI OBTIENE UN PRODUCTO, SE VACÍA EL PLAN Y SE FIJA EL NUEVO PRODUCTO
            ELSIF NVL(Ln_ProductoTempId, 0) != 0 THEN
                Ln_ProductoId := Ln_ProductoTempId;
                Ln_PlanId     := NULL;
            END IF;
          END IF;
          --
          --
          IF Ln_IdPuntoFacturacion IS NULL THEN
            --
            Ln_IdPuntoFacturacion := Ln_IdPunto;
            --
            UPDATE DB_COMERCIAL.INFO_SERVICIO
            SET PUNTO_FACTURACION_ID = Ln_IdPunto
            WHERE ID_SERVICIO        = Le_SolicitudesClientes(Ln_Indx).SERVICIO_ID;
            --
          END IF;
          --
          --
          -- Se inserta la cabecera de la factura
          Lr_InfoDocumentoFinancieroCab                       := NULL;
          Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO          := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
          Lr_InfoDocumentoFinancieroCab.OFICINA_ID            := Ln_OficinaId;
          Lr_InfoDocumentoFinancieroCab.PUNTO_ID              := Ln_IdPuntoFacturacion;
          Lr_InfoDocumentoFinancieroCab.TIPO_DOCUMENTO_ID     := 1;
          Lr_InfoDocumentoFinancieroCab.ES_AUTOMATICA         := 'S';
          Lr_InfoDocumentoFinancieroCab.PRORRATEO             := 'N';
          Lr_InfoDocumentoFinancieroCab.REACTIVACION          := 'N';
          Lr_InfoDocumentoFinancieroCab.RECURRENTE            := 'N';
          Lr_InfoDocumentoFinancieroCab.COMISIONA             := 'S';
          Lr_InfoDocumentoFinancieroCab.FE_CREACION           := SYSDATE;
          Lr_InfoDocumentoFinancieroCab.USR_CREACION          := Pv_UsrCreacion;
          Lr_InfoDocumentoFinancieroCab.ES_ELECTRONICA        := 'S';
          Lr_InfoDocumentoFinancieroCab.MES_CONSUMO           := NULL;
          Lr_InfoDocumentoFinancieroCab.ANIO_CONSUMO          := NULL;
          Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT := 'Pendiente';
          --
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab, Pv_MsnError);
          --
          IF TRIM(Pv_MsnError) IS NOT NULL THEN
            --
            Pv_MsnError := Pv_MsnError || ' - Error al insertar la cabecera de la factura';
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
          --
          -- Con la informacion de cabecera se inserta el historial
          Lr_InfoDocumentoFinancieroHis                       := NULL;
          Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:= DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
          Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
          Lr_InfoDocumentoFinancieroHis.FE_CREACION           := SYSDATE;
          Lr_InfoDocumentoFinancieroHis.USR_CREACION          := Pv_UsrCreacion;
          Lr_InfoDocumentoFinancieroHis.ESTADO                := 'Pendiente';
          Lr_InfoDocumentoFinancieroHis.OBSERVACION           := Lv_ObservacionDetalle;
          --
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis, Pv_MsnError);
          --
          IF TRIM(Pv_MsnError) IS NOT NULL THEN
            --
            Pv_MsnError := Pv_MsnError || ' - Error al insertar el historial de la cabecera de la factura';
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
          --
          -- Se guarda el detalle de la factura
          Lr_InfoDocumentoFinancieroDet                               := NULL;
          Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID                  := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
          Lr_InfoDocumentoFinancieroDet.PUNTO_ID                      := Ln_IdPunto;
          Lr_InfoDocumentoFinancieroDet.PLAN_ID                       := Ln_PlanId;
          Lr_InfoDocumentoFinancieroDet.CANTIDAD                      := '1';
          Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE   := Ln_Subtotal;
          Lr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO   := Ln_PorcentajeDescuento;
          Lr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE      := Ln_Descuento;
          Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE          := ROUND(Ln_Subtotal, 2);
          Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE          := ROUND(Ln_Subtotal, 2);
          Lr_InfoDocumentoFinancieroDet.FE_CREACION                   := SYSDATE;
          Lr_InfoDocumentoFinancieroDet.USR_CREACION                  := Pv_UsrCreacion;
          Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                   := Ln_ProductoId;
          Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE := Lv_ObservacionDetalle;
          Lr_InfoDocumentoFinancieroDet.OFICINA_ID                    := Ln_OficinaId;
          Lr_InfoDocumentoFinancieroDet.EMPRESA_ID                    := Lv_EmpresaCod;
          Lr_InfoDocumentoFinancieroDet.SERVICIO_ID                   := Le_SolicitudesClientes(Ln_Indx).SERVICIO_ID;

          --SE INSERTAN LAS CARACTERÍSTICAS DE LA TABLA INFO_DETALLE_SOLICITUD_CARAC
          DB_FINANCIERO.FNCK_TRANSACTION.P_CLONAR_SOLICITUD_CARAC(Le_SolicitudesClientes(Ln_Indx).ID_DETALLE_SOLICITUD,
                                                                  Lr_InfoDocumentoFinancieroDet,
                                                                  Lv_PagaIva,
                                                                  Pv_MsnError);
          IF Pv_MsnError IS NOT NULL THEN
            RAISE Lex_Exception;
          END IF;
          --
          IF Pv_DescripcionSolicitud = 'SOLICITUD FACTURACION POR REUBICACION' THEN 
            IF C_ObtieneCaractSolFact%ISOPEN THEN
                CLOSE C_ObtieneCaractSolFact;
            END IF;

            OPEN  C_ObtieneCaractSolFact(Cv_DescripcionCaract => 'SOLICITUD_FACT_REUBICACION',
                                         Cv_Estado            => Lv_EstadoActivo);
            FETCH C_ObtieneCaractSolFact INTO Lr_CaractSolFact;
            CLOSE C_ObtieneCaractSolFact;  

            Lr_InfoDocumentoCaracteristica                             := NULL;
            Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID;
            Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Lr_CaractSolFact.ID_CARACTERISTICA;
            Lr_InfoDocumentoCaracteristica.VALOR                       := Le_SolicitudesClientes(Ln_Indx).ID_DETALLE_SOLICITUD;
             --La característica queda activa para poder ser visualizada en telcos
            Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;
            Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
            Lr_InfoDocumentoCaracteristica.USR_CREACION                := Pv_UsrCreacion;
            Lr_InfoDocumentoCaracteristica.IP_CREACION                 := '127.0.0.1';

            --SE INSERTA LA CARACTERÍSTICA DE SOLICITUD FACTURACIÓN POR REUBICACIÓN EN INFO_DOCUMENTO_CARACTERISTICA
            DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaracteristica, Pv_MsnError);

            IF Pv_MsnError IS NOT NULL THEN
                RAISE Lex_Exception;
            END IF;

          END IF;
          --
          -- Se actualiza la cabecera de la factura
          Ln_Subtotal            := NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_SUMAR_SUBTOTAL(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0);
          Ln_SubtotalDescuento   := TRUNC(NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_SUMAR_DESCUENTO(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0),2);
          Ln_SubtotalConImpuesto := NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.P_SUMAR_IMPUESTOS(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0);
          Ln_ValorTotal          := NVL((Ln_Subtotal - Ln_SubtotalDescuento) + Ln_SubtotalConImpuesto - Ln_ValorCompensado,0);
          --
          -- Actualizo los valores de la cabecera
          Lr_InfoDocumentoFinancieroCab.SUBTOTAL               := Ln_Subtotal;
          Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CERO_IMPUESTO := Ln_Subtotal;
          Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CON_IMPUESTO  := Ln_SubtotalConImpuesto;
          Lr_InfoDocumentoFinancieroCab.SUBTOTAL_DESCUENTO     := Ln_SubtotalDescuento;
          Lr_InfoDocumentoFinancieroCab.DESCUENTO_COMPENSACION := Ln_ValorCompensado;
          Lr_InfoDocumentoFinancieroCab.VALOR_TOTAL            := Ln_ValorTotal;
          --
          --
          IF Ln_ValorTotal > 0 AND (Lv_PrefijoEmpresa = 'EN' OR Lv_PrefijoEmpresa = 'MD') THEN
            --
            DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.GET_PREFIJO_OFICINA(Lv_EmpresaCod, Lv_PrefijoEmpresa, Ln_IdOficinaNumeracion);
            --
            --
            IF TRIM(Lv_PrefijoEmpresa) IS NOT NULL AND Ln_IdOficinaNumeracion IS NOT NULL AND Ln_IdOficinaNumeracion > 0 THEN
              --
              --Se obtiene la numeracion de la factura
              Lr_Numeracion := DB_FINANCIERO.FNCK_CONSULTS.F_GET_NUMERACION( Lv_PrefijoEmpresa,
                                                                             Lv_EsMatriz, 
                                                                             Lv_EsOficinaFacturacion, 
                                                                             Ln_IdOficinaNumeracion, 
                                                                             Lv_CodigoNumeracion );
              --
              -- Se recorre la numeracion obtenida
              LOOP
                FETCH Lr_Numeracion INTO Lr_AdmiNumeracion;
                EXIT
              WHEN Lr_Numeracion%notfound;
                --
                IF Lr_AdmiNumeracion.ID_NUMERACION IS NOT NULL AND Lr_AdmiNumeracion.ID_NUMERACION > 0 THEN
                  --
                  IF TRIM(Lr_AdmiNumeracion.SECUENCIA) IS NOT NULL AND TRIM(Lr_AdmiNumeracion.NUMERACION_UNO) IS NOT NULL 
                     AND TRIM(Lr_AdmiNumeracion.NUMERACION_DOS) IS NOT NULL THEN
                    --
                    Lv_Secuencia  := LPAD(Lr_AdmiNumeracion.SECUENCIA,9,'0');
                    Lv_Numeracion := Lr_AdmiNumeracion.NUMERACION_UNO || '-' || Lr_AdmiNumeracion.NUMERACION_DOS || '-' || Lv_Secuencia;
                    --
                    Lr_AdmiNumeracion.SECUENCIA := Lr_AdmiNumeracion.SECUENCIA + 1;
                    --
                    DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lr_AdmiNumeracion.ID_NUMERACION, Lr_AdmiNumeracion, Pv_MsnError);
                    --
                    --
                    IF TRIM(Pv_MsnError) IS NOT NULL THEN
                      --
                      Pv_MsnError := Pv_MsnError || ' - Error al actualizar la numeración';
                      --
                      RAISE Lex_Exception;
                      --
                    END IF;
                    --
                  END IF;
                  --
                END IF;
                --
              END LOOP;
              --
              CLOSE Lr_Numeracion;
              --
            END IF;
            --
            --
            Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI := Lv_Numeracion;
            --
          END IF;
          --
          --
          Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT := 'Pendiente';
          --
          -- si usuario es proceso masivo se resta un dia
          IF INSTR(Gv_UsrProcesoMasivo, Pv_UsrCreacion) > 0 THEN
            Lr_InfoDocumentoFinancieroCab.FE_EMISION            := SYSDATE-1;
          ELSE
            Lr_InfoDocumentoFinancieroCab.FE_EMISION            := SYSDATE;
          END IF;
          --
          DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB( Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO, 
                                                                         Lr_InfoDocumentoFinancieroCab, 
                                                                         Pv_MsnError );
          --
          IF TRIM(Pv_MsnError) IS NOT NULL THEN
            --
            Pv_MsnError := Pv_MsnError || ' - Error al actualizar la información de la cabecera de la factura';
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
          --
          --
          Ln_ContadorCommit := Ln_ContadorCommit + 1;
          --
        ELSE
          --
          Ln_ContadorCommit := Ln_ContadorCommit + 1;
          --
          -- INSERTO HISTORIAL DEL SERVICIO
          Lo_ServicioHistorial := NULL;
          Lo_ServicioHistorial.OBSERVACION := 'Tarifario con promoción';

          --Se obtiene el estado del servicio para almacenar su historial si no es pasado por parámetro.
          IF Pv_EstadoServicio IS NOT NULL THEN
                Lo_ServicioHistorial.ESTADO := Pv_EstadoServicio;
          ELSE
                OPEN  C_ObtieneInfoServ (Cn_IdServicio => Le_SolicitudesClientes(Ln_Indx).SERVICIO_ID);
                FETCH C_ObtieneInfoServ INTO Lr_ObtieneInfoServ;
                CLOSE C_ObtieneInfoServ;
                Lo_ServicioHistorial.ESTADO                := Lr_ObtieneInfoServ.ESTADO;
          END IF;

          Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
          Lo_ServicioHistorial.USR_CREACION          := Pv_UsrCreacion;
          Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
          Lo_ServicioHistorial.SERVICIO_ID           := Le_SolicitudesClientes(Ln_Indx).SERVICIO_ID;
          --
          DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Pv_MsnError);
          --
          --
          IF TRIM(Pv_MsnError) IS NOT NULL THEN
            --
            Pv_MsnError := Pv_MsnError || ' - Error al insertar el historial del servicio';
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
        END IF;
        --
        --
        -- Actualizo la solicitud de instalacion
        UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
        SET ESTADO                 = 'Finalizada'
        WHERE ID_DETALLE_SOLICITUD = Le_SolicitudesClientes(Ln_Indx).ID_DETALLE_SOLICITUD;
        --
        --
        -- INSERTO HISTORIAL DE LA FINALIZACION DE LA SOLICITUD
        Lr_DetalleSolHistorial                        := NULL;
        Lr_DetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
        Lr_DetalleSolHistorial.DETALLE_SOLICITUD_ID   := Le_SolicitudesClientes(Ln_Indx).ID_DETALLE_SOLICITUD;
        Lr_DetalleSolHistorial.ESTADO                 := 'Finalizada';
        Lr_DetalleSolHistorial.OBSERVACION            := 'Se finaliza la solicitud';
        Lr_DetalleSolHistorial.USR_CREACION           := Pv_UsrCreacion;
        Lr_DetalleSolHistorial.IP_CREACION            := '127.0.0.1';
        --
        DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Lr_DetalleSolHistorial, Pv_MsnError);
        --
        --
        IF TRIM(Pv_MsnError) IS NOT NULL THEN
          --
          Pv_MsnError := Pv_MsnError || ' - Error al insertar el historial de la solicitud';
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        --
        IF Ln_ContadorCommit >= 5000 THEN
          --
          Ln_ContadorCommit := 0;
          --
          COMMIT;
          --
        END IF;
        --
        Ln_Indx := Le_SolicitudesClientes.NEXT(Ln_Indx);
        --
       END LOOP; -- end loop de while
       --
      END LOOP;
      --
      --
      IF Ln_ContadorCommit < 4999 THEN
        --
        COMMIT;
        --
      END IF;
      --
      --
      CLOSE Lrf_GetSolicitudesClientes;
      --
    EXCEPTION
    WHEN Lex_Exception THEN
      --
      ROLLBACK;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNCK_TRANSACTION.P_GENERAR_FACTURAS_SOLICITUD', 
                                            Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), Pv_UsrCreacion),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
    WHEN OTHERS THEN
      --
      ROLLBACK;
      --
      Pv_MsnError := 'Error al generar las facturas por solicitudes:' || SQLCODE || ' - ERROR_STACK: ' ||
                     DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNCK_TRANSACTION.P_GENERAR_FACTURAS_SOLICITUD', 
                                            Pv_MsnError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), Pv_UsrCreacion), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
    END P_GENERAR_FACTURAS_SOLICITUD;
    --
    --
    PROCEDURE P_INSERT_INFO_DOCUMENTO_CARACT(
        Pr_InfoDocumentoCaract IN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE,
        Pv_MsnError OUT VARCHAR2)
    IS
    BEGIN
      --
      INSERT
      INTO DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA
        (
          ID_DOCUMENTO_CARACTERISTICA,
          DOCUMENTO_ID,
          CARACTERISTICA_ID,
          VALOR,
          FE_CREACION,
          USR_CREACION,
          IP_CREACION,
          ESTADO
        )
        VALUES
        (
          Pr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA,
          Pr_InfoDocumentoCaract.DOCUMENTO_ID,
          Pr_InfoDocumentoCaract.CARACTERISTICA_ID,
          Pr_InfoDocumentoCaract.VALOR,
          Pr_InfoDocumentoCaract.FE_CREACION,
          Pr_InfoDocumentoCaract.USR_CREACION,
          Pr_InfoDocumentoCaract.IP_CREACION,
          Pr_InfoDocumentoCaract.ESTADO
        );
      --
    EXCEPTION
    WHEN OTHERS THEN
      --
      ROLLBACK;
      --
      Pv_MsnError := SQLERRM;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT', 
                                            'Error al insertar la caracteristica del documento' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
    END P_INSERT_INFO_DOCUMENTO_CARACT;

    PROCEDURE P_UPDATE_INFO_DOCUMENTO_CARACT(Pr_InfoDocumentoCaract IN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE,
                                             Pv_MsnError            OUT VARCHAR2)
    IS
      Le_Exception     EXCEPTION;
      Lv_Procedimiento VARCHAR2(50) := 'FNCK_TRANSACTION.P_UPDATE_INFO_DOCUMENTO_CARACT';
      Lv_Aplicacion    VARCHAR2(15) := 'Telcos+';
    BEGIN
      IF (NVL(Pr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA, 0) = 0) THEN
        Pv_MsnError := 'Error al actualizar la característica. Parámetro Pr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA vacío.';
        RAISE Le_Exception;
      END IF;

      UPDATE DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA
         SET DOCUMENTO_ID      = NVL(Pr_InfoDocumentoCaract.DOCUMENTO_ID, DOCUMENTO_ID),
             CARACTERISTICA_ID = NVL(Pr_InfoDocumentoCaract.CARACTERISTICA_ID, CARACTERISTICA_ID),
             VALOR             = NVL(Pr_InfoDocumentoCaract.VALOR, VALOR),
             FE_ULT_MOD        = NVL(Pr_InfoDocumentoCaract.FE_ULT_MOD, FE_ULT_MOD),
             USR_ULT_MOD       = NVL(Pr_InfoDocumentoCaract.USR_ULT_MOD, USR_ULT_MOD),
             IP_ULT_MOD        = NVL(Pr_InfoDocumentoCaract.IP_ULT_MOD, IP_ULT_MOD),
             ESTADO            = NVL(Pr_InfoDocumentoCaract.ESTADO, ESTADO)
      WHERE  ID_DOCUMENTO_CARACTERISTICA = Pr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA;
    EXCEPTION
      WHEN Le_Exception THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_Aplicacion,
                                             Lv_Procedimiento,
                                             Pv_MsnError,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      WHEN OTHERS THEN
        ROLLBACK;
        Pv_MsnError := 'Error al actualizar la característica - ' || SQLCODE || ' - ERROR_STACK: '
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_Aplicacion,
                                             Lv_Procedimiento,
                                             Pv_MsnError,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END P_UPDATE_INFO_DOCUMENTO_CARACT;

    --
  --
  FUNCTION F_GET_OBSERVACION_X_PLANTILLA(Pv_Plantilla          IN  VARCHAR2,
                                         Pn_DetalleSolicitudId IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                         Pv_Estado             IN  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE DEFAULT 'Activo')
  RETURN VARCHAR2
  IS
    Lv_EtiquetaInicioFin      VARCHAR2(1) := '%';
    Ln_OcurrenciasEtiqueta    NUMBER := 0;
    Lv_ObservacionFinal       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE := Pv_Plantilla;
    Lv_ObservacionTemp        DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE;
    Ln_PrimerIndice           NUMBER;
    Ln_SegundoIndice          NUMBER;
    Lv_Caracteristica         DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE;
    Lv_EtiquetaCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE;

    CURSOR C_ObtieneValorSolCaract (Cn_DetalleSolicitudId DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                    Cv_DescripcionCaract  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                    Cv_EstadoActivo       VARCHAR2,
                                    Cv_EstadoCaract       DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE) IS
        SELECT IDSC.VALOR
          FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC,
               DB_COMERCIAL.ADMI_CARACTERISTICA AC
         WHERE IDSC.DETALLE_SOLICITUD_ID = Cn_DetalleSolicitudId
           AND IDSC.ESTADO = Cv_EstadoCaract
           AND IDSC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
           AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
           AND AC.ESTADO = Cv_EstadoActivo;
    Lr_ObtieneValorSolCaract C_ObtieneValorSolCaract%ROWTYPE;
  BEGIN
    Ln_OcurrenciasEtiqueta := REGEXP_COUNT(Pv_Plantilla, Lv_EtiquetaInicioFin);
    --Si el número de ocurrencias es mayor a cero y es par.
    IF NVL(Ln_OcurrenciasEtiqueta, 0) > 0 AND MOD(Ln_OcurrenciasEtiqueta, 2) = 0 THEN
        FOR Ln_Contador IN 1..(Ln_OcurrenciasEtiqueta/2)
        LOOP
            --Se inicializan las variables.
            Lv_Caracteristica         := '';
            Lr_ObtieneValorSolCaract  := NULL;

            --Proceso de búsqueda.
            Ln_PrimerIndice           := INSTR (Lv_ObservacionFinal, Lv_EtiquetaInicioFin);
            Lv_ObservacionTemp        := SUBSTR(Lv_ObservacionFinal, Ln_PrimerIndice + 1);
            Ln_SegundoIndice          := INSTR (Lv_ObservacionTemp,  Lv_EtiquetaInicioFin);
            Lv_ObservacionTemp        := SUBSTR(Lv_ObservacionTemp,  Ln_SegundoIndice + 1);
            Lv_Caracteristica         := SUBSTR(Lv_ObservacionFinal, Ln_PrimerIndice + 1, Ln_SegundoIndice -1);

            --Se busca la característica relacionada a la solicitud.
            OPEN  C_ObtieneValorSolCaract(Cn_DetalleSolicitudId => Pn_DetalleSolicitudId,
                                          Cv_DescripcionCaract  => Lv_Caracteristica,
                                          Cv_EstadoActivo       => 'Activo',
                                          Cv_EstadoCaract       => Pv_Estado);
            FETCH C_ObtieneValorSolCaract INTO Lr_ObtieneValorSolCaract;
            CLOSE C_ObtieneValorSolCaract;

            --Se reemplaza la etiueta de la plantilla por el de la característica.
            Lv_EtiquetaCaracteristica := Lv_EtiquetaInicioFin || Lv_Caracteristica || Lv_EtiquetaInicioFin;
            Lv_ObservacionFinal       := REPLACE (Lv_ObservacionFinal, Lv_EtiquetaCaracteristica, Lr_ObtieneValorSolCaract.VALOR);

        END LOOP;
    END IF;

    RETURN Lv_ObservacionFinal;
  EXCEPTION
    WHEN OTHERS THEN
        RETURN Lv_ObservacionFinal;
  END F_GET_OBSERVACION_X_PLANTILLA;


  PROCEDURE P_BUSCA_INFORMACION_SOLICITUD(Pv_NombreSolicitud    IN  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                          Pv_EmpresaCod         IN  DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                          Pn_PlanId             OUT DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
                                          Pn_ProductoId         OUT DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
                                          Pv_ObservacionFactura OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE)
  IS
    --CURSOR QUE OBTIENE LOS PARAMETROS EN BASE A UNA SOLICITUD DESEADA
    CURSOR C_ObtieneParametrosSolicitud (Cv_NombreParametro VARCHAR2,
                                         Cv_EstadoActivo    VARCHAR2,
                                         Cv_NombreSolicitud VARCHAR2,
                                         --Cv_UsrCreacion     VARCHAR2,
                                         Cv_EmpresaCod      VARCHAR2)
    IS
      --COSTO 4
      SELECT APD.VALOR1, --NOMBRE DE LA SOLICITUD
             APD.VALOR2, --PLAN A FACTURAR
             APD.VALOR3, --PRODUCTO A FACTURAR
             APD.VALOR4 --OBSERVACION
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
             DB_GENERAL.ADMI_PARAMETRO_CAB APC
       WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
         AND APC.ESTADO = Cv_EstadoActivo
         AND APC.ID_PARAMETRO = APD.PARAMETRO_ID
         AND APD.ESTADO = Cv_EstadoActivo
         AND APD.VALOR1 = Cv_NombreSolicitud
         --AND APD.VALOR2 = NVL(Cv_UsrCreacion, APD.VALOR2)
         AND APD.EMPRESA_COD = Cv_EmpresaCod;
    Lr_ObtieneParametrosSolicitud C_ObtieneParametrosSolicitud%ROWTYPE;

    Lv_NombreParametro            VARCHAR2(50) := 'FACTURACION_SOLICITUDES';
    Lv_EstadoActivo               VARCHAR2(15) := 'Activo';
    Lv_NombreProcedimiento        VARCHAR2(50) := 'P_BUSCA_INFORMACION_SOLICITUD';
  BEGIN
    IF C_ObtieneParametrosSolicitud%ISOPEN THEN
      CLOSE C_ObtieneParametrosSolicitud;
    END IF;

    OPEN  C_ObtieneParametrosSolicitud (Cv_NombreParametro => Lv_NombreParametro,
                                        Cv_EstadoActivo    => Lv_EstadoActivo,
                                        Cv_NombreSolicitud => Pv_NombreSolicitud,
                                        Cv_EmpresaCod      => Pv_EmpresaCod);
    FETCH C_ObtieneParametrosSolicitud INTO Lr_ObtieneParametrosSolicitud;
    CLOSE C_ObtieneParametrosSolicitud;

    Pn_PlanId             := Lr_ObtieneParametrosSolicitud.VALOR2;
    Pn_ProductoId         := Lr_ObtieneParametrosSolicitud.VALOR3;
    Pv_ObservacionFactura := Lr_ObtieneParametrosSolicitud.VALOR4;

  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                            Lv_NombreProcedimiento,
                                            'Error al obtener la información de la solicitud: ' || SQLCODE || ' - ERROR_STACK: '
                                              || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                             NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_BUSCA_INFORMACION_SOLICITUD;

  PROCEDURE P_CLONAR_SOLICITUD_CARAC (Pn_DetalleSolicitudId         IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                      Pr_InfoDocumentoFinancieroDet IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE,
                                      Pv_PagaIva                    IN  VARCHAR2,
                                      Pv_Mensaje                    OUT VARCHAR2)
  IS
    --CURSOR QUE OBTIENE LOS REGISTROS DE LA TABLA ADMI_CARACTERISTICA.
    CURSOR C_AdmiCaracteristica    (Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                    Cv_Estado            DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE) IS
      --COSTO 2
      SELECT ID_CARACTERISTICA
        FROM DB_COMERCIAL.ADMI_CARACTERISTICA
       WHERE DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
         AND ESTADO = Cv_Estado;
    Lr_AdmiCaracteristica C_AdmiCaracteristica%ROWTYPE;

    --CURSOR QUE OBTIENE LAS CARACTERÍSTICAS DE UNA SOLICITUD ESPECÍFICA QUE TENGAN EL ESTADO ENVIADO POR PARÁMETRO (Facturable)
    CURSOR C_ObtieneCaracteristicas(Cn_DetalleSolicitudId DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                    Cv_Estado             DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                    Cn_CaracteristicaId   DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.CARACTERISTICA_ID%TYPE DEFAULT NULL,
                                    Cv_EstadoActivo       VARCHAR2 DEFAULT 'Activo',
                                    Cv_CaractDetalle      DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE DEFAULT 'CANTIDAD_DETALLE')
    IS
      --COSTO 5
      SELECT CARACT.CARACTERISTICA_ID,
             CARACT.VALOR,
             CARACT.ESTADO,
             CARACT.USR_CREACION,
             NVL((SELECT IDSC.VALOR
                FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
               WHERE AC.DESCRIPCION_CARACTERISTICA = Cv_CaractDetalle
                 AND AC.ESTADO = Cv_EstadoActivo
                 AND IDSC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
                 AND IDSC.ESTADO = Cv_EstadoActivo
                 AND IDSC.DETALLE_SOLICITUD_ID = Cn_DetalleSolicitudId
                 AND IDSC.DETALLE_SOL_CARACT_ID = CARACT.ID_SOLICITUD_CARACTERISTICA),1) AS CANTIDAD
        FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT CARACT
       WHERE CARACT.DETALLE_SOLICITUD_ID = Cn_DetalleSolicitudId
         AND CARACT.ESTADO = Cv_Estado
         AND CARACT.CARACTERISTICA_ID = NVL(Cn_CaracteristicaId, CARACT.CARACTERISTICA_ID);

    --CURSOR QUE OBTIENE LOS PRODUCTOS/PLANES A FACTURAR EN EL DETALLE DE LA FACTURA DE LA SOLICITUD.
    CURSOR C_ObtieneProdPlan (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                              Cv_EstadoCab       DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                              Cv_EstadoDet       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                              Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                              Cv_Valor3          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE) IS
      --COSTO DEL QUERY 4
      SELECT DET.DESCRIPCION, DET.VALOR1, DET.VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
       WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
         AND CAB.ESTADO = Cv_EstadoCab
         AND CAB.ID_PARAMETRO = DET.PARAMETRO_ID
         AND DET.ESTADO = Cv_EstadoDet
         AND EMPRESA_COD = Cv_EmpresaCod
         AND VALOR3 = Cv_Valor3;

    Lr_ObtieneProdPlan             C_ObtieneProdPlan%ROWTYPE := NULL;
    Lr_FacturaDetallada            C_ObtieneCaracteristicas%ROWTYPE := NULL;
    Lr_NotaDeCredito               C_ObtieneCaracteristicas%ROWTYPE := NULL;
    Lr_InfoDocumentoCaracteristica DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
    Lr_InfoDocumentoFinancieroDet  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
    Le_Exception                   EXCEPTION;
    Lv_EstadoActivo                VARCHAR2(15)  := 'Activo';
    Lv_MensajeError                VARCHAR2(100) := 'Ocurrió un error al clonar las características de la solicitud al documento:';
    Ln_Indice                      NUMBER        := 0;
    Ln_PlanId                      DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE;
    Ln_ProductoId                  DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
    Ln_Subtotal                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE;

  BEGIN
    --SE OBTIENE LA CARACTERISTICA DE FACTURACION DETALLADA
    OPEN  C_AdmiCaracteristica(Cv_DescripcionCaract => 'FACTURACION DETALLADA',
                               Cv_Estado            => Lv_EstadoActivo);
    FETCH C_AdmiCaracteristica INTO Lr_AdmiCaracteristica;
    CLOSE C_AdmiCaracteristica;

    --SE OBTIENE SI LA SOLICITUD REALIZA LA FACTURACIÓN DETALLADA O NO.
    OPEN  C_ObtieneCaracteristicas(Cn_DetalleSolicitudId => Pn_DetalleSolicitudId,
                                   Cv_Estado             => Lv_EstadoActivo,
                                   Cn_CaracteristicaId   => Lr_AdmiCaracteristica.ID_CARACTERISTICA);
    FETCH C_ObtieneCaracteristicas INTO Lr_FacturaDetallada;
    Lr_FacturaDetallada.VALOR      := NVL(Lr_FacturaDetallada.VALOR, 'N');
    CLOSE C_ObtieneCaracteristicas;

    --Se asigna el PlanId y el ProductoId enviados por parámetro.
    Ln_PlanId      := Pr_InfoDocumentoFinancieroDet.PLAN_ID;
    Ln_ProductoId  := Pr_InfoDocumentoFinancieroDet.PRODUCTO_ID;
    Ln_Subtotal    := Pr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE;

    --SE ITERAN LAS CARACTERÍSTICAS DE LA SOLICITUD
    FOR Lr_ObtieneSolCarac IN C_ObtieneCaracteristicas(Cn_DetalleSolicitudId => Pn_DetalleSolicitudId,
                                                       Cv_Estado             => 'Facturable',
                                                       Cn_CaracteristicaId   => NULL)
    LOOP
        --Si la solicitud aplica a la facturación detallada, clona las características como detalles según el  parámetro 
        IF 'S' = Lr_FacturaDetallada.VALOR THEN
            --Obtiene la información de los parámetros.
            OPEN  C_ObtieneProdPlan (Cv_NombreParametro => 'FACTURACION SOLICITUD DETALLADA',
                                     Cv_EstadoCab       => Lv_EstadoActivo,
                                     Cv_EstadoDet       => Lv_EstadoActivo,
                                     Cv_EmpresaCod      => Pr_InfoDocumentoFinancieroDet.EMPRESA_ID,
                                     Cv_Valor3          => Lr_ObtieneSolCarac.CARACTERISTICA_ID);
            FETCH C_ObtieneProdPlan INTO Lr_ObtieneProdPlan;
            CLOSE C_ObtieneProdPlan;
            Ln_ProductoId  := Lr_ObtieneProdPlan.VALOR1;
            Ln_PlanId      := Lr_ObtieneProdPlan.VALOR2;
            Ln_Subtotal    := Lr_ObtieneSolCarac.VALOR;
        ELSE
            --Caso contrario, se clonan las características de la solicitud como características de la factura.
            Lr_InfoDocumentoCaracteristica                             := NULL;
            Pv_Mensaje                                                 := NULL;
            Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Pr_InfoDocumentoFinancieroDet.DOCUMENTO_ID;
            Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Lr_ObtieneSolCarac.CARACTERISTICA_ID;
            Lr_InfoDocumentoCaracteristica.VALOR                       := Lr_ObtieneSolCarac.VALOR;
             --La característica queda activa para poder ser visualizada en telcos
            Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;
            Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
            Lr_InfoDocumentoCaracteristica.USR_CREACION                := Lr_ObtieneSolCarac.USR_CREACION;
            Lr_InfoDocumentoCaracteristica.IP_CREACION                 := '127.0.0.1';

            --SE INSERTA LA CARACTERÍSTICA EN INFO_DOCUMENTO_CARACTERISTICA
            DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaracteristica, Pv_Mensaje);
            IF Pv_Mensaje IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;

            --Si no aplica facturación detallada y no es el primer registro, se continúa con el bucle de migración de características.
            IF Ln_Indice > 0 THEN
                CONTINUE;
            END IF;
        END IF;

        /*--------------Se crea el detalle y el impuesto según corresponda.------------*/
        Lr_InfoDocumentoFinancieroDet                               := NULL;
        Lr_InfoDocumentoFinancieroDet                               := Pr_InfoDocumentoFinancieroDet;
        Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE                := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
        Lr_InfoDocumentoFinancieroDet.PLAN_ID                       := Ln_PlanId;
        Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                   := Ln_ProductoId;
        Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE   := Ln_Subtotal;
        Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE          := ROUND(Ln_Subtotal, 2);
        Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE          := ROUND(Ln_Subtotal, 2);
        Lr_InfoDocumentoFinancieroDet.FE_CREACION                   := SYSDATE;
        Lr_InfoDocumentoFinancieroDet.CANTIDAD                      := Lr_ObtieneSolCarac.CANTIDAD;

        DB_FINANCIERO.FNCK_TRANSACTION.P_CREA_DOCUMENTO_DETALLE_IMP(Pr_InfoDocumentoFinancieroDet => Lr_InfoDocumentoFinancieroDet,
                                                                    Pv_PagaIva                    => Pv_PagaIva,
                                                                    Pv_Mensaje                    => Pv_Mensaje);
        IF Pv_Mensaje IS NOT NULL THEN
            RAISE Le_Exception;
        END IF;
        --Se incrementa el contador de características para validar si se crea o no el detalle.
        --Existe un único detalle cuando la solicitud no aplica a facturación detallada.
        --Si la solicitud aplica facturación detallada, se crea un detalle por cada característica.
        Ln_Indice := Ln_Indice + 1;
      /*--------------FIN Se crea el detalle y el impuesto según corresponda.------------*/
    END LOOP;

    --SE ITERAN LAS CARACTERÍSTICAS NO FACTURABLES DE LA SOLICITUD
    FOR Lr_ObtieneSolCarac IN C_ObtieneCaracteristicas(Cn_DetalleSolicitudId => Pn_DetalleSolicitudId,
                                                       Cv_Estado             => 'NoFacturable',
                                                       Cn_CaracteristicaId   => NULL)
    LOOP
        --Caso contrario, se clonan las características de la solicitud como características de la factura.
        Lr_InfoDocumentoCaracteristica                             := NULL;
        Pv_Mensaje                                                 := NULL;
        Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
        Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Pr_InfoDocumentoFinancieroDet.DOCUMENTO_ID;
        Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Lr_ObtieneSolCarac.CARACTERISTICA_ID;
        Lr_InfoDocumentoCaracteristica.VALOR                       := Lr_ObtieneSolCarac.VALOR;
         --La característica queda activa para poder ser visualizada en telcos
        Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;
        Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
        Lr_InfoDocumentoCaracteristica.USR_CREACION                := Lr_ObtieneSolCarac.USR_CREACION;
        Lr_InfoDocumentoCaracteristica.IP_CREACION                 := '127.0.0.1';

        --SE INSERTA LA CARACTERÍSTICA EN INFO_DOCUMENTO_CARACTERISTICA
        DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaracteristica, Pv_Mensaje);
        IF Pv_Mensaje IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;
    END LOOP;

    IF Ln_Indice = 0 THEN
        Lr_InfoDocumentoFinancieroDet                               := Pr_InfoDocumentoFinancieroDet;
        Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE                := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
        --Si no se obtuvo ninguna caract "Facturable" significa que no ha creado ningún detalle. Por lo tanto hay que crear el detalle genérico.
        DB_FINANCIERO.FNCK_TRANSACTION.P_CREA_DOCUMENTO_DETALLE_IMP(Pr_InfoDocumentoFinancieroDet => Lr_InfoDocumentoFinancieroDet,
                                                                    Pv_PagaIva                    => Pv_PagaIva,
                                                                    Pv_Mensaje                    => Pv_Mensaje);
        IF Pv_Mensaje IS NOT NULL THEN
            RAISE Le_Exception;
        END IF;
    END IF;

    --Si la SOLICITUD tiene asociada una SOLICITUD NOTA DE CREDITO a través de la característica, se clona.
    Lr_AdmiCaracteristica := NULL;
    OPEN  C_AdmiCaracteristica(Cv_DescripcionCaract => 'SOLICITUD NOTA CREDITO',
                               Cv_Estado            => Lv_EstadoActivo);
    FETCH C_AdmiCaracteristica INTO Lr_AdmiCaracteristica;
    CLOSE C_AdmiCaracteristica;

    --SE OBTIENE SI LA SOLICITUD APLICA NOTA DE CRÉDITO O NO.
    OPEN  C_ObtieneCaracteristicas(Cn_DetalleSolicitudId => Pn_DetalleSolicitudId,
                                   Cv_Estado             => Lv_EstadoActivo,
                                   Cn_CaracteristicaId   => Lr_AdmiCaracteristica.ID_CARACTERISTICA);
    FETCH C_ObtieneCaracteristicas INTO Lr_NotaDeCredito;
    CLOSE C_ObtieneCaracteristicas;

    IF Lr_NotaDeCredito.VALOR IS NOT NULL THEN
        Lr_InfoDocumentoCaracteristica                             := NULL;
        Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
        Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Pr_InfoDocumentoFinancieroDet.DOCUMENTO_ID;
        Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Lr_NotaDeCredito.CARACTERISTICA_ID;
        Lr_InfoDocumentoCaracteristica.VALOR                       := Lr_NotaDeCredito.VALOR;
        Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;
        Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
        Lr_InfoDocumentoCaracteristica.USR_CREACION                := Lr_NotaDeCredito.USR_CREACION;
        Lr_InfoDocumentoCaracteristica.IP_CREACION                 := '127.0.0.1';

        --SE INSERTA LA CARACTERÍSTICA EN INFO_DOCUMENTO_CARACTERISTICA
        DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaracteristica, Pv_Mensaje);
        IF Pv_Mensaje IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;
    END IF;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Mensaje := Lv_MensajeError || Pv_Mensaje;
    WHEN OTHERS THEN
      Pv_Mensaje := Lv_MensajeError || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                    ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_CLONAR_SOLICITUD_CARAC;

  PROCEDURE P_CREA_DOCUMENTO_DETALLE_IMP (Pr_InfoDocumentoFinancieroDet IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE,
                                          Pv_PagaIva                    IN  VARCHAR2,
                                          Pv_Mensaje                    OUT VARCHAR2)
  IS
    CURSOR C_GetAdmiImpuesto(Cv_TipoImpuesto   DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE,
                             Cv_EstadoImpuesto DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE ) IS
      SELECT ID_IMPUESTO,
             PORCENTAJE_IMPUESTO
        FROM DB_GENERAL.ADMI_IMPUESTO
       WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
         AND ESTADO        = Cv_EstadoImpuesto;


    Lv_TipoImpuestoIva            DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := 'IVA';
    Lr_InfoDocumentoFinancieroImp DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
    Ln_Impuesto                   NUMBER := 0;
    Lv_EstadoActivo               VARCHAR2(15) := 'Activo';
    Lr_AdmiImpuesto               C_GetAdmiImpuesto%ROWTYPE;
    Le_Exception                  EXCEPTION;
    Le_NoPagaIva                  EXCEPTION;
  BEGIN
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Pr_InfoDocumentoFinancieroDet,Pv_Mensaje);
    IF TRIM(Pv_Mensaje) IS NOT NULL THEN
        Pv_Mensaje := Pv_Mensaje || ' - Error al insertar el detalle de la factura';
        RAISE Le_Exception;
    END IF;

    IF 'S' <> Pv_PagaIva AND '18' <> Pr_InfoDocumentoFinancieroDet.EMPRESA_ID THEN
      RAISE Le_NoPagaIva;
    END IF;

    Lr_AdmiImpuesto := NULL;
    IF C_GetAdmiImpuesto%ISOPEN THEN
        CLOSE C_GetAdmiImpuesto;
    END IF;

    OPEN  C_GetAdmiImpuesto( Lv_TipoImpuestoIva, Lv_EstadoActivo );
    FETCH C_GetAdmiImpuesto INTO Lr_AdmiImpuesto;
    CLOSE C_GetAdmiImpuesto;

    IF Lr_AdmiImpuesto.ID_IMPUESTO IS NOT NULL AND Lr_AdmiImpuesto.ID_IMPUESTO > 0 THEN
        IF Lr_AdmiImpuesto.PORCENTAJE_IMPUESTO IS NOT NULL AND Lr_AdmiImpuesto.PORCENTAJE_IMPUESTO > 0 THEN
            Ln_Impuesto := (Pr_InfoDocumentoFinancieroDet.CANTIDAD * Pr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE - Pr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE)
                           * Lr_AdmiImpuesto.PORCENTAJE_IMPUESTO/100;

            --Con los valores de detalle insertado, podemos ingresar el impuesto del IVA
            Lr_InfoDocumentoFinancieroImp                := NULL;
            Lr_InfoDocumentoFinancieroImp.ID_DOC_IMP     := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
            Lr_InfoDocumentoFinancieroImp.DETALLE_DOC_ID := Pr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE;
            Lr_InfoDocumentoFinancieroImp.IMPUESTO_ID    := Lr_AdmiImpuesto.ID_IMPUESTO;
            Lr_InfoDocumentoFinancieroImp.VALOR_IMPUESTO := ROUND(Ln_Impuesto,2);
            Lr_InfoDocumentoFinancieroImp.PORCENTAJE     := Lr_AdmiImpuesto.PORCENTAJE_IMPUESTO;
            Lr_InfoDocumentoFinancieroImp.FE_CREACION    := SYSDATE;
            Lr_InfoDocumentoFinancieroImp.USR_CREACION   := Pr_InfoDocumentoFinancieroDet.USR_CREACION;
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinancieroImp, Pv_Mensaje);
            IF Pv_Mensaje IS NOT NULL THEN
              Pv_Mensaje := 'Error al insertar el impuesto de la factura '|| Pv_Mensaje;
              RAISE Le_Exception;
            END IF;
        END IF;
    END IF;
  EXCEPTION
    WHEN Le_NoPagaIva THEN
        Pv_Mensaje := NULL;
    WHEN Le_Exception THEN
        Pv_Mensaje := 'Error al crear el detalle del documento: ' || Pv_Mensaje;
    WHEN OTHERS THEN
        Pv_Mensaje := 'Error inesperado: ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                      ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_CREA_DOCUMENTO_DETALLE_IMP;

  PROCEDURE P_UPDATE_DOC_CONTABILIZAR(
    Pv_Prefijo                 IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento     IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_ActualizarContabilizado IN VARCHAR2,
    Pv_FeProcesar              IN VARCHAR2,
    Pv_UsrCreacion             IN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE,
    Pv_TipoProceso             IN OUT VARCHAR2,
    Pv_MensajeError            OUT VARCHAR2)
  IS
    --
    Lv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'VALIDACIONES_PROCESOS_CONTABLES';
    Lv_EstadoParametro DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE := 'Activo';
    Lv_DescParametro   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'FECHA_CONTABILIZACION';
    --
    CURSOR C_PARAMETRO_CONTABILIZACION IS
      SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
        DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        INFO_EMPRESA_GRUPO IEG
      WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO
      AND APD.EMPRESA_COD = IEG.COD_EMPRESA
      AND APC.NOMBRE_PARAMETRO = Lv_NombreParametro
      AND APC.ESTADO           = Lv_EstadoParametro
      AND APD.ESTADO           = Lv_EstadoParametro
      AND APD.DESCRIPCION      = Lv_DescParametro
      AND IEG.PREFIJO          = Pv_Prefijo;
    --
    Lv_TipoFechaContable      VARCHAR2(30) := NULL;
    --
    --CURSOR QUE OBTIENE LOS DOCUMENTOS A ACTUALIZAR LA COLUMNA DE CONTABILIZADO E INGRESARLES EL HISTORIAL
    CURSOR C_DOCUMENTOS ( Cv_EstadoActivo         VARCHAR2,
                          Cv_ProcesosContables    VARCHAR2,
                          Cv_CodigosDocumentos    VARCHAR2,
                          Cv_OpcionFechaAnulacion VARCHAR2,
                          Cv_EstadoAnulado        VARCHAR2, 
                          Cv_TipoFecha            VARCHAR2) IS 
      SELECT IDFC.ID_DOCUMENTO, 
        IDFC.ESTADO_IMPRESION_FACT
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON IDFC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO
      WHERE EXISTS ( SELECT NULL
                     FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                     JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ON APD.PARAMETRO_ID = APC.ID_PARAMETRO
                     WHERE APD.VALOR2         = ATDF.CODIGO_TIPO_DOCUMENTO
                     AND APD.ESTADO           = Cv_EstadoActivo
                     AND APC.ESTADO           = Cv_EstadoActivo
                     AND APC.NOMBRE_PARAMETRO = Cv_ProcesosContables
                     AND APD.DESCRIPCION      = Cv_CodigosDocumentos
                     AND APD.VALOR1           = Pv_CodigoTipoDocumento)
      AND IDFC.NUMERO_FACTURA_SRI IS NOT NULL
      AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDFC.PUNTO_ID, NULL) = Pv_Prefijo
      AND IDFC.ESTADO_IMPRESION_FACT = Cv_EstadoAnulado
      AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_FECHA_HISTORIAL(IDFC.ID_DOCUMENTO, IDFC.ESTADO_IMPRESION_FACT, Cv_OpcionFechaAnulacion) >= CAST(TO_DATE(Pv_FeProcesar,'YYYY-MM-DD') AS TIMESTAMP WITH LOCAL TIME ZONE) 
      AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_FECHA_HISTORIAL(IDFC.ID_DOCUMENTO, IDFC.ESTADO_IMPRESION_FACT, Cv_OpcionFechaAnulacion) < CAST(TO_DATE(Pv_FeProcesar,'YYYY-MM-DD') AS TIMESTAMP WITH LOCAL TIME ZONE)+1 
      AND IDFC.CONTABILIZADO = 'S'
      AND NVL(INSTR(TRIM(Pv_TipoProceso), 'ANULACION'), 0) > 0
      UNION
      SELECT IDFC.ID_DOCUMENTO, 
        IDFC.ESTADO_IMPRESION_FACT
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON IDFC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO
      WHERE EXISTS ( SELECT NULL
                     FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                     JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ON APD.PARAMETRO_ID = APC.ID_PARAMETRO
                     WHERE APD.VALOR2         = ATDF.CODIGO_TIPO_DOCUMENTO
                     AND APD.ESTADO           = Cv_EstadoActivo
                     AND APC.ESTADO           = Cv_EstadoActivo
                     AND APC.NOMBRE_PARAMETRO = Cv_ProcesosContables
                     AND APD.DESCRIPCION      = Cv_CodigosDocumentos
                     AND APD.VALOR1           = Pv_CodigoTipoDocumento)
      AND IDFC.NUMERO_FACTURA_SRI IS NOT NULL
      AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDFC.PUNTO_ID, NULL) = Pv_Prefijo
      AND IDFC.FE_AUTORIZACION >= (CASE Cv_TipoFecha
                                   WHEN 'FECHA_AUTORIZA' THEN TO_TIMESTAMP(Pv_FeProcesar || '00:00:00', 'YYYY-MM-DD HH24:MI:SS')
                                   ELSE IDFC.FE_AUTORIZACION
                                   END)
      AND IDFC.FE_AUTORIZACION <= (CASE Cv_TipoFecha
                                   WHEN 'FECHA_AUTORIZA' THEN TO_TIMESTAMP(Pv_FeProcesar || '23:59:59', 'YYYY-MM-DD HH24:MI:SS')
                                   ELSE IDFC.FE_AUTORIZACION
                                   END)
      AND IDFC.FE_EMISION >= (CASE Cv_TipoFecha
                              WHEN 'FECHA_EMISION' THEN TO_TIMESTAMP(Pv_FeProcesar || '00:00:00', 'YYYY-MM-DD HH24:MI:SS')
                              ELSE IDFC.FE_EMISION
                              END)
      AND IDFC.FE_EMISION <= (CASE Cv_TipoFecha
                              WHEN 'FECHA_EMISION' THEN TO_TIMESTAMP(Pv_FeProcesar || '23:59:59', 'YYYY-MM-DD HH24:MI:SS')
                              ELSE IDFC.FE_EMISION
                              END)      AND IDFC.CONTABILIZADO = 'S'
      AND NVL(INSTR(TRIM(Pv_TipoProceso), 'ANULACION'), 0) = 0
      --ORDER BY 1
      ;
    --

    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                := 'Activo';
    Lv_EstadoAnulado DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE               := 'Anulado';
    Lv_ProcesosContables DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROCESOS_CONTABLES';
    Lv_CodigosDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE      := 'CODIGO_DOCUMENTOS';
    Lr_InfoDocumentoHistorial DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE := NULL;
    Lv_OpcionFechaAnulacion VARCHAR2(11)                                     := 'MIN_MOTIVO';
    Ln_ContadorCommit NUMBER                                                 := 0;
    Ln_PosicionAnulacion NUMBER                                              := 0;
    Ln_IdDocumentoActualizar DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Lv_EstadoDocumentoActualizar DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE;
    Lcl_Query CLOB;
    Lex_Exception EXCEPTION;
    --
  BEGIN
    -- se recupera parametro fecha de contabilziación.
    IF C_PARAMETRO_CONTABILIZACION%ISOPEN THEN
      CLOSE C_PARAMETRO_CONTABILIZACION;
    END IF;
    --
    OPEN C_PARAMETRO_CONTABILIZACION;
    FETCH C_PARAMETRO_CONTABILIZACION INTO Lv_TipoFechaContable;
    CLOSE C_PARAMETRO_CONTABILIZACION;
    --
    IF Lv_TipoFechaContable IS NULL THEN
      Lv_TipoFechaContable := 'FECHA_AUTORIZA';
    END IF;

      --
      --
    FOR Lrf_GetDocumentosActualizar IN C_DOCUMENTOS ('Activo',
                                                     'PROCESOS_CONTABLES',
                                                     'CODIGO_DOCUMENTOS',
                                                     'MIN_MOTIVO',
                                                     'Anulado',
                                                     Lv_TipoFechaContable) LOOP
      Ln_IdDocumentoActualizar := NVL(Lrf_GetDocumentosActualizar.Id_Documento,0);
      Lv_EstadoDocumentoActualizar := TRIM(Lrf_GetDocumentosActualizar.Estado_Impresion_Fact);

      --SE VERIFICA QUE EL ID DEL DOCUMENTO NO SEA NULL Y SEA MAYOR QUE CERO
      --IF Ln_IdDocumentoActualizar IS NOT NULL AND Ln_IdDocumentoActualizar > 0 AND TRIM(Lv_EstadoDocumentoActualizar) IS NOT NULL THEN
      IF Ln_IdDocumentoActualizar > 0 AND Lv_EstadoDocumentoActualizar IS NOT NULL THEN
        --
        Ln_ContadorCommit := Ln_ContadorCommit + 1;
        --
        --SE VERIFICA SI EL PROCESO REQUIERE QUE SE ACTUALICE LA BANDERA DE CONTABILIZADO
        IF TRIM(Pv_ActualizarContabilizado) IS NOT NULL AND TRIM(Pv_ActualizarContabilizado) = 'S' THEN
          --
          UPDATE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
          SET CONTABILIZADO = NULL
          WHERE ID_DOCUMENTO = Ln_IdDocumentoActualizar;
          --
        END IF;
        --
        --SE CREA Y SE GUARDA UN HISTORIAL INDICANDO QUE SE REALIZA UN RE-PROCESAMIENTO DE CONTABILIZACION DEL DOCUMENTO
        Pv_MensajeError                                  := NULL;
        Lr_InfoDocumentoHistorial                        := NULL;
        Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoHistorial.DOCUMENTO_ID           := Ln_IdDocumentoActualizar;
        Lr_InfoDocumentoHistorial.FE_CREACION            := SYSDATE;
        Lr_InfoDocumentoHistorial.USR_CREACION           := Pv_UsrCreacion;
        Lr_InfoDocumentoHistorial.ESTADO                 := Lv_EstadoDocumentoActualizar;
        Lr_InfoDocumentoHistorial.OBSERVACION            := 'Ejecución de Re-procesamiento de Contabilización | ' || Pv_TipoProceso;
        --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoHistorial, Pv_MensajeError);
        --
        --
        IF TRIM(Pv_MensajeError) IS NOT NULL THEN
          --
          Pv_MensajeError := 'Error al guardar el historial de los documentos actualizados. DOCUMENTO_ID(' || Ln_IdDocumentoActualizar || ') - ' 
                             || Pv_MensajeError;
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        --
        IF Ln_ContadorCommit >= 5000 THEN
          --
          Ln_ContadorCommit := 0;
          --
          COMMIT;
          --
        END IF;
        --
      END IF;
      --
    END LOOP;
    --
    --
    IF Ln_ContadorCommit < 5000 THEN
      --
      COMMIT;
      --
    END IF;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_TRANSACTION.P_UPDATE_DOC_CONTABILIZAR', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MensajeError := 'Error al actualizar los documentos a reprocesar la informacion contable - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_TRANSACTION.P_UPDATE_DOC_CONTABILIZAR', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_UPDATE_DOC_CONTABILIZAR;
  --
  --
  PROCEDURE P_REPROCESAMIENTO_CONTABLE(
    Pv_CodEmpresa              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo                 IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento     IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_CodigoDiario            IN  DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.COD_DIARIO%TYPE,
    Pv_ActualizarContabilizado IN  VARCHAR2,
    Pv_FeProcesar              IN  VARCHAR2,
    Pv_UsrCreacion             IN  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE,
    Pv_TipoProceso             IN  OUT VARCHAR2,
    Pv_MensajeError            OUT VARCHAR2)
  IS
    --
    Ld_FeProcesar     DATE       := NULL;
    Ln_ContadorCommit NUMBER     := 0;
    Lex_Exception     EXCEPTION;
    --
  BEGIN
    --
    Ld_FeProcesar := TO_DATE(Pv_FeProcesar, 'YYYY-MM-DD');
    --
    --SE ELIMINA LA INFORMACION CONTABLE EN EL NAF QUE NO HA SIDO MAYORIZADA DEL DIA QUE SE REQUIERE PROCESAR LA INFORMACION
    NAF47_TNET.GEK_MIGRACION.P_ELIMINA_MIGRA_CG(Ld_FeProcesar,
                                                NULL,
                                                Pv_CodigoDiario,
                                                Pv_CodEmpresa,
                                                Pv_MensajeError);
    --
    IF TRIM(Pv_MensajeError) IS NOT NULL THEN
      --
      Pv_MensajeError := 'Error al eliminar la migración contable en el NAF. - ' || Pv_MensajeError;
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    --
    --SE ACTUALIZA LOS DOCUMENTOS QUE SE REQUIERE PROCESAR LA INFORMACION CONTABLE
    DB_FINANCIERO.FNCK_TRANSACTION.P_UPDATE_DOC_CONTABILIZAR(Pv_Prefijo,
                                                             Pv_CodigoTipoDocumento,
                                                             Pv_ActualizarContabilizado,
                                                             Pv_FeProcesar,
                                                             Pv_UsrCreacion,
                                                             Pv_TipoProceso,
                                                             Pv_MensajeError);
    --
    IF TRIM(Pv_MensajeError) IS NOT NULL THEN
      --
      Pv_MensajeError := 'Error al actualizar los documentos que requieren reprocesamiento contable. - ' || Pv_MensajeError;
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    --
    --SE REALIZA EL REPROCESO DE CONTABILIZACION DE LOS DOCUMENTOS ACTUALIZADOS SEGUN LA FECHA SELECCIONADA POR EL USUARIO
    DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_CONTABILIZAR(Pv_CodEmpresa,
                                                           Pv_Prefijo,
                                                           Pv_CodigoTipoDocumento,
                                                           Pv_TipoProceso,
                                                           NULL,
                                                           Pv_FeProcesar,
                                                           Pv_MensajeError);
    --
    IF TRIM(Pv_MensajeError) IS NOT NULL THEN
      --
      Pv_MensajeError := 'Error al procesar la contabilidad. - ' || Pv_MensajeError;
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    Pv_MensajeError := 'OK';
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_TRANSACTION.P_REPROCESAMIENTO_CONTABLE', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    Pv_MensajeError := 'Error al reprocesar los documentos. - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_TRANSACTION.P_REPROCESAMIENTO_CONTABLE', 
                                          Pv_MensajeError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_REPROCESAMIENTO_CONTABLE;
  --
  --

  PROCEDURE P_GEN_CARGO_REPROCESO
  (
      Pv_PrefijoEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_EstadoDebitoDet  IN  DB_FINANCIERO.INFO_DEBITO_DET.ESTADO%TYPE,
      Pv_ParametroDebitos IN  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
      Pv_MensajeError     OUT VARCHAR2
  )
  AS
    -- Cursor que obtiene los clientes con número de intentos de débito en el mes actual >= al valor enviado como parámetro.

    -- C_ClientesConCargoReproceso - Costo Query: 24

    CURSOR C_ClientesConCargoReproceso
      IS
        SELECT IDD.PERSONA_EMPRESA_ROL_ID
        FROM DB_FINANCIERO.INFO_DEBITO_DET IDD
             JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                 ON IPER.ID_PERSONA_ROL = IDD.PERSONA_EMPRESA_ROL_ID
             JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER
                 ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
             JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
                 ON IEG.COD_EMPRESA = IER.EMPRESA_COD
             JOIN DB_FINANCIERO.INFO_DEBITO_CAB IDC
                 ON IDC.ID_DEBITO_CAB = IDD.DEBITO_CAB_ID
             JOIN DB_FINANCIERO.INFO_DEBITO_GENERAL IDG
                 ON IDG.ID_DEBITO_GENERAL = IDC.DEBITO_GENERAL_ID
        WHERE     IDD.FE_CREACION >= TRUNC (SYSDATE, 'MM')
             AND IDD.FE_CREACION  <= LAST_DAY (SYSDATE)
             AND IDD.ESTADO       = Pv_EstadoDebitoDet
             AND IEG.PREFIJO      = Pv_PrefijoEmpresa
        GROUP BY IDC.BANCO_TIPO_CUENTA_ID, IDD.PERSONA_EMPRESA_ROL_ID
          HAVING COUNT (IDG.ID_DEBITO_GENERAL) >= TO_NUMBER (Pv_ParametroDebitos,'99.99')
        MINUS
        SELECT IPTO.PERSONA_EMPRESA_ROL_ID
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
               JOIN DB_COMERCIAL.INFO_SERVICIO ISER ON ISER.ID_SERVICIO = IDS.SERVICIO_ID
               JOIN DB_COMERCIAL.INFO_PUNTO IPTO ON IPTO.ID_PUNTO = ISER.PUNTO_ID
               JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
        WHERE  ATS.DESCRIPCION_SOLICITUD    = 'SOLICITUD CARGO REPROCESO DEBITO'
               AND IDS.ESTADO               IN (SELECT PD.VALOR1 
                                                FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                                DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                                WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                                AND PC.NOMBRE_PARAMETRO = 'PARAM_CARGO_REPROCESO_DEBITOS'         
                                                AND PC.ESTADO           = 'Activo'
                                                AND PD.ESTADO           = 'Activo'
                                                AND PD.DESCRIPCION      = 'ESTADOS_SOLICITUD') 
               AND IDS.FE_CREACION          >= TRUNC (SYSDATE, 'MM')
               AND IDS.FE_CREACION          <= SYSDATE
        GROUP BY IPTO.PERSONA_EMPRESA_ROL_ID, IDS.SERVICIO_ID;  

     -- C_GetServIntPlanId - Costo Query: 21 
    CURSOR C_GetServIntPlanId(Cn_IdPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
      IS
        SELECT ISER.ID_SERVICIO
        FROM  DB_COMERCIAL.INFO_SERVICIO ISER
        JOIN  DB_COMERCIAL.INFO_PUNTO               IPTO  ON IPTO.ID_PUNTO         = ISER.PUNTO_ID
        JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER  ON IPER.ID_PERSONA_ROL   = IPTO.PERSONA_EMPRESA_ROL_ID
        JOIN  DB_COMERCIAL.INFO_EMPRESA_ROL         IER   ON IER.ID_EMPRESA_ROL    = IPER.EMPRESA_ROL_ID
        JOIN  DB_COMERCIAL.INFO_EMPRESA_GRUPO       IEG   ON IEG.COD_EMPRESA       = IER.EMPRESA_COD                           
        JOIN  DB_COMERCIAL.INFO_SERVICIO_TECNICO    IST   ON ISER.ID_SERVICIO      = IST.SERVICIO_ID
        JOIN  DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO    ATM   ON ATM.ID_TIPO_MEDIO     = IST.ULTIMA_MILLA_ID
        JOIN  DB_COMERCIAL.INFO_PLAN_CAB            IPC   ON ISER.PLAN_ID          = IPC.ID_PLAN
        JOIN  DB_COMERCIAL.INFO_PLAN_DET            IPD   ON IPC.ID_PLAN           = IPD.PLAN_ID
        JOIN  DB_COMERCIAL.ADMI_PRODUCTO            AP    ON IPD.PRODUCTO_ID       = AP.ID_PRODUCTO
        WHERE ISER.ESTADO              IN ( SELECT APD.VALOR1
                                            FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC ON   APD.PARAMETRO_ID = APC.ID_PARAMETRO
                                            WHERE  APC.NOMBRE_PARAMETRO = 'ESTADOS SERVICIOS CARGO REPROCESO'
                                            AND    APC.ESTADO           = 'Activo')
        AND   ISER.ES_VENTA            = 'S'
        AND   AP.ESTADO                = 'Activo'                              
        AND   ISER.FRECUENCIA_PRODUCTO = 1
        AND   IEG.PREFIJO              = Pv_PrefijoEmpresa
        AND   AP.NOMBRE_TECNICO        = 'INTERNET'
        AND   IPER.ID_PERSONA_ROL      = Cn_IdPersonaEmpresaRol
        AND   ROWNUM = 1;

     -- C_GetServIntProductoId - Costo Query: 16 
    CURSOR C_GetServIntProductoId(Cn_IdPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
      IS
        SELECT ISER.ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO ISER
        JOIN DB_COMERCIAL.INFO_PUNTO               IPTO  ON IPTO.ID_PUNTO         = ISER.PUNTO_ID
        JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER  ON IPER.ID_PERSONA_ROL   = IPTO.PERSONA_EMPRESA_ROL_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_ROL         IER   ON IER.ID_EMPRESA_ROL    = IPER.EMPRESA_ROL_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO       IEG   ON IEG.COD_EMPRESA       = IER.EMPRESA_COD 
        JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO    IST   ON ISER.ID_SERVICIO      = IST.SERVICIO_ID
        JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO    ATM   ON ATM.ID_TIPO_MEDIO     = IST.ULTIMA_MILLA_ID
        JOIN DB_COMERCIAL.ADMI_PRODUCTO            AP    ON ISER.PRODUCTO_ID      = AP.ID_PRODUCTO
        WHERE ISER.ESTADO              IN ( SELECT APD.VALOR1
                                            FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC ON   APD.PARAMETRO_ID = APC.ID_PARAMETRO
                                            WHERE  APC.NOMBRE_PARAMETRO = 'ESTADOS SERVICIOS CARGO REPROCESO'
                                            AND    APC.ESTADO           = 'Activo')
        AND   ISER.ES_VENTA            = 'S'
        AND   AP.ESTADO                = 'Activo'
        AND   ISER.FRECUENCIA_PRODUCTO = 1
        AND   IEG.PREFIJO              = Pv_PrefijoEmpresa
        AND   AP.NOMBRE_TECNICO        = 'INTERNET'
        AND   IPER.ID_PERSONA_ROL      = Cn_IdPersonaEmpresaRol
        AND   ROWNUM = 1;

    CURSOR C_GetNumSolPorServicio(Cn_IdServicio DB_COMERCIAL.INFO_DETALLE_SOLICITUD.SERVICIO_ID%TYPE)
      IS
        SELECT NVL(COUNT(IDS.ID_DETALLE_SOLICITUD),0)
        FROM   DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        JOIN   DB_COMERCIAL.INFO_SERVICIO ISER       ON ISER.ID_SERVICIO      = IDS.SERVICIO_ID
        JOIN   DB_COMERCIAL.INFO_PUNTO IPTO          ON IPTO.ID_PUNTO         = ISER.PUNTO_ID
        JOIN   DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS  ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
        WHERE  ATS.DESCRIPCION_SOLICITUD   =  'SOLICITUD CARGO REPROCESO DEBITO'
        AND    IDS.ESTADO                  IN  ('Pendiente','Finalizada')
        AND    IDS.SERVICIO_ID             =  Cn_IdServicio
        AND    IDS.FE_CREACION             >= TRUNC(SYSDATE,'MM')
        AND    IDS.FE_CREACION             <= SYSDATE;

    -- C_GetTipoSolicitudReproceso - Costo Query: 2 
    CURSOR C_GetTipoSolicitudReproceso
      IS
        SELECT ID_TIPO_SOLICITUD
        FROM   DB_COMERCIAL.ADMI_TIPO_SOLICITUD 
        WHERE  DESCRIPCION_SOLICITUD = 'SOLICITUD CARGO REPROCESO DEBITO'
        AND    ESTADO = 'Activo';

    -- C_GetTipoSolicitudReproceso - Costo Query: 6 
    CURSOR C_GetMotivoId
      IS
        SELECT ID_MOTIVO
        FROM   DB_GENERAL.ADMI_MOTIVO
        WHERE  NOMBRE_MOTIVO = 'Solicitud Cargo por Reproceso de Debito'
        AND    ESTADO = 'Activo';


 -- C_GetTipoSolicitudReproceso - Costo Query: 5
    CURSOR C_GetValorCargoReproceso
      IS
        SELECT TO_NUMBER(APD.VALOR2)
        FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC ON   APD.PARAMETRO_ID = APC.ID_PARAMETRO
        WHERE  APC.NOMBRE_PARAMETRO = 'CARGO REPROCESO DEBITO'
        AND    APC.ESTADO           = 'Activo';

      Ln_IdServicio               DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
      Ln_IdDetalleSolicitud       DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
      Ln_ContadorCommitParcial    NUMBER        := 0;
      Ln_PorcentajeDescuento      NUMBER        := 0;
      Ln_PrecioDescuento          NUMBER        := 0;
      Lv_MensajeError             VARCHAR(3000) := '';
      Ln_IdTipoSolicitud          NUMBER        := 0;
      Ln_SecuenciaSolicitud       NUMBER        := 0;
      Ln_SecuenciaHistSolicitud   NUMBER        := 0;
      Ln_IdMotivo                 NUMBER        := 0;
      Ln_ContSolicitudesRep       NUMBER        := 0;
      --
      Lr_DetalleSolicitud     DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
      Lr_DetalleSolHistorial  DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;

    BEGIN
    --
    -- Se asigna el id correspondiente al tipo de solicitud  en la variable a ser usada en el ingreso de la solicitud.
      IF C_GetTipoSolicitudReproceso%ISOPEN THEN
        CLOSE C_GetTipoSolicitudReproceso;
      END IF;
      --
      OPEN C_GetTipoSolicitudReproceso;
      --
      FETCH C_GetTipoSolicitudReproceso INTO Ln_IdTipoSolicitud;
      --
      CLOSE C_GetTipoSolicitudReproceso;

      -- Se asigna el id correspondiente al motivo  en la variable a ser usada en el ingreso de la solicitud.
      IF C_GetMotivoId%ISOPEN THEN
        CLOSE C_GetMotivoId;
      END IF;
      --
      OPEN C_GetMotivoId;
      --
      FETCH C_GetMotivoId INTO Ln_IdMotivo;
      --
      CLOSE C_GetMotivoId;

      -- Se asigna el valor a cobrar al cliente por cargo de reproceso  en la variable a ser usada en el ingreso de la solicitud. 
      IF C_GetValorCargoReproceso%ISOPEN THEN
        CLOSE C_GetValorCargoReproceso;
      END IF;
      --
      OPEN C_GetValorCargoReproceso;
      --
      FETCH C_GetValorCargoReproceso INTO Ln_PrecioDescuento;
      --
      CLOSE C_GetValorCargoReproceso;

      --
      FOR Lc_ClientesCargoReproceso IN C_ClientesConCargoReproceso
      LOOP
        --
          -- Se asigna el id correspondiente al servicio de Internet  en la variable a ser usada en el ingreso de la solicitud.

          IF C_GetServIntPlanId%ISOPEN THEN

            CLOSE C_GetServIntPlanId;

          END IF;
          --
          OPEN C_GetServIntPlanId(Lc_ClientesCargoReproceso.PERSONA_EMPRESA_ROL_ID);
          --
          FETCH C_GetServIntPlanId INTO Ln_IdServicio;
          --
          CLOSE C_GetServIntPlanId;

          IF Ln_IdServicio IS NULL THEN

            IF C_GetServIntProductoId%ISOPEN THEN

              CLOSE C_GetServIntProductoId;

            END IF;
            --
            OPEN C_GetServIntProductoId(Lc_ClientesCargoReproceso.PERSONA_EMPRESA_ROL_ID);
            --
            FETCH C_GetServIntProductoId INTO Ln_IdServicio;
            --
            CLOSE C_GetServIntProductoId;

          END IF;

          IF Ln_IdServicio IS NOT NULL THEN

            IF C_GetNumSolPorServicio%ISOPEN THEN

              CLOSE C_GetNumSolPorServicio;

            END IF;
            --
            OPEN C_GetNumSolPorServicio(Ln_IdServicio);
            --
            FETCH C_GetNumSolPorServicio INTO Ln_ContSolicitudesRep;
            --
            CLOSE C_GetNumSolPorServicio;

            IF Ln_ContSolicitudesRep = 0 THEN
            --
            -- CREO LA SOLICITUD DE CARGO POR REPROCESO DE DEBITO
            --
            Lr_DetalleSolicitud := NULL;
            Lv_MensajeError     := '';
            --
            --
            --
            Ln_SecuenciaSolicitud := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL;

            --
            Lr_DetalleSolicitud.ID_DETALLE_SOLICITUD  := Ln_SecuenciaSolicitud;
            Lr_DetalleSolicitud.SERVICIO_ID           := Ln_IdServicio;
            Lr_DetalleSolicitud.TIPO_SOLICITUD_ID     := Ln_IdTipoSolicitud;
            Lr_DetalleSolicitud.PRECIO_DESCUENTO      := Ln_PrecioDescuento;
            Lr_DetalleSolicitud.PORCENTAJE_DESCUENTO  := Ln_PorcentajeDescuento;
            Lr_DetalleSolicitud.USR_CREACION          := 'telcos_sol_debito';
            Lr_DetalleSolicitud.OBSERVACION           := 'Solicitud por cargo de reproceso de Debito';
            Lr_DetalleSolicitud.ESTADO                := 'Pendiente';
            Lr_DetalleSolicitud.MOTIVO_ID             := Ln_IdMotivo;
            --
            DB_COMERCIAL.COMEK_TRANSACTION.COMEP_INSERT_DETALLE_SOLICITUD(Lr_DetalleSolicitud, Lv_MensajeError);
            --
            -- FIN CREACION SOLICITUD DE CARGO POR REPROCESO
            --
            -- INSERTO HISTORIAL DE LA SOLICITUD DE CARGO POR REPROCESO
            --
            Lr_DetalleSolHistorial := NULL;
            Lv_MensajeError        := '';
            Ln_SecuenciaHistSolicitud := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            --
            --
            Lr_DetalleSolHistorial.ID_SOLICITUD_HISTORIAL := Ln_SecuenciaHistSolicitud;
            Lr_DetalleSolHistorial.DETALLE_SOLICITUD_ID   := Lr_DetalleSolicitud.ID_DETALLE_SOLICITUD;
            Lr_DetalleSolHistorial.ESTADO                 := 'Pendiente';
            Lr_DetalleSolHistorial.OBSERVACION            := 'Se crea solicitud de cargo por reproceso ';
            Lr_DetalleSolHistorial.USR_CREACION           := 'telcos_sol_debito';
            Lr_DetalleSolHistorial.IP_CREACION            := '127.0.0.1';
            --
            DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Lr_DetalleSolHistorial, Lv_MensajeError);
            --
            -- FIN INSERTO HISTORIAL DE LA SOLICITUD DE CARGO POR REPROCESO
            --
            END IF;
          END IF;
        
        IF Ln_ContadorCommitParcial >= 5000 THEN

          COMMIT;
          Ln_ContadorCommitParcial := 0;

      END IF;

      Ln_ContadorCommitParcial := Ln_ContadorCommitParcial + 1;

    END LOOP;

    COMMIT;

    EXCEPTION 
    WHEN OTHERS THEN
    --
      Pv_MensajeError := 'ERROR EN DB_FINANCIERO.FNCK_TRANSACTION.P_GEN_CARGO_REPROCESO';

      ROLLBACK;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNCK_TRANSACTION.P_GEN_CARGO_REPROCESO', 
                                            'Error al generar solicitudes de cargo por reproceso ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
    --
    END P_GEN_CARGO_REPROCESO;

    PROCEDURE P_EJEC_CARGO_REPROCESO
    (
        Pv_MensajeError     OUT VARCHAR2
    )
    AS
      -- Costo  Query: 3
      CURSOR C_GetNumIntentosDebitos 
        IS 
          SELECT APD.VALOR1 
          FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD 
          JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC ON   APD.PARAMETRO_ID = APC.ID_PARAMETRO 
          WHERE  APC.NOMBRE_PARAMETRO = 'CARGO REPROCESO DEBITO' 
          AND    APC.ESTADO           = 'Activo'; 

      -- Costo  Query: 2
      CURSOR C_GetEstadoParametroReproceso 
        IS 
          SELECT APC.ESTADO 
          FROM   DB_GENERAL.ADMI_PARAMETRO_CAB APC 
          WHERE  APC.NOMBRE_PARAMETRO = 'CARGO REPROCESO DEBITO';


      Lv_PrefijoEmpresa                VARCHAR(10)   := 'MD';
      Lv_ParametroNumIntentosDebito    VARCHAR(10)   := '';
      Lv_EstadoDebito                  VARCHAR(10)   := 'Rechazado';
      Lv_EstadoParametro               VARCHAR(10)   := '';
      Lv_MensajeError                  VARCHAR(1000) := '';

    BEGIN 

      IF C_GetNumIntentosDebitos%ISOPEN THEN 

        CLOSE C_GetNumIntentosDebitos; 

      END IF; 
      -- 
      OPEN C_GetNumIntentosDebitos; 
      -- 
      FETCH C_GetNumIntentosDebitos INTO Lv_ParametroNumIntentosDebito; 
      -- 
      CLOSE C_GetNumIntentosDebitos; 

      IF C_GetEstadoParametroReproceso%ISOPEN THEN 

        CLOSE C_GetEstadoParametroReproceso; 

      END IF; 
      -- 
      OPEN C_GetEstadoParametroReproceso; 
      -- 
      FETCH C_GetEstadoParametroReproceso INTO Lv_EstadoParametro; 
      -- 
      CLOSE C_GetEstadoParametroReproceso; 

      IF Lv_EstadoParametro = 'Activo' THEN 

        FNCK_TRANSACTION.P_GEN_CARGO_REPROCESO(Lv_PrefijoEmpresa,Lv_EstadoDebito,Lv_ParametroNumIntentosDebito,Lv_MensajeError);  

      END IF; 

    EXCEPTION 
    WHEN OTHERS THEN
    --
      Pv_MensajeError := 'ERROR EN DB_FINANCIERO.FNCK_TRANSACTION.P_EJEC_CARGO_REPROCESO';

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNCK_TRANSACTION.P_EJEC_CARGO_REPROCESO', 
                                            'Error al ejecutar cargo por reproceso ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
    --
    END P_EJEC_CARGO_REPROCESO;

    PROCEDURE P_INSERT_INFO_REPORTE_HIST(
      Pr_InfoReporteHist IN DB_FINANCIERO.INFO_REPORTE_HISTORIAL%ROWTYPE)
    IS
    BEGIN
      --
      --
      INSERT
      INTO DB_FINANCIERO.INFO_REPORTE_HISTORIAL
        (
          ID_REPORTE_HISTORIAL, 
          EMPRESA_COD, 
          CODIGO_TIPO_REPORTE, 
          USR_CREACION, 
          FE_CREACION, 
          EMAIL_USR_CREACION,
          APLICACION,
          ESTADO,
          OBSERVACION, 
          FE_ULT_MOD
        )
        VALUES
        (
          Pr_InfoReporteHist.ID_REPORTE_HISTORIAL,
          Pr_InfoReporteHist.EMPRESA_COD,
          Pr_InfoReporteHist.CODIGO_TIPO_REPORTE,
          Pr_InfoReporteHist.USR_CREACION,
          Pr_InfoReporteHist.FE_CREACION,
          Pr_InfoReporteHist.EMAIL_USR_CREACION,
          Pr_InfoReporteHist.APLICACION,
          Pr_InfoReporteHist.ESTADO,
          Pr_InfoReporteHist.OBSERVACION,
          Pr_InfoReporteHist.FE_ULT_MOD
        );

     COMMIT;

    EXCEPTION 
    WHEN OTHERS THEN
    --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNCK_TRANSACTION.P_INSERT_INFO_REPORTE_HIST', 
                                            'Error al insertar historial. ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    END P_INSERT_INFO_REPORTE_HIST;


    PROCEDURE P_UPDATE_INFO_REPORTE_HIST(
      Pn_IdReporteHistorial IN DB_FINANCIERO.INFO_REPORTE_HISTORIAL.ID_REPORTE_HISTORIAL%TYPE)
    IS
    BEGIN
      --
      --
      UPDATE
        DB_FINANCIERO.INFO_REPORTE_HISTORIAL
      SET 
        ESTADO      = 'Activo',
        FE_ULT_MOD  = SYSDATE
      WHERE ID_REPORTE_HISTORIAL =  Pn_IdReporteHistorial;

      COMMIT;
    EXCEPTION 
    WHEN OTHERS THEN
    --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNCK_TRANSACTION.P_UPDATE_INFO_REPORTE_HIST', 
                                            'Error al actualizar historial. ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    END P_UPDATE_INFO_REPORTE_HIST;

   PROCEDURE P_API_CIERRE_FISCAL_TNP(Pv_TipoCierre       IN  Varchar2,
                                    Pv_CodEmpresa        IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pv_PrefijoEmpresa    IN  INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                                    Pv_UsuarioSession    IN  VARCHAR2,
                                    Pv_EmailUsrSesion    IN  VARCHAR2,
                                    Pv_CodigoError       OUT Varchar2,
                                    Pv_MensajeError      OUT Varchar2) IS
     
     CURSOR C_JSON(Cv_TipoCierre  Varchar2) IS
      SELECT '{'
          || '"action":"' || Cv_TipoCierre || '"' || '} 'AS json
      FROM DUAL;   

     CURSOR C_URL_INTERFAZ(Cv_CodEmpresa Varchar2, Cv_Descripcion Varchar2) IS
      SELECT VALOR1
        FROM ADMI_PARAMETRO_DET
       WHERE EMPRESA_COD = Cv_CodEmpresa
         AND DESCRIPCION = Cv_Descripcion;
  
    CURSOR C_URL_ESCAPE(Cv_Json Varchar2) IS
      SELECT utl_url.escape(Cv_Json) FROM DUAL;
  
    Lv_Metodo                 VARCHAR2(10) := 'POST';
    Lv_Url                    VARCHAR2(32767);
    Lhttp_Request             UTL_HTTP.req;
    Lv_Descripcion            ADMI_PARAMETRO_DET.Descripcion%TYPE := 'URL_INTERFAZ_API_CIERREFISCAL';
    Lv_UrlEscape              Varchar2(32767);                      
    Lhttp_Response            UTL_HTTP.resp;
    data                      VARCHAR2(4000);
    Lv_Json                   Varchar2(32767);   
    Lv_Response               VARCHAR2(2000);
    Lv_Code                   VARCHAR2(2000);
    Lv_Message                VARCHAR2(2000);
    Lv_FechaTrans             VARCHAR2(2000);
    Lv_HoraTrans              VARCHAR2(2000);   
    Lv_MensajeError           VARCHAR2(5000);
    Le_Error                  Exception;
    Lr_InfoReporteHistorial   DB_FINANCIERO.INFO_REPORTE_HISTORIAL%ROWTYPE;

    BEGIN
    IF C_JSON%ISOPEN THEN
      CLOSE C_JSON;
    END IF;
    OPEN C_JSON(Pv_TipoCierre);
    FETCH C_JSON
      INTO Lv_Json;
    CLOSE C_JSON;
  
    IF Lv_Json IS NULL THEN
      Lv_MensajeError := 'Json vacio';
    ELSE
      IF C_URL_ESCAPE%ISOPEN THEN
        CLOSE C_URL_ESCAPE;
      END IF;
      OPEN C_URL_ESCAPE(Lv_Json);
      FETCH C_URL_ESCAPE
        INTO Lv_UrlEscape;
      CLOSE C_URL_ESCAPE;
    END IF;

    IF C_URL_INTERFAZ%ISOPEN THEN
      CLOSE C_URL_INTERFAZ;
    END IF;
    OPEN C_URL_INTERFAZ(Pv_CodEmpresa, Lv_Descripcion);
    FETCH C_URL_INTERFAZ
      INTO Lv_Url;
    CLOSE C_URL_INTERFAZ;
  
    IF Lv_Url IS NULL THEN
      Lv_MensajeError := 'URL vacia';
    END IF;
  
    Lv_Url        := Lv_Url || '?request=' || Lv_UrlEscape;
    Lhttp_Request := UTL_HTTP.begin_request(url    => Lv_Url,
                                            method => Lv_Metodo);
    UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', 'application/json');
  
    Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
    utl_http.read_text(Lhttp_Response, data);
  
    apex_json.parse(data);
  
    Lv_Response       := apex_json.get_varchar2('response');
    Lv_Code           := apex_json.get_varchar2('code');
    Lv_Message        := apex_json.get_varchar2('message');
    Lv_FechaTrans     := apex_json.get_varchar2('date');
    Lv_HoraTrans      := apex_json.get_varchar2('time');

    UTL_HTTP.end_response(Lhttp_Response);
    
    IF Lv_Response = 'true' THEN
    --
      Lr_InfoReporteHistorial.ID_REPORTE_HISTORIAL := DB_FINANCIERO.SEQ_INFO_REPORTE_HISTORIAL.NEXTVAL;
      Lr_InfoReporteHistorial.EMPRESA_COD          := Pv_PrefijoEmpresa;
      Lr_InfoReporteHistorial.CODIGO_TIPO_REPORTE  := Pv_TipoCierre;
      Lr_InfoReporteHistorial.USR_CREACION         := Pv_UsuarioSession;
      Lr_InfoReporteHistorial.FE_CREACION          := SYSDATE ;
      Lr_InfoReporteHistorial.EMAIL_USR_CREACION   := Pv_EmailUsrSesion;
      Lr_InfoReporteHistorial.APLICACION           := 'Telcos';
      Lr_InfoReporteHistorial.ESTADO               := 'Activo';
      Lr_InfoReporteHistorial.OBSERVACION          := 'Ejecucion de Reporte de Cierre Fiscal Tipo: '||Pv_TipoCierre||
                                                    ' Fecha de Transacción: '||Lv_FechaTrans||
                                                    ' Hora de Transacción: '||Lv_HoraTrans;
      Lr_InfoReporteHistorial.FE_ULT_MOD           := SYSDATE;
      --Se crea registro de historial.
      DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_REPORTE_HIST(Lr_InfoReporteHistorial);
    --
    ELSE
    --
      Lv_MensajeError := Lv_Code || ' ' || Lv_Message || ' ' || Pv_TipoCierre;
    --
    END IF;
    
    IF Lv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := Lv_MensajeError;
      Raise Le_Error;
    ELSE
      Pv_CodigoError  := 'OK';
      Pv_MensajeError := 'Reporte de Cierre Fiscal enviado a la impresora Tipo: '||Pv_TipoCierre;
    END IF;
    --
    COMMIT;

    EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      Pv_CodigoError := 'Error';
      DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
      DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      DBMS_OUTPUT.PUT_LINE('');
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_TRANSACTION.P_API_CIERRE_FISCAL_TNP',
                                           'Error UTL_HTTP.end_of_body',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_FINANCIERO'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
      UTL_HTTP.end_response(Lhttp_Response);
    WHEN Le_Error THEN
      Pv_CodigoError := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_TRANSACTION.P_API_CIERRE_FISCAL_TNP',
                                           'Le_Error: ' || Lv_MensajeError || ' ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_FINANCIERO'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_CodigoError := 'Error';
      DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
      DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      DBMS_OUTPUT.PUT_LINE('');
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_TRANSACTION.P_API_CIERRE_FISCAL_TNP',
                                           'Error en FNCK_TRANSACTION.P_API_CIERRE_FISCAL_TNP: ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_FINANCIERO'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
    
   END P_API_CIERRE_FISCAL_TNP;

   PROCEDURE P_API_INTERFAZ_FACTURACION_TNP(Pn_IdDocumento  IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                           Pv_CodEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pv_CodigoError  OUT Varchar2,
                                           Pv_MensajeError OUT Varchar2) IS
  
    CURSOR C_JSON(Cn_IdDocumento Number) IS
      WITH DETALLE AS
         (SELECT '{' ||                
               ' "code":"' || CASE 
                 WHEN DET.PRODUCTO_ID IS NOT NULL THEN
                   DET.PRODUCTO_ID
                 WHEN DET.PLAN_ID  IS NOT NULL THEN
                   DET.PLAN_ID 
                 ELSE
                  0
               END || '"' ||                      
               ' ,"description":"' || CASE 
                 WHEN APRO.DESCRIPCION_PRODUCTO IS NOT NULL THEN
                   FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(APRO.DESCRIPCION_PRODUCTO)
                 WHEN APLAN.NOMBRE_PLAN  IS NOT NULL THEN
                   FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(APLAN.NOMBRE_PLAN)
                 ELSE
                  'Sin Descripcion'
               END || '"' ||                
               ' ,"qty":"' || DET.CANTIDAD || '"' ||
               ' ,"price":"' || DET.PRECIO_VENTA_FACPRO_DETALLE || '"' ||
               ' ,"discount":"' || CASE
                 WHEN DET.PORCETANJE_DESCUENTO_FACPRO <> 0 THEN
                  DET.PORCETANJE_DESCUENTO_FACPRO
                 WHEN DET.DESCUENTO_FACPRO_DETALLE <> 0 THEN
                  DET.PORCETANJE_DESCUENTO_FACPRO
                 ELSE
                  0
               END || '"' || ' ,"tax":"' || TRUNC(IMP.PORCENTAJE) || '"' ||
               ' ,"type":"' || '02' || '"' || '} ' json
          FROM INFO_DOCUMENTO_FINANCIERO_DET DET,
               ADMI_PRODUCTO                 APRO,
               DB_COMERCIAL.INFO_PLAN_CAB   APLAN,
               INFO_DOCUMENTO_FINANCIERO_IMP IMP
         WHERE DET.PRODUCTO_ID = APRO.ID_PRODUCTO(+)
           AND DET.PLAN_ID     = APLAN.ID_PLAN(+)
           AND DET.ID_DOC_DETALLE = IMP.DETALLE_DOC_ID(+)
           AND DET.DOCUMENTO_ID = Cn_IdDocumento),
      PAGO AS
       (SELECT '{' || ' "title":"' || FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(AFPA.DESCRIPCION_FORMA_PAGO) || '"' ||
               ' ,"amount":"' || CAB.VALOR_TOTAL || '"' || ' ,"type":"' ||
               AFPA.ID_FORMA_PAGO || '"' || '} ' json
          FROM INFO_DOCUMENTO_FINANCIERO_CAB CAB,
               INFO_PUNTO                    PUN,
               INFO_PERSONA_EMPRESA_ROL      IPER,
               INFO_CONTRATO                 ICON,
               ADMI_FORMA_PAGO               AFPA
         WHERE CAB.PUNTO_ID = PUN.ID_PUNTO
           AND PUN.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
           AND ICON.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
           AND AFPA.ID_FORMA_PAGO = ICON.FORMA_PAGO_ID
           AND CAB.ID_DOCUMENTO = Cn_IdDocumento),
      CABECERA AS
       (SELECT '{'
               -- ||' "apicode":"'||CAB.ID_DOCUMENTO||'"'    
                || ' "token":"' || CAB.ID_DOCUMENTO || '"' ||
                ' ,"documentNumber":"' || CAB.NUMERO_FACTURA_SRI || '"' ||
                ' ,"documentType":"' ||
                DECODE(CAB.TIPO_DOCUMENTO_ID, 1, 'A', 6, 'D', 7, 'B') || '"' ||
                ' ,"customerName":"' ||
                CASE INPE.RAZON_SOCIAL
                  WHEN NULL THEN
                   FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(INPE.NOMBRES || ' ' || INPE.APELLIDOS)
                  ELSE
                   FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(INPE.RAZON_SOCIAL)
                END || '"' || ' ,"customerId":"' ||
                INPE.IDENTIFICACION_CLIENTE || '"' || ' ,"customerAddress":"' ||
                CASE INPA.DIRECCION_ENVIO
                  WHEN NULL THEN
                   FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(INPE.DIRECCION)
                  ELSE
                   FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(PUN.DIRECCION)
                END || '"' || ' ,"payments": [' ||
                (select listagg(json, ',') within group(order by 1) as data
                   from PAGO) || ']' || ' ,"items": [' ||
                (select listagg(json, ',') within group(order by 1) as data
                   from DETALLE) || ']' || '} ' json
          FROM INFO_DOCUMENTO_FINANCIERO_CAB CAB,
               INFO_PUNTO                    PUN,
               INFO_PERSONA_EMPRESA_ROL      IPER,
               INFO_PERSONA                  INPE,
               INFO_PUNTO_DATO_ADICIONAL     INPA
         WHERE CAB.PUNTO_ID = PUN.ID_PUNTO
           AND CAB.PUNTO_ID = INPA.PUNTO_ID
           AND PUN.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
           AND IPER.PERSONA_ID = INPE.ID_PERSONA
           AND CAB.ID_DOCUMENTO = Cn_IdDocumento)
      SELECT (SELECT listagg(json, ',') within group(order by 1)
                FROM CABECERA)
        FROM CABECERA;
  
    CURSOR C_URL_INTERFAZ(Cv_CodEmpresa Varchar, Cv_Descripcion Varchar2) IS
      SELECT VALOR1
        FROM ADMI_PARAMETRO_DET
       WHERE EMPRESA_COD = Cv_CodEmpresa
         AND DESCRIPCION = Cv_Descripcion;
  
    CURSOR C_URL_ESCAPE(Cv_Json Varchar2) IS
      SELECT utl_url.escape(Cv_Json) FROM DUAL;
  
    Lv_Metodo                     VARCHAR2(10) := 'POST';
    Lv_Url                        VARCHAR2(32767);
    Ln_LongitudReq                NUMBER;
    Lv_Descripcion                ADMI_PARAMETRO_DET.Descripcion%TYPE := 'URL_INTERFAZ_API';
    Ln_LongitudIdeal              NUMBER := 32767;
    Ln_Offset                     NUMBER := 1;
    Ln_Buffer                     VARCHAR2(2000);
    Ln_Amount                     NUMBER := 2000;
    Lhttp_Request                 UTL_HTTP.req;
    Lhttp_Response                UTL_HTTP.resp;
    data                          VARCHAR2(4000);
    Lv_Json                       Varchar2(32767);
    Lv_UrlEscape                  Varchar2(32767);
    Lv_Response                   VARCHAR2(2000);
    Lv_Code                       VARCHAR2(2000);
    Lv_Message                    VARCHAR2(2000);
    Lv_DocumentNumber             VARCHAR2(2000);
    Lv_FiscalNumber               VARCHAR2(2000);
    Lr_InfoDocumentoFinancieroCab INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  
    Lv_MensajeError VARCHAR2(5000);
    Le_Error Exception;
  
  BEGIN
  
    IF C_JSON%ISOPEN THEN
      CLOSE C_JSON;
    END IF;
    OPEN C_JSON(Pn_IdDocumento);
    FETCH C_JSON
      INTO Lv_Json;
    CLOSE C_JSON;
  
    IF Lv_Json IS NULL THEN
      Lv_MensajeError := 'Json vacio';
    ELSE
      IF C_URL_ESCAPE%ISOPEN THEN
        CLOSE C_URL_ESCAPE;
      END IF;
      OPEN C_URL_ESCAPE(Lv_Json);
      FETCH C_URL_ESCAPE
        INTO Lv_UrlEscape;
      CLOSE C_URL_ESCAPE;
    END IF;
  
    IF C_URL_INTERFAZ%ISOPEN THEN
      CLOSE C_URL_INTERFAZ;
    END IF;
    OPEN C_URL_INTERFAZ(Pv_CodEmpresa, Lv_Descripcion);
    FETCH C_URL_INTERFAZ
      INTO Lv_Url;
    CLOSE C_URL_INTERFAZ;
  
    IF Lv_Url IS NULL THEN
      Lv_MensajeError := 'URL vacia';
    END IF;
  
    Lv_Url        := Lv_Url || '?request=' || Lv_UrlEscape;
    Lhttp_Request := UTL_HTTP.begin_request(url    => Lv_Url,
                                            method => Lv_Metodo);
    UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', 'application/json');
  
    Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
    utl_http.read_text(Lhttp_Response, data);
  
    apex_json.parse(data);
  
    Lv_Response       := apex_json.get_varchar2('response');
    Lv_Code           := apex_json.get_varchar2('code');
    Lv_Message        := apex_json.get_varchar2('message');
    Lv_DocumentNumber := apex_json.get_varchar2('documentNumber');
    Lv_FiscalNumber   := apex_json.get_varchar2('fiscalNumber');
  
    UTL_HTTP.end_response(Lhttp_Response);
  
    IF Lv_Response = 'true' THEN
      Lr_InfoDocumentoFinancieroCab.NUMERO_AUTORIZACION := Lv_FiscalNumber;
      UPDATE_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento,
                                     Lr_InfoDocumentoFinancieroCab,
                                     Lv_MensajeError);
      IF Lv_MensajeError IS NOT NULL THEN
        Lv_MensajeError := Lv_Code || ' ' || Lv_MensajeError;
      ELSE
        COMMIT;
      END IF;
    ELSE
      Lv_MensajeError := Lv_Code || ' ' || Lv_Message || ' ' ||
                         Lv_DocumentNumber;
    END IF;
  
    IF Lv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := Lv_MensajeError;
      Raise Le_Error;
    ELSE
      Pv_CodigoError  := 'OK';
      Pv_MensajeError := 'Documento enviado a la impresora.';
    END IF;
  
  EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      Pv_CodigoError := 'Error';
      DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
      DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      DBMS_OUTPUT.PUT_LINE('');
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_TRANSACTION.P_API_INTERFAZ_FACTURACION_TNP',
                                           'Error UTL_HTTP.end_of_body',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_FINANCIERO'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
      UTL_HTTP.end_response(Lhttp_Response);
    WHEN Le_Error THEN
      Pv_CodigoError := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_TRANSACTION.P_API_INTERFAZ_FACTURACION_TNP',
                                           'Le_Error: ' || Lv_MensajeError || ' ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_FINANCIERO'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_CodigoError := 'Error';
      DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
      DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      DBMS_OUTPUT.PUT_LINE('');
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_TRANSACTION.P_API_INTERFAZ_FACTURACION_TNP',
                                           'Error en FNCK_TRANSACTION.P_API_INTERFAZ_FACTURACION_TNP: ' ||
                                           SQLERRM || ' ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_FINANCIERO'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      ROLLBACK;
    
  END P_API_INTERFAZ_FACTURACION_TNP;


  PROCEDURE P_GENERA_NC_SOLICITUDES(Pv_CodEmpresa  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    
    Lv_DescripcionCaracteristica   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE         := 'SOLICITUD NOTA CREDITO';
    Lv_EstadoDocumento             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE   := 'Activo';
    Lv_EstadoNc                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE   := 'Pendiente';
    Lv_Observacion                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE             := 'Cancelacion Voluntaria';
    Lv_NombreMotivo                DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE                                := 'Cancelacion Voluntaria';
    Lv_UsrCreacion                 INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE                          := 'telcos_cancel';
    Lv_EstadoCaracteristica        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE                  := 'Activo';
    Lv_TipoDocumentoNc             DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE  := 'NC';
    Ln_IdDocumentoNC               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE            := 0;
    Lv_ValorDefaultNc              VARCHAR2(1)                                                              := 'N';
    Lv_FechaInicio                 VARCHAR2(5)                                                              := '';
    Lv_FechaFin                    VARCHAR2(5)                                                              := '';
    Lv_ObservacionCreacion         VARCHAR2(50)                                                             := '';
    Ln_Porcentaje                  NUMBER                                                                   := 0;
    Ln_ValorTotal                  NUMBER                                                                   := 0;
    Ln_MotivoId                    NUMBER                                                                   := NULL;
    Lbool_Done                     BOOLEAN                                                                  := FALSE;
    Lv_MsnError                    VARCHAR2(1000);

    CURSOR C_GetFacturasCaractNc (Cv_DescripcionCaracteristica DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_EstadoDocumento           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                                  Cv_EstadoCaracteristica      DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,
                                  Cv_CodEmpresa                DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT 
        CAB.ID_DOCUMENTO,
        CAB.TIPO_DOCUMENTO_ID,
        CAB.OFICINA_ID

      FROM
           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB CAB
      JOIN DB_COMERCIAL.INFO_PUNTO                     IPT  ON IPT.ID_PUNTO             = CAB.PUNTO_ID
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL       IPER ON IPER.ID_PERSONA_ROL      = IPT.PERSONA_EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_ROL               IER  ON IER.ID_EMPRESA_ROL       = IPER.EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO             IEG  ON IEG.COD_EMPRESA          = IER.EMPRESA_COD
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC  ON CAB.ID_DOCUMENTO         = IDC.DOCUMENTO_ID
      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC   ON AC.ID_CARACTERISTICA     = IDC.CARACTERISTICA_ID
      WHERE
          IEG.COD_EMPRESA               = Cv_CodEmpresa
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND CAB.ESTADO_IMPRESION_FACT     = Cv_EstadoDocumento
      AND IDC.ESTADO                    = Cv_EstadoDocumento
      and CAB.FE_CREACION >= (SYSDATE-1);


    CURSOR C_GetMotivoCancelacion(Cv_NombreMotivo DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE) IS
      SELECT AM.ID_MOTIVO
      FROM  DB_GENERAL.ADMI_MOTIVO  AM 
      WHERE AM.NOMBRE_MOTIVO  =  Cv_NombreMotivo      
      AND   AM.ESTADO         =  'Activo';


    CURSOR C_GetTipoDocIdNc(Cv_CodigoTipoDoc DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE) IS
      SELECT ATDF.ID_TIPO_DOCUMENTO
      FROM  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF 
      WHERE ATDF.CODIGO_TIPO_DOCUMENTO  =  Cv_CodigoTipoDoc      
      AND   ATDF.ESTADO                 =  'Activo';

    Lc_MotivoCancel  C_GetMotivoCancelacion%ROWTYPE;
    Lc_TipoDocIdNc   C_GetTipoDocIdNc%ROWTYPE;


  BEGIN

    IF C_GetFacturasCaractNc%ISOPEN THEN
      CLOSE C_GetFacturasCaractNc;
    END IF;


    IF C_GetMotivoCancelacion%ISOPEN THEN
      CLOSE C_GetMotivoCancelacion;
    END IF;

    OPEN C_GetMotivoCancelacion(Lv_NombreMotivo);
     FETCH C_GetMotivoCancelacion
        INTO Lc_MotivoCancel;
    CLOSE C_GetMotivoCancelacion;

    IF C_GetTipoDocIdNc%ISOPEN THEN
      CLOSE C_GetTipoDocIdNc;
    END IF;
 
    OPEN C_GetTipoDocIdNc(Lv_TipoDocumentoNc);
     FETCH C_GetTipoDocIdNc
        INTO Lc_TipoDocIdNc;
    CLOSE C_GetTipoDocIdNc;  

    FOR Lc_GetFacturasCaractNc IN C_GetFacturasCaractNc( Lv_DescripcionCaracteristica, 
                                                         Lv_EstadoDocumento,
                                                         Lv_EstadoCaracteristica,
                                                         Pv_CodEmpresa )
    LOOP

      DB_FINANCIERO.FNCK_CONSULTS.P_CREA_NOTA_CREDITO(Lc_GetFacturasCaractNc.ID_DOCUMENTO,
                                          Lc_TipoDocIdNc.ID_TIPO_DOCUMENTO,
                                          Lv_Observacion,
                                          Lc_MotivoCancel.ID_MOTIVO,
                                          Lv_UsrCreacion,
                                          Lv_EstadoNc,
                                          Lv_ValorDefaultNc,
                                          Lv_ValorDefaultNc,
                                          Ln_Porcentaje,
                                          Lv_ValorDefaultNc,
                                          Lv_FechaInicio,
                                          Lv_FechaFin,
                                          Lc_GetFacturasCaractNc.OFICINA_ID,
                                          Pv_CodEmpresa,
                                          Ln_ValorTotal,
                                          Ln_IdDocumentoNC,
                                          Lv_ObservacionCreacion,
                                          Lbool_Done,
                                          Lv_MsnError);
    
       DBMS_OUTPUT.PUT_LINE(Lv_ObservacionCreacion);

     END LOOP;

  EXCEPTION
  --
  WHEN OTHERS THEN
  --
    Lv_MsnError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    FNCK_TRANSACTION.INSERT_ERROR('P_GENERA_NC_SOLICITUDES', 'FNCK_TRANSACTION.P_GENERA_NC_SOLICITUDES', Lv_MsnError);
  --
  END P_GENERA_NC_SOLICITUDES;

 PROCEDURE P_MARCAR_FACTURAS_PUNTO (Pn_PuntoId          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                    Pn_CaracteristicaId IN DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
                                    Pv_UsrCreacion      IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                    Pv_Mensaje          OUT VARCHAR2)
  IS
    Lrf_GetFacturasPto             SYS_REFCURSOR;
    Lr_FacturasPto                 T_FacturasPto;
    Le_Exception                   EXCEPTION;
    Ln_Indsx                       NUMBER;
    Lv_EstadoActivo                VARCHAR2(6)   := 'Activo';
    Lv_MensajeError                VARCHAR2(100) := 'Error ';
    Lr_InfoDocumentoCaracteristica DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
    Lr_FacturaPto                  DB_FINANCIERO.FNKG_TYPES.Lr_FacturasPto;


  BEGIN

        IF Lrf_GetFacturasPto%ISOPEN THEN
          CLOSE Lrf_GetFacturasPto;
        END IF;

        DB_FINANCIERO.FNCK_CANCELACION_VOL.P_GET_FACTURAS_BY_PTOCARACTID(Pn_PuntoId,
                                                                         Pn_CaracteristicaId,
                                                                         Lrf_GetFacturasPto);
        LOOP

          FETCH Lrf_GetFacturasPto BULK COLLECT INTO Lr_FacturasPto LIMIT 1000;
          Ln_Indsx := Lr_FacturasPto.FIRST;
          WHILE (Ln_Indsx IS NOT NULL)
            LOOP
                Lr_FacturaPto:=Lr_FacturasPto(Ln_Indsx);
                Lr_InfoDocumentoCaracteristica                             := NULL;
                Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Lr_FacturaPto.ID_DOCUMENTO;
                Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Pn_CaracteristicaId;
                Lr_InfoDocumentoCaracteristica.VALOR                       := '';
                Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;
                Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
                Lr_InfoDocumentoCaracteristica.USR_CREACION                := Pv_UsrCreacion;
                Lr_InfoDocumentoCaracteristica.IP_CREACION                 := '127.0.0.1';

                DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaracteristica, Pv_Mensaje);

                IF Pv_Mensaje IS NOT NULL THEN
                  RAISE Le_Exception;
                END IF;
              Ln_Indsx := Lr_FacturasPto.NEXT(Ln_Indsx);
            END LOOP;
            EXIT
              WHEN Lrf_GetFacturasPto%notfound;
          
        END LOOP;
	CLOSE Lrf_GetFacturasPto;

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Mensaje := Lv_MensajeError || Pv_Mensaje;
    WHEN OTHERS THEN
      Pv_Mensaje := Lv_MensajeError || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                    ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_MARCAR_FACTURAS_PUNTO;

  --
  PROCEDURE P_GENERA_NC_SOLICITUDES_REUB(Pv_CodEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
  IS
    CURSOR C_GetFacturasCaractNcReub(Cv_DescTipoSolicitud DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                     Cv_DescCaractFact    DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,
                                     Cv_UsrCreacion       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                     Cv_CodEmpresa        DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Cv_CodTipoDocumento  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                     Cv_EstadoActivo      VARCHAR2,
                                     Cv_EstadoPendiente   VARCHAR2)
    IS
      SELECT IDFC.ID_DOCUMENTO, IDFC.TIPO_DOCUMENTO_ID, IDFC.OFICINA_ID, IDS.ID_DETALLE_SOLICITUD
      FROM
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD  IDS,
        DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC,
        DB_COMERCIAL.ADMI_TIPO_SOLICITUD     ATS,
        DB_COMERCIAL.ADMI_CARACTERISTICA     AC,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      WHERE
         IDS.ID_DETALLE_SOLICITUD         = IDSC.DETALLE_SOLICITUD_ID
        AND IDS.TIPO_SOLICITUD_ID         = ATS.ID_TIPO_SOLICITUD  
        AND ATS.DESCRIPCION_SOLICITUD     = Cv_DescTipoSolicitud
        AND IDSC.CARACTERISTICA_ID        = AC.ID_CARACTERISTICA
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescCaractFact
        AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID
        AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0) = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDSC.VALOR,'^\d+')),0)
        AND IDFC.USR_CREACION             = Cv_UsrCreacion
        AND IP.ID_PUNTO                   = IDFC.PUNTO_ID 
        AND IDFC.OFICINA_ID               = IOG.ID_OFICINA
        AND IEG.COD_EMPRESA               = IOG.EMPRESA_ID
        AND IEG.COD_EMPRESA               = Cv_CodEmpresa    
        AND IDFC.ESTADO_IMPRESION_FACT    = Cv_EstadoActivo  
        AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
        AND ATDF.CODIGO_TIPO_DOCUMENTO    = Cv_CodTipoDocumento
        AND IDC.ESTADO                    = Cv_EstadoActivo  
        AND IDSC.ESTADO                   = Cv_EstadoActivo 
        AND IDS.ESTADO                    = Cv_EstadoPendiente
        AND NOT EXISTS (SELECT IDFC_NC.ID_DOCUMENTO 
                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_NC,
                          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_NC
                        WHERE IDFC_NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                          AND IDFC_NC.TIPO_DOCUMENTO_ID = ATDF_NC.ID_TIPO_DOCUMENTO
                          AND ATDF_NC.CODIGO_TIPO_DOCUMENTO = 'NC'
                          AND IDFC_NC.ESTADO_IMPRESION_FACT   NOT IN ('Eliminado','Anulado') 
                        );

    CURSOR C_GetIdMotivo(Cv_CaractMotivoNc DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                         Cv_EstadoActivo   VARCHAR2,
                         Cv_IdSolicitudNc  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.DETALLE_SOLICITUD_ID%TYPE) 
    IS
      SELECT AM.ID_MOTIVO
      FROM  DB_GENERAL.ADMI_MOTIVO AM 
      WHERE AM.NOMBRE_MOTIVO IN ( SELECT IDSC.VALOR 
                                  FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS, 
                                    DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC, 
                                    DB_COMERCIAL.ADMI_CARACTERISTICA AC
                                  WHERE
                                        IDS.ID_DETALLE_SOLICITUD      = IDSC.DETALLE_SOLICITUD_ID 
                                    AND IDSC.CARACTERISTICA_ID        = AC.ID_CARACTERISTICA
                                    AND AC.DESCRIPCION_CARACTERISTICA = Cv_CaractMotivoNc
                                    AND IDSC.ESTADO                   = Cv_EstadoActivo
                                    AND IDSC.DETALLE_SOLICITUD_ID     = Cv_IdSolicitudNc );

    CURSOR C_GetValorPorCaract(Cv_CaractMotivoNc DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Cv_EstadoActivo   VARCHAR2,
                                Cv_IdSolicitudNc  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.DETALLE_SOLICITUD_ID%TYPE) 
    IS
      SELECT IDSC.VALOR 
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS, 
        DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC, 
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE
            IDS.ID_DETALLE_SOLICITUD      = IDSC.DETALLE_SOLICITUD_ID 
        AND IDSC.CARACTERISTICA_ID        = AC.ID_CARACTERISTICA
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_CaractMotivoNc
        AND IDSC.ESTADO                   = Cv_EstadoActivo
        AND IDSC.DETALLE_SOLICITUD_ID     = Cv_IdSolicitudNc;

    CURSOR C_GetTipoDocIdNc(Cv_CodigoTipoDoc DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                            Cv_EstadoActivo  VARCHAR2) 
    IS
      SELECT ATDF.ID_TIPO_DOCUMENTO
      FROM  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF 
      WHERE ATDF.CODIGO_TIPO_DOCUMENTO = Cv_CodigoTipoDoc      
        AND   ATDF.ESTADO              = Cv_EstadoActivo;

    --  
    Lv_DescCaractFact         DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE        := 'SOLICITUD_FACT_REUBICACION'; 
    Lv_DescCaractMotivoNc     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE        := 'MOTIVO_NC_REUBICACION';
    Lv_DescCaractPorcentajeNc DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE        := 'PORCENTAJE_NC_REUBICACION';
    Lv_NombreMotivo           DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE                               := ''; 
    Lv_UsrCreacion            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE           := 'telcos_reubica';
    Lv_CodTipoDocumentoNc     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'NC';
    Lv_CodTipoDocumentoFact   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'FAC';
    Ln_IdDocumentoNC          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE           := 0;

    Lv_DescTipoSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE:='SOLICITUD NOTA CREDITO POR REUBICACION';
    Lv_AplicaProceso     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE;

    Lv_Observacion         VARCHAR2(1000) := 'Se crea Nota de Crédito por Reubicación';
    Lv_FechaInicio         VARCHAR2(10)   := '';
    Lv_FechaFin            VARCHAR2(10)   := '';
    Lv_EstadoActivo        VARCHAR2(50)   := 'Activo';
    Lv_EstadoPendiente     VARCHAR2(50)   := 'Pendiente';
    Lv_ValorOriginal       VARCHAR2(1)    := 'Y';
    Lv_PorcentajeServicio  VARCHAR2(1)    := 'N';
    Lv_ProporcionalPorDias VARCHAR2(1)    := 'N'; 
    Ln_Porcentaje          NUMBER         := 0;
    Ln_ValorTotal          NUMBER         := 0;
    Lv_ObservacionCreacion VARCHAR2(1000) := '';
    Lbool_Done             BOOLEAN        := FALSE;
    Lv_MsnError            VARCHAR2(1000);  
    Lv_LogNcReub           VARCHAR2(2000);

    Lc_TipoDocIdNc         C_GetTipoDocIdNc%ROWTYPE;
    Lc_GetIdMotivo         C_GetIdMotivo%ROWTYPE;
    Lc_GetValorPorCaract   C_GetValorPorCaract%ROWTYPE;

  BEGIN

    IF C_GetFacturasCaractNcReub%ISOPEN THEN
      CLOSE C_GetFacturasCaractNcReub;
    END IF;

    IF C_GetIdMotivo%ISOPEN THEN
      CLOSE C_GetIdMotivo;
    END IF;

    IF C_GetValorPorCaract%ISOPEN THEN
        CLOSE C_GetValorPorCaract;
    END IF;

    IF C_GetTipoDocIdNc%ISOPEN THEN
      CLOSE C_GetTipoDocIdNc;
    END IF;

    OPEN C_GetTipoDocIdNc(Lv_CodTipoDocumentoNc, Lv_EstadoActivo);
        FETCH C_GetTipoDocIdNc INTO Lc_TipoDocIdNc;
    CLOSE C_GetTipoDocIdNc;  
    --

    FOR Lc_GetFacturasCaractNc IN C_GetFacturasCaractNcReub(Lv_DescTipoSolicitud, 
                                                            Lv_DescCaractFact,
                                                            Lv_UsrCreacion,
                                                            Pv_CodEmpresa,
                                                            Lv_CodTipoDocumentoFact,
                                                            Lv_EstadoActivo,
                                                            Lv_EstadoPendiente)
    LOOP

        IF C_GetIdMotivo%ISOPEN THEN
            CLOSE C_GetIdMotivo;
        END IF;

        IF C_GetValorPorCaract%ISOPEN THEN
            CLOSE C_GetValorPorCaract;
        END IF;

        -- Obtiene el idMotivo ligado a la solicitud de NC
        OPEN C_GetIdMotivo(Lv_DescCaractMotivoNc, Lv_EstadoActivo, Lc_GetFacturasCaractNc.ID_DETALLE_SOLICITUD);
            FETCH C_GetIdMotivo INTO Lc_GetIdMotivo;
        CLOSE C_GetIdMotivo; 

        -- Obtiene porcentaje ligado a la solicitud de Nc
        OPEN C_GetValorPorCaract(Lv_DescCaractPorcentajeNc, Lv_EstadoActivo, Lc_GetFacturasCaractNc.ID_DETALLE_SOLICITUD);
            FETCH C_GetValorPorCaract INTO Ln_Porcentaje;
        CLOSE C_GetValorPorCaract; 

        IF Ln_Porcentaje <> 0 THEN          
            Lv_ValorOriginal      := 'N';
            Lv_PorcentajeServicio := 'Y';
        END IF;

        Lv_LogNcReub := 'PARAMETROS ENTRADA: ' || '-ID_FACT: ' || Lc_GetFacturasCaractNc.ID_DOCUMENTO || ' -ValorOriginal: ' || Lv_ValorOriginal
                        || ' -PorcentajeServicio: ' || Lv_PorcentajeServicio || ' -Porcentaje: ' || Ln_Porcentaje  
                        || ' -ProporcionalPorDias: ' || Lv_ProporcionalPorDias;
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('LOGS_NC_SOLICITUDES_REUB','LOGS_NC_SOLICITUDES_REUB',Lv_LogNcReub); 

        DB_FINANCIERO.FNCK_CONSULTS.P_CREA_NOTA_CREDITO(Lc_GetFacturasCaractNc.ID_DOCUMENTO,
                                                        Lc_TipoDocIdNc.ID_TIPO_DOCUMENTO,
                                                        Lv_Observacion,
                                                        Lc_GetIdMotivo.ID_MOTIVO,
                                                        Lv_UsrCreacion,
                                                        Lv_EstadoPendiente,
                                                        Lv_ValorOriginal,
                                                        Lv_PorcentajeServicio,
                                                        Ln_Porcentaje,
                                                        Lv_ProporcionalPorDias,
                                                        Lv_FechaInicio,
                                                        Lv_FechaFin,
                                                        Lc_GetFacturasCaractNc.OFICINA_ID,
                                                        Pv_CodEmpresa,
                                                        Ln_ValorTotal,
                                                        Ln_IdDocumentoNC,
                                                        Lv_ObservacionCreacion,
                                                        Lbool_Done,
                                                        Lv_MsnError);

        IF Lv_MsnError IS NULL AND Ln_IdDocumentoNC IS NOT NULL THEN
            Lv_AplicaProceso := DB_GENERAL.GNRLPCK_UTIL.F_EMPRESA_APLICA_PROCESO('NUMERACION_AUTOMATICA_NOTA_CREDITO', Pv_CodEmpresa);

            IF TRIM(Lv_AplicaProceso) = 'S' THEN
                --Se enumera automáticamente la nota de crédito.
                DB_FINANCIERO.FNCK_TRANSACTION.P_NUMERA_NOTA_CREDITO(Pn_DocumentoId    => Ln_IdDocumentoNC,
                                                                     Pv_PrefijoEmpresa => Pv_PrefijoEmpresa,
                                                                     Pv_ObsHistorial   => Lv_ObservacionCreacion,
                                                                     Pv_UsrCreacion    => Lv_UsrCreacion,
                                                                     Pv_Mensaje        => Lv_MsnError);
            END IF; 
        END IF;  

        DBMS_OUTPUT.PUT_LINE(Lv_ObservacionCreacion);

        Lv_LogNcReub := 'PARAMETROS SALIDA: ' || '-ID_FACT: ' || Lc_GetFacturasCaractNc.ID_DOCUMENTO || ' -ID_NC: ' || Ln_IdDocumentoNC 
                         || ' -ValorTotal: ' || Ln_ValorTotal || ' -ObservacionCreacionNc: ' || Lv_ObservacionCreacion;
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('LOGS_NC_SOLICITUDES_REUB','LOGS_NC_SOLICITUDES_REUB',Lv_LogNcReub);

     END LOOP; 

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsnError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('P_GENERA_NC_SOLICITUDES_REUB','FNCK_TRANSACTION.P_GENERA_NC_SOLICITUDES_REUB',Lv_MsnError);
  --
  END P_GENERA_NC_SOLICITUDES_REUB;
  --

  PROCEDURE P_CLONAR_CARACT_NC_REUB(Pn_DetalleSolicitudId IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                    Pn_IdDocumento        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                    Pv_Mensaje            OUT VARCHAR2)
  IS
    --CURSOR QUE OBTIENE LAS CARACTERÍSTICAS DE UNA SOLICITUD
    CURSOR C_ObtieneCaracteristicas(Cn_DetalleSolicitudId DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                    Cv_Estado             DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
    IS
      SELECT IDSC.CARACTERISTICA_ID,
        IDSC.VALOR,
        IDSC.ESTADO,
        IDSC.USR_CREACION
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
      WHERE IDSC.DETALLE_SOLICITUD_ID = Cn_DetalleSolicitudId
        AND IDSC.ESTADO               = Cv_Estado;
    --

    Lr_InfoDocumentoCaracteristica DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
    Le_Exception                   EXCEPTION;
    Lv_EstadoActivo                VARCHAR2(15)  := 'Activo';
    Lv_MensajeError                VARCHAR2(500) := 'Ocurrió un error al clonar las características de la solicitud al documento:';

  BEGIN

    IF C_ObtieneCaracteristicas%ISOPEN THEN
        CLOSE C_ObtieneCaracteristicas;
    END IF;

    --Se Iteran Las Características De La Solicitud
    FOR Lr_ObtieneSolCarac IN C_ObtieneCaracteristicas(Pn_DetalleSolicitudId,
                                                       Lv_EstadoActivo)
    LOOP
        --Se clonan las características de la solicitud como características del documento.
        Lr_InfoDocumentoCaracteristica                             := NULL;
        Pv_Mensaje                                                 := NULL;
        Lr_InfoDocumentoCaracteristica.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
        Lr_InfoDocumentoCaracteristica.DOCUMENTO_ID                := Pn_IdDocumento;
        Lr_InfoDocumentoCaracteristica.CARACTERISTICA_ID           := Lr_ObtieneSolCarac.CARACTERISTICA_ID;
        Lr_InfoDocumentoCaracteristica.VALOR                       := Lr_ObtieneSolCarac.VALOR;
         --La característica queda activa para poder ser visualizada en telcos
        Lr_InfoDocumentoCaracteristica.ESTADO                      := Lv_EstadoActivo;
        Lr_InfoDocumentoCaracteristica.FE_CREACION                 := SYSDATE;
        Lr_InfoDocumentoCaracteristica.USR_CREACION                := Lr_ObtieneSolCarac.USR_CREACION;
        Lr_InfoDocumentoCaracteristica.IP_CREACION                 := '127.0.0.1';

        --Se inserta la característica en info_documento_caracteristica
        DB_FINANCIERO.FNCK_TRANSACTION.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaracteristica, Pv_Mensaje);

        IF Pv_Mensaje IS NOT NULL THEN
            RAISE Le_Exception;
        END IF;

    END LOOP;

  EXCEPTION
    WHEN Le_Exception THEN
        Pv_Mensaje := Lv_MensajeError || Pv_Mensaje;
    WHEN OTHERS THEN
        Pv_Mensaje := Lv_MensajeError || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                    ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_CLONAR_CARACT_NC_REUB;
  --

  PROCEDURE P_REPORTE_REUBICACION(Pv_FechaReporte    IN VARCHAR2,
                                  Pv_EmpresaCod      IN VARCHAR2,
                                  Pv_PrefijoEmpresa  IN VARCHAR2,
                                  Pv_UsuarioCreacion IN VARCHAR2,
                                  Pv_EmailUsuario    IN VARCHAR2) 
  IS
    CURSOR C_DocumentosEmitidos(Cv_CodigoTipoDoc        IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                Cv_DescCaractFactReub   IN VARCHAR2,
                                Cv_EmpresaCod           IN VARCHAR2,
                                Cv_UsuarioCreacion      IN VARCHAR2)
    IS
      SELECT
        IDFC.ID_DOCUMENTO,
        PERS.IDENTIFICACION_CLIENTE,
        IP.LOGIN,
        IDFC.FE_EMISION AS FE_EMISION_FACT,
        IDFC.NUMERO_FACTURA_SRI,
        IDFC.VALOR_TOTAL AS VALOR_TOTAL_FACT,
        DB_FINANCIERO.FNCK_TRANSACTION.F_GET_VALORES_REPORTE_NC_REUB(IDFC.ID_DOCUMENTO, 'numNotaCredito') AS NUMERO_NC,
        DB_FINANCIERO.FNCK_TRANSACTION.F_GET_VALORES_REPORTE_NC_REUB(IDFC.ID_DOCUMENTO, 'valorTotalNc')   AS VALOR_TOTAL_NC,
        DB_FINANCIERO.FNCK_TRANSACTION.F_GET_VALORES_REPORTE_NC_REUB(IDFC.ID_DOCUMENTO, 'autorizadoNc')   AS PERSONA_AUTORIZA_NC
      FROM
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA PERS,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      WHERE
            IP.ID_PUNTO                   = IDFC.PUNTO_ID                
        AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL  
        AND IPER.PERSONA_ID               = PERS.ID_PERSONA     
        AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
        AND ATDF.CODIGO_TIPO_DOCUMENTO    = Cv_CodigoTipoDoc
        AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID
        AND IDC.CARACTERISTICA_ID         = AC.ID_CARACTERISTICA
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescCaractFactReub
        AND IDFC.OFICINA_ID               = IOG.ID_OFICINA
        AND IEG.COD_EMPRESA               = IOG.EMPRESA_ID
        AND IEG.COD_EMPRESA               = Cv_EmpresaCod
        AND IDFC.USR_CREACION             = Cv_UsuarioCreacion
        AND TRUNC(IDFC.FE_CREACION)       = Pv_FechaReporte; 

    -- 
    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100)   := 'telcos@telconet.ec'; 
    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_DescCaractFactReub    VARCHAR2(50)    := 'SOLICITUD_FACT_REUBICACION';
    Lv_CodigoTipoDoc 	     VARCHAR2(10)    := 'FAC';

    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

  BEGIN

    IF C_DocumentosEmitidos%ISOPEN THEN
        CLOSE C_DocumentosEmitidos;
    END IF;
    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_REUBICACION'); 
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Pv_EmailUsuario,'notificaciones_telcos@telconet.ec')||','; 
    Lv_NombreArchivo     := 'ReporteReubicacionDeEquipos_'||Pv_PrefijoEmpresa||'_'||'DIARIO'||'_'||Lv_FechaReporte||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lv_Asunto            := 'Notificacion REPORTE REUBICACION';

    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
    --
    utl_file.put_line(Lfile_Archivo,
                        'IDENTIFICACION_CLIENTE'    ||Lv_Delimitador
                        ||'LOGIN'                   ||Lv_Delimitador
                        ||'FE_EMISION_FACT'         ||Lv_Delimitador
                        ||'NUMERO_FACTURA_SRI'      ||Lv_Delimitador
                        ||'VALOR_TOTAL_FACT'        ||Lv_Delimitador
                        ||'NUMERO_NC'               ||Lv_Delimitador
                        ||'VALOR_TOTAL_NC'          ||Lv_Delimitador
                        ||'PERSONA_AUTORIZA_NC'     ||Lv_Delimitador); 

    FOR Lc_DocumentosEmitidos IN C_DocumentosEmitidos(Lv_CodigoTipoDoc, 
                                                      Lv_DescCaractFactReub,
                                                      Pv_EmpresaCod,
                                                      Pv_UsuarioCreacion)
    LOOP                

        UTL_FILE.PUT_LINE(Lfile_Archivo,
                            NVL(Lc_DocumentosEmitidos.IDENTIFICACION_CLIENTE, '')               ||Lv_Delimitador
                          ||NVL(Lc_DocumentosEmitidos.LOGIN, '')                                ||Lv_Delimitador
                          ||NVL(Lc_DocumentosEmitidos.FE_EMISION_FACT, '')                      ||Lv_Delimitador
                          ||NVL(Lc_DocumentosEmitidos.NUMERO_FACTURA_SRI, '')                   ||Lv_Delimitador
                          ||NVL(REPLACE(Lc_DocumentosEmitidos.VALOR_TOTAL_FACT,',','.'), '')    ||Lv_Delimitador
                          ||NVL(Lc_DocumentosEmitidos.NUMERO_NC, '')                            ||Lv_Delimitador
                          ||NVL(REPLACE(Lc_DocumentosEmitidos.VALOR_TOTAL_NC,',','.'), '')      ||Lv_Delimitador
                          ||NVL(Lc_DocumentosEmitidos.PERSONA_AUTORIZA_NC, '')                  ||Lv_Delimitador
                         );
    END LOOP;
    -- 
    UTL_FILE.fclose(Lfile_Archivo);
    dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 

    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip);
                                                  
    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip); 

  EXCEPTION
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurrió un error al generar el reporte de Fact y Nc emitidas por reubicación. '
                       ||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('P_REPORTE_REUBICACION','FNCK_TRANSACTION.P_REPORTE_REUBICACION',Lv_MsjResultado);  

  END P_REPORTE_REUBICACION;
  --

  FUNCTION F_GET_VALORES_REPORTE_NC_REUB(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                         Fv_TipoConsulta IN VARCHAR2) 
  RETURN VARCHAR2 
  IS   
    CURSOR C_GetValoresNcReub(Cn_IdDocumento     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                              Cv_CodigoDocumento DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE) 
    IS
      SELECT IDFC_NC.ID_DOCUMENTO, IDFC_NC.NUMERO_FACTURA_SRI, IDFC_NC.VALOR_TOTAL 
      FROM 
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_NC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_NC
      WHERE                
            IDFC_NC.TIPO_DOCUMENTO_ID       = ATDF_NC.ID_TIPO_DOCUMENTO
        AND ATDF_NC.CODIGO_TIPO_DOCUMENTO   = Cv_CodigoDocumento
        AND IDFC_NC.REFERENCIA_DOCUMENTO_ID = Cn_IdDocumento;

    CURSOR C_GetCaractNcReub(Cn_IdDocumentoNc        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                             Cv_DescCaractAutorizado DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE) 
    IS
      SELECT IDC_NC.VALOR 
      FROM
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_NC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC_NC
      WHERE                
            IDC_NC.CARACTERISTICA_ID         = AC_NC.ID_CARACTERISTICA
        AND AC_NC.DESCRIPCION_CARACTERISTICA = Cv_DescCaractAutorizado 
        AND IDC_NC.DOCUMENTO_ID              = Cn_IdDocumentoNc;   
    --

    Lv_CampoRetorna         VARCHAR2(100)                                                           := '';
    Lv_MsjResultado         VARCHAR2(100)                                                           := '';
    Lv_CodigoDocumento      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'NC';  
    Lv_UsrCreacion          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.USR_CREACION%TYPE          := 'telcos_reubica';  
    Lv_DescCaractAutorizado DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE        := 'AUTORIZADO_NC_REUBICACION'; 
    Lc_ValoresNcReub        C_GetValoresNcReub%ROWTYPE;
    Lc_CaractNcReub         C_GetCaractNcReub%ROWTYPE;

  BEGIN

    IF C_GetValoresNcReub%ISOPEN THEN
        CLOSE C_GetValoresNcReub;
    END IF;

    IF C_GetCaractNcReub%ISOPEN THEN
        CLOSE C_GetCaractNcReub;
    END IF;

    OPEN C_GetValoresNcReub(Fn_IdDocumento, Lv_CodigoDocumento);
        FETCH C_GetValoresNcReub INTO Lc_ValoresNcReub;
    CLOSE C_GetValoresNcReub; 
    --
    CASE 
        WHEN Fv_TipoConsulta = 'numNotaCredito' THEN

            Lv_CampoRetorna := Lc_ValoresNcReub.NUMERO_FACTURA_SRI;

        WHEN Fv_TipoConsulta = 'valorTotalNc' THEN

            Lv_CampoRetorna := TO_CHAR(Lc_ValoresNcReub.VALOR_TOTAL);  

        WHEN Fv_TipoConsulta = 'autorizadoNc' THEN

        OPEN C_GetCaractNcReub(Lc_ValoresNcReub.ID_DOCUMENTO, Lv_DescCaractAutorizado);
            FETCH C_GetCaractNcReub INTO Lc_CaractNcReub;
        CLOSE C_GetCaractNcReub; 

        Lv_CampoRetorna := Lc_CaractNcReub.VALOR;  
    --
    END CASE;

    RETURN Lv_CampoRetorna;

  EXCEPTION
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurrió un error al obtener los valores de Nc por reubicación. '
                       ||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('F_GET_VALORES_REPORTE_NC_REUB','FNCK_TRANSACTION.F_GET_VALORES_REPORTE_NC_REUB',Lv_MsjResultado); 
    Lv_CampoRetorna := '';
    RETURN Lv_CampoRetorna;

  END F_GET_VALORES_REPORTE_NC_REUB;
  --

  PROCEDURE P_CREA_NOTA_CREDITO_REUB(Pn_IdDocumento        IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                     Pn_TipoDocumentoId    IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                     Pn_IdMotivo           IN ADMI_MOTIVO.ID_MOTIVO%TYPE,
                                     Pv_ValorOriginal      IN VARCHAR2,
                                     Pv_PorcentajeServicio IN VARCHAR2,
                                     Pn_Porcentaje         IN NUMBER,
                                     Pn_IdOficina          IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                     Pn_IdEmpresa          IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pn_IdDocumentoNC      OUT INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                     Pv_MessageError       OUT VARCHAR2)
  IS

    Ln_IdDocumentoNC       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE := 0;
    Lv_FechaInicio         VARCHAR2(10)  := '';
    Lv_FechaFin            VARCHAR2(10)  := '';
    Lv_ValorOriginal       VARCHAR2(1);
    Lv_PorcentajeServicio  VARCHAR2(1); 
    Ln_Porcentaje          NUMBER        := 0;
    Ln_ValorTotal          NUMBER        := 0;
    Lv_ObservacionCreacion VARCHAR2(100) := '';
    Lv_UsrCreacion         VARCHAR2(20)  := 'telcos_reubica';
    Lv_Observacion         VARCHAR2(100) := 'Se crea nota de crédito por reubicación';
    Lv_Estado              VARCHAR2(20)  := 'Pendiente';
    Lv_ProporcionalPorDias VARCHAR2(1)   := 'N';
    Lbool_Done             BOOLEAN       := FALSE;
    Lv_MsnError            VARCHAR2(1000);  

  BEGIN
 
    DB_FINANCIERO.FNCK_CONSULTS.P_CREA_NOTA_CREDITO(Pn_IdDocumento,
                                                    Pn_TipoDocumentoId,
                                                    Lv_Observacion,
                                                    Pn_IdMotivo,
                                                    Lv_UsrCreacion,
                                                    Lv_Estado,
                                                    Pv_ValorOriginal,
                                                    Pv_PorcentajeServicio,
                                                    Pn_Porcentaje,
                                                    Lv_ProporcionalPorDias,
                                                    Lv_FechaInicio,
                                                    Lv_FechaFin,
                                                    Pn_IdOficina,
                                                    Pn_IdEmpresa,
                                                    Ln_ValorTotal,
                                                    Ln_IdDocumentoNC,
                                                    Lv_ObservacionCreacion,
                                                    Lbool_Done,
                                                    Lv_MsnError);
                                                          
    Pn_IdDocumentoNC       := Ln_IdDocumentoNC;
    Pv_MessageError        := Lv_MsnError;

  EXCEPTION
  --
  WHEN OTHERS THEN
  --
    Lv_MsnError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pn_IdDocumentoNC       := 0 ;
    Pv_MessageError        := Lv_MsnError;
    
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('P_CREA_NOTA_CREDITO_REUB','FNCK_TRANSACTION.P_CREA_NOTA_CREDITO_REUB',Lv_MsnError);
  --
  END P_CREA_NOTA_CREDITO_REUB;
  --
  
  PROCEDURE P_RECHAZA_SOLICITUDES_REUB(Pv_EmpresaCod  IN DB_SOPORTE.INFO_COMUNICACION.EMPRESA_COD%TYPE,
                                       Pv_UsrCreacion IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE)
  IS
  
    --Cursor que obtiene todas las solicitudes de fact ó Nc por reubicación ligadas a tarea que poseen estado 'Anulada', 'Rechazada', 'Cancelada'.
    CURSOR C_ObtieneSolicitudesReub(Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                    Cv_UsrCreacion       DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE,
                                    Cv_EmpresaCod        DB_SOPORTE.INFO_COMUNICACION.EMPRESA_COD%TYPE)
    IS
      SELECT IDS.ID_DETALLE_SOLICITUD, IDSC.VALOR
      FROM
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
        DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE 
            IDS.ID_DETALLE_SOLICITUD      = IDSC.DETALLE_SOLICITUD_ID
        AND IDSC.CARACTERISTICA_ID        = AC.ID_CARACTERISTICA 
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
        AND IDS.USR_CREACION              = Cv_UsrCreacion
        AND IDSC.USR_CREACION             = Cv_UsrCreacion
        AND IDS.ESTADO                    NOT IN ('Finalizado', 'Finalizada', 'Rechazada')
        AND EXISTS (SELECT IC.ID_COMUNICACION 
                    FROM DB_SOPORTE.INFO_COMUNICACION IC,
                      DB_SOPORTE.INFO_DETALLE_HISTORIAL IDH
                    WHERE IC.ID_COMUNICACION = IDSC.VALOR
                      AND IC.DETALLE_ID      = IDH.DETALLE_ID
                      AND IC.EMPRESA_COD     = Cv_EmpresaCod
                      AND IDH.ESTADO         IN ('Anulada', 'Rechazada', 'Cancelada'));
    --

    Lr_InfoDetSolicitud    DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE ;
    Lr_InfoDetSolHistorial DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE ;
    
    Lv_DescripcionCaract   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'NUMERO_TAREA_REUBICACION';
    Lv_EstadoRechazada     VARCHAR2(20)                                                     := 'Rechazada';
    Lv_MensajeError        VARCHAR2(100);
    Le_Exception           EXCEPTION;
    
  BEGIN

    IF C_ObtieneSolicitudesReub%ISOPEN THEN
        CLOSE C_ObtieneSolicitudesReub;
    END IF;

    FOR Lr_SolicitudReubicacion IN C_ObtieneSolicitudesReub(Lv_DescripcionCaract,
                                                              Pv_UsrCreacion,
                                                              Pv_EmpresaCod)
    LOOP
        Lr_InfoDetSolicitud.ID_DETALLE_SOLICITUD := Lr_SolicitudReubicacion.ID_DETALLE_SOLICITUD;
        Lr_InfoDetSolicitud.ESTADO               := Lv_EstadoRechazada;
        
        DB_COMERCIAL.COMEK_TRANSACTION.P_UPDATE_INFO_DETALLE_SOL(Lr_InfoDetSolicitud,Lv_MensajeError);
        
        IF Lv_MensajeError IS NULL THEN
           -- Inserto historial de la solicitud
            Lr_InfoDetSolHistorial                        := NULL;
            Lr_InfoDetSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetSolHistorial.DETALLE_SOLICITUD_ID   := Lr_SolicitudReubicacion.ID_DETALLE_SOLICITUD;
            Lr_InfoDetSolHistorial.ESTADO                 := Lv_EstadoRechazada;
            Lr_InfoDetSolHistorial.OBSERVACION            := 'Se rechaza la solicitud por tarea No. '||Lr_SolicitudReubicacion.VALOR;
            Lr_InfoDetSolHistorial.USR_CREACION           := Pv_UsrCreacion;
            Lr_InfoDetSolHistorial.IP_CREACION            := '127.0.0.1';
        
            DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Lr_InfoDetSolHistorial, Lv_MensajeError);             
        ELSE
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('P_RECHAZA_SOLICITUDES_REUB','FNCK_TRANSACTION.P_RECHAZA_SOLICITUDES_REUB',Lv_MensajeError);
        END IF;
        
    END LOOP;
    
    COMMIT;

  EXCEPTION
  WHEN OTHERS THEN
    Lv_MensajeError := SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                    ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                          
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('P_RECHAZA_SOLICITUDES_REUB','FNCK_TRANSACTION.P_RECHAZA_SOLICITUDES_REUB',Lv_MensajeError);
    
  END P_RECHAZA_SOLICITUDES_REUB;
  --

  PROCEDURE P_GENERAR_FAC_SOLI_X_SERVICIO(Pn_IdServicio           IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                          Pv_Estado               IN  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                          Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                          Pv_UsrCreacion          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                          Pn_MotivoId             IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
                                          Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                          Pv_MsnError             OUT VARCHAR2)
  IS
    --Costo: 126
    CURSOR C_SolicitudesClientes(Cn_IdServicio       DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Cv_Estado           DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE, 
                                 Cn_TipoSolicitudId  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE, 
                                 Cn_MotivoId         DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
                                 Cv_PrefijoEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    IS
      SELECT IDS.ID_DETALLE_SOLICITUD,
        IDS.SERVICIO_ID,
        IDS.PRECIO_DESCUENTO,
        IDS.PORCENTAJE_DESCUENTO,
        IDS.USR_CREACION
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
           DB_COMERCIAL.INFO_SERVICIO ISER
      WHERE IDS.SERVICIO_ID     = Cn_IdServicio
      AND IDS.ESTADO            = Cv_Estado
      AND IDS.MOTIVO_ID         = NVL(Cn_MotivoId, IDS.MOTIVO_ID)
      AND IDS.TIPO_SOLICITUD_ID = Cn_TipoSolicitudId
      AND ISER.ID_SERVICIO      = IDS.SERVICIO_ID
      AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(NVL(ISER.PUNTO_FACTURACION_ID,ISER.PUNTO_ID),NULL) = Cv_PrefijoEmpresa
      AND EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                  FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                    DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                  WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'ID_SERVICIO_REINGRESO'
                  AND DBISC.SERVICIO_ID                 = ISER.ID_SERVICIO
                  AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA);

    --Costo: 4
    CURSOR C_GetProducto(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT APO.DESCRIPCION_PRODUCTO
      FROM DB_COMERCIAL.ADMI_PRODUCTO APO
      WHERE APO.ID_PRODUCTO IN (SELECT ISE.PRODUCTO_ID
                                FROM DB_COMERCIAL.INFO_SERVICIO ISE
                                WHERE ISE.ID_SERVICIO = Cn_IdServicio );
    --Costo: 5
    CURSOR C_GetLogin(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT IPU.LOGIN
      FROM DB_COMERCIAL.INFO_PUNTO IPU
      WHERE IPU.ID_PUNTO IN (SELECT ISE.PUNTO_ID
                             FROM DB_COMERCIAL.INFO_SERVICIO ISE
                             WHERE ISE.ID_SERVICIO = Cn_IdServicio);

    --Costo: 3
    CURSOR C_ObtieneInfoServ (Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT ESTADO
      FROM DB_COMERCIAL.INFO_SERVICIO
      WHERE ID_SERVICIO = Cn_IdServicio;
    
    --Costo: 4
    CURSOR C_DatosNumeracion (Cv_PrefijoEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                              Cv_EsMatriz             DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE,
                              Cv_EsOficinaFacturacion DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE,
                              Cn_IdOficina            DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                              Cv_CodigoNumeracion     DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE)
    IS        
      SELECT AN.ID_NUMERACION,
        AN.EMPRESA_ID,
        AN.OFICINA_ID,
        AN.DESCRIPCION,
        AN.CODIGO,
        AN.NUMERACION_UNO,
        AN.NUMERACION_DOS,
        AN.SECUENCIA,
        AN.FE_CREACION,
        AN.USR_CREACION,
        AN.FE_ULT_MOD,
        AN.USR_ULT_MOD,
        AN.TABLA,
        AN.ESTADO,
        AN.NUMERO_AUTORIZACION,
        AN.PROCESOS_AUTOMATICOS,
        AN.TIPO_ID
      FROM DB_COMERCIAL.ADMI_NUMERACION AN,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      WHERE AN.EMPRESA_ID            = IEG.COD_EMPRESA
      AND AN.OFICINA_ID              = IOG.ID_OFICINA
      AND IEG.PREFIJO                = NVL(Cv_PrefijoEmpresa, IEG.PREFIJO)
      AND IEG.ESTADO                 = 'Activo'
      AND IOG.ESTADO                 = 'Activo'
      AND IOG.ES_MATRIZ              = NVL(Cv_EsMatriz, IOG.ES_MATRIZ)
      AND IOG.ES_OFICINA_FACTURACION = NVL(Cv_EsOficinaFacturacion, IOG.ES_OFICINA_FACTURACION)
      AND IOG.ID_OFICINA             = NVL(Cn_IdOficina, IOG.ID_OFICINA)
      AND AN.CODIGO                  = NVL(Cv_CodigoNumeracion, AN.CODIGO);

    Lv_MessageError                VARCHAR2(2000);
    Lv_ObservacionDetalle          VARCHAR2(1000);
    Lv_Compensacion                VARCHAR2(5);
    Lv_PagaIva                     VARCHAR2(5);
    Lv_Numeracion                  VARCHAR2(20);
    Lv_Secuencia                   VARCHAR2(20);
    Lv_Ip                          VARCHAR2(1000) := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
    Ln_ContadorCommit              NUMBER := 0;
    Ln_Subtotal                    NUMBER := 0;
    Ln_Descuento                   NUMBER := 0;
    Ln_PorcentajeDescuento         NUMBER := 0;
    Ln_SubtotalConImpuesto         NUMBER := 0;
    Ln_SubtotalConDescuento        NUMBER := 0;
    Ln_SubtotalDescuento           NUMBER := 0;
    Ln_ValorTotal                  NUMBER := 0;
    Ln_IdOficinaNumeracion         NUMBER;
    Lr_ObtieneInfoServ             C_ObtieneInfoServ%ROWTYPE;
    Lv_EmpresaCod                  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE;
    Lv_PrefijoEmpresa              DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
    Ln_OficinaId                   DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
    Ln_IdPunto                     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Ln_PlanId                      DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE;
    Ln_ProductoId                  DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
    Lv_descripcionProducto         DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE;
    Lv_login                       DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Ln_ProductoTempId              DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE := 0;
    Ln_PlanTempId                  DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE := 0;
    Lv_ObservacionPlantilla        DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE;
    Ln_IdPuntoFacturacion          DB_COMERCIAL.INFO_SERVICIO.PUNTO_FACTURACION_ID%TYPE;
    Lr_AdmiNumeracion              DB_FINANCIERO.FNKG_TYPES.Lr_AdmiNumeracion;
    Lv_EsMatriz                    DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE := 'S';
    Lv_EsOficinaFacturacion        DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE := 'S';
    Lv_CodigoNumeracion            DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE := 'FACE';
    Lr_InfoDocumentoFinancieroCab  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocumentoFinancieroDet  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
    Lr_InfoDocumentoFinancieroHis  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Lr_DetalleSolHistorial         DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lo_ServicioHistorial           DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Ln_ValorCompensado             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE := 0;
    Ln_TipoSolicitudId             DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE;
    Lr_InfoServicio                DB_COMERCIAL.INFO_SERVICIO%ROWTYPE;
    Lr_InfoDetalleSolicitud        DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lex_Exception                  EXCEPTION;
  --
  BEGIN

    IF C_SolicitudesClientes%ISOPEN THEN
      CLOSE C_SolicitudesClientes;
    END IF;
      
    IF Pn_IdServicio IS NULL THEN
    --
      Pv_MsnError := Pv_MsnError || ' - Error el campo Pn_IdServicio no puede ser nulo, es obligatorio para la transacción.';
      RAISE Lex_Exception;      
    --
    END IF;

    --Se obtiene el ID del tipo de solicitud.
    BEGIN
    --
      SELECT ID_TIPO_SOLICITUD INTO Ln_TipoSolicitudId
      FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
      WHERE DESCRIPCION_SOLICITUD = Pv_DescripcionSolicitud
      AND ESTADO                  = Lv_EstadoActivo;
    --
    EXCEPTION
    WHEN OTHERS THEN
      Ln_TipoSolicitudId := 0;
    END;

    --Se obtiene el prefijo de la empresa.
    BEGIN
    --
      SELECT PREFIJO INTO Lv_PrefijoEmpresa
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
      WHERE COD_EMPRESA = Pv_EmpresaCod;
    --
    EXCEPTION
    WHEN OTHERS THEN
      Lv_PrefijoEmpresa := 'MD';
    END;
      
    --Se obtiene DE LOS PARÁMETROS LA INFORMACIÓN REFERENTE A ESA SOLICITUD ESPECÍFICA.
    DB_FINANCIERO.FNCK_TRANSACTION.P_BUSCA_INFORMACION_SOLICITUD(Pv_NombreSolicitud    => Pv_DescripcionSolicitud,
                                                                 Pv_EmpresaCod         => Pv_EmpresaCod,
                                                                 Pn_PlanId             => Ln_PlanTempId,
                                                                 Pn_ProductoId         => Ln_ProductoTempId,
                                                                 Pv_ObservacionFactura => Lv_ObservacionPlantilla);
    --
    FOR Lr_SolicitudesClientes IN C_SolicitudesClientes(Cn_IdServicio      => Pn_IdServicio,
                                                        Cv_Estado          => Pv_Estado,
                                                        Cn_TipoSolicitudId => Ln_TipoSolicitudId,
                                                        Cn_MotivoId        => Pn_MotivoId,
                                                        Cv_PrefijoEmpresa  => Lv_PrefijoEmpresa)
    LOOP
      --Se reemplaza el texto que proviene en %VALOR% de la plantilla por el valor a presentarse.
      Lv_ObservacionDetalle := F_GET_OBSERVACION_X_PLANTILLA(Pv_Plantilla          => Lv_ObservacionPlantilla,
                                                             Pn_DetalleSolicitudId => Lr_SolicitudesClientes.ID_DETALLE_SOLICITUD,
                                                             Pv_Estado             => Lv_EstadoActivo);

      --
      -- Obtener la información correspondiente al servicio a facturar
      DB_FINANCIERO.FNCK_CONSULTS.P_GET_INFO_SERVICIO_A_FACTURAR(Pn_IdServicio         => Lr_SolicitudesClientes.SERVICIO_ID,
                                                                 Pv_EmpresaCod         => Lv_EmpresaCod,
                                                                 Pv_PrefijoEmpresa     => Lv_PrefijoEmpresa,
                                                                 Pn_OficinaId          => Ln_OficinaId,
                                                                 Pn_IdPuntoFacturacion => Ln_IdPuntoFacturacion,
                                                                 Pn_IdPunto            => Ln_IdPunto,
                                                                 Pn_PlanId             => Ln_PlanId,
                                                                 Pn_ProductoId         => Ln_ProductoId,
                                                                 Pv_Compensacion       => Lv_Compensacion,
                                                                 Pv_PagaIva            => Lv_PagaIva,
                                                                 Pv_MessageError       => Lv_MessageError);
      --
      Ln_PorcentajeDescuento  := Lr_SolicitudesClientes.PORCENTAJE_DESCUENTO;
      Ln_Subtotal             := Lr_SolicitudesClientes.PRECIO_DESCUENTO;
      Ln_Descuento            := TRUNC((Ln_Subtotal * NVL(Ln_PorcentajeDescuento, 0))/100,2);
      Ln_SubtotalConDescuento := Ln_Subtotal - Ln_Descuento;
      --
      IF Ln_SubtotalConDescuento > 0 THEN
        --SI INGRESA POR EL FLUJO DE DEMOS, SE LLENA DINÁMICAMENTE LA OBSERVACIÓN.
        IF Pv_DescripcionSolicitud = 'SOLICITUD REQUERIMIENTOS DE CLIENTES' AND Lr_SolicitudesClientes.USR_CREACION = 'telcos_pma_demos' THEN
          --Obtengo el producto
          OPEN C_GetProducto(Lr_SolicitudesClientes.SERVICIO_ID);
          FETCH C_GetProducto INTO Lv_descripcionProducto;
          CLOSE C_GetProducto;

          --Obtengo el login
          OPEN C_GetLogin(Lr_SolicitudesClientes.SERVICIO_ID);
          FETCH C_GetLogin INTO Lv_login;
          CLOSE C_GetLogin;

          Lv_ObservacionDetalle  := 'DEMO '||Lv_descripcionProducto||' - '||Lv_login;
          Lv_descripcionProducto := '';
          Lv_login               := '';
        --SI NO ES NINGÚN CASO ANTES MENCIONADO, BUSCA PLAN_ID, PRODUCTO_ID Y OBSERVACIÓN EN LOS PARÁMETROS.
        ELSE
          --SI OBTIENE UN PLAN, SE VACÍA EL PRODUCTO Y SE FIJA EL NUEVO PLAN
          IF NVL(Ln_PlanTempId, 0) != 0 THEN
            Ln_ProductoId := NULL;
            Ln_PlanId     := Ln_PlanTempId;
          --SI OBTIENE UN PRODUCTO, SE VACÍA EL PLAN Y SE FIJA EL NUEVO PRODUCTO
          ELSIF NVL(Ln_ProductoTempId, 0) != 0 THEN
            Ln_ProductoId := Ln_ProductoTempId;
            Ln_PlanId     := NULL;
          END IF;
        END IF;
        --
        IF Ln_IdPuntoFacturacion IS NULL THEN
          --
          Ln_IdPuntoFacturacion                := Ln_IdPunto;
          --
          Lr_InfoServicio                      := NULL;
          Lr_InfoServicio.PUNTO_FACTURACION_ID := Ln_IdPunto;
          Lr_InfoServicio.ID_SERVICIO          := Lr_SolicitudesClientes.SERVICIO_ID;
            
          DB_COMERCIAL.CMKG_REINGRESO.P_UPDATE_INFO_SERVICIO(Pr_InfoServicio => Lr_InfoServicio,
                                                             Pv_MsjResultado => Pv_MsnError);
          --
        END IF;
        --
        -- Se inserta la cabecera de la factura
        Lr_InfoDocumentoFinancieroCab                               := NULL;
        Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO                  := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
        Lr_InfoDocumentoFinancieroCab.OFICINA_ID                    := Ln_OficinaId;
        Lr_InfoDocumentoFinancieroCab.PUNTO_ID                      := Ln_IdPuntoFacturacion;
        Lr_InfoDocumentoFinancieroCab.TIPO_DOCUMENTO_ID             := 1;
        Lr_InfoDocumentoFinancieroCab.ES_AUTOMATICA                 := 'S';
        Lr_InfoDocumentoFinancieroCab.PRORRATEO                     := 'N';
        Lr_InfoDocumentoFinancieroCab.REACTIVACION                  := 'N';
        Lr_InfoDocumentoFinancieroCab.RECURRENTE                    := 'N';
        Lr_InfoDocumentoFinancieroCab.COMISIONA                     := 'S';
        Lr_InfoDocumentoFinancieroCab.FE_CREACION                   := SYSDATE;
        Lr_InfoDocumentoFinancieroCab.USR_CREACION                  := Pv_UsrCreacion;
        Lr_InfoDocumentoFinancieroCab.ES_ELECTRONICA                := 'S';
        Lr_InfoDocumentoFinancieroCab.MES_CONSUMO                   := NULL;
        Lr_InfoDocumentoFinancieroCab.ANIO_CONSUMO                  := NULL;
        Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT         := 'Pendiente';
        --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab, Pv_MsnError);
        --
        IF TRIM(Pv_MsnError) IS NOT NULL THEN
          --
          Pv_MsnError := Pv_MsnError || ' - Error al insertar la cabecera de la factura';
          RAISE Lex_Exception;
          --
        END IF;
        --
        -- Con la informacion de cabecera se inserta el historial
        Lr_InfoDocumentoFinancieroHis                               := NULL;
        Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL        := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID                  := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
        Lr_InfoDocumentoFinancieroHis.FE_CREACION                   := SYSDATE;
        Lr_InfoDocumentoFinancieroHis.USR_CREACION                  := Pv_UsrCreacion;
        Lr_InfoDocumentoFinancieroHis.ESTADO                        := 'Pendiente';
        Lr_InfoDocumentoFinancieroHis.OBSERVACION                   := Lv_ObservacionDetalle;
        --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Pr_InfoDocumentoHistorial => Lr_InfoDocumentoFinancieroHis,
                                                                      Pv_MsnError               => Pv_MsnError);
        --
        IF TRIM(Pv_MsnError) IS NOT NULL THEN
          --
          Pv_MsnError := Pv_MsnError || ' - Error al insertar el historial de la cabecera de la factura';
          RAISE Lex_Exception;
          --
        END IF;
        --
        -- Se guarda el detalle de la factura
        Lr_InfoDocumentoFinancieroDet                               := NULL;
        Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID                  := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
        Lr_InfoDocumentoFinancieroDet.PUNTO_ID                      := Ln_IdPunto;
        Lr_InfoDocumentoFinancieroDet.PLAN_ID                       := Ln_PlanId;
        Lr_InfoDocumentoFinancieroDet.CANTIDAD                      := '1';
        Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE   := Ln_Subtotal;
        Lr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO   := Ln_PorcentajeDescuento;
        Lr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE      := Ln_Descuento;
        Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE          := ROUND(Ln_Subtotal, 2);
        Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE          := ROUND(Ln_Subtotal, 2);
        Lr_InfoDocumentoFinancieroDet.FE_CREACION                   := SYSDATE;
        Lr_InfoDocumentoFinancieroDet.USR_CREACION                  := Pv_UsrCreacion;
        Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                   := Ln_ProductoId;
        Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE := Lv_ObservacionDetalle;
        Lr_InfoDocumentoFinancieroDet.OFICINA_ID                    := Ln_OficinaId;
        Lr_InfoDocumentoFinancieroDet.EMPRESA_ID                    := Lv_EmpresaCod;
        Lr_InfoDocumentoFinancieroDet.SERVICIO_ID                   := Lr_SolicitudesClientes.SERVICIO_ID;

        --SE INSERTAN LAS CARACTERÍSTICAS DE LA TABLA INFO_DETALLE_SOLICITUD_CARAC
        DB_FINANCIERO.FNCK_TRANSACTION.P_CLONAR_SOLICITUD_CARAC(Pn_DetalleSolicitudId         => Lr_SolicitudesClientes.ID_DETALLE_SOLICITUD,
                                                                Pr_InfoDocumentoFinancieroDet => Lr_InfoDocumentoFinancieroDet,
                                                                Pv_PagaIva                    => Lv_PagaIva,
                                                                Pv_Mensaje                    => Pv_MsnError);
        IF TRIM(Pv_MsnError) IS NOT NULL THEN
          RAISE Lex_Exception;
        END IF;
        --
        -- Se actualiza la cabecera de la factura
        Ln_Subtotal            := NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_SUMAR_SUBTOTAL(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0);
        Ln_SubtotalDescuento   := TRUNC(NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_SUMAR_DESCUENTO(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),
                                            0),2);
        Ln_SubtotalConImpuesto := NVL(DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.P_SUMAR_IMPUESTOS(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0);
        Ln_ValorTotal          := NVL((Ln_Subtotal - Ln_SubtotalDescuento) + Ln_SubtotalConImpuesto - Ln_ValorCompensado,0);
        --
        -- Actualizo los valores de la cabecera
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL                      := Ln_Subtotal;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CERO_IMPUESTO        := Ln_Subtotal;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CON_IMPUESTO         := Ln_SubtotalConImpuesto;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_DESCUENTO            := Ln_SubtotalDescuento;
        Lr_InfoDocumentoFinancieroCab.DESCUENTO_COMPENSACION        := Ln_ValorCompensado;
        Lr_InfoDocumentoFinancieroCab.VALOR_TOTAL                   := Ln_ValorTotal;
        --
        IF Ln_ValorTotal > 0 AND Lv_PrefijoEmpresa = 'MD' THEN
          --
          DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.GET_PREFIJO_OFICINA(Pn_EmpresaCod => Lv_EmpresaCod,
                                                                     Pv_Prefijo    => Lv_PrefijoEmpresa,
                                                                     Pn_Id_Oficina => Ln_IdOficinaNumeracion);
          --
          --
          IF TRIM(Lv_PrefijoEmpresa) IS NOT NULL AND Ln_IdOficinaNumeracion IS NOT NULL AND Ln_IdOficinaNumeracion > 0 THEN
            --Se obtiene la numeracion de la factura
            FOR Lr_DatosNumeracion IN C_DatosNumeracion (Lv_PrefijoEmpresa,
                                                         Lv_EsMatriz,
                                                         Lv_EsOficinaFacturacion,
                                                         Ln_IdOficinaNumeracion,
                                                         Lv_CodigoNumeracion)
            LOOP
            --
              IF Lr_DatosNumeracion.ID_NUMERACION IS NOT NULL AND Lr_DatosNumeracion.ID_NUMERACION > 0 
                 AND TRIM(Lr_DatosNumeracion.SECUENCIA) IS NOT NULL AND TRIM(Lr_DatosNumeracion.NUMERACION_UNO) IS NOT NULL
                 AND TRIM(Lr_DatosNumeracion.NUMERACION_DOS) IS NOT NULL THEN

                Lv_Secuencia                           := LPAD(Lr_DatosNumeracion.SECUENCIA,9,'0');
                Lv_Numeracion                          := Lr_DatosNumeracion.NUMERACION_UNO || 
                                                          '-' || Lr_DatosNumeracion.NUMERACION_DOS ||
                                                          '-' || Lv_Secuencia;

                Lr_AdmiNumeracion                      := NULL;
                Lr_AdmiNumeracion.ID_NUMERACION        := Lr_DatosNumeracion.ID_NUMERACION;
                Lr_AdmiNumeracion.EMPRESA_ID           := Lr_DatosNumeracion.EMPRESA_ID;
                Lr_AdmiNumeracion.OFICINA_ID           := Lr_DatosNumeracion.OFICINA_ID;
                Lr_AdmiNumeracion.DESCRIPCION          := Lr_DatosNumeracion.DESCRIPCION;
                Lr_AdmiNumeracion.CODIGO               := Lr_DatosNumeracion.CODIGO;
                Lr_AdmiNumeracion.NUMERACION_UNO       := Lr_DatosNumeracion.NUMERACION_UNO;
                Lr_AdmiNumeracion.NUMERACION_DOS       := Lr_DatosNumeracion.NUMERACION_DOS;
                Lr_AdmiNumeracion.SECUENCIA            := Lr_DatosNumeracion.SECUENCIA + 1;
                Lr_AdmiNumeracion.FE_CREACION          := Lr_DatosNumeracion.FE_CREACION;
                Lr_AdmiNumeracion.USR_CREACION         := Lr_DatosNumeracion.USR_CREACION;
                Lr_AdmiNumeracion.FE_ULT_MOD           := Lr_DatosNumeracion.FE_ULT_MOD;
                Lr_AdmiNumeracion.USR_ULT_MOD          := Lr_DatosNumeracion.USR_ULT_MOD;
                Lr_AdmiNumeracion.TABLA                := Lr_DatosNumeracion.TABLA;
                Lr_AdmiNumeracion.ESTADO               := Lr_DatosNumeracion.ESTADO;
                Lr_AdmiNumeracion.NUMERO_AUTORIZACION  := Lr_DatosNumeracion.NUMERO_AUTORIZACION;
                Lr_AdmiNumeracion.PROCESOS_AUTOMATICOS := Lr_DatosNumeracion.PROCESOS_AUTOMATICOS;
                Lr_AdmiNumeracion.TIPO_ID              := Lr_DatosNumeracion.TIPO_ID;

                DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Pn_IdNumeracion   => Lr_DatosNumeracion.ID_NUMERACION,
                                                                      Pr_AdmiNumeracion => Lr_AdmiNumeracion,
                                                                      Pv_MsnError       => Pv_MsnError);
                --
                IF TRIM(Pv_MsnError) IS NOT NULL THEN
                --
                  Pv_MsnError := Pv_MsnError || ' - Error al actualizar la numeración';
                  RAISE Lex_Exception;
                --
                END IF;
              --
              END IF;
            --
            END LOOP;
            --
          END IF;
          --
          Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI := Lv_Numeracion;
          --
        END IF;
        --
        Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT := 'Pendiente';
        -- si usuario es proceso masivo se resta un dia
        IF INSTR(Gv_UsrProcesoMasivo, Pv_UsrCreacion) > 0 THEN
          Lr_InfoDocumentoFinancieroCab.FE_EMISION := SYSDATE-1;
        ELSE
          Lr_InfoDocumentoFinancieroCab.FE_EMISION := SYSDATE;
        END IF;
        --
        DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento                => Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,
                                                                      Pr_InfoDocumentoFinancieroCab => Lr_InfoDocumentoFinancieroCab,
                                                                      Pv_MsnError                   => Pv_MsnError);
        --
        IF TRIM(Pv_MsnError) IS NOT NULL THEN
          --
          Pv_MsnError := Pv_MsnError || ' - Error al actualizar la información de la cabecera de la factura';
          RAISE Lex_Exception;
          --
        END IF;
        --
        Ln_ContadorCommit := Ln_ContadorCommit + 1;
        --
      ELSE
        --
        Ln_ContadorCommit                           := Ln_ContadorCommit + 1;
        -- INSERTO HISTORIAL DEL SERVICIO
        Lo_ServicioHistorial                        := NULL;
        Lo_ServicioHistorial.OBSERVACION            := 'Tarifario con promoción';
        --Se obtiene el estado del servicio para almacenar su historial si no es pasado por parámetro.
        OPEN  C_ObtieneInfoServ (Cn_IdServicio => Lr_SolicitudesClientes.SERVICIO_ID);
        FETCH C_ObtieneInfoServ INTO Lr_ObtieneInfoServ;
        CLOSE C_ObtieneInfoServ;

        Lo_ServicioHistorial.ESTADO                 := Lr_ObtieneInfoServ.ESTADO;
        Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
        Lo_ServicioHistorial.USR_CREACION           := Pv_UsrCreacion;
        Lo_ServicioHistorial.IP_CREACION            := Lv_Ip;
        Lo_ServicioHistorial.SERVICIO_ID            := Lr_SolicitudesClientes.SERVICIO_ID;
        --
        DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Pr_servicioHistorial => Lo_ServicioHistorial,
                                                                   Lv_MensaError        => Pv_MsnError);
        --
        IF TRIM(Pv_MsnError) IS NOT NULL THEN
          --
          Pv_MsnError := Pv_MsnError || ' - Error al insertar el historial del servicio';
          RAISE Lex_Exception;
          --
        END IF;
        --
      END IF;
      -- Actualizo la solicitud de instalacion
      Lr_InfoDetalleSolicitud                      := NULL;
      Lr_InfoDetalleSolicitud.ESTADO               := 'Finalizada';
      Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD := Lr_SolicitudesClientes.ID_DETALLE_SOLICITUD;

      DB_COMERCIAL.CMKG_REINGRESO.P_UPDATE_INFO_DETALLE_SOL(Pr_InfoDetalleSolicitud => Lr_InfoDetalleSolicitud,
                                                            Pv_MsjResultado         => Pv_MsnError);
                                                               
      -- INSERTO HISTORIAL DE LA FINALIZACION DE LA SOLICITUD
      Lr_DetalleSolHistorial                        := NULL;
      Lr_DetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
      Lr_DetalleSolHistorial.DETALLE_SOLICITUD_ID   := Lr_SolicitudesClientes.ID_DETALLE_SOLICITUD;
      Lr_DetalleSolHistorial.ESTADO                 := 'Finalizada';
      Lr_DetalleSolHistorial.OBSERVACION            := 'Se finaliza la solicitud';
      Lr_DetalleSolHistorial.USR_CREACION           := Pv_UsrCreacion;
      Lr_DetalleSolHistorial.IP_CREACION            := Lv_Ip;
      --
      DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Pr_InfoDetalleSolHist => Lr_DetalleSolHistorial,
                                                               Pv_MsnError           => Pv_MsnError);
      --
      IF TRIM(Pv_MsnError) IS NOT NULL THEN
        --
        Pv_MsnError := Pv_MsnError || ' - Error al insertar el historial de la solicitud';
        RAISE Lex_Exception;
        --
      END IF;
      --
      IF Ln_ContadorCommit >= 5000 THEN
        --
        Ln_ContadorCommit := 0;
        COMMIT;
        --
      END IF;
        --
    END LOOP;
    --
    IF Ln_ContadorCommit < 4999 THEN
      --
      COMMIT;
      --
    END IF;
    --
    IF C_SolicitudesClientes%ISOPEN THEN
      --
      CLOSE C_SolicitudesClientes;
      --
    END IF;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_TRANSACTION.P_GENERAR_FAC_SOLI_X_SERVICIO',
                                         Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), Pv_UsrCreacion),
                                         SYSDATE,
                                         Lv_Ip);
    --
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MsnError := 'Error al generar las facturas por solicitudes:' || SQLCODE || ' - ERROR_STACK: ' ||
                   DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'FNCK_TRANSACTION.P_GENERAR_FAC_SOLI_X_SERVICIO',
                                         Pv_MsnError,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), Pv_UsrCreacion),
                                         SYSDATE,
                                         Lv_Ip);
    --
  END P_GENERAR_FAC_SOLI_X_SERVICIO;
  
  PROCEDURE p_eliminar_data_temp_mas(Pv_IdTmpDatos DB_FINANCIERO.INFO_TMP_PRODUCTOS.UUID%TYPE, Pv_MsnError OUT VARCHAR2) IS
    
  BEGIN
    DELETE FROM db_financiero.info_tmp_productos a WHERE a.uuid = Pv_IdTmpDatos;
    DELETE FROM db_financiero.info_tmp_secuencia_docs a WHERE a.uuid = Pv_IdTmpDatos;
  EXCEPTION
    WHEN OTHERS THEN
      --
      ROLLBACK; 
      Pv_MsnError := SQLERRM;
      FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_TRANSACTION', 'FNCK_TRANSACTION.p_eliminar_data_temp_mas', SQLERRM ) ;
  END p_eliminar_data_temp_mas;

END FNCK_TRANSACTION;
/