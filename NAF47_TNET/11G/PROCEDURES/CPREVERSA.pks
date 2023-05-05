create or replace PROCEDURE CPREVERSA (pCia       IN VARCHAR2,
                                      pProve     IN VARCHAR2,
                                      pTipo      IN VARCHAR2,
                                      pDocu      IN VARCHAR2,
                                      pMonto     IN NUMBER,
                                      pMoneda    IN VARCHAR2,
                                      pmsg_error IN OUT VARCHAR2) IS

/**
 * Documentacion para CPREVERSA 
 *
 * Procedimiento que reversa del estado Actualziado a un documento de cuentas por pagar
 * tambien el campo no_docu_pago de la tabla arcbbo. * 
 *
 * @author yoveri
 * @version 1.0 01/01/2007
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 17/12/2019 Se modifica anular retención electrónica asociadas al documento que se reversa
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.2 07/02/2020 Se corrige anulación de retenciones y replica para nuevo solo de los registros tipo retención, 
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.3 11/09/2020 se modifica para hacer llamdo de reverso de control presupuesto * 
 * @param pCia       IN VARCHAR2 recibe codigo de compania
 * @param pProve     IN VARCHAR2 recibe codigo de proveedor
 * @param pTipo      IN VARCHAR2 recibe tipo de documento
 * @param pDocu      IN VARCHAR2 recibe numero transaccion cxp
 * @param pMonto     IN NUMBER   recibe monto a reversar
 * @param pMoneda    IN VARCHAR2 recibe codigo de moneda
 * @param pmsg_Error IN OUT VARCHAR2 retorma mensaje de error
 *  
 */

  --
  CURSOR C_TIPO(pCia  VARCHAR2,
                pTipo VARCHAR2) IS
    SELECT TIPO_MOV,
           COMPROBANTE_ELECTRONICO,
           DOCUMENTO
      FROM ARCPTD TD
     WHERE NO_CIA = pCia
       AND TIPO_DOC = pTipo;
  --
  CURSOR C_ORDEN_COMPRA_LOCAL ( Cv_NoDocumento   VARCHAR2,
                                Cv_TipoDocumento VARCHAR2, 
                                Cv_NoCia         VARCHAR2 ) IS
    SELECT A.COMPANIA, A.NO_DOCUMENTO_ORIGEN, SUM(A.MONTO) MONTO
      FROM CP_DOCUMENTO_ORIGEN A
     WHERE A.NO_DOCUMENTO = Cv_NoDocumento 
       AND A.TIPO_DOCUMENTO =  Cv_TipoDocumento 
       AND A.COMPANIA = Cv_NoCia
     GROUP BY A.COMPANIA, A.NO_DOCUMENTO_ORIGEN;
  --
  Lr_TipoDoc    C_TIPO%ROWTYPE := NULL;
  error_proceso EXCEPTION;
BEGIN

 CPREVERSA@GPOETNET (pCia,
            pProve,
            pTipo,
            pDocu,
            pMonto,
            pMoneda,
            pmsg_error);
EXCEPTION
  WHEN error_proceso THEN
    RETURN;
END CPReversa;
