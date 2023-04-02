/**
 *
 * Nuevos parámetros para empresa ecuanet
 *
 * @author Alex Gómez <algomez@telconet.ec>
 * @version 1.0 23-02-2023 
 *
 * Parametros ecuanet
 **/
 
DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.id_parametro_det IN
 (
	SELECT apdx.ID_PARAMETRO_DET 
	FROM
		db_general.admi_parametro_det apdx
	WHERE
		apdx.EMPRESA_COD = 33
		AND apdx.PARAMETRO_ID = 1482
 );

----------------------

DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.id_parametro_det IN
 (
	SELECT apdx.ID_PARAMETRO_DET 
	FROM
		db_general.admi_parametro_det apdx
	WHERE
		apdx.EMPRESA_COD = 33
		AND apdx.PARAMETRO_ID = 1185
 );

-------------------------
UPDATE
	DB_GENERAL.ADMI_PARAMETRO_DET
SET
	USR_ULT_MOD = 'gvelez',
	FE_ULT_MOD = TIMESTAMP '2020-10-08 17:00:58.000000',
	VALOR5 = NULL,
	VALOR6 = NULL,
	VALOR7 = NULL,
	OBSERVACION = 'En valor2 debe configurarse el nombre del proveedor de envío de sms (INFOBIP o MASSEND). valor3: Habilitar envio por Whatsapp(S,N),valor4: Prioridad envio Whatsapp(S,N)(opcional)'
WHERE
	ID_PARAMETRO_DET = 9791;

DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.id_parametro_det IN
 (
	SELECT apdx.ID_PARAMETRO_DET 
	FROM
		db_general.admi_parametro_det apdx
	WHERE
		apdx.EMPRESA_COD = 33
		AND apdx.PARAMETRO_ID = 1067
 );
 
 -------------------------
DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.id_parametro_det IN
 (
	SELECT apdx.ID_PARAMETRO_DET 
	FROM
		db_general.admi_parametro_det apdx
	WHERE
		apdx.EMPRESA_COD = 33
		AND apdx.PARAMETRO_ID = 1798
 );
 
 -------------------------
DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.id_parametro_det IN
 (
	SELECT apdx.ID_PARAMETRO_DET 
	FROM
		db_general.admi_parametro_det apdx
	WHERE
		apdx.EMPRESA_COD = 33
		AND apdx.PARAMETRO_ID = 1024
 );
 
 -------------------------
DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.id_parametro_det IN
 (
	SELECT apdx.ID_PARAMETRO_DET 
	FROM
		db_general.admi_parametro_det apdx
	WHERE
		apdx.EMPRESA_COD = 33
		AND apdx.PARAMETRO_ID = 1835
 );
 
 -------------------------
DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.id_parametro_det IN
 (
	SELECT apdx.ID_PARAMETRO_DET 
	FROM
		db_general.admi_parametro_det apdx
	WHERE
		apdx.EMPRESA_COD = 33
		AND apdx.PARAMETRO_ID = 1743
 );
 
 

-------NUEVOS PARAMETROS ------------
DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.PARAMETRO_ID =
 (
	SELECT apc.ID_PARAMETRO 
	FROM
		db_general.admi_parametro_cab apc
	WHERE
		apc.NOMBRE_PARAMETRO = 'DOCUMENTOS_CONTRATO_EMPRESA'
 );
 
 DELETE
 FROM
		db_general.admi_parametro_cab apc
	WHERE
		apc.NOMBRE_PARAMETRO = 'DOCUMENTOS_CONTRATO_EMPRESA';


------NUEVOS PARAMETROS POR APROBACION DE CONTRATO DESDE CRONTAB

DELETE
FROM
	db_general.admi_parametro_det apd
WHERE
	apd.PARAMETRO_ID =
 (
	SELECT apc.ID_PARAMETRO 
	FROM
		db_general.admi_parametro_cab apc
	WHERE
		apc.NOMBRE_PARAMETRO = 'APROBACION_CONTRATO_COMMAND'
 );
 
 DELETE
 FROM
		db_general.admi_parametro_cab apc
	WHERE
		apc.NOMBRE_PARAMETRO = 'APROBACION_CONTRATO_COMMAND';


commit;
/
