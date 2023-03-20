/** 
 * @author Leonela Burgos <mlburgos@telconet.ec>
 * @version 1.0 
 * @since 01-21-2023
 * Se crea DML de configuraciones del Proyecto Ley Organica
 */
INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
  'URL_CONTRATO_ADHESION',
  'lISTADO DE URL CONTRATO DE ADHESION',
  'COMERCIAL',
  NULL,
  'Activo',
  'mlburgos',
  SYSDATE,
  '127.0.0.1', 
  null, 
  null, 
  null);
  
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
    'https://www.netlife.ec/planes-hogar/',
    'https://www.netlife.ec/planes-pro/',
    'https://www.netlife.ec/planes-pyme/',
    NULL,
    'Activo',
    'mlburgos',
    SYSDATE,
    '127.0.0.1', 
    NULL,
    NULL,
    NULL,
    NULL,
    18,
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
    'https://www.netlife.ec/normas-y-regulaciones-indices-de-calidad',
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
    18,
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
    'https://www.netlife.ec/politica-tratamiento-datos-personales/',
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
    18,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

COMMIT;
/
