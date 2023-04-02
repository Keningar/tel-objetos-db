/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para insertar detalle que permite flujo de restricción al cambiar puerto elemento con estado Restringido para ECUANET.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 01-03-2023 - Versión Inicial.
 */ 

/*PARAMETROS USADOS PARA LA RESTRICCIÓN DE ELEMENTOS*/
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
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL ,
959,
'RESTRICCION_FACTIBILIDAD_EMPRESA',
'33',
'EN',
NULL,
NULL,
'Activo',
'jmazon',
SYSDATE,
'127.0.0.1',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL);


COMMIT;


/
     