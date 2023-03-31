/**
 * Parámetros para envío de notificación SMS por planificación
 *
 * @author Alex Gómez <algomez@telconet.ec>
 *
 * @version 1.0
 */

UPDATE
	DB_GENERAL.admi_parametro_det
SET
	USR_ULT_MOD = null,
	FE_ULT_MOD = null,
	VALOR3 = null,
	VALOR4 = null,
	VALOR5 = null,
	OBSERVACION = null
WHERE
	parametro_id = 1750
	AND EMPRESA_COD = '18';

delete from DB_GENERAL.admi_parametro_det
 where parametro_id = 1750
	AND EMPRESA_COD = '33';

commit;
/