CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_COM_ELECTRONICO
AS
  --
TYPE Lr_Doc_Fin_Cab
IS
  RECORD
  (
    ID_DOCUMENTO INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    TIPO_DOCUMENTO_ID ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
    NUMERO_FACTURA INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    FE_EMISION INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
    SUBTOTAL INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
    SUBTOTAL_SIN_IMPUESTO INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CERO_IMPUESTO%TYPE,
    SUBTOTAL_CON_IMPUESTO INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
    SUBTOTAL_DESCUENTO INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
    VALOR_TOTAL INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE);
  --
TYPE Lrf_Doc_Fin_Cab
IS
  REF
  CURSOR
    RETURN Lr_Doc_Fin_Cab;
    --
  TYPE Lr_ComprobanteElectronico
IS
  RECORD
  (
    ID_COMP_ELECTRONICO INFO_COMPROBANTE_ELECTRONICO.ID_COMP_ELECTRONICO%TYPE,
    NOMBRE_COMPROBANTE INFO_COMPROBANTE_ELECTRONICO.NOMBRE_COMPROBANTE%TYPE,
    DOCUMENTO_ID INFO_COMPROBANTE_ELECTRONICO.DOCUMENTO_ID%TYPE,
    TIPO_DOCUMENTO_ID INFO_COMPROBANTE_ELECTRONICO.TIPO_DOCUMENTO_ID%TYPE,
    NUMERO_FACTURA INFO_COMPROBANTE_ELECTRONICO.NUMERO_FACTURA_SRI%TYPE,
    COMPROBANTE_ELECTRONICO INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECTRONICO%TYPE,
    COMPROBANTE_ELECT_DEVUELTO INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECT_DEVUELTO%TYPE,
    FE_AUTORIZACION INFO_COMPROBANTE_ELECTRONICO.FE_AUTORIZACION%TYPE,
    NUMERO_AUTORIZACION INFO_COMPROBANTE_ELECTRONICO.NUMERO_AUTORIZACION%TYPE,
    CLAVE_ACCESO INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE,
    ESTADO INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
    DETALLE INFO_COMPROBANTE_ELECTRONICO.DETALLE%TYPE,
    RUC INFO_COMPROBANTE_ELECTRONICO.RUC%TYPE,
    FE_CREACION INFO_COMPROBANTE_ELECTRONICO.FE_CREACION%TYPE,
    FE_MODIFICACION INFO_COMPROBANTE_ELECTRONICO.FE_MODIFICACION%TYPE,
    USR_CREACION INFO_COMPROBANTE_ELECTRONICO.USR_CREACION%TYPE,
    USR_MODIFICACION INFO_COMPROBANTE_ELECTRONICO.USR_MODIFICACION%TYPE,
    ENVIADO INFO_COMPROBANTE_ELECTRONICO.ENVIADO%TYPE,
    NUMERO_ENVIO INFO_COMPROBANTE_ELECTRONICO.NUMERO_ENVIO%TYPE,
    LOTE_MASIVO_ID INFO_COMPROBANTE_ELECTRONICO.LOTE_MASIVO_ID%TYPE);
  --
TYPE Lr_AdmiUsuario
IS
RECORD
(
  ID_USUARIO            DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%TYPE,
  LOGIN                 DB_COMPROBANTES.ADMI_USUARIO.LOGIN%TYPE,         
  NOMBRES               DB_COMPROBANTES.ADMI_USUARIO.NOMBRES%TYPE,
  APELLIDOS             DB_COMPROBANTES.ADMI_USUARIO.APELLIDOS%TYPE,
  EMAIL                 DB_COMPROBANTES.ADMI_USUARIO.EMAIL%TYPE,
  ADMIN                 DB_COMPROBANTES.ADMI_USUARIO.ADMIN%TYPE,
  ESTADO                DB_COMPROBANTES.ADMI_USUARIO.ESTADO%TYPE,
  FE_CREACION           DB_COMPROBANTES.ADMI_USUARIO.FE_CREACION%TYPE,
  USR_CREACION          DB_COMPROBANTES.ADMI_USUARIO.USR_CREACION%TYPE,
  FE_ULT_MOD            DB_COMPROBANTES.ADMI_USUARIO.FE_ULT_MOD%TYPE,
  USR_ULT_MOD           DB_COMPROBANTES.ADMI_USUARIO.USR_ULT_MOD%TYPE,
  IP_CREACION           DB_COMPROBANTES.ADMI_USUARIO.IP_CREACION%TYPE,
  PASSWORD              DB_COMPROBANTES.ADMI_USUARIO.PASSWORD%TYPE,
  EMPRESA               DB_COMPROBANTES.ADMI_USUARIO.EMPRESA%TYPE,
  LOCALE                DB_COMPROBANTES.ADMI_USUARIO.LOCALE%TYPE,
  EMPRESA_CONSULTA      DB_COMPROBANTES.ADMI_USUARIO.EMPRESA_CONSULTA%TYPE
);

TYPE Lr_AdmiUsuarioEmpresa
IS
RECORD
(
  ID_USR_EMP           DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.ID_USR_EMP%TYPE,
  USUARIO_ID           DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.USUARIO_ID%TYPE,
  EMPRESA_ID           DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.EMPRESA_ID%TYPE,
  FE_CREACION          DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.FE_CREACION%TYPE,
  USR_CREACION         DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.USR_CREACION%TYPE, 
  FE_ULT_MOD           DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.FE_ULT_MOD%TYPE,
  USR_ULT_MOD          DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.USR_ULT_MOD%TYPE,
  IP_CREACION          DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.IP_CREACION%TYPE,
  EMAIL                DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.EMAIL%TYPE,
  DIRECCION            DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.DIRECCION%TYPE,
  TELEFONO             DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.TELEFONO%TYPE,
  CIUDAD               DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.CIUDAD%TYPE,
  NUMERO               DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.NUMERO%TYPE,
  FORMAPAGO            DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.FORMAPAGO%TYPE,
  LOGIN                DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.LOGIN%TYPE,
  CONTRATO             DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.CONTRATO%TYPE,
  PASSWORD             DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.PASSWORD%TYPE,
  N_CONEXION           DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.N_CONEXION%TYPE, 
  FE_ULT_CONEXION      DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.FE_ULT_CONEXION%TYPE,
  CAMBIO_CLAVE         DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.CAMBIO_CLAVE%TYPE
);
  --
TYPE Lr_InfoDocumento
IS
  RECORD
  (
    ID_DOCUMENTO             DB_COMPROBANTES.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE,
    TIPO_DOC_ID              DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_DOC_ID%TYPE,
    FORMATO_ID               DB_COMPROBANTES.INFO_DOCUMENTO.FORMATO_ID%TYPE,
    EMPRESA_ID               DB_COMPROBANTES.INFO_DOCUMENTO.EMPRESA_ID%TYPE,
    NOMBRE                   DB_COMPROBANTES.INFO_DOCUMENTO.NOMBRE%TYPE,
    CLAVE_ACCESO             DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%TYPE,
    FE_CREACION              DB_COMPROBANTES.INFO_DOCUMENTO.FE_CREACION%TYPE,
    USR_CREACION             DB_COMPROBANTES.INFO_DOCUMENTO.USR_CREACION%TYPE,
    FE_ULT_MOD               DB_COMPROBANTES.INFO_DOCUMENTO.FE_ULT_MOD%TYPE,
    USR_ULT_MOD              DB_COMPROBANTES.INFO_DOCUMENTO.USR_ULT_MOD%TYPE,
    IP_CREACION              DB_COMPROBANTES.INFO_DOCUMENTO.IP_CREACION%TYPE,
    ESTABLECIMIENTO          DB_COMPROBANTES.INFO_DOCUMENTO.ESTABLECIMIENTO%TYPE,
    PUNTO_EMISION            DB_COMPROBANTES.INFO_DOCUMENTO.PUNTO_EMISION%TYPE,
    VALOR                    DB_COMPROBANTES.INFO_DOCUMENTO.VALOR%TYPE,
    ESTADO_DOC_ID            DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_DOC_ID%TYPE,
    VERSION                  DB_COMPROBANTES.INFO_DOCUMENTO.VERSION%TYPE,
    SECUENCIAL               DB_COMPROBANTES.INFO_DOCUMENTO.SECUENCIAL%TYPE,
    FE_RECIBIDO              DB_COMPROBANTES.INFO_DOCUMENTO.FE_RECIBIDO%TYPE,    
    TIPO_IDENTIFICACION_ID   DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_IDENTIFICACION_ID%TYPE,
    IDENTIFICACION           DB_COMPROBANTES.INFO_DOCUMENTO.IDENTIFICACION%TYPE,
    TIPO_EMISION_ID          DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_EMISION_ID%TYPE,
    USUARIO_ID               DB_COMPROBANTES.INFO_DOCUMENTO.USUARIO_ID%TYPE,
    LOTEMASIVO_ID            DB_COMPROBANTES.INFO_DOCUMENTO.LOTEMASIVO_ID%TYPE,
    XML_ORIGINAL             DB_COMPROBANTES.INFO_DOCUMENTO.XML_ORIGINAL%TYPE,   
    AMBIENTE_ID              DB_COMPROBANTES.INFO_DOCUMENTO.AMBIENTE_ID%TYPE,
    FE_EMISION               DB_COMPROBANTES.INFO_DOCUMENTO.FE_EMISION%TYPE,
    INTENTO_RECEPCION        DB_COMPROBANTES.INFO_DOCUMENTO.INTENTO_RECEPCION%TYPE,
    INTENTO_CONSULTA         DB_COMPROBANTES.INFO_DOCUMENTO.INTENTO_CONSULTA%TYPE,
    ORIGEN_DOCUMENTO         DB_COMPROBANTES.INFO_DOCUMENTO.ORIGEN_DOCUMENTO%TYPE,
    DOCUMENTO_ID_FINAN       DB_COMPROBANTES.INFO_DOCUMENTO.DOCUMENTO_ID_FINAN%TYPE
  );  
  --
TYPE Lr_TotalImpuesto
IS
  RECORD
  (
    CODIGO                DB_GENERAL.ADMI_IMPUESTO.CODIGO_SRI%TYPE,
    CODIGO_PORCENTAJE     DB_GENERAL.ADMI_IMPUESTO.CODIGO_TARIFA%TYPE,
    BASE_IMPONIBLE        NUMBER(15,2),
    VALOR                 NUMBER(15,2)
  );
  --
TYPE Lr_LoteMasivo
IS
  RECORD
  (
    ID_LOTE_MASIVO INFO_LOTE_MASIVO.ID_LOTE_MASIVO%TYPE,
    ESTADO INFO_LOTE_MASIVO.ESTADO%TYPE,
    ENVIADO INFO_LOTE_MASIVO.ENVIADO%TYPE,
    RUC INFO_LOTE_MASIVO.RUC%TYPE,
    TIPO_DOCUMENTO_ID INFO_LOTE_MASIVO.TIPO_DOCUMENTO_ID%TYPE,
    ESTABLECIMIENTO INFO_LOTE_MASIVO.ESTABLECIMIENTO%TYPE,
    CLAVE_ACCESO INFO_LOTE_MASIVO.CLAVE_ACCESO%TYPE,
    FE_CREACION INFO_LOTE_MASIVO.FE_CREACION%TYPE,
    FE_ENVIO INFO_LOTE_MASIVO.FE_ENVIO%TYPE,
    FE_MODIFICACION INFO_LOTE_MASIVO.FE_MODIFICACION%TYPE,
    USR_CREACION INFO_COMPROBANTE_ELECTRONICO.USR_CREACION%TYPE,
    USR_MODIFICACION INFO_COMPROBANTE_ELECTRONICO.USR_MODIFICACION%TYPE,
    OBSERVACION INFO_LOTE_MASIVO.OBSERVACION%TYPE,
    NUMERO_ENVIO INFO_LOTE_MASIVO.NUMERO_ENVIO%TYPE,
    NUMERO_COMPROBANTES INFO_LOTE_MASIVO.NUMERO_COMPROBANTES%TYPE,
    NUMERO_COMP_CORRECTOS INFO_LOTE_MASIVO.NUMERO_COMP_CORRECTOS%TYPE,
    NUMERO_COMP_INCORRECTOS INFO_LOTE_MASIVO.NUMERO_COMP_INCORRECTOS%TYPE);
  --
TYPE Lr_MensajeCompElectronico
IS
  RECORD
  (
    ID_MSN_COMP_ELEC INFO_MENSAJE_COMP_ELEC.ID_MSN_COMP_ELEC%TYPE,
    DOCUMENTO_ID INFO_MENSAJE_COMP_ELEC.DOCUMENTO_ID%TYPE,
    ID_LOTE_MASIVO INFO_MENSAJE_COMP_ELEC.ID_LOTE_MASIVO%TYPE,
    TIPO INFO_MENSAJE_COMP_ELEC.TIPO%TYPE,
    MENSAJE INFO_MENSAJE_COMP_ELEC.MENSAJE%TYPE,
    INFORMACION_ADICIONAL INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE,
    FE_CREACION INFO_MENSAJE_COMP_ELEC.FE_CREACION%TYPE);
  --
TYPE Lrf_MensajeCompElectronico
IS
  REF
  CURSOR
    RETURN Lr_MensajeCompElectronico;
    --
  TYPE Lr_InfoDocumentoHistorial
IS
  RECORD
  (
    ID_DOCUMENTO_HISTORIAL INFO_DOCUMENTO_HISTORIAL.ID_DOCUMENTO_HISTORIAL%TYPE,
    DOCUMENTO_ID INFO_DOCUMENTO_HISTORIAL.DOCUMENTO_ID%TYPE,
    MOTIVO_ID INFO_DOCUMENTO_HISTORIAL.MOTIVO_ID%TYPE,
    FE_CREACION INFO_DOCUMENTO_HISTORIAL.FE_CREACION%TYPE,
    USR_CREACION INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE,
    ESTADO INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE,
    OBSERVACION INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE );
  --
TYPE Lrf_InfoDocumentoHistorial
IS
  REF
  CURSOR
    RETURN Lr_InfoDocumentoHistorial;
    -- 
   /**
  * Documentaci�n para funcion 'F_XMLBLOG'.
  * Funcion para Convertir campo XMLTYPE a BLOG
  *
  * PARAMETROS:
  * @Param Fv_ComprobanteElectronico INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECTRONICO%TYPE
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-12-2017
  */           
    FUNCTION F_XMLBLOG(
                   Fv_ComprobanteElectronico INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECTRONICO%TYPE)
    RETURN BLOB;    
    --
  /**
  * Documentaci�n para funcion 'F_GENERATORCLAVE'.
  * Funcion para obtener Clave de Acceso a generarse en base a algoritmo java
  *
  * PARAMETROS:
  * @Param fechaEmision       VARCHAR2 Fecha de Emision de la Factura,
  * @Param tipoComprobante    VARCHAR2 Tipo de Comprobante en DB_COMPROBANTE fact/nc etc,
  * @Param numeroRuc          VARCHAR2 Ruc de la empresa que emite Factura TN, MD etc,
  * @Param ambiente           VARCHAR2 Ambiente en que se ejecuta Prod, Pruebas ect,
  * @Param serie              VARCHAR2 Cadena que contiene Establecimiento + PuntoEmision,
  * @Param secuencial         VARCHAR2 Numero Secuencial de la Factura,
  * @Param codNumerico        VARCHAR2 Fecha de Emision de la Factura,
  * @Param tipoEmision        VARCHAR2 Tipo de Emision
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 21-12-2017
  */        
   FUNCTION F_GENERATORCLAVE (
   fechaEmision       VARCHAR2,
   tipoComprobante    VARCHAR2,
   numeroRuc          VARCHAR2,
   ambiente           VARCHAR2,
   serie              VARCHAR2,
   secuencial         VARCHAR2,
   codNumerico        VARCHAR2,
   tipoEmision        VARCHAR2)
   RETURN VARCHAR2;

  /**
  * Documentaci�n para funcion 'F_GENERA_PASSWD_SHA256'.
  * Funcion para obtener password del Usuario a generarse en base a algoritmo java
  *
  * PARAMETROS:
  * @Param Fn_Identificacion       VARCHAR2  Numero de Identificacion
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 16-01-2018
  */         
  FUNCTION F_GENERA_PASSWD_SHA256 (
   Fn_Identificacion      VARCHAR2)
   RETURN VARCHAR2; 
   --
  /**
  * Documentaci�n para funcion 'F_GET_TOTAL_IMPUESTO'.
  * Funcion para obtener registro de totales de impuesto por id documento
  *
  * PARAMETROS:
  * @Param Fn_IdDocumento    IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-12-2017
  */            
  FUNCTION F_GET_TOTAL_IMPUESTO(
      Fn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN Lr_TotalImpuesto;
    --  
  /**
  * Documentaci�n para funcion 'GET_DIFERENCIA_XML'.
  * Funcion para verificar si los Valores del Documento estan cuadrados
  *
  * PARAMETROS:
  * @Param Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-12-2017
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 21-02-2018 -  Se Redondea 3 y a 2 decimales debido a errores de cuadratura
  *                            provocado por Precios de Venta a 9 decimales  
  */              
  FUNCTION GET_DIFERENCIA_XML(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER;   
  /**
  * Documentacion para el procedimiento COMP_ELEC_CAB
  * Genera el comprobante electronico, documento XML
  * Pn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,          Recibe el Id del comprobante Electronico
  * Pn_IdEmpresa       IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,                      Recibe el Id de la empresa
  * Pn_IdTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,    Recibe el Id del tipo de documento
  * Pv_UsrCreacion     IN VARCHAR2,                                                 Recibe el usuario de creacion
  * Pv_TipoTransaccion IN VARCHAR2                                                  Recibe el tipo de transaccion
  * Retorna:
  * Pv_RucEmpresa               OUT VARCHAR2,       Retorna el Ruc de la empresa
  * Pclob_Comprobante           OUT CLOB,           Retorna el comprobante XML
  * Pv_NombreComprobante        OUT VARCHAR2,       Retorna el nombre de comprobante
  * Pv_NombreTipoComprobante    OUT VARCHAR2,       Retorna el nombre del tipo del comprobante
  * Pv_Anio                     OUT VARCHAR2,       Retorna el a�o en el que se genera el comprobante
  * Pv_Mes                      OUT VARCHAR2,       Retorna el mes en el que se genera el comprobante
  * Pv_Dia                      OUT VARCHAR2,       Retorna el dia en el que se genera el comprobante
  * Pv_MessageError             OUT VARCHAR2        Retorna un mensaje de error si llega existir
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.1 24-11-2014
  * @since 1.0
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.2 06-05-2015
  * @since 1.1
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.3 06-05-2015
  * @since 1.2
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.4 28-06-2016 Se aumenta el atributo de compesancion
  * @since 1.3
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.5 01-07-2016 Se envia la oficina en la funcion que retorna la direccion sucursal
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.6 18-07-2016 Se cambia la utilizacion de la funcion GET_VARCHAR_CLEAN_CLIENTE para la direcci�n
  * de envio
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.7 31-08-2016 Se agrega el Id persona rol para obtener la informaci�n del pago
  * de envio
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.8 22-09-2016 - Se verifica que al actualizar el comprobante electr�nico de un documento se actualice el campo 'FE_EMISION' de la tabla
  *                           'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.9 27-09-2016 - Se agregan los tags de 'COMPENSACIONES' requeridos por SRI al formato XML cuando el cliente es 'COMPENSADO'.
  *                           SOLO se agregan los tags de compensaciones si el valor guardado en el campo 'DESCUENTO_COMPENSACION' de la tabla 
  *                           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB es diferente de NULL y mayor que CERO.
  *                           Adicional se eliminan los tags de 'COMPENSACION' y 'FORMA_PAGO' de los campos adicionales.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.0 10-10-2016 - Se modifica la funci�n a�adiendo como campo adicional el tag de 'contribucionSolidaria'. Adicional se modifica la
  *                           la funci�n 'GET_INFODOCUMENTOXML' a�adiendo el par�metro 'Pv_CodEmpresa'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.1 13-10-2016 - Se parametrizan las validaciones para la longitud de los tags 'dirMatriz' y 'campoAdicional'.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.2 15-10-2016 - Se env�a el punto de facturaci�n a la funci�n GET_INFODOCUMENTOXML para poder obtener la forma de pago del punto
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.3 03-01-2017 - Se modifica procedimiento para enviar a la funci�n 'F_SET_ATTR_CONSUMO_CLIENTE' el a�o de consumo para ser mostrado en
  *                           la informaci�n adicional de la factura. El cambio solo aplica para TN.
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 2.4 18-04-2017 - Se agrega el tag 'fpagoCliente' como campo adicional con el objetivo de enviar la forma del pago del cliente dentro
  *                           del documento xml.
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 2.5 20-09-2017 - Se agrega el validacion dentro de los detalles del documento en el tag descripcion, se modifica el contenido que 
  *                            presenta, se realiza la llamada a la funci�n F_GET_DESCRIPCION_DET el cual retornar� la descripcion respectiva por 
  *                           tipo de facturacion (reactivacion, proporcional, mensual, contrato, req clientes, cambioPrecio) unicamente para MD.
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 2.6 04-12-2017 - Se agrega funcionalidad por Facturacion OFFLINE:
  *                           Se realiza con la generacion del comprobante electronico en DB_FINANCIERO, la creacion del documento en INFO_DOCUMENTO 
  *                           de DB_COMPROBANTES, asi como del usuario y usuarioEmpresa de no existir.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 2.7 08-01-2018 - Se modifica Procedimiento para que en los querys no sea tomada la empresa en sesion, como mejora se realiza cambio para 
  *                           que se tome la Empresa asignada a la Oficina que emitio el Documento sea factura o NC.
  *                           Se agrega llamada a la funcion F_GENERA_PASSWD_SHA256 para la generacion de PASSWORD que sera ingresado en ADMI_USUARIO 
  *                           y ADMI_USUARIO_EMPRESA.
  *                           Se modifica XML generando en mayuscula la informacion requerida para poder validar XSD.
  *                           Se agrega llamada a procedimiento P_VALIDA_COMPROBANTE que valida XML contra el XSD.
  *                           Se realiza mejora en el calculo de F_SUM_IMPUESTO_ICE_DET, para que calcule correctamente la base imponible del IVA incluyendo 
  *                           el impuesto ICE.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 2.8 06-02-2018 - Se modifica que cuando se trata de un reenvio se tome la clave de acceso de INFO_DOCUMENTO para la regeneracion del XML
  * con la misma clave de acceso ya que Proceso de Descarte Automatico, nuleaba la clave de acceso, lo cual es un proceso incorrecto para el proceso de facturacion offline.
  * Creacion de historial para el caso de documentos descuadrados unicamente cuando el mensaje sea nuevo, para evitar duplicidad de registros innecesarias. 
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 2.9
  * @since 08-11-2018
  * Se realiza el rec�lculo de impuestos cuando el documento no cuadra. Este proceso inserta historial por cambio de valores en la cabecera.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 3.0
  * @since 13-01-2021 - Se realiza validaci�n para activar las facturas (FAC, FACP) del proceso Offline, 
  *                     antes de ser enviada al SRI por medio de la consulta de un par�metro.
  * Costo C_GetParametroActivaFact: 3
  *
  *
  * @author Eduardo Montenegro <emontenegro@telconet.ec>
  * @version 3.1
  * @since 02-12-2022 - Se agrega la fecha maxima de pago como informacion adicional.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 3.2
  * @since 27-02-2023 - Se quita sentencia por RUC en el cursor C_ClaveAcceso y se agrega sentencia por el prefijo 
  *                     empresa con el codigo empresa del esquema comprobantes.
  *                     Se quita sentencia por RUC en el cursor C_GetDocumentXml y se agrega sentencia por el prefijo 
  *                     empresa con el codigo empresa del esquema comprobantes.
  */
  PROCEDURE COMP_ELEC_CAB(
      Pn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pn_IdEmpresa       IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pn_IdTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
      Pv_UsrCreacion     IN VARCHAR2,
      Pv_TipoTransaccion IN VARCHAR2,
      Pv_RucEmpresa OUT VARCHAR2,
      Pclob_Comprobante OUT CLOB,
      Pv_NombreComprobante OUT VARCHAR2,
      Pv_NombreTipoComprobante OUT VARCHAR2,
      Pv_Anio OUT VARCHAR2,
      Pv_Mes OUT VARCHAR2,
      Pv_Dia OUT VARCHAR2,
      Pv_MessageError OUT VARCHAR2);
    --
    /**
  * Documentaci�n para PROCEDURE 'P_INSERT_USUARIO_COMP_ELECT'.
  * Procedure que me permite el ingreso de usuario en DB_COMPROBANTE
  *
  * PARAMETROS:
  * @Param Prf_AdmiUsuario      IN FNCK_COM_ELECTRONICO.Lr_AdmiUsuario
  * @Param Pv_MsnError          OUT  VARCHAR2
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 06-12-2017
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 10-01-2018 - Se cambia PROCEDURE del paquete FNCK_COM_ELECTRONICO_TRAN al FNCK_COM_ELECTRONICO
  */           
    PROCEDURE P_INSERT_USUARIO_COMP_ELECT(
            Prf_AdmiUsuario IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuario,
            Pv_MsnError     OUT VARCHAR2);
 /**
  * Documentaci�n para PROCEDURE 'P_INSERT_USUARIOEMP_COMP_ELECT'.
  * Procedure que me permite el ingreso de usuario por empresa en DB_COMPROBANTE
  *
  * PARAMETROS:
  * @Param Prf_AdmiUsuarioEmpresa      IN FNCK_COM_ELECTRONICO.Lr_AdmiUsuarioEmpresa
  * @Param Pv_MsnError                 OUT  VARCHAR2
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 06-12-2017
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 10-01-2018 - Se cambia PROCEDURE del paquete FNCK_COM_ELECTRONICO_TRAN al FNCK_COM_ELECTRONICO
  */
    PROCEDURE P_INSERT_USUARIOEMP_COMP_ELECT(
            Prf_AdmiUsuarioEmpresa IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuarioEmpresa,
            Pv_MsnError            OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSERT_INFO_DOCUMENTO'.
  * Procedure que me permite el ingreso de info_documento en DB_COMPROBANTES
  *
  * PARAMETROS:
  * @Param Prf_InfoDocumento    IN FNCK_COM_ELECTRONICO.Lr_InfoDocumento
  * @Param Pv_MsnError          OUT  VARCHAR2
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 06-12-2017
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 10-01-2018 - Se cambia PROCEDURE del paquete FNCK_COM_ELECTRONICO_TRAN al FNCK_COM_ELECTRONICO
  */           
    PROCEDURE P_INSERT_INFO_DOCUMENTO(
            Prf_InfoDocumento IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento,
            Pv_MsnError       OUT VARCHAR2);
  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_DOCUMENTO'.
  * Procedure que me permite actualizar info_documento en DB_COMPROBANTES
  *
  * PARAMETROS:
  * @Param Prf_InfoDocumento    IN FNCK_COM_ELECTRONICO.Lr_InfoDocumento
  * @Param Pv_MsnError          OUT  VARCHAR2
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 06-12-2017
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 10-01-2018 - Se cambia PROCEDURE del paquete FNCK_COM_ELECTRONICO_TRAN al FNCK_COM_ELECTRONICO
  */         
    PROCEDURE P_UPDATE_INFO_DOCUMENTO(
            Prf_InfoDocumento IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento,
            Pv_MsnError       OUT VARCHAR2);
  /**
  * Documentaci�n para PROCEDURE 'INSERT_COMP_ELECTRONICO'.
  * Procedure que me permite crear el comprobante electronico
  *
  * PARAMETROS:
  * @Param Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico
  * @Param Pv_MsnError                OUT  VARCHAR2  
  * @since   1.0
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 10-01-2018 - Se cambia PROCEDURE del paquete FNCK_COM_ELECTRONICO_TRAN al FNCK_COM_ELECTRONICO
  */         
    PROCEDURE INSERT_COMP_ELECTRONICO(
            Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
            Pv_MsnError                OUT VARCHAR2);            
   /**
  * Documentaci�n para PROCEDURE 'UPDATE_COMP_ELECTRONICO'.
  * Procedure que me permite actualizar el comprobante electronico
  *
  * PARAMETROS:
  * @Param Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico
  * @Param Pv_MsnError                OUT  VARCHAR2  
  * @since   1.0
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 10-01-2018 - Se cambia PROCEDURE del paquete FNCK_COM_ELECTRONICO_TRAN al FNCK_COM_ELECTRONICO
  */                 
    PROCEDURE UPDATE_COMP_ELECTRONICO(
            Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
            Pv_MsnError                OUT VARCHAR2);          

  /**
  * Documentacion para la funcion COMP_ELEC_DET
  * Genera el detalle del comprobante electronico
  * Fn_IdDocumento          INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,                Recibe el Id del documento
  * Fv_CodTipoDocumento     ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE       Recibe el tipo de codigo del comprobante
  * Retorna:
  * Retorna un xmltype con el detalle del comprobante electronico.
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.1 21-06-2015
  * Se agrega la presentacion del nombre del producto o plan cuando el campo de observacion es null
  * @author Gina Villalba <gvillalba@telconet.ec>
  * Se modifica la presentacion de los valores a dos decimales con TRUNC
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.3 05-07-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 06-10-2016 - Se parametrizan las validaciones para la longitud del tag 'descripcion'.
  * @author  Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.5 08-03-2017 - Se agrega llamada a funci�n que retorna una cadena eliminando caracteres considerados inv�lidos dentro de un tag xml 
                              para este caso del tag 'descripcion'.
  * @author  Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.6 09-06-2021 - Se mueve funci�n F_SPLIT_DESCRIPCION_DET en el cursor C_GetDocumentoDetDescripXML para realizar split a la 
  *                           descripci�n previo a la validaci�n que realiza la funci�n de F_VALIDACION_FORMATO_XML.
  */
  FUNCTION COMP_ELEC_DET(
      Fn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_CodTipoDocumento ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
    RETURN XMLTYPE;
    --
    FUNCTION IMPUESTOS_DET(
        Fn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
        Fd_TotalSinIMpuestos INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE)
      RETURN XMLTYPE;
    --
  /**
  * Documentacion para la funcion IMPUESTOS_CAB
  * Genera la cabecera de los impuestos del comprobante
  * Fn_IdDocumento          INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,                Recibe el Id del documento
  * Fd_TotalSinIMpuestos    INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE  Recibe el Total sin impuestos
  * Retorna:
  * Retorna un xmltype con la cabecera de los impuestos del comprobante
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  *
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.1 04-07-2016 Se modifica el calculo de base imponible
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.2 05-07-2016 Se modifica la presentacion de los valores a dos decimales con TRUNC
  * @version 1.1
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.2 07-07-2016 Se quita el uso del TRUNC para cabeceras y se permite el redondeo
  * @version 1.0
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 16-10-2016 - Se realiza una validaci�n para considerar el total de los detalles sin impuestos, es decir los que no pagan IVA, 
  *                           cuando la factura tiene detalles adicionales que si pagan el impuesto de IVA
  */
  FUNCTION IMPUESTOS_CAB(
      Fn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fd_TotalSinIMpuestos INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE)
    RETURN XMLTYPE;
    --
    FUNCTION GET_ADITIONAL_DATA_BYPUNTO(
        Fn_IdPunto  IN INFO_PUNTO.ID_PUNTO%TYPE,
        Fv_TipoData IN ADMI_FORMA_CONTACTO.CODIGO%TYPE)
      RETURN VARCHAR2;
    --
    FUNCTION GET_DIRECCION_EMPRESA(
        Pn_IdEmpresa    IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pn_IdOficina    IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        Pv_Estado       IN INFO_EMPRESA_GRUPO.ESTADO%TYPE,
        Pv_TipoConsulta IN VARCHAR2)
      RETURN VARCHAR2;
    --
  /**
  * Documentacion para la funcion GET_EMPRESA_DATA
  * Retorna un XMLFOREST con el nombre, razion social y ruc de la empresa
  * @param Pn_IdEmpresa       IN Pn_IdEmpresa      INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Recibe el ID de la empresa
  * @param Pv_Estado          IN Pv_Estado         INFO_EMPRESA_GRUPO.ESTADO%TYPE recibe el es estado
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 05-10-2016 - Se parametrizan las validaciones para la longitud de los tags 'razonSocial', 'nombreComercial' y 'ruc'
  */
  FUNCTION GET_EMPRESA_DATA(
      Pn_IdEmpresa IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Estado    IN INFO_EMPRESA_GRUPO.ESTADO%TYPE )
    RETURN XMLTYPE;
    --
    --
  /**
  * Documentacion para la funcion GET_INFODOCUMENTOXML
  * Funcion que obtiene la informacion tributaria del cliente, funcion que se usa para facturas y notas de credito
  * Pn_IdDocumento           IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,            Recibe el Id del documento
  * Pd_FeEmision             IN INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,              Recibe la fecha de emision del comprobamte
  * Pv_Direccion             IN INFO_OFICINA_GRUPO.DIRECCION_OFICINA%TYPE,                  Recibe la direccion de la sucursal de la empresa
  * Pv_TipoDocumento         IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,  Recibe el tipo de documento(FAC|NC)
  * Pv_TipoIdentificadorSri  IN ADMI_TIPO_IDENTIFICACION.CODIGO_SRI%TYPE,                   Recibe el codigo sri de indentificacion del cliente
  * Pv_NumeroFactura         IN INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,      Recibe el numero de factura SRI
  * Pv_RazonSocial           IN INFO_PERSONA.RAZON_SOCIAL%TYPE,                             Recibe la razon social del cliente
  * Pv_Nombres               IN INFO_PERSONA.NOMBRES%TYPE,                                  Recibe los nombres del cliente
  * Pv_Apellidos             IN INFO_PERSONA.APELLIDOS%TYPE,                                Recibe los apellidos del cliente
  * Pv_IdentificacionCliente IN INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,                   Recibe la identificacion dell cliente
  * Pn_Total                 IN INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,             Recibe el valor total del comprobante
  * Pn_Subtotal              IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,                Recibe la base imponible del comprobante
  * Pn_TotalSinImpuesto      IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,                Recibe le valor total sin impuesto del comprobante
  * Pn_TotalDescuento        IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,                Recibe el total de descuento del comprobante
  * Pn_ReferenciaDocId       IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE             Recibe la referencia (id documento) en caso de que sea NC
  * Pn_IdPersonaRol          IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE                Recibe la referencia (id persona rol)
  * Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE            Recibe el c�digo de la empresa a la que pertenece el
  *                                                                                         documento
  * Pn_IdPunto               IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE   Id del punto de facturaci�n
  *
  * Retorna:
  * En tipo xmltype la infirmacion tributaria del cliente
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.1 03-12-2014
  * Se moodifica la presentacion de decimales y se usa TRUNC
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.2 05-07-2016
  * Se cambia a la presentacion con redondeo
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.307-07-2016
  * Se agrega el campo de la Id_persona_rol para poder obtener las formas de pago del cliente
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.4 31-08-2016
  * @since 1.0
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.5 16-09-2016 - Se a�ade como parte de la cabecera del XML los tags de 'COMPENSACION' mediante la funci�n 
  *                           'DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_CONTRIBUCION_SOLIDARIA'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.6 10-10-2016 - Se a�ade el par�metro 'Pv_CodEmpresa', adicional se modifica la funci�n 'F_GET_CONTRIBUCION_SOLIDARIA' para enviarle
  *                           como par�metros las variables 'Pv_CodEmpresa' y 'Pv_TipoDocumento' para verificar posteriormente si deben o no aparecer
  *                           los tags de compensaciones.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.7 13-10-2016 - Se parametrizan las validaciones para la longitud de los tags 'dirEstablecimiento', 'razonSocialComprador' e 
  *                           'identificacionComprador'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.8 15-10-2016 - Se recibe como par�metro el punto de facturaci�n para obtener la forma de pago por punto del cliente.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.9 24-10-2016 - Se modifica la funci�n 'IMPUESTOS_CAB' para que retorne los tags correspondientes al 'totalConImpuestos'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.0 02-12-2016 - Se modifica el cursor 'C_GetInfoDocNotaCredito' para enviar el valor de compensaci�n calculado al XML.
  */
  FUNCTION GET_INFODOCUMENTOXML(
      Pn_IdDocumento           IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pd_FeEmision             IN INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
      Pv_Direccion             IN INFO_OFICINA_GRUPO.DIRECCION_OFICINA%TYPE,
      Pv_TipoDocumento         IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_TipoIdentificadorSri  IN ADMI_TIPO_IDENTIFICACION.CODIGO_SRI%TYPE,
      Pv_NumeroFactura         IN INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
      Pv_RazonSocial           IN INFO_PERSONA.RAZON_SOCIAL%TYPE,
      Pv_Nombres               IN INFO_PERSONA.NOMBRES%TYPE,
      Pv_Apellidos             IN INFO_PERSONA.APELLIDOS%TYPE,
      Pv_IdentificacionCliente IN INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
      Pn_Total                 IN INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
      Pn_Subtotal              IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
      Pn_TotalSinImpuesto      IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
      Pn_TotalDescuento        IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
      Pn_ReferenciaDocId       IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pn_IdPersonaRol          IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Pn_DescuentoCompensacion IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE,
      Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pn_IdPunto               IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
    RETURN XMLTYPE;
  --
  --
    FUNCTION GET_CANTON_FORMA_PAGO(
        Pn_IdPersonaRol IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Pn_IdPunto      IN INFO_PUNTO.ID_PUNTO%TYPE)
      RETURN VARCHAR;
    --
    --
    /**
     * Documentacion para la funcion GET_FORMA_PAGO_SRI
     * Funcion que obtiene el codigo de la forma de pago del SRI
     * Fn_IdPersonaRol     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE                     Recibe el Id persona empresa rol
     * Fn_BaseImponible    IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE  Recibe el Valor total facturado
     * Fn_IdPunto          IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE                     Id del punto de facturaci�n
     * Retorna:
     * Retorna un xmltype con la forma de pago asociada al cliente
     * @author Gina Villalba <gvillalba@telconet.ec>
     * @version 1.0 31-08-2016
     * Se excluye la validacion del estado de los contratos
     * Se valida por el maximo id_contrato que posee el cliente
     * @author Gina Villalba <gvillalba@telconet.ec>
     * @version 1.1 03-09-2016
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.2 07-09-2016 - Se cambia la validaci�n para obtener la forma de pago asociada al cliente. Primero se busca la forma de pago ligada
     *                           al contrato, en caso de no existir se busca la forma de pago ligada al cliente o pre-cliente es decir, se busca el
     *                           el campo FORMA_PAGO_ID ingresada en la DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO.
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.3 19-09-2016 - Se cambia la validaci�n para obtener el c�digo de SRI que retorna la forma de pago asociada al cliente o al contrato
     *                           Se verifica si la forma de pago asociada al cliente es 'DEBITO', si lo es se debe verificar si es d�bito por 
     *                           'TARJETA' para enviar el c�digo del SRI respectivo asociado a la forma de pago de 'TARJETA DE CREDITO', caso
     *                           contrario se debe seguir enviando el c�digo del SRI que tiene asociado la forma de pago 'DEBITO'
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.4 15-10-2016 - Se recibe el id del punto de facturaci�n para poder obtener la forma de pago por punto del cliente, en caso de
     *                           existir un error se retornar� en NULL el XMLTYPE.
     */
    FUNCTION GET_FORMA_PAGO_SRI(
        Fn_IdPersonaRol   IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Fn_BaseImponible  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE,
        Fn_IdPunto        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
    RETURN XMLTYPE;
    --
    FUNCTION GET_VARCHAR_CLEAN(
        Fv_Cadena IN VARCHAR2)
      RETURN VARCHAR2;
    --
    /**
     * Documentacion para la funcion GET_VARCHAR_CLEAN_CLIENTE
     * Funcion que limpia ciertos caracteres especiales que no forman parte de la razon social del cliente
     * Fv_Cadena IN VARCHAR2   Recibe la cadena a limpiar
     * Retorna:
     * En tipo varchar2 la cadena sin caracteres especiales
     *
     * @author Gina Villalba <gvillalba@telconet.ec>
     * @version 1.0 15-07-2016
     * @author Gina Villalba <gvillalba@telconet.ec>
     * @version 1.1 09-08-2016
     * Se agregan validaciones adicionales para el envio al SRI
     * @author Gina Villalba <gvillalba@telconet.ec>
     * @version 1.2 22-08-2016
     * Se agrega la reestriccion para el caracter ".", debido a la valicacion del SRI
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.3 07-09-2016 - Se agrega que permita los caracteres '&', '�' y '�'. Adicional que cuando sea '�' y/o '�' los convierta a 'N' y/o 'n'
     */
    FUNCTION GET_VARCHAR_CLEAN_CLIENTE(
        Fv_Cadena IN VARCHAR2)
      RETURN VARCHAR2;  
    --
  /**
    * Documentacion para el procedure CREA_COMP_ELECTRONICO_MASIVO
    * Procedimiento llamado desde el JOB crea comprobantes electronicos, genera
    * los comprobantes electronicos
    *
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 14-10-2014
    * @version 1.1 30-05-2016
    *
    * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
    * @version 1.2 06-12-2017
    * Se agrega a la creacion del comprobante electronico la migraci�n del Documento en DB_COMPROBANTES
    *
    * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
    * @version 1.3 30-01-2018
    * Se aumenta el tama�o de  Pv_MessageError  a VARCHAR2(4000)
    *
    * @author Sofia Fernandez <sfernandez@telconet.ec>
    * @version 1.4 13-04-2018
    * Se modifica el cursor que recupera el establecimiento.
    *
    * @author Sofia Fernandez <sfernandez@telconet.ec>
    * @version 1.5 03-05-2018
    * Se optimizan querys.
    *
    * @author Luis Cabrera <lcabrera@telconet.ec>
    * @version 1.6
    * @since 29-08-2018
    * Se agrega el par�metro Pv_CodEmpresa. Por defecto es NULL y ejecuta facturaci�n para todas las empresas.
    * Si se env�a el Pv_CodEmpresa se realiza la facturaci�n �nicamente para esa empresa.
    * Se ordenan las empresas que se obtienen en el Cursor C_GetRucEmpresa para realizar el proceso primero por TN y luego MD.
    *
    * @author Luis Cabrera <lcabrera@telconet.ec>
    * @version 1.7
    * @since 08-11-2018
    * Se modifica la variable Pv_UsrCreacion a 'telcos_CompElec'
    * Se modifica la documentaci�n escrita en la cuerpo del paquete.
    *
    * @author Jos� Candelario <jcandelario@telconet.ec>
    * @version 1.8
    * @since 11-02-2021
    * Se agrega el par�metro de entrada Pv_FechaEjecucion para que proceso obtenga los documentos que se crearon antes de la fecha 
    * recibida.
    */
    PROCEDURE CREA_COMP_ELECTRONICO_MASIVO (Pv_FechaEjecucion IN VARCHAR2,
                                            Pv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE DEFAULT NULL);
    --
    PROCEDURE GET_NUMSEND_COMPROBANTE(
        Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Pn_NumeroEnvio OUT NUMBER);
    PROCEDURE SEND_MAIL_PLANTILLA(
        Pv_Envia   IN VARCHAR2,
        Pv_Asunto  IN VARCHAR2,
        Pv_Mensaje IN VARCHAR2,
        Pv_Codigo  IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE);
    --
    FUNCTION GET_NUM_CONTRATO(
        Pn_IdPersonaRol IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Pv_Estado       IN INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE)
      RETURN VARCHAR;
    --
    FUNCTION GET_LOGIN(
        Pn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
        Pv_Estado  IN INFO_PUNTO.ESTADO%TYPE)
      RETURN INFO_PUNTO.LOGIN%TYPE;
    --
    PROCEDURE GET_LOG_ESTADO_COMPROBANTE(
        Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Prf_MensajeCompElectronico OUT Lrf_MensajeCompElectronico,
        Pv_MessageError OUT VARCHAR2);
    --
    PROCEDURE GET_DOCS_FROM_INFODOCFINAN(
        Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Pblob_ComprobanteElectronico OUT INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECT_DEVUELTO%TYPE,
        Pblob_PdfComprobante OUT INFO_COMPROBANTE_ELECTRONICO.COMP_ELECTRONICO_PDF%TYPE,
        Pv_MessageError OUT VARCHAR2 );
    --
    FUNCTION GET_DIRECCION_ENVIO(
        Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE)
      RETURN VARCHAR2;
    --
    PROCEDURE GET_PUEDE_ACTUALIZAR(
        Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Pn_Estado      IN INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
        Pn_Resultado OUT NUMBER,
        Pv_MessageError OUT VARCHAR2);
    --
    FUNCTION GET_LONG_TO_VARCHAR(FrowId IN ROWID)
      RETURN VARCHAR2;
  --
  --
  /**
  * Documentacion para la funcion GET_DIFERENCIA_DOC
  * Obtiene el total de la suma de los detalles del documento financiero
  * Fn_IdDocumento          INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,                Recibe el Id del documento
  * Retorna:  El total de la sumatoria de los detalles del documento financiero
  *
  * Se redondea el valor de sumatoria a restar del total debido a que se guardan los valores de impuestos a tres decimales
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.1 24-06-2016
  *
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 12-12-2014
  *
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.2 12-12-2014 Se modifica la forma de validar por prioridad de impuesto
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.3 13-07-2016 Se agrega el round en la acumulacion de los impuestos ya que el calculo esta con 3 decimales
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.4 14-07-2016 Se agrega segunda evaluacion sin redondeo para cuadratura, unicamente si en la evaluacion con
  * redondeo genera diferencias
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.5 16-09-2016 - Se actualiza la validaci�n de los valores cuadrados, tomando en cuenta el valor de compensaci�n obtenido para el
  *                           cliente en su documento
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.6 02-12-2016 - Se actualiza la validaci�n de los valores cuadrados, calculando el valor de compensaci�n s�lo de los productos y/o
  *                           planes que pagan IVA
  */
  FUNCTION GET_DIFERENCIA_DOC(
      Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER;
  --
  --
    FUNCTION F_SET_ROOT_XMLTYPE(
        Fxml_Documento IN INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECTRONICO%TYPE,
        Fv_Version     IN VARCHAR2,
        Fv_Encoding    IN VARCHAR2)
      RETURN XMLTYPE;
    --
    FUNCTION F_SHOW_TAG_EMPRESA(
        Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
        Fv_Tag               IN VARCHAR2)
      RETURN BOOLEAN;
    --
    FUNCTION F_GET_SALDO_CLIENTE_BY_PUNTO(
        Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
      RETURN VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE;
    --
  /**
  * Documentacion para la funcion F_SET_ATTR_SALDO
  * Retorna el saldo de un punto
  * Fv_CodEmpresa         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Recibe el codigo de la empresa
  * Fv_CodeTipoDocumento  IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Recibe el codigo del tipo documento
  * Fn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE              Recibe el Id del punto
  * Fn_Saldo              IN VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE            Recibe el saldo
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 31-05-2016
  * @author Gina Villalba <gvillalba@telconet.ec>
  * Se modifica la presentacion de decimales y se usa TRUNC
  * @version 1.1 05-07-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 06-10-2016 - Se parametrizan las validaciones para la longitud del tag 'campoAdicional'.
  */
  FUNCTION F_SET_ATTR_SALDO(
      Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Fn_Saldo             IN VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE)
    RETURN XMLTYPE;
    --
  /**
  * Documentacion para la funcion F_SET_ATTR_SUBTOTAL_DOS
  * Retorna tags con el nombre subtotalDos, valorPagar dependiendo en valor en la variable de entrada Fv_Tipo
  * Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE          Recibe el codigo de la empresa
  * Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Recibe el codigo del tipo documento
  * Fn_Subtotal          IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE               Recibe el subtotal
  * Fn_SubtotalDescuento IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE     Recibe el subtotal de descuento
  * Fn_Total             IN INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE            Recibe el total de la factura
  * Fv_Tipo              IN VARCHAR2                                                  Recibe el tipo para definir el retorno de la funcion
  * @version 1.0 31-05-2016
  * @author Gina Villalba <gvillalba@telconet.ec>
  * Se modifica la presentacion de los decimales y se usa TRUNC
  * @version 1.1 05-07-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 06-10-2016 - Se parametrizan las validaciones para la longitud del tag 'campoAdicional'.
  */
  FUNCTION F_SET_ATTR_SUBTOTAL_DOS(
      Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Fn_Subtotal          IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
      Fn_SubtotalDescuento IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
      Fn_Total             IN INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
      Fv_Tipo              IN VARCHAR2)
    RETURN XMLTYPE;
    --
  /**
  * Documentacion para la funcion F_SET_ATTR_PAIS
  * Retorna un campo adicional con attr pais
  * Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE             Recibe el id de la empresa
  * Fn_IdPersonaRol      IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE    Recibe la persona empresa rol id
  * Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE    Recibe codigo tipo documento
  * @version 1.0 10-06-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 06-10-2016 - Se parametrizan las validaciones para la longitud del tag 'campoAdicional'.
  */
  FUNCTION F_SET_ATTR_PAIS(
      Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Fn_IdPersonaRol      IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
    RETURN XMLTYPE;
    --
  /**
  * Documentacion para la funcion F_SET_ATTR_CONSUMO_CLIENTE
  * Retorna un campo adicional con attr pais
  * Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE             Recibe el id de la empresa
  * Fn_IdPersonaRol      IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE    Recibe la persona empresa rol id
  * Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE    Recibe codigo tipo documento
  * @version 1.0 10-06-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.0 06-10-2016 - Se parametrizan las validaciones para la longitud del tag 'campoAdicional'.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 2.1 03-01-2017 - Se agrega variable 'Fv_AnioConsumo' para mostrar en el tag de consumo de la informaci�n adicional el a�o a la cual
  *                           pertenece la factura emitida. Dicha validaci�n se parametriza puesto que solo debe aplicar por el momento a TN.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 2.2 07-02-2018 - Se modifica XML Tags de CONSUMOCLIENTE generando en mayuscula la informacion requerida para poder validar XSD.
  *
  */
  FUNCTION F_SET_ATTR_CONSUMO_CLIENTE(
      Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Fv_MesConsumo        IN INFO_DOCUMENTO_FINANCIERO_CAB.MES_CONSUMO%TYPE,
      Fv_RangoConsumo      IN INFO_DOCUMENTO_FINANCIERO_CAB.RANGO_CONSUMO%TYPE,
      Fd_FeEmision         IN INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
      Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Fv_AnioConsumo       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ANIO_CONSUMO%TYPE)
    RETURN XMLTYPE;
  --
  /**
  * F_SUM_IMPUESTO_ICE_DET, Retorna la sumatoria a detalle de los impuestos para la informacion del comprobante
  *
  * Fn_IdDocDetalle IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE  Recibe el id del detalle del documento
  * Fv_CodigoSRI    IN ADMI_IMPUESTO.CODIGO_SRI%TYPE                      Recibe el codigo del impuesto del SRi
  * @return NUMBER 
  * 
  * @author Alexander Samaniego <awsamaniego@telconte.ec>
  * @version 1.0 04-07-2016
  *
  * Se cambia el TRUNC por ROUND ya que el valor correspondiente a base imponible se esta calculando con un centavo
  * menos
  * @author Gina Villalba <gvillalba@telconte.ec>
  * @version 1.1 13-07-2016
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.2 08-01-2018 -  Se realiza mejora para que calcule correctamente la base imponible para el calculo del IVA incluyendo 
  *                            el impuesto ICE, se modifica cursor C_GetTipoImpuesto  para que verifique el Impuesto 
  *                            asignado al detalle del documento y no solo por codigo de impuesto sri, ya que existen mas registros de Imp.IVA 
  *                            creados por Telcos Panama.
  */

  FUNCTION F_SUM_IMPUESTO_ICE_DET(Fn_IdDocDetalle IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
                                    Fv_CodigoSRI    IN ADMI_IMPUESTO.CODIGO_SRI%TYPE) 
  RETURN NUMBER;
  --
  --
  /**
  * F_SUM_IMPUESTO_ICE_CAB, Retorna la sumatoria de los impuestos para la informacion del comprobante
  *
  * @param Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE   Recibe el id del documento
  * @param Fv_CodigoSRI   IN ADMI_IMPUESTO.CODIGO_SRI%TYPE                       Recibe el codigo del impuesto del SRI
  * @return NUMBER
  *
  * @author Alexander Samaniego <awsamaniego@telconte.ec>
  * @version 1.0 04-07-2016
  * @author Edson Franco <efranco@telconte.ec>
  * @version 1.1 20-01-2017 - Se quita el TRUNC de la funci�n para que sean tomado en cuenta todos los decimales en la suma del impuesto con el 
  *                           subtotal
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.2 08-01-2018 -  Se realiza mejora para que calcule correctamente la base imponible para el calculo del IVA incluyendo 
  *                            el impuesto ICE, se modifica cursor C_GetTipoImpuesto  para que verifique el Impuesto 
  *                            asignado al documento y no solo por codigo de impuesto sri, ya que existen mas registros de Imp.IVA 
  *                            creados por Telcos Panama.
  */
  FUNCTION F_SUM_IMPUESTO_ICE_CAB(
      Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE,
      Fv_CodigoSRI   IN ADMI_IMPUESTO.CODIGO_SRI%TYPE)
    RETURN NUMBER;
  --
  --
    PROCEDURE P_UPDATE_ESTADO_COMP_ELECT(
        Pn_DocumentoIdFinan   IN DB_COMPROBANTES.INFO_DOCUMENTO.DOCUMENTO_ID_FINAN%TYPE,
        Pn_Estado             IN INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
        Pv_ClaveAcceso        IN INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE,
        Pv_ClaveAccesoNueva   IN INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE,
        Pt_FeAutorizacion     IN INFO_COMPROBANTE_ELECTRONICO.FE_AUTORIZACION%TYPE,
        Pv_NumeroAutorizacion IN INFO_COMPROBANTE_ELECTRONICO.NUMERO_AUTORIZACION%TYPE,
        Pv_Mensaje OUT VARCHAR2);
    --
    PROCEDURE P_UPDATE_CLAVEACCESO_COMP_ELEC(
        Pv_Nombre          IN DB_COMPROBANTES.INFO_DOCUMENTO.NOMBRE%TYPE,
        Pn_TipoDocId       IN DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_DOC_ID%TYPE,
        Pn_IdEmpresa       IN DB_COMPROBANTES.INFO_DOCUMENTO.EMPRESA_ID%TYPE,
        Pv_Establecimiento IN DB_COMPROBANTES.INFO_DOCUMENTO.ESTABLECIMIENTO%TYPE,  
        Pv_ClaveAcceso     IN DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%TYPE,
        Pn_Estado          IN DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_DOC_ID%TYPE,
        Pv_Mensaje         OUT VARCHAR2);
    --        
    PROCEDURE P_MESSAGE_COMP_ELEC_INSRT(
        Pv_Tipo          IN INFO_MENSAJE_COMP_ELEC.TIPO%TYPE,
        Pv_Mensaje       IN INFO_MENSAJE_COMP_ELEC.MENSAJE%TYPE,
        Pv_InfoAdicional IN INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE,
        Pn_DocumentoId   IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Pd_FeCreacion    IN INFO_MENSAJE_COMP_ELEC.FE_CREACION%TYPE,
        Pv_MensajeOut OUT VARCHAR2);
    --
  /**
  * Documentacion para la funcion F_SET_ATTR_CONTRIBUCION
  *
  * Funci�n que retorna el tag de 'contribucionSolidaria' como campo adicional al XML de un documento
  *
  * @param Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE             C�digo de la empresa a la que pertenece el documento
  * @param Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                        Id del punto del cliente
  * @param Fn_IdPersonalRol     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE    Id del cliente
  * @param Fn_IdDocumento       IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE              Id del documento al cual se le va a crear el XML
  * @param Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE    C�digo del tipo de documento que se va a crear el XML
  * @param Fn_SectorId          IN DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE                       Id del sector al que pertenece el punto del cliente
  * @param Fn_OficinaId         IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE              Id de la oficina de facturaci�n
  *
  * @return XMLTYPE Con los tags respectivos a la COMPENSACION
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 16-09-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 16-10-2016 - Se modifica la funci�n para que calcule el valor de compensaci�n del 2% de los productos que aplican IVA.
  */
  FUNCTION F_SET_ATTR_CONTRIBUCION(
      Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Fn_IdPersonalRol     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fn_IdDocumento       IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Fn_SectorId          IN DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE,
      Fn_OficinaId         IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE)
    RETURN XMLTYPE;  

   /**
    * Documentacion para la funcion F_SET_ATTR_DET_ADICIONAL
    *
    * Funci�n que retorna el tag de 'Detalle Adicional' como campo adicional al XML de un documento
    */

    FUNCTION F_SET_ATTR_DET_ADICIONAL(
    Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN XMLTYPE;
  --
  /**
  * Documentacion para la funcion F_GET_CONTRIBUCION_SOLIDARIA
  *
  * Funcion que retorna los tags respectivos a la COMPENSACION que ser� a�adidos a la cabecera del XML. 
  * Tag de ejemplo seria: <compensaciones>
  *                         <compensacion>
  *                           <codigo></codigo>
  *                           <tarifa></tarifa>
  *                           <valor></valor>
  *                         </compensacion>
  *                       </compensaciones>
  *
  * @param Pn_DescuentoCompensacion IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE  Valor compensado al cliente
  *
  * @return XMLTYPE Con los tags respectivos a la COMPENSACION
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 16-09-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 10-10-2016 - Se agregan dos par�metros 'Pv_CodEmpresa' y 'Pv_CodTipoDocumento' los cuales ayudar�n a verificar si el tag debe
  *                           aparecer o no en el XML que se enviar� al SRI.
  */
  FUNCTION F_GET_CONTRIBUCION_SOLIDARIA(
      Pn_DescuentoCompensacion IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE,
      Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_CodTipoDocumento      IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
    RETURN XMLTYPE;
  --
  /**
  * Documentacion para la funcion 'F_GET_COD_SRI_BY_BANCO_CUENTA'
  *
  * Funcion que obtiene el codigo de la forma de pago del SRI dependiendo del BANCO_TIPO_CUENTA que tenga asociado el contrato o el cliente.
  *
  * @param Fn_IdContratoOrPersona IN NUMBER     Id del Contrato asociado al cliente o el id de la PERSONA_EMPRESA_ROL
  * @param Fv_Filtro              IN VARCHAR2   Par�metro que indica si se debe buscar por CONTRATO o por PERSONA
  * @param Fv_CodigoFormaPago     IN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE      C�digo de la forma de pago que se desea buscar
  * @param Fv_CodigoSri           IN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE     C�digo del SRI que tiene asociada la forma de pago
  * 
  * @return DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE 
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 20-09-2016
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.1 24-05-2017 - Se agrega filtro de busqueda para la forma de pago 'TARJETA' en los siguientes cursores: C_GetBancoTipoCtaByContrato, 
  *                           C_GetBancoTipoCtaByPersonaRol.
  * 
  * Costo del query Cursor: C_GetBancoTipoCtaByContrato   5
  *                         C_GetBancoTipoCtaByPersonaRol 5
  */
  FUNCTION F_GET_COD_SRI_BY_BANCO_CUENTA(
      Fn_IdContratoOrPersona IN NUMBER,
      Fv_Filtro              IN VARCHAR2,
      Fv_CodigoFormaPago     IN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
      Fv_CodigoSri           IN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE)
    RETURN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE;
  --
  /**
  * Documentacion para la funcion 'F_VALIDACION_FORMATO_XML'
  *
  * Funcion que valida el formato del tag del XML de acuerdo a las consideraciones expuestas en el XSD del SRI.
  *
  * @param Fv_Tag           IN VARCHAR2     Tag del xml que se va a validar
  * @param Fv_Validador     IN VARCHAR2     Tipo de validaci�n que se va a realizar
  * @param Fv_ValorTag      IN VARCHAR2     Cadena que contiene lo que se desea escribir en el tag
  *
  * @return VARCHAR2
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 05-10-2016
  */
  FUNCTION F_VALIDACION_FORMATO_XML(
      Fv_Tag       IN DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
      Fv_Validador IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
      Fv_ValorTag  IN VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Documentaci�n para la funcion F_GET_VARCHAR_VALID_XML_VALUE
  * Funci�n que retorna una cadena eliminando caracteres considerados inv�lidos dentro de un tag xml.
  *
  * Fv_Cadena  IN VARCHAR2, Texto que se evaluar� y del cual se eliminar�n los caracteres inv�lidos
  * Retorna:
  * En tipo varchar2 texto sin caracteres inv�lidos
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.00 16-12-2016
  */
  FUNCTION F_GET_VARCHAR_VALID_XML_VALUE(
    Fv_Cadena IN VARCHAR2)
  RETURN VARCHAR2;
  --
  /**
  * Documentaci�n para la funcion F_GET_DESCRIPCION_DET
  *
  * Funci�n que retorna la descripcion de la factura por tipo de facturacion 
  * (reactivacion, proporcional, mensual, contrato, req clientes, cambioPrecio)
  * con la finalidad de realizar la busqueda del parametro dentro de la descripcion 
  * para proceder a a�adirle el nombre del plan unicamente para MD. 
  *
  * Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, Id del documento a consultar.
  * Fv_PrefijoEmpresa  IN VARCHAR2, Prefijo de empresa a consultar
  *
  * Retorna:
  * En tipo varchar2 Descripcion correspondiente al documento.
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.00 16-12-2016
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.01 06-10-2017 - Se realiza correcci�n se env�a idDocDetalle de la factura con esto 
  *                            se proceder� a a�adir el nombre del plan a cada descripcion del detalle.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.00 31-07-2018 Se agrega usuario telcos_cancelacion para obtener la descripcion del documento.
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.03
  * @since 14-11-2018
  * Se agrega estructura de control que por defecto se retorne �nicamente la descripci�n del detalle.
  */
  FUNCTION F_GET_DESCRIPCION_DET(
    Fn_IdDocDetalle     IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
    Fv_PrefijoEmpresa   IN VARCHAR2)
  RETURN INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE;
  --
  --
  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_DOC_FINANCIERO_CAB'.
  * Procedure que me permite actualizar el estado de INFO_DOCUMENTO_FINANCIERO_CAB en DB_FINANCIERO
  *
  * PARAMETROS:
  * @Param Pn_IdDocumento  IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
  * @Param Pv_Estado       IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT
  * @Param Pv_MsnError     OUT VARCHAR2
  *
  * @author Hector Lozano<hlozano@telconet.ec>
  * @version 1.0 22-12-2020
  *
  */         
  PROCEDURE P_UPDATE_INFO_DOC_FIN_CAB( Pn_IdDocumento  IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                       Pv_Estado       IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                                       Pv_MsnError    OUT  VARCHAR2);
  --
  --
  /**
  * Documentaci�n para PROCEDURE 'F_GET_ULTIMO_ESTADO_DOC'.
  * Funci�n que me permite obtener el �ltimo estado diferente de rechazado de un documento financiero.
  *
  * PARAMETROS:
  * @Param Fn_IdDocumento     IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
  *
  * Return DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE  Estado del Documento.
  *
  * @author Hector Lozano<hlozano@telconet.ec>
  * @version 1.0 18-01-2021
  *
  * Costo Query Cursor: C_GetUltimoEstadoDoc 12
  */                                              
  FUNCTION F_GET_ULTIMO_ESTADO_DOC(Fn_IdDocumento  IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE;
  --
  --
  /**
   * Documentaci�n para PROCEDURE 'P_BAJA_PM_FACT_RECHAZADAS'.
   *
   * Procedure da de Baja a los procesos masivos de reenv�o de facturas rechazadas, que no fueron procesados.
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 05-04-2022
   */
   PROCEDURE P_BAJA_PM_FACT_RECHAZADAS; 
   --
   --
   /**
   * Documentaci�n para PROCEDURE 'P_CREA_PM_FACT_RECHAZADAS'.
   *
   * Procedure que genera un Proceso Masivo para enviar al SRI las facturas rechazadas, para ser reprocesadas.
   *
   * PARAMETROS:
   * @Param Pv_UsrCreacion          IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE  (Usuario en sesi�n)
   * @Param Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (C�digo de Empresa en sesi�n)
   * @Param Pv_IpCreacion           IN  VARCHAR2 (Ip de Creaci�n)
   * @Param Pv_TipoPma              IN  VARCHAR2 (Tipo de Proceso Masivo)
   * @Param Pv_MsjResultado         OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.0 20-01-2021
   */
   PROCEDURE P_CREA_PM_FACT_RECHAZADAS(Pv_UsrCreacion      IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                       Pv_CodEmpresa       IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_IpCreacion       IN  VARCHAR2,
                                       Pv_TipoPma          IN  VARCHAR2,
                                       Pv_MsjResultado     OUT VARCHAR2); 
  --
  --
  /**
  * Documentaci�n para PROCEDURE 'P_PROCESAR_FACT_RECHAZADAS'.
  *
  * Procedure que procesa las facturas rechazadas.
  *
  * PARAMETROS:
  * @Param Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (C�digo de Empresa en sesi�n)
  * @Param Pv_TipoTransaccion      IN  VARCHAR2 (Tipo de transacci�n 'UPDATE')
  * @Param Pv_IdsDocumento         IN  VARCHAR2 (String de Id's Documentos separados por coma)
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 20-01-2021
  *
  * Costo Query Cursor: C_GetFacturasRechazadas: 3100
  * Costo Query Cursor: C_GetProcesoMasivo: 4
  * Costo Query Cursor: C_GetDocFinanciero:4
  *
  */
  PROCEDURE P_PROCESAR_FACT_RECHAZADAS (Pv_CodEmpresa       IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_TipoTransaccion  IN  VARCHAR2,
                                        Pv_IdsDocumento     IN  VARCHAR2); 
  --
  --
  /**
  * Documentaci�n para el procedimiento P_REPORTE_DOC_RECHAZADOS.
  *
  * Procedimiento que ejecuta la generaci�n de reporte de NC autom�ticas,pagos,anticipos que estan enlazados a facturas sin gesti�n.
  *
  * PARAMETROS:
  * @param Pv_EmpresaCod      IN VARCHAR2   (Id de la empresa).
  * @param Pv_PrefijoEmpresa  IN VARCHAR2   (Prefijo de la empresa).
  * @param Pv_EmailUsuario    IN VARCHAR2   (Correo a quien se env�a reporte).
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 25-01-2021
  *
  * Costo Query Cursor: C_DocumentosRechazados: 3100
  *
  */
  PROCEDURE P_REPORTE_DOC_RECHAZADOS(Pv_EmpresaCod      IN VARCHAR2,
                                     Pv_PrefijoEmpresa  IN VARCHAR2,
                                     Pv_EmailUsuario    IN VARCHAR2);
  --
  --
  /**
  * Documentaci�n para Funci�n 'F_SPLIT_DESCRIPCION_DET'.
  *
  * Funci�n que separa una cadena de string demasiado larga.
  *
  * PARAMETROS:
  * @Param Fn_DescripcionDetalle   IN  INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE  (Detalle del documento financiero)
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-03-2021
  */
  FUNCTION F_SPLIT_DESCRIPCION_DET(Fn_DescripcionDetalle  IN INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE)
  RETURN INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE;
  --
  --
  /**
  * Documentaci�n para Funci�n 'F_GET_FECHA_MAXIMA_PAGO'.
  *
  * Funci�n que regresa la fecha maxima de pago estipulada en 10 dias en funcion del id del documento.
  *
  * PARAMETROS:
  * @Param Fn_IdDocumento   IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  (Detalle del documento financiero)
  * @Return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE
  *
  * @author Eduardo Montenegro <emontenegro@telconet.ec>
  * @version 1.0 02-12-2022
  */
  FUNCTION F_GET_FECHA_MAXIMA_PAGO(Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE;
  --
  --
  END FNCK_COM_ELECTRONICO;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_COM_ELECTRONICO
AS
  --
  FUNCTION GET_EMPRESA_DATA(
      Pn_IdEmpresa IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Estado    IN INFO_EMPRESA_GRUPO.ESTADO%TYPE )
    RETURN XMLTYPE
  IS
    --
    CURSOR C_Get_Empresa_Data( Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                               Cv_Estado INFO_EMPRESA_GRUPO.ESTADO%TYPE, 
                               Cv_RazonSocial DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                               Cv_NombreComercial DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                               Cv_Ruc DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                               Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE )
    IS
      SELECT XMLForest( FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_RazonSocial, 
                                                                       Cv_Validador, 
                                                                       UPPER(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(IEG.RAZON_SOCIAL))) "razonSocial",
                        FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_NombreComercial, 
                                                                       Cv_Validador, 
                                                                       UPPER(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(IEG.NOMBRE_EMPRESA))) "nombreComercial",
                        FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML(Cv_Ruc, Cv_Validador, IEG.RUC) "ruc" )
      FROM INFO_EMPRESA_GRUPO IEG
      WHERE IEG.ESTADO    = Cv_Estado
      AND IEG.COD_EMPRESA = Cn_IdEmpresa;
    --
    LXML_Get_Empresa_Data XMLTYPE;
    Lv_RazonSocial DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE     := 'razonSocial';
    Lv_NombreComercial DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'nombreComercial';
    Lv_Ruc DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE             := 'ruc';
    Lv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE            := 'SUBSTRING';
    --
  BEGIN
    --
    IF C_Get_Empresa_Data%ISOPEN THEN
      --
      CLOSE C_Get_Empresa_Data;
      --
    END IF;
    --
    OPEN C_Get_Empresa_Data(Pn_IdEmpresa, Pv_Estado, Lv_RazonSocial, Lv_NombreComercial, Lv_Ruc, Lv_Validador);
    --
    FETCH C_Get_Empresa_Data INTO LXML_Get_Empresa_Data;
    --
    CLOSE C_Get_Empresa_Data;
    --
    RETURN LXML_Get_Empresa_Data;
    --
  EXCEPTION
  WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_EMPRESA_DATA', SQLERRM);
  END GET_EMPRESA_DATA;
--
--
 FUNCTION F_GET_TOTAL_IMPUESTO(
  Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN Lr_TotalImpuesto
IS
  --
  CURSOR C_GetDetImpuestos(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS   
  SELECT AI.CODIGO_SRI AS CODIGO,
  AI.CODIGO_TARIFA AS CODIGO_PORCENTAJE, 
  TO_NUMBER(TRIM(TO_CHAR(NVL( SUM((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) 
   - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0)), 0) 
   + NVL(FNCK_COM_ELECTRONICO.F_SUM_IMPUESTO_ICE_CAB(Cn_IdDocumento, AI.CODIGO_SRI), 0), 
   '99999999990D99'))) AS BASE_IMPONIBLE, 
  TO_NUMBER(TRIM(TO_CHAR(SUM(NVL(IDFI.VALOR_IMPUESTO, 0)),'99999999990D99'))) AS VALOR
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD,
          DB_GENERAL.ADMI_IMPUESTO AI
        WHERE IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
        AND AI.ID_IMPUESTO        = IDFI.IMPUESTO_ID
        AND IDFD.DOCUMENTO_ID     = Cn_IdDocumento
        GROUP BY AI.CODIGO_SRI,
          AI.CODIGO_TARIFA,
          AI.TIPO_IMPUESTO,
          AI.PORCENTAJE_IMPUESTO;          
  --
  CURSOR C_GetTotalDetallesSinImp(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                  Cv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE, 
                                  Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  IS
  SELECT 
        (SELECT TRIM(TO_CHAR(NVL(AI.CODIGO_SRI, 0),'9999'))
          FROM DB_GENERAL.ADMI_IMPUESTO AI
          WHERE TIPO_IMPUESTO = Cv_TipoImpuesto AND
           ESTADO             = Cv_EstadoActivo
          ) AS CODIGO,
        (SELECT TRIM(TO_CHAR(NVL(AI.CODIGO_TARIFA, 0),'9999'))
        FROM DB_GENERAL.ADMI_IMPUESTO AI
        WHERE TIPO_IMPUESTO = Cv_TipoImpuesto AND
         ESTADO             = Cv_EstadoActivo
        ) AS CODIGO_PORCENTAJE,
        TO_NUMBER(TRIM(TO_CHAR(NVL( SUM((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0)), 0), 
                     '99999999990D99') )) AS BASE_IMPONIBLE, 
        TO_NUMBER(TRIM(TO_CHAR(0.00, '0D00'))) AS VALOR
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
        LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI
        ON IDFI.DETALLE_DOC_ID  = IDFD.ID_DOC_DETALLE
        WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento
        AND IDFI.ID_DOC_IMP    IS NULL
        GROUP BY IDFD.DOCUMENTO_ID;
  --
  CURSOR C_GetDetImpuestosImpNull(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                  Cv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE, 
                                  Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  IS
      SELECT 
        (SELECT AI.CODIGO_SRI
        FROM DB_GENERAL.ADMI_IMPUESTO AI
        WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
        AND ESTADO          = Cv_EstadoActivo
        ) AS CODIGO,
      (SELECT AI.CODIGO_TARIFA
      FROM DB_GENERAL.ADMI_IMPUESTO AI
      WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
      AND ESTADO          = Cv_EstadoActivo
      ) AS CODIGO_PORCENTAJE, 
      TO_NUMBER(TRIM(TO_CHAR(NVL(TO_NUMBER( TRIM(TO_CHAR( NVL(IDFC.SUBTOTAL, 0) - NVL(IDFC.SUBTOTAL_DESCUENTO, 0),'99999999990D99')))  
      , 0),'99999999990D99'))) AS BASE_IMPONIBLE, TO_NUMBER(TO_CHAR(0.00, '0D00')) AS VALOR
      FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      WHERE IDFC.ID_DOCUMENTO = Cn_IdDocumento;
  --      
  Lr_GetDetImpuestos            C_GetDetImpuestos%ROWTYPE;
  Lr_GetTotalDetallesSinImp     C_GetTotalDetallesSinImp%ROWTYPE;
  Lr_GetDetImpuestosImpNull     C_GetDetImpuestosImpNull%ROWTYPE;
  Lv_BanderaCalcularSinImpuesto VARCHAR2(2)                   := 'S';
  Lv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE        := 'Activo';
  Lv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := 'IVA_CERO';
  Lr_CabTotalImpuesto Lr_TotalImpuesto;
  --
BEGIN
  --
  IF C_GetDetImpuestos%ISOPEN THEN
  --
    CLOSE C_GetDetImpuestos;
  --
  END IF;    
  --
  IF C_GetTotalDetallesSinImp%ISOPEN THEN
  --
    CLOSE C_GetTotalDetallesSinImp;
  --
  END IF;
  --    
  IF C_GetDetImpuestosImpNull%ISOPEN THEN
  --
    CLOSE C_GetDetImpuestosImpNull;
  --
  END IF;    
  --
  OPEN C_GetDetImpuestos(Fn_IdDocumento);
  --
  FETCH C_GetDetImpuestos INTO Lr_GetDetImpuestos;
  --
  --Se verifica si existen detalles con impuestos IVA o ICE 
  --para verificar si la factura tiene detalles adicionales sin impuestos
  IF C_GetDetImpuestos%FOUND THEN    
    --
    Lr_CabTotalImpuesto:=Lr_GetDetImpuestos;
    --
    OPEN C_GetTotalDetallesSinImp(Fn_IdDocumento, Lv_EstadoActivo, Lv_TipoImpuesto);
    --
    FETCH C_GetTotalDetallesSinImp INTO Lr_GetTotalDetallesSinImp;    
    --
    IF C_GetTotalDetallesSinImp%NOTFOUND THEN
       Lv_BanderaCalcularSinImpuesto := 'N';
    END IF;
    --
    CLOSE C_GetTotalDetallesSinImp;
    --
  END IF;
  --
  CLOSE C_GetDetImpuestos;  
  --
  --Solo ingresar� aqu� cuando la factura tenga todos sus detalles sin impuestos 
  IF Lv_BanderaCalcularSinImpuesto = 'S' THEN  
    --
    OPEN C_GetDetImpuestosImpNull(Fn_IdDocumento, Lv_EstadoActivo, Lv_TipoImpuesto);
    --
    FETCH C_GetDetImpuestosImpNull INTO Lr_GetDetImpuestosImpNull;
    --
    IF C_GetDetImpuestosImpNull%FOUND THEN
    --
      Lr_CabTotalImpuesto:=Lr_GetDetImpuestosImpNull;
    --  
    END IF;
    --
    CLOSE C_GetDetImpuestosImpNull;
    --
  END IF;
  --
  RETURN Lr_CabTotalImpuesto;
  --
EXCEPTION
WHEN OTHERS THEN
  --    
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('F_GET_TOTAL_IMPUESTO', 
                                'FNCK_COM_ELECTRONICO.F_GET_TOTAL_IMPUESTO', 
                                SQLERRM);
END F_GET_TOTAL_IMPUESTO;  
--
--
FUNCTION GET_DIFERENCIA_XML(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_GetInfoDocumentoFinCab(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT ID_DOCUMENTO,     
      NVL(IDFC.SUBTOTAL, 0) - NVL(IDFC.SUBTOTAL_DESCUENTO, 0) AS  TOTAL_SIN_IMPUESTOS,
      NVL(IDFC.SUBTOTAL_DESCUENTO, 0) AS TOTAL_DESCUENTO,
      NVL(IDFC.VALOR_TOTAL, 0) AS VALOR_TOTAL,
      NVL(IDFC.DESCUENTO_COMPENSACION, 0) AS DESCUENTO_COMPENSACION
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    WHERE ID_DOCUMENTO = Cn_IdDocumento;
  --
  CURSOR C_GetInfoDocumentoFinDet(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT ID_DOC_DETALLE,
      NVL(PRECIO_VENTA_FACPRO_DETALLE, 0) AS PRECIO_VENTA_FACPRO_DETALLE,
      NVL(CANTIDAD, 0) AS CANTIDAD,
      NVL(DESCUENTO_FACPRO_DETALLE, 0) AS DESCUENTO_FACPRO_DETALLE   
    FROM INFO_DOCUMENTO_FINANCIERO_DET
    WHERE DOCUMENTO_ID = Cn_IdDocumento;
  --
  CURSOR C_GetInfoDocumentoFinImp(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  IS
    SELECT IDFI.IMPUESTO_ID,     
      NVL(IDFI.VALOR_IMPUESTO, 0) AS VALOR_IMPUESTO,
      IDFI.PORCENTAJE,
      AI.PORCENTAJE_IMPUESTO,
      AI.PRIORIDAD
    FROM INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      ADMI_IMPUESTO AI
    WHERE IDFI.IMPUESTO_ID  = AI.ID_IMPUESTO
    AND IDFI.DETALLE_DOC_ID = Cn_IdDocDetalle
    ORDER BY AI.PRIORIDAD;
  --
  Ln_Subtotal         NUMBER                                                                       := 0;
  Ln_SubtotalImpuesto NUMBER                                                                       := 0;
  Ln_Impuesto         NUMBER                                                                       := 0;
  Ln_Resultado        NUMBER                                                                       := 0;
  Lr_GetInfoDocumentoFinCab C_GetInfoDocumentoFinCab%ROWTYPE                                       := NULL;
  Ln_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE                          := 0;
  Ln_DescuentoCompensacion DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE := 0;
  Lv_TipoImpuestoCompensacion DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE                          := 'COM';
  --
  --VARIABLE USADA PARA ACUMULAR LOS SUBTOTALES QUE SE LES CALCULA IVA PARA HALLAR EL VALOR DE LA COMPENSACION
  Ln_SubtotalSoloIva NUMBER                                                                        := 0;
  --
BEGIN
  --
  IF C_GetInfoDocumentoFinCab%ISOPEN THEN
    --
    CLOSE C_GetInfoDocumentoFinCab;
    --
  END IF;
  --
  OPEN C_GetInfoDocumentoFinCab(Fn_IdDocumento);
  --
  FETCH C_GetInfoDocumentoFinCab INTO Lr_GetInfoDocumentoFinCab;
  ---
  CLOSE C_GetInfoDocumentoFinCab;
  --
  IF Lr_GetInfoDocumentoFinCab.ID_DOCUMENTO IS NOT NULL THEN
    --
    FOR I_GetInfoDocumentoFinDet IN C_GetInfoDocumentoFinDet(Lr_GetInfoDocumentoFinCab.ID_DOCUMENTO)
    LOOP
      --
      Ln_Subtotal := 0;
      Ln_Impuesto := 0;      
      Ln_Subtotal := (I_GetInfoDocumentoFinDet.PRECIO_VENTA_FACPRO_DETALLE * I_GetInfoDocumentoFinDet.CANTIDAD) -
 I_GetInfoDocumentoFinDet.DESCUENTO_FACPRO_DETALLE;

      FOR I_GetInfoDocumentoFinImp IN C_GetInfoDocumentoFinImp(I_GetInfoDocumentoFinDet.ID_DOC_DETALLE)
      LOOP
        --
        IF I_GetInfoDocumentoFinImp.PRIORIDAD = 1 THEN        
          --
          Ln_Subtotal := Ln_Subtotal +NVL(Ln_Subtotal * (I_GetInfoDocumentoFinImp.PORCENTAJE_IMPUESTO / 100),0);          
          --
        ELSE
          --          
          Ln_Impuesto := Ln_Impuesto + NVL(Ln_Subtotal * (I_GetInfoDocumentoFinImp.PORCENTAJE_IMPUESTO / 100),0);          
          --
        END IF;
        --
      END LOOP;
      --
      Ln_SubtotalImpuesto := Ln_SubtotalImpuesto + TO_NUMBER(TO_CHAR(Ln_Subtotal, '99999999990D99')) + 
TO_NUMBER(TO_CHAR(Ln_Impuesto, '99999999990D99'));
      --
    END LOOP;
    --
    Ln_SubtotalImpuesto := Ln_SubtotalImpuesto - TO_NUMBER(TO_CHAR(NVL(Lr_GetInfoDocumentoFinCab.DESCUENTO_COMPENSACION, 0), '99999999990D99'));
    --
    Ln_Resultado := TO_NUMBER(TO_CHAR(Lr_GetInfoDocumentoFinCab.VALOR_TOTAL, '99999999990D99'))-Ln_SubtotalImpuesto;

    IF (Ln_Resultado <>0) THEN
        --
        Ln_SubtotalImpuesto := 0;
        Ln_SubtotalSoloIva  := 0;
        --
        FOR I_GetInfoDocumentoFinDet IN C_GetInfoDocumentoFinDet(Lr_GetInfoDocumentoFinCab.ID_DOCUMENTO)
        LOOP
          --
          Ln_Subtotal := 0;
          Ln_Impuesto := 0;
          Ln_Subtotal := (I_GetInfoDocumentoFinDet.PRECIO_VENTA_FACPRO_DETALLE * I_GetInfoDocumentoFinDet.CANTIDAD) - 
I_GetInfoDocumentoFinDet.DESCUENTO_FACPRO_DETALLE;
          FOR I_GetInfoDocumentoFinImp IN C_GetInfoDocumentoFinImp(I_GetInfoDocumentoFinDet.ID_DOC_DETALLE)
          LOOP
            --
            IF I_GetInfoDocumentoFinImp.PRIORIDAD = 1 THEN
               Ln_Subtotal:= Ln_Subtotal + ROUND(NVL(Ln_Subtotal * (I_GetInfoDocumentoFinImp.PORCENTAJE_IMPUESTO / 100),0),3);  
               Ln_Subtotal:=ROUND(Ln_Subtotal,2);
              --
            ELSE
              --
              Ln_SubtotalSoloIva := Ln_SubtotalSoloIva + NVL(Ln_Subtotal, 0); --ACUMULA LOS SUBTOTALES DE LOS PLANES Y/O PRODUCTOS QUE GENERAN IVA
              Ln_Impuesto := Ln_Impuesto + ROUND(NVL(Ln_Subtotal * (I_GetInfoDocumentoFinImp.PORCENTAJE_IMPUESTO / 100),0),3);
              Ln_Impuesto := ROUND(Ln_Impuesto,2);
              --
            END IF;
            --
          END LOOP;
          --
          Ln_SubtotalImpuesto := Ln_SubtotalImpuesto + Ln_Subtotal + Ln_Impuesto;
          --
        END LOOP;
        --
        --
        IF NVL(Lr_GetInfoDocumentoFinCab.DESCUENTO_COMPENSACION, 0) > 0 THEN
          --
          Ln_PorcentajeImpuesto := DB_FINANCIERO.FNCK_FACTURACION_MENSUAL_TN.F_OBTENER_IMPUESTO(Lv_TipoImpuestoCompensacion);
          --
          --
          IF NVL(Ln_PorcentajeImpuesto, 0) > 0 AND NVL(Ln_SubtotalSoloIva, 0) > 0 THEN
            --
            Ln_DescuentoCompensacion := Ln_Impuesto + TO_NUMBER(TO_CHAR( ((NVL(Ln_SubtotalSoloIva, 0) * NVL(Ln_PorcentajeImpuesto, 0)) / 100 ), 
'99999999990D99'));
            --
          END IF;
          --
        END IF;
        --
        --
        Ln_SubtotalImpuesto := Ln_SubtotalImpuesto - NVL(Ln_DescuentoCompensacion, 0);
        --        
        Ln_Resultado :=Lr_GetInfoDocumentoFinCab.VALOR_TOTAL - Ln_SubtotalImpuesto;
        --
    END IF;
    --
  END IF;
  --
  RETURN Ln_Resultado;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_DIFERENCIA_XML', SQLERRM);
  --
END GET_DIFERENCIA_XML;
--
--
FUNCTION F_GENERATORCLAVE (
   fechaEmision       VARCHAR2,
   tipoComprobante    VARCHAR2,
   numeroRuc          VARCHAR2,
   ambiente           VARCHAR2,
   serie              VARCHAR2,
   secuencial         VARCHAR2,
   codNumerico        VARCHAR2,
   tipoEmision        VARCHAR2)
   RETURN VARCHAR2
AS
   LANGUAGE JAVA
   NAME 'GeneratorClave.generarClaveAcceso(java.lang.String,
   java.lang.String,
   java.lang.String,
   java.lang.String,
   java.lang.String,
   java.lang.String,
   java.lang.String,
   java.lang.String) return java.lang.String'; 
--
--
FUNCTION F_GENERA_PASSWD_SHA256 (
   Fn_Identificacion        VARCHAR2)
   RETURN VARCHAR2
AS
   LANGUAGE JAVA
   NAME 'Genera_Passwd_Sha256.computeHashSHA256(java.lang.String) return java.lang.String';

--
--
PROCEDURE COMP_ELEC_CAB(
        Pn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Pn_IdEmpresa       IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pn_IdTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
        Pv_UsrCreacion     IN VARCHAR2,
        Pv_TipoTransaccion IN VARCHAR2,
        Pv_RucEmpresa OUT VARCHAR2,
        Pclob_Comprobante OUT CLOB,
        Pv_NombreComprobante OUT VARCHAR2,
        Pv_NombreTipoComprobante OUT VARCHAR2,
        Pv_Anio OUT VARCHAR2,
        Pv_Mes OUT VARCHAR2,
        Pv_Dia OUT VARCHAR2,
        Pv_MessageError OUT VARCHAR2)
IS
    --Costo: 17
    CURSOR C_ClaveAcceso (Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) 
    IS    
    SELECT
   FNCK_COM_ELECTRONICO.F_GENERATORCLAVE(
     TO_CHAR(IDFC.FE_EMISION, 'ddmmyyyy'),
     LPAD(ATDF.CODIGO_TIPO_COMPROB_SRI, 2, 0),
     IEG.RUC,
     EMPDOC.AMBIENTE_ID,
     IDFC.ESTABLECIMIENTO || IDFC.EMISION,
     IDFC.SECUENCIA,
     TO_CHAR(IDFC.FE_EMISION, 'ddmmyyyy'),1
    ) AS CLAVE_ACCESO
     FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
     DB_COMERCIAL.INFO_PUNTO IP,
     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
     DB_COMERCIAL.INFO_PERSONA IPR,
     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
     DB_GENERAL.ADMI_TIPO_IDENTIFICACION ATI ,
     DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
     DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG,
     --
    DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO TDOC,                     
    DB_COMPROBANTES.ADMI_EMPRESA EMPDOC,
    DB_COMPROBANTES.INFO_TIPO_IDENTIFICACION TIDDOC
    WHERE 
    IDFC.TIPO_DOCUMENTO_ID                       =  ATDF.ID_TIPO_DOCUMENTO
    AND LPAD(ATDF.CODIGO_TIPO_COMPROB_SRI, 2, 0) = TDOC.CODIGO    
    AND IDFC.PUNTO_ID                            = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID                = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID                          = IPR.ID_PERSONA
    AND NVL(IPR.TIPO_IDENTIFICACION, 'CED')      = ATI.ID_TIPO_IDENTIFICACION
    AND LPAD(ATI.CODIGO_SRI, 2, 0)               = TIDDOC.CODIGO
    AND IDFC.OFICINA_ID                         =  IOG.ID_OFICINA
    AND IOG.EMPRESA_ID                           = IEG.COD_EMPRESA               
    AND IDFC.ID_DOCUMENTO                        = Cn_IdDocumento
    AND IEG.PREFIJO                              = EMPDOC.CODIGO;   

    --Cursor que obtiene el total de impuestos de un documento con la m�scara necesaria para que cuadren los valores.
    --Costo: 5
    CURSOR C_ObtieneTotalImpuestos (Pn_DocumentoId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE) IS
        SELECT SUM(TRIM(TO_CHAR(NVL(VALOR_IMPUESTO, 0), '99999999990D99'))) AS SUMA_IMPUESTOS
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET DET,
               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IMP
         WHERE DET.DOCUMENTO_ID     = Pn_DocumentoId
           AND DET.ID_DOC_DETALLE   = IMP.DETALLE_DOC_ID;

    Lr_TotalImpuestos C_ObtieneTotalImpuestos%ROWTYPE;
    --Costo: 17
    CURSOR C_GetDocumentXml( Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,                              
                             Cv_DirMatriz DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                             Cv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                             Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                             Cv_ClaveAccesoGen DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE)
    IS
        SELECT  XMLROOT(XMLELEMENT( EVALNAME(DECODE (UPPER(ATDF.CODIGO_TIPO_DOCUMENTO), 'FAC', 'factura', 'FACP', 'factura', 'NC', 'notaCredito')), 
        XMLATTRIBUTES('comprobante' AS "id", '1.0.0' AS "version"), XMLELEMENT("infoTributaria", 
        XMLAGG(XMLForest(EMPDOC.AMBIENTE_ID "ambiente" , '1' "tipoEmision")) , 
        XMLAGG(FNCK_COM_ELECTRONICO.GET_EMPRESA_DATA(IEG.COD_EMPRESA, 'Activo')) , 
        XMLAGG(XMLForest(Cv_ClaveAccesoGen "claveAcceso")) , 
        XMLAGG( XMLForest(LPAD(ATDF.CODIGO_TIPO_COMPROB_SRI, 2, 0) "codDoc", IDFC.ESTABLECIMIENTO "estab", 
        IDFC.EMISION "ptoEmi", 
        IDFC.SECUENCIA "secuencial", 
        FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_DirMatriz, 
                                                       Cv_Validador, 
                                                       UPPER(FNCK_COM_ELECTRONICO.GET_DIRECCION_EMPRESA( IEG.COD_EMPRESA, 
                                                                                                   IDFC.OFICINA_ID, 
                                                                                                   'Activo', 
                                                                                                   'DIR' ))) "dirMatriz" ) )),
                /*Info Documento Factura - Nota Credito*/
                FNCK_COM_ELECTRONICO.GET_INFODOCUMENTOXML(IDFC.ID_DOCUMENTO, 
                IDFC.FE_EMISION, 
                UPPER(TRIM(FNCK_COM_ELECTRONICO.GET_DIRECCION_EMPRESA(IEG.COD_EMPRESA, IDFC.OFICINA_ID, 'Activo', 'SUC'))), 
                ATDF.CODIGO_TIPO_DOCUMENTO, 
                ATI.CODIGO_SRI, 
                IDFC.NUMERO_FACTURA_SRI, 
                UPPER(TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.RAZON_SOCIAL))), 
                UPPER(TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.NOMBRES))), 
                UPPER(TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.APELLIDOS))), 
                IPR.IDENTIFICACION_CLIENTE, 
                IDFC.VALOR_TOTAL, 
                IDFC.SUBTOTAL, 
                IDFC.SUBTOTAL_CERO_IMPUESTO, 
                IDFC.SUBTOTAL_DESCUENTO, 
                IDFC.REFERENCIA_DOCUMENTO_ID,
                IPER.ID_PERSONA_ROL,
                IDFC.DESCUENTO_COMPENSACION,
                IEG.COD_EMPRESA,
                IDFC.PUNTO_ID
                ) ,
                /*Info Documento Factura - Nota Credito*/
                /*DETALLES*/
                XMLELEMENT("detalles", FNCK_COM_ELECTRONICO.COMP_ELEC_DET(Cn_IdDocumento, ATDF.CODIGO_TIPO_DOCUMENTO)),
                /*InfoAdicional*/
                XMLELEMENT( "infoAdicional", 
                /*MAIL*/
                DECODE(NVL(TRIM(FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'MAIL')), NULL), NULL, NULL, 
                XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('EMAILCLIENTE' AS "nombre"), 
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador,
                                                               UPPER(FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'MAIL')) ) ))), 
                /*MAIL*/
                /*DIR CLIENTE*/
                DECODE(NVL(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(TRIM(REPLACE(REPLACE(REPLACE(FNCK_COM_ELECTRONICO.GET_DIRECCION_ENVIO(IDFC.PUNTO_ID), Chr(9), ' '), Chr(10), ' '), Chr(13), ' '))), NULL), NULL, NULL, 
                XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('DIRCLIENTE' AS "nombre"), 
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador,
                                                               FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(UPPER(TRIM (REPLACE (REPLACE (REPLACE 
                                                                (FNCK_COM_ELECTRONICO.GET_DIRECCION_ENVIO(IDFC.PUNTO_ID), Chr(9), ' '), Chr(10), ' '),
                                                                 Chr(13), ' ')))) ) ))), 
                /*FONO*/
                DECODE(NVL(TRIM(FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'FONO')), NULL), NULL, NULL, 
                XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('TELFCLIENTE' AS "nombre"), 
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador,
                                                               FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'FONO') ) ))), 
                /*FONO*/
                /*CIUDAD*/
                DECODE(FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(NULL, IDFC.PUNTO_ID), NULL, NULL, 
                XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('CIUDADCLIENTE' AS "nombre"), 
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador,
                                                               UPPER(FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(NULL, IDFC.PUNTO_ID)) ) ))), 
                /*CIUDAD*/
                /*NUMERO CLIENTE*/
                DECODE(SUBSTR( IDFC.NUMERO_FACTURA_SRI , 9, INSTR( IDFC.NUMERO_FACTURA_SRI, '-') +9), NULL, NULL, 
                XMLAGG( XMLELEMENT("campoAdicional", XMLATTRIBUTES('NUMEROCLIENTE' AS "nombre"), 
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador,
                                                               SUBSTR( IDFC.NUMERO_FACTURA_SRI , 9, INSTR(IDFC.NUMERO_FACTURA_SRI, '-') +9) ) ))), 
                /*NUMERO CLIENTE*/
                /*CONSUMO*/
                FNCK_COM_ELECTRONICO.F_SET_ATTR_CONSUMO_CLIENTE(IEG.COD_EMPRESA,
                                                                IDFC.MES_CONSUMO,
                                                                IDFC.RANGO_CONSUMO,
                                                                IDFC.FE_EMISION,
                                                                ATDF.CODIGO_TIPO_DOCUMENTO,
                                                                IDFC.ANIO_CONSUMO),
                /*CONSUMO*/
                /*LOGIN*/
                XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('LOGINCLIENTE' AS "nombre"), 
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador,
                                                               UPPER(FNCK_COM_ELECTRONICO.GET_LOGIN(IDFC.PUNTO_ID, 'Activo')) ) )), 
                /*LOGIN*/
                /*CONTRATO*/
                XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('CONTRATOCLIENTE' AS "nombre"), 
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador,
                                                               FNCK_COM_ELECTRONICO.GET_NUM_CONTRATO(IPER.ID_PERSONA_ROL, 'Activo') ) )), 


		 /*IDDOCUMENTO*/
                /*FECHAMAXIMAPAGO*/
                XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('FMAXPAGO' AS "nombre"), 
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador,
                                                               to_char(FNCK_COM_ELECTRONICO.F_GET_FECHA_MAXIMA_PAGO(Pn_IdDocumento),
                                                               'DD/MM/YYYY') ) )), 

                /*FORMA DE PAGO*/
                /*CLIENTE*/
                DECODE(FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(IPER.ID_PERSONA_ROL, NULL), NULL, NULL, 
                XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('FPAGOCLIENTE' AS "nombre" ),
                FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                               Cv_Validador, 
                                                              UPPER(FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(IPER.ID_PERSONA_ROL, NULL)) ) ))),
                /*CONTRATO*/
                /*SUBTOTAL_DOS*/
                FNCK_COM_ELECTRONICO.F_SET_ATTR_SUBTOTAL_DOS(IEG.COD_EMPRESA, 
                                                             ATDF.CODIGO_TIPO_DOCUMENTO, 
                                                             IDFC.SUBTOTAL, 
                                                             IDFC.SUBTOTAL_DESCUENTO, 
                                                             IDFC.VALOR_TOTAL, 
                                                             'SUBTOTAL_DOS'),
                /*SUBTOTAL_DOS*/
                /*VALOR_TOTAL*/
                FNCK_COM_ELECTRONICO.F_SET_ATTR_SUBTOTAL_DOS(IEG.COD_EMPRESA, 
                                                             ATDF.CODIGO_TIPO_DOCUMENTO, 
                                                             IDFC.SUBTOTAL, 
                                                             IDFC.SUBTOTAL_DESCUENTO, 
                                                             IDFC.VALOR_TOTAL, 
                                                             'VALOR_TOTAL'),
                /*VALOR_TOTAL*/
                /*NOTIFICACION*/
                FNCK_COM_ELECTRONICO.F_SET_ATTR_SALDO(IEG.COD_EMPRESA, ATDF.CODIGO_TIPO_DOCUMENTO, IDFC.PUNTO_ID, NULL),
                /*NOTIFICACION*/
                /*PAIS*/
                FNCK_COM_ELECTRONICO.F_SET_ATTR_PAIS(IEG.COD_EMPRESA, IPER.ID_PERSONA_ROL, ATDF.CODIGO_TIPO_DOCUMENTO),
                /*PAIS*/
                /*CONTRIBUCION_SOLIDARIA*/
                FNCK_COM_ELECTRONICO.F_SET_ATTR_CONTRIBUCION(IEG.COD_EMPRESA,
                                                             IDFC.PUNTO_ID,
                                                             IPER.ID_PERSONA_ROL,
                                                             IDFC.ID_DOCUMENTO,
                                                             ATDF.CODIGO_TIPO_DOCUMENTO,
                                                             IP.SECTOR_ID,
                                                             IDFC.OFICINA_ID),
                /*CONTRIBUCION_SOLIDARIA*/
                --INFORMACION ADICIONAL
                FNCK_COM_ELECTRONICO.F_SET_ATTR_DET_ADICIONAL(IEG.COD_EMPRESA, ATDF.CODIGO_TIPO_DOCUMENTO)
                )
                /*InfoAdicional*/
                ), VERSION '1.0" encoding="UTF-8', STANDALONE NO) XML,
                REPLACE(UPPER(TRIM(ATDF.NOMBRE_TIPO_DOCUMENTO)), ' ', '_')
                || '_'
                || TRIM(IDFC.NUMERO_FACTURA_SRI)
                || '_'
                || SYSDATE,
                TRIM(TO_CHAR(SYSDATE, 'YYYY')),
                TRIM(TO_CHAR(SYSDATE,'MONTH','NLS_DATE_LANGUAGE=SPANISH')),
                TRIM(TO_CHAR(SYSDATE, 'DD')),
                REPLACE(UPPER(TRIM(ATDF.NOMBRE_TIPO_DOCUMENTO)), ' ', '_'),
                TRIM(IDFC.NUMERO_FACTURA_SRI),
                TRIM(FNCK_COM_ELECTRONICO.GET_DIRECCION_EMPRESA(IEG.COD_EMPRESA, IDFC.OFICINA_ID, 'Activo', 'RUC')),
                --
                IDFC.FE_EMISION,
                TDOC.ID_TIPO_DOC,
                EMPDOC.ID_EMPRESA,
                EMPDOC.AMBIENTE_ID,
                IDFC.VALOR_TOTAL,
                TIDDOC.ID_TIPO_IDENTIFICACION,
                IPR.IDENTIFICACION_CLIENTE,
                CASE 
                WHEN TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.RAZON_SOCIAL)) IS NULL
                THEN TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.NOMBRES)) || ' ' || TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.APELLIDOS))
                ELSE 
                TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.RAZON_SOCIAL))             
                END,                
                NVL(TRIM(FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'MAIL')), NULL),
                NVL(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(TRIM(REPLACE(REPLACE(REPLACE(FNCK_COM_ELECTRONICO.GET_DIRECCION_ENVIO(IDFC.PUNTO_ID), Chr(9), ' '), Chr(10), ' '), Chr(13), ' '))), NULL),
                NVL(TRIM(FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'FONO')), NULL),
                FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(NULL, IDFC.PUNTO_ID),
                SUBSTR( IDFC.NUMERO_FACTURA_SRI , 9, INSTR( IDFC.NUMERO_FACTURA_SRI, '-') +9),
                FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(IPER.ID_PERSONA_ROL, NULL),
                FNCK_COM_ELECTRONICO.GET_LOGIN(IDFC.PUNTO_ID, 'Activo'),
                FNCK_COM_ELECTRONICO.GET_NUM_CONTRATO(IPER.ID_PERSONA_ROL, 'Activo'),
                IDFC.ESTABLECIMIENTO,
                IDFC.EMISION,
                IDFC.SECUENCIA                        

            FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                 DB_COMERCIAL.INFO_PUNTO IP,
                 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                 DB_COMERCIAL.INFO_PERSONA IPR,
                 DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                 DB_GENERAL.ADMI_TIPO_IDENTIFICACION ATI ,
                 DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
                 --
                 DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO TDOC,                 
                 DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG,                    
                 DB_COMPROBANTES.ADMI_EMPRESA EMPDOC,
                 DB_COMPROBANTES.INFO_TIPO_IDENTIFICACION TIDDOC
                 --
            WHERE ATDF.ID_TIPO_DOCUMENTO                     = IDFC.TIPO_DOCUMENTO_ID
                AND LPAD(ATDF.CODIGO_TIPO_COMPROB_SRI, 2, 0) = TDOC.CODIGO  
                AND IDFC.PUNTO_ID                            = IP.ID_PUNTO
                AND IP.PERSONA_EMPRESA_ROL_ID                = IPER.ID_PERSONA_ROL
                AND IPER.PERSONA_ID                          = IPR.ID_PERSONA
                AND NVL(IPR.TIPO_IDENTIFICACION, 'CED')      = ATI.ID_TIPO_IDENTIFICACION
                AND LPAD(ATI.CODIGO_SRI, 2, 0)               = TIDDOC.CODIGO
                AND IOG.ID_OFICINA                           = IDFC.OFICINA_ID                          
                AND IOG.EMPRESA_ID                           = IEG.COD_EMPRESA                               
                AND IDFC.ID_DOCUMENTO                        = Cn_IdDocumento
                AND IEG.PREFIJO                              = EMPDOC.CODIGO
                --
            GROUP BY ATDF.CODIGO_TIPO_DOCUMENTO,
                IDFC.PUNTO_ID,
                IPR.DIRECCION_TRIBUTARIA,
                IDFC.NUMERO_FACTURA_SRI,
                IDFC.FE_EMISION,
                IDFC.MES_CONSUMO,
                IDFC.ANIO_CONSUMO,
                IDFC.RANGO_CONSUMO,
                IDFC.ID_DOCUMENTO,
                IOG.DIRECCION_OFICINA,
                ATI.CODIGO_SRI,
                IPR.RAZON_SOCIAL,
                IPR.NOMBRES,
                IPR.APELLIDOS,
                IPR.IDENTIFICACION_CLIENTE,
                IDFC.VALOR_TOTAL,
                IDFC.SUBTOTAL,
                IDFC.SUBTOTAL_CERO_IMPUESTO,
                IDFC.SUBTOTAL_DESCUENTO,
                IDFC.REFERENCIA_DOCUMENTO_ID,
                ATDF.NOMBRE_TIPO_DOCUMENTO,
                IDFC.OFICINA_ID,
                IP.SECTOR_ID,
                IPER.ID_PERSONA_ROL,
                IDFC.DESCUENTO_COMPENSACION,
                IEG.COD_EMPRESA,
                --
                TO_CHAR(IDFC.FE_EMISION, 'DD/MM/YYYY'),
                TDOC.ID_TIPO_DOC,
                EMPDOC.ID_EMPRESA,
                EMPDOC.AMBIENTE_ID,
                IDFC.VALOR_TOTAL,
                TIDDOC.ID_TIPO_IDENTIFICACION,
                IPR.IDENTIFICACION_CLIENTE,
                CASE 
                WHEN TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.RAZON_SOCIAL)) IS NULL
                THEN TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.NOMBRES)) || ' ' || TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.APELLIDOS))
                ELSE 
                TRIM(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(IPR.RAZON_SOCIAL))             
                END,                
                NVL(TRIM(FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'MAIL')), NULL),
                NVL(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN_CLIENTE(TRIM(REPLACE(REPLACE(REPLACE(FNCK_COM_ELECTRONICO.GET_DIRECCION_ENVIO(IDFC.PUNTO_ID), Chr(9), ' '), Chr(10), ' '), Chr(13), ' '))), NULL),
                NVL(TRIM(FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'FONO')), NULL),
                FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(NULL, IDFC.PUNTO_ID),
                SUBSTR( IDFC.NUMERO_FACTURA_SRI , 9, INSTR( IDFC.NUMERO_FACTURA_SRI, '-') +9),
                FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(IPER.ID_PERSONA_ROL, NULL),
                FNCK_COM_ELECTRONICO.GET_LOGIN(IDFC.PUNTO_ID, 'Activo'),
                FNCK_COM_ELECTRONICO.GET_NUM_CONTRATO(IPER.ID_PERSONA_ROL, 'Activo'),
                IDFC.ESTABLECIMIENTO,
                IDFC.EMISION,
                IDFC.SECUENCIA;
    --
    --Costo: 16
    CURSOR C_GetParametroOrigenDoc(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS  
    SELECT 
    PAD.VALOR1
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAC,
    DB_GENERAL.ADMI_PARAMETRO_DET PAD
    WHERE PAC.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND PAC.ID_PARAMETRO       = PAD.PARAMETRO_ID
    AND PAC.ESTADO             ='Activo'
    AND PAD.ESTADO             ='Activo'
    AND ROWNUM                 = 1;    
    --
    -- CURSOR PARA DETERMINAR SI UN USUARIO EXISTE POR NUMERO DE IDENTIFICACION
    -- Costo: 3
    CURSOR C_GetUsuarioExiste(Cv_Identificacion DB_COMPROBANTES.ADMI_USUARIO.LOGIN%TYPE)
    IS
    SELECT ID_USUARIO FROM DB_COMPROBANTES.ADMI_USUARIO
    WHERE LOGIN = Cv_Identificacion
    AND ROWNUM  = 1;   
    --  
    -- CURSOR PARA DETERMINAR SI UN USUARIO EXISTE POR EMPRESA
    -- Costo: 2
    CURSOR C_GetUsuarioEmpExiste(Cn_IdUsuario DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%TYPE,
    Cn_IdEmpresa  DB_COMPROBANTES.ADMI_EMPRESA.ID_EMPRESA%TYPE)
    IS
    SELECT USUE.ID_USR_EMP FROM  DB_COMPROBANTES.ADMI_USUARIO USU,
    DB_COMPROBANTES.ADMI_USUARIO_EMPRESA USUE
    WHERE 
    USUE.USUARIO_ID     = USU.ID_USUARIO
    AND USUE.EMPRESA_ID = Cn_IdEmpresa
    AND USU.ID_USUARIO  = Cn_IdUsuario
    AND ROWNUM          = 1;
    --
    -- CURSOR PARA DETERMINAR SI SE ACTIVA LA FACTURA POR EL PROCESO OFFLINE
    -- Costo: 3
    CURSOR C_GetParametroActivaFact(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                    Cn_IdEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS  
    SELECT 
    PAD.VALOR1
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAC,
    DB_GENERAL.ADMI_PARAMETRO_DET PAD
    WHERE PAC.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND PAC.ID_PARAMETRO       = PAD.PARAMETRO_ID
    AND PAC.ESTADO             ='Activo'
    AND PAD.ESTADO             ='Activo'
    AND PAD.EMPRESA_COD        = Cn_IdEmpresa
    AND ROWNUM                 = 1;    
    --
    Lv_OrigenDocumento          VARCHAR2(25);
    Lr_CompElectronico          Lr_ComprobanteElectronico    := NULL;    
    Lr_CompInfoDocumento        Lr_InfoDocumento             := NULL;
    Lr_CompAdmiUsuario          Lr_AdmiUsuario               := NULL;
    Lr_CompAdmiUsuarioEmp       Lr_AdmiUsuarioEmpresa        := NULL;
    Lr_CompTotalImpuesto        Lr_TotalImpuesto             := NULL;
    Ln_TotalFacturaXml          NUMBER := 0;
    Ld_FechaEmision             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE;
    Lv_IdTipoDoc                DB_COMPROBANTES.ADMI_TIPO_DOCUMENTO.ID_TIPO_DOC%TYPE;
    Ln_IdEmpresa                DB_COMPROBANTES.ADMI_EMPRESA.ID_EMPRESA%TYPE;
    Ln_AmbienteId               DB_COMPROBANTES.ADMI_EMPRESA.AMBIENTE_ID%TYPE;
    Ln_Valor                    DB_COMPROBANTES.INFO_DOCUMENTO.VALOR%TYPE;
    Ln_IdTipoIdentificacion     DB_COMPROBANTES.INFO_TIPO_IDENTIFICACION.ID_TIPO_IDENTIFICACION%TYPE;
    Lv_IdentificacionCliente    DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE;
    Lv_Nombres                  DB_COMPROBANTES.ADMI_USUARIO.NOMBRES%TYPE;    
    Lv_Email                    DB_COMPROBANTES.ADMI_USUARIO.EMAIL%TYPE;
    Lv_Direccion                DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.DIRECCION%TYPE;
    Lv_Telefono                 DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.TELEFONO%TYPE;
    Lv_Ciudad                   DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.CIUDAD%TYPE;    
    Lv_Numero                   DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.NUMERO%TYPE;
    Lv_FormaPago                DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.FORMAPAGO%TYPE;    
    Lv_Login                    DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.LOGIN%TYPE;     
    Lv_Contrato                 DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.CONTRATO%TYPE;   
    Lv_Establecimiento          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTABLECIMIENTO%TYPE;
    Lv_Emision                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.EMISION%TYPE;
    Lv_Secuencia                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SECUENCIA%TYPE;
    --
    Ln_IdUsuario                DB_COMPROBANTES.ADMI_USUARIO.ID_USUARIO%TYPE:=NULL;  
    Ln_IdUsuarioEmpresa         DB_COMPROBANTES.ADMI_USUARIO_EMPRESA.ID_USR_EMP%TYPE:=NULL;
    Lv_ClaveAcceso              INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE:=NULL;
    Lr_GetUsuarioExiste         C_GetUsuarioExiste%ROWTYPE;
    Lr_GetUsuarioEmpExiste      C_GetUsuarioEmpExiste%ROWTYPE;
    Lv_ClaveAccesoGen           DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE;
    Lv_Password                 DB_COMPROBANTES.ADMI_USUARIO.PASSWORD%TYPE;
    --
    Lv_NumeroFactura            INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE := NULL;
    LXML_Comprobante            XMLTYPE;
    Ln_TotalFactura             NUMBER := 0;
    Lr_InfoDocFinanCabNc        INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocFinanCab          INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_AdmiTipoDocFinanciero    ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
    Lr_AdmiTipoDocFinancieroNc  ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
    Lv_CodTipoDocFinanciero     ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE;
    Lex_Exception EXCEPTION;
    Lr_InfoDocFinanCabHisto DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Lv_UsrDefault           DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE := 'telcos';
    Lv_DirMatriz            DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE           := 'dirMatriz';
    Lv_CampoAdicional       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE           := 'campoAdicional';
    Lv_Validador            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                := 'SUBSTRING';
    Lv_ValidaActivaFact     VARCHAR2(2);
    --
BEGIN
    IF C_GetParametroOrigenDoc%ISOPEN THEN
      --
      CLOSE C_GetParametroOrigenDoc;
      --
    END IF;
    --
    IF C_GetUsuarioExiste%ISOPEN THEN
      --
      CLOSE C_GetUsuarioExiste;
      --
    END IF; 
    --
    IF C_GetUsuarioEmpExiste%ISOPEN THEN
      --
      CLOSE C_GetUsuarioEmpExiste;
      --
    END IF;      
    --
    IF C_GetParametroActivaFact%ISOPEN THEN
      --
      CLOSE C_GetParametroActivaFact;
      --
    END IF;
    --
    OPEN C_GetParametroOrigenDoc('ORIGEN_FACTURACION');
    --
    FETCH C_GetParametroOrigenDoc INTO Lv_OrigenDocumento;
    --
    IF Lv_OrigenDocumento IS NULL THEN
      --
      Pv_MessageError := Pv_MessageError || ' - Error No existe Parametro ORIGEN_FACTURACION que define si es Online/Offline';
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    CLOSE C_GetParametroOrigenDoc;
    --
    Ln_TotalFacturaXml := FNCK_COM_ELECTRONICO.GET_DIFERENCIA_XML(Pn_IdDocumento);  
    --
    Ln_TotalFactura := FNCK_COM_ELECTRONICO.GET_DIFERENCIA_DOC(Pn_IdDocumento);
    --
    IF Ln_TotalFactura = 0 THEN
      --
      Lr_AdmiTipoDocFinanciero := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(Pn_IdTipoDocumento, NULL);
      --
      --Valida si es una nota de credito y realiza la busqueda de su documento relacion
      IF Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO = 'NC' THEN
      --
        Lr_InfoDocFinanCabNc := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento, NULL);
        Lr_InfoDocFinanCab   := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocFinanCabNc.REFERENCIA_DOCUMENTO_ID, NULL);
      --
        Lr_AdmiTipoDocFinancieroNc := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(Lr_InfoDocFinanCab.TIPO_DOCUMENTO_ID, NULL);
        Lv_CodTipoDocFinanciero    := Lr_AdmiTipoDocFinancieroNc.CODIGO_TIPO_DOCUMENTO;
      --
      END IF;
      --
      --Valida que solo se haga comprobante electronico a facturas y notas de credito, las notas de credito 
      --podran ser creadas siempre y cuando su comprobante relacionado sea una factura
      IF Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO IN ('FAC', 'FACP') OR 
         (Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO = 'NC' AND Lv_CodTipoDocFinanciero IN ('FAC', 'FACP') ) THEN
        --
        -- Bloque que se realiza solo por Facturacion ONLINE, se verifica parametro Activo.
        IF Lv_OrigenDocumento ='Online' THEN
          --
          /** Bloque que actualiza la Fecha de Emision del documento cuando se actualiza el comprobante electr�nico y crea un historial en el 
          * documento 
          **/
          IF UPPER(Pv_TipoTransaccion) = 'UPDATE' THEN
            --
            Lr_InfoDocFinanCab := NULL;
            Lr_InfoDocFinanCab := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento, NULL);
            --
            --
            IF Lr_InfoDocFinanCab.ID_DOCUMENTO IS NOT NULL AND Lr_InfoDocFinanCab.ID_DOCUMENTO > 0 THEN
              --
              Lr_InfoDocFinanCab.FE_EMISION := SYSDATE;
              DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento, Lr_InfoDocFinanCab, Pv_MessageError);
              --
              IF TRIM(Pv_MessageError) IS NOT NULL THEN
                --
                Pv_MessageError := Pv_MessageError || ' - Error al actualizar la fecha de emisi�n del documento(' || Pn_IdDocumento || ')';
                --
                RAISE Lex_Exception;
              --
              END IF;
              --
              --
              Lr_InfoDocFinanCabHisto                        := NULL;
              Lr_InfoDocFinanCabHisto.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
              Lr_InfoDocFinanCabHisto.DOCUMENTO_ID           := Lr_InfoDocFinanCab.ID_DOCUMENTO;
              Lr_InfoDocFinanCabHisto.MOTIVO_ID              := NULL;
              Lr_InfoDocFinanCabHisto.FE_CREACION            := SYSDATE;
              Lr_InfoDocFinanCabHisto.USR_CREACION           := NVL(TRIM(Pv_UsrCreacion), Lv_UsrDefault);
              Lr_InfoDocFinanCabHisto.ESTADO                 := Lr_InfoDocFinanCab.ESTADO_IMPRESION_FACT;
              Lr_InfoDocFinanCabHisto.OBSERVACION            := 'Se actualiza fecha de emisi�n del documento por actualizaci�n del comprobante '
                                                              || 'electr�nico';
              DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocFinanCabHisto, Pv_MessageError);
              --
              IF TRIM(Pv_MessageError) IS NOT NULL THEN
                --
                Pv_MessageError := Pv_MessageError || ' - Error al crear el historial del documento(' || Pn_IdDocumento || ')';
                --
                RAISE Lex_Exception;
                --
              END IF;
              --
            END IF;
            --
          END IF;
          /** Fin del Bloque que actualiza la Fecha de Emision del documento cuando se actualiza el comprobante electr�nico y crea un historial en el 
          * documento 
          **/
        --
        END IF;
        -- Fin del Bloque que se realiza solo por Facturacion ONLINE, se verifica parametro Activo.        
        --
        --       
        IF C_GetDocumentXml%ISOPEN THEN
            --
            CLOSE C_GetDocumentXml;
            --
        END IF;
        --        
        IF C_ClaveAcceso%ISOPEN THEN
            --
            CLOSE C_ClaveAcceso;
            --
        END IF;        
        --       
        OPEN C_ClaveAcceso(Pn_IdDocumento);
        --
        FETCH C_ClaveAcceso INTO Lv_ClaveAccesoGen;
        --
        IF Lv_ClaveAccesoGen IS NULL OR Lv_ClaveAccesoGen ='' THEN
            --
            BEGIN
              --
              Pv_MessageError := ' Se trato de hacer un comprobante no permitido IdDocumento: ' || Pn_IdDocumento;
              --
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'CLAVE_ACCESO NO VALIDA', Pv_MessageError);
              --
              EXCEPTION
              WHEN OTHERS THEN
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('COMPROBANTE_NO_PERMITIDO', 'ERROR_INSERT', SQLERRM || ' ' || Pn_IdDocumento);
            --
            END;
            --
        END IF;
        CLOSE C_ClaveAcceso;
        --
         IF UPPER(Pv_TipoTransaccion) = 'UPDATE' THEN
            --
            Lv_ClaveAccesoGen:= NULL;
            IF Lv_OrigenDocumento ='Offline' THEN    
              --SI ES OFFLINE SETEO LA MISMA CLAVE QUE POSEE INFO_DOCUMENTO
              SELECT CLAVE_ACCESO INTO Lv_ClaveAcceso 
              FROM DB_COMPROBANTES.INFO_DOCUMENTO 
              WHERE DOCUMENTO_ID_FINAN = Pn_IdDocumento;
              --
              IF Lv_ClaveAcceso IS NOT NULL THEN
                Lv_ClaveAccesoGen:=Lv_ClaveAcceso;            
              END IF;

               IF Lv_ClaveAccesoGen IS NULL OR Lv_ClaveAccesoGen ='' THEN
               --
                 BEGIN
                   --
                   Pv_MessageError := ' Se trato de hacer un comprobante no permitido IdDocumento: ' || Pn_IdDocumento;
                   --
                   FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'CLAVE_ACCESO NO VALIDA', Pv_MessageError);
                   --
                  EXCEPTION
                  WHEN OTHERS THEN
                  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('COMPROBANTE_NO_PERMITIDO', 'ERROR_INSERT', SQLERRM || ' ' || Pn_IdDocumento);
                  --
                  END;
                END IF;
              --
            END IF;
        END IF;  
        --       
        OPEN C_GetDocumentXml(Pn_IdDocumento, Lv_DirMatriz, Lv_CampoAdicional, Lv_Validador,Lv_ClaveAccesoGen);
        --
        FETCH C_GetDocumentXml
            INTO LXML_Comprobante,
                Pv_NombreComprobante,
                Pv_Anio,
                Pv_Mes,
                Pv_Dia,
                Pv_NombreTipoComprobante,
                Lv_NumeroFactura,
                Pv_RucEmpresa,
                --
                Ld_FechaEmision,
                Lv_IdTipoDoc,
                Ln_IdEmpresa,
                Ln_AmbienteId,
                Ln_Valor,
                Ln_IdTipoIdentificacion,
                Lv_IdentificacionCliente,                
                Lv_Nombres,
                Lv_Email,
                Lv_Direccion,
                Lv_Telefono,
                Lv_Ciudad,
                Lv_Numero,
                Lv_FormaPago,
                Lv_Login,
                Lv_Contrato,
                --
                Lv_Establecimiento,
                Lv_Emision,
                Lv_Secuencia
                --               
                ;
        --
        Pv_NombreComprobante     := TRIM(Pv_NombreComprobante);
        Pv_Anio                  := TRIM(Pv_Anio);
        Pv_Mes                   := TRIM(Pv_Mes);
        Pv_Dia                   := TRIM(Pv_Dia);
        Pv_NombreTipoComprobante := TRIM(Pv_NombreTipoComprobante);
        Lv_NumeroFactura         := TRIM(Lv_NumeroFactura);
        Pv_RucEmpresa            := TRIM(Pv_RucEmpresa);
        --        
        Ld_FechaEmision          := TRIM(Ld_FechaEmision);
        Lv_IdTipoDoc             := TRIM(Lv_IdTipoDoc);
        Ln_IdEmpresa             := TRIM(Ln_IdEmpresa);
        Ln_AmbienteId            := TRIM(Ln_AmbienteId);
        Ln_Valor                 := TRIM(Ln_Valor);
        Ln_IdTipoIdentificacion  := TRIM(Ln_IdTipoIdentificacion);
        Lv_IdentificacionCliente := TRIM(Lv_IdentificacionCliente);
        Lv_Nombres               := TRIM(Lv_Nombres);
        Lv_Email                 := TRIM(Lv_Email);
        Lv_Direccion             := TRIM(Lv_Direccion);
        Lv_Telefono              := TRIM(Lv_Telefono);
        Lv_Ciudad                := TRIM(Lv_Ciudad);
        Lv_Numero                := TRIM(Lv_Numero);
        Lv_FormaPago             := TRIM(Lv_FormaPago);
        Lv_Login                 := TRIM(Lv_Login);
        Lv_Contrato              := TRIM(Lv_Contrato);
        Lv_ClaveAccesoGen        := TRIM(Lv_ClaveAccesoGen);
        Lv_Establecimiento       := TRIM(Lv_Establecimiento);
        Lv_Emision               := TRIM(Lv_Emision);
        Lv_Secuencia             := TRIM(Lv_Secuencia);
        --
        CLOSE C_GetDocumentXml;
        --
        Lr_CompElectronico.NOMBRE_COMPROBANTE        := Pv_NombreComprobante;        
        Lr_CompElectronico.DOCUMENTO_ID              := Pn_IdDocumento;
        Lr_CompElectronico.TIPO_DOCUMENTO_ID         := Pn_IdTipoDocumento;
        Lr_CompElectronico.NUMERO_FACTURA            := Lv_NumeroFactura;
        Lr_CompElectronico.COMPROBANTE_ELECTRONICO   := LXML_Comprobante;
        Lr_CompElectronico.COMPROBANTE_ELECT_DEVUELTO:= NULL;       
        Lr_CompElectronico.ESTADO                    := 9;
        Lr_CompElectronico.DETALLE                   := 'Creado';
        Lr_CompElectronico.RUC                       := Pv_RucEmpresa;
        Lr_CompElectronico.FE_CREACION               := SYSDATE;
        Lr_CompElectronico.FE_MODIFICACION           := NULL;
        Lr_CompElectronico.USR_CREACION              := TRIM(Pv_UsrCreacion);
        Lr_CompElectronico.USR_MODIFICACION          := NULL;
        Lr_CompElectronico.ENVIADO                   := 'N';
        Lr_CompElectronico.NUMERO_ENVIO              := NULL;
        Lr_CompElectronico.LOTE_MASIVO_ID            := 0;

        --SI ES FACT OFFLINE SE REALIZA EL INGRESO DEL ADMI_USUARIO, ADMI_USUARIO_EMPRESA, INFO_DOCUMENTO EN DB_COMPROBANTES        
        IF Lv_OrigenDocumento = 'Offline' THEN               
          --
          --OBTENGO EL PASSWORD DEL USUARIO EN BASE AL NUMERO DE IDENTIFICACION Y LO INSERTO SOLO PARA USUARIOS NUEVOS
          Lv_Password :=FNCK_COM_ELECTRONICO.F_GENERA_PASSWD_SHA256(Lv_IdentificacionCliente);
          --
          Pv_MessageError:='';
          --
          --VERIFICO SI EXISTE EL USUARIO POR NUMERO DE IDENTIFICACION, SI NO EXISTE SE INGRESA
          OPEN C_GetUsuarioExiste(Lv_IdentificacionCliente);
          --
          FETCH C_GetUsuarioExiste INTO Lr_GetUsuarioExiste;
          --        
          IF(C_GetUsuarioExiste%notfound) THEN 
            --
            Ln_IdUsuario                         :=DB_COMPROBANTES.SEQ_ADMI_USUARIO.NEXTVAL;
            Lr_CompAdmiUsuario.ID_USUARIO        :=Ln_IdUsuario;
            Lr_CompAdmiUsuario.LOGIN             :=Lv_IdentificacionCliente;
            Lr_CompAdmiUsuario.NOMBRES           :=Lv_Nombres;
            Lr_CompAdmiUsuario.APELLIDOS         :=NULL;
            Lr_CompAdmiUsuario.EMAIL             :=Lv_Email;
            Lr_CompAdmiUsuario.ADMIN             :='N';
            Lr_CompAdmiUsuario.ESTADO            :='Activo';
            Lr_CompAdmiUsuario.FE_CREACION       :=SYSDATE;
            Lr_CompAdmiUsuario.USR_CREACION      :=TRIM(Pv_UsrCreacion);
            Lr_CompAdmiUsuario.FE_ULT_MOD        :=NULL;
            Lr_CompAdmiUsuario.USR_ULT_MOD       :=NULL;
            Lr_CompAdmiUsuario.IP_CREACION       :=NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
            Lr_CompAdmiUsuario.PASSWORD          :=Lv_Password;
            Lr_CompAdmiUsuario.EMPRESA           :='N';
            Lr_CompAdmiUsuario.LOCALE            :='es_EC';
            Lr_CompAdmiUsuario.EMPRESA_CONSULTA  :='N';
            --
            DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_USUARIO_COMP_ELECT(Lr_CompAdmiUsuario, Pv_MessageError);

          ELSE
             --
             Ln_IdUsuario:=Lr_GetUsuarioExiste.ID_USUARIO;
             --
          END IF;
          --
          CLOSE C_GetUsuarioExiste;          
          --
          IF Pv_MessageError IS NOT NULL OR Pv_MessageError !='' THEN
            --
            BEGIN
              --
              Pv_MessageError := Pv_MessageError || ' Se trato de hacer un comprobante no permitido IdDocumento: ' || Pn_IdDocumento;
              --
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'INGRESO DE ADMI_USUARIO', Pv_MessageError);
              --
              EXCEPTION
              WHEN OTHERS THEN
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('COMPROBANTE_NO_PERMITIDO', 'ERROR_INSERT', SQLERRM || ' ' || Pn_IdDocumento);
            --
            END;
          --
          END IF;
          --
          Pv_MessageError:='';
          --
          --VERIFICO SI EXISTE EL USUARIO CREADO PARA LA EMPRESA ESPECIFICA, SI NO EXISTE SE INSERTA
          OPEN C_GetUsuarioEmpExiste(Ln_IdUsuario, Ln_IdEmpresa);
          --
          FETCH C_GetUsuarioEmpExiste INTO Lr_GetUsuarioEmpExiste;  
          --
          IF(C_GetUsuarioEmpExiste%notfound) THEN 
            --            
            Ln_IdUsuarioEmpresa                        :=DB_COMPROBANTES.SEQ_ADMI_USUARIO_EMPRESA.NEXTVAL;
            Lr_CompAdmiUsuarioEmp.ID_USR_EMP           :=Ln_IdUsuarioEmpresa;
            Lr_CompAdmiUsuarioEmp.USUARIO_ID           :=Ln_IdUsuario;
            Lr_CompAdmiUsuarioEmp.EMPRESA_ID           :=Ln_IdEmpresa;
            Lr_CompAdmiUsuarioEmp.FE_CREACION          :=SYSDATE;
            Lr_CompAdmiUsuarioEmp.USR_CREACION         :=TRIM(Pv_UsrCreacion);
            Lr_CompAdmiUsuarioEmp.FE_ULT_MOD           :=NULL;
            Lr_CompAdmiUsuarioEmp.USR_ULT_MOD          :=NULL;
            Lr_CompAdmiUsuarioEmp.IP_CREACION          :=NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
            Lr_CompAdmiUsuarioEmp.EMAIL                :=Lv_Email;
            Lr_CompAdmiUsuarioEmp.DIRECCION            :=Lv_Direccion;
            Lr_CompAdmiUsuarioEmp.TELEFONO             :=Lv_Telefono;
            Lr_CompAdmiUsuarioEmp.CIUDAD               :=Lv_Ciudad;
            Lr_CompAdmiUsuarioEmp.NUMERO               :=Lv_Numero;
            Lr_CompAdmiUsuarioEmp.FORMAPAGO            :=Lv_FormaPago;
            Lr_CompAdmiUsuarioEmp.LOGIN                :=Lv_Login;
            Lr_CompAdmiUsuarioEmp.CONTRATO             :=Lv_Contrato;
            Lr_CompAdmiUsuarioEmp.PASSWORD             :=Lv_Password;
            Lr_CompAdmiUsuarioEmp.N_CONEXION           :=0;
            Lr_CompAdmiUsuarioEmp.FE_ULT_CONEXION      :=NULL;
            Lr_CompAdmiUsuarioEmp.CAMBIO_CLAVE         :='N';            
            --
            DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_USUARIOEMP_COMP_ELECT(Lr_CompAdmiUsuarioEmp, Pv_MessageError);
            --
          ELSE
             --
             Ln_IdUsuarioEmpresa:=Lr_GetUsuarioEmpExiste.ID_USR_EMP;
             --
          END IF;            
          CLOSE C_GetUsuarioEmpExiste;

          IF Pv_MessageError IS NOT NULL OR Pv_MessageError !='' THEN
            --
            BEGIN
              --
              Pv_MessageError := Pv_MessageError || ' Se trato de hacer un comprobante no permitido IdDocumento: ' || Pn_IdDocumento;
              --
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'INGRESO DE ADMI_USUARIO_EMPRESA', Pv_MessageError);
              --
              EXCEPTION
              WHEN OTHERS THEN
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('COMPROBANTE_NO_PERMITIDO', 'ERROR_INSERT', SQLERRM || ' ' || Pn_IdDocumento);
            --
            END;
            --
          END IF;
          --
          --SETEO CAMPOS PARA INSERTAR EN DB_COMPROBANTES -> INFO_DOCUMENTO
          Lr_CompInfoDocumento.ID_DOCUMENTO              := DB_COMPROBANTES.SEQ_INFO_DOCUMENTO.NEXTVAL;
          Lr_CompInfoDocumento.TIPO_DOC_ID               := Lv_IdTipoDoc;
          Lr_CompInfoDocumento.FORMATO_ID                := 1;
          Lr_CompInfoDocumento.EMPRESA_ID                := Ln_IdEmpresa;
          Lr_CompInfoDocumento.NOMBRE                    := Pv_NombreComprobante;
          Lr_CompInfoDocumento.CLAVE_ACCESO              := Lv_ClaveAccesoGen;
          Lr_CompInfoDocumento.FE_CREACION               := SYSDATE;
          Lr_CompInfoDocumento.USR_CREACION              := TRIM(Pv_UsrCreacion);
          Lr_CompInfoDocumento.FE_ULT_MOD                := NULL;
          Lr_CompInfoDocumento.USR_ULT_MOD               := NULL;
          Lr_CompInfoDocumento.IP_CREACION               := NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1');
          Lr_CompInfoDocumento.ESTABLECIMIENTO           := Lv_Establecimiento;
          Lr_CompInfoDocumento.PUNTO_EMISION             := Lv_Emision;
          Lr_CompInfoDocumento.VALOR                     := Ln_Valor;
          Lr_CompInfoDocumento.ESTADO_DOC_ID             := 12;--Pend Validar XSD
          Lr_CompInfoDocumento.VERSION                   := 1;
          Lr_CompInfoDocumento.SECUENCIAL                := Lv_Secuencia;
          Lr_CompInfoDocumento.FE_RECIBIDO               := SYSDATE;        
          Lr_CompInfoDocumento.TIPO_IDENTIFICACION_ID    := Ln_IdTipoIdentificacion;
          Lr_CompInfoDocumento.IDENTIFICACION            := Lv_IdentificacionCliente;
          Lr_CompInfoDocumento.TIPO_EMISION_ID           := 1;
          Lr_CompInfoDocumento.USUARIO_ID                := Ln_IdUsuario;
          Lr_CompInfoDocumento.LOTEMASIVO_ID             := 0;
          Lr_CompInfoDocumento.XML_ORIGINAL              := DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_XMLBLOG(LXML_Comprobante);
          Lr_CompInfoDocumento.AMBIENTE_ID               := Ln_AmbienteId;
          Lr_CompInfoDocumento.FE_EMISION                := Ld_FechaEmision;
          Lr_CompInfoDocumento.INTENTO_RECEPCION         := 0;
          Lr_CompInfoDocumento.INTENTO_CONSULTA          := 0;
          Lr_CompInfoDocumento.ORIGEN_DOCUMENTO          := Lv_OrigenDocumento;          
          Lr_CompInfoDocumento.DOCUMENTO_ID_FINAN        := Pn_IdDocumento;
        --
        END IF;
        -- FIN DE BLOQUE SI Lv_OrigenDocumento = 'Offline'
        --
        IF UPPER(Pv_TipoTransaccion) = 'INSERT' THEN  
            --
           Lr_CompElectronico.CLAVE_ACCESO              := Lv_ClaveAccesoGen;
           Lr_CompElectronico.FE_AUTORIZACION           := NULL;
           Lr_CompElectronico.NUMERO_AUTORIZACION       := NULL;           
           DB_FINANCIERO.FNCK_COM_ELECTRONICO.INSERT_COMP_ELECTRONICO(Lr_CompElectronico, Pv_MessageError);
           --
           --SI ES OFFLINE migro el comprobante a INFO_DOCUMENTO
           IF Lv_OrigenDocumento ='Offline' THEN 
              --              
              DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_INSERT_INFO_DOCUMENTO(Lr_CompInfoDocumento, Pv_MessageError);
              --            
           END IF;  
           --
        ELSIF UPPER(Pv_TipoTransaccion) = 'UPDATE' THEN
            --
            IF Lv_OrigenDocumento ='Offline' THEN    
              --SI ES OFFLINE SETEO LA MISMA CLAVE QUE POSEE INFO_DOCUMENTO             
              SELECT CLAVE_ACCESO INTO Lv_ClaveAcceso 
              FROM DB_COMPROBANTES.INFO_DOCUMENTO 
              WHERE DOCUMENTO_ID_FINAN = Pn_IdDocumento;
              --
              IF Lv_ClaveAcceso IS NOT NULL THEN
                Lr_CompElectronico.CLAVE_ACCESO :=Lv_ClaveAcceso;            
              END IF;
              --
              --ACTUALIZO INFO_DOCUMENTO
              Lr_CompInfoDocumento.FE_ULT_MOD        := SYSDATE;
              Lr_CompInfoDocumento.USR_ULT_MOD       := TRIM(Pv_UsrCreacion);              
              --
              --SI ES OFFLINE ACTUALIZO EN INFO_DOCUMENTO DE DB_COMPROBANTES
              DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_UPDATE_INFO_DOCUMENTO(Lr_CompInfoDocumento, Pv_MessageError);
              --
            ELSE
              --SI ES ONLINE CLAVE DE ACCESO DEBE SETEARSE EN NULL
              Lr_CompElectronico.CLAVE_ACCESO := NULL;
              --
            END IF;
            Lr_CompElectronico.ESTADO                    := 10;
            Lr_CompElectronico.DETALLE                   := 'Actualizado';
            Lr_CompElectronico.FE_MODIFICACION           := SYSDATE;
            Lr_CompElectronico.USR_MODIFICACION          := TRIM(Pv_UsrCreacion);
            --ACTUALIZO COMPROBANTE ELECTRONICO
            FNCK_COM_ELECTRONICO.UPDATE_COMP_ELECTRONICO(Lr_CompElectronico, Pv_MessageError);
        END IF;
        --
        Pv_MessageError :='';
        --VALIDO XSD
        FNCK_FACTURACION_OFFLINE.P_VALIDA_COMPROBANTE(Pn_IdDocumento,Lv_IdTipoDoc,LXML_Comprobante,Pv_MessageError);
        --
        IF Pv_MessageError IS NOT NULL OR Pv_MessageError !='' THEN
            --
            BEGIN
              --
              Pv_MessageError := Pv_MessageError || ' Se trato de Validar XSD comprobante no permitido IdDocumento: ' || Pn_IdDocumento;
              --
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'P_VALIDA_COMPROBANTE', Pv_MessageError);
              --
              EXCEPTION
              WHEN OTHERS THEN
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('COMPROBANTE_NO_PERMITIDO', 'ERROR_INSERT', SQLERRM || ' ' || Pn_IdDocumento);
            --
            END;
          --
        END IF;
        --
        --
        OPEN C_GetParametroActivaFact('FACTURACION_OFFLINE',Pn_IdEmpresa);
            FETCH C_GetParametroActivaFact INTO Lv_ValidaActivaFact;
        CLOSE C_GetParametroActivaFact;
        --
        IF Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP') AND  Lv_OrigenDocumento = 'Offline' AND Lv_ValidaActivaFact = 'S' THEN 
            DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_UPDATE_INFO_DOC_FIN_CAB(Pn_IdDocumento,'Activo',Pv_MessageError);
        END IF;
        --
        --
        Pclob_Comprobante := REPLACE(REPLACE(LXML_Comprobante.GETCLOBVAL(), '�', 'n'), '�', 'N');
        --
      ELSE
      --
        BEGIN
        --
          Pv_MessageError := 'Se trato de hacer un comprobante no permitido IdDocumento: ' || Pn_IdDocumento;
          --
          IF FNCK_CONSULTS.F_GET_ERROR_REPETIDO(Pv_MessageError) = FALSE THEN
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'COMPROBANTE_NO_PERMITIDO', Pv_MessageError);
          END IF;
          --
          EXCEPTION
          WHEN OTHERS THEN
              FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('COMPROBANTE_NO_PERMITIDO', 'ERROR_INSERT', SQLERRM || ' ' || Pn_IdDocumento);
        --
        END;
      --
      END IF;--Lr_AdmiTipoDocFinanciero
    ELSE            
      --
      BEGIN      
        --     
        Pv_MessageError := 'Los valores de la factura no cuadran ID_DOCUMENTO: ' || Pn_IdDocumento;
        IF FNCK_CONSULTS.F_GET_ERROR_REPETIDO(Pv_MessageError) = FALSE THEN
            --
            FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 'VALOR <> 0', Pv_MessageError);
            Lr_InfoDocFinanCab := NULL;
            Lr_InfoDocFinanCab := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento, NULL);
            Lr_InfoDocFinanCabHisto                        := NULL;
            Lr_InfoDocFinanCabHisto.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
            Lr_InfoDocFinanCabHisto.DOCUMENTO_ID           := Lr_InfoDocFinanCab.ID_DOCUMENTO;
            Lr_InfoDocFinanCabHisto.MOTIVO_ID              := NULL;
            Lr_InfoDocFinanCabHisto.FE_CREACION            := SYSDATE;
            Lr_InfoDocFinanCabHisto.USR_CREACION           := NVL(TRIM(Pv_UsrCreacion), Lv_UsrDefault);
            Lr_InfoDocFinanCabHisto.ESTADO                 := Lr_InfoDocFinanCab.ESTADO_IMPRESION_FACT;
            Lr_InfoDocFinanCabHisto.OBSERVACION            := 'Los valores de la factura no cuadran';            
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocFinanCabHisto, Pv_MessageError);            

            --Se obtiene la suma de los impuestos con la m�scara TRIM(TO_CHAR(NVL(VALOR_IMPUESTO, 0), '99999999990D99')) para cuadrar el documento
            OPEN  C_ObtieneTotalImpuestos (Pn_DocumentoId => Lr_InfoDocFinanCab.ID_DOCUMENTO);
            FETCH C_ObtieneTotalImpuestos INTO Lr_TotalImpuestos;
            CLOSE C_ObtieneTotalImpuestos;

            --Se actualiza el valor SUBTOTAL_CON_IMPUESTO y VALOR_TOTAL.
            Lr_InfoDocFinanCab.SUBTOTAL_CON_IMPUESTO := Lr_TotalImpuestos.SUMA_IMPUESTOS;
            Lr_InfoDocFinanCab.VALOR_TOTAL           := Lr_InfoDocFinanCab.SUBTOTAL - NVL(Lr_InfoDocFinanCab.SUBTOTAL_DESCUENTO, 0)
                                                        + Lr_InfoDocFinanCab.SUBTOTAL_CON_IMPUESTO;
            DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocFinanCab.ID_DOCUMENTO,Lr_InfoDocFinanCab, Pv_MessageError);
            IF Pv_MessageError IS NOT NULL THEN
                RAISE Lex_Exception;
            END IF;

            --Se Crea el historial por el cambio de valores en la cabecera.
            Lr_InfoDocFinanCabHisto                        := NULL;
            Lr_InfoDocFinanCabHisto.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
            Lr_InfoDocFinanCabHisto.DOCUMENTO_ID           := Lr_InfoDocFinanCab.ID_DOCUMENTO;
            Lr_InfoDocFinanCabHisto.MOTIVO_ID              := NULL;
            Lr_InfoDocFinanCabHisto.FE_CREACION            := SYSDATE;
            Lr_InfoDocFinanCabHisto.USR_CREACION           := 'FNCK_COM_ELECTRONICO';
            Lr_InfoDocFinanCabHisto.ESTADO                 := Lr_InfoDocFinanCab.ESTADO_IMPRESION_FACT;
            Lr_InfoDocFinanCabHisto.OBSERVACION            := 'Se realiza el rec�lculo aut�matico de los impuestos para cuadrar el documento.';
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocFinanCabHisto, Pv_MessageError);
            IF Pv_MessageError IS NOT NULL THEN
                RAISE Lex_Exception;
            END IF;
        END IF;

        EXCEPTION
        WHEN OTHERS THEN
            FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('VALOR <> 0', 'ERROR_INSERT', SQLERRM || ' ' || Pn_IdDocumento);
      --
      END;
      --
    END IF;
    --
EXCEPTION
WHEN Lex_Exception THEN
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', 
                                        Pv_MessageError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  --
  --
  IF FNCK_CONSULTS.F_GET_ERROR_REPETIDO(Pv_MessageError) = FALSE THEN
    --
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION_ELECTRONICA', 'FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', Pv_MessageError);
    --
  END IF;
  --
WHEN OTHERS THEN
    Pv_MessageError := Pv_MessageError || ' SQLERRM: ' || SQLERRM || ' ' || Pn_IdDocumento;
    IF FNCK_CONSULTS.F_GET_ERROR_REPETIDO(Pv_MessageError) = FALSE THEN
      FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION_ELECTRONICA', 'FNCK_COM_ELECTRONICO.COMP_ELEC_CAB', Pv_MessageError);
    END IF;
END COMP_ELEC_CAB;
/**/

PROCEDURE UPDATE_COMP_ELECTRONICO
  (
    Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
    Pv_MsnError OUT VARCHAR2
  )
IS
BEGIN
  UPDATE INFO_COMPROBANTE_ELECTRONICO
  SET NOMBRE_COMPROBANTE       = Prf_ComprobanteElectronico.NOMBRE_COMPROBANTE,
    NUMERO_FACTURA_SRI         = Prf_ComprobanteElectronico.NUMERO_FACTURA,
    COMPROBANTE_ELECTRONICO    = Prf_ComprobanteElectronico.COMPROBANTE_ELECTRONICO,
    COMPROBANTE_ELECT_DEVUELTO = Prf_ComprobanteElectronico.COMPROBANTE_ELECT_DEVUELTO,
    CLAVE_ACCESO               = Prf_ComprobanteElectronico.CLAVE_ACCESO,
    ESTADO                     = Prf_ComprobanteElectronico.ESTADO,
    DETALLE                    = Prf_ComprobanteElectronico.DETALLE,
    RUC                        = Prf_ComprobanteElectronico.RUC,
    FE_MODIFICACION            = Prf_ComprobanteElectronico.FE_MODIFICACION,
    USR_MODIFICACION           = Prf_ComprobanteElectronico.USR_MODIFICACION,
    ENVIADO                    = Prf_ComprobanteElectronico.ENVIADO
  WHERE DOCUMENTO_ID           = Prf_ComprobanteElectronico.DOCUMENTO_ID;
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', ' Error en FNCK_COM_ELECTRONICO.UPDATE_COMP_ELECTRONICO', '' || SQLERRM);
  --
END UPDATE_COMP_ELECTRONICO;
--

PROCEDURE P_INSERT_USUARIO_COMP_ELECT(
   Prf_AdmiUsuario IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuario,
   Pv_MsnError OUT VARCHAR2)
IS
BEGIN
  --
  --
 INSERT INTO
 DB_COMPROBANTES.ADMI_USUARIO 
 (
   ID_USUARIO,
   LOGIN,
   NOMBRES,
   APELLIDOS,
   EMAIL,
   ADMIN,
   ESTADO,
   FE_CREACION,
   USR_CREACION,
   FE_ULT_MOD,
   USR_ULT_MOD,
   IP_CREACION,
   PASSWORD,
   EMPRESA,
   LOCALE,
   EMPRESA_CONSULTA) 
VALUES
(
   Prf_AdmiUsuario.ID_USUARIO,
   Prf_AdmiUsuario.LOGIN,
   Prf_AdmiUsuario.NOMBRES,
   Prf_AdmiUsuario.APELLIDOS,
   Prf_AdmiUsuario.EMAIL,
   Prf_AdmiUsuario.ADMIN,
   Prf_AdmiUsuario.ESTADO,
   Prf_AdmiUsuario.FE_CREACION,
   Prf_AdmiUsuario.USR_CREACION,
   Prf_AdmiUsuario.FE_ULT_MOD,
   Prf_AdmiUsuario.USR_ULT_MOD,
   Prf_AdmiUsuario.IP_CREACION,
   Prf_AdmiUsuario.PASSWORD,
   Prf_AdmiUsuario.EMPRESA,
   Prf_AdmiUsuario.LOCALE,
   Prf_AdmiUsuario.EMPRESA_CONSULTA   
);
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := 'Error en P_INSERT_USUARIO_COMP_ELECT - ' || SQLERRM;
  --
END P_INSERT_USUARIO_COMP_ELECT;

PROCEDURE P_INSERT_USUARIOEMP_COMP_ELECT(
   Prf_AdmiUsuarioEmpresa IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_AdmiUsuarioEmpresa,
   Pv_MsnError OUT VARCHAR2)
IS
BEGIN
  --
  --
INSERT INTO
DB_COMPROBANTES.ADMI_USUARIO_EMPRESA 
(
  ID_USR_EMP,
  USUARIO_ID,
  EMPRESA_ID,
  FE_CREACION,
  USR_CREACION,
  FE_ULT_MOD,
  USR_ULT_MOD,
  IP_CREACION,
  EMAIL,
  DIRECCION,
  TELEFONO,
  CIUDAD,
  NUMERO,
  FORMAPAGO,
  LOGIN,
  CONTRATO,
  PASSWORD,
  N_CONEXION,
  FE_ULT_CONEXION,
  CAMBIO_CLAVE
) 
VALUES 
(  
  Prf_AdmiUsuarioEmpresa.ID_USR_EMP,
  Prf_AdmiUsuarioEmpresa.USUARIO_ID,
  Prf_AdmiUsuarioEmpresa.EMPRESA_ID,
  Prf_AdmiUsuarioEmpresa.FE_CREACION,
  Prf_AdmiUsuarioEmpresa.USR_CREACION,
  Prf_AdmiUsuarioEmpresa.FE_ULT_MOD,
  Prf_AdmiUsuarioEmpresa.USR_ULT_MOD,
  Prf_AdmiUsuarioEmpresa.IP_CREACION,
  Prf_AdmiUsuarioEmpresa.EMAIL,
  Prf_AdmiUsuarioEmpresa.DIRECCION,
  Prf_AdmiUsuarioEmpresa.TELEFONO,
  Prf_AdmiUsuarioEmpresa.CIUDAD,
  Prf_AdmiUsuarioEmpresa.NUMERO,
  Prf_AdmiUsuarioEmpresa.FORMAPAGO,
  Prf_AdmiUsuarioEmpresa.LOGIN,
  Prf_AdmiUsuarioEmpresa.CONTRATO,
  Prf_AdmiUsuarioEmpresa.PASSWORD,
  Prf_AdmiUsuarioEmpresa.N_CONEXION,
  Prf_AdmiUsuarioEmpresa.FE_ULT_CONEXION,
  Prf_AdmiUsuarioEmpresa.CAMBIO_CLAVE
);
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := 'Error en P_INSERT_USUARIOEMP_COMP_ELECT - ' || SQLERRM;
  --
END P_INSERT_USUARIOEMP_COMP_ELECT;

PROCEDURE P_INSERT_INFO_DOCUMENTO(
   Prf_InfoDocumento IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento,
   Pv_MsnError OUT VARCHAR2)
IS
BEGIN
  --
  INSERT INTO 
  DB_COMPROBANTES.INFO_DOCUMENTO 
  (
  ID_DOCUMENTO,
  TIPO_DOC_ID,
  FORMATO_ID,
  EMPRESA_ID,
  NOMBRE, 
  FE_CREACION,
  USR_CREACION,
  FE_ULT_MOD,
  USR_ULT_MOD,
  IP_CREACION,
  ESTABLECIMIENTO,
  PUNTO_EMISION,
  VALOR,
  ESTADO_DOC_ID,  
  VERSION,
  SECUENCIAL,
  FE_RECIBIDO,    
  TIPO_IDENTIFICACION_ID,
  IDENTIFICACION,
  TIPO_EMISION_ID,
  USUARIO_ID,
  LOTEMASIVO_ID,    
  XML_ORIGINAL,
  AMBIENTE_ID,
  FE_EMISION,
  INTENTO_RECEPCION,  
  INTENTO_CONSULTA,  
  ORIGEN_DOCUMENTO,
  DOCUMENTO_ID_FINAN,
  CLAVE_ACCESO
  ) 
  VALUES
  (
  Prf_InfoDocumento.ID_DOCUMENTO,
  Prf_InfoDocumento.TIPO_DOC_ID,
  Prf_InfoDocumento.FORMATO_ID,
  Prf_InfoDocumento.EMPRESA_ID,
  Prf_InfoDocumento.NOMBRE,  
  Prf_InfoDocumento.FE_CREACION,
  Prf_InfoDocumento.USR_CREACION,
  Prf_InfoDocumento.FE_ULT_MOD,
  Prf_InfoDocumento.USR_ULT_MOD,
  Prf_InfoDocumento.IP_CREACION,
  Prf_InfoDocumento.ESTABLECIMIENTO,
  Prf_InfoDocumento.PUNTO_EMISION,
  Prf_InfoDocumento.VALOR,
  Prf_InfoDocumento.ESTADO_DOC_ID,
  Prf_InfoDocumento.VERSION,
  Prf_InfoDocumento.SECUENCIAL,
  Prf_InfoDocumento.FE_RECIBIDO,
  Prf_InfoDocumento.TIPO_IDENTIFICACION_ID,
  Prf_InfoDocumento.IDENTIFICACION,
  Prf_InfoDocumento.TIPO_EMISION_ID,
  Prf_InfoDocumento.USUARIO_ID,
  Prf_InfoDocumento.LOTEMASIVO_ID,
  Prf_InfoDocumento.XML_ORIGINAL,  
  Prf_InfoDocumento.AMBIENTE_ID,
  Prf_InfoDocumento.FE_EMISION,
  Prf_InfoDocumento.INTENTO_RECEPCION,
  Prf_InfoDocumento.INTENTO_CONSULTA,
  Prf_InfoDocumento.ORIGEN_DOCUMENTO,
  Prf_InfoDocumento.DOCUMENTO_ID_FINAN,
  Prf_InfoDocumento.CLAVE_ACCESO
  );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := 'Error en P_INSERT_INFO_DOCUMENTO - ' || SQLERRM;
  --
END P_INSERT_INFO_DOCUMENTO;

--
PROCEDURE INSERT_COMP_ELECTRONICO(
    Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
    Pv_MsnError OUT VARCHAR2)
IS
BEGIN
  --
  --
  INSERT
  INTO INFO_COMPROBANTE_ELECTRONICO
    (
      ID_COMP_ELECTRONICO,
      NOMBRE_COMPROBANTE,
      DOCUMENTO_ID,
      TIPO_DOCUMENTO_ID,
      NUMERO_FACTURA_SRI,
      COMPROBANTE_ELECTRONICO,
      COMPROBANTE_ELECT_DEVUELTO,
      FE_AUTORIZACION,
      NUMERO_AUTORIZACION,
      CLAVE_ACCESO,
      ESTADO,
      DETALLE,
      RUC,
      FE_CREACION,
      FE_MODIFICACION,
      USR_CREACION,
      USR_MODIFICACION,
      ENVIADO,
      NUMERO_ENVIO,
      LOTE_MASIVO_ID
    )
    VALUES
    (
      SEQ_INFO_COMP_ELECTRONICO.NEXTVAL,
      Prf_ComprobanteElectronico.NOMBRE_COMPROBANTE,
      Prf_ComprobanteElectronico.DOCUMENTO_ID,
      Prf_ComprobanteElectronico.TIPO_DOCUMENTO_ID,
      Prf_ComprobanteElectronico.NUMERO_FACTURA,
      Prf_ComprobanteElectronico.COMPROBANTE_ELECTRONICO,
      Prf_ComprobanteElectronico.COMPROBANTE_ELECT_DEVUELTO,
      Prf_ComprobanteElectronico.FE_AUTORIZACION,
      Prf_ComprobanteElectronico.NUMERO_AUTORIZACION,
      Prf_ComprobanteElectronico.CLAVE_ACCESO,
      Prf_ComprobanteElectronico.ESTADO,
      Prf_ComprobanteElectronico.DETALLE,
      Prf_ComprobanteElectronico.RUC,
      Prf_ComprobanteElectronico.FE_CREACION,
      Prf_ComprobanteElectronico.FE_MODIFICACION,
      Prf_ComprobanteElectronico.USR_CREACION,
      Prf_ComprobanteElectronico.USR_MODIFICACION,
      Prf_ComprobanteElectronico.ENVIADO,
      Prf_ComprobanteElectronico.NUMERO_ENVIO,
      Prf_ComprobanteElectronico.LOTE_MASIVO_ID
    );
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := 'Error en INSERT_COMP_ELECTRONICO - ' || SQLERRM;
  --
END INSERT_COMP_ELECTRONICO;
--

PROCEDURE P_UPDATE_INFO_DOCUMENTO
  (
    Prf_InfoDocumento IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento,
    Pv_MsnError OUT VARCHAR2
  )
IS
BEGIN
  UPDATE DB_COMPROBANTES.INFO_DOCUMENTO
  SET      
     TIPO_DOC_ID            = Prf_InfoDocumento.TIPO_DOC_ID,
     EMPRESA_ID             = Prf_InfoDocumento.EMPRESA_ID,
     NOMBRE                 = Prf_InfoDocumento.NOMBRE,
     FE_ULT_MOD             = Prf_InfoDocumento.FE_ULT_MOD,
     USR_ULT_MOD            = Prf_InfoDocumento.USR_ULT_MOD,
     ESTABLECIMIENTO        = Prf_InfoDocumento.ESTABLECIMIENTO,
     PUNTO_EMISION          = Prf_InfoDocumento.PUNTO_EMISION,
     VALOR                  = Prf_InfoDocumento.VALOR,
     ESTADO_DOC_ID          = Prf_InfoDocumento.ESTADO_DOC_ID,
     SECUENCIAL             = Prf_InfoDocumento.SECUENCIAL,
     TIPO_IDENTIFICACION_ID = Prf_InfoDocumento.TIPO_IDENTIFICACION_ID,
     IDENTIFICACION         = Prf_InfoDocumento.IDENTIFICACION,
     USUARIO_ID             = Prf_InfoDocumento.USUARIO_ID,
     XML_ORIGINAL           = Prf_InfoDocumento.XML_ORIGINAL,
     FE_EMISION             = Prf_InfoDocumento.FE_EMISION,
     ORIGEN_DOCUMENTO       = Prf_InfoDocumento.ORIGEN_DOCUMENTO
   WHERE DOCUMENTO_ID_FINAN = Prf_InfoDocumento.DOCUMENTO_ID_FINAN ;

EXCEPTION
WHEN OTHERS THEN
  --ROLLBACK;
  Pv_MsnError:=' Error en FNCK_COM_ELECTRONICO.P_UPDATE_INFO_DOCUMENTO' || SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', ' Error en FNCK_COM_ELECTRONICO.P_UPDATE_INFO_DOCUMENTO', '' || SQLERRM);
  --
END P_UPDATE_INFO_DOCUMENTO;

--
FUNCTION F_XMLBLOG(Fv_ComprobanteElectronico INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECTRONICO%TYPE)
    RETURN BLOB
IS 
  Ln_DestOffset  NUMBER := 1;
  Ln_SrcOffset   NUMBER := 1;
  Ln_LangContext NUMBER := dbms_lob.default_lang_ctx;
  Ln_Warning      NUMBER;
  Lclob          clob := 'xml';  
  Lv_XmlOriginal DB_COMPROBANTES.INFO_DOCUMENTO.XML_ORIGINAL%TYPE;
BEGIN

 SYS.DBMS_LOB.FREETEMPORARY(Lclob);

 SYS.DBMS_LOB.CREATETEMPORARY(Lclob, TRUE);

 SYS.DBMS_LOB.APPEND(Lclob,Fv_ComprobanteElectronico.getclobval() );
 SYS.DBMS_LOB.CREATETEMPORARY(Lv_XmlOriginal, TRUE);
 SYS.DBMS_LOB.CONVERTTOBLOB(dest_lob     => Lv_XmlOriginal,
                            src_clob     => Lclob,
                            amount        => dbms_lob.lobmaxsize,
                            dest_offset   => Ln_DestOffset,
                            src_offset    => Ln_SrcOffset,
                            blob_csid     => nls_charset_id('AL32UTF8'),
                            lang_context  => Ln_LangContext,
                            warning       => Ln_Warning);
  RETURN Lv_XmlOriginal;                     
    --
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.F_XMLBLOG', SQLERRM);
END F_XMLBLOG;

/*
 *IMPUESTOS_DET, Obtiene los detalles de una factura con su base imponible e impuestos
 *
 * @author Alexander Samaniego <awsamaniego@telconet.ec>
 * @version 1.1 04-07-2016 Se suma ice en los detalles con iba para la base imponible
 * 
 * @author Gina Villalba <gvillalba@telconet.ec>
 * @version 1.2 05-07-2016 Se agrega el TRUNC para limitar la cantidad de caracteres a presentar
 *
 * @author Gina Villalba <gvillalba@telconet.ec>
 * @version 1.2 07-07-2016 Se permite el redondeo de los impuesto por validacion de comprobantes
 * @since 1.0
*/
FUNCTION IMPUESTOS_DET(Fn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
                       Fd_TotalSinIMpuestos INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE )
    RETURN XMLTYPE
IS
    /**/
    CURSOR C_GetDetImpuestosXMLImpNull(Cd_TotalSinIMpuestos INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE)
    IS
        /**/
        SELECT  XMLAGG(XMLELEMENT("impuesto", 
        XMLForest(2 "codigo", 0 "codigoPorcentaje", 0 "tarifa", 
        TRIM(TO_CHAR(NVL(Cd_TotalSinIMpuestos, 0),'99999999990D99')) "baseImponible", TO_CHAR(0.00, '0D00') "valor")))
            FROM DUAL;
    /**/
    CURSOR C_GetDetImpuestosXML(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE, 
                                Cd_TotalSinIMpuestos INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE)
    IS
        SELECT  XMLAGG( XMLELEMENT("impuesto", 
        XMLForest( AI.CODIGO_SRI "codigo", AI.CODIGO_TARIFA "codigoPorcentaje", 
        NVL(AI.PORCENTAJE_IMPUESTO, 0) "tarifa", 
        TRIM(TO_CHAR(NVL(Cd_TotalSinIMpuestos, 0) + NVL(FNCK_COM_ELECTRONICO.F_SUM_IMPUESTO_ICE_DET(Cn_IdDocDetalle, AI.CODIGO_SRI), 0) ,'99999999990D99')) "baseImponible", 
        TRIM(TO_CHAR(NVL(IDFI.VALOR_IMPUESTO, 0), '99999999990D99')  ) "valor")))
            FROM INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
                INFO_DOCUMENTO_FINANCIERO_DET IDFD,
                ADMI_IMPUESTO AI
            WHERE IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
                AND AI.ID_IMPUESTO       = IDFI.IMPUESTO_ID
                AND IDFD.ID_DOC_DETALLE  = Cn_IdDocDetalle;
    /**/
    LXML_DetImpuestos XMLTYPE;
    /**/
BEGIN
    --
    IF C_GetDetImpuestosXML%ISOPEN THEN
        --
        CLOSE C_GetDetImpuestosXML;
        --
    END IF;
    --
    OPEN C_GetDetImpuestosXML(Fn_IdDocDetalle, Fd_TotalSinIMpuestos);
    --
    FETCH C_GetDetImpuestosXML INTO LXML_DetImpuestos;
    --
    IF C_GetDetImpuestosXML%ISOPEN THEN
        --
        CLOSE C_GetDetImpuestosXML;
        --
    END IF;
    --
    IF LXML_DetImpuestos IS NULL THEN
        --
        LXML_DetImpuestos := NULL;
        --
        IF C_GetDetImpuestosXMLImpNull%ISOPEN THEN
            --
            CLOSE C_GetDetImpuestosXMLImpNull;
            --
        END IF;
        --
        OPEN C_GetDetImpuestosXMLImpNull(Fd_TotalSinIMpuestos);
        --
        FETCH C_GetDetImpuestosXMLImpNull INTO LXML_DetImpuestos;
        --
        IF C_GetDetImpuestosXMLImpNull%ISOPEN THEN
            --
            CLOSE C_GetDetImpuestosXMLImpNull;
            --
        END IF;
        --
    END IF;
    --
    RETURN LXML_DetImpuestos;
    --
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.IMPUESTOS_DET', SQLERRM);
END IMPUESTOS_DET;
/**/
/**/
  FUNCTION IMPUESTOS_CAB(
      Fn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fd_TotalSinIMpuestos INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE)
    RETURN XMLTYPE
  IS
    --
    CURSOR C_GetTotalConImpuestos(Cxml_CabImpuestosIvaIce XMLTYPE, Cxml_CabImpuestosSinImpuestos XMLTYPE)
    IS
      SELECT XMLELEMENT("totalConImpuestos", Cxml_CabImpuestosIvaIce, Cxml_CabImpuestosSinImpuestos )
      FROM DUAL;
    --
    CURSOR C_GetDetImpuestosXMLImpNull(Cd_BaseImponible DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE, 
                                       Cv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE, 
                                       Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    IS
      --
      SELECT XMLAGG(XMLELEMENT("totalImpuesto", XMLForest(
        (SELECT AI.CODIGO_SRI
        FROM DB_GENERAL.ADMI_IMPUESTO AI
        WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
        AND ESTADO          = Cv_EstadoActivo
        ) "codigo",
      (SELECT AI.CODIGO_TARIFA
      FROM DB_GENERAL.ADMI_IMPUESTO AI
      WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
      AND ESTADO          = Cv_EstadoActivo
      ) "codigoPorcentaje", TRIM(TO_CHAR(NVL(Cd_BaseImponible, 0),'99999999990D99')) "baseImponible", TO_CHAR(0.00, '0D00') "valor" )))
      FROM DUAL;
      --
      CURSOR C_GetDetImpuestosXML(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
      IS
        SELECT XMLAGG( 
                XMLELEMENT("totalImpuesto", 
                    XMLForest( AI.CODIGO_SRI "codigo", 
                               AI.CODIGO_TARIFA "codigoPorcentaje", 
                               TRIM(TO_CHAR(NVL( SUM((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) 
                                                      - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0)), 0) 
                                                 + NVL(FNCK_COM_ELECTRONICO.F_SUM_IMPUESTO_ICE_CAB(Cn_IdDocumento, AI.CODIGO_SRI), 0), 
                                            '99999999990D99')) "baseImponible", 
                               TRIM(TO_CHAR(SUM(NVL(IDFI.VALOR_IMPUESTO, 0)),'99999999990D99')) "valor") ) )
        FROM INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
          INFO_DOCUMENTO_FINANCIERO_DET IDFD,
          ADMI_IMPUESTO AI
        WHERE IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
        AND AI.ID_IMPUESTO        = IDFI.IMPUESTO_ID
        AND IDFD.DOCUMENTO_ID     = Cn_IdDocumento
        GROUP BY AI.CODIGO_SRI,
          AI.CODIGO_TARIFA,
          AI.TIPO_IMPUESTO,
          AI.PORCENTAJE_IMPUESTO;
      --
      CURSOR C_GetTotalDetallesSinImpXML(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
                                         Cv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE, 
                                         Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
      IS
        SELECT XMLAGG( XMLELEMENT("totalImpuesto", XMLForest(
          (SELECT TRIM(TO_CHAR(NVL(AI.CODIGO_SRI, 0),'9999'))
          FROM DB_GENERAL.ADMI_IMPUESTO AI
          WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
          AND ESTADO          = Cv_EstadoActivo
          ) "codigo",
        (SELECT TRIM(TO_CHAR(NVL(AI.CODIGO_TARIFA, 0),'9999'))
        FROM DB_GENERAL.ADMI_IMPUESTO AI
        WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
        AND ESTADO          = Cv_EstadoActivo
        ) "codigoPorcentaje", 
        TRIM(TO_CHAR(NVL( SUM((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0)), 0), 
                     '99999999990D99') ) "baseImponible", 
        TRIM(TO_CHAR(0.00, '0D00')) "valor")))
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
        LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI
        ON IDFI.DETALLE_DOC_ID  = IDFD.ID_DOC_DETALLE
        WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento
        AND IDFI.ID_DOC_IMP    IS NULL
        GROUP BY IDFD.DOCUMENTO_ID;
        --
        Lxml_TotalConImpuestos XMLTYPE;
        Lxml_CabImpuestosIvaIce XMLTYPE;
        Lxml_CabImpuestosSinImpuestos XMLTYPE;
        Lv_BanderaCalcularSinImpuesto VARCHAR2(2)                   := 'S';
        Lv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE        := 'Activo';
        Lv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := 'IVA_CERO';
        --
      BEGIN
        --
        IF C_GetDetImpuestosXML%ISOPEN THEN
          --
          CLOSE C_GetDetImpuestosXML;
          --
        END IF;
        --
        OPEN C_GetDetImpuestosXML(Fn_IdDocumento);
        --
        FETCH C_GetDetImpuestosXML INTO Lxml_CabImpuestosIvaIce;
        --
        IF C_GetDetImpuestosXML%ISOPEN THEN
          --
          CLOSE C_GetDetImpuestosXML;
          --
        END IF;
        --
        --Se verifica si existen detalles con impuestos del IVA o del ICE para verificar si la factura tiene detalles adicionales sin impuestos
        IF Lxml_CabImpuestosIvaIce IS NOT NULL THEN
          --
          Lv_BanderaCalcularSinImpuesto := 'N';
          --
          IF C_GetTotalDetallesSinImpXML%ISOPEN THEN
            --
            CLOSE C_GetTotalDetallesSinImpXML;
            --
          END IF;
          --
          OPEN C_GetTotalDetallesSinImpXML(Fn_IdDocumento, Lv_EstadoActivo, Lv_TipoImpuesto);
          --
          FETCH C_GetTotalDetallesSinImpXML INTO Lxml_CabImpuestosSinImpuestos;
          --
          IF C_GetTotalDetallesSinImpXML%ISOPEN THEN
            --
            CLOSE C_GetTotalDetallesSinImpXML;
            --
          END IF;
          --
        END IF;
        --
        --SOLO ingresar� aqu� cuando la factura tenga todos sus detalles sin impuestos 
        IF Lxml_CabImpuestosIvaIce IS NULL AND Lv_BanderaCalcularSinImpuesto = 'S' THEN
          --
          IF C_GetDetImpuestosXMLImpNull%ISOPEN THEN
            --
            CLOSE C_GetDetImpuestosXMLImpNull;
            --
          END IF;
          --
          OPEN C_GetDetImpuestosXMLImpNull(Fd_TotalSinIMpuestos, Lv_EstadoActivo, Lv_TipoImpuesto);
          --
          FETCH C_GetDetImpuestosXMLImpNull INTO Lxml_CabImpuestosIvaIce;
          --
          IF C_GetDetImpuestosXMLImpNull%ISOPEN THEN
            --
            CLOSE C_GetDetImpuestosXMLImpNull;
            --
          END IF;
          --
        END IF;
        --
        --
        IF Lxml_CabImpuestosIvaIce IS NOT NULL OR Lxml_CabImpuestosSinImpuestos IS NOT NULL THEN
          --
          IF C_GetTotalConImpuestos%ISOPEN THEN
            --
            CLOSE C_GetTotalConImpuestos;
            --
          END IF;
          --
          OPEN C_GetTotalConImpuestos(Lxml_CabImpuestosIvaIce, Lxml_CabImpuestosSinImpuestos);
          --
          FETCH C_GetTotalConImpuestos INTO Lxml_TotalConImpuestos;
          --
          IF C_GetTotalConImpuestos%ISOPEN THEN
            --
            CLOSE C_GetTotalConImpuestos;
            --
          END IF;
          --
        END IF;
        --
        --
        RETURN Lxml_TotalConImpuestos;
        --
      EXCEPTION
      WHEN OTHERS THEN
        --
        Lxml_TotalConImpuestos := NULL;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_COM_ELECTRONICO.IMPUESTOS_CAB', 
                                              'No se pudo obtener el tag de totalConImpuestos del documento ('|| Fn_IdDocumento || ') - ' || SQLCODE
                                              || ' -ERROR- ' || SQLERRM, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
        FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.IMPUESTOS_CAB', SQLERRM);
        --
      END IMPUESTOS_CAB;
--
--
FUNCTION COMP_ELEC_DET(
    Fn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_CodTipoDocumento ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetDocumentoDetXML(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
                              Cv_CodTipoDocumento VARCHAR2,
                              Cv_DetalleDescripcion DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                              Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                              Cv_PrefijoEmpresa VARCHAR2)
  IS
    SELECT XMLAGG( XMLELEMENT("detalle", XMLForest((
      CASE
        WHEN IDFD.PLAN_ID IS NULL
        OR IDFD.PLAN_ID    = 0
        THEN
          (SELECT NVL(SUBSTR(UPPER(AP.CODIGO_PRODUCTO), 1, 25), 'CDDG')
          FROM ADMI_PRODUCTO AP
          WHERE AP.ID_PRODUCTO = IDFD.PRODUCTO_ID
          )
      WHEN IDFD.PRODUCTO_ID IS NULL
      OR IDFD.PRODUCTO_ID    = 0
      THEN
        (SELECT NVL(SUBSTR(UPPER(IPC.CODIGO_PLAN), 1, 25), 'CDDG')
        FROM INFO_PLAN_CAB IPC
        WHERE IPC.ID_PLAN = IDFD.PLAN_ID
        )
    END) AS EVALNAME(Cv_CodTipoDocumento), ( FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_DetalleDescripcion, Cv_Validador, 
         UPPER(FNCK_COM_ELECTRONICO.F_GET_VARCHAR_VALID_XML_VALUE( FNCK_COM_ELECTRONICO.F_SPLIT_DESCRIPCION_DET(
               FNCK_COM_ELECTRONICO.F_GET_DESCRIPCION_DET( IDFD.ID_DOC_DETALLE ,Cv_PrefijoEmpresa ) ) ) ) ) ) "descripcion",
         IDFD.CANTIDAD "cantidad", TRIM(TO_CHAR(TRUNC(NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0), 2),'99999999990D99')) "precioUnitario", 
         TRIM(TO_CHAR(TRUNC(NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0), 2), '99999999990D99')) "descuento", 
         TRIM(TO_CHAR(TRUNC(((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0)), 2), 
              '99999999990D99')) "precioTotalSinImpuesto"), 
         XMLFOREST(FNCK_COM_ELECTRONICO.IMPUESTOS_DET(IDFD.ID_DOC_DETALLE, ((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) 
                   - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0))) "impuestos") ) )
    FROM INFO_DOCUMENTO_FINANCIERO_DET IDFD
    WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento;
  --
  CURSOR C_GetDocumentoDetDescripXML(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
                                     Cv_CodTipoDocumento VARCHAR2,
                                     Cv_DetalleDescripcion DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                     Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
  IS
    SELECT XMLAGG( XMLELEMENT("detalle", XMLForest((
      CASE
        WHEN IDFD.PLAN_ID IS NULL
        OR IDFD.PLAN_ID    = 0
        THEN
          (SELECT NVL(SUBSTR(UPPER(AP.CODIGO_PRODUCTO), 1, 25), 'CDDG')
          FROM ADMI_PRODUCTO AP
          WHERE AP.ID_PRODUCTO = IDFD.PRODUCTO_ID
          )
      WHEN IDFD.PRODUCTO_ID IS NULL
      OR IDFD.PRODUCTO_ID    = 0
      THEN
        (SELECT NVL(SUBSTR(UPPER(IPC.CODIGO_PLAN), 1, 25), 'CDDG')
        FROM INFO_PLAN_CAB IPC
        WHERE IPC.ID_PLAN = IDFD.PLAN_ID
        )
    END) AS EVALNAME(Cv_CodTipoDocumento), 
     (NVL(UPPER(FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML(Cv_DetalleDescripcion, 
                                                             Cv_Validador, 
                    FNCK_COM_ELECTRONICO.F_SPLIT_DESCRIPCION_DET(FNCK_COM_ELECTRONICO.F_GET_VARCHAR_VALID_XML_VALUE(
                                                             FNCK_COM_ELECTRONICO.GET_LONG_TO_VARCHAR(IDFD.ROWID))))),
      CASE
        WHEN IDFD.PLAN_ID IS NULL
        OR IDFD.PLAN_ID    = 0
        THEN
          (SELECT FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_DetalleDescripcion, Cv_Validador, UPPER(AP.DESCRIPCION_PRODUCTO) )
          FROM ADMI_PRODUCTO AP
          WHERE AP.ID_PRODUCTO = IDFD.PRODUCTO_ID
          )
        WHEN IDFD.PRODUCTO_ID IS NULL
        OR IDFD.PRODUCTO_ID    = 0
        THEN
          (SELECT FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_DetalleDescripcion, Cv_Validador, UPPER(IPC.NOMBRE_PLAN) )
          FROM INFO_PLAN_CAB IPC
          WHERE IPC.ID_PLAN = IDFD.PLAN_ID
          )
      END )) "descripcion", IDFD.CANTIDAD "cantidad", 
      TRIM(TO_CHAR(TRUNC(NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0), 2), '99999999990D99')) "precioUnitario", 
      TRIM(TO_CHAR(TRUNC(NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0), 2), '99999999990D99')) "descuento", 
      TRIM(TO_CHAR(TRUNC(((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0)), 2), 
           '99999999990D99')) "precioTotalSinImpuesto"), 
      XMLFOREST(FNCK_COM_ELECTRONICO.IMPUESTOS_DET(IDFD.ID_DOC_DETALLE, ((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) - 
                NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0))) "impuestos") ) )
    FROM INFO_DOCUMENTO_FINANCIERO_DET IDFD
    WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento;
  --
  LXML_InfoDocumentoDet XMLTYPE;
  Lv_CodDocumento VARCHAR2(100);
  Cr_InfoDocumento SYS_REFCURSOR;
  LrInfoDocumento FNKG_CONTABILIZAR_FACT_NC.TypeInfoDocumento;
  Lv_DetalleDescripcion DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'detallesDetalleDescripcion';
  Lv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE               := 'SUBSTRING';
  Lv_PrefijoEmpresa VARCHAR2(2)                                        := '';
  --
    BEGIN
        --
        IF UPPER(Fv_CodTipoDocumento) = 'FAC' OR UPPER(Fv_CodTipoDocumento) = 'FACP' THEN
            --
            Lv_CodDocumento := 'codigoPrincipal';
            --
        ELSIF UPPER(Fv_CodTipoDocumento) = 'NC' THEN
            --
            Lv_CodDocumento := 'codigoInterno';
            --
        END IF;
        --
        FNKG_CONTABILIZAR_FACT_NC.O_OBTENER_DATA_DOCUMENTO(Fn_IdDocumento,Cr_InfoDocumento);
        --
        FETCH Cr_InfoDocumento INTO LrInfoDocumento;
        --
        IF LrInfoDocumento.PREFIJO='MD'THEN
          --
          IF C_GetDocumentoDetXML%ISOPEN THEN
              --
              CLOSE C_GetDocumentoDetXML;
              --
          END IF;
          --
          Lv_PrefijoEmpresa := LrInfoDocumento.PREFIJO;
          --
          OPEN C_GetDocumentoDetXML(Fn_IdDocumento, Lv_CodDocumento, Lv_DetalleDescripcion, Lv_Validador, Lv_PrefijoEmpresa );
          --
          FETCH C_GetDocumentoDetXML INTO LXML_InfoDocumentoDet;
          --
          CLOSE C_GetDocumentoDetXML;
          --
        ELSE
          --
          IF C_GetDocumentoDetDescripXML%ISOPEN THEN
              --
              CLOSE C_GetDocumentoDetDescripXML;
              --
          END IF;
          --
          OPEN C_GetDocumentoDetDescripXML(Fn_IdDocumento, Lv_CodDocumento, Lv_DetalleDescripcion, Lv_Validador);
          --
          FETCH C_GetDocumentoDetDescripXML INTO LXML_InfoDocumentoDet;
          --
          CLOSE C_GetDocumentoDetDescripXML;
          --
        END IF;  
        --
        RETURN LXML_InfoDocumentoDet;
        --
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.COMP_ELEC_DET', SQLERRM);
END COMP_ELEC_DET;
    /**/
/**
  * Documentacion para la funcion GET_ADITIONAL_DATA_BYPUNTO
  * Funcion que retorna los correos o telefonos del cliente concatenados por un ;
  * Fn_IdPunto  IN INFO_PUNTO.ID_PUNTO%TYPE,        Recibe el Id del punto
  * Fv_TipoData IN ADMI_FORMA_CONTACTO.CODIGO%TYPE  Recibe el codigo de forma contacto a buscar FONO o MAIL
  * Retorna:
  * En tipo varcahar2 los correos o telefonos de cliente concatenados por un ;
  *
  * Para la empresa TN, se hace el query de los contactos por puntos, adicional se verifica la longitud del 
  * campo de retorno de 300 caracteres
  * Se presentan unicamente 5 correos electronicos por punto debido a que se trunca de manera incorrecta los correos
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.1 24-06-2016
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  *
  *
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.2 04-07-2016 Se mofica cursores para obtener las formas de contacto para la empresa TN
  *                         El orden sera el siguiente, obtener las formas contacto de un tipo de contactos financiero
  *                         primero el la INFO_PUNTO_CONTACTO y luego en la INFO_PERSONA_CONTACTO
  *
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.3 05-07-2016 Se a�adio la concatenacion de un separador 
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.4 22-08-2016 Se modifica la validacion del TDL mediante: 
  *                         curl -s http://data.iana.org/TLD/tlds-alpha-by-domain.txt | tail -n+2 | wc -L
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.5 14-06-2017 Se agrega cursor para obtener la informacion del correo electronico y telefono de la 
  *                         INFO_PUNTO_DATO_ADICIONAL exclusivamente para .
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.6 08-07-2020 Se trunca consulta de data en query principal de cursores que obtienen informaci�n de formas de contacto.
  *
  * @author Gustavo Narea <gnarea@telconet.ec>
  * @version 1.7 17-11-021 Se limita el listado de contactos al traerlo de base.
  *
  * @since 1.1  
  */
FUNCTION GET_ADITIONAL_DATA_BYPUNTO(
    Fn_IdPunto  IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_TipoData IN ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_DatoContacto(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_TipoData ADMI_FORMA_CONTACTO.CODIGO%TYPE, Cn_NumeroTruncar NUMBER)
  IS
  WITH FORMA_CONTACTO_MAIL AS
    (SELECT FNCK_CONSULTS.F_TRUNC_BY_DELIMETER(LISTAGG(
      CASE Cv_TipoData
        WHEN 'MAIL'
        THEN NVL2(EMAIL_ENVIO, EMAIL_ENVIO, NULL)
        WHEN 'FONO'
        THEN NVL2(TELEFONO_ENVIO, TELEFONO_ENVIO, NULL)
      END, ';') WITHIN GROUP (
    ORDER BY
      CASE Cv_TipoData
        WHEN 'MAIL'
        THEN EMAIL_ENVIO
        WHEN 'FONO'
        THEN TELEFONO_ENVIO
      END), ';', Cn_NumeroTruncar) CONTACTO
    FROM INFO_PUNTO_DATO_ADICIONAL
    WHERE PUNTO_ID = Cn_IdPunto
  UNION
  --
  SELECT FNCK_CONSULTS.F_TRUNC_BY_DELIMETER(LISTAGG(NVL2(IPFC.VALOR, IPFC.VALOR, NULL), ';') WITHIN GROUP (
  ORDER BY NVL2(IPFC.VALOR, IPFC.VALOR, NULL)), ';', Cn_NumeroTruncar) CONTACTO
  FROM INFO_PUNTO IP,
    INFO_PERSONA_EMPRESA_ROL IPER,
    INFO_PERSONA IPR,
    INFO_PERSONA_FORMA_CONTACTO IPFC,
    ADMI_FORMA_CONTACTO AFC
  WHERE IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
  AND IPER.PERSONA_ID             = IPR.ID_PERSONA
  AND IPR.ID_PERSONA              = IPFC.PERSONA_ID
  AND IPFC.FORMA_CONTACTO_ID      = AFC.ID_FORMA_CONTACTO
  AND IPFC.ESTADO                 = 'Activo'
  AND AFC.ESTADO                  = 'Activo'
  AND AFC.CODIGO                 IN
    (SELECT CODIGO
    FROM ADMI_FORMA_CONTACTO
    WHERE DESCRIPCION_FORMA_CONTACTO LIKE
      CASE Cv_TipoData
        WHEN 'MAIL'
        THEN 'Correo%'
        WHEN 'FONO'
        THEN 'Telefono%'
      END
    )
  AND IP.ID_PUNTO = Cn_IdPunto
  UNION
  SELECT FNCK_CONSULTS.F_TRUNC_BY_DELIMETER(IPFC.VALOR, ';', Cn_NumeroTruncar) CONTACTO
  FROM INFO_PUNTO_FORMA_CONTACTO IPFC,
    ADMI_FORMA_CONTACTO AFC
  WHERE IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
  AND AFC.CODIGO              IN
    (SELECT CODIGO
    FROM ADMI_FORMA_CONTACTO
    WHERE DESCRIPCION_FORMA_CONTACTO LIKE
      CASE Cv_TipoData
        WHEN 'MAIL'
        THEN 'Correo%'
        WHEN 'FONO'
        THEN 'Telefono%'
      END
    )
  AND IPFC.ESTADO   = 'Activo'
  AND AFC.ESTADO    = 'Activo'
  AND IPFC.PUNTO_ID = Cn_IdPunto
    )
  SELECT LISTAGG(REPLACE(REPLACE(CONTACTO, '  ', ''), ' ', ''), ';') WITHIN GROUP (
  ORDER BY CONTACTO) CONTACTO
  FROM FORMA_CONTACTO_MAIL;
  --
  CURSOR C_DatoContactoPunto(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_TipoFormaContacto VARCHAR2, Cn_NumeroTruncar NUMBER )
  IS
    SELECT FNCK_CONSULTS.F_TRUNC_BY_DELIMETER(DECODE(
            DECODE(Cv_TipoFormaContacto, 'Correo', 
                LISTAGG(REGEXP_SUBSTR(IPFC.VALOR,'[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,24}'),';') WITHIN GROUP (
    ORDER BY IPFC.VALOR), LISTAGG( REGEXP_REPLACE(IPFC.VALOR, '[^[:digit:]|;]', ''),';') WITHIN GROUP (
    ORDER BY IPFC.VALOR)), ';', NULL,
            DECODE(Cv_TipoFormaContacto, 'Correo', 
                LISTAGG(REGEXP_SUBSTR(IPFC.VALOR,'[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,24}'),';') WITHIN GROUP (
    ORDER BY IPFC.VALOR), LISTAGG( REGEXP_REPLACE(IPFC.VALOR, '[^[:digit:]|;]', ''),';') WITHIN GROUP (
    ORDER BY IPFC.VALOR))), ';', Cn_NumeroTruncar) CONTACTO
    FROM DB_COMERCIAL.INFO_PUNTO_CONTACTO IPC,
      INFO_PERSONA_FORMA_CONTACTO IPFC,
      ADMI_FORMA_CONTACTO AFC,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_EMPRESA_ROL IER,
      DB_GENERAL.ADMI_ROL AR,
      DB_GENERAL.ADMI_TIPO_ROL ATR
    WHERE IPC.PUNTO_ID            = Cn_IdPunto
    AND IPER.ID_PERSONA_ROL       = IPC.PERSONA_EMPRESA_ROL_ID
    AND IPER.EMPRESA_ROL_ID       = IER.ID_EMPRESA_ROL
    AND IER.ROL_ID                = AR.ID_ROL
    AND IPC.CONTACTO_ID           = IPFC.PERSONA_ID
    AND IPFC.FORMA_CONTACTO_ID    = AFC.ID_FORMA_CONTACTO
    AND AR.TIPO_ROL_ID            = ATR.ID_TIPO_ROL
    AND IPC.ESTADO                = 'Activo'
    AND ATR.DESCRIPCION_TIPO_ROL  = 'Contacto'
    AND AFC.DESCRIPCION_FORMA_CONTACTO LIKE Cv_TipoFormaContacto
      || '%'
    AND IPFC.ESTADO         = 'Activo'
    AND AR.DESCRIPCION_ROL IN
      (SELECT APD.VALOR1
      FROM ADMI_PARAMETRO_DET APD
      WHERE APD.PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM ADMI_PARAMETRO_CAB APC
        WHERE APC.NOMBRE_PARAMETRO = 'CONTACTO_FACTURA_TN'
        AND APC.ESTADO             = 'Activo'
        )
    AND APD.VALOR2 = Cv_TipoFormaContacto
    AND APD.VALOR3 = 'TN'
    AND APD.VALOR4 <> 'TRUNCAR'
    AND APD.ESTADO = 'Activo'
      );
    --
    CURSOR C_DatoContactoPersona(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_TipoFormaContacto VARCHAR2, Cn_NumeroTruncar NUMBER)
    IS
    SELECT FNCK_CONSULTS.F_TRUNC_BY_DELIMETER(DECODE(
            DECODE(Cv_TipoFormaContacto, 'Correo', 
                LISTAGG(REGEXP_SUBSTR(IPFC.VALOR,'[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,24}'),';') WITHIN GROUP (
    ORDER BY IPFC.VALOR), LISTAGG( REGEXP_REPLACE(IPFC.VALOR, '[^[:digit:]|;]', ''),';') WITHIN GROUP (
    ORDER BY IPFC.VALOR)), ';', NULL,
            DECODE(Cv_TipoFormaContacto, 'Correo', 
                LISTAGG(REGEXP_SUBSTR(IPFC.VALOR,'[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,24}'),';') WITHIN GROUP (
    ORDER BY IPFC.VALOR), LISTAGG( REGEXP_REPLACE(IPFC.VALOR, '[^[:digit:]|;]', ''),';') WITHIN GROUP (
    ORDER BY IPFC.VALOR))), ';', Cn_NumeroTruncar) CONTACTO
      FROM DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_CONTACTO IPC,
        INFO_PERSONA_FORMA_CONTACTO IPFC,
        ADMI_FORMA_CONTACTO AFC,
        INFO_PERSONA_EMPRESA_ROL IPER,
        INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR,
        DB_GENERAL.ADMI_TIPO_ROL ATR
      WHERE IP.ID_PUNTO             = Cn_IdPunto
      AND IP.PERSONA_EMPRESA_ROL_ID = IPC.PERSONA_EMPRESA_ROL_ID
      AND IPER.ID_PERSONA_ROL       = IPC.PERSONA_ROL_ID
      AND IPER.EMPRESA_ROL_ID       = IER.ID_EMPRESA_ROL
      AND IER.ROL_ID                = AR.ID_ROL
      AND IPC.CONTACTO_ID           = IPFC.PERSONA_ID
      AND IPFC.FORMA_CONTACTO_ID    = AFC.ID_FORMA_CONTACTO
      AND AR.TIPO_ROL_ID            = ATR.ID_TIPO_ROL
      AND IPC.ESTADO                = 'Activo'
      AND ATR.DESCRIPCION_TIPO_ROL  = 'Contacto'
      AND AFC.DESCRIPCION_FORMA_CONTACTO LIKE Cv_TipoFormaContacto
        || '%'
      AND IPFC.ESTADO         = 'Activo'
      AND AR.DESCRIPCION_ROL IN
        (SELECT APD.VALOR1
        FROM ADMI_PARAMETRO_DET APD
        WHERE APD.PARAMETRO_ID =
          (SELECT ID_PARAMETRO
          FROM ADMI_PARAMETRO_CAB APC
          WHERE APC.NOMBRE_PARAMETRO = 'CONTACTO_FACTURA_TN'
          AND APC.ESTADO             = 'Activo'
          )
      AND APD.VALOR2 = Cv_TipoFormaContacto
      AND APD.VALOR3 = 'TN'
      AND APD.VALOR4 <> 'TRUNCAR'
      AND APD.ESTADO = 'Activo'
        ) AND ROWNUM<=(Cn_NumeroTruncar+1);
      --
      CURSOR C_GetInformacionEnvioTn(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
        IS
          SELECT
            NOMBRE_ENVIO,
            SECTOR_ID,
            DIRECCION_ENVIO ,
            EMAIL_ENVIO,
            TELEFONO_ENVIO
          FROM
            DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL
          WHERE PUNTO_ID = Cn_IdPunto;      
      --
      Lv_Data VARCHAR2(2000)                                  := '';
      Lv_Prefijo DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE := '';
      Lv_TipoData             VARCHAR2(20)                    := '';
      Ln_NumeroTruncar        NUMBER                          := 0;
      Ln_NumeroTruncarDefault NUMBER                          := 0;
      Lr_GetInformacionEnvioTn C_GetInformacionEnvioTn%ROWTYPE;
      --
    BEGIN
      --
      /* Se debe verificar:
      * El prefijo de la empresa por el punto_id
      * Por el prefijo TN y por CORREO debo cargar la informacion de contactos del nuevo query
      * La otra informacion no puede verse afectada
      */
      --
      Lv_Prefijo := FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(Fn_IdPunto, '');
      --Busca la formas de contacto para TN
      IF Lv_Prefijo = 'TN' THEN
        --
        SELECT
          CASE Fv_TipoData
            WHEN 'MAIL'
            THEN 'Correo'
            WHEN 'FONO'
            THEN 'Telefono'
          END,
          CASE Fv_TipoData
            WHEN 'MAIL'
            THEN 5
            WHEN 'FONO'
            THEN 3
          END
        INTO Lv_TipoData,
          Ln_NumeroTruncarDefault
        FROM DUAL;

        --Obtiene el numero a truncar
        BEGIN
          --
          SELECT APD.VALOR1
          INTO Ln_NumeroTruncar
          FROM ADMI_PARAMETRO_DET APD
          WHERE APD.PARAMETRO_ID =
            (SELECT ID_PARAMETRO
            FROM ADMI_PARAMETRO_CAB APC
            WHERE APC.NOMBRE_PARAMETRO = 'CONTACTO_FACTURA_TN'
            AND APC.ESTADO             = 'Activo'
            )
          AND APD.VALOR2 = Lv_TipoData
          AND APD.VALOR3 = 'TN'
          AND APD.VALOR4 = 'TRUNCAR'
          AND APD.ESTADO = 'Activo';
          --
        EXCEPTION
        WHEN OTHERS THEN
          Ln_NumeroTruncar := Ln_NumeroTruncarDefault;
        END;
        --
        --Busca la data en la InfoPuntoDatoAdicional
        IF C_GetInformacionEnvioTn%ISOPEN THEN
          --
          CLOSE C_GetInformacionEnvioTn;
          --
        END IF;
        --
        OPEN C_GetInformacionEnvioTn(Fn_IdPunto);
        --
        FETCH C_GetInformacionEnvioTn INTO Lr_GetInformacionEnvioTn;
        --
        CLOSE C_GetInformacionEnvioTn;
        --
        IF Fv_TipoData = 'FONO' THEN
          --
          IF Lr_GetInformacionEnvioTn.TELEFONO_ENVIO IS NOT NULL THEN
            --
            Lv_Data := Lr_GetInformacionEnvioTn.TELEFONO_ENVIO;
            --
          END IF; --Lr_GetInformacionEnvioTn
          --
        ELSE
        --
          IF Lr_GetInformacionEnvioTn.EMAIL_ENVIO IS NOT NULL THEN
            --
            Lv_Data := Lr_GetInformacionEnvioTn.EMAIL_ENVIO;
            --
          END IF; --Lr_GetInformacionEnvioTn
        --
        END IF;
        --
        IF Lv_Data IS NULL THEN  
            --Busca la data por punto
            IF C_DatoContactoPunto%ISOPEN THEN
              --
              CLOSE C_DatoContactoPunto;
              --
            END IF;
            --
            OPEN C_DatoContactoPunto(Fn_IdPunto, Lv_TipoData, Ln_NumeroTruncar);
            --
            FETCH C_DatoContactoPunto INTO Lv_Data;
            --
            CLOSE C_DatoContactoPunto;
            --Si es null busca la data por persona
            IF Lv_Data IS NULL THEN
              --
              IF C_DatoContactoPersona%ISOPEN THEN
                --
                CLOSE C_DatoContactoPersona;
                --
              END IF;
              --
              OPEN C_DatoContactoPersona(Fn_IdPunto, Lv_TipoData, Ln_NumeroTruncar);
              --
              FETCH C_DatoContactoPersona INTO Lv_Data;
              --
              CLOSE C_DatoContactoPersona;
              --
            END IF;
            --
            IF Lv_Data IS NOT NULL THEN
               Lv_Data := Lv_Data || ';';

              --Trunca las formas de contacto
              Lv_Data := FNCK_CONSULTS.F_TRUNC_BY_DELIMETER(Lv_Data, ';', Ln_NumeroTruncar);
              --
            END IF;
            --
        END IF;
        --    
      ELSE
        --
        IF C_DatoContacto%ISOPEN THEN
          --
          CLOSE C_DatoContacto;
          --
        END IF;
        --
        OPEN C_DatoContacto(Fn_IdPunto, Fv_TipoData, Ln_NumeroTruncar);
        --
        FETCH C_DatoContacto INTO Lv_Data;
        --
        CLOSE C_DatoContacto;
        --
      END IF;
      --
      IF Fv_TipoData = 'FONO' THEN
        --
        IF Lv_Data IS NOT NULL THEN
          --
          Lv_Data := REGEXP_REPLACE(Lv_Data, '[^[:digit:]|;]', '');
          --
        END IF;
        --
      ELSE
        --
        Lv_Data := REPLACE(REPLACE(REPLACE(Lv_Data, Chr(9), ''), Chr(10), ''), Chr(13), '');
        --
      END IF;
      --
      RETURN Lv_Data;
      --
    EXCEPTION
    WHEN OTHERS THEN
      FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO', SQLERRM);
    END GET_ADITIONAL_DATA_BYPUNTO;
/**/
/**
  * Documentacion para la funcion GET_DIRECCION_EMPRESA
  * Funcion que obtiene la direccion matriz y ruc de la empresa
  * Pn_IdEmpresa    IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,     Recibe el Id de la empresa
  * Pn_IdOficina    IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,      Recibe el Id oficina
  * Pv_Estado       IN INFO_EMPRESA_GRUPO.ESTADO%TYPE,          Recibe el estado
  * Pv_TipoConsulta IN VARCHAR2                                 Recibe el tipo de consulta RUC o DIR=> Direccion
  * Retorna:
  * En tipo varcahar2 la direccion Matriz y Ruc de la empresa
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  *
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.1 01-07-2016 Se agrega cursor para obtener la direccion de la sucursal por el ID_OFICINA para TN
  * @since 1.0
  */
FUNCTION GET_DIRECCION_EMPRESA(
    Pn_IdEmpresa    IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pn_IdOficina    IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Pv_Estado       IN INFO_EMPRESA_GRUPO.ESTADO%TYPE,
    Pv_TipoConsulta IN VARCHAR2)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GetPrefijo(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT IEG.PREFIJO
    FROM INFO_EMPRESA_GRUPO IEG
    WHERE IEG.COD_EMPRESA = Cn_IdEmpresa;
  --
  CURSOR C_GetDirEmpresa(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cn_IdOficina INFO_OFICINA_GRUPO.ID_OFICINA%TYPE, Cv_Estado
    INFO_EMPRESA_GRUPO.ESTADO%TYPE)
  IS
    SELECT
      FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(SUBSTR(TRIM(IOG.DIRECCION_OFICINA)
      , 1,300))
    FROM
      INFO_OFICINA_GRUPO IOG
    WHERE
      IOG.ESTADO       = Cv_Estado
    AND IOG.EMPRESA_ID = Cn_IdEmpresa
    AND IOG.ES_MATRIZ  = 'S'
    AND IOG.ES_OFICINA_FACTURACION = 'S';
  --
  CURSOR C_GetRucEmpresa(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cv_Estado INFO_EMPRESA_GRUPO.ESTADO%TYPE)
  IS
    SELECT
      RUC
    FROM
      INFO_EMPRESA_GRUPO
    WHERE
      COD_EMPRESA = Cn_IdEmpresa
    AND ESTADO    = Cv_Estado;
  --
  CURSOR C_GetSucEmpresa(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cn_IdOficina INFO_OFICINA_GRUPO.ID_OFICINA%TYPE, Cv_Estado
    INFO_EMPRESA_GRUPO.ESTADO%TYPE)
  IS
    SELECT
      FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(SUBSTR(TRIM(IOG.DIRECCION_OFICINA)
      , 1,300))
    FROM
      INFO_OFICINA_GRUPO IOG
    WHERE
      IOG.ESTADO       = Cv_Estado
    AND IOG.EMPRESA_ID = Cn_IdEmpresa
    AND IOG.ES_MATRIZ  = 'N'
    AND IOG.ES_OFICINA_FACTURACION = 'S';
  --
  CURSOR C_GetSucEmpresaByOficinaId(Cn_IdOficina INFO_OFICINA_GRUPO.ID_OFICINA%TYPE)
  IS
    SELECT
      FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(SUBSTR(TRIM(IOG.DIRECCION_OFICINA)
      , 1,300))
    FROM
      INFO_OFICINA_GRUPO IOG
    WHERE
      IOG.ID_OFICINA = Cn_IdOficina;
  --
  Lv_InfoEmpresa VARCHAR2(1000)                  := '';
  Lv_GetPrefijo  INFO_EMPRESA_GRUPO.PREFIJO%TYPE := '';
  --
BEGIN
  --
  IF UPPER(TRIM(Pv_TipoConsulta)) = 'DIR' THEN
    --
    IF C_GetDirEmpresa%ISOPEN THEN
      --
      CLOSE C_GetDirEmpresa;
      --
    END IF;
    --
    OPEN C_GetDirEmpresa(Pn_IdEmpresa, Pn_IdOficina, Pv_Estado);
    --
    FETCH
      C_GetDirEmpresa
    INTO
      Lv_InfoEmpresa;
    --
    CLOSE C_GetDirEmpresa;
    --Este IF solo esta por facturar a TTC como MD
    IF Lv_InfoEmpresa IS NULL THEN
      --
      IF C_GetDirEmpresa%ISOPEN THEN
        --
        CLOSE C_GetDirEmpresa;
        --
      END IF;
      --
      OPEN C_GetDirEmpresa('09', Pn_IdOficina, Pv_Estado);
      --
      FETCH
        C_GetDirEmpresa
      INTO
        Lv_InfoEmpresa;
      --
      CLOSE C_GetDirEmpresa;
      --
    END IF;
    --
  ELSIF UPPER(TRIM(Pv_TipoConsulta)) = 'RUC' THEN
    --
    IF C_GetRucEmpresa%ISOPEN THEN
      --
      CLOSE C_GetRucEmpresa;
      --
    END IF;
    --
    OPEN C_GetRucEmpresa(Pn_IdEmpresa, Pv_Estado);
    --
    FETCH
      C_GetRucEmpresa
    INTO
      Lv_InfoEmpresa;
    --
    CLOSE C_GetRucEmpresa;
    --
  ELSIF UPPER(TRIM(Pv_TipoConsulta)) = 'SUC' THEN
    --
    IF C_GetPrefijo%ISOPEN THEN
      --
      CLOSE C_GetPrefijo;
      --
    END IF;
    --
    OPEN C_GetPrefijo(Pn_IdEmpresa);
    --
    FETCH
      C_GetPrefijo
    INTO
      Lv_GetPrefijo;
    --
    CLOSE C_GetPrefijo;
    --
    IF Lv_GetPrefijo = 'MD' THEN
        --
        IF C_GetSucEmpresa%ISOPEN THEN
          --
          CLOSE C_GetSucEmpresa;
          --
        END IF;
        --
        OPEN C_GetSucEmpresa(Pn_IdEmpresa, Pn_IdOficina, Pv_Estado);
        --
        FETCH
          C_GetSucEmpresa
        INTO
          Lv_InfoEmpresa;
        --
        CLOSE C_GetSucEmpresa;
        --
    ELSIF Lv_GetPrefijo = 'TN' THEN
    --
        IF C_GetSucEmpresaByOficinaId%ISOPEN THEN
          --
          CLOSE C_GetSucEmpresaByOficinaId;
          --
        END IF;
        --
        OPEN C_GetSucEmpresaByOficinaId(Pn_IdOficina);
        --
        FETCH
          C_GetSucEmpresaByOficinaId
        INTO
          Lv_InfoEmpresa;
        --
        CLOSE C_GetSucEmpresaByOficinaId;
    --
    END IF;
    --
  END IF;
  --
  RETURN TRIM(Lv_InfoEmpresa);
  ---
EXCEPTION
WHEN OTHERS THEN
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA',
  'FNCK_COM_ELECTRONICO.GET_DIRECCION_EMPRESA', SQLERRM);
END GET_DIRECCION_EMPRESA;
--
--
FUNCTION GET_INFODOCUMENTOXML(
    Pn_IdDocumento           IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pd_FeEmision             IN INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
    Pv_Direccion             IN INFO_OFICINA_GRUPO.DIRECCION_OFICINA%TYPE,
    Pv_TipoDocumento         IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoIdentificadorSri  IN ADMI_TIPO_IDENTIFICACION.CODIGO_SRI%TYPE,
    Pv_NumeroFactura         IN INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    Pv_RazonSocial           IN INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres               IN INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos             IN INFO_PERSONA.APELLIDOS%TYPE,
    Pv_IdentificacionCliente IN INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pn_Total                 IN INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    Pn_Subtotal              IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
    Pn_TotalSinImpuesto      IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
    Pn_TotalDescuento        IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
    Pn_ReferenciaDocId       IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pn_IdPersonaRol          IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Pn_DescuentoCompensacion IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE,
    Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pn_IdPunto               IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE )
  RETURN XMLTYPE
IS
    --
    CURSOR C_GetInfoDocFactura(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
                               Cd_FeEmision INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE, 
                               Cv_Direccion INFO_OFICINA_GRUPO.DIRECCION_OFICINA%TYPE, 
                               Cv_TipoDocumento ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE, 
                               Cv_TipoIdentificadorSri ADMI_TIPO_IDENTIFICACION.CODIGO_SRI%TYPE, 
                               Cv_NumeroFactura INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE, 
                               Cv_RazonSocial VARCHAR2, 
                               Cv_IdentificacionCliente INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE, 
                               Cn_Total INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE, 
                               Cn_Subtotal INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
                               Cn_TotalSinImpuesto INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
                               Cn_TotalDescuento INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
                               Cn_DescuentoCompensacion DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE,
                               Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Cv_DirEstablecimiento DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                               Cv_IdentificacionComprador DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                               Cv_RazonSocialComprador DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                               Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
    IS
        SELECT  XMLELEMENT("infoFactura", 
        XMLAGG(XMLForest(TO_CHAR(Cd_FeEmision, 'DD/MM/YYYY') "fechaEmision")), 
        XMLAGG(XMLForest(FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML(Cv_DirEstablecimiento, 
                                                                       Cv_Validador,
                                                                       UPPER(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(Cv_Direccion))) "dirEstablecimiento")),
        XMLAGG(XMLForest('0176' "contribuyenteEspecial")), 
        XMLAGG(XMLForest('SI' "obligadoContabilidad")), 
        XMLAGG(XMLForest(LPAD(Cv_TipoIdentificadorSri, 2, 0) "tipoIdentificacionComprador")), 
        XMLAGG(XMLForest(FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML(Cv_RazonSocialComprador, 
                                                                       Cv_Validador, 
                                                                       Cv_RazonSocial) "razonSocialComprador")), 
        XMLAGG(XMLForest(FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML(Cv_IdentificacionComprador, 
                                                                       Cv_Validador, 
                                                                       UPPER(Cv_IdentificacionCliente)) "identificacionComprador")), 
        XMLAGG(XMLForest(TRIM(TO_CHAR((NVL(Cn_Subtotal, 0) - NVL(Cn_TotalDescuento, 0)), '99999999990D99')) "totalSinImpuestos")), 
        XMLAGG(XMLForest(TRIM(TO_CHAR(NVL(Cn_TotalDescuento, 0), '99999999990D99')) "totalDescuento")), 
        XMLAGG(FNCK_COM_ELECTRONICO.IMPUESTOS_CAB(Cn_IdDocumento, TO_NUMBER(TO_CHAR( (NVL(Cn_Subtotal, 0)- NVL(Cn_TotalDescuento, 0)), 
                                                                                     '99999999990D99'))) ),
        DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_CONTRIBUCION_SOLIDARIA(Cn_DescuentoCompensacion, Cv_CodEmpresa, Cv_TipoDocumento), 
        XMLAGG(XMLELEMENT("propina", TO_CHAR('0.00', '0D00'))), 
        XMLAGG(XMLELEMENT("importeTotal", TRIM(TO_CHAR(NVL(Cn_Total, 0), '99999999990D99')) )), 
        XMLAGG(XMLELEMENT("moneda", 'DOLAR')),
        XMLAGG(XMLELEMENT("pagos", FNCK_COM_ELECTRONICO.GET_FORMA_PAGO_SRI(Pn_IdPersonaRol, Pn_Total, Pn_IdPunto))))
            FROM DUAL;
    --
    CURSOR C_GetInfoDocNotaCredito(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
                                   Cd_FeEmision INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE, 
                                   Cv_Direccion INFO_OFICINA_GRUPO.DIRECCION_OFICINA%TYPE, 
                                   Cv_TipoDocumento ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE, 
                                   Cv_TipoIdentificadorSri ADMI_TIPO_IDENTIFICACION.CODIGO_SRI%TYPE, 
                                   Cv_NumeroFactura INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE, 
                                   Cv_RazonSocial VARCHAR2, 
                                   Cv_IdentificacionCliente INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE, 
                                   Cn_Total INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE, 
                                   Cn_Subtotal INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
                                   Cn_TotalSinImpuesto INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
                                   Cn_TotalDescuento INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
                                   Cn_ReferenciaDocId INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                   Cv_DirEstablecimiento DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                   Cv_IdentificacionComprador DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                   Cv_RazonSocialComprador DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                   Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                   Cn_DescuentoCompensacion DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE,
                                   Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
        SELECT  XMLELEMENT("infoNotaCredito", 
        XMLAGG(XMLForest(TO_CHAR(Cd_FeEmision, 'DD/MM/YYYY') "fechaEmision")), 
        XMLAGG(XMLForest(FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML(Cv_DirEstablecimiento, 
                                                                       Cv_Validador,
                                                                       UPPER(FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(Cv_Direccion))) "dirEstablecimiento")),
        XMLAGG(XMLForest(LPAD(Cv_TipoIdentificadorSri, 2, 0) "tipoIdentificacionComprador")), 
        XMLAGG(XMLForest(FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML(Cv_RazonSocialComprador, 
                                                                       Cv_Validador,
                                                                       FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(Cv_RazonSocial)) "razonSocialComprador")), 
        XMLAGG(XMLForest(FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML(Cv_IdentificacionComprador, 
                                                                       Cv_Validador,
                                                                       UPPER(Cv_IdentificacionCliente)) "identificacionComprador")), 
        XMLAGG(XMLForest('0176' "contribuyenteEspecial")), XMLAGG(XMLForest('SI' "obligadoContabilidad")), 
        XMLAGG(XMLForest('Contribuyente Regimen Simplificado Rise' "rise")), 
        XMLAGG( XMLForest(LPAD(ATDF.CODIGO_TIPO_COMPROB_SRI, 2, 0) "codDocModificado")), 
        XMLAGG(XMLForest(LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0)
                || '-'
                || LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) +1, (INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 2) - INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1)) - 1), 1, 3), 3, 0)
                || '-'
                || LPAD(SUBSTR(IDFC.NUMERO_FACTURA_SRI, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 2) + 1, 9), 9, 0) "numDocModificado")), 
                XMLAGG(XMLForest(TO_CHAR(IDFC.FE_EMISION, 'DD/MM/YYYY') "fechaEmisionDocSustento")), 
                XMLAGG(XMLForest(TRIM(TO_CHAR(TRUNC((NVL(Cn_Subtotal, 0) - NVL(Cn_TotalDescuento, 0)), 2), '99999999990D99')) "totalSinImpuestos")), 
        DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_CONTRIBUCION_SOLIDARIA(Cn_DescuentoCompensacion, Cv_CodEmpresa, Cv_TipoDocumento), 
                XMLAGG(XMLELEMENT("valorModificacion", TRIM(TO_CHAR(TRUNC(NVL(Cn_Total, 0), 2), '99999999990D99')) )), 
                XMLAGG(XMLELEMENT("moneda", 'DOLAR')), 
                XMLAGG(FNCK_COM_ELECTRONICO.IMPUESTOS_CAB(Cn_IdDocumento, TO_NUMBER( TRIM(TO_CHAR( NVL(Cn_Subtotal, 0) - NVL(Cn_TotalDescuento, 0),
                                                                                                   '99999999990D99'))) ) ), 
                XMLAGG(XMLELEMENT("motivo", (SELECT SUBSTR(NVL(UPPER(IDFCC.OBSERVACION), 'DEVOLUCION'), 0, 300) FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFCC WHERE IDFCC.ID_DOCUMENTO = Cn_IdDocumento))))
            FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
            WHERE ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
                AND IDFC.ID_DOCUMENTO       = Cn_ReferenciaDocId;
    --
    Lv_RazonSocial INFO_PERSONA.RAZON_SOCIAL%TYPE;
    LXML_InfoDocumentov XMLTYPE;
    Lv_DirEstablecimiento DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE      := 'dirEstablecimiento';
    Lv_IdentificacionComprador DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'identificacionComprador';
    Lv_RazonSocialComprador DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE    := 'razonSocialComprador';
    Lv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                    := 'SUBSTRING';
    --
BEGIN
    --
    Lv_RazonSocial := Pv_RazonSocial;
    --
    IF Lv_RazonSocial IS NULL THEN
        --
        Lv_RazonSocial := Pv_Nombres || ' ' || Pv_Apellidos;
        --
    END IF;
    --
    IF UPPER(Pv_TipoDocumento) = 'FAC' OR UPPER(Pv_TipoDocumento) = 'FACP' THEN
        --
        IF C_GetInfoDocFactura%ISOPEN THEN
            --
            CLOSE C_GetInfoDocFactura;
            --
        END IF;
        --
        OPEN C_GetInfoDocFactura(Pn_IdDocumento,
                                 Pd_FeEmision, 
                                 Pv_Direccion, 
                                 Pv_TipoDocumento , 
                                 Pv_TipoIdentificadorSri, 
                                 Pv_NumeroFactura, 
                                 Lv_RazonSocial, 
                                 Pv_IdentificacionCliente, 
                                 Pn_Total, 
                                 Pn_Subtotal, 
                                 Pn_TotalSinImpuesto, 
                                 Pn_TotalDescuento,
                                 Pn_DescuentoCompensacion,
                                 Pv_CodEmpresa,
                                 Lv_DirEstablecimiento,
                                 Lv_IdentificacionComprador,
                                 Lv_RazonSocialComprador,
                                 Lv_Validador);
        --
        FETCH C_GetInfoDocFactura INTO LXML_InfoDocumentov;
        --
        CLOSE C_GetInfoDocFactura;
        --
    ELSIF UPPER(Pv_TipoDocumento) = 'NC' THEN
        --
        IF C_GetInfoDocNotaCredito%ISOPEN THEN
            --
            CLOSE C_GetInfoDocNotaCredito;
            --
        END IF;
        --
        OPEN C_GetInfoDocNotaCredito(Pn_IdDocumento, 
                                     Pd_FeEmision, 
                                     Pv_Direccion, 
                                     Pv_TipoDocumento , 
                                     Pv_TipoIdentificadorSri , 
                                     Pv_NumeroFactura, 
                                     Lv_RazonSocial, 
                                     Pv_IdentificacionCliente, 
                                     Pn_Total, 
                                     Pn_Subtotal, 
                                     Pn_TotalSinImpuesto, 
                                     Pn_TotalDescuento, 
                                     Pn_ReferenciaDocId,
                                     Lv_DirEstablecimiento,
                                     Lv_IdentificacionComprador,
                                     Lv_RazonSocialComprador,
                                     Lv_Validador,
                                     Pn_DescuentoCompensacion,
                                     Pv_CodEmpresa);
        --
        FETCH C_GetInfoDocNotaCredito INTO LXML_InfoDocumentov;
        --
        CLOSE C_GetInfoDocNotaCredito;
        --
    END IF;
    --
    RETURN LXML_InfoDocumentov;
    --
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_INFODOCUMENTOXML', SQLERRM);
END GET_INFODOCUMENTOXML;
/**/
/**
  * Documentacion para la funcion GET_CANTON_FORMA_PAGO
  * Funcion que obtiene la forma de pago y el canton del clientes
  * Pn_IdPersonaRol IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,    Recibe el Id persona empresa rol
  * Pn_IdPunto      IN INFO_PUNTO.ID_PUNTO%TYPE                         Recibe el Id Punto
  * Retorna:
  * En tipo varchar el la forma de pago y el canton del cliente
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.1 06-05-2015
  * @since 1.0
  */
FUNCTION GET_CANTON_FORMA_PAGO(
        Pn_IdPersonaRol IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Pn_IdPunto      IN INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR
IS
    --
    CURSOR C_GetFormaPago(Cn_IdPersonaRol INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
        SELECT  FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(REPLACE(REPLACE(REPLACE(AFP.DESCRIPCION_FORMA_PAGO, Chr(9), ' '), Chr(10), ' '), Chr(13), ' '))
            FROM INFO_CONTRATO IC,
                ADMI_FORMA_PAGO AFP
            WHERE IC.FORMA_PAGO_ID         = AFP.ID_FORMA_PAGO
                AND AFP.ESTADO                = 'Activo'
                AND IC.ESTADO                 = 'Activo'
                AND IC.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol;
    --
    CURSOR C_GetCanton(Cn_IdSector ADMI_SECTOR.ID_SECTOR%TYPE)
    IS
        SELECT  FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(REPLACE(REPLACE(REPLACE(AC.NOMBRE_CANTON, Chr(9), ' '), Chr(10), ' '), Chr(13), ' '))
            FROM ADMI_SECTOR AST,
                ADMI_PARROQUIA AP,
                ADMI_CANTON AC
            WHERE AC.ID_CANTON   = AP.CANTON_ID
                AND AP.ID_PARROQUIA = AST.PARROQUIA_ID
                AND AC.ESTADO       = 'Activo'
                AND AP.ESTADO       = 'Activo'
                AND AST.ESTADO      = 'Activo'
                AND AST.ID_SECTOR   = Cn_IdSector;
    --
    CURSOR C_GetInfoPuntoData(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
        IS
          SELECT
            *
          FROM
            INFO_PUNTO_DATO_ADICIONAL
          WHERE PUNTO_ID = Cn_IdPunto;
    /**/
    Lv_CantonFormaPago  VARCHAR2(60);
    Lr_GetInfoPuntoData C_GetInfoPuntoData%ROWTYPE;
    Ln_IdSector         ADMI_SECTOR.ID_SECTOR%TYPE;
    Lr_InfoPunto        INFO_PUNTO%ROWTYPE;
    --
BEGIN
    --
    IF Pn_IdPersonaRol IS NOT NULL AND Pn_IdPunto IS NULL THEN
        --
        IF C_GetFormaPago%ISOPEN THEN
            --
            CLOSE C_GetFormaPago;
            --
        END IF;
        --
        OPEN C_GetFormaPago(Pn_IdPersonaRol);
        --
        FETCH C_GetFormaPago INTO Lv_CantonFormaPago;
        --
        CLOSE C_GetFormaPago;
        --
    ELSIF Pn_IdPersonaRol IS NULL AND Pn_IdPunto IS NOT NULL THEN
        --
        IF C_GetInfoPuntoData%ISOPEN THEN
        --
          CLOSE C_GetInfoPuntoData;
        --
        END IF;
        --
        OPEN C_GetInfoPuntoData(Pn_IdPunto);
        --
        FETCH C_GetInfoPuntoData INTO Lr_GetInfoPuntoData;
        --
        CLOSE C_GetInfoPuntoData;
        --
        IF Lr_GetInfoPuntoData.SECTOR_ID IS NOT NULL THEN
        --
          Ln_IdSector := Lr_GetInfoPuntoData.SECTOR_ID;
        --
        ELSE
        --
          Lr_InfoPunto := FNCK_CONSULTS.F_GET_INFO_PUNTO(Pn_IdPunto, NULL);
          Ln_IdSector  := Lr_InfoPunto.SECTOR_ID;
        --
        END IF; --Lr_GetInfoPuntoData
        --
        IF C_GetCanton%ISOPEN THEN
            --
            CLOSE C_GetCanton;
            --
        END IF;
        --
        OPEN C_GetCanton(Ln_IdSector);
        --
        FETCH C_GetCanton INTO Lv_CantonFormaPago;
        --
        CLOSE C_GetCanton;
        --
    END IF;
    --
    RETURN Lv_CantonFormaPago;
    --
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO', SQLERRM);
END GET_CANTON_FORMA_PAGO;
  --
  --
  FUNCTION GET_FORMA_PAGO_SRI(
      Fn_IdPersonaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fn_BaseImponible IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE,
      Fn_IdPunto       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
    RETURN XMLTYPE
  IS
    --
    CURSOR C_GetFormaPago( Cn_CodigoSri DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE, 
                           Cn_BaseImponible DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE )
    IS
      SELECT XMLELEMENT("pago", XMLFOREST(DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(REPLACE(REPLACE(REPLACE(Cn_CodigoSri, 
                                Chr(9), ' '), Chr(10), ' '), Chr(13), ' ')) "formaPago", 
                                TRIM(TO_CHAR(NVL(Cn_BaseImponible, 0),'99999999990D99')) "total"))
      FROM DUAL;
    --
    CURSOR C_GetCodigoSriContrato(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                                  Cv_CodigoFormaPagoDebito DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
                                  Cv_CodigoFormaPagoTarjeta DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE, 
                                  Cv_CodigoFormaPagoCliente DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE, 
                                  Cn_CodigoSri DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE, 
                                  Cv_FormaPagoObtenidaPor VARCHAR2)
    IS
      SELECT
        CASE
          WHEN Cv_CodigoFormaPagoCliente = Cv_CodigoFormaPagoDebito--Se verifica que la forma de pago inicial sea DEB (DEBITO)
          THEN DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_COD_SRI_BY_BANCO_CUENTA(IC.ID_CONTRATO, 
                                                                                Cv_FormaPagoObtenidaPor, 
                                                                                Cv_CodigoFormaPagoTarjeta, 
                                                                                Cn_CodigoSri)
          ELSE Cn_CodigoSri
        END
      FROM DB_COMERCIAL.INFO_CONTRATO IC
      WHERE IC.ID_CONTRATO =
        (SELECT MAX(ID_CONTRATO)
        FROM DB_COMERCIAL.INFO_CONTRATO
        WHERE PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
        );
    --
    CURSOR C_GetCodigoSriPersona(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                                 Cv_CodigoFormaPagoDebito DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
                                 Cv_CodigoFormaPagoTarjeta DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,   
                                 Cv_CodigoFormaPagoCliente DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
                                 Cn_CodigoSri DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE,
                                 Cv_FormaPagoObtenidaPor VARCHAR2)
    IS
      SELECT
        CASE
          WHEN Cv_CodigoFormaPagoCliente = Cv_CodigoFormaPagoDebito--Se verifica que la forma de pago inicial sea DEB (DEBITO)
          THEN DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_COD_SRI_BY_BANCO_CUENTA(Cn_IdPersonaRol, 
                                                                                Cv_FormaPagoObtenidaPor,
                                                                                Cv_CodigoFormaPagoTarjeta,
                                                                                Cn_CodigoSri)
          ELSE Cn_CodigoSri
        END
      FROM DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO IPFP
      WHERE IPFP.ID_DATOS_PAGO =
        (SELECT MAX(ID_DATOS_PAGO)
        FROM DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO
        WHERE PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
        );
    --
    LXML_FormaPagoSri XMLTYPE;
    Ln_CodigoSri DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE                           := NULL;
    Lv_Estado DB_GENERAL.ADMI_FORMA_PAGO.ESTADO%TYPE                                  := 'Activo';
    Lv_CodigoFormaPagoDebito DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE        := 'DEB';
    Lv_CodigoFormaPagoTarjeta DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE       := 'TARC';
    Lv_CodigoFormaPagoCliente DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE       := '';
    Ln_IdFormaPago DB_FINANCIERO.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE                   := 0;
    Lv_DescripcionFormaPago DB_FINANCIERO.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE := '';
    Lv_TipoFormaPago DB_FINANCIERO.ADMI_FORMA_PAGO.TIPO_FORMA_PAGO%TYPE               := '';
    Lv_FormaPagoObtenidaPor VARCHAR2(10)                                              := '';
    Lv_Error                VARCHAR2(1000)                                            := '';
    Lex_Exception           EXCEPTION;
    --
  BEGIN
    --
    IF Fn_IdPersonaRol IS NOT NULL AND Fn_IdPersonaRol > 0 AND Fn_IdPunto IS NOT NULL AND Fn_IdPunto > 0 AND TO_NUMBER(Fn_BaseImponible) > 0 THEN
      --
      DB_FINANCIERO.FNCK_CONSULTS.P_GET_FORMA_PAGO_CLIENTE(Fn_IdPersonaRol,
                                                           Fn_IdPunto,
                                                           Ln_IdFormaPago,
                                                           Lv_CodigoFormaPagoCliente,
                                                           Lv_DescripcionFormaPago,
                                                           Ln_CodigoSri,
                                                           Lv_TipoFormaPago,
                                                           Lv_FormaPagoObtenidaPor);
      --
      --
      IF Ln_IdFormaPago IS NOT NULL AND Ln_IdFormaPago > 0 THEN
        --
        IF Lv_CodigoFormaPagoCliente IS NOT NULL AND Ln_CodigoSri IS NOT NULL THEN
          --
          IF Lv_FormaPagoObtenidaPor = 'CONTRATO' THEN
            --
            IF C_GetCodigoSriContrato%ISOPEN THEN
              --
              CLOSE C_GetCodigoSriContrato;
              --
            END IF;
            --
            OPEN C_GetCodigoSriContrato(Fn_IdPersonaRol, 
                                        Lv_CodigoFormaPagoDebito,
                                        Lv_CodigoFormaPagoTarjeta,
                                        Lv_CodigoFormaPagoCliente,
                                        Ln_CodigoSri,
                                        Lv_FormaPagoObtenidaPor);
            --
            FETCH C_GetCodigoSriContrato INTO Ln_CodigoSri;
            --
            CLOSE C_GetCodigoSriContrato;
            --
          ELSIF Lv_FormaPagoObtenidaPor = 'PERSONA' THEN
            --
            IF C_GetCodigoSriPersona%ISOPEN THEN
              --
              CLOSE C_GetCodigoSriPersona;
              --
            END IF;
            --
            OPEN C_GetCodigoSriPersona(Fn_IdPersonaRol, 
                                       Lv_CodigoFormaPagoDebito, 
                                       Lv_CodigoFormaPagoTarjeta, 
                                       Lv_CodigoFormaPagoCliente,
                                       Ln_CodigoSri, 
                                       Lv_FormaPagoObtenidaPor);
            --
            FETCH C_GetCodigoSriPersona INTO Ln_CodigoSri;
            --
            CLOSE C_GetCodigoSriPersona;
            --
          END IF;
          --
        ELSE
          --
          Lv_Error := 'La forma de pago encontrada tiene los campos CODIGO_FORMA_PAGO y/o CODIGO_SRI en NULL (' || Fn_IdPersonaRol || '), (' 
                      || Fn_IdPunto ||'), (' || Fn_BaseImponible || '), (' || Ln_IdFormaPago || ') - ';
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        --
        IF Ln_CodigoSri IS NOT NULL THEN
          --
          IF C_GetFormaPago%ISOPEN THEN
            --
            CLOSE C_GetFormaPago;
            --
          END IF;
          --
          OPEN C_GetFormaPago(Ln_CodigoSri, Fn_BaseImponible);
          --
          FETCH C_GetFormaPago INTO LXML_FormaPagoSri;
          --
          CLOSE C_GetFormaPago;
          --
        END IF;
        --
      ELSE
        --
        Lv_Error := 'No se encontr� forma de pago con los par�metros iniciales enviados (' || Fn_IdPersonaRol || '), (' || Fn_IdPunto ||'), (' 
                    || Fn_BaseImponible || ') - ';
        --
        RAISE Lex_Exception;
        --
      END IF;
      --
    ELSE
      --
      Lv_Error := 'No se pudo formar el tag de forma de pagos debido a que los par�metros iniciales no cumplen con la validaci�n inicial (' 
                  || Fn_IdPersonaRol || '), (' || Fn_IdPunto ||'), (' || Fn_BaseImponible || ') - ';
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    RETURN LXML_FormaPagoSri;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    LXML_FormaPagoSri := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_COM_ELECTRONICO.GET_FORMA_PAGO_SRI', Lv_Error || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN LXML_FormaPagoSri;
    --
  WHEN OTHERS THEN
    --
    LXML_FormaPagoSri := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_COM_ELECTRONICO.GET_FORMA_PAGO_SRI', 
                                          'No se pudo formar el tag de forma de pagos porque ocurri� una excepci�n en la funci�n (' 
                                          || Fn_IdPersonaRol || '), (' || Fn_IdPunto ||'), (' || Fn_BaseImponible || ') - ' || SQLCODE || ' -ERROR- '
                                          || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN LXML_FormaPagoSri;
    --
  END GET_FORMA_PAGO_SRI;
  --
  --
/**
  * Documentacion para la funcion GET_VARCHAR_CLEAN
  * Funcion que limpia la cadena de caracteres especiales
  * Fv_Cadena IN VARCHAR2   Recibe la cadena a limpiar
  * Retorna:
  * En tipo varchar2 la cadena sin caracteres especiales
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
FUNCTION GET_VARCHAR_CLEAN(
        Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2
IS
BEGIN
    RETURN TRIM(REPLACE(REPLACE(REPLACE(TRANSLATE(REGEXP_REPLACE(Fv_Cadena,'[^[:alnum:], ^[:space:]]', ''), '������,.������', 'AEIOUN  aeioun'), Chr(9), ' '), Chr(10), ' '), Chr(13), ' '));
    --

END GET_VARCHAR_CLEAN;
--
--
FUNCTION GET_VARCHAR_CLEAN_CLIENTE(
        Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2
IS
BEGIN
    RETURN TRIM(
            REPLACE(
            REPLACE(
            REPLACE(
            TRANSLATE(
            REGEXP_REPLACE(
            REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|�|<|>|/|%|"]|[)]+$', ' ')
            ,'[^A-Za-z0-9������������&()-_ ]' ,' ')
            ,'������,������', 'AEIOUN aeioun')
            , Chr(9), ' ')
            , Chr(10), ' ')
            , Chr(13), ' '));
    --

END GET_VARCHAR_CLEAN_CLIENTE;
--

PROCEDURE CREA_COMP_ELECTRONICO_MASIVO (Pv_FechaEjecucion IN VARCHAR2,
                                        Pv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE DEFAULT NULL)
IS
    --Costo del query 3
    CURSOR C_GetRucEmpresa (Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
        SELECT  RUC,
                COD_EMPRESA
            FROM INFO_EMPRESA_GRUPO
            WHERE RUC               IS NOT NULL
                AND ESTADO              = 'Activo'
                AND FACTURA_ELECTRONICO = 'S'
                AND COD_EMPRESA         = NVL(Cv_CodEmpresa, COD_EMPRESA)
            GROUP BY RUC,
                COD_EMPRESA
            ORDER BY COD_EMPRESA ASC;
    --
    CURSOR C_GetEstablecimiento(Cv_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Cv_Ruc INFO_EMPRESA_GRUPO.RUC%TYPE)
    IS
          SELECT IDFC.NUMERACION_UNO ESTABLECIMIENTO
              FROM DB_COMERCIAL.ADMI_NUMERACION IDFC,
                   INFO_OFICINA_GRUPO          IOG,
                   INFO_EMPRESA_GRUPO          IEG
             WHERE     IDFC.EMPRESA_ID = IEG.COD_EMPRESA
                   AND IDFC.OFICINA_ID = IOG.ID_OFICINA
                   AND IOG.EMPRESA_ID = IEG.COD_EMPRESA
                   AND IEG.COD_EMPRESA = Cv_IdEmpresa
                   AND IOG.ESTADO = 'Activo'
                   AND IEG.ESTADO = 'Activo'
                   AND IDFC.CODIGO IN ('FACE', 'NCE')
                   AND IDFC.NUMERACION_UNO IS NOT NULL
                   AND IEG.RUC = Cv_Ruc
          GROUP BY IDFC.NUMERACION_UNO;
    --
    CURSOR C_GetTiposDocumentos(Cv_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Cv_Ruc INFO_EMPRESA_GRUPO.RUC%TYPE, Cv_Establecimiento VARCHAR2)
    IS
        SELECT  IDFC.TIPO_DOCUMENTO_ID,
                ATDF.CODIGO_TIPO_COMPROB_SRI
            FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                INFO_OFICINA_GRUPO IOG,
                INFO_EMPRESA_GRUPO IEG,
                ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
            WHERE IDFC.OFICINA_ID                            = IOG.ID_OFICINA
                AND IOG.EMPRESA_ID                           = IEG.COD_EMPRESA
                AND IEG.COD_EMPRESA                          = Cv_IdEmpresa
                AND IDFC.TIPO_DOCUMENTO_ID                   = ATDF.ID_TIPO_DOCUMENTO
                AND IDFC.ES_ELECTRONICA                      = 'S'
                AND IEG.RUC                                  = Cv_Ruc
                AND ((IDFC.ESTADO_IMPRESION_FACT              = 'Aprobada' AND IDFC.TIPO_DOCUMENTO_ID = 6) OR
                     (IDFC.ESTADO_IMPRESION_FACT              = 'Pendiente' AND IDFC.TIPO_DOCUMENTO_ID <> 6))                
                AND IOG.ESTADO                               = 'Activo'
                AND IEG.ESTADO                               = 'Activo'
                AND IDFC.TIPO_DOCUMENTO_ID                   IN (1, 5, 6)
                AND IDFC.ESTABLECIMIENTO                     IS NOT NULL
                AND IDFC.ESTABLECIMIENTO                     = TRIM(Cv_Establecimiento)                   
                AND NOT EXISTS
                (SELECT  NULL
                    FROM INFO_COMPROBANTE_ELECTRONICO ICE
                    WHERE ICE.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                )
        GROUP BY IDFC.TIPO_DOCUMENTO_ID,
            ATDF.CODIGO_TIPO_COMPROB_SRI ;
    --
    Pn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Pn_IdEmpresa DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Pn_IdTipoDocumento DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Pv_UsrCreacion VARCHAR2(400);
    Pv_Ruc         VARCHAR2(13);
    PXML_Comprobante CLOB;
    Pv_NombreComprobante VARCHAR2(400);
    Pv_NombreTipoComprobante DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE;
    Pv_Anio         VARCHAR2(4);
    Pv_Mes          VARCHAR2(10);
    Pv_Dia          VARCHAR2(2);
    Pv_MessageError VARCHAR2(4000);
    ExWhenOthers    EXCEPTION;
    --
    --
    /**/
TYPE Lr_GetDocument
IS
    RECORD
    (
        ID_DOCUMENTO INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        EMPRESA_ID INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
        TIPO_DOCUMENTO_ID INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE);
    --
TYPE T_Documentos
IS
    TABLE OF Lr_GetDocument INDEX BY PLS_INTEGER;
    L_Documentos T_Documentos;
    /**/    
    Pn_Start             NUMBER := 0;
    Pn_Finish            NUMBER := 0;    
    Pn_Establecimiento   NUMBER := 0;        
    Ln_Total             NUMBER := 0;
    Ln_TotalCommit       NUMBER := 0;
    --
    Lrd_LoteMasivo FNCK_COM_ELECTRONICO.Lr_LoteMasivo;
    --
BEGIN
    --
    Pn_Start := SYS.DBMS_UTILITY.GET_TIME;
    --
    Pv_UsrCreacion := 'telcos_CompElec';
    --    
    --
    UTL_MAIL.SEND (sender => 'notificaciones_telcos@telconet.ec', recipients => 'notificaciones_telcos@telconet.ec;', subject => 'Facturacion Electronica - START JOB', MESSAGE => '<p>Empezo la generacion de <strong>Comprobantes Electronicos empezo : ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') || '</strong></p>', mime_type => 'text/html; charset=UTF-8' );
    --
    FOR RUC IN C_GetRucEmpresa (Cv_CodEmpresa => Pv_CodEmpresa)
    LOOP
        --
        FOR ESTAB IN C_GetEstablecimiento(RUC.COD_EMPRESA, RUC.RUC)
        LOOP
            --
            FOR ITD IN C_GetTiposDocumentos(RUC.COD_EMPRESA, RUC.RUC, ESTAB.ESTABLECIMIENTO)
            LOOP
                SELECT  IDFC.ID_DOCUMENTO,
                        DECODE(IOG.EMPRESA_ID, '09', '18', IOG.EMPRESA_ID) EMPRESA_ID,
                        IDFC.TIPO_DOCUMENTO_ID BULK COLLECT
                    INTO L_Documentos
                    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                        INFO_OFICINA_GRUPO IOG,
                        INFO_EMPRESA_GRUPO IEG
                    WHERE IDFC.OFICINA_ID                 = IOG.ID_OFICINA
                        AND IOG.EMPRESA_ID                = IEG.COD_EMPRESA
                        AND IEG.COD_EMPRESA               = RUC.COD_EMPRESA
                        AND IEG.RUC                       = RUC.RUC
                        AND IDFC.ES_ELECTRONICA           = 'S'
                        AND ((IDFC.ESTADO_IMPRESION_FACT  = 'Aprobada' AND IDFC.TIPO_DOCUMENTO_ID = 6) OR
                        (IDFC.ESTADO_IMPRESION_FACT       = 'Pendiente' AND IDFC.TIPO_DOCUMENTO_ID <> 6))
                        AND IDFC.TIPO_DOCUMENTO_ID        = ITD.TIPO_DOCUMENTO_ID                        
                        AND IDFC.ESTABLECIMIENTO          = ESTAB.ESTABLECIMIENTO
                        AND IDFC.ESTABLECIMIENTO          IS NOT NULL                        
                        AND TO_CHAR(IDFC.FE_CREACION,'RRRR-MM-DD HH24:MI:SS') < Pv_FechaEjecucion
                        AND IOG.ESTADO                    = 'Activo'
                        AND IEG.ESTADO                    = 'Activo'                               
                        AND NOT EXISTS
                        (SELECT  NULL
                            FROM INFO_COMPROBANTE_ELECTRONICO ICE
                            WHERE ICE.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                        )                       
                        ;                                                    
                --                
                FOR indx IN 1 .. L_Documentos.COUNT
                LOOP
                    --
                    Ln_Total := Ln_Total + 1;
                    --
                    Pv_MessageError := NULL;
                    --
                    FNCK_COM_ELECTRONICO.COMP_ELEC_CAB(L_Documentos(indx).ID_DOCUMENTO, L_Documentos(indx).EMPRESA_ID, L_Documentos(indx).TIPO_DOCUMENTO_ID, Pv_UsrCreacion, 'INSERT', Pv_Ruc, PXML_Comprobante, Pv_NombreComprobante, Pv_NombreTipoComprobante, Pv_Anio, Pv_Mes, Pv_Dia, Pv_MessageError);                    
                    --
                    Ln_TotalCommit := Ln_TotalCommit + 1;
                    --
                    IF Ln_TotalCommit > 2999 THEN
                        COMMIT;
                    END IF;
                    --
                END LOOP;
                --
                IF Ln_TotalCommit < 3000 THEN
                    COMMIT;
                    Ln_TotalCommit := 0;                    
                END IF;

            END LOOP;
            --
        END LOOP;
        --
    END LOOP;
    Pn_Finish := SYS.DBMS_UTILITY.GET_TIME;
    --
    --COMMIT;
    --
    UTL_MAIL.SEND (sender => 'notificaciones_telcos@telconet.ec', recipients => 'notificaciones_telcos@telconet.ec;', subject => 'Facturacion Electronica - FINISH JOB', MESSAGE => '<p>Termino la generacion de <strong>Comprobantes Electronicos con un total de ' || Ln_Total || ' Facturas en : ' || ((Pn_Finish - Pn_Start)/1000) || ' segundos. Hora final del Job ' || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS') || '</strong></p>', mime_type => 'text/html; charset=UTF-8' );
EXCEPTION
WHEN OTHERS THEN
    ROLLBACK;
    UTL_MAIL.SEND (sender => 'notificaciones_telcos@telconet.ec', recipients => 'notificaciones_telcos@telconet.ec;', subject => 'Facturacion Electronica - ERROR JOB', MESSAGE => '<p>Error <strong>Comprobantes Electronicos: </strong> </br> ' || SQLERRM || '</p>', mime_type => 'text/html; charset=UTF-8' );
END CREA_COMP_ELECTRONICO_MASIVO;
--
/**
  * Documentacion para el procedimiento GET_NUMSEND_COMPROBANTE
  * Procedimiento que obtiene el numero de veces de envio de un comprobante
  * Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,      Recibe el Id del documento
  * Pn_NumeroEnvio OUT NUMBER                                               Retorna el numero de veces de envio del comprobante
  * Retorna:
  * En tipo NUMBER el numero de veces que fue enviado el comprobante electronico
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
PROCEDURE GET_NUMSEND_COMPROBANTE(
        Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Pn_NumeroEnvio OUT NUMBER)
IS
    --
    CURSOR C_GetNumeroEnvio (Pn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
        SELECT  NVL(NUMERO_ENVIO, 0) + 1
            FROM INFO_COMPROBANTE_ELECTRONICO
            WHERE DOCUMENTO_ID = Pn_IdDocumento ;
    --
BEGIN
    --
    IF C_GetNumeroEnvio%ISOPEN THEN
        CLOSE C_GetNumeroEnvio;
    END IF;
    --
    OPEN C_GetNumeroEnvio(Pn_IdDocumento);
    --
    FETCH C_GetNumeroEnvio INTO Pn_NumeroEnvio;
    --
    CLOSE C_GetNumeroEnvio;
    --

EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_NUMSEND_COMPROBANTE', SQLERRM);
END GET_NUMSEND_COMPROBANTE;
--
/**
  * Documentacion para el procedimiento SEND_MAIL_PLANTILLA
  * Procedimiento que obtiene los alias por el codigo de la plantilla y envia correo
  * Pv_Envia   IN VARCHAR2,                                     Recibe el alias que envia el correo
  * Pv_Asunto  IN VARCHAR2,                                     Recibe el asunto del mensaje
  * Pv_Mensaje IN VARCHAR2,                                     Recibe el mensaje
  * Pv_Codigo  IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE    Recibe el codigo de la plantilla
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
PROCEDURE SEND_MAIL_PLANTILLA(
        Pv_Envia   IN VARCHAR2,
        Pv_Asunto  IN VARCHAR2,
        Pv_Mensaje IN VARCHAR2,
        Pv_Codigo  IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
IS
    --
    CURSOR C_GetPlantillaMails(Cv_Codigo DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE, Cv_Estado DB_COMUNICACION.INFO_ALIAS_PLANTILLA.ESTADO%TYPE)
    IS
        SELECT  TRIM(AA.VALOR) VALOR
            FROM DB_COMUNICACION.ADMI_PLANTILLA AP,
                DB_COMUNICACION.INFO_ALIAS_PLANTILLA IAP,
                DB_COMUNICACION.ADMI_ALIAS AA
            WHERE AP.CODIGO      = Cv_Codigo
                AND IAP.ESTADO      = Cv_Estado
                AND AP.ID_PLANTILLA = IAP.PLANTILLA_ID
                AND IAP.ALIAS_ID    = AA.ID_ALIAS;
    --
    Lv_Mails VARCHAR2(4000) := '';
    --
BEGIN
    --
    FOR MAIL IN C_GetPlantillaMails(Pv_Codigo, 'Activo')
    LOOP
        Lv_Mails := Lv_Mails || MAIL.VALOR || ';';
    END LOOP;
    --
    UTL_MAIL.SEND (sender => Pv_Envia, recipients => Lv_Mails, subject => Pv_Asunto, MESSAGE => Pv_Mensaje, mime_type => 'text/html; charset=UTF-8' );
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA', SQLERRM);
END SEND_MAIL_PLANTILLA;
--
/**
  * Documentacion para la funcion GET_NUM_CONTRATO
  * Funcion que obtiene el numero de contrato de un cliente
  * Pn_IdPersonaRol IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,    Recibe el Id persona empresa rol
  * Pv_Estado       IN INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE             Recibe el estado
  * Retorna:
  * En tipo VARCHAR el numero de contrato del cliente
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
FUNCTION GET_NUM_CONTRATO(
        Pn_IdPersonaRol IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
        Pv_Estado       IN INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE)
    RETURN VARCHAR
IS
    --
    CURSOR C_GetNumeroContrato(Cn_IdPersonaRol INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, Cv_Estado INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE)
    IS
        SELECT  TRIM(NUMERO_CONTRATO), ESTADO
            FROM INFO_CONTRATO
            WHERE ESTADO                IN ('Activo', 'Cancelado', 'Pendiente')
                AND PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
                ORDER BY ESTADO;
    --
    Lv_NumeroContrato INFO_CONTRATO.NUMERO_CONTRATO%TYPE;
    Lv_Estado INFO_CONTRATO.ESTADO%TYPE;
    --
BEGIN
    --
    IF C_GetNumeroContrato%ISOPEN THEN
        --
        CLOSE C_GetNumeroContrato;
        --
    END IF;
    --
    OPEN C_GetNumeroContrato(Pn_IdPersonaRol, Pv_Estado);
    --
    FETCH C_GetNumeroContrato INTO Lv_NumeroContrato, Lv_Estado;
    --
    CLOSE C_GetNumeroContrato;
    --
    RETURN TRIM(NVL(Lv_NumeroContrato,'0000'));
    --

EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_NUM_CONTRATO', SQLERRM);
END GET_NUM_CONTRATO;
--
/**
  * Documentacion para la funcion GET_LOGIN
  * Funcion que obtiene el login del punto
  * Pn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,     Recibe el Id punto
  * Pv_Estado  IN INFO_PUNTO.ESTADO%TYPE        Recibe el estado
  * Retorna:
  * En tipo INFO_PUNTO.LOGIN%TYPE el login del punto
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
FUNCTION GET_LOGIN(
        Pn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
        Pv_Estado  IN INFO_PUNTO.ESTADO%TYPE)
    RETURN INFO_PUNTO.LOGIN%TYPE
IS
    --
    CURSOR C_GetLogin(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_Estado INFO_PUNTO.ESTADO%TYPE)
    IS
        SELECT  REPLACE(REPLACE( REPLACE(TRIM(LOGIN), Chr(9), ' '), Chr(10), ' '), Chr(13), ' ')
            FROM INFO_PUNTO
            WHERE ID_PUNTO = Cn_IdPunto
                AND ROWNUM    < 2;
    --
    Lv_Login INFO_PUNTO.LOGIN%TYPE;
    --
BEGIN
    --
    IF C_GetLogin%ISOPEN THEN
        --
        CLOSE C_GetLogin;
        --
    END IF;
    --
    OPEN C_GetLogin(Pn_IdPunto, Pv_Estado);
    --
    FETCH C_GetLogin INTO Lv_Login;
    --
    CLOSE C_GetLogin;
    --
    RETURN Lv_Login;
    --
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_LOGIN', SQLERRM);
END GET_LOGIN;
--
/**
  * Documentacion para el procedimiento GET_LOG_ESTADO_COMPROBANTE
  * Procedimiento que retorna el log de los comprobanteselectronicos
  * Pn_IdDocumento              IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,        Recibe el Id del documento
  * Prf_MensajeCompElectronico  OUT Lrf_MensajeCompElectronico,                             Retorna el log del comprobante
  * Pv_MessageError             OUT VARCHAR2                                                Retorna un mensaje de error si existe
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
PROCEDURE GET_LOG_ESTADO_COMPROBANTE(
        Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Prf_MensajeCompElectronico OUT Lrf_MensajeCompElectronico,
        Pv_MessageError OUT VARCHAR2)
IS
    --
BEGIN
    --
    OPEN Prf_MensajeCompElectronico FOR SELECT ID_MSN_COMP_ELEC, DOCUMENTO_ID, ID_LOTE_MASIVO, TIPO, MENSAJE, INFORMACION_ADICIONAL, TO_CHAR(FE_CREACION, 'DD-MM-YYYY HH24:MI:SS:FF9') FE_CREACION FROM INFO_MENSAJE_COMP_ELEC WHERE DOCUMENTO_ID = Pn_IdDocumento ORDER BY 7;
    --
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_LOG_ESTADO_COMPROBANTE', SQLERRM);
END GET_LOG_ESTADO_COMPROBANTE;
--
/**
  * Documentacion para el procedimiento GET_DOCS_FROM_INFODOCFINAN
  * Procedimiento que retorna los comprobantes electronicos, XML y PDF
  * Pn_IdDocumento                  IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,                Recibe el Id documento
  * Pblob_ComprobanteElectronico    OUT INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECT_DEVUELTO%TYPE,  Retorna el comprobante XML
  * Pblob_PdfComprobante            OUT INFO_COMPROBANTE_ELECTRONICO.COMP_ELECTRONICO_PDF%TYPE,        Retorna el comprobante PDF
  * Pv_MessageError                 OUT VARCHAR2                                                       Retorna un mensaje de error si existe
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
PROCEDURE GET_DOCS_FROM_INFODOCFINAN(
        Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        Pblob_ComprobanteElectronico OUT INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECT_DEVUELTO%TYPE,
        Pblob_PdfComprobante OUT INFO_COMPROBANTE_ELECTRONICO.COMP_ELECTRONICO_PDF%TYPE,
        Pv_MessageError OUT VARCHAR2 )
IS
    --
    CURSOR C_GetDocsfromDocFinan (Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
        SELECT  COMPROBANTE_ELECT_DEVUELTO,
                COMP_ELECTRONICO_PDF
            FROM INFO_COMPROBANTE_ELECTRONICO
            WHERE DOCUMENTO_ID = Cn_IdDocumento;
    --
    Lblob_ComprobanteElectronico INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECT_DEVUELTO%TYPE;
    Lblob_PdfComprobante INFO_COMPROBANTE_ELECTRONICO.COMP_ELECTRONICO_PDF%TYPE;
    --
BEGIN
    --
    IF C_GetDocsfromDocFinan%ISOPEN THEN
        --
        CLOSE C_GetDocsfromDocFinan;
        --
    END IF;
    --
    OPEN C_GetDocsfromDocFinan(Pn_IdDocumento);
    --
    FETCH C_GetDocsfromDocFinan
        INTO Pblob_ComprobanteElectronico,
            Pblob_PdfComprobante;
    --
    CLOSE C_GetDocsfromDocFinan;
    --
EXCEPTION
WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_DOCS_FROM_INFODOCFINAN', SQLERRM || ' Id del Documento: ' || Pn_IdDocumento);
    Pv_MessageError := SQLERRM;
    --
END GET_DOCS_FROM_INFODOCFINAN;
--
/**
  * Documentacion para la funcion GET_DIRECCION_ENVIO
  * Funcion que obtiene la direccino de envio del comprobante
  * Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE          Recibe el Id del punto
  * Retorna:
  * En tipo VARCHAR2 la direccion de envio de la factura
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  *
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.1 27-06-2016 Se modifica el modo de obtener la direccion para la empresa TN, ya que el orden debe ser
  * direccion tributaria de la persona, direccion del punto, datos de envio del punto.
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.2 14-06-2017 Se modifica el modo de obtener la direccion para la empresa TN, se reordena la busqueda de     
  * la siguiente forma: datos de envio del punto, direccion tributaria de la persona.
  * @since 1.0
  */
FUNCTION GET_DIRECCION_ENVIO(
    Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GetDataPuntoAdicional(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT DIRECCION_ENVIO
    FROM INFO_PUNTO_DATO_ADICIONAL
    WHERE PUNTO_ID       = Cn_IdPunto
    AND DIRECCION_ENVIO IS NOT NULL;
  --
  CURSOR C_GetDireccionPersona(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT IPR.DIRECCION
    FROM INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR
    WHERE IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID             = IPR.ID_PERSONA
    AND IP.ID_PUNTO                 = Cn_IdPunto
    AND ROWNUM                      < 2;
  --
  CURSOR C_GetDireccionTributaria(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT IPR.DIRECCION_TRIBUTARIA
    FROM INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR
    WHERE IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID             = IPR.ID_PERSONA
    AND IP.ID_PUNTO                 = Cn_IdPunto
    AND ROWNUM                      < 2;
  --
  CURSOR C_GetDireccionPunto(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT DIRECCION
    FROM INFO_PUNTO
    WHERE ID_PUNTO = Cn_IdPunto
    AND DIRECCION IS NOT NULL
    AND ROWNUM     < 2;
  --
  Lv_Direccion INFO_PUNTO_DATO_ADICIONAL.DIRECCION_ENVIO%TYPE;
  Lv_Prefijo   INFO_EMPRESA_GRUPO.PREFIJO%TYPE := '';
BEGIN
  --
  Lv_Prefijo   := FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(Fn_IdPunto, '');
  --
  IF Lv_Prefijo = 'MD' THEN
    --Inicio: 1.0 Se busca la direccion en la INFO_PUNTO_DATO_ADICIONAL
    IF C_GetDataPuntoAdicional%ISOPEN THEN
      --
      CLOSE C_GetDataPuntoAdicional;
      --
    END IF;
    --
    OPEN C_GetDataPuntoAdicional(Fn_IdPunto);
    --
    FETCH C_GetDataPuntoAdicional INTO Lv_Direccion;
    --
    CLOSE C_GetDataPuntoAdicional;
    --Fin: 1.0
    /*Si Lv_Direccion es null procedemos a buscar en el otro cursor
    * que hace referencia a la tabla INFO_PERSONA
    */
    IF Lv_Direccion IS NULL THEN
      --Inicio: 1.1 Se busca la direccion en la INFO_PUNTO_DATO_ADICIONAL
      IF C_GetDireccionPersona%ISOPEN THEN
        --
        CLOSE C_GetDireccionPersona;
        --
      END IF;
      --
      OPEN C_GetDireccionPersona(Fn_IdPunto);
      --
      FETCH C_GetDireccionPersona INTO Lv_Direccion;
      --
      CLOSE C_GetDireccionPersona;
      --Fin: 1.1
    END IF;
    /*Si Lv_Direccion es null procedemos a buscar en el otro cursor
    * que hace referencia a la tabla INFO_PUNTO
    */
    IF Lv_Direccion IS NULL THEN
      --Inicio: 1.2 Se busca la direccion en la INFO_PUNTO
      IF C_GetDireccionPunto%ISOPEN THEN
        --
        CLOSE C_GetDireccionPunto;
        --
      END IF;
      --
      OPEN C_GetDireccionPunto(Fn_IdPunto);
      --
      FETCH C_GetDireccionPunto INTO Lv_Direccion;
      --
      CLOSE C_GetDireccionPunto;
      --Fin: 1.2
    END IF;
    --
  ELSE
    --  
    IF C_GetDataPuntoAdicional%ISOPEN THEN
      --
      CLOSE C_GetDataPuntoAdicional;
      --
    END IF;
    --
    OPEN C_GetDataPuntoAdicional(Fn_IdPunto);
    --
    FETCH C_GetDataPuntoAdicional INTO Lv_Direccion;
    --
    CLOSE C_GetDataPuntoAdicional;
    --
    IF Lv_Direccion IS NULL THEN
      --
      IF C_GetDireccionTributaria%ISOPEN THEN
        --
        CLOSE C_GetDireccionTributaria;
        --
      END IF;
      --
      OPEN C_GetDireccionTributaria(Fn_IdPunto);
      --
      FETCH C_GetDireccionTributaria INTO Lv_Direccion;
      --
      CLOSE C_GetDireccionTributaria;
      --
      IF Lv_Direccion IS NULL THEN
        --
        IF C_GetDireccionPunto%ISOPEN THEN
          --
          CLOSE C_GetDireccionPunto;
          --
        END IF;
        --
        OPEN C_GetDireccionPunto(Fn_IdPunto);
        --
        FETCH C_GetDireccionPunto INTO Lv_Direccion;
        --
        CLOSE C_GetDireccionPunto;
        --
      END IF;
    --
    END IF;
    --
  END IF;
  /*
  *Si la direccion no se encontro en los cursores anteriores
  * se la setea con la siguiente leyenda.
  */
  IF Lv_Direccion IS NULL THEN
    Lv_Direccion  := 'Direccion no disponible, favor comunicarse con atencion al cliente';
  END IF;
  --
  RETURN Lv_Direccion;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_DIRECCIN_ENVIO', SQLERRM);
END GET_DIRECCION_ENVIO;
--
/**
  * Documentacion para le procedimiento GET_PUEDE_ACTUALIZAR
  * Procedimiento que verifica si el comprobante puede ser actualizado
  * Pn_IdDocumento              IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,     Recibe el id del documento
  * Pn_Estado                   IN INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,            Recibe el estado
  * Pn_Resultado                OUT NUMBER,                                             Retorna el resultado 1 o NULL
  * Pv_MessageError             OUT VARCHAR2                                            Retorna un mensaje de error si existe
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
PROCEDURE GET_PUEDE_ACTUALIZAR(
    Pn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pn_Estado      IN INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
    Pn_Resultado OUT NUMBER,
    Pv_MessageError OUT VARCHAR2)
IS
  CURSOR C_GetCanUpdate(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, Cn_Estado INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE)
  IS
    SELECT 1
    FROM INFO_COMPROBANTE_ELECTRONICO
    WHERE DOCUMENTO_ID = Cn_IdDocumento
    AND ESTADO         = Cn_Estado;
BEGIN
  --
  IF C_GetCanUpdate%ISOPEN THEN
    CLOSE C_GetCanUpdate;
  END IF;
  --
  OPEN C_GetCanUpdate(Pn_IdDocumento, Pn_Estado);
  --
  FETCH C_GetCanUpdate INTO Pn_Resultado;
  --
  CLOSE C_GetCanUpdate;
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_MessageError := 'Existio un error: ' || SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_PUEDE_ACTUALIZAR', Pv_MessageError);
END GET_PUEDE_ACTUALIZAR;
--
/**
  * Documentacion para la funcion GET_LONG_TO_VARCHAR
  * Funcion que obtiene un varchar desde un Long
  * FrowId IN ROWID Recibe el rowid de la tabla INFO_DOCUMENTO_FINANCIERO_DET
  * Retorna:
  * En tipo VARCHAR2 el campo long casteado en un varchar2
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 14-10-2014
  */
FUNCTION GET_LONG_TO_VARCHAR(FrowId IN ROWID)
  RETURN VARCHAR2
IS
  --
  Lv_Varchar VARCHAR2(4000);
  --
BEGIN
  SELECT OBSERVACIONES_FACTURA_DETALLE INTO Lv_Varchar FROM INFO_DOCUMENTO_FINANCIERO_DET WHERE ROWID = FrowId;
  RETURN Lv_Varchar;
END GET_LONG_TO_VARCHAR;
--
--
FUNCTION GET_DIFERENCIA_DOC(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_GetInfoDocumentoFinCab(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT ID_DOCUMENTO,
      NVL2(VALOR_TOTAL, VALOR_TOTAL, 0) VALOR_TOTAL,
      NVL2(DESCUENTO_COMPENSACION, DESCUENTO_COMPENSACION, 0) DESCUENTO_COMPENSACION
    FROM INFO_DOCUMENTO_FINANCIERO_CAB
    WHERE ID_DOCUMENTO = Cn_IdDocumento;
  --
  CURSOR C_GetInfoDocumentoFinDet(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT ID_DOC_DETALLE,
      NVL2(PRECIO_VENTA_FACPRO_DETALLE, PRECIO_VENTA_FACPRO_DETALLE, 0) PRECIO_VENTA_FACPRO_DETALLE,
      NVL2(CANTIDAD, CANTIDAD, 0) CANTIDAD,
      NVL2(DESCUENTO_FACPRO_DETALLE, DESCUENTO_FACPRO_DETALLE, 0) DESCUENTO_FACPRO_DETALLE
    FROM INFO_DOCUMENTO_FINANCIERO_DET
    WHERE DOCUMENTO_ID = Cn_IdDocumento;
  --
  CURSOR C_GetInfoDocumentoFinImp(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  IS
    SELECT IDFI.IMPUESTO_ID,
      NVL2(IDFI.VALOR_IMPUESTO, IDFI.VALOR_IMPUESTO, 0) VALOR_IMPUESTO,
      IDFI.PORCENTAJE,
      AI.PORCENTAJE_IMPUESTO,
      AI.PRIORIDAD
    FROM INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      ADMI_IMPUESTO AI
    WHERE IDFI.IMPUESTO_ID  = AI.ID_IMPUESTO
    AND IDFI.DETALLE_DOC_ID = Cn_IdDocDetalle
    ORDER BY AI.PRIORIDAD;
  --
  Ln_Subtotal         NUMBER                                                                       := 0;
  Ln_SubtotalImpuesto NUMBER                                                                       := 0;
  Ln_Impuesto         NUMBER                                                                       := 0;
  Ln_Resultado        NUMBER                                                                       := 0;
  Lr_GetInfoDocumentoFinCab C_GetInfoDocumentoFinCab%ROWTYPE                                       := NULL;
  Ln_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE                          := 0;
  Ln_DescuentoCompensacion DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE := 0;
  Lv_TipoImpuestoCompensacion DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE                          := 'COM';              
  --
  --VARIABLE USADA PARA ACUMULAR LOS SUBTOTALES QUE SE LES CALCULA IVA PARA HALLAR EL VALOR DE LA COMPENSACION
  Ln_SubtotalSoloIva NUMBER                                                                        := 0;
  --
BEGIN
  --
  IF C_GetInfoDocumentoFinCab%ISOPEN THEN
    --
    CLOSE C_GetInfoDocumentoFinCab;
    --
  END IF;
  --
  OPEN C_GetInfoDocumentoFinCab(Fn_IdDocumento);
  --
  FETCH C_GetInfoDocumentoFinCab INTO Lr_GetInfoDocumentoFinCab;
  ---
  CLOSE C_GetInfoDocumentoFinCab;
  --
  IF Lr_GetInfoDocumentoFinCab.ID_DOCUMENTO IS NOT NULL THEN
    --
    FOR I_GetInfoDocumentoFinDet IN C_GetInfoDocumentoFinDet(Lr_GetInfoDocumentoFinCab.ID_DOCUMENTO)
    LOOP
      --
      Ln_Subtotal := 0;
      Ln_Impuesto := 0;
      Ln_Subtotal := 
       (I_GetInfoDocumentoFinDet.PRECIO_VENTA_FACPRO_DETALLE * I_GetInfoDocumentoFinDet.CANTIDAD) - I_GetInfoDocumentoFinDet.DESCUENTO_FACPRO_DETALLE;
      FOR I_GetInfoDocumentoFinImp                                        IN C_GetInfoDocumentoFinImp(I_GetInfoDocumentoFinDet.ID_DOC_DETALLE)
      LOOP
        --
        IF I_GetInfoDocumentoFinImp.PRIORIDAD = 1 THEN
          Ln_Subtotal                        := Ln_Subtotal + ROUND((Ln_Subtotal * (I_GetInfoDocumentoFinImp.PORCENTAJE_IMPUESTO / 100)),2);
          --
        ELSE
          --
          Ln_Impuesto := Ln_Impuesto + ROUND((Ln_Subtotal * (I_GetInfoDocumentoFinImp.PORCENTAJE_IMPUESTO / 100)),2);
          --
        END IF;
        --
      END LOOP;
      --
      Ln_SubtotalImpuesto := Ln_SubtotalImpuesto + Ln_Subtotal + Ln_Impuesto;
      --
    END LOOP;
    --
    Ln_SubtotalImpuesto := Ln_SubtotalImpuesto - NVL(Lr_GetInfoDocumentoFinCab.DESCUENTO_COMPENSACION, 0);
    --
    Ln_Resultado := ROUND(Lr_GetInfoDocumentoFinCab.VALOR_TOTAL, 2) - ROUND(Ln_SubtotalImpuesto, 2);
    --Se evalua sin round si la diferencia no es cero
    IF (Ln_Resultado <>0) THEN
        --
        Ln_SubtotalImpuesto := 0;
        Ln_SubtotalSoloIva  := 0;
        --
        FOR I_GetInfoDocumentoFinDet IN C_GetInfoDocumentoFinDet(Lr_GetInfoDocumentoFinCab.ID_DOCUMENTO)
        LOOP
          --
          Ln_Subtotal := 0;
          Ln_Impuesto := 0;
          Ln_Subtotal := 
           (I_GetInfoDocumentoFinDet.PRECIO_VENTA_FACPRO_DETALLE * I_GetInfoDocumentoFinDet.CANTIDAD) - I_GetInfoDocumentoFinDet.DESCUENTO_FACPRO_DETALLE;
          FOR I_GetInfoDocumentoFinImp                                        IN C_GetInfoDocumentoFinImp(I_GetInfoDocumentoFinDet.ID_DOC_DETALLE)
          LOOP
            --
            IF I_GetInfoDocumentoFinImp.PRIORIDAD = 1 THEN
              Ln_Subtotal                        := Ln_Subtotal + (Ln_Subtotal * (I_GetInfoDocumentoFinImp.PORCENTAJE_IMPUESTO / 100));
              --
            ELSE
              --
              Ln_SubtotalSoloIva := Ln_SubtotalSoloIva + NVL(Ln_Subtotal, 0); --ACUMULA LOS SUBTOTALES DE LOS PLANES Y/O PRODUCTOS QUE GENERAN IVA
              Ln_Impuesto        := Ln_Impuesto + (Ln_Subtotal * (I_GetInfoDocumentoFinImp.PORCENTAJE_IMPUESTO / 100));
              --
            END IF;
            --
          END LOOP;
          --
          Ln_SubtotalImpuesto := Ln_SubtotalImpuesto + Ln_Subtotal + Ln_Impuesto;
          --
        END LOOP;
        --
        --
        IF NVL(Lr_GetInfoDocumentoFinCab.DESCUENTO_COMPENSACION, 0) > 0 THEN
          --
          Ln_PorcentajeImpuesto := DB_FINANCIERO.FNCK_FACTURACION_MENSUAL_TN.F_OBTENER_IMPUESTO(Lv_TipoImpuestoCompensacion);
          --
          --
          IF NVL(Ln_PorcentajeImpuesto, 0) > 0 AND NVL(Ln_SubtotalSoloIva, 0) > 0 THEN
            --
            Ln_DescuentoCompensacion := (NVL(Ln_SubtotalSoloIva, 0) * NVL(Ln_PorcentajeImpuesto, 0)) / 100;
            --
          END IF;
          --
        END IF;
        --
        --
        Ln_SubtotalImpuesto := Ln_SubtotalImpuesto - NVL(Ln_DescuentoCompensacion, 0);
        --
        Ln_Resultado := ROUND(Lr_GetInfoDocumentoFinCab.VALOR_TOTAL, 2) - ROUND(Ln_SubtotalImpuesto, 2);
        --
    END IF;
    --
  END IF;
  --
  RETURN Ln_Resultado;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_DIFERENCIA_DOC', SQLERRM);
  --
END GET_DIFERENCIA_DOC;
--
/**
  * Documentacion para la funcion F_SET_ROOT_XMLTYPE
  * Retorna el documento de tipo XML seteando la version y el encoding
  * Fxml_Documento IN INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECTRONICO%TYPE Recibe el documento XML
  * Fv_Version     IN VARCHAR2                                                  Recibe la version del documento
  * Fv_Encoding    IN VARCHAR2                                                  Recibe el encoding del documento
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 28/07/2015
  */
FUNCTION F_SET_ROOT_XMLTYPE(
    Fxml_Documento IN INFO_COMPROBANTE_ELECTRONICO.COMPROBANTE_ELECTRONICO%TYPE,
    Fv_Version     IN VARCHAR2,
    Fv_Encoding    IN VARCHAR2)
  RETURN XMLTYPE
IS
  --
  Lxml XMLTYPE;
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  ADMI_PARAMETRO_DET%ROWTYPE;
  --
  Lv_Version  VARCHAR2(10) := '';
  Lv_Encoding VARCHAR2(25) := '';
  --
BEGIN
  --
  IF Fv_Version IS NULL OR Fv_Encoding IS NULL THEN
    --
    Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('CHARACTER_ENCONDING', 'Activo', 'Activo', 'DECODIFICACION', NULL, NULL, NULL);
    --
    FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
    --
    IF Lr_GetAdmiParamtrosDet.VALOR2 IS NULL OR Lr_GetAdmiParamtrosDet.VALOR4 IS NULL THEN
      Lv_Encoding                    := 'UTF-8';
      Lv_Version                     := '1.0';
    ELSE
      Lv_Encoding := Lr_GetAdmiParamtrosDet.VALOR2;
      Lv_Version  := Lr_GetAdmiParamtrosDet.VALOR4;
    END IF;
    --
  ELSE
    --
    Lv_Encoding := Fv_Encoding;
    Lv_Version  := Fv_Version;
    --
  END IF;
  --
  SELECT NVL2(Fxml_Documento, XMLROOT (Fxml_Documento, VERSION ''
    || Lv_Version
    || '" encoding="'
    || Lv_Encoding, STANDALONE NO), NULL)
  INTO Lxml
  FROM DUAL;
  --
  RETURN Lxml;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ROOT_XMLTYPE', SQLERRM);
  --
END F_SET_ROOT_XMLTYPE;
--
/**
* Documentacion para la funcion F_SHOW_TAG_EMPRESA
* Fv_CodEmpresa         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE        Recibe el codigo de la empresa
* Fv_CodeTipoDocumento  IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Recibe el codigo del tipo documento
* Fv_Tag                IN VARCHAR2                                                Recibe el tag
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 31-05-2016
*/
FUNCTION F_SHOW_TAG_EMPRESA(
    Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fv_Tag               IN VARCHAR2)
  RETURN BOOLEAN
IS
  --
  CURSOR C_GetEmpresa(Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT PREFIJO
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE COD_EMPRESA = Cv_CodEmpresa;
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE := 'TN';
  Ln_Boolean BOOLEAN;
  --
BEGIN
  --
  IF C_GetEmpresa%ISOPEN THEN
    CLOSE C_GetEmpresa;
  END IF;
  --
  OPEN C_GetEmpresa(Fv_CodEmpresa);
  --
  FETCH C_GetEmpresa INTO Lv_CodEmpresa;
  --
  CLOSE C_GetEmpresa;
  --
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('SHOW_TAG_BY_EMPRESA', 'Activo', 'Activo', TRIM(Fv_CodeTipoDocumento), Fv_Tag, NULL, Lv_CodEmpresa);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  --Si la variable no es nula existe parametro no permitido mapeado
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
    --
    Ln_Boolean := TRUE;
    --
  END IF;
  --
  RETURN Ln_Boolean;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ROOT_XMLTYPE', SQLERRM);
  --
  RETURN FALSE;
  --
END F_SHOW_TAG_EMPRESA;
/**
* Documentacion para la funcion F_GET_SALDO_CLIENTE_BY_PUNTO
* Retorna el saldo de un punto
* Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE Recibe el id del punto
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 31-05-2016
*/
FUNCTION F_GET_SALDO_CLIENTE_BY_PUNTO(
    Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE
IS
  --
  CURSOR C_GetSaldoByPunto(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT SALDO FROM VISTA_ESTADO_CUENTA_RESUMIDO WHERE PUNTO_ID =Cn_IdPunto;
  --
  Ln_Saldo VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE := 0;
  --
BEGIN
  IF C_GetSaldoByPunto%ISOPEN THEN
    CLOSE C_GetSaldoByPunto;
  END IF;
  --
  OPEN C_GetSaldoByPunto(Fn_IdPunto);
  --
  FETCH C_GetSaldoByPunto INTO Ln_Saldo;
  --
  CLOSE C_GetSaldoByPunto;
  --
  RETURN Ln_Saldo;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_GET_SALDO_CLIENTE_BY_PUNTO [' || Fn_IdPunto || ']', SQLERRM);
  --
  RETURN Ln_Saldo;
  --
END F_GET_SALDO_CLIENTE_BY_PUNTO;
--
--
FUNCTION F_SET_ATTR_SALDO(
    Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Fn_Saldo             IN VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetEmpresa(Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT PREFIJO
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE COD_EMPRESA = Cv_CodEmpresa;
  --
  CURSOR C_GetTagSaldo( Cv_NotificacionSaldo VARCHAR2, 
                        Cv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                        Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE )
  IS
    SELECT XMLAGG(XMLELEMENT( "campoAdicional", 
                              XMLATTRIBUTES('NOTIFICACION' AS "nombre"), 
                              FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, Cv_Validador, UPPER(Cv_NotificacionSaldo) ) ) )
    FROM DUAL;
  --
  Lxml XMLTYPE                                                     := NULL;
  Lv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   := 'TN';
  Lv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'campoAdicional';
  Lv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'SUBSTRING';
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_Notificacion VARCHAR2(3000) := 'Su saldo a la fecha es {strMoneda}{intSaldo} ' || 
                                    'de no confirmar desacuerdo al correo cobranzas_gye@telconet.ec ' || 
                                    'en el lapso de 72 Hs. de haber recibido la factura, se considerara aceptado formalmente por Ud.';
  --
BEGIN
  --
  IF C_GetEmpresa%ISOPEN THEN
    CLOSE C_GetEmpresa;
  END IF;
  --
  OPEN C_GetEmpresa(Fv_CodEmpresa);
  --
  FETCH C_GetEmpresa INTO Lv_CodEmpresa;
  --
  CLOSE C_GetEmpresa;
  --
  IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Fv_CodEmpresa, TRIM(Fv_CodeTipoDocumento), 'notificacion') THEN
    --
    Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('SHOW_TAG_BY_EMPRESA', 
                                                                       'Activo', 
                                                                       'Activo', 
                                                                       'NOTIFICACION', 
                                                                       NULL, 
                                                                       NULL, 
                                                                       Lv_CodEmpresa);
    --
    FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
    --
    CLOSE Lrf_GetAdmiParamtrosDet;
    --
    IF Lr_GetAdmiParamtrosDet.VALOR2 IS NOT NULL THEN
      Lv_Notificacion                := Lr_GetAdmiParamtrosDet.VALOR2;
    END IF;
    --
    Lv_Notificacion := REPLACE(Lv_Notificacion, '{strMoneda}', NVL(Lr_GetAdmiParamtrosDet.VALOR3, '$'));
    Lv_Notificacion := REPLACE(Lv_Notificacion, 
                               '{intSaldo}', 
                               TRIM(TO_CHAR(TRUNC(NVL(FNCK_COM_ELECTRONICO.F_GET_SALDO_CLIENTE_BY_PUNTO(Fn_IdPunto), 0),2), 
                               '99999999990D99')));
    --
    IF Lv_Notificacion IS NOT NULL THEN
      --
      IF C_GetTagSaldo%ISOPEN THEN
        CLOSE C_GetTagSaldo;
      END IF;
      --
      OPEN C_GetTagSaldo(Lv_Notificacion, Lv_CampoAdicional, Lv_Validador);
      --
      FETCH C_GetTagSaldo INTO Lxml;
      --
      CLOSE C_GetTagSaldo;
      --
    END IF;
    --
  END IF;
  --
  RETURN Lxml;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ATTR_SALDO', SQLERRM);
  --
  RETURN NULL;
  --
END F_SET_ATTR_SALDO;
--
--
FUNCTION F_SET_ATTR_SUBTOTAL_DOS(
    Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fn_Subtotal          IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
    Fn_SubtotalDescuento IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
    Fn_Total             IN INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    Fv_Tipo              IN VARCHAR2)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetEmpresa(Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT PREFIJO
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE COD_EMPRESA = Cv_CodEmpresa;
  --
  CURSOR C_GetSubTotalDos(Cn_Subtotal INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
                          Cn_SubtotalDescuento INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
                          Cv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                          Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
  IS
    SELECT XMLAGG(XMLELEMENT("campoAdicional", 
                             XMLATTRIBUTES('SUBTOTALDOS' AS "nombre"), 
                             FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                                            Cv_Validador,
                                                                            TO_CHAR(TRUNC((NVL(Cn_Subtotal, 0) - NVL(Cn_SubtotalDescuento, 0)),2),
                                                                            '99999999990D99') ) ))
    FROM DUAL;
  --
  CURSOR C_GetValorTotal( Cn_Total INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
                          Cv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                          Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE )
  IS
    SELECT XMLAGG(XMLELEMENT( "campoAdicional", 
                              XMLATTRIBUTES('VALORPAGAR' AS "nombre"), 
                              FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                                             Cv_Validador,
                                                                             TO_CHAR(TRUNC(NVL(Cn_Total, 0),2), '99999999990D99') ) ))
    FROM DUAL;
  --
  Lxml XMLTYPE                                                     := NULL;
  Lv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE       := 'TN';
  Ln_Total INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE          := 0;
  Lv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'campoAdicional';
  Lv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'SUBSTRING';
  --
BEGIN
  --
  IF C_GetEmpresa%ISOPEN THEN
    CLOSE C_GetEmpresa;
  END IF;
  --
  OPEN C_GetEmpresa(Fv_CodEmpresa);
  --
  FETCH C_GetEmpresa INTO Lv_CodEmpresa;
  --
  CLOSE C_GetEmpresa;
  --
  IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Fv_CodEmpresa, TRIM(Fv_CodeTipoDocumento), 'subtotalDos') THEN
    --
    IF 'SUBTOTAL_DOS' = Fv_Tipo THEN
      --
      IF C_GetSubTotalDos%ISOPEN THEN
        CLOSE C_GetSubTotalDos;
      END IF;
      --
      OPEN C_GetSubTotalDos(Fn_Subtotal, Fn_SubtotalDescuento, Lv_CampoAdicional, Lv_Validador);
      --
      FETCH C_GetSubTotalDos INTO Lxml;
      --
      CLOSE C_GetSubTotalDos;
      --
    END IF;
    --
  END IF;
  IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Fv_CodEmpresa, TRIM(Fv_CodeTipoDocumento), 'valorPagar') THEN
    --
    IF 'VALOR_TOTAL' = Fv_Tipo THEN
      --
      IF C_GetValorTotal%ISOPEN THEN
        CLOSE C_GetValorTotal;
      END IF;
      --
      OPEN C_GetValorTotal(Fn_Total, Lv_CampoAdicional, Lv_Validador);
      --
      FETCH C_GetValorTotal INTO Lxml;
      --
      CLOSE C_GetValorTotal;
      --
    END IF;
    --
  END IF;
  --
  RETURN Lxml;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ATTR_SUBTOTAL_DOS', SQLERRM);
  --
  RETURN NULL;
  --
END F_SET_ATTR_SUBTOTAL_DOS;
--
--
FUNCTION F_SET_ATTR_PAIS(
    Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fn_IdPersonaRol      IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetPaisCliente(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                          Cv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                          Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
  IS
    SELECT XMLAGG(XMLELEMENT( "campoAdicional", 
                              XMLATTRIBUTES('PAIS' AS "nombre"), 
                              FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, Cv_Validador, UPPER(AP.NOMBRE_PAIS) ) )),
      AP.ID_PAIS
    FROM INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR
    LEFT JOIN DB_GENERAL.ADMI_PAIS AP
    ON AP.ID_PAIS           = IPR.PAIS_ID
    WHERE IPER.PERSONA_ID   = IPR.ID_PERSONA
    AND IPER.ID_PERSONA_ROL = Cn_IdPersonaRol
    GROUP BY AP.ID_PAIS;
  --
  Lxml XMLTYPE                                                     := NULL;
  Ln_IdPais DB_GENERAL.ADMI_PAIS.ID_PAIS%TYPE                      := 0;
  Lv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'campoAdicional';
  Lv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'SUBSTRING';
  --
BEGIN
  --
  IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Fv_CodEmpresa, TRIM(Fv_CodeTipoDocumento), 'pais') THEN
    --
    IF C_GetPaisCliente%ISOPEN THEN
      CLOSE C_GetPaisCliente;
    END IF;
    --
    OPEN C_GetPaisCliente(Fn_IdPersonaRol, Lv_CampoAdicional, Lv_Validador);
    --
    FETCH C_GetPaisCliente INTO Lxml, Ln_IdPais;
    --
    CLOSE C_GetPaisCliente;
    --
    IF Ln_IdPais IS NULL THEN
      --
      RETURN NULL;
      --
    END IF;
    --
  END IF;
  --
  RETURN Lxml;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ATTR_PAIS', SQLERRM);
  --
  RETURN NULL;
  --
END F_SET_ATTR_PAIS;
--
--
FUNCTION F_SET_ATTR_CONSUMO_CLIENTE(
    Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_MesConsumo        IN INFO_DOCUMENTO_FINANCIERO_CAB.MES_CONSUMO%TYPE,
    Fv_RangoConsumo      IN INFO_DOCUMENTO_FINANCIERO_CAB.RANGO_CONSUMO%TYPE,
    Fd_FeEmision         IN INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
    Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fv_AnioConsumo       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ANIO_CONSUMO%TYPE)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetConsumoCliente(Cv_MesAnioConsumo VARCHAR2,
                             Cv_RangoConsumo INFO_DOCUMENTO_FINANCIERO_CAB.RANGO_CONSUMO%TYPE, 
                             Cd_FeEmision    INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
                             Cv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                             Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                             Cv_MascaraConsumo VARCHAR2,
                             Cv_FormatoConsumo VARCHAR2 )
  IS
    SELECT DECODE(Cv_RangoConsumo, 
                  NULL, 
                  DECODE(Cv_MesAnioConsumo, 
                  NULL, 
                  XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('CONSUMOCLIENTE' AS "nombre"), 
                  FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                                 Cv_Validador,
                                                                 UPPER(TO_CHAR(Cd_FeEmision, Cv_FormatoConsumo, 'NLS_DATE_LANGUAGE=SPANISH')) ) )), 
                  XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('CONSUMOCLIENTE' AS "nombre"), 
                  FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, 
                                                                 Cv_Validador,
                                                                 UPPER(TO_CHAR(TO_DATE(Cv_MesAnioConsumo, Cv_MascaraConsumo), Cv_FormatoConsumo, 
                                                                         'NLS_DATE_LANGUAGE=SPANISH')) ))) ),
                  XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('CONSUMOCLIENTE' AS "nombre"), 
                  FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, Cv_Validador, UPPER(Cv_RangoConsumo) ) )))

    FROM DUAL;
  --
  Lxml                  XMLTYPE                                        := NULL;
  Lv_CampoAdicional     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'campoAdicional';
  Lv_Validador          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE      := 'SUBSTRING';
  Lv_TagConsumoCliente  VARCHAR2(22)                                   := 'consumoMesAnioCliente';
  Lv_MesAnioConsumo     VARCHAR2(7)                                    := Fv_MesConsumo;
  Lv_MascaraConsumo     VARCHAR2(8)                                    := 'MM';
  Lv_FormatoConsumo     VARCHAR2(11)                                   := 'MONTH';
  --
BEGIN
  --
  IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Fv_CodEmpresa, TRIM(Fv_CodeTipoDocumento), 'consumoCliente') THEN
    --
    IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Fv_CodEmpresa, TRIM(Fv_CodeTipoDocumento), Lv_TagConsumoCliente) THEN
      --
      IF TRIM(Fv_AnioConsumo) IS NOT NULL THEN
        --
        Lv_MesAnioConsumo := Fv_MesConsumo || ' ' || Fv_AnioConsumo;
        Lv_MascaraConsumo := 'MM YYYY';
        Lv_FormatoConsumo := 'MONTH YYYY';
        --
      ELSIF TRIM(Fd_FeEmision) IS NOT NULL THEN
        --
        Lv_FormatoConsumo := 'MONTH YYYY';
        --
      END IF;
      --
    END IF;
    --
    --
    IF C_GetConsumoCliente%ISOPEN THEN
      CLOSE C_GetConsumoCliente;
    END IF;
    --
    OPEN C_GetConsumoCliente(Lv_MesAnioConsumo, 
                             Fv_RangoConsumo, 
                             Fd_FeEmision, 
                             Lv_CampoAdicional, 
                             Lv_Validador, 
                             Lv_MascaraConsumo, 
                             Lv_FormatoConsumo);
    --
    FETCH C_GetConsumoCliente INTO Lxml;
    --
    CLOSE C_GetConsumoCliente;
    --
  END IF;
  --
  RETURN Lxml;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ATTR_CONSUMO_CLIENTE', SQLERRM);
  --
  RETURN NULL;
  --
END F_SET_ATTR_CONSUMO_CLIENTE;
--
/**
* F_SUM_IMPUESTO_ICE_DET, Retorna la sumatoria a detalle de los impuestos para la informacion del comprobante
*
* Fn_IdDocDetalle IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE  Recibe el id del detalle del documento
* Fv_CodigoSRI    IN ADMI_IMPUESTO.CODIGO_SRI%TYPE                      Recibe el codigo del impuesto del SRi
* @return NUMBER 
* 
* @author Alexander Samaniego <awsamaniego@telconte.ec>
* @version 1.0 04-07-2016
*
* Se cambia el TRUNC por ROUND ya que el valor correspondiente a base imponible se esta calculando con un centavo
* menos
* @author Gina Villalba <gvillalba@telconte.ec>
* @version 1.1 13-07-2016
*
* @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
* @version 1.2 08-01-2018 -  Se realiza mejora para que calcule correctamente la base imponible para el calculo del IVA incluyendo 
*                            el impuesto ICE, se modifica cursor C_GetTipoImpuesto  para que verifique el Impuesto 
*                            asignado al detalle del documento y no solo por codigo de impuesto sri, ya que existen mas registros de Imp.IVA 
*                            creados por Telcos Panama.
*/
FUNCTION F_SUM_IMPUESTO_ICE_DET(
    Fn_IdDocDetalle IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
    Fv_CodigoSRI    IN ADMI_IMPUESTO.CODIGO_SRI%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_GetSumImpuesto(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE) 
    IS
    SELECT ROUND(SUM(NVL(IDFI.VALOR_IMPUESTO, 0)),2) VALOR_IMPUESTO
    FROM INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      ADMI_IMPUESTO AI
    WHERE IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
    AND AI.ID_IMPUESTO        = IDFI.IMPUESTO_ID
    AND AI.PRIORIDAD          = 1
    AND IDFD.ID_DOC_DETALLE   = Cn_IdDocDetalle;
  --
   CURSOR C_GetTipoImpuesto(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
                            Cv_CodigoSRI ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  IS  
    SELECT IMP.TIPO_IMPUESTO FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IFD,
    INFO_DOCUMENTO_FINANCIERO_IMP IFDI, DB_GENERAL.ADMI_IMPUESTO IMP
    WHERE IFD.ID_DOC_DETALLE =IFDI.DETALLE_DOC_ID
    AND IFDI.IMPUESTO_ID   = IMP.ID_IMPUESTO
    AND IFD.ID_DOC_DETALLE = Cn_IdDocDetalle
    AND IMP.CODIGO_SRI     = Cv_CodigoSRI;
  --
  Ln_GetSumImpuesto NUMBER                         := 0;
  Lv_TipoImpuesto ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := '';
  --
BEGIN
  --
  IF C_GetTipoImpuesto%ISOPEN THEN
    CLOSE C_GetTipoImpuesto;
  END IF;
  --
  OPEN C_GetTipoImpuesto(Fn_IdDocDetalle,Fv_CodigoSRI);
  --
  FETCH C_GetTipoImpuesto INTO Lv_TipoImpuesto;
  --
  CLOSE C_GetTipoImpuesto;
  --
  IF Lv_TipoImpuesto = 'IVA' THEN
    --
    IF C_GetSumImpuesto%ISOPEN THEN
      CLOSE C_GetSumImpuesto;
    END IF;
    --
    OPEN C_GetSumImpuesto(Fn_IdDocDetalle);
    --
    FETCH C_GetSumImpuesto INTO Ln_GetSumImpuesto;
    --
    CLOSE C_GetSumImpuesto;
    --
  END IF;
  --
  RETURN Ln_GetSumImpuesto;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SUM_IMPUESTO_ICE_DET', SQLERRM);
  --
  RETURN Ln_GetSumImpuesto;
  --
END F_SUM_IMPUESTO_ICE_DET;
--
--
FUNCTION F_SUM_IMPUESTO_ICE_CAB(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE,
    Fv_CodigoSRI    IN ADMI_IMPUESTO.CODIGO_SRI%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_GetSumImpuesto(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE) 
    IS
    SELECT SUM(NVL(IDFI.VALOR_IMPUESTO, 0)) VALOR_IMPUESTO
    FROM INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      ADMI_IMPUESTO AI
    WHERE IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
    AND AI.ID_IMPUESTO        = IDFI.IMPUESTO_ID
    AND AI.PRIORIDAD          = 1
    AND IDFD.DOCUMENTO_ID     = Cn_IdDocumento
    GROUP BY AI.CODIGO_SRI,
      AI.CODIGO_TARIFA,
      AI.TIPO_IMPUESTO,
      AI.PORCENTAJE_IMPUESTO;
  --
  CURSOR C_GetTipoImpuesto(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE,
                            Cv_CodigoSRI ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  IS  
    SELECT IMP.TIPO_IMPUESTO FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IFD,
    INFO_DOCUMENTO_FINANCIERO_IMP IFDI, DB_GENERAL.ADMI_IMPUESTO IMP
    WHERE IFD.ID_DOC_DETALLE =IFDI.DETALLE_DOC_ID
    AND IFDI.IMPUESTO_ID   = IMP.ID_IMPUESTO
    AND IFD.DOCUMENTO_ID   = Cn_IdDocumento
    AND IMP.CODIGO_SRI     = Cv_CodigoSRI;
  --
  Ln_GetSumImpuesto NUMBER                         := 0;
  Lv_TipoImpuesto ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := '';
  --
BEGIN
  --
  IF C_GetTipoImpuesto%ISOPEN THEN
    CLOSE C_GetTipoImpuesto;
  END IF;
  --
  OPEN C_GetTipoImpuesto(Fn_IdDocumento,Fv_CodigoSRI);
  --
  FETCH C_GetTipoImpuesto INTO Lv_TipoImpuesto;
  --
  CLOSE C_GetTipoImpuesto;
  --
  IF Lv_TipoImpuesto = 'IVA' THEN
    --
    IF C_GetSumImpuesto%ISOPEN THEN
      CLOSE C_GetSumImpuesto;
    END IF;
    --
    OPEN C_GetSumImpuesto(Fn_IdDocumento);
    --
    FETCH C_GetSumImpuesto INTO Ln_GetSumImpuesto;
    --
    CLOSE C_GetSumImpuesto;
    --
  END IF;
  --
  RETURN Ln_GetSumImpuesto;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SUM_IMPUESTO_ICE_CAB', SQLERRM);
  --
  RETURN Ln_GetSumImpuesto;
  --
END F_SUM_IMPUESTO_ICE_CAB;
/**
* Documentacion para la funcion P_UPDATE_CLAVEACCESO_COMP_ELEC
* Permite la actualizacion INFO_COMPROBANTE_ELECTRONICO, proceso que sera llamado desde el trigger en la tabla DB_COMPROBANTES.INFO_DOCUMENTO
* Pv_Nombre          IN DB_COMPROBANTES.INFO_DOCUMENTO.NOMBRE%TYPE,
* Pn_TipoDocId       IN DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_DOC_ID%TYPE,
* Pn_IdEmpresa       IN DB_COMPROBANTES.INFO_DOCUMENTO.EMPRESA_ID%TYPE,
* Pv_Establecimiento IN DB_COMPROBANTES.INFO_DOCUMENTO.ESTABLECIMIENTO%TYPE,  
* Pv_ClaveAcceso     IN DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%TYPE,
* Pn_Estado          IN DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_DOC_ID%TYPE,
* Pv_Mensaje OUT VARCHAR2
* @version 1.0 01-06-2016
*/
 PROCEDURE P_UPDATE_CLAVEACCESO_COMP_ELEC(
        Pv_Nombre          IN DB_COMPROBANTES.INFO_DOCUMENTO.NOMBRE%TYPE,
        Pn_TipoDocId       IN DB_COMPROBANTES.INFO_DOCUMENTO.TIPO_DOC_ID%TYPE,
        Pn_IdEmpresa       IN DB_COMPROBANTES.INFO_DOCUMENTO.EMPRESA_ID%TYPE,
        Pv_Establecimiento IN DB_COMPROBANTES.INFO_DOCUMENTO.ESTABLECIMIENTO%TYPE,  
        Pv_ClaveAcceso     IN DB_COMPROBANTES.INFO_DOCUMENTO.CLAVE_ACCESO%TYPE,
        Pn_Estado          IN DB_COMPROBANTES.INFO_DOCUMENTO.ESTADO_DOC_ID%TYPE,
        Pv_Mensaje         OUT VARCHAR2)
IS    
BEGIN
Pv_Mensaje :='';
EXCEPTION
WHEN OTHERS THEN
  Pv_Mensaje := SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'Error en FNCK_COM_ELECTRONICO.P_UPDATE_CLAVEACCESO_COMP_ELEC', Pv_Mensaje);
  --
END P_UPDATE_CLAVEACCESO_COMP_ELEC;
/**
* Documentacion para la funcion P_UPDATE_ESTADO_COMP_ELECT
* Permite la actualizacion INFO_COMPROBANTE_ELECTRONICO, proceso que sera llamado desde el trigger en la tabla DB_COMPROBANTES.INFO_DOCUMENTO
* Pn_DocumentoIdFinan   IN DB_COMPROBANTES.INFO_DOCUMENTO.DOCUMENTO_ID_FINAN%TYPE,
* Pn_Estado             IN INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
* Pv_ClaveAcceso        IN INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE,
* Pv_ClaveAccesoNueva   IN INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE,
* Pt_FeAutorizacion     IN INFO_COMPROBANTE_ELECTRONICO.FE_AUTORIZACION%TYPE,
* Pv_NumeroAutorizacion IN INFO_COMPROBANTE_ELECTRONICO.NUMERO_AUTORIZACION%TYPE,
* Pv_Mensaje OUT VARCHAR2
* @version 1.0 01-06-2016
*
* @author Anabelle Penaherrera <apenaherrera@telconet.ec>
* @version 1.1 15-12-2017
* Se agrega Actualizacion de la Clave de acceso en INFO_COMPROBANTE_ELECTRONICO en base al DOCUMENTO_ID_FINAN 
*
* @author Anabelle Penaherrera <apenaherrera@telconet.ec>
* @version 1.2 02-02-2018
* Se modifica para que por estado Descartado ESTADO_DOC_ID=9 no pase a NULL la Clave de Acceso
*/
PROCEDURE P_UPDATE_ESTADO_COMP_ELECT(
    Pn_DocumentoIdFinan   IN DB_COMPROBANTES.INFO_DOCUMENTO.DOCUMENTO_ID_FINAN%TYPE,
    Pn_Estado             IN INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
    Pv_ClaveAcceso        IN INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE,
    Pv_ClaveAccesoNueva   IN INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE,
    Pt_FeAutorizacion     IN INFO_COMPROBANTE_ELECTRONICO.FE_AUTORIZACION%TYPE,
    Pv_NumeroAutorizacion IN INFO_COMPROBANTE_ELECTRONICO.NUMERO_AUTORIZACION%TYPE,
    Pv_Mensaje           OUT VARCHAR2)
IS
  --
   CURSOR C_GetInfoDocumento(Cn_DocumentoIdFinan DB_COMPROBANTES.INFO_DOCUMENTO.DOCUMENTO_ID_FINAN%TYPE)
  IS
    SELECT ICE.*          
    FROM INFO_COMPROBANTE_ELECTRONICO ICE
    WHERE ICE.DOCUMENTO_ID= Cn_DocumentoIdFinan
    ;
  --
  CURSOR C_GetCombranteElectronico(Cv_ClaveAcceso INFO_COMPROBANTE_ELECTRONICO.CLAVE_ACCESO%TYPE)
  IS
    SELECT ICE.ID_COMP_ELECTRONICO,
           ICE.ESTADO,
           ICE.CLAVE_ACCESO
    FROM INFO_COMPROBANTE_ELECTRONICO ICE
    WHERE ICE.CLAVE_ACCESO = Cv_ClaveAcceso;
  --
  /*Parmetros del procedure IN*/
  Ln_Estado INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE := Pn_Estado;
  /*Parmetros del procedure IN*/
  --
  Lr_GetCombranteElectronico    C_GetCombranteElectronico%ROWTYPE;
  Lr_GetInfoDocumento           C_GetInfoDocumento%ROWTYPE;
  Lrf_ComprobanteElectronico    FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico;  
  Lrf_InfoDocumentoHistorial    FNCK_COM_ELECTRONICO.Lr_InfoDocumentoHistorial;
  Lrf_GetAdmiParamtrosDet       SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Ln_EstadoComp                 INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE;
  Prf_ComprobanteElectronico    FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico;
  Lv_CLAVE_ACCESO_NUEVA         VARCHAR2(22)   := 'CLAVE_ACCESO_NUEVA';
  Lv_CLAVE_ACCESO               VARCHAR2(13)   := 'CLAVE_ACCESO';
  Lv_ESTADO                     VARCHAR2(11)   := 'SET_ESTADO';
  Lv_ESTADO_NULL                VARCHAR2(12)   := 'ESTADO_NULL';
  Ln_EstadoNull                 NUMBER         := 999;
  Lv_Result                     VARCHAR2(2000) := '';
  Lex_Exception                 EXCEPTION;
  --
BEGIN
  --
  IF C_GetInfoDocumento%ISOPEN THEN
    --
    CLOSE C_GetInfoDocumento;
    --
  END IF;
  --
  IF C_GetCombranteElectronico%ISOPEN THEN
    --
    CLOSE C_GetCombranteElectronico;
    --
  END IF;
  --
  --Verifico si existe el comprobante en base al Documento_Id_Finan de DB_COMPROBANTE
  OPEN C_GetInfoDocumento(Pn_DocumentoIdFinan);
  --
  FETCH C_GetInfoDocumento INTO Lr_GetInfoDocumento;
  --
  CLOSE C_GetInfoDocumento;
  -- 
  --Si encuentra comprobante
  IF Lr_GetInfoDocumento.ID_COMP_ELECTRONICO IS NOT NULL THEN
    --Si ya existe Clave de Acceso registrada en INFO_COMPROBANTE_ELECTRONICO genero Historial de Actualizacion en INFO_COMP_ELECTRONICO_HIST
    IF Lr_GetInfoDocumento.CLAVE_ACCESO IS NOT NULL AND Lr_GetInfoDocumento.CLAVE_ACCESO !=Pv_ClaveAcceso THEN
      --
      Lrf_ComprobanteElectronico.NOMBRE_COMPROBANTE     := Lr_GetInfoDocumento.NOMBRE_COMPROBANTE;
      Lrf_ComprobanteElectronico.ID_COMP_ELECTRONICO    := Lr_GetInfoDocumento.ID_COMP_ELECTRONICO;
      Lrf_ComprobanteElectronico.DOCUMENTO_ID           := Lr_GetInfoDocumento.DOCUMENTO_ID;
      Lrf_ComprobanteElectronico.TIPO_DOCUMENTO_ID      := Lr_GetInfoDocumento.TIPO_DOCUMENTO_ID;
      Lrf_ComprobanteElectronico.NUMERO_FACTURA         := Lr_GetInfoDocumento.NUMERO_FACTURA_SRI;
      Lrf_ComprobanteElectronico.FE_AUTORIZACION        := Lr_GetInfoDocumento.FE_AUTORIZACION;
      Lrf_ComprobanteElectronico.NUMERO_AUTORIZACION    := Lr_GetInfoDocumento.NUMERO_AUTORIZACION;
      Lrf_ComprobanteElectronico.CLAVE_ACCESO           := Pv_ClaveAcceso;
      Lrf_ComprobanteElectronico.ESTADO                 := Lr_GetInfoDocumento.ESTADO;
      Lrf_ComprobanteElectronico.DETALLE                := Lr_GetInfoDocumento.DETALLE;
      Lrf_ComprobanteElectronico.RUC                    := Lr_GetInfoDocumento.RUC;
      Lrf_ComprobanteElectronico.FE_CREACION            := Lr_GetInfoDocumento.FE_CREACION;
      Lrf_ComprobanteElectronico.FE_MODIFICACION        := Lr_GetInfoDocumento.FE_MODIFICACION;
      Lrf_ComprobanteElectronico.USR_CREACION           := Lr_GetInfoDocumento.USR_CREACION;
      Lrf_ComprobanteElectronico.USR_MODIFICACION       := Lr_GetInfoDocumento.USR_MODIFICACION;
      Lrf_ComprobanteElectronico.ENVIADO                := Lr_GetInfoDocumento.ENVIADO;
      Lrf_ComprobanteElectronico.NUMERO_ENVIO           := Lr_GetInfoDocumento.NUMERO_ENVIO;
      Lrf_ComprobanteElectronico.LOTE_MASIVO_ID         := Lr_GetInfoDocumento.LOTE_MASIVO_ID;
      --
      Lrf_InfoDocumentoHistorial.DOCUMENTO_ID           := Lr_GetInfoDocumento.DOCUMENTO_ID;
      Lrf_InfoDocumentoHistorial.MOTIVO_ID              := NULL;
      Lrf_InfoDocumentoHistorial.FE_CREACION            := SYSDATE;
      Lrf_InfoDocumentoHistorial.USR_CREACION           := USER;
      --Crea el historial de la tabla INFO_COMP_ELECTRONICO_HIST
      FNCK_COM_ELECTRONICO_TRAN.INSERT_COMP_ELECTRONICO_HIST(Lrf_ComprobanteElectronico, Pv_Mensaje);

      IF Pv_Mensaje IS NOT NULL THEN
      --
        RAISE Lex_Exception;
      --
      END IF;     

      IF Ln_Estado = 5 THEN
        Lrf_InfoDocumentoHistorial.ESTADO := 'Activo';
      ELSIF Ln_Estado = 8 THEN
        Lrf_InfoDocumentoHistorial.ESTADO := 'Rechazado';      
      ELSE
        Lrf_InfoDocumentoHistorial.ESTADO := 'Pendiente';      
      END IF;
      --
      Lrf_InfoDocumentoHistorial.OBSERVACION    := 'Se crea Historial por Actualizacion de CLAVE_ACCESO :' || Pv_ClaveAcceso;
      FNCK_COM_ELECTRONICO_TRAN.INSERT_DOCUMENTO_HISTORIAL(Lrf_InfoDocumentoHistorial, Pv_Mensaje);
      --
      IF Pv_Mensaje IS NOT NULL THEN
        --
        RAISE Lex_Exception;
        --
      END IF;
      --
    END IF;
    --
    --Si encuento el Documento_Id_Finan referenciado entonces se Actualiza Clave de Acceso en INFO_COMPROBANTE_ELECTRONICO  
    Prf_ComprobanteElectronico.CLAVE_ACCESO         := Pv_ClaveAcceso;    
    Prf_ComprobanteElectronico.ID_COMP_ELECTRONICO  := Lr_GetInfoDocumento.ID_COMP_ELECTRONICO;
    Prf_ComprobanteElectronico.FE_MODIFICACION      := SYSDATE;
    Prf_ComprobanteElectronico.USR_MODIFICACION     := USER;
    FNCK_COM_ELECTRONICO_TRAN.UPDATE_COMP_ELECT_CLAVEACCESO(Prf_ComprobanteElectronico, Lv_Result);
    --    
  END IF;
  --
  --Verifico si existe el comprobante en base a la Clave de Acceso
  OPEN C_GetCombranteElectronico(Pv_ClaveAcceso);
  --
  FETCH C_GetCombranteElectronico INTO Lr_GetCombranteElectronico;
  --
  CLOSE C_GetCombranteElectronico;
  --
  IF Lr_GetCombranteElectronico.ID_COMP_ELECTRONICO IS NOT NULL THEN
    --
    Lr_GetCombranteElectronico.ESTADO := Pn_Estado;
    Lrf_GetAdmiParamtrosDet           := NULL;
    Lr_GetAdmiParamtrosDet            := NULL;
    --
    IF Ln_Estado IS NULL THEN
      Ln_Estado  := Ln_EstadoNull;
    END IF;
    --
    Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('MAP_ESTADO_COMP_ELECTRONICO', 'Activo', 'Activo', Ln_Estado, NULL, NULL, NULL);
    --
    FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
    --
    CLOSE Lrf_GetAdmiParamtrosDet;
    --
    IF Lv_ESTADO_NULL = Lr_GetAdmiParamtrosDet.VALOR4 THEN --Lv_ESTADO_NULL
      --
      Lr_GetCombranteElectronico.ESTADO := Lr_GetAdmiParamtrosDet.VALOR2;
      --
      IF Pv_ClaveAcceso IS NULL THEN
        --
        Lr_GetCombranteElectronico.ESTADO       := Lr_GetAdmiParamtrosDet.VALOR3;
        Lr_GetCombranteElectronico.CLAVE_ACCESO := NULL;
        --
      END IF;
      --
    END IF; --Lv_ESTADO_NULL
    --
    IF Lv_CLAVE_ACCESO_NUEVA = Lr_GetAdmiParamtrosDet.VALOR4 THEN --Lv_CLAVE_ACCESO_NUEVA
      --
      Lr_GetCombranteElectronico.ESTADO       := Lr_GetAdmiParamtrosDet.VALOR2;
      Lr_GetCombranteElectronico.CLAVE_ACCESO := Pv_ClaveAcceso;
      --
      IF Pv_ClaveAcceso IS NULL THEN
        --
        Lr_GetCombranteElectronico.ESTADO       := Lr_GetAdmiParamtrosDet.VALOR3;
        Lr_GetCombranteElectronico.CLAVE_ACCESO := NULL;
        --
      END IF;
      --
    END IF; --Lv_CLAVE_ACCESO_NUEVA
    --
    IF Lv_ESTADO = Lr_GetAdmiParamtrosDet.VALOR4 THEN --Lv_ESTADO
      --
      Lr_GetCombranteElectronico.ESTADO       := Lr_GetAdmiParamtrosDet.VALOR2;  
      --
    END IF; --Lv_ESTADO
    --
    IF Lv_CLAVE_ACCESO = Lr_GetAdmiParamtrosDet.VALOR4 THEN --Lv_CLAVE_ACCESO
      --
      Lr_GetCombranteElectronico.ESTADO := Lr_GetAdmiParamtrosDet.VALOR2;
      --
      IF Pv_ClaveAcceso IS NULL THEN
        --
        Lr_GetCombranteElectronico.ESTADO       := Lr_GetAdmiParamtrosDet.VALOR3;
        Lr_GetCombranteElectronico.CLAVE_ACCESO := NULL;
        --
      END IF;
      --
    END IF; --Lv_CLAVE_ACCESO
    --
    Prf_ComprobanteElectronico.ID_COMP_ELECTRONICO := Lr_GetCombranteElectronico.ID_COMP_ELECTRONICO;
    Prf_ComprobanteElectronico.CLAVE_ACCESO        := Lr_GetCombranteElectronico.CLAVE_ACCESO;
    Prf_ComprobanteElectronico.ESTADO              := Lr_GetCombranteElectronico.ESTADO;
    Prf_ComprobanteElectronico.FE_MODIFICACION     := SYSDATE;
    Prf_ComprobanteElectronico.USR_MODIFICACION    := 'DB_FINANCIERO';
    Prf_ComprobanteElectronico.ENVIADO             := 'S';
    Prf_ComprobanteElectronico.FE_AUTORIZACION     := Pt_FeAutorizacion;
    Prf_ComprobanteElectronico.NUMERO_AUTORIZACION := Pv_NumeroAutorizacion;
    --
    --ACTUALIZA EL COMPROBANTE ELECTRONICO
    FNCK_COM_ELECTRONICO_TRAN.UPDATE_COMP_ELECT(Prf_ComprobanteElectronico, Lv_Result);
    --
  END IF;
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_Mensaje := SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'Error en FNCK_COM_ELECTRONICO.P_UPDATE_ESTADO_COMP_ELECT', Pv_Mensaje);
  --
END P_UPDATE_ESTADO_COMP_ELECT;
--
/**
* Documentacion para el procedimiento P_MESSAGE_COMP_ELEC_INSRT
* Realiza el insert en la INFO_MENSAJE_COMP_ELEC siempre que el mensaje no exista.
* Pv_Tipo          IN INFO_MENSAJE_COMP_ELEC.TIPO%TYPE,
* Pv_Mensaje       IN INFO_MENSAJE_COMP_ELEC.MENSAJE%TYPE,
* Pv_InfoAdicional IN INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE,
* Pn_DocumentoId   IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
* Pd_FeCreacion    IN INFO_MENSAJE_COMP_ELEC.FE_CREACION%TYPE,
* Pv_Mensaje OUT VARCHAR2
* @version 1.0 03-06-2016
*/
PROCEDURE P_MESSAGE_COMP_ELEC_INSRT(
    Pv_Tipo          IN INFO_MENSAJE_COMP_ELEC.TIPO%TYPE,
    Pv_Mensaje       IN INFO_MENSAJE_COMP_ELEC.MENSAJE%TYPE,
    Pv_InfoAdicional IN INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE,
    Pn_DocumentoId   IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pd_FeCreacion    IN INFO_MENSAJE_COMP_ELEC.FE_CREACION%TYPE,
    Pv_MensajeOut OUT VARCHAR2)
IS
  --
  CURSOR C_GetMensaje(Cv_MesajeAdicional INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE, Cn_IdDocumento INFO_MENSAJE_COMP_ELEC.DOCUMENTO_ID%TYPE)
  IS
    SELECT IMCE.ID_MSN_COMP_ELEC
    FROM INFO_MENSAJE_COMP_ELEC IMCE
    WHERE IMCE.INFORMACION_ADICIONAL = Cv_MesajeAdicional
    AND IMCE.DOCUMENTO_ID            = Cn_IdDocumento;
  --
  CURSOR C_GetDocumento(Cn_IdDocumento DB_COMPROBANTES.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE)
  IS
    SELECT ICE.ID_COMP_ELECTRONICO,
      ICE.DOCUMENTO_ID
    FROM DB_COMPROBANTES.INFO_DOCUMENTO IDE,
      INFO_COMPROBANTE_ELECTRONICO ICE
    WHERE ICE.CLAVE_ACCESO = IDE.CLAVE_ACCESO
    AND IDE.ID_DOCUMENTO   = Cn_IdDocumento;
  --
  Lr_GetDocumento C_GetDocumento%ROWTYPE;
  Lr_GetMensaje C_GetMensaje%ROWTYPE;
BEGIN
  --
  IF C_GetDocumento%ISOPEN THEN
    --
    CLOSE C_GetDocumento;
    --
  END IF;
  --
  OPEN C_GetDocumento(Pn_DocumentoId);
  --
  FETCH C_GetDocumento INTO Lr_GetDocumento;
  --
  CLOSE C_GetDocumento;
  --
  IF Lr_GetDocumento.DOCUMENTO_ID IS NOT NULL THEN
    --
    IF C_GetMensaje%ISOPEN THEN
      --
      CLOSE C_GetMensaje;
      --
    END IF;
    --
    OPEN C_GetMensaje(Pv_InfoAdicional, Lr_GetDocumento.DOCUMENTO_ID);
    --
    FETCH C_GetMensaje INTO Lr_GetMensaje;
    --
    CLOSE C_GetMensaje;
    --
    IF Lr_GetMensaje.ID_MSN_COMP_ELEC IS NULL THEN
      --
      FNCK_COM_ELECTRONICO_TRAN.INSERT_MESSAGE_COMP_ELEC(Pv_Tipo, Pv_Mensaje, Pv_InfoAdicional, Lr_GetDocumento.DOCUMENTO_ID, Pd_FeCreacion);
      --
    END IF;
    --
  END IF;
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_MensajeOut := SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'Error en FNCK_COM_ELECTRONICO.P_MESSAGE_COMP_ELEC_INSRT', Pv_MensajeOut);
  --
END P_MESSAGE_COMP_ELEC_INSRT;
--
--
FUNCTION F_SET_ATTR_CONTRIBUCION(
    Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Fn_IdPersonalRol     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    Fn_IdDocumento       IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fn_SectorId          IN DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE,
    Fn_OficinaId         IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetContribucion(Cv_Parrafo VARCHAR2)
  IS
    SELECT XMLAGG(XMLELEMENT("campoAdicional", XMLATTRIBUTES('CONTRIBUCIONSOLIDARIA' AS "nombre"), Cv_Parrafo))
    FROM DUAL;
  --
  CURSOR C_GetCompensacion(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
                           Cv_TipoImpuestoIva DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE, 
                           Cv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE, 
                           Cv_TipoImpuestoCompensacion DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE )
  IS
    SELECT TRIM( TO_CHAR( ( ( ( (ROUND( NVL( SUM((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(IDFD.CANTIDAD, 0)) 
                                             - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0)), 0) 
                                        + NVL(DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_SUM_IMPUESTO_ICE_CAB(Cn_IdDocumento, AI.CODIGO_SRI), 0), 2) ) *
      (SELECT PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE ESTADO      = Cv_EstadoActivo
      AND TIPO_IMPUESTO = Cv_TipoImpuestoCompensacion
      ) )/100 ) ), '99999999990D99') ) VALOR_COMPENSADO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      DB_GENERAL.ADMI_IMPUESTO AI
    WHERE IDFC.ID_DOCUMENTO = IDFD.DOCUMENTO_ID
    AND IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
    AND AI.ID_IMPUESTO      = IDFI.IMPUESTO_ID
    AND IDFD.DOCUMENTO_ID   = Cn_IdDocumento
    AND AI.TIPO_IMPUESTO    = Cv_TipoImpuestoIva
    GROUP BY AI.CODIGO_SRI,
      AI.TIPO_IMPUESTO,
      IDFC.VALOR_TOTAL,
      AI.PORCENTAJE_IMPUESTO;
    --
    Lv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE          := '';
    Lr_Compensacion C_GetCompensacion%ROWTYPE                               := NULL;
    Lv_EsCompensado VARCHAR2(4)                                             := '';
    Lxml XMLTYPE                                                            := NULL;
    Lv_TipoImpuestoIva DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE          := 'IVA';
    Lv_TipoImpuestoCompensacion DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := 'COM';
    Lv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE                    := 'Activo';
  --
BEGIN
  --Obtiene el prefijo de la empresa
  Lv_PrefijoEmpresa := FNCK_CONSULTS.F_GET_PREFIJO_EMPRESA(Fv_CodEmpresa);
  --
  Lv_EsCompensado   := DB_FINANCIERO.FNCK_CONSULTS.F_VALIDA_CLIENTE_COMPENSADO( Fn_IdPersonalRol, 
                                                                                Fn_OficinaId, 
                                                                                Fv_CodEmpresa, 
                                                                                Fn_SectorId, 
                                                                                Fn_IdPunto );
  /*Valida que el ATTR se deba mostrar para un tipo de documento y empresa segun la configuracion de parametros y
    que para TN se genere el TAG siempre que la funcion F_VALIDA_CLIENTE_COMPENSADO sea igual a S*/
  IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Fv_CodEmpresa, TRIM(Fv_CodeTipoDocumento), 'contribucionSolidaria') AND
     Lv_PrefijoEmpresa = 'TN' AND TRIM(Lv_EsCompensado) IS NOT NULL AND TRIM(Lv_EsCompensado) = 'S' THEN --IF-ATTR_CONTRIBUCION
    --
    IF C_GetCompensacion%ISOPEN THEN
      --
      CLOSE C_GetCompensacion;
      --
    END IF;
    --
    OPEN C_GetCompensacion(Fn_IdDocumento, Lv_TipoImpuestoIva, Lv_EstadoActivo, Lv_TipoImpuestoCompensacion);
    --
    FETCH C_GetCompensacion INTO Lr_Compensacion;
    --
    CLOSE C_GetCompensacion;
    --
    IF C_GetContribucion%ISOPEN THEN
      --
      CLOSE C_GetContribucion;
      --
    END IF;
    --
    IF Lr_Compensacion.VALOR_COMPENSADO IS NOT NULL 
    AND Lr_Compensacion.VALOR_COMPENSADO <> '0.00' 
    AND TO_NUMBER(Lr_Compensacion.VALOR_COMPENSADO) >0 THEN
    --
        OPEN C_GetContribucion(Lr_Compensacion.VALOR_COMPENSADO);
        --
        FETCH C_GetContribucion INTO Lxml;
        --
        CLOSE C_GetContribucion;
    --
    END IF;
    --
  END IF; --IF-ATTR_CONTRIBUCION
  --
  RETURN Lxml;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ATTR_CONTRIBUCION', SQLERRM);
  --
  RETURN NULL;
  --
END F_SET_ATTR_CONTRIBUCION;
  --
  --
FUNCTION F_SET_ATTR_DET_ADICIONAL(
    Fv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetEmpresa(Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT PREFIJO
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE COD_EMPRESA = Cv_CodEmpresa;
  --
  CURSOR C_GetTag( Cv_Notificacion VARCHAR2, 
                        Cv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                        Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE )
  IS
    SELECT XMLAGG(XMLELEMENT( "campoAdicional", 
                              XMLATTRIBUTES('DETALLEADICIONAL' AS "nombre"), 
                              FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML( Cv_CampoAdicional, Cv_Validador, UPPER(Cv_Notificacion) ) ) )
    FROM DUAL;
  --
  Lxml XMLTYPE                                                     := NULL;
  Lv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   ;
  Lv_CampoAdicional DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'campoAdicional';
  Lv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'SUBSTRING';
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_Notificacion VARCHAR2(3000) ;
  --
BEGIN
  --
  IF C_GetEmpresa%ISOPEN THEN
    CLOSE C_GetEmpresa;
  END IF;
  --
  OPEN C_GetEmpresa(Fv_CodEmpresa);
  --
  FETCH C_GetEmpresa INTO Lv_CodEmpresa;
  --
  CLOSE C_GetEmpresa;
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ATTR_DET_ADICIONAL', 'Tratamos de entrar');
    --
    Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('SHOW_TAG_BY_EMPRESA', 
                                                                       'Activo', 
                                                                       'Activo', 
                                                                       NULL, 
                                                                       'detalle_adicional', 
                                                                       Fv_CodeTipoDocumento, 
                                                                       Lv_CodEmpresa);
    --
    FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ATTR_DET_ADICIONAL', 'Traemos '||Lr_GetAdmiParamtrosDet.VALOR3);
    --
    CLOSE Lrf_GetAdmiParamtrosDet;
    --
    IF Lr_GetAdmiParamtrosDet.VALOR1 IS NOT NULL THEN
      Lv_Notificacion                := Lr_GetAdmiParamtrosDet.VALOR1;
      
    END IF;
    --
    IF Lv_Notificacion IS NOT NULL THEN
      --
      IF C_GetTag%ISOPEN THEN
        CLOSE C_GetTag;
      END IF;
      --
      OPEN C_GetTag(Lv_Notificacion, Lv_CampoAdicional, Lv_Validador);
      --
      FETCH C_GetTag INTO Lxml;
      --
      CLOSE C_GetTag;
      
      --
    END IF;
    --
  --
  RETURN Lxml;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('DOCUMENTO_XML', 'FNCK_COM_ELECTRONICO.F_SET_ATTR_DET_ADICIONAL', SQLERRM);
  --
  RETURN NULL;
  --
END F_SET_ATTR_DET_ADICIONAL;
  --
  --
  FUNCTION F_GET_CONTRIBUCION_SOLIDARIA(
      Pn_DescuentoCompensacion IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE,
      Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_CodTipoDocumento      IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
    RETURN XMLTYPE
  IS
    --
    CURSOR C_GetContribucionSolidaria(Cn_DescuentoCompensacion DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE, 
                                      Cn_CodigoSri DB_GENERAL.ADMI_IMPUESTO.CODIGO_SRI%TYPE, 
                                      Cn_Tarifa DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE)
    IS
      SELECT XMLELEMENT("compensaciones", 
               XMLELEMENT("compensacion", 
                 XMLFOREST( TRIM(NVL(Cn_CodigoSri, 1)) "codigo", 
                            TRIM(NVL(Cn_Tarifa, 2)) "tarifa", 
                            TRIM(TO_CHAR(NVL(Cn_DescuentoCompensacion, 0),'99999999990D99')) "valor") ) )
      FROM DUAL;
    --
    CURSOR C_GetAdmiImpuesto(Cv_EstadoImpuesto DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE, Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    IS
      SELECT ID_IMPUESTO, CODIGO_SRI, PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE ESTADO      = Cv_EstadoImpuesto
      AND TIPO_IMPUESTO = Cv_TipoImpuesto;
    --
    LXML_ContribucionSolidaria XMLTYPE                          := NULL;
    Lr_AdmiImpuesto C_GetAdmiImpuesto%ROWTYPE                   := NULL;
    Lv_EstadoImpuesto DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE      := 'Activo';
    Lv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := 'COM';
    Lv_TagCompensaciones VARCHAR2(15)                           := 'compensaciones';
    --
  BEGIN
    --
    IF DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Pv_CodEmpresa, TRIM(Pv_CodTipoDocumento), Lv_TagCompensaciones) THEN
      --
      IF Pn_DescuentoCompensacion IS NOT NULL AND Pn_DescuentoCompensacion > 0 THEN
        --
        IF C_GetAdmiImpuesto%ISOPEN THEN
          --
          CLOSE C_GetAdmiImpuesto;
          --
        END IF;
        --
        OPEN C_GetAdmiImpuesto(Lv_EstadoImpuesto, Lv_TipoImpuesto);
        --
        FETCH C_GetAdmiImpuesto INTO Lr_AdmiImpuesto;
        --
        CLOSE C_GetAdmiImpuesto;
        --
        IF Lr_AdmiImpuesto.ID_IMPUESTO IS NOT NULL AND Lr_AdmiImpuesto.ID_IMPUESTO > 0 THEN
          --
          IF C_GetContribucionSolidaria%ISOPEN THEN
            --
            CLOSE C_GetContribucionSolidaria;
            --
          END IF;
          --
          OPEN C_GetContribucionSolidaria(Pn_DescuentoCompensacion, Lr_AdmiImpuesto.CODIGO_SRI, Lr_AdmiImpuesto.PORCENTAJE_IMPUESTO);
          --
          FETCH C_GetContribucionSolidaria INTO LXML_ContribucionSolidaria;
          --
          CLOSE C_GetContribucionSolidaria;
          --
        END IF;
        --
      END IF;
      --
    END IF;
    --
    --
    RETURN LXML_ContribucionSolidaria;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    LXML_ContribucionSolidaria := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_COM_ELECTRONICO.F_GET_CONTRIBUCION_SOLIDARIA', 
                                          'No se pudo obtener los tags de la compensacion - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN LXML_ContribucionSolidaria;
    --
  END F_GET_CONTRIBUCION_SOLIDARIA;
  --
  --
  FUNCTION F_GET_COD_SRI_BY_BANCO_CUENTA(
      Fn_IdContratoOrPersona IN NUMBER,
      Fv_Filtro              IN VARCHAR2,
      Fv_CodigoFormaPago     IN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
      Fv_CodigoSri           IN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE)
    RETURN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE
  IS
    --
    CURSOR C_GetCodigoSri( Cv_CodigoFormaPago DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE )
    IS
      SELECT CODIGO_SRI
      FROM DB_GENERAL.ADMI_FORMA_PAGO
      WHERE CODIGO_FORMA_PAGO = Cv_CodigoFormaPago;
    --
    CURSOR C_GetBancoTipoCtaByContrato( Cn_IdContrato         DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE, 
                                        Cv_CodigoFormaPago    DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE, 
                                        Cv_EstadoParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE, 
                                        Cv_NombreParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE )
    IS
      SELECT ICFP.BANCO_TIPO_CUENTA_ID
      FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP,
           DB_GENERAL.ADMI_BANCO_TIPO_CUENTA     ABTC,
           DB_GENERAL.ADMI_TIPO_CUENTA           ATC,
           DB_GENERAL.ADMI_BANCO                 AB
      WHERE AB.ID_BANCO             = ABTC.BANCO_ID
      AND ICFP.BANCO_TIPO_CUENTA_ID = ABTC.ID_BANCO_TIPO_CUENTA
      AND ATC.ID_TIPO_CUENTA        = ABTC.TIPO_CUENTA_ID
      AND ( AB.DESCRIPCION_BANCO    IN
            ( SELECT DESCRIPCION
              FROM DB_GENERAL.ADMI_PARAMETRO_DET
              WHERE PARAMETRO_ID =
                (
                  SELECT ID_PARAMETRO
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                  WHERE ESTADO         =  Cv_EstadoParametroCab
                  AND NOMBRE_PARAMETRO =  Cv_NombreParametroCab
                )
              AND VALOR1         = Cv_CodigoFormaPago
            )

            OR ATC.DESCRIPCION_CUENTA LIKE '%TARJETA%'
          )
      AND ICFP.ID_DATOS_PAGO =
        (SELECT MAX(ID_DATOS_PAGO)
        FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO
        WHERE CONTRATO_ID = Cn_IdContrato
        );
      --
      CURSOR C_GetBancoTipoCtaByPersonaRol( Cn_IdPersonaRol       DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                                            Cv_CodigoFormaPago    DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE, 
                                            Cv_EstadoParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE, 
                                            Cv_NombreParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE )
      IS
        SELECT IPEFP.BANCO_TIPO_CUENTA_ID
        FROM DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO IPEFP,
             DB_GENERAL.ADMI_BANCO_TIPO_CUENTA        ABTC,
             DB_GENERAL.ADMI_BANCO                    AB,
             DB_GENERAL.ADMI_TIPO_CUENTA              ATC
        WHERE AB.ID_BANCO                = ABTC.BANCO_ID
        AND   IPEFP.BANCO_TIPO_CUENTA_ID = ABTC.ID_BANCO_TIPO_CUENTA
        AND   ATC.ID_TIPO_CUENTA         = ABTC.TIPO_CUENTA_ID
        AND ( AB.DESCRIPCION_BANCO       IN
              ( SELECT DESCRIPCION
                FROM DB_GENERAL.ADMI_PARAMETRO_DET
                WHERE PARAMETRO_ID       =
                  (   SELECT ID_PARAMETRO
                      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                      WHERE ESTADO           = Cv_EstadoParametroCab
                      AND   NOMBRE_PARAMETRO = Cv_NombreParametroCab
                  )
                AND VALOR1               = Cv_CodigoFormaPago
              )

              OR ATC.DESCRIPCION_CUENTA LIKE '%TARJETA%'
          )
        AND IPEFP.ID_DATOS_PAGO =
          (SELECT MAX(ID_DATOS_PAGO)
          FROM DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO
          WHERE PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
          );
        --
        Lv_CodigoSri VARCHAR2(10);
        Lv_EstadoParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                  := 'Activo';
        Lv_NombreParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE        := 'DESCRIPCION_BANCO_PARA_XML';
        Ln_BancoTipoCuentaId DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE := 0;
        --
      BEGIN
        --
        IF Fv_Filtro = 'CONTRATO' THEN
          --
          IF C_GetBancoTipoCtaByContrato%ISOPEN THEN
            --
            CLOSE C_GetBancoTipoCtaByContrato;
            --
          END IF;
          --
          OPEN C_GetBancoTipoCtaByContrato(Fn_IdContratoOrPersona, Fv_CodigoFormaPago, Lv_EstadoParametroCab, Lv_NombreParametroCab);
          --
          FETCH C_GetBancoTipoCtaByContrato INTO Ln_BancoTipoCuentaId;
          --
          CLOSE C_GetBancoTipoCtaByContrato;
          --
        ELSIF Fv_Filtro = 'PERSONA' THEN
          --
          IF C_GetBancoTipoCtaByPersonaRol%ISOPEN THEN
            --
            CLOSE C_GetBancoTipoCtaByPersonaRol;
            --
          END IF;
          --
          OPEN C_GetBancoTipoCtaByPersonaRol(Fn_IdContratoOrPersona, Fv_CodigoFormaPago, Lv_EstadoParametroCab, Lv_NombreParametroCab);
          --
          FETCH C_GetBancoTipoCtaByPersonaRol INTO Ln_BancoTipoCuentaId;
          --
          CLOSE C_GetBancoTipoCtaByPersonaRol;
          --
        END IF;
        --
        IF Ln_BancoTipoCuentaId IS NOT NULL AND Ln_BancoTipoCuentaId > 0 THEN
          --
          IF C_GetCodigoSri%ISOPEN THEN
            --
            CLOSE C_GetCodigoSri;
            --
          END IF;
          --
          OPEN C_GetCodigoSri(Fv_CodigoFormaPago);
          --
          FETCH C_GetCodigoSri INTO Lv_CodigoSri;
          --
          CLOSE C_GetCodigoSri;
          --
        ELSE
          --
          Lv_CodigoSri := Fv_CodigoSri;
          --
        END IF;
        --
        RETURN Lv_CodigoSri;
        --
      EXCEPTION
      WHEN OTHERS THEN
        --
        Lv_CodigoSri := NULL;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_COM_ELECTRONICO.F_GET_COD_SRI_BY_BANCO_CUENTA', 
                                              'No se pudo obtener el codigo del SRI del id ('|| Fn_IdContratoOrPersona ||'), filtro ('
                                              ||Fv_Filtro||') - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
        RETURN Lv_CodigoSri;
        --
      END F_GET_COD_SRI_BY_BANCO_CUENTA;
  --
  --
  FUNCTION F_VALIDACION_FORMATO_XML(
      Fv_Tag       IN DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
      Fv_Validador IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
      Fv_ValorTag  IN VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR C_GetValoresAValidar( Cv_Validador DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE, 
                                 Cv_Tag DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                                 Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE, 
                                 Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE )
    IS
      SELECT APD.ID_PARAMETRO_DET,
        APD.DESCRIPCION,
        APD.VALOR1,
        APD.VALOR2,
        APD.VALOR3
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
        DB_GENERAL.ADMI_PARAMETRO_CAB APC
      WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
      AND APC.ESTADO           = Cv_EstadoActivo
      AND APD.ESTADO           = Cv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APD.DESCRIPCION      = Cv_Tag
      AND APD.VALOR1           = Cv_Validador;
    --
    Lv_EstadoParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE           := 'Activo';
    Lv_NombreParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'VALIDACION_FACTURA_XML_1_0_0';
    Lr_ValoresAValidar C_GetValoresAValidar%ROWTYPE;
    Lv_Resultado VARCHAR2(1000) := TRIM(Fv_ValorTag);
    --
  BEGIN
    --
    IF Lv_Resultado IS NOT NULL THEN
      --
      IF C_GetValoresAValidar%ISOPEN THEN
        --
        CLOSE C_GetValoresAValidar;
        --
      END IF;
      --
      OPEN C_GetValoresAValidar(Fv_Validador, Fv_Tag, Lv_EstadoParametroCab, Lv_NombreParametroCab);
      --
      FETCH C_GetValoresAValidar INTO Lr_ValoresAValidar;
      --
      CLOSE C_GetValoresAValidar;
      --
      IF Lr_ValoresAValidar.ID_PARAMETRO_DET IS NOT NULL AND Lr_ValoresAValidar.ID_PARAMETRO_DET > 0 THEN
        --
        IF TRIM(Lr_ValoresAValidar.VALOR1) IS NOT NULL THEN
          --
          IF TRIM(Lr_ValoresAValidar.VALOR1) = 'SUBSTRING' THEN
            --
            Lr_ValoresAValidar.VALOR2 := TO_NUMBER(Lr_ValoresAValidar.VALOR2, '9999');
            Lr_ValoresAValidar.VALOR3 := TO_NUMBER(Lr_ValoresAValidar.VALOR3, '9999');
            --
            IF Lr_ValoresAValidar.VALOR2 IS NOT NULL AND Lr_ValoresAValidar.VALOR2 > 0 
               AND Lr_ValoresAValidar.VALOR3 IS NOT NULL AND Lr_ValoresAValidar.VALOR3 > 0 THEN
              --
              Lv_Resultado := TRIM(SUBSTR(Lv_Resultado, Lr_ValoresAValidar.VALOR2, Lr_ValoresAValidar.VALOR3));
              --
            END IF;
            --
          END IF;
          --
        END IF;
        --
      END IF;
      --
    END IF;
    --
    RETURN Lv_Resultado;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_Resultado := TRIM(Fv_ValorTag);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_COM_ELECTRONICO.F_VALIDACION_FORMATO_XML', 
                                          'No se pudo realizar la validacion del formato XML con los par�metros enviados ( TAG: '|| Fv_Tag || 
                                          '; VALIDADOR: ' || Fv_Validador || '; VALOR_TAG: ' || Fv_ValorTag || ') - ' || SQLCODE || ' -ERROR- ' 
                                          || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lv_Resultado;
    --
  END F_VALIDACION_FORMATO_XML;

  FUNCTION F_GET_VARCHAR_VALID_XML_VALUE(
    Fv_Cadena IN VARCHAR2)
  RETURN VARCHAR2
  IS
    Lv_expresionRegular DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE;
    Lv_caracterDeReemplazo DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE;

    Lv_caracteresTranslateIn DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE;
    Lv_caracteresTranslateOut DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE;
  BEGIN

    SELECT valor2,
      valor3
    INTO Lv_expresionRegular,
      Lv_caracterDeReemplazo
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB a,
      DB_GENERAL.ADMI_PARAMETRO_DET b
    WHERE a.id_parametro   = b.parametro_id
    AND a.NOMBRE_PARAMETRO = 'VALIDACION_VALOR_TAG_XML'
    AND a.estado           = 'Activo'
    AND b.valor1           = 'EXPRESION_REGULAR'
    AND b.estado           = 'Activo'
    AND b.empresa_cod      = 10;

    SELECT valor2,
      valor3
    INTO Lv_caracteresTranslateIn,
      Lv_caracteresTranslateOut
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB a,
      DB_GENERAL.ADMI_PARAMETRO_DET b
    WHERE a.id_parametro   = b.parametro_id
    AND a.NOMBRE_PARAMETRO = 'VALIDACION_VALOR_TAG_XML'
    AND a.estado           = 'Activo'
    AND b.valor1           = 'CARACTERES_TRANSLATE'
    AND b.estado           = 'Activo'
    AND b.empresa_cod      = 10;

    RETURN DB_GENERAL.GNRLPCK_UTIL.F_GET_VARCHAR_REPLACED(FV_CADENA                 => Fv_Cadena,
                                                          FV_EXPRESIONREGULAR       => Lv_expresionRegular,
                                                          FV_CARACTERREEMPLAZO      => Lv_caracterDeReemplazo,
                                                          FV_CARACTERESTRANSLATEIN  => Lv_caracteresTranslateIn,
                                                          FV_CARACTERESTRANSLATEOUT => Lv_caracteresTranslateOut);

  END F_GET_VARCHAR_VALID_XML_VALUE;
  --
  --
  FUNCTION F_GET_DESCRIPCION_DET(
    Fn_IdDocDetalle     IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE, 
    Fv_PrefijoEmpresa   IN VARCHAR2)
  RETURN INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE
  IS
  --
  CURSOR C_GetDescripcionDet(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  IS
    SELECT TRIM(FNCK_COM_ELECTRONICO.GET_LONG_TO_VARCHAR(IDFD.ROWID))
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
    WHERE IDFD.ID_DOC_DETALLE = Cn_IdDocDetalle;
  --
  CURSOR C_GetNombrePlan(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  IS
    SELECT 
        CASE
          WHEN IDFD.PLAN_ID IS NULL
          OR IDFD.PLAN_ID    = 0
          THEN
            (
             SELECT SUBSTR(TRIM(AP.DESCRIPCION_PRODUCTO), 1, 300)
             FROM ADMI_PRODUCTO AP
             WHERE AP.ID_PRODUCTO = IDFD.PRODUCTO_ID
            )
          WHEN IDFD.PRODUCTO_ID IS NULL
          OR IDFD.PRODUCTO_ID    = 0
          THEN
            (
             SELECT SUBSTR(TRIM(IPC.NOMBRE_PLAN), 1, 300)
             FROM INFO_PLAN_CAB IPC
             WHERE IPC.ID_PLAN = IDFD.PLAN_ID
            )
        END
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
    WHERE IDFD.ID_DOC_DETALLE = Cn_IdDocDetalle;
  --
  CURSOR C_GetUsrCreacionFact(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  IS 
    SELECT IDFC.USR_CREACION
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
    WHERE IDFC.ID_DOCUMENTO   = IDFD.DOCUMENTO_ID
    AND   IDFD.ID_DOC_DETALLE =  Cn_IdDocDetalle;
  --
  CURSOR C_GetDescripcionInicial(Cn_IdDocDetalle INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  IS 
    SELECT
        CASE
        WHEN IDFD.PLAN_ID IS NULL
        OR IDFD.PLAN_ID    = 0
        THEN
          (SELECT SUBSTR(TRIM(AP.DESCRIPCION_PRODUCTO), 1, 300)
          FROM ADMI_PRODUCTO AP
          WHERE AP.ID_PRODUCTO = IDFD.PRODUCTO_ID
          )
        WHEN IDFD.PRODUCTO_ID IS NULL
        OR IDFD.PRODUCTO_ID    = 0
        THEN
          (SELECT SUBSTR(TRIM(IPC.NOMBRE_PLAN), 1, 300)
          FROM INFO_PLAN_CAB IPC
          WHERE IPC.ID_PLAN = IDFD.PLAN_ID
          )
      END
      || ' '
      || TRIM(FNCK_COM_ELECTRONICO.GET_LONG_TO_VARCHAR(IDFD.ROWID))
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
      WHERE IDFD.ID_DOC_DETALLE = Cn_IdDocDetalle;
  --
  --
  Lv_DescripcionDet       INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE := NULL;
  Lv_DescripcionTmp       INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE := NULL;
  Lv_DescripcionTmp1      INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE := NULL;
  Lv_DescripcionTmp2      INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE := NULL;
  Lv_UsrCreacionDoc       INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE            := NULL;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE                      := NULL;
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lv_EstadoActivo         DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE                       := 'Activo';
  Lv_NombreParametroCab   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE        := 'DESCRIPCION_TIPO_FACTURACION';
  Lv_NombrePlan           VARCHAR2(1000);
  Ln_PosicionParametro    NUMBER                                                     := 0;
  --
  BEGIN
  --
  IF Fn_IdDocDetalle     IS NOT NULL AND
     Fv_PrefijoEmpresa   IS NOT NULL THEN
     --

      IF C_GetUsrCreacionFact%ISOPEN THEN
          CLOSE C_GetUsrCreacionFact;
      END IF;
      --
      OPEN C_GetUsrCreacionFact(Fn_IdDocDetalle);
       --
      FETCH C_GetUsrCreacionFact INTO Lv_UsrCreacionDoc;
      --
      IF C_GetUsrCreacionFact%ISOPEN THEN
        --
        CLOSE C_GetUsrCreacionFact;
        --
      END IF;
      --
      --Busco el parametro de busqueda por usuario de creacion y prefijo empresa.
      Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_NombreParametroCab, 
                                                                         Lv_EstadoActivo, 
                                                                         Lv_EstadoActivo, 
                                                                         Lv_UsrCreacionDoc,
                                                                         NULL, 
                                                                         NULL,
                                                                         Fv_PrefijoEmpresa
                                                                         );
      --
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --
      --
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND 
         TRIM(Lr_GetAdmiParamtrosDet.VALOR1)     IS NOT NULL THEN
         --
            --Recupero la descripcion de la factura.
            IF C_GetDescripcionDet%ISOPEN THEN
              CLOSE C_GetDescripcionDet;
            END IF;
            --
            OPEN C_GetDescripcionDet(Fn_IdDocDetalle);
            --
            FETCH C_GetDescripcionDet INTO Lv_DescripcionTmp;
            --
            IF C_GetDescripcionDet%ISOPEN THEN
              --
              CLOSE C_GetDescripcionDet;
              --
            END IF;
            --
            --Recupero el nombre del plan del 
            IF C_GetNombrePlan%ISOPEN THEN
              CLOSE C_GetNombrePlan;
            END IF;
            --
            OPEN C_GetNombrePlan(Fn_IdDocDetalle);
            --
            FETCH C_GetNombrePlan INTO Lv_NombrePlan;
            --
            IF C_GetNombrePlan%ISOPEN THEN
              --
              CLOSE C_GetNombrePlan;
              --
            END IF;
         --
         --Verifico si la factura fue creada por: 
         --telcos_reactivacion o telcos_proporcional
         IF TRIM(Lr_GetAdmiParamtrosDet.VALOR1) = 'telcos_reactivacion' OR
            TRIM(Lr_GetAdmiParamtrosDet.VALOR1) = 'telcos_proporcional' OR
            TRIM(Lr_GetAdmiParamtrosDet.VALOR1) = 'telcos_cancelacion' OR
            TRIM(Lr_GetAdmiParamtrosDet.VALOR1) = 'telcos'              OR 
            TRIM(Lr_GetAdmiParamtrosDet.VALOR1) = 'telcos_cambioPrecio' THEN
            --
            Ln_PosicionParametro := INSTR( Lv_DescripcionTmp , Lr_GetAdmiParamtrosDet.VALOR2 );
            Lv_DescripcionTmp1   := SUBSTR(Lv_DescripcionTmp, 0, Ln_PosicionParametro -1 );
            Lv_DescripcionTmp2   := SUBSTR(Lv_DescripcionTmp, Ln_PosicionParametro);
            --
            --Uno el nombre del plan a la descripcion.
            Lv_DescripcionDet := Lv_DescripcionTmp1 || ' ' ||Lv_NombrePlan || ' ' || Lv_DescripcionTmp2;
            --
            --
         ELSIF TRIM(Lr_GetAdmiParamtrosDet.VALOR1) = 'telcos_contrato'     OR
               TRIM(Lr_GetAdmiParamtrosDet.VALOR1) = 'telcos_req_clientes' THEN
            --
            --Agrego el nombre del plan al final de la descripcion.
            Lv_DescripcionDet := Lv_DescripcionTmp || ' ' || Lv_NombrePlan;
            --
         ELSE
            Lv_DescripcionDet := Lv_DescripcionTmp;
        END IF;

      ELSE
        --
          IF C_GetDescripcionInicial%ISOPEN THEN
            CLOSE C_GetDescripcionInicial;
          END IF;
          --
          OPEN C_GetDescripcionInicial(Fn_IdDocDetalle);
          --
          FETCH C_GetDescripcionInicial INTO Lv_DescripcionDet;
          --
          IF C_GetDescripcionInicial%ISOPEN THEN
            CLOSE C_GetDescripcionInicial;
          END IF;
        --
      END IF;
     --
  END IF;
  --
  RETURN Lv_DescripcionDet;
  --
  END F_GET_DESCRIPCION_DET;
  --
  --
  PROCEDURE P_UPDATE_INFO_DOC_FIN_CAB( Pn_IdDocumento  IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                       Pv_Estado       IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                                       Pv_MsnError    OUT VARCHAR2)
  IS
  BEGIN
    UPDATE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
    SET      
       ESTADO_IMPRESION_FACT = Pv_Estado
    WHERE ID_DOCUMENTO       = Pn_IdDocumento ;

  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsnError:=' Error en FNCK_COM_ELECTRONICO.P_UPDATE_INFO_DOC_FIN_CAB' || SQLERRM;
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', ' Error en FNCK_COM_ELECTRONICO.P_UPDATE_INFO_DOC_FIN_CAB', '' || SQLERRM);
    --
  END P_UPDATE_INFO_DOC_FIN_CAB;
  --
  --
  FUNCTION F_GET_ULTIMO_ESTADO_DOC(Fn_IdDocumento  IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE
  IS
  --
  CURSOR C_GetUltimoEstadoDoc(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT MAX(ESTADO) 
      FROM INFO_DOCUMENTO_HISTORIAL 
    WHERE ESTADO NOT IN('Rechazado') AND DOCUMENTO_ID = Cn_IdDocumento;
  --
  --
  Lv_MaxEstado  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE;

  BEGIN
  --
    IF C_GetUltimoEstadoDoc%ISOPEN THEN
        CLOSE C_GetUltimoEstadoDoc;
    END IF;
    --
    OPEN C_GetUltimoEstadoDoc(Fn_IdDocumento);
       FETCH C_GetUltimoEstadoDoc INTO Lv_MaxEstado;   
    CLOSE C_GetUltimoEstadoDoc;
    --       
    IF Lv_MaxEstado = 'Pendiente' THEN
      Lv_MaxEstado := 'Activo';
    END IF;
    --
    RETURN Lv_MaxEstado;
  --
  END F_GET_ULTIMO_ESTADO_DOC;
  --
  --
  PROCEDURE P_CREA_PM_FACT_RECHAZADAS(Pv_UsrCreacion     IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                      Pv_CodEmpresa      IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pv_IpCreacion      IN  VARCHAR2,
                                      Pv_TipoPma         IN  VARCHAR2,
                                      Pv_MsjResultado    OUT VARCHAR2)
  IS  

    Lv_IpCreacion             VARCHAR2(20) := (NVL(Pv_IpCreacion,'127.0.0.1'));
    Ln_IdProcesoMasivoCab     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdProcesoMasivoDet     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;     
    Lr_InfoProcesoMasivoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;    
    Lex_Exception             EXCEPTION;

  BEGIN  
    --    
    Ln_IdProcesoMasivoCab                             := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;
    Lr_InfoProcesoMasivoCab                           := NULL;
    Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB     := Ln_IdProcesoMasivoCab;
    Lr_InfoProcesoMasivoCab.TIPO_PROCESO              := Pv_TipoPma;
    Lr_InfoProcesoMasivoCab.EMPRESA_ID                := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Pv_CodEmpresa,'^\d+')),0);
    Lr_InfoProcesoMasivoCab.CANAL_PAGO_LINEA_ID       := NULL;
    Lr_InfoProcesoMasivoCab.CANTIDAD_PUNTOS           := 0;
    Lr_InfoProcesoMasivoCab.CANTIDAD_SERVICIOS        := 0;
    Lr_InfoProcesoMasivoCab.FACTURAS_RECURRENTES      := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_EMISION_FACTURA     := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_CORTE_DESDE         := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_CORTE_HASTA         := NULL;
    Lr_InfoProcesoMasivoCab.VALOR_DEUDA               := NULL;
    Lr_InfoProcesoMasivoCab.FORMA_PAGO_ID             := NULL;
    Lr_InfoProcesoMasivoCab.IDS_BANCOS_TARJETAS       := NULL;
    Lr_InfoProcesoMasivoCab.IDS_OFICINAS              := NULL;
    Lr_InfoProcesoMasivoCab.ESTADO                    := 'Creado';
    Lr_InfoProcesoMasivoCab.FE_CREACION               := SYSDATE;
    Lr_InfoProcesoMasivoCab.FE_ULT_MOD                := NULL;
    Lr_InfoProcesoMasivoCab.USR_CREACION              := Pv_UsrCreacion;
    Lr_InfoProcesoMasivoCab.USR_ULT_MOD               := NULL;
    Lr_InfoProcesoMasivoCab.IP_CREACION               := Lv_IpCreacion;
    Lr_InfoProcesoMasivoCab.PLAN_ID                   := NULL;
    Lr_InfoProcesoMasivoCab.PLAN_VALOR                := NULL;
    Lr_InfoProcesoMasivoCab.PAGO_ID                   := NULL;
    Lr_InfoProcesoMasivoCab.PAGO_LINEA_ID             := NULL;
    Lr_InfoProcesoMasivoCab.RECAUDACION_ID            := NULL;
    Lr_InfoProcesoMasivoCab.DEBITO_ID                 := NULL;
    Lr_InfoProcesoMasivoCab.ELEMENTO_ID               := NULL;
    Lr_InfoProcesoMasivoCab.SOLICITUD_ID              := NULL;
    --
    DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSERT_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Pv_MsjResultado);
    IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
    --
      RAISE Lex_Exception;
    --
    END IF;
    -- INSERTO DETALLE DE PROCESO MASIVO
    Ln_IdProcesoMasivoDet                            :=DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
    Lr_InfoProcesoMasivoDet                          :=NULL;
    Lr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET    :=Ln_IdProcesoMasivoDet;
    Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID    :=Ln_IdProcesoMasivoCab;
    Lr_InfoProcesoMasivoDet.PUNTO_ID                 :=Ln_IdProcesoMasivoCab;
    Lr_InfoProcesoMasivoDet.ESTADO                   :='Pendiente';
    Lr_InfoProcesoMasivoDet.FE_CREACION              :=SYSDATE;
    Lr_InfoProcesoMasivoDet.FE_ULT_MOD               :=NULL;
    Lr_InfoProcesoMasivoDet.USR_CREACION             :=Pv_UsrCreacion;
    Lr_InfoProcesoMasivoDet.USR_ULT_MOD              :=NULL;
    Lr_InfoProcesoMasivoDet.IP_CREACION              :=Lv_IpCreacion;
    Lr_InfoProcesoMasivoDet.SERVICIO_ID              :=NULL;
    Lr_InfoProcesoMasivoDet.OBSERVACION              :='Se creo exitosamente el Proceso ReproFactRechazo';
    Lr_InfoProcesoMasivoDet.SOLICITUD_ID             :=NULL;
    Lr_InfoProcesoMasivoDet.PERSONA_EMPRESA_ROL_ID   :=null;             
    --
    DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSERT_INFO_PROC_MASIVO_DET(Lr_InfoProcesoMasivoDet, Pv_MsjResultado);
    IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
    --
      RAISE Lex_Exception;
    --
    END IF;
    --ACTUALIZO CABECERA DE PROCESO MASIVO A PENDIENTE  
    --
    Lr_InfoProcesoMasivoCab.FE_ULT_MOD        := SYSDATE;
    Lr_InfoProcesoMasivoCab.USR_ULT_MOD       := Pv_UsrCreacion;    
    Lr_InfoProcesoMasivoCab.ESTADO            := 'Pendiente';   

    --
    DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_UPDATE_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Pv_MsjResultado);
    IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
    --
      RAISE Lex_Exception;
    --
    END IF;
    --
    COMMIT;
    Pv_MsjResultado := 'OK';
    EXCEPTION
      --
      WHEN Lex_Exception THEN
        ROLLBACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'FNCK_COM_ELECTRONICO.P_CREA_PM_FACT_RECHAZADAS', 
                                             Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                             'reproceso_fact',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
      WHEN OTHERS THEN
      --
        Pv_MsjResultado      := 'Ocurri� un error al guardar el Proceso Masivo '||Pv_TipoPma; 
        ROLLBACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'FNCK_COM_ELECTRONICO.P_CREA_PM_FACT_RECHAZADAS', 
                                             Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                             'reproceso_fact',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  END P_CREA_PM_FACT_RECHAZADAS;
  --
  --
  PROCEDURE P_PROCESAR_FACT_RECHAZADAS ( Pv_CodEmpresa       IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_TipoTransaccion  IN  VARCHAR2,
                                         Pv_IdsDocumento     IN  VARCHAR2)
  IS
    CURSOR C_GetFacturasRechazadas(Cv_EstadoRechazado  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE, 
                                   Cv_TipoMensaje      DB_FINANCIERO.INFO_MENSAJE_COMP_ELEC.TIPO%TYPE,
                                   Cv_CodEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE )
    IS
      SELECT IDFC.ID_DOCUMENTO, 
             ATDF.ID_TIPO_DOCUMENTO,
             IOG.EMPRESA_ID

        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC,
             DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
             DB_COMERCIAL.INFO_OFICINA_GRUPO              IOG,
             DB_FINANCIERO.INFO_MENSAJE_COMP_ELEC         IMEN

      WHERE ATDF.ID_TIPO_DOCUMENTO              = IDFC.TIPO_DOCUMENTO_ID
        AND IDFC.OFICINA_ID                     = IOG.ID_OFICINA
        AND IOG.EMPRESA_ID                      = Cv_CodEmpresa
        AND IDFC.ID_DOCUMENTO                   = IMEN.DOCUMENTO_ID
        AND IDFC.ESTADO_IMPRESION_FACT          = Cv_EstadoRechazado
        AND TO_CHAR(IDFC.FE_EMISION,'MM-RRRR')  = TO_CHAR(SYSDATE,'MM-RRRR')
        AND ATDF.CODIGO_TIPO_DOCUMENTO          IN ('FAC','FACP')
        AND IMEN.TIPO                           = Cv_TipoMensaje 

      GROUP BY IDFC.ID_DOCUMENTO, 
               ATDF.ID_TIPO_DOCUMENTO,
               IOG.EMPRESA_ID; 
    --
    --
    CURSOR C_GetProcesoMasivo(Cv_EstadoPendiente  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
                              Cv_TipoProceso      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE)
    IS
      SELECT IPMC.ID_PROCESO_MASIVO_CAB,
             IPMD.ID_PROCESO_MASIVO_DET
        FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB IPMC,
             DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET IPMD 
      WHERE IPMC.ID_PROCESO_MASIVO_CAB = IPMD.PROCESO_MASIVO_CAB_ID
        AND IPMC.TIPO_PROCESO          = Cv_TipoProceso
        AND IPMC.ESTADO                = Cv_EstadoPendiente
        AND ROWNUM                     = 1;  
    --
    --
    CURSOR C_GetDocFinanciero(Cn_IdDocumento  IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT IDFC.ID_DOCUMENTO, 
             ATDF.ID_TIPO_DOCUMENTO,
             IOG.EMPRESA_ID
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC,
             DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
             DB_COMERCIAL.INFO_OFICINA_GRUPO              IOG
      WHERE ATDF.ID_TIPO_DOCUMENTO         = IDFC.TIPO_DOCUMENTO_ID
        AND IDFC.OFICINA_ID                = IOG.ID_OFICINA
        AND IDFC.ID_DOCUMENTO              = Cn_IdDocumento;  
    --
    --
    Lv_Ruc                   VARCHAR2(13);
    LXML_Comprobante         CLOB;
    Lv_NombreComprobante     VARCHAR2(400);
    Lv_NombreTipoComprobante DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE;
    Lv_Anio                  VARCHAR2(4);
    Lv_Mes                   VARCHAR2(10);
    Lv_Dia                   VARCHAR2(2);
    Lv_MessageError          VARCHAR2(4000);
    Lv_MsnError              VARCHAR2(1000); 
    Ln_IdProcesoMasivoCab    NUMBER; 
    Ln_IdProcesoMasivoDet    NUMBER; 
    Lr_InfoProcesoMasivoCab  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;    
    Lv_EstadoPendiente       DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE                  := 'Pendiente';
    Lv_EstadoRechazado       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE  := 'Rechazado';
    Lv_EstadoFinalizado      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE                  := 'Finalizado';
    Lv_TipoProceso           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE            := 'ReproFactRechazo';
    Lv_TipoMensaje           DB_FINANCIERO.INFO_MENSAJE_COMP_ELEC.TIPO%TYPE                          := 'ERROR';
    Lv_TipoTransaccion       VARCHAR2(10)                                                            := 'UPDATE';
    Lv_UsrCreacion           VARCHAR2(20)                                                            := 'reproceso_fact';
    Lv_IpCreacion            VARCHAR2(20)                                                            := ('127.0.0.1');
    Lc_GetDocFinanciero      C_GetDocFinanciero%ROWTYPE;


  BEGIN

    IF C_GetFacturasRechazadas%ISOPEN THEN
      CLOSE C_GetFacturasRechazadas;
    END IF;
    --
    IF C_GetProcesoMasivo%ISOPEN THEN
      CLOSE C_GetProcesoMasivo;
    END IF;
    --
    IF C_GetDocFinanciero%ISOPEN THEN
      CLOSE C_GetDocFinanciero;
    END IF;
    --
    OPEN C_GetProcesoMasivo(Lv_EstadoPendiente,Lv_TipoProceso);
       FETCH C_GetProcesoMasivo INTO Ln_IdProcesoMasivoCab, Ln_IdProcesoMasivoDet ;   
    CLOSE C_GetProcesoMasivo;
    --       
    IF Ln_IdProcesoMasivoCab IS NOT NULL THEN
       
      IF Pv_TipoTransaccion = 'MASIVO' THEN

        FOR Lc_GetFacturasRechazadas IN C_GetFacturasRechazadas(Lv_EstadoRechazado, Lv_TipoMensaje, Pv_CodEmpresa)
        LOOP

        FNCK_COM_ELECTRONICO.COMP_ELEC_CAB(Lc_GetFacturasRechazadas.ID_DOCUMENTO,
                                           Lc_GetFacturasRechazadas.EMPRESA_ID,
                                           Lc_GetFacturasRechazadas.ID_TIPO_DOCUMENTO,
                                           Lv_UsrCreacion,
                                           Lv_TipoTransaccion,
                                           Lv_Ruc,
                                           LXML_Comprobante,
                                           Lv_NombreComprobante,
                                           Lv_NombreTipoComprobante,
                                           Lv_Anio,
                                           Lv_Mes,
                                           Lv_Dia,
                                           Lv_MessageError);

        END LOOP; 
        --
      ELSE
        --
        FOR DOCUMENTO IN (SELECT REGEXP_SUBSTR (Pv_IdsDocumento,'[^,]+',1, LEVEL) idDocumento FROM DUAL
                          CONNECT BY REGEXP_SUBSTR (Pv_IdsDocumento,'[^,]+', 1, LEVEL) IS NOT NULL)
        LOOP
          --
          IF C_GetDocFinanciero%ISOPEN THEN
            CLOSE C_GetDocFinanciero;
          END IF;
          --
          OPEN C_GetDocFinanciero(DOCUMENTO.idDocumento);
            FETCH C_GetDocFinanciero INTO Lc_GetDocFinanciero ;   
          CLOSE C_GetDocFinanciero;
          --
          FNCK_COM_ELECTRONICO.COMP_ELEC_CAB(Lc_GetDocFinanciero.ID_DOCUMENTO,
                                             Lc_GetDocFinanciero.EMPRESA_ID,
                                             Lc_GetDocFinanciero.ID_TIPO_DOCUMENTO,
                                             Lv_UsrCreacion,
                                             Lv_TipoTransaccion,
                                             Lv_Ruc,
                                             LXML_Comprobante,
                                             Lv_NombreComprobante,
                                             Lv_NombreTipoComprobante,
                                             Lv_Anio,
                                             Lv_Mes,
                                             Lv_Dia,
                                             Lv_MessageError);

       END LOOP;

      END IF;    
      --
      --ACTUALIZO CABECERA DE PROCESO MASIVO A FINALIZADO  
      --
      Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB  := Ln_IdProcesoMasivoCab;
      Lr_InfoProcesoMasivoCab.TIPO_PROCESO           := Lv_TipoProceso;
      Lr_InfoProcesoMasivoCab.FE_ULT_MOD             := SYSDATE;
      Lr_InfoProcesoMasivoCab.USR_ULT_MOD            := Lv_UsrCreacion;    
      Lr_InfoProcesoMasivoCab.ESTADO                 := Lv_EstadoFinalizado;   
      --
      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_UPDATE_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Lv_MessageError);
      --
      --ACTUALIZO DETALLE DE PROCESO MASIVO A FINALIZADO  
      --
      Lr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET  := Ln_IdProcesoMasivoDet;
      Lr_InfoProcesoMasivoDet.OBSERVACION            := 'Se finalizo exitosamente el Proceso ReproFactRechazo';
      Lr_InfoProcesoMasivoDet.FE_ULT_MOD             := SYSDATE;
      Lr_InfoProcesoMasivoDet.USR_ULT_MOD            := Lv_UsrCreacion;    
      Lr_InfoProcesoMasivoDet.ESTADO                 := Lv_EstadoFinalizado;   
      --
      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_UPDATE_INFO_PROC_MASIVO_DET(Lr_InfoProcesoMasivoDet, Lv_MessageError);

    END IF;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsnError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_COM_ELECTRONICO.P_PROCESAR_FACT_RECHAZADAS', 
                                         Lv_MsnError,
                                         'reproceso_fact',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
  --
  END P_PROCESAR_FACT_RECHAZADAS;
  --
  --
  PROCEDURE P_BAJA_PM_FACT_RECHAZADAS 
  IS
    --
    --
    CURSOR C_GetProcesoMasivoCab(Cv_EstadoPendiente  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
                                 Cv_TipoProceso      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE)
    IS
      SELECT IPMC.ID_PROCESO_MASIVO_CAB, TO_CHAR(IPMC.FE_CREACION,'DD/MM/YYYY') AS FE_CREACION
        FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB IPMC
      WHERE IPMC. TIPO_PROCESO = Cv_TipoProceso
        AND IPMC. EMPRESA_ID   = 18
        AND IPMC. ESTADO       = Cv_EstadoPendiente;
    
    CURSOR C_GetProcesoMasivoDet(Cn_IdProcMasivoCab  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
    IS
      SELECT IPMD.ID_PROCESO_MASIVO_DET
        FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET IPMD
      WHERE IPMD.PROCESO_MASIVO_CAB_ID = Cn_IdProcMasivoCab;

    CURSOR C_GetDiasProcesoBaja(Cv_FeProcesoMasivo  VARCHAR2)
    IS
      SELECT 24 * FLOOR(SYSDATE - TO_DATE(Cv_FeProcesoMasivo,'DD/MM/YYYY')) AS HORAS FROM DUAL;
    --
    --
    Lv_MessageError          VARCHAR2(4000);
    Lv_MsnError              VARCHAR2(1000); 
    Ln_IdProcesoMasivoDet    NUMBER; 
    Ln_DiasProcesoBaja       NUMBER;
    Lr_InfoProcesoMasivoCab  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;    
    Lv_EstadoPendiente       DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE                  := 'Pendiente';
    Lv_EstadoBaja            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE                  := 'Baja';
    Lv_TipoProceso           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE            := 'ReproFactRechazo';
    Lv_TipoMensaje           DB_FINANCIERO.INFO_MENSAJE_COMP_ELEC.TIPO%TYPE                          := 'ERROR';
    Lv_UsrCreacion           VARCHAR2(20)                                                            := 'reproceso_fact';
    Lv_IpCreacion            VARCHAR2(20)                                                            := ('127.0.0.1');

  BEGIN

    --
    IF C_GetProcesoMasivoCab%ISOPEN THEN
      CLOSE C_GetProcesoMasivoCab;
    END IF;
    --       
    FOR Lc_GetProcesoMasivoCab IN C_GetProcesoMasivoCab(Lv_EstadoPendiente, Lv_TipoProceso)
    LOOP
      --
      OPEN C_GetDiasProcesoBaja(Lc_GetProcesoMasivoCab.FE_CREACION);
        FETCH C_GetDiasProcesoBaja INTO Ln_DiasProcesoBaja ;   
      CLOSE C_GetDiasProcesoBaja;

      IF Ln_DiasProcesoBaja >= 24 THEN

        --ACTUALIZO CABECERA DE PROCESO MASIVO A BAJA  
        --
        Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB  := Lc_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB;
        Lr_InfoProcesoMasivoCab.TIPO_PROCESO           := Lv_TipoProceso;
        Lr_InfoProcesoMasivoCab.FE_ULT_MOD             := SYSDATE;
        Lr_InfoProcesoMasivoCab.USR_ULT_MOD            := Lv_UsrCreacion;    
        Lr_InfoProcesoMasivoCab.ESTADO                 := Lv_EstadoBaja;   
        --
        DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_UPDATE_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Lv_MessageError);
        --
        --
        OPEN C_GetProcesoMasivoDet(Lc_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB);
          FETCH C_GetProcesoMasivoDet INTO Ln_IdProcesoMasivoDet ;   
        CLOSE C_GetProcesoMasivoDet;
     
        IF Ln_IdProcesoMasivoDet IS NOT NULL THEN

          --ACTUALIZO DETALLE DE PROCESO MASIVO A BAJA  
          --
          Lr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET  := Ln_IdProcesoMasivoDet;
          Lr_InfoProcesoMasivoDet.OBSERVACION            := 'Se regulariz� exitosamente el Proceso ReproFactRechazo';
          Lr_InfoProcesoMasivoDet.FE_ULT_MOD             := SYSDATE;
          Lr_InfoProcesoMasivoDet.USR_ULT_MOD            := Lv_UsrCreacion;    
          Lr_InfoProcesoMasivoDet.ESTADO                 := Lv_EstadoBaja;   
          --
          DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_UPDATE_INFO_PROC_MASIVO_DET(Lr_InfoProcesoMasivoDet, Lv_MessageError);
        END IF;
        --
      END IF;
      --        
    END LOOP; 
    --
    COMMIT;
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
    ROLLBACK;
    --
    Lv_MsnError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_COM_ELECTRONICO.P_BAJA_PM_FACT_RECHAZADAS', 
                                         Lv_MsnError,
                                         'reproceso_fact',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
  --
  END P_BAJA_PM_FACT_RECHAZADAS;
  --
  --
  PROCEDURE P_REPORTE_DOC_RECHAZADOS(Pv_EmpresaCod      IN VARCHAR2,
                                     Pv_PrefijoEmpresa  IN VARCHAR2,
                                     Pv_EmailUsuario    IN VARCHAR2) 
  IS
    CURSOR C_DocumentosRechazados(Cv_EmpresaCod IN VARCHAR2)
    IS
      With T_DOCUMENTOS_RECHAZADOS 
      As( SELECT IPE.IDENTIFICACION_CLIENTE,
                 IDFC.ID_DOCUMENTO, 
                 IDFC.NUMERO_FACTURA_SRI,
                 IP.LOGIN, 
                 INITCAP 
                 ( CASE 
                     WHEN IPE.RAZON_SOCIAL IS NOT NULL 
                     THEN 
                        IPE.RAZON_SOCIAL 
                     WHEN IPE.NOMBRES IS NOT NULL AND IPE.APELLIDOS IS NOT NULL 
                     THEN 
                        IPE.NOMBRES || ' ' || IPE.APELLIDOS 
                     WHEN ipe.REPRESENTANTE_LEGAL IS NOT NULL 
                     THEN 
                        IPE.REPRESENTANTE_LEGAL 
                   END 
                 ) NOMBRE_CLIENTE, 
                 IDFC.FE_EMISION, 
                 NVL(IDFC.VALOR_TOTAL,0) VALOR_TOTAL,
                 IDFC.OBSERVACION
           FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB               IDFC,
                             DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                             DB_COMERCIAL.INFO_OFICINA_GRUPO              IOG,
                             DB_COMERCIAL.INFO_PUNTO                      IP,
                             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL        IPER,
                             DB_COMERCIAL.INFO_PERSONA                    IPE
          WHERE ATDF.ID_TIPO_DOCUMENTO                             = IDFC.TIPO_DOCUMENTO_ID
                           AND IDFC.OFICINA_ID                     = IOG.ID_OFICINA
                           AND IP.ID_PUNTO                         = IDFC.PUNTO_ID
                           AND IPER.ID_PERSONA_ROL                 = IP.PERSONA_EMPRESA_ROL_ID
                           AND IPE.ID_PERSONA                      = IPER.PERSONA_ID
                           AND IOG.EMPRESA_ID                      = Cv_EmpresaCod
                           AND IDFC.ESTADO_IMPRESION_FACT          = 'Rechazado'
                           AND ATDF.CODIGO_TIPO_DOCUMENTO          IN ('FAC','FACP')
                           AND TO_CHAR(IDFC.FE_EMISION,'MM-RRRR')  = TO_CHAR(SYSDATE,'MM-RRRR'))

      SELECT  DOC_RECH_NC.IDENTIFICACION_CLIENTE,
              DOC_RECH_NC.NOMBRE_CLIENTE,
              DOC_RECH_NC.LOGIN,
              IDFC_NC.NUMERO_FACTURA_SRI AS NUMERO_DOC_SRI, 
              ATDF_NC.NOMBRE_TIPO_DOCUMENTO AS TIPO_DOC,
              IDFC_NC.ESTADO_IMPRESION_FACT AS ESTADO,
              IDFC_NC.VALOR_TOTAL, 
              IDFC_NC.FE_CREACION, 
              IDFC_NC.REFERENCIA_DOCUMENTO_ID AS SECUENCIAL_FACTURA,   
              DOC_RECH_NC.NUMERO_FACTURA_SRI,
              DOC_RECH_NC.FE_EMISION AS FE_EMISION_FACT,
              DOC_RECH_NC.VALOR_TOTAL AS VALOR_TOTAL_FACT,
              DOC_RECH_NC.OBSERVACION AS OBSERVACION_FACT
                
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC_NC,
             DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_NC,
             DB_COMERCIAL.INFO_OFICINA_GRUPO              IOG_NC,
             T_DOCUMENTOS_RECHAZADOS                      DOC_RECH_NC
        WHERE IDFC_NC.TIPO_DOCUMENTO_ID         = ATDF_NC.ID_TIPO_DOCUMENTO
        AND   IDFC_NC.OFICINA_ID                = IOG_NC.ID_OFICINA
        AND   IOG_NC.EMPRESA_ID                 = Cv_EmpresaCod
        AND ATDF_NC.CODIGO_TIPO_DOCUMENTO       IN ('NC')
        AND IDFC_NC.REFERENCIA_DOCUMENTO_ID     = DOC_RECH_NC.ID_DOCUMENTO
        
        UNION ALL
        
        SELECT DOC_RECH_PG.IDENTIFICACION_CLIENTE,
               DOC_RECH_PG.NOMBRE_CLIENTE,
               DOC_RECH_PG.LOGIN,
               IPC.NUMERO_PAGO AS NUMERO_DOC_SRI, 
               ATDF.NOMBRE_TIPO_DOCUMENTO AS TIPO_DOC, 
               IPC.ESTADO_PAGO AS ESTADO, 
               IPC.VALOR_TOTAL, 
               IPC.FE_CREACION, 
               IPD.REFERENCIA_ID AS SECUENCIAL_FACTURA,
               DOC_RECH_PG.NUMERO_FACTURA_SRI,
               DOC_RECH_PG.FE_EMISION AS FE_EMISION_FACT,
               DOC_RECH_PG.VALOR_TOTAL AS VALOR_TOTAL_FACT,
               DOC_RECH_PG.OBSERVACION AS OBSERVACION_FACT
        FROM DB_FINANCIERO.INFO_PAGO_CAB                  IPC,
             DB_FINANCIERO.INFO_PAGO_DET                  IPD,
             DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
             T_DOCUMENTOS_RECHAZADOS                      DOC_RECH_PG
        WHERE IPC.ID_PAGO            = IPD.PAGO_ID
        AND   ATDF.ID_TIPO_DOCUMENTO = IPC.TIPO_DOCUMENTO_ID
        AND   IPC.EMPRESA_ID         = Cv_EmpresaCod
        AND   IPD.REFERENCIA_ID      = DOC_RECH_PG.ID_DOCUMENTO; 
    
    -- 
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100)   := 'telcos@telconet.ec';  
    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');

    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

  BEGIN

    IF C_DocumentosRechazados%ISOPEN THEN
        CLOSE C_DocumentosRechazados;
    END IF;
    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DOC_RECHAZA'); 
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Pv_EmailUsuario,'notificaciones_telcos@telconet.ec')||','; 
    Lv_NombreArchivo     := 'ReporteDocRechazados_'||Pv_PrefijoEmpresa||'_'||'DIARIO'||'_'||Lv_FechaReporte||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lv_Asunto            := 'Notificacion REPORTE DOCUMENTOS RECHAZADOS';

    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
    --
    utl_file.put_line(Lfile_Archivo,
                        'IDENTIFICACION_CLIENTE' ||Lv_Delimitador
                        ||'NOMBRE_CLIENTE'       ||Lv_Delimitador
                        ||'LOGIN'                ||Lv_Delimitador
                        ||'NUMERO_DOC_SRI'       ||Lv_Delimitador
                        ||'TIPO_DOC'             ||Lv_Delimitador
                        ||'ESTADO'               ||Lv_Delimitador
                        ||'VALOR_TOTAL'          ||Lv_Delimitador
                        ||'FE_CREACION'          ||Lv_Delimitador
                        ||'SECUENCIAL_FACTURA'   ||Lv_Delimitador
                        ||'NUMERO_FACTURA_SRI'   ||Lv_Delimitador
                        ||'FE_EMISION_FACT'      ||Lv_Delimitador
                        ||'VALOR_TOTAL_FACT'     ||Lv_Delimitador
                        ||'OBSERVACION_FACT'     ||Lv_Delimitador); 

    FOR Lc_DocumentosRechazados IN C_DocumentosRechazados(Pv_EmpresaCod)
    LOOP                

        UTL_FILE.PUT_LINE(Lfile_Archivo,
                            NVL(Lc_DocumentosRechazados.IDENTIFICACION_CLIENTE, '')            ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.NOMBRE_CLIENTE, '')                    ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.LOGIN, '')                             ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.NUMERO_DOC_SRI, '')                    ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.TIPO_DOC, '')                          ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.ESTADO, '')                            ||Lv_Delimitador
                          ||NVL(REPLACE(Lc_DocumentosRechazados.VALOR_TOTAL,',','.'), '')      ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.FE_CREACION, '')                       ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.SECUENCIAL_FACTURA, '')                ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.NUMERO_FACTURA_SRI, '')                ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.FE_EMISION_FACT, '')                   ||Lv_Delimitador
                          ||NVL(REPLACE(Lc_DocumentosRechazados.VALOR_TOTAL_FACT,',','.'), '') ||Lv_Delimitador
                          ||NVL(Lc_DocumentosRechazados.OBSERVACION_FACT, '')                  ||Lv_Delimitador
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
    Lv_MsjResultado := 'Ocurri� un error al generar el reporte de Documentos Rechazados. '
                       ||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('P_REPORTE_DOC_RECHAZADOS','FNCK_COM_ELECTRONICO.P_REPORTE_DOC_RECHAZADOS',Lv_MsjResultado);  

  END P_REPORTE_DOC_RECHAZADOS;
  --
  --
  FUNCTION F_SPLIT_DESCRIPCION_DET(Fn_DescripcionDetalle  IN INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE)
  RETURN INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE
  IS
    --
    Lc_Descripcion  CLOB   := Fn_DescripcionDetalle;
    Ln_Indice       NUMBER := ROUND(LENGTH(Fn_DescripcionDetalle)/50);
    Ln_NumParticion NUMBER := 50;
    --
  BEGIN
    --
    FOR Ln_Particion IN 1..Ln_Indice
    LOOP
     
       Lc_Descripcion:=regexp_replace(Lc_Descripcion, '^(.{'||Ln_NumParticion||'})', '\1 ');
       Ln_NumParticion:= Ln_NumParticion + 50;
    END LOOP;
    --
    RETURN Lc_Descripcion;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.F_SPLIT_DESCRIPCION_DET', SQLERRM);
    
    RETURN Lc_Descripcion;
    --
  END F_SPLIT_DESCRIPCION_DET;
  --
  --
    FUNCTION F_GET_FECHA_MAXIMA_PAGO(Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE
  IS
    --
    Ln_IdDocumento  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  := Fn_IdDocumento;
    Ld_FechaMaxPago INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE    :=null;
    Lr_Documento    INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE            :=null;
    --
    --COSTO 3
    CURSOR C_Documento(Ln_IdDocumentoF INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
     IS
     SELECT IDFC.fe_emision FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC WHERE IDFC.ID_DOCUMENTO=Ln_IdDocumentoF;
    --
  BEGIN
    --
    IF C_Documento%ISOPEN THEN
        CLOSE C_Documento;
    END IF;
    OPEN C_Documento(Ln_IdDocumento);
    FETCH C_Documento INTO Ld_FechaMaxPago;
    RETURN Ld_FechaMaxPago+10;
    --
  END F_GET_FECHA_MAXIMA_PAGO;
  --
END FNCK_COM_ELECTRONICO;
/

