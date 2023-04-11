/**
 * DEBE EJECUTARSE EN DB_TOKENSECURITY
 * Script para que la aplicacion "Generador de Portales Cautivos" se integre con generacion y validacion de Token
 * @author David De La Cruz <ddelacruz@telconet.ec>
 * @version 1.0 
 * @since 22-09-2021
 */

--Crear Aplicacion 
INSERT INTO db_tokensecurity.application (
    id_application,
    name,
    status,
    expired_time
) VALUES (
    db_tokensecurity.seq_application.nextval,
    'APP.PORTAL_CAUTIVO',
    'ACTIVO',
    30
);

--Configurar clase GestionLdapWSController y relacionarlo con el APP.PORTAL_CAUTIVO
INSERT INTO db_tokensecurity.web_service (
    id_web_service,
    service,
    method,
    generator,
    status,
    id_application
) VALUES (
    db_tokensecurity.seq_web_service.nextval,
    'GestionLdapWSController',
    'procesarAction',
    1,
    'ACTIVO',
    (
        SELECT
            id_application
        FROM
            db_tokensecurity.application
        WHERE
                name = 'APP.PORTAL_CAUTIVO'
            AND status = 'ACTIVO'
    )
);

--Configurar Usuario/Clave PORTAL_CAUTIVO/PORTAL_CAUTIVO(sha256)
INSERT INTO db_tokensecurity.user_token (
    id_user_token,
    username,
    password,
    estado,
    application_id
) VALUES (
    db_tokensecurity.seq_user_token.nextval,
    'PORTAL_CAUTIVO',
    '11B3F02BFB1779DB01CD2BFA5EA2788FED0AD7219D2AAA5B870FE54F1F5D41D4',
    'Activo',
    (
        SELECT
            id_application
        FROM
            db_tokensecurity.application
        WHERE
                name = 'APP.PORTAL_CAUTIVO'
            AND status = 'ACTIVO'
    )
);

COMMIT;
/
