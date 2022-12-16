           
 /**
 * Parámetros de la administracion de politicas y clausulas
 *
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 *
 * @version 1.0
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
    'ADMIN_POLITICAS_CLAUSULAS',
    'PARAMETROS PARA CONFIGURACION DE ADMINISTRACION DE POLITICAS Y CLAUSULAS',
    'COMERCIAL',
    'Activo',
    'jacarrillo',
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
    OBSERVACION, 
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
      WHERE NOMBRE_PARAMETRO='ADMIN_POLITICAS_CLAUSULAS'
    ),
    'NOMBRES_RESPUESTA_UNICA',
    'SI,NO',
    NULL,
    NULL,
    NULL,
    NULL,
    'Nombres de respuesta a seleccionar en Check único',
    'Activo',
    'jacarrillo',
    SYSDATE,
    '127.0.0.1',
    '18'
  );
        
COMMIT;
/