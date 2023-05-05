-- new object type path: SCHEMA_EXPORT/TABLE/TRIGGER
CREATE EDITIONABLE TRIGGER NAF47_TNET.TR_PRE_INGRESO_SERIE 
  before insert on NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE 
  for each row
/**
 * Documentacion para TR_PRE_INGRESO_SERIE
 * Trigger que genera secuencia antes de realizar insert de registro, se crea con el fin de evitar
 * modificar los procesos para agregar la asignaci�n de nuevo PK de esta tabla.
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.0 09/04/2019
 *
 */
declare
  -- local variables here
begin
  -- si el campo que guarda Pk de la tabla viene vacio, se asigna valor de secuencia
  IF :NEW.ID_PRE_INGRESO_SERIE IS NULL THEN
    :NEW.ID_PRE_INGRESO_SERIE := NAF47_TNET.SEQ_INV_PRE_INGRESO_SERIE.NEXTVAL;
  END IF;
end TR_PRE_INGRESO;
/