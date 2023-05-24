CREATE OR REPLACE TRIGGER DB_COMPROBANTES.TRG_AFTER_INFO_DOCUMENTO_V2 AFTER
  UPDATE ON DB_COMPROBANTES.INFO_DOCUMENTO REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
DECLARE

    /**
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.1 11-03.2015
    * since  1.0
    *
    * @author Gernan Valenzuela <gvalenzuela@telconet.ec>
    * @version 1.2 30-10-2017
    * Descripcion: Anula la actualizacion del estado del documento que haya sido configurado en las tablas ADMI_PARAMETRO_CAB y ADMI_PARAMETRO_DET
    *
    * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
    * @version 1.2 15-12-2017
    * Descripcion: Se agrega en la llmada del proceso P_UPDATE_ESTADO_COMP_ELECT el id del documento de financiero.
    *
    * @author Germán Valenzuela <gvalenzuela@telconet.ec>
    * @version 1.2 16-01-2018
    * Descripcion: Se actualiza el trigger para poder crear el proceso del documento y asi mismo eliminarlo.
    *
    * @author Germán Valenzuela <mmieles@telconet.ec>
    * @version 1.2 16-01-2018
    * Descripcion: Se actualiza version de TGR.
    */

    CURSOR C_Parametros(Cv_NombreParameteroCab VARCHAR2,
                        Cv_EstadoParametroCab  VARCHAR2,
                        Cv_EstadoParametroDet  VARCHAR2,
                        Cv_Valor1              VARCHAR2,
                        Cv_Valor2              VARCHAR2,
                        Cv_Valor3              VARCHAR2,
                        Cv_Valor4              VARCHAR2,
                        Cn_EmpresaId           NUMBER) IS
      SELECT APD.*
      FROM DB_COMPROBANTES.ADMI_PARAMETRO_CAB APC,
           DB_COMPROBANTES.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
      AND APC.ESTADO           = Cv_EstadoParametroCab
      AND APD.ESTADO           = Cv_EstadoParametroDet
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParameteroCab
      AND APD.VALOR1           = Cv_Valor1
      AND APD.VALOR2           = Cv_Valor2
      AND APD.VALOR3           = Cv_Valor3
      AND APD.VALOR4           = Cv_Valor4
      AND APD.EMPRESA_ID       = Cn_EmpresaId;

    CURSOR C_Empresa(Cn_IdEmpresa NUMBER) IS
      SELECT * FROM DB_COMPROBANTES.ADMI_EMPRESA WHERE ID_EMPRESA = Cn_IdEmpresa;

    CURSOR C_ProcesoDoc(Cn_IdDocumento NUMBER) IS
      SELECT *
       FROM DB_COMPROBANTES.INFO_PROCESO_DOC
      WHERE DOCUMENTO_ID = Cn_IdDocumento;

    CURSOR C_ExisteMensajeAut(Cn_IdDocumento NUMBER) IS
      SELECT *
      FROM DB_COMPROBANTES.INFO_MENSAJE MEN
      WHERE MEN.DOCUMENTO_ID = Cn_IdDocumento
       AND MEN.TIPO = 'INFORMACION'
       AND MEN.MENSAJE = 'AUTORIZADO';

    --Variables Locales
    Lc_Parametros    C_Parametros%ROWTYPE;
    Lc_Empresa       C_Empresa%ROWTYPE;
    Lc_ExisteProceso C_ProcesoDoc%ROWTYPE;
    Lc_ExisteMensAut C_ExisteMensajeAut%ROWTYPE;
    Lb_Vacio         BOOLEAN;
    Lex_Exception    EXCEPTION;
    Lv_MsnError      VARCHAR2(3000);

  BEGIN

    IF C_Parametros%ISOPEN THEN
      CLOSE C_Parametros;
    END IF;

    IF C_Empresa%ISOPEN THEN
      CLOSE C_Empresa;
    END IF;

    IF C_ProcesoDoc%ISOPEN THEN
      CLOSE C_ProcesoDoc;
    END IF;

    IF C_ExisteMensajeAut%ISOPEN THEN
      CLOSE C_ExisteMensajeAut;
    END IF;

    --Entra si se actualiza el estado de la tabla
    IF UPDATING('ESTADO_DOC_ID') THEN

      OPEN C_Empresa(:OLD.EMPRESA_ID);
      FETCH C_Empresa
        INTO Lc_Empresa;
        --
          Lb_Vacio := C_Empresa%FOUND;
        --
      CLOSE C_Empresa;

      IF Lb_Vacio THEN

        --Verificamos los cambios de estados no permitidos
        OPEN C_Parametros('CAMBIOS_ESTADOS_NO_PERMITIDOS',
                          'Activo',
                          'Activo',
                          'FAC',
                          :OLD.ESTADO_DOC_ID,
                          :NEW.ESTADO_DOC_ID,
                           Lc_Empresa.CODIGO,
                          :OLD.EMPRESA_ID);
        FETCH C_Parametros
          INTO Lc_Parametros;
          --
            Lb_Vacio := C_Parametros%FOUND;
          --
        CLOSE C_Parametros;

        --Si el cursor devuelve valores se procede con la eliminacion del proceso y cancelamos la actualizacion.
        IF Lb_Vacio THEN

          DB_COMPROBANTES.DCKG_TRANSACTION.P_DELETE_INFO_PROCESO_DOC(Pn_IdDocumento => :OLD.ID_DOCUMENTO);
          RAISE Lex_Exception;

        END IF;

      END IF;

      --=== Comienzo de la creación del proceso para el comprobante electronico =====

      --Se elimina el proceso si el nuevo estado del comprobante es:
      --0 (Error) ; 8 (Anulado) ; 9(Descartado)
      IF :NEW.ESTADO_DOC_ID IN (0,8,9) THEN

          DB_COMPROBANTES.DCKG_TRANSACTION.P_DELETE_INFO_PROCESO_DOC(:OLD.ID_DOCUMENTO);

      -- Si el estado es 1 (Iniciado) Creamos el proceso o lo actualizamos de existir
      ELSIF :NEW.ESTADO_DOC_ID = 1 THEN

           OPEN C_ProcesoDoc(:OLD.ID_DOCUMENTO);
            FETCH C_ProcesoDoc
              INTO Lc_ExisteProceso;
                Lb_Vacio := C_ProcesoDoc%FOUND;
           CLOSE C_ProcesoDoc;

           IF Lb_Vacio THEN

             DB_COMPROBANTES.DCKG_TRANSACTION.P_UPDATE_INFO_PROCESO_DOC(:OLD.ID_DOCUMENTO,
                                                                        :NEW.ESTADO_DOC_ID,
                                                                         NULL,
                                                                         NULL);

           ELSE

            DB_COMPROBANTES.DCKG_TRANSACTION.P_INSERT_INFO_PROCESO_DOC(:OLD.ID_DOCUMENTO,
                                                                       :OLD.EMPRESA_ID,
                                                                       :OLD.TIPO_DOC_ID,
                                                                       :NEW.ESTADO_DOC_ID,
                                                                       :OLD.IP_CREACION,
                                                                        NULL,
                                                                        NULL,
                                                                        DB_COMPROBANTES.DCKG_CONSULTS.F_LOTE_PERTENECE);

          END IF;

      -- Si el estado es 5 Verificamos si no tiene mensaje de autorización en caso de tenenerlo se elimina el proceso caso contrario
      -- se verigica si ya cuenta con un proceso para actualizaro o crearlo
      ELSIF :NEW.ESTADO_DOC_ID = 5 THEN

         OPEN C_ExisteMensajeAut(:OLD.ID_DOCUMENTO);
           FETCH C_ExisteMensajeAut
            INTO Lc_ExisteMensAut;
              Lb_Vacio := C_ExisteMensajeAut%FOUND;
         CLOSE C_ExisteMensajeAut;

         IF Lb_Vacio THEN

            DB_COMPROBANTES.DCKG_TRANSACTION.P_DELETE_INFO_PROCESO_DOC(Pn_IdDocumento => :OLD.ID_DOCUMENTO);

         ELSE

           OPEN C_ProcesoDoc(:OLD.ID_DOCUMENTO);
            FETCH C_ProcesoDoc
              INTO Lc_ExisteProceso;
                Lb_Vacio := C_ProcesoDoc%FOUND;
           CLOSE C_ProcesoDoc;

           IF Lb_Vacio THEN

             DB_COMPROBANTES.DCKG_TRANSACTION.P_UPDATE_INFO_PROCESO_DOC(:OLD.ID_DOCUMENTO,
                                                                         3,
                                                                        :NEW.FE_ENVIADO,
                                                                        :NEW.FE_ULT_INTENTO_CONSULTA);

           ELSE

            DB_COMPROBANTES.DCKG_TRANSACTION.P_INSERT_INFO_PROCESO_DOC(:OLD.ID_DOCUMENTO,
                                                                       :OLD.EMPRESA_ID,
                                                                       :OLD.TIPO_DOC_ID,
                                                                        3,
                                                                       :OLD.IP_CREACION,
                                                                       :NEW.FE_ENVIADO,
                                                                       :NEW.FE_ULT_INTENTO_CONSULTA,
                                                                        DB_COMPROBANTES.DCKG_CONSULTS.F_LOTE_PERTENECE);

           END IF;

         END IF;

      END IF;

      DB_FINANCIERO.FNCK_COM_ELECTRONICO.P_UPDATE_ESTADO_COMP_ELECT(:OLD.DOCUMENTO_ID_FINAN,
                                                                    :NEW.ESTADO_DOC_ID,
                                                                    :OLD.CLAVE_ACCESO,
                                                                    :NEW.CLAVE_ACCESO,
                                                                    :NEW.FE_AUTORIZACION,
                                                                    :NEW.NUMERO_AUTORIZACION,
                                                                     Lv_MsnError);

    END IF;

  EXCEPTION

    WHEN Lex_Exception THEN

      --Cancela la transaccion y crea un codigo de error
      RAISE_APPLICATION_ERROR(-20001, 'Error en INFO_DOCUMENTO cambios de estados no permitidos, '
                              || SYS_CONTEXT ('USERENV', 'HOST')
                              || ' trato de cambiar los estados de '|| :OLD.ESTADO_DOC_ID
                              || ' a ' || :NEW.ESTADO_DOC_ID || ' '
                              || DBMS_UTILITY.FORMAT_ERROR_STACK
                              || ' ERROR_BACKTRACE: '
                              || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    WHEN OTHERS THEN

      --Cancela la transaccion y crea un codigo de error
      RAISE_APPLICATION_ERROR(-20001, 'Error en INFO_DOCUMENTO '
                              || DBMS_UTILITY.FORMAT_ERROR_STACK
                              || ' ERROR_BACKTRACE: '
                              || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

  END TRG_AFTER_INFO_DOCUMENTO_V2;
/
