CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN 
AS
/**
  * Documentación para PROCEDURE  P_Update_Info_Documento_NAF'.
  * Procedure que me permite actualizar info_documento de los registros procedentes del sistema NAF
  *
  * PARAMETROS:
  * @Param Prf_InfoDocumento    IN FNCK_COM_ELECTRONICO.Lr_InfoDocumento
  * @Param Pv_MsnError             IN  VARCHAR2
  *
  * @author  Martha Navarrete M. <mnavarrete@telconet.ec>
  * @version 1.0 29-12-2017
  */
    PROCEDURE P_Update_Info_Documento_NAF ( Prf_InfoDocumento IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento,
           Pv_MsnError OUT VARCHAR2);

    /**/
    PROCEDURE UPDATE_NUMERCACION_DOC(
            Pn_Secuencia IN ADMI_NUMERACION.SECUENCIA%TYPE,
            Pn_IdEmpresa IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
            Pn_IdOficina IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
            Pv_Codigo    IN ADMI_NUMERACION.CODIGO%TYPE);
    /**/

    PROCEDURE INSERT_MESSAGE_COMP_ELEC(
            Pv_Tipo          IN INFO_MENSAJE_COMP_ELEC.TIPO%TYPE,
            Pv_Mensaje       IN INFO_MENSAJE_COMP_ELEC.MENSAJE%TYPE,
            Pv_InfoAdicional IN INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE,
            Pn_DocumentoId   IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
            Pd_FeCreacion    IN INFO_MENSAJE_COMP_ELEC.FE_CREACION%TYPE);
    /**/
    PROCEDURE UPDATE_DOC_FIN_CAB(
            Pn_IdDocumento        IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
            Pv_Estado             IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
            Pv_NumeroAutorizacion IN INFO_COMPROBANTE_ELECTRONICO.NUMERO_AUTORIZACION%TYPE,
            Pd_FechaAutorizacion  IN INFO_COMPROBANTE_ELECTRONICO.FE_AUTORIZACION%TYPE,
            Pv_MsnError OUT VARCHAR2);
    /**/
    PROCEDURE INSERT_LOTE_MASIVO(
            Pr_LoteMasivo IN FNCK_COM_ELECTRONICO.Lr_LoteMasivo);
    --
    PROCEDURE UPDATE_LOTE_MASIVO(
            Pn_IdLoteMasivo          IN INFO_LOTE_MASIVO.ID_LOTE_MASIVO%TYPE,
            Pv_Estado                IN INFO_LOTE_MASIVO.ESTADO%TYPE,
            Pv_Enviado               IN INFO_LOTE_MASIVO.ENVIADO%TYPE,
            Pv_Ruc                   IN INFO_LOTE_MASIVO.RUC%TYPE,
            Pn_TipoDocumentoId       IN INFO_LOTE_MASIVO.TIPO_DOCUMENTO_ID%TYPE,
            Pv_Establecimiento       IN INFO_LOTE_MASIVO.ESTABLECIMIENTO%TYPE,
            Pv_ClaveAcceso           IN INFO_LOTE_MASIVO.CLAVE_ACCESO%TYPE,
            Pd_FeCreacion            IN INFO_LOTE_MASIVO.FE_CREACION%TYPE,
            Pd_FeEnvio               IN INFO_LOTE_MASIVO.FE_ENVIO%TYPE,
            Pd_FeModificacion        IN INFO_LOTE_MASIVO.FE_MODIFICACION%TYPE,
            Pv_UsrCreacion           IN INFO_COMPROBANTE_ELECTRONICO.USR_CREACION%TYPE,
            Pv_UsrModificacion       IN INFO_COMPROBANTE_ELECTRONICO.USR_MODIFICACION%TYPE,
            Pv_Observacion           IN INFO_LOTE_MASIVO.OBSERVACION%TYPE,
            Pn_NumeroEnvio           IN INFO_LOTE_MASIVO.NUMERO_ENVIO%TYPE,
            Pn_NumeroComprobantes    IN INFO_LOTE_MASIVO.NUMERO_COMPROBANTES%TYPE,
            Pn_NumeroCompCorrectos   IN INFO_LOTE_MASIVO.NUMERO_COMP_CORRECTOS%TYPE,
            Pn_NumeroCompIncorrectos IN INFO_LOTE_MASIVO.NUMERO_COMP_INCORRECTOS%TYPE,
            Pv_MsnError OUT VARCHAR2);
    --  
    /**
    * Documentación para el procedimiento INSERT_ERROR
    *
    * Realiza un insert en la tabla DB_FINANCIERO.INFO_ERROR
    *
    * @version 1.0 Version Inicial
    * @author Edson Franco <efranco@telconet.ec>
    * @version 1.1 14-08-2017 - Se agrega la sentencia 'PRAGMA AUTONOMOUS_TRANSACTION' para hacer los procesos de manera independiente al insertar
    *                           el error
    *
    * @param Pv_Aplicacion   IN INFO_ERROR.APLICACION%TYPE
    * @param Pv_Proceso      IN INFO_ERROR.PROCESO%TYPE
    * @param Pv_DetalleError IN INFO_ERROR.DETALLE_ERROR%TYPE
    */
    PROCEDURE INSERT_ERROR(
            Pv_Aplicacion   IN INFO_ERROR.APLICACION%TYPE,
            Pv_Proceso      IN INFO_ERROR.PROCESO%TYPE,
            Pv_DetalleError IN INFO_ERROR.DETALLE_ERROR%TYPE);
    --
    PROCEDURE INSERT_COMP_ELECTRONICO_HIST(
            Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
            Pv_MsnError OUT VARCHAR2);
    --
    PROCEDURE INSERT_DOCUMENTO_HISTORIAL(
         Prf_InfoDocumentoHistorial IN FNCK_COM_ELECTRONICO.Lr_InfoDocumentoHistorial,
         Pv_MsnError OUT VARCHAR2);
    --
    PROCEDURE UPDATE_COMP_ELECT(
         Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
         Pv_MsnError OUT VARCHAR2);
    --
    PROCEDURE UPDATE_COMP_ELECT_CLAVEACCESO(
         Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
         Pv_MsnError OUT VARCHAR2);
    --
END FNCK_COM_ELECTRONICO_TRAN;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN 
AS
  /**/
PROCEDURE UPDATE_NUMERCACION_DOC(
    Pn_Secuencia IN ADMI_NUMERACION.SECUENCIA%TYPE,
    Pn_IdEmpresa IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pn_IdOficina IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Pv_Codigo    IN ADMI_NUMERACION.CODIGO%TYPE)
IS
BEGIN
  --
  UPDATE ADMI_NUMERACION
  SET SECUENCIA  = Pn_Secuencia
  WHERE CODIGO   = Pv_Codigo
  AND EMPRESA_ID = Pn_IdEmpresa
  AND OFICINA_ID = Pn_IdOficina;
  --
END UPDATE_NUMERCACION_DOC;
--
Procedure  P_Update_Info_Documento_NAF (Prf_InfoDocumento IN DB_FINANCIERO.FNCK_COM_ELECTRONICO.Lr_InfoDocumento,
Pv_MsnError OUT VARCHAR2 )  IS
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
   WHERE ID_DOCUMENTO = Prf_InfoDocumento.ID_DOCUMENTO;

EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', ' Error en FNCK_COM_ELECTRONICO_TRAN.P_Update_Info_Documento_NAF', '' || SQLERRM);
  --
END P_Update_Info_Documento_NAF; 
--

/**
*Inserta un registro en la tabla INFO_MENSAJE_COMP_ELEC
*
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.1 Se quita commit y rollback ya que es usado dentro del TRIGGER [DB_COMPROBANTES.TRG_AFTER_INFO_MENSAJE]
* @since 1.0
*/
PROCEDURE INSERT_MESSAGE_COMP_ELEC(
    Pv_Tipo          IN INFO_MENSAJE_COMP_ELEC.TIPO%TYPE,
    Pv_Mensaje       IN INFO_MENSAJE_COMP_ELEC.MENSAJE%TYPE,
    Pv_InfoAdicional IN INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE,
    Pn_DocumentoId   IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pd_FeCreacion    IN INFO_MENSAJE_COMP_ELEC.FE_CREACION%TYPE )
IS
BEGIN
  --
  INSERT
  INTO INFO_MENSAJE_COMP_ELEC
    (
      ID_MSN_COMP_ELEC,
      TIPO,
      MENSAJE,
      INFORMACION_ADICIONAL,
      DOCUMENTO_ID,
      FE_CREACION
    )
    VALUES
    (
      SEQ_MENSAJE_COMP_ELEC.NEXTVAL,
      Pv_Tipo,
      Pv_Mensaje,
      Pv_InfoAdicional,
      Pn_DocumentoId,
      Pd_FeCreacion
    );
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'Error en FNCK_COM_ELECTRONICO_TRAN.INSERT_MESSAGE_COMP_ELEC', SQLERRM);
  --
END INSERT_MESSAGE_COMP_ELEC;
/***/
PROCEDURE UPDATE_DOC_FIN_CAB
  (
    Pn_IdDocumento        IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_Estado             IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    Pv_NumeroAutorizacion IN INFO_COMPROBANTE_ELECTRONICO.NUMERO_AUTORIZACION%TYPE,
    Pd_FechaAutorizacion  IN INFO_COMPROBANTE_ELECTRONICO.FE_AUTORIZACION%TYPE,
    Pv_MsnError OUT VARCHAR2
  )
IS
  --
BEGIN
  --
  UPDATE INFO_DOCUMENTO_FINANCIERO_CAB
  SET ESTADO_IMPRESION_FACT = Pv_Estado,
    NUMERO_AUTORIZACION     = Pv_NumeroAutorizacion,
    FE_AUTORIZACION         = Pd_FechaAutorizacion
  WHERE ID_DOCUMENTO        = Pn_IdDocumento;
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_MsnError := 'Error en UPDATE_DOC_FIN_CAB - ' || SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', ' Error en FNCK_COM_ELECTRONICO_TRAN.UPDATE_DOC_FIN_CAB', Pv_MsnError);
END UPDATE_DOC_FIN_CAB;
/**/
PROCEDURE INSERT_LOTE_MASIVO(
    Pr_LoteMasivo IN FNCK_COM_ELECTRONICO.Lr_LoteMasivo)
IS
BEGIN
  --
  INSERT
  INTO INFO_LOTE_MASIVO
    (
      ID_LOTE_MASIVO,
      ESTADO,
      ENVIADO,
      RUC,
      TIPO_DOCUMENTO_ID,
      ESTABLECIMIENTO,
      CLAVE_ACCESO,
      FE_CREACION,
      FE_ENVIO,
      FE_MODIFICACION,
      OBSERVACION,
      NUMERO_ENVIO,
      NUMERO_COMPROBANTES,
      NUMERO_COMP_CORRECTOS,
      NUMERO_COMP_INCORRECTOS
    )
    VALUES
    (
      Pr_LoteMasivo.ID_LOTE_MASIVO,
      Pr_LoteMasivo.ESTADO,
      Pr_LoteMasivo.ENVIADO,
      Pr_LoteMasivo.RUC,
      Pr_LoteMasivo.TIPO_DOCUMENTO_ID,
      Pr_LoteMasivo.ESTABLECIMIENTO,
      Pr_LoteMasivo.CLAVE_ACCESO,
      Pr_LoteMasivo.FE_CREACION,
      Pr_LoteMasivo.FE_ENVIO,
      Pr_LoteMasivo.FE_MODIFICACION,
      Pr_LoteMasivo.OBSERVACION,
      Pr_LoteMasivo.NUMERO_ENVIO,
      Pr_LoteMasivo.NUMERO_COMPROBANTES,
      Pr_LoteMasivo.NUMERO_COMP_CORRECTOS,
      Pr_LoteMasivo.NUMERO_COMP_INCORRECTOS
    );
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', ' Error en FNCK_COM_ELECTRONICO_TRAN.INSERT_LOTE_MASIVO', SQLERRM);
  --
END INSERT_LOTE_MASIVO;
--
--
PROCEDURE UPDATE_LOTE_MASIVO
  (
    Pn_IdLoteMasivo          IN INFO_LOTE_MASIVO.ID_LOTE_MASIVO%TYPE,
    Pv_Estado                IN INFO_LOTE_MASIVO.ESTADO%TYPE,
    Pv_Enviado               IN INFO_LOTE_MASIVO.ENVIADO%TYPE,
    Pv_Ruc                   IN INFO_LOTE_MASIVO.RUC%TYPE,
    Pn_TipoDocumentoId       IN INFO_LOTE_MASIVO.TIPO_DOCUMENTO_ID%TYPE,
    Pv_Establecimiento       IN INFO_LOTE_MASIVO.ESTABLECIMIENTO%TYPE,
    Pv_ClaveAcceso           IN INFO_LOTE_MASIVO.CLAVE_ACCESO%TYPE,
    Pd_FeCreacion            IN INFO_LOTE_MASIVO.FE_CREACION%TYPE,
    Pd_FeEnvio               IN INFO_LOTE_MASIVO.FE_ENVIO%TYPE,
    Pd_FeModificacion        IN INFO_LOTE_MASIVO.FE_MODIFICACION%TYPE,
    Pv_UsrCreacion           IN INFO_COMPROBANTE_ELECTRONICO.USR_CREACION%TYPE,
    Pv_UsrModificacion       IN INFO_COMPROBANTE_ELECTRONICO.USR_MODIFICACION%TYPE,
    Pv_Observacion           IN INFO_LOTE_MASIVO.OBSERVACION%TYPE,
    Pn_NumeroEnvio           IN INFO_LOTE_MASIVO.NUMERO_ENVIO%TYPE,
    Pn_NumeroComprobantes    IN INFO_LOTE_MASIVO.NUMERO_COMPROBANTES%TYPE,
    Pn_NumeroCompCorrectos   IN INFO_LOTE_MASIVO.NUMERO_COMP_CORRECTOS%TYPE,
    Pn_NumeroCompIncorrectos IN INFO_LOTE_MASIVO.NUMERO_COMP_INCORRECTOS%TYPE,
    Pv_MsnError OUT VARCHAR2
  )
IS
BEGIN
  --
  UPDATE INFO_LOTE_MASIVO
  SET ESTADO                = NVL(Pv_Estado, ESTADO),
    ENVIADO                 = NVL(Pv_Enviado, ENVIADO),
    RUC                     = NVL(Pv_Ruc, RUC),
    TIPO_DOCUMENTO_ID       = NVL(Pn_TipoDocumentoId, TIPO_DOCUMENTO_ID),
    ESTABLECIMIENTO         = NVL(Pv_Establecimiento, ESTABLECIMIENTO),
    CLAVE_ACCESO            = NVL(Pv_ClaveAcceso, CLAVE_ACCESO),
    FE_CREACION             = NVL(Pd_FeCreacion, FE_CREACION),
    FE_ENVIO                = NVL(Pd_FeEnvio, FE_ENVIO),
    FE_MODIFICACION         = NVL(Pd_FeModificacion, FE_MODIFICACION),
    USR_CREACION            = NVL(Pv_UsrCreacion, USR_CREACION),
    USR_MODIFICACION        = NVL(Pv_UsrModificacion, USR_MODIFICACION),
    OBSERVACION             = NVL(Pv_Observacion, OBSERVACION),
    NUMERO_ENVIO            = NVL(Pn_NumeroEnvio, NUMERO_ENVIO),
    NUMERO_COMPROBANTES     = NVL(Pn_NumeroComprobantes, NUMERO_COMPROBANTES),
    NUMERO_COMP_CORRECTOS   = NVL(Pn_NumeroCompCorrectos, NUMERO_COMP_CORRECTOS),
    NUMERO_COMP_INCORRECTOS = NVL(Pn_NumeroCompIncorrectos, NUMERO_COMP_INCORRECTOS)
  WHERE ID_LOTE_MASIVO      = Pn_IdLoteMasivo;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  ROLLBACK;
  --
  Pv_MsnError := 'Error on FNCK_COM_ELECTRONICO_TRAN.UPDATE_LOTE_MASIVO - ' || SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', ' Error en FNCK_COM_ELECTRONICO_TRAN.UPDATE_LOTE_MASIVO', Pv_MsnError);
  --
END UPDATE_LOTE_MASIVO;
--
PROCEDURE INSERT_ERROR(
    Pv_Aplicacion   IN INFO_ERROR.APLICACION%TYPE,
    Pv_Proceso      IN INFO_ERROR.PROCESO%TYPE,
    Pv_DetalleError IN INFO_ERROR.DETALLE_ERROR%TYPE)
IS
  --
  PRAGMA AUTONOMOUS_TRANSACTION;
  --
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
PROCEDURE INSERT_COMP_ELECTRONICO_HIST
  (
    Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
    Pv_MsnError OUT VARCHAR2
  )
IS
BEGIN
  --
  Pv_MsnError := NULL;
  --
  INSERT
  INTO INFO_COMP_ELECTRONICO_HIST
    (
      ID_COMP_ELECTRONICO_HIST,
      COMP_ELECTRONICO_ID,
      NOMBRE_COMPROBANTE,
      DOCUMENTO_ID,
      TIPO_DOCUMENTO_ID,
      NUMERO_FACTURA_SRI,
      COMPROBANTE_ELECTRONICO,
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
      SEQ_INFO_COMP_ELEC_HISTOR.NEXTVAL,
      Prf_ComprobanteElectronico.ID_COMP_ELECTRONICO,
      Prf_ComprobanteElectronico.NOMBRE_COMPROBANTE,
      Prf_ComprobanteElectronico.DOCUMENTO_ID,
      Prf_ComprobanteElectronico.TIPO_DOCUMENTO_ID,
      Prf_ComprobanteElectronico.NUMERO_FACTURA,
      Prf_ComprobanteElectronico.COMPROBANTE_ELECTRONICO,
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
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_MsnError := 'Error en INSERT_COMP_ELECTRONICO - ' || SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO_TRAN.INSERT_COMP_ELECTRONICO_HIST', Pv_MsnError);
  --
END INSERT_COMP_ELECTRONICO_HIST;
--
PROCEDURE INSERT_DOCUMENTO_HISTORIAL
  (
    Prf_InfoDocumentoHistorial IN FNCK_COM_ELECTRONICO.Lr_InfoDocumentoHistorial,
    Pv_MsnError OUT VARCHAR2
  )
IS
BEGIN
  --
  INSERT
  INTO INFO_DOCUMENTO_HISTORIAL
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
      SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL,
      Prf_InfoDocumentoHistorial.DOCUMENTO_ID,
      Prf_InfoDocumentoHistorial.MOTIVO_ID,
      Prf_InfoDocumentoHistorial.FE_CREACION,
      Prf_InfoDocumentoHistorial.USR_CREACION,
      Prf_InfoDocumentoHistorial.ESTADO,
      Prf_InfoDocumentoHistorial.OBSERVACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_MsnError := 'Error en INSERT_COMP_ELECTRONICO - ' || SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO_TRAN.INSERT_DOCUMENTO_HISTORIAL', Pv_MsnError);
  --
END INSERT_DOCUMENTO_HISTORIAL;
--
/**
* Documentacion para el procedimiento UPDATE_COMP_ELECT
* Realiza el insert en la INFO_MENSAJE_COMP_ELEC usado en el trigger DB_COMPROBANTES.TRG_AFTER_INFO_MENSAJE 
* Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico Recibe un record de INFO_COMPROBANTE_ELECTRONICO
* Pv_Mensaje       IN INFO_MENSAJE_COMP_ELEC.MENSAJE%TYPE,
* Pv_InfoAdicional IN INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE,
* Pn_DocumentoId   IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
* Pd_FeCreacion    IN INFO_MENSAJE_COMP_ELEC.FE_CREACION%TYPE,
* Pv_Mensaje OUT VARCHAR2
* @version 1.0 03-06-2016
*/
PROCEDURE UPDATE_COMP_ELECT(
    Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
    Pv_MsnError OUT VARCHAR2)
IS
BEGIN
  --
  UPDATE INFO_COMPROBANTE_ELECTRONICO
  SET CLAVE_ACCESO          = Prf_ComprobanteElectronico.CLAVE_ACCESO,
    ESTADO                  = Prf_ComprobanteElectronico.ESTADO,
    FE_MODIFICACION         = Prf_ComprobanteElectronico.FE_MODIFICACION,
    USR_MODIFICACION        = Prf_ComprobanteElectronico.USR_MODIFICACION,
    FE_AUTORIZACION         = Prf_ComprobanteElectronico.FE_AUTORIZACION,
    NUMERO_AUTORIZACION     = Prf_ComprobanteElectronico.NUMERO_AUTORIZACION
  WHERE ID_COMP_ELECTRONICO = Prf_ComprobanteElectronico.ID_COMP_ELECTRONICO;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  Pv_MsnError := SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'Error en FNCK_COM_ELECTRONICO_TRAN.UPDATE_COMP_ELECT', Pv_MsnError);
  --
END UPDATE_COMP_ELECT;
--
/**
* Documentacion para el procedimiento UPDATE_COMP_ELECT_CLAVEACCESO
* Realiza el update de la clave de acceso en INFO_COMPROBANTE_ELECTRONICO
* Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico Recibe un record de INFO_COMPROBANTE_ELECTRONICO
* Pv_MsnError                OUT VARCHAR2,
*
* @author Anabelle Penaherrera <apenaherrera@telconet.ec>
* @version 1.0 15-12-2017
*/
PROCEDURE UPDATE_COMP_ELECT_CLAVEACCESO(
    Prf_ComprobanteElectronico IN FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico,
    Pv_MsnError OUT VARCHAR2)
IS
BEGIN
  --
  UPDATE INFO_COMPROBANTE_ELECTRONICO
  SET CLAVE_ACCESO          = Prf_ComprobanteElectronico.CLAVE_ACCESO,   
    FE_MODIFICACION         = Prf_ComprobanteElectronico.FE_MODIFICACION,
    USR_MODIFICACION        = Prf_ComprobanteElectronico.USR_MODIFICACION
 WHERE ID_COMP_ELECTRONICO  = Prf_ComprobanteElectronico.ID_COMP_ELECTRONICO;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  Pv_MsnError := SQLERRM;
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'Error en FNCK_COM_ELECTRONICO_TRAN.UPDATE_COMP_ELECT_CLAVEACCESO', Pv_MsnError);
  --
END UPDATE_COMP_ELECT_CLAVEACCESO;
--
END FNCK_COM_ELECTRONICO_TRAN;
/