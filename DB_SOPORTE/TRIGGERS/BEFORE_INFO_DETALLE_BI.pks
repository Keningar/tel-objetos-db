
--CREAR TRIGGER 
create or replace TRIGGER DB_SOPORTE.BEFORE_INFO_DETALLE_BI
  BEFORE UPDATE ON DB_SOPORTE.INFO_DETALLE
  REFERENCING NEW AS NEW OLD AS OLD 
  FOR EACH ROW
  
    /**
    * Documentación para trigger DB_SOPORTE.BEFORE_DETALLE_BI
    * Trigger que valida los update en la tabla DB_SOPORTE.INFO_DETALLE y almacena fechas de update en INFO_DETALLE_BI
    * @author Mónica Moreta <mmoreta@telconet.ec>
    * @version 2.0 24-08-2022
    */
 
BEGIN

    UPDATE DB_SOPORTE.INFO_DETALLE_BI
    SET FE_ULT_MOD        = SYSDATE
    WHERE DETALLE_ID      = :NEW.ID_DETALLE;
    --
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO DB_SOPORTE.INFO_DETALLE_BI (DETALLE_ID,FE_ULT_MOD) 
      VALUES (:NEW.ID_DETALLE,SYSDATE);
    end if; 
    
    EXCEPTION
    WHEN OTHERS THEN
    NULL; 


END; 



/
