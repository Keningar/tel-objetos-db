 /**
 * Reverso de Parámetros de la administracion de politicas y clausulas
 * Y se realiza ingresos de registros necesarios para la aplicación 'Gestión de Licitación'.
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
WHERE NOMBRE_PARAMETRO IN ( 'ADMIN_POLITICAS_CLAUSULAS')
AND estado = 'Activo'
);
        
COMMIT;
/