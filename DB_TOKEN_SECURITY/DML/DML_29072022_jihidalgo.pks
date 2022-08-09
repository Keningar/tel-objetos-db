/**
 * DEBE EJECUTARSE EN DB_TOKEN_SECURITY.
 * Registro de App BusPagos - Token
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 29-07-2022 - Versión Inicial.
 */
 INSERT INTO DB_TOKENSECURITY.APPLICATION (
                                          ID_APPLICATION,
                                          NAME,
                                          STATUS,
                                          EXPIRED_TIME
                                         ) 
VALUES(
        DB_TOKENSECURITY.SEQ_APPLICATION.NEXTVAL, 
        'BUSPAGOS', 
        'ACTIVO',
        '30');

INSERT INTO DB_TOKENSECURITY.USER_TOKEN ( 
                                         ID_USER_TOKEN,
                                         USERNAME,
                                         PASSWORD, 
                                         ESTADO,
                                         APPLICATION_ID 
                                        ) 
VALUES(
       DB_TOKENSECURITY.SEQ_USER_TOKEN.NEXTVAL, 
       'BUSPAGOS', 
       UPPER('47b51fc9fed2a319342442ca8cabb013a34f8acf4ee1fb3f40a9365e0aba2b0e'),-- 
       'Activo', 
       (SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME='BUSPAGOS')
       );

INSERT INTO DB_TOKENSECURITY.WEB_SERVICE (
                                          ID_WEB_SERVICE,
                                          SERVICE,
                                          METHOD,
                                          GENERATOR,
                                          STATUS,
                                          ID_APPLICATION
                                         )
VALUES (
        DB_TOKENSECURITY.SEQ_WEB_SERVICE.nextval,
        'TecnicoWSController',
        'procesarAction',
        '1',
        'ACTIVO',
        (SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME = 'BUSPAGOS')
        );

COMMIT;
/
