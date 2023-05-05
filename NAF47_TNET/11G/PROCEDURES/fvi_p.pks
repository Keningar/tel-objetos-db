CREATE OR REPLACE PROCEDURE fvi_p (
    p_c1 VARCHAR2,
    p_c2 VARCHAR2 DEFAULT NULL
) IS
    PRAGMA autonomous_transaction;
BEGIN
    INSERT INTO fvi VALUES (
        p_c1,
        p_c2
    );

    COMMIT;
END;