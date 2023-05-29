CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_VENDEDOR_MASIVO AS

    /**
     * Documentación Para CMKG_VENDEDOR_MASIVO
     * Paquete que contiene procedimientos y funciones para el cambio masivo de vendedor
     *
     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 13/10/2019
     *
     * @author Kevin Baque Puya <kbaque@telconet.ec>
     * @version 1.1 17-03-2021 - Se agrega nuevo Types de la tabla DB_DOCUMENTAL.INFO_DOCUMENTO
    */

    /*
    *  Types Del Paquete
    */
    TYPE T_Array_Id IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    TYPE T_Array_Ip IS TABLE OF DB_COMERCIAL.INFO_PERSONA%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Ipun IS TABLE OF DB_COMERCIAL.INFO_PUNTO%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Iser IS TABLE OF DB_COMERCIAL.INFO_SERVICIO%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Isc IS TABLE OF DB_COMERCIAL.INFO_SERVICIO_COMISION%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Iserh IS TABLE OF DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE T_Array_Documento IS TABLE OF DB_DOCUMENTAL.INFO_DOCUMENTO%ROWTYPE INDEX BY BINARY_INTEGER;
    /**
     *
     * Procedimiento que realiza la creación masiva de contactos a nivel puntos y/o cliente
     *
     * Costo Del Query C_GetInfoPersona:           2
     * Costo Del Query C_GetInfoDetalleSolicitud:  2
     * Costo Del Query C_GetInfoPersonaEmpresaRol: 3
     * Costo Del Query C_GetAdmiMotivo:            2
     * Costo Del Query C_GetInfoLog:               4
     * Costo Del Query C_GetInfoPunto:             2
     * Costo Del Query C_GetInfoServicio:          2
     * Costo Del Query C_GetInfoServicioComision:  4
     *
     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.0 13/12/2019

     * @Author Christian Jaramillo Espinoza <cjaramilloe@telconet.ec>
     * @Version 1.1 02/04/2020 Se asigna al estado del historial del servicio el estado actual del servicio.
     *
     * @author Kevin Baque Puya <kbaque@telconet.ec>
     * @version 1.2 17-03-2021 - Se agrega nueva lógica que permite actualizar los documentos del vendedor.
     *
     *
     * @PARAM Pn_Id_Solicitud              IN NUMBER    Id de la solicitud
     * @PARAM Pv_Accion                    IN VARCHAR2  Acción de la solicitud
     * @PARAM Pn_Id_Vendedor_Origen        IN NUMBER    Id del vendedor origen
     * @PARAM Pn_Id_Vendedor_Destino       IN NUMBER    Id del vendedor destino
     * @PARAM Pn_Id_Motivo_Rechazo         IN NUMBER    Id del motivo de rechazo
     * @PARAM Pcl_Id_Clientes              IN CLOB      Id de los clientes
     * @PARAM Pcl_Extraparams              IN CLOB      Parámetros adicionales
     **** @PARAM intIdOficina              NUMBER       Id De Oficina
     **** @PARAM strCodEmpresa             VARCHAR2     Id De Empresa
     **** @PARAM strUsuario                VARCHAR2     Usuario Creador
     **** @PARAM strIp                     VARCHAR2     Ip Creador
     **** @PARAM strCambiarANivelPunto     VARCHAR2     Bandera para cambiar a nivel punto
     **** @PARAM strCambiarANivelServicio  VARCHAR2     Bandera para cambiar a nivel servicio
     * @PARAM Pn_Status_Error              OUT NUMBER   Status del procedimiento
     * @PARAM Pv_Mensaje_Error             OUT VARCHAR2 Mensaje de error del procedimiento
     *
     **/
    PROCEDURE P_CAMBIAR_CLIENTES_VENDEDOR(Pn_Id_Solicitud        IN  NUMBER,
                                          Pv_Accion              IN  VARCHAR2,
                                          Pn_Id_Vendedor_Origen  IN  NUMBER,
                                          Pn_Id_Vendedor_Destino IN  NUMBER,
                                          Pn_Id_Motivo_Rechazo   IN  NUMBER,
                                          Pcl_Id_Clientes        IN  CLOB,
                                          Pcl_Extra_Params       IN  CLOB,
                                          Pn_Status_Error        OUT NUMBER,
                                          Pv_Mensaje_Error       OUT VARCHAR2);

END CMKG_VENDEDOR_MASIVO;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_VENDEDOR_MASIVO AS

    PROCEDURE P_CAMBIAR_CLIENTES_VENDEDOR(Pn_Id_Solicitud        IN  NUMBER,
                                          Pv_Accion              IN  VARCHAR2,
                                          Pn_Id_Vendedor_Origen  IN  NUMBER,
                                          Pn_Id_Vendedor_Destino IN  NUMBER,
                                          Pn_Id_Motivo_Rechazo   IN  NUMBER,
                                          Pcl_Id_Clientes        IN  CLOB,
                                          Pcl_Extra_Params       IN  CLOB,
                                          Pn_Status_Error        OUT NUMBER,
                                          Pv_Mensaje_Error       OUT VARCHAR2) IS
    
    CURSOR C_GetInfoPersona(Ln_Id NUMBER) IS
        SELECT ip.*
        FROM DB_COMERCIAL.INFO_PERSONA ip 
            INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
            ON ip.ID_PERSONA = iper.PERSONA_ID
        WHERE iper.ID_PERSONA_ROL = Ln_Id;

    CURSOR C_GetInfoDetalleSolicitud(Ln_Id NUMBER) IS
        SELECT ids.*
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
        WHERE ids.ID_DETALLE_SOLICITUD = Ln_Id;

    CURSOR C_GetInfoPersonaEmpresaRol(Ln_Id NUMBER) IS
        SELECT NVL(MAX(iper.ID_PERSONA_ROL), 0)
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
        WHERE iper.ID_PERSONA_ROL = Ln_Id;

    CURSOR C_GetAdmiMotivo(Ln_Id NUMBER) IS
        SELECT am.*
        FROM DB_COMERCIAL.ADMI_MOTIVO am
        WHERE am.ID_MOTIVO = Ln_Id;

    CURSOR C_GetInfoLog(Ln_Id NUMBER) IS
        SELECT il.*
        FROM DB_GENERAL.INFO_LOG il
        WHERE il.APLICACION = Ln_Id
        AND il.ESTADO = 'Pendiente';

    CURSOR C_GetInfoPunto(Ln_Id NUMBER) IS
        SELECT ipto.*
        FROM DB_COMERCIAL.INFO_PUNTO ipto
        WHERE ipto.PERSONA_EMPRESA_ROL_ID = Ln_Id;

    CURSOR C_GetInfoServicio(Ln_Id NUMBER) IS
        SELECT iser.*
        FROM DB_COMERCIAL.INFO_PUNTO ipto
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO iser
            ON ipto.ID_PUNTO = iser.PUNTO_ID
        WHERE ipto.PERSONA_EMPRESA_ROL_ID = Ln_Id;

    CURSOR C_GetInfoServicioComision(Ln_Id NUMBER) IS
        SELECT isc.*
        FROM DB_COMERCIAL.INFO_PUNTO ipto
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO iser
            ON ipto.ID_PUNTO = iser.PUNTO_ID
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_COMISION isc
            ON iser.ID_SERVICIO = isc.SERVICIO_ID
        WHERE ipto.PERSONA_EMPRESA_ROL_ID = Ln_Id 
            AND isc.PERSONA_EMPRESA_ROL_ID NOT IN (
                SELECT iper.ID_PERSONA_ROL
                FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ipr 
                    ON iper.EMPRESA_ROL_ID = ipr.ID_EMPRESA_ROL
                    INNER JOIN DB_COMERCIAL.ADMI_ROL ar 
                    ON ar.ID_ROL = ipr.ROL_ID
                WHERE ipr.EMPRESA_COD = '10'       -- Telconet
                    AND ar.TIPO_ROL_ID = 1         -- Empleado
                    AND iper.DEPARTAMENTO_ID = 831 -- Dep. Producto
                    AND iper.ESTADO = 'Activo');

    CURSOR C_GetIdUsuario (CV_LOGIN_VENDEDOR VARCHAR2,
                           CV_ESTADO         VARCHAR2) IS
    SELECT
        AEU.*
    FROM
        DB_DOCUMENTAL.ADMI_USUARIO           AU
        JOIN DB_DOCUMENTAL.ADMI_EMPRESA_USUARIO   AEU ON AEU.USUARIO_ID = AU.ID_USUARIO
                                                         AND AEU.ESTADO = CV_ESTADO
                                                         AND AU.ESTADO  = CV_ESTADO
        JOIN DB_DOCUMENTAL.ADMI_EMPRESA           AE  ON AE.ID_EMPRESA  = AEU.EMPRESA_ID
                                                         AND AE.ESTADO  = CV_ESTADO
    WHERE
        AU.LOGIN = CV_LOGIN_VENDEDOR;

    CURSOR C_GetDocumento (
        CN_ID_VENDEDOR_ORIGEN_DOC   VARCHAR2,
        CV_IDENTIFICACION_CLIENTE   VARCHAR2,
        CV_CODEMPRESA               VARCHAR2,
        CV_ESTADO                   VARCHAR2,
        CV_VALORETIQUETA            VARCHAR2
    ) IS
    SELECT
        IDOC.*
    FROM
        DB_DOCUMENTAL.INFO_DOCUMENTO                     IDOC
        JOIN DB_DOCUMENTAL.ADMI_EMPRESA_USUARIO          AEU   ON AEU.ID_EMPRESA_USUARIO          = IDOC.PROPIETARIO_ID
                                                                  AND AEU.ESTADO                  = CV_ESTADO
        JOIN DB_DOCUMENTAL.ADMI_USUARIO                  AU    ON AU.ID_USUARIO                   = AEU.USUARIO_ID
                                                                  AND AU.ESTADO                   = CV_ESTADO
        JOIN DB_DOCUMENTAL.ADMI_EMPRESA                  AE    ON AE.ID_EMPRESA                   = AEU.EMPRESA_ID
                                                                  AND AE.ESTADO                   = CV_ESTADO
        JOIN DB_DOCUMENTAL.ADMI_TIPO_DOCUMENTO           ATD   ON ATD.ID_TIPO_DOCUMENTO           = IDOC.TIPO_DOCUMENTO_ID
                                                                  AND ATD.ESTADO                  = CV_ESTADO
        JOIN DB_DOCUMENTAL.ADMI_TIPO_DOCU_ETIQUETA       ATDE  ON ATDE.TIPO_DOCUMENTO_ID          = ATD.ID_TIPO_DOCUMENTO
                                                                  AND LOWER(ATDE.LABEL_KEY)       = CV_VALORETIQUETA
        JOIN DB_DOCUMENTAL.INFO_DOCUMENTO_TIPO_DOCU_ETIQ ADTDE ON ADTDE.DOCUMENTO_ID              = IDOC.ID_DOCUMENTO
                                                                  AND ADTDE.TIPO_DOCU_ETIQUETA_ID = ATDE.ID_TIPO_DOCU_ETIQUETA
    WHERE
        AE.CODIGO                  = CV_CODEMPRESA
        AND ADTDE.VALOR            = CV_IDENTIFICACION_CLIENTE
        AND AEU.ID_EMPRESA_USUARIO = CN_ID_VENDEDOR_ORIGEN_DOC;

    Ln_Id_Cliente_Actual          NUMBER;
    Ln_Cantidad_Clientes          NUMBER;
    Ln_Idoficina                  NUMBER;
    Ln_Indice_Servicio            NUMBER := 1;
    Ln_Cantidad_Clientes_Contador NUMBER := 0;
    Ln_Status_Error               NUMBER := 0; -- 0: Sin error, 1: Con error, 2: Advertencia
    Lv_Usuario                    VARCHAR2(1000) DEFAULT 'Telcos+';
    Lv_Ip                         VARCHAR2(1000) DEFAULT '127.0.0.1';
    Lv_Codempresa                 VARCHAR2(1000) DEFAULT '10';
    Lv_Login_Vendedor_Origen      VARCHAR2(1000);
    Lv_Login_Vendedor_Destino     VARCHAR2(1000);
    Lv_Cambiar_A_Nivel_Punto      VARCHAR2(1000);
    Lv_Cambiar_A_Nivel_Servicio   VARCHAR2(1000);
    Lv_Mensaje_Error              VARCHAR2(32767);
    Lt_Id_Clientes                APEX_JSON.t_values;
    Lr_InfoPersona                DB_COMERCIAL.INFO_PERSONA%ROWTYPE;
    Lr_InfoDetalleSolicitud       DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleSolHisto        DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lr_AdmiMotivo                 DB_COMERCIAL.ADMI_MOTIVO%ROWTYPE;
    Lr_InfoLog                    DB_GENERAL.INFO_LOG%ROWTYPE;
    Lr_InfoServicioHisto          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lt_InfoPunto                  T_Array_Ipun;
    Lt_InfoServicio               T_Array_Iser;
    Lt_InfoServicioComision       T_Array_Isc;
    Lt_InfoServicioHisto          T_Array_Iserh;
    Lv_Identificacion_Cliente     VARCHAR2(1000);
    Ln_Id_Vendedor_Origen_Doc     NUMBER;
    Ln_Id_Vendedor_Destino_Doc    NUMBER;
    Ln_Indice_documento           NUMBER := 1;
    Lr_Admi_Empresa_Usuario       DB_DOCUMENTAL.ADMI_EMPRESA_USUARIO%ROWTYPE;
    Lv_Estado_Activo              VARCHAR2(10) := 'Activo';
    Lv_Valor_Etiqueta             VARCHAR2(10) := 'ruc';
    Lv_Valor_Acceso               VARCHAR2(20) := 'propietario';
    Lt_Info_Documento             T_Array_Documento;
    Lv_Bandera_Continuar_Doc      VARCHAR2(1) := 'S';
    BEGIN
        APEX_JSON.parse(Pcl_Extra_Params);
        Ln_Idoficina                := APEX_JSON.get_number('intIdOficina');
        Lv_Codempresa               := APEX_JSON.get_varchar2('strCodEmpresa');
        Lv_Usuario                  := APEX_JSON.get_varchar2('strUsuario');
        Lv_Ip                       := APEX_JSON.get_varchar2('strIp');
        Lv_Cambiar_A_Nivel_Punto    := APEX_JSON.get_varchar2('strCambiarANivelPunto');
        Lv_Cambiar_A_Nivel_Servicio := APEX_JSON.get_varchar2('strCambiarANivelServicio');

        OPEN C_GetInfoPersona(Pn_Id_Vendedor_Origen);
        FETCH C_GetInfoPersona 
            INTO Lr_InfoPersona;
        CLOSE C_GetInfoPersona;

        IF Lr_InfoPersona.ID_PERSONA IS NULL THEN
            Ln_Status_Error := 1;
            Lv_Mensaje_Error := 'Información de vendedor origen no encontrado.';
            raise NO_DATA_FOUND;
        END IF;

        Lv_Login_Vendedor_Origen := Lr_InfoPersona.login;

        OPEN C_GETIDUSUARIO(Lv_Login_Vendedor_Origen,Lv_Estado_Activo);
        FETCH C_GETIDUSUARIO INTO Lr_Admi_Empresa_Usuario;
        CLOSE C_GETIDUSUARIO;

        IF Lr_Admi_Empresa_Usuario.ID_EMPRESA_USUARIO IS NULL THEN
            Lv_Bandera_Continuar_Doc := 'N';
        END IF;

        Ln_Id_Vendedor_Origen_Doc := Lr_Admi_Empresa_Usuario.ID_EMPRESA_USUARIO;

        OPEN C_GetInfoPersona(Pn_Id_Vendedor_Destino);
        FETCH C_GetInfoPersona 
            INTO Lr_InfoPersona;
        CLOSE C_GetInfoPersona;

        IF Lr_InfoPersona.ID_PERSONA IS NULL THEN
            Ln_Status_Error := 1;
            Lv_Mensaje_Error := 'Información de vendedor destino no encontrado.';
            raise NO_DATA_FOUND;
        END IF;

        Lv_Login_Vendedor_Destino := Lr_InfoPersona.login;

        OPEN C_GETIDUSUARIO(Lv_Login_Vendedor_Destino,Lv_Estado_Activo);
        FETCH C_GETIDUSUARIO INTO Lr_Admi_Empresa_Usuario;
        CLOSE C_GETIDUSUARIO;

        IF Lr_Admi_Empresa_Usuario.ID_EMPRESA_USUARIO IS NULL THEN
            Lv_Bandera_Continuar_Doc := 'N';
        END IF;

        Ln_Id_Vendedor_Destino_Doc := Lr_Admi_Empresa_Usuario.ID_EMPRESA_USUARIO;

        OPEN C_GetInfoDetalleSolicitud(Pn_Id_Solicitud);
        FETCH C_GetInfoDetalleSolicitud 
            INTO Lr_InfoDetalleSolicitud;
        CLOSE C_GetInfoDetalleSolicitud;

        IF Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD IS NULL THEN
            Ln_Status_Error  := 1;
            Lv_Mensaje_Error := 'Id Solicitud no encontrado.';
            raise NO_DATA_FOUND;
        END IF;

        OPEN C_GetInfoLog(Pn_Id_Solicitud);
        FETCH C_GetInfoLog 
            INTO Lr_InfoLog;
        CLOSE C_GetInfoLog;

        IF Pv_Accion IS NULL OR LENGTH(Pv_Accion) <= 0 THEN
            Ln_Status_Error := 1;
            Lv_Mensaje_Error := 'Acción no encontrada.';
            raise NO_DATA_FOUND;
        END IF;

        IF Pv_Accion = 'rechazar' THEN
            OPEN C_GetAdmiMotivo(Pn_Id_Motivo_Rechazo);
            FETCH C_GetAdmiMotivo 
                INTO Lr_AdmiMotivo;
            CLOSE C_GetAdmiMotivo;

            IF Lr_AdmiMotivo.ID_MOTIVO IS NULL THEN
                Ln_Status_Error := 1;
                Lv_Mensaje_Error := 'Id Motivo no encontrado.';
                raise NO_DATA_FOUND;
            END IF;
        END IF;

        APEX_JSON.parse(p_values => Lt_Id_Clientes, 
                        p_source => Pcl_Id_Clientes);

        Ln_Cantidad_Clientes := APEX_JSON.get_count(p_path   => '.', 
                                                    p_values => Lt_Id_Clientes);

        IF Ln_Cantidad_Clientes <= 0 THEN
            Ln_Status_Error := 1;
            Lv_Mensaje_Error := 'Id clientes no encontrados.';
            raise NO_DATA_FOUND;
        END IF;

        WHILE Pv_Accion = 'aprobar' AND Ln_Cantidad_Clientes_Contador < Ln_Cantidad_Clientes LOOP
            Ln_Id_Cliente_Actual := APEX_JSON.get_number(p_path   => '%d',
                                                         p0       => Ln_Cantidad_Clientes_Contador, 
                                                         p_values => Lt_Id_Clientes);

            OPEN C_GetInfoPersona(Ln_Id_Cliente_Actual);
            FETCH C_GetInfoPersona 
                INTO Lr_InfoPersona;
            CLOSE C_GetInfoPersona;

            IF Lr_InfoPersona.ID_PERSONA IS NOT NULL THEN
                IF Lv_Cambiar_A_Nivel_Punto = 'S' THEN
                    OPEN C_GetInfoPunto(Ln_Id_Cliente_Actual);
                      FETCH C_GetInfoPunto 
                      BULK COLLECT INTO Lt_InfoPunto LIMIT 10000000;
                    CLOSE C_GetInfoPunto;

                    IF Lt_InfoPunto.COUNT > 0 THEN
                        FORALL Ln_Indice IN Lt_InfoPunto.FIRST .. Lt_InfoPunto.LAST SAVE EXCEPTIONS
                            UPDATE DB_COMERCIAL.INFO_PUNTO Ipto
                                SET Ipto.Usr_Vendedor = Lv_Login_Vendedor_Destino,
                                    Ipto.Usr_Ult_Mod  = Lv_Usuario,
                                    Ipto.Ip_Ult_Mod   = Lv_Ip,
                                    Ipto.Fe_Ult_Mod   = SYSDATE,
                                    Ipto.Accion       = 'cambio masivo cliente vendedor: ' || Lv_Login_Vendedor_Origen ||
                                                        ' -> ' || Lv_Login_Vendedor_Destino
                                WHERE Ipto.Id_Punto   = Lt_InfoPunto(Ln_Indice).Id_Punto;

                        Lt_InfoPunto.DELETE;
                    END IF;
                END IF;

                IF Lv_Cambiar_A_Nivel_Servicio = 'S' THEN
                    OPEN C_GetInfoServicio(Ln_Id_Cliente_Actual);
                      FETCH C_GetInfoServicio 
                      BULK COLLECT INTO Lt_InfoServicio LIMIT 10000000;
                    CLOSE C_GetInfoServicio;

                    WHILE Ln_Indice_Servicio <= Lt_InfoServicio.COUNT() LOOP
                        Lr_InfoServicioHisto.Id_Servicio_Historial := DB_COMERCIAL.Seq_Info_Servicio_Historial.NEXTVAL;
                        Lr_InfoServicioHisto.Servicio_Id           := Lt_InfoServicio(Ln_Indice_Servicio).Id_Servicio;
                        Lr_InfoServicioHisto.Usr_Creacion          := Lv_Usuario;
                        Lr_InfoServicioHisto.Ip_Creacion           := Lv_Ip;
                        Lr_InfoServicioHisto.Estado                := Lt_InfoServicio(Ln_Indice_Servicio).Estado;
                        Lr_InfoServicioHisto.Fe_Creacion           := SYSDATE;
                        Lr_InfoServicioHisto.Observacion           := 'cambio masivo cliente vendedor: ' || Lv_Login_Vendedor_Origen ||
                                                                      ' -> ' || Lv_Login_Vendedor_Destino;

                        Lt_InfoServicioHisto(Lt_InfoServicioHisto.COUNT) := Lr_InfoServicioHisto;
                        Ln_Indice_Servicio := Ln_Indice_Servicio + 1;
                    END LOOP;

                    Ln_Indice_Servicio := 1;

                    IF Lt_InfoServicio.COUNT > 0 THEN
                        FORALL Ln_Indice IN Lt_InfoServicio.FIRST .. Lt_InfoServicio.LAST SAVE EXCEPTIONS
                            UPDATE DB_COMERCIAL.INFO_SERVICIO Iser
                                SET Iser.USR_VENDEDOR  = Lv_Login_Vendedor_Destino
                                WHERE Iser.ID_SERVICIO = Lt_InfoServicio(Ln_Indice).ID_SERVICIO;

                        Lt_InfoServicio.DELETE;

                        IF Lt_InfoServicioHisto.COUNT > 0 THEN
                          FORALL Ln_Indice IN Lt_InfoServicioHisto.FIRST .. Lt_InfoServicioHisto.LAST SAVE EXCEPTIONS
                            INSERT INTO DB_COMERCIAL.Info_Servicio_Historial VALUES Lt_InfoServicioHisto ( Ln_Indice );

                          Lt_InfoServicioHisto.DELETE;
                        END IF;
                    END IF;

                    OPEN C_GetInfoServicioComision(Ln_Id_Cliente_Actual);
                        FETCH C_GetInfoServicioComision 
                        BULK COLLECT INTO Lt_InfoServicioComision LIMIT 10000000;
                    CLOSE C_GetInfoServicioComision;

                    IF Lt_InfoServicioComision.COUNT > 0 THEN
                        FORALL Ln_Indice IN Lt_InfoServicioComision.FIRST .. Lt_InfoServicioComision.LAST SAVE EXCEPTIONS
                            UPDATE DB_COMERCIAL.INFO_SERVICIO_COMISION Isc
                                SET Isc.PERSONA_EMPRESA_ROL_ID = Pn_Id_Vendedor_Destino,
                                    Isc.USR_ULT_MOD            = Lv_Usuario,
                                    Isc.IP_ULT_MOD             = Lv_Ip,
                                    Isc.FE_ULT_MOD             = SYSDATE
                                WHERE Isc.ID_SERVICIO_COMISION = Lt_InfoServicioComision(Ln_Indice).ID_SERVICIO_COMISION;

                        Lt_InfoServicioComision.DELETE;
                    END IF;
                END IF;

                Lv_Identificacion_Cliente := Lr_InfoPersona.identificacion_cliente;

                IF Lv_Bandera_Continuar_Doc = 'S' AND Lv_Identificacion_Cliente IS NOT NULL THEN
                Ln_Indice_documento := 1;
                --Actualizamos los documentos relacionados a la identificación del cliente, del antiguo vendedor
                    OPEN C_GetDocumento(Ln_Id_Vendedor_Origen_Doc, Lv_Identificacion_Cliente, Lv_Codempresa, Lv_Estado_Activo, Lv_Valor_Etiqueta);
                        FETCH C_GetDocumento BULK COLLECT INTO Lt_Info_Documento LIMIT 10000000;
                        CLOSE C_GetDocumento;
                        WHILE Ln_Indice_documento <= Lt_Info_Documento.COUNT() LOOP

                            UPDATE DB_DOCUMENTAL.INFO_DOCUMENTO_RELACION
                            SET
                                EMPRESA_USUARIO_ID = Ln_Id_Vendedor_Destino_Doc
                            WHERE
                                DOCUMENTO_ID = Lt_Info_Documento(Ln_Indice_documento).ID_DOCUMENTO
                                AND EMPRESA_USUARIO_ID = Ln_Id_Vendedor_Origen_Doc
                                AND LOWER(ACCESO) = Lv_Valor_Acceso;

                            UPDATE DB_DOCUMENTAL.INFO_DOCUMENTO
                            SET
                                PROPIETARIO_ID = Ln_Id_Vendedor_Destino_Doc
                            WHERE
                                ID_DOCUMENTO = Lt_Info_Documento(Ln_Indice_documento).ID_DOCUMENTO
                                AND PROPIETARIO_ID = Ln_Id_Vendedor_Origen_Doc;

                            Ln_Indice_documento := Ln_Indice_documento + 1;
                        END LOOP;
                        Lt_Info_Documento.DELETE;
                END IF;
            ELSE
                Ln_Status_Error  := 2;
                Lv_Mensaje_Error := 'Información de cliente no encontrado. (Id: ' || Ln_Id_Cliente_Actual || ')';
            END IF;

            Ln_Cantidad_Clientes_Contador := Ln_Cantidad_Clientes_Contador + 1;
        END LOOP;

        Lr_InfoDetalleSolicitud.ESTADO       := CASE Pv_Accion WHEN 'aprobar' THEN 'Aprobado' WHEN 'rechazar' THEN 'Rechazado' ELSE NULL END;
        Lr_InfoDetalleSolicitud.FE_EJECUCION := CASE Pv_Accion WHEN 'aprobar' THEN SYSDATE ELSE NULL END;
        Lr_InfoDetalleSolicitud.FE_RECHAZO   := CASE Pv_Accion WHEN 'rechazar' THEN SYSDATE ELSE NULL END;

        UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
            SET ROW = Lr_InfoDetalleSolicitud
            WHERE ids.ID_DETALLE_SOLICITUD = Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD;

        Lr_InfoDetalleSolHisto.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
        Lr_InfoDetalleSolHisto.DETALLE_SOLICITUD_ID   := Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD;
        Lr_InfoDetalleSolHisto.ESTADO                 := Lr_InfoDetalleSolicitud.ESTADO;
        Lr_InfoDetalleSolHisto.OBSERVACION            := Lr_InfoDetalleSolicitud.OBSERVACION;
        Lr_InfoDetalleSolHisto.USR_CREACION           := Lv_Usuario;
        Lr_InfoDetalleSolHisto.FE_CREACION            := SYSDATE;
        Lr_InfoDetalleSolHisto.IP_CREACION            := Lv_Ip;
        Lr_InfoDetalleSolHisto.MOTIVO_ID              := CASE Pv_Accion WHEN 'rechazar' THEN Lr_AdmiMotivo.ID_MOTIVO ELSE NULL END; 

        Lr_InfoLog.ESTADO      := 'Eliminado';
        Lr_InfoLog.FE_ULT_MOD  := SYSDATE;
        Lr_InfoLog.USR_ULT_MOD := Lv_Usuario;

        UPDATE DB_GENERAL.INFO_LOG il
            SET ROW = Lr_InfoLog
            WHERE il.ID_LOG = Lr_InfoLog.ID_LOG;

        INSERT 
            INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST 
            VALUES Lr_InfoDetalleSolHisto;

        Pv_Mensaje_Error := Lv_Mensaje_Error;
        Pn_Status_Error  := Ln_Status_Error;

        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Pv_Mensaje_Error := Lv_Mensaje_Error;
            Pn_Status_Error  := Ln_Status_Error;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS+',
                                                 'CMKG_VENDEDOR_MASIVO.P_CAMBIAR_CLIENTES_VENDEDOR',
                                                 Pv_Mensaje_Error,
                                                 NVL(SYS_CONTEXT('USERENV','HOST'),'TELCOS+'),
                                                 SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
            ROLLBACK;

        WHEN OTHERS THEN
            Pv_Mensaje_Error := 'Ha ocurrido un error inesperado: ' || SQLCODE || ' -ERROR- ' || Substr(SQLERRM, 1, 1000);
            Pn_Status_Error := 1;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('TELCOS+',
                                                 'CMKG_VENDEDOR_MASIVO.P_CAMBIAR_CLIENTES_VENDEDOR',
                                                 Pv_Mensaje_Error, NVL(SYS_CONTEXT('USERENV','HOST'),'TELCOS+'),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
            ROLLBACK;

    END P_CAMBIAR_CLIENTES_VENDEDOR;
END CMKG_VENDEDOR_MASIVO;
/
