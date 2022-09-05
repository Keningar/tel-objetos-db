--CREAR TRIGGER 
create or replace TRIGGER DB_COMERCIAL.BEFORE_INFO_PERSONA_BI
  BEFORE UPDATE ON DB_COMERCIAL.INFO_PERSONA 
  REFERENCING NEW AS NEW OLD AS OLD 
  FOR EACH ROW
    /**
    * Documentación para trigger DB_COMERCIAL.BEFORE_INFO_PERSONA_BI
    * Trigger que valida los update en la tabla INFO_PERSONA y almacena fechas de update en INFO_PERSONA_BI
    * @author Mónica Moreta <mmoreta@telconet.ec>
    * @version 2.0 24-08-2022
    */

BEGIN

    UPDATE DB_COMERCIAL.INFO_PERSONA_BI
    SET FE_ULT_MOD        = SYSDATE
    WHERE PERSONA_ID      = :NEW.ID_PERSONA;
    --
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO DB_COMERCIAL.INFO_PERSONA_BI (PERSONA_ID,FE_ULT_MOD) 
      VALUES (:NEW.ID_PERSONA,SYSDATE);
    end if; 

    EXCEPTION
    WHEN OTHERS THEN
    NULL; 
    
END; 


/