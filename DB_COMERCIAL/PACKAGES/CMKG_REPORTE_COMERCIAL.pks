CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_REPORTE_COMERCIAL AS 

  /*
  *Se agregan types necesarios para generaci�n de reporte de clientes - facturas.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 01-12-2016
  */

  TYPE Lr_ListadoDatos IS RECORD(TOTAL_REGISTRO NUMBER);
  --
  TYPE Lt_Result IS TABLE OF Lr_ListadoDatos;
  --
  TYPE Lrf_Result IS REF CURSOR;



    /**
   * Documentacion para la funcion F_GET_VARCHAR_CLEAN
   * Funcion que limpia ciertos caracteres especiales que no forman parte de la razon social del cliente
   * Fv_Cadena IN VARCHAR2   Recibe la cadena a limpiar
   * Retorna:
   * En tipo varchar2 la cadena sin caracteres especiales
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 01-12-2016
   */
  FUNCTION F_GET_VARCHAR_CLEAN(
      Fv_Cadena IN VARCHAR2)
    RETURN VARCHAR2;  

  /*
  * Documentaci�n para PROCEDURE 'P_GET_CLIENTES_FACTURAS'.
  * Procedure que me permite obtener lista de clientes con sus facturas iniciales filtros enviados como par�metros.
  *
  * PARAMETROS:
  * @Param number         Pn_EmpresaId  (empresa a generar el reporte)
  * @Param varchar2       Pv_PrefijoEmpresa   Prefijo de empresa en sesion
  * @Param varchar2       Pv_UsrSesion  Usuario en sesion
  * @Param varchar2       Pv_EmailUsrSesion   Email de usuario en sesi�n
  * @Param varchar2       Pv_FechaCreacionDesde (rango inicial para consulta por fecha de creaci�n del documento)
  * @Param varchar2       Pv_FechaCreacionHasta (rango final para consulta por fecha de creaci�n del documento)
  * @Param varchar2       Pv_FechaActivacionDesde (rango inicial para consulta por fecha de activaci�n del servicio)
  * @Param varchar2       Pv_FechaActivacionHasta (rango final para consulta por fecha de activaci�n del servicio)  
  * @Param varchar2       Pv_FechaPrePlanificacionDesde (rango inicial para consulta por fecha de pre-planificaci�n del servicio)
  * @Param varchar2       Pv_FechaPrePlanificacionHasta (rango final para consulta por fecha de pre-planificaci�n del servicio)  
  * @Param varchar2       Pv_Identificacion Numero de identificaci�n el vendedor
  * @Param varchar2       Pv_RazonSocial   Raz�n social del cliente
  * @Param varchar2       Pv_Nombres   Nombres del cliente 
  * @Param varchar2       Pv_Apellidos Apellidos del cliente   
  * @Param varchar2       Pv_IdsPlan (ids para filtrar por plan)  
  * @Param varchar2       Pv_IdsOficinasVendedor (ids para filtrar por oficina del vendedor)  
  * @Param varchar2       Pv_IdsOficinasPtoCobertura (ids para filtrar por oficina de punto de cobertura )    
  * @Param number         Pn_Start (Rango inicial de consulta)
  * @Param number         Pn_Limit (Rango final consulta) 
  * @param number         Pn_TotalRegistros  OUT  ( Total de registros obtenidos de la consulta )
  * @param SYS_REFCURSOR  Pr_Documentos      OUT  ( Cursor con los documentos obtenidos de la consulta )
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 30-09-2016
  */

  PROCEDURE P_GET_CLIENTES_FACTURAS(
    Pn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_FechaActivacionDesde         IN  VARCHAR2,
    Pv_FechaActivacionHasta         IN  VARCHAR2,
    Pv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Pv_FechaPrePlanificacionHasta   IN  VARCHAR2,
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Pv_IdsPlan                      IN  VARCHAR2,
    Pv_IdsOficinasVendedor          IN  VARCHAR2,
    Pv_IdsOficinasPtoCobertura      IN  VARCHAR2,
    Pn_Start                        IN  NUMBER,
    Pn_Limit                        IN  NUMBER,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Documentos                   OUT SYS_REFCURSOR
  );


  /*
  * Documentaci�n para la funci�n 'F_GET_CLIENTES_FACTURAS'.
  * Funci�n que me permite obtener lista de clientes con sus facturas iniciales seg�n filtros enviados como par�metros.
  *
  * PARAMETROS:
  * @Param varchar2 Fn_EmpresaCod (empresa a generar el reporte)
  * @Param varchar2 Fv_PrefijoEmpresa   Prefijo de empresa en sesion
  * @Param varchar2 Fv_UsrSesion  Usuario en sesion
  * @Param varchar2 Fv_EmailUsrSesion   Email de usuario en sesi�n
  * @Param varchar2 Fv_FechaCreacionDesde (rango inicial para consulta por fecha de creaci�n del documento)
  * @Param varchar2 Fv_FechaCreacionHasta (rango final para consulta por fecha de creaci�n del documento)
  * @Param varchar2 Fv_FechaActivacionDesde (rango inicial para consulta por fecha de activaci�n del servicio)
  * @Param varchar2 Fv_FechaActivacionHasta (rango final para consulta por fecha de activaci�n del servicio)  
  * @Param varchar2 Fv_FechaPrePlanificacionDesde (rango inicial para consulta por fecha de pre-planificacion del servicio)
  * @Param varchar2 Fv_FechaPrePlanificacionHasta (rango final para consulta por fecha de pre-planificaci�n del servicio) 
  * @Param varchar2 Fv_Identificacion Numero de identificaci�n el vendedor
  * @Param varchar2 Fv_RazonSocial   Raz�n social del cliente
  * @Param varchar2 Fv_Nombres   Nombres del cliente 
  * @Param varchar2 Fv_Apellidos Apellidos del cliente
  * @Param varchar2 Fv_IdsPlan (ids para filtrar por plan)  
  * @Param varchar2 Fv_IdsOficinasVendedor (ids para filtrar por oficina del vendedor)  
  * @Param varchar2 Fv_IdsOficinasPtoCobertura (ids para filtrar por oficina de punto de cobertura )    
  * @Param number   Fn_Start   Rango inicial de consulta
  * @Param number   Fn_Limit   Rango final de consulta
  * @param number   Fn_TotalRegistros  OUT  ( Total de registros obtenidos de la consulta )
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 30-09-2016
  */

  FUNCTION F_GET_CLIENTES_FACTURAS(
    Fn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Fv_PrefijoEmpresa               IN  VARCHAR2,
    Fv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Fv_EmailUsrSesion               IN  VARCHAR2,
    Fv_FechaCreacionDesde           IN  VARCHAR2,
    Fv_FechaCreacionHasta           IN  VARCHAR2,
    Fv_FechaActivacionDesde         IN  VARCHAR2,
    Fv_FechaActivacionHasta         IN  VARCHAR2,  
    Fv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Fv_FechaPrePlanificacionHasta   IN  VARCHAR2,      
    Fv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Fv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Fv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Fv_IdsPlan                      IN  VARCHAR2,
    Fv_IdsOficinasVendedor          IN  VARCHAR2,    
    Fv_IdsOficinasPtoCobertura      IN  VARCHAR2,        
    Fn_Start                        IN  NUMBER,
    Fn_Limit                        IN  NUMBER,
    Fn_TotalRegistros               OUT NUMBER
  )
    RETURN SYS_REFCURSOR; 

  /*
  * Funcion que sirve para obtener el total de los registros consultados
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0  13-10-2016
  * @param  CLOB  Lcl_Consulta  Sql que se consulta
  * @return NUMBER              Cantidad de registros
  */
  --
  FUNCTION F_GET_COUNT_REFCURSOR(
      Lcl_Consulta IN CLOB)
    RETURN NUMBER; 

 /**
  * Documentaci�n para F_GET_ULTIMO_ESTADO_ROL
  * Retorna el �ltimo estado del rol enviado comopar�metro.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 02-12-2016
  *
  * @param  Fn_IdPersonaEmpresaRol     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL Recibe el ID del rol
  * @return DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO.ESTADO%TYPE  
  */
  FUNCTION F_GET_ULTIMO_ESTADO_ROL(
      Fn_IdPersonaEmpresaRol     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO.ESTADO%TYPE;


 /**
  * Documentaci�n para F_GET_DESCRIPCION_SERVICIO
  * Retorna la descripci�n o nombre del servicio.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 02-12-2016
  *
  * @param  Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Recibe el ID del servicio
  * @return DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE 
  */
  FUNCTION F_GET_DESCRIPCION_SERVICIO(
      Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE;





 /**
  * Documentaci�n para F_GET_TOTAL_PAGOS
  * Retorna el valor total de pagos realizados al documento enviado como par�metro.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 06-12-2016
  *
  * @param  Fn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el ID del documento
  * @return NUMBER 
  */
  FUNCTION F_GET_TOTAL_PAGOS(
      Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER;

 /**
  * Documentaci�n para F_GET_FECHA_ACTIVACION_SERVICIO
  * Retorna la fecha de activaci�n del servicio.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 05-12-2016
  *
  * @param  Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Recibe el ID del servicio
  * @return VARCHAR2   Fecha de activaci�n en formato string
  */
  FUNCTION F_GET_FECHA_ACTIVACION(
      Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2;  

 /**
  * Documentaci�n para F_GET_FECHA_PREPLANIFICACION_SERVICIO
  * Retorna la fecha de pre-planificaci�n del servicio.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 10-01-2016
  *
  * @param  Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Recibe el ID del servicio
  * @return VARCHAR2   Fecha de pre-planificaci�n en formato string
  */
  FUNCTION F_GET_FECHA_PREPLANIFICACION(
      Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2;  


 /**
  * Documentaci�n para F_GET_OFICINA_USUARIO
  * Retorna oficina correspondiente al login de usuario con rol empleado enviado como par�metro.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 08-12-2016
  *
  * @param  Fv_Login       DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE Recibe el login del usuario
  * @param  Fv_EmpresaCod  DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE Recibe el ID de la empresa en  sesi�n  
  * @return DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE   Nombre de la oficina
  */
  FUNCTION F_GET_OFICINA_USUARIO(
      Fv_Login      IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
      Fv_EmpresaCod IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE)
     RETURN DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE;  



 /**
  * Documentaci�n para F_GET_ID_OFICINA_USUARIO
  * Retorna el id oficina correspondiente al login de usuario con rol empleado enviado como par�metro.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 15-12-2016
  *
  * @param  Fv_Login       DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE Recibe el login del usuario
  * @param  Fv_EmpresaCod  DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE Recibe el ID de la empresa en  sesi�n  
  * @return DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE   Nombre de la oficina
  */
  FUNCTION F_GET_ID_OFICINA_USUARIO(
      Fv_Login      IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
      Fv_EmpresaCod IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE)
     RETURN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;  

 /**
  * Documentaci�n para F_GET_PRIMERA_FACTURA
  * Retorna el valor del campo deseado enviado como par�metro en formato string .
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 10-01-2017
  *
  * @param  Fn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE Recibe el id del punto
  * @param  Fv_TipoRetorno VARCHAR2                              Recibe el nombre del campo a retornar
  * @return VARCHAR2                                             
  */     
  FUNCTION F_GET_PRIMERA_FACTURA(
      Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,Fv_TipoRetorno IN VARCHAR2)
    RETURN VARCHAR2;     

  /*
  * Documentaci�n para PROCEDURE 'P_REPORTE_CLIENTES_FACTURAS'.
  * Procedure que me permite generar reporte de clientes-facturas en formato csv y enviarlo por mail seg�n filtros enviados como par�metros.
  *
  * PARAMETROS:
  * @Param number         Pn_EmpresaId  (empresa a generar el reporte)
  * @Param varchar2       Pv_PrefijoEmpresa   Prefijo de empresa en sesion
  * @Param varchar2       Pv_UsrSesion  Usuario en sesion
  * @Param varchar2       Pv_EmailUsrSesion   Email de usuario en sesi�n
  * @Param varchar2       Pv_FechaCreacionDesde (rango inicial para consulta por fecha de creaci�n del documento)
  * @Param varchar2       Pv_FechaCreacionHasta (rango final para consulta por fecha de creaci�n del documento)
  * @Param varchar2       Pv_FechaActivacionDesde (rango inicial para consulta por fecha de activaci�n del servicio)
  * @Param varchar2       Pv_FechaActivacionHasta (rango final para consulta por fecha de activaci�n del servicio)  
  * @Param varchar2       Pv_Identificacion Numero de identificaci�n el vendedor
  * @Param varchar2       Pv_RazonSocial   Raz�n social del cliente
  * @Param varchar2       Pv_Nombres   Nombres del cliente 
  * @Param varchar2       Pv_Apellidos Apellidos del cliente   
  * @Param varchar2       Pv_IdsPlan (ids para filtrar por plan)  
  * @Param varchar2       Pv_IdsOficinasVendedor (ids para filtrar por oficina del vendedor)  
  * @Param varchar2       Pv_IdsOficinasPtoCobertura (ids para filtrar por oficina de punto de cobertura ) 
  * @Param varchar2       Pv_MsjResultado Devuelve un mensaje del resultado de la generaci�n del resporte
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 15-12-2016
  */

  PROCEDURE P_REPORTE_CLIENTES_FACTURAS(
    Pn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_FechaActivacionDesde         IN  VARCHAR2,
    Pv_FechaActivacionHasta         IN  VARCHAR2, 
    Pv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Pv_FechaPrePlanificacionHasta   IN  VARCHAR2,     
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Pv_IdsPlan                      IN  VARCHAR2,
    Pv_IdsOficinasVendedor          IN  VARCHAR2,    
    Pv_IdsOficinasPtoCobertura      IN  VARCHAR2,
    Pv_MsjResultado                 OUT VARCHAR2  
  );     


  /*
  * Documentaci�n para PROCEDURE 'P_REPORTE_ARCOTEL_SERV_ACT'.
  * Procedure que permite generar un reporte mensual de los servicios activos de Internet y Datos para la empresa Telconet
  *
  * PARAMETROS:
  * @Param varchar2       pv_prefijo_empresa   Prefijo de empresa en sesion
  * @Param varchar2       pv_mensaje_error     Mensaje de error
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.0 23-03-2017
  * 
  * @author Modificado: Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.1 06-04-2017 - Se realizan ajustes para obtener la fecha de activaci�n del servicio por observaci�n, esta busqueda se
  *                           realizara para los historiales que no tienen la acci�n de confirmarServicio
  *
  * @author Modificado: Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.2 04-05-2017 - Se realizan ajustes para mostrar tambi�n los servicios que no tiene INFO TECNICA
  *
  * @author Modificado: Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.3 07-08-2017 - Se realizan ajustes para agregar 2 campos al reporte (nombre del punto y fecha de creaci�n del servicio)
  */
  PROCEDURE P_REPORTE_ARCOTEL_SERV_ACT(
    pv_prefijo_empresa IN  VARCHAR2,
    pv_mensaje_error   OUT  VARCHAR2
  ); 


END CMKG_REPORTE_COMERCIAL;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REPORTE_COMERCIAL AS     

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

  PROCEDURE P_GET_CLIENTES_FACTURAS(
    Pn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_FechaActivacionDesde         IN  VARCHAR2,
    Pv_FechaActivacionHasta         IN  VARCHAR2,    
    Pv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Pv_FechaPrePlanificacionHasta   IN  VARCHAR2,   
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Pv_IdsPlan                      IN  VARCHAR2,
    Pv_IdsOficinasVendedor          IN  VARCHAR2,    
    Pv_IdsOficinasPtoCobertura      IN  VARCHAR2,     
    Pn_Start                        IN  NUMBER,
    Pn_Limit                        IN  NUMBER,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Documentos                   OUT SYS_REFCURSOR
  )
  IS

    Lv_IpCreacion      VARCHAR2(10) := '127.0.0.1';

  BEGIN

    Pc_Documentos := DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_CLIENTES_FACTURAS(Pn_EmpresaId,
                                                                      Pv_PrefijoEmpresa,
                                                                      Pv_UsrSesion,
                                                                      Pv_EmailUsrSesion,
                                                                      Pv_FechaCreacionDesde,
                                                                      Pv_FechaCreacionHasta,
                                                                      Pv_FechaActivacionDesde,
                                                                      Pv_FechaActivacionHasta,
                                                                      Pv_FechaPrePlanificacionDesde,
                                                                      Pv_FechaPrePlanificacionHasta,
                                                                      Pv_Identificacion,
                                                                      Pv_RazonSocial,
                                                                      Pv_Nombres,
                                                                      Pv_Apellidos,
                                                                      Pv_IdsPlan,
                                                                      Pv_IdsOficinasVendedor,
                                                                      Pv_IdsOficinasPtoCobertura,
                                                                      Pn_Start,
                                                                      Pn_Limit,
                                                                      Pn_TotalRegistros
                                                                      );

    EXCEPTION
      WHEN OTHERS THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_REPORTE_COMERCIAL.F_GET_CLIENTES_FACTURAS', 
                                              SQLERRM,
                                              Pv_UsrSesion,
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_GET_CLIENTES_FACTURAS;


  FUNCTION F_GET_CLIENTES_FACTURAS(
    Fn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Fv_PrefijoEmpresa               IN  VARCHAR2,
    Fv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Fv_EmailUsrSesion               IN  VARCHAR2,
    Fv_FechaCreacionDesde           IN  VARCHAR2,
    Fv_FechaCreacionHasta           IN  VARCHAR2,
    Fv_FechaActivacionDesde         IN  VARCHAR2,
    Fv_FechaActivacionHasta         IN  VARCHAR2,
    Fv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Fv_FechaPrePlanificacionHasta   IN  VARCHAR2, 
    Fv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Fv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Fv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Fv_IdsPlan                      IN  VARCHAR2,
    Fv_IdsOficinasVendedor          IN  VARCHAR2,
    Fv_IdsOficinasPtoCobertura      IN  VARCHAR2,
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

    Lc_ClientesFacturas  SYS_REFCURSOR;
  --
  BEGIN
    Lv_QueryCount      :='SELECT IPE.ID_PERSONA ';
    Lv_QueryAllColumns :='SELECT * FROM (SELECT ROWNUM ID_QUERY,
                            IPE.ID_PERSONA AS ID_CLIENTE,
                            IPE.ESTADO,
                             CASE
                               WHEN IPE.RAZON_SOCIAL IS NULL THEN IPE.NOMBRES||'' ''||IPE.APELLIDOS
                             ELSE 
                               DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
                                                                             REPLACE(
                                                                             REPLACE(
                                                                             REPLACE(
                                                                               IPE.RAZON_SOCIAL, Chr(9), '' ''), Chr(10), '' ''), 
                                                                               Chr(13), '' '')))                  
                             END AS CLIENTE,
                             IPE.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
                             NVL(IC.NUMERO_CONTRATO_EMP_PUB,'' '') AS NUMERO_EMP_PUB,
                             NVL(IC.USR_APROBACION,'' '') AS USR_APROBACION,
                             NVL(IC.ESTADO,'' '') AS ESTADO_CONTRATO,
                             NVL(ATC.DESCRIPCION_CUENTA,'' '') AS DESCRIPCION_CUENTA,
                             TO_CHAR( IC.FE_APROBACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_APROBACION,
                             TO_CHAR( IPER.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_CREACION_PER,
                             IPE.USR_CREACION,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(TRIM(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                           REPLACE(
                                                                             IPE.DIRECCION, Chr(9), '' ''), Chr(10), '' ''), 
                                                                             Chr(13), '' '')))                  
                             AS DIRECCION,                             
                             IPER.ID_PERSONA_ROL AS ID_ROL,
                             IP.LOGIN,
                             TO_CHAR( IP.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_CREACION_PTO,
                             IP.ID_PUNTO,
                             IP.USR_VENDEDOR,
                             ISE.ID_SERVICIO,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_ULTIMO_ESTADO_ROL(IPER.ID_PERSONA_ROL) AS ESTADO_ROL,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_DESCRIPCION_SERVICIO(ISE.ID_SERVICIO) AS SERVICIO,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_FECHA_PREPLANIFICACION(ISE.ID_SERVICIO) AS FE_PREPLANIFICACION,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_FECHA_ACTIVACION(ISE.ID_SERVICIO) AS FE_ACTIVACION,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_PRIMERA_FACTURA(IP.ID_PUNTO,''ESTADO_IMPRESION_FACT'')  AS ESTADO_IMPRESION_FACT,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_PRIMERA_FACTURA(IP.ID_PUNTO,''NUMERO_FACTURA_SRI'')     AS NUMERO_FACTURA_SRI,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_PRIMERA_FACTURA(IP.ID_PUNTO,''VALOR_TOTAL'')            AS VALOR_TOTAL,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_PRIMERA_FACTURA(IP.ID_PUNTO,''FE_EMISION'')             AS FE_EMISION,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_PRIMERA_FACTURA(IP.ID_PUNTO,''TOTAL_PAGOS'')            AS TOTAL_PAGOS,
                             DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_OFICINA_USUARIO(IP.USR_VENDEDOR,'''||Fn_EmpresaId||''') AS OFICINA_VENDEDOR,
                             NVL(IOGJ.NOMBRE_OFICINA,'' '') AS OFICINA_PTO_COBERTURA';

      Lv_Query          := ' FROM DB_COMERCIAL.INFO_PERSONA IPE
                              JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL         IPER ON IPER.PERSONA_ID           = IPE.ID_PERSONA
                              JOIN DB_COMERCIAL.INFO_PUNTO                       IP   ON IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL 
                              JOIN DB_GENERAL.ADMI_JURISDICCION                  AJ   ON AJ.ID_JURISDICCION        = IP.PUNTO_COBERTURA_ID
                              JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO               IOGJ ON IOGJ.ID_OFICINA           = AJ.OFICINA_ID
                              LEFT JOIN DB_COMERCIAL.INFO_CONTRATO               IC   ON IC.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL 
                              LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO    ICFP ON ICFP.CONTRATO_ID          = IC.ID_CONTRATO
                              LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA              ATC  ON ATC.ID_TIPO_CUENTA        = ICFP.TIPO_CUENTA_ID
                              JOIN DB_COMERCIAL.INFO_SERVICIO                    ISE  ON ISE.PUNTO_ID              = IP.ID_PUNTO
                              JOIN DB_COMERCIAL.INFO_EMPRESA_ROL                 IER  ON IPER.EMPRESA_ROL_ID       = IER.ID_EMPRESA_ROL 
                              JOIN DB_COMERCIAL.ADMI_ROL                         AR   ON AR.ID_ROL                 = IER.ROL_ID
                              JOIN DB_COMERCIAL.ADMI_TIPO_ROL                    ATR  ON ATR.ID_TIPO_ROL           = AR.TIPO_ROL_ID
                            WHERE
                              ISE.TIPO_ORDEN NOT IN(''T'',''R'')
                              AND IPER.PERSONA_EMPRESA_ROL_ID IS NULL
                              AND IP.ID_PUNTO  NOT IN  (SELECT IPC.PUNTO_ID 
                                                        FROM   DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC,
                                                               DB_COMERCIAL.ADMI_CARACTERISTICA AC
                                                        WHERE  IPC.CARACTERISTICA_ID         = AC.ID_CARACTERISTICA
                                                        AND    AC.DESCRIPCION_CARACTERISTICA = ''PUNTO CAMBIO RAZON SOCIAL'')                              
                              AND ATR.DESCRIPCION_TIPO_ROL = ''Cliente''  
                              AND IPER.ESTADO IN (''Activo'',''Pendiente'')
                              AND ISE.ESTADO  NOT IN (''Eliminado'')
                              AND IER.EMPRESA_COD = '''||Fn_EmpresaId||'''';

      IF Fv_FechaCreacionDesde IS NOT NULL AND  Fv_FechaCreacionDesde IS  NOT NULL THEN
        Lv_Query := Lv_Query || '  AND IPE.FE_CREACION BETWEEN TO_DATE('''||Fv_FechaCreacionDesde||''',''DD/MM/YY'')
                                   AND TO_DATE('''||Fv_FechaCreacionHasta||''',''DD/MM/YY'')' ;
      END IF;

      IF Fv_Identificacion IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPE.IDENTIFICACION_CLIENTE LIKE ''%' || Fv_Identificacion || '%''';
        --
      END IF;  

      IF Fv_Nombres IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPE.NOMBRES LIKE ''%' || Fv_Nombres || '%''';
        --
      END IF; 

      IF Fv_Apellidos IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPE.APELLIDOS LIKE ''%' || Fv_Apellidos || '%''';
        --
      END IF; 

      IF Fv_RazonSocial IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IPE.RAZON_SOCIAL LIKE ''%' || Fv_RazonSocial || '%''';
        --
      END IF; 

      IF Fv_IdsPlan IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND ISE.PLAN_ID IN ('|| Fv_IdsPlan ||')';
        --
      END IF;     

      IF Fv_IdsOficinasVendedor IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_ID_OFICINA_USUARIO(IP.USR_VENDEDOR,'''||Fn_EmpresaId||''') 
                                  IN  ('|| Fv_IdsOficinasVendedor ||')';
        --
      END IF;   

      IF Fv_IdsOficinasPtoCobertura IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND IOGJ.ID_OFICINA IN ('|| Fv_IdsOficinasPtoCobertura ||')';
        --
      END IF;         

      IF Fv_FechaActivacionDesde IS NOT NULL AND Fv_FechaActivacionHasta IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND ISE.ID_SERVICIO IN (SELECT  ISE.ID_SERVICIO 
                                                          FROM    DB_COMERCIAL.INFO_SERVICIO ISE
                                                          JOIN    DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH 
                                                            ON    ISH.SERVICIO_ID = ISE.ID_SERVICIO
                                                          WHERE   ISH.FE_CREACION 
                                                          BETWEEN TO_DATE('''||Fv_FechaActivacionDesde||''',''DD/MM/YY'') 
                                                          AND     TO_DATE('''||Fv_FechaActivacionHasta||''',''DD/MM/YY'')
                                                          AND     ISH.ESTADO = ''Activo'' 
                                                          AND     ISH.ACCION =''confirmarServicio'')';
        --
      END IF;  

      IF Fv_FechaPrePlanificacionDesde IS NOT NULL AND Fv_FechaPrePlanificacionHasta IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ' AND ISE.ID_SERVICIO IN (SELECT  ISE.ID_SERVICIO 
                                                          FROM    DB_COMERCIAL.INFO_SERVICIO ISE
                                                          JOIN    DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH 
                                                            ON    ISH.SERVICIO_ID = ISE.ID_SERVICIO
                                                          WHERE   ISH.FE_CREACION 
                                                          BETWEEN TO_DATE('''||Fv_FechaPrePlanificacionDesde||''',''DD/MM/YY'') 
                                                          AND     TO_DATE('''||Fv_FechaPrePlanificacionHasta||''',''DD/MM/YY'')
                                                          AND     ISH.ESTADO = ''PrePlanificada'')';
        --
      END IF;      

      IF Fn_Start   IS NOT NULL AND  Fn_Limit  IS NOT NULL THEN
        Lv_LimitAllColumns := ' ) TB WHERE TB.ID_QUERY >= ' || NVL(Fn_Start, 0) ||
        ' AND TB.ID_QUERY <= ' || (NVL(Fn_Start,0) + NVL(Fn_Limit,0)) || ' ORDER BY TB.ID_QUERY' ;
      ELSE
        Lv_LimitAllColumns := ' ) '
        ;
      END IF;     

  Lv_QueryAllColumns := Lv_QueryAllColumns || Lv_Query || Lv_LimitAllColumns;
  Lv_QueryCount      := Lv_QueryCount || Lv_Query;

  OPEN Lc_ClientesFacturas FOR Lv_QueryAllColumns;


  Fn_TotalRegistros := CMKG_REPORTE_COMERCIAL.F_GET_COUNT_REFCURSOR(Lv_QueryCount);
  --
  RETURN Lc_ClientesFacturas;
  --
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                            'CMKG_REPORTE_COMERCIAL.F_GET_CLIENTES_FACTURAS', 
                                            SQLERRM,
                                            Fv_UsrSesion,
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );

      RETURN NULL;
      --
  END F_GET_CLIENTES_FACTURAS;


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


  FUNCTION F_GET_ULTIMO_ESTADO_ROL(
      Fn_IdPersonaEmpresaRol     IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO.ESTADO%TYPE
  IS
    --
    CURSOR Lc_GetUltimoEstado(Cn_IdPersonaEmpresaRol     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
      SELECT NVL(IPERH.ESTADO,'')
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPERH
      WHERE IPERH.ID_PERSONA_EMPRESA_ROL_HISTO = (SELECT MAX(IPRH.ID_PERSONA_EMPRESA_ROL_HISTO) 
                                                 FROM   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO IPRH  
                                                 WHERE  IPRH.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaEmpresaRol);
    --
    Lv_GetEstadoRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO.ESTADO%TYPE;

    Lv_IpCreacion      VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetUltimoEstado%ISOPEN THEN
      --
      CLOSE Lc_GetUltimoEstado;
      --
    END IF;
    --
    OPEN Lc_GetUltimoEstado(Fn_IdPersonaEmpresaRol);
    --
    FETCH Lc_GetUltimoEstado INTO Lv_GetEstadoRol;
    --
    CLOSE Lc_GetUltimoEstado;
    --
    RETURN Lv_GetEstadoRol;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.F_GET_ULTIMO_ESTADO_ROL', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_ULTIMO_ESTADO_ROL;


  FUNCTION F_GET_DESCRIPCION_SERVICIO(
      Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE
  IS
    --
    CURSOR Lc_GetDescripcion(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT 
        CASE WHEN ISE.PRODUCTO_ID IS NOT NULL 
             THEN (SELECT NVL(AP.DESCRIPCION_PRODUCTO,'') FROM DB_COMERCIAL.ADMI_PRODUCTO AP WHERE AP.ID_PRODUCTO = ISE.PRODUCTO_ID)
             ELSE (SELECT NVL(IPC.NOMBRE_PLAN,'') FROM DB_COMERCIAL.INFO_PLAN_CAB IPC WHERE IPC.ID_PLAN = ISE.PLAN_ID)
        END AS NOMBRE_SERVICIO            
      FROM  DB_COMERCIAL.INFO_SERVICIO ISE
      WHERE ISE.ID_SERVICIO = Cn_IdServicio;
    --
    Lv_GetDescripcion DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE;
    Lv_IpCreacion      VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetDescripcion%ISOPEN THEN
      --
      CLOSE Lc_GetDescripcion;
      --
    END IF;
    --
    OPEN Lc_GetDescripcion(Fn_IdServicio);
    --
    FETCH Lc_GetDescripcion INTO Lv_GetDescripcion;
    --
    CLOSE Lc_GetDescripcion;
    IF Lv_GetDescripcion IS NULL THEN
      Lv_GetDescripcion  := '';
    END IF;
    --
    RETURN Lv_GetDescripcion;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.F_GET_DESCRIPCION_SERVICIO', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_DESCRIPCION_SERVICIO;



  FUNCTION F_GET_FECHA_ACTIVACION(
      Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2
  IS
    --
    CURSOR Lc_GetFechaActivacion(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT NVL(TO_CHAR( ISH.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS'),'') 
      FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
      WHERE ISH.SERVICIO_ID = Cn_IdServicio
      AND ISH.ESTADO = 'Activo' AND ISH.ACCION='confirmarServicio'
      ORDER BY ISH.FE_CREACION ASC;
    --
    Lv_StrFechaActivacion VARCHAR2(20);
    Lv_IpCreacion         VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetFechaActivacion%ISOPEN THEN
      --
      CLOSE Lc_GetFechaActivacion;
      --
    END IF;
    --
    OPEN Lc_GetFechaActivacion(Fn_IdServicio);
    --
    FETCH Lc_GetFechaActivacion INTO Lv_StrFechaActivacion;
    --
    CLOSE Lc_GetFechaActivacion;
    --
    RETURN Lv_StrFechaActivacion;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.F_GET_FECHA_ACTIVACION', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_FECHA_ACTIVACION;

  FUNCTION F_GET_FECHA_PREPLANIFICACION(
      Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2
  IS
    --
    CURSOR Lc_GetFechaPrePlanificacion(
                                       Cn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Cv_EstadoServicio DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE
                                      )
    IS
      SELECT NVL(TO_CHAR( ISH.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS'),'') 
      FROM   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
      WHERE  ISH.SERVICIO_ID = Cn_IdServicio
      AND    ISH.ESTADO      = Cv_EstadoServicio
      AND    ISH.ID_SERVICIO_HISTORIAL = (SELECT MIN(ISHH. ID_SERVICIO_HISTORIAL) 
                                          FROM   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISHH
                                          WHERE  ISHH.SERVICIO_ID = Cn_IdServicio
                                          AND    ISHH.ESTADO      = Cv_EstadoServicio);
    --
    Lv_StrFechaPrePlanificacion VARCHAR2(20);
    Lv_IpCreacion               VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetFechaPrePlanificacion%ISOPEN THEN
      --
      CLOSE Lc_GetFechaPrePlanificacion;
      --
    END IF;
    --
    OPEN Lc_GetFechaPrePlanificacion(Fn_IdServicio,'PrePlanificada');
    --
    FETCH Lc_GetFechaPrePlanificacion INTO Lv_StrFechaPrePlanificacion;
    --
    CLOSE Lc_GetFechaPrePlanificacion;
    --
    RETURN Lv_StrFechaPrePlanificacion;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.F_GET_FECHA_PREPLANIFICACION', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_FECHA_PREPLANIFICACION;

  FUNCTION F_GET_TOTAL_PAGOS(
      Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER
  IS
    --
    CURSOR Lc_GetTotalPagos(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT NVL(SUM(IPD.VALOR_PAGO),0) 
      FROM DB_FINANCIERO.INFO_PAGO_DET IPD
      WHERE IPD.REFERENCIA_ID = Cn_IdDocumento
      AND IPD.ESTADO IN ('Activo','Cerrado');
    --
    Ln_TotalPagos  NUMBER;
    Lv_IpCreacion  VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetTotalPagos%ISOPEN THEN
      --
      CLOSE Lc_GetTotalPagos;
      --
    END IF;
    --
    OPEN Lc_GetTotalPagos(Fn_IdDocumento);
    --
    FETCH Lc_GetTotalPagos INTO Ln_TotalPagos;
    --
    CLOSE Lc_GetTotalPagos;
    --
    RETURN Ln_TotalPagos;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.F_GET_TOTAL_PAGOS', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_TOTAL_PAGOS;



  FUNCTION F_GET_OFICINA_USUARIO(
      Fv_Login      IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
      Fv_EmpresaCod IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE)
     RETURN DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE
  IS
    --
  CURSOR Lc_GetDescripcion(Cv_Login DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE, Cv_EmpresaCod INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE )
    IS
      SELECT NVL(IOG.NOMBRE_OFICINA,'') 
      FROM  DB_COMERCIAL.INFO_PERSONA IPE
        JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER  ON IPER.PERSONA_ID     = IPE.ID_PERSONA
        JOIN  DB_COMERCIAL.INFO_OFICINA_GRUPO       IOG   ON IPER.OFICINA_ID     = IOG.ID_OFICINA
        JOIN  DB_COMERCIAL.INFO_EMPRESA_ROL         IER   ON IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
        JOIN  DB_GENERAL.ADMI_ROL                   AR    ON IER.ROL_ID          = AR.ID_ROL
        JOIN  DB_GENERAL.ADMI_TIPO_ROL              ATR   ON AR.TIPO_ROL_ID      = ATR.ID_TIPO_ROL
      WHERE IPE.LOGIN LIKE '%'||Cv_Login||'%' 
      AND   IPER.ESTADO     = 'Activo'
      AND   IOG.EMPRESA_ID  = Cv_EmpresaCod
      AND   IER.EMPRESA_COD = Cv_EmpresaCod
      AND   ATR.DESCRIPCION_TIPO_ROL='Empleado';      
    --
    Lv_GetDescripcion DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE;
    Lv_IpCreacion   VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetDescripcion%ISOPEN THEN
      --
      CLOSE Lc_GetDescripcion;
      --
    END IF;
    --
    OPEN Lc_GetDescripcion(Fv_Login,Fv_EmpresaCod);
    --
    FETCH Lc_GetDescripcion INTO Lv_GetDescripcion;
    --
    CLOSE Lc_GetDescripcion;
    IF Lv_GetDescripcion IS NULL THEN
      Lv_GetDescripcion  := '';
    END IF;
    --
    RETURN Lv_GetDescripcion;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.F_GET_OFICINA_USUARIO', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_OFICINA_USUARIO;




    FUNCTION F_GET_ID_OFICINA_USUARIO(
      Fv_Login      IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
      Fv_EmpresaCod IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE)
     RETURN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE
  IS
    --
  CURSOR Lc_GetIdOficina(Cv_Login DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE, Cv_EmpresaCod INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE )
    IS
      SELECT NVL(IOG.ID_OFICINA,0) 
      FROM  DB_COMERCIAL.INFO_PERSONA IPE
        JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER  ON IPER.PERSONA_ID     = IPE.ID_PERSONA
        JOIN  DB_COMERCIAL.INFO_OFICINA_GRUPO       IOG   ON IPER.OFICINA_ID     = IOG.ID_OFICINA
        JOIN  DB_COMERCIAL.INFO_EMPRESA_ROL         IER   ON IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
        JOIN  DB_GENERAL.ADMI_ROL                   AR    ON IER.ROL_ID          = AR.ID_ROL
        JOIN  DB_GENERAL.ADMI_TIPO_ROL              ATR   ON AR.TIPO_ROL_ID      = ATR.ID_TIPO_ROL
      WHERE IPE.LOGIN LIKE '%'||Cv_Login||'%' 
      AND   IPER.ESTADO     = 'Activo'
      AND   IOG.EMPRESA_ID  = Cv_EmpresaCod
      AND   IER.EMPRESA_COD = Cv_EmpresaCod
      AND   ATR.DESCRIPCION_TIPO_ROL='Empleado'
      OR    ATR.DESCRIPCION_TIPO_ROL='Personal Externo';          
    --
    Ln_GetIdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
    Lv_IpCreacion   VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetIdOficina%ISOPEN THEN
      --
      CLOSE Lc_GetIdOficina;
      --
    END IF;
    --
    OPEN Lc_GetIdOficina(Fv_Login,Fv_EmpresaCod);
    --
    FETCH Lc_GetIdOficina INTO Ln_GetIdOficina;
    --
    CLOSE Lc_GetIdOficina;
    --
    RETURN Ln_GetIdOficina;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.F_GET_ID_OFICINA_USUARIO', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_ID_OFICINA_USUARIO;

  FUNCTION F_GET_PRIMERA_FACTURA(
      Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,Fv_TipoRetorno IN VARCHAR2)
    RETURN VARCHAR2
  IS
    --
    CURSOR Lc_GetPrimeraFactura(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,Cv_TipoRetorno  VARCHAR2)
    IS
      SELECT  NVL(IDFC.ESTADO_IMPRESION_FACT,' ')                                                 AS ESTADO_IMPRESION_FACT,
              NVL(IDFC.NUMERO_FACTURA_SRI,' ')                                                    AS NUMERO_FACTURA_SRI,
              TO_CHAR(NVL(IDFC.VALOR_TOTAL,0))                                                    AS VALOR_TOTAL,
              NVL(TO_CHAR(IDFC.FE_EMISION, 'DD-MM-YYYY HH24:MI:SS') ,' ')                         AS FE_EMISION,
              TO_CHAR(DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_TOTAL_PAGOS(IDFC.ID_DOCUMENTO))   AS TOTAL_PAGOS
      FROM    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB   IDFC
      JOIN    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF ON IDFC.TIPO_DOCUMENTO_ID  = ATDF.ID_TIPO_DOCUMENTO 
      WHERE   IDFC.PUNTO_ID             = Cn_IdPunto 
      AND     ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP','ND')
      AND     IDFC.ESTADO_IMPRESION_FACT NOT IN ('Anulada','Inactivo','Inactiva','Rechazado','Rechazada','null','PendienteError',
                                                 'PendienteSri')
      AND     IDFC.ID_DOCUMENTO = ( SELECT * FROM ( SELECT   MIN(IDF.ID_DOCUMENTO) DOCUMENTO
                                      FROM     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB   IDF
                                      JOIN     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF ON IDF.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO 
                                      WHERE    IDF.PUNTO_ID = Cn_IdPunto 
                                      AND      ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP','ND')
                                      AND      IDF.ESTADO_IMPRESION_FACT NOT IN ('Anulada','Inactivo','Inactiva','Rechazado','Rechazada',
                                                                                 'null','PendienteError','PendienteSri')  
                                      ORDER BY IDF.FE_CREACION ASC )
                                  )                                     
      ORDER BY IDFC.FE_CREACION ASC;

    --
    Lc_PrimeraFactura  Lc_GetPrimeraFactura%ROWTYPE;
    Lv_Resultado       VARCHAR2(100) := '';
    Lv_IpCreacion      VARCHAR2(10)  := '127.0.0.1';
    --
  BEGIN
    --
    IF Lc_GetPrimeraFactura%ISOPEN THEN
      --
      CLOSE Lc_GetPrimeraFactura;
      --
    END IF;
    --
    OPEN Lc_GetPrimeraFactura(Fn_IdPunto,Fv_TipoRetorno);
    --
    FETCH Lc_GetPrimeraFactura INTO Lc_PrimeraFactura;
    --
    CLOSE Lc_GetPrimeraFactura;
    --

    CASE
        WHEN Fv_TipoRetorno = 'ESTADO_IMPRESION_FACT' THEN
            --
            Lv_Resultado := Lc_PrimeraFactura.ESTADO_IMPRESION_FACT;
            --
        WHEN Fv_TipoRetorno = 'NUMERO_FACTURA_SRI' THEN
            --
            Lv_Resultado :=  Lc_PrimeraFactura.NUMERO_FACTURA_SRI;
            --
        WHEN Fv_TipoRetorno = 'VALOR_TOTAL' THEN
            --
            Lv_Resultado :=  Lc_PrimeraFactura.VALOR_TOTAL;   
            --
        WHEN Fv_TipoRetorno = 'FE_EMISION' THEN
            --
            Lv_Resultado :=  Lc_PrimeraFactura.FE_EMISION;  
            --
        WHEN Fv_TipoRetorno = 'TOTAL_PAGOS' THEN
            --
            Lv_Resultado :=  Lc_PrimeraFactura.TOTAL_PAGOS;          --
            --
    END CASE;

  RETURN Lv_Resultado;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.F_GET_PRIMERA_FACTURA', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );
    RETURN NULL;
    --
  END F_GET_PRIMERA_FACTURA;

  PROCEDURE P_REPORTE_CLIENTES_FACTURAS(
    Pn_EmpresaId                    IN  DB_FINANCIERO.INFO_PAGO_CAB.EMPRESA_ID%TYPE,
    Pv_PrefijoEmpresa               IN  VARCHAR2,
    Pv_UsrSesion                    IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_EmailUsrSesion               IN  VARCHAR2,
    Pv_FechaCreacionDesde           IN  VARCHAR2,
    Pv_FechaCreacionHasta           IN  VARCHAR2,
    Pv_FechaActivacionDesde         IN  VARCHAR2,
    Pv_FechaActivacionHasta         IN  VARCHAR2,
    Pv_FechaPrePlanificacionDesde   IN  VARCHAR2,
    Pv_FechaPrePlanificacionHasta   IN  VARCHAR2,    
    Pv_Identificacion               IN  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Pv_RazonSocial                  IN  DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    Pv_Nombres                      IN  DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    Pv_Apellidos                    IN  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    Pv_IdsPlan                      IN  VARCHAR2,
    Pv_IdsOficinasVendedor          IN  VARCHAR2,
    Pv_IdsOficinasPtoCobertura      IN  VARCHAR2,
    Pv_MsjResultado                 OUT VARCHAR2
  )
  IS

    Lv_Directorio                 VARCHAR2(50)   := 'DIR_REPGERENCIA';
    Lv_NombreArchivo              VARCHAR2(100)  := 'ReporteClientesFacturas_'||Pv_PrefijoEmpresa||'_'||Pv_UsrSesion||'.csv';
    Lv_Delimitador                VARCHAR2(1)    := ';';
    Lv_Gzip                       VARCHAR2(100)  := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_Remitente                  VARCHAR2(100)  := 'notificaciones_telcos@telconet.ec';
    Lv_Destinatario               VARCHAR2(100)  := NVL(Pv_EmailUsrSesion,'notificaciones_telcos@telconet.ec')||',';
    Lv_Asunto                     VARCHAR2(300)  := 'Notificacion REPORTE DE CLIENTES PRIMERA FACTURA ';
    Lv_Cuerpo                     VARCHAR2(9999) := '';
    Lv_IpCreacion                 VARCHAR2(10)   := '127.0.0.1';
    Ln_Total                      NUMBER         := 0;
    Lv_NombreArchivoZip           VARCHAR2(250)  := Lv_NombreArchivo||'.gz';
    Lc_GetDatos                   SYS_REFCURSOR;
    Lr_Datos                      DB_COMERCIAL.CMKG_TYPES.Lr_RptClientesFacturas;
    Lc_GetAliasPlantilla          DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo                 UTL_FILE.FILE_TYPE;

  BEGIN

    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DFC');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;

    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000); 

    Pv_MsjResultado      := 'Reporte generado y enviado correctamente .'; 

    Lc_GetDatos := DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_CLIENTES_FACTURAS(Pn_EmpresaId,
                                                                      Pv_PrefijoEmpresa,
                                                                      Pv_UsrSesion,
                                                                      Pv_EmailUsrSesion,
                                                                      Pv_FechaCreacionDesde,
                                                                      Pv_FechaCreacionHasta,
                                                                      Pv_FechaActivacionDesde,
                                                                      Pv_FechaActivacionHasta,
                                                                      Pv_FechaPrePlanificacionDesde,
                                                                      Pv_FechaPrePlanificacionHasta,
                                                                      Pv_Identificacion,
                                                                      Pv_RazonSocial,
                                                                      Pv_Nombres,
                                                                      Pv_Apellidos,
                                                                      Pv_IdsPlan,
                                                                      Pv_IdsOficinasVendedor,
                                                                      Pv_IdsOficinasPtoCobertura,
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
             );

   utl_file.put_line(Lfile_Archivo,'DESDE: '||Pv_FechaCreacionDesde||Lv_Delimitador  
           ||' '||Lv_Delimitador 
           ||'HASTA: '||Pv_FechaCreacionHasta||Lv_Delimitador 
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

    utl_file.put_line(Lfile_Archivo,'CLIENTE'||Lv_Delimitador  
           ||'IDENTIFICACION'||Lv_Delimitador 
           ||'FECHA CREACION CLIENTE'||Lv_Delimitador 
           ||'ESTADO CLIENTE'||Lv_Delimitador 
           ||'LOGIN'||Lv_Delimitador 
           ||'OFICINA PTO. COBERTURA'||Lv_Delimitador 
           ||'VENDEDOR'||Lv_Delimitador 
           ||'OFICINA VENDEDOR'||Lv_Delimitador 
           ||'USR APROBACION'||Lv_Delimitador 
           ||'FECHA APROBACION'||Lv_Delimitador 
           ||'ESTADO CONTRATO'||Lv_Delimitador 
           ||'NUM EMPRESA PUBLICA'||Lv_Delimitador 
           ||'SERVICIO'||Lv_Delimitador 
           ||'FECHA PRE-PLANIFICACION'||Lv_Delimitador            
           ||'FECHA ACTIVACION'||Lv_Delimitador 
           ||'FACTURA'||Lv_Delimitador 
           ||'FECHA EMISION'||Lv_Delimitador
           ||'ESTADO FACTURA'||Lv_Delimitador 
           ||'TOTAL PAGOS'||Lv_Delimitador 
           ||'DESCRIPCION CTA.'||Lv_Delimitador 
           );  
    LOOP
      FETCH Lc_GetDatos INTO Lr_Datos;     
        EXIT
        WHEN Lc_GetDatos%NOTFOUND; 
        UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_Datos.cliente, '')||Lv_Delimitador  
             ||NVL(Lr_Datos.identificacion, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.fe_creacion_per, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.estado, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.login,'')||Lv_Delimitador 
             ||NVL(Lr_Datos.oficina_pto_cobertura, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.usr_vendedor, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.oficina_vendedor, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.usr_aprobacion, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.fe_aprobacion, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.estado_contrato, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.numero_emp_pub, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.servicio, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.fe_preplanificacion, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.fe_activacion, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.numero_factura_sri, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.fe_emision, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.estado_impresion_fact, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.total_pagos, '')||Lv_Delimitador 
             ||NVL(Lr_Datos.descripcion_cuenta, '')||Lv_Delimitador         
             );                           

    END LOOP; 

    UTL_FILE.fclose(Lfile_Archivo);
    DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip);
    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip); 

    EXCEPTION
      WHEN OTHERS THEN
        --
        Pv_MsjResultado      := 'Error al generar el reporte.'; 

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'CMKG_REPORTE_COMERCIAL.P_REPORTE_CLIENTES_FACTURAS', 
                                              SQLERRM,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                            );
  END P_REPORTE_CLIENTES_FACTURAS;



PROCEDURE P_REPORTE_ARCOTEL_SERV_ACT(pv_prefijo_empresa IN VARCHAR2,pv_mensaje_error OUT VARCHAR2)
IS
  --Costo del Query 19
  CURSOR c_get_servicios_activos(cn_contacto_fijo NUMBER,cn_contacto_movil_claro NUMBER, cn_contacto_movil_movistar NUMBER,
  cn_contacto_movil_cnt NUMBER, cv_estado VARCHAR2,pv_prefijo_empresa VARCHAR2, cn_solicitud NUMBER,cn_producto_carct NUMBER, 
  cv_estado_sol_camb_plan VARCHAR2,cv_fecha_reporte VARCHAR2,cn_servicio NUMBER)
  IS
    SELECT DISTINCT(infopunto.login),
      infopunto.descripcion_punto,
      infopunto.nombre_punto,
      infopersona.razon_social,
      infopersona.nombres
      ||' '
      ||infopersona.apellidos nombres_completo,
      infopersona.identificacion_cliente,
      infopunto.direccion direccion_punto,
      admitiponegocio.nombre_tipo_negocio,
      admiproducto.id_producto,
      infoservicio.id_servicio,
      infoservicio.fe_creacion,
      infoserviciotecnico.tercerizadora_id,
      (SELECT admiprovincia.nombre_provincia
      FROM db_general.admi_provincia admiprovincia
      WHERE admiprovincia.id_provincia =
        (SELECT MAX(admicanton.provincia_id)
        FROM db_general.admi_canton admicanton
        WHERE admicanton.id_canton =
          (SELECT MAX(admiparroquia.canton_id)
          FROM db_general.admi_parroquia admiparroquia
          WHERE admiparroquia.id_parroquia =
            (SELECT MAX(admisector.parroquia_id)
            FROM db_general.admi_sector admisector
            WHERE admisector.id_sector = infopunto.sector_id
            )
          )
        )
      ) provincia,
      (SELECT admicanton.nombre_canton
      FROM db_general.admi_canton admicanton
      WHERE admicanton.id_canton =
        (SELECT MAX(admiparroquia.canton_id)
        FROM db_general.admi_parroquia admiparroquia
        WHERE admiparroquia.id_parroquia =
          (SELECT MAX(admisector.parroquia_id)
          FROM db_general.admi_sector admisector
          WHERE admisector.id_sector = infopunto.sector_id
          )
        )
      ) canton,
      (SELECT admiparroqia.nombre_parroquia
      FROM db_general.admi_parroquia admiparroqia
      WHERE admiparroqia.id_parroquia =
        (SELECT MAX(admisector.parroquia_id)
        FROM db_general.admi_sector admisector
        WHERE admisector.id_sector = infopunto.sector_id
        )
      ) parroquia,
      (SELECT listagg(infopuntoformacontacto.valor, ':') WITHIN GROUP (
      ORDER BY infopuntoformacontacto.fe_creacion)
      FROM db_comercial.info_punto_forma_contacto infopuntoformacontacto
      WHERE infopuntoformacontacto.forma_contacto_id = cn_contacto_fijo
      AND infopuntoformacontacto.punto_id            = infopunto.id_punto
      AND infopuntoformacontacto.estado              = cv_estado
      ) telefono_fijo,
      (SELECT listagg(infopuntoformacontacto.valor, ':') WITHIN GROUP (
      ORDER BY infopuntoformacontacto.fe_creacion)
      FROM db_comercial.info_punto_forma_contacto infopuntoformacontacto
      WHERE (infopuntoformacontacto.forma_contacto_id = cn_contacto_movil_claro
      OR infopuntoformacontacto.forma_contacto_id     = cn_contacto_movil_movistar
      OR infopuntoformacontacto.forma_contacto_id     = cn_contacto_movil_cnt)
      AND infopuntoformacontacto.punto_id             = infopunto.id_punto
      AND infopuntoformacontacto.estado               = cv_estado
      ) telefono_movil,
      admiproducto.descripcion_producto,
      (SELECT admitipomedio.nombre_tipo_medio
      FROM db_infraestructura.admi_tipo_medio admitipomedio
      WHERE admitipomedio.id_tipo_medio = infoserviciotecnico.ultima_milla_id
      ) ultima_milla,
      infoelemento.nombre_elemento,
      infointerfaceelemento.nombre_interface_elemento,
      (SELECT admimarcaelemento.nombre_marca_elemento
      FROM db_infraestructura.admi_marca_elemento admimarcaelemento
      WHERE admimarcaelemento.id_marca_elemento =
        (SELECT MAX(admimodeloelemento.marca_elemento_id)
        FROM db_infraestructura.admi_modelo_elemento admimodeloelemento
        WHERE admimodeloelemento.id_modelo_elemento =
          (SELECT MAX(infoelemento.modelo_elemento_id)
          FROM db_infraestructura.info_elemento infoelemento
          WHERE infoelemento.id_elemento = infoserviciotecnico.elemento_cliente_id
          )
        )
      ) marca_cpe,
      (SELECT admimodeloelemento.nombre_modelo_elemento
      FROM db_infraestructura.admi_modelo_elemento admimodeloelemento
      WHERE admimodeloelemento.id_modelo_elemento =
        (SELECT MAX(infoelemento.modelo_elemento_id)
        FROM db_infraestructura.info_elemento infoelemento
        WHERE infoelemento.id_elemento = infoserviciotecnico.elemento_cliente_id
        )
      ) modelo_cpe,
      infoserviciotecnico.tercerizadora_id empresa_tercerizadora,
      (SELECT infoelemento.nombre_elemento
      FROM db_infraestructura.info_elemento infoelemento
      WHERE infoelemento.id_elemento =
        (SELECT MAX(inforelacionelemento.elemento_id_a)
        FROM db_infraestructura.info_relacion_elemento inforelacionelemento
        WHERE inforelacionelemento.elemento_id_b =
          (SELECT MAX(infointerfaceelemento.elemento_id)
          FROM db_infraestructura.info_interface_elemento infointerfaceelemento
          WHERE infointerfaceelemento.id_interface_elemento = (
            (SELECT MAX(infoservicioprodcaract.valor)
            FROM db_comercial.info_servicio_prod_caract infoservicioprodcaract
            WHERE infoservicioprodcaract.servicio_id               = infoservicio.id_servicio
            AND infoservicioprodcaract.producto_caracterisitica_id = cn_producto_carct
            AND infoservicioprodcaract.estado                      = cv_estado
            ))
          )
        )
      ) login_nodo_wifi,
      (SELECT infoElemento.NOMBRE_ELEMENTO
      FROM db_infraestructura.info_elemento infoElemento
      WHERE infoElemento.ID_ELEMENTO =
        (SELECT MAX(infoPuntoDatoAdicional.ELEMENTO_ID)
        FROM db_comercial.INFO_PUNTO_DATO_ADICIONAL infoPuntoDatoAdicional
        WHERE punto_id = infopunto.id_punto
        )
      ) Edificio_padre,
      infoservicio.precio_venta valor_servicio,
      DECODE(infoservicio.es_venta,'S','VENTA','CORTESIA') tipo_venta,
      (SELECT MAX(infoserviciohistorial.fe_creacion)
      FROM db_comercial.info_servicio_historial infoserviciohistorial
      WHERE infoserviciohistorial.estado = cv_estado
      AND infoserviciohistorial.accion   = 'confirmarServicio'
      AND servicio_id                    = infoservicio.id_servicio
      ) fe_activacion_servicio,
      (SELECT MAX(infodetallesolhist.fe_creacion)
        FROM db_comercial.info_detalle_sol_hist infodetallesolhist
      WHERE infodetallesolhist.detalle_solicitud_id IN
        (SELECT infodetallesolicitud.id_detalle_solicitud
        FROM db_comercial.info_detalle_solicitud infodetallesolicitud
        WHERE infodetallesolicitud.tipo_solicitud_id = cn_solicitud
        AND infodetallesolicitud.servicio_id         = infoservicio.id_servicio
        )
      AND infodetallesolhist.estado = cv_estado_sol_camb_plan
      ) ultima_fecha_cambio_plan
    FROM db_comercial.info_servicio infoservicio,
      db_comercial.info_punto infopunto,
      db_comercial.info_persona_empresa_rol infopersonempresarol,
      db_comercial.info_persona infopersona,
      db_comercial.admi_tipo_negocio admitiponegocio,
      db_comercial.admi_producto admiproducto,
      db_comercial.info_servicio_tecnico infoserviciotecnico,
      db_comercial.info_elemento infoelemento,
      db_comercial.admi_tipo_medio admitipomedio,
      db_infraestructura.info_interface_elemento infointerfaceelemento
    WHERE infoservicio.punto_id                     = infopunto.id_punto
    AND admitiponegocio.id_tipo_negocio             = infopunto.tipo_negocio_id
    AND infopunto.persona_empresa_rol_id            = infopersonempresarol.id_persona_rol
    AND infopersonempresarol.persona_id             = infopersona.id_persona
    AND admiproducto.id_producto                    = infoservicio.producto_id
    AND infoserviciotecnico.servicio_id(+)             = infoservicio.id_servicio
    AND infoelemento.id_elemento(+)                    = infoserviciotecnico.elemento_id
    AND admitipomedio.id_tipo_medio(+)                 = infoserviciotecnico.ultima_milla_id
    AND infointerfaceelemento.id_interface_elemento(+) = infoserviciotecnico.interface_elemento_id
    AND infopunto.login IS NOT NULL
    AND infopersonempresarol.estado                 = cv_estado
    AND infoservicio.estado                         = cv_estado
    AND infoservicio.id_servicio                    = cn_servicio
    AND infoservicio.fe_creacion <= to_date(cv_fecha_reporte,'dd/mm/yyyy');


    --Se obtienen todos los servicios de INTERNET y DATOS 
    CURSOR c_getServicios(cv_estado VARCHAR2,cv_prefijo VARCHAR2,cv_internet VARCHAR2,cv_datos VARCHAR2) IS
    SELECT infoservicio.id_servicio 
    FROM db_comercial.info_servicio infoservicio
    WHERE infoservicio.estado = cv_estado
    AND infoservicio.producto_id   IN
          (SELECT admiproducto.id_producto
          FROM db_comercial.admi_producto admiproducto
          WHERE admiproducto.empresa_cod =
            (SELECT infoempresagrupo.cod_empresa
            FROM db_comercial.info_empresa_grupo infoempresagrupo
            WHERE infoempresagrupo.prefijo = cv_prefijo
            )
          AND (admiproducto.clasificacion = cv_internet OR 
          admiproducto.clasificacion = cv_datos)
          );



    --Se obtiene el ancho de banda de subida/bajada
    CURSOR c_getanchobanda(cn_caracteristicaid NUMBER,cn_productoid NUMBER,cn_servicioid NUMBER,cv_estado VARCHAR2,cv_estadoP VARCHAR2)
    IS
      SELECT MAX(infoservicioprod.valor)
      FROM db_comercial.info_servicio_prod_caract infoservicioprod
      WHERE infoservicioprod.producto_caracterisitica_id =
        (SELECT MAX(admiproductocaract.id_producto_caracterisitica)
        FROM db_comercial.admi_producto_caracteristica admiproductocaract
        WHERE admiproductocaract.producto_id     = cn_productoid
        AND admiproductocaract.estado            = cv_estado
        AND admiproductocaract.caracteristica_id = cn_caracteristicaid
        )
    AND infoservicioprod.servicio_id = cn_servicioid
    AND infoservicioprod.estado      = cv_estadoP;
    --Se obtiene la empresa tercerizadora
    CURSOR c_getempresatercerizadora(cn_personaempresarol NUMBER,cv_estado VARCHAR2)
    IS
      SELECT infopersona.razon_social
      FROM db_comercial.info_persona infopersona
      WHERE infopersona.id_persona =
        (SELECT MAX(infopersonaempresarol.id_persona_rol)
        FROM db_comercial.info_persona_empresa_rol infopersonaempresarol
        WHERE infopersonaempresarol.id_persona_rol = cn_personaempresarol
        AND infopersonaempresarol.estado           = cv_estado
        );
    --Se obtiene valor de parametro
    CURSOR C_GetParametro(cv_nombre_parametro VARCHAR2,cv_descripcion VARCHAR2)
    IS
      SELECT admipatametrodet.valor1
      FROM db_general.admi_parametro_det admipatametrodet
      WHERE admipatametrodet.parametro_id =
        (SELECT admipatametrocab.id_parametro
        FROM db_general.admi_parametro_cab admipatametrocab
        WHERE admipatametrocab.nombre_parametro = cv_nombre_parametro
        )
    AND admipatametrodet.descripcion = cv_descripcion;

    --Se obtiene el id de una solicitud
    CURSOR c_get_id_solicitud(cv_descripcion VARCHAR2,cv_estado VARCHAR2)
    IS
      SELECT admiTipoSolicitud.ID_TIPO_SOLICITUD
      FROM db_comercial.ADMI_TIPO_SOLICITUD admiTipoSolicitud
      WHERE admiTipoSolicitud.DESCRIPCION_SOLICITUD = cv_descripcion
      AND admiTipoSolicitud.estado                  = cv_estado; 

    --Se obtiene el id del producto caracteristica del producto wifi
    CURSOR c_get_caract_prod_wifi(cv_descripcion VARCHAR2,cv_caracteristica VARCHAR2,cv_estado VARCHAR2)
    IS
      SELECT admiproductocaracteristica.ID_PRODUCTO_CARACTERISITICA
      FROM db_comercial.admi_producto_caracteristica admiproductocaracteristica
      WHERE admiproductocaracteristica.producto_id =
        (SELECT admiproducto.id_producto
        FROM db_comercial.admi_producto admiproducto
        WHERE admiproducto.descripcion_producto = cv_descripcion
        AND admiproducto.estado                 = cv_estado
        )
    AND admiproductocaracteristica.caracteristica_id =
      (SELECT id_caracteristica
      FROM db_comercial.admi_caracteristica
      WHERE descripcion_caracteristica = cv_caracteristica
      );      

    --Se obtiene id de la caracteristica
    CURSOR c_get_caracteristica(cv_descripcion VARCHAR2,cv_estado VARCHAR2)
    IS
      SELECT admicaracteristica.id_caracteristica
      FROM db_comercial.admi_caracteristica admicaracteristica
      WHERE admicaracteristica.descripcion_caracteristica = cv_descripcion
      AND admicaracteristica.estado = cv_estado;

    --Se obtiene fecha de activacion del servicio
    CURSOR c_get_fecha_activacion(cn_servicio NUMBER,cv_estado VARCHAR2)
    IS    
    SELECT MIN(infoserviciohistorial.fe_creacion)
    FROM db_comercial.info_servicio_historial infoserviciohistorial
    WHERE infoserviciohistorial.observacion LIKE '%Se confirmo el servicio%'
    AND infoserviciohistorial.servicio_id = cn_servicio
    AND infoserviciohistorial.estado = cv_estado;


    Lv_fecha_archivo               VARCHAR2(20)   := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
    Lv_fecha_reporte               VARCHAR2(20)   := TO_CHAR(SYSDATE, 'DD/MM/YYYY');
    Lv_Fecha_ejecucion             VARCHAR2(40)   := TO_CHAR(SYSDATE, 'DD/MM/YYYY HH:MI:SS');
    Lv_Asunto_Notificacion         VARCHAR2(100)  := 'Notificaci�n de Generacion de Reporte Mensual Arcotel';
    Lv_directorio                  VARCHAR2(50)   := 'DIR_REPORTES_ARCOTEL';
    Lv_nombre_archivo              VARCHAR2(100)  := 'ReporteArcotelServiciosActivosTN_'|| Lv_fecha_archivo||'.csv';
    Lv_parametro_proyecto_arcotel  VARCHAR2(100)  := 'PARAMETROS PROYECTO ARCOTEL';
    Lv_parametro_remitente         VARCHAR2(100)  := 'CORREO_REMITENTE';
    Lv_parametro_destinatario      VARCHAR2(100)  := 'CORREO_DESTINATARIO';
    Lv_parametro_direcc_reporte    VARCHAR2(100)  := 'DIRECCION_REPORTES_SERV_ACT';
    Lv_parametro_comando_reporte   VARCHAR2(100)  := 'COMANDO_REPORTE';    
    Lv_parametro_extension_repor   VARCHAR2(100)  := 'EXTENSION_REPORTE';      
    Lv_parametro_plantilla         VARCHAR2(100)  := 'PLANTILLA_NOTIFICACION_SERV_ACT';    
    Lv_parametro_cambio_plan       VARCHAR2(100)  := 'CAMBIO PLAN';   
    Lv_parametro_internet_wifi     VARCHAR2(100)  := 'INTERNET WIFI';   
    Lv_parametro_interface_eleme   VARCHAR2(100)  := 'INTERFACE_ELEMENTO_ID';    
    Lv_parametro_capacidad1        VARCHAR2(100)  := 'CAPACIDAD1';       
    Lv_parametro_capacidad2        VARCHAR2(100)  := 'CAPACIDAD2';      
    Lv_internet                    VARCHAR2(100)  := 'INTERNET';       
    Lv_datos                       VARCHAR2(100)  := 'DATOS';    
    Lv_IpCreacion                  VARCHAR2(30)   := '127.0.0.1';     
    Ln_caracteristica_capacidad1   number         ;
    Ln_caracteristica_capacidad2   number         ;
    Lv_gzip                        VARCHAR2(500)  := '';    
    Lv_Nombre_Archivo_Correo       VARCHAR2(100)  := '';
    Lv_Plantilla_Notificacion      VARCHAR2(4000) := '';
    Lv_ancho_banda_subida          VARCHAR2(10)   := '';
    Lv_ancho_banda_bajada          VARCHAR2(10)   := '';
    Lv_ancho_banda_anterior_bajada VARCHAR2(10)   := '';
    Lv_tercerizadora               VARCHAR2(100)  := '';
    Lv_Remitente                   VARCHAR2(100)  := '';
    Lv_Destinatario                VARCHAR2(100)  := '';
    Lv_Direccion_completa_reporte  VARCHAR2(200)  := '';
    Lv_Comando_reporte_serv_Act    VARCHAR2(50)   := '';    
    Lv_Extension_reporte_serv_Act  VARCHAR2(50)   := '';      
    Lt_Fecha_Activacion            TIMESTAMP           ;
    Lf_archivo                     UTL_FILE.FILE_TYPE;
    Lv_delimitador             VARCHAR2(1)  := '|';
    Ln_contacto_fijo           NUMBER       := 4;
    Ln_contacto_movil_claro    NUMBER       := 25;
    Ln_contacto_movil_movistar NUMBER       := 26;
    Ln_contacto_movil_cnt      NUMBER       := 27;
    Lv_estado                  VARCHAR2(10) := 'Activo';
    Lv_prefijo_empresa         VARCHAR2(5)  := pv_prefijo_empresa;
    Lr_servicios               c_get_servicios_activos%ROWTYPE;
    Ln_sol_cambio_plan         NUMBER       ;
    Ln_prod_caract_prod_wifi   NUMBER       ;
    Lv_estado_sol_camb_plan    VARCHAR2(20) := 'Finalizada';
  BEGIN
    --Se crea el archivo
    Lf_Archivo := UTL_FILE.FOPEN(Lv_Directorio,Lv_Nombre_Archivo,'w',3000);

    IF (C_GetParametro%isopen) THEN 
      CLOSE C_GetParametro;
    END IF;    
    --Se obtiene el remitente
    OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_remitente);
    FETCH C_GetParametro INTO Lv_Remitente;
    CLOSE C_GetParametro;
    --Se obtiene el destinatario
    OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_destinatario);
    FETCH C_GetParametro INTO Lv_Destinatario;
    CLOSE C_GetParametro;
    --Se obtiene la direccion donde se almacenan los reportes de servicios activos
    OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_direcc_reporte);
    FETCH C_GetParametro INTO Lv_Direccion_completa_reporte;
    CLOSE C_GetParametro;
    --Se obtiene el comando a ejecutar
    OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_comando_reporte);    
    FETCH C_GetParametro INTO Lv_Comando_reporte_serv_Act;
    CLOSE C_GetParametro;    
    --Se obtiene el comando a ejecutar
    OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_extension_repor);
    FETCH C_GetParametro INTO Lv_Extension_reporte_serv_Act;    
    CLOSE C_GetParametro;     
    --Se obtiene la plantilla para la notificacion
    OPEN C_GetParametro(Lv_parametro_proyecto_arcotel,Lv_parametro_plantilla);
    FETCH C_GetParametro INTO Lv_plantilla_notificacion;    
    CLOSE C_GetParametro;       


    IF (c_get_id_solicitud%isopen) THEN 
      CLOSE c_get_id_solicitud;
    END IF;    
    --Se obtiene el id de una solicitud
    OPEN c_get_id_solicitud(Lv_parametro_cambio_plan,'Activo'); 
    FETCH c_get_id_solicitud INTO Ln_sol_cambio_plan;
    CLOSE c_get_id_solicitud;   

    IF (c_get_caract_prod_wifi%isopen) THEN 
      CLOSE c_get_caract_prod_wifi;
    END IF;        
    --Se obtiene el id de una solicitud
    OPEN c_get_caract_prod_wifi(Lv_parametro_internet_wifi,Lv_parametro_interface_eleme,'Activo');
    FETCH c_get_caract_prod_wifi INTO Ln_prod_caract_prod_wifi;
    CLOSE c_get_caract_prod_wifi;      

    IF (c_get_caracteristica%isopen) THEN 
      CLOSE c_get_caracteristica;
    END IF;    
    --Se obtiene la caracteristica capacitdad 1
    OPEN c_get_caracteristica(Lv_parametro_capacidad1,'Activo'); 
    FETCH c_get_caracteristica INTO Ln_caracteristica_capacidad1;
    CLOSE c_get_caracteristica;      
    --Se obtiene la caracteristica capacitdad 2
    OPEN c_get_caracteristica(Lv_parametro_capacidad2,'Activo');
    FETCH c_get_caracteristica INTO Ln_caracteristica_capacidad2;
    CLOSE c_get_caracteristica;      

    --Se insertan las CABECERAS
    utl_file.put_line(lf_archivo, 
                        'LOGIN PUNTO'||lv_delimitador 
                      ||'DESCRIPCION PUNTO'||lv_delimitador
                      ||'NOMBRE PUNTO'||lv_delimitador
                      ||'RAZON SOCIAL'||lv_delimitador
                      ||'NOMBRES COMPLETO'||lv_delimitador 
                      ||'IDENTIFICACION'||lv_delimitador 
                      ||'DIRECCION PUNTO'||lv_delimitador 
                      ||'TIPO NEGOCIO'||lv_delimitador 
                      ||'PROVINCIA'||lv_delimitador 
                      ||'CANTON'||lv_delimitador 
                      ||'PARROQUIA'||lv_delimitador 
                      ||'ANCHO BANDA BAJADA'||lv_delimitador 
                      ||'ANCHO BANDA SUBIDA'||lv_delimitador 
                      ||'TELEFONO FIJO'||lv_delimitador 
                      ||'TELEFONO MOVIL'||lv_delimitador 
                      ||'DESCRIPCION PRODUCTO'||lv_delimitador
                      ||'ULTIMA MILLA'||lv_delimitador 
                      ||'SWITCH'||lv_delimitador 
                      ||'PUERTO'||lv_delimitador 
                      ||'MARCA DEL CPE'||lv_delimitador 
                      ||'MODELO DEL CPE'||lv_delimitador 
                      ||'EMPRESA TERCERIZADORA'||lv_delimitador 
                      ||'LOGIN NODO WIFI'||lv_delimitador
                      ||'EDIFICIO PADRE'||lv_delimitador
                      ||'VALOR'||lv_delimitador 
                      ||'TIPO VENTA'||lv_delimitador 
                      ||'FECHA CREACION SERVICIO'||lv_delimitador
                      ||'FECHA  ACTIVACION'||lv_delimitador 
                      ||'ULTIMO CAMBIO PLAN'||lv_delimitador 
                      ||'ANCHO BANDA  ANTERIOR'||lv_delimitador);                       

    IF (c_getServicios%isopen) THEN 
      CLOSE c_getServicios;
    END IF;          

    FOR i in c_getServicios(Lv_estado,Lv_prefijo_empresa,Lv_internet,Lv_datos) LOOP

      IF (c_get_servicios_activos%isopen) THEN 
        CLOSE c_get_servicios_activos;
      END IF;


      OPEN c_get_servicios_activos(Ln_contacto_fijo,Ln_contacto_movil_claro,Ln_contacto_movil_movistar, Ln_contacto_movil_cnt,
                                   Lv_estado,Lv_prefijo_empresa,Ln_sol_cambio_plan,Ln_prod_caract_prod_wifi,Lv_estado_sol_camb_plan,
                                   Lv_fecha_reporte,i.id_servicio);
      FETCH c_get_servicios_activos INTO Lr_servicios;
      CLOSE c_get_servicios_activos;

      Lv_ancho_banda_subida := '';
      Lv_ancho_banda_bajada := '';
      Lv_tercerizadora      :='';

      IF (c_getanchobanda%isopen) THEN 
        CLOSE c_getanchobanda;
      END IF;        
      --Se obtiene el ancho de banda de subida
      OPEN c_getanchobanda(Ln_caracteristica_capacidad1,Lr_servicios.id_producto,Lr_servicios.id_servicio,'Activo','Activo');
      FETCH c_getanchobanda INTO Lv_ancho_banda_subida;
      CLOSE c_getanchobanda;
      --Se obtiene el ancho de banda de bajada
      OPEN c_getanchobanda(Ln_caracteristica_capacidad2,Lr_servicios.id_producto,Lr_servicios.id_servicio,'Activo','Activo');
      FETCH c_getanchobanda INTO Lv_ancho_banda_bajada;
      CLOSE c_getanchobanda;
      --Se obtiene el ancho de banda anterior de bajada
      OPEN c_getanchobanda(Ln_caracteristica_capacidad2,Lr_servicios.id_producto,Lr_servicios.id_servicio,'Activo','Eliminado');
      FETCH c_getanchobanda INTO Lv_ancho_banda_anterior_bajada;
      CLOSE c_getanchobanda;

      IF (c_getempresatercerizadora%isopen) THEN 
        CLOSE c_getempresatercerizadora;
      END IF;   

      --Se obtiene el ancho de banda de subida
      OPEN c_getempresatercerizadora(Lr_servicios.tercerizadora_id,'Activo');
      FETCH c_getempresatercerizadora INTO Lv_tercerizadora;
      CLOSE c_getempresatercerizadora; 

      IF(Lr_servicios.Fe_Activacion_Servicio IS NULL) THEN

        IF (c_get_fecha_activacion%isopen) THEN 
        CLOSE c_get_fecha_activacion;
        END IF; 

        --Se obtiene la fecha de activacion del servicio 
        OPEN c_get_fecha_activacion(Lr_servicios.id_servicio,Lv_estado);
        FETCH c_get_fecha_activacion INTO Lt_Fecha_Activacion;
        CLOSE c_get_fecha_activacion;               

      ELSE      
        Lt_Fecha_Activacion := Lr_servicios.Fe_Activacion_Servicio;
      END IF;

      UTL_FILE.PUT_LINE(Lf_Archivo, Lr_servicios.Login||Lv_Delimitador                                                 -- 1)Login del Punto Cliente
      ||REPLACE(REPLACE(REPLACE(REPLACE(Lr_servicios.Descripcion_Punto,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),';','')
      ||Lv_Delimitador                                                                                                 -- 2)Descripcion del Punto
      ||REPLACE(REPLACE(REPLACE(REPLACE(Lr_servicios.Nombre_Punto,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),';','')
      ||Lv_Delimitador                                                                                                 -- 3)Nombre del Punto
      ||REPLACE(REPLACE(REPLACE(REPLACE(Lr_servicios.Razon_Social,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),';','')
      ||Lv_Delimitador                                                                                                 -- 4)Razon Social
      ||REPLACE(REPLACE(REPLACE(REPLACE(Lr_servicios.Nombres_Completo,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),';','')
      ||Lv_Delimitador                                                                                                 -- 5)Nombre Completo
      ||REPLACE(REPLACE(REPLACE(Lr_servicios.Identificacion_Cliente,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' ')
      ||Lv_Delimitador                                                                                                 -- 6)Identificacion
      ||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Lr_servicios.Direccion_Punto,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),'|',''),';','')
      ||Lv_Delimitador                                                 -- 7)Direccion del Punto
      ||Lr_servicios.Nombre_Tipo_Negocio||Lv_Delimitador               -- 8)Tipo de Negocio
      ||Lr_servicios.Provincia||Lv_Delimitador                         -- 9)Provincia del Punto
      ||Lr_servicios.Canton||Lv_Delimitador                            --10)Canton  del Punto
      ||Lr_servicios.Parroquia||Lv_Delimitador                         --11)Parroquia del Punto
      ||Lv_Ancho_Banda_Bajada||Lv_Delimitador                          --12)Ancho de Banda de Bajada
      ||Lv_Ancho_Banda_Subida||Lv_Delimitador                          --13)Ancho de Banda de Subida
      ||Lr_servicios.Telefono_Fijo||Lv_Delimitador                     --14)Telefonos fijos del punto
      ||Lr_servicios.Telefono_Movil||Lv_Delimitador                    --15)Telefonos moviles del punto
      ||REPLACE(REPLACE(REPLACE(REPLACE(Lr_servicios.Descripcion_Producto,CHR(10),' ') ,CHR(13),' ') ,CHR(9),' '),';','')
      ||Lv_Delimitador                                                 --16)Descripcion del Producto
      ||Lr_servicios.Ultima_Milla||Lv_Delimitador                      --17)Ultima Milla
      ||Lr_servicios.Nombre_Elemento||Lv_Delimitador                   --18)Nombre del Switch
      ||Lr_servicios.Nombre_Interface_Elemento||Lv_Delimitador         --19)Puerto
      ||Lr_servicios.Marca_Cpe||Lv_Delimitador                         --20)Marca del CPE
      ||Lr_servicios.Modelo_Cpe||Lv_Delimitador                        --21)Modelo del CPE
      ||Lv_Tercerizadora||Lv_Delimitador                               --22)Empresa Tercerizadora
      ||Lr_servicios.Login_Nodo_Wifi||Lv_Delimitador                   --23)Login Nodo WIFI
      ||Lr_servicios.Edificio_padre||Lv_Delimitador                    --24)Edificio Padre
      ||Lr_servicios.Valor_Servicio||Lv_Delimitador                    --25)Valor del Servicio
      ||Lr_servicios.Tipo_Venta||Lv_Delimitador                        --26)Tipo de Venta
      ||TO_CHAR(Lr_servicios.Fe_Creacion, 'DD/MM/YYYY')||Lv_Delimitador--27)Fecha de creacion del servicio
      ||TO_CHAR(Lt_Fecha_Activacion, 'DD/MM/YYYY')||Lv_Delimitador     --28)Fecha en la que se activo el servicio
      ||TO_CHAR(Lr_servicios.Ultima_Fecha_Cambio_Plan, 'DD/MM/YYYY')||Lv_Delimitador     --29)Ultima fecha en la que se realizo el cambio de plan
      ||Lv_ancho_banda_anterior_bajada||Lv_Delimitador                                   --30)Ancho de Banda Anterior
      );

    END LOOP;
    UTL_FILE.FCLOSE(LF_ARCHIVO);


    --Se arma el comando a ejecutar
    Lv_gzip := Lv_Comando_reporte_serv_Act || ' ' || Lv_Direccion_completa_reporte || Lv_nombre_archivo;
    --Armo nombre completo del archivo que se genera
    Lv_Nombre_Archivo_Correo := Lv_nombre_archivo || Lv_Extension_reporte_serv_Act;

    DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_gzip));
    /* Se envia notificacion de la generacion del reporte */
    Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<Lv_Nombre_Archivo_Correo>>',Lv_Nombre_Archivo_Correo);
    Lv_Plantilla_Notificacion := REPLACE(Lv_Plantilla_Notificacion,'<<Lv_Fecha_ejecucion>>',Lv_Fecha_ejecucion);  

   UTL_MAIL.SEND (sender     => Lv_Remitente, 
                  recipients => Lv_Destinatario, 
                  subject    => Lv_Asunto_Notificacion, 
                  MESSAGE    => Lv_Plantilla_Notificacion, 
                  mime_type  => 'text/html; charset=UTF-8');

  EXCEPTION
  WHEN OTHERS THEN
    pv_mensaje_error := 'COD_ERROR: '||SQLCODE||' - '||SQLERRM;

    db_general.gnrlpck_util.insert_error('Telcos +', 
                                          'CMKG_REPORTE_COMERCIAL.P_REPORTE_ARCOTEL_SERV_ACT', 
                                          SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'Telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );   

    --Se cierran cursores abiertos
    IF (c_get_servicios_activos%isopen) THEN
      CLOSE c_get_servicios_activos;
    END IF;
    IF (c_getServicios%isopen) THEN
      CLOSE c_getServicios;
    END IF; 
    IF (c_getanchobanda%isopen) THEN
      CLOSE c_getanchobanda;
    END IF;
    IF (c_getempresatercerizadora%isopen) THEN
      CLOSE c_getempresatercerizadora;
    END IF;
    IF (C_GetParametro%isopen) THEN
      CLOSE C_GetParametro;
    END IF;

    IF (c_get_caracteristica%isopen) THEN
      CLOSE c_get_caracteristica;
    END IF;
    IF (c_get_caract_prod_wifi%isopen) THEN
      CLOSE c_get_caract_prod_wifi;
    END IF;
    IF (c_get_id_solicitud%isopen) THEN
      CLOSE c_get_id_solicitud;
    END IF;  
  END P_REPORTE_ARCOTEL_SERV_ACT;

  END CMKG_REPORTE_COMERCIAL;
/