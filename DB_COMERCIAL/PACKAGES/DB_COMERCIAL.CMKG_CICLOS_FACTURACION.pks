CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_CICLOS_FACTURACION AS 

  /**
  * Se agregan types necesarios para Generación del Listado de Clientes a realizar Cambio de Ciclo de Facturación
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 19-09-2017
  */

  TYPE Lr_ListadoDatos IS RECORD(TOTAL_REGISTRO NUMBER);
  --
  TYPE Lt_Result IS TABLE OF Lr_ListadoDatos;
  --
  TYPE Lrf_Result IS REF CURSOR;
  --
  TYPE Lr_ListClientesCambioCiclo IS RECORD (
          ID_QUERY                   NUMBER,
          ID_SERVICIO                DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
          ID_PERSONA_ROL             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
          IDENTIFICACION             DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
          NOMBRE_CLIENTE             VARCHAR2(500), 
          LOGIN_PUNTO                DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
          FORMA_PAGO                 DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,         
          DESCRIPCION_CUENTA         DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
          DESCRIPCION_BANCO          DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE, 
          VALOR_RECURRENTE           VARCHAR2(100),   
          SALDO_DEUDOR               VARCHAR2(100),
          NOMBRE_CICLO               DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE,
          ESTADO_SERV                DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
          PTO_COBERTURA              DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
          PLAN_PRODUCTO              VARCHAR2(500)                    
    );  
   TYPE Lr_GrupoClientesCambioCiclo IS RECORD (            
          ID_PERSONA_ROL             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
          IDENTIFICACION             DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
          NOMBRE_CLIENTE             VARCHAR2(500),          
          FORMA_PAGO                 DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,         
          DESCRIPCION_CUENTA         DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
          DESCRIPCION_BANCO          DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,          
          NOMBRE_CICLO               DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE            
    );  

  /**
   * Documentacion para la funcion F_GET_VARCHAR_CLEAN
   * Funcion que limpia caracteres especiales
   *
   * Fv_Cadena IN VARCHAR2 (Recibe la cadena a limpiar)
   * Retorna:  En tipo varchar2 la cadena sin caracteres especiales
   *
   * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
   * @version 1.0 15-09-2017
   */
  FUNCTION F_GET_VARCHAR_CLEAN(
      Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2;  

  /**
  * Documentación para PROCEDURE 'P_GET_CLIENTES_CAMBIO_CICLO'.
  * Procedure que me permite obtener Listado de clientes a los cuales se realizara Cambio de Ciclo de Facturación
  * en base a filtros de Busqueda enviados por parametros
  *
  * PARAMETROS:
  * @Param Pv_Identificacion      IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE (Identificación del Cliente)
  * @Param Pv_NombreCliente       IN  VARCHAR2 ( Nombre o Razón Social del Cliente )
  * @Param Pn_IdCicloFacturacion  IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE ( Id del Ciclo de Facturación)
  * @Param Pv_IdsEstadoServicio   IN  VARCHAR2( Ids del parametro Det correspondiente a los estados de servicios)
  * @Param Pv_IdsPtoCobertura     IN  VARCHAR2 ( Ids para filtrar por puntos de cobertura )
  * @Param Pn_IdFormaPago         IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE ( Id de la forma de pago)
  * @Param Pv_EsTarjeta           IN  VARCHAR2 ( Identifica si es Tarjeta S/N)
  * @Param Pv_IdsTipoCuenta       IN  VARCHAR2 ( Ids para filtrar los tipos de cuenta )
  * @Param Pv_IdsBancos           IN  VARCHAR2 ( Ids para filtrar los Bancos )
  * @Param Pv_CodEmpresa          IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Codigo Empresa en sesion)
  * @Param Pv_PrefijoEmpresa      IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de empresa en sesion)
  * @Param Pv_UsrSesion           IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Usuario en sesion)   
  * @Param Pn_Start               IN  NUMBER (Rango inicial de consulta)
  * @Param Pn_Limit               IN  NUMBER (Rango final consulta) 
  * @param Pn_TotalRegistros      OUT NUMBER (Total de registros obtenidos de la consulta)
  * @param Pc_Registros           OUT SYS_REFCURSOR (Cursor con los Registros obtenidos de la consulta)
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 15-09-2017
  */
  PROCEDURE P_GET_CLIENTES_CAMBIO_CICLO(
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_NombreCliente                IN  VARCHAR2,
    Pn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Pv_IdsEstadoServicio            IN  VARCHAR2, 
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
    Pv_EsTarjeta                    IN  VARCHAR2,
    Pv_IdsTipoCuenta                IN  VARCHAR2,
    Pv_IdsBancos                    IN  VARCHAR2,
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pn_Start                        IN  NUMBER,
    Pn_Limit                        IN  NUMBER,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Registros                    OUT SYS_REFCURSOR
  );

  /**
  * Documentación para la función 'F_GET_CLIENTES_CAMBIO_CICLO'.
  * Función que me permite obtener Listado de clientes a los cuales se realizara Cambio de Ciclo de Facturación
  * en base a filtros de Busqueda enviados por parametros
  * Costo: 26
  * PARAMETROS:
  * @Param Fv_Identificacion      IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE (Identificación del Cliente)
  * @Param Fv_NombreCliente       IN  VARCHAR2 ( Nombre o Razón Social del Cliente )
  * @Param Fn_IdCicloFacturacion  IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE ( Id del Ciclo de Facturación)
  * @Param Fv_IdsEstadoServicio   IN  VARCHAR2( Ids del parametro Det correspondiente a los estados de servicios)
  * @Param Fv_IdsPtoCobertura     IN  VARCHAR2 ( Ids para filtrar por puntos de cobertura )
  * @Param Fn_IdFormaPago         IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE ( Id de la forma de pago)
  * @Param Fv_EsTarjeta           IN  VARCHAR2 ( Identifica si es Tarjeta S/N)
  * @Param Fv_IdsTipoCuenta       IN  VARCHAR2 ( Ids para filtrar los tipos de cuenta )
  * @Param Fv_IdsBancos           IN  VARCHAR2 ( Ids para filtrar los Bancos )
  * @Param Fv_CodEmpresa          IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Codigo Empresa en sesion)
  * @Param Fv_PrefijoEmpresa      IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de empresa en sesion)
  * @Param Fv_UsrSesion           IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Usuario en sesion   
  * @Param Fn_Start               IN  NUMBER (Rango inicial de consulta)
  * @Param Fn_Limit               IN  NUMBER (Rango final de consulta)
  * @param Fn_TotalRegistros      OUT NUMBER (Total de registros obtenidos de la consulta)
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-09-2017
  */
  FUNCTION F_GET_CLIENTES_CAMBIO_CICLO(
    Fv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fv_NombreCliente                IN  VARCHAR2,
    Fn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,  
    Fv_IdsEstadoServicio            IN  VARCHAR2,
    Fv_IdsPtoCobertura              IN  VARCHAR2,
    Fn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
    Fv_EsTarjeta                    IN  VARCHAR2,
    Fv_IdsTipoCuenta                IN  VARCHAR2,
    Fv_IdsBancos                    IN  VARCHAR2,
    Fv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Fn_Start                        IN  NUMBER,
    Fn_Limit                        IN  NUMBER,
    Fn_TotalRegistros               OUT NUMBER
  )
    RETURN SYS_REFCURSOR; 

  /**
  * Funcion que sirve para obtener el total de los registros consultados
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0  18-09-2017
  * @param  Lcl_Consulta IN CLOB (Sql que se consulta)
  * @return NUMBER  Cantidad de registros
  */  
  FUNCTION F_GET_COUNT_REFCURSOR(
      Lcl_Consulta IN CLOB)
    RETURN NUMBER;  

/**
  * Documentación para F_INFO_CLIENTE_PORPTOFACT
  * Retorna Informacion del Cliente segun el tipo de informacion que desea obtener como:
  * Valor Recurrente de Facturacion: Valor Total de la sumatoria de los servicios definidos como PREFERENCIALES en estado Activos e In-Corte
  * marcados como VENTA y Ciclicos mensual
  * Saldo deudor : Saldo Total del Cliente, sumatoria de los saldos por todos los Puntos que posee el cliente
  * Punto de cobertura: Jurisdiccion del Login atado a un servicio Preferencial , obtener maxima Jurisdiccion por cliente
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 20-10-2017
  *
  * @param   Fv_TipoInformacion IN VARCHAR2 (Tipo de campo a obtener en la informacion)
  * @param   Fn_IdPersonaRol    IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL%TYPE (Id del cliente)  
  *
  * @return VARCHAR2   Retorna Informacion del cliente
  */
 FUNCTION F_INFO_CLIENTE_PORPTOFACT(
    Fv_TipoInformacion     IN VARCHAR2,
    Fn_IdPersonaRol        IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN VARCHAR2;
        
/**
  * Documentación para F_INFORMACION_CONTRATO_CLI
  * Retorna Informacion del Contrato por cliente segun el estado y por el tipo de informacion que desea obtener
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-09-2017
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
  * Documentación para PROCEDURE 'P_CREA_PM_CAMBIO_CICLO'.
  * Procedure que me permite crear un Proceso Masivo por Cambio de Ciclo de Facturación.
  * Procedure que genera un Proceso Masivo de Cambio de Ciclo de Facturacion, en base a parametros enviados.
  * El metodo incluira en el PMA de Cambio de Ciclo a todos los Clientes que hayan sido previamente escogidos o
  * marcados en el proceso, asignando el nuevo Ciclo escogido.
  * PARAMETROS:
  * @Param Pv_IdsPersonaRol            IN  VARCHAR2 ( ids de Clientes a los cuales se realizara el cambio de ciclo.)
  * @Param Pn_IdCicloFacturacionNuevo  IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE ( Id del Ciclo de Facturación)
  * @Param Pv_IdsPtoCobertura          IN  VARCHAR2 (Ids de Puntos de Cobertura)
  * @Param Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Codigo Empresa en sesion)
  * @Param Pv_PrefijoEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de empresaen sesion)
  * @Param Pv_UsrSesion                IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Usuario en sesion)   
  * @Param Pv_MsjResultado             OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)
  
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-09-2017
  */
  PROCEDURE P_CREA_PM_CAMBIO_CICLO(
    Pv_IdsPersonaRol                IN  CLOB,  
    Pn_IdCicloFacturacionNuevo      IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,    
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_MsjResultado                 OUT VARCHAR2  
  ); 
  
  /**
   * Documentación para P_ANULA_CAMBIO_CICLO_PMA
   * Procedimiento que anula los procesos en ejecución.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 26-02-2018
   */
  PROCEDURE P_ANULA_CAMBIO_CICLO_PMA;

  /**
  * Documentación para PROCEDURE 'P_CREA_PM_CMB_CICLO_TODOS'.
  * Procedure que me permite crear un Proceso Masivo por Cambio de Ciclo de Facturación.
  * El metodo incluira en el PMA de Cambio de Ciclo a todos los Clientes que esten incluidos en los criterios 
  * o filtros seleccionados por pantalla, asignando el nuevo Ciclo escogido.
  * PARAMETROS:
  * @Param Pn_IdCicloFacturacionNuevo      IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
  * @Param Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE, Ced/Ruc/Pas del cliente
  * @Param Pv_NombreCliente                IN  VARCHAR2, Nombre o Razon Social del cliente
  * @Param Pn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   id de ciclo actual del cliente
  * @Param Pv_IdsEstadoServicio            IN  VARCHAR2, Id de Estado de ciclo (Parametizado en Base)
  * @Param Pv_IdsPtoCobertura              IN  VARCHAR2, Ids de los Puntos de Cobertura o Jurisdiccion de los logines del cliente.
  * @Param Pn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
  * @Param Pv_EsTarjeta                    IN  VARCHAR2, Identifica si es Tarjeta S/N 
  * @Param Pv_IdsTipoCuenta                IN  VARCHAR2, ids para filtrar por Tipo de Cuenta 
  * @Param Pv_IdsBancos                    IN  VARCHAR2, ids para filtrar por Bancos  
  * @Param Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Codigo Empresa en sesion)
  * @Param Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de empresaen sesion)
  * @Param Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Usuario en sesion)   
  * @Param Pv_MsjResultado                 OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)
  
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 13-10-2017
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 - Se validan los filtros para no realizar la misma transacción.
  * @since 26-02-2018
  *
  */
  PROCEDURE P_CREA_PM_CMB_CICLO_TODOS(   
    Pn_IdCicloFacturacionNuevo      IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_NombreCliente                IN  VARCHAR2,
    Pn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Pv_IdsEstadoServicio            IN  VARCHAR2,
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
    Pv_EsTarjeta                    IN  VARCHAR2,
    Pv_IdsTipoCuenta                IN  VARCHAR2,
    Pv_IdsBancos                    IN  VARCHAR2,
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_MsjResultado                 OUT VARCHAR2
  );
  
  /**
  * Documentación para PROCEDURE 'P_GENERAR_RPT_CAMBIO_CICLO'.
  * Procedure que me permite obtener reporte de clientes a los cuales se realizara Cambio de Ciclo de Facturación
  * La consulta se realiza en base a los filtros de busqueda enviados por parametros, genera CSV de la informacion 
  * que será enviado por correo.
  * PARAMETROS:  
  * @Param Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE, Ced/Ruc/Pas del cliente
  * @Param Pv_NombreCliente                IN  VARCHAR2, Nombre o Razon Social del cliente
  * @Param Pn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   id de ciclo actual del cliente
  * @Param Pv_IdsEstadoServicio            IN  VARCHAR2, Id de Estado de ciclo (Parametizado en Base)
  * @Param Pv_IdsPtoCobertura              IN  VARCHAR2, Ids de los Puntos de Cobertura o Jurisdiccion de los logines del cliente.
  * @Param Pn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
  * @Param Pv_EsTarjeta                    IN  VARCHAR2, Identifica si es Tarjeta S/N 
  * @Param Pv_IdsTipoCuenta                IN  VARCHAR2, ids para filtrar por Tipo de Cuenta 
  * @Param Pv_IdsBancos                    IN  VARCHAR2, ids para filtrar por Bancos  
  * @Param Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Codigo Empresa en sesion)
  * @Param Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de empresaen sesion)
  * @Param Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE (Usuario en sesion)   
  * @Param Pv_MsjResultado                 OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)
  
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-10-2017
  */
  
  PROCEDURE P_GENERAR_RPT_CAMBIO_CICLO(       
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_NombreCliente                IN  VARCHAR2,
    Pn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Pv_IdsEstadoServicio            IN  VARCHAR2,
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
    Pv_EsTarjeta                    IN  VARCHAR2,
    Pv_IdsTipoCuenta                IN  VARCHAR2,
    Pv_IdsBancos                    IN  VARCHAR2,
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_MsjResultado                 OUT VARCHAR2
  );
  
  /**
  * Documentación para PROCEDURE 'P_EJECUTA_PM_CAMBIO_CICLO'.
  * Procedure que me permite ejecutar Proceso Masivo por Cambio de Ciclo de Facturación.
  *
  * PARAMETROS:
  * @Param Pn_IdProcesoMasivoCab  IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE
  * @Param Pv_IdsPtoCobertura     IN  VARCHAR2 (Ids de Puntos de Cobertura)
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 25-09-2017
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 - Se modifica el orden para actualizar el PMA.
  * @since 01-03-2018
  * @author Jorge Guerrerop <jguerrerop@telconet.ec>
  * @version 1.2 - Se mejora el query para escribir en el archivo.
  * @since 01-03-2018
  */
  PROCEDURE P_EJECUTA_PM_CAMBIO_CICLO(Pn_IdProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                                      Pv_IdsPtoCobertura    IN  VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_VALIDA_CARACT_ALCANCE'.
  * Procedure que me permite Validar la caracteristica de alcance.
  *
  * PARAMETROS:
  * @Param Pn_Punto  IN  NUMBER (Punto de facturacion)
  * @Param Pn_Servi  IN  NUMBER (id del servicio)
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0 1-12-2017
  */
  PROCEDURE P_VALIDA_CARACT_ALCANCE(Pn_Punto NUMBER,
                                    Pn_Servi NUMBER);

  /**
  * Documentación para PROCEDURE 'P_VALIDA_CARACT_ALCANCE'.
  * Procedure que me permite Validar la caracteristica de alcance.
  *
  * PARAMETROS:
  * @Param Pn_Punto     IN  NUMBER (Punto de facturacion)
  * @Param Pn_Servicio  IN  NUMBER (id del servicio)
  * @Return Number
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0 1-12-2017
  */
  FUNCTION F_GET_SERV_ACTIVOS_CLI(Pn_Punto      NUMBER,
                                  Pn_Servicio   NUMBER)
    RETURN NUMBER;

  /**
   * Documentación para PROCEDURE P_CREA_PARAM_GRUPOS_PROMO
   * Procedure que permite parametrizar los grupos de clientes a procesarse en el mapeo promocional por banco_tipo_cuenta_id y por ciclo de Facturacion 
   * 
   * PARAMETROS:
   * @Param Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
   *
   * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
   * @version 1.0 16-06-2022
   */  
  PROCEDURE P_CREA_PARAM_GRUPOS_PROMO (Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE);
  

END CMKG_CICLOS_FACTURACION;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_CICLOS_FACTURACION AS  
  --
  --

  PROCEDURE P_GET_CLIENTES_CAMBIO_CICLO(
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_NombreCliente                IN  VARCHAR2,
    Pn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Pv_IdsEstadoServicio            IN  VARCHAR2,
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
    Pv_EsTarjeta                    IN  VARCHAR2,
    Pv_IdsTipoCuenta                IN  VARCHAR2,
    Pv_IdsBancos                    IN  VARCHAR2,
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pn_Start                        IN  NUMBER,
    Pn_Limit                        IN  NUMBER,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Registros                    OUT SYS_REFCURSOR
  )
  IS

    Lv_IpCreacion      VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

  BEGIN 

    Pc_Registros := DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_GET_CLIENTES_CAMBIO_CICLO(Pv_Identificacion,
                                                                      Pv_NombreCliente,
                                                                      Pn_IdCicloFacturacion,
                                                                      Pv_IdsEstadoServicio,
                                                                      Pv_IdsPtoCobertura,
                                                                      Pn_IdFormaPago,
                                                                      Pv_EsTarjeta,
                                                                      Pv_IdsTipoCuenta,
                                                                      Pv_IdsBancos,
                                                                      Pv_CodEmpresa,
                                                                      Pv_PrefijoEmpresa,
                                                                      Pv_UsrSesion,
                                                                      Pn_Start,
                                                                      Pn_Limit,
                                                                      Pn_TotalRegistros
                                                                      );

    EXCEPTION
      WHEN OTHERS THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_GET_CLIENTES_CAMBIO_CICLO', 
                                              SQLERRM,
                                              Pv_UsrSesion,
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_GET_CLIENTES_CAMBIO_CICLO;
  --
  --

  FUNCTION F_GET_CLIENTES_CAMBIO_CICLO(
    Fv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fv_NombreCliente                IN  VARCHAR2,
    Fn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Fv_IdsEstadoServicio            IN  VARCHAR2,
    Fv_IdsPtoCobertura              IN  VARCHAR2,
    Fn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
    Fv_EsTarjeta                    IN  VARCHAR2,
    Fv_IdsTipoCuenta                IN  VARCHAR2,
    Fv_IdsBancos                    IN  VARCHAR2,
    Fv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
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

    Lv_IpCreacion      VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    Lc_ClientesAprobContratos  SYS_REFCURSOR;
  --
  BEGIN
    Lv_QueryCount      :='SELECT ISE.ID_SERVICIO ';
    Lv_QueryAllColumns :='SELECT * FROM (SELECT ROWNUM ID_QUERY,
     ISE.ID_SERVICIO,
     IPER.ID_PERSONA_ROL,
     IPE.IDENTIFICACION_CLIENTE AS IDENTIFICACION,     
     CASE
        WHEN IPE.RAZON_SOCIAL IS NULL THEN IPE.NOMBRES||'' ''||IPE.APELLIDOS
        ELSE 
        DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_GET_VARCHAR_CLEAN(TRIM(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     IPE.RAZON_SOCIAL, Chr(9), '' ''), Chr(10), '' ''), 
                                                                     Chr(13), '' '')))                  
        END AS NOMBRE_CLIENTE,
        IP.LOGIN AS LOGIN_PUNTO,    
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_FORMA_PAGO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '')
        AS FORMA_PAGO,
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_CUENTA'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
        AS DESCRIPCION_CUENTA,
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_BANCO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
        AS DESCRIPCION_BANCO,
        ISE.PRECIO_VENTA AS VALOR_RECURRENTE,
        TRIM(TO_CHAR(TRUNC(NVL(DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_SALDO_CLIENTE_BY_PUNTO(ISE.PUNTO_ID), 0),2), 
                               ''99999999990D99'')) AS SALDO_DEUDOR,
        CI.NOMBRE_CICLO AS NOMBRE_CICLO,
        ISE.ESTADO AS ESTADO_SERV,
        NVL(AJ.NOMBRE_JURISDICCION,'' '') AS PTO_COBERTURA,
        DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_GET_VARCHAR_CLEAN(TRIM(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     PLAC.NOMBRE_PLAN, Chr(9), '' ''), Chr(10), '' ''), 
                                                                     Chr(13), '' '')))   AS PLAN_PRODUCTO ';  

    Lv_Query          := ' FROM DB_COMERCIAL.INFO_PERSONA IPE
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL         IPER  ON IPER.PERSONA_ID              = IPE.ID_PERSONA
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC   IPERC ON IPERC.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA              CARAC ON IPERC.CARACTERISTICA_ID      = CARAC.ID_CARACTERISTICA
      JOIN DB_FINANCIERO.ADMI_CICLO                      CI    
      ON COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,''^\d+'')),0) = CI.ID_CICLO
      JOIN DB_COMERCIAL.INFO_PUNTO                       IP    ON IP.PERSONA_EMPRESA_ROL_ID    = IPER.ID_PERSONA_ROL     
      JOIN DB_GENERAL.ADMI_JURISDICCION                  AJ    ON AJ.ID_JURISDICCION           = IP.PUNTO_COBERTURA_ID      
      JOIN DB_COMERCIAL.INFO_SERVICIO                    ISE   ON ISE.PUNTO_ID                 = IP.ID_PUNTO
      JOIN DB_COMERCIAL.INFO_EMPRESA_ROL                 IER   ON IPER.EMPRESA_ROL_ID          = IER.ID_EMPRESA_ROL 
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO               EMPG  ON IER.EMPRESA_COD              = EMPG.COD_EMPRESA
      JOIN DB_COMERCIAL.ADMI_ROL                         AR    ON AR.ID_ROL                    = IER.ROL_ID
      JOIN DB_COMERCIAL.ADMI_TIPO_ROL                    ATR   ON ATR.ID_TIPO_ROL              = AR.TIPO_ROL_ID                
      JOIN DB_COMERCIAL.INFO_PLAN_CAB                    PLAC  ON ISE.PLAN_ID                  = PLAC.ID_PLAN
      JOIN DB_COMERCIAL.INFO_PLAN_DET                    PLAD  ON PLAC.ID_PLAN                 = PLAD.PLAN_ID
      JOIN DB_COMERCIAL.ADMI_PRODUCTO                    PRO   ON PLAD.PRODUCTO_ID             = PRO.ID_PRODUCTO
      WHERE
      ATR.DESCRIPCION_TIPO_ROL              IN  (''Cliente'',''Pre-cliente'')
      AND EMPG.PREFIJO                      =  '''||Fv_PrefijoEmpresa||'''
      AND CARAC.DESCRIPCION_CARACTERISTICA  = ''CICLO_FACTURACION''
      AND CI.ESTADO                         IN (''Activo'',''Inactivo'')
      AND CI.EMPRESA_COD                     = '''||Fv_CodEmpresa||'''
      AND PRO.ES_PREFERENCIA                 = ''SI'' 
      AND IPERC.ESTADO                      = ''Activo''  ';

      IF Fv_Identificacion IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPE.IDENTIFICACION_CLIENTE = '''|| Fv_Identificacion ||''' ';
        --
      END IF;  

      IF Fv_NombreCliente IS NOT NULL THEN
        --
         Lv_Query := Lv_Query || ' AND (UPPER(IPE.RAZON_SOCIAL) LIKE ''%' || Fv_NombreCliente || '%''';
         Lv_Query := Lv_Query || ' OR UPPER(IPE.NOMBRES) LIKE ''%' || Fv_NombreCliente || '%''';
         Lv_Query := Lv_Query || ' OR UPPER(IPE.APELLIDOS) LIKE ''%' || Fv_NombreCliente || '%'' ) ';
        --
      END IF;   

       IF Fn_IdCicloFacturacion IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND CI.ID_CICLO = '|| Fn_IdCicloFacturacion ||'';
        --
      END IF;  

      IF Fv_IdsEstadoServicio <> ' ' THEN
        --
        Lv_Query := Lv_Query || 
        ' AND ISE.ESTADO IN (SELECT VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET PDET WHERE PDET.ID_PARAMETRO_DET IN ('|| Fv_IdsEstadoServicio ||') )';        
        --
      ELSE
        Lv_Query := Lv_Query || 
        ' AND ISE.ESTADO NOT IN (''Anulado'',''Eliminado'',''Reubicado'',''Trasladado'') ';  
      END IF; 

      IF Fv_IdsPtoCobertura <> ' ' THEN
        --
        Lv_Query := Lv_Query || ' AND AJ.ID_JURISDICCION IN ('|| Fv_IdsPtoCobertura ||')';
        --
      END IF;         
      --      
      IF Fn_IdFormaPago IS NOT NULL THEN
      --
        Lv_Query := Lv_Query || 
        ' AND NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''ID_FORMA_PAGO'',
        IPER.ID_PERSONA_ROL,IPER.ESTADO), 0) = '''|| Fn_IdFormaPago ||'''';
      --
      END IF; 

      IF Fv_EsTarjeta IS NOT NULL THEN
      --
        Lv_Query := Lv_Query || 
        ' AND NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''ES_TARJETA'',
        IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') = '''|| Fv_EsTarjeta ||'''';
      --
      END IF; 

     IF Fv_IdsTipoCuenta <> ' '  THEN
        --
        Lv_Query := Lv_Query || 
        ' AND NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''ID_TIPO_CUENTA'',
        IPER.ID_PERSONA_ROL,IPER.ESTADO), 0) IN ('|| Fv_IdsTipoCuenta ||')';
        --
      END IF;   

      IF Fv_IdsBancos <> ' '  THEN
        --
        Lv_Query := Lv_Query ||
        ' AND NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''ID_BANCO'',
        IPER.ID_PERSONA_ROL,IPER.ESTADO), 0) IN ('|| Fv_IdsBancos ||')';
        --
      END IF;   

      IF Fn_Start   IS NOT NULL AND  Fn_Limit  IS NOT NULL THEN
        Lv_LimitAllColumns := ' ) TB WHERE TB.ID_QUERY >= ' || NVL(Fn_Start, 0) ||
        ' AND TB.ID_QUERY <= ' || (NVL(Fn_Start,0) + NVL(Fn_Limit,0)) || ' ORDER BY TB.ID_QUERY' ;
      ELSE
        Lv_LimitAllColumns := ' 
        ORDER BY IPER.ID_PERSONA_ROL ASC
        ) '
        ;
      END IF;     

  Lv_QueryAllColumns := Lv_QueryAllColumns || Lv_Query || Lv_LimitAllColumns;
  Lv_QueryCount      := Lv_QueryCount || Lv_Query;

  OPEN Lc_ClientesAprobContratos FOR Lv_QueryAllColumns;

  Fn_TotalRegistros := CMKG_CICLOS_FACTURACION.F_GET_COUNT_REFCURSOR(Lv_QueryCount);
  --
  RETURN Lc_ClientesAprobContratos;
  --
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                            'CMKG_CICLOS_FACTURACION.F_GET_CLIENTES_CAMBIO_CICLO', 
                                            SQLERRM || ' - QUERY:'|| Lv_QueryAllColumns,
                                            Fv_UsrSesion,
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );

      RETURN NULL;
      --
  END F_GET_CLIENTES_CAMBIO_CICLO;
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
  FUNCTION F_INFO_CLIENTE_PORPTOFACT(
    Fv_TipoInformacion     IN VARCHAR2,
    Fn_IdPersonaRol        IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN VARCHAR2
  IS
  --Costo: 1
  CURSOR C_ValorRecurrente(Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  IS
  SELECT
  TRIM(TO_CHAR(TRUNC(NVL(SUM(SERVHIJOS.PRECIO_VENTA),0),2),'99999999990D99')) AS VALOR_RECURRENTE 
  --
  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPROL
  JOIN DB_COMERCIAL.INFO_PUNTO IPPADRE ON IPROL.ID_PERSONA_ROL = IPPADRE.PERSONA_EMPRESA_ROL_ID
  JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL PDA ON IPPADRE.ID_PUNTO = PDA.PUNTO_ID
  JOIN DB_COMERCIAL.INFO_SERVICIO SERVHIJOS ON SERVHIJOS.PUNTO_FACTURACION_ID = IPPADRE.ID_PUNTO  
  WHERE
  IPROL.ID_PERSONA_ROL              = Cn_IdPersonaRol
  AND PDA.ES_PADRE_FACTURACION      = 'S'  
  AND SERVHIJOS.ES_VENTA            = 'S'
  AND SERVHIJOS.PRECIO_VENTA        > 0  
  AND SERVHIJOS.FRECUENCIA_PRODUCTO = 1 
  AND SERVHIJOS.ESTADO              IN ('Activo','In-Corte')   
  ; 
  --Costo: 1
  CURSOR C_SaldoDeudor(Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  IS
  SELECT 
  TRIM(TO_CHAR(TRUNC(SUM(NVL(DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_SALDO_CLIENTE_BY_PUNTO(IP.ID_PUNTO), 0)),2),'99999999990D99'))
  AS SALDO_DEUDOR
  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPROL
  JOIN DB_COMERCIAL.INFO_PUNTO IP ON IPROL.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID 
  WHERE
  IPROL.ID_PERSONA_ROL = Cn_IdPersonaRol  
  ;  
  --Costo: 1
  CURSOR C_Jurisdiccion(Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  IS
  SELECT IPPADRE.ID_PUNTO,IPPADRE.LOGIN,
  JU.DESCRIPCION_JURISDICCION AS JURISDICCION
  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPROL 
  JOIN DB_COMERCIAL.INFO_PUNTO IPPADRE ON IPROL.ID_PERSONA_ROL = IPPADRE.PERSONA_EMPRESA_ROL_ID
  JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JU ON IPPADRE.PUNTO_COBERTURA_ID=JU.ID_JURISDICCION
  JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL PDA ON IPPADRE.ID_PUNTO = PDA.PUNTO_ID
  WHERE
   IPROL.ID_PERSONA_ROL              = Cn_IdPersonaRol
   AND PDA.ES_PADRE_FACTURACION      = 'S'  
   AND EXISTS (SELECT 1 FROM DB_COMERCIAL.INFO_SERVICIO SERVHIJOS
              WHERE SERVHIJOS.PUNTO_FACTURACION_ID = IPPADRE.ID_PUNTO
              AND SERVHIJOS.ES_VENTA               = 'S'
              AND SERVHIJOS.PRECIO_VENTA           > 0  
              AND SERVHIJOS.FRECUENCIA_PRODUCTO    = 1             
              )
   AND ROWNUM = 1              
  ;  

  CURSOR C_ServClient(Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  IS
    SELECT ISER.ID_SERVICIO,
           ISER.PRECIO_VENTA,
           ISER.PORCENTAJE_DESCUENTO,
           ISER.VALOR_DESCUENTO
    FROM INFO_PERSONA_EMPRESA_ROL IPER,
         INFO_PUNTO IP,
         INFO_SERVICIO ISER
    WHERE IPER.ID_PERSONA_ROL=Cn_IdPersonaRol
    AND IPER.ID_PERSONA_ROL=IP.PERSONA_EMPRESA_ROL_ID
    AND IP.ID_PUNTO=ISER.PUNTO_FACTURACION_ID
    AND ISER.FRECUENCIA_PRODUCTO=1
    AND ISER.ES_VENTA='S'
    AND ISER.PRECIO_VENTA > 0
    AND ISER.ESTADO in ('Activo','In-Corte');

   CURSOR C_SolicitudDesc(Pn_Servicio NUMBER)
      IS
      SELECT id_detalle_solicitud,
              porcentaje_descuento
            FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD
            WHERE id_detalle_solicitud IN
              (SELECT MIN(ids.id_detalle_solicitud)
              FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
              LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
              ON ats.id_tipo_solicitud     =ids.tipo_solicitud_id
              WHERE ids.servicio_id        =Pn_Servicio
              AND ats.descripcion_solicitud='SOLICITUD DESCUENTO UNICO'
              AND ids.estado               ='Aprobado'
              AND rownum                   =1);

    CURSOR C_TotalPreferencial(Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
      SELECT TRIM(TO_CHAR(TRUNC(NVL(SUM(ISER.PRECIO_VENTA),0),2),'99999999990D99')) AS TOTAL_PREFERENCIAL
      FROM INFO_PERSONA_EMPRESA_ROL IPER,
           INFO_PUNTO IP,
           INFO_SERVICIO ISER,
           INFO_PLAN_DET IPD,
           ADMI_PRODUCTO AP
      WHERE IPER.ID_PERSONA_ROL=Cn_IdPersonaRol
      AND IPER.ID_PERSONA_ROL=IP.PERSONA_EMPRESA_ROL_ID
      AND IP.ID_PUNTO=ISER.PUNTO_FACTURACION_ID
      AND ISER.FRECUENCIA_PRODUCTO=1
      AND ISER.ES_VENTA='S'
      AND ISER.PRECIO_VENTA > 0
      AND ISER.ESTADO in ('Activo','In-Corte')
      AND IPD.PLAN_ID=ISER.PLAN_ID
      AND AP.ID_PRODUCTO=IPD.PRODUCTO_ID
      AND AP.ES_PREFERENCIA='SI';

   Lr_ValorRecurrente     C_ValorRecurrente%ROWTYPE;
   Lr_SaldoDeudor         C_SaldoDeudor%ROWTYPE;
   Lr_Jurisdiccion        C_Jurisdiccion%ROWTYPE;   
   Lr_Descuentos          C_ServClient%ROWTYPE;
   Lr_SolicitudDesc       C_SolicitudDesc%ROWTYPE;
   Lr_TotalPreferencial   C_TotalPreferencial%ROWTYPE;
   Lv_DatoPtoFact         VARCHAR2(1000);
   Lv_IpCreacion          VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
   Ln_PorceDesc           NUMBER(9,2):=0;
   Ln_ValorDesc           NUMBER(9,2):=0;
   Ln_AumValorDesc        NUMBER(9,2):=0;
   Ln_ValorImpt           NUMBER(9,2):=0;
   Ln_AumValorImpt        NUMBER(9,2):=0;
   Ln_Porcentaje          NUMBER;
   Lv_DescripcionImpuesto VARCHAR2(100) := 'IVA 12%';
  BEGIN

    IF C_ValorRecurrente%ISOPEN THEN
      CLOSE C_ValorRecurrente;
    END IF;

    IF C_SaldoDeudor%ISOPEN THEN
      CLOSE C_SaldoDeudor;
    END IF;

     IF C_Jurisdiccion%ISOPEN THEN
      CLOSE C_Jurisdiccion;
    END IF;

    IF C_ServClient %ISOPEN THEN
      CLOSE C_ServClient;
    END IF;

    IF Fv_TipoInformacion='SUBTOT_PREFER' THEN

      OPEN C_TotalPreferencial(Fn_IdPersonaRol);
      FETCH C_TotalPreferencial INTO Lr_TotalPreferencial;
      CLOSE C_TotalPreferencial;

      Lv_DatoPtoFact:=Lr_TotalPreferencial.TOTAL_PREFERENCIAL;

    END IF;

    IF Fv_TipoInformacion='TOT_CON_IMP' THEN

      Ln_Porcentaje:=DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_OBTENER_IMPUESTO_POR_DESC(Lv_DescripcionImpuesto);

      FOR I IN C_ServClient(Fn_IdPersonaRol) LOOP

        Ln_ValorImpt := I.PRECIO_VENTA+((I.PRECIO_VENTA*Ln_Porcentaje)/100);
        Ln_AumValorImpt := Ln_AumValorImpt+Ln_ValorImpt;
        Ln_ValorImpt:=0;

      END LOOP;

      Lv_DatoPtoFact:=TRIM(TO_CHAR(TRUNC(NVL(Ln_AumValorImpt, 0),2),'99999999990D99'));

    END IF;

    IF Fv_TipoInformacion='DESCUENTO' THEN

      FOR J IN C_ServClient(Fn_IdPersonaRol) LOOP

        Lr_SolicitudDesc:=NULL;
        OPEN C_SolicitudDesc(J.ID_SERVICIO);
        FETCH C_SolicitudDesc INTO Lr_SolicitudDesc;
        CLOSE C_SolicitudDesc;

        IF Lr_SolicitudDesc.porcentaje_descuento IS NOT NULL THEN
          Ln_PorceDesc:=Lr_SolicitudDesc.porcentaje_descuento;
          Ln_ValorDesc:=(J.PRECIO_VENTA*Ln_PorceDesc)/100;
        ELSIF J.porcentaje_descuento IS NOT NULL THEN
          Ln_PorceDesc:=J.porcentaje_descuento;
          Ln_ValorDesc:=(J.PRECIO_VENTA*Ln_PorceDesc)/100;
        ELSIF J.valor_descuento IS NOT NULL THEN
          Ln_ValorDesc:=J.VALOR_DESCUENTO;
        END IF;

        Ln_AumValorDesc := Ln_AumValorDesc+Ln_ValorDesc;
        Ln_PorceDesc    := 0;
        Ln_ValorDesc    := 0;

      END LOOP;

      Lv_DatoPtoFact:=TRIM(TO_CHAR(TRUNC(NVL(Ln_AumValorDesc, 0),2),'99999999990D99'));

    END IF;

    OPEN C_ValorRecurrente(Fn_IdPersonaRol);
    --
    FETCH C_ValorRecurrente INTO Lr_ValorRecurrente;
    IF(C_ValorRecurrente%FOUND) THEN
    --
       IF Fv_TipoInformacion='VALOR_RECURRENTE' THEN    
          Lv_DatoPtoFact := Lr_ValorRecurrente.VALOR_RECURRENTE; 
       END IF;
    END IF; 
    CLOSE C_ValorRecurrente;
    --
    OPEN C_SaldoDeudor(Fn_IdPersonaRol);
    --
    FETCH C_SaldoDeudor INTO Lr_SaldoDeudor;
    IF(C_SaldoDeudor%FOUND) THEN
    --
       IF Fv_TipoInformacion='SALDO_DEUDOR' THEN    
          Lv_DatoPtoFact := Lr_SaldoDeudor.SALDO_DEUDOR;        
       END IF;
    END IF; 
    CLOSE C_SaldoDeudor;
    --
    OPEN C_Jurisdiccion(Fn_IdPersonaRol);
    --
    FETCH C_Jurisdiccion INTO Lr_Jurisdiccion;
    IF(C_Jurisdiccion%FOUND) THEN
    --
       IF Fv_TipoInformacion='JURISDICCION' THEN    
          Lv_DatoPtoFact := Lr_Jurisdiccion.JURISDICCION; 
       END IF;
    END IF; 
    CLOSE C_Jurisdiccion;
    --
  RETURN Lv_DatoPtoFact;
  --
EXCEPTION
WHEN OTHERS THEN 
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'CMKG_CICLOS_FACTURACION.F_INFO_CLIENTE_PORPTOFACT', 
                                        'Error al obtener información de VALOR RECURRENTE, SALDO DEUDOR y JURISDICCION del cliente
                                        (' || Fv_TipoInformacion || ', ' || Fn_IdPersonaRol || ') - '
                                        || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
  --
  RETURN NULL;
  --
  END F_INFO_CLIENTE_PORPTOFACT;
  --
  --
  FUNCTION F_INFORMACION_CONTRATO_CLI(
      Fv_TipoInformacion IN VARCHAR2,
      Fn_IdPersonaRol    IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fv_Estado          IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE)
    RETURN VARCHAR2
  IS
  -- 
  --Costo: 11  Cursor para obtener la informacion del contrato por cliente y por estado
  CURSOR C_InformacionContrato(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                               Cv_Estado       DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE) IS
  SELECT 
      IC.ID_CONTRATO,
      AFP.ID_FORMA_PAGO,
      AFP.DESCRIPCION_FORMA_PAGO,
      AB.ID_BANCO,
      AB.DESCRIPCION_BANCO,
      ATC.ID_TIPO_CUENTA,
      ATC.DESCRIPCION_CUENTA,
      ATC.ES_TARJETA

      FROM DB_COMERCIAL.INFO_CONTRATO IC
      LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO=IC.FORMA_PAGO_ID
      LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP ON ICFP.CONTRATO_ID=IC.ID_CONTRATO AND ICFP.ESTADO = 'Activo'
      LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC ON ABTC.ID_BANCO_TIPO_CUENTA=ICFP.BANCO_TIPO_CUENTA_ID
      LEFT JOIN DB_GENERAL.ADMI_BANCO AB ON AB.ID_BANCO=ABTC.BANCO_ID
      LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA ATC ON ATC.ID_TIPO_CUENTA= ABTC.TIPO_CUENTA_ID
      WHERE
      IC.ESTADO                     = Cv_Estado  
      AND IC.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
      AND ROWNUM                    = 1;

  --Costo: 9  Cursor para obtener la informacion del contrato por cliente ultimo registro
  CURSOR C_InformacionContratoUlt(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
  SELECT 
      IC.ID_CONTRATO,
      AFP.ID_FORMA_PAGO,
      AFP.DESCRIPCION_FORMA_PAGO,
      AB.ID_BANCO,
      AB.DESCRIPCION_BANCO,
      ATC.ID_TIPO_CUENTA,
      ATC.DESCRIPCION_CUENTA,
      ATC.ES_TARJETA

      FROM DB_COMERCIAL.INFO_CONTRATO IC
      LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO=IC.FORMA_PAGO_ID
      LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP ON ICFP.CONTRATO_ID=IC.ID_CONTRATO
      LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC on ABTC.ID_BANCO_TIPO_CUENTA=ICFP.BANCO_TIPO_CUENTA_ID
      LEFT JOIN DB_GENERAL.ADMI_BANCO AB ON AB.ID_BANCO=ABTC.BANCO_ID
      LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA ATC ON ATC.ID_TIPO_CUENTA= ABTC.TIPO_CUENTA_ID      
      WHERE     
      IC.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
      AND IC.ID_CONTRATO IN (SELECT MAX(CONT.ID_CONTRATO) 
                            FROM DB_COMERCIAL.INFO_CONTRATO CONT
                            WHERE CONT.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol);

      Lr_InformacionContrato     C_InformacionContrato%ROWTYPE;
      Lr_InformacionContratoUlt  C_InformacionContratoUlt%ROWTYPE;
      Lv_DatoContrato            VARCHAR2(1000);
      Lv_IpCreacion              VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
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
        ELSIF Fv_TipoInformacion='ID_CONTRATO' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.ID_CONTRATO;     
        ELSIF Fv_TipoInformacion='ID_FORMA_PAGO' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.ID_FORMA_PAGO;     
        ELSIF Fv_TipoInformacion='ID_TIPO_CUENTA' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.ID_TIPO_CUENTA;         
        ELSIF Fv_TipoInformacion='ID_BANCO' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.ID_BANCO; 
        ELSIF Fv_TipoInformacion='ES_TARJETA' THEN  
            Lv_DatoContrato := Lr_InformacionContrato.ES_TARJETA;         
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
            ELSIF Fv_TipoInformacion='ID_CONTRATO' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.ID_CONTRATO;
            ELSIF Fv_TipoInformacion='ID_FORMA_PAGO' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.ID_FORMA_PAGO;     
            ELSIF Fv_TipoInformacion='ID_TIPO_CUENTA' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.ID_TIPO_CUENTA;         
            ELSIF Fv_TipoInformacion='ID_BANCO' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.ID_BANCO;         
            ELSIF Fv_TipoInformacion='ES_TARJETA' THEN  
                Lv_DatoContrato := Lr_InformacionContratoUlt.ES_TARJETA;         
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
                                        'CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI', 
                                        'Error al obtener la información de contrato (' || Fv_TipoInformacion || ', ' || Fn_IdPersonaRol || ') - '
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
              REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|¿|<|>|/|;|.|,|%|"]|[)]+$', ' ')
              ,'[^A-Za-z0-9ÁÉÍÓÚáéíóúÑñ&()-_ ]' ,' ')
              ,'ÁÉÍÓÚÑ,áéíóúñ', 'AEIOUN aeioun')
              , Chr(9), ' ')
              , Chr(10), ' ')
              , Chr(13), ' ')
              , Chr(59), ' '));
      --

  END F_GET_VARCHAR_CLEAN;
  --
  --
  PROCEDURE P_CREA_PM_CAMBIO_CICLO(
    Pv_IdsPersonaRol                IN  CLOB,  
    Pn_IdCicloFacturacionNuevo      IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,     
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_MsjResultado                 OUT VARCHAR2  
  )
  IS  
  --Costo: 7
  CURSOR C_GetIdPersonaRol (Cn_IdPersonaRol    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                            Cv_PrefijoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
  IS
  SELECT IPER.ID_PERSONA_ROL
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
      DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG,
      DB_GENERAL.ADMI_TIPO_ROL ATR,
      DB_GENERAL.ADMI_ROL AR
    WHERE IPER.EMPRESA_ROL_ID    = IER.ID_EMPRESA_ROL
    AND IER.EMPRESA_COD          = IEG.COD_EMPRESA    
    AND IER.ROL_ID               = AR.ID_ROL
    AND ATR.ID_TIPO_ROL          = AR.TIPO_ROL_ID
    AND IEG.PREFIJO              = Cv_PrefijoEmpresa
    AND ATR.DESCRIPCION_TIPO_ROL IN ('Cliente','Pre-cliente')
    AND IPER.ID_PERSONA_ROL      = Cn_IdPersonaRol;

    --Costo: 4
    CURSOR C_GetMaxPunto (Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
    SELECT MAX(ID_PUNTO) AS PUNTO_ID
    FROM DB_COMERCIAL.INFO_PUNTO 
    WHERE PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol;

    Lv_IpCreacion         VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_IdPersonaRol       DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE;
    Ln_IdPunto            DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE; 
    Ln_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdProcesoMasivoDet DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;       

  BEGIN  
    Pv_MsjResultado      := 'Se procedio a ejecutar el script de Cambio de Ciclo, favor esperar el email de confirmacion!'; 

    IF C_GetIdPersonaRol%ISOPEN THEN
      --
      CLOSE C_GetIdPersonaRol;
      --
    END IF;
    --
     IF C_GetMaxPunto%ISOPEN THEN
      --
      CLOSE C_GetMaxPunto;
      --
    END IF;
    --
    Ln_IdProcesoMasivoCab := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;

    INSERT INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB 
    (ID_PROCESO_MASIVO_CAB,
    TIPO_PROCESO,
    EMPRESA_ID,
    CANAL_PAGO_LINEA_ID,
    CANTIDAD_PUNTOS,
    CANTIDAD_SERVICIOS,
    FACTURAS_RECURRENTES,
    FECHA_EMISION_FACTURA,
    FECHA_CORTE_DESDE,
    FECHA_CORTE_HASTA,
    VALOR_DEUDA,
    FORMA_PAGO_ID,
    IDS_BANCOS_TARJETAS,
    IDS_OFICINAS,
    ESTADO,
    FE_CREACION,
    FE_ULT_MOD,
    USR_CREACION,
    USR_ULT_MOD,
    IP_CREACION,
    PLAN_ID,
    PLAN_VALOR,
    PAGO_ID,
    PAGO_LINEA_ID,
    RECAUDACION_ID,
    DEBITO_ID,
    ELEMENTO_ID,
    SOLICITUD_ID)
    VALUES
    (Ln_IdProcesoMasivoCab,
    'CicloFacturacion',
    Pv_CodEmpresa,
    NULL,'0','0',NULL,NULL,NULL,NULL,'0',NULL,NULL,NULL,
    'Creado',SYSDATE,null,Pv_UsrSesion,NULL,Lv_IpCreacion,
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,Pn_IdCicloFacturacionNuevo);
    --
    --  
    FOR CURRENT_ROW IN (
        WITH TEST AS
        (SELECT Pv_IdsPersonaRol FROM DUAL)
        SELECT regexp_substr(Pv_IdsPersonaRol, '[^,]+', 1, ROWNUM) SPLIT
        FROM TEST
        CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_IdsPersonaRol, '[^,]+'))  + 1
      )
    LOOP
       OPEN C_GetIdPersonaRol(TO_NUMBER(CURRENT_ROW.SPLIT), Pv_PrefijoEmpresa);
        --
       FETCH C_GetIdPersonaRol INTO Ln_IdPersonaRol;
       IF(Ln_IdPersonaRol IS NOT NULL) THEN
          --
          OPEN C_GetMaxPunto(Ln_IdPersonaRol);
          FETCH C_GetMaxPunto INTO Ln_IdPunto;
          IF(Ln_IdPunto IS NOT NULL) THEN
             --
             -- INSERTO DETALLE DE PROCESO MASIVO
             Ln_IdProcesoMasivoDet := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
             INSERT INTO 
             DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET 
             (ID_PROCESO_MASIVO_DET,
             PROCESO_MASIVO_CAB_ID,
             PUNTO_ID,
             ESTADO,
             FE_CREACION,
             FE_ULT_MOD,
             USR_CREACION,
             USR_ULT_MOD,
             IP_CREACION,
             SERVICIO_ID,
             OBSERVACION,
             SOLICITUD_ID,
             PERSONA_EMPRESA_ROL_ID) 
             VALUES
             (Ln_IdProcesoMasivoDet,
             Ln_IdProcesoMasivoCab,
             Ln_IdPunto,
            'Pendiente',
             SYSDATE,
             NULL,
             Pv_UsrSesion,
             NULL,
             Lv_IpCreacion,
             NULL,
             '',
             null,
             Ln_IdPersonaRol);
             --
          END IF;  
          --
          CLOSE C_GetMaxPunto;
          --
       END IF;
       --
       CLOSE C_GetIdPersonaRol;

    END LOOP;
    --
    --ACTUALIZO CABECERA DE PROCESO MASIVO A PENDIENTE  
    --
    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB 
    SET ESTADO ='Pendiente'
    WHERE ID_PROCESO_MASIVO_CAB = Ln_IdProcesoMasivoCab;
    --
    COMMIT;

    --
    --Genero JOB auto_drop => TRUE para que ejecute el PMA de Cambio de Ciclo y se auto destruya al terminar de procesar.
    --
    SYS.DBMS_SCHEDULER.CREATE_JOB(                               
                                job_name   => '"DB_COMERCIAL"."JOB_PMA_CAMBIOCICLO_'||Ln_IdProcesoMasivoCab||'"',
                                job_type   => 'PLSQL_BLOCK',                        
                                job_action => 'DECLARE
                                               Ln_IdProcMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
                                               Lv_IdsPtoCobert    VARCHAR2(1000);
                                               BEGIN                                               
                                               Ln_IdProcMasivoCab:='''|| Ln_IdProcesoMasivoCab||''';
                                               Lv_IdsPtoCobert   :='''|| Pv_IdsPtoCobertura||''';

                                               DB_COMERCIAL.CMKG_CICLOS_FACTURACION.P_EJECUTA_PM_CAMBIO_CICLO(
                                                             Ln_IdProcMasivoCab,
                                                             Lv_IdsPtoCobert);
                                               END;',
                                number_of_arguments => 0,
                                start_date         => NULL,
                                repeat_interval    => NULL,
                                end_date           => NULL,
                                enabled            => FALSE,
                                auto_drop          => TRUE,
                                comments           => 'Job para ejecutar Proceso Masivo de Cambio de Ciclo de Facturación ');
       SYS.DBMS_SCHEDULER.SET_ATTRIBUTE( 
                                     name      => '"DB_COMERCIAL"."JOB_PMA_CAMBIOCICLO_'||Ln_IdProcesoMasivoCab||'"', 
                                     attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF );
       SYS.DBMS_SCHEDULER.enable(
                             name => '"DB_COMERCIAL"."JOB_PMA_CAMBIOCICLO_'||Ln_IdProcesoMasivoCab||'"');         

    EXCEPTION
      WHEN OTHERS THEN
        --
        Pv_MsjResultado      := 'Error al ejecutar el script de Cambio de Ciclo'; 

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_CREA_PM_CAMBIO_CICLO', 
                                              SQLERRM,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_CREA_PM_CAMBIO_CICLO;
  --
  --
  PROCEDURE P_GENERAR_RPT_CAMBIO_CICLO(       
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_NombreCliente                IN  VARCHAR2,
    Pn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Pv_IdsEstadoServicio            IN  VARCHAR2,
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
    Pv_EsTarjeta                    IN  VARCHAR2,
    Pv_IdsTipoCuenta                IN  VARCHAR2,
    Pv_IdsBancos                    IN  VARCHAR2,
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_MsjResultado                 OUT VARCHAR2
  )
  IS        
    --
    --Costo: 1
    CURSOR C_GetDescPtosCobertura(Cv_IdsPtoCobertura DB_INFRAESTRUCTURA.ADMI_JURISDICCION.ID_JURISDICCION%TYPE)
    IS 
    SELECT IJU.NOMBRE_JURISDICCION AS JURISDICCION
    FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION IJU 
    WHERE IJU.ID_JURISDICCION = Cv_IdsPtoCobertura;
    --
    Lv_Directorio                VARCHAR2(50)   := 'DIR_REPGERENCIA';
    Lv_NombreArchivo             VARCHAR2(150)  := 'Reporte_ClientesAEjecutarCambioCiclo_'||Pv_PrefijoEmpresa||'_'||Pv_UsrSesion||'.csv';
    Lv_Delimitador               VARCHAR2(1)    := '|';
    Lv_Gzip                      VARCHAR2(100)  := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_Remitente                 VARCHAR2(100)  := 'notificaciones_telcos@telconet.ec';    
    Lv_Asunto                    VARCHAR2(300)  := 'Reporte de Clientes consultados para ejecutar Cambio de Ciclo de Facturación ';
    Lv_Cuerpo                    VARCHAR2(9999) := ''; 
    Lv_IpCreacion                VARCHAR2(15)   := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_Total                     NUMBER         := 0;
    Lv_NombreArchivoZip          VARCHAR2(250)  := Lv_NombreArchivo||'.gz';    
    Lc_GetDatos                  SYS_REFCURSOR;   
    Lr_Datos                     Lr_ListClientesCambioCiclo;
    Lc_GetAliasPlantilla         DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo                UTL_FILE.FILE_TYPE;
    Lv_AliasCorreos              VARCHAR2(500);
    Lv_Destinatario              VARCHAR2(500);  
    Lv_DescPtosCobertura         VARCHAR2(4000):='';
    Lv_DesCobertura              VARCHAR2(250);
    Lv_DescEstadosServicios      VARCHAR2(250):='';
    Lv_EstadoServicio            VARCHAR2(60):='';
    Lv_DescFormaPago             VARCHAR2(250):='';
    Lv_DescTiposCuenta           VARCHAR2(4000):='';
    Lv_TipoCuenta                VARCHAR2(250):='';
    Lv_DescBancos                VARCHAR2(4000):='';
    Lv_Banco                     VARCHAR2(250):='';
    Lv_DesFormaPago              DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE;
    Lv_NombreCiclo               DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE;
  BEGIN
    --  
    IF C_GetDescPtosCobertura%ISOPEN THEN
      --
      CLOSE C_GetDescPtosCobertura;
      --
    END IF;
    --
    --JURISDICCIOM
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
          Lv_DescPtosCobertura:= Lv_DescPtosCobertura || '' ||Lv_DesCobertura|| ', ';
      END IF;
      --
      CLOSE C_GetDescPtosCobertura;

      END LOOP;
    --
    IF(Lv_DescPtosCobertura IS NULL) THEN
        Lv_DescPtosCobertura:='Todos';
    END IF;
    --
    --ESTADOS SERVICIO
    IF Pv_IdsEstadoServicio <> ' ' THEN
    FOR CURRENT_ROW IN (
        WITH TEST AS
        (SELECT Pv_IdsEstadoServicio FROM DUAL)
        SELECT regexp_substr(Pv_IdsEstadoServicio, '[^,]+', 1, ROWNUM) SPLIT
        FROM TEST
        CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_IdsEstadoServicio, '[^,]+'))  + 1
      )
      LOOP     
        SELECT VALOR1 INTO Lv_EstadoServicio FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE ID_PARAMETRO_DET=CURRENT_ROW.SPLIT;
        --      
        IF(Lv_EstadoServicio IS NOT NULL) THEN
            Lv_DescEstadosServicios:= Lv_DescEstadosServicios || '' ||Lv_EstadoServicio|| ', ';
        END IF;
        --      
      END LOOP;
    --
    END IF;
    IF(Lv_DescEstadosServicios IS NULL) THEN
        Lv_DescEstadosServicios:='Todos';
    END IF;

    --
    --TIPOS DE CUENTA
    IF Pv_IdsTipoCuenta <> ' '  THEN
    FOR CURRENT_ROW IN (
        WITH TEST AS
        (SELECT Pv_IdsTipoCuenta FROM DUAL)
        SELECT regexp_substr(Pv_IdsTipoCuenta, '[^,]+', 1, ROWNUM) SPLIT
        FROM TEST
        CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_IdsTipoCuenta, '[^,]+'))  + 1
      )
      LOOP     
        SELECT DESCRIPCION_CUENTA INTO Lv_TipoCuenta FROM DB_GENERAL.ADMI_TIPO_CUENTA WHERE ID_TIPO_CUENTA=CURRENT_ROW.SPLIT;
        --      
        IF(Lv_TipoCuenta IS NOT NULL) THEN
            Lv_DescTiposCuenta:= Lv_DescTiposCuenta || '' ||Lv_TipoCuenta|| ', ';
        END IF;
        --      
      END LOOP;
    --
    END IF;    
    IF(Lv_DescTiposCuenta IS NULL) THEN
        Lv_DescTiposCuenta:='Todos';
    END IF;
    --
    --BANCOS
    IF Pv_IdsBancos <> ' '  THEN
    FOR CURRENT_ROW IN (
        WITH TEST AS
        (SELECT Pv_IdsBancos FROM DUAL)
        SELECT regexp_substr(Pv_IdsBancos, '[^,]+', 1, ROWNUM) SPLIT
        FROM TEST
        CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_IdsBancos, '[^,]+'))  + 1
      )
      LOOP     
        SELECT DESCRIPCION_BANCO INTO Lv_Banco FROM DB_GENERAL.ADMI_BANCO WHERE ID_BANCO=CURRENT_ROW.SPLIT;
        --      
        IF(Lv_Banco IS NOT NULL) THEN
            Lv_DescBancos:= Lv_DescBancos || '' ||Lv_Banco|| ', ';
        END IF;
        --      
      END LOOP;
    --
    END IF;
    IF(Lv_DescBancos IS NULL) THEN
        Lv_DescBancos:='Todos';
    END IF;
    --
    --FORMA DE PAGO
    IF Pn_IdFormaPago IS NOT NULL THEN
       SELECT DESCRIPCION_FORMA_PAGO INTO Lv_DesFormaPago FROM DB_GENERAL.ADMI_FORMA_PAGO WHERE ID_FORMA_PAGO=Pn_IdFormaPago;
    END IF;
    --
    IF(Lv_DesFormaPago IS NULL) THEN
        Lv_DesFormaPago:='Todos';
    END IF;
     --
    --FORMA DE PAGO
    IF Pn_IdCicloFacturacion IS NOT NULL THEN
       SELECT NOMBRE_CICLO INTO Lv_NombreCiclo FROM DB_FINANCIERO.ADMI_CICLO WHERE ID_CICLO=Pn_IdCicloFacturacion;
    END IF;
    --
    IF(Lv_NombreCiclo IS NULL) THEN
        Lv_NombreCiclo:=' ';
    END IF;

    --
    --
    Pv_MsjResultado := 'Reporte generado y enviado correctamente .'; 
    Lc_GetDatos := DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_GET_CLIENTES_CAMBIO_CICLO(Pv_Identificacion,
                                                                      Pv_NombreCliente,
                                                                      Pn_IdCicloFacturacion,
                                                                      Pv_IdsEstadoServicio,
                                                                      Pv_IdsPtoCobertura,
                                                                      Pn_IdFormaPago,
                                                                      Pv_EsTarjeta,
                                                                      Pv_IdsTipoCuenta,
                                                                      Pv_IdsBancos,
                                                                      Pv_CodEmpresa,
                                                                      Pv_PrefijoEmpresa,
                                                                      Pv_UsrSesion,
                                                                      NULL,
                                                                      NULL,
                                                                      Ln_Total
                                                                      );
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_CLI_CICLOFA');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
    Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';
    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

    --CABECERA DEL REPORTE
    utl_file.put_line(Lfile_Archivo,'REPORTE DE CLIENTES CONSULTADOS PARA EJECUCION DE CAMBIO DE CICLO DE FACTURACION'||Lv_Delimitador           
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
     utl_file.put_line(Lfile_Archivo,'FECHA DE GENERACION:  '||TO_CHAR(SYSDATE, 'DD-MM-YYYY, HH24:MI:SS')||Lv_Delimitador 
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

     utl_file.put_line(Lfile_Archivo,'IDENTIFICACION: '||Pv_Identificacion||Lv_Delimitador 
          ||' NOMBRE CLIENTE: '||Pv_NombreCliente||Lv_Delimitador           
          ||' CICLO DE FACTURACION'||Lv_NombreCiclo||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador  
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador                               
          );        
     utl_file.put_line(Lfile_Archivo,' ESTADOS SERVICIOS: '||Lv_DescEstadosServicios||Lv_Delimitador 
          ||' JURISDICCION: '||Lv_DescPtosCobertura||Lv_Delimitador 
          ||' FORMAS DE PAGO: '||Lv_DesFormaPago||Lv_Delimitador           
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
      utl_file.put_line(Lfile_Archivo,' POR TARJETA: '||Pv_EsTarjeta||Lv_Delimitador 
          ||' TIPO DE CUENTA: '||Lv_DescTiposCuenta||Lv_Delimitador 
          ||' BANCOS: '||Lv_DescBancos||Lv_Delimitador 
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
       utl_file.put_line(Lfile_Archivo,' '||Lv_Delimitador 
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
     utl_file.put_line(Lfile_Archivo,'CED/RUC/PAS'||Lv_Delimitador            
          ||'NOMBRE CLIENTE'||Lv_Delimitador  
          ||'LOGIN PUNTO'||Lv_Delimitador           
          ||'FORMA PAGO'||Lv_Delimitador 
          ||'DESC.TIPO CUENTA'||Lv_Delimitador 
          ||'DESC. BANCO'||Lv_Delimitador 
          ||'VALOR RECURRENTE FACT'||Lv_Delimitador 
          ||'SALDO DEUDOR'||Lv_Delimitador 
          ||'CICLO DEL CLIENTE'||Lv_Delimitador       
          ||'ESTADO SERVICIO'||Lv_Delimitador
          ||'JURISDICCION'||Lv_Delimitador
          ||'DESCRIPCION PLAN'||Lv_Delimitador
          );   
     LOOP
      FETCH Lc_GetDatos INTO Lr_Datos;
        EXIT
        WHEN Lc_GetDatos%NOTFOUND; 

            UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_Datos.IDENTIFICACION, '')||Lv_Delimitador             
            ||NVL(Lr_Datos.NOMBRE_CLIENTE, '')||Lv_Delimitador 
            ||NVL(Lr_Datos.LOGIN_PUNTO, '')||Lv_Delimitador    
            ||NVL(Lr_Datos.FORMA_PAGO, '')||Lv_Delimitador    
            ||NVL(Lr_Datos.DESCRIPCION_CUENTA,'')||Lv_Delimitador  
            ||NVL(Lr_Datos.DESCRIPCION_BANCO, '')||Lv_Delimitador 
            ||NVL(Lr_Datos.VALOR_RECURRENTE, '')||Lv_Delimitador  
            ||NVL(Lr_Datos.SALDO_DEUDOR, '')||Lv_Delimitador  
            ||NVL(Lr_Datos.NOMBRE_CICLO, '')||Lv_Delimitador  
            ||NVL(Lr_Datos.ESTADO_SERV, '')||Lv_Delimitador  
            ||NVL(Lr_Datos.PTO_COBERTURA, '')||Lv_Delimitador 
            ||NVL(Lr_Datos.PLAN_PRODUCTO, '')||Lv_Delimitador  
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
    --
    --INSERTO HISTORIAL DE REPORTE GENERADO
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
    'RPT_CLI_CICLOFA',
    Pv_UsrSesion,
    SYSDATE,
    Lv_AliasCorreos,
    'Telcos',
    'Activo',
    'Reporte de Clientes consultados para ejecutar Cambio de Ciclo de Facturación :'||
    '</br> Identificación: <b>'||Pv_Identificacion||
    '</br> Nombre Cliente: <b>'||Pv_NombreCliente||
    '</br> Nombre Ciclo:   <b>'||Lv_NombreCiclo||    
    '</br> Estados de Servicios: <b>'||Lv_DescEstadosServicios||
    '</br> Jurisdicciones: <b>'||Lv_DescPtosCobertura||
    '</br> Formas de Pago: <b>'||Lv_DesFormaPago||
    '</br> Tarjeta: <b>'||Pv_EsTarjeta||
    '</br> Tipos de Cuenta: <b>'||Lv_DescTiposCuenta||
    '</br> Bancos: <b>'||Lv_DescBancos||
    '</b>');
    --
    --
    EXCEPTION
      WHEN OTHERS THEN
        --
        Pv_MsjResultado      := 'Error al generar el reporte.';        

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_GENERAR_RPT_CAMBIO_CICLO', 
                                              SQLERRM,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_GENERAR_RPT_CAMBIO_CICLO;

  --
  --
  PROCEDURE P_CREA_PM_CMB_CICLO_TODOS(   
    Pn_IdCicloFacturacionNuevo      IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_NombreCliente                IN  VARCHAR2,
    Pn_IdCicloFacturacion           IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,   
    Pv_IdsEstadoServicio            IN  VARCHAR2,
    Pv_IdsPtoCobertura              IN  VARCHAR2,
    Pn_IdFormaPago                  IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,    
    Pv_EsTarjeta                    IN  VARCHAR2,
    Pv_IdsTipoCuenta                IN  VARCHAR2,
    Pv_IdsBancos                    IN  VARCHAR2,
    Pv_CodEmpresa                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_PrefijoEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_MsjResultado                 OUT VARCHAR2
  )
  IS       
    --Costo: 4
    CURSOR C_GetMaxPunto (Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
    SELECT MAX(ID_PUNTO) AS PUNTO_ID
    FROM DB_COMERCIAL.INFO_PUNTO 
    WHERE PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol;

    Lv_IpCreacion           VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_IdPunto              DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Ln_IdProcesoMasivoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdProcesoMasivoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;
    Lr_DatosClientes        Lr_GrupoClientesCambioCiclo;
    Lv_Query                CLOB;
    Ln_CuentaEjecuciones    NUMBER;
    Le_Error                EXCEPTION;
    Lc_ClientesCambioCiclo  SYS_REFCURSOR;
    Lv_FiltrosBusqueda      VARCHAR2(4000) := 'Pn_IdCicloFacturacionNuevo:' || Pn_IdCicloFacturacionNuevo
                                          || '|Pv_Identificacion:'          || Pv_Identificacion
                                          || '|Pv_NombreCliente:'           || Pv_NombreCliente
                                          || '|Pn_IdCicloFacturacion:'      || Pn_IdCicloFacturacion
                                          || '|Pv_IdsEstadoServicio:'       || Pv_IdsEstadoServicio
                                          || '|Pv_IdsPtoCobertura:'         || Pv_IdsPtoCobertura
                                          || '|Pn_IdFormaPago:'             || Pn_IdFormaPago
                                          || '|Pv_EsTarjeta:'               || Pv_EsTarjeta
                                          || '|Pv_IdsTipoCuenta:'           || Pv_IdsTipoCuenta
                                          || '|Pv_IdsBancos:'               || Pv_IdsBancos
                                          || '|Pv_CodEmpresa:'              || Pv_CodEmpresa
                                          || '|Pv_PrefijoEmpresa:'          || Pv_PrefijoEmpresa;
  BEGIN  
    Pv_MsjResultado      := 'Se procedio a ejecutar el script de Cambio de Ciclo, favor esperar el email de confirmacion!';        
    --
     IF C_GetMaxPunto%ISOPEN THEN
      --
      CLOSE C_GetMaxPunto;
      --
    END IF;
    --    
    --   
     Lv_Query:=' SELECT  
     IPER.ID_PERSONA_ROL,
     IPE.IDENTIFICACION_CLIENTE AS IDENTIFICACION,     
    CASE
        WHEN IPE.RAZON_SOCIAL IS NULL THEN IPE.NOMBRES||'' ''||IPE.APELLIDOS
        ELSE 
        DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_GET_VARCHAR_CLEAN(TRIM(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     IPE.RAZON_SOCIAL, Chr(9), '' ''), Chr(10), '' ''), 
                                                                     Chr(13), '' '')))                  
        END AS NOMBRE_CLIENTE,         
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_FORMA_PAGO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '')
        AS FORMA_PAGO,
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_CUENTA'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
        AS DESCRIPCION_CUENTA,
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_BANCO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') 
        AS DESCRIPCION_BANCO,
        CI.NOMBRE_CICLO AS NOMBRE_CICLO         
      --
      FROM DB_COMERCIAL.INFO_PERSONA IPE
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL         IPER  ON IPER.PERSONA_ID              = IPE.ID_PERSONA
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC   IPERC ON IPERC.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA              CARAC ON IPERC.CARACTERISTICA_ID      = CARAC.ID_CARACTERISTICA
      JOIN DB_FINANCIERO.ADMI_CICLO                      CI    
     ON COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,''^\d+'')),0) = CI.ID_CICLO
      JOIN DB_COMERCIAL.INFO_PUNTO                       IP    ON IP.PERSONA_EMPRESA_ROL_ID    = IPER.ID_PERSONA_ROL     
      JOIN DB_GENERAL.ADMI_JURISDICCION                  AJ    ON AJ.ID_JURISDICCION           = IP.PUNTO_COBERTURA_ID      
      JOIN DB_COMERCIAL.INFO_SERVICIO                    ISE   ON ISE.PUNTO_ID                 = IP.ID_PUNTO
      JOIN DB_COMERCIAL.INFO_EMPRESA_ROL                 IER   ON IPER.EMPRESA_ROL_ID          = IER.ID_EMPRESA_ROL 
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO               EMPG  ON IER.EMPRESA_COD              = EMPG.COD_EMPRESA
      JOIN DB_COMERCIAL.ADMI_ROL                         AR    ON AR.ID_ROL                    = IER.ROL_ID
      JOIN DB_COMERCIAL.ADMI_TIPO_ROL                    ATR   ON ATR.ID_TIPO_ROL              = AR.TIPO_ROL_ID                
      JOIN DB_COMERCIAL.INFO_PLAN_CAB                    PLAC  ON ISE.PLAN_ID                  = PLAC.ID_PLAN
      JOIN DB_COMERCIAL.INFO_PLAN_DET                    PLAD  ON PLAC.ID_PLAN                 = PLAD.PLAN_ID
      JOIN DB_COMERCIAL.ADMI_PRODUCTO                    PRO   ON PLAD.PRODUCTO_ID             = PRO.ID_PRODUCTO

       WHERE
      ATR.DESCRIPCION_TIPO_ROL              IN  (''Cliente'',''Pre-cliente'')
      AND EMPG.PREFIJO                      =  '''||Pv_PrefijoEmpresa||'''
      AND CARAC.DESCRIPCION_CARACTERISTICA  = ''CICLO_FACTURACION''
      AND CI.ESTADO                         IN (''Activo'',''Inactivo'')
      AND CI.EMPRESA_COD                    = '''||Pv_CodEmpresa||'''
      AND PRO.ES_PREFERENCIA                = ''SI'' 
      AND IPERC.ESTADO                      = ''Activo''  ';

    IF Pv_Identificacion IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPE.IDENTIFICACION_CLIENTE = '''|| Pv_Identificacion ||''' ';
        --
      END IF;  

      IF Pv_NombreCliente IS NOT NULL THEN
        --
         Lv_Query := Lv_Query || ' AND (UPPER(IPE.RAZON_SOCIAL) LIKE ''%' || Pv_NombreCliente || '%''';
         Lv_Query := Lv_Query || ' OR UPPER(IPE.NOMBRES) LIKE ''%' || Pv_NombreCliente || '%''';
         Lv_Query := Lv_Query || ' OR UPPER(IPE.APELLIDOS) LIKE ''%' || Pv_NombreCliente || '%'' ) ';
        --
      END IF;   

       IF Pn_IdCicloFacturacion IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND CI.ID_CICLO = '|| Pn_IdCicloFacturacion ||'';
        --
      END IF;  

      IF Pv_IdsEstadoServicio <> ' ' THEN
        --
        Lv_Query := Lv_Query || 
        ' AND ISE.ESTADO IN (SELECT VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET PDET
        WHERE PDET.ID_PARAMETRO_DET IN ('|| Pv_IdsEstadoServicio ||') )';
        --
      ELSE
      Lv_Query := Lv_Query || 
        ' AND ISE.ESTADO NOT IN (''Anulado'',''Eliminado'',''Reubicado'',''Trasladado'') ';
      END IF; 

      IF Pv_IdsPtoCobertura <> ' ' THEN
        --
        Lv_Query := Lv_Query || ' AND AJ.ID_JURISDICCION IN ('|| Pv_IdsPtoCobertura ||')';
        --
      END IF;         
      --      
      IF Pn_IdFormaPago IS NOT NULL THEN
      --
        Lv_Query := Lv_Query || 
        ' AND NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''ID_FORMA_PAGO'',
        IPER.ID_PERSONA_ROL,IPER.ESTADO), 0) = '''|| Pn_IdFormaPago ||'''';
      --
      END IF; 

      IF Pv_EsTarjeta IS NOT NULL THEN
      --
        Lv_Query := Lv_Query || 
        ' AND NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''ES_TARJETA'',
        IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') = '''|| Pv_EsTarjeta ||'''';
      --
      END IF; 

     IF Pv_IdsTipoCuenta <> ' '  THEN
        --
        Lv_Query := Lv_Query || 
        ' AND NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''ID_TIPO_CUENTA'',
        IPER.ID_PERSONA_ROL,IPER.ESTADO), 0) IN ('|| Pv_IdsTipoCuenta ||')';
        --
      END IF;   

      IF Pv_IdsBancos <> ' '  THEN
        --
        Lv_Query := Lv_Query ||
        ' AND NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''ID_BANCO'',
        IPER.ID_PERSONA_ROL,IPER.ESTADO), 0) IN ('|| Pv_IdsBancos ||')';
        --
      END IF;        

       Lv_Query:=  Lv_Query || ' GROUP BY (IPER.ID_PERSONA_ROL,
       IPE.IDENTIFICACION_CLIENTE,
       CASE
        WHEN IPE.RAZON_SOCIAL IS NULL THEN IPE.NOMBRES||'' ''||IPE.APELLIDOS
        ELSE 
        DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_GET_VARCHAR_CLEAN(TRIM(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     IPE.RAZON_SOCIAL, Chr(9), '' ''), Chr(10), '' ''), 
                                                                     Chr(13), '' '')))                  
        END,
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_FORMA_PAGO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' ''),       
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_CUENTA'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') ,        
        NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI(''DESCRIPCION_BANCO'',IPER.ID_PERSONA_ROL,IPER.ESTADO),'' '') ,        
        CI.NOMBRE_CICLO ) ';
     --
     --

    --VALIDO UNA EJECUCIÓN CON LOS MISMOS FILTROS.
    SELECT COUNT(*) INTO Ln_CuentaEjecuciones FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
       WHERE TIPO_PROCESO = 'CicloFacturacion'
         AND ESTADO IN ('Pendiente', 'Procesado', 'Creado')
         AND IDS_BANCOS_TARJETAS = Lv_FiltrosBusqueda;

    IF(Ln_CuentaEjecuciones > 0) THEN
        Pv_MsjResultado      := 'Ya existe un proceso ejecutando el cambio de ciclo con los filtros seleccionados';
        RAISE Le_Error;
    END IF;

    Ln_IdProcesoMasivoCab := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;

    INSERT INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB 
    (ID_PROCESO_MASIVO_CAB,
    TIPO_PROCESO,
    EMPRESA_ID,
    CANAL_PAGO_LINEA_ID,
    CANTIDAD_PUNTOS,
    CANTIDAD_SERVICIOS,
    FACTURAS_RECURRENTES,
    FECHA_EMISION_FACTURA,
    FECHA_CORTE_DESDE,
    FECHA_CORTE_HASTA,
    VALOR_DEUDA,
    FORMA_PAGO_ID,
    IDS_BANCOS_TARJETAS, --ALMACENO LOS FILTROS DE BÚSQUEDA
    IDS_OFICINAS,
    ESTADO,
    FE_CREACION,
    FE_ULT_MOD,
    USR_CREACION,
    USR_ULT_MOD,
    IP_CREACION,
    PLAN_ID,
    PLAN_VALOR,
    PAGO_ID,
    PAGO_LINEA_ID,
    RECAUDACION_ID,
    DEBITO_ID,
    ELEMENTO_ID,
    SOLICITUD_ID)
    VALUES
    (Ln_IdProcesoMasivoCab,
    'CicloFacturacion',
    Pv_CodEmpresa,
    NULL,'0','0',NULL,NULL,NULL,NULL,'0',NULL, Lv_FiltrosBusqueda,NULL,
    'Creado',SYSDATE,null,Pv_UsrSesion,NULL,Lv_IpCreacion,
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,Pn_IdCicloFacturacionNuevo);

    --CONFIRMO LA CABECERA DEL PROCESO MASIVO ANTES DE REALIZAR LA BÚSQUEDA DE LOS CLIENTES.
    COMMIT;
    --
    --     
    OPEN Lc_ClientesCambioCiclo FOR Lv_Query;
    LOOP
    FETCH Lc_ClientesCambioCiclo INTO Lr_DatosClientes;
    EXIT
    WHEN Lc_ClientesCambioCiclo%NOTFOUND; 
          OPEN C_GetMaxPunto(Lr_DatosClientes.ID_PERSONA_ROL);
          FETCH C_GetMaxPunto INTO Ln_IdPunto;
          IF(Ln_IdPunto IS NOT NULL) THEN
             --
             -- INSERTO DETALLE DE PROCESO MASIVO
             Ln_IdProcesoMasivoDet := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
             INSERT INTO 
             DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET 
             (ID_PROCESO_MASIVO_DET,
             PROCESO_MASIVO_CAB_ID,
             PUNTO_ID,
             ESTADO,
             FE_CREACION,
             FE_ULT_MOD,
             USR_CREACION,
             USR_ULT_MOD,
             IP_CREACION,
             SERVICIO_ID,
             OBSERVACION,
             SOLICITUD_ID,
             PERSONA_EMPRESA_ROL_ID) 
             VALUES
             (Ln_IdProcesoMasivoDet,
             Ln_IdProcesoMasivoCab,
             Ln_IdPunto,
            'Pendiente',
             SYSDATE,
             NULL,
             Pv_UsrSesion,
             NULL,
             Lv_IpCreacion,
             NULL,
             '',
             null,
             Lr_DatosClientes.ID_PERSONA_ROL);
             --
          END IF;  
          --
          CLOSE C_GetMaxPunto;
          --
    END LOOP; 
    --
    --ACTUALIZO CABECERA DE PROCESO MASIVO A PENDIENTE  
    --
    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB 
    SET ESTADO ='Pendiente'
    WHERE ID_PROCESO_MASIVO_CAB = Ln_IdProcesoMasivoCab;
    --
    COMMIT;

    --
    --Genero JOB auto_drop => TRUE para que ejecute el PMA de Cambio de Ciclo y se auto destruya al terminar de procesar.
    --
    SYS.DBMS_SCHEDULER.CREATE_JOB(                               
                                job_name   => '"DB_COMERCIAL"."JOB_PMA_CAMBIOCICLO_'||Ln_IdProcesoMasivoCab||'"',
                                job_type   => 'PLSQL_BLOCK',                        
                                job_action => 'DECLARE
                                               Ln_IdProcMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
                                               Lv_IdsPtoCobert    VARCHAR2(1000);
                                               BEGIN                                               
                                               Ln_IdProcMasivoCab:='''|| Ln_IdProcesoMasivoCab||''';
                                               Lv_IdsPtoCobert   :='''|| Pv_IdsPtoCobertura||''';

                                               DB_COMERCIAL.CMKG_CICLOS_FACTURACION.P_EJECUTA_PM_CAMBIO_CICLO(
                                                             Ln_IdProcMasivoCab,
                                                             Lv_IdsPtoCobert);
                                               END;',
                                number_of_arguments => 0,
                                start_date         => NULL,
                                repeat_interval    => NULL,
                                end_date           => NULL,
                                enabled            => FALSE,
                                auto_drop          => TRUE,
                                comments           => 'Job para ejecutar Proceso Masivo de Cambio de Ciclo de Facturación ');
       SYS.DBMS_SCHEDULER.SET_ATTRIBUTE( 
                                     name      => '"DB_COMERCIAL"."JOB_PMA_CAMBIOCICLO_'||Ln_IdProcesoMasivoCab||'"', 
                                     attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF );
       SYS.DBMS_SCHEDULER.enable(
                             name => '"DB_COMERCIAL"."JOB_PMA_CAMBIOCICLO_'||Ln_IdProcesoMasivoCab||'"');         

    EXCEPTION
      WHEN Le_Error THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_CREA_PM_CMB_CICLO_TODOS', 
                                              Pv_MsjResultado,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
      WHEN OTHERS THEN
        --
        Pv_MsjResultado      := 'Error al ejecutar el script de Cambio de Ciclo'; 

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_CREA_PM_CMB_CICLO_TODOS', 
                                              SQLERRM,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_CREA_PM_CMB_CICLO_TODOS;


  --
  --
  PROCEDURE P_EJECUTA_PM_CAMBIO_CICLO (Pn_IdProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                                       Pv_IdsPtoCobertura              IN  VARCHAR2)
   IS
    --Costo: 4
   CURSOR C_GetProcesoMasivoCab(Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
   IS
   SELECT PMC.ID_PROCESO_MASIVO_CAB, 
   PMC.SOLICITUD_ID AS ID_CICLO,
   CI.NOMBRE_CICLO,
   EMPG.PREFIJO,
   PMC.ESTADO AS ESTADO_CAB   
   FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PMC,  
   DB_FINANCIERO.ADMI_CICLO CI,
   DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPG
   WHERE
   PMC.SOLICITUD_ID                = CI.ID_CICLO
   AND PMC.EMPRESA_ID              = EMPG.COD_EMPRESA
   AND PMC.TIPO_PROCESO            = 'CicloFacturacion' 
   AND PMC.ESTADO                  = 'Pendiente'
   AND PMC.ID_PROCESO_MASIVO_CAB   = Cn_IdProcesoMasivoCab;
   Lr_GetProcesoMasivoCab   C_GetProcesoMasivoCab%ROWTYPE;

   --Costo: 6
   CURSOR C_GetProcesoMasivo(Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
   IS
   SELECT PMC.ID_PROCESO_MASIVO_CAB, 
   PMC.SOLICITUD_ID AS ID_CICLO,
   CI.NOMBRE_CICLO,
   PMC.ESTADO AS ESTADO_CAB,
   PMD.ID_PROCESO_MASIVO_DET,
   PMD.PERSONA_EMPRESA_ROL_ID,
   PMD.ESTADO AS ESTADO_DET
   FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PMC,
   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PMD,
   DB_FINANCIERO.ADMI_CICLO CI
   WHERE PMC.ID_PROCESO_MASIVO_CAB = PMD.PROCESO_MASIVO_CAB_ID
   AND PMC.SOLICITUD_ID            = CI.ID_CICLO
   AND PMC.TIPO_PROCESO            = 'CicloFacturacion' 
   AND PMC.ESTADO                  = 'Pendiente'
   AND PMC.ID_PROCESO_MASIVO_CAB   = Cn_IdProcesoMasivoCab;

   --Costo: 7
   CURSOR C_GetPerRolCaractCiclo(Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
   IS
   SELECT IPERC.ID_PERSONA_EMPRESA_ROL_CARACT,
   CI.NOMBRE_CICLO,
   IPERC.ESTADO
   FROM 
   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, 
   DB_COMERCIAL.ADMI_CARACTERISTICA CA,
   DB_COMERCIAL.ADMI_CICLO CI
   WHERE
   IPER.ID_PERSONA_ROL                                          = Cn_IdPersonaRol
   AND IPERC.PERSONA_EMPRESA_ROL_ID                             = IPER.ID_PERSONA_ROL
   AND IPERC.CARACTERISTICA_ID                                  = CA.ID_CARACTERISTICA
   AND CA.DESCRIPCION_CARACTERISTICA                            = 'CICLO_FACTURACION'  
   AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0) = CI.ID_CICLO
   AND IPERC.ESTADO                                             = 'Activo';

   --Costo: 1
   CURSOR C_GetPerRolCaractCicloFact(Cn_IdPersonaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
   IS
   SELECT IPERC.ID_PERSONA_EMPRESA_ROL_CARACT,IPERC.VALOR,  
   IPERC.ESTADO
   FROM 
   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, 
   DB_COMERCIAL.ADMI_CARACTERISTICA CA 
   WHERE
   IPER.ID_PERSONA_ROL                                          = Cn_IdPersonaRol
   AND IPERC.PERSONA_EMPRESA_ROL_ID                             = IPER.ID_PERSONA_ROL
   AND IPERC.CARACTERISTICA_ID                                  = CA.ID_CARACTERISTICA
   AND CA.DESCRIPCION_CARACTERISTICA                            = 'CAMBIO_CICLO_FACTURADO'    
   AND IPERC.ESTADO                                             = 'Activo';

   --Costo: 2
   CURSOR C_GetCaractCiclo (Cv_DescripcionCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
   IS 
   SELECT ID_CARACTERISTICA 
   FROM DB_COMERCIAL.ADMI_CARACTERISTICA 
   WHERE DESCRIPCION_CARACTERISTICA=Cv_DescripcionCarac
   AND ESTADO = 'Activo'
   AND ROWNUM = 1;

    CURSOR C_GetClientePmaResultado (Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
   IS
   SELECT 
       IPE.IDENTIFICACION_CLIENTE AS IDENTIFICACION,     
       CASE
       WHEN IPE.RAZON_SOCIAL IS NULL THEN IPE.NOMBRES||' '||IPE.APELLIDOS
       ELSE 
       DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_GET_VARCHAR_CLEAN(TRIM(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     REPLACE(
                                                                     IPE.RAZON_SOCIAL, Chr(9), ' '), Chr(10), ' '), 
                                                                     Chr(13), ' ')))                  
       END AS NOMBRE_CLIENTE,
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI('DESCRIPCION_FORMA_PAGO',IPER.ID_PERSONA_ROL,IPER.ESTADO),' ') 
       AS FORMA_PAGO,        
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI('DESCRIPCION_CUENTA',IPER.ID_PERSONA_ROL,IPER.ESTADO),' ')
       AS DESCRIPCION_CUENTA,
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFORMACION_CONTRATO_CLI('DESCRIPCION_BANCO',IPER.ID_PERSONA_ROL,IPER.ESTADO),' ') 
       AS DESCRIPCION_BANCO,
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFO_CLIENTE_PORPTOFACT('VALOR_RECURRENTE',IPER.ID_PERSONA_ROL),' ') 
       AS VALOR_RECURRENTE,
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFO_CLIENTE_PORPTOFACT('SALDO_DEUDOR',IPER.ID_PERSONA_ROL),' ') 
       AS SALDO_DEUDOR,
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFO_CLIENTE_PORPTOFACT('JURISDICCION',IPER.ID_PERSONA_ROL),' ') 
       AS JURISDICCION,
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFO_CLIENTE_PORPTOFACT('DESCUENTO',IPER.ID_PERSONA_ROL),' ') 
       AS DESCUENTO,
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFO_CLIENTE_PORPTOFACT('TOT_CON_IMP',IPER.ID_PERSONA_ROL),' ') 
       AS TOTAL_CON_IMP,
       NVL(DB_COMERCIAL.CMKG_CICLOS_FACTURACION.F_INFO_CLIENTE_PORPTOFACT('SUBTOT_PREFER',IPER.ID_PERSONA_ROL),' ') 
       AS SUBTOT_PREFER,
       (
        SELECT
          MAX(AC.NOMBRE_CICLO)
        FROM
          DB_FINANCIERO.ADMI_CICLO AC,
          INFO_PERSONA_EMPRESA_ROL_CARAC IERC,
          ADMI_CARACTERISTICA ACAR
        WHERE
          IPER.ID_PERSONA_ROL=IERC.PERSONA_EMPRESA_ROL_ID
        AND TO_CHAR(AC.ID_CICLO)=IERC.VALOR
        AND ACAR.ID_CARACTERISTICA=IERC.CARACTERISTICA_ID
        AND IERC.ESTADO='Activo'
        AND ACAR.DESCRIPCION_CARACTERISTICA='CICLO_FACTURACION'
      ) AS NOMBRE_CICLO_CLIENTE,
       IPMD.ESTADO AS ESTADO_DET_PMA,
       IPMD.OBSERVACION
    FROM
      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB IPMC,
      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET IPMD,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PERSONA IPE
    WHERE
      IPMC.ID_PROCESO_MASIVO_CAB   = Cn_IdProcesoMasivoCab
    AND IPMC.ID_PROCESO_MASIVO_CAB = IPMD.PROCESO_MASIVO_CAB_ID
    AND IPER.ID_PERSONA_ROL        = IPMD.PERSONA_EMPRESA_ROL_ID
    AND IPE.ID_PERSONA             = IPER.PERSONA_ID;

   CURSOR C_GetUsuario(Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
   IS
   SELECT USR_CREACION
   FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
   WHERE ID_PROCESO_MASIVO_CAB=Cn_IdProcesoMasivoCab;

   Lx_ErrorProcedure            exception;
   Lv_IpCreacion                VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
   Ln_IdPersonaEmpresaRolCaract DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC.ID_PERSONA_EMPRESA_ROL_CARACT%TYPE; 
   Ln_IdCaractCicloFacturacion  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
   Ln_IdCaractCicloFacturado    DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
   Ln_IdPersonaEmpresaRolHisto  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO.ID_PERSONA_EMPRESA_ROL_HISTO%TYPE;   
   Lv_NombreCicloAnterior       DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE; 
   Lv_NombreCicloNuevo          DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE; 
   Lv_PrefijoEmpresa            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
   Lv_Directorio                VARCHAR2(50)   := 'DIR_REPGERENCIA';
   Lv_NombreArchivo             VARCHAR2(150);
   Lv_Delimitador               VARCHAR2(1)    := '|';
   Lv_Gzip                      VARCHAR2(100);
   Lv_Remitente                 VARCHAR2(100)  := 'notificaciones_telcos@telconet.ec';
   Lv_Asunto                    VARCHAR2(300)  := 'Reporte de Ejecución de Cambio de Ciclo de Facturación ';
   Lv_Cuerpo                    VARCHAR2(9999) := ''; 
   Lv_NombreArchivoZip          VARCHAR2(250);
   Lc_GetAliasPlantilla         DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
   Lfile_Archivo                UTL_FILE.FILE_TYPE;
   Lv_AliasCorreos              VARCHAR2(500);
   Lv_Destinatario              VARCHAR2(500);
   Lv_Query                     CLOB;
   Ln_TotalRegistros            NUMBER;
   Ln_ContadorCursor            NUMBER := 0;
   Ln_LimiteBulk                NUMBER := 3000;
   Lc_PtosCoberturaCliente      SYS_REFCURSOR;
   Lv_EstadoDetPma              DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE;
   Lv_ObservacionPma            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.OBSERVACION%TYPE;
   Lb_ProcesoPma                BOOLEAN:=TRUE;
   Lv_User                      VARCHAR2(1000);

   BEGIN

    OPEN C_GetUsuario(Pn_IdProcesoMasivoCab);
    FETCH C_GetUsuario into Lv_User;
    CLOSE C_GetUsuario;

    Lv_NombreArchivo     := 'ReporteEjecucionCambioCicloFacturacion_'||Lv_User||'_'||Pn_IdProcesoMasivoCab||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';

    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_PMA_CICLOFA');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
    Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';
    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
   --        
    IF C_GetCaractCiclo%ISOPEN THEN
      --
      CLOSE C_GetCaractCiclo;
      --
    END IF;
    --
    IF C_GetProcesoMasivoCab%ISOPEN THEN
      --
      CLOSE C_GetProcesoMasivoCab;
      --
    END IF;
    --
    OPEN C_GetProcesoMasivoCab(Pn_IdProcesoMasivoCab);    
    FETCH C_GetProcesoMasivoCab INTO Lr_GetProcesoMasivoCab; 
    --
    IF(C_GetProcesoMasivoCab%FOUND) THEN
       Lv_NombreCicloNuevo := Lr_GetProcesoMasivoCab.NOMBRE_CICLO;
       Lv_PrefijoEmpresa   := Lr_GetProcesoMasivoCab.PREFIJO;
    END IF;
    --
    CLOSE C_GetProcesoMasivoCab;
    --
    -- OBTENGO CARACTERISTICA DE CICLO_FACTURACION
    OPEN C_GetCaractCiclo('CICLO_FACTURACION');
    FETCH C_GetCaractCiclo INTO Ln_IdCaractCicloFacturacion;
    IF(Ln_IdCaractCicloFacturacion IS NULL) THEN
       raise Lx_ErrorProcedure;
    END IF;
    CLOSE C_GetCaractCiclo;
    --
    -- OBTENGO CARACTERISTICA DE CAMBIO_CICLO_FACTURADO
    OPEN C_GetCaractCiclo('CAMBIO_CICLO_FACTURADO');
    FETCH C_GetCaractCiclo INTO Ln_IdCaractCicloFacturado;
    IF(Ln_IdCaractCicloFacturado IS NULL) THEN
       raise Lx_ErrorProcedure;
    END IF;
    CLOSE C_GetCaractCiclo;
    --
    --BARRO LOS DETALLES DEL PMA DE CAMBIO DE CICLO
    FOR Lr_GetProcesoMasivo IN C_GetProcesoMasivo(Pn_IdProcesoMasivoCab) LOOP
       --

       Ln_ContadorCursor := Ln_ContadorCursor + 1;
       Lb_ProcesoPma     :=TRUE;
       Lv_EstadoDetPma   :='Finalizado';
       Lv_ObservacionPma :='Se Cambio Exitosamente el Ciclo de Facturacion';
       --
       IF Pv_IdsPtoCobertura IS NOT NULL THEN
           --
           Lv_Query:= 'SELECT JU.ID_JURISDICCION
           FROM
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_COMERCIAL.INFO_PUNTO PTO, 
           DB_INFRAESTRUCTURA.ADMI_JURISDICCION JU,
           DB_COMERCIAL.INFO_SERVICIO ISER,
           INFO_PLAN_DET IPD,
           ADMI_PRODUCTO AP
           WHERE 
           IPER.ID_PERSONA_ROL         = '||Lr_GetProcesoMasivo.PERSONA_EMPRESA_ROL_ID||'     
           AND JU.ID_JURISDICCION      NOT IN ('|| Pv_IdsPtoCobertura ||')
           AND IPER.ID_PERSONA_ROL     = PTO.PERSONA_EMPRESA_ROL_ID
           AND ISER.PUNTO_FACTURACION_ID=PTO.ID_PUNTO
           AND ISER.PLAN_ID = IPD.PLAN_ID
           AND AP.ID_PRODUCTO = IPD.PRODUCTO_ID
           AND ISER.ESTADO IN (''Activo'',''In-Corte'')
           AND AP.ES_PREFERENCIA=''SI''
           AND PTO.PUNTO_COBERTURA_ID  = JU.ID_JURISDICCION           
           GROUP BY JU.ID_JURISDICCION ';  

           Ln_TotalRegistros := CMKG_CICLOS_FACTURACION.F_GET_COUNT_REFCURSOR(Lv_Query);         
           IF (Ln_TotalRegistros>0) THEN             
              Lv_EstadoDetPma   :='Fallo';
              Lv_ObservacionPma :='No se realizo Cambio de Ciclo de Facturacion el Cliente posee Logines en diferentes Coberturas';
              Lb_ProcesoPma     :=FALSE;
           END IF;
           --
       END IF;    
       --   
       IF(Lb_ProcesoPma = TRUE) THEN
          --
          FOR Lr_GetPerRolCaractCiclo in C_GetPerRolCaractCiclo(Lr_GetProcesoMasivo.PERSONA_EMPRESA_ROL_ID) LOOP                    
             --
             -- INACTIVO CARACTERISTICAS DE CICLO DE FACTURACION DEL CLIENTE
             UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC 
             SET ESTADO  = 'Inactivo',
             USR_ULT_MOD = 'pma_cambiociclo',
             FE_ULT_MOD  = SYSDATE          
             WHERE ID_PERSONA_EMPRESA_ROL_CARACT = Lr_GetPerRolCaractCiclo.ID_PERSONA_EMPRESA_ROL_CARACT;
             --
             Lv_NombreCicloAnterior := Lr_GetPerRolCaractCiclo.NOMBRE_CICLO;
             --
             --
          END LOOP;
          --
          FOR Lr_GetPerRolCaractCicloFact in C_GetPerRolCaractCicloFact(Lr_GetProcesoMasivo.PERSONA_EMPRESA_ROL_ID) LOOP                    
             --
             -- INACTIVO CARACTERISTICAS DE CAMBIO_CICLO_FACTURADO DEL CLIENTE
             UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC 
             SET ESTADO  = 'Inactivo',
             USR_ULT_MOD = 'pma_cambiociclo',
             FE_ULT_MOD  = SYSDATE          
             WHERE ID_PERSONA_EMPRESA_ROL_CARACT = Lr_GetPerRolCaractCicloFact.ID_PERSONA_EMPRESA_ROL_CARACT;                      
             --
             --
          END LOOP;
          --
          Ln_IdPersonaEmpresaRolCaract := SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL;
          --
          --INSERTO NUEVA CARACTERISTICA DE CICLO_FACTURACION DEL CLIENTE
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC 
          (ID_PERSONA_EMPRESA_ROL_CARACT,
          PERSONA_EMPRESA_ROL_ID,
          CARACTERISTICA_ID,
          VALOR,
          FE_CREACION,
          FE_ULT_MOD,
          USR_CREACION,
          USR_ULT_MOD,
          IP_CREACION,
          ESTADO,
          PERSONA_EMPRESA_ROL_CARAC_ID) 
          VALUES
          (Ln_IdPersonaEmpresaRolCaract,
          Lr_GetProcesoMasivo.PERSONA_EMPRESA_ROL_ID,
          Ln_IdCaractCicloFacturacion,
          Lr_GetProcesoMasivo.ID_CICLO,
          SYSDATE,
          NULL,
          'pma_cambiociclo',
          NULL,
          Lv_IpCreacion,
          'Activo',
          NULL);       
          --
          --
            Ln_IdPersonaEmpresaRolCaract := SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL;
          --
          --INSERTO NUEVA CARACTERISTICA DE CAMBIO_CICLO_FACTURADO DEL CLIENTE
          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC 
          (ID_PERSONA_EMPRESA_ROL_CARACT,
          PERSONA_EMPRESA_ROL_ID,
          CARACTERISTICA_ID,
          VALOR,
          FE_CREACION,
          FE_ULT_MOD,
          USR_CREACION,
          USR_ULT_MOD,
          IP_CREACION,
          ESTADO,
          PERSONA_EMPRESA_ROL_CARAC_ID) 
          VALUES
          (Ln_IdPersonaEmpresaRolCaract,
          Lr_GetProcesoMasivo.PERSONA_EMPRESA_ROL_ID,
          Ln_IdCaractCicloFacturado,
          'N',
          SYSDATE,
          NULL,
          'pma_cambiociclo',
          NULL,
          Lv_IpCreacion,
          'Activo',
          NULL);       
          --
          -- INSERTO HISTORIAL EN EL CLIENTE QUE SE HA EJECUTADO UN CAMBIO DE CICLO DE FACTURACION
          --
          Ln_IdPersonaEmpresaRolHisto := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;

          INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO 
          (ID_PERSONA_EMPRESA_ROL_HISTO,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          PERSONA_EMPRESA_ROL_ID,
          OBSERVACION,
          MOTIVO_ID,
          EMPRESA_ROL_ID,
          OFICINA_ID,
          DEPARTAMENTO_ID,
          CUADRILLA_ID,
          REPORTA_PERSONA_EMPRESA_ROL_ID,
          ES_PREPAGO) VALUES
          (Ln_IdPersonaEmpresaRolHisto,
          'pma_cambiociclo',
          SYSDATE,
          Lv_IpCreacion,
          'Activo',
          Lr_GetProcesoMasivo.PERSONA_EMPRESA_ROL_ID,
         'Se modifico Ciclo de Facturación :
          <br>Ciclo Anterior: ' || Lv_NombreCicloAnterior || ' <br>Ciclo Nuevo: ' || Lr_GetProcesoMasivo.NOMBRE_CICLO,
          NULL,NULL,NULL,NULL,NULL,NULL,NULL);

       END IF;
       --
       --ACTUALIZO DETALLE DE PROCESO a Finalizado o Fallo
       --      
       UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
       SET ESTADO  = Lv_EstadoDetPma,
       USR_ULT_MOD = 'pma_cambiociclo',
       FE_ULT_MOD  = SYSDATE ,
       OBSERVACION = Lv_ObservacionPma
       WHERE ID_PROCESO_MASIVO_DET = Lr_GetProcesoMasivo.ID_PROCESO_MASIVO_DET;
       --
       --
       --ACTUALIZO CADA CIERTO NÚMERO DE REGISTROS
       IF Ln_ContadorCursor >= Ln_LimiteBulk THEN
         COMMIT;
         Ln_ContadorCursor := 0;
       END IF;

    END LOOP;

    --ACTUALIZO LOS RESTANTES
    COMMIT;
    --
    -- ACTUALIZO CABECERA DE PROCESO A Finalizado
    --

    --GENERO CSV DE REPORTE DE EJECUCION DE PMA DE CAMBIO DE CICLO
    --CABECERA DEL REPORTE
    utl_file.put_line(Lfile_Archivo,'REPORTE DE EJECUCION DE CAMBIO DE CICLO DE FACTURACION'||Lv_Delimitador 
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

    utl_file.put_line(Lfile_Archivo,'FECHA DE GENERACION:  '||TO_CHAR(SYSDATE, 'DD-MM-YYYY, HH24:MI:SS')||Lv_Delimitador 
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

    utl_file.put_line(Lfile_Archivo,'NUEVO_CICLO:  '|| Lv_NombreCicloNuevo ||Lv_Delimitador 
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

     utl_file.put_line(Lfile_Archivo,'CED/RUC/PAS'||Lv_Delimitador  
          ||'NOMBRE CLIENTE'||Lv_Delimitador  
          ||'FORMA PAGO'||Lv_Delimitador 
          ||'DESC.TIPO CUENTA'||Lv_Delimitador 
          ||'DESC. BANCO'||Lv_Delimitador 
          ||'CICLO DEL CLIENTE'||Lv_Delimitador     
          ||'VALOR RECURRENTE DEL CLIENTE'||Lv_Delimitador     
          ||'SALDO DEUDOR DEL CLIENTE'||Lv_Delimitador     
          ||'JURISDICCION'||Lv_Delimitador     
          ||'ESTADO'||Lv_Delimitador
          ||'OBSERVACION'||Lv_Delimitador
          ||'DESCUENTO'||Lv_Delimitador     
          ||'TOTAL (CON IMPUESTOS)'||Lv_Delimitador
          ||'SUBTOTAL PREFERENCIAL'||Lv_Delimitador
          );

    --
    --LEO EL PMA DE CAMBIO DE CICLO DE FACTURACION PARA ENVIAR PLANTILLA DE CORREO CON CSV ADJUNTO.    
    FOR Lr_GetClientePmaResultado IN C_GetClientePmaResultado(Pn_IdProcesoMasivoCab) LOOP

        UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_GetClientePmaResultado.IDENTIFICACION, '')||Lv_Delimitador 
            ||NVL(Lr_GetClientePmaResultado.NOMBRE_CLIENTE, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.FORMA_PAGO, '')||Lv_Delimitador 
            ||NVL(Lr_GetClientePmaResultado.DESCRIPCION_CUENTA, '')||Lv_Delimitador    
            ||NVL(Lr_GetClientePmaResultado.DESCRIPCION_BANCO, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.NOMBRE_CICLO_CLIENTE, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.VALOR_RECURRENTE, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.SALDO_DEUDOR, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.JURISDICCION, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.ESTADO_DET_PMA, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.OBSERVACION, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.DESCUENTO, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.TOTAL_CON_IMP, '')||Lv_Delimitador  
            ||NVL(Lr_GetClientePmaResultado.SUBTOT_PREFER, '')||Lv_Delimitador  
            );
    END LOOP;
    --
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

    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
    SET ESTADO  = 'Finalizado',
    USR_ULT_MOD = 'pma_cambiociclo',
    FE_ULT_MOD  = SYSDATE
    WHERE ID_PROCESO_MASIVO_CAB = Pn_IdProcesoMasivoCab;

    --
    --
    --INSERTO HISTORIAL DE REPORTE CSV GENERADO
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
    Lv_PrefijoEmpresa,
    'RPT_PMA_CICLOFA',
    'pma_cambiociclo',
    SYSDATE,
    Lv_AliasCorreos,
    'Telcos',
    'Activo',
    'Reporte de Ejecución de Cambio de Ciclo de Facturación:'||
    '<br> Ciclo Anterior: '|| Lv_NombreCicloAnterior || '<b> Ciclo Nuevo: '||Lv_NombreCicloNuevo||'</br>');
    --
    --
    COMMIT;

    EXCEPTION
      WHEN Lx_ErrorProcedure THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_EJECUTA_PM_CAMBIO_CICLO', 
                                              'No encontro Caracteristica CICLO_FACTURACION, '|| SQLERRM,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
      WHEN OTHERS THEN
        --       
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_EJECUTA_PM_CAMBIO_CICLO', 
                                              SQLERRM || ' - ' || Lv_Query,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_EJECUTA_PM_CAMBIO_CICLO;

  PROCEDURE P_ANULA_CAMBIO_CICLO_PMA
  IS
  CURSOR C_PmaPorAnular(Cv_EmpresaCod VARCHAR2) IS
    SELECT ID_PROCESO_MASIVO_CAB, ESTADO
    FROM   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
    WHERE  TIPO_PROCESO = 'CicloFacturacion'
     AND   EMPRESA_ID = Cv_EmpresaCod
     AND   ESTADO IN ('Pendiente', 'Procesado', 'Creado')
     AND   FE_CREACION <= (SYSDATE - 1);

    Lrf_AdmiParametroDet     SYS_REFCURSOR;
    Lv_Observacion           VARCHAR2(4000);
    Lv_NombreJobPma          VARCHAR2(45) := '"DB_COMERCIAL"."JOB_PMA_CAMBIOCICLO_';
    Lr_AdmiParametroDet      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;

  BEGIN
    --SE ITERA EL PARÁMETRO SI TIENE CICLO DE FACTURACIÓN
    Lrf_AdmiParametroDet := DB_GENERAL.GNRLPCK_UTIL.F_GET_PARAMS_DETS('CICLO_FACTURACION_EMPRESA');
    LOOP
        FETCH Lrf_AdmiParametroDet INTO Lr_AdmiParametroDet;
        EXIT WHEN Lrf_AdmiParametroDet%NOTFOUND;

        CONTINUE WHEN UPPER(Lr_AdmiParametroDet.VALOR1) <> 'S';

        FOR Lr_PmaPorAnular IN C_PmaPorAnular(Lr_AdmiParametroDet.EMPRESA_COD)
        LOOP
            Lv_Observacion := '| Se elimina el proceso del job:' || Lv_NombreJobPma || Lr_PmaPorAnular.ID_PROCESO_MASIVO_CAB || '"';
            --SE REALIZA EL DROP PARA EL POSIBLE JOB.
            BEGIN
              DBMS_SCHEDULER.DROP_JOB (JOB_NAME => Lv_NombreJobPma || Lr_PmaPorAnular.ID_PROCESO_MASIVO_CAB ||'"');
            EXCEPTION
              WHEN OTHERS THEN
                Lv_Observacion := Lv_Observacion || ' - ERROR_STACK: '     || DBMS_UTILITY.FORMAT_ERROR_STACK
                                                 || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            END;
            --SE ANULA LA CABECERA DEL PROCESO MASIVO
            UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
               SET ESTADO = 'Anulado',
                   FE_ULT_MOD = SYSDATE,
                   USR_ULT_MOD = 'pma_cambiociclo'
            WHERE ID_PROCESO_MASIVO_CAB = Lr_PmaPorAnular.ID_PROCESO_MASIVO_CAB;
            --SE ANULA EL DETALLE DEL PROCESO MASIVO
            UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
               SET ESTADO = 'Anulado',
                   FE_ULT_MOD = SYSDATE,
                   USR_ULT_MOD = 'pma_cambiociclo',
                   OBSERVACION = SUBSTR(OBSERVACION || '|Estado:' || ESTADO || '|| Se da de baja por proceso automático de eliminación de procesos pendientes '
                                  || 'de Cambio de ciclo de facturacion' || Lv_Observacion, 1, 4000)
             WHERE PROCESO_MASIVO_CAB_ID = Lr_PmaPorAnular.ID_PROCESO_MASIVO_CAB
               AND ESTADO NOT IN ('Finalizado','Fallo');
            COMMIT;
        END LOOP;
    END LOOP;
    CLOSE Lrf_AdmiParametroDet;
  EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_ANULA_CAMBIO_CICLO_PMA',
                                              SQLERRM ,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'pma_cambiociclo'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
                                            );
  END P_ANULA_CAMBIO_CICLO_PMA;

  PROCEDURE P_VALIDA_CARACT_ALCANCE(Pn_Punto NUMBER,
                                    Pn_Servi NUMBER)
  IS

    Lb_PuedeBajarCaract BOOLEAN;
    Ln_IdPersonaRol     NUMBER        :=0;
    Lv_Error            VARCHAR2(4000):='';

    Lr_Pers_Emp_Rol_Caract        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC%ROWTYPE;

  BEGIN

    Ln_IdPersonaRol:=F_GET_SERV_ACTIVOS_CLI(Pn_Punto,Pn_Servi);

    IF Ln_IdPersonaRol > 0 THEN
      Lr_Pers_Emp_Rol_Caract:=NULL;
      Lr_Pers_Emp_Rol_Caract.Persona_Empresa_Rol_Id:=Ln_IdPersonaRol;
      Lr_Pers_Emp_Rol_Caract.Valor:='N';
      Lr_Pers_Emp_Rol_Caract.Estado:='Eliminado';

      Lv_Error:=NULL;
      DB_FINANCIERO.FNCK_FACTURACION.P_ACTUAL_PERS_EMP_ROL_CARACT(Lr_Pers_Emp_Rol_Caract,Lv_Error);

      IF Lv_Error IS NOT NULL THEN
        Lv_Error:='P_ACTUAL_PERS_EMP_ROL_CARACT:'||Lv_Error;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                             'CMKG_CICLOS_FACTURACION.P_VALIDA_CARACT_ALCANCE', 
                                             Lv_Error,
                                             USER,
                                             SYSDATE,
                                             SYS_CONTEXT('USERENV','IP_ADDRESS')
                                            );
      END IF;
    END IF;
  EXCEPTION
      WHEN OTHERS THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_CICLOS_FACTURACION.P_VALIDA_CARACT_ALCANCE', 
                                              SQLERRM,
                                              USER,
                                              SYSDATE,
                                              SYS_CONTEXT('USERENV','IP_ADDRESS')
                                            );
  END P_VALIDA_CARACT_ALCANCE;

  FUNCTION F_GET_SERV_ACTIVOS_CLI(Pn_Punto      NUMBER,
                                  Pn_Servicio   NUMBER)
    RETURN NUMBER
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    CURSOR C_GetCliente(Pn_PuntoId NUMBER)
    IS
      SELECT IPER.PERSONA_ID
      FROM DB_COMERCIAL.INFO_PUNTO IP,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
      WHERE IP.ID_PUNTO=Pn_PuntoId
      AND IP.PERSONA_EMPRESA_ROL_ID=IPER.ID_PERSONA_ROL;

    CURSOR C_GetPersonaRol(Pn_PersonaId NUMBER)
    IS
      SELECT IPER.ID_PERSONA_ROL
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_COMERCIAL.INFO_EMPRESA_ROL IER,
           DB_GENERAL.ADMI_TIPO_ROL ATR,
           DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG,
           DB_GENERAL.ADMI_ROL AR
      WHERE IPER.PERSONA_ID=Pn_PersonaId
      AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
      AND IER.EMPRESA_COD = IEG.COD_EMPRESA
      AND IEG.PREFIJO = 'MD'
      AND ATR.ID_TIPO_ROL = AR.TIPO_ROL_ID
      AND IER.ROL_ID = AR.ID_ROL
      AND IPER.ESTADO = 'Activo'
      AND ATR.DESCRIPCION_TIPO_ROL = 'Cliente';

    CURSOR C_GetServActivos(Pn_PersonaEmpRol NUMBER,
                            Pn_Servicio      NUMBER)
    IS
      SELECT ISE.ID_SERVICIO,ISE.ESTADO
      FROM INFO_SERVICIO ISE,
           INFO_PLAN_DET IPD,
           ADMI_PRODUCTO AP,
           INFO_PUNTO IP
      WHERE IP.PERSONA_EMPRESA_ROL_ID=Pn_PersonaEmpRol
      AND IPD.PLAN_ID=ISE.PLAN_ID
      AND ISE.ID_SERVICIO <> Pn_Servicio
      AND AP.ID_PRODUCTO=IPD.PRODUCTO_ID
      AND IP.ID_PUNTO=ISE.PUNTO_ID
      AND ISE.ESTADO IN ('Activo')
      AND AP.ES_PREFERENCIA='SI';

    Lc_GetCliente C_GetCliente%ROWTYPE;

    Lb_PuedeBajarCaract BOOLEAN:=TRUE;
    Ln_IdPersonaRol     NUMBER :=0;

  BEGIN

    OPEN C_GetCliente(Pn_Punto);
    FETCH C_GetCliente INTO Lc_GetCliente;
    CLOSE C_GetCliente;

    FOR I IN C_GetPersonaRol(Lc_GetCliente.PERSONA_ID) LOOP

      Ln_IdPersonaRol:=I.ID_PERSONA_ROL;
      FOR J IN C_GetServActivos(I.ID_PERSONA_ROL,Pn_Servicio) LOOP
        Lb_PuedeBajarCaract:=FALSE;
      END LOOP;

    END LOOP;

    IF NOT Lb_PuedeBajarCaract THEN
      Ln_IdPersonaRol := 0;
    END IF;

    RETURN Ln_IdPersonaRol;

  END F_GET_SERV_ACTIVOS_CLI;
  --
   PROCEDURE P_CREA_PARAM_GRUPOS_PROMO (Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
  
   --Costo: 27
   CURSOR C_GetGruposMapeoPromo (Cv_CodEmpresa            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                 Cv_Codigo                DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE, 
                                 Cv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                                 Cv_EstadoActivo          DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ESTADO%TYPE,
                                 Cv_EstadoActivoDebito    DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ESTADO%TYPE,
                                 Cv_NombrePais            DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE)
    IS
      SELECT BTC.ID_BANCO_TIPO_CUENTA AS VALOR2,
      TCTA.ID_TIPO_CUENTA AS VALOR3, BCO.ID_BANCO AS VALOR4,
      TCTA.DESCRIPCION_CUENTA VALOR6, BCO.DESCRIPCION_BANCO AS VALOR7
      FROM DB_GENERAL.ADMI_BANCO_TIPO_CUENTA BTC,
      DB_GENERAL.ADMI_TIPO_CUENTA TCTA, 
      DB_GENERAL.ADMI_BANCO BCO,
      DB_GENERAL.ADMI_PAIS PS
      WHERE BTC.TIPO_CUENTA_ID = TCTA.ID_TIPO_CUENTA
      AND BTC.BANCO_ID         = BCO.ID_BANCO
      AND BTC.ESTADO          IN (Cv_EstadoActivo,Cv_EstadoActivoDebito)
      AND TCTA.ESTADO         IN (Cv_EstadoActivo,Cv_EstadoActivoDebito)
      AND BCO.ESTADO          IN (Cv_EstadoActivo,Cv_EstadoActivoDebito)
      AND BCO.PAIS_ID          = PS.ID_PAIS
      AND PS.NOMBRE_PAIS       = Cv_NombrePais
      AND ((BTC.ES_TARJETA != 'S' AND BCO.GENERA_DEBITO_BANCARIO = 'S') OR BTC.ES_TARJETA = 'S')
      AND NOT EXISTS (SELECT 1
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                DB_GENERAL.ADMI_PARAMETRO_DET DET,
                DB_FINANCIERO.ADMI_CICLO CICLO
                WHERE NOMBRE_PARAMETRO = Cv_NombreParametro
                AND CAB.ID_PARAMETRO   = DET.PARAMETRO_ID   
                AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR5,'^\d+')),0)   = CICLO.ID_CICLO
                AND CICLO.CODIGO       = Cv_Codigo
                AND DET.EMPRESA_COD    = Cv_CodEmpresa
                AND DET.ESTADO         = Cv_EstadoActivo
                AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR2,'^\d+')),0)  = BTC.ID_BANCO_TIPO_CUENTA);
    
    --Costo: 4            
    CURSOR C_GetCicloFacturacion (Cv_CodEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS 
      SELECT id_ciclo, nombre_ciclo,
      codigo, fe_inicio, fe_fin, observacion, 
      fe_creacion, usr_creacion, estado
      FROM DB_FINANCIERO.ADMI_CICLO 
      WHERE EMPRESA_COD = Cv_CodEmpresa;


    --Costo: 3      
    CURSOR C_Parametros(Cv_NombreParametro   VARCHAR2,                       
                        Cv_EstadoActivo      VARCHAR2)
       IS      
         SELECT CAB.ID_PARAMETRO
         FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
         WHERE CAB.NOMBRE_PARAMETRO  = Cv_NombreParametro
          AND CAB.ESTADO             = Cv_EstadoActivo
         ;
         
    --Costo:11
    CURSOR C_GetCantidadGruposPromo (Cv_CodEmpresa            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Cv_Codigo                DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE, 
                                     Cv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                                     Cv_EstadoActivo          DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ESTADO%TYPE)
    IS                                 
      SELECT COUNT(*) + 1 AS CANTIDAD_GRUPOS FROM (
         SELECT DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1) AS GRUPO,
         REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR5), ',') WITHIN GROUP (
         ORDER BY PAMD.VALOR5),'([^,]*)(,\1)+($|,)', '\1\3') AS CICLO,
         REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR1), ',') WITHIN GROUP (
         ORDER BY PAMD.VALOR1),'([^,]*)(,\1)+($|,)', '\1\3') AS FORMA_PAGO,
         LISTAGG (TRIM(PAMD.VALOR2), ',') WITHIN GROUP (
         ORDER BY PAMD.VALOR2) AS IDS_FORMASPAGO_EMISORES
         FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAMC,
         DB_GENERAL.ADMI_PARAMETRO_DET PAMD,
         DB_FINANCIERO.ADMI_CICLO CICLO
         WHERE NOMBRE_PARAMETRO      = Cv_NombreParametro
         AND PAMC.ESTADO             = Cv_EstadoActivo
         AND PAMD.ESTADO             = Cv_EstadoActivo
         AND PAMC.ID_PARAMETRO       = PAMD.PARAMETRO_ID
         AND PAMD.EMPRESA_COD        = Cv_CodEmpresa
         AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(PAMD.VALOR5,'^\d+')),0)   = CICLO.ID_CICLO
         AND CICLO.CODIGO = Cv_Codigo
         GROUP BY DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1));
         
      Lv_IpCreacion            VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      Lex_Exception            EXCEPTION;   
      Lv_MsjResultado          VARCHAR2(1000);
      Lv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='MAPEO DE PROMOCIONES MENSUAL';
      Lv_EstadoActivo          DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ESTADO%TYPE:='Activo';
      Lv_EstadoActivoDebito    DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ESTADO%TYPE:='Activo-debitos';
      Lv_Codigo                DB_FINANCIERO.ADMI_CICLO.CODIGO%TYPE:='CICLO1';
      Lv_NombrePais            DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE:='ECUADOR';
      Lr_AdmiParamtroCab       DB_GENERAL.ADMI_PARAMETRO_CAB%ROWTYPE;
      Lv_Observacion           DB_GENERAL.ADMI_PARAMETRO_DET.OBSERVACION%TYPE:='VALOR1: DESCRIPCION REFERENTE A LA FORMA DE PAGO,'||
                               'VALOR2: ID_BANCO_TIPO_CUENTA,    VALOR3: ID_TIPO_CUENTA,    VALOR4: ID_BANCO,    VALOR5: ID DEL CICLO DE FACTURACION ADMI_CICLO'||
                               'VALOR6: DESCRIPCION DEL TIPO DE CUENTA    VALOR7: DESCRIPCIÓN DEL BANCO';
      Lv_Descripcion           DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE;
      Ln_IdParametro           DB_GENERAL.ADMI_PARAMETRO_CAB.ID_PARAMETRO%TYPE;
      Lv_Usuario               DB_GENERAL.ADMI_PARAMETRO_DET.USR_CREACION%TYPE:='telcos_map_prom';
      Ln_CantidadGrupos        NUMBER;
      Ln_NumeroGrupos          NUMBER;
      Ln_Limit                 NUMBER:=10;
      Ln_CantBancoTipoCuenta   NUMBER:=0;
   
    BEGIN       
        IF C_Parametros%ISOPEN THEN
            CLOSE C_Parametros;
        END IF;
         IF C_GetCantidadGruposPromo%ISOPEN THEN
            CLOSE C_GetCantidadGruposPromo;
        END IF;
                          --
        OPEN  C_Parametros(Lv_NombreParametro,Lv_EstadoActivo);
        FETCH C_Parametros INTO Ln_IdParametro;
        CLOSE C_Parametros;

        OPEN  C_GetCantidadGruposPromo(Pv_CodEmpresa, Lv_Codigo, Lv_NombreParametro,Lv_EstadoActivo);
        FETCH C_GetCantidadGruposPromo INTO Ln_CantidadGrupos;
        CLOSE C_GetCantidadGruposPromo;

        IF Ln_CantidadGrupos IS NULL THEN
              Lv_MsjResultado := 'No se encontro cantidad de Grupos por parametro de promociones';
              RAISE Lex_Exception;
        END IF;
            
        FOR Lr_GetCicloFacturacion IN C_GetCicloFacturacion(Pv_CodEmpresa)
        LOOP
           Ln_NumeroGrupos:= Ln_CantidadGrupos + 1;
           Lv_Descripcion:= 'GRUPO' || Ln_NumeroGrupos || ' BANCO_TIPO_CUENTA_ID ' || Lr_GetCicloFacturacion.CODIGO;
           Ln_CantBancoTipoCuenta := 0;
           FOR Lr_GetGruposMapeoPromo IN C_GetGruposMapeoPromo(Pv_CodEmpresa, Lr_GetCicloFacturacion.CODIGO, Lv_NombreParametro,Lv_EstadoActivo, Lv_EstadoActivoDebito, Lv_NombrePais)
           LOOP      
                Ln_CantBancoTipoCuenta := Ln_CantBancoTipoCuenta + 1;
                IF Ln_CantBancoTipoCuenta > Ln_Limit THEN
                   Ln_NumeroGrupos:= Ln_NumeroGrupos + 1;
                   Ln_CantBancoTipoCuenta := 1;
                   Lv_Descripcion:= 'GRUPO' || Ln_NumeroGrupos || ' BANCO_TIPO_CUENTA_ID ' || Lr_GetCicloFacturacion.CODIGO;
                END IF;
                
                INSERT
                INTO DB_GENERAL.ADMI_PARAMETRO_DET
                (
                 ID_PARAMETRO_DET,
                 PARAMETRO_ID,
                 DESCRIPCION,
                 VALOR1,
                 VALOR2,
                 VALOR3,
                 VALOR4,
                 ESTADO,
                 USR_CREACION,
                 FE_CREACION,
                 IP_CREACION,
                 USR_ULT_MOD,
                 FE_ULT_MOD,
                 IP_ULT_MOD,
                 VALOR5,
                 EMPRESA_COD,
                 VALOR6,
                 VALOR7,
                 OBSERVACION
                 )
                 VALUES
                (
                 DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
                 Ln_IdParametro,
                 Lv_Descripcion,
                 'DEBITO BANCARIO',
                 Lr_GetGruposMapeoPromo.VALOR2,
                 Lr_GetGruposMapeoPromo.VALOR3,
                 Lr_GetGruposMapeoPromo.VALOR4,
                 Lv_EstadoActivo,
                 Lv_Usuario,
                 SYSDATE,
                 Lv_IpCreacion,
                 Lv_Usuario,
                 SYSDATE,
                 Lv_IpCreacion,
                 Lr_GetCicloFacturacion.ID_CICLO,
                 Pv_CodEmpresa,
                 Lr_GetGruposMapeoPromo.VALOR6,
                 Lr_GetGruposMapeoPromo.VALOR7,
                 Lv_Observacion
                );
                
           END LOOP;
        END LOOP;    
        COMMIT;
    EXCEPTION
    WHEN Lex_Exception THEN
    --
    Lv_MsjResultado      := 'Ocurrio un error al parametrizar los grupos de clientes a procesarse en el mapeo promocional por banco_tipo_cuenta_id y por ciclo de Facturacion - '|| Lv_MsjResultado;                            

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_CICLOS_FACTURACION.P_CREA_PARAM_GRUPOS_PROMO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_pms_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    WHEN OTHERS THEN
    --
    Lv_MsjResultado      := 'Ocurrio un error al parametrizar los grupos de clientes a procesarse en el mapeo promocional por banco_tipo_cuenta_id y por ciclo de Facturacion';                            

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_CICLOS_FACTURACION.P_CREA_PARAM_GRUPOS_PROMO', 
                                          Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          'telcos_pms_promo',
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                         );            
  END P_CREA_PARAM_GRUPOS_PROMO;
  --
  END CMKG_CICLOS_FACTURACION;
/
