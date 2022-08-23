    /*
    * Se realiza ingresos de registros necesarios para la aplicación 'Gestión de Licitación'.
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 - 25-06-2022
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
        'LOGIN_X_PEDIDO_PARAM_INI',
        'PARAMETROS AUXILIARES QUE INTERACTUAN CON LA APLICACION GESTION DE LICITACION',
        'COMERCIAL',
        'Activo',
        'kbaque',
        SYSDATE,
        '127.0.0.1'
    );

    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (
        ID_PARAMETRO_DET,
        PARAMETRO_ID,
        DESCRIPCION,
        VALOR1,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        EMPRESA_COD,
        OBSERVACION
    ) VALUES (
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
                AND ESTADO = 'Activo'
        ),
        'ROLES_ACCIONES',
        '[{"rol":"bossRole","cargosAsociados":[{"cargo":"Jefe Dpto Nacional"},{"cargo":"Jefe Departamental"}],"accionesPermitidas":[{"opcion":"Visualizar_Tender"},{"opcion":"Visualizar_Dashboard"},{"opcion":"Asignar"},{"opcion":"Editar_Tender_Categorizado"},{"opcion":"Editar_Tender_Sin_Categorizar"},{"opcion":"Enviar_Tender"},{"opcion":"Revision_Tender"}]},{"rol":"employeeRole","cargosAsociados":[{"cargo":"Asistente de Compras"},{"cargo":"Ayudante Compras"}],"accionesPermitidas":[{"opcion":"Visualizar_Tender"},{"opcion":"Visualizar_Dashboard"},{"opcion":"Editar_Tender_Categorizado"},{"opcion":"Enviar_Tender"},{"opcion":"Revision_Tender"},{"opcion":"Visualizar_Tender_Asignados"}]}]',
        'Activo',
        'kbaque',
        SYSDATE,
        '127.0.0.1',
        10,
        'VALOR1= JSON QUE CONTIENE LOS ROLES ASOCIADOS AL CARGO'
    );

    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (
        ID_PARAMETRO_DET,
        PARAMETRO_ID,
        DESCRIPCION,
        VALOR1,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        EMPRESA_COD,
        OBSERVACION
    ) VALUES (
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
                AND ESTADO = 'Activo'
        ),
        'CAMBIOS_ESTADOS_PERMITIDOS',
        '[{"currentStatus":"Expirado","allowedStatus":[{"status":"Cancelado"}]}]',
        'Activo',
        'kbaque',
        SYSDATE,
        '127.0.0.1',
        10,
        'VALOR1= JSON QUE CONTIENE LOS ESTADOS PERMITIDOS'
    );

    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (
        ID_PARAMETRO_DET,
        PARAMETRO_ID,
        DESCRIPCION,
        VALOR1,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        EMPRESA_COD,
        OBSERVACION
    ) VALUES (
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
                AND ESTADO = 'Activo'
        ),
        'ESTADOS_CONSULTA_DEDFAULT',
        '[{"estado":"Pendiente"},{"estado":"Enviado"},{"estado":"Expirado"}]',
        'Activo',
        'kbaque',
        SYSDATE,
        '127.0.0.1',
        10,
        'VALOR1= JSON QUE CONTIENE LOS ESTADOS QUE CARGAN LOS TENDER POR DEFECTO'
    );

    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (
        ID_PARAMETRO_DET,
        PARAMETRO_ID,
        DESCRIPCION,
        VALOR1,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        EMPRESA_COD,
        OBSERVACION
    ) VALUES (
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
                AND ESTADO = 'Activo'
        ),
        'CONSTANTES_PUBLICACION',
        '{"paymentMethod":"UNIT","tenderStatus":"PUBLICADA","fixedPrice":"true"}',
        'Activo',
        'kbaque',
        SYSDATE,
        '127.0.0.1',
        10,
        'VALOR1= JSON QUE CONTIENE LAS CONSTANTES'
    );

    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (
        ID_PARAMETRO_DET,
        PARAMETRO_ID,
        DESCRIPCION,
        VALOR1,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        EMPRESA_COD,
        OBSERVACION
    ) VALUES (
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
                AND ESTADO = 'Activo'
        ),
        'URL_IMAGEN_TENDER',
        'https://ktask.pro/document/visor/CATALOG/c7e9825d-055e-49a6-98c1-08040e3e437f.png',
        'Activo',
        'kbaque',
        SYSDATE,
        '127.0.0.1',
        10,
        'VALOR1= URL DE LA IMAGEN A PUBLICAR'
    );

    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (
        ID_PARAMETRO_DET,
        PARAMETRO_ID,
        DESCRIPCION,
        VALOR1,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        EMPRESA_COD,
        OBSERVACION
    ) VALUES (
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
                AND ESTADO = 'Activo'
        ),
        'INTERVALO_CONSULTAS_DEFAULT',
        '{"diasInervaloConsultas":"15","limiteRegistrosConsulta":"50"}',
        'Activo',
        'kbaque',
        SYSDATE,
        '127.0.0.1',
        10,
        'VALOR1= JSON QUE CONTIENE LOS INTERVALOS PARA CONSULTAR LOS TENDER'
    );

    INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (
        ID_PARAMETRO_DET,
        PARAMETRO_ID,
        DESCRIPCION,
        VALOR1,
        ESTADO,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION,
        EMPRESA_COD,
        OBSERVACION
    ) VALUES (
        DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
        (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                    NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
                AND ESTADO = 'Activo'
        ),
        'BANDERA_RECURRENTES',
        'NO_PERMITIDO',
        'Activo',
        'kbaque',
        SYSDATE,
        '127.0.0.1',
        10,
        'VALOR1= BANDERA QUE PERMITE AGRUPAR LOS RECURRENTES'
    );

    COMMIT;
    /