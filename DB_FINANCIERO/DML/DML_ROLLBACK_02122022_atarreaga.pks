/** 
 * @author Alex Arreaga <atarreaga@telconet.ec>
 * @version 1.0 
 * @since 02-12-2022
 * Se crea DML de reverso de configuraciones para validaciones a clientes.
 */

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET 
SET PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS'),
    VALOR7 = NULL
WHERE PARAMETRO_ID IN (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES')
AND valor7 = 'PUNTO_ADICIONAL' AND EMPRESA_COD = '18'; 

UPDATE DB_GENERAL.ADMI_PARAMETRO_DET 
SET PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS'),
    VALOR7 = NULL
WHERE PARAMETRO_ID IN (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES')
AND valor7 = 'PUNTO_ADICIONAL' AND EMPRESA_COD = '33'; 

--SE ELIMINA PARAMETROS
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
	WHERE PARAMETRO_ID IN ( SELECT ID_PARAMETRO
	                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
	                        WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES'
	                        AND ESTADO             = 'Activo');

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = 'PARAM_CLIENTE_VALIDACIONES';

COMMIT;
/
