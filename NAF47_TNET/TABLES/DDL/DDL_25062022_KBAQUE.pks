    CREATE TABLE NAF47_TNET.ARIN_CATALOGO_KATUK_CAB (
        ID_CATALOGO        NUMBER(19, 0)
            NOT NULL ENABLE,
        NOMBRE             VARCHAR2(100)
            NOT NULL ENABLE,
        NIVEL              NUMBER
            NOT NULL ENABLE,
        TIPO               VARCHAR2(100)
            NOT NULL ENABLE,
        CODIGO             VARCHAR2(100)
            NOT NULL ENABLE,
        ESTADO             VARCHAR2(1) DEFAULT 'A'
            NOT NULL ENABLE,
        FECHA_CREACION     DATE DEFAULT SYSDATE
            NOT NULL ENABLE,
        USUARIO_CREACION   VARCHAR2(50),
        FECHA_ACTUALIZA    DATE,
        USUARIO_ACTUALIZA  VARCHAR2(50),
        CONSTRAINT ARIN_CATALOGO_KATUK_CAB_PK PRIMARY KEY ( "ID_CATALOGO" )
    );

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB.ID_CATALOGO IS
        'Id secuencial';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB.NOMBRE IS
        'Nombre de catalogo';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB.NIVEL IS
        'Nivel a que pertenece el catalogo';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB.TIPO IS
        'tipo de catalogo';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB.CODIGO IS
        'Codigo de catalogo';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB.ESTADO IS
        'Estado A Activo, I Inanctivo';

    CREATE SEQUENCE NAF47_TNET.SEQ_ARIN_CATALOGO_KATUK_CAB MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH
    1 NOCACHE ORDER NOCYCLE;


    CREATE TABLE NAF47_TNET.ARIN_CATALOGO_KATUK_DET (
        ID_CATALOGO_DET    NUMBER(19, 0)
            NOT NULL ENABLE,
        NOMBRE             VARCHAR2(100)
            NOT NULL ENABLE,
        NIVEL              NUMBER
            NOT NULL ENABLE,
        TIPO               VARCHAR2(100)
            NOT NULL ENABLE,
        CODIGO             VARCHAR2(100)
            NOT NULL ENABLE,
        CATALOGO_ID        NUMBER(19, 0),
        ESTADO             VARCHAR2(1) DEFAULT 'A'
            NOT NULL ENABLE,
        FECHA_CREACION     DATE DEFAULT SYSDATE
            NOT NULL ENABLE,
        USUARIO_CREACION   VARCHAR2(50),
        FECHA_ACTUALIZA    DATE,
        USUARIO_ACTUALIZA  VARCHAR2(50),
        CONSTRAINT ARIN_CATALOGO_KATUK_DET PRIMARY KEY ( "ID_CATALOGO_DET" )
    );

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_DET.ID_CATALOGO_DET IS
        'Id secuencial';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_DET.NOMBRE IS
        'Nombre de catalogo';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_DET.NIVEL IS
        'Nivel a que pertenece el catalogo';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_DET.TIPO IS
        'tipo de catalogo';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_DET.CODIGO IS
        'Codigo de catalogo';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_DET.CATALOGO_ID IS
        'Codigo de catalogo padre a que hace referencia';

    COMMENT ON COLUMN NAF47_TNET.ARIN_CATALOGO_KATUK_DET.ESTADO IS
        'Estado A Activo, I Inanctivo';

    CREATE SEQUENCE NAF47_TNET.SEQ_ARIN_CATALOGO_KATUK_DET MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH
    1 NOCACHE ORDER NOCYCLE;

    ALTER TABLE NAF47_TNET.ARINDA ADD (
        CATALOGO_ID_DET NUMBER(19, 0) DEFAULT 1
    );

    COMMENT ON COLUMN NAF47_TNET.ARINDA.CATALOGO_ID_DET IS
        'Codigo de catalago detalle Katuk en NAF';

    COMMIT;
    /