CREATE OR REPLACE PROCEDURE NAF47_TNET.CPREVERSA (pCia       IN VARCHAR2,
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
 * @version 1.1 17/12/2019 Se modifica anular retenci�n electr�nica asociadas al documento que se reversa
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.2 07/02/2020 Se corrige anulaci�n de retenciones y replica para nuevo solo de los registros tipo retenci�n, 
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

  --
  -- Actualiza el saldo del proveedor
  --
  OPEN c_tipo(pCia, pTipo);
  FETCH c_tipo
    INTO Lr_TipoDoc;
  CLOSE c_tipo;
  --
  --
  -- se valida que para documentos electronicos de tipo factura no se permite el reverso... solo anulaci�n
  IF Lr_TipoDoc.Documento = 'F' AND Lr_TipoDoc.Comprobante_Electronico = 'S' THEN
    --
    pmsg_error := 'Tipo de documento es electr�nico y no se puede Reversar!!!';
    RAISE error_proceso;
    --
  END IF;
  --
  --
  -- Procede a eliminar el documento del libro de compras
  --
  DELETE arcglco
   WHERE no_cia = pCia
     AND tipo_doc = pTipo
     AND no_docu = pDocu
     AND no_prove = pProve;

  --
  -- Envia el monto en negativo para reversar el saldo anterior.
  CPActualiza_saldo_prove(pCia, pProve, Lr_TipoDoc.Tipo_Mov, pMoneda, -pMonto, NULL, NULL, NULL, pmsg_error);

  IF pmsg_error IS NOT NULL THEN
    RAISE error_proceso;
  END IF;

  --
  -- Actualiza el documento dejandolo pendiente y con saldo 0
  --
  UPDATE arcpmd
     SET Ind_Act       = 'P',
         saldo         = monto_nominal,
         saldo_nominal = monto_nominal,
         --
         estado_sri     = decode(Documento_Id, 'P', estado_sri, 8),
         comp_ret_anulada = decode(Documento_Id, null, comp_ret_anulada, comp_ret),
         comp_ret       = decode(Documento_Id, null, comp_ret, null),
         nombre_archivo = decode(Documento_Id, null, nombre_archivo, null)
         --
  WHERE no_cia = pCia
  AND tipo_doc = pTipo
  AND no_docu = pDocu
  AND no_prove = pProve;

  --  Cambia estado de Anulado a detalle de retenciones
  UPDATE ARCPTI  
  SET ANULADA = 'S'
  WHERE IND_IMP_RET = 'R'
  AND NO_CIA  = pCia
  AND NO_DOCU = pDocu;

  -- Al reversar documento, el comprobante electr�nico se anula autom�ticamente.
  --
  UPDATE DB_COMPROBANTES.INFO_DOCUMENTO IDC
  SET IDC.ESTADO_DOC_ID = 8
  WHERE EXISTS (SELECT NULL
                FROM NAF47_TNET.ARCPMD MD
                WHERE MD.DOCUMENTO_ID = IDC.ID_DOCUMENTO
                AND MD.NO_CIA = pCia
                AND MD.TIPO_DOC = pTipo
                AND MD.NO_DOCU = pDocu
                AND MD.NO_PROVE = pProve);
  --
  --si actualiz� el documento es electr�nico
  IF SQL%ROWCOUNT != 0 THEN
    -- se replica nuevo detalle de retenciones para nuevao comprobante
    INSERT INTO arcpti 
         ( no_cia, no_prove, tipo_doc, no_docu,
           clave, porcentaje, monto, ind_imp_ret,
           aplica_cred_fiscal, base, codigo_tercero,
           comportamiento, id_sec, no_refe)
    SELECT no_cia, no_prove, tipo_doc, no_docu,
           clave, porcentaje, monto, ind_imp_ret,
           aplica_cred_fiscal, base, codigo_tercero,
           comportamiento, id_sec, no_refe
    FROM arcpti
    WHERE ind_imp_ret = 'R'
      AND no_cia  = pCia
      AND no_docu = pDocu;
  END IF;


  -- llindao: se devuelve valor facturado de orden de compra
  FOR Lr_Origen IN C_ORDEN_COMPRA_LOCAL(pDocu, pTipo, pCia) LOOP
    UPDATE TAPORDEE A
       SET A.VALOR_FACTURADO = A.VALOR_FACTURADO - Lr_Origen.Monto
     WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
       AND A.NO_CIA = Lr_Origen.Compania;
  END LOOP;
  --
  -- ejecutar reverso de costeo 
  NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.P_DISTRIBUCION_COSTO_FACTURA ( pDocu,
                                                                     pCia,
                                                                     'Reversar',
                                                                     pmsg_error);
  --
  IF pmsg_error IS NOT NULL THEN
    RAISE error_proceso;
  END IF;  
  --
EXCEPTION
  WHEN error_proceso THEN
    RETURN;
END CPReversa;
/