    INSERT INTO db_comercial.info_oficina_grupo
    SELECT DB_COMERCIAL.SEQ_INFO_OFICINA_GRUPO.NEXTVAL, 33, GRU.CANTON_ID, REPLACE(UPPER(GRU.NOMBRE_OFICINA), 'MEGADATOS', 'ECUANET'), GRU.DIRECCION_OFICINA, GRU.TELEFONO_FIJO_OFICINA, GRU.EXTENSION_OFICINA, GRU.FAX_OFICINA, GRU.CODIGO_POSTAL_OFI, GRU.ES_MATRIZ, GRU.ES_OFICINA_FACTURACION, GRU.ESTADO, 'epin', sysdate, GRU.IP_CREACION, GRU.ES_VIRTUAL, GRU.TERRITORIO, GRU.CTA_CONTABLE_CLIENTES, GRU.CTA_CONTABLE_ANTICIPOS, GRU.CTA_CONTABLE_PAGOS, GRU.NO_CTA, GRU.NUM_ESTAB_SRI, GRU.CTA_CONTABLE_CARGO, GRU.ID_OFICINA
    FROM db_comercial.info_oficina_grupo GRU
        where gru.empresa_id = 18
        and gru.estado = 'Activo'
        and gru.id_oficina in (58, 59);


    INSERT INTO DB_FINANCIERO.ADMI_CICLO (ID_CICLO,NOMBRE_CICLO,FE_INICIO,FE_FIN,OBSERVACION,FE_CREACION,USR_CREACION,IP_CREACION,EMPRESA_COD,ESTADO,CODIGO) 
    VALUES (DB_FINANCIERO.SEQ_ADMI_CICLO.NEXTVAL,'Ciclo (I) - 1 al 30',TIMESTAMP '2017-01-01 00:00:00.000000',TIMESTAMP '2017-01-31 00:00:00.000000',TO_CLOB('Ciclo inicial configurado'),sysdate,'epin','127.0.0.1','33','Activo','CICLO1');


    INSERT INTO db_general.admi_area (
        id_area,
        nombre_area,
        estado,
        usr_creacion,
        fe_creacion,
        usr_ult_mod,
        fe_ult_mod,
        empresa_cod,
        email_area
    ) VALUES (
        db_general.seq_admi_area.nextval,
        'Administrativo',
        'Activo',
        'wgaibor',
        sysdate,
        'wgaibor',
        sysdate,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        NULL
    );

    INSERT INTO db_general.admi_area (
        id_area,
        nombre_area,
        estado,
        usr_creacion,
        fe_creacion,
        usr_ult_mod,
        fe_ult_mod,
        empresa_cod,
        email_area
    ) VALUES (
        db_general.seq_admi_area.nextval,
        'Tecnico',
        'Activo',
        'wgaibor',
        sysdate,
        'wgaibor',
        sysdate,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        NULL
    );

    INSERT INTO db_general.admi_area (
        id_area,
        nombre_area,
        estado,
        usr_creacion,
        fe_creacion,
        usr_ult_mod,
        fe_ult_mod,
        empresa_cod,
        email_area
    ) VALUES (
        db_general.seq_admi_area.nextval,
        'Comercial',
        'Activo',
        'wgaibor',
        sysdate,
        'wgaibor',
        sysdate,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        NULL
    );




    INSERT INTO db_general.admi_departamento (
        id_departamento,
        area_id,
        nombre_departamento,
        estado,
        usr_creacion,
        fe_creacion,
        usr_ult_mod,
        fe_ult_mod,
        empresa_cod,
        email_departamento
    ) VALUES (
        db_general.seq_admi_departamento.nextval,
        (
            SELECT
                id_area
            FROM
                db_general.admi_area
            WHERE
                    nombre_area = 'Administrativo'
                AND empresa_cod = (
                    SELECT
                        iegr.cod_empresa
                    FROM
                        db_comercial.info_empresa_grupo iegr
                    WHERE
                            iegr.prefijo = 'EN'
                        AND iegr.estado = 'Activo'
                )
        ),
        'Administracion',
        'Activo',
        'wgaibor',
        sysdate,
        'wgaibor',
        sysdate,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        NULL
    );

    INSERT INTO db_general.admi_departamento (
        id_departamento,
        area_id,
        nombre_departamento,
        estado,
        usr_creacion,
        fe_creacion,
        usr_ult_mod,
        fe_ult_mod,
        empresa_cod,
        email_departamento
    ) VALUES (
        db_general.seq_admi_departamento.nextval,
        (
            SELECT
                id_area
            FROM
                db_general.admi_area
            WHERE
                    nombre_area = 'Comercial'
                AND empresa_cod = (
                    SELECT
                        iegr.cod_empresa
                    FROM
                        db_comercial.info_empresa_grupo iegr
                    WHERE
                            iegr.prefijo = 'EN'
                        AND iegr.estado = 'Activo'
                )
        ),
        'Ventas',
        'Activo',
        'wgaibor',
        sysdate,
        'wgaibor',
        sysdate,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        NULL
    );


    INSERT INTO db_general.admi_departamento (
        id_departamento,
        area_id,
        nombre_departamento,
        estado,
        usr_creacion,
        fe_creacion,
        usr_ult_mod,
        fe_ult_mod,
        empresa_cod,
        email_departamento
    ) VALUES (
        db_general.seq_admi_departamento.nextval,
        (
            SELECT
                id_area
            FROM
                db_general.admi_area
            WHERE
                    nombre_area = 'Comercial'
                AND empresa_cod = (
                    SELECT
                        iegr.cod_empresa
                    FROM
                        db_comercial.info_empresa_grupo iegr
                    WHERE
                            iegr.prefijo = 'EN'
                        AND iegr.estado = 'Activo'
                )
        ),
        'Ventas Sucursal',
        'Activo',
        'wgaibor',
        sysdate,
        'wgaibor',
        sysdate,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        NULL
    );

    INSERT INTO db_general.admi_departamento (
        id_departamento,
        area_id,
        nombre_departamento,
        estado,
        usr_creacion,
        fe_creacion,
        usr_ult_mod,
        fe_ult_mod,
        empresa_cod,
        email_departamento
    ) VALUES (
        db_general.seq_admi_departamento.nextval,
        (
            SELECT
                id_area
            FROM
                db_general.admi_area
            WHERE
                    nombre_area = 'Comercial'
                AND empresa_cod = (
                    SELECT
                        iegr.cod_empresa
                    FROM
                        db_comercial.info_empresa_grupo iegr
                    WHERE
                            iegr.prefijo = 'EN'
                        AND iegr.estado = 'Activo'
                )
        ),
        'Comercial',
        'Activo',
        'wgaibor',
        sysdate,
        'wgaibor',
        sysdate,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        NULL
    );


    INSERT INTO db_general.admi_departamento (
        id_departamento,
        area_id,
        nombre_departamento,
        estado,
        usr_creacion,
        fe_creacion,
        usr_ult_mod,
        fe_ult_mod,
        empresa_cod,
        email_departamento
    ) VALUES (
        db_general.seq_admi_departamento.nextval,
        (
            SELECT
                id_area
            FROM
                db_general.admi_area
            WHERE
                    nombre_area = 'Tecnico'
                AND empresa_cod = (
                    SELECT
                        iegr.cod_empresa
                    FROM
                        db_comercial.info_empresa_grupo iegr
                    WHERE
                            iegr.prefijo = 'EN'
                        AND iegr.estado = 'Activo'
                )
        ),
        'Operaciones',
        'Activo',
        'wgaibor',
        sysdate,
        'wgaibor',
        sysdate,
        (
            SELECT
                iegr.cod_empresa
            FROM
                db_comercial.info_empresa_grupo iegr
            WHERE
                    iegr.prefijo = 'EN'
                AND iegr.estado = 'Activo'
        ),
        NULL
    );


    INSERT INTO db_infraestructura.ADMI_JURISDICCION ADM
    SELECT db_infraestructura.SEQ_ADMI_JURISDICCION.NEXTVAL, (SELECT ID_OFICINA FROM DB_COMERCIAL.info_oficina_grupo WHERE JUR.OFICINA_ID = REF_OFICINA_ID), REPLACE(UPPER(JUR.NOMBRE_JURISDICCION), 'MEGADATOS', 'ECUANET'), REPLACE(UPPER(JUR.DESCRIPCION_JURISDICCION), 'MEGADATOS', 'ECUANET'), JUR.ESTADO, 'epin', sysdate, 'epin', sysdate, 0, jur.id_jurisdiccion
    from db_infraestructura.ADMI_JURISDICCION JUR
    left join db_comercial.info_oficina_grupo ofi
    on jur.oficina_id = ofi.id_oficina
    WHERE jur.ESTADO in  ('Activo','Modificado')
    and ofi.empresa_id =18
    and ofi.id_oficina in (58, 59);


    insert into db_infraestructura.admi_canton_jurisdiccion
    select db_infraestructura.seq_admi_canton_jurisdiccion.nextval, canton_id, (select id_jurisdiccion from db_infraestructura.admi_jurisdiccion where cupo_mobile = can.jurisdiccion_id and rownum = 1), can.segundo_octeto, can.mail_tecnico, can.ip_reserva, can.nombre_mst, can.revision_mst, can.instance_mst, can.estado, 'epin', sysdate, can.usr_ult_mod, can.fe_ult_mod
    from db_infraestructura.admi_canton_jurisdiccion can
    left join db_infraestructura.admi_jurisdiccion jur
    on can.jurisdiccion_id = jur.cupo_mobile
    where jur.cupo_mobile > 0  ;



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
                    descripcion_rol = 'Director General'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Asistente Administrativa'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
                AND ESTADO = 'Activo'
                AND USR_CREACION = 'ssosync'
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Contador General'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Director De Ventas'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Director De Producto'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Asesor Comercial'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Director De Operaciones'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Ingeniero De Operaciones'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Pre-cliente'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Pre-cliente'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Cliente'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Cliente'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Representante Legal Juridico'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Representante Legal'
                )
        ),
        'Activo',
        'wgaibor',
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
                    descripcion_rol = 'Ejecutivo De Ventas'
                AND tipo_rol_id = (
                    SELECT
                        id_tipo_rol
                    FROM
                        db_general.admi_tipo_rol
                    WHERE
                        descripcion_tipo_rol = 'Empleado'
                )
        ),
        'Activo',
        'wgaibor',
        sysdate,
        '127.0.0.0'
    );


    INSERT INTO DB_GENERAL.admi_sector
    select DB_GENERAL.SEQ_ADMI_SECTOR.nextval, SEC.NOMBRE_SECTOR, SEC.PARROQUIA_ID, SEC.ESTADO, 'epin', sysdate, null, null, 33
    FROM DB_GENERAL.ADMI_SECTOR SEC
    where empresa_cod = 18
    and estado = 'Activo';

    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (ID_PARAMETRO_DET,PARAMETRO_ID,DESCRIPCION,VALOR1,VALOR2,VALOR3,VALOR4,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,VALOR5,EMPRESA_COD,VALOR6,VALOR7,OBSERVACION,VALOR8,VALOR9) 
    VALUES (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,509,'DOCUMENTO ENTREGABLE PAGARÉ','PAG','PAGARÉ','1',NULL,'Activo','epin',sysdate,'127.0.0.1',NULL,NULL,NULL,NULL,'33',NULL,NULL,NULL,NULL,NULL);
    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (ID_PARAMETRO_DET,PARAMETRO_ID,DESCRIPCION,VALOR1,VALOR2,VALOR3,VALOR4,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,VALOR5,EMPRESA_COD,VALOR6,VALOR7,OBSERVACION,VALOR8,VALOR9) 
    VALUES (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,509,'DOCUMENTO ENTREGABLE COPIA DE CÉDULA','CED','COPIA DE CÉDULA','2',NULL,'Activo','epin',sysdate,'127.0.0.1',NULL,NULL,NULL,NULL,'33',NULL,NULL,NULL,NULL,NULL);

    insert into DB_GENERAL.admi_parametro_det 
    select db_general.seq_admi_parametro_det.nextval, parametro_id, descripcion, valor1, valor2, valor3, valor4, estado, 'epin', sysdate, ip_creacion, null, null, null, VALOR5, '33', VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9
    from DB_GENERAL.admi_parametro_det
    where parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_ADULTO_MAYOR') and empresa_cod = 18;


    insert into DB_GENERAL.admi_parametro_det 
    select db_general.seq_admi_parametro_det.nextval, parametro_id, descripcion, valor1, valor2, valor3, valor4, estado, 'epin', sysdate, ip_creacion, null, null, null, VALOR5, '33', VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9
    from DB_GENERAL.admi_parametro_det
    where parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'NOMBRE_TECNICO') and empresa_cod = 18;

    insert into DB_GENERAL.admi_parametro_det 
    select db_general.seq_admi_parametro_det.nextval, parametro_id, descripcion, valor1, valor2, valor3, valor4, estado, 'epin', sysdate, ip_creacion, null, null, null, VALOR5, '33', VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9
    from DB_GENERAL.admi_parametro_det
    where parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'NOMBRE_TECNICO_PRODUCTO') and empresa_cod = 18;


    insert into DB_GENERAL.admi_parametro_det 
    select db_general.seq_admi_parametro_det.nextval, parametro_id, descripcion, valor1, valor2, valor3, valor4, estado, 'epin', sysdate, ip_creacion, null, null, null, VALOR5, '33', VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9
    from DB_GENERAL.admi_parametro_det
    where parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'TIEMPO_BANDEJA_PLAN_AUTOMATICA') and empresa_cod = 18;
    
    insert into DB_GENERAL.admi_parametro_det 
    select db_general.seq_admi_parametro_det.nextval, parametro_id, descripcion, valor1, valor2, valor3, valor4, estado, 'epin', sysdate, ip_creacion, null, null, null, 'EN', '33', VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9
    from DB_GENERAL.admi_parametro_det
    where parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'DESCUENTOS_FACTURAS') and empresa_cod = 18;

    INSERT INTO DB_GENERAL.admi_gestion_directorios 
    SELECT DB_GENERAL.SEQ_ADMI_GESTION_DIRECTORIOS.NEXTVAL, CODIGO_APP, 3, APLICACION, PAIS, 'EN', MODULO, SUBMODULO, ESTADO, SYSDATE, NULL, 'epin', NULL
    FROM DB_GENERAL.admi_gestion_directorios 
    where aplicacion = 'TmComercial'
    AND EMPRESA = 'MD';

    UPDATE DB_GENERAL.admi_parametro_det
    SET VALOR1 = (SELECT id_producto from db_comercial.admi_producto where codigo_producto = 'INTD' and empresa_cod = '33' and estado = 'Activo')
    where parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_ADULTO_MAYOR') 
    and empresa_cod = '33'
    and descripcion = 'APLICA_PRODUCTO_DESCUENTO_ADULTO_MAYOR'
    and valor1 = '63';

    insert into DB_GENERAL.admi_parametro_det 
    select db_general.seq_admi_parametro_det.nextval, parametro_id, descripcion, valor1, valor2, valor3, valor4, estado, 'epin', sysdate, ip_creacion, null, null, null, VALOR5, '33', VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9
    from DB_GENERAL.admi_parametro_det
    where parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_SOLICITUD_DESC_DISCAPACIDAD') and empresa_cod = 18;

    insert into DB_GENERAL.admi_parametro_det 
    select db_general.seq_admi_parametro_det.nextval, parametro_id, descripcion, valor1, valor2, valor3, valor4, estado, 'epin', sysdate, ip_creacion, null, null, null, VALOR5, '33', VALOR6, VALOR7, OBSERVACION, VALOR8, VALOR9
    from DB_GENERAL.admi_parametro_det
    where parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'VARIABLES_VELOCIDAD_PLANES') and empresa_cod = 18;

    INSERT INTO DB_COMERCIAL.ADMI_TIPO_NEGOCIO (ID_TIPO_NEGOCIO, CODIGO_TIPO_NEGOCIO, NOMBRE_TIPO_NEGOCIO, FE_CREACION, USR_CREACION, ESTADO, EMPRESA_COD)
    VALUES (DB_COMERCIAL.SEQ_ADMI_TIPO_NEGOCIO.NEXTVAL, 'HOME', 'HOME', SYSDATE, 'epin', 'Activo', 33);

    INSERT INTO DB_COMERCIAL.ADMI_TIPO_CONTRATO (ID_TIPO_CONTRATO, EMPRESA_COD, DESCRIPCION_TIPO_CONTRATO, FE_CREACION, USR_CREACION, ESTADO, TIEMPO_FINALIZACION, TIEMPO_ALERTA_FINALIZACION)
    VALUES (DB_COMERCIAL.SEQ_ADMI_TIPO_CONTRATO.NEXTVAL, 33, 'HOME', SYSDATE, 'epin', 'Activo', 12, 10);



COMMIT;
/
DECLARE
  
  CURSOR C_GET_VENDEDOR IS
  select per.persona_id,
   (SELECT ID_EMPRESA_ROL FROM db_comercial.INFO_EMPRESA_ROL WHERE ROL_ID  = (SELECT ID_ROL FROM DB_COMERCIAL.ADMI_ROL WHERE DESCRIPCION_ROL = 'Ejecutivo De Ventas' AND TIPO_ROL_ID = 1) AND EMPRESA_COD = 33) as EMP_ROL_ID
 , (SELECT ID_OFICINA FROM db_comercial.info_oficina_grupo where ref_oficina_id = per.oficina_id) as oficina_id
 , (SELECT ID_DEPARTAMENTO FROM DB_GENERAL.admi_departamento where nombre_departamento = (select nombre_departamento from DB_GENERAL.admi_departamento where id_departamento = per.departamento_id) and empresa_cod = 33) as departamento_id
 , per.estado, per.es_prepago
  from  db_comercial.info_persona_empresa_rol per
  where per.empresa_rol_id = 1619
    and per.estado = 'Activo';     
  
BEGIN
  FOR I IN C_GET_VENDEDOR() LOOP
    
    INSERT INTO DB_COMERCIAL.info_persona_empresa_rol(ID_PERSONA_ROL, PERSONA_ID, EMPRESA_ROL_ID, OFICINA_ID, DEPARTAMENTO_ID, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, ES_PREPAGO)
    VALUES(db_comercial.seq_info_persona_empresa_rol.nextval, I.PERSONA_ID, I.EMP_ROL_ID, I.OFICINA_ID, I.DEPARTAMENTO_ID, I.ESTADO, 'epin', sysdate, '127.0.0.1', I.ES_PREPAGO);

  END LOOP;
  
 
  COMMIT;
  
--rollback; 
END;
   --
    
/