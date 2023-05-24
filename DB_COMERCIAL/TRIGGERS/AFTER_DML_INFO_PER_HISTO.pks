CREATE OR REPLACE TRIGGER DB_COMERCIAL.AFTER_DML_INFO_PER_HISTO AFTER
  UPDATE ON DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW DECLARE
    --
    /**
    * Documentaci�n para trigger AFTER_DML_INFO_PER_HISTO
    * Si un empleado se ha cambiado de departamento, se reasignan las tareas pendientes de dicho empleado al Jefe del departamento anterior
    * @author Lizbeth Cruz <mlcruz@telconet.ec>
    * @version 1.0 27-01-2017
    *
    * @author Lizbeth Cruz <mlcruz@telconet.ec>
    * @version 1.1 06-02-2017 Se realizan modificaciones del trigger dispar�ndolo desde la actualizaci�n de la tabla en
    *                         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL y enviando los par�metros del OLD Y NEW del registro
    */
    Lv_MsjError VARCHAR2(1000);
    PRAGMA AUTONOMOUS_TRANSACTION;
  --
  BEGIN
    IF UPDATING('DEPARTAMENTO_ID') THEN
      DB_SOPORTE.SPKG_TAREAS_CAMBIO_EMPLEADO.P_REASIGNAR_TAREAS_JEFE_DEP( :OLD.ID_PERSONA_ROL, 
                                                                          :OLD.OFICINA_ID, 
                                                                          :OLD.EMPRESA_ROL_ID, 
                                                                          :OLD.DEPARTAMENTO_ID, 
                                                                          :OLD.IP_CREACION, 
                                                                          :NEW.OFICINA_ID, 
                                                                          :NEW.EMPRESA_ROL_ID, 
                                                                          :NEW.DEPARTAMENTO_ID, 
                                                                          Lv_MsjError );
    END IF;
  END AFTER_DML_INFO_PER_HISTO ;
/