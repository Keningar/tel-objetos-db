/*
 * Inserts a la tabla ADMI_PARAMETRO_CAB y ADMI_PARAMETRO_DET para parametrizar los dias de feriado de nuestro pais.
 */

INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,'DIAS_FERIADO_HORASEXTRA','Parametro para validar los dias de feriado del año','HORAS_EXTRA','','Activo','imata',SYSDATE,
    '127.0.0.1', null, null, null);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',1,1,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',2,24,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',2,25,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',4,10,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',5,1,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',5,24,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',7,25,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',8,10,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',10,9,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',11,2,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DIAS_FERIADO_HORASEXTRA'),
    'MES_DIAS_FERIADO',12,25,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    



/*
 * Inserts a la tabla ADMI_PARAMETRO_CAB y ADMI_PARAMETRO_DET para parametrizar a los usuarios que tendra un rol de administrador.
 */
INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,'PERMISOS_ADMINISTRADOR','Parametro para validar un usuario de rol administrador','HORAS_EXTRA','','Activo','imata',SYSDATE,
    '127.0.0.1', null, null, null);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','S','ichavez',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','S','hproano',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);


/*
 * Inserts a la tabla ADMI_PARAMETRO_CAB y ADMI_PARAMETRO_DET para parametrizar el correo de gerencia.
 */

INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,'CORREO_GERENCIAL_HE','Parametro que contiene el correo gerencial','HORAS_EXTRA','','Activo','imata',SYSDATE,
    '127.0.0.1', null, null, null);
    
   
 INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CORREO_GERENCIAL_HE'),
    'CORREO_ELECTRONICO','notificaciones_sistemas@telconet.ec',NULL,NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL); 

COMMIT;
/
