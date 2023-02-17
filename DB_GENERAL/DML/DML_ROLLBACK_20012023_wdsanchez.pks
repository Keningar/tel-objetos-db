/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para reversar cabecera y detalle de parametros para microservicios derecho legal
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0
 * @since 20-01-2023 - Versión Inicial.
 */

DELETE FROM 
db_general.admi_parametro_det apdt
WHERE apdt.PARAMETRO_ID in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_DLEGAL'
            AND estado = 'Activo'
			AND usr_creacion = 'wdsanchez');
			
			
DELETE FROM 
db_general.admi_parametro_cab
WHERE 
nombre_parametro = 'PARAMETROS_DLEGAL'
AND estado = 'Activo'
AND usr_creacion = 'wdsanchez';

commit;

/
