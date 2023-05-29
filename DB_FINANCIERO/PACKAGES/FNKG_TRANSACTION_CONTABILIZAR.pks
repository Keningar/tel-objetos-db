CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR
AS 

--
/**
* Documentacion para el PKG FNKG_TRANSACTION_CONTABILIZAR
* El PKGFNKG_TRANSACTION_CONTABILIZAR contendra las variables que sean necesarias a usar en los PKG de consultas o transacciones
* separando procedimientos y funciones de las declaraciones de variables
* @author Andres Montero <amontero@telconet.ec>
* @version 1.0 16-04-2016
*/
--
  /*Documentacion para type 
   *Detalles de pago para poder obtener de aqui datos para insertar en tablas del naf
   */ 
  Type TypeDetallePagos IS RECORD(
        ID_PAGO_DET                DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
        FORMA_PAGO                 DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
        CODIGO_FORMA_PAGO          DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,        
        MONTO                      DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
        FE_CREACION                DB_FINANCIERO.INFO_PAGO_DET.FE_CREACION%TYPE,
        NUMERO_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
        NUMERO_CUENTA_BANCO        DB_FINANCIERO.INFO_PAGO_DET.NUMERO_CUENTA_BANCO%TYPE,
        LOGIN                      DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
        USR_CREACION               DB_FINANCIERO.INFO_PAGO_DET.USR_CREACION%TYPE,
        OFICINA                    DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        CUENTA_CONTABLE_ID         DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE,
        NUMERO_REFERENCIA          DB_FINANCIERO.INFO_PAGO_DET.NUMERO_REFERENCIA%TYPE,
        OFICINA_ID                 DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,   
        PREFIJO                    DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,   
        TIPO_DOC                   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
        PAGO_ID                    DB_FINANCIERO.INFO_PAGO_DET.PAGO_ID%TYPE,
        ID_FORMA_PAGO              DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE, 
        TIPO_DOCUMENTO_ID          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
        COD_EMPRESA                DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        FE_DEPOSITO                DB_FINANCIERO.INFO_PAGO_DET.FE_DEPOSITO%TYPE,
        PUNTO_ID                   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
        ESTADO_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
        MONTO_ANTICIPOS            NUMBER
  );


  /*Documentacion para type 
   *datos del admi_cuenta_contable para obtener los datos contables de los pagos
   *
   * @author Luis Lindao <llindao@telconet.ec>
   * @version 1.1 11-01-2019 - Se agrega campo centro de costo para recuperar en contabilizacion de pagos.
   */ 
  Type TypeCuentaContable IS RECORD(
        NO_CIA                   DB_FINANCIERO.ADMI_CUENTA_CONTABLE.NO_CIA%TYPE,
        NO_CTA                   DB_FINANCIERO.ADMI_CUENTA_CONTABLE.NO_CTA%TYPE,
        CUENTA                   DB_FINANCIERO.ADMI_CUENTA_CONTABLE.CUENTA%TYPE,
        TABLA_REFERENCIAL        DB_FINANCIERO.ADMI_CUENTA_CONTABLE.TABLA_REFERENCIAL%TYPE,
        CAMPO_REFERENCIAL        DB_FINANCIERO.ADMI_CUENTA_CONTABLE.CAMPO_REFERENCIAL%TYPE,
        VALOR_CAMPO_REFERENCIAL  DB_FINANCIERO.ADMI_CUENTA_CONTABLE.VALOR_CAMPO_REFERENCIAL%TYPE,
        NOMBRE_OBJETO_NAF        DB_FINANCIERO.ADMI_CUENTA_CONTABLE.NOMBRE_OBJETO_NAF%TYPE,
        CENTRO_COSTO             DB_FINANCIERO.ADMI_CUENTA_CONTABLE.CENTRO_COSTO%TYPE DEFAULT '000000000'
  );

  /*Documentacion para type 
   *datos del admi_cuenta_contable para obtener los datos contables de los pagos
   *
   * @author Luis Lindao <llindao@telconet.ec>
   * @version 1.1 11-01-2019 - Se agrega campo centro de costo para recuperar en contabilizacion de pagos
   */ 
  Type TypeCuentaContablePorTipo IS RECORD(
        NO_CIA                   DB_FINANCIERO.ADMI_CUENTA_CONTABLE.NO_CIA%TYPE,
        CUENTA                   DB_FINANCIERO.ADMI_CUENTA_CONTABLE.CUENTA%TYPE,
        CENTRO_COSTO             DB_FINANCIERO.ADMI_CUENTA_CONTABLE.CENTRO_COSTO%TYPE DEFAULT '000000000'
  );



  Type TypeOficina IS RECORD(
      ID_OFICINA      DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      PREFIJO         DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      NOMBRE_OFICINA  DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE
  );




    /*Documentacion para type 
   *Detalles de pago para poder obtener de aqui datos para insertar en tablas del naf
   */ 
  Type TypeDebito IS RECORD(
      CODIGO_TIPO_DOCUMENTO     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      VALOR_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
      OFICINA_ID                DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
      DESCRIPCION_CUENTA        DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
      ID_PAGO_DET               DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
      ID_PAGO                   DB_FINANCIERO.INFO_PAGO_DET.PAGO_ID%TYPE,
      ESTADO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
      TIPO_DOCUMENTO_ID         DB_FINANCIERO.INFO_PAGO_CAB.TIPO_DOCUMENTO_ID%TYPE,
      USR_CREACION              DB_FINANCIERO.INFO_PAGO_CAB.USR_CREACION%TYPE
  );


  Type TypeOficinas IS RECORD(
      OFICINA_ID     DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,
      NOMBRE_OFICINA DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE
  );

  /*Documentacion para type 
   *Detalles de pago para poder obtener de aqui datos para insertar en tablas del naf
   */ 
  Type TypePlantillaContableCab IS RECORD(
        ID_PLANTILLA_CONTABLE_CAB  DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.ID_PLANTILLA_CONTABLE_CAB%TYPE,
        ID_TIPO_DOCUMENTO          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
        CODIGO_TIPO_DOCUMENTO      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,        
        ID_FORMA_PAGO              DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
        CODIGO_FORMA_PAGO          DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,        
        TABLA_CABECERA             DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TABLA_CABECERA%TYPE,
        TABLA_DETALLE              DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TABLA_DETALLE%TYPE,
        COD_DIARIO                 DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.COD_DIARIO%TYPE,
        FORMATO_NO_DOCU_ASIENTO    DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_NO_DOCU_ASIENTO%TYPE,
        FORMATO_GLOSA              DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_GLOSA%TYPE,
        DESCRIPCION                DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE,
        NOMBRE_PAQUETE_SQL         DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.NOMBRE_PAQUETE_SQL%TYPE,
        TIPO_DOC                   DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TIPO_DOC%TYPE
  );

  /*Documentacion para type 
   *Detalles de pago para poder obtener de aqui datos para insertar en tablas del naf
   */ 
  Type TypePlantillaContableDet IS RECORD(
        ID_PLANTILLA_CONTABLE_DET  DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_DET.ID_PLANTILLA_CONTABLE_DET%TYPE,
        POSICION                   DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_DET.POSICION%TYPE,
        TIPO_CUENTA_CONTABLE_ID    DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE.ID_TIPO_CUENTA_CONTABLE%TYPE,
        TIPO_CUENTA_CONTABLE       DB_FINANCIERO.ADMI_TIPO_CUENTA_CONTABLE.DESCRIPCION%TYPE,
        FORMATO_GLOSA              DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_DET.FORMATO_GLOSA%TYPE,
        DESCRIPCION                DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_DET.DESCRIPCION%TYPE

  );

  /*Documentacion para type 
   *Datos del deposito con tdos sus datos principales para realizar asientos contables
   */ 
  Type TypeDeposito IS RECORD(
      ID_DEPOSITO               DB_FINANCIERO.INFO_DEPOSITO.ID_DEPOSITO%TYPE,
      BANCO_NAF_ID              DB_FINANCIERO.INFO_DEPOSITO.BANCO_NAF_ID%TYPE, 
      NO_CUENTA_BANCO_NAF       DB_FINANCIERO.INFO_DEPOSITO.NO_CUENTA_BANCO_NAF%TYPE,
      NO_CUENTA_CONTABLE_NAF    DB_FINANCIERO.INFO_DEPOSITO.NO_CUENTA_CONTABLE_NAF%TYPE,
      NO_COMPROBANTE_DEPOSITO   DB_FINANCIERO.INFO_DEPOSITO.NO_COMPROBANTE_DEPOSITO%TYPE,
      VALOR                     DB_FINANCIERO.INFO_DEPOSITO.VALOR%TYPE, 
      FE_DEPOSITO               DB_FINANCIERO.INFO_DEPOSITO.FE_DEPOSITO%TYPE, 
      FE_ANULADO                DB_FINANCIERO.INFO_DEPOSITO.FE_ANULADO%TYPE,
      FE_PROCESADO              DB_FINANCIERO.INFO_DEPOSITO.FE_PROCESADO%TYPE,
      FE_CREACION               DB_FINANCIERO.INFO_DEPOSITO.FE_CREACION%TYPE,
      FE_ULT_MOD                DB_FINANCIERO.INFO_DEPOSITO.FE_ULT_MOD%TYPE,
      USR_CREACION              DB_FINANCIERO.INFO_DEPOSITO.USR_CREACION%TYPE,
      USR_PROCESA               DB_FINANCIERO.INFO_DEPOSITO.USR_PROCESA%TYPE,
      USR_ANULA                 DB_FINANCIERO.INFO_DEPOSITO.USR_ANULA%TYPE,
      USR_ULT_MOD               DB_FINANCIERO.INFO_DEPOSITO.USR_ULT_MOD%TYPE,
      ESTADO                    DB_FINANCIERO.INFO_DEPOSITO.ESTADO%TYPE,  
      IP_CREACION               DB_FINANCIERO.INFO_DEPOSITO.IP_CREACION%TYPE, 
      EMPRESA_ID                DB_FINANCIERO.INFO_DEPOSITO.EMPRESA_ID%TYPE,
      NUM_DEPOSITO_MIGRACION    DB_FINANCIERO.INFO_DEPOSITO.NUM_DEPOSITO_MIGRACION%TYPE,
      CUENTA_CONTABLE_ID        DB_FINANCIERO.INFO_DEPOSITO.CUENTA_CONTABLE_ID%TYPE,
      OFICINA_ID                DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,  
      NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE  
  ); 


  /*Documentacion para type 
   *Datos del debito
   */
  Type TypeDatosDebito IS RECORD(    
      ID_DEBITO_GENERAL           DB_FINANCIERO.INFO_DEBITO_GENERAL.ID_DEBITO_GENERAL%TYPE, 
      ID_DEBITO_GENERAL_HISTORIAL DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.ID_DEBITO_GENERAL_HISTORIAL%TYPE, 
      NUMERO_DOCUMENTO            DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.NUMERO_DOCUMENTO%TYPE,
      FE_DOCUMENTO                DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.FE_DOCUMENTO%TYPE,
      PORCENTAJE_COMISION_BCO     DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.PORCENTAJE_COMISION_BCO%TYPE,
      CONTIENE_RET_FTE            DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.CONTIENE_RETENCION_FTE%TYPE,
      CONTIENE_RET_IVA            DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.CONTIENE_RETENCION_IVA%TYPE,
      NOMBRE_GRUPO                DB_FINANCIERO.ADMI_GRUPO_ARCHIVO_DEBITO_CAB.NOMBRE_GRUPO%TYPE,
      FE_CREACION                 DB_FINANCIERO.INFO_DEBITO_GENERAL.FE_CREACION%TYPE,
      USR_CREACION                DB_FINANCIERO.INFO_DEBITO_GENERAL.USR_CREACION%TYPE,
      CUENTA_CONTABLE_ID          DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.CUENTA_CONTABLE_ID%TYPE,
      EMPRESA_COD                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      TOTAL_PAGOS                 number,
      TOTAL_ANTICIPOS             number,
      TOTAL                       number,
      TOTAL_RETENCION_FTE         number,
      TOTAL_COMISION              number,
      TOTAL_RETENCION_IVA         number,
      TOTAL_NETO                  number,
      TOTAL_BASEIMP               number,
      OFICINA_ID                  DB_FINANCIERO.INFO_DEBITO_GENERAL.OFICINA_ID%TYPE

  );

  Type TypeDebitosOficina IS RECORD(
      ID_OFICINA        DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      NOMBRE_OFICINA    DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
      VALOR_PAGOS       number,
      VALOR_ANTICIPOS   number
  );    


  Type TypePagosDebito IS RECORD(
      ID_PAGO_DET      DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
      ESTADO_PAGO      DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
      ID_PAGO          DB_FINANCIERO.INFO_PAGO_DET.PAGO_ID%TYPE
  );

    /*Documentacion para type 
   *Datos del pago asociado a migracion NAF.
   */ 
  Type TypePagoMigracionNaf IS RECORD(
      ID_MIGRACION     NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.MIGRACION_ID%TYPE,
      TIPO_MIGRACION   NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.TIPO_MIGRACION%TYPE,
      NO_CIA           NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.NO_CIA%TYPE,
      TIPO_DOC_MIGRA   NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO.TIPO_DOC_MIGRACION%TYPE
  );
  /*Documentacion para type
  * Datos de los IdPagos relacionados a la anulacion del pago.
  */
  Type TypeIdPagosFe IS RECORD(
        ID_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
        ESTADO_PAGO            DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
        ANTICIPO_ID            DB_FINANCIERO.INFO_PAGO_CAB.ANTICIPO_ID%TYPE,
        TIPO_DOCUMENTO_ID      DB_FINANCIERO.INFO_PAGO_CAB.TIPO_DOCUMENTO_ID%TYPE
  );

  TYPE Type_IdPagosAsociados IS TABLE OF DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeIdPagosFe INDEX BY PLS_INTEGER;


--PROCEDURE INSERT_MIGRA_ARCGAE(Pr_MigraArcgae IN  NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,Pv_MsnError    OUT VARCHAR2);

--PROCEDURE INSERT_MIGRA_ARCGAL(Pr_MigraArcgal IN  NAF47_TNET.MIGRA_ARCGAL%ROWTYPE,Pv_MsnError    OUT VARCHAR2);

--PROCEDURE INSERT_MIGRA_ARCKMM(Pr_MigraArckmm IN  NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,Pv_MsnError OUT VARCHAR2);

--PROCEDURE INSERT_MIGRA_ARCKML(Pr_MigraArckml IN  NAF47_TNET.MIGRA_ARCKML%ROWTYPE,Pv_MsnError    OUT VARCHAR2);

PROCEDURE UPDATE_MIGRA_ARCKMM(Pr_no_docu IN VARCHAR2, Pr_no_cia IN VARCHAR2,
              Pr_MigraArckmm IN  NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
);
PROCEDURE UPDATE_MIGRA_ARCGAE(
              Pr_no_asiento IN VARCHAR2,
              Pr_no_cia IN VARCHAR2,
              Pr_MigraArcgae IN  NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
);
PROCEDURE INSERT_INFO_PROCESO_MASIVO_CAB(
              Pr_InfoProcesoMasivoCab IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
);

PROCEDURE INSERT_INFO_PROCESO_MASIVO_DET(
              Pr_InfoProcesoMasivoDet IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
);

/**
  * Documentacion para el procedimiento INSERT_CTA_CONTABLE
  * Permite insertar las cuentas contables asociada a los procesos
  * Pn_TipoCuentaContableId IN  ADMI_CUENTA_CONTABLE.TIPO_CUENTA_CONTABLE_ID%TYPE Tipo de cuenta a procesar PRODUCTOS | PRODUCTOS_NC
  * Pn_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Empresa a procesar,
  * Pv_Cuenta               IN  VARCHAR2                                          Cuenta contable segun proceso,
  * Pv_Descripcion          IN  VARCHAR2                                          Descripcion para cuenta contable financiera,
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 04-01-2017
*/
PROCEDURE INSERT_CTA_CONTABLE(
  Pn_TipoCuentaContableId     IN ADMI_CUENTA_CONTABLE.TIPO_CUENTA_CONTABLE_ID%TYPE,
  Pv_EmpresaCod               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  Pv_Cuenta                   IN VARCHAR2,
  Pv_Descripcion              IN VARCHAR2
);

/**
  * Documentacion para el procedimiento P_MARCA_PAGOS_DEPENDIENTES
  * Permite recuperar los documentos asociados aPAGOS o ANTICIPOS del documento que fue Anulado
  *
  * Pn_IdPago                   IN INFO_PAGO_CAB.ID_PAGO%TYPE,
  * Pv_CodigoTipoDocumento      IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
  * Pv_NumeroPago               IN DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
  * Pn_EmpresaId                IN VARCHAR2,
  * Pv_MsnError                 OUT VARCHAR2
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 04-08-2017
*/
PROCEDURE P_MARCA_PAGOS_DEPENDIENTES(
  Pn_IdPago                   IN INFO_PAGO_CAB.ID_PAGO%TYPE,
  Pv_CodigoTipoDocumento      IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
  Pv_NumeroPago               IN DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
  Pn_EmpresaId                IN VARCHAR2,
  Pv_MsnError                 OUT VARCHAR2
);

/**
  * Documentacion para el procedimiento INSERT_PAGO_HISTORIAL_DEPENCIA
  * Insert los pagos con historial dependientes
  * @param Pr_PagosHistorialDep       IN  DB_FINANCIERO.INFO_PAGO_HISTORIAL%ROWTYPE, Recibe un objeto como INFO_PAGO_HISTORIAL
  * @param Pv_MsnError                OUT VARCHAR2  Devuelve el mensaje de error
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 05-08-2017
  */
PROCEDURE INSERT_PAGO_HISTORIAL_DEPENCIA(
  Pr_PagosHistorialDep IN  DB_FINANCIERO.INFO_PAGO_HISTORIAL%ROWTYPE,
  Pv_MsnError          OUT VARCHAR2
);
--
 /**
  * Documentación para FUNCTION 'F_GET_ID_PAGO_RELACIONADO'.
  *
  * Función que devuelve los idPagos relacionados a la anulacion del documento. 
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 12-08-2017
  *
  * PARAMETROS:
  * @param Fn_IdPago        IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  (Id del documento - Pago)
  * @param Fn_EmpresaId     IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE (EmpresaId - Pago)
  *
  *
  * @return Type_IdPagosAsociados
  *
  */
  FUNCTION F_GET_ID_PAGO_RELACIONADO(
    Fn_IdPago       IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
    Fn_EmpresaId    IN  VARCHAR2)
    RETURN Type_IdPagosAsociados;

  /**
  * Documentación para FUNCTION 'F_GET_ID_ANTICIPO_PADRE'.
  *
  * Función que devuelve los idPagos relacionados a la anulacion del documento. 
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 12-08-2017
  *
  * PARAMETROS:
  * @param Fn_IdPago        IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  (Id del documento - Pago)
  * @param Fv_TipoDocumento IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE  (Tipo de Documento)
  *
  * @param DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE
  *
  * @return DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;
  *
  */ 
    FUNCTION F_GET_ID_ANTICIPO_PADRE(
    Fn_IdPago        IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
    Fv_TipoDocumento IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fn_EmpresaId     IN  VARCHAR2)
    RETURN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;

  /**
  * Documentación para FUNCTION 'F_AGREGA_PADRES_RELACIONADOS'.
  *
  * Función que inclute ANT y PAG a los registros de los pagos asociados
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 14-08-2017
  *
  * PARAMETROS:
  * @param Fn_IdPago       IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,  
  * @param Flr_IdPagosFe   IN  DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.Type_IdPagosAsociados,
  * @param Fn_Idx          IN  NUMBER
  * @param Fn_EmpresaId    IN  VARCHAR2
  *
  * @return Type_IdPagosAsociados
  *
  */ 
  FUNCTION F_AGREGA_PADRES_RELACIONADOS(
    Fn_IdPago       IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,  
    Flr_IdPagosFe   IN  DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.Type_IdPagosAsociados,
    Fn_Idx          IN  NUMBER,
    Fn_EmpresaId    IN  VARCHAR2)
    RETURN Type_IdPagosAsociados;
  --
END FNKG_TRANSACTION_CONTABILIZAR;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR
AS

--
/**
  * Documentacion para el procedimiento INSERT_MIGRA_ARCGAE
  * Insert la cabecera del asiento contable
  * @param Pr_MigraArcgae       IN  MIGRA_ARCGAE%ROWTYPE Recibe un objeto como MIGRA_ARCGAE
  * @param Pv_MsnError          OUT VARCHAR2  Devuelve el mensaje de error
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 22-12-2015
  */
PROCEDURE INSERT_MIGRA_ARCGAE
            (
              Pr_MigraArcgae IN  NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
            )
IS
BEGIN
  Pv_MsnError:='OK';
  --
  INSERT
  INTO
    NAF47_TNET.MIGRA_ARCGAE
    (

      NO_CIA,
      ANO,
      MES,
      NO_ASIENTO,
      IMPRESO,
      FECHA,
      DESCRI1,
      ESTADO,
      AUTORIZADO,
      ORIGEN,  
      T_DEBITOS,
      T_CREDITOS,
      COD_DIARIO,
      T_CAMB_C_V,
      TIPO_CAMBIO,
      TIPO_COMPROBANTE,
      ANULADO, 
      USUARIO_CREACION, 
      TRANSFERIDO, 
      FECHA_CREACION
    )
    VALUES
    (
      Pr_MigraArcgae.NO_CIA,
      Pr_MigraArcgae.ANO,
      Pr_MigraArcgae.MES,
      Pr_MigraArcgae.NO_ASIENTO,
      Pr_MigraArcgae.IMPRESO,
      Pr_MigraArcgae.FECHA,
      Pr_MigraArcgae.DESCRI1,
      Pr_MigraArcgae.ESTADO,
      Pr_MigraArcgae.AUTORIZADO,
      Pr_MigraArcgae.ORIGEN,
      Pr_MigraArcgae.T_DEBITOS,
      Pr_MigraArcgae.T_CREDITOS,
      Pr_MigraArcgae.COD_DIARIO,
      Pr_MigraArcgae.T_CAMB_C_V,
      Pr_MigraArcgae.TIPO_CAMBIO,
      Pr_MigraArcgae.TIPO_COMPROBANTE,
      Pr_MigraArcgae.ANULADO,
      Pr_MigraArcgae.USUARIO_CREACION,
      Pr_MigraArcgae.TRANSFERIDO,
      Pr_MigraArcgae.FECHA_CREACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  --
END INSERT_MIGRA_ARCGAE;







--
/**
  * Documentacion para el procedimiento INSERT_MIGRA_ARCGAL
  * Insert los detalles del asiento contable
  * @param Pr_MigraArcgal       IN  MIGRA_ARCGAL%ROWTYPE Recibe un objeto como MIGRA_ARCGAL
  * @param Pv_MsnError          OUT VARCHAR2  Devuelve el mensaje de error
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 22-12-2015
  */
PROCEDURE INSERT_MIGRA_ARCGAL
            (
              Pr_MigraArcgal IN NAF47_TNET.MIGRA_ARCGAL%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
            )
IS
BEGIN
  Pv_MsnError:='OK';
  --
  INSERT
  INTO
    NAF47_TNET.MIGRA_ARCGAL
    (
        NO_CIA,
        ANO,
        MES,
        NO_ASIENTO,
        NO_LINEA,
        CUENTA,
        DESCRI,
        COD_DIARIO,
        MONEDA,
        TIPO_CAMBIO,
        MONTO,
        CENTRO_COSTO,
        TIPO,
        MONTO_DOL,
        CC_1,
        CC_2,
        CC_3,
        LINEA_AJUSTE_PRECISION  
    )
    VALUES
    (
      Pr_MigraArcgal.NO_CIA,
      Pr_MigraArcgal.ANO,
      Pr_MigraArcgal.MES,
      Pr_MigraArcgal.NO_ASIENTO,
      Pr_MigraArcgal.NO_LINEA,
      Pr_MigraArcgal.CUENTA,
      Pr_MigraArcgal.DESCRI,
      Pr_MigraArcgal.COD_DIARIO,
      Pr_MigraArcgal.MONEDA,
      Pr_MigraArcgal.TIPO_CAMBIO,
      Pr_MigraArcgal.MONTO,
      Pr_MigraArcgal.CENTRO_COSTO,
      Pr_MigraArcgal.TIPO,
      Pr_MigraArcgal.MONTO_DOL,
      Pr_MigraArcgal.CC_1,
      Pr_MigraArcgal.CC_2,
      Pr_MigraArcgal.CC_3,
      Pr_MigraArcgal.LINEA_AJUSTE_PRECISION
    );    
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM; 

  --
END INSERT_MIGRA_ARCGAL;








--
/**
  * Documentacion para el procedimiento INSERT_MIGRA_ARCKMM
  * Insert los detalles del asiento contable
  * @param Pr_MigraArckmm       IN  MIGRA_ARCKMM%ROWTYPE Recibe un objeto como MIGRA_ARCKMM
  * @param Pv_MsnError          OUT VARCHAR2  Devuelve el mensaje de error
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 22-12-2015
  */
PROCEDURE INSERT_MIGRA_ARCKMM(
              Pr_MigraArckmm IN  NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
)
IS

BEGIN
  Pv_MsnError:='OK';
            --INSERTA CABECERA DEL ASIENTO
            ----------------------------
INSERT INTO NAF47_TNET.MIGRA_ARCKMM 
            (
                NO_CIA,
                NO_CTA, 
                PROCEDENCIA, 
                TIPO_DOC, 
                NO_DOCU, 
                FECHA, 
                COMENTARIO, 
                MONTO, 
                ESTADO, 
                CONCILIADO, 
                MES, 
                ANO, 
                IND_OTROMOV, 
                MONEDA_CTA, 
                TIPO_CAMBIO, 
                T_CAMB_C_V,
                IND_OTROS_MESES,
                NO_FISICO,
                ORIGEN,
                USUARIO_CREACION,
                FECHA_DOC,
                IND_DIVISION,
                FECHA_CREACION
            )VALUES
            (
                Pr_MigraArckmm.NO_CIA,
                Pr_MigraArckmm.NO_CTA,                
                Pr_MigraArckmm.PROCEDENCIA,
                Pr_MigraArckmm.TIPO_DOC,
                Pr_MigraArckmm.NO_DOCU,
                Pr_MigraArckmm.FECHA,
                Pr_MigraArckmm.COMENTARIO,
                Pr_MigraArckmm.MONTO,
                Pr_MigraArckmm.ESTADO,
                Pr_MigraArckmm.CONCILIADO,
                Pr_MigraArckmm.MES,
                Pr_MigraArckmm.ANO,              
                Pr_MigraArckmm.IND_OTROMOV,
                Pr_MigraArckmm.MONEDA_CTA,
                Pr_MigraArckmm.TIPO_CAMBIO,
                Pr_MigraArckmm.T_CAMB_C_V,
                Pr_MigraArckmm.IND_OTROS_MESES,
                Pr_MigraArckmm.NO_FISICO,
                Pr_MigraArckmm.ORIGEN,
                Pr_MigraArckmm.USUARIO_CREACION,
                Pr_MigraArckmm.FECHA_DOC,
                Pr_MigraArckmm.IND_DIVISION,
                Pr_MigraArckmm.FECHA_CREACION);

EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;

END INSERT_MIGRA_ARCKMM;




--
/**
  * Documentacion para el procedimiento INSERT_MIGRA_ARCKML
  * Insert los detalles del asiento contable
  * @param Pr_MigraArckml       IN  MIGRA_ARCKML%ROWTYPE Recibe un objeto como MIGRA_ARCKML
  * @param Pv_MsnError          OUT VARCHAR2  Devuelve el mensaje de error
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 22-12-2015
  */
PROCEDURE INSERT_MIGRA_ARCKML
            (
              Pr_MigraArckml IN  NAF47_TNET.MIGRA_ARCKML%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
            )
IS
BEGIN
  Pv_MsnError:='OK';
  --
            --INSERTA CREDITO DEL ASIENTO
            ----------------------------
            INSERT INTO NAF47_TNET.MIGRA_ARCKML 
            (
                NO_CIA, 
                PROCEDENCIA, 
                TIPO_DOC, 
                NO_DOCU, 
                COD_CONT, 
                CENTRO_COSTO, 
                TIPO_MOV,        
                MONTO, 
                MONTO_DOl, 
                TIPO_CAMBIO,        
                MONEDA,         
                MODIFICABLE, 
                ANO, 
                MES,         
                MONTO_DC, 
                GLOSA
            )
            VALUES
            (
                Pr_MigraArckml.NO_CIA,
                Pr_MigraArckml.PROCEDENCIA,
                Pr_MigraArckml.TIPO_DOC,
                Pr_MigraArckml.NO_DOCU,
                Pr_MigraArckml.COD_CONT,
                Pr_MigraArckml.CENTRO_COSTO,
                Pr_MigraArckml.TIPO_MOV,
                Pr_MigraArckml.MONTO,
                Pr_MigraArckml.MONTO_DOl,
                Pr_MigraArckml.TIPO_CAMBIO,
                Pr_MigraArckml.MONEDA,
                Pr_MigraArckml.MODIFICABLE,
                Pr_MigraArckml.ANO,
                Pr_MigraArckml.MES,        
                Pr_MigraArckml.MONTO_DC,
                Pr_MigraArckml.GLOSA
            );  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;

  --
END INSERT_MIGRA_ARCKML;





--
/**
  * Documentacion para el procedimiento UPDATE_MIGRA_ARCKMM
  * actualiza asiento contable
  * @param Pr_no_docu      IN  VARCHAR2
  * @param Pr_no_cia       IN  VARCHAR2 
  * @param Pr_MigraArckmm  IN  MIGRA_ARCKMM%ROWTYPE Recibe un objeto como MIGRA_ARCKMM
  * @param Pv_MsnError     OUT VARCHAR2  Devuelve el mensaje de error
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 22-12-2015
  */
PROCEDURE UPDATE_MIGRA_ARCKMM(
              Pr_no_docu IN VARCHAR2,
              Pr_no_cia IN VARCHAR2,
              Pr_MigraArckmm IN  NAF47_TNET.MIGRA_ARCKMM%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
)
IS

BEGIN
  Pv_MsnError:='OK';  
            --INSERTA CABECERA DEL ASIENTO
            ----------------------------
UPDATE NAF47_TNET.MIGRA_ARCKMM 
SET 
    NO_CIA           = NVL(Pr_MigraArckmm.NO_CIA,NO_CIA),
    NO_CTA           = NVL(Pr_MigraArckmm.NO_CTA,NO_CTA), 
    PROCEDENCIA      = NVL(Pr_MigraArckmm.PROCEDENCIA,PROCEDENCIA), 
    TIPO_DOC         = NVL(Pr_MigraArckmm.TIPO_DOC,TIPO_DOC), 
    NO_DOCU          = NVL(Pr_MigraArckmm.NO_DOCU,NO_DOCU), 
    FECHA            = NVL(Pr_MigraArckmm.FECHA,FECHA), 
    COMENTARIO       = NVL(Pr_MigraArckmm.COMENTARIO,COMENTARIO), 
    MONTO            = NVL(Pr_MigraArckmm.MONTO,MONTO), 
    ESTADO           = NVL(Pr_MigraArckmm.ESTADO,ESTADO), 
    CONCILIADO       = NVL(Pr_MigraArckmm.CONCILIADO,CONCILIADO), 
    MES              = NVL(Pr_MigraArckmm.MES,MES), 
    ANO              = NVL(Pr_MigraArckmm.ANO,ANO), 
    IND_OTROMOV      = NVL(Pr_MigraArckmm.IND_OTROMOV,IND_OTROMOV), 
    MONEDA_CTA       = NVL(Pr_MigraArckmm.MONEDA_CTA,MONEDA_CTA), 
    TIPO_CAMBIO      = NVL(Pr_MigraArckmm.TIPO_CAMBIO,TIPO_CAMBIO), 
    T_CAMB_C_V       = NVL(Pr_MigraArckmm.T_CAMB_C_V,T_CAMB_C_V),
    IND_OTROS_MESES  = NVL(Pr_MigraArckmm.IND_OTROS_MESES,IND_OTROS_MESES),
    NO_FISICO        = NVL(Pr_MigraArckmm.NO_FISICO,NO_FISICO),
    SERIE_FISICO     = NVL(Pr_MigraArckmm.SERIE_FISICO,SERIE_FISICO),    
    ORIGEN           = NVL(Pr_MigraArckmm.ORIGEN,ORIGEN),
    USUARIO_CREACION = NVL(Pr_MigraArckmm.USUARIO_CREACION,USUARIO_CREACION),
    FECHA_DOC        = NVL(Pr_MigraArckmm.FECHA_DOC,FECHA_DOC),
    IND_DIVISION     = NVL(Pr_MigraArckmm.IND_DIVISION,IND_DIVISION),
    FECHA_CREACION   = NVL(Pr_MigraArckmm.FECHA_CREACION,FECHA_CREACION),
    PROCESADO        = NVL(Pr_MigraArckmm.PROCESADO,PROCESADO)     
WHERE
    NO_DOCU=Pr_no_docu 
    AND NO_CIA=Pr_no_cia ;

EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;

END UPDATE_MIGRA_ARCKMM;




--
/**
  * Documentacion para el procedimiento UPDATE_MIGRA_ARCGAE
  * actualiza asiento contable
  * @param Pr_no_asiento   IN  VARCHAR2
  * @param Pr_no_cia       IN  VARCHAR2 
  * @param Pr_MigraArcgae  IN  MIGRA_ARCGAE%ROWTYPE Recibe un objeto como MIGRA_ARCGAE
  * @param Pv_MsnError     OUT VARCHAR2  Devuelve el mensaje de error
  * @author Andres Montero <amontero@telconet.ec>
  * @version 1.0 19-06-2016
  */
PROCEDURE UPDATE_MIGRA_ARCGAE(
              Pr_no_asiento IN VARCHAR2,
              Pr_no_cia IN VARCHAR2,
              Pr_MigraArcgae IN  NAF47_TNET.MIGRA_ARCGAE%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
)
IS

BEGIN
  Pv_MsnError:='OK';  
            --INSERTA CABECERA DEL ASIENTO
            ----------------------------
UPDATE NAF47_TNET.MIGRA_ARCGAE 
SET     
    NO_CIA           = NVL(Pr_MigraArcgae.NO_CIA,NO_CIA),
    ANO              = NVL(Pr_MigraArcgae.ANO,ANO),   
    MES              = NVL(Pr_MigraArcgae.MES,MES),      
    NO_ASIENTO       = NVL(Pr_MigraArcgae.NO_ASIENTO,NO_ASIENTO),
    IMPRESO          = NVL(Pr_MigraArcgae.IMPRESO,IMPRESO),  
    FECHA            = NVL(Pr_MigraArcgae.FECHA,FECHA),     
    DESCRI1          = NVL(Pr_MigraArcgae.DESCRI1,DESCRI1),    
    ESTADO           = NVL(Pr_MigraArcgae.ESTADO,ESTADO), 
    AUTORIZADO       = NVL(Pr_MigraArcgae.AUTORIZADO,AUTORIZADO),
    ORIGEN           = NVL(Pr_MigraArcgae.ORIGEN,ORIGEN),   
    T_DEBITOS        = NVL(Pr_MigraArcgae.T_DEBITOS,T_DEBITOS),
    T_CREDITOS       = NVL(Pr_MigraArcgae.T_CREDITOS,T_CREDITOS),    
    COD_DIARIO       = NVL(Pr_MigraArcgae.COD_DIARIO,COD_DIARIO),  
    T_CAMB_C_V       = NVL(Pr_MigraArcgae.T_CAMB_C_V,T_CAMB_C_V),    
    TIPO_CAMBIO      = NVL(Pr_MigraArcgae.TIPO_CAMBIO,TIPO_CAMBIO), 
    TIPO_COMPROBANTE = NVL(Pr_MigraArcgae.TIPO_COMPROBANTE,TIPO_COMPROBANTE), 
    NUMERO_CTRL      = NVL(Pr_MigraArcgae.NUMERO_CTRL,NUMERO_CTRL), 
    ANULADO          = NVL(Pr_MigraArcgae.ANULADO,ANULADO),
    USUARIO_CREACION = NVL(Pr_MigraArcgae.USUARIO_CREACION,USUARIO_CREACION),    
    TRANSFERIDO      = NVL(Pr_MigraArcgae.TRANSFERIDO,TRANSFERIDO),
    FECHA_CREACION   = NVL(Pr_MigraArcgae.FECHA_CREACION,FECHA_CREACION),    
    USUARIO_PROCESA  = NVL(Pr_MigraArcgae.USUARIO_PROCESA,USUARIO_PROCESA),    
    FECHA_PROCESA    = NVL(Pr_MigraArcgae.FECHA_PROCESA,FECHA_PROCESA)
WHERE
    NO_ASIENTO=Pr_no_asiento 
    AND NO_CIA=Pr_no_cia ;

EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;

END UPDATE_MIGRA_ARCGAE;



--
/**
  * Documentacion para el procedimiento INSERT_INFO_PROCESO_MASIVO_CAB
  * Insert los detalles del proceso masivo cab
  * @param Pr_InfoProcesoMasivoCab  IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE Recibe un objeto como INFO_PROCESO_MASIVO_CAB
  * @param Pv_MsnError              OUT VARCHAR2  Devuelve el mensaje de error
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 29-01-2015
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 23-04-2018 - Se modifica para asignar ip creación 127.0.0.1 por defecto pues cuando se ejecuta por JOB no recupera IP
                              y genera error porque no puede insertar valor nulo
  */
PROCEDURE INSERT_INFO_PROCESO_MASIVO_CAB
            (
              Pr_InfoProcesoMasivoCab IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
            )
IS
BEGIN
  Pv_MsnError:='OK';
  --
  INSERT INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB 
  (
      ID_PROCESO_MASIVO_CAB,
      TIPO_PROCESO,
      EMPRESA_ID,
      CANAL_PAGO_LINEA_ID,
      CANTIDAD_PUNTOS,
      CANTIDAD_SERVICIOS,
      FACTURAS_RECURRENTES,
      FECHA_EMISION_FACTURA,
      FECHA_CORTE_DESDE,
      FECHA_CORTE_HASTA,
      VALOR_DEUDA,
      FORMA_PAGO_ID,
      IDS_BANCOS_TARJETAS,
      IDS_OFICINAS,
      ESTADO,
      FE_CREACION,
      FE_ULT_MOD,
      USR_CREACION,
      USR_ULT_MOD,
      IP_CREACION,
      PLAN_ID,
      PLAN_VALOR,
      PAGO_ID,
      PAGO_LINEA_ID,
      RECAUDACION_ID,
      DEBITO_ID
  )
  VALUES
  (
      Pr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB,
      Pr_InfoProcesoMasivoCab.TIPO_PROCESO,
      Pr_InfoProcesoMasivoCab.EMPRESA_ID,
      Pr_InfoProcesoMasivoCab.CANAL_PAGO_LINEA_ID,
      Pr_InfoProcesoMasivoCab.CANTIDAD_PUNTOS,
      Pr_InfoProcesoMasivoCab.CANTIDAD_SERVICIOS,
      Pr_InfoProcesoMasivoCab.FACTURAS_RECURRENTES,
      Pr_InfoProcesoMasivoCab.FECHA_EMISION_FACTURA,
      Pr_InfoProcesoMasivoCab.FECHA_CORTE_DESDE,
      Pr_InfoProcesoMasivoCab.FECHA_CORTE_HASTA,
      Pr_InfoProcesoMasivoCab.VALOR_DEUDA,
      Pr_InfoProcesoMasivoCab.FORMA_PAGO_ID,
      Pr_InfoProcesoMasivoCab.IDS_BANCOS_TARJETAS,
      Pr_InfoProcesoMasivoCab.IDS_OFICINAS,
      Pr_InfoProcesoMasivoCab.ESTADO,
      Pr_InfoProcesoMasivoCab.FE_CREACION,
      Pr_InfoProcesoMasivoCab.FE_ULT_MOD,
      Pr_InfoProcesoMasivoCab.USR_CREACION,
      Pr_InfoProcesoMasivoCab.USR_ULT_MOD,
      NVL(Pr_InfoProcesoMasivoCab.IP_CREACION,'127.0.0.1'),
      Pr_InfoProcesoMasivoCab.PLAN_ID,
      Pr_InfoProcesoMasivoCab.PLAN_VALOR,
      Pr_InfoProcesoMasivoCab.PAGO_ID,
      Pr_InfoProcesoMasivoCab.PAGO_LINEA_ID,
      Pr_InfoProcesoMasivoCab.RECAUDACION_ID,
      Pr_InfoProcesoMasivoCab.DEBITO_ID
  );  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;

  --
END INSERT_INFO_PROCESO_MASIVO_CAB;


--
/**
  * Documentacion para el procedimiento INSERT_INFO_PROCESO_MASIVO_DET
  * Insert los detalles del proceso masivo cab
  * @param Pr_InfoProcesoMasivoDet  IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE Recibe un objeto como INFO_PROCESO_MASIVO_DET
  * @param Pv_MsnError              OUT VARCHAR2  Devuelve el mensaje de error
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 29-01-2015
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 23-04-2018 - Se modifica para asignar ip creación 127.0.0.1 por defecto pues cuando se ejecuta por JOB no recupera IP
                              y genera error porque no puede insertar valor nulo
  */
PROCEDURE INSERT_INFO_PROCESO_MASIVO_DET
            (
              Pr_InfoProcesoMasivoDet IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
              Pv_MsnError    OUT VARCHAR2
            )
IS
BEGIN
  Pv_MsnError:='OK';
  --
  INSERT INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET 
  (
      ID_PROCESO_MASIVO_DET,
      PROCESO_MASIVO_CAB_ID,
      PUNTO_ID,
      ESTADO,
      FE_CREACION,
      FE_ULT_MOD,
      USR_CREACION,
      USR_ULT_MOD,
      IP_CREACION,
      SERVICIO_ID,
      OBSERVACION
  )
  VALUES
  (
      Pr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET,
      Pr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID,
      Pr_InfoProcesoMasivoDet.PUNTO_ID,
      Pr_InfoProcesoMasivoDet.ESTADO,
      Pr_InfoProcesoMasivoDet.FE_CREACION,
      Pr_InfoProcesoMasivoDet.FE_ULT_MOD,
      Pr_InfoProcesoMasivoDet.USR_CREACION,
      Pr_InfoProcesoMasivoDet.USR_ULT_MOD,
      NVL(Pr_InfoProcesoMasivoDet.IP_CREACION,'127.0.0.1'),
      Pr_InfoProcesoMasivoDet.SERVICIO_ID,
      Pr_InfoProcesoMasivoDet.OBSERVACION
  );  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;

  --
END INSERT_INFO_PROCESO_MASIVO_DET;

--
PROCEDURE INSERT_CTA_CONTABLE(
  Pn_TipoCuentaContableId     IN ADMI_CUENTA_CONTABLE.TIPO_CUENTA_CONTABLE_ID%TYPE,
  Pv_EmpresaCod               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  Pv_Cuenta                   IN VARCHAR2,
  Pv_Descripcion              IN VARCHAR2
)
IS
  Lv_VariableQuery            VARCHAR2(32000);
  Ln_AnchoSubstring           NUMBER;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  --
  IF(Pv_Descripcion = 'PRODUCTO')THEN
    Ln_AnchoSubstring := 16;
  ELSE
    Ln_AnchoSubstring := 20;
  END IF;
  --
  Lv_VariableQuery  :='INSERT
  INTO DB_FINANCIERO.ADMI_CUENTA_CONTABLE
    (
      ID_CUENTA_CONTABLE,
      NO_CIA,
      CUENTA,
      TABLA_REFERENCIAL,
      CAMPO_REFERENCIAL,
      VALOR_CAMPO_REFERENCIAL,
      NOMBRE_OBJETO_NAF,
      TIPO_CUENTA_CONTABLE_ID,
      DESCRIPCION,
      EMPRESA_COD,
      OFICINA_ID,
      FE_CREACION,
      USR_CREACION,
      IP_CREACION,
      ESTADO
    )
  SELECT DB_FINANCIERO.SEQ_ADMI_CUENTA_CONTABLE.nextval,
    NO_CIA,
    CUENTA,
    TABLA_REFERENCIAL,
    CAMPO_REFERENCIAL,
    VALOR_CAMPO_REFERENCIAL,
    NOMBRE_OBJETO_NAF,
    TIPO_CUENTA_CONTABLE_ID,
    DESCRIPCION,
    EMPRESA_COD,
    OFICINA_ID,
    FE_CREACION,
    USR_CREACION,
    IP_CREACION,
    ESTADO
  FROM
    (
        SELECT cc.NO_CIA,
        cc.cuenta,
        ''ADMI_PRODUCTO'' AS TABLA_REFERENCIAL,
        ''ID_PRODUCTO''   AS CAMPO_REFERENCIAL,
        ap.ID_PRODUCTO    AS VALOR_CAMPO_REFERENCIAL,
        ''ARCGMS''        AS NOMBRE_OBJETO_NAF,'
        || Pn_TipoCuentaContableId || ' AS TIPO_CUENTA_CONTABLE_ID,'
        || 'CONCAT( CONCAT( CONCAT ('|| q'[']' || Pv_Descripcion || ':' || q'[']' || ', ap.CODIGO_PRODUCTO ), '||q'[' - ']'||' ) , iog.NOMBRE_OFICINA ) AS DESCRIPCION,'
        || 'AP.EMPRESA_COD,
        iog.ID_OFICINA AS OFICINA_ID,
        sysdate        AS fe_creacion,
        ''gvillalba''    AS usr_creacion,
        ''127.0.0.1''    AS ip_creacion,
        ''Activo''       AS estado
        FROM NAF47_TNET.ARCGMS cc
        JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO iog
        ON trim(SUBSTR(upper(iog.NOMBRE_OFICINA),12))=trim(SUBSTR(upper(cc.DESCRI),'|| Ln_AnchoSubstring ||'))
        JOIN DB_COMERCIAL.ADMI_PRODUCTO ap
        ON IOG.EMPRESA_ID=AP.EMPRESA_COD
        WHERE cc.CUENTA LIKE '|| q'[']' || Pv_Cuenta ||q'[%']'
        ||' AND cc.no_cia   ='|| q'[']' || Pv_EmpresaCod || q'[']' ||'
        AND iog.EMPRESA_ID  ='|| q'[']' || Pv_EmpresaCod || q'[']' ||'
        AND ap.EMPRESA_COD  ='|| q'[']' || Pv_EmpresaCod || q'[']' ||'
        AND cc.IND_MOV      ='||q'['S']'||'
        AND ap.id_producto IN
        (
          SELECT id_producto
          FROM DB_COMERCIAL.admi_producto
          WHERE EMPRESA_COD    ='|| q'[']' || Pv_EmpresaCod || q'[']' ||'
          AND id_producto NOT IN
            (
              SELECT DB_FINANCIERO.ADMI_CUENTA_CONTABLE.VALOR_CAMPO_REFERENCIAL
              FROM DB_FINANCIERO.ADMI_CUENTA_CONTABLE
              WHERE CAMPO_REFERENCIAL     =' || q'['ID_PRODUCTO']' ||'
              AND TIPO_CUENTA_CONTABLE_ID =' || Pn_TipoCuentaContableId ||'
            )
        )
    )';
    --
    EXECUTE IMMEDIATE Lv_VariableQuery;   
    --
    COMMIT;
    --
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Lv_InfoError := SQLERRM;
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_TRANSACTION_CONTABILIZAR.INSERT_CTA_CONTABLE', Lv_InfoError);  
    --
END INSERT_CTA_CONTABLE;
--
--
PROCEDURE P_MARCA_PAGOS_DEPENDIENTES(
  Pn_IdPago                   IN INFO_PAGO_CAB.ID_PAGO%TYPE,
  Pv_CodigoTipoDocumento      IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
  Pv_NumeroPago               IN DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
  Pn_EmpresaId                IN VARCHAR2,
  Pv_MsnError                 OUT VARCHAR2
)
IS
  --
  --Obtengo IdMotivo del pago por Anulacion por dependicia.
  CURSOR C_GetIdMotivoPorNombre(Cv_Nombre DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
                                Cv_Estado DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE)
  IS
  SELECT AM.ID_MOTIVO
  FROM  DB_GENERAL.ADMI_MOTIVO AM
  WHERE AM.NOMBRE_MOTIVO = Cv_Nombre
  AND   AM.ESTADO        = Cv_Estado;
  --
  --Recupera el Registro del pago padre
CURSOR C_Get_IdPago(Cn_IdPago       DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                    Cn_EmpresaId    VARCHAR2,
                    Cv_NombreMotivo VARCHAR2) 
  IS
  SELECT IPC.ID_PAGO, 
         IPC.ANTICIPO_ID, 
         IPC.PAGO_ID, 
         ATDF.CODIGO_TIPO_DOCUMENTO,
         IPC.EMPRESA_ID,
         IPC.ESTADO_PAGO,
         IPC.TIPO_DOCUMENTO_ID
  FROM DB_FINANCIERO.INFO_PAGO_CAB IPC ,
       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
  where ATDF.ID_TIPO_DOCUMENTO =   IPC.TIPO_DOCUMENTO_ID 
  AND  IPC.EMPRESA_ID         =  Cn_EmpresaId
  AND  IPC.ID_PAGO            =  Cn_IdPago
  AND  NOT EXISTS (SELECT IPH.PAGO_ID
                    FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH,
                         DB_GENERAL.ADMI_MOTIVO AM
                    WHERE IPH.MOTIVO_ID  = AM.ID_MOTIVO
                    AND IPH.PAGO_ID      = IPC.ID_PAGO
                    AND AM.NOMBRE_MOTIVO = Cv_NombreMotivo);

--Recupera el Id del Anticipo Padre
CURSOR C_Get_AnticipoPadre_Id(Cn_PagoId       DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                              Cn_EmpresaId    VARCHAR2,
                              Cv_NombreMotivo VARCHAR2)
  IS
  SELECT IPC.ID_PAGO, 
         IPC.ANTICIPO_ID, 
         IPC.PAGO_ID, 
         IPC.EMPRESA_ID,
         IPC.TIPO_DOCUMENTO_ID,
         IPC.ESTADO_PAGO
  FROM DB_FINANCIERO.INFO_PAGO_CAB IPC 
  WHERE   IPC.EMPRESA_ID         = Cn_EmpresaId
  AND     IPC.PAGO_ID            =  Cn_PagoId
  AND     IPC.ANTICIPO_ID IS NULL
  AND     NOT EXISTS (SELECT IPH.PAGO_ID
                      FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH,
                           DB_GENERAL.ADMI_MOTIVO AM
                      WHERE IPH.MOTIVO_ID  = AM.ID_MOTIVO
                      AND IPH.PAGO_ID      = IPC.ID_PAGO
                      AND AM.NOMBRE_MOTIVO = Cv_NombreMotivo);
  --
  Lr_Get_IdPago         C_Get_IdPago%ROWTYPE                      := NULL;
  Lr_Get_AnticipoPadre  C_Get_AnticipoPadre_Id%ROWTYPE            := NULL;
  Ln_IdPago             DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  := NULL;  
  Ln_IdPagoTmp          DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  := NULL; 
  Ln_PagoIdAnticipo     DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  := NULL; 
  Lv_EstadoPago         DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE  := 'Anulado';
  Lv_NombreMotivo       DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE     := 'ANULACION_DEPENCIA';
  Lv_EstadoMotivo       DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE            := 'Activo';
  Ln_IdMotivoAnulaDep   DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE         := NULL;
  Lr_InfoPagoHistorial  DB_FINANCIERO.INFO_PAGO_HISTORIAL%ROWTYPE     := NULL;
  Lv_MsnError           VARCHAR2(4000);
  Lr_IdPagosFe          DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.Type_IdPagosAsociados;
  Ln_IdPagoTemporal     DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;
  Lex_Exception         EXCEPTION;
  Ln_ContDocsAsociados  NUMBER                                        := 0;
  Ln_ContPagosHistoDep  NUMBER                                        := 0;
  --
BEGIN
    IF  Pn_IdPago               IS NOT NULL  AND 
        Pn_EmpresaId            IS NOT NULL  AND 
        Pv_CodigoTipoDocumento  IS NOT NULL  AND
        Pv_NumeroPago           IS NOT NULL  THEN
        --
        --Recupero el IdMotivo para el pago por Anulacion por dependencia.
        IF C_GetIdMotivoPorNombre%ISOPEN THEN
          CLOSE C_GetIdMotivoPorNombre;
        END IF;
        --
        OPEN C_GetIdMotivoPorNombre(Lv_NombreMotivo, Lv_EstadoMotivo);
        FETCH C_GetIdMotivoPorNombre INTO Ln_IdMotivoAnulaDep;
        CLOSE C_GetIdMotivoPorNombre;
        --
        IF C_Get_IdPago%ISOPEN THEN
          CLOSE C_Get_IdPago;
        END IF;
        --
        OPEN  C_Get_IdPago(Pn_IdPago, Pn_EmpresaId, Lv_NombreMotivo);
        FETCH C_Get_IdPago INTO Lr_Get_IdPago;
        CLOSE C_Get_IdPago;
        --
        --Verifico que sea un PAG, este documento ya está ANULADO
        IF Lr_Get_IdPago.ANTICIPO_ID IS NULL AND 
           Lr_Get_IdPago.PAGO_ID     IS NULL AND
           Lr_Get_IdPago.ID_PAGO     IS NOT NULL THEN
            --ESTE ES UN PADRE
            IF C_Get_AnticipoPadre_Id%ISOPEN THEN
              CLOSE C_Get_AnticipoPadre_Id;
            END IF;
            --
            OPEN  C_Get_AnticipoPadre_Id(Lr_Get_IdPago.ID_PAGO, Lr_Get_IdPago.EMPRESA_ID, Lv_NombreMotivo);
            FETCH C_Get_AnticipoPadre_Id INTO Lr_Get_AnticipoPadre;
            CLOSE C_Get_AnticipoPadre_Id;
            --
            -- LLAMAR FUNCION QUE DEVUELVA TODOS LOS REGISTROS ASOCIADOS
            --
            Ln_IdPagoTmp := Lr_Get_AnticipoPadre.ID_PAGO;

            IF Ln_IdPagoTmp IS NOT NULL THEN
              --
              Lr_IdPagosFe := DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.F_GET_ID_PAGO_RELACIONADO(Ln_IdPagoTmp,
                                                                                                    Lr_Get_AnticipoPadre.EMPRESA_ID);
              --Si el Documento es un Padre - 'PAG', agrego 'ANT' y los registros asociados al Anticipos
              IF  Lr_IdPagosFe IS NOT NULL AND 
                  Lr_IdPagosFe.COUNT > 0   THEN
                  --
                  Ln_ContDocsAsociados := Lr_IdPagosFe.LAST;
                  Ln_ContDocsAsociados := Ln_ContDocsAsociados + 1;
                  Lr_IdPagosFe(Ln_ContDocsAsociados).ID_PAGO           := Lr_Get_AnticipoPadre.ID_PAGO;
                  Lr_IdPagosFe(Ln_ContDocsAsociados).ESTADO_PAGO       := Lr_Get_AnticipoPadre.ESTADO_PAGO;
                  Lr_IdPagosFe(Ln_ContDocsAsociados).ANTICIPO_ID       := Lr_Get_AnticipoPadre.ANTICIPO_ID;
                  Lr_IdPagosFe(Ln_ContDocsAsociados).TIPO_DOCUMENTO_ID := Lr_Get_AnticipoPadre.TIPO_DOCUMENTO_ID;
                  --
              END IF;
              --
           END IF;
        --
        ELSE
          --No es un Pago (Padre) - Puede ser ANT|ANTC|PAGC
           Ln_IdPago := DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.F_GET_ID_ANTICIPO_PADRE( Lr_Get_IdPago.ID_PAGO, 
                                                                                             Lr_Get_IdPago.CODIGO_TIPO_DOCUMENTO,
                                                                                             Lr_Get_IdPago.EMPRESA_ID);
           IF Ln_IdPago IS NOT NULL THEN
              --
              Lr_IdPagosFe := DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.F_GET_ID_PAGO_RELACIONADO(Ln_IdPago,
                                                                                                    Lr_Get_IdPago.EMPRESA_ID);
              --
              IF  Lr_IdPagosFe IS NOT NULL AND 
                  Lr_IdPagosFe.COUNT > 0   THEN
                  -- F_AGREGA_PADRES_RELACIONADOS
                    Lr_IdPagosFe := DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.F_AGREGA_PADRES_RELACIONADOS(Ln_IdPago,        Lr_IdPagosFe,
                                                                                                             Lr_IdPagosFe.LAST,Pn_EmpresaId);
                  --
              ELSE
                  --
                  --No hay documentos creados por un cruce de ANTICIPOS, por el ANT (Padre) => agrego al PAG 
                  --Recupero el PAGO_ID del ANT y agrego el PAG.
                    --
                    Ln_PagoIdAnticipo := Lr_Get_IdPago.PAGO_ID;
                    Lr_Get_IdPago     :=  NULL;
                    --
                    IF C_Get_IdPago%ISOPEN THEN
                      CLOSE C_Get_IdPago;
                    END IF;
                    --
                    OPEN  C_Get_IdPago(Ln_PagoIdAnticipo, Pn_EmpresaId, Lv_NombreMotivo);
                    FETCH C_Get_IdPago INTO Lr_Get_IdPago;
                    CLOSE C_Get_IdPago;
                    --
                    --Agrego el PAGO.
                    --
                    Ln_ContDocsAsociados := 1;
                    Lr_IdPagosFe(Ln_ContDocsAsociados).ID_PAGO           := Lr_Get_IdPago.ID_PAGO;
                    Lr_IdPagosFe(Ln_ContDocsAsociados).ESTADO_PAGO       := Lr_Get_IdPago.ESTADO_PAGO;
                    Lr_IdPagosFe(Ln_ContDocsAsociados).ANTICIPO_ID       := Lr_Get_IdPago.ANTICIPO_ID;
                    Lr_IdPagosFe(Ln_ContDocsAsociados).TIPO_DOCUMENTO_ID := Lr_Get_IdPago.TIPO_DOCUMENTO_ID;
                  --
                  --
              END IF;
              --
           END IF;
          --
        END IF;
        --
        --
        IF  Lr_IdPagosFe IS NOT NULL AND
            Lr_IdPagosFe.COUNT > 0   THEN 
            --
            --Ingresar al historial:
              FOR idx IN Lr_IdPagosFe.FIRST .. Lr_IdPagosFe.LAST
              LOOP
                      --
                      IF Lr_IdPagosFe(idx).ID_PAGO     <> Pn_IdPago     AND  --No insertar Pago que se esta Anulando
                         Lr_IdPagosFe(idx).ESTADO_PAGO <> Lv_EstadoPago THEN --No insertar Pago diferente de Anulado
                          --
                          Lr_InfoPagoHistorial := NULL;
                          --
                          --Inserto Anticipo 'Cerrado' a Historial por dependencia de pago.
                          Lr_InfoPagoHistorial.PAGO_ID      := Lr_IdPagosFe(idx).ID_PAGO;
                          Lr_InfoPagoHistorial.MOTIVO_ID    := Ln_IdMotivoAnulaDep;
                          Lr_InfoPagoHistorial.FE_CREACION  := SYSDATE;
                          Lr_InfoPagoHistorial.USR_CREACION := 'telcos_anulacion';
                          Lr_InfoPagoHistorial.ESTADO       := Lr_IdPagosFe(idx).ESTADO_PAGO;
                          Lr_InfoPagoHistorial.OBSERVACION  := 'Anulacion con Dependencia: ' || Pv_NumeroPago;
                          --
                          DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_PAGO_HISTORIAL_DEPENCIA(Lr_InfoPagoHistorial, Lv_MsnError);
                          --
                          IF Lv_MsnError <> 'OK' THEN
                             RAISE Lex_Exception;
                          END IF;
                          --
                          Ln_ContPagosHistoDep := Ln_ContPagosHistoDep + 1;
                          --
                      END IF;
                      --
              END LOOP;
              --
              --Hago COMMIT siempre y cuando halla por lo menos un ingreso al historial.
              IF Ln_ContPagosHistoDep > 0 THEN
                COMMIT;
              END IF;
              --
        END IF;
        --
    END IF;
    --
    EXCEPTION
    WHEN Lex_Exception THEN
      --
      Pv_MsnError := Lv_MsnError || ' ' || SQLERRM;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNKG_TRANSACTION_CONTABILIZAR.P_MARCA_PAGOS_DEPENDIENTES', 
                                            Pv_MsnError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

      --
    WHEN OTHERS THEN
      --
      Pv_MsnError := Lv_MsnError || ' ERROR_STACK: ' || 
                         DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNKG_TRANSACTION_CONTABILIZAR.P_MARCA_PAGOS_DEPENDIENTES', 
                                            Pv_MsnError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
END P_MARCA_PAGOS_DEPENDIENTES;
--
--
PROCEDURE INSERT_PAGO_HISTORIAL_DEPENCIA
            (
              Pr_PagosHistorialDep IN  DB_FINANCIERO.INFO_PAGO_HISTORIAL%ROWTYPE,
              Pv_MsnError          OUT VARCHAR2
            )
IS
BEGIN
  Pv_MsnError:='OK';
  --
            --INSERTA PAGO CON HISTORIAL DE ANULACION DEPENDENCIA
            ----------------------------
            INSERT INTO DB_FINANCIERO.INFO_PAGO_HISTORIAL 
            (
                ID_PAGO_HISTORIAL, 
                PAGO_ID,
                MOTIVO_ID, 
                FE_CREACION, 
                USR_CREACION, 
                ESTADO, 
                OBSERVACION 
            )
            VALUES
            (
                DB_FINANCIERO.SEQ_INFO_PAGO_HISTORIAL.nextval,
                Pr_PagosHistorialDep.PAGO_ID,
                Pr_PagosHistorialDep.MOTIVO_ID,
                Pr_PagosHistorialDep.FE_CREACION,
                Pr_PagosHistorialDep.USR_CREACION,
                Pr_PagosHistorialDep.ESTADO,
                Pr_PagosHistorialDep.OBSERVACION
            );  
--
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsnError := SQLERRM;
  --
END INSERT_PAGO_HISTORIAL_DEPENCIA;
--
FUNCTION F_GET_ID_PAGO_RELACIONADO(
    Fn_IdPago       IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
    Fn_EmpresaId    IN  VARCHAR2)
    RETURN Type_IdPagosAsociados
IS
--
CURSOR C_GetPago(Cn_IdPago       DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                 Cn_EmpresaId    VARCHAR2,
                 Cv_NombreMotivo VARCHAR2)
  IS
   SELECT IPC.ID_PAGO, 
          IPC.ESTADO_PAGO, 
          IPC.ANTICIPO_ID, 
          IPC.TIPO_DOCUMENTO_ID
  FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
  WHERE  IPC.EMPRESA_ID        =  Cn_EmpresaId
  AND    IPC.ANTICIPO_ID       =  Cn_IdPago
  AND     NOT EXISTS (SELECT IPH.PAGO_ID
                      FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH,
                           DB_GENERAL.ADMI_MOTIVO AM
                      WHERE IPH.MOTIVO_ID  = AM.ID_MOTIVO
                      AND IPH.PAGO_ID      = IPC.ID_PAGO
                      AND AM.NOMBRE_MOTIVO = Cv_NombreMotivo)
  ORDER BY IPC.ID_PAGO;

  Lrf_PagosRelacionados         DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.Type_IdPagosAsociados;
  Lrf_PagoRelacionadoDevueltos  DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.Type_IdPagosAsociados;
  Lv_NombreMotivo               DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE     := 'ANULACION_DEPENCIA';

  Ln_Count NUMBER := 1;

BEGIN
--
-- Todos los documentos asociados a	l ANTICIPO PADRE
  FOR I_GetPagos IN C_GetPago(Fn_IdPago, Fn_EmpresaId, Lv_NombreMotivo)
    LOOP
      --
      -- SI ERES PAGO CRUZADO
      IF I_GetPagos.Tipo_Documento_ID = 11 THEN
            Lrf_PagosRelacionados(Ln_Count).ID_PAGO           := I_GetPagos.ID_PAGO;
            Lrf_PagosRelacionados(Ln_Count).ESTADO_PAGO       := I_GetPagos.ESTADO_PAGO;
            Lrf_PagosRelacionados(Ln_Count).ANTICIPO_ID       := I_GetPagos.ANTICIPO_ID;
            Lrf_PagosRelacionados(Ln_Count).TIPO_DOCUMENTO_ID := I_GetPagos.TIPO_DOCUMENTO_ID;
      END IF;
      --
      --SI ERES ANTICIPO CRUZADO
      IF I_GetPagos.Tipo_Documento_ID = 10 THEN
            Lrf_PagosRelacionados(Ln_Count).ID_PAGO           := I_GetPagos.ID_PAGO;
            Lrf_PagosRelacionados(Ln_Count).ESTADO_PAGO       := I_GetPagos.ESTADO_PAGO;
            Lrf_PagosRelacionados(Ln_Count).ANTICIPO_ID       := I_GetPagos.ANTICIPO_ID;
            Lrf_PagosRelacionados(Ln_Count).TIPO_DOCUMENTO_ID := I_GetPagos.TIPO_DOCUMENTO_ID;
            --
            Lrf_PagoRelacionadoDevueltos := DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.F_GET_ID_PAGO_RELACIONADO(I_GetPagos.ID_PAGO, Fn_EmpresaId);
            --
            --Itero los registros devueltos del ANT
            IF Lrf_PagoRelacionadoDevueltos IS NOT NULL AND 
               Lrf_PagoRelacionadoDevueltos.COUNT > 0   THEN  
                FOR idx IN Lrf_PagoRelacionadoDevueltos.FIRST .. Lrf_PagoRelacionadoDevueltos.LAST
                  LOOP
                      Ln_Count :=  Ln_Count + 1;
                      Lrf_PagosRelacionados(Ln_Count).ID_PAGO           := Lrf_PagoRelacionadoDevueltos(idx).ID_PAGO;
                      Lrf_PagosRelacionados(Ln_Count).ESTADO_PAGO       := Lrf_PagoRelacionadoDevueltos(idx).ESTADO_PAGO;
                      Lrf_PagosRelacionados(Ln_Count).ANTICIPO_ID       := Lrf_PagoRelacionadoDevueltos(idx).ANTICIPO_ID;
                      Lrf_PagosRelacionados(Ln_Count).TIPO_DOCUMENTO_ID := Lrf_PagoRelacionadoDevueltos(idx).TIPO_DOCUMENTO_ID;
                  END LOOP;
                  --
            END IF;
            --
      END IF;
      --
      Ln_Count := Ln_Count + 1 ;
      --
    END LOOP;--I_GetPagos
    --
    RETURN Lrf_PagosRelacionados;
--
END F_GET_ID_PAGO_RELACIONADO;
--
FUNCTION F_GET_ID_ANTICIPO_PADRE(
    Fn_IdPago        IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
    Fv_TipoDocumento IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fn_EmpresaId     IN  VARCHAR2)
    RETURN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE
IS
  --
  --Obtengo el AnticipoId de los pagos que nacieron por un ANT
  CURSOR C_GetAnticipoPagoIdPorIdPago(Cn_IdPago       DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                                      Cn_EmpresaId    VARCHAR2,
                                      Cv_NombreMotivo VARCHAR2)
  IS
   SELECT IPC.ANTICIPO_ID, IPC.EMPRESA_ID
  FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
  WHERE   IPC.EMPRESA_ID        =  Cn_EmpresaId
  AND     IPC.ID_PAGO            =  Cn_IdPago
  AND     NOT EXISTS (SELECT IPH.PAGO_ID
                      FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH,
                           DB_GENERAL.ADMI_MOTIVO AM
                      WHERE IPH.MOTIVO_ID  = AM.ID_MOTIVO
                      AND IPH.PAGO_ID      = IPC.ID_PAGO
                      AND AM.NOMBRE_MOTIVO = Cv_NombreMotivo)
  ORDER BY IPC.ID_PAGO;
  --
 CURSOR C_GetTipoDocumento(Cn_IdPago       DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                           Cn_EmpresaId    VARCHAR2,
                           Cv_NombreMotivo VARCHAR2)
  IS
  SELECT ATDF.CODIGO_TIPO_DOCUMENTO
  FROM DB_FINANCIERO.INFO_PAGO_CAB IPC,
      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
  WHERE IPC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO 
  AND   IPC.ID_PAGO             = Cn_IdPago
  AND   IPC.EMPRESA_ID        = Cn_EmpresaId
  AND   NOT EXISTS (SELECT IPH.PAGO_ID
                    FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH,
                         DB_GENERAL.ADMI_MOTIVO AM
                    WHERE IPH.MOTIVO_ID  = AM.ID_MOTIVO
                    AND IPH.PAGO_ID      = IPC.ID_PAGO
                    AND AM.NOMBRE_MOTIVO = Cv_NombreMotivo);
  --
  LrF_GetAnticipoPagoIdPorIdPago C_GetAnticipoPagoIdPorIdPago%ROWTYPE          := NULL;
  Ln_IdPago                      DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE      := NULL;
  Lv_EstadoPago                  DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE  := 'Anulado';
  Lv_NombreMotivo                DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE     := 'ANULACION_DEPENCIA';
  Lv_tipoDocumento               DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := NULL;
  --
BEGIN
--
  IF Fv_TipoDocumento = 'ANTC' OR Fv_TipoDocumento = 'PAGC'THEN
  --
      IF C_GetAnticipoPagoIdPorIdPago%ISOPEN THEN
        CLOSE C_GetAnticipoPagoIdPorIdPago;
      END IF;
      --
      OPEN  C_GetAnticipoPagoIdPorIdPago(Fn_IdPago, Fn_EmpresaId, Lv_NombreMotivo) ;
      --
      FETCH C_GetAnticipoPagoIdPorIdPago INTO LrF_GetAnticipoPagoIdPorIdPago;
      --
      CLOSE C_GetAnticipoPagoIdPorIdPago;
      --
      --Obtener el tipo de documento que es:
      IF C_GetTipoDocumento%ISOPEN THEN
        CLOSE C_GetTipoDocumento;
      END IF;
      --
      OPEN C_GetTipoDocumento(LrF_GetAnticipoPagoIdPorIdPago.ANTICIPO_ID,
                              LrF_GetAnticipoPagoIdPorIdPago.EMPRESA_ID,
                              Lv_NombreMotivo);
      --
      FETCH C_GetTipoDocumento INTO Lv_tipoDocumento;
      --
      CLOSE C_GetTipoDocumento;
      --
      IF LrF_GetAnticipoPagoIdPorIdPago.ANTICIPO_ID IS NOT NULL THEN
      --
      Ln_IdPago := DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.F_GET_ID_ANTICIPO_PADRE( LrF_GetAnticipoPagoIdPorIdPago.ANTICIPO_ID,
                                                                                        Lv_tipoDocumento,
                                                                                        LrF_GetAnticipoPagoIdPorIdPago.EMPRESA_ID);
      --
      END IF;
      --
  ELSE
  --
    Ln_IdPago := Fn_IdPago;
  --
  END IF;

  RETURN Ln_IdPago;
--  
END F_GET_ID_ANTICIPO_PADRE;
--
FUNCTION F_AGREGA_PADRES_RELACIONADOS(
    Fn_IdPago       IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,  
    Flr_IdPagosFe   IN  DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.Type_IdPagosAsociados,
    Fn_Idx          IN  NUMBER,
    Fn_EmpresaId    IN  VARCHAR2)
    RETURN Type_IdPagosAsociados
IS
--
--Recupera el Registro del pago padre
CURSOR C_Get_IdPago(Cn_IdPago       DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                    Cn_EmpresaId    VARCHAR2,
                    Cv_NombreMotivo VARCHAR2) 
  IS
  SELECT IPC.ID_PAGO, 
         IPC.ANTICIPO_ID, 
         IPC.PAGO_ID, 
         ATDF.CODIGO_TIPO_DOCUMENTO,
         IPC.EMPRESA_ID,
         IPC.ESTADO_PAGO,
         IPC.TIPO_DOCUMENTO_ID
  FROM DB_FINANCIERO.INFO_PAGO_CAB IPC ,
       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
  WHERE ATDF.ID_TIPO_DOCUMENTO =  IPC.TIPO_DOCUMENTO_ID 
  AND   IPC.EMPRESA_ID         =  Cn_EmpresaId
  AND   IPC.ID_PAGO            =  Cn_IdPago
  AND     NOT EXISTS (SELECT IPH.PAGO_ID
                      FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH,
                           DB_GENERAL.ADMI_MOTIVO AM
                      WHERE IPH.MOTIVO_ID  = AM.ID_MOTIVO
                      AND IPH.PAGO_ID      = IPC.ID_PAGO
                      AND AM.NOMBRE_MOTIVO = Cv_NombreMotivo);
  --
  LrF_Get_IdPago          C_Get_IdPago%ROWTYPE          := NULL;
  Ln_Idx                  NUMBER                        := 0;
  Ln_PagoId               DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  := NULL;
  Lv_NombreMotivo         DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE := 'ANULACION_DEPENCIA';
  Lrf_PagosAgregaPagosRel DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.Type_IdPagosAsociados;
  --
BEGIN
--
  IF Fn_IdPago    IS NOT NULL AND
     Fn_Idx       IS NOT NULL AND
     Fn_EmpresaId IS NOT NULL THEN
     --
     --Recupero el registro ANT para obtener el PAG (PAGO_ID) que lo generó.
      IF C_Get_IdPago%ISOPEN THEN
        CLOSE C_Get_IdPago;
      END IF;
      --
      OPEN  C_Get_IdPago(Fn_IdPago, Fn_EmpresaId,Lv_NombreMotivo) ;
      --
      FETCH C_Get_IdPago INTO LrF_Get_IdPago;
      --
      CLOSE C_Get_IdPago;
      --  
      --
      Lrf_PagosAgregaPagosRel := Flr_IdPagosFe;
      Ln_Idx                  := Fn_Idx;
      --
      IF LrF_Get_IdPago.CODIGO_TIPO_DOCUMENTO = 'ANT' THEN
        --
            Ln_Idx := Ln_Idx +1;
            Lrf_PagosAgregaPagosRel(Ln_Idx).ID_PAGO           := LrF_Get_IdPago.ID_PAGO;
            Lrf_PagosAgregaPagosRel(Ln_Idx).ESTADO_PAGO       := LrF_Get_IdPago.ESTADO_PAGO;
            Lrf_PagosAgregaPagosRel(Ln_Idx).ANTICIPO_ID       := LrF_Get_IdPago.ANTICIPO_ID;
            Lrf_PagosAgregaPagosRel(Ln_Idx).TIPO_DOCUMENTO_ID := LrF_Get_IdPago.TIPO_DOCUMENTO_ID;
        --
      END IF;
      --
      --Recupero el registro PAG por medio del PAGO_ID
      --
      IF LrF_Get_IdPago.PAGO_ID IS NOT NULL THEN
        --
        Ln_PagoId      := LrF_Get_IdPago.PAGO_ID;
        --
      END IF; 
      --
      LrF_Get_IdPago := NULL;
      --
      IF C_Get_IdPago%ISOPEN THEN
        CLOSE C_Get_IdPago;
      END IF;
      --
      OPEN  C_Get_IdPago(Ln_PagoId, Fn_EmpresaId,Lv_NombreMotivo) ;
      --
      FETCH C_Get_IdPago INTO LrF_Get_IdPago;
      --
      CLOSE C_Get_IdPago;
      --
      IF LrF_Get_IdPago.CODIGO_TIPO_DOCUMENTO = 'PAG' THEN
        --
            Ln_Idx := Ln_Idx +1;
            Lrf_PagosAgregaPagosRel(Ln_Idx).ID_PAGO           := LrF_Get_IdPago.ID_PAGO;
            Lrf_PagosAgregaPagosRel(Ln_Idx).ESTADO_PAGO       := LrF_Get_IdPago.ESTADO_PAGO;
            Lrf_PagosAgregaPagosRel(Ln_Idx).ANTICIPO_ID       := LrF_Get_IdPago.ANTICIPO_ID;
            Lrf_PagosAgregaPagosRel(Ln_Idx).TIPO_DOCUMENTO_ID := LrF_Get_IdPago.TIPO_DOCUMENTO_ID;
        --
      END IF;
      --
      RETURN Lrf_PagosAgregaPagosRel;
      --
  END IF;
--
END F_AGREGA_PADRES_RELACIONADOS;
--
END FNKG_TRANSACTION_CONTABILIZAR;
/