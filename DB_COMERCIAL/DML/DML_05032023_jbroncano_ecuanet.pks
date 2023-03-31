
INSERT INTO db_comercial.info_empresa_rol (
        id_empresa_rol,
        empresa_cod,
        rol_id,
        estado,
        usr_creacion,
        fe_creacion,
        ip_creacion
    ) VALUES (
        db_comercial.seq_info_empresa_rol.nextval,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        (
            SELECT
                id_rol
            FROM
                db_general.admi_rol
            WHERE
                    descripcion_rol = 'Contacto Comercial'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Contacto'
                )
        ),
        'Activo',
        'jbroncano',
        sysdate,
        '127.0.0.0'
    );


INSERT INTO db_comercial.info_empresa_rol (
        id_empresa_rol,
        empresa_cod,
        rol_id,
        estado,
        usr_creacion,
        fe_creacion,
        ip_creacion
    ) VALUES (
        db_comercial.seq_info_empresa_rol.nextval,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        (
            SELECT
                id_rol
            FROM
                db_general.admi_rol
            WHERE
                    descripcion_rol = 'Contacto Administrador de edificio'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Contacto'
                )
        ),
        'Activo',
        'jbroncano',
        sysdate,
        '127.0.0.0'
    );



   INSERT INTO db_comercial.info_empresa_rol (
        id_empresa_rol,
        empresa_cod,
        rol_id,
        estado,
        usr_creacion,
        fe_creacion,
        ip_creacion
    ) VALUES (
        db_comercial.seq_info_empresa_rol.nextval,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        (
            SELECT
                id_rol
            FROM
                db_general.admi_rol
            WHERE
                    descripcion_rol = 'Contacto Tecnico'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Contacto'
                )
        ),
        'Activo',
        'jbroncano',
        sysdate,
        '127.0.0.0'
    );


    INSERT INTO db_comercial.info_empresa_rol (
        id_empresa_rol,
        empresa_cod,
        rol_id,
        estado,
        usr_creacion,
        fe_creacion,
        ip_creacion
    ) VALUES (
        db_comercial.seq_info_empresa_rol.nextval,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        (
            SELECT
                id_rol
            FROM
                db_general.admi_rol
            WHERE
                    descripcion_rol = 'Contacto Facturacion/Cobranza'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Contacto'
                )
        ),
        'Activo',
        'jbroncano',
        sysdate,
        '127.0.0.0'
    );


    COMMIT;

    /




