CREATE OR REPLACE PACKAGE DB_COMERCIAL.COMEK_CONSULTAS AS

  /**
  * Documentacion para la funcion F_GET_JEFE_BY_ID_PERSONA
  * Funcion que retorna el id persona deljefe
  *
  * @param  Fv_PrefijoEmpresa  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE
  * @return DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE
  * @author John Vera <javera@telconet.ec>
  * @version 1.0 15-05-2018
  */
  FUNCTION F_GET_JEFE_BY_ID_PERSONA(Pv_idPersona IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
    RETURN NUMBER;

  /**
  * Documentacion para F_GET_SERVICIOS_NOTIF_MASIVA
  * Funcion que retorna el listado de los clientes con envio masivo
  * 
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 20-10-2017
  * 
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 26-12-2017 Se modifica la consulta para comparar el saldo pendiente a nivel de punto de facturacion 
  *
  * @author Jos閿燂拷 Guam閿熺单 <jaguamanp@telconet.ec>
  * @version 1.1 19-11-2022 Se agrega el WITH TMP_ESTADO_PUNTO cuando no se ingresa datos de Fv_EstadoServicio, 
  * Fv_EstadoPunto, Fv_EstadoCliente  y se quita el LOOP para contar los registros
  *
  * @param Fv_DestinatariosCorreo        IN VARCHAR2 Recibe 'S' si se desea obtener los destinatarios del envio masivo que se quiere realizar
  * @param Fn_Start                      IN NUMBER Inicio del rownum
  * @param Fn_Limit                      IN NUMBER Fin del rownum
  * @param Fv_Grupo                      IN VARCHAR2 Recibe el nombre del grupo de un producto
  * @param Fv_Subgrupo                   IN VARCHAR2 Recibe el nombre del subgrupo de un producto
  * @param Fn_IdElementoNodo             IN NUMBER Recibe el id del elemento nodo
  * @param Fn_IdElementoSwitch           IN NUMBER Recibe el id del elemento switch
  * @param Fv_EstadoServicio             IN VARCHAR2 Recibe el estado del servicio
  * @param Fv_EstadoPunto                IN VARCHAR2 Recibe el estado del punto
  * @param Fv_EstadoCliente              IN VARCHAR2 Recibe el estado del cliente
  * @param Fv_ClientesVIP                IN VARCHAR2 Recibe 'S' si se desea filtrar solo por clientes que son VIP o 'N' para excluir a los clientes 
  *                                                  VIP
  * @param Fv_UsrCreacionFactura         IN VARCHAR2 Recibe el usuario de creacion de una factura
  * @param Fn_NumFacturasAbiertas        IN NUMBER Recibe el numero minimo de facturas abiertas
  * @param Fv_PuntosFacturacion          IN VARCHAR2 Recibe 'S' si se desea filtrar solo por puntos de facturacion
  * @param Fv_IdsTiposNegocio            IN VARCHAR2 Recibe los ids del tipo de negocio concatenados con ,
  * @param Fv_IdsOficinas                IN VARCHAR2 Recibe los ids de las oficinas concatenados con ,
  * @param Fn_IdFormaPago                IN NUMBER Recibe el id de la forma de pago
  * @param Fv_NombreFormaPago            IN VARCHAR2 Recibe el nombre de la forma de pago
  * @param Fv_IdsBancosTarjetas          IN VARCHAR2 Recibe los ids de los bancos o tarjetas concatenados con ,
  * @param Fv_FechaDesdeFactura          IN VARCHAR2 Recibe la fecha desde la que comparara la fecha de autorizacion de las facturas
  * @param Fv_FechaHastaFactura          IN VARCHAR2 Recibe la fecha hasta la que comparara la fecha de autorizacion de las facturas
  * @param Fv_SaldoPendientePago         IN VARCHAR2 Recibe 'S' si se desea filtrar solo a los clientes con saldo pendiente de pago
  * @param Ff_ValorSaldoPendientePago    IN FLOAT Recibe el valor minimo para comparar el saldo pendiente de un cliente
  * @param Fv_IdsTiposContactos          IN VARCHAR2 Rebibe los ids del empresa rol asociados con el tipo de contacto
  * @param Fv_VariablesNotificacion      IN VARCHAR2 Recibe los nombres de las variables que se encuentran en la plantilla de la notificacion
  * @param Fn_TotalRegistros             OUT NUMBER Recibe el total de registros 
  * @return Frf_ListadoEnvioMasivo       OUT SYS_REFCURSOR Cursor que retorna el listado del envio masivo
  *
  */
  FUNCTION F_GET_SERVICIOS_NOTIF_MASIVA(Fv_DestinatariosCorreo     IN VARCHAR2,
                                        Fn_Start                   IN NUMBER,
                                        Fn_Limit                   IN NUMBER,
                                        Fv_Grupo                   IN VARCHAR2,
                                        Fv_Subgrupo                IN VARCHAR2,
                                        Fn_IdElementoNodo          IN NUMBER,
                                        Fn_IdElementoSwitch        IN NUMBER,
                                        Fv_EstadoServicio          IN VARCHAR2,
                                        Fv_EstadoPunto             IN VARCHAR2,
                                        Fv_EstadoCliente           IN VARCHAR2,
                                        Fv_ClientesVIP             IN VARCHAR2,
                                        Fv_UsrCreacionFactura      IN VARCHAR2,
                                        Fn_NumFacturasAbiertas     IN NUMBER,
                                        Fv_PuntosFacturacion       IN VARCHAR2,
                                        Fv_IdsTiposNegocio         IN VARCHAR2,
                                        Fv_IdsOficinas             IN VARCHAR2,
                                        Fn_IdFormaPago             IN NUMBER,
                                        Fv_NombreFormaPago         IN VARCHAR2,
                                        Fv_IdsBancosTarjetas       IN VARCHAR2,
                                        Fv_FechaDesdeFactura       IN VARCHAR2,
                                        Fv_FechaHastaFactura       IN VARCHAR2,
                                        Fv_SaldoPendientePago      IN VARCHAR2,
                                        Ff_ValorSaldoPendientePago IN FLOAT,
                                        Fv_IdsTiposContactos       IN VARCHAR2,
                                        Fv_VariablesNotificacion   IN VARCHAR2,
                                        Fn_TotalRegistros          OUT NUMBER)
    RETURN SYS_REFCURSOR;

  --
  /**
  * Documentacion para la Funcion 'F_GET_INFO_DASHBOARD_SERVICIO'
  *
  * Funcion que retorna la informacion del dashboard de servicio
  *
  * @param  Fn_IdDashboardServicio IN DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ID_DASHBOARD_SERVICIO%TYPE   Id del registro del dashboard de servicio
  * @param  Fv_Buscar    IN VARCHAR2   Parametro de lo que se desea consultar
  *
  * @return VARCHAR2   Retorna la informacion consultada
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 21-07-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 12-10-2017 - Se agrega validacion para que retorne el motivo de migracion del registro.
  */
  FUNCTION F_GET_INFO_DASHBOARD_SERVICIO(Fn_IdDashboardServicio IN DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ID_DASHBOARD_SERVICIO%TYPE,
                                         Fv_Buscar              IN VARCHAR2)
    RETURN VARCHAR2;
  /**
  * Documentacion para la procedimiento 'P_GET_VENDEDORES_POR_META'
  *
  * Procedimiento que retorna el listado de los vendedores destacados segun los Parametros enviados por el usuario
  *
  * @param  Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE   Recibe el prefijo de la empresa a consultar
  * @param  Pd_FechaInicio    IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE    Fecha de inicio de los servicios a consultar
  * @param  Pd_FechaFin   IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE    Fecha de fin de los servicios a consultar (sin incluirla)
  * @param  Pv_Categoria    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE   Se envia el nombre de la categoria a buscar
  * @param  Pv_Grupo    IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE    Se envia el nombre del grupo de los productos a consultar
  * @param  Pv_Subgrupo   IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE   Se envia el nombre del subgrupo de los productos a consultar
  * @param  Pv_TipoVendedor   IN VARCHAR2   Tipo de vendedor a consultar
  * @param  Pv_TipoPersonal  IN VARCHAR2  Se envia el tipo de consulta por personal que se va a realizar 'SUBGERENTE' o 'VENDEDOR'
  * @param  Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Se envia el id del personal a consultar
  * @param  Pr_ListadoVendedores   OUT SYS_REFCURSOR   Cursor que retorna el listado de los vendedores
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 10-06-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 12-06-2017 - Se implementan cambios para poder mostrar la informacion de los vendedores con sus metas de un personal especifico ya
  *                           sea un 'VENDEDOR' o 'SUBGERENTE'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 12-07-2017 - Se agrega a la suma de VALOR_TOTAL el valor de la instalacion (NRC) dividido para 12 meses.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 28-07-2017 - Se adapta la funcionalidad para que consulte la informacion desde la nueva tabla 'DB_COMERCIAL.INFO_DASHBOARD_SERVICIO'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 12-10-2017 - Se modifica la consulta principal para que obtenga la informacion respectiva de los campos 'GRUPO', 'SUBGRUPO', 'MRC',
  *                           'NRC', 'CATEGORIA' y 'ACCION' de los campos nuevos agregados a la tabla 'DB_COMERCIAL.INFO_DASHBOARD_COMERCIAL'
  */
  PROCEDURE P_GET_VENDEDORES_POR_META(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                      Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                      Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                      Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                      Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                      Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                      Pv_TipoVendedor        IN VARCHAR2,
                                      Pv_TipoPersonal        IN VARCHAR2,
                                      Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                      Pr_ListadoVendedores   OUT SYS_REFCURSOR);
  --
  --
  /**
  * Documentacion para la procedimiento 'P_GET_LIST_VENDEDOR_DESTACADOS'
  *
  * Procedimiento que retorna el listado de los vendedores destacados segun los Parametros enviados por el usuario
  *
  * @param  Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE   Recibe el prefijo de la empresa a consultar
  * @param  Pd_FechaInicio    IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE    Fecha de inicio de los servicios a consultar
  * @param  Pd_FechaFin   IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE    Fecha de fin de los servicios a consultar (sin incluirla)
  * @param  Pv_Categoria    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE   Se envia el nombre de la categoria a buscar
  * @param  Pv_Grupo    IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE    Se envia el nombre del grupo de los productos a consultar
  * @param  Pv_Subgrupo   IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE   Se envia el nombre del subgrupo de los productos a consultar
  * @param  Pv_TipoPersonal  IN VARCHAR2  Se envia el tipo de consulta por personal que se va a realizar 'SUBGERENTE' o 'VENDEDOR'
  * @param  Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Se envia el id del personal a consultar
  * @param  Pn_Rownum       IN NUMBER       Cantidad de registros que se desean obtener
  * @param  Pr_ListadoVendedores   OUT SYS_REFCURSOR   Cursor que retorna el listado de los vendedores destacados
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 08-06-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 12-06-2017 - Se implementan cambios para poder mostrar la informacion de los vendedores destacados de un personal especifico ya sea
  *                           un 'VENDEDOR' o 'SUBGERENTE'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 12-07-2017 - Se agrega a la suma de VALOR_TOTAL el valor de la instalacion (NRC) dividido para 12 meses.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 28-07-2017 - Se adapta la funcionalidad para que consulte la informacion desde la nueva tabla 'DB_COMERCIAL.INFO_DASHBOARD_SERVICIO'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 12-10-2017 - Se modifica la consulta principal para que obtenga la informacion respectiva de los campos 'GRUPO', 'SUBGRUPO', 'MRC',
  *                           'NRC', 'CATEGORIA' y 'ACCION' de los campos nuevos agregados a la tabla 'DB_COMERCIAL.INFO_DASHBOARD_COMERCIAL'
  */
  PROCEDURE P_GET_LIST_VENDEDOR_DESTACADOS(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                           Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                           Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                           Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                           Pv_TipoPersonal        IN VARCHAR2,
                                           Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                           Pn_Rownum              IN NUMBER,
                                           Pr_ListadoVendedores   OUT SYS_REFCURSOR);
  --
  --
  /**
  * Documentacion para la procedimiento 'P_GET_LIST_PRODUCTO_DESTACADOS'
  *
  * Procedimiento que retorna el listado de los productos destacados segun los Parametros enviados por el usuario
  *
  * @param  Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE   Recibe el prefijo de la empresa a consultar
  * @param  Pd_FechaInicio    IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE    Fecha de inicio de los servicios a consultar
  * @param  Pd_FechaFin   IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE    Fecha de fin de los servicios a consultar (sin incluirla)
  * @param  Pv_Categoria    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE   Se envia el nombre de la categoria a buscar
  * @param  Pv_Grupo    IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE    Se envia el nombre del grupo de los productos a consultar
  * @param  Pv_Subgrupo   IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE   Se envia el nombre del subgrupo de los productos a consultar
  * @param  Pv_TipoPersonal  IN VARCHAR2  Se envia el tipo de consulta por personal que se va a realizar 'SUBGERENTE' o 'VENDEDOR'
  * @param  Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Se envia el id del personal a consultar
  * @param  Pn_Rownum       IN NUMBER       Cantidad de registros que se desean obtener
  * @param  Pr_ListadoProductos   OUT SYS_REFCURSOR   Cursor que retorna el listado de los productos destacados
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 08-06-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 12-06-2017 - Se implementan cambios para poder mostrar la informacion de los productos destacados de un personal especifico ya sea
  *                           un 'VENDEDOR' o 'SUBGERENTE'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 12-07-2017 - Se agrega a la suma de VALOR_TOTAL el valor de la instalacion (NRC) dividido para 12 meses.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 28-07-2017 - Se adapta la funcionalidad para que consulte la informacion desde la nueva tabla 'DB_COMERCIAL.INFO_DASHBOARD_SERVICIO'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 12-10-2017 - Se modifica la consulta principal para que obtenga la informacion respectiva de los campos 'GRUPO', 'SUBGRUPO', 'MRC',
  *                           'NRC', 'CATEGORIA' y 'ACCION' de los campos nuevos agregados a la tabla 'DB_COMERCIAL.INFO_DASHBOARD_COMERCIAL'
  */
  PROCEDURE P_GET_LIST_PRODUCTO_DESTACADOS(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                           Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                           Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                           Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                           Pv_TipoPersonal        IN VARCHAR2,
                                           Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                           Pn_Rownum              IN NUMBER,
                                           Pr_ListadoProductos    OUT SYS_REFCURSOR);
  --
  --
  /**
  * Documentacion para la procedimiento 'P_GET_INFO_DASHBOARD'
  *
  * Procedimiento que retorna la informacion correspondiente a las ventas por Categoria, Grupo o Subgrupos de productos la cual es presentada en el
  * dashboard comercial
  *
  * @param  Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE   Recibe el prefijo de la empresa a consultar
  * @param  Pd_FechaInicio    IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE    Fecha de inicio de los servicios a consultar
  * @param  Pd_FechaFin   IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE    Fecha de fin de los servicios a consultar (sin incluirla)
  * @param  Pv_Categoria    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE   Se envia el nombre de la categoria a buscar
  * @param  Pv_Grupo    IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE    Se envia el nombre del grupo de los productos a consultar
  * @param  Pv_Subgrupo   IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE   Se envia el nombre del subgrupo de los productos a consultar
  * @param  Pv_TipoPersonal  IN VARCHAR2  Se envia el tipo de consulta por personal que se va a realizar 'SUBGERENTE' o 'VENDEDOR'
  * @param  Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Se envia el id del personal a consultar
  * @param  Pr_InformacionDashboard   OUT SYS_REFCURSOR   Cursor que retorna la data informacion comercial obtenida
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 05-06-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 12-06-2017 - Se ordena la informacion por descripcion, grupo y subgrupo dependiendo de las opciones mostradas en el dashboard
  *                           comercial. Adicional se implementa cambios para poder mostrar la informacion de un personal especifico ya sea un
  *                           'VENDEDOR' o 'SUBGERENTE'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 12-07-2017 - Se agrega a la suma de VALOR_TOTAL el valor de la instalacion (NRC) dividido para 12 meses.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 28-07-2017 - Se adapta la funcionalidad para que consulte la informacion desde la nueva tabla 'DB_COMERCIAL.INFO_DASHBOARD_SERVICIO'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 12-10-2017 - Se modifica la consulta principal para que obtenga la informacion respectiva de los campos 'GRUPO', 'SUBGRUPO', 'MRC',
  *                           'NRC', 'CATEGORIA' y 'ACCION' de los campos nuevos agregados a la tabla 'DB_COMERCIAL.INFO_DASHBOARD_COMERCIAL'
  */
  PROCEDURE P_GET_INFO_DASHBOARD(Pv_PrefijoEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                 Pd_FechaInicio          IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                 Pd_FechaFin             IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                 Pv_Categoria            IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                 Pv_Grupo                IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                 Pv_Subgrupo             IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                 Pv_TipoPersonal         IN VARCHAR2,
                                 Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                 Pr_InformacionDashboard OUT SYS_REFCURSOR);
  --
  --
  /**
  * Documentacion para el procedimiento 'P_GET_SUM_ORDENES_SERVICIO'
  *
  * Procedimiento que retorna la cantidad de ordenes y la suma total de venta de las ordenes de servicio consultadas.
  *
  * @param  Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE   Recibe el prefijo de la empresa a consultar
  * @param  Pd_FechaInicio    IN VARCHAR2    Fecha de inicio de los servicios a consultar
  * @param  Pd_FechaFin   IN VARCHAR2    Fecha de fin de los servicios a consultar (sin incluirla)
  * @param  Pv_Categoria    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE   Se envia el nombre de la categoria a buscar
  * @param  Pv_Grupo    IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE    Se envia el nombre del grupo de los productos a consultar
  * @param  Pv_Subgrupo   IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE   Se envia el nombre del subgrupo de los productos a consultar
  * @param  Pv_TipoOrdenes    IN VARCHAR2   Parametro usado para identificar el tipo de ordenes a consultar
  * @param  Pv_Frecuencia       IN VARCHAR2     Parametro usado para identificar la frecuencia de las ordenes a consultar
  * @param  Pv_TipoPersonal  IN VARCHAR2  Se envia el tipo de consulta por personal que se va a realizar 'SUBGERENTE' o 'VENDEDOR'
  * @param  Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Se envia el id del personal a consultar
  * @param  Pv_OpcionSelect       IN VARCHAR2  Bandera que indica lo que se desea obtener del SELECT
  * @param  Pv_EmailUsrSesion       IN VARCHAR2  Email del usuario en session
  * @param  Pv_CantidadOrdenes    OUT NUMBER   Parametro usado para retornar la cantidad de ordenes encontradas
  * @param  Pv_TotalVenta    OUT NUMBER   Parametro usado para retornar el total de las ventas calculadas
  * @param  Pv_MensajeRespuesta    OUT VARCHAR2   Parametro usado para retornar obtener el mensaje de respuesta del procedimiento
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 09-06-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 12-06-2017 - Se implementan cambios para poder mostrar la informacion de un personal especifico ya sea un 'VENDEDOR' o 'SUBGERENTE'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 14-06-2017 - Se implementan la consulta de las solicitudes de descuento en estado 'Pendiente' asociadas a los servicios.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 05-07-2017 - Se modifica la Funcion para generar y enviar el excel de las ordenes de servicios ingresadas al TELCOS y consultadas
  *                           dependiendo de los Parametros ingresados por el usuario.
  *                           Se agrega a la suma de VALOR_TOTAL el valor de la instalacion (NRC) dividido para 12 meses.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 28-07-2017 - Se adapta la funcionalidad para que consulte la informacion desde la nueva tabla 'DB_COMERCIAL.INFO_DASHBOARD_SERVICIO'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.5 01-09-2017 - Se agrega la columna 'MOTIVO CANCELACION' cuando se exporta el detallado de las ordenes de servicio en estado 'Cancel'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.6 12-10-2017 - Se modifica la consulta principal para que obtenga la informacion respectiva de los campos 'GRUPO', 'SUBGRUPO', 'MRC',
  *                           'NRC', 'CATEGORIA' y 'ACCION' de los campos nuevos agregados a la tabla 'DB_COMERCIAL.INFO_DASHBOARD_COMERCIAL'
  * @version 1.7 06-11-2018 - Se modifica la consulta principal de manera que no reciba las categoria si no las lineas de negocio de la tabla 
  *                           'DB_COMERCIAL.INFO_DASHBOARD_COMERCIAL'  
  *
  * @author  Kevin Baque <kbaque@telconet.ec>
  * @version 1.8 29-09-2020 - Se modifica la consulta para presentar el valor de la instalaci閿熺单 sin dividirla para el a閿熺郸.
  *
  */
  PROCEDURE P_GET_SUM_ORDENES_SERVICIO(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                       Pd_FechaInicio         IN VARCHAR2,
                                       Pd_FechaFin            IN VARCHAR2,
                                       Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                       Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                       Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                       Pv_TipoOrdenes         IN VARCHAR2,
                                       Pv_Frecuencia          IN VARCHAR2,
                                       Pv_TipoPersonal        IN VARCHAR2,
                                       Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                       Pv_OpcionSelect        IN VARCHAR2,
                                       Pv_EmailUsrSesion      IN VARCHAR2,
                                       Pv_CantidadOrdenes     OUT NUMBER,
                                       Pv_TotalVenta          OUT NUMBER,
                                       Pv_MensajeRespuesta    OUT VARCHAR2);

    /**
     * Funci閿熺单 que devuelve si un punto enviado por par閿熺丹etro es un punto adicional.
     * Para determinar si es un punto adicional, se valida que existan m閿熺氮 puntos dentro de la misma persona empresa rol y que el rol sea "Cliente".
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 22-11-2018
     */
    FUNCTION F_ES_PUNTO_ADICIONAL (Pn_PuntoId    IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2;

    /**
     * Funci閿熺单 que devuelve si un punto enviado por par閿熺丹etro aplica la facturaci閿熺单 de instalaci閿熺单 seg閿熺单 su tipo de origen.
     * Para determinar si aplica una factura es necesario obtener la caracter閿熺氮tica TIPO_ORIGEN_TECNOLOGIA, el valor corresponde al ID_CARACTERISTICA
     * del punto. El cu閿熺担 se encuentra en el par閿熺丹etro COMBO_TIPO_ORIGEN_TECNOLOGIA_PUNTO y en el valor3 se encuentra la bandera si se factura o no.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 22-11-2018
     */
    FUNCTION F_APLICA_FACT_INST_ORIGEN_PTO (Pv_EmpresaCod IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                            Pn_PuntoId    IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2;

    /**
     * Funci閿熺单 que devuelve la descripci閿熺单 del rol de una personaEmpresaRolId.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 22-11-2018
     */
    FUNCTION F_GET_DESCRIPCION_ROL (Pn_PersonaEmpRolId DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE;

    /**
     * Funci閿熺单 que devuelve la informaci閿熺单 necesaria para poder generar las solicitudes de instalaci閿熺单.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 22-11-2018
     *
     * Costo Cursor C_GetValorInstalacion:4
     * @version 1.1  23-09-2019
     * @author Anabelle Pe閿熺禈herrera <apenaherrera@telconet.ec>
     * Se modifica CURSOR C_GetValorInstalacion para que obtenga el valor base de Instalaci閿熺单 por Ultima milla FO, CO 
     * y Forma de Pago Efectivo     
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 1.2
     * @since 27-02-2023  Se agrega par閿熺丹etro CvEmpresaCod en el cursor C_GetDiasVigencia, para filtrar el resultado por empresa.  
     */
    FUNCTION F_GET_INFO_SOL_INSTALACION (Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                         Pv_CaractContrato       IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                         Pv_NombreMotivo         IN  DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
                                         Pv_UltimaMilla          IN  DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE DEFAULT NULL)
    RETURN DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion;
  --
  /**
  * Documentacion para el procedimiento 'P_GET_AGRU_ORDENES'
  *
  * Procedimiento que retorna el vendedor, cantidad de ordenes y la suma total de venta de las ordenes de servicio consultadas.
  *
  * @param  Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE   Recibe el prefijo de la empresa a consultar
  * @param  Pd_FechaInicio    IN VARCHAR2    Fecha de inicio de los servicios a consultar
  * @param  Pd_FechaFin   IN VARCHAR2    Fecha de fin de los servicios a consultar (sin incluirla)
  * @param  Pv_Categoria    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE   Se envia el nombre de las lineas de negocio a buscar
  * @param  Pv_Grupo    IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE    Se envia el nombre del grupo de los productos a consultar
  * @param  Pv_Subgrupo   IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE   Se envia el nombre del subgrupo de los productos a consultar
  * @param  Pv_TipoOrdenes    IN VARCHAR2   Parametro usado para identificar el tipo de ordenes a consultar
  * @param  Pv_Frecuencia       IN VARCHAR2     Parametro usado para identificar la frecuencia de las ordenes a consultar
  * @param  Pv_TipoPersonal  IN VARCHAR2  Se envia el tipo de consulta por personal que se va a realizar 'SUBGERENTE' o 'VENDEDOR'
  * @param  Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE Se envia el id del personal a consultar
  * @param  Pv_OpcionSelect       IN VARCHAR2  Bandera que indica lo que se desea obtener del SELECT
  * @param  Pv_MensajeRespuesta    OUT VARCHAR2   Parametro usado para retornar obtener el mensaje de respuesta del procedimiento
  * @param  Pr_Informacion         OUT SYS_REFCURSOR   Parametro usado para retornar el cursor de todos los vendedores  
  *
  * @author kevin Baque <kbaque@telconet.ec>
  * @version 1.0 07-11-2018
  */
  PROCEDURE P_GET_AGRU_ORDENES(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                       Pd_FechaInicio         IN VARCHAR2,
                                       Pd_FechaFin            IN VARCHAR2,
                                       Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                       Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                       Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                       Pv_TipoOrdenes         IN VARCHAR2,
                                       Pv_Frecuencia          IN VARCHAR2,
                                       Pv_TipoPersonal        IN VARCHAR2,
                                       Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                       Pv_OpcionSelect        IN VARCHAR2,                                       
                                       Pv_MensajeRespuesta    OUT VARCHAR2,
                                       Pr_Informacion         OUT SYS_REFCURSOR);
  --  
  /**
  * Documentacion para la funcion COMEF_GET_ADMI_CARACTERISTICA
  * la funcion COMEF_GET_ADMI_CARACTERISTICA obtiene un registro de la tabla ADMI_CARACTERISTICA
  *
  * @param  Fv_DescripcionCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE    Recibe la descripcion de la caracteristica
  * @return ADMI_CARACTERISTICA%ROWTYPE  Retorna el registro ADMI_CARACTERISTICA
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 17-09-2015
  */
  FUNCTION COMEF_GET_ADMI_CARACTERISTICA(Fv_DescripcionCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    RETURN ADMI_CARACTERISTICA%ROWTYPE;
  --
  --
  --
  /**
  * Documentacion para la funcion F_GET_FECHA_RENOVACION_PLAN
  * 
  * La funcion retorna la fecha de renovacion de un servicio dependiendo de la frecuencia de su producto o plan
  *
  * @param  Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE    Recibe el id del servicio que se va a consultar
  * @return VARCHAR2  Retorna la fecha de renovacion del servicio
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 27-06-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 01-08-2016 - Se parametriza los planes que requieren renovacion
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 01-09-2017 - Se agrega NULL al Parametro fecha de la Funcion 'COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL'
  */
  FUNCTION F_GET_FECHA_RENOVACION_PLAN(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2;
  --
  --
  --
  --
  /**
  * Documentacion para la funcion F_GET_FECHA_CREACION_HISTORIAL
  * 
  * La funcion retorna la fecha de creacion de un servicio dependiendo de los Parametros enviados
  *
  * @param  Fn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE    Recibe el id del servicio que se va a consultar
  * @param  Fv_Buscar      IN VARCHAR2                                       Recibe un string con lo que se desea buscar
  * @param  Fv_Parametro   IN VARCHAR2                                       Recibe el Parametro donde se desea buscar en el historial
  * @return VARCHAR2       Retorna la fecha de creacion del historial del servicio
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 27-06-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 20-07-2017 - Se modifica la Funcion para que pueda buscar la fecha de historial dependiendo del estado del servicio que se desea
  *                           buscar
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 01-09-2017 - Se modifica la Funcion para agregar que consulte el motivo del historial ingresado en el servicio.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 13-10-2017 - Se modifica la Funcion para que consulte el motivo padre del historial ingresado en el servicio cancelado
  *                           Adicional se usa el Parametro 'Fd_FechaFin' en los Parametros de consulta que son 'HistorialByObservacionEstado' y
  *                           'HistorialByObservacionFeCreacion'
  */
  FUNCTION F_GET_FECHA_CREACION_HISTORIAL(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                          Fv_Buscar     IN VARCHAR2,
                                          Fv_Parametro  IN VARCHAR2,
                                          Fd_FechaFin   IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE)
    RETURN VARCHAR2;
  --
  --
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_NOMBRE_CLIENTE
  * la funcion F_GET_SOLMA_NOMBRE_CLIENTE obtiene el nombre o razon social del cliente en tabla INFO_PERSONA
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE    Recibe el Id detalle solicitud Cabecera
  * @return VARCHAR2  Retorna el nombre del cliente
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_NOMBRE_CLIENTE(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    RETURN VARCHAR2;
  --
  --
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_NOMBRE_PRODUCTO
  * la funcion F_GET_SOLMA_NOMBRE_PRODUCTO obtiene el nombre del producto en tabla ADMI_PRODUCTO
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE Recibe el Id detalle solicitud Cabecera
  * @return VARCHAR2  Retorna el nombre del cliente
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_NOMBRE_PRODUCTO(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    RETURN VARCHAR2;
  --
  --
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_CARACTERISTICA
  * la funcion F_GET_SOLMA_CARACTERISTICA obtiene el valor de la caracteristica en INFO_DETALLE_SOL_CARACT
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE    Recibe el Id detalle solicitud Cabecera
  * @param  Fn_descCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE Recibe la descripcion de la caracteristica
  * @return VARCHAR2  Retorna valor de la caracteristica
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_CARACTERISTICA(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                      Fn_descCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    RETURN VARCHAR2;
  --
  --
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_TOTAL_DET_EST
  * la funcion F_GET_SOLMA_TOTAL_DET_EST obtiene el total de detalles con determinado estado de una Solicitud Masiva
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE Recibe el Id detalle solicitud Cabecera
  * @param  Fn_estado IN VARCHAR2 Recibe el nombre del estado
  * @return NUMBER  Retorna la cantidad de detalles
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_TOTAL_DET_EST(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                     Fn_estado             IN VARCHAR2)
    RETURN NUMBER;
  --
  --
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_TOTAL_DET_EST_CAR
  * la funcion F_GET_SOLMA_TOTAL_DET_EST_CAR obtiene el total de detalles con determinado estado de una Solicitud Masiva en una caracteristica
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE Recibe el Id detalle solicitud Cabecera
  * @param  Fn_estado IN VARCHAR2 Recibe el nombre del estado
  * @param  Fn_caracteristica IN VARCHAR2 Recibe el nombre de la caracteristica
  * @return NUMBER  Retorna la cantidad de detalles
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_TOTAL_DET_EST_CAR(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                         Fn_caracteristica     IN VARCHAR2,
                                         Fn_estado             IN VARCHAR2)
    RETURN NUMBER;
  --
  /**
  * Documentacion para la funcion GET_MODEL_ELE_X_SERV_TIPO
  * la funcion GET_MODEL_ELE_X_SERV_TIPO obtiene un campo del Modelo de un elemento dependiendo del servicio
  *
  * @param  Pn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Recibe el Id del servicio
  * @param  Pn_TipoElemento   IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE Recibe el tipo de elemento
  * @param  Pn_Campo          IN VARCHAR2 campo que se desea del modelo
  * @return VARCHAR2          Retorna un campo del Modelo de un elemento
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 29-07-2016
  */
  FUNCTION GET_MODEL_ELE_X_SERV_TIPO(Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pn_TipoElemento IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE,
                                     Pn_Campo        IN VARCHAR2)
    RETURN VARCHAR2;
  --
  /**
  * Documentacion para la funcion GET_ELEMENTO_X_SERV_TIPO
  * la funcion GET_ELEMENTO_X_SERV_TIPO obtiene un id del elemento dependiendo del servicio y tipo de elemento
  *
  * @param  Pn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE Recibe el Id del servicio
  * @param  Pn_TipoElemento   IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE Recibe el tipo de elemento
  * @return DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE  Retorna un id del elemento
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 29-07-2016
  *
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.1 11-08-2016 - se cambia la consideracion del la consulta para todos los casos de ultima milla
  *
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.2 02-09-2016 - en caso de no encuentrar el elemento CPE verifica si el campo ELEMENTO_CLIENTE_ID es el id del CPE
  *
  * @author Duval Medina C. <dmedina@telconet.ec>
  * @version 1.3 2016-09-22 - Se modifico Cursor C_GetNombreTipoElemento al buscar CPE para busqueda adecuada
  *                           Se cambio variable Cn_IdInterfaceElemento por Cn_IdElemento
  */
  FUNCTION GET_ELEMENTO_X_SERV_TIPO(Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Pn_TipoElemento IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE;
  --
  /**
  * Documentacion para la funcion GET_ELEMENTO_CLI_X_TIPO_ELE
  * la funcion GET_ELEMENTO_CLI_X_TIPO_ELE obtiene un id del elemento interface id y tipo de elemento
  *
  * @param  Pn_IdInterfaceElementoConector     IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID%TYPE 
  *                                               Recibe el Id de la Interface Elemento Conector
  * @param  Pn_TipoElemento                    IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE Recibe el tipo de elemento
  * @return DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE  Retorna un id del elemento
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 29-07-2016
  *
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.1 11-08-2016 - Se reemplazo el igual por un like para que sea mas abierta la comparacion
  */
  FUNCTION GET_ELEMENTO_CLI_X_TIPO_ELE(Pn_IdInterfaceElementoConector IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID%TYPE,
                                       Pn_TipoElemento                IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE;
  --
  /**
  * Documentacion para la funcion F_GET_ID_ELEMENTO_PRINCIPAL
  * Obtiene el id del elemento principal partiendo desde una INTERFACE_ELEMENTO_CLIENTE_ID
  *
  * @param  Fn_IdInterfaceElementoCliente IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE
  *                                               Recibe el Id de la Interface Elemento Cliente
  * @param  Fv_TipoElemento               IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE Recibe el tipo de elemento
  * @return DB_COMERCIAL.INFO_ELEMENTO.ID_ELEMENTO%TYPE  Retorna un id del elemento
  * @author Duval Medina C. <dmedina@telconet.ec>
  * @version 1.0 2016-08-29
  */
  FUNCTION F_GET_ID_ELEMENTO_PRINCIPAL(Fn_IdInterfaceElementoCliente IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
                                       Fv_TipoElemento               IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_ELEMENTO.ID_ELEMENTO%TYPE;

  /**
  * Documentacion para la funcion F_GET_SOL_BY_SERVICIO_ID
  * Obtiene el numero total de las solicitudes segun los criterios de consulta enviados como Parametros.
  *
  * @param  Fn_IdServicio        IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE                 => Id del servicio relacionado a la solicitud.
  * @param  Fv_DescTipoSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE => Descripcion del tipo de solicitud.
  * @param  Fv_Estado            IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE             => Estado de la solicitud.
  * @return DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE  Retorna el detalle de la solicitud
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 24-03-2017
  */
  FUNCTION F_GET_SOL_BY_SERVICIO_ID(Fn_IdServicio        IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Fv_DescTipoSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                    Fv_Estado            IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
    RETURN NUMBER;

  /**
  * Documentacion para la funcion F_GET_PRODUCTO_BY_COD
  * Obtiene el id del producto con el codigo enviado como Parametro.
  *
  * @param  Fv_CodigoProducto    DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE  => codigo del producto.
  * @return DB_COMERCIAL.ADMI_PRODUCTO%ROWTYPE  Retorna el registro del producto con el codigo enviado como Parametro.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 24-03-2016
  */
  FUNCTION F_GET_PRODUCTO_BY_COD(Fv_CodigoProducto IN DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE)
    RETURN DB_COMERCIAL.ADMI_PRODUCTO%ROWTYPE;

  /**
  * Documentacion para la funcion F_GET_SOL_PEND_BY_SER_ID
  * Funcion que retorna las solicitudes pendientes segun los criterios enviados como Parametro.
  *
  * @param  Fv_DescripcionTipoSolicitud  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE  => Descripcion de ipo de solicitud.
  * @param  Fn_IdServicio                DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE                  => Id del servicio.
  * @return SYS_REFCURSOR                Retorna las solicitudes que cumplan con los criterios enviados como Parametros..
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 06-03-2017
  */
  FUNCTION F_GET_SOL_PEND_BY_SER_ID(Fv_DescripcionTipoSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                    Fn_IdServicio               IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN SYS_REFCURSOR;

  /**
  * Documentacion para la funcion F_GET_COD_BY_PREFIJO_EMP
  * Funcion que retorna el codigo de la empresa segun el prefijo enviado como Parametro.
  *
  * @param  Fv_PrefijoEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE => Prefijo de la empresa.
  * @return DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Retorna el codigo de la empresa.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 08-08-2017
  */
  FUNCTION F_GET_COD_BY_PREFIJO_EMP(Fv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    RETURN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;

  /**
  * Documentacion para P_PERSONA_BY_LOGIN_IDENTIFICACION
  * Procedimiento que realiza la verifica si existe la persona por login e identifacion
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 09/03/2018
  *
  * @param Pv_Login                 IN  VARCHAR2,
  * @param Pv_IdentificacionCliente IN  VARCHAR2,
  * @param Pv_MensajeSalida         OUT VARCHAR2
  */
  PROCEDURE P_GET_PERSONA_X_LOGIN_ID(Pv_Login                 IN VARCHAR2,
                                     Pv_IdentificacionCliente IN VARCHAR2,
                                     Pv_MensajeSalida         OUT VARCHAR2);

  /**
  * Documentacion para P_GET_SSID_FOX
  * Procedimiento que verifica el usuario que se intenta conectar
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22/06/2018
  *
  * @param Pv_UsuarioFox    IN  VARCHAR2,
  * @param Pv_PasswordFox   IN  VARCHAR2,
  * @param Pv_SsidFox       OUT VARCHAR2
  * @param Pv_MensajeSalida OUT VARCHAR2
  */
  PROCEDURE P_GET_SSID_FOX(Pv_UsuarioFox    IN VARCHAR2,
                           Pv_PasswordFox   IN VARCHAR2,
                           Pv_KeyEncript    IN VARCHAR2,
                           Pv_SsidFox       OUT VARCHAR2,
                           Pv_CodPais       OUT VARCHAR2,
                           Pv_MensajeSalida OUT VARCHAR2);

  /**
  * Documentacion para P_VALIDA_CARACTERISTICA
  * Procedimiento que valida las caracteristicas
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 22/06/2018
  *
  * @param Pv_DescrCaracteristica    IN  VARCHAR2,
  * @param Pv_MensajeSalida       OUT VARCHAR2
  */
  PROCEDURE P_VALIDA_CARACTERISTICA(Pv_DescrCaracteristica IN VARCHAR2,
                                    Pv_Valor               IN VARCHAR2,
                                    Pv_ServicioId          OUT VARCHAR2,
                                    Pv_MensajeSalida       OUT VARCHAR2);

  /**
  * Documentacion para P_VERIFICA_ESTADO_SERVICIO
  * Procedimiento que verifica el estado del servicio
  *
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 25/06/2018

  * @author Jonathan Maz閿熺单 S閿熺单chez <jmazon@telconet.ec>
  * @version 1.1 12/10/2020
  * se modifica el ingreso de parametros para validar si es Fox, Paramount o Noggin
  *
  * @author Jonathan Maz閿熺单 S閿熺单chez <jmazon@telconet.ec>
  * @version 1.2 29/10/2020
  * se modifica el codigo de error a 02 para el estado en In-Corte
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.3 06/08/2021 Se agrega la programaci閿熺单 para autorizar servicios El canal del f閿熺但bol
  *
  * @author Jonathan Maz閿熺单 S閿熺单chez <jmazon@telconet.ec>
  * @version 1.4 28/09/2021 Se agrega mejora para autorizar servicios El canal del f閿熺但bol
  *
  * @param Pn_IdSpcSuscriber  IN  NUMBER,
  * @param Pv_SubscriberId  IN  VARCHAR2,
  * @param Pv_CountryCode   IN  VARCHAR2,
  * @param Pv_CodigoUrn     IN VARCHAR2,
  * @param Pv_CodigoSalida  OUT VARCHAR2,
  * @param Pv_MensajeSalida OUT VARCHAR2,
  * @param Pv_strCodigoUrn  IN VARCHAR2, 
  * @param Pv_strSsid       IN VARCHAR2
  */
  PROCEDURE P_VERIFICA_ESTADO_SERVICIO(Pn_IdSpcSuscriber IN NUMBER,
                                       Pv_SubscriberId  IN VARCHAR2,
                                       Pv_CountryCode   IN VARCHAR2,
                                       Pv_CodigoUrn     IN VARCHAR2,
                                       Pv_CodigoSalida  OUT VARCHAR2,
                                       Pv_MensajeSalida OUT VARCHAR2,
                                       Pv_strCodigoUrn  IN VARCHAR2,
                                       Pv_strSsid       IN VARCHAR2);

  /**
   * P_GET_SERVICIOS_POR_RECHAZAR
   * Procedimiento que retorna el listado de servicios que se encuentran en estado Detenido por un tiempo superior al parametrizado
   * 
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 08-11-2018
   *
   * @param  Pv_CodigoEmpresa             IN VARCHAR2 Recibe el c閿熺禌igo de la empresa
   * @param  Pv_EstadoActualServicio      IN VARCHAR2 Recibe el estado actual del servicio
   * @param  Pn_DiasRechazo               IN NUMBER Recibe el n閿熺丹ero de d閿熺禈s m閿熺单imos de un servicio en un estado determinado
   * @param  Pn_TotalRegistros            OUT NUMBER Recibe el total de registros del listado de servicios
   * @param  Prf_Servicios                OUT SYS_REFCURSOR Cursor que retorna el listado de servicios
   * @param  Pv_StatusLiberacion          OUT VARCHAR2 Status de procedimiento
   * @param  Pv_MensajeError              OUT VARCHAR2 Mensaje de error
   *
   * Costo = 4927
   *
   * @author Jean Pierre Nazareno <jnazareno@telconet.ec>
   * @version 1.1 29-01-2020 - Se agrega variable Lv_AccionSeguimiento para nuevo filtro de clientes por anular
   *
   */
  PROCEDURE P_GET_SERVICIOS_POR_RECHAZAR(
      Pv_CodigoEmpresa IN VARCHAR2,
      Pv_EstadoActualServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pn_DiasRechazo   IN NUMBER,
      Pn_TotalRegistros OUT NUMBER,
      Prf_Servicios OUT SYS_REFCURSOR,
      Pv_Status OUT VARCHAR2,
      Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentaci閿熺单 para la funci閿熺单 F_GET_DESCRIPCION_PRODUCTO.
  * Funci閿熺单 que retorna la descripci閿熺单 de un producto 'INTERNET DEDICADO'.
  * Costo del Query C_getDescripcionProducto: 3
  *
  * @param  Fn_IdPlan                  DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE => Id del plan.
  * @return DESCRIPCION_PRODUCTO       Retorna la descripci閿熺单 del producto.
  * @author Ricardo Robles <rrobles@telconet.ec>
  * @version 1.0 11-06-2019
  */
  FUNCTION F_GET_DESCRIPCION_PRODUCTO(Fn_IdPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    RETURN VARCHAR2;

 /**
  * Documentaci閿熺单 para la funci閿熺单 F_GET_VALOR_PLAN.
  * Funci閿熺单 que retorna el valor de un plan.
  * Costo del Query C_getValorPlan: 4
  *
  * @param  Fn_IdPlan                DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE => Id del plan.
  * @return VALOR_PLAN               Retorna valor del plan
  * @author Ricardo Robles <rrobles@telconet.ec>
  * @version 1.0 11-06-2019
  */
  FUNCTION F_GET_VALOR_PLAN(Fn_IdPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    RETURN NUMBER;

 /**
  * Documentaci閿熺单 para el procedure P_SERVICIOS_MCAFEE_ERROR
  * Procedimiento que ejecuta un job para enviar notificaci閿熺单 con clientes que presentaron
  * error al cancelar suscripci閿熺单 mcafee por migraci閿熺单 de tecnolog閿熺禈
  *
  * @author Jes閿熺氮 Bozada <jbozada@telconet.ec>
  * @version 1.0 16-08-2019
  */
  PROCEDURE P_SERVICIOS_MCAFEE_ERROR;

 /**
  * Documentaci閿熺单 para el procedure P_SERVICIOS_KASPERSKY_ERROR
  * Procedimiento que ejecuta un job para enviar notificaci閿熺单 con clientes que presentaron
  * error al cancelar suscripci閿熺单 kaspersky
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 16-09-2019
  */
  PROCEDURE P_SERVICIOS_KASPERSKY_ERROR;

 /**
  * Documentaci閿熺单 para la funci閿熺单 F_GET_FORMAS_CONTACTO_BY_PUNTO.
  * Funci閿熺单 que retorna las formas de contacto de un punto.
  *
  * @param  Fn_IdPunto                DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE => Id del punto.
  * @param  Fv_TipoData               DB_COMERCIAL.ADMI_FORMA_CONTACTO.CODIGO%TYPE => c閿熺禌igo de forma contacto.
  * @return VARCHAR2                  Retorna valor cadena de caracteres con las formas de contacto.
  * @author Andr閿熺氮 Montero <amontero@telconet.ec>
  * @version 1.0 25-10-2019
  */
FUNCTION F_GET_FORMAS_CONTACTO_BY_PUNTO(
    Fn_IdPunto        IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_TipoData       IN ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  RETURN VARCHAR2;

 /**
  * Actualizaci閿熺单: Se corrige query principal agregando "OR" faltante para 
  * consulta de estado de punto pendiente.
  *
  * @author Andr閿熺氮 Montero <amontero@telconet.ec>
  * @version 1.1 18-12-2019
  *
  * Documentaci閿熺单 para la funci閿熺单 GET_FORMAS_CONTACTO_BY_PUNTO.
  * Funci閿熺单 que retorna las formas de contacto de un punto.
  *
  * @param  Pv_CodEmpresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE => C閿熺禌igo de la empresa.
  * @param  Pv_Valor                  IN  VARCHAR2                                         => Valor de la forma de contacto a consultar.
  * @param  Pv_Tipo                   IN  VARCHAR2                                         => Tipo de forma de contacto a consultar.
  * @param  Pv_MensajeRespuesta       OUT VARCHAR2                                         => Mensaje de respuesta.
  * @param  Pr_Informacion            OUT SYSREFCURSOR                                     => Resultado de los logins obtenidos seg閿熺单 par閿熺丹etros.
  * @author Andr閿熺氮 Montero <amontero@telconet.ec>
  * @version 1.0 28-10-2019
  */
PROCEDURE P_GET_PUNTOS_BY_FORMA_CONTAC(
    Pv_CodEmpresa       IN VARCHAR2,
    Pv_Valor            IN VARCHAR2,
    Pv_Tipo             IN VARCHAR2,
    Pv_MensajeRespuesta OUT VARCHAR2,
    Pr_Informacion      OUT SYS_REFCURSOR);
--
  /**
  * Documentacion para el procedimiento 'P_GET_ORDENES_TELCOS_CRM'
  *
  * Procedimiento que retorna las ordenes de servicio consultadas.
  *
  * @param  Pcl_Parametros         IN CLOB          Recibe los par閿熺丹etros necesarios para realizar la consulta
  * @param  Pv_MensajeRespuesta    OUT VARCHAR2     Parametro usado para retornar obtener el mensaje de respuesta del procedimiento
  * @param  Pr_Informacion         OUT SYSREFCURSOR Parametro usado para retornar el cursor de todos las ordenes
  *
  * @author Kevin Baque <kbaque@telconet.ec>
  * @version 1.0 21-09-2020
  */
  PROCEDURE P_GET_ORDENES_TELCOS_CRM(Pcl_Parametros         IN CLOB,
                                     Pv_MensajeRespuesta    OUT VARCHAR2,
                                     Pr_Informacion         OUT SYS_REFCURSOR);

  /**
  * Documentacion para la Funcion 'F_GET_NUM_DIAS_ESTADO'
  *
  * Funcion que retorna la cantidad de d閿熺禈s y fecha del servicio
  *
  * @param  FnIdServicio     IN NUMBER   Id del servicio
  * @param  FvEstadoServicio IN VARCHAR2 Estado del servicio
  * @param  FvRetornar       IN VARCHAR2 Parametro de lo que se desea consultar
  *
  * @return VARCHAR2   Retorna la informacion consultada
  *
  * @author Kevin Baque <kbaque@telconet.ec>
  * @version 1.0 21-09-2020
  */
  FUNCTION F_GET_NUM_DIAS_ESTADO(FnIdServicio     IN NUMBER,
                                 FvEstadoServicio IN VARCHAR2,
                                 FvRetornar       IN VARCHAR2)
    RETURN VARCHAR2;

  /**
  * Documentacion para la Funcion 'F_GET_NUM_DIAS_ESTADO'
  *
  * Funcion que retorna la cantidad de d閿熺禈s y fecha del servicio
  *
  * @param  FnIdServicio     IN NUMBER   Id del servicio
  * @param  FvEstadoServicio IN VARCHAR2 Estado del servicio
  * @param  FvPrefijo        IN VARCHAR2 Prefijo de la empresa
  * @param  FvRetornar       IN VARCHAR2 Parametro de lo que se desea consultar
  *
  * @return VARCHAR2   Retorna la informacion consultada
  *
  * @author Kevin Baque <kbaque@telconet.ec>
  * @version 1.0 21-09-2020
  */
  FUNCTION F_GET_DEPARTAMENTO_SERVICIO(FnIdServicio     IN NUMBER,
                                       FvEstadoServicio IN VARCHAR2,
                                       FvPrefijo        IN VARCHAR2,
                                       FvRetornar       IN VARCHAR2)
    RETURN VARCHAR2;

 /**
  * Documentaci閿熺单 para el procedimiento P_SERVICIO_POR_SERIE_ELEMENTO
  *
  * M閿熺但odo encargado de retornar el servicio del cual pertenece por la serie f閿熺氮ica del elemento
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   serie                         := Serie del elemento
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacci閿熺单
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacci閿熺单
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacci閿熺单
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.0 30-09-2020
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.1 21-12-2020 - Se valida la busqueda por el login del servicio
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.2 21-01-2021 - Se agrega la cliente, ciudad y la sigla al query
  */
  PROCEDURE P_SERVICIO_POR_SERIE_ELEMENTO(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR);

 /**
  * Documentaci閿熺单 para el procedimiento P_GET_SERVICIO_ACTIVAR_SERIE
  *
  * M閿熺但odo encargado de retornar los datos del servicio para activar la licencia de la serie del elemento
  *
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacci閿熺单
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacci閿熺单
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacci閿熺单
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.0 09-12-2020
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.1 21-01-2021 - Se agrega la cliente, ciudad y la sigla al query
  */
  PROCEDURE P_GET_SERVICIO_ACTIVAR_SERIE(Pv_Status  OUT VARCHAR2,
                                 Pv_Mensaje         OUT VARCHAR2,
                                 Pcl_Response       OUT SYS_REFCURSOR);

 /**
  * Documentaci閿熺单 para el procedimiento P_GET_SERVICIO_LICENCIA_RPA
  *
  * M閿熺但odo encargado de retornar los datos del servicio cancelado para la revisi閿熺单 de la licencia de la serie del elemento
  *
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacci閿熺单
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacci閿熺单
  * @param Pcl_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacci閿熺单
  *
  * @author Felix Caicedo <facaicedo@telconet.ec>
  * @version 1.0 21-01-2021
  *
  * Se agrega WITH para mejorar la consulta de los datos cuando no viene Fv_EstadoServicio, Fv_EstadoPunto, Fv_EstadoCliente 
  * y se elimina el LOOP que cuenta los datos
  * @author Jos閿燂拷 Guam閿熺单 <jaguamanp@telconet.ec>
  * @version 1.0 19-11-2022
  */
  PROCEDURE P_GET_SERVICIO_LICENCIA_RPA(Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Pcl_Response OUT SYS_REFCURSOR);

   /**
  * Documentaci閿熺单 para el procedimiento P_GET_SERVICIO_ENVIO_CORREO
  *
  * M閿熺但odo encargado de consultar y enviar correos de los datos del cliente/Pre-Cliente que realiza solicitud de Portabilidad
  *
  * @param Pv_Identificacion      IN  VARCHAR2 Ingresa la identificacion del cliente/Pre-Cliente
  * @param Pv_Destinatario        IN  VARCHAR2 Ingresa el correo del cliente/Pre-Cliente
  * @param Pv_Mensaje             OUT VARCHAR2 Retorna mensaje de exito o error del envio de correo
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.0 02-12-2022
  */
   PROCEDURE P_GET_SERVICIO_ENVIO_CORREO(Pv_Identificacion    IN VARCHAR2,
                                         Pv_Destinatario      IN VARCHAR2,
                                         Pv_Mensaje           OUT VARCHAR2); 
                                         
                                   
 
   /**
  * Documentaci閿熺单 para el procedimiento P_ENVIO_CORREO_LOPDP
  *
  * M閿熺但odo encargado de  enviar correos de los datos del cliente que realiza solicitud de Oposicion
  * Suspension de Tratamiento y Detencion Suspension de tratamiento
  *
  * @param Pv_Cliente             IN  VARCHAR2 Ingresa el nombre del cliente
  * @param Pv_Destinatario        IN  VARCHAR2 Ingresa el correo del cliente
  * @param Pv_Mensaje             OUT VARCHAR2 Retorna mensaje de exito o error del envio de correo
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.0 02-12-2022
  */   
   PROCEDURE P_ENVIO_CORREO_LOPDP( Pv_Cliente           IN VARCHAR2,
                                   Pv_Destinatario      IN VARCHAR2,
                                   Pv_Mensaje           OUT VARCHAR2);
END COMEK_CONSULTAS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.COMEK_CONSULTAS AS

  FUNCTION F_GET_SERVICIOS_NOTIF_MASIVA(Fv_DestinatariosCorreo     IN VARCHAR2,
                                        Fn_Start                   IN NUMBER,
                                        Fn_Limit                   IN NUMBER,
                                        Fv_Grupo                   IN VARCHAR2,
                                        Fv_Subgrupo                IN VARCHAR2,
                                        Fn_IdElementoNodo          IN NUMBER,
                                        Fn_IdElementoSwitch        IN NUMBER,
                                        Fv_EstadoServicio          IN VARCHAR2,
                                        Fv_EstadoPunto             IN VARCHAR2,
                                        Fv_EstadoCliente           IN VARCHAR2,
                                        Fv_ClientesVIP             IN VARCHAR2,
                                        Fv_UsrCreacionFactura      IN VARCHAR2,
                                        Fn_NumFacturasAbiertas     IN NUMBER,
                                        Fv_PuntosFacturacion       IN VARCHAR2,
                                        Fv_IdsTiposNegocio         IN VARCHAR2,
                                        Fv_IdsOficinas             IN VARCHAR2,
                                        Fn_IdFormaPago             IN NUMBER,
                                        Fv_NombreFormaPago         IN VARCHAR2,
                                        Fv_IdsBancosTarjetas       IN VARCHAR2,
                                        Fv_FechaDesdeFactura       IN VARCHAR2,
                                        Fv_FechaHastaFactura       IN VARCHAR2,
                                        Fv_SaldoPendientePago      IN VARCHAR2,
                                        Ff_ValorSaldoPendientePago IN FLOAT,
                                        Fv_IdsTiposContactos       IN VARCHAR2,
                                        Fv_VariablesNotificacion   IN VARCHAR2,
                                        Fn_TotalRegistros          OUT NUMBER)
    RETURN SYS_REFCURSOR IS
    Lv_UsrCreacion        VARCHAR2(15) := 'envio_masivo_tn';
    Lv_DescripcionCliente VARCHAR2(10) := 'Cliente';
    Lv_EstadoActivo       VARCHAR2(6) := 'Activo';
    Lv_TipoNodo           VARCHAR2(4) := 'NODO';
    Lv_TipoSwitch         VARCHAR2(6) := 'SWITCH';
    Lv_TipoRack           VARCHAR2(4) := 'RACK';
    Lv_TipoUdRack         VARCHAR2(6) := 'UDRACK';
    Lv_ParamEstados       VARCHAR2(28) := 'ESTADOS_FILTROS_ENVIO_MASIVO';
    Lv_ParamValorServ     VARCHAR2(8) := 'SERVICIO';
    Lv_ParamValorPunto    VARCHAR2(5) := 'PUNTO';
    Lv_ParamValorCliente  VARCHAR2(7) := 'CLIENTE';
    Lv_DocFacp            VARCHAR2(4) := 'FACP';
    Lv_DocFac             VARCHAR2(3) := 'FAC';
    Lv_TipoEnvio          VARCHAR2(18) := 'Correo Electronico';
    Ln_IdCursor           NUMBER;
    Ln_IdCursorCount      NUMBER;
    Ln_LimitConsulta      NUMBER;
    Ln_StartConsulta      NUMBER;
    Ln_NumExecCount       NUMBER;
    Ln_NumExecPrincipal   NUMBER;
    Lrf_ConsultaCount     SYS_REFCURSOR;
    Lrf_ConsultaPrincipal SYS_REFCURSOR;
  
    Lv_AgregarEstadoActivo  VARCHAR2(1) := '';
    Lv_CodEmpresa           VARCHAR2(2) := '10';
    Lv_SelectVarsPrincipal  VARCHAR2(4000) := '';
    Lv_SelectVarsNotif      VARCHAR2(4000) := '';
    Lcl_QueryFinal          CLOB;
    Lcl_QueryCount          CLOB;
    Lcl_QueryDestinatarios  CLOB;
    Lv_QueryPrincipal       VARCHAR2(4000);
    Lv_WithPrincipal        VARCHAR2(4000) := '';
    Lv_JoinAdic             CLOB;
    Lv_Where                CLOB;
    Lv_QueryNodos           VARCHAR2(500);
    Lv_WhereNodos           VARCHAR2(300);
    Lv_QuerySwDirecto       VARCHAR2(4000);
    Lv_QuerySwRackNodo      VARCHAR2(4000);
    Lv_QueryFactAbiertas    VARCHAR2(1000);
    Lv_WhereSw              VARCHAR2(100);
    Lv_QueryIdsSw           CLOB;
    Lv_BancosTarjetas       VARCHAR2(500) := '';
    Lv_FechaDesdeFact       VARCHAR2(100) := '';
    Lv_FechaHastaFact       VARCHAR2(100) := '';
    Lv_FechaDesdeHastaFact  VARCHAR2(200) := '';
    Lv_SelectPrincipal      VARCHAR2(1000) := '';
    Lv_SelectCountPrincipal VARCHAR2(1000) := '';
    Lv_OrderByPrincipal     VARCHAR2(100) := '';
    Lv_TipoPunto            VARCHAR2(9) := '';
    Lv_AgregarOrderBy       VARCHAR2(1) := '';
  
    Lt_ArrayParamsBind       DB_COMERCIAL.CMKG_TYPES.Lt_ArrayAsociativo;
    Lt_ArrayParamsStartLimit DB_COMERCIAL.CMKG_TYPES.Lt_ArrayAsociativo;
    Lt_ArrayParamsVarsNotif  DB_COMERCIAL.CMKG_TYPES.Lt_ArrayAsociativo;
    Lv_NombreParamBind       VARCHAR2(30);
  BEGIN
    IF Fv_DestinatariosCorreo IS NOT NULL AND Fv_DestinatariosCorreo = 'S' THEN
      Lv_SelectPrincipal := ' SELECT DISTINCT 
                              CASE
                                WHEN persona.RAZON_SOCIAL IS NOT NULL THEN
                                persona.RAZON_SOCIAL
                                ELSE
                                CONCAT(CONCAT (NVL(persona.NOMBRES, ''''),'' ''), NVL(persona.APELLIDOS, ''''))  
                              END AS NOMBRES_CLIENTE ';
    
      IF Fv_VariablesNotificacion IS NOT NULL THEN
        FOR I_VariablesNotificacion IN (SELECT trim(regexp_substr(Fv_VariablesNotificacion,
                                                                  '[^,]+',
                                                                  1,
                                                                  LEVEL)) nombreVariablesNotificacion
                                          FROM dual
                                        CONNECT BY LEVEL <=
                                                   length(Fv_VariablesNotificacion) -
                                                   length(REPLACE(Fv_VariablesNotificacion,
                                                                  ',',
                                                                  '')) + 1) LOOP
          Lt_ArrayParamsVarsNotif(I_VariablesNotificacion.nombreVariablesNotificacion) := I_VariablesNotificacion.nombreVariablesNotificacion;
        END LOOP;
      END IF;
    ELSE
      Lv_AgregarOrderBy  := 'S';
      Lv_SelectPrincipal := ' SELECT DISTINCT per.ID_PERSONA_ROL, 
                              CASE
                                WHEN persona.RAZON_SOCIAL IS NOT NULL THEN
                                persona.RAZON_SOCIAL
                                ELSE
                                CONCAT(CONCAT (NVL(persona.NOMBRES, ''''),'' ''), NVL(persona.APELLIDOS, '''')) 
                                END AS NOMBRES_CLIENTE ,
                                oficina.NOMBRE_OFICINA, tipoNegocio.NOMBRE_TIPO_NEGOCIO ';
    END IF;
    Lv_QueryPrincipal := '  FROM DB_COMERCIAL.INFO_SERVICIO servicio 
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO producto
                                ON producto.ID_PRODUCTO = servicio.PRODUCTO_ID
                                INNER JOIN DB_COMERCIAL.INFO_PUNTO punto
                                ON punto.ID_PUNTO = servicio.PUNTO_ID
                                INNER JOIN DB_COMERCIAL.INFO_PUNTO puntoFact
                                ON puntoFact.ID_PUNTO = servicio.PUNTO_FACTURACION_ID 
                                INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per
                                ON per.ID_PERSONA_ROL = punto.PERSONA_EMPRESA_ROL_ID
                                INNER JOIN DB_COMERCIAL.INFO_PERSONA persona
                                ON persona.ID_PERSONA = per.PERSONA_ID
                                INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO oficina
                                ON oficina.ID_OFICINA = per.OFICINA_ID
                                INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL empresaRol
                                ON empresaRol.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID 
                                INNER JOIN DB_GENERAL.ADMI_ROL rol
                                ON rol.ID_ROL = empresaRol.ROL_ID
                                INNER JOIN DB_GENERAL.ADMI_TIPO_ROL tipoRol
                                ON rol.TIPO_ROL_ID = tipoRol.ID_TIPO_ROL ';
  
    Lv_JoinAdic := '';
    Lv_Where    := ' WHERE empresaRol.EMPRESA_COD = :Lv_CodEmpresa  
                           AND tipoRol.DESCRIPCION_TIPO_ROL = :Lv_DescripcionCliente ';
  
    Lt_ArrayParamsBind('Lv_CodEmpresa') := Lv_CodEmpresa;
    Lt_ArrayParamsBind('Lv_DescripcionCliente') := Lv_DescripcionCliente;
  
    IF TRIM(Fv_PuntosFacturacion) IS NOT NULL AND
       Fv_PuntosFacturacion = 'S' THEN
      Lv_JoinAdic := Lv_JoinAdic ||
                     ' INNER JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL puntoAdicional
                                                  ON puntoAdicional.PUNTO_ID = punto.ID_PUNTO ';
      Lv_Where := Lv_Where ||
                  'AND puntoAdicional.ES_PADRE_FACTURACION = :Fv_PuntosFacturacion ';
      Lt_ArrayParamsBind('Fv_PuntosFacturacion') := Fv_PuntosFacturacion;
      Lv_TipoPunto := 'puntoFact';
      Lv_SelectCountPrincipal := 'SELECT COUNT(DISTINCT puntoFact.ID_PUNTO) AS TOTAL_REGISTROS ';
    ELSE
      Lv_TipoPunto            := 'punto';
      Lv_SelectCountPrincipal := 'SELECT COUNT(DISTINCT servicio.ID_SERVICIO) AS TOTAL_REGISTROS ';
      Lv_SelectPrincipal      := Lv_SelectPrincipal ||
                                 ', servicio.ID_SERVICIO, producto.DESCRIPCION_PRODUCTO, servicio.ESTADO ';
    END IF;
    Lv_OrderByPrincipal := ' ORDER BY ' || Lv_TipoPunto || '.LOGIN ASC ';
    Lv_SelectPrincipal  := Lv_SelectPrincipal || ', ' || Lv_TipoPunto ||
                           '.ID_PUNTO, ' || Lv_TipoPunto || '.LOGIN ';
  
    Lv_QueryPrincipal := Lv_QueryPrincipal ||
                         ' INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO tipoNegocio
                                                ON tipoNegocio.ID_TIPO_NEGOCIO = ' ||
                         Lv_TipoPunto || '.TIPO_NEGOCIO_ID ';
  
    IF TRIM(Fv_Grupo) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND producto.GRUPO = :Fv_Grupo ';
      Lt_ArrayParamsBind('Fv_Grupo') := Fv_Grupo;
    END IF;
  
    IF TRIM(Fv_Subgrupo) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND producto.SUBGRUPO = :Fv_Subgrupo ';
      Lt_ArrayParamsBind('Fv_Subgrupo') := Fv_Subgrupo;
    END IF;
  
    IF TRIM(Fv_EstadoServicio) IS NULL OR TRIM(Fv_EstadoPunto) IS NULL OR
       TRIM(Fv_EstadoCliente) IS NULL THEN
       -- IMPLEMETAR WITH -- jaguamanp
      Lv_WithPrincipal := Lv_WithPrincipal ||' TMP_ESTADO_PUNTO AS(SELECT APD.VALOR2,
													APD.VALOR1 ,
													APC.ESTADO,
													APD.ESTADO AS ESTADO_DET,
													APC.NOMBRE_PARAMETRO
                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                    ON APD.PARAMETRO_ID = APC.ID_PARAMETRO
                                                    ),';
      Lt_ArrayParamsBind('Lv_ParamEstados') := Lv_ParamEstados;
    END IF;
  
    IF TRIM(Fv_EstadoServicio) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND servicio.ESTADO = :Fv_EstadoServicio ';
      Lt_ArrayParamsBind('Fv_EstadoServicio') := Fv_EstadoServicio;
    ELSE
      Lv_Where := Lv_Where ||
                  'AND servicio.ESTADO IN ( SELECT TMEP.VALOR2
                                                        FROM TMP_ESTADO_PUNTO TMEP
                                                        WHERE TMEP.NOMBRE_PARAMETRO = :Lv_ParamEstados  
                                                        AND TMEP.VALOR1 = :Lv_ParamValorServ   
                                                        AND TMEP.ESTADO = :Lv_EstadoActivo  
                                                        AND TMEP.ESTADO_DET = :Lv_EstadoActivo ) ';
      Lt_ArrayParamsBind('Lv_ParamValorServ') := Lv_ParamValorServ;
      Lv_AgregarEstadoActivo := 'S';
    END IF;
  
    IF TRIM(Fv_EstadoPunto) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND ' || Lv_TipoPunto ||
                  '.ESTADO = :Fv_EstadoPunto ';
      Lt_ArrayParamsBind('Fv_EstadoPunto') := Fv_EstadoPunto;
    ELSE
      Lv_Where := Lv_Where || 'AND ' || Lv_TipoPunto ||
                  '.ESTADO IN (   SELECT TEP.VALOR2 FROM TMP_ESTADO_PUNTO TEP
                                  WHERE TEP.NOMBRE_PARAMETRO = :Lv_ParamEstados  
                                  AND TEP.VALOR1 = :Lv_ParamValorPunto 
                                  AND TEP.ESTADO = :Lv_EstadoActivo 
                                  AND TEP.ESTADO_DET = :Lv_EstadoActivo ) ';
      Lt_ArrayParamsBind('Lv_ParamValorPunto') := Lv_ParamValorPunto;
      Lv_AgregarEstadoActivo := 'S';
    END IF;
  
    IF TRIM(Fv_EstadoCliente) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND per.ESTADO = :Fv_EstadoCliente ';
      Lt_ArrayParamsBind('Fv_EstadoCliente') := Fv_EstadoCliente;
    ELSE
      Lv_Where := Lv_Where ||
                  'AND per.ESTADO IN ( SELECT TMEC.VALOR2 FROM TMP_ESTADO_PUNTO TMEC WHERE TMEC.NOMBRE_PARAMETRO = :Lv_ParamEstados  
                                                    AND TMEC.VALOR1 = :Lv_ParamValorCliente  
                                                    AND TMEC.ESTADO = :Lv_EstadoActivo  
                                                    AND TMEC.ESTADO_DET = :Lv_EstadoActivo ) ';
      Lt_ArrayParamsBind('Lv_ParamValorCliente') := Lv_ParamValorCliente;
      Lv_AgregarEstadoActivo := 'S';
    END IF;
  
    IF TRIM(Fv_IdsTiposNegocio) IS NOT NULL THEN
      Lv_Where := Lv_Where ||
                  'AND tipoNegocio.ID_TIPO_NEGOCIO IN 
                               (SELECT regexp_substr(:Fv_IdsTiposNegocio, ''[^,]+'', 1, LEVEL) id_tipo_negocio
                                FROM dual
                                CONNECT BY LEVEL <= length(:Fv_IdsTiposNegocio) - length(REPLACE(:Fv_IdsTiposNegocio, '','', '''')) + 1 ) ';
      Lt_ArrayParamsBind('Fv_IdsTiposNegocio') := Fv_IdsTiposNegocio;
    END IF;
  
    IF TRIM(Fv_IdsOficinas) IS NOT NULL THEN
      Lv_Where := Lv_Where ||
                  'AND oficina.ID_OFICINA IN 
                               (SELECT regexp_substr(:Fv_IdsOficinas, ''[^,]+'', 1, LEVEL) id_oficina
                                FROM dual
                                CONNECT BY LEVEL <= length(:Fv_IdsOficinas) - length(REPLACE(:Fv_IdsOficinas, '','', '''')) + 1 ) ';
      Lt_ArrayParamsBind('Fv_IdsOficinas') := Fv_IdsOficinas;
    END IF;
  
    IF ((TRIM(Fn_IdElementoNodo) IS NOT NULL AND Fn_IdElementoNodo > 0) OR
       (TRIM(Fn_IdElementoSwitch) IS NOT NULL AND Fn_IdElementoSwitch > 0)) THEN
      Lv_JoinAdic := Lv_JoinAdic ||
                     ' INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO servicioTecnico
                                          ON servicioTecnico.SERVICIO_ID = servicio.ID_SERVICIO ';
      Lv_WhereNodos := 'WHERE nodos.ESTADO = :Lv_EstadoActivo  
                          AND nodos.NOMBRE_TIPO_ELEMENTO = :Lv_TipoNodo ';
      Lt_ArrayParamsBind('Lv_TipoNodo') := Lv_TipoNodo;
      Lv_AgregarEstadoActivo := 'S';
      IF TRIM(Fn_IdElementoNodo) IS NOT NULL AND Fn_IdElementoNodo > 0 THEN
        Lv_WhereNodos := Lv_WhereNodos ||
                         'AND nodos.ID_ELEMENTO = :Fn_IdElementoNodo ';
        Lt_ArrayParamsBind('Fn_IdElementoNodo') := Fn_IdElementoNodo;
      END IF;
      Lv_QueryNodos := 'SELECT DISTINCT nodos.ID_ELEMENTO
                          FROM DB_INFRAESTRUCTURA.VISTA_ELEMENTOS nodos ' ||
                       Lv_WhereNodos;
    
      Lv_QuerySwDirecto := 'SELECT elemSwitch.ID_ELEMENTO 
                            FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO relacionNodoSwitch
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO elemSwitch
                            ON elemSwitch.ID_ELEMENTO = relacionNodoSwitch.ELEMENTO_ID_B
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloSwitch
                            ON modeloSwitch.ID_MODELO_ELEMENTO = elemSwitch.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO tipoSwitch
                            ON tipoSwitch.ID_TIPO_ELEMENTO = modeloSwitch.TIPO_ELEMENTO_ID
                            WHERE elemSwitch.ESTADO = :Lv_EstadoActivo 
                            AND relacionNodoSwitch.ESTADO = :Lv_EstadoActivo  
                            AND tipoSwitch.NOMBRE_TIPO_ELEMENTO = :Lv_TipoSwitch
                            AND relacionNodoSwitch.ELEMENTO_ID_A IN (' ||
                           Lv_QueryNodos || ') ';
    
      Lv_QuerySwRackNodo := 'SELECT elemSwitch.ID_ELEMENTO 
                            FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO relacionNodoRack
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO elemRack
                            ON elemRack.ID_ELEMENTO = relacionNodoRack.ELEMENTO_ID_B
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloRack
                            ON modeloRack.ID_MODELO_ELEMENTO = elemRack.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO tipoRack
                            ON tipoRack.ID_TIPO_ELEMENTO = modeloRack.TIPO_ELEMENTO_ID

                            INNER JOIN DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO relacionRackUnid
                            ON relacionRackUnid.ELEMENTO_ID_A = elemRack.ID_ELEMENTO
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO elemUnidRack
                            ON elemUnidRack.ID_ELEMENTO = relacionRackUnid.ELEMENTO_ID_B
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloUnidRack
                            ON modeloUnidRack.ID_MODELO_ELEMENTO = elemUnidRack.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO tipoUnidRack
                            ON tipoUnidRack.ID_TIPO_ELEMENTO = modeloUnidRack.TIPO_ELEMENTO_ID

                            INNER JOIN DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO relacionUnidRackSwitch
                            ON relacionUnidRackSwitch.ELEMENTO_ID_A = elemUnidRack.ID_ELEMENTO
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO elemSwitch
                            ON elemSwitch.ID_ELEMENTO = relacionUnidRackSwitch.ELEMENTO_ID_B
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloSwitch
                            ON modeloSwitch.ID_MODELO_ELEMENTO = elemSwitch.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO tipoSwitch
                            ON tipoSwitch.ID_TIPO_ELEMENTO = modeloSwitch.TIPO_ELEMENTO_ID
                            WHERE elemSwitch.ESTADO = :Lv_EstadoActivo 
                            AND relacionUnidRackSwitch.ESTADO = :Lv_EstadoActivo 
                            AND relacionRackUnid.ESTADO = :Lv_EstadoActivo 
                            AND relacionNodoRack.ESTADO = :Lv_EstadoActivo 
                            AND tipoRack.NOMBRE_TIPO_ELEMENTO = :Lv_TipoRack 
                            AND tipoUnidRack.NOMBRE_TIPO_ELEMENTO = :Lv_TipoUdRack  
                            AND tipoSwitch.NOMBRE_TIPO_ELEMENTO = :Lv_TipoSwitch  
                            AND relacionNodoRack.ELEMENTO_ID_A IN (' ||
                            Lv_QueryNodos || ') ';
    
      Lt_ArrayParamsBind('Lv_TipoRack') := Lv_TipoRack;
      Lt_ArrayParamsBind('Lv_TipoUdRack') := Lv_TipoUdRack;
      Lt_ArrayParamsBind('Lv_TipoSwitch') := Lv_TipoSwitch;
      Lv_WhereSw := '';
      IF TRIM(Fn_IdElementoSwitch) IS NOT NULL AND Fn_IdElementoSwitch > 0 THEN
        Lv_WhereSw := Lv_WhereSw ||
                      'AND elemSwitch.ID_ELEMENTO = :Fn_IdElementoSwitch ';
        Lt_ArrayParamsBind('Fn_IdElementoSwitch') := Fn_IdElementoSwitch;
      END IF;
    
      Lv_QueryIdsSw := 'SELECT DISTINCT switches.ID_ELEMENTO FROM (' ||
                       Lv_QuerySwDirecto || Lv_WhereSw || ' UNION ALL ' ||
                       Lv_QuerySwRackNodo || Lv_WhereSw || ') switches ';
      Lv_Where      := Lv_Where || 'AND servicioTecnico.ELEMENTO_ID IN ( ' ||
                       Lv_QueryIdsSw || ') ';
    END IF;
  
    IF ((TRIM(Fn_NumFacturasAbiertas) IS NOT NULL AND
       Fn_NumFacturasAbiertas > 0) OR
       TRIM(Fv_FechaDesdeFactura) IS NOT NULL OR
       TRIM(Fv_FechaHastaFactura) IS NOT NULL OR
       TRIM(Fv_UsrCreacionFactura) IS NOT NULL OR
       Lt_ArrayParamsVarsNotif.EXISTS('MES_ANIO_CONSUMO_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('FECHA_EMISION_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('NUMERO_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('VALOR_FACTURA')) THEN
      Lt_ArrayParamsBind('Lv_DocFacp') := Lv_DocFacp;
      Lt_ArrayParamsBind('Lv_DocFac') := Lv_DocFac;
    END IF;
  
    IF TRIM(Fn_NumFacturasAbiertas) IS NOT NULL AND
       Fn_NumFacturasAbiertas > 0 THEN
      Lv_QueryFactAbiertas := 'SELECT facturasAbiertas.PUNTO_ID, COUNT(facturasAbiertas.ID_DOCUMENTO) AS FACTURAS_ABIERTAS
                                FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB facturasAbiertas
                                INNER JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tipoDoc
                                ON tipoDoc.ID_TIPO_DOCUMENTO = facturasAbiertas.TIPO_DOCUMENTO_ID
                                WHERE tipoDoc.CODIGO_TIPO_DOCUMENTO IN (:Lv_DocFacp , :Lv_DocFac ) 
                                AND facturasAbiertas.ESTADO_IMPRESION_FACT = :Lv_EstadoActivo  
                                GROUP BY facturasAbiertas.PUNTO_ID 
                                HAVING COUNT(facturasAbiertas.ID_DOCUMENTO) >= :Fn_NumFacturasAbiertas ';
      Lv_JoinAdic := Lv_JoinAdic || ' INNER JOIN (' || Lv_QueryFactAbiertas ||
                     ') puntoFactAbiertas
                                                  ON puntoFactAbiertas.PUNTO_ID = puntoFact.ID_PUNTO ';
      Lt_ArrayParamsBind('Fn_NumFacturasAbiertas') := Fn_NumFacturasAbiertas;
      Lv_AgregarEstadoActivo := 'S';
    END IF;
  
    IF TRIM(Fv_FechaDesdeFactura) IS NOT NULL OR
       TRIM(Fv_FechaHastaFactura) IS NOT NULL OR
       TRIM(Fv_UsrCreacionFactura) IS NOT NULL OR
       Lt_ArrayParamsVarsNotif.EXISTS('MES_ANIO_CONSUMO_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('FECHA_EMISION_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('NUMERO_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('VALOR_FACTURA') THEN
    
      Lv_JoinAdic := Lv_JoinAdic ||
                     ' INNER JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB facturas
                                                  ON facturas.PUNTO_ID = puntoFact.ID_PUNTO 
                                                  INNER JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tipoDoc
                                                  ON tipoDoc.ID_TIPO_DOCUMENTO = facturas.TIPO_DOCUMENTO_ID  ';
    
      Lv_Where               := Lv_Where ||
                                'AND tipoDoc.CODIGO_TIPO_DOCUMENTO IN ( :Lv_DocFacp , :Lv_DocFac ) 
                               AND facturas.ESTADO_IMPRESION_FACT =  :Lv_EstadoActivo ';
      Lv_AgregarEstadoActivo := 'S';
    
      IF TRIM(Fv_UsrCreacionFactura) IS NOT NULL THEN
        Lv_Where := Lv_Where ||
                    'AND facturas.USR_CREACION =  :Fv_UsrCreacionFactura ';
        Lt_ArrayParamsBind('Fv_UsrCreacionFactura') := Fv_UsrCreacionFactura;
      END IF;
    
      IF TRIM(Fv_FechaDesdeFactura) IS NOT NULL OR
         TRIM(Fv_FechaHastaFactura) IS NOT NULL THEN
        Lv_Where := Lv_Where ||
                    'AND facturas.FE_AUTORIZACION IS NOT NULL AND ( ';
        IF TRIM(Fv_FechaDesdeFactura) IS NOT NULL THEN
          Lv_FechaDesdeFact := ' facturas.FE_EMISION >= TO_DATE( :Fv_FechaDesdeFactura , ''yyyy-mm-dd'') ';
          Lt_ArrayParamsBind('Fv_FechaDesdeFactura') := Fv_FechaDesdeFactura;
        END IF;
      
        IF TRIM(Fv_FechaHastaFactura) IS NOT NULL THEN
          Lv_FechaHastaFact := '  facturas.FE_EMISION < TO_DATE( :Fv_FechaHastaFactura , ''yyyy-mm-dd'') ';
          Lt_ArrayParamsBind('Fv_FechaHastaFactura') := Fv_FechaHastaFactura;
        END IF;
      
        IF TRIM(Lv_FechaDesdeFact) IS NOT NULL AND
           TRIM(Lv_FechaHastaFact) IS NOT NULL THEN
          Lv_FechaDesdeHastaFact := Lv_FechaDesdeFact || ' AND ' ||
                                    Lv_FechaHastaFact || ' ';
        ELSE
          Lv_FechaDesdeHastaFact := Lv_FechaDesdeFact || ' ' ||
                                    Lv_FechaHastaFact || ' ';
        END IF;
        Lv_Where := Lv_Where || Lv_FechaDesdeHastaFact || ') ';
      END IF;
    END IF;
  
    IF TRIM(Fv_SaldoPendientePago) IS NOT NULL AND
       Fv_SaldoPendientePago = 'S' OR
       Lt_ArrayParamsVarsNotif.EXISTS('SALDO_PUNTO_FACT') THEN
      Lv_JoinAdic := Lv_JoinAdic ||
                     ' INNER JOIN DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO vecrp
                                        ON vecrp.PUNTO_ID = puntoFact.ID_PUNTO ';
      IF TRIM(Ff_ValorSaldoPendientePago) IS NOT NULL AND
         Ff_ValorSaldoPendientePago > 0 THEN
        Lv_Where := Lv_Where ||
                    'AND vecrp.SALDO >= :Ff_ValorSaldoPendientePago ';
        Lt_ArrayParamsBind('Ff_ValorSaldoPendientePago') := Ff_ValorSaldoPendientePago;
      ELSE
        Lv_Where := Lv_Where ||
                    'AND vecrp.SALDO > :Ff_ValorSaldoPendientePago ';
        Lt_ArrayParamsBind('Ff_ValorSaldoPendientePago') := 0;
      END IF;
    END IF;
  
    IF ((TRIM(Fn_IdFormaPago) IS NOT NULL AND Fn_IdFormaPago > 0) OR
       TRIM(Fv_IdsBancosTarjetas) IS NOT NULL OR
       TRIM(Fv_ClientesVIP) IS NOT NULL) THEN
      Lv_JoinAdic            := Lv_JoinAdic ||
                                ' INNER JOIN DB_COMERCIAL.INFO_CONTRATO contrato
                                      ON contrato.PERSONA_EMPRESA_ROL_ID = per.ID_PERSONA_ROL ';
      Lv_Where               := Lv_Where ||
                                'AND contrato.ESTADO = :Lv_EstadoActivo ';
      Lv_AgregarEstadoActivo := 'S';
      IF TRIM(Fv_ClientesVIP) IS NOT NULL THEN
        IF TRIM(Fv_ClientesVIP) = 'S' THEN
          Lv_JoinAdic := Lv_JoinAdic ||
                         ' INNER JOIN DB_COMERCIAL.INFO_CONTRATO_DATO_ADICIONAL contratoAdicVip 
                                          ON contratoAdicVip.CONTRATO_ID = contrato.ID_CONTRATO ';
          Lv_Where := Lv_Where ||
                      'AND contratoAdicVip.ES_VIP =  :Fv_ClientesVIP ';
          Lt_ArrayParamsBind('Fv_ClientesVIP') := Fv_ClientesVIP;
        ELSE
          IF TRIM(Fv_ClientesVIP) = 'N' THEN
            Lv_JoinAdic := Lv_JoinAdic ||
                           ' LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_DATO_ADICIONAL contratoAdicVip 
                                              ON contratoAdicVip.CONTRATO_ID = contrato.ID_CONTRATO ';
            Lv_Where := Lv_Where ||
                        'AND (contratoAdicVip.ES_VIP =  :Fv_ClientesVIP  
                                          OR contratoAdicVip.ID_DATO_ADICIONAL IS NULL) ';
            Lt_ArrayParamsBind('Fv_ClientesVIP') := Fv_ClientesVIP;
          END IF;
        END IF;
      END IF;
    
      IF TRIM(Fn_IdFormaPago) IS NOT NULL AND Fn_IdFormaPago > 0 THEN
        Lv_JoinAdic := Lv_JoinAdic ||
                       ' INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO formaPago
                                          ON formaPago.ID_FORMA_PAGO = contrato.FORMA_PAGO_ID  ';
        Lv_Where := Lv_Where ||
                    'AND formaPago.ID_FORMA_PAGO = :Fn_IdFormaPago ';
        Lt_ArrayParamsBind('Fn_IdFormaPago') := Fn_IdFormaPago;
        IF TRIM(Fv_IdsBancosTarjetas) IS NOT NULL THEN
          IF (TRIM(Fv_NombreFormaPago) IS NOT NULL AND
             (TRIM(Fv_NombreFormaPago) = 'TARJETA DE CREDITO' OR
             TRIM(Fv_NombreFormaPago) = 'DEBITO BANCARIO')) THEN
            Lv_JoinAdic            := Lv_JoinAdic ||
                                      ' INNER JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO contratoFormaPago
                                              ON contratoFormaPago.CONTRATO_ID = contrato.ID_CONTRATO
                                              INNER JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA bancoTipoCuenta
                                              ON bancoTipoCuenta.ID_BANCO_TIPO_CUENTA = contratoFormaPago.BANCO_TIPO_CUENTA_ID ';
            Lv_Where               := Lv_Where ||
                                      'AND contratoFormaPago.ESTADO = :Lv_EstadoActivo ';
            Lv_AgregarEstadoActivo := 'S';
            Lv_BancosTarjetas      := 'SELECT regexp_substr(:Fv_IdsBancosTarjetas, ''[^,]+'', 1, LEVEL) id_banco_tarjeta
                                  FROM dual
                                  CONNECT BY LEVEL <= length(:Fv_IdsBancosTarjetas) - length(REPLACE(:Fv_IdsBancosTarjetas, '','', '''')) + 1 ';
            IF TRIM(Fv_NombreFormaPago) = 'DEBITO BANCARIO' THEN
              Lv_Where := Lv_Where || 'AND bancoTipoCuenta.BANCO_ID IN ( ' ||
                          Lv_BancosTarjetas || ' ) ';
              Lt_ArrayParamsBind('Fv_IdsBancosTarjetas') := Fv_IdsBancosTarjetas;
            END IF;
            IF TRIM(Fv_NombreFormaPago) = 'TARJETA DE CREDITO' THEN
              Lv_Where := Lv_Where ||
                          'AND bancoTipoCuenta.TIPO_CUENTA_ID IN ( ' ||
                          Lv_BancosTarjetas || ' ) ';
              Lt_ArrayParamsBind('Fv_IdsBancosTarjetas') := Fv_IdsBancosTarjetas;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  
    IF Fv_DestinatariosCorreo IS NOT NULL AND Fv_DestinatariosCorreo = 'S' THEN
      IF Lt_ArrayParamsVarsNotif.EXISTS('NUM_PUNTOS_AFECTADOS') THEN
        Lv_WithPrincipal := Lv_WithPrincipal ||
                            ' NUM_PUNTOS_PTO_FACT AS ( SELECT puntoFact.ID_PUNTO,
                                                                            COUNT (DISTINCT puntoAfectado.ID_PUNTO) AS NUM_PUNTOS 
                                                                            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                                                            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                                                            ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                                                            INNER JOIN DB_COMERCIAL.INFO_PUNTO puntoFact
                                                                            ON iper.ID_PERSONA_ROL = puntoFact.PERSONA_EMPRESA_ROL_ID
                                                                            INNER JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL datoPuntoFact
                                                                            ON datoPuntoFact.PUNTO_ID = puntoFact.ID_PUNTO 
                                                                            INNER JOIN DB_COMERCIAL.INFO_SERVICIO servicioAfectado 
                                                                            ON servicioAfectado.PUNTO_FACTURACION_ID = puntoFact.ID_PUNTO
                                                                            INNER JOIN DB_COMERCIAL.INFO_PUNTO puntoAfectado
                                                                            ON puntoAfectado.ID_PUNTO = servicioAfectado.PUNTO_ID
                                                                            WHERE datoPuntoFact.ES_PADRE_FACTURACION = :LvSiEsPadreFacturacion
                                                                            AND puntoAfectado.ESTADO = :Lv_EstadoActivo
                                                                            AND ier.EMPRESA_COD = :Lv_CodEmpresa
                                                                            GROUP BY puntoFact.ID_PUNTO ),';
        Lt_ArrayParamsBind('LvSiEsPadreFacturacion') := 'S';
      
        Lv_JoinAdic            := Lv_JoinAdic ||
                                  ' INNER JOIN NUM_PUNTOS_PTO_FACT numPuntosPtoFact 
                                                      ON numPuntosPtoFact.ID_PUNTO = puntoFact.ID_PUNTO  ';
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', numPuntosPtoFact.NUM_PUNTOS AS NUM_PUNTOS_AFECTADOS ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.NUM_PUNTOS_AFECTADOS ';
        Lv_AgregarEstadoActivo := 'S';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', 0 AS NUM_PUNTOS_AFECTADOS ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.NUM_PUNTOS_AFECTADOS ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('MES_ANIO_CONSUMO_FACTURA') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', COALESCE(CONCAT(facturas.MES_CONSUMO, CONCAT(''/'', facturas.ANIO_CONSUMO)),'''') 
                                                                AS MES_ANIO_CONSUMO_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.MES_ANIO_CONSUMO_FACTURA ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', '''' AS MES_ANIO_CONSUMO_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.MES_ANIO_CONSUMO_FACTURA ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('FECHA_EMISION_FACTURA') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', COALESCE(TO_CHAR(facturas.FE_EMISION,''DD/MM/YYYY''),'''') AS FECHA_EMISION_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.FECHA_EMISION_FACTURA ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', '''' AS FECHA_EMISION_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.FECHA_EMISION_FACTURA ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('NUMERO_FACTURA') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', facturas.NUMERO_FACTURA_SRI AS NUMERO_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.NUMERO_FACTURA ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', '''' AS NUMERO_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.NUMERO_FACTURA ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('VALOR_FACTURA') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', facturas.VALOR_TOTAL AS VALOR_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.VALOR_FACTURA ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', 0.00 AS VALOR_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.VALOR_FACTURA ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('SALDO_PUNTO_FACT') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', vecrp.SALDO AS SALDO_PUNTO_FACT ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.SALDO_PUNTO_FACT ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', 0.00 AS SALDO_PUNTO_FACT ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.SALDO_PUNTO_FACT ';
      END IF;
    END IF;
  
    IF TRIM(Lv_WithPrincipal) IS NOT NULL THEN
      Lv_WithPrincipal := 'WITH ' ||
                          TRIM(TRAILING ',' FROM Lv_WithPrincipal) || ' ';
    END IF;
  
    IF Lv_AgregarEstadoActivo = 'S' THEN
      Lt_ArrayParamsBind('Lv_EstadoActivo') := Lv_EstadoActivo;
      Lv_AgregarEstadoActivo := 'N';
    END IF;
  
    Lcl_QueryFinal := Lv_SelectPrincipal || Lv_SelectVarsPrincipal ||
                      Lv_QueryPrincipal || Lv_JoinAdic || Lv_Where;
  
    IF Lv_AgregarOrderBy = 'S' THEN
      Lcl_QueryFinal := Lcl_QueryFinal || Lv_OrderByPrincipal;
    END IF;
  
    IF Fv_DestinatariosCorreo IS NOT NULL AND Fv_DestinatariosCorreo = 'S' THEN
      Fn_TotalRegistros := 0;
    
      IF TRIM(Lv_WithPrincipal) IS NOT NULL THEN
        Lcl_QueryDestinatarios := Lv_WithPrincipal ||
                                  ', PUNTOS_CONSULTA AS (' ||
                                  Lcl_QueryFinal || ') ';
      ELSE
        Lcl_QueryDestinatarios := 'WITH PUNTOS_CONSULTA AS (' ||
                                  Lcl_QueryFinal || ') ';
      END IF;
      Lcl_QueryDestinatarios := Lcl_QueryDestinatarios ||
                                'SELECT DISTINCT 
                                    puntosConsulta.NOMBRES_CLIENTE,
                                    CASE
                                        WHEN persona.RAZON_SOCIAL IS NOT NULL THEN
                                        persona.RAZON_SOCIAL
                                        ELSE
                                        CONCAT(CONCAT (NVL(persona.NOMBRES, ''''),'' ''), NVL(persona.APELLIDOS, '''')) 
                                    END AS NOMBRES_CONTACTO,
                                    personaFormaContacto.VALOR AS CORREO,
                                    rol.DESCRIPCION_ROL AS TIPO_CONTACTO,
                                    puntosConsulta.LOGIN ' ||
                                Lv_SelectVarsNotif ||
                                ' FROM DB_COMERCIAL.INFO_PUNTO_CONTACTO puntoContacto
                                    INNER JOIN PUNTOS_CONSULTA puntosConsulta
                                    ON puntosConsulta.ID_PUNTO = puntoContacto.PUNTO_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PERSONA persona
                                    ON persona.ID_PERSONA = puntoContacto.CONTACTO_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL perContacto
                                    ON perContacto.PERSONA_ID = persona.ID_PERSONA
                                    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ierContacto
                                    ON ierContacto.ID_EMPRESA_ROL = perContacto.EMPRESA_ROL_ID
                                    INNER JOIN DB_GENERAL.ADMI_ROL rol
                                    ON rol.ID_ROL = ierContacto.ROL_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO personaFormaContacto 
                                    ON personaFormaContacto.PERSONA_ID = persona.ID_PERSONA
                                    INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO formaContacto 
                                    ON formaContacto.ID_FORMA_CONTACTO = personaFormaContacto.FORMA_CONTACTO_ID
                                    WHERE ierContacto.EMPRESA_COD = :Lv_CodEmpresa 
                                    AND formaContacto.DESCRIPCION_FORMA_CONTACTO = :Lv_TipoEnvio  
                                    AND puntoContacto.ESTADO = :Lv_EstadoActivo 
                                    AND personaFormaContacto.ESTADO = :Lv_EstadoActivo  
                                    AND perContacto.ESTADO = :Lv_EstadoActivo ';
      IF Lv_AgregarEstadoActivo = 'S' THEN
        Lt_ArrayParamsBind('Lv_EstadoActivo') := Lv_EstadoActivo;
        Lv_AgregarEstadoActivo := 'N';
      END IF;
      IF TRIM(Fv_IdsTiposContactos) IS NOT NULL THEN
        Lcl_QueryDestinatarios := Lcl_QueryDestinatarios ||
                                  ' AND ierContacto.ID_EMPRESA_ROL IN ' ||
                                  '(SELECT regexp_substr(:Fv_IdsTiposContactos, ''[^,]+'', 1, LEVEL) id_tipo_contacto 
                                      FROM dual
                                      CONNECT BY LEVEL <= length(:Fv_IdsTiposContactos) - length(REPLACE(:Fv_IdsTiposContactos, '','', '''')) + 1 ) ';
        Lt_ArrayParamsBind('Fv_IdsTiposContactos') := Fv_IdsTiposContactos;
      END IF;
      Lt_ArrayParamsBind('Lv_TipoEnvio') := Lv_TipoEnvio;
      Lcl_QueryFinal := Lcl_QueryDestinatarios;
    
    ELSE
      Lcl_QueryCount   := Lv_WithPrincipal || Lv_SelectCountPrincipal ||
                          Lv_QueryPrincipal || Lv_JoinAdic || Lv_Where;
      Lcl_QueryFinal   := Lv_WithPrincipal || Lcl_QueryFinal;
    END IF;
  
    Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
    DBMS_SQL.PARSE(Ln_IdCursor, Lcl_QueryFinal, DBMS_SQL.NATIVE);
    Lv_NombreParamBind := Lt_ArrayParamsBind.FIRST;
    WHILE (Lv_NombreParamBind IS NOT NULL) LOOP
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             Lv_NombreParamBind,
                             Lt_ArrayParamsBind(Lv_NombreParamBind));
      Lv_NombreParamBind := Lt_ArrayParamsBind.NEXT(Lv_NombreParamBind);
    END LOOP;
  
    Ln_NumExecPrincipal   := DBMS_SQL.EXECUTE(Ln_IdCursor);
    Lrf_ConsultaPrincipal := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
    RETURN Lrf_ConsultaPrincipal;
  
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_SERVICIOS_NOTIF_MASIVA',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               Lv_UsrCreacion),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
      RETURN NULL;
  END F_GET_SERVICIOS_NOTIF_MASIVA;

  --
  FUNCTION F_GET_INFO_DASHBOARD_SERVICIO(Fn_IdDashboardServicio IN DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ID_DASHBOARD_SERVICIO%TYPE,
                                         Fv_Buscar              IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    --CURSOR QUE RETORNA LA INFORMACION CORRESPONDIENTE AL LA INFORMACION DEL DASHBOARD DEL SERVICIO A BUSCAR
    --COSTO DEL QUERY: 3
    CURSOR C_GetInfoDashboardServicio(Cn_IdDashboardServicio DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ID_DASHBOARD_SERVICIO%TYPE) IS
    --
      SELECT IDS.ID_DASHBOARD_SERVICIO,
             IDS.ESTADO,
             IDS.SERVICIO_ID,
             IDS.PROCESADO,
             IDS.PRECIO_VENTA,
             IDS.FECHA_TRANSACCION,
             IDS.ACCION
        FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS
       WHERE IDS.ID_DASHBOARD_SERVICIO = Cn_IdDashboardServicio;
    --
    Lv_FechaResultado           VARCHAR2(50);
    Lr_GetInfoDashboardServicio C_GetInfoDashboardServicio%ROWTYPE;
    --
  BEGIN
    --
    IF C_GetInfoDashboardServicio%ISOPEN THEN
      CLOSE C_GetInfoDashboardServicio;
    END IF;
    --
    OPEN C_GetInfoDashboardServicio(Fn_IdDashboardServicio);
    --
    FETCH C_GetInfoDashboardServicio
      INTO Lr_GetInfoDashboardServicio;
    --
    CLOSE C_GetInfoDashboardServicio;
    --
    --
    IF Lr_GetInfoDashboardServicio.ID_DASHBOARD_SERVICIO > 0 THEN
      --
      IF Fv_Buscar = 'Estado' THEN
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.ESTADO, NULL);
        --
      ELSIF Fv_Buscar = 'Procesado' THEN
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.PROCESADO,
                                 NULL);
        --
      ELSIF Fv_Buscar = 'PrecioVenta' THEN
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.PRECIO_VENTA,
                                 '0');
        --
      ELSIF Fv_Buscar = 'FechaTransaccion' THEN
        --
        Lv_FechaResultado := Lr_GetInfoDashboardServicio.FECHA_TRANSACCION;
        --
      ELSIF Fv_Buscar = 'Accion' THEN
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.ACCION, NULL);
        --
      ELSE
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.ESTADO, NULL);
        --
      END IF;
      --
    END IF; --Lr_GetInfoDashboardServicio.ID_DASHBOARD_SERVICIO > 0
    --
    --
    RETURN Lv_FechaResultado;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_FechaResultado := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_TRANSACTION.P_MIGRA_INFORMACION_DASHBOARD',
                                           'Error al consultar la informacion del dashboard de servicios - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'telcos'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
      RETURN Lv_FechaResultado;
      --
  END F_GET_INFO_DASHBOARD_SERVICIO;
  --
  --
  PROCEDURE P_GET_VENDEDORES_POR_META(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                      Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                      Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                      Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                      Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                      Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                      Pv_TipoVendedor        IN VARCHAR2,
                                      Pv_TipoPersonal        IN VARCHAR2,
                                      Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                      Pr_ListadoVendedores   OUT SYS_REFCURSOR) IS
    --
    Lv_Query         CLOB;
    Lv_Select        CLOB;
    Lv_GroupBy       CLOB;
    Lv_FromWhereJoin CLOB;
    Lv_OrderBy       CLOB;
    Le_Exception EXCEPTION;
    Lv_MensajeError        VARCHAR2(4000);
    Lv_TipoOrdenes         VARCHAR2(30);
    Ln_IdCursor            NUMBER;
    Ln_NumeroRegistros     NUMBER;
    Lv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_GrupoRolesPersonal  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'GRUPO_ROLES_PERSONAL';
    Lv_ValorCategorias     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_EstadosServicios    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_ProvinciasNoAplican DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'PROVINCIAS_NO_APLICAN';
    Lv_Vendedor            DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'VENDEDOR';
    Lv_Proceso             DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo              DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta             DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden           DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    Lv_TipoVendedor        DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'TIPO_VENDEDOR';
    Lv_CaracGrupoRoles     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CARGO_GRUPO_ROLES_PERSONAL';
    Lv_Empleado            DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE := 'Empleado';
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL AND TRIM(Pv_TipoVendedor) IS NOT NULL THEN
      --
      IF TRIM(Pv_TipoVendedor) = 'PROVINCIAS_AGRUPADAS' THEN
        --
        Lv_Select  := 'SELECT TBL_METAS.NOMBRE_CANTON AS VENDEDOR, SUM(TBL_METAS.TOTAL_VENTA) AS TOTAL_VENTA ';
        Lv_GroupBy := 'GROUP BY TBL_METAS.NOMBRE_CANTON ';
        Lv_OrderBy := 'ORDER BY TBL_METAS.NOMBRE_CANTON ';
        --
      ELSIF TRIM(Pv_TipoVendedor) = 'PROVINCIAS' THEN
        --
        Lv_Select  := 'SELECT TBL_METAS.VENDEDOR, TBL_METAS.NOMBRE_CANTON AS CANTON, SUM(TBL_METAS.TOTAL_VENTA) AS TOTAL_VENTA ';
        Lv_GroupBy := 'GROUP BY TBL_METAS.NOMBRE_CANTON, TBL_METAS.VENDEDOR ';
        Lv_OrderBy := 'ORDER BY TBL_METAS.NOMBRE_CANTON, TBL_METAS.VENDEDOR ';
        --
      ELSE
        --
        Lv_Select  := 'SELECT TBL_METAS.VENDEDOR, SUM(TBL_METAS.TOTAL_VENTA) AS TOTAL_VENTA ';
        Lv_GroupBy := 'GROUP BY TBL_METAS.VENDEDOR ';
        Lv_OrderBy := 'ORDER BY TBL_METAS.VENDEDOR ';
        --
      END IF;
      --
      --
      Lv_FromWhereJoin := 'FROM ( ' ||
                          '  SELECT CONCAT(IPE.NOMBRES, CONCAT('' '', IPE.APELLIDOS)) AS VENDEDOR, ' ||
                          '         AC.NOMBRE_CANTON, ' ||
                          '         SUM( ROUND( ( ( (NVL(IDS.PRECIO_VENTA, 0) * NVL(IDS.CANTIDAD, 0)) - NVL(IDS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                          '                       ( NVL(IDS.PRECIO_INSTALACION, 0) / 12 ) ), 2 ) ) AS TOTAL_VENTA ' ||
                          '  FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS ' ||
                          '  JOIN ( ' ||
                          '         SELECT IDSER.USR_VENDEDOR, MAX(IPERS.ID_PERSONA_ROL) AS ID_PERSONA_ROL ' ||
                          '         FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDSER ' ||
                          '         JOIN DB_COMERCIAL.INFO_PERSONA IPES ' ||
                          '         ON IPES.LOGIN = IDSER.USR_VENDEDOR ' ||
                          '         JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPERS ' ||
                          '         ON IPERS.PERSONA_ID = IPES.ID_PERSONA ' ||
                          '         JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IERS ' ||
                          '         ON IERS.ID_EMPRESA_ROL = IPERS.EMPRESA_ROL_ID ' ||
                          '         JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEGS ' ||
                          '         ON IEGS.COD_EMPRESA = IERS.EMPRESA_COD ' ||
                          '         JOIN DB_GENERAL.ADMI_ROL ARS ' ||
                          '         ON ARS.ID_ROL = IERS.ROL_ID ' ||
                          '         JOIN DB_GENERAL.ADMI_TIPO_ROL ATRS ' ||
                          '         ON ATRS.ID_TIPO_ROL = ARS.TIPO_ROL_ID ' ||
                          '         WHERE IEGS.PREFIJO = :Pv_PrefijoEmpresa ' ||
                          '         AND IPERS.ESTADO = :Lv_EstadoActivo ' ||
                          '         AND ATRS.DESCRIPCION_TIPO_ROL = :Lv_Empleado ' ||
                          '         GROUP BY IDSER.USR_VENDEDOR ' ||
                          '       ) TBL_IPER ' ||
                          'ON IDS.USR_VENDEDOR = TBL_IPER.USR_VENDEDOR ' ||
                          'JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ' ||
                          'ON IPER.ID_PERSONA_ROL = TBL_IPER.ID_PERSONA_ROL ' ||
                          'JOIN DB_COMERCIAL.INFO_PERSONA IPE ' ||
                          'ON IPER.PERSONA_ID = IPE.ID_PERSONA ' ||
                          'JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ' ||
                          'ON IOG.ID_OFICINA = IPER.OFICINA_ID ' ||
                          'JOIN DB_GENERAL.ADMI_CANTON AC ' ||
                          'ON AC.ID_CANTON = IOG.CANTON_ID ' ||
                          'WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDS.PUNTO_ID, NULL) = :Pv_PrefijoEmpresa ' ||
                          'AND IDS.ES_VENTA = :Lv_EsVenta ' ||
                          'AND IDS.TIPO_ORDEN = :Lv_TipoOrden ' ||
                          'AND IDS.FECHA_TRANSACCION >= :Pd_FechaInicio ' ||
                          'AND IDS.FECHA_TRANSACCION < :Pd_FechaFin ' ||
                          'AND IDS.ESTADO NOT IN ( ' ||
                          '  SELECT APD.DESCRIPCION ' ||
                          '  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                          '  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                          '  ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                          '  WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                          '  AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                          '  AND APD.VALOR2      = :Lv_EstadosServicios ' ||
                          '  AND APD.EMPRESA_COD = ( ' ||
                          '    SELECT COD_EMPRESA ' ||
                          '    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                          '    WHERE ESTADO = :Lv_EstadoActivo ' ||
                          '    AND PREFIJO  = :Pv_PrefijoEmpresa ' ||
                          '  ) ' || ') ';
      --
      --
      IF TRIM(Pv_TipoVendedor) = 'PROVINCIAS_AGRUPADAS' THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            'AND AC.NOMBRE_CANTON NOT IN ( ' ||
                            '  SELECT APD.DESCRIPCION ' ||
                            '  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                            '  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                            '  ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                            '  WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                            '  AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                            '  AND APD.VALOR1      = :Lv_ProvinciasNoAplican ' ||
                            '  AND APD.EMPRESA_COD = ( ' ||
                            '    SELECT COD_EMPRESA ' ||
                            '    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                            '    WHERE ESTADO = :Lv_EstadoActivo ' ||
                            '    AND PREFIJO  = :Pv_PrefijoEmpresa ' ||
                            '  ) ' || ') ';
        --
      ELSE
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin || 'AND IPE.ID_PERSONA IN ( ' ||
                            '  SELECT IPER_S.PERSONA_ID ' ||
                            '  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                            '  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC_S ' ||
                            '  ON IPER_S.ID_PERSONA_ROL = IPERC_S.PERSONA_EMPRESA_ROL_ID ' ||
                            '  JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC_S ' ||
                            '  ON AC_S.ID_CARACTERISTICA = IPERC_S.CARACTERISTICA_ID ' ||
                            '  WHERE AC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND IPERC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND IPERC_S.VALOR = :Pv_TipoVendedor ' ||
                            '  AND AC_S.DESCRIPCION_CARACTERISTICA = :Lv_TipoVendedor ' || ') ' ||
                            'AND IPE.ID_PERSONA IN ( ' ||
                            '  SELECT IPER_S.PERSONA_ID ' ||
                            '  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                            '  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC_S ' ||
                            '  ON IPER_S.ID_PERSONA_ROL = IPERC_S.PERSONA_EMPRESA_ROL_ID ' ||
                            '  JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC_S ' ||
                            '  ON AC_S.ID_CARACTERISTICA = IPERC_S.CARACTERISTICA_ID ' ||
                            '  WHERE AC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND IPERC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND IPERC_S.VALOR = ( ' ||
                            '  SELECT TRIM(TO_CHAR(APD_S.ID_PARAMETRO_DET, ''999999999'')) ' ||
                            '  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD_S ' ||
                            '  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC_S ' ||
                            '  ON APD_S.PARAMETRO_ID = APC_S.ID_PARAMETRO ' ||
                            '  WHERE APC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND APD_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND APC_S.NOMBRE_PARAMETRO = :Lv_GrupoRolesPersonal ' ||
                            '  AND APD_S.DESCRIPCION = :Lv_Vendedor ' ||
                            '  ) ' ||
                            '  AND AC_S.DESCRIPCION_CARACTERISTICA = :Lv_CaracGrupoRoles ' || ') ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            'AND IDS.USR_VENDEDOR IN ( ' ||
                            ' SELECT IPE_S.LOGIN ' ||
                            ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                            ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                            ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_FromWhereJoin := Lv_FromWhereJoin ||
                              'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_FromWhereJoin := Lv_FromWhereJoin ||
                              'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin || ' ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            ' AND IDS.CATEGORIA = :Pv_Categoria ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            ' AND IDS.GRUPO = :Pv_Grupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            ' AND IDS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin || ' AND IDS.CATEGORIA IN ( ' ||
                            ' SELECT APD.DESCRIPCION ' ||
                            ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                            ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                            ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                            ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                            ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                            ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                            ' AND APC.PROCESO = :Lv_Proceso ' ||
                            ' AND APC.MODULO = :Lv_Modulo ' ||
                            ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                            ' AND APD.EMPRESA_COD = ( ' ||
                            '   SELECT COD_EMPRESA ' ||
                            '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                            '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                            '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' ||
                            ' ) ) ';
        --
      END IF;
      --
      --
      Lv_FromWhereJoin := Lv_FromWhereJoin ||
                          ' GROUP BY IPE.NOMBRES, IPE.APELLIDOS, AC.NOMBRE_CANTON) TBL_METAS ';
      --
      --
      --COSTO QUERY: 355
      Lv_Query := Lv_Select || Lv_FromWhereJoin || Lv_GroupBy || Lv_OrderBy;
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Empleado', Lv_Empleado);
      --
      --
      IF TRIM(Pv_TipoVendedor) = 'PROVINCIAS_AGRUPADAS' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ProvinciasNoAplican',
                               Lv_ProvinciasNoAplican);
        --
      ELSE
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Vendedor', Lv_Vendedor);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_TipoVendedor',
                               Pv_TipoVendedor);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_TipoVendedor',
                               Lv_TipoVendedor);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_CaracGrupoRoles',
                               Lv_CaracGrupoRoles);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_GrupoRolesPersonal',
                               Lv_GrupoRolesPersonal);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_NombreParametro',
                               Lv_NombreParametro);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      Ln_NumeroRegistros   := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_ListadoVendedores := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), ' || 'Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pr_ListadoVendedores := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_VENDEDORES_POR_META',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pr_ListadoVendedores := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_VENDEDORES_POR_META',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_VENDEDORES_POR_META;
  --
  --
  PROCEDURE P_GET_LIST_VENDEDOR_DESTACADOS(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                           Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                           Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                           Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                           Pv_TipoPersonal        IN VARCHAR2,
                                           Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                           Pn_Rownum              IN NUMBER,
                                           Pr_ListadoVendedores   OUT SYS_REFCURSOR) IS
    --
    Lv_Query CLOB;
    Le_Exception EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_TipoOrdenes      VARCHAR2(30);
    Ln_IdCursor         NUMBER;
    Ln_NumeroRegistros  NUMBER;
    Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_EstadosServicios DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso          DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta          DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden        DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_Query := 'SELECT TBL_VENDEDOR_ORDENADO.VALOR_VENTA, ' ||
                  '       TBL_VENDEDOR_ORDENADO.VENDEDOR ' || 'FROM ( ' ||
                  'SELECT TBL_VENDEDOR.VALOR_VENTA, ' ||
                  '       TBL_VENDEDOR.VENDEDOR ' || 'FROM ' ||
                  '( SELECT SUM( ROUND( ( ( ( NVL(IDS.PRECIO_VENTA, 0) * NVL(IDS.CANTIDAD, 0) ) ) - NVL(IDS.DESCUENTO_TOTALIZADO, 0) ' ||
                  '                       + ( NVL(IDS.PRECIO_INSTALACION, 0) / 12 ) ), 2 ) ) AS VALOR_VENTA, ' ||
                  '         CONCAT(IPE.NOMBRES, CONCAT('' '', IPE.APELLIDOS)) AS VENDEDOR ' ||
                  '  FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS ' ||
                  '  JOIN DB_COMERCIAL.INFO_PERSONA IPE ' ||
                  '  ON IPE.LOGIN = IDS.USR_VENDEDOR ' ||
                  '  JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                  '  ON AP.ID_PRODUCTO  = IDS.PRODUCTO_ID ' ||
                  '  WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDS.PUNTO_ID, NULL) = :Pv_PrefijoEmpresa ' ||
                  '  AND IDS.FECHA_TRANSACCION                                                    >= :Pd_FechaInicio ' ||
                  '  AND IDS.FECHA_TRANSACCION                                                     < :Pd_FechaFin ' ||
                  '  AND IDS.ES_VENTA                                                              = :Lv_EsVenta ' ||
                  '  AND IDS.TIPO_ORDEN                                                            = :Lv_TipoOrden ' ||
                  '  AND IDS.ESTADO                                                                NOT IN ( ' ||
                  '    SELECT APD.DESCRIPCION ' ||
                  '    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '    JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '    ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  '    WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                  '    AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                  '    AND APD.VALOR2      = :Lv_EstadosServicios ' ||
                  '    AND APD.EMPRESA_COD = ( ' ||
                  '      SELECT COD_EMPRESA ' ||
                  '      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  '      WHERE ESTADO = :Lv_EstadoActivo ' ||
                  '      AND PREFIJO  = :Pv_PrefijoEmpresa ) ' || '  ) ';
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Query := Lv_Query || ' ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';        
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.GRUPO = :Pv_Grupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      Lv_Query := Lv_Query || 'GROUP BY IPE.NOMBRES, IPE.APELLIDOS ' ||
                  ') TBL_VENDEDOR ' ||
                  'ORDER BY TBL_VENDEDOR.VALOR_VENTA DESC ' ||
                  ') TBL_VENDEDOR_ORDENADO ' ||
                  'WHERE ROWNUM <= NVL(:Pn_Rownum, 1) ';
      --
      --
      --COSTO QUERY: 334
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pn_Rownum', Pn_Rownum);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_NombreParametro',
                               Lv_NombreParametro);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      Ln_NumeroRegistros   := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_ListadoVendedores := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), ' || 'Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pr_ListadoVendedores := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_LIST_VENDEDOR_DESTACADOS',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pr_ListadoVendedores := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_LIST_VENDEDOR_DESTACADOS',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_LIST_VENDEDOR_DESTACADOS;
  --
  --
  PROCEDURE P_GET_LIST_PRODUCTO_DESTACADOS(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                           Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                           Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                           Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                           Pv_TipoPersonal        IN VARCHAR2,
                                           Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                           Pn_Rownum              IN NUMBER,
                                           Pr_ListadoProductos    OUT SYS_REFCURSOR) IS
    --
    Lv_Query CLOB;
    Le_Exception EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_TipoOrdenes      VARCHAR2(30);
    Ln_IdCursor         NUMBER;
    Ln_NumeroRegistros  NUMBER;
    Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_EstadosServicios DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso          DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta          DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden        DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_Query := 'SELECT TBL_PRODUCTO_ORDENADO.VALOR_VENTA, ' ||
                  '       TBL_PRODUCTO_ORDENADO.DESCRIPCION_PRODUCTO ' ||
                  'FROM (' || 'SELECT TBL_PRODUCTO.VALOR_VENTA, ' ||
                  '       TBL_PRODUCTO.DESCRIPCION_PRODUCTO ' || 'FROM ' ||
                  '( SELECT SUM( ROUND( ( ( ( NVL(IDS.PRECIO_VENTA, 0) * NVL(IDS.CANTIDAD, 0) ) - NVL(IDS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                  '                       ( NVL(IDS.PRECIO_INSTALACION, 0) / 12 ) ) , 2 ) ) AS VALOR_VENTA, ' ||
                  '         AP.DESCRIPCION_PRODUCTO ' ||
                  '  FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS ' ||
                  '  JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                  '  ON AP.ID_PRODUCTO = IDS.PRODUCTO_ID ' ||
                  '  WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDS.PUNTO_ID, NULL) = :Pv_PrefijoEmpresa ' ||
                  '  AND IDS.FECHA_TRANSACCION                                                    >= :Pd_FechaInicio ' ||
                  '  AND IDS.FECHA_TRANSACCION                                                     < :Pd_FechaFin ' ||
                  '  AND IDS.ES_VENTA                                                              = :Lv_EsVenta ' ||
                  '  AND IDS.TIPO_ORDEN                                                            = :Lv_TipoOrden ' ||
                  '  AND IDS.ESTADO                                                                NOT IN ( ' ||
                  '    SELECT APD.DESCRIPCION ' ||
                  '    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '    JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '    ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  '    WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                  '    AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                  '    AND APD.VALOR2      = :Lv_EstadosServicios ' ||
                  '    AND APD.EMPRESA_COD = ( ' ||
                  '      SELECT COD_EMPRESA ' ||
                  '      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  '      WHERE ESTADO = :Lv_EstadoActivo ' ||
                  '      AND PREFIJO  = :Pv_PrefijoEmpresa ) ' || '  ) ';
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Query := Lv_Query || ' ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.GRUPO = :Pv_Grupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      Lv_Query := Lv_Query || 'GROUP BY AP.DESCRIPCION_PRODUCTO ' ||
                  ') TBL_PRODUCTO ' ||
                  'ORDER BY TBL_PRODUCTO.VALOR_VENTA DESC ' ||
                  ') TBL_PRODUCTO_ORDENADO ' ||
                  'WHERE ROWNUM <= NVL(:Pn_Rownum, 1) ';
      --
      --COSTO QUERY: 332
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pn_Rownum', Pn_Rownum);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_NombreParametro',
                               Lv_NombreParametro);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      Ln_NumeroRegistros  := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_ListadoProductos := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), ' || 'Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pr_ListadoProductos := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_LIST_PRODUCTO_DESTACADOS',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pr_ListadoProductos := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_LIST_PRODUCTO_DESTACADOS',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_LIST_PRODUCTO_DESTACADOS;
  --
  --
  PROCEDURE P_GET_INFO_DASHBOARD(Pv_PrefijoEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                 Pd_FechaInicio          IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                 Pd_FechaFin             IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                 Pv_Categoria            IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                 Pv_Grupo                IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                 Pv_Subgrupo             IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                 Pv_TipoPersonal         IN VARCHAR2,
                                 Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                 Pr_InformacionDashboard OUT SYS_REFCURSOR) IS
    --
    Lv_Query CLOB;
    Le_Exception EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_TipoOrdenes      VARCHAR2(30);
    Ln_IdCursor         NUMBER;
    Ln_NumeroRegistros  NUMBER;
    Lv_OrderBy          VARCHAR2(1000);
    Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_EstadosServicios DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso          DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta          DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden        DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_Query := 'SELECT INITCAP(TRIM(TO_CHAR(:Pd_FechaInicio, ''day'', ''nls_date_language=spanish''))) AS DIA_SEMANA, ' ||
                  '       TRIM(TO_CHAR(:Pd_FechaInicio, ''dd'', ''nls_date_language=spanish'')) AS DIA_MES, ' ||
                  '       INITCAP(TRIM(TO_CHAR(:Pd_FechaInicio, ''month'', ''nls_date_language=spanish''))) AS MES, ' ||
                  '       TRIM(TO_CHAR(:Pd_FechaInicio, ''yyyy'', ''nls_date_language=spanish'')) AS ANIO, ' ||
                  '       TRIM(TO_CHAR(:Pd_FechaInicio, ''Q'', ''nls_date_language=spanish'')) AS TRIMESTRE, ' ||
                  '       CASE ' ||
                  '         WHEN TRIM(TO_CHAR(:Pd_FechaInicio, ''Q'', ''nls_date_language=spanish'')) = ''1'' THEN ' ||
                  '           ''ENERO - MARZO''' ||
                  '         WHEN TRIM(TO_CHAR(:Pd_FechaInicio, ''Q'', ''nls_date_language=spanish'')) = ''2'' THEN ' ||
                  '           ''ABRIL - JUNIO''' ||
                  '         WHEN TRIM(TO_CHAR(:Pd_FechaInicio, ''Q'', ''nls_date_language=spanish'')) = ''3'' THEN ' ||
                  '           ''JULIO - SEPTIEMBRE''' || '         ELSE ' ||
                  '           ''OCTUBRE - DICIEMBRE''' ||
                  '       END AS MESES_TRIMESTRE, ' || '       INITCAP(( ' ||
                  '         SELECT APD.VALOR2 ' ||
                  '         FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '         JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '         ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                  '         WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  '         AND APC.PROCESO = :Lv_Proceso ' ||
                  '         AND APC.MODULO = :Lv_Modulo ' ||
                  '         AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                  '         AND APD.DESCRIPCION = IDS.CATEGORIA ' ||
                  '         AND APD.EMPRESA_COD = ( ' ||
                  '           SELECT COD_EMPRESA ' ||
                  '           FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                  '           WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                  '           AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' ||
                  '         ) ' || '       ) ) AS MEDICION_CATEGORIA, ' ||
                  'concat(AP.LINEA_NEGOCIO, '' (''|| '||
                  'INITCAP(( ' ||
                  '         SELECT APD.VALOR2 ' ||
                  '         FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '         JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '         ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                  '         WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  '         AND APC.PROCESO = :Lv_Proceso ' ||
                  '         AND APC.MODULO = :Lv_Modulo ' ||
                  '         AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                  '         AND APD.DESCRIPCION = IDS.CATEGORIA ' ||
                  '         AND APD.EMPRESA_COD = ( ' ||
                  '           SELECT COD_EMPRESA ' ||
                  '           FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                  '           WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                  '           AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' ||
                  '         ) ' || '       ) ) ' ||
                  
                  ' ||'')'') AS DESCRIPCION_CARACTERISTICA';
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL OR TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ', concat(IDS.GRUPO, '' (''|| '||
                  'INITCAP(( ' ||
                  '         SELECT APD.VALOR2 ' ||
                  '         FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '         JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '         ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                  '         WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  '         AND APC.PROCESO = :Lv_Proceso ' ||
                  '         AND APC.MODULO = :Lv_Modulo ' ||
                  '         AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                  '         AND APD.DESCRIPCION = IDS.CATEGORIA ' ||
                  '         AND APD.EMPRESA_COD = ( ' ||
                  '           SELECT COD_EMPRESA ' ||
                  '           FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                  '           WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                  '           AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' ||
                  '         ) ' || '       ) ) ' ||                  
                  ' ||'')'') AS GRUPO';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL OR TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ', IDS.SUBGRUPO ';
        --
      END IF;
      --
      --
      Lv_Query := Lv_Query ||
                  ', COUNT(IDS.SERVICIO_ID) AS ORDENES_PARCIALES, ' ||
                  'SUM( ROUND( ( ( ( NVL(IDS.PRECIO_VENTA, 0) * NVL(IDS.CANTIDAD, 0) ) - NVL(IDS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                  '              ( NVL(IDS.PRECIO_INSTALACION, 0) / 12 ) ), 2) ) AS VENTA_PARCIALES ' ||
                  'FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS ' ||
                  'JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                  'ON AP.ID_PRODUCTO = IDS.PRODUCTO_ID ' ||
                  'WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDS.PUNTO_ID, NULL)  = :Pv_PrefijoEmpresa ' ||
                  'AND IDS.FECHA_TRANSACCION                                                    >= :Pd_FechaInicio ' ||
                  'AND IDS.FECHA_TRANSACCION                                                     < :Pd_FechaFin ' ||
                  'AND IDS.ES_VENTA                                                              = :Lv_EsVenta ' ||
                  'AND IDS.TIPO_ORDEN                                                            = :Lv_TipoOrden ' ||
                  'AND IDS.ESTADO                                                                NOT IN ( ' ||
                  '  SELECT APD.DESCRIPCION ' ||
                  '  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '  ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  '  WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                  '  AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                  '  AND APD.VALOR2      = :Lv_EstadosServicios ' ||
                  '  AND APD.EMPRESA_COD = (SELECT COD_EMPRESA ' ||
                  '  FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  '  WHERE ESTADO = :Lv_EstadoActivo ' ||
                  '  AND PREFIJO  = :Pv_PrefijoEmpresa) ) ';
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';        
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.GRUPO = :Pv_Grupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Query := Lv_Query || ' ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      Lv_Query   := Lv_Query || 'GROUP BY IDS.CATEGORIA, AP.LINEA_NEGOCIO ';
      Lv_OrderBy := 'ORDER BY IDS.CATEGORIA, AP.LINEA_NEGOCIO ';            
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL OR TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query   := Lv_Query || ', IDS.GRUPO ';
        Lv_OrderBy := Lv_OrderBy || ', IDS.GRUPO ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL OR TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query   := Lv_Query || ', IDS.SUBGRUPO ';
        Lv_OrderBy := Lv_OrderBy || ', IDS.SUBGRUPO ';
        --
      END IF;
      --
      --
      --COSTO QUERY: 335
      Lv_Query := Lv_Query || Lv_OrderBy;
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_NombreParametro',
                             Lv_NombreParametro);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_ValorCategorias',
                             Lv_ValorCategorias);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      Ln_NumeroRegistros      := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_InformacionDashboard := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), ' || 'Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pr_InformacionDashboard := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_INFO_DASHBOARD',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pr_InformacionDashboard := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_INFO_DASHBOARD',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_INFO_DASHBOARD;
  --
  --
  PROCEDURE P_GET_SUM_ORDENES_SERVICIO(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                       Pd_FechaInicio         IN VARCHAR2,
                                       Pd_FechaFin            IN VARCHAR2,
                                       Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                       Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                       Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                       Pv_TipoOrdenes         IN VARCHAR2,
                                       Pv_Frecuencia          IN VARCHAR2,
                                       Pv_TipoPersonal        IN VARCHAR2,
                                       Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                       Pv_OpcionSelect        IN VARCHAR2,
                                       Pv_EmailUsrSesion      IN VARCHAR2,
                                       Pv_CantidadOrdenes     OUT NUMBER,
                                       Pv_TotalVenta          OUT NUMBER,
                                       Pv_MensajeRespuesta    OUT VARCHAR2) IS
    --
    Ln_IdCursor        NUMBER;
    Ln_NumeroRegistros NUMBER;
    Lv_Query           CLOB;
    Lv_WhereAdicional  VARCHAR2(100);
    Le_Exception EXCEPTION;
    Lv_MensajeError       VARCHAR2(4000);
    Ln_Resultado          NUMBER;
    Lc_OrdenesVendidas    SYS_REFCURSOR;
    Lr_OrdenesVendidas    DB_COMERCIAL.CMKG_TYPES.Lr_DetalladoServicios;
    Lv_TipoOrdenes        VARCHAR2(50);
    Lv_FrecuenciaProducto NUMBER;
    Lv_CamposAdicionales  VARCHAR2(500);
    Lv_RegistroAdicional  VARCHAR2(1000);
    Lv_Select             VARCHAR2(4000) := 'SELECT ';
    Lv_From               VARCHAR2(4000) := 'FROM ';
    Lv_Where              VARCHAR2(4000) := 'WHERE ';
    Lv_GroupBy            VARCHAR2(4000) := '';
    Lv_EstadoActivo       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_EstadoPendiente    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Pendiente';
    Lv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_SolicitudDescuento DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'SOLICITUDES DE DESCUENTO';
    Lv_EstadosServicios   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso            DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo             DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta            DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden          DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    Lv_Directorio         VARCHAR2(50) := 'DIR_REPGERENCIA';
    Lv_NombreArchivo      VARCHAR2(100) := 'DetalladoVentas_' ||
                                           Pv_PrefijoEmpresa || '_' ||
                                           Pv_TipoOrdenes || '.csv';
    Lv_Delimitador        VARCHAR2(1) := ';';
    Lv_Gzip               VARCHAR2(100) := 'gzip /backup/repgerencia/' ||
                                           Lv_NombreArchivo;
    Lv_Remitente          VARCHAR2(20) := 'telcos@telconet.ec';
    Lv_Destinatario       VARCHAR2(100) := NVL(Pv_EmailUsrSesion,
                                               'notificaciones_telcos@telconet.ec') || ',';
    Lv_Asunto             VARCHAR2(300) := 'Notificacion DETALLADO DE ' ||
                                           Pv_TipoOrdenes;
    Lv_NombreArchivoZip   VARCHAR2(100) := Lv_NombreArchivo || '.gz';
    Lc_GetAliasPlantilla  DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Cuerpo             VARCHAR2(9999);
    Lfile_Archivo         utl_file.file_type;
    --
    Lv_Categoria1                DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 1';
    Lv_Categoria2                DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 2';
    Lv_Categoria3                DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 3';
    Lv_MotivoPadreRegularizacion DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_PADRE_CANCELACION%TYPE := 'Cancelacion por Regularizacion';
    --
    Ln_NumeroMesesRestantes NUMBER := 13 - TO_NUMBER(TO_CHAR(TO_DATE(Pd_FechaInicio,
                                                                     'DD-MM-YYYY'),
                                                             'MM'),
                                                     '99');
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_From := Lv_From || ' DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDAS ' ||
                 'JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                 'ON AP.ID_PRODUCTO = IDAS.PRODUCTO_ID ';
      --
      --
      Lv_Where := Lv_Where ||
                  ' DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDAS.PUNTO_ID, NULL) =  :Pv_PrefijoEmpresa ' ||
                  'AND IDAS.FECHA_TRANSACCION >= CAST(TO_DATE(:Pd_FechaInicio, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                  'AND IDAS.FECHA_TRANSACCION <  CAST(TO_DATE(:Pd_FechaFin, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                  'AND AP.EMPRESA_COD = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = :Lv_EstadoActivo ' ||
                  'AND PREFIJO  = :Pv_PrefijoEmpresa) ' ||
                  'AND IDAS.ES_VENTA = :Lv_EsVenta ' ||
                  'AND IDAS.TIPO_ORDEN = :Lv_TipoOrden ';
      --
      --
      IF Pv_OpcionSelect = 'DESCUENTO' THEN
        --
        Lv_Select := Lv_Select ||
                     ' COUNT(IDS.ID_DETALLE_SOLICITUD) AS CANTIDAD_SOLICITUDES, ' ||
                     ' SUM( ROUND( NVL(IDS.PRECIO_DESCUENTO, 0) , 2 ) ) AS TOTAL_DESCUENTOS ';
        --
        Lv_From := Lv_From ||
                   ' JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ' ||
                   ' ON IDS.SERVICIO_ID = IDAS.SERVICIO_ID ' ||
                   ' JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ' ||
                   ' ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID ';
        --
        Lv_Where := Lv_Where || ' AND ATS.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND IDS.ESTADO = :Lv_EstadoPendiente ' ||
                    ' AND ATS.DESCRIPCION_SOLICITUD IN ( ' ||
                    '   SELECT APD.DESCRIPCION ' ||
                    '   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    '   JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    '   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                    '   WHERE APD.ESTADO         = :Lv_EstadoActivo ' ||
                    '   AND APC.ESTADO           = :Lv_EstadoActivo ' ||
                    '   AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    '   AND APC.PROCESO          = :Lv_Proceso ' ||
                    '   AND APC.MODULO           = :Lv_Modulo ' ||
                    '   AND APD.VALOR1           = :Lv_SolicitudDescuento ' ||
                    '   AND APD.EMPRESA_COD      = ( ' ||
                    '     SELECT COD_EMPRESA ' ||
                    '     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                    '     WHERE ESTADO = :Lv_EstadoActivo ' ||
                    '     AND PREFIJO  = :Pv_PrefijoEmpresa ' || '   ) ' ||
                    ' ) ';
        --
      ELSIF Pv_OpcionSelect = 'DETALLE' THEN
        --
        Lv_Select := Lv_Select || ' IOG.NOMBRE_OFICINA, ' ||
                     ' IDAS.CATEGORIA, ' || ' IDAS.GRUPO, ' ||
                     ' IDAS.SUBGRUPO, ' || ' AP.DESCRIPCION_PRODUCTO, ' ||
                     ' NVL( IPE.RAZON_SOCIAL, CONCAT( IPE.NOMBRES, CONCAT('' '', IPE.APELLIDOS) ) ) AS CLIENTE, ' ||
                     ' IP.LOGIN, ' || ' IDAS.USR_VENDEDOR, ' ||
                     ' ISER.ID_SERVICIO, ' || ' IDAS.PRODUCTO_ID, ' ||
                     ' IDAS.ESTADO, ' ||
                     ' DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN( TRIM( REPLACE( REPLACE( REPLACE( TRIM( ' ||
                     ' ISER.DESCRIPCION_PRESENTA_FACTURA ), Chr(9), '' ''), Chr(10), '' ''), Chr(13), '' '') ) ) AS ' ||
                     ' DESCRIPCION_PRESENTA_FACTURA, ' ||
                     ' TO_CHAR(ISER.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_CREACION, ' ||
                     ' TO_CHAR( TO_DATE( DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_DASHBOARD_SERVICIO( MAX(IDAS.ID_DASHBOARD_SERVICIO), ' ||
                     ' ''FechaTransaccion''), ''YYYY-MM-DD HH24:MI:SS'' ), ''DD-MM-YYYY HH24:MI:SS'' ) AS FE_HISTORIAL, ' ||
                     ' NVL(IDAS.FRECUENCIA_PRODUCTO, 0) AS FRECUENCIA_PRODUCTO, ' ||
                     ' IDAS.ES_VENTA, ' || ' IDAS.MRC, ' ||
                     ' NVL(IDAS.PRECIO_VENTA, 0) AS PRECIO_VENTA, ' ||
                     ' NVL(IDAS.CANTIDAD, 0) AS CANTIDAD, ' ||
                     ' NVL(IDAS.DESCUENTO_UNITARIO, 0) AS DESCUENTO, ' ||
                     ' NVL(IDAS.PRECIO_INSTALACION, 0) AS PRECIO_INSTALACION, ' ||
                     ' ( NVL(IDAS.PRECIO_VENTA, 0) - NVL(IDAS.DESCUENTO_UNITARIO, 0) ) AS SUBTOTAL_CON_DESCUENTO, ' ||
                     ' ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) AS ' ||
                     ' SUBTOTAL, ' ||
                     ' IDAS.NRC AS VALOR_INSTALACION_MENSUAL, ' ||
                     ' ROUND( ( ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                     '          ( NVL(IDAS.PRECIO_INSTALACION, 0) ) ), 2 ) AS VALOR_TOTAL, ' ||
                     ' IDAS.ACCION, ';
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_Select := Lv_Select ||
                       ' IDAS.MOTIVO_CANCELACION, IDAS.MOTIVO_PADRE_CANCELACION ';
          --
        ELSE
          --
          Lv_Select := Lv_Select ||
                       ' '' '' AS MOTIVO_CANCELACION, '' '' AS MOTIVO_PADRE_CANCELACION ';
          --
        END IF;
        --
        --
        Lv_GroupBy := 'GROUP BY ISER.ID_SERVICIO, IOG.NOMBRE_OFICINA, IDAS.PRODUCTO_ID, IDAS.GRUPO, IDAS.SUBGRUPO, AP.DESCRIPCION_PRODUCTO, ' ||
                      ' IPE.RAZON_SOCIAL, IPE.NOMBRES, IPE.APELLIDOS, IP.LOGIN, IDAS.USR_VENDEDOR, IDAS.ESTADO, ' ||
                      ' ISER.DESCRIPCION_PRESENTA_FACTURA, ISER.FE_CREACION, IDAS.FRECUENCIA_PRODUCTO, IDAS.ES_VENTA, ' ||
                      ' IDAS.PRECIO_VENTA, IDAS.CANTIDAD, IDAS.DESCUENTO_UNITARIO, IDAS.PRECIO_INSTALACION, IDAS.CATEGORIA, IDAS.MRC, IDAS.NRC, ' ||
                      ' IDAS.DESCUENTO_TOTALIZADO, IDAS.ACCION ';
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_GroupBy := Lv_GroupBy ||
                        ', IDAS.MOTIVO_CANCELACION, IDAS.MOTIVO_PADRE_CANCELACION ';
          --
        END IF;
        --
        --
        Lv_From := Lv_From || ' JOIN DB_COMERCIAL.INFO_SERVICIO ISER ' ||
                   ' ON ISER.ID_SERVICIO = IDAS.SERVICIO_ID ' ||
                   ' JOIN DB_COMERCIAL.INFO_PUNTO IP ' ||
                   ' ON ISER.PUNTO_ID = IP.ID_PUNTO ' ||
                   ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ' ||
                   ' ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID ' ||
                   ' JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ' ||
                   ' ON IPER.OFICINA_ID = IOG.ID_OFICINA ' ||
                   ' JOIN DB_COMERCIAL.INFO_PERSONA IPE ' ||
                   ' ON IPE.ID_PERSONA = IPER.PERSONA_ID ';
        --
        --
      ELSE
        --
        Lv_Select := Lv_Select ||
                     ' COUNT(IDAS.SERVICIO_ID) AS CANTIDAD_ORDENES, ' ||
                     ' SUM( ROUND( ( ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                     '               ( NVL(IDAS.PRECIO_INSTALACION, 0)  ) ), 2 ) ) AS TOTAL_VENTA ';
        --
      END IF;
      --
      --
      Lv_Where := Lv_Where || 'AND IDAS.ESTADO ';
      --
      --
      IF TRIM(Pv_TipoOrdenes) = 'VENTAS_ACTIVAS' THEN
        --
        Lv_Where       := Lv_Where || ' NOT IN ';
        Lv_TipoOrdenes := NULL;
        --
      ELSE
        --
        Lv_Where       := Lv_Where || ' IN ';
        Lv_TipoOrdenes := Pv_TipoOrdenes;
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'ORDENES_PENDIENTES' OR
           TRIM(Pv_TipoOrdenes) = 'ORDENES_ACTIVAS' THEN
          --
          Lv_EstadosServicios := 'ESTADO_SERVICIO_ESPECIAL';
          --
        END IF;
        --
        --
      END IF;
      --
      --
      Lv_Where := Lv_Where || ' ( SELECT APD.DESCRIPCION ' ||
                  'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  'JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  'ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  'WHERE APD.ESTADO         = :Lv_EstadoActivo ' ||
                  'AND APC.ESTADO           = :Lv_EstadoActivo ' ||
                  'AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  'AND APC.PROCESO          = :Lv_Proceso ' ||
                  'AND APC.MODULO           = :Lv_Modulo ' ||
                  'AND APD.VALOR2           = :Lv_EstadosServicios ' ||
                  'AND APD.VALOR1           = NVL(:Lv_TipoOrdenes, APD.VALOR1) ' ||
                  'AND APD.EMPRESA_COD      = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = :Lv_EstadoActivo ' ||
                  'AND PREFIJO  = :Pv_PrefijoEmpresa) ) ';
      --
      --
      IF Pv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        Lv_Where := Lv_Where ||
                    ' AND IDAS.MOTIVO_PADRE_CANCELACION = :Lv_MotivoPadreRegularizacion ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Frecuencia) IS NOT NULL AND TRIM(Pv_Frecuencia) = 'UNICA' THEN
        --
        Lv_FrecuenciaProducto := 0;
        Lv_Where              := Lv_Where ||
                                 'AND ( IDAS.FRECUENCIA_PRODUCTO = :Lv_FrecuenciaProducto OR IDAS.FRECUENCIA_PRODUCTO IS NULL ) ';
        --
      ELSIF TRIM(Pv_Frecuencia) IS NOT NULL AND
            (TRIM(Pv_Frecuencia) = 'MENSUAL' OR
             TRIM(Pv_Frecuencia) = 'NO_MENSUAL') THEN
        --
        Lv_FrecuenciaProducto := 1;
        --
        --
        IF TRIM(Pv_Frecuencia) = 'MENSUAL' THEN
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO = :Lv_FrecuenciaProducto ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO > :Lv_FrecuenciaProducto ';
          --
        END IF;
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.GRUPO = :Pv_Grupo ';
        --
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Where := Lv_Where || ' ) ';
        --
      END IF;
      --
      --
      -- COSTO QUERY: 332
      Lv_Query := Lv_Select || Lv_From || Lv_Where || Lv_GroupBy;
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_NombreParametro',
                             Lv_NombreParametro);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrdenes', Lv_TipoOrdenes);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      --
      --
      IF Pv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_MotivoPadreRegularizacion',
                               Lv_MotivoPadreRegularizacion);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Frecuencia) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_FrecuenciaProducto',
                               Lv_FrecuenciaProducto);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      IF Pv_OpcionSelect = 'DESCUENTO' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_EstadoPendiente',
                               Lv_EstadoPendiente);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_SolicitudDescuento',
                               Lv_SolicitudDescuento);
        --
      END IF;
      --
      --
      IF Pv_OpcionSelect = 'DETALLE' THEN
        --
        Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DFC');
        Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
        Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,
                                               Lv_NombreArchivo,
                                               'w',
                                               3000);
        --
        Lv_CamposAdicionales := NULL;
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_CamposAdicionales := 'MOTIVO PADRE CANCELACION' ||
                                  Lv_Delimitador || 'MOTIVO CANCELACION' ||
                                  Lv_Delimitador;
          --
        END IF;
        --
        --
        utl_file.put_line(Lfile_Archivo,
                          'OFICINA' || Lv_Delimitador || 'CLIENTE' ||
                          Lv_Delimitador || 'LOGIN' || Lv_Delimitador ||
                          'VENDEDOR' || Lv_Delimitador || 'ID_PRODUCTO' ||
                          Lv_Delimitador || 'DESCRIPCION PRODUCTO' ||
                          Lv_Delimitador || 'CATEGORIA' || Lv_Delimitador ||
                          'GRUPO' || Lv_Delimitador || 'SUBGRUPO' ||
                          Lv_Delimitador || 'ID SERVICIO' || Lv_Delimitador ||
                          'DESCRIPCION SERVICIO' || Lv_Delimitador ||
                          'FRECUENCIA PRODUCTO' || Lv_Delimitador ||
                          'ES VENTA' || Lv_Delimitador || 'ESTADO' ||
                          Lv_Delimitador || 'ACCION' || Lv_Delimitador ||
                          'FECHA CREACION' || Lv_Delimitador ||
                          'FECHA ACTUALIZACION' || Lv_Delimitador ||
                          'VALOR MRC' || Lv_Delimitador || 'PRECIO VENTA' ||
                          Lv_Delimitador || 'DESCUENTO UNITARIO' ||
                          Lv_Delimitador || 'SUBTOTAL CON DESCUENTO' ||
                          Lv_Delimitador || 'CANTIDAD' || Lv_Delimitador ||
                          'SUBTOTAL' || Lv_Delimitador ||
                          'VALOR INSTALACION' || Lv_Delimitador ||
                          'V. INSTALACION (NRC)' || Lv_Delimitador ||
                          'VALOR TOTAL (SUBTOTAL + NRC)' || Lv_Delimitador ||
                          Lv_CamposAdicionales);
        --
        Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
        Lc_OrdenesVendidas := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
        --
        LOOP
          --
          FETCH Lc_OrdenesVendidas
            INTO Lr_OrdenesVendidas;
          EXIT WHEN Lc_OrdenesVendidas%NOTFOUND;
          --
          --
          Lv_RegistroAdicional := NULL;
          --
          IF TRIM(Pv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
            --
            Lv_RegistroAdicional := Lr_OrdenesVendidas.MOTIVO_PADRE_CANCELACION ||
                                    Lv_Delimitador ||
                                    Lr_OrdenesVendidas.MOTIVO_CANCELACION ||
                                    Lv_Delimitador;
            --
          END IF;
          --
          --
          utl_file.put_line(Lfile_Archivo,
                            Lr_OrdenesVendidas.NOMBRE_OFICINA ||
                            Lv_Delimitador || Lr_OrdenesVendidas.CLIENTE ||
                            Lv_Delimitador || Lr_OrdenesVendidas.LOGIN ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.USR_VENDEDOR ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.PRODUCTO_ID ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.DESCRIPCION_PRODUCTO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.CATEGORIA ||
                            Lv_Delimitador || Lr_OrdenesVendidas.GRUPO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.SUBGRUPO ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.ID_SERVICIO ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.DESCRIPCION_PRESENTA_FACTURA ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.FRECUENCIA_PRODUCTO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.ES_VENTA ||
                            Lv_Delimitador || Lr_OrdenesVendidas.ESTADO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.ACCION ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.FE_CREACION ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.FE_HISTORIAL ||
                            Lv_Delimitador || Lr_OrdenesVendidas.MRC ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.PRECIO_VENTA ||
                            Lv_Delimitador || Lr_OrdenesVendidas.DESCUENTO ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.SUBTOTAL_CON_DESCUENTO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.CANTIDAD ||
                            Lv_Delimitador || Lr_OrdenesVendidas.SUBTOTAL ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.PRECIO_INSTALACION ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.VALOR_INSTALACION_MENSUAL ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.VALOR_TOTAL ||
                            Lv_Delimitador || Lv_RegistroAdicional);
          --
        END LOOP;
        --
        UTL_FILE.fclose(Lfile_Archivo);
        --
        DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lv_Gzip));
        --
        DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lv_Remitente,
                                                  Lv_Destinatario,
                                                  Lv_Asunto,
                                                  Lv_Cuerpo,
                                                  Lv_Directorio,
                                                  Lv_NombreArchivoZip);
        --
        UTL_FILE.FREMOVE(Lv_Directorio, Lv_NombreArchivoZip);
        --
        Pv_MensajeRespuesta := 'Reporte generado y enviado al mail exitosamente';
        --
      ELSE
        --
        Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
        Lc_OrdenesVendidas := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
        --
        FETCH Lc_OrdenesVendidas
          INTO Pv_CantidadOrdenes, Pv_TotalVenta;
        --
        CLOSE Lc_OrdenesVendidas;
        --
        --
        Pv_CantidadOrdenes  := NVL(Pv_CantidadOrdenes, 0);
        Pv_TotalVenta       := NVL(Pv_TotalVenta, 0);
        Pv_MensajeRespuesta := 'Proceso OK';
        --
      END IF;
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), TipoOrdenes( ' || Pv_TipoOrdenes ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pv_CantidadOrdenes  := 0;
      Pv_TotalVenta       := 0;
      Pv_MensajeRespuesta := Lv_MensajeError;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SUM_ORDENES_SERVICIO',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pv_CantidadOrdenes  := 0;
      Pv_TotalVenta       := 0;
      Pv_MensajeRespuesta := 'Error al consultar las ordenes de servicio';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SUM_ORDENES_SERVICIO',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_SUM_ORDENES_SERVICIO;
  --
  --

    FUNCTION F_ES_PUNTO_ADICIONAL (Pn_PuntoId    IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2
    IS

        --Cursor que cuenta el total de puntos de la persona empresa rol seg閿熺单 los estados parametrizados.
        --Verifica puntos por cualquier estado
        --Costo query 10
        CURSOR C_CuentaPuntos (Cn_IdPunto      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
            SELECT
                COUNT(*) AS TOTAL, PTO_B.PERSONA_EMPRESA_ROL_ID
            FROM
                DB_COMERCIAL.INFO_PUNTO PTO_A,
                DB_COMERCIAL.INFO_PUNTO PTO_B
            WHERE
                PTO_A.ID_PUNTO = Cn_IdPunto
                AND PTO_A.PERSONA_EMPRESA_ROL_ID = PTO_B.PERSONA_EMPRESA_ROL_ID
                AND PTO_B.ID_PUNTO <> PTO_A.ID_PUNTO
            GROUP BY PTO_B.PERSONA_EMPRESA_ROL_ID;

        Ln_TotalPuntos      NUMBER := 0;
        Lv_PrefijoEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
        Lv_EmpresaCod       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
        Ln_PersonaEmpRolId  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE;
        Lv_EsPuntoAdicional VARCHAR2(1) := 'N';
    BEGIN

        Lv_PrefijoEmpresa := DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(Pn_PuntoId, NULL);
        Lv_EmpresaCod     := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP(Lv_PrefijoEmpresa);

        OPEN  C_CuentaPuntos(Cn_IdPunto      => Pn_PuntoId);
        FETCH C_CuentaPuntos INTO Ln_TotalPuntos, Ln_PersonaEmpRolId;
        CLOSE C_CuentaPuntos;

        --Si tiene m閿熺氮 de un punto ligado a la persona empresa rol, se verifica que ya sea "Cliente" para determinar que es un "PUNTO ADICIONAL"
        IF Ln_TotalPuntos > 0 AND
           DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DESCRIPCION_ROL(Pn_PersonaEmpRolId => Ln_PersonaEmpRolId) = 'Cliente' THEN
                Lv_EsPuntoAdicional := 'S';
        END IF;

        RETURN Lv_EsPuntoAdicional;
    EXCEPTION
        WHEN OTHERS THEN
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Facturas de instalaci閿熺单',
                                                        'COMEK_TRANSACTION.F_ES_PUNTO_ADICIONAL',
                                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                        ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RETURN 'N';
    END F_ES_PUNTO_ADICIONAL;

    FUNCTION F_APLICA_FACT_INST_ORIGEN_PTO (Pv_EmpresaCod IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                            Pn_PuntoId    IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2
    IS
        CURSOR C_GetEsOrigenFacturable (Cv_EmpresaCod        DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Cn_PuntoId           DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                        Cv_EstadoActivo      VARCHAR2 DEFAULT 'Activo',
                                        Cv_NombreParametro   VARCHAR2 DEFAULT 'COMBO_TIPO_ORIGEN_TECNOLOGIA_PUNTO',
                                        Cv_DescripcionCaract VARCHAR2 DEFAULT 'TIPO_ORIGEN_TECNOLOGIA')
        IS
            SELECT VALOR3
              FROM DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC,
                   DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                   DB_COMERCIAL.ADMI_CARACTERISTICA AC2,
                   DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                   DB_GENERAL.ADMI_PARAMETRO_DET DET
             WHERE IPC.PUNTO_ID = Cn_PuntoId
               AND IPC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
               AND IPC.ESTADO = Cv_EstadoActivo
               AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
               AND AC.ESTADO = Cv_EstadoActivo
               AND TO_CHAR(IPC.VALOR) = TO_CHAR(AC2.ID_CARACTERISTICA)
               AND AC2.DESCRIPCION_CARACTERISTICA = TO_CHAR(DET.VALOR2)
               AND DET.ESTADO = Cv_EstadoActivo
               AND DET.EMPRESA_COD = Cv_EmpresaCod
               AND DET.PARAMETRO_ID = CAB.ID_PARAMETRO
               AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
               AND CAB.ESTADO = Cv_EstadoActivo;

        Lv_EsFacturable VARCHAR2(1);
    BEGIN
        Lv_EsFacturable := DB_GENERAL.GNRLPCK_UTIL.F_EMPRESA_APLICA_PROCESO('TIPO_ORIGEN_TECNOLOGIA_PUNTO', Pv_EmpresaCod);
        IF Lv_EsFacturable = 'N' THEN
            RETURN Lv_EsFacturable;
        END IF;

        Lv_EsFacturable := NULL;
        OPEN  C_GetEsOrigenFacturable (Cv_EmpresaCod => Pv_EmpresaCod,
                                       Cn_PuntoId    => Pn_PuntoId);
        FETCH C_GetEsOrigenFacturable INTO Lv_EsFacturable;
        CLOSE C_GetEsOrigenFacturable;

        Lv_EsFacturable := NVL (Lv_EsFacturable, 'S');
        RETURN Lv_EsFacturable;
    EXCEPTION
        WHEN OTHERS THEN
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Facturas de instalaci閿熺单',
                                                        'COMEK_TRANSACTION.F_APLICA_FACT_INST_ORIGEN_PTO',
                                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                        ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RETURN 'S';
    END F_APLICA_FACT_INST_ORIGEN_PTO;

    FUNCTION F_GET_DESCRIPCION_ROL (Pn_PersonaEmpRolId DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE IS
        CURSOR C_GetDescripcionRol (Cn_PersonaEmpRolId DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
            SELECT AR.DESCRIPCION_ROL
              FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
              JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
              JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
             WHERE IPER.ID_PERSONA_ROL = Cn_PersonaEmpRolId;
        Lv_DescripcionRol DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE := NULL;
    BEGIN
        OPEN  C_GetDescripcionRol(Cn_PersonaEmpRolId => Pn_PersonaEmpRolId);
        FETCH C_GetDescripcionRol INTO Lv_DescripcionRol;
        CLOSE C_GetDescripcionRol;

        RETURN Lv_DescripcionRol;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END F_GET_DESCRIPCION_ROL;

    FUNCTION F_GET_INFO_SOL_INSTALACION (Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                         Pv_CaractContrato       IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                         Pv_NombreMotivo         IN  DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
                                         Pv_UltimaMilla          IN  DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE DEFAULT NULL)
    RETURN DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion
    IS
       --Costo: 4
       CURSOR C_GetValorInstalacion (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                      Cv_EstadoActivo    VARCHAR2,
                                      Cv_UltimaMilla     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                      Cv_FormaPago       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                      Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE) 
        IS
        SELECT TO_NUMBER(apd.VALOR5)
        FROM DB_GENERAL.ADMI_PARAMETRO_DET apd
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB apc
        ON apd.PARAMETRO_ID = apc.ID_PARAMETRO
        WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND apc.ESTADO = Cv_EstadoActivo
        AND apd.ESTADO = Cv_EstadoActivo
        AND apd.VALOR1 = Cv_UltimaMilla
        AND apd.VALOR2 = Cv_FormaPago
        AND APD.EMPRESA_COD = Cv_EmpresaCod;

        CURSOR C_GetDiasVigencia(Cv_EstadoActivo             DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE, 
                                 Cv_ParametroVigenciaFactura DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_TipoSolicitud            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                 Cv_EmpresaCod               DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
        IS
          SELECT VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_DET
          WHERE ESTADO     = Cv_EstadoActivo
          AND PARAMETRO_ID = ( SELECT ID_PARAMETRO
                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                                WHERE ESTADO           = Cv_EstadoActivo
                                  AND NOMBRE_PARAMETRO = Cv_ParametroVigenciaFactura)
          AND VALOR2      = Cv_TipoSolicitud
          AND EMPRESA_COD = Cv_EmpresaCod;

        CURSOR C_GetCaracteristica(Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                   Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE )
        IS
          SELECT ID_CARACTERISTICA
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA
          WHERE ESTADO                   = Cv_EstadoActivo
          AND DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract;

        CURSOR C_GetSolicitud (Cv_DescripcionSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                               Cv_EstadoActivo         DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ESTADO%TYPE)
        IS
            SELECT ID_TIPO_SOLICITUD
              FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
             WHERE DESCRIPCION_SOLICITUD = Cv_DescripcionSolicitud
               AND ESTADO = Cv_EstadoActivo;

        CURSOR C_GetMotivo (Cv_NombreMotivo DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
                            Cv_EstadoActivo DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE)
        IS
            SELECT ID_MOTIVO
              FROM DB_GENERAL.ADMI_MOTIVO
             WHERE NOMBRE_MOTIVO = Cv_NombreMotivo
               AND ESTADO = Cv_EstadoActivo;
       
        Lv_ParamVigenciaFactura DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DIAS_VIGENCIA_FACTURA';
        Lv_CaracFechaVigencia   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FECHA_VIGENCIA';
        Lv_EstadoActivo         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
        Ln_ValorInstalacion     NUMBER := 0;
        Ln_NumeroDiasVigencia   NUMBER := 0;
        Ln_CaractIdContratoTipo NUMBER := 0;
        Ln_FechaVigenciaCarac   NUMBER := 0;
        Ln_IdTipoSolicitud      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE;
        Ln_IdMotivo             DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE;
        Lv_FechaVigenciaFact    VARCHAR2(25) := '';
        Lr_SolicitudInstalacion DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion := NULL;
        Le_Exception            EXCEPTION;
    BEGIN

        IF Pv_EmpresaCod IS NULL OR Pv_DescripcionSolicitud IS NULL OR Pv_CaractContrato IS NULL OR Pv_NombreMotivo IS NULL THEN
            RAISE Le_Exception;
        END IF;       
        --Se obtiene el valor base a cobrar de instalaci閿熺单 por FO, CO y forma de pago Efectivo
        OPEN  C_GetValorInstalacion(Cv_NombreParametro => 'PORCENTAJE_DESCUENTO_INSTALACION',
                                    Cv_EstadoActivo    => 'Activo',
                                    Cv_UltimaMilla     => Pv_UltimaMilla,
                                    Cv_FormaPago       => 'EFECTIVO',
                                    Cv_EmpresaCod      => Pv_EmpresaCod);
        FETCH C_GetValorInstalacion INTO Ln_ValorInstalacion;
        CLOSE C_GetValorInstalacion;
        IF Ln_ValorInstalacion IS NULL THEN
            RAISE Le_Exception;
        END IF;
        --
        --Se obtiene el n閿熺丹ero de d閿熺禈s de vigencia para el c閿熺担culo.
        IF C_GetDiasVigencia%ISOPEN THEN
            CLOSE C_GetDiasVigencia;
        END IF;
        OPEN  C_GetDiasVigencia( Lv_EstadoActivo, Lv_ParamVigenciaFactura, Pv_DescripcionSolicitud,Pv_EmpresaCod);
        FETCH C_GetDiasVigencia INTO Ln_NumeroDiasVigencia;
        CLOSE C_GetDiasVigencia;
        --Se calcula el n閿熺丹ero de d閿熺禈s de vigencia.
        Lv_FechaVigenciaFact := TO_CHAR((SYSDATE + NVL(Ln_NumeroDiasVigencia, 0)), 'DD-MM-YYYY');

        IF Lv_FechaVigenciaFact IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene la caracter閿熺氮tica dependiendo del tipo de contrato
        IF C_GetCaracteristica%ISOPEN THEN
            CLOSE C_GetCaracteristica;
        END IF;
        OPEN  C_GetCaracteristica( Lv_EstadoActivo, Pv_CaractContrato );
        FETCH C_GetCaracteristica INTO Ln_CaractIdContratoTipo;
        CLOSE C_GetCaracteristica;

        IF Ln_CaractIdContratoTipo IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene la caracter閿熺氮tica de la fecha de vigencia.
        OPEN C_GetCaracteristica( Lv_EstadoActivo, Lv_CaracFechaVigencia );
        FETCH C_GetCaracteristica INTO Ln_FechaVigenciaCarac;
        CLOSE C_GetCaracteristica;

        IF Ln_FechaVigenciaCarac IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene la solicitud
        IF C_GetSolicitud%ISOPEN THEN
            CLOSE C_GetSolicitud;
        END IF;
        OPEN  C_GetSolicitud (Pv_DescripcionSolicitud, Lv_EstadoActivo);
        FETCH C_GetSolicitud INTO Ln_IdTipoSolicitud;
        CLOSE C_GetSolicitud;

        IF Ln_IdTipoSolicitud IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene el motivo.
        IF C_GetMotivo%ISOPEN THEN
            CLOSE C_GetMotivo;
        END IF;
        OPEN  C_GetMotivo (Pv_NombreMotivo, Lv_EstadoActivo);
        FETCH C_GetMotivo INTO Ln_IdMotivo;
        CLOSE C_GetMotivo;

        IF Ln_IdMotivo IS NULL THEN
            RAISE Le_Exception;
        END IF;

        Lr_SolicitudInstalacion.ID_TIPO_SOLICITUD         := Ln_IdTipoSolicitud;
        Lr_SolicitudInstalacion.DESCRIPCION_SOLICITUD     := Pv_DescripcionSolicitud;
        Lr_SolicitudInstalacion.DESC_CARACT_CONTRATO      := Pv_CaractContrato;
        Lr_SolicitudInstalacion.ID_CARACT_TIPO_CONTRATO   := Ln_CaractIdContratoTipo;
        Lr_SolicitudInstalacion.ID_CARACT_FE_VIGENCIA     := Ln_FechaVigenciaCarac;
        Lr_SolicitudInstalacion.MOTIVO_ID                 := Ln_IdMotivo;
        Lr_SolicitudInstalacion.COD_EMPRESA               := Pv_EmpresaCod;
        Lr_SolicitudInstalacion.FECHA_VIGENCIA_FACT       := Lv_FechaVigenciaFact;
        Lr_SolicitudInstalacion.VALOR_INSTALACION         := Ln_ValorInstalacion;

        RETURN Lr_SolicitudInstalacion;
    EXCEPTION
        WHEN Le_Exception THEN
            RETURN NULL;
        WHEN OTHERS THEN
            RETURN NULL;
    END F_GET_INFO_SOL_INSTALACION;

  PROCEDURE P_GET_AGRU_ORDENES(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                       Pd_FechaInicio         IN VARCHAR2,
                                       Pd_FechaFin            IN VARCHAR2,
                                       Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                       Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                       Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                       Pv_TipoOrdenes         IN VARCHAR2,
                                       Pv_Frecuencia          IN VARCHAR2,
                                       Pv_TipoPersonal        IN VARCHAR2,
                                       Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                       Pv_OpcionSelect        IN VARCHAR2,
                                       Pv_MensajeRespuesta    OUT VARCHAR2,
                                       Pr_Informacion         OUT SYS_REFCURSOR) IS
    --
    Ln_IdCursor        NUMBER;
    Ln_NumeroRegistros NUMBER;
    Lv_Query           CLOB;
    Lv_WhereAdicional  VARCHAR2(100);
    Le_Exception EXCEPTION;
    Lv_MensajeError       VARCHAR2(4000);
    Ln_Resultado          NUMBER;
    Lc_OrdenesVendidas    SYS_REFCURSOR;
    Lr_OrdenesVendidas    DB_COMERCIAL.CMKG_TYPES.Lr_DetalladoServicios;
    Lv_TipoOrdenes        VARCHAR2(50);
    Lv_FrecuenciaProducto NUMBER;
    Lv_CamposAdicionales  VARCHAR2(500);
    Lv_RegistroAdicional  VARCHAR2(1000);
    Lv_Select             VARCHAR2(4000) := 'SELECT ';
    Lv_From               VARCHAR2(4000) := 'FROM ';
    Lv_Where              VARCHAR2(4000) := 'WHERE ';
    Lv_GroupBy            VARCHAR2(4000) := '';
    Lv_EstadoActivo       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_EstadoPendiente    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Pendiente';
    Lv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_SolicitudDescuento DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'SOLICITUDES DE DESCUENTO';
    Lv_EstadosServicios   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso            DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo             DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta            DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden          DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    --
    Lv_MotivoPadreRegularizacion DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_PADRE_CANCELACION%TYPE := 'Cancelacion por Regularizacion';
    --
    Ln_NumeroMesesRestantes NUMBER := 13 - TO_NUMBER(TO_CHAR(TO_DATE(Pd_FechaInicio,
                                                                     'DD-MM-YYYY'),
                                                             'MM'),
                                                     '99');
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_From := Lv_From || ' DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDAS ' ||
                 'JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                 'ON AP.ID_PRODUCTO = IDAS.PRODUCTO_ID ';
      --
      --
      Lv_Where := Lv_Where ||
                  ' DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDAS.PUNTO_ID, NULL) =  :Pv_PrefijoEmpresa ' ||
                  'AND IDAS.FECHA_TRANSACCION >= CAST(TO_DATE(:Pd_FechaInicio, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                  'AND IDAS.FECHA_TRANSACCION <  CAST(TO_DATE(:Pd_FechaFin, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                  'AND AP.EMPRESA_COD = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = :Lv_EstadoActivo ' ||
                  'AND PREFIJO  = :Pv_PrefijoEmpresa) ' ||
                  'AND IDAS.ES_VENTA = :Lv_EsVenta ' ||
                  'AND IDAS.TIPO_ORDEN = :Lv_TipoOrden ';
      --
      --
      IF Pv_OpcionSelect = 'DESCUENTO' THEN
        --
        Lv_Select := Lv_Select ||
                     ' COUNT(IDS.ID_DETALLE_SOLICITUD) AS CANTIDAD_SOLICITUDES, ' ||
                     ' SUM( ROUND( NVL(IDS.PRECIO_DESCUENTO, 0) , 2 ) ) AS TOTAL_DESCUENTOS, '||
                     ' IDAS.USR_VENDEDOR ';
        --
        Lv_From := Lv_From ||
                   ' JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ' ||
                   ' ON IDS.SERVICIO_ID = IDAS.SERVICIO_ID ' ||
                   ' JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ' ||
                   ' ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID ';
        --
        Lv_Where := Lv_Where || ' AND ATS.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND IDS.ESTADO = :Lv_EstadoPendiente ' ||
                    ' AND ATS.DESCRIPCION_SOLICITUD IN ( ' ||
                    '   SELECT APD.DESCRIPCION ' ||
                    '   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    '   JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    '   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                    '   WHERE APD.ESTADO         = :Lv_EstadoActivo ' ||
                    '   AND APC.ESTADO           = :Lv_EstadoActivo ' ||
                    '   AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    '   AND APC.PROCESO          = :Lv_Proceso ' ||
                    '   AND APC.MODULO           = :Lv_Modulo ' ||
                    '   AND APD.VALOR1           = :Lv_SolicitudDescuento ' ||
                    '   AND APD.EMPRESA_COD      = ( ' ||
                    '     SELECT COD_EMPRESA ' ||
                    '     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                    '     WHERE ESTADO = :Lv_EstadoActivo ' ||
                    '     AND PREFIJO  = :Pv_PrefijoEmpresa ' || '   ) ' ||
                    ' ) ';
        Lv_GroupBy :=Lv_GroupBy || ' GROUP BY IDAS.USR_VENDEDOR ';
        --
      ELSE
        --
        Lv_Select := Lv_Select ||
                     ' COUNT(IDAS.SERVICIO_ID) AS CANTIDAD_ORDENES, ' ||
                     ' SUM( ROUND( ( ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                     '               ( NVL(IDAS.PRECIO_INSTALACION, 0) / 12 ) ), 2 ) ) AS TOTAL_VENTA , '||
                     ' IDAS.USR_VENDEDOR ';
        Lv_GroupBy :=Lv_GroupBy || ' GROUP BY IDAS.USR_VENDEDOR ';
        --
      END IF;
      --
      --
      Lv_Where := Lv_Where || 'AND IDAS.ESTADO ';
      --
      --
      IF TRIM(Pv_TipoOrdenes) = 'VENTAS_ACTIVAS' THEN
        --
        Lv_Where       := Lv_Where || ' NOT IN ';
        Lv_TipoOrdenes := NULL;
        --
      ELSE
        --
        Lv_Where       := Lv_Where || ' IN ';
        Lv_TipoOrdenes := Pv_TipoOrdenes;
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'ORDENES_PENDIENTES' OR
           TRIM(Pv_TipoOrdenes) = 'ORDENES_ACTIVAS' THEN
          --
          Lv_EstadosServicios := 'ESTADO_SERVICIO_ESPECIAL';
          --
        END IF;
        --
        --
      END IF;
      --
      --
      Lv_Where := Lv_Where || ' ( SELECT APD.DESCRIPCION ' ||
                  'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  'JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  'ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  'WHERE APD.ESTADO         = :Lv_EstadoActivo ' ||
                  'AND APC.ESTADO           = :Lv_EstadoActivo ' ||
                  'AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  'AND APC.PROCESO          = :Lv_Proceso ' ||
                  'AND APC.MODULO           = :Lv_Modulo ' ||
                  'AND APD.VALOR2           = :Lv_EstadosServicios ' ||
                  'AND APD.VALOR1           = NVL(:Lv_TipoOrdenes, APD.VALOR1) ' ||
                  'AND APD.EMPRESA_COD      = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = :Lv_EstadoActivo ' ||
                  'AND PREFIJO  = :Pv_PrefijoEmpresa) ) ';
      --
      --
      IF Pv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        Lv_Where := Lv_Where ||
                    ' AND IDAS.MOTIVO_PADRE_CANCELACION = :Lv_MotivoPadreRegularizacion ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Frecuencia) IS NOT NULL AND TRIM(Pv_Frecuencia) = 'UNICA' THEN
        --
        Lv_FrecuenciaProducto := 0;
        Lv_Where              := Lv_Where ||
                                 'AND ( IDAS.FRECUENCIA_PRODUCTO = :Lv_FrecuenciaProducto OR IDAS.FRECUENCIA_PRODUCTO IS NULL ) ';
        --
      ELSIF TRIM(Pv_Frecuencia) IS NOT NULL AND
            (TRIM(Pv_Frecuencia) = 'MENSUAL' OR
             TRIM(Pv_Frecuencia) = 'NO_MENSUAL') THEN
        --
        Lv_FrecuenciaProducto := 1;
        --
        --
        IF TRIM(Pv_Frecuencia) = 'MENSUAL' THEN
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO = :Lv_FrecuenciaProducto ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO > :Lv_FrecuenciaProducto ';
          --
        END IF;
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.GRUPO = :Pv_Grupo ';
        --
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Where := Lv_Where || ' ) ';
        --
      END IF;
      --
      --
      -- COSTO QUERY: 332      
      Lv_Query := Lv_Select || Lv_From || Lv_Where || Lv_GroupBy;
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_NombreParametro',
                             Lv_NombreParametro);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrdenes', Lv_TipoOrdenes);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      --
      --
      IF Pv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_MotivoPadreRegularizacion',
                               Lv_MotivoPadreRegularizacion);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Frecuencia) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_FrecuenciaProducto',
                               Lv_FrecuenciaProducto);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      IF Pv_OpcionSelect = 'DESCUENTO' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_EstadoPendiente',
                               Lv_EstadoPendiente);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_SolicitudDescuento',
                               Lv_SolicitudDescuento);
        --
      END IF;
      --          
      Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_Informacion := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);      
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), TipoOrdenes( ' || Pv_TipoOrdenes ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pv_MensajeRespuesta := Lv_MensajeError;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SUM_ORDENES_SERVICIO',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pv_MensajeRespuesta := 'Error al consultar las ordenes de servicio';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SUM_ORDENES_SERVICIO',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_AGRU_ORDENES;  
  --
  --
  /**
  * Documentacion para la funcion COMEF_GET_ADMI_CARACTERISTICA
  * la funcion COMEF_GET_ADMI_CARACTERISTICA obtiene un registro de la tabla ADMI_CARACTERISTICA
  *
  * @param  Fv_DescripcionCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE    Recibe la descripcion de la caracteristica
  * @return ADMI_CARACTERISTICA%ROWTYPE  Retorna el registro ADMI_CARACTERISTICA
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 17-09-2015
  */
  FUNCTION COMEF_GET_ADMI_CARACTERISTICA(Fv_DescripcionCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    RETURN ADMI_CARACTERISTICA%ROWTYPE IS
    --
    CURSOR C_GetCaracteristica(Cv_DescripcionCaracteristica ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    --
    IS
    --
      SELECT *
        FROM ADMI_CARACTERISTICA
       WHERE ESTADO = 'Activo'
         AND DESCRIPCION_CARACTERISTICA =
             NVL(Cv_DescripcionCaracteristica, DESCRIPCION_CARACTERISTICA);
    --
    Lc_GetCaracteristica C_GetCaracteristica%ROWTYPE;
    --
  BEGIN
    --
    IF C_GetCaracteristica%ISOPEN THEN
      --
      CLOSE C_GetCaracteristica;
      --
    END IF;
    --
    OPEN C_GetCaracteristica(Fv_DescripcionCaracteristica);
    --
    FETCH C_GetCaracteristica
      INTO Lc_GetCaracteristica;
    --
    CLOSE C_GetCaracteristica;
    --
    RETURN Lc_GetCaracteristica;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('COMEF_GET_ADMI_CARACTERISTICA',
                                                  'COMEK_CONSULTAS.COMEF_GET_ADMI_CARACTERISTICA',
                                                  SQLERRM);
      --
  END COMEF_GET_ADMI_CARACTERISTICA;
  --
  --
  FUNCTION F_GET_FECHA_RENOVACION_PLAN(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2 IS
    --
    --
    CURSOR C_FechaRenovacion IS
    --
    --
      SELECT iser.ID_SERVICIO,
             iser.PUNTO_ID,
             iser.FRECUENCIA_PRODUCTO,
             iser.MESES_RESTANTES,
             iser.TIPO_ORDEN,
             iper.PERSONA_EMPRESA_ROL_ID,
             ier.EMPRESA_COD,
             iper.ID_PERSONA_ROL
        FROM DB_COMERCIAL.INFO_SERVICIO iser
        JOIN DB_COMERCIAL.INFO_PUNTO ip
          ON ip.ID_PUNTO = iser.PUNTO_ID
        JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
          ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
          ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
       WHERE iser.ID_SERVICIO = Fn_IdServicio;
    --
    --
    --  
    Lv_FechaRenovacion        VARCHAR2(50) := '';
    Lv_FechaActivacion        VARCHAR2(50) := '';
    Lv_Seguir                 VARCHAR2(2) := 'S';
    Ln_CompararFechas         NUMBER := 0;
    Ln_ServicioOrigenT        NUMBER := 0;
    Ln_ProductoCaracteristica NUMBER := 0;
    Ln_ServicioOrigenTrasTmp  NUMBER := 0;
    Ln_IdInfoServicio         DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Lr_InfoServicio           DB_COMERCIAL.INFO_SERVICIO%ROWTYPE;
    Ln_NumeroLazosPermitidos  NUMBER := 0;
    --
    --
  BEGIN
    --    
    --
    IF C_FechaRenovacion%ISOPEN THEN
      --
      --
      CLOSE C_FechaRenovacion;
      --
      --
    END IF;
    --
    --
    --
    FOR Le_FechaRenovacion IN C_FechaRenovacion LOOP
      --
      --
      Ln_NumeroLazosPermitidos := 0;
      --
      --
      --
      WHILE Lv_Seguir = 'S' LOOP
        --
        --
        IF Le_FechaRenovacion.TIPO_ORDEN = 'N' THEN
          --
          --
          Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                               'renovacionPlan',
                                                                               'Accion',
                                                                               NULL);
          --
          --
          --
          IF Lv_FechaActivacion IS NULL THEN
            --
            --
            Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                                 '%Se cambio de plan,%',
                                                                                 'Observacion',
                                                                                 NULL);
            --
            --
          END IF;
          --
          --
          --
          IF Lv_FechaActivacion IS NULL THEN
            --
            --
            Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                                 'Se confirmo el servicio',
                                                                                 'Observacion',
                                                                                 NULL);
            --
            --
          END IF;
          --
          --
        ELSIF Le_FechaRenovacion.TIPO_ORDEN = 'T' THEN
          --
          --
          Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                               'renovacionPlan',
                                                                               'Accion',
                                                                               NULL);
          --
          --
          --
          IF Lv_FechaActivacion IS NULL THEN
            --
            --
            Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                                 '%Se cambio de plan,%',
                                                                                 'Observacion',
                                                                                 NULL);
            --
            --
          END IF;
          --
          --
          --
          IF Lv_FechaActivacion IS NULL THEN
            --
            --
            SELECT NVL((SELECT apc.ID_PRODUCTO_CARACTERISITICA
                         FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA apc
                        WHERE apc.ESTADO = 'Activo'
                          AND apc.PRODUCTO_ID =
                              (SELECT ap.ID_PRODUCTO
                                 FROM DB_COMERCIAL.ADMI_PRODUCTO ap
                                WHERE ap.ESTADO = 'Activo'
                                  AND ap.DESCRIPCION_PRODUCTO =
                                      'INTERNET DEDICADO'
                                  AND ap.EMPRESA_COD =
                                      Le_FechaRenovacion.EMPRESA_COD)
                          AND apc.CARACTERISTICA_ID =
                              (SELECT ac.ID_CARACTERISTICA
                                 FROM DB_COMERCIAL.ADMI_CARACTERISTICA ac
                                WHERE ac.ESTADO = 'Activo'
                                  AND ac.DESCRIPCION_CARACTERISTICA =
                                      'TRASLADO')),
                       NULL)
              INTO Ln_ProductoCaracteristica
              FROM DUAL;
            --
            --
            --
            Ln_ServicioOrigenT := Le_FechaRenovacion.ID_SERVICIO;
            --
            --
            --
            WHILE Ln_ServicioOrigenT >= 0 AND Lv_Seguir = 'S' LOOP
              --
              --
              Ln_ServicioOrigenTrasTmp := Ln_ServicioOrigenT;
              --
              --
              --
              SELECT NVL((SELECT ispc.VALOR
                           FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ispc
                          WHERE ispc.SERVICIO_ID = Ln_ServicioOrigenT
                            AND ispc.PRODUCTO_CARACTERISITICA_ID =
                                Ln_ProductoCaracteristica),
                         -1)
                INTO Ln_ServicioOrigenT
                FROM DUAL;
              --
              --
              --
              IF Ln_ServicioOrigenT = -1 THEN
                --
                --
                Lv_Seguir          := 'N';
                Ln_ServicioOrigenT := Ln_ServicioOrigenTrasTmp;
                --
                --
              END IF;
              --
              --
              --
              IF Ln_ServicioOrigenT > 0 THEN
                --
                --
                Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Ln_ServicioOrigenT,
                                                                                     'renovacionPlan',
                                                                                     'Accion',
                                                                                     NULL);
                --
                --
                --
                IF Lv_FechaActivacion IS NULL THEN
                  --
                  --
                  Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Ln_ServicioOrigenT,
                                                                                       '%Se cambio de plan,%',
                                                                                       'Observacion',
                                                                                       NULL);
                  --
                  --
                END IF;
                --
                --
                --
                IF Lv_FechaActivacion IS NULL THEN
                  --
                  --
                  Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Ln_ServicioOrigenT,
                                                                                       'Se confirmo el servicio',
                                                                                       'Observacion',
                                                                                       NULL);
                  --
                  --
                END IF;
                --
                --
                --
                IF Lv_FechaActivacion IS NOT NULL THEN
                  --
                  --
                  Ln_ServicioOrigenT := -1;
                  --
                  --
                END IF;
                --
                --
              END IF;
              --
            --
            END LOOP;
            --
            --
          END IF;
          --
          --
        END IF;
        --
        --
        --
        IF Lv_FechaActivacion IS NOT NULL THEN
          --
          --
          Lv_Seguir := 'N';
          --
          --
        END IF;
        --
        --
        --
        IF Lv_Seguir = 'S' THEN
          --
          --
          IF Le_FechaRenovacion.PERSONA_EMPRESA_ROL_ID IS NOT NULL THEN
            --    
            --
            SELECT NVL((SELECT iser.ID_SERVICIO
                         FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                         JOIN DB_COMERCIAL.INFO_PUNTO ip
                           ON ip.PERSONA_EMPRESA_ROL_ID =
                              iper.ID_PERSONA_ROL
                         JOIN DB_COMERCIAL.INFO_SERVICIO iser
                           ON iser.PUNTO_ID = ip.ID_PUNTO
                         JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc
                           ON ipc.ID_PLAN = iser.PLAN_ID
                        WHERE ipc.ID_PLAN IN
                              (SELECT ipc2.ID_PLAN
                                 FROM DB_COMERCIAL.INFO_PLAN_CAB ipc2
                                 JOIN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA ipcar
                                   ON ipc2.ID_PLAN = ipcar.PLAN_ID
                                 JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac2
                                   ON ac2.ID_CARACTERISTICA =
                                      ipcar.CARACTERISTICA_ID
                                WHERE ipcar.VALOR = 'SI'
                                  AND ipcar.ESTADO = 'Activo'
                                  AND ac2.DESCRIPCION_CARACTERISTICA =
                                      'REQUIERE_RENOVACION'
                                  AND ac2.ESTADO = 'Activo')
                          AND iper.ID_PERSONA_ROL =
                              Le_FechaRenovacion.PERSONA_EMPRESA_ROL_ID
                          AND ROWNUM = 1),
                       NULL)
              INTO Ln_IdInfoServicio
              FROM DUAL;
            --
            --
          ELSE
            --
            --
            SELECT NVL((SELECT iser.ID_SERVICIO
                         FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                         JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC iperc
                           ON iperc.PERSONA_EMPRESA_ROL_ID =
                              iper.ID_PERSONA_ROL
                         JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac
                           ON ac.ID_CARACTERISTICA =
                              iperc.CARACTERISTICA_ID
                         JOIN DB_COMERCIAL.INFO_PUNTO ip
                           ON TO_CHAR(ip.ID_PUNTO) = iperc.VALOR
                         JOIN DB_COMERCIAL.INFO_SERVICIO iser
                           ON iser.PUNTO_ID = ip.ID_PUNTO
                         JOIN DB_COMERCIAl.INFO_PLAN_CAB ipc
                           ON iser.PLAN_ID = ipc.ID_PLAN
                        WHERE iper.ID_PERSONA_ROL =
                              Le_FechaRenovacion.ID_PERSONA_ROL
                          AND ac.DESCRIPCION_CARACTERISTICA =
                              'PUNTO CAMBIO RAZON SOCIAL'
                          AND ac.ESTADO = 'Activo'
                          AND ipc.ID_PLAN IN
                              (SELECT ipc2.ID_PLAN
                                 FROM DB_COMERCIAL.INFO_PLAN_CAB ipc2
                                 JOIN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA ipcar
                                   ON ipc2.ID_PLAN = ipcar.PLAN_ID
                                 JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac2
                                   ON ac2.ID_CARACTERISTICA =
                                      ipcar.CARACTERISTICA_ID
                                WHERE ipcar.VALOR = 'SI'
                                  AND ipcar.ESTADO = 'Activo'
                                  AND ac2.DESCRIPCION_CARACTERISTICA =
                                      'REQUIERE_RENOVACION'
                                  AND ac2.ESTADO = 'Activo')
                          AND ROWNUM = 1),
                       NULL)
              INTO Ln_IdInfoServicio
              FROM DUAL;
            --
            --
            --
            IF Ln_IdInfoServicio IS NULL THEN
              --
              --
              SELECT NVL((SELECT iser.ID_SERVICIO
                           FROM DB_COMERCIAL.INFO_SERVICIO iser
                           JOIN DB_COMERCIAL.INFO_PUNTO ip
                             ON iser.PUNTO_ID = ip.ID_PUNTO
                           JOIN DB_COMERCIAl.INFO_PLAN_CAB ipc
                             ON iser.PLAN_ID = ipc.ID_PLAN
                          WHERE TO_CHAR(ip.ID_PUNTO) IN
                                (SELECT TO_CHAR(ipc3.VALOR)
                                   FROM DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA ipc3
                                  WHERE ipc3.ID_PUNTO_CARACTERISTICA =
                                        (SELECT MAX(ipc2.ID_PUNTO_CARACTERISTICA)
                                           FROM DB_COMERCIAL.INFO_PUNTO ip2
                                           JOIN DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA ipc2
                                             ON ip2.ID_PUNTO = ipc2.PUNTO_ID
                                           JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac2
                                             ON ac2.ID_CARACTERISTICA =
                                                ipc2.CARACTERISTICA_ID
                                          WHERE ip2.ID_PUNTO =
                                                Le_FechaRenovacion.PUNTO_ID
                                            AND ac2.DESCRIPCION_CARACTERISTICA =
                                                'PUNTO CAMBIO RAZON SOCIAL'
                                            AND ac2.ESTADO = 'Activo'))
                            AND ipc.ID_PLAN IN
                                (SELECT ipc3.ID_PLAN
                                   FROM DB_COMERCIAL.INFO_PLAN_CAB ipc3
                                   JOIN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA ipcar3
                                     ON ipc3.ID_PLAN = ipcar3.PLAN_ID
                                   JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac3
                                     ON ac3.ID_CARACTERISTICA =
                                        ipcar3.CARACTERISTICA_ID
                                  WHERE ipcar3.VALOR = 'SI'
                                    AND ipcar3.ESTADO = 'Activo'
                                    AND ac3.DESCRIPCION_CARACTERISTICA =
                                        'REQUIERE_RENOVACION'
                                    AND ac3.ESTADO = 'Activo')
                            AND ROWNUM = 1),
                         NULL)
                INTO Ln_IdInfoServicio
                FROM DUAL;
              --
              --
            END IF;
            --
            --
          END IF;
          --
          --
          --
          IF Ln_IdInfoServicio IS NOT NULL THEN
            --
            --
            SELECT iser.*
              INTO Lr_InfoServicio
              FROM DB_COMERCIAL.INFO_SERVICIO iser
             WHERE iser.ID_SERVICIO = Ln_IdInfoServicio;
            --
            --
            --
            Le_FechaRenovacion.TIPO_ORDEN  := Lr_InfoServicio.TIPO_ORDEN;
            Le_FechaRenovacion.ID_SERVICIO := Lr_InfoServicio.ID_SERVICIO;
            --
            --
          ELSE
            --
            --
            Lv_Seguir := 'N';
            --
            --
          END IF;
          --
          --
        END IF;
        --
        --
        --
        IF Ln_NumeroLazosPermitidos = 10 THEN
          --
          --
          Lv_Seguir := 'N';
          --
          --
        END IF;
        --
        --
        --
        Ln_NumeroLazosPermitidos := Ln_NumeroLazosPermitidos + 1;
        --
      --
      END LOOP;
      --
      --
      --
      IF Lv_FechaActivacion IS NOT NULL THEN
        --
        --
        SELECT NVL((SELECT TO_CHAR(ADD_MONTHS(Lv_FechaActivacion,
                                             Le_FechaRenovacion.FRECUENCIA_PRODUCTO),
                                  'DD/MM/YYYY')
                     FROM DUAL),
                   0)
          INTO Lv_FechaRenovacion
          FROM DUAL;
        --
        --
      ELSE
        --
        --
        Lv_FechaRenovacion := '';
        --
        --
      END IF;
      --
    --
    END LOOP;
    --
    --
    IF C_FechaRenovacion%ISOPEN THEN
      --
      --
      CLOSE C_FechaRenovacion;
      --
      --
    END IF;
    --
    --
    RETURN Lv_FechaRenovacion;
    --
    --
  END F_GET_FECHA_RENOVACION_PLAN;
  ----
  --
  --
  --
  FUNCTION F_GET_FECHA_CREACION_HISTORIAL(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                          Fv_Buscar     IN VARCHAR2,
                                          Fv_Parametro  IN VARCHAR2,
                                          Fd_FechaFin   IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE)
    RETURN VARCHAR2 IS
    --
    --CURSOR QUE RETORNA HISTORIAL DEL SERVICIO DEPENDIENDO DE LA ACCION Y FECHA CONSULTA ENVIADA PARA LA CONSULTA
    --COSTO DEL QUERY: 3
    CURSOR C_GetHistorialByAccion(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                  Cv_Accion     VARCHAR2,
                                  Cd_FechaFin   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE) IS
    --
      SELECT ISERH.ID_SERVICIO_HISTORIAL,
             ISERH.FE_CREACION,
             ISERH.ESTADO,
             ISERH.OBSERVACION
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
       WHERE ISERH.ID_SERVICIO_HISTORIAL =
             (SELECT MAX(ISERH_S.ID_SERVICIO_HISTORIAL)
                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH_S
               WHERE ISERH_S.ACCION = Cv_Accion
                 AND ISERH_S.SERVICIO_ID = Cn_IdServicio
                 AND ISERH_S.FE_CREACION < Cd_FechaFin);
    --
    --
    --CURSOR QUE RETORNA HISTORIAL DEL SERVICIO DEPENDIENDO DE LA OBSERVACION ENVIADA PARA LA CONSULTA
    --COSTO DEL QUERY: 3
    CURSOR C_GetHistorialByObservacion(Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Cv_Observacion VARCHAR2,
                                       Cd_FechaFin    DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE) IS
    --
      SELECT ISERH.ID_SERVICIO_HISTORIAL, ISERH.FE_CREACION, ISERH.ESTADO
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
       WHERE ISERH.ID_SERVICIO_HISTORIAL =
             (SELECT MAX(ISERH_S.ID_SERVICIO_HISTORIAL)
                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH_S
               WHERE ISERH_S.OBSERVACION LIKE Cv_Observacion
                 AND ISERH_S.SERVICIO_ID = Cn_IdServicio
                 AND ISERH_S.FE_CREACION < Cd_FechaFin);
    --
    --
    --
    --CURSOR QUE RETORNA LA FECHA DE CREACION DEL HISTORIAL DEPENDIENDO DEL ESTADO ENVIADO PARA LA CONSULTA
    --COSTO DEL QUERY: 3
    CURSOR C_GetFechaHistorialByEstado(Cn_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Cv_Estado               VARCHAR2,
                                       Cv_DescripcionSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE) IS
    --
      SELECT ISERH.FE_CREACION,
             NVL((SELECT NVL(TRIM(AM.NOMBRE_MOTIVO), NULL)
                   FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                   JOIN DB_GENERAL.ADMI_MOTIVO AM
                     ON AM.ID_MOTIVO = IDS.MOTIVO_ID
                   JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
                     ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
                  WHERE ATS.DESCRIPCION_SOLICITUD = Cv_DescripcionSolicitud
                    AND IDS.SERVICIO_ID = ISERH.SERVICIO_ID
                    AND ROWNUM = 1),
                 (SELECT NVL(TRIM(AM_S.NOMBRE_MOTIVO), NULL)
                    FROM DB_GENERAL.ADMI_MOTIVO AM_S
                   WHERE AM_S.ID_MOTIVO = ISERH.MOTIVO_ID)) AS NOMBRE_MOTIVO,
             NVL((SELECT NVL(TRIM(AMP.NOMBRE_MOTIVO), NULL)
                   FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                   JOIN DB_GENERAL.ADMI_MOTIVO AM
                     ON AM.ID_MOTIVO = IDS.MOTIVO_ID
                   JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
                     ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
                   JOIN DB_GENERAL.ADMI_MOTIVO AMP
                     ON AM.REF_MOTIVO_ID = AMP.ID_MOTIVO
                  WHERE ATS.DESCRIPCION_SOLICITUD = Cv_DescripcionSolicitud
                    AND IDS.SERVICIO_ID = ISERH.SERVICIO_ID
                    AND ROWNUM = 1),
                 (SELECT NVL(TRIM(AMP_S.NOMBRE_MOTIVO), NULL)
                    FROM DB_GENERAL.ADMI_MOTIVO AM_S
                    JOIN DB_GENERAL.ADMI_MOTIVO AMP_S
                      ON AM_S.REF_MOTIVO_ID = AMP_S.ID_MOTIVO
                   WHERE AM_S.ID_MOTIVO = ISERH.MOTIVO_ID)) AS NOMBRE_MOTIVO_PADRE,
             ISERH.OBSERVACION,
             ISERH.ID_SERVICIO_HISTORIAL
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
       WHERE ISERH.ID_SERVICIO_HISTORIAL =
             (SELECT MAX(ISERH_S.ID_SERVICIO_HISTORIAL)
                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH_S
               WHERE ISERH_S.ESTADO = Cv_Estado
                 AND ISERH_S.SERVICIO_ID = Cn_IdServicio);
    --
    --
    --CURSOR QUE RETORNA EL ESTADO DEL HISTORIAL DEL SERVICIO A BUSCAR
    --COSTO DEL QUERY: 3
    CURSOR C_GetHistorial(Cn_IdServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE) IS
    --
      SELECT ISERH.ID_SERVICIO_HISTORIAL, ISERH.ESTADO, ISERH.FE_CREACION
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
       WHERE ISERH.ID_SERVICIO_HISTORIAL = Cn_IdServicioHistorial;
    --
    --
    Lr_GetEstadoHistorial        C_GetHistorial%ROWTYPE;
    Lr_GetHistorialByObservacion C_GetHistorialByObservacion%ROWTYPE;
    Lr_GetFechaHistorialByEstado C_GetFechaHistorialByEstado%ROWTYPE;
    Lr_GetHistorialByAccion      C_GetHistorialByAccion%ROWTYPE;
    Lv_DescripcionSolicitud      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE := 'CANCELACION';
    Lv_FechaResultado            VARCHAR2(1000) := '';
    --
  BEGIN
    --
    IF Fv_Parametro = 'Accion' THEN
      --
      --
      SELECT NVL((SELECT iserh.FE_CREACION
                   FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL iserh
                   JOIN DB_COMERCIAL.INFO_SERVICIO iser
                     ON iserh.SERVICIO_ID = iser.ID_SERVICIO
                  WHERE iser.ID_SERVICIO = Fn_IdServicio
                    AND iserh.ID_SERVICIO_HISTORIAL =
                        (SELECT MAX(iserh2.ID_SERVICIO_HISTORIAL)
                           FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL iserh2
                          WHERE iserh2.ACCION = Fv_Buscar
                            AND iserh2.SERVICIO_ID = Fn_IdServicio)),
                 NULL)
        INTO Lv_FechaResultado
        FROM DUAL;
      --
      --
    ELSIF Fv_Parametro = 'Estado' OR Fv_Parametro = 'Motivo' OR
          Fv_Parametro = 'MotivoPadre' THEN
      --
      IF C_GetFechaHistorialByEstado%ISOPEN THEN
        CLOSE C_GetFechaHistorialByEstado;
      END IF;
      --
      OPEN C_GetFechaHistorialByEstado(Fn_IdServicio,
                                       Fv_Buscar,
                                       Lv_DescripcionSolicitud);
      --
      FETCH C_GetFechaHistorialByEstado
        INTO Lr_GetFechaHistorialByEstado;
      --
      CLOSE C_GetFechaHistorialByEstado;
      --
      --
      IF Lr_GetFechaHistorialByEstado.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        IF Fv_Parametro = 'Estado' THEN
          --
          Lv_FechaResultado := Lr_GetFechaHistorialByEstado.FE_CREACION;
          --
        ELSIF Fv_Parametro = 'Motivo' THEN
          --
          Lv_FechaResultado := Lr_GetFechaHistorialByEstado.NOMBRE_MOTIVO;
          --
          IF TRIM(Lv_FechaResultado) IS NULL THEN
            --
            Lv_FechaResultado := TO_CHAR(dbms_lob.substr(Lr_GetFechaHistorialByEstado.OBSERVACION,
                                                         300,
                                                         1));
            --
          END IF;
          --
        ELSIF Fv_Parametro = 'MotivoPadre' THEN
          --
          Lv_FechaResultado := Lr_GetFechaHistorialByEstado.NOMBRE_MOTIVO_PADRE;
          --
        END IF;
        --
      END IF;
      --
      --
    ELSIF Fv_Parametro = 'HistorialByAccionObservacion' THEN
      --
      IF C_GetHistorialByAccion%ISOPEN THEN
        CLOSE C_GetHistorialByAccion;
      END IF;
      --
      OPEN C_GetHistorialByAccion(Fn_IdServicio, Fv_Buscar, Fd_FechaFin);
      --
      FETCH C_GetHistorialByAccion
        INTO Lr_GetHistorialByAccion;
      --
      CLOSE C_GetHistorialByAccion;
      --
      --
      IF Lr_GetHistorialByAccion.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        Lv_FechaResultado := TRIM(Lr_GetHistorialByAccion.OBSERVACION);
        --
      END IF;
      --
      --
    ELSIF Fv_Parametro = 'HistorialByObservacionEstado' THEN
      --
      IF C_GetHistorialByObservacion%ISOPEN THEN
        CLOSE C_GetHistorialByObservacion;
      END IF;
      --
      OPEN C_GetHistorialByObservacion(Fn_IdServicio,
                                       Fv_Buscar,
                                       Fd_FechaFin);
      --
      FETCH C_GetHistorialByObservacion
        INTO Lr_GetHistorialByObservacion;
      --
      CLOSE C_GetHistorialByObservacion;
      --
      --
      IF Lr_GetHistorialByObservacion.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        Lv_FechaResultado := TRIM(Lr_GetHistorialByObservacion.ESTADO);
        --
      END IF;
      --
    ELSIF Fv_Parametro = 'HistorialByObservacionFeCreacion' THEN
      --
      IF C_GetHistorialByObservacion%ISOPEN THEN
        CLOSE C_GetHistorialByObservacion;
      END IF;
      --
      OPEN C_GetHistorialByObservacion(Fn_IdServicio,
                                       Fv_Buscar,
                                       Fd_FechaFin);
      --
      FETCH C_GetHistorialByObservacion
        INTO Lr_GetHistorialByObservacion;
      --
      CLOSE C_GetHistorialByObservacion;
      --
      --
      IF Lr_GetHistorialByObservacion.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        Lv_FechaResultado := TRIM(Lr_GetHistorialByObservacion.FE_CREACION);
        --
      END IF;
      --
    ELSIF Fv_Parametro = 'Historial' THEN
      --
      IF C_GetHistorial%ISOPEN THEN
        CLOSE C_GetHistorial;
      END IF;
      --
      OPEN C_GetHistorial(Fn_IdServicio);
      --
      FETCH C_GetHistorial
        INTO Lr_GetEstadoHistorial;
      --
      CLOSE C_GetHistorial;
      --
      --
      IF Lr_GetEstadoHistorial.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        IF Fv_Buscar = 'Estado' THEN
          --
          Lv_FechaResultado := TRIM(Lr_GetEstadoHistorial.ESTADO);
          --
        ELSE
          --
          Lv_FechaResultado := TRIM(Lr_GetEstadoHistorial.FE_CREACION);
          --
        END IF;
        --
      END IF;
      --
    ELSE
      --
      --
      SELECT NVL((SELECT iserh.FE_CREACION
                   FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL iserh
                   JOIN DB_COMERCIAL.INFO_SERVICIO iser
                     ON iserh.SERVICIO_ID = iser.ID_SERVICIO
                  WHERE iser.ID_SERVICIO = Fn_IdServicio
                    AND iserh.ID_SERVICIO_HISTORIAL =
                        (SELECT MAX(iserh2.ID_SERVICIO_HISTORIAL)
                           FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL iserh2
                          WHERE iserh2.OBSERVACION LIKE Fv_Buscar
                            AND iserh2.SERVICIO_ID = Fn_IdServicio)),
                 NULL)
        INTO Lv_FechaResultado
        FROM DUAL;
      --
      --
    END IF;
    --
    --
    --
    RETURN Lv_FechaResultado;
    --
    --
  END F_GET_FECHA_CREACION_HISTORIAL;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_NOMBRE_CLIENTE
  * la funcion F_GET_SOLMA_NOMBRE_CLIENTE obtiene el nombre o razon social del cliente en tabla INFO_PERSONA
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE    Recibe el Id detalle solicitud Cabecera
  * @return VARCHAR2  Retorna el nombre del cliente
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_NOMBRE_CLIENTE(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetCliente(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE) IS
      SELECT NVL(IP.RAZON_SOCIAL, IP.NOMBRES || ' ' || IP.APELLIDOS)
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        LEFT JOIN DB_COMERCIAL.INFO_SERVICIO ISER
          ON IDS.SERVICIO_ID = ISER.ID_SERVICIO
        LEFT JOIN DB_COMERCIAL.INFO_PUNTO IPTO
          ON ISER.PUNTO_ID = IPTO.ID_PUNTO
        LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
          ON IPTO.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
        LEFT JOIN DB_COMERCIAL.INFO_PERSONA IP
          ON IP.ID_PERSONA = IPER.PERSONA_ID
        LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC_DET
          ON IDS.ID_DETALLE_SOLICITUD = IDSC_DET.DETALLE_SOLICITUD_ID
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          ON IDSC_DET.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
       WHERE ACAR.DESCRIPCION_CARACTERISTICA = 'Referencia Solicitud'
         AND IDSC_DET.VALOR = TO_CHAR(Cn_IdDetalleSolicitud)
         AND ROWNUM < 2;
    --
    Lv_NombreCliente VARCHAR2(500) := '';
    --
  BEGIN
    --
    IF C_GetCliente%ISOPEN THEN
      CLOSE C_GetCliente;
    END IF;
    --
    OPEN C_GetCliente(Fn_IdDetalleSolicitud);
    --
    FETCH C_GetCliente
      INTO Lv_NombreCliente;
    --
    CLOSE C_GetCliente;
    --
    RETURN Lv_NombreCliente;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_NombreCliente;
      --
  END F_GET_SOLMA_NOMBRE_CLIENTE;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_NOMBRE_PRODUCTO
  * la funcion F_GET_SOLMA_NOMBRE_PRODUCTO obtiene el nombre o razon social del cliente en tabla INFO_PERSONA
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE    Recibe el Id detalle solicitud Cabecera
  * @return VARCHAR2  Retorna el nombre del cliente
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_NOMBRE_PRODUCTO(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetProducto(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE) IS
      SELECT APROD.DESCRIPCION_PRODUCTO
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        LEFT JOIN DB_COMERCIAL.INFO_SERVICIO ISER
          ON IDS.SERVICIO_ID = ISER.ID_SERVICIO
        LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APROD
          ON ISER.PRODUCTO_ID = APROD.ID_PRODUCTO
        LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC_DET
          ON IDS.ID_DETALLE_SOLICITUD = IDSC_DET.DETALLE_SOLICITUD_ID
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          ON IDSC_DET.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
       WHERE ACAR.DESCRIPCION_CARACTERISTICA = 'Referencia Solicitud'
         AND IDSC_DET.VALOR = TO_CHAR(Cn_IdDetalleSolicitud)
         AND ROWNUM < 2;
    --
    Lv_NombreProducto VARCHAR2(500) := '';
    --
  BEGIN
    --
    IF C_GetProducto%ISOPEN THEN
      CLOSE C_GetProducto;
    END IF;
    --
    OPEN C_GetProducto(Fn_IdDetalleSolicitud);
    --
    FETCH C_GetProducto
      INTO Lv_NombreProducto;
    --
    CLOSE C_GetProducto;
    --
    RETURN Lv_NombreProducto;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_NombreProducto;
      --
  END F_GET_SOLMA_NOMBRE_PRODUCTO;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_CARACTERISTICA
  * la funcion F_GET_SOLMA_CARACTERISTICA obtiene el valor de la caracteristica en INFO_DETALLE_SOL_CARACT
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE    Recibe el Id detalle solicitud Cabecera
  * @param  Fn_descCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE Recibe la descripcion de la caracteristica
  * @return VARCHAR2  Retorna valor de la caracteristica
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_CARACTERISTICA(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                      Fn_descCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetCaracteristica(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                               Cn_descCaracteristica ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE) IS
      SELECT IDSC.VALOR
        FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          ON IDSC.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
       WHERE IDSC.DETALLE_SOLICITUD_ID = Cn_IdDetalleSolicitud
         AND ACAR.DESCRIPCION_CARACTERISTICA = Cn_descCaracteristica;
    --
    Lv_ValorCaracteristica VARCHAR2(500) := '';
    --
  BEGIN
    --
    IF C_GetCaracteristica%ISOPEN THEN
      CLOSE C_GetCaracteristica;
    END IF;
    --
    OPEN C_GetCaracteristica(Fn_IdDetalleSolicitud, Fn_descCaracteristica);
    --
    FETCH C_GetCaracteristica
      INTO Lv_ValorCaracteristica;
    --
    CLOSE C_GetCaracteristica;
    --
    RETURN Lv_ValorCaracteristica;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_ValorCaracteristica;
      --
  END F_GET_SOLMA_CARACTERISTICA;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_TOTAL_DET_EST
  * la funcion F_GET_SOLMA_TOTAL_DET_EST obtiene el total de detalles con determinado estado de una Solicitud Masiva
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE Recibe el Id detalle solicitud Cabecera
  * @param  Fn_estado IN VARCHAR2 Recibe el nombre del estado
  * @return NUMBER  Retorna la cantidad de detalles
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_TOTAL_DET_EST(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                     Fn_estado             IN VARCHAR2)
    RETURN NUMBER IS
    --
    CURSOR C_GetTotalDetalles(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                              Cn_estado             VARCHAR2) IS
      SELECT COUNT(*) TOTAL
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
          ON IDS.ID_DETALLE_SOLICITUD = IDSC.DETALLE_SOLICITUD_ID
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          ON IDSC.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
       WHERE ACAR.DESCRIPCION_CARACTERISTICA = 'Referencia Solicitud'
         AND IDSC.VALOR = TO_CHAR(Cn_IdDetalleSolicitud)
         AND (IDS.ESTADO = Cn_estado OR Cn_estado IS NULL OR Cn_estado = '');
    --
    Lv_TotalDetalles NUMBER := 0;
    --
  BEGIN
    --
    IF C_GetTotalDetalles%ISOPEN THEN
      CLOSE C_GetTotalDetalles;
    END IF;
    --
    OPEN C_GetTotalDetalles(Fn_IdDetalleSolicitud, Fn_estado);
    --
    FETCH C_GetTotalDetalles
      INTO Lv_TotalDetalles;
    --
    CLOSE C_GetTotalDetalles;
    --
    RETURN Lv_TotalDetalles;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_TotalDetalles;
      --
  END F_GET_SOLMA_TOTAL_DET_EST;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_TOTAL_DET_EST_CAR
  * la funcion F_GET_SOLMA_TOTAL_DET_EST_CAR obtiene el total de detalles con determinado estado de una Solicitud Masiva en una caracteristica
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE Recibe el Id detalle solicitud Cabecera
  * @param  Fn_estado IN VARCHAR2 Recibe el nombre del estado
  * @param  Fn_caracteristica IN VARCHAR2 Recibe el nombre de la caracteristica
  * @return NUMBER  Retorna la cantidad de detalles
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_TOTAL_DET_EST_CAR(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                         Fn_caracteristica     IN VARCHAR2,
                                         Fn_estado             IN VARCHAR2)
    RETURN NUMBER IS
    --
    CURSOR C_GetTotalDetalles(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                              Cn_caracteristica     VARCHAR2,
                              Cn_estado             VARCHAR2) IS
      SELECT COUNT(T1.ID_DETALLE_SOLICITUD)
        FROM (SELECT IDS.*
                FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
                  ON IDS.ID_DETALLE_SOLICITUD = IDSC.DETALLE_SOLICITUD_ID
                LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
                  ON IDSC.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
               WHERE ACAR.DESCRIPCION_CARACTERISTICA =
                     'Referencia Solicitud'
                 AND IDSC.VALOR = TO_CHAR(Cn_IdDetalleSolicitud)) T1
        JOIN (SELECT IDS.*, ACAR.DESCRIPCION_CARACTERISTICA, IDSC.VALOR
                FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
                  ON IDS.ID_DETALLE_SOLICITUD = IDSC.DETALLE_SOLICITUD_ID
                LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
                  ON IDSC.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
               WHERE ACAR.DESCRIPCION_CARACTERISTICA = Cn_caracteristica
                 AND IDSC.VALOR = Cn_estado
                  OR Cn_estado IS NULL
                  OR Cn_estado = '') T2
          ON T2.ID_DETALLE_SOLICITUD = T1.ID_DETALLE_SOLICITUD;
    --
    Lv_TotalDetalles NUMBER := 0;
    --
  BEGIN
    --
    IF C_GetTotalDetalles%ISOPEN THEN
      CLOSE C_GetTotalDetalles;
    END IF;
    --
    OPEN C_GetTotalDetalles(Fn_IdDetalleSolicitud,
                            Fn_caracteristica,
                            Fn_estado);
    --
    FETCH C_GetTotalDetalles
      INTO Lv_TotalDetalles;
    --
    CLOSE C_GetTotalDetalles;
    --
    RETURN Lv_TotalDetalles;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_TotalDetalles;
      --
  END F_GET_SOLMA_TOTAL_DET_EST_CAR;
  --
  FUNCTION GET_MODEL_ELE_X_SERV_TIPO(Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pn_TipoElemento IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE,
                                     Pn_Campo        IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetAdmiModeloElemento(Cn_IdElemento DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE) IS
      SELECT AME.ID_MODELO_ELEMENTO,
             AME.NOMBRE_MODELO_ELEMENTO,
             AME.CAPACIDAD_ENTRADA,
             AME.UNIDAD_MEDIDA_ENTRADA,
             AME.CAPACIDAD_SALIDA,
             AME.UNIDAD_MEDIDA_SALIDA
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO        IELE,
             DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME
       WHERE IELE.ID_ELEMENTO = Cn_IdElemento
         AND AME.ID_MODELO_ELEMENTO = IELE.MODELO_ELEMENTO_ID;
    --
    Lr_AdmiModeloElemento C_GetAdmiModeloElemento%ROWTYPE;
    Lv_IdElemento         DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE;
    Lv_Resultado          VARCHAR2(1000);
  BEGIN
    --
    Lv_IdElemento := GET_ELEMENTO_X_SERV_TIPO(Pn_IdServicio,
                                              Pn_TipoElemento);
    --
    IF Lv_IdElemento IS NOT NULL THEN
      --
      IF C_GetAdmiModeloElemento%ISOPEN THEN
        --
        CLOSE C_GetAdmiModeloElemento;
        --
      END IF;
      --
      OPEN C_GetAdmiModeloElemento(Lv_IdElemento);
      --
      FETCH C_GetAdmiModeloElemento
        INTO Lr_AdmiModeloElemento;
      --
      CLOSE C_GetAdmiModeloElemento;
      --
      IF Lr_AdmiModeloElemento.ID_MODELO_ELEMENTO IS NOT NULL THEN
        --
        IF Pn_Campo = 'ID' THEN
          --
          Lv_Resultado := TO_CHAR(Lr_AdmiModeloElemento.ID_MODELO_ELEMENTO);
          --
        END IF;
        --
        IF Pn_Campo = 'NOMBRE' THEN
          --
          Lv_Resultado := Lr_AdmiModeloElemento.NOMBRE_MODELO_ELEMENTO;
          --
        END IF;
        --
        IF Pn_Campo = 'CAPACIDAD1' THEN
          --
          Lv_Resultado := TO_CHAR(Lr_AdmiModeloElemento.CAPACIDAD_ENTRADA);
          --
        END IF;
        --
        IF Pn_Campo = 'CAPACIDAD1_UNIDAD' THEN
          --
          Lv_Resultado := Lr_AdmiModeloElemento.UNIDAD_MEDIDA_ENTRADA;
          --
        END IF;
        --
        IF Pn_Campo = 'CAPACIDAD2' THEN
          --
          Lv_Resultado := TO_CHAR(Lr_AdmiModeloElemento.CAPACIDAD_SALIDA);
          --
        END IF;
        --
        IF Pn_Campo = 'CAPACIDAD2_UNIDAD' THEN
          --
          Lv_Resultado := Lr_AdmiModeloElemento.UNIDAD_MEDIDA_SALIDA;
          --
        END IF;
        --
        --
      END IF;
      --
    END IF;
    --
    RETURN Lv_Resultado;
    --
  END GET_MODEL_ELE_X_SERV_TIPO;
  --
  FUNCTION GET_ELEMENTO_X_SERV_TIPO(Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Pn_TipoElemento IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE IS
    --
    CURSOR C_GetInfoServicioTecnico(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) IS
      SELECT DISTINCT IST.INTERFACE_ELEMENTO_CONECTOR_ID,
                      IST.ELEMENTO_CLIENTE_ID,
                      IST.INTERFACE_ELEMENTO_CLIENTE_ID,
                      ATM.NOMBRE_TIPO_MEDIO,
                      CASE
                        WHEN ISPC.VALOR IS NOT NULL THEN
                         ISPC.VALOR
                        WHEN ISPC.VALOR IS NULL AND
                             ATM.NOMBRE_TIPO_MEDIO = 'Fibra Optica' THEN
                         'RUTA'
                        WHEN ISPC.VALOR IS NULL AND
                             ATM.NOMBRE_TIPO_MEDIO != 'Fibra Optica' THEN
                         'DIRECTO'
                      END TIPO_FACTIBILIDAD
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
        JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO ATM
          ON ATM.ID_TIPO_MEDIO = IST.ULTIMA_MILLA_ID
        JOIN DB_COMERCIAL.INFO_SERVICIO ISER
          ON ISER.ID_SERVICIO = IST.SERVICIO_ID
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
          ON AC.DESCRIPCION_CARACTERISTICA = 'TIPO_FACTIBILIDAD'
        LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
          ON APC.PRODUCTO_ID = ISER.PRODUCTO_ID
         AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
        LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
          ON ISPC.SERVICIO_ID = ISER.ID_SERVICIO
         AND ISPC.PRODUCTO_CARACTERISITICA_ID =
             APC.ID_PRODUCTO_CARACTERISITICA
       WHERE IST.SERVICIO_ID = Cn_IdServicio;
    --
    CURSOR C_GetNombreTipoElemento(Cn_IdElemento DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE) IS
      SELECT ATE.NOMBRE_TIPO_ELEMENTO
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO        IELE,
             DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
             DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO   ATE
       WHERE IELE.ID_ELEMENTO = Cn_IdElemento
         AND AME.ID_MODELO_ELEMENTO = IELE.MODELO_ELEMENTO_ID
         AND ATE.ID_TIPO_ELEMENTO = AME.TIPO_ELEMENTO_ID;
    --
    Lr_InfoServicioTecnico C_GetInfoServicioTecnico%ROWTYPE;
    Lv_IdElementoCliente   DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE;
    Lv_NombreTipoElemento  DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE;
  BEGIN
    --
    IF C_GetInfoServicioTecnico%ISOPEN THEN
      --
      CLOSE C_GetInfoServicioTecnico;
      --
    END IF;
    --
    OPEN C_GetInfoServicioTecnico(Pn_IdServicio);
    --
    FETCH C_GetInfoServicioTecnico
      INTO Lr_InfoServicioTecnico;
    --
    CLOSE C_GetInfoServicioTecnico;
    --
    IF Lr_InfoServicioTecnico.NOMBRE_TIPO_MEDIO = 'Fibra Optica' AND
       Lr_InfoServicioTecnico.TIPO_FACTIBILIDAD = 'RUTA' THEN
      --
      Lv_IdElementoCliente := GET_ELEMENTO_CLI_X_TIPO_ELE(Lr_InfoServicioTecnico.INTERFACE_ELEMENTO_CONECTOR_ID,
                                                          Pn_TipoElemento);
      --
    ELSIF (Lr_InfoServicioTecnico.NOMBRE_TIPO_MEDIO = 'Fibra Optica' AND
          Lr_InfoServicioTecnico.TIPO_FACTIBILIDAD = 'DIRECTO') OR
          Lr_InfoServicioTecnico.NOMBRE_TIPO_MEDIO = 'Radio' THEN
      --
      Lv_IdElementoCliente := GET_ELEMENTO_CLI_X_TIPO_ELE(Lr_InfoServicioTecnico.INTERFACE_ELEMENTO_CLIENTE_ID,
                                                          Pn_TipoElemento);
      --
    ELSIF Lr_InfoServicioTecnico.NOMBRE_TIPO_MEDIO = 'UTP' THEN
      --
      Lv_IdElementoCliente := Lr_InfoServicioTecnico.ELEMENTO_CLIENTE_ID;
      --
    END IF;
    --
    IF Lv_IdElementoCliente IS NULL THEN
      --
      IF C_GetNombreTipoElemento%ISOPEN THEN
        --
        CLOSE C_GetNombreTipoElemento;
        --
      END IF;
      --
      OPEN C_GetNombreTipoElemento(Lr_InfoServicioTecnico.ELEMENTO_CLIENTE_ID);
      --
      FETCH C_GetNombreTipoElemento
        INTO Lv_NombreTipoElemento;
      --
      CLOSE C_GetNombreTipoElemento;
      --
      IF Lv_NombreTipoElemento LIKE (Pn_TipoElemento || '%') THEN
        --
        Lv_IdElementoCliente := Lr_InfoServicioTecnico.ELEMENTO_CLIENTE_ID;
        --
      END IF;
      --
    END IF;
    --
    RETURN Lv_IdElementoCliente;
    --
  END GET_ELEMENTO_X_SERV_TIPO;
  --
  FUNCTION GET_ELEMENTO_CLI_X_TIPO_ELE(Pn_IdInterfaceElementoConector IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID%TYPE,
                                       Pn_TipoElemento                IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE IS
    --
    CURSOR C_GetInfoInterfaceElemento(Cn_IdInterfaceElemento DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE) IS
      SELECT IIE.ID_INTERFACE_ELEMENTO, IIE.ELEMENTO_ID
        FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IIE
       WHERE IIE.ID_INTERFACE_ELEMENTO = Cn_IdInterfaceElemento;
    --
    CURSOR C_GetInfoEnlace(Cn_IdInterfaceElementoIni DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_INI_ID%TYPE,
                           Cn_Estado                 DB_INFRAESTRUCTURA.INFO_ENLACE.ESTADO%TYPE) IS
      SELECT IE.INTERFACE_ELEMENTO_FIN_ID
        FROM DB_INFRAESTRUCTURA.INFO_ENLACE IE
       WHERE IE.INTERFACE_ELEMENTO_INI_ID = Cn_IdInterfaceElementoIni
         AND IE.ESTADO = Cn_Estado;
    --
    CURSOR C_GetNombreTipoElemento(Cn_IdInterfaceElemento DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE) IS
      SELECT ATE.NOMBRE_TIPO_ELEMENTO
        FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IIE,
             DB_INFRAESTRUCTURA.INFO_ELEMENTO           IELE,
             DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO    AME,
             DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO      ATE
       WHERE IIE.ID_INTERFACE_ELEMENTO = Cn_IdInterfaceElemento
         AND IELE.ID_ELEMENTO = IIE.ELEMENTO_ID
         AND AME.ID_MODELO_ELEMENTO = IELE.MODELO_ELEMENTO_ID
         AND ATE.ID_TIPO_ELEMENTO = AME.TIPO_ELEMENTO_ID;
    --
    Lr_InfoInterfaceElemento C_GetInfoInterfaceElemento%ROWTYPE;
    Lr_InfoEnlace            C_GetInfoEnlace%ROWTYPE;
    Lv_NombreTipoElemento    DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE;
    Lv_IdElementoCliente     DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE;
  BEGIN
    IF C_GetInfoInterfaceElemento%ISOPEN THEN
      --
      CLOSE C_GetInfoInterfaceElemento;
      --
    END IF;
    --
    OPEN C_GetInfoInterfaceElemento(Pn_IdInterfaceElementoConector);
    --
    FETCH C_GetInfoInterfaceElemento
      INTO Lr_InfoInterfaceElemento;
    --
    CLOSE C_GetInfoInterfaceElemento;
    --
    IF Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO IS NOT NULL THEN
      --
      IF C_GetInfoEnlace%ISOPEN THEN
        --
        CLOSE C_GetInfoEnlace;
        --
      END IF;
      --
      OPEN C_GetInfoEnlace(Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO,
                           'Activo');
      --
      FETCH C_GetInfoEnlace
        INTO Lr_InfoEnlace;
      --
      CLOSE C_GetInfoEnlace;
      --
      IF Lr_InfoEnlace.INTERFACE_ELEMENTO_FIN_ID IS NOT NULL THEN
        --
        Lr_InfoInterfaceElemento := NULL;
        --
        IF C_GetInfoInterfaceElemento%ISOPEN THEN
          --
          CLOSE C_GetInfoInterfaceElemento;
          --
        END IF;
        --
        OPEN C_GetInfoInterfaceElemento(Lr_InfoEnlace.INTERFACE_ELEMENTO_FIN_ID);
        --
        FETCH C_GetInfoInterfaceElemento
          INTO Lr_InfoInterfaceElemento;
        --
        CLOSE C_GetInfoInterfaceElemento;
        --
        IF Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO IS NOT NULL THEN
          --
          IF C_GetNombreTipoElemento%ISOPEN THEN
            --
            CLOSE C_GetNombreTipoElemento;
            --
          END IF;
          --
          OPEN C_GetNombreTipoElemento(Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO);
          --
          FETCH C_GetNombreTipoElemento
            INTO Lv_NombreTipoElemento;
          --
          CLOSE C_GetNombreTipoElemento;
          --
          IF Lv_NombreTipoElemento LIKE (Pn_TipoElemento || '%') THEN
            --
            Lv_IdElementoCliente := Lr_InfoInterfaceElemento.ELEMENTO_ID;
            --
          END IF;
          IF Lv_NombreTipoElemento != Pn_TipoElemento THEN
            --
            Lv_IdElementoCliente := GET_ELEMENTO_CLI_X_TIPO_ELE(Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO,
                                                                Pn_TipoElemento);
            --
          END IF;
          --
        END IF;
        --
      END IF;
      --
    END IF;
    --
    RETURN Lv_IdElementoCliente;
    --
  END GET_ELEMENTO_CLI_X_TIPO_ELE;
  --
  FUNCTION F_GET_ID_ELEMENTO_PRINCIPAL(Fn_IdInterfaceElementoCliente IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
                                       Fv_TipoElemento               IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_ELEMENTO.ID_ELEMENTO%TYPE IS
    CURSOR C_GetIdElementoPrincipal(Cn_IdInterfaceElementoCliente DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
                                    Cv_TipoElemento               DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE) IS
      SELECT e.ID_ELEMENTO
        FROM info_elemento e
        JOIN (SELECT id_elemento, MAX(enlace) lvl
                FROM (SELECT (SELECT iie.elemento_id
                                FROM info_interface_elemento iie
                               WHERE iie.id_interface_elemento =
                                     interface_elemento_fin_id) AS id_elemento,
                             level AS enlace
                        FROM info_enlace
                       START WITH interface_elemento_ini_id =
                                  Cn_IdInterfaceElementoCliente
                      CONNECT BY interface_elemento_ini_id = PRIOR
                                 interface_elemento_fin_id
                       ORDER BY enlace DESC)
               GROUP BY id_elemento) ids
          ON ids.id_elemento = e.id_elemento
        JOIN admi_modelo_elemento me
          ON me.id_modelo_elemento = e.modelo_elemento_id
        JOIN admi_tipo_elemento te
          ON te.id_tipo_elemento = me.tipo_elemento_id
       WHERE te.nombre_tipo_elemento = Cv_TipoElemento
         AND ROWNUM <= 1;
    Fr_GetIdElementoPrincipal C_GetIdElementoPrincipal%ROWTYPE;
    Fn_IdElemento             DB_COMERCIAL.INFO_ELEMENTO.ID_ELEMENTO%TYPE := 0;
  BEGIN
    IF C_GetIdElementoPrincipal%ISOPEN THEN
      CLOSE C_GetIdElementoPrincipal;
    END IF;
    --
    OPEN C_GetIdElementoPrincipal(Fn_IdInterfaceElementoCliente,
                                  Fv_TipoElemento);
    FETCH C_GetIdElementoPrincipal
      INTO Fr_GetIdElementoPrincipal;
    CLOSE C_GetIdElementoPrincipal;
    --
    IF Fr_GetIdElementoPrincipal.ID_ELEMENTO IS NULL THEN
      Fn_IdElemento := 0;
    ELSE
      Fn_IdElemento := Fr_GetIdElementoPrincipal.ID_ELEMENTO;
    END IF;
    --
    RETURN Fn_IdElemento;
    --
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END F_GET_ID_ELEMENTO_PRINCIPAL;
  --

  FUNCTION F_GET_SOL_BY_SERVICIO_ID(Fn_IdServicio        IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Fv_DescTipoSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                    Fv_Estado            IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
    RETURN NUMBER IS
    -- C_GetSolicitud - Costo Query: 6
    CURSOR C_GetSolicitud(Cn_IdServicio        DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                          Cv_DescTipoSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                          Cv_Estado            DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE) IS
      SELECT COUNT(IDS.ID_DETALLE_SOLICITUD)
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
          ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
       WHERE IDS.SERVICIO_ID = Cn_IdServicio
         AND ats.descripcion_solicitud = Cv_DescTipoSolicitud
         AND ids.estado = Cv_Estado;
  
    Ln_TotalDetalles NUMBER := 0;
  
  BEGIN
    IF C_GetSolicitud%ISOPEN THEN
      CLOSE C_GetSolicitud;
    END IF;
  
    OPEN C_GetSolicitud(Fn_IdServicio, Fv_DescTipoSolicitud, Fv_Estado);
    --
    FETCH C_GetSolicitud
      INTO Ln_TotalDetalles;
    --
    RETURN Ln_TotalDetalles;
    --
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.GET_SOL_BY_SERVICIO_ID',
                                           'Error al consultar solicitud con servicioId: ' ||
                                           Fn_IdServicio,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END F_GET_SOL_BY_SERVICIO_ID;

  FUNCTION F_GET_PRODUCTO_BY_COD(Fv_CodigoProducto IN DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE)
    RETURN DB_COMERCIAL.ADMI_PRODUCTO%ROWTYPE IS
    -- C_GetProducto - Costo Query: 2
    CURSOR C_GetProducto(Cv_CodigoProducto DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE) IS
      SELECT AP.*
        FROM DB_COMERCIAL.ADMI_PRODUCTO AP
       WHERE AP.CODIGO_PRODUCTO = Cv_CodigoProducto;
  
    Lr_AdmiProducto DB_COMERCIAL.ADMI_PRODUCTO%ROWTYPE;
  
  BEGIN
    IF C_GetProducto%ISOPEN THEN
      CLOSE C_GetProducto;
    END IF;
  
    OPEN C_GetProducto(Fv_CodigoProducto);
    --
    FETCH C_GetProducto
      INTO Lr_AdmiProducto;
    --
    RETURN Lr_AdmiProducto;
    --
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_PRODUCTO_BY_COD',
                                           'Error al consultar productoId por codigo: ' ||
                                           Fv_CodigoProducto,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END F_GET_PRODUCTO_BY_COD;

  FUNCTION F_GET_SOL_PEND_BY_SER_ID(Fv_DescripcionTipoSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                    Fn_IdServicio               IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN SYS_REFCURSOR IS
    C_GetSolicitudes SYS_REFCURSOR;
    -- Costo Query: 4
  BEGIN
    OPEN C_GetSolicitudes FOR
      SELECT IDS.*
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        JOIN DB_COMERCIAL.INFO_SERVICIO ISER
          ON ISER.ID_SERVICIO = IDS.SERVICIO_ID
        JOIN DB_COMERCIAL.INFO_PUNTO IPTO
          ON IPTO.ID_PUNTO = ISER.PUNTO_ID
        JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
          ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
       WHERE ATS.DESCRIPCION_SOLICITUD = Fv_DescripcionTipoSolicitud
         AND IDS.ESTADO = 'Pendiente'
         AND IDS.SERVICIO_ID = Fn_IdServicio;
  
    RETURN C_GetSolicitudes;
  
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_SOL_PEND_BY_SER_ID',
                                           'Error al consultar solicitudes con servicioId: ' ||
                                           Fn_IdServicio,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END F_GET_SOL_PEND_BY_SER_ID;

  FUNCTION F_GET_COD_BY_PREFIJO_EMP(Fv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    RETURN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE IS
    CURSOR C_GetEmpresaCod(Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE) IS
      SELECT IEG.COD_EMPRESA
        FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
       WHERE IEG.PREFIJO = Cv_PrefijoEmpresa
         AND IEG.ESTADO = 'Activo';
  
    Lv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
  
  BEGIN
    IF C_GetEmpresaCod%ISOPEN THEN
      CLOSE C_GetEmpresaCod;
    END IF;
  
    OPEN C_GetEmpresaCod(Fv_PrefijoEmpresa);
    --
    FETCH C_GetEmpresaCod
      INTO Lv_EmpresaCod;
    --
    RETURN Lv_EmpresaCod;
    --
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP',
                                           'Error al consultar empresaCod por prefijo: ',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END F_GET_COD_BY_PREFIJO_EMP;

  PROCEDURE P_GET_PERSONA_X_LOGIN_ID(Pv_Login                 IN VARCHAR2,
                                     Pv_IdentificacionCliente IN VARCHAR2,
                                     Pv_MensajeSalida         OUT VARCHAR2) IS
    CURSOR C_VERIFICA IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_PERSONA
       WHERE LOGIN = Pv_Login
         AND IDENTIFICACION_CLIENTE = Pv_IdentificacionCliente;
  
    Ln_Existencia    Number := 0;
    Lv_MensajeSalida Varchar2(15) := 'NoExiste';
  
  BEGIN
  
    IF C_VERIFICA%ISOPEN THEN
      CLOSE C_VERIFICA;
    END IF;
    OPEN C_VERIFICA;
    FETCH C_VERIFICA
      INTO Ln_Existencia;
    CLOSE C_VERIFICA;
  
    IF Ln_Existencia > 0 THEN
      Lv_MensajeSalida := 'Existe';
    END IF;
    Pv_MensajeSalida := Lv_MensajeSalida;
  
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_PERSONA_X_LOGIN_ID',
                                           'Error al consultar persona por login e identifiacion: ',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_GET_PERSONA_X_LOGIN_ID;

  FUNCTION F_GET_JEFE_BY_ID_PERSONA(Pv_idPersona IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
    RETURN NUMBER IS
    CURSOR C_getJefe(Cv_idPersona NUMBER) IS
      SELECT ee.id_jefe, ee.no_cia_jefe
        FROM info_persona p, NAF47_TNET.V_EMPLEADOS_EMPRESAS ee
       WHERE ee.cedula = p.IDENTIFICACION_CLIENTE
          AND ee.estado = 'A'
         AND p.id_persona = Cv_idPersona;
    CURSOR C_getIdPersona(Cv_idPersona NUMBER, Cv_cia NUMBER) IS
      SELECT P.ID_PERSONA
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS ee, info_persona p
       WHERE ee.no_emple = Cv_idPersona
         AND ee.no_cia = Cv_cia
         AND ee.cedula = p.IDENTIFICACION_CLIENTE;
    Ln_jefe         NUMBER := 0;
    Ln_cia_jefe     NUMBER := 0;
    Ln_persona_jefe NUMBER := 0;
  BEGIN
    OPEN C_getJefe(Pv_idPersona);
    FETCH C_getJefe
      INTO Ln_jefe, Ln_cia_jefe;
    CLOSE C_getJefe;
    IF Ln_cia_jefe > 0 AND Ln_jefe > 0 THEN
      OPEN C_getIdPersona(Ln_jefe, Ln_cia_jefe);
      FETCH C_getIdPersona
        INTO Ln_persona_jefe;
      CLOSE C_getIdPersona;
    END IF;
    RETURN Ln_persona_jefe;
  END;

  PROCEDURE P_GET_SSID_FOX(Pv_UsuarioFox    IN VARCHAR2,
                           Pv_PasswordFox   IN VARCHAR2,
                           Pv_KeyEncript    IN VARCHAR2,
                           Pv_SsidFox       OUT VARCHAR2,
                           Pv_CodPais       OUT VARCHAR2,
                           Pv_MensajeSalida OUT VARCHAR2) IS
  
    CURSOR C_CODIGO_EMPRESA(Cn_IdServicio Number) IS
      SELECT EMPRESA_ID
        FROM DB_COMERCIAL.INFO_SERVICIO            ISE,
             DB_COMERCIAL.INFO_PUNTO               IPU,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPE,
             DB_COMERCIAL.INFO_OFICINA_GRUPO       IOG
       WHERE ISE.PUNTO_ID = IPU.ID_PUNTO
         AND IPU.PERSONA_EMPRESA_ROL_ID = IPE.ID_PERSONA_ROL
         AND IPE.OFICINA_ID = IOG.ID_OFICINA
         AND ISE.ID_SERVICIO = Cn_IdServicio;
  
    CURSOR C_COD_PAIS(Cv_CodEmpresa Varchar2) IS
      SELECT DET.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
       WHERE CAB.ID_PARAMETRO = DET.PARAMETRO_ID
         AND DET.DESCRIPCION = 'CODIGO_DE_PAIS'
         AND CAB.ESTADO = 'Activo'
         AND DET.ESTADO = 'Activo'
         AND DET.EMPRESA_COD = Cv_CodEmpresa;
  
    Lv_UsuarioFox         Varchar2(100) := 'USUARIO_FOX';
    Lv_PasswordFox        Varchar2(100) := 'PASSWORD_FOX';
    Lv_ValorUsuario       Varchar2(100);
    Lv_ServicioIdUsuario  Varchar2(100);
    Lv_MensajeSalida      Varchar2(500);
    Lv_ValorPassword      Varchar2(100);
    Lv_ServicioIdPassword Varchar2(100);
    Lv_PassEncriptado     Varchar2(4000);
    Lv_CodEmpresa         Varchar2(10);
    Lv_CodPais            Varchar2(10);
    Lv_SubscriberId       Varchar2(100);
  
    Le_Error Exception;
  
  BEGIN
  
    P_VALIDA_CARACTERISTICA(Lv_UsuarioFox,
                            Pv_UsuarioFox,
                            Lv_ServicioIdUsuario,
                            Lv_MensajeSalida);
    IF Lv_MensajeSalida = 'Error' THEN
      Lv_MensajeSalida := ' Error en P_VALIDA_CARACTERISTICA Usuario' ||
                          Lv_MensajeSalida;
      Raise Le_Error;
    ELSE
      IF Lv_ServicioIdUsuario IS NOT NULL THEN
        DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR(Pv_PasswordFox,
                                                   Pv_KeyEncript,
                                                   Lv_PassEncriptado);
        P_VALIDA_CARACTERISTICA(Lv_PasswordFox,
                                Lv_PassEncriptado,
                                Lv_ServicioIdPassword,
                                Lv_MensajeSalida);
        IF Lv_MensajeSalida = 'Error' THEN
          Lv_MensajeSalida := ' Error en P_VALIDA_CARACTERISTICA Password' ||
                              Lv_MensajeSalida;
          Raise Le_Error;
        ELSE
          IF Lv_ServicioIdUsuario = Lv_ServicioIdPassword THEN
            Lv_SubscriberId := Lv_ServicioIdUsuario;
            IF C_CODIGO_EMPRESA%ISOPEN THEN
              CLOSE C_CODIGO_EMPRESA;
            END IF;
            OPEN C_CODIGO_EMPRESA(Lv_SubscriberId);
            FETCH C_CODIGO_EMPRESA
              INTO Lv_CodEmpresa;
            IF C_CODIGO_EMPRESA%NOTFOUND THEN
              Lv_MensajeSalida := 'No se encontro empresa para servicio: ' ||
                                  Lv_SubscriberId;
              Raise Le_Error;
            ELSE
              IF C_COD_PAIS%ISOPEN THEN
                CLOSE C_COD_PAIS;
              END IF;
              OPEN C_COD_PAIS(Lv_CodEmpresa);
              FETCH C_COD_PAIS
                INTO Lv_CodPais;
              IF C_COD_PAIS%NOTFOUND THEN
                Lv_MensajeSalida := 'No se encontro pais para empresa: ' ||
                                    Lv_CodEmpresa;
                Raise Le_Error;
              ELSE
                Pv_MensajeSalida := 'OK';
                Pv_SsidFox       := Lv_SubscriberId;
                Pv_CodPais       := Lv_CodPais;
              END IF;
              CLOSE C_COD_PAIS;
            
            END IF;
          
            CLOSE C_CODIGO_EMPRESA;
          ELSE
            Lv_MensajeSalida := ' Error Password incorrecto';
            Raise Le_Error;
          END IF;
        END IF;
      ELSE
        Lv_MensajeSalida := ' Error Usuario incorrecto';
        Raise Le_Error;
      END IF;
    END IF;
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SSID_FOX',
                                           Lv_MensajeSalida,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SSID_FOX',
                                           SQLCODE || ' ' || SQLERRM,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_GET_SSID_FOX;

  PROCEDURE P_VALIDA_CARACTERISTICA(Pv_DescrCaracteristica IN VARCHAR2,
                                    Pv_Valor               IN VARCHAR2,
                                    Pv_ServicioId          OUT VARCHAR2,
                                    Pv_MensajeSalida       OUT VARCHAR2) IS
  
    CURSOR C_CARACTERISTICA(Cv_DescriCaracteristica Varchar2) IS
      SELECT ID_CARACTERISTICA
        FROM ADMI_CARACTERISTICA
       WHERE DESCRIPCION_CARACTERISTICA = Cv_DescriCaracteristica
         AND ESTADO = 'Activo';
  
    CURSOR C_ADMI_PROD_CARACTERISTICA(Cv_CaracteristicaId Varchar2) IS
      SELECT ID_PRODUCTO_CARACTERISITICA
        FROM ADMI_PRODUCTO_CARACTERISTICA
       WHERE CARACTERISTICA_ID = Cv_CaracteristicaId
         AND ESTADO = 'Activo';
  
    CURSOR C_INFO_SERV_PROD_CARACT(Cv_ProdCaracId Varchar2,
                                   Cv_Valor       Varchar2) IS
      SELECT SERVICIO_ID
        FROM INFO_SERVICIO_PROD_CARACT
       WHERE PRODUCTO_CARACTERISITICA_ID = Cv_ProdCaracId
         AND VALOR = Cv_Valor
         AND ESTADO = 'Activo';
  
    Ln_ServicioId           INFO_SERVICIO_PROD_CARACT.SERVICIO_ID%TYPE;
    Ln_IdCaracateristica    ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdProCaracateristica ADMI_PRODUCTO_CARACTERISTICA.ID_PRODUCTO_CARACTERISITICA%TYPE;
    Lr_InfoServProdCaract   C_INFO_SERV_PROD_CARACT%ROWTYPE;
    Lv_MensajeSalida        Varchar2(500);
  
    Le_Error Exception;
  
  BEGIN
  
    IF C_CARACTERISTICA%ISOPEN THEN
      CLOSE C_CARACTERISTICA;
    END IF;
  
    OPEN C_CARACTERISTICA(Pv_DescrCaracteristica);
    FETCH C_CARACTERISTICA
      INTO Ln_IdCaracateristica;
    IF C_CARACTERISTICA%NOTFOUND THEN
      Lv_MensajeSalida := ' Error en C_CARACTERISTICA';
      Raise Le_Error;
    ELSE
      IF C_ADMI_PROD_CARACTERISTICA%ISOPEN THEN
        CLOSE C_ADMI_PROD_CARACTERISTICA;
      END IF;
      OPEN C_ADMI_PROD_CARACTERISTICA(Ln_IdCaracateristica);
      FETCH C_ADMI_PROD_CARACTERISTICA
        INTO Ln_IdProCaracateristica;
      IF C_ADMI_PROD_CARACTERISTICA%NOTFOUND THEN
        Lv_MensajeSalida := ' Error en C_ADMI_PROD_CARACTERISTICA';
        Raise Le_Error;
      ELSE
        IF C_INFO_SERV_PROD_CARACT%ISOPEN THEN
          CLOSE C_INFO_SERV_PROD_CARACT;
        END IF;
        OPEN C_INFO_SERV_PROD_CARACT(Ln_IdProCaracateristica, Pv_Valor);
        FETCH C_INFO_SERV_PROD_CARACT
          INTO Lr_InfoServProdCaract;
        IF C_INFO_SERV_PROD_CARACT%NOTFOUND THEN
          Lv_MensajeSalida := ' Error en C_INFO_SERV_PROD_CARACT';
          Raise Le_Error;
        ELSE
          Pv_ServicioId := Lr_InfoServProdCaract.Servicio_Id;
        END IF;
        CLOSE C_INFO_SERV_PROD_CARACT;
      END IF;
      CLOSE C_ADMI_PROD_CARACTERISTICA;
    END IF;
    CLOSE C_CARACTERISTICA;
  
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_VALIDA_CARACTERISTICA',
                                           Lv_MensajeSalida,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_VALIDA_CARACTERISTICA',
                                           'Error al consultar persona por login e identifiacion: ',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_VALIDA_CARACTERISTICA;

  PROCEDURE P_VERIFICA_ESTADO_SERVICIO(Pn_IdSpcSuscriber    IN NUMBER,
                                       Pv_SubscriberId      IN VARCHAR2,
                                       Pv_CountryCode       IN VARCHAR2,
                                       Pv_CodigoUrn         IN VARCHAR2,
                                       Pv_CodigoSalida      OUT VARCHAR2,
                                       Pv_MensajeSalida     OUT VARCHAR2,
                                       Pv_strCodigoUrn      IN VARCHAR2, 
                                       Pv_strSsid           IN VARCHAR2)
  IS
  
    CURSOR C_PARAMETROS(Cv_Valor1      Varchar2,
                        Cv_Descripcion Varchar2,
                        Cv_Estado      Varchar2) IS
      SELECT DET.EMPRESA_COD
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
       WHERE CAB.ID_PARAMETRO = DET.PARAMETRO_ID
         AND DET.DESCRIPCION = Cv_Descripcion
         AND CAB.ESTADO = Cv_Estado
         AND DET.ESTADO = Cv_Estado
         AND DET.VALOR1 = Cv_Valor1;
  
    CURSOR C_CARACTERISTICA(Cn_SSid        Number,
                            Cv_Descripcion Varchar2,
                            Cv_Estado      Varchar2) IS
      SELECT ISPC.SERVICIO_ID
        FROM ADMI_CARACTERISTICA          ACA,
             ADMI_PRODUCTO_CARACTERISTICA APC,
             INFO_SERVICIO_PROD_CARACT    ISPC
       WHERE ACA.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
         AND APC.ID_PRODUCTO_CARACTERISITICA =
             ISPC.PRODUCTO_CARACTERISITICA_ID
         AND ACA.DESCRIPCION_CARACTERISTICA = Cv_Descripcion
         AND ISPC.VALOR = Cn_SSid
         AND ACA.ESTADO = Cv_Estado
         AND APC.ESTADO = Cv_Estado
         AND ISPC.ESTADO = Cv_Estado;
  
    CURSOR C_SERVICIO(Cn_IdServicio Number, Cv_Estado Varchar2) IS
      SELECT 'X'
        FROM DB_COMERCIAL.INFO_SERVICIO            ISE,
             DB_COMERCIAL.INFO_PUNTO               IPU,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPE,
             DB_COMERCIAL.INFO_OFICINA_GRUPO       IOG
       WHERE ISE.PUNTO_ID = IPU.ID_PUNTO
         AND IPU.PERSONA_EMPRESA_ROL_ID = IPE.ID_PERSONA_ROL
         AND IPE.OFICINA_ID = IOG.ID_OFICINA
         AND ISE.ID_SERVICIO = Cn_IdServicio
         AND ISE.ESTADO = Cv_Estado;

    Lv_EmpresaCod    DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE;
    Lv_EmpresaUrn    DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE;
    Lv_Existe        Varchar2(1);
    Lv_CodigoPais    Varchar2(50) := 'CODIGO_DE_PAIS';
    Lv_CodigoUrn     Varchar2(50) := Pv_strCodigoUrn;
    Lv_CodigoSsIdFox Varchar2(50) := Pv_strSsid;
    Lv_Estado        Varchar2(50) := 'Activo';
    Ln_IdServicio    DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    
    Le_Error Exception;

    Lv_NombreParamsWsProductosTv    VARCHAR2(100) := 'PARAMETROS_WS_PRODUCTOS_TV';
    Lv_VerifAutorizacion            VARCHAR2(100) := 'VERIFICACIONES_AUTORIZACION';
    Lv_EstadosServiciosPermitidos   VARCHAR2(100) := 'ESTADOS_SERVICIOS_PERMITIDOS';
    Lv_VerificaSaldoPendiente       VARCHAR2(100) := 'VERIFICA_SALDO_PENDIENTE';
    Lv_VerificaFinCicloFacturacion  VARCHAR2(100) := 'VERIFICA_FIN_CICLO_FACTURACION';
    Lv_CicloFacturacion             VARCHAR2(100) := 'CICLO_FACTURACION';
    Lv_EstadoCancel                 VARCHAR2(6)   := 'Cancel';
    Lv_FechaMinimaSuscripcion       VARCHAR2(100) := 'FECHA_MINIMA_SUSCRIPCION';
    Lv_FechaActivacion              VARCHAR2(100) := 'FECHA_ACTIVACION';
    Lv_AccionHistorial              VARCHAR2(100) := 'confirmarServicio';
    Lv_AccionCancel                 VARCHAR2(100) := 'cancelarCliente';

    CURSOR Lc_GetInfoClienteXSpcSuscribId(Cn_IdSpcSuscriberId DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT%TYPE)
    IS
      SELECT DISTINCT SERVICIO.ID_SERVICIO, SERVICIO.ESTADO AS ESTADO_SERVICIO, PER.ID_PERSONA_ROL, PER.ESTADO AS ESTADO_PER, 
        PUNTO_FACTURACION.ID_PUNTO, PROD.NOMBRE_TECNICO AS NOMBRE_TECNICO_PROD
        FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC_SUSCRIBER_ID
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
        ON SERVICIO.ID_SERVICIO = SPC_SUSCRIBER_ID.SERVICIO_ID
        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
        ON PROD.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO_FACTURACION
        ON PUNTO_FACTURACION.ID_PUNTO = SERVICIO.PUNTO_FACTURACION_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
        ON PER.ID_PERSONA_ROL = PUNTO_FACTURACION.PERSONA_EMPRESA_ROL_ID
       WHERE SPC_SUSCRIBER_ID.ID_SERVICIO_PROD_CARACT = Cn_IdSpcSuscriberId;

    CURSOR Lc_VerificacionesAutorizacion(   Cv_Valor1   VARCHAR2,
                                            Cv_Valor2   VARCHAR2,
                                            Cv_Valor3   VARCHAR2,
                                            Cv_Valor4   VARCHAR2)
    IS
      SELECT DET.ID_PARAMETRO_DET, DET.VALOR5, DET.VALOR6, DET.OBSERVACION
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
        ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
        WHERE CAB.NOMBRE_PARAMETRO = Lv_NombreParamsWsProductosTv
        AND DET.VALOR1 = Cv_Valor1
        AND DET.VALOR2 = Cv_Valor2
        AND DET.VALOR3 = Cv_Valor3
        AND DET.VALOR4 = Cv_Valor4
        AND CAB.ESTADO = Lv_Estado
        AND DET.ESTADO = Lv_Estado
        AND ROWNUM = 1;

    CURSOR Lc_GetInfoCicloFacturacion(Cn_IdPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
      SELECT TO_CHAR(CICLO_FACTURACION.FE_INICIO,'DD') AS DIA_INICIO_CICLO_FACTURACION,
        TO_CHAR(CICLO_FACTURACION.FE_FIN,'DD') AS DIA_FIN_CICLO_FACTURACION
        FROM DB_FINANCIERO.ADMI_CICLO CICLO_FACTURACION
        WHERE CICLO_FACTURACION.ID_CICLO  =
          (SELECT MAX(PER_CARACT.VALOR)
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC PER_CARACT
            INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACTERISTICA
            ON CARACTERISTICA.ID_CARACTERISTICA = PER_CARACT.CARACTERISTICA_ID 
          WHERE PER_CARACT.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaEmpresaRol
          AND PER_CARACT.ESTADO = Lv_Estado
          AND CARACTERISTICA.DESCRIPCION_CARACTERISTICA = Lv_CicloFacturacion
          );

    CURSOR Lc_GetFechaCarctServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, Cn_DescripCarac VARCHAR2)
    IS
        SELECT 
         TO_CHAR(TO_DATE(ISPC.VALOR, 'YYYY-MM-DD HH24:MI:SS'), 'DD') AS DIA_FECHA_CANCELACION,
         TO_CHAR(TO_DATE(ISPC.VALOR, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM') AS ANIO_MES_FECHA_CANCELACION,
         TO_CHAR(TO_DATE(ISPC.VALOR, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD') AS FECHA_COMPLETA
        FROM DB_COMERCIAL.admi_caracteristica AC
        LEFT JOIN DB_COMERCIAL.admi_producto_caracteristica APC ON apc.caracteristica_id = ac.id_caracteristica
        LEFT JOIN DB_COMERCIAL.info_servicio_prod_caract ISPC ON ispc.producto_caracterisitica_id = apc.id_producto_caracterisitica
        LEFT JOIN DB_COMERCIAL.info_servicio IS1 ON is1.id_servicio = ispc.servicio_id
        WHERE is1.estado= Lv_EstadoCancel
        and IS1.ID_SERVICIO = Cn_IdServicio
        AND ac.descripcion_caracteristica= Cn_DescripCarac;

    CURSOR Lc_GetFechaCancelacionServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
        SELECT 
            TO_CHAR(MAX(ish.fe_creacion),'DD') AS DIA_FECHA_CANCEL,
            TO_CHAR(MAX(ish.fe_creacion),'YYYY-MM') AS ANIO_MES_FECHA_CANCEL
        FROM  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
            JOIN  DB_COMERCIAL.INFO_SERVICIO ISER ON ISER.ID_SERVICIO = ISH.SERVICIO_ID
		    WHERE ISER.ID_SERVICIO = Cn_IdServicio
            AND   ISH.ACCION      = Lv_AccionCancel;

    Lr_GetInfoClienteXSpcSuscribId  Lc_GetInfoClienteXSpcSuscribId%ROWTYPE;
    Lr_VerificacionesAutorizacion   Lc_VerificacionesAutorizacion%ROWTYPE;
    Ln_SaldoPorPunto                DB_COMERCIAL.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE;
    Lr_GetInfoCicloFacturacion      Lc_GetInfoCicloFacturacion%ROWTYPE;
    Lr_GetFechaFinalCaractServicio  Lc_GetFechaCarctServicio%ROWTYPE;
    Lr_GetFechaActivacionServicio   Lc_GetFechaCarctServicio%ROWTYPE;
    Lr_GetFechaCancelServicioHist   Lc_GetFechaCancelacionServicio%ROWTYPE;
    Lv_DiaInicioCicloFacturacion    VARCHAR2(3);
    Lv_DiaFinCicloFacturacion       VARCHAR2(3);
    Lv_DiaFechaCancelacion          VARCHAR2(3);
    Lv_AnioMesFechaCancelacion      VARCHAR2(7);
    Lv_DiaFechaCancelHist           VARCHAR2(3);
    Lv_AnioMesFechaCancelHist       VARCHAR2(8);
    Lv_FechaFinSuscripcion          VARCHAR2(10);
    Lv_AnioMesDiaFechaActivacion    VARCHAR2(10);
    Lv_FechaInicioPeriodoPermitido  VARCHAR2(10);
    Lv_FechaFinPeriodoPermitido     VARCHAR2(10);
  BEGIN
  
    IF C_PARAMETROS%ISOPEN THEN
      CLOSE C_PARAMETROS;
    END IF;
    OPEN C_PARAMETROS(Pv_CountryCode, Lv_CodigoPais, Lv_Estado);
    FETCH C_PARAMETROS
      INTO Lv_EmpresaCod;
    IF C_PARAMETROS%NOTFOUND THEN
      Pv_CodigoSalida  := '02';
      Pv_MensajeSalida := 'Codigo de pais invalido';
      Raise Le_Error;
    END IF;
    CLOSE C_PARAMETROS;
  
    IF C_PARAMETROS%ISOPEN THEN
      CLOSE C_PARAMETROS;
    END IF;

    IF Pn_IdSpcSuscriber IS NOT NULL THEN
      IF Lc_GetInfoClienteXSpcSuscribId%ISOPEN THEN
        CLOSE Lc_GetInfoClienteXSpcSuscribId;
      END IF;
      OPEN Lc_GetInfoClienteXSpcSuscribId(Pn_IdSpcSuscriber);
      FETCH Lc_GetInfoClienteXSpcSuscribId
      INTO Lr_GetInfoClienteXSpcSuscribId;

      IF Lc_GetInfoClienteXSpcSuscribId%NOTFOUND THEN
        Pv_CodigoSalida  := '01';
        Pv_MensajeSalida := 'Usuario o Contrasena Incorrectos';
        Raise Le_Error;
      END IF;

      IF Lc_VerificacionesAutorizacion%ISOPEN THEN
        CLOSE Lc_VerificacionesAutorizacion;
      END IF;
      OPEN Lc_VerificacionesAutorizacion(   Lv_VerifAutorizacion,
                                            Lr_GetInfoClienteXSpcSuscribId.NOMBRE_TECNICO_PROD,
                                            Lv_EstadosServiciosPermitidos,
                                            Lr_GetInfoClienteXSpcSuscribId.ESTADO_SERVICIO);
      FETCH Lc_VerificacionesAutorizacion
      INTO Lr_VerificacionesAutorizacion;

      IF Lc_VerificacionesAutorizacion%NOTFOUND THEN
        Pv_CodigoSalida  := '01';
        Pv_MensajeSalida := 'No se puede acceder al servicio';
        Raise Le_Error;
      END IF;

      IF Lr_VerificacionesAutorizacion.VALOR5 = 'OK' THEN 
          Pv_CodigoSalida := 'OK';
      ELSIF Lr_VerificacionesAutorizacion.VALOR5 = 'ERROR' THEN
        Pv_CodigoSalida  := Lr_VerificacionesAutorizacion.VALOR6;
        Pv_MensajeSalida := Lr_VerificacionesAutorizacion.OBSERVACION;
        Raise Le_Error;
      ELSE
        Lr_VerificacionesAutorizacion := NULL;
        IF Lc_VerificacionesAutorizacion%ISOPEN THEN
          CLOSE Lc_VerificacionesAutorizacion;
        END IF;
        OPEN Lc_VerificacionesAutorizacion( Lv_VerifAutorizacion,
                                            Lr_GetInfoClienteXSpcSuscribId.NOMBRE_TECNICO_PROD,
                                            Lv_VerificaSaldoPendiente,
                                            Lr_GetInfoClienteXSpcSuscribId.ESTADO_SERVICIO);
        FETCH Lc_VerificacionesAutorizacion
        INTO Lr_VerificacionesAutorizacion;
        IF Lr_VerificacionesAutorizacion.ID_PARAMETRO_DET IS NOT NULL THEN
          Ln_SaldoPorPunto:=TRUNC(NVL(DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_SALDO_CLIENTE_BY_PUNTO(Lr_GetInfoClienteXSpcSuscribId.ID_PUNTO), 0),2);
          IF Ln_SaldoPorPunto > 0 THEN
            Pv_CodigoSalida  := Lr_VerificacionesAutorizacion.VALOR6;
            Pv_MensajeSalida := Lr_VerificacionesAutorizacion.OBSERVACION;
            Raise Le_Error;
          END IF;
        END IF;


        Lr_VerificacionesAutorizacion := NULL;
        IF Lc_VerificacionesAutorizacion%ISOPEN THEN
          CLOSE Lc_VerificacionesAutorizacion;
        END IF;
        OPEN Lc_VerificacionesAutorizacion( Lv_VerifAutorizacion,
                                            Lr_GetInfoClienteXSpcSuscribId.NOMBRE_TECNICO_PROD,
                                            Lv_VerificaFinCicloFacturacion,
                                            Lr_GetInfoClienteXSpcSuscribId.ESTADO_SERVICIO);
        FETCH Lc_VerificacionesAutorizacion
        INTO Lr_VerificacionesAutorizacion;
        IF Lr_VerificacionesAutorizacion.ID_PARAMETRO_DET IS NOT NULL THEN

          IF Lc_GetInfoCicloFacturacion%ISOPEN THEN
            CLOSE Lc_GetInfoCicloFacturacion;
          END IF;
          OPEN Lc_GetInfoCicloFacturacion(Lr_GetInfoClienteXSpcSuscribId.ID_PERSONA_ROL);
          FETCH Lc_GetInfoCicloFacturacion
          INTO Lr_GetInfoCicloFacturacion;

          IF Lc_GetInfoCicloFacturacion%NOTFOUND THEN
            Pv_CodigoSalida  := '01';
            Pv_MensajeSalida := 'No se puede validar el acceso al servicio';
            Raise Le_Error;
          END IF;

          IF Lc_GetFechaCarctServicio%ISOPEN THEN
            CLOSE Lc_GetFechaCarctServicio;
          END IF;
          OPEN Lc_GetFechaCarctServicio(Lr_GetInfoClienteXSpcSuscribId.ID_SERVICIO, Lv_FechaMinimaSuscripcion);
          FETCH Lc_GetFechaCarctServicio
          INTO Lr_GetFechaFinalCaractServicio;

          IF Lc_GetFechaCarctServicio%NOTFOUND THEN
            Pv_CodigoSalida  := '01';
            Pv_MensajeSalida := 'No se puede validar la fecha de cancelaci閿熺单 del servicio';
            Raise Le_Error;
          END IF;

          Lv_DiaInicioCicloFacturacion  := Lr_GetInfoCicloFacturacion.DIA_INICIO_CICLO_FACTURACION;
          Lv_DiaFinCicloFacturacion     := Lr_GetInfoCicloFacturacion.DIA_FIN_CICLO_FACTURACION;
          
          Lv_DiaFechaCancelacion        := Lr_GetFechaFinalCaractServicio.DIA_FECHA_CANCELACION;
          Lv_AnioMesFechaCancelacion    := Lr_GetFechaFinalCaractServicio.ANIO_MES_FECHA_CANCELACION;
          Lv_FechaFinSuscripcion        := Lr_GetFechaFinalCaractServicio.FECHA_COMPLETA;
          
          IF Lc_GetFechaCarctServicio%ISOPEN THEN
            CLOSE Lc_GetFechaCarctServicio;
          END IF;
          OPEN Lc_GetFechaCarctServicio(Lr_GetInfoClienteXSpcSuscribId.ID_SERVICIO, Lv_FechaActivacion);
          FETCH Lc_GetFechaCarctServicio
          INTO Lr_GetFechaActivacionServicio;

          IF Lc_GetFechaCarctServicio%NOTFOUND THEN
            Pv_CodigoSalida  := '01';
            Pv_MensajeSalida := 'No se puede validar la fecha de activaci閿熺单 del servicio';
            Raise Le_Error;
          END IF;
          
          Lv_AnioMesDiaFechaActivacion  := Lr_GetFechaActivacionServicio.FECHA_COMPLETA;
          
          IF Lc_GetFechaCancelacionServicio%ISOPEN THEN
            CLOSE Lc_GetFechaCancelacionServicio;
          END IF;
          OPEN Lc_GetFechaCancelacionServicio(Lr_GetInfoClienteXSpcSuscribId.ID_SERVICIO);
          FETCH Lc_GetFechaCancelacionServicio
          INTO Lr_GetFechaCancelServicioHist;
          
          Lv_DiaFechaCancelHist        := Lr_GetFechaCancelServicioHist.DIA_FECHA_CANCEL;
          Lv_AnioMesFechaCancelHist    := Lr_GetFechaCancelServicioHist.ANIO_MES_FECHA_CANCEL;
          
          
          IF TRUNC(SYSDATE) < TO_DATE(Lv_FechaFinSuscripcion, 'YYYY-MM-DD') THEN
              IF TO_NUMBER(Lv_DiaInicioCicloFacturacion,'99999999990D99') <= TO_NUMBER(Lv_DiaFechaCancelacion,'99999999990D99') THEN
                Lv_FechaInicioPeriodoPermitido := Lv_AnioMesFechaCancelacion || '-' || Lv_DiaInicioCicloFacturacion;
              ELSE
                Lv_FechaInicioPeriodoPermitido := TO_CHAR(ADD_MONTHS(TO_DATE(Lv_AnioMesFechaCancelacion,'YYYY-MM'),-1),'YYYY-MM')
                                                  || '-' || Lv_DiaInicioCicloFacturacion;
              END IF;
          ELSE
              IF TO_NUMBER(Lv_DiaInicioCicloFacturacion,'99999999990D99') <= TO_NUMBER(Lv_DiaFechaCancelHist,'99999999990D99') THEN
                Lv_FechaInicioPeriodoPermitido := Lv_AnioMesFechaCancelHist || '-' || Lv_DiaInicioCicloFacturacion;
              ELSE
                Lv_FechaInicioPeriodoPermitido := TO_CHAR(ADD_MONTHS(TO_DATE(Lv_AnioMesFechaCancelHist,'YYYY-MM'),-1),'YYYY-MM')
                                                  || '-' || Lv_DiaInicioCicloFacturacion;
              END IF;
          
          END IF;
          Lv_FechaFinPeriodoPermitido := TO_CHAR(ADD_MONTHS(TO_DATE(Lv_FechaInicioPeriodoPermitido,'YYYY-MM-DD'),+1)-1,'YYYY-MM-DD');

          IF TRUNC(SYSDATE) BETWEEN TO_DATE(Lv_AnioMesDiaFechaActivacion, 'YYYY-MM-DD') AND TO_DATE(Lv_FechaFinPeriodoPermitido, 'YYYY-MM-DD') THEN
            Pv_CodigoSalida := 'OK';
          ELSE
            Pv_CodigoSalida  := Lr_VerificacionesAutorizacion.VALOR6;
            Pv_MensajeSalida := Lr_VerificacionesAutorizacion.OBSERVACION;
            Raise Le_Error;
          END IF;
        END IF;
      END IF;
    ELSE
      OPEN C_PARAMETROS(Pv_CodigoUrn, Lv_CodigoUrn, Lv_Estado);
      FETCH C_PARAMETROS
        INTO Lv_EmpresaUrn;
      IF C_PARAMETROS%NOTFOUND THEN
        Pv_CodigoSalida  := '03';
        Pv_MensajeSalida := 'Codigo de canal invalido';
        Raise Le_Error;
      END IF;
      CLOSE C_PARAMETROS;
  
      IF C_CARACTERISTICA%ISOPEN THEN
        CLOSE C_CARACTERISTICA;
      END IF;
  
      OPEN C_CARACTERISTICA(Pv_SubscriberId, Lv_CodigoSsIdFox, Lv_Estado);
      FETCH C_CARACTERISTICA
        INTO Ln_IdServicio;
      IF C_CARACTERISTICA%NOTFOUND THEN
        Pv_CodigoSalida  := '01';
        Pv_MensajeSalida := 'Usuario o Contrasena Incorrectos';
      ELSE
        IF C_SERVICIO%ISOPEN THEN
          CLOSE C_SERVICIO;
        END IF;
    
        OPEN C_SERVICIO(Ln_IdServicio, Lv_Estado);
        FETCH C_SERVICIO
          INTO Lv_Existe;
        IF C_SERVICIO%NOTFOUND THEN
          Pv_CodigoSalida  := '01';
          Pv_MensajeSalida := 'No se puede acceder al servicio porque el Internet esta In-Corte';
          Raise Le_Error;
        ELSE
          IF NVL(Lv_Existe, '@') = 'X' THEN
            Pv_CodigoSalida := 'OK';
          ELSE
            Pv_CodigoSalida  := '01';
            Pv_MensajeSalida := 'Usuario o Contrasena Incorrectos';
            Raise Le_Error;
          END IF;
        END IF;
        CLOSE C_SERVICIO;
      END IF;
      CLOSE C_CARACTERISTICA;
    END IF;
  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_VALIDA_CARACTERISTICA',
                                           Pv_MensajeSalida,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_VALIDA_CARACTERISTICA',
                                           'Error al consultar persona por login e identifiacion: ',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_VERIFICA_ESTADO_SERVICIO;

  PROCEDURE P_GET_SERVICIOS_POR_RECHAZAR(
                                          Pv_CodigoEmpresa        IN VARCHAR2,
                                          Pv_EstadoActualServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                          Pn_DiasRechazo          IN NUMBER,
                                          Pn_TotalRegistros       OUT NUMBER,
                                          Prf_Servicios           OUT SYS_REFCURSOR,
                                          Pv_Status               OUT VARCHAR2,
                                          Pv_MensajeError         OUT VARCHAR2)
  AS
    Lv_SelectPrincipal VARCHAR2(4000);
    Lv_SelectCountPrincipal VARCHAR2(4000);
    Lv_Select VARCHAR2(4000);
    Lcl_ConsultaPrincipal CLOB;
    Lcl_ConsultaCountPrincipal CLOB;
    Lv_FromJoin VARCHAR2(4000);
    Lv_Where VARCHAR2(4000);
    Lv_WherePrincipal VARCHAR2(4000);
    Lv_GrupoDatacenter VARCHAR2(10) := 'DATACENTER';
    Lv_EstadoEliminado VARCHAR2(9) := 'Eliminado';
    Lv_AccionSeguimiento VARCHAR2(11) := 'Seguimiento';
    Lv_DescripcionSolicitud VARCHAR2(23) := 'SOLICITUD PLANIFICACION';
    Lt_ArrayParamsBind CMKG_TYPES.Lt_ArrayAsociativo;
    Lv_NombreParamBind VARCHAR2(30);
    Ln_IdCursor NUMBER;
    Ln_NumExecPrincipal NUMBER;
    Ln_IdCursorCount NUMBER;
    Ln_NumExecCount NUMBER;
    Lrf_ConsultaCount SYS_REFCURSOR;
  
    BEGIN
      Pn_TotalRegistros       := 0;
      Lv_SelectCountPrincipal := 'SELECT COUNT(DISTINCT ID_SERVICIO) AS TOTAL_REGISTROS ';
      Lv_SelectPrincipal      := 'SELECT DISTINCT SERVICIOS.ID_SERVICIO,
                                  SERVICIOS.ID_SERVICIO_TECNICO,
                                  SERVICIOS.INTERFACE_ELEMENTO_CONECTOR_ID,
                                  SERVICIOS.EMPRESA_COD,
                                  SERVICIOS.JURISDICCION,
                                  SERVICIOS.CIUDAD,
                                  SERVICIOS.CODIGO_TIPO_MEDIO,
                                  SERVICIOS.USR_VENDEDOR,
                                  SERVICIOS.VENDEDOR,
                                  SERVICIOS.CLIENTE,
                                  SERVICIOS.LOGIN,
                                  SERVICIOS.ID_PRODUCTO,
                                  SERVICIOS.NOMBRE_PRODUCTO,
                                  SERVICIOS.NOMBRE_TECNICO_PRODUCTO,
                                  SERVICIOS.PRODUCTO_ES_CONCENTRADOR,
                                  SERVICIOS.ID_DETALLE_SOLICITUD,
                                  TO_CHAR(SERVICIOS.FECHA_DETENIDO, ''DD/MM/YYYY HH24:MI:SS'') AS FECHA_DETENIDO,
                                  ROUND((SYSDATE -TRUNC(SERVICIOS.FECHA_DETENIDO)),2)        AS DIAS_DETENIDO ';
  
      Lv_Select               := 'SELECT SERVICIO.ID_SERVICIO,
                                  SERVICIO_TECNICO.ID_SERVICIO_TECNICO,
                                  SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID,
                                  ER.EMPRESA_COD,
                                  JURISDICCION.NOMBRE_JURISDICCION AS JURISDICCION,
                                  DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(CANTON.NOMBRE_CANTON) AS CIUDAD,
                                  MEDIO.CODIGO_TIPO_MEDIO,
                                  SERVICIO.USR_VENDEDOR,
                                  (SELECT CONCAT(CONCAT (NVL(PERSONA_VENDEDOR.NOMBRES, ''''),'' ''), NVL(PERSONA_VENDEDOR.APELLIDOS, ''''))
                                   FROM DB_COMERCIAL.INFO_PERSONA PERSONA_VENDEDOR
                                   WHERE PERSONA_VENDEDOR.LOGIN = SERVICIO.USR_VENDEDOR
                                   AND PERSONA_VENDEDOR.ESTADO <> :Lv_EstadoEliminado
                                   AND ROWNUM = 1) AS VENDEDOR,
                                  CASE
                                    WHEN PERSONA.RAZON_SOCIAL IS NOT NULL
                                    THEN DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.RAZON_SOCIAL)
                                    ELSE CONCAT(CONCAT (NVL(PERSONA.NOMBRES, ''''),'' ''), NVL(PERSONA.APELLIDOS, ''''))
                                  END         AS CLIENTE,
                                  PUNTO.LOGIN AS LOGIN,
                                  PRODUCTO.ID_PRODUCTO AS ID_PRODUCTO,
                                  PRODUCTO.DESCRIPCION_PRODUCTO AS NOMBRE_PRODUCTO,
                                  PRODUCTO.NOMBRE_TECNICO AS NOMBRE_TECNICO_PRODUCTO,
                                  PRODUCTO.ES_CONCENTRADOR AS PRODUCTO_ES_CONCENTRADOR,
                                  SOLICITUD.ID_DETALLE_SOLICITUD,
                                  (SELECT MAX(SERVICIO_HISTORIAL.FE_CREACION)
                                  FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SERVICIO_HISTORIAL
                                  WHERE SERVICIO_HISTORIAL.SERVICIO_ID=SERVICIO.ID_SERVICIO
                                  AND SERVICIO_HISTORIAL.ESTADO       = :Pv_EstadoActualServicio
                                  AND NVL(SERVICIO_HISTORIAL.ACCION, '' '') != :Lv_AccionSeguimiento
                                  )                             AS FECHA_DETENIDO ';
  
      Lv_FromJoin             := 'FROM DB_COMERCIAL.INFO_PUNTO PUNTO
                                  INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                                  ON PUNTO.PERSONA_EMPRESA_ROL_ID=PER.ID_PERSONA_ROL
                                  INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER
                                  ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
                                  INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
                                  ON PER.PERSONA_ID =PERSONA.ID_PERSONA
                                  INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
                                  ON PUNTO.PUNTO_COBERTURA_ID =JURISDICCION.ID_JURISDICCION
                                  INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
                                  ON PUNTO.ID_PUNTO =SERVICIO.PUNTO_ID
                                  INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
                                  ON SERVICIO_TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO
                                  INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO MEDIO
                                  ON MEDIO.ID_TIPO_MEDIO = SERVICIO_TECNICO.ULTIMA_MILLA_ID
                                  INNER JOIN DB_GENERAL.ADMI_SECTOR SECTOR
                                  ON SECTOR.ID_SECTOR = PUNTO.SECTOR_ID
                                  INNER JOIN DB_GENERAL.ADMI_PARROQUIA PARROQUIA
                                  ON PARROQUIA.ID_PARROQUIA = SECTOR.PARROQUIA_ID
                                  INNER JOIN DB_GENERAL.ADMI_CANTON CANTON
                                  ON CANTON.ID_CANTON = PARROQUIA.CANTON_ID
                                  INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD
                                  ON SOLICITUD.SERVICIO_ID = SERVICIO.ID_SERVICIO
                                  INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOLICITUD
                                  ON TIPO_SOLICITUD.ID_TIPO_SOLICITUD = SOLICITUD.TIPO_SOLICITUD_ID
                                  INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                  ON PRODUCTO.ID_PRODUCTO                  = SERVICIO.PRODUCTO_ID ';
  
      Lv_Where                := 'WHERE SERVICIO.ESTADO                    = :Pv_EstadoActualServicio
                                  AND SOLICITUD.SERVICIO_ID                = SERVICIO.ID_SERVICIO
                                  AND SOLICITUD.ESTADO                     = :Pv_EstadoActualServicio
                                  AND TIPO_SOLICITUD.DESCRIPCION_SOLICITUD = :Lv_DescripcionSolicitud
                                  AND ER.EMPRESA_COD                       = :Pv_CodigoEmpresa 
                                  AND PRODUCTO.GRUPO                       <> :Lv_GrupoDatacenter ';
      Lv_WherePrincipal       := 'WHERE SERVICIOS_REPORTE.DIAS_DETENIDO >= :Fn_DiasLiberaFactib ';
  
      Lt_ArrayParamsBind('Lv_EstadoEliminado')        := Lv_EstadoEliminado;
      Lt_ArrayParamsBind('Pv_EstadoActualServicio')   := Pv_EstadoActualServicio;
      Lt_ArrayParamsBind('Lv_AccionSeguimiento')      := Lv_AccionSeguimiento;
      Lt_ArrayParamsBind('Lv_DescripcionSolicitud')   := Lv_DescripcionSolicitud;
      Lt_ArrayParamsBind('Pv_CodigoEmpresa')          := Pv_CodigoEmpresa;
      Lt_ArrayParamsBind('Lv_GrupoDatacenter')        := Lv_GrupoDatacenter;
      Lt_ArrayParamsBind('Fn_DiasLiberaFactib')       := Pn_DiasRechazo;
  
  
      Lcl_ConsultaPrincipal := 'SELECT SERVICIOS_REPORTE.*, ROUND(SERVICIOS_REPORTE.DIAS_DETENIDO) AS DIAS_DETENIDO_REPORTE FROM ( ' ||
                                Lv_SelectPrincipal || ' FROM (' || Lv_Select || Lv_FromJoin || Lv_Where || ') SERVICIOS ) SERVICIOS_REPORTE ' || 
                                Lv_WherePrincipal;
      Lcl_ConsultaCountPrincipal := Lv_SelectCountPrincipal || ' FROM (' || Lcl_ConsultaPrincipal || ') ';
      Ln_IdCursorCount := DBMS_SQL.OPEN_CURSOR();
      DBMS_SQL.PARSE(Ln_IdCursorCount, Lcl_ConsultaCountPrincipal, DBMS_SQL.NATIVE);
      Lv_NombreParamBind := Lt_ArrayParamsBind.FIRST;
      WHILE (Lv_NombreParamBind IS NOT NULL) LOOP
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursorCount, Lv_NombreParamBind, Lt_ArrayParamsBind(Lv_NombreParamBind));
        Lv_NombreParamBind := Lt_ArrayParamsBind.NEXT(Lv_NombreParamBind);
      END LOOP;
      Ln_NumExecCount := DBMS_SQL.EXECUTE(Ln_IdCursorCount);
      Lrf_ConsultaCount := DBMS_SQL.TO_REFCURSOR(Ln_IdCursorCount);
      FETCH Lrf_ConsultaCount INTO Pn_TotalRegistros;
  
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      DBMS_SQL.PARSE(Ln_IdCursor, Lcl_ConsultaPrincipal, DBMS_SQL.NATIVE);
      Lv_NombreParamBind := Lt_ArrayParamsBind.FIRST;
      WHILE (Lv_NombreParamBind IS NOT NULL) LOOP
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, Lv_NombreParamBind, Lt_ArrayParamsBind(Lv_NombreParamBind));
        Lv_NombreParamBind := Lt_ArrayParamsBind.NEXT(Lv_NombreParamBind);
      END LOOP;
      Ln_NumExecPrincipal     := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Prf_Servicios           := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      Pv_Status               := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      --
      Pn_TotalRegistros         := 0;
      Prf_Servicios             := NULL;
      Pv_Status                 := 'ERROR';
      Pv_MensajeError           := 'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                    || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'COMEK_CONSULTAS.P_GET_SERVICIOS_POR_RECHAZAR', 
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_SERVICIOS_POR_RECHAZAR;

  FUNCTION F_GET_DESCRIPCION_PRODUCTO(Fn_idPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    RETURN VARCHAR2 
  IS
    CURSOR C_getDescripcionProducto(Cn_idPlan NUMBER) 
    IS
      SELECT cap.descripcion_producto 
      FROM db_comercial.admi_producto cap,
        db_comercial.info_plan_det ipd
      WHERE cap.codigo_producto = 'INTD'
      AND cap.id_producto       = ipd.producto_id
      AND ipd.plan_id           = Cn_idPlan
      AND ipd.estado            = 'Activo'
      AND cap.Estado            = 'Activo';
    
    Lv_DescripcionProducto DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE := '';
     
  BEGIN
      
    IF C_getDescripcionProducto%ISOPEN THEN
      CLOSE C_getDescripcionProducto;
    END IF;
        
    OPEN  C_getDescripcionProducto(Fn_idPlan);
    FETCH C_getDescripcionProducto INTO Lv_DescripcionProducto;
    CLOSE C_getDescripcionProducto;
    
    RETURN Lv_DescripcionProducto;

  END F_GET_DESCRIPCION_PRODUCTO;

  FUNCTION F_GET_VALOR_PLAN(Fn_idPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    RETURN NUMBER 
  IS
    CURSOR C_getValorPlan(Cn_idPlan NUMBER) 
    IS
      SELECT SUM(ipd.CANTIDAD_DETALLE*ipd.PRECIO_ITEM) VALOR_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB  IPC,
        DB_COMERCIAL.INFO_PLAN_DET  IPD 
      WHERE IPD.PLAN_ID   = IPC.ID_PLAN
      AND IPC.ID_PLAN     = Cn_idPlan
      AND IPC.EMPRESA_COD = '18'
      AND IPC.ESTADO      = 'Activo'
      AND IPD.ESTADO      = 'Activo';
    
    Ln_ValorPlan DB_COMERCIAL.INFO_PLAN_DET.PRECIO_ITEM%TYPE := 0;
     
  BEGIN
      
    IF C_getValorPlan%ISOPEN THEN
      CLOSE C_getValorPlan;
    END IF;
        
    OPEN  C_getValorPlan(Fn_idPlan);
    FETCH C_getValorPlan INTO Ln_ValorPlan;
    CLOSE C_getValorPlan;
    
    RETURN Ln_ValorPlan;

  END F_GET_VALOR_PLAN;

  PROCEDURE P_SERVICIOS_MCAFEE_ERROR
    AS
      CURSOR C_GetRegistros(Pv_DescCaract VARCHAR2,Pv_EstadoActivo VARCHAR2, Pv_BusquedaProductos VARCHAR2)
      IS
        SELECT INFO_PUNTO.LOGIN           AS login,
          INFO_SERVICIO_PROD_CARACT.VALOR AS valor
        FROM DB_COMERCIAL.INFO_PUNTO,
          DB_COMERCIAL.INFO_SERVICIO,
          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT,
          DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA,
          DB_COMERCIAL.ADMI_CARACTERISTICA ,
          DB_COMERCIAL.ADMI_PRODUCTO
        WHERE INFO_PUNTO.ID_PUNTO                                 = INFO_SERVICIO.PUNTO_ID
        AND INFO_SERVICIO.ID_SERVICIO                             = INFO_SERVICIO_PROD_CARACT.SERVICIO_ID
        AND INFO_SERVICIO_PROD_CARACT.PRODUCTO_CARACTERISITICA_ID = ADMI_PRODUCTO_CARACTERISTICA.ID_PRODUCTO_CARACTERISITICA
        AND ADMI_PRODUCTO_CARACTERISTICA.CARACTERISTICA_ID        = ADMI_CARACTERISTICA.ID_CARACTERISTICA
        AND ADMI_PRODUCTO_CARACTERISTICA.PRODUCTO_ID              = ADMI_PRODUCTO.ID_PRODUCTO
        AND ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA        = Pv_DescCaract
        AND INFO_SERVICIO_PROD_CARACT.ESTADO                      = Pv_EstadoActivo
        AND INFO_SERVICIO_PROD_CARACT.FE_CREACION                >= to_date(TO_CHAR(sysdate, 'dd/mm/yyyy'), 'dd/mm/yyyy')
        AND ADMI_PRODUCTO.DESCRIPCION_PRODUCTO LIKE Pv_BusquedaProductos
        AND INFO_SERVICIO_PROD_CARACT.VALOR IS NOT NULL;
      Lv_MensajeError       VARCHAR2(4000);
      Lv_SuscripcionesError VARCHAR2(4000);
      Lv_Remitente          VARCHAR2(50)   := 'notificaciones_telcos@telconet.ec';
      Lv_Asunto             VARCHAR2(300)  := 'Clientes con errores en cancelaci閿熺单 de suscripciones MCAFEE por migraci閿熺单 de tecnolog閿熺禈';
      Lv_BusquedaProductos  VARCHAR2(10)   := 'I. %';
      Lv_DescCaract         VARCHAR2(20)   := 'ERROR_CANCELACION';
      Lv_EstadoActivo       VARCHAR2(10)   := 'Activo';
      Iv_contador           NUMBER         := 0;
      Lcl_PlantillaReporte CLOB;
      Lr_GetAliasPlantillaGeneral DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    BEGIN
      Lr_GetAliasPlantillaGeneral := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('MCAFEE_ERROR_CA');
      Lcl_PlantillaReporte        := Lr_GetAliasPlantillaGeneral.PLANTILLA;
      FOR I_GetRegistros IN C_GetRegistros(Lv_DescCaract, Lv_EstadoActivo,Lv_BusquedaProductos)
      LOOP
        Iv_contador           := Iv_contador +1;
        Lv_SuscripcionesError := Lv_SuscripcionesError||'<tr><td>'|| Iv_contador ||'</td><td>'|| I_GetRegistros.login ||'</td><td>'|| I_GetRegistros.valor||'</td></tr>';
      END LOOP;
      Lcl_PlantillaReporte                         := REPLACE(Lcl_PlantillaReporte,'{{ registrosSuscripciones }}', Lv_SuscripcionesError);
      IF Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS IS NOT NULL THEN
        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS  := REPLACE(Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, ';', ',') || ',';
      ELSE
        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS := Lv_Remitente;
      END IF;
      --Se verifica que existan servicios por liberarse por empresa
      --Env閿熺郸 de correo al vendedor
      IF Lv_SuscripcionesError IS NOT NULL THEN
        DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL( Lv_Remitente, Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, Lv_Asunto, SUBSTR(Lcl_PlantillaReporte, 1, 32767), 'text/html; charset=UTF-8', Lv_MensajeError);
        IF Lv_MensajeError IS NOT NULL THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'P_SERVICIOS_MCAFEE_ERROR', Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
          Lv_MensajeError := '';
        END IF;
      END IF;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'P_SERVICIOS_MCAFEE_ERROR', Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
  END P_SERVICIOS_MCAFEE_ERROR;

  PROCEDURE P_SERVICIOS_KASPERSKY_ERROR
    AS
      CURSOR C_GetRegistros(Pv_DescCaract VARCHAR2,Pv_EstadoActivo VARCHAR2, Pv_BusquedaProductos VARCHAR2)
      IS
        SELECT INFO_PUNTO.LOGIN           AS login,
          INFO_SERVICIO_PROD_CARACT.VALOR AS valor
        FROM DB_COMERCIAL.INFO_PUNTO,
          DB_COMERCIAL.INFO_SERVICIO,
          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT,
          DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA,
          DB_COMERCIAL.ADMI_CARACTERISTICA ,
          DB_COMERCIAL.ADMI_PRODUCTO
        WHERE INFO_PUNTO.ID_PUNTO                                 = INFO_SERVICIO.PUNTO_ID
        AND INFO_SERVICIO.ID_SERVICIO                             = INFO_SERVICIO_PROD_CARACT.SERVICIO_ID
        AND INFO_SERVICIO_PROD_CARACT.PRODUCTO_CARACTERISITICA_ID = ADMI_PRODUCTO_CARACTERISTICA.ID_PRODUCTO_CARACTERISITICA
        AND ADMI_PRODUCTO_CARACTERISTICA.CARACTERISTICA_ID        = ADMI_CARACTERISTICA.ID_CARACTERISTICA
        AND ADMI_PRODUCTO_CARACTERISTICA.PRODUCTO_ID              = ADMI_PRODUCTO.ID_PRODUCTO
        AND ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA        = Pv_DescCaract
        AND INFO_SERVICIO_PROD_CARACT.ESTADO                      = Pv_EstadoActivo
        AND INFO_SERVICIO_PROD_CARACT.FE_CREACION                >= to_date(TO_CHAR(sysdate, 'dd/mm/yyyy'), 'dd/mm/yyyy')
        AND ADMI_PRODUCTO.DESCRIPCION_PRODUCTO = Pv_BusquedaProductos
        AND INFO_SERVICIO_PROD_CARACT.VALOR IS NOT NULL;
      Lv_MensajeError       VARCHAR2(4000);
      Lv_SuscripcionesError VARCHAR2(4000);
      Lv_Remitente          VARCHAR2(50)   := 'notificaciones_telcos@telconet.ec';
      Lv_Asunto             VARCHAR2(300)  := 'Clientes con errores en cancelaci閿熺单 de suscripciones KASPERSKY';
      Lv_BusquedaProductos  VARCHAR2(10)   := 'I. PROTEGIDO MULTI PAID';
      Lv_DescCaract         VARCHAR2(37)   := 'ERROR_CANCELACION_INTERNET_PROTEGIDO';
      Lv_EstadoActivo       VARCHAR2(10)   := 'Activo';
      Iv_contador           NUMBER         := 0;
      Lcl_PlantillaReporte CLOB;
      Lr_GetAliasPlantillaGeneral DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    BEGIN
      Lr_GetAliasPlantillaGeneral := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('ERRORCANMASIPMP');
      Lcl_PlantillaReporte        := Lr_GetAliasPlantillaGeneral.PLANTILLA;
      FOR I_GetRegistros IN C_GetRegistros(Lv_DescCaract, Lv_EstadoActivo,Lv_BusquedaProductos)
      LOOP
        Iv_contador           := Iv_contador +1;
        Lv_SuscripcionesError := Lv_SuscripcionesError||'<tr><td>'|| Iv_contador ||'</td><td>'|| I_GetRegistros.login ||'</td><td>'
                                 || I_GetRegistros.valor||'</td></tr>';
      END LOOP;
      Lcl_PlantillaReporte                         := REPLACE(Lcl_PlantillaReporte,'{{ registrosSuscripciones }}', Lv_SuscripcionesError);
      IF Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS IS NOT NULL THEN
        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS  := REPLACE(Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, ';', ',') || ',';
      ELSE
        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS := Lv_Remitente;
      END IF;
      --Se verifica que existan servicios por liberarse por empresa
      --Env閿熺郸 de correo al vendedor
      IF Lv_SuscripcionesError IS NOT NULL THEN
        DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL(  Lv_Remitente, 
                                                        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, 
                                                        Lv_Asunto, 
                                                        SUBSTR(Lcl_PlantillaReporte, 1, 32767), 
                                                        'text/html; charset=UTF-8', 
                                                        Lv_MensajeError);
        IF Lv_MensajeError IS NOT NULL THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                'P_SERVICIOS_KASPERSKY_ERROR', 
                                                Lv_MensajeError, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                                SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
          Lv_MensajeError := '';
        END IF;
      END IF;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'P_SERVICIOS_KASPERSKY_ERROR', 
                                            Lv_MensajeError, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
  END P_SERVICIOS_KASPERSKY_ERROR;

FUNCTION F_GET_FORMAS_CONTACTO_BY_PUNTO(
    Fn_IdPunto        IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_TipoData       IN ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_DatoContacto(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_TipoData ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  IS
  WITH FORMA_CONTACTO_MAIL AS
  (
  --
  SELECT LISTAGG(AFC.DESCRIPCION_FORMA_CONTACTO||':'||REPLACE(REPLACE(
    REGEXP_REPLACE(NVL2(IPFC.VALOR, IPFC.VALOR, NULL), '[^[:digit:]|;]', '')
    , '  ', ''), ' ', ''), ';') 
  WITHIN GROUP (
  ORDER BY NVL2(IPFC.VALOR, IPFC.VALOR, NULL)
  ) CONTACTO
  FROM DB_COMERCIAL.INFO_PUNTO IP,
    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
    DB_COMERCIAL.INFO_PERSONA IPR,
    DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC,
    DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
  WHERE IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
  AND IPER.PERSONA_ID             = IPR.ID_PERSONA
  AND IPR.ID_PERSONA              = IPFC.PERSONA_ID
  AND IPFC.FORMA_CONTACTO_ID      = AFC.ID_FORMA_CONTACTO
  AND IPFC.ESTADO                 = 'Activo'
  AND AFC.ESTADO                  = 'Activo'
  AND (IP.ESTADO                  = 'Activo'
  OR   IP.ESTADO                  = 'In-Corte'
  OR   IP.ESTADO                  = 'Pendiente')
  AND AFC.CODIGO                 IN
    (SELECT CODIGO
    FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO
    WHERE DESCRIPCION_FORMA_CONTACTO LIKE
      CASE Cv_TipoData
        WHEN 'MAIL'
        THEN 'Correo%'
        WHEN 'FONO'
        THEN 'Telefono%'
        WHEN 'MOVIL'
        THEN '%Movil%'
        ELSE 'Telefono%'
      END
    )
  AND IP.ID_PUNTO = Cn_IdPunto
  UNION
  SELECT AFC.DESCRIPCION_FORMA_CONTACTO||':'||REPLACE(REPLACE(
    REGEXP_REPLACE(NVL2(IPFC.VALOR, IPFC.VALOR, NULL), '[^[:digit:]|;]', '')
  , '  ', ''), ' ', '') CONTACTO
  FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO IPFC,
    DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC,
    DB_COMERCIAL.INFO_PUNTO IP
  WHERE 
  IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
  AND IPFC.PUNTO_ID      = IP.ID_PUNTO
  AND AFC.CODIGO  IN
    (SELECT CODIGO
    FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO
    WHERE DESCRIPCION_FORMA_CONTACTO LIKE
      CASE Cv_TipoData
        WHEN 'MAIL'
        THEN 'Correo%'
        WHEN 'FONO'
        THEN 'Telefono%'
        WHEN 'MOVIL'
        THEN '%Movil%'
        ELSE 'Telefono%'
      END
    )
  AND IPFC.ESTADO   = 'Activo'
  AND AFC.ESTADO    = 'Activo'
  AND (IP.ESTADO    = 'Activo'
  OR  IP.ESTADO     = 'In-Corte')
  AND IPFC.PUNTO_ID = Cn_IdPunto
    )
  SELECT LISTAGG(CONTACTO, ';') WITHIN GROUP (
  ORDER BY CONTACTO) CONTACTO
  FROM FORMA_CONTACTO_MAIL;
      --
      Lv_Data VARCHAR2(4000);
      --
    BEGIN
        --
        --
        IF C_DatoContacto%ISOPEN THEN
          --
          CLOSE C_DatoContacto;
          --
        END IF;
        --
        OPEN C_DatoContacto(Fn_IdPunto, Fv_TipoData);
        --
        FETCH C_DatoContacto INTO Lv_Data;
        --
        CLOSE C_DatoContacto;
        --
      --
      IF Fv_TipoData = 'MAIL' THEN
        Lv_Data := REPLACE(REPLACE(REPLACE(Lv_Data, Chr(9), ''), Chr(10), ''), Chr(13), '');
        --
      END IF;
      --
      RETURN Lv_Data;
      --
    EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'COMEK_CONSULTAS.F_GET_FORMAS_CONTACTO_BY_PUNTO', 
                                            SQLERRM, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    END F_GET_FORMAS_CONTACTO_BY_PUNTO;



  PROCEDURE P_GET_PUNTOS_BY_FORMA_CONTAC(Pv_CodEmpresa       IN VARCHAR2,
                                         Pv_Valor            IN VARCHAR2,
                                         Pv_Tipo             IN VARCHAR2,
                                         Pv_MensajeRespuesta OUT VARCHAR2,
                                         Pr_Informacion      OUT SYS_REFCURSOR) IS
    --
    Lv_Query             CLOB;
    Lv_QueryPersona      CLOB;
    Lv_QueryPunto        CLOB;
    Lv_TipoFormaContacto VARCHAR2(100);
    Le_Exception         EXCEPTION;
    Lv_MensajeError      VARCHAR2(4000);
    Lv_EstadoActivo      VARCHAR2(15) := 'Activo';
    Lv_EstadoInCorte     VARCHAR2(15) := 'In-Corte';
    Lv_EstadoPendiente   VARCHAR2(15) := 'Pendiente';
    --
    --
  BEGIN
    --
    IF Pv_CodEmpresa IS NOT NULL AND TRIM(Pv_Valor) IS NOT NULL AND TRIM(Pv_Tipo) IS NOT NULL THEN
      --
      Lv_TipoFormaContacto :=  '';

      IF Pv_Tipo = 'FONO' THEN
          Lv_TipoFormaContacto := 'Telefono';
      ELSE
         IF Pv_Tipo = 'MAIL' THEN
             Lv_TipoFormaContacto := 'Correo Electronico';
         ELSE
             IF Pv_Tipo = 'MOVIL' THEN
                 Lv_TipoFormaContacto := 'Movil';
             ELSE
                 Lv_TipoFormaContacto :=  Pv_Tipo;
             END IF;
         END IF;
      END IF;
      --
      Lv_QueryPersona := Lv_QueryPersona || 
      '(
          SELECT pto.ID_PUNTO, pto.LOGIN
          FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO pfc 
          JOIN DB_COMERCIAL.INFO_PERSONA pe ON pe.ID_PERSONA = pfc.PERSONA_ID
          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per ON per.PERSONA_ID = pe.ID_PERSONA
          JOIN DB_COMERCIAL.INFO_EMPRESA_ROL erol ON erol.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
          JOIN DB_COMERCIAL.INFO_PUNTO pto ON per.ID_PERSONA_ROL = pto.PERSONA_EMPRESA_ROL_ID
          WHERE 
          pfc.FORMA_CONTACTO_ID in 
          (
              SELECT ID_FORMA_CONTACTO FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO '|| 
              q'[ WHERE REGEXP_LIKE(DESCRIPCION_FORMA_CONTACTO, ']'||Lv_TipoFormaContacto||q'['))]'||
        q'[ AND pfc.ESTADO       = ']'||Lv_EstadoActivo||q'[']'||
        q'[ AND pfc.VALOR        = ']'||Pv_Valor||q'[']'||
        q'[ AND per.ESTADO       = ']'||Lv_EstadoActivo||q'[']'||
        ' AND ('||
        q'[      pto.ESTADO      = ']'||Lv_EstadoActivo||q'['  OR ]'|| 
        q'[      pto.ESTADO      = ']'||Lv_EstadoInCorte||q'[' OR ]'||
        q'[      pto.ESTADO      = ']'||Lv_EstadoPendiente||q'[']'||
        '     )'||
        q'[  AND erol.EMPRESA_COD = ']'||Pv_CodEmpresa||q'[']'||
      ')';

      Lv_QueryPunto := Lv_QueryPunto || '
      (
          SELECT pto.ID_PUNTO, pto.LOGIN FROM 
          DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO pfc
          JOIN DB_COMERCIAL.INFO_PUNTO pto ON pto.ID_PUNTO = pfc.PUNTO_ID
          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per ON per.ID_PERSONA_ROL = pto.PERSONA_EMPRESA_ROL_ID
          JOIN DB_COMERCIAL.INFO_PERSONA pe ON pe.ID_PERSONA = per.PERSONA_ID
          JOIN DB_COMERCIAL.INFO_EMPRESA_ROL erol ON erol.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
          WHERE 
          pfc.FORMA_CONTACTO_ID in 
          (
              SELECT ID_FORMA_CONTACTO FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO '|| 
      q'[        WHERE REGEXP_LIKE(DESCRIPCION_FORMA_CONTACTO, ']'||Lv_TipoFormaContacto||q'[')]'||
      '    )'||
      q'[   AND pfc.ESTADO       = ']'||Lv_EstadoActivo||q'[']'||
      q'[   AND pfc.VALOR        = ']'||Pv_Valor||q'[']'||
      '     AND ('||
      q'[         pto.ESTADO      = ']'||Lv_EstadoActivo||q'['  OR ]'|| 
      q'[         pto.ESTADO      = ']'||Lv_EstadoInCorte||q'[' OR ]'||
      q'[         pto.ESTADO      = ']'||Lv_EstadoPendiente||q'[']'||
      '         )'||
      q'[   AND per.ESTADO       = ']'||Lv_EstadoActivo||q'[']'||
      q'[   AND erol.EMPRESA_COD = ']'||Pv_CodEmpresa||q'[']'||
      ')';

      Lv_Query := Lv_QueryPersona || ' UNION ' || Lv_QueryPunto ;
      --
      OPEN Pr_Informacion FOR Lv_Query;
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Par閿熺丹etros adecuados para realizar la consulta - CodEmpresa(' ||
                         Pv_CodEmpresa || '), Pv_Valor( ' ||Pv_Valor || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pv_MensajeRespuesta := Lv_MensajeError;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_PUNTOS_BY_FORMA_CONTAC',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pv_MensajeRespuesta := 'Error al consultar los puntos por forma de contacto';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_PUNTOS_BY_FORMA_CONTAC',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_PUNTOS_BY_FORMA_CONTAC;

  PROCEDURE P_GET_ORDENES_TELCOS_CRM(Pcl_Parametros         IN CLOB,
                                     Pv_MensajeRespuesta    OUT VARCHAR2,
                                     Pr_Informacion         OUT SYS_REFCURSOR) IS
    --
    Ln_Indx                NUMBER;
    Lv_Query               CLOB;
    Le_Exception           EXCEPTION;
    Lv_MensajeError        VARCHAR2(30000);
    Lr_OrdenesVendidas     DB_COMERCIAL.CMKG_TYPES.Lr_ServiciosCrm;
    Lr_OrdenesVendidasProcesar DB_COMERCIAL.CMKG_TYPES.T_ServiciosCrm;
    Lv_FrecuenciaProducto  NUMBER;
    Lv_CamposAdicionales   VARCHAR2(500);
    Lv_RegistroAdicional   VARCHAR2(1000);
    Lv_Select              VARCHAR2(30000) := 'SELECT ';
    Lv_From                VARCHAR2(30000) := 'FROM ';
    Lv_Where               VARCHAR2(30000) := 'WHERE ';
    Lv_GroupBy             VARCHAR2(30000) := '';
    Lv_SelectCaB           VARCHAR2(30000) := '';
    Lv_FromCabIni          VARCHAR2(30000) := '';
    Lv_FromCabFin          VARCHAR2(30000) := '';
    Lv_Caracteristica      VARCHAR2(30000) := 'NOMBRE_PROPUESTA';
    Lv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE  := 'Activo';
    Lv_EstadoPendiente     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE  := 'Pendiente';
    Lv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE  := 'CATEGORIAS_PRODUCTOS';
    Lv_SolicitudDescuento  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE  := 'SOLICITUDES DE DESCUENTO';
    Lv_EstadosServicios    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE  := 'ESTADO_SERVICIO';
    Lv_Proceso             DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo              DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE  := 'COMERCIAL';
    Lv_EsVenta             DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE   := 'S';
    Lv_TipoOrden           DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    Lv_Directorio          VARCHAR2(50)  := 'DIR_REPGERENCIA';
    Lv_NombreArchivo       VARCHAR2(100);
    Lv_Delimitador         VARCHAR2(1) := ';';
    Lv_Gzip                VARCHAR2(100);
    Lv_Remitente           VARCHAR2(30) := 'telcos@telconet.ec';
    Lv_Destinatario        VARCHAR2(100);
    Lv_Asunto              VARCHAR2(300);
    Lv_NombreArchivoZip    VARCHAR2(100);
    Lc_GetAliasPlantilla   DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Cuerpo              VARCHAR2(9999);
    Lfile_Archivo          utl_file.file_type;
    Lv_PrefijoEmpresa      VARCHAR2(50);
    Lv_FechaInicio         VARCHAR2(400);
    Lv_FechaFin            VARCHAR2(400);
    Lv_Categoria           VARCHAR2(400);
    Lv_Grupo               VARCHAR2(400);
    Lv_Subgrupo            VARCHAR2(400);
    Lv_TipoOrdenes         VARCHAR2(400);
    Lv_Frecuencia          VARCHAR2(400);
    Lv_TipoPersonal        VARCHAR2(400);
    Ln_IdPersonaEmpresaRol NUMBER;
    Lv_OpcionSelect        VARCHAR2(400);
    Lv_EmailUsrSesion      VARCHAR2(400);
    Lv_EmailTelcos         VARCHAR2(40):='notificaciones_telcos@telconet.ec';
    --
    Lv_MotivoPadreRegularizacion DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_PADRE_CANCELACION%TYPE := 'Cancelacion por Regularizacion';
    --
  BEGIN
    --
    APEX_JSON.parse(Pcl_Parametros);
    Lv_PrefijoEmpresa      := APEX_JSON.get_varchar2('strPrefijoEmpresa');
    Lv_FechaInicio         := APEX_JSON.get_varchar2('strFechaInicio');
    Lv_FechaFin            := APEX_JSON.get_varchar2('strFechaFin');
    Lv_Categoria           := APEX_JSON.get_varchar2('strCategoria');
    Lv_Grupo               := APEX_JSON.get_varchar2('strGrupo');
    Lv_Subgrupo            := APEX_JSON.get_varchar2('strSubgrupo');
    Lv_TipoOrdenes         := APEX_JSON.get_varchar2('strTipoOrdenes');
    Lv_Frecuencia          := APEX_JSON.get_varchar2('strFrecuencia');
    Lv_TipoPersonal        := APEX_JSON.get_varchar2('strTipoPersonal');
    Ln_IdPersonaEmpresaRol := APEX_JSON.get_number('intIdPersonEmpresaRol');
    Lv_OpcionSelect        := APEX_JSON.get_varchar2('strOpcionSelect');
    Lv_EmailUsrSesion      := APEX_JSON.get_varchar2('strEmailUsrSession');

    IF TRIM(Lv_PrefijoEmpresa) IS NOT NULL AND Lv_FechaInicio IS NOT NULL AND
       Lv_FechaFin IS NOT NULL THEN
      --
      Lv_SelectCaB := ' SELECT DISTINCT '||
                          '  COUNT(DISTINCT cantidad_propuesta) AS cantidad_propuesta, '||
                          '  COUNT(cantidad_ordenes) - COUNT(cantidad_ordenes_crm) AS cantidad_ordenes, '||
                          '  COUNT(cantidad_ordenes_crm) AS cantidad_ordenes_crm, '||
                          '  SUM(total_venta_mrc) AS total_venta_mrc, '||
                          '  SUM(total_venta_nrc) AS total_venta_nrc, '||
                          '  usr_vendedor ';
      --
      Lv_FromCabIni :=' FROM (';
      --
      Lv_FromCabFin := ' ) ';
      --
      Lv_From       := Lv_From || ' DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDAS ' ||
                                  'JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                                  'ON AP.ID_PRODUCTO = IDAS.PRODUCTO_ID ';
      --
      Lv_Where      := Lv_Where ||
                        ' DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDAS.PUNTO_ID, NULL) = '''||Lv_PrefijoEmpresa||''' ' ||
                        'AND IDAS.FECHA_TRANSACCION >= CAST(TO_DATE('''||Lv_FechaInicio||''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                        'AND IDAS.FECHA_TRANSACCION <  CAST(TO_DATE('''||Lv_FechaFin||''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                        'AND AP.EMPRESA_COD = (SELECT COD_EMPRESA ' ||
                        'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                        'WHERE ESTADO = '''||Lv_EstadoActivo||''' ' ||
                        'AND PREFIJO  = '''||Lv_PrefijoEmpresa||''') ' ||
                        'AND IDAS.ES_VENTA = '''||Lv_EsVenta||''' ' ||
                        'AND IDAS.TIPO_ORDEN = '''||Lv_TipoOrden||''' ';
      --
      IF Lv_OpcionSelect = 'DETALLE' THEN
        --
        Lv_SelectCaB  := '';
        Lv_FromCabIni := '';
        Lv_FromCabFin := '';
        Lv_Select     := Lv_Select || ' IOG.NOMBRE_OFICINA, ' ||
                      ' IDAS.CATEGORIA, ' || ' IDAS.GRUPO, ' ||
                      ' IDAS.SUBGRUPO, ' || ' AP.DESCRIPCION_PRODUCTO, ' ||
                      ' NVL( IPE.RAZON_SOCIAL, CONCAT( IPE.NOMBRES, CONCAT('' '', IPE.APELLIDOS) ) ) AS CLIENTE, ' ||
                      ' IP.LOGIN, ' || ' IDAS.USR_VENDEDOR, ' ||
                      ' ISER.ID_SERVICIO, ' || ' IDAS.PRODUCTO_ID, ' ||
                      ' IDAS.ESTADO, ' ||
                      ' DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN( TRIM( REPLACE( REPLACE( REPLACE( TRIM( ' ||
                      ' ISER.DESCRIPCION_PRESENTA_FACTURA ), Chr(9), '' ''), Chr(10), '' ''), Chr(13), '' '') ) ) AS ' ||
                      ' DESCRIPCION_PRESENTA_FACTURA, ' ||
                      ' TO_CHAR(ISER.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_CREACION, ' ||
                      ' ROUND((SYSDATE - trunc(ISER.FE_CREACION)), 0) - 1 AS DIAS_ACUMULADO_CREACION, ' ||
                      ' DB_COMERCIAL.COMEK_CONSULTAS.F_GET_NUM_DIAS_ESTADO(IDAS.SERVICIO_ID, IDAS.ESTADO,''FECHA'') AS FE_ESTADO, ' ||
                      ' DB_COMERCIAL.COMEK_CONSULTAS.F_GET_NUM_DIAS_ESTADO(IDAS.SERVICIO_ID, IDAS.ESTADO,''NUM_DIAS'') AS DIAS_ACUMULADO_ESTADO, ' ||
                      ' DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DEPARTAMENTO_SERVICIO(IDAS.SERVICIO_ID, IDAS.ESTADO, '''||Lv_PrefijoEmpresa||''',''PERSONA'') AS USR_ESTADO, ' ||
                      ' DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DEPARTAMENTO_SERVICIO(IDAS.SERVICIO_ID, IDAS.ESTADO, '''||Lv_PrefijoEmpresa||''',''DEPARTAMENTO'') AS DEPARTAMENTO_ESTADO, ' ||
                      '( ' ||
                      '     SELECT ISERPC.VALOR ' ||
                      '     FROM ' ||
                      '         DB_COMERCIAL.INFO_SERVICIO                       ISER ' ||
                      '         JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT      ISERPC ON ISERPC.SERVICIO_ID              = ISER.ID_SERVICIO ' ||
                      '                                                                 AND ISERPC.ESTADO                  = '''||Lv_EstadoActivo||''' ' ||
                      '         JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA   APC    ON APC.ID_PRODUCTO_CARACTERISITICA = ISERPC.PRODUCTO_CARACTERISITICA_ID ' ||
                      '                                                                 AND APC.ESTADO                     = '''||Lv_EstadoActivo||''' ' ||
                      '         JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC     ON AC.ID_CARACTERISTICA            = APC.CARACTERISTICA_ID ' ||
                      '                                                                 AND AC.ESTADO                      = '''||Lv_EstadoActivo||''' ' ||
                      '     WHERE ' ||
                      '         ISER.ID_SERVICIO                  = IDAS.SERVICIO_ID ' ||
                      '         AND AC.DESCRIPCION_CARACTERISTICA = '''||Lv_Caracteristica||''' ' ||
                      ' ) AS PROPUESTA, ' ||
                      ' NVL(IDAS.FRECUENCIA_PRODUCTO, 0) AS FRECUENCIA_PRODUCTO, ' ||
                      ' IDAS.ES_VENTA, ' || ' IDAS.MRC, ' ||
                      ' NVL(IDAS.PRECIO_VENTA, 0) AS PRECIO_VENTA, ' ||
                      ' NVL(IDAS.CANTIDAD, 0) AS CANTIDAD, ' ||
                      ' NVL(IDAS.DESCUENTO_UNITARIO, 0) AS DESCUENTO, ' ||
                      ' NVL(IDAS.PRECIO_INSTALACION, 0) AS PRECIO_INSTALACION, ' ||
                      ' ( NVL(IDAS.PRECIO_VENTA, 0) - NVL(IDAS.DESCUENTO_UNITARIO, 0) ) AS SUBTOTAL_CON_DESCUENTO, ' ||
                      ' ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) AS ' ||
                      ' SUBTOTAL, ' ||
                      ' IDAS.NRC AS VALOR_INSTALACION_MENSUAL, ' ||
                      ' ROUND( ( ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                      '          ( NVL(IDAS.PRECIO_INSTALACION, 0) ) ), 2 ) AS VALOR_TOTAL, ' ||
                      ' IDAS.ACCION, ';
        --
        IF TRIM(Lv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_Select := Lv_Select ||' IDAS.MOTIVO_CANCELACION, IDAS.MOTIVO_PADRE_CANCELACION ';
          --
        ELSE
          --
          Lv_Select := Lv_Select ||' '' '' AS MOTIVO_CANCELACION, '' '' AS MOTIVO_PADRE_CANCELACION ';
          --
        END IF;
        --
        Lv_From := Lv_From || ' JOIN DB_COMERCIAL.INFO_SERVICIO ISER ' ||
                   ' ON ISER.ID_SERVICIO = IDAS.SERVICIO_ID ' ||
                   ' JOIN DB_COMERCIAL.INFO_PUNTO IP ' ||
                   ' ON ISER.PUNTO_ID = IP.ID_PUNTO ' ||
                   ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ' ||
                   ' ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID ' ||
                   ' JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ' ||
                   ' ON IPER.OFICINA_ID = IOG.ID_OFICINA ' ||
                   ' JOIN DB_COMERCIAL.INFO_PERSONA IPE ' ||
                   ' ON IPE.ID_PERSONA = IPER.PERSONA_ID ';
        --
      ELSE
        --
        Lv_Select := Lv_Select ||
                      ' IDAS.SERVICIO_ID AS CANTIDAD_ORDENES, '||
                      ' ( '||
                      '   SELECT '||
                      '       ISER.ID_SERVICIO '||
                      '   FROM '||
                      '      DB_COMERCIAL.INFO_SERVICIO                  ISER '||
                      '       JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT      ISERPC ON ISERPC.SERVICIO_ID = ISER.ID_SERVICIO '||
                      '                                                             AND ISERPC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '       JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA   APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISERPC.PRODUCTO_CARACTERISITICA_ID '||
                      '                                                             AND APC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '       JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID '||
                      '                                                   AND AC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '   WHERE '||
                      '       ISER.ID_SERVICIO = IDAS.SERVICIO_ID '||
                      '       AND AC.DESCRIPCION_CARACTERISTICA = '''||Lv_Caracteristica||''' '||
                      ' ) AS CANTIDAD_ORDENES_CRM, '||
                      ' ROUND((((NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0)) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0)) +(NVL(IDAS.PRECIO_INSTALACION '||
                      ' , 0) )), 2) AS TOTAL_VENTA, '||
                      ' ROUND((((NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0)) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0))), 2) AS TOTAL_VENTA_MRC, '||
                      ' ROUND(((NVL(IDAS.PRECIO_INSTALACION, 0) )), 2) AS TOTAL_VENTA_NRC, '||
                      ' IDAS.USR_VENDEDOR, '||
                      ' ( '||
                      '   SELECT DISTINCT '||
                      '       ISERPC.VALOR '||
                      '   FROM '||
                      '       DB_COMERCIAL.INFO_SERVICIO                  ISER '||
                      '       JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT      ISERPC ON ISERPC.SERVICIO_ID = ISER.ID_SERVICIO '||
                      '                                                             AND ISERPC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '       JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA   APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISERPC.PRODUCTO_CARACTERISITICA_ID '||
                      '                                                             AND APC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '       JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID '||
                      '                                                   AND AC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '   WHERE '||
                      '       ISER.ID_SERVICIO = IDAS.SERVICIO_ID '||
                      '       AND AC.DESCRIPCION_CARACTERISTICA = '''||Lv_Caracteristica||''' '||
                      ' ) AS CANTIDAD_PROPUESTA ';
        --
        IF Lv_OpcionSelect = 'DESCUENTO' THEN
          --
          Lv_SelectCaB := Lv_SelectCaB ||
                          ' ,COUNT(cantidad_solicitudes) AS cantidad_solicitudes, '||
                              ' SUM(total_descuentos) AS total_descuentos ';
          Lv_Select    := Lv_Select ||
                          ' ,( SELECT DISTINCT IDS.ID_DETALLE_SOLICITUD  ' ||
                          ' FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ' ||
                          ' JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ' ||
                          ' ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID '||
                          ' WHERE ATS.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                          ' AND IDS.SERVICIO_ID = IDAS.SERVICIO_ID ' ||
                          ' AND IDS.ESTADO = '''||Lv_EstadoPendiente||''' ' ||
                          ' AND ATS.DESCRIPCION_SOLICITUD IN ( ' ||
                          '   SELECT APD.DESCRIPCION ' ||
                          '   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                          '   JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                          '   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                          '   WHERE APD.ESTADO         = '''||Lv_EstadoActivo||''' ' ||
                          '   AND APC.ESTADO           = '''||Lv_EstadoActivo||''' ' ||
                          '   AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' ' ||
                          '   AND APC.PROCESO          = '''||Lv_Proceso||''' ' ||
                          '   AND APC.MODULO           = '''||Lv_Modulo||''' ' ||
                          '   AND APD.VALOR1           = '''||Lv_SolicitudDescuento||''' ' ||
                          '   AND APD.EMPRESA_COD      = ( ' ||
                          '     SELECT COD_EMPRESA ' ||
                          '     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                          '     WHERE ESTADO = '''||Lv_EstadoActivo||''' ' ||
                          '     AND PREFIJO  = '''||Lv_PrefijoEmpresa||''' ' || '   ) ' ||
                          ' ))AS CANTIDAD_SOLICITUDES, '||
                          ' (SELECT ROUND( NVL(IDS.PRECIO_DESCUENTO, 0) , 2 )  '||
                          ' FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ' ||
                          ' JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ' ||
                          ' ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID '||
                          ' WHERE ATS.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                          ' AND IDS.SERVICIO_ID = IDAS.SERVICIO_ID ' ||
                          ' AND IDS.ESTADO = '''||Lv_EstadoPendiente||''' ' ||
                          ' AND ATS.DESCRIPCION_SOLICITUD IN ( ' ||
                          '   SELECT APD.DESCRIPCION ' ||
                          '   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                          '   JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                          '   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                          '   WHERE APD.ESTADO         = '''||Lv_EstadoActivo||''' ' ||
                          '   AND APC.ESTADO           = '''||Lv_EstadoActivo||''' ' ||
                          '   AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' ' ||
                          '   AND APC.PROCESO          = '''||Lv_Proceso||''' ' ||
                          '   AND APC.MODULO           = '''||Lv_Modulo||''' ' ||
                          '   AND APD.VALOR1           = '''||Lv_SolicitudDescuento||''' ' ||
                          '   AND APD.EMPRESA_COD      = ( ' ||
                          '     SELECT COD_EMPRESA ' ||
                          '     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                          '     WHERE ESTADO = '''||Lv_EstadoActivo||''' ' ||
                          '     AND PREFIJO  = '''||Lv_PrefijoEmpresa||''' ' || '   ) ' ||
                          ' )) AS TOTAL_DESCUENTOS ';
        END IF;
        --
        Lv_GroupBy := ' GROUP BY usr_vendedor ';
      END IF;
      --
      Lv_Where := Lv_Where || 'AND IDAS.ESTADO ';
      --
      IF TRIM(Lv_TipoOrdenes) = 'VENTAS_ACTIVAS' THEN
        --
        Lv_Where       := Lv_Where || ' NOT IN ';
        --
      ELSE
        --
        Lv_Where       := Lv_Where || ' IN ';
        --
        IF TRIM(Lv_TipoOrdenes) = 'ORDENES_PENDIENTES' OR
           TRIM(Lv_TipoOrdenes) = 'ORDENES_ACTIVAS' THEN
          --
          Lv_EstadosServicios := 'ESTADO_SERVICIO_ESPECIAL';
          --
        END IF;
        --
      END IF;
      --
      Lv_Where := Lv_Where || ' ( SELECT APD.DESCRIPCION ' ||
                  'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  'JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  'ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  'WHERE APD.ESTADO         = '''||Lv_EstadoActivo||''' ' ||
                  'AND APC.ESTADO           = '''||Lv_EstadoActivo||''' ' ||
                  'AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' ' ||
                  'AND APC.PROCESO          = '''||Lv_Proceso||''' ' ||
                  'AND APC.MODULO           = '''||Lv_Modulo||''' ' ||
                  'AND APD.VALOR2           = '''||Lv_EstadosServicios||''' ' ||
                  'AND APD.VALOR1           = NVL('''||Lv_TipoOrdenes||''', APD.VALOR1) ' ||
                  'AND APD.EMPRESA_COD      = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = '''||Lv_EstadoActivo||''' ' ||
                  'AND PREFIJO  = '''||Lv_PrefijoEmpresa||''') ) ';
      --
      IF Lv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        Lv_Where := Lv_Where ||
                    ' AND IDAS.MOTIVO_PADRE_CANCELACION = '''||Lv_MotivoPadreRegularizacion||''' ';
        --
      END IF;
      --
      IF TRIM(Lv_Frecuencia) IS NOT NULL AND TRIM(Lv_Frecuencia) = 'UNICA' THEN
        --
        Lv_FrecuenciaProducto := 0;
        Lv_Where              := Lv_Where ||
                                 'AND ( IDAS.FRECUENCIA_PRODUCTO = '''||Lv_FrecuenciaProducto||''' OR IDAS.FRECUENCIA_PRODUCTO IS NULL ) ';
        --
      ELSIF TRIM(Lv_Frecuencia) IS NOT NULL AND
            (TRIM(Lv_Frecuencia) = 'MENSUAL' OR
             TRIM(Lv_Frecuencia) = 'NO_MENSUAL') THEN
        --
        Lv_FrecuenciaProducto := 1;
        --
        IF TRIM(Lv_Frecuencia) = 'MENSUAL' THEN
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO = '''||Lv_FrecuenciaProducto||''' ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO > '''||Lv_FrecuenciaProducto||''' ';
          --
        END IF;
        --
      END IF;
      --
      --
      IF TRIM(Lv_Categoria) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND AP.LINEA_NEGOCIO = '''||Lv_Categoria||''' ';
        --
      ELSIF TRIM(Lv_Grupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.GRUPO = '''||Lv_Grupo||''' ';
        --
        --
      ELSIF TRIM(Lv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.SUBGRUPO = '''||Lv_Subgrupo||''' ';
        --
      END IF;
      --
      --
      IF TRIM(Lv_Categoria) IS NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                    ' AND APC.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                    ' AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' ' ||
                    ' AND APC.PROCESO = '''||Lv_Proceso||''' ' ||
                    ' AND APC.MODULO = '''||Lv_Modulo||''' ' ||
                    ' AND APD.VALOR1 = '''||Lv_ValorCategorias||''' ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                    '   AND IEG.PREFIJO = '''||Lv_PrefijoEmpresa||''' ' || ' ) ) ';
        --
      END IF;
      --
      --
      IF TRIM(Lv_TipoPersonal) IS NOT NULL AND Ln_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Lv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.ID_PERSONA_ROL = '''||Ln_IdPersonaEmpresaRol||''' ';
          --
        ELSIF (TRIM(Lv_TipoPersonal) IS NOT NULL OR Lv_TipoPersonal != 'VENDEDOR') THEN
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = '''||Ln_IdPersonaEmpresaRol||''' ';
          --
        END IF;
        --
        Lv_Where := Lv_Where || ' ) ';
        --
      END IF;
      --
      Lv_Query := Lv_SelectCaB || Lv_FromCabIni || Lv_Select ||  Lv_From || Lv_Where || Lv_FromCabFin || Lv_GroupBy;
      --
      IF Lv_OpcionSelect = 'DETALLE' THEN
        --
        Lv_NombreArchivo    := 'DetalladoVentas_' ||
                                Lv_PrefijoEmpresa || '_' ||
                                Lv_TipoOrdenes || '.csv';
        Lv_Gzip             := 'gzip /backup/repgerencia/' ||Lv_NombreArchivo;
        Lv_Destinatario     := NVL(Lv_EmailUsrSesion,Lv_EmailTelcos) || ',';
        Lv_Asunto           := 'Notificacion DETALLADO DE ' ||Lv_TipoOrdenes;
        Lv_NombreArchivoZip := Lv_NombreArchivo || '.gz';
        Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_Ventas_Dash');
        Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
        Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,
                                               Lv_NombreArchivo,
                                               'w',
                                               3000);
        --
        Lv_CamposAdicionales := NULL;
        --
        IF TRIM(Lv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_CamposAdicionales := 'MOTIVO PADRE CANCELACION' ||
                                  Lv_Delimitador || 'MOTIVO CANCELACION' ||
                                  Lv_Delimitador;
          --
        END IF;
        --
        --
        utl_file.put_line(Lfile_Archivo,
                          'OFICINA' || Lv_Delimitador || 'CLIENTE' ||
                          Lv_Delimitador || 'LOGIN' || Lv_Delimitador ||
                          'VENDEDOR' || Lv_Delimitador || 'ID_PRODUCTO' ||
                          Lv_Delimitador || 'DESCRIPCION PRODUCTO' ||
                          Lv_Delimitador || 'CATEGORIA' || Lv_Delimitador ||
                          'GRUPO' || Lv_Delimitador || 'SUBGRUPO' ||
                          Lv_Delimitador || 'ID SERVICIO' || Lv_Delimitador ||
                          'DESCRIPCION SERVICIO' || Lv_Delimitador ||
                          'FRECUENCIA PRODUCTO' || Lv_Delimitador ||
                          'ES VENTA' || Lv_Delimitador || 'ESTADO' ||
                          Lv_Delimitador || 'ACCION' || Lv_Delimitador ||
                          'FECHA CREACION' || Lv_Delimitador ||
                          'DIAS ACUMULADO CREACION' || Lv_Delimitador ||
                          'FECHA ESTADO' || Lv_Delimitador ||
                          'DIAS ACUMULADO ESTADO' || Lv_Delimitador ||
                          'USR ESTADO' || Lv_Delimitador ||
                          'ESTADO DEPARTAMENTO' || Lv_Delimitador ||
                          'PROPUESTA' || Lv_Delimitador ||
                          'VALOR MRC' || Lv_Delimitador || 'PRECIO VENTA' ||
                          Lv_Delimitador || 'DESCUENTO UNITARIO' ||
                          Lv_Delimitador || 'SUBTOTAL CON DESCUENTO' ||
                          Lv_Delimitador || 'CANTIDAD' || Lv_Delimitador ||
                          'SUBTOTAL' || Lv_Delimitador ||
                          'VALOR INSTALACION' || Lv_Delimitador ||
                          'V. INSTALACION (NRC)' || Lv_Delimitador ||
                          'VALOR TOTAL (SUBTOTAL + NRC)' || Lv_Delimitador ||
                          Lv_CamposAdicionales);
        --
        OPEN Pr_Informacion FOR Lv_Query;
        LOOP
          FETCH Pr_Informacion BULK COLLECT INTO Lr_OrdenesVendidasProcesar LIMIT 100000000;
          Ln_Indx:=Lr_OrdenesVendidasProcesar.FIRST;
          WHILE (Ln_Indx IS NOT NULL)
          LOOP
            Lr_OrdenesVendidas   := Lr_OrdenesVendidasProcesar(Ln_Indx);
            Ln_Indx              := Lr_OrdenesVendidasProcesar.NEXT(Ln_Indx);
            Lv_RegistroAdicional := NULL;
            --
            IF TRIM(Lv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
              --
              Lv_RegistroAdicional := Lr_OrdenesVendidas.MOTIVO_PADRE_CANCELACION ||
                                      Lv_Delimitador ||
                                      Lr_OrdenesVendidas.MOTIVO_CANCELACION ||
                                      Lv_Delimitador;
              --
            END IF;
            --
            utl_file.put_line(Lfile_Archivo,
                              Lr_OrdenesVendidas.NOMBRE_OFICINA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.CLIENTE ||
                              Lv_Delimitador || Lr_OrdenesVendidas.LOGIN ||
                              Lv_Delimitador || Lr_OrdenesVendidas.USR_VENDEDOR ||
                              Lv_Delimitador || Lr_OrdenesVendidas.PRODUCTO_ID ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DESCRIPCION_PRODUCTO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.CATEGORIA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.GRUPO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.SUBGRUPO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.ID_SERVICIO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DESCRIPCION_PRESENTA_FACTURA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.FRECUENCIA_PRODUCTO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.ES_VENTA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.ACCION ||
                              Lv_Delimitador || Lr_OrdenesVendidas.FE_CREACION ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DIAS_ACUMULADO_CREACION ||
                              Lv_Delimitador || Lr_OrdenesVendidas.FE_ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DIAS_ACUMULADO_ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.USR_ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DEPARTAMENTO_ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.PROPUESTA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.MRC ||
                              Lv_Delimitador || Lr_OrdenesVendidas.PRECIO_VENTA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DESCUENTO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.SUBTOTAL_CON_DESCUENTO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.CANTIDAD ||
                              Lv_Delimitador || Lr_OrdenesVendidas.SUBTOTAL ||
                              Lv_Delimitador || Lr_OrdenesVendidas.PRECIO_INSTALACION ||
                              Lv_Delimitador || Lr_OrdenesVendidas.VALOR_INSTALACION_MENSUAL ||
                              Lv_Delimitador || Lr_OrdenesVendidas.VALOR_TOTAL ||
                              Lv_Delimitador || Lv_RegistroAdicional);
          END LOOP;
          EXIT WHEN Pr_Informacion%NOTFOUND; 
          --
        END LOOP;
        CLOSE Pr_Informacion;
        --
        UTL_FILE.fclose(Lfile_Archivo);
        --
        DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lv_Gzip));
        --
        DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lv_Remitente,
                                                  Lv_Destinatario,
                                                  Lv_Asunto,
                                                  Lv_Cuerpo,
                                                  Lv_Directorio,
                                                  Lv_NombreArchivoZip);
        --
        UTL_FILE.FREMOVE(Lv_Directorio, Lv_NombreArchivoZip);
        --
        Pr_Informacion      := null;
        Pv_MensajeRespuesta := 'Reporte generado y enviado al mail exitosamente';
        --
      ELSE
        --
        OPEN Pr_Informacion FOR Lv_Query;
        Pv_MensajeRespuesta := 'Proceso OK';
        --
      END IF;
      --
      
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Lv_PrefijoEmpresa || '), FeInicio( ' ||
                         Lv_FechaInicio || '), FeFin( ' || Lv_FechaFin ||
                         '), TipoOrdenes( ' || Lv_TipoOrdenes ||
                         '), Categoria(' || Lv_Categoria || '), Grupo(' ||
                         Lv_Grupo || '), Subgrupo(' || Lv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pv_MensajeRespuesta := Lv_MensajeError;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_ORDENES_TELCOS_CRM',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pv_MensajeRespuesta := 'Error al consultar las ordenes de servicio';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_ORDENES_TELCOS_CRM',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_ORDENES_TELCOS_CRM;

  FUNCTION F_GET_NUM_DIAS_ESTADO(FnIdServicio     IN NUMBER,
                                 FvEstadoServicio IN VARCHAR2,
                                 FvRetornar       IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetNumDiasEstado(CnIdServicio VARCHAR2,CvEstado VARCHAR2) IS
    --
      SELECT
        DIAS_ACUMULADO,
        FE_CREACION
      FROM
      (
        SELECT ROUND((SYSDATE - TRUNC(ISERH.FE_CREACION)), 0)-1 AS DIAS_ACUMULADO,
               TO_CHAR(ISERH.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS') AS FE_CREACION
          FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
        WHERE ISERH.SERVICIO_ID = CnIdServicio
          AND ISERH.ESTADO      = CvEstado
          ORDER BY
            ISERH.FE_CREACION DESC)
      WHERE
          ROWNUM = 1;
    --
    Lv_Respuesta        VARCHAR2(100):='3';
    Lr_GetNumDiasEstado C_GetNumDiasEstado%ROWTYPE;
    --
  BEGIN
    --
    IF C_GetNumDiasEstado%ISOPEN THEN
      CLOSE C_GetNumDiasEstado;
    END IF;
    --
    OPEN C_GetNumDiasEstado(FnIdServicio,FvEstadoServicio);
    --
    FETCH C_GetNumDiasEstado
      INTO Lr_GetNumDiasEstado;
    --
    CLOSE C_GetNumDiasEstado;
    --
    IF Lr_GetNumDiasEstado.FE_CREACION IS NOT NULL THEN
    --
      IF FvRetornar ='NUM_DIAS' THEN
        --
        Lv_Respuesta := NVL(Lr_GetNumDiasEstado.DIAS_ACUMULADO, NULL);
        --
      ELSIF FvRetornar = 'FECHA' THEN
        --
        Lv_Respuesta := NVL(Lr_GetNumDiasEstado.FE_CREACION, NULL);
        --
      END IF;
        --
    END IF;
    --
    RETURN Lv_Respuesta;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_Respuesta := 0;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_NUM_DIAS_ESTADO',
                                           'Error al consultar la informacion - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'telcos'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
      RETURN Lv_Respuesta;
      --
  END F_GET_NUM_DIAS_ESTADO;

  FUNCTION F_GET_DEPARTAMENTO_SERVICIO(FnIdServicio     IN NUMBER,
                                       FvEstadoServicio IN VARCHAR2,
                                       FvPrefijo        IN VARCHAR2,
                                       FvRetornar       IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetPersonaDepartamento(CnIdServicio     NUMBER,
                                    CvEstadoServicio VARCHAR2,
                                    Cv_Prefijo       VARCHAR2,
                                    CvEstadoActivo   VARCHAR2) IS
    --
      SELECT
        NOMBRE_DEPARTAMENTO,
        NOMBRES_COMPLETOS
      FROM
      (
        SELECT
            AD.NOMBRE_DEPARTAMENTO             AS NOMBRE_DEPARTAMENTO,
            IPE.NOMBRES || ' ' ||IPE.APELLIDOS AS NOMBRES_COMPLETOS
        FROM
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL         ISERH
            JOIN DB_COMERCIAL.INFO_PERSONA               IPE   ON ISERH.USR_CREACION = IPE.LOGIN
            JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL   IPER  ON IPER.PERSONA_ID    = IPE.ID_PERSONA
            JOIN DB_GENERAL.ADMI_DEPARTAMENTO            AD    ON AD.ID_DEPARTAMENTO = IPER.DEPARTAMENTO_ID
            JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO         IEG   ON IEG.COD_EMPRESA    = AD.EMPRESA_COD
            
        WHERE
            ISERH.SERVICIO_ID     = CnIdServicio
            AND AD.ESTADO         = CvEstadoActivo
            AND IEG.PREFIJO       = Cv_Prefijo
            AND ISERH.ESTADO      = CvEstadoServicio
        ORDER BY
            ISERH.FE_CREACION DESC)
      WHERE
          ROWNUM = 1;
    --
    Lv_Respuesta              VARCHAR2(100) :='';
    Lv_EstadoActivo           VARCHAR2(100) := 'Activo';
    lr_GetPersonaDepartamento C_GetPersonaDepartamento%ROWTYPE;
    --
  BEGIN
    --
    IF C_GetPersonaDepartamento%ISOPEN THEN
      CLOSE C_GetPersonaDepartamento;
    END IF;
    --
    OPEN C_GetPersonaDepartamento(FnIdServicio,FvEstadoServicio,FvPrefijo,Lv_EstadoActivo);
    --
    FETCH C_GetPersonaDepartamento
      INTO lr_GetPersonaDepartamento;
    --
    CLOSE C_GetPersonaDepartamento;
    --
    IF lr_GetPersonaDepartamento.NOMBRES_COMPLETOS IS NOT NULL THEN
      --
      IF FvRetornar ='DEPARTAMENTO' THEN
        --
        Lv_Respuesta := NVL(lr_GetPersonaDepartamento.NOMBRE_DEPARTAMENTO, NULL);
        --
      ELSIF FvRetornar = 'PERSONA' THEN
        --
        Lv_Respuesta := NVL(lr_GetPersonaDepartamento.NOMBRES_COMPLETOS, NULL);
      --
      END IF;
      --
    END IF;
    --
    RETURN Lv_Respuesta;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_Respuesta := '';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_DEPARTAMENTO_SERVICIO',
                                           'Error al consultar la informacion - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'telcos'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
      RETURN Lv_Respuesta;
      --
  END F_GET_DEPARTAMENTO_SERVICIO;

  PROCEDURE P_SERVICIO_POR_SERIE_ELEMENTO(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lv_SerieFisica                VARCHAR2(100);
    Lcl_Select                    CLOB;
    Lcl_From                      CLOB;
    Lcl_Where                     CLOB;
    Lcl_Query                     CLOB;
    Ln_IdElemento                 NUMBER;
    Ln_IdServicio                 NUMBER;
    Ln_IdInterface                NUMBER;
    Ln_IdElementoCli              NUMBER;
    Ln_IdInterfaceCli             NUMBER;
    Lv_NombreElemento             VARCHAR2(100);
    Lv_LoginAux                   VARCHAR2(100);
    Lv_FormaContacto              VARCHAR2(30)    := 'Correo Electronico';
    Lv_EstadoActivo               VARCHAR2(10)    := 'Activo';
    Lv_EstadoConnect              VARCHAR2(10)    := 'connected';
    Lv_TipoEnlaceBackup           VARCHAR2(15)    := 'BACKUP';
    Lv_StandAloneNombre           VARCHAR2(15)    := 'PROPIEDAD';
    Lv_StandAloneDetalle          VARCHAR2(30)    := 'ELEMENTO PROPIEDAD DE';
    Lv_StandAloneValor            VARCHAR2(15)    := 'CLIENTE';
    Lv_ParametroModelo            VARCHAR2(64)    := 'NOMBRES_MODELOS_REEMPLAZAR_FORTIGATE_PORTAL';

    Ln_IdElementoEnl              NUMBER;
    Ln_IdIniInterface             NUMBER;
    Ln_IdFinInterface             NUMBER;
    Ln_ContInteraciones           NUMBER          := 0;
    Ln_MaxInteraciones            NUMBER          := 30;
    Lb_BanderaEnlace              BOOLEAN         := FALSE;
    Le_Errors                     EXCEPTION;

    CURSOR C_ObtenerDatosElemento(Cv_SerieElemento DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE)
    IS
        SELECT ID_ELEMENTO, NOMBRE_ELEMENTO FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO 
        WHERE SERIE_FISICA = Cv_SerieElemento
        AND ESTADO = Lv_EstadoActivo
        AND ROWNUM = 1;

    CURSOR C_ObtenerIdInterface(Cn_IdElemento DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID%TYPE)
    IS
        SELECT ID_INTERFACE_ELEMENTO FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
        WHERE ELEMENTO_ID = Cn_IdElemento
        AND ESTADO = Lv_EstadoConnect;

    CURSOR C_GetDatosServicioPorIntLogin(Cn_InterfaceCliente DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
        Cv_LoginAux DB_COMERCIAL.INFO_SERVICIO.LOGIN_AUX%TYPE)
    IS
        SELECT * FROM (
            SELECT SER.ID_SERVICIO, SER.LOGIN_AUX, TEC.INTERFACE_ELEMENTO_ID, TEC.ELEMENTO_CLIENTE_ID, TEC.INTERFACE_ELEMENTO_CLIENTE_ID
            FROM DB_COMERCIAL.INFO_SERVICIO SER
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TEC ON TEC.SERVICIO_ID = SER.ID_SERVICIO
            WHERE ( TEC.INTERFACE_ELEMENTO_ID = Cn_InterfaceCliente OR TEC.INTERFACE_ELEMENTO_CLIENTE_ID = Cn_InterfaceCliente )
            AND SER.LOGIN_AUX = Cv_LoginAux
            AND TEC.TIPO_ENLACE != Lv_TipoEnlaceBackup
            ORDER BY SER.FE_CREACION DESC
        ) WHERE ROWNUM = 1;

    CURSOR C_GetDatosServicioPorLogin(Cb_NombreElemento DB_COMERCIAL.INFO_SERVICIO.LOGIN_AUX%TYPE)
    IS
        SELECT * FROM (
            SELECT SER.ID_SERVICIO, SER.LOGIN_AUX, TEC.INTERFACE_ELEMENTO_ID, TEC.ELEMENTO_CLIENTE_ID, TEC.INTERFACE_ELEMENTO_CLIENTE_ID
            FROM DB_COMERCIAL.INFO_SERVICIO SER
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TEC ON TEC.SERVICIO_ID = SER.ID_SERVICIO
            WHERE TEC.TIPO_ENLACE != Lv_TipoEnlaceBackup
            AND SER.LOGIN_AUX = Cb_NombreElemento
            ORDER BY SER.FE_CREACION DESC
        ) WHERE ROWNUM = 1;

    CURSOR C_GetDatosServicioPorInt(Cn_InterfaceCliente DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE)
    IS
        SELECT * FROM (
            SELECT SER.ID_SERVICIO, SER.LOGIN_AUX, TEC.INTERFACE_ELEMENTO_ID, TEC.ELEMENTO_CLIENTE_ID, TEC.INTERFACE_ELEMENTO_CLIENTE_ID
            FROM DB_COMERCIAL.INFO_SERVICIO SER
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TEC ON TEC.SERVICIO_ID = SER.ID_SERVICIO
            WHERE ( TEC.INTERFACE_ELEMENTO_ID = Cn_InterfaceCliente OR TEC.INTERFACE_ELEMENTO_CLIENTE_ID = Cn_InterfaceCliente )
            AND TEC.TIPO_ENLACE != Lv_TipoEnlaceBackup
            ORDER BY SER.FE_CREACION DESC
        ) WHERE ROWNUM = 1;

    CURSOR C_ObtenerInterfaceIniId(Cn_IdIniInterface DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_FIN_ID%TYPE)
    IS
        SELECT * FROM (
            SELECT INTERFACE_ELEMENTO_INI_ID FROM DB_INFRAESTRUCTURA.INFO_ENLACE
            WHERE INTERFACE_ELEMENTO_FIN_ID = Cn_IdIniInterface
            AND ESTADO = Lv_EstadoActivo
            ORDER BY FE_CREACION ASC
        ) WHERE ROWNUM = 1;

    BEGIN
        -- RETORNO LAS VARIABLES DEL REQUEST
        APEX_JSON.PARSE(Pcl_Request);
        Lv_SerieFisica := APEX_JSON.get_varchar2(p_path => 'serie');

        --obtener datos del elemento
        OPEN C_ObtenerDatosElemento(Lv_SerieFisica);
        FETCH C_ObtenerDatosElemento INTO Ln_IdElemento, Lv_NombreElemento;
        CLOSE C_ObtenerDatosElemento;

        --verificar si se encontro el elemento
        IF Ln_IdElemento IS NULL THEN
            Pv_Mensaje := 'No se encontr閿燂拷 el elemento con la serie ' || Lv_SerieFisica || 
                          ', por favor notificar a Sistemas.';
            RAISE Le_Errors;
        END IF;

        --buscar servicio por el login
        OPEN C_GetDatosServicioPorLogin(Lv_NombreElemento);
        FETCH C_GetDatosServicioPorLogin INTO Ln_IdServicio, Lv_LoginAux, Ln_IdInterface, Ln_IdElementoCli, Ln_IdInterfaceCli;
        CLOSE C_GetDatosServicioPorLogin;
        --verificar si se encontro el servicio
        IF Ln_IdServicio IS NOT NULL THEN
            Pv_Status := 'OK';
        END IF;

        IF Ln_IdServicio IS NULL THEN
            --busqueda del servicio por enlace
            IF C_ObtenerIdInterface%ISOPEN THEN
                CLOSE C_ObtenerIdInterface;
            END IF;
            --recorrer los id de la interface del elemento
            FOR I_GetInterface IN C_ObtenerIdInterface(Ln_IdElemento)
            LOOP
                --buscar servicio por el id de interface del cliente
                OPEN C_GetDatosServicioPorInt(I_GetInterface.ID_INTERFACE_ELEMENTO);
                FETCH C_GetDatosServicioPorInt INTO Ln_IdServicio, Lv_LoginAux, Ln_IdInterface, Ln_IdElementoCli, Ln_IdInterfaceCli;
                CLOSE C_GetDatosServicioPorInt;
                --finalizar loop si se encontro el servicio
                IF Ln_IdServicio IS NOT NULL THEN
                    Pv_Status := 'OK';
                    EXIT;
                END IF;
                --setear las variables del while
                Ln_ContInteraciones := 0;
                Lb_BanderaEnlace    := FALSE;
                --seteo el id ini de la interface
                Ln_IdIniInterface := I_GetInterface.ID_INTERFACE_ELEMENTO;
                --se recorre el while para buscar el enlace a travez del id interface
                WHILE Lb_BanderaEnlace = FALSE
                LOOP
                    --obtener el id ini de la interface
                    OPEN C_ObtenerInterfaceIniId(Ln_IdIniInterface);
                    FETCH C_ObtenerInterfaceIniId INTO Ln_IdIniInterface;
                    CLOSE C_ObtenerInterfaceIniId;
                    --obtener los datos del servicio por interface y login auxiliar
                    OPEN C_GetDatosServicioPorIntLogin(Ln_IdIniInterface,Lv_NombreElemento);
                    FETCH C_GetDatosServicioPorIntLogin INTO Ln_IdServicio, Lv_LoginAux, Ln_IdInterface, Ln_IdElementoCli, Ln_IdInterfaceCli;
                    CLOSE C_GetDatosServicioPorIntLogin;
                    --comparo el id del elemento
                    IF Ln_IdServicio IS NOT NULL THEN
                        Pv_Status := 'OK';
                        Lb_BanderaEnlace := TRUE;
                        EXIT;
                    END IF;
                    --obtener los datos del servicio por interface
                    OPEN C_GetDatosServicioPorInt(Ln_IdIniInterface);
                    FETCH C_GetDatosServicioPorInt INTO Ln_IdServicio, Lv_LoginAux, Ln_IdInterface, Ln_IdElementoCli, Ln_IdInterfaceCli;
                    CLOSE C_GetDatosServicioPorInt;
                    --comparo el id del elemento
                    IF Ln_IdServicio IS NOT NULL THEN
                        Pv_Status := 'OK';
                        Lb_BanderaEnlace := TRUE;
                        EXIT;
                    END IF;
                    --contar interaciones
                    Ln_ContInteraciones := Ln_ContInteraciones + 1;
                    --verifico si llego el maximo de numeros de interaciones
                    IF Ln_ContInteraciones >= Ln_MaxInteraciones THEN
                        Pv_Status := 'ERROR';
                        Lb_BanderaEnlace := TRUE;
                        EXIT;
                    END IF;
                END LOOP;
                --finalizar loop si se encontro el servicio
                IF Ln_IdServicio IS NOT NULL THEN
                    Pv_Status := 'OK';
                    EXIT;
                END IF;
            END LOOP;
        END IF;

        --verifico si se encontro el servicio
        IF Pv_Status = 'ERROR' THEN
            Pv_Mensaje := 'No se encontr閿燂拷 el enlace relacionado del servicio con login auxiliar ' ||
                          Lv_NombreElemento || ' con la serie ' || Lv_SerieFisica ||
                          ', por favor notificar a Sistemas.';
            RAISE Le_Errors;
        END IF;

        --verifico si el id del servicio esta vacio
        IF Ln_IdServicio IS NULL THEN
            Pv_Status := 'ERROR';
            Pv_Mensaje := 'No se encontr閿燂拷 ningun servicio asociado a este elemento ' || Lv_NombreElemento ||
                          ' con la serie ' || Lv_SerieFisica || ', por favor notificar a Sistemas.';
            RAISE Le_Errors;
        END IF;

        Lcl_Select  := 'SELECT SER.ID_SERVICIO, ELE.ID_ELEMENTO, PUN.LOGIN, SER.LOGIN_AUX, SER.ESTADO,
                        MAR.NOMBRE_MARCA_ELEMENTO MARCA, ELE.SERIE_FISICA SERIE, PRO.DESCRIPCION_PRODUCTO, MOD.NOMBRE_MODELO_ELEMENTO,
                        CAN.NOMBRE_CANTON CIUDAD, CAN.SIGLA SIGLA_CIUDAD, PER.RAZON_SOCIAL CLIENTE,
                        ( SELECT REMOD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET REMOD WHERE REMOD.VALOR1 = MOD.NOMBRE_MODELO_ELEMENTO
                          AND REMOD.PARAMETRO_ID = ( SELECT CREMOD.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB CREMOD
                            WHERE CREMOD.NOMBRE_PARAMETRO = ''' || Lv_ParametroModelo || ''' AND CREMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 )
                          AND REMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) MODELO,
                        ( SELECT PCOR.VALOR FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PCOR, DB_COMERCIAL.ADMI_FORMA_CONTACTO FCON
                          WHERE PCOR.FORMA_CONTACTO_ID = FCON.ID_FORMA_CONTACTO AND PCOR.ESTADO = ''' || Lv_EstadoActivo || '''
                          AND PCOR.PUNTO_ID = PUN.ID_PUNTO AND FCON.DESCRIPCION_FORMA_CONTACTO = ''' || Lv_FormaContacto || ''' AND ROWNUM = 1 ) CORREO,
                        ( SELECT CASE WHEN DELE.DETALLE_VALOR = ''' || Lv_StandAloneValor || ''' THEN ''SI'' ELSE ''NO'' END AS VALOR
                          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DELE
                          WHERE DELE.ELEMENTO_ID = ELE.ID_ELEMENTO AND DELE.DETALLE_NOMBRE = ''' || Lv_StandAloneNombre || '''
                          AND DELE.DETALLE_DESCRIPCION = ''' || Lv_StandAloneDetalle || '''
                          AND DELE.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) ES_STAND_ALONE';
        Lcl_From    := ' FROM DB_COMERCIAL.INFO_SERVICIO SER, DB_COMERCIAL.INFO_PUNTO PUN, DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE,
                        DB_COMERCIAL.ADMI_PRODUCTO PRO, DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD, DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR,
                        DB_GENERAL.ADMI_SECTOR SEC, DB_GENERAL.ADMI_PARROQUIA PAR, DB_GENERAL.ADMI_CANTON CAN,
                        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERE, DB_COMERCIAL.INFO_PERSONA PER';
        Lcl_Where   := ' WHERE SER.PUNTO_ID = PUN.ID_PUNTO
                        AND SER.PRODUCTO_ID = PRO.ID_PRODUCTO
                        AND ELE.MODELO_ELEMENTO_ID = MOD.ID_MODELO_ELEMENTO
                        AND MOD.MARCA_ELEMENTO_ID = MAR.ID_MARCA_ELEMENTO
                        AND SEC.ID_SECTOR = PUN.SECTOR_ID
                        AND PAR.ID_PARROQUIA = SEC.PARROQUIA_ID
                        AND CAN.ID_CANTON = PAR.CANTON_ID
                        AND PERE.ID_PERSONA_ROL = PUN.PERSONA_EMPRESA_ROL_ID
                        AND PER.ID_PERSONA = PERE.PERSONA_ID';

        Lcl_Where := Lcl_Where || ' AND ELE.ID_ELEMENTO = ' || Ln_IdElemento;
        Lcl_Where := Lcl_Where || ' AND SER.ID_SERVICIO = ' || Ln_IdServicio;
        Lcl_Query := 'SELECT ID_SERVICIO, ID_ELEMENTO, LOGIN, LOGIN_AUX, ESTADO, MARCA, SERIE, DESCRIPCION_PRODUCTO, CORREO, ES_STAND_ALONE,
                      CASE WHEN MODELO IS NOT NULL THEN MODELO ELSE NOMBRE_MODELO_ELEMENTO END AS MODELO, CIUDAD, SIGLA_CIUDAD, CLIENTE
                      FROM ( ' || Lcl_Select || Lcl_From || Lcl_Where || ' )';
        OPEN Pcl_Response FOR Lcl_Query;

        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacci閿熺单 exitosa';
    EXCEPTION
        WHEN Le_Errors THEN
            Pv_Status  := 'ERROR';
        WHEN OTHERS THEN
            Pv_Status  := 'ERROR';
            Pv_Mensaje := SQLERRM;
  END P_SERVICIO_POR_SERIE_ELEMENTO;

    PROCEDURE P_GET_SERVICIO_ACTIVAR_SERIE(Pv_Status OUT VARCHAR2,
                                   Pv_Mensaje         OUT VARCHAR2,
                                   Pcl_Response       OUT SYS_REFCURSOR)
    AS
      Lcl_Query                     CLOB;
      Lv_FormaContacto              VARCHAR2(30)    := 'Correo Electronico';
      Lv_EstadoActivo               VARCHAR2(10)    := 'Activo';
      Lv_EstadoPendiente            VARCHAR2(10)    := 'Pendiente';
      Lv_StandAloneNombre           VARCHAR2(15)    := 'PROPIEDAD';
      Lv_StandAloneDetalle          VARCHAR2(30)    := 'ELEMENTO PROPIEDAD DE';
      Lv_StandAloneValor            VARCHAR2(15)    := 'CLIENTE';
      Lv_MarcaElemento              VARCHAR2(20)    := 'FORTIGATE';
      Lv_TipoSolicitud              VARCHAR2(45)    := 'SOLICITUD RPA LICENCIA';
      Lv_ParametroModelo            VARCHAR2(64)    := 'NOMBRES_MODELOS_REEMPLAZAR_FORTIGATE_PORTAL';
      --
      BEGIN
          --formar el query
          Lcl_Query  := 'SELECT ID_DETALLE_SOLICITUD, ID_SERVICIO, ID_ELEMENTO, LOGIN, LOGIN_AUX, ESTADO, MARCA, SERIE, DESCRIPCION_PRODUCTO,
                            CASE WHEN MODELO IS NOT NULL THEN MODELO ELSE NOMBRE_MODELO_ELEMENTO END AS MODELO, CORREO, ES_STAND_ALONE,
                            CLIENTE, CIUDAD, SIGLA_CIUDAD
                         FROM (
                            SELECT SOL.ID_DETALLE_SOLICITUD, SER.ID_SERVICIO, ELE.ID_ELEMENTO, PUN.LOGIN, SER.LOGIN_AUX, SER.ESTADO,
                            MAR.NOMBRE_MARCA_ELEMENTO MARCA, ELE.SERIE_FISICA SERIE, PRO.DESCRIPCION_PRODUCTO, MOD.NOMBRE_MODELO_ELEMENTO,
                            CAN.NOMBRE_CANTON CIUDAD, CAN.SIGLA SIGLA_CIUDAD, PER.RAZON_SOCIAL CLIENTE,
                            ( SELECT REMOD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET REMOD WHERE REMOD.VALOR1 = MOD.NOMBRE_MODELO_ELEMENTO
                              AND REMOD.PARAMETRO_ID = ( SELECT CREMOD.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB CREMOD
                                WHERE CREMOD.NOMBRE_PARAMETRO = ''' || Lv_ParametroModelo || ''' AND CREMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 )
                              AND REMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) MODELO,
                            ( SELECT PCOR.VALOR FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PCOR, DB_COMERCIAL.ADMI_FORMA_CONTACTO FCON
                              WHERE PCOR.FORMA_CONTACTO_ID = FCON.ID_FORMA_CONTACTO AND PCOR.ESTADO = ''' || Lv_EstadoActivo || '''
                              AND PCOR.PUNTO_ID = PUN.ID_PUNTO AND FCON.DESCRIPCION_FORMA_CONTACTO = ''' || Lv_FormaContacto || ''' AND ROWNUM = 1 ) CORREO,
                            ( SELECT CASE WHEN DELE.DETALLE_VALOR = ''' || Lv_StandAloneValor || ''' THEN ''SI'' ELSE ''NO'' END AS VALOR
                              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DELE
                              WHERE DELE.ELEMENTO_ID = ELE.ID_ELEMENTO AND DELE.DETALLE_NOMBRE = ''' || Lv_StandAloneNombre || '''
                              AND DELE.DETALLE_DESCRIPCION = ''' || Lv_StandAloneDetalle || '''
                              AND DELE.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) ES_STAND_ALONE
                            FROM DB_COMERCIAL.INFO_SERVICIO SER, DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL, DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIP,
                            DB_COMERCIAL.INFO_PUNTO PUN, DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE, DB_COMERCIAL.ADMI_PRODUCTO PRO,
                            DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD, DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR,
                            DB_GENERAL.ADMI_SECTOR SEC, DB_GENERAL.ADMI_PARROQUIA PAR, DB_GENERAL.ADMI_CANTON CAN,
                            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERE, DB_COMERCIAL.INFO_PERSONA PER
                            WHERE TIP.DESCRIPCION_SOLICITUD = ''' || Lv_TipoSolicitud || '''
                            AND TIP.ID_TIPO_SOLICITUD = SOL.TIPO_SOLICITUD_ID
                            AND SER.ID_SERVICIO = SOL.SERVICIO_ID
                            AND SER.PUNTO_ID = PUN.ID_PUNTO
                            AND SER.PRODUCTO_ID = PRO.ID_PRODUCTO
                            AND ELE.NOMBRE_ELEMENTO = SER.LOGIN_AUX
                            AND ELE.MODELO_ELEMENTO_ID = MOD.ID_MODELO_ELEMENTO
                            AND MOD.MARCA_ELEMENTO_ID = MAR.ID_MARCA_ELEMENTO
                            AND SEC.ID_SECTOR = PUN.SECTOR_ID
                            AND PAR.ID_PARROQUIA = SEC.PARROQUIA_ID
                            AND CAN.ID_CANTON = PAR.CANTON_ID
                            AND PERE.ID_PERSONA_ROL = PUN.PERSONA_EMPRESA_ROL_ID
                            AND PER.ID_PERSONA = PERE.PERSONA_ID
                            AND MAR.NOMBRE_MARCA_ELEMENTO = ''' || Lv_MarcaElemento || '''
                            AND SOL.ESTADO = ''' || Lv_EstadoPendiente || '''
                            AND SER.ESTADO = ''' || Lv_EstadoActivo || '''
                            AND ELE.ESTADO = ''' || Lv_EstadoActivo || '''
                            ORDER BY SOL.FE_CREACION ASC
                        )
                        WHERE ROWNUM = 1';
          OPEN Pcl_Response FOR Lcl_Query;
          --resultados
          Pv_Status     := 'OK';
          Pv_Mensaje    := 'Transacci閿熺单 exitosa';
      EXCEPTION
          WHEN OTHERS THEN
              Pv_Status  := 'ERROR';
              Pv_Mensaje := SQLERRM;
    END P_GET_SERVICIO_ACTIVAR_SERIE;

    PROCEDURE P_GET_SERVICIO_LICENCIA_RPA(Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT SYS_REFCURSOR)
    AS
      Lcl_Query                     CLOB;
      Lv_FormaContacto              VARCHAR2(30)    := 'Correo Electronico';
      Lv_EstadoActivo               VARCHAR2(10)    := 'Activo';
      Lv_EstadoCancel               VARCHAR2(10)    := 'Cancel';
      Lv_EstadoEliminado            VARCHAR2(10)    := 'Eliminado';
      Lv_EstadoPendiente            VARCHAR2(10)    := 'Pendiente';
      Lv_StandAloneNombre           VARCHAR2(15)    := 'PROPIEDAD';
      Lv_StandAloneDetalle          VARCHAR2(30)    := 'ELEMENTO PROPIEDAD DE';
      Lv_StandAloneValor            VARCHAR2(15)    := 'CLIENTE';
      Lv_MarcaElemento              VARCHAR2(20)    := 'FORTIGATE';
      Lv_TipoSolicitud              VARCHAR2(45)    := 'SOLICITUD RPA CANCELACION LICENCIA';
      Lv_ParametroModelo            VARCHAR2(64)    := 'NOMBRES_MODELOS_REEMPLAZAR_FORTIGATE_PORTAL';
      --
      BEGIN
          --formar el query
          Lcl_Query  := 'SELECT ID_DETALLE_SOLICITUD, ID_SERVICIO, ID_ELEMENTO, LOGIN, LOGIN_AUX, ESTADO, MARCA, SERIE, DESCRIPCION_PRODUCTO,
                            CASE WHEN MODELO IS NOT NULL THEN MODELO ELSE NOMBRE_MODELO_ELEMENTO END AS MODELO, CORREO, ES_STAND_ALONE,
                            CLIENTE, CIUDAD, SIGLA_CIUDAD
                         FROM (
                            SELECT SOL.ID_DETALLE_SOLICITUD, SER.ID_SERVICIO, ELE.ID_ELEMENTO, PUN.LOGIN, SER.LOGIN_AUX, SER.ESTADO,
                            MAR.NOMBRE_MARCA_ELEMENTO MARCA, ELE.SERIE_FISICA SERIE, PRO.DESCRIPCION_PRODUCTO, MOD.NOMBRE_MODELO_ELEMENTO,
                            CAN.NOMBRE_CANTON CIUDAD, CAN.SIGLA SIGLA_CIUDAD, PER.RAZON_SOCIAL CLIENTE,
                            ( SELECT REMOD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET REMOD WHERE REMOD.VALOR1 = MOD.NOMBRE_MODELO_ELEMENTO
                              AND REMOD.PARAMETRO_ID = ( SELECT CREMOD.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB CREMOD
                                WHERE CREMOD.NOMBRE_PARAMETRO = ''' || Lv_ParametroModelo || ''' AND CREMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 )
                              AND REMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) MODELO,
                            ( SELECT PCOR.VALOR FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PCOR, DB_COMERCIAL.ADMI_FORMA_CONTACTO FCON
                              WHERE PCOR.FORMA_CONTACTO_ID = FCON.ID_FORMA_CONTACTO AND PCOR.ESTADO = ''' || Lv_EstadoActivo || '''
                              AND PCOR.PUNTO_ID = PUN.ID_PUNTO AND FCON.DESCRIPCION_FORMA_CONTACTO = ''' || Lv_FormaContacto || ''' AND ROWNUM = 1 ) CORREO,
                            ( SELECT CASE WHEN DELE.DETALLE_VALOR = ''' || Lv_StandAloneValor || ''' THEN ''SI'' ELSE ''NO'' END AS VALOR
                              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DELE
                              WHERE DELE.ELEMENTO_ID = ELE.ID_ELEMENTO AND DELE.DETALLE_NOMBRE = ''' || Lv_StandAloneNombre || '''
                              AND DELE.DETALLE_DESCRIPCION = ''' || Lv_StandAloneDetalle || '''
                              AND DELE.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) ES_STAND_ALONE
                            FROM DB_COMERCIAL.INFO_SERVICIO SER, DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL, DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIP,
                            DB_COMERCIAL.INFO_PUNTO PUN, DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE, DB_COMERCIAL.ADMI_PRODUCTO PRO,
                            DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD, DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR,
                            DB_GENERAL.ADMI_SECTOR SEC, DB_GENERAL.ADMI_PARROQUIA PAR, DB_GENERAL.ADMI_CANTON CAN,
                            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERE, DB_COMERCIAL.INFO_PERSONA PER
                            WHERE TIP.DESCRIPCION_SOLICITUD = ''' || Lv_TipoSolicitud || '''
                            AND TIP.ID_TIPO_SOLICITUD = SOL.TIPO_SOLICITUD_ID
                            AND SER.ID_SERVICIO = SOL.SERVICIO_ID
                            AND SER.PUNTO_ID = PUN.ID_PUNTO
                            AND SER.PRODUCTO_ID = PRO.ID_PRODUCTO
                            AND ELE.NOMBRE_ELEMENTO = SER.LOGIN_AUX
                            AND ELE.MODELO_ELEMENTO_ID = MOD.ID_MODELO_ELEMENTO
                            AND MOD.MARCA_ELEMENTO_ID = MAR.ID_MARCA_ELEMENTO
                            AND SEC.ID_SECTOR = PUN.SECTOR_ID
                            AND PAR.ID_PARROQUIA = SEC.PARROQUIA_ID
                            AND CAN.ID_CANTON = PAR.CANTON_ID
                            AND PERE.ID_PERSONA_ROL = PUN.PERSONA_EMPRESA_ROL_ID
                            AND PER.ID_PERSONA = PERE.PERSONA_ID
                            AND MAR.NOMBRE_MARCA_ELEMENTO = ''' || Lv_MarcaElemento || '''
                            AND SOL.ESTADO = ''' || Lv_EstadoPendiente || '''
                            AND SER.ESTADO = ''' || Lv_EstadoCancel || '''
                            AND ( ELE.ESTADO = ''' || Lv_EstadoActivo || ''' OR ELE.ESTADO = ''' || Lv_EstadoEliminado || ''' )
                            ORDER BY SOL.FE_CREACION ASC, ELE.FE_CREACION DESC
                        )
                        WHERE ROWNUM = 1';
          OPEN Pcl_Response FOR Lcl_Query;
          --resultados
          Pv_Status     := 'OK';
          Pv_Mensaje    := 'Transacci閿熺单 exitosa';
      EXCEPTION
          WHEN OTHERS THEN
              Pv_Status  := 'ERROR';
              Pv_Mensaje := SQLERRM;
    END P_GET_SERVICIO_LICENCIA_RPA;

/**
  * Documentaci閿熺单 para el procedimiento P_GET_SERVICIO_ENVIO_CORREO
  *
  * M閿熺但odo encargado de consultar y enviar correos de los datos del cliente/Pre-Cliente que realiza solicitud de Portabilidad
  *
  * @param Pv_Identificacion      IN  VARCHAR2 Ingresa la identificacion del cliente/Pre-Cliente
  * @param Pv_Destinatario        IN  VARCHAR2 Ingresa el correo del cliente/Pre-Cliente
  * @param Pv_Mensaje             OUT VARCHAR2 Retorna mensaje de exito o error del envio de correo
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.0 02-12-2022
  */
PROCEDURE P_GET_SERVICIO_ENVIO_CORREO(Pv_Identificacion    IN VARCHAR2,
                                          Pv_Destinatario      IN VARCHAR2,
                                          Pv_Mensaje           OUT VARCHAR2)
AS
  --
 
  Lv_MensajeError                 VARCHAR2(4000);
  Lrf_ServiciosCliente            SYS_REFCURSOR;
  Ln_TotalRegistros               NUMBER := 0;
  Ln_IndxServicios                NUMBER;
  Lv_Remitente                    VARCHAR2(100);
  Lv_AsuntoInicial                VARCHAR2(300);
  Lv_Asunto                       VARCHAR2(300);
  Lv_FechaArchivo                 VARCHAR2(20)   := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
  Lv_NombreArchivo                VARCHAR2(100) := '';
  Lv_NombreArchivoZip             VARCHAR2(100) := '';
  Lv_Delimitador                  VARCHAR2(1) := '|'; 
  Lf_Archivo                      utl_file.file_type;
  Lv_Gzip                         VARCHAR2(100) := '';
  Lcl_PlantillaReporte            CLOB; 
  Le_Exception                    EXCEPTION;
  Lv_EmpresaCod                   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
  Lt_TServiciosCliente            DB_COMERCIAL.CMKG_TYPES.T_ServiciosPersona;

  TYPE Lt_ParametrosDet           IS TABLE OF DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_Datos_Contacto_Persona       VARCHAR2(10000);
  Lv_Datos_Contacto_Punto         VARCHAR2(10000);--;
  Lv_Tipo_Cuenta                  VARCHAR2(100);
  Lv_EstadoActivo                 VARCHAR2(7) := 'Activo';
  Lv_NombreParamDirBdArchivosTmp  VARCHAR2(33) := 'DIRECTORIO_BD_ARCHIVOS_TEMPORALES';
  Lv_DirectorioBaseDatos          VARCHAR2(100);
  Lv_RutaDirectorioBaseDatos      VARCHAR2(500);
  Lv_NombreParamsServiciosMd      VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
  Lv_NombreParamRemitenteYAsunto  VARCHAR2(41) := 'REMITENTES_Y_ASUNTOS_CORREOS_POR_PROCESO';
  Lv_ProcesoRemitenteYAsunto      VARCHAR2(30) := 'PROCESOS_DERECHOS_DEL_TITULAR';
  Lv_anio_vencimiento             VARCHAR2(20);
  Lv_mes_vencimiento              VARCHAR2(20);
  Lv_KeyEncript                   VARCHAR2(300);
  Lr_RespuestaKeyEncriptBusq      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lr_ParametroDetalleBusqueda     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lrf_RespuestaKeyEncriptBusq     SYS_REFCURSOR;
  Ln_IndxParametrosDetKeyEncript  NUMBER;
  Lt_ParametrosDetKeyEncript      Lt_ParametrosDet;
  Lv_ValorNuevoNumCuenta          DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.NUMERO_CTA_TARJETA%TYPE;
  Lv_Num_Cuenta                   DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.NUMERO_CTA_TARJETA%TYPE;
  Lb_Fexists                      BOOLEAN;
  Ln_FileLength                   NUMBER;
  Lbi_BlockSize                   BINARY_INTEGER;
  Ln_Fila                         NUMBER := 2;
  Lv_NombreDirectorio            VARCHAR2(100);
  Lv_RutaDirectorio              VARCHAR2(100);
  Ln_NumeroColumnas              NUMBER := 28;
  Lv_Extension                   VARCHAR2(5)   := '.gz';
  Ln_limiteBulk                  CONSTANT PLS_INTEGER DEFAULT 5000;
  Li_Cont                       PLS_INTEGER;
  i                             PLS_INTEGER := 0;
  Lcl_QuerySelect               CLOB;
  Lcl_QueryFrom                 CLOB;
  Lcl_QueryWhere                CLOB;
  Lcl_Query                     CLOB;
  Lcl_union                     CLOB;
  Lcl_QuerySelectSecund         CLOB;
  Lcl_QueryFromSecund           CLOB;
  Lv_Where                      VARCHAR2(4000);
  Lv_WhereSecundario            VARCHAR2(4000);
  Lv_Nombre_Cliente             VARCHAR2(4000);
  

  CURSOR Lc_GetValoresParamsGeneral(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
    SELECT DET.VALOR1, DET.VALOR2
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
    ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO = Lv_EstadoActivo
    AND DET.ESTADO = Lv_EstadoActivo;

  CURSOR Lc_GetValorParamServiciosMd(   Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                        Cv_Valor2          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
  IS
    SELECT DET.VALOR3, DET.VALOR4, EMPRESA_COD
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
    ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO = Lv_EstadoActivo
    AND DET.VALOR1 = Cv_Valor1
    AND DET.VALOR2 = Cv_Valor2
    AND DET.ESTADO = Lv_EstadoActivo;

  
  CURSOR C_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
  IS
    SELECT
      AP.PLANTILLA
    FROM
      DB_COMUNICACION.ADMI_PLANTILLA AP 
    WHERE
      AP.CODIGO = Cv_CodigoPlantilla
    AND AP.ESTADO <> 'Eliminado';
    
    CURSOR Lc_GetFormasContactoPersona(Cv_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
    IS
    SELECT
        afc.DESCRIPCION_FORMA_CONTACTO as forma_contacto,
        IPFC .VALOR as contacto
    FROM
        DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc
        INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc ON
        IPFC .FORMA_CONTACTO_ID = afc.ID_FORMA_CONTACTO
    WHERE
        IPFC .PERSONA_ID = Cv_IdPersona;
        TYPE contactoPersona IS TABLE OF Lc_GetFormasContactoPersona%ROWTYPE INDEX BY PLS_INTEGER;
    
    CURSOR Lc_GetFormasContactoPunto(Cv_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
    SELECT
	afc.DESCRIPCION_FORMA_CONTACTO as forma_contacto,
	IPFC.VALOR as contacto
    FROM
        DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO ipfc
    INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc ON
        IPFC .FORMA_CONTACTO_ID = afc.ID_FORMA_CONTACTO
    WHERE
        IPFC.PUNTO_ID = Cv_IdPunto;
   TYPE contactoPunto IS TABLE OF Lc_GetFormasContactoPunto%ROWTYPE INDEX BY PLS_INTEGER;
        
    CURSOR Lc_GetDetalleFormaPago(Cv_IdContrato DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.CONTRATO_ID%TYPE)
    IS
    SELECT TIPO_CUENTA.DESCRIPCION_CUENTA TIPO_CUENTA,
           TIPO_CUENTA.ES_TARJETA ES_TARJETA,
           CONTRATO_FORMA_PAGO.NUMERO_CTA_TARJETA NUM_CUENTA_TARJETA,
           CONTRATO_FORMA_PAGO.ANIO_VENCIMIENTO ANIO_VENCIMIENTO,
           CONTRATO_FORMA_PAGO.MES_VENCIMIENTO MES_VENCIMIENTO
    FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONTRATO_FORMA_PAGO
    INNER JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA BANCO_TIPO_CUENTA
    ON BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA = CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID
    LEFT JOIN DB_GENERAL.ADMI_BANCO BANCO
    ON BANCO.ID_BANCO = BANCO_TIPO_CUENTA.BANCO_ID
    LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA TIPO_CUENTA
    ON TIPO_CUENTA.ID_TIPO_CUENTA                      = CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID
    WHERE CONTRATO_FORMA_PAGO.CONTRATO_ID              = Cv_IdContrato;
    TYPE formaPago IS TABLE OF Lc_GetDetalleFormaPago%ROWTYPE INDEX BY PLS_INTEGER;
    
    Lr_RegGetDetalleFormaPago         Lc_GetDetalleFormaPago%ROWTYPE;
    Lr_RegGetFormasContactoPersona    Lc_GetFormasContactoPersona%ROWTYPE;
    Lr_RegGetFormasContactoPunto      Lc_GetFormasContactoPunto%ROWTYPE;
    Lr_RegGetValoresParamsGeneral     Lc_GetValoresParamsGeneral%ROWTYPE;
    Lr_RegGetValorParamServiciosMd    Lc_GetValorParamServiciosMd%ROWTYPE;
    
    Lc_ContactoPersona   contactoPersona;
    Lc_ContactoPunto     contactoPunto;
    Lc_FormaPago           formaPago;
     
  BEGIN
  
    OPEN Lc_GetValoresParamsGeneral(Lv_NombreParamDirBdArchivosTmp);
    FETCH Lc_GetValoresParamsGeneral INTO Lr_RegGetValoresParamsGeneral;
    CLOSE Lc_GetValoresParamsGeneral;
    Lv_DirectorioBaseDatos      := Lr_RegGetValoresParamsGeneral.VALOR1;
    
    IF Lv_DirectorioBaseDatos IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener el directorio para guardar los archivos csv';
      RAISE Le_Exception;
    END IF;
    Lv_RutaDirectorioBaseDatos  := Lr_RegGetValoresParamsGeneral.VALOR2;
    
    IF Lv_RutaDirectorioBaseDatos IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener la rura del directorio para guardar los archivos csv';
      RAISE Le_Exception;   
    END IF;
    
    OPEN Lc_GetValorParamServiciosMd(Lv_NombreParamsServiciosMd, Lv_NombreParamRemitenteYAsunto, Lv_ProcesoRemitenteYAsunto);
    FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetValorParamServiciosMd;
    CLOSE Lc_GetValorParamServiciosMd;
    Lv_Remitente        := Lr_RegGetValorParamServiciosMd.VALOR3;
    Lv_AsuntoInicial    := Lr_RegGetValorParamServiciosMd.VALOR4;
    Lv_EmpresaCod       := Lr_RegGetValorParamServiciosMd.EMPRESA_COD;
    
    IF Lv_Remitente IS NULL OR Lv_AsuntoInicial IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener el remitente y/o el asunto del correo para el proceso de portabilidad';
      RAISE Le_Exception;
    END IF;

    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    
    OPEN C_GetPlantilla('PORTABILIDAD');
    FETCH C_GetPlantilla INTO Lcl_PlantillaReporte;
    CLOSE C_GetPlantilla;
    
    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    
    --Parametros para encriptar y desencriptar claves
      Lv_ValorNuevoNumCuenta              := '';
      Lv_Num_Cuenta                       := '';
      Lr_ParametroDetalleBusqueda         := NULL;
      Lr_ParametroDetalleBusqueda.VALOR1  := 'KEY_SECRET_TELCOS';
      Lr_ParametroDetalleBusqueda.VALOR2  := NULL;
      Lr_ParametroDetalleBusqueda.VALOR3  := NULL;
      Lr_ParametroDetalleBusqueda.VALOR4  := NULL;
      Lr_ParametroDetalleBusqueda.VALOR5  := NULL;
      Lrf_RespuestaKeyEncriptBusq         := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
      Lv_KeyEncript                       := '';
      
    FETCH Lrf_RespuestaKeyEncriptBusq BULK COLLECT INTO Lt_ParametrosDetKeyEncript LIMIT 1000;
    Ln_IndxParametrosDetKeyEncript := Lt_ParametrosDetKeyEncript.FIRST;
    WHILE (Ln_IndxParametrosDetKeyEncript IS NOT NULL)
    LOOP
      Lr_RespuestaKeyEncriptBusq      := Lt_ParametrosDetKeyEncript(Ln_IndxParametrosDetKeyEncript);
      Lv_KeyEncript                   := Lr_RespuestaKeyEncriptBusq.VALOR2;
      Ln_IndxParametrosDetKeyEncript  := Lt_ParametrosDetKeyEncript.NEXT(Ln_IndxParametrosDetKeyEncript);
    END LOOP;
    IF Lv_KeyEncript IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener la Key para encriptar y desencriptar las claves';
      RAISE Le_Exception;
    END IF;

      
            DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelectSecund, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryFromSecund, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE);
            DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_union, TRUE); 
    
             DBMS_LOB.APPEND(Lcl_QuerySelect,'SELECT ip.ID_PERSONA ,
                                    ip.TIPO_IDENTIFICACION,
                                    ip.IDENTIFICACION_CLIENTE NUMERO_IDENTIFICACION,
                                    ip.NOMBRES,
                                    ip.APELLIDOS ,
                                    ip.RAZON_SOCIAL ,
                                    CASE                         
                                    WHEN ip.RAZON_SOCIAL IS NOT NULL THEN                         
                                    ip.RAZON_SOCIAL                          
                                    ELSE                         
                                    ip.NOMBRES || '' '' || ip.APELLIDOS                      
                                    END NOMBRE_COMPLETO,
                                    CASE ip.NACIONALIDAD
                                    WHEN ''NAC'' THEN ''Nacional''
                                    WHEN ''EXT'' THEN ''Extranjera''
                                    ELSE '' ''
                                    END as NACIONALIDAD,
                                    ipu.DIRECCION,
                                    ip.GENERO ,
                                    DB_COMERCIAL.CMKG_BENEFICIOS.F_GET_ES_CLIENTE_DISCAPACITADO(is2.ID_SERVICIO,iper.ID_PERSONA_ROL) DISCAPACIDAD,
                                    ip.REPRESENTANTE_LEGAL ,
                                    CASE ip.ORIGEN_INGRESOS
                                    WHEN ''B'' THEN ''Empleado Publico''
                                    WHEN ''V'' THEN ''Empleado Privado''
                                    WHEN ''I'' THEN ''Independiente''
                                    WHEN ''A'' THEN ''Ama de casa o estudiante''
                                    WHEN ''R'' THEN ''Rentista''
                                    WHEN ''J'' THEN ''Jubilado''
                                    WHEN ''I'' THEN ''Independiente''
                                    ELSE ''Remesas del exterior''
                                    END as ORIGEN_INGRESOS,
                                    ipu.ID_PUNTO,
                                    ipu.LATITUD COORDENADA_LATITUD_PUNTO,
                                    ipu.LONGITUD COORDENADA_LONGITUD_PUNTO,
                                    ap2.NOMBRE_PROVINCIA PROVINCIA_PUNTO,
                                    ac.NOMBRE_CANTON CIUDAD_PUNTO,
                                    ac.NOMBRE_CANTON CANTON_PUNTO,
                                    ap.NOMBRE_PARROQUIA PARROQUIA_PUNTO	,
                                    as2.NOMBRE_SECTOR SECTOR_PUNTO,
                                    atu.DESCRIPCION_TIPO_UBICACION TIPO_UBICACION_PUNTO,
                                    ipc.NOMBRE_PLAN NOMBRE_PLAN,
                                    ipu.ESTADO ESTADO_PUNTO,
                                    afp.DESCRIPCION_FORMA_PAGO,
                                    is2.ID_SERVICIO SERVICIO,
                                    IC.ID_CONTRATO');
                            
        DBMS_LOB.APPEND(Lcl_QueryFrom,' FROM DB_COMERCIAL.INFO_PERSONA ip 
                                INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper ON ip.ID_PERSONA = iper.PERSONA_ID 
                                INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier ON iper.EMPRESA_ROL_ID = ier.ID_EMPRESA_ROL 
                                INNER JOIN DB_COMERCIAL.INFO_PUNTO ipu ON iper.ID_PERSONA_ROL = ipu.PERSONA_EMPRESA_ROL_ID  
                                INNER JOIN DB_GENERAL.ADMI_SECTOR as2 ON ipu.SECTOR_ID = as2.ID_SECTOR 
                                INNER JOIN DB_GENERAL.ADMI_PARROQUIA ap ON as2.PARROQUIA_ID  = ap.ID_PARROQUIA 
                                INNER JOIN DB_GENERAL.ADMI_CANTON ac ON ap.CANTON_ID = ac.ID_CANTON 
                                INNER JOIN DB_GENERAL.ADMI_PROVINCIA ap2 ON ac.PROVINCIA_ID = ap2.ID_PROVINCIA 
                                INNER JOIN DB_COMERCIAL.ADMI_TIPO_UBICACION atu ON ipu.TIPO_UBICACION_ID = atu.ID_TIPO_UBICACION
                                INNER JOIN DB_COMERCIAL.INFO_SERVICIO is2 ON ipu.ID_PUNTO = is2.PUNTO_ID 
                                INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc ON is2.PLAN_ID = ipc.ID_PLAN 
                                INNER JOIN DB_COMERCIAL.INFO_CONTRATO ic ON iper.ID_PERSONA_ROL = ic.PERSONA_EMPRESA_ROL_ID 
                                INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO afp ON ic.FORMA_PAGO_ID = afp.ID_FORMA_PAGO'); 
                            
        DBMS_LOB.APPEND(Lcl_union, ' UNION ');
        DBMS_LOB.APPEND(Lcl_QuerySelectSecund, ' SELECT ip.ID_PERSONA ,
                                ip.TIPO_IDENTIFICACION,
                                ip.IDENTIFICACION_CLIENTE NUMERO_IDENTIFICACION,
                                ip.NOMBRES,
                                ip.APELLIDOS ,
                                ip.RAZON_SOCIAL ,
                                CASE                         
                                  WHEN ip.RAZON_SOCIAL IS NOT NULL THEN                         
                                  ip.RAZON_SOCIAL                          
                                  ELSE                         
                                  ip.NOMBRES || '' '' || ip.APELLIDOS                      
                                  END NOMBRE_COMPLETO,
                                CASE ip.NACIONALIDAD
                                WHEN ''NAC'' THEN ''Nacional''
                                WHEN ''EXT'' THEN ''Extranjera''
                                ELSE '' ''
                                END as NACIONALIDAD,
                                ipu.DIRECCION,
                                ip.GENERO,
                                DB_COMERCIAL.CMKG_BENEFICIOS.F_GET_ES_CLIENTE_DISCAPACITADO(is2.ID_SERVICIO,iper.ID_PERSONA_ROL) DISCAPACIDAD,
                                ip.REPRESENTANTE_LEGAL ,
                                CASE ip.ORIGEN_INGRESOS
                                WHEN ''B'' THEN ''Empleado Publico''
                                WHEN ''V'' THEN ''Empleado Privado''
                                WHEN ''I'' THEN ''Independiente''
                                WHEN ''A'' THEN ''Ama de casa o estudiante''
                                WHEN ''R'' THEN ''Rentista''
                                WHEN ''J'' THEN ''Jubilado''
                                WHEN ''I'' THEN ''Independiente''
                                ELSE ''Remesas del exterior''
                                END as ORIGEN_INGRESOS,
                                ipu.ID_PUNTO,
                                ipu.LATITUD COORDENADA_LATITUD_PUNTO,
                                ipu.LONGITUD COORDENADA_LONGITUD_PUNTO,
                                ap2.NOMBRE_PROVINCIA PROVINCIA_PUNTO,
                                ac.NOMBRE_CANTON CIUDAD_PUNTO,
                                ac.NOMBRE_CANTON CANTON_PUNTO,
                                ap.NOMBRE_PARROQUIA PARROQUIA_PUNTO	,
                                as2.NOMBRE_SECTOR SECTOR_PUNTO,
                                atu.DESCRIPCION_TIPO_UBICACION TIPO_UBICACION_PUNTO,
                                apro.DESCRIPCION_PRODUCTO NOMBRE_PLAN,
                                ipu.ESTADO ESTADO_PUNTO,
                                afp.DESCRIPCION_FORMA_PAGO,
                                is2.ID_SERVICIO SERVICIO,
                                IC.ID_CONTRATO');
                                
        DBMS_LOB.APPEND(Lcl_QueryFromSecund, ' FROM DB_COMERCIAL.INFO_PERSONA ip 
                                INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper ON ip.ID_PERSONA = iper.PERSONA_ID 
                                INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier ON iper.EMPRESA_ROL_ID = ier.ID_EMPRESA_ROL 
                                INNER JOIN DB_COMERCIAL.INFO_PUNTO ipu ON iper.ID_PERSONA_ROL = ipu.PERSONA_EMPRESA_ROL_ID  
                                INNER JOIN DB_GENERAL.ADMI_SECTOR as2 ON ipu.SECTOR_ID = as2.ID_SECTOR 
                                INNER JOIN DB_GENERAL.ADMI_PARROQUIA ap ON as2.PARROQUIA_ID  = ap.ID_PARROQUIA 
                                INNER JOIN DB_GENERAL.ADMI_CANTON ac ON ap.CANTON_ID = ac.ID_CANTON 
                                INNER JOIN DB_GENERAL.ADMI_PROVINCIA ap2 ON ac.PROVINCIA_ID = ap2.ID_PROVINCIA 
                                INNER JOIN DB_COMERCIAL.ADMI_TIPO_UBICACION atu ON ipu.TIPO_UBICACION_ID = atu.ID_TIPO_UBICACION
                                INNER JOIN DB_COMERCIAL.INFO_SERVICIO is2 ON ipu.ID_PUNTO = is2.PUNTO_ID 
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO apro ON is2.PRODUCTO_ID = apro.ID_PRODUCTO 
                                INNER JOIN DB_COMERCIAL.INFO_CONTRATO ic ON iper.ID_PERSONA_ROL = ic.PERSONA_EMPRESA_ROL_ID 
                                INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO afp ON ic.FORMA_PAGO_ID = afp.ID_FORMA_PAGO');
                            
                            
               Lv_Where            := ' WHERE ip.IDENTIFICACION_CLIENTE = '':Lv_Identificacion''';      
               Lv_Where            := REPLACE(Lv_Where,':Lv_Identificacion', Pv_Identificacion);
            DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_Where);     
            
               Lv_WhereSecundario  := ' AND ier.EMPRESA_COD  = '':Lv_EmpresaCod''';
               Lv_WhereSecundario  := REPLACE(Lv_WhereSecundario,':Lv_EmpresaCod', Lv_EmpresaCod);
            DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_WhereSecundario); 
   
    
      
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_union);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelectSecund);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFromSecund);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
      
            
            DB_GENERAL.GNKG_AS_XLSX.CLEAR_WORKBOOK;
            DB_GENERAL.GNKG_AS_XLSX.NEW_SHEET(P_SHEETNAME => 'Datos Persona Derechos del Titular');
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(1,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(2,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(3,35);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(4,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(5,50);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(6,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(7,55);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(8,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(9,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(10,50);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(11,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(12,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(13,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(14,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(15,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(16,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(17,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(18,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(19,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(20,50);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(21,50);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(22,60);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(23,25);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(24,25);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(25,25);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(26,25);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(27,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(28,20);
                    
            --Columnas del reporte.
            DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
              P_ROW       => 1,
              P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 10, P_NAME => 'LKLUG', P_RGB => 'FFFFFF'),
              P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
              P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
              P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => '888888'));
            DB_GENERAL.GNKG_AS_XLSX.CELL(1,1,'TIPO_IDENTIFICACION');
            DB_GENERAL.GNKG_AS_XLSX.CELL(2,1,'NUMERO_IDENTIFICACION');
            DB_GENERAL.GNKG_AS_XLSX.CELL(3,1,'NOMBRES');
            DB_GENERAL.GNKG_AS_XLSX.CELL(4,1,'APELLIDOS');
            DB_GENERAL.GNKG_AS_XLSX.CELL(5,1,'RAZON_SOCIAL');
            DB_GENERAL.GNKG_AS_XLSX.CELL(6,1,'NACIONALIDAD');
            DB_GENERAL.GNKG_AS_XLSX.CELL(7,1,'DIRECCION');
            DB_GENERAL.GNKG_AS_XLSX.CELL(8,1,'GENERO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(9,1,'DISCAPACIDAD');
            DB_GENERAL.GNKG_AS_XLSX.CELL(10,1,'REPRESENTANTE_LEGAL');
            DB_GENERAL.GNKG_AS_XLSX.CELL(11,1,'ORIGEN_INGRESOS');
            DB_GENERAL.GNKG_AS_XLSX.CELL(12,1,'COORDENADA_LATITUD_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(13,1,'COORDENADA_LONGITUD_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(14,1,'PROVINCIA_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(15,1,'CIUDAD_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(16,1,'CANTON_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(17,1,'PARROQUIA_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(18,1,'SECTOR_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(19,1,'TIPO_UBICACION_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(20,1,'DATOS_CONTACTO_PERSONA');
            DB_GENERAL.GNKG_AS_XLSX.CELL(21,1,'DATOS_CONTACTO_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(22,1,'NOMBRE_PLAN');
            DB_GENERAL.GNKG_AS_XLSX.CELL(23,1,'ESTADO DEL PUNTO');            
            DB_GENERAL.GNKG_AS_XLSX.CELL(24,1,'FORMA DE PAGO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(25,1,'TIPO_DE_CUENTA');
            DB_GENERAL.GNKG_AS_XLSX.CELL(26,1,'NO_TARJETA/CUENTA');
            DB_GENERAL.GNKG_AS_XLSX.CELL(27,1,'MES_VENCIMIENTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(28,1,'A閿熺祮_VENCIMIENTO');
                    
         
          OPEN Lrf_ServiciosCliente FOR Lcl_Query;
            LOOP
              FETCH Lrf_ServiciosCliente BULK COLLECT INTO Lt_TServiciosCliente LIMIT Ln_limiteBulk;
                Li_Cont := Lt_TServiciosCliente.FIRST;
                WHILE (Li_Cont IS NOT NULL) LOOP
          
                OPEN Lc_GetFormasContactoPersona(Lt_TServiciosCliente(Li_Cont).ID_PERSONA);
                LOOP
                  FETCH Lc_GetFormasContactoPersona BULK COLLECT INTO Lc_ContactoPersona LIMIT Ln_limiteBulk;
                  EXIT WHEN Lc_ContactoPersona.COUNT = 0;
                  BEGIN
                  i := Lc_ContactoPersona.FIRST;
                    WHILE (i IS NOT NULL) LOOP
                        IF Lc_ContactoPersona(i).forma_contacto IS NOT NULL THEN
                           Lv_Datos_Contacto_Persona := Lv_Datos_Contacto_Persona||Lc_ContactoPersona(i).forma_contacto||': '||Lc_ContactoPersona(i).contacto  ||' ; '||chr(13);
                        END IF;
                    i := Lc_ContactoPersona.NEXT(i);
                    END LOOP;
                  END;
                END LOOP;
               CLOSE Lc_GetFormasContactoPersona;
           
           
               --forma de contacto punto
               OPEN Lc_GetFormasContactoPunto(Lt_TServiciosCliente(Li_Cont).ID_PUNTO);
                LOOP
                  FETCH Lc_GetFormasContactoPunto BULK COLLECT INTO Lc_ContactoPunto LIMIT Ln_limiteBulk;
                  EXIT WHEN Lc_ContactoPunto.COUNT = 0;
                  BEGIN
                  i := Lc_ContactoPunto.FIRST;
                    WHILE (i IS NOT NULL) LOOP
                    
                        IF Lc_ContactoPunto(i).forma_contacto IS NOT NULL THEN
                           Lv_Datos_Contacto_Punto := Lv_Datos_Contacto_Punto||Lc_ContactoPunto(i).forma_contacto||': '||Lc_ContactoPunto(i).contacto  ||' ; '||chr(13) ;
                        END IF;
                    i := Lc_ContactoPunto.NEXT(i);
                    END LOOP;
                  END;
                END LOOP;
               CLOSE Lc_GetFormasContactoPunto;
            

            --Valida la forma de Pago para incluir valores en caso de DebitoBancario
            IF  Lt_TServiciosCliente(Li_Cont).DESCRIPCION_FORMA_PAGO = 'DEBITO BANCARIO' THEN
            
                --Cursor para obtener informacion de DebitosBancarios
                OPEN Lc_GetDetalleFormaPago(Lt_TServiciosCliente(Li_Cont).ID_CONTRATO);
                LOOP
                  FETCH Lc_GetDetalleFormaPago BULK COLLECT INTO Lc_FormaPago LIMIT Ln_limiteBulk;
                  EXIT WHEN Lc_FormaPago.COUNT = 0;
                  BEGIN
                  i := Lc_FormaPago.FIRST;
                    WHILE (i IS NOT NULL) LOOP
                    DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_DESCENCRIPTAR(Lc_FormaPago(i).NUM_CUENTA_TARJETA,
                                                                         Lv_KeyEncript,
                                                                         Lv_Num_Cuenta);
                        Lv_ValorNuevoNumCuenta := REPLACE(Lv_Num_Cuenta, substr((Lv_Num_Cuenta), 4, LENGTH(Lv_Num_Cuenta)-6), 
                                                  lpad('X', LENGTH(Lv_Num_Cuenta)-6,'X'));  
                          
                        Lv_Tipo_Cuenta := Lc_FormaPago(i).TIPO_CUENTA;
                        
                        if Lc_FormaPago(i).ES_TARJETA = 'S' THEN
                                                   
                        Lv_Anio_Vencimiento := rpad(substr((Lc_FormaPago(i).ANIO_VENCIMIENTO),1,
                                               LENGTH(Lc_FormaPago(i).ANIO_VENCIMIENTO)-1),LENGTH(Lc_FormaPago(i).ANIO_VENCIMIENTO),'X');
                        Lv_Mes_Vencimiento := Lc_FormaPago(i).MES_VENCIMIENTO;
                           
                        END IF;
                i := Lc_FormaPago.NEXT(i);
                END LOOP;
              END;
            END LOOP;
           CLOSE Lc_GetDetalleFormaPago;
                
        ELSE
            Lv_Tipo_Cuenta          := '';
            Lv_ValorNuevoNumCuenta  := '';
            Lv_Mes_Vencimiento      := '';
            Lv_Anio_Vencimiento     := '';
        END IF;
            
            
            DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
            P_ROW       => Ln_Fila,
            P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => '000000'),
            P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
            P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
            P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
            DB_GENERAL.GNKG_AS_XLSX.CELL(1,Ln_Fila,Lt_TServiciosCliente(Li_Cont).TIPO_IDENTIFICACION);
            DB_GENERAL.GNKG_AS_XLSX.CELL(2,Ln_Fila,Lt_TServiciosCliente(Li_Cont).NUMERO_IDENTIFICACION);
            DB_GENERAL.GNKG_AS_XLSX.CELL(3,Ln_Fila,Lt_TServiciosCliente(Li_Cont).NOMBRES);
            DB_GENERAL.GNKG_AS_XLSX.CELL(4,Ln_Fila,Lt_TServiciosCliente(Li_Cont).APELLIDOS);
            DB_GENERAL.GNKG_AS_XLSX.CELL(5,Ln_Fila,Lt_TServiciosCliente(Li_Cont).RAZON_SOCIAL);
            DB_GENERAL.GNKG_AS_XLSX.CELL(6,Ln_Fila,Lt_TServiciosCliente(Li_Cont).NACIONALIDAD);
            DB_GENERAL.GNKG_AS_XLSX.CELL(7,Ln_Fila,Lt_TServiciosCliente(Li_Cont).DIRECCION);
            DB_GENERAL.GNKG_AS_XLSX.CELL(8,Ln_Fila,Lt_TServiciosCliente(Li_Cont).GENERO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(9,Ln_Fila,Lt_TServiciosCliente(Li_Cont).DISCAPACIDAD);
            DB_GENERAL.GNKG_AS_XLSX.CELL(10,Ln_Fila,Lt_TServiciosCliente(Li_Cont).REPRESENTANTE_LEGAL);
            DB_GENERAL.GNKG_AS_XLSX.CELL(11,Ln_Fila,Lt_TServiciosCliente(Li_Cont).ORIGEN_INGRESOS);
            DB_GENERAL.GNKG_AS_XLSX.CELL(12,Ln_Fila,Lt_TServiciosCliente(Li_Cont).COORDENADA_LATITUD_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(13,Ln_Fila,Lt_TServiciosCliente(Li_Cont).COORDENADA_LONGITUD_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(14,Ln_Fila,Lt_TServiciosCliente(Li_Cont).PROVINCIA_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(15,Ln_Fila,Lt_TServiciosCliente(Li_Cont).CIUDAD_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(16,Ln_Fila,Lt_TServiciosCliente(Li_Cont).CANTON_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(17,Ln_Fila,Lt_TServiciosCliente(Li_Cont).PARROQUIA_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(18,Ln_Fila,Lt_TServiciosCliente(Li_Cont).SECTOR_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(19,Ln_Fila,Lt_TServiciosCliente(Li_Cont).TIPO_UBICACION_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(20,Ln_Fila,Lv_Datos_Contacto_Persona);
            DB_GENERAL.GNKG_AS_XLSX.CELL(21,Ln_Fila,Lv_Datos_Contacto_Punto);
            DB_GENERAL.GNKG_AS_XLSX.CELL(22,Ln_Fila,Lt_TServiciosCliente(Li_Cont).NOMBRE_PLAN);
            DB_GENERAL.GNKG_AS_XLSX.CELL(23,Ln_Fila,Lt_TServiciosCliente(Li_Cont).ESTADO_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(24,Ln_Fila,Lt_TServiciosCliente(Li_Cont).DESCRIPCION_FORMA_PAGO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(25,Ln_Fila,Lv_Tipo_Cuenta);
            DB_GENERAL.GNKG_AS_XLSX.CELL(26,Ln_Fila,Lv_ValorNuevoNumCuenta);
            DB_GENERAL.GNKG_AS_XLSX.CELL(27,Ln_Fila,Lv_Mes_Vencimiento);
            DB_GENERAL.GNKG_AS_XLSX.CELL(28,Ln_Fila,Lv_Anio_Vencimiento);
            Ln_Fila := Ln_Fila + 1;
            Lv_Nombre_Cliente := Lt_TServiciosCliente(Li_Cont).NOMBRE_COMPLETO;
              Li_Cont:= Lt_TServiciosCliente.NEXT(Li_Cont);
            END LOOP;
            
          EXIT WHEN Lrf_ServiciosCliente%NOTFOUND;
        END LOOP;                              
        
          --Fin de la creaci閿熺单 del Archivo.
            Lv_NombreArchivo := 'REPORTE_DATOS_CLIENTE.xlsx';
            DB_GENERAL.GNKG_AS_XLSX.SAVE(Lv_DirectorioBaseDatos,Lv_NombreArchivo);
        
           
          
          Lcl_PlantillaReporte := REPLACE(Lcl_PlantillaReporte,'{{CLIENTE}}', Lv_Nombre_Cliente );
          
          DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                    Pv_Destinatario||',',
                                                    Lv_AsuntoInicial, 
                                                    Lcl_PlantillaReporte, 
                                                    Lv_DirectorioBaseDatos,
                                                    Lv_NombreArchivo);
        
          --Eliminaci閿熺单 del archivo xlsx.
            UTL_FILE.FGETATTR(Lv_DirectorioBaseDatos, Lv_NombreArchivo, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
            IF Lb_Fexists THEN
              UTL_FILE.FREMOVE(Lv_DirectorioBaseDatos,Lv_NombreArchivo);
              DBMS_OUTPUT.PUT_LINE('Archivo '||Lv_NombreArchivo||' eliminado.');
            END IF;
        
 

    IF TRIM(Lv_MensajeError) IS NOT NULL THEN
      Pv_Mensaje := Lv_MensajeError;
      RAISE Le_Exception;
    END IF;
    Pv_Mensaje := 'OK';
EXCEPTION
WHEN Le_Exception THEN
  --
  ROLLBACK;
  --
  Pv_Mensaje := Lv_MensajeError;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'COMEK_CONSULTAS.P_GET_SERVICIO_ENVIO_CORREO', 
                                        Lv_MensajeError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                                        
WHEN OTHERS THEN
  --
  ROLLBACK;
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  Pv_Mensaje := 'Error al ejecutar el proceso de envio de correo';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'COMEK_CONSULTAS.P_GET_SERVICIO_ENVIO_CORREO', 
                                         SUBSTR(Lv_MensajeError,1,3000), 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                                   
  --
END P_GET_SERVICIO_ENVIO_CORREO;

/**
  * Documentaci閿熺单 para el procedimiento P_ENVIO_CORREO_LOPDP
  *
  * M閿熺但odo encargado de  enviar correos de los datos del cliente que realiza solicitud de Oposicion
  * Suspension de Tratamiento y Detencion Suspension de tratamiento
  *
  * @param Pv_Cliente             IN  VARCHAR2 Ingresa el nombre del cliente
  * @param Pv_Destinatario        IN  VARCHAR2 Ingresa el correo del cliente
  * @param Pv_Mensaje             OUT VARCHAR2 Retorna mensaje de exito o error del envio de correo
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.0 02-12-2022
  */  
PROCEDURE P_ENVIO_CORREO_LOPDP(Pv_Cliente           IN VARCHAR2,
                               Pv_Destinatario      IN VARCHAR2,
                               Pv_Mensaje           OUT VARCHAR2)
  AS
    Lv_NombreParamsServiciosMd      VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_NombreParamRemitenteYAsunto  VARCHAR2(41) := 'REMITENTES_Y_ASUNTOS_CORREOS_POR_PROCESO';
    Lv_ProcesoRemitenteYAsunto      VARCHAR2(30) := 'PROCESOS_DERECHOS_DEL_TITULAR';
    Lv_MensajeError                 VARCHAR2(4000);
    Lcl_PlantillaReporte            CLOB; 
    Lv_EstadoActivo                 VARCHAR2(7) := 'Activo';
    Lv_PlantillaInicial             VARCHAR2(4000);
    Lv_PlantillaCorreo              VARCHAR2(4000);
    Lv_ContenidoCorreo              VARCHAR2(4000);
    Lv_Asunto                       VARCHAR2(500);
    Lv_Remitente                    VARCHAR2(50);
    Le_Exception                    EXCEPTION;
    
    CURSOR C_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
     IS
    SELECT
      AP.PLANTILLA
    FROM
      DB_COMUNICACION.ADMI_PLANTILLA AP 
    WHERE
      AP.CODIGO = Cv_CodigoPlantilla
    AND AP.ESTADO <> 'Eliminado';
   
    CURSOR Lc_GetValorParamServiciosMd(   Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                        Cv_Valor2          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
     IS
    SELECT DET.VALOR3, DET.VALOR4, EMPRESA_COD
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
    ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO = Lv_EstadoActivo
    AND DET.VALOR1 = Cv_Valor1
    AND DET.VALOR2 = Cv_Valor2
    AND DET.ESTADO = Lv_EstadoActivo;
    Lr_RegGetValorParamServiciosMd    Lc_GetValorParamServiciosMd%ROWTYPE;
    
    

  BEGIN
    OPEN Lc_GetValorParamServiciosMd(Lv_NombreParamsServiciosMd, Lv_NombreParamRemitenteYAsunto, Lv_ProcesoRemitenteYAsunto);
    FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetValorParamServiciosMd;
    CLOSE Lc_GetValorParamServiciosMd;
    Lv_Remitente        := Lr_RegGetValorParamServiciosMd.VALOR3;
    Lv_Asunto           := Lr_RegGetValorParamServiciosMd.VALOR4;
    
    IF Lv_Remitente IS NULL OR Lv_Asunto IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener el remitente y/o el asunto del correo para el proceso de portabilidad';
      RAISE Le_Exception;
    END IF;

    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    
    OPEN C_GetPlantilla('DERECHO_TITULAR');
    FETCH C_GetPlantilla INTO Lcl_PlantillaReporte;
    CLOSE C_GetPlantilla;
    
    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    
    Lcl_PlantillaReporte  := REPLACE(Lcl_PlantillaReporte,'{{CLIENTE}}', Pv_Cliente);
    
    
    UTL_MAIL.SEND (   SENDER      => Lv_Remitente, 
                      RECIPIENTS  => Pv_Destinatario|| ',', 
                      SUBJECT     => Lv_Asunto,
                      MESSAGE     => SUBSTR(Lcl_PlantillaReporte, 1, 32767),
                      MIME_TYPE   => 'text/html; charset=iso-8859-1');
    Pv_Mensaje   := 'OK';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Mensaje  := 'No se ha podido realizar el env閿熺郸 del correo';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'COMEK_CONSULTAS.P_ENVIO_CORREO_LOPDP', 
                                            'No se ha podido realizar el env閿熺郸 del correo del cliente' || Pv_Cliente
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ENVIO_CORREO_LOPDP;

END COMEK_CONSULTAS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.COMEK_CONSULTAS AS

  FUNCTION F_GET_SERVICIOS_NOTIF_MASIVA(Fv_DestinatariosCorreo     IN VARCHAR2,
                                        Fn_Start                   IN NUMBER,
                                        Fn_Limit                   IN NUMBER,
                                        Fv_Grupo                   IN VARCHAR2,
                                        Fv_Subgrupo                IN VARCHAR2,
                                        Fn_IdElementoNodo          IN NUMBER,
                                        Fn_IdElementoSwitch        IN NUMBER,
                                        Fv_EstadoServicio          IN VARCHAR2,
                                        Fv_EstadoPunto             IN VARCHAR2,
                                        Fv_EstadoCliente           IN VARCHAR2,
                                        Fv_ClientesVIP             IN VARCHAR2,
                                        Fv_UsrCreacionFactura      IN VARCHAR2,
                                        Fn_NumFacturasAbiertas     IN NUMBER,
                                        Fv_PuntosFacturacion       IN VARCHAR2,
                                        Fv_IdsTiposNegocio         IN VARCHAR2,
                                        Fv_IdsOficinas             IN VARCHAR2,
                                        Fn_IdFormaPago             IN NUMBER,
                                        Fv_NombreFormaPago         IN VARCHAR2,
                                        Fv_IdsBancosTarjetas       IN VARCHAR2,
                                        Fv_FechaDesdeFactura       IN VARCHAR2,
                                        Fv_FechaHastaFactura       IN VARCHAR2,
                                        Fv_SaldoPendientePago      IN VARCHAR2,
                                        Ff_ValorSaldoPendientePago IN FLOAT,
                                        Fv_IdsTiposContactos       IN VARCHAR2,
                                        Fv_VariablesNotificacion   IN VARCHAR2,
                                        Fn_TotalRegistros          OUT NUMBER)
    RETURN SYS_REFCURSOR IS
    Lv_UsrCreacion        VARCHAR2(15) := 'envio_masivo_tn';
    Lv_DescripcionCliente VARCHAR2(10) := 'Cliente';
    Lv_EstadoActivo       VARCHAR2(6) := 'Activo';
    Lv_TipoNodo           VARCHAR2(4) := 'NODO';
    Lv_TipoSwitch         VARCHAR2(6) := 'SWITCH';
    Lv_TipoRack           VARCHAR2(4) := 'RACK';
    Lv_TipoUdRack         VARCHAR2(6) := 'UDRACK';
    Lv_ParamEstados       VARCHAR2(28) := 'ESTADOS_FILTROS_ENVIO_MASIVO';
    Lv_ParamValorServ     VARCHAR2(8) := 'SERVICIO';
    Lv_ParamValorPunto    VARCHAR2(5) := 'PUNTO';
    Lv_ParamValorCliente  VARCHAR2(7) := 'CLIENTE';
    Lv_DocFacp            VARCHAR2(4) := 'FACP';
    Lv_DocFac             VARCHAR2(3) := 'FAC';
    Lv_TipoEnvio          VARCHAR2(18) := 'Correo Electronico';
    Ln_IdCursor           NUMBER;
    Ln_IdCursorCount      NUMBER;
    Ln_LimitConsulta      NUMBER;
    Ln_StartConsulta      NUMBER;
    Ln_NumExecCount       NUMBER;
    Ln_NumExecPrincipal   NUMBER;
    Lrf_ConsultaCount     SYS_REFCURSOR;
    Lrf_ConsultaPrincipal SYS_REFCURSOR;
  
    Lv_AgregarEstadoActivo  VARCHAR2(1) := '';
    Lv_CodEmpresa           VARCHAR2(2) := '10';
    Lv_SelectVarsPrincipal  VARCHAR2(4000) := '';
    Lv_SelectVarsNotif      VARCHAR2(4000) := '';
    Lcl_QueryFinal          CLOB;
    Lcl_QueryCount          CLOB;
    Lcl_QueryDestinatarios  CLOB;
    Lv_QueryPrincipal       VARCHAR2(4000);
    Lv_WithPrincipal        VARCHAR2(4000) := '';
    Lv_JoinAdic             CLOB;
    Lv_Where                CLOB;
    Lv_QueryNodos           VARCHAR2(500);
    Lv_WhereNodos           VARCHAR2(300);
    Lv_QuerySwDirecto       VARCHAR2(4000);
    Lv_QuerySwRackNodo      VARCHAR2(4000);
    Lv_QueryFactAbiertas    VARCHAR2(1000);
    Lv_WhereSw              VARCHAR2(100);
    Lv_QueryIdsSw           CLOB;
    Lv_BancosTarjetas       VARCHAR2(500) := '';
    Lv_FechaDesdeFact       VARCHAR2(100) := '';
    Lv_FechaHastaFact       VARCHAR2(100) := '';
    Lv_FechaDesdeHastaFact  VARCHAR2(200) := '';
    Lv_SelectPrincipal      VARCHAR2(1000) := '';
    Lv_SelectCountPrincipal VARCHAR2(1000) := '';
    Lv_OrderByPrincipal     VARCHAR2(100) := '';
    Lv_TipoPunto            VARCHAR2(9) := '';
    Lv_AgregarOrderBy       VARCHAR2(1) := '';
  
    Lt_ArrayParamsBind       DB_COMERCIAL.CMKG_TYPES.Lt_ArrayAsociativo;
    Lt_ArrayParamsStartLimit DB_COMERCIAL.CMKG_TYPES.Lt_ArrayAsociativo;
    Lt_ArrayParamsVarsNotif  DB_COMERCIAL.CMKG_TYPES.Lt_ArrayAsociativo;
    Lv_NombreParamBind       VARCHAR2(30);
  BEGIN
    IF Fv_DestinatariosCorreo IS NOT NULL AND Fv_DestinatariosCorreo = 'S' THEN
      Lv_SelectPrincipal := ' SELECT DISTINCT 
                              CASE
                                WHEN persona.RAZON_SOCIAL IS NOT NULL THEN
                                persona.RAZON_SOCIAL
                                ELSE
                                CONCAT(CONCAT (NVL(persona.NOMBRES, ''''),'' ''), NVL(persona.APELLIDOS, ''''))  
                              END AS NOMBRES_CLIENTE ';
    
      IF Fv_VariablesNotificacion IS NOT NULL THEN
        FOR I_VariablesNotificacion IN (SELECT trim(regexp_substr(Fv_VariablesNotificacion,
                                                                  '[^,]+',
                                                                  1,
                                                                  LEVEL)) nombreVariablesNotificacion
                                          FROM dual
                                        CONNECT BY LEVEL <=
                                                   length(Fv_VariablesNotificacion) -
                                                   length(REPLACE(Fv_VariablesNotificacion,
                                                                  ',',
                                                                  '')) + 1) LOOP
          Lt_ArrayParamsVarsNotif(I_VariablesNotificacion.nombreVariablesNotificacion) := I_VariablesNotificacion.nombreVariablesNotificacion;
        END LOOP;
      END IF;
    ELSE
      Lv_AgregarOrderBy  := 'S';
      Lv_SelectPrincipal := ' SELECT DISTINCT per.ID_PERSONA_ROL, 
                              CASE
                                WHEN persona.RAZON_SOCIAL IS NOT NULL THEN
                                persona.RAZON_SOCIAL
                                ELSE
                                CONCAT(CONCAT (NVL(persona.NOMBRES, ''''),'' ''), NVL(persona.APELLIDOS, '''')) 
                                END AS NOMBRES_CLIENTE ,
                                oficina.NOMBRE_OFICINA, tipoNegocio.NOMBRE_TIPO_NEGOCIO ';
    END IF;
    Lv_QueryPrincipal := '  FROM DB_COMERCIAL.INFO_SERVICIO servicio 
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO producto
                                ON producto.ID_PRODUCTO = servicio.PRODUCTO_ID
                                INNER JOIN DB_COMERCIAL.INFO_PUNTO punto
                                ON punto.ID_PUNTO = servicio.PUNTO_ID
                                INNER JOIN DB_COMERCIAL.INFO_PUNTO puntoFact
                                ON puntoFact.ID_PUNTO = servicio.PUNTO_FACTURACION_ID 
                                INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per
                                ON per.ID_PERSONA_ROL = punto.PERSONA_EMPRESA_ROL_ID
                                INNER JOIN DB_COMERCIAL.INFO_PERSONA persona
                                ON persona.ID_PERSONA = per.PERSONA_ID
                                INNER JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO oficina
                                ON oficina.ID_OFICINA = per.OFICINA_ID
                                INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL empresaRol
                                ON empresaRol.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID 
                                INNER JOIN DB_GENERAL.ADMI_ROL rol
                                ON rol.ID_ROL = empresaRol.ROL_ID
                                INNER JOIN DB_GENERAL.ADMI_TIPO_ROL tipoRol
                                ON rol.TIPO_ROL_ID = tipoRol.ID_TIPO_ROL ';
  
    Lv_JoinAdic := '';
    Lv_Where    := ' WHERE empresaRol.EMPRESA_COD = :Lv_CodEmpresa  
                           AND tipoRol.DESCRIPCION_TIPO_ROL = :Lv_DescripcionCliente ';
  
    Lt_ArrayParamsBind('Lv_CodEmpresa') := Lv_CodEmpresa;
    Lt_ArrayParamsBind('Lv_DescripcionCliente') := Lv_DescripcionCliente;
  
    IF TRIM(Fv_PuntosFacturacion) IS NOT NULL AND
       Fv_PuntosFacturacion = 'S' THEN
      Lv_JoinAdic := Lv_JoinAdic ||
                     ' INNER JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL puntoAdicional
                                                  ON puntoAdicional.PUNTO_ID = punto.ID_PUNTO ';
      Lv_Where := Lv_Where ||
                  'AND puntoAdicional.ES_PADRE_FACTURACION = :Fv_PuntosFacturacion ';
      Lt_ArrayParamsBind('Fv_PuntosFacturacion') := Fv_PuntosFacturacion;
      Lv_TipoPunto := 'puntoFact';
      Lv_SelectCountPrincipal := 'SELECT COUNT(DISTINCT puntoFact.ID_PUNTO) AS TOTAL_REGISTROS ';
    ELSE
      Lv_TipoPunto            := 'punto';
      Lv_SelectCountPrincipal := 'SELECT COUNT(DISTINCT servicio.ID_SERVICIO) AS TOTAL_REGISTROS ';
      Lv_SelectPrincipal      := Lv_SelectPrincipal ||
                                 ', servicio.ID_SERVICIO, producto.DESCRIPCION_PRODUCTO, servicio.ESTADO ';
    END IF;
    Lv_OrderByPrincipal := ' ORDER BY ' || Lv_TipoPunto || '.LOGIN ASC ';
    Lv_SelectPrincipal  := Lv_SelectPrincipal || ', ' || Lv_TipoPunto ||
                           '.ID_PUNTO, ' || Lv_TipoPunto || '.LOGIN ';
  
    Lv_QueryPrincipal := Lv_QueryPrincipal ||
                         ' INNER JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO tipoNegocio
                                                ON tipoNegocio.ID_TIPO_NEGOCIO = ' ||
                         Lv_TipoPunto || '.TIPO_NEGOCIO_ID ';
  
    IF TRIM(Fv_Grupo) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND producto.GRUPO = :Fv_Grupo ';
      Lt_ArrayParamsBind('Fv_Grupo') := Fv_Grupo;
    END IF;
  
    IF TRIM(Fv_Subgrupo) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND producto.SUBGRUPO = :Fv_Subgrupo ';
      Lt_ArrayParamsBind('Fv_Subgrupo') := Fv_Subgrupo;
    END IF;
  
    IF TRIM(Fv_EstadoServicio) IS NULL OR TRIM(Fv_EstadoPunto) IS NULL OR
       TRIM(Fv_EstadoCliente) IS NULL THEN
       -- IMPLEMETAR WITH -- jaguamanp
      Lv_WithPrincipal := Lv_WithPrincipal ||' TMP_ESTADO_PUNTO AS(SELECT APD.VALOR2,
													APD.VALOR1 ,
													APC.ESTADO,
													APD.ESTADO AS ESTADO_DET,
													APC.NOMBRE_PARAMETRO
                                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                                    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                    ON APD.PARAMETRO_ID = APC.ID_PARAMETRO
                                                    ),';
      Lt_ArrayParamsBind('Lv_ParamEstados') := Lv_ParamEstados;
    END IF;
  
    IF TRIM(Fv_EstadoServicio) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND servicio.ESTADO = :Fv_EstadoServicio ';
      Lt_ArrayParamsBind('Fv_EstadoServicio') := Fv_EstadoServicio;
    ELSE
      Lv_Where := Lv_Where ||
                  'AND servicio.ESTADO IN ( SELECT TMEP.VALOR2
                                                        FROM TMP_ESTADO_PUNTO TMEP
                                                        WHERE TMEP.NOMBRE_PARAMETRO = :Lv_ParamEstados  
                                                        AND TMEP.VALOR1 = :Lv_ParamValorServ   
                                                        AND TMEP.ESTADO = :Lv_EstadoActivo  
                                                        AND TMEP.ESTADO_DET = :Lv_EstadoActivo ) ';
      Lt_ArrayParamsBind('Lv_ParamValorServ') := Lv_ParamValorServ;
      Lv_AgregarEstadoActivo := 'S';
    END IF;
  
    IF TRIM(Fv_EstadoPunto) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND ' || Lv_TipoPunto ||
                  '.ESTADO = :Fv_EstadoPunto ';
      Lt_ArrayParamsBind('Fv_EstadoPunto') := Fv_EstadoPunto;
    ELSE
      Lv_Where := Lv_Where || 'AND ' || Lv_TipoPunto ||
                  '.ESTADO IN (   SELECT TEP.VALOR2 FROM TMP_ESTADO_PUNTO TEP
                                  WHERE TEP.NOMBRE_PARAMETRO = :Lv_ParamEstados  
                                  AND TEP.VALOR1 = :Lv_ParamValorPunto 
                                  AND TEP.ESTADO = :Lv_EstadoActivo 
                                  AND TEP.ESTADO_DET = :Lv_EstadoActivo ) ';
      Lt_ArrayParamsBind('Lv_ParamValorPunto') := Lv_ParamValorPunto;
      Lv_AgregarEstadoActivo := 'S';
    END IF;
  
    IF TRIM(Fv_EstadoCliente) IS NOT NULL THEN
      Lv_Where := Lv_Where || 'AND per.ESTADO = :Fv_EstadoCliente ';
      Lt_ArrayParamsBind('Fv_EstadoCliente') := Fv_EstadoCliente;
    ELSE
      Lv_Where := Lv_Where ||
                  'AND per.ESTADO IN ( SELECT TMEC.VALOR2 FROM TMP_ESTADO_PUNTO TMEC WHERE TMEC.NOMBRE_PARAMETRO = :Lv_ParamEstados  
                                                    AND TMEC.VALOR1 = :Lv_ParamValorCliente  
                                                    AND TMEC.ESTADO = :Lv_EstadoActivo  
                                                    AND TMEC.ESTADO_DET = :Lv_EstadoActivo ) ';
      Lt_ArrayParamsBind('Lv_ParamValorCliente') := Lv_ParamValorCliente;
      Lv_AgregarEstadoActivo := 'S';
    END IF;
  
    IF TRIM(Fv_IdsTiposNegocio) IS NOT NULL THEN
      Lv_Where := Lv_Where ||
                  'AND tipoNegocio.ID_TIPO_NEGOCIO IN 
                               (SELECT regexp_substr(:Fv_IdsTiposNegocio, ''[^,]+'', 1, LEVEL) id_tipo_negocio
                                FROM dual
                                CONNECT BY LEVEL <= length(:Fv_IdsTiposNegocio) - length(REPLACE(:Fv_IdsTiposNegocio, '','', '''')) + 1 ) ';
      Lt_ArrayParamsBind('Fv_IdsTiposNegocio') := Fv_IdsTiposNegocio;
    END IF;
  
    IF TRIM(Fv_IdsOficinas) IS NOT NULL THEN
      Lv_Where := Lv_Where ||
                  'AND oficina.ID_OFICINA IN 
                               (SELECT regexp_substr(:Fv_IdsOficinas, ''[^,]+'', 1, LEVEL) id_oficina
                                FROM dual
                                CONNECT BY LEVEL <= length(:Fv_IdsOficinas) - length(REPLACE(:Fv_IdsOficinas, '','', '''')) + 1 ) ';
      Lt_ArrayParamsBind('Fv_IdsOficinas') := Fv_IdsOficinas;
    END IF;
  
    IF ((TRIM(Fn_IdElementoNodo) IS NOT NULL AND Fn_IdElementoNodo > 0) OR
       (TRIM(Fn_IdElementoSwitch) IS NOT NULL AND Fn_IdElementoSwitch > 0)) THEN
      Lv_JoinAdic := Lv_JoinAdic ||
                     ' INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO servicioTecnico
                                          ON servicioTecnico.SERVICIO_ID = servicio.ID_SERVICIO ';
      Lv_WhereNodos := 'WHERE nodos.ESTADO = :Lv_EstadoActivo  
                          AND nodos.NOMBRE_TIPO_ELEMENTO = :Lv_TipoNodo ';
      Lt_ArrayParamsBind('Lv_TipoNodo') := Lv_TipoNodo;
      Lv_AgregarEstadoActivo := 'S';
      IF TRIM(Fn_IdElementoNodo) IS NOT NULL AND Fn_IdElementoNodo > 0 THEN
        Lv_WhereNodos := Lv_WhereNodos ||
                         'AND nodos.ID_ELEMENTO = :Fn_IdElementoNodo ';
        Lt_ArrayParamsBind('Fn_IdElementoNodo') := Fn_IdElementoNodo;
      END IF;
      Lv_QueryNodos := 'SELECT DISTINCT nodos.ID_ELEMENTO
                          FROM DB_INFRAESTRUCTURA.VISTA_ELEMENTOS nodos ' ||
                       Lv_WhereNodos;
    
      Lv_QuerySwDirecto := 'SELECT elemSwitch.ID_ELEMENTO 
                            FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO relacionNodoSwitch
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO elemSwitch
                            ON elemSwitch.ID_ELEMENTO = relacionNodoSwitch.ELEMENTO_ID_B
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloSwitch
                            ON modeloSwitch.ID_MODELO_ELEMENTO = elemSwitch.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO tipoSwitch
                            ON tipoSwitch.ID_TIPO_ELEMENTO = modeloSwitch.TIPO_ELEMENTO_ID
                            WHERE elemSwitch.ESTADO = :Lv_EstadoActivo 
                            AND relacionNodoSwitch.ESTADO = :Lv_EstadoActivo  
                            AND tipoSwitch.NOMBRE_TIPO_ELEMENTO = :Lv_TipoSwitch
                            AND relacionNodoSwitch.ELEMENTO_ID_A IN (' ||
                           Lv_QueryNodos || ') ';
    
      Lv_QuerySwRackNodo := 'SELECT elemSwitch.ID_ELEMENTO 
                            FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO relacionNodoRack
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO elemRack
                            ON elemRack.ID_ELEMENTO = relacionNodoRack.ELEMENTO_ID_B
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloRack
                            ON modeloRack.ID_MODELO_ELEMENTO = elemRack.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO tipoRack
                            ON tipoRack.ID_TIPO_ELEMENTO = modeloRack.TIPO_ELEMENTO_ID

                            INNER JOIN DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO relacionRackUnid
                            ON relacionRackUnid.ELEMENTO_ID_A = elemRack.ID_ELEMENTO
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO elemUnidRack
                            ON elemUnidRack.ID_ELEMENTO = relacionRackUnid.ELEMENTO_ID_B
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloUnidRack
                            ON modeloUnidRack.ID_MODELO_ELEMENTO = elemUnidRack.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO tipoUnidRack
                            ON tipoUnidRack.ID_TIPO_ELEMENTO = modeloUnidRack.TIPO_ELEMENTO_ID

                            INNER JOIN DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO relacionUnidRackSwitch
                            ON relacionUnidRackSwitch.ELEMENTO_ID_A = elemUnidRack.ID_ELEMENTO
                            INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO elemSwitch
                            ON elemSwitch.ID_ELEMENTO = relacionUnidRackSwitch.ELEMENTO_ID_B
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO modeloSwitch
                            ON modeloSwitch.ID_MODELO_ELEMENTO = elemSwitch.MODELO_ELEMENTO_ID
                            INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO tipoSwitch
                            ON tipoSwitch.ID_TIPO_ELEMENTO = modeloSwitch.TIPO_ELEMENTO_ID
                            WHERE elemSwitch.ESTADO = :Lv_EstadoActivo 
                            AND relacionUnidRackSwitch.ESTADO = :Lv_EstadoActivo 
                            AND relacionRackUnid.ESTADO = :Lv_EstadoActivo 
                            AND relacionNodoRack.ESTADO = :Lv_EstadoActivo 
                            AND tipoRack.NOMBRE_TIPO_ELEMENTO = :Lv_TipoRack 
                            AND tipoUnidRack.NOMBRE_TIPO_ELEMENTO = :Lv_TipoUdRack  
                            AND tipoSwitch.NOMBRE_TIPO_ELEMENTO = :Lv_TipoSwitch  
                            AND relacionNodoRack.ELEMENTO_ID_A IN (' ||
                            Lv_QueryNodos || ') ';
    
      Lt_ArrayParamsBind('Lv_TipoRack') := Lv_TipoRack;
      Lt_ArrayParamsBind('Lv_TipoUdRack') := Lv_TipoUdRack;
      Lt_ArrayParamsBind('Lv_TipoSwitch') := Lv_TipoSwitch;
      Lv_WhereSw := '';
      IF TRIM(Fn_IdElementoSwitch) IS NOT NULL AND Fn_IdElementoSwitch > 0 THEN
        Lv_WhereSw := Lv_WhereSw ||
                      'AND elemSwitch.ID_ELEMENTO = :Fn_IdElementoSwitch ';
        Lt_ArrayParamsBind('Fn_IdElementoSwitch') := Fn_IdElementoSwitch;
      END IF;
    
      Lv_QueryIdsSw := 'SELECT DISTINCT switches.ID_ELEMENTO FROM (' ||
                       Lv_QuerySwDirecto || Lv_WhereSw || ' UNION ALL ' ||
                       Lv_QuerySwRackNodo || Lv_WhereSw || ') switches ';
      Lv_Where      := Lv_Where || 'AND servicioTecnico.ELEMENTO_ID IN ( ' ||
                       Lv_QueryIdsSw || ') ';
    END IF;
  
    IF ((TRIM(Fn_NumFacturasAbiertas) IS NOT NULL AND
       Fn_NumFacturasAbiertas > 0) OR
       TRIM(Fv_FechaDesdeFactura) IS NOT NULL OR
       TRIM(Fv_FechaHastaFactura) IS NOT NULL OR
       TRIM(Fv_UsrCreacionFactura) IS NOT NULL OR
       Lt_ArrayParamsVarsNotif.EXISTS('MES_ANIO_CONSUMO_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('FECHA_EMISION_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('NUMERO_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('VALOR_FACTURA')) THEN
      Lt_ArrayParamsBind('Lv_DocFacp') := Lv_DocFacp;
      Lt_ArrayParamsBind('Lv_DocFac') := Lv_DocFac;
    END IF;
  
    IF TRIM(Fn_NumFacturasAbiertas) IS NOT NULL AND
       Fn_NumFacturasAbiertas > 0 THEN
      Lv_QueryFactAbiertas := 'SELECT facturasAbiertas.PUNTO_ID, COUNT(facturasAbiertas.ID_DOCUMENTO) AS FACTURAS_ABIERTAS
                                FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB facturasAbiertas
                                INNER JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tipoDoc
                                ON tipoDoc.ID_TIPO_DOCUMENTO = facturasAbiertas.TIPO_DOCUMENTO_ID
                                WHERE tipoDoc.CODIGO_TIPO_DOCUMENTO IN (:Lv_DocFacp , :Lv_DocFac ) 
                                AND facturasAbiertas.ESTADO_IMPRESION_FACT = :Lv_EstadoActivo  
                                GROUP BY facturasAbiertas.PUNTO_ID 
                                HAVING COUNT(facturasAbiertas.ID_DOCUMENTO) >= :Fn_NumFacturasAbiertas ';
      Lv_JoinAdic := Lv_JoinAdic || ' INNER JOIN (' || Lv_QueryFactAbiertas ||
                     ') puntoFactAbiertas
                                                  ON puntoFactAbiertas.PUNTO_ID = puntoFact.ID_PUNTO ';
      Lt_ArrayParamsBind('Fn_NumFacturasAbiertas') := Fn_NumFacturasAbiertas;
      Lv_AgregarEstadoActivo := 'S';
    END IF;
  
    IF TRIM(Fv_FechaDesdeFactura) IS NOT NULL OR
       TRIM(Fv_FechaHastaFactura) IS NOT NULL OR
       TRIM(Fv_UsrCreacionFactura) IS NOT NULL OR
       Lt_ArrayParamsVarsNotif.EXISTS('MES_ANIO_CONSUMO_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('FECHA_EMISION_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('NUMERO_FACTURA') OR
       Lt_ArrayParamsVarsNotif.EXISTS('VALOR_FACTURA') THEN
    
      Lv_JoinAdic := Lv_JoinAdic ||
                     ' INNER JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB facturas
                                                  ON facturas.PUNTO_ID = puntoFact.ID_PUNTO 
                                                  INNER JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO tipoDoc
                                                  ON tipoDoc.ID_TIPO_DOCUMENTO = facturas.TIPO_DOCUMENTO_ID  ';
    
      Lv_Where               := Lv_Where ||
                                'AND tipoDoc.CODIGO_TIPO_DOCUMENTO IN ( :Lv_DocFacp , :Lv_DocFac ) 
                               AND facturas.ESTADO_IMPRESION_FACT =  :Lv_EstadoActivo ';
      Lv_AgregarEstadoActivo := 'S';
    
      IF TRIM(Fv_UsrCreacionFactura) IS NOT NULL THEN
        Lv_Where := Lv_Where ||
                    'AND facturas.USR_CREACION =  :Fv_UsrCreacionFactura ';
        Lt_ArrayParamsBind('Fv_UsrCreacionFactura') := Fv_UsrCreacionFactura;
      END IF;
    
      IF TRIM(Fv_FechaDesdeFactura) IS NOT NULL OR
         TRIM(Fv_FechaHastaFactura) IS NOT NULL THEN
        Lv_Where := Lv_Where ||
                    'AND facturas.FE_AUTORIZACION IS NOT NULL AND ( ';
        IF TRIM(Fv_FechaDesdeFactura) IS NOT NULL THEN
          Lv_FechaDesdeFact := ' facturas.FE_EMISION >= TO_DATE( :Fv_FechaDesdeFactura , ''yyyy-mm-dd'') ';
          Lt_ArrayParamsBind('Fv_FechaDesdeFactura') := Fv_FechaDesdeFactura;
        END IF;
      
        IF TRIM(Fv_FechaHastaFactura) IS NOT NULL THEN
          Lv_FechaHastaFact := '  facturas.FE_EMISION < TO_DATE( :Fv_FechaHastaFactura , ''yyyy-mm-dd'') ';
          Lt_ArrayParamsBind('Fv_FechaHastaFactura') := Fv_FechaHastaFactura;
        END IF;
      
        IF TRIM(Lv_FechaDesdeFact) IS NOT NULL AND
           TRIM(Lv_FechaHastaFact) IS NOT NULL THEN
          Lv_FechaDesdeHastaFact := Lv_FechaDesdeFact || ' AND ' ||
                                    Lv_FechaHastaFact || ' ';
        ELSE
          Lv_FechaDesdeHastaFact := Lv_FechaDesdeFact || ' ' ||
                                    Lv_FechaHastaFact || ' ';
        END IF;
        Lv_Where := Lv_Where || Lv_FechaDesdeHastaFact || ') ';
      END IF;
    END IF;
  
    IF TRIM(Fv_SaldoPendientePago) IS NOT NULL AND
       Fv_SaldoPendientePago = 'S' OR
       Lt_ArrayParamsVarsNotif.EXISTS('SALDO_PUNTO_FACT') THEN
      Lv_JoinAdic := Lv_JoinAdic ||
                     ' INNER JOIN DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO vecrp
                                        ON vecrp.PUNTO_ID = puntoFact.ID_PUNTO ';
      IF TRIM(Ff_ValorSaldoPendientePago) IS NOT NULL AND
         Ff_ValorSaldoPendientePago > 0 THEN
        Lv_Where := Lv_Where ||
                    'AND vecrp.SALDO >= :Ff_ValorSaldoPendientePago ';
        Lt_ArrayParamsBind('Ff_ValorSaldoPendientePago') := Ff_ValorSaldoPendientePago;
      ELSE
        Lv_Where := Lv_Where ||
                    'AND vecrp.SALDO > :Ff_ValorSaldoPendientePago ';
        Lt_ArrayParamsBind('Ff_ValorSaldoPendientePago') := 0;
      END IF;
    END IF;
  
    IF ((TRIM(Fn_IdFormaPago) IS NOT NULL AND Fn_IdFormaPago > 0) OR
       TRIM(Fv_IdsBancosTarjetas) IS NOT NULL OR
       TRIM(Fv_ClientesVIP) IS NOT NULL) THEN
      Lv_JoinAdic            := Lv_JoinAdic ||
                                ' INNER JOIN DB_COMERCIAL.INFO_CONTRATO contrato
                                      ON contrato.PERSONA_EMPRESA_ROL_ID = per.ID_PERSONA_ROL ';
      Lv_Where               := Lv_Where ||
                                'AND contrato.ESTADO = :Lv_EstadoActivo ';
      Lv_AgregarEstadoActivo := 'S';
      IF TRIM(Fv_ClientesVIP) IS NOT NULL THEN
        IF TRIM(Fv_ClientesVIP) = 'S' THEN
          Lv_JoinAdic := Lv_JoinAdic ||
                         ' INNER JOIN DB_COMERCIAL.INFO_CONTRATO_DATO_ADICIONAL contratoAdicVip 
                                          ON contratoAdicVip.CONTRATO_ID = contrato.ID_CONTRATO ';
          Lv_Where := Lv_Where ||
                      'AND contratoAdicVip.ES_VIP =  :Fv_ClientesVIP ';
          Lt_ArrayParamsBind('Fv_ClientesVIP') := Fv_ClientesVIP;
        ELSE
          IF TRIM(Fv_ClientesVIP) = 'N' THEN
            Lv_JoinAdic := Lv_JoinAdic ||
                           ' LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_DATO_ADICIONAL contratoAdicVip 
                                              ON contratoAdicVip.CONTRATO_ID = contrato.ID_CONTRATO ';
            Lv_Where := Lv_Where ||
                        'AND (contratoAdicVip.ES_VIP =  :Fv_ClientesVIP  
                                          OR contratoAdicVip.ID_DATO_ADICIONAL IS NULL) ';
            Lt_ArrayParamsBind('Fv_ClientesVIP') := Fv_ClientesVIP;
          END IF;
        END IF;
      END IF;
    
      IF TRIM(Fn_IdFormaPago) IS NOT NULL AND Fn_IdFormaPago > 0 THEN
        Lv_JoinAdic := Lv_JoinAdic ||
                       ' INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO formaPago
                                          ON formaPago.ID_FORMA_PAGO = contrato.FORMA_PAGO_ID  ';
        Lv_Where := Lv_Where ||
                    'AND formaPago.ID_FORMA_PAGO = :Fn_IdFormaPago ';
        Lt_ArrayParamsBind('Fn_IdFormaPago') := Fn_IdFormaPago;
        IF TRIM(Fv_IdsBancosTarjetas) IS NOT NULL THEN
          IF (TRIM(Fv_NombreFormaPago) IS NOT NULL AND
             (TRIM(Fv_NombreFormaPago) = 'TARJETA DE CREDITO' OR
             TRIM(Fv_NombreFormaPago) = 'DEBITO BANCARIO')) THEN
            Lv_JoinAdic            := Lv_JoinAdic ||
                                      ' INNER JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO contratoFormaPago
                                              ON contratoFormaPago.CONTRATO_ID = contrato.ID_CONTRATO
                                              INNER JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA bancoTipoCuenta
                                              ON bancoTipoCuenta.ID_BANCO_TIPO_CUENTA = contratoFormaPago.BANCO_TIPO_CUENTA_ID ';
            Lv_Where               := Lv_Where ||
                                      'AND contratoFormaPago.ESTADO = :Lv_EstadoActivo ';
            Lv_AgregarEstadoActivo := 'S';
            Lv_BancosTarjetas      := 'SELECT regexp_substr(:Fv_IdsBancosTarjetas, ''[^,]+'', 1, LEVEL) id_banco_tarjeta
                                  FROM dual
                                  CONNECT BY LEVEL <= length(:Fv_IdsBancosTarjetas) - length(REPLACE(:Fv_IdsBancosTarjetas, '','', '''')) + 1 ';
            IF TRIM(Fv_NombreFormaPago) = 'DEBITO BANCARIO' THEN
              Lv_Where := Lv_Where || 'AND bancoTipoCuenta.BANCO_ID IN ( ' ||
                          Lv_BancosTarjetas || ' ) ';
              Lt_ArrayParamsBind('Fv_IdsBancosTarjetas') := Fv_IdsBancosTarjetas;
            END IF;
            IF TRIM(Fv_NombreFormaPago) = 'TARJETA DE CREDITO' THEN
              Lv_Where := Lv_Where ||
                          'AND bancoTipoCuenta.TIPO_CUENTA_ID IN ( ' ||
                          Lv_BancosTarjetas || ' ) ';
              Lt_ArrayParamsBind('Fv_IdsBancosTarjetas') := Fv_IdsBancosTarjetas;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  
    IF Fv_DestinatariosCorreo IS NOT NULL AND Fv_DestinatariosCorreo = 'S' THEN
      IF Lt_ArrayParamsVarsNotif.EXISTS('NUM_PUNTOS_AFECTADOS') THEN
        Lv_WithPrincipal := Lv_WithPrincipal ||
                            ' NUM_PUNTOS_PTO_FACT AS ( SELECT puntoFact.ID_PUNTO,
                                                                            COUNT (DISTINCT puntoAfectado.ID_PUNTO) AS NUM_PUNTOS 
                                                                            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                                                            INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                                                            ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                                                            INNER JOIN DB_COMERCIAL.INFO_PUNTO puntoFact
                                                                            ON iper.ID_PERSONA_ROL = puntoFact.PERSONA_EMPRESA_ROL_ID
                                                                            INNER JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL datoPuntoFact
                                                                            ON datoPuntoFact.PUNTO_ID = puntoFact.ID_PUNTO 
                                                                            INNER JOIN DB_COMERCIAL.INFO_SERVICIO servicioAfectado 
                                                                            ON servicioAfectado.PUNTO_FACTURACION_ID = puntoFact.ID_PUNTO
                                                                            INNER JOIN DB_COMERCIAL.INFO_PUNTO puntoAfectado
                                                                            ON puntoAfectado.ID_PUNTO = servicioAfectado.PUNTO_ID
                                                                            WHERE datoPuntoFact.ES_PADRE_FACTURACION = :LvSiEsPadreFacturacion
                                                                            AND puntoAfectado.ESTADO = :Lv_EstadoActivo
                                                                            AND ier.EMPRESA_COD = :Lv_CodEmpresa
                                                                            GROUP BY puntoFact.ID_PUNTO ),';
        Lt_ArrayParamsBind('LvSiEsPadreFacturacion') := 'S';
      
        Lv_JoinAdic            := Lv_JoinAdic ||
                                  ' INNER JOIN NUM_PUNTOS_PTO_FACT numPuntosPtoFact 
                                                      ON numPuntosPtoFact.ID_PUNTO = puntoFact.ID_PUNTO  ';
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', numPuntosPtoFact.NUM_PUNTOS AS NUM_PUNTOS_AFECTADOS ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.NUM_PUNTOS_AFECTADOS ';
        Lv_AgregarEstadoActivo := 'S';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', 0 AS NUM_PUNTOS_AFECTADOS ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.NUM_PUNTOS_AFECTADOS ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('MES_ANIO_CONSUMO_FACTURA') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', COALESCE(CONCAT(facturas.MES_CONSUMO, CONCAT(''/'', facturas.ANIO_CONSUMO)),'''') 
                                                                AS MES_ANIO_CONSUMO_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.MES_ANIO_CONSUMO_FACTURA ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', '''' AS MES_ANIO_CONSUMO_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.MES_ANIO_CONSUMO_FACTURA ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('FECHA_EMISION_FACTURA') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', COALESCE(TO_CHAR(facturas.FE_EMISION,''DD/MM/YYYY''),'''') AS FECHA_EMISION_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.FECHA_EMISION_FACTURA ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', '''' AS FECHA_EMISION_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.FECHA_EMISION_FACTURA ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('NUMERO_FACTURA') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', facturas.NUMERO_FACTURA_SRI AS NUMERO_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.NUMERO_FACTURA ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', '''' AS NUMERO_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.NUMERO_FACTURA ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('VALOR_FACTURA') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', facturas.VALOR_TOTAL AS VALOR_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.VALOR_FACTURA ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', 0.00 AS VALOR_FACTURA ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.VALOR_FACTURA ';
      END IF;
    
      IF Lt_ArrayParamsVarsNotif.EXISTS('SALDO_PUNTO_FACT') THEN
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', vecrp.SALDO AS SALDO_PUNTO_FACT ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.SALDO_PUNTO_FACT ';
      ELSE
        Lv_SelectVarsPrincipal := Lv_SelectVarsPrincipal ||
                                  ', 0.00 AS SALDO_PUNTO_FACT ';
        Lv_SelectVarsNotif     := Lv_SelectVarsNotif ||
                                  ', puntosConsulta.SALDO_PUNTO_FACT ';
      END IF;
    END IF;
  
    IF TRIM(Lv_WithPrincipal) IS NOT NULL THEN
      Lv_WithPrincipal := 'WITH ' ||
                          TRIM(TRAILING ',' FROM Lv_WithPrincipal) || ' ';
    END IF;
  
    IF Lv_AgregarEstadoActivo = 'S' THEN
      Lt_ArrayParamsBind('Lv_EstadoActivo') := Lv_EstadoActivo;
      Lv_AgregarEstadoActivo := 'N';
    END IF;
  
    Lcl_QueryFinal := Lv_SelectPrincipal || Lv_SelectVarsPrincipal ||
                      Lv_QueryPrincipal || Lv_JoinAdic || Lv_Where;
  
    IF Lv_AgregarOrderBy = 'S' THEN
      Lcl_QueryFinal := Lcl_QueryFinal || Lv_OrderByPrincipal;
    END IF;
  
    IF Fv_DestinatariosCorreo IS NOT NULL AND Fv_DestinatariosCorreo = 'S' THEN
      Fn_TotalRegistros := 0;
    
      IF TRIM(Lv_WithPrincipal) IS NOT NULL THEN
        Lcl_QueryDestinatarios := Lv_WithPrincipal ||
                                  ', PUNTOS_CONSULTA AS (' ||
                                  Lcl_QueryFinal || ') ';
      ELSE
        Lcl_QueryDestinatarios := 'WITH PUNTOS_CONSULTA AS (' ||
                                  Lcl_QueryFinal || ') ';
      END IF;
      Lcl_QueryDestinatarios := Lcl_QueryDestinatarios ||
                                'SELECT DISTINCT 
                                    puntosConsulta.NOMBRES_CLIENTE,
                                    CASE
                                        WHEN persona.RAZON_SOCIAL IS NOT NULL THEN
                                        persona.RAZON_SOCIAL
                                        ELSE
                                        CONCAT(CONCAT (NVL(persona.NOMBRES, ''''),'' ''), NVL(persona.APELLIDOS, '''')) 
                                    END AS NOMBRES_CONTACTO,
                                    personaFormaContacto.VALOR AS CORREO,
                                    rol.DESCRIPCION_ROL AS TIPO_CONTACTO,
                                    puntosConsulta.LOGIN ' ||
                                Lv_SelectVarsNotif ||
                                ' FROM DB_COMERCIAL.INFO_PUNTO_CONTACTO puntoContacto
                                    INNER JOIN PUNTOS_CONSULTA puntosConsulta
                                    ON puntosConsulta.ID_PUNTO = puntoContacto.PUNTO_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PERSONA persona
                                    ON persona.ID_PERSONA = puntoContacto.CONTACTO_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL perContacto
                                    ON perContacto.PERSONA_ID = persona.ID_PERSONA
                                    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ierContacto
                                    ON ierContacto.ID_EMPRESA_ROL = perContacto.EMPRESA_ROL_ID
                                    INNER JOIN DB_GENERAL.ADMI_ROL rol
                                    ON rol.ID_ROL = ierContacto.ROL_ID
                                    INNER JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO personaFormaContacto 
                                    ON personaFormaContacto.PERSONA_ID = persona.ID_PERSONA
                                    INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO formaContacto 
                                    ON formaContacto.ID_FORMA_CONTACTO = personaFormaContacto.FORMA_CONTACTO_ID
                                    WHERE ierContacto.EMPRESA_COD = :Lv_CodEmpresa 
                                    AND formaContacto.DESCRIPCION_FORMA_CONTACTO = :Lv_TipoEnvio  
                                    AND puntoContacto.ESTADO = :Lv_EstadoActivo 
                                    AND personaFormaContacto.ESTADO = :Lv_EstadoActivo  
                                    AND perContacto.ESTADO = :Lv_EstadoActivo ';
      IF Lv_AgregarEstadoActivo = 'S' THEN
        Lt_ArrayParamsBind('Lv_EstadoActivo') := Lv_EstadoActivo;
        Lv_AgregarEstadoActivo := 'N';
      END IF;
      IF TRIM(Fv_IdsTiposContactos) IS NOT NULL THEN
        Lcl_QueryDestinatarios := Lcl_QueryDestinatarios ||
                                  ' AND ierContacto.ID_EMPRESA_ROL IN ' ||
                                  '(SELECT regexp_substr(:Fv_IdsTiposContactos, ''[^,]+'', 1, LEVEL) id_tipo_contacto 
                                      FROM dual
                                      CONNECT BY LEVEL <= length(:Fv_IdsTiposContactos) - length(REPLACE(:Fv_IdsTiposContactos, '','', '''')) + 1 ) ';
        Lt_ArrayParamsBind('Fv_IdsTiposContactos') := Fv_IdsTiposContactos;
      END IF;
      Lt_ArrayParamsBind('Lv_TipoEnvio') := Lv_TipoEnvio;
      Lcl_QueryFinal := Lcl_QueryDestinatarios;
    
    ELSE
      Lcl_QueryCount   := Lv_WithPrincipal || Lv_SelectCountPrincipal ||
                          Lv_QueryPrincipal || Lv_JoinAdic || Lv_Where;
      Lcl_QueryFinal   := Lv_WithPrincipal || Lcl_QueryFinal;
    END IF;
  
    Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
    DBMS_SQL.PARSE(Ln_IdCursor, Lcl_QueryFinal, DBMS_SQL.NATIVE);
    Lv_NombreParamBind := Lt_ArrayParamsBind.FIRST;
    WHILE (Lv_NombreParamBind IS NOT NULL) LOOP
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             Lv_NombreParamBind,
                             Lt_ArrayParamsBind(Lv_NombreParamBind));
      Lv_NombreParamBind := Lt_ArrayParamsBind.NEXT(Lv_NombreParamBind);
    END LOOP;
  
    Ln_NumExecPrincipal   := DBMS_SQL.EXECUTE(Ln_IdCursor);
    Lrf_ConsultaPrincipal := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
    RETURN Lrf_ConsultaPrincipal;
  
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_SERVICIOS_NOTIF_MASIVA',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               Lv_UsrCreacion),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
      RETURN NULL;
  END F_GET_SERVICIOS_NOTIF_MASIVA;

  --
  FUNCTION F_GET_INFO_DASHBOARD_SERVICIO(Fn_IdDashboardServicio IN DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ID_DASHBOARD_SERVICIO%TYPE,
                                         Fv_Buscar              IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    --CURSOR QUE RETORNA LA INFORMACION CORRESPONDIENTE AL LA INFORMACION DEL DASHBOARD DEL SERVICIO A BUSCAR
    --COSTO DEL QUERY: 3
    CURSOR C_GetInfoDashboardServicio(Cn_IdDashboardServicio DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ID_DASHBOARD_SERVICIO%TYPE) IS
    --
      SELECT IDS.ID_DASHBOARD_SERVICIO,
             IDS.ESTADO,
             IDS.SERVICIO_ID,
             IDS.PROCESADO,
             IDS.PRECIO_VENTA,
             IDS.FECHA_TRANSACCION,
             IDS.ACCION
        FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS
       WHERE IDS.ID_DASHBOARD_SERVICIO = Cn_IdDashboardServicio;
    --
    Lv_FechaResultado           VARCHAR2(50);
    Lr_GetInfoDashboardServicio C_GetInfoDashboardServicio%ROWTYPE;
    --
  BEGIN
    --
    IF C_GetInfoDashboardServicio%ISOPEN THEN
      CLOSE C_GetInfoDashboardServicio;
    END IF;
    --
    OPEN C_GetInfoDashboardServicio(Fn_IdDashboardServicio);
    --
    FETCH C_GetInfoDashboardServicio
      INTO Lr_GetInfoDashboardServicio;
    --
    CLOSE C_GetInfoDashboardServicio;
    --
    --
    IF Lr_GetInfoDashboardServicio.ID_DASHBOARD_SERVICIO > 0 THEN
      --
      IF Fv_Buscar = 'Estado' THEN
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.ESTADO, NULL);
        --
      ELSIF Fv_Buscar = 'Procesado' THEN
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.PROCESADO,
                                 NULL);
        --
      ELSIF Fv_Buscar = 'PrecioVenta' THEN
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.PRECIO_VENTA,
                                 '0');
        --
      ELSIF Fv_Buscar = 'FechaTransaccion' THEN
        --
        Lv_FechaResultado := Lr_GetInfoDashboardServicio.FECHA_TRANSACCION;
        --
      ELSIF Fv_Buscar = 'Accion' THEN
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.ACCION, NULL);
        --
      ELSE
        --
        Lv_FechaResultado := NVL(Lr_GetInfoDashboardServicio.ESTADO, NULL);
        --
      END IF;
      --
    END IF; --Lr_GetInfoDashboardServicio.ID_DASHBOARD_SERVICIO > 0
    --
    --
    RETURN Lv_FechaResultado;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_FechaResultado := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_TRANSACTION.P_MIGRA_INFORMACION_DASHBOARD',
                                           'Error al consultar la informacion del dashboard de servicios - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'telcos'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
      RETURN Lv_FechaResultado;
      --
  END F_GET_INFO_DASHBOARD_SERVICIO;
  --
  --
  PROCEDURE P_GET_VENDEDORES_POR_META(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                      Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                      Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                      Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                      Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                      Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                      Pv_TipoVendedor        IN VARCHAR2,
                                      Pv_TipoPersonal        IN VARCHAR2,
                                      Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                      Pr_ListadoVendedores   OUT SYS_REFCURSOR) IS
    --
    Lv_Query         CLOB;
    Lv_Select        CLOB;
    Lv_GroupBy       CLOB;
    Lv_FromWhereJoin CLOB;
    Lv_OrderBy       CLOB;
    Le_Exception EXCEPTION;
    Lv_MensajeError        VARCHAR2(4000);
    Lv_TipoOrdenes         VARCHAR2(30);
    Ln_IdCursor            NUMBER;
    Ln_NumeroRegistros     NUMBER;
    Lv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_GrupoRolesPersonal  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'GRUPO_ROLES_PERSONAL';
    Lv_ValorCategorias     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_EstadosServicios    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_ProvinciasNoAplican DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'PROVINCIAS_NO_APLICAN';
    Lv_Vendedor            DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'VENDEDOR';
    Lv_Proceso             DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo              DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta             DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden           DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    Lv_TipoVendedor        DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'TIPO_VENDEDOR';
    Lv_CaracGrupoRoles     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CARGO_GRUPO_ROLES_PERSONAL';
    Lv_Empleado            DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE := 'Empleado';
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL AND TRIM(Pv_TipoVendedor) IS NOT NULL THEN
      --
      IF TRIM(Pv_TipoVendedor) = 'PROVINCIAS_AGRUPADAS' THEN
        --
        Lv_Select  := 'SELECT TBL_METAS.NOMBRE_CANTON AS VENDEDOR, SUM(TBL_METAS.TOTAL_VENTA) AS TOTAL_VENTA ';
        Lv_GroupBy := 'GROUP BY TBL_METAS.NOMBRE_CANTON ';
        Lv_OrderBy := 'ORDER BY TBL_METAS.NOMBRE_CANTON ';
        --
      ELSIF TRIM(Pv_TipoVendedor) = 'PROVINCIAS' THEN
        --
        Lv_Select  := 'SELECT TBL_METAS.VENDEDOR, TBL_METAS.NOMBRE_CANTON AS CANTON, SUM(TBL_METAS.TOTAL_VENTA) AS TOTAL_VENTA ';
        Lv_GroupBy := 'GROUP BY TBL_METAS.NOMBRE_CANTON, TBL_METAS.VENDEDOR ';
        Lv_OrderBy := 'ORDER BY TBL_METAS.NOMBRE_CANTON, TBL_METAS.VENDEDOR ';
        --
      ELSE
        --
        Lv_Select  := 'SELECT TBL_METAS.VENDEDOR, SUM(TBL_METAS.TOTAL_VENTA) AS TOTAL_VENTA ';
        Lv_GroupBy := 'GROUP BY TBL_METAS.VENDEDOR ';
        Lv_OrderBy := 'ORDER BY TBL_METAS.VENDEDOR ';
        --
      END IF;
      --
      --
      Lv_FromWhereJoin := 'FROM ( ' ||
                          '  SELECT CONCAT(IPE.NOMBRES, CONCAT('' '', IPE.APELLIDOS)) AS VENDEDOR, ' ||
                          '         AC.NOMBRE_CANTON, ' ||
                          '         SUM( ROUND( ( ( (NVL(IDS.PRECIO_VENTA, 0) * NVL(IDS.CANTIDAD, 0)) - NVL(IDS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                          '                       ( NVL(IDS.PRECIO_INSTALACION, 0) / 12 ) ), 2 ) ) AS TOTAL_VENTA ' ||
                          '  FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS ' ||
                          '  JOIN ( ' ||
                          '         SELECT IDSER.USR_VENDEDOR, MAX(IPERS.ID_PERSONA_ROL) AS ID_PERSONA_ROL ' ||
                          '         FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDSER ' ||
                          '         JOIN DB_COMERCIAL.INFO_PERSONA IPES ' ||
                          '         ON IPES.LOGIN = IDSER.USR_VENDEDOR ' ||
                          '         JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPERS ' ||
                          '         ON IPERS.PERSONA_ID = IPES.ID_PERSONA ' ||
                          '         JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IERS ' ||
                          '         ON IERS.ID_EMPRESA_ROL = IPERS.EMPRESA_ROL_ID ' ||
                          '         JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEGS ' ||
                          '         ON IEGS.COD_EMPRESA = IERS.EMPRESA_COD ' ||
                          '         JOIN DB_GENERAL.ADMI_ROL ARS ' ||
                          '         ON ARS.ID_ROL = IERS.ROL_ID ' ||
                          '         JOIN DB_GENERAL.ADMI_TIPO_ROL ATRS ' ||
                          '         ON ATRS.ID_TIPO_ROL = ARS.TIPO_ROL_ID ' ||
                          '         WHERE IEGS.PREFIJO = :Pv_PrefijoEmpresa ' ||
                          '         AND IPERS.ESTADO = :Lv_EstadoActivo ' ||
                          '         AND ATRS.DESCRIPCION_TIPO_ROL = :Lv_Empleado ' ||
                          '         GROUP BY IDSER.USR_VENDEDOR ' ||
                          '       ) TBL_IPER ' ||
                          'ON IDS.USR_VENDEDOR = TBL_IPER.USR_VENDEDOR ' ||
                          'JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ' ||
                          'ON IPER.ID_PERSONA_ROL = TBL_IPER.ID_PERSONA_ROL ' ||
                          'JOIN DB_COMERCIAL.INFO_PERSONA IPE ' ||
                          'ON IPER.PERSONA_ID = IPE.ID_PERSONA ' ||
                          'JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ' ||
                          'ON IOG.ID_OFICINA = IPER.OFICINA_ID ' ||
                          'JOIN DB_GENERAL.ADMI_CANTON AC ' ||
                          'ON AC.ID_CANTON = IOG.CANTON_ID ' ||
                          'WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDS.PUNTO_ID, NULL) = :Pv_PrefijoEmpresa ' ||
                          'AND IDS.ES_VENTA = :Lv_EsVenta ' ||
                          'AND IDS.TIPO_ORDEN = :Lv_TipoOrden ' ||
                          'AND IDS.FECHA_TRANSACCION >= :Pd_FechaInicio ' ||
                          'AND IDS.FECHA_TRANSACCION < :Pd_FechaFin ' ||
                          'AND IDS.ESTADO NOT IN ( ' ||
                          '  SELECT APD.DESCRIPCION ' ||
                          '  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                          '  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                          '  ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                          '  WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                          '  AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                          '  AND APD.VALOR2      = :Lv_EstadosServicios ' ||
                          '  AND APD.EMPRESA_COD = ( ' ||
                          '    SELECT COD_EMPRESA ' ||
                          '    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                          '    WHERE ESTADO = :Lv_EstadoActivo ' ||
                          '    AND PREFIJO  = :Pv_PrefijoEmpresa ' ||
                          '  ) ' || ') ';
      --
      --
      IF TRIM(Pv_TipoVendedor) = 'PROVINCIAS_AGRUPADAS' THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            'AND AC.NOMBRE_CANTON NOT IN ( ' ||
                            '  SELECT APD.DESCRIPCION ' ||
                            '  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                            '  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                            '  ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                            '  WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                            '  AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                            '  AND APD.VALOR1      = :Lv_ProvinciasNoAplican ' ||
                            '  AND APD.EMPRESA_COD = ( ' ||
                            '    SELECT COD_EMPRESA ' ||
                            '    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                            '    WHERE ESTADO = :Lv_EstadoActivo ' ||
                            '    AND PREFIJO  = :Pv_PrefijoEmpresa ' ||
                            '  ) ' || ') ';
        --
      ELSE
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin || 'AND IPE.ID_PERSONA IN ( ' ||
                            '  SELECT IPER_S.PERSONA_ID ' ||
                            '  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                            '  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC_S ' ||
                            '  ON IPER_S.ID_PERSONA_ROL = IPERC_S.PERSONA_EMPRESA_ROL_ID ' ||
                            '  JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC_S ' ||
                            '  ON AC_S.ID_CARACTERISTICA = IPERC_S.CARACTERISTICA_ID ' ||
                            '  WHERE AC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND IPERC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND IPERC_S.VALOR = :Pv_TipoVendedor ' ||
                            '  AND AC_S.DESCRIPCION_CARACTERISTICA = :Lv_TipoVendedor ' || ') ' ||
                            'AND IPE.ID_PERSONA IN ( ' ||
                            '  SELECT IPER_S.PERSONA_ID ' ||
                            '  FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                            '  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC_S ' ||
                            '  ON IPER_S.ID_PERSONA_ROL = IPERC_S.PERSONA_EMPRESA_ROL_ID ' ||
                            '  JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC_S ' ||
                            '  ON AC_S.ID_CARACTERISTICA = IPERC_S.CARACTERISTICA_ID ' ||
                            '  WHERE AC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND IPERC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND IPERC_S.VALOR = ( ' ||
                            '  SELECT TRIM(TO_CHAR(APD_S.ID_PARAMETRO_DET, ''999999999'')) ' ||
                            '  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD_S ' ||
                            '  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC_S ' ||
                            '  ON APD_S.PARAMETRO_ID = APC_S.ID_PARAMETRO ' ||
                            '  WHERE APC_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND APD_S.ESTADO = :Lv_EstadoActivo ' ||
                            '  AND APC_S.NOMBRE_PARAMETRO = :Lv_GrupoRolesPersonal ' ||
                            '  AND APD_S.DESCRIPCION = :Lv_Vendedor ' ||
                            '  ) ' ||
                            '  AND AC_S.DESCRIPCION_CARACTERISTICA = :Lv_CaracGrupoRoles ' || ') ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            'AND IDS.USR_VENDEDOR IN ( ' ||
                            ' SELECT IPE_S.LOGIN ' ||
                            ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                            ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                            ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_FromWhereJoin := Lv_FromWhereJoin ||
                              'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_FromWhereJoin := Lv_FromWhereJoin ||
                              'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin || ' ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            ' AND IDS.CATEGORIA = :Pv_Categoria ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            ' AND IDS.GRUPO = :Pv_Grupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin ||
                            ' AND IDS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_FromWhereJoin := Lv_FromWhereJoin || ' AND IDS.CATEGORIA IN ( ' ||
                            ' SELECT APD.DESCRIPCION ' ||
                            ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                            ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                            ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                            ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                            ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                            ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                            ' AND APC.PROCESO = :Lv_Proceso ' ||
                            ' AND APC.MODULO = :Lv_Modulo ' ||
                            ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                            ' AND APD.EMPRESA_COD = ( ' ||
                            '   SELECT COD_EMPRESA ' ||
                            '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                            '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                            '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' ||
                            ' ) ) ';
        --
      END IF;
      --
      --
      Lv_FromWhereJoin := Lv_FromWhereJoin ||
                          ' GROUP BY IPE.NOMBRES, IPE.APELLIDOS, AC.NOMBRE_CANTON) TBL_METAS ';
      --
      --
      --COSTO QUERY: 355
      Lv_Query := Lv_Select || Lv_FromWhereJoin || Lv_GroupBy || Lv_OrderBy;
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Empleado', Lv_Empleado);
      --
      --
      IF TRIM(Pv_TipoVendedor) = 'PROVINCIAS_AGRUPADAS' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ProvinciasNoAplican',
                               Lv_ProvinciasNoAplican);
        --
      ELSE
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Vendedor', Lv_Vendedor);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_TipoVendedor',
                               Pv_TipoVendedor);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_TipoVendedor',
                               Lv_TipoVendedor);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_CaracGrupoRoles',
                               Lv_CaracGrupoRoles);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_GrupoRolesPersonal',
                               Lv_GrupoRolesPersonal);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_NombreParametro',
                               Lv_NombreParametro);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      Ln_NumeroRegistros   := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_ListadoVendedores := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), ' || 'Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pr_ListadoVendedores := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_VENDEDORES_POR_META',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pr_ListadoVendedores := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_VENDEDORES_POR_META',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_VENDEDORES_POR_META;
  --
  --
  PROCEDURE P_GET_LIST_VENDEDOR_DESTACADOS(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                           Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                           Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                           Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                           Pv_TipoPersonal        IN VARCHAR2,
                                           Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                           Pn_Rownum              IN NUMBER,
                                           Pr_ListadoVendedores   OUT SYS_REFCURSOR) IS
    --
    Lv_Query CLOB;
    Le_Exception EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_TipoOrdenes      VARCHAR2(30);
    Ln_IdCursor         NUMBER;
    Ln_NumeroRegistros  NUMBER;
    Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_EstadosServicios DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso          DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta          DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden        DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_Query := 'SELECT TBL_VENDEDOR_ORDENADO.VALOR_VENTA, ' ||
                  '       TBL_VENDEDOR_ORDENADO.VENDEDOR ' || 'FROM ( ' ||
                  'SELECT TBL_VENDEDOR.VALOR_VENTA, ' ||
                  '       TBL_VENDEDOR.VENDEDOR ' || 'FROM ' ||
                  '( SELECT SUM( ROUND( ( ( ( NVL(IDS.PRECIO_VENTA, 0) * NVL(IDS.CANTIDAD, 0) ) ) - NVL(IDS.DESCUENTO_TOTALIZADO, 0) ' ||
                  '                       + ( NVL(IDS.PRECIO_INSTALACION, 0) / 12 ) ), 2 ) ) AS VALOR_VENTA, ' ||
                  '         CONCAT(IPE.NOMBRES, CONCAT('' '', IPE.APELLIDOS)) AS VENDEDOR ' ||
                  '  FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS ' ||
                  '  JOIN DB_COMERCIAL.INFO_PERSONA IPE ' ||
                  '  ON IPE.LOGIN = IDS.USR_VENDEDOR ' ||
                  '  JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                  '  ON AP.ID_PRODUCTO  = IDS.PRODUCTO_ID ' ||
                  '  WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDS.PUNTO_ID, NULL) = :Pv_PrefijoEmpresa ' ||
                  '  AND IDS.FECHA_TRANSACCION                                                    >= :Pd_FechaInicio ' ||
                  '  AND IDS.FECHA_TRANSACCION                                                     < :Pd_FechaFin ' ||
                  '  AND IDS.ES_VENTA                                                              = :Lv_EsVenta ' ||
                  '  AND IDS.TIPO_ORDEN                                                            = :Lv_TipoOrden ' ||
                  '  AND IDS.ESTADO                                                                NOT IN ( ' ||
                  '    SELECT APD.DESCRIPCION ' ||
                  '    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '    JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '    ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  '    WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                  '    AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                  '    AND APD.VALOR2      = :Lv_EstadosServicios ' ||
                  '    AND APD.EMPRESA_COD = ( ' ||
                  '      SELECT COD_EMPRESA ' ||
                  '      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  '      WHERE ESTADO = :Lv_EstadoActivo ' ||
                  '      AND PREFIJO  = :Pv_PrefijoEmpresa ) ' || '  ) ';
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Query := Lv_Query || ' ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';        
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.GRUPO = :Pv_Grupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      Lv_Query := Lv_Query || 'GROUP BY IPE.NOMBRES, IPE.APELLIDOS ' ||
                  ') TBL_VENDEDOR ' ||
                  'ORDER BY TBL_VENDEDOR.VALOR_VENTA DESC ' ||
                  ') TBL_VENDEDOR_ORDENADO ' ||
                  'WHERE ROWNUM <= NVL(:Pn_Rownum, 1) ';
      --
      --
      --COSTO QUERY: 334
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pn_Rownum', Pn_Rownum);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_NombreParametro',
                               Lv_NombreParametro);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      Ln_NumeroRegistros   := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_ListadoVendedores := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), ' || 'Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pr_ListadoVendedores := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_LIST_VENDEDOR_DESTACADOS',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pr_ListadoVendedores := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_LIST_VENDEDOR_DESTACADOS',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_LIST_VENDEDOR_DESTACADOS;
  --
  --
  PROCEDURE P_GET_LIST_PRODUCTO_DESTACADOS(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                           Pd_FechaInicio         IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pd_FechaFin            IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                           Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                           Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                           Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                           Pv_TipoPersonal        IN VARCHAR2,
                                           Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                           Pn_Rownum              IN NUMBER,
                                           Pr_ListadoProductos    OUT SYS_REFCURSOR) IS
    --
    Lv_Query CLOB;
    Le_Exception EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_TipoOrdenes      VARCHAR2(30);
    Ln_IdCursor         NUMBER;
    Ln_NumeroRegistros  NUMBER;
    Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_EstadosServicios DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso          DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta          DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden        DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_Query := 'SELECT TBL_PRODUCTO_ORDENADO.VALOR_VENTA, ' ||
                  '       TBL_PRODUCTO_ORDENADO.DESCRIPCION_PRODUCTO ' ||
                  'FROM (' || 'SELECT TBL_PRODUCTO.VALOR_VENTA, ' ||
                  '       TBL_PRODUCTO.DESCRIPCION_PRODUCTO ' || 'FROM ' ||
                  '( SELECT SUM( ROUND( ( ( ( NVL(IDS.PRECIO_VENTA, 0) * NVL(IDS.CANTIDAD, 0) ) - NVL(IDS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                  '                       ( NVL(IDS.PRECIO_INSTALACION, 0) / 12 ) ) , 2 ) ) AS VALOR_VENTA, ' ||
                  '         AP.DESCRIPCION_PRODUCTO ' ||
                  '  FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS ' ||
                  '  JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                  '  ON AP.ID_PRODUCTO = IDS.PRODUCTO_ID ' ||
                  '  WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDS.PUNTO_ID, NULL) = :Pv_PrefijoEmpresa ' ||
                  '  AND IDS.FECHA_TRANSACCION                                                    >= :Pd_FechaInicio ' ||
                  '  AND IDS.FECHA_TRANSACCION                                                     < :Pd_FechaFin ' ||
                  '  AND IDS.ES_VENTA                                                              = :Lv_EsVenta ' ||
                  '  AND IDS.TIPO_ORDEN                                                            = :Lv_TipoOrden ' ||
                  '  AND IDS.ESTADO                                                                NOT IN ( ' ||
                  '    SELECT APD.DESCRIPCION ' ||
                  '    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '    JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '    ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  '    WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                  '    AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                  '    AND APD.VALOR2      = :Lv_EstadosServicios ' ||
                  '    AND APD.EMPRESA_COD = ( ' ||
                  '      SELECT COD_EMPRESA ' ||
                  '      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  '      WHERE ESTADO = :Lv_EstadoActivo ' ||
                  '      AND PREFIJO  = :Pv_PrefijoEmpresa ) ' || '  ) ';
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Query := Lv_Query || ' ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.GRUPO = :Pv_Grupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      Lv_Query := Lv_Query || 'GROUP BY AP.DESCRIPCION_PRODUCTO ' ||
                  ') TBL_PRODUCTO ' ||
                  'ORDER BY TBL_PRODUCTO.VALOR_VENTA DESC ' ||
                  ') TBL_PRODUCTO_ORDENADO ' ||
                  'WHERE ROWNUM <= NVL(:Pn_Rownum, 1) ';
      --
      --COSTO QUERY: 332
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pn_Rownum', Pn_Rownum);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_NombreParametro',
                               Lv_NombreParametro);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      Ln_NumeroRegistros  := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_ListadoProductos := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), ' || 'Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pr_ListadoProductos := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_LIST_PRODUCTO_DESTACADOS',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pr_ListadoProductos := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_LIST_PRODUCTO_DESTACADOS',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_LIST_PRODUCTO_DESTACADOS;
  --
  --
  PROCEDURE P_GET_INFO_DASHBOARD(Pv_PrefijoEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                 Pd_FechaInicio          IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                 Pd_FechaFin             IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                 Pv_Categoria            IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                 Pv_Grupo                IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                 Pv_Subgrupo             IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                 Pv_TipoPersonal         IN VARCHAR2,
                                 Pv_IdPersonaEmpresaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                 Pr_InformacionDashboard OUT SYS_REFCURSOR) IS
    --
    Lv_Query CLOB;
    Le_Exception EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Lv_TipoOrdenes      VARCHAR2(30);
    Ln_IdCursor         NUMBER;
    Ln_NumeroRegistros  NUMBER;
    Lv_OrderBy          VARCHAR2(1000);
    Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_EstadosServicios DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso          DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta          DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden        DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_Query := 'SELECT INITCAP(TRIM(TO_CHAR(:Pd_FechaInicio, ''day'', ''nls_date_language=spanish''))) AS DIA_SEMANA, ' ||
                  '       TRIM(TO_CHAR(:Pd_FechaInicio, ''dd'', ''nls_date_language=spanish'')) AS DIA_MES, ' ||
                  '       INITCAP(TRIM(TO_CHAR(:Pd_FechaInicio, ''month'', ''nls_date_language=spanish''))) AS MES, ' ||
                  '       TRIM(TO_CHAR(:Pd_FechaInicio, ''yyyy'', ''nls_date_language=spanish'')) AS ANIO, ' ||
                  '       TRIM(TO_CHAR(:Pd_FechaInicio, ''Q'', ''nls_date_language=spanish'')) AS TRIMESTRE, ' ||
                  '       CASE ' ||
                  '         WHEN TRIM(TO_CHAR(:Pd_FechaInicio, ''Q'', ''nls_date_language=spanish'')) = ''1'' THEN ' ||
                  '           ''ENERO - MARZO''' ||
                  '         WHEN TRIM(TO_CHAR(:Pd_FechaInicio, ''Q'', ''nls_date_language=spanish'')) = ''2'' THEN ' ||
                  '           ''ABRIL - JUNIO''' ||
                  '         WHEN TRIM(TO_CHAR(:Pd_FechaInicio, ''Q'', ''nls_date_language=spanish'')) = ''3'' THEN ' ||
                  '           ''JULIO - SEPTIEMBRE''' || '         ELSE ' ||
                  '           ''OCTUBRE - DICIEMBRE''' ||
                  '       END AS MESES_TRIMESTRE, ' || '       INITCAP(( ' ||
                  '         SELECT APD.VALOR2 ' ||
                  '         FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '         JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '         ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                  '         WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  '         AND APC.PROCESO = :Lv_Proceso ' ||
                  '         AND APC.MODULO = :Lv_Modulo ' ||
                  '         AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                  '         AND APD.DESCRIPCION = IDS.CATEGORIA ' ||
                  '         AND APD.EMPRESA_COD = ( ' ||
                  '           SELECT COD_EMPRESA ' ||
                  '           FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                  '           WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                  '           AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' ||
                  '         ) ' || '       ) ) AS MEDICION_CATEGORIA, ' ||
                  'concat(AP.LINEA_NEGOCIO, '' (''|| '||
                  'INITCAP(( ' ||
                  '         SELECT APD.VALOR2 ' ||
                  '         FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '         JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '         ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                  '         WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  '         AND APC.PROCESO = :Lv_Proceso ' ||
                  '         AND APC.MODULO = :Lv_Modulo ' ||
                  '         AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                  '         AND APD.DESCRIPCION = IDS.CATEGORIA ' ||
                  '         AND APD.EMPRESA_COD = ( ' ||
                  '           SELECT COD_EMPRESA ' ||
                  '           FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                  '           WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                  '           AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' ||
                  '         ) ' || '       ) ) ' ||
                  
                  ' ||'')'') AS DESCRIPCION_CARACTERISTICA';
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL OR TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ', concat(IDS.GRUPO, '' (''|| '||
                  'INITCAP(( ' ||
                  '         SELECT APD.VALOR2 ' ||
                  '         FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '         JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '         ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                  '         WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.ESTADO = :Lv_EstadoActivo ' ||
                  '         AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  '         AND APC.PROCESO = :Lv_Proceso ' ||
                  '         AND APC.MODULO = :Lv_Modulo ' ||
                  '         AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                  '         AND APD.DESCRIPCION = IDS.CATEGORIA ' ||
                  '         AND APD.EMPRESA_COD = ( ' ||
                  '           SELECT COD_EMPRESA ' ||
                  '           FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                  '           WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                  '           AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' ||
                  '         ) ' || '       ) ) ' ||                  
                  ' ||'')'') AS GRUPO';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL OR TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || ', IDS.SUBGRUPO ';
        --
      END IF;
      --
      --
      Lv_Query := Lv_Query ||
                  ', COUNT(IDS.SERVICIO_ID) AS ORDENES_PARCIALES, ' ||
                  'SUM( ROUND( ( ( ( NVL(IDS.PRECIO_VENTA, 0) * NVL(IDS.CANTIDAD, 0) ) - NVL(IDS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                  '              ( NVL(IDS.PRECIO_INSTALACION, 0) / 12 ) ), 2) ) AS VENTA_PARCIALES ' ||
                  'FROM DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS ' ||
                  'JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                  'ON AP.ID_PRODUCTO = IDS.PRODUCTO_ID ' ||
                  'WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDS.PUNTO_ID, NULL)  = :Pv_PrefijoEmpresa ' ||
                  'AND IDS.FECHA_TRANSACCION                                                    >= :Pd_FechaInicio ' ||
                  'AND IDS.FECHA_TRANSACCION                                                     < :Pd_FechaFin ' ||
                  'AND IDS.ES_VENTA                                                              = :Lv_EsVenta ' ||
                  'AND IDS.TIPO_ORDEN                                                            = :Lv_TipoOrden ' ||
                  'AND IDS.ESTADO                                                                NOT IN ( ' ||
                  '  SELECT APD.DESCRIPCION ' ||
                  '  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  '  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  '  ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  '  WHERE APD.ESTADO    = :Lv_EstadoActivo ' ||
                  '  AND APC.ESTADO      = :Lv_EstadoActivo ' ||
                  '  AND APD.VALOR2      = :Lv_EstadosServicios ' ||
                  '  AND APD.EMPRESA_COD = (SELECT COD_EMPRESA ' ||
                  '  FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  '  WHERE ESTADO = :Lv_EstadoActivo ' ||
                  '  AND PREFIJO  = :Pv_PrefijoEmpresa) ) ';
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';        
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.GRUPO = :Pv_Grupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Query := Lv_Query ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Query := Lv_Query || ' ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      Lv_Query   := Lv_Query || 'GROUP BY IDS.CATEGORIA, AP.LINEA_NEGOCIO ';
      Lv_OrderBy := 'ORDER BY IDS.CATEGORIA, AP.LINEA_NEGOCIO ';            
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL OR TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Query   := Lv_Query || ', IDS.GRUPO ';
        Lv_OrderBy := Lv_OrderBy || ', IDS.GRUPO ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL OR TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query   := Lv_Query || ', IDS.SUBGRUPO ';
        Lv_OrderBy := Lv_OrderBy || ', IDS.SUBGRUPO ';
        --
      END IF;
      --
      --
      --COSTO QUERY: 335
      Lv_Query := Lv_Query || Lv_OrderBy;
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_NombreParametro',
                             Lv_NombreParametro);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_ValorCategorias',
                             Lv_ValorCategorias);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      Ln_NumeroRegistros      := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_InformacionDashboard := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), ' || 'Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pr_InformacionDashboard := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_INFO_DASHBOARD',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pr_InformacionDashboard := NULL;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_INFO_DASHBOARD',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_INFO_DASHBOARD;
  --
  --
  PROCEDURE P_GET_SUM_ORDENES_SERVICIO(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                       Pd_FechaInicio         IN VARCHAR2,
                                       Pd_FechaFin            IN VARCHAR2,
                                       Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                       Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                       Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                       Pv_TipoOrdenes         IN VARCHAR2,
                                       Pv_Frecuencia          IN VARCHAR2,
                                       Pv_TipoPersonal        IN VARCHAR2,
                                       Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                       Pv_OpcionSelect        IN VARCHAR2,
                                       Pv_EmailUsrSesion      IN VARCHAR2,
                                       Pv_CantidadOrdenes     OUT NUMBER,
                                       Pv_TotalVenta          OUT NUMBER,
                                       Pv_MensajeRespuesta    OUT VARCHAR2) IS
    --
    Ln_IdCursor        NUMBER;
    Ln_NumeroRegistros NUMBER;
    Lv_Query           CLOB;
    Lv_WhereAdicional  VARCHAR2(100);
    Le_Exception EXCEPTION;
    Lv_MensajeError       VARCHAR2(4000);
    Ln_Resultado          NUMBER;
    Lc_OrdenesVendidas    SYS_REFCURSOR;
    Lr_OrdenesVendidas    DB_COMERCIAL.CMKG_TYPES.Lr_DetalladoServicios;
    Lv_TipoOrdenes        VARCHAR2(50);
    Lv_FrecuenciaProducto NUMBER;
    Lv_CamposAdicionales  VARCHAR2(500);
    Lv_RegistroAdicional  VARCHAR2(1000);
    Lv_Select             VARCHAR2(4000) := 'SELECT ';
    Lv_From               VARCHAR2(4000) := 'FROM ';
    Lv_Where              VARCHAR2(4000) := 'WHERE ';
    Lv_GroupBy            VARCHAR2(4000) := '';
    Lv_EstadoActivo       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_EstadoPendiente    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Pendiente';
    Lv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_SolicitudDescuento DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'SOLICITUDES DE DESCUENTO';
    Lv_EstadosServicios   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso            DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo             DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta            DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden          DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    Lv_Directorio         VARCHAR2(50) := 'DIR_REPGERENCIA';
    Lv_NombreArchivo      VARCHAR2(100) := 'DetalladoVentas_' ||
                                           Pv_PrefijoEmpresa || '_' ||
                                           Pv_TipoOrdenes || '.csv';
    Lv_Delimitador        VARCHAR2(1) := ';';
    Lv_Gzip               VARCHAR2(100) := 'gzip /backup/repgerencia/' ||
                                           Lv_NombreArchivo;
    Lv_Remitente          VARCHAR2(20) := 'telcos@telconet.ec';
    Lv_Destinatario       VARCHAR2(100) := NVL(Pv_EmailUsrSesion,
                                               'notificaciones_telcos@telconet.ec') || ',';
    Lv_Asunto             VARCHAR2(300) := 'Notificacion DETALLADO DE ' ||
                                           Pv_TipoOrdenes;
    Lv_NombreArchivoZip   VARCHAR2(100) := Lv_NombreArchivo || '.gz';
    Lc_GetAliasPlantilla  DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Cuerpo             VARCHAR2(9999);
    Lfile_Archivo         utl_file.file_type;
    --
    Lv_Categoria1                DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 1';
    Lv_Categoria2                DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 2';
    Lv_Categoria3                DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 3';
    Lv_MotivoPadreRegularizacion DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_PADRE_CANCELACION%TYPE := 'Cancelacion por Regularizacion';
    --
    Ln_NumeroMesesRestantes NUMBER := 13 - TO_NUMBER(TO_CHAR(TO_DATE(Pd_FechaInicio,
                                                                     'DD-MM-YYYY'),
                                                             'MM'),
                                                     '99');
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_From := Lv_From || ' DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDAS ' ||
                 'JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                 'ON AP.ID_PRODUCTO = IDAS.PRODUCTO_ID ';
      --
      --
      Lv_Where := Lv_Where ||
                  ' DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDAS.PUNTO_ID, NULL) =  :Pv_PrefijoEmpresa ' ||
                  'AND IDAS.FECHA_TRANSACCION >= CAST(TO_DATE(:Pd_FechaInicio, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                  'AND IDAS.FECHA_TRANSACCION <  CAST(TO_DATE(:Pd_FechaFin, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                  'AND AP.EMPRESA_COD = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = :Lv_EstadoActivo ' ||
                  'AND PREFIJO  = :Pv_PrefijoEmpresa) ' ||
                  'AND IDAS.ES_VENTA = :Lv_EsVenta ' ||
                  'AND IDAS.TIPO_ORDEN = :Lv_TipoOrden ';
      --
      --
      IF Pv_OpcionSelect = 'DESCUENTO' THEN
        --
        Lv_Select := Lv_Select ||
                     ' COUNT(IDS.ID_DETALLE_SOLICITUD) AS CANTIDAD_SOLICITUDES, ' ||
                     ' SUM( ROUND( NVL(IDS.PRECIO_DESCUENTO, 0) , 2 ) ) AS TOTAL_DESCUENTOS ';
        --
        Lv_From := Lv_From ||
                   ' JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ' ||
                   ' ON IDS.SERVICIO_ID = IDAS.SERVICIO_ID ' ||
                   ' JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ' ||
                   ' ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID ';
        --
        Lv_Where := Lv_Where || ' AND ATS.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND IDS.ESTADO = :Lv_EstadoPendiente ' ||
                    ' AND ATS.DESCRIPCION_SOLICITUD IN ( ' ||
                    '   SELECT APD.DESCRIPCION ' ||
                    '   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    '   JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    '   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                    '   WHERE APD.ESTADO         = :Lv_EstadoActivo ' ||
                    '   AND APC.ESTADO           = :Lv_EstadoActivo ' ||
                    '   AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    '   AND APC.PROCESO          = :Lv_Proceso ' ||
                    '   AND APC.MODULO           = :Lv_Modulo ' ||
                    '   AND APD.VALOR1           = :Lv_SolicitudDescuento ' ||
                    '   AND APD.EMPRESA_COD      = ( ' ||
                    '     SELECT COD_EMPRESA ' ||
                    '     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                    '     WHERE ESTADO = :Lv_EstadoActivo ' ||
                    '     AND PREFIJO  = :Pv_PrefijoEmpresa ' || '   ) ' ||
                    ' ) ';
        --
      ELSIF Pv_OpcionSelect = 'DETALLE' THEN
        --
        Lv_Select := Lv_Select || ' IOG.NOMBRE_OFICINA, ' ||
                     ' IDAS.CATEGORIA, ' || ' IDAS.GRUPO, ' ||
                     ' IDAS.SUBGRUPO, ' || ' AP.DESCRIPCION_PRODUCTO, ' ||
                     ' NVL( IPE.RAZON_SOCIAL, CONCAT( IPE.NOMBRES, CONCAT('' '', IPE.APELLIDOS) ) ) AS CLIENTE, ' ||
                     ' IP.LOGIN, ' || ' IDAS.USR_VENDEDOR, ' ||
                     ' ISER.ID_SERVICIO, ' || ' IDAS.PRODUCTO_ID, ' ||
                     ' IDAS.ESTADO, ' ||
                     ' DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN( TRIM( REPLACE( REPLACE( REPLACE( TRIM( ' ||
                     ' ISER.DESCRIPCION_PRESENTA_FACTURA ), Chr(9), '' ''), Chr(10), '' ''), Chr(13), '' '') ) ) AS ' ||
                     ' DESCRIPCION_PRESENTA_FACTURA, ' ||
                     ' TO_CHAR(ISER.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_CREACION, ' ||
                     ' TO_CHAR( TO_DATE( DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_DASHBOARD_SERVICIO( MAX(IDAS.ID_DASHBOARD_SERVICIO), ' ||
                     ' ''FechaTransaccion''), ''YYYY-MM-DD HH24:MI:SS'' ), ''DD-MM-YYYY HH24:MI:SS'' ) AS FE_HISTORIAL, ' ||
                     ' NVL(IDAS.FRECUENCIA_PRODUCTO, 0) AS FRECUENCIA_PRODUCTO, ' ||
                     ' IDAS.ES_VENTA, ' || ' IDAS.MRC, ' ||
                     ' NVL(IDAS.PRECIO_VENTA, 0) AS PRECIO_VENTA, ' ||
                     ' NVL(IDAS.CANTIDAD, 0) AS CANTIDAD, ' ||
                     ' NVL(IDAS.DESCUENTO_UNITARIO, 0) AS DESCUENTO, ' ||
                     ' NVL(IDAS.PRECIO_INSTALACION, 0) AS PRECIO_INSTALACION, ' ||
                     ' ( NVL(IDAS.PRECIO_VENTA, 0) - NVL(IDAS.DESCUENTO_UNITARIO, 0) ) AS SUBTOTAL_CON_DESCUENTO, ' ||
                     ' ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) AS ' ||
                     ' SUBTOTAL, ' ||
                     ' IDAS.NRC AS VALOR_INSTALACION_MENSUAL, ' ||
                     ' ROUND( ( ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                     '          ( NVL(IDAS.PRECIO_INSTALACION, 0) ) ), 2 ) AS VALOR_TOTAL, ' ||
                     ' IDAS.ACCION, ';
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_Select := Lv_Select ||
                       ' IDAS.MOTIVO_CANCELACION, IDAS.MOTIVO_PADRE_CANCELACION ';
          --
        ELSE
          --
          Lv_Select := Lv_Select ||
                       ' '' '' AS MOTIVO_CANCELACION, '' '' AS MOTIVO_PADRE_CANCELACION ';
          --
        END IF;
        --
        --
        Lv_GroupBy := 'GROUP BY ISER.ID_SERVICIO, IOG.NOMBRE_OFICINA, IDAS.PRODUCTO_ID, IDAS.GRUPO, IDAS.SUBGRUPO, AP.DESCRIPCION_PRODUCTO, ' ||
                      ' IPE.RAZON_SOCIAL, IPE.NOMBRES, IPE.APELLIDOS, IP.LOGIN, IDAS.USR_VENDEDOR, IDAS.ESTADO, ' ||
                      ' ISER.DESCRIPCION_PRESENTA_FACTURA, ISER.FE_CREACION, IDAS.FRECUENCIA_PRODUCTO, IDAS.ES_VENTA, ' ||
                      ' IDAS.PRECIO_VENTA, IDAS.CANTIDAD, IDAS.DESCUENTO_UNITARIO, IDAS.PRECIO_INSTALACION, IDAS.CATEGORIA, IDAS.MRC, IDAS.NRC, ' ||
                      ' IDAS.DESCUENTO_TOTALIZADO, IDAS.ACCION ';
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_GroupBy := Lv_GroupBy ||
                        ', IDAS.MOTIVO_CANCELACION, IDAS.MOTIVO_PADRE_CANCELACION ';
          --
        END IF;
        --
        --
        Lv_From := Lv_From || ' JOIN DB_COMERCIAL.INFO_SERVICIO ISER ' ||
                   ' ON ISER.ID_SERVICIO = IDAS.SERVICIO_ID ' ||
                   ' JOIN DB_COMERCIAL.INFO_PUNTO IP ' ||
                   ' ON ISER.PUNTO_ID = IP.ID_PUNTO ' ||
                   ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ' ||
                   ' ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID ' ||
                   ' JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ' ||
                   ' ON IPER.OFICINA_ID = IOG.ID_OFICINA ' ||
                   ' JOIN DB_COMERCIAL.INFO_PERSONA IPE ' ||
                   ' ON IPE.ID_PERSONA = IPER.PERSONA_ID ';
        --
        --
      ELSE
        --
        Lv_Select := Lv_Select ||
                     ' COUNT(IDAS.SERVICIO_ID) AS CANTIDAD_ORDENES, ' ||
                     ' SUM( ROUND( ( ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                     '               ( NVL(IDAS.PRECIO_INSTALACION, 0)  ) ), 2 ) ) AS TOTAL_VENTA ';
        --
      END IF;
      --
      --
      Lv_Where := Lv_Where || 'AND IDAS.ESTADO ';
      --
      --
      IF TRIM(Pv_TipoOrdenes) = 'VENTAS_ACTIVAS' THEN
        --
        Lv_Where       := Lv_Where || ' NOT IN ';
        Lv_TipoOrdenes := NULL;
        --
      ELSE
        --
        Lv_Where       := Lv_Where || ' IN ';
        Lv_TipoOrdenes := Pv_TipoOrdenes;
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'ORDENES_PENDIENTES' OR
           TRIM(Pv_TipoOrdenes) = 'ORDENES_ACTIVAS' THEN
          --
          Lv_EstadosServicios := 'ESTADO_SERVICIO_ESPECIAL';
          --
        END IF;
        --
        --
      END IF;
      --
      --
      Lv_Where := Lv_Where || ' ( SELECT APD.DESCRIPCION ' ||
                  'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  'JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  'ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  'WHERE APD.ESTADO         = :Lv_EstadoActivo ' ||
                  'AND APC.ESTADO           = :Lv_EstadoActivo ' ||
                  'AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  'AND APC.PROCESO          = :Lv_Proceso ' ||
                  'AND APC.MODULO           = :Lv_Modulo ' ||
                  'AND APD.VALOR2           = :Lv_EstadosServicios ' ||
                  'AND APD.VALOR1           = NVL(:Lv_TipoOrdenes, APD.VALOR1) ' ||
                  'AND APD.EMPRESA_COD      = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = :Lv_EstadoActivo ' ||
                  'AND PREFIJO  = :Pv_PrefijoEmpresa) ) ';
      --
      --
      IF Pv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        Lv_Where := Lv_Where ||
                    ' AND IDAS.MOTIVO_PADRE_CANCELACION = :Lv_MotivoPadreRegularizacion ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Frecuencia) IS NOT NULL AND TRIM(Pv_Frecuencia) = 'UNICA' THEN
        --
        Lv_FrecuenciaProducto := 0;
        Lv_Where              := Lv_Where ||
                                 'AND ( IDAS.FRECUENCIA_PRODUCTO = :Lv_FrecuenciaProducto OR IDAS.FRECUENCIA_PRODUCTO IS NULL ) ';
        --
      ELSIF TRIM(Pv_Frecuencia) IS NOT NULL AND
            (TRIM(Pv_Frecuencia) = 'MENSUAL' OR
             TRIM(Pv_Frecuencia) = 'NO_MENSUAL') THEN
        --
        Lv_FrecuenciaProducto := 1;
        --
        --
        IF TRIM(Pv_Frecuencia) = 'MENSUAL' THEN
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO = :Lv_FrecuenciaProducto ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO > :Lv_FrecuenciaProducto ';
          --
        END IF;
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.GRUPO = :Pv_Grupo ';
        --
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Where := Lv_Where || ' ) ';
        --
      END IF;
      --
      --
      -- COSTO QUERY: 332
      Lv_Query := Lv_Select || Lv_From || Lv_Where || Lv_GroupBy;
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_NombreParametro',
                             Lv_NombreParametro);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrdenes', Lv_TipoOrdenes);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      --
      --
      IF Pv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_MotivoPadreRegularizacion',
                               Lv_MotivoPadreRegularizacion);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Frecuencia) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_FrecuenciaProducto',
                               Lv_FrecuenciaProducto);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      IF Pv_OpcionSelect = 'DESCUENTO' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_EstadoPendiente',
                               Lv_EstadoPendiente);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_SolicitudDescuento',
                               Lv_SolicitudDescuento);
        --
      END IF;
      --
      --
      IF Pv_OpcionSelect = 'DETALLE' THEN
        --
        Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DFC');
        Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
        Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,
                                               Lv_NombreArchivo,
                                               'w',
                                               3000);
        --
        Lv_CamposAdicionales := NULL;
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_CamposAdicionales := 'MOTIVO PADRE CANCELACION' ||
                                  Lv_Delimitador || 'MOTIVO CANCELACION' ||
                                  Lv_Delimitador;
          --
        END IF;
        --
        --
        utl_file.put_line(Lfile_Archivo,
                          'OFICINA' || Lv_Delimitador || 'CLIENTE' ||
                          Lv_Delimitador || 'LOGIN' || Lv_Delimitador ||
                          'VENDEDOR' || Lv_Delimitador || 'ID_PRODUCTO' ||
                          Lv_Delimitador || 'DESCRIPCION PRODUCTO' ||
                          Lv_Delimitador || 'CATEGORIA' || Lv_Delimitador ||
                          'GRUPO' || Lv_Delimitador || 'SUBGRUPO' ||
                          Lv_Delimitador || 'ID SERVICIO' || Lv_Delimitador ||
                          'DESCRIPCION SERVICIO' || Lv_Delimitador ||
                          'FRECUENCIA PRODUCTO' || Lv_Delimitador ||
                          'ES VENTA' || Lv_Delimitador || 'ESTADO' ||
                          Lv_Delimitador || 'ACCION' || Lv_Delimitador ||
                          'FECHA CREACION' || Lv_Delimitador ||
                          'FECHA ACTUALIZACION' || Lv_Delimitador ||
                          'VALOR MRC' || Lv_Delimitador || 'PRECIO VENTA' ||
                          Lv_Delimitador || 'DESCUENTO UNITARIO' ||
                          Lv_Delimitador || 'SUBTOTAL CON DESCUENTO' ||
                          Lv_Delimitador || 'CANTIDAD' || Lv_Delimitador ||
                          'SUBTOTAL' || Lv_Delimitador ||
                          'VALOR INSTALACION' || Lv_Delimitador ||
                          'V. INSTALACION (NRC)' || Lv_Delimitador ||
                          'VALOR TOTAL (SUBTOTAL + NRC)' || Lv_Delimitador ||
                          Lv_CamposAdicionales);
        --
        Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
        Lc_OrdenesVendidas := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
        --
        LOOP
          --
          FETCH Lc_OrdenesVendidas
            INTO Lr_OrdenesVendidas;
          EXIT WHEN Lc_OrdenesVendidas%NOTFOUND;
          --
          --
          Lv_RegistroAdicional := NULL;
          --
          IF TRIM(Pv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
            --
            Lv_RegistroAdicional := Lr_OrdenesVendidas.MOTIVO_PADRE_CANCELACION ||
                                    Lv_Delimitador ||
                                    Lr_OrdenesVendidas.MOTIVO_CANCELACION ||
                                    Lv_Delimitador;
            --
          END IF;
          --
          --
          utl_file.put_line(Lfile_Archivo,
                            Lr_OrdenesVendidas.NOMBRE_OFICINA ||
                            Lv_Delimitador || Lr_OrdenesVendidas.CLIENTE ||
                            Lv_Delimitador || Lr_OrdenesVendidas.LOGIN ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.USR_VENDEDOR ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.PRODUCTO_ID ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.DESCRIPCION_PRODUCTO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.CATEGORIA ||
                            Lv_Delimitador || Lr_OrdenesVendidas.GRUPO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.SUBGRUPO ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.ID_SERVICIO ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.DESCRIPCION_PRESENTA_FACTURA ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.FRECUENCIA_PRODUCTO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.ES_VENTA ||
                            Lv_Delimitador || Lr_OrdenesVendidas.ESTADO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.ACCION ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.FE_CREACION ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.FE_HISTORIAL ||
                            Lv_Delimitador || Lr_OrdenesVendidas.MRC ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.PRECIO_VENTA ||
                            Lv_Delimitador || Lr_OrdenesVendidas.DESCUENTO ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.SUBTOTAL_CON_DESCUENTO ||
                            Lv_Delimitador || Lr_OrdenesVendidas.CANTIDAD ||
                            Lv_Delimitador || Lr_OrdenesVendidas.SUBTOTAL ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.PRECIO_INSTALACION ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.VALOR_INSTALACION_MENSUAL ||
                            Lv_Delimitador ||
                            Lr_OrdenesVendidas.VALOR_TOTAL ||
                            Lv_Delimitador || Lv_RegistroAdicional);
          --
        END LOOP;
        --
        UTL_FILE.fclose(Lfile_Archivo);
        --
        DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lv_Gzip));
        --
        DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lv_Remitente,
                                                  Lv_Destinatario,
                                                  Lv_Asunto,
                                                  Lv_Cuerpo,
                                                  Lv_Directorio,
                                                  Lv_NombreArchivoZip);
        --
        UTL_FILE.FREMOVE(Lv_Directorio, Lv_NombreArchivoZip);
        --
        Pv_MensajeRespuesta := 'Reporte generado y enviado al mail exitosamente';
        --
      ELSE
        --
        Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
        Lc_OrdenesVendidas := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
        --
        FETCH Lc_OrdenesVendidas
          INTO Pv_CantidadOrdenes, Pv_TotalVenta;
        --
        CLOSE Lc_OrdenesVendidas;
        --
        --
        Pv_CantidadOrdenes  := NVL(Pv_CantidadOrdenes, 0);
        Pv_TotalVenta       := NVL(Pv_TotalVenta, 0);
        Pv_MensajeRespuesta := 'Proceso OK';
        --
      END IF;
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), TipoOrdenes( ' || Pv_TipoOrdenes ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pv_CantidadOrdenes  := 0;
      Pv_TotalVenta       := 0;
      Pv_MensajeRespuesta := Lv_MensajeError;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SUM_ORDENES_SERVICIO',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pv_CantidadOrdenes  := 0;
      Pv_TotalVenta       := 0;
      Pv_MensajeRespuesta := 'Error al consultar las ordenes de servicio';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SUM_ORDENES_SERVICIO',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_SUM_ORDENES_SERVICIO;
  --
  --

    FUNCTION F_ES_PUNTO_ADICIONAL (Pn_PuntoId    IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2
    IS

        --Cursor que cuenta el total de puntos de la persona empresa rol seg煤n los estados parametrizados.
        --Verifica puntos por cualquier estado
        --Costo query 10
        CURSOR C_CuentaPuntos (Cn_IdPunto      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
            SELECT
                COUNT(*) AS TOTAL, PTO_B.PERSONA_EMPRESA_ROL_ID
            FROM
                DB_COMERCIAL.INFO_PUNTO PTO_A,
                DB_COMERCIAL.INFO_PUNTO PTO_B
            WHERE
                PTO_A.ID_PUNTO = Cn_IdPunto
                AND PTO_A.PERSONA_EMPRESA_ROL_ID = PTO_B.PERSONA_EMPRESA_ROL_ID
                AND PTO_B.ID_PUNTO <> PTO_A.ID_PUNTO
            GROUP BY PTO_B.PERSONA_EMPRESA_ROL_ID;

        Ln_TotalPuntos      NUMBER := 0;
        Lv_PrefijoEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
        Lv_EmpresaCod       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
        Ln_PersonaEmpRolId  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE;
        Lv_EsPuntoAdicional VARCHAR2(1) := 'N';
    BEGIN

        Lv_PrefijoEmpresa := DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(Pn_PuntoId, NULL);
        Lv_EmpresaCod     := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP(Lv_PrefijoEmpresa);

        OPEN  C_CuentaPuntos(Cn_IdPunto      => Pn_PuntoId);
        FETCH C_CuentaPuntos INTO Ln_TotalPuntos, Ln_PersonaEmpRolId;
        CLOSE C_CuentaPuntos;

        --Si tiene m谩s de un punto ligado a la persona empresa rol, se verifica que ya sea "Cliente" para determinar que es un "PUNTO ADICIONAL"
        IF Ln_TotalPuntos > 0 AND
           DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DESCRIPCION_ROL(Pn_PersonaEmpRolId => Ln_PersonaEmpRolId) = 'Cliente' THEN
                Lv_EsPuntoAdicional := 'S';
        END IF;

        RETURN Lv_EsPuntoAdicional;
    EXCEPTION
        WHEN OTHERS THEN
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Facturas de instalaci贸n',
                                                        'COMEK_TRANSACTION.F_ES_PUNTO_ADICIONAL',
                                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                        ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RETURN 'N';
    END F_ES_PUNTO_ADICIONAL;

    FUNCTION F_APLICA_FACT_INST_ORIGEN_PTO (Pv_EmpresaCod IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                            Pn_PuntoId    IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2
    IS
        CURSOR C_GetEsOrigenFacturable (Cv_EmpresaCod        DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Cn_PuntoId           DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                        Cv_EstadoActivo      VARCHAR2 DEFAULT 'Activo',
                                        Cv_NombreParametro   VARCHAR2 DEFAULT 'COMBO_TIPO_ORIGEN_TECNOLOGIA_PUNTO',
                                        Cv_DescripcionCaract VARCHAR2 DEFAULT 'TIPO_ORIGEN_TECNOLOGIA')
        IS
            SELECT VALOR3
              FROM DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC,
                   DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                   DB_COMERCIAL.ADMI_CARACTERISTICA AC2,
                   DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                   DB_GENERAL.ADMI_PARAMETRO_DET DET
             WHERE IPC.PUNTO_ID = Cn_PuntoId
               AND IPC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
               AND IPC.ESTADO = Cv_EstadoActivo
               AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
               AND AC.ESTADO = Cv_EstadoActivo
               AND TO_CHAR(IPC.VALOR) = TO_CHAR(AC2.ID_CARACTERISTICA)
               AND AC2.DESCRIPCION_CARACTERISTICA = TO_CHAR(DET.VALOR2)
               AND DET.ESTADO = Cv_EstadoActivo
               AND DET.EMPRESA_COD = Cv_EmpresaCod
               AND DET.PARAMETRO_ID = CAB.ID_PARAMETRO
               AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
               AND CAB.ESTADO = Cv_EstadoActivo;

        Lv_EsFacturable VARCHAR2(1);
    BEGIN
        Lv_EsFacturable := DB_GENERAL.GNRLPCK_UTIL.F_EMPRESA_APLICA_PROCESO('TIPO_ORIGEN_TECNOLOGIA_PUNTO', Pv_EmpresaCod);
        IF Lv_EsFacturable = 'N' THEN
            RETURN Lv_EsFacturable;
        END IF;

        Lv_EsFacturable := NULL;
        OPEN  C_GetEsOrigenFacturable (Cv_EmpresaCod => Pv_EmpresaCod,
                                       Cn_PuntoId    => Pn_PuntoId);
        FETCH C_GetEsOrigenFacturable INTO Lv_EsFacturable;
        CLOSE C_GetEsOrigenFacturable;

        Lv_EsFacturable := NVL (Lv_EsFacturable, 'S');
        RETURN Lv_EsFacturable;
    EXCEPTION
        WHEN OTHERS THEN
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Facturas de instalaci贸n',
                                                        'COMEK_TRANSACTION.F_APLICA_FACT_INST_ORIGEN_PTO',
                                                        'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                        ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RETURN 'S';
    END F_APLICA_FACT_INST_ORIGEN_PTO;

    FUNCTION F_GET_DESCRIPCION_ROL (Pn_PersonaEmpRolId DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    RETURN DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE IS
        CURSOR C_GetDescripcionRol (Cn_PersonaEmpRolId DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
            SELECT AR.DESCRIPCION_ROL
              FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
              JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
              JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
             WHERE IPER.ID_PERSONA_ROL = Cn_PersonaEmpRolId;
        Lv_DescripcionRol DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE := NULL;
    BEGIN
        OPEN  C_GetDescripcionRol(Cn_PersonaEmpRolId => Pn_PersonaEmpRolId);
        FETCH C_GetDescripcionRol INTO Lv_DescripcionRol;
        CLOSE C_GetDescripcionRol;

        RETURN Lv_DescripcionRol;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END F_GET_DESCRIPCION_ROL;

    FUNCTION F_GET_INFO_SOL_INSTALACION (Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                         Pv_CaractContrato       IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                         Pv_NombreMotivo         IN  DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
                                         Pv_UltimaMilla          IN  DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE DEFAULT NULL)
    RETURN DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion
    IS
       --Costo: 4
       CURSOR C_GetValorInstalacion (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                      Cv_EstadoActivo    VARCHAR2,
                                      Cv_UltimaMilla     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                      Cv_FormaPago       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                      Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE) 
        IS
        SELECT TO_NUMBER(apd.VALOR5)
        FROM DB_GENERAL.ADMI_PARAMETRO_DET apd
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB apc
        ON apd.PARAMETRO_ID = apc.ID_PARAMETRO
        WHERE apc.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND apc.ESTADO = Cv_EstadoActivo
        AND apd.ESTADO = Cv_EstadoActivo
        AND apd.VALOR1 = Cv_UltimaMilla
        AND apd.VALOR2 = Cv_FormaPago
        AND APD.EMPRESA_COD = Cv_EmpresaCod;

        CURSOR C_GetDiasVigencia(Cv_EstadoActivo             DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE, 
                                 Cv_ParametroVigenciaFactura DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_TipoSolicitud            DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                 Cv_EmpresaCod               DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
        IS
          SELECT VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_DET
          WHERE ESTADO     = Cv_EstadoActivo
          AND PARAMETRO_ID = ( SELECT ID_PARAMETRO
                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                                WHERE ESTADO           = Cv_EstadoActivo
                                  AND NOMBRE_PARAMETRO = Cv_ParametroVigenciaFactura)
          AND VALOR2      = Cv_TipoSolicitud
          AND EMPRESA_COD = Cv_EmpresaCod;

        CURSOR C_GetCaracteristica(Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                   Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE )
        IS
          SELECT ID_CARACTERISTICA
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA
          WHERE ESTADO                   = Cv_EstadoActivo
          AND DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract;

        CURSOR C_GetSolicitud (Cv_DescripcionSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                               Cv_EstadoActivo         DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ESTADO%TYPE)
        IS
            SELECT ID_TIPO_SOLICITUD
              FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
             WHERE DESCRIPCION_SOLICITUD = Cv_DescripcionSolicitud
               AND ESTADO = Cv_EstadoActivo;

        CURSOR C_GetMotivo (Cv_NombreMotivo DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
                            Cv_EstadoActivo DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE)
        IS
            SELECT ID_MOTIVO
              FROM DB_GENERAL.ADMI_MOTIVO
             WHERE NOMBRE_MOTIVO = Cv_NombreMotivo
               AND ESTADO = Cv_EstadoActivo;
       
        Lv_ParamVigenciaFactura DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DIAS_VIGENCIA_FACTURA';
        Lv_CaracFechaVigencia   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FECHA_VIGENCIA';
        Lv_EstadoActivo         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
        Ln_ValorInstalacion     NUMBER := 0;
        Ln_NumeroDiasVigencia   NUMBER := 0;
        Ln_CaractIdContratoTipo NUMBER := 0;
        Ln_FechaVigenciaCarac   NUMBER := 0;
        Ln_IdTipoSolicitud      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE;
        Ln_IdMotivo             DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE;
        Lv_FechaVigenciaFact    VARCHAR2(25) := '';
        Lr_SolicitudInstalacion DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion := NULL;
        Le_Exception            EXCEPTION;
    BEGIN

        IF Pv_EmpresaCod IS NULL OR Pv_DescripcionSolicitud IS NULL OR Pv_CaractContrato IS NULL OR Pv_NombreMotivo IS NULL THEN
            RAISE Le_Exception;
        END IF;       
        --Se obtiene el valor base a cobrar de instalaci贸n por FO, CO y forma de pago Efectivo
        OPEN  C_GetValorInstalacion(Cv_NombreParametro => 'PORCENTAJE_DESCUENTO_INSTALACION',
                                    Cv_EstadoActivo    => 'Activo',
                                    Cv_UltimaMilla     => Pv_UltimaMilla,
                                    Cv_FormaPago       => 'EFECTIVO',
                                    Cv_EmpresaCod      => Pv_EmpresaCod);
        FETCH C_GetValorInstalacion INTO Ln_ValorInstalacion;
        CLOSE C_GetValorInstalacion;
        IF Ln_ValorInstalacion IS NULL THEN
            RAISE Le_Exception;
        END IF;
        --
        --Se obtiene el n煤mero de d铆as de vigencia para el c谩lculo.
        IF C_GetDiasVigencia%ISOPEN THEN
            CLOSE C_GetDiasVigencia;
        END IF;
        OPEN  C_GetDiasVigencia( Lv_EstadoActivo, Lv_ParamVigenciaFactura, Pv_DescripcionSolicitud,Pv_EmpresaCod);
        FETCH C_GetDiasVigencia INTO Ln_NumeroDiasVigencia;
        CLOSE C_GetDiasVigencia;
        --Se calcula el n煤mero de d铆as de vigencia.
        Lv_FechaVigenciaFact := TO_CHAR((SYSDATE + NVL(Ln_NumeroDiasVigencia, 0)), 'DD-MM-YYYY');

        IF Lv_FechaVigenciaFact IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene la caracter铆stica dependiendo del tipo de contrato
        IF C_GetCaracteristica%ISOPEN THEN
            CLOSE C_GetCaracteristica;
        END IF;
        OPEN  C_GetCaracteristica( Lv_EstadoActivo, Pv_CaractContrato );
        FETCH C_GetCaracteristica INTO Ln_CaractIdContratoTipo;
        CLOSE C_GetCaracteristica;

        IF Ln_CaractIdContratoTipo IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene la caracter铆stica de la fecha de vigencia.
        OPEN C_GetCaracteristica( Lv_EstadoActivo, Lv_CaracFechaVigencia );
        FETCH C_GetCaracteristica INTO Ln_FechaVigenciaCarac;
        CLOSE C_GetCaracteristica;

        IF Ln_FechaVigenciaCarac IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene la solicitud
        IF C_GetSolicitud%ISOPEN THEN
            CLOSE C_GetSolicitud;
        END IF;
        OPEN  C_GetSolicitud (Pv_DescripcionSolicitud, Lv_EstadoActivo);
        FETCH C_GetSolicitud INTO Ln_IdTipoSolicitud;
        CLOSE C_GetSolicitud;

        IF Ln_IdTipoSolicitud IS NULL THEN
            RAISE Le_Exception;
        END IF;

        --Se obtiene el motivo.
        IF C_GetMotivo%ISOPEN THEN
            CLOSE C_GetMotivo;
        END IF;
        OPEN  C_GetMotivo (Pv_NombreMotivo, Lv_EstadoActivo);
        FETCH C_GetMotivo INTO Ln_IdMotivo;
        CLOSE C_GetMotivo;

        IF Ln_IdMotivo IS NULL THEN
            RAISE Le_Exception;
        END IF;

        Lr_SolicitudInstalacion.ID_TIPO_SOLICITUD         := Ln_IdTipoSolicitud;
        Lr_SolicitudInstalacion.DESCRIPCION_SOLICITUD     := Pv_DescripcionSolicitud;
        Lr_SolicitudInstalacion.DESC_CARACT_CONTRATO      := Pv_CaractContrato;
        Lr_SolicitudInstalacion.ID_CARACT_TIPO_CONTRATO   := Ln_CaractIdContratoTipo;
        Lr_SolicitudInstalacion.ID_CARACT_FE_VIGENCIA     := Ln_FechaVigenciaCarac;
        Lr_SolicitudInstalacion.MOTIVO_ID                 := Ln_IdMotivo;
        Lr_SolicitudInstalacion.COD_EMPRESA               := Pv_EmpresaCod;
        Lr_SolicitudInstalacion.FECHA_VIGENCIA_FACT       := Lv_FechaVigenciaFact;
        Lr_SolicitudInstalacion.VALOR_INSTALACION         := Ln_ValorInstalacion;

        RETURN Lr_SolicitudInstalacion;
    EXCEPTION
        WHEN Le_Exception THEN
            RETURN NULL;
        WHEN OTHERS THEN
            RETURN NULL;
    END F_GET_INFO_SOL_INSTALACION;

  PROCEDURE P_GET_AGRU_ORDENES(Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                       Pd_FechaInicio         IN VARCHAR2,
                                       Pd_FechaFin            IN VARCHAR2,
                                       Pv_Categoria           IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                       Pv_Grupo               IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
                                       Pv_Subgrupo            IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
                                       Pv_TipoOrdenes         IN VARCHAR2,
                                       Pv_Frecuencia          IN VARCHAR2,
                                       Pv_TipoPersonal        IN VARCHAR2,
                                       Pv_IdPersonaEmpresaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                       Pv_OpcionSelect        IN VARCHAR2,
                                       Pv_MensajeRespuesta    OUT VARCHAR2,
                                       Pr_Informacion         OUT SYS_REFCURSOR) IS
    --
    Ln_IdCursor        NUMBER;
    Ln_NumeroRegistros NUMBER;
    Lv_Query           CLOB;
    Lv_WhereAdicional  VARCHAR2(100);
    Le_Exception EXCEPTION;
    Lv_MensajeError       VARCHAR2(4000);
    Ln_Resultado          NUMBER;
    Lc_OrdenesVendidas    SYS_REFCURSOR;
    Lr_OrdenesVendidas    DB_COMERCIAL.CMKG_TYPES.Lr_DetalladoServicios;
    Lv_TipoOrdenes        VARCHAR2(50);
    Lv_FrecuenciaProducto NUMBER;
    Lv_CamposAdicionales  VARCHAR2(500);
    Lv_RegistroAdicional  VARCHAR2(1000);
    Lv_Select             VARCHAR2(4000) := 'SELECT ';
    Lv_From               VARCHAR2(4000) := 'FROM ';
    Lv_Where              VARCHAR2(4000) := 'WHERE ';
    Lv_GroupBy            VARCHAR2(4000) := '';
    Lv_EstadoActivo       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
    Lv_EstadoPendiente    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Pendiente';
    Lv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'CATEGORIAS_PRODUCTOS';
    Lv_SolicitudDescuento DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE := 'SOLICITUDES DE DESCUENTO';
    Lv_EstadosServicios   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := 'ESTADO_SERVICIO';
    Lv_Proceso            DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo             DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE := 'COMERCIAL';
    Lv_EsVenta            DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE := 'S';
    Lv_TipoOrden          DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    --
    Lv_MotivoPadreRegularizacion DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_PADRE_CANCELACION%TYPE := 'Cancelacion por Regularizacion';
    --
    Ln_NumeroMesesRestantes NUMBER := 13 - TO_NUMBER(TO_CHAR(TO_DATE(Pd_FechaInicio,
                                                                     'DD-MM-YYYY'),
                                                             'MM'),
                                                     '99');
    --
  BEGIN
    --
    IF TRIM(Pv_PrefijoEmpresa) IS NOT NULL AND Pd_FechaInicio IS NOT NULL AND
       Pd_FechaFin IS NOT NULL THEN
      --
      Lv_From := Lv_From || ' DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDAS ' ||
                 'JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                 'ON AP.ID_PRODUCTO = IDAS.PRODUCTO_ID ';
      --
      --
      Lv_Where := Lv_Where ||
                  ' DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDAS.PUNTO_ID, NULL) =  :Pv_PrefijoEmpresa ' ||
                  'AND IDAS.FECHA_TRANSACCION >= CAST(TO_DATE(:Pd_FechaInicio, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                  'AND IDAS.FECHA_TRANSACCION <  CAST(TO_DATE(:Pd_FechaFin, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                  'AND AP.EMPRESA_COD = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = :Lv_EstadoActivo ' ||
                  'AND PREFIJO  = :Pv_PrefijoEmpresa) ' ||
                  'AND IDAS.ES_VENTA = :Lv_EsVenta ' ||
                  'AND IDAS.TIPO_ORDEN = :Lv_TipoOrden ';
      --
      --
      IF Pv_OpcionSelect = 'DESCUENTO' THEN
        --
        Lv_Select := Lv_Select ||
                     ' COUNT(IDS.ID_DETALLE_SOLICITUD) AS CANTIDAD_SOLICITUDES, ' ||
                     ' SUM( ROUND( NVL(IDS.PRECIO_DESCUENTO, 0) , 2 ) ) AS TOTAL_DESCUENTOS, '||
                     ' IDAS.USR_VENDEDOR ';
        --
        Lv_From := Lv_From ||
                   ' JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ' ||
                   ' ON IDS.SERVICIO_ID = IDAS.SERVICIO_ID ' ||
                   ' JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ' ||
                   ' ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID ';
        --
        Lv_Where := Lv_Where || ' AND ATS.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND IDS.ESTADO = :Lv_EstadoPendiente ' ||
                    ' AND ATS.DESCRIPCION_SOLICITUD IN ( ' ||
                    '   SELECT APD.DESCRIPCION ' ||
                    '   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    '   JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    '   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                    '   WHERE APD.ESTADO         = :Lv_EstadoActivo ' ||
                    '   AND APC.ESTADO           = :Lv_EstadoActivo ' ||
                    '   AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    '   AND APC.PROCESO          = :Lv_Proceso ' ||
                    '   AND APC.MODULO           = :Lv_Modulo ' ||
                    '   AND APD.VALOR1           = :Lv_SolicitudDescuento ' ||
                    '   AND APD.EMPRESA_COD      = ( ' ||
                    '     SELECT COD_EMPRESA ' ||
                    '     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                    '     WHERE ESTADO = :Lv_EstadoActivo ' ||
                    '     AND PREFIJO  = :Pv_PrefijoEmpresa ' || '   ) ' ||
                    ' ) ';
        Lv_GroupBy :=Lv_GroupBy || ' GROUP BY IDAS.USR_VENDEDOR ';
        --
      ELSE
        --
        Lv_Select := Lv_Select ||
                     ' COUNT(IDAS.SERVICIO_ID) AS CANTIDAD_ORDENES, ' ||
                     ' SUM( ROUND( ( ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                     '               ( NVL(IDAS.PRECIO_INSTALACION, 0) / 12 ) ), 2 ) ) AS TOTAL_VENTA , '||
                     ' IDAS.USR_VENDEDOR ';
        Lv_GroupBy :=Lv_GroupBy || ' GROUP BY IDAS.USR_VENDEDOR ';
        --
      END IF;
      --
      --
      Lv_Where := Lv_Where || 'AND IDAS.ESTADO ';
      --
      --
      IF TRIM(Pv_TipoOrdenes) = 'VENTAS_ACTIVAS' THEN
        --
        Lv_Where       := Lv_Where || ' NOT IN ';
        Lv_TipoOrdenes := NULL;
        --
      ELSE
        --
        Lv_Where       := Lv_Where || ' IN ';
        Lv_TipoOrdenes := Pv_TipoOrdenes;
        --
        --
        IF TRIM(Pv_TipoOrdenes) = 'ORDENES_PENDIENTES' OR
           TRIM(Pv_TipoOrdenes) = 'ORDENES_ACTIVAS' THEN
          --
          Lv_EstadosServicios := 'ESTADO_SERVICIO_ESPECIAL';
          --
        END IF;
        --
        --
      END IF;
      --
      --
      Lv_Where := Lv_Where || ' ( SELECT APD.DESCRIPCION ' ||
                  'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  'JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  'ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  'WHERE APD.ESTADO         = :Lv_EstadoActivo ' ||
                  'AND APC.ESTADO           = :Lv_EstadoActivo ' ||
                  'AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                  'AND APC.PROCESO          = :Lv_Proceso ' ||
                  'AND APC.MODULO           = :Lv_Modulo ' ||
                  'AND APD.VALOR2           = :Lv_EstadosServicios ' ||
                  'AND APD.VALOR1           = NVL(:Lv_TipoOrdenes, APD.VALOR1) ' ||
                  'AND APD.EMPRESA_COD      = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = :Lv_EstadoActivo ' ||
                  'AND PREFIJO  = :Pv_PrefijoEmpresa) ) ';
      --
      --
      IF Pv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        Lv_Where := Lv_Where ||
                    ' AND IDAS.MOTIVO_PADRE_CANCELACION = :Lv_MotivoPadreRegularizacion ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Frecuencia) IS NOT NULL AND TRIM(Pv_Frecuencia) = 'UNICA' THEN
        --
        Lv_FrecuenciaProducto := 0;
        Lv_Where              := Lv_Where ||
                                 'AND ( IDAS.FRECUENCIA_PRODUCTO = :Lv_FrecuenciaProducto OR IDAS.FRECUENCIA_PRODUCTO IS NULL ) ';
        --
      ELSIF TRIM(Pv_Frecuencia) IS NOT NULL AND
            (TRIM(Pv_Frecuencia) = 'MENSUAL' OR
             TRIM(Pv_Frecuencia) = 'NO_MENSUAL') THEN
        --
        Lv_FrecuenciaProducto := 1;
        --
        --
        IF TRIM(Pv_Frecuencia) = 'MENSUAL' THEN
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO = :Lv_FrecuenciaProducto ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO > :Lv_FrecuenciaProducto ';
          --
        END IF;
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND AP.LINEA_NEGOCIO = :Pv_Categoria ';
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.GRUPO = :Pv_Grupo ';
        --
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.SUBGRUPO = :Pv_Subgrupo ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.ESTADO = :Lv_EstadoActivo ' ||
                    ' AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro ' ||
                    ' AND APC.PROCESO = :Lv_Proceso ' ||
                    ' AND APC.MODULO = :Lv_Modulo ' ||
                    ' AND APD.VALOR1 = :Lv_ValorCategorias ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = :Lv_EstadoActivo ' ||
                    '   AND IEG.PREFIJO = :Pv_PrefijoEmpresa ' || ' ) ) ';
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Pv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.ID_PERSONA_ROL = :Pv_IdPersonaEmpresaRol ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = :Pv_IdPersonaEmpresaRol ';
          --
        END IF;
        --
        --
        Lv_Where := Lv_Where || ' ) ';
        --
      END IF;
      --
      --
      -- COSTO QUERY: 332      
      Lv_Query := Lv_Select || Lv_From || Lv_Where || Lv_GroupBy;
      --
      --
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      --
      DBMS_SQL.PARSE(Ln_IdCursor, Lv_Query, DBMS_SQL.NATIVE);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Pv_PrefijoEmpresa',
                             Pv_PrefijoEmpresa);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaInicio', Pd_FechaInicio);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pd_FechaFin', Pd_FechaFin);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadoActivo',
                             Lv_EstadoActivo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_NombreParametro',
                             Lv_NombreParametro);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Proceso', Lv_Proceso);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_Modulo', Lv_Modulo);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                             'Lv_EstadosServicios',
                             Lv_EstadosServicios);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrdenes', Lv_TipoOrdenes);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_EsVenta', Lv_EsVenta);
      DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Lv_TipoOrden', Lv_TipoOrden);
      --
      --
      IF Pv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_MotivoPadreRegularizacion',
                               Lv_MotivoPadreRegularizacion);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Frecuencia) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_FrecuenciaProducto',
                               Lv_FrecuenciaProducto);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Categoria', Pv_Categoria);
        --
      ELSIF TRIM(Pv_Grupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Grupo', Pv_Grupo);
        --
      ELSIF TRIM(Pv_Subgrupo) IS NOT NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, 'Pv_Subgrupo', Pv_Subgrupo);
        --
      END IF;
      --
      --
      IF TRIM(Pv_Categoria) IS NULL THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_ValorCategorias',
                               Lv_ValorCategorias);
        --
      END IF;
      --
      --
      IF TRIM(Pv_TipoPersonal) IS NOT NULL AND Pv_IdPersonaEmpresaRol > 0 THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Pv_IdPersonaEmpresaRol',
                               Pv_IdPersonaEmpresaRol);
        --
      END IF;
      --
      --
      IF Pv_OpcionSelect = 'DESCUENTO' THEN
        --
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_EstadoPendiente',
                               Lv_EstadoPendiente);
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor,
                               'Lv_SolicitudDescuento',
                               Lv_SolicitudDescuento);
        --
      END IF;
      --          
      Ln_NumeroRegistros := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Pr_Informacion := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);      
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Pv_PrefijoEmpresa || '), FeInicio( ' ||
                         Pd_FechaInicio || '), FeFin( ' || Pd_FechaFin ||
                         '), TipoOrdenes( ' || Pv_TipoOrdenes ||
                         '), Categoria(' || Pv_Categoria || '), Grupo(' ||
                         Pv_Grupo || '), Subgrupo(' || Pv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pv_MensajeRespuesta := Lv_MensajeError;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SUM_ORDENES_SERVICIO',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pv_MensajeRespuesta := 'Error al consultar las ordenes de servicio';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SUM_ORDENES_SERVICIO',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_AGRU_ORDENES;  
  --
  --
  /**
  * Documentacion para la funcion COMEF_GET_ADMI_CARACTERISTICA
  * la funcion COMEF_GET_ADMI_CARACTERISTICA obtiene un registro de la tabla ADMI_CARACTERISTICA
  *
  * @param  Fv_DescripcionCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE    Recibe la descripcion de la caracteristica
  * @return ADMI_CARACTERISTICA%ROWTYPE  Retorna el registro ADMI_CARACTERISTICA
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 17-09-2015
  */
  FUNCTION COMEF_GET_ADMI_CARACTERISTICA(Fv_DescripcionCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    RETURN ADMI_CARACTERISTICA%ROWTYPE IS
    --
    CURSOR C_GetCaracteristica(Cv_DescripcionCaracteristica ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    --
    IS
    --
      SELECT *
        FROM ADMI_CARACTERISTICA
       WHERE ESTADO = 'Activo'
         AND DESCRIPCION_CARACTERISTICA =
             NVL(Cv_DescripcionCaracteristica, DESCRIPCION_CARACTERISTICA);
    --
    Lc_GetCaracteristica C_GetCaracteristica%ROWTYPE;
    --
  BEGIN
    --
    IF C_GetCaracteristica%ISOPEN THEN
      --
      CLOSE C_GetCaracteristica;
      --
    END IF;
    --
    OPEN C_GetCaracteristica(Fv_DescripcionCaracteristica);
    --
    FETCH C_GetCaracteristica
      INTO Lc_GetCaracteristica;
    --
    CLOSE C_GetCaracteristica;
    --
    RETURN Lc_GetCaracteristica;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('COMEF_GET_ADMI_CARACTERISTICA',
                                                  'COMEK_CONSULTAS.COMEF_GET_ADMI_CARACTERISTICA',
                                                  SQLERRM);
      --
  END COMEF_GET_ADMI_CARACTERISTICA;
  --
  --
  FUNCTION F_GET_FECHA_RENOVACION_PLAN(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN VARCHAR2 IS
    --
    --
    CURSOR C_FechaRenovacion IS
    --
    --
      SELECT iser.ID_SERVICIO,
             iser.PUNTO_ID,
             iser.FRECUENCIA_PRODUCTO,
             iser.MESES_RESTANTES,
             iser.TIPO_ORDEN,
             iper.PERSONA_EMPRESA_ROL_ID,
             ier.EMPRESA_COD,
             iper.ID_PERSONA_ROL
        FROM DB_COMERCIAL.INFO_SERVICIO iser
        JOIN DB_COMERCIAL.INFO_PUNTO ip
          ON ip.ID_PUNTO = iser.PUNTO_ID
        JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
          ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
          ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
       WHERE iser.ID_SERVICIO = Fn_IdServicio;
    --
    --
    --  
    Lv_FechaRenovacion        VARCHAR2(50) := '';
    Lv_FechaActivacion        VARCHAR2(50) := '';
    Lv_Seguir                 VARCHAR2(2) := 'S';
    Ln_CompararFechas         NUMBER := 0;
    Ln_ServicioOrigenT        NUMBER := 0;
    Ln_ProductoCaracteristica NUMBER := 0;
    Ln_ServicioOrigenTrasTmp  NUMBER := 0;
    Ln_IdInfoServicio         DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    Lr_InfoServicio           DB_COMERCIAL.INFO_SERVICIO%ROWTYPE;
    Ln_NumeroLazosPermitidos  NUMBER := 0;
    --
    --
  BEGIN
    --    
    --
    IF C_FechaRenovacion%ISOPEN THEN
      --
      --
      CLOSE C_FechaRenovacion;
      --
      --
    END IF;
    --
    --
    --
    FOR Le_FechaRenovacion IN C_FechaRenovacion LOOP
      --
      --
      Ln_NumeroLazosPermitidos := 0;
      --
      --
      --
      WHILE Lv_Seguir = 'S' LOOP
        --
        --
        IF Le_FechaRenovacion.TIPO_ORDEN = 'N' THEN
          --
          --
          Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                               'renovacionPlan',
                                                                               'Accion',
                                                                               NULL);
          --
          --
          --
          IF Lv_FechaActivacion IS NULL THEN
            --
            --
            Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                                 '%Se cambio de plan,%',
                                                                                 'Observacion',
                                                                                 NULL);
            --
            --
          END IF;
          --
          --
          --
          IF Lv_FechaActivacion IS NULL THEN
            --
            --
            Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                                 'Se confirmo el servicio',
                                                                                 'Observacion',
                                                                                 NULL);
            --
            --
          END IF;
          --
          --
        ELSIF Le_FechaRenovacion.TIPO_ORDEN = 'T' THEN
          --
          --
          Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                               'renovacionPlan',
                                                                               'Accion',
                                                                               NULL);
          --
          --
          --
          IF Lv_FechaActivacion IS NULL THEN
            --
            --
            Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Le_FechaRenovacion.ID_SERVICIO,
                                                                                 '%Se cambio de plan,%',
                                                                                 'Observacion',
                                                                                 NULL);
            --
            --
          END IF;
          --
          --
          --
          IF Lv_FechaActivacion IS NULL THEN
            --
            --
            SELECT NVL((SELECT apc.ID_PRODUCTO_CARACTERISITICA
                         FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA apc
                        WHERE apc.ESTADO = 'Activo'
                          AND apc.PRODUCTO_ID =
                              (SELECT ap.ID_PRODUCTO
                                 FROM DB_COMERCIAL.ADMI_PRODUCTO ap
                                WHERE ap.ESTADO = 'Activo'
                                  AND ap.DESCRIPCION_PRODUCTO =
                                      'INTERNET DEDICADO'
                                  AND ap.EMPRESA_COD =
                                      Le_FechaRenovacion.EMPRESA_COD)
                          AND apc.CARACTERISTICA_ID =
                              (SELECT ac.ID_CARACTERISTICA
                                 FROM DB_COMERCIAL.ADMI_CARACTERISTICA ac
                                WHERE ac.ESTADO = 'Activo'
                                  AND ac.DESCRIPCION_CARACTERISTICA =
                                      'TRASLADO')),
                       NULL)
              INTO Ln_ProductoCaracteristica
              FROM DUAL;
            --
            --
            --
            Ln_ServicioOrigenT := Le_FechaRenovacion.ID_SERVICIO;
            --
            --
            --
            WHILE Ln_ServicioOrigenT >= 0 AND Lv_Seguir = 'S' LOOP
              --
              --
              Ln_ServicioOrigenTrasTmp := Ln_ServicioOrigenT;
              --
              --
              --
              SELECT NVL((SELECT ispc.VALOR
                           FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ispc
                          WHERE ispc.SERVICIO_ID = Ln_ServicioOrigenT
                            AND ispc.PRODUCTO_CARACTERISITICA_ID =
                                Ln_ProductoCaracteristica),
                         -1)
                INTO Ln_ServicioOrigenT
                FROM DUAL;
              --
              --
              --
              IF Ln_ServicioOrigenT = -1 THEN
                --
                --
                Lv_Seguir          := 'N';
                Ln_ServicioOrigenT := Ln_ServicioOrigenTrasTmp;
                --
                --
              END IF;
              --
              --
              --
              IF Ln_ServicioOrigenT > 0 THEN
                --
                --
                Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Ln_ServicioOrigenT,
                                                                                     'renovacionPlan',
                                                                                     'Accion',
                                                                                     NULL);
                --
                --
                --
                IF Lv_FechaActivacion IS NULL THEN
                  --
                  --
                  Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Ln_ServicioOrigenT,
                                                                                       '%Se cambio de plan,%',
                                                                                       'Observacion',
                                                                                       NULL);
                  --
                  --
                END IF;
                --
                --
                --
                IF Lv_FechaActivacion IS NULL THEN
                  --
                  --
                  Lv_FechaActivacion := COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(Ln_ServicioOrigenT,
                                                                                       'Se confirmo el servicio',
                                                                                       'Observacion',
                                                                                       NULL);
                  --
                  --
                END IF;
                --
                --
                --
                IF Lv_FechaActivacion IS NOT NULL THEN
                  --
                  --
                  Ln_ServicioOrigenT := -1;
                  --
                  --
                END IF;
                --
                --
              END IF;
              --
            --
            END LOOP;
            --
            --
          END IF;
          --
          --
        END IF;
        --
        --
        --
        IF Lv_FechaActivacion IS NOT NULL THEN
          --
          --
          Lv_Seguir := 'N';
          --
          --
        END IF;
        --
        --
        --
        IF Lv_Seguir = 'S' THEN
          --
          --
          IF Le_FechaRenovacion.PERSONA_EMPRESA_ROL_ID IS NOT NULL THEN
            --    
            --
            SELECT NVL((SELECT iser.ID_SERVICIO
                         FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                         JOIN DB_COMERCIAL.INFO_PUNTO ip
                           ON ip.PERSONA_EMPRESA_ROL_ID =
                              iper.ID_PERSONA_ROL
                         JOIN DB_COMERCIAL.INFO_SERVICIO iser
                           ON iser.PUNTO_ID = ip.ID_PUNTO
                         JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc
                           ON ipc.ID_PLAN = iser.PLAN_ID
                        WHERE ipc.ID_PLAN IN
                              (SELECT ipc2.ID_PLAN
                                 FROM DB_COMERCIAL.INFO_PLAN_CAB ipc2
                                 JOIN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA ipcar
                                   ON ipc2.ID_PLAN = ipcar.PLAN_ID
                                 JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac2
                                   ON ac2.ID_CARACTERISTICA =
                                      ipcar.CARACTERISTICA_ID
                                WHERE ipcar.VALOR = 'SI'
                                  AND ipcar.ESTADO = 'Activo'
                                  AND ac2.DESCRIPCION_CARACTERISTICA =
                                      'REQUIERE_RENOVACION'
                                  AND ac2.ESTADO = 'Activo')
                          AND iper.ID_PERSONA_ROL =
                              Le_FechaRenovacion.PERSONA_EMPRESA_ROL_ID
                          AND ROWNUM = 1),
                       NULL)
              INTO Ln_IdInfoServicio
              FROM DUAL;
            --
            --
          ELSE
            --
            --
            SELECT NVL((SELECT iser.ID_SERVICIO
                         FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                         JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC iperc
                           ON iperc.PERSONA_EMPRESA_ROL_ID =
                              iper.ID_PERSONA_ROL
                         JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac
                           ON ac.ID_CARACTERISTICA =
                              iperc.CARACTERISTICA_ID
                         JOIN DB_COMERCIAL.INFO_PUNTO ip
                           ON TO_CHAR(ip.ID_PUNTO) = iperc.VALOR
                         JOIN DB_COMERCIAL.INFO_SERVICIO iser
                           ON iser.PUNTO_ID = ip.ID_PUNTO
                         JOIN DB_COMERCIAl.INFO_PLAN_CAB ipc
                           ON iser.PLAN_ID = ipc.ID_PLAN
                        WHERE iper.ID_PERSONA_ROL =
                              Le_FechaRenovacion.ID_PERSONA_ROL
                          AND ac.DESCRIPCION_CARACTERISTICA =
                              'PUNTO CAMBIO RAZON SOCIAL'
                          AND ac.ESTADO = 'Activo'
                          AND ipc.ID_PLAN IN
                              (SELECT ipc2.ID_PLAN
                                 FROM DB_COMERCIAL.INFO_PLAN_CAB ipc2
                                 JOIN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA ipcar
                                   ON ipc2.ID_PLAN = ipcar.PLAN_ID
                                 JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac2
                                   ON ac2.ID_CARACTERISTICA =
                                      ipcar.CARACTERISTICA_ID
                                WHERE ipcar.VALOR = 'SI'
                                  AND ipcar.ESTADO = 'Activo'
                                  AND ac2.DESCRIPCION_CARACTERISTICA =
                                      'REQUIERE_RENOVACION'
                                  AND ac2.ESTADO = 'Activo')
                          AND ROWNUM = 1),
                       NULL)
              INTO Ln_IdInfoServicio
              FROM DUAL;
            --
            --
            --
            IF Ln_IdInfoServicio IS NULL THEN
              --
              --
              SELECT NVL((SELECT iser.ID_SERVICIO
                           FROM DB_COMERCIAL.INFO_SERVICIO iser
                           JOIN DB_COMERCIAL.INFO_PUNTO ip
                             ON iser.PUNTO_ID = ip.ID_PUNTO
                           JOIN DB_COMERCIAl.INFO_PLAN_CAB ipc
                             ON iser.PLAN_ID = ipc.ID_PLAN
                          WHERE TO_CHAR(ip.ID_PUNTO) IN
                                (SELECT TO_CHAR(ipc3.VALOR)
                                   FROM DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA ipc3
                                  WHERE ipc3.ID_PUNTO_CARACTERISTICA =
                                        (SELECT MAX(ipc2.ID_PUNTO_CARACTERISTICA)
                                           FROM DB_COMERCIAL.INFO_PUNTO ip2
                                           JOIN DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA ipc2
                                             ON ip2.ID_PUNTO = ipc2.PUNTO_ID
                                           JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac2
                                             ON ac2.ID_CARACTERISTICA =
                                                ipc2.CARACTERISTICA_ID
                                          WHERE ip2.ID_PUNTO =
                                                Le_FechaRenovacion.PUNTO_ID
                                            AND ac2.DESCRIPCION_CARACTERISTICA =
                                                'PUNTO CAMBIO RAZON SOCIAL'
                                            AND ac2.ESTADO = 'Activo'))
                            AND ipc.ID_PLAN IN
                                (SELECT ipc3.ID_PLAN
                                   FROM DB_COMERCIAL.INFO_PLAN_CAB ipc3
                                   JOIN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA ipcar3
                                     ON ipc3.ID_PLAN = ipcar3.PLAN_ID
                                   JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ac3
                                     ON ac3.ID_CARACTERISTICA =
                                        ipcar3.CARACTERISTICA_ID
                                  WHERE ipcar3.VALOR = 'SI'
                                    AND ipcar3.ESTADO = 'Activo'
                                    AND ac3.DESCRIPCION_CARACTERISTICA =
                                        'REQUIERE_RENOVACION'
                                    AND ac3.ESTADO = 'Activo')
                            AND ROWNUM = 1),
                         NULL)
                INTO Ln_IdInfoServicio
                FROM DUAL;
              --
              --
            END IF;
            --
            --
          END IF;
          --
          --
          --
          IF Ln_IdInfoServicio IS NOT NULL THEN
            --
            --
            SELECT iser.*
              INTO Lr_InfoServicio
              FROM DB_COMERCIAL.INFO_SERVICIO iser
             WHERE iser.ID_SERVICIO = Ln_IdInfoServicio;
            --
            --
            --
            Le_FechaRenovacion.TIPO_ORDEN  := Lr_InfoServicio.TIPO_ORDEN;
            Le_FechaRenovacion.ID_SERVICIO := Lr_InfoServicio.ID_SERVICIO;
            --
            --
          ELSE
            --
            --
            Lv_Seguir := 'N';
            --
            --
          END IF;
          --
          --
        END IF;
        --
        --
        --
        IF Ln_NumeroLazosPermitidos = 10 THEN
          --
          --
          Lv_Seguir := 'N';
          --
          --
        END IF;
        --
        --
        --
        Ln_NumeroLazosPermitidos := Ln_NumeroLazosPermitidos + 1;
        --
      --
      END LOOP;
      --
      --
      --
      IF Lv_FechaActivacion IS NOT NULL THEN
        --
        --
        SELECT NVL((SELECT TO_CHAR(ADD_MONTHS(Lv_FechaActivacion,
                                             Le_FechaRenovacion.FRECUENCIA_PRODUCTO),
                                  'DD/MM/YYYY')
                     FROM DUAL),
                   0)
          INTO Lv_FechaRenovacion
          FROM DUAL;
        --
        --
      ELSE
        --
        --
        Lv_FechaRenovacion := '';
        --
        --
      END IF;
      --
    --
    END LOOP;
    --
    --
    IF C_FechaRenovacion%ISOPEN THEN
      --
      --
      CLOSE C_FechaRenovacion;
      --
      --
    END IF;
    --
    --
    RETURN Lv_FechaRenovacion;
    --
    --
  END F_GET_FECHA_RENOVACION_PLAN;
  ----
  --
  --
  --
  FUNCTION F_GET_FECHA_CREACION_HISTORIAL(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                          Fv_Buscar     IN VARCHAR2,
                                          Fv_Parametro  IN VARCHAR2,
                                          Fd_FechaFin   IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE)
    RETURN VARCHAR2 IS
    --
    --CURSOR QUE RETORNA HISTORIAL DEL SERVICIO DEPENDIENDO DE LA ACCION Y FECHA CONSULTA ENVIADA PARA LA CONSULTA
    --COSTO DEL QUERY: 3
    CURSOR C_GetHistorialByAccion(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                  Cv_Accion     VARCHAR2,
                                  Cd_FechaFin   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE) IS
    --
      SELECT ISERH.ID_SERVICIO_HISTORIAL,
             ISERH.FE_CREACION,
             ISERH.ESTADO,
             ISERH.OBSERVACION
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
       WHERE ISERH.ID_SERVICIO_HISTORIAL =
             (SELECT MAX(ISERH_S.ID_SERVICIO_HISTORIAL)
                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH_S
               WHERE ISERH_S.ACCION = Cv_Accion
                 AND ISERH_S.SERVICIO_ID = Cn_IdServicio
                 AND ISERH_S.FE_CREACION < Cd_FechaFin);
    --
    --
    --CURSOR QUE RETORNA HISTORIAL DEL SERVICIO DEPENDIENDO DE LA OBSERVACION ENVIADA PARA LA CONSULTA
    --COSTO DEL QUERY: 3
    CURSOR C_GetHistorialByObservacion(Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Cv_Observacion VARCHAR2,
                                       Cd_FechaFin    DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE) IS
    --
      SELECT ISERH.ID_SERVICIO_HISTORIAL, ISERH.FE_CREACION, ISERH.ESTADO
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
       WHERE ISERH.ID_SERVICIO_HISTORIAL =
             (SELECT MAX(ISERH_S.ID_SERVICIO_HISTORIAL)
                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH_S
               WHERE ISERH_S.OBSERVACION LIKE Cv_Observacion
                 AND ISERH_S.SERVICIO_ID = Cn_IdServicio
                 AND ISERH_S.FE_CREACION < Cd_FechaFin);
    --
    --
    --
    --CURSOR QUE RETORNA LA FECHA DE CREACION DEL HISTORIAL DEPENDIENDO DEL ESTADO ENVIADO PARA LA CONSULTA
    --COSTO DEL QUERY: 3
    CURSOR C_GetFechaHistorialByEstado(Cn_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Cv_Estado               VARCHAR2,
                                       Cv_DescripcionSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE) IS
    --
      SELECT ISERH.FE_CREACION,
             NVL((SELECT NVL(TRIM(AM.NOMBRE_MOTIVO), NULL)
                   FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                   JOIN DB_GENERAL.ADMI_MOTIVO AM
                     ON AM.ID_MOTIVO = IDS.MOTIVO_ID
                   JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
                     ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
                  WHERE ATS.DESCRIPCION_SOLICITUD = Cv_DescripcionSolicitud
                    AND IDS.SERVICIO_ID = ISERH.SERVICIO_ID
                    AND ROWNUM = 1),
                 (SELECT NVL(TRIM(AM_S.NOMBRE_MOTIVO), NULL)
                    FROM DB_GENERAL.ADMI_MOTIVO AM_S
                   WHERE AM_S.ID_MOTIVO = ISERH.MOTIVO_ID)) AS NOMBRE_MOTIVO,
             NVL((SELECT NVL(TRIM(AMP.NOMBRE_MOTIVO), NULL)
                   FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                   JOIN DB_GENERAL.ADMI_MOTIVO AM
                     ON AM.ID_MOTIVO = IDS.MOTIVO_ID
                   JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
                     ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
                   JOIN DB_GENERAL.ADMI_MOTIVO AMP
                     ON AM.REF_MOTIVO_ID = AMP.ID_MOTIVO
                  WHERE ATS.DESCRIPCION_SOLICITUD = Cv_DescripcionSolicitud
                    AND IDS.SERVICIO_ID = ISERH.SERVICIO_ID
                    AND ROWNUM = 1),
                 (SELECT NVL(TRIM(AMP_S.NOMBRE_MOTIVO), NULL)
                    FROM DB_GENERAL.ADMI_MOTIVO AM_S
                    JOIN DB_GENERAL.ADMI_MOTIVO AMP_S
                      ON AM_S.REF_MOTIVO_ID = AMP_S.ID_MOTIVO
                   WHERE AM_S.ID_MOTIVO = ISERH.MOTIVO_ID)) AS NOMBRE_MOTIVO_PADRE,
             ISERH.OBSERVACION,
             ISERH.ID_SERVICIO_HISTORIAL
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
       WHERE ISERH.ID_SERVICIO_HISTORIAL =
             (SELECT MAX(ISERH_S.ID_SERVICIO_HISTORIAL)
                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH_S
               WHERE ISERH_S.ESTADO = Cv_Estado
                 AND ISERH_S.SERVICIO_ID = Cn_IdServicio);
    --
    --
    --CURSOR QUE RETORNA EL ESTADO DEL HISTORIAL DEL SERVICIO A BUSCAR
    --COSTO DEL QUERY: 3
    CURSOR C_GetHistorial(Cn_IdServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE) IS
    --
      SELECT ISERH.ID_SERVICIO_HISTORIAL, ISERH.ESTADO, ISERH.FE_CREACION
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
       WHERE ISERH.ID_SERVICIO_HISTORIAL = Cn_IdServicioHistorial;
    --
    --
    Lr_GetEstadoHistorial        C_GetHistorial%ROWTYPE;
    Lr_GetHistorialByObservacion C_GetHistorialByObservacion%ROWTYPE;
    Lr_GetFechaHistorialByEstado C_GetFechaHistorialByEstado%ROWTYPE;
    Lr_GetHistorialByAccion      C_GetHistorialByAccion%ROWTYPE;
    Lv_DescripcionSolicitud      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE := 'CANCELACION';
    Lv_FechaResultado            VARCHAR2(1000) := '';
    --
  BEGIN
    --
    IF Fv_Parametro = 'Accion' THEN
      --
      --
      SELECT NVL((SELECT iserh.FE_CREACION
                   FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL iserh
                   JOIN DB_COMERCIAL.INFO_SERVICIO iser
                     ON iserh.SERVICIO_ID = iser.ID_SERVICIO
                  WHERE iser.ID_SERVICIO = Fn_IdServicio
                    AND iserh.ID_SERVICIO_HISTORIAL =
                        (SELECT MAX(iserh2.ID_SERVICIO_HISTORIAL)
                           FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL iserh2
                          WHERE iserh2.ACCION = Fv_Buscar
                            AND iserh2.SERVICIO_ID = Fn_IdServicio)),
                 NULL)
        INTO Lv_FechaResultado
        FROM DUAL;
      --
      --
    ELSIF Fv_Parametro = 'Estado' OR Fv_Parametro = 'Motivo' OR
          Fv_Parametro = 'MotivoPadre' THEN
      --
      IF C_GetFechaHistorialByEstado%ISOPEN THEN
        CLOSE C_GetFechaHistorialByEstado;
      END IF;
      --
      OPEN C_GetFechaHistorialByEstado(Fn_IdServicio,
                                       Fv_Buscar,
                                       Lv_DescripcionSolicitud);
      --
      FETCH C_GetFechaHistorialByEstado
        INTO Lr_GetFechaHistorialByEstado;
      --
      CLOSE C_GetFechaHistorialByEstado;
      --
      --
      IF Lr_GetFechaHistorialByEstado.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        IF Fv_Parametro = 'Estado' THEN
          --
          Lv_FechaResultado := Lr_GetFechaHistorialByEstado.FE_CREACION;
          --
        ELSIF Fv_Parametro = 'Motivo' THEN
          --
          Lv_FechaResultado := Lr_GetFechaHistorialByEstado.NOMBRE_MOTIVO;
          --
          IF TRIM(Lv_FechaResultado) IS NULL THEN
            --
            Lv_FechaResultado := TO_CHAR(dbms_lob.substr(Lr_GetFechaHistorialByEstado.OBSERVACION,
                                                         300,
                                                         1));
            --
          END IF;
          --
        ELSIF Fv_Parametro = 'MotivoPadre' THEN
          --
          Lv_FechaResultado := Lr_GetFechaHistorialByEstado.NOMBRE_MOTIVO_PADRE;
          --
        END IF;
        --
      END IF;
      --
      --
    ELSIF Fv_Parametro = 'HistorialByAccionObservacion' THEN
      --
      IF C_GetHistorialByAccion%ISOPEN THEN
        CLOSE C_GetHistorialByAccion;
      END IF;
      --
      OPEN C_GetHistorialByAccion(Fn_IdServicio, Fv_Buscar, Fd_FechaFin);
      --
      FETCH C_GetHistorialByAccion
        INTO Lr_GetHistorialByAccion;
      --
      CLOSE C_GetHistorialByAccion;
      --
      --
      IF Lr_GetHistorialByAccion.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        Lv_FechaResultado := TRIM(Lr_GetHistorialByAccion.OBSERVACION);
        --
      END IF;
      --
      --
    ELSIF Fv_Parametro = 'HistorialByObservacionEstado' THEN
      --
      IF C_GetHistorialByObservacion%ISOPEN THEN
        CLOSE C_GetHistorialByObservacion;
      END IF;
      --
      OPEN C_GetHistorialByObservacion(Fn_IdServicio,
                                       Fv_Buscar,
                                       Fd_FechaFin);
      --
      FETCH C_GetHistorialByObservacion
        INTO Lr_GetHistorialByObservacion;
      --
      CLOSE C_GetHistorialByObservacion;
      --
      --
      IF Lr_GetHistorialByObservacion.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        Lv_FechaResultado := TRIM(Lr_GetHistorialByObservacion.ESTADO);
        --
      END IF;
      --
    ELSIF Fv_Parametro = 'HistorialByObservacionFeCreacion' THEN
      --
      IF C_GetHistorialByObservacion%ISOPEN THEN
        CLOSE C_GetHistorialByObservacion;
      END IF;
      --
      OPEN C_GetHistorialByObservacion(Fn_IdServicio,
                                       Fv_Buscar,
                                       Fd_FechaFin);
      --
      FETCH C_GetHistorialByObservacion
        INTO Lr_GetHistorialByObservacion;
      --
      CLOSE C_GetHistorialByObservacion;
      --
      --
      IF Lr_GetHistorialByObservacion.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        Lv_FechaResultado := TRIM(Lr_GetHistorialByObservacion.FE_CREACION);
        --
      END IF;
      --
    ELSIF Fv_Parametro = 'Historial' THEN
      --
      IF C_GetHistorial%ISOPEN THEN
        CLOSE C_GetHistorial;
      END IF;
      --
      OPEN C_GetHistorial(Fn_IdServicio);
      --
      FETCH C_GetHistorial
        INTO Lr_GetEstadoHistorial;
      --
      CLOSE C_GetHistorial;
      --
      --
      IF Lr_GetEstadoHistorial.ID_SERVICIO_HISTORIAL > 0 THEN
        --
        IF Fv_Buscar = 'Estado' THEN
          --
          Lv_FechaResultado := TRIM(Lr_GetEstadoHistorial.ESTADO);
          --
        ELSE
          --
          Lv_FechaResultado := TRIM(Lr_GetEstadoHistorial.FE_CREACION);
          --
        END IF;
        --
      END IF;
      --
    ELSE
      --
      --
      SELECT NVL((SELECT iserh.FE_CREACION
                   FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL iserh
                   JOIN DB_COMERCIAL.INFO_SERVICIO iser
                     ON iserh.SERVICIO_ID = iser.ID_SERVICIO
                  WHERE iser.ID_SERVICIO = Fn_IdServicio
                    AND iserh.ID_SERVICIO_HISTORIAL =
                        (SELECT MAX(iserh2.ID_SERVICIO_HISTORIAL)
                           FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL iserh2
                          WHERE iserh2.OBSERVACION LIKE Fv_Buscar
                            AND iserh2.SERVICIO_ID = Fn_IdServicio)),
                 NULL)
        INTO Lv_FechaResultado
        FROM DUAL;
      --
      --
    END IF;
    --
    --
    --
    RETURN Lv_FechaResultado;
    --
    --
  END F_GET_FECHA_CREACION_HISTORIAL;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_NOMBRE_CLIENTE
  * la funcion F_GET_SOLMA_NOMBRE_CLIENTE obtiene el nombre o razon social del cliente en tabla INFO_PERSONA
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE    Recibe el Id detalle solicitud Cabecera
  * @return VARCHAR2  Retorna el nombre del cliente
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_NOMBRE_CLIENTE(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetCliente(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE) IS
      SELECT NVL(IP.RAZON_SOCIAL, IP.NOMBRES || ' ' || IP.APELLIDOS)
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        LEFT JOIN DB_COMERCIAL.INFO_SERVICIO ISER
          ON IDS.SERVICIO_ID = ISER.ID_SERVICIO
        LEFT JOIN DB_COMERCIAL.INFO_PUNTO IPTO
          ON ISER.PUNTO_ID = IPTO.ID_PUNTO
        LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
          ON IPTO.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
        LEFT JOIN DB_COMERCIAL.INFO_PERSONA IP
          ON IP.ID_PERSONA = IPER.PERSONA_ID
        LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC_DET
          ON IDS.ID_DETALLE_SOLICITUD = IDSC_DET.DETALLE_SOLICITUD_ID
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          ON IDSC_DET.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
       WHERE ACAR.DESCRIPCION_CARACTERISTICA = 'Referencia Solicitud'
         AND IDSC_DET.VALOR = TO_CHAR(Cn_IdDetalleSolicitud)
         AND ROWNUM < 2;
    --
    Lv_NombreCliente VARCHAR2(500) := '';
    --
  BEGIN
    --
    IF C_GetCliente%ISOPEN THEN
      CLOSE C_GetCliente;
    END IF;
    --
    OPEN C_GetCliente(Fn_IdDetalleSolicitud);
    --
    FETCH C_GetCliente
      INTO Lv_NombreCliente;
    --
    CLOSE C_GetCliente;
    --
    RETURN Lv_NombreCliente;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_NombreCliente;
      --
  END F_GET_SOLMA_NOMBRE_CLIENTE;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_NOMBRE_PRODUCTO
  * la funcion F_GET_SOLMA_NOMBRE_PRODUCTO obtiene el nombre o razon social del cliente en tabla INFO_PERSONA
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE    Recibe el Id detalle solicitud Cabecera
  * @return VARCHAR2  Retorna el nombre del cliente
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_NOMBRE_PRODUCTO(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetProducto(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE) IS
      SELECT APROD.DESCRIPCION_PRODUCTO
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        LEFT JOIN DB_COMERCIAL.INFO_SERVICIO ISER
          ON IDS.SERVICIO_ID = ISER.ID_SERVICIO
        LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO APROD
          ON ISER.PRODUCTO_ID = APROD.ID_PRODUCTO
        LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC_DET
          ON IDS.ID_DETALLE_SOLICITUD = IDSC_DET.DETALLE_SOLICITUD_ID
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          ON IDSC_DET.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
       WHERE ACAR.DESCRIPCION_CARACTERISTICA = 'Referencia Solicitud'
         AND IDSC_DET.VALOR = TO_CHAR(Cn_IdDetalleSolicitud)
         AND ROWNUM < 2;
    --
    Lv_NombreProducto VARCHAR2(500) := '';
    --
  BEGIN
    --
    IF C_GetProducto%ISOPEN THEN
      CLOSE C_GetProducto;
    END IF;
    --
    OPEN C_GetProducto(Fn_IdDetalleSolicitud);
    --
    FETCH C_GetProducto
      INTO Lv_NombreProducto;
    --
    CLOSE C_GetProducto;
    --
    RETURN Lv_NombreProducto;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_NombreProducto;
      --
  END F_GET_SOLMA_NOMBRE_PRODUCTO;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_CARACTERISTICA
  * la funcion F_GET_SOLMA_CARACTERISTICA obtiene el valor de la caracteristica en INFO_DETALLE_SOL_CARACT
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE    Recibe el Id detalle solicitud Cabecera
  * @param  Fn_descCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE Recibe la descripcion de la caracteristica
  * @return VARCHAR2  Retorna valor de la caracteristica
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_CARACTERISTICA(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                      Fn_descCaracteristica IN ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetCaracteristica(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                               Cn_descCaracteristica ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE) IS
      SELECT IDSC.VALOR
        FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          ON IDSC.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
       WHERE IDSC.DETALLE_SOLICITUD_ID = Cn_IdDetalleSolicitud
         AND ACAR.DESCRIPCION_CARACTERISTICA = Cn_descCaracteristica;
    --
    Lv_ValorCaracteristica VARCHAR2(500) := '';
    --
  BEGIN
    --
    IF C_GetCaracteristica%ISOPEN THEN
      CLOSE C_GetCaracteristica;
    END IF;
    --
    OPEN C_GetCaracteristica(Fn_IdDetalleSolicitud, Fn_descCaracteristica);
    --
    FETCH C_GetCaracteristica
      INTO Lv_ValorCaracteristica;
    --
    CLOSE C_GetCaracteristica;
    --
    RETURN Lv_ValorCaracteristica;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_ValorCaracteristica;
      --
  END F_GET_SOLMA_CARACTERISTICA;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_TOTAL_DET_EST
  * la funcion F_GET_SOLMA_TOTAL_DET_EST obtiene el total de detalles con determinado estado de una Solicitud Masiva
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE Recibe el Id detalle solicitud Cabecera
  * @param  Fn_estado IN VARCHAR2 Recibe el nombre del estado
  * @return NUMBER  Retorna la cantidad de detalles
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_TOTAL_DET_EST(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                     Fn_estado             IN VARCHAR2)
    RETURN NUMBER IS
    --
    CURSOR C_GetTotalDetalles(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                              Cn_estado             VARCHAR2) IS
      SELECT COUNT(*) TOTAL
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
          ON IDS.ID_DETALLE_SOLICITUD = IDSC.DETALLE_SOLICITUD_ID
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          ON IDSC.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
       WHERE ACAR.DESCRIPCION_CARACTERISTICA = 'Referencia Solicitud'
         AND IDSC.VALOR = TO_CHAR(Cn_IdDetalleSolicitud)
         AND (IDS.ESTADO = Cn_estado OR Cn_estado IS NULL OR Cn_estado = '');
    --
    Lv_TotalDetalles NUMBER := 0;
    --
  BEGIN
    --
    IF C_GetTotalDetalles%ISOPEN THEN
      CLOSE C_GetTotalDetalles;
    END IF;
    --
    OPEN C_GetTotalDetalles(Fn_IdDetalleSolicitud, Fn_estado);
    --
    FETCH C_GetTotalDetalles
      INTO Lv_TotalDetalles;
    --
    CLOSE C_GetTotalDetalles;
    --
    RETURN Lv_TotalDetalles;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_TotalDetalles;
      --
  END F_GET_SOLMA_TOTAL_DET_EST;
  --
  /**
  * Documentacion para la funcion F_GET_SOLMA_TOTAL_DET_EST_CAR
  * la funcion F_GET_SOLMA_TOTAL_DET_EST_CAR obtiene el total de detalles con determinado estado de una Solicitud Masiva en una caracteristica
  *
  * @param  Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE Recibe el Id detalle solicitud Cabecera
  * @param  Fn_estado IN VARCHAR2 Recibe el nombre del estado
  * @param  Fn_caracteristica IN VARCHAR2 Recibe el nombre de la caracteristica
  * @return NUMBER  Retorna la cantidad de detalles
  * @author Robinson Salgado <rsalgado@telconet.ec>
  * @version 1.0 19-07-2016
  */
  FUNCTION F_GET_SOLMA_TOTAL_DET_EST_CAR(Fn_IdDetalleSolicitud IN INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                         Fn_caracteristica     IN VARCHAR2,
                                         Fn_estado             IN VARCHAR2)
    RETURN NUMBER IS
    --
    CURSOR C_GetTotalDetalles(Cn_IdDetalleSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                              Cn_caracteristica     VARCHAR2,
                              Cn_estado             VARCHAR2) IS
      SELECT COUNT(T1.ID_DETALLE_SOLICITUD)
        FROM (SELECT IDS.*
                FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
                  ON IDS.ID_DETALLE_SOLICITUD = IDSC.DETALLE_SOLICITUD_ID
                LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
                  ON IDSC.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
               WHERE ACAR.DESCRIPCION_CARACTERISTICA =
                     'Referencia Solicitud'
                 AND IDSC.VALOR = TO_CHAR(Cn_IdDetalleSolicitud)) T1
        JOIN (SELECT IDS.*, ACAR.DESCRIPCION_CARACTERISTICA, IDSC.VALOR
                FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC
                  ON IDS.ID_DETALLE_SOLICITUD = IDSC.DETALLE_SOLICITUD_ID
                LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
                  ON IDSC.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
               WHERE ACAR.DESCRIPCION_CARACTERISTICA = Cn_caracteristica
                 AND IDSC.VALOR = Cn_estado
                  OR Cn_estado IS NULL
                  OR Cn_estado = '') T2
          ON T2.ID_DETALLE_SOLICITUD = T1.ID_DETALLE_SOLICITUD;
    --
    Lv_TotalDetalles NUMBER := 0;
    --
  BEGIN
    --
    IF C_GetTotalDetalles%ISOPEN THEN
      CLOSE C_GetTotalDetalles;
    END IF;
    --
    OPEN C_GetTotalDetalles(Fn_IdDetalleSolicitud,
                            Fn_caracteristica,
                            Fn_estado);
    --
    FETCH C_GetTotalDetalles
      INTO Lv_TotalDetalles;
    --
    CLOSE C_GetTotalDetalles;
    --
    RETURN Lv_TotalDetalles;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      RETURN Lv_TotalDetalles;
      --
  END F_GET_SOLMA_TOTAL_DET_EST_CAR;
  --
  FUNCTION GET_MODEL_ELE_X_SERV_TIPO(Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pn_TipoElemento IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE,
                                     Pn_Campo        IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetAdmiModeloElemento(Cn_IdElemento DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE) IS
      SELECT AME.ID_MODELO_ELEMENTO,
             AME.NOMBRE_MODELO_ELEMENTO,
             AME.CAPACIDAD_ENTRADA,
             AME.UNIDAD_MEDIDA_ENTRADA,
             AME.CAPACIDAD_SALIDA,
             AME.UNIDAD_MEDIDA_SALIDA
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO        IELE,
             DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME
       WHERE IELE.ID_ELEMENTO = Cn_IdElemento
         AND AME.ID_MODELO_ELEMENTO = IELE.MODELO_ELEMENTO_ID;
    --
    Lr_AdmiModeloElemento C_GetAdmiModeloElemento%ROWTYPE;
    Lv_IdElemento         DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE;
    Lv_Resultado          VARCHAR2(1000);
  BEGIN
    --
    Lv_IdElemento := GET_ELEMENTO_X_SERV_TIPO(Pn_IdServicio,
                                              Pn_TipoElemento);
    --
    IF Lv_IdElemento IS NOT NULL THEN
      --
      IF C_GetAdmiModeloElemento%ISOPEN THEN
        --
        CLOSE C_GetAdmiModeloElemento;
        --
      END IF;
      --
      OPEN C_GetAdmiModeloElemento(Lv_IdElemento);
      --
      FETCH C_GetAdmiModeloElemento
        INTO Lr_AdmiModeloElemento;
      --
      CLOSE C_GetAdmiModeloElemento;
      --
      IF Lr_AdmiModeloElemento.ID_MODELO_ELEMENTO IS NOT NULL THEN
        --
        IF Pn_Campo = 'ID' THEN
          --
          Lv_Resultado := TO_CHAR(Lr_AdmiModeloElemento.ID_MODELO_ELEMENTO);
          --
        END IF;
        --
        IF Pn_Campo = 'NOMBRE' THEN
          --
          Lv_Resultado := Lr_AdmiModeloElemento.NOMBRE_MODELO_ELEMENTO;
          --
        END IF;
        --
        IF Pn_Campo = 'CAPACIDAD1' THEN
          --
          Lv_Resultado := TO_CHAR(Lr_AdmiModeloElemento.CAPACIDAD_ENTRADA);
          --
        END IF;
        --
        IF Pn_Campo = 'CAPACIDAD1_UNIDAD' THEN
          --
          Lv_Resultado := Lr_AdmiModeloElemento.UNIDAD_MEDIDA_ENTRADA;
          --
        END IF;
        --
        IF Pn_Campo = 'CAPACIDAD2' THEN
          --
          Lv_Resultado := TO_CHAR(Lr_AdmiModeloElemento.CAPACIDAD_SALIDA);
          --
        END IF;
        --
        IF Pn_Campo = 'CAPACIDAD2_UNIDAD' THEN
          --
          Lv_Resultado := Lr_AdmiModeloElemento.UNIDAD_MEDIDA_SALIDA;
          --
        END IF;
        --
        --
      END IF;
      --
    END IF;
    --
    RETURN Lv_Resultado;
    --
  END GET_MODEL_ELE_X_SERV_TIPO;
  --
  FUNCTION GET_ELEMENTO_X_SERV_TIPO(Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Pn_TipoElemento IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE IS
    --
    CURSOR C_GetInfoServicioTecnico(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) IS
      SELECT DISTINCT IST.INTERFACE_ELEMENTO_CONECTOR_ID,
                      IST.ELEMENTO_CLIENTE_ID,
                      IST.INTERFACE_ELEMENTO_CLIENTE_ID,
                      ATM.NOMBRE_TIPO_MEDIO,
                      CASE
                        WHEN ISPC.VALOR IS NOT NULL THEN
                         ISPC.VALOR
                        WHEN ISPC.VALOR IS NULL AND
                             ATM.NOMBRE_TIPO_MEDIO = 'Fibra Optica' THEN
                         'RUTA'
                        WHEN ISPC.VALOR IS NULL AND
                             ATM.NOMBRE_TIPO_MEDIO != 'Fibra Optica' THEN
                         'DIRECTO'
                      END TIPO_FACTIBILIDAD
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
        JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO ATM
          ON ATM.ID_TIPO_MEDIO = IST.ULTIMA_MILLA_ID
        JOIN DB_COMERCIAL.INFO_SERVICIO ISER
          ON ISER.ID_SERVICIO = IST.SERVICIO_ID
        LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
          ON AC.DESCRIPCION_CARACTERISTICA = 'TIPO_FACTIBILIDAD'
        LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
          ON APC.PRODUCTO_ID = ISER.PRODUCTO_ID
         AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
        LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
          ON ISPC.SERVICIO_ID = ISER.ID_SERVICIO
         AND ISPC.PRODUCTO_CARACTERISITICA_ID =
             APC.ID_PRODUCTO_CARACTERISITICA
       WHERE IST.SERVICIO_ID = Cn_IdServicio;
    --
    CURSOR C_GetNombreTipoElemento(Cn_IdElemento DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE) IS
      SELECT ATE.NOMBRE_TIPO_ELEMENTO
        FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO        IELE,
             DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME,
             DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO   ATE
       WHERE IELE.ID_ELEMENTO = Cn_IdElemento
         AND AME.ID_MODELO_ELEMENTO = IELE.MODELO_ELEMENTO_ID
         AND ATE.ID_TIPO_ELEMENTO = AME.TIPO_ELEMENTO_ID;
    --
    Lr_InfoServicioTecnico C_GetInfoServicioTecnico%ROWTYPE;
    Lv_IdElementoCliente   DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE;
    Lv_NombreTipoElemento  DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE;
  BEGIN
    --
    IF C_GetInfoServicioTecnico%ISOPEN THEN
      --
      CLOSE C_GetInfoServicioTecnico;
      --
    END IF;
    --
    OPEN C_GetInfoServicioTecnico(Pn_IdServicio);
    --
    FETCH C_GetInfoServicioTecnico
      INTO Lr_InfoServicioTecnico;
    --
    CLOSE C_GetInfoServicioTecnico;
    --
    IF Lr_InfoServicioTecnico.NOMBRE_TIPO_MEDIO = 'Fibra Optica' AND
       Lr_InfoServicioTecnico.TIPO_FACTIBILIDAD = 'RUTA' THEN
      --
      Lv_IdElementoCliente := GET_ELEMENTO_CLI_X_TIPO_ELE(Lr_InfoServicioTecnico.INTERFACE_ELEMENTO_CONECTOR_ID,
                                                          Pn_TipoElemento);
      --
    ELSIF (Lr_InfoServicioTecnico.NOMBRE_TIPO_MEDIO = 'Fibra Optica' AND
          Lr_InfoServicioTecnico.TIPO_FACTIBILIDAD = 'DIRECTO') OR
          Lr_InfoServicioTecnico.NOMBRE_TIPO_MEDIO = 'Radio' THEN
      --
      Lv_IdElementoCliente := GET_ELEMENTO_CLI_X_TIPO_ELE(Lr_InfoServicioTecnico.INTERFACE_ELEMENTO_CLIENTE_ID,
                                                          Pn_TipoElemento);
      --
    ELSIF Lr_InfoServicioTecnico.NOMBRE_TIPO_MEDIO = 'UTP' THEN
      --
      Lv_IdElementoCliente := Lr_InfoServicioTecnico.ELEMENTO_CLIENTE_ID;
      --
    END IF;
    --
    IF Lv_IdElementoCliente IS NULL THEN
      --
      IF C_GetNombreTipoElemento%ISOPEN THEN
        --
        CLOSE C_GetNombreTipoElemento;
        --
      END IF;
      --
      OPEN C_GetNombreTipoElemento(Lr_InfoServicioTecnico.ELEMENTO_CLIENTE_ID);
      --
      FETCH C_GetNombreTipoElemento
        INTO Lv_NombreTipoElemento;
      --
      CLOSE C_GetNombreTipoElemento;
      --
      IF Lv_NombreTipoElemento LIKE (Pn_TipoElemento || '%') THEN
        --
        Lv_IdElementoCliente := Lr_InfoServicioTecnico.ELEMENTO_CLIENTE_ID;
        --
      END IF;
      --
    END IF;
    --
    RETURN Lv_IdElementoCliente;
    --
  END GET_ELEMENTO_X_SERV_TIPO;
  --
  FUNCTION GET_ELEMENTO_CLI_X_TIPO_ELE(Pn_IdInterfaceElementoConector IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID%TYPE,
                                       Pn_TipoElemento                IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE IS
    --
    CURSOR C_GetInfoInterfaceElemento(Cn_IdInterfaceElemento DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE) IS
      SELECT IIE.ID_INTERFACE_ELEMENTO, IIE.ELEMENTO_ID
        FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IIE
       WHERE IIE.ID_INTERFACE_ELEMENTO = Cn_IdInterfaceElemento;
    --
    CURSOR C_GetInfoEnlace(Cn_IdInterfaceElementoIni DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_INI_ID%TYPE,
                           Cn_Estado                 DB_INFRAESTRUCTURA.INFO_ENLACE.ESTADO%TYPE) IS
      SELECT IE.INTERFACE_ELEMENTO_FIN_ID
        FROM DB_INFRAESTRUCTURA.INFO_ENLACE IE
       WHERE IE.INTERFACE_ELEMENTO_INI_ID = Cn_IdInterfaceElementoIni
         AND IE.ESTADO = Cn_Estado;
    --
    CURSOR C_GetNombreTipoElemento(Cn_IdInterfaceElemento DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE) IS
      SELECT ATE.NOMBRE_TIPO_ELEMENTO
        FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IIE,
             DB_INFRAESTRUCTURA.INFO_ELEMENTO           IELE,
             DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO    AME,
             DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO      ATE
       WHERE IIE.ID_INTERFACE_ELEMENTO = Cn_IdInterfaceElemento
         AND IELE.ID_ELEMENTO = IIE.ELEMENTO_ID
         AND AME.ID_MODELO_ELEMENTO = IELE.MODELO_ELEMENTO_ID
         AND ATE.ID_TIPO_ELEMENTO = AME.TIPO_ELEMENTO_ID;
    --
    Lr_InfoInterfaceElemento C_GetInfoInterfaceElemento%ROWTYPE;
    Lr_InfoEnlace            C_GetInfoEnlace%ROWTYPE;
    Lv_NombreTipoElemento    DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE;
    Lv_IdElementoCliente     DB_COMERCIAL.INFO_SERVICIO_TECNICO.ELEMENTO_CLIENTE_ID%TYPE;
  BEGIN
    IF C_GetInfoInterfaceElemento%ISOPEN THEN
      --
      CLOSE C_GetInfoInterfaceElemento;
      --
    END IF;
    --
    OPEN C_GetInfoInterfaceElemento(Pn_IdInterfaceElementoConector);
    --
    FETCH C_GetInfoInterfaceElemento
      INTO Lr_InfoInterfaceElemento;
    --
    CLOSE C_GetInfoInterfaceElemento;
    --
    IF Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO IS NOT NULL THEN
      --
      IF C_GetInfoEnlace%ISOPEN THEN
        --
        CLOSE C_GetInfoEnlace;
        --
      END IF;
      --
      OPEN C_GetInfoEnlace(Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO,
                           'Activo');
      --
      FETCH C_GetInfoEnlace
        INTO Lr_InfoEnlace;
      --
      CLOSE C_GetInfoEnlace;
      --
      IF Lr_InfoEnlace.INTERFACE_ELEMENTO_FIN_ID IS NOT NULL THEN
        --
        Lr_InfoInterfaceElemento := NULL;
        --
        IF C_GetInfoInterfaceElemento%ISOPEN THEN
          --
          CLOSE C_GetInfoInterfaceElemento;
          --
        END IF;
        --
        OPEN C_GetInfoInterfaceElemento(Lr_InfoEnlace.INTERFACE_ELEMENTO_FIN_ID);
        --
        FETCH C_GetInfoInterfaceElemento
          INTO Lr_InfoInterfaceElemento;
        --
        CLOSE C_GetInfoInterfaceElemento;
        --
        IF Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO IS NOT NULL THEN
          --
          IF C_GetNombreTipoElemento%ISOPEN THEN
            --
            CLOSE C_GetNombreTipoElemento;
            --
          END IF;
          --
          OPEN C_GetNombreTipoElemento(Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO);
          --
          FETCH C_GetNombreTipoElemento
            INTO Lv_NombreTipoElemento;
          --
          CLOSE C_GetNombreTipoElemento;
          --
          IF Lv_NombreTipoElemento LIKE (Pn_TipoElemento || '%') THEN
            --
            Lv_IdElementoCliente := Lr_InfoInterfaceElemento.ELEMENTO_ID;
            --
          END IF;
          IF Lv_NombreTipoElemento != Pn_TipoElemento THEN
            --
            Lv_IdElementoCliente := GET_ELEMENTO_CLI_X_TIPO_ELE(Lr_InfoInterfaceElemento.ID_INTERFACE_ELEMENTO,
                                                                Pn_TipoElemento);
            --
          END IF;
          --
        END IF;
        --
      END IF;
      --
    END IF;
    --
    RETURN Lv_IdElementoCliente;
    --
  END GET_ELEMENTO_CLI_X_TIPO_ELE;
  --
  FUNCTION F_GET_ID_ELEMENTO_PRINCIPAL(Fn_IdInterfaceElementoCliente IN DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
                                       Fv_TipoElemento               IN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE)
    RETURN DB_COMERCIAL.INFO_ELEMENTO.ID_ELEMENTO%TYPE IS
    CURSOR C_GetIdElementoPrincipal(Cn_IdInterfaceElementoCliente DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
                                    Cv_TipoElemento               DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE) IS
      SELECT e.ID_ELEMENTO
        FROM info_elemento e
        JOIN (SELECT id_elemento, MAX(enlace) lvl
                FROM (SELECT (SELECT iie.elemento_id
                                FROM info_interface_elemento iie
                               WHERE iie.id_interface_elemento =
                                     interface_elemento_fin_id) AS id_elemento,
                             level AS enlace
                        FROM info_enlace
                       START WITH interface_elemento_ini_id =
                                  Cn_IdInterfaceElementoCliente
                      CONNECT BY interface_elemento_ini_id = PRIOR
                                 interface_elemento_fin_id
                       ORDER BY enlace DESC)
               GROUP BY id_elemento) ids
          ON ids.id_elemento = e.id_elemento
        JOIN admi_modelo_elemento me
          ON me.id_modelo_elemento = e.modelo_elemento_id
        JOIN admi_tipo_elemento te
          ON te.id_tipo_elemento = me.tipo_elemento_id
       WHERE te.nombre_tipo_elemento = Cv_TipoElemento
         AND ROWNUM <= 1;
    Fr_GetIdElementoPrincipal C_GetIdElementoPrincipal%ROWTYPE;
    Fn_IdElemento             DB_COMERCIAL.INFO_ELEMENTO.ID_ELEMENTO%TYPE := 0;
  BEGIN
    IF C_GetIdElementoPrincipal%ISOPEN THEN
      CLOSE C_GetIdElementoPrincipal;
    END IF;
    --
    OPEN C_GetIdElementoPrincipal(Fn_IdInterfaceElementoCliente,
                                  Fv_TipoElemento);
    FETCH C_GetIdElementoPrincipal
      INTO Fr_GetIdElementoPrincipal;
    CLOSE C_GetIdElementoPrincipal;
    --
    IF Fr_GetIdElementoPrincipal.ID_ELEMENTO IS NULL THEN
      Fn_IdElemento := 0;
    ELSE
      Fn_IdElemento := Fr_GetIdElementoPrincipal.ID_ELEMENTO;
    END IF;
    --
    RETURN Fn_IdElemento;
    --
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END F_GET_ID_ELEMENTO_PRINCIPAL;
  --

  FUNCTION F_GET_SOL_BY_SERVICIO_ID(Fn_IdServicio        IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Fv_DescTipoSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                    Fv_Estado            IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
    RETURN NUMBER IS
    -- C_GetSolicitud - Costo Query: 6
    CURSOR C_GetSolicitud(Cn_IdServicio        DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                          Cv_DescTipoSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                          Cv_Estado            DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE) IS
      SELECT COUNT(IDS.ID_DETALLE_SOLICITUD)
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
          ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
       WHERE IDS.SERVICIO_ID = Cn_IdServicio
         AND ats.descripcion_solicitud = Cv_DescTipoSolicitud
         AND ids.estado = Cv_Estado;
  
    Ln_TotalDetalles NUMBER := 0;
  
  BEGIN
    IF C_GetSolicitud%ISOPEN THEN
      CLOSE C_GetSolicitud;
    END IF;
  
    OPEN C_GetSolicitud(Fn_IdServicio, Fv_DescTipoSolicitud, Fv_Estado);
    --
    FETCH C_GetSolicitud
      INTO Ln_TotalDetalles;
    --
    RETURN Ln_TotalDetalles;
    --
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.GET_SOL_BY_SERVICIO_ID',
                                           'Error al consultar solicitud con servicioId: ' ||
                                           Fn_IdServicio,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END F_GET_SOL_BY_SERVICIO_ID;

  FUNCTION F_GET_PRODUCTO_BY_COD(Fv_CodigoProducto IN DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE)
    RETURN DB_COMERCIAL.ADMI_PRODUCTO%ROWTYPE IS
    -- C_GetProducto - Costo Query: 2
    CURSOR C_GetProducto(Cv_CodigoProducto DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE) IS
      SELECT AP.*
        FROM DB_COMERCIAL.ADMI_PRODUCTO AP
       WHERE AP.CODIGO_PRODUCTO = Cv_CodigoProducto;
  
    Lr_AdmiProducto DB_COMERCIAL.ADMI_PRODUCTO%ROWTYPE;
  
  BEGIN
    IF C_GetProducto%ISOPEN THEN
      CLOSE C_GetProducto;
    END IF;
  
    OPEN C_GetProducto(Fv_CodigoProducto);
    --
    FETCH C_GetProducto
      INTO Lr_AdmiProducto;
    --
    RETURN Lr_AdmiProducto;
    --
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_PRODUCTO_BY_COD',
                                           'Error al consultar productoId por codigo: ' ||
                                           Fv_CodigoProducto,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END F_GET_PRODUCTO_BY_COD;

  FUNCTION F_GET_SOL_PEND_BY_SER_ID(Fv_DescripcionTipoSolicitud IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                    Fn_IdServicio               IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN SYS_REFCURSOR IS
    C_GetSolicitudes SYS_REFCURSOR;
    -- Costo Query: 4
  BEGIN
    OPEN C_GetSolicitudes FOR
      SELECT IDS.*
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        JOIN DB_COMERCIAL.INFO_SERVICIO ISER
          ON ISER.ID_SERVICIO = IDS.SERVICIO_ID
        JOIN DB_COMERCIAL.INFO_PUNTO IPTO
          ON IPTO.ID_PUNTO = ISER.PUNTO_ID
        JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
          ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
       WHERE ATS.DESCRIPCION_SOLICITUD = Fv_DescripcionTipoSolicitud
         AND IDS.ESTADO = 'Pendiente'
         AND IDS.SERVICIO_ID = Fn_IdServicio;
  
    RETURN C_GetSolicitudes;
  
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_SOL_PEND_BY_SER_ID',
                                           'Error al consultar solicitudes con servicioId: ' ||
                                           Fn_IdServicio,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END F_GET_SOL_PEND_BY_SER_ID;

  FUNCTION F_GET_COD_BY_PREFIJO_EMP(Fv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    RETURN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE IS
    CURSOR C_GetEmpresaCod(Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE) IS
      SELECT IEG.COD_EMPRESA
        FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
       WHERE IEG.PREFIJO = Cv_PrefijoEmpresa
         AND IEG.ESTADO = 'Activo';
  
    Lv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
  
  BEGIN
    IF C_GetEmpresaCod%ISOPEN THEN
      CLOSE C_GetEmpresaCod;
    END IF;
  
    OPEN C_GetEmpresaCod(Fv_PrefijoEmpresa);
    --
    FETCH C_GetEmpresaCod
      INTO Lv_EmpresaCod;
    --
    RETURN Lv_EmpresaCod;
    --
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP',
                                           'Error al consultar empresaCod por prefijo: ',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END F_GET_COD_BY_PREFIJO_EMP;

  PROCEDURE P_GET_PERSONA_X_LOGIN_ID(Pv_Login                 IN VARCHAR2,
                                     Pv_IdentificacionCliente IN VARCHAR2,
                                     Pv_MensajeSalida         OUT VARCHAR2) IS
    CURSOR C_VERIFICA IS
      SELECT COUNT(*)
        FROM DB_COMERCIAL.INFO_PERSONA
       WHERE LOGIN = Pv_Login
         AND IDENTIFICACION_CLIENTE = Pv_IdentificacionCliente;
  
    Ln_Existencia    Number := 0;
    Lv_MensajeSalida Varchar2(15) := 'NoExiste';
  
  BEGIN
  
    IF C_VERIFICA%ISOPEN THEN
      CLOSE C_VERIFICA;
    END IF;
    OPEN C_VERIFICA;
    FETCH C_VERIFICA
      INTO Ln_Existencia;
    CLOSE C_VERIFICA;
  
    IF Ln_Existencia > 0 THEN
      Lv_MensajeSalida := 'Existe';
    END IF;
    Pv_MensajeSalida := Lv_MensajeSalida;
  
  EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_PERSONA_X_LOGIN_ID',
                                           'Error al consultar persona por login e identifiacion: ',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_GET_PERSONA_X_LOGIN_ID;

  FUNCTION F_GET_JEFE_BY_ID_PERSONA(Pv_idPersona IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
    RETURN NUMBER IS
    CURSOR C_getJefe(Cv_idPersona NUMBER) IS
      SELECT ee.id_jefe, ee.no_cia_jefe
        FROM info_persona p, NAF47_TNET.V_EMPLEADOS_EMPRESAS ee
       WHERE ee.cedula = p.IDENTIFICACION_CLIENTE
          AND ee.estado = 'A'
         AND p.id_persona = Cv_idPersona;
    CURSOR C_getIdPersona(Cv_idPersona NUMBER, Cv_cia NUMBER) IS
      SELECT P.ID_PERSONA
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS ee, info_persona p
       WHERE ee.no_emple = Cv_idPersona
         AND ee.no_cia = Cv_cia
         AND ee.cedula = p.IDENTIFICACION_CLIENTE;
    Ln_jefe         NUMBER := 0;
    Ln_cia_jefe     NUMBER := 0;
    Ln_persona_jefe NUMBER := 0;
  BEGIN
    OPEN C_getJefe(Pv_idPersona);
    FETCH C_getJefe
      INTO Ln_jefe, Ln_cia_jefe;
    CLOSE C_getJefe;
    IF Ln_cia_jefe > 0 AND Ln_jefe > 0 THEN
      OPEN C_getIdPersona(Ln_jefe, Ln_cia_jefe);
      FETCH C_getIdPersona
        INTO Ln_persona_jefe;
      CLOSE C_getIdPersona;
    END IF;
    RETURN Ln_persona_jefe;
  END;

  PROCEDURE P_GET_SSID_FOX(Pv_UsuarioFox    IN VARCHAR2,
                           Pv_PasswordFox   IN VARCHAR2,
                           Pv_KeyEncript    IN VARCHAR2,
                           Pv_SsidFox       OUT VARCHAR2,
                           Pv_CodPais       OUT VARCHAR2,
                           Pv_MensajeSalida OUT VARCHAR2) IS
  
    CURSOR C_CODIGO_EMPRESA(Cn_IdServicio Number) IS
      SELECT EMPRESA_ID
        FROM DB_COMERCIAL.INFO_SERVICIO            ISE,
             DB_COMERCIAL.INFO_PUNTO               IPU,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPE,
             DB_COMERCIAL.INFO_OFICINA_GRUPO       IOG
       WHERE ISE.PUNTO_ID = IPU.ID_PUNTO
         AND IPU.PERSONA_EMPRESA_ROL_ID = IPE.ID_PERSONA_ROL
         AND IPE.OFICINA_ID = IOG.ID_OFICINA
         AND ISE.ID_SERVICIO = Cn_IdServicio;
  
    CURSOR C_COD_PAIS(Cv_CodEmpresa Varchar2) IS
      SELECT DET.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
       WHERE CAB.ID_PARAMETRO = DET.PARAMETRO_ID
         AND DET.DESCRIPCION = 'CODIGO_DE_PAIS'
         AND CAB.ESTADO = 'Activo'
         AND DET.ESTADO = 'Activo'
         AND DET.EMPRESA_COD = Cv_CodEmpresa;
  
    Lv_UsuarioFox         Varchar2(100) := 'USUARIO_FOX';
    Lv_PasswordFox        Varchar2(100) := 'PASSWORD_FOX';
    Lv_ValorUsuario       Varchar2(100);
    Lv_ServicioIdUsuario  Varchar2(100);
    Lv_MensajeSalida      Varchar2(500);
    Lv_ValorPassword      Varchar2(100);
    Lv_ServicioIdPassword Varchar2(100);
    Lv_PassEncriptado     Varchar2(4000);
    Lv_CodEmpresa         Varchar2(10);
    Lv_CodPais            Varchar2(10);
    Lv_SubscriberId       Varchar2(100);
  
    Le_Error Exception;
  
  BEGIN
  
    P_VALIDA_CARACTERISTICA(Lv_UsuarioFox,
                            Pv_UsuarioFox,
                            Lv_ServicioIdUsuario,
                            Lv_MensajeSalida);
    IF Lv_MensajeSalida = 'Error' THEN
      Lv_MensajeSalida := ' Error en P_VALIDA_CARACTERISTICA Usuario' ||
                          Lv_MensajeSalida;
      Raise Le_Error;
    ELSE
      IF Lv_ServicioIdUsuario IS NOT NULL THEN
        DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR(Pv_PasswordFox,
                                                   Pv_KeyEncript,
                                                   Lv_PassEncriptado);
        P_VALIDA_CARACTERISTICA(Lv_PasswordFox,
                                Lv_PassEncriptado,
                                Lv_ServicioIdPassword,
                                Lv_MensajeSalida);
        IF Lv_MensajeSalida = 'Error' THEN
          Lv_MensajeSalida := ' Error en P_VALIDA_CARACTERISTICA Password' ||
                              Lv_MensajeSalida;
          Raise Le_Error;
        ELSE
          IF Lv_ServicioIdUsuario = Lv_ServicioIdPassword THEN
            Lv_SubscriberId := Lv_ServicioIdUsuario;
            IF C_CODIGO_EMPRESA%ISOPEN THEN
              CLOSE C_CODIGO_EMPRESA;
            END IF;
            OPEN C_CODIGO_EMPRESA(Lv_SubscriberId);
            FETCH C_CODIGO_EMPRESA
              INTO Lv_CodEmpresa;
            IF C_CODIGO_EMPRESA%NOTFOUND THEN
              Lv_MensajeSalida := 'No se encontro empresa para servicio: ' ||
                                  Lv_SubscriberId;
              Raise Le_Error;
            ELSE
              IF C_COD_PAIS%ISOPEN THEN
                CLOSE C_COD_PAIS;
              END IF;
              OPEN C_COD_PAIS(Lv_CodEmpresa);
              FETCH C_COD_PAIS
                INTO Lv_CodPais;
              IF C_COD_PAIS%NOTFOUND THEN
                Lv_MensajeSalida := 'No se encontro pais para empresa: ' ||
                                    Lv_CodEmpresa;
                Raise Le_Error;
              ELSE
                Pv_MensajeSalida := 'OK';
                Pv_SsidFox       := Lv_SubscriberId;
                Pv_CodPais       := Lv_CodPais;
              END IF;
              CLOSE C_COD_PAIS;
            
            END IF;
          
            CLOSE C_CODIGO_EMPRESA;
          ELSE
            Lv_MensajeSalida := ' Error Password incorrecto';
            Raise Le_Error;
          END IF;
        END IF;
      ELSE
        Lv_MensajeSalida := ' Error Usuario incorrecto';
        Raise Le_Error;
      END IF;
    END IF;
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SSID_FOX',
                                           Lv_MensajeSalida,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_SSID_FOX',
                                           SQLCODE || ' ' || SQLERRM,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_GET_SSID_FOX;

  PROCEDURE P_VALIDA_CARACTERISTICA(Pv_DescrCaracteristica IN VARCHAR2,
                                    Pv_Valor               IN VARCHAR2,
                                    Pv_ServicioId          OUT VARCHAR2,
                                    Pv_MensajeSalida       OUT VARCHAR2) IS
  
    CURSOR C_CARACTERISTICA(Cv_DescriCaracteristica Varchar2) IS
      SELECT ID_CARACTERISTICA
        FROM ADMI_CARACTERISTICA
       WHERE DESCRIPCION_CARACTERISTICA = Cv_DescriCaracteristica
         AND ESTADO = 'Activo';
  
    CURSOR C_ADMI_PROD_CARACTERISTICA(Cv_CaracteristicaId Varchar2) IS
      SELECT ID_PRODUCTO_CARACTERISITICA
        FROM ADMI_PRODUCTO_CARACTERISTICA
       WHERE CARACTERISTICA_ID = Cv_CaracteristicaId
         AND ESTADO = 'Activo';
  
    CURSOR C_INFO_SERV_PROD_CARACT(Cv_ProdCaracId Varchar2,
                                   Cv_Valor       Varchar2) IS
      SELECT SERVICIO_ID
        FROM INFO_SERVICIO_PROD_CARACT
       WHERE PRODUCTO_CARACTERISITICA_ID = Cv_ProdCaracId
         AND VALOR = Cv_Valor
         AND ESTADO = 'Activo';
  
    Ln_ServicioId           INFO_SERVICIO_PROD_CARACT.SERVICIO_ID%TYPE;
    Ln_IdCaracateristica    ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdProCaracateristica ADMI_PRODUCTO_CARACTERISTICA.ID_PRODUCTO_CARACTERISITICA%TYPE;
    Lr_InfoServProdCaract   C_INFO_SERV_PROD_CARACT%ROWTYPE;
    Lv_MensajeSalida        Varchar2(500);
  
    Le_Error Exception;
  
  BEGIN
  
    IF C_CARACTERISTICA%ISOPEN THEN
      CLOSE C_CARACTERISTICA;
    END IF;
  
    OPEN C_CARACTERISTICA(Pv_DescrCaracteristica);
    FETCH C_CARACTERISTICA
      INTO Ln_IdCaracateristica;
    IF C_CARACTERISTICA%NOTFOUND THEN
      Lv_MensajeSalida := ' Error en C_CARACTERISTICA';
      Raise Le_Error;
    ELSE
      IF C_ADMI_PROD_CARACTERISTICA%ISOPEN THEN
        CLOSE C_ADMI_PROD_CARACTERISTICA;
      END IF;
      OPEN C_ADMI_PROD_CARACTERISTICA(Ln_IdCaracateristica);
      FETCH C_ADMI_PROD_CARACTERISTICA
        INTO Ln_IdProCaracateristica;
      IF C_ADMI_PROD_CARACTERISTICA%NOTFOUND THEN
        Lv_MensajeSalida := ' Error en C_ADMI_PROD_CARACTERISTICA';
        Raise Le_Error;
      ELSE
        IF C_INFO_SERV_PROD_CARACT%ISOPEN THEN
          CLOSE C_INFO_SERV_PROD_CARACT;
        END IF;
        OPEN C_INFO_SERV_PROD_CARACT(Ln_IdProCaracateristica, Pv_Valor);
        FETCH C_INFO_SERV_PROD_CARACT
          INTO Lr_InfoServProdCaract;
        IF C_INFO_SERV_PROD_CARACT%NOTFOUND THEN
          Lv_MensajeSalida := ' Error en C_INFO_SERV_PROD_CARACT';
          Raise Le_Error;
        ELSE
          Pv_ServicioId := Lr_InfoServProdCaract.Servicio_Id;
        END IF;
        CLOSE C_INFO_SERV_PROD_CARACT;
      END IF;
      CLOSE C_ADMI_PROD_CARACTERISTICA;
    END IF;
    CLOSE C_CARACTERISTICA;
  
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_VALIDA_CARACTERISTICA',
                                           Lv_MensajeSalida,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_VALIDA_CARACTERISTICA',
                                           'Error al consultar persona por login e identifiacion: ',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_VALIDA_CARACTERISTICA;

  PROCEDURE P_VERIFICA_ESTADO_SERVICIO(Pn_IdSpcSuscriber    IN NUMBER,
                                       Pv_SubscriberId      IN VARCHAR2,
                                       Pv_CountryCode       IN VARCHAR2,
                                       Pv_CodigoUrn         IN VARCHAR2,
                                       Pv_CodigoSalida      OUT VARCHAR2,
                                       Pv_MensajeSalida     OUT VARCHAR2,
                                       Pv_strCodigoUrn      IN VARCHAR2, 
                                       Pv_strSsid           IN VARCHAR2)
  IS
  
    CURSOR C_PARAMETROS(Cv_Valor1      Varchar2,
                        Cv_Descripcion Varchar2,
                        Cv_Estado      Varchar2) IS
      SELECT DET.EMPRESA_COD
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
       WHERE CAB.ID_PARAMETRO = DET.PARAMETRO_ID
         AND DET.DESCRIPCION = Cv_Descripcion
         AND CAB.ESTADO = Cv_Estado
         AND DET.ESTADO = Cv_Estado
         AND DET.VALOR1 = Cv_Valor1;
  
    CURSOR C_CARACTERISTICA(Cn_SSid        Number,
                            Cv_Descripcion Varchar2,
                            Cv_Estado      Varchar2) IS
      SELECT ISPC.SERVICIO_ID
        FROM ADMI_CARACTERISTICA          ACA,
             ADMI_PRODUCTO_CARACTERISTICA APC,
             INFO_SERVICIO_PROD_CARACT    ISPC
       WHERE ACA.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
         AND APC.ID_PRODUCTO_CARACTERISITICA =
             ISPC.PRODUCTO_CARACTERISITICA_ID
         AND ACA.DESCRIPCION_CARACTERISTICA = Cv_Descripcion
         AND ISPC.VALOR = Cn_SSid
         AND ACA.ESTADO = Cv_Estado
         AND APC.ESTADO = Cv_Estado
         AND ISPC.ESTADO = Cv_Estado;
  
    CURSOR C_SERVICIO(Cn_IdServicio Number, Cv_Estado Varchar2) IS
      SELECT 'X'
        FROM DB_COMERCIAL.INFO_SERVICIO            ISE,
             DB_COMERCIAL.INFO_PUNTO               IPU,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPE,
             DB_COMERCIAL.INFO_OFICINA_GRUPO       IOG
       WHERE ISE.PUNTO_ID = IPU.ID_PUNTO
         AND IPU.PERSONA_EMPRESA_ROL_ID = IPE.ID_PERSONA_ROL
         AND IPE.OFICINA_ID = IOG.ID_OFICINA
         AND ISE.ID_SERVICIO = Cn_IdServicio
         AND ISE.ESTADO = Cv_Estado;

    Lv_EmpresaCod    DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE;
    Lv_EmpresaUrn    DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE;
    Lv_Existe        Varchar2(1);
    Lv_CodigoPais    Varchar2(50) := 'CODIGO_DE_PAIS';
    Lv_CodigoUrn     Varchar2(50) := Pv_strCodigoUrn;
    Lv_CodigoSsIdFox Varchar2(50) := Pv_strSsid;
    Lv_Estado        Varchar2(50) := 'Activo';
    Ln_IdServicio    DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
    
    Le_Error Exception;

    Lv_NombreParamsWsProductosTv    VARCHAR2(100) := 'PARAMETROS_WS_PRODUCTOS_TV';
    Lv_VerifAutorizacion            VARCHAR2(100) := 'VERIFICACIONES_AUTORIZACION';
    Lv_EstadosServiciosPermitidos   VARCHAR2(100) := 'ESTADOS_SERVICIOS_PERMITIDOS';
    Lv_VerificaSaldoPendiente       VARCHAR2(100) := 'VERIFICA_SALDO_PENDIENTE';
    Lv_VerificaFinCicloFacturacion  VARCHAR2(100) := 'VERIFICA_FIN_CICLO_FACTURACION';
    Lv_CicloFacturacion             VARCHAR2(100) := 'CICLO_FACTURACION';
    Lv_EstadoCancel                 VARCHAR2(6)   := 'Cancel';
    Lv_FechaMinimaSuscripcion       VARCHAR2(100) := 'FECHA_MINIMA_SUSCRIPCION';
    Lv_FechaActivacion              VARCHAR2(100) := 'FECHA_ACTIVACION';
    Lv_AccionHistorial              VARCHAR2(100) := 'confirmarServicio';
    Lv_AccionCancel                 VARCHAR2(100) := 'cancelarCliente';

    CURSOR Lc_GetInfoClienteXSpcSuscribId(Cn_IdSpcSuscriberId DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT%TYPE)
    IS
      SELECT DISTINCT SERVICIO.ID_SERVICIO, SERVICIO.ESTADO AS ESTADO_SERVICIO, PER.ID_PERSONA_ROL, PER.ESTADO AS ESTADO_PER, 
        PUNTO_FACTURACION.ID_PUNTO, PROD.NOMBRE_TECNICO AS NOMBRE_TECNICO_PROD
        FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC_SUSCRIBER_ID
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
        ON SERVICIO.ID_SERVICIO = SPC_SUSCRIBER_ID.SERVICIO_ID
        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD
        ON PROD.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO_FACTURACION
        ON PUNTO_FACTURACION.ID_PUNTO = SERVICIO.PUNTO_FACTURACION_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
        ON PER.ID_PERSONA_ROL = PUNTO_FACTURACION.PERSONA_EMPRESA_ROL_ID
       WHERE SPC_SUSCRIBER_ID.ID_SERVICIO_PROD_CARACT = Cn_IdSpcSuscriberId;

    CURSOR Lc_VerificacionesAutorizacion(   Cv_Valor1   VARCHAR2,
                                            Cv_Valor2   VARCHAR2,
                                            Cv_Valor3   VARCHAR2,
                                            Cv_Valor4   VARCHAR2)
    IS
      SELECT DET.ID_PARAMETRO_DET, DET.VALOR5, DET.VALOR6, DET.OBSERVACION
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
        ON DET.PARAMETRO_ID = CAB.ID_PARAMETRO
        WHERE CAB.NOMBRE_PARAMETRO = Lv_NombreParamsWsProductosTv
        AND DET.VALOR1 = Cv_Valor1
        AND DET.VALOR2 = Cv_Valor2
        AND DET.VALOR3 = Cv_Valor3
        AND DET.VALOR4 = Cv_Valor4
        AND CAB.ESTADO = Lv_Estado
        AND DET.ESTADO = Lv_Estado
        AND ROWNUM = 1;

    CURSOR Lc_GetInfoCicloFacturacion(Cn_IdPersonaEmpresaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
      SELECT TO_CHAR(CICLO_FACTURACION.FE_INICIO,'DD') AS DIA_INICIO_CICLO_FACTURACION,
        TO_CHAR(CICLO_FACTURACION.FE_FIN,'DD') AS DIA_FIN_CICLO_FACTURACION
        FROM DB_FINANCIERO.ADMI_CICLO CICLO_FACTURACION
        WHERE CICLO_FACTURACION.ID_CICLO  =
          (SELECT MAX(PER_CARACT.VALOR)
            FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC PER_CARACT
            INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACTERISTICA
            ON CARACTERISTICA.ID_CARACTERISTICA = PER_CARACT.CARACTERISTICA_ID 
          WHERE PER_CARACT.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaEmpresaRol
          AND PER_CARACT.ESTADO = Lv_Estado
          AND CARACTERISTICA.DESCRIPCION_CARACTERISTICA = Lv_CicloFacturacion
          );

    CURSOR Lc_GetFechaCarctServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, Cn_DescripCarac VARCHAR2)
    IS
        SELECT 
         TO_CHAR(TO_DATE(ISPC.VALOR, 'YYYY-MM-DD HH24:MI:SS'), 'DD') AS DIA_FECHA_CANCELACION,
         TO_CHAR(TO_DATE(ISPC.VALOR, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM') AS ANIO_MES_FECHA_CANCELACION,
         TO_CHAR(TO_DATE(ISPC.VALOR, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD') AS FECHA_COMPLETA
        FROM DB_COMERCIAL.admi_caracteristica AC
        LEFT JOIN DB_COMERCIAL.admi_producto_caracteristica APC ON apc.caracteristica_id = ac.id_caracteristica
        LEFT JOIN DB_COMERCIAL.info_servicio_prod_caract ISPC ON ispc.producto_caracterisitica_id = apc.id_producto_caracterisitica
        LEFT JOIN DB_COMERCIAL.info_servicio IS1 ON is1.id_servicio = ispc.servicio_id
        WHERE is1.estado= Lv_EstadoCancel
        and IS1.ID_SERVICIO = Cn_IdServicio
        AND ac.descripcion_caracteristica= Cn_DescripCarac;

    CURSOR Lc_GetFechaCancelacionServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
        SELECT 
            TO_CHAR(MAX(ish.fe_creacion),'DD') AS DIA_FECHA_CANCEL,
            TO_CHAR(MAX(ish.fe_creacion),'YYYY-MM') AS ANIO_MES_FECHA_CANCEL
        FROM  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
            JOIN  DB_COMERCIAL.INFO_SERVICIO ISER ON ISER.ID_SERVICIO = ISH.SERVICIO_ID
		    WHERE ISER.ID_SERVICIO = Cn_IdServicio
            AND   ISH.ACCION      = Lv_AccionCancel;

    Lr_GetInfoClienteXSpcSuscribId  Lc_GetInfoClienteXSpcSuscribId%ROWTYPE;
    Lr_VerificacionesAutorizacion   Lc_VerificacionesAutorizacion%ROWTYPE;
    Ln_SaldoPorPunto                DB_COMERCIAL.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE;
    Lr_GetInfoCicloFacturacion      Lc_GetInfoCicloFacturacion%ROWTYPE;
    Lr_GetFechaFinalCaractServicio  Lc_GetFechaCarctServicio%ROWTYPE;
    Lr_GetFechaActivacionServicio   Lc_GetFechaCarctServicio%ROWTYPE;
    Lr_GetFechaCancelServicioHist   Lc_GetFechaCancelacionServicio%ROWTYPE;
    Lv_DiaInicioCicloFacturacion    VARCHAR2(3);
    Lv_DiaFinCicloFacturacion       VARCHAR2(3);
    Lv_DiaFechaCancelacion          VARCHAR2(3);
    Lv_AnioMesFechaCancelacion      VARCHAR2(7);
    Lv_DiaFechaCancelHist           VARCHAR2(3);
    Lv_AnioMesFechaCancelHist       VARCHAR2(8);
    Lv_FechaFinSuscripcion          VARCHAR2(10);
    Lv_AnioMesDiaFechaActivacion    VARCHAR2(10);
    Lv_FechaInicioPeriodoPermitido  VARCHAR2(10);
    Lv_FechaFinPeriodoPermitido     VARCHAR2(10);
  BEGIN
  
    IF C_PARAMETROS%ISOPEN THEN
      CLOSE C_PARAMETROS;
    END IF;
    OPEN C_PARAMETROS(Pv_CountryCode, Lv_CodigoPais, Lv_Estado);
    FETCH C_PARAMETROS
      INTO Lv_EmpresaCod;
    IF C_PARAMETROS%NOTFOUND THEN
      Pv_CodigoSalida  := '02';
      Pv_MensajeSalida := 'Codigo de pais invalido';
      Raise Le_Error;
    END IF;
    CLOSE C_PARAMETROS;
  
    IF C_PARAMETROS%ISOPEN THEN
      CLOSE C_PARAMETROS;
    END IF;

    IF Pn_IdSpcSuscriber IS NOT NULL THEN
      IF Lc_GetInfoClienteXSpcSuscribId%ISOPEN THEN
        CLOSE Lc_GetInfoClienteXSpcSuscribId;
      END IF;
      OPEN Lc_GetInfoClienteXSpcSuscribId(Pn_IdSpcSuscriber);
      FETCH Lc_GetInfoClienteXSpcSuscribId
      INTO Lr_GetInfoClienteXSpcSuscribId;

      IF Lc_GetInfoClienteXSpcSuscribId%NOTFOUND THEN
        Pv_CodigoSalida  := '01';
        Pv_MensajeSalida := 'Usuario o Contrasena Incorrectos';
        Raise Le_Error;
      END IF;

      IF Lc_VerificacionesAutorizacion%ISOPEN THEN
        CLOSE Lc_VerificacionesAutorizacion;
      END IF;
      OPEN Lc_VerificacionesAutorizacion(   Lv_VerifAutorizacion,
                                            Lr_GetInfoClienteXSpcSuscribId.NOMBRE_TECNICO_PROD,
                                            Lv_EstadosServiciosPermitidos,
                                            Lr_GetInfoClienteXSpcSuscribId.ESTADO_SERVICIO);
      FETCH Lc_VerificacionesAutorizacion
      INTO Lr_VerificacionesAutorizacion;

      IF Lc_VerificacionesAutorizacion%NOTFOUND THEN
        Pv_CodigoSalida  := '01';
        Pv_MensajeSalida := 'No se puede acceder al servicio';
        Raise Le_Error;
      END IF;

      IF Lr_VerificacionesAutorizacion.VALOR5 = 'OK' THEN 
          Pv_CodigoSalida := 'OK';
      ELSIF Lr_VerificacionesAutorizacion.VALOR5 = 'ERROR' THEN
        Pv_CodigoSalida  := Lr_VerificacionesAutorizacion.VALOR6;
        Pv_MensajeSalida := Lr_VerificacionesAutorizacion.OBSERVACION;
        Raise Le_Error;
      ELSE
        Lr_VerificacionesAutorizacion := NULL;
        IF Lc_VerificacionesAutorizacion%ISOPEN THEN
          CLOSE Lc_VerificacionesAutorizacion;
        END IF;
        OPEN Lc_VerificacionesAutorizacion( Lv_VerifAutorizacion,
                                            Lr_GetInfoClienteXSpcSuscribId.NOMBRE_TECNICO_PROD,
                                            Lv_VerificaSaldoPendiente,
                                            Lr_GetInfoClienteXSpcSuscribId.ESTADO_SERVICIO);
        FETCH Lc_VerificacionesAutorizacion
        INTO Lr_VerificacionesAutorizacion;
        IF Lr_VerificacionesAutorizacion.ID_PARAMETRO_DET IS NOT NULL THEN
          Ln_SaldoPorPunto:=TRUNC(NVL(DB_FINANCIERO.FNCK_COM_ELECTRONICO.F_GET_SALDO_CLIENTE_BY_PUNTO(Lr_GetInfoClienteXSpcSuscribId.ID_PUNTO), 0),2);
          IF Ln_SaldoPorPunto > 0 THEN
            Pv_CodigoSalida  := Lr_VerificacionesAutorizacion.VALOR6;
            Pv_MensajeSalida := Lr_VerificacionesAutorizacion.OBSERVACION;
            Raise Le_Error;
          END IF;
        END IF;


        Lr_VerificacionesAutorizacion := NULL;
        IF Lc_VerificacionesAutorizacion%ISOPEN THEN
          CLOSE Lc_VerificacionesAutorizacion;
        END IF;
        OPEN Lc_VerificacionesAutorizacion( Lv_VerifAutorizacion,
                                            Lr_GetInfoClienteXSpcSuscribId.NOMBRE_TECNICO_PROD,
                                            Lv_VerificaFinCicloFacturacion,
                                            Lr_GetInfoClienteXSpcSuscribId.ESTADO_SERVICIO);
        FETCH Lc_VerificacionesAutorizacion
        INTO Lr_VerificacionesAutorizacion;
        IF Lr_VerificacionesAutorizacion.ID_PARAMETRO_DET IS NOT NULL THEN

          IF Lc_GetInfoCicloFacturacion%ISOPEN THEN
            CLOSE Lc_GetInfoCicloFacturacion;
          END IF;
          OPEN Lc_GetInfoCicloFacturacion(Lr_GetInfoClienteXSpcSuscribId.ID_PERSONA_ROL);
          FETCH Lc_GetInfoCicloFacturacion
          INTO Lr_GetInfoCicloFacturacion;

          IF Lc_GetInfoCicloFacturacion%NOTFOUND THEN
            Pv_CodigoSalida  := '01';
            Pv_MensajeSalida := 'No se puede validar el acceso al servicio';
            Raise Le_Error;
          END IF;

          IF Lc_GetFechaCarctServicio%ISOPEN THEN
            CLOSE Lc_GetFechaCarctServicio;
          END IF;
          OPEN Lc_GetFechaCarctServicio(Lr_GetInfoClienteXSpcSuscribId.ID_SERVICIO, Lv_FechaMinimaSuscripcion);
          FETCH Lc_GetFechaCarctServicio
          INTO Lr_GetFechaFinalCaractServicio;

          IF Lc_GetFechaCarctServicio%NOTFOUND THEN
            Pv_CodigoSalida  := '01';
            Pv_MensajeSalida := 'No se puede validar la fecha de cancelaci贸n del servicio';
            Raise Le_Error;
          END IF;

          Lv_DiaInicioCicloFacturacion  := Lr_GetInfoCicloFacturacion.DIA_INICIO_CICLO_FACTURACION;
          Lv_DiaFinCicloFacturacion     := Lr_GetInfoCicloFacturacion.DIA_FIN_CICLO_FACTURACION;
          
          Lv_DiaFechaCancelacion        := Lr_GetFechaFinalCaractServicio.DIA_FECHA_CANCELACION;
          Lv_AnioMesFechaCancelacion    := Lr_GetFechaFinalCaractServicio.ANIO_MES_FECHA_CANCELACION;
          Lv_FechaFinSuscripcion        := Lr_GetFechaFinalCaractServicio.FECHA_COMPLETA;
          
          IF Lc_GetFechaCarctServicio%ISOPEN THEN
            CLOSE Lc_GetFechaCarctServicio;
          END IF;
          OPEN Lc_GetFechaCarctServicio(Lr_GetInfoClienteXSpcSuscribId.ID_SERVICIO, Lv_FechaActivacion);
          FETCH Lc_GetFechaCarctServicio
          INTO Lr_GetFechaActivacionServicio;

          IF Lc_GetFechaCarctServicio%NOTFOUND THEN
            Pv_CodigoSalida  := '01';
            Pv_MensajeSalida := 'No se puede validar la fecha de activaci贸n del servicio';
            Raise Le_Error;
          END IF;
          
          Lv_AnioMesDiaFechaActivacion  := Lr_GetFechaActivacionServicio.FECHA_COMPLETA;
          
          IF Lc_GetFechaCancelacionServicio%ISOPEN THEN
            CLOSE Lc_GetFechaCancelacionServicio;
          END IF;
          OPEN Lc_GetFechaCancelacionServicio(Lr_GetInfoClienteXSpcSuscribId.ID_SERVICIO);
          FETCH Lc_GetFechaCancelacionServicio
          INTO Lr_GetFechaCancelServicioHist;
          
          Lv_DiaFechaCancelHist        := Lr_GetFechaCancelServicioHist.DIA_FECHA_CANCEL;
          Lv_AnioMesFechaCancelHist    := Lr_GetFechaCancelServicioHist.ANIO_MES_FECHA_CANCEL;
          
          
          IF TRUNC(SYSDATE) < TO_DATE(Lv_FechaFinSuscripcion, 'YYYY-MM-DD') THEN
              IF TO_NUMBER(Lv_DiaInicioCicloFacturacion,'99999999990D99') <= TO_NUMBER(Lv_DiaFechaCancelacion,'99999999990D99') THEN
                Lv_FechaInicioPeriodoPermitido := Lv_AnioMesFechaCancelacion || '-' || Lv_DiaInicioCicloFacturacion;
              ELSE
                Lv_FechaInicioPeriodoPermitido := TO_CHAR(ADD_MONTHS(TO_DATE(Lv_AnioMesFechaCancelacion,'YYYY-MM'),-1),'YYYY-MM')
                                                  || '-' || Lv_DiaInicioCicloFacturacion;
              END IF;
          ELSE
              IF TO_NUMBER(Lv_DiaInicioCicloFacturacion,'99999999990D99') <= TO_NUMBER(Lv_DiaFechaCancelHist,'99999999990D99') THEN
                Lv_FechaInicioPeriodoPermitido := Lv_AnioMesFechaCancelHist || '-' || Lv_DiaInicioCicloFacturacion;
              ELSE
                Lv_FechaInicioPeriodoPermitido := TO_CHAR(ADD_MONTHS(TO_DATE(Lv_AnioMesFechaCancelHist,'YYYY-MM'),-1),'YYYY-MM')
                                                  || '-' || Lv_DiaInicioCicloFacturacion;
              END IF;
          
          END IF;
          Lv_FechaFinPeriodoPermitido := TO_CHAR(ADD_MONTHS(TO_DATE(Lv_FechaInicioPeriodoPermitido,'YYYY-MM-DD'),+1)-1,'YYYY-MM-DD');

          IF TRUNC(SYSDATE) BETWEEN TO_DATE(Lv_AnioMesDiaFechaActivacion, 'YYYY-MM-DD') AND TO_DATE(Lv_FechaFinPeriodoPermitido, 'YYYY-MM-DD') THEN
            Pv_CodigoSalida := 'OK';
          ELSE
            Pv_CodigoSalida  := Lr_VerificacionesAutorizacion.VALOR6;
            Pv_MensajeSalida := Lr_VerificacionesAutorizacion.OBSERVACION;
            Raise Le_Error;
          END IF;
        END IF;
      END IF;
    ELSE
      OPEN C_PARAMETROS(Pv_CodigoUrn, Lv_CodigoUrn, Lv_Estado);
      FETCH C_PARAMETROS
        INTO Lv_EmpresaUrn;
      IF C_PARAMETROS%NOTFOUND THEN
        Pv_CodigoSalida  := '03';
        Pv_MensajeSalida := 'Codigo de canal invalido';
        Raise Le_Error;
      END IF;
      CLOSE C_PARAMETROS;
  
      IF C_CARACTERISTICA%ISOPEN THEN
        CLOSE C_CARACTERISTICA;
      END IF;
  
      OPEN C_CARACTERISTICA(Pv_SubscriberId, Lv_CodigoSsIdFox, Lv_Estado);
      FETCH C_CARACTERISTICA
        INTO Ln_IdServicio;
      IF C_CARACTERISTICA%NOTFOUND THEN
        Pv_CodigoSalida  := '01';
        Pv_MensajeSalida := 'Usuario o Contrasena Incorrectos';
      ELSE
        IF C_SERVICIO%ISOPEN THEN
          CLOSE C_SERVICIO;
        END IF;
    
        OPEN C_SERVICIO(Ln_IdServicio, Lv_Estado);
        FETCH C_SERVICIO
          INTO Lv_Existe;
        IF C_SERVICIO%NOTFOUND THEN
          Pv_CodigoSalida  := '01';
          Pv_MensajeSalida := 'No se puede acceder al servicio porque el Internet esta In-Corte';
          Raise Le_Error;
        ELSE
          IF NVL(Lv_Existe, '@') = 'X' THEN
            Pv_CodigoSalida := 'OK';
          ELSE
            Pv_CodigoSalida  := '01';
            Pv_MensajeSalida := 'Usuario o Contrasena Incorrectos';
            Raise Le_Error;
          END IF;
        END IF;
        CLOSE C_SERVICIO;
      END IF;
      CLOSE C_CARACTERISTICA;
    END IF;
  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_VALIDA_CARACTERISTICA',
                                           Pv_MensajeSalida,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeSalida := 'Error';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_VALIDA_CARACTERISTICA',
                                           'Error al consultar persona por login e identifiacion: ',
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
  END P_VERIFICA_ESTADO_SERVICIO;

  PROCEDURE P_GET_SERVICIOS_POR_RECHAZAR(
                                          Pv_CodigoEmpresa        IN VARCHAR2,
                                          Pv_EstadoActualServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                          Pn_DiasRechazo          IN NUMBER,
                                          Pn_TotalRegistros       OUT NUMBER,
                                          Prf_Servicios           OUT SYS_REFCURSOR,
                                          Pv_Status               OUT VARCHAR2,
                                          Pv_MensajeError         OUT VARCHAR2)
  AS
    Lv_SelectPrincipal VARCHAR2(4000);
    Lv_SelectCountPrincipal VARCHAR2(4000);
    Lv_Select VARCHAR2(4000);
    Lcl_ConsultaPrincipal CLOB;
    Lcl_ConsultaCountPrincipal CLOB;
    Lv_FromJoin VARCHAR2(4000);
    Lv_Where VARCHAR2(4000);
    Lv_WherePrincipal VARCHAR2(4000);
    Lv_GrupoDatacenter VARCHAR2(10) := 'DATACENTER';
    Lv_EstadoEliminado VARCHAR2(9) := 'Eliminado';
    Lv_AccionSeguimiento VARCHAR2(11) := 'Seguimiento';
    Lv_DescripcionSolicitud VARCHAR2(23) := 'SOLICITUD PLANIFICACION';
    Lt_ArrayParamsBind CMKG_TYPES.Lt_ArrayAsociativo;
    Lv_NombreParamBind VARCHAR2(30);
    Ln_IdCursor NUMBER;
    Ln_NumExecPrincipal NUMBER;
    Ln_IdCursorCount NUMBER;
    Ln_NumExecCount NUMBER;
    Lrf_ConsultaCount SYS_REFCURSOR;
  
    BEGIN
      Pn_TotalRegistros       := 0;
      Lv_SelectCountPrincipal := 'SELECT COUNT(DISTINCT ID_SERVICIO) AS TOTAL_REGISTROS ';
      Lv_SelectPrincipal      := 'SELECT DISTINCT SERVICIOS.ID_SERVICIO,
                                  SERVICIOS.ID_SERVICIO_TECNICO,
                                  SERVICIOS.INTERFACE_ELEMENTO_CONECTOR_ID,
                                  SERVICIOS.EMPRESA_COD,
                                  SERVICIOS.JURISDICCION,
                                  SERVICIOS.CIUDAD,
                                  SERVICIOS.CODIGO_TIPO_MEDIO,
                                  SERVICIOS.USR_VENDEDOR,
                                  SERVICIOS.VENDEDOR,
                                  SERVICIOS.CLIENTE,
                                  SERVICIOS.LOGIN,
                                  SERVICIOS.ID_PRODUCTO,
                                  SERVICIOS.NOMBRE_PRODUCTO,
                                  SERVICIOS.NOMBRE_TECNICO_PRODUCTO,
                                  SERVICIOS.PRODUCTO_ES_CONCENTRADOR,
                                  SERVICIOS.ID_DETALLE_SOLICITUD,
                                  TO_CHAR(SERVICIOS.FECHA_DETENIDO, ''DD/MM/YYYY HH24:MI:SS'') AS FECHA_DETENIDO,
                                  ROUND((SYSDATE -TRUNC(SERVICIOS.FECHA_DETENIDO)),2)        AS DIAS_DETENIDO ';
  
      Lv_Select               := 'SELECT SERVICIO.ID_SERVICIO,
                                  SERVICIO_TECNICO.ID_SERVICIO_TECNICO,
                                  SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID,
                                  ER.EMPRESA_COD,
                                  JURISDICCION.NOMBRE_JURISDICCION AS JURISDICCION,
                                  DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(CANTON.NOMBRE_CANTON) AS CIUDAD,
                                  MEDIO.CODIGO_TIPO_MEDIO,
                                  SERVICIO.USR_VENDEDOR,
                                  (SELECT CONCAT(CONCAT (NVL(PERSONA_VENDEDOR.NOMBRES, ''''),'' ''), NVL(PERSONA_VENDEDOR.APELLIDOS, ''''))
                                   FROM DB_COMERCIAL.INFO_PERSONA PERSONA_VENDEDOR
                                   WHERE PERSONA_VENDEDOR.LOGIN = SERVICIO.USR_VENDEDOR
                                   AND PERSONA_VENDEDOR.ESTADO <> :Lv_EstadoEliminado
                                   AND ROWNUM = 1) AS VENDEDOR,
                                  CASE
                                    WHEN PERSONA.RAZON_SOCIAL IS NOT NULL
                                    THEN DB_COMERCIAL.CMKG_REPORTE_COMERCIAL.F_GET_VARCHAR_CLEAN(PERSONA.RAZON_SOCIAL)
                                    ELSE CONCAT(CONCAT (NVL(PERSONA.NOMBRES, ''''),'' ''), NVL(PERSONA.APELLIDOS, ''''))
                                  END         AS CLIENTE,
                                  PUNTO.LOGIN AS LOGIN,
                                  PRODUCTO.ID_PRODUCTO AS ID_PRODUCTO,
                                  PRODUCTO.DESCRIPCION_PRODUCTO AS NOMBRE_PRODUCTO,
                                  PRODUCTO.NOMBRE_TECNICO AS NOMBRE_TECNICO_PRODUCTO,
                                  PRODUCTO.ES_CONCENTRADOR AS PRODUCTO_ES_CONCENTRADOR,
                                  SOLICITUD.ID_DETALLE_SOLICITUD,
                                  (SELECT MAX(SERVICIO_HISTORIAL.FE_CREACION)
                                  FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SERVICIO_HISTORIAL
                                  WHERE SERVICIO_HISTORIAL.SERVICIO_ID=SERVICIO.ID_SERVICIO
                                  AND SERVICIO_HISTORIAL.ESTADO       = :Pv_EstadoActualServicio
                                  AND NVL(SERVICIO_HISTORIAL.ACCION, '' '') != :Lv_AccionSeguimiento
                                  )                             AS FECHA_DETENIDO ';
  
      Lv_FromJoin             := 'FROM DB_COMERCIAL.INFO_PUNTO PUNTO
                                  INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PER
                                  ON PUNTO.PERSONA_EMPRESA_ROL_ID=PER.ID_PERSONA_ROL
                                  INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ER
                                  ON ER.ID_EMPRESA_ROL = PER.EMPRESA_ROL_ID
                                  INNER JOIN DB_COMERCIAL.INFO_PERSONA PERSONA
                                  ON PER.PERSONA_ID =PERSONA.ID_PERSONA
                                  INNER JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JURISDICCION
                                  ON PUNTO.PUNTO_COBERTURA_ID =JURISDICCION.ID_JURISDICCION
                                  INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
                                  ON PUNTO.ID_PUNTO =SERVICIO.PUNTO_ID
                                  INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO SERVICIO_TECNICO
                                  ON SERVICIO_TECNICO.SERVICIO_ID = SERVICIO.ID_SERVICIO
                                  INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO MEDIO
                                  ON MEDIO.ID_TIPO_MEDIO = SERVICIO_TECNICO.ULTIMA_MILLA_ID
                                  INNER JOIN DB_GENERAL.ADMI_SECTOR SECTOR
                                  ON SECTOR.ID_SECTOR = PUNTO.SECTOR_ID
                                  INNER JOIN DB_GENERAL.ADMI_PARROQUIA PARROQUIA
                                  ON PARROQUIA.ID_PARROQUIA = SECTOR.PARROQUIA_ID
                                  INNER JOIN DB_GENERAL.ADMI_CANTON CANTON
                                  ON CANTON.ID_CANTON = PARROQUIA.CANTON_ID
                                  INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD
                                  ON SOLICITUD.SERVICIO_ID = SERVICIO.ID_SERVICIO
                                  INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOLICITUD
                                  ON TIPO_SOLICITUD.ID_TIPO_SOLICITUD = SOLICITUD.TIPO_SOLICITUD_ID
                                  INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
                                  ON PRODUCTO.ID_PRODUCTO                  = SERVICIO.PRODUCTO_ID ';
  
      Lv_Where                := 'WHERE SERVICIO.ESTADO                    = :Pv_EstadoActualServicio
                                  AND SOLICITUD.SERVICIO_ID                = SERVICIO.ID_SERVICIO
                                  AND SOLICITUD.ESTADO                     = :Pv_EstadoActualServicio
                                  AND TIPO_SOLICITUD.DESCRIPCION_SOLICITUD = :Lv_DescripcionSolicitud
                                  AND ER.EMPRESA_COD                       = :Pv_CodigoEmpresa 
                                  AND PRODUCTO.GRUPO                       <> :Lv_GrupoDatacenter ';
      Lv_WherePrincipal       := 'WHERE SERVICIOS_REPORTE.DIAS_DETENIDO >= :Fn_DiasLiberaFactib ';
  
      Lt_ArrayParamsBind('Lv_EstadoEliminado')        := Lv_EstadoEliminado;
      Lt_ArrayParamsBind('Pv_EstadoActualServicio')   := Pv_EstadoActualServicio;
      Lt_ArrayParamsBind('Lv_AccionSeguimiento')      := Lv_AccionSeguimiento;
      Lt_ArrayParamsBind('Lv_DescripcionSolicitud')   := Lv_DescripcionSolicitud;
      Lt_ArrayParamsBind('Pv_CodigoEmpresa')          := Pv_CodigoEmpresa;
      Lt_ArrayParamsBind('Lv_GrupoDatacenter')        := Lv_GrupoDatacenter;
      Lt_ArrayParamsBind('Fn_DiasLiberaFactib')       := Pn_DiasRechazo;
  
  
      Lcl_ConsultaPrincipal := 'SELECT SERVICIOS_REPORTE.*, ROUND(SERVICIOS_REPORTE.DIAS_DETENIDO) AS DIAS_DETENIDO_REPORTE FROM ( ' ||
                                Lv_SelectPrincipal || ' FROM (' || Lv_Select || Lv_FromJoin || Lv_Where || ') SERVICIOS ) SERVICIOS_REPORTE ' || 
                                Lv_WherePrincipal;
      Lcl_ConsultaCountPrincipal := Lv_SelectCountPrincipal || ' FROM (' || Lcl_ConsultaPrincipal || ') ';
      Ln_IdCursorCount := DBMS_SQL.OPEN_CURSOR();
      DBMS_SQL.PARSE(Ln_IdCursorCount, Lcl_ConsultaCountPrincipal, DBMS_SQL.NATIVE);
      Lv_NombreParamBind := Lt_ArrayParamsBind.FIRST;
      WHILE (Lv_NombreParamBind IS NOT NULL) LOOP
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursorCount, Lv_NombreParamBind, Lt_ArrayParamsBind(Lv_NombreParamBind));
        Lv_NombreParamBind := Lt_ArrayParamsBind.NEXT(Lv_NombreParamBind);
      END LOOP;
      Ln_NumExecCount := DBMS_SQL.EXECUTE(Ln_IdCursorCount);
      Lrf_ConsultaCount := DBMS_SQL.TO_REFCURSOR(Ln_IdCursorCount);
      FETCH Lrf_ConsultaCount INTO Pn_TotalRegistros;
  
      Ln_IdCursor := DBMS_SQL.OPEN_CURSOR();
      DBMS_SQL.PARSE(Ln_IdCursor, Lcl_ConsultaPrincipal, DBMS_SQL.NATIVE);
      Lv_NombreParamBind := Lt_ArrayParamsBind.FIRST;
      WHILE (Lv_NombreParamBind IS NOT NULL) LOOP
        DBMS_SQL.BIND_VARIABLE(Ln_IdCursor, Lv_NombreParamBind, Lt_ArrayParamsBind(Lv_NombreParamBind));
        Lv_NombreParamBind := Lt_ArrayParamsBind.NEXT(Lv_NombreParamBind);
      END LOOP;
      Ln_NumExecPrincipal     := DBMS_SQL.EXECUTE(Ln_IdCursor);
      Prf_Servicios           := DBMS_SQL.TO_REFCURSOR(Ln_IdCursor);
      Pv_Status               := 'OK';
    EXCEPTION
    WHEN OTHERS THEN
      --
      Pn_TotalRegistros         := 0;
      Prf_Servicios             := NULL;
      Pv_Status                 := 'ERROR';
      Pv_MensajeError           := 'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: ' 
                                    || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'COMEK_CONSULTAS.P_GET_SERVICIOS_POR_RECHAZAR', 
                                            Pv_MensajeError,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_GET_SERVICIOS_POR_RECHAZAR;

  FUNCTION F_GET_DESCRIPCION_PRODUCTO(Fn_idPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    RETURN VARCHAR2 
  IS
    CURSOR C_getDescripcionProducto(Cn_idPlan NUMBER) 
    IS
      SELECT cap.descripcion_producto 
      FROM db_comercial.admi_producto cap,
        db_comercial.info_plan_det ipd
      WHERE cap.codigo_producto = 'INTD'
      AND cap.id_producto       = ipd.producto_id
      AND ipd.plan_id           = Cn_idPlan
      AND ipd.estado            = 'Activo'
      AND cap.Estado            = 'Activo';
    
    Lv_DescripcionProducto DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE := '';
     
  BEGIN
      
    IF C_getDescripcionProducto%ISOPEN THEN
      CLOSE C_getDescripcionProducto;
    END IF;
        
    OPEN  C_getDescripcionProducto(Fn_idPlan);
    FETCH C_getDescripcionProducto INTO Lv_DescripcionProducto;
    CLOSE C_getDescripcionProducto;
    
    RETURN Lv_DescripcionProducto;

  END F_GET_DESCRIPCION_PRODUCTO;

  FUNCTION F_GET_VALOR_PLAN(Fn_idPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    RETURN NUMBER 
  IS
    CURSOR C_getValorPlan(Cn_idPlan NUMBER) 
    IS
      SELECT SUM(ipd.CANTIDAD_DETALLE*ipd.PRECIO_ITEM) VALOR_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB  IPC,
        DB_COMERCIAL.INFO_PLAN_DET  IPD 
      WHERE IPD.PLAN_ID   = IPC.ID_PLAN
      AND IPC.ID_PLAN     = Cn_idPlan
      AND IPC.EMPRESA_COD = '18'
      AND IPC.ESTADO      = 'Activo'
      AND IPD.ESTADO      = 'Activo';
    
    Ln_ValorPlan DB_COMERCIAL.INFO_PLAN_DET.PRECIO_ITEM%TYPE := 0;
     
  BEGIN
      
    IF C_getValorPlan%ISOPEN THEN
      CLOSE C_getValorPlan;
    END IF;
        
    OPEN  C_getValorPlan(Fn_idPlan);
    FETCH C_getValorPlan INTO Ln_ValorPlan;
    CLOSE C_getValorPlan;
    
    RETURN Ln_ValorPlan;

  END F_GET_VALOR_PLAN;

  PROCEDURE P_SERVICIOS_MCAFEE_ERROR
    AS
      CURSOR C_GetRegistros(Pv_DescCaract VARCHAR2,Pv_EstadoActivo VARCHAR2, Pv_BusquedaProductos VARCHAR2)
      IS
        SELECT INFO_PUNTO.LOGIN           AS login,
          INFO_SERVICIO_PROD_CARACT.VALOR AS valor
        FROM DB_COMERCIAL.INFO_PUNTO,
          DB_COMERCIAL.INFO_SERVICIO,
          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT,
          DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA,
          DB_COMERCIAL.ADMI_CARACTERISTICA ,
          DB_COMERCIAL.ADMI_PRODUCTO
        WHERE INFO_PUNTO.ID_PUNTO                                 = INFO_SERVICIO.PUNTO_ID
        AND INFO_SERVICIO.ID_SERVICIO                             = INFO_SERVICIO_PROD_CARACT.SERVICIO_ID
        AND INFO_SERVICIO_PROD_CARACT.PRODUCTO_CARACTERISITICA_ID = ADMI_PRODUCTO_CARACTERISTICA.ID_PRODUCTO_CARACTERISITICA
        AND ADMI_PRODUCTO_CARACTERISTICA.CARACTERISTICA_ID        = ADMI_CARACTERISTICA.ID_CARACTERISTICA
        AND ADMI_PRODUCTO_CARACTERISTICA.PRODUCTO_ID              = ADMI_PRODUCTO.ID_PRODUCTO
        AND ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA        = Pv_DescCaract
        AND INFO_SERVICIO_PROD_CARACT.ESTADO                      = Pv_EstadoActivo
        AND INFO_SERVICIO_PROD_CARACT.FE_CREACION                >= to_date(TO_CHAR(sysdate, 'dd/mm/yyyy'), 'dd/mm/yyyy')
        AND ADMI_PRODUCTO.DESCRIPCION_PRODUCTO LIKE Pv_BusquedaProductos
        AND INFO_SERVICIO_PROD_CARACT.VALOR IS NOT NULL;
      Lv_MensajeError       VARCHAR2(4000);
      Lv_SuscripcionesError VARCHAR2(4000);
      Lv_Remitente          VARCHAR2(50)   := 'notificaciones_telcos@telconet.ec';
      Lv_Asunto             VARCHAR2(300)  := 'Clientes con errores en cancelaci贸n de suscripciones MCAFEE por migraci贸n de tecnolog铆a';
      Lv_BusquedaProductos  VARCHAR2(10)   := 'I. %';
      Lv_DescCaract         VARCHAR2(20)   := 'ERROR_CANCELACION';
      Lv_EstadoActivo       VARCHAR2(10)   := 'Activo';
      Iv_contador           NUMBER         := 0;
      Lcl_PlantillaReporte CLOB;
      Lr_GetAliasPlantillaGeneral DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    BEGIN
      Lr_GetAliasPlantillaGeneral := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('MCAFEE_ERROR_CA');
      Lcl_PlantillaReporte        := Lr_GetAliasPlantillaGeneral.PLANTILLA;
      FOR I_GetRegistros IN C_GetRegistros(Lv_DescCaract, Lv_EstadoActivo,Lv_BusquedaProductos)
      LOOP
        Iv_contador           := Iv_contador +1;
        Lv_SuscripcionesError := Lv_SuscripcionesError||'<tr><td>'|| Iv_contador ||'</td><td>'|| I_GetRegistros.login ||'</td><td>'|| I_GetRegistros.valor||'</td></tr>';
      END LOOP;
      Lcl_PlantillaReporte                         := REPLACE(Lcl_PlantillaReporte,'{{ registrosSuscripciones }}', Lv_SuscripcionesError);
      IF Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS IS NOT NULL THEN
        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS  := REPLACE(Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, ';', ',') || ',';
      ELSE
        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS := Lv_Remitente;
      END IF;
      --Se verifica que existan servicios por liberarse por empresa
      --Env铆o de correo al vendedor
      IF Lv_SuscripcionesError IS NOT NULL THEN
        DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL( Lv_Remitente, Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, Lv_Asunto, SUBSTR(Lcl_PlantillaReporte, 1, 32767), 'text/html; charset=UTF-8', Lv_MensajeError);
        IF Lv_MensajeError IS NOT NULL THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'P_SERVICIOS_MCAFEE_ERROR', Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
          Lv_MensajeError := '';
        END IF;
      END IF;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'P_SERVICIOS_MCAFEE_ERROR', Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
  END P_SERVICIOS_MCAFEE_ERROR;

  PROCEDURE P_SERVICIOS_KASPERSKY_ERROR
    AS
      CURSOR C_GetRegistros(Pv_DescCaract VARCHAR2,Pv_EstadoActivo VARCHAR2, Pv_BusquedaProductos VARCHAR2)
      IS
        SELECT INFO_PUNTO.LOGIN           AS login,
          INFO_SERVICIO_PROD_CARACT.VALOR AS valor
        FROM DB_COMERCIAL.INFO_PUNTO,
          DB_COMERCIAL.INFO_SERVICIO,
          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT,
          DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA,
          DB_COMERCIAL.ADMI_CARACTERISTICA ,
          DB_COMERCIAL.ADMI_PRODUCTO
        WHERE INFO_PUNTO.ID_PUNTO                                 = INFO_SERVICIO.PUNTO_ID
        AND INFO_SERVICIO.ID_SERVICIO                             = INFO_SERVICIO_PROD_CARACT.SERVICIO_ID
        AND INFO_SERVICIO_PROD_CARACT.PRODUCTO_CARACTERISITICA_ID = ADMI_PRODUCTO_CARACTERISTICA.ID_PRODUCTO_CARACTERISITICA
        AND ADMI_PRODUCTO_CARACTERISTICA.CARACTERISTICA_ID        = ADMI_CARACTERISTICA.ID_CARACTERISTICA
        AND ADMI_PRODUCTO_CARACTERISTICA.PRODUCTO_ID              = ADMI_PRODUCTO.ID_PRODUCTO
        AND ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA        = Pv_DescCaract
        AND INFO_SERVICIO_PROD_CARACT.ESTADO                      = Pv_EstadoActivo
        AND INFO_SERVICIO_PROD_CARACT.FE_CREACION                >= to_date(TO_CHAR(sysdate, 'dd/mm/yyyy'), 'dd/mm/yyyy')
        AND ADMI_PRODUCTO.DESCRIPCION_PRODUCTO = Pv_BusquedaProductos
        AND INFO_SERVICIO_PROD_CARACT.VALOR IS NOT NULL;
      Lv_MensajeError       VARCHAR2(4000);
      Lv_SuscripcionesError VARCHAR2(4000);
      Lv_Remitente          VARCHAR2(50)   := 'notificaciones_telcos@telconet.ec';
      Lv_Asunto             VARCHAR2(300)  := 'Clientes con errores en cancelaci贸n de suscripciones KASPERSKY';
      Lv_BusquedaProductos  VARCHAR2(10)   := 'I. PROTEGIDO MULTI PAID';
      Lv_DescCaract         VARCHAR2(37)   := 'ERROR_CANCELACION_INTERNET_PROTEGIDO';
      Lv_EstadoActivo       VARCHAR2(10)   := 'Activo';
      Iv_contador           NUMBER         := 0;
      Lcl_PlantillaReporte CLOB;
      Lr_GetAliasPlantillaGeneral DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    BEGIN
      Lr_GetAliasPlantillaGeneral := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('ERRORCANMASIPMP');
      Lcl_PlantillaReporte        := Lr_GetAliasPlantillaGeneral.PLANTILLA;
      FOR I_GetRegistros IN C_GetRegistros(Lv_DescCaract, Lv_EstadoActivo,Lv_BusquedaProductos)
      LOOP
        Iv_contador           := Iv_contador +1;
        Lv_SuscripcionesError := Lv_SuscripcionesError||'<tr><td>'|| Iv_contador ||'</td><td>'|| I_GetRegistros.login ||'</td><td>'
                                 || I_GetRegistros.valor||'</td></tr>';
      END LOOP;
      Lcl_PlantillaReporte                         := REPLACE(Lcl_PlantillaReporte,'{{ registrosSuscripciones }}', Lv_SuscripcionesError);
      IF Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS IS NOT NULL THEN
        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS  := REPLACE(Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, ';', ',') || ',';
      ELSE
        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS := Lv_Remitente;
      END IF;
      --Se verifica que existan servicios por liberarse por empresa
      --Env铆o de correo al vendedor
      IF Lv_SuscripcionesError IS NOT NULL THEN
        DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL(  Lv_Remitente, 
                                                        Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, 
                                                        Lv_Asunto, 
                                                        SUBSTR(Lcl_PlantillaReporte, 1, 32767), 
                                                        'text/html; charset=UTF-8', 
                                                        Lv_MensajeError);
        IF Lv_MensajeError IS NOT NULL THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                'P_SERVICIOS_KASPERSKY_ERROR', 
                                                Lv_MensajeError, 
                                                NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                                SYSDATE, 
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
          Lv_MensajeError := '';
        END IF;
      END IF;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'P_SERVICIOS_KASPERSKY_ERROR', 
                                            Lv_MensajeError, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
  END P_SERVICIOS_KASPERSKY_ERROR;

FUNCTION F_GET_FORMAS_CONTACTO_BY_PUNTO(
    Fn_IdPunto        IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_TipoData       IN ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_DatoContacto(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_TipoData ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  IS
  WITH FORMA_CONTACTO_MAIL AS
  (
  --
  SELECT LISTAGG(AFC.DESCRIPCION_FORMA_CONTACTO||':'||REPLACE(REPLACE(
    REGEXP_REPLACE(NVL2(IPFC.VALOR, IPFC.VALOR, NULL), '[^[:digit:]|;]', '')
    , '  ', ''), ' ', ''), ';') 
  WITHIN GROUP (
  ORDER BY NVL2(IPFC.VALOR, IPFC.VALOR, NULL)
  ) CONTACTO
  FROM DB_COMERCIAL.INFO_PUNTO IP,
    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
    DB_COMERCIAL.INFO_PERSONA IPR,
    DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC,
    DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
  WHERE IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
  AND IPER.PERSONA_ID             = IPR.ID_PERSONA
  AND IPR.ID_PERSONA              = IPFC.PERSONA_ID
  AND IPFC.FORMA_CONTACTO_ID      = AFC.ID_FORMA_CONTACTO
  AND IPFC.ESTADO                 = 'Activo'
  AND AFC.ESTADO                  = 'Activo'
  AND (IP.ESTADO                  = 'Activo'
  OR   IP.ESTADO                  = 'In-Corte'
  OR   IP.ESTADO                  = 'Pendiente')
  AND AFC.CODIGO                 IN
    (SELECT CODIGO
    FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO
    WHERE DESCRIPCION_FORMA_CONTACTO LIKE
      CASE Cv_TipoData
        WHEN 'MAIL'
        THEN 'Correo%'
        WHEN 'FONO'
        THEN 'Telefono%'
        WHEN 'MOVIL'
        THEN '%Movil%'
        ELSE 'Telefono%'
      END
    )
  AND IP.ID_PUNTO = Cn_IdPunto
  UNION
  SELECT AFC.DESCRIPCION_FORMA_CONTACTO||':'||REPLACE(REPLACE(
    REGEXP_REPLACE(NVL2(IPFC.VALOR, IPFC.VALOR, NULL), '[^[:digit:]|;]', '')
  , '  ', ''), ' ', '') CONTACTO
  FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO IPFC,
    DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC,
    DB_COMERCIAL.INFO_PUNTO IP
  WHERE 
  IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
  AND IPFC.PUNTO_ID      = IP.ID_PUNTO
  AND AFC.CODIGO  IN
    (SELECT CODIGO
    FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO
    WHERE DESCRIPCION_FORMA_CONTACTO LIKE
      CASE Cv_TipoData
        WHEN 'MAIL'
        THEN 'Correo%'
        WHEN 'FONO'
        THEN 'Telefono%'
        WHEN 'MOVIL'
        THEN '%Movil%'
        ELSE 'Telefono%'
      END
    )
  AND IPFC.ESTADO   = 'Activo'
  AND AFC.ESTADO    = 'Activo'
  AND (IP.ESTADO    = 'Activo'
  OR  IP.ESTADO     = 'In-Corte')
  AND IPFC.PUNTO_ID = Cn_IdPunto
    )
  SELECT LISTAGG(CONTACTO, ';') WITHIN GROUP (
  ORDER BY CONTACTO) CONTACTO
  FROM FORMA_CONTACTO_MAIL;
      --
      Lv_Data VARCHAR2(4000);
      --
    BEGIN
        --
        --
        IF C_DatoContacto%ISOPEN THEN
          --
          CLOSE C_DatoContacto;
          --
        END IF;
        --
        OPEN C_DatoContacto(Fn_IdPunto, Fv_TipoData);
        --
        FETCH C_DatoContacto INTO Lv_Data;
        --
        CLOSE C_DatoContacto;
        --
      --
      IF Fv_TipoData = 'MAIL' THEN
        Lv_Data := REPLACE(REPLACE(REPLACE(Lv_Data, Chr(9), ''), Chr(10), ''), Chr(13), '');
        --
      END IF;
      --
      RETURN Lv_Data;
      --
    EXCEPTION
    WHEN OTHERS THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'COMEK_CONSULTAS.F_GET_FORMAS_CONTACTO_BY_PUNTO', 
                                            SQLERRM, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    END F_GET_FORMAS_CONTACTO_BY_PUNTO;



  PROCEDURE P_GET_PUNTOS_BY_FORMA_CONTAC(Pv_CodEmpresa       IN VARCHAR2,
                                         Pv_Valor            IN VARCHAR2,
                                         Pv_Tipo             IN VARCHAR2,
                                         Pv_MensajeRespuesta OUT VARCHAR2,
                                         Pr_Informacion      OUT SYS_REFCURSOR) IS
    --
    Lv_Query             CLOB;
    Lv_QueryPersona      CLOB;
    Lv_QueryPunto        CLOB;
    Lv_TipoFormaContacto VARCHAR2(100);
    Le_Exception         EXCEPTION;
    Lv_MensajeError      VARCHAR2(4000);
    Lv_EstadoActivo      VARCHAR2(15) := 'Activo';
    Lv_EstadoInCorte     VARCHAR2(15) := 'In-Corte';
    Lv_EstadoPendiente   VARCHAR2(15) := 'Pendiente';
    --
    --
  BEGIN
    --
    IF Pv_CodEmpresa IS NOT NULL AND TRIM(Pv_Valor) IS NOT NULL AND TRIM(Pv_Tipo) IS NOT NULL THEN
      --
      Lv_TipoFormaContacto :=  '';

      IF Pv_Tipo = 'FONO' THEN
          Lv_TipoFormaContacto := 'Telefono';
      ELSE
         IF Pv_Tipo = 'MAIL' THEN
             Lv_TipoFormaContacto := 'Correo Electronico';
         ELSE
             IF Pv_Tipo = 'MOVIL' THEN
                 Lv_TipoFormaContacto := 'Movil';
             ELSE
                 Lv_TipoFormaContacto :=  Pv_Tipo;
             END IF;
         END IF;
      END IF;
      --
      Lv_QueryPersona := Lv_QueryPersona || 
      '(
          SELECT pto.ID_PUNTO, pto.LOGIN
          FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO pfc 
          JOIN DB_COMERCIAL.INFO_PERSONA pe ON pe.ID_PERSONA = pfc.PERSONA_ID
          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per ON per.PERSONA_ID = pe.ID_PERSONA
          JOIN DB_COMERCIAL.INFO_EMPRESA_ROL erol ON erol.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
          JOIN DB_COMERCIAL.INFO_PUNTO pto ON per.ID_PERSONA_ROL = pto.PERSONA_EMPRESA_ROL_ID
          WHERE 
          pfc.FORMA_CONTACTO_ID in 
          (
              SELECT ID_FORMA_CONTACTO FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO '|| 
              q'[ WHERE REGEXP_LIKE(DESCRIPCION_FORMA_CONTACTO, ']'||Lv_TipoFormaContacto||q'['))]'||
        q'[ AND pfc.ESTADO       = ']'||Lv_EstadoActivo||q'[']'||
        q'[ AND pfc.VALOR        = ']'||Pv_Valor||q'[']'||
        q'[ AND per.ESTADO       = ']'||Lv_EstadoActivo||q'[']'||
        ' AND ('||
        q'[      pto.ESTADO      = ']'||Lv_EstadoActivo||q'['  OR ]'|| 
        q'[      pto.ESTADO      = ']'||Lv_EstadoInCorte||q'[' OR ]'||
        q'[      pto.ESTADO      = ']'||Lv_EstadoPendiente||q'[']'||
        '     )'||
        q'[  AND erol.EMPRESA_COD = ']'||Pv_CodEmpresa||q'[']'||
      ')';

      Lv_QueryPunto := Lv_QueryPunto || '
      (
          SELECT pto.ID_PUNTO, pto.LOGIN FROM 
          DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO pfc
          JOIN DB_COMERCIAL.INFO_PUNTO pto ON pto.ID_PUNTO = pfc.PUNTO_ID
          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per ON per.ID_PERSONA_ROL = pto.PERSONA_EMPRESA_ROL_ID
          JOIN DB_COMERCIAL.INFO_PERSONA pe ON pe.ID_PERSONA = per.PERSONA_ID
          JOIN DB_COMERCIAL.INFO_EMPRESA_ROL erol ON erol.ID_EMPRESA_ROL = per.EMPRESA_ROL_ID
          WHERE 
          pfc.FORMA_CONTACTO_ID in 
          (
              SELECT ID_FORMA_CONTACTO FROM DB_COMERCIAL.ADMI_FORMA_CONTACTO '|| 
      q'[        WHERE REGEXP_LIKE(DESCRIPCION_FORMA_CONTACTO, ']'||Lv_TipoFormaContacto||q'[')]'||
      '    )'||
      q'[   AND pfc.ESTADO       = ']'||Lv_EstadoActivo||q'[']'||
      q'[   AND pfc.VALOR        = ']'||Pv_Valor||q'[']'||
      '     AND ('||
      q'[         pto.ESTADO      = ']'||Lv_EstadoActivo||q'['  OR ]'|| 
      q'[         pto.ESTADO      = ']'||Lv_EstadoInCorte||q'[' OR ]'||
      q'[         pto.ESTADO      = ']'||Lv_EstadoPendiente||q'[']'||
      '         )'||
      q'[   AND per.ESTADO       = ']'||Lv_EstadoActivo||q'[']'||
      q'[   AND erol.EMPRESA_COD = ']'||Pv_CodEmpresa||q'[']'||
      ')';

      Lv_Query := Lv_QueryPersona || ' UNION ' || Lv_QueryPunto ;
      --
      OPEN Pr_Informacion FOR Lv_Query;
      --
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Par谩metros adecuados para realizar la consulta - CodEmpresa(' ||
                         Pv_CodEmpresa || '), Pv_Valor( ' ||Pv_Valor || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pv_MensajeRespuesta := Lv_MensajeError;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_PUNTOS_BY_FORMA_CONTAC',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pv_MensajeRespuesta := 'Error al consultar los puntos por forma de contacto';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_PUNTOS_BY_FORMA_CONTAC',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_PUNTOS_BY_FORMA_CONTAC;

  PROCEDURE P_GET_ORDENES_TELCOS_CRM(Pcl_Parametros         IN CLOB,
                                     Pv_MensajeRespuesta    OUT VARCHAR2,
                                     Pr_Informacion         OUT SYS_REFCURSOR) IS
    --
    Ln_Indx                NUMBER;
    Lv_Query               CLOB;
    Le_Exception           EXCEPTION;
    Lv_MensajeError        VARCHAR2(30000);
    Lr_OrdenesVendidas     DB_COMERCIAL.CMKG_TYPES.Lr_ServiciosCrm;
    Lr_OrdenesVendidasProcesar DB_COMERCIAL.CMKG_TYPES.T_ServiciosCrm;
    Lv_FrecuenciaProducto  NUMBER;
    Lv_CamposAdicionales   VARCHAR2(500);
    Lv_RegistroAdicional   VARCHAR2(1000);
    Lv_Select              VARCHAR2(30000) := 'SELECT ';
    Lv_From                VARCHAR2(30000) := 'FROM ';
    Lv_Where               VARCHAR2(30000) := 'WHERE ';
    Lv_GroupBy             VARCHAR2(30000) := '';
    Lv_SelectCaB           VARCHAR2(30000) := '';
    Lv_FromCabIni          VARCHAR2(30000) := '';
    Lv_FromCabFin          VARCHAR2(30000) := '';
    Lv_Caracteristica      VARCHAR2(30000) := 'NOMBRE_PROPUESTA';
    Lv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE  := 'Activo';
    Lv_EstadoPendiente     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE  := 'Pendiente';
    Lv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_ValorCategorias     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE  := 'CATEGORIAS_PRODUCTOS';
    Lv_SolicitudDescuento  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE  := 'SOLICITUDES DE DESCUENTO';
    Lv_EstadosServicios    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE  := 'ESTADO_SERVICIO';
    Lv_Proceso             DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE := 'REPORTES';
    Lv_Modulo              DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE  := 'COMERCIAL';
    Lv_EsVenta             DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE   := 'S';
    Lv_TipoOrden           DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE := 'N';
    Lv_Directorio          VARCHAR2(50)  := 'DIR_REPGERENCIA';
    Lv_NombreArchivo       VARCHAR2(100);
    Lv_Delimitador         VARCHAR2(1) := ';';
    Lv_Gzip                VARCHAR2(100);
    Lv_Remitente           VARCHAR2(30) := 'telcos@telconet.ec';
    Lv_Destinatario        VARCHAR2(100);
    Lv_Asunto              VARCHAR2(300);
    Lv_NombreArchivoZip    VARCHAR2(100);
    Lc_GetAliasPlantilla   DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Cuerpo              VARCHAR2(9999);
    Lfile_Archivo          utl_file.file_type;
    Lv_PrefijoEmpresa      VARCHAR2(50);
    Lv_FechaInicio         VARCHAR2(400);
    Lv_FechaFin            VARCHAR2(400);
    Lv_Categoria           VARCHAR2(400);
    Lv_Grupo               VARCHAR2(400);
    Lv_Subgrupo            VARCHAR2(400);
    Lv_TipoOrdenes         VARCHAR2(400);
    Lv_Frecuencia          VARCHAR2(400);
    Lv_TipoPersonal        VARCHAR2(400);
    Ln_IdPersonaEmpresaRol NUMBER;
    Lv_OpcionSelect        VARCHAR2(400);
    Lv_EmailUsrSesion      VARCHAR2(400);
    Lv_EmailTelcos         VARCHAR2(40):='notificaciones_telcos@telconet.ec';
    --
    Lv_MotivoPadreRegularizacion DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_PADRE_CANCELACION%TYPE := 'Cancelacion por Regularizacion';
    --
  BEGIN
    --
    APEX_JSON.parse(Pcl_Parametros);
    Lv_PrefijoEmpresa      := APEX_JSON.get_varchar2('strPrefijoEmpresa');
    Lv_FechaInicio         := APEX_JSON.get_varchar2('strFechaInicio');
    Lv_FechaFin            := APEX_JSON.get_varchar2('strFechaFin');
    Lv_Categoria           := APEX_JSON.get_varchar2('strCategoria');
    Lv_Grupo               := APEX_JSON.get_varchar2('strGrupo');
    Lv_Subgrupo            := APEX_JSON.get_varchar2('strSubgrupo');
    Lv_TipoOrdenes         := APEX_JSON.get_varchar2('strTipoOrdenes');
    Lv_Frecuencia          := APEX_JSON.get_varchar2('strFrecuencia');
    Lv_TipoPersonal        := APEX_JSON.get_varchar2('strTipoPersonal');
    Ln_IdPersonaEmpresaRol := APEX_JSON.get_number('intIdPersonEmpresaRol');
    Lv_OpcionSelect        := APEX_JSON.get_varchar2('strOpcionSelect');
    Lv_EmailUsrSesion      := APEX_JSON.get_varchar2('strEmailUsrSession');

    IF TRIM(Lv_PrefijoEmpresa) IS NOT NULL AND Lv_FechaInicio IS NOT NULL AND
       Lv_FechaFin IS NOT NULL THEN
      --
      Lv_SelectCaB := ' SELECT DISTINCT '||
                          '  COUNT(DISTINCT cantidad_propuesta) AS cantidad_propuesta, '||
                          '  COUNT(cantidad_ordenes) - COUNT(cantidad_ordenes_crm) AS cantidad_ordenes, '||
                          '  COUNT(cantidad_ordenes_crm) AS cantidad_ordenes_crm, '||
                          '  SUM(total_venta_mrc) AS total_venta_mrc, '||
                          '  SUM(total_venta_nrc) AS total_venta_nrc, '||
                          '  usr_vendedor ';
      --
      Lv_FromCabIni :=' FROM (';
      --
      Lv_FromCabFin := ' ) ';
      --
      Lv_From       := Lv_From || ' DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDAS ' ||
                                  'JOIN DB_COMERCIAL.ADMI_PRODUCTO AP ' ||
                                  'ON AP.ID_PRODUCTO = IDAS.PRODUCTO_ID ';
      --
      Lv_Where      := Lv_Where ||
                        ' DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDAS.PUNTO_ID, NULL) = '''||Lv_PrefijoEmpresa||''' ' ||
                        'AND IDAS.FECHA_TRANSACCION >= CAST(TO_DATE('''||Lv_FechaInicio||''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                        'AND IDAS.FECHA_TRANSACCION <  CAST(TO_DATE('''||Lv_FechaFin||''', ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE) ' ||
                        'AND AP.EMPRESA_COD = (SELECT COD_EMPRESA ' ||
                        'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                        'WHERE ESTADO = '''||Lv_EstadoActivo||''' ' ||
                        'AND PREFIJO  = '''||Lv_PrefijoEmpresa||''') ' ||
                        'AND IDAS.ES_VENTA = '''||Lv_EsVenta||''' ' ||
                        'AND IDAS.TIPO_ORDEN = '''||Lv_TipoOrden||''' ';
      --
      IF Lv_OpcionSelect = 'DETALLE' THEN
        --
        Lv_SelectCaB  := '';
        Lv_FromCabIni := '';
        Lv_FromCabFin := '';
        Lv_Select     := Lv_Select || ' IOG.NOMBRE_OFICINA, ' ||
                      ' IDAS.CATEGORIA, ' || ' IDAS.GRUPO, ' ||
                      ' IDAS.SUBGRUPO, ' || ' AP.DESCRIPCION_PRODUCTO, ' ||
                      ' NVL( IPE.RAZON_SOCIAL, CONCAT( IPE.NOMBRES, CONCAT('' '', IPE.APELLIDOS) ) ) AS CLIENTE, ' ||
                      ' IP.LOGIN, ' || ' IDAS.USR_VENDEDOR, ' ||
                      ' ISER.ID_SERVICIO, ' || ' IDAS.PRODUCTO_ID, ' ||
                      ' IDAS.ESTADO, ' ||
                      ' DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN( TRIM( REPLACE( REPLACE( REPLACE( TRIM( ' ||
                      ' ISER.DESCRIPCION_PRESENTA_FACTURA ), Chr(9), '' ''), Chr(10), '' ''), Chr(13), '' '') ) ) AS ' ||
                      ' DESCRIPCION_PRESENTA_FACTURA, ' ||
                      ' TO_CHAR(ISER.FE_CREACION, ''DD-MM-YYYY HH24:MI:SS'') AS FE_CREACION, ' ||
                      ' ROUND((SYSDATE - trunc(ISER.FE_CREACION)), 0) - 1 AS DIAS_ACUMULADO_CREACION, ' ||
                      ' DB_COMERCIAL.COMEK_CONSULTAS.F_GET_NUM_DIAS_ESTADO(IDAS.SERVICIO_ID, IDAS.ESTADO,''FECHA'') AS FE_ESTADO, ' ||
                      ' DB_COMERCIAL.COMEK_CONSULTAS.F_GET_NUM_DIAS_ESTADO(IDAS.SERVICIO_ID, IDAS.ESTADO,''NUM_DIAS'') AS DIAS_ACUMULADO_ESTADO, ' ||
                      ' DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DEPARTAMENTO_SERVICIO(IDAS.SERVICIO_ID, IDAS.ESTADO, '''||Lv_PrefijoEmpresa||''',''PERSONA'') AS USR_ESTADO, ' ||
                      ' DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DEPARTAMENTO_SERVICIO(IDAS.SERVICIO_ID, IDAS.ESTADO, '''||Lv_PrefijoEmpresa||''',''DEPARTAMENTO'') AS DEPARTAMENTO_ESTADO, ' ||
                      '( ' ||
                      '     SELECT ISERPC.VALOR ' ||
                      '     FROM ' ||
                      '         DB_COMERCIAL.INFO_SERVICIO                       ISER ' ||
                      '         JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT      ISERPC ON ISERPC.SERVICIO_ID              = ISER.ID_SERVICIO ' ||
                      '                                                                 AND ISERPC.ESTADO                  = '''||Lv_EstadoActivo||''' ' ||
                      '         JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA   APC    ON APC.ID_PRODUCTO_CARACTERISITICA = ISERPC.PRODUCTO_CARACTERISITICA_ID ' ||
                      '                                                                 AND APC.ESTADO                     = '''||Lv_EstadoActivo||''' ' ||
                      '         JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC     ON AC.ID_CARACTERISTICA            = APC.CARACTERISTICA_ID ' ||
                      '                                                                 AND AC.ESTADO                      = '''||Lv_EstadoActivo||''' ' ||
                      '     WHERE ' ||
                      '         ISER.ID_SERVICIO                  = IDAS.SERVICIO_ID ' ||
                      '         AND AC.DESCRIPCION_CARACTERISTICA = '''||Lv_Caracteristica||''' ' ||
                      ' ) AS PROPUESTA, ' ||
                      ' NVL(IDAS.FRECUENCIA_PRODUCTO, 0) AS FRECUENCIA_PRODUCTO, ' ||
                      ' IDAS.ES_VENTA, ' || ' IDAS.MRC, ' ||
                      ' NVL(IDAS.PRECIO_VENTA, 0) AS PRECIO_VENTA, ' ||
                      ' NVL(IDAS.CANTIDAD, 0) AS CANTIDAD, ' ||
                      ' NVL(IDAS.DESCUENTO_UNITARIO, 0) AS DESCUENTO, ' ||
                      ' NVL(IDAS.PRECIO_INSTALACION, 0) AS PRECIO_INSTALACION, ' ||
                      ' ( NVL(IDAS.PRECIO_VENTA, 0) - NVL(IDAS.DESCUENTO_UNITARIO, 0) ) AS SUBTOTAL_CON_DESCUENTO, ' ||
                      ' ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) AS ' ||
                      ' SUBTOTAL, ' ||
                      ' IDAS.NRC AS VALOR_INSTALACION_MENSUAL, ' ||
                      ' ROUND( ( ( ( NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0) ) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0) ) + ' ||
                      '          ( NVL(IDAS.PRECIO_INSTALACION, 0) ) ), 2 ) AS VALOR_TOTAL, ' ||
                      ' IDAS.ACCION, ';
        --
        IF TRIM(Lv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_Select := Lv_Select ||' IDAS.MOTIVO_CANCELACION, IDAS.MOTIVO_PADRE_CANCELACION ';
          --
        ELSE
          --
          Lv_Select := Lv_Select ||' '' '' AS MOTIVO_CANCELACION, '' '' AS MOTIVO_PADRE_CANCELACION ';
          --
        END IF;
        --
        Lv_From := Lv_From || ' JOIN DB_COMERCIAL.INFO_SERVICIO ISER ' ||
                   ' ON ISER.ID_SERVICIO = IDAS.SERVICIO_ID ' ||
                   ' JOIN DB_COMERCIAL.INFO_PUNTO IP ' ||
                   ' ON ISER.PUNTO_ID = IP.ID_PUNTO ' ||
                   ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ' ||
                   ' ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID ' ||
                   ' JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ' ||
                   ' ON IPER.OFICINA_ID = IOG.ID_OFICINA ' ||
                   ' JOIN DB_COMERCIAL.INFO_PERSONA IPE ' ||
                   ' ON IPE.ID_PERSONA = IPER.PERSONA_ID ';
        --
      ELSE
        --
        Lv_Select := Lv_Select ||
                      ' IDAS.SERVICIO_ID AS CANTIDAD_ORDENES, '||
                      ' ( '||
                      '   SELECT '||
                      '       ISER.ID_SERVICIO '||
                      '   FROM '||
                      '      DB_COMERCIAL.INFO_SERVICIO                  ISER '||
                      '       JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT      ISERPC ON ISERPC.SERVICIO_ID = ISER.ID_SERVICIO '||
                      '                                                             AND ISERPC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '       JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA   APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISERPC.PRODUCTO_CARACTERISITICA_ID '||
                      '                                                             AND APC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '       JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID '||
                      '                                                   AND AC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '   WHERE '||
                      '       ISER.ID_SERVICIO = IDAS.SERVICIO_ID '||
                      '       AND AC.DESCRIPCION_CARACTERISTICA = '''||Lv_Caracteristica||''' '||
                      ' ) AS CANTIDAD_ORDENES_CRM, '||
                      ' ROUND((((NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0)) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0)) +(NVL(IDAS.PRECIO_INSTALACION '||
                      ' , 0) )), 2) AS TOTAL_VENTA, '||
                      ' ROUND((((NVL(IDAS.PRECIO_VENTA, 0) * NVL(IDAS.CANTIDAD, 0)) - NVL(IDAS.DESCUENTO_TOTALIZADO, 0))), 2) AS TOTAL_VENTA_MRC, '||
                      ' ROUND(((NVL(IDAS.PRECIO_INSTALACION, 0) )), 2) AS TOTAL_VENTA_NRC, '||
                      ' IDAS.USR_VENDEDOR, '||
                      ' ( '||
                      '   SELECT DISTINCT '||
                      '       ISERPC.VALOR '||
                      '   FROM '||
                      '       DB_COMERCIAL.INFO_SERVICIO                  ISER '||
                      '       JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT      ISERPC ON ISERPC.SERVICIO_ID = ISER.ID_SERVICIO '||
                      '                                                             AND ISERPC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '       JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA   APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISERPC.PRODUCTO_CARACTERISITICA_ID '||
                      '                                                             AND APC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '       JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID '||
                      '                                                   AND AC.ESTADO = '''||Lv_EstadoActivo||''' '||
                      '   WHERE '||
                      '       ISER.ID_SERVICIO = IDAS.SERVICIO_ID '||
                      '       AND AC.DESCRIPCION_CARACTERISTICA = '''||Lv_Caracteristica||''' '||
                      ' ) AS CANTIDAD_PROPUESTA ';
        --
        IF Lv_OpcionSelect = 'DESCUENTO' THEN
          --
          Lv_SelectCaB := Lv_SelectCaB ||
                          ' ,COUNT(cantidad_solicitudes) AS cantidad_solicitudes, '||
                              ' SUM(total_descuentos) AS total_descuentos ';
          Lv_Select    := Lv_Select ||
                          ' ,( SELECT DISTINCT IDS.ID_DETALLE_SOLICITUD  ' ||
                          ' FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ' ||
                          ' JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ' ||
                          ' ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID '||
                          ' WHERE ATS.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                          ' AND IDS.SERVICIO_ID = IDAS.SERVICIO_ID ' ||
                          ' AND IDS.ESTADO = '''||Lv_EstadoPendiente||''' ' ||
                          ' AND ATS.DESCRIPCION_SOLICITUD IN ( ' ||
                          '   SELECT APD.DESCRIPCION ' ||
                          '   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                          '   JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                          '   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                          '   WHERE APD.ESTADO         = '''||Lv_EstadoActivo||''' ' ||
                          '   AND APC.ESTADO           = '''||Lv_EstadoActivo||''' ' ||
                          '   AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' ' ||
                          '   AND APC.PROCESO          = '''||Lv_Proceso||''' ' ||
                          '   AND APC.MODULO           = '''||Lv_Modulo||''' ' ||
                          '   AND APD.VALOR1           = '''||Lv_SolicitudDescuento||''' ' ||
                          '   AND APD.EMPRESA_COD      = ( ' ||
                          '     SELECT COD_EMPRESA ' ||
                          '     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                          '     WHERE ESTADO = '''||Lv_EstadoActivo||''' ' ||
                          '     AND PREFIJO  = '''||Lv_PrefijoEmpresa||''' ' || '   ) ' ||
                          ' ))AS CANTIDAD_SOLICITUDES, '||
                          ' (SELECT ROUND( NVL(IDS.PRECIO_DESCUENTO, 0) , 2 )  '||
                          ' FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS ' ||
                          ' JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS ' ||
                          ' ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID '||
                          ' WHERE ATS.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                          ' AND IDS.SERVICIO_ID = IDAS.SERVICIO_ID ' ||
                          ' AND IDS.ESTADO = '''||Lv_EstadoPendiente||''' ' ||
                          ' AND ATS.DESCRIPCION_SOLICITUD IN ( ' ||
                          '   SELECT APD.DESCRIPCION ' ||
                          '   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                          '   JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                          '   ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                          '   WHERE APD.ESTADO         = '''||Lv_EstadoActivo||''' ' ||
                          '   AND APC.ESTADO           = '''||Lv_EstadoActivo||''' ' ||
                          '   AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' ' ||
                          '   AND APC.PROCESO          = '''||Lv_Proceso||''' ' ||
                          '   AND APC.MODULO           = '''||Lv_Modulo||''' ' ||
                          '   AND APD.VALOR1           = '''||Lv_SolicitudDescuento||''' ' ||
                          '   AND APD.EMPRESA_COD      = ( ' ||
                          '     SELECT COD_EMPRESA ' ||
                          '     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                          '     WHERE ESTADO = '''||Lv_EstadoActivo||''' ' ||
                          '     AND PREFIJO  = '''||Lv_PrefijoEmpresa||''' ' || '   ) ' ||
                          ' )) AS TOTAL_DESCUENTOS ';
        END IF;
        --
        Lv_GroupBy := ' GROUP BY usr_vendedor ';
      END IF;
      --
      Lv_Where := Lv_Where || 'AND IDAS.ESTADO ';
      --
      IF TRIM(Lv_TipoOrdenes) = 'VENTAS_ACTIVAS' THEN
        --
        Lv_Where       := Lv_Where || ' NOT IN ';
        --
      ELSE
        --
        Lv_Where       := Lv_Where || ' IN ';
        --
        IF TRIM(Lv_TipoOrdenes) = 'ORDENES_PENDIENTES' OR
           TRIM(Lv_TipoOrdenes) = 'ORDENES_ACTIVAS' THEN
          --
          Lv_EstadosServicios := 'ESTADO_SERVICIO_ESPECIAL';
          --
        END IF;
        --
      END IF;
      --
      Lv_Where := Lv_Where || ' ( SELECT APD.DESCRIPCION ' ||
                  'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                  'JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                  'ON APC.ID_PARAMETRO = APD.PARAMETRO_ID ' ||
                  'WHERE APD.ESTADO         = '''||Lv_EstadoActivo||''' ' ||
                  'AND APC.ESTADO           = '''||Lv_EstadoActivo||''' ' ||
                  'AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' ' ||
                  'AND APC.PROCESO          = '''||Lv_Proceso||''' ' ||
                  'AND APC.MODULO           = '''||Lv_Modulo||''' ' ||
                  'AND APD.VALOR2           = '''||Lv_EstadosServicios||''' ' ||
                  'AND APD.VALOR1           = NVL('''||Lv_TipoOrdenes||''', APD.VALOR1) ' ||
                  'AND APD.EMPRESA_COD      = (SELECT COD_EMPRESA ' ||
                  'FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ' ||
                  'WHERE ESTADO = '''||Lv_EstadoActivo||''' ' ||
                  'AND PREFIJO  = '''||Lv_PrefijoEmpresa||''') ) ';
      --
      IF Lv_OpcionSelect = 'CANCEL_POR_REGULARIZACION' THEN
        --
        Lv_Where := Lv_Where ||
                    ' AND IDAS.MOTIVO_PADRE_CANCELACION = '''||Lv_MotivoPadreRegularizacion||''' ';
        --
      END IF;
      --
      IF TRIM(Lv_Frecuencia) IS NOT NULL AND TRIM(Lv_Frecuencia) = 'UNICA' THEN
        --
        Lv_FrecuenciaProducto := 0;
        Lv_Where              := Lv_Where ||
                                 'AND ( IDAS.FRECUENCIA_PRODUCTO = '''||Lv_FrecuenciaProducto||''' OR IDAS.FRECUENCIA_PRODUCTO IS NULL ) ';
        --
      ELSIF TRIM(Lv_Frecuencia) IS NOT NULL AND
            (TRIM(Lv_Frecuencia) = 'MENSUAL' OR
             TRIM(Lv_Frecuencia) = 'NO_MENSUAL') THEN
        --
        Lv_FrecuenciaProducto := 1;
        --
        IF TRIM(Lv_Frecuencia) = 'MENSUAL' THEN
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO = '''||Lv_FrecuenciaProducto||''' ';
          --
        ELSE
          --
          Lv_Where := Lv_Where ||
                      'AND IDAS.FRECUENCIA_PRODUCTO > '''||Lv_FrecuenciaProducto||''' ';
          --
        END IF;
        --
      END IF;
      --
      --
      IF TRIM(Lv_Categoria) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND AP.LINEA_NEGOCIO = '''||Lv_Categoria||''' ';
        --
      ELSIF TRIM(Lv_Grupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.GRUPO = '''||Lv_Grupo||''' ';
        --
        --
      ELSIF TRIM(Lv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.SUBGRUPO = '''||Lv_Subgrupo||''' ';
        --
      END IF;
      --
      --
      IF TRIM(Lv_Categoria) IS NULL THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.CATEGORIA IN ( ' ||
                    ' SELECT APD.DESCRIPCION ' ||
                    ' FROM DB_GENERAL.ADMI_PARAMETRO_DET APD ' ||
                    ' JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ' ||
                    ' ON APD.PARAMETRO_ID = APC.ID_PARAMETRO ' ||
                    ' WHERE APD.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                    ' AND APC.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                    ' AND APC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' ' ||
                    ' AND APC.PROCESO = '''||Lv_Proceso||''' ' ||
                    ' AND APC.MODULO = '''||Lv_Modulo||''' ' ||
                    ' AND APD.VALOR1 = '''||Lv_ValorCategorias||''' ' ||
                    ' AND APD.EMPRESA_COD = ( ' || '   SELECT COD_EMPRESA ' ||
                    '   FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ' ||
                    '   WHERE IEG.ESTADO = '''||Lv_EstadoActivo||''' ' ||
                    '   AND IEG.PREFIJO = '''||Lv_PrefijoEmpresa||''' ' || ' ) ) ';
        --
      END IF;
      --
      --
      IF TRIM(Lv_TipoPersonal) IS NOT NULL AND Ln_IdPersonaEmpresaRol > 0 THEN
        --
        Lv_Where := Lv_Where || 'AND IDAS.USR_VENDEDOR IN ( ' ||
                    ' SELECT IPE_S.LOGIN ' ||
                    ' FROM DB_COMERCIAL.INFO_PERSONA IPE_S ' ||
                    ' JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_S ' ||
                    ' ON IPER_S.PERSONA_ID = IPE_S.ID_PERSONA ';
        --
        --
        IF TRIM(Lv_TipoPersonal) = 'VENDEDOR' THEN
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.ID_PERSONA_ROL = '''||Ln_IdPersonaEmpresaRol||''' ';
          --
        ELSIF (TRIM(Lv_TipoPersonal) IS NOT NULL OR Lv_TipoPersonal != 'VENDEDOR') THEN
          --
          Lv_Where := Lv_Where ||
                      'WHERE IPER_S.REPORTA_PERSONA_EMPRESA_ROL_ID = '''||Ln_IdPersonaEmpresaRol||''' ';
          --
        END IF;
        --
        Lv_Where := Lv_Where || ' ) ';
        --
      END IF;
      --
      Lv_Query := Lv_SelectCaB || Lv_FromCabIni || Lv_Select ||  Lv_From || Lv_Where || Lv_FromCabFin || Lv_GroupBy;
      --
      IF Lv_OpcionSelect = 'DETALLE' THEN
        --
        Lv_NombreArchivo    := 'DetalladoVentas_' ||
                                Lv_PrefijoEmpresa || '_' ||
                                Lv_TipoOrdenes || '.csv';
        Lv_Gzip             := 'gzip /backup/repgerencia/' ||Lv_NombreArchivo;
        Lv_Destinatario     := NVL(Lv_EmailUsrSesion,Lv_EmailTelcos) || ',';
        Lv_Asunto           := 'Notificacion DETALLADO DE ' ||Lv_TipoOrdenes;
        Lv_NombreArchivoZip := Lv_NombreArchivo || '.gz';
        Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_Ventas_Dash');
        Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
        Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,
                                               Lv_NombreArchivo,
                                               'w',
                                               3000);
        --
        Lv_CamposAdicionales := NULL;
        --
        IF TRIM(Lv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
          --
          Lv_CamposAdicionales := 'MOTIVO PADRE CANCELACION' ||
                                  Lv_Delimitador || 'MOTIVO CANCELACION' ||
                                  Lv_Delimitador;
          --
        END IF;
        --
        --
        utl_file.put_line(Lfile_Archivo,
                          'OFICINA' || Lv_Delimitador || 'CLIENTE' ||
                          Lv_Delimitador || 'LOGIN' || Lv_Delimitador ||
                          'VENDEDOR' || Lv_Delimitador || 'ID_PRODUCTO' ||
                          Lv_Delimitador || 'DESCRIPCION PRODUCTO' ||
                          Lv_Delimitador || 'CATEGORIA' || Lv_Delimitador ||
                          'GRUPO' || Lv_Delimitador || 'SUBGRUPO' ||
                          Lv_Delimitador || 'ID SERVICIO' || Lv_Delimitador ||
                          'DESCRIPCION SERVICIO' || Lv_Delimitador ||
                          'FRECUENCIA PRODUCTO' || Lv_Delimitador ||
                          'ES VENTA' || Lv_Delimitador || 'ESTADO' ||
                          Lv_Delimitador || 'ACCION' || Lv_Delimitador ||
                          'FECHA CREACION' || Lv_Delimitador ||
                          'DIAS ACUMULADO CREACION' || Lv_Delimitador ||
                          'FECHA ESTADO' || Lv_Delimitador ||
                          'DIAS ACUMULADO ESTADO' || Lv_Delimitador ||
                          'USR ESTADO' || Lv_Delimitador ||
                          'ESTADO DEPARTAMENTO' || Lv_Delimitador ||
                          'PROPUESTA' || Lv_Delimitador ||
                          'VALOR MRC' || Lv_Delimitador || 'PRECIO VENTA' ||
                          Lv_Delimitador || 'DESCUENTO UNITARIO' ||
                          Lv_Delimitador || 'SUBTOTAL CON DESCUENTO' ||
                          Lv_Delimitador || 'CANTIDAD' || Lv_Delimitador ||
                          'SUBTOTAL' || Lv_Delimitador ||
                          'VALOR INSTALACION' || Lv_Delimitador ||
                          'V. INSTALACION (NRC)' || Lv_Delimitador ||
                          'VALOR TOTAL (SUBTOTAL + NRC)' || Lv_Delimitador ||
                          Lv_CamposAdicionales);
        --
        OPEN Pr_Informacion FOR Lv_Query;
        LOOP
          FETCH Pr_Informacion BULK COLLECT INTO Lr_OrdenesVendidasProcesar LIMIT 100000000;
          Ln_Indx:=Lr_OrdenesVendidasProcesar.FIRST;
          WHILE (Ln_Indx IS NOT NULL)
          LOOP
            Lr_OrdenesVendidas   := Lr_OrdenesVendidasProcesar(Ln_Indx);
            Ln_Indx              := Lr_OrdenesVendidasProcesar.NEXT(Ln_Indx);
            Lv_RegistroAdicional := NULL;
            --
            IF TRIM(Lv_TipoOrdenes) = 'CLIENTES_CANCELADOS' THEN
              --
              Lv_RegistroAdicional := Lr_OrdenesVendidas.MOTIVO_PADRE_CANCELACION ||
                                      Lv_Delimitador ||
                                      Lr_OrdenesVendidas.MOTIVO_CANCELACION ||
                                      Lv_Delimitador;
              --
            END IF;
            --
            utl_file.put_line(Lfile_Archivo,
                              Lr_OrdenesVendidas.NOMBRE_OFICINA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.CLIENTE ||
                              Lv_Delimitador || Lr_OrdenesVendidas.LOGIN ||
                              Lv_Delimitador || Lr_OrdenesVendidas.USR_VENDEDOR ||
                              Lv_Delimitador || Lr_OrdenesVendidas.PRODUCTO_ID ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DESCRIPCION_PRODUCTO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.CATEGORIA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.GRUPO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.SUBGRUPO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.ID_SERVICIO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DESCRIPCION_PRESENTA_FACTURA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.FRECUENCIA_PRODUCTO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.ES_VENTA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.ACCION ||
                              Lv_Delimitador || Lr_OrdenesVendidas.FE_CREACION ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DIAS_ACUMULADO_CREACION ||
                              Lv_Delimitador || Lr_OrdenesVendidas.FE_ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DIAS_ACUMULADO_ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.USR_ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DEPARTAMENTO_ESTADO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.PROPUESTA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.MRC ||
                              Lv_Delimitador || Lr_OrdenesVendidas.PRECIO_VENTA ||
                              Lv_Delimitador || Lr_OrdenesVendidas.DESCUENTO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.SUBTOTAL_CON_DESCUENTO ||
                              Lv_Delimitador || Lr_OrdenesVendidas.CANTIDAD ||
                              Lv_Delimitador || Lr_OrdenesVendidas.SUBTOTAL ||
                              Lv_Delimitador || Lr_OrdenesVendidas.PRECIO_INSTALACION ||
                              Lv_Delimitador || Lr_OrdenesVendidas.VALOR_INSTALACION_MENSUAL ||
                              Lv_Delimitador || Lr_OrdenesVendidas.VALOR_TOTAL ||
                              Lv_Delimitador || Lv_RegistroAdicional);
          END LOOP;
          EXIT WHEN Pr_Informacion%NOTFOUND; 
          --
        END LOOP;
        CLOSE Pr_Informacion;
        --
        UTL_FILE.fclose(Lfile_Archivo);
        --
        DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lv_Gzip));
        --
        DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lv_Remitente,
                                                  Lv_Destinatario,
                                                  Lv_Asunto,
                                                  Lv_Cuerpo,
                                                  Lv_Directorio,
                                                  Lv_NombreArchivoZip);
        --
        UTL_FILE.FREMOVE(Lv_Directorio, Lv_NombreArchivoZip);
        --
        Pr_Informacion      := null;
        Pv_MensajeRespuesta := 'Reporte generado y enviado al mail exitosamente';
        --
      ELSE
        --
        OPEN Pr_Informacion FOR Lv_Query;
        Pv_MensajeRespuesta := 'Proceso OK';
        --
      END IF;
      --
      
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los Parametros adecuados para realizar la consulta - Prefijo(' ||
                         Lv_PrefijoEmpresa || '), FeInicio( ' ||
                         Lv_FechaInicio || '), FeFin( ' || Lv_FechaFin ||
                         '), TipoOrdenes( ' || Lv_TipoOrdenes ||
                         '), Categoria(' || Lv_Categoria || '), Grupo(' ||
                         Lv_Grupo || '), Subgrupo(' || Lv_Subgrupo || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      Pv_MensajeRespuesta := Lv_MensajeError;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_ORDENES_TELCOS_CRM',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
    WHEN OTHERS THEN
      --
      Pv_MensajeRespuesta := 'Error al consultar las ordenes de servicio';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.P_GET_ORDENES_TELCOS_CRM',
                                           'Error obtener la consulta - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
  END P_GET_ORDENES_TELCOS_CRM;

  FUNCTION F_GET_NUM_DIAS_ESTADO(FnIdServicio     IN NUMBER,
                                 FvEstadoServicio IN VARCHAR2,
                                 FvRetornar       IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetNumDiasEstado(CnIdServicio VARCHAR2,CvEstado VARCHAR2) IS
    --
      SELECT
        DIAS_ACUMULADO,
        FE_CREACION
      FROM
      (
        SELECT ROUND((SYSDATE - TRUNC(ISERH.FE_CREACION)), 0)-1 AS DIAS_ACUMULADO,
               TO_CHAR(ISERH.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS') AS FE_CREACION
          FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
        WHERE ISERH.SERVICIO_ID = CnIdServicio
          AND ISERH.ESTADO      = CvEstado
          ORDER BY
            ISERH.FE_CREACION DESC)
      WHERE
          ROWNUM = 1;
    --
    Lv_Respuesta        VARCHAR2(100):='3';
    Lr_GetNumDiasEstado C_GetNumDiasEstado%ROWTYPE;
    --
  BEGIN
    --
    IF C_GetNumDiasEstado%ISOPEN THEN
      CLOSE C_GetNumDiasEstado;
    END IF;
    --
    OPEN C_GetNumDiasEstado(FnIdServicio,FvEstadoServicio);
    --
    FETCH C_GetNumDiasEstado
      INTO Lr_GetNumDiasEstado;
    --
    CLOSE C_GetNumDiasEstado;
    --
    IF Lr_GetNumDiasEstado.FE_CREACION IS NOT NULL THEN
    --
      IF FvRetornar ='NUM_DIAS' THEN
        --
        Lv_Respuesta := NVL(Lr_GetNumDiasEstado.DIAS_ACUMULADO, NULL);
        --
      ELSIF FvRetornar = 'FECHA' THEN
        --
        Lv_Respuesta := NVL(Lr_GetNumDiasEstado.FE_CREACION, NULL);
        --
      END IF;
        --
    END IF;
    --
    RETURN Lv_Respuesta;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_Respuesta := 0;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_NUM_DIAS_ESTADO',
                                           'Error al consultar la informacion - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'telcos'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
      RETURN Lv_Respuesta;
      --
  END F_GET_NUM_DIAS_ESTADO;

  FUNCTION F_GET_DEPARTAMENTO_SERVICIO(FnIdServicio     IN NUMBER,
                                       FvEstadoServicio IN VARCHAR2,
                                       FvPrefijo        IN VARCHAR2,
                                       FvRetornar       IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    CURSOR C_GetPersonaDepartamento(CnIdServicio     NUMBER,
                                    CvEstadoServicio VARCHAR2,
                                    Cv_Prefijo       VARCHAR2,
                                    CvEstadoActivo   VARCHAR2) IS
    --
      SELECT
        NOMBRE_DEPARTAMENTO,
        NOMBRES_COMPLETOS
      FROM
      (
        SELECT
            AD.NOMBRE_DEPARTAMENTO             AS NOMBRE_DEPARTAMENTO,
            IPE.NOMBRES || ' ' ||IPE.APELLIDOS AS NOMBRES_COMPLETOS
        FROM
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL         ISERH
            JOIN DB_COMERCIAL.INFO_PERSONA               IPE   ON ISERH.USR_CREACION = IPE.LOGIN
            JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL   IPER  ON IPER.PERSONA_ID    = IPE.ID_PERSONA
            JOIN DB_GENERAL.ADMI_DEPARTAMENTO            AD    ON AD.ID_DEPARTAMENTO = IPER.DEPARTAMENTO_ID
            JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO         IEG   ON IEG.COD_EMPRESA    = AD.EMPRESA_COD
            
        WHERE
            ISERH.SERVICIO_ID     = CnIdServicio
            AND AD.ESTADO         = CvEstadoActivo
            AND IEG.PREFIJO       = Cv_Prefijo
            AND ISERH.ESTADO      = CvEstadoServicio
        ORDER BY
            ISERH.FE_CREACION DESC)
      WHERE
          ROWNUM = 1;
    --
    Lv_Respuesta              VARCHAR2(100) :='';
    Lv_EstadoActivo           VARCHAR2(100) := 'Activo';
    lr_GetPersonaDepartamento C_GetPersonaDepartamento%ROWTYPE;
    --
  BEGIN
    --
    IF C_GetPersonaDepartamento%ISOPEN THEN
      CLOSE C_GetPersonaDepartamento;
    END IF;
    --
    OPEN C_GetPersonaDepartamento(FnIdServicio,FvEstadoServicio,FvPrefijo,Lv_EstadoActivo);
    --
    FETCH C_GetPersonaDepartamento
      INTO lr_GetPersonaDepartamento;
    --
    CLOSE C_GetPersonaDepartamento;
    --
    IF lr_GetPersonaDepartamento.NOMBRES_COMPLETOS IS NOT NULL THEN
      --
      IF FvRetornar ='DEPARTAMENTO' THEN
        --
        Lv_Respuesta := NVL(lr_GetPersonaDepartamento.NOMBRE_DEPARTAMENTO, NULL);
        --
      ELSIF FvRetornar = 'PERSONA' THEN
        --
        Lv_Respuesta := NVL(lr_GetPersonaDepartamento.NOMBRES_COMPLETOS, NULL);
      --
      END IF;
      --
    END IF;
    --
    RETURN Lv_Respuesta;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_Respuesta := '';
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'COMEK_CONSULTAS.F_GET_DEPARTAMENTO_SERVICIO',
                                           'Error al consultar la informacion - ' ||
                                           SQLCODE || ' - ERROR_STACK: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                           ' - ERROR_BACKTRACE: ' ||
                                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'telcos'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      --
      RETURN Lv_Respuesta;
      --
  END F_GET_DEPARTAMENTO_SERVICIO;

  PROCEDURE P_SERVICIO_POR_SERIE_ELEMENTO(Pcl_Request  IN  CLOB,
                                 Pv_Status    OUT VARCHAR2,
                                 Pv_Mensaje   OUT VARCHAR2,
                                 Pcl_Response OUT SYS_REFCURSOR)
  AS
    Lv_SerieFisica                VARCHAR2(100);
    Lcl_Select                    CLOB;
    Lcl_From                      CLOB;
    Lcl_Where                     CLOB;
    Lcl_Query                     CLOB;
    Ln_IdElemento                 NUMBER;
    Ln_IdServicio                 NUMBER;
    Ln_IdInterface                NUMBER;
    Ln_IdElementoCli              NUMBER;
    Ln_IdInterfaceCli             NUMBER;
    Lv_NombreElemento             VARCHAR2(100);
    Lv_LoginAux                   VARCHAR2(100);
    Lv_FormaContacto              VARCHAR2(30)    := 'Correo Electronico';
    Lv_EstadoActivo               VARCHAR2(10)    := 'Activo';
    Lv_EstadoConnect              VARCHAR2(10)    := 'connected';
    Lv_TipoEnlaceBackup           VARCHAR2(15)    := 'BACKUP';
    Lv_StandAloneNombre           VARCHAR2(15)    := 'PROPIEDAD';
    Lv_StandAloneDetalle          VARCHAR2(30)    := 'ELEMENTO PROPIEDAD DE';
    Lv_StandAloneValor            VARCHAR2(15)    := 'CLIENTE';
    Lv_ParametroModelo            VARCHAR2(64)    := 'NOMBRES_MODELOS_REEMPLAZAR_FORTIGATE_PORTAL';

    Ln_IdElementoEnl              NUMBER;
    Ln_IdIniInterface             NUMBER;
    Ln_IdFinInterface             NUMBER;
    Ln_ContInteraciones           NUMBER          := 0;
    Ln_MaxInteraciones            NUMBER          := 30;
    Lb_BanderaEnlace              BOOLEAN         := FALSE;
    Le_Errors                     EXCEPTION;

    CURSOR C_ObtenerDatosElemento(Cv_SerieElemento DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE)
    IS
        SELECT ID_ELEMENTO, NOMBRE_ELEMENTO FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO 
        WHERE SERIE_FISICA = Cv_SerieElemento
        AND ESTADO = Lv_EstadoActivo
        AND ROWNUM = 1;

    CURSOR C_ObtenerIdInterface(Cn_IdElemento DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ELEMENTO_ID%TYPE)
    IS
        SELECT ID_INTERFACE_ELEMENTO FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO
        WHERE ELEMENTO_ID = Cn_IdElemento
        AND ESTADO = Lv_EstadoConnect;

    CURSOR C_GetDatosServicioPorIntLogin(Cn_InterfaceCliente DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE,
        Cv_LoginAux DB_COMERCIAL.INFO_SERVICIO.LOGIN_AUX%TYPE)
    IS
        SELECT * FROM (
            SELECT SER.ID_SERVICIO, SER.LOGIN_AUX, TEC.INTERFACE_ELEMENTO_ID, TEC.ELEMENTO_CLIENTE_ID, TEC.INTERFACE_ELEMENTO_CLIENTE_ID
            FROM DB_COMERCIAL.INFO_SERVICIO SER
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TEC ON TEC.SERVICIO_ID = SER.ID_SERVICIO
            WHERE ( TEC.INTERFACE_ELEMENTO_ID = Cn_InterfaceCliente OR TEC.INTERFACE_ELEMENTO_CLIENTE_ID = Cn_InterfaceCliente )
            AND SER.LOGIN_AUX = Cv_LoginAux
            AND TEC.TIPO_ENLACE != Lv_TipoEnlaceBackup
            ORDER BY SER.FE_CREACION DESC
        ) WHERE ROWNUM = 1;

    CURSOR C_GetDatosServicioPorLogin(Cb_NombreElemento DB_COMERCIAL.INFO_SERVICIO.LOGIN_AUX%TYPE)
    IS
        SELECT * FROM (
            SELECT SER.ID_SERVICIO, SER.LOGIN_AUX, TEC.INTERFACE_ELEMENTO_ID, TEC.ELEMENTO_CLIENTE_ID, TEC.INTERFACE_ELEMENTO_CLIENTE_ID
            FROM DB_COMERCIAL.INFO_SERVICIO SER
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TEC ON TEC.SERVICIO_ID = SER.ID_SERVICIO
            WHERE TEC.TIPO_ENLACE != Lv_TipoEnlaceBackup
            AND SER.LOGIN_AUX = Cb_NombreElemento
            ORDER BY SER.FE_CREACION DESC
        ) WHERE ROWNUM = 1;

    CURSOR C_GetDatosServicioPorInt(Cn_InterfaceCliente DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CLIENTE_ID%TYPE)
    IS
        SELECT * FROM (
            SELECT SER.ID_SERVICIO, SER.LOGIN_AUX, TEC.INTERFACE_ELEMENTO_ID, TEC.ELEMENTO_CLIENTE_ID, TEC.INTERFACE_ELEMENTO_CLIENTE_ID
            FROM DB_COMERCIAL.INFO_SERVICIO SER
            INNER JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO TEC ON TEC.SERVICIO_ID = SER.ID_SERVICIO
            WHERE ( TEC.INTERFACE_ELEMENTO_ID = Cn_InterfaceCliente OR TEC.INTERFACE_ELEMENTO_CLIENTE_ID = Cn_InterfaceCliente )
            AND TEC.TIPO_ENLACE != Lv_TipoEnlaceBackup
            ORDER BY SER.FE_CREACION DESC
        ) WHERE ROWNUM = 1;

    CURSOR C_ObtenerInterfaceIniId(Cn_IdIniInterface DB_INFRAESTRUCTURA.INFO_ENLACE.INTERFACE_ELEMENTO_FIN_ID%TYPE)
    IS
        SELECT * FROM (
            SELECT INTERFACE_ELEMENTO_INI_ID FROM DB_INFRAESTRUCTURA.INFO_ENLACE
            WHERE INTERFACE_ELEMENTO_FIN_ID = Cn_IdIniInterface
            AND ESTADO = Lv_EstadoActivo
            ORDER BY FE_CREACION ASC
        ) WHERE ROWNUM = 1;

    BEGIN
        -- RETORNO LAS VARIABLES DEL REQUEST
        APEX_JSON.PARSE(Pcl_Request);
        Lv_SerieFisica := APEX_JSON.get_varchar2(p_path => 'serie');

        --obtener datos del elemento
        OPEN C_ObtenerDatosElemento(Lv_SerieFisica);
        FETCH C_ObtenerDatosElemento INTO Ln_IdElemento, Lv_NombreElemento;
        CLOSE C_ObtenerDatosElemento;

        --verificar si se encontro el elemento
        IF Ln_IdElemento IS NULL THEN
            Pv_Mensaje := 'No se encontr贸 el elemento con la serie ' || Lv_SerieFisica || 
                          ', por favor notificar a Sistemas.';
            RAISE Le_Errors;
        END IF;

        --buscar servicio por el login
        OPEN C_GetDatosServicioPorLogin(Lv_NombreElemento);
        FETCH C_GetDatosServicioPorLogin INTO Ln_IdServicio, Lv_LoginAux, Ln_IdInterface, Ln_IdElementoCli, Ln_IdInterfaceCli;
        CLOSE C_GetDatosServicioPorLogin;
        --verificar si se encontro el servicio
        IF Ln_IdServicio IS NOT NULL THEN
            Pv_Status := 'OK';
        END IF;

        IF Ln_IdServicio IS NULL THEN
            --busqueda del servicio por enlace
            IF C_ObtenerIdInterface%ISOPEN THEN
                CLOSE C_ObtenerIdInterface;
            END IF;
            --recorrer los id de la interface del elemento
            FOR I_GetInterface IN C_ObtenerIdInterface(Ln_IdElemento)
            LOOP
                --buscar servicio por el id de interface del cliente
                OPEN C_GetDatosServicioPorInt(I_GetInterface.ID_INTERFACE_ELEMENTO);
                FETCH C_GetDatosServicioPorInt INTO Ln_IdServicio, Lv_LoginAux, Ln_IdInterface, Ln_IdElementoCli, Ln_IdInterfaceCli;
                CLOSE C_GetDatosServicioPorInt;
                --finalizar loop si se encontro el servicio
                IF Ln_IdServicio IS NOT NULL THEN
                    Pv_Status := 'OK';
                    EXIT;
                END IF;
                --setear las variables del while
                Ln_ContInteraciones := 0;
                Lb_BanderaEnlace    := FALSE;
                --seteo el id ini de la interface
                Ln_IdIniInterface := I_GetInterface.ID_INTERFACE_ELEMENTO;
                --se recorre el while para buscar el enlace a travez del id interface
                WHILE Lb_BanderaEnlace = FALSE
                LOOP
                    --obtener el id ini de la interface
                    OPEN C_ObtenerInterfaceIniId(Ln_IdIniInterface);
                    FETCH C_ObtenerInterfaceIniId INTO Ln_IdIniInterface;
                    CLOSE C_ObtenerInterfaceIniId;
                    --obtener los datos del servicio por interface y login auxiliar
                    OPEN C_GetDatosServicioPorIntLogin(Ln_IdIniInterface,Lv_NombreElemento);
                    FETCH C_GetDatosServicioPorIntLogin INTO Ln_IdServicio, Lv_LoginAux, Ln_IdInterface, Ln_IdElementoCli, Ln_IdInterfaceCli;
                    CLOSE C_GetDatosServicioPorIntLogin;
                    --comparo el id del elemento
                    IF Ln_IdServicio IS NOT NULL THEN
                        Pv_Status := 'OK';
                        Lb_BanderaEnlace := TRUE;
                        EXIT;
                    END IF;
                    --obtener los datos del servicio por interface
                    OPEN C_GetDatosServicioPorInt(Ln_IdIniInterface);
                    FETCH C_GetDatosServicioPorInt INTO Ln_IdServicio, Lv_LoginAux, Ln_IdInterface, Ln_IdElementoCli, Ln_IdInterfaceCli;
                    CLOSE C_GetDatosServicioPorInt;
                    --comparo el id del elemento
                    IF Ln_IdServicio IS NOT NULL THEN
                        Pv_Status := 'OK';
                        Lb_BanderaEnlace := TRUE;
                        EXIT;
                    END IF;
                    --contar interaciones
                    Ln_ContInteraciones := Ln_ContInteraciones + 1;
                    --verifico si llego el maximo de numeros de interaciones
                    IF Ln_ContInteraciones >= Ln_MaxInteraciones THEN
                        Pv_Status := 'ERROR';
                        Lb_BanderaEnlace := TRUE;
                        EXIT;
                    END IF;
                END LOOP;
                --finalizar loop si se encontro el servicio
                IF Ln_IdServicio IS NOT NULL THEN
                    Pv_Status := 'OK';
                    EXIT;
                END IF;
            END LOOP;
        END IF;

        --verifico si se encontro el servicio
        IF Pv_Status = 'ERROR' THEN
            Pv_Mensaje := 'No se encontr贸 el enlace relacionado del servicio con login auxiliar ' ||
                          Lv_NombreElemento || ' con la serie ' || Lv_SerieFisica ||
                          ', por favor notificar a Sistemas.';
            RAISE Le_Errors;
        END IF;

        --verifico si el id del servicio esta vacio
        IF Ln_IdServicio IS NULL THEN
            Pv_Status := 'ERROR';
            Pv_Mensaje := 'No se encontr贸 ningun servicio asociado a este elemento ' || Lv_NombreElemento ||
                          ' con la serie ' || Lv_SerieFisica || ', por favor notificar a Sistemas.';
            RAISE Le_Errors;
        END IF;

        Lcl_Select  := 'SELECT SER.ID_SERVICIO, ELE.ID_ELEMENTO, PUN.LOGIN, SER.LOGIN_AUX, SER.ESTADO,
                        MAR.NOMBRE_MARCA_ELEMENTO MARCA, ELE.SERIE_FISICA SERIE, PRO.DESCRIPCION_PRODUCTO, MOD.NOMBRE_MODELO_ELEMENTO,
                        CAN.NOMBRE_CANTON CIUDAD, CAN.SIGLA SIGLA_CIUDAD, PER.RAZON_SOCIAL CLIENTE,
                        ( SELECT REMOD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET REMOD WHERE REMOD.VALOR1 = MOD.NOMBRE_MODELO_ELEMENTO
                          AND REMOD.PARAMETRO_ID = ( SELECT CREMOD.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB CREMOD
                            WHERE CREMOD.NOMBRE_PARAMETRO = ''' || Lv_ParametroModelo || ''' AND CREMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 )
                          AND REMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) MODELO,
                        ( SELECT PCOR.VALOR FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PCOR, DB_COMERCIAL.ADMI_FORMA_CONTACTO FCON
                          WHERE PCOR.FORMA_CONTACTO_ID = FCON.ID_FORMA_CONTACTO AND PCOR.ESTADO = ''' || Lv_EstadoActivo || '''
                          AND PCOR.PUNTO_ID = PUN.ID_PUNTO AND FCON.DESCRIPCION_FORMA_CONTACTO = ''' || Lv_FormaContacto || ''' AND ROWNUM = 1 ) CORREO,
                        ( SELECT CASE WHEN DELE.DETALLE_VALOR = ''' || Lv_StandAloneValor || ''' THEN ''SI'' ELSE ''NO'' END AS VALOR
                          FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DELE
                          WHERE DELE.ELEMENTO_ID = ELE.ID_ELEMENTO AND DELE.DETALLE_NOMBRE = ''' || Lv_StandAloneNombre || '''
                          AND DELE.DETALLE_DESCRIPCION = ''' || Lv_StandAloneDetalle || '''
                          AND DELE.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) ES_STAND_ALONE';
        Lcl_From    := ' FROM DB_COMERCIAL.INFO_SERVICIO SER, DB_COMERCIAL.INFO_PUNTO PUN, DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE,
                        DB_COMERCIAL.ADMI_PRODUCTO PRO, DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD, DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR,
                        DB_GENERAL.ADMI_SECTOR SEC, DB_GENERAL.ADMI_PARROQUIA PAR, DB_GENERAL.ADMI_CANTON CAN,
                        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERE, DB_COMERCIAL.INFO_PERSONA PER';
        Lcl_Where   := ' WHERE SER.PUNTO_ID = PUN.ID_PUNTO
                        AND SER.PRODUCTO_ID = PRO.ID_PRODUCTO
                        AND ELE.MODELO_ELEMENTO_ID = MOD.ID_MODELO_ELEMENTO
                        AND MOD.MARCA_ELEMENTO_ID = MAR.ID_MARCA_ELEMENTO
                        AND SEC.ID_SECTOR = PUN.SECTOR_ID
                        AND PAR.ID_PARROQUIA = SEC.PARROQUIA_ID
                        AND CAN.ID_CANTON = PAR.CANTON_ID
                        AND PERE.ID_PERSONA_ROL = PUN.PERSONA_EMPRESA_ROL_ID
                        AND PER.ID_PERSONA = PERE.PERSONA_ID';

        Lcl_Where := Lcl_Where || ' AND ELE.ID_ELEMENTO = ' || Ln_IdElemento;
        Lcl_Where := Lcl_Where || ' AND SER.ID_SERVICIO = ' || Ln_IdServicio;
        Lcl_Query := 'SELECT ID_SERVICIO, ID_ELEMENTO, LOGIN, LOGIN_AUX, ESTADO, MARCA, SERIE, DESCRIPCION_PRODUCTO, CORREO, ES_STAND_ALONE,
                      CASE WHEN MODELO IS NOT NULL THEN MODELO ELSE NOMBRE_MODELO_ELEMENTO END AS MODELO, CIUDAD, SIGLA_CIUDAD, CLIENTE
                      FROM ( ' || Lcl_Select || Lcl_From || Lcl_Where || ' )';
        OPEN Pcl_Response FOR Lcl_Query;

        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacci贸n exitosa';
    EXCEPTION
        WHEN Le_Errors THEN
            Pv_Status  := 'ERROR';
        WHEN OTHERS THEN
            Pv_Status  := 'ERROR';
            Pv_Mensaje := SQLERRM;
  END P_SERVICIO_POR_SERIE_ELEMENTO;

    PROCEDURE P_GET_SERVICIO_ACTIVAR_SERIE(Pv_Status OUT VARCHAR2,
                                   Pv_Mensaje         OUT VARCHAR2,
                                   Pcl_Response       OUT SYS_REFCURSOR)
    AS
      Lcl_Query                     CLOB;
      Lv_FormaContacto              VARCHAR2(30)    := 'Correo Electronico';
      Lv_EstadoActivo               VARCHAR2(10)    := 'Activo';
      Lv_EstadoPendiente            VARCHAR2(10)    := 'Pendiente';
      Lv_StandAloneNombre           VARCHAR2(15)    := 'PROPIEDAD';
      Lv_StandAloneDetalle          VARCHAR2(30)    := 'ELEMENTO PROPIEDAD DE';
      Lv_StandAloneValor            VARCHAR2(15)    := 'CLIENTE';
      Lv_MarcaElemento              VARCHAR2(20)    := 'FORTIGATE';
      Lv_TipoSolicitud              VARCHAR2(45)    := 'SOLICITUD RPA LICENCIA';
      Lv_ParametroModelo            VARCHAR2(64)    := 'NOMBRES_MODELOS_REEMPLAZAR_FORTIGATE_PORTAL';
      --
      BEGIN
          --formar el query
          Lcl_Query  := 'SELECT ID_DETALLE_SOLICITUD, ID_SERVICIO, ID_ELEMENTO, LOGIN, LOGIN_AUX, ESTADO, MARCA, SERIE, DESCRIPCION_PRODUCTO,
                            CASE WHEN MODELO IS NOT NULL THEN MODELO ELSE NOMBRE_MODELO_ELEMENTO END AS MODELO, CORREO, ES_STAND_ALONE,
                            CLIENTE, CIUDAD, SIGLA_CIUDAD
                         FROM (
                            SELECT SOL.ID_DETALLE_SOLICITUD, SER.ID_SERVICIO, ELE.ID_ELEMENTO, PUN.LOGIN, SER.LOGIN_AUX, SER.ESTADO,
                            MAR.NOMBRE_MARCA_ELEMENTO MARCA, ELE.SERIE_FISICA SERIE, PRO.DESCRIPCION_PRODUCTO, MOD.NOMBRE_MODELO_ELEMENTO,
                            CAN.NOMBRE_CANTON CIUDAD, CAN.SIGLA SIGLA_CIUDAD, PER.RAZON_SOCIAL CLIENTE,
                            ( SELECT REMOD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET REMOD WHERE REMOD.VALOR1 = MOD.NOMBRE_MODELO_ELEMENTO
                              AND REMOD.PARAMETRO_ID = ( SELECT CREMOD.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB CREMOD
                                WHERE CREMOD.NOMBRE_PARAMETRO = ''' || Lv_ParametroModelo || ''' AND CREMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 )
                              AND REMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) MODELO,
                            ( SELECT PCOR.VALOR FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PCOR, DB_COMERCIAL.ADMI_FORMA_CONTACTO FCON
                              WHERE PCOR.FORMA_CONTACTO_ID = FCON.ID_FORMA_CONTACTO AND PCOR.ESTADO = ''' || Lv_EstadoActivo || '''
                              AND PCOR.PUNTO_ID = PUN.ID_PUNTO AND FCON.DESCRIPCION_FORMA_CONTACTO = ''' || Lv_FormaContacto || ''' AND ROWNUM = 1 ) CORREO,
                            ( SELECT CASE WHEN DELE.DETALLE_VALOR = ''' || Lv_StandAloneValor || ''' THEN ''SI'' ELSE ''NO'' END AS VALOR
                              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DELE
                              WHERE DELE.ELEMENTO_ID = ELE.ID_ELEMENTO AND DELE.DETALLE_NOMBRE = ''' || Lv_StandAloneNombre || '''
                              AND DELE.DETALLE_DESCRIPCION = ''' || Lv_StandAloneDetalle || '''
                              AND DELE.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) ES_STAND_ALONE
                            FROM DB_COMERCIAL.INFO_SERVICIO SER, DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL, DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIP,
                            DB_COMERCIAL.INFO_PUNTO PUN, DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE, DB_COMERCIAL.ADMI_PRODUCTO PRO,
                            DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD, DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR,
                            DB_GENERAL.ADMI_SECTOR SEC, DB_GENERAL.ADMI_PARROQUIA PAR, DB_GENERAL.ADMI_CANTON CAN,
                            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERE, DB_COMERCIAL.INFO_PERSONA PER
                            WHERE TIP.DESCRIPCION_SOLICITUD = ''' || Lv_TipoSolicitud || '''
                            AND TIP.ID_TIPO_SOLICITUD = SOL.TIPO_SOLICITUD_ID
                            AND SER.ID_SERVICIO = SOL.SERVICIO_ID
                            AND SER.PUNTO_ID = PUN.ID_PUNTO
                            AND SER.PRODUCTO_ID = PRO.ID_PRODUCTO
                            AND ELE.NOMBRE_ELEMENTO = SER.LOGIN_AUX
                            AND ELE.MODELO_ELEMENTO_ID = MOD.ID_MODELO_ELEMENTO
                            AND MOD.MARCA_ELEMENTO_ID = MAR.ID_MARCA_ELEMENTO
                            AND SEC.ID_SECTOR = PUN.SECTOR_ID
                            AND PAR.ID_PARROQUIA = SEC.PARROQUIA_ID
                            AND CAN.ID_CANTON = PAR.CANTON_ID
                            AND PERE.ID_PERSONA_ROL = PUN.PERSONA_EMPRESA_ROL_ID
                            AND PER.ID_PERSONA = PERE.PERSONA_ID
                            AND MAR.NOMBRE_MARCA_ELEMENTO = ''' || Lv_MarcaElemento || '''
                            AND SOL.ESTADO = ''' || Lv_EstadoPendiente || '''
                            AND SER.ESTADO = ''' || Lv_EstadoActivo || '''
                            AND ELE.ESTADO = ''' || Lv_EstadoActivo || '''
                            ORDER BY SOL.FE_CREACION ASC
                        )
                        WHERE ROWNUM = 1';
          OPEN Pcl_Response FOR Lcl_Query;
          --resultados
          Pv_Status     := 'OK';
          Pv_Mensaje    := 'Transacci贸n exitosa';
      EXCEPTION
          WHEN OTHERS THEN
              Pv_Status  := 'ERROR';
              Pv_Mensaje := SQLERRM;
    END P_GET_SERVICIO_ACTIVAR_SERIE;

    PROCEDURE P_GET_SERVICIO_LICENCIA_RPA(Pv_Status    OUT VARCHAR2,
                                          Pv_Mensaje   OUT VARCHAR2,
                                          Pcl_Response OUT SYS_REFCURSOR)
    AS
      Lcl_Query                     CLOB;
      Lv_FormaContacto              VARCHAR2(30)    := 'Correo Electronico';
      Lv_EstadoActivo               VARCHAR2(10)    := 'Activo';
      Lv_EstadoCancel               VARCHAR2(10)    := 'Cancel';
      Lv_EstadoEliminado            VARCHAR2(10)    := 'Eliminado';
      Lv_EstadoPendiente            VARCHAR2(10)    := 'Pendiente';
      Lv_StandAloneNombre           VARCHAR2(15)    := 'PROPIEDAD';
      Lv_StandAloneDetalle          VARCHAR2(30)    := 'ELEMENTO PROPIEDAD DE';
      Lv_StandAloneValor            VARCHAR2(15)    := 'CLIENTE';
      Lv_MarcaElemento              VARCHAR2(20)    := 'FORTIGATE';
      Lv_TipoSolicitud              VARCHAR2(45)    := 'SOLICITUD RPA CANCELACION LICENCIA';
      Lv_ParametroModelo            VARCHAR2(64)    := 'NOMBRES_MODELOS_REEMPLAZAR_FORTIGATE_PORTAL';
      --
      BEGIN
          --formar el query
          Lcl_Query  := 'SELECT ID_DETALLE_SOLICITUD, ID_SERVICIO, ID_ELEMENTO, LOGIN, LOGIN_AUX, ESTADO, MARCA, SERIE, DESCRIPCION_PRODUCTO,
                            CASE WHEN MODELO IS NOT NULL THEN MODELO ELSE NOMBRE_MODELO_ELEMENTO END AS MODELO, CORREO, ES_STAND_ALONE,
                            CLIENTE, CIUDAD, SIGLA_CIUDAD
                         FROM (
                            SELECT SOL.ID_DETALLE_SOLICITUD, SER.ID_SERVICIO, ELE.ID_ELEMENTO, PUN.LOGIN, SER.LOGIN_AUX, SER.ESTADO,
                            MAR.NOMBRE_MARCA_ELEMENTO MARCA, ELE.SERIE_FISICA SERIE, PRO.DESCRIPCION_PRODUCTO, MOD.NOMBRE_MODELO_ELEMENTO,
                            CAN.NOMBRE_CANTON CIUDAD, CAN.SIGLA SIGLA_CIUDAD, PER.RAZON_SOCIAL CLIENTE,
                            ( SELECT REMOD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET REMOD WHERE REMOD.VALOR1 = MOD.NOMBRE_MODELO_ELEMENTO
                              AND REMOD.PARAMETRO_ID = ( SELECT CREMOD.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB CREMOD
                                WHERE CREMOD.NOMBRE_PARAMETRO = ''' || Lv_ParametroModelo || ''' AND CREMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 )
                              AND REMOD.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) MODELO,
                            ( SELECT PCOR.VALOR FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO PCOR, DB_COMERCIAL.ADMI_FORMA_CONTACTO FCON
                              WHERE PCOR.FORMA_CONTACTO_ID = FCON.ID_FORMA_CONTACTO AND PCOR.ESTADO = ''' || Lv_EstadoActivo || '''
                              AND PCOR.PUNTO_ID = PUN.ID_PUNTO AND FCON.DESCRIPCION_FORMA_CONTACTO = ''' || Lv_FormaContacto || ''' AND ROWNUM = 1 ) CORREO,
                            ( SELECT CASE WHEN DELE.DETALLE_VALOR = ''' || Lv_StandAloneValor || ''' THEN ''SI'' ELSE ''NO'' END AS VALOR
                              FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DELE
                              WHERE DELE.ELEMENTO_ID = ELE.ID_ELEMENTO AND DELE.DETALLE_NOMBRE = ''' || Lv_StandAloneNombre || '''
                              AND DELE.DETALLE_DESCRIPCION = ''' || Lv_StandAloneDetalle || '''
                              AND DELE.ESTADO = ''' || Lv_EstadoActivo || ''' AND ROWNUM = 1 ) ES_STAND_ALONE
                            FROM DB_COMERCIAL.INFO_SERVICIO SER, DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL, DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIP,
                            DB_COMERCIAL.INFO_PUNTO PUN, DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE, DB_COMERCIAL.ADMI_PRODUCTO PRO,
                            DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD, DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR,
                            DB_GENERAL.ADMI_SECTOR SEC, DB_GENERAL.ADMI_PARROQUIA PAR, DB_GENERAL.ADMI_CANTON CAN,
                            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERE, DB_COMERCIAL.INFO_PERSONA PER
                            WHERE TIP.DESCRIPCION_SOLICITUD = ''' || Lv_TipoSolicitud || '''
                            AND TIP.ID_TIPO_SOLICITUD = SOL.TIPO_SOLICITUD_ID
                            AND SER.ID_SERVICIO = SOL.SERVICIO_ID
                            AND SER.PUNTO_ID = PUN.ID_PUNTO
                            AND SER.PRODUCTO_ID = PRO.ID_PRODUCTO
                            AND ELE.NOMBRE_ELEMENTO = SER.LOGIN_AUX
                            AND ELE.MODELO_ELEMENTO_ID = MOD.ID_MODELO_ELEMENTO
                            AND MOD.MARCA_ELEMENTO_ID = MAR.ID_MARCA_ELEMENTO
                            AND SEC.ID_SECTOR = PUN.SECTOR_ID
                            AND PAR.ID_PARROQUIA = SEC.PARROQUIA_ID
                            AND CAN.ID_CANTON = PAR.CANTON_ID
                            AND PERE.ID_PERSONA_ROL = PUN.PERSONA_EMPRESA_ROL_ID
                            AND PER.ID_PERSONA = PERE.PERSONA_ID
                            AND MAR.NOMBRE_MARCA_ELEMENTO = ''' || Lv_MarcaElemento || '''
                            AND SOL.ESTADO = ''' || Lv_EstadoPendiente || '''
                            AND SER.ESTADO = ''' || Lv_EstadoCancel || '''
                            AND ( ELE.ESTADO = ''' || Lv_EstadoActivo || ''' OR ELE.ESTADO = ''' || Lv_EstadoEliminado || ''' )
                            ORDER BY SOL.FE_CREACION ASC, ELE.FE_CREACION DESC
                        )
                        WHERE ROWNUM = 1';
          OPEN Pcl_Response FOR Lcl_Query;
          --resultados
          Pv_Status     := 'OK';
          Pv_Mensaje    := 'Transacci贸n exitosa';
      EXCEPTION
          WHEN OTHERS THEN
              Pv_Status  := 'ERROR';
              Pv_Mensaje := SQLERRM;
    END P_GET_SERVICIO_LICENCIA_RPA;

/**
  * Documentaci贸n para el procedimiento P_GET_SERVICIO_ENVIO_CORREO
  *
  * M茅todo encargado de consultar y enviar correos de los datos del cliente/Pre-Cliente que realiza solicitud de Portabilidad
  *
  * @param Pv_Identificacion      IN  VARCHAR2 Ingresa la identificacion del cliente/Pre-Cliente
  * @param Pv_Destinatario        IN  VARCHAR2 Ingresa el correo del cliente/Pre-Cliente
  * @param Pv_Mensaje             OUT VARCHAR2 Retorna mensaje de exito o error del envio de correo
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.0 02-12-2022
  */
PROCEDURE P_GET_SERVICIO_ENVIO_CORREO(Pv_Identificacion    IN VARCHAR2,
                                          Pv_Destinatario      IN VARCHAR2,
                                          Pv_Mensaje           OUT VARCHAR2)
AS
  --
 
  Lv_MensajeError                 VARCHAR2(4000);
  Lrf_ServiciosCliente            SYS_REFCURSOR;
  Ln_TotalRegistros               NUMBER := 0;
  Ln_IndxServicios                NUMBER;
  Lv_Remitente                    VARCHAR2(100);
  Lv_AsuntoInicial                VARCHAR2(300);
  Lv_Asunto                       VARCHAR2(300);
  Lv_FechaArchivo                 VARCHAR2(20)   := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
  Lv_NombreArchivo                VARCHAR2(100) := '';
  Lv_NombreArchivoZip             VARCHAR2(100) := '';
  Lv_Delimitador                  VARCHAR2(1) := '|'; 
  Lf_Archivo                      utl_file.file_type;
  Lv_Gzip                         VARCHAR2(100) := '';
  Lcl_PlantillaReporte            CLOB; 
  Le_Exception                    EXCEPTION;
  Lv_EmpresaCod                   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
  Lt_TServiciosCliente            DB_COMERCIAL.CMKG_TYPES.T_ServiciosPersona;

  TYPE Lt_ParametrosDet           IS TABLE OF DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_Datos_Contacto_Persona       VARCHAR2(10000);
  Lv_Datos_Contacto_Punto         VARCHAR2(10000);--;
  Lv_Tipo_Cuenta                  VARCHAR2(100);
  Lv_EstadoActivo                 VARCHAR2(7) := 'Activo';
  Lv_NombreParamDirBdArchivosTmp  VARCHAR2(33) := 'DIRECTORIO_BD_ARCHIVOS_TEMPORALES';
  Lv_DirectorioBaseDatos          VARCHAR2(100);
  Lv_RutaDirectorioBaseDatos      VARCHAR2(500);
  Lv_NombreParamsServiciosMd      VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
  Lv_NombreParamRemitenteYAsunto  VARCHAR2(41) := 'REMITENTES_Y_ASUNTOS_CORREOS_POR_PROCESO';
  Lv_ProcesoRemitenteYAsunto      VARCHAR2(30) := 'PROCESOS_DERECHOS_DEL_TITULAR';
  Lv_anio_vencimiento             VARCHAR2(20);
  Lv_mes_vencimiento              VARCHAR2(20);
  Lv_KeyEncript                   VARCHAR2(300);
  Lr_RespuestaKeyEncriptBusq      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lr_ParametroDetalleBusqueda     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lrf_RespuestaKeyEncriptBusq     SYS_REFCURSOR;
  Ln_IndxParametrosDetKeyEncript  NUMBER;
  Lt_ParametrosDetKeyEncript      Lt_ParametrosDet;
  Lv_ValorNuevoNumCuenta          DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.NUMERO_CTA_TARJETA%TYPE;
  Lv_Num_Cuenta                   DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.NUMERO_CTA_TARJETA%TYPE;
  Lb_Fexists                      BOOLEAN;
  Ln_FileLength                   NUMBER;
  Lbi_BlockSize                   BINARY_INTEGER;
  Ln_Fila                         NUMBER := 2;
  Lv_NombreDirectorio            VARCHAR2(100);
  Lv_RutaDirectorio              VARCHAR2(100);
  Ln_NumeroColumnas              NUMBER := 28;
  Lv_Extension                   VARCHAR2(5)   := '.gz';
  Ln_limiteBulk                  CONSTANT PLS_INTEGER DEFAULT 5000;
  Li_Cont                       PLS_INTEGER;
  i                             PLS_INTEGER := 0;
  Lcl_QuerySelect               CLOB;
  Lcl_QueryFrom                 CLOB;
  Lcl_QueryWhere                CLOB;
  Lcl_Query                     CLOB;
  Lcl_union                     CLOB;
  Lcl_QuerySelectSecund         CLOB;
  Lcl_QueryFromSecund           CLOB;
  Lv_Where                      VARCHAR2(4000);
  Lv_WhereSecundario            VARCHAR2(4000);
  Lv_Nombre_Cliente             VARCHAR2(4000);
  

  CURSOR Lc_GetValoresParamsGeneral(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
    SELECT DET.VALOR1, DET.VALOR2
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
    ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO = Lv_EstadoActivo
    AND DET.ESTADO = Lv_EstadoActivo;

  CURSOR Lc_GetValorParamServiciosMd(   Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                        Cv_Valor2          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
  IS
    SELECT DET.VALOR3, DET.VALOR4, EMPRESA_COD
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
    ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO = Lv_EstadoActivo
    AND DET.VALOR1 = Cv_Valor1
    AND DET.VALOR2 = Cv_Valor2
    AND DET.ESTADO = Lv_EstadoActivo;

  
  CURSOR C_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
  IS
    SELECT
      AP.PLANTILLA
    FROM
      DB_COMUNICACION.ADMI_PLANTILLA AP 
    WHERE
      AP.CODIGO = Cv_CodigoPlantilla
    AND AP.ESTADO <> 'Eliminado';
    
    CURSOR Lc_GetFormasContactoPersona(Cv_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
    IS
    SELECT
        afc.DESCRIPCION_FORMA_CONTACTO as forma_contacto,
        IPFC .VALOR as contacto
    FROM
        DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc
        INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc ON
        IPFC .FORMA_CONTACTO_ID = afc.ID_FORMA_CONTACTO
    WHERE
        IPFC .PERSONA_ID = Cv_IdPersona;
        TYPE contactoPersona IS TABLE OF Lc_GetFormasContactoPersona%ROWTYPE INDEX BY PLS_INTEGER;
    
    CURSOR Lc_GetFormasContactoPunto(Cv_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
    SELECT
	afc.DESCRIPCION_FORMA_CONTACTO as forma_contacto,
	IPFC.VALOR as contacto
    FROM
        DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO ipfc
    INNER JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc ON
        IPFC .FORMA_CONTACTO_ID = afc.ID_FORMA_CONTACTO
    WHERE
        IPFC.PUNTO_ID = Cv_IdPunto;
   TYPE contactoPunto IS TABLE OF Lc_GetFormasContactoPunto%ROWTYPE INDEX BY PLS_INTEGER;
        
    CURSOR Lc_GetDetalleFormaPago(Cv_IdContrato DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.CONTRATO_ID%TYPE)
    IS
    SELECT TIPO_CUENTA.DESCRIPCION_CUENTA TIPO_CUENTA,
           TIPO_CUENTA.ES_TARJETA ES_TARJETA,
           CONTRATO_FORMA_PAGO.NUMERO_CTA_TARJETA NUM_CUENTA_TARJETA,
           CONTRATO_FORMA_PAGO.ANIO_VENCIMIENTO ANIO_VENCIMIENTO,
           CONTRATO_FORMA_PAGO.MES_VENCIMIENTO MES_VENCIMIENTO
    FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONTRATO_FORMA_PAGO
    INNER JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA BANCO_TIPO_CUENTA
    ON BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA = CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID
    LEFT JOIN DB_GENERAL.ADMI_BANCO BANCO
    ON BANCO.ID_BANCO = BANCO_TIPO_CUENTA.BANCO_ID
    LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA TIPO_CUENTA
    ON TIPO_CUENTA.ID_TIPO_CUENTA                      = CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID
    WHERE CONTRATO_FORMA_PAGO.CONTRATO_ID              = Cv_IdContrato;
    TYPE formaPago IS TABLE OF Lc_GetDetalleFormaPago%ROWTYPE INDEX BY PLS_INTEGER;
    
    Lr_RegGetDetalleFormaPago         Lc_GetDetalleFormaPago%ROWTYPE;
    Lr_RegGetFormasContactoPersona    Lc_GetFormasContactoPersona%ROWTYPE;
    Lr_RegGetFormasContactoPunto      Lc_GetFormasContactoPunto%ROWTYPE;
    Lr_RegGetValoresParamsGeneral     Lc_GetValoresParamsGeneral%ROWTYPE;
    Lr_RegGetValorParamServiciosMd    Lc_GetValorParamServiciosMd%ROWTYPE;
    
    Lc_ContactoPersona   contactoPersona;
    Lc_ContactoPunto     contactoPunto;
    Lc_FormaPago           formaPago;
     
  BEGIN
  
    OPEN Lc_GetValoresParamsGeneral(Lv_NombreParamDirBdArchivosTmp);
    FETCH Lc_GetValoresParamsGeneral INTO Lr_RegGetValoresParamsGeneral;
    CLOSE Lc_GetValoresParamsGeneral;
    Lv_DirectorioBaseDatos      := Lr_RegGetValoresParamsGeneral.VALOR1;
    
    IF Lv_DirectorioBaseDatos IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener el directorio para guardar los archivos csv';
      RAISE Le_Exception;
    END IF;
    Lv_RutaDirectorioBaseDatos  := Lr_RegGetValoresParamsGeneral.VALOR2;
    
    IF Lv_RutaDirectorioBaseDatos IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener la rura del directorio para guardar los archivos csv';
      RAISE Le_Exception;   
    END IF;
    
    OPEN Lc_GetValorParamServiciosMd(Lv_NombreParamsServiciosMd, Lv_NombreParamRemitenteYAsunto, Lv_ProcesoRemitenteYAsunto);
    FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetValorParamServiciosMd;
    CLOSE Lc_GetValorParamServiciosMd;
    Lv_Remitente        := Lr_RegGetValorParamServiciosMd.VALOR3;
    Lv_AsuntoInicial    := Lr_RegGetValorParamServiciosMd.VALOR4;
    Lv_EmpresaCod       := Lr_RegGetValorParamServiciosMd.EMPRESA_COD;
    
    IF Lv_Remitente IS NULL OR Lv_AsuntoInicial IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener el remitente y/o el asunto del correo para el proceso de portabilidad';
      RAISE Le_Exception;
    END IF;

    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    
    OPEN C_GetPlantilla('PORTABILIDAD');
    FETCH C_GetPlantilla INTO Lcl_PlantillaReporte;
    CLOSE C_GetPlantilla;
    
    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    
    --Parametros para encriptar y desencriptar claves
      Lv_ValorNuevoNumCuenta              := '';
      Lv_Num_Cuenta                       := '';
      Lr_ParametroDetalleBusqueda         := NULL;
      Lr_ParametroDetalleBusqueda.VALOR1  := 'KEY_SECRET_TELCOS';
      Lr_ParametroDetalleBusqueda.VALOR2  := NULL;
      Lr_ParametroDetalleBusqueda.VALOR3  := NULL;
      Lr_ParametroDetalleBusqueda.VALOR4  := NULL;
      Lr_ParametroDetalleBusqueda.VALOR5  := NULL;
      Lrf_RespuestaKeyEncriptBusq         := DB_COMERCIAL.TECNK_SERVICIOS.F_GET_PARAMS_SERVICIOS_MD(Lr_ParametroDetalleBusqueda);
      Lv_KeyEncript                       := '';
      
    FETCH Lrf_RespuestaKeyEncriptBusq BULK COLLECT INTO Lt_ParametrosDetKeyEncript LIMIT 1000;
    Ln_IndxParametrosDetKeyEncript := Lt_ParametrosDetKeyEncript.FIRST;
    WHILE (Ln_IndxParametrosDetKeyEncript IS NOT NULL)
    LOOP
      Lr_RespuestaKeyEncriptBusq      := Lt_ParametrosDetKeyEncript(Ln_IndxParametrosDetKeyEncript);
      Lv_KeyEncript                   := Lr_RespuestaKeyEncriptBusq.VALOR2;
      Ln_IndxParametrosDetKeyEncript  := Lt_ParametrosDetKeyEncript.NEXT(Ln_IndxParametrosDetKeyEncript);
    END LOOP;
    IF Lv_KeyEncript IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener la Key para encriptar y desencriptar las claves';
      RAISE Le_Exception;
    END IF;

      
            DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelect, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryFrom, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QuerySelectSecund, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryFromSecund, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_QueryWhere, TRUE);
            DBMS_LOB.CREATETEMPORARY(Lcl_Query, TRUE); 
            DBMS_LOB.CREATETEMPORARY(Lcl_union, TRUE); 
    
             DBMS_LOB.APPEND(Lcl_QuerySelect,'SELECT ip.ID_PERSONA ,
                                    ip.TIPO_IDENTIFICACION,
                                    ip.IDENTIFICACION_CLIENTE NUMERO_IDENTIFICACION,
                                    ip.NOMBRES,
                                    ip.APELLIDOS ,
                                    ip.RAZON_SOCIAL ,
                                    CASE                         
                                    WHEN ip.RAZON_SOCIAL IS NOT NULL THEN                         
                                    ip.RAZON_SOCIAL                          
                                    ELSE                         
                                    ip.NOMBRES || '' '' || ip.APELLIDOS                      
                                    END NOMBRE_COMPLETO,
                                    CASE ip.NACIONALIDAD
                                    WHEN ''NAC'' THEN ''Nacional''
                                    WHEN ''EXT'' THEN ''Extranjera''
                                    ELSE '' ''
                                    END as NACIONALIDAD,
                                    ipu.DIRECCION,
                                    ip.GENERO ,
                                    DB_COMERCIAL.CMKG_BENEFICIOS.F_GET_ES_CLIENTE_DISCAPACITADO(is2.ID_SERVICIO,iper.ID_PERSONA_ROL) DISCAPACIDAD,
                                    ip.REPRESENTANTE_LEGAL ,
                                    CASE ip.ORIGEN_INGRESOS
                                    WHEN ''B'' THEN ''Empleado Publico''
                                    WHEN ''V'' THEN ''Empleado Privado''
                                    WHEN ''I'' THEN ''Independiente''
                                    WHEN ''A'' THEN ''Ama de casa o estudiante''
                                    WHEN ''R'' THEN ''Rentista''
                                    WHEN ''J'' THEN ''Jubilado''
                                    WHEN ''I'' THEN ''Independiente''
                                    ELSE ''Remesas del exterior''
                                    END as ORIGEN_INGRESOS,
                                    ipu.ID_PUNTO,
                                    ipu.LATITUD COORDENADA_LATITUD_PUNTO,
                                    ipu.LONGITUD COORDENADA_LONGITUD_PUNTO,
                                    ap2.NOMBRE_PROVINCIA PROVINCIA_PUNTO,
                                    ac.NOMBRE_CANTON CIUDAD_PUNTO,
                                    ac.NOMBRE_CANTON CANTON_PUNTO,
                                    ap.NOMBRE_PARROQUIA PARROQUIA_PUNTO	,
                                    as2.NOMBRE_SECTOR SECTOR_PUNTO,
                                    atu.DESCRIPCION_TIPO_UBICACION TIPO_UBICACION_PUNTO,
                                    ipc.NOMBRE_PLAN NOMBRE_PLAN,
                                    ipu.ESTADO ESTADO_PUNTO,
                                    afp.DESCRIPCION_FORMA_PAGO,
                                    is2.ID_SERVICIO SERVICIO,
                                    IC.ID_CONTRATO');
                            
        DBMS_LOB.APPEND(Lcl_QueryFrom,' FROM DB_COMERCIAL.INFO_PERSONA ip 
                                INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper ON ip.ID_PERSONA = iper.PERSONA_ID 
                                INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier ON iper.EMPRESA_ROL_ID = ier.ID_EMPRESA_ROL 
                                INNER JOIN DB_COMERCIAL.INFO_PUNTO ipu ON iper.ID_PERSONA_ROL = ipu.PERSONA_EMPRESA_ROL_ID  
                                INNER JOIN DB_GENERAL.ADMI_SECTOR as2 ON ipu.SECTOR_ID = as2.ID_SECTOR 
                                INNER JOIN DB_GENERAL.ADMI_PARROQUIA ap ON as2.PARROQUIA_ID  = ap.ID_PARROQUIA 
                                INNER JOIN DB_GENERAL.ADMI_CANTON ac ON ap.CANTON_ID = ac.ID_CANTON 
                                INNER JOIN DB_GENERAL.ADMI_PROVINCIA ap2 ON ac.PROVINCIA_ID = ap2.ID_PROVINCIA 
                                INNER JOIN DB_COMERCIAL.ADMI_TIPO_UBICACION atu ON ipu.TIPO_UBICACION_ID = atu.ID_TIPO_UBICACION
                                INNER JOIN DB_COMERCIAL.INFO_SERVICIO is2 ON ipu.ID_PUNTO = is2.PUNTO_ID 
                                INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc ON is2.PLAN_ID = ipc.ID_PLAN 
                                INNER JOIN DB_COMERCIAL.INFO_CONTRATO ic ON iper.ID_PERSONA_ROL = ic.PERSONA_EMPRESA_ROL_ID 
                                INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO afp ON ic.FORMA_PAGO_ID = afp.ID_FORMA_PAGO'); 
                            
        DBMS_LOB.APPEND(Lcl_union, ' UNION ');
        DBMS_LOB.APPEND(Lcl_QuerySelectSecund, ' SELECT ip.ID_PERSONA ,
                                ip.TIPO_IDENTIFICACION,
                                ip.IDENTIFICACION_CLIENTE NUMERO_IDENTIFICACION,
                                ip.NOMBRES,
                                ip.APELLIDOS ,
                                ip.RAZON_SOCIAL ,
                                CASE                         
                                  WHEN ip.RAZON_SOCIAL IS NOT NULL THEN                         
                                  ip.RAZON_SOCIAL                          
                                  ELSE                         
                                  ip.NOMBRES || '' '' || ip.APELLIDOS                      
                                  END NOMBRE_COMPLETO,
                                CASE ip.NACIONALIDAD
                                WHEN ''NAC'' THEN ''Nacional''
                                WHEN ''EXT'' THEN ''Extranjera''
                                ELSE '' ''
                                END as NACIONALIDAD,
                                ipu.DIRECCION,
                                ip.GENERO,
                                DB_COMERCIAL.CMKG_BENEFICIOS.F_GET_ES_CLIENTE_DISCAPACITADO(is2.ID_SERVICIO,iper.ID_PERSONA_ROL) DISCAPACIDAD,
                                ip.REPRESENTANTE_LEGAL ,
                                CASE ip.ORIGEN_INGRESOS
                                WHEN ''B'' THEN ''Empleado Publico''
                                WHEN ''V'' THEN ''Empleado Privado''
                                WHEN ''I'' THEN ''Independiente''
                                WHEN ''A'' THEN ''Ama de casa o estudiante''
                                WHEN ''R'' THEN ''Rentista''
                                WHEN ''J'' THEN ''Jubilado''
                                WHEN ''I'' THEN ''Independiente''
                                ELSE ''Remesas del exterior''
                                END as ORIGEN_INGRESOS,
                                ipu.ID_PUNTO,
                                ipu.LATITUD COORDENADA_LATITUD_PUNTO,
                                ipu.LONGITUD COORDENADA_LONGITUD_PUNTO,
                                ap2.NOMBRE_PROVINCIA PROVINCIA_PUNTO,
                                ac.NOMBRE_CANTON CIUDAD_PUNTO,
                                ac.NOMBRE_CANTON CANTON_PUNTO,
                                ap.NOMBRE_PARROQUIA PARROQUIA_PUNTO	,
                                as2.NOMBRE_SECTOR SECTOR_PUNTO,
                                atu.DESCRIPCION_TIPO_UBICACION TIPO_UBICACION_PUNTO,
                                apro.DESCRIPCION_PRODUCTO NOMBRE_PLAN,
                                ipu.ESTADO ESTADO_PUNTO,
                                afp.DESCRIPCION_FORMA_PAGO,
                                is2.ID_SERVICIO SERVICIO,
                                IC.ID_CONTRATO');
                                
        DBMS_LOB.APPEND(Lcl_QueryFromSecund, ' FROM DB_COMERCIAL.INFO_PERSONA ip 
                                INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper ON ip.ID_PERSONA = iper.PERSONA_ID 
                                INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier ON iper.EMPRESA_ROL_ID = ier.ID_EMPRESA_ROL 
                                INNER JOIN DB_COMERCIAL.INFO_PUNTO ipu ON iper.ID_PERSONA_ROL = ipu.PERSONA_EMPRESA_ROL_ID  
                                INNER JOIN DB_GENERAL.ADMI_SECTOR as2 ON ipu.SECTOR_ID = as2.ID_SECTOR 
                                INNER JOIN DB_GENERAL.ADMI_PARROQUIA ap ON as2.PARROQUIA_ID  = ap.ID_PARROQUIA 
                                INNER JOIN DB_GENERAL.ADMI_CANTON ac ON ap.CANTON_ID = ac.ID_CANTON 
                                INNER JOIN DB_GENERAL.ADMI_PROVINCIA ap2 ON ac.PROVINCIA_ID = ap2.ID_PROVINCIA 
                                INNER JOIN DB_COMERCIAL.ADMI_TIPO_UBICACION atu ON ipu.TIPO_UBICACION_ID = atu.ID_TIPO_UBICACION
                                INNER JOIN DB_COMERCIAL.INFO_SERVICIO is2 ON ipu.ID_PUNTO = is2.PUNTO_ID 
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO apro ON is2.PRODUCTO_ID = apro.ID_PRODUCTO 
                                INNER JOIN DB_COMERCIAL.INFO_CONTRATO ic ON iper.ID_PERSONA_ROL = ic.PERSONA_EMPRESA_ROL_ID 
                                INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO afp ON ic.FORMA_PAGO_ID = afp.ID_FORMA_PAGO');
                            
                            
               Lv_Where            := ' WHERE ip.IDENTIFICACION_CLIENTE = '':Lv_Identificacion''';      
               Lv_Where            := REPLACE(Lv_Where,':Lv_Identificacion', Pv_Identificacion);
            DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_Where);     
            
               Lv_WhereSecundario  := ' AND ier.EMPRESA_COD  = '':Lv_EmpresaCod''';
               Lv_WhereSecundario  := REPLACE(Lv_WhereSecundario,':Lv_EmpresaCod', Lv_EmpresaCod);
            DBMS_LOB.APPEND(Lcl_QueryWhere,Lv_WhereSecundario); 
   
    
      
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelect);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFrom);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_union);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QuerySelectSecund);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryFromSecund);
        DBMS_LOB.APPEND(Lcl_Query,Lcl_QueryWhere);
      
            
            DB_GENERAL.GNKG_AS_XLSX.CLEAR_WORKBOOK;
            DB_GENERAL.GNKG_AS_XLSX.NEW_SHEET(P_SHEETNAME => 'Datos Persona Derechos del Titular');
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(1,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(2,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(3,35);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(4,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(5,50);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(6,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(7,55);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(8,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(9,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(10,50);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(11,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(12,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(13,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(14,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(15,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(16,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(17,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(18,30);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(19,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(20,50);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(21,50);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(22,60);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(23,25);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(24,25);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(25,25);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(26,25);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(27,20);
            DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(28,20);
                    
            --Columnas del reporte.
            DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
              P_ROW       => 1,
              P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 10, P_NAME => 'LKLUG', P_RGB => 'FFFFFF'),
              P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
              P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
              P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => '888888'));
            DB_GENERAL.GNKG_AS_XLSX.CELL(1,1,'TIPO_IDENTIFICACION');
            DB_GENERAL.GNKG_AS_XLSX.CELL(2,1,'NUMERO_IDENTIFICACION');
            DB_GENERAL.GNKG_AS_XLSX.CELL(3,1,'NOMBRES');
            DB_GENERAL.GNKG_AS_XLSX.CELL(4,1,'APELLIDOS');
            DB_GENERAL.GNKG_AS_XLSX.CELL(5,1,'RAZON_SOCIAL');
            DB_GENERAL.GNKG_AS_XLSX.CELL(6,1,'NACIONALIDAD');
            DB_GENERAL.GNKG_AS_XLSX.CELL(7,1,'DIRECCION');
            DB_GENERAL.GNKG_AS_XLSX.CELL(8,1,'GENERO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(9,1,'DISCAPACIDAD');
            DB_GENERAL.GNKG_AS_XLSX.CELL(10,1,'REPRESENTANTE_LEGAL');
            DB_GENERAL.GNKG_AS_XLSX.CELL(11,1,'ORIGEN_INGRESOS');
            DB_GENERAL.GNKG_AS_XLSX.CELL(12,1,'COORDENADA_LATITUD_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(13,1,'COORDENADA_LONGITUD_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(14,1,'PROVINCIA_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(15,1,'CIUDAD_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(16,1,'CANTON_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(17,1,'PARROQUIA_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(18,1,'SECTOR_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(19,1,'TIPO_UBICACION_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(20,1,'DATOS_CONTACTO_PERSONA');
            DB_GENERAL.GNKG_AS_XLSX.CELL(21,1,'DATOS_CONTACTO_PUNTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(22,1,'NOMBRE_PLAN');
            DB_GENERAL.GNKG_AS_XLSX.CELL(23,1,'ESTADO DEL PUNTO');            
            DB_GENERAL.GNKG_AS_XLSX.CELL(24,1,'FORMA DE PAGO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(25,1,'TIPO_DE_CUENTA');
            DB_GENERAL.GNKG_AS_XLSX.CELL(26,1,'NO_TARJETA/CUENTA');
            DB_GENERAL.GNKG_AS_XLSX.CELL(27,1,'MES_VENCIMIENTO');
            DB_GENERAL.GNKG_AS_XLSX.CELL(28,1,'A脩O_VENCIMIENTO');
                    
         
          OPEN Lrf_ServiciosCliente FOR Lcl_Query;
            LOOP
              FETCH Lrf_ServiciosCliente BULK COLLECT INTO Lt_TServiciosCliente LIMIT Ln_limiteBulk;
                Li_Cont := Lt_TServiciosCliente.FIRST;
                WHILE (Li_Cont IS NOT NULL) LOOP
          
                OPEN Lc_GetFormasContactoPersona(Lt_TServiciosCliente(Li_Cont).ID_PERSONA);
                LOOP
                  FETCH Lc_GetFormasContactoPersona BULK COLLECT INTO Lc_ContactoPersona LIMIT Ln_limiteBulk;
                  EXIT WHEN Lc_ContactoPersona.COUNT = 0;
                  BEGIN
                  i := Lc_ContactoPersona.FIRST;
                    WHILE (i IS NOT NULL) LOOP
                        IF Lc_ContactoPersona(i).forma_contacto IS NOT NULL THEN
                           Lv_Datos_Contacto_Persona := Lv_Datos_Contacto_Persona||Lc_ContactoPersona(i).forma_contacto||': '||Lc_ContactoPersona(i).contacto  ||' ; '||chr(13);
                        END IF;
                    i := Lc_ContactoPersona.NEXT(i);
                    END LOOP;
                  END;
                END LOOP;
               CLOSE Lc_GetFormasContactoPersona;
           
           
               --forma de contacto punto
               OPEN Lc_GetFormasContactoPunto(Lt_TServiciosCliente(Li_Cont).ID_PUNTO);
                LOOP
                  FETCH Lc_GetFormasContactoPunto BULK COLLECT INTO Lc_ContactoPunto LIMIT Ln_limiteBulk;
                  EXIT WHEN Lc_ContactoPunto.COUNT = 0;
                  BEGIN
                  i := Lc_ContactoPunto.FIRST;
                    WHILE (i IS NOT NULL) LOOP
                    
                        IF Lc_ContactoPunto(i).forma_contacto IS NOT NULL THEN
                           Lv_Datos_Contacto_Punto := Lv_Datos_Contacto_Punto||Lc_ContactoPunto(i).forma_contacto||': '||Lc_ContactoPunto(i).contacto  ||' ; '||chr(13) ;
                        END IF;
                    i := Lc_ContactoPunto.NEXT(i);
                    END LOOP;
                  END;
                END LOOP;
               CLOSE Lc_GetFormasContactoPunto;
            

            --Valida la forma de Pago para incluir valores en caso de DebitoBancario
            IF  Lt_TServiciosCliente(Li_Cont).DESCRIPCION_FORMA_PAGO = 'DEBITO BANCARIO' THEN
            
                --Cursor para obtener informacion de DebitosBancarios
                OPEN Lc_GetDetalleFormaPago(Lt_TServiciosCliente(Li_Cont).ID_CONTRATO);
                LOOP
                  FETCH Lc_GetDetalleFormaPago BULK COLLECT INTO Lc_FormaPago LIMIT Ln_limiteBulk;
                  EXIT WHEN Lc_FormaPago.COUNT = 0;
                  BEGIN
                  i := Lc_FormaPago.FIRST;
                    WHILE (i IS NOT NULL) LOOP
                    DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_DESCENCRIPTAR(Lc_FormaPago(i).NUM_CUENTA_TARJETA,
                                                                         Lv_KeyEncript,
                                                                         Lv_Num_Cuenta);
                        Lv_ValorNuevoNumCuenta := REPLACE(Lv_Num_Cuenta, substr((Lv_Num_Cuenta), 4, LENGTH(Lv_Num_Cuenta)-6), 
                                                  lpad('X', LENGTH(Lv_Num_Cuenta)-6,'X'));  
                          
                        Lv_Tipo_Cuenta := Lc_FormaPago(i).TIPO_CUENTA;
                        
                        if Lc_FormaPago(i).ES_TARJETA = 'S' THEN
                                                   
                        Lv_Anio_Vencimiento := rpad(substr((Lc_FormaPago(i).ANIO_VENCIMIENTO),1,
                                               LENGTH(Lc_FormaPago(i).ANIO_VENCIMIENTO)-1),LENGTH(Lc_FormaPago(i).ANIO_VENCIMIENTO),'X');
                        Lv_Mes_Vencimiento := Lc_FormaPago(i).MES_VENCIMIENTO;
                           
                        END IF;
                i := Lc_FormaPago.NEXT(i);
                END LOOP;
              END;
            END LOOP;
           CLOSE Lc_GetDetalleFormaPago;
                
        ELSE
            Lv_Tipo_Cuenta          := '';
            Lv_ValorNuevoNumCuenta  := '';
            Lv_Mes_Vencimiento      := '';
            Lv_Anio_Vencimiento     := '';
        END IF;
            
            
            DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
            P_ROW       => Ln_Fila,
            P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => '000000'),
            P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
            P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
            P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
            DB_GENERAL.GNKG_AS_XLSX.CELL(1,Ln_Fila,Lt_TServiciosCliente(Li_Cont).TIPO_IDENTIFICACION);
            DB_GENERAL.GNKG_AS_XLSX.CELL(2,Ln_Fila,Lt_TServiciosCliente(Li_Cont).NUMERO_IDENTIFICACION);
            DB_GENERAL.GNKG_AS_XLSX.CELL(3,Ln_Fila,Lt_TServiciosCliente(Li_Cont).NOMBRES);
            DB_GENERAL.GNKG_AS_XLSX.CELL(4,Ln_Fila,Lt_TServiciosCliente(Li_Cont).APELLIDOS);
            DB_GENERAL.GNKG_AS_XLSX.CELL(5,Ln_Fila,Lt_TServiciosCliente(Li_Cont).RAZON_SOCIAL);
            DB_GENERAL.GNKG_AS_XLSX.CELL(6,Ln_Fila,Lt_TServiciosCliente(Li_Cont).NACIONALIDAD);
            DB_GENERAL.GNKG_AS_XLSX.CELL(7,Ln_Fila,Lt_TServiciosCliente(Li_Cont).DIRECCION);
            DB_GENERAL.GNKG_AS_XLSX.CELL(8,Ln_Fila,Lt_TServiciosCliente(Li_Cont).GENERO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(9,Ln_Fila,Lt_TServiciosCliente(Li_Cont).DISCAPACIDAD);
            DB_GENERAL.GNKG_AS_XLSX.CELL(10,Ln_Fila,Lt_TServiciosCliente(Li_Cont).REPRESENTANTE_LEGAL);
            DB_GENERAL.GNKG_AS_XLSX.CELL(11,Ln_Fila,Lt_TServiciosCliente(Li_Cont).ORIGEN_INGRESOS);
            DB_GENERAL.GNKG_AS_XLSX.CELL(12,Ln_Fila,Lt_TServiciosCliente(Li_Cont).COORDENADA_LATITUD_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(13,Ln_Fila,Lt_TServiciosCliente(Li_Cont).COORDENADA_LONGITUD_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(14,Ln_Fila,Lt_TServiciosCliente(Li_Cont).PROVINCIA_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(15,Ln_Fila,Lt_TServiciosCliente(Li_Cont).CIUDAD_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(16,Ln_Fila,Lt_TServiciosCliente(Li_Cont).CANTON_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(17,Ln_Fila,Lt_TServiciosCliente(Li_Cont).PARROQUIA_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(18,Ln_Fila,Lt_TServiciosCliente(Li_Cont).SECTOR_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(19,Ln_Fila,Lt_TServiciosCliente(Li_Cont).TIPO_UBICACION_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(20,Ln_Fila,Lv_Datos_Contacto_Persona);
            DB_GENERAL.GNKG_AS_XLSX.CELL(21,Ln_Fila,Lv_Datos_Contacto_Punto);
            DB_GENERAL.GNKG_AS_XLSX.CELL(22,Ln_Fila,Lt_TServiciosCliente(Li_Cont).NOMBRE_PLAN);
            DB_GENERAL.GNKG_AS_XLSX.CELL(23,Ln_Fila,Lt_TServiciosCliente(Li_Cont).ESTADO_PUNTO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(24,Ln_Fila,Lt_TServiciosCliente(Li_Cont).DESCRIPCION_FORMA_PAGO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(25,Ln_Fila,Lv_Tipo_Cuenta);
            DB_GENERAL.GNKG_AS_XLSX.CELL(26,Ln_Fila,Lv_ValorNuevoNumCuenta);
            DB_GENERAL.GNKG_AS_XLSX.CELL(27,Ln_Fila,Lv_Mes_Vencimiento);
            DB_GENERAL.GNKG_AS_XLSX.CELL(28,Ln_Fila,Lv_Anio_Vencimiento);
            Ln_Fila := Ln_Fila + 1;
            Lv_Nombre_Cliente := Lt_TServiciosCliente(Li_Cont).NOMBRE_COMPLETO;
              Li_Cont:= Lt_TServiciosCliente.NEXT(Li_Cont);
            END LOOP;
            
          EXIT WHEN Lrf_ServiciosCliente%NOTFOUND;
        END LOOP;                              
        
          --Fin de la creaci贸n del Archivo.
            Lv_NombreArchivo := 'REPORTE_DATOS_CLIENTE.xlsx';
            DB_GENERAL.GNKG_AS_XLSX.SAVE(Lv_DirectorioBaseDatos,Lv_NombreArchivo);
        
           
          
          Lcl_PlantillaReporte := REPLACE(Lcl_PlantillaReporte,'{{CLIENTE}}', Lv_Nombre_Cliente );
          
          DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                    Pv_Destinatario||',',
                                                    Lv_AsuntoInicial, 
                                                    Lcl_PlantillaReporte, 
                                                    Lv_DirectorioBaseDatos,
                                                    Lv_NombreArchivo);
        
          --Eliminaci贸n del archivo xlsx.
            UTL_FILE.FGETATTR(Lv_DirectorioBaseDatos, Lv_NombreArchivo, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
            IF Lb_Fexists THEN
              UTL_FILE.FREMOVE(Lv_DirectorioBaseDatos,Lv_NombreArchivo);
              DBMS_OUTPUT.PUT_LINE('Archivo '||Lv_NombreArchivo||' eliminado.');
            END IF;
        
 

    IF TRIM(Lv_MensajeError) IS NOT NULL THEN
      Pv_Mensaje := Lv_MensajeError;
      RAISE Le_Exception;
    END IF;
    Pv_Mensaje := 'OK';
EXCEPTION
WHEN Le_Exception THEN
  --
  ROLLBACK;
  --
  Pv_Mensaje := Lv_MensajeError;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'COMEK_CONSULTAS.P_GET_SERVICIO_ENVIO_CORREO', 
                                        Lv_MensajeError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                                        
WHEN OTHERS THEN
  --
  ROLLBACK;
  --
  Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  Pv_Mensaje := 'Error al ejecutar el proceso de envio de correo';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'COMEK_CONSULTAS.P_GET_SERVICIO_ENVIO_CORREO', 
                                         SUBSTR(Lv_MensajeError,1,3000), 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                                   
  --
END P_GET_SERVICIO_ENVIO_CORREO;

/**
  * Documentaci贸n para el procedimiento P_ENVIO_CORREO_LOPDP
  *
  * M茅todo encargado de  enviar correos de los datos del cliente que realiza solicitud de Oposicion
  * Suspension de Tratamiento y Detencion Suspension de tratamiento
  *
  * @param Pv_Cliente             IN  VARCHAR2 Ingresa el nombre del cliente
  * @param Pv_Destinatario        IN  VARCHAR2 Ingresa el correo del cliente
  * @param Pv_Mensaje             OUT VARCHAR2 Retorna mensaje de exito o error del envio de correo
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.0 02-12-2022
  */  
PROCEDURE P_ENVIO_CORREO_LOPDP(Pv_Cliente           IN VARCHAR2,
                               Pv_Destinatario      IN VARCHAR2,
                               Pv_Mensaje           OUT VARCHAR2)
  AS
    Lv_NombreParamsServiciosMd      VARCHAR2(35) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';
    Lv_NombreParamRemitenteYAsunto  VARCHAR2(41) := 'REMITENTES_Y_ASUNTOS_CORREOS_POR_PROCESO';
    Lv_ProcesoRemitenteYAsunto      VARCHAR2(30) := 'PROCESOS_DERECHOS_DEL_TITULAR';
    Lv_MensajeError                 VARCHAR2(4000);
    Lcl_PlantillaReporte            CLOB; 
    Lv_EstadoActivo                 VARCHAR2(7) := 'Activo';
    Lv_PlantillaInicial             VARCHAR2(4000);
    Lv_PlantillaCorreo              VARCHAR2(4000);
    Lv_ContenidoCorreo              VARCHAR2(4000);
    Lv_Asunto                       VARCHAR2(500);
    Lv_Remitente                    VARCHAR2(50);
    Le_Exception                    EXCEPTION;
    
    CURSOR C_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
     IS
    SELECT
      AP.PLANTILLA
    FROM
      DB_COMUNICACION.ADMI_PLANTILLA AP 
    WHERE
      AP.CODIGO = Cv_CodigoPlantilla
    AND AP.ESTADO <> 'Eliminado';
   
    CURSOR Lc_GetValorParamServiciosMd(   Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                        Cv_Valor1          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                        Cv_Valor2          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
     IS
    SELECT DET.VALOR3, DET.VALOR4, EMPRESA_COD
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
    INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
    ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO = Lv_EstadoActivo
    AND DET.VALOR1 = Cv_Valor1
    AND DET.VALOR2 = Cv_Valor2
    AND DET.ESTADO = Lv_EstadoActivo;
    Lr_RegGetValorParamServiciosMd    Lc_GetValorParamServiciosMd%ROWTYPE;
    
    

  BEGIN
    OPEN Lc_GetValorParamServiciosMd(Lv_NombreParamsServiciosMd, Lv_NombreParamRemitenteYAsunto, Lv_ProcesoRemitenteYAsunto);
    FETCH Lc_GetValorParamServiciosMd INTO Lr_RegGetValorParamServiciosMd;
    CLOSE Lc_GetValorParamServiciosMd;
    Lv_Remitente        := Lr_RegGetValorParamServiciosMd.VALOR3;
    Lv_Asunto           := Lr_RegGetValorParamServiciosMd.VALOR4;
    
    IF Lv_Remitente IS NULL OR Lv_Asunto IS NULL THEN
      Lv_MensajeError := 'No se ha podido obtener el remitente y/o el asunto del correo para el proceso de portabilidad';
      RAISE Le_Exception;
    END IF;

    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    
    OPEN C_GetPlantilla('DERECHO_TITULAR');
    FETCH C_GetPlantilla INTO Lcl_PlantillaReporte;
    CLOSE C_GetPlantilla;
    
    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    
    Lcl_PlantillaReporte  := REPLACE(Lcl_PlantillaReporte,'{{CLIENTE}}', Pv_Cliente);
    
    
    UTL_MAIL.SEND (   SENDER      => Lv_Remitente, 
                      RECIPIENTS  => Pv_Destinatario|| ',', 
                      SUBJECT     => Lv_Asunto,
                      MESSAGE     => SUBSTR(Lcl_PlantillaReporte, 1, 32767),
                      MIME_TYPE   => 'text/html; charset=iso-8859-1');
    Pv_Mensaje   := 'OK';
  EXCEPTION
  WHEN OTHERS THEN
    Pv_Mensaje  := 'No se ha podido realizar el env驴o del correo';
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'COMEK_CONSULTAS.P_ENVIO_CORREO_LOPDP', 
                                            'No se ha podido realizar el env驴o del correo del cliente' || Pv_Cliente
                                            || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_ENVIO_CORREO_LOPDP;

END COMEK_CONSULTAS;
/
