
/**
 * Documentación INSERT DE PARÁMETROS para configurar las cuentas de correos para la autorización de contratos.
 * INSERT de parámetros en la estructura  DB_GENERAL.ADMI_PARAMETRO_CAB y DB_GENERAL.ADMI_PARAMETRO_DET.
 *
 * @author Walther Joao Gaibor C <wgaibor@telconet.ec>
 * @version 1.0 12-10-2022
 */

REM INSERTING into DB_GENERAL.ADMI_PARAMETRO_DET
SET DEFINE OFF;

--##############################################################################
--#########################  ADMI_PARAMETRO_CAB  ###############################
--##############################################################################
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    PROCESO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'CORREOS_ADMINISTRACION_CONTRATOS',
    'LISTADO DE CORREOS PARA LA ADMINISTRACIÓN DE CONTRATOS',
    'COMERCIAL',
    NULL,
    'Activo',
    'wgaibor',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL);

--##############################################################################
--#########################  ADMI_PARAMETRO_DET  ###############################
--##############################################################################
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    VALOR6,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CORREOS_ADMINISTRACION_CONTRATOS'
    ),
    'CORREO ADMINISTRACIÓN CONTRATOS GYE',
    'admcontratosgye@netlife.net.ec',
    NULL,
    NULL,
    NULL,
    'Activo',
    'wgaibor',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '18'
  );
--
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    VALOR6,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CORREOS_ADMINISTRACION_CONTRATOS'
    ),
    'CORREO ADMINISTRACIÓN CONTRATOS UIO',
    'admcontratosuio@netlife.net.ec',
    NULL,
    NULL,
    NULL,
    'Activo',
    'wgaibor',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    '18'
  );

--##############################################################################
--#########################  ADMI_CARACTERISTICA ###############################
--##############################################################################
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
        'docFisicoCargado',
        'T',
        'Activo',
        SYSDATE,
        'wgaibor',
        'COMERCIAL'
    );


/
COMMIT;