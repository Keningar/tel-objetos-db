/**
 * Reverso de los parametros para el consumo del WS de Networking
 * para el proceso de Migracion de los OLTs
 *
 * @author Leonardo Mero <lemero@telconet.ec>
 * @version 1.0 08-03-2022
 */


DELETE
FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE DESCRIPCION = 'Parametros Consumo NW'
AND PARAMETRO_ID  =
  (SELECT ID_PARAMETRO
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
  AND MODULO             = 'TECNICO'
  AND ESTADO             = 'Activo'
  );

COMMIT;
/
