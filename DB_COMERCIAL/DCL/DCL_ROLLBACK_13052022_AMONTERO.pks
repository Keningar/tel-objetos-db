/*
 * SCRIPT  DEL ESQUEMA DB_COMERCIAL. 
 * REMUEVE PERMISOS DE EJECUCION Y LISTADO DEL ESQUEMA  DB_COMERCIAL AL ESQUEMA DB_SOPORTE
 */


REVOKE EXECUTE ON DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION FROM DB_SOPORTE;


/