UPDATE DB_GENERAL.ADMI_PARAMETRO_DET
SET VALOR3 = 'La solicitud no aplica para Planificación comercial. Se envia la solicitud a PYL.'
WHERE PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PRODUCTOS QUE NO SE PLANIFICAN');
COMMIT;