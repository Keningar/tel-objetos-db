CREATE OR REPLACE package NAF47_TNET.SRIK_CARGA_MASIVA_XML is

  /**
  * Documentacion para NAF47_TNET.SRIK_CARGA_MASIVA_XML
  * Paquete que contiene procesos y funciones para procesar
  * informacion facturas y retenciones luego de la carga de XML
  *
  * @author jgilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  */

  type LIST_FILE is varray(100) of varchar2(256);

  TYPE FACTURA_ITEM_REC IS RECORD(
    RUC                   NAF47_TNET.INFO_TRIBUTARIA_DOC.RUC%TYPE,
    SERIE                 VARCHAR2(6),
    AUTORIZACION          VARCHAR2(60),
    FECHA_EMISION         DATE,
    DOCUMENTO_ELECTRONICO NAF47_TNET.INFO_ARCHIVOS_CARGADOS.NOMBRE_ARCHIVO%TYPE,
    SUBTOTAL              NUMBER,
    VALOR_IVA             NUMBER,
    TOTAL                 NUMBER,
    COD_RETENCION         VARCHAR2(10));

  L_ITEM FACTURA_ITEM_REC;
  TYPE TABLA_FACTURAS IS TABLE OF FACTURA_ITEM_REC INDEX BY BINARY_INTEGER;

  /**
  * Documentaci?n para P_GET_FACTURAS
  * Procedimiento que permite obtener las facturas cargadas sobre el periodo en proceso
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param P_Lista IN OUT TABLA_FACTURAS Retorna la lista de Facturas
  */
  PROCEDURE P_GET_FACTURAS(P_LISTA IN OUT TABLA_FACTURAS);

  /**
  * Documentaci?n para P_GUARDA_ARCHIVOS_BASE
  * Procedimiento que permite guardar informaci?n base del documento electr?nico
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PV_NOCIA   IN  VARCHAR2 Recibe codigo de la Compa?ia
  * @param PV_RUTA    IN  VARCHAR2 Recibe ruta del archivo XML cargado
  * @param PV_ARCHIVO IN  VARCHAR2 Recibe nombre del archivo XML cargado
  * @param PN_ANIO    IN  VARCHAR2 Recibe Anio en Proceso
  * @param PN_MES     IN  VARCHAR2 Recibe Mes en Proceso
  * @param PV_ERROR   OUT VARCHAR2 Retorna cualquier error generado en el proceso
  */
  PROCEDURE P_GUARDA_ARCHIVOS_BASE(PV_NOCIA   IN VARCHAR2,
                                   PV_RUTA    IN VARCHAR2,
                                   PV_ARCHIVO IN VARCHAR2,
                                   PN_ANIO    IN NUMBER,
                                   PN_MES     IN NUMBER,
                                   PV_ERROR   OUT VARCHAR2);

  /**
  * Documentaci?n para P_ELIMINA_REGISTROS
  * Procedimiento que permite eliminar los documentos Ingresados en caso de generarse un problema
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PV_NOCIA IN VARCHAR2 Recibe codigo de la Compa?ia
  */
  PROCEDURE P_ELIMINA_REGISTROS(PV_NOCIA IN VARCHAR2);

  /**
  * Documentaci?n para P_EXTRAER_VALOR
  * Procedimiento que permite extraer el valor segun una etiqueta de un archivo CLOB
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PV_LINEA    IN  VARCHAR2 Recibe la linea en formato XML <etiqueta>valor</etiqueta>
  * @param PV_ETIQUETA IN  VARCHAR2 Recibe el nombre de la etiqueta XML
  * @param PV_VALOR    OUT VARCHAR2 Retorna el valor de la etiqueta XML
  */
  PROCEDURE P_EXTRAER_VALOR(PV_LINEA    IN VARCHAR2,
                            PV_ETIQUETA IN VARCHAR2,
                            PV_VALOR    OUT VARCHAR2);

  /**
  * Documentaci?n para F_TO_CLOB
  * Funcion que permite convertir una linea VARCHAR2 a CLOB
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param  PV_LINEA    IN  VARCHAR2 Recibe la linea a convertir
  * @return                 CLOB     Retorna el CLOB a partir de un VARCHAR2
  */
  FUNCTION F_TO_CLOB(PV_LINEA IN VARCHAR2) RETURN CLOB;

  /**
  * Documentaci?n para P_ACTUALIZA_CARGA_ARCHIVO
  * Procedimiento que permite actualizar la informacion de los archivos cargados
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA             IN  VARCHAR2 Recibe la secuencia del documento a actualizar
  * @param PV_ESTADO_AUTORIZACION   IN  VARCHAR2 Recibe el estado de la autorizacion
  * @param PV_NUMERO_AUTORIZACION   IN  VARCHAR2 Recibe el numero de autorizacion
  * @param PV_FECHA_AUTORIZACION    IN  VARCHAR2 Recibe la fecha de autorizacion
  * @param PV_TIPO_DOCUMENTO        IN  VARCHAR2 Recibe el tipo de documento FACTURA | RETENCION
  * @param PV_VERSION               IN  VARCHAR2 Recibe la version del documento
  * @param PN_CODIGO                IN  VARCHAR2 Recibe el codigo de la accion a realizar
  * @param PV_LINEA                 IN  VARCHAR2 Recibe la linea en formato XML <etiqueta>valor</etiqueta>
  * @param PN_ANIO                  IN  VARCHAR2 Recibe el Anio en Proceso
  * @param PN_MES                   IN  VARCHAR2 Recibe el Mes en Proceso
  * @param PV_ERROR                 OUT VARCHAR2 Retorna cualquier error generado en el proceso
  */
  PROCEDURE P_ACTUALIZA_CARGA_ARCHIVO(PN_SECUENCIA           IN NUMBER,
                                      PV_ESTADO_AUTORIZACION IN VARCHAR2,
                                      PV_NUMERO_AUTORIZACION IN VARCHAR2,
                                      PV_FECHA_AUTORIZACION  IN VARCHAR2,
                                      PV_TIPO_DOCUMENTO      IN VARCHAR2,
                                      PV_VERSION             IN VARCHAR2,
                                      PN_CODIGO              IN NUMBER,
                                      PV_LINEA               IN VARCHAR2,
                                      PN_ANIO                IN NUMBER,
                                      PN_MES                 IN NUMBER,
                                      PV_ERROR               OUT VARCHAR2);

  /**
  * Documentaci?n para P_CARGA_INFORMACION
  * Procedimiento que se encarga de leer el XML de cada documento y cargarlos a las estructuras correspondientes
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PV_NOCIA  IN  VARCHAR2 Recibe codigo de la compania
  * @param PN_ANIO   IN  VARCHAR2 Recibe el Anio en Proceso
  * @param PN_MES    IN  VARCHAR2 Recibe el Mes en Proceso
  * @param PV_ERROR  OUT VARCHAR2 Retorna cualquier error generado en el proceso
  */
  PROCEDURE P_CARGA_INFORMACION(PV_NOCIA IN VARCHAR2,
                                PN_ANIO  IN NUMBER,
                                PN_MES   IN NUMBER,
                                PV_ERROR OUT VARCHAR2);

  /**
  * Documentaci?n para P_ELIMINA_DATA
  * Procedimiento que permite eliminar los documentos Ingresados en caso de generarse un problema
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PV_NOCIA    IN  VARCHAR2 Recibe codigo de la compania
  * @param PN_ANIO     IN  VARCHAR2 Recibe el Anio en Proceso
  * @param PN_MES      IN  VARCHAR2 Recibe el Mes en Proceso
  * @param PV_USUARIO  IN  VARCHAR2 Recibe el usuario que realizo la carga
  */
  PROCEDURE P_ELIMINA_DATA(PV_NOCIA   VARCHAR2,
                           PN_ANIO    NUMBER,
                           PN_MES     NUMBER,
                           PV_USUARIO VARCHAR2);

  /**
  * Documentaci?n para F_OBTENER_SECUENCIA
  * Funcion que permite obtener la secuencia del siguiente documento
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @return NUMBER Retorna la siguiente secuencia
  */
  FUNCTION F_OBTENER_SECUENCIA RETURN NUMBER;

  /**
  * Documentaci?n para P_INSERTA_INFOTRIBUTARIA
  * Procedimiento que inserta la Informaci?n Tributaria
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA_DOC     IN  NUMBER                                                    Recibe secuencia del documento
  * @param PN_AMBIENTE          IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.AMBIENTE%TYPE          Recibe ambiente
  * @param PN_TIPO_EMISION      IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.TIPO_EMISION%TYPE      Recibe tipo de emision
  * @param PV_RAZON_SOCIAL      IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.RAZON_SOCIAL%TYPE      Recibe la razon social
  * @param PV_NOMBRE_COMERCIAL  IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.NOMBRE_COMERCIAL%TYPE  Recibe nombre comercial
  * @param PV_RUC               IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.RUC%TYPE               Recibe RUC
  * @param PV_CLAVE_ACCESO      IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.CLAVE_ACCESO%TYPE      Recibe Clave de Acceso al documento
  * @param PV_COD_DOC           IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.COD_DOC%TYPE           Recibe Codigo del documento
  * @param PV_ESTAB             IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.ESTAB%TYPE             Recibe codigo del establecimiento
  * @param PV_PTO_EMI           IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.PTO_EMI%TYPE           Recibe punto de emision
  * @param PV_SECUENCIAL        IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.SECUENCIAL%TYPE        Recibe secuencia del documento
  * @param PV_DIR_MATRIZ        IN  NAF47_TNET.INFO_TRIBUTARIA_DOC.DIR_MATRIZ%TYPE        Recibe direccion matriz
  */
  PROCEDURE P_INSERTA_INFOTRIBUTARIA(PN_SECUENCIA_DOC    NUMBER,
                                     PN_AMBIENTE         NAF47_TNET.INFO_TRIBUTARIA_DOC.AMBIENTE_ID%TYPE,
                                     PN_TIPO_EMISION     NAF47_TNET.INFO_TRIBUTARIA_DOC.TIPO_EMISION_ID%TYPE,
                                     PV_RAZON_SOCIAL     NAF47_TNET.INFO_TRIBUTARIA_DOC.RAZON_SOCIAL%TYPE,
                                     PV_NOMBRE_COMERCIAL NAF47_TNET.INFO_TRIBUTARIA_DOC.NOMBRE_COMERCIAL%TYPE,
                                     PV_RUC              NAF47_TNET.INFO_TRIBUTARIA_DOC.RUC%TYPE,
                                     PV_CLAVE_ACCESO     NAF47_TNET.INFO_TRIBUTARIA_DOC.CLAVE_ACCESO%TYPE,
                                     PV_COD_DOC          NAF47_TNET.INFO_TRIBUTARIA_DOC.DOCUMENTO_ID%TYPE,
                                     PV_ESTAB            NAF47_TNET.INFO_TRIBUTARIA_DOC.ESTABLECIMIENTO%TYPE,
                                     PV_PTO_EMI          NAF47_TNET.INFO_TRIBUTARIA_DOC.PUNTO_EMISION%TYPE,
                                     PV_SECUENCIAL       NAF47_TNET.INFO_TRIBUTARIA_DOC.SECUENCIAL_ID%TYPE,
                                     PV_DIR_MATRIZ       NAF47_TNET.INFO_TRIBUTARIA_DOC.DIR_MATRIZ%TYPE);

  /**
  * Documentaci?n para P_INSERTA_INFODOCUMENTO
  * Procedimiento que inserta la Informaci?n base del documento electronico
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA_DOC       IN  NUMBER                                                                     Recibe secuencia del documento
  * @param PV_FECHA_EMISION       IN  NAF47_TNET.INFO_FACTURA_RETENCION.FECHA_EMISION%TYPE                   Recibe la fecha de emision
  * @param PV_DIRECCION_ESTAB     IN  NAF47_TNET.INFO_FACTURA_RETENCION.DIRECCION_ESTABLECIMIENTO%TYPE       Recibe direccion del establecimiento
  * @param PV_CONTRIBUYENTE_ESP   IN  NAF47_TNET.INFO_FACTURA_RETENCION.CONTRIBUYENTE_ESP%TYPE               Recibe bandera que indica si es contribuyente especial
  * @param PV_OBLIGADO_CONTAB     IN  NAF47_TNET.INFO_FACTURA_RETENCION.OBLIGADO_CONTABILIDAD%TYPE           Recibe bandera que indica si eta obligado a llevar contabilidad
  * @param PV_TIPO_IDENT          IN  NAF47_TNET.INFO_FACTURA_RETENCION.TIPO_IDENTIFICACION%TYPE             Recibe el tipo de identificacion
  * @param PV_RAZON_SOCIAL        IN  NAF47_TNET.INFO_FACTURA_RETENCION.RAZON_SOCIAL%TYPE                    Recibe la razon social
  * @param PV_IDENTIFICACION      IN  NAF47_TNET.INFO_FACTURA_RETENCION.IDENTIFICACION%TYPE                  Recibe la identificacion
  * @param PV_DIRECCION_COMP      IN  NAF47_TNET.INFO_FACTURA_RETENCION.DIRECCION_COMPRADOR%TYPE             Recibe la direccion del comprador
  * @param PN_TOTA_SIMP           IN  NAF47_TNET.INFO_FACTURA_RETENCION.TOTAL_SIMP%TYPE                      Recibe el total sin impuestos
  * @param PN_TOTAL_DESC          IN  NAF47_TNET.INFO_FACTURA_RETENCION.TOTAL_DESC%TYPE                      Recibe el total de descuento
  * @param PN_PROPINA             IN  NAF47_TNET.INFO_FACTURA_RETENCION.PROPINA%TYPE                         Recibe la propina
  * @param PN_IMPORTE_TOTAL       IN  NAF47_TNET.INFO_FACTURA_RETENCION.IMPORTE_TOTAL%TYPE                   Recibe el importe total
  * @param PV_MONEDA              IN  NAF47_TNET.INFO_FACTURA_RETENCION.MONEDA%TYPE                          Recibe el tipo de moneda usada
  * @param PV_PARTE_REL           IN  NAF47_TNET.INFO_FACTURA_RETENCION.PARTE_REL%TYPE                       Recibe bandera que indica si existe parte relacionada
  * @param PN_PERIODO_FISCAL      IN  NAF47_TNET.INFO_FACTURA_RETENCION.PERIODO_FISCAL%TYPE                  Recibe el periodo fiscal en proceso
  */
  PROCEDURE P_INSERTA_INFODOCUMENTO(PN_SECUENCIA         NUMBER,
                                    PV_FECHA_EMISION     NAF47_TNET.INFO_FACTURA_RETENCION.FE_EMISION%TYPE,
                                    PV_DIRECCION_ESTAB   NAF47_TNET.INFO_FACTURA_RETENCION.DIRECCION_ESTABLECIMIENTO%TYPE,
                                    PV_CONTRIBUYENTE_ESP NAF47_TNET.INFO_FACTURA_RETENCION.CONTRIBUYENTE_ESPECIAL%TYPE,
                                    PV_OBLIGADO_CONTAB   NAF47_TNET.INFO_FACTURA_RETENCION.OBLIGADO_CONTABILIDAD%TYPE,
                                    PV_TIPO_IDENT        NAF47_TNET.INFO_FACTURA_RETENCION.TIPO_IDENTIFICACION%TYPE,
                                    PV_RAZON_SOCIAL      NAF47_TNET.INFO_FACTURA_RETENCION.RAZON_SOCIAL%TYPE,
                                    PV_IDENTIFICACION    NAF47_TNET.INFO_FACTURA_RETENCION.IDENTIFICACION%TYPE,
                                    PV_DIRECCION_COMP    NAF47_TNET.INFO_FACTURA_RETENCION.DIRECCION_COMPRADOR%TYPE,
                                    PN_TOTA_SIMP         NAF47_TNET.INFO_FACTURA_RETENCION.TOTAL_SIMP%TYPE,
                                    PN_TOTAL_DESC        NAF47_TNET.INFO_FACTURA_RETENCION.TOTAL_DESC%TYPE,
                                    PN_PROPINA           NAF47_TNET.INFO_FACTURA_RETENCION.PROPINA%TYPE,
                                    PN_IMPORTE_TOTAL     NAF47_TNET.INFO_FACTURA_RETENCION.IMPORTE_TOTAL%TYPE,
                                    PV_MONEDA            NAF47_TNET.INFO_FACTURA_RETENCION.MONEDA%TYPE,
                                    PV_PARTE_REL         NAF47_TNET.INFO_FACTURA_RETENCION.PARTE_REL%TYPE,
                                    PN_PERIODO_FISCAL    NAF47_TNET.INFO_FACTURA_RETENCION.PERIODO_FISCAL%TYPE);

  /**
  * Documentaci?n para P_INSERTA_INFOIMPUESTOS
  * Procedimiento que inserta la Informaci?n de impuestos
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA_DOC    IN  NUMBER                                               Recibe secuencia del documento
  * @param PN_CODIGO           IN  NAF47_TNET.INFO_IMPUESTOS.CODIGO%TYPE            Recibe el codigo del impuesto
  * @param PV_COD_PORCENTAJE   IN  NAF47_TNET.INFO_IMPUESTOS.COD_PORCENTAJE%TYPE    Recibe el porcentaje del impuesto
  * @param PN_TARIFA           IN  NAF47_TNET.INFO_IMPUESTOS.TARIFA%TYPE            Recibe la tarifa del impuesto
  * @param PN_BASE_IMPONIBLE   IN  NAF47_TNET.INFO_IMPUESTOS.BASE_IMPONIBLE%TYPE    Recibe la base imponible sobre la que se aplica el impuesto
  * @param PN_VALOR            IN  NAF47_TNET.INFO_IMPUESTOS.VALOR%TYPE             Recibe el valor calculado del impuesto
  * @param PN_COD_SUSTENTO     IN  NAF47_TNET.INFO_IMPUESTOS.COD_SUSTENTO%TYPE      Recibe codigo de sustento relacionado a una retencion
  * @param PN_COD_DOC_SUSTENTO IN  NAF47_TNET.INFO_IMPUESTOS.COD_DOC_SUSTENTO%TYPE  Recibe codigo documento sustento relacionado a una retencion
  * @param PV_COD_ITEM         IN  NAF47_TNET.INFO_IMPUESTOS.COD_ITEM_FACT%TYPE     Recibe codigo del producto relacionado a una factura
  */
  PROCEDURE P_INSERTA_INFOIMPUESTOS(PN_SECUENCIA        NUMBER,
                                    PN_CODIGO           NAF47_TNET.INFO_IMPUESTOS.IMPUESTO_ID%TYPE,
                                    PV_COD_PORCENTAJE   NAF47_TNET.INFO_IMPUESTOS.PORCENTAJE_ID%TYPE,
                                    PN_TARIFA           NAF47_TNET.INFO_IMPUESTOS.TARIFA%TYPE,
                                    PN_BASE_IMPONIBLE   NAF47_TNET.INFO_IMPUESTOS.BASE_IMPONIBLE%TYPE,
                                    PN_VALOR            NAF47_TNET.INFO_IMPUESTOS.VALOR%TYPE,
                                    PN_COD_SUSTENTO     NAF47_TNET.INFO_IMPUESTOS.SUSTENTO_ID%TYPE,
                                    PN_COD_DOC_SUSTENTO NAF47_TNET.INFO_IMPUESTOS.DOC_SUSTENTO_ID%TYPE,
                                    PV_COD_ITEM         NAF47_TNET.INFO_IMPUESTOS.ITEM_FACTURA_ID%TYPE);

  /**
  * Documentaci?n para P_INSERTA_INFOPAGOS
  * Procedimiento que inserta la Informaci?n de pagos
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA_DOC    IN  NUMBER                                          Recibe secuencia del documento
  * @param PV_FORMA_PAGO       IN  NAF47_TNET.INFO_PAGO.FORMA_PAGO%TYPE        Recibe el codigo de la forma de pago
  * @param PN_TOTAL            IN  NAF47_TNET.INFO_PAGO.TOTAL%TYPE             Recibe el total de pago
  * @param PN_PLAZO            IN  NAF47_TNET.INFO_PAGO.PLAZO%TYPE             Recibe el plazo del pago
  * @param PV_UNIDAD_TIEMPO    IN  NAF47_TNET.INFO_PAGO.UNIDAD_TIEMPO%TYPE     Recibe la unidad de tiempo
  * @param PN_COD_SUSTENTO     IN  NAF47_TNET.INFO_PAGO.COD_SUSTENTO%TYPE      Recibe codigo de sustento relacionado a una retencion
  * @param PN_COD_DOC_SUSTENTO IN  NAF47_TNET.INFO_PAGO.COD_DOC_SUSTENTO%TYPE  Recibe codigo documento sustento relacionado a una retencion
  */
  PROCEDURE P_INSERTA_INFOPAGOS(PN_SECUENCIA        NUMBER,
                                PV_FORMA_PAGO       NAF47_TNET.INFO_PAGO.FORMA_PAGO_ID%TYPE,
                                PN_TOTAL            NAF47_TNET.INFO_PAGO.TOTAL%TYPE,
                                PN_PLAZO            NAF47_TNET.INFO_PAGO.PLAZO%TYPE,
                                PV_UNIDAD_TIEMPO    NAF47_TNET.INFO_PAGO.UNIDAD_TIEMPO%TYPE,
                                PN_COD_SUSTENTO     NAF47_TNET.INFO_PAGO.SUSTENTO_ID%TYPE,
                                PN_COD_DOC_SUSTENTO NAF47_TNET.INFO_PAGO.DOC_SUSTENTO_ID%TYPE);

  /**
  * Documentaci?n para P_INSERTA_DETALLE_FACTURA
  * Procedimiento que inserta el detalle de la factura
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA_DOC     IN  NUMBER                                                Recibe secuencia del documento
  * @param PV_COD_PRINCIPAL     IN  NAF47_TNET.INFO_DETALLE_FACTURA.CODIGO_PRINCIPAL%TYPE  Recibe el codigo de producto facturado
  * @param PV_DESCRIPCION       IN  NAF47_TNET.INFO_DETALLE_FACTURA.DESCRIPCION%TYPE       Recibe descripcion del producto facturado
  * @param PN_CANTIDAD          IN  NAF47_TNET.INFO_DETALLE_FACTURA.CANTIDAD%TYPE          Recibe la cantidad del producto facturado
  * @param PN_PRECIO_UNITARIO   IN  NAF47_TNET.INFO_DETALLE_FACTURA.PRECIO_UNITARIO%TYPE   Recibe precio unitario del producto
  * @param PN_DESCUENTO         IN  NAF47_TNET.INFO_DETALLE_FACTURA.DESCUENTO%TYPE         Recibe descuento realizado del producto
  * @param PN_PRECIO_TOTAL_SIMP IN  NAF47_TNET.INFO_DETALLE_FACTURA.PRECIO_TOT_SIMP%TYPE   Recibe precio total sin impuestos
  */
  PROCEDURE P_INSERTA_DETALLE_FACTURA(PN_SECUENCIA         NUMBER,
                                      PV_COD_PRINCIPAL     NAF47_TNET.INFO_DETALLE_FACTURA.CODIGO_PRINCIPAL%TYPE,
                                      PV_DESCRIPCION       NAF47_TNET.INFO_DETALLE_FACTURA.DESCRIPCION%TYPE,
                                      PN_CANTIDAD          NAF47_TNET.INFO_DETALLE_FACTURA.CANTIDAD%TYPE,
                                      PN_PRECIO_UNITARIO   NAF47_TNET.INFO_DETALLE_FACTURA.PRECIO_UNITARIO%TYPE,
                                      PN_DESCUENTO         NAF47_TNET.INFO_DETALLE_FACTURA.DESCUENTO%TYPE,
                                      PN_PRECIO_TOTAL_SIMP NAF47_TNET.INFO_DETALLE_FACTURA.TOTAL_SIMP%TYPE);

  /**
  * Documentaci?n para P_INSERTA_INFOADICIONAL
  * Procedimiento que inserta informacion adicional
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA_DOC     IN  NUMBER                                                Recibe secuencia del documento
  * @param PV_DESCRIPCION       IN  NAF47_TNET.INFO_ADICIONAL.DESCRIPCION%TYPE        Recibe descripcion
  */
  PROCEDURE P_INSERTA_INFOADICIONAL(PN_SECUENCIA   NUMBER,
                                    PV_DESCRIPCION NAF47_TNET.INFO_ADICIONAL.DESCRIPCION%TYPE);

  /**
  * Documentaci?n para P_INSERTA_SUSTENTO
  * Procedimiento que inserta informacion del sustento del comprobante de retencion
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA_DOC       IN  NUMBER                                                           Recibe secuencia del documento
  * @param PN_COD_SUSTENTO        IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.COD_SUSTENTO%TYPE              Recibe codigo del sustento
  * @param PN_COD_DOC_SUSTENTO    IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.COD_DOC_SUSTENTO%TYPE          Recibe codigo del documento del sustento
  * @param PV_NUM_DOC_SUSTENTO    IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.NUM_DOC_SUSTENTO%TYPE          Recibe numero del documento del sustento
  * @param PD_FECHA_EMISION       IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.FECHA_EMISION_DOC_SUS%TYPE     Recibe fecha emision del sustento
  * @param PD_FECHA_REG_CONTABLE  IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.FECHA_REGISTRO_CONTABLE%TYPE   Recibe fecha registro contable
  * @param PV_NUM_AUT             IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.NUM_AUT_DOC_SUS%TYPE           Recibe descripcion
  * @param PV_PAGO_LOC            IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.PAGO_LOC_EXT%TYPE              Recibe numero de autorizacion
  * @param PN_TOTAL_SIMP          IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.TOTAL_SIMP%TYPE                Recibe total sin impuestos
  * @param PN_IMPORTE_TOTAL       IN  NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.IMPORTE_TOTAL%TYPE             Recibe importe total
  */
  PROCEDURE P_INSERTA_SUSTENTO(PN_SECUENCIA          NUMBER,
                               PN_COD_SUSTENTO       NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.SUSTENTO_ID%TYPE,
                               PN_COD_DOC_SUSTENTO   NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.DOC_SUSTENTO_ID%TYPE,
                               PV_NUM_DOC_SUSTENTO   NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.NUM_DOC_SUSTENTO%TYPE,
                               PD_FECHA_EMISION      NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.FE_EMISION_DOC_SUS%TYPE,
                               PD_FECHA_REG_CONTABLE NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.FE_REGISTRO_CONTABLE%TYPE,
                               PV_NUM_AUT            NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.NUM_AUT_DOC_SUS%TYPE,
                               PV_PAGO_LOC           NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.PAGO_LOC_EXT%TYPE,
                               PN_TOTAL_SIMP         NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.TOTAL_SIMP%TYPE,
                               PN_IMPORTE_TOTAL      NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.IMPORTE_TOTAL%TYPE);

  /**
  * Documentaci?n para P_INSERTA_INFORETENCION
  * Procedimiento que inserta informacion de la retencion
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PN_SECUENCIA_DOC       IN  NUMBER                                                      Recibe secuencia del documento
  * @param PN_CODIGO              IN  NAF47_TNET.INFO_RETENCIONES.CODIGO%TYPE                 Recibe codigo del registro
  * @param PV_COD_RETENCION       IN  NAF47_TNET.INFO_RETENCIONES.CODIGO_RETENCION%TYPE       Recibe codigo de la retencion
  * @param PN_BASE                IN  NAF47_TNET.INFO_RETENCIONES.BASE_IMPONIBLE%TYPE         Recibe base imponible sobre la que se calcula la retencion
  * @param PN_PORCENTAJE          IN  NAF47_TNET.INFO_RETENCIONES.PORCENTAJE_RETENCION%TYPE   Recibe porcentaje de retencion
  * @param PN_VALOR               IN  NAF47_TNET.INFO_RETENCIONES.VALOR_RETENIDO%TYPE         Recibe valor retenido
  * @param PN_COD_SUSTENTO        IN  NAF47_TNET.INFO_RETENCIONES.COD_SUSTENTO%TYPE           Recibe codigo del sustento
  * @param PN_COD_DOC_SUSTENTO    IN  NAF47_TNET.INFO_RETENCIONES.COD_DOC_SUSTENTO%TYPE       Recibe codigo del documento de sustento
  */
  PROCEDURE P_INSERTA_INFORETENCION(PN_SECUENCIA        NUMBER,
                                    PN_CODIGO           NAF47_TNET.INFO_RETENCIONES.ELEMENTO_ID%TYPE,
                                    PV_COD_RETENCION    NAF47_TNET.INFO_RETENCIONES.RETENCION_ID%TYPE,
                                    PN_BASE             NAF47_TNET.INFO_RETENCIONES.BASE_IMPONIBLE%TYPE,
                                    PN_PORCENTAJE       NAF47_TNET.INFO_RETENCIONES.PORCENTAJE_RETENCION%TYPE,
                                    PN_VALOR            NAF47_TNET.INFO_RETENCIONES.VALOR_RETENIDO%TYPE,
                                    PN_COD_SUSTENTO     NAF47_TNET.INFO_RETENCIONES.SUSTENTO_ID%TYPE,
                                    PN_COD_DOC_SUSTENTO NAF47_TNET.INFO_RETENCIONES.DOC_SUSTENTO_ID%TYPE);

  /**
  * Documentaci?n para P_ACTUALIZA_DOCUMENTO
  * Procedimiento que actualiza informaci?n de un documento en proceso
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param PV_NOCIA        IN  NUMBER                                                   Recibe codigo compania
  * @param PN_SECUENCIA    IN  NAF47_TNET.INFO_RETENCIONES.CODIGO%TYPE              Recibe secuencia del documento
  * @param PV_ESTADO       IN  NAF47_TNET.INFO_RETENCIONES.CODIGO_RETENCION%TYPE    Recibe estado del registro
  * @param PV_OBSERVACION  IN  NAF47_TNET.INFO_RETENCIONES.BASE_IMPONIBLE%TYPE      Recibe observacion sobre el registro
  */
  PROCEDURE P_ACTUALIZA_DOCUMENTO(PV_NOCIA       VARCHAR2,
                                  PN_SECUENCIA   NUMBER,
                                  PV_ESTADO      NAF47_TNET.INFO_ARCHIVOS_CARGADOS.ESTADO%TYPE,
                                  PV_OBSERVACION NAF47_TNET.INFO_ARCHIVOS_CARGADOS.OBSERVACION%TYPE);

  /**
  * Documentaci?n para F_NUM_ERRORES
  * Funcion que permite consultar el numero de errores que se hallan presentado en el proceso de carga
  *
  * @author Jimmy Gilces <jgilces@telconet.ec>
  * @version 1.0 19/09/2022
  *
  * @param  PV_NOCIA    IN  NUMBER   Recibe codigo compania
  * @param  PN_ANIO     IN  VARCHAR2 Recibe el Anio en Proceso
  * @param  PN_MES      IN  VARCHAR2 Recibe el Mes en Proceso
  * @return                 NUMBER   Numero de errores encontrados
  */
  FUNCTION F_NUM_ERRORES(PV_NOCIA IN VARCHAR2,
                         PN_ANIO  IN NUMBER,
                         PN_MES   IN NUMBER) RETURN NUMBER;

END SRIK_CARGA_MASIVA_XML;
/

CREATE OR REPLACE package body NAF47_TNET.SRIK_CARGA_MASIVA_XML is

  PROCEDURE P_GET_FACTURAS(P_LISTA IN OUT TABLA_FACTURAS) IS
    CURSOR C_GET_REGISTROS(CN_ANIO NUMBER, CN_MES NUMBER) IS
      SELECT B.RUC,
             B.ESTABLECIMIENTO || '' || B.PUNTO_EMISION SERIE,
             B.SECUENCIAL_ID NUMERO_DOCUMENTO,
             '???' AUTORIZACION,
             TO_DATE(C.FE_EMISION, 'DD/MM/YYYY') FECHA_EMISION,
             A.NOMBRE_ARCHIVO DOCUMENTO_ELECTRONICO,
             C.Total_Simp SUBTOTAL,
             D.VALOR VALOR_IVA,
             c.importe_total total,
             '??' COD_RETENCION
        FROM NAF47_TNET.INFO_ARCHIVOS_CARGADOS A,
             NAF47_TNET.INFO_TRIBUTARIA_DOC    B,
             NAF47_TNET.INFO_FACTURA_RETENCION C,
             NAF47_TNET.INFO_IMPUESTOS         D
       WHERE A.SECUENCIA_CARGA_ID = B.SECUENCIA_CARGA_ID
         AND A.ESTADO = 'C'
         AND A.TIPO_DOCUMENTO = 'FACTURA'
         AND A.SECUENCIA_CARGA_ID = C.SECUENCIA_CARGA_ID
         AND A.SECUENCIA_CARGA_ID = D.SECUENCIA_CARGA_ID
         AND D.ITEM_FACTURA_ID IS NULL
         AND D.DOC_SUSTENTO_ID IS NULL
         AND D.SUSTENTO_ID IS NULL
         AND A.PERIODO_ANIO = CN_ANIO
         AND A.PERIODO_MES = CN_MES;
  
    LN_IDX NUMBER := 1;
  
  BEGIN
    FOR REGISTRO IN C_GET_REGISTROS(1, 1) LOOP
      L_ITEM.RUC                   := REGISTRO.RUC;
      L_ITEM.SERIE                 := REGISTRO.SERIE;
      L_ITEM.AUTORIZACION          := REGISTRO.AUTORIZACION;
      L_ITEM.FECHA_EMISION         := REGISTRO.FECHA_EMISION;
      L_ITEM.DOCUMENTO_ELECTRONICO := REGISTRO.DOCUMENTO_ELECTRONICO;
      L_ITEM.SUBTOTAL              := REGISTRO.SUBTOTAL;
      L_ITEM.VALOR_IVA             := REGISTRO.VALOR_IVA;
      L_ITEM.TOTAL                 := REGISTRO.TOTAL;
      L_ITEM.COD_RETENCION         := REGISTRO.COD_RETENCION;
    
      P_LISTA(LN_IDX) := L_ITEM;
      LN_IDX := LN_IDX + 1;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_GUARDA_ARCHIVOS_BASE(PV_NOCIA   IN VARCHAR2,
                                   PV_RUTA    IN VARCHAR2,
                                   PV_ARCHIVO IN VARCHAR2,
                                   PN_ANIO    IN NUMBER,
                                   PN_MES     IN NUMBER,
                                   PV_ERROR   OUT VARCHAR2) IS
    LN_EXISTE_IC NUMBER;
    LN_EXISTE_E  NUMBER;
    REGISTRO_DUPLICADO EXCEPTION;
  BEGIN
    BEGIN
      /*SELECT COUNT(*)
       INTO LN_EXISTE_IC
       FROM NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
      WHERE A.PERIODO_ANIO = PN_ANIO
        AND A.PERIODO_MES = PN_MES
        AND A.NOMBRE_ARCHIVO = PV_ARCHIVO
        AND A.NO_CIA = PV_NOCIA
        AND A.ESTADO IN ('I', 'C');*/
    
      --IF LN_EXISTE_IC = 0 THEN
      SELECT COUNT(*)
        INTO LN_EXISTE_E
        FROM NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
       WHERE A.PERIODO_ANIO = PN_ANIO
         AND A.PERIODO_MES = PN_MES
         AND A.NOMBRE_ARCHIVO = PV_ARCHIVO
         AND A.NO_CIA = PV_NOCIA
         AND A.ESTADO IN ('E');
      /*ELSE
        RAISE REGISTRO_DUPLICADO;
      END IF;*/
    END;
  
    --IF LN_EXISTE_IC = 0 OR LN_EXISTE_E > 0 THEN
    INSERT INTO NAF47_TNET.INFO_ARCHIVOS_CARGADOS
      (SECUENCIA_CARGA_ID,
       PERIODO_ANIO,
       PERIODO_MES,
       NOMBRE_ARCHIVO,
       RUTA_ARCHIVO,
       TIPO_DOCUMENTO,
       XML_DATA,
       ESTADO,
       FE_CREACION,
       USR_CREACION,
       FE_MODIFICACION,
       USR_MODIFICACION,
       NO_CIA)
    VALUES
      (F_OBTENER_SECUENCIA,
       PN_ANIO,
       PN_MES,
       PV_ARCHIVO,
       PV_RUTA,
       NULL,
       NULL,
       'I',
       SYSDATE,
       USER,
       NULL,
       NULL,
       PV_NOCIA);
    COMMIT;
    --END IF;
  
  EXCEPTION
    WHEN REGISTRO_DUPLICADO THEN
      PV_ERROR := 'El documento ' || PV_ARCHIVO ||
                  'ya ha sido ingresado/cargado para el periodo en proceso ' ||
                  pn_anio || '/' || pn_mes;
    WHEN OTHERS THEN
      PV_ERROR := SQLERRM;
  end;

  PROCEDURE P_ELIMINA_REGISTROS(PV_NOCIA IN VARCHAR2) IS
  
  BEGIN
    DELETE FROM NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
     WHERE A.ESTADO = 'I'
       AND A.NO_CIA = PV_NOCIA;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_EXTRAER_VALOR(PV_LINEA    IN VARCHAR2,
                            PV_ETIQUETA IN VARCHAR2,
                            PV_VALOR    OUT VARCHAR2) IS
    LN_POS_1 NUMBER;
    LN_POS_2 NUMBER;
  BEGIN
    LN_POS_1 := INSTR(PV_LINEA, PV_ETIQUETA, 1, 1);
    LN_POS_1 := INSTR(PV_LINEA, '>', LN_POS_1, 1);
    LN_POS_2 := INSTR(PV_LINEA, '</', LN_POS_1, 1);
  
    PV_VALOR := SUBSTR(PV_LINEA, LN_POS_1 + 1, (LN_POS_2 - LN_POS_1) - 1);
  END;

  FUNCTION F_TO_CLOB(PV_LINEA IN VARCHAR2) RETURN CLOB IS
  BEGIN
    RETURN TO_CLOB(PV_LINEA);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_ACTUALIZA_CARGA_ARCHIVO(PN_SECUENCIA           IN NUMBER,
                                      PV_ESTADO_AUTORIZACION IN VARCHAR2,
                                      PV_NUMERO_AUTORIZACION IN VARCHAR2,
                                      PV_FECHA_AUTORIZACION  IN VARCHAR2,
                                      PV_TIPO_DOCUMENTO      IN VARCHAR2,
                                      PV_VERSION             IN VARCHAR2,
                                      PN_CODIGO              IN NUMBER,
                                      PV_LINEA               IN VARCHAR2,
                                      PN_ANIO                IN NUMBER,
                                      PN_MES                 IN NUMBER,
                                      PV_ERROR               OUT VARCHAR2) IS
  
    LD_FECHA DATE;
    LE_ERROR_FECHA exception;
  BEGIN
  
    IF PN_CODIGO = 1 THEN
      BEGIN
        SELECT cast(to_timestamp(fecha, 'yyyy-mm-dd hh24:mi:ss.ff') as date)
          INTO LD_FECHA
          FROM (select PV_FECHA_AUTORIZACION as fecha from dual) a
         where REGEXP_LIKE(a.fecha,
                           '\d{4}-[0-9]?\d-[0-9]?\d\s[0-9]?\d:[0-9]?\d:[0-9]?\d.[0-9]+\d*');
      EXCEPTION
        WHEN OTHERS THEN
          BEGIN
            SELECT TO_DATE(SUBSTR(replace(fecha, 'T', ' '),
                                  1,
                                  INSTR(replace(fecha, 'T', ' '), ' ', 1, 1)) ||
                           SUBSTR(SUBSTR(replace(fecha, 'T', ' '),
                                         INSTR(replace(fecha, 'T', ' '),
                                               ' ',
                                               1,
                                               1)),
                                  1,
                                  INSTR(SUBSTR(replace(fecha, 'T', ' '),
                                               INSTR(replace(fecha, 'T', ' '),
                                                     ' ',
                                                     1,
                                                     1)),
                                        '-',
                                        1,
                                        1) - 1),
                           'yyyy-mm-dd hh24:mi:ss')
              INTO LD_FECHA
              FROM (select PV_FECHA_AUTORIZACION as fecha from dual) a
             where REGEXP_LIKE(a.fecha,
                               '\d{4}-[0-9]?\d-[0-9]?\dT[0-9]?\d:[0-9]?\d:[0-9]?\d-[0-9]?\d:[0-9]?\d');
          
          EXCEPTION
            WHEN OTHERS THEN
              BEGIN
              
                SELECT TO_DATE(fecha, 'DD/MM/YYYY HH24:MI:SS')
                  INTO LD_FECHA
                  FROM (select PV_FECHA_AUTORIZACION fecha from dual) a
                 where REGEXP_LIKE(a.fecha,
                                   '[0-9]?\d\/[0-9]?\d\/\d{4}\s[0-9]?\d:[0-9]?\d:[0-9]?\d');
              
              EXCEPTION
                WHEN OTHERS THEN
                  BEGIN
                  
                    SELECT TO_DATE(fecha, 'YYYY-MM-DD HH24:MI:SS')
                      INTO LD_FECHA
                      FROM (select PV_FECHA_AUTORIZACION fecha from dual) a
                     where REGEXP_LIKE(a.fecha,
                                       '\d{4}-[0-9]?\d-[0-9]?\d\s[0-9]?\d:[0-9]?\d:[0-9]?\d');
                  
                  EXCEPTION
                    WHEN OTHERS THEN
                      PV_ERROR := SQLERRM;
                      RAISE LE_ERROR_FECHA;
                  END;
              END;
          END;
      END;
    
      UPDATE NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
         SET A.ESTADO_AUT        = PV_ESTADO_AUTORIZACION,
             A.NUMERO_AUT        = PV_NUMERO_AUTORIZACION,
             A.FECHA_AUT         = LD_FECHA,
             A.TIPO_DOCUMENTO    = PV_TIPO_DOCUMENTO,
             A.VERSION_DOCUMENTO = PV_VERSION
       WHERE A.SECUENCIA_CARGA_ID = PN_SECUENCIA;
    ELSIF PN_CODIGO = 2 THEN
      UPDATE NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
         SET A.XML_DATA = A.XML_DATA || CHR(10) || PV_LINEA
       WHERE A.SECUENCIA_CARGA_ID = PN_SECUENCIA;
    ELSIF PN_CODIGO = 3 THEN
      UPDATE NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
         SET A.PERIODO_ANIO = PN_ANIO, A.PERIODO_MES = PN_MES
       WHERE A.ESTADO = 'I';
    END IF;
  
    COMMIT;
  EXCEPTION
    WHEN LE_ERROR_FECHA THEN
      PV_ERROR := 'Se ha detectado un formato incorrecto de fecha. ' ||
                  PV_ERROR;
    WHEN OTHERS THEN
      PV_ERROR := SQLERRM;
  END;

  procedure P_CARGA_INFORMACION(PV_NOCIA IN VARCHAR2,
                                pn_anio  IN number,
                                pn_mes   IN number,
                                pv_error out varchar2) is
  
    LV_RUC_DOCUMENTO    NAF47_TNET.INFO_TRIBUTARIA_DOC.RUC%TYPE;
    LN_SECUENCIA_EXISTE NAF47_TNET.INFO_ARCHIVOS_CARGADOS.SECUENCIA_CARGA_ID%TYPE;
  
    CURSOR C_GET_DOCUMENTOS(CN_ANIO NUMBER, CN_MES NUMBER) IS
      SELECT A.SECUENCIA_CARGA_ID,
             NOMBRE_ARCHIVO,
             XML_DATA,
             A.TIPO_DOCUMENTO,
             A.VERSION_DOCUMENTO,
             A.NO_CIA
        FROM NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
       WHERE A.PERIODO_ANIO = CN_ANIO
         AND A.PERIODO_MES = CN_MES
         AND A.ESTADO = 'I'
         AND A.NO_CIA = PV_NOCIA
         AND TRUNC(A.FE_CREACION) = TRUNC(SYSDATE);
  
    LC_DOCUMENTOS C_GET_DOCUMENTOS%ROWTYPE;
  
    --CURSOR INFORMACION TRIBUTARIA FACTURAS/RETENCION
    CURSOR C_GET_INFOTRIBUTARIA(PC_DATA CLOB, PV_TIPO_DOCUMENTO VARCHAR2) IS
      SELECT EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//ambiente') AMBIENTE,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//tipoEmision') TIPO_EMISION,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//razonSocial') RAZON_SOCIAL,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA),
                          '//nombreComercial') NOMBRE_COMERCIAL,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//ruc') RUC,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//claveAcceso') CLAVE_ACCESO,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//codDoc') COD_DOCUMENTO,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//estab') ESTABLECIMIENTO,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//ptoEmi') PTO_EMISION,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//secuencial') SECUENCIAL,
             EXTRACTvalue(value(INFORMACION_TRIBUTARIA), '//dirMatriz') DIR_MATRIZ
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '/' ||
                                       DECODE(PV_TIPO_DOCUMENTO,
                                              'FACTURA',
                                              'factura',
                                              'RETENCION',
                                              'comprobanteRetencion') ||
                                       '/infoTributaria'))) INFORMACION_TRIBUTARIA;
  
    L_INFO_TRIBUTARIA C_GET_INFOTRIBUTARIA%ROWTYPE;
  
    --CURSOR INFORMACION ADICIONAL
    CURSOR C_GET_INFOADICIONAL(PC_DATA CLOB, PV_TIPO_DOCUMENTO VARCHAR2) IS
      SELECT EXTRACTvalue(value(INFORMACION_ADICIONAL),
                          '//campoAdicional[@nombre=''valor' || level ||
                          ''']') CAMPO_ADICIONAL
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '/' ||
                                       DECODE(PV_TIPO_DOCUMENTO,
                                              'FACTURA',
                                              'factura',
                                              'RETENCION',
                                              'comprobanteRetencion') ||
                                       '/infoAdicional'))) INFORMACION_ADICIONAL
      connect by level <= 5;
  
    L_INFOADICIONAL C_GET_INFOADICIONAL%ROWTYPE;
  
    --CURSOR INFORMACION DEL DOCUMENTO
    CURSOR C_GET_INFODOCUMENTO(PC_DATA CLOB, PV_TIPO_DOCUMENTO VARCHAR2) IS
      SELECT EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//fechaEmision') FECHA_EMISION,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//dirEstablecimiento') DIR_ESTABLECIMIENTO,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC),
                          '//contribuyenteEspecial') CONTRIBUYENTE_ESPECIAL,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC),
                          '//obligadoContabilidad') OBLIGADO_CONTAB,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC),
                          '//tipoIdentificacionComprador') TIPO_IDENT_FACTURA,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC),
                          '//tipoIdentificacionSujetoRetenido') TIPO_IDENT_RETENCION,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC),
                          '//razonSocialComprador') RAZON_SOCIAL_FACTURA,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC),
                          '//razonSocialSujetoRetenido') RAZON_SOCIAL_RETENCION,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC),
                          '//identificacionComprador') IDENT_FACTURA,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC),
                          '//identificacionSujetoRetenido') IDENT_RETENCION,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//direccionComprador') DIRECCION_FACTURA,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//totalSinImpuestos') TOTAL_SIMP,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//totalDescuento') TOTAL_DESCUENTO,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//propina') PROPINA,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//importeTotal') IMPORTE_TOTAL,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//moneda') MONEDA,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//parteRel') PARTE_RELACIONADA,
             EXTRACTvalue(value(INFO_DOCUMENTO_FC), '//periodoFiscal') PERIODO_FISCAL
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '/' ||
                                       DECODE(PV_TIPO_DOCUMENTO,
                                              'FACTURA',
                                              'factura',
                                              'RETENCION',
                                              'comprobanteRetencion') || '/' ||
                                       DECODE(PV_TIPO_DOCUMENTO,
                                              'FACTURA',
                                              'infoFactura',
                                              'RETENCION',
                                              'infoCompRetencion')))) INFO_DOCUMENTO_FC;
  
    L_INFO_DOCUMENTO C_GET_INFODOCUMENTO%ROWTYPE;
  
    --CURSOR IMPUESTOS FACTURA
    CURSOR C_GET_INFOIMPUESTOS_F(PC_DATA CLOB) IS
      SELECT EXTRACTvalue(value(INFO_IMPUESTOS), '//codigo') CODIGO,
             EXTRACTvalue(value(INFO_IMPUESTOS), '//codigoPorcentaje') CODIGO_PORCENTAJE,
             EXTRACTvalue(value(INFO_IMPUESTOS), '//baseImponible') BASE_IMPONIBLE,
             EXTRACTvalue(value(INFO_IMPUESTOS), '//tarifa') TARIFA,
             EXTRACTvalue(value(INFO_IMPUESTOS), '//valor') VALOR
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '/factura/infoFactura/totalConImpuestos/totalImpuesto'))) INFO_IMPUESTOS;
  
    L_INFO_IMPUESTOS_F C_GET_INFOIMPUESTOS_F%ROWTYPE;
  
    --CURSOR IMPUESTOS RETENCION V 2.0.0
    CURSOR C_GET_INFOIMPUESTOS_R(PC_DATA             CLOB,
                                 PV_COD_SUSTENTO     VARCHAR2,
                                 PV_COd_DOC_SUSTENTO VARCHAR2) IS
      SELECT EXTRACTvalue(value(INFO_IMPUESTOS), '//codImpuestoDocSustento') CODIGO,
             EXTRACTvalue(value(INFO_IMPUESTOS), '//codigoPorcentaje') CODIGO_PORCENTAJE,
             EXTRACTvalue(value(INFO_IMPUESTOS), '//baseImponible') BASE_IMPONIBLE,
             EXTRACTvalue(value(INFO_IMPUESTOS), '//tarifa') TARIFA,
             EXTRACTvalue(value(INFO_IMPUESTOS), '//valorImpuesto') VALOR
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '//comprobanteRetencion/docsSustento/docSustento[codSustento=''' ||
                                       PV_COD_SUSTENTO ||
                                       ''' and codDocSustento=''' ||
                                       PV_COd_DOC_SUSTENTO ||
                                       ''']/impuestosDocSustento/impuestoDocSustento'))) INFO_IMPUESTOS;
  
    L_INFO_IMPUESTOS_R C_GET_INFOIMPUESTOS_R%ROWTYPE;
  
    --IMPUESTO RETENCIONES V 1.0.0
    CURSOR C_GET_INFOIMPUESTOS_R_100(PC_DATA CLOB) IS
      SELECT EXTRACTvalue(value(RETENCIONES_100), '//codigo') CODIGO_IMPUESTO,
             EXTRACTvalue(value(RETENCIONES_100), '//codigoRetencion') CODIGO_RETENCION,
             EXTRACTvalue(value(RETENCIONES_100), '//baseImponible') BASE_IMPONIBLE,
             EXTRACTvalue(value(RETENCIONES_100), '//porcentajeRetener') PORCENTAJE_RETENCION,
             EXTRACTvalue(value(RETENCIONES_100), '//valorRetenido') VALOR_RETENIDO,
             EXTRACTvalue(value(RETENCIONES_100), '//codDocSustento') COD_DOC_SUS,
             EXTRACTvalue(value(RETENCIONES_100), '//numDocSustento') NUM_DOC_SUS,
             TO_DATE(EXTRACTvalue(value(RETENCIONES_100),
                                  '//fechaEmisionDocSustento'),
                     'DD/MM/YYYY') FECHA_EMISI_DOC_SUS
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '//impuestos/impuesto'))) RETENCIONES_100;
  
    L_INFO_IMPUESTOS_R_100 C_GET_INFOIMPUESTOS_R_100%ROWTYPE;
  
    --CURSOR PAGO FACTURAS
    CURSOR C_GET_INFOPAGO_F(PC_DATA CLOB) IS
      SELECT EXTRACTvalue(value(INFO_PAGO), '//formaPago') FORMA_PAGO,
             EXTRACTvalue(value(INFO_PAGO), '//total') TOTAL,
             EXTRACTvalue(value(INFO_PAGO), '//plazo') PLAZO,
             EXTRACTvalue(value(INFO_PAGO), '//unidadTiempo') UNIDAD_TIEMPO
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '/factura/infoFactura/pagos/pago'))) INFO_PAGO;
  
    L_INFOPAGO_F C_GET_INFOPAGO_F%ROWTYPE;
  
    --CURSOR PAGO RETENCIONES
    CURSOR C_GET_INFOPAGO_R(PC_DATA             CLOB,
                            PV_COD_SUSTENTO     VARCHAR2,
                            PV_COd_DOC_SUSTENTO VARCHAR2) IS
      SELECT EXTRACTvalue(value(INFO_PAGO), '//formaPago') FORMA_PAGO,
             EXTRACTvalue(value(INFO_PAGO), '//total') TOTAL
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '//comprobanteRetencion/docsSustento/docSustento[codSustento=''' ||
                                       PV_COD_SUSTENTO ||
                                       ''' and codDocSustento=''' ||
                                       PV_COd_DOC_SUSTENTO ||
                                       ''']/pagos/pago'))) INFO_PAGO;
  
    L_INFOPAGO_R C_GET_INFOPAGO_R%ROWTYPE;
  
    --DETALLE FACTURA
    CURSOR C_GET_DETALLE_FACTURA(PC_DATA CLOB) IS
      SELECT EXTRACTvalue(value(DETALLE_FACT), '//codigoPrincipal') CODIGO_PRINCIPAL_ITEM,
             EXTRACTvalue(value(DETALLE_FACT), '//descripcion') DESCRIPCION_ITEM,
             EXTRACTvalue(value(DETALLE_FACT), '//cantidad') CANTIDAD,
             EXTRACTvalue(value(DETALLE_FACT), '//precioUnitario') PRECIO_UNITARIO,
             EXTRACTvalue(value(DETALLE_FACT), '//descuento') DESCUENTO,
             EXTRACTvalue(value(DETALLE_FACT), '//precioTotalSinImpuesto') PRECIO_TOTAL_SIMP
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '/factura/detalles/detalle'))) DETALLE_FACT;
  
    L_DETALLE_FACT C_GET_DETALLE_FACTURA%ROWTYPE;
  
    --INFO IMPUESTOS ITEM DETALLE FACTURA
    CURSOR C_GET_INFIMPUES_DET_ITEM_FACT(PC_DATA        CLOB,
                                         PV_CODIGO_ITEM VARCHAR2) IS
      SELECT EXTRACTvalue(value(IMP_DETALLE_FACT), '//codigo') CODIGO,
             EXTRACTvalue(value(IMP_DETALLE_FACT), '//codigoPorcentaje') CODIGO_PORCENTAJE,
             EXTRACTvalue(value(IMP_DETALLE_FACT), '//tarifa') TARIFA,
             EXTRACTvalue(value(IMP_DETALLE_FACT), '//baseImponible') BASE_IMPONIBLE,
             EXTRACTvalue(value(IMP_DETALLE_FACT), '//valor') VALOR
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '//factura/detalles/detalle[codigoPrincipal=''' ||
                                       PV_CODIGO_ITEM ||
                                       ''']/impuestos/impuesto'))) IMP_DETALLE_FACT;
  
    L_INFIMP_DETA_ITEM_FACT C_GET_INFIMPUES_DET_ITEM_FACT%ROWTYPE;
  
    --INFO SUSTENTO RETENCION
    CURSOR C_GET_INFO_SUSTENTO(PC_DATA CLOB) IS
      SELECT EXTRACTvalue(value(INFO_SUSTENTOS), '//codSustento') COD_SUSTENTO,
             EXTRACTvalue(value(INFO_SUSTENTOS), '//codDocSustento') COD_DOC_SUSTENTO,
             EXTRACTvalue(value(INFO_SUSTENTOS), '//numDocSustento') NUM_DOC_SUSTENTO,
             EXTRACTvalue(value(INFO_SUSTENTOS),
                          '//fechaEmisionDocSustento') FECHA_EMISION_SUSTENTO,
             EXTRACTvalue(value(INFO_SUSTENTOS), '//fechaRegistroContable') FECHA_REGISTRO_CONT,
             EXTRACTvalue(value(INFO_SUSTENTOS), '//numAutDocSustento') NUM_AUT_SUSTENTO,
             EXTRACTvalue(value(INFO_SUSTENTOS), '//pagoLocExt') PAGO_LOC_EXT,
             EXTRACTvalue(value(INFO_SUSTENTOS), '//totalSinImpuestos') TOTAL_SIMP,
             EXTRACTvalue(value(INFO_SUSTENTOS), '//importeTotal') IMPORTE_TOTAL
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '/comprobanteRetencion/docsSustento/docSustento'))) INFO_SUSTENTOS;
  
    L_INFOSUSTENTO C_GET_INFO_SUSTENTO%ROWTYPE;
  
    --INFO RETENCIONES SEGUN CODIGO DEL DOCUMENTO Y CODIGO DE SUSTENTO
    CURSOR C_GET_RETENCIONES_BY_SUSTENTO(PC_DATA             CLOB,
                                         PV_COD_SUSTENTO     VARCHAR2,
                                         PV_COS_DOC_SUSTENTO VARCHAR2) IS
      SELECT EXTRACTvalue(value(INFO_RETENCIONES), '//codigo') CODIGO,
             EXTRACTvalue(value(INFO_RETENCIONES), '//codigoRetencion') CODIGO_RETENCION,
             EXTRACTvalue(value(INFO_RETENCIONES), '//baseImponible') BASE_IMPONIBLE,
             EXTRACTvalue(value(INFO_RETENCIONES), '//porcentajeRetener') PORCENTAJE,
             EXTRACTvalue(value(INFO_RETENCIONES), '//valorRetenido') VALOR
        FROM table(xmlsequence(extract(xmltype(PC_DATA),
                                       '/comprobanteRetencion/docsSustento/docSustento[codSustento=''' ||
                                       PV_COD_SUSTENTO ||
                                       ''' and codDocSustento=''' ||
                                       PV_COS_DOC_SUSTENTO ||
                                       ''']/retenciones/retencion'))) INFO_RETENCIONES;
  
    L_RENTENCIONES C_GET_RETENCIONES_BY_SUSTENTO%ROWTYPE;
  
    LB_ENCONTRO      BOOLEAN;
    LN_SECUENCIA     NUMBER;
    LD_FECHA_EMISION DATE;
    LE_FECHA_PERIODO EXCEPTION;
    LN_NUM_ERRORES NUMBER;
  
  BEGIN
  
    OPEN C_GET_DOCUMENTOS(pn_anio, PN_MES);
    FETCH C_GET_DOCUMENTOS
      INTO LC_DOCUMENTOS;
    LB_ENCONTRO := C_GET_DOCUMENTOS%FOUND;
    CLOSE C_GET_DOCUMENTOS;
  
    IF NOT LB_ENCONTRO THEN
      PV_ERROR := 'No existen documentos para procesar.';
      RETURN;
    END IF;
  
    FOR DOCUMENTO IN C_GET_DOCUMENTOS(pn_anio, PN_MES) LOOP
      LN_SECUENCIA := DOCUMENTO.SECUENCIA_CARGA_ID;
      BEGIN
        --LN_SECUENCIA := NAF47_TNET.SRATS_SEQ_DOCUMENTO_XML.NEXTVAL;
        --se obtiene la informacion tributaria
        OPEN C_GET_INFOTRIBUTARIA(DOCUMENTO.XML_DATA,
                                  DOCUMENTO.TIPO_DOCUMENTO);
        FETCH C_GET_INFOTRIBUTARIA
          INTO L_INFO_TRIBUTARIA;
        LB_ENCONTRO := C_GET_INFOTRIBUTARIA%FOUND;
        CLOSE C_GET_INFOTRIBUTARIA;
      
        IF LB_ENCONTRO THEN
          /*VALIDA SECUENCIAL Y RUC QUE NO EXISTAN*/
          BEGIN
            SELECT A.SECUENCIA_CARGA_ID
              INTO LN_SECUENCIA_EXISTE
              FROM NAF47_TNET.INFO_TRIBUTARIA_DOC A
             WHERE A.SECUENCIAL_ID = L_INFO_TRIBUTARIA.SECUENCIAL
               AND A.RUC = L_INFO_TRIBUTARIA.RUC;
          
            --ERROR EL DOCUMENTO YA EXISTE
            P_ACTUALIZA_DOCUMENTO(PV_NOCIA,
                                  LN_SECUENCIA,
                                  'E',
                                  'El documento con SECUENCIAL=' ||
                                  L_INFO_TRIBUTARIA.SECUENCIAL || ' y RUC=' ||
                                  L_INFO_TRIBUTARIA.RUC ||
                                  ' ya ha sido cargado para el periodo actual.');
          
            COMMIT;
            CONTINUE;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              LN_SECUENCIA_EXISTE := -1;
          END;
        
          IF LN_SECUENCIA_EXISTE = -1 THEN
            P_INSERTA_INFOTRIBUTARIA(PN_SECUENCIA_DOC    => DOCUMENTO.SECUENCIA_CARGA_ID,
                                     PN_AMBIENTE         => L_INFO_TRIBUTARIA.AMBIENTE,
                                     PN_TIPO_EMISION     => L_INFO_TRIBUTARIA.TIPO_EMISION,
                                     PV_RAZON_SOCIAL     => L_INFO_TRIBUTARIA.RAZON_SOCIAL,
                                     PV_NOMBRE_COMERCIAL => L_INFO_TRIBUTARIA.NOMBRE_COMERCIAL,
                                     PV_RUC              => L_INFO_TRIBUTARIA.RUC,
                                     PV_CLAVE_ACCESO     => L_INFO_TRIBUTARIA.CLAVE_ACCESO,
                                     PV_COD_DOC          => L_INFO_TRIBUTARIA.COD_DOCUMENTO,
                                     PV_ESTAB            => L_INFO_TRIBUTARIA.ESTABLECIMIENTO,
                                     PV_PTO_EMI          => L_INFO_TRIBUTARIA.PTO_EMISION,
                                     PV_SECUENCIAL       => L_INFO_TRIBUTARIA.SECUENCIAL,
                                     PV_DIR_MATRIZ       => L_INFO_TRIBUTARIA.DIR_MATRIZ);
          END IF;
        END IF;
      
        --info documento
        OPEN C_GET_INFODOCUMENTO(DOCUMENTO.XML_DATA,
                                 DOCUMENTO.TIPO_DOCUMENTO);
        FETCH C_GET_INFODOCUMENTO
          INTO L_INFO_DOCUMENTO;
        LB_ENCONTRO := C_GET_INFODOCUMENTO%FOUND;
        CLOSE C_GET_INFODOCUMENTO;
      
        IF LB_ENCONTRO THEN
          --VALIDACION DE FECHA DE EMISION DEL DOCUMENTO Y EL PERIODO EN PROCESO
          LD_FECHA_EMISION := TO_DATE(L_INFO_DOCUMENTO.FECHA_EMISION,
                                      'DD/MM/YYYY');
          IF pn_anio != TO_NUMBER(TO_CHAR(LD_FECHA_EMISION, 'YYYY')) OR
             PN_MES != TO_NUMBER(TO_CHAR(LD_FECHA_EMISION, 'MM')) THEN
            RAISE LE_FECHA_PERIODO;
          END IF;
        
          IF DOCUMENTO.TIPO_DOCUMENTO = 'FACTURA' THEN
            P_INSERTA_INFODOCUMENTO(PN_SECUENCIA         => DOCUMENTO.SECUENCIA_CARGA_ID,
                                    PV_FECHA_EMISION     => L_INFO_DOCUMENTO.FECHA_EMISION,
                                    PV_DIRECCION_ESTAB   => L_INFO_DOCUMENTO.DIR_ESTABLECIMIENTO,
                                    PV_CONTRIBUYENTE_ESP => L_INFO_DOCUMENTO.CONTRIBUYENTE_ESPECIAL,
                                    PV_OBLIGADO_CONTAB   => L_INFO_DOCUMENTO.OBLIGADO_CONTAB,
                                    PV_TIPO_IDENT        => L_INFO_DOCUMENTO.TIPO_IDENT_FACTURA,
                                    PV_RAZON_SOCIAL      => L_INFO_DOCUMENTO.RAZON_SOCIAL_FACTURA,
                                    PV_IDENTIFICACION    => L_INFO_DOCUMENTO.IDENT_FACTURA,
                                    PV_DIRECCION_COMP    => L_INFO_DOCUMENTO.DIRECCION_FACTURA,
                                    PN_TOTA_SIMP         => L_INFO_DOCUMENTO.TOTAL_SIMP,
                                    PN_TOTAL_DESC        => L_INFO_DOCUMENTO.TOTAL_DESCUENTO,
                                    PN_PROPINA           => L_INFO_DOCUMENTO.PROPINA,
                                    PN_IMPORTE_TOTAL     => L_INFO_DOCUMENTO.IMPORTE_TOTAL,
                                    PV_MONEDA            => L_INFO_DOCUMENTO.MONEDA,
                                    PV_PARTE_REL         => L_INFO_DOCUMENTO.PARTE_RELACIONADA,
                                    PN_PERIODO_FISCAL    => L_INFO_DOCUMENTO.PERIODO_FISCAL);
          ELSIF DOCUMENTO.TIPO_DOCUMENTO = 'RETENCION' THEN
            /*CONSULTA RUC*/
            BEGIN
              SELECT A.RUC
                INTO LV_RUC_DOCUMENTO
                FROM NAF47_TNET.INFO_TRIBUTARIA_DOC A
               WHERE A.SECUENCIA_CARGA_ID = DOCUMENTO.SECUENCIA_CARGA_ID;
            END;
          
            P_INSERTA_INFODOCUMENTO(PN_SECUENCIA         => DOCUMENTO.SECUENCIA_CARGA_ID,
                                    PV_FECHA_EMISION     => L_INFO_DOCUMENTO.FECHA_EMISION,
                                    PV_DIRECCION_ESTAB   => L_INFO_DOCUMENTO.DIR_ESTABLECIMIENTO,
                                    PV_CONTRIBUYENTE_ESP => L_INFO_DOCUMENTO.CONTRIBUYENTE_ESPECIAL,
                                    PV_OBLIGADO_CONTAB   => L_INFO_DOCUMENTO.OBLIGADO_CONTAB,
                                    PV_TIPO_IDENT        => L_INFO_DOCUMENTO.TIPO_IDENT_RETENCION,
                                    PV_RAZON_SOCIAL      => L_INFO_DOCUMENTO.RAZON_SOCIAL_RETENCION,
                                    PV_IDENTIFICACION    => LV_RUC_DOCUMENTO, --L_INFO_DOCUMENTO.IDENT_RETENCION,
                                    PV_DIRECCION_COMP    => L_INFO_DOCUMENTO.DIRECCION_FACTURA,
                                    PN_TOTA_SIMP         => L_INFO_DOCUMENTO.TOTAL_SIMP,
                                    PN_TOTAL_DESC        => L_INFO_DOCUMENTO.TOTAL_DESCUENTO,
                                    PN_PROPINA           => L_INFO_DOCUMENTO.PROPINA,
                                    PN_IMPORTE_TOTAL     => L_INFO_DOCUMENTO.IMPORTE_TOTAL,
                                    PV_MONEDA            => L_INFO_DOCUMENTO.MONEDA,
                                    PV_PARTE_REL         => L_INFO_DOCUMENTO.PARTE_RELACIONADA,
                                    PN_PERIODO_FISCAL    => L_INFO_DOCUMENTO.PERIODO_FISCAL);
          END IF;
        END IF;
      
        IF DOCUMENTO.TIPO_DOCUMENTO = 'FACTURA' THEN
          --impuestos factura
          OPEN C_GET_INFOIMPUESTOS_F(DOCUMENTO.XML_DATA);
          FETCH C_GET_INFOIMPUESTOS_F
            INTO L_INFO_IMPUESTOS_F;
          LB_ENCONTRO := C_GET_INFOIMPUESTOS_F%FOUND;
          CLOSE C_GET_INFOIMPUESTOS_F;
        
          IF LB_ENCONTRO THEN
            FOR IMPUESTO IN C_GET_INFOIMPUESTOS_F(DOCUMENTO.XML_DATA) LOOP
              P_INSERTA_INFOIMPUESTOS(PN_SECUENCIA        => DOCUMENTO.SECUENCIA_CARGA_ID,
                                      PN_CODIGO           => IMPUESTO.CODIGO,
                                      PV_COD_PORCENTAJE   => IMPUESTO.CODIGO_PORCENTAJE,
                                      PN_TARIFA           => IMPUESTO.TARIFA,
                                      PN_BASE_IMPONIBLE   => IMPUESTO.BASE_IMPONIBLE,
                                      PN_VALOR            => IMPUESTO.VALOR,
                                      PN_COD_SUSTENTO     => NULL,
                                      PN_COD_DOC_SUSTENTO => NULL,
                                      PV_COD_ITEM         => NULL);
            END LOOP;
          END IF;
        
          --PAGOS FACTURA
          OPEN C_GET_INFOPAGO_F(DOCUMENTO.XML_DATA);
          FETCH C_GET_INFOPAGO_F
            INTO L_INFOPAGO_F;
          LB_ENCONTRO := C_GET_INFOPAGO_F%FOUND;
          CLOSE C_GET_INFOPAGO_F;
        
          IF LB_ENCONTRO THEN
            FOR PAGO IN C_GET_INFOPAGO_F(DOCUMENTO.XML_DATA) LOOP
              P_INSERTA_INFOPAGOS(PN_SECUENCIA        => DOCUMENTO.SECUENCIA_CARGA_ID,
                                  PV_FORMA_PAGO       => PAGO.FORMA_PAGO,
                                  PN_TOTAL            => PAGO.TOTAL,
                                  PN_PLAZO            => PAGO.PLAZO,
                                  PV_UNIDAD_TIEMPO    => PAGO.UNIDAD_TIEMPO,
                                  PN_COD_SUSTENTO     => NULL,
                                  PN_COD_DOC_SUSTENTO => NULL);
            END LOOP;
          END IF;
        
          --DETALLE FACTURA
          OPEN C_GET_DETALLE_FACTURA(DOCUMENTO.XML_DATA);
          FETCH C_GET_DETALLE_FACTURA
            INTO L_DETALLE_FACT;
          LB_ENCONTRO := C_GET_DETALLE_FACTURA%FOUND;
          CLOSE C_GET_DETALLE_FACTURA;
        
          IF LB_ENCONTRO THEN
            FOR DETALLE IN C_GET_DETALLE_FACTURA(DOCUMENTO.XML_DATA) LOOP
              P_INSERTA_DETALLE_FACTURA(PN_SECUENCIA         => DOCUMENTO.SECUENCIA_CARGA_ID,
                                        PV_COD_PRINCIPAL     => DETALLE.CODIGO_PRINCIPAL_ITEM,
                                        PV_DESCRIPCION       => DETALLE.DESCRIPCION_ITEM,
                                        PN_CANTIDAD          => DETALLE.CANTIDAD,
                                        PN_PRECIO_UNITARIO   => DETALLE.PRECIO_UNITARIO,
                                        PN_DESCUENTO         => DETALLE.DESCUENTO,
                                        PN_PRECIO_TOTAL_SIMP => DETALLE.PRECIO_TOTAL_SIMP);
            
              --IMPUESTO DEL ITEM ITERADO
              OPEN C_GET_INFIMPUES_DET_ITEM_FACT(DOCUMENTO.XML_DATA,
                                                 DETALLE.CODIGO_PRINCIPAL_ITEM);
              FETCH C_GET_INFIMPUES_DET_ITEM_FACT
                INTO L_INFIMP_DETA_ITEM_FACT;
              LB_ENCONTRO := C_GET_INFIMPUES_DET_ITEM_FACT%FOUND;
              CLOSE C_GET_INFIMPUES_DET_ITEM_FACT;
            
              IF LB_ENCONTRO THEN
                FOR IMPUESTO IN C_GET_INFIMPUES_DET_ITEM_FACT(DOCUMENTO.XML_DATA,
                                                              DETALLE.CODIGO_PRINCIPAL_ITEM) LOOP
                  P_INSERTA_INFOIMPUESTOS(PN_SECUENCIA        => DOCUMENTO.SECUENCIA_CARGA_ID,
                                          PN_CODIGO           => IMPUESTO.CODIGO,
                                          PV_COD_PORCENTAJE   => IMPUESTO.CODIGO_PORCENTAJE,
                                          PN_TARIFA           => IMPUESTO.TARIFA,
                                          PN_BASE_IMPONIBLE   => IMPUESTO.BASE_IMPONIBLE,
                                          PN_VALOR            => IMPUESTO.VALOR,
                                          PN_COD_SUSTENTO     => NULL,
                                          PN_COD_DOC_SUSTENTO => NULL,
                                          PV_COD_ITEM         => DETALLE.CODIGO_PRINCIPAL_ITEM);
                END LOOP;
              END IF;
            END LOOP;
          END IF;
        
        ELSIF DOCUMENTO.TIPO_DOCUMENTO = 'RETENCION' THEN
          --DOCUMENTOS DE SUSTENTOS
          IF DOCUMENTO.VERSION_DOCUMENTO = '2.0.0' THEN
            OPEN C_GET_INFO_SUSTENTO(DOCUMENTO.XML_DATA);
            FETCH C_GET_INFO_SUSTENTO
              INTO L_INFOSUSTENTO;
            LB_ENCONTRO := C_GET_INFO_SUSTENTO%FOUND;
            CLOSE C_GET_INFO_SUSTENTO;
          
            FOR SUSTENTO IN C_GET_INFO_SUSTENTO(DOCUMENTO.XML_DATA) LOOP
              P_INSERTA_SUSTENTO(PN_SECUENCIA          => DOCUMENTO.SECUENCIA_CARGA_ID,
                                 PN_COD_SUSTENTO       => SUSTENTO.COD_SUSTENTO,
                                 PN_COD_DOC_SUSTENTO   => SUSTENTO.COD_DOC_SUSTENTO,
                                 PV_NUM_DOC_SUSTENTO   => SUSTENTO.NUM_DOC_SUSTENTO,
                                 PD_FECHA_EMISION      => TO_DATE(SUSTENTO.FECHA_EMISION_SUSTENTO,
                                                                  'DD/MM/YYYY'),
                                 PD_FECHA_REG_CONTABLE => TO_DATE(SUSTENTO.FECHA_REGISTRO_CONT,
                                                                  'DD/MM/YYYY'),
                                 PV_NUM_AUT            => SUSTENTO.NUM_AUT_SUSTENTO,
                                 PV_PAGO_LOC           => SUSTENTO.PAGO_LOC_EXT,
                                 PN_TOTAL_SIMP         => SUSTENTO.TOTAL_SIMP,
                                 PN_IMPORTE_TOTAL      => SUSTENTO.IMPORTE_TOTAL);
            
              --IMPUESTOS
              OPEN C_GET_INFOIMPUESTOS_R(DOCUMENTO.XML_DATA,
                                         SUSTENTO.COD_SUSTENTO,
                                         SUSTENTO.COD_DOC_SUSTENTO);
              FETCH C_GET_INFOIMPUESTOS_R
                INTO L_INFO_IMPUESTOS_R;
              LB_ENCONTRO := C_GET_INFOIMPUESTOS_R%FOUND;
              CLOSE C_GET_INFOIMPUESTOS_R;
            
              IF LB_ENCONTRO THEN
                FOR IMPUESTO IN C_GET_INFOIMPUESTOS_R(DOCUMENTO.XML_DATA,
                                                      SUSTENTO.COD_SUSTENTO,
                                                      SUSTENTO.COD_DOC_SUSTENTO) LOOP
                  P_INSERTA_INFOIMPUESTOS(PN_SECUENCIA        => DOCUMENTO.SECUENCIA_CARGA_ID,
                                          PN_CODIGO           => IMPUESTO.CODIGO,
                                          PV_COD_PORCENTAJE   => IMPUESTO.CODIGO_PORCENTAJE,
                                          PN_TARIFA           => IMPUESTO.TARIFA,
                                          PN_BASE_IMPONIBLE   => IMPUESTO.BASE_IMPONIBLE,
                                          PN_VALOR            => IMPUESTO.VALOR,
                                          PN_COD_SUSTENTO     => SUSTENTO.COD_SUSTENTO,
                                          PN_COD_DOC_SUSTENTO => SUSTENTO.COD_DOC_SUSTENTO,
                                          PV_COD_ITEM         => NULL);
                END LOOP;
              END IF;
            
              --RETENCIONES
              OPEN C_GET_RETENCIONES_BY_SUSTENTO(DOCUMENTO.XML_DATA,
                                                 SUSTENTO.COD_SUSTENTO,
                                                 SUSTENTO.COD_DOC_SUSTENTO);
              FETCH C_GET_RETENCIONES_BY_SUSTENTO
                INTO L_RENTENCIONES;
              LB_ENCONTRO := C_GET_RETENCIONES_BY_SUSTENTO%FOUND;
              CLOSE C_GET_RETENCIONES_BY_SUSTENTO;
            
              IF LB_ENCONTRO THEN
                FOR RETENCION IN C_GET_RETENCIONES_BY_SUSTENTO(DOCUMENTO.XML_DATA,
                                                               SUSTENTO.COD_SUSTENTO,
                                                               SUSTENTO.COD_DOC_SUSTENTO) LOOP
                  P_INSERTA_INFORETENCION(PN_SECUENCIA        => DOCUMENTO.SECUENCIA_CARGA_ID,
                                          PN_CODIGO           => RETENCION.CODIGO,
                                          PV_COD_RETENCION    => RETENCION.CODIGO_RETENCION,
                                          PN_BASE             => RETENCION.BASE_IMPONIBLE,
                                          PN_PORCENTAJE       => RETENCION.PORCENTAJE,
                                          PN_VALOR            => RETENCION.VALOR,
                                          PN_COD_SUSTENTO     => SUSTENTO.COD_SUSTENTO,
                                          PN_COD_DOC_SUSTENTO => SUSTENTO.COD_DOC_SUSTENTO);
                END LOOP;
              END IF;
            
              --PAGOS
              OPEN C_GET_INFOPAGO_R(DOCUMENTO.XML_DATA,
                                    SUSTENTO.COD_SUSTENTO,
                                    SUSTENTO.COD_DOC_SUSTENTO);
              FETCH C_GET_INFOPAGO_R
                INTO L_INFOPAGO_R;
              LB_ENCONTRO := C_GET_INFOPAGO_R%FOUND;
              CLOSE C_GET_INFOPAGO_R;
            
              IF LB_ENCONTRO THEN
                FOR PAGO IN C_GET_INFOPAGO_R(DOCUMENTO.XML_DATA,
                                             SUSTENTO.COD_SUSTENTO,
                                             SUSTENTO.COD_DOC_SUSTENTO) LOOP
                  P_INSERTA_INFOPAGOS(PN_SECUENCIA        => DOCUMENTO.SECUENCIA_CARGA_ID,
                                      PV_FORMA_PAGO       => PAGO.FORMA_PAGO,
                                      PN_TOTAL            => PAGO.TOTAL,
                                      PN_PLAZO            => NULL,
                                      PV_UNIDAD_TIEMPO    => NULL,
                                      PN_COD_SUSTENTO     => SUSTENTO.COD_SUSTENTO,
                                      PN_COD_DOC_SUSTENTO => SUSTENTO.COD_DOC_SUSTENTO);
                END LOOP;
              END IF;
            END LOOP;
          
            OPEN C_GET_INFOIMPUESTOS_R(DOCUMENTO.XML_DATA, null, null);
            FETCH C_GET_INFOIMPUESTOS_R
              INTO L_INFO_IMPUESTOS_R;
            --LB_ENCONTRO := C_GET_INFOIMPUESTOS_R%FOUND;
            CLOSE C_GET_INFOIMPUESTOS_R;
          
            OPEN C_GET_INFOPAGO_R(DOCUMENTO.XML_DATA, null, null);
            FETCH C_GET_INFOPAGO_R
              INTO L_INFOPAGO_R;
            CLOSE C_GET_INFOPAGO_R;
          ELSIF DOCUMENTO.VERSION_DOCUMENTO = '1.0.0' THEN
            OPEN C_GET_INFOIMPUESTOS_R_100(DOCUMENTO.XML_DATA);
            FETCH C_GET_INFOIMPUESTOS_R_100
              INTO L_INFO_IMPUESTOS_R_100;
            LB_ENCONTRO := C_GET_INFOIMPUESTOS_R_100%FOUND;
            CLOSE C_GET_INFOIMPUESTOS_R_100;
          
            IF LB_ENCONTRO THEN
              FOR IMPUESTO_RET IN C_GET_INFOIMPUESTOS_R_100(DOCUMENTO.XML_DATA) LOOP
                P_INSERTA_SUSTENTO(PN_SECUENCIA          => DOCUMENTO.SECUENCIA_CARGA_ID,
                                   PN_COD_SUSTENTO       => NULL,
                                   PN_COD_DOC_SUSTENTO   => IMPUESTO_RET.COD_DOC_SUS,
                                   PV_NUM_DOC_SUSTENTO   => IMPUESTO_RET.NUM_DOC_SUS,
                                   PD_FECHA_EMISION      => IMPUESTO_RET.FECHA_EMISI_DOC_SUS,
                                   PD_FECHA_REG_CONTABLE => NULL,
                                   PV_NUM_AUT            => NULL,
                                   PV_PAGO_LOC           => NULL,
                                   PN_TOTAL_SIMP         => NULL,
                                   PN_IMPORTE_TOTAL      => NULL);
              
                P_INSERTA_INFORETENCION(PN_SECUENCIA        => DOCUMENTO.SECUENCIA_CARGA_ID,
                                        PN_CODIGO           => IMPUESTO_RET.CODIGO_IMPUESTO,
                                        PV_COD_RETENCION    => IMPUESTO_RET.CODIGO_RETENCION,
                                        PN_BASE             => IMPUESTO_RET.BASE_IMPONIBLE,
                                        PN_PORCENTAJE       => IMPUESTO_RET.PORCENTAJE_RETENCION,
                                        PN_VALOR            => IMPUESTO_RET.VALOR_RETENIDO,
                                        PN_COD_SUSTENTO     => NULL,
                                        PN_COD_DOC_SUSTENTO => IMPUESTO_RET.COD_DOC_SUS);
              END LOOP;
            END IF;
          END IF;
        END IF;
      
        --informaci?n adicional
        OPEN C_GET_INFOADICIONAL(DOCUMENTO.XML_DATA,
                                 DOCUMENTO.TIPO_DOCUMENTO);
        FETCH C_GET_INFOADICIONAL
          INTO L_INFOADICIONAL;
        LB_ENCONTRO := C_GET_INFOADICIONAL%FOUND;
        CLOSE C_GET_INFOADICIONAL;
      
        IF LB_ENCONTRO THEN
          FOR ADICIONAL IN C_GET_INFOADICIONAL(DOCUMENTO.XML_DATA,
                                               DOCUMENTO.TIPO_DOCUMENTO) LOOP
            IF ADICIONAL.CAMPO_ADICIONAL IS NOT NULL THEN
              P_INSERTA_INFOADICIONAL(PN_SECUENCIA   => DOCUMENTO.SECUENCIA_CARGA_ID,
                                      PV_DESCRIPCION => ADICIONAL.CAMPO_ADICIONAL);
            END IF;
          END LOOP;
        END IF;
      
        P_ACTUALIZA_DOCUMENTO(PV_NOCIA,
                              DOCUMENTO.SECUENCIA_CARGA_ID,
                              'C',
                              'Cargado');
      
        COMMIT;
      EXCEPTION
        WHEN LE_FECHA_PERIODO THEN
          ROLLBACK;
          P_ACTUALIZA_DOCUMENTO(PV_NOCIA,
                                LN_SECUENCIA,
                                'E',
                                'El documento no pertenece al periodo en proceso.');
          COMMIT;
        WHEN OTHERS THEN
          ROLLBACK;
          P_ACTUALIZA_DOCUMENTO(PV_NOCIA,
                                LN_SECUENCIA,
                                'E',
                                'Error al completar proceso de carga. [' ||
                                sqlerrm || ']');
          COMMIT;
      END;
    END LOOP;
  
    PV_ERROR := 'Documentos cargados con exito.';
  
    --VALIDACION DE ERRORES
    LN_NUM_ERRORES := F_NUM_ERRORES(PV_NOCIA, PN_ANIO, PN_MES);
  
    IF LN_NUM_ERRORES > 0 THEN
      PV_ERROR := 'Algunos documentos presentaron inconvenientes y no fueron cargados.';
    END IF;
  end;

  FUNCTION F_NUM_ERRORES(PV_NOCIA IN VARCHAR2,
                         PN_ANIO  IN NUMBER,
                         PN_MES   IN NUMBER) RETURN NUMBER IS
    LN_NUM NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO LN_NUM
      FROM NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
     WHERE A.ESTADO = 'E'
       AND A.NO_CIA = PV_NOCIA
       AND A.PERIODO_ANIO = PN_ANIO
       AND A.PERIODO_MES = PN_MES;
  
    RETURN LN_NUM;
  END;

  PROCEDURE P_ACTUALIZA_DOCUMENTO(PV_NOCIA       IN VARCHAR2,
                                  PN_SECUENCIA   IN NUMBER,
                                  PV_ESTADO      IN NAF47_TNET.INFO_ARCHIVOS_CARGADOS.ESTADO%TYPE,
                                  PV_OBSERVACION IN NAF47_TNET.INFO_ARCHIVOS_CARGADOS.OBSERVACION%TYPE) IS
  
  BEGIN
    UPDATE NAF47_TNET.INFO_ARCHIVOS_CARGADOS A
       SET A.ESTADO           = PV_ESTADO,
           A.OBSERVACION      = PV_OBSERVACION,
           A.FE_MODIFICACION  = SYSDATE,
           A.USR_MODIFICACION = USER
     WHERE A.SECUENCIA_CARGA_ID = PN_SECUENCIA
       AND A.NO_CIA = PV_NOCIA;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  FUNCTION F_OBTENER_SECUENCIA RETURN NUMBER IS
    LN_SEQ NUMBER;
  BEGIN
    SELECT NAF47_TNET.SEQ_INFO_CARGA_ARCHIVOS.NEXTVAL
      INTO LN_SEQ
      FROM DUAL;
    RETURN LN_SEQ;
  END;

  PROCEDURE P_INSERTA_INFOTRIBUTARIA(PN_SECUENCIA_DOC    IN NUMBER,
                                     PN_AMBIENTE         IN NAF47_TNET.INFO_TRIBUTARIA_DOC.AMBIENTE_ID%TYPE,
                                     PN_TIPO_EMISION     IN NAF47_TNET.INFO_TRIBUTARIA_DOC.TIPO_EMISION_ID%TYPE,
                                     PV_RAZON_SOCIAL     IN NAF47_TNET.INFO_TRIBUTARIA_DOC.RAZON_SOCIAL%TYPE,
                                     PV_NOMBRE_COMERCIAL IN NAF47_TNET.INFO_TRIBUTARIA_DOC.NOMBRE_COMERCIAL%TYPE,
                                     PV_RUC              IN NAF47_TNET.INFO_TRIBUTARIA_DOC.RUC%TYPE,
                                     PV_CLAVE_ACCESO     IN NAF47_TNET.INFO_TRIBUTARIA_DOC.CLAVE_ACCESO%TYPE,
                                     PV_COD_DOC          IN NAF47_TNET.INFO_TRIBUTARIA_DOC.DOCUMENTO_ID%TYPE,
                                     PV_ESTAB            IN NAF47_TNET.INFO_TRIBUTARIA_DOC.ESTABLECIMIENTO%TYPE,
                                     PV_PTO_EMI          IN NAF47_TNET.INFO_TRIBUTARIA_DOC.PUNTO_EMISION%TYPE,
                                     PV_SECUENCIAL       IN NAF47_TNET.INFO_TRIBUTARIA_DOC.SECUENCIAL_ID%TYPE,
                                     PV_DIR_MATRIZ       IN NAF47_TNET.INFO_TRIBUTARIA_DOC.DIR_MATRIZ%TYPE) IS
  BEGIN
    INSERT INTO NAF47_TNET.INFO_TRIBUTARIA_DOC
      (SECUENCIA_CARGA_ID,
       AMBIENTE_ID,
       TIPO_EMISION_ID,
       RAZON_SOCIAL,
       NOMBRE_COMERCIAL,
       RUC,
       CLAVE_ACCESO,
       DOCUMENTO_ID,
       ESTABLECIMIENTO,
       PUNTO_EMISION,
       SECUENCIAL_ID,
       DIR_MATRIZ)
    VALUES
      (PN_SECUENCIA_DOC,
       PN_AMBIENTE,
       PN_TIPO_EMISION,
       PV_RAZON_SOCIAL,
       PV_NOMBRE_COMERCIAL,
       PV_RUC,
       PV_CLAVE_ACCESO,
       PV_COD_DOC,
       PV_ESTAB,
       PV_PTO_EMI,
       PV_SECUENCIAL,
       PV_DIR_MATRIZ);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_INSERTA_INFODOCUMENTO(PN_SECUENCIA         IN NUMBER,
                                    PV_FECHA_EMISION     IN NAF47_TNET.INFO_FACTURA_RETENCION.FE_EMISION%TYPE,
                                    PV_DIRECCION_ESTAB   IN NAF47_TNET.INFO_FACTURA_RETENCION.DIRECCION_ESTABLECIMIENTO%TYPE,
                                    PV_CONTRIBUYENTE_ESP IN NAF47_TNET.INFO_FACTURA_RETENCION.CONTRIBUYENTE_ESPECIAL%TYPE,
                                    PV_OBLIGADO_CONTAB   IN NAF47_TNET.INFO_FACTURA_RETENCION.OBLIGADO_CONTABILIDAD%TYPE,
                                    PV_TIPO_IDENT        IN NAF47_TNET.INFO_FACTURA_RETENCION.TIPO_IDENTIFICACION%TYPE,
                                    PV_RAZON_SOCIAL      IN NAF47_TNET.INFO_FACTURA_RETENCION.RAZON_SOCIAL%TYPE,
                                    PV_IDENTIFICACION    IN NAF47_TNET.INFO_FACTURA_RETENCION.IDENTIFICACION%TYPE,
                                    PV_DIRECCION_COMP    IN NAF47_TNET.INFO_FACTURA_RETENCION.DIRECCION_COMPRADOR%TYPE,
                                    PN_TOTA_SIMP         IN NAF47_TNET.INFO_FACTURA_RETENCION.TOTAL_SIMP%TYPE,
                                    PN_TOTAL_DESC        IN NAF47_TNET.INFO_FACTURA_RETENCION.TOTAL_DESC%TYPE,
                                    PN_PROPINA           IN NAF47_TNET.INFO_FACTURA_RETENCION.PROPINA%TYPE,
                                    PN_IMPORTE_TOTAL     IN NAF47_TNET.INFO_FACTURA_RETENCION.IMPORTE_TOTAL%TYPE,
                                    PV_MONEDA            IN NAF47_TNET.INFO_FACTURA_RETENCION.MONEDA%TYPE,
                                    PV_PARTE_REL         IN NAF47_TNET.INFO_FACTURA_RETENCION.PARTE_REL%TYPE,
                                    PN_PERIODO_FISCAL    IN NAF47_TNET.INFO_FACTURA_RETENCION.PERIODO_FISCAL%TYPE) IS
  BEGIN
    INSERT INTO NAF47_TNET.INFO_FACTURA_RETENCION
      (SECUENCIA_CARGA_ID,
       FE_EMISION,
       DIRECCION_ESTABLECIMIENTO,
       CONTRIBUYENTE_ESPECIAL,
       OBLIGADO_CONTABILIDAD,
       TIPO_IDENTIFICACION,
       RAZON_SOCIAL,
       IDENTIFICACION,
       DIRECCION_COMPRADOR,
       TOTAL_SIMP,
       TOTAL_DESC,
       PROPINA,
       IMPORTE_TOTAL,
       MONEDA,
       PARTE_REL,
       PERIODO_FISCAL)
    VALUES
      (PN_SECUENCIA,
       TO_DATE(PV_FECHA_EMISION, 'DD/MM/YYYY'),
       PV_DIRECCION_ESTAB,
       PV_CONTRIBUYENTE_ESP,
       PV_OBLIGADO_CONTAB,
       PV_TIPO_IDENT,
       PV_RAZON_SOCIAL,
       PV_IDENTIFICACION,
       PV_DIRECCION_COMP,
       PN_TOTA_SIMP,
       PN_TOTAL_DESC,
       PN_PROPINA,
       PN_IMPORTE_TOTAL,
       PV_MONEDA,
       PV_PARTE_REL,
       PN_PERIODO_FISCAL);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_INSERTA_INFOIMPUESTOS(PN_SECUENCIA        IN NUMBER,
                                    PN_CODIGO           IN NAF47_TNET.INFO_IMPUESTOS.IMPUESTO_ID%TYPE,
                                    PV_COD_PORCENTAJE   IN NAF47_TNET.INFO_IMPUESTOS.PORCENTAJE_ID%TYPE,
                                    PN_TARIFA           IN NAF47_TNET.INFO_IMPUESTOS.TARIFA%TYPE,
                                    PN_BASE_IMPONIBLE   IN NAF47_TNET.INFO_IMPUESTOS.BASE_IMPONIBLE%TYPE,
                                    PN_VALOR            IN NAF47_TNET.INFO_IMPUESTOS.VALOR%TYPE,
                                    PN_COD_SUSTENTO     IN NAF47_TNET.INFO_IMPUESTOS.SUSTENTO_ID%TYPE,
                                    PN_COD_DOC_SUSTENTO IN NAF47_TNET.INFO_IMPUESTOS.DOC_SUSTENTO_ID%TYPE,
                                    PV_COD_ITEM         IN NAF47_TNET.INFO_IMPUESTOS.ITEM_FACTURA_ID%TYPE) IS
  
  BEGIN
    INSERT INTO NAF47_TNET.INFO_IMPUESTOS
      (SECUENCIA_CARGA_ID,
       IMPUESTO_ID,
       PORCENTAJE_ID,
       TARIFA,
       BASE_IMPONIBLE,
       VALOR,
       SUSTENTO_ID,
       DOC_SUSTENTO_ID,
       ITEM_FACTURA_ID)
    values
      (PN_SECUENCIA,
       PN_CODIGO,
       PV_COD_PORCENTAJE,
       PN_TARIFA,
       PN_BASE_IMPONIBLE,
       PN_VALOR,
       PN_COD_SUSTENTO,
       PN_COD_DOC_SUSTENTO,
       PV_COD_ITEM);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_INSERTA_INFOPAGOS(PN_SECUENCIA        IN NUMBER,
                                PV_FORMA_PAGO       IN NAF47_TNET.INFO_PAGO.FORMA_PAGO_ID%TYPE,
                                PN_TOTAL            IN NAF47_TNET.INFO_PAGO.TOTAL%TYPE,
                                PN_PLAZO            IN NAF47_TNET.INFO_PAGO.PLAZO%TYPE,
                                PV_UNIDAD_TIEMPO    IN NAF47_TNET.INFO_PAGO.UNIDAD_TIEMPO%TYPE,
                                PN_COD_SUSTENTO     IN NAF47_TNET.INFO_PAGO.SUSTENTO_ID%TYPE,
                                PN_COD_DOC_SUSTENTO IN NAF47_TNET.INFO_PAGO.DOC_SUSTENTO_ID%TYPE) IS
  
  BEGIN
    INSERT INTO NAF47_TNET.INFO_PAGO
      (SECUENCIA_CARGA_ID,
       FORMA_PAGO_ID,
       TOTAL,
       PLAZO,
       UNIDAD_TIEMPO,
       SUSTENTO_ID,
       DOC_SUSTENTO_ID)
    VALUES
      (PN_SECUENCIA,
       PV_FORMA_PAGO,
       PN_TOTAL,
       PN_PLAZO,
       PV_UNIDAD_TIEMPO,
       PN_COD_SUSTENTO,
       PN_COD_DOC_SUSTENTO);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_INSERTA_DETALLE_FACTURA(PN_SECUENCIA         IN NUMBER,
                                      PV_COD_PRINCIPAL     IN NAF47_TNET.INFO_DETALLE_FACTURA.CODIGO_PRINCIPAL%TYPE,
                                      PV_DESCRIPCION       IN NAF47_TNET.INFO_DETALLE_FACTURA.DESCRIPCION%TYPE,
                                      PN_CANTIDAD          IN NAF47_TNET.INFO_DETALLE_FACTURA.CANTIDAD%TYPE,
                                      PN_PRECIO_UNITARIO   IN NAF47_TNET.INFO_DETALLE_FACTURA.PRECIO_UNITARIO%TYPE,
                                      PN_DESCUENTO         IN NAF47_TNET.INFO_DETALLE_FACTURA.DESCUENTO%TYPE,
                                      PN_PRECIO_TOTAL_SIMP IN NAF47_TNET.INFO_DETALLE_FACTURA.TOTAL_SIMP%TYPE) IS
  
  BEGIN
    INSERT INTO NAF47_TNET.INFO_DETALLE_FACTURA
      (SECUENCIA_CARGA_ID,
       CODIGO_PRINCIPAL,
       DESCRIPCION,
       CANTIDAD,
       PRECIO_UNITARIO,
       DESCUENTO,
       TOTAL_SIMP)
    VALUES
      (PN_SECUENCIA,
       PV_COD_PRINCIPAL,
       PV_DESCRIPCION,
       PN_CANTIDAD,
       PN_PRECIO_UNITARIO,
       PN_DESCUENTO,
       PN_PRECIO_TOTAL_SIMP);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_INSERTA_INFOADICIONAL(PN_SECUENCIA   IN NUMBER,
                                    PV_DESCRIPCION IN NAF47_TNET.INFO_ADICIONAL.DESCRIPCION%TYPE) IS
  
  BEGIN
    INSERT INTO NAF47_TNET.INFO_ADICIONAL
      (SECUENCIA_CARGA_ID, DESCRIPCION)
    VALUES
      (PN_SECUENCIA, PV_DESCRIPCION);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_INSERTA_SUSTENTO(PN_SECUENCIA          IN NUMBER,
                               PN_COD_SUSTENTO       IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.SUSTENTO_ID%TYPE,
                               PN_COD_DOC_SUSTENTO   IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.DOC_SUSTENTO_ID%TYPE,
                               PV_NUM_DOC_SUSTENTO   IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.NUM_DOC_SUSTENTO%TYPE,
                               PD_FECHA_EMISION      IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.FE_EMISION_DOC_SUS%TYPE,
                               PD_FECHA_REG_CONTABLE IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.FE_REGISTRO_CONTABLE%TYPE,
                               PV_NUM_AUT            IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.NUM_AUT_DOC_SUS%TYPE,
                               PV_PAGO_LOC           IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.PAGO_LOC_EXT%TYPE,
                               PN_TOTAL_SIMP         IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.TOTAL_SIMP%TYPE,
                               PN_IMPORTE_TOTAL      IN NAF47_TNET.INFO_DOCS_SUSTENTOS_RET.IMPORTE_TOTAL%TYPE) IS
  
  BEGIN
    INSERT INTO NAF47_TNET.INFO_DOCS_SUSTENTOS_RET
      (SECUENCIA_CARGA_ID,
       SUSTENTO_ID,
       DOC_SUSTENTO_ID,
       NUM_DOC_SUSTENTO,
       FE_EMISION_DOC_SUS,
       FE_REGISTRO_CONTABLE,
       NUM_AUT_DOC_SUS,
       PAGO_LOC_EXT,
       TOTAL_SIMP,
       IMPORTE_TOTAL)
    VALUES
      (PN_SECUENCIA,
       PN_COD_SUSTENTO,
       PN_COD_DOC_SUSTENTO,
       PV_NUM_DOC_SUSTENTO,
       PD_FECHA_EMISION,
       PD_FECHA_REG_CONTABLE,
       PV_NUM_AUT,
       PV_PAGO_LOC,
       PN_TOTAL_SIMP,
       PN_IMPORTE_TOTAL);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_INSERTA_INFORETENCION(PN_SECUENCIA        IN NUMBER,
                                    PN_CODIGO           IN NAF47_TNET.INFO_RETENCIONES.ELEMENTO_ID%TYPE,
                                    PV_COD_RETENCION    IN NAF47_TNET.INFO_RETENCIONES.RETENCION_ID%TYPE,
                                    PN_BASE             IN NAF47_TNET.INFO_RETENCIONES.BASE_IMPONIBLE%TYPE,
                                    PN_PORCENTAJE       IN NAF47_TNET.INFO_RETENCIONES.PORCENTAJE_RETENCION%TYPE,
                                    PN_VALOR            IN NAF47_TNET.INFO_RETENCIONES.VALOR_RETENIDO%TYPE,
                                    PN_COD_SUSTENTO     IN NAF47_TNET.INFO_RETENCIONES.SUSTENTO_ID%TYPE,
                                    PN_COD_DOC_SUSTENTO IN NAF47_TNET.INFO_RETENCIONES.DOC_SUSTENTO_ID%TYPE) IS
  
  BEGIN
    INSERT INTO NAF47_TNET.INFO_RETENCIONES
      (SECUENCIA_CARGA_ID,
       ELEMENTO_ID,
       RETENCION_ID,
       BASE_IMPONIBLE,
       PORCENTAJE_RETENCION,
       VALOR_RETENIDO,
       SUSTENTO_ID,
       DOC_SUSTENTO_ID)
    VALUES
      (PN_SECUENCIA,
       PN_CODIGO,
       PV_COD_RETENCION,
       PN_BASE,
       PN_PORCENTAJE,
       PN_VALOR,
       PN_COD_SUSTENTO,
       PN_COD_DOC_SUSTENTO);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE P_ELIMINA_DATA(PV_NOCIA   IN VARCHAR2,
                           pn_anio    IN number,
                           pn_mes     IN number,
                           PV_USUARIO IN VARCHAR2) IS
  
  BEGIN
    delete from naf47_tnet.INFO_ARCHIVOS_CARGADOS A
     where estado = 'I'
       and no_cia = PV_NOCIA
       and usr_CREACION = PV_USUARIO
       AND A.PERIODO_ANIO = PN_ANIO
       AND A.PERIODO_MES = PN_MES;
  
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
end SRIK_CARGA_MASIVA_XML;
/
