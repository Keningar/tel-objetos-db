/**
 * DEBE EJECUTARSE EN DB_TOKEN_SECURITY.
 * Registro de App Derecho legal
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 20-01-2023 - Versión Inicial.
 */


INSERT INTO DB_TOKENSECURITY.APPLICATION (
                                          ID_APPLICATION,
                                          NAME,
                                          STATUS,
                                          EXPIRED_TIME
                                         ) 
VALUES(
        DB_TOKENSECURITY.SEQ_APPLICATION.NEXTVAL, 
        'DERECHO_LEGAL', 
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
       'DERECHO_LEGAL', 
       UPPER('6edaebf4324fdfeeae6ce53029635c6c8292346cdabe0f439ce410f4ff3fe3e1'),-- 
       'Activo', 
       (SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME='DERECHO_LEGAL')
       );

Insert into DB_TOKENSECURITY.WEB_SERVICE (
                                          ID_WEB_SERVICE,
                                          SERVICE,
                                          METHOD,
                                          GENERATOR,
                                          STATUS,
                                          ID_APPLICATION
                                         )
values (
        DB_TOKENSECURITY.SEQ_WEB_SERVICE.nextval,
        'ComercialMobileWSControllerRest',
        'procesarAction',
        '1',
        'ACTIVO',
        (SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME = 'DERECHO_LEGAL')
        );
        
        
/
