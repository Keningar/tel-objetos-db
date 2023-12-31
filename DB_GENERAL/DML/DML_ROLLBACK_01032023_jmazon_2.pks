/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para Eliminar cabecera y detalle que permite el flujo al consumir WebService con ECUANET.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 01-03-2023 - Versión Inicial.
 */

/*ROLLBACK PARA LOS PARAMETROS QUE REQUIERE EL FLUJO DEL WS INFORMACIONCLIENTEACS*/
DELETE
FROM
	DB_GENERAL.ADMI_PARAMETRO_DET
WHERE
	VALOR1 = 'PARAMETROS_WEB_SERVICES_ACS'
	AND EMPRESA_COD = 33
	AND USR_CREACION = 'jmazon';
	

/*ROLLBACK PARA LOS PARAMETROS QUE REQUIERE EL FLUJO DEL WS INFORMACIONCLIENTE*/
DELETE
FROM
	DB_GENERAL.ADMI_PARAMETRO_DET
WHERE
	VALOR1 = 'PARAMETROS_WEB_SERVICES'
	AND EMPRESA_COD = 33
	AND USR_CREACION = 'jmazon';




COMMIT;


/
     
