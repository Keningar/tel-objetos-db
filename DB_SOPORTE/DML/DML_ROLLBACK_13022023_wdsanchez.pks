/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para eliminar nuevo proceso y nueva tarea creados Derecho legal eliminacion
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0
 * @since 20-01-2023 - Versión Inicial.
 */

DELETE FROM Db_Soporte.Admi_Tarea
WHERE
    Nombre_Tarea = 'SOLICITUD DE DESENCRIPTACION'
  AND Estado = 'Activo'
  AND Usr_Creacion = 'wdsanchez';

commit;

/
