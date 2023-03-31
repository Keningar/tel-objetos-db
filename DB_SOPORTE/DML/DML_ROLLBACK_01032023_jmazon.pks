/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para Eliminar relación del proceso con la Empresa.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 01-03-2023 - Versión Inicial.
 */

/*ROLLBACK DE ADMI PROCESO EMPRESA PARA ECUANET*/

DELETE
FROM
	DB_SOPORTE.ADMI_PROCESO_EMPRESA
WHERE
	PROCESO_ID = 120
	AND EMPRESA_COD = 33
	AND USR_CREACION = 'mpluas';




COMMIT;


/


