/**
 * Documentación para crear parámetros
 * Parámetros de creación en DB_GENERAL.ADMI_PARAMETRO_CAB 
 * y DB_GENERAL.ADMI_PARAMATRO_DET.
 *
 * @author Steven Ruano <sruano@telconet.ec>
 * @version 1.0 03-05-2023
 *
 */
 
SET SERVEROUTPUT ON

--INSERT PARAMETRO PARA LISTADO_PRODUCTOS_IP_ADICIONALES
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
(
        ID_PARAMETRO,
        NOMBRE_PARAMETRO,
        DESCRIPCION,
        MODULO,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION
)
VALUES
(
        DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
        'VALIDACION_CANTON_ID_CAJAS',
        'Validacion de bandera para filtrar las cajas por canton id',
        'TECNICO',
        'Activo',
        'sruano',
        SYSDATE,
        '127.0.0.1'
);


-- INGRESO LOS DETALLES DE LA CABECERA 'VALIDACION_CANTON_ID_CAJAS'
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
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
        EMPRESA_COD,
        VALOR7
)
VALUES
(
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT ID_PARAMETRO
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE NOMBRE_PARAMETRO = 'VALIDACION_CANTON_ID_CAJAS'
            AND ESTADO = 'Activo'
        ),
        'BANDERA_VALIDACION_CANTON_ID_CAJAS',
        'SI',
        Null,
        NULL,
        NULL,
        'Activo',
        'sruano',
        SYSDATE,
        '127.0.0.1',
        NULL,
        NULL
        );

COMMIT;
/
