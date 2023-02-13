 
DELETE FROM db_general.admi_parametro_det
WHERE
    parametro_id = (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_REGULARIZACION_CLIENTE'
            AND estado = 'Activo'
    );

DELETE FROM db_general.admi_parametro_cab 
WHERE nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_REGULARIZACION_CLIENTE';

COMMIT;
/