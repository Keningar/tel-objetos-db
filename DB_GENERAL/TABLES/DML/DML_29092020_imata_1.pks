UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR2='Gerente Tecnico Regional',VALOR1='Gerencia' 
    WHERE VALOR2='hproano' AND PARAMETRO_ID=(SELECT A.ID_PARAMETRO 
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR');
    
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR2='Subgerente Téc. Regional', VALOR1='Gerencia' 
    WHERE VALOR2='ichavez' AND PARAMETRO_ID=(SELECT A.ID_PARAMETRO 
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR');
    

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Gerencia','Gerente Tecnico Nacional',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
    -- INSERTS PARA REGISTRO DE JEFATURA
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Subgerente Datacenter',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);


INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Jefe Sistemas',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);


INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Jefe Dpto. Nacional',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL); 

   
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Jefe Dpto Nacional',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);


INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Jefe Departamental',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Gerente Área Nacional',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Gerente Tecnico Sucursal',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Subgerente Datacenter',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);  
  
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),'USUARIO_ADMINISTRADOR','Jefatura','Subgerente Datacenter',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);


INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Jefatura','Gerente Data Center',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);    
    
    --INSERTS PARA REGISTRO DE COORDINADORES   
    
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Coordinacion','Coordinador',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Coordinacion','Coordinador NOC',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Coordinacion','Ayudante Coordinador',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Coordinacion','Coordinador Devops',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Coordinacion','Coordinador Nacional',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Coordinacion','Lider de Desarrollo',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Coordinacion','Lider Desarrollo Soft.',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
   

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,(SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR'),
    'USUARIO_ADMINISTRADOR','Coordinacion','Lider Soporte Usuario',NULL,NULL,'Activo','imata',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);    
    

commit;

/
