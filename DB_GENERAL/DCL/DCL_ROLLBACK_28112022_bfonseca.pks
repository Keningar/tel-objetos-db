/**
* Se remueven permisos de ejecución del paquete DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE al esquema DB_COMERCIAL
*/
REVOKE execute ON DB_GENERAL.GNKG_INTEGRACION_TELCODRIVE FROM DB_COMERCIAL; 
/