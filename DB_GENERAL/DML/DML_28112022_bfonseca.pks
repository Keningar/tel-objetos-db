/**
* Inserts de: 
* - Parámetros usados por el paquete DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE 
* - Parámetros usados por el paquete DB_COMERCIAL.CMKG_REPORTES_GERENCIALES al interactuar con DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE
*
* @author Bryan Fonseca <bfonseca@telconet.ec>
* @version 1.0 28-11-2022
*/

SET DEFINE OFF;
/

------------------------------ Telcodrive -------------------------------
-- Parametros usados en paquete de Telcodrive: paths y URLs.
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
	(
		ID_PARAMETRO,
		NOMBRE_PARAMETRO,
		DESCRIPCION,
		MODULO,
		PROCESO,
		ESTADO,
		USR_CREACION,
		FE_CREACION,
		IP_CREACION,
		USR_ULT_MOD,
		FE_ULT_MOD,
		IP_ULT_MOD		
	)
	VALUES
	(
		DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
		'INTEGRACION_TELCODRIVE',
		'Parámetros para comunicación entre el API de telcodrive y la base de datos. Los paths que requieren placeholders son del tipo foo/{bar_id}/baz',
		'GENERAL',
		'REPORTES_GERENCIALES',
		'Activo',
		'bfonseca',
		sysdate,
		'127.0.0.1',
		'bfonseca',
		sysdate,
		'127.0.0.1'
	);

-- Host al que se realizan las peticiones, cambiar en producción.
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'INTEGRACION_TELCODRIVE'
      AND ESTADO             = 'Activo'
    ),
    'HOST_TELCODRIVE_BASE',
    'http://telcos-ws-ext-lb.telconet.ec/telcodrive/', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Host al que se realizarán las peticiones.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'INTEGRACION_TELCODRIVE'
      AND ESTADO             = 'Activo'
    ),
    'HOST_TELCODRIVE_PRODUCCION',
    'https://telcodrive.telconet.net/', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Host de producción de Telcodrive.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'INTEGRACION_TELCODRIVE'
      AND ESTADO             = 'Activo'
    ),
    'PATH_GET_SHARE_LINK',
    'api/v2.1/smart-link/?repo_id={repo_id}&path={path}&is_dir={is_dir}', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: path que se combinará con host de Telcodrive para realizar petición de obtener link para compartir.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'INTEGRACION_TELCODRIVE'
      AND ESTADO             = 'Activo'
    ),
    'PATH_GET_UPLOAD_LINK',
    'api2/repos/{repo_id}/upload-link/', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: path que se combinará con host de Telcodrive para realizar petición de obtener link de subida.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'INTEGRACION_TELCODRIVE'
      AND ESTADO             = 'Activo'
    ),
    'PATH_LIST_REPOS',
    'api/v2.1/repos/', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: path que se combinará con host de Telcodrive para realizar petición de obtener listado de repos de Telcodrive.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'INTEGRACION_TELCODRIVE'
      AND ESTADO             = 'Activo'
    ),
    'PATH_AUTHENTICATION',
    'api2/auth-token/', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: path que se combinará con host de Telcodrive para realizar petición de autenticación en Telcodrive.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'INTEGRACION_TELCODRIVE'
      AND ESTADO             = 'Activo'
    ),
    'PATH_SHARE_REPO',
    'api2/repos/{repo_id}/dir/shared_items/?p=/', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: path que se combinará con host de Telcodrive para realizar petición de compartir repositorios.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'INTEGRACION_TELCODRIVE'
      AND ESTADO             = 'Activo'
    ),
    'REMITENTE_NOTIFICACION',
    'notificaciones_telcos@telconet.ec', 'Activo',
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: correo electrónico remitente de los mails de notificación al subir archivos a Telcodrive.');

-- Cabecera referenciada por los reportes generados
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
	(
		ID_PARAMETRO,
		NOMBRE_PARAMETRO,
		DESCRIPCION,
		MODULO,
		PROCESO,
		ESTADO,
		USR_CREACION,
		FE_CREACION,
		IP_CREACION,
		USR_ULT_MOD,
		FE_ULT_MOD,
		IP_ULT_MOD		
	)
	VALUES
	(
		DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
		'REPORTES_GENERADOS',
		'Reportes gerenciales generados por JOB_REPGER_REPORTCOMERCIAL.',
		'GENERAL',
		'REPORTES_GERENCIALES',
		'Activo',
		'bfonseca',
		sysdate,
		'127.0.0.1',
		'bfonseca',
		sysdate,
		'127.0.0.1'
	);
	
-- Cabecera para parámetros específicos de reportes gerenciales, como nombre de repo y credenciales etc.
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
	(
		ID_PARAMETRO,
		NOMBRE_PARAMETRO,
		DESCRIPCION,
		MODULO,
		PROCESO,
		ESTADO,
		USR_CREACION,
		FE_CREACION,
		IP_CREACION,
		USR_ULT_MOD,
		FE_ULT_MOD,
		IP_ULT_MOD		
	)
	VALUES
	(
		DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
		'REPORTES_GERENCIALES',
		'Parámetros específicos para el proceso de generación de reportes gerenciales y su integración con Telcodrive.',
		'GENERAL',
		'REPORTES_GERENCIALES',
		'Activo',
		'bfonseca',
		sysdate,
		'127.0.0.1',
		'bfonseca',
		sysdate,
		'127.0.0.1'
	);

-- Usuario cuenta Telcodrive
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'USER',
    'telcodrive-sis@telconet.ec', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Usuario de la cuenta de Telcodrive que alojará los reportes.');

-- Contraseña cuenta Telcodrive
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'PASSWORD',
    'jDfGYO3AqR', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Contraseña de la cuenta de Telcodrive que alojará los reportes.');

-- Nombre Repo donde se subirán los reportes gerenciales en Telcodrive
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'NOMBRE_REPO',
    'Reportes', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Nombre de repositorio donde se subirán los reportes gerenciales en Telcodrive.');

-- Nombre directorio donde se generan los reportes gerenciales
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'NOMBRE_DIRECTORIO',
    'DIR_REPGERENCIA', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Nombre de directorio en base de datos donde se generan los reportes gerenciales.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'IDENT_MUNICIPIO',
    '0960000220001', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: RUC ident municipio.');
	
-- Cabecera para destinatarios a los cuales se les compartirá el repositorio de reportes gerenciales
-- Y se notificarán mediante correo cuando un reporte se haya generado y subido.
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
	(
		ID_PARAMETRO,
		NOMBRE_PARAMETRO,
		DESCRIPCION,
		MODULO,
		PROCESO,
		ESTADO,
		USR_CREACION,
		FE_CREACION,
		IP_CREACION,
		USR_ULT_MOD,
		FE_ULT_MOD,
		IP_ULT_MOD		
	)
	VALUES
	(
		DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
		'DESTINATARIOS_REPORTES_GERENCIALES',
		'Destinatarios a los que se les notificará que los reportes gerenciales están subidos en Telcodrive.',
		'GENERAL',
		'REPORTES_GERENCIALES',
		'Activo',
		'bfonseca',
		sysdate,
		'127.0.0.1',
		'bfonseca',
		sysdate,
		'127.0.0.1'
	);

-- EMAIL_NOTIFICACION
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'DESTINATARIOS_REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_NOTIFICACION',
    'notificaciones_telcos@telconet.ec', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Correo al que se notificará cuando se suban los reportes a Telcodrive');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'DESTINATARIOS_REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_NOTIFICACION',
    'vrodriguez@telconet.ec', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Nombre de directorio en base de datos donde se generan los reportes gerenciales.');	

-- EMAIL_GERENCIA
-- TODO: usar los correos de los gerentes en producción
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'DESTINATARIOS_REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_GERENCIA',
    'ttopic@telconet.ec', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Correo de gerente que se notificará cuando se suban reportes a Telcodrive.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'DESTINATARIOS_REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_GERENCIA',
    'jmsuarez@telconet.ec', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Correo de gerente que se notificará cuando se suban reportes a Telcodrive.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'DESTINATARIOS_REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_GERENCIA',
    'gvillalba@telconet.ec', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Correo de gerente que se notificará cuando se suban reportes a Telcodrive.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'DESTINATARIOS_REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_GERENCIA',
    'vrodriguez@telconet.ec', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Correo de gerente que se notificará cuando se suban reportes a Telcodrive.');

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD,
    OBSERVACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'DESTINATARIOS_REPORTES_GERENCIALES'
      AND ESTADO             = 'Activo'
    ),
    'EMAIL_GERENCIA',
    'apenaherrera@telconet.ec', 'Activo', 
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Correo de gerente que se notificará cuando se suban reportes a Telcodrive.');

COMMIT;
/