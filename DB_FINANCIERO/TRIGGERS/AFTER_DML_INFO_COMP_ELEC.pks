CREATE OR REPLACE TRIGGER DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC 
AFTER UPDATE ON DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO 
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW 
--
DECLARE 
/**
  * Documentacion para trigger AFTER_DML_INFO_COMP_ELEC
  * FAC - FACP - NC: Actualiza el estado de la factura cuando se actuliza el estado del comprobante
  * Si el estado es 5 se actualizara el estado de la factura a Activo, si el estado del comprobante no esta entre
  * (1 => 'Iniciado', 9 => 'Creada', 10 => 'Actualizada') se actualizara el estado de la factura a Rechazado
  * NC: Cuando se activa la NC se aplicara contra la factura relacionada
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.1 11-03.2015
  * since  1.0
  *
  * Se considera el estado Anulado para los casos de Anulaciones de comprobantes electronicos
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.2 13-07.2016
  *
  * Se crea un historial en el caso de anulacion por medio de DB_CMPROBANTES
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.3 27-07.2016
  *
  * Se agrega Verificacion al momento de reenviar el documento Rechazado
  * se verifica si documento Factura tiene Saldo pendiente, en caso de no tener Saldo, documento pasa a Cerrado
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.4 07-02-2018
  *
  * Se agregan logs de monitoreo 'LOG AFTER_DML_INFO_COMP_ELEC' debido a falta de generación de
  * NDI y ANTC en el ambiente de producción.
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.5 28-05-2019
  *
  * Se agrega validación para activar el documento financiero cuando el SRI devuelve estado autorizado.
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.6 12-01-2021
  */
  Ln_IdDocumento                INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
  --
  Lrf_ComprobanteElectronico    FNCK_COM_ELECTRONICO.Lr_ComprobanteElectronico;
  --
  Lrf_InfoDocumentoHistorial    FNCK_COM_ELECTRONICO.Lr_InfoDocumentoHistorial;
  --
  Lr_AdmiTipoDocFinanciero      ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
  --
  Lr_InfoDocumentoFinancieroNc  INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  --
  Lv_MsnError                   VARCHAR2(2000);
  --
  Lv_Estado                     VARCHAR2(25) := 'Rechazado';
  --
  Lv_HistActivo                 VARCHAR2(2) := 'N';
  --
  Lex_Exception                 EXCEPTION;
  --
  Lf_Saldo                      FLOAT;
  --
  BEGIN
    --Entra si se actualiza el estado de la tabla

    IF UPDATING('ESTADO') THEN
      --
      Lrf_ComprobanteElectronico.NOMBRE_COMPROBANTE     := :OLD.NOMBRE_COMPROBANTE;
      Lrf_ComprobanteElectronico.ID_COMP_ELECTRONICO    := :OLD.ID_COMP_ELECTRONICO;
      Lrf_ComprobanteElectronico.DOCUMENTO_ID           := :OLD.DOCUMENTO_ID;
      Lrf_ComprobanteElectronico.TIPO_DOCUMENTO_ID      := :OLD.TIPO_DOCUMENTO_ID;
      Lrf_ComprobanteElectronico.NUMERO_FACTURA         := :OLD.NUMERO_FACTURA_SRI;
      --Lrf_ComprobanteElectronico.COMPROBANTE_ELECTRONICO    := :OLD.COMPROBANTE_ELECTRONICO; -- No es necesario guardar
      --Lrf_ComprobanteElectronico.COMPROBANTE_ELECT_DEVUELTO := :OLD.COMPROBANTE_ELECT_DEVUELTO; -- No es necesario guardar
      Lrf_ComprobanteElectronico.FE_AUTORIZACION        := :OLD.FE_AUTORIZACION;
      Lrf_ComprobanteElectronico.NUMERO_AUTORIZACION    := :OLD.NUMERO_AUTORIZACION;
      Lrf_ComprobanteElectronico.CLAVE_ACCESO           := :OLD.CLAVE_ACCESO;
      Lrf_ComprobanteElectronico.ESTADO                 := :OLD.ESTADO;
      Lrf_ComprobanteElectronico.DETALLE                := :OLD.DETALLE;
      Lrf_ComprobanteElectronico.RUC                    := :OLD.RUC;
      Lrf_ComprobanteElectronico.FE_CREACION            := :OLD.FE_CREACION;
      Lrf_ComprobanteElectronico.FE_MODIFICACION        := :OLD.FE_MODIFICACION;
      Lrf_ComprobanteElectronico.USR_CREACION           := :OLD.USR_CREACION;
      Lrf_ComprobanteElectronico.USR_MODIFICACION       := :OLD.USR_MODIFICACION;
      Lrf_ComprobanteElectronico.ENVIADO                := :OLD.ENVIADO;
      Lrf_ComprobanteElectronico.NUMERO_ENVIO           := :OLD.NUMERO_ENVIO;
      Lrf_ComprobanteElectronico.LOTE_MASIVO_ID         := :OLD.LOTE_MASIVO_ID;
      --
      Lrf_InfoDocumentoHistorial.DOCUMENTO_ID           := :OLD.DOCUMENTO_ID;
      Lrf_InfoDocumentoHistorial.MOTIVO_ID              := NULL;
      Lrf_InfoDocumentoHistorial.FE_CREACION            := SYSDATE;
      Lrf_InfoDocumentoHistorial.USR_CREACION           := USER;
      --Crea el historial de la tabla
      FNCK_COM_ELECTRONICO_TRAN.INSERT_COMP_ELECTRONICO_HIST(Lrf_ComprobanteElectronico, Lv_MsnError);
      -- 
      FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '1. INGRESA A LA VALIDACION UPDATING - Crea el historial de la tabla '
                                     || ' ID_DOCUMENTO: '|| :OLD.DOCUMENTO_ID || ' N° FACTURA: '|| :OLD.NUMERO_FACTURA_SRI || ' TIPO DOCUMENTO: '|| :OLD.TIPO_DOCUMENTO_ID);
      --Si existe un error envia un correo
      IF Lv_MsnError IS NOT NULL THEN
            --
            RAISE Lex_Exception;            
            --
      END IF;

      --Obtiene la nota de credito
      Lr_InfoDocumentoFinancieroNc  := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(:OLD.DOCUMENTO_ID, NULL);
      --
      FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '2. UPDATING - Obtiene Tipo de Documento '
                                    || ' TIPO DOCUMENTO: '|| Lr_InfoDocumentoFinancieroNc.TIPO_DOCUMENTO_ID|| ' DOCUMENTO ID: '|| :OLD.DOCUMENTO_ID);
      --Obtiene el tipo de documento id
      Lr_AdmiTipoDocFinanciero      := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(Lr_InfoDocumentoFinancieroNc.TIPO_DOCUMENTO_ID, NULL);
      -- 
      FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '3. UPDATING - Antes de Obtener el tipo de documento y Estado '
                                    || ' DOCUMENTO ID: '|| :OLD.DOCUMENTO_ID ||' TIPO DOC: ' ||Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO || ' Estado: ' ||:OLD.ESTADO );
      --NEW
      FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '3. UPDATING - Después de Obtener el tipo de documento y Estado '
                                    || ' DOCUMENTO ID: '|| :OLD.DOCUMENTO_ID ||' TIPO DOC: ' ||Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO|| ' Estado: ' ||:NEW.ESTADO);

      --Si es estado 5 activa la factura o aplica la nota de credito

      IF :NEW.ESTADO = 5 THEN       
        -- 
        FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '4. UPDATING - Obtiene el estado al ingresar a la validacion ' ||' ESTADO ' || :NEW.ESTADO 
                                      || ' ESTADO DE IMPRESION: '||Lr_InfoDocumentoFinancieroNc.ESTADO_IMPRESION_FACT||' TIPO DOC: '||Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO 
                                      || ' DOCUMENTO ID: '||:OLD.DOCUMENTO_ID);

        -- 
        IF Lr_InfoDocumentoFinancieroNc.ESTADO_IMPRESION_FACT IN ('Activo', 'Cerrado') THEN

          IF Lr_InfoDocumentoFinancieroNc.ESTADO_IMPRESION_FACT = 'Activo' THEN
            Lv_HistActivo:= 'S';
          END IF;

          FNCK_COM_ELECTRONICO_TRAN.UPDATE_DOC_FIN_CAB(:OLD.DOCUMENTO_ID, Lr_InfoDocumentoFinancieroNc.ESTADO_IMPRESION_FACT, :NEW.NUMERO_AUTORIZACION, :NEW.FE_AUTORIZACION, Lv_MsnError);

        ELSIF Lr_InfoDocumentoFinancieroNc.ESTADO_IMPRESION_FACT IN ('Rechazado') THEN

          IF DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_ULTIMO_ESTADO_DOC(:OLD.DOCUMENTO_ID) ='Activo' THEN
            Lv_HistActivo:= 'S';
          END IF;

          FNCK_COM_ELECTRONICO_TRAN.UPDATE_DOC_FIN_CAB(:OLD.DOCUMENTO_ID, DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_ULTIMO_ESTADO_DOC(:OLD.DOCUMENTO_ID), :NEW.NUMERO_AUTORIZACION, :NEW.FE_AUTORIZACION, Lv_MsnError);

        ELSE

          Lv_HistActivo:= 'S';
          FNCK_COM_ELECTRONICO_TRAN.UPDATE_DOC_FIN_CAB(:OLD.DOCUMENTO_ID, 'Activo', :NEW.NUMERO_AUTORIZACION, :NEW.FE_AUTORIZACION, Lv_MsnError);

        END IF;
        --
        FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '5. UPDATING - Actualiza el Estado de Impresion de Fact.: ' || Lr_InfoDocumentoFinancieroNc.ESTADO_IMPRESION_FACT 
                                      ||' TIPO DOCUMENTO: '|| Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO || ' ESTADO: '||:NEW.ESTADO || ' DOCUMENTO ID: '||:OLD.DOCUMENTO_ID);

        IF Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO IN ('FACP','FAC') THEN
          --
          Lf_Saldo:= ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(:OLD.DOCUMENTO_ID, '', 'saldo'),2);
          --
          FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '6. Inserta el saldo de la Factura ID_DOCUMENTO: '|| :OLD.DOCUMENTO_ID || ' es Lf_Saldo: '|| Lf_Saldo);
          IF Lf_Saldo<=0 THEN              
            FNCK_COM_ELECTRONICO_TRAN.UPDATE_DOC_FIN_CAB(:OLD.DOCUMENTO_ID, 'Cerrado', :NEW.NUMERO_AUTORIZACION, :NEW.FE_AUTORIZACION, Lv_MsnError);

            FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', 'SALDO - Se cierra Factura ID_DOCUMENTO: '|| :OLD.DOCUMENTO_ID || ' por saldo Lf_Saldo: '|| Lf_Saldo);
          END IF;          
          --
        END IF;
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        IF Lv_HistActivo = 'S'  THEN
          --
          Lrf_InfoDocumentoHistorial.ESTADO         := 'Activo';
          Lrf_InfoDocumentoHistorial.OBSERVACION    := 'Se Activo la ' || Lr_AdmiTipoDocFinanciero.NOMBRE_TIPO_DOCUMENTO ||
                                                       ', Historial creado por trigger AFTER_DML_INFO_COMP_ELEC';
          FNCK_COM_ELECTRONICO_TRAN.INSERT_DOCUMENTO_HISTORIAL(Lrf_InfoDocumentoHistorial, Lv_MsnError);
          --

          IF Lv_MsnError IS NOT NULL THEN
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
        END IF;
        --Si es nota de credito se ejecuta el proceso de aplicar

        FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '7. Verifica el tipo de documento para ejecutar el proceso de P_APLICA_NOTA_CREDITO - '||
                                      ' Codigo Tipo_Documento: '|| Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO||' DOCUMENTO ID: '||:OLD.DOCUMENTO_ID || ' ESTADO: '||:NEW.ESTADO );

        IF Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO = 'NC' THEN

          --Aplica la nota de credito
          FNCK_CONSULTS.P_APLICA_NOTA_CREDITO(Lr_InfoDocumentoFinancieroNc.ID_DOCUMENTO, NULL, Lr_InfoDocumentoFinancieroNc.OFICINA_ID, Lv_MsnError);            

          --LOG PARA MONITOREO DE BUG
          FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '8. Ingresó a FNCK_CONSULTS.P_APLICA_NOTA_CREDITO y se Aplico NC  ID_DOCUMENTO: '|| :OLD.DOCUMENTO_ID || 
                                        ' OFICINA_ID: ' || Lr_InfoDocumentoFinancieroNc.OFICINA_ID || ' ESTADO: '||:NEW.ESTADO ||' Lv_MsnError: '||Lv_MsnError);            
          IF Lv_MsnError IS NOT NULL THEN
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
        END IF;
        --
        --
        FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '9. Verifica el estado del documento antes de Rechazarlo: ' ||
                                      ' ESTADO: '|| :NEW.ESTADO||' DOCUMENTO ID: '||:OLD.DOCUMENTO_ID);
        --
      ELSIF :NEW.ESTADO NOT IN (1, 10, 9) THEN
        --
        IF :NEW.ESTADO = 8 THEN
            Lv_Estado := 'Anulado';
        END IF;
        --Si el estado no es Iniciado, Actualizado o Creado => Rechaza el documento Financiero
        FNCK_COM_ELECTRONICO_TRAN.UPDATE_DOC_FIN_CAB(:OLD.DOCUMENTO_ID, Lv_Estado, :NEW.NUMERO_AUTORIZACION, :NEW.FE_AUTORIZACION, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --        
        FNCK_TRANSACTION.INSERT_ERROR('LOG AFTER_DML_INFO_COMP_ELEC', 'DB_FINANCIERO.AFTER_DML_INFO_COMP_ELEC', '10. FIN LOG - ESTADO: '|| Lv_Estado ||
                                      ' NOMBRE DOCUMENTO: '||Lr_AdmiTipoDocFinanciero.NOMBRE_TIPO_DOCUMENTO||' DOCUMENTO ID: '||:OLD.DOCUMENTO_ID);

        Lrf_InfoDocumentoHistorial.ESTADO      := Lv_Estado;
        Lrf_InfoDocumentoHistorial.OBSERVACION := 'Se ha ' || Lv_Estado || ' la ' || Lr_AdmiTipoDocFinanciero.NOMBRE_TIPO_DOCUMENTO || 
                                                  ', Historial creado por trigger AFTER_DML_INFO_COMP_ELEC';
        --
        IF :NEW.ESTADO = 8 THEN
            Lrf_InfoDocumentoHistorial.USR_CREACION := 'DB_COMPROBANTES';
            Lrf_InfoDocumentoHistorial.OBSERVACION  := 'Se ha ' || Lv_Estado || ' la ' || Lr_AdmiTipoDocFinanciero.NOMBRE_TIPO_DOCUMENTO || 
                                                       ', Historial creado por trigger AFTER_INFO_DOCUMENTO';
        END IF;
        --
        FNCK_COM_ELECTRONICO_TRAN.INSERT_DOCUMENTO_HISTORIAL(Lrf_InfoDocumentoHistorial, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
      END IF;
      --
    END IF;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('notificaciones_telcos@telconet.ec', 
                                             'Error Trigger - AFTER_DML_INFO_COMP_ELEC', 
                                             'Existio un error en el trigger - ERROR_STACK: ' ||
                                             DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' || 
                                             Lv_MsnError, 'FACE');
  WHEN OTHERS THEN
    FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA('notificaciones_telcos@telconet.ec', 
                                             'Error Trigger - AFTER_DML_INFO_COMP_ELEC', 
                                             'Existio un error en el trigger - ERROR_STACK: ' ||
                                             DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ' || 
                                             Lv_MsnError, 'FACE');
    --
  END AFTER_DML_INFO_COMP_ELEC;
/
