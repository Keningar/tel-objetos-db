/**
 * @author  Liseth Chunga <lchunga@telconet.ec>
 * @version 1.0
 * @since   02-05-2023
 * Sentencia DCL para eliminar permisos de ejecución de objetos de DB_COMERCIAL desde NAF47_TNET.
 */
REVOKE EXECUTE ON DB_COMERCIAL.CMKG_ARCHIVOS_EMPLEADOS FROM NAF47_TNET;
