/**
 * @author  David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since   01-11-2021    
 * Sentencia DCL para permitir la ejecución de objetos de DB_COMERCIAL desde DB_SOPORTE.
 */
grant execute on DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_C to DB_SOPORTE;
grant execute on DB_COMERCIAL.CMKG_ADMI_FORMA_CONTACTO_C to DB_SOPORTE;
grant execute on DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_C to DB_SOPORTE;
grant execute on DB_COMERCIAL.CMKG_PERSONA_CONSULTA to DB_SOPORTE;
grant execute on DB_COMERCIAL.CMKG_CONSULTA_CLIENTE to DB_SOPORTE;
grant select on DB_COMERCIAL.INFO_EMPRESA_GRUPO to DB_SOPORTE;
