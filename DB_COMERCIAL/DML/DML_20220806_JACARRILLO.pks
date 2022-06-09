/**
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 * @version 1.0
 * @since 04-14-2022  
 * Se crea nuevos parametros de configuraciones para transferencia de documentos
 */
SET DEFINE OFF; 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'CANTIDAD_PROCESAR',
    '10000',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'filtra cantidad de registros a procesar por al consultar documentos pendientes'
  );
   
   
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'ESTADO_FIRMA',
    'expirado,valido',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'filtra ESTADO de certificado'
  );
   
   
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
      AND ESTADO             = 'Activo'
    ),
    'CANTIDAD_DIAS',
    '60',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    '18',
    'filtra por cantidad de dias apartir de la fecha de creacion de cada certificado'
  );
   

COMMIT; 
/


