/**
 * @author  David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since   29-10-2021    
 * Sentencia DCL para eliminar permiso de ejecucion al objeto GNKG_PARAMETRO_CONSULTA desde DB_SOPORTE.
 */
revoke execute ON DB_GENERAL.GNKG_PARAMETRO_CONSULTA FROM DB_FINANCIERO;
revoke execute ON DB_GENERAL.GNKG_PARAMETRO_CONSULTA FROM DB_SOPORTE;
revoke execute on DB_GENERAL.GNKG_EMPRESA_CONSULTA from DB_SOPORTE;
revoke execute on DB_GENERAL.GNKG_TYPES from DB_SOPORTE;

