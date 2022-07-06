/**
 * @author Jefferson Carrillo <jacarrillo@telconet.ec>
 * @version 1.0
 * @since 07-17-2022  
 * Se crea actualiza valor de parametros
 */
SET DEFINE OFF; 
UPDATE  DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR1=1
WHERE PARAMETRO_ID IN ( SELECT ID_PARAMETRO
	                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
	                        WHERE NOMBRE_PARAMETRO =  'PARAM_FLUJO_TRANSFERENCIA_SECURITY_DATA'
	                        AND ESTADO             = 'Activo')
                            AND DESCRIPCION = 'DIA_PROCESADO';
COMMIT;
/