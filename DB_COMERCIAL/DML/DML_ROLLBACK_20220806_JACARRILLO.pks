/**
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 * @version 1.0
 * @since 04-14-2022  
 * Se crea reverso de configuraciones para transferencia de documentos
 */
SET DEFINE OFF; 
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
	WHERE PARAMETRO_ID IN ( SELECT ID_PARAMETRO
	                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
	                        WHERE NOMBRE_PARAMETRO =  'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
	                        AND ESTADO             = 'Activo')
	                        AND  DESCRIPCION  IN (  'CANTIDAD_PROCESAR', 'ESTADO_FIRMA',   'CANTIDAD_DIAS');

COMMIT;
/