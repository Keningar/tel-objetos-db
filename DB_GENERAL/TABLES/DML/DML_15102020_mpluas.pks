/*
 * Insert para contrato digital web.
 */

INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,'DOC_GENERACION_CONTRATO/ADENDUM','Parámetro para validar los documentos requeridos en la generación del contrato o adendum segun su tipo','CONTRATO-DIGITAL','','Activo','mpluas',SYSDATE,
    '127.0.0.1', null, null, null);
   
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DOC_GENERACION_CONTRATO/ADENDUM'),
    'NATURAL','FOT,CED,CEDR',NULL,NULL,NULL,'Activo','mpluas',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'18',NULL,NULL,'VALOR1=[CODIGOS TIPO DOCUMENTOS]');
   
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DOC_GENERACION_CONTRATO/ADENDUM'),
    'JURIDICA','FOT,CED,CEDR,NBR,RUC,FDP',NULL,NULL,NULL,'Activo','mpluas',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'18',NULL,NULL,'VALOR1=[CODIGOS TIPO DOCUMENTOS]');

INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,'CONFIG_CD_NFS_MAIL','Parámetro de configuración para reemplazar la ruta que envia el nfs con la ruta que tiene el ms mail y asi poder enviar documentos adjuntos','CONTRATO-DIGITAL','','Activo','mpluas',SYSDATE,
    '127.0.0.1', null, null, null);

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CONFIG_CD_NFS_MAIL'),
    'NFS1','/nfs1/','/home/sqa/reportes1/',NULL,NULL,'Activo','mpluas',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'18',NULL,NULL,'VALOR1=[RUTA NFS PRINCIAL], VALOR2=[RUTA CONTENEDOR MS MAIL]');

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CONFIG_CD_NFS_MAIL'),
    'NFS2','/nfs2/','/home/sqa/reportes2/',NULL,NULL,'Activo','mpluas',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'18',NULL,NULL,'VALOR1=[RUTA NFS PRINCIAL], VALOR2=[RUTA CONTENEDOR MS MAIL]');

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CONFIG_CD_NFS_MAIL'),
    'NFS3','/nfs3/','/home/sqa/reportes3/',NULL,NULL,'Activo','mpluas',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'18',NULL,NULL,'VALOR1=[RUTA NFS PRINCIAL], VALOR2=[RUTA CONTENEDOR MS MAIL]');


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET (
  ID_PARAMETRO_DET,
  PARAMETRO_ID,
  DESCRIPCION,
  VALOR1,
  ESTADO,
  USR_CREACION,
  FE_CREACION,
  IP_CREACION,
  EMPRESA_COD
) VALUES (
  DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'ESTADO_PLAN_CONTRATO'),
  'ESTADO_PLAN_CONTRATO',
  'Clonado',
  'Activo',
  'gvalenzuela',
   SYSDATE,
  '172.17.0.1',
  '18');

COMMIT;
/
