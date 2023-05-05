CREATE OR REPLACE TRIGGER DB_COMERCIAL.AFTER_INFO_PERSONA_TIPO_IDENT 
  AFTER INSERT OR UPDATE OF TIPO_IDENTIFICACION,IDENTIFICACION_CLIENTE ON DB_COMERCIAL.INFO_PERSONA 
  REFERENCING NEW AS NEW FOR EACH ROW
DECLARE
 /**
  * Documentacion para trigger AFTER_INFO_PERSONA_TIPO_IDENT
  * Especificacion: Triggers que controla el ingreso o actualizacion del campo TIPO_IDENTIFICACION de la tabla INFO_PERSONA.
  * Si se trata del registro de una persona con rol de Cliente o Precliente entonces se
  * valida que el campo TIPO_IDENTIFICACION sea obligatorio en el ingreso o actualizacion caso contrario se salta una exception.
  * Se controla los tipos de datos sea CED, RUC, que coincidan con el tipo de dato ingresado.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 06-04-2015
  */
  v_mensaje      VARCHAR2(1000);
  v_id_persona   db_comercial.info_persona_empresa_rol.persona_id%type;
  Lex_Exception   EXCEPTION;

  CURSOR LC_PersonaEsCliente(p_id_persona db_comercial.info_persona_empresa_rol.persona_id%TYPE) is
  select pemprol.persona_id 
  from info_persona_empresa_rol pemprol  
    join info_empresa_rol emprol on pemprol.empresa_rol_id=emprol.id_empresa_rol     
    join info_empresa_grupo empgrup on emprol.empresa_cod=empgrup.cod_empresa 
    join admi_rol rol on emprol.ROL_ID=rol.ID_ROL 
    join ADMI_TIPO_ROL trol on rol.TIPO_ROL_ID=trol.ID_TIPO_ROL 
    and trol.descripcion_tipo_rol in ('Pre-cliente','Cliente')
   where pemprol.persona_id = p_id_persona;   

begin  
  OPEN  LC_PersonaEsCliente(:NEW.ID_PERSONA);
  FETCH LC_PersonaEsCliente INTO v_id_persona;

  IF (LC_PersonaEsCliente%FOUND) THEN 
     if(:NEW.TIPO_IDENTIFICACION is null) then  
          v_mensaje := 'Error: No se permite el ingreso de Tipo identificacion NULL para la Persona con identificacion: ' || :NEW.IDENTIFICACION_CLIENTE;
          RAISE Lex_Exception; 
    
     elsif(:NEW.TIPO_IDENTIFICACION ='CED' and LENGTH(:NEW.IDENTIFICACION_CLIENTE)!=10) then  
          v_mensaje := 'Error: El Tipo identificacion: ' || :NEW.TIPO_IDENTIFICACION || ' no coincide con la identificacion de la Persona : ' || :NEW.IDENTIFICACION_CLIENTE;
          RAISE Lex_Exception;    

     elsif(:NEW.TIPO_IDENTIFICACION ='RUC' and LENGTH(:NEW.IDENTIFICACION_CLIENTE)!=13) then          
           v_mensaje := 'Error: El Tipo identificacion: ' || :NEW.TIPO_IDENTIFICACION || ' no coincide con la identificacion de la Persona : ' || :NEW.IDENTIFICACION_CLIENTE;
          RAISE Lex_Exception;

     elsif(:NEW.TIPO_IDENTIFICACION !='CED' and :NEW.TIPO_IDENTIFICACION !='RUC' and :NEW.TIPO_IDENTIFICACION !='PAS') then
           v_mensaje := 'Error, El tipo de Identificacion permitido es CED/RUC/PAS para la Persona con identificacion:' || :NEW.IDENTIFICACION_CLIENTE;
           RAISE Lex_Exception;

     end if;
  END IF;

  close LC_PersonaEsCliente;   

 EXCEPTION
  WHEN Lex_Exception THEN 
    RAISE_APPLICATION_ERROR(-20001, v_mensaje);   
 
  WHEN OTHERS THEN   
    RAISE_APPLICATION_ERROR(-20001, 'No se permite el ingreso de Tipo identificacion NULL para la Persona con identificacion:' || :NEW.IDENTIFICACION_CLIENTE);    
    
end AFTER_INFO_PERSONA_TIPO_IDENT;
/
