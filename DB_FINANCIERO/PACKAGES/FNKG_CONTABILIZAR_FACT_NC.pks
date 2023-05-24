CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC
AS

  /*
  * Documentaci�n para TYPE 'TypePlantillaCab'.
  * Record que me permite almancernar la cabecera de la plantilla
  */
  TYPE TypePlantillaCab IS RECORD (
        ID_PLANTILLA_CONTABLE_CAB     ADMI_PLANTILLA_CONTABLE_CAB.ID_PLANTILLA_CONTABLE_CAB%TYPE,
        DESCRIPCION                   ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE,
        TABLA_CABECERA                ADMI_PLANTILLA_CONTABLE_CAB.TABLA_CABECERA%TYPE,
        TABLA_DETALLE                 ADMI_PLANTILLA_CONTABLE_CAB.TABLA_DETALLE%TYPE,
        COD_DIARIO                    ADMI_PLANTILLA_CONTABLE_CAB.COD_DIARIO%TYPE,
        FORMATO_NO_DOCU_ASIENTO       ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_NO_DOCU_ASIENTO%TYPE,
        FORMATO_GLOSA                 ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_GLOSA%TYPE
  );

  /*
  * Documentaci�n para TYPE 'lst_map_idMigracionType'.
  * Record que me permite almancernar mapeo de IdMigracion para Compa�ia 33 y 18
  */
  type lst_map_idMigracionType is table of number index by pls_integer;

  /*
  * Documentaci�n para TYPE 'TypeoOficinas'.
  * Record que me permite almancernar las oficinas de la empresa
  */
  TYPE TypeoOficinas IS RECORD (
        ID_OFICINA                    DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        NOMBRE_OFICINA                DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeProductosFacturados'.
  * Record que me permite almancernar por producto los valores torales facturados
  */
  TYPE TypeDetalleProductos IS RECORD (
        ID_DOCUMENTO                  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        PUNTO_ID                      INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
        OFICINA_ID                    INFO_DOCUMENTO_FINANCIERO_CAB.OFICINA_ID%TYPE,
        FE_AUTORIZACION               INFO_DOCUMENTO_FINANCIERO_CAB.FE_AUTORIZACION%TYPE,
        ESTADO                        INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
        CANTIDAD                      INFO_DOCUMENTO_FINANCIERO_DET.CANTIDAD%TYPE,
        PRECIO_VENTA_FACPRO_DETALLE   INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE,
        DESCUENTO_FACPRO_DETALLE      INFO_DOCUMENTO_FINANCIERO_DET.DESCUENTO_FACPRO_DETALLE%TYPE,
        PRODUCTO_ID                   INFO_DOCUMENTO_DETALLE_PRODUCT.PRODUCTO_ID%TYPE,
        IMPUESTO_ID                   INFO_DOCUMENTO_DETALLE_PRODUCT.IMPUESTO_ID%TYPE,
        VALOR                         INFO_DOCUMENTO_DETALLE_PRODUCT.VALOR%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeProductosFacturados'.
  * Record que me permite almancernar por producto los valores torales facturados
  */
  TYPE TypeProductosFacturados IS RECORD (
        PRODUCTO_ID    DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
        TOTAL          INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
        DESCUENTO      INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
        IMPUESTO_ID    INFO_DOCUMENTO_FINANCIERO_IMP.IMPUESTO_ID%TYPE,
        IVA            INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
        ICE            INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
        ESTADO         INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeProductosFacturadosTab'.
  * Table para manejo de los arreglos
  */
  TYPE TypeProductosFacturadosTab IS TABLE OF TypeProductosFacturados INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'TypeOficinasFacturados'.
  * Record que me permite almancernar por oficina los valores torales facturados
  */
  TYPE TypeOficinasFacturados IS RECORD (
        OFICINA_ID      DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        NOMBRE_OFICINA  DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        REDONDEO        VARCHAR2(1),
        PRODUCTOS       TypeProductosFacturadosTab
  );

  /*
  * Documentaci�n para TYPE 'TypeOficinasFacturadosTab'.
  * Table para manejo de los arreglos
  */
  TYPE TypeOficinasFacturadosTab IS TABLE OF TypeOficinasFacturados INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'TypeInfoDocumento'.
  * Record que me permite almancernar informacion consultada del documento individual
  */
  TYPE TypeInfoDocumento IS RECORD (
        FE_AUTORIZACION       VARCHAR2(100),
        FE_EMISION            VARCHAR2(100),
        NUMERO_FACTURA_SRI    INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
        LOGIN                 DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
        NOMBRE_OFICINA        DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        USR_CREACION          INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
        ESTADO                INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
        COD_EMPRESA           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        PREFIJO               DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
        ES_AUTOMATICA         INFO_DOCUMENTO_FINANCIERO_CAB.ES_AUTOMATICA%TYPE,
        CODIGO_TIPO_DOCUMENTO ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeArreglo'.
  * Tipo que me permite almacenar datos del split
  */
  TYPE TypeArreglo IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

  /*
  * Documentaci�n para TYPE 'TypePlantillaDet'.
  * Record que me permite almancernar informacion de la plantilla detalle
  */
  TYPE TypePlantillaDet IS RECORD (
        TIPO_CUENTA_CONTABLE    ADMI_TIPO_CUENTA_CONTABLE.DESCRIPCION%TYPE,
        DESCRIPCION             ADMI_PLANTILLA_CONTABLE_DET.DESCRIPCION%TYPE,
        POSICION                ADMI_PLANTILLA_CONTABLE_DET.POSICION%TYPE,
        TIPO_DETALLE            ADMI_PLANTILLA_CONTABLE_DET.TIPO_DETALLE%TYPE,
        FORMATO_GLOSA           ADMI_PLANTILLA_CONTABLE_DET.FORMATO_GLOSA%TYPE,
        PORCENTAJE              ADMI_PLANTILLA_CONTABLE_DET.PORCENTAJE%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeTotalizado'.
  * Record que me permite almancernar el totalizado por oficina consultada
  */
  TYPE TypeTotalizado IS RECORD (
        TOTAL          INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
        DESCUENTO      INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
        IMPUESTO_ID    INFO_DOCUMENTO_FINANCIERO_IMP.IMPUESTO_ID%TYPE,
        IVA            INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
        ICE            INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeIdDocumento'.
  * Record que me permite almancenar el id_documento de los documentos procesados
  */
  TYPE TypeIdDocumento IS RECORD (
        ID_DOCUMENTO   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        PUNTO_ID       DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
        ESTADO         INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeIdDocumentoTab'.
  * Record que me permite almancenar el id_documento | id_punto de los documentos procesados
  */
  TYPE TypeIdDocumentoTab IS TABLE OF TypeIdDocumento INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'TypeDocumentosFacturados'.
  * Record que me permite almancernar por oficina los documentos facturados
  */
  TYPE TypeDocumentosFacturados IS RECORD (
        OFICINA_ID      DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        DOCUMENTOS      TypeIdDocumentoTab
  );

  /*
  * Documentaci�n para TYPE 'TypeDocumentosFacturadosTab'.
  * Table para manejo de los arreglos
  */
  TYPE TypeDocumentosFacturadosTab IS TABLE OF TypeDocumentosFacturados INDEX BY PLS_INTEGER;
  --
  /*
  * Documentaci�n para TYPE 'TypeTotalOficinaImpuesto'.
  * Table para manejo de los arreglos
  */
  TYPE TypeTotalOficinaImpuesto IS TABLE OF TypeTotalizado INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'lstMigraArcgaeType'.
  * Table para manejo de los arreglos
  */
  type lstMigraArcgaeType is table of NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;

  type lstDocumentosAsociadosType is table of NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;

  type R_DocumentosSecuencia IS RECORD(
   documento DB_FINANCIERO.INFO_TMP_SECUENCIA_DOCS.ID_DOCUMENTO%type,
   secuencia DB_FINANCIERO.INFO_TMP_SECUENCIA_DOCS.SECUENCIA%type,
   estado DB_FINANCIERO.INFO_TMP_PRODUCTOS.ESTADO_IMPRESION_FACT%type
  );

  type lstSecuenciaDocumentosType is table of R_DocumentosSecuencia;

  /*
  * Documentaci�n para TYPE 'lstMigraArcgalType'.
  * Table para manejo de los arreglos
  */
  type lstMigraArcgalType is table of NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;
  --

  --Permite obtener la cabecera de la plantilla por documento
  PROCEDURE P_OBTENER_PLANTILLA_CAB(
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_PlantillaDescripcion IN  ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE,
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cr_PlantillaCab         OUT SYS_REFCURSOR);

  --Permite obtener el detalle de la plantilla por documento
  PROCEDURE P_OBTENER_PLANTILLA_DET(
    Pn_IdPlantillaCab IN ADMI_PLANTILLA_CONTABLE_CAB.ID_PLANTILLA_CONTABLE_CAB%TYPE,
    Cr_PlantillaDet   OUT SYS_REFCURSOR
    );

  --Permite obtener el id_impuesto creado por empresa
  FUNCTION F_OBTENER_IMPUESTO(
    Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  RETURN NUMBER;

  /**
    * Documentacion para el procedimiento F_OBTENER_COM_SOLIDARIA
    * Permite obtener la sumatoria de la compensacion solidaria registrada
    * Ft_Fe_Actual            IN VARCHAR2                                                   Fecha del proceso,
    * Fn_IdOficina            IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE            Oficina procesada,
    * Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE           Empresa procesada,
    * Fv_TipoProceso          IN  VARCHAR2                                                  Proceso masivo, anulacion o individual,
    * Fv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Tipo de documento a procesar
    * Retorna:
    * Sumatoria de la compensacion solidaria registrada
    * Costo 2k
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.0 11-11-2016
    *
    * Se modifica el cursor que retorna la informacion segun el codigo tipo de documento y segun el tipo de proceso, que se comporte de manera
    * dinamica
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 04-01-2017
    *
  */
  FUNCTION F_OBTENER_COM_SOLIDARIA(
    Ft_Fe_Actual            IN VARCHAR2,
    Fn_IdOficina            IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_TipoProceso          IN  VARCHAR2,
    Fv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN NUMBER;

  /**
    * Documentacion para el procedimiento UPDATE_COMP_SOLIDARIA
    * Permite actualizar los valores correspondiente a la cuenta de clientes de los asientos contables que poseen compensacion
    * Pv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Empresa a procesar,
    * Pv_Anio       IN  VARCHAR2                                          A�o de asiento contable,
    * Pv_Mes        IN  VARCHAR2                                          Mes de asiento contable,
    * Pv_NoAsiento  IN  VARCHAR2                                          Numero de asiento contable a procesar,
    * Pn_Monto      IN  INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE    Valor actualizar
    *
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.0 21-12-2016
  */
  PROCEDURE UPDATE_COMP_SOLIDARIA(
    Pv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Anio       IN  VARCHAR2,
    Pv_Mes        IN  VARCHAR2,
    Pv_NoAsiento  IN  VARCHAR2,
    Pn_Monto      IN  INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
  );

  /**
    * Documentacion para el procedimiento P_LISTADO_PRODUCTOS_FACT
    * Permite obtener el listado de los productos facturados
    * Pv_CodEmpresa              DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,          Empresa a procesar
    * Pv_FechaProceso            VARCHAR2                                                   Fecha del proceso
    * Pv_ParametroAdicional      VARCHAR2                                                   Cadena del query adicional
    * Cr_ProductosFacturados     SYS_REFCURSOR                                              Listado de productos facturados
    * Retorna:
    * Listado de productos facturados
    * Costo 7k
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 11-11-2016
  */
  PROCEDURE P_LISTADO_PRODUCTOS_FACT(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaProceso         IN  VARCHAR2,
    Pv_ParametroAdicional   IN  VARCHAR2,
    Cr_ProductosFacturados  OUT SYS_REFCURSOR
    );

  /**
    * Documentacion para el procedimiento P_LISTADO_PRODUCTOS_FACT_IND
    * Permite obtener el listado de los productos facturados de manera individual(facturacion diaria), solo soporta facturas unicamente
    * Pv_CodEmpresa              DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,          Empresa a procesar
    * Pv_ParametroAdicional      VARCHAR2                                                   Cadena del query adicional
    * Cr_ProductosFacturados     SYS_REFCURSOR                                              Listado de productos facturados
    * Retorna:
    * Listado de productos facturados
    * Costo 22
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 11-11-2016
  */
  PROCEDURE P_LISTADO_PRODUCTOS_FACT_IND(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Cr_ProductosFacturados  OUT SYS_REFCURSOR
  );

  /**
    * Documentacion para el procedimiento P_LISTADO_PRODUCTOS_FACT_ANU
    * Permite obtener el listado de los productos facturados anulados
    * Pv_CodEmpresa              DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,          Empresa a procesar
    * Pv_FechaProceso            VARCHAR2                                                   Fecha del proceso
    * Pv_ParametroAdicional      VARCHAR2                                                   Cadena del query adicional
    * Cr_ProductosFacturados     SYS_REFCURSOR                                              Listado de productos facturados
    * Retorna:
    * Listado de productos facturados anulados
    * Costo 195
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 11-11-2016
    *
    * Se modifica la consulta de anulaciones por fecha de creacion del historial ya que esa es la fecha real de anulacion, verificando el estado del historial en anulado
    * y que posea motivo de anulacion ya que esto nos indica que el Telcos creo ese historial
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.2 04-01-2017
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.3 14-08-2018 - Se corrige query din�mico que hace referencia a las estructuras configuraci�n contable que fueron quitadas.
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.4 20-08-2018 - Se corrige query din�mico que recupera datos de facturas anuladas, se cambio a constante el ID_PRODUCTO
    *                           sin considerarlo como variable en el string que guarda el query dinamico
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.5 07-11-2018 - Se corrige query din�mico para anulacion de documentos, sentencia order by sin separar genera error de sintaxis
*/
  PROCEDURE P_LISTADO_PRODUCTOS_FACT_ANU(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaProceso         IN  VARCHAR2,
    Pv_ParametroAdicional   IN  VARCHAR2,
    Cr_ProductosFacturados  OUT SYS_REFCURSOR
  );

  /**
    * Documentacion para el Procedure P_OFICINAS_POR_EMPRESA
    * procedure que recupera las oficinas con facturas pendientes de contabilizar
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 11-11-2016
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.2 21-06-2018 - Se modifica usar query din�mico que permita filtrar informaci�n por fecha DATE o TIMESTAMP
    *
    * Pv_CodEmpresa  IN      VARCHAR2,      C�digo de empresa
    * Cr_Oficinas    IN OUT  SYS_REFCURSOR  Retorna curso con datos de las oficinas
  */
  PROCEDURE P_OFICINAS_POR_EMPRESA(
    Pv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cr_Oficinas   OUT SYS_REFCURSOR
  );

  /**
    * Documentacion para el funcion F_VERIFICAR_FACTURADO
    * Permite verificar los valores facturados
    * Ft_Fe_Actual                VARCHAR2,                                                               Fecha del proceso
    * Fn_IdOficina                DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE                         Oficina a verificar informacion
    * Fv_CodEmpresa               VARCHAR2                                                                Empresa del proceso
    * Fv_CodigoTipoDocumento      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Tipo de documentos a procesar
    * Retorna:
    * Acumulado de productos por oficina
    * Costo 1,2k
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 11-11-2016
  */
  FUNCTION F_VERIFICAR_FACTURADO(
    Ft_Fe_Actual  IN VARCHAR2,
    Fn_IdOficina  IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE
  )RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

  /**
    * Documentacion para el funcion F_VERIFICAR_REDONDEO
    * Permite verificar si los totales detallados coinciden con los totales de las oficinas, sino se redondea
    * Ft_Fe_Actual                VARCHAR2,                                                               Fecha del proceso
    * Fn_IdOficina                DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE                         Oficina a verificar informacion
    * Fv_CodEmpresa               VARCHAR2                                                                Empresa del proceso
    * Fv_CodigoTipoDocumento      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Tipo de documentos a procesar
    * Retorna:
    * Acumulado de productos por oficina
    * Costo 2,2k
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 11-11-2016
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.2 05-03-2018 - Se modifica para eliminar c�digo en comentario.
  */
  FUNCTION F_VERIFICAR_REDONDEO(
    Ft_Fe_Actual  IN VARCHAR2,
    Fn_IdOficina  IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE
    )
  RETURN VARCHAR;

  /**
    * Documentacion para el procedimiento P_LISTADO_POR_OFICINA
    * Permite obtener el listado por oficina y por productos acumulados de lo facturado
    * Pv_CodEmpresa              DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,                       Empresa a procesar
    * Cr_ProductosFacturados     SYS_REFCURSOR                                                           Productos facturados
    * Pt_Fe_Actual               VARCHAR2                                                                Fecha del proceso
    * Pv_CodigoTipoDocumento     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Tipo de documentos a procesar
    * Cr_OficinasFacturado       TypeOficinasFacturadosTab                                               Producstos facturados por oficina
    * Pr_Documentos              TypeDocumentosFacturadosTab                                             Facturas a marcar como contabilizadas
    * Retorna:
    * Acumulado de productos por oficina
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 11-11-2016
  */
  PROCEDURE P_LISTADO_POR_OFICINA(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cr_ProductosFacturados  IN  SYS_REFCURSOR,
    Pt_Fe_Actual            IN  VARCHAR2,
    Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Cr_OficinasFacturado    OUT TypeOficinasFacturadosTab,
    Pr_Documentos           OUT TypeDocumentosFacturadosTab
  );

  --Permite obtener la informacion relacionada al documentos individual a procesar
  PROCEDURE O_OBTENER_DATA_DOCUMENTO(
    Pv_IdDocumento    IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Cr_InfoDocumento  OUT SYS_REFCURSOR
  );

  --Permite generar la descripcion para el asiento contable
  --Se agrega nueva longitud para el substring de la descripcion
  PROCEDURE P_GENERAR_DESCRIPCION(
    Pv_FormatoGlosa         IN  ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_GLOSA%TYPE,
    Pv_Fe_Actual            IN  VARCHAR2,
    Pv_Oficina              IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
    Pv_Login                IN  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    Pv_NumeroFacturaSri     IN  INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    Pv_Descripcion          OUT  VARCHAR2
  );

  --Permite generar el nombre de plantilla a consultar
  FUNCTION F_GENERAR_NOMBRE_PLANTILLA(
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pn_FlatIva              IN  VARCHAR2
  )RETURN VARCHAR2;

  --Permite dividir la cadena enviada
  PROCEDURE P_SPLIT(
    Pv_Cadena   IN VARCHAR2,
    Pv_Caracter IN VARCHAR2,
    Pr_Arreglo  OUT TypeArreglo
  );

  --Permite generar el numero de asiento para el asiento contable
  PROCEDURE P_GENERAR_NO_ASIENTO(
    Pv_FormatoNoAsiento     IN  ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_NO_DOCU_ASIENTO%TYPE,
    Pv_Fe_Actual            IN  VARCHAR2,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pn_IdOficina            IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Pv_NoAsiento            OUT  VARCHAR2
  );

  /**
    * Documentacion para el procedimiento P_TOTALIZANDO_POR_OFICINA
    * Permite totalizar por oficina basandose en el arreglo de productos facturados
    * Pr_OficinasFacturado              TypeOficinasFacturadosTab,                       Tabla de oficinas facturadas
    * Pn_OficinaIdx                     DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE  Oficina a verificar
    * Pn_ValorTotal                     TypeTotalOficinaImpuesto                         Total por oficina e Impuesto
    * Retorna:
    * Totalizado por oficina consultada
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.1 11-11-2016
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.2 05-03-2018 -  Se modifica para quitar registro log por total oficina
  */
  PROCEDURE P_TOTALIZANDO_POR_OFICINA(
    Pr_OficinasFacturado  IN  TypeOficinasFacturadosTab,
    Pn_OficinaIdx         IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Pn_ValorTotal         OUT TypeTotalOficinaImpuesto
  );

  --Permite obtener la cuenta contable por tipo de cuenta y por oficina
  --Permite obtener la no_cta para el caso de la informacion de bancos
  PROCEDURE P_OBTENER_CUENTA_CONTABLE(
    Pv_CodEmpresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_TipoCuentaContable     IN  ADMI_TIPO_CUENTA_CONTABLE.DESCRIPCION%TYPE,
    Pv_CampoReferencial       IN  ADMI_CUENTA_CONTABLE.CAMPO_REFERENCIAL%TYPE,
    Pv_ValorCampoReferencial  IN  ADMI_CUENTA_CONTABLE.VALOR_CAMPO_REFERENCIAL%TYPE,
    Pv_Oficina                IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
    Cr_CtaContable            OUT VARCHAR2,
    Cr_NoCta                  OUT VARCHAR2
  );

  --Permite segun el tipo de posicion D | C el valor correspondiente al monto
  PROCEDURE P_POSICION_VALOR(
    Pv_Posicion IN ADMI_PLANTILLA_CONTABLE_DET.POSICION%TYPE,
    Pn_Monto    IN OUT INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
  );

  --Permite marcar la informacion contabilizada, se agrega el proceso que esta contabilizando
  PROCEDURE P_MARCAR_CONTABILIZADO(
    Pv_IdDocumento  IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_TipoProceso  IN  VARCHAR2
  );

  /**
   * Documentacion para el procedimiento P_PROCESAR
   * Permite procesar la informaci�n a contabilizar
   * Cr_ProductosFacturados  IN  SYS_REFCURSOR                                               Listado de productos facturados,
   * Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE            Codigo de empresa a procesar,
   * Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE                PRefijo de empresaa procesar
   * Pv_TipoProceso          IN  VARCHAR2                                                    Tipo de proceso a realizar,
   * Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE   Codigo de Tipo de documento a procesar,
   * Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE             Documento a procesar (proceso individual),
   * Pt_Fe_Actual            IN  VARCHAR2                                                    Fecha de ejecucion del proceso,
   * Pv_DescripcionImpuesto  IN  VARCHAR2                                                    Parametro de compensacion solidaria
   *
   * @author Gina Villalba <gvillalba@telconet.ec>
   * @since 1.0
   *
   * Se agrega el parametro indicativo de la compensacion solidaria para proceder al calculo de la misma
   * @author Gina Villalba <gvillalba@telconet.ec>
   * @since 1.1 21-12-2016
   *
   * @author Edson Franco <efranco@telconet.ec>
   * @version 1.2 17-03-2017 - Se quita la funci�n SUBSTR de las columnas 'Lr_MigraArcgae.NO_ASIENTO' para que el n�mero de asiento generado coincida
   *                           con el formato ingresado en la 'DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB', y se pueda realizar la comparaci�n de lo
   *                           guardado en TELCOS+ con lo migrado al NAF por la columna 'FORMATO_NO_DOCU_ASIENTO'.
   * @author Edson Franco <efranco@telconet.ec>
   * @version 1.3 11-07-2017 - Se redondea la variable 'Pn_ValorTotal.IVA' para poder inicializar la variable 'Pn_FlatIva' con el valor respectivo
   *
   * @author rcoello <rcoello@telconet.ec>
   * @version 1.3 15-08-2017 - Se modifica para usar los procedimientos insert de repositorio migraci�n de NAF
   * tambi�n se modifica para mejorar el control de errores
   *
   * @author llindao <llindao@telconet.ec>
   * @version 1.4 04-03-2018 - Se modifica corregir asignaci�n de valor campo referencial cuando se contabiliza la linea PORTADOR.
   *
   * @author llindao <llindao@telconet.ec>
   * @version 1.5 21-06-2018 - Se modifica validar cuadre de asiento y ajustar autom�ticamente en base a plantilla de ajuste por redondeo
   * 
   * @author eareyesv <eareyesv@telconet.ec>
   * @version 1.6 08-05-2023 - SE corrige bug en el cursor cObtenerSecuenciasDocs, para evitar que obtenga secuenciales registrados en la tabla INFO_DOCUMENTO_HISTORIAL, se agrega condicional para evitarla ejecuci�n del procedimiento almacenado 'FNCK_FACTURACION_DETALLES.P_FACTURACION_DETALLE' cuando el mes a procesar sea diferente al mes actual.
   *
   */
  PROCEDURE P_PROCESAR(
      Cr_ProductosFacturados  IN SYS_REFCURSOR,
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoProceso          IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pt_Fe_Actual            IN  VARCHAR2,
      Pv_DescripcionImpuesto  IN  VARCHAR2
  );

  /**
   * Documentacion para el procedimiento P_PROCESAR
   * Permite contabilizar los documentos ya sea de manera masiva o de manera individual
   * Se agrega proceso "ANULACION-FAC-FE" para poder procesar anulaciones de fechas especificas
   * Utilizado unicamente para la anulacion por fecha "ANULACION-FAC-FE", Pv_Fe_Procesar
   * Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE            Empresa a procesar,
   * Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE                Prefijo de empresa a procesar,
   * Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE   Codigo de documentos a procesar,
   * Pv_TipoProceso          IN  OUT VARCHAR2                                                Tipo de proceso a ejecutar individual, masivo,
   *                                                                                         anulacion,
   * Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE             Id_Documento a procesar unicamente para el individual,
   * Pv_Fe_Procesar          IN  VARCHAR2                                                    Fecha del proceso
   * Pv_MsnError             OUT VARCHAR2                                                    Texto con el mensaje de error en caso de existir
   *
   * @author Gina Villalba <gvillalba@telconet.ec>
   * @since 1.0
   *
   * Se agrega el parametro indicativo de la compensacion solidaria para proceder a la contabilizacion en su respectiva cuenta
   * y con su respectivo valor
   * @author Gina Villalba <gvillalba@telconet.ec>
   * @since 1.1 21-12-2016
   *
   * Se agrega los procesos de generar los detalles para la ejecucion automatica del proceso
   * @author Gina Villalba <gvillalba@telconet.ec>
   * @since 1.2 04-01-2017
   *
   * @author Edson Franco <efranco@telconet.ec>
   * @since 1.4 23-02-2017 - Se agrega variable 'Pv_MsnError' para retornar mensaje de error en caso de existir
   *
   * @author Luis Lindao <llindao@telconet.ec>
   * @version 1.5 12-11-2018 - Se corrige parametro que genera query din�mico para considerar filtro PRODUCTO_NC pues se duplica detalle contable
   *
   * @author Luis Lindao <llindao@telconet.ec>
   * @version 1.6 14-11-2018 - La correcci�n anterior se aplic� a contabilizaci�n masiva de facturas, se agrega correcci�n en anulaci�n nota cr�dito
   */
  PROCEDURE P_CONTABILIZAR(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  OUT VARCHAR2,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_Fe_Procesar          IN  VARCHAR2,
    Pv_MsnError             OUT VARCHAR2
  );

/**
   * Documentacion para el procedimiento P_REG_MOTIV_FACT_ANULADA
   * Permite registrar  un motivo para los documentos(FAC,FACP.NC) que fueron anulados y que no poseen un motivo
   * registrado en la tabla INFO_DOCUMENTO_HISTORIAL,para que se pueda realizar el proceso de contabilizaci�n.
   *
   * Pv_PrefijoEmpresa      IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE                Prefijo de empresaa procesar
   * Pv_CodigoTipoDocFac    IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE   Codigo de Tipo de documento a procesar,
   * Pv_CodigoTipoDocFacp   IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE   Codigo de Tipo de documento a procesar,
   * Pv_CodigoTipoDocNc     IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE   Codigo de Tipo de documento a procesar,
   * Pv_MsnError            OUT VARCHAR2                                                    Texto con el mensaje de error en caso de existir
   *
   * @author Ricardo Robles <rrobles@telconet.ec>
   * @since 1.0 20-05-2019
   *
   */
   PROCEDURE P_REG_MOTIV_FACT_ANULADA(
    Pv_PrefijoEmpresa       IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocFac     IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_CodigoTipoDocFacp    IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_CodigoTipoDocNc      IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_MsnError             OUT VARCHAR2
  );

  /*
  * @Author Jimmy Gilces <jgilces@telconet.ec>
  * @Objetivo Replicar las migraciones de Ecuanet a Megadatos
  * Parametros de Entrada:
  *            Pv_Cia_Origen   IN naf47_tnet.migra_arcgae.no_cia%type      Compa�ia Origen
  *            Pv_Cia_Destino  IN naf47_tnet.migra_arcgae.no_cia%type      Compa�ia Destino
  *            Pv_CodDIario    IN naf47_tnet.migra_arcgae.cod_diario%type  Documento Procesado
  */
  PROCEDURE P_REPLICA_INFORMACION(Pv_Cia_Origen  IN naf47_tnet.migra_arcgae.no_cia%type,
                                  Pv_Cia_Destino IN naf47_tnet.migra_arcgae.no_cia%type,
                                  Pv_CodDIario   naf47_tnet.migra_arcgae.cod_diario%type, 
                                  P_lst_mapIdMigracion lst_map_idMigracionType);


END FNKG_CONTABILIZAR_FACT_NC;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC AS
   --
   Gv_FechaProceso     VARCHAR2(11);
   Gn_TipoProceso      NUMBER(2) := 0;
   Gv_CodTipoDocumento DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE;
   Gv_Redondear        VARCHAR2(1) := 'S'; -- Se parametriza si se redondea o no... por defecto se redondea
   Gv_TipoFechaCtble   VARCHAR2(30) := FNKG_VAR.Gv_FechaAutoriza ; -- por defecto se contabiliza por fecha de Autorizacion
   Gv_IdTemporalDocumentos VARCHAR2(60);
   --
  /**
    * Documentacion para el procedimiento P_LISTADO_PRODUCTOS
    * Permite recuperar detalle de los documentos facturas y notas de creditos a procesar por oficina con consultas fijas
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.0 06-01-2018
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.1 05-03-2018 - Se modifica para cambiar DECODE por CASE pues la condicion contraria del DECODE no presenta el resultado requerido
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.2 26-04-2018 - Se corrige formato fecha para filtro del campo FECHA_AUTORIZACION pues es TIMESTAMP
    *
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.3 20-06-2018 - Se cambia metodo query dinamico para generar query por filtro DATE o TIMESTAMP
    *
    * @Param Pv_CodEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE                        C�digo de Empresa
    * @Param Pv_CodTipoDoc           DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Tipo de documento
    * @Param Pv_FechaProceso         VARCHAR2                                                                Fecha de Proceso
    * @Param Pn_TipoProceso          NUMBER                                                                  Tipo de proceso a consultar
    * @Return Cr_ProductosFacturados SYS_REFCURSOR                                                           Retorna los productos facturados
  */

 FUNCTION F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro IN VARCHAR2,
                                    Pv_Parametro       IN VARCHAR2)
   RETURN VARCHAR2 IS
   CURSOR C_OBTENER_PARAMETRO(Cv_NombreParametro VARCHAR2,
                              Cv_Parametro       VARCHAR2) IS
     select apd.valor2
       from db_general.admi_parametro_cab apc,
            db_general.admi_parametro_det apd
      where apc.id_parametro = apd.parametro_id
        and apc.estado = apd.estado
        and apc.estado = 'Activo'
        and apc.nombre_parametro = Cv_NombreParametro
        and apd.valor1 = Cv_Parametro;

   Lv_ValorParametro DB_GENERAL.Admi_Parametro_Det.VALOR2%type;
 BEGIN
   IF C_Obtener_Parametro%ISOPEN THEN
     CLOSE C_Obtener_Parametro;
   END IF;

   OPEN C_Obtener_Parametro(Pv_NombreParametro, Pv_Parametro);
   FETCH C_Obtener_Parametro
     INTO Lv_ValorParametro;
   CLOSE C_Obtener_Parametro;

   RETURN Lv_ValorParametro;
 END;

  PROCEDURE P_LISTADO_PRODUCTOS ( Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Pv_CodTipoDoc           IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                  Pv_FechaProceso         IN  VARCHAR2,
                                  Pn_TipoProceso          IN  NUMBER,
                                  Cr_ProductosFacturados  OUT SYS_REFCURSOR ) AS
    --
    Lv_CampoRefProducto CONSTANT VARCHAR2(100) := 'ID_PRODUCTO';
    Lv_CampoRefPortador CONSTANT VARCHAR2(100) := 'ID_PORTADOR';
    Lv_DescTipoCtaServ  CONSTANT VARCHAR2(20) := 'SERVICIO';
    --
    Lv_InfoError  VARCHAR2(2000);
    Lv_DescTipoCtaProd VARCHAR2(20) := NULL;
    --
    Lv_consulta        VARCHAR2(32000) := NULL;
    --
    Ld_FechaEmisionIni DATE;
    Ld_FechaEmisionFin DATE;
    Ld_FechaAutorizaIni TIMESTAMP;
    Ld_FechaAutorizaFin TIMESTAMP;
    --

  BEGIN
    --
    IF Pv_CodTipoDoc = 'FAC' THEN
      Lv_DescTipoCtaProd := 'PRODUCTOS';
    ELSE
      Lv_DescTipoCtaProd := 'PRODUCTOS_NC';
    END IF;
    --
    --tn:jgi:Se a ade un HINT para mejorar la consulta por costes
    Lv_consulta := 'SELECT /*+ CHOOSE USE_HASH(@"SEL$49B84A29" "IDFD"@"SEL$2")*/ IDFC.ID_DOCUMENTO,'||CHR(10);
    Lv_consulta := Lv_consulta||'IDFC.PUNTO_ID,'||CHR(10);
    Lv_consulta := Lv_consulta||'IDFC.OFICINA_ID,'||CHR(10);
    Lv_consulta := Lv_consulta||'IDFC.FE_AUTORIZACION,'||CHR(10);
    Lv_consulta := Lv_consulta||'IDFC.ESTADO_IMPRESION_FACT,'||CHR(10);
    Lv_consulta := Lv_consulta||'IDFD.CANTIDAD,'||CHR(10);
    Lv_consulta := Lv_consulta||'IDFD.PRECIO_VENTA_FACPRO_DETALLE,'||CHR(10);
    Lv_consulta := Lv_consulta||'IDFD.DESCUENTO_FACPRO_DETALLE,'||CHR(10);
    Lv_consulta := Lv_consulta||'IDDP.PRODUCTO_ID,'||CHR(10);
    Lv_consulta := Lv_consulta||'NVL(IDDP.IMPUESTO_ID,0) as IMPUESTO_ID,'||CHR(10);
    Lv_consulta := Lv_consulta||'NVL(IDDP.VALOR,0) as VALOR'||CHR(10);
    Lv_consulta := Lv_consulta||'FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,'||CHR(10);
    Lv_consulta := Lv_consulta||'DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,'||CHR(10);
    Lv_consulta := Lv_consulta||'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,'||CHR(10);
    Lv_consulta := Lv_consulta||'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD,'||CHR(10);
    Lv_consulta := Lv_consulta||'DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT IDDP'||CHR(10);
    Lv_consulta := Lv_consulta||'WHERE IOG.EMPRESA_ID = :1'||CHR(10); -- Pv_CodEmpresa
    --
    IF Gv_TipoFechaCtble = FNKG_VAR.Gv_FechaEmision THEN
      Lv_Consulta := Lv_Consulta||'AND IDFC.FE_EMISION >= :2 '||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND IDFC.FE_EMISION <= :3 '||CHR(10);
    ELSIF Gv_TipoFechaCtble = FNKG_VAR.Gv_FechaAutoriza THEN
      Lv_Consulta := Lv_Consulta||'AND IDFC.FE_AUTORIZACION >= :2 '||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND IDFC.FE_AUTORIZACION <= :3 '||CHR(10);
    END IF;
    --
    --
    Lv_consulta := Lv_consulta||'AND EXISTS (SELECT NULL'||CHR(10);
    Lv_consulta := Lv_consulta||'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,'||CHR(10);
    Lv_consulta := Lv_consulta||'DB_GENERAL.ADMI_PARAMETRO_CAB APC'||CHR(10);
    Lv_consulta := Lv_consulta||'WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO'||CHR(10);
    Lv_consulta := Lv_consulta||'AND APC.NOMBRE_PARAMETRO = :4'||CHR(10); --FNKG_VAR.Gv_ValidaProcesoContable
    Lv_consulta := Lv_consulta||'AND APC.ESTADO = :5'||CHR(10); --FNKG_VAR.Gr_Estado.ACTIVO
    Lv_consulta := Lv_consulta||'AND APD.ESTADO = :5'||CHR(10); --FNKG_VAR.Gr_Estado.ACTIVO
    Lv_consulta := Lv_consulta||'AND APD.DESCRIPCION = :6'||CHR(10);--FNKG_VAR.Gv_ParTipoDocfacturacion
    Lv_consulta := Lv_consulta||'AND APD.VALOR1 = :7'||CHR(10); --Pv_CodTipoDoc
    Lv_consulta := Lv_consulta||'AND APD.VALOR2 = IDFC.TIPO_DOCUMENTO_ID)'||CHR(10);  -- Estados impresi�n facturas
    --
    Lv_consulta := Lv_consulta||'AND EXISTS (SELECT NULL'||CHR(10);
    Lv_consulta := Lv_consulta||'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,'||CHR(10);
    Lv_consulta := Lv_consulta||'DB_GENERAL.ADMI_PARAMETRO_CAB APC'||CHR(10);
    Lv_consulta := Lv_consulta||'WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO'||CHR(10);
    Lv_consulta := Lv_consulta||'AND APC.NOMBRE_PARAMETRO = :4'||CHR(10); --FNKG_VAR.Gv_ValidaProcesoContable
    Lv_consulta := Lv_consulta||'AND APC.ESTADO = :5'||CHR(10); --FNKG_VAR.Gr_Estado.ACTIVO
    Lv_consulta := Lv_consulta||'AND APD.ESTADO = :5'||CHR(10); --FNKG_VAR.Gr_Estado.ACTIVO
    Lv_consulta := Lv_consulta||'AND APD.DESCRIPCION = :8'||CHR(10);--FNKG_VAR.Gv_ParEstadoDocumento
    Lv_consulta := Lv_consulta||'AND APD.VALOR1 = IDFC.ESTADO_IMPRESION_FACT)'||CHR(10); -- Tipos Documentos
    --
    Lv_consulta := Lv_consulta||'AND IDFC.CONTABILIZADO IS NULL'||CHR(10);
    Lv_consulta := Lv_consulta||'AND IDFC.FE_AUTORIZACION IS NOT NULL'||CHR(10);
    --
    Lv_consulta := Lv_consulta||'AND EXISTS (SELECT NULL'||CHR(10);
    Lv_consulta := Lv_consulta||'FROM DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE ATCC,'||CHR(10);
    Lv_consulta := Lv_consulta||'DB_FINANCIERO.ADMI_CUENTA_CONTABLE ACC'||CHR(10);
    Lv_consulta := Lv_consulta||'WHERE ACC.VALOR_CAMPO_REFERENCIAL = IDDP.PRODUCTO_ID'||CHR(10);
    Lv_consulta := Lv_consulta||'AND ACC.CAMPO_REFERENCIAL = :9'||CHR(10); --Lv_CampoRefProducto
    Lv_consulta := Lv_consulta||'AND ACC.OFICINA_ID = IDFC.OFICINA_ID'||CHR(10);
    --
    Lv_consulta := Lv_consulta||'AND ATCC.DESCRIPCION = :10'||CHR(10); --Lv_DescTipoCtaProd
    Lv_consulta := Lv_consulta||'AND ACC.TIPO_CUENTA_CONTABLE_ID = ATCC.ID_TIPO_CUENTA_CONTABLE'||CHR(10);
    Lv_consulta := Lv_consulta||'UNION'||CHR(10);
    Lv_consulta := Lv_consulta||'SELECT NULL'||CHR(10);
    Lv_consulta := Lv_consulta||'FROM DB_FINANCIERO.ADMI_CUENTA_CONTABLE ACC'||CHR(10);
    Lv_consulta := Lv_consulta||'JOIN DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE = ACC.TIPO_CUENTA_CONTABLE_ID'||CHR(10);
    Lv_consulta := Lv_consulta||'WHERE ACC.VALOR_CAMPO_REFERENCIAL = IDDP.PRODUCTO_ID'||CHR(10);
    Lv_consulta := Lv_consulta||'AND ACC.CAMPO_REFERENCIAL = :11'||CHR(10);--Lv_CampoRefPortador
    Lv_consulta := Lv_consulta||'AND ACC.OFICINA_ID = IDFC.OFICINA_ID'||CHR(10);
    Lv_consulta := Lv_consulta||'AND ATCC.DESCRIPCION = :12 )'||CHR(10);--Lv_DescTipoCtaServ
    --
    --
    --
    Lv_consulta := Lv_consulta||'AND IDFC.ID_DOCUMENTO = IDFD.DOCUMENTO_ID'||CHR(10);
    Lv_consulta := Lv_consulta||'AND IDFC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO'||CHR(10);
    Lv_consulta := Lv_consulta||'AND IDFC.OFICINA_ID = IOG.ID_OFICINA'||CHR(10);
    Lv_consulta := Lv_consulta||'AND IDFC.ID_DOCUMENTO = IDDP.DOCUMENTO_ID'||CHR(10);
    Lv_consulta := Lv_consulta||'AND IDDP.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE'||CHR(10);

    --Lv_consulta := Lv_consulta||'ORDER BY IDFC.OFICINA_ID'||CHR(10);
    --
    IF Gv_TipoFechaCtble = FNKG_VAR.Gv_FechaEmision THEN
      --
      Ld_FechaEmisionIni := TO_DATE(Gv_FechaProceso||FNKG_VAR.Gv_HoraIniDia,FNKG_VAR.Gv_FmtFechaDateR);
      Ld_FechaEmisionFin := TO_DATE(Gv_FechaProceso||FNKG_VAR.Gv_HoraFinDia,FNKG_VAR.Gv_FmtFechaDateR);
      --
      OPEN Cr_ProductosFacturados FOR Lv_consulta USING Pv_CodEmpresa,
                                                        Ld_FechaEmisionIni,
                                                        Ld_FechaEmisionFin,
                                                        FNKG_VAR.Gv_ValidaProcesoContable,
                                                        FNKG_VAR.Gr_Estado.ACTIVO,
                                                        FNKG_VAR.Gr_Estado.ACTIVO,
                                                        FNKG_VAR.Gv_ParTipoDocfacturacion,
                                                        Pv_CodTipoDoc,
                                                        FNKG_VAR.Gv_ValidaProcesoContable,
                                                        FNKG_VAR.Gr_Estado.ACTIVO,
                                                        FNKG_VAR.Gr_Estado.ACTIVO,
                                                        FNKG_VAR.Gv_ParEstadoDocumento,
                                                        Lv_CampoRefProducto,
                                                        Lv_DescTipoCtaProd,
                                                        Lv_CampoRefPortador,
                                                        Lv_DescTipoCtaServ;

    ELSIF Gv_TipoFechaCtble = FNKG_VAR.Gv_FechaAutoriza THEN
      --
      Ld_FechaAutorizaIni := TO_TIMESTAMP(Gv_FechaProceso||FNKG_VAR.Gv_HoraIniDia,FNKG_VAR.Gv_FmtFechaTimeR);
      Ld_FechaAutorizaFin := TO_TIMESTAMP(Gv_FechaProceso||FNKG_VAR.Gv_HoraFinDia,FNKG_VAR.Gv_FmtFechaTimeR);
      --
      OPEN Cr_ProductosFacturados FOR Lv_consulta USING Pv_CodEmpresa,
                                                        Ld_FechaAutorizaIni,
                                                        Ld_FechaAutorizaFin,
                                                        FNKG_VAR.Gv_ValidaProcesoContable,
                                                        FNKG_VAR.Gr_Estado.ACTIVO,
                                                        FNKG_VAR.Gr_Estado.ACTIVO,
                                                        FNKG_VAR.Gv_ParTipoDocfacturacion,
                                                        Pv_CodTipoDoc,
                                                        FNKG_VAR.Gv_ValidaProcesoContable,
                                                        FNKG_VAR.Gr_Estado.ACTIVO,
                                                        FNKG_VAR.Gr_Estado.ACTIVO,
                                                        FNKG_VAR.Gv_ParEstadoDocumento,
                                                        Lv_CampoRefProducto,
                                                        Lv_DescTipoCtaProd,
                                                        Lv_CampoRefPortador,
                                                        Lv_DescTipoCtaServ;


    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_LISTADO_PRODUCTOS', Lv_InfoError);
  END P_LISTADO_PRODUCTOS;

  PROCEDURE P_OBTENER_PLANTILLA_CAB(
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_PlantillaDescripcion IN  ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE,
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cr_PlantillaCab         OUT SYS_REFCURSOR)
  AS
    Lv_InfoError  VARCHAR2(2000);
  BEGIN
    OPEN Cr_PlantillaCab FOR
      SELECT
      APCC.ID_PLANTILLA_CONTABLE_CAB ,
      APCC.DESCRIPCION,
      APCC.TABLA_CABECERA,
      APCC.TABLA_DETALLE,
      APCC.COD_DIARIO,
      APCC.FORMATO_NO_DOCU_ASIENTO,
      APCC.FORMATO_GLOSA
      FROM ADMI_PLANTILLA_CONTABLE_CAB APCC
      JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=APCC.TIPO_DOCUMENTO_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=APCC.EMPRESA_COD
      WHERE
      ATDF.CODIGO_TIPO_DOCUMENTO=Pv_CodigoTipoDocumento
      AND APCC.DESCRIPCION=Pv_PlantillaDescripcion
      AND IEG.COD_EMPRESA=Pv_CodEmpresa;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_CAB', Lv_InfoError);
  END P_OBTENER_PLANTILLA_CAB;

  PROCEDURE P_OBTENER_PLANTILLA_DET(
    Pn_IdPlantillaCab IN ADMI_PLANTILLA_CONTABLE_CAB.ID_PLANTILLA_CONTABLE_CAB%TYPE,
    Cr_PlantillaDet   OUT SYS_REFCURSOR
    )
  AS
    Lv_InfoError  VARCHAR2(2000);
  BEGIN
    OPEN Cr_PlantillaDet FOR
      SELECT
      ATCC.DESCRIPCION AS TIPO_CUENTA_CONTABLE,
      APCD.DESCRIPCION,
      APCD.POSICION,
      APCD.TIPO_DETALLE,
      APCD.FORMATO_GLOSA,
      APCD.PORCENTAJE
      FROM ADMI_PLANTILLA_CONTABLE_DET APCD
      JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=APCD.TIPO_CUENTA_CONTABLE_ID
      WHERE
      APCD.PLANTILLA_CONTABLE_CAB_ID=Pn_IdPlantillaCab
      ORDER BY APCD.ID_PLANTILLA_CONTABLE_DET;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_DET', Lv_InfoError);
  END P_OBTENER_PLANTILLA_DET;

  FUNCTION F_OBTENER_IMPUESTO(
    Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_ObtenerImpuesto(Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) IS
      SELECT ID_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE UPPER(TIPO_IMPUESTO)=Cv_TipoImpuesto
      AND ESTADO                ='Activo';
    --
    Ln_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;

    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError                VARCHAR2(2000);
  BEGIN
    IF C_ObtenerImpuesto%ISOPEN THEN
      CLOSE C_ObtenerImpuesto;
    END IF;
    --
    OPEN C_ObtenerImpuesto(Fv_TipoImpuesto);
    --
    FETCH C_ObtenerImpuesto INTO Ln_PorcentajeImpuesto;
    --
    CLOSE C_ObtenerImpuesto;
    --
    IF Ln_PorcentajeImpuesto IS NULL THEN
      Ln_PorcentajeImpuesto  := 0;
    END IF;
    --
    RETURN Ln_PorcentajeImpuesto;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.F_OBTENER_IMPUESTO', Lv_InfoError);
  END F_OBTENER_IMPUESTO;

  FUNCTION F_OBTENER_COM_SOLIDARIA(
    Ft_Fe_Actual            IN VARCHAR2,
    Fn_IdOficina            IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_TipoProceso          IN  VARCHAR2,
    Fv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN NUMBER
  IS
    --Variable cursor dinamico
    Lv_CodigoTipoDocumento        VARCHAR2(500);
    Lv_EstadoImpresionFact        VARCHAR2(500);
    Lv_InformacionQuery           VARCHAR2(5000);

    --Cursor
    Lrf_ObtenerValorCompSolidaria SYS_REFCURSOR;

    --Variable cursor dinamico
    Lv_CompensacionSolidaria      VARCHAR2(32000);

    --Sumatoria de compensacion solidaria
    Ln_SumatoriaCompensacion      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError                  VARCHAR2(2000);
    --
  BEGIN
    --
    IF (Fv_CodigoTipoDocumento='FAC') THEN
      --
      Lv_CodigoTipoDocumento :=' AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('||q'['FAC']'||','||q'['FACP']'||')';
      --
    ELSE
      --
      Lv_CodigoTipoDocumento:=' AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('||q'['NC']'||')';
      --
    END IF;
    --
    IF (Fv_TipoProceso='MASIVO') THEN
      --
      Lv_EstadoImpresionFact := ' AND IDFC.ESTADO_IMPRESION_FACT IN ('||q'['Activo']'||','||q'['Cerrado']'||','||q'['Anulado']'||') ';
      --
      Lv_InformacionQuery    :=' IDFC.FE_AUTORIZACION >= TO_DATE('||q'[']'||Ft_Fe_Actual||q'[ 00:00:00','YYYY-MM-DD hh24:mi:ss']'||')
                                 AND IDFC.FE_AUTORIZACION <= TO_DATE('||q'[']'||Ft_Fe_Actual||q'[ 23:59:59','YYYY-MM-DD hh24:mi:ss']'||')' ;
      --
    ELSE
      --
      Lv_EstadoImpresionFact := ' AND IDFC.ESTADO_IMPRESION_FACT IN ('||q'['Anulado']'||')';
      --
      Lv_InformacionQuery    :=' IDFC.ID_DOCUMENTO IN (
                                    SELECT IDH.DOCUMENTO_ID FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
                                    WHERE
                                     IDH.FE_CREACION >= TO_DATE('||q'[']'||Ft_Fe_Actual||q'[ 00:00:00','YYYY-MM-DD hh24:mi:ss']'||')
                                     AND IDH.FE_CREACION <=  TO_DATE('||q'[']'||Ft_Fe_Actual||q'[ 23:59:59','YYYY-MM-DD hh24:mi:ss']'||')
                                     AND IDH.ESTADO='||q'['Anulado']'|| '
                                     AND IDH.USR_CREACION <> '||q'['telcos']'|| '
                                     AND MOTIVO_ID IS NOT NULL
                                     ) ';
    END IF;
    --
    Lv_CompensacionSolidaria := 'SELECT SUM(NVL(IDFC.DESCUENTO_COMPENSACION,0))
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      WHERE '
      || Lv_InformacionQuery
      || Lv_CodigoTipoDocumento
      || Lv_EstadoImpresionFact
      || ' AND IOG.EMPRESA_ID='|| Fv_CodEmpresa
      || ' AND IOG.ID_OFICINA='|| Fn_IdOficina;
    --
    OPEN Lrf_ObtenerValorCompSolidaria FOR Lv_CompensacionSolidaria;
    --
    FETCH Lrf_ObtenerValorCompSolidaria INTO Ln_SumatoriaCompensacion;
    --
    CLOSE Lrf_ObtenerValorCompSolidaria;
    --
    IF Ln_SumatoriaCompensacion IS NULL THEN
      Ln_SumatoriaCompensacion  := 0;
    END IF;
    --
    RETURN Ln_SumatoriaCompensacion;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.F_OBTENER_IMPUESTO', Lv_InfoError);
  END F_OBTENER_COM_SOLIDARIA;

  PROCEDURE UPDATE_COMP_SOLIDARIA(
    Pv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Anio       IN  VARCHAR2,
    Pv_Mes        IN  VARCHAR2,
    Pv_NoAsiento  IN  VARCHAR2,
    Pn_Monto      IN  INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
  )
  AS
    --Variable de error
    Lv_InfoError  VARCHAR2(2000);
  BEGIN
    --Actualizacion de la linea correspondiente a las cuentas de clientes
    UPDATE NAF47_TNET.MIGRA_ARCGAL ma
    SET ma.MONTO=Pn_Monto, ma.MONTO_DOL=Pn_Monto
    WHERE
    EXISTS ( SELECT '1'
    FROM DB_FINANCIERO.ADMI_CUENTA_CONTABLE acc, DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE atcc
    WHERE
    ma.CUENTA=acc.CUENTA
    AND acc.TIPO_CUENTA_CONTABLE_ID=atcc.ID_TIPO_CUENTA_CONTABLE
    AND atcc.DESCRIPCION='CLIENTES'
    )
    AND ma.NO_ASIENTO=Pv_NoAsiento
    AND ma.NO_CIA=Pv_CodEmpresa
    AND ma.MES=Pv_Mes
    AND ma.ANO=Pv_Anio;
    --
    COMMIT;
    --
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.UPDATE_COMP_SOLIDARIA', Lv_InfoError);
  END UPDATE_COMP_SOLIDARIA;

  PROCEDURE P_LISTADO_PRODUCTOS_FACT(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaProceso         IN  VARCHAR2,
    Pv_ParametroAdicional   IN  VARCHAR2,
    Cr_ProductosFacturados  OUT SYS_REFCURSOR
    )
  AS
    --Formato de fecha ejemplo 2016-01-18
    Lv_InfoError  VARCHAR2(2000);
    --
    Lv_Consulta  VARCHAR2(32000);

  BEGIN

    Lv_Consulta:='SELECT
      IDFC.ID_DOCUMENTO,
      IDFC.PUNTO_ID,
      IDFC.OFICINA_ID,
      IDFC.FE_AUTORIZACION,
      IDFC.ESTADO_IMPRESION_FACT,
      IDFD.CANTIDAD,
      IDFD.PRECIO_VENTA_FACPRO_DETALLE,
      IDFD.DESCUENTO_FACPRO_DETALLE,
      IDDP.PRODUCTO_ID,
      NVL(IDDP.IMPUESTO_ID,0) as IMPUESTO_ID,
      NVL(IDDP.VALOR,0) as VALOR
      FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
      JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
      LEFT JOIN INFO_DOCUMENTO_DETALLE_PRODUCT IDDP ON IDDP.DOCUMENTO_ID=IDFC.ID_DOCUMENTO AND IDDP.DETALLE_DOC_ID=IDFD.ID_DOC_DETALLE
      JOIN ADMI_CUENTA_CONTABLE ACC ON ACC.VALOR_CAMPO_REFERENCIAL=IDDP.PRODUCTO_ID
      JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=ACC.TIPO_CUENTA_CONTABLE_ID
      where
      IEG.COD_EMPRESA='||Pv_CodEmpresa||'
      AND TRUNC(IDFC.FE_AUTORIZACION) = TO_DATE('||q'[']'||Pv_FechaProceso||q'[','YYYY-MM-DD']'||')
      AND ACC.CAMPO_REFERENCIAL='||q'['ID_PRODUCTO']'||'
      AND ACC.OFICINA_ID=IDFC.OFICINA_ID
      AND IDFC.FE_AUTORIZACION IS NOT NULL
      AND '||Pv_ParametroAdicional||'
      ORDER BY IDFC.OFICINA_ID';
    --
    --
    OPEN Cr_ProductosFacturados FOR Lv_Consulta;
    --
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_LISTADO_PRODUCTOS_FACT', Lv_InfoError);
  END P_LISTADO_PRODUCTOS_FACT;

  PROCEDURE P_LISTADO_PRODUCTOS_FACT_ANU(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaProceso         IN  VARCHAR2,
    Pv_ParametroAdicional   IN  VARCHAR2,
    Cr_ProductosFacturados  OUT SYS_REFCURSOR
    )
  AS
    --Formato de fecha ejemplo 2016-01-18
    Lv_InfoError  VARCHAR2(2000);
    --
    Lv_Consulta  VARCHAR2(32000);
    Lv_TipoCuenta CONSTANT VARCHAR2(20) := 'ID_PRODUCTO';
    --

  BEGIN

    Lv_Consulta:='SELECT
      IDFC.ID_DOCUMENTO,
      IDFC.PUNTO_ID,
      IDFC.OFICINA_ID,
      IDFC.FE_AUTORIZACION,
      IDFC.ESTADO_IMPRESION_FACT,
      IDFD.CANTIDAD,
      IDFD.PRECIO_VENTA_FACPRO_DETALLE,
      IDFD.DESCUENTO_FACPRO_DETALLE,
      IDDP.PRODUCTO_ID,
      NVL(IDDP.IMPUESTO_ID,0) as IMPUESTO_ID,
      NVL(IDDP.VALOR,0) as VALOR
      FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
      JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
      LEFT JOIN INFO_DOCUMENTO_DETALLE_PRODUCT IDDP ON IDDP.DOCUMENTO_ID=IDFC.ID_DOCUMENTO AND IDDP.DETALLE_DOC_ID=IDFD.ID_DOC_DETALLE
      JOIN ADMI_CUENTA_CONTABLE ACC ON ACC.VALOR_CAMPO_REFERENCIAL=IDDP.PRODUCTO_ID
      JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=ACC.TIPO_CUENTA_CONTABLE_ID
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH ON IDH.DOCUMENTO_ID=IDFC.ID_DOCUMENTO AND IDH.ESTADO='||q'['Anulado']'||' AND IDH.MOTIVO_ID IS NOT NULL
      where
      IEG.COD_EMPRESA='||Pv_CodEmpresa||'
      AND TRUNC(IDH.FE_CREACION) = TO_DATE('||q'[']'||Pv_FechaProceso||q'[','YYYY-MM-DD']'||')
      AND IDFC.FE_AUTORIZACION IS NOT NULL
      AND ACC.CAMPO_REFERENCIAL = '||chr(39)||Lv_TipoCuenta||chr(39)||CHR(10);
      --
      Lv_Consulta := Lv_Consulta||'AND ACC.OFICINA_ID=IDFC.OFICINA_ID'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND '||Pv_ParametroAdicional||' ORDER BY IDFC.OFICINA_ID';
    --
    OPEN Cr_ProductosFacturados FOR Lv_Consulta;
    --
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_LISTADO_PRODUCTOS_FACT_ANU', Lv_InfoError);
  END P_LISTADO_PRODUCTOS_FACT_ANU;

  PROCEDURE P_LISTADO_PRODUCTOS_FACT_IND(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Cr_ProductosFacturados  OUT SYS_REFCURSOR
    )
  AS
    --Formato de fecha ejemplo 2016-01-18
    Lv_InfoError  VARCHAR2(2000);
  BEGIN
    --
    OPEN Cr_ProductosFacturados FOR
      SELECT
      IDFC.ID_DOCUMENTO,
      IDFC.PUNTO_ID,
      IDFC.OFICINA_ID,
      IDFC.FE_AUTORIZACION,
      IDFC.ESTADO_IMPRESION_FACT,
      IDFD.CANTIDAD,
      IDFD.PRECIO_VENTA_FACPRO_DETALLE,
      IDFD.DESCUENTO_FACPRO_DETALLE,
      IDDP.PRODUCTO_ID,
      NVL(IDDP.IMPUESTO_ID,0) as IMPUESTO_ID,
      NVL(IDDP.VALOR,0) as VALOR
      FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
      LEFT JOIN INFO_DOCUMENTO_DETALLE_PRODUCT IDDP ON IDDP.DOCUMENTO_ID=IDFC.ID_DOCUMENTO AND IDDP.DETALLE_DOC_ID=IDFD.ID_DOC_DETALLE
      JOIN ADMI_CUENTA_CONTABLE ACC ON ACC.VALOR_CAMPO_REFERENCIAL=IDDP.PRODUCTO_ID
      JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=ACC.TIPO_CUENTA_CONTABLE_ID
      where
      IEG.COD_EMPRESA=Pv_CodEmpresa
      AND IDFC.ID_DOCUMENTO=Pv_IdDocumento
      AND ACC.CAMPO_REFERENCIAL='ID_PRODUCTO'
      AND ATCC.DESCRIPCION='PRODUCTOS'
      AND ACC.OFICINA_ID=IDFC.OFICINA_ID
      AND IDFC.CONTABILIZADO IS NULL
      AND IDFC.FE_AUTORIZACION IS NOT NULL
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Cerrado','Anulado')
      ORDER BY IDFC.OFICINA_ID;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_LISTADO_PRODUCTOS_FACT_IND', Lv_InfoError);
  END P_LISTADO_PRODUCTOS_FACT_IND;

  PROCEDURE P_OFICINAS_POR_EMPRESA( Pv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Cr_Oficinas   OUT SYS_REFCURSOR ) AS
    Lv_InfoError          VARCHAR2(2000);
    Lv_DescripcionIva     VARCHAR2(20);
    --
    Lv_Consulta     VARCHAR2(32000);
    Lv_DescCampoRef CONSTANT VARCHAR2(20) := 'ID_OFICINA';
    Lv_DescTipoCta  CONSTANT VARCHAR2(20) := 'CLIENTES';
    --
    Ld_FechaEmisionIni DATE;
    Ld_FechaEmisionFin DATE;
    Ld_FechaAutorizaIni TIMESTAMP;
    Ld_FechaAutorizaFin TIMESTAMP;
    --
  BEGIN
    --
    Lv_Consulta := 'SELECT '||CHR(10);
    Lv_Consulta := Lv_Consulta||'IOG.ID_OFICINA,'||CHR(10);
    Lv_Consulta := Lv_Consulta||'IOG.NOMBRE_OFICINA'||CHR(10);
    Lv_Consulta := Lv_Consulta||'FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG'||CHR(10);
    Lv_Consulta := Lv_Consulta||'WHERE IOG.EMPRESA_ID = :1'||CHR(10);
    Lv_Consulta := Lv_Consulta||'AND IOG.ESTADO = :2'||CHR(10);
    --
    --
    IF Gv_FechaProceso IS NOT NULL THEN
      --
      IF Gn_TipoProceso = 2 THEN
        Lv_DescripcionIva := 'IVA 12%';
      ELSIF Gn_TipoProceso = 3 THEN
        Lv_DescripcionIva := 'IVA 14%';
      END IF;
      --
      Lv_Consulta := Lv_Consulta||'AND EXISTS (SELECT NULL'||CHR(10);
      Lv_Consulta := Lv_Consulta||'FROM ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,'||CHR(10);
      Lv_Consulta := Lv_Consulta||'INFO_DOCUMENTO_FINANCIERO_CAB IDFC'||CHR(10);
      Lv_Consulta := Lv_Consulta||'WHERE IDFC.OFICINA_ID = IOG.ID_OFICINA'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND IDFC.CONTABILIZADO IS NULL'||CHR(10);
      --
      IF Gv_TipoFechaCtble = FNKG_VAR.Gv_FechaEmision THEN
        Lv_Consulta := Lv_Consulta||'AND IDFC.FE_EMISION >= :3 '||CHR(10);
        Lv_Consulta := Lv_Consulta||'AND IDFC.FE_EMISION <= :4 '||CHR(10);
      ELSIF Gv_TipoFechaCtble = FNKG_VAR.Gv_FechaAutoriza THEN
        Lv_Consulta := Lv_Consulta||'AND IDFC.FE_AUTORIZACION >= :3 '||CHR(10);
        Lv_Consulta := Lv_Consulta||'AND IDFC.FE_AUTORIZACION <= :4 '||CHR(10);
      END IF;
      --
      IF Gn_TipoProceso = 1 THEN
        Lv_Consulta := Lv_Consulta||'AND IDFC.SUBTOTAL_CON_IMPUESTO = 0'||CHR(10);
      ELSE
        Lv_Consulta := Lv_Consulta||'AND IDFC.SUBTOTAL_CON_IMPUESTO > 0'||CHR(10);
      END IF;
      --
      Lv_Consulta := Lv_Consulta||'AND EXISTS (SELECT NULL'||CHR(10);
      Lv_Consulta := Lv_Consulta||'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,'||CHR(10);
      Lv_Consulta := Lv_Consulta||'DB_GENERAL.ADMI_PARAMETRO_CAB APC'||CHR(10);
      Lv_Consulta := Lv_Consulta||'WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND APC.NOMBRE_PARAMETRO = :5'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND APC.ESTADO = :2'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND APD.ESTADO = :2'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND APD.DESCRIPCION = :6'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND APD.VALOR1 = :7'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND APD.VALOR2 = IDFC.TIPO_DOCUMENTO_ID)'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND IDFC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO'||CHR(10);
      --
      Lv_Consulta := Lv_Consulta||'AND EXISTS (SELECT NULL'||CHR(10);
      Lv_Consulta := Lv_Consulta||'FROM DB_GENERAL.ADMI_IMPUESTO AI,'||CHR(10);
      Lv_Consulta := Lv_Consulta||'INFO_DOCUMENTO_FINANCIERO_IMP IDFI,'||CHR(10);
      Lv_Consulta := Lv_Consulta||'INFO_DOCUMENTO_FINANCIERO_DET IDFD'||CHR(10);
      Lv_Consulta := Lv_Consulta||'WHERE IDFD.DOCUMENTO_ID = IDFC.ID_DOCUMENTO'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND AI.DESCRIPCION_IMPUESTO = :8'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND IDFI.IMPUESTO_ID = AI.ID_IMPUESTO'||CHR(10);
      Lv_Consulta := Lv_Consulta||'AND IDFD.ID_DOC_DETALLE = IDFI.DETALLE_DOC_ID)'||CHR(10);
      Lv_Consulta := Lv_Consulta||')'||CHR(10);

    END IF;

    Lv_Consulta := Lv_Consulta||'AND EXISTS (SELECT NULL'||CHR(10);
    Lv_Consulta := Lv_Consulta||'FROM ADMI_CUENTA_CONTABLE ACC'||CHR(10);
    Lv_Consulta := Lv_Consulta||'JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=ACC.TIPO_CUENTA_CONTABLE_ID'||CHR(10);
    Lv_Consulta := Lv_Consulta||'WHERE ACC.VALOR_CAMPO_REFERENCIAL = IOG.ID_OFICINA'||CHR(10);
    Lv_Consulta := Lv_Consulta||'AND ACC.CAMPO_REFERENCIAL = :9'||CHR(10);
    Lv_Consulta := Lv_Consulta||'AND ATCC.DESCRIPCION = :10)'||CHR(10);
    --Lv_Consulta := Lv_Consulta||'ORDER BY IOG.ID_OFICINA';
    --
    IF Gv_FechaProceso IS NOT NULL THEN
      IF Gv_TipoFechaCtble = FNKG_VAR.Gv_FechaEmision THEN
        --
        Ld_FechaEmisionIni := TO_DATE(Gv_FechaProceso||FNKG_VAR.Gv_HoraIniDia, FNKG_VAR.Gv_FmtFechaDateR);
        Ld_FechaEmisionFin := TO_DATE(Gv_FechaProceso||FNKG_VAR.Gv_HoraFinDia, FNKG_VAR.Gv_FmtFechaDateR);
        --
        OPEN Cr_Oficinas FOR Lv_Consulta USING Pv_CodEmpresa, 
                                               FNKG_VAR.Gr_Estado.ACTIVO,
                                               Ld_FechaEmisionIni,
                                               Ld_FechaEmisionFin,
                                               FNKG_VAR.Gv_ValidaProcesoContable,
                                               FNKG_VAR.Gr_Estado.ACTIVO,
                                               FNKG_VAR.Gr_Estado.ACTIVO,
                                               FNKG_VAR.Gv_ParTipoDocfacturacion,
                                               Gv_CodTipoDocumento,
                                               Lv_DescripcionIva,
                                               Lv_DescCampoRef,
                                               Lv_DescTipoCta;

      ELSIF Gv_TipoFechaCtble = FNKG_VAR.Gv_FechaAutoriza THEN
        --
        Ld_FechaAutorizaIni := TO_TIMESTAMP(Gv_FechaProceso||FNKG_VAR.Gv_HoraIniDia, FNKG_VAR.Gv_FmtFechaTimeR);
        Ld_FechaAutorizaFin := TO_TIMESTAMP(Gv_FechaProceso||FNKG_VAR.Gv_HoraFinDia, FNKG_VAR.Gv_FmtFechaTimeR);
        --
        OPEN Cr_Oficinas FOR Lv_Consulta USING Pv_CodEmpresa, 
                                               FNKG_VAR.Gr_Estado.ACTIVO,
                                               Ld_FechaAutorizaIni,
                                               Ld_FechaAutorizaFin,
                                               FNKG_VAR.Gv_ValidaProcesoContable,
                                               FNKG_VAR.Gr_Estado.ACTIVO,
                                               FNKG_VAR.Gr_Estado.ACTIVO,
                                               FNKG_VAR.Gv_ParTipoDocfacturacion,
                                               Gv_CodTipoDocumento,
                                               Lv_DescripcionIva,
                                               Lv_DescCampoRef,
                                               Lv_DescTipoCta;
      END IF;
    ELSE
      OPEN Cr_Oficinas FOR Lv_Consulta USING Pv_CodEmpresa, 
                                             FNKG_VAR.Gr_Estado.ACTIVO,
                                             Lv_DescCampoRef,
                                             Lv_DescTipoCta;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_OFICINAS_POR_EMPRESA', Lv_InfoError);
  END P_OFICINAS_POR_EMPRESA;
  --

  FUNCTION F_VERIFICAR_FACTURADO(
    Ft_Fe_Actual  IN VARCHAR2,
    Fn_IdOficina  IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE
    )
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
  IS
    --Cursor para el sumarizado de detalles
    CURSOR C_ObtenerValorFact(Ct_Fe_Actual  VARCHAR2,
                              Cn_IdOficina  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                              Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
      SELECT SUM(IDFC.VALOR_TOTAL)
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      WHERE TRUNC(IDFC.FE_AUTORIZACION)=TO_DATE(Ct_Fe_Actual,'YYYY-MM-DD')
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND IOG.EMPRESA_ID=Cv_CodEmpresa
      AND IOG.ID_OFICINA=Cn_IdOficina
      GROUP BY TRUNC(IDFC.FE_AUTORIZACION),IOG.NOMBRE_OFICINA;
    --
    Ln_ValorTotal        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError         VARCHAR2(2000);
    --
  BEGIN
    --
    IF C_ObtenerValorFact%ISOPEN THEN
      CLOSE C_ObtenerValorFact;
    END IF;
    --
    OPEN C_ObtenerValorFact(Ft_Fe_Actual,Fn_IdOficina,Fv_CodEmpresa);
    --
    FETCH C_ObtenerValorFact INTO Ln_ValorTotal;
    --
    CLOSE C_ObtenerValorFact;
    --
    IF Ln_ValorTotal IS NULL THEN
      Ln_ValorTotal  := 0;
    END IF;
    --
    RETURN Ln_ValorTotal;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.F_VERIFICAR_FACTURADO', Lv_InfoError);
  END F_VERIFICAR_FACTURADO;

  FUNCTION F_VERIFICAR_REDONDEO(
    Ft_Fe_Actual  IN VARCHAR2,
    Fn_IdOficina  IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE
    )
  RETURN VARCHAR
  IS
    --Cursor para el sumarizado de detalles
    CURSOR C_ObtenerValorDetallesFact(Ct_Fe_Actual  VARCHAR2,
                                      Cn_IdOficina  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                      Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS

      SELECT ROUND(SUM(NVL(IDDP.VALOR,0)),2)
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        JOIN DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT IDDP ON IDDP.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
        --JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
        JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      WHERE IDFC.FE_AUTORIZACION BETWEEN TO_TIMESTAMP(Ct_Fe_Actual||' 00:00:00','YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP(Ct_Fe_Actual||' 23:59:59','YYYY-MM-DD HH24:MI:SS')
      AND IDFC.OFICINA_ID = Cn_IdOficina
      --AND IOG.EMPRESA_ID = Cv_CodEmpresa
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP');

    --Cursor para el sumarizado de detalles
    CURSOR C_ObtenerValorFact(Ct_Fe_Actual  VARCHAR2,
                              Cn_IdOficina  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                              Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
      SELECT SUM(NVL(IDFC.VALOR_TOTAL,0))
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      --JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      WHERE IDFC.FE_AUTORIZACION BETWEEN TO_TIMESTAMP(Ct_Fe_Actual||' 00:00:00','YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP(Ct_Fe_Actual||' 23:59:59','YYYY-MM-DD HH24:MI:SS')
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      --AND IOG.EMPRESA_ID=Cv_CodEmpresa
      AND IDFC.OFICINA_ID=Cn_IdOficina;

    --Cursor para el sumarizado de detalles de notas de credito
    CURSOR C_ObtenerValorDetallesNc(Ct_Fe_Actual  VARCHAR2,
                                      Cn_IdOficina  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                      Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
      SELECT ROUND(SUM(NVL(IDDP.VALOR,0)),2)
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT IDDP ON IDDP.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      WHERE IDFC.FE_AUTORIZACION BETWEEN TO_TIMESTAMP(Ct_Fe_Actual||' 00:00:00','YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP(Ct_Fe_Actual||' 23:59:59','YYYY-MM-DD HH24:MI:SS')
      --TRUNC(IDFC.FE_AUTORIZACION)=TO_DATE(Ct_Fe_Actual,'YYYY-MM-DD')
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('NC')
      AND IOG.EMPRESA_ID = Cv_CodEmpresa
      AND IOG.ID_OFICINA = Cn_IdOficina
      --GROUP BY TRUNC(IDFC.FE_AUTORIZACION),IOG.NOMBRE_OFICINA
      ;

    --Cursor para el sumarizado de detalles de notas de credito
    CURSOR C_ObtenerValorNc(Ct_Fe_Actual  VARCHAR2,
                              Cn_IdOficina  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                              Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
      SELECT SUM(NVL(IDFC.VALOR_TOTAL,0))
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      WHERE IDFC.FE_AUTORIZACION BETWEEN TO_TIMESTAMP(Ct_Fe_Actual||' 00:00:00','YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP(Ct_Fe_Actual||' 23:59:59','YYYY-MM-DD HH24:MI:SS')
      --TRUNC(IDFC.FE_AUTORIZACION)=TO_DATE(Ct_Fe_Actual,'YYYY-MM-DD')
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('NC')
      AND IOG.EMPRESA_ID = Cv_CodEmpresa
      AND IOG.ID_OFICINA = Cn_IdOficina
      --GROUP BY TRUNC(IDFC.FE_AUTORIZACION),IOG.NOMBRE_OFICINA
      ;
    --
    --
    Ln_ValorTotalDetalle DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Ln_ValorTotal        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError         VARCHAR2(2000);
    Lv_BanderaRedondeo   VARCHAR2(1) :='N';
    --
  BEGIN
    /*
     * Proceso:
     * - Para Fv_CodigoTipoDocumento: FAC, se va utilizar los cursores de facturas, tanto del detallado como del
     *   agrupado mediante la oficina y la fecha ya que es necesario saber si el proceso debe redondear o no
     * - Para Fv_CodigoTipoDocumento: NC se va utilizar los cursores de facturas, tanto del detallado como del
     *   agrupado mediante la oficina y la fecha ya que es necesario saber si el proceso debe redondear o no
     */
    --
    IF C_ObtenerValorDetallesFact%ISOPEN THEN
      CLOSE C_ObtenerValorDetallesFact;
    END IF;
    --
    IF C_ObtenerValorFact%ISOPEN THEN
      CLOSE C_ObtenerValorFact;
    END IF;
    --
    IF (Fv_CodigoTipoDocumento = 'FAC') THEN
      --
      OPEN C_ObtenerValorDetallesFact(Ft_Fe_Actual,Fn_IdOficina,Fv_CodEmpresa);
      --
      FETCH C_ObtenerValorDetallesFact INTO Ln_ValorTotalDetalle;
      --
      CLOSE C_ObtenerValorDetallesFact;
      --
      IF Ln_ValorTotalDetalle IS NULL THEN
        Ln_ValorTotalDetalle  := 0;
      END IF;
      --
      OPEN C_ObtenerValorFact(Ft_Fe_Actual,Fn_IdOficina,Fv_CodEmpresa);
      --
      FETCH C_ObtenerValorFact INTO Ln_ValorTotal;
      --
      CLOSE C_ObtenerValorFact;
      --
      IF Ln_ValorTotal IS NULL THEN
        Ln_ValorTotal  := 0;
      END IF;
      --
      IF (Ln_ValorTotal>Ln_ValorTotalDetalle) THEN
        Lv_BanderaRedondeo:='S';
      ELSE
        Lv_BanderaRedondeo:='N';
      END IF;
      --
    ELSIF(Fv_CodigoTipoDocumento = 'NC') THEN
      --
      OPEN C_ObtenerValorDetallesNc(Ft_Fe_Actual,Fn_IdOficina,Fv_CodEmpresa);
      --
      FETCH C_ObtenerValorDetallesNc INTO Ln_ValorTotalDetalle;
      --
      CLOSE C_ObtenerValorDetallesNc;
      --
      IF Ln_ValorTotalDetalle IS NULL THEN
        Ln_ValorTotalDetalle  := 0;
      END IF;
      --
      OPEN C_ObtenerValorNc(Ft_Fe_Actual,Fn_IdOficina,Fv_CodEmpresa);
      --
      FETCH C_ObtenerValorNc INTO Ln_ValorTotal;
      --
      CLOSE C_ObtenerValorNc;
      --
      IF Ln_ValorTotal IS NULL THEN
        Ln_ValorTotal  := 0;
      END IF;
      --
      IF (Ln_ValorTotal>Ln_ValorTotalDetalle) THEN
        Lv_BanderaRedondeo:='S';
      ELSE
        Lv_BanderaRedondeo:='N';
      END IF;
      --
    END IF;
    --
    RETURN Lv_BanderaRedondeo;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.F_VERIFICAR_REDONDEO', Lv_InfoError);
  END F_VERIFICAR_REDONDEO;

  PROCEDURE P_LISTADO_POR_OFICINA(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cr_ProductosFacturados  IN  SYS_REFCURSOR,
    Pt_Fe_Actual            IN  VARCHAR2,
    Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Cr_OficinasFacturado    OUT TypeOficinasFacturadosTab,
    Pr_Documentos           OUT TypeDocumentosFacturadosTab
  )
  AS
    Lv_InfoError   VARCHAR2(2000);
    Cr_Oficinas    SYS_REFCURSOR;


    --tn:jgilces:se redefine cr_productos a una tabla plsql para realizar BULK Collect
    --Cr_Productos   TypeDetalleProductos;
    type lstProductos is table of TypeDetalleProductos index by pls_integer;
    Cr_Productos  lstProductos;

    --Cr_Oficina     TypeoOficinas;
    type lstOficinas is table of TypeoOficinas index by pls_integer;
    Cr_Oficina  lstOficinas;
    ---

    Ln_Subtotal    INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
    Ln_Iva         INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE;
    Ln_Ice         INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE;
    --
    Ln_SubtotalIdx INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
    Ln_SubtotalDif INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
    --
    Ln_OficinaIdx  PLS_INTEGER;
    Ln_ProductoIdx PLS_INTEGER;
    --
    ln_oficina number;
    LN_PRODUCTO NUMBER;

    LE_FORALL_EXCEPT EXCEPTION;
    PRAGMA EXCEPTION_INIT(LE_FORALL_EXCEPT, -24381);

  BEGIN
    --

    P_OFICINAS_POR_EMPRESA(Pv_CodEmpresa,Cr_Oficinas);

    fetch Cr_Oficinas bulk collect into Cr_Oficina;
    close Cr_Oficinas;

   if Cr_Oficina.count > 0 then
     ln_oficina := Cr_Oficina.first;
    while (ln_oficina is not null) loop

      Cr_OficinasFacturado(Cr_Oficina(ln_oficina).ID_OFICINA).OFICINA_ID:=Cr_Oficina(ln_oficina).ID_OFICINA;
      Cr_OficinasFacturado(Cr_Oficina(ln_oficina).ID_OFICINA).NOMBRE_OFICINA:=Cr_Oficina(ln_oficina).NOMBRE_OFICINA;
      Cr_OficinasFacturado(Cr_Oficina(ln_oficina).ID_OFICINA).REDONDEO:=Gv_Redondear;

      --Verifir a nivel de la oficina si debe redondearse o no
      --Se envian de parametros fe_actual, oficina, empresa
      /* Cr_OficinasFacturado(Cr_Oficina.ID_OFICINA).REDONDEO:=F_VERIFICAR_REDONDEO(Pt_Fe_Actual,
                                                                                  Cr_Oficina.ID_OFICINA,
                                                                                  Pv_CodEmpresa,
                                                                                  Pv_CodigoTipoDocumento);*/
      --Documentos
      Pr_Documentos(Cr_Oficina(ln_oficina).ID_OFICINA).OFICINA_ID:=Cr_Oficina(ln_oficina).ID_OFICINA;
	  ln_oficina := Cr_Oficina.next(ln_oficina);
    END LOOP;
    end if;

    Ln_Subtotal:=0;
    Ln_Iva:=0;
    Ln_Ice:=0;
    --
    --
    fetch Cr_ProductosFacturados bulk collect into Cr_Productos;
    close Cr_ProductosFacturados;

    --insercion temporal 
    BEGIN
      SELECT SYS_GUID() INTO Gv_IdTemporalDocumentos FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        Gv_IdTemporalDocumentos := USER||TO_CHAR(SYSDATE,'ddmmyyyyhh24miss');
    END;

    FORALL idx IN Cr_Productos.FIRST..Cr_Productos.LAST SAVE EXCEPTIONS
    INSERT INTO db_financiero.info_tmp_productos(uuid, 
                                                 id_documento, 
                                                 punto_id, 
                                                 oficina_id, 
                                                 estado_impresion_fact)
    VALUES(Gv_IdTemporalDocumentos,
           Cr_Productos(idx).ID_DOCUMENTO,
           Cr_Productos(idx).PUNTO_ID,
           Cr_Productos(idx).OFICINA_ID,
           Cr_Productos(idx).ESTADO);

    commit;
    --

    if Cr_Productos.count > 0 then
      LN_PRODUCTO := Cr_Productos.first;
    --for producto in Cr_Productos.first..Cr_Productos.last loop
    WHILE(LN_PRODUCTO IS NOT NULL) LOOP
    --LOOP
      /*FETCH Cr_ProductosFacturados into Cr_Productos;
      EXIT WHEN Cr_ProductosFacturados%NOTFOUND;*/--tn:jgilces:reemplazo bulk collect

      ---
      --Agrego el producto
      Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).PRODUCTO_ID:=Cr_Productos(LN_PRODUCTO).PRODUCTO_ID;

      --Obtengo valor para acumular
      IF(Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).TOTAL IS NULL) THEN
        Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).TOTAL:=0;
      END IF;

      IF(Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).IVA IS NULL) THEN
        Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).IVA:=0;
      END IF;

      IF(Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).ICE IS NULL) THEN
        Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).ICE:=0;
      END IF;

      IF(Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).IMPUESTO_ID IS NULL) THEN
        Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).IMPUESTO_ID:=0;
      END IF;

      Ln_Subtotal:=Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).TOTAL;
      Ln_Iva:=Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).IVA;
      Ln_Ice:=Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).ICE;

      IF (Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).REDONDEO='S') THEN
        --
        IF Cr_Productos(LN_PRODUCTO).IMPUESTO_ID=0 THEN
          Ln_Subtotal := ROUND(ROUND(Ln_Subtotal,3),2) + ROUND(ROUND(Cr_Productos(LN_PRODUCTO).VALOR,3),2);
        ELSIF Cr_Productos(LN_PRODUCTO).IMPUESTO_ID=2 THEN
          Ln_Ice := ROUND(ROUND(Ln_Ice,3),2) + ROUND(ROUND(Cr_Productos(LN_PRODUCTO).VALOR,3),2);
        ELSE
          Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).IMPUESTO_ID:=Cr_Productos(LN_PRODUCTO).IMPUESTO_ID;
          Ln_Iva:= ROUND(ROUND(Ln_Iva,3),2) + ROUND(ROUND(Cr_Productos(LN_PRODUCTO).VALOR,3),2);
        END IF;
        --
      ELSE
        IF Cr_Productos(LN_PRODUCTO).IMPUESTO_ID=0 THEN
          Ln_Subtotal := Ln_Subtotal+ Cr_Productos(LN_PRODUCTO).VALOR;
        ELSIF Cr_Productos(LN_PRODUCTO).IMPUESTO_ID=2 THEN
          Ln_Ice := Ln_Ice + Cr_Productos(LN_PRODUCTO).VALOR;
        ELSE
          Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).IMPUESTO_ID:=Cr_Productos(LN_PRODUCTO).IMPUESTO_ID;
          Ln_Iva:= Ln_Iva + Cr_Productos(LN_PRODUCTO).VALOR;
        END IF;
      END IF;

      --
      --Guardo los valores nuevos acumulados
      Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).TOTAL := Ln_Subtotal;
      Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).IVA   := Ln_Iva;
      Cr_OficinasFacturado(Cr_Productos(LN_PRODUCTO).OFICINA_ID).PRODUCTOS(Cr_Productos(LN_PRODUCTO).PRODUCTO_ID).ICE   := Ln_Ice;

      --Guardo los documentos por oficina unicamente
      Pr_Documentos(Cr_Productos(LN_PRODUCTO).OFICINA_ID).DOCUMENTOS(Cr_Productos(LN_PRODUCTO).ID_DOCUMENTO).ID_DOCUMENTO := Cr_Productos(LN_PRODUCTO).ID_DOCUMENTO;
      Pr_Documentos(Cr_Productos(LN_PRODUCTO).OFICINA_ID).DOCUMENTOS(Cr_Productos(LN_PRODUCTO).ID_DOCUMENTO).PUNTO_ID     := Cr_Productos(LN_PRODUCTO).PUNTO_ID;
      Pr_Documentos(Cr_Productos(LN_PRODUCTO).OFICINA_ID).DOCUMENTOS(Cr_Productos(LN_PRODUCTO).ID_DOCUMENTO).ESTADO       := Cr_Productos(LN_PRODUCTO).ESTADO;
      --
      LN_PRODUCTO := CR_PRODUCTOS.NEXT(LN_PRODUCTO);
    END LOOP;
    end if;
    --
    EXCEPTION
      WHEN LE_FORALL_EXCEPT THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
          'TELCOS-CONTABILIDAD',
          'DB_FINANCIERO.FNKG_CONTABILIZAR_FACT.P_LISTADO_POR_OFICINA',
          'Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||chr(13),
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
          SYSDATE,
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1')
          );
      WHEN OTHERS THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
          'TELCOS-CONTABILIDAD',
          'DB_FINANCIERO.FNKG_CONTABILIZAR_FACT.P_LISTADO_POR_OFICINA',
          'Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
          SYSDATE,
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1')
          );
  END P_LISTADO_POR_OFICINA;

  PROCEDURE P_TOTALIZANDO_POR_OFICINA(
    Pr_OficinasFacturado  IN  TypeOficinasFacturadosTab,
    Pn_OficinaIdx         IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Pn_ValorTotal         OUT TypeTotalOficinaImpuesto
  )
  AS
    Ln_ProductoIdx      PLS_INTEGER;
    Ln_ImpuestoId       INFO_DOCUMENTO_FINANCIERO_IMP.IMPUESTO_ID%TYPE;
  BEGIN

    --
    Ln_ProductoIdx      := Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS.FIRST;
    LOOP
      EXIT WHEN Ln_ProductoIdx IS NULL;
      --Inicializo
      Ln_ImpuestoId :=  Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).IMPUESTO_ID;

      --
      Pn_ValorTotal(Ln_ImpuestoId).IMPUESTO_ID := Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).IMPUESTO_ID;
      --
      Pn_ValorTotal(Ln_ImpuestoId).DESCUENTO := 0;
      --Hago la sumatoria
      Pn_ValorTotal(Ln_ImpuestoId).TOTAL := NVL(Pn_ValorTotal(Ln_ImpuestoId).TOTAL,0)
                                            +Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).TOTAL
                                            +Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).IVA
                                            +Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).ICE;
      Pn_ValorTotal(Ln_ImpuestoId).IVA := NVL(Pn_ValorTotal(Ln_ImpuestoId).IVA,0)
                                          +Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).IVA;

      Pn_ValorTotal(Ln_ImpuestoId).ICE := NVL(Pn_ValorTotal(Ln_ImpuestoId).ICE,0) 
                                          +Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).ICE;


      --Avanzo el registro
      Ln_ProductoIdx:=Pr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS.next(Ln_ProductoIdx);

    END LOOP;

    --Guardo los valores

  END P_TOTALIZANDO_POR_OFICINA;

  PROCEDURE O_OBTENER_DATA_DOCUMENTO(
    Pv_IdDocumento    IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Cr_InfoDocumento  OUT SYS_REFCURSOR
  )
  AS
    Lv_InfoError  VARCHAR2(2000);
  BEGIN
    OPEN Cr_InfoDocumento FOR
      SELECT
      TO_CHAR(IDFC.FE_AUTORIZACION,'YYYY-MM-DD') AS FE_AUTORIZACION,
      TO_CHAR(IDFC.FE_EMISION,'YYYY-MM-DD') AS FE_EMISION,
      IDFC.NUMERO_FACTURA_SRI,
      IP.LOGIN,
      IOG.NOMBRE_OFICINA,
      IDFC.USR_CREACION,
      IDFC.ESTADO_IMPRESION_FACT AS ESTADO,
      IEG.COD_EMPRESA,
      IEG.PREFIJO,
      IDFC.ES_AUTOMATICA,
      ATDF.CODIGO_TIPO_DOCUMENTO
      FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      JOIN DB_COMERCIAL.INFO_PUNTO IP ON IDFC.PUNTO_ID=IP.ID_PUNTO
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG on IEG.COD_EMPRESA=IOG.EMPRESA_ID
      WHERE IDFC.ID_DOCUMENTO=Pv_IdDocumento;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.O_OBTENER_DATA_DOCUMENTO', Lv_InfoError);
  END O_OBTENER_DATA_DOCUMENTO;

  PROCEDURE P_GENERAR_DESCRIPCION(
    Pv_FormatoGlosa         IN  ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_GLOSA%TYPE,
    Pv_Fe_Actual            IN  VARCHAR2,
    Pv_Oficina              IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
    Pv_Login                IN  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    Pv_NumeroFacturaSri     IN  INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    Pv_Descripcion          OUT  VARCHAR2
  )
  AS
    LrInfoDocumento   TypeInfoDocumento;
    Lv_Formato        TypeArreglo;
  BEGIN
    --
    P_SPLIT(Pv_FormatoGlosa,'|',Lv_Formato);
    --
    FOR i IN 0..Lv_Formato.count - 1 loop
    --
      IF (Lv_Formato(i) = 'fe_emision') THEN
        Pv_Descripcion := Pv_Descripcion ||' '|| Pv_Fe_Actual;
      ELSIF (Lv_Formato(i) = 'nombre_oficina') THEN
        Pv_Descripcion := Pv_Descripcion ||' '|| Pv_Oficina;
      ELSIF (Lv_Formato(i) = 'login_pto') THEN
        Pv_Descripcion := Pv_Descripcion ||' '|| Pv_Login;
      ELSIF (Lv_Formato(i) = 'numero_factura_sri') THEN
        Pv_Descripcion := Pv_Descripcion ||' '|| Pv_NumeroFacturaSri;
      ELSIF (Lv_Formato(i) = 'longitud_250') THEN
        Pv_Descripcion:=SUBSTR(Pv_Descripcion,1,250);
      ELSIF (Lv_Formato(i) = 'longitud_100') THEN
        Pv_Descripcion:=SUBSTR(Pv_Descripcion,1,100);
      ELSIF (Lv_Formato(i) = 'longitud_240') THEN
        Pv_Descripcion:=SUBSTR(Pv_Descripcion,1,240);
      ELSE
        Pv_Descripcion := Pv_Descripcion || Lv_Formato(i);
      END IF;
    --
    END LOOP;
  END P_GENERAR_DESCRIPCION;

  FUNCTION F_GENERAR_NOMBRE_PLANTILLA(
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pn_FlatIva              IN  VARCHAR2
  )RETURN VARCHAR2
  AS
    Lv_NombrePlantilla  VARCHAR2(200);
    Lv_InfoError        VARCHAR2(3000);
  BEGIN
    Lv_NombrePlantilla:='';
    --
    IF Pv_CodigoTipoDocumento='FAC' THEN
      IF Pv_TipoProceso='INDIVIDUAL' THEN
        IF Pn_FlatIva='S' THEN
          Lv_NombrePlantilla:='FACTURA INDIVIDUAL CON IVA';
        ELSE
          Lv_NombrePlantilla:='FACTURA INDIVIDUAL SIN IVA';
        END IF;
      ELSIF Pv_TipoProceso='MASIVO' THEN
        IF Pn_FlatIva='S' THEN
          Lv_NombrePlantilla:='FACTURA MASIVA CON IVA';
        ELSE
          Lv_NombrePlantilla:='FACTURA MASIVA SIN IVA';
        END IF;
      ELSIF Pv_TipoProceso='ANULACION-FAC' THEN
        IF Pn_FlatIva='S' THEN
          Lv_NombrePlantilla:='ANULACION DE FACTURAS MASIVAS CON IVA';--Anulacion de facturas con iva
        ELSE
          Lv_NombrePlantilla:='ANULACION DE FACTURAS MASIVAS SIN IVA';--Anulacion de facturas sin iva
        END IF;
      ELSIF Pv_TipoProceso='AJUSTE POR REDONDEO' THEN
        Lv_NombrePlantilla:='FACTURA '||Pv_TipoProceso;-- FACTURA AJUTE POR REDONDEO
      END IF;
    ELSIF Pv_CodigoTipoDocumento='NC' THEN
      IF Pv_TipoProceso='MASIVO' THEN
        IF Pn_FlatIva='S' THEN
          Lv_NombrePlantilla:='NOTA DE CREDITO MASIVA CON IVA';
        ELSE
          Lv_NombrePlantilla:='NOTA DE CREDITO MASIVA SIN IVA';
        END IF;
      ELSIF Pv_TipoProceso='ANULACION-FAC' THEN
        IF Pn_FlatIva='S' THEN
          Lv_NombrePlantilla:='ANULACION DE NOTA DE CREDITO MASIVA CON IVA';--Anulacion de facturas con iva
        ELSE
          Lv_NombrePlantilla:='ANULACION DE NOTA DE CREDITO MASIVA SIN IVA';--Anulacion de facturas sin iva
        END IF;
      ELSIF Pv_TipoProceso='AJUSTE POR REDONDEO' THEN
        Lv_NombrePlantilla:='NOTA DE CREDITO '||Pv_TipoProceso;--Anulacion de facturas sin iva
      END IF;
    END IF;
    RETURN Lv_NombrePlantilla;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.F_GENERAR_NOMBRE_PLANTILLA', Lv_InfoError);
  END F_GENERAR_NOMBRE_PLANTILLA;

  PROCEDURE P_SPLIT(
    Pv_Cadena   IN VARCHAR2,
    Pv_Caracter IN VARCHAR2,
    Pr_Arreglo  OUT TypeArreglo
  )
  AS
    Ln_Idx number := 0;
  BEGIN
      FOR CURRENT_ROW IN (
        WITH TEST AS
        (SELECT Pv_Cadena FROM DUAL)
        SELECT regexp_substr(Pv_Cadena, '[^'||Pv_Caracter||']+', 1, ROWNUM) SPLIT
        FROM TEST
        CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_Cadena, '[^'||Pv_Caracter||']+'))  + 1
      )
      LOOP
        Ln_Idx := Ln_Idx + 1;
        Pr_Arreglo(Pr_Arreglo.COUNT) := CURRENT_ROW.SPLIT;
      END LOOP;
  END P_SPLIT;

  PROCEDURE P_GENERAR_NO_ASIENTO(
    Pv_FormatoNoAsiento     IN  ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_NO_DOCU_ASIENTO%TYPE,
    Pv_Fe_Actual            IN  VARCHAR2,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pn_IdOficina            IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Pv_NoAsiento            OUT  VARCHAR2
  )
  AS
    Lv_Formato        TypeArreglo;
    Pr_Arreglo        TypeArreglo;
    Pv_Caracter       VARCHAR2(1):='-';

  BEGIN
    --
    Pv_NoAsiento:=  NULL;
    P_SPLIT(Pv_FormatoNoAsiento,'|',Lv_Formato);
    P_SPLIT(Pv_Fe_Actual,Pv_Caracter,Pr_Arreglo);
    --
    FOR i IN 0..Lv_Formato.count - 1 loop
    --
      IF (Lv_Formato(i) = 'id_oficina') THEN
        Pv_NoAsiento := Pv_NoAsiento || Pn_IdOficina;
      ELSIF (Lv_Formato(i) = 'anio_fe_emision') THEN
        Pv_NoAsiento := Pv_NoAsiento || Pr_Arreglo(0);
      ELSIF (Lv_Formato(i) = 'mes_fe_emision') THEN
        Pv_NoAsiento := Pv_NoAsiento || Pr_Arreglo(1);
      ELSIF (Lv_Formato(i) = 'dia_fe_emision') THEN
        Pv_NoAsiento:=  Pv_NoAsiento || Pr_Arreglo(2);
      ELSIF (Lv_Formato(i) = 'id_documento') THEN
        Pv_NoAsiento:=  Pv_NoAsiento || Pv_IdDocumento;
      ELSE
        Pv_NoAsiento := Pv_NoAsiento || Lv_Formato(i);
      END IF;
    --
    END LOOP;
  END P_GENERAR_NO_ASIENTO;

  PROCEDURE P_OBTENER_CUENTA_CONTABLE(
    Pv_CodEmpresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_TipoCuentaContable     IN  ADMI_TIPO_CUENTA_CONTABLE.DESCRIPCION%TYPE,
    Pv_CampoReferencial       IN  ADMI_CUENTA_CONTABLE.CAMPO_REFERENCIAL%TYPE,
    Pv_ValorCampoReferencial  IN  ADMI_CUENTA_CONTABLE.VALOR_CAMPO_REFERENCIAL%TYPE,
    Pv_Oficina                IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
    Cr_CtaContable            OUT VARCHAR2,
    Cr_NoCta                  OUT VARCHAR2
  )
  AS
    Lv_InfoError  VARCHAR(3000);
  BEGIN
    IF Pv_TipoCuentaContable='BANCOS' THEN
      --Cuando es BANCOS ya tenemos directamente el valor correspondiente al id_cuenta_contable.
      SELECT
      ACC.CUENTA,
      ACC.NO_CTA
      INTO Cr_CtaContable,Cr_NoCta
      FROM ADMI_CUENTA_CONTABLE ACC
      WHERE
      ACC.ID_CUENTA_CONTABLE=TO_NUMBER(Pv_ValorCampoReferencial);

    ELSIF Pv_TipoCuentaContable IN ('BANCOS DEBITOS MD', 'PORTADOR MD', 'SERVICIO') THEN
      SELECT
      ACC.CUENTA,
      ACC.NO_CTA
      INTO Cr_CtaContable,Cr_NoCta
      FROM ADMI_CUENTA_CONTABLE ACC
      JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=ACC.TIPO_CUENTA_CONTABLE_ID
      WHERE
      ATCC.DESCRIPCION=Pv_TipoCuentaContable
      AND ACC.CAMPO_REFERENCIAL=Pv_CampoReferencial
      AND ACC.VALOR_CAMPO_REFERENCIAL=Pv_ValorCampoReferencial
      AND ACC.NO_CIA=Pv_CodEmpresa;

    ELSE
      --Cuando son los demas casos.
      SELECT
      ACC.CUENTA,
      ACC.NO_CTA
      INTO Cr_CtaContable,Cr_NoCta
      FROM ADMI_CUENTA_CONTABLE ACC
      JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=ACC.TIPO_CUENTA_CONTABLE_ID
      WHERE
      ATCC.DESCRIPCION=Pv_TipoCuentaContable
      AND ACC.CAMPO_REFERENCIAL=Pv_CampoReferencial
      AND ACC.VALOR_CAMPO_REFERENCIAL=Pv_ValorCampoReferencial
      AND ACC.NO_CIA=Pv_CodEmpresa
      AND ACC.OFICINA_ID=Pv_Oficina;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:='Parametros: Pv_CodEmpresa'||Pv_CodEmpresa||'- Pv_TipoCuentaContable:'||Pv_TipoCuentaContable||'- Pv_CampoReferencial: '
                    ||Pv_CampoReferencial||'- Pv_ValorCampoReferencial: '||Pv_ValorCampoReferencial||'- Pv_Oficina:'||Pv_Oficina;
      Lv_InfoError:=Lv_InfoError ||'Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_CUENTA_CONTABLE', Lv_InfoError);
  END P_OBTENER_CUENTA_CONTABLE;

  PROCEDURE P_POSICION_VALOR(
    Pv_Posicion IN ADMI_PLANTILLA_CONTABLE_DET.POSICION%TYPE,
    Pn_Monto    IN OUT INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
  )
  AS
  BEGIN
    --Tranformo en negativo segun el proceso
    IF Pv_Posicion='C' THEN
      Pn_Monto:=Pn_Monto*(-1);
    END IF;
  END P_POSICION_VALOR;

  PROCEDURE P_MARCAR_CONTABILIZADO(
    Pv_IdDocumento  IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_TipoProceso  IN  VARCHAR2
  )
  AS
  --[Proceso contable OK]
    Lr_InfoDocumentoHistorial     INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Lr_InfoDocumentoFinancieroCab INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Pv_MsnError                   VARCHAR2(3000);
    Cr_InfoDocumento              SYS_REFCURSOR;
    LrInfoDocumento               TypeInfoDocumento;
  BEGIN

    --Debo consultar la data del registro para verificar el estado
    O_OBTENER_DATA_DOCUMENTO(Pv_IdDocumento,Cr_InfoDocumento);
    FETCH Cr_InfoDocumento INTO LrInfoDocumento;

    --Se guarda el historial
    Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL  := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
    Lr_InfoDocumentoHistorial.DOCUMENTO_ID            :=  Pv_IdDocumento;
    Lr_InfoDocumentoHistorial.FE_CREACION             :=  SYSDATE;
    Lr_InfoDocumentoHistorial.USR_CREACION            :=  'telcos';
    Lr_InfoDocumentoHistorial.ESTADO                  :=  LrInfoDocumento.ESTADO;
    Lr_InfoDocumentoHistorial.OBSERVACION             :=  '[Proceso contable OK | Tipo proceso:'||Pv_TipoProceso||']';
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoHistorial,Pv_MsnError);

    --Se actualiza la bandera contabilizado
    Lr_InfoDocumentoFinancieroCab.CONTABILIZADO       :=  'S';
    DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Pv_IdDocumento,Lr_InfoDocumentoFinancieroCab,Pv_MsnError);

  END P_MARCAR_CONTABILIZADO;
  --
  /**
    * Documentacion para el Procedure P_OFICINAS_POR_EMPRESA
    * procedure que registra historial y actualiza a contabilizado los documentos.
    * @author Luis Lindao <llindao@telconet.ec>
    * @version 1.1 21-06-2018
    *
    * @Param Pn_IdDocumento  IN NUMBER,    Id documento
    * @Param Pv_EstadoDoc    IN VARCHAR2,  Estado documento
    * @Param Pv_TipoProceso  IN VARCHAR2   Tipo de proceso que se esta ejecutando
  */  
  PROCEDURE P_ACTUALIZA_CONTABILIZADO ( Pn_IdDocumento  IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                        Pv_EstadoDoc    IN  INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                                        Pr_DocumentosAsociados IN DB_FINANCIERO.FNCK_TRANSACTION.lstSecuenciaDocumentosType default null,
                                        Pv_TipoProceso  IN  VARCHAR2
  )
  AS
  --[Proceso contable OK]
    Lr_InfoDocumentoHistorial     INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Lr_InfoDocumentoFinancieroCab INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Pv_MsnError                   VARCHAR2(3000);
    Cr_InfoDocumento              SYS_REFCURSOR;
    --LrInfoDocumento               TypeInfoDocumento;

    LE_FORALL_EXCEPT EXCEPTION;
    PRAGMA EXCEPTION_INIT(LE_FORALL_EXCEPT, -24381);
  BEGIN

    --Se guarda el historial
    --Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL  := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
    --Lr_InfoDocumentoHistorial.DOCUMENTO_ID            :=  Pn_IdDocumento;
    Lr_InfoDocumentoHistorial.FE_CREACION             :=  SYSDATE;
    Lr_InfoDocumentoHistorial.USR_CREACION            :=  'telcos';
    --Lr_InfoDocumentoHistorial.ESTADO                  :=  Pv_EstadoDoc;
    Lr_InfoDocumentoHistorial.OBSERVACION             :=  '[Proceso contable OK | Tipo proceso:'||Pv_TipoProceso||']';

    IF Pv_TipoProceso NOT IN ('MASIVO') THEN
      Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL  := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
      Lr_InfoDocumentoHistorial.DOCUMENTO_ID            :=  Pn_IdDocumento;
      Lr_InfoDocumentoHistorial.ESTADO                  :=  Pv_EstadoDoc;

      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoHistorial,Pv_MsnError);

      --Se actualiza la bandera contabilizado
      UPDATE INFO_DOCUMENTO_FINANCIERO_CAB
      SET CONTABILIZADO = 'S'
      WHERE ID_DOCUMENTO  = Pn_IdDocumento;
    ELSE
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINAN_HST_MAS(Pr_DocumentosAsociados,Pv_MsnError);

      --Se actualiza la bandera contabilizado
      FORALL idx IN Pr_DocumentosAsociados.FIRST..Pr_DocumentosAsociados.LAST SAVE EXCEPTIONS
      UPDATE INFO_DOCUMENTO_FINANCIERO_CAB
      SET CONTABILIZADO = 'S'
      WHERE ID_DOCUMENTO  = Pr_DocumentosAsociados(idx).DOCUMENTO;

    END IF;

  EXCEPTION
    WHEN LE_FORALL_EXCEPT THEN 
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
          'TELCOS-CONTABILIDAD',
          'DB_FINANCIERO.FNKG_CONTABILIZAR_FACT.P_ACTUALIZA_CONTABILIZADO',
          'Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||chr(13),
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
          SYSDATE,
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1')
          );
  END P_ACTUALIZA_CONTABILIZADO;
  --

  /**

  **/
  PROCEDURE P_GENERA_SECUENCIAS_MASIVO(Pv_Uuid DB_FINANCIERO.INFO_TMP_PRODUCTOS.UUID%TYPE) IS
   LN_CONTADOR NUMBER;
   TYPE SECUENCIA_DOCS IS RECORD(
        SECUENCIA NUMBER,
        DOCUMENTO NUMBER
   );
   TYPE LST_SECUENCIAS_TYPE IS TABLE OF SECUENCIA_DOCS;
   PR_SECUENCIAS LST_SECUENCIAS_TYPE;

   CURSOR CTEST(UUID VARCHAR2) IS
   SELECT DISTINCT A.ID_DOCUMENTO, A.OFICINA_ID FROM DB_FINANCIERO.INFO_TMP_PRODUCTOS A WHERE A.UUID = UUID;

   LE_FORALL_EXCEPT EXCEPTION;
   PRAGMA EXCEPTION_INIT(LE_FORALL_EXCEPT, -24381);

  BEGIN
   PR_SECUENCIAS := LST_SECUENCIAS_TYPE();

   LN_CONTADOR := 1;
   FOR DOC IN CTEST(Pv_Uuid) LOOP
      PR_SECUENCIAS.EXTEND;
      PR_SECUENCIAS(LN_CONTADOR).SECUENCIA := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
      PR_SECUENCIAS(LN_CONTADOR).DOCUMENTO := DOC.ID_DOCUMENTO;
      LN_CONTADOR := LN_CONTADOR + 1;
   END LOOP;

   FORALL idx IN PR_SECUENCIAS.FIRST..PR_SECUENCIAS.LAST SAVE EXCEPTIONS
   INSERT INTO DB_FINANCIERO.INFO_TMP_SECUENCIA_DOCS(UUID, SECUENCIA, ID_DOCUMENTO)
   VALUES(Pv_Uuid,PR_SECUENCIAS(idx).SECUENCIA,PR_SECUENCIAS(idx).DOCUMENTO);

   EXCEPTION
     WHEN LE_FORALL_EXCEPT THEN 
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
          'TELCOS-CONTABILIDAD',
          'DB_FINANCIERO.FNKG_CONTABILIZAR_FACT.P_ACTUALIZA_CONTABILIZADO',
          'Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||chr(13),
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
          SYSDATE,
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1')
          );
  END;

  PROCEDURE P_PROCESAR(
      Cr_ProductosFacturados  IN  SYS_REFCURSOR,
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoProceso          IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pt_Fe_Actual            IN  VARCHAR2,
      Pv_DescripcionImpuesto  IN  VARCHAR2
      )
  AS

  ln_secuenciasGeneradas boolean;

    --
    CURSOR C_ASIENTO_CONTABLE ( Cn_IdMigracion NUMBER,
                                Cv_NoCia       VARCHAR2) IS
      SELECT SUM(AL.MONTO) MONTO,
        (SELECT DECODE(ATDF.MOVIMIENTO, '+', 'D', 'C') 
         FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
         WHERE ATDF.CODIGO_TIPO_DOCUMENTO = Pv_CodigoTipoDocumento) NATURALEZA_DOCUMENTO
      FROM MIGRA_ARCGAL AL
      WHERE AL.MIGRACION_ID = Cn_IdMigracion
      AND AL.NO_CIA = Cv_NoCia
      GROUP BY AL.MIGRACION_ID, AL.NO_CIA;
    --
    Lr_AsientoContable        C_ASIENTO_CONTABLE%ROWTYPE := NULL;
    --Asiento contable
    Lv_CodDiario              VARCHAR2(100);
    Lv_NoAsiento              VARCHAR2(1000);
    Lv_UsrCreacion            VARCHAR2(1000);
    Pn_FlatIva                VARCHAR2(1);
    Lv_Descripcion            VARCHAR2(3000);
    Pv_CampoReferencial       VARCHAR2(100);
    Pv_ValorCampoReferencial  VARCHAR2(100);
    Cr_CtaContable            VARCHAR2(100);
    Cr_NoCta                  VARCHAR2(100);

     --Tipo de record
    Cr_OficinasFacturado      TypeOficinasFacturadosTab;
    Pr_Arreglo                TypeArreglo;
    Pn_ValorTotal             TypeTotalOficinaImpuesto;
    Pr_Documentos             TypeDocumentosFacturadosTab;
    LrInfoDocumento           TypeInfoDocumento;

    --Tipo para la plantilla
    --Lc_Plantilla              TypePlantillaCab;
    type lstPlantillasCabType is table of TypePlantillaCab;
    Lc_Plantilla lstPlantillasCabType;

    --Lc_PlantillaDet           TypePlantillaDet;
    TYPE LSTPLANTILLASDETTYPE IS TABLE OF TypePlantillaDet;
    Lc_PlantillaDet LSTPLANTILLASDETTYPE;

    --Listas para mejora de procesos, se realiza un insert masivo------
    --tn:jgilces

    lstMigraArcgae NAF47_TNET.GEK_MIGRACION.lstMigraArcgaeType;
    lstMigraArcgal NAF47_TNET.GEK_MIGRACION.lstMigraArcgalType;

    lnContadorArcgae number;
    lnContadorArcgal number;

    type lstMigraIdsType is table of number(12);
    lstMigraIds lstMigraIdsType;

    CURSOR cObtenerInfoMigraArcgae(Cn_IdMigracion NUMBER, Cv_Nocia VARCHAR2) IS
    select a.no_cia, a.ano, a.mes, a.no_asiento, a.impreso, a.fecha, a.descri1,
    a.estado, a.autorizado, a.origen, a.t_debitos, a.t_creditos, a.cod_diario, a.t_camb_c_v, a.tipo_cambio,
    a.tipo_comprobante, a.numero_ctrl, a.anulado, a.usuario_creacion, a.transferido, a.fecha_creacion, a.usuario_procesa, a.fecha_procesa,
    a.detalle_error, a.id_forma_pago, a.id_oficina_facturacion, a.id_migracion from naf47_tnet.migra_arcgae a where a.id_migracion = Cn_IdMigracion and a.no_cia = Cv_Nocia;

    CURSOR cObtenerInfoMigraArcgalLinea(Cn_IdMigracion NUMBER, Cv_Nocia VARCHAR2) IS
    select MAX(NO_LINEA) AS LINEA from naf47_tnet.migra_arcgal a where a.migracion_id = Cn_IdMigracion and a.no_cia = Cv_Nocia;

    CURSOR cObtenerInfoMigraArcgal(Cn_IdMigracion NUMBER, Cv_Nocia VARCHAR2) IS
    select a.no_cia, a.ano, a.mes, a.no_asiento, a.no_linea, a.cuenta, a.descri, a.no_docu,
    a.cod_diario, a.moneda, a.tipo_cambio, a.fecha, a.monto, a.centro_costo, a.tipo,
    a.monto_dol, a.cc_1, a.cc_2, a.cc_3, a.codigo_tercero, a.linea_ajuste_precision, a.transferido, a.migracion_id from naf47_tnet.migra_arcgal a where a.migracion_id = Cn_IdMigracion and a.no_cia = Cv_Nocia;

    Pn_MontoTotalArcgae NAF47_TNET.MIGRA_ARCGAE.T_CREDITOS%TYPE;
    P_Linea cObtenerInfoMigraArcgalLinea%ROWTYPE;

    idx number;
    --------------------------------------------------------------------

    --Tablas ed contabilidad
    Lr_MigraArcgae            NAF47_TNET.MIGRA_ARCGAE%ROWTYPE;
    Lr_MigraArcgal            NAF47_TNET.MIGRA_ARCGAL%ROWTYPE;
    Lr_DocAsociado            NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE := NULL;
    Pn_Monto                  INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Pn_MontoComp              INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Lv_PlantillaDescripcion   ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE;
    Lv_DescPlantillaAjuste    ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE;
    Ln_Monto                  INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

    --Recorridos de arreglos
    Pn_OficinaIdx             DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
    Ln_ProductoIdx            DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
    Ln_DocumentoIdx           INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Pn_LineaIdx               NUMBER;
    Ln_TotalOficinaImpIdx     NUMBER;
    Ln_IdImpuesto             DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE;

    --Para el manejo de la fecha
    Ld_FeCreacion             DATE;

    --Para manejo de errores
    Pv_MsnError               VARCHAR2(3000);

    --Proceso masivo
    Lr_InfoProcesoMasivoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;

    --Prueba
    --Cr_Productos              TypeDetalleProductos;

    --Glosa contable
    Lv_FormatoGlosa           ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_GLOSA%TYPE;
    Lv_FormatoNoAsiento       ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_NO_DOCU_ASIENTO%TYPE;

    --Fechas
    Lv_Anio                   VARCHAR2(1000);
    Lv_Mes                    VARCHAR2(1000);
    Pv_PosicionRestaComp      VARCHAR2(1);

    --Plantilla
    Cr_PlantillaCab           SYS_REFCURSOR;
    Cr_PlantillaDet           SYS_REFCURSOR;
    Cr_InfoDocumento          SYS_REFCURSOR;
    Cr_PlantillaCabAjuste     SYS_REFCURSOR;
    --
    Le_Error                  EXCEPTION;
    --

    cursor cObtenerDocumentosAsociados(cnTipoDocMigracion naf47_tnet.MIGRA_DOCUMENTO_ASOCIADO.tipo_doc_migracion%type,
                                       cnMigracionId naf47_tnet.MIGRA_DOCUMENTO_ASOCIADO.migracion_id%type,
                                       cnTipoMigracion naf47_tnet.MIGRA_DOCUMENTO_ASOCIADO.tipo_migracion%type,
                                       cnCia naf47_tnet.MIGRA_DOCUMENTO_ASOCIADO.no_cia%type,
                                       cnEstado naf47_tnet.MIGRA_DOCUMENTO_ASOCIADO.estado%type,
                                       cnUsuarioCreacion naf47_tnet.MIGRA_DOCUMENTO_ASOCIADO.usr_creacion%type,
                                       cnOficina db_financiero.INFO_DOCUMENTO_FINANCIERO_CAB.oficina_id%type,
                                       cvUUID varchar2) is
      select distinct a.id_documento DOCUMENTO_ORIGEN_ID, 
             cnTipoDocMigracion TIPO_DOC_MIGRACION ,--
             cnMigracionId MIGRACION_ID, --
             cnTipoMigracion TIPO_MIGRACION,--
             cnCia NO_CIA, 
             '' as forma_pago_id, 
             '' as tipo_documento_id, 
             cnEstado ESTADO, 
             cnUsuarioCreacion USR_CREACION, 
             sysdate FE_CREACION, 
             null USR_ULT_MOD, 
             null FE_ULT_MOD 
        from db_financiero.info_tmp_productos a 
       where a.oficina_id = cnOficina
         and a.uuid = cvUUID;

    cursor cObtenerSecuenciasDocs(Cv_Uuid DB_FINANCIERO.INFO_TMP_PRODUCTOS.UUID%TYPE, Cv_OficinaID DB_FINANCIERO.INFO_TMP_PRODUCTOS.OFICINA_ID%TYPE) IS
    select distinct a.id_documento, b.secuencia, a.estado_impresion_fact
     from INFO_TMP_PRODUCTOS a, INFO_TMP_SECUENCIA_DOCS b
     LEFT JOIN INFO_DOCUMENTO_HISTORIAL hist ON hist.ID_DOCUMENTO_HISTORIAL = b.secuencia
     where a.uuid = b.uuid
        and a.id_documento = b.id_documento
        and a.uuid = Cv_Uuid and a.oficina_id = Cv_OficinaID
        AND hist.ID_DOCUMENTO_HISTORIAL IS null;   

    listaDocumentosAsociados NAF47_TNET.GEK_MIGRACION.lstDocumentosAsociadosType;
    lstSecuenciaDocumentos DB_FINANCIERO.FNCK_TRANSACTION.lstSecuenciaDocumentosType;

    Ln_PlantillaIndice NUMBER;
    Ln_PlantillaDetIndice NUMBER;

    Ln_IdMigracion33 naf47_tnet.migra_arcgae.id_migracion%type;
    Ln_IdMigracion18 naf47_tnet.migra_arcgae.id_migracion%type;

    lst_map_idMigracion lst_map_idMigracionType;

    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;

  BEGIN
      --carga parametros de ecuanet
      Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      --
      --
      P_LISTADO_POR_OFICINA(Pv_CodEmpresa,
                            Cr_ProductosFacturados,
                            Pt_Fe_Actual,
                            Pv_CodigoTipoDocumento,
                            Cr_OficinasFacturado,
                            Pr_Documentos);

      --Ubicacion de la posicion de la cuenta de clientes por oficina
      Pv_PosicionRestaComp := '';

      --Ya tengo las oficinas que se procesaron o se procesaran debo recorrer
      --y enviar los parametros que quien se va a totalizar
      Pn_OficinaIdx        := Cr_OficinasFacturado.FIRST;

      --inicializacion de arreglos para arcgae y arcgal
      IF Pv_TipoProceso = 'MASIVO' THEN
        lstMigraArcgae := NAF47_TNET.GEK_MIGRACION.lstMigraArcgaeType();
        lstMigraArcgal := NAF47_TNET.GEK_MIGRACION.lstMigraArcgalType();
        lstMigraIds := lstMigraIdsType();
        lnContadorArcgae := 0;
        lnContadorArcgal := 0;
      END IF;

      LOOP
        EXIT WHEN Pn_OficinaIdx IS NULL;
        --Solo se barre internamente la oficina enviada, ya devuelve el type no se debe hacer FETCH
        P_TOTALIZANDO_POR_OFICINA(Cr_OficinasFacturado,Pn_OficinaIdx,Pn_ValorTotal);
        --
        --
        Ln_TotalOficinaImpIdx      := Pn_ValorTotal.FIRST;
        LOOP
          EXIT WHEN Ln_TotalOficinaImpIdx IS NULL;

          --Cuando ya tengo totalizado y se que va a tener de detalles puedo consultar la respectiva plantilla
          IF( ROUND(Pn_ValorTotal(Ln_TotalOficinaImpIdx).IVA, 2) > 0 ) OR Pv_Prefijo IN ('MD','EN') THEN
            Pn_FlatIva:='S';
          ELSE
            Pn_FlatIva:='N';
          END IF;

          --Antes de eso debo generar el nombre de la plantilla segun los parametros enviados
          Lv_PlantillaDescripcion:=F_GENERAR_NOMBRE_PLANTILLA(Pv_CodigoTipoDocumento,Pv_TipoProceso,Pn_FlatIva);
          --
          P_OBTENER_PLANTILLA_CAB(Pv_CodigoTipoDocumento,Lv_PlantillaDescripcion,Pv_CodEmpresa,Cr_PlantillaCab);
          FETCH Cr_PlantillaCab BULK COLLECT INTO Lc_Plantilla;
          Ln_PlantillaIndice := Lc_Plantilla.FIRST;

          --Obtengo la data de la plantilla
          Lv_CodDiario:= Lc_Plantilla(Ln_PlantillaIndice).COD_DIARIO;

          --Cuando el totalizado no existe, no debe crear cabecera
          IF (Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL>0)THEN

            --Leyendo la plantilla, segun el proceso
            IF Lc_Plantilla(Ln_PlantillaIndice).TABLA_CABECERA='MIGRA_ARCGAE' THEN

              IF Pv_TipoProceso='INDIVIDUAL' THEN
                --Data por individual
                O_OBTENER_DATA_DOCUMENTO(Pv_IdDocumento,Cr_InfoDocumento);
                FETCH Cr_InfoDocumento INTO LrInfoDocumento;
                P_SPLIT(TO_CHAR(LrInfoDocumento.FE_AUTORIZACION),'-',Pr_Arreglo);
                Lv_Anio         :=  Pr_Arreglo(0);
                Lv_Mes          :=  Pr_Arreglo(1);
                Ld_FeCreacion   :=  TO_DATE(LrInfoDocumento.FE_AUTORIZACION,'YYYY-MM-DD');
                Lv_UsrCreacion  :=  LrInfoDocumento.USR_CREACION;
                Lv_NoAsiento    :=  Pv_IdDocumento;
              ELSIF (Pv_TipoProceso='MASIVO' OR Pv_TipoProceso='ANULACION-FAC') THEN
                P_SPLIT(Pt_Fe_Actual,'-',Pr_Arreglo);
                Lv_Anio         :=  Pr_Arreglo(0);
                Lv_Mes          :=  Pr_Arreglo(1);
                Ld_FeCreacion   :=  TO_DATE(Pt_Fe_Actual,'YYYY-MM-DD');
                Lv_UsrCreacion  :=  'telcos';
              END IF;
              --
              Lv_FormatoGlosa:=Lc_Plantilla(Ln_PlantillaIndice).FORMATO_GLOSA;
              Lv_FormatoNoAsiento:=Lc_Plantilla(Ln_PlantillaIndice).FORMATO_NO_DOCU_ASIENTO;
              --
              P_GENERAR_DESCRIPCION(
                Lv_FormatoGlosa,
                TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
                Cr_OficinasFacturado(Pn_OficinaIdx).NOMBRE_OFICINA,
                LrInfoDocumento.LOGIN,
                NULL,
                Lv_Descripcion
              );

              P_GENERAR_NO_ASIENTO(
                Lv_FormatoNoAsiento,
                TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
                Pv_IdDocumento,
                Pn_OficinaIdx,
                Lv_NoAsiento
              );

              --Altera por ejecucion de masivo e individual, para diferencia el asiento segun el IVA
              IF (Pv_TipoProceso='MASIVO' OR Pv_TipoProceso='ANULACION-FAC') THEN
                Lv_NoAsiento := Lv_NoAsiento || Pn_ValorTotal(Ln_TotalOficinaImpIdx).IMPUESTO_ID;
              END IF;

              Lr_MigraArcgae.NO_CIA           := Pv_CodEmpresa;
              --*jilces::cambio por nueva compa�ia ecuanet, se usa la misma secuencia de megadatos
              --*debido a que en futuro se migrara los registros de ecuanet a megadatos
              IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                Lr_MigraArcgae.Id_Migracion     := NAF47_TNET.TRANSA_ID.MIGRA_CG (Lv_EmpresaOrigen);
                Ln_IdMigracion33 := Lr_MigraArcgae.Id_Migracion;
                Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CG (Lv_EmpresaDestino);
              ELSE
                Lr_MigraArcgae.Id_Migracion     := NAF47_TNET.TRANSA_ID.MIGRA_CG (Pv_CodEmpresa);
              END IF;

              Lr_MigraArcgae.Id_Oficina_Facturacion :=  Pn_OficinaIdx;
              Lr_MigraArcgae.ANO              :=  Lv_Anio;
              Lr_MigraArcgae.MES              :=  Lv_Mes;
              Lr_MigraArcgae.FECHA            :=  Ld_FeCreacion;
              Lr_MigraArcgae.NO_ASIENTO       :=  Lv_NoAsiento;
              Lr_MigraArcgae.DESCRI1          :=  Lv_Descripcion;
              Lr_MigraArcgae.ESTADO           := 'P';
              Lr_MigraArcgae.AUTORIZADO       := 'N';
              Lr_MigraArcgae.ORIGEN           := 'CG';
              Lr_MigraArcgae.T_DEBITOS        :=  ROUND(Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL,2);
              Lr_MigraArcgae.T_CREDITOS       :=  ROUND(Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL,2);
              Lr_MigraArcgae.COD_DIARIO       :=  Lv_CodDiario;
              Lr_MigraArcgae.T_CAMB_C_V       := 'C';
              Lr_MigraArcgae.TIPO_CAMBIO      := '1';
              Lr_MigraArcgae.TIPO_COMPROBANTE := 'T';
              Lr_MigraArcgae.ANULADO          := 'N';
              Lr_MigraArcgae.USUARIO_CREACION :=  Lv_UsrCreacion;
              Lr_MigraArcgae.TRANSFERIDO      := 'N';
              Lr_MigraArcgae.FECHA_CREACION   :=  SYSDATE;

              --DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_MIGRA_ARCGAE(Lr_MigraArcgae,Pv_MsnError);
              IF Pv_TipoProceso NOT IN ('MASIVO') THEN
                 NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae,Pv_MsnError);

                 IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                   declare
                    Ln_OficinaMap DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
                   begin

                     select id_oficina INTO Ln_OficinaMap
                      from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                     where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                 from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                where a.id_oficina = Pn_OficinaIdx);

                     Lr_MigraArcgae.Id_Migracion := Ln_IdMigracion18;
                     Lr_MigraArcgae .NO_CIA := Lv_EmpresaDestino;
                     Lr_MigraArcgae.Id_Oficina_Facturacion :=  Ln_OficinaMap;

                     NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae,Pv_MsnError);

                     Lr_MigraArcgae.Id_Oficina_Facturacion :=  Pn_OficinaIdx;
                     Lr_MigraArcgae.Id_Migracion := Ln_IdMigracion33;
                     Lr_MigraArcgae .NO_CIA := Pv_CodEmpresa;
                   end; 
                 END IF;

              ELSE
                 lstMigraArcgae.extend;
                 lnContadorArcgae := lnContadorArcgae + 1;
                 lstMigraArcgae(lnContadorArcgae) := Lr_MigraArcgae;
                 lstMigraIds.extend;
                 lstMigraIds(lnContadorArcgae) := Lr_MigraArcgae.Id_Migracion;

                 IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                   lst_map_idMigracion(Ln_IdMigracion33) := Ln_IdMigracion18;
                 END IF;
              END IF;
              --
              IF Pv_MsnError IS NOT NULL THEN
                Raise Le_Error;
              END IF;

              --
              --Leyendo detalle de plantilla, segun proceso
              --Cuando tengo la plantillaDet, busco sus cuentas contable enlazadas
              Pn_LineaIdx :=  0;

              P_OBTENER_PLANTILLA_DET(Lc_Plantilla(Ln_PlantillaIndice).ID_PLANTILLA_CONTABLE_CAB,Cr_PlantillaDet);
              FETCH CR_PLANTILLADET BULK COLLECT INTO Lc_PlantillaDet;

              Ln_PlantillaDetIndice := Lc_PlantillaDet.FIRST;

              LOOP 
                EXIT WHEN Ln_PlantillaDetIndice IS NULL;

                --Valores fijos
                Lr_MigraArcgal.NO_CIA                 :=  Pv_CodEmpresa;
                Lr_MigraArcgal.MIGRACION_ID           :=  Lr_MigraArcgae.Id_Migracion;
                Lr_MigraArcgal.ANO                    :=  Lv_Anio;
                Lr_MigraArcgal.MES                    :=  Lv_Mes;
                Lr_MigraArcgal.NO_ASIENTO             :=  SUBSTR(Lv_NoAsiento,1,12);
                Lr_MigraArcgal.NO_LINEA               :=  Pn_LineaIdx;
                Lr_MigraArcgal.DESCRI                 :=  Lv_Descripcion;
                Lr_MigraArcgal.COD_DIARIO             :=  Lv_CodDiario;
                Lr_MigraArcgal.MONEDA                 :=  'P';
                Lr_MigraArcgal.TIPO_CAMBIO            :=  '1';
                Lr_MigraArcgal.FECHA                  :=  Ld_FeCreacion;
                Lr_MigraArcgal.CENTRO_COSTO           :=  '000000000';
                Lr_MigraArcgal.TIPO                   :=  Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION;
                Lr_MigraArcgal.CC_1                   :=  '000';
                Lr_MigraArcgal.CC_2                   :=  '000';
                Lr_MigraArcgal.CC_3                   :=  '000';
                Lr_MigraArcgal.LINEA_AJUSTE_PRECISION :=  'N';
                Lr_MigraArcgal.TRANSFERIDO            :=  'N';

                --Campo referenciales
                Pn_Monto                 := 0;
                Pv_CampoReferencial      := NULL;
                Pv_ValorCampoReferencial := NULL;
                Ln_IdImpuesto            := NULL;

                IF(Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE='CLIENTES') THEN
                  Pv_CampoReferencial         := 'ID_OFICINA';
                  Pv_ValorCampoReferencial    := Pn_OficinaIdx;
                  Pn_Monto                    := ROUND(Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL,2);
                  --Debido a la modificacion de los valores correspondientes al cliente debemos conservar su posicion
                  Pv_PosicionRestaComp        := Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION;
                ELSIF (Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE='IVA') THEN
                  Pv_CampoReferencial         := 'ID_IMPUESTO';
                  --Actualmente es el impuesto variable, se obtiene de la obtiene mediante el procesamiento
                  Ln_IdImpuesto               := Pn_ValorTotal(Ln_TotalOficinaImpIdx).IMPUESTO_ID;
                  Pv_ValorCampoReferencial    := Ln_IdImpuesto;
                  Pn_Monto                    := ROUND(Pn_ValorTotal(Ln_TotalOficinaImpIdx).IVA,2);
                ELSIF (Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE='ICE') THEN
                  Pv_CampoReferencial         := 'ID_IMPUESTO';
                  Ln_IdImpuesto               := F_OBTENER_IMPUESTO('ICE');
                  Pv_ValorCampoReferencial    := Ln_IdImpuesto;
                  Pn_Monto                    := ROUND(Pn_ValorTotal(Ln_TotalOficinaImpIdx).ICE,2);
                ELSIF (Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE='PRODUCTOS' OR Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE='PRODUCTOS_NC') THEN
                  Pv_CampoReferencial         := 'ID_PRODUCTO';
                ELSIF (Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE IN ('PORTADOR', 'PORTADOR_NC', 'SERVICIO')) THEN
                  Pv_CampoReferencial         := 'ID_PORTADOR';
                  Pv_ValorCampoReferencial    := Pn_OficinaIdx;
                ELSIF (Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE='COMPENSACION_SOLIDARIA' AND Pv_DescripcionImpuesto='COMPENSACION 2%')  THEN
                  Pv_CampoReferencial         := 'ID_IMPUESTO';
                  Ln_IdImpuesto               := F_OBTENER_IMPUESTO('COM');
                  Pv_ValorCampoReferencial    := Ln_IdImpuesto;
                  --Funcion para la sumatoria de los valores compensados
                  Pn_Monto                    := F_OBTENER_COM_SOLIDARIA(Pt_Fe_Actual,Pn_OficinaIdx,Pv_CodEmpresa,Pv_TipoProceso,Pv_CodigoTipoDocumento);
                END IF;

                --Proceso segun el tipo de detalle
                IF(Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_DETALLE='FIJO')THEN
                  IF(Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE NOT IN ('PORTADOR', 'PORTADOR_NC', 'SERVICIO'))THEN

                    P_OBTENER_CUENTA_CONTABLE(Pv_CodEmpresa,
                                              Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE,
                                              Pv_CampoReferencial,
                                              Pv_ValorCampoReferencial,
                                              Pn_OficinaIdx,
                                              Cr_CtaContable,
                                              Cr_NoCta);
                    --
                    Pn_LineaIdx :=  Pn_LineaIdx+1;
                    --Segun el tipo modificamos lo siguiente
                    Lr_MigraArcgal.NO_LINEA   :=  Pn_LineaIdx;
                    Lr_MigraArcgal.CUENTA     :=  Cr_CtaContable;
                    --Insertando | Guardo los montos correspondientes
                    P_POSICION_VALOR(Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION,Pn_Monto);
                    Lr_MigraArcgal.MONTO      :=  Pn_Monto;
                    Lr_MigraArcgal.MONTO_DOL  :=  Pn_Monto;

                    --Insertando | Se valida que el monto a guardar sea mayor a cero
                    IF(Pn_Monto<>0) THEN
                       --DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);
                       IF Pv_TipoProceso NOT IN ('MASIVO') THEN
                          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);

                          IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                            Lr_MigraArcgal .NO_CIA                 :=  Lv_EmpresaDestino;
                            Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion18;

                            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);

                            Lr_MigraArcgal .NO_CIA                 :=  Pv_CodEmpresa;
                            Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion33;
                          END IF;

                       ELSE
                          lstMigraArcgal.extend;
                          lnContadorArcgal := lnContadorArcgal + 1;
                          lstMigraArcgal(lnContadorArcgal) := Lr_MigraArcgal;
                       END IF;
                       --
                       IF Pv_MsnError IS NOT NULL THEN
                         Raise Le_Error;
                       END IF;
                    END IF;

                    --Si estoy en la linea de la compensacion se debe restar a la cuenta de clientes el valor de la compensacion solidaria
                    IF (Pv_DescripcionImpuesto='COMPENSACION 2%')  THEN
                      --
                      Pn_MontoComp:= ROUND(Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL,2)-ABS(Pn_Monto);
                      --Posicion del valor correspondiente negativo | positivo
                      P_POSICION_VALOR(Pv_PosicionRestaComp,Pn_MontoComp);
                      --
                      UPDATE_COMP_SOLIDARIA(Pv_CodEmpresa,Lv_Anio,Lv_Mes,SUBSTR(Lv_NoAsiento,1,12),Pn_MontoComp);
                      --
                    END IF;


                  ELSE
                    --Proceso para el llenado de la variable Pv_ValorCampoReferencial
                    Ln_ProductoIdx := Cr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS.FIRST;
                    LOOP
                      EXIT WHEN Ln_ProductoIdx IS NULL;
                      --llindao: solo debe recuperar los montos de producto x oficina de acuerdo al impuesto id
                      --
                      IF Cr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).IMPUESTO_ID = 
                        Pn_ValorTotal(Ln_TotalOficinaImpIdx).IMPUESTO_ID THEN
                        --
                        --
                        P_OBTENER_CUENTA_CONTABLE(Pv_CodEmpresa,
                                                Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE,
                                                Pv_CampoReferencial,
                                                Pv_ValorCampoReferencial,
                                                Pn_OficinaIdx,
                                                Cr_CtaContable,
                                                Cr_NoCta);

                        Pn_LineaIdx :=  Pn_LineaIdx+1;
                        --Segun el tipo modificamos lo siguiente
                        Lr_MigraArcgal.NO_LINEA   :=  Pn_LineaIdx;
                        Lr_MigraArcgal.CUENTA     :=  Cr_CtaContable;
                        Pn_Monto  :=(Cr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).TOTAL*Lc_PlantillaDet(Ln_PlantillaDetIndice).PORCENTAJE)/100;
                        P_POSICION_VALOR(Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION,Pn_Monto);
                        ---Guardo los montos correspondientes
                        Lr_MigraArcgal.MONTO      :=  Pn_Monto;
                        Lr_MigraArcgal.MONTO_DOL  :=  Pn_Monto;
                        -- Para MD en PORTADOR y SERVICIO solo estan configurados los Productos Instalacion, Soporte, Traslado y Reubicaci�n
                        IF (Pv_Prefijo = 'TN') OR (Cr_CtaContable IS NOT NULL AND Pv_Prefijo in ('MD','EN')) THEN
                          --Insertando | Se valida que el monto a guardar sea mayor a cero
                          IF(Pn_Monto<>0) THEN
                            --DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);
                            IF Pv_TipoProceso NOT IN ('MASIVO') THEN
                               NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);
                               IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                                  Lr_MigraArcgal .NO_CIA                 :=  Lv_EmpresaDestino;
                                  Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion18;

                                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);

                                  Lr_MigraArcgal .NO_CIA                 :=  Pv_CodEmpresa;
                                  Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion33;
                                END IF;

                            ELSE
                              lstMigraArcgal.extend;
                              lnContadorArcgal := lnContadorArcgal + 1;
                              lstMigraArcgal(lnContadorArcgal) := Lr_MigraArcgal;
                            END IF;
                            --
                            IF Pv_MsnError IS NOT NULL THEN
                              Raise Le_Error;
                           END IF;
                          END IF;
                        END IF;
                        --
                      END IF;
                      --Avanzo a otro producto
                      Ln_ProductoIdx:=Cr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS.next(Ln_ProductoIdx);
                    END LOOP;

                  END IF;
                ELSIF(Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_DETALLE='VARIABLE')THEN
                  --Proceso para el llenado de la variable Pv_ValorCampoReferencial
                  Ln_ProductoIdx := Cr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS.FIRST;
                  LOOP
                    EXIT WHEN Ln_ProductoIdx IS NULL;
                    --
                    --llindao: solo debe recuperar los montos de producto x oficina de acuerdo al impuesto id
                    IF Cr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).IMPUESTO_ID = Pn_ValorTotal(Ln_TotalOficinaImpIdx).IMPUESTO_ID THEN
                      --
                      --
                      Pv_ValorCampoReferencial:=Ln_ProductoIdx;
                      P_OBTENER_CUENTA_CONTABLE(Pv_CodEmpresa,
                                                Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE,
                                                Pv_CampoReferencial,
                                                Pv_ValorCampoReferencial,
                                                Pn_OficinaIdx,
                                                Cr_CtaContable,
                                                Cr_NoCta);
                      --
                      --
                      Pn_LineaIdx :=  Pn_LineaIdx+1;
                      -- Si es servicio y no recupera cuenta debe cntinuar ahsta que encuentre
                      IF Cr_CtaContable IS NOT NULL OR (Cr_CtaContable IS NULL AND Pv_Prefijo NOT IN ('MD','EN')) THEN
                        --Segun el tipo modificamos lo siguiente
                        Lr_MigraArcgal.NO_LINEA   :=  Pn_LineaIdx;
                        Lr_MigraArcgal.CUENTA     :=  Cr_CtaContable;
                        Pn_Monto  :=(Cr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS(Ln_ProductoIdx).TOTAL*Lc_PlantillaDet(Ln_PlantillaDetIndice).PORCENTAJE)/100;
                        P_POSICION_VALOR(Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION,Pn_Monto);
                        ---Guardo los montos correspondientes
                        Lr_MigraArcgal.MONTO      :=  Pn_Monto;
                        Lr_MigraArcgal.MONTO_DOL  :=  Pn_Monto;
                        --
                        --Insertando | Se valida que el monto a guardar sea mayor a cero
                        IF (Pn_Monto<>0) THEN
                          --DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);
                          IF Pv_TipoProceso NOT IN ('MASIVO') THEN
                             NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);
                             IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                              Lr_MigraArcgal .NO_CIA                 :=  Lv_EmpresaDestino;
                              Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion18;

                              NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);

                              Lr_MigraArcgal .NO_CIA                 :=  Pv_CodEmpresa;
                              Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion33;
                            END IF;
                          ELSE
                             lstMigraArcgal.extend;
                             lnContadorArcgal := lnContadorArcgal + 1;
                             lstMigraArcgal(lnContadorArcgal) := Lr_MigraArcgal;
                          END IF;
                          --
                          IF Pv_MsnError IS NOT NULL THEN
                             Raise Le_Error;
                          END IF;
                        END IF;
                        --
                      END IF;
                      --
                    END IF;
                    --Avanzo a otro producto
                    Ln_ProductoIdx:=Cr_OficinasFacturado(Pn_OficinaIdx).PRODUCTOS.next(Ln_ProductoIdx);
                  END LOOP;

                END IF;
                Ln_PlantillaDetIndice := Lc_PlantillaDet.next(Ln_PlantillaDetIndice);
              END LOOP;

              CLOSE Cr_PlantillaDet;

              --
              -- Verificacion de Asiento descuadrado
              -- aqui validar si asiento contable cuadra
              IF Pv_TipoProceso NOT IN ('MASIVO') THEN
              IF C_ASIENTO_CONTABLE%ISOPEN THEN
                CLOSE C_ASIENTO_CONTABLE;
              END IF;
              OPEN C_ASIENTO_CONTABLE(Lr_MigraArcgae.Id_Migracion, 
                                      Lr_MigraArcgae.No_Cia) ;
              FETCH C_ASIENTO_CONTABLE INTO Lr_AsientoContable;
              IF C_ASIENTO_CONTABLE%NOTFOUND THEN
                Lr_AsientoContable.MONTO := 0;
              END IF;
              CLOSE C_ASIENTO_CONTABLE;
              --
              -- si existe descuadre se debe ejecutar ajuste.
              IF NVL(Lr_AsientoContable.MONTO, 0) != 0 THEN
                --
                Cr_PlantillaCabAjuste := NULL;
                --
                Lv_DescPlantillaAjuste := F_GENERAR_NOMBRE_PLANTILLA( Pv_CodigoTipoDocumento,
                                                                      'AJUSTE POR REDONDEO',
                                                                      NULL);
                --
                P_OBTENER_PLANTILLA_CAB(Pv_CodigoTipoDocumento,Lv_DescPlantillaAjuste,Pv_CodEmpresa,Cr_PlantillaCabAjuste);
                FETCH Cr_PlantillaCabAjuste BULK COLLECT INTO Lc_Plantilla;
                --
                  Ln_PlantillaIndice := Lc_Plantilla.FIRST;
                  --
                Cr_PlantillaDet := NULL;
                --
                P_OBTENER_PLANTILLA_DET(Lc_Plantilla(Ln_PlantillaIndice).ID_PLANTILLA_CONTABLE_CAB, Cr_PlantillaDet);
                  FETCH Cr_PlantillaDet BULK COLLECT INTO Lc_PlantillaDet;

                  Ln_PlantillaDetIndice := Lc_PlantillaDet.FIRST;

                  LOOP
                    /*FETCH Cr_PlantillaDet INTO Lc_PlantillaDet.TIPO_CUENTA_CONTABLE, Lc_PlantillaDet.DESCRIPCION, Lc_PlantillaDet.POSICION,
                    Lc_PlantillaDet.TIPO_DETALLE, Lc_PlantillaDet.FORMATO_GLOSA, Lc_PlantillaDet.PORCENTAJE;*/
                    EXIT WHEN Ln_PlantillaDetIndice IS NULL;
                  --
                  IF (Lr_AsientoContable.NATURALEZA_DOCUMENTO = 'C' AND Lr_AsientoContable.MONTO > 0 AND Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION = Lr_AsientoContable.NATURALEZA_DOCUMENTO) OR
                     (Lr_AsientoContable.NATURALEZA_DOCUMENTO = 'C' AND Lr_AsientoContable.MONTO < 0 AND Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION = 'D' ) OR
                     (Lr_AsientoContable.NATURALEZA_DOCUMENTO = 'D' AND Lr_AsientoContable.MONTO > 0 AND Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION = 'C') OR
                     (Lr_AsientoContable.NATURALEZA_DOCUMENTO = 'D' AND Lr_AsientoContable.MONTO < 0 AND Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION = Lr_AsientoContable.NATURALEZA_DOCUMENTO) THEN
                    --
                    --
                    P_OBTENER_CUENTA_CONTABLE ( Pv_CodEmpresa,
                      Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE,
                      'ID_OFICINA',
                      Pn_OficinaIdx,
                      Pn_OficinaIdx,
                      Cr_CtaContable,
                      Cr_NoCta);
                    --
                    --
                    Pn_LineaIdx :=  Pn_LineaIdx+1;
                    Lr_MigraArcgal.NO_LINEA   :=  Pn_LineaIdx;
                    Lr_MigraArcgal.CUENTA     :=  Cr_CtaContable;
                    Lr_MigraArcgal.TIPO       :=  Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION;
                    --
                    Pn_Monto := ABS(Lr_AsientoContable.monto);
                    --
                    P_POSICION_VALOR(Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION, Pn_Monto);
                    ---Guardo los montos correspondientes
                    Lr_MigraArcgal.MONTO      :=  Pn_Monto;
                    Lr_MigraArcgal.MONTO_DOL  :=  Pn_Monto;
                    --
                    Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL := NVL(Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL,0) + Pn_Monto;
                    --Insertando | Se valida que el monto a guardar sea mayor a cero
                    IF (Pn_Monto<>0) THEN
                      --DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);
                      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL (Lr_MigraArcgal,Pv_MsnError);

                      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                            Lr_MigraArcgal .NO_CIA                 :=  Lv_EmpresaDestino;
                            Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion18;

                            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);

                            Lr_MigraArcgal .NO_CIA                 :=  Pv_CodEmpresa;
                            Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion33;
                          END IF;
                      --
                      IF Pv_MsnError IS NOT NULL THEN
                         Raise Le_Error;
                      END IF;
                      END IF;
                    END IF;
				Ln_PlantillaDetIndice := Lc_PlantillaDet.next(Ln_PlantillaDetIndice);
                END LOOP;
                --
                CLOSE Cr_PlantillaDet;
                CLOSE Cr_PlantillaCabAjuste;
                --
                -- se refleja el ajuste en la cabecera del asiento contable
                UPDATE NAF47_TNET.MIGRA_ARCGAE
                SET T_DEBITOS = Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL,
                    T_CREDITOS = Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL
                WHERE ID_MIGRACION = Lr_MigraArcgae.Id_Migracion
                AND NO_CIA = Lr_MigraArcgae.No_Cia;

                IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                  UPDATE NAF47_TNET.MIGRA_ARCGAE
                SET T_DEBITOS = Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL,
                    T_CREDITOS = Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL
                WHERE ID_MIGRACION = Ln_IdMigracion18
                AND NO_CIA = Lv_EmpresaDestino;
                END IF;

                --
                END IF;
              END IF;

              --Cuando el proceso es "OK" debemos:
              --Crear el proceso masivo si el proceso es MASIVO --> unicamente
              --Marca en la info_doc_fin_cab | CONTABILIZADO ='S'
              --Crear historial de "Proceso de contabilizacion ok"
              IF Pv_MsnError IS NULL AND Pv_TipoProceso NOT IN ('MASIVO') THEN
                --Proceso de actualizar documentos contabilizados
                IF Pv_TipoProceso='INDIVIDUAL' THEN
                  P_MARCAR_CONTABILIZADO(Pv_IdDocumento,Pv_TipoProceso);
                ELSIF (/*Pv_TipoProceso='MASIVO' OR */Pv_TipoProceso='ANULACION-FAC') THEN
                  --Lectura del cursor de los facturados
                  --Generacion del proceso masivo, se neceita el punto_id | documento_id
                  ----Registrando el masivo cab
                  Ln_DocumentoIdx := Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS.FIRST;
                  --
                  LOOP
                    BEGIN
                      EXIT WHEN Ln_DocumentoIdx IS NULL;

                      -- se asigna documento asociado.
                      Lr_DocAsociado.Documento_Origen_Id := Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS(Ln_DocumentoIdx).ID_DOCUMENTO;
                      Lr_DocAsociado.Tipo_Doc_Migracion := Lr_MigraArcgae.Cod_Diario;
                      Lr_DocAsociado.Migracion_Id := Lr_MigraArcgae.Id_Migracion;
                      Lr_DocAsociado.Tipo_Migracion := 'CG';
                      Lr_DocAsociado.No_Cia := Lr_MigraArcgae.No_Cia;
                      Lr_DocAsociado.Estado := 'M';
                      Lr_DocAsociado.Usr_Creacion := Lr_MigraArcgae.Usuario_Creacion;
                      Lr_DocAsociado.Fe_Creacion := sysdate;
                      --
                      NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO (Pr_MigraDocAsociado => Lr_DocAsociado,
                                                                  Pv_TipoProceso => 'I',
                                                                  Pv_MensajeError => Pv_MsnError);
                      --
                      IF Pv_MsnError IS NOT NULL THEN
                        Raise Le_Error;
                      END IF;
                      --
                      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                        Lr_DocAsociado.Migracion_Id := Ln_IdMigracion18;
                        Lr_DocAsociado.No_Cia := Lv_EmpresaDestino;

                        NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO (Pr_MigraDocAsociado => Lr_DocAsociado,
                                                                  Pv_TipoProceso => 'I',
                                                                  Pv_MensajeError => Pv_MsnError);

                        Lr_DocAsociado.Migracion_Id := Ln_IdMigracion33;
                        Lr_DocAsociado.No_Cia := Pv_CodEmpresa;
                      END IF;

                      IF Pv_MsnError IS NOT NULL THEN
                        Raise Le_Error;
                      END IF;
                      -- marca documento como contabilizado
                      P_ACTUALIZA_CONTABILIZADO(Pn_IdDocumento => Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS(Ln_DocumentoIdx).ID_DOCUMENTO,
                                                Pv_EstadoDoc => Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS(Ln_DocumentoIdx).ESTADO,
                                                Pv_TipoProceso => Pv_TipoProceso);

                      Ln_DocumentoIdx:=Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS.next(Ln_DocumentoIdx);
                      --
                    EXCEPTION
                    WHEN OTHERS THEN
                      Pv_MsnError:='Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
                      Raise Le_Error;
                    END;
                  END LOOP;
                  --
                END IF;
              END IF;
            END IF;
          ELSE
            --Informe de error en el proceso
            Pv_MsnError := 'No se contabiliza variable Pn_ValorTotal.TOTAL:'||Pn_ValorTotal(Ln_TotalOficinaImpIdx).TOTAL ||' Pn_OficinaIdx:' ||Pn_OficinaIdx;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
              'TELCOS',
              'DB_FINANCIERO.FNKG_CONTABILIZAR_FACT.P_PROCESAR',
              Pv_MsnError,
              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
              SYSDATE,
              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1')
              );
          END IF;

          --Cierro la plantilla
          CLOSE Cr_PlantillaCab;
          ---
          Ln_TotalOficinaImpIdx := Pn_ValorTotal.NEXT(Ln_TotalOficinaImpIdx);
          --
        END LOOP;
        --Aumento el indice de las oficinas
        Pn_OficinaIdx := Cr_OficinasFacturado.NEXT(Pn_OficinaIdx);
        --       
      END LOOP;
      --
      -----INSERCION EN LAS MIGRAS


      --Proceso de Cuadre y Contabilizacion
       IF Pv_TipoProceso = 'MASIVO' THEN -------- Inicio del if de masivo
         -----INSERCION EN LAS MIGRAS
      IF lstMigraArcgae.COUNT > 0 THEN
        NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE_MASIVO(Pr_MigraArcga => lstMigraArcgae, Pv_MensajeError => Pv_MsnError);

        IF Pv_MsnError IS NOT NULL THEN
          RAISE LE_ERROR;
        ELSE
          IF lstMigraArcgal.COUNT > 0 THEN
            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL_MASIVO(Pr_MigraArcga => lstMigraArcgal, Pv_MensajeError => Pv_MsnError);
            IF Pv_MsnError IS NOT NULL THEN
              RAISE LE_ERROR;
            END IF;
          END IF;
        END IF;
      END IF; 

         idx := lstMigraIds.FIRST;
         ln_secuenciasGeneradas := false;
         BEGIN
           LOOP
             EXIT WHEN idx IS NULL;
             Lr_MigraArcgae := null; 
             OPEN cObtenerInfoMigraArcgae(lstMigraIds(idx), Pv_CodEmpresa);
             FETCH cObtenerInfoMigraArcgae INTO Lr_MigraArcgae;
             CLOSE cObtenerInfoMigraArcgae;

             OPEN cObtenerInfoMigraArcgal(lstMigraIds(idx), Pv_CodEmpresa);
             FETCH cObtenerInfoMigraArcgal INTO Lr_MigraArcgal;
             CLOSE cObtenerInfoMigraArcgal;

             OPEN cObtenerInfoMigraArcgalLinea(lstMigraIds(idx), Pv_CodEmpresa);
             FETCH cObtenerInfoMigraArcgalLinea INTO P_Linea;
             CLOSE cObtenerInfoMigraArcgalLinea;

             IF C_ASIENTO_CONTABLE%ISOPEN THEN
               CLOSE C_ASIENTO_CONTABLE;
             END IF;

             OPEN C_ASIENTO_CONTABLE(Lr_MigraArcgae.Id_Migracion,Lr_MigraArcgae.No_Cia);
             FETCH C_ASIENTO_CONTABLE INTO Lr_AsientoContable;

             IF C_ASIENTO_CONTABLE%NOTFOUND THEN
               Lr_AsientoContable.MONTO := 0;
             END IF;

             CLOSE C_ASIENTO_CONTABLE;

             --
             -- si existe descuadre se debe ejecutar ajuste.
             IF NVL(Lr_AsientoContable.MONTO, 0) != 0 THEN
               --
               Cr_PlantillaCabAjuste := NULL;
               --
               Lv_DescPlantillaAjuste := F_GENERAR_NOMBRE_PLANTILLA(Pv_CodigoTipoDocumento,'AJUSTE POR REDONDEO',NULL);
               --
               P_OBTENER_PLANTILLA_CAB(Pv_CodigoTipoDocumento,
                                       Lv_DescPlantillaAjuste,
                                       Pv_CodEmpresa,
                                       Cr_PlantillaCabAjuste);
               FETCH Cr_PlantillaCabAjuste bulk collect INTO Lc_Plantilla;

               Ln_PlantillaIndice := Lc_Plantilla.FIRST;

               --
               Cr_PlantillaDet := NULL;
               --
               P_OBTENER_PLANTILLA_DET(Lc_Plantilla(Ln_PlantillaIndice).ID_PLANTILLA_CONTABLE_CAB,
                                       Cr_PlantillaDet);

               FETCH Cr_PlantillaDet BULK COLLECT INTO Lc_PlantillaDet;

               Ln_PlantillaDetIndice := Lc_PlantillaDet.FIRST;

               LOOP
                 /*FETCH Cr_PlantillaDet INTO Lc_PlantillaDet.TIPO_CUENTA_CONTABLE, Lc_PlantillaDet.DESCRIPCION, Lc_PlantillaDet.POSICION,
                    Lc_PlantillaDet.TIPO_DETALLE, Lc_PlantillaDet.FORMATO_GLOSA, Lc_PlantillaDet.PORCENTAJE;*/
                 EXIT WHEN Ln_PlantillaDetIndice IS NULL;
                 --
                 IF (Lr_AsientoContable.NATURALEZA_DOCUMENTO = 'C' AND Lr_AsientoContable.MONTO > 0 AND Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION = Lr_AsientoContable.NATURALEZA_DOCUMENTO) OR
                    (Lr_AsientoContable.NATURALEZA_DOCUMENTO = 'C' AND Lr_AsientoContable.MONTO < 0 AND Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION = 'D') OR
                    (Lr_AsientoContable.NATURALEZA_DOCUMENTO = 'D' AND Lr_AsientoContable.MONTO > 0 AND Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION = 'C') OR
                    (Lr_AsientoContable.NATURALEZA_DOCUMENTO = 'D' AND Lr_AsientoContable.MONTO < 0 AND Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION = Lr_AsientoContable.NATURALEZA_DOCUMENTO) THEN
                    --
                    --
                    P_OBTENER_CUENTA_CONTABLE(Pv_CodEmpresa,
                                              Lc_PlantillaDet(Ln_PlantillaDetIndice).TIPO_CUENTA_CONTABLE,
                                              'ID_OFICINA',
                                              Lr_MigraArcgae.Id_Oficina_Facturacion,
                                              Lr_MigraArcgae.Id_Oficina_Facturacion,
                                              Cr_CtaContable,
                                              Cr_NoCta);
                    --
                    --
                    Pn_LineaIdx             := P_Linea.LINEA + 1;--se debe tomar el maximo de la arcgal
                    Lr_MigraArcgal.NO_LINEA := Pn_LineaIdx;
                    Lr_MigraArcgal.CUENTA   := Cr_CtaContable;
                    Lr_MigraArcgal.TIPO     := Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION;
                    --
                    Pn_Monto := ABS(Lr_AsientoContable.monto);
                    --
                    P_POSICION_VALOR(Lc_PlantillaDet(Ln_PlantillaDetIndice).POSICION, Pn_Monto);
                    ---Guardo los montos correspondientes
                    Lr_MigraArcgal.MONTO     := Pn_Monto;
                    Lr_MigraArcgal.MONTO_DOL := Pn_Monto;
                    --
                    Pn_MontoTotalArcgae := NVL(Lr_MigraArcgae.T_CREDITOS,
                                                                            0) + Pn_Monto;
                    --Insertando | Se valida que el monto a guardar sea mayor a cero
                    IF (Pn_Monto <> 0) THEN
                      --DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_MIGRA_ARCGAL(Lr_MigraArcgal,Pv_MsnError);
                      NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal,
                                                                      Pv_MsnError);
                      --
                      IF Pv_MsnError IS NOT NULL THEN
                        Raise Le_Error;
                      END IF;
                    END IF;
                 END IF;
                 Ln_PlantillaDetIndice := Lc_PlantillaDet.next(Ln_PlantillaDetIndice);
               END LOOP;
               --
               CLOSE Cr_PlantillaDet;
               CLOSE Cr_PlantillaCabAjuste;
               --
               -- se refleja el ajuste en la cabecera del asiento contable
               UPDATE NAF47_TNET.MIGRA_ARCGAE
                  SET T_DEBITOS  = Pn_MontoTotalArcgae,
                      T_CREDITOS = Pn_MontoTotalArcgae
                WHERE ID_MIGRACION = Lr_MigraArcgae.Id_Migracion
                  AND NO_CIA = Lr_MigraArcgae.No_Cia;
             END IF;

             --Lectura del cursor de los facturados
             --Generacion del proceso masivo, se neceita el punto_id | documento_id
             ----Registrando el masivo cab  
               OPEN cObtenerDocumentosAsociados(Lr_MigraArcgae.Cod_Diario,
                                                Lr_MigraArcgae.Id_Migracion,
                                                'CG',
                                                Lr_MigraArcgae.No_Cia,
                                                'M',
                                                Lr_MigraArcgae.Usuario_Creacion,
                                                Lr_MigraArcgae.Id_Oficina_Facturacion,
                                                Gv_IdTemporalDocumentos);
               FETCH cObtenerDocumentosAsociados BULK COLLECT INTO listaDocumentosAsociados;
               CLOSE cObtenerDocumentosAsociados;

               IF listaDocumentosAsociados.COUNT > 0 THEN
                 NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOC_mas(Pr_MigraDocAsociado => NULL,
                                                                        Pr_MigraDocAsociadoMas => listaDocumentosAsociados, 
                                                                        Pv_EsProcesoMasivo => TRUE,
                                                                        Pv_TipoProceso => 'I',
                                                                        Pv_MensajeError => Pv_MsnError);

                IF Pv_MsnError IS NOT NULL THEN
                  Raise Le_Error;
               END IF;

               END IF;



               --ACTUALIZACION DE CONTABILIZADO
               if not ln_secuenciasGeneradas then
                 P_GENERA_SECUENCIAS_MASIVO(Gv_IdTemporalDocumentos);
                 ln_secuenciasGeneradas := true;
               end if;


               OPEN cObtenerSecuenciasDocs(Gv_IdTemporalDocumentos, Lr_MigraArcgae.Id_Oficina_Facturacion);
               FETCH cObtenerSecuenciasDocs BULK COLLECT INTO lstSecuenciaDocumentos;
               CLOSE cObtenerSecuenciasDocs;

               P_ACTUALIZA_CONTABILIZADO(Pn_IdDocumento         => NULL,
                                         Pv_EstadoDoc           => NULL,
                                         Pr_DocumentosAsociados => lstSecuenciaDocumentos,
                                         Pv_TipoProceso         => Pv_TipoProceso); 


             idx := lstMigraIds.next(idx);

           END LOOP;
         EXCEPTION
               WHEN OTHERS THEN
                 Pv_MsnError:='Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||chr(13);
                 Raise Le_Error;
         END;

        --- Cambio Delete G: Tabla temporal db_financiero.info_tmp_productos en caso de finalizar proceso
         FNCK_TRANSACTION.P_ELIMINAR_DATA_TEMP_MAS(Pv_IdTmpDatos => Gv_IdTemporalDocumentos, Pv_MsnError => Pv_MsnError);

       END IF;
       -------- Termina del if de masivo

       --replica de contabilizaion de compa�ia EN a MD
       if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen then
          p_replica_informacion(Pv_Cia_Origen => Pv_CodEmpresa, Pv_Cia_Destino => Lv_EmpresaDestino, Pv_CodDIario => Lv_CodDiario, P_lst_mapIdMigracion => lst_map_idMigracion);
       end if;
  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'TELCOS',
        'DB_FINANCIERO.FNKG_CONTABILIZAR_FACT.P_PROCESAR',
        Pv_MsnError,
        NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
        SYSDATE,
        NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1')
        );
        --- Cambio Delete G: Tabla temporal db_financiero.info_tmp_productos en caso de excepciones
        FNCK_TRANSACTION.P_ELIMINAR_DATA_TEMP_MAS(Pv_IdTmpDatos => Gv_IdTemporalDocumentos, Pv_MsnError => Pv_MsnError);

    WHEN OTHERS THEN
      Pv_MsnError :=  'Error ' || SQLERRM || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'TELCOS',
        'DB_FINANCIERO.FNKG_CONTABILIZAR_FACT.P_PROCESAR',
        Pv_MsnError,
        NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
        SYSDATE,
        NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1')
        );
        --- Cambio Delete G: Tabla temporal db_financiero.info_tmp_productos en caso de excepciones
        FNCK_TRANSACTION.P_ELIMINAR_DATA_TEMP_MAS(Pv_IdTmpDatos => Gv_IdTemporalDocumentos, Pv_MsnError => Pv_MsnError);
      ROLLBACK;
  END P_PROCESAR;

  PROCEDURE P_CONTABILIZAR(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  OUT VARCHAR2,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_Fe_Procesar          IN  VARCHAR2, --Utilizado unicamente para la ANULACION-FAC-FE por fecha
    Pv_MsnError             OUT VARCHAR2
  )
  AS
    PRAGMA AUTONOMOUS_TRANSACTION;
    --
    CURSOR C_PARAMETRO_CONTABILIZACION (Cv_DescParametro VARCHAR2) IS
      SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
        DB_GENERAL.ADMI_PARAMETRO_CAB APC
      WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO
      AND APC.NOMBRE_PARAMETRO = FNKG_VAR.Gv_ValidaProcesoContable --Gv_NombreParametro
      AND APC.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO --Gv_EstadoParametro
      AND APD.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO --Gv_EstadoParametro
      AND APD.DESCRIPCION      = Cv_DescParametro
      AND APD.EMPRESA_COD      = Pv_CodEmpresa;

    --Variables para FODATEL
    Pt_Dia_Actual             NUMBER(2);
    Pt_Fe_Emision_Ini         VARCHAR2(100);
    Pt_Fe_Emision_Fin         VARCHAR2(100);
    Pt_Fe_Actual              VARCHAR2(100);
    --
    Cr_ProductosFacturados    SYS_REFCURSOR;
    --
    Lv_ParametroAdicional     VARCHAR2(4000);
    Lv_TipoCuentaContable     VARCHAR2(4000);
    Lv_SubQueryAdicional      VARCHAR2(10000);
    Lv_CodigoTipoDocumento    VARCHAR2(4000);
    Lv_EstadoImpresionFact    VARCHAR2(4000);
    Lv_Contabilizado          VARCHAR2(4000);
    Lv_DescripcionImpuesto    VARCHAR2(4000);
    --
    idx_Masivo                NUMBER(2);
    Ln_CantProd               NUMBER(6) := 0;
    LN_MAX_ITER NUMBER := 3;
    --
    --Cr_Productos              TypeDetalleProductos;
    --
  BEGIN
    /*Proceso:
      --Formato de fecha ejemplo 2016-01-18
      --Invoca a FODATEL segun el tipo INDIVIDUAL | MASIVO
      --Obtener plantilla cabecera por tipo de proceso
      --Obtener plantilla detalle
      --Mediante la plantilla cab, se contra que tablas voy a procesar la cabecera de lo asientos por oficina, para esto ya debo tener los totales por oficina
      --Segun el tipo INDIVIDUAL | MASIVO llamo a las funciones que me devuelven el listado de documentos
      --Con el cursos de totalizado obtengo los valores por oficina y producto
      --Si el proceso de guardar en las tablas migra da "OK", creo el proceso masivo con el listado
        --Guardo la OBSERVACION con el sigt formato "ID_DOCUMENTO: #"
      --Modifico:
        --INFO_DOC_FIN_CAB, el campo CONTABILIZADO
        --INFO_DOC_HISTORIAL, creo regitros de historial de contabilizacion realizadas
    */
    -- se recupera parametro fecha de contabilziaci�n.
    IF C_PARAMETRO_CONTABILIZACION%ISOPEN THEN
      CLOSE C_PARAMETRO_CONTABILIZACION;
    END IF;
    --
    OPEN C_PARAMETRO_CONTABILIZACION('FECHA_CONTABILIZACION');
    FETCH C_PARAMETRO_CONTABILIZACION INTO Gv_TipoFechaCtble;
    CLOSE C_PARAMETRO_CONTABILIZACION;
    --
    IF Gv_TipoFechaCtble IS NULL THEN
      Gv_TipoFechaCtble := FNKG_VAR.Gv_FechaAutoriza;
    END IF;

    -- se recupera parametro numero decimales a usa en contabilziaci�n.
    IF C_PARAMETRO_CONTABILIZACION%ISOPEN THEN
      CLOSE C_PARAMETRO_CONTABILIZACION;
    END IF;
    --
    OPEN C_PARAMETRO_CONTABILIZACION('DECIMALES_CONTABILIZACION');
    FETCH C_PARAMETRO_CONTABILIZACION INTO Gv_Redondear;
    CLOSE C_PARAMETRO_CONTABILIZACION;
   --
    IF Gv_Redondear IS NULL THEN
      Gv_Redondear := 'S'; -- si no se encuentra se aplica valor por defecto
    END IF;

    --
    IF Pv_TipoProceso='INDIVIDUAL' THEN
      FNCK_FACTURACION_DETALLES.P_FACTURACION_DETALLE(Pv_Prefijo,NULL, NULL,'I',Pv_IdDocumento);
    ELSIF (Pv_TipoProceso='MASIVO' OR Pv_TipoProceso='ANULACION-FAC' OR Pv_TipoProceso='ANULACION-FAC-FE') THEN
      --Obtenemos las fechas actuales
      SELECT to_number(TO_CHAR(sysdate-1,'dd')),
        TO_CHAR(trunc(sysdate-1, 'mm'),'DD/MM/YYYY'),
        TO_CHAR(trunc(last_day(sysdate-1)),'DD/MM/YYYY'),
        TO_CHAR(sysdate-1,'YYYY-MM-DD')
      INTO Pt_Dia_Actual,Pt_Fe_Emision_Ini,Pt_Fe_Emision_Fin,Pt_Fe_Actual
      FROM DUAL;

      --Verificacion del dia 1 del proceso del mes siguiente, para procesar las pendientes del dia anterior
      IF Pt_Dia_Actual=1 THEN
        select TO_CHAR(trunc(add_months(sysdate,-1),'MM'),'DD/MM/YYYY') INTO Pt_Fe_Emision_Ini from dual;
      END IF;

      IF (Pv_Fe_Procesar IS NOT NULL) THEN
        --Debemos formatear Pt_Fe_Actual | YYYY-MM-DD
        Pt_Fe_Actual      := Pv_Fe_Procesar;
        Pt_Fe_Emision_Ini := TO_CHAR(TO_DATE(SUBSTR(Pv_Fe_Procesar,1,8)||'01', 'YYYY-MM-DD'),'DD/MM/YYYY');
        Pt_Fe_Emision_Fin := TO_CHAR(LAST_DAY(TO_DATE(SUBSTR(Pv_Fe_Procesar,1,8)||'01', 'YYYY-MM-DD')),'DD/MM/YYYY');
      END IF;

      IF (Pv_TipoProceso='ANULACION-FAC-FE') THEN
        --Debemos reescribir el proceso a Pv_TipoProceso='ANULACION-FAC'
        Pv_TipoProceso := 'ANULACION-FAC';
      END IF;
      -- En reprocesamiento no debe ejecutarse a futuro.
      --Llamada del procedure para el detallado actual que generalmente correspondera al dia anterior procesado
      IF to_char(TO_DATE(Pt_Fe_Actual,'YYYY-MM-DD'), 'MM') = to_char(SYSDATE-1,'MM') THEN
         FNCK_FACTURACION_DETALLES.P_FACTURACION_DETALLE(Pv_Prefijo,Pt_Fe_Emision_Ini, Pt_Fe_Emision_Fin,'A',NULL);
      END IF;
      Gv_FechaProceso := Pt_Fe_Actual;
      --
    END IF;

    --Llamo al proceso especifico por Pv_CodigoTipoDocumento
    IF Pv_TipoProceso='INDIVIDUAL' THEN
      Lv_DescripcionImpuesto:='';
      --
      P_LISTADO_PRODUCTOS_FACT_IND(Pv_CodEmpresa,Pv_IdDocumento,Cr_ProductosFacturados);
      P_PROCESAR(
        Cr_ProductosFacturados,
        Pv_CodEmpresa,
        Pv_Prefijo,
        Pv_TipoProceso,
        Pv_CodigoTipoDocumento,
        Pv_IdDocumento,
        Pt_Fe_Actual,
        Lv_DescripcionImpuesto
      );
    ELSIF Pv_TipoProceso='MASIVO' THEN
      idx_Masivo := 1;
      --
      Lv_DescripcionImpuesto :='';
      Gn_TipoProceso         := idx_Masivo;
      Gv_CodTipoDocumento    := Pv_CodigoTipoDocumento;

        --Adicional incluir el for para el procesamiento por individual
        P_LISTADO_PRODUCTOS ( TRIM(Pv_CodEmpresa),
                              Pv_CodigoTipoDocumento,
                              TRIM(Pt_Fe_Actual),
                              idx_Masivo,
                              Cr_ProductosFacturados);
        --
        P_PROCESAR(
          Cr_ProductosFacturados,
          Pv_CodEmpresa,
          Pv_Prefijo,
          Pv_TipoProceso,
          Pv_CodigoTipoDocumento,
          Pv_IdDocumento,
          Pt_Fe_Actual,
          Lv_DescripcionImpuesto);
        --
    ELSIF Pv_TipoProceso='ANULACION-FAC' THEN
      --Cuando realizamos el proceso de anulacion debemos incluir FAC | FACP
      --Utilizamos el formato de la NC
      --Debo pode identificar el asiento contable de NC con su glosa de anulacion
      --Obtener listado de documentos en estado anulado
      --YYYY-MM-DD
      --
      Lv_CodigoTipoDocumento  :='';
      Lv_ParametroAdicional   :='';
      Lv_EstadoImpresionFact  :='';
      Lv_TipoCuentaContable   :='';
      Lv_DescripcionImpuesto:='';
      --
      IF (Pv_CodigoTipoDocumento='FAC')THEN
        Lv_CodigoTipoDocumento := ' ATDF.CODIGO_TIPO_DOCUMENTO IN ('||q'['FAC']'||','||q'['FACP']'||')';
        Lv_TipoCuentaContable  :=' AND ATCC.DESCRIPCION IN ('||q'['PRODUCTOS']'||')';
      ELSIF(Pv_CodigoTipoDocumento='NC')THEN
        Lv_CodigoTipoDocumento := ' ATDF.CODIGO_TIPO_DOCUMENTO IN ('||q'['NC']'||')';
        Lv_TipoCuentaContable  := ' AND ATCC.DESCRIPCION IN ('||q'['PRODUCTOS_NC']'||')';
      END IF;

      Lv_EstadoImpresionFact := ' AND IDFC.ESTADO_IMPRESION_FACT IN ('||q'['Anulado']'||')';

      FOR idx_Masivo IN 1..3 LOOP

        Gn_TipoProceso         := idx_Masivo;
        Gv_CodTipoDocumento    := Pv_CodigoTipoDocumento;

        IF idx_Masivo = 1 THEN
          --Consideraciones sin iva
          Lv_ParametroAdicional:=Lv_CodigoTipoDocumento || ' AND IDFC.SUBTOTAL_CON_IMPUESTO=0 ' || Lv_EstadoImpresionFact || Lv_TipoCuentaContable;
        ELSIF idx_Masivo = 2 THEN
          --Consideraciones con iva al 12%
          Lv_SubQueryAdicional := ' AND IDFC.ID_DOCUMENTO IN (
                                    SELECT ID_DOCUMENTO
                                    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                                     JOIN INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
                                     JOIN INFO_DOCUMENTO_FINANCIERO_IMP IDFI ON IDFI.DETALLE_DOC_ID=IDFD.ID_DOC_DETALLE
                                     JOIN DB_GENERAL.ADMI_IMPUESTO AI ON AI.ID_IMPUESTO=IDFI.IMPUESTO_ID
                                     JOIN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH ON IDH.DOCUMENTO_ID=IDFC.ID_DOCUMENTO AND IDH.ESTADO='||q'['Anulado']'||' AND IDH.MOTIVO_ID IS NOT NULL
                                    WHERE AI.DESCRIPCION_IMPUESTO    ='||q'['IVA 12%']'||'
                                     AND IDFC.ESTADO_IMPRESION_FACT  ='||q'['Anulado']'||'
                                     AND TRUNC(IDH.FE_CREACION) = TO_DATE('||q'[']'||Pt_Fe_Actual||q'[','YYYY-MM-DD']'||'))';
          --
          Lv_ParametroAdicional:= Lv_CodigoTipoDocumento ||
                                  ' AND IDFC.SUBTOTAL_CON_IMPUESTO>0 ' ||
                                  Lv_EstadoImpresionFact ||
                                  Lv_SubQueryAdicional ||
                                  Lv_TipoCuentaContable;
          --
        ELSIF idx_Masivo = 3 THEN
          --Consideraciones con iva al 14%
          --Masivo que debe compensar por el 14% del IVA
          Lv_SubQueryAdicional := ' AND IDFC.ID_DOCUMENTO IN (
                                    SELECT ID_DOCUMENTO
                                    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                                     JOIN INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
                                     JOIN INFO_DOCUMENTO_FINANCIERO_IMP IDFI ON IDFI.DETALLE_DOC_ID=IDFD.ID_DOC_DETALLE
                                     JOIN DB_GENERAL.ADMI_IMPUESTO AI ON AI.ID_IMPUESTO=IDFI.IMPUESTO_ID
                                     JOIN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH ON IDH.DOCUMENTO_ID=IDFC.ID_DOCUMENTO AND IDH.ESTADO='||q'['Anulado']'||' AND IDH.MOTIVO_ID IS NOT NULL
                                    WHERE AI.DESCRIPCION_IMPUESTO   ='||q'['IVA 14%']'||'
                                     AND IDFC.ESTADO_IMPRESION_FACT  ='||q'['Anulado']'||'
                                     AND TRUNC(IDH.FE_CREACION) = TO_DATE('||q'[']'||Pt_Fe_Actual||q'[','YYYY-MM-DD']'||'))';
          --
          Lv_ParametroAdicional:= Lv_CodigoTipoDocumento ||
                                  ' AND IDFC.SUBTOTAL_CON_IMPUESTO>0 ' ||
                                  Lv_EstadoImpresionFact ||
                                  Lv_SubQueryAdicional ||
                                  Lv_TipoCuentaContable;
          --
          Lv_DescripcionImpuesto:= 'COMPENSACION 2%';
        END IF;
        --
        --Adicional incluir el for para el procesamiento por individual
        P_LISTADO_PRODUCTOS_FACT_ANU(TRIM(Pv_CodEmpresa),TRIM(Pt_Fe_Actual),Lv_ParametroAdicional,Cr_ProductosFacturados);

        --
        P_PROCESAR(
          Cr_ProductosFacturados,
          Pv_CodEmpresa,
          Pv_Prefijo,
          Pv_TipoProceso,
          Pv_CodigoTipoDocumento,
          Pv_IdDocumento,
          Pt_Fe_Actual,
          Lv_DescripcionImpuesto);
        --
      END LOOP;
    END IF;
    --
    COMMIT;
    --

    EXCEPTION
      WHEN OTHERS THEN
        Pv_MsnError:='Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
          'TELCOS-CONTABILIDAD',
          'DB_FINANCIERO.FNKG_CONTABILIZAR_FACT.P_CONTABILIZAR',
          Pv_MsnError,
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
          SYSDATE,
          NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1')
          );
        --DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_CONTABILIZAR', Pv_MsnError);
  END P_CONTABILIZAR;

PROCEDURE P_REG_MOTIV_FACT_ANULADA(Pv_PrefijoEmpresa     IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                   Pv_CodigoTipoDocFac   IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                   Pv_CodigoTipoDocFacp  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                   Pv_CodigoTipoDocNc    IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                   Pv_MsnError           OUT VARCHAR2)
    AS
    PRAGMA AUTONOMOUS_TRANSACTION;
    --
    CURSOR C_ObtenerFactAnulada(Cv_prefijoEmpresa    VARCHAR2, Cv_CodigoTipoDocFac VARCHAR2,
                                Cv_CodigoTipoDocFacp VARCHAR2, Cv_CodigoTipoDocNc  VARCHAR2)
      IS
       SELECT idfc.id_documento
         FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc,
              DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO atdf
        WHERE idfc.tipo_documento_id  = atdf.id_tipo_documento    
          AND atdf.codigo_tipo_documento in (Cv_CodigoTipoDocFac,
                                             Cv_CodigoTipoDocFacp,
                                             Cv_CodigoTipoDocNc)
          AND TRUNC(idfc.FE_CREACION) =  TRUNC(SYSDATE-1) 
          AND NOT EXISTS (SELECT idh.documento_id
                           FROM  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL idh
                          WHERE  idfc.ID_DOCUMENTO          = idh.documento_id   
                            AND  idh.ESTADO                 = 'Anulado'          
                            AND  idh.motivo_id is not null)           
                            AND  idfc.estado_impresion_fact = 'Anulado'     
                            AND  DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDFC.PUNTO_ID,NULL) = Pv_PrefijoEmpresa;

    CURSOR C_ObtenerIdMotivo(Cv_descripcionMotivo VARCHAR2)
      IS 
        SELECT am.ID_MOTIVO 
          FROM DB_GENERAL.ADMI_MOTIVO am
         WHERE am.NOMBRE_MOTIVO = Cv_descripcionMotivo;
     --             
    CURSOR C_ObtenerFacHistorial(Cn_idDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) 
      IS
        SELECT MIN(ID_DOCUMENTO_HISTORIAL) 
          FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL 
         WHERE DOCUMENTO_ID = Cn_idDocumento  
           AND ESTADO       = 'Anulado' 
         ORDER BY ID_DOCUMENTO_HISTORIAL;
     --       
     Ln_IdDocumento        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
     Ln_IdDocumentoHist    DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.ID_DOCUMENTO_HISTORIAL%TYPE; 
     Ln_IdMotivo           DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE;
     Lv_DescripcionMotivo  VARCHAR2(50):= 'Regularizacion de Motivo no seleccionado en Telcos';
     --
     BEGIN
     --  
     IF C_ObtenerFactAnulada%ISOPEN THEN
        CLOSE C_ObtenerFactAnulada;
     END IF;
     --
     OPEN C_ObtenerFactAnulada(Pv_prefijoEmpresa,Pv_CodigoTipoDocFac,Pv_CodigoTipoDocFacp,Pv_CodigoTipoDocNc);
     --
     LOOP
         FETCH C_ObtenerFactAnulada INTO Ln_IdDocumento;
          EXIT WHEN C_ObtenerFactAnulada%NOTFOUND;
           --         
           IF C_ObtenerFacHistorial%ISOPEN THEN
            CLOSE C_ObtenerFacHistorial ;
           END IF;
           --
           OPEN  C_ObtenerFacHistorial(Ln_IdDocumento);           
           FETCH C_ObtenerFacHistorial INTO Ln_IdDocumentoHist;
            EXIT WHEN C_ObtenerFacHistorial%NOTFOUND;
           --
             IF Ln_IdDocumentoHist > 0 THEN

               IF C_ObtenerIdMotivo%ISOPEN THEN
                CLOSE C_ObtenerIdMotivo;
               END IF;

               OPEN C_ObtenerIdMotivo(Lv_DescripcionMotivo);           
               FETCH C_ObtenerIdMotivo INTO Ln_IdMotivo;
             --
               UPDATE DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL SET MOTIVO_ID = Ln_IdMotivo 
                WHERE ID_DOCUMENTO_HISTORIAL = Ln_IdDocumentoHist;

               COMMIT;
               CLOSE C_ObtenerIdMotivo;
            END IF;  
           --  
           CLOSE C_ObtenerFacHistorial;
            --    
     END LOOP;
     --
     CLOSE C_ObtenerFactAnulada;
     --
       EXCEPTION
       WHEN OTHERS THEN

         Pv_MsnError := DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
         DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_FACT_NC.P_REG_FACT_ANULADA_HIST', Pv_MsnError);

    END  P_REG_MOTIV_FACT_ANULADA;

PROCEDURE P_REPLICA_INFORMACION(Pv_Cia_Origen  IN naf47_tnet.migra_arcgae.no_cia%type,
                                                  Pv_Cia_Destino IN naf47_tnet.migra_arcgae.no_cia%type,
                                                  Pv_CodDIario   naf47_tnet.migra_arcgae.cod_diario%type, 
                                                  P_lst_mapIdMigracion lst_map_idMigracionType) IS

  CURSOR C_OBTENER_INFO_MIGRAGAE(CV_COMPANIA in naf47_tnet.migra_arcgae.no_cia%type,
                                 C_IdMigracion IN naf47_tnet.migra_arcgae.id_migracion%type) IS
    select a.ID_MIGRACION,
           a.NO_CIA,
           a.ANO,
           a.MES,
           a.NO_ASIENTO,
           a.IMPRESO,
           a.FECHA,
           a.DESCRI1,
           a.ESTADO,
           a.AUTORIZADO,
           a.ORIGEN,
           a.T_DEBITOS,
           a.T_CREDITOS,
           a.COD_DIARIO,
           a.T_CAMB_C_V,
           a.TIPO_CAMBIO,
           a.TIPO_COMPROBANTE,
           a.NUMERO_CTRL,
           a.ANULADO,
           a.USUARIO_CREACION,
           a.TRANSFERIDO,
           a.FECHA_CREACION,
           a.USUARIO_PROCESA,
           a.FECHA_PROCESA,
           a.DETALLE_ERROR,
           a.ID_FORMA_PAGO,
           a.ID_OFICINA_FACTURACION
      from naf47_tnet.migra_arcgae a
     where a.no_cia = CV_COMPANIA
     AND A.ID_MIGRACION = C_IdMigracion;

  CURSOR C_OBTENER_INFO_MIGRAGAL(CV_COMPANIA     VARCHAR2,
                                 CN_ID_MIGRACION NUMBER) IS
    select a.NO_CIA,
           a.MIGRACION_ID,
           a.NO_LINEA,
           a.ANO,
           a.MES,
           a.NO_ASIENTO,
           a.CUENTA,
           a.DESCRI,
           a.NO_DOCU,
           a.COD_DIARIO,
           a.MONEDA,
           a.TIPO_CAMBIO,
           a.FECHA,
           a.MONTO,
           a.CENTRO_COSTO,
           a.TIPO,
           a.MONTO_DOL,
           a.CC_1,
           a.CC_2,
           a.CC_3,
           a.CODIGO_TERCERO,
           a.LINEA_AJUSTE_PRECISION,
           a.TRANSFERIDO
      from naf47_tnet.migra_arcgal A
     WHERE A.MIGRACION_ID = CN_ID_MIGRACION
       AND A.NO_CIA = CV_COMPANIA;

  CURSOR C_OBTENER_INFO_DOC_ASO(CV_COMPANIA     VARCHAR2,
                                CN_ID_MIGRACION NUMBER) IS
    select a.DOCUMENTO_ORIGEN_ID,
           a.TIPO_DOC_MIGRACION,
           a.MIGRACION_ID,
           a.TIPO_MIGRACION,
           a.NO_CIA,
           a.FORMA_PAGO_ID,
           a.TIPO_DOCUMENTO_ID,
           a.ESTADO,
           a.USR_CREACION,
           a.FE_CREACION,
           a.USR_ULT_MOD,
           a.FE_ULT_MOD
      from NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO A
     WHERE A.MIGRACION_ID = CN_ID_MIGRACION
       AND A.NO_CIA = CV_COMPANIA;

  TYPE R_MAPEO_SECUENCIA IS RECORD(
    SECUENCIA_ORIGINAL naf47_tnet.migra_arcgae.id_migracion%type,
    SECUENCIA_REPLICAR naf47_tnet.migra_arcgae.id_migracion%type);

  LN_CONTADOR        NUMBER := 1;
  LN_NUEVA_SECUENCIA NUMBER;
  Lr_Info_MigraArcgae C_OBTENER_INFO_MIGRAGAE%ROWTYPE;
  L_SecuenciasMap R_MAPEO_SECUENCIA;
BEGIN
  L_SecuenciasMap.SECUENCIA_ORIGINAL := P_lst_mapIdMigracion.first;

  LOOP
    exit when L_SecuenciasMap.SECUENCIA_ORIGINAL is null;

    L_SecuenciasMap.SECUENCIA_REPLICAR := P_lst_mapIdMigracion(L_SecuenciasMap.SECUENCIA_ORIGINAL);

    IF C_OBTENER_INFO_MIGRAGAE%ISOPEN THEN
      CLOSE C_OBTENER_INFO_MIGRAGAE;
    END IF;

    OPEN C_OBTENER_INFO_MIGRAGAE(Pv_Cia_Origen, L_SecuenciasMap.SECUENCIA_ORIGINAL);
    FETCH C_OBTENER_INFO_MIGRAGAE INTO Lr_Info_MigraArcgae;
    CLOSE C_OBTENER_INFO_MIGRAGAE;

    INSERT INTO NAF47_TNET.MIGRA_ARCGAE
      (NO_CIA,
       ID_MIGRACION,
       ANO,
       MES,
       NO_ASIENTO,
       FECHA,
       DESCRI1,
       T_DEBITOS,
       T_CREDITOS,
       COD_DIARIO,
       USUARIO_CREACION,
       FECHA_CREACION,
       ID_FORMA_PAGO,
       ID_OFICINA_FACTURACION,
       ORIGEN,
       TIPO_COMPROBANTE,
       TRANSFERIDO,
       IMPRESO,
       ESTADO,
       AUTORIZADO,
       T_CAMB_C_V,
       TIPO_CAMBIO,
       ANULADO)
    VALUES
      (Pv_Cia_Destino,
       L_SecuenciasMap.SECUENCIA_REPLICAR,
       Lr_Info_MigraArcgae.ano,
       Lr_Info_MigraArcgae.mes,
       Lr_Info_MigraArcgae.no_asiento,
       TRUNC(Lr_Info_MigraArcgae.fecha),
       Lr_Info_MigraArcgae.descri1,
       Lr_Info_MigraArcgae.t_debitos,
       Lr_Info_MigraArcgae.t_creditos,
       Lr_Info_MigraArcgae.cod_diario,
       Lr_Info_MigraArcgae.usuario_creacion,
       SYSDATE,
       NVL(Lr_Info_MigraArcgae.id_forma_pago, 0),
       (select id_oficina
          from DB_COMERCIAL.INFO_OFICINA_GRUPO b
         where b.NOMBRE_OFICINA =
               (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                  from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                 where a.id_oficina = Lr_Info_MigraArcgae.id_oficina_facturacion)),
       Lr_Info_MigraArcgae.origen,
       NVL(Lr_Info_MigraArcgae.tipo_comprobante, 'T'),
       NVL(Lr_Info_MigraArcgae.transferido, 'N'),
       NVL(Lr_Info_MigraArcgae.impreso, 'N'),
       NVL(Lr_Info_MigraArcgae.estado, 'P'),
       NVL(Lr_Info_MigraArcgae.autorizado, 'N'),
       NVL(Lr_Info_MigraArcgae.t_camb_c_v, 'C'),
       NVL(Lr_Info_MigraArcgae.tipo_cambio, 1),
       NVL(Lr_Info_MigraArcgae.anulado, 'N'));

    FOR ARCGAL IN C_OBTENER_INFO_MIGRAGAL(Pv_Cia_Origen,
                                          Lr_Info_MigraArcgae.ID_MIGRACION) LOOP
      INSERT INTO MIGRA_ARCGAL
        (NO_CIA,
         MIGRACION_ID,
         ANO,
         MES,
         NO_ASIENTO,
         NO_LINEA,
         CUENTA,
         DESCRI,
         COD_DIARIO,
         MONTO,
         MONTO_DOL,
         TIPO,
         CENTRO_COSTO,
         CC_1,
         CC_2,
         CC_3,
         MONEDA,
         TIPO_CAMBIO,
         LINEA_AJUSTE_PRECISION,
         TRANSFERIDO)
      VALUES
        (Pv_Cia_Destino,
         L_SecuenciasMap.SECUENCIA_REPLICAR,
         ARCGAL.ano,
         ARCGAL.mes,
         ARCGAL.no_asiento,
         ARCGAL.no_linea,
         ARCGAL.cuenta,
         ARCGAL.descri,
         ARCGAL.cod_diario,
         ARCGAL.monto,
         ARCGAL.monto_dol,
         ARCGAL.tipo,
         ARCGAL.centro_costo,
         ARCGAL.cc_1,
         ARCGAL.cc_2,
         ARCGAL.cc_3,
         NVL(ARCGAL.moneda, 'P'),
         NVL(ARCGAL.tipo_cambio, 1),
         NVL(ARCGAL.linea_ajuste_precision, 'N'),
         NVL(ARCGAL.Transferido, 'N'));
    END LOOP;

    FOR DOC_ASO IN C_OBTENER_INFO_DOC_ASO(Pv_Cia_Origen,
                                          Lr_Info_MigraArcgae.ID_MIGRACION) LOOP
      INSERT INTO NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO
        (DOCUMENTO_ORIGEN_ID,
         TIPO_DOC_MIGRACION,
         MIGRACION_ID,
         TIPO_MIGRACION,
         NO_CIA,
         FORMA_PAGO_ID,
         TIPO_DOCUMENTO_ID,
         ESTADO,
         USR_CREACION,
         FE_CREACION)
      VALUES
        (DOC_ASO.documento_origen_id,
         DOC_ASO.tipo_doc_migracion,
         L_SecuenciasMap.SECUENCIA_REPLICAR,
         DOC_ASO.tipo_migracion,
         Pv_Cia_Destino,
         DOC_ASO.forma_pago_id,
         DOC_ASO.tipo_documento_id,
         DOC_ASO.estado,
         DOC_ASO.usr_creacion,
         SYSDATE);
    END LOOP;

  L_SecuenciasMap.SECUENCIA_ORIGINAL := P_lst_mapIdMigracion.next(L_SecuenciasMap.SECUENCIA_ORIGINAL);

  END LOOP;
END P_REPLICA_INFORMACION;

END FNKG_CONTABILIZAR_FACT_NC;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_CONTABILIZAR_NCI
AS

 /*
 * Documentaci�n para FUNCION 'F_OBTENER_VALOR_PARAMETRO'.
 * FUNCION QUE OBTIENE PARAMETROS DE ECUANET PARA MIGRACION A COMPA�IA MEGADATOS
 * @author Jimmy Gilces <jgilces@telconet.ec>
 * @version 1.0
 * @since 27/03/2023
 * @Param varchar2 Pv_NombreParametro
 * @Param varchar2 Pv_Parametro
 * @return  VARCHAR2 (VALOR DEL PARAMETRO SOLICITADO)
 */
 FUNCTION F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro IN VARCHAR2,
                                    Pv_Parametro       IN VARCHAR2)
   RETURN VARCHAR2 IS
   CURSOR C_OBTENER_PARAMETRO(Cv_NombreParametro VARCHAR2,
                              Cv_Parametro       VARCHAR2) IS
     select apd.valor2
       from db_general.admi_parametro_cab apc,
            db_general.admi_parametro_det apd
      where apc.id_parametro = apd.parametro_id
        and apc.estado = apd.estado
        and apc.estado = 'Activo'
        and apc.nombre_parametro = Cv_NombreParametro
        and apd.valor1 = Cv_Parametro;
 
   Lv_ValorParametro DB_GENERAL.Admi_Parametro_Det.VALOR2%type;
 BEGIN
   IF C_Obtener_Parametro%ISOPEN THEN
     CLOSE C_Obtener_Parametro;
   END IF;
 
   OPEN C_Obtener_Parametro(Pv_NombreParametro, Pv_Parametro);
   FETCH C_Obtener_Parametro
     INTO Lv_ValorParametro;
   CLOSE C_Obtener_Parametro;
 
   RETURN Lv_ValorParametro;
 END;
 
  --Procedimiento para obtener el listado de notas de Credito Internas por individual
  PROCEDURE P_LISTADO_NCI_INDIVIDUAL(
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pn_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Lrf_Listado             OUT SYS_REFCURSOR
  )
  AS
    Lv_InfoError  VARCHAR2(2000);
  BEGIN
    OPEN Lrf_Listado FOR
      --
      SELECT IOG.ID_OFICINA,
        IDFC.PUNTO_ID,
        IDFC.ID_DOCUMENTO,
        IDFC.FE_EMISION,
        IDFC.VALOR_TOTAL,
        ACC.ID_CUENTA_CONTABLE

      FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
      JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      --
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
      --
      LEFT JOIN DB_GENERAL.ADMI_MOTIVO AM ON AM.ID_MOTIVO=IDFD.MOTIVO_ID
      --
      JOIN ADMI_CUENTA_CONTABLE ACC ON ACC.VALOR_CAMPO_REFERENCIAL=IDFC.OFICINA_ID
      JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=ACC.TIPO_CUENTA_CONTABLE_ID

      WHERE
      ATDF.CODIGO_TIPO_DOCUMENTO     = Pv_CodigoTipoDocumento
      AND IEG.COD_EMPRESA            = Pv_CodEmpresa
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Cerrado')
      AND IDFC.ID_DOCUMENTO          = Pn_IdDocumento
      AND IDFC.CONTABILIZADO         IS NULL
      --
      AND ACC.CAMPO_REFERENCIAL      = 'ID_OFICINA'
      AND ACC.OFICINA_ID             = IDFC.OFICINA_ID
      AND ATCC.DESCRIPCION           IN ('OTROS EGRESOS')

      GROUP BY IOG.ID_OFICINA,
      IDFC.PUNTO_ID,
      IDFC.ID_DOCUMENTO,
      IDFC.FE_EMISION,
      ACC.CUENTA,
      IDFC.VALOR_TOTAL,
      ACC.ID_CUENTA_CONTABLE;
      --

      EXCEPTION
        WHEN OTHERS THEN
        Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_LISTADO_NCI_INDIVIDUAL', Lv_InfoError);
  END P_LISTADO_NCI_INDIVIDUAL;

  PROCEDURE P_LISTADO_POR_OFICINA(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Prf_Listado             IN  SYS_REFCURSOR,
    Lr_OficinasFacturado    OUT TypeOficinasNciTab,
    Lr_Documentos           OUT FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab
  )
  AS
    Lv_InfoError             VARCHAR2(2000);
    Cr_Oficinas              SYS_REFCURSOR;
    Cr_Oficina               FNKG_CONTABILIZAR_FACT_NC.TypeoOficinas;
    Lrf_NotaDeCreditoInterna TypeNotaDeCreditoInterna;
    Ln_Total                 INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

  BEGIN
    /*--Proceso:
      --Obtengo las oficinas de la empresa, mediante la funcion
      --Las guardo en el arreglo y como indice
      --Despues de guardar las oficinas empiezo a recorrer el arreglo de oficinas_facturados, que debe estar ordenado por oficina
    */
    --
    FNKG_CONTABILIZAR_FACT_NC.P_OFICINAS_POR_EMPRESA(Pv_CodEmpresa,Cr_Oficinas);

    LOOP
      FETCH Cr_Oficinas into Cr_Oficina;
      EXIT WHEN Cr_Oficinas%NOTFOUND;
      Lr_OficinasFacturado(Cr_Oficina.ID_OFICINA).OFICINA_ID:=Cr_Oficina.ID_OFICINA;
      Lr_OficinasFacturado(Cr_Oficina.ID_OFICINA).NOMBRE_OFICINA:=Cr_Oficina.NOMBRE_OFICINA;
      --Documentos
      Lr_Documentos(Cr_Oficina.ID_OFICINA).OFICINA_ID:=Cr_Oficina.ID_OFICINA;

    END LOOP;

    Ln_Total:=0;
    LOOP
      FETCH Prf_Listado into Lrf_NotaDeCreditoInterna;
      EXIT WHEN Prf_Listado%NOTFOUND;
      --Obtengo valor para acumular
      IF(Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).TOTAL IS NULL) THEN
        Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).TOTAL:=0;
      END IF;

      Ln_Total:=Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).TOTAL;

      IF Lrf_NotaDeCreditoInterna.VALOR_TOTAL>0 THEN
        Ln_Total:=Ln_Total+Lrf_NotaDeCreditoInterna.VALOR_TOTAL;
      END IF;

      --Guardo los valores nuevos acumulados
      Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).TOTAL:=Ln_Total;
      Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).ID_CUENTA_CONTABLE:=Lrf_NotaDeCreditoInterna.ID_CUENTA_CONTABLE;

      --Guardo los documentos por oficina unicamente
      Lr_Documentos(Lrf_NotaDeCreditoInterna.ID_OFICINA).DOCUMENTOS(Lrf_NotaDeCreditoInterna.ID_DOCUMENTO).ID_DOCUMENTO:=Lrf_NotaDeCreditoInterna.ID_DOCUMENTO;
      Lr_Documentos(Lrf_NotaDeCreditoInterna.ID_OFICINA).DOCUMENTOS(Lrf_NotaDeCreditoInterna.ID_DOCUMENTO).PUNTO_ID:=Lrf_NotaDeCreditoInterna.PUNTO_ID;
      --
    END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
        Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_LISTADO_POR_OFICINA', Lv_InfoError);
  END P_LISTADO_POR_OFICINA;

  FUNCTION F_OBTENER_MOTIVO(
    Pn_IdDocumento      IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2
  AS
    CURSOR C_NombreMotivo
      (Cn_IdDocumento      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
    ) IS
      SELECT
        am.NOMBRE_MOTIVO
      FROM INFO_DOCUMENTO_FINANCIERO_CAB idfc
      LEFT JOIN INFO_OFICINA_GRUPO iog on iog.ID_OFICINA=idfc.OFICINA_ID
      LEFT JOIN INFO_DOCUMENTO_FINANCIERO_DET idfd on idfd.DOCUMENTO_ID=idfc.ID_DOCUMENTO
      LEFT JOIN admi_motivo am on am.id_motivo=idfd.MOTIVO_ID
      LEFT JOIN admi_tipo_documento_financiero atdf on atdf.ID_TIPO_DOCUMENTO=idfc.tipo_documento_id
      WHERE atdf.CODIGO_TIPO_DOCUMENTO = 'NCI'
      AND idfc.id_documento            = Cn_IdDocumento;
    --
    Lv_StringMotivo   VARCHAR2(1000);
    --
    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError      VARCHAR2(2000);
  BEGIN
    IF C_NombreMotivo%ISOPEN THEN
      CLOSE C_NombreMotivo;
    END IF;
    --
    OPEN C_NombreMotivo(Pn_IdDocumento);
    --
    FETCH C_NombreMotivo INTO Lv_StringMotivo;
    --
    CLOSE C_NombreMotivo;
    --
    IF Lv_StringMotivo IS NULL THEN
      Lv_StringMotivo  := '';
    END IF;
    --
    RETURN Lv_StringMotivo;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.F_OBTENER_MOTIVO', Lv_InfoError);
  END F_OBTENER_MOTIVO;

  PROCEDURE P_PROCESAR(
      Prf_Listado             IN  SYS_REFCURSOR,
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoProceso          IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
      )
  AS

    --Asiento contable
    Lv_CodDiario              VARCHAR2(100);
    Lv_NoAsiento              VARCHAR2(1000);
    Lv_UsrCreacion            VARCHAR2(1000);
    Lv_Descripcion            VARCHAR2(240);
    Pv_CampoReferencial       VARCHAR2(100);
    Pv_ValorCampoReferencial  VARCHAR2(100);
    Cr_CtaContable            VARCHAR2(100);
    Cr_NoCta                  VARCHAR2(100);

     --Tipo de record
    Lr_OficinasFacturado      TypeOficinasNciTab;
    Pr_Arreglo                FNKG_CONTABILIZAR_FACT_NC.TypeArreglo;
    Ln_ValorTotal             INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

    Lr_Documentos             FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab;
    Lr_InfoDocumento           FNKG_CONTABILIZAR_FACT_NC.TypeInfoDocumento;
    Lv_NumeroFacturaSri       INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;

    --Tipo para la plantilla
    Lr_Plantilla              FNKG_CONTABILIZAR_FACT_NC.TypePlantillaCab;
    Lr_PlantillaDet           FNKG_CONTABILIZAR_FACT_NC.TypePlantillaDet;

    --Tablas ed contabilidad
    Lr_MigraArcgae            MIGRA_ARCGAE%ROWTYPE;
    Lr_MigraArcgal            MIGRA_ARCGAL%ROWTYPE;
    --
    Pn_Monto                  INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Lv_PlantillaDescripcion   ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE;

    --Recorridos de arreglos
    Ln_OficinaIdx             DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
    Ln_LineaId               NUMBER;

    --Para el manejo de la fecha
    Ld_FeCreacion             DATE;

    --Para manejo de errores
    Pv_MsnError               VARCHAR2(4000);

    --Glosa contable
    Lv_FormatoGlosa           ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_GLOSA%TYPE;
    Lv_FormatoNoAsiento       ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_NO_DOCU_ASIENTO%TYPE;

    --Fechas
    Lv_Anio                   VARCHAR2(1000);
    Lv_Mes                    VARCHAR2(1000);

    --Plantilla
    Cr_PlantillaCab           SYS_REFCURSOR;
    Cr_PlantillaDet           SYS_REFCURSOR;
    Cr_InfoDocumento          SYS_REFCURSOR;
    --
    Le_Exception EXCEPTION;
    Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    Lrf_GetAdmiParametrosDet  SYS_REFCURSOR;
    Lr_GetAdmiParametrosDet   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    --
    Ln_IdMigracion33 naf47_tnet.migra_arckmm.id_migracion%type;
    Ln_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type;
  
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
  BEGIN
    --
    P_LISTADO_POR_OFICINA(Pv_CodEmpresa,Prf_Listado,Lr_OficinasFacturado,Lr_Documentos);
    --Ya tengo las oficinas que se procesaron o se procesaran debo recorrer
    --y enviar los parametros que quien se va a totalizar
    Ln_OficinaIdx := Lr_OficinasFacturado.FIRST;
    LOOP
      
      Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      
      EXIT WHEN Ln_OficinaIdx IS NULL;
      --
      Lv_PlantillaDescripcion:='NOTA DE CREDITO INTERNA INDIVIDUAL';
      --
      FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_CAB(Pv_CodigoTipoDocumento,Lv_PlantillaDescripcion,Pv_CodEmpresa,Cr_PlantillaCab);
      FETCH Cr_PlantillaCab INTO Lr_Plantilla;

      --Obtengo la data de la plantilla
      Lv_CodDiario:= Lr_Plantilla.COD_DIARIO;
      Ln_ValorTotal:=Lr_OficinasFacturado(Ln_OficinaIdx).TOTAL;
      --
      --Cuando el totalizado no existe, no debe crear cabecera
      IF (Ln_ValorTotal>0)THEN
        --
        Lv_NumeroFacturaSri:= '';
        --Parametros necesario de manera externa
        IF Pv_TipoProceso='INDIVIDUAL' THEN
          --Data por individual
          FNKG_CONTABILIZAR_FACT_NC.O_OBTENER_DATA_DOCUMENTO(Pv_IdDocumento,Cr_InfoDocumento);
          FETCH Cr_InfoDocumento INTO Lr_InfoDocumento;
          FNKG_CONTABILIZAR_FACT_NC.P_SPLIT(TO_CHAR(Lr_InfoDocumento.FE_EMISION),'-',Pr_Arreglo);
          Lv_Anio             :=  Pr_Arreglo(0);
          Lv_Mes              :=  Pr_Arreglo(1);
          Ld_FeCreacion       :=  TO_DATE(Lr_InfoDocumento.FE_EMISION,'YYYY-MM-DD');
          Lv_UsrCreacion      :=  Lr_InfoDocumento.USR_CREACION;
          Lv_NoAsiento        :=  Pv_IdDocumento;
          Lv_NumeroFacturaSri :=  Lr_InfoDocumento.NUMERO_FACTURA_SRI;
        END IF;

        --Leyendo la plantilla, segun el proceso
        IF Lr_Plantilla.TABLA_CABECERA='MIGRA_ARCGAE' THEN
          --
          Lv_FormatoGlosa:=Lr_Plantilla.FORMATO_GLOSA;
          Lv_FormatoNoAsiento:=Lr_Plantilla.FORMATO_NO_DOCU_ASIENTO;
          --
          FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_DESCRIPCION(
            Lv_FormatoGlosa,
            TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
            Lr_OficinasFacturado(Ln_OficinaIdx).NOMBRE_OFICINA,
            Lr_InfoDocumento.LOGIN,
            Lv_NumeroFacturaSri,
            Lv_Descripcion
          );

          FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_NO_ASIENTO(
            Lv_FormatoNoAsiento,
            TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
            Pv_IdDocumento,
            Ln_OficinaIdx,
            Lv_NoAsiento
          );
          --
          --
          Lr_MigraArcgae.ID_FORMA_PAGO          := NULL;
          Lr_MigraArcgae.ID_OFICINA_FACTURACION := Ln_OficinaIdx;
          --
          IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
           Lr_MigraArcgae.ID_MIGRACION    := NAF47_TNET.TRANSA_ID.MIGRA_CG ( Lv_EmpresaOrigen );
           Ln_IdMigracion33 := Lr_MigraArcgae.ID_MIGRACION;
           Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CG ( Lv_EmpresaDestino );
          ELSE
           Lr_MigraArcgae.ID_MIGRACION     := NAF47_TNET.TRANSA_ID.MIGRA_CG( Pv_CodEmpresa );
          END IF;
          
          Lr_MigraArcgae.NO_CIA           := Pv_CodEmpresa;
          Lr_MigraArcgae.ANO              :=  Lv_Anio;
          Lr_MigraArcgae.MES              :=  Lv_Mes;
          Lr_MigraArcgae.FECHA            :=  Ld_FeCreacion;
          Lr_MigraArcgae.NO_ASIENTO       :=  SUBSTR(Lv_NoAsiento,1,12);
          Lr_MigraArcgae.DESCRI1          :=  SUBSTR(Lv_Descripcion, 1, 240);
          Lr_MigraArcgae.ESTADO           := 'P';
          Lr_MigraArcgae.AUTORIZADO       := 'N';
          Lr_MigraArcgae.ORIGEN           :=  Pv_Prefijo;
          Lr_MigraArcgae.T_DEBITOS        :=  Ln_ValorTotal;
          Lr_MigraArcgae.T_CREDITOS       :=  Ln_ValorTotal;
          Lr_MigraArcgae.COD_DIARIO       :=  Lv_CodDiario;
          Lr_MigraArcgae.T_CAMB_C_V       := 'C';
          Lr_MigraArcgae.TIPO_CAMBIO      := '1';
          Lr_MigraArcgae.TIPO_COMPROBANTE := 'T';
          Lr_MigraArcgae.ANULADO          := 'N';
          Lr_MigraArcgae.USUARIO_CREACION :=  Lv_UsrCreacion;
          Lr_MigraArcgae.TRANSFERIDO      := 'N';
          Lr_MigraArcgae.FECHA_CREACION   :=  SYSDATE;
          --
          Pv_MsnError := NULL;
          --
          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Pv_MsnError);
          --
          IF Pv_MsnError IS NOT NULL THEN
            --
            Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAE. - ID_DOCUMENTO( ' ||
                           Pv_IdDocumento || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
            --
            RAISE Le_Exception;
            --
          END IF;
          --
          IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
            DECLARE
             Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
            BEGIN
              select id_oficina INTO Ln_IdOficina
                          from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                         where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                     from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                    where a.id_oficina = Ln_OficinaIdx);
                                                    
              Lr_MigraArcgae.ID_MIGRACION     := Ln_IdMigracion18;
              Lr_MigraArcgae.ID_OFICINA_FACTURACION := Ln_IdOficina;
              Lr_MigraArcgae.NO_CIA           := Lv_EmpresaDestino;
            
              NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Pv_MsnError);
          --
              IF Pv_MsnError IS NOT NULL THEN
                --
                Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAE. - ID_DOCUMENTO( ' ||
                               Pv_IdDocumento || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                --
                RAISE Le_Exception;
                --
              END IF;
            
              Lr_MigraArcgae.ID_OFICINA_FACTURACION := Ln_OficinaIdx;
              Lr_MigraArcgae.ID_MIGRACION     := Ln_IdMigracion33;
              Lr_MigraArcgae.NO_CIA           := Lv_EmpresaOrigen;
            END;
          END IF;
          --
          --Leyendo detalle de plantilla, segun proceso
          --Cuando tengo la plantillaDet, busco sus cuentas contable enlazadas
          Ln_LineaId :=  0;

          FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_DET(Lr_Plantilla.ID_PLANTILLA_CONTABLE_CAB,Cr_PlantillaDet);
          LOOP
            FETCH Cr_PlantillaDet INTO Lr_PlantillaDet;
            EXIT WHEN Cr_PlantillaDet%NOTFOUND;
            --
            Lv_FormatoGlosa:=Lr_PlantillaDet.FORMATO_GLOSA;
            --
            FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_DESCRIPCION(
              Lv_FormatoGlosa,
              TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
              Lr_OficinasFacturado(Ln_OficinaIdx).NOMBRE_OFICINA,
              Lr_InfoDocumento.LOGIN,
              Lv_NumeroFacturaSri,
              Lv_Descripcion
            );

            --Valores fijos
            Lr_MigraArcgal.MIGRACION_ID           :=  Lr_MigraArcgae.ID_MIGRACION;
            Lr_MigraArcgal.NO_CIA                 :=  Pv_CodEmpresa;
            Lr_MigraArcgal.ANO                    :=  Lv_Anio;
            Lr_MigraArcgal.MES                    :=  Lv_Mes;
            Lr_MigraArcgal.NO_ASIENTO             :=  SUBSTR(Lv_NoAsiento,1,12);
            Lr_MigraArcgal.NO_LINEA               :=  Ln_LineaId;
            Lr_MigraArcgal.DESCRI                 :=  SUBSTR(Lv_Descripcion, 1, 100);
            Lr_MigraArcgal.COD_DIARIO             :=  Lv_CodDiario;
            Lr_MigraArcgal.MONEDA                 :=  'P';
            Lr_MigraArcgal.TIPO_CAMBIO            :=  '1';
            Lr_MigraArcgal.FECHA                  :=  Ld_FeCreacion;
            Lr_MigraArcgal.TIPO                   :=  Lr_PlantillaDet.POSICION;
            Lr_MigraArcgal.CC_1                   :=  '000';
            Lr_MigraArcgal.CC_2                   :=  '000';
            Lr_MigraArcgal.CC_3                   :=  '000';
            Lr_MigraArcgal.LINEA_AJUSTE_PRECISION :=  'N';
            Lr_MigraArcgal.TRANSFERIDO            :=  'N';

            --Campo referenciales
            IF(Lr_PlantillaDet.TIPO_CUENTA_CONTABLE='CLIENTES' or Lr_PlantillaDet.TIPO_CUENTA_CONTABLE='OTROS EGRESOS') THEN
              Pv_CampoReferencial:='ID_OFICINA';
              Pv_ValorCampoReferencial:=Ln_OficinaIdx;
              Pn_Monto  :=Ln_ValorTotal;
            END IF;

            --Proceso segun el tipo de detalle
            IF(Lr_PlantillaDet.TIPO_DETALLE='FIJO')THEN
              FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_CUENTA_CONTABLE(Pv_CodEmpresa,
                                                                  Lr_PlantillaDet.TIPO_CUENTA_CONTABLE,
                                                                  Pv_CampoReferencial,
                                                                  Pv_ValorCampoReferencial,
                                                                  Ln_OficinaIdx,
                                                                  Cr_CtaContable,
                                                                  Cr_NoCta);
              Ln_LineaId :=  Ln_LineaId+1;
              --Segun el tipo modificamos lo siguiente
              Lr_MigraArcgal.NO_LINEA   :=  Ln_LineaId;
              Lr_MigraArcgal.CUENTA     :=  Cr_CtaContable;
              --
              -- Tambien se valida si cuenta contable recuperar acepta centro de costos
              IF NAF47_TNET.CUENTA_CONTABLE.acepta_cc (Lr_MigraArcgal.NO_CIA, Lr_MigraArcgal.CUENTA) THEN
                -- si cuenta contable maneja centro de costo se busca en la parametrizacion
                --BLOQUE QUE VERIFICA SI EXISTE LA OPCION EN LOS PARAMETROS PARA COLOCAR EL COSTO A LOS PAGOS CON PROVISION INCOBRABLE
                Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(
                                            'SHOW_OPCION_BY_EMPRESA',
                                            'Activo',
                                            'Activo',
                                            Lr_MigraArcgae.ID_OFICINA_FACTURACION,
                                            Lr_MigraArcgae.no_cia,
                                            NULL,
                                            NULL );
                --
                FETCH Lrf_GetAdmiParametrosDet INTO Lr_GetAdmiParametrosDet;
                CLOSE Lrf_GetAdmiParametrosDet;
                --
                -- se verifica que retorne valores
                IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NULL THEN
                  --
                  Pv_MsnError := 'No se ha configurado Centro de costo para FormaPago: ' || Lr_MigraArcgae.id_forma_pago || ' y oficina: ' ||
                                 Lr_MigraArcgae.id_oficina_facturacion;
                  --
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                                        'FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO',
                                                        Pv_MsnError,
                                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                                        SYSDATE,
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                  --
                  RAISE Le_Exception;
                  --
                END IF;
                --
                Lr_MigraArcgal.Cc_1 := Lr_GetAdmiParametrosDet.VALOR3;
                Lr_MigraArcgal.Cc_2 := Lr_GetAdmiParametrosDet.VALOR4;
                Lr_MigraArcgal.Cc_3 := Lr_GetAdmiParametrosDet.VALOR5;
                --
              END IF;
              --
              Lr_MigraArcgal.CENTRO_COSTO           :=  Lr_MigraArcgal.Cc_1||Lr_MigraArcgal.Cc_2||Lr_MigraArcgal.Cc_3;
              --

              --Insertando
              ---Guardo los montos correspondientes
              FNKG_CONTABILIZAR_FACT_NC.P_POSICION_VALOR(Lr_PlantillaDet.POSICION,Pn_Monto);
              Lr_MigraArcgal.MONTO      :=  Pn_Monto;
              Lr_MigraArcgal.MONTO_DOL  :=  Pn_Monto;
              --
              Pv_MsnError := NULL;
              --
              NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal, Pv_MsnError);
              --
              IF Pv_MsnError IS NOT NULL THEN
                --
                Pv_MsnError := 'Error al insertar el detalle del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAL. - ID_DOCUMENTO( ' ||
                               Pv_IdDocumento || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                --
                RAISE Le_Exception;
                --
              END IF;
              
              IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                                                                        
                  Lr_MigraArcgal.MIGRACION_ID     := Ln_IdMigracion18;
                  Lr_MigraArcgal.NO_CIA := Lv_EmpresaDestino;
                
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal, Pv_MsnError);
              --
                  IF Pv_MsnError IS NOT NULL THEN
                    --
                    Pv_MsnError := 'Error al insertar el detalle del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAL. - ID_DOCUMENTO( ' ||
                               Pv_IdDocumento || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                    --
                    RAISE Le_Exception;
                    --
                  END IF;
                  
                  Lr_MigraArcgal.MIGRACION_ID     := Ln_IdMigracion33;
                  Lr_MigraArcgal.NO_CIA := Lv_EmpresaOrigen;
              END IF;
              --
            END IF;
          END LOOP;

          CLOSE Cr_PlantillaDet;
          --
          --
          -- LO MARCAMOS COMO CONTABILIZADO CUANDO EL PROCESO NO PRESENTA ERRORES.
          IF Pv_MsnError IS NULL THEN
            --
            FNKG_CONTABILIZAR_FACT_NC.P_MARCAR_CONTABILIZADO(Pv_IdDocumento,Pv_TipoProceso);
            --
            Lr_MigraDocumentoAsociado                     := NULL;
            Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := Pv_IdDocumento;
            Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := Lv_CodDiario;
            Lr_MigraDocumentoAsociado.NO_CIA              := Pv_CodEmpresa;
            Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := NULL;
            Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := '8';
            Lr_MigraDocumentoAsociado.ESTADO              := 'M';
            Lr_MigraDocumentoAsociado.USR_CREACION        := Lr_InfoDocumento.USR_CREACION;
            Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
            Lr_MigraDocumentoAsociado.MIGRACION_ID        := Lr_MigraArcgae.ID_MIGRACION;
            Lr_MigraDocumentoAsociado.TIPO_MIGRACION      := 'CG';
            --
            --
            IF Lr_MigraDocumentoAsociado.MIGRACION_ID IS NOT NULL AND Lr_MigraDocumentoAsociado.MIGRACION_ID > 0 THEN
              --
              Pv_MsnError := NULL;
              --
              NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MsnError);
              --
              IF Pv_MsnError IS NOT NULL THEN
                --
                Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento ||
                ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                --
                RAISE Le_Exception;
                --
              END IF;
              
              IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                Lr_MigraDocumentoAsociado.NO_CIA              := Lv_EmpresaDestino;
                Lr_MigraDocumentoAsociado.MIGRACION_ID        := Ln_IdMigracion18;
                
                NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MsnError);
                --
                IF Pv_MsnError IS NOT NULL THEN
                  --
                  Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento ||
                  ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                  --
                  RAISE Le_Exception;
                  --
                END IF;
                
                Lr_MigraDocumentoAsociado.NO_CIA              := Pv_CodEmpresa;
                Lr_MigraDocumentoAsociado.MIGRACION_ID        := Lr_MigraArcgae.ID_MIGRACION;
              END IF;
            --
            ELSE
              --
              Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento ||
              ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
              --
              RAISE Le_Exception;
             --
            END IF;
          --
          END IF;
          --
        END IF;
      ELSE
        --Informe de error en el proceso
        Pv_MsnError := 'No se contabiliza variable Ln_ValorTotal.TOTAL:'||Ln_ValorTotal ||' Ln_OficinaIdx:' ||Ln_OficinaIdx;
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_CONTABILIZAR',Pv_MsnError);
      END IF;
      --Cierro la plantilla
      CLOSE Cr_PlantillaCab;
      --Aumento el indice de las oficinas
      Ln_OficinaIdx := Lr_OficinasFacturado.NEXT(Ln_OficinaIdx);
      --
    END LOOP;
    --
    --Se guarda la transaccion realizada
    COMMIT;
    --
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    Pv_MsnError := Pv_MsnError || ' - Error:' || DBMS_UTILITY.FORMAT_ERROR_STACK || '-' || DBMS_UTILITY.format_call_stack || chr(13) || ' : ' ||
                   DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_NCI.P_PROCESAR',
                                          Pv_MsnError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  WHEN OTHERS THEN
    --
    Pv_MsnError := Pv_MsnError || ' - Error:' || DBMS_UTILITY.FORMAT_ERROR_STACK || '-' || DBMS_UTILITY.format_call_stack || chr(13) || ' : ' ||
                   DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_NCI.P_PROCESAR',
                                          Pv_MsnError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  END P_PROCESAR;

  --Contabilizar NCI
  PROCEDURE P_CONTABILIZAR(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
  )
  AS
    Lrf_Listado                SYS_REFCURSOR;
    --Para manejo de errores
    Lv_MsnError               VARCHAR2(3000);
    --
    Lv_StringMotivo           VARCHAR2(1000);
    --

  BEGIN
    IF Pv_TipoProceso='INDIVIDUAL' THEN
      Lv_StringMotivo  := F_OBTENER_MOTIVO(Pv_IdDocumento);
       --
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_CONTABILIZAR',
      'Data Lv_StringMotivo:'||Lv_StringMotivo || 'Pv_IdDocumento:' ||Pv_IdDocumento);
      --
      P_LISTADO_NCI_INDIVIDUAL(Pv_CodEmpresa,Pv_CodigoTipoDocumento,Pv_IdDocumento,Lrf_Listado);
        --
      P_PROCESAR(
          Lrf_Listado,
          Pv_CodEmpresa,
          Pv_Prefijo,
          Pv_TipoProceso,
          Pv_CodigoTipoDocumento,
          Pv_IdDocumento
          );
      --
    END IF;
    --
    EXCEPTION
      WHEN OTHERS THEN
        Lv_MsnError:='Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_CONTABILIZAR', Lv_MsnError);
  END P_CONTABILIZAR;

END FNKG_CONTABILIZAR_NCI;
/
