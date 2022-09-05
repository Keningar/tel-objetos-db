
--CREAR TRIGGER 
create or replace TRIGGER DB_INFRAESTRUCTURA.BEFORE_INFO_ELEMENTO_BI
  BEFORE UPDATE ON DB_INFRAESTRUCTURA.INFO_ELEMENTO
  REFERENCING NEW AS NEW OLD AS OLD 
  FOR EACH ROW
    /**
    * Documentación para trigger DB_INFRAESTRUCTURA.BEFORE_INFO_ELEMENTO_BI
    * Trigger que valida los update en la tabla DB_INFRAESTRUCTURA.INFO_ELEMENTO y almacena fechas de update en DB_INFRAESTRUCTURA.INFO_ELEMENTO_BI
    * @author Mónica Moreta <mmoreta@telconet.ec>
    * @version 2.0 24-08-2022
    */
 
BEGIN

    UPDATE DB_INFRAESTRUCTURA.INFO_ELEMENTO_BI
    SET FE_ULT_MOD       = SYSDATE
    WHERE ELEMENTO_ID    = :NEW.ID_ELEMENTO;
    --
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO DB_INFRAESTRUCTURA.INFO_ELEMENTO_BI (ELEMENTO_ID,FE_ULT_MOD) 
      VALUES (:NEW.ID_ELEMENTO,SYSDATE);
    end if; 

    EXCEPTION
    WHEN OTHERS THEN
    NULL; 

END; 



/
