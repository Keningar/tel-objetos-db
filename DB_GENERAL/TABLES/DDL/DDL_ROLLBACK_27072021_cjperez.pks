/**
 * Rollback para crear la columna INFO_DOCUMENTO.UBICACION_FISICA_DOCUMENTO 
 * para guardar la ruta del documento en el servidor NFS,
 * empleado en el proyecto Gestión Documental.
 *	 
 * @author Carlos Julio Pérez Quizhpe <cjperez@telconet.ec>
 * @version 1.0 27-07-2021
 */
ALTER TABLE DB_DOCUMENTAL.INFO_DOCUMENTO
   DROP COLUMN UBICACION_FISICA_DOCUMENTO;

COMMIT;
/
