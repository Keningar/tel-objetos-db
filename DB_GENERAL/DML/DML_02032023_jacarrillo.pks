
 /**
 * Parámetros de la formas de contactos para link bancario flujos de prospecto y regularizacion
 *
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 *
 * @version 1.0
 */

 

-----------------------------------------------
--FORMAS DE CONTACTOS PARA EMPRESA MEGADATOS ID 18
-----------------------------------------------



--forma de contacto para flujo de prospecto 
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
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Correo Electrónico',
    '5',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil Claro',
    '25',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil Movistar',
    '26',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil CNT',
    '27',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Fijo',
    '4',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
);


--forma de contacto para regularización de clientes
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
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Correo Electrónico',
    '5',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil Claro',
    '25',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil Movistar',
    '26',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil CNT',
    '27',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Fijo',
    '4',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Formas de contacto permitido'
);

-----------------------------------------------
--FORMAS DE CONTACTOS PARA EMPRESA ECUANET ID 33
-----------------------------------------------



--forma de contacto para flujo de prospecto 
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
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Correo Electrónico',
    '5',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil Claro',
    '25',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil Movistar',
    '26',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil CNT',
    '27',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Fijo',
    '4',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
);


--forma de contacto para regularización de clientes
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
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Correo Electrónico',
    '5',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil Claro',
    '25',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil Movistar',
    '26',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Movil CNT',
    '27',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
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
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'FORMAS_CONTACTO',
    'Teléfono Fijo',
    '4',
    '1',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Formas de contacto permitido'
);




--Datos de presentacion link de prospecto para megaDatos
INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,   
    valor5,
    valor6,
    valor7,
    valor8, 
    valor9,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'PRESENTACION',
    'Netlife - Internet seguro de Ultra Alta Velocidad',
    'https://netlife.com.ec/',
    'https://www.netlife.ec/wp-content/themes/netlifetheme/images/favicon/favicon-16x16.png',     
    'https://cdnnetlife.konibit.com.mx/PROD_ENV/imagenes/lopdp/background.png', 
    'https://cdnnetlife.konibit.com.mx/PROD_ENV/imagenes/lopdp/backgroundEnero.png', 
    '#f58514',
    '#808a9c',
    NULL,
    NULL, 
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    18,
    'Valor1=Title, Valor2=link redireccion, Valor3=Icono app, Valor4=Imagen de fondo web, Valor5=Imagen de fondo movil'
);
 

--Datos de presentacion link de prospecto para ecuanet
INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,   
    valor5,
    valor6,
    valor7,
    valor8, 
    valor9,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'PRESENTACION',
    'Ecuanet - Internet seguro de Ultra Alta Velocidad',
    'https://ecuanet.com.ec/',
    'https://cdnnetlife.konibit.com.mx/PROD_ENV/imagenes/lopdp/logoEcuanet16x16.jpg',  
    'https://cdnnetlife.konibit.com.mx/PROD_ENV/imagenes/lopdp/backgroundEcuanet.jpg', 
    'https://cdnnetlife.konibit.com.mx/PROD_ENV/imagenes/lopdp/backgroundMovilEcuanet.jpg', 
    '#1b80fc', --remplazar 
    '#808a9c', --remplazar    
    NULL,
    NULL, 
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    33,
    'Valor1=Title, Valor2=link redireccion, Valor3=Icono app, Valor4=Imagen de fondo web, Valor5=Imagen de fondo movil'
);
 



COMMIT; 

/