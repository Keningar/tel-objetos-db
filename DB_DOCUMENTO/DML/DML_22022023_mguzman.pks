/*
 * SCRIPT DML DEL ESQUEMA DB_DOCUMENTO. 
 *
 * @author: Miguel Guzman <mguzman@telconet.ec>
 * @notes: Migrado desde DB_DOCUMENTO/DML/DML_24102022_ccaguana.pks para proyecto Ecuanet
 */


------Creación de la cabecera enunciado plantilla

INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
ES_REQUERIDO,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'Opciones de respuesta de lista negra',
    'OR-LN',
     8,
     'N',
    'SELECT valor FROM admi_respuesta where id_respuesta = :idValor and estado = :estado',
    'Configuración de opciones de lista negra',
    'multiSelect',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);

--

INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
ES_REQUERIDO,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'Opciones de respuesta de lista blanca',
    'OR-LB',
     7,
     'N',
    'SELECT valor FROM admi_respuesta where id_respuesta = :idValor and estado = :estado',
    'Configuración de opciones de lista blanca',
    'multiSelect',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);


INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'Opciones de respuestas permitidas para continuar con el flujo',
    'OR-PCF',
    6,
    'SELECT valor FROM admi_respuesta where id_respuesta = :idValor and estado = :estado',
    'Configuración de opciones permitidas para continuar con el flujo',
    'multiSelect',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);

---

INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
ES_REQUERIDO,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'Opciones de respuesta marcada por default',
    'OR-MD',
    5,
    'N',
    'SELECT valor FROM admi_respuesta where id_respuesta = :idValor and estado = :estado',
    'Configuración de opciones respuesta marcada por default',
    'select',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);


INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'Opción de respuesta',
    'OR',
    4,
    'SELECT valor FROM admi_respuesta where id_respuesta = :idValor and estado = :estado',
    'Configuración de opciones de respuesta',
    'multiSelect',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);


INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'Tipo de selección de respuesta',
    'OR-TSR',
     3,
    'SELECT nombre FROM ADMI_TIPO where id_tipo = :idValor and estado = :estado',
    'Configuración de tipo de selección de respuesta',
    'select',
     33,
    'Activo',
    'mguzman',
    SYSDATE
);



INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
ES_REQUERIDO,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'Detalle',
    'DETALLE',
     2,
    'N',
     NULL,
    'Configuración detalle',
    'textarea',
     33,
    'Activo',
    'mguzman',
    SYSDATE
);



INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
ES_REQUERIDO,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'Link',
    'LINK',
     1,
    'N',
     NULL,
    'Configuración de link',
    'url',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);


INSERT INTO DB_DOCUMENTO.ADMI_CAB_ENUNCIADO (
ID_CAB_ENUNCIADO,
NOMBRE,
CODIGO,
ORDEN,
ES_REQUERIDO,
REFERENCIA_TABLA,
DESCRIPCION,
TIPO_INPUT,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_CAB_ENUNCIADO.NEXTVAL,
    'ORDEN',
    'ORDEN',
     0,
    'S',
     NULL,
    'Configuración de orden',
    'number',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);



--creación de proceso
INSERT INTO DB_DOCUMENTO.ADMI_PROCESO(ID_PROCESO,
NOMBRE,
CODIGO,
DESCRIPCION,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_PROCESO.NEXTVAL,
    'LinkDatosBancarios',
    'LDB',
    'Proceso de link Bancarios',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);

--creación de documento
INSERT INTO DB_DOCUMENTO.ADMI_DOCUMENTO(ID_DOCUMENTO,
NOMBRE,
CODIGO,
DESCRIPCION,
PROCESO_ID,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_DOCUMENTO.NEXTVAL,
    'Contrato de adhesión',
    'CDA',
    'Documento Contrato de adhesión',
    (SELECT
    id_proceso FROM DB_DOCUMENTO.admi_proceso
    WHERE codigo = 'LDB'
    AND estado = 'Activo' AND EMPRESA_COD = 33),
    'Activo',
    'mguzman',
    SYSDATE
);

  
--creacion de respuesta

INSERT INTO DB_DOCUMENTO.ADMI_RESPUESTA  (
ID_RESPUESTA,
NOMBRE ,
VALOR ,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_RESPUESTA.NEXTVAL,
    'ELECTRÓNICA',
    'ELECTRÓNICA',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);


INSERT INTO DB_DOCUMENTO.ADMI_RESPUESTA  (
ID_RESPUESTA,
NOMBRE ,
VALOR ,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_RESPUESTA.NEXTVAL,
    'ACEPTA',
    'ACEPTA',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);



INSERT INTO DB_DOCUMENTO.ADMI_RESPUESTA  (
ID_RESPUESTA,
NOMBRE ,
VALOR ,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_RESPUESTA.NEXTVAL,
    'NO ACEPTA',
    'NO ACEPTA',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);

INSERT INTO DB_DOCUMENTO.ADMI_RESPUESTA  (
ID_RESPUESTA,
NOMBRE ,
VALOR ,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_RESPUESTA.NEXTVAL,
    'SI',
    'SI',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);

INSERT INTO DB_DOCUMENTO.ADMI_RESPUESTA  (
ID_RESPUESTA,
NOMBRE ,
VALOR ,
EMPRESA_COD,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_RESPUESTA.NEXTVAL,
    'NO',
    'NO',
    33,
    'Activo',
    'mguzman',
    SYSDATE
);





-------Creación relacion entre enunciado y respuestas.

INSERT INTO DB_DOCUMENTO.ADMI_TIPO_ENUNCIADO (
ID_TIPO_ENUNCIADO,
TIPO_ID,
CAB_ENUNCIADO_ID,
DESCRIPCION,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_TIPO_ENUNCIADO.NEXTVAL,
    (SELECT
    ID_TIPO FROM DB_DOCUMENTO.ADMI_TIPO
    WHERE NOMBRE = 'Check único'
    AND estado = 'Activo'),
     (SELECT
    ID_CAB_ENUNCIADO FROM DB_DOCUMENTO.ADMI_CAB_ENUNCIADO
    WHERE codigo = 'OR-TSR'
    AND estado = 'Activo' AND EMPRESA_COD = 33),
    (SELECT
    DESCRIPCION  FROM DB_DOCUMENTO.ADMI_TIPO
    WHERE NOMBRE = 'Check único'
    AND estado = 'Activo'),
    'Activo',
    'mguzman',
    SYSDATE
);





INSERT INTO DB_DOCUMENTO.ADMI_TIPO_ENUNCIADO (
ID_TIPO_ENUNCIADO,
TIPO_ID,
CAB_ENUNCIADO_ID,
DESCRIPCION,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_TIPO_ENUNCIADO.NEXTVAL,
    (SELECT
    ID_TIPO FROM DB_DOCUMENTO.ADMI_TIPO
    WHERE NOMBRE = 'Check por respuesta'
    AND estado = 'Activo'),
     (SELECT
    ID_CAB_ENUNCIADO FROM DB_DOCUMENTO.ADMI_CAB_ENUNCIADO
    WHERE codigo = 'OR-TSR'
    AND estado = 'Activo' AND EMPRESA_COD = 33),
    (SELECT
    DESCRIPCION  FROM DB_DOCUMENTO.ADMI_TIPO
    WHERE NOMBRE = 'Check por respuesta'
    AND estado = 'Activo'),
    'Activo',
    'mguzman',
    SYSDATE
);



INSERT INTO DB_DOCUMENTO.ADMI_TIPO_ENUNCIADO (
ID_TIPO_ENUNCIADO,
TIPO_ID,
CAB_ENUNCIADO_ID,
DESCRIPCION,
ESTADO,
USUARIO_CREACION,
FECHA_CREACION
)
VALUES(
    DB_DOCUMENTO.SEQ_ADMI_TIPO_ENUNCIADO.NEXTVAL,
    (SELECT
    ID_TIPO FROM DB_DOCUMENTO.ADMI_TIPO
    WHERE NOMBRE = 'Respuestas'
    AND estado = 'Activo'),
     (SELECT
    ID_CAB_ENUNCIADO FROM DB_DOCUMENTO.ADMI_CAB_ENUNCIADO
    WHERE codigo = 'OR'
    AND estado = 'Activo' AND EMPRESA_COD = 33),
    (SELECT
    DESCRIPCION  FROM DB_DOCUMENTO.ADMI_TIPO
    WHERE NOMBRE = 'Respuestas'
    AND estado = 'Activo'),
    'Activo',
    'mguzman',
    SYSDATE
);


commit;
/