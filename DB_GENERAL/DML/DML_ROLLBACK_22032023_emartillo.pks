/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Rollback de las banderas para envio de SMS para Massend para Ecuanet y Megadatos.
 * 
 * @author Emmanuel Martillo<emartillo@telconet.ec>
 * @version 1.0 22-03-2023 - Versión Inicial.
 */

  DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET 
  WHERE PARAMETRO_ID IN (SELECT ID_PARAMETRO        FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO   = 'CONFIG_SMS_MASSEND' AND ESTADO = 'Activo' AND USR_CREACION = 'emartillo')
  AND USR_CREACION = 'emartillo';
  
    DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO   = 'CONFIG_SMS_MASSEND' AND ESTADO = 'Activo' AND USR_CREACION = 'emartillo';

  COMMIT;
/