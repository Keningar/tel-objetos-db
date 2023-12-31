/** NETWORKING **/
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Aplicaciones','https://aplicaciones.telconet.ec:8888/','Contiene operaciones y reportes sobre la red y equipos de la red','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Networking','Tatiana Navarro','netdevelopers@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Admin-Dispositivos','https://admin-dispositivos.telconet.ec/','Sistema de Administración de Dispositivos','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Networking','Tatiana Navarro','netdevelopers@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Admin-Dispositivos Backup','https://admin-dispositivos-bk.telconet.ec/','Sistema de Administración de Dispositivos','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Networking','Tatiana Navarro','netdevelopers@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Cacti Backbone','http://backbonemonitor.telconet.ec/','Sistema de monitoreo de equipos de backbone','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Networking','Tatiana Navarro','netdevelopers@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Administracion Cisco','https://aaaa.telconet.ec/','Sistema de monitoreo de equipos de backbone','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Networking','Tatiana Navarro','netdevelopers@telconet.ec',0,'LDAP');
/** NETWORKING **/
/** MEGADATOS **/
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://zabbix.netlife.net.ec/zabbix/','Sistema de monitoreo','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Nagios','http://nagios.netlife.net.ec/pandora_console/','Monitoreo SNMP','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'RDA','RDA','red_acceso@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Syslog rda','http://syslog.netlife.net.ec/netlife-syslog/netlife-syslog/','Almacenamiento de logs','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'RDA','RDA','red_acceso@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Syslog rda','http://syslog.netlife.net.ec/loganalyzer/','Almacenamiento de logs','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Cacti','http://cacti.netlife.net.ec/','Monitoreo olt','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'RDA','RDA','red_acceso@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'CPNR GYE REGIONAL','http://172.30.80.71:8090/','Asignacion de IP olt','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'RDA','RDA','red_acceso@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'CPNR GYE LOCAL','http://172.30.80.72:8080/','Asignacion de IP olt','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'RDA','RDA','red_acceso@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'CPNR UIO REGIONAL','http://172.30.80.101:8090/','Asignacion de IP olt','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'RDA','RDA','red_acceso@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'CPNR UIO LOCAL','http://172.30.80.102:8080/','Asignacion de IP olt','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'RDA','RDA','red_acceso@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Onlyoffice','https://onlyoffice.netlife.net.ec/','Onlyoffice netlifedrive','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Oss Netlife','https://oss.netlife.net.ec/','Oss','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'GDA','GDA','informaticos@netlife.net.ec',0,'CAS');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Talento Humano','https://talentohumano.netlife.net.ec/','TTHH Megadatos','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'GDA','GDA','informaticos@netlife.net.ec',0,'CAS');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Generar Claves de HW','http://adminlc.netlife.ec/','Generar Claves de HW','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'GDA','GDA','informaticos@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Regularizar Cleves de Jvillacis','http://soportelc.netlife.ec/','Regularizar Cleves de Jvillacis','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'GDA','GDA','informaticos@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Pagina web netlife','https://netlife.ec/','Pagina web netlife','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Marketing','MK','marketingnetlife@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Mail corporativo','https://mail.netlife.net.ec/','netlife.net.ec','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Consola de administracion mail MD','https://mail.netlife.net.ec:7071/','Consola de administracion mail netlife.net.ec','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Speedtest UIO','https://speedtest1.netlife.ec:8080/','Medidor de AB','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');
                                   
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Speedtest GYE','https://speedtest1.telconet.net:8080/','Medidor de AB','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Qlick Sense','https://bi.netlife.net.ec/','Plataforma para analisis de datos','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BI','BI','bi@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Nprinting','https://nprinting.netlife.net.ec/#/reports/','Envío automático de informes','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BI','BI','bi@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Paginas SGC','http://calidad.netlife.net.ec/','Portal','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Calidad','Calidad','rcalderon@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Pagina Ambiente','http://ambiente.netlife.net.ec/','Portal','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Calidad','Calidad','rcalderon@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Pagina Seguridad','http://seguridad.netlife.net.ec/','Portal','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Calidad','Calidad','rcalderon@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Pagina portal conocimiento','http://conocimiento.netlife.net.ec/','Portal','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Calidad','Calidad','rcalderon@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Netlifedrive','https://netlifedrive.netlife.net.ec/','File sync and Share','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Moodle','https://capacitacion.netlife.net.ec/','Moodle portal capacitaciones','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Calidad','Calidad','rcalderon@netlife.net.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Consola de Administracion Servidor cloudcenter','https://correo.cloudcenter.ec:7071/','Servidor dominios clientes externos','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Consola de Administracion Servidor cloudcenter 2','https://correo2.cloudcenter.ec:7071/','Servidor dominios clientes externos','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Consola de Administracion Servidor cloudcenter 3','https://correo3.cloudcenter.ec:7071/','Servidor dominios clientes externos','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Consola de Administracion Servidor cloudcenter 4','https://correo4.cloudcenter.ec:7071/','Servidor dominios clientes externos','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Consola de Administracion Servidor cloudcenter 5','https://mail.netlife.ec:7071/','defense.netlife.ec/envio de pines a clientes','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'CIMC UIO','https://172.24.8.14/login.html/','Integrated Management Controller Configuration','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'CIMC GYE','https://172.24.8.13/login.html/','Integrated Management Controller Configuration','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'TI','TI','ti@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Aplicación Issabel UIO','https://issabel.netlife.net.ec:9666/','Potales central telefónica','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Telefonia','Telefonia','telefonia@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Aplicación Issabel GYE','https://telefonia.netlife.net.ec:9666/','Potales central telefónica','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Telefonia','Telefonia','telefonia@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Aplicación Issabel GYE Cobranzas','https://172.24.9.42:8080/','Potales central telefónica','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Telefonia','Telefonia','telefonia@netlife.net.ec',0,'OTRO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Aplicación Issabel Salinas','https://172.24.9.43/','Potales central telefónica','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Telefonia','Telefonia','telefonia@netlife.net.ec',0,'OTRO');
/** MEGADATOS **/
/** NOC **/
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/QIj73jjRnw2gN4=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/mzS8eUT750txj4=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/2cwDDE4AQYdALs=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/eyBN1bB3SKp89M=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/tMhBbrK5ua9aLY=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/FdTxd6N8NLWjNE=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/tgBpeD6hthpKwg=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/pM5jDZYe9Ws4JI=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/UtccuHjmwfd4g0=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana - Zabbix','https://telcograf.telconet.ec/EhOyy3kDBns1ek=/','Herramienta de monitoreo WAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','https://172.24.27.37/zabbix/','Herramienta de monitoreo LAN clientes.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Web Service Proactivo','https://noc-apps.telconet.ec/admin/','Web service ingreso monitoreo proactivo.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','https://monitoreobackbone3.telconet.ec/zabbix/','Herramienta de monitoreo backbone.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.24.27.16/zabbix/','Herramienta de monitoreo clientes vip.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.24.27.50/zabbix/','Herramienta de monitoreo clientes corporativos.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','https://172.24.27.70/zabbix/','Herramienta de monitoreo backbone backup.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.24.27.22/zabbix/','Herramienta de monitoreo servicios.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.30.19.6/zabbix/','Herramienta de monitoreo dc.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Grafana','https://backbonenoc.telconet.ec/','Herramienta de monitoreo backbone.','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'NOC','NOC','noc@telconet.ec',0,'LDAP');
/** NOC **/
/** LCHIANG **/
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'MPG','https://mpg.telconet.ec/','Aplicación de Monitoreo Proactivo de clientes y flota','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'OPU','Luis Chiang','lchiang@telconet.ec',0,'JOSSO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'HAL','https://hal.telconet.ec/','Aplicación Web de Hal','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'OPU','Luis Chiang','lchiang@telconet.ec',0,'JOSSO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'CPE','https://cpe.telconet.ec/','Aplicación Web de IPCCL2','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'IPCCL2','Luis Chiang','lchiang@telconet.ec',0,'JOSSO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'RCA','https://rca.telconet.ec/','Acceso a los cpes','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'IPCCL2','Luis Chiang','lchiang@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'TelcoU','https://telcou.ec/','Telcou Moodle','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'Talento Humano','mharo','mharo@telconet.ec',0,'JOSSO');
/** LCHIANG **/
/** BOC **/
INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.30.147.11/zabbix/','Monitoreo de Infraestructura y equipos de áreas','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.30.147.12/zabbix/','Monitoreo de Infraestructura y equipos de clientes','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.30.147.19/zabbix/','Monitoreo Cloud','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.30.147.51/zabbix/','Monitoreo de áreas de TN','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.30.147.52/zabbix/','Monitoreo de áreas de TN','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.30.147.54/zabbix/','Monitoreo de áreas de TI y cloud','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Zabbix','http://172.30.147.56/zabbix/','Monitoreo de áreas de TI y cloud','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Telcograf','https://telcograf.telconet.ec/fMgBzsK9je9aMy=/login/','Dashboard de Monitoreo','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Opendcim','https://172.30.147.30/','CMDB de equipos instalados en el TI de Datacenter Quito','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'LDAP');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Syscloud test','https://syscloudtest.i.telconet.net/','Ambiente de pruebas de sistema de tickets de Data Center','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'JOSSO');

INSERT INTO DB_SSO.ADMI_SERVICIO_SSO (ID_SERVICIO_SSO,NOMBRE_SERVICIO,SERVICE_TARGET,DESCRIPCION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,USR_ULT_MOD,FE_ULT_MOD,IP_ULT_MOD,DEPARTAMENTO_RESPONSABLE,NOMBRE_RESPONSABLE,CORREO_RESPONSABLE,AUTORIZAR_CAS,TIPO_AUTENTICACION) 
VALUES (DB_SSO.SEQ_ADMI_SERVICIO_SSO.NEXTVAL,'Syscloud producción','https://syscloudcenter.i.telconet.net/','Ambiente de producción de sistema de tickets de Data Center','Activo','mpluas',SYSDATE,'127.0.0.1',NULL,NULL,NULL,'BOC','BOC','datacenter_uioboc@telconet.ec',0,'JOSSO');
/** BOC **/

COMMIT;

/


