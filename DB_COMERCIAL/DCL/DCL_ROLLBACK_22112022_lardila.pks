/*
 * SCRIPT  DEL ESQUEMA DB_COMERCIAL. 
 * REMUEVE PERMISOS DE EJECUCION Y LISTADO DEL ESQUEMA  DB_COMERCIAL AL ESQUEMA DB_SOPORTE
 */


REVOKE SELECT ON DB_COMERCIAL.INFO_DETALLE_SOL_PLANIF     FROM DB_SOPORTE;

/