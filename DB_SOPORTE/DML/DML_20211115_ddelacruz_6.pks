/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para crear nuevo proceso y nueva tarea para crear tareas desde Extranet
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 
 * @since 15-11-2021 - Versión Inicial.
 */

INSERT INTO Db_Soporte.Admi_Proceso (
  Id_Proceso,
  Nombre_proceso,
  Descripcion_Proceso,
  Aplica_Estado,
  Estado,
  Usr_Creacion,
  Fe_Creacion,
  Usr_Ult_Mod,
  Fe_Ult_Mod,
  Visible,
  Planmantenimiento
) VALUES (
  Db_Soporte.Seq_Admi_Proceso.Nextval,
  'EXTRANET - PROCESO GENERAL',
  'Proceso general para tareas solicitadas por clientes desde Extranet',
  'N/A',
  'Activo',
  'ddelacruz',
  sysdate,
  'ddelacruz',
  sysdate,
  'NO',
  'N'
);

INSERT INTO Db_Soporte.Admi_Tarea (
  Id_Tarea,
  Proceso_id,
  Nombre_Tarea,
  Descripcion_Tarea,
  Estado,
  Fe_Creacion,
  Usr_Creacion,
  Fe_Ult_Mod,
  Usr_Ult_Mod,
  Visualizar_Movil
) VALUES (
  Db_Soporte.Seq_Admi_Tarea.Nextval,
  (select id_proceso from Db_Soporte.Admi_Proceso where nombre_proceso = 'EXTRANET - PROCESO GENERAL'),
  'EXTRANET - TAREA GENERAL',
  'Tarea general solicitada por cliente desde Extranet',
  'Activo',
  SYSDATE,
  'ddelacruz',
  SYSDATE,
  'ddelacruz',
  'N'
);

COMMIT;

/
