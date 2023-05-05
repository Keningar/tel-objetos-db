create or replace TRIGGER DB_COMPROBANTES.TRG_AFTER_INFO_MENSAJE AFTER
  INSERT ON DB_COMPROBANTES.INFO_MENSAJE REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
    --
    DECLARE
    /**
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 03-06-2016
    */
    --
    Lv_MsnError VARCHAR2(2000);
  --
  BEGIN
    --
    DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_MESSAGE_COMP_ELEC_INSRT(:NEW.TIPO,
                                                                 :NEW.MENSAJE,
                                                                 :NEW.INFOADICIONAL,
                                                                 :NEW.DOCUMENTO_ID,
                                                                 SYSDATE,
                                                                 Lv_MsnError);
    --
  END TRG_AFTER_INFO_MENSAJE;