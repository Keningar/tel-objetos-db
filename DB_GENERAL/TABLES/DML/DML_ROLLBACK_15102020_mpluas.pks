/*
 * Insert para contrato digital web.
 */

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET B WHERE B.PARAMETRO_ID= (SELECT A.ID_PARAMETRO
FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DOC_GENERACION_CONTRATO/ADENDUM');

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'DOC_GENERACION_CONTRATO/ADENDUM';

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET B WHERE B.PARAMETRO_ID= (SELECT A.ID_PARAMETRO
FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CONFIG_CD_NFS_MAIL');

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CONFIG_CD_NFS_MAIL';

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
  WHERE PARAMETRO_ID = (
    SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'ESTADO_PLAN_CONTRATO'
  ) AND VALOR1 = 'Clonado';

COMMIT;
/