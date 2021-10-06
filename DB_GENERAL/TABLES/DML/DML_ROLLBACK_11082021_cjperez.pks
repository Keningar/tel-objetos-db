/**
 *
 * Rollback de parámetros para el proyecto Gestión Documental
 *	 
 * @author Carlos Julio Pérez Quizhpe <cjperez@telconet.ec>
 * @version 1.0 11-08-2021 
 * @version 1.1 16-09-2021
 */
DELETE FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS
  WHERE  CODIGO_APP = 7
    AND  CODIGO_PATH= 1
    AND  APLICACION = 'GestionDocumental'
    AND  PAIS='593'
    AND  EMPRESA='TN'
    AND  MODULO='Gestion'
    AND  SUBMODULO='MisDocumentos'
    AND  ESTADO='Activo';

DELETE FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS
  WHERE  CODIGO_APP = 7
    AND  CODIGO_PATH= 2
    AND  APLICACION = 'GestionDocumental'
    AND  PAIS='593'
    AND  EMPRESA='TN'
    AND  MODULO='Recepcion'
    AND  SUBMODULO='Asignacion'
    AND  ESTADO='Activo';

COMMIT;

/
