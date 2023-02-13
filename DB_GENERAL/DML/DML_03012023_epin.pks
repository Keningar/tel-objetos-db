INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB (
        ID_PARAMETRO,
        NOMBRE_PARAMETRO,
        DESCRIPCION,
        MODULO,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION
    ) VALUES (
        DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
        'PARAMETROS_FORMULARIO_REGULARIZACION_CLIENTE',
        'PARAMETROS QUE INTERACTUAN CON EL FORMULARIO DE REGULARIZACIÓN DE CLIENTES',
        'COMERCIAL',
        'Activo',
        'epin',
        SYSDATE,
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
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'PARAMETROS_FORMULARIO_REGULARIZACION_CLIENTE' AND ESTADO= 'Activo'),
    'ENVIO_WHATSAPP_REGULARIZACION_CLIENTE',
    'id de las formas de contacto que se pueden elegir en formulario de prospecto',
    'SI',
    'netreg001',
    'https://private.savia-digital.com/attachments/Flower.png',
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
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'PARAMETROS_FORMULARIO_REGULARIZACION_CLIENTE' AND ESTADO= 'Activo'),
    'TIEMPO_VALIDEZ_LINK_REGULARIZACION_CLIENTE',
    'Tiempo de validez de la url',
    '30',
    'Estimado cliente, ud. cuenta con un contrato activo. En caso de requerir modificar su respuesta a la política de tratamiento de datos personales, dirigirse a  <a href="https://www.netlife.ec">www.netlife.ec</a> y descargar el formulario de oposición',
    'Netlife - Consentimiento para envío de información por medios digitales',
    'Activo',
    'ccaguana',
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
     NOMBRE_PARAMETRO= 'PARAMETROS_FORMULARIO_REGULARIZACION_CLIENTE' AND ESTADO= 'Activo'),
    'ESTADOS_SERVICIOS',
    'Estados de servicios no permitidos',
    'Activo,In-Corte',
    'Activo',
    'ccaguana',
     SYSDATE,
    '127.0.0.1',
    '18'
  );


COMMIT;    
