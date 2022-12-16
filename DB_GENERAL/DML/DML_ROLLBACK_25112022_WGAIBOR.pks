/*
 * Se realiza ingresos de registros necesarios para la aplicación 'Gestión de Licitación'.
 * @author Walther Joao Gaibor <wgaibor@telconet.ec>
 * @version 1.0 - 25-11-2022
 */
 
DELETE FROM db_general.admi_parametro_det
WHERE
    parametro_id = (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_ACEPTACION_PROSPECTO'
            AND estado = 'Activo'
    );

DELETE FROM db_general.admi_parametro_cab 
WHERE nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_ACEPTACION_PROSPECTO';

COMMIT;
/