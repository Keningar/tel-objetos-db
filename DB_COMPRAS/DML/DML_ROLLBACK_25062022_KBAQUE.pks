    /*
    * Rollback del DML (DML_25062022_KBAQUE.pks)
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 - 25-06-2022
    */
    UPDATE DB_COMPRAS.ADMI_PARAMETRO
    SET
        VALOR = 'Ingresado',
        USR_ULT_MOD = 'kbaque',
        FE_ULT_MOD = SYSDATE
    WHERE
        CODIGO = 'PED-AUT-ESTADO-INICIAL';
    COMMIT;
    /