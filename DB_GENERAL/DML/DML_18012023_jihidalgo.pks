/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Parametro que permite activar cobro por reconexion a todo cliente.
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 18-01-2023 - Versión Inicial.
 *
 * VALOR 3 = BANDERA DE GENERACION DE COBRO A TODOS
 * VALOR 4 = NUMERO DE DIAS PARA RANGO DE CONSULTA DE CORTE DE SERVICIO 
 */
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET D SET D.VALOR3 = '1', D.VALOR4 = '45' WHERE D.PARAMETRO_ID = (SELECT C.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB C WHERE C.NOMBRE_PARAMETRO = 'CARGO REACTIVACION SERVICIO');

COMMIT;
/
