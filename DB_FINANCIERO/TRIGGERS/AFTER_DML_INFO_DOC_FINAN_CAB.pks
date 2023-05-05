CREATE EDITIONABLE TRIGGER DB_FINANCIERO.BEFORE_DML_INFO_COMP_ELEC 
BEFORE UPDATE ON DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO 
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW 
--
DECLARE 
/**
  * Documentacion para trigger BEFORE_DML_INFO_COMP_ELEC
  * Eliminara los comprobantes electronicos que sean autorizados por el SRI
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 21-05-2015
  * @version 1.1 21-05-2015
  * @since 1.0
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.2 29-01-2020 - Se modifica el proceso de saldo disponible, se invoca al procedimiento 
  *                           'FNCK_FACTURACION.P_GET_VALOR_TOTAL_NC_BY_FACT' para obtener el saldo por factura 
  *                           s�lo considerando las notas de cr�ditos.
  *
  */
  --
  Lrf_ComprobanteElectronico    FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico;
  --
  Lr_InfoDocumentoFinancieroNc  INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  --
  Lr_AdmiTipoDocFinanciero      ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
  --
  Ln_Saldo                      NUMBER := 0;
  --
  Lv_MsnError                   VARCHAR2(2000);
  --
  Lex_Exception                 EXCEPTION;
  --
  BEGIN
    --Entra si se actualiza el estado de la tabla
    IF UPDATING('ESTADO') THEN
      --
      IF :NEW.ESTADO = 5 THEN
        --
        :NEW.COMPROBANTE_ELECTRONICO := NULL;
        --
      END IF;
      --
      IF :NEW.ESTADO IN (9, 10) THEN
      --
        Lr_AdmiTipoDocFinanciero := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(:OLD.TIPO_DOCUMENTO_ID, NULL);
        --
        IF Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO = 'NC' THEN
        --
          FNCK_FACTURACION.P_GET_VALOR_TOTAL_NC_BY_FACT(:OLD.DOCUMENTO_ID, Ln_Saldo);
          --
          --Si el saldo <= 0 no permite la actualizaci�n del comprobante para su env�o al SRI
          IF ROUND(Ln_Saldo, 2) <= 0 THEN
          --
            RAISE Lex_Exception;
          --
          END IF;
        --
        END IF;
        --
      --
      END IF;
      --
    END IF;
    --
  EXCEPTION
  --
  WHEN Lex_Exception THEN
    --
    FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('notificaciones_telcos@telconet.ec', 
                                             'Error Trigger - BEFORE_DML_INFO_COMP_ELEC', 
                                             'Error en BEFORE_DML_INFO_COMP_ELEC el saldo de la factura es: ' || Ln_Saldo || 
                                             DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'FACE');
    --
    RAISE_APPLICATION_ERROR(-20001, 'Error en BEFORE_DML_INFO_COMP_ELEC el saldo de la factura es: ' || Ln_Saldo ||
                            DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    --
  WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('notificaciones_telcos@telconet.ec', 
                                             'Error Trigger - BEFORE_DML_INFO_COMP_ELEC', 
                                             'Existio un error en el trigger - ERROR_STACK: ' ||
                                             DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' || 
                                             Lv_MsnError, 'FACE');
    --
  END BEFORE_DML_INFO_COMP_ELEC;

/