/**
  * Documentación para Registro de parametros necesarios para Ecuanet en Facturacio Detallada y Ciclo Facturacion.
  *  
  * @author Andre Lazo <alazo@telconet.ec>
  * @version 1.0 17-03-2023
  */

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'Instalacion',
    NULL,
    (
        SELECT
            id_plan
        FROM
            db_comercial.info_plan_cab
        WHERE
                codigo_plan = 'INS'
            AND nombre_plan = 'INSTALACION'
            AND empresa_cod = 33
            AND estado = 'Inactivo'
            AND usr_creacion = 'migracion_md'
    ),
    '1233',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    (
        SELECT
            id_plan
        FROM
            db_comercial.info_plan_cab
        WHERE
                codigo_plan = 'INS'
            AND nombre_plan = 'INSTALACION'
            AND empresa_cod = 33
            AND estado = 'Inactivo'
            AND usr_creacion = 'migracion_md'
    ),
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'Descuentos',
    NULL,
    (
        SELECT
            id_plan
        FROM
            db_comercial.info_plan_cab
        WHERE
                codigo_plan = 'DINST'
            AND nombre_plan = 'PROMO SUSCRIPCIONX3M'
            AND empresa_cod = 33
            AND estado = 'Activo'
            AND usr_creacion = 'migracion_md'
    ),
    '1234',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    (
        SELECT
            id_plan
        FROM
            db_comercial.info_plan_cab
        WHERE
                codigo_plan = 'DINST'
            AND nombre_plan = 'PROMO SUSCRIPCIONX3M'
            AND empresa_cod = 33
            AND estado = 'Activo'
            AND usr_creacion = 'migracion_md'
    ),
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'Equipos',
    (
        SELECT
            id_producto
        FROM
            db_comercial.admi_producto
        WHERE
                descripcion_producto = 'EQUIPOS VARIOS'
            AND empresa_cod = 33
            AND estado = 'Activo'
            AND usr_creacion = 'alazo'
    ),
    NULL,
    '1231',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'Dcto. Adicional',
    NULL,
    (
        SELECT
            id_plan
        FROM
            db_comercial.info_plan_cab
        WHERE
                codigo_plan = 'DINST'
            AND nombre_plan = 'PROMO SUSCRIPCIONX3M'
            AND empresa_cod = 33
            AND estado = 'Activo'
            AND usr_creacion = 'migracion_md'
    ),
    '1235',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'S',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'I. PROTEGIDO MULTI PAID',
    NULL,
    NULL,
    '2024',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'IP FIJA ADICIONAL PYME',
    NULL,
    NULL,
    '2027',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'IP FIJA',
    NULL,
    NULL,
    '2026',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'PARAMOUNT+',
    NULL,
    NULL,
    '2023',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CABLEADO ETHERNET',
    NULL,
    NULL,
    '2022',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'ECOMMERCE BASIC',
    NULL,
    NULL,
    '2021',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'Netlife Assistance Pro',
    NULL,
    NULL,
    '2020',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'ElCanalDelFutbol',
    NULL,
    NULL,
    '1730',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'PromoNetlifecam',
    NULL,
    NULL,
    '1619',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '127.0.0.1',
    'telcos_cancel_volun',
    sysdate,
    '127.0.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'NetlifeCloud',
    NULL,
    NULL,
    '1180',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'NetlifeAssistance',
    NULL,
    NULL,
    '1232',
    NULL,
    'Activo',
    'telcos_cancel_volun',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'FUENTE DE PODER',
    NULL,
    (
        SELECT
            id_plan
        FROM
            db_comercial.info_plan_cab
        WHERE
                codigo_plan = 'EQV01'
            AND nombre_plan = 'FUENTE DE PODER'
            AND empresa_cod = 33
            AND estado = 'Activo'
            AND usr_creacion = 'ecuanet'
    ),
    '1222',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'FUENTE DE PODER AP CISCO',
    NULL,
    NULL,
    '1226',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'EQUIPO AP CISCO',
    NULL,
    NULL,
    '1227',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CPE ADSL',
    NULL,
    NULL,
    '1225',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'ROSETA',
    NULL,
    (
        SELECT
            id_plan
        FROM
            db_comercial.info_plan_cab
        WHERE
                codigo_plan = 'RSTA'
            AND nombre_plan = 'ROSETA (Huawei)'
            AND empresa_cod = 33
            AND estado = 'Activo'
            AND usr_creacion = 'ecuanet'
    ),
    '1224',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CPE WIFI TELLION',
    NULL,
    NULL,
    '1221',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CPE ONT HUAWEI',
    NULL,
    (
        SELECT
            id_plan
        FROM
            db_comercial.info_plan_cab
        WHERE
                codigo_plan = 'CPEH'
            AND nombre_plan = 'CPE Huawei'
            AND empresa_cod = 33
            AND estado = 'Activo'
            AND usr_creacion = 'ecuanet'
    ),
    '1223',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CPE ONT TELLION',
    NULL,
    NULL,
    '1220',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CPE ONT ZTE',
    NULL,
    NULL,
    '1781',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CAMARA EZVIZ CS-C3N-A0-3G2WFL1',
    NULL,
    NULL,
    '1949',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CAMARA EZVIZ CS-C2C-A0-1E2WF',
    NULL,
    NULL,
    '1950',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CAMARA EZVIZ CS-CV206 (MINI-O)',
    NULL,
    NULL,
    '1617',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CAMARA EZVIZ CS-C1C-D0-1D1WFR',
    NULL,
    NULL,
    '1616',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'TARJETA MICRO SD',
    NULL,
    NULL,
    '1618',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'TARJETA MICRO SD',
    NULL,
    NULL,
    '1618',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'EXTENDER DUAL BAND',
    NULL,
    NULL,
    '1375',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'WA8011V',
    NULL,
    NULL,
    '2019',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'WA8M8011VW09',
    NULL,
    NULL,
    '2018',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'ZXHN H196A V9',
    NULL,
    NULL,
    '2017',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    '172.17.0.1',
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'WIFI DUAL BAND',
    NULL,
    NULL,
    '1374',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '172.17.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    'N',
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'SIR_CONF',
    NULL,
    NULL,
    '1271',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CO_DISP',
    NULL,
    NULL,
    '1270',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CO_AC',
    NULL,
    NULL,
    '1269',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CO_CORTI',
    NULL,
    NULL,
    '1268',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'REPET',
    NULL,
    NULL,
    '1267',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CERR_ULT',
    NULL,
    NULL,
    '1266',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'FOCO_LED',
    NULL,
    NULL,
    '1265',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'K_LUCES',
    NULL,
    NULL,
    '1264',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'TOMA_EMP',
    NULL,
    NULL,
    '1263',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'TOMA_SUP',
    NULL,
    NULL,
    '1262',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'SENS_M2',
    NULL,
    NULL,
    '1261',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'SENS_M1',
    NULL,
    NULL,
    '1260',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'SENS_PVR',
    NULL,
    NULL,
    '1275',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'SENS_PV',
    NULL,
    NULL,
    '1274',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'CONTR_UI',
    NULL,
    NULL,
    '1273',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
                nombre_parametro = 'FACTURACION SOLICITUD DETALLADA'
            AND estado = 'Activo'
    ),
    'NHOME',
    NULL,
    NULL,
    '1272',
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    usr_ult_mod,
    fe_ult_mod,
    ip_ult_mod,
    valor5,
    empresa_cod,
    valor6,
    valor7,
    observacion,
    valor8,
    valor9
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    '1847',
    'PARAMETRIZACION PARA LOS CICLOS DE FACTURACION',
    'Ciclo (I) - 1 al 30',
    (
        SELECT
            id_ciclo
        FROM
            db_financiero.admi_ciclo
        WHERE
                empresa_cod = '33'
            AND nombre_ciclo = 'Ciclo (I) - 1 al 30'
            AND codigo = 'CICLO1'
    ),
    NULL,
    NULL,
    'Activo',
    'alazo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    'Se agrega unicamente el parametro VALOR2 para el ciclo de facturacion I.',
    NULL,
    NULL
);

COMMIT;
/