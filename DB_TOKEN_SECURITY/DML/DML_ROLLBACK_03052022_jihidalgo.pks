/**
 * DEBE EJECUTARSE EN DB_TOKEN_SECURITY.
 * Rollback para los parametros utilizados para proceso Anti-Phishing
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 22-04-2022 - Versión Inicial.
 */
DELETE FROM DB_TOKENSECURITY.WEB_SERVICE
WHERE ID_APPLICATION=(SELECT ID_APPLICATION FROM DB_TOKENSECURITY.APPLICATION WHERE NAME = 'ANTI_PHISHING');

DELETE FROM  DB_TOKENSECURITY.USER_TOKEN
WHERE USERNAME='ANTI_PHISHING'; 

DELETE FROM DB_TOKENSECURITY.APPLICATION
WHERE NAME='ANTI_PHISHING';

COMMIT;
/  
