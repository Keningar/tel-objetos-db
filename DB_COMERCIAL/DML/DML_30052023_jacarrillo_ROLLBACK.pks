

/**
 * Actualización de rango de fechas para procesamiento masivo de regularización en firmas de documentos 
 * @author Jefferson Alexy Carrillo<jcarrillo@telconet.ec>
 * @version 1.0 30-05-2023 - Versión Inicial.
 */


UPDATE    db_general.admi_parametro_det SET 
VALOR2  =  '17/02/2023', 
VALOR4  =  '20/04/2023',
USR_ULT_MOD  ='ccaguana',
FE_ULT_MOD = SYSDATE 
WHERE PARAMETRO_ID IN  
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAM_REGULARIZACION_DOCUMENTO_FIRMA'
            AND estado = 'Activo'
    )
 AND DESCRIPCION =   'FILTROS_DOCUMENTO_FIRMA'; 
 
  


 COMMIT;
/
 