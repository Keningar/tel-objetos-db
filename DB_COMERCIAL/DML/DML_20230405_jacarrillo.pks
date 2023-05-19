/**
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 * @version 1.0
 * @since 04-05-2023  
 * Se crea parametro para regularizacion de firmas
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
    'PARAM_REGULARIZACION_DOCUMENTO_FIRMA',
    'Parametros definidos para consulta de documentos a regularizar firma digital',
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



INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    valor5,
    valor6,
    valor7, 
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,   
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
            nombre_parametro = 'PARAM_REGULARIZACION_DOCUMENTO_FIRMA'
            AND estado = 'Activo'
    ),
    'FILTROS_DOCUMENTO_FIRMA',
    'S',
    'Activo,Pendiente',
    '17/02/2023' ,
    '20/04/2023',   
    '18',
     NULL,
     NULL,
    'Activo',
    'jacarrillo',
     sysdate,
    '127.0.0.1',
    '0',
    'valor1:S para habilitar ejecucion de consulta, valor2:estados de contrato, valor3: fecha desde, valor4: fecha hasta, valor5:cod empresas'
);  
   


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    valor5,
    valor6,
    valor7, 
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,   
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
            nombre_parametro = 'PARAM_REGULARIZACION_DOCUMENTO_FIRMA'
            AND estado = 'Activo'
    ),
    'CRON_START_REGULARIZAR',
    '0 30 23  * * * ',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
     sysdate,
    '127.0.0.1',
    '0',
    'valor1:Patron de configuración de ejecución de cron para arancar regularización de documentos'
);  



INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    valor5,
    valor6,
    valor7, 
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,   
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
            nombre_parametro = 'PARAM_REGULARIZACION_DOCUMENTO_FIRMA'
            AND estado = 'Activo'
    ),
    'CAMBIOS_DOCUMENTO_FIRMA',
    'Invalido',
    'FirmaRegula',
    '',
    '',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
     sysdate,
    '127.0.0.1',
    '0',
    'valor1:estado que se asigna a documento anterior, valor2:nombre de usuario, valor3:texto a remplazar en ruta, valor4 texto nuevo a remplazar en ruta'
);  


COMMIT;
/