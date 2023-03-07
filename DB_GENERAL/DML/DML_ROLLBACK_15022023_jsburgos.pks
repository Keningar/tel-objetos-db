/**
 * Reverso de los parametros para el proceso de migracion olt alta densidad
 *
 * @author Jonathan Burgos <jsburgos@telconet.ec>
 * @version 1.0 15-02-2023
 */

  --Rollbacks
  --Se eliminan el parametro detalle de MIGRACION_OLT_ALTA_DENSIDAD
  -- SE EJECUTA EN DB_GENERAL
DELETE
FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE PARAMETRO_ID =
  (SELECT ID_PARAMETRO
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
  AND ESTADO             = 'Activo'
  );
--Se eliminan el parametro cabecera de MIGRACION_OLT_PARAMETROS
DELETE
FROM DB_GENERAL.ADMI_PARAMETRO_CAB
WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_ALTA_DENSIDAD'
AND ESTADO             = 'Activo'; 

-- ROLLBACK DE RUTA NFS
DELETE 
 FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS
WHERE MODULO = 'Tecnico'
AND SUBMODULO = 'MigracionOltAltaDensidad'
AND ESTADO = 'Activo';

COMMIT;
/
