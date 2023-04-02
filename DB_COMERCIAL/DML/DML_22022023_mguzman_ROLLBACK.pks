 /**
 * Reverso de parámetros de las cláusulas de contrato
 *
 * @author Miguel Guzman <mguzman@telconet.ec>
 *
 * @version 1.0
 */
           
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET 
WHERE EMPRESA_COD = '33' 
AND usr_creacion ='mguzman'
AND parametro_id IN (SELECT ID_PARAMETRO
FROM DB_GENERAL.ADMI_PARAMETRO_CAB
WHERE NOMBRE_PARAMETRO IN (  'ACEPTACION_CLAUSULA_CONTRATO' ,'REQUIERE_ACTUALIZAR_PERSONA')
AND estado = 'Activo'
);
        
COMMIT;
/
        