CREATE OR REPLACE PACKAGE DB_SEGURIDAD.SEKG_TRANSACCION IS

 /**
  * Documentacion para P_VALIDA_PERFIL_PER_EXTERNO
  * Procedure que verifica los roles en DB_SEGURIDAD.SEGU_PERFIL_PERSONA
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22/03/2018
  *
  * @param Pn_PersonaId    IN NUMBER
  * @param Pn_TotalREgistros IN OUT NUMBER.
  */
  PROCEDURE P_VALIDA_PERFIL_PER_EXTERNO (Pn_PersonaId    IN  NUMBER,
                                         Pn_TotalREgistros IN OUT NUMBER);

END SEKG_TRANSACCION;
/

CREATE OR REPLACE PACKAGE BODY DB_SEGURIDAD.SEKG_TRANSACCION IS

  PROCEDURE P_VALIDA_PERFIL_PER_EXTERNO (Pn_PersonaId    IN  NUMBER,
                                         Pn_TotalREgistros IN OUT NUMBER)IS

    CURSOR C_ROLES (Cn_PersonaId Number)IS
    SELECT COUNT(*)
      FROM DB_SEGURIDAD.SEGU_PERFIL_PERSONA
     WHERE PERSONA_ID = Cn_PersonaId;

     Ln_TotalRegistros Number:=0;

  BEGIN

     IF C_ROLES%ISOPEN THEN CLOSE C_ROLES; END IF;
     OPEN C_ROLES(Pn_PersonaId);
     FETCH C_ROLES INTO Ln_TotalRegistros;
     CLOSE C_ROLES;

     IF Ln_TotalRegistros > 0 THEN
       DELETE DB_SEGURIDAD.SEGU_PERFIL_PERSONA WHERE PERSONA_ID = Pn_PersonaId;
       Pn_TotalREgistros:=0;
     ELSIF Ln_TotalRegistros = 0 THEN
       Pn_TotalREgistros:=0;
     END IF;

     DELETE DB_SEGURIDAD.SEGU_MENU_PERSONA   WHERE PERSONA_ID = Pn_PersonaId;
     COMMIT;


  EXCEPTION
   WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                    'SEKG_TRANSACCION.P_VALIDA_PERFIL_PER_EXTERNO',
                                    'Error en SEKG_TRANSACCION.P_VALIDA_PERFIL_PER_EXTERNO: ',
                                    USER,
                                    SYSDATE,
                                    '127.0.0.0');
  END P_VALIDA_PERFIL_PER_EXTERNO;

END SEKG_TRANSACCION;
/
