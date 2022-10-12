CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CONTRATO_TRANSACCION
AS


   /**
    * Documentación para la función P_AUTORIZAR_CONTRATO
    * Procedimiento para autorizar un contrato o adendum
    *
    * @param  Pcl_Request       -  Datos para autorizar contrato/adendum,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pv_SeAutorizo     -  Se autoriza 0/1
    * @author 
    * @version 1.0 22-03-2022
    *
    * Se remplazo el procedimiento para  consumo de la tentativa de promociones
    * @author Jefferson Carrillo <jacarrillo@telconet.ec>
    * @version 1.1 27-05-2022 
    */
    PROCEDURE P_AUTORIZAR_CONTRATO(Pcl_Request     IN  VARCHAR2,
                                   Pv_Mensaje      OUT VARCHAR2,
                                   Pv_Status       OUT VARCHAR2,
                                   Pn_SeAutorizo   OUT NUMBER);

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
    * Documentación para la función P_VALIDAR_TARJETA_BANCARIA
    * Procedimiento para validar tarjeta bancaria
    *
    * @param  Pcl_Request       -  Datos del contrato,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    * @author Carlos Caguana <ccaguana@telconet.ec>
    * @version 1.0 02-10-2019
    */                            
    PROCEDURE P_VALIDAR_TARJETA_BANCARIA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2);
   /**
    * Documentación para la función P_GUARDAR_CLAUSULA
    * Procedimiento que guarda el contrato
    *
    * @param  Pcl_Request       -  Json,
    *         Pv_Mensaje        -  Mensaje,
    *         Pv_Status         -  Estado,
    *         Pcl_Response      -  Respuesta
    * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
    * @version 1.0 25-03-2022
    */

    PROCEDURE P_GUARDAR_CLAUSULA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR);

    /**
     * Documentación para la función P_ACTUALIZA_CLAUSULA
     * Procedimiento que actualiza la encuesta.
     *
     * @param  Pcl_Request       -  Json,
     *         Pv_Mensaje        -  Mensaje,
     *         Pv_Status         -  Estado,
     *         Pcl_Response      -  Respuesta
     * @author Walther Joao Gaibor C. <wgaibor@telconet.ec>
     * @version 1.0 05-04-2022
     */
    PROCEDURE P_ACTUALIZA_CLAUSULA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR);


END CMKG_CONTRATO_TRANSACCION;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_CONTRATO_TRANSACCION
AS

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

    CURSOR C_GET_ADENDUM_SERVICIO (Ln_IdAdendum NUMBER)
    IS
    SELECT 
        IAD.SERVICIO_ID
    FROM DB_COMERCIAL.INFO_ADENDUM IAD
    WHERE IAD.ID_ADENDUM = Ln_IdAdendum;

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

      CURSOR C_GET_PARAMETRO(Lv_NombreParametro VARCHAR2, Lv_Estado VARCHAR2, Lv_Descripcion VARCHAR2)
      IS
      SELECT DET.VALOR1, DET.VALOR2, DET.VALOR3, DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Lv_NombreParametro
        AND CAB.ESTADO = Lv_Estado
        AND DET.DESCRIPCION = Lv_Descripcion
        AND DET.ESTADO = Lv_Estado;

      CURSOR C_GET_PRODUCTO_SERVICIO (Ln_ServicioId NUMBER)
      IS
      SELECT  PRODUCTO_ID
      FROM DB_COMERCIAL.INFO_SERVICIO
      WHERE ID_SERVICIO = Ln_ServicioId
        AND ESTADO = 'PrePlanificada';

      CURSOR C_GET_PLAN_SERVICIO (Ln_ServicioId NUMBER)
      IS
      SELECT  PLAN_ID
      FROM DB_COMERCIAL.INFO_SERVICIO
      WHERE ID_SERVICIO = Ln_ServicioId
        AND ESTADO = 'PrePlanificada';
        
      --edg          
      CURSOR C_GET_ESTADO_SERVICIO (Ln_ServicioId NUMBER)
      IS
      SELECT ESTADO
      FROM DB_COMERCIAL.INFO_SERVICIO
      WHERE ID_SERVICIO = Ln_ServicioId;

      CURSOR C_GET_PRODUCTO_PLANIFICA (Lv_Nombre VARCHAR2)
      IS
      SELECT DISTINCT(valor5) as VALOR
      FROM DB_GENERAL.ADMI_PARAMETRO_DET 
      WHERE PARAMETRO_ID = (SELECT id_parametro 
                            FROM db_general.admi_parametro_cab 
                            WHERE nombre_parametro = Lv_Nombre) --'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
     AND valor1 = 'GESTION_PYL_SIMULTANEA' 
     AND VALOR3 = 'PLANIFICAR';


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
    Ln_IteradorM INTEGER;
   Ln_NumeroRolCliente         NUMBER := 0;
   Ln_ProductoId               NUMBER := 0;
   Ln_PlanId                   NUMBER := 0;
   Lv_ParamValor1              VARCHAR2(4000);
   Lv_ParamValor2              VARCHAR2(300);
   Lv_ParamValor3              VARCHAR2(300);
   Lv_ParamValor4              VARCHAR2(300);
   Lv_ParamValor5              VARCHAR2(300);
   Lv_ParamV1              VARCHAR2(4000);
   Lv_ParamV2              VARCHAR2(300);
   Lv_ParamV3              VARCHAR2(300);
   Lv_ParamV4              VARCHAR2(300);
   Lv_ParamV5              VARCHAR2(300);
   Lv_ProductosPlanif          VARCHAR2(4000) := '';

   Lv_MensajeHistPlanif        VARCHAR2(400);
   Lb_TieneProductoRestringido BOOLEAN := FALSE;
   Ln_IdServicio               NUMBER := 0;
   Lv_EstadoServicio           VARCHAR2(50); 


      TYPE recordUltimaMillaServ  IS RECORD
       ( ID_TIPO_MEDIO NUMBER, 
       CODIGO_TIPO_MEDIO VARCHAR2(5));
   TYPE tablaUltimaMillaServ IS TABLE OF recordUltimaMillaServ;
   Pv_arrayMillaServ tablaUltimaMillaServ;
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
                     DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_CONSUME_EVALUA_TENTATIVA(Ln_PuntoId,
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

          FETCH Pcl_UltimaMillaServ BULK COLLECT INTO Pv_arrayMillaServ;
            IF Pv_arrayMillaServ.count() > 0 THEN
              Ln_IteradorM := Pv_arrayMillaServ.FIRST;
              Ln_Id_Tipo_Medio     := Pv_arrayMillaServ(Ln_IteradorM).ID_TIPO_MEDIO;
              Lv_Codigo_Tipo_Medio :=Pv_arrayMillaServ(Ln_IteradorM).CODIGO_TIPO_MEDIO;
          END IF;


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
            DB_COMERCIAL.CMKG_CONTRATO_AUTORIZACION.P_APROBAR_CONTRATO(Pcl_AprobarContrato, Pv_Mensaje, Pv_Status);
            IF Pv_Status != 'OK' THEN
              RAISE Le_Errors;
            END IF;
            Lv_EstadoContrato := 'Activo';
            OPEN C_GET_PARAMETRO('PRODUCTOS QUE NO SE PLANIFICAN', 'Activo', 'PRODUCTOS QUE NO SE PLANIFICAN');
            FETCH C_GET_PARAMETRO INTO Lv_ParamValor1, Lv_ParamValor2, Lv_ParamValor3, Lv_ParamValor4;
            CLOSE C_GET_PARAMETRO;
            Lv_MensajeHistPlanif := Lv_ParamValor4;

      	    --C_GET_PRODUCTO_PLANIFICA
            FOR i IN C_GET_PRODUCTO_PLANIFICA('PARAMETROS_ASOCIADOS_A_SERVICIOS_MD')
            LOOP
                Lv_ProductosPlanif := Lv_ProductosPlanif || i.valor || ',';               
            END LOOP;

            OPEN C_GET_PARAMETRO('PRODUCTOS ADICIONALES MANUALES', 'Activo', 'Productos adicionales manuales para activar');
            FETCH C_GET_PARAMETRO INTO Lv_ParamV1, Lv_ParamV2, Lv_ParamV3, Lv_ParamV4;
            CLOSE C_GET_PARAMETRO;
            Lv_ProductosPlanif := Lv_ProductosPlanif || Lv_ParamV1 || ',' || Lv_ParamV2 || ',' || Lv_ParamV3 || ',' || Lv_ParamV4;


            Lb_TieneProductoRestringido := FALSE;
            FOR i IN C_ADENDUM_PARAMS(Ln_ContratoId, Lv_Tipo)        
            LOOP
              --C_GET_PRODUCTO_SERVICIO
              OPEN C_GET_PRODUCTO_SERVICIO(i.SERVICIO_ID);
              FETCH C_GET_PRODUCTO_SERVICIO INTO Ln_ProductoId;
              IF C_GET_PRODUCTO_SERVICIO%NOTFOUND THEN
                Ln_ProductoId := 0;
              END IF;  
              CLOSE C_GET_PRODUCTO_SERVICIO;
              IF ((Ln_ProductoId > 0 AND INSTR(Lv_ProductosPlanif, Ln_ProductoId) = 0) OR Lv_Tipo = 'AS') THEN
                 Lb_TieneProductoRestringido := true;
                IF Lb_TieneProductoRestringido THEN
                   Lv_MensajeHistPlanif := Lv_ParamValor3;
                END IF;  
              END IF;
            END LOOP;
          ELSE
            Pcl_SetearDatosContrato := DB_COMERCIAL.DATOS_CONTRATO_TYPE(Ln_ContratoId, Lv_ObservacionHistorial, Lv_IpCreacion, Lv_Origen, Lv_UsrCreacion);
            DB_COMERCIAL.CMKG_CONTRATO_AUTORIZACION.P_SETEAR_DATOS_CONTRATO(Pcl_SetearDatosContrato, Pv_Mensaje, Pv_Status);
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
              IF Ln_Descuento = 100 THEN  
                  OPEN C_GET_PRODUCTO_SERVICIO(i.SERVICIO_ID);
                  FETCH C_GET_PRODUCTO_SERVICIO INTO Ln_ProductoId;
                  IF C_GET_PRODUCTO_SERVICIO%NOTFOUND THEN
                    Ln_ProductoId := 0;
                  END IF;       
                  CLOSE C_GET_PRODUCTO_SERVICIO;

                  OPEN C_GET_PLAN_SERVICIO(i.SERVICIO_ID);
                  FETCH C_GET_PLAN_SERVICIO INTO Ln_PlanId;
                  IF C_GET_PLAN_SERVICIO%NOTFOUND THEN
                    Ln_PlanId := 0;
                  END IF;

                  CLOSE C_GET_PLAN_SERVICIO;

                  IF (Ln_PlanId > 0 OR (Ln_ProductoId > 0 AND INSTR(Lv_ProductosPlanif, Ln_ProductoId) != 0)) THEN
                         
                    OPEN C_GET_ESTADO_SERVICIO(i.SERVICIO_ID);
                    FETCH C_GET_ESTADO_SERVICIO INTO Lv_EstadoServicio;
                    IF C_GET_ESTADO_SERVICIO%NOTFOUND THEN
                      Lv_EstadoServicio := 'PrePlanificada';
                    END IF;   
                    CLOSE C_GET_ESTADO_SERVICIO;    
                    
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
                        i.SERVICIO_ID,
                        Lv_UsrCreacion,
                        SYSDATE,
                        Lv_IpCreacion,
                        Lv_EstadoServicio,
                        Lv_MensajeHistPlanif,
                        'Planificacion Comercial'
                    );
                 END IF;   
              END IF;                
          END LOOP;
          UPDATE
            DB_COMERCIAL.INFO_CONTRATO IC
          SET IC.ESTADO = Lv_EstadoContrato
          WHERE
            IC.ID_CONTRATO = Ln_ContratoId;
          COMMIT;
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

                DB_COMERCIAL.CMKG_CONTRATO_AUTORIZACION.P_APROBAR_ADENDUM(Pcl_AprobarAdendum, Pv_Mensaje, Pv_Status);

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
                   COMMIT;             
                END IF;

            END IF; 

            OPEN C_GET_ADENDUM_NUMERO (Lv_Tipo,Lv_NumeroAdendum);
            FETCH C_GET_ADENDUM_NUMERO BULK COLLECT INTO Pcl_ArrayAdendumsNum LIMIT 5000;
            CLOSE C_GET_ADENDUM_NUMERO;
            OPEN C_GET_PARAMETRO('PRODUCTOS QUE NO SE PLANIFICAN', 'Activo', 'PRODUCTOS QUE NO SE PLANIFICAN');
            FETCH C_GET_PARAMETRO INTO Lv_ParamValor1,Lv_ParamValor3,Lv_ParamValor3,Lv_ParamValor4;
            CLOSE C_GET_PARAMETRO;

            Lv_MensajeHistPlanif := Lv_ParamValor4;
            Lv_ProductosPlanif := '';
            FOR i IN C_GET_PRODUCTO_PLANIFICA('PARAMETROS_ASOCIADOS_A_SERVICIOS_MD')
            LOOP
                Lv_ProductosPlanif := Lv_ProductosPlanif || i.valor || ',';               
            END LOOP;


            OPEN C_GET_PARAMETRO('PRODUCTOS ADICIONALES MANUALES', 'Activo', 'Productos adicionales manuales para activar');
            FETCH C_GET_PARAMETRO INTO Lv_ParamV1, Lv_ParamV2, Lv_ParamV3, Lv_ParamV4;
            CLOSE C_GET_PARAMETRO;
            Lv_ProductosPlanif := Lv_ProductosPlanif || ',' || Lv_ParamV1 || ',' || Lv_ParamV2 || ',' || Lv_ParamV3 || ',' || Lv_ParamV4;

            Lb_TieneProductoRestringido := FALSE;            
            IF Pcl_ArrayAdendumsNum.EXISTS(1)
            THEN
                Ln_IteradorJ := Pcl_ArrayAdendumsNum.FIRST;
                WHILE (Ln_IteradorJ IS NOT NULL)
                LOOP
                    --C_GET_ADENDUM_SERVICIO
                  OPEN C_GET_ADENDUM_SERVICIO (Pcl_ArrayAdendumsNum(Ln_IteradorJ).ID_ADENDUM);
                  FETCH C_GET_ADENDUM_SERVICIO INTO Ln_IdServicio;
                  CLOSE C_GET_ADENDUM_SERVICIO;  

                  OPEN C_GET_PRODUCTO_SERVICIO(Ln_IdServicio);
                  FETCH C_GET_PRODUCTO_SERVICIO INTO Ln_ProductoId;
                  IF C_GET_PRODUCTO_SERVICIO%NOTFOUND THEN
                    Ln_ProductoId := 0;
                  END IF;  
                  CLOSE C_GET_PRODUCTO_SERVICIO;

                   IF ((Ln_ProductoId > 0 AND INSTR(Lv_ProductosPlanif, Ln_ProductoId) = 0) OR Lv_Tipo = 'AS')THEN
                     Lb_TieneProductoRestringido := true;
                    IF Lb_TieneProductoRestringido THEN
                       Lv_MensajeHistPlanif := Lv_ParamValor3;
                    END IF;  
                  END IF; 

                  Ln_IteradorJ := Pcl_ArrayAdendumsNum.NEXT(Ln_IteradorJ); 
                END LOOP;
            ELSE
                Pv_Mensaje := 'No Existe Adendum para Autorizar';
                RAISE Le_Errors;
            END IF;

            IF Pcl_ArrayAdendumsNum.EXISTS(1)
            THEN
                Ln_IteradorJ := Pcl_ArrayAdendumsNum.FIRST;
                WHILE (Ln_IteradorJ IS NOT NULL)
                LOOP
                    UPDATE DB_COMERCIAL.INFO_ADENDUM IA
                        SET IA.ESTADO      = Lv_EstadoAdendum
                    WHERE IA.ID_ADENDUM = Pcl_ArrayAdendumsNum(Ln_IteradorJ).ID_ADENDUM;

                    IF Ln_Descuento = 100  OR Lv_Tipo = 'AS' THEN
                      OPEN C_GET_ADENDUM_SERVICIO (Pcl_ArrayAdendumsNum(Ln_IteradorJ).ID_ADENDUM);
                      FETCH C_GET_ADENDUM_SERVICIO INTO Ln_IdServicio;
                      CLOSE C_GET_ADENDUM_SERVICIO;  

                      OPEN C_GET_PRODUCTO_SERVICIO(Ln_IdServicio);
                      FETCH C_GET_PRODUCTO_SERVICIO INTO Ln_ProductoId;
                      IF C_GET_PRODUCTO_SERVICIO%NOTFOUND THEN
                        Ln_ProductoId := 0;
                      END IF;  
                      CLOSE C_GET_PRODUCTO_SERVICIO;  

                      OPEN C_GET_PLAN_SERVICIO(Ln_IdServicio);
                      FETCH C_GET_PLAN_SERVICIO INTO Ln_PlanId;
                      IF C_GET_PLAN_SERVICIO%NOTFOUND THEN
                        Ln_PlanId := 0;
                      END IF;

                      CLOSE C_GET_PLAN_SERVICIO;

                      IF ((Ln_PlanId > 0 OR (Ln_ProductoId > 0 AND INSTR(Lv_ProductosPlanif, Ln_ProductoId) != 0)) OR Lv_Tipo = 'AS') THEN
                        OPEN C_GET_ESTADO_SERVICIO(Ln_IdServicio);
                        FETCH C_GET_ESTADO_SERVICIO INTO Lv_EstadoServicio;
                        IF C_GET_ESTADO_SERVICIO%NOTFOUND THEN
                          Lv_EstadoServicio := 'PrePlanificada';
                        END IF;   
                        CLOSE C_GET_ESTADO_SERVICIO;
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
                              Lv_UsrCreacion,
                              SYSDATE,
                              Lv_IpCreacion,
                              Lv_EstadoServicio,
                              Lv_MensajeHistPlanif,
                              'Planificacion Comercial'
                          ); 
                        END IF;
                    END IF;

                  Ln_IteradorJ := Pcl_ArrayAdendumsNum.NEXT(Ln_IteradorJ); 
                  COMMIT;
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

        DB_COMERCIAL.CMKG_CONTRATO_TRANSACCION.P_RECHAZAR_CONTRATO_ERROR(Pcl_RechazarContrato,
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
                                      Cv_EstadoPendiente VARCHAR2) IS
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
          AND IPER.ESTADO        IN (Cv_EstadoActivo,Cv_EstadoPendiente);

    CURSOR C_GET_CONTRATO_PERSONA(Cn_PersonaEmpresaRol VARCHAR2) IS
        SELECT ID_CONTRATO,ESTADO
        FROM DB_COMERCIAL.INFO_CONTRATO
        WHERE
        PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRol
        AND ESTADO IN ('Activo','PorAutorizar');

    CURSOR C_GET_PUNTO(Cn_PersonaEmpresaRol VARCHAR2) IS
        SELECT ID_PUNTO
        FROM DB_COMERCIAL.INFO_PUNTO
        WHERE
        PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpresaRol
        AND ESTADO NOT IN ( 'Anulado',
                            'Cancelado',
                            'Eliminado',
                            'Cancel');

    CURSOR C_GET_SERVICIO(Cn_IdServicio INTEGER,Cn_IdPersonaEmpRol INTEGER) IS
        SELECT ID_SERVICIO
        FROM DB_COMERCIAL.INFO_SERVICIO ISE
        INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON IPU.ID_PUNTO = ISE.PUNTO_ID
        WHERE
        ISE.ID_SERVICIO = Cn_IdServicio AND
        IPU.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaEmpRol;

    CURSOR C_GET_SERVICIO_ALL(Cn_IdServicio INTEGER) IS
        SELECT ISE.*
        FROM DB_COMERCIAL.INFO_SERVICIO ISE
        WHERE ISE.ID_SERVICIO = Cn_IdServicio;

    CURSOR C_GET_TIPO_CONTRATO(Cn_IdTipoContrato INTEGER)  IS
      SELECT ATC.*
      FROM DB_COMERCIAL.ADMI_TIPO_CONTRATO ATC
      WHERE ATC.ID_TIPO_CONTRATO = Cn_IdTipoContrato;

    CURSOR C_GET_SERVICIO_CARACT(Cn_IdServicio INTEGER, Cn_IdCaracteristica INTEGER) IS
      SELECT ISC.*
      FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC
      WHERE ISC.SERVICIO_ID = Cn_IdServicio
        AND ISC.CARACTERISTICA_ID = Cn_IdCaracteristica
        AND ISC.ESTADO = 'Activo';

    CURSOR C_GET_CARACTERISTICA(Cv_DescCaract VARCHAR2) IS
      SELECT AC.*
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE AC.DESCRIPCION_CARACTERISTICA = Cv_DescCaract
        AND AC.TIPO = 'COMERCIAL'
        AND AC.ESTADO = 'Activo';

    CURSOR C_PER_EMP_ROL_CARACT(  Cn_PersonaEmpresaRolId  INTEGER,
                                  Cn_CaracteristicaId     INTEGER,
                                  Cv_Estado               VARCHAR2)  IS
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
                COMMIT;
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
        COMMIT;
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
                  COMMIT;
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
                 COMMIT;
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
                COMMIT;
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
                  COMMIT;
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
                COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
                COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
                  COMMIT;
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
        COMMIT;
        --INACTIVAR FORMA DE CONTRATO
        FOR i IN C_GET_CONTRATO_FORMA_PAGO(Ln_IdContrato)
        LOOP
            UPDATE DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP
            SET ICFP.ESTADO      = 'Inactivo',
                ICFP.FE_ULT_MOD  = SYSDATE,
                ICFP.USR_ULT_MOD = Lv_UsrCreacion
            WHERE ICFP.ID_DATOS_PAGO = i.ID_DATOS_PAGO;
            COMMIT;
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
          COMMIT;
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
                BEGIN 
                DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_DESCENCRIPTAR(Pv_DatosFormaPago.Pv_NumeroCtaTarjeta,'c69555ab183de6672b1ebf6100bbed59186a5d72', Lv_ValorCifradoTarjeta);
                Lv_DatosTarjeta   := DB_COMERCIAL.DATOS_TARJETA_TYPE( Pv_DatosFormaPago.Pn_TipoCuentaID,
                                                                        Pv_DatosFormaPago.Pn_BancoTipoCuentaId,
                                                                        Lv_ValorCifradoTarjeta,
                                                                        Pv_DatosFormaPago.Pv_CodigoVerificacion,
                                                                        Pv_DatosFormaPago.Pn_CodEmpresa);

                  P_VALIDAR_NUMERO_TARJETA(Lv_DatosTarjeta,Pv_Mensaje,Pv_Status,Lv_RespValidaTarjeta);
                  IF Lv_RespValidaTarjeta IS NOT NULL OR Pv_Status = 'ERROR'
                  THEN
                      Lv_ValorCifradoTarjeta := NULL;
                  END IF;
                EXCEPTION
                  WHEN OTHERS THEN
                  Lv_ValorCifradoTarjeta := NULL;
                END;

                IF Lv_ValorCifradoTarjeta IS NULL
                THEN
                  DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR(Pv_DatosFormaPago.Pv_NumeroCtaTarjeta,'c69555ab183de6672b1ebf6100bbed59186a5d72',Lv_ValorCifradoTarjeta);
                ELSE
                  Lv_ValorCifradoTarjeta := Pv_DatosFormaPago.Pv_NumeroCtaTarjeta;
                END IF;

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
              COMMIT;
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


     PROCEDURE P_VALIDAR_TARJETA_BANCARIA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2
                                  )
  IS

      
        --Forma Pago
        Ln_FormaPagoId             INTEGER;
        Ln_TipoCuentaID            INTEGER;
        Ln_BancoTipoCuentaId       INTEGER;
        Lv_NumeroCtaTarjeta        VARCHAR2(400);
        Lv_CodigoVerificacion      VARCHAR2(400);
        Ln_CodEmpresa              INTEGER;
        Lv_RespValidaTarjeta       VARCHAR2(1000);
        Lv_DatosTarjeta            DB_COMERCIAL.DATOS_TARJETA_TYPE;
     

  BEGIN
        APEX_JSON.PARSE(Pcl_Request);
        Ln_CodEmpresa         := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
        Lv_NumeroCtaTarjeta   := APEX_JSON.get_varchar2(p_path => 'numeroCtaTarjeta');
        Ln_BancoTipoCuentaId  := APEX_JSON.get_varchar2(p_path => 'bancoTipoCuentaId');
        Ln_TipoCuentaID       := APEX_JSON.get_varchar2(p_path => 'tipoCuentaId');
        Ln_FormaPagoId        := APEX_JSON.get_varchar2(p_path => 'formaPagoId');
        Lv_CodigoVerificacion := APEX_JSON.get_varchar2(p_path => 'codigoVerificacion');

       
        Pv_Mensaje   := 'Proceso de validación correcto';
        Pv_Status    := 'OK';
       
        
       
         Lv_DatosTarjeta   := DB_COMERCIAL.DATOS_TARJETA_TYPE( Ln_TipoCuentaID,
                                                                      Ln_BancoTipoCuentaId,
                                                                      Lv_NumeroCtaTarjeta,
                                                                      Lv_CodigoVerificacion,
                                                                      Ln_CodEmpresa);

                                                                     
                                                                     
                                                                     
         P_VALIDAR_NUMERO_TARJETA(Lv_DatosTarjeta,Pv_Mensaje,Pv_Status,Lv_RespValidaTarjeta);
         IF Lv_RespValidaTarjeta IS NOT NULL
         THEN
              RAISE_APPLICATION_ERROR(-20101, Lv_RespValidaTarjeta);
         END IF;
      
       
  EXCEPTION
        WHEN OTHERS THEN
        Pv_Status    := 'ERROR';
        Pv_Mensaje   := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                             'DB_COMERCIAL.P_VALIDAR_TARJETA_BANCARIA',
                                             'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                             'telcos',
                                             SYSDATE,
                                             '127.0.0.1');


  END P_VALIDAR_TARJETA_BANCARIA;

  PROCEDURE P_GUARDAR_CLAUSULA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR) AS

  CURSOR C_EncuestaPuntoExiste(Cn_PuntoId NUMBER) IS
  SELECT
    apla.id_punto_clausula
  FROM
    db_comercial.info_punto_clausula apla
  WHERE
    apla.punto_id = Cn_PuntoId
    and apla.estado NOT IN ('Activo', 'Eliminado');
  -- Estados
    Lv_EstadoPreActivo      VARCHAR2(400) := 'PreActivo';
    Lv_EstadoActivo         VARCHAR2(400) := 'Activo';
    Lv_EstadoEliminado      VARCHAR2(400) := 'Eliminado';

  -- Variables globales de empresa - usuario
    Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
    Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';

  --Variables
    Ln_puntoId                 INTEGER;
    Ln_puntoIdClausula         INTEGER;
    Ln_IdEnunciado             INTEGER;
    Ln_IdRespuesta             INTEGER;
    Ln_CountClausulas          INTEGER;
    Ln_IdDocEnunciadoResp      INTEGER;

    Ln_puntoIdClaResp          INTEGER;
  --VARIABLE CURSOR
    Lc_Response                  SYS_REFCURSOR;
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);

    Ln_puntoId            := APEX_JSON.get_varchar2(p_path => 'puntoId');
    Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ClienteIp          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');

    --Tamaños de arreglo clausula
    Ln_CountClausulas   := APEX_JSON.GET_COUNT(p_path => 'clausulas.enunciado');
    IF Ln_puntoId IS NULL THEN
            RAISE_APPLICATION_ERROR(-20101, 'Es requerido el parámetro puntoId ');
    END IF;
    IF Ln_CountClausulas IS NOT NULL
    THEN
      -- Consultar si el punto ya ingreso clausula en el sistema
        FOR i IN C_EncuestaPuntoExiste(Ln_puntoId) LOOP
          UPDATE DB_COMERCIAL.INFO_PUNTO_CLAUSULA ipca
          SET ipca.ESTADO = Lv_EstadoEliminado,
              ipca.USUARIO_MODIFICACION = Lv_UsrCreacion,
              ipca.FECHA_MODIFICACION = SYSDATE
          WHERE
              ID_PUNTO_CLAUSULA = i.id_punto_clausula;

          UPDATE DB_COMERCIAL.INFO_PUNTO_CLAUSULA_RESP ICRP
          SET ICRP.ESTADO = Lv_EstadoEliminado,
              ICRP.USUARIO_MODIFICACION = Lv_UsrCreacion,
              ICRP.FECHA_MODIFICACION = SYSDATE
          WHERE
              ICRP.PUNTO_CLAUSULA_ID = i.id_punto_clausula;
        END LOOP;
      --
      INSERT INTO DB_COMERCIAL.INFO_PUNTO_CLAUSULA (
                                                    ID_PUNTO_CLAUSULA,
                                                    PUNTO_ID,
                                                    NUMERO_DOCUMENTO,
                                                    ESTADO,
                                                    OBSERVACION,
                                                    USUARIO_CREACION,
                                                    FECHA_CREACION
                                                    )
      VALUES (
        DB_COMERCIAL.SEQ_INFO_PUNTO_CLAUSULA.NEXTVAL,
        Ln_puntoId,
        NULL,
        Lv_EstadoPreActivo,
        NULL,
        Lv_UsrCreacion,
        SYSDATE) RETURNING ID_PUNTO_CLAUSULA INTO Ln_puntoIdClausula;
        --Guardar en el Historial
        INSERT INTO DB_COMERCIAL.INFO_PUNTO_CLAUSULA_HIST (
                                                            ID_PUNTO_CLAUSULA_HIST,
                                                            PUNTO_CLAUSULA_ID,
                                                            PUNTO_ID,
                                                            ESTADO,
                                                            USUARIO_CREACION,
                                                            FECHA_CREACION
                                                          )
        VALUES(
          DB_COMERCIAL.SEQ_INFO_PUNTO_CLAUSULA_HIST.NEXTVAL,
          Ln_puntoIdClausula,
          Ln_puntoId,
          Lv_EstadoPreActivo,
          Lv_UsrCreacion,
          SYSDATE
        );
        FOR i IN 1 .. Ln_CountClausulas LOOP
        APEX_JSON.PARSE(Pcl_Request);
        Ln_IdEnunciado := APEX_JSON.get_varchar2(p_path => 'clausulas.enunciado[%d].idenunciado', p0 => i);
        Ln_IdRespuesta := APEX_JSON.get_varchar2(p_path => 'clausulas.enunciado[%d].respuestas.idrespuesta', p0 => i);

        SELECT
          ader.id_doc_enunciado_resp INTO Ln_IdDocEnunciadoResp
        FROM DB_DOCUMENTO.admi_doc_enunciado_resp ader, DB_DOCUMENTO.admi_documento_enunciado aden
        WHERE ader.documento_enunciado_id = aden.id_documento_enunciado
          and ader.respuesta_id = Ln_IdRespuesta
          and aden.enunciado_id = Ln_IdEnunciado
          and ader.estado = Lv_EstadoActivo
          and aden.estado = Lv_EstadoActivo;

        IF Ln_IdDocEnunciadoResp IS NOT NULL THEN
          INSERT INTO DB_COMERCIAL.INFO_PUNTO_CLAUSULA_RESP (
                                                        ID_PUNTO_CLAUSULA_RESP,
                                                        PUNTO_CLAUSULA_ID,
                                                        DOC_ENUNCIADO_RESP_ID,
                                                        JUSTIFICACION_RESPUESTA,
                                                        ESTADO,
                                                        USUARIO_CREACION,
                                                        FECHA_CREACION
                                                        )
          VALUES (
            DB_COMERCIAL.SEQ_INFO_PUNTO_CLAUSULA_RESP.NEXTVAL,
            Ln_puntoIdClausula,
            Ln_IdDocEnunciadoResp,
            NULL,
            Lv_EstadoPreActivo,
            Lv_UsrCreacion,
            SYSDATE) RETURNING ID_PUNTO_CLAUSULA_RESP INTO Ln_puntoIdClaResp;

          INSERT INTO DB_COMERCIAL.INFO_PUNTO_CLAUSULA_RESP_HIST(
                                                                  ID_PUNTO_CLAUSULA_RESP_HIST,
                                                                  PUNTO_CLAUSULA_RESP_ID,
                                                                  PUNTO_CLAUSULA_ID,
                                                                  DOC_ENUNCIADO_RESP_ID,
                                                                  ESTADO,
                                                                  USUARIO_CREACION,
                                                                  FECHA_CREACION
                                                                )
          VALUES(
            DB_COMERCIAL.SEQ_INFO_PUNTO_CLAUSULA_RESP.NEXTVAL,
            Ln_puntoIdClaResp,
            Ln_puntoIdClausula,
            Ln_IdDocEnunciadoResp,
            Lv_EstadoPreActivo,
            Lv_UsrCreacion,
            SYSDATE
          );
        END IF;
      END LOOP;
    END IF;

    OPEN Pcl_Response FOR
    SELECT 'Encuesta guardada' AS mensaje
    FROM   DUAL;
    --
    COMMIT;
    --
    Pv_Mensaje   := 'Proceso realizado con exito';
    Pv_Status    := 'OK';
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.P_GUARDAR_CLAUSULA',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');
  END P_GUARDAR_CLAUSULA;

  PROCEDURE P_ACTUALIZA_CLAUSULA(
                                  Pcl_Request       IN  VARCHAR2,
                                  Pv_Mensaje        OUT VARCHAR2,
                                  Pv_Status         OUT VARCHAR2,
                                  Pcl_Response      OUT SYS_REFCURSOR) AS
  CURSOR C_CLAUSULA(Cn_PuntoId NUMBER) IS
  SELECT
      ipcl.id_punto_clausula,
      ipcr.id_punto_clausula_resp,
      ipcl.estado,
      ipcl.punto_id
  FROM
      db_comercial.info_punto_clausula      ipcl,
      db_comercial.info_punto_clausula_resp ipcr
  WHERE
          ipcl.id_punto_clausula = ipcr.punto_clausula_id
      AND ipcl.punto_id = Cn_PuntoId;
    -- Estados
      Lv_Estado         VARCHAR2(400);

  -- Variables globales de empresa - usuario
    Lv_UsrCreacion             VARCHAR2(15) := 'telcos';
    Lv_ClienteIp               VARCHAR2(400) := '127.0.0.1';

  --Variables
    Ln_puntoId                 INTEGER;
    Ln_puntoIdClausula         INTEGER;
    Ln_IdEnunciado             INTEGER;
    Ln_IdRespuesta             INTEGER;
    Ln_CountClausulas          INTEGER;
    Ln_IdDocEnunciadoResp      INTEGER;

  --VARIABLE CURSOR
    Lc_Response                  SYS_REFCURSOR;
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);

    Ln_puntoId            := APEX_JSON.get_varchar2(p_path => 'puntoId');
    Lv_UsrCreacion        := SUBSTR(APEX_JSON.get_varchar2(p_path => 'usrCreacion'),0,32);
    Lv_ClienteIp          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_Estado             := APEX_JSON.get_varchar2(p_path => 'estado');

    FOR i IN C_CLAUSULA(Ln_puntoId) LOOP
    IF i.estado = 'PreActivo' THEN
      UPDATE DB_COMERCIAL.INFO_PUNTO_CLAUSULA
      SET ESTADO = Lv_Estado,
          USUARIO_MODIFICACION = Lv_UsrCreacion,
          FECHA_MODIFICACION = SYSDATE
      WHERE
          ID_PUNTO_CLAUSULA = i.id_punto_clausula;

      UPDATE DB_COMERCIAL.INFO_PUNTO_CLAUSULA_RESP
      SET ESTADO = Lv_Estado,
          USUARIO_MODIFICACION = Lv_UsrCreacion,
          FECHA_MODIFICACION = SYSDATE
      WHERE
          ID_PUNTO_CLAUSULA_RESP = i.id_punto_clausula_resp;
      ELSE IF i.estado = 'Eliminado' THEN
        UPDATE DB_COMERCIAL.INFO_PUNTO_CLAUSULA
        SET ESTADO = Lv_Estado,
            USUARIO_MODIFICACION = Lv_UsrCreacion,
            FECHA_MODIFICACION = SYSDATE
        WHERE
            ID_PUNTO_CLAUSULA = i.id_punto_clausula
            and estado <> i.estado;

        UPDATE DB_COMERCIAL.INFO_PUNTO_CLAUSULA_RESP
        SET ESTADO = Lv_Estado,
            USUARIO_MODIFICACION = Lv_UsrCreacion,
            FECHA_MODIFICACION = SYSDATE
        WHERE
            ID_PUNTO_CLAUSULA_RESP = i.id_punto_clausula_resp
            and estado <> i.estado;
      END IF;
    END IF;

    INSERT INTO DB_COMERCIAL.INFO_PUNTO_CLAUSULA_HIST (
                                                            ID_PUNTO_CLAUSULA_HIST,
                                                            PUNTO_CLAUSULA_ID,
                                                            PUNTO_ID,
                                                            ESTADO,
                                                            USUARIO_CREACION,
                                                            FECHA_CREACION
                                                          )
    VALUES(
      DB_COMERCIAL.SEQ_INFO_PUNTO_CLAUSULA_HIST.NEXTVAL,
      i.id_punto_clausula,
      i.punto_id,
      Lv_Estado,
      Lv_UsrCreacion,
      SYSDATE
    );
    END LOOP;

    OPEN Pcl_Response FOR
    SELECT 'Encuesta actualizada' AS mensaje
    FROM   DUAL;
    --
    COMMIT;
    --
  EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    Pv_Status     := 'ERROR';
    Pcl_Response  :=  NULL;
    Pv_Mensaje    := SUBSTR(REGEXP_SUBSTR(SQLERRM,':[^:]+'),2);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CONTRATO',
                                            'DB_DOCUMENTO.P_ACTUALIZA_CLAUSULA',
                                            'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                            'telcos',
                                            SYSDATE,
                                            '127.0.0.1');
  END P_ACTUALIZA_CLAUSULA;

END CMKG_CONTRATO_TRANSACCION;
/
