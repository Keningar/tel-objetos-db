/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para Eliminar detalle de parametros de Actividad para planificación HAL de la empresa Ecuanet.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 01-03-2023 - Versión Inicial.
 */

/* SE ELIMINA ACTIVIDAD */

DELETE 
FROM
	DB_GENERAL.ADMI_PARAMETRO_DET apd
WHERE
	PARAMETRO_ID = (
        SELECT
            ID_PARAMETRO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB apc
        WHERE
            NOMBRE_PARAMETRO = 'PREFERENCIAS_CUADRILLAS_HAL'
        )
	AND USR_CREACION = 'jmazon';


COMMIT;


/
