           
 /**
 * Insert de parámetros de remitente
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 *
 * @version 1.0
 */

 

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'CAB_REMITENTE_CORREO_MS',
    'CABECERA DE LOS REMITENTE PARA LOS MS',
    'Activo',
    'ccaguana',
    CURRENT_TIMESTAMP,
    '127.0.0.1'
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
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='CAB_REMITENTE_CORREO_MS'
    ),
    'REMITENTE_DIGITAL',
    'defense@netlife.ec',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '18'
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
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='CAB_REMITENTE_CORREO_MS'
    ),
    'REMITENTE_DIGITAL',
    'notificacionesecuanet@ecuanet.com.ec',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '33'
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
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='CAB_REMITENTE_CORREO_MS'
    ),
    'REMITENTE_CUADRILLA',
    'defense@netlife.ec',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '18'
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
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='CAB_REMITENTE_CORREO_MS'
    ),
    'REMITENTE_CUADRILLA',
    'notificacionesecuanet@ecuanet.com.ec',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '33'
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
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='CAB_REMITENTE_CORREO_MS'
    ),
    'REMITENTE_CREDENCIAL',
    'defense@netlife.ec',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '18'
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
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='CAB_REMITENTE_CORREO_MS'
    ),
    'REMITENTE_CREDENCIAL',
    'notificacionesecuanet@ecuanet.com.ec',
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '33'
  );
COMMIT;
/