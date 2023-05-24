CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_PAGO_AUTOMATICO AS
  /**
  * Documentaci�n para TYPE 'Lr_AnticiposDet'.
  *  
  * @author Edgar Holgu�n <eholgu�n@telconet.ec>
  * @version 1.0 04-05-2021
  */
  TYPE Lr_AnticiposDet IS RECORD (
    REFERENCIA_DET_PAGO_AUT_ID DB_FINANCIERO.INFO_PAGO_DET.REFERENCIA_DET_PAGO_AUT_ID%TYPE,
    VALOR_PAGO                 DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
    NUMERO_REFERENCIA          DB_FINANCIERO.INFO_PAGO_DET.NUMERO_REFERENCIA%TYPE,
    FORMA_PAGO_ID              DB_FINANCIERO.INFO_PAGO_DET.FORMA_PAGO_ID%TYPE,
    COMENTARIO                 DB_FINANCIERO.INFO_PAGO_DET.COMENTARIO%TYPE,
    FE_DEPOSITO                DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.FECHA%TYPE,
    DOCUMENTO_ID               DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.DOCUMENTO_ID%TYPE
  );

  /**
  * Documentaci�n para TYPE 'T_AnticiposDet'.
  * Tabla para almacenar la data de anticipos a generar.
  * @author Edgar Holgu�n <eholgu�n@telconet.ec>
  * @version 1.0 04-05-2021
  */
  TYPE T_AnticiposDet IS TABLE OF Lr_AnticiposDet INDEX BY PLS_INTEGER;


  /*
  * Documentaci�n para TYPE 'T_DatosRptRetExistentes'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 16-09-2021
  */
  TYPE T_DatosRptRetExistentes IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_RptRetExistente INDEX BY PLS_INTEGER;

 /**
  * Documentaci�n para TYPE 'Lr_FacturasProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-04-2021
  */
  TYPE Lr_FacturasProcesar IS RECORD (
    ID_DOCUMENTO            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    OFICINA_ID              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OFICINA_ID%TYPE,
    PUNTO_ID                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
    BASE_IMPONIBLE          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    SUBTOTAL_CON_IMPUESTO   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
    ESTADO_IMPRESION_FACT   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    NUMERO_FACTURA_SRI      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    VALOR_TOTAL             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    FE_CREACION             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_CREACION%TYPE,
    TIPO_DOCUMENTO_ID       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE 
  );

 /**
  * Documentaci�n para TYPE 'T_FacturasProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-04-2021
  */
  TYPE T_FacturasProcesar IS TABLE OF Lr_FacturasProcesar INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para TYPE 'TpInfoPagosAutomaticoCab'.
  *
  * Tipo de datos para el retorno de la informaci�n de retenciones.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 15-08-2019
  */
  TYPE TpInfoPagosAutomaticoCab
  IS
    RECORD
    (
      ID_PAGO_AUTOMATICO       DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE,
      OFICINA_ID               DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.OFICINA_ID%TYPE,
      RUTA_ARCHIVO             DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.RUTA_ARCHIVO%TYPE,       
      ESTADO                   DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ESTADO%TYPE,
      IDENTIFICACION_CLIENTE   DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.IDENTIFICACION_CLIENTE%TYPE,
      TIPO_FORMA_PAGO          DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.TIPO_FORMA_PAGO%TYPE
      );

  /**
  * Documentaci�n para TYPE 'TpInfoPagosAutomaticoDet'.
  *
  * Tipo de datos para el retorno de la informaci�n de detalles de retenciones.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 22-06-2021
  */
  TYPE TpInfoPagosAutomaticoDet
  IS
    RECORD
    (
      ID_DETALLE_PAGO_AUTOMATICO       DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ID_DETALLE_PAGO_AUTOMATICO%TYPE,
      PAGO_AUTOMATICO_ID               DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.PAGO_AUTOMATICO_ID%TYPE,
      PERSONA_EMPRESA_ROL_ID           DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.PERSONA_EMPRESA_ROL_ID%TYPE,       
      DOCUMENTO_ID                     DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.DOCUMENTO_ID%TYPE,
      FORMA_PAGO_ID                    DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.FORMA_PAGO_ID%TYPE,
      OBSERVACION                      DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.OBSERVACION%TYPE,
      NUMERO_REFERENCIA                DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_REFERENCIA%TYPE,
      BASE_IMPONIBLE                   DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.BASE_IMPONIBLE%TYPE,
      BASE_IMPONIBLE_CAL               DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.BASE_IMPONIBLE_CAL%TYPE,       
      CODIGO_IMPUESTO                  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.CODIGO_IMPUESTO%TYPE,
      PORCENTAJE_RETENCION             DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.PORCENTAJE_RETENCION%TYPE,
      NUMERO_FACTURA                   DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_FACTURA%TYPE,
      MONTO                            DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.MONTO%TYPE,
      EMPRESA_COD                      DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.EMPRESA_COD%TYPE,       
      ESTADO                           DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ESTADO%TYPE,
      FECHA                            DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.FECHA%TYPE,
      FE_CREACION                      DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.FE_CREACION%TYPE
      );

  /*
  * Documentaci�n para TYPE 'T_InfoPagoAutomaticoCab'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 26-04-2021
  */
  TYPE T_InfoPagoAutomaticoCab IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.TpInfoPagosAutomaticoCab INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'T_InfoPagosAutomaticoDet'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 22-06-2021
  */
  TYPE T_InfoPagosAutomaticoDet IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.TpInfoPagosAutomaticoDet INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para TYPE 'TpInfoFactPagAutomaticoDet'.
  *
  * Tipo de dato para el retorno de la informaci�n de n�mero de facturas en detalles de retenci�n.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 15-08-2019
  */
  TYPE TpInfoFactPagAutomaticoDet
  IS
    RECORD
    (
      NUMERO_FACTURA  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_FACTURA%TYPE
    );

  /*
  * Documentaci�n para TYPE 'T_InfoPagoAutomaticoDet'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 26-04-2021
  */
  TYPE T_InfoPagoAutomaticoDet IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.TpInfoFactPagAutomaticoDet INDEX BY PLS_INTEGER;


  /**
  * Documentaci�n para TYPE 'TpInfoPagDet'.
  *
  * Tipo de dato para el retorno de la informaci�n del id del detalle del pago.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 23-06-2021
  */
  TYPE TpInfoPagDet
  IS
    RECORD
    (
      ID_PAGO_DET  DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE
    );

  /*
  * Documentaci�n para TYPE 'T_InfoPagDet'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 23-06-2021
  */
  TYPE T_InfoPagDet IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.TpInfoPagDet INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'T_ArrayIds'.
  * Almacena array de ids
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 26-04-2021
  */
  TYPE T_ArrayIds IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;


/**
  * Documentaci�n para la funci�n 'P_PROCESAR_RETENCIONES'.
  *
  * Procedimiento que procesa las retenciones enviadas como par�metros.
  *
  * @param  Pv_IdsRetSelecionadas    IN  VARCHAR2  recibe el c�digo de la empresa.
  * @param  Pv_EmpresaCod            IN  VARCHAR2  recibe el id del punto.
  * @param  Pv_UsrCreacion           IN  VARCHAR2  recibe el id del servicio.
  * @param  Pv_Ip                    IN  VARCHAR2  recibe el id del contrato.
  * @param  Pv_Status                IN  VARCHAR2  recibe el id de la forma de pado.
  * @param  Pv_Mensaje               IN  VARCHAR2  recibe el id del TipoCuenta.
  * @param  Fn_BancoTipoCuentaId     IN  VARCHAR2  recibe el id del BancoTipoCuenta.
  * @return NUMBER
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 27-05-2020
  * @author Gustavo Narea <gnarea@telconet.ec>
  * @version 1.01 20-08-2021 Los anticipos se los crea dentro de p_genera_pago
  */
PROCEDURE P_PROCESAR_RETENCIONES( Pv_IdsRetSelecionadas   IN  VARCHAR2,
                                  Pv_PrefijoEmpresa       IN  VARCHAR2,
                                  Pv_EmpresaCod           IN  VARCHAR2,
                                  Pv_UsrCreacion          IN  VARCHAR2,
                                  Pv_Ip                   IN  VARCHAR2,
                                  Pv_Status               OUT VARCHAR2,
                                  Pv_Mensaje              OUT VARCHAR2);
  /**
  * Documentaci�n para el procedimiento P_GET_INFO_DOCUMENTO
  *
  * Procedimiento que retorna informaci�n de la factura asociada enviada como par�metro.
  *
  * Costo 10
  *
  * @param Pv_CodEmpresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Prefijo de la empresa.
  * @param Pv_NumFactura             IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE
  * @param Prf_InfoDocumento         OUT SYS_REFCURSOR  Retorna cursor con informacion de documento.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 27-04-2021
  */

  PROCEDURE P_GET_INFO_DOCUMENTO(
    Pv_CodEmpresa         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_NumFactura         IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    Prf_InfoDocumento     OUT SYS_REFCURSOR);


  /**
  * Documentaci�n para el procedimiento P_GET_LIST_INFO_PAG_AUT_CAB
  *
  * Procedimiento que retorna cursor con las retenciones (INFO_PAGO_AUTOMATICO_CAB) con ids enviados como par�metro.
  *
  * Costo 10
  *
  * @param Pv_CodEmpresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  C�digo de la empresa.
  * @param Pv_IdsRetSelecionadas     IN  VARCHAR2 Ids de retenciones seleccionadas para generaci�n de pagos
  * @param Prf_InfoDocumento         OUT SYS_REFCURSOR  Retorna cursor con informacion de las retenciones.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 27-04-2021
  */
  PROCEDURE P_GET_LIST_INFO_PAG_AUT_CAB(
    Pv_CodEmpresa                 IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IdsRetSelecionadas         VARCHAR2,
    Prf_InfoPagoAutomaticoCab     OUT SYS_REFCURSOR);


  /**
  * Documentaci�n para el procedimiento P_GET_LIST_FACT_SELECT
  *
  * Procedimiento que retorna cursor con las facturas asociadas a la retenci�n con id enviado como par�metro.
  *
  * Costo 50
  *
  * @param Pv_CodEmpresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE C�digo de la empresa.
  * @param Pv_IdPagoAutomaticoCab    IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE Id de la retenci�n
  * @param Prf_ListFacturasSelect    OUT SYS_REFCURSOR  Retorna cursor de facturas asociadas a la retenci�n.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 27-04-2021
  */
  PROCEDURE P_GET_LIST_FACT_SELECT(
    Pv_CodEmpresa                 IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IdPagoAutomaticoCab        IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE,
    Prf_ListFacturasSelect        OUT SYS_REFCURSOR);
  /**
  * Documentaci�n para la funci�n P_GENERA_PAGO
  * 
  * Procedimiento que genera un pago  asociado a los datos enviados como par�metro.
  *
  * Costo 50
  *
  * @param Fn_ValorPagado      IN DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE                   Valor total del pago.
  * @param Fv_EmpresaId        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE               C�digo de la empres
  * @param Fv_UsrCreacion      IN DB_FINANCIERO.INFO_PAGO_CAB.USR_CREACION%TYPE                  Usuario de creaci�n.
  * @param Fn_IdPagoAutomatico IN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.PAGO_AUTOMATICO_ID%TYPE Id de la retenci�n.
  * @param Fn_NumDocSustento   IN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_FACTURA%TYPE     N�mero de actura asociada en el xml
  * @param Frf_Facturas        IN SYS_REFCURSOR                                                  Informaci�n de la factura asociada.
  * @param Fn_ValorPagoDif     OUT DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE                  Valor total de anticipo
  * @param Ft_InfoAnticiposDet OUT T_AnticiposDet                                                Informaci�n de detalles de anticipos
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 27-04-2021
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.01 13-07-2021 Se excluye consulta de detalles con estado No Procesa.
  *
  * @author Gustavo Narea <eholguin@telconet.ec>
  * @version 1.02 20-08-2021 Generacion de anticipos no procesados.
  
  */
  PROCEDURE P_GENERA_PAGO(
                          Fn_ValorPagado      IN  DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
                          Fv_EmpresaId        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                          Fv_UsrCreacion      IN  DB_FINANCIERO.INFO_PAGO_CAB.USR_CREACION%TYPE,
                          Fn_IdPagoAutomatico IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.PAGO_AUTOMATICO_ID%TYPE,
                          Fn_NumDocSustento   IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_FACTURA%TYPE,
                          Frf_Facturas        IN  SYS_REFCURSOR,
                          Fn_ValorPagoDif     OUT DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
                          Ft_InfoAnticiposDet OUT T_AnticiposDet
                         );

  /**
  * Documentaci�n para el procedimiento P_CREA_PAGO_AUT_DET_HIST
  *
  * Proceso que genera el registro de un historial con los datos enviados como par�metro.
  *
  * @param Fv_EmpresaId        Pn_IdPagoAutDet        IN  NUMBER    Id de detalle de pago automatico asociado     
  * @param Fv_UsrCreacion      Pv_Observacion         IN  VARCHAR2  Observaci�n
  * @param Fn_IdPagoAutomatico Pv_Estado              IN  VARCHAR2  Estado
  * @param Fn_NumDocSustento   Pv_UsuarioCreacion     IN  VARCHAR2  Usuario de creaci�n  
  * @param Frf_Facturas        Pv_IpCreacion          IN  VARCHAR2  Ip de creaci�n
  * @param Fn_NumDocSustento   Pv_NombreProceso       OUT VARCHAR2  
  * @param Frf_Facturas        Pv_Error               OUT VARCHAR2      
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.00 29-04-2021
  */
  PROCEDURE P_CREA_PAGO_AUT_DET_HIST(Pn_IdPagoAutDet        IN  NUMBER,
                                     Pv_Observacion         IN  VARCHAR2,
                                     Pv_Estado              IN  VARCHAR2,
                                     Pv_UsuarioCreacion     IN  VARCHAR2,
                                     Pv_IpCreacion          IN  VARCHAR2,
                                     Pv_NombreProceso       OUT VARCHAR2,
                                     Pv_Error               OUT VARCHAR2);

  /**
  * Documentacion para el procedimiento P_CREA_DETALLE_PAGO
  *
  * M�todo encargado de crear el detalle del pago
  *
  * @param Pn_IdPago            IN  NUMBER Recibe el id del pago
  * @param Pr_InfoPagoAutDet    IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET%ROWTYPE Recibe un objeto de tipo (INFO_PAGO_AUTOMATICO_DET)
  * @param Pv_NombreProceso     OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error             OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 27-04-2021
  */     
  PROCEDURE P_CREA_DETALLE_PAGO(
      Pn_IdPago            IN  NUMBER,
      Pr_InfoPagoAutDet    IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET%ROWTYPE,
      Pv_NombreProceso     OUT VARCHAR2,
      Pv_Error             OUT VARCHAR2);

    /**
   * Documentacion para la funcion F_GET_VARCHAR_CLEAN
   * Funcion que limpia ciertos caracteres especiales de la cadena enviada como par�metro.
   * Fv_Cadena IN VARCHAR2   Recibe la cadena a limpiar
   * Retorna:
   * En tipo varchar2 la cadena sin caracteres especiales
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 13-07-2021
   */
FUNCTION GET_VARCHAR_CLEAN(
        Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2;


  /**
  * Documentaci�n para P_PROCESA_RPT_TRIBUTACION
  * Procedimiento que procesa y genera reporte de salida a partir de reporte de tributaci�n almacenado en la ruta enviada como par�metro.
  * 
  * @author Edgar Holgu�n <eholguin@telcos.ec>
  * @version 1.0 10-08-2021
  *
  * @author Edgar Holgu�n <eholguin@telcos.ec>
  * @version 1.1 10-11-2021 Se agregan columnas de reporte de tributaci�n de entrada al reporte de retenciones existentes (salida).
  * 
  * @param Pn_IdEmpresa IN NUMBER Id de empresa que esta relacionada a la lista de pagos
  * @param  Pv_UrlFile               IN  VARCHAR2  Recibe la ruta del archivo o reporte de tributaci�n almacenado con nfs.
  * @param  Pv_EmpresaCod            IN  VARCHAR2  Recibe el c�digo de la empresa.
  * @param  Pv_UsrCreacion           IN  VARCHAR2  Recibe el user de creaci�n.
  * @param  Pv_Ip                    IN  VARCHAR2  Recibe la ip.
  * @param  Pv_Status                OUT VARCHAR2  Status de salida.
  * @param  Pv_Mensaje               OUT VARCHAR2  Mensaje de salida.
  */
  PROCEDURE P_PROCESA_RPT_TRIBUTACION(Pv_UrlFile              IN  VARCHAR2,
                                      Pv_EmpresaCod           IN  VARCHAR2,
                                      Pv_UsrCreacion          IN  VARCHAR2,
                                      Pv_Ip                   IN  VARCHAR2,
                                      Pv_Status               OUT VARCHAR2,
                                      Pv_Mensaje              OUT VARCHAR2);
  /**
  * Documentaci�n para P_ANULA_RETENCIONES_AUT
  * Procedimiento que anula retenciones con estado Error.
  * 
  * @author Edgar Holgu�n <eholguin@telcos.ec>
  * @version 1.0 16-09-2021
  *
  * @author Edgar Holgu�n <eholguin@telcos.ec>
  * @version 1.1 26-05-2022 Se agrega inserci�n de historial de eliminacion a nivel de tabla  INFO_PAGO_AUTOMATICO_HIST. 
  * 
  * @param  Pv_EmpresaCod IN  VARCHAR2  Recibe el c�digo de la empresa.
  */
  PROCEDURE P_ANULA_RETENCIONES_AUT(Pv_EmpresaCod           IN  VARCHAR2);

  /**
  * Documentacion para el procedimiento P_REPORTE_RET_ANULADAS
  *
  * Procedimiento que env�a un correo notificando a los usuarios de los retenciones anuladas existentes.
  * Costo del query 39
  *
  * @param Pv_EmpresaCod             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.COD_EMPRESA%TYPE  C�digo de la empresa de la cual se va a obtener 
  * @param Pv_CodigoPlantilla        IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla de notificaci�n
  * @param Pv_TipoEnvio              IN VARCHAR2  Tipo de env�o (M --> Mensual, D---> Diario)
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 07-09-2021 
  */
  PROCEDURE P_REPORTE_RET_ANULADAS(Pv_EmpresaCod       IN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.EMPRESA_COD%TYPE,
                                   Pv_CodigoPlantilla  IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
                                   Pv_TipoEnvio        IN VARCHAR2); 

  /**
   * Documentaci�n para TYPE 'Lr_PagoAutomatico'.
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.0 09-06-2022
   */   
  TYPE Lr_PagoAutomatico
  IS
    RECORD
    (
        ID_DETALLE_PAGO_AUTOMATICO   DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ID_DETALLE_PAGO_AUTOMATICO%TYPE,
        BANCO                        VARCHAR2(1000),
        FECHA_TRANSACCION            DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.FECHA%TYPE,
        TIPO_MOVIMIENTO              DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.OBSERVACION%TYPE,
        NUMERO_REFERENCIA            DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_REFERENCIA%TYPE,
        MONTO                        DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.MONTO%TYPE,
        ESTADO                       DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ESTADO%TYPE
    );    
   
  /**
   * Documentaci�n para TYPE 'T_PagosAutomaticos'.
   *
   * @author Edgar Holgu�n <atarreaga@telconet.ec>
   * @version 1.0 09-06-2022
   */  
  TYPE T_PagosAutomaticos IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.Lr_PagoAutomatico INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para el procedimiento P_GET_PAG_AUTOMATICOS
  *
  * Procedimiento que retorna cursor de pagos automaticos seg�n filtros enviados como par�metros.
  *
  * Costo del query 1105
  *
  * @param Pv_PrejifoEmpresa             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Prefijo de la empresa.
  * @param Pr_ParamRptPagAut             IN IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE  Par�metros  para filtrar rangos de fecha.
  * @param Pv_Estado                     IN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ESTADO%TYPE  Par�metro  para filtrar consulta por estado.
  * @param Prf_PagosAutomaticos          OUT VARCHAR2  Retorna cursor de pagos autom�ticos.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 09-06-2022
  */
  PROCEDURE P_GET_PAG_AUTOMATICOS(
    Pv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pr_ParamRptPagAut     IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Pv_Estado             IN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ESTADO%TYPE,
    Prf_PagosAutomaticos  OUT SYS_REFCURSOR);

  /**
  * Documentacion para el procedimiento P_RPT_PAG_AUT_PENDIENTES
  *
  * Procedimiento que env�a un correo con el reporte adjunto de pagos no procesados.
  *
  * @param Pv_EmpresaCod             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.COD_EMPRESA%TYPE  C�digo de la empresa de la cual se va a obtener 
  * @param Pv_PrefijoEmpresa         IN DB_COMERCIAL.INFO_OFICINA_GRUPO.PREFIJO%TYPE  Prefijo de la empresa. 
  * @param Pv_CodigoPlantilla        IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla de notificaci�n
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 10-06-2022 
  */
  PROCEDURE P_RPT_PAG_AUT_PENDIENTES(
    Pv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla   IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE);

  /**
   * Documentaci�n para TYPE 'Lr_InfoPagoAut'.
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.0 09-06-2022
   */   
  TYPE Lr_InfoRptPagoAut
  IS
    RECORD
    (
        LOGIN                     DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
        ESTADO_CLIENTE            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE,
        IDENTIFICACION_CLIENTE    DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
        NOMBRES                   DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
        APELLIDOS                 DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
        RAZON_SOCIAL              DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
        ID_PAGO                   DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
        ID_PAGO_DET               DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
        MIGRACION_ID              NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.MIGRACION_ID%TYPE,
        NOMBRE_TIPO_DOCUMENTO     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
        NUMERO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
        VALOR_TOTAL               DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
        DESCRIPCION_FORMA_PAGO    DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
        NUMERO_REFERENCIA         DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_REFERENCIA%TYPE,
        COMENTARIO                DB_FINANCIERO.INFO_PAGO_DET.COMENTARIO%TYPE,
        BANCO_EMPRESA             VARCHAR2(500),
        TIPO_DOCUMENTO_FACT       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
        NUMERO_FACTURA_SRI        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
        FE_EMISION                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
        ESTADO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
        USR_CREACION              DB_FINANCIERO.INFO_PAGO_CAB.USR_CREACION%TYPE,
        FE_CREACION               DB_FINANCIERO.INFO_PAGO_CAB.FE_CREACION%TYPE,
        FE_DEPOSITO               DB_FINANCIERO.INFO_PAGO_DET.FE_DEPOSITO%TYPE,
        FECHA_PROCESADO           DB_FINANCIERO.INFO_DEPOSITO.FE_PROCESADO%TYPE,
        NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE
    );    
   
  /**
   * Documentaci�n para TYPE 'T_PagosAutProcesados'.
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.0 13-06-2022
   */  
  TYPE T_PagosAutProcesados IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.Lr_InfoRptPagoAut INDEX BY PLS_INTEGER;


  /**
   * Documentaci�n para TYPE 'Lr_InfoPagoNdi'.
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.0 18-06-2022
   */   
  TYPE Lr_InfoPagoNdi
  IS
    RECORD
    (
        CLIENTE                   DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
        FECHA_CREACION            VARCHAR2(50),
        NUMERO_FACTURA_SRI        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
        NUMERO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
        VALOR_TOTAL               DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
        NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        NOMBRE_MOTIVO             DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE       
    ); 

  /**
   * Documentaci�n para TYPE 'T_InfoNdiPagAut'.
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.0 18-06-2022
   */  
  TYPE T_InfoNdiPagAut IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.Lr_InfoPagoNdi INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para el procedimiento P_GET_PAG_AUTOMATICOS
  *
  * Procedimiento que retorna cursor de pagos creados por procesamiento de pagos automaticos seg�n filtros enviados como par�metros.
  *
  * Costo del query 22
  *
  * @param Pv_PrejifoEmpresa             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Prefijo de la empresa.
  * @param Prf_PagosAutomaticos          OUT VARCHAR2  Retorna cursor de pagos autom�ticos.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 13-06-2022
  *
  * @author Kevin Villegas <kmvillegas@telconet.ec>
  * @version 1.1 09-11-2022 Se agrega filtro por empresa en consulta de pagos.
  */
  PROCEDURE P_GET_PAG_AUT_PROCESADOS(
    Pv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Prf_Pagos             OUT SYS_REFCURSOR);

  /**
  * Documentacion para el procedimiento P_RPT_PAG_AUT_PPROCESADOS
  *
  * Procedimiento que env�a un correo con el reporte adjunto de pagos procesados.
  *
  * @param Pv_EmpresaCod             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.COD_EMPRESA%TYPE  C�digo de la empresa de la cual se va a obtener 
  * @param Pv_PrefijoEmpresa         IN DB_COMERCIAL.INFO_OFICINA_GRUPO.PREFIJO%TYPE  Prefijo de la empresa. 
  * @param Pv_CodigoPlantilla        IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  C�digo de la plantilla de notificaci�n
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 13-06-2022 
  */
  PROCEDURE P_RPT_PAG_AUT_PPROCESADOS(
    Pv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla   IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE);

  /**
   * Documentaci�n para TYPE 'Lr_InfoPagoAut'  que almacena informaci�n de Ndi, pago asociado a un pago autom�tico reversado.
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.0 15-06-2022
   */   
  TYPE Lr_InfoPagoAsociado
  IS
    RECORD
    (
        CLIENTE                   DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
        FECHA_CREACION            VARCHAR2(100),
        NUMERO_FACTURA_SRI        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
        NUMERO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
        VALOR_TOTAL               DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
        NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        NOMBRE_MOTIVO             DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE
    );

  /**
   * Documentaci�n para TYPE 'T_InfoNdiPagosAsociados'.
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.0 15-06-2022
   */  
  TYPE T_InfoNdiPagosAsociados IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.Lr_InfoPagoAsociado INDEX BY PLS_INTEGER;

 /**
   * Documentaci�n para TYPE 'Lr_NdiReversoPago'.
   *
   * @author Kevin Villegas <kmvillegas@telconet.ec>
   * @version 1.0 01-09-2022
   */   
  TYPE Lr_NdiReversoPago
  IS
    RECORD
    (
        CLIENTE                   DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
        FECHA_CREACION            VARCHAR2(50),
        NUMERO_FACTURA_SRI        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
        NUMERO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
        VALOR_TOTAL               DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
        NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        NOMBRE_MOTIVO             DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
        LOGIN                     DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
        OFICINA                   DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        CORREO_ALIAS              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE
    ); 

  /**
   * Documentaci�n para TYPE 'T_NdiReversoPago'.
   *
   * @author Kevin Villegas <kmvillegas@telconet.ec>
   * @version 1.0 18-06-2022
   */  
  TYPE T_NdiReversoPago IS TABLE OF DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.Lr_NdiReversoPago INDEX BY PLS_INTEGER;

END FNKG_PAGO_AUTOMATICO;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_PAGO_AUTOMATICO AS

PROCEDURE P_PROCESAR_RETENCIONES( Pv_IdsRetSelecionadas   IN  VARCHAR2,
                                  Pv_PrefijoEmpresa       IN  VARCHAR2,
                                  Pv_EmpresaCod           IN  VARCHAR2,
                                  Pv_UsrCreacion          IN  VARCHAR2,
                                  Pv_Ip                   IN  VARCHAR2,
                                  Pv_Status               OUT VARCHAR2,
                                  Pv_Mensaje              OUT VARCHAR2) AS

CURSOR C_GetInfoDocumento(Cn_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                          Cv_NumFactura DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE)
IS
  SELECT  FAC.ID_DOCUMENTO,FAC.PUNTO_ID ,FAC.OFICINA_ID,(FAC.SUBTOTAL-FAC.SUBTOTAL_DESCUENTO) AS BASE_IMPONIBLE,FAC.SUBTOTAL_CON_IMPUESTO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB FAC
    JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATD ON ATD.ID_TIPO_DOCUMENTO = FAC.TIPO_DOCUMENTO_ID
    WHERE ATD.ID_TIPO_DOCUMENTO IN (1,5)
    AND   FAC.NUMERO_FACTURA_SRI = Cv_NumFactura
    AND (SELECT IEG.COD_EMPRESA 
         FROM DB_COMERCIAL.INFO_PUNTO IPT,
              DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
              DB_COMERCIAL.INFO_EMPRESA_ROL IER,
              DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
         WHERE IPT.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
         AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
         AND IER.EMPRESA_COD = IEG.COD_EMPRESA
         AND IPT.ID_PUNTO = FAC.PUNTO_ID) = Cn_CodEmpresa;

  CURSOR C_GetOficinaByIdentificacion(Cv_CodEmpresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Cv_Identificacion     DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                      Cv_descripcionTipoRol DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE) IS
    SELECT IPER.ID_PERSONA_ROL,IPER.OFICINA_ID
      FROM DB_COMERCIAL.INFO_PERSONA             PER 
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON PER.ID_PERSONA     = IPER.PERSONA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_ROL         IER  ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.ADMI_ROL                 AR   ON AR.ID_ROL          = IER.ROL_ID
      JOIN DB_COMERCIAL.ADMI_TIPO_ROL            ATR  ON ATR.ID_TIPO_ROL    = AR.TIPO_ROL_ID
     WHERE PER.IDENTIFICACION_CLIENTE = Cv_Identificacion
       AND ATR.DESCRIPCION_TIPO_ROL   = Cv_descripcionTipoRol
       AND IER.EMPRESA_COD            = Cv_CodEmpresa
       AND IPER.ESTADO                = 'Activo';

  -- Costo Query: 5
  CURSOR C_GetTotalPago(Cv_NumDocSustento     DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_FACTURA%TYPE,
                        Cn_IdPagoAutomatico   DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE) IS
    SELECT ROUND(SUM(IPAD.MONTO),2) AS VALOR_TOTAL
    FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD
    WHERE IPAD.NUMERO_FACTURA    =  Cv_NumDocSustento
    AND IPAD.PAGO_AUTOMATICO_ID  =  Cn_IdPagoAutomatico;


  Ln_IdPagoAutomatico         DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE;
  Ln_TotalPago                DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE;
  Ln_IdOficina                DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
  Ln_ValorPago                NUMBER;
  Ln_ValorPagoDif             NUMBER                     := 0;
  Ln_Indsx                    NUMBER;
  Ln_Indsx2                   NUMBER;
  Ln_Indx3                    NUMBER;
  Ln_CounterCommit            NUMBER                     := 0;
  Ln_Contador                 NUMBER                     := 0;
  Lv_Delimitador              VARCHAR2(1)                :=',';
  Lr_InfoDocumento            C_GetInfoDocumento%ROWTYPE := NULL;
  InfoPagosAutomaticoCab      T_InfoPagoAutomaticoCab;
  Lt_InfoAnticiposDet         T_AnticiposDet;
  Lr_InfoPagoAutomaticoCab    DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.TpInfoPagosAutomaticoCab;
  InfoPagosAutomaticoDet      T_InfoPagoAutomaticoDet;
  Lr_InfoFactPagAutomaticoDet DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.TpInfoFactPagAutomaticoDet;
  Lr_InfoPagoAutomaticoDet    DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET%ROWTYPE;
  Ln_NumFactura               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
  Lv_ComentarioAnticipo       VARCHAR2(100) := 'Anticipo generado por pago autom�tico  ';
  Lr_IdTipoDocumento          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
  Lr_NumeroPago               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE;
  Lr_IdPago                   DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;
  Lv_TipoDocumento            VARCHAR2(10);
  Lv_Error                    VARCHAR2(4000);
  Lv_NombreProceso            VARCHAR2(3000);
  Lc_Total                    C_GetTotalPago%ROWTYPE;
  La_FacturasProcesar         T_FacturasProcesar;
  Lr_Factura                  Lr_FacturasProcesar;
  Lr_DetalleAnticipo          Lr_AnticiposDet := NULL;
  Lrf_InfoPagoAutomaticoCab   SYS_REFCURSOR;
  Lrf_InfoFacturasSelect      SYS_REFCURSOR;
  Lrf_InfoDocumento           SYS_REFCURSOR;
  Lc_InfoDocumento            C_GetInfoDocumento%ROWTYPE;
  Ln_Cont                     NUMBER;
  Ln_Pos                      NUMBER := 0;
  Lr_NumeroAnt               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE;

  Le_ExceptionProceso         EXCEPTION;
BEGIN
  --
    IF Lrf_InfoPagoAutomaticoCab%ISOPEN THEN
      CLOSE Lrf_InfoPagoAutomaticoCab;
    END IF;

    DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GET_LIST_INFO_PAG_AUT_CAB(Pv_EmpresaCod,
                                                                   Pv_IdsRetSelecionadas,
                                                                   Lrf_InfoPagoAutomaticoCab);      
    LOOP
      -- Se itera las retenciones seleccionadas a nivel de INFO PAGO AUTOMATICO CAB
      FETCH Lrf_InfoPagoAutomaticoCab BULK COLLECT INTO InfoPagosAutomaticoCab LIMIT 1000;
      Ln_Indsx := InfoPagosAutomaticoCab.FIRST;
      WHILE (Ln_Indsx IS NOT NULL)
        LOOP
          Lr_InfoPagoAutomaticoCab:=InfoPagosAutomaticoCab(Ln_Indsx);
          DBMS_OUTPUT.PUT_LINE(Lr_InfoPagoAutomaticoCab.IDENTIFICACION_CLIENTE);

          IF Lr_InfoPagoAutomaticoCab.ESTADO = 'Pendiente' THEN 
          ------------------------------------------------
          IF Lrf_InfoFacturasSelect%ISOPEN THEN
            CLOSE Lrf_InfoFacturasSelect;
          END IF;
          -- Obtengo los n�meros de facturas asociadas
          DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GET_LIST_FACT_SELECT(Pv_EmpresaCod,
                                                                    Lr_InfoPagoAutomaticoCab.ID_PAGO_AUTOMATICO,
                                                                    Lrf_InfoFacturasSelect);

          LOOP
          -- Se itera los detalles de retenciones seleccionadas a nivel de INFO PAGO AUTOMATICO DET
            FETCH Lrf_InfoFacturasSelect BULK COLLECT INTO InfoPagosAutomaticoDet LIMIT 1000;
            Ln_Indsx2 := InfoPagosAutomaticoDet.FIRST;
            WHILE (Ln_Indsx2 IS NOT NULL)
              LOOP
                Lr_InfoFactPagAutomaticoDet:=InfoPagosAutomaticoDet(Ln_Indsx2);
                DBMS_OUTPUT.PUT_LINE(Lr_InfoFactPagAutomaticoDet.NUMERO_FACTURA);

                IF C_GetTotalPago%ISOPEN THEN
                CLOSE C_GetTotalPago;
                END IF;

                OPEN C_GetTotalPago(Lr_InfoFactPagAutomaticoDet.NUMERO_FACTURA,Lr_InfoPagoAutomaticoCab.ID_PAGO_AUTOMATICO);
                FETCH C_GetTotalPago
                INTO Lc_Total;
                CLOSE C_GetTotalPago;

                Ln_TotalPago := NVL(Lc_Total.VALOR_TOTAL,0);
                -------------------------------------------------------------------
                Ln_NumFactura := SUBSTR(Lr_InfoFactPagAutomaticoDet.NUMERO_FACTURA,0,3)||'-'||SUBSTR(Lr_InfoFactPagAutomaticoDet.NUMERO_FACTURA,4,3)||'-'||SUBSTR(Lr_InfoFactPagAutomaticoDet.NUMERO_FACTURA,7);

                DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GET_INFO_DOCUMENTO(Pv_EmpresaCod,Ln_NumFactura,Lrf_InfoDocumento);

                DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GENERA_PAGO(
                                                                    Ln_TotalPago,
                                                                    Pv_EmpresaCod,
                                                                    Pv_UsrCreacion,
                                                                    Lr_InfoPagoAutomaticoCab.ID_PAGO_AUTOMATICO,
                                                                    Lr_InfoFactPagAutomaticoDet.NUMERO_FACTURA,
                                                                    Lrf_InfoDocumento,
                                                                    Ln_ValorPagoDif,
                                                                    Lt_InfoAnticiposDet
                                                                );
                ------  Genera Anticipo si es necesario -------------------------
                IF C_GetInfoDocumento%ISOPEN THEN
                  CLOSE C_GetInfoDocumento;
                END IF;

                ------- Fin anticipo --------------------------------------------

                CLOSE Lrf_InfoDocumento; 
                ------------------------------------------------------------------
                Ln_Indsx2 := InfoPagosAutomaticoDet.NEXT(Ln_Indsx2);
              END LOOP;
              EXIT
                WHEN Lrf_InfoFacturasSelect%notfound;

          END LOOP;

          CLOSE Lrf_InfoFacturasSelect;
          --------------------------------------------------
          END IF;
          Ln_Indsx := InfoPagosAutomaticoCab.NEXT(Ln_Indsx);

        END LOOP;

        EXIT
          WHEN Lrf_InfoPagoAutomaticoCab%notfound;

    END LOOP;

    CLOSE Lrf_InfoPagoAutomaticoCab;
    Pv_Status  := 'OK';
    Pv_Mensaje := 'OK';
    EXCEPTION
    WHEN Le_ExceptionProceso THEN
      Pv_Status  := 'Error';
      Pv_Mensaje := Lv_Error;
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                                  'FNKG_PROCESO_MASIVO_DEB.P_PROCESAR_DEBITOS_P', 
                                                   Lv_Error);

    WHEN OTHERS THEN
      Pv_Status  := 'Error';
      Pv_Mensaje := 'Error';
      ROLLBACK;
      Lv_Error  := 'Error en FNKG_PAGO_AUTOMATICO.P_PROCESAR_RETENCIONES - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('DB_FINANCIERO.FNKG_PAGO_AUTOMATICO',
                                                  'DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_PROCESAR_RETENCIONES', 
                                                   Lv_Error);

  END P_PROCESAR_RETENCIONES;

  PROCEDURE P_GET_INFO_DOCUMENTO(
    Pv_CodEmpresa         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_NumFactura         IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    Prf_InfoDocumento     OUT SYS_REFCURSOR)
  IS
    Lcl_Query             CLOB ;
    Lv_InfoError          VARCHAR2(3000);
  BEGIN

      Lcl_Query :=' SELECT  FAC.ID_DOCUMENTO,
                            FAC.OFICINA_ID ,
                            FAC.PUNTO_ID ,
                            (FAC.SUBTOTAL-FAC.SUBTOTAL_DESCUENTO) AS BASE_IMPONIBLE,
                            FAC.SUBTOTAL_CON_IMPUESTO,
                            FAC.ESTADO_IMPRESION_FACT, 
                            FAC.NUMERO_FACTURA_SRI,
                            FAC.VALOR_TOTAL, 
                            FAC.FE_CREACION,
                            FAC.TIPO_DOCUMENTO_ID 
                    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB FAC
                    JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATD ON ATD.ID_TIPO_DOCUMENTO = FAC.TIPO_DOCUMENTO_ID
                    WHERE ATD.CODIGO_TIPO_DOCUMENTO IN (''FAC'',''FACP'')
                    AND   FAC.NUMERO_FACTURA_SRI = '''||Pv_NumFactura||'''
                    AND (SELECT IEG.COD_EMPRESA 
                         FROM DB_COMERCIAL.INFO_PUNTO IPT,
                              DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                              DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                              DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
                         WHERE IPT.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                         AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
                         AND IER.EMPRESA_COD = IEG.COD_EMPRESA
                         AND IPT.ID_PUNTO = FAC.PUNTO_ID) = '''||Pv_CodEmpresa||'''';
      
    OPEN Prf_InfoDocumento FOR Lcl_Query;

    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError := 'Error en FNKG_PAGO_AUTOMATICO.P_GET_INFO_DOCUMENTO - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_AUTOMATICO.P_GET_INFO_DOCUMENTO', 
                                            Lv_InfoError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_GET_INFO_DOCUMENTO;

  PROCEDURE P_GET_LIST_INFO_PAG_AUT_CAB(
    Pv_CodEmpresa                 IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IdsRetSelecionadas         VARCHAR2,
    Prf_InfoPagoAutomaticoCab     OUT SYS_REFCURSOR)
  IS
    Lcl_Query                 CLOB ;
    Lv_InfoError              VARCHAR2(3000);
  BEGIN

      Lcl_Query :=' SELECT  IPA.ID_PAGO_AUTOMATICO,
                    IPA.OFICINA_ID,
                    IPA.RUTA_ARCHIVO,       
                    IPA.ESTADO,
                    IPA.IDENTIFICACION_CLIENTE ,
                    IPA.TIPO_FORMA_PAGO
                    FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB IPA
                    WHERE IPA.ID_PAGO_AUTOMATICO IN ('||Pv_IdsRetSelecionadas||') AND IPA.ESTADO <> ''Eliminado'' AND IPA.ESTADO <> ''Error'' ';
      
    OPEN Prf_InfoPagoAutomaticoCab FOR Lcl_Query;

    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError := 'Error en FNKG_PAGO_AUTOMATICO.P_GET_LIST_INFO_PAG_AUT_CAB - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_AUTOMATICO.P_GET_LIST_INFO_PAG_AUT_CAB', 
                                            Lv_InfoError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_GET_LIST_INFO_PAG_AUT_CAB;


  PROCEDURE P_GET_LIST_FACT_SELECT(
    Pv_CodEmpresa                 IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IdPagoAutomaticoCab        IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE,
    Prf_ListFacturasSelect        OUT SYS_REFCURSOR)
  IS
    Lcl_Query                     CLOB ;
    Lv_InfoError                  VARCHAR2(3000);
  BEGIN

      Lcl_Query :=' SELECT DISTINCT(IPAD.NUMERO_FACTURA)
                    FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD
                    WHERE IPAD.PAGO_AUTOMATICO_ID = '||Pv_IdPagoAutomaticoCab||' AND IPAD.ESTADO <> ''Eliminado'' AND IPAD.ESTADO <> ''Error'' ';
      
    OPEN Prf_ListFacturasSelect FOR Lcl_Query;

    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError := 'Error en FNKG_PAGO_AUTOMATICO.P_GET_LIST_FACT_SELECT - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_AUTOMATICO.P_GET_LIST_FACT_SELECT', 
                                            Lv_InfoError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_GET_LIST_FACT_SELECT;


  PROCEDURE P_GENERA_PAGO(
                          Fn_ValorPagado      IN  DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
                          Fv_EmpresaId        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                          Fv_UsrCreacion      IN  DB_FINANCIERO.INFO_PAGO_CAB.USR_CREACION%TYPE,
                          Fn_IdPagoAutomatico IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.PAGO_AUTOMATICO_ID%TYPE,
                          Fn_NumDocSustento   IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_FACTURA%TYPE,
                          Frf_Facturas        IN  SYS_REFCURSOR,
                          Fn_ValorPagoDif     OUT DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
                          Ft_InfoAnticiposDet OUT T_AnticiposDet
                         )
  IS
  CURSOR C_GetInfoPagoAutomaticoDet(Cn_IdPagoAutomatico DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE,
                                    Cn_CodEmpresa       DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.EMPRESA_COD%TYPE,
                                    Cv_NumFactura       DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_FACTURA%TYPE)
    IS
      SELECT  
        IPAD.ID_DETALLE_PAGO_AUTOMATICO,
        IPAD.PAGO_AUTOMATICO_ID,
        IPAD.PERSONA_EMPRESA_ROL_ID, 
        IPAD.DOCUMENTO_ID,       
        IPAD.FORMA_PAGO_ID,       
        IPAD.OBSERVACION,       
        IPAD.NUMERO_REFERENCIA,       
        IPAD.BASE_IMPONIBLE,       
        IPAD.BASE_IMPONIBLE_CAL,       
        IPAD.CODIGO_IMPUESTO,       
        IPAD.PORCENTAJE_RETENCION,       
        IPAD.NUMERO_FACTURA,
        IPAD.MONTO,       
        IPAD.EMPRESA_COD, 
        IPAD.ESTADO,
        IPAD.FECHA,
        IPAD.FE_CREACION
        FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD
        WHERE IPAD.PAGO_AUTOMATICO_ID = Cn_IdPagoAutomatico
        AND   IPAD.EMPRESA_COD        = Cn_CodEmpresa 
        AND   IPAD.NUMERO_FACTURA     = Cv_NumFactura
        AND   IPAD.ESTADO <> 'Eliminado' AND IPAD.ESTADO <> 'Error' AND IPAD.ESTADO <> 'No Procesa'
        ORDER BY IPAD.MONTO DESC;

  CURSOR C_GetInfoPagoDet(Cn_IdPago       DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE)
    IS
      SELECT  
        IPD.ID_PAGO_DET
      FROM DB_FINANCIERO.INFO_PAGO_DET IPD
      WHERE IPD.PAGO_ID =  Cn_IdPago;

    Lr_InfoPagoAutomaticoDet    C_GetInfoPagoAutomaticoDet%ROWTYPE;
    Lr_InfoPagoDet              C_GetInfoPagoDet%ROWTYPE;
    Lr_NumeroPago               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE;
    Lr_IdTipoDocumento          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Lv_CodTipoDocumento         DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'PAG';
    Lr_IdPago                   DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;
    Lr_InfoPagoAutDet           DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET%ROWTYPE;
    Lt_InfoPagosAutomaticoDet   T_InfoPagosAutomaticoDet;
    Lt_InfoPagDet               T_InfoPagDet;
    Lv_Error                    VARCHAR2(500);
    Lv_ComentarioPago           VARCHAR2(100)  := 'Pago generado por proceso autom�tico.';
    Lv_ComentarioAntc           VARCHAR2(100)  := 'Anticipo generado por proceso autom�tico.';
    Lv_EstadoFactura            VARCHAR2(200);
    Ln_SaldoFactura             NUMBER;
    Ln_TotalPagNc               NUMBER;
    Ln_ValorPago                NUMBER;
    Ln_Indx                     NUMBER;
    Ln_ContadorPuntos           NUMBER := 0;
    Ln_ContadorAnt              NUMBER := 0;
    Ln_Indx2                    NUMBER := 0;
    Ln_Indx3                    NUMBER := 0;
    Lb_CierraFactura            BOOLEAN;
    Lb_GeneraAnticipo           BOOLEAN;
    Le_ExceptionProceso         EXCEPTION;
    Lv_NombreProceso            VARCHAR2(3000);
    Lv_MessageError             VARCHAR2(1000) := '';
    La_FacturasProcesar         T_FacturasProcesar;
    Lr_Factura                  Lr_FacturasProcesar;
    Lr_DetalleAnticipo          Lr_AnticiposDet := NULL;
    Ln_ValorPagado              NUMBER := Fn_ValorPagado;
    Lt_ArrayPunto               T_ArrayIds;
    Lv_EstadoPago               VARCHAR2(20) := 'Cerrado';
    
    Ln_ValorPagoCab             NUMBER := 0;
    Ln_Sobrante NUMBER := 0;
    Lb_EstadoPago BOOLEAN := TRUE;
    Lr_IdAnt                   DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;
    Lr_IdPagAnt DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;
    Ln_TotalPagoAnt NUMBER:=0;
    Lb_AntInicial BOOLEAN := FALSE;
    Lv_ComentarioPagoAnt VARCHAR2(1000);
    Ln_AnticipoSobrante NUMBER:=0;
    --
  BEGIN
     LOOP
          FETCH Frf_Facturas BULK COLLECT INTO La_FacturasProcesar LIMIT 1000;
          Ln_Indx := La_FacturasProcesar.FIRST; 

            WHILE (Ln_Indx IS NOT NULL)       
              LOOP                  
                  Lr_Factura := La_FacturasProcesar(Ln_Indx);
                  --        
                   Lb_CierraFactura  := FALSE;
                   Lb_GeneraAnticipo := FALSE;
                   
                   --Estados iniciales cmo los declarados
                   Lb_EstadoPago  := TRUE;
                   Lb_AntInicial  := FALSE;
                   
                   Ln_TotalPagoAnt :=0;
                   Ln_ValorPagoCab := 0; --Pagos
                   Ln_Sobrante :=0 ;
                   Ln_SaldoFactura :=0;
                   Ln_AnticipoSobrante :=0;
                   
                    IF Ln_ValorPagado > 0 THEN

                      --Obtiene el saldo de la factura
                      DB_FINANCIERO.FNCK_CONSULTS.P_SALDO_X_FACTURA(Lr_Factura.ID_DOCUMENTO, NULL, Ln_SaldoFactura, Lv_Error);
                      DBMS_OUTPUT.PUT_LINE('P_SALDO_X_FACTURA '||Ln_SaldoFactura);

                      --
                      IF Lv_Error IS NOT NULL THEN
                          --
                        RAISE Le_ExceptionProceso;
                          --
                      END IF;
                      
                      IF Ln_SaldoFactura < 0 THEN
                        Lv_Error := 'El saldo de la factura no puede ser negativo. Favor revisar el idDocumento '||Lr_Factura.ID_DOCUMENTO;
                        RAISE Le_ExceptionProceso;
                      END IF;

                      IF Ln_SaldoFactura <= 0 THEN
                          --
                        Lv_CodTipoDocumento := 'ANT';
                        Lv_ComentarioPago   := Lv_ComentarioAntc;
                        Lv_EstadoPago := 'Pendiente';
                        Lb_AntInicial := TRUE;
                          --
                      END IF;

                      /* Funcion para obtener la numeracion del pago */
                      Lr_NumeroPago := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_NUMERACION(Fv_EmpresaId, 
                                                                                              Lr_Factura.OFICINA_ID,
                                                                                              Lv_CodTipoDocumento,
                                                                                              Lv_NombreProceso,
                                                                                              Lv_Error);

                      IF Lr_NumeroPago IS NULL OR Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionProceso;
                      END IF;

                      /* Funcion para obtener el tipo de documento */
                      Lr_IdTipoDocumento := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_TIPO_DOCUMENTO(Lv_CodTipoDocumento,
                                                                                                       'Activo',
                                                                                                       Lv_NombreProceso,
                                                                                                       Lv_Error);

                      IF Lr_IdTipoDocumento IS NULL OR Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionProceso;
                      END IF;

                      /* Funcion para crear y obtener el id del pago */
                      DBMS_OUTPUT.PUT_LINE('CREA CABECERA PAGO VALOR '||Ln_ValorPagado);
                      
                      Lr_IdPago := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_CREA_PAGO(Lr_Factura.PUNTO_ID,
                                                                                     Lr_Factura.OFICINA_ID,
                                                                                     Fv_EmpresaId,
                                                                                     NULL,
                                                                                     Lr_NumeroPago,
                                                                                     Ln_ValorPagado,
                                                                                     Lv_EstadoPago,
                                                                                     Lv_ComentarioPago,
                                                                                     Fv_UsrCreacion,
                                                                                     Lr_IdTipoDocumento,
                                                                                     NULL,
                                                                                     Lv_NombreProceso,
                                                                                     Lv_Error);

                      IF Lr_IdPago IS NULL OR Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionProceso;
                      END IF;

                      IF Ln_SaldoFactura = 0 THEN
                          --
                        Fn_ValorPagoDif   := 0;
                        Lb_GeneraAnticipo := FALSE;
                          --
                      ELSE
                        IF Ln_SaldoFactura = Ln_ValorPagado THEN
                          Lb_CierraFactura := TRUE;
                          Ln_ValorPago     := Ln_ValorPagado;
                          Fn_ValorPagoDif  := Ln_ValorPagado - Ln_SaldoFactura;
                        ELSIF Ln_SaldoFactura < Ln_ValorPagado THEN
                          Lb_CierraFactura := TRUE;
                          Lb_GeneraAnticipo:= TRUE;
                          Ln_ValorPago     := Ln_SaldoFactura;
                          Fn_ValorPagoDif  := Ln_ValorPagado - Ln_SaldoFactura;
                        ELSE
                          Ln_ValorPago     := Ln_ValorPagado;
                          Fn_ValorPagoDif  := 0;
                        END IF;
                      END IF;

                      /*Actualiza Factura*/
                      IF Lb_CierraFactura THEN

                        Lv_EstadoFactura := 'Cerrado';

                        DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SET_FACTURA_ESTADO(Lr_Factura.ID_DOCUMENTO, 
                                                                                   Lv_EstadoFactura,
                                                                                   Lv_NombreProceso,
                                                                                   Lv_Error);

                        IF Lv_Error IS NOT NULL THEN
                          RAISE Le_ExceptionProceso;
                        END IF;

                      ELSE

                        Lv_EstadoFactura := Lr_Factura.ESTADO_IMPRESION_FACT;

                      END IF;

                      /* Proceso para crear el historial de la factura*/
                      DBMS_OUTPUT.PUT_LINE('CREA HISTORIAL'||Lr_Factura.ID_DOCUMENTO);

                      DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_FACTURA_HISTORIAL(Lr_Factura.ID_DOCUMENTO,
                                                                                     Lv_EstadoFactura,
                                                                                     Fv_UsrCreacion,
                                                                                     Lv_NombreProceso,
                                                                                     Lv_Error);

                      IF Lv_Error IS NOT NULL THEN
                       RAISE Le_ExceptionProceso;
                      END IF;

                      -----------------------------------------------------------------------------------------------------------

                      IF C_GetInfoPagoAutomaticoDet%ISOPEN THEN
                        CLOSE C_GetInfoPagoAutomaticoDet;
                      END IF;
                      --
                      OPEN C_GetInfoPagoAutomaticoDet(Fn_IdPagoAutomatico,
                                                      Fv_EmpresaId,
                                                      Fn_NumDocSustento);
                      --
                      LOOP
                        FETCH C_GetInfoPagoAutomaticoDet BULK COLLECT INTO Lt_InfoPagosAutomaticoDet LIMIT 1000;
                        Ln_Indx2 := Lt_InfoPagosAutomaticoDet.FIRST;
                        WHILE (Ln_Indx2 IS NOT NULL)
                        --FOR Ln_Indx2 IN Lt_InfoPagosAutomaticoDet.FIRST .. Lt_InfoPagosAutomaticoDet.LAST LOOP
                          LOOP
                          
                            Lr_InfoPagoAutomaticoDet:=Lt_InfoPagosAutomaticoDet(Ln_Indx2);

                            DBMS_OUTPUT.PUT_LINE(Lr_InfoPagoAutomaticoDet.ID_DETALLE_PAGO_AUTOMATICO||'---'||Lr_InfoPagoAutomaticoDet.NUMERO_FACTURA);

                            UPDATE DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET DET
                              SET ESTADO = 'Procesado'
                            WHERE DET.ID_DETALLE_PAGO_AUTOMATICO = Lr_InfoPagoAutomaticoDet.ID_DETALLE_PAGO_AUTOMATICO;

                            /* Crea el historial del pago */

                            DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_CREA_PAGO_AUT_DET_HIST(Lr_InfoPagoAutomaticoDet.ID_DETALLE_PAGO_AUTOMATICO,
                                                                                        'Se actualiza detalle retenci�n a estado Procesado.',
                                                                                        'Procesado',
                                                                                        Fv_UsrCreacion,
                                                                                        '127.0.0.1',
                                                                                        Lv_NombreProceso,
                                                                                        Lv_Error);
                            /* Crea el detalle del pago */
                            IF Lr_InfoPagoAutomaticoDet.MONTO >  0 THEN
                                Lr_InfoPagoAutomaticoDet.MONTO := Lr_InfoPagoAutomaticoDet.MONTO + Ln_Sobrante;
                                
                                Lr_InfoPagoAutDet.ID_DETALLE_PAGO_AUTOMATICO := Lr_InfoPagoAutomaticoDet.ID_DETALLE_PAGO_AUTOMATICO;
                                Lr_InfoPagoAutDet.FECHA                      := Lr_InfoPagoAutomaticoDet.FECHA;
                                Lr_InfoPagoAutDet.USR_CREACION               := Fv_UsrCreacion;
                                Lr_InfoPagoAutDet.FORMA_PAGO_ID              := Lr_InfoPagoAutomaticoDet.FORMA_PAGO_ID;
                                Lr_InfoPagoAutDet.NUMERO_REFERENCIA          := Lr_InfoPagoAutomaticoDet.NUMERO_REFERENCIA;
                                
                                IF(Ln_SaldoFactura-Lr_InfoPagoAutomaticoDet.MONTO<0) THEN
                                  Lr_InfoPagoAutDet.MONTO                      := Ln_SaldoFactura;  
                                  Ln_Sobrante := ROUND((Lr_InfoPagoAutomaticoDet.MONTO - Ln_SaldoFactura),2);
                                  dbms_output.put_line('Pagamos el saldo y tenemos un sobrante de '||Ln_Sobrante);
                                ELSE
                                  Lr_InfoPagoAutDet.MONTO := Lr_InfoPagoAutomaticoDet.MONTO;
                                  Ln_Sobrante := 0;
                                END IF;
                          
                                
                                IF(Ln_SaldoFactura>0) then
                                
                                  Lr_InfoPagoAutDet.OBSERVACION                := Lr_InfoPagoAutomaticoDet.OBSERVACION;
                                  Lr_InfoPagoAutDet.ESTADO                     := 'Cerrado';  
                                  Lb_EstadoPago := Lb_EstadoPago AND TRUE;
                                  Lr_InfoPagoAutDet.DOCUMENTO_ID               := Lr_Factura.ID_DOCUMENTO;
                                ELSE
                                  Lr_InfoPagoAutDet.OBSERVACION                := Lv_ComentarioPago||Lr_InfoPagoAutomaticoDet.OBSERVACION;
                                  Lr_InfoPagoAutDet.ESTADO                     := 'Pendiente';
                                  Lb_EstadoPago := Lb_EstadoPago AND FALSE;
                                  Lr_InfoPagoAutDet.DOCUMENTO_ID               := null;
                                  
                                END IF;
                                
                                Lr_IdPagAnt := Lr_IdPago;
                                IF Ln_SaldoFactura>0 THEN
                                   Ln_SaldoFactura := Ln_SaldoFactura - Lr_InfoPagoAutDet.MONTO; 
                                END IF;
                                
                                -----------------------Creamos la cabecera de los anticipos -------------
                                --------------------   (*solo si hay pagos previos*)  -------------------
                                                           -------------------
                      if (Ln_SaldoFactura<=0) and not Lb_AntInicial and ln_Sobrante>0 and Lr_IdAnt is null then
                        Lv_CodTipoDocumento := 'ANT';
                        dbms_output.put_line('Creamos la cabecera del anticipo');
                        /* Funcion para obtener la numeracion del pago */
                        Lr_NumeroPago := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_NUMERACION(Fv_EmpresaId, 
                                                                                                Lr_Factura.OFICINA_ID,
                                                                                                Lv_CodTipoDocumento,
                                                                                                Lv_NombreProceso,
                                                                                                Lv_Error);

                        IF Lr_NumeroPago IS NULL OR Lv_Error IS NOT NULL THEN
                          RAISE Le_ExceptionProceso;
                        END IF;

                        /* Funcion para obtener el tipo de documento */
                        Lr_IdTipoDocumento := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_TIPO_DOCUMENTO(Lv_CodTipoDocumento,
                                                                                                       'Activo',
                                                                                                       Lv_NombreProceso,
                                                                                                       Lv_Error);
                        --Crea la cabecera de los anticipos
                        Lr_IdAnt := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_CREA_PAGO(Lr_Factura.PUNTO_ID,
                                                                                     Lr_Factura.OFICINA_ID,
                                                                                     Fv_EmpresaId,
                                                                                     NULL,
                                                                                     Lr_NumeroPago,
                                                                                     0,
                                                                                     'Pendiente',
                                                                                     Lv_ComentarioAntc,
                                                                                     Fv_UsrCreacion,
                                                                                     Lr_IdTipoDocumento,
                                                                                     NULL,
                                                                                     Lv_NombreProceso,
                                                                                     Lv_Error);
                        Lr_IdPagAnt := Lr_IdAnt;

                        END IF;
                                -------------------------Fin de cabecera de anticipos--------------------
                                dbms_output.put_line('SaldoFacutra '||Ln_SaldoFactura);
                                if Ln_SaldoFactura = 0 and not Lb_AntInicial then --*
                                  Lr_IdPagAnt := Lr_IdPago;
                                end if;
                                
                                
                                --Si hay saldo positivo, crea el detalle del pago/ant
                                if Ln_SaldoFactura>=0 THEN
                                
                                  if Lb_AntInicial then--
                                    Lr_InfoPagoAutDet.MONTO := Lr_InfoPagoAutomaticoDet.MONTO;
                                  end if;
                                  if(Ln_TotalPagoAnt>0) then--Para llevar la cuenta de los Anticipos Iniciales
                                     Lr_InfoPagoAutDet.MONTO := Lr_InfoPagoAutomaticoDet.MONTO - Ln_TotalPagoAnt;
                                  end if;
                                  
                                  dbms_output.put_line('Tratamos de crear el del pago/ant(caB) '||Lr_IdPagAnt||' por $'||Lr_InfoPagoAutDet.MONTO);
                                  IF Lr_InfoPagoAutDet.MONTO > 0  THEN
                                    DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_CREA_DETALLE_PAGO(Lr_IdPagAnt,
                                                                                           Lr_InfoPagoAutDet,
                                                                                           Lv_NombreProceso,
                                                                                           Lv_Error);
                                    dbms_output.put_line('Se crea el del pago/ant(caB) '||Lr_IdPagAnt||' por $'||Lr_InfoPagoAutDet.MONTO);
                                  END IF;
                                  
                                  
                                  IF Ln_SaldoFactura >= 0 and not Lb_AntInicial THEN
                                    Ln_ValorPagoCab:=Ln_ValorPagoCab + Lr_InfoPagoAutDet.MONTO;  
                                    dbms_output.put_line('Sumamos... el total del PAGO va '||Ln_ValorPagoCab);
                                  ELSIF Lb_AntInicial then
                                    Ln_TotalPagoAnt:= Ln_TotalPagoAnt + Lr_InfoPagoAutDet.MONTO;
                                    dbms_output.put_line('Sumamos... el total del Anticipo '||Ln_TotalPagoAnt);
                                  END if;
                                  
                                  --Actualizamos el saldo de la factura x cada pago cruzado con la factura
                                  
                                  
                                  dbms_output.put_line('Saldo depues de pagar '||Ln_SaldoFactura);

                                --Coordinamos el sobrante al ultimo
                                  IF Ln_Sobrante>0 and not Lb_AntInicial then
                                    Lr_InfoPagoAutDet.MONTO := Ln_Sobrante;
                                    Lr_InfoPagoAutDet.OBSERVACION                := Lv_ComentarioAntc||Lr_InfoPagoAutomaticoDet.OBSERVACION;
                                    Lr_InfoPagoAutDet.ESTADO                     := 'Pendiente';
                                    Lb_EstadoPago := Lb_EstadoPago AND FALSE;
                                    Lr_InfoPagoAutDet.DOCUMENTO_ID               := null;
                                    DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_CREA_DETALLE_PAGO(Lr_IdAnt,
                                                                                           Lr_InfoPagoAutDet,
                                                                                           Lv_NombreProceso,
                                                                                           Lv_Error);
                                    dbms_output.put_line('Se crea el del anticipo-sobrante(caB) '||Lr_IdAnt||' por $'||Lr_InfoPagoAutDet.MONTO);
                                    --Ln_TotalPagoAnt:= Ln_TotalPagoAnt + Lr_InfoPagoAutDet.MONTO;
                                    Ln_AnticipoSobrante := Ln_AnticipoSobrante + Ln_Sobrante;
                                  END IF;
                                  
                                   IF Ln_Sobrante>0 and not Lb_AntInicial then
                                    --Ln_TotalPagoAnt:= Ln_TotalPagoAnt + Ln_Sobrante;
                                    
                                    dbms_output.put_line('Sumamos... el total del sobrante '||Ln_TotalPagoAnt);
                                    Ln_Sobrante := 0; --resto el sobrante xq ya lo sum_e
                                  end if;

                                END IF;--FIN DE SOBRANTE
                                
                            IF Lv_Error IS NOT NULL THEN
                             RAISE Le_ExceptionProceso;
                            END IF;

                          END IF;-- monto>0
                          Ln_Indx2 := Lt_InfoPagosAutomaticoDet.NEXT(Ln_Indx2);
                        END LOOP; --end while  --end WHILE (Ln_Indx2 IS NOT NULL)
                        

                      EXIT WHEN C_GetInfoPagoAutomaticoDet%NOTFOUND;  
                      --
                      CLOSE C_GetInfoPagoAutomaticoDet;

                     END LOOP;
                     
                     IF Lb_EstadoPago and Ln_SaldoFactura = 0 THEN
                      Lv_EstadoPago := 'Cerrado';
                     ELSE
                      Lv_EstadoPago := 'Pendiente';
                     END IF;

                       ------------------------------------------------------------------------------------------------------------

                      IF Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionProceso;
                      END IF;
                      
                      --Actualizamos el estado de la cabecera del pago
                      --Si no se hizo ningun pago (solo anticipos)
                      if Lb_AntInicial then
                        Ln_ValorPagoCab := Ln_Sobrante;
                      end if;
                      
                      IF Lr_IdPago is not null THEN
                        UPDATE DB_FINANCIERO.INFO_PAGO_CAB
                          set VALOR_TOTAL = Ln_ValorPagoCab
                        WHERE ID_PAGO = Lr_IdPago;
                      END IF;
                      
                     --Cuando venimos por un pago y creacion de anticipos
                      IF Ln_AnticipoSobrante>Ln_TotalPagoAnt THEN
                        Ln_TotalPagoAnt := Ln_AnticipoSobrante;
                      END IF;
                      
                      IF Lr_IdAnt is not null THEN
                        --Actualizamos el valor de la cabecera de los anticipos
                        UPDATE DB_FINANCIERO.INFO_PAGO_CAB
                          SET VALOR_TOTAL = Ln_TotalPagoAnt
                        WHERE ID_PAGO = Lr_IdAnt;
                      END IF;
                      /* Actualizamos el valor total del pago */
                      DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SET_VALOR_TOTAL_PAGO(Lr_IdPago,
                                                                                   Ln_ValorPagoCab,
                                                                                   Lv_NombreProceso,
                                                                                   Lv_Error);

                      IF Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionProceso;
                      END IF; 

                      /* Crea el historial del pago */
                      
                      if Lr_IdPago is not null then
                        IF Ln_SaldoFactura =0 AND Lb_AntInicial THEN --Creado por saldoFac 0 y anticipos
                          Lv_EstadoPago := 'Pendiente';
                          Lv_ComentarioPagoAnt := Lv_ComentarioAntc;
                        ELSE
                          Lv_EstadoPago := 'Cerrado'; --Es un pago
                          Lv_ComentarioPagoAnt := Lv_ComentarioPago;
                        END IF;
                      
                      DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_HISTORIAL_PAGO(Lr_IdPago,
                                                                                  Lv_EstadoPago,
                                                                                  Fv_UsrCreacion,
                                                                                  NULL,
                                                                                  Lv_ComentarioPagoAnt,
                                                                                  Lv_NombreProceso,
                                                                                  Lv_Error);
                    END IF;
                    IF Lr_IdAnt is not null then
                      DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_HISTORIAL_PAGO(Lr_IdAnt,
                                                                                    'Pendiente',
                                                                                    Fv_UsrCreacion,
                                                                                    NULL,
                                                                                    Lv_ComentarioAntc,
                                                                                    Lv_NombreProceso,
                                                                                    Lv_Error);
                    END IF;

                      IF Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionProceso;
                      END IF;

                    END IF;

              Ln_Indx    := La_FacturasProcesar.NEXT(Ln_Indx);
              UPDATE DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB CAB
              SET    ESTADO = 'Procesado'
              WHERE  CAB.ID_PAGO_AUTOMATICO = Fn_IdPagoAutomatico;
              COMMIT; 
              ----------- CONTABILIZA PAGOS DET ----------------------------------------------------------
              IF C_GetInfoPagoAutomaticoDet%ISOPEN THEN
                CLOSE C_GetInfoPagoDet;
              END IF;
              --
              OPEN C_GetInfoPagoDet(Lr_IdPago);
            --
              LOOP
                FETCH C_GetInfoPagoDet BULK COLLECT INTO Lt_InfoPagDet LIMIT 1000;
                Ln_Indx3 := Lt_InfoPagDet.FIRST;
                WHILE (Ln_Indx3 IS NOT NULL)
                  LOOP
                    Lr_InfoPagoDet:= Lt_InfoPagDet(Ln_Indx3);
                    Ln_Indx3      := Lt_InfoPagDet.NEXT(Ln_Indx3);
                  END LOOP;
                EXIT 
                  WHEN C_GetInfoPagoDet%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE('CONTABILIZA PAGO '||Lr_InfoPagoDet.ID_PAGO_DET);
                DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.PROCESAR_PAGO_ANTICIPO_MANUAL(Fv_EmpresaId,Lr_InfoPagoDet.ID_PAGO_DET, 'N',Lv_Error);

              END LOOP;
            --
              CLOSE C_GetInfoPagoDet;
              ----------------------------------------------------------------------------------------------------          
              IF Lv_Error IS NOT NULL AND Lv_Error <> 'Proceso OK' THEN
                RAISE Le_ExceptionProceso;
              END IF;
               
              END LOOP;
      
            EXIT WHEN Frf_Facturas%NOTFOUND;       

     END LOOP; 
     --          --
  EXCEPTION 
  WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    Lv_Error := 'Error en DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GENERA_PAGO - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||'Fn_IdPagoAutomatico: '||Fn_IdPagoAutomatico||' Fn_NumDocSustento: '||Fn_NumDocSustento;
                                   
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('DB_FINANCIERO.FNKG_PAGO_AUTOMATICO',
                                                'DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GENERA_PAGO', 
                                                Lv_Error);
  WHEN OTHERS THEN
    Lv_Error := 'Error en DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GENERA_PAGO - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('DB_FINANCIERO.FNKG_PAGO_AUTOMATICO',
                                                'DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.F_GENERA_PAGO', 
                                                Lv_Error);                                                                                                                               
    --
  END P_GENERA_PAGO;

  /*
    PROCEDIMIENTO QUE GRABA EL HISTORIAL DEL PAGO
  */
  PROCEDURE P_CREA_PAGO_AUT_DET_HIST(Pn_IdPagoAutDet        IN  NUMBER,
                                     Pv_Observacion         IN  VARCHAR2,
                                     Pv_Estado              IN  VARCHAR2,
                                     Pv_UsuarioCreacion     IN  VARCHAR2,
                                     Pv_IpCreacion          IN  VARCHAR2,
                                     Pv_NombreProceso       OUT VARCHAR2,
                                     Pv_Error               OUT VARCHAR2) IS  
  BEGIN
  
    INSERT
    INTO DB_FINANCIERO.INFO_PAGO_AUTOMATICO_HIST
      (
        ID_PAGO_AUTOMATICO_HIST,
        DETALLE_PAGO_AUTOMATICO_ID,
        OBSERVACION,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION
      )
      VALUES
      (
        DB_FINANCIERO.SEQ_INFO_PAGO_AUTOMATICO_HIST.NEXTVAL,
        Pn_IdPagoAutDet,
        Pv_Observacion,
        Pv_Estado,
        Pv_UsuarioCreacion,
        SYSDATE,
        Pv_IpCreacion
      );
      
  EXCEPTION
    
      WHEN OTHERS THEN
       
        Pv_NombreProceso := 'FNKG_PAGO_AUTOMATICO.P_CREA_PAGO_AUT_DET_HIST';
        Pv_Error         := SQLERRM;
  
  END P_CREA_PAGO_AUT_DET_HIST;

  PROCEDURE P_CREA_DETALLE_PAGO(
      Pn_IdPago            IN  NUMBER,
      Pr_InfoPagoAutDet    IN  DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET%ROWTYPE,
      Pv_NombreProceso     OUT VARCHAR2,
      Pv_Error             OUT VARCHAR2) IS
  BEGIN

    INSERT
    INTO DB_FINANCIERO.INFO_PAGO_DET
      (
        ID_PAGO_DET,
        PAGO_ID,
        DEPOSITADO,
        FE_CREACION,
        FE_DEPOSITO,
        USR_CREACION,
        FORMA_PAGO_ID,
        VALOR_PAGO,
        NUMERO_REFERENCIA,
        COMENTARIO,
        ESTADO,
        REFERENCIA_ID,
        REFERENCIA_DET_PAGO_AUT_ID
      )
      VALUES
      (
        DB_FINANCIERO.SEQ_INFO_PAGO_DET.NEXTVAL,
        Pn_IdPago,
        'N',
        SYSDATE,
        TO_TIMESTAMP(Pr_InfoPagoAutDet.FECHA,'YYYY-MM-DD"T"HH24:MI:SS'),
        Pr_InfoPagoAutDet.USR_CREACION,
        Pr_InfoPagoAutDet.FORMA_PAGO_ID,
        Pr_InfoPagoAutDet.MONTO,
        Pr_InfoPagoAutDet.NUMERO_REFERENCIA,
        Pr_InfoPagoAutDet.OBSERVACION,
        Pr_InfoPagoAutDet.ESTADO,
        Pr_InfoPagoAutDet.DOCUMENTO_ID,
        Pr_InfoPagoAutDet.ID_DETALLE_PAGO_AUTOMATICO
      );
      
  EXCEPTION
    
    WHEN OTHERS THEN
        
      Pv_NombreProceso := 'FNKG_PAGO_AUTOMATICO.P_CREA_DETALLE_PAGO';  
      Pv_Error         := SQLERRM;

  END P_CREA_DETALLE_PAGO;

/**
  * Documentacion para la funcion GET_VARCHAR_CLEAN
  * Funcion que limpia la cadena de caracteres especiales
  * Fv_Cadena IN VARCHAR2   Recibe la cadena a limpiar
  * Retorna:
  * En tipo varchar2 la cadena sin caracteres especiales
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 14-07-2021
  */
FUNCTION GET_VARCHAR_CLEAN(
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
            REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|�|<|>|/|%|"]|[)]+$', '')
            ,'[^A-Za-z0-9������������&()-_ ]' ,'')
            ,'������,������', 'AEIOUN aeioun')
            , Chr(9), '')
            , Chr(10), '')
            , Chr(13), ''));    --

END GET_VARCHAR_CLEAN;


  PROCEDURE P_PROCESA_RPT_TRIBUTACION(Pv_UrlFile              IN  VARCHAR2,
                                      Pv_EmpresaCod           IN  VARCHAR2,
                                      Pv_UsrCreacion          IN  VARCHAR2,
                                      Pv_Ip                   IN  VARCHAR2,
                                      Pv_Status               OUT VARCHAR2,
                                      Pv_Mensaje              OUT VARCHAR2) AS
  --Costo:5
  CURSOR C_GetRetExistente(Cv_Referencia     DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_REFERENCIA%TYPE,
                           Cv_Identificacion DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.IDENTIFICACION_CLIENTE%TYPE)
  IS
    SELECT NVL(MAX(IPAC.ID_PAGO_AUTOMATICO),NULL)
    FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB IPAC,
         DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD
    WHERE IPAC.ID_PAGO_AUTOMATICO   = IPAD.PAGO_AUTOMATICO_ID
    AND IPAC.IDENTIFICACION_CLIENTE = Cv_Identificacion
    AND IPAD.NUMERO_REFERENCIA      = Cv_Referencia;


  CURSOR C_GetInfoRetAut(Cv_IdPagAutomatico    DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE)
  IS
    SELECT IPAC.ESTADO,IPAC.USR_CREACION
    FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB IPAC,
         DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD
    WHERE IPAC.ID_PAGO_AUTOMATICO   = IPAD.PAGO_AUTOMATICO_ID
    AND   IPAC.ID_PAGO_AUTOMATICO   = Cv_IdPagAutomatico;

  CURSOR C_GetInfoPagFact(Cv_IdPagAutomatico    DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE)
  IS
    SELECT DISTINCT(IPC.ID_PAGO),IPC.VALOR_TOTAL,IPC.USR_CREACION, IDFC.NUMERO_FACTURA_SRI,IPT.LOGIN,IOG.NOMBRE_OFICINA
    FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB IPAC,
         DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD,
         DB_FINANCIERO.INFO_PAGO_CAB IPC,
         DB_FINANCIERO.INFO_PAGO_DET IPD,
         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
         DB_COMERCIAL.INFO_PUNTO IPT,
         DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
    WHERE IPAC.ID_PAGO_AUTOMATICO         = IPAD.PAGO_AUTOMATICO_ID
    AND   IPAD.ID_DETALLE_PAGO_AUTOMATICO = IPD.REFERENCIA_DET_PAGO_AUT_ID
    AND   IPC.ID_PAGO                     = IPD.PAGO_ID
    AND   IPC.PUNTO_ID                    = IPT.ID_PUNTO
    AND   IPC.OFICINA_ID                  = IOG.ID_OFICINA
    AND   IDFC.ID_DOCUMENTO               = IPD.REFERENCIA_ID
    AND   IPAC.ID_PAGO_AUTOMATICO         = Cv_IdPagAutomatico;

   --Costo:6
    CURSOR C_GetParametro(Cv_EmpresaCod IN VARCHAR2,Cv_NombreParamCab IN VARCHAR2,Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
          DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.ESTADO           = 'Activo'
        AND APD.ESTADO           = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.VALOR1           = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod;

   --Costo:3
   CURSOR C_GetParametroNot(Cv_EmpresaCod IN VARCHAR2,Cv_NombreParamCab IN VARCHAR2,Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
          DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.ESTADO           = 'Activo'
        AND APD.ESTADO           = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.DESCRIPCION      = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod;
  
    Ln_IdPagoAutomatico       DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ID_PAGO_AUTOMATICO%TYPE;
    Lv_CodigoPlantilla        DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE:= 'RPT_RET_EXIST';
    Lr_Parametro              C_GetParametro%ROWTYPE;
    Lr_ParametroNot           C_GetParametroNot%ROWTYPE;
    Lr_RetAutExistente        C_GetInfoRetAut%ROWTYPE;
    Lr_InfoPagFact            C_GetInfoPagFact%ROWTYPE;
    Lrf_DatosExcel            SYS_REFCURSOR;
    Lv_Url                    VARCHAR2(800);
    Lv_UrlContext             VARCHAR2(600);
    LBL_EXCEL                 BLOB;
    Luh_http_request          UTL_HTTP.req;
    Luh_http_response         UTL_HTTP.resp;
    LRW_raw RAW(32767);
    Ln_itemLoop number;
    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_NombreParametroCab    VARCHAR2(50)    := 'AUTOMATIZACION_RETENCIONES';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100);  
    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');

    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lv_Status                VARCHAR2(15);
    Lv_Estado                DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.ESTADO%TYPE      :='';
    Lv_UsrCreacion           DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.USR_CREACION%TYPE:='';
    Lv_Oficina               DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE:='';
    Lv_Login                 DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE:='';
    Lv_Factura               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE:='';
    LV_ValorTotal            VARCHAR2(100):='';
    Lv_ReferenciaFormat      VARCHAR2(100);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;
    LV_ERROR                 VARCHAR2(3000);
    LE_ERROR                 EXCEPTION; 
BEGIN

    OPEN C_GetParametro(Pv_EmpresaCod,Lv_NombreParametroCab,'FILE-HTTP-HOST');
    FETCH C_GetParametro INTO Lr_Parametro;
    CLOSE C_GetParametro;

    OPEN C_GetParametroNot(Pv_EmpresaCod,Lv_NombreParametroCab,Lv_CodigoPlantilla);
    FETCH C_GetParametroNot INTO Lr_ParametroNot;
    CLOSE C_GetParametroNot;

    DBMS_OUTPUT.PUT_LINE(Pv_UrlFile);
    SELECT REGEXP_SUBSTR(Pv_UrlFile, '^([^:]*://)?([^/]+)(/.*)?', 1, 1, null, 3) into Lv_UrlContext from dual;
    DBMS_OUTPUT.PUT_LINE('Lv_UrlContext '||Pv_UrlFile);

    Lv_Url:=Lr_Parametro.VALOR2||Lv_UrlContext;
    DBMS_OUTPUT.PUT_LINE(Lv_Url);
    -- Initialize the BLOB.
    DBMS_LOB.createtemporary(LBL_EXCEL, FALSE);

    -- Make a HTTP request and get the response.
    Luh_http_request  := UTL_HTTP.begin_request(Lv_Url);
    Luh_http_response := UTL_HTTP.get_response(Luh_http_request);
    -- Copy the response into the BLOB.
    BEGIN
      LOOP
        UTL_HTTP.read_raw(Luh_http_response, LRW_raw, 32767);
        DBMS_LOB.writeappend (LBL_EXCEL, UTL_RAW.length(LRW_raw), LRW_raw);
      END LOOP;
    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        DBMS_OUTPUT.PUT_LINE(' -ERROR- ' || SQLERRM);
        UTL_HTTP.end_response(Luh_http_response);
    END;

    DBMS_OUTPUT.PUT_LINE('lectura P');
    Ln_itemLoop  :=0;
    Pv_Status    := 'OK';
    Pv_Mensaje   := 'OK';

    --DBMS_LOB.freetemporary(LBL_EXCEL);

    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_CodigoPlantilla); 
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Lc_GetAliasPlantilla.ALIAS_CORREOS,'notificaciones_telcos@telconet.ec')||',';
    Lv_Destinatario      := REPLACE(Lv_Destinatario,';',',');  
    Lv_NombreArchivo     := 'ReporteRetExistentes_'||Lv_FechaReporte||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lv_Asunto            := NVL(Lr_ParametroNot.VALOR1,'');
    Lv_Remitente         := NVL(Lr_ParametroNot.VALOR2,''); 


    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
    --
    utl_file.put_line(Lfile_Archivo,
                         'COMPROBANTE'              ||Lv_Delimitador
                        ||'SERIE COMPROBANTE'       ||Lv_Delimitador
                        ||'RUC EMISOR'              ||Lv_Delimitador
                        ||'RAZON SOCIAL EMISOR'     ||Lv_Delimitador
                        ||'FECHA EMISION'           ||Lv_Delimitador
                        ||'FECHA AUTORIZACION'      ||Lv_Delimitador
                        ||'TIPO EMISION'            ||Lv_Delimitador
                        ||''                        ||Lv_Delimitador
                        ||'IDENTIFICACION RECEPTOR' ||Lv_Delimitador
                        ||'CLAVE ACCESO'            ||Lv_Delimitador
                        ||'NUMERO AUTORIZACION'     ||Lv_Delimitador
                        ||'NUMERO REFERENCIA'       ||Lv_Delimitador
                        ||'STATUS'                  ||Lv_Delimitador
                        ||'ESTADO'                  ||Lv_Delimitador
                        ||'VALOR_TOTAL'             ||Lv_Delimitador
                        ||'NUMERO_FACTURA_SRI'      ||Lv_Delimitador
                        ||'LOGIN'                   ||Lv_Delimitador
                        ||'NOMBRE_OFICINA'          ||Lv_Delimitador
                        ||'USR_CREACION'            ||Lv_Delimitador);

    FOR infoRetencionExcel in ( SELECT COMPROBANTE,
                                       NUMERO_REFERENCIA,
                                       IDENTIFICACION_CLIENTE,
                                       RAZON_SOCIAL,
                                       FECHA_EMISION,
                                       FECHA_AUTORIZACION,
                                       TIPO_EMISION,
                                       CODIGO,
                                       IDE_RECEPTOR,
                                       CLAVE_ACCESO,
                                       NUMERO_AUTORIZACION FROM  (SELECT row_nr, col_nr,
                                  CASE cell_type
                                    WHEN 'S'
                                    THEN string_val
                                    WHEN 'N'
                                    THEN to_char(number_val)
                                    WHEN 'D'
                                    THEN to_char(date_val,'DD-MM-YYYY')
                                    ELSE ''
                                  END cell_val 
                                FROM
                                  (
                                    SELECT
                                      *
                                    FROM
                                      TABLE( as_read_xlsx.read( LBL_EXCEL))
                                  )
                             ) pivot ( MAX(cell_val) 
                                       FOR col_nr IN (1 AS COMPROBANTE,
                                                      2 AS NUMERO_REFERENCIA,
                                                      3 AS IDENTIFICACION_CLIENTE,
                                                      4 AS RAZON_SOCIAL,
                                                      5 AS FECHA_EMISION,
                                                      6 AS FECHA_AUTORIZACION,
                                                      7 AS TIPO_EMISION,
                                                      8 AS CODIGO,
                                                      9 AS IDE_RECEPTOR,
                                                      10 AS CLAVE_ACCESO,
                                                      11 AS NUMERO_AUTORIZACION)) WHERE row_nr >1)
    LOOP
    BEGIN

      IF infoRetencionExcel.IDENTIFICACION_CLIENTE IS NOT NULL THEN

        Lv_ReferenciaFormat := REPLACE(infoRetencionExcel.NUMERO_REFERENCIA,'-','');
        Lv_ReferenciaFormat := LPAD(Lv_ReferenciaFormat,LENGTH(Lv_ReferenciaFormat),'0');

	    OPEN  C_GetRetExistente(Lv_ReferenciaFormat,infoRetencionExcel.IDENTIFICACION_CLIENTE);
	    FETCH C_GetRetExistente INTO Ln_IdPagoAutomatico;
	    CLOSE C_GetRetExistente;

	    IF Ln_IdPagoAutomatico IS NOT NULL THEN
           OPEN C_GetInfoRetAut(Ln_IdPagoAutomatico);
           FETCH C_GetInfoRetAut INTO Lr_RetAutExistente;
           CLOSE C_GetInfoRetAut;
	       Lv_Status      := 'EXISTENTE';
           Lv_Estado      := NVL(Lr_RetAutExistente.ESTADO,'');
           Lv_UsrCreacion := NVL(Lr_RetAutExistente.USR_CREACION,'');
           IF Lv_Estado = 'Procesado' THEN
             OPEN C_GetInfoPagFact(Ln_IdPagoAutomatico);
             FETCH C_GetInfoPagFact INTO Lr_InfoPagFact;
             CLOSE C_GetInfoPagFact;
             Lv_Oficina    := NVL(Lr_InfoPagFact.NOMBRE_OFICINA,'');
             Lv_Login      := NVL(Lr_InfoPagFact.LOGIN,'');
             Lv_Factura    := NVL(Lr_InfoPagFact.NUMERO_FACTURA_SRI,'');
             LV_ValorTotal := TO_CHAR(NVL(Lr_InfoPagFact.VALOR_TOTAL,0));
           ELSE
             Lv_Estado     := '';
             Lv_Oficina    := '';
             Lv_Login      := '';
             Lv_Factura    := '';
             LV_ValorTotal := '';
             Lv_UsrCreacion:= '';
           END IF;

	    ELSE
	       Lv_Status     := 'NO EXISTENTE';
           Lv_Estado     := '';
           Lv_Oficina    := '';
           Lv_Login      := '';
           Lv_Factura    := '';
           LV_ValorTotal := '';
           Lv_UsrCreacion:= '';
	    END IF;

	  UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(infoRetencionExcel.COMPROBANTE,'')||Lv_Delimitador
	       ||NVL(infoRetencionExcel.NUMERO_REFERENCIA,'')||Lv_Delimitador 
	       ||NVL(infoRetencionExcel.IDENTIFICACION_CLIENTE,'')||Lv_Delimitador 
	       ||NVL(infoRetencionExcel.RAZON_SOCIAL,'')||Lv_Delimitador 
	       ||NVL(infoRetencionExcel.FECHA_EMISION,'')||Lv_Delimitador 
	       ||NVL(infoRetencionExcel.FECHA_AUTORIZACION,'')||Lv_Delimitador 
	       ||NVL(infoRetencionExcel.TIPO_EMISION,'')||Lv_Delimitador 
	       ||NVL(infoRetencionExcel.CODIGO,'')||Lv_Delimitador 
	       ||NVL(infoRetencionExcel.IDE_RECEPTOR,'')||Lv_Delimitador 
	       ||NVL(infoRetencionExcel.CLAVE_ACCESO, '')||Lv_Delimitador
	       ||NVL(infoRetencionExcel.NUMERO_AUTORIZACION, '')||Lv_Delimitador
	       ||NVL(Lv_ReferenciaFormat, '')||Lv_Delimitador 
	       ||NVL(Lv_Status, '')||Lv_Delimitador 
	       ||NVL(Lv_Estado, '')||Lv_Delimitador 
	       ||NVL(LV_ValorTotal, '')||Lv_Delimitador  
	       ||NVL(Lv_Factura, '')||Lv_Delimitador  
	       ||NVL(Lv_Login, '')||Lv_Delimitador  
	       ||NVL(Lv_Oficina, '')||Lv_Delimitador  
	       ||NVL(Lv_UsrCreacion, '')||Lv_Delimitador 
	       ); 

      END IF;
    END;
  END LOOP;
  DBMS_LOB.freetemporary(LBL_EXCEL);

  UTL_FILE.FCLOSE(Lfile_Archivo);
  DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  
  DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                            Lv_Destinatario,
                                            Lv_Asunto, 
                                            Lv_Cuerpo, 
                                            Lv_Directorio,
                                            Lv_NombreArchivoZip);
  UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);     
  DBMS_OUTPUT.PUT_LINE('cierre P');

EXCEPTION
    WHEN LE_ERROR THEN
      DBMS_LOB.freetemporary(LBL_EXCEL);
      Pv_Status  := 'Error';
      Pv_Mensaje := 'Error';        
      Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso .' ||
                        ' - ' || Lv_MsjResultado;
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNKG_PAGO_AUTOMATICO.P_PROCESA_RPT_TRIBUTACION', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_pagaut',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    WHEN OTHERS THEN
      DBMS_LOB.freetemporary(LBL_EXCEL);
      Pv_Status  := 'Error';
      Pv_Mensaje := 'Error';  
      Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso.' ||
                        ' - ' || Lv_MsjResultado;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNKG_PAGO_AUTOMATICO.P_PROCESA_RPT_TRIBUTACION', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_pagaut',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  END P_PROCESA_RPT_TRIBUTACION;

  PROCEDURE P_ANULA_RETENCIONES_AUT(Pv_EmpresaCod           IN  VARCHAR2)
  IS
  CURSOR C_RetPorAnular(Cv_EmpresaCod VARCHAR2) IS
    SELECT ID_PAGO_AUTOMATICO
    FROM   DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB
    WHERE  TIPO_FORMA_PAGO = 'RETENCION'
     AND   ESTADO IN ('Error')
     AND   FE_CREACION >= TRUNC(SYSDATE,'month') 
     AND   FE_ULT_MOD IS NULL;

  CURSOR C_RetDetPorAnular(Cn_IdPagoAutomatico NUMBER) IS
    SELECT ID_DETALLE_PAGO_AUTOMATICO
    FROM   DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET
    WHERE  PAGO_AUTOMATICO_ID = Cn_IdPagoAutomatico
     AND   FE_CREACION >= TRUNC(SYSDATE,'month');

    Lv_Observacion    VARCHAR2(4000);
    Lv_NombreJob      VARCHAR2(45) := '"DB_FINANCIERO"."JOB_ANULA_RETENCIONES_AUT';
    Lv_Error          VARCHAR2(500);
    Lv_NombreProceso  VARCHAR2(3000);

  BEGIN
    FOR Lr_RetPorAnular IN C_RetPorAnular(Pv_EmpresaCod)
    LOOP
        Lv_Observacion := 'Se elimina retenci�n autom�tica mediante ejecuci�n del job:' || Lv_NombreJob || ' ID: '||Lr_RetPorAnular.ID_PAGO_AUTOMATICO || '"';
        --SE ANULA LA CABECERA DEL PAGO AUTOMATICO
        UPDATE DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB
           SET ESTADO = 'Eliminado',
               FE_ULT_MOD = SYSDATE,
               USR_ULT_MOD = 'telcos_pagAut'
        WHERE ID_PAGO_AUTOMATICO = Lr_RetPorAnular.ID_PAGO_AUTOMATICO;
        --SE ANULA EL DETALLE DEL PAGO AUTOMATICO
        UPDATE DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET
           SET ESTADO = 'Eliminado',
               FE_ULT_MOD = SYSDATE,
               USR_ULT_MOD = 'telcos_pagAut',
               OBSERVACION = 'Se da de baja por proceso autom�tico de eliminaci�n de retenciones '
                              ||Lv_Observacion
         WHERE PAGO_AUTOMATICO_ID = Lr_RetPorAnular.ID_PAGO_AUTOMATICO
           AND ESTADO NOT IN ('Pendiente','Procesado');

        FOR Lr_RetDetPorAnular IN C_RetDetPorAnular(Lr_RetPorAnular.ID_PAGO_AUTOMATICO)
        LOOP
            DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_CREA_PAGO_AUT_DET_HIST(Lr_RetDetPorAnular.ID_DETALLE_PAGO_AUTOMATICO,
                                                                        'Se da de baja por proceso autom�tico de eliminaci�n de retenciones ',
                                                                        'Eliminado',
                                                                        'telcos_pagAut',
                                                                        '127.0.0.1',
                                                                        Lv_NombreProceso,
                                                                        Lv_Error);
        END LOOP;
        COMMIT;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'FNKG_PAGO_AUTOMATICO.P_ANULA_RETENCIONES_AUT',
                                              SQLERRM ,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos_anulaPagAut'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                            );
  END P_ANULA_RETENCIONES_AUT;

  PROCEDURE P_REPORTE_RET_ANULADAS(Pv_EmpresaCod       IN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.EMPRESA_COD%TYPE,
                                   Pv_CodigoPlantilla  IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
                                   Pv_TipoEnvio        IN VARCHAR2)
  IS
    CURSOR C_DocumentosAnuladosMens(Cv_EmpresaCod IN VARCHAR2)
    IS
      SELECT IPAC.IDENTIFICACION_CLIENTE,
             IPAC.RAZON_SOCIAL,
             IPAD.NUMERO_REFERENCIA,
             IPAD.FECHA,
             IPAD.MONTO,
             IPAD.ESTADO,
             TO_CHAR(IPAC.FE_CREACION,'dd/mm/yyyy hh24:mi:ss') AS FECHA_CREACION
          FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB IPAC
          JOIN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD
          ON (IPAC.ID_PAGO_AUTOMATICO = IPAD.PAGO_AUTOMATICO_ID)
          WHERE IPAD.ESTADO       = 'Eliminado'
          AND IPAD.EMPRESA_COD    = Cv_EmpresaCod
          AND IPAD.PAGO_AUTOMATICO_ID IS NOT NULL
          AND TO_CHAR(IPAD.FE_ULT_MOD,'MM-RRRR')  = TO_CHAR(SYSDATE,'MM-RRRR');

    CURSOR C_DocumentosAnuladosD(Cv_EmpresaCod IN VARCHAR2)
    IS
      SELECT IPAC.IDENTIFICACION_CLIENTE,
             IPAC.RAZON_SOCIAL,
             IPAD.NUMERO_REFERENCIA,
             IPAD.FECHA,
             IPAD.MONTO,
             IPAD.ESTADO,
             TO_CHAR(IPAC.FE_CREACION,'dd/mm/yyyy hh24:mi:ss') AS FECHA_CREACION
          FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB IPAC
          JOIN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD
          ON (IPAC.ID_PAGO_AUTOMATICO = IPAD.PAGO_AUTOMATICO_ID)
          WHERE IPAD.ESTADO       = 'Eliminado'
          AND IPAD.EMPRESA_COD    = Cv_EmpresaCod
          AND IPAD.PAGO_AUTOMATICO_ID IS NOT NULL
          AND TRUNC(IPAD.FE_ULT_MOD)  = TRUNC(SYSDATE);

    CURSOR C_GetParametro(Cv_EmpresaCod IN VARCHAR2,Cv_NombreParamCab IN VARCHAR2,Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
          DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.DESCRIPCION      = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod;

    -- 
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100);  
    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreParametroCab    VARCHAR2(50);
    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lr_ParametroNotifica     C_GetParametro%ROWTYPE;
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

  BEGIN

    IF Pv_TipoEnvio = 'M' THEN
      IF C_DocumentosAnuladosMens%ISOPEN THEN
        CLOSE C_DocumentosAnuladosMens;
      END IF;
    ELSE
      IF C_DocumentosAnuladosD%ISOPEN THEN
        CLOSE C_DocumentosAnuladosD;
      END IF;
    END IF;
    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla); 
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Lc_GetAliasPlantilla.ALIAS_CORREOS,'notificaciones_telcos@telconet.ec')||',';
    Lv_Destinatario      := REPLACE(Lv_Destinatario,';',','); 
    Lv_NombreArchivo     := 'ReporteRetAnuladas_'||Lv_FechaReporte||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lv_NombreParametroCab:= 'AUTOMATIZACION_RETENCIONES';


    IF C_GetParametro%ISOPEN THEN
      CLOSE C_GetParametro;
    END IF;
    OPEN  C_GetParametro(Pv_EmpresaCod, Lv_NombreParametroCab, Pv_CodigoPlantilla);
    FETCH C_GetParametro INTO Lr_ParametroNotifica;
    CLOSE C_GetParametro;

    Lv_Asunto            := NVL(Lr_ParametroNotifica.VALOR1,'');
    Lv_Remitente         := NVL(Lr_ParametroNotifica.VALOR2,'');  

    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
    --
    utl_file.put_line(Lfile_Archivo,
                        'IDENTIFICACION_CLIENTE' ||Lv_Delimitador
                        ||'CLIENTE'              ||Lv_Delimitador
                        ||'NUMERO_REFERENCIA'    ||Lv_Delimitador
                        ||'FECHA'                ||Lv_Delimitador
                        ||'MONTO'                ||Lv_Delimitador
                        ||'ESTADO'               ||Lv_Delimitador
                        ||'FE_CREACION'          ||Lv_Delimitador); 

    IF Pv_TipoEnvio = 'M' THEN
      FOR Lr_RetAnuladas IN C_DocumentosAnuladosMens(Pv_EmpresaCod)
      LOOP                

          UTL_FILE.PUT_LINE(Lfile_Archivo,
                              NVL(Lr_RetAnuladas.IDENTIFICACION_CLIENTE, '')   ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.RAZON_SOCIAL, '')             ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.NUMERO_REFERENCIA, '')        ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.FECHA, '')                    ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.MONTO, '')                    ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.ESTADO, '')                   ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.FECHA_CREACION, '')           ||Lv_Delimitador
                           );
      END LOOP;
    ELSE
      FOR Lr_RetAnuladas IN C_DocumentosAnuladosD(Pv_EmpresaCod)
      LOOP                

          UTL_FILE.PUT_LINE(Lfile_Archivo,
                              NVL(Lr_RetAnuladas.IDENTIFICACION_CLIENTE, '')   ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.RAZON_SOCIAL, '')             ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.NUMERO_REFERENCIA, '')        ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.FECHA, '')                    ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.MONTO, '')                    ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.ESTADO, '')                   ||Lv_Delimitador
                            ||NVL(Lr_RetAnuladas.FECHA_CREACION, '')           ||Lv_Delimitador
                           );
      END LOOP;
    END IF;
    -- 
    UTL_FILE.fclose(Lfile_Archivo);
    dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 
    IF Pv_TipoEnvio = 'M' THEN
      Lv_Asunto := Lv_Asunto||' (MENSUAL)';
    ELSE
      Lv_Asunto := Lv_Asunto||' (DIARIO)';
    END IF;
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip);

    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip); 

  EXCEPTION
  WHEN OTHERS THEN
    Lv_MsjResultado := 'Ocurri� un error al generar el reporte de Retenciones Anuladas. '
                       ||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('P_REPORTE_RET_ANULADAS','FNKG_PAGO_AUTOMATICO.P_REPORTE_RET_ANULADAS',Lv_MsjResultado);  

  END P_REPORTE_RET_ANULADAS;

  PROCEDURE P_GET_PAG_AUTOMATICOS(
    Pv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pr_ParamRptPagAut     IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Pv_Estado             IN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ESTADO%TYPE,
    Prf_PagosAutomaticos  OUT SYS_REFCURSOR)
  IS
    Lcl_Query                 CLOB ;
    Lv_InfoError              VARCHAR2(3000);
  BEGIN

      Lcl_Query :=' SELECT DISTINCT(IPAD.ID_DETALLE_PAGO_AUTOMATICO)                   AS ID_DETALLE_PAGO_AUTOMATICO,
                                    CONCAT(ADCC.DESCRIPCION,CONCAT('' '',ADCC.NO_CTA)) AS BANCO,
                                    IPAD.FECHA                                         AS FECHA_TRANSACCION,
                                    IPAD.OBSERVACION                                   AS TIPO_MOVIMIENTO,
                                    IPAD.NUMERO_REFERENCIA                             AS NUMERO_REFERENCIA,
                                    IPAD.MONTO                                         AS MONTO,
                                    IPAD.ESTADO                                        AS ESTADO
                                    FROM DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET IPAD
                                    JOIN DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB IPAC ON IPAC.ID_PAGO_AUTOMATICO  = IPAD.PAGO_AUTOMATICO_ID
                                    JOIN DB_FINANCIERO.ADMI_CUENTA_CONTABLE     ADCC ON ADCC.ID_CUENTA_CONTABLE = IPAC.CUENTA_CONTABLE_ID
                                    WHERE IPAC.TIPO_FORMA_PAGO IS NULL ';
      IF Pr_ParamRptPagAut.valor3 IS NOT NULL THEN
        Lcl_Query := Lcl_Query ||'  AND IPAD.FE_CREACION >= (SYSDATE - NUMTODSINTERVAL('||Pr_ParamRptPagAut.valor3||','''||Pr_ParamRptPagAut.valor5||''' )) ';
        Lcl_Query := Lcl_Query ||'  AND IPAD.FE_CREACION <= (SYSDATE - NUMTODSINTERVAL('||Pr_ParamRptPagAut.valor4||','''||Pr_ParamRptPagAut.valor5||''' )) ';
      END IF;
  
      Lcl_Query := Lcl_Query ||' ORDER BY IPAD.ID_DETALLE_PAGO_AUTOMATICO DESC ';
      
    OPEN Prf_PagosAutomaticos FOR Lcl_Query;

    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError := 'Error en FNKG_PAGO_AUTOMATICO.P_GET_PAG_AUTOMATICOS - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_AUTOMATICO.P_GET_PAG_AUTOMATICOS', 
                                            Lv_InfoError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_GET_PAG_AUTOMATICOS;


  PROCEDURE P_RPT_PAG_AUT_PENDIENTES(
    Pv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla   IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE) 
  IS

  -- Costo del query: 4
  CURSOR C_GetParametro(Cv_NombreParamCab VARCHAR2, Cv_DescParamDet VARCHAR2, Cv_EstadoParametroCab VARCHAR2, Cv_EstadoParametroDet VARCHAR2, Cv_EmpresaCod VARCHAR2)
  IS
    SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4,  APD.VALOR5
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
      DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
    AND APC.ESTADO           = NVL(Cv_EstadoParametroCab, APC.ESTADO)
    AND APD.ESTADO           = NVL(Cv_EstadoParametroDet, APD.ESTADO)
    AND APC.NOMBRE_PARAMETRO = NVL(Cv_NombreParamCab, APC.NOMBRE_PARAMETRO)
    AND APD.DESCRIPCION      = NVL(Cv_DescParamDet, APD.DESCRIPCION)
    AND APD.EMPRESA_COD      = NVL(Cv_EmpresaCod, APD.EMPRESA_COD);
    
    Lr_ParametroNotificacion C_GetParametro%ROWTYPE;
    Lv_NombreParametroCab    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'AUTOMATIZACION PAGOS';
    Lv_DescripcionParamDet   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE                   := 'RPT_PAG_AUT_PENDIENTES';
    Lv_EstadoActivo          DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                        := 'Activo';
    Lv_EstadoPagAutDet       DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ESTADO%TYPE               := 'Pendiente';
    Lrf_PagosAutomaticos     SYS_REFCURSOR;
    La_PagosAutomaticos      T_PagosAutomaticos;

    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100); 

    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lr_PagoAutomatico        DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.Lr_PagoAutomatico;
    Lr_ParamRptPagAut        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

    Ln_Limit                 CONSTANT PLS_INTEGER DEFAULT 1000;
    Ln_Indx                  NUMBER;
    Ln_Indr                  NUMBER := 0;
  BEGIN

     --Se obtiene los par�metros para enviar el correo
    OPEN C_GetParametro(Lv_NombreParametroCab, Lv_DescripcionParamDet,Lv_EstadoActivo, Lv_EstadoActivo, Pv_CodEmpresa);
    FETCH C_GetParametro INTO Lr_ParametroNotificacion;
    CLOSE C_GetParametro;
    
    IF Lr_ParametroNotificacion.ID_PARAMETRO_DET IS NOT NULL THEN

        Lr_ParamRptPagAut.valor3 := Lr_ParametroNotificacion.valor3;
        Lr_ParamRptPagAut.valor4 := Lr_ParametroNotificacion.valor4;
        Lr_ParamRptPagAut.valor5 := Lr_ParametroNotificacion.valor5;

      --Se obtiene el alias y la plantilla donde se enviar� la notificaci�n
        Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla);
   
      --Si no esta configurado la plantilla con alias y el par�metro con los datos del remitente y asunto
      --no se enviar� la notificaci�n
        IF Lc_GetAliasPlantilla.PLANTILLA        IS NOT NULL AND
           Lc_GetAliasPlantilla.ALIAS_CORREOS    IS NOT NULL THEN

            Lv_Cuerpo           := Lc_GetAliasPlantilla.PLANTILLA;    
            Lv_Destinatario     := NVL(REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',','),'notificaciones_telcos@telconet.ec')||',';
            Lv_NombreArchivo    := 'ReportePagosNoProcesados'||Pv_PrefijoEmpresa||'_'||Lv_FechaReporte||'.csv';
            Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
            Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
            Lv_Remitente        := NVL(Lr_ParametroNotificacion.VALOR1,'');
            Lv_Asunto           := NVL(Lr_ParametroNotificacion.VALOR2,'REPORTE DE PAGOS NO PROCESADOS');
            Lfile_Archivo       := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

            utl_file.put_line(Lfile_Archivo,'BANCO EMPRESA' ||Lv_Delimitador
                              ||'FECHA DEPOSITO'            ||Lv_Delimitador 
                              ||'TIPO MOVIMIENTO'           ||Lv_Delimitador 
                              ||'# REFERENCIA'              ||Lv_Delimitador  
                              ||'VALOR'                     ||Lv_Delimitador 
                              ||'ESTADO'                    ||Lv_Delimitador
                              );

            IF Lrf_PagosAutomaticos%ISOPEN THEN
              CLOSE Lrf_PagosAutomaticos;
            END IF;

            DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GET_PAG_AUTOMATICOS(Pv_PrefijoEmpresa,
                                                                     Lr_ParamRptPagAut,
                                                                     Lv_EstadoPagAutDet,
                                                                     Lrf_PagosAutomaticos);      
        LOOP
            FETCH Lrf_PagosAutomaticos BULK COLLECT INTO La_PagosAutomaticos LIMIT Ln_Limit;
            Ln_Indx := La_PagosAutomaticos.FIRST;
            --
            EXIT WHEN La_PagosAutomaticos.COUNT = 0;
            --
            WHILE (Ln_Indx IS NOT NULL)
            LOOP
                Ln_Indr := Ln_Indr + 1;
                Lr_PagoAutomatico := La_PagosAutomaticos(Ln_Indx);

                UTL_FILE.PUT_LINE(Lfile_Archivo,
                        NVL(Lr_PagoAutomatico.BANCO, '')              ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.FECHA_TRANSACCION, '')  ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.TIPO_MOVIMIENTO, '')    ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.NUMERO_REFERENCIA, '')  ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.MONTO, '')              ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.ESTADO, '')             ||Lv_Delimitador
                 );
              Ln_Indx := La_PagosAutomaticos.NEXT(Ln_Indx);
            END LOOP;
        END LOOP;
        --
        UTL_FILE.fclose(Lfile_Archivo);
        dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 
        IF Ln_Indr > 0 THEN 
            DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                      Lv_Destinatario,
                                                      Lv_Asunto, 
                                                      Lv_Cuerpo, 
                                                      Lv_Directorio,
                                                      Lv_NombreArchivoZip);
        END IF;
        UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);
    END IF;
  END IF;
  EXCEPTION
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurri� un error al generar el reporte de pagos automaticos no procesados.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNKG_PAGO_AUTOMATICO.P_RPT_PAG_AUT_PENDIENTES', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_reporte',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      
  END P_RPT_PAG_AUT_PENDIENTES;

  PROCEDURE P_GET_PAG_AUT_PROCESADOS(
    Pv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Prf_Pagos             OUT SYS_REFCURSOR)
  IS
    Lcl_Query                 CLOB ;
    Lv_InfoError              VARCHAR2(3000);
  BEGIN

      Lcl_Query :='  SELECT IPT.LOGIN                   AS LOGIN , 
                            IPER.ESTADO                 AS ESTADO_CLIENTE,
                            PERS.IDENTIFICACION_CLIENTE AS IDENTIFICACION_CLIENTE, 
                            PERS.NOMBRES                AS NOMBRES,
                            PERS.APELLIDOS              AS APELLIDOS, 
                            PERS.RAZON_SOCIAL           AS RAZON_SOCIAL,
                            IPC.ID_PAGO                 AS ID_PAGO,
                            IPD.ID_PAGO_DET             AS ID_PAGO_DET,
                            MDA.MIGRACION_ID            AS MIGRACION_ID, 
                            ATDF.NOMBRE_TIPO_DOCUMENTO  AS NOMBRE_TIPO_DOCUMENTO,
                            IPC.NUMERO_PAGO             AS NUMERO_PAGO, 
                            IPD.VALOR_PAGO             AS VALOR_TOTAL, 
                            AFP.DESCRIPCION_FORMA_PAGO  AS DESCRIPCION_FORMA_PAGO,
                            IPD.NUMERO_REFERENCIA       AS NUMERO_REFERENCIA,
                            IPD.COMENTARIO              AS COMENTARIO,  
                            CONCAT(ACCB.DESCRIPCION,CONCAT('' '',ACCB.NO_CTA)) AS BANCO_EMPRESA,
                            ATDFF.NOMBRE_TIPO_DOCUMENTO AS TIPO_DOCUMENTO_FACT, 
                            IDFC.NUMERO_FACTURA_SRI     AS NUMERO_FACTURA_SRI,
                            IDFC.FE_EMISION             AS FE_EMISION,
                            IPC.ESTADO_PAGO             AS ESTADO_PAGO,
                            IPC.USR_CREACION            AS USR_CREACION, 
                            IPC.FE_CREACION             AS FE_CREACION,
                            IPD.FE_DEPOSITO             AS FE_DEPOSITO,
                            (SELECT DEP.FE_PROCESADO FROM DB_FINANCIERO.INFO_DEPOSITO DEP WHERE DEP.NO_COMPROBANTE_DEPOSITO = IPD.NUMERO_REFERENCIA) AS FECHA_PROCESADO, 
                            IOG.NOMBRE_OFICINA          AS NOMBRE_OFICINA
                      FROM  DB_FINANCIERO.INFO_PAGO_CAB IPC 
                      JOIN  DB_FINANCIERO.INFO_PAGO_DET IPD                   ON IPD.PAGO_ID             = IPC.ID_PAGO
                      JOIN  DB_GENERAL.ADMI_FORMA_PAGO  AFP                   ON AFP.ID_FORMA_PAGO       = IPD.FORMA_PAGO_ID
                      JOIN  DB_COMERCIAL.INFO_PUNTO     IPT                   ON IPT.ID_PUNTO            = IPC.PUNTO_ID
                      JOIN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO  = IPC.TIPO_DOCUMENTO_ID
                      LEFT JOIN  DB_FINANCIERO.ADMI_CUENTA_CONTABLE  ACCB          ON ACCB.ID_CUENTA_CONTABLE = IPD.CUENTA_CONTABLE_ID
                      FULL OUTER JOIN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC ON IDFC.ID_DOCUMENTO       = IPD.REFERENCIA_ID                    
                      LEFT JOIN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDFF ON IDFC.TIPO_DOCUMENTO_ID = ATDFF.ID_TIPO_DOCUMENTO
                      JOIN  DB_COMERCIAL.INFO_OFICINA_GRUPO  IOG ON IOG.ID_OFICINA = IPC.OFICINA_ID
                      JOIN  DB_COMERCIAL.INFO_EMPRESA_GRUPO  IEG ON IEG.COD_EMPRESA = IOG.EMPRESA_ID
                      JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL  IPER ON IPER.ID_PERSONA_ROL = IPT.PERSONA_EMPRESA_ROL_ID
                      JOIN  DB_COMERCIAL.INFO_PERSONA  PERS ON PERS.ID_PERSONA = IPER.PERSONA_ID
                      INNER JOIN  NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA ON MDA.DOCUMENTO_ORIGEN_ID = IPD.ID_PAGO_DET
                      WHERE TRUNC(IPC.FE_CREACION) >= TRUNC(SYSDATE) and MDA.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO
                      AND IEG.PREFIJO = ''TN''';

      Lcl_Query := Lcl_Query ||' ORDER BY IPC.ID_PAGO DESC ';
      
    OPEN Prf_Pagos FOR Lcl_Query;

    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError := 'Error en FNKG_PAGO_AUTOMATICO.P_GET_PAG_AUT_PROCESADOS - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                         || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNKG_PAGO_AUTOMATICO.P_GET_PAG_AUT_PROCESADOS', 
                                            Lv_InfoError, 
                                            NVL(SYS_CONTEXT( 'USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1') );
  END P_GET_PAG_AUT_PROCESADOS;

  PROCEDURE P_RPT_PAG_AUT_PPROCESADOS(
    Pv_CodEmpresa        IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla   IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE) 
  IS

  -- Costo del query: 4
  CURSOR C_GetParametro(Cv_NombreParamCab VARCHAR2, Cv_DescParamDet VARCHAR2, Cv_EstadoParametroCab VARCHAR2, Cv_EstadoParametroDet VARCHAR2, Cv_EmpresaCod VARCHAR2)
  IS
    SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4,  APD.VALOR5
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
      DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
    AND APC.ESTADO           = NVL(Cv_EstadoParametroCab, APC.ESTADO)
    AND APD.ESTADO           = NVL(Cv_EstadoParametroDet, APD.ESTADO)
    AND APC.NOMBRE_PARAMETRO = NVL(Cv_NombreParamCab, APC.NOMBRE_PARAMETRO)
    AND APD.DESCRIPCION      = NVL(Cv_DescParamDet, APD.DESCRIPCION)
    AND APD.EMPRESA_COD      = NVL(Cv_EmpresaCod, APD.EMPRESA_COD);
    
    Lr_ParametroNotificacion C_GetParametro%ROWTYPE;
    Lv_NombreParametroCab    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'AUTOMATIZACION PAGOS';
    Lv_DescripcionParamDet   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE                   := 'RPT_PAG_AUT_PROCESADOS';
    Lv_EstadoActivo          DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                        := 'Activo';
    Lrf_PagosAutomaticos     SYS_REFCURSOR;
    La_PagosAutomaticos      T_PagosAutProcesados;

    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100);
    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lr_PagoAutomatico        DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.Lr_InfoRptPagoAut;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

    Ln_Limit                 CONSTANT PLS_INTEGER DEFAULT 1000;
    Ln_Indx                  NUMBER;
    Ln_Indr                  NUMBER := 0;
  BEGIN

     --Se obtiene los par�metros para enviar el correo
    OPEN C_GetParametro(Lv_NombreParametroCab, Lv_DescripcionParamDet,Lv_EstadoActivo, Lv_EstadoActivo, Pv_CodEmpresa);
    FETCH C_GetParametro INTO Lr_ParametroNotificacion;
    CLOSE C_GetParametro;
    
    IF Lr_ParametroNotificacion.ID_PARAMETRO_DET IS NOT NULL THEN

      --Se obtiene el alias y la plantilla donde se enviar� la notificaci�n
        Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla);
   
      --Si no esta configurado la plantilla con alias y el par�metro con los datos del remitente y asunto
      --no se enviar� la notificaci�n
        IF Lc_GetAliasPlantilla.PLANTILLA        IS NOT NULL AND
           Lc_GetAliasPlantilla.ALIAS_CORREOS    IS NOT NULL THEN

            Lv_Cuerpo           := Lc_GetAliasPlantilla.PLANTILLA;    
            Lv_Destinatario     := NVL(REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',','),'notificaciones_telcos@telconet.ec')||',';
            Lv_NombreArchivo    := 'ReportePagosAutProcesados'||Pv_PrefijoEmpresa||'_'||Lv_FechaReporte||'.csv';
            Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
            Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
            Lv_Remitente        := NVL(Lr_ParametroNotificacion.VALOR1,'');
            Lv_Asunto           := NVL(Lr_ParametroNotificacion.VALOR2,'REPORTE DE PAGOS PROCESADOS');
            Lfile_Archivo       := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

            utl_file.put_line(Lfile_Archivo,'LOGIN'  ||Lv_Delimitador
                              ||'ESTADO CLIENTE'     ||Lv_Delimitador 
                              ||'IDENTIFICACION'     ||Lv_Delimitador 
                              ||'NOMBRES'            ||Lv_Delimitador 
                              ||'APELLIDOS'          ||Lv_Delimitador 
                              ||'RAZON SOCIAL'       ||Lv_Delimitador 
                              ||'ID PAGO'            ||Lv_Delimitador 
                              ||'ID DETALLE PAGO'    ||Lv_Delimitador 
                              ||'ID MIGRACION NAF'   ||Lv_Delimitador 
                              ||'TIPO DOCUMENTO'     ||Lv_Delimitador 
                              ||'# DOCUMENTO'        ||Lv_Delimitador 
                              ||'VALOR '             ||Lv_Delimitador 
                              ||'FORMA PAGO'         ||Lv_Delimitador 
                              ||'# REFERENCIA'       ||Lv_Delimitador 
                              ||'COMENTARIO PAGO DET'||Lv_Delimitador 
                              ||'BANCO EMPRESA'      ||Lv_Delimitador 
                              ||'TIPO DOCUMENTO AUT' ||Lv_Delimitador 
                              ||'# DOCUMENTO AUT'    ||Lv_Delimitador 
                              ||'FECHA EMISION'      ||Lv_Delimitador 
                              ||'ESTADO PAGO'        ||Lv_Delimitador 
                              ||'USR CREACION PAG'   ||Lv_Delimitador 
                              ||'FECHA CREACION'     ||Lv_Delimitador 
                              ||'FECHA DEPOSITO'     ||Lv_Delimitador 
                              ||'FECHA PROCESADO'    ||Lv_Delimitador 
                              ||'OFICINA'            ||Lv_Delimitador 
                              );

            IF Lrf_PagosAutomaticos%ISOPEN THEN
              CLOSE Lrf_PagosAutomaticos;
            END IF;

            DB_FINANCIERO.FNKG_PAGO_AUTOMATICO.P_GET_PAG_AUT_PROCESADOS(Pv_PrefijoEmpresa,
                                                                        Lrf_PagosAutomaticos);      
        LOOP
            FETCH Lrf_PagosAutomaticos BULK COLLECT INTO La_PagosAutomaticos LIMIT Ln_Limit;
            Ln_Indx := La_PagosAutomaticos.FIRST;
            --
            EXIT WHEN La_PagosAutomaticos.COUNT = 0;
            --
            WHILE (Ln_Indx IS NOT NULL)
            LOOP
                Ln_Indr := Ln_Indr + 1;
                Lr_PagoAutomatico := La_PagosAutomaticos(Ln_Indx);

                UTL_FILE.PUT_LINE(Lfile_Archivo,
                        NVL(Lr_PagoAutomatico.LOGIN, '')                  ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.ESTADO_CLIENTE, '')         ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.IDENTIFICACION_CLIENTE, '') ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.NOMBRES, '')                ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.APELLIDOS, '')              ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.RAZON_SOCIAL, '')           ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.ID_PAGO, '')                ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.ID_PAGO_DET, '')            ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.MIGRACION_ID, '')           ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.NOMBRE_TIPO_DOCUMENTO, '')  ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.NUMERO_PAGO, '')            ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.VALOR_TOTAL, '')            ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.DESCRIPCION_FORMA_PAGO, '') ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.NUMERO_REFERENCIA, '')      ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.COMENTARIO, '')             ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.BANCO_EMPRESA, '')          ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.TIPO_DOCUMENTO_FACT, '')    ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.NUMERO_FACTURA_SRI, '')     ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.FE_EMISION, '')             ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.ESTADO_PAGO, '')            ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.USR_CREACION, '')           ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.FE_CREACION, '')            ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.FE_DEPOSITO, '')            ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.FECHA_PROCESADO, '')        ||Lv_Delimitador
                      ||NVL(Lr_PagoAutomatico.NOMBRE_OFICINA, '')         ||Lv_Delimitador
                 );
              Ln_Indx := La_PagosAutomaticos.NEXT(Ln_Indx);
            END LOOP;
        END LOOP;
        --
        UTL_FILE.fclose(Lfile_Archivo);
        dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 
        IF Ln_Indr > 0 THEN 
            DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                      Lv_Destinatario,
                                                      Lv_Asunto, 
                                                      Lv_Cuerpo, 
                                                      Lv_Directorio,
                                                      Lv_NombreArchivoZip);
        END IF;
        UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);
    END IF;
  END IF;
  EXCEPTION
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurri� un error al generar el reporte de pagos automaticos procesados.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNKG_PAGO_AUTOMATICO.P_RPT_PAG_AUT_PPROCESADOS', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_reporte',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      
  END P_RPT_PAG_AUT_PPROCESADOS;

END FNKG_PAGO_AUTOMATICO;
/