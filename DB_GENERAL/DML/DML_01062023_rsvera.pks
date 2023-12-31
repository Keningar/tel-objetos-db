/**
 * Insert de los estados para la validacion de la migracion de ultima milla
 * @author Rafael Vera<rsvera@telconet.ec>
 * @version 1.0 01-06-2023 - Versión Inicial.
 */



INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (ID_PARAMETRO_DET,PARAMETRO_ID,DESCRIPCION,VALOR1,VALOR2,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,EMPRESA_COD)
VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='CAMBIO_ULTIMA_MILLA_MASIVO' AND ESTADO = 'Activo'),'Estado no permitido que contengan los servicios','EstadoNoPermitido','Anulado','Activo','rsvera',SYSDATE,'127.0.0.1',10);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (ID_PARAMETRO_DET,PARAMETRO_ID,DESCRIPCION,VALOR1,VALOR2,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,EMPRESA_COD)
VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='CAMBIO_ULTIMA_MILLA_MASIVO' AND ESTADO = 'Activo'),'Estado no permitido que contengan los servicios','EstadoNoPermitido','Eliminado','Activo','rsvera',SYSDATE,'127.0.0.1',10);
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (ID_PARAMETRO_DET,PARAMETRO_ID,DESCRIPCION,VALOR1,VALOR2,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,EMPRESA_COD)
VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='CAMBIO_ULTIMA_MILLA_MASIVO' AND ESTADO = 'Activo'),'Estado no permitido que contengan los servicios','EstadoNoPermitido','Rechazada','Activo','rsvera',SYSDATE,'127.0.0.1',10);
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (ID_PARAMETRO_DET,PARAMETRO_ID,DESCRIPCION,VALOR1,VALOR2,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION,EMPRESA_COD)
VALUES
  (DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO='CAMBIO_ULTIMA_MILLA_MASIVO' AND ESTADO = 'Activo'),'Estado no permitido que contengan los servicios','EstadoNoPermitido','Cancel','Activo','rsvera',SYSDATE,'127.0.0.1',10);

COMMIT;
/