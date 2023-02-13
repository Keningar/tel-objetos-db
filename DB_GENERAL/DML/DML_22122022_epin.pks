/*
 * Se realiza ingresos de registros necesarios para la aplicación 'Gestión de Licitación'.
 * @author Edgar Pin Villavicencio <epin@telconet.ec>
 * @version 1.0 - 22-12-2022
 */
    
INSERT INTO db_general.admi_parametro_cab (
    id_parametro,
    nombre_parametro,
    descripcion,
    modulo,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion
) VALUES (
    db_general.seq_admi_parametro_cab.nextval,
    'FORMAS_CONTACTO_FORMULARIO_REGULARIZACION_CLIENTE',
    'FORMAS DE CONTACTO ',
    'COMERCIAL',
    'Activo',
    'epin',
    sysdate,
    '127.0.0.1'
);



INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    OBSERVACION,
    VALOR1,
    VALOR2,
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
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'FORMAS_CONTACTO_FORMULARIO_REGULARIZACION_CLIENTE' AND ESTADO= 'Activo'),
    'Correo Electrónico',
    'Forma de contacto correo electrónico',
     '5',
    '1',
    'Activo',
    'epin',
     SYSDATE,
    '127.0.0.1',
    '18'
  );
   




INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    OBSERVACION,
    VALOR1,
    VALOR2,
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
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'FORMAS_CONTACTO_FORMULARIO_REGULARIZACION_CLIENTE' AND ESTADO= 'Activo'),
    'Teléfono Movil Claro',
    'Teléfono Movil Claro',
    '25',
    '1',
    'Activo',
    'epin',
     SYSDATE,
    '127.0.0.1',
    '18'
  );
   



INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    OBSERVACION,
    VALOR1,
    VALOR2,
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
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'FORMAS_CONTACTO_FORMULARIO_REGULARIZACION_CLIENTE' AND ESTADO= 'Activo'),
    'Teléfono Movil Movistar',
    'Teléfono Movil Movistar',
    '26',
    '1',
    'Activo',
    'epin',
     SYSDATE,
    '127.0.0.1',
    '18'
  );
   



INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    OBSERVACION,
    VALOR1,
    VALOR2,
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
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'FORMAS_CONTACTO_FORMULARIO_REGULARIZACION_CLIENTE' AND ESTADO= 'Activo'),
    'Teléfono Movil CNT',
    'Teléfono Movil CNT',
    '27',
    '1',
    'Activo',
    'epin',
     SYSDATE,
    '127.0.0.1',
    '18'
  );
   

COMMIT;
/