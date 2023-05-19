/**
 * Rollback de parámetros 
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 *
 * @version 1.0
 */



DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET apd WHERE PARAMETRO_ID=(SELECT ID_PARAMETRO
                                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                                                                    WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO');

DELETE DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO';
COMMIT;
/
