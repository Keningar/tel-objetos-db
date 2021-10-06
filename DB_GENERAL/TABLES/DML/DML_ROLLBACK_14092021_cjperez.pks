/**
 *
 * Rollback de mensajes personalizados para los diálogos y ventanas emergentes 
 * para el proyecto Gestión Documental
 *	 
 * @author Carlos Julio Pérez Quizhpe <cjperez@telconet.ec>
 * @version 1.0 14-09-2021
 */

DELETE DB_DOCUMENTAL.SIST_RESOURCE_BUNDLE
WHERE USR_CREACION = 'cjperez' AND CODIGO = 'element.delete.undo';

COMMIT;
/
