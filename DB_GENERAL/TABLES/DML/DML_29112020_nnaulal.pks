/*
 * Insert para contrato digital web.
 */

INSERT 
INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,'ESTADO_SERVICIOS_CONTRATO_ADENDUM',
  'Parámetro para obtener los estados de los servicios para el contrato digital','CONTRATO-DIGITAL','',
  'Activo','nnaulal',SYSDATE,
    '127.0.0.1', NULL, NULL, NULL);

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO CONTRATO','Factible',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'0',NULL,NULL,'El 0 en empresaId es para ambas empresas');

INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO MD CONTRATO','Factible',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'18',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO TN CONTRATO','Rechazado',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO TN CONTRATO','Rechazada',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO TN CONTRATO','Cancelado',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO TN CONTRATO','Anulado',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO TN CONTRATO','Cancel',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO TN CONTRATO','Eliminado',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
'ESTADO SERVICIO TN CONTRATO','Reubicado',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);
    
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADO_SERVICIOS_CONTRATO_ADENDUM'),
  'ESTADO SERVICIO TN CONTRATO',
'Trasladado',NULL,NULL,NULL,'Activo','nnaulal',SYSDATE,
    '127.0.0.1',NULL,NULL,NULL,NULL,'10',NULL,NULL,NULL);

COMMIT;
/
