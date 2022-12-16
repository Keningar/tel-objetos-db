/**
* Documentación del archivo DML_30102022_wgaibor
*
* @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
* @version 1.1 11-10-2022
*/

INSERT
INTO DB_GENERAL.ADMI_TIPO_ROL
( 
  ID_TIPO_ROL,
  DESCRIPCION_TIPO_ROL,
  ESTADO,
  USR_CREACION,
  FE_CREACION
)
VALUES
(
  DB_GENERAL.SEQ_ADMI_TIPO_ROL.NEXTVAL,
  'listaPersona',
  'Activo',
  'wgaibor',
  SYSDATE
);

INSERT
INTO DB_GENERAL.ADMI_ROL
( 
  ID_ROL,
  TIPO_ROL_ID,
  DESCRIPCION_ROL,
  ESTADO,
  USR_CREACION,
  FE_CREACION
)
VALUES
(
  DB_GENERAL.SEQ_ADMI_ROL.NEXTVAL,
  (SELECT ID_TIPO_ROL FROM DB_GENERAL.ADMI_TIPO_ROL WHERE DESCRIPCION_TIPO_ROL = 'listaPersona'),
  'blanca',
  'Activo',
  'wgaibor',
  SYSDATE
);

INSERT
INTO DB_GENERAL.ADMI_ROL
( 
  ID_ROL,
  TIPO_ROL_ID,
  DESCRIPCION_ROL,
  ESTADO,
  USR_CREACION,
  FE_CREACION
)
VALUES
(
  DB_GENERAL.SEQ_ADMI_ROL.NEXTVAL,
  (SELECT ID_TIPO_ROL FROM DB_GENERAL.ADMI_TIPO_ROL WHERE DESCRIPCION_TIPO_ROL = 'listaPersona'),
  'negra',
  'Activo',
  'wgaibor',
  SYSDATE
);

--Se registra el tipo de listaPersona ingresado para las diferentes empresas
INSERT INTO DB_COMERCIAL.INFO_EMPRESA_ROL
(id_empresa_rol,empresa_cod,rol_id,estado,usr_creacion,fe_creacion,ip_creacion)
VALUES
(
    DB_COMERCIAL.SEQ_INFO_EMPRESA_ROL.NEXTVAL,
    18,
    (SELECT ID_ROL FROM DB_GENERAL.ADMI_ROL WHERE DESCRIPCION_ROL='blanca'),
    'Activo',
    'wgaibor',
    sysdate,
    '127.0.0.1'
);
--
INSERT INTO DB_COMERCIAL.INFO_EMPRESA_ROL
(id_empresa_rol,empresa_cod,rol_id,estado,usr_creacion,fe_creacion,ip_creacion)
VALUES
(
    DB_COMERCIAL.SEQ_INFO_EMPRESA_ROL.NEXTVAL,
    18,
    (SELECT ID_ROL FROM DB_GENERAL.ADMI_ROL WHERE DESCRIPCION_ROL='negra'),
    'Activo',
    'wgaibor',
    sysdate,
    '127.0.0.1'
);

COMMIT;
/