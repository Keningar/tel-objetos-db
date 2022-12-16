/**
 * Rollback de parámetros de las cláusulas de contrato
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 *
 * @version 1.0
 */


DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET apd WHERE DESCRIPCION='CONTACTOS FILTRO';

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET apd WHERE PARAMETRO_ID=(SELECT ID_PARAMETRO
                                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                                                                    WHERE NOMBRE_PARAMETRO='REQUIERE_ACTUALIZAR_PERSONA');

DELETE DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='REQUIERE_ACTUALIZAR_PERSONA';
COMMIT;
/
