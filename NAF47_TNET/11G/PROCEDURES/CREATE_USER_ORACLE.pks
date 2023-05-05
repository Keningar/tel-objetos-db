create or replace PROCEDURE            CREATE_USER_ORACLE (p_user       IN VARCHAR2,
                              p_password   IN VARCHAR2,
                              p_no_cia     IN VARCHAR2,
                              p_puesto     IN VARCHAR2)
IS
PRAGMA AUTONOMOUS_TRANSACTION;

 CURSOR c_perfiles_cargo(v_no_cia naf47_tnet.arcgmc.no_cia%TYPE, v_puesto naf47_tnet.arplmp.puesto%TYPE) IS
    SELECT id_perfil 
    from seg47_tnet.sg_perfil
    WHERE id_compania = v_no_cia 
      AND id_cargo = v_puesto
      AND estado = 'A';

  CURSOR c_sinonimos_perfil(v_no_cia naf47_tnet.arcgmc.no_cia%TYPE, v_perfil SEG47_TNET.sg_perfil.id_perfil%TYPE) IS
    SELECT objeto, propietario 
    FROM SEG47_TNET.sg_perfil_sinonimos 
    WHERE id_compania = v_no_cia 
      AND id_perfil = v_perfil
      AND estado = 'A';
      
BEGIN
  EXECUTE IMMEDIATE 'CREATE USER '||p_user||' IDENTIFIED BY "'||p_password||'" DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP'; 
  
  EXECUTE IMMEDIATE 'GRANT UNLIMITED TABLESPACE TO '||p_user; 
  EXECUTE IMMEDIATE 'GRANT RESOURCE TO '||p_user;
  EXECUTE IMMEDIATE 'GRANT NAFTNET_USUARIOS TO '||p_user;
  EXECUTE IMMEDIATE '--GRANT EXECUTE ON ANY CLASS TO '||p_user;
  EXECUTE IMMEDIATE '--GRANT EXECUTE ON ANY PROGRAM TO '||p_user;
  EXECUTE IMMEDIATE '--GRANT EXECUTE ON ANY LIBRARY TO '||p_user;
  EXECUTE IMMEDIATE '--GRANT EXECUTE ON ANY PROCEDURE TO '||p_user;
  EXECUTE IMMEDIATE 'GRANT CREATE ANY SEQUENCE TO '||p_user;
  EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO '||p_user;
  
  for perfil in c_perfiles_cargo(p_no_cia, p_puesto) loop
      for sinonimo in c_sinonimos_perfil(p_no_cia, perfil.id_perfil) loop
          execute immediate 'CREATE OR REPLACE SYNONYM '||p_user||'.'||sinonimo.objeto||' FOR '||sinonimo.propietario||'.'||sinonimo.objeto; 
      end loop;
  end loop;
  
END;