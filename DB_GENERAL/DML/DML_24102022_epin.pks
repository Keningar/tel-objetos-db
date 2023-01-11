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
        'PARAMETROS_FORMULARIO_ACEPTACION_PROSPECTO',
        'PARAMETROS QUE INTERACTUAN CON EL FORMULARIO DE ACEPTACION DE PROSPECTO',
        'COMERCIAL',
        'Activo',
        'epin',
        SYSDATE,
        '127.0.0.1'
    );
    

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
VALUES (        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'PARAMETROS_FORMULARIO_ACEPTACION_PROSPECTO'
                AND ESTADO = 'Activo'
        ), 'ENVIO_WHATSAPP','SI', 'netreg001', 'https://private.savia-digital.com/attachments/Flower.png', null, 'Activo', 'epin', sysdate, '127.0.0.1', null, null, null, null, '18', null, null, 'id de las formas de contacto que se pueden elegir en formulario de prospecto'
);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
VALUES (        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'PARAMETROS_FORMULARIO_ACEPTACION_PROSPECTO'
                AND ESTADO = 'Activo'
        ), 'TIEMPO_VALIDEZ_LINK','30', 'Estimado cliente, ud. cuenta con un contrato activo. En caso de requerir modificar su respuesta a la política de tratamiento de datos personales, dirigirse a  <a href="https://www.netlife.ec">www.netlife.ec</a> y descargar el formulario de oposición'
        , 'Consentimiento para envío de información por medios digitales', null, 'Activo', 'epin', sysdate, '127.0.0.1', null, null, null, null, '18', null, null, 'Tiempo de validez de la url'
);



COMMIT;    



