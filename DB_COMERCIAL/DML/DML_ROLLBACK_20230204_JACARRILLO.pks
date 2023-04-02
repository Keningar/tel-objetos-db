
/**
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 * @version 1.0
 * @since 04-02-2023 
 * Se crea reverso de configuraciones para parametro PROVEEDOR_EMPRESA
 */
SET DEFINE OFF; 
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
	WHERE PARAMETRO_ID IN ( SELECT ID_PARAMETRO
	                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
	                        WHERE NOMBRE_PARAMETRO = 'PARAMETROS_FORMULARIOS_COMERCIAL_CREDENCIAL'
	                        AND ESTADO             = 'Activo')
                            AND DESCRIPCION =    'PROVEEDOR_EMPRESA';
 

COMMIT;
/
