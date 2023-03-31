/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones bandera para utilizacion de enviar correo o whtssap
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 20-03-2023 - Versión Inicial.
 */



            
INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
 (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE        
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'),
'NOTIFICACION_WHATSAPP','N',NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,null,null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
 (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'),
'PLANTILLA_WHATSAPP','netsopp006_v2',NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,null,null,null);


           
INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES 
(
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
        SELECT
            ID_PARAMETRO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE
            NOMBRE_PARAMETRO = 'URL_CONTRATO_ADHESION' AND ESTADO='Activo'
    ),
    'URL_SITIO_WEB_CONSULTA_TARIFAS',
    'https://www.ecuanet.ec/planes-hogar/',
    '',
    '',
    NULL,
    'Activo',
    'jbroncano',
    SYSDATE,
    '127.0.0.1', 
    NULL,
    NULL,
    NULL,
    NULL,
    33,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES 
(
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
        SELECT
            ID_PARAMETRO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE
            NOMBRE_PARAMETRO = 'URL_CONTRATO_ADHESION' AND ESTADO='Activo'
    ),
    'URL_SITIO_WEB_CONSULTA_CALIDAD_SERVICIO',
    'https://www.ecuanet.ec/normas-y-regulaciones-indices-de-calidad',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jbroncano',
    SYSDATE,
    '127.0.0.1', 
    NULL,
    NULL,
    NULL,
    NULL,
    33,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES 
(
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
        SELECT
            ID_PARAMETRO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE
            NOMBRE_PARAMETRO = 'URL_CONTRATO_ADHESION' AND ESTADO='Activo'
    ),
    'URL_SITIO_WEB_DATOS_PERSONALES',
    'https://www.ecuanet.ec/politica-tratamiento-datos-personales/',
    NULL,
    NULL,
    NULL,
    'Activo',
    'mlburgos',
    SYSDATE,
    '127.0.0.1', 
    NULL,
    NULL,
    NULL,
    NULL,
    33,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);




COMMIT;
/