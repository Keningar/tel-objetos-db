create or replace TRIGGER NAF47_TNET.TR_MGCGAL_CENTRO
  BEFORE INSERT OR UPDATE OF cc_1, cc_2, cc_3, centro_costo
  ON MIGRA_ARCGAL FOR EACH ROW
  /**
  * Documentacion para trigger TR_MGCGAL_CENTRO
  * Trigger que validará que los campos centros de costos siempre se registren con valores asignados
  * al registrar en repositorio migración bancos
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 01-09-2017
  */
BEGIN
  IF :New.centro_costo IS NULL THEN
     :NEW.Centro_costo := :new.cc_1||:new.cc_2||:new.cc_3;
  ELSIF :new.centro_costo = :old.centro_costo THEN
     :NEW.Centro_costo := :new.cc_1||:new.cc_2||:new.cc_3;
  ELSE
     :New.cc_1 := SubStr(:new.centro_costo,1,3);
     :New.cc_2 := SubStr(:new.centro_costo,4,3);
     :New.cc_3 := SubStr(:new.centro_costo,7,3);
  END IF;
END;
