/**
 * @author  David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since   01-11-2021    
 * Sentencia DCL para permitir la ejecución de objetos de DB_COMUNICACION desde DB_SOPORTE.
 */
grant execute on DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC to DB_SOPORTE;
grant execute on DB_COMUNICACION.CUKG_COMUNICACIONES_CONSULTA to DB_SOPORTE;
grant select on DB_COMUNICACION.INFO_DOCUMENTO_RELACION to DB_SOPORTE;
grant select ON DB_COMUNICACION.ADMI_CLASE_DOCUMENTO to DB_SOPORTE;
