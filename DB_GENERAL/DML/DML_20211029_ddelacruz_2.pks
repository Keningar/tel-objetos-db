/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear cabecera y detalle de parametros para microservicios del esquema SOPORTE
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 
 * @since 29-10-2021 - Versión Inicial.
 */

Insert 
into DB_GENERAL.ADMI_PARAMETRO_CAB
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
values         
(
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'MS_CORE_SOPORTE',
    'Parametros utilizados para microservicios que se encuentren dentro del esquema SOPORTE',
    'SOPORTE',
    null,
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    null,
    null,
    null
);

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
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'MS_CORE_SOPORTE'),
    'DIAS_DEFAULT_PARA_CONSULTAR_CASOS',
    '30',
    NULL,
    NULL,
    NULL,
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '10',
    NULL,
    NULL,
    'Parámetro de días para restar a la fecha actual, utilizado cuando al consultar los casos, no ingresan fecha de apertura, id o numero del caso'
);

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
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'MS_CORE_SOPORTE'),
    'DIAS_DEFAULT_PARA_CONSULTAR_TAREAS',
    '30',
    NULL,
    NULL,
    NULL,
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '10',
    NULL,
    NULL,
    'Parámetro de días para restar a la fecha actual, utilizado cuando al consultar las tareas, no ingresan fecha de creacion, id detalle o numero de la tarea'
);

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
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'MS_CORE_SOPORTE'),
    'TS_TECNICO',
    'IPCCL1',
    '132',
    '594591',
    '237805',
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '3473',
    '10',
    '727',
    'Jefe Dpto Nacional - JAIME ADRIAN BONILLA FERNANDEZ',
    'Identifica a quien se asignará el caso técnico, cuando se crea un Requerimiento desde la extranet.
    Valor1=NombreDepartamento, Valor2=IdDepartamento, Valor3:IdPersonaEmpresaRol, Valor4:IdPersona, Valor5:IdEmpresaRol, Valor6:IdRol
    Valor7=Descripcion'
);

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
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'MS_CORE_SOPORTE'),
    'TS_FACTURACION',
    'Contabilidad Facturacion',
    '679',
    '1523441',
    '283428',
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '2461',
    '10',
    '582',
    'Jefe Facturación Nacional - ELVIA YESSENIA	ALVARIO CHICAIZA',
    'Identifica a quien se asignará la tarea, cuando se crea un Requerimiento desde la extranet, para tareas de facturación.
    Valor1=NombreDepartamento, Valor2=IdDepartamento, Valor3:IdPersonaEmpresaRol, Valor4:IdPersona, Valor5:IdEmpresaRol, Valor6:IdRol
    Valor7=Descripcion'
);


Insert 
into DB_GENERAL.ADMI_PARAMETRO_CAB
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
values         
(
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'MS_CORE_FINANCIERO',
    'Parametros utilizados para microservicios que se encuentren dentro del esquema FINANCIERO',
    'FINANCIERO',
    null,
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    null,
    null,
    null
);

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
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'MS_CORE_FINANCIERO'),
    'DIAS_DEFAULT_PARA_CONSULTAR_FACTURAS',
    '30',
    NULL,
    NULL,
    NULL,
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '10',
    NULL,
    NULL,
    'Parámetro de días para restar a la fecha actual, utilizado cuando al consultar las facturas, no ingresan fecha de emision'
);

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
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'MS_CORE_SOPORTE'),
    'ID_HIPOTESIS_GENERAL',
    '1742',
    NULL,
    NULL,
    NULL,
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '10',
    NULL,
    NULL,
    'Identificador de la hipotesis general que se utilizará para crear casos desde Extranet'
);

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
    (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'MS_CORE_SOPORTE'),
    'TIEMPO_MIN_CONSULTAR_CASOS_EXTRANET',
    '1',
    NULL,
    NULL,
    NULL,
    'Activo',
    'ddelacruz',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '10',
    NULL,
    NULL,
    'Tiempo en minutos en que se consultan los casos de extranet para visualizarlos en la parte superior derecha de Telcos'
);

COMMIT;

/
