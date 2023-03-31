/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para Rollback detalle de parametros para flujo de Rechazar orden de trabajo y anulacion para internet con empresa Ecuanet.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 02-03-2023 - Versión Inicial.
 */

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE 
PARAMETRO_ID =   (SELECT id_parametro FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                  WHERE NOMBRE_PARAMETRO = 'PROMOCION ANCHO BANDA'
                  AND ESTADO = 'Activo')
AND DESCRIPCION IN ('Estados permitidos para anular la promocion', 'Datos para webservices de detener promocion')
AND USR_CREACION =  'emartillo'
AND EMPRESA_COD  = '33';


COMMIT;
/