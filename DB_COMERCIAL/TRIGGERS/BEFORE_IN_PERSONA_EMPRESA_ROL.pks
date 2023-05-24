CREATE OR REPLACE TRIGGER DB_COMERCIAL.BEFORE_IN_PERSONA_EMPRESA_ROL
   BEFORE INSERT
   ON DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
   FOR EACH ROW 
     /**
   * Documentaci�n para el trigger BEFORE_IN_PERSONA_EMPRESA_ROL'.
   * Trigger que valida los nuevos insert en la tabla info_persona_empresa_rol
   *  si el empleado ya tiene un ROl.
   * @versi�n 1.0 17-03-2022
   *
   * Se agrego el estado pendiente para validar si ya existe el rol en el cliente.
   * @author Jefferson Carrillo <jacarrillo@telconet.ec>
   * @version 1.1 14-05-2021 
   */
   DECLARE
   v_persona_id integer;
 BEGIN
  SELECT COUNT(*) INTO v_persona_id
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
   where persona_id=:new.persona_id and EMPRESA_ROL_ID=:new.EMPRESA_ROL_ID  and 	
   OFICINA_ID=:new.OFICINA_ID  and ESTADO in ('Pendiente','Activo') and USR_CREACION=:new.USR_CREACION;
   IF(v_persona_id>=1) THEN
     raise_application_error(-20000, 'El empleado ya tiene Rol');
   END IF;
 END;
/