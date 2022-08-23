/**
 * DEBE EJECUTARSE EN DB_COMERCIAL.
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 21-07-2022 - Versión Inicial.
 */
GRANT INSERT ON DB_COMERCIAL.INFO_SERVICIO_HISTORIAL TO DB_FINANCIERO;
GRANT UPDATE ON DB_COMERCIAL.INFO_PUNTO TO DB_FINANCIERO;
GRANT EXECUTE ON DB_COMERCIAL.TECNK_SERVICIOS TO DB_FINANCIERO;

/**
 * DEBE EJECUTARSE EN DB_INFRAESTRUCTURA.
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 21-07-2022 - Versión Inicial.
 */
GRANT EXECUTE ON DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES TO DB_FINANCIERO;
COMMIT;
/