
/**
 * Parametros para ley organica
 * Parametros para el catalogo movil Comercial
 * @author Carlos Caguana<jbroncano@telconet.ec>
 */


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
        'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL',
        'PARAMETROS QUE INTERACTUAN CON LOS FORMULARIOS',
        'COMERCIAL',
        'Activo',
        'ccaguana',
        SYSDATE,
        '127.0.0.1'
    );




 INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 

) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'ENVIO_WHATSAPP',
    'SI',
    'netreg001',
    'https://private.savia-digital.com/attachments/Flower.png',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    18,
    'Parametros para envio de whatsApp'
);  



 INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 

) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'ENVIO_WHATSAPP',
    'NO',
    'netreg001',
    'https://private.savia-digital.com/attachments/Flower.png',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    33,
    'Parametros para envio de whatsApp'
);  
   



 INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'TIEMPO_VALIDEZ_LINK',
    '30',
    'Estimado cliente, ud. cuenta con un contrato activo. En caso de requerir modificar su respuesta a la política de tratamiento de datos personales, dirigirse a  <a href="https://www.netlife.ec">www.netlife.ec</a> y descargar el formulario de oposición',
    'Consentimiento para envío de información por medios digitales',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    'https://extranet.netlife.ec/g8yekxafktxdjsu296m/dphx8r9bc/p4x2kwuw/prospecto/',
    NULL,
    18,
    'Tiempo de validez de la url'
);  
   



 INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'TIEMPO_VALIDEZ_LINK',
    '30',
    'Estimado cliente, ud. cuenta con un contrato activo. En caso de requerir modificar su respuesta a la política de tratamiento de datos personales, dirigirse a  <a href="https://www.netlife.ec">www.netlife.ec</a> y descargar el formulario de oposición',
    'Consentimiento para envío de información por medios digitales',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    'https://extranet.netlife.ec/g8yekxafktxdjsu296m/dphx8r9bc/p4x2kwuw/prospecto/',
    NULL,
    33,
    'Tiempo de validez de la url'
);  



INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'NOMBRE_DOCUMENTO',
    'flujo de prospectos',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    18,
    'Nombre del documento'
);  
   


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'NOMBRE_DOCUMENTO',
    'flujo de prospectos',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    33,
    'Nombre del documento'
);  
  


 INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 

) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'ENVIO_WHATSAPP',
    'NO',
    'netreg001',
    'https://private.savia-digital.com/attachments/Flower.png',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Parametros para envio de whatsApp'
);  
   


 INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 

) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'ENVIO_WHATSAPP',
    'SI',
    'netreg001',
    'https://private.savia-digital.com/attachments/Flower.png',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Parametros para envio de whatsApp'
);  



INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'TIEMPO_VALIDEZ_LINK',
    '30',
    'Estimado cliente, ud. cuenta con un contrato activo. En caso de requerir modificar su respuesta a la política de tratamiento de datos personales, dirigirse a  <a href="https://www.ecuanet.ec">www.ecuanet.ec</a> y descargar el formulario de oposición',
    'Ecuanet - Consentimiento para envío de información por medios digitales',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    'https://extranet.netlife.ec/g8yekxafktxdjsu296m/dphx8r9bc/p4x2kwuw/regularizacion-cliente/',
    NULL,
    33,
    'Tiempo de validez de la url'
); 


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'TIEMPO_VALIDEZ_LINK',
    '30',
    'Estimado cliente, ud. cuenta con un contrato activo. En caso de requerir modificar su respuesta a la política de tratamiento de datos personales, dirigirse a  <a href="https://www.ecuanet.ec">www.ecuanet.ec</a> y descargar el formulario de oposición',
    'Ecuanet - Consentimiento para envío de información por medios digitales',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    'https://extranet.netlife.ec/g8yekxafktxdjsu296m/dphx8r9bc/p4x2kwuw/regularizacion-cliente/',
    NULL,
    18,
    'Tiempo de validez de la url'
); 


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'ESTADOS_SERVICIOS',
    'Activo,In-Corte',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Estados de servicios no permitidos'
);  


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'ESTADOS_SERVICIOS',
    'Activo,In-Corte',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Estados de servicios no permitidos'
);  



INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'NOMBRE_DOCUMENTO',
    'regularización de clientes',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Nombre del documento'
);  


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'NOMBRE_DOCUMENTO',
    'regularización de clientes',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Nombre del documento'
);  


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'PLANTILLA_CORREO',
    'REGULARIZA_CLI',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    18,
    'Plantilla del correo'
);  



INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'PLANTILLA_CORREO',
    'REGULARIZA_CLI',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'regularización de clientes',
    NULL,
    NULL,
    33,
    'Plantilla del correo'
);  



INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'PLANTILLA_CORREO',
    'PROSPECTO_INFOR',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    18,
    'Plantilla del correo'
);  


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    valor6,
    valor7,
    empresa_cod,
    OBSERVACION 
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
            AND estado = 'Activo'
    ),
    'PLANTILLA_CORREO',
    'PROSPECTO_INFOR',
    '',
    '',
    NULL,
    'Activo',
    'ccaguana',
    sysdate,
    '127.0.0.1',
    'flujo de prospectos',
    NULL,
    NULL,
    33,
    'Plantilla del correo'
);  

/

commit;
