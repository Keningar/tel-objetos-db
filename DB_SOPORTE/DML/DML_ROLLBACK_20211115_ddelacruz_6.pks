/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para eliminar nuevo proceso y nueva tarea creados para Extranet
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since 15-11-2021 - Versión Inicial.
 */

DELETE FROM Db_Soporte.Admi_Tarea
WHERE
    Nombre_Tarea = 'EXTRANET - TAREA GENERAL'
  AND Estado = 'Activo'
  AND Usr_Creacion = 'ddelacruz';

DELETE FROM Db_Soporte.Admi_Proceso
WHERE
    Nombre_proceso = 'EXTRANET - PROCESO GENERAL'
  AND Estado = 'Activo'
  AND Usr_Creacion = 'ddelacruz';  

commit;

/
