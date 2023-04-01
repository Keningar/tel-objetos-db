/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Rollback para los parametros utilizados para modulo de pagos Ecuanet
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 28-03-2023 - Versión Inicial.
 */

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE 
PARAMETRO_ID = (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'NUMERO_DE_DIAS_ANULAR_PAGOS')
AND VALOR4 = 'EN';

COMMIT;
/