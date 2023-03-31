/**
 * Parámetros para envío de notificación SMS por planificación
 *
 * @author Alex Gómez <algomez@telconet.ec>
 *
 * @version 1.0
 */
 
 UPDATE
	DB_GENERAL.admi_parametro_det
SET
	USR_ULT_MOD = 'algomez',
	FE_ULT_MOD = SYSDATE ,
	VALOR3 = '1001',
	VALOR4 = 'COMPOSE_MESSAGE',
	VALOR5 = 'CONDIG-PLANF',
	OBSERVACION = 'valor3:apiSMS-IdMessage. valor4:apiSMS - SIMPLE_MESSAGE O COMPOSE_MESSAGE, valor5:apiSMS: codProcess'
WHERE
	parametro_id = 1750
	AND EMPRESA_COD = '18';

INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET
(ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	USR_ULT_MOD,
	FE_ULT_MOD,
	IP_ULT_MOD,
	VALOR5,
	EMPRESA_COD,
	VALOR6,
	VALOR7,
	OBSERVACION,
	VALOR8,
	VALOR9)
VALUES(
db_general.seq_admi_parametro_det.nextval,
1750,
'SMS PARA LA PLANIFICACION HAL',
'Bienvenido a Ecuanet, elegiste el dia {{fechaSms}} a las {{horaIni}} para la instalacion de tu servicio. Requieres mayor informacion contactate con tu asesor comercial.',
'S',
'1003',
'COMPOSE_MESSAGE',
'Activo',
'algomez',
sysdate,
'127.0.0.1',
null,
NULL,
NULL,
'CONDIG-PLANF',
'33',
NULL,
NULL,
'valor3:apiSMS-IdMessage. valor4:apiSMS - SIMPLE_MESSAGE O COMPOSE_MESSAGE, valor5:apiSMS: codProcess',
NULL,
NULL);

commit;
/