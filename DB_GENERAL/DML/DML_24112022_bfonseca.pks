/**
* Inserts de parámetros del paquete NAF47_TNET.GENERAR_IMG_EMPLEADOS_TN 
*
* @author Bryan Fonseca <bfonseca@telconet.ec>
* @version 1.0 24-11-2022
*/
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
		'FOTOS_EMPLEADOS_TN',
		'Parámetros para generación de fotos de empleados de TN en el servidor de base de datos',
		'NAF47_TNET',
		'GENERAR_IMG_EMPLEADOS_TN',
		'Activo',
		'bfonseca',
		sysdate,
		'127.0.0.1',
		'bfonseca',
		sysdate,
		'127.0.0.1'
	);

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
      WHERE NOMBRE_PARAMETRO = 'FOTOS_EMPLEADOS_TN'
      AND ESTADO             = 'Activo'
    ),
    'DIR_FOTOS_EMPLEADOS_TN_DESTINO',
    'fotos_empleados_tn', 'Activo',
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Nombre del directorio que se creará en el servidor de base de datos y contendrá las fotos.');

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
      WHERE NOMBRE_PARAMETRO = 'FOTOS_EMPLEADOS_TN'
      AND ESTADO             = 'Activo'
    ),
    'DIR_FOTOS_EMPLEADOS_TN_BASE',
    'NAF_DIR', 'Activo',
	'bfonseca', SYSDATE, '127.0.0.1', '10', 'DESCRIPCIÓN: Nombre del directorio accesible desde NAF47_TNET.');	

COMMIT;
/