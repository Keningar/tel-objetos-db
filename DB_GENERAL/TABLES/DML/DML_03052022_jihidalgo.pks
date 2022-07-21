/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones de proyecto AntiPhishing - ROLES
 * DESCRIPCION = TIPO ROL
 * VALOR1 = LOGIN
 * VALOR2 = TIPO DE PARAMETRO
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 22-04-2022 - Versión Inicial.
 */
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL, 'PARAMETROS_PHISHING', 'PARAMETROS AUXILIARES QUE INTERACTUAN CON PHISHING','SEGURIDAD', NULL,'Activo','jihidalgo',SYSDATE,'127.0.0.1', NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'ROL_AUTORIZADOR', 'jihidalgo', 'rol', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'ROL_SOLICITANTE', 'jihidalgo', 'rol', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones de proyecto AntiPhishing - PARAMETROS GENERALES
 * DESCRIPCION = NOMBRE PARAMETRO
 * VALOR1 = DATA
 * VALOR2 = TIPO DE PARAMETRO
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 22-04-2022 - Versión Inicial.
 */ 
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'DOMINIOS_RESTRINGIDOS', 'telconet;netlife;tesoterra', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'TIEMPO_HORA_EXP_TOKEN', 8, 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'CEL_CSOC', '0994111009', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'CORREO_CSOC', 'csoc@telconet.ec', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'NOTIFICACION_USUARIO_PHISHING', 'Usted ha sido víctima de phishing, por tal razón, el equipo de CERT ha {action} su usuario, para precautelar la seguridad.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'NOTIFICACION_JEFE_PHISHING', 'Su colaborador {user} ha sido víctima de phishing, por tal razón, el equipo de CERT ha {action} a dicho usuario para precautelar la seguridad.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'NOTIFICACION_USUARIO_HABILITACION', 'La investigación del incidente en Seguridad Informática ha concluido, por tal razón, el equipo de CERT ha habilitado su usuario.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'NOTIFICACION_JEFE_HABILITACION', 'La investigación del incidente en Seguridad Informática de su colaborador ha concluido, por tal razón, el equipo de CERT ha habilitado al usuario {user}.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'NOTIFICACION_USUARIO_ACTIVACION', 'La investigación del incidente en Seguridad Informática ha concluido, por tal razón, el equipo de CERT ha reactivado su usuario. La contraseña temporal generada para que ingrese a la VPN es {password} cuya vigencia será de {tokenTime} horas a partir de la recepción del presente correo/sms, en caso de no logonearse en ese tiempo, deberá solicitar otra contraseña temporal para ingresar a la VPN. El siguiente link le permitirá resetear su contraseña, recuerde que el link se autodestruirá después de {tokenTime} horas: {link}', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'NOTIFICACION_JEFE_ACTIVACION', 'La investigación del incidente en Seguridad Informática de su colaborador ha concluido, por tal razón, el equipo de CERT ha reactivado al usuario {user}. La contraseña temporal generada para que su colaborador ingrese a la VPN es {password} cuya vigencia será de {tokenTime} horas a partir de la recepción del presente correo/sms, en caso de no logonearse en ese tiempo, deberá solicitar otra contraseña a CERT. El siguiente link le permitirá resetear su contraseña, recuerde que el link se autodestruirá después de {tokenTime} horas: {link}', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'SMS_USUARIO_ACTIVACION', 'Cert culminó su análisis y su usuario ha sido activado temporalmente. Para completar el proceso de activación revise su correo y siga las indicaciones.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'SMS_JEFE_ACTIVACION', 'Cert culminó su análisis y su colaborador {user} ha sido activado temporalmente. Para completar su activación revise su correo y siga las indicaciones.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'TEXTO_ACT_INFO_USUARIO', 'Por favor confirme si sus datos personales están actualizados, en caso de no ser así, por favor actualícelos. Recuerde que esta información será utilizada para enviar notificaciones en caso que usted caiga en algún incidente de seguridad informática.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'TEXTO_PAGINA_EXPIRADA_USUARIO', 'El tiempo para resetear la contraseña es de máximo {tokenTime} horas después del envío de la clave temporal (generada el {fechaToken}), usted lamentablemente se ha excedido de ese tiempo por tal motivo este link ha expirado, por favor, para resetear su contraseña comuníquese con CERT al número 0999999999 o al correo electrónico cert@telconet.ec para el envío de una nueva contraseña temporal para ingresar a la VPN.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

COMMIT;
/
