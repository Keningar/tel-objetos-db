-----UPDATE PARA MODIFICAR PARAMETRO DE ENVIO DE CORREO DE SOLICITUDES AUTORIZADAS

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR1='nomina@telconet.ec,arsuarez@telconet.ec,' WHERE PARAMETRO_ID = (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'CORREO_DESTINATARIO_HE');


commit;

/
