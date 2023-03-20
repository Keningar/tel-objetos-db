/**
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 *
 *Se actualizan el parametro SMS PARA LA PLANIFICACION HAL
 **/

        
    UPDATE   DB_GENERAL.admi_parametro_det
    SET VALOR2='S'
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