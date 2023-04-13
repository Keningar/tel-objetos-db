/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear cabecera y detalle de parametros para microservicios derecho legal proceso descifra datos
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 13-02-2023 - Versión Inicial.
 */


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, 
(SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'),
'DATOS_CORREO_DESCIFRAR',
'<html><head><meta http-equiv=Content-Type content="text/html; charset=UTF-8"></head><body><table align="center" width="100%" cellspacing="0" cellpadding="5" border="0"><tr></tr><tr><td style="border:1px solid #6699CC;"><table width="100%" cellspacing="0" cellpadding="5" border="0"><tr><td colspan="2"><table cellspacing="0" cellpadding="2" border="0"><tr><td colspan="2">Estimado delegado de Datos Personales</td></tr><tr><td></td></tr><tr><td>Se ha procedido a desencriptar los datos del cliente {identificacion_cliente}</td></tr><tr><td><br><b>Fecha y hora: </b>{fechaHora}</td></tr><tr><tr><td><b>Usuario: </b>{usuario}</td></tr><tr><tr><td><b>Origen: </b>{origen}</td></tr><tr><br><td colspan="2">Atentamente,</td></tr><tr><td></td></tr><tr><td colspan="2"><strong>Sistema TelcoS+</strong></td></tr></table></td></tr><tr><td colspan="2"><br></td></tr></table></td></tr><tr><td></td></tr></table></body></html>',
'notificacionesnetlife@netlife.info.ec',
'plantillaDLDescifradoDatosLink',
'NETLIFE-INCORPORACIÓN EN BASE DE CLIENTES ', 
'Activo', 
'wdsanchez', 
SYSDATE, 
'127.0.0.1', 
NULL, 
NULL, 
NULL, 
NULL, 
18, 
'parametro',
'delegadodatos@netlife.net.ec', 
NULL,
NULL,
NULL);


INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'), 'DATOS_LINK', 30, 'plantillaDLCifraDatosLink', 'notificacionesnetlife@netlife.info.ec', 'NETLIFE-INCORPORACIÓN EN BASE DE CLIENTES ', 'Activo', 'wdsanchez', SYSDATE, '127.0.0.1', NULL, NULL, NULL, 'S', 18, 'Hola! Nos alegra tenerte de vuelta, para continuar con el proceso de instalación ayúdanos dando clic en el siguiente link: {url} para incorporarte en la base de clientes ACTIVOS', 'netsop007', NULL,NULL,NULL);



INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_DLEGAL'), 'CORREO_DESCIFRA', 'NETLIFE-INCORPORACIÓN EN BASE DE CLIENTES ', 'plantillaDLDescifra', 'notificacionesnetlife@netlife.info.ec', NULL, 'Activo', 'wdsanchez', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 18, NULL, NULL, NULL,NULL,NULL);


update DB_GENERAL.ADMI_PARAMETRO_DET set VALOR1= 'ACTUALIZACION DE SOLICITUD DE EJERCICIO DE DERECHOS DEL TITULAR'  where descripcion = 'DATOS_CORREO_CIFRAR';



COMMIT;


/
     
