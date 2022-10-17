    /*
    * Rollback del DML (DML_25062022_KBAQUE.pks)
    * @author Kevin Baque Puya <kbaque@telconet.ec>
    * @version 1.0 - 25-06-2022
    */
    UPDATE NAF47_TNET.ARINDA
    SET
        CATALOGO_ID_DET = ''
    WHERE
        NO_CIA = 10;

    COMMIT;
    /