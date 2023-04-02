/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para Eliminar detalle que permite flujo de restricción al cambiar puerto elemento con estado Restringido para ECUANET.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 01-03-2023 - Versión Inicial.
 */

/*ROLLBACK PARA LOS PARAMETROS USADOS PARA LA RESTRICCIÓN DE ELEMENTOS */
DELETE
FROM
	DB_GENERAL.ADMI_PARAMETRO_DET
WHERE
	PARAMETRO_ID = 959
	AND VALOR1 = '33'
	AND VALOR2 = 'EN'
	AND USR_CREACION = 'jmazon';



COMMIT;


/
     
