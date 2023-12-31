CREATE TABLE NAF47_TNET.ADMI_TIPO_SANCION (
    ID_TIPO_SANCION   NUMBER NOT NULL,
    TIPO_SANCION      VARCHAR2(100),
    ESTADO            VARCHAR2(15),
    COD_EMPRESA       VARCHAR2(3),
    USR_CREACION      VARCHAR2(15) NOT NULL,
    IP_CREACION       VARCHAR2(15) NOT NULL,
    FE_CREACION       TIMESTAMP(6) NOT NULL,
    USR_ULT_MOD       VARCHAR2(15),
    IP_ULT_MOD        VARCHAR2(15),
    FE_ULT_MOD        TIMESTAMP(6)
);
ALTER TABLE NAF47_TNET.ADMI_TIPO_SANCION ADD CONSTRAINT PK_ADMI_TIPO_SANCION PRIMARY KEY (ID_TIPO_SANCION);

CREATE SEQUENCE NAF47_TNET.SEQ_ADMI_TIPO_SANCION MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1;

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.ID_TIPO_SANCION IS
    'ID SECUENCIAL DE LA TABLA';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.TIPO_SANCION IS
    'VALOR DEL TIPO DE SANCION';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.ESTADO IS
    'ESTADO DEL TIPO DE SANCION';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.COD_EMPRESA IS
    'CODIGO DE EMPRESA A LA QUE PERTENECE EL TIPO DE SANCION';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.FE_CREACION IS
    'FECHA DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.USR_CREACION IS
    'USUARIO DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.IP_CREACION IS
    'IP DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.FE_ULT_MOD IS
    'FECHA DE ÚLTIMA MODIFICACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.USR_ULT_MOD IS
    'USUARIO DE ÚLTIMA MODIFICACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_SANCION.IP_ULT_MOD IS
    'IP ÚLTIMA MODIFICACIÓN';

CREATE TABLE NAF47_TNET.ADMI_HALLAZGO (
    ID_HALLAZGO       NUMBER NOT NULL,
    TIPO_SANCION_ID   NUMBER,
    HALLAZGO          VARCHAR2(200),
    DEPARTAMENTO      VARCHAR2(100),
    ESTADO            VARCHAR2(15),
    COD_EMPRESA       VARCHAR2(3),
    USR_CREACION      VARCHAR2(15) NOT NULL,
    IP_CREACION       VARCHAR2(15) NOT NULL,
    FE_CREACION       TIMESTAMP(6) NOT NULL,
    USR_ULT_MOD       VARCHAR2(15),
    IP_ULT_MOD        VARCHAR2(15),
    FE_ULT_MOD        TIMESTAMP(6)
);

ALTER TABLE NAF47_TNET.ADMI_HALLAZGO ADD CONSTRAINT PK_ADMI_HALLAZGO PRIMARY KEY (ID_HALLAZGO);

CREATE SEQUENCE NAF47_TNET.SEQ_ADMI_HALLAZGO MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1;

ALTER TABLE NAF47_TNET.ADMI_HALLAZGO ADD CONSTRAINT FK_ADMI_HALLAZGO_SANCION FOREIGN KEY (TIPO_SANCION_ID)
    REFERENCES NAF47_TNET.ADMI_TIPO_SANCION(ID_TIPO_SANCION);

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.ID_HALLAZGO IS
    'ID SECUENCIAL DE LA TABLA';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.TIPO_SANCION_ID IS
    'REFERENCIAL DE LA TABLA ADMI_TIPO_SANCION';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.HALLAZGO IS
    'VALOR DEL HALLAZGO';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.DEPARTAMENTO IS
    'DEPARTAMENTO DEL HALLAZGO';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.ESTADO IS
    'ESTADO DEL HALLAZGO';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.COD_EMPRESA IS
    'CODIGO DE EMPRESA A LA QUE PERTENECE EL HALLAZGO';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.FE_CREACION IS
    'FECHA DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.USR_CREACION IS
    'USUARIO DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.IP_CREACION IS
    'IP DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.FE_ULT_MOD IS
    'FECHA DE ÚLTIMA MODIFICACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.USR_ULT_MOD IS
    'USUARIO DE ÚLTIMA MODIFICACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_HALLAZGO.IP_ULT_MOD IS
    'IP ÚLTIMA MODIFICACIÓN';

CREATE TABLE NAF47_TNET.ADMI_TIPO_DOCUMENTO (
    ID_TIPO_DOCUMENTO NUMBER NOT NULL,
    TIPO_DOCUMENTO    VARCHAR2(100),
    ESTADO            VARCHAR2(15),
    COD_EMPRESA       VARCHAR2(3),
    USR_CREACION      VARCHAR2(15) NOT NULL,
    IP_CREACION       VARCHAR2(15) NOT NULL,
    FE_CREACION       TIMESTAMP(6) NOT NULL,
    USR_ULT_MOD       VARCHAR2(15),
    IP_ULT_MOD        VARCHAR2(15),
    FE_ULT_MOD        TIMESTAMP(6)
);
ALTER TABLE NAF47_TNET.ADMI_TIPO_DOCUMENTO ADD CONSTRAINT PK_ADMI_TIPO_DOCUMENTO PRIMARY KEY (ID_TIPO_DOCUMENTO);

CREATE SEQUENCE NAF47_TNET.SEQ_ADMI_TIPO_DOCUMENTO MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1;

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.ID_TIPO_DOCUMENTO IS
    'ID SECUENCIAL DE LA TABLA';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.TIPO_DOCUMENTO IS
    'VALOR DEL TIPO DE DOCUMENTO';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.ESTADO IS
    'ESTADO DEL TIPO DE SANCION';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.COD_EMPRESA IS
    'CODIGO DE EMPRESA A LA QUE PERTENECE EL TIPO DE DOCUMENTO';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.FE_CREACION IS
    'FECHA DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.USR_CREACION IS
    'USUARIO DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.IP_CREACION IS
    'IP DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.FE_ULT_MOD IS
    'FECHA DE ÚLTIMA MODIFICACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.USR_ULT_MOD IS
    'USUARIO DE ÚLTIMA MODIFICACIÓN';

COMMENT ON COLUMN NAF47_TNET.ADMI_TIPO_DOCUMENTO.IP_ULT_MOD IS
    'IP ÚLTIMA MODIFICACIÓN';


CREATE TABLE NAF47_TNET.INFO_DOCUMENTO (
    ID_DOCUMENTO      NUMBER NOT NULL,
    TIPO_DOCUMENTO_ID NUMBER NOT NULL,
    TIPO_SANCION_ID   NUMBER NOT NULL,
    HALLAZGO_ID       NUMBER NOT NULL,
    NO_EMPLE_ID       NUMBER NOT NULL,
    DEPARTAMENTO      VARCHAR2(100),
    TAREA_ID          NUMBER,
    OBSERVACION       VARCHAR2(400),
    FE_HALLAZGO       TIMESTAMP(6) NOT NULL,
    ESTADO            VARCHAR2(15),
    COD_EMPRESA       VARCHAR2(3),
    USR_CREACION      VARCHAR2(15) NOT NULL,
    IP_CREACION       VARCHAR2(15) NOT NULL,
    FE_CREACION       TIMESTAMP(6) NOT NULL,
    USR_ULT_MOD       VARCHAR2(15),
    IP_ULT_MOD        VARCHAR2(15),
    FE_ULT_MOD        TIMESTAMP(6)
);

ALTER TABLE NAF47_TNET.INFO_DOCUMENTO ADD CONSTRAINT PK_INFO_DOCUMENTO PRIMARY KEY (ID_DOCUMENTO);

CREATE SEQUENCE NAF47_TNET.SEQ_INFO_DOCUMENTO MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1;

ALTER TABLE NAF47_TNET.INFO_DOCUMENTO ADD CONSTRAINT FK_INFO_DOCUMENTO_TIPO_DOC FOREIGN KEY (TIPO_DOCUMENTO_ID)
    REFERENCES NAF47_TNET.ADMI_TIPO_DOCUMENTO(ID_TIPO_DOCUMENTO);

ALTER TABLE NAF47_TNET.INFO_DOCUMENTO ADD CONSTRAINT FK_INFO_DOCUMENTO_TIPO_SANCION FOREIGN KEY (TIPO_SANCION_ID)
    REFERENCES NAF47_TNET.ADMI_TIPO_SANCION(ID_TIPO_SANCION);

ALTER TABLE NAF47_TNET.INFO_DOCUMENTO ADD CONSTRAINT FK_INFO_DOCUMENTO_HALLAZGO FOREIGN KEY (HALLAZGO_ID)
    REFERENCES NAF47_TNET.ADMI_HALLAZGO(ID_HALLAZGO);

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.ID_DOCUMENTO IS
    'ID SECUENCIAL DE LA TABLA';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.TIPO_DOCUMENTO_ID IS
    'REFERENCIAL DE LA TABLA ADMI_TIPO_DOCUMENTO';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.TIPO_SANCION_ID IS
    'REFERENCIAL DE LA TABLA ADMI_TIPO_SANCION';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.HALLAZGO_ID IS
    'REFERENCIAL DE LA TABLA ADMI_HALLAZGO';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.NO_EMPLE_ID IS
    'ID DEL EMPLEADO SE RELACIONA CON LA VISTA V_EMPLEADOS_EMPRESAS';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.DEPARTAMENTO IS
    'DEPARTAMENTO DEL EMPLEADO';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.TAREA_ID IS
    'ID DE LA TAREA QUE SE RELACIONA AL EMPLEADO';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.OBSERVACION IS
    'OBSERVACION DEL DOCUMENTO';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.FE_HALLAZGO IS
    'FECHA DE HALLAZGO';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.ESTADO IS
    'ESTADO DEL DOCUMENTO';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.COD_EMPRESA IS
    'CODIGO DE EMPRESA A LA QUE PERTENECE EL DOCUMENTO';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.FE_CREACION IS
    'FECHA DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.USR_CREACION IS
    'USUARIO DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.IP_CREACION IS
    'IP DE CREACIÓN';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.FE_ULT_MOD IS
    'FECHA DE ÚLTIMA MODIFICACIÓN';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.USR_ULT_MOD IS
    'USUARIO DE ÚLTIMA MODIFICACIÓN';

COMMENT ON COLUMN NAF47_TNET.INFO_DOCUMENTO.IP_ULT_MOD IS
    'IP ÚLTIMA MODIFICACIÓN';

/
