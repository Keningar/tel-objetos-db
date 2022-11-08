/**
 * @author  David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since   01-11-2021    
 * Sentencia DCL para eliminar permisos de ejecución de objetos de DB_COMUNICACION desde DB_SOPORTE.
 */
revoke execute on DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC from DB_SOPORTE;
revoke execute on DB_COMUNICACION.CUKG_COMUNICACIONES_CONSULTA from DB_SOPORTE;
revoke select on DB_COMUNICACION.INFO_DOCUMENTO_RELACION from DB_SOPORTE;
revoke select ON DB_COMUNICACION.ADMI_CLASE_DOCUMENTO from DB_SOPORTE;
