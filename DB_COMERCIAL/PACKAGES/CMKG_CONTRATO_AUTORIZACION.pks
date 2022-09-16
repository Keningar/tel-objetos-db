CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CONTRATO_AUTORIZACION
AS
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


END CMKG_CONTRATO_AUTORIZACION;

/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_CONTRATO_AUTORIZACION
AS
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
              COMMIT;
            -- Se actualiza la numeracion de las ordenes de trabajo
            IF Ln_IdOrdenTrabajo IS NOT NULL AND Ln_Secuencia IS NOT NULL
            THEN      
                Ln_SecuenciaSig := Ln_Secuencia + 1;
                UPDATE 
                DB_COMERCIAL.ADMI_NUMERACION AN
                    SET AN.SECUENCIA = Ln_SecuenciaSig
                WHERE 
                    AN.ID_NUMERACION = Lv_IdNumeracion;
                COMMIT;
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
                          COMMIT;
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
                          COMMIT;
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
                  COMMIT;
                END IF;
              END IF;
              UPDATE DB_COMERCIAL.INFO_SERVICIO ISE
              SET ISE.ESTADO = Lv_EstadoServicio,
                  ISE.ORDEN_TRABAJO_ID = Ln_IdOrdenTrabajo
              WHERE ISE.ID_SERVICIO = Lc_Servicio.Id_Servicio;
              COMMIT;
              IF Lc_Servicio.Tipo_Orden IS NOT NULL THEN
                UPDATE DB_COMERCIAL.INFO_ORDEN_TRABAJO IOT
                SET IOT.TIPO_ORDEN = Lc_Servicio.Tipo_Orden
                WHERE IOT.ID_ORDEN_TRABAJO = Ln_IdOrdenTrabajo;
                COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
        COMMIT;
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
      COMMIT;
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
        COMMIT;
      

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
         COMMIT;
          UPDATE DB_COMERCIAL.INFO_PERSONA_REPRESENTANTE IPR
          SET IPR.ESTADO = 'Eliminado',
              IPR.FE_ULT_MOD = SYSDATE,
              IPR.USR_ULT_MOD = Pcl_Request.Pv_UsrCreacion,
              IPR.IP_ULT_MOD = Pcl_Request.Pv_IpCreacion
          WHERE IPR.ID_PERSONA_REPRESENTANTE = Lc_PersonaRepresentante.Id_Persona_Representante;
         COMMIT;
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
            COMMIT;
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
            COMMIT;
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
            COMMIT;
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
          COMMIT;
        END IF;
      END IF;

      -- Se actualiza la persona empresa rol del prospecto a inactivo
      UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
      SET IPER.ESTADO = 'Inactivo'
      WHERE IPER.ID_PERSONA_ROL = Lc_PersonaEmpresaRol.Id_Persona_Rol;
      COMMIT;
      -- Se actualiza la persona empresa rol referido con el rol cliente
      OPEN C_PERSONA_REFERIDO(Lc_PersonaEmpresaRol.Id_Persona_Rol);
      FETCH C_PERSONA_REFERIDO INTO Lc_PersonaReferido;
      CLOSE C_PERSONA_REFERIDO;      

      IF Lc_PersonaReferido.Id_Persona_Referido IS NOT NULL THEN
        UPDATE DB_COMERCIAL.INFO_PERSONA_REFERIDO IPR
        SET IPR.PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaEmpresaRolCliente
        WHERE IPR.ID_PERSONA_REFERIDO = Lc_PersonaReferido.Id_Persona_Referido;
        COMMIT;
      END IF;

      -- Se actualiza los contactos de pre-cliente con la persona empresa rol cliente
      FOR i in C_CONTACTOS(Lc_PersonaEmpresaRol.Id_Persona_Rol) LOOP
        UPDATE DB_COMERCIAL.INFO_PERSONA_CONTACTO IPC
        SET IPC.PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaEmpresaRolCliente
        WHERE IPC.ID_PERSONA_CONTACTO = i.Id_Persona_Contacto;
        COMMIT;
      END LOOP;

      -- Se actualiza los puntos con la persona empresa rol cliente
      Lv_ContribucionSolidaria    := 'N';
      FOR i in C_PUNTOS(Lc_PersonaEmpresaRol.Id_Persona_Rol) LOOP
        UPDATE DB_COMERCIAL.INFO_PUNTO IP
        SET  IP.PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaEmpresaRolCliente,
             IP.USR_ULT_MOD            = Pcl_Request.Pv_UsrCreacion,
             IP.FE_ULT_MOD             = SYSDATE
        WHERE IP.ID_PUNTO = i.id_punto;
        COMMIT;
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
          COMMIT;
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
          COMMIT;
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
      COMMIT;
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
      COMMIT;
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
       COMMIT;
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
       COMMIT;
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
        COMMIT;
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
         COMMIT;
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
                COMMIT;
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
                COMMIT;
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
                COMMIT;
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
                  COMMIT;
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
                COMMIT;
                IF Ln_IdSolicitud IS NOT NULL 
                THEN
                    UPDATE 
                        DB_COMERCIAL.INFO_DETALLE_SOLICITUD 
                    SET
                        SERVICIO_ID = Ln_IdServicioNuevo
                    WHERE ID_DETALLE_SOLICITUD = Ln_IdSolicitud;
                    COMMIT;
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
             COMMIT;
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
                    COMMIT;
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
                            COMMIT;
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
                                COMMIT;
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
                            COMMIT;
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
                                COMMIT;
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
                                    COMMIT;
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
                                COMMIT;
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
                            COMMIT;
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
                            COMMIT;
                        END IF;
                    END IF;    

                    IF Lv_TipoOrdenServicio IS NOT NULL
                    THEN
                        UPDATE
                        DB_COMERCIAL.INFO_ORDEN_TRABAJO IOT
                            SET IOT.TIPO_ORDEN = Lv_TipoOrdenServicio
                        WHERE 
                            IOT.ID_ORDEN_TRABAJO = Ln_IdOrdenTrabajo;
                         COMMIT;   
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
                        COMMIT;
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
                            COMMIT;
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
                            COMMIT;
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

END CMKG_CONTRATO_AUTORIZACION;
/

