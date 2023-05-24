CREATE OR REPLACE TRIGGER DB_COMERCIAL.AFTER_INFO_CONTRATO
   AFTER INSERT OR UPDATE
   ON DB_COMERCIAL.INFO_CONTRATO
   FOR EACH ROW
DECLARE
    CURSOR C_GetFacturasInstalacion (Cn_PersonaEmpresaRolId DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE,
                                     Cv_EstadoActivo        VARCHAR2 DEFAULT 'Activo',
                                     Cv_EstadoEliminado     VARCHAR2 DEFAULT 'Eliminado',
                                     Cv_ValorS              VARCHAR2 DEFAULT 'S',
                                     Cv_Origen              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                     Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE DEFAULT 'SOLICITUDES_DE_CONTRATO')
    IS
        SELECT DISTINCT IDFC.ID_DOCUMENTO, IDC.ID_DOCUMENTO_CARACTERISTICA, IDFC.ESTADO_IMPRESION_FACT
          FROM DB_COMERCIAL.INFO_PUNTO IP,
               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
               DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
               DB_COMERCIAL.ADMI_CARACTERISTICA AC
         WHERE IP.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId
           AND IP.ID_PUNTO = IDFC.PUNTO_ID
           AND IDFC.ID_DOCUMENTO = IDC.DOCUMENTO_ID
           AND IDC.ESTADO = Cv_EstadoActivo
           AND IDC.VALOR = Cv_ValorS
           AND IDC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
           AND AC.DESCRIPCION_CARACTERISTICA IN (SELECT VALOR2
                                                   FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                        DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                  WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                                                    AND CAB.ESTADO = Cv_EstadoActivo
                                                    AND DET.PARAMETRO_ID = CAB.ID_PARAMETRO
                                                    AND DET.VALOR1 <> Cv_Origen
                                                    AND DET.ESTADO <> Cv_EstadoEliminado);
    Lv_Mensaje                VARCHAR2(1000) := NULL;
    Lr_InfoDocumentoCaract    DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
    Lr_InfoDocumentoHistorial DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Le_Exception              EXCEPTION;
    Le_NoAplicaFlujo          EXCEPTION;
    Ln_CaractContrato         DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Lv_UsrCreacion            VARCHAR2(15);

    Lr_InfoDocumentoFinancieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;

    CURSOR C_GetCaractXOrigen (Cv_EstadoActivo        VARCHAR2 DEFAULT 'Activo',
                               Cv_EstadoEliminado     VARCHAR2 DEFAULT 'Eliminado',
                               Cv_Origen              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                               Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE DEFAULT 'SOLICITUDES_DE_CONTRATO')
    IS
        SELECT AC.ID_CARACTERISTICA, DET.VALOR6
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
               DB_GENERAL.ADMI_PARAMETRO_DET DET,
               DB_COMERCIAL.ADMI_CARACTERISTICA AC
         WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
           AND CAB.ESTADO = Cv_EstadoActivo
           AND DET.PARAMETRO_ID = CAB.ID_PARAMETRO
           AND DET.VALOR1 = Cv_Origen
           AND DET.ESTADO <> Cv_EstadoEliminado
           AND DET.VALOR2 = AC.DESCRIPCION_CARACTERISTICA
           AND AC.ESTADO = Cv_EstadoActivo;

    CURSOR C_GetEmpresa (Cn_IdPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
        SELECT IOG.EMPRESA_ID
          FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
               DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
         WHERE IPER.ID_PERSONA_ROL = Cn_IdpersonaEmpresaRol
           AND IPER.OFICINA_ID = IOG.ID_OFICINA;

    Lv_EmpresaCod     DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE;
    Lv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;

    CURSOR C_GetServiciosXCliente (Cn_PerEmpRolId    DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE,
                                   Cv_EstadoActivo   VARCHAR2 DEFAULT 'Activo',
                                   Cv_EstadoFactible VARCHAR2 DEFAULT 'Factible')
    IS
        SELECT ISER.PUNTO_ID, ISER.ID_SERVICIO
          FROM DB_COMERCIAL.INFO_PUNTO IP,
               DB_COMERCIAL.INFO_SERVICIO ISER
         WHERE IP.PERSONA_EMPRESA_ROL_ID = Cn_PerEmpRolId
           AND IP.ID_PUNTO = ISER.PUNTO_ID
           AND IP.ESTADO = Cv_EstadoActivo
           AND ISER.ESTADO = Cv_EstadoFactible;
BEGIN

    IF INSERTING OR UPDATING('ORIGEN') THEN
        OPEN  C_GetEmpresa (Cn_IdPersonaEmpresaRol => :NEW.PERSONA_EMPRESA_ROL_ID);
        FETCH C_GetEmpresa INTO Lv_EmpresaCod;
        CLOSE C_GetEmpresa;

        --Se verifica que la empresa aplique al flujo de facturaci�n de instalaci�n.
        IF 'S' <> DB_GENERAL.GNRLPCK_UTIL.F_EMPRESA_APLICA_PROCESO('FACTURACION_INSTALACION_PUNTOS_ADICIONALES', Lv_EmpresaCod) THEN
            RAISE Le_NoAplicaFlujo;
        END IF;

        --Se obtiene la caracter�stica relacionada al contrato seg�n su origen.
        OPEN  C_GetCaractXOrigen(Cv_Origen => NVL(:NEW.ORIGEN, 'WEB'));
        FETCH C_GetCaractXOrigen INTO Ln_CaractContrato, Lv_UsrCreacion;
        CLOSE C_GetCaractXOrigen;

        --Se regularizan las facturas creadas con un origen espec�fico.
        FOR Lr_Facturas IN C_GetFacturasInstalacion(Cn_PersonaEmpresaRolId => :NEW.PERSONA_EMPRESA_ROL_ID,
                                                    Cv_Origen              => NVL(:NEW.ORIGEN, 'WEB'))
        LOOP
            --Se actualiza el usuario de la factura por el nuevo origen del contrato.
            Lr_InfoDocumentoFinancieroCab              := NULL;
            Lr_InfoDocumentoFinancieroCab.USR_CREACION := Lv_UsrCreacion;
            DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_Facturas.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Lv_Mensaje);
            IF Lv_Mensaje IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;

            --Se actualiza la caracter�stica de la factura por el nuevo origen del contrato.
            Lr_InfoDocumentoCaract                             := NULL;
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := Lr_Facturas.ID_DOCUMENTO_CARACTERISTICA;
            Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_CaractContrato;
            Lr_InfoDocumentoCaract.FE_ULT_MOD                  := SYSDATE;
            Lr_InfoDocumentoCaract.USR_ULT_MOD                 := Lv_UsrCreacion;
            Lr_InfoDocumentoCaract.IP_ULT_MOD                  := '127.0.0.1';
            DB_FINANCIERO.FNCK_TRANSACTION.P_UPDATE_INFO_DOCUMENTO_CARACT(Pr_InfoDocumentoCaract => Lr_InfoDocumentoCaract,
                                                                          Pv_MsnError            => Lv_Mensaje);
            IF Lv_Mensaje IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;

            --Inserta el historial de regularizaci�n.
            Lr_InfoDocumentoHistorial                        := NULL;
            Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
            Lr_InfoDocumentoHistorial.DOCUMENTO_ID           := Lr_Facturas.ID_DOCUMENTO;
            Lr_InfoDocumentoHistorial.FE_CREACION            := SYSDATE;
            Lr_InfoDocumentoHistorial.USR_CREACION           := Lv_UsrCreacion;
            Lr_InfoDocumentoHistorial.ESTADO                 := Lr_Facturas.ESTADO_IMPRESION_FACT;
            Lr_InfoDocumentoHistorial.OBSERVACION            := 'Regularizaci�n de facturas de instalaci�n: Se actualiza caracter�stica por origen '
                                                                || NVL(:NEW.ORIGEN, 'WEB');
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoHistorial, Lv_Mensaje);
            IF Lv_Mensaje IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
        END LOOP;
    END IF;
EXCEPTION
    WHEN Le_NoAplicaFlujo THEN
        NULL;
    WHEN Le_Exception THEN
        RAISE_APPLICATION_ERROR(-20002, Lv_Mensaje);
    WHEN OTHERS THEN  
        RAISE_APPLICATION_ERROR(-20001, DBMS_UTILITY.FORMAT_ERROR_STACK || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
