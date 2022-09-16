/*
 * SCRIPT DML DEL ESQUEMA DB_DOCUMENTO. 
 *
 * @author: Walther Joao Gaibor <wgaibor@telconet.ec>
 * @version 1.0 13-06-2022
 */

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
    'LinkDatosBancario',
    'link-banc',
    'Link de datos bancario',
    18,
    'Activo',
    'wgaibor',
    SYSDATE
);

--
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
    'TerminoCondicion',
    'term-cond',
    'Terminos y Condición',
    (SELECT
    id_proceso FROM DB_DOCUMENTO.admi_proceso
    WHERE codigo = 'link-banc'
    AND estado = 'Activo'),
    'Activo',
    'wgaibor',
    SYSDATE
);
commit;
/