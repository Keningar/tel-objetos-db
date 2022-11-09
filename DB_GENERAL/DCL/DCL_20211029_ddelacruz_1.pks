/**
 * @author  David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since   29-10-2021    
 * Sentencia DCL para agregar permiso de ejecucion al objeto GNKG_PARAMETRO_CONSULTA desde DB_SOPORTE.
 */
grant execute on DB_GENERAL.GNKG_PARAMETRO_CONSULTA to DB_SOPORTE;
grant execute on DB_GENERAL.GNKG_PARAMETRO_CONSULTA to DB_FINANCIERO;
grant execute on DB_GENERAL.GNKG_EMPRESA_CONSULTA to DB_SOPORTE;
grant execute on DB_GENERAL.GNKG_TYPES to DB_SOPORTE;

