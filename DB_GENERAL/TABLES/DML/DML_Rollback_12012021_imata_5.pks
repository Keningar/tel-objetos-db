
-----UPDATE PARA Inactivar PARAMETRO PARA VALIDAR DEPARTAMENTOS QUE DEBEN INGRESAR TAREA DE MANERA OBLIGATORIA

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET APD SET APD.ESTADO='Inactivo' WHERE APD.PARAMETRO_ID = (SELECT APC.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC WHERE APC.NOMBRE_PARAMETRO='DEPARTAMENTO_TAREA_HE');


--Delete para eliminar el parametro que valida los roles por departamento que deben ingresar tarea.

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE PARAMETRO_ID= (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ROLES_TAREA_HE');

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE ID_PARAMETRO= (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ROLES_TAREA_HE');


COMMIT;

/

