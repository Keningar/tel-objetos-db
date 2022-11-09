/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para reversar cabecera y detalle de parametros para microservicios del esquema SOPORTE
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since 29-10-2021 - Versión Inicial.
 */

DELETE FROM 
db_general.admi_parametro_det apdt
WHERE apdt.PARAMETRO_ID in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'MS_CORE_SOPORTE'
            AND estado = 'Activo'
			AND usr_creacion = 'ddelacruz');

DELETE FROM 
db_general.admi_parametro_cab
WHERE 
nombre_parametro = 'MS_CORE_SOPORTE'
AND estado = 'Activo'
AND usr_creacion = 'ddelacruz';

DELETE FROM 
db_general.admi_parametro_det apdt
WHERE apdt.PARAMETRO_ID in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'MS_CORE_FINANCIERO'
            AND estado = 'Activo'
			AND usr_creacion = 'ddelacruz');

DELETE FROM 
db_general.admi_parametro_cab
WHERE 
nombre_parametro = 'MS_CORE_FINANCIERO'
AND estado = 'Activo'
AND usr_creacion = 'ddelacruz';

commit;

/
