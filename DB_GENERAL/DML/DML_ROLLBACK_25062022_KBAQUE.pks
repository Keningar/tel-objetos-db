    /*
    * Rollback del DML (DML_25062022_KBAQUE.pks)
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 - 25-06-2022
    */
    --Eliminamos el detalle de los parametros.
    DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
    WHERE
        PARAMETRO_ID = (
            SELECT
                ID_PARAMETRO
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE
                NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
        );

    --Eliminamos la cabecera.
    DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE
            NOMBRE_PARAMETRO = 'LOGIN_X_PEDIDO_PARAM_INI'
        AND USR_CREACION = 'kbaque';

    COMMIT;
    /