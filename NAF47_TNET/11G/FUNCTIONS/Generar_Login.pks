create or replace function            Generar_Login(p_connectionType varchar2,p_nombre varchar2,p_medio varchar2,p_apellido_p varchar2,p_apellido_m varchar2,p_cedula varchar2,p_mail varchar2) return varchar2 is
  loginEmpleado    db_comercial.info_persona.login%type;
  v_uidNumber      varchar2(2);
BEGIN
  
  if (p_cedula is not null) then
    v_uidNumber := javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;cedula;'||p_cedula);
    if(to_number(v_uidNumber)>0)then
      loginEmpleado := javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidName '||UPPER(p_connectionType)||';dc=telconet,dc=net;cedula;'||p_cedula);
      
      RETURN loginEmpleado;
    else
      loginEmpleado := LOWER(substr(p_nombre,1,1)||p_apellido_p);
        IF to_number(javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;uid;'||loginEmpleado)) > 0 THEN
            loginEmpleado := LOWER(substr(p_nombre,1,1)||substr(p_medio,1,1)||p_apellido_p);
            IF to_number(javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;uid;'||loginEmpleado)) > 0 THEN
                loginEmpleado := LOWER(substr(p_nombre,1,1)||substr(p_medio,1,1)||p_apellido_p||substr(p_apellido_m,1,1));
                IF to_number(javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;uid;'||loginEmpleado)) > 0 THEN
                    RETURN loginEmpleado||TO_CHAR(to_number(javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;uid;'||loginEmpleado))+1);
                ELSE
                    RETURN loginEmpleado;
                END IF;
            ELSE
                RETURN loginEmpleado;
            END IF;
        ELSE
            return loginEmpleado;
        END IF;
    end if;
  else 
    if((p_mail is not null) and (instr(p_mail, '@') > 0))then
      v_uidNumber := javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;mail;'||p_mail);
      if(to_number(v_uidNumber)>0)then
        loginEmpleado := javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidName '||UPPER(p_connectionType)||';dc=telconet,dc=net;mail;'||p_mail);
        RETURN loginEmpleado;
      end if;
    else 
      if((p_cedula is not null) and ((p_mail is not null) or (instr(p_mail, '@') < 1)))then
        loginEmpleado := LOWER(substr(p_nombre,1,1)||p_apellido_p);
        IF to_number(javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;uid;'||loginEmpleado)) > 0 THEN
            loginEmpleado := LOWER(substr(p_nombre,1,1)||substr(p_medio,1,1)||p_apellido_p);
            IF to_number(javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;uid;'||loginEmpleado)) > 0 THEN
                RETURN loginEmpleado||TO_CHAR(to_number(javaruncommand('/usr/java/jdk1.7.0_40/jre/bin/java -jar /home/oracle/scripts/SSO_LDAP.jar searchUidNumber '||UPPER(p_connectionType)||';dc=telconet,dc=net;uid;'||loginEmpleado))+1);
            ELSE
                RETURN loginEmpleado;
            END IF;
        ELSE
            return loginEmpleado;
        END IF;
      end if;
    end if;
  end if;
  
  return loginEmpleado;
END Generar_Login;