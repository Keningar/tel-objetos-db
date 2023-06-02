/**
 * Reversar valores anteriores en regularizacion de adendums
 *
 *
 * @author Jefferson Carrillo<jacarrillo@telconet.ec>
 * @version 1.0 01-06-2023
 */ 

SET DEFINE OFF;


UPDATE DB_COMERCIAL.info_adendum ADEN
SET ADEN.FORMA_CONTRATO   = null ,
ADEN.FE_MODIFICA          = SYSDATE,  
ADEN.USR_MODIFICA         = 'RegulaReverso'
WHERE   ADEN.USR_MODIFICA = 'RegulaFirma'; 



COMMIT;
/