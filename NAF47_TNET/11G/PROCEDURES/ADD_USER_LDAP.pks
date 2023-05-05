create or replace PROCEDURE            ADD_USER_LDAP (p_connectionType   IN VARCHAR2,
                         p_dn               IN VARCHAR2,
                         p_cn               IN VARCHAR2,
                         p_sn               IN VARCHAR2, 
                         p_displayName      IN VARCHAR2, 
                         p_cedula           IN VARCHAR2, 
                         p_uid              IN VARCHAR2, 
                         p_uidNumber        IN VARCHAR2 DEFAULT '501', 
                         p_gidNumber        IN VARCHAR2 DEFAULT '501', 
                         p_homeDirectory    IN VARCHAR2, 
                         p_loginShell       IN VARCHAR2 DEFAULT '/bin/bash', 
                         p_mail             IN VARCHAR2, 
                         p_userPassword     IN VARCHAR2, 
                         p_cargo            IN VARCHAR2)
AS

v_resultado   varchar2(2);

BEGIN

  v_resultado := javaruncommand('/usr/java/jdk1.7.0_25/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar addUser '||UPPER(p_connectionType)||';'||p_dn||';'||p_cn||';'||p_sn||';'||p_displayName||';'||p_cedula||';'||p_uid||';'||p_uidNumber||';'||p_gidNumber||';'||p_homeDirectory||';'||p_loginShell||';'||p_mail||';'||p_userPassword||';'||p_cargo);

END;