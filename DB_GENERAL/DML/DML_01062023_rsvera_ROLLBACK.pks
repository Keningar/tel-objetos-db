/**
 * Reverso de los estados para la validacion de la migracion de ultima milla
 * @author Rafael Vera<rsvera@telconet.ec>
 * @version 1.0 01-06-2023 - Versión Inicial.
 */
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE VALOR1 = 'EstadoNoPermitido' 
and PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='CAMBIO_ULTIMA_MILLA_MASIVO' AND ESTADO = 'Activo');

COMMIT;
/