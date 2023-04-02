
/**
 *
 * Se ELiminan plantillas para la empresa ECUANET con el flujo de Cancelacion y PreCancelacion.
 *	 
 * @author Jonathan Mazon <jmazon@telconet.ec>
 * @version 1.0 03-03-2023
 */


--PLANTILLAS CORREO 

DELETE FROM DB_COMUNICACION.ADMI_PLANTILLA
WHERE CODIGO IN ('ACTA_CANCEL_EN','ACTA_PRECAN_EN') ;


COMMIT;

/
