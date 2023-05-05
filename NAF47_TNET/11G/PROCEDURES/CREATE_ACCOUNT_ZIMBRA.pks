create or replace PROCEDURE            CREATE_ACCOUNT_ZIMBRA (p_connectionType   IN VARCHAR2,
                                 p_codeCompany      IN VARCHAR2,
                                 p_esJefe           IN VARCHAR2,
                                 p_esGerente        IN VARCHAR2, 
                                 p_login            IN VARCHAR2, 
                                 p_dominio          IN VARCHAR2, 
                                 p_dn               IN VARCHAR2, 
                                 p_displayName      IN VARCHAR2, 
                                 p_givenName        IN VARCHAR2, 
                                 p_lastName         IN VARCHAR2)
AS

v_resultado   varchar2(2);

BEGIN

  v_resultado := javaruncommand('/usr/java/jdk1.7.0_25/jre/bin/java -jar /home/oracle/scripts/SSO_Zimbra.jar createAccount '||UPPER(p_connectionType)||';'||p_codeCompany||';'||p_esJefe||';'||p_esGerente||';'||p_login||'|'||p_dominio||';'||p_dn||';'||p_displayName||';'||p_givenName||';'||p_lastName);

END;