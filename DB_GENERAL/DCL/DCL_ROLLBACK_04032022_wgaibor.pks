/**
 * Privilegios para que el esquema 'DB_DOCUMENTO' pueda ejecutar
 * los procesos y funciones del paquete 'GNRLPCK_UTIL'
 */
REVOKE EXECUTE  ON DB_GENERAL.GNRLPCK_UTIL FROM DB_DOCUMENTO;
/
