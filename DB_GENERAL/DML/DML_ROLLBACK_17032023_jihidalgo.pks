/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Rollback para los parametros utilizados para modulo de pagos Ecuanet
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 17-03-2023 - Versión Inicial.
 */

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE 
PARAMETRO_ID = (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PROCESO CONTABILIZACION EMPRESA')
AND VALOR1 = 'EN';

COMMIT;
/