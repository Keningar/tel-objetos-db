CREATE OR REPLACE PROCEDURE NAF47_TNET.CPAnula(
  pCia            IN     VARCHAR2,
  pTipo           IN     VARCHAR2, -- Tipo de doc a anular
  pDocu           IN     VARCHAR2, -- Doc a anular
  pFecha_anula    IN     DATE,     -- Fecha de anulacion
  pMotivo         IN     VARCHAR2,
  pmsg_error      IN OUT VARCHAR2
) IS
  --
  --
/**
 * Documentacion para CPANULA 
 *
 * Anula el documento pasado como parametro (credito o debito) insertando
 * un documento de tipo anulacion (arcptd.ind_anulacion = 'S') y
 * con tipo de movimiento inverso. El documento a anular NO debe tener
 * movimientos aplicados, excepto por retenciones incluidas (Guatemala).
 * Solamente se anulan documentos correspondientes al periodo en proceso.
 *
 * @author yoveri
 * @version 1.0 01/01/2007
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 17/12/2019 Se modifica anular retención electrónica asociadas al documento que se reversa
 * 
 * @param pCia         IN VARCHAR2     recibe codigo de compania
 * @param pTipo        IN VARCHAR2     recibe tipo de documento
 * @param pProve       IN VARCHAR2     recibe codigo de proveedor
 * @param pFecha_anula IN DATE         recibe fecha de anulación
 * @param pMotivo      IN VARCHAR2     recibe texto del motivo de anulación
 * @param pmsg_Error   IN OUT VARCHAR2 retorma mensaje de erro
 */
  --
BEGIN
  
 CPAnula@Gpoetnet(pCia => pCia,
                  pTipo => pTipo,
                  pDocu => pDocu,
                  pFecha_anula => pFecha_anula,
                  pMotivo => pMotivo,
                  pmsg_error => pmsg_error);


EXCEPTION
  WHEN others THEN
     pmsg_error := 'CPANULA: '||sqlerrm;
     return;
END;
/