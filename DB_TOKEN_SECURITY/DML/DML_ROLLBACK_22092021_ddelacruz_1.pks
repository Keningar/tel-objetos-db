/**
 * DEBE EJECUTARSE EN DB_TOKENSECURITY
 * Script para eliminar registros creados para que la aplicacion "Generador de Portales Cautivos"
 * se integre con generacion y validacion de Token
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 
 * @since 22-09-2021
 */

--Configurar Usuario/Clave PORTAL_CAUTIVO/PORTAL_CAUTIVO(sha256)
DELETE FROM db_tokensecurity.user_token
WHERE
    application_id = (
        SELECT
            id_application
        FROM
            db_tokensecurity.application
        WHERE
                name = 'APP.PORTAL_CAUTIVO'
            AND status = 'ACTIVO'
    );

--Eliminar clase GestionLdapWSController relacionada con el APP.PORTAL_CAUTIVO
DELETE FROM db_tokensecurity.web_service
WHERE
    id_application = (
        SELECT
            id_application
        FROM
            db_tokensecurity.application
        WHERE
                name = 'APP.PORTAL_CAUTIVO'
            AND status = 'ACTIVO'
    );

--Eliminar Aplicacion 
DELETE FROM db_tokensecurity.application
WHERE
        name = 'APP.PORTAL_CAUTIVO'
    AND status = 'ACTIVO';

COMMIT;
/