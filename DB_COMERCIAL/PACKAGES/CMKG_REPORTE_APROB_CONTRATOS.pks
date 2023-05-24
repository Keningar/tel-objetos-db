CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS AS 

  /**
  * Se agregan types necesarios para Generaci�n de Reporte Detallado y Resumido de Aprobaci�n de Contratos
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 11-07-2017
  */

  TYPE Lr_ListadoDatos IS RECORD(TOTAL_REGISTRO NUMBER);
  --
  TYPE Lt_Result IS TABLE OF Lr_ListadoDatos;
  --
  TYPE Lrf_Result IS REF CURSOR;
  --
  TYPE Lr_RptClientesAprobContratos IS RECORD (
          ID_QUERY                   NUMBER,
          ID_SERVICIO                DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, 
          ID_CONTRATO                DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
          LOGIN_PUNTO                DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
          FE_PREPLANIFICACION        VARCHAR2(100),          
          ULT_ESTADO_SOL_PLANIFIC    DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ESTADO%TYPE, 
          NUM_CONTRATO_EMP_PUB       DB_COMERCIAL.INFO_CONTRATO.NUMERO_CONTRATO_EMP_PUB%TYPE,
          NUM_CONTRATO_SISTEMA       DB_COMERCIAL.INFO_CONTRATO.NUMERO_CONTRATO%TYPE,
          IDENTIFICACION             DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
          NOMBRE_CLIENTE             VARCHAR2(500),  
          PTO_COBERTURA              DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
          USUARIO_APROBACION         VARCHAR2(500),
          VENDEDOR                   VARCHAR2(500),
          FE_CREACION_PROSPECTO      VARCHAR2(100),
          FE_CREACION_PTO            VARCHAR2(100),
          FE_CREACION_SERVICIO       VARCHAR2(100),
          FE_FACTIBLE                VARCHAR2(100),
          CANAL_VENTA                VARCHAR2(500),
          PUNTO_VENTA                VARCHAR2(500),
          FORMA_PAGO                 DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
          DESCRIPCION_BANCO          DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE, 
          DESCRIPCION_CUENTA         DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
          ESTADO_CONTRATO            DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE,
          COSTO_INSTALACION          VARCHAR2(500),
          CORTESIA                   VARCHAR2(2), 
          NUMERO_FACTURA             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
          ESTADO_FACTURA             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
          NUMERO_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
          FE_CREACION_PAGO           VARCHAR2(100),
          OBSERVACION_PAGO           DB_FINANCIERO.INFO_PAGO_CAB.COMENTARIO_PAGO%TYPE,
          MOTIVO_RECHAZO             DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
          ULTIMA_MILLA               DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.NOMBRE_TIPO_MEDIO%TYPE,
          SEGMENTO                   DB_COMERCIAL.ADMI_TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO%TYPE,
          TIPO_CONTRATO              DB_COMERCIAL.ADMI_TIPO_CONTRATO.DESCRIPCION_TIPO_CONTRATO%TYPE,
          PLAN_PRODUCTO              VARCHAR2(500)
    );

  TYPE Lr_RptResumenAprobContratos IS RECORD (
          FE_PREPLANIFICACION        VARCHAR2(100),
          PTO_COBERTURA              DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
          CANAL_VENTA                VARCHAR2(500),
          PUNTO_VENTA                VARCHAR2(500),
          SUM_APROBADOS              NUMBER,
          SUM_RECHAZADOS             NUMBER
    );

  /**
   * Documentacion para la funcion F_GET_VARCHAR_CLEAN
   * Funcion que limpia ciertos caracteres especiales 
   * Fv_Cadena IN VARCHAR2 (Recibe la cadena a limpiar)
   * Retorna:
   * En tipo varchar2 la cadena sin caracteres especiales
   *
   * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
   * @version 1.0 11-07-2017
   */
  FUNCTION F_GET_VARCHAR_CLEAN(
      Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2;  

  /**
  * Documentaci�n para PROCEDURE 'P_GET_CLIENTES_APROB_CONTRATOS'.
  * Procedure que me permite obtener Reporte de Gestion de Administracion de Contratos con filtros enviados como par�metros.
  *
  * PARAMETROS:
  * @Param Pv_CodEmpresa  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Codigo Empresa a generar el reporte)
  * @Param Pv_PrefijoEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de empresa a generar el reporte)
  * @Param Pv_UsrSesion  IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Usuario a generar el reporte) 
  * @Param Pv_FechaPrePlanificacionDesde VARCHAR2  (Rango inicial para consulta por fecha de pre-planificacion del servicio)
  * @Param Pv_FechaPrePlanificacionHasta VARCHAR2 (Rango final para consulta por fecha de pre-planificaci�n del servicio)   
  * @Param Pv_IdsPtoCobertura VARCHAR2 (Ids para filtrar por punto de cobertura )    
  * @Param Pn_Start IN NUMBER (Rango inicial de consulta)
  * @Param Pn_Limit IN NUMBER(Rango final consulta) 
  * @param Pn_TotalRegistros  OUT NUMBER (Total de registros obtenidos de la consulta)
  * @param Pr_Documentos      OUT SYS_REFCURSOR (Cursor con los documentos obtenidos de la consulta)
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 11-07-2017
  */
  PROCEDURE P_GET_CLIENTES_APROB_CONTRATOS(
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,   
    Pv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Pv_FechaPrePlanificacionHasta   IN  VARCHAR2,   
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pn_Start                        IN  NUMBER,
    Pn_Limit                        IN  NUMBER,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Documentos                   OUT SYS_REFCURSOR
  );

  /**
  * Documentaci�n para la funci�n 'F_GET_CLIENTES_APROB_CONTRATOS'.
  * Funci�n que me permite obtener Reporte de Gestion de Administracion de Contratos con filtros enviados como par�metros.
  * Costo: 11114
  * PARAMETROS:
  * @Param Fv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Codigo Empresa a generar el reporte)
  * @Param Fv_PrefijoEmpresa  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de empresa a generar el reporte)
  * @Param Fv_UsrSesion IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Usuario a generar el reporte)
  * @Param Fv_FechaPrePlanificacionDesde IN  VARCHAR2 (Rango inicial para consulta por fecha de pre-planificacion del servicio)
  * @Param Fv_FechaPrePlanificacionHasta IN  VARCHAR2 (Rango final para consulta por fecha de pre-planificaci�n del servicio) 
  * @Param Fv_IdsPtoCobertura IN  VARCHAR2 (Ids para filtrar por punto de cobertura )    
  * @Param Fn_Start IN  NUMBER  (Rango inicial de consulta)
  * @Param Fn_Limit IN  NUMBER (Rango final de consulta)
  * @param Fn_TotalRegistros  OUT NUMBER (Total de registros obtenidos de la consulta)
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 11-07-2017
  */
  FUNCTION F_GET_CLIENTES_APROB_CONTRATOS(
    Fv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Fv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Fv_FechaPrePlanificacionHasta   IN  VARCHAR2,
    Fv_IdsPtoCobertura              IN  VARCHAR2,
    Fn_Start                        IN  NUMBER,
    Fn_Limit                        IN  NUMBER,
    Fn_TotalRegistros               OUT NUMBER
  )
    RETURN SYS_REFCURSOR; 

  /**
  * Funcion que sirve para obtener el total de los registros consultados
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0  11-07-2017
  * @param  Lcl_Consulta IN CLOB (Sql que se consulta)
  * @return NUMBER              Cantidad de registros
  */  
  FUNCTION F_GET_COUNT_REFCURSOR(
      Lcl_Consulta IN CLOB)
    RETURN NUMBER;  

  /**
  * Documentaci�n para F_GET_FE_USR_SOLICITUD
  * Retorna la fecha o el usuario del Historial de una Solicitud en base al servicio, Estado y Tipo de Solicitud.
  * Costo: 12
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 14-07-2017
  *
  * @param  Fn_IdServicio        IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE (Recibe el ID del servicio)
  * @param  Fv_TipoSolicitud     IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE (Recibe el tipo de Solicitud)
  * @param  Fv_EstadoSolicitud   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ESTADO%TYPE (Recibe el estado de la Solicitud)
  * @param  Fv_TipoDato          IN VARCHAR2 (Tipo de Dato a obtener: Fecha, o usuario)
  * @return VARCHAR2   Retorna la fecha o usuario del historico de la solicitud
  */
  FUNCTION F_GET_FE_USR_SOLICITUD(
      Fn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Fv_TipoSolicitud   IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
      Fv_EstadoSolicitud IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ESTADO%TYPE,
      Fv_TipoDato        IN VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Documentaci�n para F_GET_ULT_ESTADO_SOLPLANIF
  * Retorna el ultimo estado de una solicitud de tipo PLANIFICACION para un servicio especifico.
  * Costo: 3
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 14-07-2017
  *
  * @param  Fn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE (Recibe el ID del servicio)
  * @return VARCHAR2   Retorna el ultimo estado de una solicitud de tipo PLANIFICACION
  */
  FUNCTION F_GET_ULT_ESTADO_SOLPLANIF(
      Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ESTADO%TYPE;

/**
  * Documentaci�n para F_GET_USUARIO
  * Retorna los nombres del usuario segun el login que recibe como parametro
  * Costo: 3
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-07-2017
  *
  * @param  Fv_Login  IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Recibe Login del usuario)
  * @return VARCHAR2   Retorna apellido y nombres del usuario
  */  
  FUNCTION F_GET_USUARIO(
      Fv_Login     IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE)
  RETURN VARCHAR2;    


/**
  * Documentaci�n para F_GET_FECHA_PROSPECTO_CLI
  * Retorna la fecha de creacion del Prospecto o cliente segun el Rol y prefijho empresa que recibe
  * Costo: 3
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-07-2017
  *
  * @param   Fn_IdPersona          IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE (Id de la Persona Cliente)
  * @param   Fv_DescripcionTipoRol IN DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE (Descripcion del Tipo de Rol)
  * @param   Fv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de la Empresa)
  * @return VARCHAR2   Retorna fecha de creacion del Prospecto o cliente
  */
  FUNCTION F_GET_FECHA_PROSPECTO_CLI(
      Fn_IdPersona          IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
      Fv_DescripcionTipoRol IN DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
      Fv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    RETURN VARCHAR2;    

/**
  * Documentaci�n para F_GET_CANAL_PTOVTA
  * Retorna el canal o el punto de venta asignado a un Punto
  * Costo: 12
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-07-2017
  *
  * @param   Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE (Id del Punto Cliente)
  * @param   Fv_TipoDato  IN VARCHAR2 (Tipo de campo a obtener CANAL O PUNTO DE VENTA)
  * @return VARCHAR2   Retorna Canal o Punto de Venta
  */
  FUNCTION F_GET_CANAL_PTOVTA(
      Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Fv_TipoDato        IN VARCHAR2)
    RETURN VARCHAR2;

/**
  * Documentaci�n para F_INFORMACION_CONTRATO_CLI
  * Retorna Informacion del Contrato por cliente segun el estado y por el tipo de informacion que desea obtener
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-07-2017
  *
  * @param   Fv_TipoInformacion IN VARCHAR2 (Tipo de campo a obtener en la informacion del Contrato)
  * @param   Fn_IdPersonaRol    IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE (Id del cliente)
  * @param   Fv_Estado          IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE (Estado a Consultar)
  * @return VARCHAR2   Retorna Informacion del Contrato
  */
  FUNCTION F_INFORMACION_CONTRATO_CLI(
      Fv_TipoInformacion IN VARCHAR2,
      Fn_IdPersonaRol    IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fv_Estado          IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE)
    RETURN VARCHAR2;

/**
  * Documentaci�n para F_INFORMACION_PAGO_ANT
  * Retorna Informacion del Pago asociado a un ID_DOCUMENTO Factura o Anticipo asociado al ID_PUNTO de facturacion
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 19-07-2017
  *
  * @param   Fv_TipoInformacion IN VARCHAR2 (Tipo de campo a obtener en la informacion del Pago)
  * @param   Fn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE (Id del documento Factura)
  * @param   Fn_IdPunto         IN DB_FINANCIERO.INFO_PAGO_CAB.PUNTO_ID%TYPE (Id del Punto de Facturacion asociado al pago)
  * @return  VARCHAR2   Retorna Informacion del Pago o Anticipo
  */
  FUNCTION F_INFORMACION_PAGO_ANT(
      Fv_TipoInformacion IN VARCHAR2,
      Fn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fn_IdPunto         IN DB_FINANCIERO.INFO_PAGO_CAB.PUNTO_ID%TYPE)
    RETURN VARCHAR2;

/**
  * Documentaci�n para F_INFORMACION_FACT_INST
  * Retorna Informacion respecto a la factura de instalacion en base al ID_PUNTO  de Facturacion, retorna informacion
  * segun el parametro enviado.
  * Costo: 4
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 19-07-2017
  *
  * @param   Fv_TipoInformacion IN VARCHAR2 (Tipo de campo a obtener en la informacion de la Primera Factura de Instalacion)
  * @param   Fn_IdPunto         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE (Id del Punto de Facturacion)
  * @return  VARCHAR2   Retorna Informacion de la factura de instalacion
  */    
  FUNCTION F_INFORMACION_FACT_INST(
      Fv_TipoInformacion IN VARCHAR2,     
      Fn_IdPunto         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN VARCHAR2;

  /**
  * Documentaci�n para PROCEDURE 'P_REPORTE_APROBACION_CONTRATOS'.
  * Procedure que me permite generar Reporte de Gestion de Administracion de Contratos en formato csv Detallado y Resumido y enviarlo por mail
  * segun con filtros recibidos como par�metros.  
  * Costo: 11945
  * PARAMETROS:
  * @Param Pv_CodEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Codigo Empresa a generar el reporte)
  * @Param Pv_PrefijoEmpresa  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de empresa a generar el reporte)
  * @Param Pv_UsrSesion IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Usuario a generar el reporte)
  * @Param Pv_FechaPrePlanificacionDesde IN  VARCHAR2 (Rango inicial para consulta por fecha de pre-planificaci�n del servicio)
  * @Param Pv_FechaPrePlanificacionHasta IN  VARCHAR2 (Rango final para consulta por fecha de pre-planificaci�n del servicio)
  * @Param Pv_IdsPtoCobertura IN  VARCHAR2 (Ids para filtrar por punto de cobertura) 
  * @Param Pv_MsjResultado OUT VARCHAR2 (Devuelve un mensaje del resultado de la generaci�n del reporte)
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 11-07-2017
  */
  PROCEDURE P_REPORTE_APROBACION_CONTRATOS(
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Pv_FechaPrePlanificacionHasta   IN  VARCHAR2,
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pv_MsjResultado                 OUT VARCHAR2  
  );              

END CMKG_REPORTE_APROB_CONTRATOS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS AS

  FUNCTION F_GET_VARCHAR_CLEAN(
          Fv_Cadena IN VARCHAR2)
      RETURN VARCHAR2
  IS
  BEGIN
      RETURN TRIM(
              REPLACE(
              REPLACE(
              REPLACE(
              REPLACE(
              TRANSLATE(
              REGEXP_REPLACE(
              REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|�|<|>|/|;|.|,|%|"]|[)]+$', ' ')
              ,'[^A-Za-z0-9������������&()-_ ]' ,' ')
              ,'������,������', 'AEIOUN aeioun')
              , Chr(9), ' ')
              , Chr(10), ' ')
              , Chr(13), ' ')
              , Chr(59), ' '));
      --

  END F_GET_VARCHAR_CLEAN;
  --
  --

  PROCEDURE P_GET_CLIENTES_APROB_CONTRATOS(
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,   
    Pv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Pv_FechaPrePlanificacionHasta   IN  VARCHAR2,
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pn_Start                        IN  NUMBER,
    Pn_Limit                        IN  NUMBER,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Documentos                   OUT SYS_REFCURSOR
  )
  IS

    Lv_IpCreacion      VARCHAR2(10) := '127.0.0.1';

  BEGIN

    Pc_Documentos := DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_CLIENTES_APROB_CONTRATOS(Pv_CodEmpresa,
                                                                      Pv_PrefijoEmpresa,
                                                                      Pv_UsrSesion,
                                                                      Pv_FechaPrePlanificacionDesde,
                                                                      Pv_FechaPrePlanificacionHasta,
                                                                      Pv_IdsPtoCobertura,
                                                                      Pn_Start,
                                                                      Pn_Limit,
                                                                      Pn_TotalRegistros
                                                                      );

    EXCEPTION
      WHEN OTHERS THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_REPORTE_APROB_CONTRATOS.P_GET_CLIENTES_APROB_CONTRATOS', 
                                              SQLERRM,
                                              Pv_UsrSesion,
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_GET_CLIENTES_APROB_CONTRATOS;
  --
  --

  FUNCTION F_GET_CLIENTES_APROB_CONTRATOS(
    Fv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,    
    Fv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Fv_FechaPrePlanificacionHasta   IN  VARCHAR2, 
    Fv_IdsPtoCobertura              IN  VARCHAR2,
    Fn_Start                        IN  NUMBER,
    Fn_Limit                        IN  NUMBER,
    Fn_TotalRegistros               OUT NUMBER
  )
    RETURN SYS_REFCURSOR
  IS
  --

    Lv_Query           CLOB;
    --
    Lv_QueryCount      CLOB;
    --
    Lv_QueryAllColumns CLOB;
    --
    Lv_LimitAllColumns CLOB;
    --
    Lv_LimitCount      CLOB;

    Lv_IpCreacion      VARCHAR2(10) := '127.0.0.1';

    Lc_ClientesAprobContratos  SYS_REFCURSOR;
  --
  BEGIN
    Lv_QueryCount      :='SELECT ISE.ID_SERVICIO ';
    Lv_QueryAllColumns :='SELECT * FROM (SELECT ROWNUM ID_QUERY,
  ISE.ID_SERVICIO,  
  NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''ID_CONTRATO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
  AS ID_CONTRATO,
  IP.LOGIN AS LOGIN_PUNTO,
  DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_FE_USR_SOLICITUD(ISE.ID_SERVICIO,''SOLICITUD PLANIFICACION'', ''PrePlanificada'',''FECHA'') 
  AS FE_PREPLANIFICACION,
  DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_ULT_ESTADO_SOLPLANIF(ISE.ID_SERVICIO) AS ULT_ESTADO_SOL_PLANIFIC,
  NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''NUMERO_CONTRATO_EMP_PUB'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
  AS NUM_CONTRATO_EMP_PUB,
  NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''NUMERO_CONTRATO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
  AS NUM_CONTRATO_SISTEMA,
  IPE.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
  CASE
        WHEN IPE.RAZON_SOCIAL IS NULL THEN IPE.NOMBRES||'' ''||IPE.APELLIDOS
        ELSE 
        DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
        REPLACE(
        REPLACE(
        REPLACE(
        IPE.RAZON_SOCIAL, Chr(9), '' ''), Chr(10), '' ''), 
        Chr(13), '' '')))
        END AS NOMBRE_CLIENTE,
      NVL(AJ.NOMBRE_JURISDICCION,'' '') AS PTO_COBERTURA,
      DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_FE_USR_SOLICITUD(ISE.ID_SERVICIO,''SOLICITUD PLANIFICACION'', ''PrePlanificada'',''USUARIO'') 
      AS USUARIO_APROBACION,
      NVL(CASE
      WHEN DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_USUARIO(ISE.USR_VENDEDOR) IS NOT NULL
        THEN DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_USUARIO(ISE.USR_VENDEDOR) 
        ELSE
        DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_USUARIO(IP.USR_VENDEDOR) 
        END,'' '') AS VENDEDOR,
      DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_FECHA_PROSPECTO_CLI(IPE.ID_PERSONA,''Pre-cliente'',EMPG.PREFIJO) AS FE_CREACION_PROSPECTO,
      TO_CHAR( IP.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_CREACION_PTO,
      TO_CHAR( ISE.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_CREACION_SERVICIO,
      DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_FE_USR_SOLICITUD(ISE.ID_SERVICIO,''SOLICITUD FACTIBILIDAD'', ''Factible'',''FECHA'') 
      AS FE_FACTIBLE,

      DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
      REPLACE(
      REPLACE(
      REPLACE(
      DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_CANAL_PTOVTA(IP.ID_PUNTO,''CANAL_VENTA''), Chr(9), '' ''), Chr(10), '' ''), 
      Chr(13), '' '')))
      AS CANAL_VENTA,
      DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
      REPLACE(
      REPLACE(
      REPLACE(
      DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_CANAL_PTOVTA(IP.ID_PUNTO,''PUNTO_VENTA''), Chr(9), '' ''), Chr(10), '' ''), 
      Chr(13), '' '')))
      AS PUNTO_VENTA,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_FORMA_PAGO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
      AS FORMA_PAGO,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_BANCO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
      AS DESCRIPCION_BANCO,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_CUENTA'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
      AS DESCRIPCION_CUENTA,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''ESTADO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '')
      AS ESTADO_CONTRATO,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_FACT_INST(''VALOR_TOTAL'',ISE.PUNTO_FACTURACION_ID),'' '') 
      AS COSTO_INSTALACION,
      CASE 
      WHEN ISE.ES_VENTA =''N'' THEN ''SI''
      ELSE ''NO''
      END
      AS CORTESIA,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_FACT_INST(''NUMERO_FACTURA_SRI'',ISE.PUNTO_FACTURACION_ID),'' '') 
      AS NUMERO_FACTURA,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_FACT_INST(''ESTADO_IMPRESION_FACT'',ISE.PUNTO_FACTURACION_ID),'' '') 
      AS ESTADO_FACTURA,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_FACT_INST(''NUMERO_PAGO'',ISE.PUNTO_FACTURACION_ID),'' '') 
      AS NUMERO_PAGO,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_FACT_INST(''FE_CREACION_PAGO'',ISE.PUNTO_FACTURACION_ID),'' '') 
      AS FE_CREACION_PAGO,
      DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
      REPLACE(
      REPLACE(
      REPLACE(
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_FACT_INST(''COMENTARIO_PAGO'',ISE.PUNTO_FACTURACION_ID),'' '')
      , Chr(9), '' ''), Chr(10), '' ''), 
      Chr(13), '' '')))
      AS OBSERVACION_PAGO,
      DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
      REPLACE(
      REPLACE(
      REPLACE(
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''NOMBRE_MOTIVO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '')
      , Chr(9), '' ''), Chr(10), '' ''), 
      Chr(13), '' '')))  
      AS MOTIVO_RECHAZO,
      CASE
      WHEN UM.NOMBRE_TIPO_MEDIO IS NOT NULL THEN UM.NOMBRE_TIPO_MEDIO
      ELSE '' ''
      END AS ULTIMA_MILLA,
      CASE
      WHEN TNE.NOMBRE_TIPO_NEGOCIO IS NOT NULL THEN TNE.NOMBRE_TIPO_NEGOCIO
      ELSE '' ''
      END AS SEGMENTO,
      CASE
      WHEN NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI(''ORIGEN'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') = ''MOVIL''
      THEN ''MOVIL''
      ELSE ''WEB''
      END AS TIPO_CONTRATO,
      CASE
      WHEN ISE.PLAN_ID  IS NOT NULL
      THEN 
      DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     PLA.NOMBRE_PLAN, Chr(9), '' ''), Chr(10), '' ''), 
                                                                     Chr(13), '' '')))            
      ELSE  DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                    PRO.DESCRIPCION_PRODUCTO, Chr(9), '' ''), Chr(10), '' ''), 
                                                                     Chr(13), '' '')))
      END AS PLAN_PRODUCTO ';  

    Lv_Query          := ' FROM DB_COMERCIAL.INFO_PERSONA IPE
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL         IPER ON IPER.PERSONA_ID           = IPE.ID_PERSONA
      JOIN DB_COMERCIAL.INFO_PUNTO                       IP   ON IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL 
      JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO                TNE  ON IP.TIPO_NEGOCIO_ID        = TNE.ID_TIPO_NEGOCIO
      JOIN DB_GENERAL.ADMI_JURISDICCION                  AJ   ON AJ.ID_JURISDICCION        = IP.PUNTO_COBERTURA_ID
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO               IOGJ ON IOGJ.ID_OFICINA           = AJ.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_SERVICIO                    ISE  ON ISE.PUNTO_ID              = IP.ID_PUNTO
      JOIN DB_COMERCIAL.INFO_EMPRESA_ROL                 IER  ON IPER.EMPRESA_ROL_ID       = IER.ID_EMPRESA_ROL 
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO               EMPG ON IER.EMPRESA_COD           = EMPG.COD_EMPRESA
      JOIN DB_COMERCIAL.ADMI_ROL                         AR   ON AR.ID_ROL                 = IER.ROL_ID
      JOIN DB_COMERCIAL.ADMI_TIPO_ROL                    ATR  ON ATR.ID_TIPO_ROL           = AR.TIPO_ROL_ID
      LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO       ISET ON ISE.ID_SERVICIO           = ISET.SERVICIO_ID
      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO       UM   ON ISET.ULTIMA_MILLA_ID      = UM.ID_TIPO_MEDIO
      LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO               PRO  ON ISE.PRODUCTO_ID           = PRO.ID_PRODUCTO
      LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB               PLA  ON ISE.PLAN_ID               = PLA.ID_PLAN

      WHERE
      ATR.DESCRIPCION_TIPO_ROL = ''Cliente''
      AND EMPG.PREFIJO        =  '''||Fv_PrefijoEmpresa||'''
      AND EXISTS (SELECT DS.ID_DETALLE_SOLICITUD
                  FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS
                  JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS ON DS.TIPO_SOLICITUD_ID=TS.ID_TIPO_SOLICITUD
                  WHERE TS.DESCRIPCION_SOLICITUD = ''SOLICITUD PLANIFICACION''
                  AND DS.SERVICIO_ID             = ISE.ID_SERVICIO) ';

      IF Fv_IdsPtoCobertura IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND AJ.ID_JURISDICCION IN ('|| Fv_IdsPtoCobertura ||')';
        --
      END IF;         
      --      
      IF Fv_FechaPrePlanificacionDesde IS NOT NULL AND Fv_FechaPrePlanificacionHasta IS NOT NULL THEN
        --              
        Lv_Query := Lv_Query || ' AND  ISE.ID_SERVICIO IN ( SELECT DS.SERVICIO_ID
                                                            FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS
                                                            JOIN DB_COMERCIAL.INFO_DETALLE_SOL_HIST DSH 
                                                           ON DS.ID_DETALLE_SOLICITUD = DSH.DETALLE_SOLICITUD_ID
                                                            JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS   
                                                           ON DS.TIPO_SOLICITUD_ID    = TS.ID_TIPO_SOLICITUD
                                                            WHERE TS.DESCRIPCION_SOLICITUD = ''SOLICITUD PLANIFICACION''
                                                            AND DSH.ESTADO                 = ''PrePlanificada''
                                                            AND DS.SERVICIO_ID             = ISE.ID_SERVICIO
                                                            AND DSH.FE_CREACION 
                                                            BETWEEN TO_DATE('''||Fv_FechaPrePlanificacionDesde||''',''DD/MM/YY'') 
                                                            AND     TO_DATE('''||Fv_FechaPrePlanificacionHasta||''',''DD/MM/YY'') 
                                                          ) ';
        --                                                          
      END IF;      

      IF Fn_Start   IS NOT NULL AND  Fn_Limit  IS NOT NULL THEN
        Lv_LimitAllColumns := ' ) TB WHERE TB.ID_QUERY >= ' || NVL(Fn_Start, 0) ||
        ' AND TB.ID_QUERY <= ' || (NVL(Fn_Start,0) + NVL(Fn_Limit,0)) || ' ORDER BY TB.ID_QUERY' ;
      ELSE
        Lv_LimitAllColumns := ' 
        ORDER BY TO_DATE(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_FE_USR_SOLICITUD(ISE.ID_SERVICIO,
''SOLICITUD PLANIFICACION'' , ''PrePlanificada'',''FECHA''), ''DD-MM-YYYY HH24:MI:SS'') ASC
        ) '
        ;
      END IF;     

  Lv_QueryAllColumns := Lv_QueryAllColumns || Lv_Query || Lv_LimitAllColumns;
  Lv_QueryCount      := Lv_QueryCount || Lv_Query;

  OPEN Lc_ClientesAprobContratos FOR Lv_QueryAllColumns;

  Fn_TotalRegistros := CMKG_REPORTE_APROB_CONTRATOS.F_GET_COUNT_REFCURSOR(Lv_QueryCount);
  --
  RETURN Lc_ClientesAprobContratos;
  --
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                            'CMKG_REPORTE_APROB_CONTRATOS.F_GET_CLIENTES_APROB_CONTRATOS', 
                                            SQLERRM || ' - QUERY:'|| Lv_QueryAllColumns,
                                            Fv_UsrSesion,
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );

      RETURN NULL;
      --
  END F_GET_CLIENTES_APROB_CONTRATOS;
  --
  --

  FUNCTION F_GET_COUNT_REFCURSOR(
      Lcl_Consulta IN CLOB)
    RETURN NUMBER
  IS
    Lrf_Count    Lrf_Result;
    Lt_RefCursor Lt_Result;
  BEGIN
    --
    OPEN Lrf_Count FOR Lcl_Consulta;
    --
    FETCH
      Lrf_Count BULK COLLECT
    INTO
      Lt_RefCursor;
    --
    RETURN Lt_RefCursor.COUNT;
    --
  END F_GET_COUNT_REFCURSOR;
  --
  --
  FUNCTION F_GET_FE_USR_SOLICITUD(
      Fn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Fv_TipoSolicitud   IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
      Fv_EstadoSolicitud IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ESTADO%TYPE,
      Fv_TipoDato        IN VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR C_GetFeUsrSolicitud(
                                Cn_IdServicio      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Cv_TipoSolicitud   DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                Cv_EstadoSolicitud DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE
                              )
    IS
      SELECT NVL(TO_CHAR( DSH.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS'),'') AS FECHA_SOLICITUD,
      NVL(CASE
      WHEN IPE.RAZON_SOCIAL IS NULL THEN IPE.APELLIDOS||' '||IPE.NOMBRES
      ELSE 
      DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_VARCHAR_CLEAN(TRIM(
                                                                  REPLACE(
                                                                  REPLACE(
                                                                  REPLACE(
                                                                  IPE.RAZON_SOCIAL, Chr(9), ' '), Chr(10), ' '), 
                                                                  Chr(13), ' ')))
      END ,'') AS USUARIO_SOLICITUD
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS
      JOIN DB_COMERCIAL.INFO_DETALLE_SOL_HIST DSH ON DS.ID_DETALLE_SOLICITUD  = DSH.DETALLE_SOLICITUD_ID
      JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS    ON DS.TIPO_SOLICITUD_ID     = TS.ID_TIPO_SOLICITUD
      LEFT JOIN DB_COMERCIAL.INFO_PERSONA IPE     ON IPE.LOGIN                = DSH.USR_CREACION
      WHERE       
      TS.DESCRIPCION_SOLICITUD  = Cv_TipoSolicitud
      AND DSH.ESTADO            = Cv_EstadoSolicitud
      AND DS.SERVICIO_ID        = Cn_IdServicio;

    Lr_GetFeUsrSolicitud C_GetFeUsrSolicitud%ROWTYPE;
    --
    Lv_FechaUsrSolicitud VARCHAR2(500);
    Lv_IpCreacion        VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF C_GetFeUsrSolicitud%ISOPEN THEN
      --
      CLOSE C_GetFeUsrSolicitud;
      --
    END IF;
    --
    OPEN C_GetFeUsrSolicitud(Fn_IdServicio,Fv_TipoSolicitud,Fv_EstadoSolicitud);
    --
    FETCH C_GetFeUsrSolicitud INTO Lr_GetFeUsrSolicitud;
    --
    IF Fv_TipoDato = 'FECHA' THEN
    --
      Lv_FechaUsrSolicitud:= Lr_GetFeUsrSolicitud.FECHA_SOLICITUD;
    --
    ELSIF Fv_TipoDato = 'USUARIO' THEN
    --
        Lv_FechaUsrSolicitud:= Lr_GetFeUsrSolicitud.USUARIO_SOLICITUD;
    --
    END IF;
    CLOSE C_GetFeUsrSolicitud;
    --
    RETURN Lv_FechaUsrSolicitud;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_APROB_CONTRATOS.F_GET_FE_USR_SOLICITUD', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_FE_USR_SOLICITUD;
  --
  --
  FUNCTION F_GET_ULT_ESTADO_SOLPLANIF(
      Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ESTADO%TYPE
  IS
    --
    CURSOR C_GetUltimoEstado(Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Cv_TipoSolicitud  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE)
    IS
    SELECT NVL(DESH.ESTADO,'')
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST DESH 
      WHERE DESH.ID_SOLICITUD_HISTORIAL = (SELECT MAX(DSH.ID_SOLICITUD_HISTORIAL)
                                          FROM  DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS
                                          JOIN  DB_COMERCIAL.INFO_DETALLE_SOL_HIST DSH ON DS.ID_DETALLE_SOLICITUD=DSH.DETALLE_SOLICITUD_ID
                                          JOIN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS ON DS.TIPO_SOLICITUD_ID=TS.ID_TIPO_SOLICITUD
                                          WHERE TS.DESCRIPCION_SOLICITUD = Cv_TipoSolicitud
                                          AND DS.SERVICIO_ID             = Cn_IdServicio);
    --
    Lv_EstadoSolPlanif DB_COMERCIAL.INFO_DETALLE_SOL_HIST.ESTADO%TYPE;

    Lv_IpCreacion  VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF C_GetUltimoEstado%ISOPEN THEN
      --
      CLOSE C_GetUltimoEstado;
      --
    END IF;
    --
    OPEN C_GetUltimoEstado(Fn_IdServicio,'SOLICITUD PLANIFICACION');
    --
    FETCH C_GetUltimoEstado INTO Lv_EstadoSolPlanif;
    --
    CLOSE C_GetUltimoEstado;
    --
    RETURN Lv_EstadoSolPlanif;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_APROB_CONTRATOS.F_GET_ULT_ESTADO_SOLPLANIF', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_ULT_ESTADO_SOLPLANIF;
  --
  --
  FUNCTION F_GET_USUARIO(
      Fv_Login     IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE)
  RETURN VARCHAR2
  IS
    --
    CURSOR C_GetUsuario(Cv_Login DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE)
    IS
    SELECT 
    NVL(CASE
    WHEN IPE.RAZON_SOCIAL IS NULL THEN IPE.APELLIDOS||' '||IPE.NOMBRES
    ELSE 
    DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_VARCHAR_CLEAN(TRIM(
                                                                  REPLACE(
                                                                  REPLACE(
                                                                  REPLACE(
                                                                  IPE.RAZON_SOCIAL, Chr(9), ' '), Chr(10), ' '), 
                                                                  Chr(13), ' ')))
  END ,'') AS NOMBRE_USUARIO
  FROM DB_COMERCIAL.INFO_PERSONA  IPE
  WHERE IPE.LOGIN = Cv_Login;
    --
    Lv_NombreUsuario   VARCHAR2(500);

    Lv_IpCreacion      VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF C_GetUsuario%ISOPEN THEN
      --
      CLOSE C_GetUsuario;
      --
    END IF;
    --
    OPEN C_GetUsuario(Fv_Login);
    --
    FETCH C_GetUsuario INTO Lv_NombreUsuario;
    --
    CLOSE C_GetUsuario;
    --
    RETURN Lv_NombreUsuario;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_APROB_CONTRATOS.F_GET_USUARIO', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_USUARIO;
  --
  --
  FUNCTION F_GET_FECHA_PROSPECTO_CLI(
      Fn_IdPersona          IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
      Fv_DescripcionTipoRol IN DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
      Fv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    RETURN VARCHAR2
  IS
    --
    CURSOR Lc_GetFechaProspectoCli(Cn_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                   Cv_DescripcionTipoRol DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
                                   Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    IS
      SELECT NVL(TO_CHAR( IPERH.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS'),'') 
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH
      WHERE IPERH.ID_PERSONA_EMPRESA_ROL_HISTO = (SELECT MIN(IPRH.ID_PERSONA_EMPRESA_ROL_HISTO) 
                                                  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPRH,
                                                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPEMROL,
                                                  DB_COMERCIAL.INFO_EMPRESA_ROL EMPROL,
                                                  DB_GENERAL.ADMI_ROL ROL,
                                                  DB_GENERAL.ADMI_TIPO_ROL TROL,
                                                  DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPGRUP
                                                  WHERE  IPRH.PERSONA_EMPRESA_ROL_ID   = IPEMROL.ID_PERSONA_ROL
                                                  AND IPEMROL.EMPRESA_ROL_ID    = EMPROL.ID_EMPRESA_ROL
                                                  AND EMPROL.EMPRESA_COD        = EMPGRUP.COD_EMPRESA
                                                  AND EMPROL.ROL_ID             = ROL.ID_ROL
                                                  AND ROL.TIPO_ROL_ID           = TROL.ID_TIPO_ROL
                                                  AND TROL.DESCRIPCION_TIPO_ROL = Cv_DescripcionTipoRol
                                                  AND EMPGRUP.PREFIJO           = Cv_PrefijoEmpresa
                                                  AND IPEMROL.PERSONA_ID        = Cn_IdPersona
                                                  );
    --
    Lv_StrFechaProspectoCli VARCHAR2(20);
    Lv_IpCreacion           VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetFechaProspectoCli%ISOPEN THEN
      --
      CLOSE Lc_GetFechaProspectoCli;
      --
    END IF;
    --
    OPEN Lc_GetFechaProspectoCli(Fn_IdPersona,Fv_DescripcionTipoRol,Fv_PrefijoEmpresa);
    --
    FETCH Lc_GetFechaProspectoCli INTO Lv_StrFechaProspectoCli;
    --
    CLOSE Lc_GetFechaProspectoCli;
    --
    RETURN Lv_StrFechaProspectoCli;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_APROB_CONTRATOS.F_GET_FECHA_PROSPECTO_CLI', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_FECHA_PROSPECTO_CLI;
  --
  --
    FUNCTION F_GET_CANAL_PTOVTA(
      Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,     
      Fv_TipoDato        IN VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR C_GetCanalPtoVta(
                            Cn_IdPunto         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                            Cv_Caracteristica  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                            Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE
                           )
    IS
      SELECT 
      PTO.ID_PUNTO,
      PTO.LOGIN,
      PTO.ESTADO,
      PTOCA.VALOR,
      PAD.VALOR4 AS CANAL,
      PAD.VALOR2 AS PUNTO_VENTA
      FROM INFO_PUNTO PTO,
      DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA PTOCA, 
      DB_COMERCIAL.ADMI_CARACTERISTICA CARA,
      DB_GENERAL.ADMI_PARAMETRO_CAB PAC,
      DB_GENERAL.ADMI_PARAMETRO_DET PAD
      WHERE 
      PTO.ID_PUNTO                            = PTOCA.PUNTO_ID
      AND PTOCA.CARACTERISTICA_ID             = CARA.ID_CARACTERISTICA
      AND PAC.ID_PARAMETRO                    = PAD.PARAMETRO_ID
      AND CARA.DESCRIPCION_CARACTERISTICA     = Cv_Caracteristica
      AND PAC.NOMBRE_PARAMETRO                = Cv_NombreParametro
      AND DBMS_LOB.SUBSTR(PTOCA.VALOR,4000,1) = PAD.VALOR1
      AND PTO.ID_PUNTO                        = Cn_IdPunto
  ;

  Lr_GetCanalPtoVta  C_GetCanalPtoVta%ROWTYPE;
  --
  Lv_CanalPuntoVenta   VARCHAR2(250);
  Lv_IpCreacion        VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF C_GetCanalPtoVta%ISOPEN THEN
      --
      CLOSE C_GetCanalPtoVta;
      --
    END IF;
    --
    OPEN C_GetCanalPtoVta(Fn_IdPunto,'PUNTO_DE_VENTA_CANAL','CANALES_PUNTO_VENTA');
    --
    FETCH C_GetCanalPtoVta INTO Lr_GetCanalPtoVta;
    --
    IF Fv_TipoDato = 'CANAL_VENTA' THEN
    --
      Lv_CanalPuntoVenta:= Lr_GetCanalPtoVta.CANAL;
    --
    ELSIF Fv_TipoDato = 'PUNTO_VENTA' THEN
    --
        Lv_CanalPuntoVenta:= Lr_GetCanalPtoVta.PUNTO_VENTA;
    --
    END IF;
    CLOSE C_GetCanalPtoVta;
    --
    RETURN Lv_CanalPuntoVenta;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_APROB_CONTRATOS.F_GET_CANAL_PTOVTA', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_CANAL_PTOVTA;
  --
  --
  FUNCTION F_INFORMACION_CONTRATO_CLI(
      Fv_TipoInformacion IN VARCHAR2,
      Fn_IdPersonaRol    IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fv_Estado          IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE)
    RETURN VARCHAR2
  IS
  -- 
  --Costo: 12  Cursor para obtener la informacion del contrato por cliente y por estado
  CURSOR C_InformacionContrato(Cn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                               Cv_Estado       IN DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE) IS
  SELECT 
      IC.ID_CONTRATO,
      AFP.DESCRIPCION_FORMA_PAGO,
      AB.DESCRIPCION_BANCO,
      ATC.DESCRIPCION_CUENTA,
      MO.NOMBRE_MOTIVO,
      IC.NUMERO_CONTRATO,
      IC.NUMERO_CONTRATO_EMP_PUB,
      IC.ESTADO,
      IC.ORIGEN
      FROM DB_COMERCIAL.INFO_CONTRATO IC
      LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO=IC.FORMA_PAGO_ID
      LEFT JOIN INFO_CONTRATO_FORMA_PAGO ICFP ON ICFP.CONTRATO_ID=IC.ID_CONTRATO
      LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC on ABTC.ID_BANCO_TIPO_CUENTA=ICFP.BANCO_TIPO_CUENTA_ID
      LEFT JOIN DB_GENERAL.ADMI_BANCO AB ON AB.ID_BANCO=ABTC.BANCO_ID
      LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA ATC ON ATC.ID_TIPO_CUENTA= ABTC.TIPO_CUENTA_ID
      LEFT JOIN DB_GENERAL.ADMI_MOTIVO MO ON IC.MOTIVO_RECHAZO_ID=MO.ID_MOTIVO
      WHERE
      IC.ESTADO                     = Cv_Estado  
      AND IC.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
      AND ROWNUM                    = 1;  

  --Costo: 10  Cursor para obtener la informacion del contrato por cliente ultimo registro
  CURSOR C_InformacionContratoUlt(Cn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
  SELECT 
      IC.ID_CONTRATO,
      AFP.DESCRIPCION_FORMA_PAGO,
      AB.DESCRIPCION_BANCO,
      ATC.DESCRIPCION_CUENTA,
      MO.NOMBRE_MOTIVO,
      IC.NUMERO_CONTRATO,
      IC.NUMERO_CONTRATO_EMP_PUB,
      IC.ESTADO,
      IC.ORIGEN
      FROM DB_COMERCIAL.INFO_CONTRATO IC
      LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO=IC.FORMA_PAGO_ID
      LEFT JOIN INFO_CONTRATO_FORMA_PAGO ICFP ON ICFP.CONTRATO_ID=IC.ID_CONTRATO
      LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC on ABTC.ID_BANCO_TIPO_CUENTA=ICFP.BANCO_TIPO_CUENTA_ID
      LEFT JOIN DB_GENERAL.ADMI_BANCO AB ON AB.ID_BANCO=ABTC.BANCO_ID
      LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA ATC ON ATC.ID_TIPO_CUENTA= ABTC.TIPO_CUENTA_ID
      LEFT JOIN DB_GENERAL.ADMI_MOTIVO MO ON IC.MOTIVO_RECHAZO_ID=MO.ID_MOTIVO
      WHERE     
      IC.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
      AND IC.ID_CONTRATO IN (SELECT MAX(CONT.ID_CONTRATO) 
                            FROM DB_COMERCIAL.INFO_CONTRATO CONT
                            WHERE CONT.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol);

      Lr_InformacionContrato     C_InformacionContrato%ROWTYPE;    
      Lr_InformacionContratoUlt  C_InformacionContratoUlt%ROWTYPE;
      Lv_DatoContrato            VARCHAR2(1000);
      Lv_IpCreacion              VARCHAR2(10) := '127.0.0.1';
  --  
BEGIN    
    IF C_InformacionContrato%ISOPEN THEN
      CLOSE C_InformacionContrato;
    END IF;
    --
    IF C_InformacionContratoUlt%ISOPEN THEN
      CLOSE C_InformacionContratoUlt;
    END IF;
    --
    IF Fv_Estado = 'Cancelado' THEN
      OPEN C_InformacionContrato(Fn_IdPersonaRol,'Cancelado');
      --
      FETCH C_InformacionContrato INTO Lr_InformacionContrato;
      --      
    ELSE
        OPEN C_InformacionContrato(Fn_IdPersonaRol,'Activo');
        --
        FETCH C_InformacionContrato INTO Lr_InformacionContrato;
        --        
    --    
    END IF;
    --
    IF(C_InformacionContrato%FOUND) THEN
    --
        IF Fv_TipoInformacion='DESCRIPCION_FORMA_PAGO' THEN    
            Lv_DatoContrato := Lr_InformacionContrato.DESCRIPCION_FORMA_PAGO;
        ELSIF Fv_TipoInformacion='DESCRIPCION_BANCO' THEN
            Lv_DatoContrato := Lr_InformacionContrato.DESCRIPCION_BANCO;
        ELSIF Fv_TipoInformacion='DESCRIPCION_CUENTA' THEN    
            Lv_DatoContrato := Lr_InformacionContrato.DESCRIPCION_CUENTA;
        ELSIF Fv_TipoInformacion='NOMBRE_MOTIVO' AND Lr_InformacionContrato.ESTADO='Rechazado' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.NOMBRE_MOTIVO;
        ELSIF Fv_TipoInformacion='NUMERO_CONTRATO' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.NUMERO_CONTRATO;
        ELSIF Fv_TipoInformacion='NUMERO_CONTRATO_EMP_PUB' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.NUMERO_CONTRATO_EMP_PUB;
        ELSIF Fv_TipoInformacion='ESTADO' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.ESTADO;      
        ELSIF Fv_TipoInformacion='ORIGEN' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.ORIGEN;
        ELSIF Fv_TipoInformacion='ID_CONTRATO' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.ID_CONTRATO;     
        END IF;                                
    ELSE
    --
        OPEN C_InformacionContratoUlt(Fn_IdPersonaRol);
        --
        FETCH C_InformacionContratoUlt INTO Lr_InformacionContratoUlt;
        --
        IF(C_InformacionContratoUlt%FOUND) THEN
        --
            IF Fv_TipoInformacion='DESCRIPCION_FORMA_PAGO' THEN    
                Lv_DatoContrato := Lr_InformacionContratoUlt.DESCRIPCION_FORMA_PAGO;
            ELSIF Fv_TipoInformacion='DESCRIPCION_BANCO' THEN
                Lv_DatoContrato := Lr_InformacionContratoUlt.DESCRIPCION_BANCO;
            ELSIF Fv_TipoInformacion='DESCRIPCION_CUENTA' THEN    
                Lv_DatoContrato := Lr_InformacionContratoUlt.DESCRIPCION_CUENTA;
            ELSIF Fv_TipoInformacion='NOMBRE_MOTIVO' AND Lr_InformacionContratoUlt.ESTADO='Rechazado' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.NOMBRE_MOTIVO;
            ELSIF Fv_TipoInformacion='NUMERO_CONTRATO' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.NUMERO_CONTRATO;
            ELSIF Fv_TipoInformacion='NUMERO_CONTRATO_EMP_PUB' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.NUMERO_CONTRATO_EMP_PUB;
            ELSIF Fv_TipoInformacion='ESTADO' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.ESTADO;
            ELSIF Fv_TipoInformacion='ORIGEN' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.ORIGEN;  
            ELSIF Fv_TipoInformacion='ID_CONTRATO' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.ID_CONTRATO;
            END IF;  
        --
        END IF;
        --
        CLOSE C_InformacionContratoUlt;
    --
    END IF;  
    --
    CLOSE C_InformacionContrato;
  --
  --
  RETURN Lv_DatoContrato;
  --
EXCEPTION
WHEN OTHERS THEN 
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_CONTRATO_CLI', 
                                        'Error al obtener la informaci�n de contrato (' || Fv_TipoInformacion || ', ' || Fn_IdPersonaRol || ') - '
                                        || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
  --
  RETURN NULL;
  --
END F_INFORMACION_CONTRATO_CLI;
  --
  --
  FUNCTION F_INFORMACION_PAGO_ANT(
      Fv_TipoInformacion IN VARCHAR2,
      Fn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fn_IdPunto         IN DB_FINANCIERO.INFO_PAGO_CAB.PUNTO_ID%TYPE)
    RETURN VARCHAR2
  IS
    -- Costo: 7
    CURSOR C_GetPago(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
    SELECT NVL(IPC.NUMERO_PAGO,'') AS NUMERO_PAGO,
      NVL(TO_CHAR(IPC.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS') ,' ') AS FE_CREACION_PAGO,
      NVL(IPC.COMENTARIO_PAGO,'') AS COMENTARIO_PAGO      
      FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
      JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IPC.ID_PAGO = IPD.PAGO_ID
      WHERE IPD.REFERENCIA_ID = Cn_IdDocumento
      AND IPD.ESTADO          IN ('Activo','Cerrado');
    --  
    -- Costo: 4
    CURSOR C_GetAnticipo(Cn_IdPunto DB_FINANCIERO.INFO_PAGO_CAB.PUNTO_ID%TYPE)
    IS
    SELECT NVL(IPC.NUMERO_PAGO,'') AS NUMERO_PAGO,
    NVL(TO_CHAR(IPC.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS') ,' ') AS FE_CREACION_PAGO,
    NVL(IPC.COMENTARIO_PAGO,'') AS COMENTARIO_PAGO     
      FROM DB_FINANCIERO.INFO_PAGO_CAB IPC,
      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF 
      WHERE IPC.TIPO_DOCUMENTO_ID    = ATDF.ID_TIPO_DOCUMENTO 
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('ANT','ANTS')
      AND IPC.ESTADO_PAGO            IN ('Pendiente')
      AND IPC.PUNTO_ID               = Cn_IdPunto
      AND IPC.ID_PAGO                IN (SELECT MIN(IPC.ID_PAGO)
                                         FROM DB_FINANCIERO.INFO_PAGO_CAB IPC,
                                         DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF 
                                         WHERE IPC.TIPO_DOCUMENTO_ID    = ATDF.ID_TIPO_DOCUMENTO 
                                         AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('ANT','ANTS')
                                         AND IPC.ESTADO_PAGO            IN ('Pendiente')
                                         AND IPC.PUNTO_ID               = Cn_IdPunto);

    Lr_GetPago             C_GetPago%ROWTYPE;        
    Lr_GetAnticipo         C_GetAnticipo%ROWTYPE;        
    Lv_DatoPagoAnticipo    VARCHAR2(1000);
    Lv_IpCreacion          VARCHAR2(10) := '127.0.0.1';         
    --
  BEGIN
    --
    IF C_GetPago%ISOPEN THEN
      --
      CLOSE C_GetPago;
      --
    END IF;
    --
    IF C_GetAnticipo%ISOPEN THEN
      --
      CLOSE C_GetAnticipo;
      --
    END IF;
    --
    OPEN C_GetPago(Fn_IdDocumento);
    --
    FETCH C_GetPago INTO Lr_GetPago;
    --
    IF(C_GetPago%FOUND) THEN
    --
        IF Fv_TipoInformacion='NUMERO_PAGO' THEN    
            Lv_DatoPagoAnticipo := Lr_GetPago.NUMERO_PAGO;
        ELSIF Fv_TipoInformacion='FE_CREACION_PAGO' THEN
            Lv_DatoPagoAnticipo := Lr_GetPago.FE_CREACION_PAGO;
        ELSIF Fv_TipoInformacion='COMENTARIO_PAGO' THEN
            Lv_DatoPagoAnticipo := Lr_GetPago.COMENTARIO_PAGO;
        END IF;
    --    
    ELSE
    --
      OPEN C_GetAnticipo(Fn_IdPunto);
      --
      FETCH C_GetAnticipo INTO Lr_GetAnticipo;

      IF(C_GetAnticipo%FOUND) THEN
        --
        IF Fv_TipoInformacion='NUMERO_PAGO' THEN    
          Lv_DatoPagoAnticipo := Lr_GetAnticipo.NUMERO_PAGO;
        ELSIF Fv_TipoInformacion='FE_CREACION_PAGO' THEN
            Lv_DatoPagoAnticipo := Lr_GetAnticipo.FE_CREACION_PAGO;
        ELSIF Fv_TipoInformacion='COMENTARIO_PAGO' THEN
            Lv_DatoPagoAnticipo := Lr_GetAnticipo.COMENTARIO_PAGO;
        END IF;
    --
    END IF;
    CLOSE C_GetAnticipo;
    --
    END IF;
    --
    CLOSE C_GetPago;
    --            

    RETURN Lv_DatoPagoAnticipo;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_PAGO_ANT', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_INFORMACION_PAGO_ANT;
  --
  --
  FUNCTION F_INFORMACION_FACT_INST(
      Fv_TipoInformacion IN VARCHAR2,     
      Fn_IdPunto         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
    RETURN VARCHAR2
  IS
    --
    CURSOR C_GetFactInstalacion(Cn_IdPunto DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
    IS
    SELECT  IDFC.ID_DOCUMENTO,
      NVL(IDFC.NUMERO_FACTURA_SRI,'')  AS NUMERO_FACTURA_SRI,
      NVL(IDFC.ESTADO_IMPRESION_FACT,'') AS ESTADO_IMPRESION_FACT,
      NVL(IDFC.OBSERVACION,'') AS COMENTARIO_FACTURA,
      NVL(IDFC.VALOR_TOTAL,'') AS VALOR_TOTAL,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_PAGO_ANT('NUMERO_PAGO',IDFC.ID_DOCUMENTO,Cn_IdPunto),' ') AS NUMERO_PAGO,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_PAGO_ANT('FE_CREACION_PAGO',IDFC.ID_DOCUMENTO,Cn_IdPunto),' ') AS FE_CREACION_PAGO,
      NVL(DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_PAGO_ANT('COMENTARIO_PAGO',IDFC.ID_DOCUMENTO,Cn_IdPunto),' ') AS COMENTARIO_PAGO

      FROM    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB   IDFC
      JOIN    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF ON IDFC.TIPO_DOCUMENTO_ID  = ATDF.ID_TIPO_DOCUMENTO 
      WHERE   IDFC.PUNTO_ID             = Cn_IdPunto
      AND     ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND     IDFC.ESTADO_IMPRESION_FACT IN ('Cerrado','Activo')
      AND     IDFC.ID_DOCUMENTO IN ( SELECT  MIN(IDF.ID_DOCUMENTO) 
                                      FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB   IDF
                                      JOIN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF ON IDF.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO 
                                      JOIN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET   IDFD ON IDF.ID_DOCUMENTO      = IDFD.DOCUMENTO_ID
                                      LEFT JOIN  DB_COMERCIAL.ADMI_PRODUCTO               PROD ON IDFD.PRODUCTO_ID      = PROD.ID_PRODUCTO
                                      LEFT JOIN  DB_COMERCIAL.INFO_PLAN_CAB               PLA  ON IDFD.PLAN_ID          = PLA.ID_PLAN
                                      WHERE IDF.PUNTO_ID             = Cn_IdPunto 
                                      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
                                      AND IDF.ESTADO_IMPRESION_FACT  IN ('Cerrado','Activo')  
                                      AND (
                                          (IDFD.PRODUCTO_ID IS NOT NULL AND UPPER(DESCRIPCION_PRODUCTO) LIKE 'INSTALACION%')
                                          OR 
                                          (IDFD.PLAN_ID IS NOT NULL AND UPPER(NOMBRE_PLAN) LIKE 'INSTALACION%')
                                          )
                                    )
                                    ;
    --    
    Lr_GetFactInstalacion     C_GetFactInstalacion%ROWTYPE;
    Lv_DatoFactInstalacion    VARCHAR2(1000);
    Lv_IpCreacion             VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF C_GetFactInstalacion%ISOPEN THEN
      --
      CLOSE C_GetFactInstalacion;
      --
    END IF;
    --

  OPEN C_GetFactInstalacion(Fn_IdPunto);
    --
    FETCH C_GetFactInstalacion INTO Lr_GetFactInstalacion;
    --
    IF(C_GetFactInstalacion%FOUND) THEN
    --
        IF Fv_TipoInformacion='NUMERO_FACTURA_SRI' THEN
            Lv_DatoFactInstalacion := Lr_GetFactInstalacion.NUMERO_FACTURA_SRI;
        ELSIF Fv_TipoInformacion='ESTADO_IMPRESION_FACT' THEN
            Lv_DatoFactInstalacion := Lr_GetFactInstalacion.ESTADO_IMPRESION_FACT;
        ELSIF Fv_TipoInformacion='NUMERO_PAGO' THEN
            Lv_DatoFactInstalacion := Lr_GetFactInstalacion.NUMERO_PAGO;
        ELSIF Fv_TipoInformacion='FE_CREACION_PAGO' THEN
            Lv_DatoFactInstalacion := Lr_GetFactInstalacion.FE_CREACION_PAGO;
        ELSIF Fv_TipoInformacion='COMENTARIO_PAGO' THEN
            Lv_DatoFactInstalacion := Lr_GetFactInstalacion.COMENTARIO_PAGO;
        ELSIF Fv_TipoInformacion='VALOR_TOTAL' THEN
            Lv_DatoFactInstalacion := Lr_GetFactInstalacion.VALOR_TOTAL;
        END IF;   
        --
    END IF;
    --
    CLOSE C_GetFactInstalacion;
    --            

    RETURN Lv_DatoFactInstalacion;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_APROB_CONTRATOS.F_INFORMACION_FACT_INST', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_INFORMACION_FACT_INST;
  --
  --    
  PROCEDURE P_REPORTE_APROBACION_CONTRATOS(
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,    
    Pv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Pv_FechaPrePlanificacionHasta   IN  VARCHAR2,    
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pv_MsjResultado                 OUT VARCHAR2
  )
  IS
    Lv_Directorio                 VARCHAR2(50)   := 'DIR_REPGERENCIA';
    Lv_NombreArchivo              VARCHAR2(150)  := 'ReporteDetalladoGestionAdmContratos_'||Pv_PrefijoEmpresa||'_'||Pv_UsrSesion||'.csv';
    Lv_NombreArchivoResumen       VARCHAR2(150)  := 'ReporteResumenGestionAdmContratos_'||Pv_PrefijoEmpresa||'_'||Pv_UsrSesion||'.csv';
    Lv_Delimitador                VARCHAR2(1)    := ';';
    Lv_Gzip                       VARCHAR2(100)  := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_GzipResumen                VARCHAR2(100)  := 'gzip /backup/repgerencia/'||Lv_NombreArchivoResumen;
    Lv_Remitente                  VARCHAR2(100)  := 'notificaciones_telcos@telconet.ec';    
    Lv_Asunto                     VARCHAR2(300)  := 'Reporte Detalle de Gestion de Administracion de Contratos ';
    Lv_AsuntoResumen              VARCHAR2(300)  := 'Reporte Resumen de Gestion de Administracion de Contratos ';
    Lv_Cuerpo                     VARCHAR2(9999) := '';
    Lv_IpCreacion                 VARCHAR2(10)   := '127.0.0.1';
    Ln_Total                      NUMBER         := 0;
    Lv_NombreArchivoZip           VARCHAR2(250)  := Lv_NombreArchivo||'.gz';
    Lv_NombreArchivoZipResumen    VARCHAR2(250)  := Lv_NombreArchivoResumen||'.gz';
    Lc_GetDatos                   SYS_REFCURSOR;    
    Lr_Datos                      Lr_RptClientesAprobContratos;
    Lr_DatosResumen               Lr_RptResumenAprobContratos;
    Lc_GetAliasPlantilla          DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo                 UTL_FILE.FILE_TYPE;
    Lfile_ArchivoResumen          UTL_FILE.FILE_TYPE;
    Lv_AliasCorreos               VARCHAR2(500);
    Lv_Destinatario               VARCHAR2(500); 
    Lv_DescPtosCobertura          VARCHAR2(4000):='';
    Lv_DesCobertura               VARCHAR2(250);
    Lv_DocsEntregables            VARCHAR2(500);
    Lv_CaractOriginal             VARCHAR2(100):= '������������������������������������������������';
    Lv_CaractReemplazo            VARCHAR2(100):= 'naeiouaeiouaoaeiooaeioucNAEIOUAEIOUAOAEIOOAEIOUC';
    --
    --Costo: 1
    CURSOR C_GetDescPtosCobertura(Cv_IdsPtoCobertura DB_INFRAESTRUCTURA.ADMI_JURISDICCION.ID_JURISDICCION%TYPE)
    IS 
    SELECT IJU.NOMBRE_JURISDICCION AS JURISDICCION
    FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION IJU 
    WHERE IJU.ID_JURISDICCION = Cv_IdsPtoCobertura;
    --
    --Costo: 6
    CURSOR C_GetParametroDocEntregables
    IS
    SELECT PAD.DESCRIPCION,
    PAD.VALOR1,
    PAD.VALOR2
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAC,
    DB_GENERAL.ADMI_PARAMETRO_DET PAD
    WHERE PAC.NOMBRE_PARAMETRO = 'DOCUMENTOS_ENTREGABLES_CONTRATO'
    AND PAC.ID_PARAMETRO       = PAD.PARAMETRO_ID;
    --
    --Costo: 248
    CURSOR C_GetDocsEntregablesContrato(Cn_IdContrato DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                        Cv_TipoDoc    DB_COMERCIAL.INFO_CONTRATO_CARACTERISTICA.VALOR1%TYPE)
    IS
      SELECT IC.ID_CONTRATO,
      CAR.DESCRIPCION_CARACTERISTICA,
      PAD.DESCRIPCION,
      PAD.VALOR2,
      ICC.VALOR1, 
      ICC.VALOR2 AS RESPUESTA
      FROM DB_COMERCIAL.INFO_CONTRATO IC,
      DB_COMERCIAL.INFO_CONTRATO_CARACTERISTICA ICC,
      DB_COMERCIAL.ADMI_CARACTERISTICA CAR,
      DB_GENERAL.ADMI_PARAMETRO_CAB PAC,
      DB_GENERAL.ADMI_PARAMETRO_DET PAD
      WHERE IC.ORIGEN                    = 'MOVIL'
      AND CAR.DESCRIPCION_CARACTERISTICA = 'DOCUMENTOS_ENTREGABLES_CONTRATO'
      AND IC.ID_CONTRATO                 = ICC.CONTRATO_ID
      AND ICC.CARACTERISTICA_ID          = CAR.ID_CARACTERISTICA
      AND CAR.DESCRIPCION_CARACTERISTICA = PAC.NOMBRE_PARAMETRO
      AND PAD.PARAMETRO_ID               = PAC.ID_PARAMETRO
      AND PAD.VALOR1                     = ICC.VALOR1
      AND IC.ID_CONTRATO                 = Cn_IdContrato
      AND ICC.VALOR1                     = Cv_TipoDoc
      AND ROWNUM                         = 1;

    Lr_GetDocsEntregablesContrato     C_GetDocsEntregablesContrato%ROWTYPE;
    Lv_Query     CLOB;
    Lc_ResumenAprobContratos  SYS_REFCURSOR;

  BEGIN

    IF C_GetDescPtosCobertura%ISOPEN THEN
      --
      CLOSE C_GetDescPtosCobertura;
      --
    END IF;
    IF C_GetDocsEntregablesContrato%ISOPEN THEN
      --
      CLOSE C_GetDocsEntregablesContrato;
      --
    END IF;
    --
    FOR CURRENT_ROW IN (
        WITH TEST AS
        (SELECT Pv_IdsPtoCobertura FROM DUAL)
        SELECT regexp_substr(Pv_IdsPtoCobertura, '[^,]+', 1, ROWNUM) SPLIT
        FROM TEST
        CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_IdsPtoCobertura, '[^,]+'))  + 1
      )
      LOOP
      OPEN C_GetDescPtosCobertura(CURRENT_ROW.SPLIT);
        --
      FETCH C_GetDescPtosCobertura INTO Lv_DesCobertura;
      IF(Lv_DesCobertura IS NOT NULL) THEN
          Lv_DescPtosCobertura:= Lv_DescPtosCobertura || '' ||Lv_DesCobertura|| '|';
      END IF;
      --
      CLOSE C_GetDescPtosCobertura;

      END LOOP;
    --
    IF(Lv_DescPtosCobertura IS NULL) THEN
        Lv_DescPtosCobertura:='Todos';
    END IF;

    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DET_APRCONT');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
    Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';

    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000); 

    Pv_MsjResultado      := 'Reporte generado y enviado correctamente .'; 

    ---------------------------------------------------------------------
    --GENERO REPORTE DETALLADO DE GESTION DE ADMINISTRACION DE CONTRATROS
    ---------------------------------------------------------------------
    Lc_GetDatos := DB_COMERCIAL.CMKG_REPORTE_APROB_CONTRATOS.F_GET_CLIENTES_APROB_CONTRATOS(Pv_CodEmpresa,
                                                                      Pv_PrefijoEmpresa,
                                                                      Pv_UsrSesion,
                                                                      Pv_FechaPrePlanificacionDesde,
                                                                      Pv_FechaPrePlanificacionHasta,
                                                                      Pv_IdsPtoCobertura,
                                                                      NULL,
                                                                      NULL,
                                                                      Ln_Total
                                                                      );   
  -- CABECERA DEL REPORTE
  utl_file.put_line(Lfile_Archivo,'USUARIO QUE GENERA: '||Pv_UsrSesion||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||'FECHA DE GENERACION:  '||TO_CHAR(SYSDATE, 'DD-MM-YYYY, HH24:MI:SS')||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          );

  utl_file.put_line(Lfile_Archivo,'DESDE: '||TO_DATE(Pv_FechaPrePlanificacionDesde,'DD/MM/YY')||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||'HASTA: '||(TO_DATE(Pv_FechaPrePlanificacionHasta,'DD/MM/YY')-1)||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
  );
  utl_file.put_line(Lfile_Archivo,'PTOS COBERTURA: '||Lv_DescPtosCobertura||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          );

  utl_file.put_line(Lfile_Archivo,'Formato Detalle de Gestion de Administracion de Contratos'||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          );

  FOR Lr_GetParametroDocEntregables in C_GetParametroDocEntregables LOOP
    Lv_DocsEntregables := Lv_DocsEntregables || Lr_GetParametroDocEntregables.VALOR2 ||Lv_Delimitador;
    Lv_DocsEntregables := TRANSLATE(Lv_DocsEntregables,Lv_CaractOriginal,Lv_CaractReemplazo);
  END LOOP;

  utl_file.put_line(Lfile_Archivo,'LOGIN'||Lv_Delimitador  --0)
          ||'FECHA DE PREPLANIFICACION'||Lv_Delimitador  --1)
          ||'ESTADO SOLIC. PLANIFICACION'||Lv_Delimitador --2)
          ||'NO. CONTRATO'||Lv_Delimitador --3)
          ||'NO. CONTRATO SISTEMA'||Lv_Delimitador --4)
          ||'CED/RUC/PAS'||Lv_Delimitador --5)
          ||'NOMBRE DEL CLIENTE'||Lv_Delimitador --6)
          ||'PTO. COBERTURA'||Lv_Delimitador --7)
          ||'USUARIO APROBACION'||Lv_Delimitador --8)
          ||'USUARIO VENDEDOR'||Lv_Delimitador --9)
          ||'FECHA CREACION PROSPECTO'||Lv_Delimitador --10)
          ||'FECHA CREACION PUNTO'||Lv_Delimitador --11)
          ||'FECHA CREACION SERVICIO'||Lv_Delimitador --12)
          ||'FECHA FACTIBLE'||Lv_Delimitador --13)
          ||'CANAL DE VENTA'||Lv_Delimitador --14)
          ||'PUNTO DE VENTA'||Lv_Delimitador --15)
          ||'FORMA DE PAGO'||Lv_Delimitador  --16)
          ||'DESC. BANCO'||Lv_Delimitador    --17)
          ||'DESC. TIPO CUENTA'||Lv_Delimitador --18)
          ||'ESTADO DEL CONTRATO'||Lv_Delimitador --19)
          ||'COSTO INSTALACION'||Lv_Delimitador --20)
          ||'CORTESIA'||Lv_Delimitador   --21)
          ||'NUMERO DE FACTURA'||Lv_Delimitador  --22) 
          ||'ESTADO DE FACTURA'||Lv_Delimitador  --23)
          ||'NUMERO DE PAGO'||Lv_Delimitador     --24)
          ||'FECHA CREACION PAGO'||Lv_Delimitador --25)
          ||'OBSERVACION PAGO'||Lv_Delimitador --26)
          ||'ULTIMA MILLA'||Lv_Delimitador --27)
          ||'SEGMENTO'||Lv_Delimitador --28)
          ||'TIPO CONTRATO'||Lv_Delimitador --29)
          ||'PLAN/PRODUCTO'||Lv_Delimitador --30) 
          ||Lv_DocsEntregables
          );
    LOOP
      FETCH Lc_GetDatos INTO Lr_Datos;
        EXIT
        WHEN Lc_GetDatos%NOTFOUND; 
          Lv_DocsEntregables := '';
          FOR Lr_GetParametroDocEntregables in C_GetParametroDocEntregables LOOP
              --
              OPEN C_GetDocsEntregablesContrato(Lr_Datos.ID_CONTRATO, Lr_GetParametroDocEntregables.VALOR1);
              --
              FETCH C_GetDocsEntregablesContrato INTO Lr_GetDocsEntregablesContrato;
              IF(C_GetDocsEntregablesContrato%FOUND) THEN
                  Lv_DocsEntregables:= Lv_DocsEntregables || Lr_GetDocsEntregablesContrato.RESPUESTA ||Lv_Delimitador;
              ELSE
                  Lv_DocsEntregables:= Lv_DocsEntregables ||Lv_Delimitador;
              END IF;
              --
              CLOSE C_GetDocsEntregablesContrato;

          END LOOP;
          UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_Datos.LOGIN_PUNTO, '')||Lv_Delimitador --0)
            ||NVL(Lr_Datos.FE_PREPLANIFICACION, '')||Lv_Delimitador  --1)
            ||NVL(Lr_Datos.ULT_ESTADO_SOL_PLANIFIC, '')||Lv_Delimitador --2)
            ||NVL(Lr_Datos.NUM_CONTRATO_EMP_PUB, '')||Lv_Delimitador    --3)
            ||NVL(Lr_Datos.NUM_CONTRATO_SISTEMA, '')||Lv_Delimitador    --4)
            ||NVL(Lr_Datos.IDENTIFICACION,'')||Lv_Delimitador           --5)
            ||NVL(Lr_Datos.NOMBRE_CLIENTE, '')||Lv_Delimitador          --6)
            ||NVL(Lr_Datos.PTO_COBERTURA, '')||Lv_Delimitador   --7)
            ||NVL(Lr_Datos.USUARIO_APROBACION, '')||Lv_Delimitador      --8)
            ||NVL(Lr_Datos.VENDEDOR, '')||Lv_Delimitador                --9)
            ||NVL(Lr_Datos.FE_CREACION_PROSPECTO, '')||Lv_Delimitador   --10)
            ||NVL(Lr_Datos.FE_CREACION_PTO, '')||Lv_Delimitador         --11)
            ||NVL(Lr_Datos.FE_CREACION_SERVICIO, '')||Lv_Delimitador    --12)
            ||NVL(Lr_Datos.FE_FACTIBLE, '')||Lv_Delimitador             --13)
            ||NVL(Lr_Datos.CANAL_VENTA, '')||Lv_Delimitador             --14)
            ||NVL(Lr_Datos.PUNTO_VENTA, '')||Lv_Delimitador             --15)
            ||NVL(Lr_Datos.FORMA_PAGO, '')||Lv_Delimitador              --16)
            ||NVL(Lr_Datos.DESCRIPCION_BANCO, '')||Lv_Delimitador       --17)
            ||NVL(Lr_Datos.DESCRIPCION_CUENTA, '')||Lv_Delimitador      --18)
            ||NVL(Lr_Datos.ESTADO_CONTRATO, '')||Lv_Delimitador         --19)
            ||NVL(Lr_Datos.COSTO_INSTALACION, '')||Lv_Delimitador       --20)
            ||NVL(Lr_Datos.CORTESIA, '')||Lv_Delimitador                --21)
            ||NVL(Lr_Datos.NUMERO_FACTURA, '')||Lv_Delimitador          --22)
            ||NVL(Lr_Datos.ESTADO_FACTURA, '')||Lv_Delimitador          --23)
            ||NVL(Lr_Datos.NUMERO_PAGO, '')||Lv_Delimitador             --24)
            ||NVL(Lr_Datos.FE_CREACION_PAGO, '')||Lv_Delimitador        --25)
            ||NVL(Lr_Datos.OBSERVACION_PAGO, '')||Lv_Delimitador        --26)
            ||NVL(Lr_Datos.ULTIMA_MILLA, '')||Lv_Delimitador            --27)
            ||NVL(Lr_Datos.SEGMENTO, '')||Lv_Delimitador                --28)
            ||NVL(Lr_Datos.TIPO_CONTRATO, '')||Lv_Delimitador           --29)
            ||NVL(Lr_Datos.PLAN_PRODUCTO, '')||Lv_Delimitador           --30)
            ||Lv_DocsEntregables
            );
    END LOOP; 

    UTL_FILE.fclose(Lfile_Archivo);
    DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip,
                                              'text/html; charset=UTF-8');

    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);
    --
    --INSERTO HISTORIAL DE REPORTE DETALLADO GENERADO
    --
    INSERT INTO DB_FINANCIERO.INFO_REPORTE_HISTORIAL
    (ID_REPORTE_HISTORIAL,
    EMPRESA_COD,
    CODIGO_TIPO_REPORTE,
    USR_CREACION,
    FE_CREACION,
    EMAIL_USR_CREACION,
    APLICACION,
    ESTADO,
    OBSERVACION) 
    VALUES
    (DB_FINANCIERO.SEQ_INFO_REPORTE_HISTORIAL.NEXTVAL,
    Pv_PrefijoEmpresa,
    'RPT_DET_APRCONT',
    Pv_UsrSesion,
    SYSDATE,
    Lv_AliasCorreos,
    'Telcos',
    'Activo',
    'Reporte Detallado de Gesti�n de Administraci�n de Contratos en base a los parametros:'||
    '</br> Fecha PrePlanificaci�n Desde: <b>'||TO_DATE(Pv_FechaPrePlanificacionDesde,'DD/MM/YY')||
'</b> Hasta: <b>'||(TO_DATE(Pv_FechaPrePlanificacionHasta,'DD/MM/YY')-1)||'</b>'||
    '</br> Puntos Cobertura: <b>'||Lv_DescPtosCobertura||'</b>');
    --
    --
    ---------------------------------------------------------------------
    --GENERO REPORTE RESUMIDO DE GESTION DE ADMINISTRACION DE CONTRATROS
    ---------------------------------------------------------------------
    Lv_Query:=' SELECT  
    SOLICITUD.FECHA_PREPLANIFICACION,
    AJ.NOMBRE_JURISDICCION,
    CANAL_PTOVTA.CANAL,
    CANAL_PTOVTA.PUNTO_VENTA,
    SUM(CASE WHEN ISE.ESTADO IN (''EnPruebas'',''Activo'',''Asignada'') THEN  1 ELSE 0 END) AS SUM_APROBADOS,
    SUM(CASE WHEN ISE.ESTADO IN (''Anulado'',''Rechazada'',''Rechazado'') THEN  1 ELSE 0 END) AS SUM_RECHAZADOS
      --
      FROM DB_COMERCIAL.INFO_PERSONA IPE
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL         IPER ON IPER.PERSONA_ID           = IPE.ID_PERSONA
      JOIN DB_COMERCIAL.INFO_PUNTO                       IP   ON IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
      JOIN DB_GENERAL.ADMI_JURISDICCION                  AJ   ON AJ.ID_JURISDICCION        = IP.PUNTO_COBERTURA_ID
      JOIN DB_COMERCIAL.INFO_SERVICIO                    ISE  ON ISE.PUNTO_ID              = IP.ID_PUNTO
      JOIN DB_COMERCIAL.INFO_EMPRESA_ROL                 IER  ON IPER.EMPRESA_ROL_ID       = IER.ID_EMPRESA_ROL 
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO               EMPG ON IER.EMPRESA_COD           = EMPG.COD_EMPRESA
      JOIN DB_COMERCIAL.ADMI_ROL                         AR   ON AR.ID_ROL                 = IER.ROL_ID
      JOIN DB_COMERCIAL.ADMI_TIPO_ROL                    ATR  ON ATR.ID_TIPO_ROL           = AR.TIPO_ROL_ID   
      --
      JOIN (      
          SELECT DS.SERVICIO_ID, NVL(TO_CHAR( DSH.FE_CREACION, ''DD-MM-YYYY''),'' '') AS FECHA_PREPLANIFICACION
            FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS
            JOIN DB_COMERCIAL.INFO_DETALLE_SOL_HIST DSH ON DS.ID_DETALLE_SOLICITUD  = DSH.DETALLE_SOLICITUD_ID
            JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS    ON DS.TIPO_SOLICITUD_ID     = TS.ID_TIPO_SOLICITUD
            LEFT JOIN DB_COMERCIAL.INFO_PERSONA IPE     ON IPE.LOGIN                = DSH.USR_CREACION
            WHERE       
            TS.DESCRIPCION_SOLICITUD  = ''SOLICITUD PLANIFICACION''
            AND DSH.ESTADO            = ''PrePlanificada''
      ) SOLICITUD ON SOLICITUD.SERVICIO_ID = ISE.ID_SERVICIO
      --
      --
    LEFT JOIN(
            SELECT 
            PTO.ID_PUNTO,
            PTO.LOGIN,
            PTO.ESTADO,
            PTOCA.VALOR,
            PAD.VALOR4 AS CANAL,
            PAD.VALOR2 AS PUNTO_VENTA
            FROM INFO_PUNTO PTO,
            DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA PTOCA, 
            DB_COMERCIAL.ADMI_CARACTERISTICA CARA,
            DB_GENERAL.ADMI_PARAMETRO_CAB PAC,
            DB_GENERAL.ADMI_PARAMETRO_DET PAD
            WHERE 
            PTO.ID_PUNTO                            = PTOCA.PUNTO_ID
            AND PTOCA.CARACTERISTICA_ID             = CARA.ID_CARACTERISTICA
            AND PAC.ID_PARAMETRO                    = PAD.PARAMETRO_ID
            AND CARA.DESCRIPCION_CARACTERISTICA     = ''PUNTO_DE_VENTA_CANAL''
            AND PAC.NOMBRE_PARAMETRO                = ''CANALES_PUNTO_VENTA''
            AND DBMS_LOB.SUBSTR(PTOCA.VALOR,4000,1) = PAD.VALOR1
      ) CANAL_PTOVTA ON CANAL_PTOVTA.ID_PUNTO       = IP.ID_PUNTO
      --
      WHERE
      ATR.DESCRIPCION_TIPO_ROL = ''Cliente''
      AND EMPG.PREFIJO        =  '''||Pv_PrefijoEmpresa||'''
      AND ISE.ESTADO IN (''EnPruebas'',''Activo'',''Asignada'',''Anulado'',''Rechazada'',''Rechazado'')
      AND EXISTS (SELECT 1                  
                  FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS
                  JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS ON DS.TIPO_SOLICITUD_ID=TS.ID_TIPO_SOLICITUD
                  WHERE TS.DESCRIPCION_SOLICITUD = ''SOLICITUD PLANIFICACION''
                  AND DS.SERVICIO_ID             = ISE.ID_SERVICIO) ';
    --              
    IF Pv_IdsPtoCobertura IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND AJ.ID_JURISDICCION IN ('|| Pv_IdsPtoCobertura ||')';
        --
    END IF;  
    --
    IF Pv_FechaPrePlanificacionDesde IS NOT NULL AND Pv_FechaPrePlanificacionHasta IS NOT NULL THEN
        --              
        Lv_Query := Lv_Query || ' AND  ISE.ID_SERVICIO IN ( SELECT DS.SERVICIO_ID
                                                            FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS
                                                            JOIN DB_COMERCIAL.INFO_DETALLE_SOL_HIST DSH 
                                                            ON DS.ID_DETALLE_SOLICITUD = DSH.DETALLE_SOLICITUD_ID
                                                            JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS
                                                            ON DS.TIPO_SOLICITUD_ID    = TS.ID_TIPO_SOLICITUD
                                                            WHERE TS.DESCRIPCION_SOLICITUD = ''SOLICITUD PLANIFICACION''
                                                            AND DSH.ESTADO                 = ''PrePlanificada''
                                                            AND DS.SERVICIO_ID             = ISE.ID_SERVICIO
                                                            AND DSH.FE_CREACION 
                                                            BETWEEN TO_DATE('''||Pv_FechaPrePlanificacionDesde||''',''DD/MM/YY'') 
                                                            AND     TO_DATE('''||Pv_FechaPrePlanificacionHasta||''',''DD/MM/YY'') 
                                                          ) ';
    --                                                          
    END IF;
    Lv_Query:=  Lv_Query || ' GROUP BY (SOLICITUD.FECHA_PREPLANIFICACION,AJ.NOMBRE_JURISDICCION,CANAL_PTOVTA.CANAL,CANAL_PTOVTA.PUNTO_VENTA)
                  ORDER BY SOLICITUD.FECHA_PREPLANIFICACION,AJ.NOMBRE_JURISDICCION,CANAL_PTOVTA.CANAL,CANAL_PTOVTA.PUNTO_VENTA ';

    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_RES_APRCONT');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
    Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';

    Lfile_ArchivoResumen := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivoResumen,'w',3000); 

    -- CABECERA DEL REPORTE RESUMEN
    utl_file.put_line(Lfile_ArchivoResumen,'USUARIO QUE GENERA: '||Pv_UsrSesion||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||'FECHA DE GENERACION:  '||TO_CHAR(SYSDATE, 'DD-MM-YYYY, HH24:MI:SS')||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          );

    utl_file.put_line(Lfile_ArchivoResumen,'DESDE: '||TO_DATE(Pv_FechaPrePlanificacionDesde,'DD/MM/YY')||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||'HASTA: '||(TO_DATE(Pv_FechaPrePlanificacionHasta,'DD/MM/YY')-1)||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          );
    utl_file.put_line(Lfile_ArchivoResumen,'PTOS COBERTURA: '||Lv_DescPtosCobertura||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador
          );

    utl_file.put_line(Lfile_ArchivoResumen,'Formato Resumen de Gestion de Administracion de Contratos'||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
            );
      utl_file.put_line(Lfile_ArchivoResumen,' '||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||' APROBADOS '||Lv_Delimitador 
          ||' '||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' RECHAZADOS '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
            );      
      utl_file.put_line(Lfile_ArchivoResumen,'FECHA DE PREPLANIFICACION'||Lv_Delimitador  --1)
          ||'PTO. COBERTURA'||Lv_Delimitador --2)
          ||'CANAL_VENTA'||Lv_Delimitador --3)
          ||'PUNTO_VENTA'||Lv_Delimitador --4)
          ||'TOTAL'||Lv_Delimitador --5)
          ||' '||Lv_Delimitador --6)
          ||'PTO. COBERTURA'||Lv_Delimitador --7)
          ||'CANAL_VENTA'||Lv_Delimitador --8)
          ||'PUNTO_VENTA'||Lv_Delimitador --9)
          ||'TOTAL'||Lv_Delimitador --10)
          ); 

    OPEN Lc_ResumenAprobContratos FOR Lv_Query;
    LOOP
    FETCH Lc_ResumenAprobContratos INTO Lr_DatosResumen;
    EXIT
    WHEN Lc_ResumenAprobContratos%NOTFOUND; 

    UTL_FILE.PUT_LINE(Lfile_ArchivoResumen,NVL(Lr_DatosResumen.FE_PREPLANIFICACION, '')||Lv_Delimitador --1)
            ||NVL(Lr_DatosResumen.PTO_COBERTURA, '')||Lv_Delimitador  --2)
            ||NVL(Lr_DatosResumen.CANAL_VENTA, '')||Lv_Delimitador --3)
            ||NVL(Lr_DatosResumen.PUNTO_VENTA, '')||Lv_Delimitador    --4)
            ||NVL(Lr_DatosResumen.SUM_APROBADOS, '')||Lv_Delimitador    --5)
            ||' '||Lv_Delimitador --6)
            ||NVL(Lr_DatosResumen.PTO_COBERTURA, '')||Lv_Delimitador  --7)
            ||NVL(Lr_DatosResumen.CANAL_VENTA, '')||Lv_Delimitador --8)
            ||NVL(Lr_DatosResumen.PUNTO_VENTA, '')||Lv_Delimitador    --9)
            ||NVL(Lr_DatosResumen.SUM_RECHAZADOS, '')||Lv_Delimitador    --10)
    ); 
    END LOOP; 
    --
    UTL_FILE.fclose(Lfile_ArchivoResumen);
    DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_GzipResumen) ) ;
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente,
                                              Lv_Destinatario,
                                              Lv_AsuntoResumen,
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZipResumen,
                                              'text/html; charset=UTF-8');

    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZipResumen); 
    --
    --INSERTO HISTORIAL DE REPORTE RESUMIDO GENERADO
    --
    INSERT INTO DB_FINANCIERO.INFO_REPORTE_HISTORIAL
    (ID_REPORTE_HISTORIAL,
    EMPRESA_COD,
    CODIGO_TIPO_REPORTE,
    USR_CREACION,
    FE_CREACION,
    EMAIL_USR_CREACION,
    APLICACION,
    ESTADO,
    OBSERVACION) 
    VALUES
    (DB_FINANCIERO.SEQ_INFO_REPORTE_HISTORIAL.NEXTVAL,
    Pv_PrefijoEmpresa,
    'RPT_RES_APRCONT',
    Pv_UsrSesion,
    SYSDATE,
    Lv_AliasCorreos,
    'Telcos',
    'Activo',
    'Reporte Resumen de Gesti�n de Administraci�n de Contratos en base a los parametros:'||
    '</br> Fecha PrePlanificaci�n Desde: <b>'||TO_DATE(Pv_FechaPrePlanificacionDesde,'DD/MM/YY')||'</b> Hasta: <b>'
||(TO_DATE(Pv_FechaPrePlanificacionHasta,'DD/MM/YY')-1)||'</b>'||
    '</br> Puntos Cobertura: <b>'||Lv_DescPtosCobertura||'</b>');
    --
    --
    COMMIT;

    EXCEPTION
      WHEN OTHERS THEN
        --
        Pv_MsjResultado      := 'Error al generar el reporte.'; 

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_REPORTE_APROB_CONTRATOS.P_REPORTE_APROBACION_CONTRATOS', 
                                              SQLERRM,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_REPORTE_APROBACION_CONTRATOS;
  --
  --
  END CMKG_REPORTE_APROB_CONTRATOS;
/