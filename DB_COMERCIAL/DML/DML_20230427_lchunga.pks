/**
 * @author Liseth Chunga <lchunga@telconet.ec>
 * @version 1.0
 * @since 27-04-202  
 * Se crea registro en la tabla de parametros para definir el departamento OPU
 */
Insert 
into DB_GENERAL.ADMI_PARAMETRO_DET
(
    ID_PARAMETRO_DET, 
    PARAMETRO_ID, 
    DESCRIPCION, 
    VALOR1, 
    VALOR2, 
    VALOR3, 
    VALOR4, 
    ESTADO, 
    USR_CREACION, 
    FE_CREACION, 
    IP_CREACION, 
    USR_ULT_MOD, 
    FE_ULT_MOD, 
    IP_ULT_MOD, 
    VALOR5, 
    EMPRESA_COD, 
    VALOR6, 
    VALOR7, 
    OBSERVACION
)
values         
(
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'FOTOS_EMPLEADOS_TN'),
    'DPTO_GUARDAR_FOTO_NFS',
    '128',
    NULL,
    NULL,
    NULL,
    'Activo',
    'lchunga',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '10',
    NULL,
    NULL,
    'Parámetro para especificar el departamento al cual se generará url de foto de empleado'
);
commit;