 /**
 * Parámetros de la administracion de politicas y clausulas
 * Y se realiza ingresos de registros necesarios para la aplicación 'Gestión de Licitación'.
 *
 * @author Miguel Guzman <mguzman@telconet.ec>
 *
 * @version 1.0
 */

 
INSERT  INTO DB_GENERAL.ADMI_PARAMETRO_DET
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
      AND estado = 'Activo'
    ),
    'NOMBRES_RESPUESTA_UNICA',
    'SI,NO',
    NULL,
    NULL,
    NULL,
    NULL,
    'Nombres de respuesta a seleccionar en Check único',
    'Activo',
    'mguzman',
    SYSDATE,
    '127.0.0.1',
    '33'
  );
     
  
COMMIT;
/