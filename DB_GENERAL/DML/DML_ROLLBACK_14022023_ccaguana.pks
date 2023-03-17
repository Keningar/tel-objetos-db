/**
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 *
 *ROLLBACK de actualización por parametro SMS PARA LA PLANIFICACION HAL
 **/

        
    UPDATE   DB_GENERAL.admi_parametro_det
    SET VALOR2='Bienvenido a Netlife, elegiste el dia {{fechaSms}} a las {{horaIni}} para la instalacion de tu servicio, si requieres mayor informacion contactate con su asesor comercial.'
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'SMS_PLANIFICACION_HAL'
            AND estado = 'Activo');
/
COMMIT;   
/