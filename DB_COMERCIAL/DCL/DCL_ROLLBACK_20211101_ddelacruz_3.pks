/**
 * @author  David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0
 * @since   01-11-2021    
 * Sentencia DCL para eliminar permisos de ejecución de objetos de DB_COMERCIAL desde DB_SOPORTE.
 */
revoke execute on DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_C from DB_SOPORTE;
revoke execute on DB_COMERCIAL.CMKG_ADMI_FORMA_CONTACTO_C from DB_SOPORTE;
revoke execute on DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_C from DB_SOPORTE;
revoke execute on DB_COMERCIAL.CMKG_PERSONA_CONSULTA from DB_SOPORTE;
revoke execute on DB_COMERCIAL.CMKG_CONSULTA_CLIENTE from DB_SOPORTE;
revoke select on DB_COMERCIAL.INFO_EMPRESA_GRUPO from DB_SOPORTE;
