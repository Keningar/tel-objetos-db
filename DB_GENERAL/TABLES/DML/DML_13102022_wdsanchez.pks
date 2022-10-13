
/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones de proyecto AntiPhishing - PARAMETROS GENERALES ENVIO SMS
 * DESCRIPCION = NOMBRE PARAMETRO
 * VALOR1 = DATA
 * VALOR2 = TIPO DE PARAMETRO
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 13-10-2022 - Versión Inicial.
 */ 
 
UPDATE DB_GENERAL.admi_parametro_det set valor1 = 'CSOC culminó su análisis y su usuario ha sido activado temporalmente. Para completar el proceso de activación revise su correo y siga las indicaciones. Ante alguna duda por favor comunicarse con el departamento del CSOC o al número {cel_CSOC}.', valor2 = 'parametro_sms' where descripcion = 'SMS_USUARIO_ACTIVACION' AND parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING');

UPDATE DB_GENERAL.admi_parametro_det set valor1 = 'CSOC culminó su análisis y su colaborador {user} ha sido activado temporalmente. Para completar su activación revise su correo y siga las indicaciones. Ante alguna duda por favor comunicarse con el departamento del CSOC o al número {cel_CSOC}.', valor2 = 'parametro_sms' where descripcion = 'SMS_JEFE_ACTIVACION' AND parametro_id = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'SMS-JEFE-HABILITACION', 'La investigación del incidente en Seguridad Informática de su colaborador ha concluido, por tal razón, el equipo de CSOC ha habilitado al usuario {user}. Ante alguna duda por favor comunicarse con el departamento del CSOC o al número {cel_CSOC}.', 'parametro_sms', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'SMS-USUARIO-HABILITACION', 'La investigación del incidente en Seguridad Informática ha concluido, por tal razón, el equipo de CSOC ha habilitado su usuario. Ante alguna duda por favor comunicarse con el departamento del CSOC o al número {cel_CSOC}.', 'parametro_sms', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'SMS-JEFE-PHISHING', 'Su colaborador {user} ha sido víctima de phishing, por tal razón, el equipo de CSOC ha {action} a dicho usuario para precautelar la seguridad. Ante alguna duda por favor comunicarse con el departamento del CSOC o al número {cel_CSOC}.', 'parametro_sms', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'SMS-USUARIO-PHISHING', 'Usted ha sido víctima de phishing, por tal razón, el equipo de CSOC ha {action} su usuario, para precautelar la seguridad. Ante alguna duda por favor comunicarse con el departamento del CSOC o al número {cel_CSOC}.', 'parametro_sms', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

COMMIT;
/
