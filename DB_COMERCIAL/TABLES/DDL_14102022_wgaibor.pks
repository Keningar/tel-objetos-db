/*
 * Creación de la tabla 'INFO_PERSONA_EMP_ROL_ENUNCIADO', encargada de
 * almacenar las claúsulas de puntos creadas en el telcos y tmComercial.
 */
CREATE TABLE DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO
(
  ID_PERSONA_EMP_ROL_ENUM         NUMBER,
  PERSONA_EMPRESA_ROL_ID          NUMBER NOT NULL,
  ENUNCIADO_ID                    NUMBER NOT NULL,
  DOC_RESPUESTA_ID                NUMBER NOT NULL,
  ESTADO                          VARCHAR2(50) NOT NULL,
  VALOR                           VARCHAR2(100) NOT NULL,
  USUARIO_CREACION                VARCHAR2(30) NOT NULL,
  FECHA_CREACION                  TIMESTAMP(6)    NOT NULL,
  IP_CREACION                     VARCHAR2(16) NOT NULL,
  USUARIO_MODIFICACION            VARCHAR2(30),
  FECHA_MODIFICACION              TIMESTAMP(6),
  IP_MODIFICACION                 VARCHAR2(16),
  CONSTRAINT PK_ID_PERSONA_EMP_ROL_ENUM  PRIMARY KEY (ID_PERSONA_EMP_ROL_ENUM),
  CONSTRAINT FK_PERSONA_EMPRESA_ROL_ID_1 FOREIGN KEY (PERSONA_EMPRESA_ROL_ID)
    REFERENCES DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL (ID_PERSONA_ROL),
  CONSTRAINT FK_ENUNCIADO_ID_1 FOREIGN KEY (ENUNCIADO_ID)
    REFERENCES DB_DOCUMENTO.ADMI_ENUNCIADO (ID_ENUNCIADO),
  CONSTRAINT FK_DOC_RESPUESTA_ID_1 FOREIGN KEY (DOC_RESPUESTA_ID)
    REFERENCES DB_DOCUMENTO.INFO_DOC_RESPUESTA (ID_DOC_RESPUESTA)
);

--Comentario de la tabla 'INFO_PERSONA_EMP_ROL_ENUNCIADO'.
COMMENT ON TABLE DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO
    IS 'TABLA ENCARGADA DE ALMACENAR LA INFORMACIÓN CORRESPONDIENTE AL ENUNCIADO QUE TIENE UNA PERSONA EN BASE AL ROL';

--Comentarios de las columnas de la tabla 'INFO_PERSONA_EMP_ROL_ENUNCIADO'.
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.ID_PERSONA_EMP_ROL_ENUM      IS 'ID DE LA TABLA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.PERSONA_EMPRESA_ROL_ID       IS 'REFERENCIA DEL CAMPO ID_PUNTO DE LA TABLA DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.ENUNCIADO_ID                 IS 'REFERENCIA DEL CAMPO ID_PUNTO DE LA TABLA DB_DOCUMENTO.ADMI_ENUNCIADO';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.DOC_RESPUESTA_ID             IS 'REFERENCIA DEL CAMPO ID_PUNTO DE LA TABLA DB_DOCUMENTO.INFO_DOC_RESPUESTA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.ESTADO                       IS 'ESTADO DEl REGISTRO DEL ROL DEL ENUNCIADO DE LA PERSONA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.VALOR                        IS 'VALOR DEL ENUNCIADO DE LA PERSONA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.USUARIO_CREACION             IS 'USUARIO QUIEN CREA EL ENUNCIADO DE LA PERSONA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.FECHA_CREACION               IS 'FECHA DE CREACION DEL ENUNCIADO DE LA PERSONA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.IP_CREACION                  IS 'IP DE CREACION DEL ENUNCIADO DE LA PERSONA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.USUARIO_MODIFICACION         IS 'USUARIO QUIEN MODIFICA EL ENUNCIADO DE LA PERSONA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.FECHA_MODIFICACION           IS 'FECHA DE MODIFICACION DEL ENUNCIADO DE LA PERSONA';
COMMENT ON COLUMN DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO.IP_MODIFICACION              IS 'IP DE MODIFICACION DEL ENUNCIADO DE LA PERSONA';

--Creación de indices para mayor agilidad en la consulta de la tabla 'INFO_PERSONA_EMP_ROL_ENUNCIADO'.
CREATE INDEX DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_FK_1   ON DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO (PERSONA_EMPRESA_ROL_ID);
CREATE INDEX DB_COMERCIAL.ADMI_ENUNCIADO_FK_1             ON DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO (ENUNCIADO_ID);
CREATE INDEX DB_COMERCIAL.INFO_DOC_RESPUESTA_FK_1         ON DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO (DOC_RESPUESTA_ID);
CREATE INDEX DB_COMERCIAL.INFO_PER_EMP_ROL_ENUN_IDX_1     ON DB_COMERCIAL.INFO_PERSONA_EMP_ROL_ENUNCIADO (VALOR);
