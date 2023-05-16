/**
 * @author  Pedro Velez <psvelez@telconet.ec>
 * @version 1.0
 * @since   20-03-2023    
 * rollback de permiso de select a tabla  DB_COMERCIAL.INFO_PUNTO para usuario  DB_GENERAL.
 */

revoke select  on DB_COMERCIAL.INFO_PUNTO to DB_GENERAL;

/