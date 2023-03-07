/**
 * Reverso de los parametros para el consumo de WS de Networking 
 * para el proceso de Migracion de los OLTs
 *
 * @author Leonardo Mero <lemero@telconet.ec>
 * @version 1.0 12-12-2022
 */

  --Rollbacks
  --Se eliminan el parametro detalle de MIGRACION_OLT_PARAMETROS
 DELETE
FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE PARAMETRO_ID =
  (SELECT ID_PARAMETRO
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
  AND MODULO             = 'TECNICO'
  AND ESTADO             = 'Activo'
  );
--Se eliminan el parametro cabecera de MIGRACION_OLT_PARAMETROS
DELETE
FROM DB_GENERAL.ADMI_PARAMETRO_CAB
WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
AND MODULO             = 'TECNICO'
AND ESTADO             = 'Activo'; 

COMMIT;
/
