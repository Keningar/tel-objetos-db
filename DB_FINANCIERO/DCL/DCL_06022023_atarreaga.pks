/**
 * @author Alex Arreaga <atarreaga@telconet.ec>
 * @version 1.0
 * @since 06-02-2023 
 * Se crea script DCL para configuraciones de validaciones cliente fase 2.
 */

--Grant para poder consultar la tabla en el esquema financiero.
GRANT SELECT ON DB_SEGURIDAD.SEGU_PERFIL_PERSONA TO DB_FINANCIERO;
GRANT SELECT ON DB_SEGURIDAD.SIST_PERFIL TO DB_FINANCIERO;
GRANT SELECT ON DB_SEGURIDAD.INFO_PERSONA TO DB_FINANCIERO;

COMMIT;
