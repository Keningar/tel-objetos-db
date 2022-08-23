    /*
    * Se realiza ingresos y actualizaciones de registros necesarios para la aplicación 'Gestión de Licitación'.
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 - 25-06-2022
    */
    --Ingresamos desde donde se va a empezar agregar los artículos a los tender.
    INSERT INTO DB_COMPRAS.INFO_TENDER_EXEC (
        ID_TENDER_EXEC,
        SOLICITUD_ID,
        ESTADO_EJECUCION,
        FE_EJECUCION_INI
    ) VALUES (
        DB_COMPRAS.SEQ_INFO_TENDER_EXEC.NEXTVAL,
        (
            SELECT
                MAX(ID_SOLICITUD)
            FROM
                DB_COMPRAS.INFO_SOLICITUD
        ),
        'Finalizado',
        SYSDATE
    );
    --Actualizamos el estado inicial de los pedidos automáticos.
    UPDATE DB_COMPRAS.ADMI_PARAMETRO
    SET
        VALOR = 'Autorizado',
        USR_ULT_MOD = 'kbaque',
        FE_ULT_MOD = SYSDATE
    WHERE
        CODIGO = 'PED-AUT-ESTADO-INICIAL';
    COMMIT;
    /