/*
 * CREACIÓN DE TELCOS
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Telcos Prod','https://telcos.telconet.ec/','App telcos prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación Telcos Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'Telcos Prod',NULL,NULL,NULL,NULL,NULL,'^https://telcos.telconet.ec/?.*',NULL,NULL);

/*
 * CREACIÓN DE CONSUMO CELULAR
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Consumo Celular Prod','https://sites.telconet.ec/consumo-celular/','App consumo celular prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación Consumo Celular Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'Consumo Celular Prod',NULL,NULL,NULL,NULL,NULL,'^https://sites.telconet.ec/consumo-celular/?.*',NULL,NULL);

/*
 * CREACIÓN DE PEDIDOS
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Pedidos Prod','https://sites.telconet.ec/pedidos/','App pedidos prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación Pedidos Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'Pedidos Prod',NULL,NULL,NULL,NULL,NULL,'^https://sites.telconet.ec/pedidos/?.*',NULL,NULL);

/*
 * CREACIÓN DE SQA BOARD
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'SQA Board Prod','https://sites.telconet.ec/sqa/','App sqa board prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación SQA Board Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'SQA Board Prod',NULL,NULL,NULL,NULL,NULL,'^https://sites.telconet.ec/sqa/?.*',NULL,NULL);

/*
 * CREACIÓN DE INTRANET
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Intranet Prod','https://intranet.telconet.net/','App intranet prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación Intranet Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'Intranet Prod',NULL,NULL,NULL,NULL,NULL,'^https://intranet.telconet.net/?.*',NULL,NULL);

/*
 * CREACIÓN DE GESTION DOCUMENTAL
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Gestion Documental Prod','https://sites.telconet.ec/gestiondocumental/','App gestion documental prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación Gestion Documental Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'Gestion Documental Prod',NULL,NULL,NULL,NULL,NULL,'^https://sites.telconet.ec/gestiondocumental/?.*',NULL,NULL);

/*
 * CREACIÓN DE SIS RED
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Sis Red Prod','https://sisred.telconet.net/','App sis red prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación Sis Red Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'Sis Red Prod',NULL,NULL,NULL,NULL,NULL,'^https://sisred.telconet.net/?.*',NULL,NULL);

/*
 * CREACIÓN DE CITAS COVID 19
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Citas Covid 19 Prod','https://sites.telconet.ec/citas-covid19/','App citas covid 19 prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación Citas Covid 19 Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'Citas Covid 19 Prod',NULL,NULL,NULL,NULL,NULL,'^https://sites.telconet.ec/citas-covid19/?.*',NULL,NULL);

/*
 * CREACIÓN DE MONITOR ELEMENTOS
 */
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD) VALUES 
(DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Monitor Elementos Prod','https://sites.telconet.ec/monitor-elementos/','App monitor elementos prod','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL);
INSERT INTO DB_SSO.REGEXREGISTEREDSERVICE (EXPRESSION_TYPE,ID,ACCESS_STRATEGY,ATTRIBUTE_RELEASE,DESCRIPTION,EVALUATION_ORDER,EXPIRATION_POLICY,INFORMATIONURL,LOGO,LOGOUT_TYPE,LOGOUT_URL,MFA_POLICY,NAME,PRIVACYURL,PROXY_POLICY,PUBLIC_KEY,REQUIRED_HANDLERS,RESPONSETYPE,SERVICEID,THEME,USERNAME_ATTR) VALUES 
('regex',DB_SSO.SEQ_REGX_REGIS_SERVICE.NEXTVAL,NULL,NULL,'Aplicación Monitor Elementos Prod',1,NULL,NULL,NULL,NULL,NULL,NULL,'Monitor Elementos Prod',NULL,NULL,NULL,NULL,NULL,'^https://sites.telconet.ec/monitor-elementos/?.*',NULL,NULL);

COMMIT;

/

