/**
 *
 * Rollback de parámetros del query para mover archivos a NFS
 * para el proyecto Gestión Documental
 *	 
 * @author Carlos Julio Pérez Quizhpe <cjperez@telconet.ec>
 * @version 1.0 12-08-2021 
 */
DELETE DB_GENERAL.ADMI_PARAMETRO_DET
WHERE
    PARAMETRO_ID = (
        SELECT
            ID_PARAMETRO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE
            NOMBRE_PARAMETRO = 'QUERIES_PARA_MOVER_ARCHIVOS_A_NUEVO_NFS_GD'
    );

DELETE DB_GENERAL.ADMI_PARAMETRO_CAB
WHERE NOMBRE_PARAMETRO = 'QUERIES_PARA_MOVER_ARCHIVOS_A_NUEVO_NFS_GD';

COMMIT;

/
