--INGRESAR TOKEN Y DEMAS CARACTERISTICAS DE UN USUARIO EN LA TOKENSECURITY
INSERT INTO DB_TOKENSECURITY.APPLICATION (
                                          ID_APPLICATION,
                                          NAME,
                                          STATUS,
                                          EXPIRED_TIME
                                         ) 
VALUES(
        DB_TOKENSECURITY.SEQ_APPLICATION.NEXTVAL, 
        'GESTION_PERSONAL', 
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
       'GESTION_PERSONAL', 
       'B87B7B324F484259064F0065B14F282E6E8FD9E5CECC38A63D1FDDDD64D61871',
       'Activo', 
       (SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME='GESTION_PERSONAL')
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
        (SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME = 'GESTION_PERSONAL')
        );

COMMIT;
//
