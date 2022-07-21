/**
 * DEBE EJECUTARSE EN DB_TOKEN_SECURITY.
 * Registro de App AntiPhishing - Token
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 22-04-2022 - Versión Inicial.
 */
 INSERT INTO DB_TOKENSECURITY.APPLICATION (
                                          ID_APPLICATION,
                                          NAME,
                                          STATUS,
                                          EXPIRED_TIME
                                         ) 
VALUES(
        DB_TOKENSECURITY.SEQ_APPLICATION.NEXTVAL, 
        'ANTI_PHISHING', 
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
       'ANTI_PHISHING', 
       UPPER('4b3750822ae6628549204068b87f38c13f7d9fea32912f05c1986c868daaced5'),-- 
       'Activo', 
       (SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME='ANTI_PHISHING')
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
        'SeguridadWSController',
        'procesarAction',
        '1',
        'ACTIVO',
        (SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME = 'ANTI_PHISHING')
        );

COMMIT;
/
