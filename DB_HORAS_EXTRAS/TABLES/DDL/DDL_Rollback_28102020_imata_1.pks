-- Alter para eliminar campo CUADRILLA_ID de la tabla INFO_TAREAS_HORAS
ALTER TABLE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS DROP COLUMN CUADRILLA_ID;

--Alter para indicar que el campo tarea_id no permita null.
ALTER TABLE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS MODIFY (TAREA_ID NOT NULL);

/*
 * Drop para eliminar el directorio para el esquema db_horas_extras.
 *
 */
drop directory "DIR_REPHEXTRAS";


/
