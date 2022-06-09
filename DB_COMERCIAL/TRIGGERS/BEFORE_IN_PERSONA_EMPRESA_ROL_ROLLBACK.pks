create or replace trigger BEFORE_IN_PERSONA_EMPRESA_ROL
   BEFORE INSERT
   ON DB_COMERCIAL.info_persona_empresa_rol
   FOR EACH ROW 
     /**
   * Documentación para el trigger BEFORE_IN_PERSONA_EMPRESA_ROL'.
   * Trigger que valida los nuevos insert en la tabla info_persona_empresa_rol
   *  si el empleado ya tiene un ROl.
   * @versión 1.0 17-03-2022
   */ 
   DECLARE
   v_persona_id integer;
 BEGIN
  SELECT COUNT(*) INTO v_persona_id
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
   where persona_id=:new.persona_id and EMPRESA_ROL_ID=:new.EMPRESA_ROL_ID  and 	
   OFICINA_ID=:new.OFICINA_ID  and ESTADO='Activo' and USR_CREACION=:new.USR_CREACION;
   IF(v_persona_id>=1) THEN
     raise_application_error(-20000, 'El empleado ya tiene Rol');
   END IF;
 END;
/