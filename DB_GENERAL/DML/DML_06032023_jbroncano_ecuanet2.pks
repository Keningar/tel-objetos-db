INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'DIGITAL_ASUNTO_CORREO_EMPRESA','SE PARAMETRIZA  LOS ASUNTOS QUE SE ENVIA EN EL CORREO POR EMPRESA',null
,null,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_MD','Netlife ha registrado el contrato de tu servicio de Ultra Alta Velocidad.','FORMA_REALIZACION_CONTRATO',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_EN','Ecuanet ha registrado el contrato de tu servicio de Ultra Alta Velocidad.','FORMA_REALIZACION_CONTRATO',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_MD','Netlife ha registrado el adendum de tu servicio de Ultra Alta Velocidad.','FORMA_REALIZACION_ADENDUM',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_EN','Ecuanet ha registrado el adendum de tu servicio de Ultra Alta Velocidad.','FORMA_REALIZACION_ADENDUM',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_MD','SOLICITUD DE AUTORIZACIÓN DE CONTRATO','FORMA_REALIZACION_AUTORIZACION',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_EN','SOLICITUD DE AUTORIZACIÓN DE CONTRATO','FORMA_REALIZACION_AUTORIZACION',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_EN','Los datos ingresados no son válidos. Por favor ingrese la información nuevamente, dígite las credenciales temporales para el proceso el contrato de tu servicio de Ultra Alta Velocidad.','FORMA_REALIZACION_REENVIO_CREDENCIALES_CLIENTE',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_MD','Los datos ingresados no son válidos. Por favor ingrese la información nuevamente, dígite las credenciales temporales para el proceso el contrato de tu servicio de Ultra Alta Velocidad.','FORMA_REALIZACION_REENVIO_CREDENCIALES_CLIENTE',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_MD','Netlife ha registrado sus credenciales temporales para el proceso el contrato de tu servicio de Ultra Alta Velocidad.','FORMA_REALIZACION_ENVIO_CREDENCIALES_CLIENTE',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_EN','Ecuanet ha registrado sus credenciales temporales para el proceso el contrato de tu servicio de Ultra Alta Velocidad.','FORMA_REALIZACION_ENVIO_CREDENCIALES_CLIENTE',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_MD','Pin de Instalación.','FORMA_REALIZACION_PIN',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_EN','Pin de Instalación.','FORMA_REALIZACION_PIN',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_EN','Datos ingresados por el cliente','FORMA_REALIZACION_DATOS_INGRESADO_CLIENTE',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'33',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);



INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'),
'DIGITAL_ASUNTO_CORREO_MD','Datos ingresados por el cliente','FORMA_REALIZACION_DATOS_INGRESADO_CLIENTE',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,'VALOR1: EL ASUNTO DEL CORREO; VALOR2: PARA  QUE DOCUMENTO SERA EL ASUNTO',null,null);







INSERT INTO DB_GENERAL.admi_parametro_det 
(ID_PARAMETRO_DET
,PARAMETRO_ID
,DESCRIPCION
,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,USR_CREACION
      ,FE_CREACION
      ,IP_CREACION
      ,USR_ULT_MOD
      ,FE_ULT_MOD
      ,IP_ULT_MOD
      ,VALOR5
      ,EMPRESA_COD
      ,VALOR6
      ,VALOR7
      ,OBSERVACION
      ,VALOR8
      ,VALOR9)
      SELECT DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
      (SELECT id_parametro FROM db_general.admi_parametro_cab  WHERE    nombre_parametro = 'PROCESO_EMER_SANITARIA' AND estado = 'Activo')
      ,DESCRIPCION
      ,VALOR1
      ,VALOR2
      ,VALOR3
      ,VALOR4
      ,ESTADO
      ,'jbroncano'
      ,sysdate
      ,'0.0.0.0',
          null,
          null,
          null,
          VALOR5,
          (select COD_EMPRESA from DB_COMERCIAL.INFO_EMPRESA_GRUPO where NOMBRE_EMPRESA='ECUANET'),
          VALOR6,
          VALOR7,        
     OBSERVACION,
          VALOR8,
          VALOR9
   FROM DB_GENERAL.admi_parametro_det
    where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PROCESO_EMER_SANITARIA'
            AND estado = 'Activo') and empresa_cod='18' and estado='Activo' AND DESCRIPCION='MES_DIFERIDO';   






COMMIT;

/