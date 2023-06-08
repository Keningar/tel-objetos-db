/**
 *
 * Reverso de actualizacion de VALOR4 para el parametro de PreCancelacion de Contrato
 * @author Daniel Males <dsmales@telconet.ec>
 * @version 1.0 08-06-2023
 */
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR4 = NULL 
WHERE 
PARAMETRO_ID = 
(SELECT
  ID_PARAMETRO
FROM
  DB_GENERAL.ADMI_PARAMETRO_CAB
WHERE
NOMBRE_PARAMETRO = 'FLUJO_ACTA_CANCELACION'
AND ESTADO = 'Activo'
)
AND VALOR1 = 'WEB-TN'
AND VALOR2 = 'PreCancelacion';

COMMIT;