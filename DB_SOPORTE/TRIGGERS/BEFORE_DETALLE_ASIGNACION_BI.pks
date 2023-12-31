CREATE OR REPLACE TRIGGER DB_SOPORTE.BEFORE_DETALLE_ASIGNACION_BI
  BEFORE UPDATE ON DB_SOPORTE.INFO_DETALLE_ASIGNACION
  REFERENCING NEW AS NEW OLD AS OLD 
  FOR EACH ROW
    /**
    * Documentación para trigger DB_SOPORTE.BEFORE_DETALLE_ASIGNACION_BI
    * Trigger que valida los update en la tabla INFO_DETALLE_ASIGNACION y almacena fechas de update en INFO_DETALLE_ASIGNACION_BI
    * @author Mónica Moreta <mmoreta@telconet.ec>
    * @version 2.0 24-08-2022
    */
 
BEGIN

    UPDATE DB_SOPORTE.INFO_DETALLE_ASIGNACION_BI
    SET FE_ULT_MOD                   = SYSDATE
    WHERE DETALLE_ASIGNACION_ID      = :NEW.ID_DETALLE_ASIGNACION;
    --
    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO DB_SOPORTE.INFO_DETALLE_ASIGNACION_BI (detalle_asignacion_id,FE_ULT_MOD) 
      VALUES (:NEW.ID_DETALLE_ASIGNACION,SYSDATE);
    end if; 

    EXCEPTION
    WHEN OTHERS THEN
    NULL; 

END;
/
