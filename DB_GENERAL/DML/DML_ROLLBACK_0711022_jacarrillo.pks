/**
 * Rollback de parámetros de la administracion de politicas y clausulas
 *
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 *
 * @version 1.0
 */

 

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET apd WHERE PARAMETRO_ID=(SELECT ID_PARAMETRO
                                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                                                                    WHERE NOMBRE_PARAMETRO='ADMIN_POLITICAS_CLAUSULAS');

DELETE DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='ADMIN_POLITICAS_CLAUSULAS';
COMMIT;
/
