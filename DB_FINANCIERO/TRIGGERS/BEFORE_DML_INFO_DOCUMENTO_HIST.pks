CREATE OR REPLACE TRIGGER DB_FINANCIERO.BEFORE_DML_INFO_DOCUMENTO_HIST
BEFORE INSERT ON DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL
REFERENCING OLD AS OLD NEW AS NEW 
FOR EACH ROW 
DECLARE
  --CURSOR QUE OBTIENE EL ESTADO DE LA TABLA INFO_DOCUMENTO_FINANCIERO_CAB
  --COSTO DEL QUERY 3
  CURSOR C_ObtieneDocFinanCab (Cn_DocumentoId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS
    SELECT CAB.ESTADO_IMPRESION_FACT,
           CAB.TIPO_DOCUMENTO_ID
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB CAB
     WHERE CAB.ID_DOCUMENTO = Cn_DocumentoId;
  Lr_ObtieneDocFinanCab   C_ObtieneDocFinanCab%ROWTYPE;
  Lr_InfoDocFinancieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lv_Mensaje              VARCHAR2(500);
  Lv_EstadoCerrado        VARCHAR2(15) := 'Cerrado';
  Le_Error                EXCEPTION;
BEGIN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'DB_FINANCIERO.BEFORE_DML_INFO_DOCUMENTO_HIST',
                                         '1) Se ingresa Historial por cierre de Documento ID_DOCUMENTO='|| :NEW.DOCUMENTO_ID ||
                                         '  ESTADO_IMPRESION_FACT='|| :NEW.ESTADO || '  F_SALDO_X_FACTURA=' ||
                                         ROUND( DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA( :NEW.DOCUMENTO_ID,'', 'saldo' ), 2 ),                                                               
                                         'telcos_pal_rec',
                                         SYSDATE,
                                         '127.0.0.1'
                                        );
    --SI EL ESTADO DEL NUEVO HISTORIAL ES CERRADO, SE VERIFICA QUE LA CABECERA EST� CERRADA.
    IF INSERTING AND Lv_EstadoCerrado = :NEW.ESTADO THEN

        --SE OBTIENE EL ESTADO_IMPRESION_FACT DE LA CABECERA
        OPEN  C_ObtieneDocFinanCab (Cn_DocumentoId => :NEW.DOCUMENTO_ID);
        FETCH C_ObtieneDocFinanCab INTO Lr_ObtieneDocFinanCab;
        CLOSE C_ObtieneDocFinanCab;

        --Si es una factura o factura proporcional y el estado no es Cerrado.
        IF Lv_EstadoCerrado != Lr_ObtieneDocFinanCab.ESTADO_IMPRESION_FACT AND Lr_ObtieneDocFinanCab.TIPO_DOCUMENTO_ID IN (1, 5) THEN
          --Se actualiza el estado de la cabecera por inconsistencia.
          Lr_InfoDocFinancieroCab.ESTADO_IMPRESION_FACT := Lv_EstadoCerrado;
          DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento                => :NEW.DOCUMENTO_ID,
                                                                        Pr_InfoDocumentoFinancieroCab => Lr_InfoDocFinancieroCab,
                                                                        Pv_MsnError                   => Lv_Mensaje);
          IF (Lv_Mensaje IS NOT NULL) THEN
            RAISE Le_Error;
          END IF;

          :NEW.OBSERVACION := 'BEFORE_DML_INFO_DOCUMENTO_HIST: ' || :NEW.OBSERVACION;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'DB_FINANCIERO.BEFORE_DML_INFO_DOCUMENTO_HIST',
                                         '2) Se ingresa Historial por cierre de Documento ID_DOCUMENTO='|| :NEW.DOCUMENTO_ID ||
                                         '  ESTADO_IMPRESION_FACT='|| :NEW.ESTADO || '  F_SALDO_X_FACTURA=' ||
                                         ROUND( DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA( :NEW.DOCUMENTO_ID,'', 'saldo' ), 2 ),                                                               
                                         'telcos_pal_rec',
                                         SYSDATE,
                                         '127.0.0.1'
                                        );
        END IF;

    END IF;
    --
  EXCEPTION
  WHEN Le_Error THEN
    --Env�a un correo de notificaci�n
    DB_FINANCIERO.FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('sistemas-financiero@telconet.ec', 
                                             'Error Trigger - BEFORE_DML_INFO_DOCUMENTO_HIST en DOCUMENTO_ID : ' 
                                             || :NEW.DOCUMENTO_ID || ' '
                                             || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS'), 
                                             '<p>Error en INFO_DOCUMENTO_FINANCIERO_CAB, no es posible actualizar la cabecera del documento <b>' 
                                             || :NEW.DOCUMENTO_ID
                                             || '</b> a ' 
                                             || :NEW.ESTADO 
                                             || '</p> <p><b>ERROR_STACK:</b> <small>' 
                                             || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                             || '</small></p> <p><b>ERROR_BACKTRACE:</b> </p> <small>' 
                                             || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE 
                                             || '</small>', 'EXCTG');
    --
    --Cancela la transacci�n y crea un c�digo de error
    RAISE_APPLICATION_ERROR(-20001, 'Error en INFO_DOCUMENTO_FINANCIERO_CAB, no se pudo completar la actualizaci�n. ID_DOCUMENTO: ' 
                            || :NEW.DOCUMENTO_ID
                            || ' ' || SYS_CONTEXT ('USERENV', 'HOST') 
                            || ' ' 
                            || DBMS_UTILITY.FORMAT_ERROR_STACK 
                            || ' ERROR_BACKTRACE: ' 
                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    --
  WHEN OTHERS THEN
    --
    --Env�a un correo de notificaci�n
    DB_FINANCIERO.FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('sistemas-financiero@telconet.ec', 
                                             'Error Trigger - BEFORE_DML_INFO_DOCUMENTO_HIST en DOCUMENTO_ID : ' 
                                             || :NEW.DOCUMENTO_ID || ' '
                                             || TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS'), 
                                             '<p>Error en INFO_DOCUMENTO_FINANCIERO_CAB, no es posible actualizar la cabecera del documento <b>' 
                                             || :NEW.DOCUMENTO_ID
                                             || '</b> a ' 
                                             || :NEW.ESTADO 
                                             || '</p> <p><b>ERROR_STACK:</b> <small>' 
                                             || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                             || '</small></p> <p><b>ERROR_BACKTRACE:</b> </p> <small>' 
                                             || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE 
                                             || '</small>', 'EXCTG');
    --
    --Cancela la transacci�n y crea un c�digo de error
    RAISE_APPLICATION_ERROR(-20001, 'Error en INFO_DOCUMENTO_FINANCIERO_CAB, no se pudo completar la actualizaci�n. ID_DOCUMENTO: ' 
                            || :NEW.DOCUMENTO_ID
                            || ' ' || SYS_CONTEXT ('USERENV', 'HOST') 
                            || ' ' 
                            || DBMS_UTILITY.FORMAT_ERROR_STACK 
                            || ' ERROR_BACKTRACE: ' 
                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    --
END BEFORE_DML_INFO_DOCUMENTO_HIST;
/
