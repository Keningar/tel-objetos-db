INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'RCOMPRA_ASUNTO_CORREO_EMPRESA','SE PARAMETRIZA  LOS ASUNTOS QUE SE ENVIA EN EL CORREO POR EMPRESA',null
,null,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'RCOMPRA_ASUNTO_CORREO_EMPRESA'),
'RCOMPRA_ASUNTO_CORREO_MD','Resumen Compra','FORMA_REALIZACION_RCOMPRA',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'RCOMPRA_ASUNTO_CORREO_EMPRESA'),
'RCOMPRA_ASUNTO_CORREO_MD','NETLIFE tiene información importante que compartir','FORMA_REALIZACION_RREGULARIZACION',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);

COMMIT;
/