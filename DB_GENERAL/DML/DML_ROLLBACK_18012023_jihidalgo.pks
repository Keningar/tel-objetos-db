/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Rollback para parametro que permite activar cobro por reconexion a todo cliente.
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 18-01-2023 - Versión Inicial.
 */
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET D SET D.VALOR3 = NULL, D.VALOR4 = NULL WHERE D.PARAMETRO_ID = (SELECT C.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB C WHERE C.NOMBRE_PARAMETRO = 'CARGO REACTIVACION SERVICIO');

COMMIT;
/
