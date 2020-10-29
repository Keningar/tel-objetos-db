/**
 * DEBE EJECUTARSE EN DB_HORAS_EXTRAS.
 * @author Ivan Mata <imata@telconet.ec>
 * @version 1.0 28-10-2020 - Versión Inicial.
 */




 -- Alter para agregar campo cuadrilla_id a la tabla INFO_TAREAS_HORAS
ALTER TABLE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS ADD CUADRILLA_ID NUMBER;
COMMENT ON COLUMN DB_HORAS_EXTRAS.INFO_TAREAS_HORAS.CUADRILLA_ID is 'Campo para guardar el id de una cuadrilla';

--Alter para indicar que el campo tarea_id permita null.
ALTER TABLE DB_HORAS_EXTRAS.INFO_TAREAS_HORAS MODIFY (TAREA_ID NULL);

--CREAR DIRECTORIO DIR_REPHEXTRAS EN DB_HORAS_EXTRAS
create or replace directory DIR_REPHEXTRAS as '/base/';

/

