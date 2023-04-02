/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para insertar relación del proceso con la Empresa.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 01-03-2023 - Versión Inicial.
 */

/*INSERT DE RELACIÓN DE PROCESO CON EMPRESA ECUANET*/

INSERT
	INTO
	DB_SOPORTE.ADMI_PROCESO_EMPRESA (ID_PROCESO_EMPRESA,
	PROCESO_ID,
	EMPRESA_COD,
	ESTADO,
	USR_CREACION,
	FE_CREACION)
VALUES (DB_SOPORTE.SEQ_ADMI_PROCESO_EMPRESA.NEXTVAL,
120,
'33',
'Activo',
'mpluas',
SYSDATE); 


COMMIT;


/


