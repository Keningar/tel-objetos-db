/*
 * SCRIPT DCL DEL ESQUEMA DB_COMERCIAL. 
 */
GRANT SELECT  ON DB_COMERCIAL.INFO_SOLUCION_CAB           TO DB_INFRAESTRUCTURA;
GRANT SELECT  ON DB_COMERCIAL.INFO_SOLUCION_DET           TO DB_INFRAESTRUCTURA;
GRANT SELECT  ON DB_COMERCIAL.INFO_SERVICIO_RECURSO_CAB   TO DB_INFRAESTRUCTURA;
GRANT SELECT  ON DB_COMERCIAL.INFO_SERVICIO_RECURSO_DET   TO DB_INFRAESTRUCTURA;
GRANT EXECUTE ON DB_COMERCIAL.CMKG_SOLUCIONES_TRANSACCION TO DB_INFRAESTRUCTURA;
GRANT EXECUTE ON DB_COMERCIAL.CMKG_SOLICITUD_TRANSACCION  TO DB_INFRAESTRUCTURA;
GRANT EXECUTE ON DB_COMERCIAL.CMKG_SERVICIO_TRANSACCION   TO DB_INFRAESTRUCTURA;
/