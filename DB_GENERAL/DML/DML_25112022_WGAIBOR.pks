/*
 * Se realiza ingresos de registros necesarios para la aplicación 'Gestión de Licitación'.
 * @author Walther Joao Gaibor <wgaibor@telconet.ec>
 * @version 1.0 - 25-11-2022
 */
    
INSERT INTO db_general.admi_parametro_cab (
    id_parametro,
    nombre_parametro,
    descripcion,
    modulo,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion
) VALUES (
    db_general.seq_admi_parametro_cab.nextval,
    'FORMAS_CONTACTO_FORMULARIO_ACEPTACION_PROSPECTO',
    'FORMAS DE CONTACTO ',
    'COMERCIAL',
    'Activo',
    'epin',
    sysdate,
    '127.0.0.1'
);

INSERT INTO db_general.admi_parametro_det VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_ACEPTACION_PROSPECTO'
            AND estado = 'Activo'
    ),
    'Correo Electronico',
    '5',
    '1',
    NULL,
    NULL,
    'Activo',
    'epin',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    'Forma de contacto correo electronico'
);

INSERT INTO db_general.admi_parametro_det VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_ACEPTACION_PROSPECTO'
            AND estado = 'Activo'
    ),
    'Telefono Fijo',
    '4',
    '1',
    NULL,
    NULL,
    'Activo',
    'epin',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    'Forma de contacto telefono fijo'
);

INSERT INTO db_general.admi_parametro_det VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_ACEPTACION_PROSPECTO'
            AND estado = 'Activo'
    ),
    'Telefono Movil Claro',
    '25',
    '1',
    NULL,
    NULL,
    'Activo',
    'epin',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    'id de las formas de contacto que se pueden elegir en formulario de prospecto'
);

INSERT INTO db_general.admi_parametro_det VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_ACEPTACION_PROSPECTO'
            AND estado = 'Activo'
    ),
    'Telefono Movil Movistar',
    '26',
    '1',
    NULL,
    NULL,
    'Activo',
    'epin',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    'id de las formas de contacto que se pueden elegir en formulario de prospecto'
);

INSERT INTO db_general.admi_parametro_det VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FORMAS_CONTACTO_FORMULARIO_ACEPTACION_PROSPECTO'
            AND estado = 'Activo'
    ),
    'Telefono Movil CNT',
    '27',
    '1',
    NULL,
    NULL,
    'Activo',
    'epin',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    'id de las formas de contacto que se pueden elegir en formulario de prospecto'
);


COMMIT;
/