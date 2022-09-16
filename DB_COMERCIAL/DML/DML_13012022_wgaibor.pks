-- CREACIÓN DEL PARÁMETRO CAB  - ESTADO_CONT_ADEN_COMERCIAL
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
    'ACEPTACION_CLAUSULA_CONTRATO',
    'Parámetro para saber si se solicita al usuario llenar la información del cliente',
    'COMERCIAL',
    'Activo',
    'wgaibor',
    sysdate,
    '127.0.0.1'
);

-- DB_GENERAL.ADMI_PARAMETRO_DET 
-- FLUJO DE REGULARIZACIÓN (CONTRATO/ADENDUM) ACTIVO AUTORIZADOS

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
    valor5,
    valor6,
    valor7,
    empresa_cod
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'MOSTRAR CLAUSULA',
    'S',
    'CLAUSULA_CONTRATO',
    NULL,
    NULL,
    'Activo',
    'wgaibor',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    18
);
--
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
    valor5,
    valor6,
    valor7,
    empresa_cod
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'MOSTRAR DATOS BANCARIO',
    'S',
    'LINK_BANCARIO',
    NULL,
    NULL,
    'Activo',
    'wgaibor',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    18
);
--
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
    valor5,
    valor6,
    valor7,
    EMPRESA_COD
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'URL NETLIFE',
    'http://netlife.com.ec/',
    'URL_PORTAL_NETLIFE',
    NULL,
    NULL,
    'Activo',
    'wgaibor',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    18
);
--
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
    valor5,
    valor6,
    valor7,
    EMPRESA_COD
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'NUMERO DE INTENTOS',
    '3',
    'LINK_BANCARIO',
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    18
);
--
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
    valor5,
    valor6,
    valor7,
    EMPRESA_COD
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'TIEMPO DE VIGENCIA MIN',
    '30',
    'LINK_BANCARIO',
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    18
);
--
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
    valor5,
    valor6,
    valor7,
    EMPRESA_COD
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'CADUCAR CREDENCIALES',
    '<h1> Estimado asesor</h1>
    <p> Las credenciales del cliente {{cliente}} se han caducado.</p>',
    'sistemas-qa@telconet.ec',
    NULL,
    NULL,
    'Activo',
    'wgaibor',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    18
);

--
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
    'CONTRATO_FISICO_VALIDACION',
    'Parámetro con validaciones de contrato fisico validaciones',
    'COMERCIAL',
    'Activo',
    'wgaibor',
    sysdate,
    '127.0.0.1'
);

--
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
    valor5,
    valor6,
    valor7,
    EMPRESA_COD
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CONTRATO_FISICO_VALIDACION'
            AND estado = 'Activo'
    ),
    'Parámetro con validaciones de contrato fisico validaciones VALOR1: -PREGUNTA1-, VALOR2: -RESPUESTA1- VALOR3: -PREGUNTA2-, VALOR4: -RESPUESTA2-, VALOR5: -RESPUESTA POR default-',
    'FIRMA DIGITAL',
    'No Acepta',
    'TÍTULO DE FACTURACIÓN',
    'ELECTRÓNICA',
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'Acepta',
    NULL,
    NULL,
    18
);

--
INSERT INTO DB_COMERCIAL.ADMI_CARACTERISTICA (
        ID_CARACTERISTICA,
        DESCRIPCION_CARACTERISTICA,
        TIPO_INGRESO,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        TIPO
    ) VALUES (
        DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
        'linkDatosBancarios',
        'T',
        'Activo',
        SYSDATE,
        'wgaibor',
        'COMERCIAL'
    );

--

INSERT INTO DB_COMERCIAL.ADMI_CARACTERISTICA (
        ID_CARACTERISTICA,
        DESCRIPCION_CARACTERISTICA,
        DETALLE_CARACTERISTICA,
        TIPO_INGRESO,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        TIPO
    ) VALUES (
        DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
        'passwordLinkDatosBancarios',
        'Password y numero de intentos generado para la credencial de aceptación de cláusulas y datos bancarios',
        'T',
        'Activo',
        SYSDATE,
        'ccaguana',
        'COMERCIAL'
    );




--


INSERT INTO DB_COMERCIAL.ADMI_CARACTERISTICA (
        ID_CARACTERISTICA,
        DESCRIPCION_CARACTERISTICA,
        DETALLE_CARACTERISTICA,
        TIPO_INGRESO,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        TIPO
    ) VALUES (
        DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
        'usuarioLinkDatosBancarios',
        'Usuario registrado para la credencial de aceptación de cláusulas y datos bancarios',
        'T',
        'Activo',
        SYSDATE,
        'ccaguana',
        'COMERCIAL'
    );




INSERT INTO DB_COMERCIAL.ADMI_CARACTERISTICA (
        ID_CARACTERISTICA,
        DESCRIPCION_CARACTERISTICA,
        DETALLE_CARACTERISTICA,
        TIPO_INGRESO,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        TIPO
    ) VALUES (
        DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
        'correoLinkDatosBancarios',
        'Correo registrado para la credencial de aceptación de cláusulas y datos bancarios',
        'T',
        'Activo',
        SYSDATE,
        'ccaguana',
        'COMERCIAL'
    );

INSERT INTO DB_COMERCIAL.ADMI_CARACTERISTICA (
        ID_CARACTERISTICA,
        DESCRIPCION_CARACTERISTICA,
        DETALLE_CARACTERISTICA,
        TIPO_INGRESO,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        TIPO
    ) VALUES (
        DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
        'datosLinkDatosBancarios',
        'Registro de los datos bancarios',
        'T',
        'Activo',
        SYSDATE,
        'ccaguana',
        'COMERCIAL'
    );

INSERT INTO DB_COMERCIAL.ADMI_CARACTERISTICA (
        ID_CARACTERISTICA,
        DESCRIPCION_CARACTERISTICA,
        DETALLE_CARACTERISTICA,
        TIPO_INGRESO,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        TIPO
    ) VALUES (
        DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
        'editarFormaPagoCliente',
        'Bandera para conocer si el cliente proviene de un editar forma de pago',
        'T',
        'Activo',
        SYSDATE,
        'wgaibor',
        'COMERCIAL'
    );


COMMIT;
/