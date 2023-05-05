CREATE EDITIONABLE TRIGGER NAF47_TNET.AFTER_DML_TAPORDED
  AFTER UPDATE ON NAF47_TNET.TAPORDED
  FOR EACH ROW
DECLARE
  LV_MENSAJE VARCHAR2(1000);
BEGIN
  IF UPDATING('RECIBIDO') THEN
    -- Inserta en TAP_HISTORIAL_OC la linea que se esta procesando         
    NAF47_TNET.INKG_TRANSACCION.P_INSERTA_TAP_HISTORIAL_OC(:NEW.NO_CIA,
                                                :NEW.NO_ORDEN,
                                                :NEW.NO_LINEA,
                                                :NEW.NO_ARTI,
                                                :NEW.CANTIDAD,
                                                (:NEW.RECIBIDO -
                                                NVL(:OLD.RECIBIDO, 0)),
                                                SYSDATE,
                                                USER,
                                                LV_MENSAJE);
  END IF;
END TR_AFTER_DML_TAPORDED;
  --
/