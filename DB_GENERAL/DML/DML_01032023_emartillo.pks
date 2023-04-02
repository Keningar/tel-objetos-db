/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Insert de las banderas para que tome progreso porcentaje  para la empresa ecuanet.
 * Insert para que el producto internet dedicado siga el flujo de MD para ecuanet.
 * @author Emmanuel Martillo<emartillo@telconet.ec>
 * @version 1.0 01-03-2023 - Versión Inicial.
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
OBSERVACION
)
values         
(
                DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
                (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='IDS_PROGRESOS_TAREAS'),
                'IDs de progresos de materiales para tareas de soporte EN',
                'PROG_SOPORTE_EN_MATERIALES',
    ((SELECT IPP.ID_PROGRESO_PORCENTAJE FROM DB_SOPORTE.INFO_PROGRESO_PORCENTAJE IPP
        WHERE IPP.ORDEN = '4' AND IPP.EMPRESA_ID= '33') ||','|| ( SELECT IPP.ID_PROGRESO_PORCENTAJE FROM DB_SOPORTE.INFO_PROGRESO_PORCENTAJE IPP
        WHERE IPP.ORDEN = '7' AND IPP.EMPRESA_ID= '33')),
    NULL,
    NULL,
    'Activo',
    'emartillo',
    SYSDATE,
    '127.0.0.1',
    'Se crea parametro para que Ecuanet pueda seguir el flujo de Megadatos'
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
OBSERVACION
)
values         
(
                DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
                (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='IDS_PROGRESOS_TAREAS'),
                'IDs de progresos de fibra para tareas de soporte EN',
                'PROG_SOPORTE_EN_FIBRA',
    ((SELECT IPP.ID_PROGRESO_PORCENTAJE FROM DB_SOPORTE.INFO_PROGRESO_PORCENTAJE IPP
        WHERE IPP.ORDEN = '6' AND IPP.EMPRESA_ID= '33'
        AND TAREA_ID = '-1') ||','|| ( SELECT IPP.ID_PROGRESO_PORCENTAJE FROM DB_SOPORTE.INFO_PROGRESO_PORCENTAJE IPP
        WHERE IPP.ORDEN = '8' AND IPP.EMPRESA_ID= '33')),
    NULL,
    NULL,
    'Activo',
    'emartillo',
    SYSDATE,
    '127.0.0.1',
    'Se crea parametro para que Ecuanet pueda seguir el flujo de Megadatos'
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
OBSERVACION
)
values         
(
                DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
                (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='IDS_PROGRESOS_TAREAS'),
                'IDs de progresos de materiales para tareas de instalación EN',
                'PROG_INSTALACION_EN_FIBRA',
        (select ID_PROGRESO_PORCENTAJE from DB_SOPORTE.INFO_PROGRESO_PORCENTAJE where TIPO_PROGRESO_ID = 19 AND ORDEN = 11 AND EMPRESA_ID =33),
    NULL,
    NULL,
    'Activo',
    'emartillo',
    SYSDATE,
    '127.0.0.1',
    'Se crea parametro para que Ecuanet pueda seguir el flujo de Megadatos'
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
OBSERVACION
)
values         
(
                DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
                (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='IDS_PROGRESOS_TAREAS'),
                'IDs de progresos de materiales para tareas de instalación EN',
                'PROG_INSTALACION_EN_MATERIALES',
    (select ID_PROGRESO_PORCENTAJE from DB_SOPORTE.INFO_PROGRESO_PORCENTAJE where TIPO_PROGRESO_ID = 5 AND ORDEN = 6 AND EMPRESA_ID =33),
    NULL,
    NULL,
    'Activo',
    'emartillo',
    SYSDATE,
    '127.0.0.1',
    'Se crea parametro para que Ecuanet pueda seguir el flujo de Megadatos'
);


INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID ,
    DESCRIPCION ,
    VALOR1 ,
    VALOR2 ,
    VALOR3 ,
    VALOR4 ,
    ESTADO ,
    USR_CREACION ,
    FE_CREACION ,
    IP_CREACION ,
    USR_ULT_MOD ,
    FE_ULT_MOD ,
    IP_ULT_MOD ,
    OBSERVACION  
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
    WHERE NOMBRE_PARAMETRO = 'EMPRESA_EQUIVALENTE'
    ),
    'EN Y FIBRA RETORNA EN',
    'EN',
    'FO',
    'MD',
    '',
    'Activo',
    'emartillo',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL, 
    NULL,
    'Se ingresa flujo de MD para EN para que siga el flujo principal'
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
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE NOMBRE_PARAMETRO='PARAMETROS_ASOCIADOS_A_SERVICIOS_EN'),
    'Estados de los servicios parametrizados para permitir un traslado en EN',
    'TRASLADO',
    'ESTADOS_SERVICIOS_PERMITIDOS',
    'Activo',
    NULL,
    NULL,
    'Activo',
    'emartillo',
    SYSDATE,
    '127.0.0.1',
    '33'
  );

COMMIT;
/