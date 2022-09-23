/**
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 * @version 1.0
 * @since 23-09-2022  
 * Se crea parametros de configuraciones para creacion de prospecto
 */
SET DEFINE OFF; 

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
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
    'PARAM_FLUJO_PROSPECTO',
    'Parametros definidos para prospecto',
    'COMERCIAL',
    NULL,
    'Activo',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1',
    'jacarrillo',
    SYSDATE,
    '172.17.0.1'
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
      WHERE NOMBRE_PARAMETRO =  'PARAM_FLUJO_PROSPECTO'
      AND ESTADO             = 'Activo'
    ),
   'LIMITE_RECOMENDACION',
    1000,
    '{}',
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
    'limite valor de recomendacion de tarjetas.'
  );


 COMMIT;
/
 