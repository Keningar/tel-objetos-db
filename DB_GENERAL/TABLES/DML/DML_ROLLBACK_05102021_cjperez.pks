/**
 *
 * Quitar permisos para consultar tablas al ejecutar el script Java 
 * de migración para el proyecto Gestión Documental.
 *	 
 * @author Carlos Julio Pérez Quizhpe <cjperez@telconet.ec>
 * @version 1.0 05-10-2021
 */

REVOKE SELECT on db_general.admi_parametro_cab FROM DB_DOCUMENTAL ;
REVOKE SELECT on db_general.admi_parametro_det FROM DB_DOCUMENTAL ;
/
