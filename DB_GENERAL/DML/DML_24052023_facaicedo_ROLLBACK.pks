/*
  * Reverso de los service port al parametro para los servicios safecity.
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.0 24-05-2023
*/

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET
SET VALOR3 = NULL
    , VALOR4 = NULL
    , VALOR5 = NULL
    , USR_ULT_MOD = 'facaicedo'
    , FE_ULT_MOD = SYSDATE
WHERE ID_PARAMETRO_DET IN (
    SELECT DET.ID_PARAMETRO_DET
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
    WHERE CAB.NOMBRE_PARAMETRO = 'PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND DET.DESCRIPCION = 'SPID-ZTE'
    AND DET.ESTADO = 'Activo'
);

COMMIT;
/
