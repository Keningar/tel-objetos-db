/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Rollback para los parametros utilizados para proceso Anti-Phishing
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 22-04-2022 - Versión Inicial.
 */
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET B WHERE B.PARAMETRO_ID IN (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING');
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING';

COMMIT;
/
