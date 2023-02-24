/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Rollback para los parametros utilizados para proceso de BusPagos
 * @author Milen Ortega <mortega1@telconet.ec>
 * @version 1.0 28/12/2022
 */

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR6 = null, VALOR7 = null, VALOR8 = null WHERE VALOR1 = 'BUSPAGOS';

COMMIT;

/