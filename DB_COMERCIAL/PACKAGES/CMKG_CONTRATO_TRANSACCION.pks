CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CONTRATO_TRANSACCION
AS

   /**
    * Documentación para la función P_GUARDAR_CONTRATO
    * Procedimiento que guarda el contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 04-06-2019
    */

    PROCEDURE P_GUARDAR_CONTRATO(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR) ;


   /**
    * Documentación para la función P_VALIDAR_NUMERO_TARJETA
    * Procedimiento validar número de tarjeta
    *
    * @param  Pv_DatosTarjeta   -  Datos de la tarjeta,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Respuesta      -  Data Respuesta
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 02-10-2019
    */

    PROCEDURE P_VALIDAR_NUMERO_TARJETA(
                                  Pv_DatosTarjeta   IN  DB_COMERCIAL.DATOS_TARJETA_TYPE,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2);

    /**
    * Documentación para la función P_RECHAZAR_CONTRATO_ERROR
    * Procedimiento rechazar contrato por error
    *
    * @param  Pcl_Request       -  Datos del contrato,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Respuesta      -  Data Respuesta
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 02-10-2019
    */

    PROCEDURE P_RECHAZAR_CONTRATO_ERROR(
                                  Pcl_Request       IN  CLOB,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR);

   /**
    * Documentación para la función P_GENERAR_SECUENCIA
    * Procedimiento que genera secuencia contrato/adendum
    *
    * @param  Pv_DatosPago      -  Datos de secuencia,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Respuesta      -  Data Respuesta
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 02-10-2019
    *
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.1 22-06-2021 - Se le realiza el update a la secuencia en este proceso
    * @since 1.0
    */

    PROCEDURE P_GENERAR_SECUENCIA(
                                  Pv_DatosSecuencia IN  DB_COMERCIAL.DATOS_SECUENCIA,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_NumeroCA       OUT VARCHAR2,
                                  Pn_Secuencia      OUT INTEGER,
                                  Pn_IdNumeracion   OUT INTEGER) ;

    /**
    * Documentación para la función P_GUARDAR_FORMA_PAGO
    * Procedimiento que guarda la forma de pago
    *
    * @param  Pv_DatosFormaPago -  Datos de forma de pago,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Respuesta      -  Data Respuesta
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 02-10-2019
    *
    * @author Nestor Naula <nnaulal@telconet.ec>
    * @version 1.1 31-08-2021 - Se cambia posicion del COMMIT al hacer update a la info adendum
    * @since 1.0
    */

    PROCEDURE P_GUARDAR_FORMA_PAGO(
                                  Pv_DatosFormaPago IN  DB_COMERCIAL.FORMA_PAGO_TYPE,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR) ;

  /**
    * Documentación para la función P_CREAR_ADENDUM
    * Procedimiento para crear Adendum
    *
    * @param  Pcl_Request       -  Datos del contrato,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_Respuesta      -  Data Respuesta
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 02-10-2019
    */

    PROCEDURE P_CREAR_ADENDUM(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR);


   /**
    * Documentación para la función P_AUTORIZAR_CONTRATO
    * Procedimiento para autorizar un contrato o adendum
    *
    * @param  Pcl_Request       -  Datos para autorizar contrato/adendum,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_SeAutorizo     -  Se autoriza 0/1
    * @author Marlon Pluas <mpluas@telconet.ec>
    * @version 1.0 27-10-2020
    */
    PROCEDURE P_AUTORIZAR_CONTRATO(Pcl_Request     IN  VARCHAR2,
                                   Pv_Mensaje      OUT VARCHAR2,
                                   Pv_Status       OUT VARCHAR2,
                                   Pn_SeAutorizo   OUT NUMBER);

   /**
    * Documentación para la función P_APROBAR_ADENDUM
    * Procedimiento para obtener los datos del cliente
    *
    * @param  Pcl_Request       -  Datos de aprobar adendum,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_SeAutorizo     -  Se autoriza
    * @author Ariel Bailón <abailon@telconet.ec>
    * @version 1.0 27-10-2020
    */

    PROCEDURE P_APROBAR_ADENDUM(
                                  Pcl_Request       IN  DB_COMERCIAL.DATOS_APROBAR_ADENDUM_TYPE,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2);

   /**
    * Documentación para la función P_APROBAR_CONTRATO
    * Procedimiento para obtener los datos del cliente
    *
    * @param  Pcl_Request       -  Datos de aprobar adendum,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_SeAutorizo     -  Se autoriza
    * @author Ariel Bailón <abailon@telconet.ec>
    * @version 1.0 27-10-2020
    *
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.1 25-01-2022 - Se solicita que no se duplique la información 
    *                           de la info_persona_empresa_rol.
    */
    PROCEDURE P_APROBAR_CONTRATO(Pcl_Request       IN  DB_COMERCIAL.DATOS_APROBAR_CONTRATO_TYPE,
                                 Pv_Mensaje        OUT VARCHAR2,
                                 Pv_Status         OUT VARCHAR2);

   /**
    * Documentación para la función P_SETEAR_DATOS_CONTRATO
    * Procedimiento para obtener los datos del cliente
    *
    * @param  Pcl_Request       -  Datos setear datos contrato,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    * @author Ariel Bailón <abailon@telconet.ec>
    * @version 1.0 27-10-2020
    */


    PROCEDURE P_SETEAR_DATOS_CONTRATO(
                                  Pcl_Request       IN  DB_COMERCIAL.DATOS_CONTRATO_TYPE,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2);

     /**
    * Documentación para la función P_GENERAR_OT_SERVADIC
    * Procedimiento para obtener los datos del cliente
    *
    * @param  Pcl_Request       -  Datos setear datos contrato,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    * @author Néstor Naula <nnaulal@telconet.ec>
    * @version 1.0 27-10-2020
    */


    PROCEDURE P_GENERAR_OT_SERVADIC(
                                  Pcl_Request       IN  DB_COMERCIAL.DATOS_GENERAR_OT_TYPE,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2);                             

END CMKG_CONTRATO_TRANSACCION;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_CONTRATO_TRANSACCION
AS


PROCEDURE P_GUARDAR_CONTRATO(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR)
                                  IS

    CURSOR C_GET_DATOS_PER_FORMA_PAGO(Cn_IdPersonaRol    INTEGER,
                                      Cn_IdEmpresa       INTEGER,
                                      Cv_DescripcionRol  VARCHAR2,
                                      Cv_EstadoActivo    VARCHAR2,
                                      Cv_EstadoPendiente VARCHAR2)
    IS
      SELECT
        IPEFP.FORMA_PAGO_ID,IPEFP.TIPO_CUENTA_ID,IPEFP.BANCO_TIPO_CUENTA_ID
        FROM DB_COMERCIAL.INFO_PERSONA IPE
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPE.ID_PERSONA = IPER.PERSONA_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO IPEFP ON IPEFP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
        WHERE IPER.ID_PERSONA_ROL = Cn_IdPersonaRol
          AND AR.DESCRIPCION_ROL  = Cv_DescripcionRol
          AND IER.EMPRESA_COD     = Cn_IdEmpresa
          AND IPEFP.ESTADO        = Cv_EstadoActivo
          AND IPER.ESTADO        IN (Cv_EstadoActivo,Cv_EstadoPendiente) ;

    CURSOR C_GET_CONTRATO_PERSONA(Cn_PersonaEmpresaRol VARCHAR2)
    IS
        SELECT ID_CONTRATO,ESTADO
        FROM DB_COMERCIAL.INFO_CONTRATO
        WHERE
        PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRol
        AND ESTADO IN ('Activo','PorAutorizar');

    CURSOR C_GET_PUNTO(Cn_PersonaEmpresaRol VARCHAR2)
    IS
        SELECT ID_PUNTO
        FROM DB_COMERCIAL.INFO_PUNTO
        WHERE
        PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRol
        AND ESTADO NOT IN ( 'Anulado',
                            'Cancelado',
                            'Eliminado',
                            'Cancel');

    CURSOR C_GET_SERVICIO(Cn_IdServicio INTEGER,Cn_IdPersonaEmpRol INTEGER)
    IS
        SELECT ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO ISE
        INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON IPU.ID_PUNTO = ISE.PUNTO_ID
        WHERE
        ISE.ID_SERVICIO = Cn_IdServicio AND
        IPU.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaEmpRol;
        
    CURSOR C_GET_SERVICIO_ALL(Cn_IdServicio INTEGER)
    IS
        SELECT ISE.*
        FROM DB_COMERCIAL.INFO_SERVICIO ISE
        WHERE ISE.ID_SERVICIO = Cn_IdServicio;
       
    CURSOR C_GET_TIPO_CONTRATO(Cn_IdTipoContrato INTEGER)
    IS
      SELECT ATC.*
      FROM DB_COMERCIAL.ADMI_TIPO_CONTRATO ATC
      WHERE ATC.ID_TIPO_CONTRATO = Cn_IdTipoContrato;

    CURSOR C_GET_SERVICIO_CARACT(Cn_IdServicio INTEGER, Cn_IdCaracteristica INTEGER)
    IS
      SELECT ISC.*
      FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC
      WHERE ISC.SERVICIO_ID = Cn_IdServicio
        AND ISC.CARACTERISTICA_ID = Cn_IdCaracteristica
        AND ISC.ESTADO = 'Activo';

    CURSOR C_GET_CARACTERISTICA(Cv_DescCaract VARCHAR2)
    IS
      SELECT AC.*
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE AC.DESCRIPCION_CARACTERISTICA = Cv_DescCaract
        AND AC.TIPO = 'COMERCIAL'
        AND AC.ESTADO = 'Activo';

    CURSOR C_PER_EMP_ROL_CARACT(  Cn_PersonaEmpresaRolId  INTEGER,
                                  Cn_CaracteristicaId     INTEGER,
                                  Cv_Estado               VARCHAR2)
      IS
      SELECT IPERC.*
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC
      WHERE IPERC.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId
          AND IPERC.CARACTERISTICA_ID = Cn_CaracteristicaId
          AND IPERC.ESTADO = Cv_Estado;
          
    -- Estados
    Lv_EstadoActivo            VARCHAR2(400) := 'Activo';
    Lv_EstadoPendiente         VARCHAR2(400) := 'Pendiente';

    -- Variables globales de empresa - usuario
    Ln_CodEmpresa              INTEGER;
    Lv_PrefijoEmpresa          VARCHAR2(400);
    Ln_IdOficina               INTEGER;
    Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
    Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';

    --Variables de Contrato
    Ln_IdPersonaEmpRol         INTEGER;
    Ln_IdContrato              INTEGER;
    Lv_ValorAnticipo           VARCHAR2(400);
    Lv_NumContratoEmpPub       VARCHAR2(400);
    Lv_codigoNumeracionVe      VARCHAR2(400);
    Lv_FeIncioContrato         DATE := SYSDATE;
    Lv_FeFinContratoPost       DATE;
    Lv_ValorEstado             VARCHAR2(400) := 'Pendiente';
    Lv_ConvenioPago            VARCHAR2(10) := 'N';
    Lv_EsTramiteLegal          VARCHAR2(10) := 'N';
    Lv_EsVip                   VARCHAR2(10) := 'N';
    Lv_PermiteCorteAutom       VARCHAR2(10) := 'N';
    Lv_fideicomiso             VARCHAR2(10) := 'N';
    Lv_TiempoEsperaMesesCorte  VARCHAR2(400);
    Lv_CodigoVerificacion      VARCHAR2(400);
    Lv_AnioVencimiento         VARCHAR2(400);
    Lv_MesVencimiento          VARCHAR2(400);
    Lv_TitularCuenta           VARCHAR2(400);
    Lv_DescripcionRol          VARCHAR2(400):= 'Pre-cliente';
    Ln_PuntoId                 INTEGER;
    Lv_EstadoContrato          VARCHAR2(400);
    Lv_cambioRazonSocial       VARCHAR2(10);
    Ln_TipoContratoId          INTEGER;

    --Forma Pago
    Ln_FormaPagoId             INTEGER;
    Ln_TipoCuentaID            INTEGER;
    Ln_BancoTipoCuentaId       INTEGER;
    Lv_NumeroCtaTarjeta        VARCHAR2(400);
    Lv_DatosFormPago           DB_COMERCIAL.FORMA_PAGO_TYPE;

    --Datos Secuencia
    Lv_DatosSecuencia          DB_COMERCIAL.DATOS_SECUENCIA;
    Lv_NumeroContrato          VARCHAR2(400);
    Ln_Secuencia               INTEGER;
    Ln_SigSecuencia            INTEGER;
    Ln_IdNumeracion            INTEGER;

    --Clausulas
    Lv_IdClausula              INTEGER;
    Lv_DescripClausula         VARCHAR2(400);
    Lv_Origen                  VARCHAR2(400);

    --Tamaño de arreglos
    Ln_CountClausulas          INTEGER :=0;
    Ln_CountServicios          INTEGER :=0;
    Ln_CountAdendumsRS         INTEGER :=0;
    Ln_CountPromoMix           INTEGER :=0;
    Ln_CountPromoMens          INTEGER :=0;
    Ln_CountPromoIns           INTEGER :=0;
    Ln_CountPromoBw            INTEGER :=0;
    Lv_Servicio                VARCHAR2(1000);
    Lv_ServicioId              INTEGER;
    Lv_ServicioValidoId        INTEGER;
    Lv_AdendumId               INTEGER;
    
    Pcl_ArrayAdendumsEncontrado Pcl_AdendumsEncontrado_Type := Pcl_AdendumsEncontrado_Type();

    Lv_RespuestaFormaPago      SYS_REFCURSOR;
    Lc_CaractPromoMix          C_GET_CARACTERISTICA%rowtype;
    Lc_ServicioCaractPromoMix  C_GET_SERVICIO_CARACT%rowtype;
    Lc_ServicioPromoMix        C_GET_SERVICIO_ALL%rowtype;
    Ln_TipoPromocionIdPMix     INTEGER;
    Ln_ServicioIdPMix          INTEGER;
    Lv_CodigoPromoPMix         VARCHAR2(500);
    Lv_TipoPromocionPMix       VARCHAR2(500);
    Lv_ObservacionPMix         VARCHAR2(1000);
    Lc_CaractPromoMens         C_GET_CARACTERISTICA%rowtype;
    Lc_ServicioCaractPromoMens C_GET_SERVICIO_CARACT%rowtype;
    Lc_ServicioPromoMens       C_GET_SERVICIO_ALL%rowtype;
    Ln_TipoPromocionIdPMens    INTEGER;
    Ln_ServicioIdPMens         INTEGER;
    Lv_CodigoPromoPMens        VARCHAR2(500);
    Lv_TipoPromocionPMens      VARCHAR2(500);
    Lv_ObservacionPMens        VARCHAR2(1000);
    Lc_CaractPromoIns          C_GET_CARACTERISTICA%rowtype;
    Lc_ServicioCaractPromoIns  C_GET_SERVICIO_CARACT%rowtype;
    Lc_ServicioPromoIns        C_GET_SERVICIO_ALL%rowtype;
    Ln_TipoPromocionIdPIns     INTEGER;
    Ln_ServicioIdPIns          INTEGER;
    Lv_CodigoPromoPIns         VARCHAR2(500);
    Lv_TipoPromocionPIns       VARCHAR2(500);
    Lv_ObservacionPIns         VARCHAR2(1000);
    Lc_CaractPromoBw           C_GET_CARACTERISTICA%rowtype;
    Lc_ServicioCaractPromoBw   C_GET_SERVICIO_CARACT%rowtype;
    Lc_ServicioPromoBw         C_GET_SERVICIO_ALL%rowtype;
    Ln_TipoPromocionIdPBw      INTEGER;
    Ln_ServicioIdPBw           INTEGER;
    Lv_CodigoPromoPBw          VARCHAR2(500);
    Lv_TipoPromocionPBw        VARCHAR2(500);
    Lv_ObservacionPBw          VARCHAR2(1000);
    Lb_RequiereFormaPago       BOOLEAN := TRUE;
    Lc_TipoContrato            C_GET_TIPO_CONTRATO%rowtype;
    Lc_CaractRecomBw    C_GET_CARACTERISTICA%rowtype;
    Lc_PerEmpRolCarContrRecom C_PER_EMP_ROL_CARACT%rowtype;
    Pcl_InfoContratoCaracteristica DB_COMERCIAL.INFO_CONTRATO_CARACTERISTICA%rowtype;

    BEGIN

        APEX_JSON.PARSE(Pcl_Request);

        Ln_CodEmpresa         := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
        Lv_PrefijoEmpresa     := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
        Ln_IdOficina          := APEX_JSON.get_varchar2(p_path => 'oficinaId');
        Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,14);
        Lv_ClienteIp          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
        Lv_Origen             := APEX_JSON.get_varchar2(p_path => 'origen');

        --Valores de Contrato
        Ln_PuntoId            := APEX_JSON.get_number(p_path => 'contrato.puntoId');
        Lv_ValorAnticipo      := APEX_JSON.get_varchar2(p_path => 'contrato.valorAnticipado');
        Lv_NumContratoEmpPub  := APEX_JSON.get_varchar2(p_path => 'contrato.numContratoEmpPub');
        Lv_codigoNumeracionVe := APEX_JSON.get_varchar2(p_path => 'contrato.codNumeracionVE');
        Lv_FeIncioContrato    := TO_DATE(APEX_JSON.get_varchar2(p_path => 'contrato.feInicioContrato'),'YYYY-MM-DD HH24:MI:SS');
        Lv_FeFinContratoPost  := TO_DATE(APEX_JSON.get_varchar2(p_path => 'contrato.feFinContratoPost'),'YYYY-MM-DD HH24:MI:SS');
        Ln_IdPersonaEmpRol    := APEX_JSON.get_varchar2(p_path => 'contrato.personaEmpresaRolId');
        Lv_ValorEstado        := APEX_JSON.get_varchar2(p_path => 'contrato.estado');
        Ln_TipoContratoId     := APEX_JSON.get_varchar2(p_path => 'contrato.tipoContratoId');

        --Valores de Contrato Adicional
        Lv_ConvenioPago            := APEX_JSON.get_varchar2(p_path => 'contrato.esConvenioPago');
        Lv_EsTramiteLegal          := APEX_JSON.get_varchar2(p_path => 'contrato.esTramiteLegal');
        Lv_EsVip                   := APEX_JSON.get_varchar2(p_path => 'contrato.esVip');
        Lv_PermiteCorteAutom       := APEX_JSON.get_varchar2(p_path => 'contrato.permitirCorteAutomatico');
        Lv_fideicomiso             := APEX_JSON.get_varchar2(p_path => 'contrato.fideicomiso');
        Lv_TiempoEsperaMesesCorte  := APEX_JSON.get_varchar2(p_path => 'contrato.tiempoEsperaMesesCorte');

        --ValoresTarjeta
        Lv_NumeroCtaTarjeta   := APEX_JSON.get_varchar2(p_path => 'contrato.numeroCtaTarjeta');
        Lv_CodigoVerificacion := APEX_JSON.get_varchar2(p_path => 'contrato.codigoVerificacion');
        Lv_AnioVencimiento    := APEX_JSON.get_varchar2(p_path => 'contrato.anioVencimiento');
        Lv_MesVencimiento     := APEX_JSON.get_varchar2(p_path => 'contrato.mesVencimiento');
        Lv_TitularCuenta      := APEX_JSON.get_varchar2(p_path => 'contrato.titularCuenta');

        --Tamaños de arreglo clausula
        Ln_CountClausulas   := APEX_JSON.GET_COUNT(p_path => 'contrato.clausula');
        Ln_CountServicios   := APEX_JSON.GET_COUNT(p_path => 'contrato.servicios');
        Ln_CountAdendumsRS  := APEX_JSON.GET_COUNT(p_path => 'contrato.adendumsRazonSocial');
        Ln_CountPromoMix    := APEX_JSON.GET_COUNT(p_path => 'promoMix');
        Ln_CountPromoMens   := APEX_JSON.GET_COUNT(p_path => 'promoMens');
        Ln_CountPromoIns    := APEX_JSON.GET_COUNT(p_path => 'promoIns');
        Ln_CountPromoBw     := APEX_JSON.GET_COUNT(p_path => 'promoBw');

        --RazonSocial
        Ln_FormaPagoId       := APEX_JSON.get_varchar2(p_path => 'contrato.formaPagoId');
        Ln_TipoCuentaID      := APEX_JSON.get_varchar2(p_path => 'contrato.tipoCuentaId');
        Ln_BancoTipoCuentaId := APEX_JSON.get_varchar2(p_path => 'contrato.bancoTipoCuentaId');
        Lv_cambioRazonSocial := APEX_JSON.get_varchar2(p_path => 'cambioRazonSocial');
        
        IF Ln_PuntoId IS NULL THEN
          OPEN C_GET_PUNTO (Ln_IdPersonaEmpRol);
          FETCH C_GET_PUNTO INTO Ln_PuntoId;
          CLOSE C_GET_PUNTO;
        END IF;
       
        OPEN C_GET_TIPO_CONTRATO(Ln_TipoContratoId);
        FETCH C_GET_TIPO_CONTRATO INTO Lc_TipoContrato;
        CLOSE C_GET_TIPO_CONTRATO;

        OPEN C_GET_CONTRATO_PERSONA(Ln_IdPersonaEmpRol);
        FETCH C_GET_CONTRATO_PERSONA INTO Ln_IdContrato,Lv_EstadoContrato;
        CLOSE C_GET_CONTRATO_PERSONA;

        IF Ln_IdContrato IS NOT NULL
        THEN
            RAISE_APPLICATION_ERROR(-20101, CONCAT('Ya existe un contrato con estado ',Lv_EstadoContrato));
        END IF;

        IF Ln_CountServicios IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountServicios LOOP
                APEX_JSON.PARSE(Pcl_Request);
                Lv_ServicioValidoId:= NULL;
                Lv_ServicioId      := APEX_JSON.get_number(p_path => 'contrato.servicios[%d]',  p0 => i);
                OPEN C_GET_SERVICIO (Lv_ServicioId,Ln_IdPersonaEmpRol);
                FETCH C_GET_SERVICIO INTO Lv_ServicioValidoId;
                CLOSE C_GET_SERVICIO;
                IF Lv_ServicioValidoId IS NOT NULL
                THEN
                  Lv_Servicio        := CONCAT(Lv_Servicio,CONCAT(Lv_ServicioId,','));
                ELSE
                  RAISE_APPLICATION_ERROR(-20101, 'El id servicio '|| Lv_ServicioId || '. No Corresponde al cliente');
                END IF;
            END LOOP;
        END IF;
        
        IF Ln_CountAdendumsRS IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountAdendumsRS LOOP
              Lv_AdendumId      := APEX_JSON.get_number(p_path => 'contrato.adendumsRazonSocial[%d]',  p0 => i);
              Pcl_ArrayAdendumsEncontrado.extend;
              Pcl_ArrayAdendumsEncontrado(i) := Lv_AdendumId;
            END LOOP;
        END IF;

        --Secuencia del contrato
        Lv_DatosSecuencia := DB_COMERCIAL.DATOS_SECUENCIA(Lv_codigoNumeracionVe,Ln_CodEmpresa,Ln_IdOficina,0);
        P_GENERAR_SECUENCIA(Lv_DatosSecuencia,Pv_Mensaje,Pv_Status,Lv_NumeroContrato,Ln_Secuencia,Ln_IdNumeracion);

        IF Lv_FeFinContratoPost IS NULL
        THEN
            Lv_FeFinContratoPost  := ADD_MONTHS(SYSDATE,12);
        END IF;

        --Forma de Pago del cliente
        IF Lv_PrefijoEmpresa = 'MD' AND Lv_cambioRazonSocial = 'N'
        THEN
            OPEN C_GET_DATOS_PER_FORMA_PAGO (Ln_IdPersonaEmpRol,Ln_CodEmpresa,Lv_DescripcionRol,Lv_EstadoActivo,Lv_EstadoPendiente);
            FETCH C_GET_DATOS_PER_FORMA_PAGO INTO Ln_FormaPagoId,Ln_TipoCuentaID,Ln_BancoTipoCuentaId;
            CLOSE C_GET_DATOS_PER_FORMA_PAGO;
        END IF;
        
        INSERT INTO DB_COMERCIAL.INFO_CONTRATO (ID_CONTRATO,
                                               NUMERO_CONTRATO,
                                               NUMERO_CONTRATO_EMP_PUB,
                                               FORMA_PAGO_ID,
                                               ESTADO,
                                               FE_CREACION,
                                               USR_CREACION,
                                               IP_CREACION,
                                               TIPO_CONTRATO_ID,
                                               FE_FIN_CONTRATO,
                                               VALOR_CONTRATO,
                                               VALOR_ANTICIPO,
                                               VALOR_GARANTIA,
                                               PERSONA_EMPRESA_ROL_ID,
                                               FE_APROBACION,
                                               USR_APROBACION,
                                               ARCHIVO_DIGITAL,
                                               NUM_CONTRATO_ANT,
                                               FE_RECHAZO,
                                               USR_RECHAZO,
                                               MOTIVO_RECHAZO_ID,
                                               ORIGEN)
        VALUES (
               DB_COMERCIAL.SEQ_INFO_CONTRATO.NEXTVAL,
               Lv_NumeroContrato,
               Lv_NumContratoEmpPub,
               Ln_FormaPagoId,
               Lv_ValorEstado,
               SYSDATE,
               Lv_UsrCreacion,
               Lv_ClienteIp,
               Ln_TipoContratoId,
               Lv_FeFinContratoPost,
               Lv_ValorAnticipo,
               NULL,
               NULL,
               Ln_IdPersonaEmpRol,
               Lv_FeIncioContrato,
               Lv_UsrCreacion,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               Lv_Origen)
        RETURNING ID_CONTRATO INTO Ln_IdContrato;
        COMMIT;
 
       --MOVER CARACTERISTICA RECOMENDACION DE EQUIFAX
        IF  Lv_PrefijoEmpresa = 'MD'  THEN
          OPEN C_GET_CARACTERISTICA('EQUIFAX_RECOMENDACION');
          FETCH C_GET_CARACTERISTICA INTO  Lc_CaractRecomBw;
          CLOSE C_GET_CARACTERISTICA; 

          IF Lc_CaractRecomBw.Id_Caracteristica IS  NULL THEN
          RAISE_APPLICATION_ERROR(-20101, 'No existe la caracteristica  EQUIFAX_RECOMENDACION .');
          ELSE  

          OPEN C_PER_EMP_ROL_CARACT(Ln_IdPersonaEmpRol, Lc_CaractRecomBw.Id_Caracteristica,  Lv_EstadoActivo );
          FETCH C_PER_EMP_ROL_CARACT INTO Lc_PerEmpRolCarContrRecom;
          CLOSE C_PER_EMP_ROL_CARACT;
          
          IF  Lc_PerEmpRolCarContrRecom.ID_PERSONA_EMPRESA_ROL_CARACT IS NOT NULL THEN

                Pcl_InfoContratoCaracteristica.ID_CONTRATO_CARACTERISTICA:= DB_COMERCIAL.SEQ_INFO_CONTRATO_CARAC.NEXTVAL;
                Pcl_InfoContratoCaracteristica.CONTRATO_ID               := Ln_IdContrato;
                Pcl_InfoContratoCaracteristica.CARACTERISTICA_ID         := Lc_CaractRecomBw.Id_Caracteristica;
                Pcl_InfoContratoCaracteristica.VALOR1                    := Lc_CaractRecomBw.DESCRIPCION_CARACTERISTICA;
                Pcl_InfoContratoCaracteristica.VALOR2                    := Lc_PerEmpRolCarContrRecom.VALOR ; 
                Pcl_InfoContratoCaracteristica.ESTADO                    := Lv_EstadoActivo ; 
                Pcl_InfoContratoCaracteristica.USR_CREACION              := Lv_UsrCreacion;
                Pcl_InfoContratoCaracteristica.FE_CREACION               := SYSDATE; 
                Pcl_InfoContratoCaracteristica.IP_CREACION               := Lv_ClienteIp;

                INSERT  INTO  DB_COMERCIAL.INFO_CONTRATO_CARACTERISTICA VALUES Pcl_InfoContratoCaracteristica; 
                COMMIT;
            END IF;
          END IF;
        END IF;

          
        --Clausulas
        IF Ln_CountClausulas IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountClausulas LOOP

                APEX_JSON.PARSE(Pcl_Request);

                Lv_IdClausula        := APEX_JSON.get_varchar2(p_path => 'contrato.clausula[%d].id',  p0 => i);
                Lv_DescripClausula   := APEX_JSON.get_varchar2(p_path => 'contrato.clausula[%d].descripcion',  p0 => i);

                INSERT INTO DB_COMERCIAL.INFO_CONTRATO_CLAUSULA (ID_CLAUSULA_CONTRATO,
                                                                CONTRATO_ID,
                                                                CLAUSULA_ID,
                                                                DESCRIPCION_CLAUSULA,
                                                                FE_CREACION,
                                                                USR_CREACION,
                                                                ESTADO)
                                                        VALUES (
                                                                DB_COMERCIAL.SEQ_INFO_CONTRATO_CLAUSULA.NEXTVAL,
                                                                Ln_IdContrato,
                                                                Lv_IdClausula,
                                                                Lv_DescripClausula,
                                                                SYSDATE,
                                                                Lv_UsrCreacion,
                                                                Lv_EstadoPendiente);
            END LOOP;
        END IF;
        -- Dato adicional contrato
        IF Lv_ConvenioPago IS NULL
        THEN
            Lv_ConvenioPago  := 'N';
        END IF;

        IF Lv_EsTramiteLegal IS NULL
        THEN
            Lv_EsTramiteLegal  := 'N';
        END IF;

        IF Lv_EsVip IS NULL
        THEN
            Lv_EsVip  := 'N';
        END IF;

        IF Lv_PermiteCorteAutom IS NULL
        THEN
            Lv_PermiteCorteAutom  := 'N';
        END IF;

        IF Lv_fideicomiso IS NULL
        THEN
            Lv_fideicomiso  := 'N';
        END IF;

        IF Lv_TiempoEsperaMesesCorte IS NULL
        THEN
            Lv_TiempoEsperaMesesCorte  := '1';
        END IF;

        INSERT INTO DB_COMERCIAL.INFO_CONTRATO_DATO_ADICIONAL(
                                                                CONTRATO_ID,
                                                                ES_VIP,
                                                                ES_TRAMITE_LEGAL,
                                                                PERMITE_CORTE_AUTOMATICO,
                                                                FIDEICOMISO,
                                                                CONVENIO_PAGO,
                                                                TIEMPO_ESPERA_MESES_CORTE,
                                                                FE_CREACION,
                                                                USR_CREACION,
                                                                IP_CREACION,
                                                                ID_DATO_ADICIONAL)
                                                        VALUES(
                                                                Ln_IdContrato,
                                                                Lv_EsVip,
                                                                Lv_EsTramiteLegal,
                                                                Lv_PermiteCorteAutom,
                                                                Lv_fideicomiso,
                                                                Lv_ConvenioPago,
                                                                Lv_TiempoEsperaMesesCorte,
                                                                SYSDATE,
                                                                Lv_UsrCreacion,
                                                                Lv_ClienteIp,
                                                                DB_COMERCIAL.SEQ_INFO_CONTRA_DATO_ADI.NEXTVAL
                                                        );
        
        IF Lc_TipoContrato.Id_Tipo_Contrato IS NOT NULL AND Lc_TipoContrato.Descripcion_Tipo_Contrato = 'VEHICULO' THEN
          Lb_RequiereFormaPago := FALSE;
        END IF;
       
        IF Lb_RequiereFormaPago THEN
          --Forma de Pago
          Lv_DatosFormPago := DB_COMERCIAL.FORMA_PAGO_TYPE(Ln_FormaPagoId,Ln_TipoCuentaID,
                                                           Ln_BancoTipoCuentaId,Lv_NumeroCtaTarjeta,
                                                           Lv_CodigoVerificacion,Ln_CodEmpresa,
                                                           Lv_AnioVencimiento,Lv_TitularCuenta,
                                                           Ln_IdContrato,Lv_MesVencimiento,
                                                           Lv_UsrCreacion,Lv_ClienteIp,
                                                           Ln_PuntoId,Lv_Servicio,'N',0,'C',Lv_ValorEstado,NULL,
                                                           Lv_cambioRazonSocial, Pcl_ArrayAdendumsEncontrado);

          P_GUARDAR_FORMA_PAGO(Lv_DatosFormPago,Pv_Mensaje,Pv_Status,Lv_RespuestaFormaPago);
        
          IF Pv_Status IS NULL OR Pv_Status = 'ERROR'
          THEN
            RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
          END IF;
          COMMIT;
        END IF;
        COMMIT;

        -- Agregar promociones
        -- PROMO MIX
        IF Ln_CountPromoMix IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountPromoMix LOOP
              Ln_TipoPromocionIdPMix      := APEX_JSON.get_number(p_path => 'promoMix[%d].tipoPromocionId',  p0 => i);
              Ln_ServicioIdPMix           := APEX_JSON.get_number(p_path => 'promoMix[%d].servicioId',  p0 => i);
              Lv_CodigoPromoPMix          := APEX_JSON.get_varchar2(p_path => 'promoMix[%d].codigoPromo',  p0 => i);
              Lv_TipoPromocionPMix        := APEX_JSON.get_varchar2(p_path => 'promoMix[%d].tipoPromocion',  p0 => i);
              Lv_ObservacionPMix          := APEX_JSON.get_varchar2(p_path => 'promoMix[%d].observacion',  p0 => i);

              OPEN C_GET_CARACTERISTICA(Lv_TipoPromocionPMix);
              FETCH C_GET_CARACTERISTICA INTO Lc_CaractPromoMix;
              CLOSE C_GET_CARACTERISTICA;

              IF Lc_CaractPromoMix.Id_Caracteristica IS NOT NULL THEN
                OPEN C_GET_SERVICIO_CARACT(Ln_ServicioIdPMix, Lc_CaractPromoMix.Id_Caracteristica);
                FETCH C_GET_SERVICIO_CARACT INTO Lc_ServicioCaractPromoMix;
                CLOSE C_GET_SERVICIO_CARACT;

                OPEN C_GET_SERVICIO_ALL(Ln_ServicioIdPMix);
                FETCH C_GET_SERVICIO_ALL INTO Lc_ServicioPromoMix;
                CLOSE C_GET_SERVICIO_ALL;

                IF Lc_ServicioCaractPromoMix.Id_Servicio_Caracteristica IS NOT NULL THEN
                  UPDATE DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA EE 
                  SET ESTADO = 'Inactivo',
                      USR_ULT_MOD = Lv_UsrCreacion,
                      FE_ULT_MOD = SYSDATE,
                      IP_ULT_MOD = Lv_ClienteIp
                  WHERE ID_SERVICIO_CARACTERISTICA = Lc_ServicioCaractPromoMix.Id_Servicio_Caracteristica;

                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL, 
                    SERVICIO_ID, 
                    USR_CREACION, 
                    FE_CREACION, 
                    IP_CREACION, 
                    ESTADO, 
                    OBSERVACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_ServicioIdPMix,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_ClienteIp,
                    Lc_ServicioPromoMix.Estado,
                    'Se eliminan los códigos promocionales en estado activo, para priorizar códigos promociones de tipo mix.'
                  );
                END IF;
                INSERT INTO DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
                  (
                    ID_SERVICIO_CARACTERISTICA,
                    SERVICIO_ID              ,
                    CARACTERISTICA_ID        ,
                    VALOR                    ,
                    ESTADO                   ,
                    OBSERVACION              ,
                    USR_CREACION             ,
                    IP_CREACION              ,
                    FE_CREACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_CARAC.NEXTVAL,
                    Ln_ServicioIdPMix,
                    Lc_CaractPromoMix.Id_Caracteristica,
                    Ln_TipoPromocionIdPMix,
                    'Activo',
                    Lv_ObservacionPMix,
                    Lv_UsrCreacion,
                    Lv_ClienteIp,
                    SYSDATE
                  );

                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL, 
                    SERVICIO_ID, 
                    USR_CREACION, 
                    FE_CREACION, 
                    IP_CREACION, 
                    ESTADO, 
                    OBSERVACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_ServicioIdPMix,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_ClienteIp,
                    Lc_ServicioPromoMix.Estado,
                    Lv_ObservacionPMix
                  );
              END IF;
            END LOOP;
        END IF;
        COMMIT;

        -- PROMO MENS
        IF Ln_CountPromoMens IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountPromoMens LOOP
              Ln_TipoPromocionIdPMens      := APEX_JSON.get_number(p_path => 'promoMens[%d].tipoPromocionId',  p0 => i);
              Ln_ServicioIdPMens           := APEX_JSON.get_number(p_path => 'promoMens[%d].servicioId',  p0 => i);
              Lv_CodigoPromoPMens          := APEX_JSON.get_varchar2(p_path => 'promoMens[%d].codigoPromo',  p0 => i);
              Lv_TipoPromocionPMens        := APEX_JSON.get_varchar2(p_path => 'promoMens[%d].tipoPromocion',  p0 => i);
              Lv_ObservacionPMens          := APEX_JSON.get_varchar2(p_path => 'promoMens[%d].observacion',  p0 => i);

              OPEN C_GET_CARACTERISTICA(Lv_TipoPromocionPMens);
              FETCH C_GET_CARACTERISTICA INTO Lc_CaractPromoMens;
              CLOSE C_GET_CARACTERISTICA;

              IF Lc_CaractPromoMens.Id_Caracteristica IS NOT NULL THEN
                OPEN C_GET_SERVICIO_CARACT(Ln_ServicioIdPMens, Lc_CaractPromoMens.Id_Caracteristica);
                FETCH C_GET_SERVICIO_CARACT INTO Lc_ServicioCaractPromoMens;
                CLOSE C_GET_SERVICIO_CARACT;
                
                OPEN C_GET_SERVICIO_ALL(Ln_ServicioIdPMens);
                FETCH C_GET_SERVICIO_ALL INTO Lc_ServicioPromoMens;
                CLOSE C_GET_SERVICIO_ALL;

                IF Lc_ServicioCaractPromoMens.Id_Servicio_Caracteristica IS NOT NULL THEN
                  UPDATE DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA EE 
                  SET ESTADO = 'Inactivo',
                      USR_ULT_MOD = Lv_UsrCreacion,
                      FE_ULT_MOD = SYSDATE,
                      IP_ULT_MOD = Lv_ClienteIp
                  WHERE ID_SERVICIO_CARACTERISTICA = Lc_ServicioCaractPromoMens.Id_Servicio_Caracteristica;

                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL, 
                    SERVICIO_ID, 
                    USR_CREACION, 
                    FE_CREACION, 
                    IP_CREACION, 
                    ESTADO, 
                    OBSERVACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_ServicioIdPMens,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_ClienteIp,
                    Lc_ServicioPromoMens.Estado,
                    'Se eliminan los códigos promocionales en estado activo, para priorizar códigos promociones de tipo mens.'
                  );
                END IF;
                INSERT INTO DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
                  (
                    ID_SERVICIO_CARACTERISTICA,
                    SERVICIO_ID              ,
                    CARACTERISTICA_ID        ,
                    VALOR                    ,
                    ESTADO                   ,
                    OBSERVACION              ,
                    USR_CREACION             ,
                    IP_CREACION              ,
                    FE_CREACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_CARAC.NEXTVAL,
                    Ln_ServicioIdPMens,
                    Lc_CaractPromoMens.Id_Caracteristica,
                    Ln_TipoPromocionIdPMens,
                    'Activo',
                    Lv_ObservacionPMens,
                    Lv_UsrCreacion,
                    Lv_ClienteIp,
                    SYSDATE
                  );

                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL, 
                    SERVICIO_ID, 
                    USR_CREACION, 
                    FE_CREACION, 
                    IP_CREACION, 
                    ESTADO, 
                    OBSERVACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_ServicioIdPMens,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_ClienteIp,
                    Lc_ServicioPromoMens.Estado,
                    Lv_ObservacionPMens
                  );
              END IF;
            END LOOP;
        END IF;
        COMMIT;

        -- PROMO INS
        IF Ln_CountPromoIns IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountPromoIns LOOP
              Ln_TipoPromocionIdPIns      := APEX_JSON.get_number(p_path => 'promoIns[%d].tipoPromocionId',  p0 => i);
              Ln_ServicioIdPIns           := APEX_JSON.get_number(p_path => 'promoIns[%d].servicioId',  p0 => i);
              Lv_CodigoPromoPIns          := APEX_JSON.get_varchar2(p_path => 'promoIns[%d].codigoPromo',  p0 => i);
              Lv_TipoPromocionPIns        := APEX_JSON.get_varchar2(p_path => 'promoIns[%d].tipoPromocion',  p0 => i);
              Lv_ObservacionPIns          := APEX_JSON.get_varchar2(p_path => 'promoIns[%d].observacion',  p0 => i);

              OPEN C_GET_CARACTERISTICA(Lv_TipoPromocionPIns);
              FETCH C_GET_CARACTERISTICA INTO Lc_CaractPromoIns;
              CLOSE C_GET_CARACTERISTICA;

              IF Lc_CaractPromoIns.Id_Caracteristica IS NOT NULL THEN
                OPEN C_GET_SERVICIO_CARACT(Ln_ServicioIdPIns, Lc_CaractPromoIns.Id_Caracteristica);
                FETCH C_GET_SERVICIO_CARACT INTO Lc_ServicioCaractPromoIns;
                CLOSE C_GET_SERVICIO_CARACT;
                
                OPEN C_GET_SERVICIO_ALL(Ln_ServicioIdPIns);
                FETCH C_GET_SERVICIO_ALL INTO Lc_ServicioPromoIns;
                CLOSE C_GET_SERVICIO_ALL;

                IF Lc_ServicioCaractPromoIns.Id_Servicio_Caracteristica IS NOT NULL THEN
                  UPDATE DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA EE 
                  SET ESTADO = 'Inactivo',
                      USR_ULT_MOD = Lv_UsrCreacion,
                      FE_ULT_MOD = SYSDATE,
                      IP_ULT_MOD = Lv_ClienteIp
                  WHERE ID_SERVICIO_CARACTERISTICA = Lc_ServicioCaractPromoIns.Id_Servicio_Caracteristica;

                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL, 
                    SERVICIO_ID, 
                    USR_CREACION, 
                    FE_CREACION, 
                    IP_CREACION, 
                    ESTADO, 
                    OBSERVACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_ServicioIdPIns,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_ClienteIp,
                    Lc_ServicioPromoIns.Estado,
                    'Se eliminan los códigos promocionales en estado activo, para priorizar códigos promociones de tipo ins.'
                  );
                END IF;
                INSERT INTO DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
                  (
                    ID_SERVICIO_CARACTERISTICA,
                    SERVICIO_ID              ,
                    CARACTERISTICA_ID        ,
                    VALOR                    ,
                    ESTADO                   ,
                    OBSERVACION              ,
                    USR_CREACION             ,
                    IP_CREACION              ,
                    FE_CREACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_CARAC.NEXTVAL,
                    Ln_ServicioIdPIns,
                    Lc_CaractPromoIns.Id_Caracteristica,
                    Ln_TipoPromocionIdPIns,
                    'Activo',
                    Lv_ObservacionPIns,
                    Lv_UsrCreacion,
                    Lv_ClienteIp,
                    SYSDATE
                  );

                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL, 
                    SERVICIO_ID, 
                    USR_CREACION, 
                    FE_CREACION, 
                    IP_CREACION, 
                    ESTADO, 
                    OBSERVACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_ServicioIdPIns,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_ClienteIp,
                    Lc_ServicioPromoIns.Estado,
                    Lv_ObservacionPIns
                  );
              END IF;
            END LOOP;
        END IF;
        COMMIT;

        -- PROMO BW
        IF Ln_CountPromoBw IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountPromoBw LOOP
              Ln_TipoPromocionIdPBw      := APEX_JSON.get_number(p_path => 'promoBw[%d].tipoPromocionId',  p0 => i);
              Ln_ServicioIdPBw           := APEX_JSON.get_number(p_path => 'promoBw[%d].servicioId',  p0 => i);
              Lv_CodigoPromoPBw          := APEX_JSON.get_varchar2(p_path => 'promoBw[%d].codigoPromo',  p0 => i);
              Lv_TipoPromocionPBw        := APEX_JSON.get_varchar2(p_path => 'promoBw[%d].tipoPromocion',  p0 => i);
              Lv_ObservacionPBw          := APEX_JSON.get_varchar2(p_path => 'promoBw[%d].observacion',  p0 => i);

              OPEN C_GET_CARACTERISTICA(Lv_TipoPromocionPBw);
              FETCH C_GET_CARACTERISTICA INTO Lc_CaractPromoBw;
              CLOSE C_GET_CARACTERISTICA;

              IF Lc_CaractPromoBw.Id_Caracteristica IS NOT NULL THEN
                OPEN C_GET_SERVICIO_CARACT(Ln_ServicioIdPBw, Lc_CaractPromoBw.Id_Caracteristica);
                FETCH C_GET_SERVICIO_CARACT INTO Lc_ServicioCaractPromoBw;
                CLOSE C_GET_SERVICIO_CARACT;
                
                OPEN C_GET_SERVICIO_ALL(Ln_ServicioIdPBw);
                FETCH C_GET_SERVICIO_ALL INTO Lc_ServicioPromoBw;
                CLOSE C_GET_SERVICIO_ALL;

                IF Lc_ServicioCaractPromoBw.Id_Servicio_Caracteristica IS NOT NULL THEN
                  UPDATE DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA EE 
                  SET ESTADO = 'Inactivo',
                      USR_ULT_MOD = Lv_UsrCreacion,
                      FE_ULT_MOD = SYSDATE,
                      IP_ULT_MOD = Lv_ClienteIp
                  WHERE ID_SERVICIO_CARACTERISTICA = Lc_ServicioCaractPromoBw.Id_Servicio_Caracteristica;

                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL, 
                    SERVICIO_ID, 
                    USR_CREACION, 
                    FE_CREACION, 
                    IP_CREACION, 
                    ESTADO, 
                    OBSERVACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_ServicioIdPBw,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_ClienteIp,
                    Lc_ServicioPromoBw.Estado,
                    'Se eliminan los códigos promocionales en estado activo, para priorizar códigos promociones de tipo bw.'
                  );
                END IF;
                INSERT INTO DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
                  (
                    ID_SERVICIO_CARACTERISTICA,
                    SERVICIO_ID              ,
                    CARACTERISTICA_ID        ,
                    VALOR                    ,
                    ESTADO                   ,
                    OBSERVACION              ,
                    USR_CREACION             ,
                    IP_CREACION              ,
                    FE_CREACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_CARAC.NEXTVAL,
                    Ln_ServicioIdPBw,
                    Lc_CaractPromoBw.Id_Caracteristica,
                    Ln_TipoPromocionIdPBw,
                    'Activo',
                    Lv_ObservacionPBw,
                    Lv_UsrCreacion,
                    Lv_ClienteIp,
                    SYSDATE
                  );

                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL, 
                    SERVICIO_ID, 
                    USR_CREACION, 
                    FE_CREACION, 
                    IP_CREACION, 
                    ESTADO, 
                    OBSERVACION
                  )
                  VALUES
                  (
                    SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_ServicioIdPBw,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_ClienteIp,
                    Lc_ServicioPromoBw.Estado,
                    Lv_ObservacionPBw
                  );
              END IF;
            END LOOP;
        END IF;

        COMMIT;

        OPEN Pcl_Response FOR
        SELECT ID_CONTRATO
        FROM   DB_COMERCIAL.INFO_CONTRATO
        WHERE  ID_CONTRATO = Ln_IdContrato;

        Pv_Mensaje   := 'Proceso realizado con exito';
        Pv_Status    := 'OK';
        EXCEPTION
            WHEN OTHERS THEN
            ROLLBACK;
            IF Ln_IdContrato IS NOT NULL
            THEN
                UPDATE DB_COMERCIAL.INFO_CONTRATO 
                SET ESTADO = 'Rechazado',
                    MOTIVO_RECHAZO_ID = 1414,
                    FE_RECHAZO = SYSDATE,
                    USR_RECHAZO = USR_CREACION
                WHERE ID_CONTRATO = Ln_IdContrato;
                COMMIT;
            END IF;
            Pv_Status     := 'ERROR';
            Pcl_Response  :=  NULL;
            Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                                 'DB_COMERCIAL.P_GUARDAR_CONTRATO',
                                                 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                                 'telcos',
                                                  SYSDATE,
                                                 '127.0.0.1');

    END P_GUARDAR_CONTRATO;


    PROCEDURE P_VALIDAR_NUMERO_TARJETA(
                                  Pv_DatosTarjeta   IN  DB_COMERCIAL.DATOS_TARJETA_TYPE,
                                  Pv_Mensaje        OUT  VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_Respuesta      OUT VARCHAR2)
    IS

    CURSOR C_GET_TIPO_CUENTA_BANCO (Cv_BancoTipoCuentaID INTEGER)
    IS
        SELECT ABTC.TOTAL_CARACTERES,ABTC.TOTAL_CARACTERES_MINIMO,ABTC.CARACTER_EMPIEZA,ABTC.CARACTER_NO_EMPIEZA
        FROM DB_COMERCIAL.ADMI_BANCO_TIPO_CUENTA ABTC
        WHERE ID_BANCO_TIPO_CUENTA = Cv_BancoTipoCuentaID;

    CURSOR C_GET_TIPO_CUENTA (Cv_TipoCuentaID INTEGER)
    IS
        SELECT ATC.DESCRIPCION_CUENTA
        FROM DB_COMERCIAL.ADMI_TIPO_CUENTA ATC
        WHERE ID_TIPO_CUENTA = Cv_TipoCuentaID;

    CURSOR C_GET_PARAMETRO(Cv_DescripcionParametro VARCHAR2,Cv_EmpresaCod INTEGER)
    IS
        SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO = APD.PARAMETRO_ID
        WHERE APC.NOMBRE_PARAMETRO = Cv_DescripcionParametro AND APD.EMPRESA_COD = Cv_EmpresaCod;

    CURSOR C_GET_BIN_VALIDO(Cv_Estado VARCHAR2, Cn_TipoBancoCuentaId INTEGER, Cn_BinTarjeta INTEGER)
    IS
        SELECT COUNT(AB.ID_BIN)
        FROM DB_GENERAL.ADMI_BINES AB
        WHERE AB.ESTADO = Cv_Estado AND AB.BANCO_TIPO_CUENTA_ID = Cn_TipoBancoCuentaId
              AND (AB.BIN_ANTIGUO = Cn_BinTarjeta OR AB.BIN_NUEVO = Cn_BinTarjeta);

    Lv_Valido       INTEGER := 0;
    Lv_NoValido     INTEGER := 0;
    Ln_idCountBin   INTEGER;

    --Parámetros de validación de cuenta
    Ln_TotalCaracteres             INTEGER;
    Ln_TotalCaracteresMinimo       INTEGER;
    Ln_Valor1Parametro             VARCHAR2(400);
    Lv_CaracterEmpieza             VARCHAR2(400);
    Lv_CaracterNoEmpieza           VARCHAR2(400);
    Lv_DescripcionCuenta           VARCHAR2(400);
    Lv_NombreParametro             VARCHAR2(400) := 'PERMITE_VALIDAR_BIN_POR_EMPRESA';
    Lv_EstadoActivo                VARCHAR2(400) := 'Activo';

    BEGIN

        OPEN C_GET_TIPO_CUENTA_BANCO(Pv_DatosTarjeta.Pn_BancoTipoCuentaId);
        FETCH C_GET_TIPO_CUENTA_BANCO INTO Ln_TotalCaracteres,Ln_TotalCaracteresMinimo,Lv_CaracterEmpieza,Lv_CaracterNoEmpieza;
        CLOSE C_GET_TIPO_CUENTA_BANCO;
        IF Ln_TotalCaracteres IS NOT NULL AND Ln_TotalCaracteresMinimo IS NOT NULL
        THEN
            IF LENGTH(Pv_DatosTarjeta.Pv_NumeroCuentaTarj) < Ln_TotalCaracteresMinimo OR
               LENGTH(Pv_DatosTarjeta.Pv_NumeroCuentaTarj) > Ln_TotalCaracteres
            THEN
                Pv_Respuesta := CONCAT('Numero de cuenta invalido. Minimo de digitos a ingresar ',
                                       CONCAT(Ln_TotalCaracteresMinimo,CONCAT('. Maximo de digitos a ingresar ',Ln_TotalCaracteres)));
            END IF;
        ELSE
            IF Ln_TotalCaracteres IS NOT NULL
            THEN
                IF LENGTH(Pv_DatosTarjeta.Pv_NumeroCuentaTarj) != Ln_TotalCaracteres
                THEN
                     Pv_Respuesta := CONCAT('Numero de cuenta invalido. Digitos que debe ingresar ',Ln_TotalCaracteres);
                END IF;
            ELSE
                IF Ln_TotalCaracteresMinimo IS NOT NULL AND LENGTH(Pv_DatosTarjeta.Pv_NumeroCuentaTarj) < Ln_TotalCaracteresMinimo
                THEN
                     Pv_Respuesta := CONCAT('Numero de cuenta invalido. Digitos minimos que debe ingresar ',Ln_TotalCaracteres);
                END IF;
            END IF;
        END IF;

        IF Lv_CaracterEmpieza IS NOT NULL
        THEN

            FOR i IN
              (SELECT TRIM(REGEXP_SUBSTR(Lv_CaracterEmpieza, '[^,]+', 1, LEVEL)) Lv_CaractEmpieza
               FROM DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(Lv_CaracterEmpieza, ',')+1
              )
            LOOP
               IF SUBSTR(Pv_DatosTarjeta.Pv_NumeroCuentaTarj,0,LENGTH(TRIM(i.Lv_CaractEmpieza))) = TRIM(i.Lv_CaractEmpieza)
                THEN
                     Lv_Valido    := 1;
                END IF;
            END LOOP;

            IF Lv_Valido = 0
            THEN
                 Pv_Respuesta := CONCAT('Numero de cuenta invalido. Debe empezar con los digitos ',Lv_CaracterEmpieza);
            END IF;

        END IF;

        IF Lv_CaracterNoEmpieza IS NOT NULL
        THEN

            FOR i IN
              (SELECT TRIM(REGEXP_SUBSTR(Lv_CaracterNoEmpieza, '[^,]+', 1, LEVEL)) Lv_CaractNoEmpieza
               FROM DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(Lv_CaracterNoEmpieza, ',')+1
              )
            LOOP
               IF SUBSTR(Pv_DatosTarjeta.Pv_NumeroCuentaTarj,0,LENGTH(TRIM(i.Lv_CaractNoEmpieza))) = TRIM(i.Lv_CaractNoEmpieza)
                THEN
                     Lv_NoValido    := 1;
                END IF;
            END LOOP;

            IF Lv_NoValido = 1
            THEN
                 Pv_Respuesta := CONCAT('Numero de cuenta invalido. No debe empezar con los digitos ',Lv_CaracterNoEmpieza);
            END IF;
        END IF;

        IF Pv_DatosTarjeta.Pv_NumeroCuentaTarj IS NOT NULL AND NOT REGEXP_LIKE(Pv_DatosTarjeta.Pv_NumeroCuentaTarj, '^[[:digit:]]+$')
        THEN
             Pv_Respuesta := 'Numero de cuenta invalido. Solo debe ingresar numeros';
        END IF;

        OPEN C_GET_TIPO_CUENTA(Pv_DatosTarjeta.Pn_TipoCuentaId);
        FETCH C_GET_TIPO_CUENTA INTO Lv_DescripcionCuenta;
        CLOSE C_GET_TIPO_CUENTA;

        IF Lv_DescripcionCuenta IS NOT NULL AND Lv_DescripcionCuenta != 'AHORRO' AND Lv_DescripcionCuenta != 'CORRIENTE'
           AND Pv_DatosTarjeta.Pv_NumeroCuentaTarj IS NOT NULL
        THEN
            --Validación del BIN
            OPEN C_GET_PARAMETRO(Lv_NombreParametro,Pv_DatosTarjeta.Pn_CodigoEmpresa);
            FETCH C_GET_PARAMETRO INTO Ln_Valor1Parametro;
            CLOSE C_GET_PARAMETRO;

            --Si la empresa permite Bines
            IF Ln_Valor1Parametro IS NOT NULL AND Ln_Valor1Parametro = 'SI'
            THEN
                OPEN C_GET_BIN_VALIDO(Lv_EstadoActivo,Pv_DatosTarjeta.Pn_BancoTipoCuentaId,
                                      SUBSTR(Pv_DatosTarjeta.Pv_NumeroCuentaTarj,0,6));
                FETCH C_GET_BIN_VALIDO INTO Ln_idCountBin;
                CLOSE C_GET_BIN_VALIDO;

                IF Ln_idCountBin IS NULL OR Ln_idCountBin = 0
                THEN
                    Pv_Respuesta := 'Bin no valido [6 primeros digitos de N° Tarjeta]. Favor comunicarse con departamento de Cobranzas';
                END IF;
            END IF;
        END IF;

        Pv_Mensaje   := 'Proceso realizado con exito';
        Pv_Status    := 'OK';
        EXCEPTION
            WHEN OTHERS THEN
            ROLLBACK;
            Pv_Mensaje   := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
            Pv_Respuesta := Pv_Mensaje;
            Pv_Status    := 'ERROR';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                                 'DB_COMERCIAL.P_VALIDAR_NUMERO_TARJETA',
                                                  'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                                 'telcos',
                                                 SYSDATE,
                                                 '127.0.0.1');


    END P_VALIDAR_NUMERO_TARJETA;

    PROCEDURE P_RECHAZAR_CONTRATO_ERROR(
                                  Pcl_Request       IN  CLOB,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR)
    IS

        CURSOR C_GET_MOTIVO(Cv_Motivo VARCHAR2)
        IS
            SELECT AM.ID_MOTIVO
            FROM DB_GENERAL.ADMI_MOTIVO AM
            WHERE AM.NOMBRE_MOTIVO = Cv_Motivo;

        CURSOR C_GET_CONTRATO(Cn_IdContrato INTEGER)
        IS
            SELECT IC.ID_CONTRATO,IC.FORMA_PAGO_ID
            FROM DB_COMERCIAL.INFO_CONTRATO IC
            WHERE IC.ID_CONTRATO = Cn_IdContrato;

        CURSOR C_GET_CONTRATO_FORMA_PAGO(Cn_IdContrato INTEGER)
        IS
            SELECT ICFP.ID_DATOS_PAGO,
                   ICFP.MES_VENCIMIENTO,
                   ICFP.ANIO_VENCIMIENTO,
                   ICFP.BANCO_TIPO_CUENTA_ID,
                   ICFP.CEDULA_TITULAR,
                   ICFP.CODIGO_VERIFICACION,
                   ICFP.NUMERO_CTA_TARJETA,
                   ICFP.NUMERO_DEBITO_BANCO,
                   ICFP.TIPO_CUENTA_ID,
                   ICFP.TITULAR_CUENTA
            FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP
            WHERE ICFP.ESTADO IN ('Pendiente', 'Activo') AND
                  ICFP.CONTRATO_ID = Cn_IdContrato;

        Ln_IdContrato         INTEGER;
        Ln_IdContratoTemp     INTEGER;
        Lv_UsrCreacion        VARCHAR2(15);
        Lv_IpCliente          VARCHAR2(400);
        Lv_Motivo             VARCHAR2(400);

        Ln_IdMotivo           INTEGER;

        --Variable forma de pago
        Ln_FormaPagoId         INTEGER;

    BEGIN

        APEX_JSON.PARSE(Pcl_Request);
        Ln_IdContrato         := APEX_JSON.get_varchar2(p_path => 'contrato.idContrato');
        Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,14);
        Lv_IpCliente          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
        Lv_Motivo             := APEX_JSON.get_varchar2(p_path => 'contrato.motivo');

        OPEN C_GET_CONTRATO(Ln_IdContrato);
        FETCH C_GET_CONTRATO INTO Ln_IdContratoTemp,Ln_FormaPagoId;
        CLOSE C_GET_CONTRATO;

        IF Ln_IdContratoTemp IS NULL
        THEN
            RAISE_APPLICATION_ERROR(-20101, 'El idContrato no existe');
        END IF;

        OPEN C_GET_MOTIVO(Lv_Motivo);
        FETCH C_GET_MOTIVO INTO Ln_IdMotivo;
        CLOSE C_GET_MOTIVO;

        IF Ln_IdMotivo IS NULL
        THEN
            RAISE_APPLICATION_ERROR(-20101, 'El motivo ingresado no existe');
        END IF;

        UPDATE DB_COMERCIAL.INFO_CONTRATO ICO
        SET ICO.ESTADO = 'Rechazado',
            ICO.MOTIVO_RECHAZO_ID = Ln_IdMotivo,
            ICO.USR_RECHAZO       = Lv_UsrCreacion,
            ICO.FE_RECHAZO        = SYSDATE
        WHERE ICO.ID_CONTRATO     = Ln_IdContrato;

        --INACTIVAR FORMA DE CONTRATO
        FOR i IN C_GET_CONTRATO_FORMA_PAGO(Ln_IdContrato)
        LOOP
            UPDATE DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP
            SET ICFP.ESTADO      = 'Inactivo',
                ICFP.FE_ULT_MOD  = SYSDATE,
                ICFP.USR_ULT_MOD = Lv_UsrCreacion
            WHERE ICFP.ID_DATOS_PAGO = i.ID_DATOS_PAGO;
            --Crear Historial
            INSERT INTO DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST ICFPH (
                                                ID_DATOS_PAGO,
                                                MES_VENCIMIENTO,
                                                ANIO_VENCIMIENTO,
                                                BANCO_TIPO_CUENTA_ID,
                                                CEDULA_TITULAR,
                                                CODIGO_VERIFICACION,
                                                CONTRATO_ID,
                                                FORMA_PAGO,
                                                NUMERO_CTA_TARJETA,
                                                NUMERO_DEBITO_BANCO,
                                                TIPO_CUENTA_ID,
                                                TITULAR_CUENTA,
                                                ESTADO,
                                                FE_CREACION,
                                                FE_ULT_MOD,
                                                USR_ULT_MOD,
                                                USR_CREACION,
                                                IP_CREACION)
                                        VALUES(
                                            DB_COMERCIAL.SEQ_INFO_CONTRATO_FORMA_PAGO_H.NEXTVAL,
                                            i.MES_VENCIMIENTO,
                                            i.ANIO_VENCIMIENTO,
                                            i.BANCO_TIPO_CUENTA_ID,
                                            i.CEDULA_TITULAR,
                                            i.CODIGO_VERIFICACION,
                                            Ln_IdContrato,
                                            Ln_FormaPagoId,
                                            i.NUMERO_CTA_TARJETA,
                                            i.NUMERO_DEBITO_BANCO,
                                            i.TIPO_CUENTA_ID,
                                            i.TITULAR_CUENTA,
                                            'Inactivo',
                                            SYSDATE,
                                            SYSDATE,
                                            Lv_UsrCreacion,
                                            Lv_UsrCreacion,
                                            Lv_IpCliente
                                        );

        END LOOP;
        COMMIT;
        Pv_Status    := 'OK';
        Pv_Mensaje   := 'Proceso realizado con exito';
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status    := 'ERROR';
        Pv_Mensaje   := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        Pcl_Response := NULL;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                             'DB_COMERCIAL.P_RECHAZAR_CONTRATO_ERROR',
                                              'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                             'telcos',
                                             SYSDATE,
                                             '127.0.0.1');


    END P_RECHAZAR_CONTRATO_ERROR;

    PROCEDURE P_GENERAR_SECUENCIA(
                                  Pv_DatosSecuencia IN  DB_COMERCIAL.DATOS_SECUENCIA,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pv_NumeroCA       OUT VARCHAR2,
                                  Pn_Secuencia      OUT INTEGER,
                                  Pn_IdNumeracion   OUT INTEGER)
    IS
    CURSOR C_GET_NUM_CONTRATO_VEHI(Cv_CodigoNumeraVeh   VARCHAR2,
                                   Cn_CodEmpresa        INTEGER,
                                   Cn_IdOficina         INTEGER,
                                   Cv_EstadoActivo      VARCHAR2)
    IS
      SELECT
        AN.ID_NUMERACION,AN.SECUENCIA,AN.NUMERACION_UNO,AN.NUMERACION_DOS
        FROM DB_COMERCIAL.ADMI_NUMERACION AN
        INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=AN.OFICINA_ID
        WHERE AN.ESTADO     = Cv_EstadoActivo
          AND AN.CODIGO     = Cv_CodigoNumeraVeh
          AND AN.EMPRESA_ID = Cn_CodEmpresa
          AND AN.OFICINA_ID = Cn_IdOficina;

    CURSOR C_GET_NUM_EMP_TIPO(Cv_CodigoNumeraEmpr   VARCHAR2,
                               Cn_CodEmpresa        INTEGER,
                               Cn_IdOficina         INTEGER,
                               Cv_EstadoActivo      VARCHAR2)
    IS
      SELECT
        AN.ID_NUMERACION,AN.SECUENCIA,AN.NUMERACION_UNO,AN.NUMERACION_DOS
        FROM DB_COMERCIAL.ADMI_NUMERACION AN
        WHERE AN.ESTADO     = Cv_EstadoActivo
          AND AN.CODIGO     = Cv_CodigoNumeraEmpr
          AND AN.EMPRESA_ID = Cn_CodEmpresa
          AND AN.OFICINA_ID = Cn_IdOficina;

    --Numeracion
    Lv_NumeracionUno           VARCHAR2(400);
    Lv_NumeracionDos           VARCHAR2(400);
    Lv_SecuenciaAsig           VARCHAR2(400);
    Lv_NumeroContrato          VARCHAR2(400);
    Lv_EstadoActivo            VARCHAR2(400) := 'Activo';

  BEGIN
         --Secuencia del contrato
        IF Pv_DatosSecuencia.Pv_codigoNumeracionVe IS NOT NULL
        THEN
            IF Pv_DatosSecuencia.Pn_ContrAdend = 0
            THEN
                OPEN C_GET_NUM_CONTRATO_VEHI (Pv_DatosSecuencia.Pv_codigoNumeracionVe,Pv_DatosSecuencia.Pn_CodEmpresa,
                                              Pv_DatosSecuencia.Pn_IdOficina,Lv_EstadoActivo);
                FETCH C_GET_NUM_CONTRATO_VEHI INTO Pn_IdNumeracion,Pn_Secuencia,Lv_NumeracionUno,Lv_NumeracionDos;
                CLOSE C_GET_NUM_CONTRATO_VEHI;
            ELSE
                OPEN C_GET_NUM_EMP_TIPO ('CON',Pv_DatosSecuencia.Pn_CodEmpresa,Pv_DatosSecuencia.Pn_IdOficina,Lv_EstadoActivo);
                FETCH C_GET_NUM_EMP_TIPO INTO Pn_IdNumeracion,Pn_Secuencia,Lv_NumeracionUno,Lv_NumeracionDos;
                CLOSE C_GET_NUM_EMP_TIPO;
            END IF;
        ELSE
            OPEN C_GET_NUM_EMP_TIPO ('CON',Pv_DatosSecuencia.Pn_CodEmpresa,Pv_DatosSecuencia.Pn_IdOficina,Lv_EstadoActivo);
            FETCH C_GET_NUM_EMP_TIPO INTO Pn_IdNumeracion,Pn_Secuencia,Lv_NumeracionUno,Lv_NumeracionDos;
            CLOSE C_GET_NUM_EMP_TIPO;
        END IF;

        IF Pn_Secuencia IS NOT NULL AND Lv_NumeracionUno IS NOT NULL AND Lv_NumeracionDos IS NOT NULL
        THEN
            --Actualización de la númeracion
            Lv_SecuenciaAsig  := LPAD(Pn_Secuencia,7,'0');
            Pn_Secuencia      := Pn_Secuencia + 1;
            UPDATE DB_COMERCIAL.ADMI_NUMERACION SET SECUENCIA = Pn_Secuencia WHERE ID_NUMERACION = Pn_IdNumeracion;
            COMMIT;
            
            Lv_NumeroContrato := CONCAT(CONCAT(CONCAT(Lv_NumeracionUno,CONCAT('-',Lv_NumeracionDos)),'-'),Lv_SecuenciaAsig);
        END IF;
        Pv_NumeroCA:= Lv_NumeroContrato;

        Pv_Mensaje   := 'Proceso realizado con exito';
        Pv_Status    := 'OK';
  EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status    := 'ERROR';
        Pv_Mensaje   := 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        Pv_NumeroCA  := NULL;
        Pn_Secuencia := NULL;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                             'DB_COMERCIAL.P_GENERAR_SECUENCIA',
                                              Pv_Mensaje,
                                             'telcos',
                                             SYSDATE,
                                             '127.0.0.1');


    END P_GENERAR_SECUENCIA;

    PROCEDURE P_GUARDAR_FORMA_PAGO(
                                  Pv_DatosFormaPago IN  DB_COMERCIAL.FORMA_PAGO_TYPE,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR)
    IS

        CURSOR C_GET_TIPO_CUENTA_BANCO (Cv_BancoTipoCuentaID INTEGER)
        IS
            SELECT ABTC.ES_TARJETA
            FROM DB_COMERCIAL.ADMI_BANCO_TIPO_CUENTA ABTC
            WHERE ID_BANCO_TIPO_CUENTA = Cv_BancoTipoCuentaID;

        CURSOR C_GET_FORMA_PAGO( Cn_IdFormaPago      INTEGER)
        IS
          SELECT CODIGO_FORMA_PAGO
          FROM DB_COMERCIAL.ADMI_FORMA_PAGO
          WHERE ID_FORMA_PAGO = Cn_IdFormaPago;

        CURSOR C_GET_ADENDUM (Cn_PuntoId VARCHAR2)
        IS
             SELECT IA.ID_ADENDUM,IA.SERVICIO_ID
             FROM DB_COMERCIAL.INFO_ADENDUM IA
             WHERE IA.PUNTO_ID = Cn_PuntoId;

        --Variables forma Pago
        Lv_CodigoFormaPago         VARCHAR2(400);
        Lv_RespValidaTarjeta       VARCHAR2(1000);
        Lv_ValorCifradoTarjeta     VARCHAR2(2000);
        Lv_EsTarjeta               VARCHAR2(10);
        Lv_EstadoActivo            VARCHAR2(400) := 'Activo';
        Lv_EstadoPendiente         VARCHAR2(400) := 'Pendiente';
        Ln_IngresoAdendum          NUMBER := 0;
        Lv_DatosTarjeta            DB_COMERCIAL.DATOS_TARJETA_TYPE;
        Ln_IteradorI               NUMBER := 0;
    BEGIN                                
        OPEN C_GET_FORMA_PAGO (Pv_DatosFormaPago.Pn_FormaPagoId);
        FETCH C_GET_FORMA_PAGO INTO Lv_CodigoFormaPago;
        CLOSE C_GET_FORMA_PAGO;

        IF Lv_CodigoFormaPago = 'DEB' OR Lv_CodigoFormaPago = 'TARC'
        THEN
            IF Pv_DatosFormaPago.Pn_TipoCuentaID IS NULL OR Pv_DatosFormaPago.Pn_BancoTipoCuentaId IS NULL
             OR Pv_DatosFormaPago.Pv_NumeroCtaTarjeta IS NULL
            THEN
                --0 ->Contrato, 1->Adendum
                IF Pv_DatosFormaPago.Pn_ContrAdend = 0
                THEN
                    RAISE_APPLICATION_ERROR(-20101, 'Faltan datos de cuenta bancaria para el contrato');
                ELSE
                    RAISE_APPLICATION_ERROR(-20101, 'Faltan datos de cuenta bancaria para el adendum');
                END IF;
            END IF;

            IF Pv_DatosFormaPago.Pn_ContrAdend = 0 OR Pv_DatosFormaPago.Pv_CambioTarjeta = 'S'
            THEN
                Lv_DatosTarjeta   := DB_COMERCIAL.DATOS_TARJETA_TYPE( Pv_DatosFormaPago.Pn_TipoCuentaID,
                                                                      Pv_DatosFormaPago.Pn_BancoTipoCuentaId,
                                                                      Pv_DatosFormaPago.Pv_NumeroCtaTarjeta,
                                                                      Pv_DatosFormaPago.Pv_CodigoVerificacion,
                                                                      Pv_DatosFormaPago.Pn_CodEmpresa);

                P_VALIDAR_NUMERO_TARJETA(Lv_DatosTarjeta,Pv_Mensaje,Pv_Status,Lv_RespValidaTarjeta);
                IF Lv_RespValidaTarjeta IS NOT NULL
                THEN
                    RAISE_APPLICATION_ERROR(-20101, Lv_RespValidaTarjeta);
                END IF;
            END IF;

            OPEN C_GET_TIPO_CUENTA_BANCO(Pv_DatosFormaPago.Pn_BancoTipoCuentaId);
            FETCH C_GET_TIPO_CUENTA_BANCO INTO Lv_EsTarjeta;
            CLOSE C_GET_TIPO_CUENTA_BANCO;

            IF Lv_EsTarjeta IS NOT NULL AND Lv_EsTarjeta = 'S' 
              AND (Pv_DatosFormaPago.Pv_AnioVencimiento IS NULL OR Pv_DatosFormaPago.Pv_MesVencimiento IS NULL)
            THEN
                IF Pv_DatosFormaPago.Pn_ContrAdend = 0
                THEN
                    RAISE_APPLICATION_ERROR(-20101, 'No se pudo guardar el contrato -
                      El Anio y mes de Vencimiento de la tarjeta son campos obligatorios');
                ELSE
                    RAISE_APPLICATION_ERROR(-20101, 'No se pudo guardar el adendum -
                      El Anio y mes de Vencimiento de la tarjeta son campos obligatorios');
                END IF;
            END IF;

            IF Pv_DatosFormaPago.Pn_ContrAdend = 0 OR Pv_DatosFormaPago.Pv_CambioTarjeta = 'S' OR Pv_DatosFormaPago.Pv_NumeroCtaTarjeta IS NOT NULL
            THEN
                DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR(Pv_DatosFormaPago.Pv_NumeroCtaTarjeta,'c69555ab183de6672b1ebf6100bbed59186a5d72',Lv_ValorCifradoTarjeta);

                IF Lv_ValorCifradoTarjeta IS NULL
                THEN
                    IF Pv_DatosFormaPago.Pn_ContrAdend = 0
                    THEN
                        RAISE_APPLICATION_ERROR(-20101, 'No se pudo guardar el contrato - Numero de cuenta/tarjeta es incorrecto');
                    ELSE
                        RAISE_APPLICATION_ERROR(-20101, 'No se pudo guardar el adendum - Numero de cuenta/tarjeta es incorrecto');
                    END IF;
                END IF;
            END IF;

            IF Pv_DatosFormaPago.Pv_TitularCuenta IS NULL
            THEN
                IF Pv_DatosFormaPago.Pn_ContrAdend = 0
                THEN
                    RAISE_APPLICATION_ERROR(-20101, 'No se pudo guardar el contrato - El titular de cuenta es un campo obligatorio');
                ELSE
                    RAISE_APPLICATION_ERROR(-20101, 'No se pudo guardar el adendum - El titular de cuenta es un campo obligatorio');
                END IF;
            END IF;

            IF Pv_DatosFormaPago.Pn_ContrAdend = 0
            THEN
                INSERT INTO DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO (
                                                                ID_DATOS_PAGO,
                                                                CONTRATO_ID,
                                                                BANCO_TIPO_CUENTA_ID,
                                                                NUMERO_CTA_TARJETA,
                                                                CODIGO_VERIFICACION,
                                                                TITULAR_CUENTA,
                                                                FE_CREACION,
                                                                USR_CREACION,
                                                                ESTADO,
                                                                TIPO_CUENTA_ID,
                                                                IP_CREACION,
                                                                ANIO_VENCIMIENTO,
                                                                MES_VENCIMIENTO)
                                                        VALUES (
                                                                DB_COMERCIAL.SEQ_INFO_CONTRATO_FORMA_PAGO.NEXTVAL,
                                                                Pv_DatosFormaPago.Pn_IdContrato,
                                                                Pv_DatosFormaPago.Pn_BancoTipoCuentaId,
                                                                Lv_ValorCifradoTarjeta,
                                                                Pv_DatosFormaPago.Pv_CodigoVerificacion,
                                                                Pv_DatosFormaPago.Pv_TitularCuenta,
                                                                SYSDATE,
                                                                SUBSTR(Pv_DatosFormaPago.Pv_UsrCreacion,0,14),
                                                                Lv_EstadoActivo,
                                                                Pv_DatosFormaPago.Pn_TipoCuentaID,
                                                                Pv_DatosFormaPago.Pv_ClienteIp,
                                                                Pv_DatosFormaPago.Pv_AnioVencimiento,
                                                                Pv_DatosFormaPago.Pv_MesVencimiento
                                                                );
            END IF;
        END IF;
        COMMIT;

        IF Pv_DatosFormaPago.Pv_cambioRazonSocial = 'N' THEN
          --Update de la forma de pago del Ademdum
          FOR i IN C_GET_ADENDUM(Pv_DatosFormaPago.Pn_PuntoId)
          LOOP
              Ln_IngresoAdendum := 1;
              IF REGEXP_LIKE(Pv_DatosFormaPago.Pv_Servicio,i.SERVICIO_ID)
              THEN
                  UPDATE DB_COMERCIAL.INFO_ADENDUM
                  SET CONTRATO_ID          = Pv_DatosFormaPago.Pn_IdContrato,
                      FORMA_PAGO_ID        = Pv_DatosFormaPago.Pn_FormaPagoId,
                      TIPO_CUENTA_ID       = Pv_DatosFormaPago.Pn_TipoCuentaID,
                      BANCO_TIPO_CUENTA_ID = Pv_DatosFormaPago.Pn_BancoTipoCuentaId,
                      NUMERO_CTA_TARJETA   = Lv_ValorCifradoTarjeta,
                      TITULAR_CUENTA       = Pv_DatosFormaPago.Pv_TitularCuenta,
                      MES_VENCIMIENTO      = Pv_DatosFormaPago.Pv_MesVencimiento,
                      ANIO_VENCIMIENTO     = Pv_DatosFormaPago.Pv_AnioVencimiento,
                      CODIGO_VERIFICACION  = Pv_DatosFormaPago.Pv_CodigoVerificacion,
                      TIPO                 = Pv_DatosFormaPago.Pv_Tipo,
                      ESTADO               = 'PorAutorizar'
                      -- Para Adendum Pv_EstadoAdendum Pv_NumeroAdendum
                  WHERE ID_ADENDUM = i.ID_ADENDUM;
                  COMMIT;

                  IF Pv_DatosFormaPago.Pv_NumeroAdendum IS NOT NULL
                  THEN
                      UPDATE DB_COMERCIAL.INFO_ADENDUM
                      SET NUMERO               = Pv_DatosFormaPago.Pv_NumeroAdendum,
                          ESTADO               = Pv_DatosFormaPago.Pv_EstadoAdendum
                      WHERE ID_ADENDUM = i.ID_ADENDUM;
                      COMMIT;
                  END IF;
              END IF;
          END LOOP;

          IF Ln_IngresoAdendum = 0
          THEN
              RAISE_APPLICATION_ERROR(-20101, 'El id punto '|| Pv_DatosFormaPago.Pn_PuntoId || '. No tiene registrado Adendum');
          END IF;
        ELSE
          IF Pv_DatosFormaPago.Pn_Adendums.EXISTS(1)
          THEN
              Ln_IteradorI := Pv_DatosFormaPago.Pn_Adendums.FIRST;
              WHILE (Ln_IteradorI IS NOT NULL)
              LOOP
                UPDATE DB_COMERCIAL.INFO_ADENDUM
                  SET CONTRATO_ID          = Pv_DatosFormaPago.Pn_IdContrato,
                      FORMA_PAGO_ID        = Pv_DatosFormaPago.Pn_FormaPagoId,
                      TIPO_CUENTA_ID       = Pv_DatosFormaPago.Pn_TipoCuentaID,
                      BANCO_TIPO_CUENTA_ID = Pv_DatosFormaPago.Pn_BancoTipoCuentaId,
                      NUMERO_CTA_TARJETA   = Lv_ValorCifradoTarjeta,
                      TITULAR_CUENTA       = Pv_DatosFormaPago.Pv_TitularCuenta,
                      MES_VENCIMIENTO      = Pv_DatosFormaPago.Pv_MesVencimiento,
                      ANIO_VENCIMIENTO     = Pv_DatosFormaPago.Pv_AnioVencimiento,
                      CODIGO_VERIFICACION  = Pv_DatosFormaPago.Pv_CodigoVerificacion,
                      ESTADO               = Lv_EstadoPendiente
                WHERE ID_ADENDUM = Pv_DatosFormaPago.Pn_Adendums(Ln_IteradorI);
                COMMIT;
                
                IF Pv_DatosFormaPago.Pv_NumeroAdendum IS NOT NULL
                  THEN
                      UPDATE DB_COMERCIAL.INFO_ADENDUM
                      SET NUMERO               = Pv_DatosFormaPago.Pv_NumeroAdendum
                      WHERE ID_ADENDUM = Pv_DatosFormaPago.Pn_Adendums(Ln_IteradorI);
                      COMMIT;
                  END IF;   
                Ln_IteradorI := Pv_DatosFormaPago.Pn_Adendums.NEXT(Ln_IteradorI);             
              END LOOP;
          END IF;
        END IF;

        COMMIT;
        Pv_Mensaje:= 'Proceso realizado';
        Pv_Status := 'OK';

        OPEN Pcl_Response FOR
        SELECT ID_ADENDUM,SERVICIO_ID
        FROM   DB_COMERCIAL.INFO_ADENDUM
        WHERE  CONTRATO_ID = Pv_DatosFormaPago.Pn_IdContrato
        AND NUMERO IS NOT NULL;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        Pv_Mensaje   := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        Pv_Status    := 'ERROR';
        Pcl_Response :=  NULL;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                             'DB_COMERCIAL.P_GUARDAR_FORMA_PAGO',
                                              'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                             'telcos',
                                             SYSDATE,
                                             '127.0.0.1');
    END P_GUARDAR_FORMA_PAGO;

  PROCEDURE P_CREAR_ADENDUM(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR)
  IS

        CURSOR C_GET_SERVICIO(Cn_IdServicio INTEGER, Cn_IdPunto INTEGER)
        IS
            SELECT ID_SERVICIO
            FROM DB_COMERCIAL.INFO_SERVICIO ISE
            INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON IPU.ID_PUNTO = ISE.PUNTO_ID
            WHERE
            ISE.ID_SERVICIO = Cn_IdServicio AND
            IPU.PERSONA_EMPRESA_ROL_ID IN (
                SELECT IPU.PERSONA_EMPRESA_ROL_ID
                FROM DB_COMERCIAL.INFO_SERVICIO ISE
                INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON IPU.ID_PUNTO = ISE.PUNTO_ID
                WHERE IPU.ID_PUNTO = Cn_IdPunto
            );
        -- Variables globales de empresa - usuario
        Ln_CodEmpresa              INTEGER;
        Lv_PrefijoEmpresa          VARCHAR2(400);
        Ln_IdOficina               INTEGER;
        Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
        Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';

        --Datos Secuencia
        Lv_DatosSecuencia          DB_COMERCIAL.DATOS_SECUENCIA;
        Lv_NumeroAdendum           VARCHAR2(400);
        Lv_Tipo                    VARCHAR2(400);
        Ln_Secuencia               INTEGER;
        Ln_SigSecuencia            INTEGER;
        Ln_IdNumeracion            INTEGER;
        Ln_IdContrato              INTEGER;

        --Forma Pago
        Ln_FormaPagoId             INTEGER;
        Ln_TipoCuentaID            INTEGER;
        Ln_BancoTipoCuentaId       INTEGER;
        Lv_NumeroCtaTarjeta        VARCHAR2(400);
        Lv_DatosFormPago           DB_COMERCIAL.FORMA_PAGO_TYPE;

        Lv_CodigoVerificacion      VARCHAR2(400);
        Lv_AnioVencimiento         VARCHAR2(400);
        Lv_MesVencimiento          VARCHAR2(400);
        Lv_TitularCuenta           VARCHAR2(400);

        Ln_PuntoId                 INTEGER;
        Lv_Servicio                VARCHAR2(1000);
        Lv_ServicioId              INTEGER;
        Lv_ServicioValidoId        INTEGER;
        Lv_CambioTarjeta           VARCHAR2(10);
        Lv_RespuestaFormaPago      SYS_REFCURSOR;

        Lv_CodigoNumeracion        VARCHAR2(400);
        Ln_CountServicios          INTEGER :=0;
        Ln_CountAdendumsRS         INTEGER :=0;
        Lv_EstadoAdendum           VARCHAR2(400);
        Lv_cambioRazonSocial       VARCHAR2(400);
        Lv_AdendumId               INTEGER;
        
        Pcl_ArrayAdendumsEncontrado Pcl_AdendumsEncontrado_Type := Pcl_AdendumsEncontrado_Type();

  BEGIN
        APEX_JSON.PARSE(Pcl_Request);

        Ln_CodEmpresa         := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
        Lv_PrefijoEmpresa     := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
        Ln_IdOficina          := APEX_JSON.get_varchar2(p_path => 'oficinaId');
        Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,14);
        Lv_ClienteIp          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
        Lv_Tipo               := APEX_JSON.get_varchar2(p_path => 'tipo');

        Lv_CambioTarjeta      := APEX_JSON.get_varchar2(p_path => 'adendum.cambioNumeroTarjeta');

        --ValoresTarjeta
        Ln_PuntoId            := APEX_JSON.get_varchar2(p_path => 'adendum.puntoId');
        Ln_IdContrato         := APEX_JSON.get_varchar2(p_path => 'adendum.contratoId');
        Lv_EstadoAdendum      := APEX_JSON.get_varchar2(p_path => 'adendum.estado');
        Lv_NumeroCtaTarjeta   := APEX_JSON.get_varchar2(p_path => 'adendum.numeroCtaTarjeta');
        Lv_CodigoVerificacion := APEX_JSON.get_varchar2(p_path => 'adendum.codigoVerificacion');
        Lv_AnioVencimiento    := APEX_JSON.get_varchar2(p_path => 'adendum.anioVencimiento');
        Lv_MesVencimiento     := APEX_JSON.get_varchar2(p_path => 'adendum.mesVencimiento');
        Lv_TitularCuenta      := APEX_JSON.get_varchar2(p_path => 'adendum.titularCuenta');
        Ln_BancoTipoCuentaId  := APEX_JSON.get_varchar2(p_path => 'adendum.bancoTipoCuentaId');
        Ln_TipoCuentaID       := APEX_JSON.get_varchar2(p_path => 'adendum.tipoCuentaId');
        Ln_FormaPagoId        := APEX_JSON.get_varchar2(p_path => 'adendum.formaPagoId');

        Ln_CountServicios     := APEX_JSON.GET_COUNT(p_path => 'adendum.servicios');
        Ln_CountAdendumsRS    := APEX_JSON.GET_COUNT(p_path => 'adendum.adendumsRazonSocial');
        
        Lv_cambioRazonSocial := APEX_JSON.get_varchar2(p_path => 'cambioRazonSocial');

        IF Ln_CountServicios IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountServicios LOOP
                APEX_JSON.PARSE(Pcl_Request);
                Lv_ServicioId      := APEX_JSON.get_number(p_path => 'adendum.servicios[%d]',  p0 => i);
                OPEN C_GET_SERVICIO (Lv_ServicioId,Ln_PuntoId);
                FETCH C_GET_SERVICIO INTO Lv_ServicioValidoId;
                CLOSE C_GET_SERVICIO;
                IF Lv_ServicioValidoId IS NULL
                THEN
                    RAISE_APPLICATION_ERROR(-20101, 'El id servicio '|| Lv_ServicioId || '. No Corresponde al cliente');
                END IF;
                Lv_ServicioValidoId:= NULL;
                Lv_Servicio        := CONCAT(Lv_Servicio,CONCAT(Lv_ServicioId,','));
            END LOOP;
        END IF;
        
        IF Ln_CountAdendumsRS IS NOT NULL
        THEN
            FOR i IN 1 .. Ln_CountAdendumsRS LOOP
              Lv_AdendumId      := APEX_JSON.get_number(p_path => 'adendum.adendumsRazonSocial[%d]',  p0 => i);
              Pcl_ArrayAdendumsEncontrado.extend;
              Pcl_ArrayAdendumsEncontrado(i) := Lv_AdendumId;
            END LOOP;
        END IF;

        IF Lv_Tipo IS NOT NULL AND Lv_Tipo = 'AS'
        THEN
            Lv_CodigoNumeracion:= 'CONA';
        ELSE
            Lv_CodigoNumeracion:= 'CON';
        END IF;

         --Secuencia del contrato
        Lv_DatosSecuencia := DB_COMERCIAL.DATOS_SECUENCIA(Lv_CodigoNumeracion,Ln_CodEmpresa,Ln_IdOficina,1);
        P_GENERAR_SECUENCIA(Lv_DatosSecuencia,Pv_Mensaje,Pv_Status,Lv_NumeroAdendum,Ln_Secuencia,Ln_IdNumeracion);

        IF Lv_NumeroAdendum IS NULL
        THEN
            RAISE_APPLICATION_ERROR(-20101, 'No se pudo obtener la numeracion');
        END IF;

        --Forma de Pago
        Lv_DatosFormPago := DB_COMERCIAL.FORMA_PAGO_TYPE(Ln_FormaPagoId,Ln_TipoCuentaID,
                                                         Ln_BancoTipoCuentaId,Lv_NumeroCtaTarjeta,
                                                         Lv_CodigoVerificacion,Ln_CodEmpresa,
                                                         Lv_AnioVencimiento,Lv_TitularCuenta,
                                                         Ln_IdContrato,Lv_MesVencimiento,
                                                         Lv_UsrCreacion,Lv_ClienteIp,
                                                         Ln_PuntoId,Lv_Servicio,Lv_CambioTarjeta,
                                                         1,Lv_Tipo,'PorAutorizar',Lv_NumeroAdendum,
                                                         Lv_cambioRazonSocial, Pcl_ArrayAdendumsEncontrado);

        P_GUARDAR_FORMA_PAGO(Lv_DatosFormPago,Pv_Mensaje,Pv_Status,Lv_RespuestaFormaPago);

        IF Pv_Status IS NULL OR Pv_Status = 'ERROR'
        THEN
            RAISE_APPLICATION_ERROR(-20101,Pv_Mensaje);
        END IF;
        COMMIT;

        OPEN Pcl_Response FOR
        SELECT Lv_NumeroAdendum AS numeroAdendum
        FROM   DUAL;

        Pv_Mensaje   := 'Proceso realizado';
        Pv_Status    := 'OK';
  EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status    := 'ERROR';
        Pv_Mensaje   := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        Pcl_Response := NULL;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                             'DB_COMERCIAL.P_CREAR_ADENDUM',
                                             'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                             'telcos',
                                             SYSDATE,
                                             '127.0.0.1');


    END P_CREAR_ADENDUM;

    PROCEDURE P_SETEAR_DATOS_CONTRATO(Pcl_Request IN  DB_COMERCIAL.DATOS_CONTRATO_TYPE,
                                      Pv_Mensaje  OUT VARCHAR2,
                                      Pv_Status   OUT VARCHAR2)
    IS
      CURSOR C_GET_CONTRATO(Cn_IdContrato INTEGER)
      IS
        SELECT
          IC.PERSONA_EMPRESA_ROL_ID,
          IC.ESTADO
        FROM
          DB_COMERCIAL.INFO_CONTRATO IC
        WHERE
          IC.ID_CONTRATO = Cn_IdContrato;

      CURSOR C_GET_PERSONA_EMPRESA_ROL(Cn_PersonaEmpresaRolId INTEGER)
      IS
        SELECT
          IPER.EMPRESA_ROL_ID,
          IPER.PERSONA_ID    ,
          IPER.OFICINA_ID    ,
          IPER.ES_PREPAGO    ,
          IPER.ID_PERSONA_ROL
        FROM
          INFO_PERSONA_EMPRESA_ROL IPER
        WHERE
          IPER.ID_PERSONA_ROL = Cn_PersonaEmpresaRolId;

      Pn_PersonaEmpresaRolId INTEGER;
      Pv_Estado              VARCHAR2(30);
      Le_Errors              EXCEPTION;
    BEGIN
      OPEN C_GET_CONTRATO(Pcl_Request.Pn_IdContrato);
      FETCH C_GET_CONTRATO INTO Pn_PersonaEmpresaRolId, Pv_Estado;
      CLOSE C_GET_CONTRATO;

      IF Pcl_Request.Pv_Origen IS NOT NULL THEN
        UPDATE
          DB_COMERCIAL.INFO_CONTRATO IC
        SET IC.ORIGEN = Pcl_Request.Pv_Origen
        WHERE
          IC.ID_CONTRATO = Pcl_Request.Pn_IdContrato;
        COMMIT;
      END IF;

      IF Pn_PersonaEmpresaRolId IS NOT NULL
        AND
        Pcl_Request.Pv_Origen IS NOT NULL THEN
        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO
          ( ID_PERSONA_EMPRESA_ROL_HISTO,
            ESTADO                      ,
            FE_CREACION                 ,
            IP_CREACION                 ,
            PERSONA_EMPRESA_ROL_ID      ,
            USR_CREACION                ,
            OBSERVACION
          )
          VALUES
          ( DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
            'Activo'                                           ,
            SYSDATE                                            ,
            Pcl_Request.Pv_IpCreacion                          ,
            Pn_PersonaEmpresaRolId                             ,
            Pcl_Request.pv_usrCreacion                         ,
            Pcl_Request.Pv_ObservacionHistorial
          );
          COMMIT;
      ELSE
        Pv_Mensaje := 'No se pudo setear los datos del contrato, error al obtener personaEmpresaRol o Origen';
        RAISE Le_Errors;
      END IF;
      Pv_Mensaje := 'Proceso realizado con exito';
      Pv_Status  := 'OK';
    EXCEPTION
    WHEN Le_Errors THEN
      ROLLBACK;
      Pv_Status := 'ERROR';
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO', 'DB_COMERCIAL.P_SETEAR_DATOS_CONTRATO', Pv_Mensaje, 'telcos', SYSDATE, '127.0.0.1');
    END P_SETEAR_DATOS_CONTRATO;

    PROCEDURE P_APROBAR_ADENDUM(
                                  Pcl_Request              IN  DB_COMERCIAL.DATOS_APROBAR_ADENDUM_TYPE,
                                  Pv_Mensaje               OUT VARCHAR2,
                                  Pv_Status                OUT VARCHAR2)
                                  IS

    CURSOR C_GET_PUNTO(Cn_IdServicio INTEGER)
    IS
    SELECT 
        ISE.PUNTO_ID,ISE.ID_SERVICIO,ISE.PLAN_ID,IPU.PUNTO_COBERTURA_ID,ISE.PRODUCTO_ID,
        APO.REQUIERE_PLANIFICACION,ISE.ESTADO,IST.ULTIMA_MILLA_ID,ATM.NOMBRE_TIPO_MEDIO,
        APO.ESTADO_INICIAL,ISE.TIPO_ORDEN
    FROM
        DB_COMERCIAL.INFO_SERVICIO ISE
        INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON IPU.ID_PUNTO = ISE.PUNTO_ID
        LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APO ON APO.ID_PRODUCTO = ISE.PRODUCTO_ID
        LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO IST ON IST.SERVICIO_ID = ISE.ID_SERVICIO
        LEFT JOIN DB_COMERCIAL.ADMI_TIPO_MEDIO ATM ON ATM.ID_TIPO_MEDIO = IST.ULTIMA_MILLA_ID
        WHERE ISE.ID_SERVICIO = Cn_IdServicio;

    CURSOR C_GET_SOLICITUD(Cn_IdServicio INTEGER,Cv_EstadoSolicitud VARCHAR2)
    IS
    SELECT 
        IDS.ID_DETALLE_SOLICITUD
    FROM
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        WHERE IDS.SERVICIO_ID = Cn_IdServicio AND
              IDS.ESTADO = Cv_EstadoSolicitud;

    CURSOR C_GET_DATOS_NUM_OF(Cn_IdPersonaEmprRol INTEGER,
                              Cv_EstadoActivo     VARCHAR2,
                              Cv_Codigo           VARCHAR2)
    IS
    SELECT 
        AN.ID_NUMERACION,IOG.ID_OFICINA,AN.SECUENCIA,AN.NUMERACION_UNO,AN.NUMERACION_DOS
    FROM
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
        INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IPER.OFICINA_ID = IOG.ID_OFICINA
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.ADMI_NUMERACION AN ON IER.EMPRESA_COD = AN.EMPRESA_ID AND AN.OFICINA_ID = IOG.ID_OFICINA
        WHERE IPER.ID_PERSONA_ROL = Cn_IdPersonaEmprRol AND AN.ESTADO = Cv_EstadoActivo AND AN.CODIGO=Cv_Codigo;

    CURSOR C_GET_COUNT_SOLICITUD (Cn_IdServicio INTEGER,
                                  Cv_DescripSol VARCHAR2,
                                  Cv_Estado     VARCHAR2)
    IS
    SELECT 
        COUNT(IDS.TIPO_SOLICITUD_ID)
    FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
    INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
    INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISE ON ISE.ID_SERVICIO = IDS.SERVICIO_ID
    WHERE UPPER(IDS.ESTADO) <> UPPER(Cv_Estado) AND 
          ISE.ID_SERVICIO = Cn_IdServicio AND
          ATS.DESCRIPCION_SOLICITUD = Cv_DescripSol;

    CURSOR C_GET_TIPO_SOLICITUD (Cv_DescripSol VARCHAR2)
    IS
    SELECT 
        ATS.ID_TIPO_SOLICITUD
    FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
    WHERE ATS.DESCRIPCION_SOLICITUD = Cv_DescripSol;

    CURSOR C_GET_ADENDUM (Cn_IdServicio INTEGER)
    IS
    SELECT 
        IAD.ID_ADENDUM
    FROM DB_COMERCIAL.INFO_ADENDUM IAD
    WHERE IAD.SERVICIO_ID = Cn_IdServicio;

    Lv_EstadoActivo         VARCHAR2(50) := 'Activo';
    Lv_EstadoActiva         VARCHAR2(50) := 'Activa';
    Lv_EstadoFactible       VARCHAR2(50) := 'Factible';
    Lv_EstadoPendiente      VARCHAR2(50) := 'Pendiente';
    Lv_EstadoPreplanificada VARCHAR2(50) := 'PrePlanificada';
    Lv_EstadoFactiAnticipa  VARCHAR2(100):= 'Factibilidad-anticipada';
    Lv_CodigoNumeracion     VARCHAR2(50) := 'ORD';
    Ln_IdServicio           INTEGER;
    Ln_IdPunto              INTEGER;
    Ln_IdOficina            INTEGER;
    Lv_Secuencia            INTEGER;
    Lv_NumeracionUno        VARCHAR2(50);
    Lv_NumeracionDos        VARCHAR2(50);

    Lv_SecuenciaAsig        VARCHAR2(100);
    Lv_NumeroOrdenTra       VARCHAR2(400);
    Lv_TipoOrden            VARCHAR2(400) := 'N';

    Lv_IdNumeracion         INTEGER;
    Ln_IdOrdenTrabajo       INTEGER;
    Ln_SecuenciaSig         INTEGER;
    Ln_PlanId               INTEGER;
    Ln_IdJurisdiccion       INTEGER;
    Ln_IdAdmiProducto       INTEGER;
    Lv_RequierePlanifica    VARCHAR2(10);
    Lv_EstadoServicio       VARCHAR2(100);

    Ln_RequierePlanifi      INTEGER := 0;
    Ln_HayServicio          INTEGER := 0;
    Lv_PrefioEmprComparaMD  VARCHAR2(10) := 'MD';
    Lv_PrefioEmprComparaTN  VARCHAR2(10) := 'TN';
    Ln_IdUltimaMilla        INTEGER;
    Ln_NombreTipoMedio      VARCHAR2(100);
    Lv_MillaRadio           VARCHAR2(100) := 'Radio';
    Lv_EstadoSolPlanifica   VARCHAR2(100) := 'PrePlanificada';--PrePlanificada Asignar-factibilidad
    Ln_IdDetalleSolicitud   INTEGER;
    Lv_EstadoInicial        VARCHAR2(100);
    Lv_ObservacionServicio  VARCHAR2(400) := 'Se Confimo el Servicio';
    Lv_AccionServicio       VARCHAR2(400) := 'confirmarServicio';
    Lv_TipoOrdenServicio    VARCHAR2(400);
    Lv_UsrContrato          VARCHAR2(400) := 'telcos_contrato';
    Lv_DescripSolicitud     VARCHAR2(400) := 'SOLICITUD PLANIFICACION';
    Ln_NumeroSolicitud      INTEGER := 0;
    Lv_EstadoRechazada      VARCHAR2(400) := 'Rechazada';
    Ln_IdTipoSolicitud      INTEGER;
    Ln_DetalleSolNuevo      INTEGER;
    Ln_IdAdendum            INTEGER;
    Ln_IteradorI            INTEGER;
    Ln_ObservacionHist      VARCHAR2(4000);

    BEGIN

    Ln_ObservacionHist := Pcl_Request.Pv_ObservacionHistorial;
    IF Pcl_Request.Pv_Servicios.EXISTS(1)
    THEN
        Ln_IteradorI := Pcl_Request.Pv_Servicios.FIRST;
        WHILE (Ln_IteradorI IS NOT NULL)
        LOOP

            Ln_IdServicio   := Pcl_Request.Pv_Servicios(Ln_IteradorI);

            OPEN C_GET_PUNTO(Ln_IdServicio);
            FETCH C_GET_PUNTO INTO  Ln_IdPunto,
                                    Ln_IdServicio,
                                    Ln_PlanId,
                                    Ln_IdJurisdiccion,
                                    Ln_IdAdmiProducto,
                                    Lv_RequierePlanifica,
                                    Lv_EstadoServicio,
                                    Ln_IdUltimaMilla,
                                    Ln_NombreTipoMedio,
                                    Lv_EstadoInicial,
                                    Lv_TipoOrdenServicio;
            CLOSE C_GET_PUNTO;

            OPEN C_GET_DATOS_NUM_OF(Pcl_Request.Pn_PersonaEmpresaRolId,Lv_EstadoActivo,Lv_CodigoNumeracion);
            FETCH C_GET_DATOS_NUM_OF INTO Lv_IdNumeracion,Ln_IdOficina,Lv_Secuencia,Lv_NumeracionUno,Lv_NumeracionDos;
            CLOSE C_GET_DATOS_NUM_OF;

            IF Lv_Secuencia IS NOT NULL
            THEN
                Lv_SecuenciaAsig    := LPAD(Lv_Secuencia,7,'0');
                Lv_NumeroOrdenTra   := Lv_NumeracionUno || '-' || Lv_NumeracionDos || '-' || Lv_SecuenciaAsig;
            END IF;

            INSERT INTO DB_COMERCIAL.INFO_ORDEN_TRABAJO (
                                    ID_ORDEN_TRABAJO, 
                                    NUMERO_ORDEN_TRABAJO, 
                                    PUNTO_ID, 
                                    FE_CREACION,
                                    USR_CREACION,  
                                    IP_CREACION, 
                                    TIPO_ORDEN, 
                                    OFICINA_ID, 
                                    ESTADO)
            VALUES(
                SEQ_INFO_ORDEN_TRABAJO.NEXTVAL,
                Lv_NumeroOrdenTra,
                Ln_IdPunto,
                SYSDATE,
                Pcl_Request.Pv_UsrCreacion,
                Pcl_Request.Pv_IpCreacion,
                Lv_TipoOrden,
                Ln_IdOficina,
                Lv_EstadoActiva
            ) RETURNING ID_ORDEN_TRABAJO INTO Ln_IdOrdenTrabajo;

            IF Ln_IdOrdenTrabajo IS NOT NULL AND Lv_Secuencia IS NOT NULL
            THEN      
                Ln_SecuenciaSig := Lv_Secuencia + 1;
                UPDATE 
                DB_COMERCIAL.ADMI_NUMERACION AN
                    SET AN.SECUENCIA = Ln_SecuenciaSig
                WHERE 
                    AN.ID_NUMERACION = Lv_IdNumeracion;
                COMMIT;
            END IF;

            IF Ln_IdServicio IS NOT NULL
            THEN  

                OPEN C_GET_ADENDUM (Ln_IdServicio);
                FETCH C_GET_ADENDUM INTO Ln_IdAdendum;
                CLOSE C_GET_ADENDUM;

                IF Ln_IdAdendum IS NOT NULL
                THEN

                    UPDATE 
                    DB_COMERCIAL.INFO_SERVICIO ISE
                        SET ISE.ORDEN_TRABAJO_ID = Ln_IdOrdenTrabajo
                    WHERE 
                        ISE.ID_SERVICIO = Ln_IdServicio;

                    IF Pcl_Request.Pv_PrefijoEmpresa = Lv_PrefioEmprComparaMD
                    THEN
                        IF Ln_PlanId IS NOT NULL THEN
                            Ln_RequierePlanifi := 1;
                            Ln_HayServicio     := 1;
                            Lv_EstadoServicio  := Lv_EstadoPreplanificada;
                            Ln_ObservacionHist := 'Se solicito planificacion';
                            UPDATE
                            DB_COMERCIAL.INFO_SERVICIO ISE
                                SET ISE.ESTADO = Lv_EstadoPreplanificada
                            WHERE 
                                ISE.ID_SERVICIO = Ln_IdServicio;
                        ELSE
                           IF Ln_IdAdmiProducto IS NOT NULL AND
                              Lv_RequierePlanifica = 'SI' AND
                              Lv_EstadoServicio    = Lv_EstadoFactible
                           THEN
                                Ln_RequierePlanifi := 1;
                                Ln_HayServicio     := 1;

                                UPDATE
                                DB_COMERCIAL.INFO_SERVICIO ISE
                                    SET ISE.ESTADO = Lv_EstadoPreplanificada
                                WHERE 
                                    ISE.ID_SERVICIO = Ln_IdServicio; 
                           END IF;
                        END IF;
                    ELSE
                        IF Ln_IdAdmiProducto IS NOT NULL AND
                           Lv_RequierePlanifica = 'SI' AND
                           Lv_EstadoServicio    = Lv_EstadoFactible
                        THEN
                            Ln_RequierePlanifi := 1;

                            UPDATE
                            DB_COMERCIAL.INFO_SERVICIO ISE
                                SET ISE.ESTADO = Lv_EstadoPreplanificada
                            WHERE 
                                ISE.ID_SERVICIO = Ln_IdServicio; 
                        ELSIF Lv_EstadoServicio = Lv_EstadoFactiAnticipa
                        THEN
                            IF Pcl_Request.Pv_PrefijoEmpresa = Lv_PrefioEmprComparaTN AND 
                               Ln_IdUltimaMilla IS NOT NULL AND
                               Ln_IdUltimaMilla > 0 AND Ln_NombreTipoMedio IS NOT NULL AND
                               Ln_NombreTipoMedio = Lv_MillaRadio 
                            THEN
                                Lv_EstadoSolPlanifica := 'Asignar-factibilidad';
                                Ln_RequierePlanifi := 1;
                                UPDATE
                                DB_COMERCIAL.INFO_SERVICIO ISE
                                    SET ISE.ESTADO = Lv_EstadoSolPlanifica
                                WHERE 
                                    ISE.ID_SERVICIO = Ln_IdServicio;

                                OPEN C_GET_SOLICITUD(Ln_IdServicio,Lv_EstadoFactiAnticipa);
                                FETCH C_GET_SOLICITUD INTO Ln_IdDetalleSolicitud;
                                CLOSE C_GET_SOLICITUD;

                                IF Ln_IdDetalleSolicitud IS NOT NULL
                                THEN
                                    UPDATE
                                    DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                                        SET IDS.ESTADO = Lv_EstadoSolPlanifica
                                    WHERE 
                                        IDS.ID_DETALLE_SOLICITUD = Ln_IdDetalleSolicitud;
                                    END IF;

                                    INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                                    (
                                        ID_SOLICITUD_HISTORIAL, 
                                        DETALLE_SOLICITUD_ID, 
                                        ESTADO, 
                                        USR_CREACION, 
                                        FE_CREACION, 
                                        IP_CREACION
                                    )
                                    VALUES
                                    (
                                        SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                                        Ln_IdDetalleSolicitud,
                                        Lv_EstadoSolPlanifica,
                                        Pcl_Request.Pv_UsrCreacion,
                                        SYSDATE,
                                        Pcl_Request.Pv_IpCreacion
                                    );
                            END IF;
                        ELSIF Ln_IdAdmiProducto IS NOT NULL AND
                           Lv_EstadoInicial = Lv_EstadoActivo AND
                           Lv_EstadoServicio    = Lv_EstadoPendiente
                        THEN
                            UPDATE
                            DB_COMERCIAL.INFO_SERVICIO ISE
                                SET ISE.ESTADO = Lv_EstadoInicial
                            WHERE 
                                ISE.ID_SERVICIO = Ln_IdServicio;

                            INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                            (
                                ID_SERVICIO_HISTORIAL, 
                                SERVICIO_ID, 
                                USR_CREACION, 
                                FE_CREACION, 
                                IP_CREACION, 
                                ESTADO, 
                                OBSERVACION, 
                                ACCION
                            )
                            VALUES
                            (
                                SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                                Ln_IdServicio,
                                Pcl_Request.Pv_UsrCreacion,
                                SYSDATE,
                                Pcl_Request.Pv_IpCreacion,
                                Lv_EstadoInicial,
                                Lv_ObservacionServicio,
                                Lv_AccionServicio
                            );
                        END IF;
                    END IF;    

                    IF Lv_TipoOrdenServicio IS NOT NULL
                    THEN
                        UPDATE
                        DB_COMERCIAL.INFO_ORDEN_TRABAJO IOT
                            SET IOT.TIPO_ORDEN = Lv_TipoOrdenServicio
                        WHERE 
                            IOT.ID_ORDEN_TRABAJO = Ln_IdOrdenTrabajo;
                    END IF;

                    IF Ln_RequierePlanifi = 1
                    THEN
                        INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                        (
                            ID_SERVICIO_HISTORIAL, 
                            SERVICIO_ID, 
                            USR_CREACION, 
                            FE_CREACION, 
                            IP_CREACION, 
                            ESTADO, 
                            OBSERVACION
                        )
                        VALUES
                        (
                            SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                            Ln_IdServicio,
                            Lv_UsrContrato,
                            SYSDATE,
                            Pcl_Request.Pv_IpCreacion,
                            Lv_EstadoServicio,
                            Ln_ObservacionHist
                        );

                        OPEN C_GET_TIPO_SOLICITUD (Lv_DescripSolicitud);
                        FETCH C_GET_TIPO_SOLICITUD INTO Ln_IdTipoSolicitud;
                        CLOSE C_GET_TIPO_SOLICITUD;

                        OPEN C_GET_COUNT_SOLICITUD (Ln_IdServicio,Lv_DescripSolicitud,Lv_EstadoRechazada);
                        FETCH C_GET_COUNT_SOLICITUD INTO Ln_NumeroSolicitud;
                        CLOSE C_GET_COUNT_SOLICITUD;

                        IF Ln_NumeroSolicitud IS NULL OR Ln_NumeroSolicitud <= 0 OR Ln_IdDetalleSolicitud IS NOT NULL
                        THEN
                            INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS (
                                                        ID_DETALLE_SOLICITUD,
                                                        SERVICIO_ID,
                                                        TIPO_SOLICITUD_ID,
                                                        ESTADO,
                                                        USR_CREACION,
                                                        FE_CREACION)
                            VALUES(
                                DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL,
                                Ln_IdServicio,
                                Ln_IdTipoSolicitud,
                                Lv_EstadoSolPlanifica,
                                Pcl_Request.Pv_UsrCreacion,
                                SYSDATE
                            )
                            RETURNING IDS.ID_DETALLE_SOLICITUD INTO Ln_DetalleSolNuevo;

                            INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                            (
                                ID_SOLICITUD_HISTORIAL, 
                                DETALLE_SOLICITUD_ID, 
                                ESTADO, 
                                USR_CREACION, 
                                FE_CREACION, 
                                IP_CREACION
                            )
                            VALUES
                            (
                                SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                                Ln_DetalleSolNuevo,
                                Lv_EstadoSolPlanifica,
                                Pcl_Request.Pv_UsrCreacion,
                                SYSDATE,
                                Pcl_Request.Pv_IpCreacion
                            );

                            IF Ln_HayServicio = 1
                            THEN
                                DBMS_OUTPUT.PUT_LINE('Cupos Moviles -> getCuposMobil');
                            END IF;

                        END IF;

                    END IF;

                    UPDATE DB_COMERCIAL.INFO_ADENDUM
                    SET ESTADO = Lv_EstadoActivo
                    WHERE ID_ADENDUM = Ln_IdAdendum;

                    COMMIT;

                ELSE
                    RAISE_APPLICATION_ERROR(-20101, 'No se encuentra adendum para activar');
                END IF;

            ELSE
                RAISE_APPLICATION_ERROR(-20101, 'No se encuentra servicio para activar adendum');
            END IF;

        Ln_IdServicio       := NULL;
        Ln_IdOficina        := NULL;
        Ln_IdOrdenTrabajo   := NULL;
        Ln_SecuenciaSig     := NULL;
        Ln_PlanId           := NULL;
        Ln_IdAdendum        := NULL;
        Ln_RequierePlanifi  := 0;
        Ln_HayServicio      := 0;
        Ln_IteradorI := Pcl_Request.Pv_Servicios.NEXT(Ln_IteradorI);
        END LOOP;
    --ELSE
    --    RAISE_APPLICATION_ERROR(-20101, 'Servicios no enviados para adendum');
    END IF;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Proceso realizado con éxito';
    EXCEPTION
            WHEN OTHERS THEN
            ROLLBACK;
            Pv_Status     := 'ERROR';
            Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                                 'DB_COMERCIAL.P_APROBAR_ADENDUM',
                                                 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                                 'telcos',
                                                  SYSDATE,
                                                 '127.0.0.1');

    END P_APROBAR_ADENDUM;

    PROCEDURE P_APROBAR_CONTRATO(Pcl_Request IN  DB_COMERCIAL.DATOS_APROBAR_CONTRATO_TYPE,
                                 Pv_Mensaje  OUT VARCHAR2,
                                 Pv_Status   OUT VARCHAR2)
    IS
      CURSOR C_GET_APLICA_CICLO_FACTURACION(Cv_NombreParametro  VARCHAR2,
                                            Cv_Modulo           VARCHAR2,
                                            Cv_Proceso          VARCHAR2,
                                            Cn_EmpresaCod       INTEGER)
      IS
      SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD, DB_GENERAL.ADMI_PARAMETRO_CAB APC
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APC.MODULO = Cv_Modulo
        AND APC.PROCESO = Cv_Proceso
        AND APD.EMPRESA_COD = Cn_EmpresaCod
        AND APC.ESTADO = 'Activo'
        AND APD.ESTADO = 'Activo';

      CURSOR C_CONTRATO_PARAMS(Cn_ContratoId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_CONTRATO IC
        WHERE IC.ID_CONTRATO = Cn_ContratoId;

      CURSOR C_PERSONA_EMPRESA_ROL_PARAMS(Cn_PersonaEmpresaRolId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IC
        WHERE IC.ID_PERSONA_ROL = Cn_PersonaEmpresaRolId;

      CURSOR C_EMPRESA_ROL_PARAMS(Cn_EmpresaRolId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_EMPRESA_ROL IC
        WHERE IC.ID_EMPRESA_ROL = Cn_EmpresaRolId;

      CURSOR C_PERSONA_PARAMS(Cn_PersonaId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_PERSONA IC
        WHERE IC.ID_PERSONA = Cn_PersonaId;

      CURSOR C_PERSONA_REPRESENTANTE_PARAMS(Cn_PersonaEmpresaRolId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE IC
        WHERE IC.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId
        AND IC.ESTADO = 'Activo';

      CURSOR C_PRODUCTO_PARAMS(Cn_ProductoId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.ADMI_PRODUCTO IC
        WHERE IC.ID_PRODUCTO = Cn_ProductoId;

      CURSOR C_OFICINA_PARAMS(Cn_OficinaId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IC
        WHERE IC.ID_OFICINA = Cn_OficinaId;

     CURSOR C_ULTIMA_MILLA_PARAMS(Cn_UltimaMillaId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.ADMI_TIPO_MEDIO IC
        WHERE IC.ID_TIPO_MEDIO = Cn_UltimaMillaId;

     CURSOR C_CARACTERISTICA_PARAMS(Cn_CaracteristicaId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.ADMI_CARACTERISTICA IC
        WHERE IC.ID_CARACTERISTICA = Cn_CaracteristicaId
        AND IC.ESTADO = 'Activo';

      CURSOR C_FORMA_PAGO_PARAMS(Cn_FormaPagoId NUMBER)
      IS
        SELECT IC.*
        FROM DB_GENERAL.ADMI_FORMA_PAGO IC
        WHERE IC.ID_FORMA_PAGO = Cn_FormaPagoId;

      CURSOR C_PERSONA_REFERIDO(Cn_PersonaEmpresaRolId     VARCHAR2)
      IS
      SELECT IPR.*
      FROM DB_COMERCIAL.INFO_PERSONA_REFERIDO IPR
      WHERE IPR.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId
          AND IPR.ESTADO = 'Activo';

      CURSOR C_SERVICIO_TECNICO_PARAMS(Cn_ServicioId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO IC
        WHERE IC.SERVICIO_ID = Cn_ServicioId;

      CURSOR C_SERVICIO_PARAMS(Cn_ServicioId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_SERVICIO IC
        WHERE IC.ID_SERVICIO = Cn_ServicioId;

      CURSOR C_COUNT_SERVICIO_OT_ADICIONAL(Cn_ServicioId NUMBER, Cn_ProductoId NUMBER)
      IS
        SELECT COUNT(AP.ID_PRODUCTO)
        FROM DB_COMERCIAL.INFO_SERVICIO IC, DB_COMERCIAL.ADMI_PRODUCTO AP
        WHERE IC.PRODUCTO_ID = AP.ID_PRODUCTO
        AND AP.ID_PRODUCTO = Cn_ProductoId
        AND IC.ID_SERVICIO = Cn_ServicioId
        AND IC.ESTADO IN ('Activo','Asignada','PrePlanificada');

      CURSOR C_PUNTO_PARAMS(Cn_PuntoId NUMBER)
      IS
        SELECT IC.*
        FROM DB_COMERCIAL.INFO_PUNTO IC
        WHERE IC.ID_PUNTO = Cn_PuntoId;

      CURSOR C_EMPRESA_ROL_CLIENTE(Cn_CodEmpresa   INTEGER,
                                   Cv_NombreTipoRol VARCHAR2)
      IS
        SELECT IER.*
        FROM DB_COMERCIAL.INFO_EMPRESA_ROL IER, DB_COMERCIAL.ADMI_ROL AR, DB_COMERCIAL.ADMI_TIPO_ROL ATR
        WHERE IER.ROL_ID = AR.ID_ROL
        AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
        AND IER.EMPRESA_COD = Cn_CodEmpresa
        AND ATR.DESCRIPCION_TIPO_ROL = Cv_NombreTipoRol
        AND AR.DESCRIPCION_ROL = Cv_NombreTipoRol;

      CURSOR C_CLIENTE_POR_IDEN(Cv_IdenCliente    VARCHAR2,
                                Cn_CodEmpresa     INTEGER)
      IS
        SELECT IPE.*
          FROM DB_COMERCIAL.INFO_PERSONA IPE, DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER, DB_COMERCIAL.INFO_EMPRESA_ROL IER, DB_COMERCIAL.ADMI_ROL AR, DB_COMERCIAL.ADMI_TIPO_ROL ATR
          WHERE IPE.ID_PERSONA = IPER.PERSONA_ID
          AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
          AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
          AND IPER.ESTADO = 'Activo'
          AND UPPER(ATR.DESCRIPCION_TIPO_ROL) = UPPER ('Cliente')
          AND IPE.IDENTIFICACION_CLIENTE = Cv_IdenCliente
          AND IER.EMPRESA_COD = Cn_CodEmpresa;

      CURSOR C_GET_NUMERACION(Cn_EmpresaCod    INTEGER,
                              Cn_OficinaId     INTEGER,
                              Cv_Codigo        VARCHAR2)
      IS
        SELECT AN.ID_NUMERACION, AN.SECUENCIA, AN.NUMERACION_UNO, AN.NUMERACION_DOS
          FROM DB_COMERCIAL.ADMI_NUMERACION AN
          WHERE AN.EMPRESA_ID = Cn_EmpresaCod
          AND AN.OFICINA_ID = Cn_OficinaId
          AND AN.CODIGO = Cv_Codigo;

      CURSOR C_DET_PARAMETRO_PARAMS(Cv_NombreParametro VARCHAR2,
                                    Cv_Descripcion VARCHAR2,
                                    Cv_CodEmpresa VARCHAR2)
      IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APD.DESCRIPCION = Cv_Descripcion
      AND APD.EMPRESA_COD = Cv_CodEmpresa
      AND APC.ESTADO = 'Activo'
      AND APD.ESTADO = 'Activo';

      CURSOR C_DET_PARAMETRO_VALOR1(Cv_NombreParametro VARCHAR2,
                                    Cv_Valor1 VARCHAR2,
                                    Cv_CodEmpresa VARCHAR2)
      IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APD.VALOR1 = Cv_Valor1
      AND APD.EMPRESA_COD = Cv_CodEmpresa
      AND APC.ESTADO = 'Activo'
      AND APD.ESTADO = 'Activo';

      CURSOR C_LIST_DET_PARAMETRO(Cv_NombreParametro VARCHAR2)
      IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APC.ESTADO = 'Activo'
      AND APD.ESTADO = 'Activo';

      CURSOR C_SOL_FACTIBILIDAD_ANTICIP(Cn_ServicioId INTEGER,
                                        Cv_Estado     VARCHAR2)
      IS
      SELECT IDS.*
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
      WHERE IDS.SERVICIO_ID = Cn_ServicioId
          AND IDS.ESTADO = Cv_Estado;

      CURSOR C_GET_TIPO_SOLICITUD(Cv_DescripcionSolicitud     VARCHAR2)
      IS
      SELECT ATS.*
      FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
      WHERE ATS.DESCRIPCION_SOLICITUD = Cv_DescripcionSolicitud;

      CURSOR C_GET_DETALLE_SOLICITUD(Cn_ServicioId          INTEGER,
                                     Cn_TipoSolicitudId     VARCHAR2)
      IS
      SELECT COUNT(IDS.SERVICIO_ID)
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS, DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS, DB_COMERCIAL.INFO_SERVICIO ISE
      WHERE IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
          AND IDS.SERVICIO_ID = ISE.ID_SERVICIO
          AND ISE.ID_SERVICIO = Cn_ServicioId
          AND ATS.ID_TIPO_SOLICITUD = Cn_TipoSolicitudId
          AND LOWER(IDS.ESTADO) != LOWER('Rechazada');

      CURSOR C_CARAT_CICLO_FACTURACION(Cn_IdPersonaRol     VARCHAR2)
      IS
      SELECT CI.NOMBRE_CICLO, IPERC.ID_PERSONA_EMPRESA_ROL_CARACT, IPERC.PERSONA_EMPRESA_ROL_ID,
             IPERC.CARACTERISTICA_ID, IPERC.VALOR, IPERC.ESTADO
          FROM
          DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
          DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
          DB_COMERCIAL.ADMI_CARACTERISTICA CA,
          DB_COMERCIAL.ADMI_CICLO CI
          WHERE IPER.ID_PERSONA_ROL                                    = Cn_IdPersonaRol
          AND IPERC.PERSONA_EMPRESA_ROL_ID                             = IPER.ID_PERSONA_ROL
          AND IPERC.CARACTERISTICA_ID                                  = CA.ID_CARACTERISTICA
          AND CA.DESCRIPCION_CARACTERISTICA                            = 'CICLO_FACTURACION'
          AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0) = CI.ID_CICLO
          AND IPERC.ESTADO                                             = 'Activo'
          AND ROWNUM                                                   = 1;

      CURSOR C_GET_LIST_PERC(Cv_Estado              VARCHAR2,
                             Cn_PersonaEmpresaRolId INTEGER,
                             Cn_CaracteristicaId    INTEGER)
      IS
      SELECT IPERC.ID_PERSONA_EMPRESA_ROL_CARACT, IPERC.PERSONA_EMPRESA_ROL_ID, IPERC.CARACTERISTICA_ID
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC
      WHERE IPERC.ESTADO = Cv_Estado
          AND IPERC.CARACTERISTICA_ID = Cn_CaracteristicaId
          AND IPERC.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId;

      CURSOR C_CONTACTOS(Cn_PersonaEmpresaRolId     INTEGER)
      IS
      SELECT IPC.ID_PERSONA_CONTACTO, IPC.PERSONA_EMPRESA_ROL_ID
      FROM DB_COMERCIAL.INFO_PERSONA_CONTACTO IPC
      WHERE IPC.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId;

      CURSOR C_PUNTOS(Cn_PersonaEmpresaRolId     INTEGER)
      IS
      SELECT IPE.*
      FROM DB_COMERCIAL.INFO_PUNTO IPE
      WHERE IPE.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId;

      CURSOR C_PUNTO_ADICIONAL(Cn_PuntoId     INTEGER)
      IS
      SELECT IPDA.*
      FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA
      WHERE IPDA.PUNTO_ID = Cn_PuntoId;

      CURSOR C_PER_EMP_ROL_CARACT(Cn_PersonaEmpresaRolId     INTEGER,
                                  Cn_CaracteristicaId        INTEGER,
                                  Cv_Estado                  VARCHAR2)
      IS
      SELECT IPERC.*
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC
      WHERE IPERC.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId
          AND IPERC.CARACTERISTICA_ID = Cn_CaracteristicaId
          AND IPERC.ESTADO = Cv_Estado;

      CURSOR C_MOTIVO_PARAMS(Cv_NombreMotivo     VARCHAR2)
      IS
      SELECT AM.*
      FROM DB_COMERCIAL.ADMI_MOTIVO AM
      WHERE AM.NOMBRE_MOTIVO = Cv_NombreMotivo;

      CURSOR C_HISTORIAL_PER_EMP_ROL(Cn_PersonaEmpresaRolId     INTEGER)
      IS
      SELECT IPERH.*
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH
      WHERE IPERH.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId;

      CURSOR C_GET_PERSONA_EMPRESA_ROL (Cn_PersonaId INTEGER, Cn_EmpresaRolId INTEGER, Cv_DescripcionRol VARCHAR2, Cv_Estado VARCHAR2)
      IS
      SELECT
          IPER.ID_PERSONA_ROL
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER, DB_COMERCIAL.INFO_EMPRESA_ROL IERO, DB_COMERCIAL.ADMI_ROL ADRO
      WHERE IPER.EMPRESA_ROL_ID = IERO.ID_EMPRESA_ROL
      AND IERO.ROL_ID           = ADRO.ID_ROL
      AND IPER.PERSONA_ID       = Cn_PersonaId
      AND IPER.EMPRESA_ROL_ID   = Cn_EmpresaRolId
      AND ADRO.DESCRIPCION_ROL  = Cv_DescripcionRol
      AND IPER.ESTADO           = Cv_Estado
      AND ROWNUM = 1;

      Lv_AplicaCicloFac               VARCHAR2(4000);
      Lc_Contrato                     C_CONTRATO_PARAMS%rowtype;
      Lc_PersonaEmpresaRol            C_PERSONA_EMPRESA_ROL_PARAMS%rowtype;
      Lc_EmpresaRol                   C_EMPRESA_ROL_PARAMS%rowtype;
      Lc_Persona                      C_PERSONA_PARAMS%rowtype;
      Lc_Oficina                      C_OFICINA_PARAMS%rowtype;
      Lc_EmpresaRolCliente            C_EMPRESA_ROL_CLIENTE%rowtype;
      Lc_Cliente                      C_CLIENTE_POR_IDEN%rowtype;
      Lc_FormaPago                    C_FORMA_PAGO_PARAMS%rowtype;
      Lc_Servicio                     C_SERVICIO_PARAMS%rowtype;
      Lc_Punto                        C_PUNTO_PARAMS%rowtype;
      Lc_Producto                     C_PRODUCTO_PARAMS%rowtype;
      Lc_OficinaVirtual               C_LIST_DET_PARAMETRO%rowtype;
      Lc_ServicioTecnico              C_SERVICIO_TECNICO_PARAMS%rowtype;
      Lc_UltimaMilla                  C_ULTIMA_MILLA_PARAMS%rowtype;
      Lc_SolFactibilidadAnticip       C_SOL_FACTIBILIDAD_ANTICIP%rowtype;
      Lc_TipoSolicitud                C_GET_TIPO_SOLICITUD%rowtype;
      Lc_PersonaRepresentante         C_PERSONA_REPRESENTANTE_PARAMS%rowtype;
      Lc_CaractCiclo                  C_CARACTERISTICA_PARAMS%rowtype;
      Lc_PersonaReferido              C_PERSONA_REFERIDO%rowtype;
      Lc_PuntoAdicional               C_PUNTO_ADICIONAL%rowtype;
      Lc_CaractContrSolidaria         C_CARACTERISTICA_PARAMS%rowtype;
      Lc_PerEmpRolCarContrSolidaria   C_PER_EMP_ROL_CARACT%rowtype;
      Lc_MotivoCambioDatosFactu       C_MOTIVO_PARAMS%rowtype;
      Ln_Secuencia                    NUMBER;
      Ln_NumeracionUno                NUMBER;
      Ln_NumeracionDos                NUMBER;
      Lv_SecuenciaAsignada            VARCHAR2(30);
      Lv_NumeroOrdenTrabajo           VARCHAR2(30);
      Lv_EstadoActiva                 VARCHAR2(50) := 'Activa';
      Lv_TipoOrden                    VARCHAR2(400) := 'N';
      Ln_IdOrdenTrabajo               INTEGER;
      Ln_SecuenciaSig                 INTEGER;
      Lv_IdNumeracion                 INTEGER;
      Lb_RequierePlanficacion         BOOLEAN := FALSE;
      Lb_HayServicio                  BOOLEAN := FALSE;
      Lv_EstadoServicio               VARCHAR2(50);
      Lv_ObservacionHistorial         VARCHAR2(4000);
      Lv_EstadoSolPlanificacion       VARCHAR2(100);
      Lv_ObservacionHistorialServ     VARCHAR2(100);
      Lv_UsrTelcosContrato            VARCHAR2(100) := 'telcos_contrato';
      Ln_IdJurisdiccion               INTEGER;
      Lv_ContarDetalleSolicitud       INTEGER;
      Ln_DetalleSolicitudIdNew        INTEGER;
      Ln_IdPersonaEmpresaRolCliente   INTEGER;
      Lv_NombreCiclo                  VARCHAR2(50);
      Ln_IdPersonaEmpresaRolCaract    INTEGER;
      Ln_PersonaEmpresaRolIdFact      INTEGER;
      Ln_CaracteristicaId             INTEGER;
      Lv_Valor                        VARCHAR2(1000);
      Lv_EstadoFact                   VARCHAR2(30);
      Ln_IdPersonaRepresenanteNew     INTEGER;
      Lv_ContribucionSolidaria        VARCHAR2(30);
      Lv_RptContribucionSolidaria     VARCHAR2(1000);
      Ln_SectorId                     INTEGER;
      Ln_MotivoCambioDatosFactuTemp   INTEGER;
      Lv_ObervacionPerEmpRolHisTemp   VARCHAR2(1000);
      Ln_TotalServicioOtAdic          INTEGER;
      Ln_IteradorK                    INTEGER;
      Pcl_GenerarOtAdicional          DB_COMERCIAL.DATOS_GENERAR_OT_TYPE;
      Le_Errors                       EXCEPTION;
      Ln_PersonaEmpresaRolId          INTEGER;
    BEGIN
      -- VALIDACIONES
      IF Pcl_Request.Pn_FormaPagoId IS NULL THEN
        Pv_Mensaje := 'Información incompleta, no se está enviando la forma de pago del contrato';
        RAISE Le_Errors;
      END IF;

      OPEN C_GET_APLICA_CICLO_FACTURACION('CICLO_FACTURACION_EMPRESA', 'FINANCIERO', 'CICLO_FACTURACION', Pcl_Request.Pv_EmpresaCod);
      FETCH C_GET_APLICA_CICLO_FACTURACION INTO Lv_AplicaCicloFac;
      CLOSE C_GET_APLICA_CICLO_FACTURACION;

      IF Pcl_Request.Pv_ObservacionHistorial IS NOT NULL THEN
        Lv_ObservacionHistorial := Pcl_Request.Pv_ObservacionHistorial;
      END IF;

      OPEN C_CONTRATO_PARAMS(Pcl_Request.Pn_ContratoId);
      FETCH C_CONTRATO_PARAMS INTO Lc_Contrato;
      CLOSE C_CONTRATO_PARAMS;

      OPEN C_PERSONA_EMPRESA_ROL_PARAMS(Pcl_Request.Pn_PersonaEmpresaRolId);
      FETCH C_PERSONA_EMPRESA_ROL_PARAMS INTO Lc_PersonaEmpresaRol;
      CLOSE C_PERSONA_EMPRESA_ROL_PARAMS;

      OPEN C_EMPRESA_ROL_PARAMS(Lc_PersonaEmpresaRol.Empresa_Rol_Id);
      FETCH C_EMPRESA_ROL_PARAMS INTO Lc_EmpresaRol;
      CLOSE C_EMPRESA_ROL_PARAMS;

      OPEN C_PERSONA_PARAMS(Lc_PersonaEmpresaRol.Persona_Id);
      FETCH C_PERSONA_PARAMS INTO Lc_Persona;
      CLOSE C_PERSONA_PARAMS;

      OPEN C_OFICINA_PARAMS(Lc_PersonaEmpresaRol.Oficina_Id);
      FETCH C_OFICINA_PARAMS INTO Lc_Oficina;
      CLOSE C_OFICINA_PARAMS;

      OPEN C_EMPRESA_ROL_CLIENTE(Lc_EmpresaRol.Empresa_Cod, 'Cliente');
      FETCH C_EMPRESA_ROL_CLIENTE INTO Lc_EmpresaRolCliente;
      CLOSE C_EMPRESA_ROL_CLIENTE;

      OPEN C_CLIENTE_POR_IDEN(Lc_Persona.Identificacion_Cliente, Lc_EmpresaRol.Empresa_Cod);
      FETCH C_CLIENTE_POR_IDEN INTO Lc_Cliente;
      CLOSE C_CLIENTE_POR_IDEN;

      IF Lc_Cliente.Id_Persona IS NULL THEN
        Pv_Mensaje := 'No se encontro la información del cliente, Favor Revisar!';
        RAISE Le_Errors;
      END IF;

      OPEN C_GET_PERSONA_EMPRESA_ROL(Lc_Persona.Id_Persona, Lc_EmpresaRolCliente.Id_Empresa_Rol, 'Cliente','Activo');
      FETCH C_GET_PERSONA_EMPRESA_ROL INTO Ln_PersonaEmpresaRolId;
      CLOSE C_GET_PERSONA_EMPRESA_ROL;

      IF Ln_PersonaEmpresaRolId IS NOT NULL AND Ln_PersonaEmpresaRolId <> 0 THEN
        Pv_Mensaje := 'El cliente ya existe... no se puede aprobar, Favor Revisar!';
        RAISE Le_Errors;
      END IF;

      OPEN C_FORMA_PAGO_PARAMS(Pcl_Request.Pn_FormaPagoId);
      FETCH C_FORMA_PAGO_PARAMS INTO Lc_FormaPago;
      CLOSE C_FORMA_PAGO_PARAMS;

      -- Genero orden de trabajo de todos los servicios factibles marcados en el listado
      IF Pcl_Request.Pv_Servicios.EXISTS(1)
      THEN
          Ln_IteradorK := Pcl_Request.Pv_Servicios.FIRST;
          WHILE (Ln_IteradorK IS NOT NULL)
          LOOP
            OPEN C_SERVICIO_PARAMS(Pcl_Request.Pv_Servicios(Ln_IteradorK));
            FETCH C_SERVICIO_PARAMS INTO Lc_Servicio;
            CLOSE C_SERVICIO_PARAMS;
            OPEN C_PUNTO_PARAMS(Lc_Servicio.Punto_Id);
            FETCH C_PUNTO_PARAMS INTO Lc_Punto;
            CLOSE C_PUNTO_PARAMS;

            -- Genero numeracion
            OPEN C_GET_NUMERACION(Lc_EmpresaRol.Empresa_Cod, Lc_Oficina.Id_Oficina, 'ORD');
            FETCH C_GET_NUMERACION INTO Lv_IdNumeracion, Ln_Secuencia, Ln_NumeracionUno, Ln_NumeracionDos;
            CLOSE C_GET_NUMERACION;

            IF Ln_Secuencia IS NOT NULL THEN
              Lv_SecuenciaAsignada  := LPAD(TO_CHAR(Ln_Secuencia), 7, '0');
              Lv_NumeroOrdenTrabajo := Ln_NumeracionUno || '-' || Ln_NumeracionDos || '-' || Lv_SecuenciaAsignada;
            ELSE
              OPEN C_LIST_DET_PARAMETRO('OFICINA VIRTUAL');
              FETCH C_LIST_DET_PARAMETRO INTO Lc_OficinaVirtual;
              CLOSE C_LIST_DET_PARAMETRO;

              OPEN C_GET_NUMERACION(Lc_EmpresaRol.Empresa_Cod, Lc_OficinaVirtual.Valor1, 'ORD');
              FETCH C_GET_NUMERACION INTO Lv_IdNumeracion, Ln_Secuencia, Ln_NumeracionUno, Ln_NumeracionDos;
              CLOSE C_GET_NUMERACION;
            END IF;


            INSERT INTO DB_COMERCIAL.INFO_ORDEN_TRABAJO (
                                    ID_ORDEN_TRABAJO, 
                                    NUMERO_ORDEN_TRABAJO, 
                                    PUNTO_ID, 
                                    FE_CREACION,
                                    USR_CREACION,  
                                    IP_CREACION, 
                                    TIPO_ORDEN, 
                                    OFICINA_ID, 
                                    ESTADO)
            VALUES(
                SEQ_INFO_ORDEN_TRABAJO.NEXTVAL,
                Lv_NumeroOrdenTrabajo,
                Lc_Punto.Id_Punto,
                SYSDATE,
                Pcl_Request.Pv_UsrCreacion,
                Pcl_Request.Pv_IpCreacion,
                Lv_TipoOrden,
                Lc_Oficina.Id_Oficina,
                Lv_EstadoActiva
            ) RETURNING ID_ORDEN_TRABAJO INTO Ln_IdOrdenTrabajo;

            -- Se actualiza la numeracion de las ordenes de trabajo
            IF Ln_IdOrdenTrabajo IS NOT NULL AND Ln_Secuencia IS NOT NULL
            THEN      
                Ln_SecuenciaSig := Ln_Secuencia + 1;
                UPDATE 
                DB_COMERCIAL.ADMI_NUMERACION AN
                    SET AN.SECUENCIA = Ln_SecuenciaSig
                WHERE 
                    AN.ID_NUMERACION = Lv_IdNumeracion;
            END IF;

            IF Lc_Servicio.Id_Servicio IS NOT NULL THEN
              Lv_ObservacionHistorialServ := 'Se solicito planificacion';
              Lv_EstadoSolPlanificacion := 'PrePlanificada';
              -- Actualizo servicio con la orden de trabajo
              IF Pcl_Request.Pv_PrefijoEmpresa = 'MD' THEN
                Lv_EstadoServicio := 'PrePlanificada';
                Lb_RequierePlanficacion := TRUE;
                Lb_HayServicio := TRUE;
                Ln_IdJurisdiccion := Lc_Punto.Punto_Cobertura_Id;
              ELSE
                OPEN C_PRODUCTO_PARAMS(Lc_Servicio.Producto_Id);
                FETCH C_PRODUCTO_PARAMS INTO Lc_Producto;
                CLOSE C_PRODUCTO_PARAMS;
                IF Lc_Producto.Id_Producto IS NOT NULL AND 
                   Lc_Producto.Requiere_Planificacion = 'SI' AND 
                   Lc_Producto.Estado = 'Factible' THEN
                  Lv_EstadoServicio := 'PrePlanificada';
                  Lb_RequierePlanficacion := TRUE;
                ELSIF Lc_Producto.Id_Producto IS NOT NULL AND
                   Lc_Producto.Estado = 'Factibilidad-anticipada' THEN
                   IF Pcl_Request.Pv_PrefijoEmpresa = 'TN' THEN
                    OPEN C_SERVICIO_TECNICO_PARAMS(Pcl_Request.Pn_ContratoId);
                    FETCH C_SERVICIO_TECNICO_PARAMS INTO Lc_ServicioTecnico;
                    CLOSE C_SERVICIO_TECNICO_PARAMS;

                    IF Lc_ServicioTecnico.Id_Servicio_Tecnico IS NOT NULL AND 
                      Lc_ServicioTecnico.Ultima_Milla_Id > 0 THEN
                      OPEN C_ULTIMA_MILLA_PARAMS(Lc_ServicioTecnico.Ultima_Milla_Id);
                      FETCH C_ULTIMA_MILLA_PARAMS INTO Lc_UltimaMilla;
                      CLOSE C_ULTIMA_MILLA_PARAMS;
                      IF Lc_UltimaMilla.Nombre_Tipo_Medio = 'Radio' AND
                        Lc_Servicio.Estado = 'Factibilidad-anticipada' THEN
                        Lv_EstadoSolPlanificacion := 'Asignar-factibilidad';
                        Lv_EstadoServicio := Lv_EstadoSolPlanificacion;
                        Lb_RequierePlanficacion := TRUE;
                        Lv_ObservacionHistorial := 'Se solicita asignar factibilidad de servicio Radio';
                        OPEN C_SOL_FACTIBILIDAD_ANTICIP(Lc_Servicio.Id_Servicio, 'Factibilidad-anticipada');
                        FETCH C_SOL_FACTIBILIDAD_ANTICIP INTO Lc_SolFactibilidadAnticip;
                        CLOSE C_SOL_FACTIBILIDAD_ANTICIP;
                        IF Lc_SolFactibilidadAnticip.Id_Detalle_Solicitud IS NOT NULL THEN
                          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                          SET IDS.ESTADO = Lv_EstadoSolPlanificacion
                          WHERE IDS.ID_DETALLE_SOLICITUD = Lc_SolFactibilidadAnticip.Id_Detalle_Solicitud;

                          INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST (
                                                                    ID_SOLICITUD_HISTORIAL,
                                                                    DETALLE_SOLICITUD_ID,
                                                                    IP_CREACION,
                                                                    FE_CREACION,
                                                                    USR_CREACION,
                                                                    ESTADO)
                          VALUES(DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                                 Lc_SolFactibilidadAnticip.Id_Detalle_Solicitud,
                                 Pcl_Request.Pv_IpCreacion,
                                 SYSDATE,
                                 Pcl_Request.Pv_UsrCreacion,
                                 Lv_EstadoSolPlanificacion);
                        END IF;
                      END IF;
                    END IF;
                   END IF;

                ELSIF Lc_Producto.Id_Producto IS NOT NULL AND
                  Lc_Producto.Estado = 'Activo' AND
                  Lc_Servicio.Estado = 'Pendiente' THEN
                  -- Producto no requiere flujo. Se realizara activacion autormatica
                  Lv_EstadoServicio := Lc_Producto.Estado_Inicial;
                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (
                                                    ID_SERVICIO_HISTORIAL,
                                                    SERVICIO_ID,
                                                    OBSERVACION,
                                                    IP_CREACION,
                                                    USR_CREACION,
                                                    FE_CREACION,
                                                    ACCION,
                                                    ESTADO)
                                            VALUES(
                                                DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                                                Lc_Servicio.Id_Servicio,
                                                'Se confirmó el servicio',
                                                Pcl_Request.Pv_IpCreacion,
                                                Pcl_Request.Pv_UsrCreacion,
                                                SYSDATE,
                                                'confirmarServicio',
                                                Lc_Producto.Estado_Inicial
                                            );
                END IF;
              END IF;
              UPDATE DB_COMERCIAL.INFO_SERVICIO ISE
              SET ISE.ESTADO = Lv_EstadoServicio,
                  ISE.ORDEN_TRABAJO_ID = Ln_IdOrdenTrabajo
              WHERE ISE.ID_SERVICIO = Lc_Servicio.Id_Servicio;
              IF Lc_Servicio.Tipo_Orden IS NOT NULL THEN
                UPDATE DB_COMERCIAL.INFO_ORDEN_TRABAJO IOT
                SET IOT.TIPO_ORDEN = Lc_Servicio.Tipo_Orden
                WHERE IOT.ID_ORDEN_TRABAJO = Ln_IdOrdenTrabajo;
              END IF;
              IF Lb_RequierePlanficacion THEN
                -- Crear historial del servicio
                INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH (
                                                ID_SERVICIO_HISTORIAL,
                                                SERVICIO_ID,
                                                OBSERVACION,
                                                IP_CREACION,
                                                USR_CREACION,
                                                FE_CREACION,
                                                ESTADO)
                                        VALUES(
                                            DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                                            Lc_Servicio.Id_Servicio,
                                            Lv_ObservacionHistorialServ,
                                            Pcl_Request.Pv_IpCreacion,
                                            Lv_UsrTelcosContrato,
                                            SYSDATE,
                                            Lv_EstadoServicio
                                        );
                -- Crear solicitud de plantificacion del servicio
                OPEN C_GET_TIPO_SOLICITUD('SOLICITUD PLANIFICACION');
                FETCH C_GET_TIPO_SOLICITUD INTO Lc_TipoSolicitud;
                CLOSE C_GET_TIPO_SOLICITUD;

                OPEN C_GET_DETALLE_SOLICITUD(Lc_Servicio.Id_Servicio, Lc_TipoSolicitud.Id_Tipo_Solicitud);
                FETCH C_GET_DETALLE_SOLICITUD INTO Lv_ContarDetalleSolicitud;
                CLOSE C_GET_DETALLE_SOLICITUD;

                IF Lv_ContarDetalleSolicitud IS NOT NULL OR Lv_ContarDetalleSolicitud <= 0 OR Lc_SolFactibilidadAnticip.Id_Detalle_Solicitud IS NOT NULL THEN
                  INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD (
                                                ID_DETALLE_SOLICITUD,
                                                SERVICIO_ID,
                                                TIPO_SOLICITUD_ID,
                                                ESTADO,
                                                USR_CREACION,
                                                FE_CREACION)
                  VALUES(DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL,
                         Lc_Servicio.Id_Servicio,
                         Lc_TipoSolicitud.Id_Tipo_Solicitud,
                         Lv_EstadoSolPlanificacion,
                         Pcl_Request.Pv_UsrCreacion,
                         SYSDATE)
                  RETURNING ID_DETALLE_SOLICITUD INTO Ln_DetalleSolicitudIdNew;

                  INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST (
                                                ID_SOLICITUD_HISTORIAL,
                                                DETALLE_SOLICITUD_ID,
                                                IP_CREACION,
                                                USR_CREACION,
                                                FE_CREACION,
                                                ESTADO)
                   VALUES(DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                          Ln_DetalleSolicitudIdNew,
                          Pcl_Request.Pv_IpCreacion,
                          Pcl_Request.Pv_UsrCreacion,
                          SYSDATE,
                          Lv_EstadoSolPlanificacion);
                END IF;
              END IF;
            END IF;
            Ln_IteradorK := Pcl_Request.Pv_Servicios.NEXT(Ln_IteradorK);   
          END LOOP; 
      END IF;

      -- Actualizo la informacion del prospecto que sera convertido a cliente
      -- Actualizo la informacion de la persona y se activa
      UPDATE DB_COMERCIAL.INFO_PERSONA IP
        SET IP.ESTADO               = 'Activo',
            IP.ORIGEN_PROSPECTO     = 'S',
            IP.USR_CREACION         = Pcl_Request.Pv_UsrCreacion,
            IP.IP_CREACION          = Pcl_Request.Pv_IpCreacion
        WHERE IP.ID_PERSONA = Lc_Persona.Id_Persona;

      -- Se crea el nuevo persona empresa rol con rol:Cliente
      INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL (
                                                ID_PERSONA_ROL,
                                                EMPRESA_ROL_ID,
                                                PERSONA_ID,
                                                OFICINA_ID,
                                                FE_CREACION,
                                                USR_CREACION,
                                                ES_PREPAGO,
                                                ESTADO)
      VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL.NEXTVAL,
             Lc_EmpresaRolCliente.Id_Empresa_Rol,
             Lc_Persona.Id_Persona,
             Lc_Oficina.Id_Oficina,
             SYSDATE,
             Pcl_Request.Pv_UsrCreacion,
             Lc_PersonaEmpresaRol.Es_Prepago,
             'Activo')
      RETURNING Id_Persona_Rol INTO Ln_IdPersonaEmpresaRolCliente;
      ---Se crea caracteristica del usuario (260)
       INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC (
                                            ID_PERSONA_EMPRESA_ROL_CARACT,
                                            PERSONA_EMPRESA_ROL_ID,
                                            CARACTERISTICA_ID,
                                            VALOR,
                                            FE_CREACION,
                                            USR_CREACION,
                                            IP_CREACION,
                                            ESTADO)
          VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL,
                 Ln_IdPersonaEmpresaRolCliente,
                 260,
                 Lc_Persona.Identificacion_Cliente,
                 SYSDATE,
                 Pcl_Request.Pv_UsrCreacion,
                 Pcl_Request.Pv_IpCreacion,
                 'Activo');
      
      

      IF Pcl_Request.Pv_PrefijoEmpresa = 'MD' AND Lc_Persona.Tipo_Tributario = 'JUR' THEN
        OPEN C_PERSONA_REPRESENTANTE_PARAMS (Lc_PersonaEmpresaRol.Id_Persona_Rol);
        FETCH C_PERSONA_REPRESENTANTE_PARAMS INTO Lc_PersonaRepresentante;
        CLOSE C_PERSONA_REPRESENTANTE_PARAMS;

        IF Lc_PersonaRepresentante.Id_Persona_Representante IS NOT NULL THEN
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE (
                                                        ID_PERSONA_REPRESENTANTE,
                                                        PERSONA_EMPRESA_ROL_ID,
                                                        REPRESENTANTE_EMPRESA_ROL_ID,
                                                        RAZON_COMERCIAL,
                                                        FE_REGISTRO_MERCANTIL,
                                                        FE_EXPIRACION_NOMBRAMIENTO,
                                                        ESTADO,
                                                        USR_CREACION,
                                                        FE_CREACION,
                                                        IP_CREACION,
                                                        OBSERVACION)
          VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_REPRESENTANTE.NEXTVAL,
                 Ln_IdPersonaEmpresaRolCliente,
                 Lc_PersonaRepresentante.Representante_Empresa_Rol_Id,
                 Lc_PersonaRepresentante.Razon_Comercial,
                 Lc_PersonaRepresentante.Fe_Registro_Mercantil,
                 Lc_PersonaRepresentante.Fe_Expiracion_Nombramiento,
                 'Activo',
                 Pcl_Request.Pv_UsrCreacion,
                 SYSDATE,
                 Pcl_Request.Pv_IpCreacion,
                 'Actualización de rol precliente a cliente')
          RETURNING ID_PERSONA_REPRESENTANTE INTO Ln_IdPersonaRepresenanteNew;

          UPDATE DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE IPR
          SET IPR.ESTADO = 'Eliminado',
              IPR.FE_ULT_MOD = SYSDATE,
              IPR.USR_ULT_MOD = Pcl_Request.Pv_UsrCreacion,
              IPR.IP_ULT_MOD = Pcl_Request.Pv_IpCreacion
          WHERE IPR.ID_PERSONA_REPRESENTANTE = Lc_PersonaRepresentante.Id_Persona_Representante;
        END IF;
      END IF;

      -- Asignar ciclo de facturacion del pre-cliente a cliente
      IF Lv_AplicaCicloFac = 'S' THEN
        OPEN C_CARAT_CICLO_FACTURACION (Lc_PersonaEmpresaRol.Id_Persona_Rol);
        FETCH C_CARAT_CICLO_FACTURACION INTO Lv_NombreCiclo, Ln_IdPersonaEmpresaRolCaract, Ln_PersonaEmpresaRolIdFact, Ln_CaracteristicaId, Lv_Valor, Lv_EstadoFact;
        CLOSE C_CARAT_CICLO_FACTURACION;
        IF Ln_IdPersonaEmpresaRolCaract IS NULL THEN
          Pv_Mensaje := 'No fue posible aprobar el contrato - El Pre-Cliente no posee Ciclo de Facturación asignado';
          RAISE Le_Errors;
        ELSE
          OPEN C_CARACTERISTICA_PARAMS(Ln_CaracteristicaId);
          FETCH C_CARACTERISTICA_PARAMS INTO Lc_CaractCiclo;
          CLOSE C_CARACTERISTICA_PARAMS;

          IF Lc_CaractCiclo.Id_Caracteristica IS NULL THEN
            Pv_Mensaje := 'No fue posible aprobar el contrato - No existe Caracteristica CICLO_FACTURACION';
            RAISE Le_Errors;
          END IF;

          FOR i in C_GET_LIST_PERC('Activo', Ln_IdPersonaEmpresaRolCliente, Lc_CaractCiclo.Id_Caracteristica) LOOP
            UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC
            SET IPERC.ESTADO = 'Inactivo',
                IPERC.FE_ULT_MOD = SYSDATE,
                IPERC.USR_ULT_MOD = Pcl_Request.Pv_UsrCreacion
            WHERE IPERC.Id_Persona_Empresa_Rol_Caract = i.Id_Persona_Empresa_Rol_Caract;

            INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH (
                                            ID_PERSONA_EMPRESA_ROL_HISTO,
                                            USR_CREACION,
                                            FE_CREACION,
                                            IP_CREACION,
                                            ESTADO,
                                            PERSONA_EMPRESA_ROL_ID,
                                            OBSERVACION)
            VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
                   Pcl_Request.Pv_UsrCreacion,
                   SYSDATE,
                   Pcl_Request.Pv_IpCreacion,
                   'Inactivo',
                   Ln_IdPersonaEmpresaRolCliente,
                   'Se inactiva el ciclo anteriormente asignado');
          END LOOP;

          -- Inserto CICLO_FACTURACION del PRE CLIENTE AL NUEVO CLIENTE
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC (
                                            ID_PERSONA_EMPRESA_ROL_CARACT,
                                            PERSONA_EMPRESA_ROL_ID,
                                            CARACTERISTICA_ID,
                                            VALOR,
                                            FE_CREACION,
                                            USR_CREACION,
                                            IP_CREACION,
                                            ESTADO)
          VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL,
                 Ln_IdPersonaEmpresaRolCliente,
                 Lc_CaractCiclo.Id_Caracteristica,
                 Lv_Valor,
                 SYSDATE,
                 Pcl_Request.Pv_UsrCreacion,
                 Pcl_Request.Pv_IpCreacion,
                 'Activo');
          -- Inserto historial de creacion de caracteristica de CICLO_FACTURACION en el CLIENTE
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO (
                                            ID_PERSONA_EMPRESA_ROL_HISTO,
                                            USR_CREACION,
                                            FE_CREACION,
                                            IP_CREACION,
                                            ESTADO,
                                            PERSONA_EMPRESA_ROL_ID,
                                            OBSERVACION)
          VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
                 Pcl_Request.Pv_UsrCreacion,
                 SYSDATE,
                 Pcl_Request.Pv_IpCreacion,
                 'Activo',
                 Ln_IdPersonaEmpresaRolCliente,
                 'Se creo Cliente con Ciclo de Facturación: ' || Lv_NombreCiclo);
        END IF;
      END IF;

      -- Se actualiza la persona empresa rol del prospecto a inactivo
      UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
      SET IPER.ESTADO = 'Inactivo'
      WHERE IPER.ID_PERSONA_ROL = Lc_PersonaEmpresaRol.Id_Persona_Rol;

      -- Se actualiza la persona empresa rol referido con el rol cliente
      OPEN C_PERSONA_REFERIDO(Lc_PersonaEmpresaRol.Id_Persona_Rol);
      FETCH C_PERSONA_REFERIDO INTO Lc_PersonaReferido;
      CLOSE C_PERSONA_REFERIDO;      

      IF Lc_PersonaReferido.Id_Persona_Referido IS NOT NULL THEN
        UPDATE DB_COMERCIAL.INFO_PERSONA_REFERIDO IPR
        SET IPR.PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaEmpresaRolCliente
        WHERE IPR.ID_PERSONA_REFERIDO = Lc_PersonaReferido.Id_Persona_Referido;
      END IF;

      -- Se actualiza los contactos de pre-cliente con la persona empresa rol cliente
      FOR i in C_CONTACTOS(Lc_PersonaEmpresaRol.Id_Persona_Rol) LOOP
        UPDATE DB_COMERCIAL.INFO_PERSONA_CONTACTO IPC
        SET IPC.PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaEmpresaRolCliente
        WHERE IPC.ID_PERSONA_CONTACTO = i.Id_Persona_Contacto;
      END LOOP;

      -- Se actualiza los puntos con la persona empresa rol cliente
      Lv_ContribucionSolidaria    := 'N';
      FOR i in C_PUNTOS(Lc_PersonaEmpresaRol.Id_Persona_Rol) LOOP
        UPDATE DB_COMERCIAL.INFO_PUNTO IP
        SET  IP.PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaEmpresaRolCliente,
             IP.USR_ULT_MOD            = Pcl_Request.Pv_UsrCreacion,
             IP.FE_ULT_MOD             = SYSDATE
        WHERE IP.ID_PUNTO = i.id_punto;

        IF Pcl_Request.Pv_PrefijoEmpresa = 'TN' THEN
          OPEN C_PUNTO_ADICIONAL(i.id_punto);
          FETCH C_PUNTO_ADICIONAL INTO Lc_PuntoAdicional;
          CLOSE C_PUNTO_ADICIONAL;

          IF Lc_PuntoAdicional.Id_Punto_Dato_Adicional IS NOT NULL 
            AND Lc_PuntoAdicional.Es_Padre_Facturacion = 'S' AND Lv_ContribucionSolidaria = 'N' 
          THEN
            Lv_RptContribucionSolidaria := RPAD('', 10, ' ');
            IF i.sector_id IS NULL THEN
              Ln_SectorId := 0;
            ELSE
              Ln_SectorId := i.sector_id;
            END IF;
            Lv_RptContribucionSolidaria := DB_FINANCIERO.FNCK_CONSULTS.F_VALIDA_CLIENTE_COMPENSADO(
                                            Ln_IdPersonaEmpresaRolCliente,
                                            Lc_Oficina.Id_Oficina,
                                            Pcl_Request.Pv_EmpresaCod,
                                            Ln_SectorId,
                                            i.id_punto);
            IF Lv_RptContribucionSolidaria IS NOT NULL THEN
              Lv_ContribucionSolidaria := Lv_RptContribucionSolidaria;
            END IF;
          END IF;
        END IF;
      END LOOP;

      -- Compensacion solidaria
      IF Pcl_Request.Pv_PrefijoEmpresa = 'TN' THEN
        OPEN C_CARACTERISTICA_PARAMS('CONTRIBUCION_SOLIDARIA');
        FETCH C_CARACTERISTICA_PARAMS INTO Lc_CaractContrSolidaria;
        CLOSE C_CARACTERISTICA_PARAMS;

        IF Lc_CaractContrSolidaria.Id_Caracteristica IS NULL THEN
          Pv_Mensaje := 'No existe Caracteristica CONTRIBUCION_SOLIDARIA';
          RAISE Le_Errors;
        END IF;

        OPEN C_PER_EMP_ROL_CARACT(Ln_IdPersonaEmpresaRolCliente, Lc_CaractContrSolidaria.Id_Caracteristica, 'Activo');
        FETCH C_PER_EMP_ROL_CARACT INTO Lc_PerEmpRolCarContrSolidaria;
        CLOSE C_PER_EMP_ROL_CARACT;

        OPEN C_MOTIVO_PARAMS('CAMBIO DATOS FACTURACION');
        FETCH C_MOTIVO_PARAMS INTO Lc_MotivoCambioDatosFactu;
        CLOSE C_MOTIVO_PARAMS;

        IF Lc_PerEmpRolCarContrSolidaria.Id_Persona_Empresa_Rol_Caract IS NOT NULL THEN
          UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC
          SET    IPERC.VALOR = Lv_ContribucionSolidaria
          WHERE IPERC.ID_PERSONA_EMPRESA_ROL_CARACT = Lc_PerEmpRolCarContrSolidaria.Id_Persona_Empresa_Rol_Caract;
        ELSE
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC (
                                                ID_PERSONA_EMPRESA_ROL_CARACT,
                                                PERSONA_EMPRESA_ROL_ID,
                                                CARACTERISTICA_ID,
                                                VALOR,
                                                FE_CREACION,
                                                USR_CREACION,
                                                IP_CREACION,
                                                ESTADO)
           VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL,
                  Ln_IdPersonaEmpresaRolCliente,
                  Lc_CaractContrSolidaria.Id_Caracteristica,
                  Lv_ContribucionSolidaria,
                  SYSDATE,
                  Pcl_Request.Pv_UsrCreacion,
                  Pcl_Request.Pv_IpCreacion,
                  'Activo');
        END IF;

        IF Lc_MotivoCambioDatosFactu.Id_Motivo IS NOT NULL THEN
          Ln_MotivoCambioDatosFactuTemp := Lc_MotivoCambioDatosFactu.Id_Motivo;
        END IF;

        IF Lv_ContribucionSolidaria = 'S' THEN
          Lv_ObervacionPerEmpRolHisTemp := 'El cliente se marcó como CONTRIBUCION_SOLIDARIA en Si';
        ELSE
          Lv_ObervacionPerEmpRolHisTemp := 'El cliente se marcó como CONTRIBUCION_SOLIDARIA en No';
        END IF;

        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH (
                                            ID_PERSONA_EMPRESA_ROL_HISTO,
                                            ESTADO,
                                            FE_CREACION,
                                            USR_CREACION,
                                            IP_CREACION,
                                            PERSONA_EMPRESA_ROL_ID,
                                            MOTIVO_ID,
                                            OBSERVACION)
        VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
               'Activo',
               SYSDATE,
               Pcl_Request.Pv_UsrCreacion,
               Pcl_Request.Pv_IpCreacion,
               Ln_IdPersonaEmpresaRolCliente,
               Ln_MotivoCambioDatosFactuTemp,
               Lv_ObervacionPerEmpRolHisTemp);
      END IF;

      -- Actualizo estado activo
      UPDATE DB_COMERCIAL.INFO_CONTRATO ICO
      SET ICO.PERSONA_EMPRESA_ROL_ID      = Ln_IdPersonaEmpresaRolCliente,
          ICO.ESTADO                      = 'Activo',
          ICO.FORMA_PAGO_ID               = Pcl_Request.Pn_FormaPagoId,
          ICO.USR_APROBACION              = Pcl_Request.Pv_UsrCreacion,
          ICO.FE_APROBACION               = SYSDATE,
          ICO.ORIGEN                      = Pcl_Request.Pv_Origen
      WHERE ICO.ID_CONTRATO               = Pcl_Request.Pn_ContratoId;

      -- Se crea historial a persona empresa rol pre cliente
      INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH (
                                            ID_PERSONA_EMPRESA_ROL_HISTO,
                                            PERSONA_EMPRESA_ROL_ID,
                                            ESTADO,
                                            IP_CREACION,
                                            USR_CREACION,
                                            FE_CREACION)
      VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
             Lc_PersonaEmpresaRol.Id_Persona_Rol,
             'Convertido',
             Pcl_Request.Pv_UsrCreacion,
             Pcl_Request.Pv_IpCreacion,
             SYSDATE);

      -- Se crea historial a persona empresa rol cliente
      INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH (
                                            ID_PERSONA_EMPRESA_ROL_HISTO,
                                            PERSONA_EMPRESA_ROL_ID,
                                            ESTADO,
                                            IP_CREACION,
                                            USR_CREACION,
                                            FE_CREACION)
      VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
             Ln_IdPersonaEmpresaRolCliente,
             'Activo',
             Pcl_Request.Pv_UsrCreacion,
             Pcl_Request.Pv_IpCreacion,
             SYSDATE);

      -- Se crea historial de la persona empresa rol cliente con el pin y telefono que se autorizo
      IF Lv_ObservacionHistorial IS NOT NULL THEN
        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH (
                                                ID_PERSONA_EMPRESA_ROL_HISTO,
                                                ESTADO,
                                                FE_CREACION,
                                                IP_CREACION,
                                                PERSONA_EMPRESA_ROL_ID,
                                                USR_CREACION,
                                                OBSERVACION)
        VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
               'Activo',
               SYSDATE,
               Pcl_Request.Pv_IpCreacion,
               Ln_IdPersonaEmpresaRolCliente,
               Lv_UsrTelcosContrato,
               Lv_ObservacionHistorial);
      ELSE
        FOR i IN C_HISTORIAL_PER_EMP_ROL(Lc_PersonaEmpresaRol.Id_Persona_Rol) LOOP
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH (
                                                    ID_PERSONA_EMPRESA_ROL_HISTO,
                                                    ESTADO,
                                                    FE_CREACION,
                                                    IP_CREACION,
                                                    PERSONA_EMPRESA_ROL_ID,
                                                    USR_CREACION,
                                                    OBSERVACION)
          VALUES(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL,
                 'Activo',
                 SYSDATE,
                 Pcl_Request.Pv_IpCreacion,
                 Ln_IdPersonaEmpresaRolCliente,
                 i.usr_creacion,
                 i.observacion);
        END LOOP;
      END IF;

      IF Pcl_Request.Pv_PrefijoEmpresa = 'MD' AND Lc_Servicio.Id_Servicio IS NOT NULL THEN
        FOR i IN C_DET_PARAMETRO_VALOR1('VALIDA_PROD_ADICIONAL', 'PROD_ADIC_PLANIFICA', Pcl_Request.Pv_EmpresaCod) LOOP
          OPEN C_COUNT_SERVICIO_OT_ADICIONAL(Lc_Servicio.Id_Servicio, i.valor2);
          FETCH C_COUNT_SERVICIO_OT_ADICIONAL INTO Ln_TotalServicioOtAdic;
          CLOSE C_COUNT_SERVICIO_OT_ADICIONAL;
          IF Ln_TotalServicioOtAdic > 0 THEN
           Pcl_GenerarOtAdicional := DB_COMERCIAL.DATOS_GENERAR_OT_TYPE(
                                        Lc_Servicio.Punto_Id,
                                        i.valor2,
                                        Lc_Servicio.Id_Servicio,
                                        i.valor3,
                                        i.valor4,
                                        Pcl_Request.Pv_UsrCreacion,
                                        Pcl_Request.Pv_IpCreacion,
                                        Pcl_Request.Pv_EmpresaCod,
                                        Lc_PersonaEmpresaRol.Oficina_Id,
                                        '',
                                        '',
                                        '');
            P_GENERAR_OT_SERVADIC(Pcl_GenerarOtAdicional, Pv_Mensaje, Pv_Status);
            IF Pv_Status != 'OK' THEN
              RAISE Le_Errors;
            END IF;
          END IF;
        END LOOP;
      END IF;

      IF Lb_HayServicio THEN
         DBMS_OUTPUT.PUT_LINE('Cupos Moviles -> getCuposMobil');
      END IF;

      Pv_Mensaje := 'Proceso realizado con éxito';
      Pv_Status  := 'OK';
    EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status     := 'ERROR';
      ROLLBACK;
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Status  := 'ERROR';
      Pv_Mensaje := 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO', 'DB_COMERCIAL.P_APROBAR_CONTRATO', Pv_Mensaje, 'telcos', SYSDATE, '127.0.0.1');
    END P_APROBAR_CONTRATO;

    PROCEDURE P_AUTORIZAR_CONTRATO(Pcl_Request     IN  VARCHAR2,
                                   Pv_Mensaje      OUT VARCHAR2,
                                   Pv_Status       OUT VARCHAR2,
                                   Pn_SeAutorizo   OUT NUMBER)
    IS
    CURSOR C_CONTRATO_PARAMS(Cn_ContratoId NUMBER)
    IS
      SELECT IC.*
      FROM DB_COMERCIAL.INFO_CONTRATO IC
      WHERE IC.ID_CONTRATO = Cn_ContratoId;

    CURSOR C_PERSONA_EMP_ROL_PARAMS(Cn_PersonaEmpresaRolId NUMBER)
    IS
      SELECT IC.*
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IC
      WHERE IC.ID_PERSONA_ROL = Cn_PersonaEmpresaRolId;

    CURSOR C_PUNTO_PARAMS(Cn_PuntoId NUMBER)
    IS
      SELECT IC.*
      FROM DB_COMERCIAL.INFO_PUNTO IC
      WHERE IC.ID_PUNTO = Cn_PuntoId;

    CURSOR C_GET_SERVICIOS(Cn_PersonaEmpresaRolId  INTEGER,
                           Cv_Estado               VARCHAR2,
                           Cv_NombreParametro      VARCHAR2,
                           Cn_EmpresaId            INTEGER,
                           Cv_NumeroAdendum        VARCHAR2)
    IS
      SELECT
        ISE.ID_SERVICIO,ISE.PLAN_ID
      FROM
          DB_COMERCIAL.INFO_SERVICIO ISE
          INNER JOIN DB_COMERCIAL.INFO_PUNTO IPO ON IPO.ID_PUNTO=ISE.PUNTO_ID
          INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL = IPO.PERSONA_EMPRESA_ROL_ID
          WHERE IPO.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRolId 
          AND EXISTS (
            SELECT 1
            FROM DB_COMERCIAL.INFO_ADENDUM IAD
            WHERE IAD.SERVICIO_ID = ISE.ID_SERVICIO AND
            (CASE WHEN Cv_NumeroAdendum IS NOT NULL THEN IAD.NUMERO ELSE '1' END) = (CASE WHEN Cv_NumeroAdendum IS NOT NULL THEN Cv_NumeroAdendum ELSE '1' END)
          )
          AND ISE.ESTADO     IN (
                           SELECT
                                    APD.VALOR1
                                FROM
                                    DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APD.PARAMETRO_ID=APC.ID_PARAMETRO
                                    WHERE APC.NOMBRE_PARAMETRO  = Cv_NombreParametro 
                                    AND APD.ESTADO              = Cv_Estado
                                    AND APD.EMPRESA_COD         = Cn_EmpresaId
                                    AND APC.ESTADO              = Cv_Estado)
      AND (ISE.ES_VENTA   <> 'E' OR ISE.ES_VENTA IS NULL);

    CURSOR C_DET_PARAMETRO_PARAMS(Cv_NombreParametro VARCHAR2,
                                  Cv_Descripcion VARCHAR2,
                                  Cv_CodEmpresa VARCHAR2)
    IS
    SELECT APD.*
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
    AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND APD.DESCRIPCION = Cv_Descripcion
    AND APD.EMPRESA_COD = Cv_CodEmpresa
    AND APC.ESTADO = 'Activo'
    AND APD.ESTADO = 'Activo';

    CURSOR C_LIST_DET_PARAMETRO(Cv_NombreParametro VARCHAR2)
    IS
    SELECT APD.*
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
    AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND APC.ESTADO = 'Activo'
    AND APD.ESTADO = 'Activo';

    CURSOR C_GET_PLANES_CONTRATO(Cn_IdPlan             INTEGER,
                                 Cv_Estado             VARCHAR2,
                                 Cv_NombreParametro    VARCHAR2)
    IS   
    SELECT  
        DET.PRODUCTO_ID,NOMBRE_TECNICO
    FROM DB_COMERCIAL.INFO_PLAN_DET DET
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APRO ON APRO.ID_PRODUCTO = DET.PRODUCTO_ID
        WHERE DET.PLAN_ID = Cn_IdPlan
        AND DET.ESTADO IN (
            SELECT
                APD.VALOR1
            FROM
                DB_GENERAL.ADMI_PARAMETRO_CAB APC
                INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APD.PARAMETRO_ID=APC.ID_PARAMETRO
                WHERE APC.NOMBRE_PARAMETRO  = Cv_NombreParametro 
                AND APD.ESTADO              = Cv_Estado
                AND APC.ESTADO              = Cv_Estado
        );

    CURSOR C_GET_SERVICIO_ADENDUM (Cn_IdServicio INTEGER,
                                   Cv_Tipo       VARCHAR2,
                                   Cv_Numero     VARCHAR2)
    IS
    SELECT
        SERVICIO_ID
    FROM
        DB_COMERCIAL.INFO_ADENDUM
    WHERE 
        SERVICIO_ID = Cn_IdServicio AND
        CASE WHEN Cv_Tipo <> 'C' THEN TIPO ELSE '1' END  = CASE WHEN Cv_Tipo <> 'C' THEN Cv_Tipo ELSE '1' END   AND
        (NUMERO = CASE WHEN Cv_Tipo <> 'C' THEN Cv_Numero ELSE NULL END
        OR CONTRATO_ID = CASE WHEN Cv_Tipo = 'C' THEN Cv_Numero ELSE NULL END)
        GROUP BY SERVICIO_ID;

    CURSOR C_ADENDUM_PARAMS(Cn_ContratoId NUMBER, Cv_Tipo VARCHAR2)
    IS
      SELECT IC.*
      FROM DB_COMERCIAL.INFO_ADENDUM IC
      WHERE IC.CONTRATO_ID = Cn_ContratoId
      AND IC.TIPO = Cv_Tipo;

    CURSOR C_GET_ADENDUM_NUMERO (Cv_Tipo      VARCHAR2,
					         Cv_Numero    VARCHAR2)
    IS
    SELECT 
        IAD.ID_ADENDUM
    FROM DB_COMERCIAL.INFO_ADENDUM IAD
    WHERE IAD.TIPO    = Cv_Tipo AND
		  IAD.NUMERO  = Cv_Numero;

    CURSOR C_GET_CARACTERISTICA (Cv_Descripcion VARCHAR2, Cv_Tipo VARCHAR2, Cv_Estado VARCHAR2)
    IS 
    SELECT ID_CARACTERISTICA
    FROM DB_COMERCIAL.ADMI_CARACTERISTICA
    WHERE DESCRIPCION_CARACTERISTICA = Cv_Descripcion
      AND TIPO = Cv_Tipo
      AND ESTADO = Cv_Estado;

    

    CURSOR C_EXISTE_CARACT_SERV(Ln_ServicioId NUMBER, Ln_CaracteristicaId NUMBER, Lv_Estado VARCHAR2)
    IS
      SELECT NVL(count(ID_SERVICIO_CARACTERISTICA), 0)
      FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
      WHERE SERVICIO_ID = Ln_ServicioId
        AND CARACTERISTICA_ID = Ln_CaracteristicaId
        and ESTADO = Lv_Estado;

     -- Types	  
    TYPE Pcl_AdendumsNum IS TABLE OF C_GET_ADENDUM_NUMERO%ROWTYPE;
    Pcl_ArrayAdendumsNum Pcl_AdendumsNum;

    TYPE Lcl_TypeUltimMillaPorServ IS RECORD(ID_TIPO_MEDIO     NUMBER,
                                             CODIGO_TIPO_MEDIO VARCHAR2(1000));

    TYPE Pcl_Planes IS TABLE OF C_GET_PLANES_CONTRATO%ROWTYPE;
    Pcl_ArrayPLanes Pcl_Planes;

    TYPE Pcl_ServicioAdendum IS TABLE OF C_GET_SERVICIO_ADENDUM%ROWTYPE;
    Pcl_ArrayAdendum Pcl_ServicioAdendum;

    Pcl_ArrayServEncontrado Pcl_ServEncontrado_Type := Pcl_ServEncontrado_Type();

    Lv_IpCreacion              VARCHAR2(1000);
    Lv_CodEmpresa              VARCHAR2(1000);
    Lv_PrefijoEmpresa          VARCHAR2(1000);
    Lv_UsrCreacion             VARCHAR2(1000);
    Lv_Origen                  VARCHAR2(1000);
    Lv_Tipo                    VARCHAR2(1000);
    Lv_ObservacionHistorial    VARCHAR2(1000);
    Ln_PersonaEmpresaRolId     NUMBER;
    Ln_ContratoId              NUMBER;
    Ln_PuntoId                 NUMBER;
    Lv_NumeroAdendum           VARCHAR2(1000);
    Lc_Contrato                C_CONTRATO_PARAMS%rowtype;
    Lc_PersonaEmpRol           C_PERSONA_EMP_ROL_PARAMS%rowtype;
    Lc_Punto                   C_PUNTO_PARAMS%rowtype;
    TYPE Pcl_ServicioEstado    IS TABLE OF C_GET_SERVICIOS%ROWTYPE;
    Pcl_ArrayServicio          Pcl_ServicioEstado;
    Pcl_ArrayServicioPromo     Pcl_ServicioEstado;
    Pcl_UltimaMillaServ        SYS_REFCURSOR;
    Pv_ReqUltimaMillaServ      CLOB;
    Ln_ServicioFactible        NUMBER;  
    Lv_EstadoActivo            VARCHAR2(400) := 'Activo'; 
    Lv_NombreParamContrato     VARCHAR2(400) := 'ESTADO_PLAN_CONTRATO';
    Lv_PromoInst               VARCHAR2(400) := 'PROM_INS';
    Lv_NombreParamEstaC        VARCHAR2(400) := 'ESTADO_SERVICIOS_CONTRATO_ADENDUM';
    Lv_NumContratoAdendum      VARCHAR2(400);
    Lv_EstadoAdendum           VARCHAR2(400) := 'Pendiente';
    Ln_Descuento               INTEGER;
    Ln_CantPeriodo             INTEGER;
    Lv_Observacion             VARCHAR2(400);
    Pcl_RechazarContrato       CLOB;
    Lv_NombreMotivoRechazo     VARCHAR2(4000);
    Pcl_RechazarError          SYS_REFCURSOR;
    Ln_Id_Tipo_Medio           NUMBER;
    Lv_Codigo_Tipo_Medio       VARCHAR2(1000);
    Pcl_AprobarAdendum         DB_COMERCIAL.DATOS_APROBAR_ADENDUM_TYPE;
    Pcl_AprobarContrato        DB_COMERCIAL.DATOS_APROBAR_CONTRATO_TYPE;
    Pcl_SetearDatosContrato    DB_COMERCIAL.DATOS_CONTRATO_TYPE;
    Lv_EstadoContrato          VARCHAR2(400);
    Lv_MensajeRechazo          VARCHAR2(4000);
    Le_Errors                  EXCEPTION;
    Le_ErrorRechazarContrato   EXCEPTION;
    Ln_IteradorI               INTEGER;
    Ln_IteradorK               INTEGER;
    Ln_IteradorJ               INTEGER;
    Ln_ServicioPlan            NUMBER := 0;  
    Ln_Existe                  NUMBER := 0;
    Ln_CaracteristicaId        NUMBER := 0;
  BEGIN
    -- RETORNO LAS VARIABLES DEL REQUEST
    APEX_JSON.PARSE(Pcl_Request);
    Lv_IpCreacion           := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_CodEmpresa           := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Lv_PrefijoEmpresa       := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
    Lv_UsrCreacion          := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_Origen               := APEX_JSON.get_varchar2(p_path => 'origen');
    Lv_Tipo                 := APEX_JSON.get_varchar2(p_path => 'tipo');
    Lv_ObservacionHistorial := APEX_JSON.get_varchar2(p_path => 'observacionHistorial');
    Ln_PersonaEmpresaRolId  := APEX_JSON.get_number(p_path => 'personaEmpresaRolId');
    Ln_ContratoId           := APEX_JSON.get_number(p_path => 'contratoId');
    Ln_PuntoId              := APEX_JSON.get_number(p_path => 'puntoId');
    Lv_NumeroAdendum        := APEX_JSON.get_varchar2(p_path => 'numeroAdendum');
    
    Ln_Descuento            :=0;
    -- VALIDACIONES
    IF Lv_IpCreacion IS NULL THEN
      Pv_Mensaje := 'El parámetro ipCreacion esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_CodEmpresa IS NULL THEN
      Pv_Mensaje := 'El parámetro codEmpresa esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_PrefijoEmpresa IS NULL THEN
      Pv_Mensaje := 'El parámetro prefijoEmpresa esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_UsrCreacion IS NULL THEN
      Pv_Mensaje := 'El parámetro usrCreacion esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Origen IS NULL THEN
      Pv_Mensaje := 'El parámetro origen esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Tipo IS NULL THEN
      Pv_Mensaje := 'El parámetro tipo esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Lv_Tipo != 'C' AND Lv_NumeroAdendum  IS NULL THEN
      Pv_Mensaje := 'El parámetro numeroAdendum esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Ln_PersonaEmpresaRolId IS NULL THEN
      Pv_Mensaje := 'El parámetro personaEmpresaRolId esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Ln_ContratoId IS NULL THEN
      Pv_Mensaje := 'El parámetro contratoId esta vacío';
      RAISE Le_Errors;
    END IF;
    IF Ln_PuntoId IS NULL THEN
      Pv_Mensaje := 'El parámetro puntoId esta vacío';
      RAISE Le_Errors;
    END IF;

    OPEN C_CONTRATO_PARAMS(Ln_ContratoId);
    FETCH C_CONTRATO_PARAMS INTO Lc_Contrato;
    CLOSE C_CONTRATO_PARAMS;
    IF Lc_Contrato.Estado = 'Activo' AND Lv_Tipo = 'C' 
    THEN
      Pv_Mensaje := 'El contrato ya se encuentra Activo';
      RAISE Le_Errors;
    END IF;
    IF Lc_Contrato.Estado != 'PorAutorizar' AND Lv_Tipo = 'C' 
    THEN
      Pv_Mensaje := 'El contrato no se encuentra en estado PorAutorizar';
      RAISE Le_Errors;
    END IF;

    OPEN C_PERSONA_EMP_ROL_PARAMS(Ln_PersonaEmpresaRolId);
    FETCH C_PERSONA_EMP_ROL_PARAMS INTO Lc_PersonaEmpRol;
    CLOSE C_PERSONA_EMP_ROL_PARAMS;
    IF Lc_PersonaEmpRol.Id_Persona_Rol IS NULL THEN
      Pv_Mensaje := 'El personaEmpresaRolId no existe';
      RAISE Le_Errors;
    END IF;

    OPEN C_PUNTO_PARAMS(Ln_PuntoId);
    FETCH C_PUNTO_PARAMS INTO Lc_Punto;
    CLOSE C_PUNTO_PARAMS;
    IF Lc_Punto.Id_Punto IS NULL THEN
      Pv_Mensaje := 'El puntoId no existe';
      RAISE Le_Errors;
    END IF;

    IF Lv_ObservacionHistorial IS NULL THEN
      Lv_ObservacionHistorial := '';
    END IF;

    OPEN C_GET_SERVICIOS(Ln_PersonaEmpresaRolId, Lv_EstadoActivo,Lv_NombreParamEstaC,0,Lv_NumeroAdendum);
    FETCH C_GET_SERVICIOS BULK COLLECT INTO Pcl_ArrayServicio LIMIT 5000;
    CLOSE C_GET_SERVICIOS;

    IF Pcl_ArrayServicio.EXISTS(1)
    THEN
        Ln_IteradorI := Pcl_ArrayServicio.FIRST;
        WHILE (Ln_IteradorI IS NOT NULL)
        LOOP
          IF Pcl_ArrayServicio(Ln_IteradorI).PLAN_ID IS NOT NULL THEN
                Ln_ServicioPlan := Pcl_ArrayServicio(Ln_IteradorI).ID_SERVICIO;
                --Obtener planes permitidos
                OPEN C_GET_PLANES_CONTRATO(Pcl_ArrayServicio(Ln_IteradorI).PLAN_ID,Lv_EstadoActivo,Lv_NombreParamContrato);
                FETCH C_GET_PLANES_CONTRATO BULK COLLECT INTO Pcl_ArrayPLanes LIMIT 5000;
                CLOSE C_GET_PLANES_CONTRATO;
    
                Ln_IteradorJ := Pcl_ArrayPLanes.FIRST;
                WHILE (Ln_IteradorJ IS NOT NULL)
                LOOP
                    IF Pcl_ArrayPLanes(Ln_IteradorJ).NOMBRE_TECNICO IS NOT NULL AND Pcl_ArrayPLanes(Ln_IteradorJ).NOMBRE_TECNICO = 'INTERNET'
                    THEN
                        DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_MAPEO_PROM_TENTATIVA(Ln_PuntoId,
                                                                                  Pcl_ArrayServicio(Ln_IteradorI).ID_SERVICIO,
                                                                                  Lv_PromoInst,
                                                                                  Lv_CodEmpresa,
                                                                                  Ln_Descuento, 
                                                                                  Ln_CantPeriodo,
                                                                                  Lv_Observacion);
                    END IF;
                    Ln_IteradorJ := Pcl_ArrayPLanes.NEXT(Ln_IteradorJ);  
                END LOOP;            
            END IF;
            Ln_IteradorI := Pcl_ArrayServicio.NEXT(Ln_IteradorI);
        END LOOP;
  --  ELSE    
   --     Pv_Mensaje := 'No cuenta con servicios Factibles.';
   --     RAISE Le_Errors;
    END IF;
    IF Ln_Descuento IS NULL
    THEN
        Lv_NombreMotivoRechazo := 'Contrato en Estado Rechazado';
        Lv_MensajeRechazo := 'Se rechazo contrato por error al obtener descuento';
        RAISE Le_ErrorRechazarContrato;
    ELSIF Ln_Descuento = 100 OR Lv_Tipo = 'AS'
    THEN
        OPEN C_GET_SERVICIOS(Ln_PersonaEmpresaRolId, Lv_EstadoActivo,Lv_NombreParamEstaC,Lv_CodEmpresa,Lv_NumeroAdendum);
        FETCH C_GET_SERVICIOS BULK COLLECT INTO Pcl_ArrayServicioPromo LIMIT 5000;
        CLOSE C_GET_SERVICIOS;

        IF Pcl_ArrayServicioPromo.EXISTS(1)
        THEN
            Ln_IteradorI := Pcl_ArrayServicioPromo.FIRST;
            WHILE (Ln_IteradorI IS NOT NULL)
            LOOP
                IF Lv_Tipo = 'C' 
                THEN
                    Lv_NumContratoAdendum := Ln_ContratoId;
                ELSE  
                    Lv_NumContratoAdendum := Lv_NumeroAdendum;
                END IF;

                OPEN C_GET_SERVICIO_ADENDUM(Pcl_ArrayServicioPromo(Ln_IteradorI).ID_SERVICIO, Lv_Tipo, Lv_NumContratoAdendum);
                FETCH C_GET_SERVICIO_ADENDUM BULK COLLECT INTO Pcl_ArrayAdendum LIMIT 5000;
                CLOSE C_GET_SERVICIO_ADENDUM;

                IF Pcl_ArrayAdendum.EXISTS(1)
                THEN
                    Ln_IteradorK := Pcl_ArrayAdendum.FIRST;
                    WHILE (Ln_IteradorK IS NOT NULL)
                    LOOP
                        Pcl_ArrayServEncontrado.extend;
                        Pcl_ArrayServEncontrado(Ln_IteradorK) := Pcl_ArrayAdendum(Ln_IteradorK).SERVICIO_ID;
                        Ln_IteradorK := Pcl_ArrayAdendum.NEXT(Ln_IteradorK);
                    END LOOP;
                END IF;
              Ln_IteradorI := Pcl_ArrayServicio.NEXT(Ln_IteradorI);
            END LOOP;
        END IF;
    END IF;

    IF Lv_Tipo = 'C' THEN
      -- Autorizar contrato
          Lv_ObservacionHistorial := 'El contrato: ' || Lc_Contrato.Numero_Contrato || ' ' || Lv_ObservacionHistorial;
          IF Pcl_ArrayServicio.EXISTS(1) THEN
            Ln_ServicioFactible := Pcl_ArrayServicio(1).ID_SERVICIO;
          END IF;
          IF Ln_ServicioFactible IS NULL THEN
            Pv_Mensaje := 'Cliente no cuenta con un servicio en estado Factible';
            RAISE Le_Errors;
          END IF;
          -- Obtengo la ultima milla Lcl_TypeUltimMillaPorServ
          Pv_ReqUltimaMillaServ :='{
                                   "puntoId": '||Ln_PuntoId||',
                                   "estado": "Factible"
                                  }';
          DB_COMERCIAL.CMKG_CONSULTA.P_ULTIMA_MILLA_POR_PUNTO(Pv_ReqUltimaMillaServ, Pv_Status, Pv_Mensaje, Pcl_UltimaMillaServ);
          IF Pv_Status != 'OK' THEN
            RAISE Le_Errors;
          END IF;

          LOOP 
          FETCH Pcl_UltimaMillaServ INTO Ln_Id_Tipo_Medio, Lv_Codigo_Tipo_Medio;
          EXIT WHEN Pcl_UltimaMillaServ%notfound;
          END LOOP;
          CLOSE Pcl_UltimaMillaServ;

          IF Ln_Id_Tipo_Medio IS NULL AND Lv_Codigo_Tipo_Medio IS NULL THEN
            Pv_Mensaje := 'Cliente no cuenta con ultima milla';
            RAISE Le_Errors;
          END IF;

          IF Ln_Descuento = 100 THEN
            Pcl_AprobarContrato := DB_COMERCIAL.DATOS_APROBAR_CONTRATO_TYPE(
                                          Pcl_ArrayServEncontrado,
                                          Lv_UsrCreacion,
                                          Lv_IpCreacion,
                                          Lv_PrefijoEmpresa,
                                          Lv_Origen,
                                          Lv_ObservacionHistorial,
                                          Lv_CodEmpresa,
                                          Ln_PersonaEmpresaRolId,
                                          Ln_ContratoId,
                                          Lc_Contrato.Forma_Pago_Id);
            P_APROBAR_CONTRATO(Pcl_AprobarContrato, Pv_Mensaje, Pv_Status);
            IF Pv_Status != 'OK' THEN
              RAISE Le_Errors;
            END IF;
            Lv_EstadoContrato := 'Activo';
          ELSE
            Pcl_SetearDatosContrato := DB_COMERCIAL.DATOS_CONTRATO_TYPE(Ln_ContratoId, Lv_ObservacionHistorial, Lv_IpCreacion, Lv_Origen, Lv_UsrCreacion);
            P_SETEAR_DATOS_CONTRATO(Pcl_SetearDatosContrato, Pv_Mensaje, Pv_Status);
            IF Pv_Status != 'OK' THEN
              RAISE Le_Errors;
            END IF;
            Lv_EstadoContrato := 'Pendiente';
          END IF;

      -- Actualizar adendum y contrato
          FOR i IN C_ADENDUM_PARAMS(Ln_ContratoId, Lv_Tipo)
          LOOP 
              UPDATE
                DB_COMERCIAL.INFO_ADENDUM IC
              SET IC.ESTADO = Lv_EstadoContrato
              WHERE
                IC.ID_ADENDUM = i.Id_Adendum;
          END LOOP;

          UPDATE
            DB_COMERCIAL.INFO_CONTRATO IC
          SET IC.ESTADO = Lv_EstadoContrato
          WHERE
            IC.ID_CONTRATO = Ln_ContratoId;
    
          Pv_Mensaje := 'El contrato fue autorizado con exito';
    ELSE 
      -- Autorizar adendum
          Lv_ObservacionHistorial := 'El contrato: ' || Lc_Contrato.Numero_Contrato || ' ' || Lv_ObservacionHistorial;
    
            IF Ln_Descuento = 100 OR Lv_Tipo = 'AS'
            THEN
                Pcl_AprobarAdendum := DB_COMERCIAL.DATOS_APROBAR_ADENDUM_TYPE(
                                            Pcl_ArrayServEncontrado,
                                            Lv_UsrCreacion,
                                            Lv_IpCreacion,
                                            Lv_PrefijoEmpresa,
                                            Lv_Origen,
                                            Lv_ObservacionHistorial,
                                            Lv_CodEmpresa,
                                            Ln_PersonaEmpresaRolId);                
    
                P_APROBAR_ADENDUM(Pcl_AprobarAdendum, Pv_Mensaje, Pv_Status);
    
                IF Pv_Status != 'OK' 
                THEN
                    RAISE Le_Errors;
                ELSE
                    Lv_EstadoAdendum := Lv_EstadoActivo;
                END IF;
            ELSE
                Ln_CaracteristicaId := 0;
                OPEN C_GET_CARACTERISTICA('PROM_INSTALACION', 'COMERCIAL', 'Activo');
                FETCH C_GET_CARACTERISTICA INTO Ln_CaracteristicaId;
                CLOSE C_GET_CARACTERISTICA;

                OPEN C_GET_ADENDUM_NUMERO (Lv_Tipo,Lv_NumeroAdendum);
                FETCH C_GET_ADENDUM_NUMERO BULK COLLECT INTO Pcl_ArrayAdendumsNum LIMIT 5000;
                CLOSE C_GET_ADENDUM_NUMERO;
                OPEN C_EXISTE_CARACT_SERV(Ln_ServicioPlan, Ln_CaracteristicaId, 'Activo');
                FETCH C_EXISTE_CARACT_SERV INTO Ln_Existe;
                CLOSE C_EXISTE_CARACT_SERV;
                IF Ln_Existe = 0
                THEN
                  INSERT INTO DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
                    (
                      ID_SERVICIO_CARACTERISTICA,
                      SERVICIO_ID              ,
                      CARACTERISTICA_ID        ,
                      VALOR                    ,
                      ESTADO                   ,
                      OBSERVACION              ,
                      USR_CREACION             ,
                      IP_CREACION              ,
                      FE_CREACION
                    )
                    VALUES
                    (
                      SEQ_INFO_SERVICIO_CARAC.NEXTVAL,
                      Ln_ServicioPlan,
                      Ln_CaracteristicaId,
                      '',
                      'Activo',
                      'Se crea característica para facturación por punto adicional',
                      Lv_UsrCreacion,
                      Lv_IpCreacion,
                      SYSDATE
                    );                
                END IF;
                  
            END IF; 

            OPEN C_GET_ADENDUM_NUMERO (Lv_Tipo,Lv_NumeroAdendum);
            FETCH C_GET_ADENDUM_NUMERO BULK COLLECT INTO Pcl_ArrayAdendumsNum LIMIT 5000;
            CLOSE C_GET_ADENDUM_NUMERO;

            IF Pcl_ArrayAdendumsNum.EXISTS(1)
            THEN
                Ln_IteradorJ := Pcl_ArrayAdendumsNum.FIRST;
                WHILE (Ln_IteradorJ IS NOT NULL)
                LOOP
                    UPDATE DB_COMERCIAL.INFO_ADENDUM IA
                        SET IA.ESTADO      = Lv_EstadoAdendum
                    WHERE IA.ID_ADENDUM = Pcl_ArrayAdendumsNum(Ln_IteradorJ).ID_ADENDUM;
                  Ln_IteradorJ := Pcl_ArrayAdendumsNum.NEXT(Ln_IteradorJ); 
                END LOOP;
            ELSE
                Pv_Mensaje := 'No Existe Adendum para Autorizar';
                RAISE Le_Errors;
            END IF;

            Pv_Mensaje := 'El adendum fue autorizado con exito';
    END IF;

    Pv_Status     := 'OK';
    Pn_SeAutorizo := 1;
    COMMIT;
    EXCEPTION
    WHEN Le_Errors THEN
        ROLLBACK;
        Pv_Status     := 'ERROR';
        Pn_SeAutorizo := 0;
    WHEN Le_ErrorRechazarContrato THEN
        ROLLBACK;
        Pcl_RechazarContrato   :='{
                                    "usrCreacion": "'||Lv_UsrCreacion||'",
                                    "ipCreacion": "'||Lv_IpCreacion||'",
                                        "contrato": {
                                        "idContrato": "'||Ln_ContratoId||'",
                                        "motivo": "'||Lv_NombreMotivoRechazo||'"
                                        }
                                  }';

        P_RECHAZAR_CONTRATO_ERROR(Pcl_RechazarContrato,
                                  Pv_Mensaje,
                                  Pv_Status,
                                  Pcl_RechazarError);
        IF Pv_Status = 'OK' THEN
          Pv_Mensaje := Lv_MensajeRechazo;
        END IF;
        Pv_Status     := 'ERROR';
        Pn_SeAutorizo := 0;
    WHEN OTHERS THEN
        ROLLBACK;
        Pv_Status     := 'ERROR';
        Pn_SeAutorizo := 0;
        Pv_Mensaje    := 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                           'DB_COMERCIAL.P_AUTORIZAR_CONTRATO',
                                            Pv_Mensaje,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');
  END P_AUTORIZAR_CONTRATO;

  PROCEDURE P_GENERAR_OT_SERVADIC(
                                  Pcl_Request       IN  DB_COMERCIAL.DATOS_GENERAR_OT_TYPE,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2)
                                  IS
    CURSOR C_GET_SERVICIO(Cn_IdServicio INTEGER)
    IS
    SELECT 
        ISE.ID_SERVICIO,ISE.PUNTO_FACTURACION_ID,ISE.USR_VENDEDOR
    FROM
        DB_COMERCIAL.INFO_SERVICIO ISE
        WHERE ISE.ID_SERVICIO = Cn_IdServicio;

    CURSOR C_GET_PRODUCTO(Cn_Producto INTEGER)
    IS
    SELECT 
        APO.ID_PRODUCTO,APO.DESCRIPCION_PRODUCTO
    FROM
        DB_COMERCIAL.ADMI_PRODUCTO APO
        WHERE APO.ID_PRODUCTO = Cn_Producto;

    CURSOR C_GET_ORDEN_TRABAJO( Cn_IdPunto      INTEGER,
                                Cv_EstadoActiva VARCHAR2,
                                Cn_Producto     INTEGER)
    IS
    SELECT 
        IOT.ID_ORDEN_TRABAJO
    FROM
        DB_COMERCIAL.INFO_ORDEN_TRABAJO IOT
        WHERE IOT.PUNTO_ID      = Cn_IdPunto AND
              IOT.ESTADO        = Cv_EstadoActiva AND
              IOT.OBSERVACION   = Cn_Producto;

    CURSOR C_GET_PUNTO(Cn_Punto INTEGER)
    IS
    SELECT 
        IPU.ID_PUNTO
    FROM
        DB_COMERCIAL.INFO_PUNTO IPU
        WHERE IPU.ID_PUNTO = Cn_Punto;

    CURSOR C_GET_SERVICIO_TEC(Cn_IdServicio INTEGER)
    IS
    SELECT 
        ISET.ULTIMA_MILLA_ID
    FROM
        DB_COMERCIAL.INFO_SERVICIO_TECNICO ISET
        WHERE ISET.SERVICIO_ID = Cn_IdServicio;

    CURSOR C_GET_SERV_PROD_CARACT(Cn_IdProducto         INTEGER,
                                  Cv_NomCaracteristica  VARCHAR2,
                                  Cn_Estado             VARCHAR2)
    IS
    SELECT 
        APC.ID_PRODUCTO_CARACTERISITICA
    FROM
        DB_COMERCIAL.ADMI_CARACTERISTICA ACA
        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC 
            ON APC.CARACTERISTICA_ID = ACA.ID_CARACTERISTICA
        WHERE APC.ESTADO                        = Cn_Estado AND
              ACA.DESCRIPCION_CARACTERISTICA    = Cv_NomCaracteristica AND
              APC.PRODUCTO_ID                   = Cn_IdProducto;

    Ln_IdPunto                INTEGER;
    Ln_Producto               VARCHAR2(400);
    Ln_IdServicio             INTEGER;
    Lv_Observacion            VARCHAR2(400);
    Lv_Caracteristica         VARCHAR2(400);
    Lv_UsrCreacion            VARCHAR2(400);
    Lv_IpCreacion             VARCHAR2(400);
    Ln_EmpresaCod             INTEGER;
    Ln_IdOficina              INTEGER;
    Lv_EstadoServicio         VARCHAR2(400);
    Ln_IdSolicitud            VARCHAR2(400);
    Lv_NuevoServicio          VARCHAR2(400);

    Ln_IdUltimaMilla          INTEGER;
    Lv_EstadoActiva           VARCHAR2(400) := 'Activa';
    Lv_EstadoActivo           VARCHAR2(400) := 'Activo';
    Ln_IdOrdenTrabajo         INTEGER;
    Ln_IdPuntoFacturacion     INTEGER;
    Lv_Vendedor               VARCHAR2(400);
    Lv_DescripcionProducto    VARCHAR2(4000);

    Ln_IdServicioNuevo        INTEGER;
    Lv_IdProductoCaract       INTEGER;
    Lv_AccionServicio         VARCHAR2(400);
    Ln_ValorCaract            VARCHAR2(400) := 'si';

    BEGIN

        Ln_IdPunto                := Pcl_Request.Pn_IdPunto;
        Ln_Producto               := Pcl_Request.Pn_Producto;
        Ln_IdServicio             := Pcl_Request.Pn_IdServicio;
        Lv_Observacion            := Pcl_Request.Pv_Observacion;
        Lv_Caracteristica         := Pcl_Request.Pv_Caracteristica;
        Lv_UsrCreacion            := Pcl_Request.Pv_UsrCreacion;
        Lv_IpCreacion             := Pcl_Request.Pv_IpCreacion;
        Ln_EmpresaCod             := Pcl_Request.Pn_EmpresaCod;
        Ln_IdOficina              := Pcl_Request.Pn_IdOficina;
        Lv_EstadoServicio         := Pcl_Request.Pv_EstadoServicio;
        Ln_IdSolicitud            := Pcl_Request.Pv_Solicitud;
        Lv_NuevoServicio          := Pcl_Request.Pv_NuevoServicio;

        IF Lv_NuevoServicio IS NOT NULL AND Lv_NuevoServicio != 'SI'
        THEN
            RAISE_APPLICATION_ERROR(-20101, 'Flujo incorrecto para OT en proceso contrato digital');
        ELSE
            OPEN C_GET_SERVICIO(Ln_IdServicio);
            FETCH C_GET_SERVICIO INTO Ln_IdServicio,Ln_IdPuntoFacturacion,Lv_Vendedor;
            CLOSE C_GET_SERVICIO;

            OPEN C_GET_PRODUCTO(Ln_Producto);
            FETCH C_GET_PRODUCTO INTO Ln_Producto,Lv_DescripcionProducto;
            CLOSE C_GET_PRODUCTO;

            OPEN C_GET_PUNTO(Ln_IdPunto);
            FETCH C_GET_PUNTO INTO Ln_IdPunto;
            CLOSE C_GET_PUNTO;

            OPEN C_GET_ORDEN_TRABAJO(Ln_IdPunto,Lv_EstadoActiva,Ln_Producto);
            FETCH C_GET_ORDEN_TRABAJO INTO Ln_IdOrdenTrabajo;
            CLOSE C_GET_ORDEN_TRABAJO;

            IF Ln_IdServicio IS NOT NULL AND Ln_Producto IS NOT NULL
            THEN

                OPEN C_GET_SERVICIO_TEC(Ln_IdServicio);
                FETCH C_GET_SERVICIO_TEC INTO Ln_IdUltimaMilla;
                CLOSE C_GET_SERVICIO_TEC;

                INSERT INTO DB_COMERCIAL.INFO_SERVICIO(
                    ID_SERVICIO, 
                    PUNTO_ID, 
                    PRODUCTO_ID, 
                    ES_VENTA,
                    PRECIO_VENTA,
                    CANTIDAD,
                    TIPO_ORDEN,
                    ORDEN_TRABAJO_ID,  
                    PUNTO_FACTURACION_ID,
                    USR_VENDEDOR,
                    ESTADO,
                    FRECUENCIA_PRODUCTO,
                    DESCRIPCION_PRESENTA_FACTURA, 
                    USR_CREACION,
                    FE_CREACION, 
                    IP_CREACION
                )
                VALUES
                (
                    DB_COMERCIAL.SEQ_INFO_SERVICIO.NEXTVAL,
                    Ln_IdPunto,
                    Ln_Producto,
                    'N',
                    0,
                    1,
                    'N',
                    Ln_IdOrdenTrabajo,
                    Ln_IdPuntoFacturacion,
                    Lv_Vendedor,
                    Lv_EstadoServicio,
                    0,
                    Lv_DescripcionProducto,
                    Lv_UsrCreacion,
                    SYSDATE,
                    Lv_IpCreacion
                ) RETURNING ID_SERVICIO INTO Ln_IdServicioNuevo;

                INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH 
                (
                    ID_SERVICIO_HISTORIAL,
                    SERVICIO_ID,
                    OBSERVACION,
                    ESTADO,
                    USR_CREACION,
                    IP_CREACION,
                    FE_CREACION
                )
                VALUES
                (
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_IdServicioNuevo,
                    'Se Crea el servicio por cambio de plan',
                    'PrePlanificado',
                    Lv_UsrCreacion,
                    Lv_IpCreacion,
                    SYSDATE
                );

                IF Lv_EstadoServicio = Lv_EstadoActivo
                THEN
                    Lv_AccionServicio := 'confirmarServicio';
                END IF;

                INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH 
                (
                    ID_SERVICIO_HISTORIAL,
                    SERVICIO_ID,
                    OBSERVACION,
                    ESTADO,
                    USR_CREACION,
                    IP_CREACION,
                    FE_CREACION,
                    ACCION
                )
                VALUES
                (
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Ln_IdServicioNuevo,
                    'Se toma el estado de la Solicitud de Cableado Ethernet',
                    Lv_EstadoServicio,
                    Lv_UsrCreacion,
                    Lv_IpCreacion,
                    SYSDATE,
                    Lv_AccionServicio
                );

                IF Ln_IdUltimaMilla IS NOT NULL 
                THEN

                    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_TECNICO
                    (
                        ID_SERVICIO_TECNICO, 
                        SERVICIO_ID,
                        TIPO_ENLACE,
                        ULTIMA_MILLA_ID
                    )
                    VALUES
                    (
                        DB_COMERCIAL.SEQ_INFO_SERVICIO_TECNICO.NEXTVAL,
                        Ln_IdServicioNuevo,
                        'PRINCIPAL',
                        Ln_IdUltimaMilla
                    );

                END IF;

                OPEN C_GET_SERV_PROD_CARACT (Ln_Producto,'ES_GRATIS',Lv_EstadoActivo);
                FETCH C_GET_SERV_PROD_CARACT INTO Lv_IdProductoCaract;
                CLOSE C_GET_SERV_PROD_CARACT;

                INSERT INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
                (
                    ID_SERVICIO_PROD_CARACT, 
                    SERVICIO_ID, 
                    PRODUCTO_CARACTERISITICA_ID, 
                    VALOR,
                    ESTADO,
                    USR_CREACION,
                    FE_CREACION
                )
                VALUES
                (
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
                    Ln_IdServicioNuevo,
                    Lv_IdProductoCaract,
                    Ln_ValorCaract,
                    Lv_EstadoActivo,
                    Lv_UsrCreacion,
                    SYSDATE

                );

                IF Ln_IdSolicitud IS NOT NULL 
                THEN
                    UPDATE 
                        DB_COMERCIAL.INFO_DETALLE_SOLICITUD 
                    SET
                        SERVICIO_ID = Ln_IdServicioNuevo
                    WHERE ID_DETALLE_SOLICITUD = Ln_IdSolicitud;
                END IF;
              COMMIT;
            END IF;

        END IF;

    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pv_Mensaje    := 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                       'DB_COMERCIAL.P_GENERAR_OTSERV_ADI',
                                        Pv_Mensaje,
                                        'telcos',
                                        SYSDATE,
                                        '127.0.0.1');
    END P_GENERAR_OT_SERVADIC;

END CMKG_CONTRATO_TRANSACCION;
/
