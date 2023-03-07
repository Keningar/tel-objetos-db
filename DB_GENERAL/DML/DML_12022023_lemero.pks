/**
 * Creacion de los parametros para la Migracion de los OLTs
 * para el proceso de Migracion de los OLTs
 *
 * @author Leonardo Mero <lemero@telconet.ec>
 * @version 1.0 12-12-2022
 */

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'MIGRACION_OLT_PARAMETROS', 
    'Parametros para realizar el consumo del WS de Networking para la migracion de los OLTs',
    'TECNICO',
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1'
  );

--Ingreso de los parametros para las subredes
  INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'Parametros Subredes',
    'CAMSAFECITY', --USO
    '27', --PREFIJO
    'Ocupado', --ESTADO
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );

  INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'Parametros Subredes',
    'SAFECITYCAMVPN', --USO
    '29', --PREFIJO
    'Ocupado', --ESTADO
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
  INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'Parametros Subredes',
    'WIFISSIDSAFECITY', --USO
    '25', --PREFIJO
    'Activo', --ESTADO
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
  INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'Parametros Subredes',
    'WIFIADMINSAFECITY', --USO
    '25', --PREFIJO
    'Activo', --ESTADO
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    (SELECT COD_EMPRESA
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE PREFIJO = 'TN'
    AND ESTADO    = 'Activo'
    )
  );
  COMMIT;
/