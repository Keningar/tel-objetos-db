/**
 * DEBE EJECUTARSE EN DB_HORAS_EXTRAS.
 * @author Ivan Mata <imata@telconet.ec>
 * @version 1.0 01-02-2021 - Versión Inicial.
 */

/** Trigger auditoria tabla LISTADO_HORAS_HE **/
CREATE OR REPLACE TRIGGER DB_HORAS_EXTRAS.BEFORE_LISTADO_HORAS_HE
  BEFORE UPDATE ON DB_HORAS_EXTRAS.LISTADO_HORAS_HE FOR EACH ROW

BEGIN
  :NEW.USR_MODIFICACION := NVL(:NEW.USR_MODIFICACION,USER);
  :NEW.FE_MODIFICACION  := NVL(:NEW.FE_MODIFICACION,SYSDATE);
  :NEW.IP_CREACION      := NVL(:NEW.IP_CREACION,NVL(SYS_CONTEXT('USER','IP_ADDRESS'),'127.0.0.1'));
END;

/
