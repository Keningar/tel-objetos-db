/**
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 * @version 1.0
 * @since 04-14-2022  
 * Se crea parametro para validar proveedor
 */
SET DEFINE OFF; 
 

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
    'PROVEEDOR_EMPRESA',
    'S',
    '18',
    'flujo de prospectos',
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    '',
    NULL,
    NULL,
    NULL,
    'valor1:empresa por default, valor2: bandera que valida proveedores, valor3: nombre de documento'
);  
   

COMMIT;
/