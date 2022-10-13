/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Rollback para los parametros utilizados para proceso Anti-Phishing envio sms
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 13-10-2022 - Versión Inicial.
 */
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET B WHERE B.PARAMETRO_ID IN (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING') and valor2 = 'parametro_sms';

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'SMS_USUARIO_ACTIVACION', 'Cert culminó su análisis y su usuario ha sido activado temporalmente. Para completar el proceso de activación revise su correo y siga las indicaciones.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL, (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAMETROS_PHISHING'), 'SMS_JEFE_ACTIVACION', 'Cert culminó su análisis y su colaborador {user} ha sido activado temporalmente. Para completar su activación revise su correo y siga las indicaciones.', 'parametro', NULL, NULL, 'Activo', 'jihidalgo', SYSDATE, '127.0.0.1', NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL);


COMMIT;
/
