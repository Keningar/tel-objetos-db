/**
 * DEBE EJECUTARSE EN DB_SSO.
 * @author Marlon Plúas <mpluas@telconet.ec>
 * @version 1.0 01-07-2020 - Versión Inicial.
 */

/** Creación de secuencias tablas cas **/
CREATE SEQUENCE DB_SSO.SEQ_REGX_REGIS_SERVICE
  INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCACHE;

CREATE SEQUENCE DB_SSO.SEQ_REGX_REGIS_SERVICE_PRO
  INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCACHE;

CREATE SEQUENCE DB_SSO.SEQ_REGIS_SERVICE_IMP_CONT
  INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCACHE;

/** Creación de tabla ADMI_SERVICIO_SSO **/
CREATE TABLE DB_SSO.ADMI_SERVICIO_SSO
(
  ID_SERVICIO_SSO       NUMBER NOT NULL,
  NOMBRE_SERVICIO       VARCHAR2(300) NOT NULL,
  SERVICE_TARGET	VARCHAR2(1500) NOT NULL,
  DESCRIPCION		VARCHAR2(500) NULL,
  ESTADO                VARCHAR2(30)  NOT NULL,
  USR_CREACION          VARCHAR2(30)  NOT NULL,
  FE_CREACION           TIMESTAMP     NOT NULL,
  IP_CREACION           VARCHAR2(30)  NOT NULL,
  USR_ULT_MOD           VARCHAR2(30),
  FE_ULT_MOD            TIMESTAMP,
  IP_ULT_MOD            VARCHAR2(30),
  CONSTRAINT PK_ID_SERVICIO_SSO  PRIMARY KEY (ID_SERVICIO_SSO),
  UNIQUE(SERVICE_TARGET)
);

/** Comentarios de tabla ADMI_SERVICIO_SSO **/
COMMENT ON TABLE DB_SSO.ADMI_SERVICIO_SSO
    IS 'TABLA ENCARGADA DE ALMACENAR LOS SERVICIOS QUE ESTAN AUTORIZADOS POR EL SSO';

/** Comentarios de columnas tabla ADMI_SERVICIO_SSO **/
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.ID_SERVICIO_SSO      IS 'ID DEL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.SERVICE_TARGET       IS 'URL DEL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.NOMBRE_SERVICIO      IS 'NOMBRE DEL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.DESCRIPCION      	IS 'DESCRIPCION DEL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.ESTADO               IS 'ESTADO DEL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.USR_CREACION         IS 'USUARIO QUIEN CREA EL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.FE_CREACION          IS 'FECHA DE CREACION DEL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.IP_CREACION          IS 'IP DEL USUARIO QUIEN CREA EL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.USR_ULT_MOD          IS 'USUARIO QUIEN MODIFICA EL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.FE_ULT_MOD           IS 'FECHA DE MODIFICACION DEL SERVICIO';
COMMENT ON COLUMN DB_SSO.ADMI_SERVICIO_SSO.IP_ULT_MOD           IS 'IP DEL USUARIO QUIEN MODIFICA EL SERVICIO';

/** Comentarios de indixes tabla ADMI_SERVICIO_SSO **/
CREATE INDEX DB_SSO.IDX_NOMBRE_SERVICIO   ON DB_SSO.ADMI_SERVICIO_SSO (NOMBRE_SERVICIO);
CREATE INDEX DB_SSO.IDX_ESTADO   ON DB_SSO.ADMI_SERVICIO_SSO (ESTADO);
CREATE INDEX DB_SSO.IDX_FE_CREACION_ASC   ON DB_SSO.ADMI_SERVICIO_SSO (FE_CREACION ASC);
CREATE INDEX DB_SSO.IDX_FE_CREACION_DESC   ON DB_SSO.ADMI_SERVICIO_SSO (FE_CREACION DESC);

/** Comentarios de secuencias tabla ADMI_SERVICIO_SSO **/
CREATE SEQUENCE DB_SSO.SEQ_ADMI_SERVICIO_SSO
  INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 NOCACHE;

/