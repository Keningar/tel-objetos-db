CREATE OR REPLACE TRIGGER DB_COMERCIAL."AFTER_DML_INFO_PERSONA"
  AFTER INSERT OR UPDATE OF identificacion_cliente ON DB_COMERCIAL.INFO_PERSONA 
  FOR EACH ROW
 /**
  * Documentacion para trigger AFTER_DML_INFO_PERSONA
  * @author Telcos
  * @version 1.0 Trigger que valida si ya existe registrada la persona seg�n su identificaci�n.
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 21-09-2017 Se elimina la validaci�n de la identificaci�n en esta instancia.
  */
DECLARE
  v_mensaje      VARCHAR2(1500);
  v_id_persona   db_comercial.vista_persona.id_persona%type;
  
  CURSOR c_existe_persona(v_identificacion_cliente db_comercial.vista_persona.identificacion_cliente%TYPE) IS
    SELECT db_comercial.vista_persona.id_persona
    FROM db_comercial.vista_persona
    WHERE identificacion_cliente = v_identificacion_cliente;
begin
  v_mensaje := NULL;
  
  OPEN  c_existe_persona(:NEW.IDENTIFICACION_CLIENTE);
  FETCH c_existe_persona INTO v_id_persona;
  IF c_existe_persona%NOTFOUND THEN 
    v_id_persona := NULL;
  END IF;
  CLOSE c_existe_persona;
  
  IF v_id_persona is not null then
    v_mensaje := 'Ya se encuentra ingresada una persona con el mismo numero de identificacion';
  END IF;
  
  IF v_mensaje IS NOT NULL THEN
    RAISE_APPLICATION_ERROR(-20002, v_mensaje);
  END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      Raise_Application_Error('-20003', 'AFTER_DML_INFO_PERSONA: '||sqlerrm);
end AFTER_DML_INFO_PERSONA;
/