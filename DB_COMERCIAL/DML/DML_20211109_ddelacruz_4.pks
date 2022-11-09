/**
 * DEBE EJECUTARSE EN DB_COMERCIAL
 * Script para crear nueva forma de contacto para aperturar casos desde Extranet
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 
 * @since 09-11-2021 - Versión Inicial.
 */

INSERT INTO Db_Comercial.Admi_Forma_Contacto (
  Id_Forma_Contacto,
  Descripcion_Forma_Contacto,
  Fe_Creacion,
  Usr_Creacion,
  Estado,
  Codigo
) VALUES (
  Db_Comercial.Seq_Admi_Forma_Contacto.Nextval,
  'Extranet',
  Sysdate,
  'ddelacruz',
  'Activo',
  'EXTR'
);

INSERT INTO Db_Comercial.Admi_Caracteristica (
  Id_Caracteristica,
  Descripcion_Caracteristica,
  Tipo_Ingreso,
  Estado,
  Fe_Creacion,
  Usr_Creacion,
  Tipo,
  Detalle_Caracteristica
) VALUES (
  Db_Comercial.Seq_Admi_Caracteristica.Nextval,
  'REFERENCIA_PERSONA',
  'C',
  'Activo',
  SYSDATE,
  'ddelacruz',
  'SOPORTE',
  'Se relaciona con DB_SOPORTE.INFO_TAREA_CARACTERISTICA. Permite asociar una tarea con un cliente (id persona), con el objetivo de relacionar una tarea creada desde Extranet donde no existe relación directa con un punto. Ejemplo: Solicitud de nuevo punto'
);


COMMIT;

/
