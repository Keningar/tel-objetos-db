SET DEFINE OFF
CREATE OR REPLACE PACKAGE DB_COMERCIAL.COMEK_TRANSACTION
AS
  --
  /**
  * Documentación para FUNCTION 'P_GET_RESTRIC_PLAN_INST'.
  *
  * Procedimiento que verifica si existen restricciones por planes a los cuales no se cobra instalación y por planes que se cobra la instalación
  * en su totalidad, obtiene booleano que especÍfica si es Plan por restricción y el descuento que se aplicará según el parámetro
  *
  * Costo Query C_GetRegexpLike:2
  *
  * PARAMETROS:
  * @Param Pv_NombrePlan           IN DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
  * @Param Pb_PlanConRestriccion   OUT BOOLEAN,
  * @Param Pn_PorcentajeDescuento  OUT NUMBER,
  * @Param Pv_Observacion          OUT VARCHAR2
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 19-09-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 10-12-2020 - Se agrega parametro se salida que será utilizado en los proceso de promociones tentativas para MD.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.2
  * @since 06-03-2023  Se agrega parámetro Pv_EmpresaCod en el proceso para filtrar el resultado por empresa.
  */
  PROCEDURE P_GET_RESTRIC_PLAN_INST(Pv_NombrePlan           IN DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
                                    Pv_EmpresaCod           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pb_PlanConRestriccion   OUT BOOLEAN,
                                    Pn_PorcentajeDescuento  OUT NUMBER,
                                    Pv_Observacion          OUT VARCHAR2);
   /**
   * Documentación para el procedimiento P_OBTIENE_PUNTOS_ADICIONALES:
   * Procedimiento que obtiene los servicios Factibles asociados a Puntos (Logines) con rol "Cliente" y con contrato activo
   * que serán considerados para la generación de Facturas de Instalación.
   * 
   * Costo Query C_GetParamNumDiasFecAlcance:3
   * Costo Query C_GetParamTipoSol:4
   *
   * @param Pv_EmpresaCod  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
   * @param Pv_Mensaje     OUT VARCHAR2
   * @author Katherine Yager <kyager@telconet.ec>
   * @version 1.0
   * @since 27-09-2019
   * 
   * @author Katherine Yager <kyager@telconet.ec>
   * @version 1.1 05-12-2019 - Se modifica query para obtener la data a procesar con servicios estado Factible en el historial del día
   * y servicios con estados parametrizados, se parametrizan los días de Sysdate a consultar en el query.
   * 
   * @version 1.6  19-12-2019
   * @author Katherine Yager <kyager@telconet.ec>
   * Se realizan cambios en query que obtiene servicios, cambiando el TO_CHAR por TO_DATE
   *
   * @version 1.7  12-03-2020
   * @author José Candelario <jcandelario@telconet.ec>
   * Se realizan cambios en query que obtiene servicios, se agrega filtro que el servicio no cuente con una característica de Reingreso
   * de OS automática.
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.8
   * @since 01-03-2023  Se agrega parámetro CvEmpresaCod en los cursores C_GetParamNumDiasFecAlcance, C_GetParamTipoSol,
   *                    para filtrar el resultado por empresa.
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 1.9
   * @since 20-04-2023  Se modifica query principal que obtiene servicios, reemplazando la funcion F_GET_DESCRIPCION_ROL, por un subquery 
   *                    que obtiene la descripcion del rol en la consulta.
   *
   * @author Hector Lozano <hlozano@telconet.ec>
   * @version 2.0
   * @since 27-04-2023  Se elimina la sentencia TRUNC en los campos fechas del query principal que obtiene los servicios, para disminuir el costo.
   */
   PROCEDURE P_OBTIENE_PUNTOS_ADICIONALES(Pv_EmpresaCod  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                          Pv_Mensaje     OUT VARCHAR2);
                                              
  /**
  * Documentación para TYPE 'Lr_PuntosAdicionales'.
  * Record que me permite devolver los valores del servicio y punto adicional.
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 27-09-2019
  */

  TYPE Lr_PuntosAdicionales IS RECORD(
    ID_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_PUNTO    DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
    );
    
  /**
  * Documentación para TYPE 'T_PuntosAdicionales'.  
  * 
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 27-09-2019
  */
  TYPE T_PuntosAdicionales IS TABLE OF Lr_PuntosAdicionales INDEX BY PLS_INTEGER;

  /**
   * Documentacion para P_CONSUMO_WS_NETVOICE
   * Procedimiento que realiza el consumo de ws de netvoice que compara con la 
   * información comercial para insertar en las tablas de consumo
   *
   * @author John Vera <javera@telconet.ec>
   * @version 1.0 10/09/2018 
   *
   * @param Pv_Empresa
   * @param Pv_Mensaje  OUT VARCHAR2
   */
  PROCEDURE P_CONSUMO_WS_NETVOICE(  Pv_Empresa IN VARCHAR2,
                                    Pv_Mensaje OUT VARCHAR2);
                                    


  /**
   * Documentacion para P_GENERAR_TOKEN_NETVOICE
   * Procedimiento que realiza el consumo de ws de generacion de Token.
   *
   * @author John Vera <javera@telconet.ec>
   * @version 1.0 10/09/201
   *
   * @param Pv_Mensaje  IN  VARCHAR2,
   * @param Pv_Token    OUT VARCHAR2
   */
  PROCEDURE P_GENERAR_TOKEN_NETVOICE( Pv_Mensaje OUT VARCHAR2,
                                      Pv_token   OUT CLOB) ; 
  /**
  * Documentacion para la procedimiento 'P_MIGRA_INFORMACION_DASHBOARD'
  *
  * Procedimiento que migra la información de los servicios a la tabla del dashboard comercial 'DB_COMERCIAL.INFO_DASHBOARD_SERVICIO'
  *
  * @param  Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Codigo de la empresa que se desea consultar
  * @param  Pd_FechaInicio    IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE  Fecha de inicio de consulta de la información
  * @param Pv_MensajeError OUT VARCHAR2  Retorna el mensaje de error en caso de existir
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 21-07-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 01-09-2017 - Se agrega validación para que almacene la diferencia cuando el servicio ha sufrido un cambio de precio por un valor
  *                           mayor UPGRADE.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 13-10-2017 - Se incorporan mejoras que implican ingresar la información correspondiente a los campos 'MRC', 'NRC', 'CATEGORIA',
  *                          'GRUPO', 'SUBGRUPO', 'ACCION', 'OFICINA_VENDEDOR_ID', 'MOTIVO_PADRE_CANCELACION' y 'MOTIVO_CANCELACION'.
  */
  PROCEDURE P_MIGRA_INFORMACION_DASHBOARD(
      Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pd_FechaInicio    IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
      Pv_MensajeError   OUT VARCHAR2);

  /**
   * Función que genera un usuario en base al filtro seleccionado.
   * Se completan los valores en caso de no tenerlos con el Pv_PrefijoEmpresa.
   *
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 22-06-2018
   *
   * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
   * @version 1.1
   * @since 15-09-2020
   * Se modifica parametros de entrada para buscar la caracteristica del Producto y generar usuario.
   *
   * @author Claudio Olvera  <colvera@telconet.ec>
   * @version 1.2
   * @since 10-05-2022
   * Se agrega restriccion a la creación de nombres de usuario, no se permiten nombres que coincidan con
   * regexp no permitidos
   *
   * @param  Pv_IdPersona      Id de la persona para obtener la información de los nombres.
   * @param  Pv_InfoTabla      Identificador por el cual discrimina en qué cursor validar la existencia de un usuario similar.
   * @param  Pv_PrefijoEmpresa Prefijo de empresa para completar en caso que no tenga primer y segundo nombre.
   * @param  Pv_CaracUsuario   Caracteristica del usuario 
   * @param  Pv_NombreTecnico  Nombre técnico del producto
   * @return Lv_Usuario        VARCHAR2
   */
  FUNCTION F_GENERA_USUARIO(Pv_IdPersona      IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                            Pv_InfoTabla      IN VARCHAR2,
                            Pv_PrefijoEmpresa IN VARCHAR2,
                            Pv_CaracUsuario   IN VARCHAR2,
                            Pv_NombreTecnico  IN VARCHAR2)
    RETURN VARCHAR2;
  --
  --
  /**
  * Documentacion para el procedimiento COMEP_CONTEO_FRECUENCIAS
  *
  * Procedimiento que verifica los meses transcurridos desde la última vez en que se facturó a un cliente, o su
  * última vez que se reinicio el conteo viendo el historial del servicio o por su fecha de activación del servicio
  *
  * @param    Pv_PrefijoEmpresa       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE     Prefijo de la empresa de los servicios que se van a
  *                                                                                       modificar
  * @param    Pv_EstadoServicio       IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE           Estado de los servicios que se van a buscar
  * @param    Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE      Id del servicio a consultar
  * @param    Pn_MesesRestantes       IN DB_COMERCIAL.INFO_SERVICIO.MESES_RESTANTES%TYPE  Cantidad de meses restantes que tengan los servicios a 
  *                                                                                       consultar
  * @param    Pv_LlamadoProcedure     IN VARCHAR2                                         Origen de donde es invocado el procedimiento
  * @param    Pv_FechaReinicioConteo  IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE           Fecha con la cual se realiza el cálculo de meses restantes
  * @return   Pv_MensajeError         OUT VARCHAR2                                        Variable que retorna el mensaje de error en caso de existir
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 14-04-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 01-08-2016 - Se corrige el formato de las fechas para poder restar de forma correcta los meses restantes
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 16-08-2016 - Se parametriza que se envíe el código de la empresa y el estado del servicio para cambiar los meses restantes.
  *                           Adicional, se cambia la forma de verificar las facturas generadas al servicio para obtener los meses restantes
  *                           correspondientes.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 24-10-2016 - Se realiza modificaciones al script para validar lo siguiente:
  *                         - Se descartan las facturas proporcionales si son las últimas facturas emitidas al cliente
  *                         - Si la fecha de activación no está entre el rango de la facturación masiva y la frecuencia del servicio es igual a
  *                           uno se debe actualizar los meses restantes a cero para que ingrese a la siguiente facturación masiva
  *                         - Si no se encuentra factura, ni fecha de activación y la frecuencia del servicio es igual a uno se debe actualizar
  *                           los meses restantes a cero para que ingrese a la siguiente facturación masiva
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 04-12-2016 - Se corrige el formato de las fechas a 'DD-MM-YY' para poder restar de forma correcta los meses restantes.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.5 02-03-2017 - Se agrega parámetro de salida 'Pv_FechaReinicioConteo' para obtener la fecha con la cual se realiza el cálculo de meses
  *                           restantes, el parámetro de entrada 'Pn_IdServicio' para realizar el reinicio de conteo de un servicio específico, el
  *                           parámetro 'Pn_MesesRestantes' para consultar un grupo de servicios que correspondan al valor de meses restantes
  *                           enviados, y 'Pv_LlamadoProcedure' variable que contiene el origen desde donde es invocado el procedimiento. Adicional
  *                           se cambia el formato de las fechas obtenidas en el procedimiento para que no existan problemas de formato de fechas
  *                           cuando el procedimiento es invocado directamente del servidor o desde el aplicativo TELCOS+
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.6 07-04-2017 - Se quita el TRUNC al SYSDATE y se agrega el TO_DATE con la máscara dependiendo de donde es llamado el procedimiento,
  *                           para ello se usa la variable 'Lv_FormatoFecha' que contiene el formato correspondiente
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.7 11-05-2017 - Se corrige que sólo cuando la frecuencia del producto es igual a uno se debe verificar si la facturación realizada se
  *                           encuentra dentro del período correspondiente.
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.8 12-06-2017 - Se corrige la falta de inicializacion de la variable correspondiente a la fecha de reincion de conteo.
  * 
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.9 06-09-2018 - Se aumenta tamaño de la variable correspondiente a la fecha de rango de consumo.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec> 
  * @version 2.0 15-10-2018 - Se agrega Historial del servicio con los valores tomados para el calculo de los meses restantes como: fecha de 
  *                           reinicio de conteo, meses transcurridos, meses_restantes anterior y meses_restantes nuevo.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 2.1 25-10-2018 
  * Se modifica para que se invoque a la funcion F_GET_MAX_DOCUMENTO_SERV_PROD que retorna la máxima factura dependiendo del puntoFacturacionId,
  * puntoId, servicioId,  productoId y precioVenta ademas del filtro que se envíe a consultar, sean Factura por AnioMes o Rango de Consumo.
  * Se considera como prioridad se obtenga la Factura por Servicio facturado, o Factura por Producto y Precio de Venta asociado,
  * o solo por producto asociado al servicio.
  * Se considera que al obtener la Factura por 'rangoConsumo', se evalue que si el anio de la fecha de consumo final (FE_RANGO_FINAL) es mayor al  
  * anio de la Fecha de consumo inicial (FE_RANGO_INICIAL) entonces se debe usar la Fecha de Rango de Consumo Inicial como referencia para el calculo
  * de los meses transcurridos, caso contrario se debe usar la Fecha de Rango de Consumo Final.
  *
  * @author Jubert Goya <jgoya@telconet.ec> 
  * @version 2.2 31-03-2023 - Se agrega validacion de servicio prepago y pospago  antes de calcular la cantidad de meses restantes. Si es prepago se
  *                           aplica FLOOR y si es pospago se aplica CEIL
  */  
  PROCEDURE COMEP_CONTEO_FRECUENCIAS(
      Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_EstadoServicio      IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pn_IdServicio          IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Pn_MesesRestantes      IN DB_COMERCIAL.INFO_SERVICIO.MESES_RESTANTES%TYPE,
      Pv_LlamadoProcedure    IN VARCHAR2,
      Pv_FechaReinicioConteo OUT VARCHAR2,
      Pv_MensajeError        OUT VARCHAR2);
  --
  /**
  * Documentacion para el procedimiento P_REINICIO_MESES_RESTANTES
  *
  * Procedimiento que reinicia los meses restantes a cero cuando la frecuencia del servicio es igual a 1 y no tiene factura en el mes anterior
  *
  * @param    Pv_PrefijoEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE    Prefijo de la empresa de los servicios que se van a modificar
  * @param    Pv_EstadoServicio  IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE          Estado de los servicios que se van a buscar
  * @return   Pv_MensajeError    OUT VARCHAR2                                       Variable que retorna el mensaje de error en caso de existir
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 29-09-2016
  */
  PROCEDURE P_REINICIO_MESES_RESTANTES(
      Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_EstadoServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pv_MensajeError OUT VARCHAR2);
  --
 /**
  * Documentacion para el procedimiento COMEP_INSERT_NUEVAS_METAS
  * Crea las nuevas metas del nuevo mes
  * @author Edson Franco <efranco@telconet.ec>
  
  * @version 1.0 17-09-2015
  */
  PROCEDURE COMEP_INSERT_NUEVAS_METAS(
      Pv_MetaActiva   IN  VARCHAR2,
      Pv_MetaBruta    IN  VARCHAR2,
      Pv_EstadoMetas  IN  VARCHAR2,
      Pv_MsnError     OUT VARCHAR2 );
    --
    --
    --
    /**
     * Documentacion para el procedimiento COMEP_INSERT_PUNTO_HISTORIAL
     * Guarda un historial del punto (INFO_PUNTO)
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.0 29-07-2016
     */
    PROCEDURE COMEP_INSERT_PUNTO_HISTORIAL
    (  
        Po_InfoPuntoHistorial IN  DB_COMERCIAL.INFO_PUNTO_HISTORIAL%ROWTYPE,
        Pv_MsnError           OUT VARCHAR2 
    );

    /**
     * Procedimiento que crea las facturas de instalación para un punto adicional.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 22-11-2018
     *
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.1
     * @since 19-12-2018
     * Si el servicio pertenece a un Cliente Canal, no se genera factura.
     *
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.2
     * @since 30-01-2019
     * Se valida si el punto tiene un tipo de origen facturable.
     * Se agrega historial cuando el servicio no aplica a facturas de instalación.
     *
     * @version 1.3  
     * 18-09-2019
     * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
     * Se valida en base al Tipo de Origen Facturable y el Rol de Cliente para definir si debe generar Factura de Instalación.
     * 28-09-2019
     * @author Katherine Yager <kyager@telconet.ec>
     * Se modifica flujo para depurar código que ya no será utilizado en procedimiento como la validación de punto adicional, 
     * validación por banderas ya que ahora se procesarán todos los puntos.
     * Se agrega parámetro de Estado del contrato.
     *
     * @version 1.4  18-06-2020
     * @author Katherine Yager <kyager@telconet.ec>
     * Se realizan cambios para obtener el último estado del servicio y guardar en el historial del servicio.
     *
     * @version 1.5  21-04-2022
     * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
     * Se obtienen los mensajes parametrizados de las validaciones :
     *         CLIENTE_CANAL: Cliente Canal no genera facturas de instalación.
     *         MIGRACION_TECNOLOGIA: El tipo de origen del punto no genera facturas de instalación.
     *         EXISTE_FACTURA: El punto ya tiene generada una factura de instalación.     
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 1.6
     * @since 01-03-2023  Se agrega parámetro CvEmpresaCod en el cursor C_Parametros, para filtrar el resultado por empresa.    
     */
    PROCEDURE P_CREA_FACT_INS_PTO_ADICIONAL (Pn_PuntoId        IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                             Pn_IdServicio     IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                             Pv_PrefijoEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                             Pv_EstadoContrato IN  DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE,
                                             Pv_Mensaje        OUT VARCHAR2);

    /**
     * Procedimiento que realiza el proceso de creación de solicitudes y facturación para un punto adicional.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 23-11-2018
     *
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.1
     * @since 18-12-2018
     * Se valida que el servicio sea TIPO_ORDEN = 'N'.
     *
     * @version 1.2  18-09-2019
     * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
     * Se modifica Flujo en la generación de Solicitudes de Facturas de Instalación y se agrega proceso de Mapeo y Aplicación de Promociones
     * de Instalación.
     * Costo CURSOR C_GetSolicitudInstalacion: 5
     * Costo CURSOR C_GetUltMillaServ:5
     * Costo CURSOR C_GetServicioHistorial:14
     * Costo CURSOR C_ObtieneEstadoServ:3
     *
     * @version 1.3  18-06-2020
     * @author Katherine Yager <kyager@telconet.ec>
     * Se realizan cambios para obtener el último estado del servicio y guardar en el historial del servicio.
     *
     * @version 1.4  10-12-2020
     * @author José Candelario <jcandelario@telconet.ec>
     * Se realizan cambios por el llamado de proceso P_GET_RESTRIC_PLAN_INST se le aumenta un parametro de salida.
     *
     * @version 1.4  10-11-2020
     * @author José Candelario <jcandelario@telconet.ec>
     * Se realizan cambios en el proceso que se consideren los servicios que tienen una característica activa de un
     * código promocional.
     *
     * @version 1.5  21-04-2022
     * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
     * Se agrega registro en info_servicio_historial del mensaje de validacion de P_GET_RESTRIC_PLAN_INST
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 1.6
     * @since 01-03-2023  Se agrega parámetro CvEmpresaCod en el cursor C_GetSolicitudInstalacion, para filtrar el resultado por empresa. 
     *                    Se agrega empresa_cod en el llamado a función P_GET_RESTRIC_PLAN_INST.
     */
    PROCEDURE P_FACTURACION_PUNTO_ADICIONAL (Pn_IdServicio IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                             Pn_PuntoId    IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                             Pv_EmpresaCod IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                             Pv_Origen     IN  DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE,
                                             Pv_FormaPago  IN  VARCHAR2,
                                             Pv_Mensaje    OUT VARCHAR2);

    /**
     * Procedimiento que contiene la lógica para crear las solicitudes de instalación según corresponda.
     *
     * Costo Query C_GetUltMillaServ:           5
     *
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 23-11-2018
     *
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.1
     * @since 18-12-2018
     * Se agrega el texto "tipo de orden nuevo" al mensaje del historial cuando no se genera la factura.
     *
     * @author Katherine Yager <kyager@telconet.ec>
     * @version 1.2
     * @since 14-09-2019
     * Se modifica procedimiento para que ya no realice validaciones, solo crea la solicitud con los parámetros que recibe.
     */
    PROCEDURE P_CREA_SOL_FACT_INSTALACION(Pr_SolicitudInstalacion IN  DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion,
                                          Pv_Mensaje              OUT VARCHAR2,
                                          Pn_ContadorSolicitudes  IN  OUT NUMBER,
                                          Pn_IdDetalleSolicitud   IN  OUT NUMBER);
    --
    --
    --
    /**
     * Documentacion para el procedimiento COMEP_INSERT_PERSONA_ROL_HISTO
     * Guarda un historial de la INFO_PERSONA_EMPRESA_ROL
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.0 29-07-2016
     */
    PROCEDURE COMEP_INSERT_PERSONA_ROL_HISTO
    (  
        Po_InfoPersonaRolHistorial  IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE,
        Pv_MsnError                 OUT VARCHAR2 
    );
    --
    --
    --
    /**
     * Documentacion para el procedimiento COMEP_INSERT_DETALLE_SOLICITUD
     * Guarda un registro en la INFO_DETALLE_SOLICITUD
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.0 29-07-2016
     * @author Edgar Holguin <eholguin@telconet.ec>
     * @version 1.1 22-03-2017  Se agrega ingreso del campo PRECIO_DESCUENTO
     */
    PROCEDURE COMEP_INSERT_DETALLE_SOLICITUD
    (  
        Po_InfoDetalleSolicitud  IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
        Pv_MsnError              OUT VARCHAR2 
    );
    --
    --
    --

    /**
     * Procedimiento que itera los parámetros SOLICITUDES_DE_CONTRATO para poder crear las facturas de instalación según el origen y la empresa.
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.0
     * @since 10-10-2018
     *
     * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
     * @version 1.1 - Se modifica para que se procesen contratos Pendientes de Origen Web, se elimina Proceso de P_REGULARIZA_FACT_INSTALACION
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 1.2 - Se modifica procedimiento para enviar parametro Pv_TipoProceso en COMEP_CREAR_FACT_INSTALACION, 
     *                donde se procesaran contratos Activo y Pendientes.
     *
     */
    PROCEDURE P_FACT_INSTALACION_X_PARAMETRO (Pv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE DEFAULT NULL);

    /**
     * Documentacion para el procedimiento COMEP_CREAR_FACT_INSTALACION
     * Procedure que crea la solicitud de INSTALACION_GRATIS y la Factura correspondiente a la solicitud
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.0 07-08-2016
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.1 04-04-2017 - Se valida que cuando el cliente tenga una solicitud de instalación en estado 'Pendiente' se genere la factura
     *                           correspondiente.
     *
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.2
     * @since 10-10-2018
     * Se agrega el parámetro Pv_UsrCreacion (USR_CREACION) debido a que ahora ingresan en este proceso los contratos de origen WEB y MOVIL.
     * Se agrega el parámetro Pv_NombreMotivo.
     * Se agrega el parámetro observación de la solicitud. Pv_ObservacionSolicitud
     * Se agrega el parámetro característica del contrato debido a que ahora se ingresan contratos WEB y MOVIL
     * Se agrega el parámetro Pn_DiasPermitidos para saber el número de días permitidos desde la factibilidad del servicio.
     * Se escribe en el campo DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PRECIO_DESCUENTO el valor real de la instalación y en el campo
     *      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO se escribe el porcentaje de descuento según la forma de pago del parámetro.
     *      Para realizar la factura se calcula el PRECIO_DESCUENTO - PRECIO_DESCUENTO * PORCENTAJE_DESCUENTO.
     * Se agrega validación para realizar el proceso de solicitudes únicamente por servicios que la fecha de su último estado factible = SYSDATE.
     *
     * @author Luis Cabrera <lcabrera@telconet.ec>
     * @version 1.3
     * @since 18-12-2018
     * Se agrega la validación del servicio por TIPO_ORDEN = 'N'.
     * Se agrega validación: No se deben crear facturas de instalación a los Cliente Canal
     *
     * @version 1.4  19-09-2019
     * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
     * Se ajusta proceso para crear Facturas de Instalación para Contratos en estado Pendiente de Origen Web o Móvil.
     * Se modifica Flujo en la generación de Solicitudes de Facturas de Instalación y se agrega proceso de Mapeo y Aplicación de Promociones
     * de Instalación.     
     * Se valida  que el punto no posea Factura de Instalación o que si posee esta no este cerrada por una NC, de ser el caso ya no debe Facturar.
     * Se valida el tipo de origen: "Si es migración de tecnología" No debe Facturar.
     * Se valida si el servicio posee una solicitud de Facturación web o móvil en estado pendiente o finalizada ya no debe Facturar.
     * Se valida las restricciones de planes parametrizados por "RESTRICCION_PLANES_X_INSTALACION" para obtener los descuentos o valores a Facturar.
     * Costo CURSOR C_GetSolicitudInstalacion: 5
     * Costo CURSOR C_GetServicioHistorial:14
     * Costo Query C_GetParamNumDiasFecAlcance:3
     * Costo Query C_GetParamTipoSol:4
     * Costo Query C_ObtieneEstadoServ:3
     *
     * @version 1.5  05-12-2019
     * @author Katherine Yager <kyager@telconet.ec>
     * Se realizan cambios en query que obtiene servicios para obtener aquellos que estén factibles en el día y su servicio en los 
     * estados parametrizados, con número días Sysdate parametrizado.
     *
     * @version 1.6  19-12-2019
     * @author Katherine Yager <kyager@telconet.ec>
     * Se realizan cambios en query que obtiene servicios, cambiando el TO_CHAR por TO_DATE
     *
     * @version 1.7  18-06-2020
     * @author Katherine Yager <kyager@telconet.ec>
     * Se realizan cambios para obtener el último estado del servicio y guardar en el historial del servicio.
     *
     * @version 1.8  12-03-2020
     * @author José Candelario <jcandelario@telconet.ec>
     * Se realizan cambios en query que obtiene servicios, se agrega filtro que el servicio no cuente con una característica de Reingreso
     * de OS automática.
     *
     * @version 1.9  10-12-2020
     * @author José Candelario <jcandelario@telconet.ec>
     * Se realizan cambios por el llamado de proceso P_GET_RESTRIC_PLAN_INST se le aumenta un parametro de salida.
     *
     * @version 1.10  10-11-2020
     * @author José Candelario <jcandelario@telconet.ec>
     * Se realizan cambios en el proceso que se consideren los servicios que tienen una característica activa de un
     * código promocional.
     *
     * @version 1.11  26-04-2022
     * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
     * Se obtienen los mensajes parametrizados de las validaciones :
     *         CLIENTE_CANAL: Cliente Canal no genera facturas de instalación.
     *         MIGRACION_TECNOLOGIA: El tipo de origen del punto no genera facturas de instalación.
     *         EXISTE_FACTURA: El punto ya tiene generada una factura de instalación.
     * y se agrega registro en info_servicio_historial del mensaje de validacion de P_GET_RESTRIC_PLAN_INST
     *
     * @version 2.0  31-05-2022
     * @author Hector Lozano <hlozano@telconet.ec>
     * Se agregan logs para monitorear el proceso de mapeo de promociones de Instalacion.
     *
     * @version 2.1  03-06-2022
     * @author Hector Lozano <hlozano@telconet.ec>
     * Se agrega parametro Pv_TipoProceso, para procesar Contratos Activos y Pendientes. Se elimina cursor C_Contrato
     * y se crea cursor dinamico para obtener los contratos a procesar por el tipo de proceso.
     *
     * @version 2.2  13-06-2022
     * @author Alex Arreaga <atarreaga@telconet.ec>
     * Se modifica sentencia de validación de fecha por FE_APROBACION en el cursor dinámico que obtiene los contratos a  
     * procesar por el tipo de proceso 'ProcesaActivos'.
     *
     * @version 2.3  24-06-2022
     * @author Alex Arreaga <atarreaga@telconet.ec>
     * Se agrega sentencia "OR" de validación de fecha por FE_CREACION en el cursor dinámico que obtiene los contratos a  
     * procesar por el tipo de proceso 'ProcesaActivos'.
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 2.4
     * @since 01-03-2023  Se agrega parámetro Cv_EmpresaCod en los cursores C_GetSolicitudInstalacion,C_GetParamNumDiasFecAlcance,
     *                    C_GetParamTipoSol,C_Parametros, para filtrar el resultado por empresa.
     *                    Se agrega empresa_cod en el llamado a función P_GET_RESTRIC_PLAN_INST.
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 2.5
     * @since 11-04-2023  Se elimina la sentencia TRUNC en los campos fechas del query que obtiene los contratos, para disminuir el costo.  
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 2.6
     * @since 27-04-2023  Se elimina la sentencia TRUNC en los campos fechas del query que obtiene los servicios, para disminuir el costo.
     */
    PROCEDURE COMEP_CREAR_FACT_INSTALACION
    (
        Pv_OrigenContrato       IN  DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE,
        Pv_CaractContrato       IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
        Pv_ObservacionSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
        Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
        Pv_NombreMotivo         IN  DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
        Pv_UsrCreacion          IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE,
        Pv_EstadoContrato       IN  DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE,
        Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pn_DiasPermitidos       IN  NUMBER,
        Pv_TipoProceso          IN  VARCHAR2
    );
  --
  --
  /**
  * Documentacion para el procedimiento P_INSERT_SERVICIO_HISTO
  *
  * Guarda un historial del servicio en la INFO_SERVICIO_HISTORIAL
  *
  * @param Pr_InfoServicioHistorial IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE   Objecto que contiene la información que se desea guardar
  *
  * @return Pv_MsnError OUT VARCHAR2   Retorna un mensaje de error en caso de existir
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 21-09-2016
  */
  PROCEDURE P_INSERT_SERVICIO_HISTO(
      Pr_InfoServicioHistorial IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE,
      Pv_MsnError OUT VARCHAR2 );
  --
  --
  /**
  * Documentacion para el procedimiento P_INSERT_DETALLE_SOL_HIST
  *
  * Guarda un historial de la solicitud en la INFO_DETALLE_SOL_HIST
  *
  * @param Pr_InfoDetalleSolHist IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE   Objecto que contiene la información que se desea guardar
  *
  * @return Pv_MsnError OUT VARCHAR2   Retorna un mensaje de error en caso de existir
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 21-09-2016
  */
  PROCEDURE P_INSERT_DETALLE_SOL_HIST(
      Pr_InfoDetalleSolHist IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,
      Pv_MsnError OUT VARCHAR2 );
  --
  /**
  * Documentacion para el procedimiento P_INSERT_DETALLE_SOL_HIST
  *
  * Guarda un historial de la solicitud en la INFO_DETALLE_SOL_HIST
  *
  * @param  Pn_IdTipoSolicitud     IN  INFO_DETALLE_SOLICITUD.TIPO_SOLICITUD_ID%TYPE   Id del tipo de solicitud.
  * @param  Pv_EstadoSol           IN  INFO_DETALLE_SOLICITUD.ESTADO%TYPE              Estado nuevo a actualizar.
  * @param  Pv_EstadoSolActualizar IN  INFO_DETALLE_SOLICITUD.ESTADO%TYPE              Estado actual de la solicitud.
  * @param  Pv_Observacion         IN  INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE         Observación.
  * @param  Pv_Usuario             IN  INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE        Usuario de creación.
  * @param  Pv_Ip                  IN  INFO_DETALLE_SOL_HIST.IP_CREACION%TYPE          Ip de creación.
  * @return Pv_Error               OUT VARCHAR2                                        Mensaje de error.
  *
  * @author Egar Holguin <eholguin@telconet.ec>
  * @version 1.0 30-03-2017
  */
  PROCEDURE P_FINALIZA_SOLICITUD_POR_TIPO(
      Pn_IdTipoSolicitud     IN  INFO_DETALLE_SOLICITUD.TIPO_SOLICITUD_ID%TYPE,
      Pv_EstadoSol           IN  INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
      Pv_EstadoSolActualizar IN  INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
      Pv_Observacion         IN  INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
      Pv_Usuario             IN  INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE,
      Pv_Ip                  IN  INFO_DETALLE_SOL_HIST.IP_CREACION%TYPE,
      Pv_Error               OUT VARCHAR2);
   --   
  /**
  * Documentacion para el procedimiento P_CALCULO_COMISION_MANTENIMI
  *
  * Procedimiento que calcula la comision en mantenimiento en Plantillas de Comisionistas en servicios Activos con fecha de 
  * activacion mayor a 12 meses
  *
  * @param    Pv_PrefijoEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE    Prefijo de la empresa de los servicios que se van a modificar
  * @param    Pv_EstadoServicio  IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE          Estado de los servicios que se van a buscar
  * @param    Pn_ContadorCommit  IN NUMBER                                          Cantidad de registros a realizar commit parcial
  * @return   Pv_MensajeError    OUT VARCHAR2                                       Variable que retorna el mensaje de error en caso de existir
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 16-05-2017
  */
  PROCEDURE P_CALCULO_COMISION_MANTENIMI(
      Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_EstadoServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pn_ContadorCommit IN NUMBER,
      Pv_MensajeError OUT VARCHAR2);
  --      
  /**
  * Documentación para el procedimiento P_CAMBIO_ESTADO_SERVICIO
  *
  * De acuerdo al estado anterior y al estado nuevo del servicio, se procede a realizar la gestión respecto a la solicitud y al servicio 
  * dependiendo de los tipos de solicitudes parametrizadas de acuerdo al cambio de estado que se esté realizando.
  *
  * Las solicitudes se encuentran parametrizadas de la siguiente manera:
  * NOMBRE_PARAMETRO -> 'TIPOS_SOLICITUDES_CAMBIO_ESTADO_SERVICIO'
  * DESCRIPCION -> nombre del tipo de solicitud a buscar
  * VALOR1 -> estado anterior de servicio
  * VALOR2 -> estado nuevo de servicio
  * VALOR3 -> estado de la solicitud a buscar
  * VALOR4 -> estado para actualizar a la solicitud
  *
  * Si la solicitud es de tipo 'SOLICITUD MIGRACION', se coloca en estado Pendiente dichas solicitudes asociadas al servicio.
  * 
  * Si la solicitud es de tipo 'SOLICITUD PREPLANIFICACION', se finaliza dichas solicitudes asociadas al punto del servicio del que se está actualizando 
  * el estado y crea una nueva solicitud de tipo 'SOLICITUD PLANIFICACION'
  *
  * @param Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE id del servicio
  * @param Pn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE id del punto
  * @param Pv_EstadoAnterior IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE estado anterior del servicio
  * @param Pv_EstadoNuevo IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE estado nuevo del servicio
  * @return Pv_MensajeError OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 06-04-2017
  */
  PROCEDURE P_CAMBIO_ESTADO_SERVICIO(
      Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Pn_IdPunto IN DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
      Pv_EstadoAnterior IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pv_EstadoNuevo IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pv_UsrCreacion IN DB_COMERCIAL.INFO_SERVICIO.USR_CREACION%TYPE,
      Pv_MensajeError OUT VARCHAR2 );
  --

  /**
  * Documentación para el procedimiento P_CLIENTE_SIN_DEUDA
  *
  * Procedimiento usado para obtener todos los clientes que tienen solicitudes de preplanificación en estado Pendiente y que no
  * tienen deuda. Si se cumple esta validación, se procede a actualizar el estado de dicha solicitud a Finalizada y se creará la
  * solicitud de planificación respectiva para continuar el flujo normal en el plan de netlifecam
  * 
  * @return Pv_MensajeError OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 10-07-2017
  */
  PROCEDURE P_CLIENTE_SIN_DEUDA(
      Pv_MensajeError OUT VARCHAR2 );

  /**
   * Documentación para el procedimiento P_UPDATE_INFO_SERVICIO_CARAC:
   * Procedimiento que realiza el update de un registro en base al ID_SERVICIO_CARACTERISTICA
   * @param Lr_InfoServicioCaracteristica
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 14-06-2018
   */
  PROCEDURE P_UPDATE_INFO_SERVICIO_CARAC(Pr_InfoServicioCaracteristica IN  DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE,
                                         Pv_Mensaje                    OUT VARCHAR2);
  --
  /*
  * Documentación para PROCEDURE P_NOTIFICA_CANCELACION_DEMOS
  *
  * Procedimiento que se ejecuta diariamente y se encarga de validar si existen demos que estan proximos a expirar,
  * adicional realiza la notificacion a los clientes cuando estan a 2 dias de la fecha fin
  *
  * PARAMETROS:
  * @Param varchar2       pv_mensaje     Mensaje de respuesta
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.0 20-07-2017
  *
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.1 02-05-2018 - Se ralizan ajustes para consultar la fecha de creacion del demo, considerando el ultimo registro activo
  *
  */
  PROCEDURE P_NOTIFICA_CANCELACION_DEMOS(pv_mensaje OUT VARCHAR2);
  --

  /*
  * Documentación para PROCEDURE P_FINALIZAR_SOL_MASIVA_CAB
  *
  * Procedimiento que se ejecuta 1 vez al día, regularizando los estados de las cabeceras de las solicitudes masivas cuyos detalles 
  * se encuentran en estado Finalizado o Rechazado de Pendiente a Finalizada
  * Costo = 188
  * PARAMETROS:
  * @Param varchar2       Pv_MsjError     Mensaje de respuesta
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 20-03-2018
  *
  */
PROCEDURE P_FINALIZAR_SOL_MASIVA_CAB(Pv_MsjError OUT VARCHAR2);


  /**
   * Documentación para el procedimiento P_UPDATE_INFO_SERVICIO_CARAC:
   * Procedimiento que realiza el update de un registro en base al ID_SERVICIO_CARACTERISTICA
   * @param Pn_IdServicio
   * @param Pv_DescripcionCaract
   * @param Pv_NuevoEstado
   * @param Pv_UsrModifica
   * @author Edgar Holguín <eholguin@telconet.ec>
   * @version 1.0
   * @since 10-07-2018
   */
  PROCEDURE P_SET_ESTADO_INFO_SERV_CARAC(Pn_IdServicio         IN  NUMBER,
                                         Pv_DescripcionCaract  IN  VARCHAR2,
                                         Pv_NuevoEstado        IN  VARCHAR2,
                                         Pv_UsrModifica        IN  VARCHAR2,
                                         Pv_Mensaje            OUT VARCHAR2);

  /**
  * P_INSERT_SERVICIO_HISTORIAL
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA INFO_DETALLE_SOLICITUD
  *
  * @author Edgar Holguin  <eholguin@telconet.ec>
  * @version 1.0 24/07/2018
  * @param string Pr_detalleSolicitud
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1
  * Se agrega la validación de la fecha si viene null, por defecto se fija la fecha del sistema.
  *
  * @return string Pr_servicioHistorial
  */       
        
    PROCEDURE P_INSERT_SERVICIO_HISTORIAL(
        Pr_servicioHistorial IN INFO_SERVICIO_HISTORIAL%ROWTYPE,        
        Lv_MensaError OUT VARCHAR2);

  /**
   * P_RECHAZA_SERVICIOS
   *
   * Procedimiento que rechaza las solicitudes de planificación en estado Detenido de todos los productos, excepto los productos con grupo DATACENTER
   * al superar el tiempo establecido que se encuentra parametrizado por empresa y última milla
   * Además se enviará una notificación con el consolidado de los servicios que se hayan rechazado a los alias configurados
   * y adicionalmente se enviará un correo al vendedor del servicio notificándole la liberación de recursos de factibilidad
   * y rechazo de dicho servicio
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 08/11/2018
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.1 11/02/2019 Se agrega servicios TelcoHome para que realizar el rechazo automático en estado Detenido
   *
   * @author Jean Pierre Nazareno <jnazareno@telconet.ec>
   * @version 1.2 20/09/2019 Se agrega bloque de código para cambiar estado a "Anulado" y crear un nuevo registro en el historial.
   * 
   * @param Pv_EstadoActualServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE Estado actual del servicio
   * 
   */
  PROCEDURE P_RECHAZA_SERVICIOS(Pv_EstadoActualServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE);


  /**
   * Documentación para el procedimiento P_UPDATE_INFO_DETALLE_SOL:
   * Procedimiento que realiza el update de un registro en base al campo ID_DETALLE_SOLICITUD
   * @param Lr_InfoDetalleSolicitud
   * @author Edgar Holguín <eholguin@telconet.ec>
   * @version 1.0
   * @since 29-09-2018
   */
   PROCEDURE P_UPDATE_INFO_DETALLE_SOL(Pr_InfoDetalleSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                       Pv_Mensaje              OUT VARCHAR2);

 /**
  * Documentación para TYPE 'Lr_ContratosProcesar'.
  *  
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 06-06-2022
  */
  TYPE Lr_ContratosProcesar IS RECORD ( ID_CONTRATO               DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                        PERSONA_EMPRESA_ROL_ID    DB_COMERCIAL.INFO_CONTRATO.PERSONA_EMPRESA_ROL_ID%TYPE,
                                        FORMA_PAGO                DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
                                        FE_CREACION               DB_COMERCIAL.INFO_CONTRATO.FE_CREACION%TYPE) ;

 /**
  * Documentación para TYPE 'T_ContratosProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 06-06-2022
  */
  TYPE T_ContratosProcesar IS TABLE OF Lr_ContratosProcesar INDEX BY PLS_INTEGER;

END COMEK_TRANSACTION;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.COMEK_TRANSACTION
AS

  PROCEDURE P_GET_RESTRIC_PLAN_INST(Pv_NombrePlan           IN DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
                                    Pv_EmpresaCod           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pb_PlanConRestriccion   OUT BOOLEAN,
                                    Pn_PorcentajeDescuento  OUT NUMBER,
                                    Pv_Observacion          OUT VARCHAR2)
  IS
    TYPE                    Lt_AdmiParametroDet IS REF CURSOR RETURN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_AdmiParametroDet    Lt_AdmiParametroDet;
    Lr_AdmiParametroDet     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lv_ParamRestricPlanInst DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='RESTRICCION_PLANES_X_INSTALACION';        
    Ln_PlanConRestriccion   NUMBER := 0;
    Lv_IpCreacion           VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado         VARCHAR2(2000); 
    --Costo :2
    CURSOR C_GetRegexpLike (Cv_NombrePlan   VARCHAR2,
                            Cv_RegExp       VARCHAR2,
                            Cv_MatchPattern VARCHAR2 DEFAULT 'c')
    IS
    SELECT COUNT(*)
    FROM DUAL
    WHERE REGEXP_LIKE (Cv_NombrePlan, Cv_RegExp, Cv_MatchPattern); 
           
  BEGIN
    Pn_PorcentajeDescuento:=0;
    Pb_PlanConRestriccion:=FALSE;
    --Se obtienen las restricciones por planes que no se cobran instalación y por planes que se cobra la instalación en su totalidad.
    Lrf_AdmiParametroDet := DB_GENERAL.GNRLPCK_UTIL.F_GET_PARAMS_DETS_EMPRESA(Lv_ParamRestricPlanInst,Pv_EmpresaCod);
    LOOP
      FETCH Lrf_AdmiParametroDet INTO Lr_AdmiParametroDet;
      EXIT WHEN Lrf_AdmiParametroDet%NOTFOUND OR Ln_PlanConRestriccion=1;

      OPEN  C_GetRegexpLike (Cv_NombrePlan   => Pv_NombrePlan,
                             Cv_RegExp       => Lr_AdmiParametroDet.VALOR1,
                             Cv_MatchPattern => Lr_AdmiParametroDet.VALOR2);

      FETCH C_GetRegexpLike INTO Ln_PlanConRestriccion;
      CLOSE C_GetRegexpLike;

      IF Ln_PlanConRestriccion = 1 THEN
        Pv_Observacion         := Lr_AdmiParametroDet.DESCRIPCION;
        Pn_PorcentajeDescuento := Lr_AdmiParametroDet.VALOR3; 
        Pb_PlanConRestriccion  :=TRUE;                
      END IF;
    END LOOP;
    --
    CLOSE Lrf_AdmiParametroDet;

  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MsjResultado := 'Ocurrio un error al verificar la restricción de planes por Instalación Nombre_Plan: '||Pv_NombrePlan;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'COMEK_TRANSACTION.P_GET_RESTRIC_PLAN_INST',  
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );      
    Pv_Observacion        := '';
    Pn_PorcentajeDescuento:=0;
    Pb_PlanConRestriccion:=FALSE;
  END P_GET_RESTRIC_PLAN_INST;
  --
    --
  PROCEDURE P_OBTIENE_PUNTOS_ADICIONALES( Pv_EmpresaCod  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pv_Mensaje     OUT VARCHAR2 
                                        ) 
  IS

    --Costo: Query que obtiene un servicio disponible a ser facturado por instalación: 762
    CURSOR C_GetInfoServicio (Cv_EstadoServ     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                              Cv_EsVenta         DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE,
                              Cv_EstadoActivo    VARCHAR2,
                              Cv_EmpresaCod      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Cv_FibraCod        DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
                              Cv_CobreCod        DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
                              Cv_NombreTecnico   DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                              Cn_Frecuencia      DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
                              Cv_TipoOrden       DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE DEFAULT 'N',
                              Cn_NumeroDias      NUMBER,
                              Cv_NombreParametro VARCHAR2,
                              Cv_TipoPromo       VARCHAR2,
                              Cv_EstadoPendiente   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                              Cv_EstadoFinalizada  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                              Cv_EstadoEliminada   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                              Cv_IdSolWeb          DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE,
                              Cv_IdSolMovil        DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE
                              )
    IS
    SELECT DISTINCT ID_SERVICIO,  iser.punto_id
    FROM DB_COMERCIAL.INFO_SERVICIO iser
    JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
      ON iser.ID_SERVICIO = ist.SERVICIO_ID
    JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm
      ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
    JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc
      ON iser.PLAN_ID = ipc.ID_PLAN
    JOIN DB_COMERCIAL.INFO_PLAN_DET ipd
      ON ipc.ID_PLAN = ipd.PLAN_ID
    JOIN DB_COMERCIAL.ADMI_PRODUCTO ap
      ON ipd.PRODUCTO_ID = ap.ID_PRODUCTO
    JOIN DB_COMERCIAL.INFO_PUNTO IP
      ON IP.ID_PUNTO = ISER.PUNTO_ID
    JOIN DB_COMERCIAL.INFO_CONTRATO IC
      ON IP.PERSONA_EMPRESA_ROL_ID = IC.PERSONA_EMPRESA_ROL_ID
    JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
      ON ISERH.SERVICIO_ID=iser.ID_SERVICIO
    WHERE ISERH.ESTADO              = Cv_EstadoServ
    AND iser.ES_VENTA              = Cv_EsVenta
    AND iser.TIPO_ORDEN            = Cv_TipoOrden
    AND ap.ESTADO                  = Cv_EstadoActivo
    AND atm.CODIGO_TIPO_MEDIO      IN (Cv_FibraCod, Cv_CobreCod)
    AND iser.FRECUENCIA_PRODUCTO   = Cn_Frecuencia
    AND ap.EMPRESA_COD             = Cv_EmpresaCod
    AND ap.NOMBRE_TECNICO          = Cv_NombreTecnico  
    AND IC.ESTADO                  = Cv_EstadoActivo
    AND  iserh.FE_CREACION >= to_date(SYSDATE - Cn_NumeroDias, 'DD/MM/RRRR') 
    AND  iser.ESTADO in (
     SELECT APD.VALOR2 AS VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
      AND APD.ESTADO           = Cv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APC.ESTADO           = Cv_EstadoActivo
      AND APD.VALOR1           = Cv_TipoPromo
     AND APD.EMPRESA_COD       = Cv_EmpresaCod
    )
   AND iser.ID_SERVICIO not in (select DISTINCT SERVICIO_ID from DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
                                    WHERE TIPO_SOLICITUD_ID  in (Cv_IdSolWeb,Cv_IdSolMovil)
                                    and IDS.SERVICIO_ID           = iser.ID_SERVICIO
                                    AND IDS.ESTADO                IN (Cv_EstadoPendiente, Cv_EstadoFinalizada, Cv_EstadoEliminada)
                                    AND  ids.FE_CREACION >= to_date(SYSDATE - Cn_NumeroDias, 'DD/MM/RRRR')
                                 )
    AND 'Cliente'              IN (SELECT AR.DESCRIPCION_ROL 
                                     FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                                     JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
                                     JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
                                    WHERE IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID)
    AND NOT EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                    FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                      DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                    WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'ID_SERVICIO_REINGRESO'
                    AND DBISC.SERVICIO_ID                 = ISER.ID_SERVICIO
                    AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA)
    UNION
      SELECT  ID_SERVICIO,  iser.punto_id
      FROM DB_COMERCIAL.INFO_SERVICIO iser
      JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
        ON iser.ID_SERVICIO = ist.SERVICIO_ID
      JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm
        ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
      JOIN DB_COMERCIAL.ADMI_PRODUCTO ap
        ON iser.PRODUCTO_ID = ap.ID_PRODUCTO
      JOIN DB_COMERCIAL.INFO_PUNTO IP
        ON IP.ID_PUNTO = ISER.PUNTO_ID
      JOIN DB_COMERCIAL.INFO_CONTRATO IC
        ON IP.PERSONA_EMPRESA_ROL_ID = IC.PERSONA_EMPRESA_ROL_ID  
      JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
        ON ISERH.SERVICIO_ID=iser.ID_SERVICIO
      WHERE iserh.ESTADO              = Cv_EstadoServ
      AND iser.ES_VENTA              = Cv_EsVenta
      AND iser.TIPO_ORDEN            = Cv_TipoOrden
      AND ap.ESTADO                  = Cv_EstadoActivo
      AND atm.CODIGO_TIPO_MEDIO      IN (Cv_FibraCod, Cv_CobreCod)
      AND iser.FRECUENCIA_PRODUCTO   = Cn_Frecuencia
      AND ap.EMPRESA_COD             = Cv_EmpresaCod
      AND ap.NOMBRE_TECNICO          = Cv_NombreTecnico
      AND IC.ESTADO                  = Cv_EstadoActivo
      AND iserh.FE_CREACION >= to_date(SYSDATE - Cn_NumeroDias, 'DD/MM/RRRR')
      AND  iser.ESTADO in (
        SELECT APD.VALOR2 AS VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
          DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
          AND APD.ESTADO           = Cv_EstadoActivo
          AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
          AND APC.ESTADO           = Cv_EstadoActivo
          AND APD.VALOR1           = Cv_TipoPromo
          AND APD.EMPRESA_COD      = Cv_EmpresaCod
      )      
      AND iser.ID_SERVICIO not in (select DISTINCT SERVICIO_ID from DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
                                    WHERE TIPO_SOLICITUD_ID  in (Cv_IdSolWeb,Cv_IdSolMovil)
                                    and IDS.SERVICIO_ID           = iser.ID_SERVICIO
                                    AND IDS.ESTADO                IN (Cv_EstadoPendiente, Cv_EstadoFinalizada, Cv_EstadoEliminada)
                                    AND  ids.FE_CREACION >= to_date(SYSDATE - Cn_NumeroDias, 'DD/MM/RRRR')
                                 )
      AND 'Cliente'              IN (SELECT AR.DESCRIPCION_ROL 
                                       FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                                       JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
                                       JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
                                    WHERE IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID)
      AND NOT EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'ID_SERVICIO_REINGRESO'
                      AND DBISC.SERVICIO_ID                 = ISER.ID_SERVICIO
                      AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA);           
 
   --
   --Costo: Query para obtener prefijo de la empresa: 1
    CURSOR C_GetEmpresaPref(Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                            Cv_EstadoActivo DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE
                           ) 
    IS
    SELECT IEG.PREFIJO
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
    WHERE IEG.COD_EMPRESA = Cv_CodEmpresa
    AND IEG.ESTADO        = Cv_EstadoActivo;
    

   CURSOR C_GetParamNumDiasFecAlcance (Cv_NombreParam    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                       Cv_DescParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.DESCRIPCION%TYPE,    
                                       Cv_Estado         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                       Cv_EmpresaCod     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
    IS
    SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_DIAS
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
    DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
    AND APD.ESTADO             = Cv_Estado
    AND APC.NOMBRE_PARAMETRO   = Cv_NombreParam
    AND APD.DESCRIPCION        = Cv_DescParametro
    AND APC.ESTADO             = Cv_Estado
    AND APD.EMPRESA_COD        = Cv_EmpresaCod;
    --
   CURSOR C_GetParamTipoSol (Cv_NombreParam      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,    
                             Cv_EstadoEliminado  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_Origen           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                             Cv_EmpresaCod       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
    IS
    SELECT ATS.ID_TIPO_SOLICITUD
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
          DB_GENERAL.ADMI_PARAMETRO_DET DET,
          DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParam
      AND CAB.ESTADO       = Cv_EstadoActivo
      AND CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      AND DET.VALOR4       = ATS.descripcion_solicitud
      AND DET.ESTADO       <> Cv_EstadoEliminado
      AND DET.VALOR1       = Cv_Origen
      AND DET.EMPRESA_COD  = Cv_EmpresaCod;

  
      Ln_Indx                 NUMBER;
      Lv_EstadoActivo         VARCHAR2(15):='Activo';
      Lv_PrefijoEmpresa       VARCHAR2(2000);
      La_PuntosAdicionales    T_PuntosAdicionales;
      Ln_Limit                CONSTANT PLS_INTEGER DEFAULT 5000;
      Lv_MsjResultado         VARCHAR2(2000);
      Lv_IpCreacion           VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
      --
      Ln_NumeroDias            NUMBER := 0;
      Lv_NombreParametro       VARCHAR2(2000):='PROM_ESTADO_SERVICIO';
      Lv_TipoPromo             VARCHAR2(2000):='PROM_INS_SOL_FACT';
      Lv_NombreParametroDias   VARCHAR2(2000):='PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE';
      Lv_DescParametroDias     VARCHAR2(2000):='NUMERO_DIAS_PROM_INS';
      Lv_IdSolWeb              VARCHAR2(20);
      LvIdSolMovil             VARCHAR2(20);
      
    BEGIN
    
      IF C_GetEmpresaPref%ISOPEN THEN
        CLOSE C_GetEmpresaPref;
      END IF;
      --
      OPEN C_GetEmpresaPref(Pv_EmpresaCod,Lv_EstadoActivo);
      FETCH C_GetEmpresaPref INTO Lv_PrefijoEmpresa;
      CLOSE C_GetEmpresaPref;
      --
      IF C_GetParamTipoSol%ISOPEN THEN
        CLOSE C_GetParamTipoSol;
      END IF;
      --
      OPEN C_GetParamTipoSol(Cv_NombreParam     => 'SOLICITUDES_DE_CONTRATO',
                             Cv_EstadoActivo    => 'Activo',
                             Cv_EstadoEliminado => 'Eliminado', 
                             Cv_Origen          => 'WEB',
                             Cv_EmpresaCod      => Pv_EmpresaCod);
      FETCH C_GetParamTipoSol INTO Lv_IdSolWeb;
      CLOSE C_GetParamTipoSol;
      --
      --
      IF C_GetParamTipoSol%ISOPEN THEN
        CLOSE C_GetParamTipoSol;
      END IF;
      --
      OPEN C_GetParamTipoSol(Cv_NombreParam     => 'SOLICITUDES_DE_CONTRATO',
                             Cv_EstadoActivo    => 'Activo',
                             Cv_EstadoEliminado => 'Eliminado', 
                             Cv_Origen          => 'MOVIL',
                             Cv_EmpresaCod      =>  Pv_EmpresaCod);
      FETCH C_GetParamTipoSol INTO LvIdSolMovil;
      CLOSE C_GetParamTipoSol;
      --
      --
       IF C_GetParamNumDiasFecAlcance%ISOPEN THEN
        CLOSE C_GetParamNumDiasFecAlcance;
      END IF;
      --
     
       OPEN  C_GetParamNumDiasFecAlcance(Cv_NombreParam    => Lv_NombreParametroDias,
                                         Cv_DescParametro  => Lv_DescParametroDias,
                                         Cv_Estado         => Lv_EstadoActivo,
                                         Cv_EmpresaCod     => Pv_EmpresaCod);
      FETCH C_GetParamNumDiasFecAlcance INTO Ln_NumeroDias;
      CLOSE C_GetParamNumDiasFecAlcance;
      --
      IF (Ln_NumeroDias IS NULL OR Ln_NumeroDias = 0) THEN
        Lv_MsjResultado := 'No se puedo obtener el numero de dias parametrizados en PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE 
                para la ejecución del proceso: P_OBTIENE_PUNTOS_ADICIONALES';
  
      END IF;  
      --
      --
      IF C_GetInfoServicio%ISOPEN THEN
        CLOSE C_GetInfoServicio;
      END IF;
      --
      --
      OPEN C_GetInfoServicio( Cv_EstadoServ    => 'Factible',
                              Cv_EsVenta       => 'S',
                              Cv_EstadoActivo  => 'Activo' ,
                              Cv_EmpresaCod    => Pv_EmpresaCod,
                              Cv_FibraCod      => 'FO',
                              Cv_CobreCod      => 'CO',
                              Cv_NombreTecnico => 'INTERNET',
                              Cn_Frecuencia    => 1,
                              Cv_TipoOrden     => 'N',
                              Cn_NumeroDias    => Ln_NumeroDias,
                              Cv_NombreParametro => Lv_NombreParametro,
                              Cv_TipoPromo       => Lv_TipoPromo,
                              Cv_EstadoPendiente =>    'Pendiente',
                              Cv_EstadoFinalizada =>  'Finalizada',
                              Cv_EstadoEliminada  =>  'Eliminada',
                              Cv_IdSolWeb         =>  Lv_IdSolWeb,
                              Cv_IdSolMovil       =>  LvIdSolMovil
                              );
                              
  
      LOOP
        FETCH C_GetInfoServicio BULK COLLECT INTO La_PuntosAdicionales LIMIT Ln_Limit;
        Ln_Indx := La_PuntosAdicionales.FIRST;
        --
        EXIT WHEN La_PuntosAdicionales.COUNT = 0;
        --
        WHILE (Ln_Indx IS NOT NULL)  
        LOOP
          BEGIN
            --
             
            DB_COMERCIAL.COMEK_TRANSACTION.P_CREA_FACT_INS_PTO_ADICIONAL(Pn_PuntoId        => La_PuntosAdicionales(Ln_Indx).ID_PUNTO,
                                                                         Pn_IdServicio     => La_PuntosAdicionales(Ln_Indx).ID_SERVICIO,
                                                                         Pv_PrefijoEmpresa => Lv_PrefijoEmpresa,
                                                                         Pv_EstadoContrato => Lv_EstadoActivo,
                                                                         Pv_Mensaje        => Lv_MsjResultado);
        
            Ln_Indx := La_PuntosAdicionales.NEXT(Ln_Indx);
            --
          END; 
        END LOOP;
      END LOOP;      
        
    EXCEPTION
      WHEN OTHERS THEN
        Lv_MsjResultado := 'Ocurrió un error al obtener los Puntos Adicionales para la generación de Facturas de Instalación.';
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'COMEK_TRANSACTION.P_OBTIENE_PUNTOS_ADICIONALES',  
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM , 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );       

  END P_OBTIENE_PUNTOS_ADICIONALES;  
  --                
  --
  PROCEDURE P_MIGRA_INFORMACION_DASHBOARD(
      Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pd_FechaInicio    IN DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
      Pv_MensajeError OUT VARCHAR2)
  IS
    --
    --CURSOR QUE RETORNA SI EXISTE EL ESTADO QUE SE VA A MIGRAR AL DASHBOARD
    --COSTO QUERY:
    CURSOR C_GetValidarEstadoServicio(Cv_EstadoServicio DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                      Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                      Cv_LabelDashboardComercial DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                      Cv_Descripcion DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                      Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Cv_LabelAgrupadas DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
                                      Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
    IS
      --
      SELECT MAX(APD.ID_PARAMETRO_DET) AS ID_PARAMETRO_DET, APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
      WHERE APD.VALOR2         = Cv_EstadoServicio
      AND APD.VALOR3           = Cv_LabelAgrupadas
      AND APD.ESTADO           = Cv_EstadoActivo
      AND APC.ESTADO           = Cv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO = Cv_LabelDashboardComercial
      AND APD.DESCRIPCION      = Cv_Descripcion
      AND APD.VALOR1           = NVL(Cv_Valor1, APD.VALOR1)
      AND APD.EMPRESA_COD      =
        (SELECT COD_EMPRESA
        FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
        WHERE PREFIJO = Cv_PrefijoEmpresa
        AND ESTADO    = Cv_EstadoActivo
        )
      GROUP BY APD.VALOR1;
    --
    --
    --CURSOR QUE RETORNA LA INFORMACION DE LOS SERVICIOS A MIGRARSE HACIA EL DASHBOARD
    --COSTO QUERY:
    CURSOR C_GetServiciosDashboard(Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Cd_FechaInicio DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                   Cd_FechaFinal DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE,
                                   Cv_EstadoPrePlanificada DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                   Cv_EstadoPendiente DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                   Cv_AccionConfirmarServicio DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE,
                                   Cv_LabelAccion VARCHAR2,
                                   Cv_LabelEstado VARCHAR2,
                                   Cv_LabelHistorial VARCHAR2,
                                   Cv_LabelProcesado VARCHAR2,
                                   Cv_ReinicioConteo VARCHAR2,
                                   Cv_LabelCategoria1  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_LabelCategoria2  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_LabelCategoria3  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                   Cv_DescripcionEmpleado  DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE)
    IS
      --
      SELECT MAX(IDS.ID_DASHBOARD_SERVICIO) AS ID_DASHBOARD_SERVICIO,
        ISER.ID_SERVICIO,
        ISER.PUNTO_ID,
        ISER.PRODUCTO_ID,
        ISER.PLAN_ID,
        ISER.ES_VENTA,
        NVL(ISER.CANTIDAD, 0)            AS CANTIDAD,
        NVL(ISER.PRECIO_VENTA, 0)        AS PRECIO_VENTA,
        NVL(ISER.DESCUENTO_UNITARIO, 0)  AS DESCUENTO_UNITARIO,
        NVL(ISER.VALOR_DESCUENTO, 0)     AS DESCUENTO_TOTALIZADO,
        NVL(ISER.FRECUENCIA_PRODUCTO, 0) AS FRECUENCIA_PRODUCTO,
        MAX(ISH.ID_SERVICIO_HISTORIAL)   AS ID_SERVICIO_HISTORIAL,
        ISER.USR_VENDEDOR,
        ISER.TIPO_ORDEN,
        NVL(ISER.PRECIO_INSTALACION, 0)                                                                                                         AS
        PRECIO_INSTALACION,
        SUBSTR(ISER.FE_CREACION, 1, 9)                                                                                                          AS
        FE_CREACION,
        SUBSTR(DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(ISER.ID_SERVICIO, Cv_EstadoPendiente, Cv_LabelEstado, NULL), 1, 9)   AS
        FE_PENDIENTE,
        SUBSTR(DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(ISER.ID_SERVICIO, Cv_EstadoPrePlanificada, Cv_LabelEstado, NULL), 1, 9) AS
        FE_PREPLANIFICADA,
        SUBSTR(DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(ISER.ID_SERVICIO, Cv_AccionConfirmarServicio, Cv_LabelAccion, NULL), 1, 
        9) AS FE_ACTIVACION,
        DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(MAX(ISH.ID_SERVICIO_HISTORIAL), Cv_LabelEstado, Cv_LabelHistorial, NULL)    AS
        ESTADO_SERVICIO,
        DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL(MAX(ISH.ID_SERVICIO_HISTORIAL), NULL, Cv_LabelHistorial, NULL)              AS
        FE_HISTORIAL,
        DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_DASHBOARD_SERVICIO(MAX(IDS.ID_DASHBOARD_SERVICIO), Cv_LabelEstado)                              AS
        ESTADO_MIGRADO,
        DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_DASHBOARD_SERVICIO(MAX(IDS.ID_DASHBOARD_SERVICIO), Cv_LabelProcesado)                           AS
        PROCESADO,
        DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_DASHBOARD_SERVICIO(MAX(IDS.ID_DASHBOARD_SERVICIO), Cv_LabelAccion)                              AS
        ACCION,
        AP.GRUPO,
        AP.SUBGRUPO,
        (
            SELECT
              AC.DESCRIPCION_CARACTERISTICA
            FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC 
            JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC 
            ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
            WHERE
              AC.DESCRIPCION_CARACTERISTICA IN (
                Cv_LabelCategoria1,
                Cv_LabelCategoria2,
                Cv_LabelCategoria3
              )
              AND   AC.ESTADO = Cv_EstadoActivo
              AND   APC.ESTADO = Cv_EstadoActivo
              AND   ROWNUM = 1
              AND APC.PRODUCTO_ID = ISER.PRODUCTO_ID
        ) AS CATEGORIA,
        ( SELECT
            OFICINA_ID
          FROM
            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
          WHERE
            ID_PERSONA_ROL = (
              SELECT
                MAX(IPER.ID_PERSONA_ROL)
              FROM
                DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                JOIN DB_COMERCIAL.INFO_PERSONA IPE ON IPE.ID_PERSONA = IPER.PERSONA_ID
                JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
                JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = IER.EMPRESA_COD
                JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL = IER.ROL_ID
                JOIN DB_GENERAL.ADMI_TIPO_ROL ATR ON AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
              WHERE
                IPE.LOGIN = ISER.USR_VENDEDOR
                AND   IPER.ESTADO = Cv_EstadoActivo
                AND   IEG.PREFIJO = Cv_PrefijoEmpresa
                AND   ATR.DESCRIPCION_TIPO_ROL = Cv_DescripcionEmpleado
                AND   IPER.DEPARTAMENTO_ID IS NOT NULL
            )
         ) AS OFICINA_VENDEDOR_ID
      FROM DB_COMERCIAL.INFO_SERVICIO ISER
      JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
      ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
      JOIN DB_COMERCIAL.ADMI_PRODUCTO AP
      ON AP.ID_PRODUCTO  = ISER.PRODUCTO_ID
      LEFT JOIN DB_COMERCIAL.INFO_DASHBOARD_SERVICIO IDS
      ON IDS.SERVICIO_ID                                                          = ISER.ID_SERVICIO
      WHERE ISH.FE_CREACION                                                      >= Cd_FechaInicio
      AND ISH.FE_CREACION                                                         < Cd_FechaFinal
      AND NVL(ISH.ACCION, 'NULL')                                                <> Cv_ReinicioConteo
      AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(ISER.PUNTO_ID, NULL) = Cv_PrefijoEmpresa
      GROUP BY ISER.ID_SERVICIO,
        ISER.PUNTO_ID,
        ISER.PRODUCTO_ID,
        ISER.PLAN_ID,
        ISER.ES_VENTA,
        ISER.CANTIDAD,
        ISER.PRECIO_VENTA,
        ISER.DESCUENTO_UNITARIO,
        ISER.VALOR_DESCUENTO,
        ISER.FRECUENCIA_PRODUCTO,
        ISER.FE_CREACION,
        ISER.USR_VENDEDOR,
        ISER.TIPO_ORDEN,
        ISER.PRECIO_INSTALACION,
        AP.GRUPO,
        AP.SUBGRUPO;
    --
    --
    Lc_GetServiciosDashboard C_GetServiciosDashboard%ROWTYPE;
    Ln_ContadorCommit NUMBER := 0;
    Ld_FechaInicio DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE;
    Ld_FechaFinal DB_COMERCIAL.INFO_SERVICIO.FE_CREACION%TYPE;
    Le_Exception EXCEPTION;
    Lr_ParamDetEstadoServicio C_GetValidarEstadoServicio%ROWTYPE;
    Lr_ParamDetEstadoDashboard C_GetValidarEstadoServicio%ROWTYPE;
    Lv_MensajeError             VARCHAR2(4000);
    Lv_MigrarInformacion        VARCHAR2(2);
    Lv_UpdateMigraInformacion   VARCHAR2(2);
    Lv_FechaHistorialObtenida   VARCHAR2(50);
    Lv_EstadoHistorialObtenida  VARCHAR2(50);
    Lv_ObsHistorialObtenida     VARCHAR2(100);
    Ln_PrecioAnteriorObtenido   NUMBER;
    Ln_PrecioMigradoObtenido    NUMBER;
    Ln_ValorMRC                 NUMBER;
    Ln_ValorNRC                 NUMBER;
    Lv_Motivo                   VARCHAR2(300);
    Lv_MotivoPadre              VARCHAR2(300);
    Ln_NumeroMesesRestantes     NUMBER;
    Lv_ObsCambioRazonSocial     VARCHAR2(100);
    Lv_VentasCanceladas DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                  := 'VENTAS_CANCELADAS';
    Lv_LabelAgrupadas DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE                    := 'AGRUPADAS';
    Lv_EstadoServicio DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                    := 'ESTADO_SERVICIO';
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                      := 'Activo';
    Lv_LabelDashboardComercial DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_EstadoPrePlanificada DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE                 := 'PrePlanificada';
    Lv_EstadoPendiente DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE                      := 'Pendiente';
    Lv_AccionConfirmarServicio DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE    := 'confirmarServicio';
    Lv_LabelAccion                  VARCHAR2(7)                                    := 'Accion';
    Lv_LabelEstado                  VARCHAR2(7)                                    := 'Estado';
    Lv_LabelHistorial               VARCHAR2(10)                                   := 'Historial';
    Lv_LabelProcesado               VARCHAR2(10)                                   := 'Procesado';
    Lv_ReinicioConteo               VARCHAR2(15)                                   := 'reinicioConteo';
    Lv_Accion  DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ACCION%TYPE                    := 'Nueva';
    Lv_DescripcionEmpleado  DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE     := 'Empleado';
    --
    Lv_LabelCategoria1  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 1';
    Lv_LabelCategoria2  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 2';
    Lv_LabelCategoria3  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CATEGORIA 3';
    --
  BEGIN
    --
    IF Pv_PrefijoEmpresa IS NULL OR Pd_FechaInicio IS NULL THEN
      --
      Pv_MensajeError := 'No se han enviado los parámetros adecuados para la ejecución del procedimiento. PrefijoEmpresa(' || Pv_PrefijoEmpresa ||
                         ') FechaInicio( ' || Pd_FechaInicio || ')';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
    Ld_FechaInicio          := TO_DATE('01-' || TO_CHAR(Pd_FechaInicio, 'MM') || '-' || TO_CHAR(Pd_FechaInicio, 'YY'), 'DD-MM-YY');
    Ld_FechaFinal           := TO_DATE(LAST_DAY(Pd_FechaInicio) + 1, 'DD-MM-YY');
    Ln_NumeroMesesRestantes := 13 - TO_NUMBER( TO_CHAR( Pd_FechaInicio, 'MM'), '99');
    --
    --
    IF C_GetServiciosDashboard%ISOPEN THEN
      --
      CLOSE C_GetServiciosDashboard;
      --
    END IF;
    --
    OPEN C_GetServiciosDashboard(Pv_PrefijoEmpresa,
                                 Ld_FechaInicio,
                                 Ld_FechaFinal,
                                 Lv_EstadoPrePlanificada,
                                 Lv_EstadoPendiente,
                                 Lv_AccionConfirmarServicio,
                                 Lv_LabelAccion,
                                 Lv_LabelEstado,
                                 Lv_LabelHistorial,
                                 Lv_LabelProcesado,
                                 Lv_ReinicioConteo,
                                 Lv_LabelCategoria1,
                                 Lv_LabelCategoria2,
                                 Lv_LabelCategoria3,
                                 Lv_EstadoActivo,
                                 Lv_DescripcionEmpleado);
    LOOP
      --
      FETCH C_GetServiciosDashboard INTO Lc_GetServiciosDashboard;
      --
      EXIT
    WHEN C_GetServiciosDashboard%NOTFOUND;
      --
      --
      Lv_MensajeError            := NULL;
      Lr_ParamDetEstadoServicio  := NULL;
      Lr_ParamDetEstadoDashboard := NULL;
      Lv_MigrarInformacion       := 'N';
      Lv_UpdateMigraInformacion  := 'N';
      Lv_FechaHistorialObtenida  := NULL;
      Ln_PrecioMigradoObtenido   := 0;
      Ln_PrecioAnteriorObtenido  := 0;
      Ln_ValorMRC                := 0;
      Ln_ValorNRC                := 0;
      Lv_Accion                  := 'Nueva';
      --
      --
      IF TRIM(Lc_GetServiciosDashboard.TIPO_ORDEN) = 'R' THEN
        --
        Lv_Accion := 'Reubicado';
        --
      ELSIF TRIM(Lc_GetServiciosDashboard.TIPO_ORDEN) = 'T' THEN
        --
        Ln_ValorNRC := ROUND( (NVL(Lc_GetServiciosDashboard.PRECIO_INSTALACION, 0) / 12), 2 );
        Lv_Accion   := 'Traslado';
        --
      ELSE
        --
        Lv_Accion   := 'Nueva';
        Ln_ValorNRC := ROUND( (NVL(Lc_GetServiciosDashboard.PRECIO_INSTALACION, 0) / 12), 2 );
        --
        --
        IF (Lc_GetServiciosDashboard.CATEGORIA = 'CATEGORIA 2' OR Lc_GetServiciosDashboard.CATEGORIA = 'CATEGORIA 3') 
           AND (Lc_GetServiciosDashboard.FRECUENCIA_PRODUCTO IS NOT NULL AND Lc_GetServiciosDashboard.FRECUENCIA_PRODUCTO >= 1) THEN
          --
          Ln_ValorMRC := ROUND( ( ( ( ( NVL(Lc_GetServiciosDashboard.PRECIO_VENTA, 0) * NVL(Lc_GetServiciosDashboard.CANTIDAD, 0) ) 
                                      - NVL(Lc_GetServiciosDashboard.DESCUENTO_TOTALIZADO, 0) ) / Lc_GetServiciosDashboard.FRECUENCIA_PRODUCTO ) 
                                  * Ln_NumeroMesesRestantes ), 2);
          --
        ELSE
          --
          Ln_ValorMRC := ROUND(( ( NVL(Lc_GetServiciosDashboard.PRECIO_VENTA, 0) * NVL(Lc_GetServiciosDashboard.CANTIDAD, 0) ) 
                                    - NVL(Lc_GetServiciosDashboard.DESCUENTO_TOTALIZADO, 0) ), 2);
          --
        END IF;
        --
      END IF;
      --
      --
      BEGIN
        --
        IF TRIM(Lc_GetServiciosDashboard.ESTADO_SERVICIO) IS NULL THEN
          --
          Lv_MensajeError := 'El servicio (' || Lc_GetServiciosDashboard.ID_SERVICIO || ') no tiene estado de historial (' || 
                              Lc_GetServiciosDashboard.ESTADO_SERVICIO || ').';
          --
          RAISE Le_Exception;
          --
        END IF;
        --
      EXCEPTION
      WHEN Le_Exception THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'COMEK_TRANSACTION.P_MIGRA_INFORMACION_DASHBOARD',
                                              Lv_MensajeError || ' - '|| SQLCODE ||' -ERROR- ' || SQLERRM || ' - ' ||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      END;
      --
      --
      IF Lv_MensajeError IS NULL THEN
        --
        IF Lc_GetServiciosDashboard.ID_DASHBOARD_SERVICIO > 0 THEN
          --
          IF C_GetValidarEstadoServicio%ISOPEN THEN
            CLOSE C_GetValidarEstadoServicio;
          END IF;
          --
          OPEN C_GetValidarEstadoServicio(Lv_EstadoServicio,
                                          Lv_EstadoActivo,
                                          Lv_LabelDashboardComercial,
                                          TRIM(Lc_GetServiciosDashboard.ESTADO_MIGRADO),
                                          Pv_PrefijoEmpresa,
                                          Lv_LabelAgrupadas,
                                          NULL);
          --
          FETCH C_GetValidarEstadoServicio INTO Lr_ParamDetEstadoDashboard;
          --
          CLOSE C_GetValidarEstadoServicio;
          --
          --
          IF C_GetValidarEstadoServicio%ISOPEN THEN
            CLOSE C_GetValidarEstadoServicio;
          END IF;
          --
          OPEN C_GetValidarEstadoServicio(Lv_EstadoServicio,
                                          Lv_EstadoActivo,
                                          Lv_LabelDashboardComercial,
                                          TRIM(Lc_GetServiciosDashboard.ESTADO_SERVICIO),
                                          Pv_PrefijoEmpresa,
                                          Lv_LabelAgrupadas,
                                          NULL);
          --
          FETCH C_GetValidarEstadoServicio INTO Lr_ParamDetEstadoServicio;
          --
          CLOSE C_GetValidarEstadoServicio;
          --
          --
          IF Lr_ParamDetEstadoDashboard.ID_PARAMETRO_DET IS NULL AND Lr_ParamDetEstadoServicio.ID_PARAMETRO_DET > 0 THEN
            --
            IF TRIM(Lc_GetServiciosDashboard.PROCESADO) = 'N' THEN
              --
              Lv_Accion                 := Lc_GetServiciosDashboard.ACCION;
              Lv_UpdateMigraInformacion := 'S';
              Lv_MigrarInformacion      := 'N';
              --
            ELSE
              --
              Lv_MigrarInformacion      := 'S';
              Lv_UpdateMigraInformacion := 'N';
              --
            END IF;
            --
          ELSIF Lr_ParamDetEstadoDashboard.ID_PARAMETRO_DET > 0 AND Lr_ParamDetEstadoServicio.ID_PARAMETRO_DET IS NULL THEN
            --
            IF TRIM(Lc_GetServiciosDashboard.PROCESADO) = 'N' THEN
              --
              Lv_Accion                 := Lc_GetServiciosDashboard.ACCION;
              Lv_UpdateMigraInformacion := 'S';
              Lv_MigrarInformacion      := 'N';
              --
            ELSE
              --
              Lv_MigrarInformacion      := 'S';
              Lv_UpdateMigraInformacion := 'N';
              --
            END IF;
            --
          ELSIF Lr_ParamDetEstadoDashboard.ID_PARAMETRO_DET > 0 AND Lr_ParamDetEstadoServicio.ID_PARAMETRO_DET > 0
                AND Lr_ParamDetEstadoDashboard.VALOR1 <> Lr_ParamDetEstadoServicio.VALOR1 THEN
            --
            IF TRIM(Lc_GetServiciosDashboard.PROCESADO) = 'N' THEN
              --
              Lv_Accion                 := Lc_GetServiciosDashboard.ACCION;
              Lv_UpdateMigraInformacion := 'S';
              Lv_MigrarInformacion      := 'N';
              --
            ELSE
              --
              Lv_MigrarInformacion      := 'S';
              Lv_UpdateMigraInformacion := 'N';
              --
            END IF;
            --
          ELSE
            --
            IF TRIM(Lc_GetServiciosDashboard.PROCESADO) = 'N' AND Lc_GetServiciosDashboard.ID_DASHBOARD_SERVICIO > 0 THEN
              --
              Lv_Accion                 := Lc_GetServiciosDashboard.ACCION;
              Lv_UpdateMigraInformacion := 'S';
              Lv_MigrarInformacion      := 'N';
              --
            END IF;
            --
          END IF;
          --
        ELSE
          --
          IF C_GetValidarEstadoServicio%ISOPEN THEN
            CLOSE C_GetValidarEstadoServicio;
          END IF;
          --
          OPEN C_GetValidarEstadoServicio(Lv_EstadoServicio,
                                          Lv_EstadoActivo,
                                          Lv_LabelDashboardComercial,
                                          TRIM(Lc_GetServiciosDashboard.ESTADO_SERVICIO),
                                          Pv_PrefijoEmpresa,
                                          Lv_LabelAgrupadas,
                                          NULL);
          --
          FETCH C_GetValidarEstadoServicio INTO Lr_ParamDetEstadoServicio;
          --
          CLOSE C_GetValidarEstadoServicio;
          --
          --
          IF Lr_ParamDetEstadoServicio.ID_PARAMETRO_DET > 0 THEN
            --
            Lv_MigrarInformacion := 'S';
            --
          ELSE
            --
            IF Lc_GetServiciosDashboard.FE_PREPLANIFICADA IS NOT NULL AND Lv_MigrarInformacion = 'N' THEN
              --
              IF CAST(TO_DATE(Lc_GetServiciosDashboard.FE_PREPLANIFICADA, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
                 >= CAST(Ld_FechaInicio AS TIMESTAMP WITH LOCAL TIME ZONE) AND 
                 CAST(TO_DATE(Lc_GetServiciosDashboard.FE_PREPLANIFICADA, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
                 < CAST(Ld_FechaFinal AS TIMESTAMP WITH LOCAL TIME ZONE) THEN
                --
                Lv_MigrarInformacion := 'S';
                --
              END IF;
              --
            END IF;
            --
            --
            IF Lc_GetServiciosDashboard.FE_PENDIENTE IS NOT NULL AND Lv_MigrarInformacion = 'N' THEN
              --
              IF CAST(TO_DATE(Lc_GetServiciosDashboard.FE_PENDIENTE, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
                 >= CAST(Ld_FechaInicio AS TIMESTAMP WITH LOCAL TIME ZONE) AND
                 CAST(TO_DATE(Lc_GetServiciosDashboard.FE_PENDIENTE, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
                 < CAST(Ld_FechaFinal AS TIMESTAMP WITH LOCAL TIME ZONE) THEN
                --
                Lv_MigrarInformacion := 'S';
                --
              END IF;
              --
            END IF;
            --
            --
            IF Lc_GetServiciosDashboard.FE_CREACION IS NOT NULL AND Lv_MigrarInformacion = 'N' THEN
              --
              IF CAST(TO_DATE(Lc_GetServiciosDashboard.FE_CREACION, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
                 >= CAST(Ld_FechaInicio AS TIMESTAMP WITH LOCAL TIME ZONE) AND
                 CAST(TO_DATE(Lc_GetServiciosDashboard.FE_CREACION, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
                 < CAST(Ld_FechaFinal AS TIMESTAMP WITH LOCAL TIME ZONE) THEN
                --
                Lv_MigrarInformacion := 'S';
                --
              END IF;
              --
            END IF;
            --
          END IF;
          --
        END IF;--Lc_GetServiciosDashboard.ID_DASHBOARD_SERVICIO > 0
        --
        --
        -- EN ESTE BLOQUE SE VALIDA QUE LA INFORMACIÓN A MIGRAR NO SEA POR CAMBIO DE RAZON SOCIAL
        IF Lv_MigrarInformacion = 'S' THEN
          --
          Lv_ObsCambioRazonSocial := '%razon social%';
          --
          --PRIMERO SE VERIFICA SI EL SERVICIO TIENE UN CAMBIO DE RAZON SOCIAL EN LAS FECHAS CONSULTADAS
          Lv_FechaHistorialObtenida := SUBSTR( DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL( Lc_GetServiciosDashboard.ID_SERVICIO,
                                                                                                            Lv_ObsCambioRazonSocial,
                                                                                                            'HistorialByObservacionFeCreacion',
                                                                                                            Ld_FechaFinal ), 1,
                                                                                                            9 );
          --
          IF TRIM(Lv_FechaHistorialObtenida) IS NOT NULL THEN
            --
            IF CAST(TO_DATE(Lv_FechaHistorialObtenida, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
               < CAST(Ld_FechaInicio AS TIMESTAMP WITH LOCAL TIME ZONE) OR
               CAST(TO_DATE(Lv_FechaHistorialObtenida, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
               >= CAST(Ld_FechaFinal AS TIMESTAMP WITH LOCAL TIME ZONE) THEN
              --
              Lv_FechaHistorialObtenida := NULL;
              --
            END IF;
            --
          END IF;
          --
          --
          IF TRIM(Lv_FechaHistorialObtenida) IS NULL THEN
            --
            Lv_ObsCambioRazonSocial := '%razón social%';
            --
            Lv_FechaHistorialObtenida := SUBSTR( DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL( Lc_GetServiciosDashboard.ID_SERVICIO,
                                                                                                              Lv_ObsCambioRazonSocial,
                                                                                                              'HistorialByObservacionFeCreacion',
                                                                                                              Ld_FechaFinal ), 1,
                                                                                                              9 );
            --
          END IF;
          --
          --
          IF TRIM(Lv_FechaHistorialObtenida) IS NOT NULL THEN
            --
            IF CAST(TO_DATE(Lv_FechaHistorialObtenida, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
               >= CAST(Ld_FechaInicio AS TIMESTAMP WITH LOCAL TIME ZONE) AND
               CAST(TO_DATE(Lv_FechaHistorialObtenida, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
               < CAST(Ld_FechaFinal AS TIMESTAMP WITH LOCAL TIME ZONE) THEN
              --
              Lr_ParamDetEstadoServicio  := NULL;--ESTADO DEL HISTORIAL DE CAMBIO DE RAZON SOCIAL
              Lr_ParamDetEstadoDashboard := NULL;--ESTADO DEL SERVICIO A CONSULTAR
              Lv_EstadoHistorialObtenida := TRIM( DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL( Lc_GetServiciosDashboard.ID_SERVICIO,
                                                                                                               Lv_ObsCambioRazonSocial,
                                                                                                               'HistorialByObservacionEstado',
                                                                                                               Ld_FechaFinal ) );
              --
              IF C_GetValidarEstadoServicio%ISOPEN THEN
                CLOSE C_GetValidarEstadoServicio;
              END IF;
              --
              OPEN C_GetValidarEstadoServicio(Lv_EstadoServicio,
                                              Lv_EstadoActivo,
                                              Lv_LabelDashboardComercial,
                                              Lv_EstadoHistorialObtenida,
                                              Pv_PrefijoEmpresa,
                                              Lv_LabelAgrupadas,
                                              NULL);
              --
              FETCH C_GetValidarEstadoServicio INTO Lr_ParamDetEstadoServicio;
              --
              CLOSE C_GetValidarEstadoServicio;
              --
              --
              IF C_GetValidarEstadoServicio%ISOPEN THEN
                CLOSE C_GetValidarEstadoServicio;
              END IF;
              --
              OPEN C_GetValidarEstadoServicio(Lv_EstadoServicio,
                                              Lv_EstadoActivo,
                                              Lv_LabelDashboardComercial,
                                              Lc_GetServiciosDashboard.ESTADO_SERVICIO,
                                              Pv_PrefijoEmpresa,
                                              Lv_LabelAgrupadas,
                                              NULL);
              --
              FETCH C_GetValidarEstadoServicio INTO Lr_ParamDetEstadoDashboard;
              --
              CLOSE C_GetValidarEstadoServicio;
              --
              --
              IF Lr_ParamDetEstadoServicio.ID_PARAMETRO_DET > 0 THEN
                --
                IF Lr_ParamDetEstadoDashboard.ID_PARAMETRO_DET > 0 THEN
                  --
                  IF Lr_ParamDetEstadoServicio.VALOR1 <> Lr_ParamDetEstadoDashboard.VALOR1 THEN
                    --
                    Lv_Accion   := 'CambioRazonSocial';
                    Ln_ValorMRC := 0;
                    Ln_ValorNRC := 0;
                    --
                  ELSE
                    --
                    Lv_MigrarInformacion := 'N';
                    --
                  END IF;
                  --
                END IF;
                --
              ELSE
                --
                IF Lr_ParamDetEstadoDashboard.ID_PARAMETRO_DET > 0 THEN
                  --
                  Lv_Accion   := 'CambioRazonSocial';
                  Ln_ValorMRC := 0;
                  Ln_ValorNRC := 0;
                  --
                ELSE
                  --
                  Lv_MigrarInformacion := 'N';
                  --
                END IF;
                --
              END IF;
              --
            END IF;
            --
          END IF;
          --
        END IF;--Lv_MigrarInformacion = 'S'
        --
        --
        -- EN ESTE BLOQUE SE VALIDA SI EL PRECIO A CAMBIADO (UPGRADE O DOWNGRADE)
        IF Lv_MigrarInformacion = 'N' OR Lv_UpdateMigraInformacion = 'N' THEN
          --
          --PRIMERO SE VERIFICA SI EL SERVICIO TIENE UN CAMBIO DE PRECIO EN LAS FECHAS CONSULTADAS
          Lv_FechaHistorialObtenida := NULL;
          Lv_FechaHistorialObtenida := SUBSTR( DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL( Lc_GetServiciosDashboard.ID_SERVICIO,
                                                                                                            'confirmoCambioPrecio',
                                                                                                            'Accion',
                                                                                                            NULL ), 1, 9 );
          IF TRIM(Lv_FechaHistorialObtenida) IS NOT NULL THEN
            --
            IF CAST(TO_DATE(Lv_FechaHistorialObtenida, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
               >= CAST(Ld_FechaInicio AS TIMESTAMP WITH LOCAL TIME ZONE) AND
               CAST(TO_DATE(Lv_FechaHistorialObtenida, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
               < CAST(Ld_FechaFinal AS TIMESTAMP WITH LOCAL TIME ZONE) THEN
              --
              Lv_ObsHistorialObtenida := NULL;
              Lv_ObsHistorialObtenida := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL( Lc_GetServiciosDashboard.ID_SERVICIO,
                                                                                                      'confirmoCambioPrecio',
                                                                                                      'HistorialByAccionObservacion',
                                                                                                      Ld_FechaFinal );
              IF TRIM(Lv_ObsHistorialObtenida) IS NOT NULL THEN
                --
                Ln_PrecioMigradoObtenido  := Lc_GetServiciosDashboard.PRECIO_VENTA;
                Ln_PrecioAnteriorObtenido := TO_NUMBER( TRIM( SUBSTR( TRIM(Lv_ObsHistorialObtenida),17 ) ), '999999999D99' );
                --
                --
                IF Ln_PrecioMigradoObtenido > Ln_PrecioAnteriorObtenido THEN
                  --
                  Lc_GetServiciosDashboard.PRECIO_INSTALACION   := 0;
                  Lc_GetServiciosDashboard.DESCUENTO_UNITARIO   := 0;
                  Lc_GetServiciosDashboard.DESCUENTO_TOTALIZADO := 0;
                  Lc_GetServiciosDashboard.PRECIO_VENTA         := ROUND( (Ln_PrecioMigradoObtenido - Ln_PrecioAnteriorObtenido), 2 );
                  --
                  Ln_ValorMRC := Lc_GetServiciosDashboard.PRECIO_VENTA;
                  Ln_ValorNRC := 0;
                  Lv_Accion   := 'CambioPrecio';
                  --
                  --
                  IF Lc_GetServiciosDashboard.ID_DASHBOARD_SERVICIO > 0 THEN
                    --
                    IF TRIM(Lc_GetServiciosDashboard.PROCESADO) = 'N' THEN
                      --
                      Lv_UpdateMigraInformacion := 'S';
                      Lv_MigrarInformacion      := 'N';
                      --
                    ELSE
                      --
                      Lv_MigrarInformacion      := 'S';
                      Lv_UpdateMigraInformacion := 'N';
                      --
                    END IF;
                    --
                  ELSE
                    --
                    Lv_MigrarInformacion      := 'S';
                    Lv_UpdateMigraInformacion := 'N';
                    --
                  END IF;--Lc_GetServiciosDashboard.ID_DASHBOARD_SERVICIO > 0
                  --
                END IF;--Ln_PrecioMigradoObtenido > Ln_PrecioAnteriorObtenido
                --
              END IF;--TRIM(Lv_ObsHistorialObtenida) IS NOT NULL
              --
            END IF;--CAST(TO_DATE(Lv_FechaHistorialObtenida, 'DD-MM-YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
            --
          END IF;--TRIM(Lv_FechaHistorialObtenida) IS NOT NULL 
          --
        END IF;--Lv_MigrarInformacion = 'N' OR Lv_UpdateMigraInformacion = 'N'
        --
        --
        Lr_ParamDetEstadoServicio := NULL;
        --
        IF C_GetValidarEstadoServicio%ISOPEN THEN
            CLOSE C_GetValidarEstadoServicio;
        END IF;
        --
        OPEN C_GetValidarEstadoServicio(Lv_EstadoServicio,
                                        Lv_EstadoActivo,
                                        Lv_LabelDashboardComercial,
                                        Lc_GetServiciosDashboard.ESTADO_SERVICIO,
                                        Pv_PrefijoEmpresa,
                                        Lv_LabelAgrupadas,
                                        Lv_VentasCanceladas);
        --
        FETCH C_GetValidarEstadoServicio INTO Lr_ParamDetEstadoServicio;
        --
        CLOSE C_GetValidarEstadoServicio;
        --
        --
        IF Lr_ParamDetEstadoServicio.ID_PARAMETRO_DET > 0 THEN
          --
          Ln_ValorNRC := 0;
          Ln_ValorMRC := 0;
          --
        END IF;
        --
        --
        Lv_Motivo      := NULL;
        Lv_MotivoPadre := NULL;
        --
        IF Lc_GetServiciosDashboard.ESTADO_SERVICIO = 'Cancel' THEN
          --
          Lv_Motivo      := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL( Lc_GetServiciosDashboard.ID_SERVICIO,
                                                                                         Lc_GetServiciosDashboard.ESTADO_SERVICIO,
                                                                                         'Motivo', 
                                                                                         NULL );
          Lv_MotivoPadre := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_FECHA_CREACION_HISTORIAL( Lc_GetServiciosDashboard.ID_SERVICIO,
                                                                                         Lc_GetServiciosDashboard.ESTADO_SERVICIO,
                                                                                         'MotivoPadre',
                                                                                         NULL );
          --
        END IF;
        --
        --
        IF Lv_MigrarInformacion = 'S' THEN
          --
          Ln_ContadorCommit := Ln_ContadorCommit + 1;
          --
          INSERT
          INTO DB_COMERCIAL.INFO_DASHBOARD_SERVICIO VALUES
            (
              DB_COMERCIAL.SEQ_INFO_DASHBOARD_SERVICIO.NEXTVAL,
              Lc_GetServiciosDashboard.ID_SERVICIO,
              Lc_GetServiciosDashboard.PUNTO_ID,
              'N',
              Lc_GetServiciosDashboard.ES_VENTA,
              Lc_GetServiciosDashboard.ESTADO_SERVICIO,
              Lc_GetServiciosDashboard.FE_HISTORIAL,
              Lc_GetServiciosDashboard.PRECIO_INSTALACION,
              Lc_GetServiciosDashboard.DESCUENTO_UNITARIO,
              Lc_GetServiciosDashboard.DESCUENTO_TOTALIZADO,
              Lc_GetServiciosDashboard.CANTIDAD,
              Lc_GetServiciosDashboard.PRECIO_VENTA,
              TO_CHAR(Ld_FechaInicio, 'YYYY'),
              TO_CHAR(Ld_FechaInicio, 'MM'),
              Lc_GetServiciosDashboard.FRECUENCIA_PRODUCTO,
              Lc_GetServiciosDashboard.PLAN_ID,
              Lc_GetServiciosDashboard.PRODUCTO_ID,
              Lc_GetServiciosDashboard.USR_VENDEDOR,
              Lc_GetServiciosDashboard.TIPO_ORDEN,
              Lc_GetServiciosDashboard.GRUPO,
              Lc_GetServiciosDashboard.SUBGRUPO,
              Lc_GetServiciosDashboard.CATEGORIA,
              Lv_Accion,
              Ln_ValorMRC,
              Ln_ValorNRC,
              Lc_GetServiciosDashboard.OFICINA_VENDEDOR_ID,
              Lv_MotivoPadre,
              Lv_Motivo
            );
          --
        ELSIF Lv_UpdateMigraInformacion = 'S' THEN
          --
          Ln_ContadorCommit := Ln_ContadorCommit + 1;
          --
          UPDATE DB_COMERCIAL.INFO_DASHBOARD_SERVICIO
          SET ES_VENTA                = Lc_GetServiciosDashboard.ES_VENTA,
            PUNTO_ID                  = Lc_GetServiciosDashboard.PUNTO_ID,
            ESTADO                    = Lc_GetServiciosDashboard.ESTADO_SERVICIO,
            FECHA_TRANSACCION         = Lc_GetServiciosDashboard.FE_HISTORIAL,
            PRECIO_INSTALACION        = Lc_GetServiciosDashboard.PRECIO_INSTALACION,
            DESCUENTO_UNITARIO        = Lc_GetServiciosDashboard.DESCUENTO_UNITARIO,
            DESCUENTO_TOTALIZADO      = Lc_GetServiciosDashboard.DESCUENTO_TOTALIZADO,
            CANTIDAD                  = Lc_GetServiciosDashboard.CANTIDAD,
            PRECIO_VENTA              = Lc_GetServiciosDashboard.PRECIO_VENTA,
            FRECUENCIA_PRODUCTO       = Lc_GetServiciosDashboard.FRECUENCIA_PRODUCTO,
            USR_VENDEDOR              = Lc_GetServiciosDashboard.USR_VENDEDOR,
            TIPO_ORDEN                = Lc_GetServiciosDashboard.TIPO_ORDEN,
            GRUPO                     = Lc_GetServiciosDashboard.GRUPO,
            SUBGRUPO                  = Lc_GetServiciosDashboard.SUBGRUPO,
            CATEGORIA                 = Lc_GetServiciosDashboard.CATEGORIA,
            ACCION                    = Lv_Accion,
            MRC                       = Ln_ValorMRC,
            NRC                       = Ln_ValorNRC,
            OFICINA_VENDEDOR_ID       = Lc_GetServiciosDashboard.OFICINA_VENDEDOR_ID,
            MOTIVO_PADRE_CANCELACION  = Lv_MotivoPadre,
            MOTIVO_CANCELACION        = Lv_Motivo
          WHERE ID_DASHBOARD_SERVICIO = Lc_GetServiciosDashboard.ID_DASHBOARD_SERVICIO;
          --
        END IF;--Lv_MigrarInformacion = 'S'
        --
        --
        IF Ln_ContadorCommit = 5000 THEN
          --
          Ln_ContadorCommit := 0;
          --
          COMMIT;
          --
        END IF;
        --
      END IF;--Lv_MensajeError IS NULL
      --
    END LOOP;
    --
    --
    IF Ln_ContadorCommit < 5000 THEN
      --
      COMMIT;
      --
    END IF;
    --
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'COMEK_TRANSACTION.P_MIGRA_INFORMACION_DASHBOARD',
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                          '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    Pv_MensajeError := 'Error al migrar la información del dashboard comercial.';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'COMEK_TRANSACTION.P_MIGRA_INFORMACION_DASHBOARD',
                                          Pv_MensajeError || ' - ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                          ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_MIGRA_INFORMACION_DASHBOARD;
  --
  --
  PROCEDURE COMEP_CONTEO_FRECUENCIAS(
      Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_EstadoServicio      IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pn_IdServicio          IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Pn_MesesRestantes      IN DB_COMERCIAL.INFO_SERVICIO.MESES_RESTANTES%TYPE,
      Pv_LlamadoProcedure    IN VARCHAR2,
      Pv_FechaReinicioConteo OUT VARCHAR2,
      Pv_MensajeError        OUT VARCHAR2)
  AS
    --
    --CURSOR QUE RETORNA LOS SERVICIOS A LOS CUALES SE LES VA A REALIZAR EL CALCULO DE MESES RESTANTES
    --COSTO DEL QUERY: 234
    CURSOR C_ConteoFrecuencia(Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                              Cv_EstadoServicio DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                              Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Cn_MesesRestantes DB_COMERCIAL.INFO_SERVICIO.MESES_RESTANTES%TYPE)
    IS
      SELECT ISER.ID_SERVICIO,
        ISER.PUNTO_FACTURACION_ID,
        ISER.PUNTO_ID,
        ISER.PRODUCTO_ID,
        ISER.PRECIO_VENTA,
        ISER.FRECUENCIA_PRODUCTO,
        ISER.MESES_RESTANTES,
        ISER.ESTADO,
        (SELECT LOGIN FROM DB_COMERCIAL.INFO_PUNTO WHERE ID_PUNTO = ISER.PUNTO_ID
        ) LOGIN
    FROM DB_COMERCIAL.INFO_SERVICIO ISER
    WHERE ISER.ESTADO                                                           = Cv_EstadoServicio
    AND NVL(ISER.MESES_RESTANTES, NVL(Cn_MesesRestantes, 1))                    >= NVL(Cn_MesesRestantes, 1)
    AND ISER.FRECUENCIA_PRODUCTO                                                > 0
    AND ISER.ID_SERVICIO                                                        = NVL(Cn_IdServicio, ISER.ID_SERVICIO)
    AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(ISER.PUNTO_ID, NULL) = Cv_PrefijoEmpresa
    ORDER BY ISER.ID_SERVICIO;
    --
    --CURSOR QUE RETORNA LA FECHA DE CREACION DEL SERVICIO YA SEA POR LA OBSERVACION O LA ACCION DEL HISTORIAL DEL SERVICIO
    --COSTO DEL QUERY: 3
    CURSOR C_FechaCreacionServicio(Cv_Observacion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE, 
                                   Cv_Accion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE,
                                   Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT
        TRUNC(ISERH.FE_CREACION)
      FROM
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
      WHERE
        ISERH.ID_SERVICIO_HISTORIAL =
        (
          SELECT
            MIN(ISERH_S.ID_SERVICIO_HISTORIAL)
          FROM
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH_S
          WHERE
            ISERH_S.SERVICIO_ID = Cn_IdServicio
          AND
            (
              ISERH_S.OBSERVACION LIKE Cv_Observacion
              OR ISERH_S.ACCION    =   Cv_Accion
            )
        );
    --
    --CURSOR QUE RETORNA LA FECHA DE CREACION DE UN SERVICIO FILTRANDO POR UNA ACCION ESPECIFICA DEL HISTORIAL
    --COSTO DEL QUERY: 3
    CURSOR C_FeCreacionByAccion(Cv_Accion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE,
                                Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Cv_Estado DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ESTADO%TYPE)
    IS
      SELECT
        TRUNC(ISERH.FE_CREACION)
      FROM
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
      WHERE
        ISERH.SERVICIO_ID             = Cn_IdServicio
      AND ISERH.ID_SERVICIO_HISTORIAL =
        (
          SELECT
            MAX(ISERH_S.ID_SERVICIO_HISTORIAL)
          FROM
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH_S
          WHERE
            ISERH_S.ACCION        = Cv_Accion
          AND ISERH_S.SERVICIO_ID = Cn_IdServicio
          AND ISERH_S.ESTADO      = Cv_Estado
        );
    --
    --CURSOR QUE RETORNA EL VALOR EN FORMATO DE FECHA DE LAS CARACTERISTICAS CONSULTADAS
    --COSTO DEL QUERY: 4
    CURSOR C_GetCaracteristicaDocumento(Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE, 
                                        Cn_IdDocumentoFinanciero DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                        Cv_EstadoCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE,
                                        Cv_EstadoDocumentoCaract DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE)
    IS
      SELECT
        TO_DATE(TRIM(SUBSTR(TRIM(IDC.VALOR), 1, 10 )), 'DD-MM-YYYY')
      FROM
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
      ON
        AC.ID_CARACTERISTICA = IDC.CARACTERISTICA_ID
      WHERE
        IDC.DOCUMENTO_ID                = Cn_IdDocumentoFinanciero
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND AC.ESTADO                     = Cv_EstadoCaracteristica
      AND IDC.ESTADO                    = Cv_EstadoDocumentoCaract;
    --
    CURSOR C_ValidaTipoFactura(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
                               Cv_TipoAValidar DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
    IS
      SELECT
        CASE
          WHEN ATDF.CODIGO_TIPO_DOCUMENTO = Cv_TipoAValidar
          THEN 'S'
          ELSE 'N'
        END VALIDACION
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
      WHERE IDFC.ID_DOCUMENTO   = Cn_IdDocumento;
    --
    CURSOR C_GetEmpresaCod(Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                           Cv_EstadoActivo DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE)
    IS
      SELECT COD_EMPRESA
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
      WHERE ESTADO = Cv_EstadoActivo
      AND PREFIJO  = Cv_PrefijoEmpresa;
    --
    CURSOR C_GetEsPrepago (Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) 
    IS
      SELECT iper.ES_PREPAGO 
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper 
	    INNER JOIN DB_COMERCIAL.INFO_PUNTO ip ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
	    INNER JOIN DB_COMERCIAL.INFO_SERVICIO is2 ON ip.ID_PUNTO = is2.PUNTO_ID 
	    WHERE is2.ID_SERVICIO = Cn_IdServicio;
    --
    Ln_MesesTranscurridos         NUMBER                                                                  := 0;
    Lv_FechaActivacion            VARCHAR2(50)                                                            := '';
    Ln_ContadorServicios          NUMBER                                                                  := 0;
    Ln_MesesActualizados          NUMBER                                                                  := 0;
    Ln_CompararFechas             NUMBER                                                                  := 0;
    Lv_FechaCreacionTmp           VARCHAR2(15)                                                            := '';
    Lv_FechaActivacionTmp         VARCHAR2(15)                                                            := '';
    Lv_FechaMesAnioConsumo        VARCHAR2(15)                                                            := '';
    Lv_FechaRangoConsumo          VARCHAR2(40)                                                            := '';
    Lv_FechaRangoConsumoIni       VARCHAR2(40)                                                            := '';
    Lv_FechaRangoConsumoFin       VARCHAR2(40)                                                            := '';
    Lv_AnioIni                    VARCHAR2(2)                                                             := '';
    Lv_AnioFin                    VARCHAR2(2)                                                             := '';
    Lv_FechaCreacionServicio      VARCHAR2(40)                                                            := '';
    Lv_UsrCreacion                VARCHAR2(14)                                                            := 'telcos_conteo';
    Lv_IpCreacion                 VARCHAR2(10)                                                            := '127.0.0.1';
    Lv_TipoFacturaAValidar        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'FACP';
    Lv_RespuestaValidacion        VARCHAR2(2)                                                             := '';
    Lv_EstadoActivo               DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ESTADO%TYPE                        := 'Activo';
    Lv_EmpresaCod                 VARCHAR2(3)                                                             := '';
    Lv_FechaInicioPeriodo         VARCHAR2(15)                                                            := '';
    Lv_FechaFinPeriodo            VARCHAR2(15)                                                            := '';
    Lv_EsPrepago                  VARCHAR2(1)                                                             := '';
    Ln_CantidadDiasTotalMes       NUMBER                                                                  := 0;
    Ln_CantidadDiasRestantes      NUMBER                                                                  := 0;
    Lv_FormatoFecha               VARCHAR2(10)                                                            := 'YYYY-MM-DD';
    Lr_InfoDocumentoFinancieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Ln_IdServicioHistorial        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE;  
    --
  BEGIN
    --
    --BLOQUE QUE VERIFICA SI EL PROCEDIMIENTO ES LLAMADO DESDE UN JOB PARA CAMBIAR EL FORMATO DE FECHAS A UTILIZAR
    IF TRIM(Pv_LlamadoProcedure) IS NOT NULL AND TRIM(Pv_LlamadoProcedure) = 'JOB' THEN
      --
      Lv_FormatoFecha := 'DD-MM-YY';
      --
    END IF;
    --
    -- BLOQUE QUE OBTIENE EL CODIGO DE LA EMPRESA DEL PREFIJO ENVIADO COMO PARAMETRO
    --
    IF C_GetEmpresaCod%ISOPEN THEN
      CLOSE C_GetEmpresaCod;
    END IF;
    --
    OPEN C_GetEmpresaCod(Pv_PrefijoEmpresa, Lv_EstadoActivo);
    --
    FETCH C_GetEmpresaCod INTO Lv_EmpresaCod;
    --
    CLOSE C_GetEmpresaCod;
    --
    --
    IF C_ConteoFrecuencia%ISOPEN THEN
      CLOSE C_ConteoFrecuencia;
    END IF;
    --
    -- SE RECORRE EL LISTADO DE SERVICIOS ACTIVOS DE LA EMPRESA ENVIADA POR EL USUARIO PARA VERIFICAR LOS MESES TRANSCURRIDOS
    FOR I_ConteoFrecuencia IN C_ConteoFrecuencia(Pv_PrefijoEmpresa, Pv_EstadoServicio, Pn_IdServicio, Pn_MesesRestantes)
    LOOP
      --
      Lv_FechaActivacion := NULL;
      --
      -- BLOQUE QUE OBTIENE LA FECHA DE ACTIVACIÓN DEL SERVICIO
      --
      IF C_FechaCreacionServicio%ISOPEN THEN
        CLOSE C_FechaCreacionServicio;
      END IF;
      --
      OPEN C_FechaCreacionServicio('Se confirmo el servicio', 'confirmarServicio', I_ConteoFrecuencia.ID_SERVICIO);
      --
      FETCH C_FechaCreacionServicio INTO Lv_FechaCreacionServicio;
      --
      CLOSE C_FechaCreacionServicio;
      --
      --
      -- BLOQUE QUE OBTIENE LA FECHA DE RENOVACION DEL PLAN DEL SERVICIO CON LA QUE SE VERIFICARAN LOS MESES TRANSCURRIDOS EN CASO DE EXISTIR
      --
      IF C_FeCreacionByAccion%ISOPEN THEN
        CLOSE C_FeCreacionByAccion;
      END IF;
      --
      OPEN C_FeCreacionByAccion('renovacionPlan', I_ConteoFrecuencia.ID_SERVICIO, Lv_EstadoActivo);
      --
      FETCH C_FeCreacionByAccion INTO Lv_FechaActivacion;
      --
      CLOSE C_FeCreacionByAccion;
      --
      --
      -- SI NO SE ENCUENTRA FECHA DE RENOVACIÓN DE PLAN SE BUSCA FECHA DE FACTURAS CREADAS POR MES Y AÑO DE CONSUMO, O RANGO DE CONSUMO
      IF Lv_FechaActivacion IS NULL THEN
        --
        Lv_FechaMesAnioConsumo := NULL;
        Lv_FechaRangoConsumo   := NULL;
        Lv_FechaRangoConsumoIni:= NULL;
        Lv_FechaRangoConsumoFin:= NULL;
        Lv_AnioIni             := NULL;
        Lv_AnioFin             := NULL;
        --
        -- SE BUSCA DOCUMENTO POR MES Y AÑO DE CONSUMO, SE AGREGA QUE POR PRIORIDAD OBTENGA LA FACTURA POR SERVICIO FACTURADO O POR
        -- PRODUCTO Y PRECIO_VENTA O SOLO POR PRODUCTO ASOCIADO. 
        Lr_InfoDocumentoFinancieroCab := DB_FINANCIERO.FNCK_CONSULTS.F_GET_MAX_DOCUMENTO_SERV_PROD(I_ConteoFrecuencia.PUNTO_FACTURACION_ID, 
                                                                                         I_ConteoFrecuencia.PUNTO_ID,
                                                                                         I_ConteoFrecuencia.ID_SERVICIO,
                                                                                         I_ConteoFrecuencia.PRODUCTO_ID, 
                                                                                         I_ConteoFrecuencia.PRECIO_VENTA,
                                                                                         'mesAnioConsumo');
        --
        -- SI ENCUENTRA DOCUMENTO SETEO EL MES Y AÑO DE CONSUMO COMO FECHA CON LA CUAL SE VA A REALIZAR LA VALIDACION DE LOS MESES TRANSCURRIDOS
        IF Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO IS NOT NULL THEN
          --
          -- BLOQUE QUE VERIFICA SI LA ÚLTIMA FACTURA EMITIDA FUE UNA PROPORCIONAL
          IF C_ValidaTipoFactura%ISOPEN THEN
            CLOSE C_ValidaTipoFactura;
          END IF;
          --
          OPEN C_ValidaTipoFactura(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO, Lv_TipoFacturaAValidar);
          --
          FETCH C_ValidaTipoFactura INTO Lv_RespuestaValidacion;
          --
          CLOSE C_ValidaTipoFactura;
          --
          -- SI NO FUE UNA FACTURA PROPORCIONAL SETEO LA FECHA DE CONSUMO DEL DOCUMENTO
          IF Lv_RespuestaValidacion = 'N' THEN
            --
            --BLOQUE QUE VERIFICA SI EL PROCEDIMIENTO ES LLAMADO DESDE UN JOB PARA CAMBIAR EL FORMATO DE FECHA A UTILIZAR
            IF TRIM(Pv_LlamadoProcedure) IS NOT NULL AND TRIM(Pv_LlamadoProcedure) = 'JOB' THEN
              --
              Lv_FechaMesAnioConsumo := '01-' || LPAD(Lr_InfoDocumentoFinancieroCab.MES_CONSUMO, 2, '0') || '-' 
                                        || Lr_InfoDocumentoFinancieroCab.ANIO_CONSUMO;
              --
            ELSE
              --
              Lv_FechaMesAnioConsumo := Lr_InfoDocumentoFinancieroCab.ANIO_CONSUMO || '-' || LPAD(Lr_InfoDocumentoFinancieroCab.MES_CONSUMO, 2, '0')
                                        || '-01';
              --
            END IF;
            
            --
          END IF;
          --
        END IF;
        --
        Lr_InfoDocumentoFinancieroCab := NULL;
        Lv_RespuestaValidacion        := '';
       --
        -- SE BUSCA DOCUMENTO POR RANGO DE CONSUMO ,SE AGREGA QUE POR PRIORIDAD OBTENGA LA FACTURA POR SERVICIO FACTURADO O POR
        -- PRODUCTO Y PRECIO_VENTA O SOLO POR PRODUCTO ASOCIADO.      
        Lr_InfoDocumentoFinancieroCab := DB_FINANCIERO.FNCK_CONSULTS.F_GET_MAX_DOCUMENTO_SERV_PROD(I_ConteoFrecuencia.PUNTO_FACTURACION_ID, 
                                                                                         I_ConteoFrecuencia.PUNTO_ID,
                                                                                         I_ConteoFrecuencia.ID_SERVICIO,
                                                                                         I_ConteoFrecuencia.PRODUCTO_ID, 
                                                                                         I_ConteoFrecuencia.PRECIO_VENTA,
                                                                                         'rangoConsumo');
        --
        -- SI ENCUENTRA DOCUMENTO SE BUSCA LA FECHA FINAL DEL RANGO GUARDADO POR EL USUARIO
        IF Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO IS NOT NULL THEN
          --
          -- BLOQUE QUE VERIFICA SI LA ÚLTIMA FACTURA EMITIDA FUE UNA PROPORCIONAL
          IF C_ValidaTipoFactura%ISOPEN THEN
            CLOSE C_ValidaTipoFactura;
          END IF;
          --
          OPEN C_ValidaTipoFactura(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO, Lv_TipoFacturaAValidar);
          --
          FETCH C_ValidaTipoFactura INTO Lv_RespuestaValidacion;
          --
          CLOSE C_ValidaTipoFactura;
          --
          -- SI NO FUE UNA FACTURA PROPORCIONAL SETEO LA FECHA FINAL DEL RANGO DE CONSUMO DEL DOCUMENTO
          IF Lv_RespuestaValidacion = 'N' THEN
            --
            IF C_GetCaracteristicaDocumento%ISOPEN THEN
              CLOSE C_GetCaracteristicaDocumento;
            END IF;
             --
            -- DEBO OBTENER LA FECHA INICIO Y FECHA FIN DE RANGO DE FACTURACION, SI EL ANIO DE LA FECHA (FE_RANGO_FINAL) ES MAYOR AL ANIO 
            -- DE LA FECHA (FE_RANGO_INICIAL) ENTONCES DEBO USAR LA FECHA DE RANGO DE CONSUMO INICIAL COMO REFERENCIA PARA EL CALCULO DE MESES
            -- TRANSCURRIDOS, CASO CONTRARIO DEBO USAR LA FECHA DE RANGO DE CONSUMO FINAL.
            OPEN C_GetCaracteristicaDocumento('FE_RANGO_INICIAL', Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO, Lv_EstadoActivo, Lv_EstadoActivo);
            --
            FETCH C_GetCaracteristicaDocumento INTO Lv_FechaRangoConsumoIni;
            --
            CLOSE C_GetCaracteristicaDocumento;
            --            
            OPEN C_GetCaracteristicaDocumento('FE_RANGO_FINAL', Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO, Lv_EstadoActivo, Lv_EstadoActivo);
            --
            FETCH C_GetCaracteristicaDocumento INTO Lv_FechaRangoConsumoFin;
            --
            CLOSE C_GetCaracteristicaDocumento;
            --
            IF Lv_FechaRangoConsumoIni IS NOT NULL AND Lv_FechaRangoConsumoFin IS NOT NULL THEN            
              --
              Lv_AnioIni:=TO_CHAR(TO_DATE(Lv_FechaRangoConsumoIni,'DD-MM-YYYY'),'YY');
              --
              Lv_AnioFin:=TO_CHAR(TO_DATE(Lv_FechaRangoConsumoFin,'DD-MM-YYYY'),'YY');
              --
              IF Lv_AnioFin > Lv_AnioIni THEN
                  --
                  Lv_FechaRangoConsumo:=Lv_FechaRangoConsumoIni;
                  --
              ELSE
                  --
                  Lv_FechaRangoConsumo:=Lv_FechaRangoConsumoFin;
                  --
              END IF;
              --
            END IF;
            --
          END IF;
          --
        END IF;
        --
        -- SE SE ENCUENTRAN LA FECHAS POR MES-AÑO DE CONSUMO Y POR RANGO DE CONSUMO SE VERIFICA CUAL ES MAYOR PARA USAR ESA FECHA COMO REFERENCIA
        -- PARA EL CALCULO DE MESES TRANSCURRIDOS
        IF TRIM(Lv_FechaMesAnioConsumo) IS NOT NULL AND TRIM(Lv_FechaRangoConsumo) IS NOT NULL THEN
          --
          IF TO_DATE(Lv_FechaMesAnioConsumo, Lv_FormatoFecha) >= TO_DATE(Lv_FechaRangoConsumo, Lv_FormatoFecha) THEN
            --
            Lv_FechaActivacion := Lv_FechaMesAnioConsumo;
            --
          ELSE
            --
            Lv_FechaActivacion := Lv_FechaRangoConsumo;
            --
          END IF;
          --
          -- CASO CONTRARIO SI SE TIENE LA FECHA MES-AÑO CONSUMO SE USA COMO REFERENCIA PARA EL CALCULO DE MESES TRANSCURRIDOS
        ELSIF TRIM(Lv_FechaMesAnioConsumo) IS NOT NULL THEN
          --
          Lv_FechaActivacion := Lv_FechaMesAnioConsumo;
          --
          -- CASO CONTRARIO SI SE TIENE LA FECHA RANGO CONSUMO SE USA COMO REFERENCIA PARA EL CALCULO DE MESES TRANSCURRIDOS
        ELSIF TRIM(Lv_FechaRangoConsumo) IS NOT NULL THEN
          --
          Lv_FechaActivacion := Lv_FechaRangoConsumo;
          --
          -- CASO CONTRARIO SE SETEA EN NULL LA VARIABLE 'Lv_FechaActivacion'
        ELSE
          --
          Lv_FechaActivacion := NULL;
          --
        END IF;
        --
        -- SE VERIFICA SI LA VARIABLE 'Lv_FechaActivacion' ES MAYOR QUE LA FECHA DE CREACION DEL SERVICIO PARA TOMAR DICHA FECHA COMO REFERENCIA PARA
        -- EL CALCULO DE MESES TRANSCURRIDOS CASO CONTRARIO SETEO EN NULL LA VARIABLE 'Lv_FechaActivacion'
        IF Lv_FechaActivacion IS NOT NULL AND TRIM(Lv_FechaCreacionServicio) IS NOT NULL THEN
          --
          Lv_FechaCreacionTmp := SUBSTR(Lv_FechaCreacionServicio, 0, 10 );
          --
          Lv_FechaActivacionTmp := SUBSTR(Lv_FechaActivacion, 0, 10);
          --
          IF TO_DATE(Lv_FechaActivacionTmp, Lv_FormatoFecha) < TO_DATE(Lv_FechaCreacionTmp, Lv_FormatoFecha) THEN
            --
            Lv_FechaActivacion := NULL;
            --
          END IF;
          --
        END IF;
        --
      END IF;
      --
      -- SI LA VARIABLE 'Lv_FechaActivacion' ES NULL SE BUSCA LA FECHA EN EL HISTORIAL DEL SERVICIO POR REINICIO DE CONTEO
      IF Lv_FechaActivacion IS NULL THEN
        --
        IF C_FeCreacionByAccion%ISOPEN THEN
          CLOSE C_FeCreacionByAccion;
        END IF;
        --
        OPEN C_FeCreacionByAccion('reinicioConteo', I_ConteoFrecuencia.ID_SERVICIO, Lv_EstadoActivo);
        --
        FETCH C_FeCreacionByAccion INTO Lv_FechaActivacion;
        --
        CLOSE C_FeCreacionByAccion;
        --
      END IF;
      --
      -- SI LA VARIABLE 'Lv_FechaActivacion' ES NULL SE USA LA FECHA DE CREACION DEL SERVICIO SI LA FECHA DE CREACION NO ES NULL
      IF Lv_FechaActivacion IS NULL AND Lv_FechaCreacionServicio IS NOT NULL THEN
        --
        Lv_FechaActivacion := Lv_FechaCreacionServicio;
        --
        -- SE COMPARA QUE LA FECHA DE ACTIVACION NO ESTE DENTRO DEL RANGO DE LA FECHA DE FACTURACION Y SE VERIFICA SI TIENE FRECUENCIA_PRODUCTO
        -- IGUAL A UNO PARA HABILITARLO PARA FACTURACION
        IF NVL(I_ConteoFrecuencia.FRECUENCIA_PRODUCTO, 0) = 1 THEN
          --
          -- SE OBTIENE EL PERIODO DE FACTURACION DEL SERVICIO DEPENDIENDO DE SU FECHA DE ACTIVACION
          DB_FINANCIERO.FNCK_CONSULTS.P_GET_FECHAS_DIAS_PERIODO( Lv_EmpresaCod, 
                                                                 TO_CHAR(TO_DATE(Lv_FechaActivacion, 'DD-MM-YY'), 'YYYY-MM-DD'), 
                                                                 Lv_FechaInicioPeriodo, 
                                                                 Lv_FechaFinPeriodo, 
                                                                 Ln_CantidadDiasTotalMes,
                                                                 Ln_CantidadDiasRestantes );
          --
          IF TRIM(Lv_FechaInicioPeriodo) IS NOT NULL AND TRIM(Lv_FechaFinPeriodo) IS NOT NULL THEN
            --
            -- SE COLOCA EL FORMATO 'YYYY-MM-DD' AL SYSDATE PARA SER COMPARADO CONTRA LAS FECHAS DE INICIO Y FIN DEL PERIODO FACTURADO QUE SON 
            -- RETORNADAS DEL PROCEDURE 'DB_FINANCIERO.FNCK_CONSULTS.P_GET_FECHAS_DIAS_PERIODO' CON EL FORMATO 'YYYY-MM-DD'
            IF TO_DATE(SYSDATE, 'YYYY-MM-DD') < TO_DATE(Lv_FechaInicioPeriodo, 'YYYY-MM-DD') 
               OR TO_DATE(SYSDATE, 'YYYY-MM-DD') > TO_DATE(Lv_FechaFinPeriodo, 'YYYY-MM-DD') THEN
              --
              Lv_FechaActivacion := NULL;
              --
            END IF;
            --
          END IF;
          --
        END IF;
        --
      END IF;
      --
      Pv_FechaReinicioConteo  := '';
      --
      IF Lv_FechaActivacion IS NOT NULL THEN
        --
        Pv_FechaReinicioConteo := TRIM(SUBSTR(TRIM(Lv_FechaActivacion), 0, 10 ));
        --
      END IF;
      --
      -- SE CALCULAN LOS MESES RESTANTES DEL SERVICIO SI LA VARIABLE 'Lv_FechaActivacion' NO ES NULL Y 'Pv_LlamadoProcedure' ES IGUAL A 'JOB'
      IF TRIM(Pv_LlamadoProcedure) IS NOT NULL AND TRIM(Pv_LlamadoProcedure) = 'JOB' THEN
        --
        IF Pv_FechaReinicioConteo IS NOT NULL THEN
          --
          Lv_FechaActivacionTmp := Pv_FechaReinicioConteo;
          --
          Ln_MesesTranscurridos := MONTHS_BETWEEN( TO_DATE(SYSDATE, Lv_FormatoFecha), TO_DATE(Lv_FechaActivacionTmp, Lv_FormatoFecha) );
          --
          -- BLOQUE QUE OBTIENE LA FECHA DE RENOVACION DEL PLAN DEL SERVICIO CON LA QUE SE VERIFICARAN LOS MESES TRANSCURRIDOS EN CASO DE EXISTIR
          --
          IF C_GetEsPrepago%ISOPEN THEN
            CLOSE C_GetEsPrepago;
          END IF;
          --
          OPEN C_GetEsPrepago(I_ConteoFrecuencia.ID_SERVICIO);
          --
          FETCH C_GetEsPrepago INTO Lv_EsPrepago;
          --
          CLOSE C_GetEsPrepago;
          --
          IF Lv_EsPrepago = 'S' THEN
            Ln_MesesTranscurridos := FLOOR( NVL(Ln_MesesTranscurridos, 0) );
          ELSE
            Ln_MesesTranscurridos := CEIL( NVL(Ln_MesesTranscurridos, 0) );
          END IF;
          --
          IF Ln_MesesTranscurridos > NVL(I_ConteoFrecuencia.FRECUENCIA_PRODUCTO, 0) THEN
            --
            Ln_MesesActualizados := 0;
            --
          ELSE
            --
            IF Ln_MesesTranscurridos >= 0 THEN
              --
              Ln_MesesActualizados := NVL(I_ConteoFrecuencia.FRECUENCIA_PRODUCTO, 0) - NVL(Ln_MesesTranscurridos, 0);
              --
            ELSE
              --
              Ln_MesesActualizados := NVL(I_ConteoFrecuencia.FRECUENCIA_PRODUCTO, 0);
              --
            END IF;
            --
          END IF;
          --
          BEGIN
            --
            UPDATE DB_COMERCIAL.INFO_SERVICIO
            SET MESES_RESTANTES = Ln_MesesActualizados
            WHERE ID_SERVICIO   = I_ConteoFrecuencia.ID_SERVICIO;
            --
            Ln_ContadorServicios := Ln_ContadorServicios + 1;
            --
            Ln_IdServicioHistorial:=DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
            INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
             (ID_SERVICIO_HISTORIAL,
             SERVICIO_ID,
             USR_CREACION,
             FE_CREACION,
             IP_CREACION,
             ESTADO,
             MOTIVO_ID,
             ACCION,
             OBSERVACION)
            VALUES 
            (Ln_IdServicioHistorial,
             I_ConteoFrecuencia.ID_SERVICIO,
            NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion),
             SYSDATE,
            Lv_IpCreacion,
             I_ConteoFrecuencia.ESTADO,
             null,   
            'conteoFrecuencia',         
            'Se Actualiza los meses restantes: ' ||
            ' <br/><b>Meses_restantes anterior:</b> ' || I_ConteoFrecuencia.MESES_RESTANTES || 
            ' <br/><b>Meses_restantes nuevo:</b>  ' || Ln_MesesActualizados || 
            ' <br/><b>Fecha de Reinicio de Conteo:</b>  ' || Pv_FechaReinicioConteo ||
            ' <br/><b>Meses Transcurridos:</b>  ' || Ln_MesesTranscurridos  || '<br/>' 
            );
           --      
          EXCEPTION
          WHEN OTHERS THEN
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                  'COMEK_TRANSACTION.COMEP_CONTEO_FRECUENCIAS', 
                                                  'No se pudo actualizar los meses restantes del servicio a (' || Ln_MesesActualizados ||'). ' 
                                                  || 'ID_SERVICIO = ' || I_ConteoFrecuencia.ID_SERVICIO || ' - ' || SQLCODE || ' -ERROR- '
                                                  || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                  NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion), 
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
            --
          END;
          --
          -- CUANDO NO SE TIENE FECHA DE ACTIVACION DEL SERVICIO Y TIENE FRECUENCIA_PRODUCTO IGUAL A 1 SE DEBE HABILITAR PARA FACTURAR.
        ELSE
          --
          IF I_ConteoFrecuencia.FRECUENCIA_PRODUCTO IS NOT NULL AND I_ConteoFrecuencia.FRECUENCIA_PRODUCTO = 1 THEN
            --
            BEGIN
              --
              UPDATE DB_COMERCIAL.INFO_SERVICIO
              SET MESES_RESTANTES = 0
              WHERE ID_SERVICIO   = I_ConteoFrecuencia.ID_SERVICIO;
              --
              Ln_ContadorServicios := Ln_ContadorServicios + 1;
              --
              Ln_IdServicioHistorial:=DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
              INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
              (ID_SERVICIO_HISTORIAL,
              SERVICIO_ID,
              USR_CREACION,
              FE_CREACION,
              IP_CREACION,
              ESTADO,
              MOTIVO_ID,
              ACCION,
              OBSERVACION)
              VALUES 
              (Ln_IdServicioHistorial,
              I_ConteoFrecuencia.ID_SERVICIO,
              NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion),
              SYSDATE,
              Lv_IpCreacion,
              I_ConteoFrecuencia.ESTADO,
              null,
              'conteoFrecuencia',
             'Se Actualiza los meses restantes: ' ||
            ' <br/><b>Meses_restantes anterior:</b> ' || I_ConteoFrecuencia.MESES_RESTANTES || 
            ' <br/><b>Meses_restantes nuevo:</b> 0 ' || 
            ' <br/><b>Fecha de Reinicio de Conteo:</b>  ' || Pv_FechaReinicioConteo ||
            ' <br/><b>Meses Transcurridos:</b>  ' || Ln_MesesTranscurridos  || '<br/>' 
            );
            --
            EXCEPTION
            WHEN OTHERS THEN
              --
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                    'COMEK_TRANSACTION.COMEP_CONTEO_FRECUENCIAS', 
                                                    'No se pudo actualizar los meses restantes del servicio a (' || Ln_MesesActualizados ||'). '
                                                    || 'ID_SERVICIO = ' || I_ConteoFrecuencia.ID_SERVICIO || ' - ' || SQLCODE || ' -ERROR- '
                                                    || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                    NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion), 
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
              --
            END;
            --
          END IF;--I_ConteoFrecuencia.FRECUENCIA_PRODUCTO IS NOT NULL AND I_ConteoFrecuencia.FRECUENCIA_PRODUCTO = 1
          --
        END IF;--Pv_FechaReinicioConteo IS NOT NULL
        --
      END IF;--TRIM(Pv_LlamadoProcedure) IS NOT NULL AND TRIM(Pv_LlamadoProcedure) = 'JOB'
      --
      --
      IF Ln_ContadorServicios > 4999 THEN
        --
        COMMIT;
        --
        Ln_ContadorServicios := 0;
        --
      END IF;
      --
    END LOOP;
    --
    --
    IF Ln_ContadorServicios > 0 AND Ln_ContadorServicios <= 4999 THEN
      --
      COMMIT;
      --
    END IF;
    --
    --
    IF C_ConteoFrecuencia%ISOPEN THEN
      CLOSE C_ConteoFrecuencia;
    END IF;
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'COMEK_TRANSACTION.COMEP_CONTEO_FRECUENCIAS', 
                                          'No se pudo realizar el conteo de frecuencia de los servicios de la empresa ' || Pv_PrefijoEmpresa || ' - '
                                          || SQLCODE || ' -ERROR- ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
    --
    Pv_MensajeError := 'No se pudo realizar el conteo de frecuencia de los servicios de la empresa ' || Pv_PrefijoEmpresa;
    --
  END COMEP_CONTEO_FRECUENCIAS;
  --
  --
  PROCEDURE P_REINICIO_MESES_RESTANTES(
      Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_EstadoServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pv_MensajeError OUT VARCHAR2)
  AS
    --
    CURSOR C_ServiciosFrecuenciaUno(Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                                    Cv_EstadoServicio DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    IS
      SELECT ISER.ID_SERVICIO,
        ISER.PUNTO_FACTURACION_ID,
        ISER.PUNTO_ID,
        ISER.PRODUCTO_ID,
        ISER.FRECUENCIA_PRODUCTO,
        ISER.MESES_RESTANTES,
        ISER.ESTADO,
        (SELECT LOGIN FROM DB_COMERCIAL.INFO_PUNTO WHERE ID_PUNTO = ISER.PUNTO_ID
        ) LOGIN
    FROM DB_COMERCIAL.INFO_SERVICIO ISER
    WHERE ISER.ESTADO                                                           = Cv_EstadoServicio
    AND ISER.MESES_RESTANTES                                                    = 1
    AND ISER.FRECUENCIA_PRODUCTO                                                = 1
    AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(ISER.PUNTO_ID, NULL) = Cv_PrefijoEmpresa
    ORDER BY ISER.ID_SERVICIO;
    --
    Lv_UsrCreacion           VARCHAR2(14) := 'telcos_conteo';
    Lv_IpCreacion            VARCHAR2(10) := '127.0.0.1';
    Ln_ContadorServicios     NUMBER       := 0;
    Lr_InfoDocumentoFinancieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    --
  BEGIN
    --
    IF C_ServiciosFrecuenciaUno%ISOPEN THEN
      CLOSE C_ServiciosFrecuenciaUno;
    END IF;
    --
    -- SE RECORRE EL LISTADO DE SERVICIOS ACTIVOS DE LA EMPRESA ENVIADA POR EL USUARIO Y QUE TENGAN FRECUENCIA Y MESES RESTANTES IGUAL A UNO
    FOR I_ConteoFrecuencia IN C_ServiciosFrecuenciaUno(Pv_PrefijoEmpresa, Pv_EstadoServicio)
    LOOP
      --
      -- SE BUSCA DOCUMENTO POR MES Y AÑO DE CONSUMO
      Lr_InfoDocumentoFinancieroCab := DB_FINANCIERO.FNCK_CONSULTS.F_GET_MAX_DOCUMENTO(I_ConteoFrecuencia.PUNTO_FACTURACION_ID,
                                                                                       I_ConteoFrecuencia.PUNTO_ID, 
                                                                                       I_ConteoFrecuencia.PRODUCTO_ID, 
                                                                                       'mesAnioConsumo');
      --
      -- SI NO ENCUENTRA DOCUMENTO BUSCO POR RANGO DE CONSUMO
      IF Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO IS NULL THEN
        --
        Lr_InfoDocumentoFinancieroCab := DB_FINANCIERO.FNCK_CONSULTS.F_GET_MAX_DOCUMENTO(I_ConteoFrecuencia.PUNTO_FACTURACION_ID,
                                                                                         I_ConteoFrecuencia.PUNTO_ID,
                                                                                         I_ConteoFrecuencia.PRODUCTO_ID,
                                                                                         'rangoConsumo');
        --
      END IF;
      --
      --
      -- SI NO ENCUENTRA DOCUMENTO SE ACTUALIZAN LOS MESES RESTANTES A CERO
      IF Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO IS NULL THEN
        --
        Ln_ContadorServicios := Ln_ContadorServicios + 1;
        --
        UPDATE DB_COMERCIAL.INFO_SERVICIO
        SET MESES_RESTANTES = 0
        WHERE ID_SERVICIO   = I_ConteoFrecuencia.ID_SERVICIO;
        --
      END IF;
      --
      --
      IF Ln_ContadorServicios > 4999 THEN
        --
        COMMIT;
        --
        Ln_ContadorServicios := 0;
        --
      END IF;
      --
    END LOOP;
    --
    --
    IF Ln_ContadorServicios <= 4999 THEN
      --
      COMMIT;
      --
    END IF;
    --
    --
    IF C_ServiciosFrecuenciaUno%ISOPEN THEN
      CLOSE C_ServiciosFrecuenciaUno;
    END IF;
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'COMEK_TRANSACTION.P_REINICIO_MESES_RESTANTES', 
                                          'No se pudo realizar el reinicio de meses restantes de los servicios de la empresa ' || Pv_PrefijoEmpresa
                                          || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion), 
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
    --
    Pv_MensajeError := 'No se pudo realizar el reinicio de meses restantes de los servicios de la empresa ' || Pv_PrefijoEmpresa;
    --
  END P_REINICIO_MESES_RESTANTES;
--
--
 /**
  * Documentacion para el procedimiento COMEP_INSERT_NUEVAS_METAS
  * Crea las nuevas metas del nuevo mes
  * @author Edson Franco <efranco@telconet.ec>
  
  * @version 1.0 17-09-2015
  */
  PROCEDURE COMEP_INSERT_NUEVAS_METAS(
      Pv_MetaActiva   IN  VARCHAR2,
      Pv_MetaBruta    IN  VARCHAR2,
      Pv_EstadoMetas  IN  VARCHAR2,
      Pv_MsnError     OUT VARCHAR2 )
AS
--
Lr_AdmiCaracMetaActiva ADMI_CARACTERISTICA%ROWTYPE := DB_COMERCIAL.COMEK_CONSULTAS.COMEF_GET_ADMI_CARACTERISTICA( Pv_MetaActiva );
Lr_AdmiCaracMetaBruta  ADMI_CARACTERISTICA%ROWTYPE := DB_COMERCIAL.COMEK_CONSULTAS.COMEF_GET_ADMI_CARACTERISTICA( Pv_MetaBruta );
Lr_userSystem          VARCHAR2(50)                := '';
    --
    CURSOR C_GetMetas(Cn_IdMeta ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE, Cv_EstadoMetas VARCHAR2 )
    IS
        SELECT * 
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC
        WHERE CARACTERISTICA_ID = Cn_IdMeta
          AND ESTADO = Cv_EstadoMetas;
    --
    CURSOR C_GetContextUser
    IS
        SELECT SYS_CONTEXT ('USERENV', 'SESSION_USER') 
        FROM DUAL;
    --
BEGIN
    --
    IF C_GetContextUser%ISOPEN THEN
        CLOSE C_GetContextUser;
    END IF;
    --
    OPEN C_GetContextUser();
    --
    FETCH C_GetContextUser INTO Lr_userSystem;
    --
    CLOSE C_GetContextUser;
    --
    IF C_GetMetas%ISOPEN THEN
        CLOSE C_GetMetas;
    END IF;
    --
    FOR Lc_MetasActivas IN C_GetMetas(Lr_AdmiCaracMetaActiva.ID_CARACTERISTICA, Pv_EstadoMetas)
    LOOP
        --Ingreso la nueva meta
        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC
        (
            ID_PERSONA_EMPRESA_ROL_CARACT,        
            PERSONA_EMPRESA_ROL_ID,        
            CARACTERISTICA_ID,   
            VALOR,                 
            FE_CREACION,          
            USR_CREACION,                   
            IP_CREACION,      
            ESTADO             
        )
        VALUES
        (
            SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL,
            Lc_MetasActivas.PERSONA_EMPRESA_ROL_ID,
            Lc_MetasActivas.CARACTERISTICA_ID,
            Lc_MetasActivas.VALOR,
            SYSDATE,
            Lr_userSystem,
            '127.0.0.1',
            'Activo'
        );
        
        
        --Actualizo el valor de la meta del Mes Pasado
        UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC
        SET ESTADO = 'Eliminado', USR_ULT_MOD = Lr_userSystem, FE_ULT_MOD = SYSDATE
        
        WHERE ID_PERSONA_EMPRESA_ROL_CARACT = Lc_MetasActivas.ID_PERSONA_EMPRESA_ROL_CARACT;
        
        COMMIT;
    END LOOP;
    --
    IF C_GetMetas%ISOPEN THEN
        CLOSE C_GetMetas;
    END IF;
    --
    FOR Lc_MetasBrutas IN C_GetMetas(Lr_AdmiCaracMetaBruta.ID_CARACTERISTICA, Pv_EstadoMetas)
    LOOP
        --Ingreso la nueva meta
        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC
        (
            ID_PERSONA_EMPRESA_ROL_CARACT,        
            PERSONA_EMPRESA_ROL_ID,        
            CARACTERISTICA_ID,   
            VALOR,                 
            FE_CREACION,          
            USR_CREACION,                   
            IP_CREACION,      
            ESTADO             
        )
        VALUES
        (
            SEQ_INFO_PERSONA_EMP_ROL_CARAC.NEXTVAL,
            Lc_MetasBrutas.PERSONA_EMPRESA_ROL_ID,
            Lc_MetasBrutas.CARACTERISTICA_ID,
            Lc_MetasBrutas.VALOR,
            SYSDATE,
            Lr_userSystem,
            '127.0.0.1',
            'Activo'
        );
        
        
        --Actualizo el valor de la meta del Mes Pasado
        UPDATE DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC
        SET ESTADO = 'Eliminado', USR_ULT_MOD = Lr_userSystem, FE_ULT_MOD = SYSDATE
        
        WHERE ID_PERSONA_EMPRESA_ROL_CARACT = Lc_MetasBrutas.ID_PERSONA_EMPRESA_ROL_CARACT;
        
        COMMIT;
    END LOOP;
    --
EXCEPTION
WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsnError := 'Error en COMEK_TRANSACTION.COMEP_INSERT_NUEVAS_METAS - ' || SQLERRM;
    --
END COMEP_INSERT_NUEVAS_METAS;
    --
    --
    PROCEDURE COMEP_INSERT_PUNTO_HISTORIAL
    (  
        Po_InfoPuntoHistorial IN  DB_COMERCIAL.INFO_PUNTO_HISTORIAL%ROWTYPE,
        Pv_MsnError           OUT VARCHAR2 
    )
    AS
    BEGIN
    --
        --
        INSERT INTO DB_COMERCIAL.INFO_PUNTO_HISTORIAL
        (
            ID_PUNTO_HISTORIAL,
            PUNTO_ID,
            VALOR,
            USR_CREACION,
            FE_CREACION
        )
        VALUES
        (
            Po_InfoPuntoHistorial.ID_PUNTO_HISTORIAL,
            Po_InfoPuntoHistorial.PUNTO_ID,
            Po_InfoPuntoHistorial.VALOR,
            Po_InfoPuntoHistorial.USR_CREACION,
            SYSDATE
        );
        --
        --
        --
        COMMIT;
        --
    --
    EXCEPTION
    WHEN OTHERS THEN
    --
        --
        ROLLBACK;
        Pv_MsnError := 'Error en COMEK_TRANSACTION.COMEP_INSERT_PUNTO_HISTORIAL - ' || SQLERRM;
        --
    --
    END COMEP_INSERT_PUNTO_HISTORIAL;
    --
    --
    --
    --
    PROCEDURE P_CREA_FACT_INS_PTO_ADICIONAL (Pn_PuntoId        IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                             Pn_IdServicio     IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                             Pv_PrefijoEmpresa IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                             Pv_EstadoContrato IN  DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE,
                                             Pv_Mensaje        OUT VARCHAR2)
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        Lv_AplicaProceso   VARCHAR2(1) := 'N';
        Lv_EmpresaCod      DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
        Le_NoAplicaProceso EXCEPTION;
        Lv_Mensaje         VARCHAR2(1000);
        Lv_Origen          DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE;
        Lv_EstadoActivo    VARCHAR2(15) := 'Activo';
        Lv_EstadoInactivo  VARCHAR2(15) := 'Inactivo';
        Lv_FormaPago       VARCHAR2(100);
        Lv_ParamContrato   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'SOLICITUDES_DE_CONTRATO';
        Lv_Observacion     VARCHAR2(100);

        --Costo: Query para obtener información del contrato: 11
        CURSOR C_GetInfoContrato (Cn_PuntoId         DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                  Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_EstadoPendiente DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                  Cv_EstadoInactivo  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                  Cv_EstadoActivo    DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                  Cv_EmpresaCod      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
        IS
            SELECT NVL(ICO.ORIGEN, 'WEB') AS ORIGEN,
                   NVL(atc.DESCRIPCION_CUENTA, afp.DESCRIPCION_FORMA_PAGO) AS FORMA_PAGO
              FROM DB_COMERCIAL.INFO_PUNTO IP
              JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                ON IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
              JOIN DB_COMERCIAL.INFO_CONTRATO ICO
                ON ICO.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
              JOIN DB_GENERAL.ADMI_FORMA_PAGO afp
                ON ICO.FORMA_PAGO_ID = afp.ID_FORMA_PAGO
         LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO icfp
                ON icfp.CONTRATO_ID = ICO.ID_CONTRATO
               AND ICFP.ESTADO = Cv_EstadoActivo
         LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA atc
                ON atc.ID_TIPO_CUENTA = icfp.TIPO_CUENTA_ID
             WHERE ICO.ESTADO IN (Cv_EstadoPendiente)
               AND IP.ID_PUNTO = Cn_PuntoId;

        --Costo: Query para obtener id persona empresa rol: 11
        CURSOR C_GetPersonaEmpresaRol (Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
        IS
            SELECT IP.PERSONA_EMPRESA_ROL_ID
              FROM DB_COMERCIAL.INFO_PUNTO IP
             WHERE IP.ID_PUNTO = Cn_PuntoId;

        --Costo:14
        CURSOR C_GetServicioHistorial (Cv_Observacion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE,
                                       Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.SERVICIO_ID%TYPE
                                      ) 
        IS
        SELECT ID_SERVICIO_HISTORIAL
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
        WHERE OBSERVACION LIKE Cv_Observacion
        AND SERVICIO_ID = Cn_IdServicio;
        
        --Costo:3
        CURSOR C_ObtieneEstadoServ(Cn_IdServicio   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
        IS  
          SELECT ESTADO
          FROM DB_COMERCIAL.INFO_SERVICIO
          WHERE ID_SERVICIO =  Cn_IdServicio;
   
        --Costo: 3      
         CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                             Cv_Descripcion     VARCHAR2,
                             Cv_EstadoActivo    VARCHAR2,
                             Cv_EmpresaCod      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
         IS      
         SELECT DET.VALOR1,
         DET.VALOR2
         FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
         DB_GENERAL.ADMI_PARAMETRO_DET DET
         WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
          AND CAB.ESTADO             = Cv_EstadoActivo
          AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
          AND DET.DESCRIPCION        = Cv_Descripcion
          AND DET.ESTADO             = Cv_EstadoActivo
          AND DET.EMPRESA_COD        = Cv_EmpresaCod;


        Ln_PersonaEmpRolId       DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE;
        Lo_ServicioHistorial     DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
        Lv_EstadoServicio        VARCHAR2(100);
        Lc_ObtieneEstadoServ     C_ObtieneEstadoServ%ROWTYPE;
        Lc_Parametros            C_Parametros%ROWTYPE;
        Lv_NombreParametroTentativa   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_TENTATIVA_MENSAJES';

    BEGIN
    
        --
        IF C_ObtieneEstadoServ%ISOPEN THEN
          CLOSE C_ObtieneEstadoServ;
        END IF;
        --
        OPEN C_ObtieneEstadoServ(Pn_IdServicio);
        --
        FETCH C_ObtieneEstadoServ INTO Lc_ObtieneEstadoServ;
        Lv_EstadoServicio:= Lc_ObtieneEstadoServ.ESTADO;
        --
        CLOSE C_ObtieneEstadoServ;
        -- 
        --Se obtiene la persona Empresa rol para verificar si es cliente canal
        OPEN  C_GetPersonaEmpresaRol(Cn_PuntoId => Pn_PuntoId);
        FETCH C_GetPersonaEmpresaRol INTO Ln_PersonaEmpRolId;
        CLOSE C_GetPersonaEmpresaRol;

        --Se verifica si la empresa aplica al proceso de facturación de instalación de puntos adicionales por estado factible.
        Lv_EmpresaCod    := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP(Pv_PrefijoEmpresa);
        Lv_AplicaProceso := DB_GENERAL.GNRLPCK_UTIL.F_EMPRESA_APLICA_PROCESO('FACTURACION_INSTALACION_PUNTOS_ADICIONALES', Lv_EmpresaCod);

        --Si no aplica el proceso, se finaliza inmediatamente
        IF Lv_AplicaProceso = 'N' THEN
            RAISE Le_NoAplicaProceso;
        END IF;

        Lc_Parametros := NULL;
        --Se verifica que el cliente no sea Canal
        IF DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DESCRIPCION_ROL(Pn_PersonaEmpRolId => Ln_PersonaEmpRolId) = 'Cliente Canal' THEN
            IF C_Parametros%ISOPEN THEN
                CLOSE C_Parametros;
            END IF;
            OPEN  C_Parametros(Lv_NombreParametroTentativa,'CLIENTE_CANAL',Lv_EstadoActivo,Lv_EmpresaCod);
            FETCH C_Parametros INTO Lc_Parametros;
            CLOSE C_Parametros;

            Lv_Observacion := NVL(Lc_Parametros.VALOR1,'Cliente Canal no genera facturas de instalación.');
            RAISE Le_NoAplicaProceso;
        END IF;

        --Se obtiene el tipo de origen del punto para saber si es mandatorio crear una factura de instalación.
        Lv_AplicaProceso := DB_COMERCIAL.COMEK_CONSULTAS.F_APLICA_FACT_INST_ORIGEN_PTO (Pv_EmpresaCod => Lv_EmpresaCod,
                                                                                        Pn_PuntoId    => Pn_PuntoId);

        --Si no aplica el proceso porque el tipo de origen no debe generar factura, se finaliza inmediatamente
        IF Lv_AplicaProceso = 'N' THEN
            IF C_Parametros%ISOPEN THEN
              CLOSE C_Parametros;
            END IF;
            --
            OPEN  C_Parametros(Lv_NombreParametroTentativa,'MIGRACION_TECNOLOGIA',Lv_EstadoActivo,Lv_EmpresaCod);
            FETCH C_Parametros INTO Lc_Parametros;
            CLOSE C_Parametros;

            Lv_Observacion := NVL(Lc_Parametros.VALOR1,'El tipo de origen del punto no genera facturas de instalación.');
            RAISE Le_NoAplicaProceso;
        END IF;

        --Se verifica si se debe generar factura de instalación a ese servicio en ese punto.
        Lv_AplicaProceso := DB_FINANCIERO.FNCK_CONSULTS.F_APLICA_CREAR_FACT_INST (Pn_PuntoId => Pn_PuntoId);


        --Si no aplica el proceso, se finaliza inmediatamente
        IF Lv_AplicaProceso = 'N' THEN
            IF C_Parametros%ISOPEN THEN
              CLOSE C_Parametros;
            END IF;
            --
            OPEN  C_Parametros(Lv_NombreParametroTentativa,'EXISTE_FACTURA',Lv_EstadoActivo,Lv_EmpresaCod);
            FETCH C_Parametros INTO Lc_Parametros;
            CLOSE C_Parametros;

            Lv_Observacion := NVL(Lc_Parametros.VALOR1,'El punto ya tiene generada una factura de instalación.'); 
            RAISE Le_NoAplicaProceso;
        END IF;

        --Se verifica si es de origen WEB para poder realizar la facturación por nuevos servicios factibles.
        --Si no es punto adicional, significa que es cliente. Por lo tanto sólo los contratos web generan facturas por servicios factibles.
        OPEN  C_GetInfoContrato (Cn_PuntoId         => Pn_PuntoId,
                                 Cv_NombreParametro => Lv_ParamContrato,
                                 Cv_EstadoPendiente => Pv_EstadoContrato,
                                 Cv_EstadoInactivo  => Lv_EstadoInactivo,
                                 Cv_EmpresaCod      => Lv_EmpresaCod,
                                 Cv_EstadoActivo    => Lv_EstadoActivo);
        FETCH C_GetInfoContrato INTO Lv_Origen, Lv_FormaPago;

        CLOSE C_GetInfoContrato;

        --Se crea la solicitud para realizar la facturación de instalación del punto.
        DB_COMERCIAL.COMEK_TRANSACTION.P_FACTURACION_PUNTO_ADICIONAL (Pn_IdServicio => Pn_IdServicio,
                                                                      Pn_PuntoId    => Pn_PuntoId,
                                                                      Pv_EmpresaCod => Lv_EmpresaCod,
                                                                      Pv_Origen     => Lv_Origen,
                                                                      Pv_FormaPago  => Lv_FormaPago,
                                                                      Pv_Mensaje    => Pv_Mensaje);

        IF Pv_Mensaje IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20003, Pv_Mensaje);
        END IF;

        COMMIT;
    EXCEPTION
        WHEN Le_NoAplicaProceso THEN
          Lo_ServicioHistorial                       := NULL;
          -- VERIFICO SI YA SE INGRESO EL HISTORIAL EN EL SERVICIO PARA NO VOLVERLO A INGRESAR
                OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_Observacion,
                                             Cn_IdServicio  => Pn_IdServicio);
                FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
                CLOSE C_GetServicioHistorial;


          -- INSERTO HISTORIAL DEL SERVICIO SI EXISTE LA OBSERVACION

          IF Lv_Observacion IS NOT NULL  AND  NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN
            Lo_ServicioHistorial                       := NULL;
            Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
            Lo_ServicioHistorial.OBSERVACION           := Lv_Observacion;
            Lo_ServicioHistorial.ESTADO                := Lv_EstadoServicio;
            Lo_ServicioHistorial.USR_CREACION          := 'telcos';
            Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
            Lo_ServicioHistorial.SERVICIO_ID           := Pn_IdServicio;
            DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Pv_Mensaje);
            COMMIT;
          END IF;
          Pv_Mensaje := NULL;
        WHEN OTHERS THEN
            ROLLBACK;
            Pv_Mensaje := 'No se pudo generar la factura de instalación para el servicio:' || Pn_IdServicio || '  punto:' || Pn_PuntoId || ' '
                          || 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                          || ' ' || Pv_Mensaje;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'COMEK_TRANSACTION.P_CREA_FACT_INS_PTO_ADICIONAL',
                                                 Pv_Mensaje ,
                                                 NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    END P_CREA_FACT_INS_PTO_ADICIONAL;


    PROCEDURE P_FACTURACION_PUNTO_ADICIONAL (Pn_IdServicio IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                             Pn_PuntoId    IN  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                             Pv_EmpresaCod IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                             Pv_Origen     IN  DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE,
                                             Pv_FormaPago  IN  VARCHAR2,
                                             Pv_Mensaje    OUT VARCHAR2)
    IS
        --Cursor que obtiene todos los servicios disponibles a ser facturados por instalación.
        CURSOR C_GetInfoServicio (Cn_IdServicio    DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                  Cv_EstadoServ    DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                  Cv_EsVenta       DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE,
                                  Cv_EstadoActivo  VARCHAR2,
                                  Cv_EmpresaCod    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Cv_FibraCod      DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
                                  Cv_CobreCod      DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
                                  Cv_NombreTecnico DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                  Cn_Frecuencia    DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
                                  Cv_TipoOrden     DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE DEFAULT 'N')
        IS
            SELECT ID_SERVICIO, ipc.NOMBRE_PLAN AS NOMBRE_PLAN
              FROM DB_COMERCIAL.INFO_SERVICIO iser
              JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
                ON iser.ID_SERVICIO = ist.SERVICIO_ID
              JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm
                ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
              JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc
                ON iser.PLAN_ID = ipc.ID_PLAN
              JOIN DB_COMERCIAL.INFO_PLAN_DET ipd
                ON ipc.ID_PLAN = ipd.PLAN_ID
              JOIN DB_COMERCIAL.ADMI_PRODUCTO ap
                ON ipd.PRODUCTO_ID = ap.ID_PRODUCTO
             WHERE iser.ID_SERVICIO = Cn_IdServicio
               AND iser.ESTADO = NVL(Cv_EstadoServ, iser.ESTADO)
               AND iser.ES_VENTA = Cv_EsVenta
               AND iser.TIPO_ORDEN = Cv_TipoOrden
               AND ap.ESTADO = Cv_EstadoActivo
               AND atm.CODIGO_TIPO_MEDIO IN (Cv_FibraCod, Cv_CobreCod)
               AND iser.FRECUENCIA_PRODUCTO = Cn_Frecuencia
               AND ap.EMPRESA_COD = Cv_EmpresaCod
               AND ap.NOMBRE_TECNICO = Cv_NombreTecnico
               AND EXISTS (SELECT ISC.ID_SERVICIO_CARACTERISTICA           
                           FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC,
                             DB_COMERCIAL.ADMI_CARACTERISTICA CARAC
                           WHERE ISC.SERVICIO_ID                = ISER.ID_SERVICIO
                           AND CARAC.ID_CARACTERISTICA          = ISC.CARACTERISTICA_ID
                           AND CARAC.DESCRIPCION_CARACTERISTICA = 'PROM_INSTALACION')
             UNION
            SELECT ID_SERVICIO, AP.DESCRIPCION_PRODUCTO AS NOMBRE_PLAN
              FROM DB_COMERCIAL.INFO_SERVICIO iser
              JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
                ON iser.ID_SERVICIO = ist.SERVICIO_ID
              JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm
                ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
              JOIN DB_COMERCIAL.ADMI_PRODUCTO ap
                ON iser.PRODUCTO_ID = ap.ID_PRODUCTO
             WHERE iser.ID_SERVICIO = Cn_IdServicio
               AND iser.ESTADO = NVL(Cv_EstadoServ, iser.ESTADO)
               AND iser.ES_VENTA = Cv_EsVenta
               AND iser.TIPO_ORDEN = Cv_TipoOrden
               AND ap.ESTADO = Cv_EstadoActivo
               AND atm.CODIGO_TIPO_MEDIO IN (Cv_FibraCod, Cv_CobreCod)
               AND iser.FRECUENCIA_PRODUCTO = Cn_Frecuencia
               AND ap.EMPRESA_COD = Cv_EmpresaCod
               AND ap.NOMBRE_TECNICO = Cv_NombreTecnico;
               
        --Costo:3
        CURSOR C_ObtieneEstadoServ(Cn_IdServicio   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
        IS  
          SELECT ESTADO
          FROM DB_COMERCIAL.INFO_SERVICIO
          WHERE ID_SERVICIO =  Cn_IdServicio;

        Ln_IdServicio            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE := 0;
        Lv_NombrePlan            DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE := '';
        Lr_SolicitudInstalacion  DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion := NULL;
        Ln_ContadorSolicitudes   NUMBER := 0;
        Ln_IdDetalleSolicitud    NUMBER := 0;
        Lb_PlanConRestriccion    BOOLEAN:=FALSE;
        Ln_PorcentajeDescuento   NUMBER:=0;
        Lv_UltimaMilla           DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE;
        Lo_ServicioHistorial     DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
        Lv_Observacion           VARCHAR2(1000);
        Lb_AplicaPromo           BOOLEAN:=FALSE;
        Lv_EstadoServicio        VARCHAR2(100);
        Lv_ObservacionPlan       VARCHAR2(32000);
        Lc_ObtieneEstadoServ     C_ObtieneEstadoServ%ROWTYPE;

        CURSOR C_GetParametro (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                               Cv_Origen          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                               Cv_EstadoActivo    VARCHAR2,
                               Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
        IS
            SELECT VALOR1, VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7
              FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                   DB_GENERAL.ADMI_PARAMETRO_DET DET
             WHERE CAB.ID_PARAMETRO = DET.PARAMETRO_ID
               AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
               AND CAB.ESTADO = Cv_EstadoActivo
               AND DET.ESTADO = Cv_EstadoActivo
               AND DET.VALOR1 = Cv_Origen
               AND DET.EMPRESA_COD = Cv_EmpresaCod;
         Lr_Parametro     C_GetParametro%ROWTYPE;
         Le_Exception     EXCEPTION;
         Lv_MensajeError  VARCHAR2(1000);

        --CURSOR QUE RETORNA EL ESTADO DE LA SOLICITUD DE INSTALACION CREADA
        --COSTO QUERY: 5
        CURSOR C_GetSolicitudInstalacion(Cn_IdServicio           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.SERVICIO_ID%TYPE,
                                         Cv_EmpresaCod           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Cv_EstadoPendiente      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                         Cv_EstadoFinalizada     DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                         Cv_EstadoEliminada      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                         Cv_EstadoActivo         DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ESTADO%TYPE,
                                         Cv_EstadoEliminado      DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE DEFAULT 'Eliminado',
                                         Cv_NombreParametro      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE DEFAULT 'SOLICITUDES_DE_CONTRATO')
        IS
          SELECT IDS.ID_DETALLE_SOLICITUD,
                 IDS.ESTADO
            FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
            JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
              ON IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
           WHERE IDS.SERVICIO_ID           = Cn_IdServicio
             AND IDS.ESTADO                IN (Cv_EstadoPendiente, Cv_EstadoFinalizada, Cv_EstadoEliminada)
             AND ATS.DESCRIPCION_SOLICITUD IN ((SELECT DISTINCT VALOR4
                                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                      DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                                                  AND CAB.ESTADO           = Cv_EstadoActivo
                                                  AND CAB.ID_PARAMETRO     = DET.PARAMETRO_ID
                                                  AND DET.ESTADO           <> Cv_EstadoEliminado
                                                  AND DET.EMPRESA_COD      = Cv_EmpresaCod)) 
             AND ATS.ESTADO                = Cv_EstadoActivo;
        Lr_GetSolicitudInstalacion C_GetSolicitudInstalacion%ROWTYPE;

        --Costo: 5
        CURSOR C_GetUltMillaServ (Cn_ServicioId DB_COMERCIAL.INFO_SERVICIO_TECNICO.SERVICIO_ID%TYPE) 
        IS        
          SELECT atm.CODIGO_TIPO_MEDIO
          FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
          JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm
          ON atm.ID_TIPO_MEDIO  = ist.ULTIMA_MILLA_ID
          WHERE ist.SERVICIO_ID = Cn_ServicioId;

        --Costo:14
        CURSOR C_GetServicioHistorial (Cv_Observacion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE,
                                       Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.SERVICIO_ID%TYPE
                                      ) 
        IS
        SELECT ID_SERVICIO_HISTORIAL
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
        WHERE OBSERVACION LIKE Cv_Observacion
        AND SERVICIO_ID = Cn_IdServicio;
        
    BEGIN

        OPEN  C_GetInfoServicio (Cn_IdServicio    => Pn_IdServicio,
                                 Cv_EstadoServ    => NULL, --Se fija en null porque al momento del trigger se encuentra en cualquier estado
                                 Cv_EsVenta       => 'S',
                                 Cv_EstadoActivo  => 'Activo',
                                 Cv_EmpresaCod    => Pv_EmpresaCod,
                                 Cv_FibraCod      => 'FO',
                                 Cv_CobreCod      => 'CO',
                                 Cv_NombreTecnico => 'INTERNET',
                                 Cn_Frecuencia    => 1,
                                 Cv_TipoOrden     => 'N');
        FETCH C_GetInfoServicio INTO Ln_IdServicio, Lv_NombrePlan;
        CLOSE C_GetInfoServicio;
        --
        OPEN  C_GetParametro (Cv_NombreParametro => 'SOLICITUDES_DE_INSTALACION_X_SERVICIO',
                              Cv_Origen          => Pv_Origen,
                              Cv_EstadoActivo    => 'Activo',
                              Cv_EmpresaCod      => Pv_EmpresaCod);
        FETCH C_GetParametro INTO Lr_Parametro;
        CLOSE C_GetParametro;                
        --
        --Verifico si existen Solicitudes de Instalación Pendientes o Finalizadas
        Lr_GetSolicitudInstalacion := NULL;
        IF C_GetSolicitudInstalacion%ISOPEN THEN
          CLOSE C_GetSolicitudInstalacion;
        END IF;

        OPEN  C_GetSolicitudInstalacion(Ln_IdServicio, Pv_EmpresaCod, 'Pendiente', 'Finalizada','Eliminada','Activo');
        FETCH C_GetSolicitudInstalacion INTO Lr_GetSolicitudInstalacion;
        CLOSE C_GetSolicitudInstalacion;        
        --
        --Si no existen solicitudes de Instalación verifico promociones y genero solicitudes de Facturación de Instalación.                       
        IF ( NVL(Ln_IdServicio, 0) > 0 AND NVL(Lr_GetSolicitudInstalacion.ID_DETALLE_SOLICITUD, 0) = 0 ) THEN                              
          Lv_MensajeError := '';
          --
          IF C_ObtieneEstadoServ%ISOPEN THEN
            CLOSE C_ObtieneEstadoServ;
          END IF;
          --
          OPEN C_ObtieneEstadoServ(Ln_IdServicio);
          --
          FETCH C_ObtieneEstadoServ INTO Lc_ObtieneEstadoServ;
          Lv_EstadoServicio:= Lc_ObtieneEstadoServ.ESTADO;
          --
          CLOSE C_ObtieneEstadoServ;          
          --             
          --Si posee plan con restricción debo generar la Solicitud de Facturación con el valor base por FO y con el Descuento obtenido
          --del parametro RESTRICCION_PLANES_X_INSTALACION
          DB_COMERCIAL.COMEK_TRANSACTION.P_GET_RESTRIC_PLAN_INST(Pv_NombrePlan           => Lv_NombrePlan,
                                                                 Pv_EmpresaCod           => Pv_EmpresaCod,
                                                                 Pb_PlanConRestriccion   => Lb_PlanConRestriccion,
                                                                 Pn_PorcentajeDescuento  => Ln_PorcentajeDescuento,
                                                                 Pv_Observacion          => Lv_ObservacionPlan);
          IF NOT Lb_PlanConRestriccion THEN
            OPEN  C_GetUltMillaServ (Cn_ServicioId => Ln_IdServicio);
            FETCH C_GetUltMillaServ INTO Lv_UltimaMilla;
            CLOSE C_GetUltMillaServ;
          ELSE
            --Si tiene plan con restricción se fija por defecto FO.
            Lv_UltimaMilla := 'FO'; 
            --            
            Lo_ServicioHistorial  := NULL;
                
            -- VERIFICO SI YA SE INGRESO EL HISTORIAL EN EL SERVICIO PARA NO VOLVERLO A INGRESAR
            OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_ObservacionPlan,
                                         Cn_IdServicio  => Ln_IdServicio);
            FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
            CLOSE C_GetServicioHistorial;

            IF Lv_ObservacionPlan IS NOT NULL AND NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN
               Lo_ServicioHistorial                       := NULL;
               Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
               Lo_ServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
               Lo_ServicioHistorial.ESTADO                := Lv_EstadoServicio;
               Lo_ServicioHistorial.OBSERVACION           := Lv_ObservacionPlan;
               Lo_ServicioHistorial.USR_CREACION          := Lr_Parametro.VALOR6;
               Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
               DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Lv_MensajeError);
            END IF; 
          END IF;
          --                           
          IF Lv_UltimaMilla IS NOT NULL THEN
            --
            Lr_SolicitudInstalacion:= DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_SOL_INSTALACION(Pv_EmpresaCod           => Pv_EmpresaCod,
                                                                                              Pv_DescripcionSolicitud => Lr_Parametro.VALOR4,
                                                                                              Pv_CaractContrato       => Lr_Parametro.VALOR2,
                                                                                              Pv_NombreMotivo         => Lr_Parametro.VALOR5,
                                                                                              Pv_UltimaMilla          => Lv_UltimaMilla);
            IF Lr_SolicitudInstalacion.ID_TIPO_SOLICITUD IS NULL THEN
              Lv_MensajeError := 'No fue encontrada la información requerida para crear las solicitudes de instalación.';
              RAISE Le_Exception;
            END IF;
            --
            Lr_SolicitudInstalacion.USR_CREACION:= Lr_Parametro.VALOR6;
            --
            --Si no posee plan con restricción debo ejecutar el mapeo promocional por instalación para verificar si aplica a alguna promoción
            --y poder generar la solicitud de Facturación con el descuento y diferido de ser el caso.
            IF NOT Lb_PlanConRestriccion THEN
              --Proceso que genera el mapeo promocional en el caso que el servicio cumpla alguna Promoción por Instalación.
              DB_COMERCIAL.CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio            =>Ln_IdServicio,
                                                                         Pv_CodigoGrupoPromocion  =>'PROM_INS',
                                                                         Pv_CodEmpresa            =>Pv_EmpresaCod,
                                                                         Pv_EsCodigo              => 'S',
                                                                         Pv_Mensaje               =>Lv_MensajeError);
                                                                         
              Lv_MensajeError := '';
              --                                                           
              DB_COMERCIAL.CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio            =>Ln_IdServicio,
                                                                         Pv_CodigoGrupoPromocion  =>'PROM_INS',
                                                                         Pv_CodEmpresa            =>Pv_EmpresaCod,
                                                                         Pv_EsCodigo              => 'N',
                                                                         Pv_Mensaje               =>Lv_MensajeError);
              --  
              Lv_MensajeError := '';
              --Proceso genera solicitud de Facturación de Instalación en base a la promoción aplicada.
              DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   =>Pv_EmpresaCod,  
                                                               Pv_TipoPromo    =>'PROM_INS',
                                                               Pn_IdServicio   =>Ln_IdServicio, 
                                                               Pv_MsjResultado =>Lv_MensajeError);                                             
              IF Lv_MensajeError = 'OK' THEN
                Lb_AplicaPromo:= TRUE;
              ELSE 
                Ln_PorcentajeDescuento:=0;
                Lo_ServicioHistorial  := NULL;
                Lv_Observacion        := 'No se Aplicó promoción de Instalación para el servicio, se generará Factura de Instalación por el '||
                                         'valor base de Instalación';
                -- VERIFICO SI YA SE INGRESO EL HISTORIAL EN EL SERVICIO PARA NO VOLVERLO A INGRESAR
                OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_Observacion,
                                             Cn_IdServicio  => Ln_IdServicio);
                FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
                CLOSE C_GetServicioHistorial;

                IF NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN
                  Lo_ServicioHistorial                       := NULL;
                  Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                  Lo_ServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
                  Lo_ServicioHistorial.ESTADO                := Lv_EstadoServicio;
                  Lo_ServicioHistorial.OBSERVACION           := Lv_Observacion;
                  Lo_ServicioHistorial.USR_CREACION          := Lr_Parametro.VALOR6;
                  Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
                  DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Lv_MensajeError);
                END IF;
                -- 
              END IF;
              -- FIN Lv_MensajeError = 'OK'                           
              --          
            END IF;
            --FIN NOT Lb_PlanConRestriccion 
            --
            --
            --Si posee plan con restricción debo generar la Solicitud de Facturación con el valor base por FO y con el Descuento obtenido
            --del parametro RESTRICCION_PLANES_X_INSTALACION
            --Si no Aplicó a ninguna Promoción por Instalación debo generar la Solicitud de Facturación por el valor base para FO, CO 
            --y sin descuento.
            IF Lb_PlanConRestriccion OR NOT Lb_AplicaPromo THEN                         
              --                
              Lr_SolicitudInstalacion.OBSERVACION_SOLICITUD := Lr_Parametro.VALOR3;          
              Lr_SolicitudInstalacion.NOMBRE_PLAN           := Lv_NombrePlan;
              Lr_SolicitudInstalacion.FORMA_PAGO            := Pv_FormaPago;
              Lr_SolicitudInstalacion.PUNTO_ID              := Pn_PuntoId;
              Lr_SolicitudInstalacion.ID_SERVICIO           := Ln_IdServicio;
              Lr_SolicitudInstalacion.PORCENTAJE            := Ln_PorcentajeDescuento;
              Lr_SolicitudInstalacion.PERIODOS              := NULL;
              Lr_SolicitudInstalacion.APLICA_PROMO          := NULL;
              Lv_MensajeError                               := NULL;
              DB_COMERCIAL.COMEK_TRANSACTION.P_CREA_SOL_FACT_INSTALACION(Pr_SolicitudInstalacion => Lr_SolicitudInstalacion,
                                                                         Pv_Mensaje              => Lv_MensajeError,
                                                                         Pn_ContadorSolicitudes  => Ln_ContadorSolicitudes,
                                                                         Pn_IdDetalleSolicitud   => Ln_IdDetalleSolicitud);
              IF Lv_MensajeError IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              --
            END IF;-- FIN Lb_PlanConRestriccion OR NOT Lb_AplicaPromo
            --
            --
            --Se llama a Proceso que genera las Facturas en base a las solicitudes de Fact. de Instalación.  
            Lv_MensajeError :=NULL;  
            DB_FINANCIERO.FNCK_TRANSACTION.P_GENERAR_FACTURAS_SOLICITUD(Pv_Estado               => 'Pendiente',
                                                                        Pv_DescripcionSolicitud => Lr_SolicitudInstalacion.DESCRIPCION_SOLICITUD,
                                                                        Pv_UsrCreacion          => Lr_SolicitudInstalacion.USR_CREACION,
                                                                        Pn_MotivoId             => Lr_SolicitudInstalacion.MOTIVO_ID,
                                                                        Pv_EmpresaCod           => Pv_EmpresaCod,
                                                                        Pv_EstadoServicio       => Lv_EstadoServicio,
                                                                        Pv_MsnError             => Lv_MensajeError);
            IF Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            -- 
            --
          ELSE
            --Insertó Historial del servicio si la Última milla no es FO,CO
            Lo_ServicioHistorial := NULL;
            Lv_Observacion       := 'No se genera solicitud de descuento ni factura de instalación puesto'||
                                    ' que el servicio no tiene asociado una última milla de Fibra o Cobre';

            -- VERIFICO SI YA SE INGRESO EL HISTORIAL EN EL SERVICIO PARA NO VOLVERLO A INGRESAR
            OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_Observacion,
                                         Cn_IdServicio  => Ln_IdServicio);
            FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
            CLOSE C_GetServicioHistorial;

            IF NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN
              Lo_ServicioHistorial                       := NULL;
              Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
              Lo_ServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
              Lo_ServicioHistorial.ESTADO                := Lv_EstadoServicio;
              Lo_ServicioHistorial.OBSERVACION           := Lv_Observacion;
              Lo_ServicioHistorial.USR_CREACION          := Lr_Parametro.VALOR6;
              Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
              DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Lv_MensajeError);
            END IF;
            --
          END IF;
          --FIN Lv_UltimaMilla IS NOT NULL 
          --              
          --        
        END IF;
        --
        --Fin ( NVL(Ln_IdServicio, 0) > 0 AND NVL(Lr_GetSolicitudInstalacion.ID_DETALLE_SOLICITUD, 0) = 0 )

      COMMIT;
    EXCEPTION
        WHEN Le_Exception THEN
            Pv_Mensaje := Lv_MensajeError;
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'COMEK_TRANSACTION.P_FACTURACION_PUNTO_ADICIONAL',
                                                 Lv_MensajeError,
                                                 NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                                 SYSDATE, 
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        WHEN OTHERS THEN
            ROLLBACK;
            Pv_Mensaje := DBMS_UTILITY.FORMAT_ERROR_STACK || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'COMEK_TRANSACTION.P_FACTURACION_PUNTO_ADICIONAL:',
                                                 Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                                 SYSDATE, 
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END P_FACTURACION_PUNTO_ADICIONAL;

    /**
     * Documentacion para el procedimiento COMEP_INSERT_PERSONA_ROL_HISTO
     * Guarda un historial de la INFO_PERSONA_EMPRESA_ROL
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.0 29-07-2016
     */
    PROCEDURE COMEP_INSERT_PERSONA_ROL_HISTO
    (  
        Po_InfoPersonaRolHistorial  IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE,
        Pv_MsnError                 OUT VARCHAR2 
    )
    AS
    BEGIN
    --
        --
        INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO
        (
            ID_PERSONA_EMPRESA_ROL_HISTO,
            USR_CREACION,
            FE_CREACION,
            IP_CREACION,
            ESTADO,
            PERSONA_EMPRESA_ROL_ID,
            OBSERVACION
        )
        VALUES
        (
            Po_InfoPersonaRolHistorial.ID_PERSONA_EMPRESA_ROL_HISTO,
            Po_InfoPersonaRolHistorial.USR_CREACION,
            SYSDATE,
            Po_InfoPersonaRolHistorial.IP_CREACION,
            Po_InfoPersonaRolHistorial.ESTADO,
            Po_InfoPersonaRolHistorial.PERSONA_EMPRESA_ROL_ID,
            Po_InfoPersonaRolHistorial.OBSERVACION
        );
        --
        --
        --
        COMMIT;
        --
    --
    EXCEPTION
    WHEN OTHERS THEN
    --
        --
        ROLLBACK;
        Pv_MsnError := 'Error en COMEK_TRANSACTION.COMEP_INSERT_PERSONA_ROL_HISTO - ' || SQLERRM;
        --
    --
    END COMEP_INSERT_PERSONA_ROL_HISTO;
    --
    --
    PROCEDURE COMEP_INSERT_DETALLE_SOLICITUD
    (  
        Po_InfoDetalleSolicitud  IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
        Pv_MsnError                 OUT VARCHAR2 
    )
    AS
    BEGIN
    --
        --
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD
        (
            ID_DETALLE_SOLICITUD,
            SERVICIO_ID,
            TIPO_SOLICITUD_ID,
            PRECIO_DESCUENTO,
            PORCENTAJE_DESCUENTO,
            USR_CREACION,
            FE_CREACION,
            OBSERVACION,
            ESTADO,
            MOTIVO_ID
        )
        VALUES
        (
            Po_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD,
            Po_InfoDetalleSolicitud.SERVICIO_ID,
            Po_InfoDetalleSolicitud.TIPO_SOLICITUD_ID,
            Po_InfoDetalleSolicitud.PRECIO_DESCUENTO,     
            Po_InfoDetalleSolicitud.PORCENTAJE_DESCUENTO,      
            Po_InfoDetalleSolicitud.USR_CREACION,
            SYSDATE,
            Po_InfoDetalleSolicitud.OBSERVACION,
            Po_InfoDetalleSolicitud.ESTADO,
            Po_InfoDetalleSolicitud.MOTIVO_ID
        );
        --
        --
        --
        COMMIT;
        --
    --
    EXCEPTION
    WHEN OTHERS THEN
    --
        --
        ROLLBACK;
        Pv_MsnError := 'Error en COMEK_TRANSACTION.COMEP_INSERT_DETALLE_SOLICITUD - ' || SQLERRM;
        --
    --
    END COMEP_INSERT_DETALLE_SOLICITUD;
    --

    PROCEDURE P_FACT_INSTALACION_X_PARAMETRO (Pv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE DEFAULT NULL)
    IS
        CURSOR C_ObtieneParametros (Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                    Cv_EstadoCab       DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                    Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE DEFAULT 'Activo',
                                    Cv_EstadoInactivo  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE DEFAULT 'Inactivo',
                                    Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE) IS
            SELECT DET.VALOR1, DET.VALOR2, DET.VALOR3, DET.VALOR4, DET.VALOR5, DET.VALOR6, DET.VALOR7, DET.EMPRESA_COD, DET.ESTADO, IEG.PREFIJO
              FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                   DB_GENERAL.ADMI_PARAMETRO_DET DET,
                   DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
             WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
               AND CAB.ESTADO = Cv_EstadoCab
               AND CAB.ID_PARAMETRO = DET.PARAMETRO_ID
               AND DET.ESTADO IN (Cv_EstadoActivo, Cv_EstadoInactivo)
               AND DET.EMPRESA_COD = NVL(Cv_EmpresaCod, EMPRESA_COD)
               AND DET.EMPRESA_COD = IEG.COD_EMPRESA
             ORDER BY EMPRESA_COD DESC;

        Lv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:= 'SOLICITUDES_DE_CONTRATO';
        Lv_NombreProcedimiento VARCHAR2(50) := 'COMEK_TRANSACTION.P_FACT_INSTALACION_X_PARAMETRO';
        Lv_ErrorInesperado     VARCHAR2(50) := 'ERROR INESPERADO:  - ';
        Lv_ErrorStack          VARCHAR2(25) := ' - ERROR_STACK: ';
        Lv_ErrorBackTrace      VARCHAR2(25) := ' - ERROR_BACKTRACE: ';
        Lv_Aplicacion          VARCHAR2(15) := 'Telcos';
        Lv_EstadoActivo        VARCHAR2(15) := 'Activo';
    BEGIN
        FOR Lr_Registros IN C_ObtieneParametros (Cv_NombreParametro => Lv_NombreParametro,
                                                 Cv_EstadoCab       => Lv_EstadoActivo,
                                                 Cv_EmpresaCod      => Pv_EmpresaCod)
        LOOP
          BEGIN
            DB_COMERCIAL.COMEK_TRANSACTION.COMEP_CREAR_FACT_INSTALACION(Pv_OrigenContrato       => Lr_Registros.VALOR1,
                                                                        Pv_CaractContrato       => Lr_Registros.VALOR2,
                                                                        Pv_ObservacionSolicitud => Lr_Registros.VALOR3,
                                                                        Pv_DescripcionSolicitud => Lr_Registros.VALOR4,
                                                                        Pv_NombreMotivo         => Lr_Registros.VALOR5,
                                                                        Pv_UsrCreacion          => Lr_Registros.VALOR6,
                                                                        Pv_EstadoContrato       => 'Pendiente',
                                                                        Pv_EmpresaCod           => Lr_Registros.EMPRESA_COD,
                                                                        Pn_DiasPermitidos       => Lr_Registros.VALOR7,
                                                                        Pv_TipoProceso          => 'ProcesaPendientes');

            DB_COMERCIAL.COMEK_TRANSACTION.COMEP_CREAR_FACT_INSTALACION(Pv_OrigenContrato       => Lr_Registros.VALOR1,
                                                                        Pv_CaractContrato       => Lr_Registros.VALOR2,
                                                                        Pv_ObservacionSolicitud => Lr_Registros.VALOR3,
                                                                        Pv_DescripcionSolicitud => Lr_Registros.VALOR4,
                                                                        Pv_NombreMotivo         => Lr_Registros.VALOR5,
                                                                        Pv_UsrCreacion          => Lr_Registros.VALOR6,
                                                                        Pv_EstadoContrato       => 'Activo',
                                                                        Pv_EmpresaCod           => Lr_Registros.EMPRESA_COD,
                                                                        Pn_DiasPermitidos       => Lr_Registros.VALOR7,
                                                                        Pv_TipoProceso          => 'ProcesaActivos');

            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK;
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_Aplicacion,
                                                         Lv_NombreProcedimiento,
                                                         Lv_ErrorInesperado || SQLCODE || Lv_ErrorStack || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                         Lv_ErrorBackTrace || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                                         SYSDATE, 
                                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
            END;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(Lv_Aplicacion, 
                                                 Lv_NombreProcedimiento,
                                                 Lv_ErrorInesperado || SQLCODE || Lv_ErrorStack || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                 Lv_ErrorBackTrace || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                 NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                                 SYSDATE, 
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    END P_FACT_INSTALACION_X_PARAMETRO;
    --   
  --
    PROCEDURE COMEP_CREAR_FACT_INSTALACION
    (
        Pv_OrigenContrato       IN  DB_COMERCIAL.INFO_CONTRATO.ORIGEN%TYPE,
        Pv_CaractContrato       IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
        Pv_ObservacionSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
        Pv_DescripcionSolicitud IN  DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
        Pv_NombreMotivo         IN  DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
        Pv_UsrCreacion          IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE,
        Pv_EstadoContrato       IN  DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE,
        Pv_EmpresaCod           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        Pn_DiasPermitidos       IN  NUMBER,
        Pv_TipoProceso          IN  VARCHAR2
    )
    AS
    --
        --Costo:14
        CURSOR C_GetServicioHistorial (Cv_Observacion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE,
                                       Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.SERVICIO_ID%TYPE
                                      ) 
        IS
        SELECT ID_SERVICIO_HISTORIAL
        FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
        WHERE OBSERVACION LIKE Cv_Observacion
        AND SERVICIO_ID = Cn_IdServicio;

        --Cursor que obtiene un servicio disponible a ser facturado por instalación.
        CURSOR C_GetInfoServicio (Cn_PuntoId       DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                  Cv_EstadoServ    DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                  Cv_EsVenta       DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE,
                                  Cv_EstadoActivo  VARCHAR2,
                                  Cv_EmpresaCod    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Cv_FibraCod      DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
                                  Cv_CobreCod      DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
                                  Cv_NombreTecnico DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                  Cn_Frecuencia    DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
                                  Cv_TipoOrden     DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE DEFAULT 'N',
                                  Cn_NumeroDias    NUMBER,
                                  Cv_NombreParametro VARCHAR2,
                                  Cv_TipoPromo     VARCHAR2,
                                  Cv_EstadoPendiente   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                  Cv_EstadoFinalizada  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                  Cv_EstadoEliminada   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                  Cv_IdSolWeb          DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE,
                                  Cv_IdSolMovil        DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE)
        IS
            SELECT ID_SERVICIO, ipc.NOMBRE_PLAN AS NOMBRE_PLAN,atm.CODIGO_TIPO_MEDIO
              FROM DB_COMERCIAL.INFO_SERVICIO iser
              JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
                ON iser.ID_SERVICIO = ist.SERVICIO_ID
              JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm
                ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
              JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc
                ON iser.PLAN_ID = ipc.ID_PLAN
              JOIN DB_COMERCIAL.INFO_PLAN_DET ipd
                ON ipc.ID_PLAN = ipd.PLAN_ID
              JOIN DB_COMERCIAL.ADMI_PRODUCTO ap
                ON ipd.PRODUCTO_ID = ap.ID_PRODUCTO
              JOIN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
                ON ISERH.SERVICIO_ID=iser.ID_SERVICIO
             WHERE iser.PUNTO_ID = Cn_PuntoId
               AND iserh.ESTADO = Cv_EstadoServ
               AND iser.ES_VENTA = Cv_EsVenta
               AND iser.TIPO_ORDEN = Cv_TipoOrden
               AND ap.ESTADO = Cv_EstadoActivo
               AND atm.CODIGO_TIPO_MEDIO IN (Cv_FibraCod, Cv_CobreCod)
               AND iser.FRECUENCIA_PRODUCTO = Cn_Frecuencia
               AND ap.EMPRESA_COD = Cv_EmpresaCod
               AND ap.NOMBRE_TECNICO = Cv_NombreTecnico
               AND  iser.ESTADO  in (
                     SELECT APD.VALOR2 AS VALOR2
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                          DB_GENERAL.ADMI_PARAMETRO_DET APD
                        WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                        AND APD.ESTADO           = Cv_EstadoActivo
                        AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                        AND APC.ESTADO           = Cv_EstadoActivo
                        AND APD.VALOR1           = Cv_TipoPromo
                       AND APD.EMPRESA_COD       = Cv_EmpresaCod
                    )
               AND  iserh.FE_CREACION >= to_date(SYSDATE - Cn_NumeroDias, 'DD/MM/RRRR') 
               AND iser.ID_SERVICIO not in (select DISTINCT SERVICIO_ID from DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
                                    WHERE TIPO_SOLICITUD_ID  in (Cv_IdSolWeb,Cv_IdSolMovil)
                                    and IDS.SERVICIO_ID           = iser.ID_SERVICIO
                                    AND IDS.ESTADO                IN (Cv_EstadoPendiente, Cv_EstadoFinalizada, Cv_EstadoEliminada)
                                    AND  ids.FE_CREACION >= to_date(SYSDATE - Cn_NumeroDias, 'DD/MM/RRRR')
                                 )
               AND NOT EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                               FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                                 DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                               WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'ID_SERVICIO_REINGRESO'
                               AND DBISC.SERVICIO_ID                 = ISER.ID_SERVICIO
                               AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA)
            AND ROWNUM = 1
             UNION
            SELECT ID_SERVICIO, AP.DESCRIPCION_PRODUCTO AS NOMBRE_PLAN,atm.CODIGO_TIPO_MEDIO
              FROM DB_COMERCIAL.INFO_SERVICIO iser
              JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
                ON iser.ID_SERVICIO = ist.SERVICIO_ID
              JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO atm
                ON atm.ID_TIPO_MEDIO = ist.ULTIMA_MILLA_ID
              JOIN DB_COMERCIAL.ADMI_PRODUCTO ap
                ON iser.PRODUCTO_ID = ap.ID_PRODUCTO
              JOIN  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISERH
                ON ISERH.SERVICIO_ID=iser.ID_SERVICIO
             WHERE iser.PUNTO_ID = Cn_PuntoId
               AND iserh.ESTADO = Cv_EstadoServ
               AND iser.ES_VENTA = Cv_EsVenta
               AND iser.TIPO_ORDEN = Cv_TipoOrden
               AND ap.ESTADO = Cv_EstadoActivo
               AND atm.CODIGO_TIPO_MEDIO IN (Cv_FibraCod, Cv_CobreCod)
               AND iser.FRECUENCIA_PRODUCTO = Cn_Frecuencia
               AND ap.EMPRESA_COD = Cv_EmpresaCod
               AND ap.NOMBRE_TECNICO = Cv_NombreTecnico
               AND  iser.ESTADO  in (
                     SELECT APD.VALOR2 AS VALOR2
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                          DB_GENERAL.ADMI_PARAMETRO_DET APD
                        WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                        AND APD.ESTADO           = Cv_EstadoActivo
                        AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                        AND APC.ESTADO           = Cv_EstadoActivo
                        AND APD.VALOR1           = Cv_TipoPromo
                       AND APD.EMPRESA_COD       = Cv_EmpresaCod
                )
               AND  iserh.FE_CREACION >= to_date(SYSDATE - Cn_NumeroDias, 'DD/MM/RRRR')
               AND iser.ID_SERVICIO not in (select DISTINCT SERVICIO_ID from DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
                                    WHERE TIPO_SOLICITUD_ID  in (Cv_IdSolWeb,Cv_IdSolMovil)
                                    and IDS.SERVICIO_ID           = iser.ID_SERVICIO
                                    AND IDS.ESTADO                IN (Cv_EstadoPendiente, Cv_EstadoFinalizada, Cv_EstadoEliminada)
                                    AND  ids.FE_CREACION >= to_date(SYSDATE - Cn_NumeroDias, 'DD/MM/RRRR')
                                 )
               AND NOT EXISTS (SELECT  DBISC.CARACTERISTICA_ID 
                               FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                                 DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA DBISC
                               WHERE DBAC.DESCRIPCION_CARACTERISTICA = 'ID_SERVICIO_REINGRESO'
                               AND DBISC.SERVICIO_ID                 = ISER.ID_SERVICIO
                               AND DBISC.CARACTERISTICA_ID           = DBAC.ID_CARACTERISTICA)
               AND ROWNUM = 1;
        

        --Costo: 5
        CURSOR C_GetSolicitudInstalacion(Cn_IdServicio           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.SERVICIO_ID%TYPE,
                                         Cv_EmpresaCod           DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Cv_EstadoPendiente      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                         Cv_EstadoFinalizada     DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                         Cv_EstadoEliminada      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                         Cv_EstadoActivo         DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ESTADO%TYPE,
                                         Cv_EstadoEliminado      DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE DEFAULT 'Eliminado',
                                         Cv_NombreParametro      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE DEFAULT 'SOLICITUDES_DE_CONTRATO')
        IS
          SELECT IDS.ID_DETALLE_SOLICITUD,
                 IDS.ESTADO
            FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
            JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
              ON IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
           WHERE IDS.SERVICIO_ID           = Cn_IdServicio
             AND IDS.ESTADO                IN (Cv_EstadoPendiente, Cv_EstadoFinalizada,Cv_EstadoEliminada)
             AND ATS.DESCRIPCION_SOLICITUD IN ((SELECT DISTINCT VALOR4
                                                 FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                      DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                                                  AND CAB.ESTADO           = Cv_EstadoActivo
                                                  AND CAB.ID_PARAMETRO     = DET.PARAMETRO_ID
                                                  AND DET.ESTADO           <> Cv_EstadoEliminado
                                                  AND DET.EMPRESA_COD      = Cv_EmpresaCod)) 
             AND ATS.ESTADO                = Cv_EstadoActivo;
        --
        CURSOR C_GetParamNumDiasFecAlcance (Cv_NombreParam    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                            Cv_DescParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.DESCRIPCION%TYPE,    
                                            Cv_Estado         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                            Cv_EmpresaCod     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
        IS
        SELECT  COALESCE(TO_NUMBER(REGEXP_SUBSTR( APD.VALOR1 ,'^\d+')),0) AS NUMERO_DIAS
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
        AND APD.ESTADO             = Cv_Estado
        AND APC.NOMBRE_PARAMETRO   = Cv_NombreParam
        AND APD.DESCRIPCION        = Cv_DescParametro
        AND APC.ESTADO             = Cv_Estado
        AND APD.EMPRESA_COD        = Cv_EmpresaCod;
            
        --
        --
       CURSOR C_GetParamTipoSol (Cv_NombreParam      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,    
                                 Cv_EstadoEliminado  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                 Cv_Origen           DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                 Cv_EmpresaCod       DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
        IS
        SELECT ATS.ID_TIPO_SOLICITUD
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
              DB_GENERAL.ADMI_PARAMETRO_DET DET,
              DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
        WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParam
          AND CAB.ESTADO       = Cv_EstadoActivo
          AND CAB.ID_PARAMETRO = DET.PARAMETRO_ID
          AND DET.VALOR4       = ATS.descripcion_solicitud
          AND DET.ESTADO       <> Cv_EstadoEliminado
          AND DET.VALOR1       = Cv_Origen
          AND DET.EMPRESA_COD  = Cv_EmpresaCod;
      
       --Costo:3
       CURSOR C_ObtieneEstadoServ(Cn_IdServicio   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
       IS  
         SELECT ESTADO
         FROM DB_COMERCIAL.INFO_SERVICIO
         WHERE ID_SERVICIO =  Cn_IdServicio;

       --Costo: 3      
       CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                           Cv_Descripcion     VARCHAR2,
                           Cv_EstadoActivo    VARCHAR2,
                           Cv_EmpresaCod      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
       IS      
         SELECT DET.VALOR1,
         DET.VALOR2
         FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
         DB_GENERAL.ADMI_PARAMETRO_DET DET
         WHERE CAB.NOMBRE_PARAMETRO  = Cv_NombreParametro
          AND CAB.ESTADO             = Cv_EstadoActivo
          AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
          AND DET.DESCRIPCION        = Cv_Descripcion
          AND DET.ESTADO             = Cv_EstadoActivo
          AND DET.EMPRESA_COD        = Cv_EmpresaCod;
        --
        Lr_GetSolicitudInstalacion C_GetSolicitudInstalacion%ROWTYPE;
          
        Ln_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;
        Lo_PersonaEmpresaRol    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL%ROWTYPE;
        Ln_ContadorPuntos       NUMBER := 0;
        Ln_ContadorSolicitudes  NUMBER := 0;
        Lv_MensajeError         VARCHAR(3000) := '';
        Lv_Observacion          VARCHAR2(1000);
        Lo_PersonaRolHistorial  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE;
        Lv_EstadoActivo         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Activo';
        Le_Exception            EXCEPTION;
        Lr_SolicitudInstalacion DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion := NULL;
        Lv_NombrePlan           DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE := '';
        Lv_UltimaMilla          DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE;
        Ln_IdDetalleSolicitud   NUMBER := 0;
        Lb_PlanConRestriccion   BOOLEAN:=FALSE;
        Ln_PorcentajeDescuento  NUMBER:=0;    
        Lo_ServicioHistorial    DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;    
        Lb_AplicaPromo          BOOLEAN:=FALSE;
        Lv_AplicaProceso        VARCHAR2(1) := 'N';
        Lv_AplicaProceso2       VARCHAR2(1) := 'N';
        --
        Ln_NumeroDias           NUMBER := 0;
        Lv_NombreParametroDias  VARCHAR2(2000):='PROMOCIONES_PARAMETROS_EJECUCION_DE_ALCANCE';
        Lv_DescParametroDias    VARCHAR2(2000):='NUMERO_DIAS_PROM_INS';
        Lv_NombreParametro       VARCHAR2(2000):='PROM_ESTADO_SERVICIO';
        Lv_TipoPromo             VARCHAR2(2000):='PROM_INS_SOL_FACT';
        Lv_IdSolWeb              VARCHAR2(20);
        LvIdSolMovil             VARCHAR2(20);
        Lv_EstadoServicio        VARCHAR2(100);
        Lv_ObservacionPlan       VARCHAR2(32000);
        Lc_ObtieneEstadoServ     C_ObtieneEstadoServ%ROWTYPE;
        --
        Lv_Consulta             VARCHAR2(4000);
        Lrf_ContratosProcesar   SYS_REFCURSOR;
        La_ContratosProcesar    T_ContratosProcesar;
        Lr_Contrato             Lr_ContratosProcesar;
        Ln_Indx                 NUMBER;
        Lc_Parametros            C_Parametros%ROWTYPE;
        Lv_NombreParametroTentativa   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_TENTATIVA_MENSAJES';
    --
    BEGIN    
        --
        IF C_GetParamNumDiasFecAlcance%ISOPEN THEN
          CLOSE C_GetParamNumDiasFecAlcance;
        END IF;
        --
     
        OPEN  C_GetParamNumDiasFecAlcance(Cv_NombreParam    => Lv_NombreParametroDias,
                                          Cv_DescParametro   => Lv_DescParametroDias,
                                          Cv_Estado          => Lv_EstadoActivo,
                                          Cv_EmpresaCod      => Pv_EmpresaCod);
        FETCH C_GetParamNumDiasFecAlcance INTO Ln_NumeroDias;
        CLOSE C_GetParamNumDiasFecAlcance;
        
        --
        IF C_GetParamTipoSol%ISOPEN THEN
          CLOSE C_GetParamTipoSol;
        END IF;
        --
        OPEN C_GetParamTipoSol(Cv_NombreParam     => 'SOLICITUDES_DE_CONTRATO',
                               Cv_EstadoActivo    => 'Activo',
                               Cv_EstadoEliminado => 'Eliminado', 
                               Cv_Origen          => 'WEB',
                               Cv_EmpresaCod      => Pv_EmpresaCod);
        FETCH C_GetParamTipoSol INTO Lv_IdSolWeb;
        CLOSE C_GetParamTipoSol;
        --
        --
        IF C_GetParamTipoSol%ISOPEN THEN
          CLOSE C_GetParamTipoSol;
        END IF;
        --
        OPEN C_GetParamTipoSol(Cv_NombreParam     => 'SOLICITUDES_DE_CONTRATO',
                               Cv_EstadoActivo    => 'Activo',
                               Cv_EstadoEliminado => 'Eliminado', 
                               Cv_Origen          => 'MOVIL',
                               Cv_EmpresaCod      => Pv_EmpresaCod);
        FETCH C_GetParamTipoSol INTO LvIdSolMovil;
        CLOSE C_GetParamTipoSol;
        --
        --
        IF Lrf_ContratosProcesar%ISOPEN THEN
          CLOSE Lrf_ContratosProcesar;
        END IF;

        Lv_Consulta := 'SELECT  
                          ic.ID_CONTRATO,      
                          ic.PERSONA_EMPRESA_ROL_ID, 
                          NVL((SELECT atc.DESCRIPCION_CUENTA
                                 FROM DB_GENERAL.ADMI_TIPO_CUENTA atc,
                                      DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO icfp
                                 WHERE icfp.TIPO_CUENTA_ID = atc.ID_TIPO_CUENTA
                                   and icfp.CONTRATO_ID    = ic.ID_CONTRATO), afp.DESCRIPCION_FORMA_PAGO) as FORMA_PAGO,
                          ic.FE_CREACION
                          FROM DB_COMERCIAL.INFO_CONTRATO ic
                          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                            ON iper.ID_PERSONA_ROL = ic.PERSONA_EMPRESA_ROL_ID
                          JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                            ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID AND ier.EMPRESA_COD = '''||Pv_EmpresaCod||'''
                          JOIN DB_GENERAL.ADMI_FORMA_PAGO afp
                            ON ic.FORMA_PAGO_ID = afp.ID_FORMA_PAGO
                          WHERE ic.ESTADO = '''||Pv_EstadoContrato||'''
                            AND ic.ORIGEN = '''||Pv_OrigenContrato||''' ';
                            
        IF Pv_TipoProceso = 'ProcesaActivos' THEN
         Lv_Consulta := Lv_Consulta || ' AND (ic.FE_APROBACION >= trunc(SYSDATE) AND ic.FE_APROBACION <= (SYSDATE) 
                                              OR ic.FE_CREACION >= trunc(SYSDATE) AND ic.FE_CREACION <= (SYSDATE) )';
        ELSE
          Lv_Consulta := Lv_Consulta || ' AND iC.FE_CREACION >= ADD_MONTHS(TRUNC(SYSDATE), -2) ';
        END IF;
        --
        --
        La_ContratosProcesar.DELETE();
    
        OPEN Lrf_ContratosProcesar FOR Lv_Consulta;
        LOOP
          --
            FETCH Lrf_ContratosProcesar BULK COLLECT INTO La_ContratosProcesar LIMIT 5000;
      
            Ln_Indx:=La_ContratosProcesar.FIRST;

            WHILE (Ln_Indx IS NOT NULL)       
            LOOP    
            --
              Lr_Contrato := La_ContratosProcesar(Ln_Indx);
              Ln_Indx     := La_ContratosProcesar.NEXT(Ln_Indx);  

              --Si es Cliente Canal, no se debe crear facturas de instalación.
              IF DB_COMERCIAL.COMEK_CONSULTAS.F_GET_DESCRIPCION_ROL(Lr_Contrato.PERSONA_EMPRESA_ROL_ID) = 'Cliente Canal' THEN
                  CONTINUE;
              END IF;

              Ln_ContadorPuntos := 0;
              Lv_AplicaProceso  :='N';
              Lv_AplicaProceso2 :='N';
              --
              FOR Lc_Puntos IN (  SELECT ip.ID_PUNTO, ip.PERSONA_EMPRESA_ROL_ID
                                  FROM DB_COMERCIAL.INFO_PUNTO ip
                                  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                  ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                                  WHERE iper.ID_PERSONA_ROL = Lr_Contrato.PERSONA_EMPRESA_ROL_ID
                                    AND ip.ESTADO = 'Activo' )
              LOOP
              
                Ln_ContadorPuntos      := Ln_ContadorPuntos + 1;
                Ln_IdServicio          := NULL;
                Lv_NombrePlan          := NULL;
                Lv_UltimaMilla         := NULL;
                Lb_AplicaPromo         := FALSE;
                Lb_PlanConRestriccion  := FALSE;
                Ln_PorcentajeDescuento := 0;
               
                OPEN  C_GetInfoServicio(Cn_PuntoId       => Lc_Puntos.ID_PUNTO,
                                        Cv_EstadoServ    => 'Factible',
                                        Cv_EsVenta       => 'S',
                                        Cv_EstadoActivo  => 'Activo',
                                        Cv_EmpresaCod    => Pv_EmpresaCod,
                                        Cv_FibraCod      => 'FO',
                                        Cv_CobreCod      => 'CO',
                                        Cv_NombreTecnico => 'INTERNET',
                                        Cn_Frecuencia    => 1,
                                        Cv_TipoOrden     => 'N',
                                        Cn_NumeroDias    => Ln_NumeroDias,
                                        Cv_NombreParametro => Lv_NombreParametro,
                                        Cv_TipoPromo       => Lv_TipoPromo,
                                        Cv_EstadoPendiente =>    'Pendiente',
                                        Cv_EstadoFinalizada =>  'Finalizada',
                                        Cv_EstadoEliminada  =>  'Eliminada',
                                        Cv_IdSolWeb         =>  Lv_IdSolWeb,
                                        Cv_IdSolMovil       =>  LvIdSolMovil);
              FETCH C_GetInfoServicio INTO Ln_IdServicio, Lv_NombrePlan, Lv_UltimaMilla;
              CLOSE C_GetInfoServicio;
                
              IF NVL(Ln_IdServicio, 0) > 0 THEN               
                --
                IF C_ObtieneEstadoServ%ISOPEN THEN
                  CLOSE C_ObtieneEstadoServ;
                END IF;
                --
                OPEN C_ObtieneEstadoServ(Ln_IdServicio);
                --
                FETCH C_ObtieneEstadoServ INTO Lc_ObtieneEstadoServ;
                Lv_EstadoServicio:= Lc_ObtieneEstadoServ.ESTADO;
                --
                CLOSE C_ObtieneEstadoServ;
                --
                Lc_Parametros := NULL;    
                --                 
                --Verifica Origen del Punto, si es migración de Tecnología no aplica al proceso de generar Fact de Instalación
                Lv_AplicaProceso := DB_COMERCIAL.COMEK_CONSULTAS.F_APLICA_FACT_INST_ORIGEN_PTO (Pv_EmpresaCod => Pv_EmpresaCod,
                                                                                                Pn_PuntoId    => Lc_Puntos.ID_PUNTO);
                IF Lv_AplicaProceso = 'N' THEN
                  IF C_Parametros%ISOPEN THEN
                     CLOSE C_Parametros;
                  END IF;
                  --
                  OPEN  C_Parametros(Lv_NombreParametroTentativa,'MIGRACION_TECNOLOGIA',Lv_EstadoActivo,Pv_EmpresaCod);
                  FETCH C_Parametros INTO Lc_Parametros;
                  CLOSE C_Parametros;

                  Lv_Observacion := NVL(Lc_Parametros.VALOR1,'El tipo de origen del punto no genera facturas de instalación.');                 
                END IF;

                Lc_Parametros := NULL; 
                --Verifica Si existe Factura de Instalación POR_CONTRATO_DIGITAL o POR_CONTRATO_FISICO, en estado Pendiente, Activo
                --o Cerrado y que no haya sido aplicada una NC por el valor total de la Factura.
                Lv_AplicaProceso2 := DB_FINANCIERO.FNCK_CONSULTS.F_APLICA_CREAR_FACT_INST (Pn_PuntoId => Lc_Puntos.ID_PUNTO);

                IF Lv_AplicaProceso2 = 'N' THEN
                  IF C_Parametros%ISOPEN THEN
                    CLOSE C_Parametros;
                  END IF;
                  --
                  OPEN  C_Parametros(Lv_NombreParametroTentativa,'EXISTE_FACTURA',Lv_EstadoActivo,Pv_EmpresaCod);
                  FETCH C_Parametros INTO Lc_Parametros;
                  CLOSE C_Parametros;

                  Lv_Observacion := NVL(Lc_Parametros.VALOR1,'El punto ya tiene generada una factura de instalación.');                 
                END IF;

                --Inserto Historial en el servicio si el Punto no aplica para generar el proceso.
                IF Lv_AplicaProceso='N' or Lv_AplicaProceso2='N' THEN
                  --
                  Lo_ServicioHistorial  := NULL;
                  OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_Observacion,
                                               Cn_IdServicio  => Ln_IdServicio);
                  FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
                  CLOSE C_GetServicioHistorial;

                  IF Lv_Observacion IS NOT NULL AND NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN                      
                      --
                      Lo_ServicioHistorial                       := NULL;
                      Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                      Lo_ServicioHistorial.OBSERVACION           := Lv_Observacion;
                      Lo_ServicioHistorial.ESTADO                := Lv_EstadoServicio;
                      Lo_ServicioHistorial.USR_CREACION          := 'telcos';
                      Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
                      Lo_ServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
                      DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Lv_MensajeError);
                    END IF;  
                    CONTINUE;                    
                  END IF;              
              
                    Lr_GetSolicitudInstalacion := NULL;
                IF C_GetSolicitudInstalacion%ISOPEN THEN
                  CLOSE C_GetSolicitudInstalacion;
                END IF;

                OPEN  C_GetSolicitudInstalacion(Ln_IdServicio, Pv_EmpresaCod, 'Pendiente', 'Finalizada','Eliminada', 'Activo');
                FETCH C_GetSolicitudInstalacion INTO Lr_GetSolicitudInstalacion;
                CLOSE C_GetSolicitudInstalacion;
                --
                --Si no existen solicitudes de Instalación para el servicio en estado Pendiente o Finalizada verifico promociones, genero 
                --y proceso solicitud de Facturación de Instalación.
                --
                IF NVL(Lr_GetSolicitudInstalacion.ID_DETALLE_SOLICITUD, 0) = 0 THEN 
                --
                  Lv_MensajeError := '';
                  --Si posee plan con restricción debo generar la Solicitud de Facturación con el valor base por FO y con el Descuento obtenido
                  --del parametro RESTRICCION_PLANES_X_INSTALACION
                  DB_COMERCIAL.COMEK_TRANSACTION.P_GET_RESTRIC_PLAN_INST(Pv_NombrePlan           => Lv_NombrePlan,
                                                                         Pv_EmpresaCod           => Pv_EmpresaCod,
                                                                         Pb_PlanConRestriccion   => Lb_PlanConRestriccion,
                                                                         Pn_PorcentajeDescuento  => Ln_PorcentajeDescuento,
                                                                         Pv_Observacion          => Lv_ObservacionPlan);
                  IF Lb_PlanConRestriccion THEN
                    --Si tiene plan con restricción se fija por defecto FO.
                    Lv_UltimaMilla := 'FO';
                    --
                    Lo_ServicioHistorial  := NULL;

                    -- VERIFICO SI YA SE INGRESO EL HISTORIAL EN EL SERVICIO PARA NO VOLVERLO A INGRESAR
                    OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_ObservacionPlan,
                                                 Cn_IdServicio  => Ln_IdServicio);
                    FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
                    CLOSE C_GetServicioHistorial;

                    IF Lv_ObservacionPlan IS NOT NULL AND NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN
                      Lo_ServicioHistorial                       := NULL;
                      Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                      Lo_ServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
                      Lo_ServicioHistorial.ESTADO                := Lv_EstadoServicio;
                      Lo_ServicioHistorial.OBSERVACION           := Lv_ObservacionPlan;
                      Lo_ServicioHistorial.USR_CREACION          := Pv_UsrCreacion;
                      Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
                      DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Lv_MensajeError);
                    END IF;    
                  END IF;  
                  Lr_SolicitudInstalacion:=DB_COMERCIAL.COMEK_CONSULTAS.F_GET_INFO_SOL_INSTALACION(Pv_EmpresaCod           => Pv_EmpresaCod,
                                                                                                   Pv_DescripcionSolicitud => Pv_DescripcionSolicitud,
                                                                                                   Pv_CaractContrato       => Pv_CaractContrato,
                                                                                                   Pv_NombreMotivo         => Pv_NombreMotivo,
                                                                                                   Pv_UltimaMilla          => Lv_UltimaMilla);
                  IF Lr_SolicitudInstalacion.ID_TIPO_SOLICITUD IS NULL THEN
                    Lv_MensajeError := 'No fue encontrada la información requerida para crear las solicitudes de instalación.';
                    RAISE Le_Exception;
                  END IF;
                  Lr_SolicitudInstalacion.USR_CREACION:= Pv_UsrCreacion;                   
                    --                  
                    --Si no posee plan con restricción debo ejecutar el mapeo promocional por instalación para verificar si aplica a alguna promoción
                    --y poder generar la solicitud de Facturación con el descuento y diferido de ser el caso.
                    IF NOT Lb_PlanConRestriccion THEN
  
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'COMEK_TRANSACTION.COMEP_CREAR_FACT_INSTALACION', 
                                           'Por Ingresar P_PROCESO_MAPEO_PROM_INS', 
                                           'telcos_log_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  

                      --Proceso que genera el mapeo promocional en el caso que el servicio cumpla alguna Promoción por Instalación.
                      DB_COMERCIAL.CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio            =>Ln_IdServicio,
                                                                                 Pv_CodigoGrupoPromocion  =>'PROM_INS',
                                                                                 Pv_CodEmpresa            =>Pv_EmpresaCod,
                                                                                 Pv_EsCodigo              => 'S',
                                                                                 Pv_Mensaje               =>Lv_MensajeError);

                      Lv_MensajeError := '';
                      --
                      DB_COMERCIAL.CMKG_PROMOCIONES_INS.P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio            =>Ln_IdServicio,
                                                                                 Pv_CodigoGrupoPromocion  =>'PROM_INS',
                                                                                 Pv_CodEmpresa            =>Pv_EmpresaCod,
                                                                                 Pv_EsCodigo              => 'N',
                                                                                 Pv_Mensaje               =>Lv_MensajeError);
                      --  
                      Lv_MensajeError := '';
  
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'COMEK_TRANSACTION.COMEP_CREAR_FACT_INSTALACION', 
                                           'Finaliza P_PROCESO_MAPEO_PROM_INS: ' || Lv_MensajeError, 
                                           'telcos_log_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
                      --
                      --
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'COMEK_TRANSACTION.COMEP_CREAR_FACT_INSTALACION', 
                                           'Por Ingresar P_APLICA_PROMOCION', 
                                           'telcos_log_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
  
                      --Proceso genera solicitud de Facturación de Instalación en base a la promoción aplicada.
                      DB_COMERCIAL.CMKG_PROMOCIONES.P_APLICA_PROMOCION(Pv_CodEmpresa   =>Pv_EmpresaCod,  
                                                                       Pv_TipoPromo    =>'PROM_INS',
                                                                       Pn_IdServicio   =>Ln_IdServicio, 
                                                                       Pv_MsjResultado =>Lv_MensajeError);

                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'COMEK_TRANSACTION.COMEP_CREAR_FACT_INSTALACION', 
                                           'Finaliza P_APLICA_PROMOCION: ' || Lv_MensajeError,
                                           'telcos_log_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
                      --
                      --
                      IF Lv_MensajeError = 'OK' THEN
                        Lb_AplicaPromo:=TRUE;
                      ELSE
                        Ln_PorcentajeDescuento:= 0;
                        Lo_ServicioHistorial  := NULL;
                        Lv_Observacion        := 'No se Aplicó promoción de Instalación para el servicio, se generará Factura de Instalación'||
                                                 ' por el valor base de Instalación';
                        OPEN  C_GetServicioHistorial(Cv_Observacion => Lv_Observacion,
                                                     Cn_IdServicio  => Ln_IdServicio);
                        FETCH C_GetServicioHistorial INTO Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL;
                        CLOSE C_GetServicioHistorial;

                        IF NVL(Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL, 0) = 0 THEN
                          Lo_ServicioHistorial                       := NULL;
                          Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                          Lo_ServicioHistorial.SERVICIO_ID           := Ln_IdServicio;
                          Lo_ServicioHistorial.ESTADO                := Lv_EstadoServicio;
                          Lo_ServicioHistorial.OBSERVACION           := Lv_Observacion;
                          Lo_ServicioHistorial.USR_CREACION          := Pv_UsrCreacion;
                          Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
                          DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Lv_MensajeError);
                        END IF;
                        -- 
                      END IF;
                      -- FIN Lv_MensajeError = 'OK' 
                      --
                    END IF;
                    --FIN NOT Lb_PlanConRestriccion               
                    --
                    IF Lb_PlanConRestriccion OR NOT Lb_AplicaPromo THEN                         
                    --     
                      Lr_SolicitudInstalacion.OBSERVACION_SOLICITUD := Pv_ObservacionSolicitud;          
                      Lr_SolicitudInstalacion.NOMBRE_PLAN           := Lv_NombrePlan;
                      Lr_SolicitudInstalacion.FORMA_PAGO            := Lr_Contrato.FORMA_PAGO;
                      Lr_SolicitudInstalacion.PUNTO_ID              := Lc_Puntos.ID_PUNTO;
                      Lr_SolicitudInstalacion.ID_SERVICIO           := Ln_IdServicio;
                      Lr_SolicitudInstalacion.PORCENTAJE            := Ln_PorcentajeDescuento;
                      Lr_SolicitudInstalacion.PERIODOS              := NULL;
                      Lr_SolicitudInstalacion.APLICA_PROMO          := NULL;
                      Lv_MensajeError                               := NULL;
                      DB_COMERCIAL.COMEK_TRANSACTION.P_CREA_SOL_FACT_INSTALACION(Pr_SolicitudInstalacion => Lr_SolicitudInstalacion,
                                                                                 Pv_Mensaje              => Lv_MensajeError,
                                                                                 Pn_ContadorSolicitudes  => Ln_ContadorSolicitudes,
                                                                                 Pn_IdDetalleSolicitud   => Ln_IdDetalleSolicitud);
                      IF Lv_MensajeError IS NOT NULL THEN
                        RAISE Le_Exception;
                      END IF;
                      --
                    END IF;
                    -- FIN Lb_PlanConRestriccion OR NOT Lb_AplicaPromo
                    -- 
                    --
                  END IF;
                  --Fin NVL(Lr_GetSolicitudInstalacion.ID_DETALLE_SOLICITUD, 0) = 0 
                  --
                END IF;
                --FIN NVL(Ln_IdServicio, 0) != 0
                --  
                
              END LOOP;
              --
              --
              --
              IF Ln_ContadorPuntos = 0 THEN
              --
                --
                  -- INSERTO HISTORIAL DE LA PERSONA EMPRESA ROL
                  --
                  Lo_PersonaEmpresaRol    := NULL;
                  Lo_PersonaRolHistorial  := NULL;
                  Lv_MensajeError         := '';
                  Lv_Observacion          := 'No se genera solicitud de descuento ni factura de instalación puesto el'||
                                             ' cliente no tiene puntos agregados';
                  --
                  --
                  --
                  -- VERIFICO SI YA SE INGRESO EL HISTORIAL DE LA PERSONA EMPRESA ROL PARA NO VOLVERLO A INGRESAR
                  --
                  SELECT NVL(
                                (
                                    SELECT ID_PERSONA_EMPRESA_ROL_HISTO
                                    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO
                                    WHERE OBSERVACION LIKE Lv_Observacion
                                      AND ID_PERSONA_EMPRESA_ROL_HISTO = (
                                                                              SELECT MAX(ID_PERSONA_EMPRESA_ROL_HISTO)
                                                                              FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO
                                                                              WHERE PERSONA_EMPRESA_ROL_ID = Lr_Contrato.PERSONA_EMPRESA_ROL_ID
                                                                         )
                                ),
                                0
                            )
                  INTO Lo_PersonaRolHistorial.ID_PERSONA_EMPRESA_ROL_HISTO
                  FROM DUAL;
                  --
                  --
                  --
                  IF Lo_PersonaRolHistorial.ID_PERSONA_EMPRESA_ROL_HISTO = 0 THEN
                  --
                      --
                      SELECT * INTO Lo_PersonaEmpresaRol
                      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
                      WHERE ID_PERSONA_ROL = Lr_Contrato.PERSONA_EMPRESA_ROL_ID;
                      --
                      --
                      --
                      SELECT DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL 
                      INTO Lo_PersonaRolHistorial.ID_PERSONA_EMPRESA_ROL_HISTO
                      FROM DUAL;
                      --
                      --
                      --
                      Lo_PersonaRolHistorial.PERSONA_EMPRESA_ROL_ID := Lo_PersonaEmpresaRol.ID_PERSONA_ROL;
                      Lo_PersonaRolHistorial.OBSERVACION            := Lv_Observacion;
                      Lo_PersonaRolHistorial.USR_CREACION           := Pv_UsrCreacion;
                      Lo_PersonaRolHistorial.ESTADO                 := Lo_PersonaEmpresaRol.ESTADO;
                      Lo_PersonaRolHistorial.IP_CREACION            := '127.0.0.1';
                      --
                      DB_COMERCIAL.COMEK_TRANSACTION.COMEP_INSERT_PERSONA_ROL_HISTO(Lo_PersonaRolHistorial, Lv_MensajeError);
                      --
                  --
                  END IF;
                  --
                  --
                  -- FIN INSERTO HISTORIAL DE LA PERSONA EMPRESA ROL
                  --
              --
              END IF;
              -- 
            END LOOP;
            --
            EXIT WHEN Lrf_ContratosProcesar%NOTFOUND;    
        --
        END LOOP;
        --
        CLOSE Lrf_ContratosProcesar; 
        --
        --
        --
        COMMIT;
        --
        --
        --
        IF Lr_SolicitudInstalacion.MOTIVO_ID IS NOT NULL THEN
        --
            --
            DB_FINANCIERO.FNCK_TRANSACTION.P_GENERAR_FACTURAS_SOLICITUD(Pv_Estado               => 'Pendiente',
                                                                        Pv_DescripcionSolicitud => Pv_DescripcionSolicitud,
                                                                        Pv_UsrCreacion          => Pv_UsrCreacion,
                                                                        Pn_MotivoId             => Lr_SolicitudInstalacion.MOTIVO_ID,
                                                                        Pv_EmpresaCod           => Pv_EmpresaCod,
                                                                        Pv_MsnError             => Lv_MensajeError);
            --
        --
        END IF;
        --
    --
    EXCEPTION 
    WHEN Le_Exception THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'COMEK_TRANSACTION.COMEP_CREAR_FACT_INSTALACION', 
                                            'Error al crear la factura por instalacion  - ' || Lv_MensajeError
                                            || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK
                                            || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    WHEN OTHERS THEN
      --
      ROLLBACK;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'COMEK_TRANSACTION.COMEP_CREAR_FACT_INSTALACION', 
                                            'Error al crear la factura por instalacion  - ' || SQLCODE || ' - ERROR_STACK: ' 
                                            || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  --
  END COMEP_CREAR_FACT_INSTALACION;
  --

  PROCEDURE P_CREA_SOL_FACT_INSTALACION(Pr_SolicitudInstalacion IN  DB_COMERCIAL.CMKG_TYPES.Lr_SolicitudInstalacion,
                                          Pv_Mensaje              OUT VARCHAR2,
                                          Pn_ContadorSolicitudes  IN  OUT NUMBER,
                                          Pn_IdDetalleSolicitud   IN  OUT NUMBER)
    IS
        Lo_PuntoHistorial       DB_COMERCIAL.INFO_PUNTO_HISTORIAL%ROWTYPE;
        Lo_DetalleSolicitud     DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
        Lr_InfoDetalleSolCaract DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE;
        Lo_DetalleSolHistorial  DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
        Lv_EstadoFacturable     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE := 'Facturable';
        Lv_ObservacionPorDias   VARCHAR2(150) := NULL;
        Lv_Observacion          VARCHAR2(1000) := NULL;
        Lv_MensajeError         VARCHAR2(3000) := '';
        Lv_AplicaPromocion      VARCHAR2(100)                                                    := Pr_SolicitudInstalacion.APLICA_PROMO;
        Ln_PorcentajeDescuento  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.PORCENTAJE%TYPE            := Pr_SolicitudInstalacion.PORCENTAJE;
        Ln_CantidadPeriodos     DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.PERIODo%TYPE               := Pr_SolicitudInstalacion.PERIODOS;
        Lv_DescripcionSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE      := Pr_SolicitudInstalacion.DESCRIPCION_SOLICITUD;
        Lv_ObservacionSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE             := Pr_SolicitudInstalacion.OBSERVACION_SOLICITUD;
        Ln_IdTipoSolicitud      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE          := Pr_SolicitudInstalacion.ID_TIPO_SOLICITUD;
        Ln_IdMotivo             DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE               := Pr_SolicitudInstalacion.MOTIVO_ID;
        Ln_ValorInstalacion     NUMBER                                                           := Pr_SolicitudInstalacion.VALOR_INSTALACION;
        Lv_FechaVigenciaFact    VARCHAR2(25)                                                     := Pr_SolicitudInstalacion.FECHA_VIGENCIA_FACT;
        Lv_UsrCreacion          VARCHAR2(20)                                                     := Pr_SolicitudInstalacion.USR_CREACION;       
        Ln_IdServicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE                      := Pr_SolicitudInstalacion.ID_SERVICIO;
        Ln_PuntoId              DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                            := Pr_SolicitudInstalacion.PUNTO_ID;
        Ln_CaractIdContratoTipo DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE          := Pr_SolicitudInstalacion.ID_CARACT_TIPO_CONTRATO;
        Ln_FechaVigenciaCarac   DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE          := Pr_SolicitudInstalacion.ID_CARACT_FE_VIGENCIA;
        Lv_CaractContrato       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := Pr_SolicitudInstalacion.DESC_CARACT_CONTRATO;
        Le_Exception            EXCEPTION;      

        --Costo: Query para obtener el id_punto_historial: 9
        CURSOR C_GetPuntoHistorial (Cv_Observacion DB_COMERCIAL.INFO_PUNTO_HISTORIAL.VALOR%TYPE,
                                    Cn_IdPunto     DB_COMERCIAL.INFO_PUNTO_HISTORIAL.PUNTO_ID%TYPE) IS
            SELECT ID_PUNTO_HISTORIAL
              FROM DB_COMERCIAL.INFO_PUNTO_HISTORIAL
             WHERE VALOR = Cv_Observacion
               AND PUNTO_ID = Cn_IdPunto;

    BEGIN

        IF NVL(Ln_IdServicio, 0) > 0 THEN

                    IF Lv_AplicaPromocion = 'S' then 
                        Ln_ValorInstalacion   :=   ROUND(NVL((Ln_ValorInstalacion/Ln_CantidadPeriodos), 0), 2);
                    END IF;

                    --SE CREA LA SOLICITUD DE INSTALACIÓN
                    Lv_MensajeError     := '';
                    Lo_DetalleSolicitud := NULL;
                    Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD  := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL;
                    Lo_DetalleSolicitud.SERVICIO_ID           := Ln_IdServicio;
                    Lo_DetalleSolicitud.TIPO_SOLICITUD_ID     := Ln_IdTipoSolicitud;
                    Lo_DetalleSolicitud.PORCENTAJE_DESCUENTO  := Ln_PorcentajeDescuento;
                    Lo_DetalleSolicitud.PRECIO_DESCUENTO      := Ln_ValorInstalacion;
                    Lo_DetalleSolicitud.USR_CREACION          := Lv_UsrCreacion;
                    Lo_DetalleSolicitud.OBSERVACION           := Lv_ObservacionSolicitud;
                    Lo_DetalleSolicitud.ESTADO                := 'Pendiente';
                    Lo_DetalleSolicitud.MOTIVO_ID             := Ln_IdMotivo;
                    DB_COMERCIAL.COMEK_TRANSACTION.COMEP_INSERT_DETALLE_SOLICITUD(Lo_DetalleSolicitud, Lv_MensajeError);
                    Pn_IdDetalleSolicitud                     := Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD;
              
                    IF Lv_MensajeError IS NOT NULL THEN
                        Lv_MensajeError := 'Error al crear la ' || NVL(Lv_DescripcionSolicitud, 'solicitud de facturación de instalación');
                        RAISE Le_Exception;
                    END IF;
                    --FIN SE CREA LA SOLICITUD DE INSTALACIÓN

                    --SE CREAN LAS CARACTERÍSTICAS A SER MIGRADAS EN EL DOCUMENTO.
                    --Característica por el tipo de contrato DIGITAL/FISICO
                    Lr_InfoDetalleSolCaract                             := NULL;
                    Lr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID        := Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD;
                    Lr_InfoDetalleSolCaract.CARACTERISTICA_ID           := Ln_CaractIdContratoTipo;
                    Lr_InfoDetalleSolCaract.VALOR                       := 'S';
                    Lr_InfoDetalleSolCaract.FE_CREACION                 := SYSDATE;
                    Lr_InfoDetalleSolCaract.USR_CREACION                := Lv_UsrCreacion;
                    Lr_InfoDetalleSolCaract.ESTADO                      := Lv_EstadoFacturable;
                    DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC( Lr_InfoDetalleSolCaract, Lv_MensajeError );

                    IF Lv_MensajeError IS NOT NULL THEN
                        Lv_MensajeError := 'Error al insertar la característica ' || Lv_CaractContrato || ':' || Lv_MensajeError;
                        RAISE Le_Exception;
                    END IF;

                    Lr_InfoDetalleSolCaract                             := NULL;
                    Lr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID        := Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD;
                    Lr_InfoDetalleSolCaract.CARACTERISTICA_ID           := Ln_FechaVigenciaCarac;
                    Lr_InfoDetalleSolCaract.VALOR                       := Lv_FechaVigenciaFact;
                    Lr_InfoDetalleSolCaract.FE_CREACION                 := SYSDATE;
                    Lr_InfoDetalleSolCaract.USR_CREACION                := Lv_UsrCreacion;
                    Lr_InfoDetalleSolCaract.ESTADO                      := Lv_EstadoFacturable;
                    DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC( Lr_InfoDetalleSolCaract, Lv_MensajeError );

                    IF Lv_MensajeError IS NOT NULL THEN
                        Lv_MensajeError := 'Error al insertar la característica de FECHA_VIGENCIA en la factura:' || Lv_MensajeError;
                        RAISE Le_Exception;
                    END IF;
                    --FIN SE CREAN LAS CARACTERISTICAS A SER MIGRADAS EN EL DOCUMENTO.

                    --SE CREA HISTORIAL DE LA SOLICITUD DE INSTALACIÓN
                    Lo_DetalleSolHistorial := NULL;
                    Lv_MensajeError        := '';

                    Lo_DetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
                    Lo_DetalleSolHistorial.DETALLE_SOLICITUD_ID   := Lo_DetalleSolicitud.ID_DETALLE_SOLICITUD;
                    Lo_DetalleSolHistorial.ESTADO                 := 'Pendiente';
                    Lo_DetalleSolHistorial.OBSERVACION            := 'Se crea: ' || Lv_ObservacionSolicitud;
                    Lo_DetalleSolHistorial.USR_CREACION           := Lv_UsrCreacion;
                    Lo_DetalleSolHistorial.IP_CREACION            := '127.0.0.1';
                    DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Lo_DetalleSolHistorial, Lv_MensajeError);
                    -- FIN INSERTO HISTORIAL DE LA SOLICITUD DE INSTALACION

                    Pn_ContadorSolicitudes := Pn_ContadorSolicitudes + 1;
        
        ELSE
            -- INSERTO HISTORIAL DEL PUNTO
            Lo_PuntoHistorial := NULL;
            Lv_MensajeError   := '';
            Lv_Observacion    := NVL(Lv_ObservacionPorDias, 
                                     'No se genera solicitud de descuento ni factura de instalación puesto que el punto del cliente'||
                                     ' no tiene servicios con tipo de orden nueva, en estado factible, que sean venta, de frecuencia '||
                                     'mensual, con un producto de INTERNET y que su ultima milla sea Fibra o Cobre');
            --Se vacía la observación.
            Lv_ObservacionPorDias := NULL;

            -- VERIFICO SI YA SE INGRESO EL HISTORIAL EN EL PUNTO PARA NO VOLVERLO A INGRESAR
            OPEN  C_GetPuntoHistorial (Cv_Observacion => Lv_Observacion,
                                       Cn_IdPunto     => Ln_PuntoId);
            FETCH C_GetPuntoHistorial INTO Lo_PuntoHistorial.ID_PUNTO_HISTORIAL;
            CLOSE C_GetPuntoHistorial;

            IF NVL(Lo_PuntoHistorial.ID_PUNTO_HISTORIAL, 0) = 0 THEN
                Lo_PuntoHistorial                    := NULL;
                Lo_PuntoHistorial.ID_PUNTO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_PUNTO_HISTORIAL.NEXTVAL;
                Lo_PuntoHistorial.PUNTO_ID           := Ln_PuntoId;
                Lo_PuntoHistorial.VALOR              := Lv_Observacion;
                Lo_PuntoHistorial.USR_CREACION       := Lv_UsrCreacion;
                DB_COMERCIAL.COMEK_TRANSACTION.COMEP_INSERT_PUNTO_HISTORIAL(Lo_PuntoHistorial, Lv_MensajeError);
            END IF;
            -- FIN INSERTO HISTORIAL DEL PUNTO
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            Pv_Mensaje := Lv_MensajeError || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'COMEK_TRANSACTION.P_CREA_SOL_FACT_INSTALACION', 
                                                 'Error al crear la factura por instalacion  - ' || SQLCODE || ' - ERROR_STACK: ' || 
                                                 DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                                                 ': ' || Pv_Mensaje,
                                                 NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                                 SYSDATE, 
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_CREA_SOL_FACT_INSTALACION;
  --
  PROCEDURE P_INSERT_DETALLE_SOL_HIST(
      Pr_InfoDetalleSolHist IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,
      Pv_MsnError OUT VARCHAR2 )
  AS
  BEGIN
    --
    INSERT
    INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
      (
        ID_SOLICITUD_HISTORIAL,
        DETALLE_SOLICITUD_ID,
        ESTADO,
        OBSERVACION,
        USR_CREACION,
        FE_CREACION,
        IP_CREACION
      )
      VALUES
      (
        Pr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL,
        Pr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID,
        Pr_InfoDetalleSolHist.ESTADO,
        Pr_InfoDetalleSolHist.OBSERVACION,
        Pr_InfoDetalleSolHist.USR_CREACION,
        SYSDATE,
        Pr_InfoDetalleSolHist.IP_CREACION
      );
    --
    COMMIT;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MsnError := 'No se pudo generar el historial de la solicitud';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST', 
                                          Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_INSERT_DETALLE_SOL_HIST;
  --
  --
  PROCEDURE P_INSERT_SERVICIO_HISTO
    (
      Pr_InfoServicioHistorial IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE,
      Pv_MsnError OUT VARCHAR2
    )
  AS
  BEGIN
    --
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
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
        Pr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL,
        Pr_InfoServicioHistorial.SERVICIO_ID,
        Pr_InfoServicioHistorial.USR_CREACION,
        SYSDATE,
        Pr_InfoServicioHistorial.IP_CREACION,
        Pr_InfoServicioHistorial.ESTADO,
        Pr_InfoServicioHistorial.OBSERVACION
      );
    --
    COMMIT;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MsnError := 'Error al guardar el historial del servicio';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTO', 
                                          Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_INSERT_SERVICIO_HISTO;

  PROCEDURE P_FINALIZA_SOLICITUD_POR_TIPO(
      Pn_IdTipoSolicitud     IN  INFO_DETALLE_SOLICITUD.TIPO_SOLICITUD_ID%TYPE,
      Pv_EstadoSol           IN  INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
      Pv_EstadoSolActualizar IN  INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
      Pv_Observacion         IN  INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
      Pv_Usuario             IN  INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE,
      Pv_Ip                  IN  INFO_DETALLE_SOL_HIST.IP_CREACION%TYPE,
      Pv_Error               OUT VARCHAR2)
  AS
    -- C_GetDetalleSolicitud - Costo Query: 4
    CURSOR C_GetDetalleSolicitud(Cn_IdTipoSolicitud INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE, Cv_Estado INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
    IS
      SELECT IDS.ID_DETALLE_SOLICITUD,
        (SELECT IP.LOGIN
        FROM DB_COMERCIAL.INFO_PUNTO IP,
          DB_COMERCIAL.INFO_SERVICIO ISR
        WHERE IP.ID_PUNTO   = ISR.PUNTO_ID
        AND ISR.ID_SERVICIO = IDS.SERVICIO_ID
        ) LOGIN,
        ATS.DESCRIPCION_SOLICITUD,
        IDS.USR_CREACION,
        TO_CHAR(IDS.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS') FE_CREACION,
        IDS.ESTADO
      FROM INFO_DETALLE_SOLICITUD IDS,
        ADMI_TIPO_SOLICITUD ATS
      WHERE IDS.TIPO_SOLICITUD_ID = Cn_IdTipoSolicitud
      AND ATS.ID_TIPO_SOLICITUD   = IDS.TIPO_SOLICITUD_ID
      AND IDS.ESTADO              = Cv_Estado;
    --
    Lc_GetDetalleSolicitud C_GetDetalleSolicitud%ROWTYPE;
    Lr_DetalleSolHistorial INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lv_TableSolicitud      CLOB;
    Lc_GetAliasPlantilla   DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Ln_CounterMail         NUMBER := 0;
    Lv_Observacion         VARCHAR2(2000);
    Lv_MsgErrorMail        VARCHAR2(3000);
    Lv_MensajeErrorHist    VARCHAR2(3000);
    Lv_CuerpoMail          VARCHAR2(3000);
    Lv_EstadoSolicitud     VARCHAR2(20);
    Le_FalloInsrtHist      EXCEPTION;
    --
  BEGIN
    --
    DBMS_LOB.CREATETEMPORARY(Lv_TableSolicitud, TRUE);
    --
    FOR I_GetDetalleSolicitud IN C_GetDetalleSolicitud(Pn_IdTipoSolicitud, Pv_EstadoSol)
    LOOP
      --
      BEGIN
        --
        Lv_Observacion := 'Se cambio la solicitud a estado ' || Pv_EstadoSolActualizar;
        Lv_CuerpoMail  := 'Estimado personal el siguiente correo es para informales la finalización de solicitudes por cargo de reproceso';
        --
        UPDATE INFO_DETALLE_SOLICITUD
        SET ESTADO                 = Pv_EstadoSolActualizar
        WHERE ID_DETALLE_SOLICITUD = I_GetDetalleSolicitud.ID_DETALLE_SOLICITUD;
        --
        Lr_DetalleSolHistorial                        := NULL;
        Lr_DetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL ;
        Lr_DetalleSolHistorial.DETALLE_SOLICITUD_ID   := I_GetDetalleSolicitud.ID_DETALLE_SOLICITUD;
        Lr_DetalleSolHistorial.ESTADO                 := Pv_EstadoSolActualizar;
        Lr_DetalleSolHistorial.OBSERVACION            := Pv_Observacion;
        Lr_DetalleSolHistorial.USR_CREACION           := Pv_Usuario;
        Lr_DetalleSolHistorial.IP_CREACION            := Pv_Ip;
        Lv_EstadoSolicitud                            := Pv_EstadoSolActualizar;
        --
        DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Lr_DetalleSolHistorial, Lv_MensajeErrorHist);
        --
        --
        Ln_CounterMail := Ln_CounterMail + 1;
        --
        IF Lv_MensajeErrorHist IS NOT NULL THEN
          --
          RAISE Le_FalloInsrtHist;
          --
        END IF;
        --
      EXCEPTION
      WHEN Le_FalloInsrtHist THEN
        --
        Lv_Observacion      := 'No se pudo cambiar el estado de la solicutd.';
        Lv_EstadoSolicitud  := I_GetDetalleSolicitud.ESTADO;
        --
      END;
      --
      --
      DBMS_LOB.APPEND(Lv_TableSolicitud, '<tr>' || 
                            '<td>' || I_GetDetalleSolicitud.ID_DETALLE_SOLICITUD || ' </td>' || 
                            '<td>' || I_GetDetalleSolicitud.LOGIN || ' </td>' ||
                            '<td>' || I_GetDetalleSolicitud.DESCRIPCION_SOLICITUD || ' </td>' ||
                            '<td>' || I_GetDetalleSolicitud.USR_CREACION || ' </td>' ||
                            '<td>' || I_GetDetalleSolicitud.FE_CREACION || ' </td>' ||
                            '<td>' || Lv_EstadoSolicitud || ' </td>' ||
                            '<td>' || Lv_Observacion || ' </td></tr>');

      IF Ln_CounterMail >= 100 THEN
        --
        Ln_CounterMail := 0;
        --
        --
        DB_GENERAL.GNRLPCK_UTIL.P_ENVIO_CORREO_POR_PARAMETROS('ENVIO_MAIL_CARGO_DEBT', 
                                                              'Activo', 
                                                              'Activo', 
                                                              'CARGO_DEBT_SUB', 
                                                              NULL, 
                                                              NULL, 
                                                              NULL, 
                                                              'CARGO_DEBT_SUB',
                                                              Lv_CuerpoMail , 
                                                              Lv_TableSolicitud, 
                                                              'text/html; charset=UTF-8', 
                                                              Lv_MsgErrorMail);
        --
        DBMS_LOB.FREETEMPORARY(Lv_TableSolicitud);

        Lv_TableSolicitud := '';

        DBMS_LOB.CREATETEMPORARY(Lv_TableSolicitud, TRUE);
        --
      END IF;
      --
    END LOOP;
    --
    IF Ln_CounterMail > 0 THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.P_ENVIO_CORREO_POR_PARAMETROS('ENVIO_MAIL_CARGO_DEBT', 
                                                            'Activo', 
                                                            'Activo', 
                                                            'CARGO_DEBT_SUB', 
                                                            NULL, 
                                                            NULL, 
                                                            NULL, 
                                                            'CARGO_DEBT_SUB',
                                                            Lv_CuerpoMail , 
                                                            Lv_TableSolicitud, 
                                                            'text/html; charset=UTF-8', 
                                                            Lv_MsgErrorMail);
      --
      DBMS_LOB.FREETEMPORARY(Lv_TableSolicitud);

      Lv_TableSolicitud := '';

      DBMS_LOB.CREATETEMPORARY(Lv_TableSolicitud, TRUE);
      --
    END IF;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'COMEK_TRANSACTION.P_FINALIZA_SOLICITUD_POR_TIPO', 
                                          'Error al finalizar solicitud por tipo ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_FINALIZA_SOLICITUD_POR_TIPO;
  --

  PROCEDURE P_UPDATE_INFO_SERVICIO_CARAC(Pr_InfoServicioCaracteristica IN  DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE,
                                         Pv_Mensaje                    OUT VARCHAR2)
  AS
  BEGIN
    UPDATE DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
        SET VALOR       = NVL(Pr_InfoServicioCaracteristica.VALOR,VALOR),
            ESTADO      = NVL(Pr_InfoServicioCaracteristica.ESTADO,ESTADO),
            OBSERVACION = NVL(Pr_InfoServicioCaracteristica.OBSERVACION,OBSERVACION),
            FE_ULT_MOD  = SYSDATE,
            USR_ULT_MOD = NVL(Pr_InfoServicioCaracteristica.USR_ULT_MOD,USR_ULT_MOD),
            IP_ULT_MOD  = NVL(Pr_InfoServicioCaracteristica.IP_ULT_MOD,IP_ULT_MOD)
      WHERE ID_SERVICIO_CARACTERISTICA = Pr_InfoServicioCaracteristica.ID_SERVICIO_CARACTERISTICA;
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Ocurrió un error al actualizar el registro ' || Pr_InfoServicioCaracteristica.ID_SERVICIO_CARACTERISTICA
                 || ' de INFO_SERVICIO_CARACTERISTICA. ' || 'Error ' || SQLCODE || ' -ERROR- ' || SQLERRM
                 || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_UPDATE_INFO_SERVICIO_CARAC;

  --
  PROCEDURE P_CALCULO_COMISION_MANTENIMI(
      Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_EstadoServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pn_ContadorCommit IN NUMBER,
      Pv_MensajeError OUT VARCHAR2)
  AS
    --
    --COSTO DE QUERY : 34
    CURSOR C_ServiciosComisionMantenim(Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                                       Cv_EstadoServicio DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    IS      
   SELECT 
    PER.ID_PERSONA,
    PER.NOMBRES,
    PER.APELLIDOS,
    PER.IDENTIFICACION_CLIENTE,
    PER.RAZON_SOCIAL, 
    PEMPROL.ID_PERSONA_ROL,        
    PTO.LOGIN,
    SERV.ID_SERVICIO,
    SERV.LOGIN_AUX,
    HISTO.FECHA_ACTIVACION,   
    MONTHS_BETWEEN(SYSDATE,HISTO.FECHA_ACTIVACION) AS MESES, 
    --
    SCOM.ID_SERVICIO_COMISION,    
    SCOM.COMISION_DET_ID,
    SCOM.PERSONA_EMPRESA_ROL_ID,
    SCOM.ESTADO,  
    SCOM.COMISION_VENTA, 
    SCOM.COMISION_VENTA *0.5 AS COMI_MANTENIMIENTO
  FROM  DB_COMERCIAL.INFO_PERSONA PER
  JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEMPROL ON PER.ID_PERSONA = PEMPROL.PERSONA_ID 
  JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPROL ON PEMPROL.EMPRESA_ROL_ID  = EMPROL.ID_EMPRESA_ROL
  JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPGRUP ON EMPROL.EMPRESA_COD   = EMPGRUP.COD_EMPRESA 
  JOIN DB_GENERAL.ADMI_ROL ROL ON EMPROL.ROL_ID = ROL.ID_ROL
  JOIN DB_GENERAL.ADMI_TIPO_ROL TROL ON ROL.TIPO_ROL_ID = TROL.ID_TIPO_ROL 
  JOIN DB_COMERCIAL.INFO_PUNTO PTO ON PEMPROL.ID_PERSONA_ROL= PTO.PERSONA_EMPRESA_ROL_ID
  JOIN DB_COMERCIAL.INFO_SERVICIO SERV ON PTO.ID_PUNTO = SERV.PUNTO_ID
  --OBTENGO FECHA DE ACTIVACION DEL SERVICIO
  JOIN ( SELECT SERVICIO_ID,
              MAX(FE_CREACION) AS FECHA_ACTIVACION
              FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
              WHERE (UPPER (DBMS_LOB.SUBSTR( OBSERVACION,4000,1)) LIKE '%SE CONFIRMO EL SERVICIO%'
              OR UPPER (ACCION)                                   = 'CONFIRMARSERVICIO')
              AND ESTADO                                          = Cv_EstadoServicio
              GROUP BY SERVICIO_ID 
             ) HISTO ON HISTO.SERVICIO_ID = SERV.ID_SERVICIO  
             
  JOIN DB_COMERCIAL.ADMI_PRODUCTO PROD ON SERV.PRODUCTO_ID = PROD.ID_PRODUCTO
  JOIN DB_COMERCIAL.INFO_SERVICIO_COMISION SCOM ON SERV.ID_SERVICIO = SCOM.SERVICIO_ID
  WHERE   
  --SOLO CLIENTES DE TN
  TROL.DESCRIPCION_TIPO_ROL          = 'Cliente'  
  AND EMPGRUP.PREFIJO                = Cv_PrefijoEmpresa 
  --SOLO SERVICIOS ACTIVOS
  AND SERV.ESTADO                    = Cv_EstadoServicio
  --PRODUCTO DEBE ESTAR MARCADO QUE REQUIERE COMISIONAR
  AND PROD.REQUIERE_COMISIONAR       = 'SI'
  --ESTADO DE LA PLANTILLA DE COMISIONISTAS
  AND SCOM.ESTADO                    = Cv_EstadoServicio
  --SERVICIOS ACTIVOS CON MAS DE 1 ANIO (12 MESES) DESDE LA ACTIVACION
  AND MONTHS_BETWEEN(SYSDATE,HISTO.FECHA_ACTIVACION)>12 
  --QUE NO HAYA SIDO CALCULADA LA COMISION DE MANTENIMIENTO
  AND SCOM.COMISION_MANTENIMIENTO IS NULL
  
 ORDER BY HISTO.FECHA_ACTIVACION DESC ;
 
    --
    Lv_UsrCreacion           VARCHAR2(25) := 'telcos_comision';
    Lv_IpCreacion            VARCHAR2(10) := '127.0.0.1';
    Ln_ContadorServicios     NUMBER       := 0;    
    Ln_IdServicioComisionHisto DB_COMERCIAL.INFO_SERVICIO_COMISION_HISTO.ID_SERVICIO_COMISION_HISTO%TYPE;  
    --
  BEGIN
    --
    IF C_ServiciosComisionMantenim%ISOPEN THEN
      CLOSE C_ServiciosComisionMantenim;
    END IF;
    --
    -- SE RECORRE EL LISTADO DE SERVICIOS CON SUS PLANTILLAS A CALCULAR LA COMISION DE MANTENIMIENTO
    FOR Lr_ServiciosComisionMantenim IN C_ServiciosComisionMantenim(Pv_PrefijoEmpresa, Pv_EstadoServicio)
    LOOP
      --ACTUALIZO COMISION EN MANTENIMIENTO CALCULADA
      UPDATE DB_COMERCIAL.INFO_SERVICIO_COMISION SET COMISION_MANTENIMIENTO=Lr_ServiciosComisionMantenim.COMI_MANTENIMIENTO
      WHERE ID_SERVICIO_COMISION=Lr_ServiciosComisionMantenim.ID_SERVICIO_COMISION;
      --
      --INSERTO HISTORIAL DE COMISION EN MANTENIMIENTO CALCULADA
      Ln_IdServicioComisionHisto:=DB_COMERCIAL.SEQ_INFO_SERVICIO_COMI_HISTO.NEXTVAL;
      INSERT INTO
      DB_COMERCIAL.INFO_SERVICIO_COMISION_HISTO 
      (ID_SERVICIO_COMISION_HISTO,
      SERVICIO_COMISION_ID,
      SERVICIO_ID,
      COMISION_DET_ID,
      PERSONA_EMPRESA_ROL_ID,
      COMISION_VENTA,
      COMISION_MANTENIMIENTO,
      ESTADO,
      OBSERVACION,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION) 
      VALUES 
      (Ln_IdServicioComisionHisto,
      Lr_ServiciosComisionMantenim.ID_SERVICIO_COMISION,
      Lr_ServiciosComisionMantenim.ID_SERVICIO,
      Lr_ServiciosComisionMantenim.COMISION_DET_ID,
      Lr_ServiciosComisionMantenim.PERSONA_EMPRESA_ROL_ID,
      Lr_ServiciosComisionMantenim.COMISION_VENTA,
      Lr_ServiciosComisionMantenim.COMI_MANTENIMIENTO,     
      Lr_ServiciosComisionMantenim.ESTADO,
      'Se Calcula Comisión de Mantenimiento de: ['|| Lr_ServiciosComisionMantenim.COMI_MANTENIMIENTO || '] 
<br>En base a la Comisión en Venta de: [' || Lr_ServiciosComisionMantenim.COMISION_VENTA || '] 
<br> Fecha de Activación del servicio: [' || Lr_ServiciosComisionMantenim.FECHA_ACTIVACION ||']',
      Lv_UsrCreacion,
      SYSDATE,
      Lv_IpCreacion);
      --          
      Ln_ContadorServicios :=Ln_ContadorServicios+1;
      
      IF Ln_ContadorServicios > Pn_ContadorCommit THEN
         --
         COMMIT;
         --
         Ln_ContadorServicios := 0;
         --
      END IF;
      --
    END LOOP;
    --
    --
    IF Ln_ContadorServicios <= Pn_ContadorCommit THEN
      --
      COMMIT;
      --
    END IF;
    --
    --
    IF C_ServiciosComisionMantenim%ISOPEN THEN
      CLOSE C_ServiciosComisionMantenim;
    END IF;
    --
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'COMEK_TRANSACTION.P_CALCULO_COMISION_MANTENIMI', 
                                          'No se pudo realizar el calculo de la comision de mantenimiento de los servicios de la empresa ' || Pv_PrefijoEmpresa
                                          || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), Lv_UsrCreacion), 
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
    --
    Pv_MensajeError := 'No se pudo realizar el calculo de la comision de mantenimiento de los servicios de la empresa ' || Pv_PrefijoEmpresa;
    --
  END P_CALCULO_COMISION_MANTENIMI;
--



  PROCEDURE P_CAMBIO_ESTADO_SERVICIO
    (
      Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Pn_IdPunto IN DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
      Pv_EstadoAnterior IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pv_EstadoNuevo IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      Pv_UsrCreacion IN DB_COMERCIAL.INFO_SERVICIO.USR_CREACION%TYPE,
      Pv_MensajeError OUT VARCHAR2
    )
  AS
    PRAGMA AUTONOMOUS_TRANSACTION;
    --Cursor para obtener los tipos de solicitudes a gestionarse de acuerdo al cambio del estado del servicio
    CURSOR C_GetParamSols( Cv_EstadoAnterior DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                           Cv_EstadoNuevo DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
      IS
        SELECT APD.DESCRIPCION AS TIPO_SOLICITUD, APD.VALOR3 AS ESTADO_SOLICITUD_BUSCAR, APD.VALOR4 AS ESTADO_SOLICITUD_ACTUALIZAR
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
          ON APC.ID_PARAMETRO = APD.PARAMETRO_ID
        WHERE APC.NOMBRE_PARAMETRO = 'TIPOS_SOLICITUDES_CAMBIO_ESTADO_SERVICIO'
          AND APC.ESTADO = 'Activo'
          AND APD.ESTADO = 'Activo'
          AND APD.VALOR1 = Cv_EstadoAnterior
          AND APD.VALOR2 = Cv_EstadoNuevo;

    --Cursor para obtener el tipo de solicitud de planificación
    CURSOR C_GetAdmiSolPlanif
      IS
        SELECT ID_TIPO_SOLICITUD
        FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
        WHERE DESCRIPCION_SOLICITUD = 'SOLICITUD PLANIFICACION'
          AND ESTADO = 'Activo';


    CURSOR C_GetSolGestionPorServicio( Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Cv_NombreTipoSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                       Cv_EstadoSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
      IS
        SELECT IDS.ID_DETALLE_SOLICITUD
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISERV
          ON ISERV.ID_SERVICIO = IDS.SERVICIO_ID
        INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
          ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
        WHERE ISERV.ID_SERVICIO = Cn_IdServicio
          AND ATS.DESCRIPCION_SOLICITUD = Cv_NombreTipoSolicitud
          AND IDS.ESTADO = Cv_EstadoSolicitud;

    CURSOR C_GetSolGestionPorPunto( Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, 
                                    Cv_NombreTipoSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                    Cv_EstadoSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
      IS
        SELECT IDS.ID_DETALLE_SOLICITUD, ISERV.ID_SERVICIO, IOT.ID_ORDEN_TRABAJO, IOT.OFICINA_ID
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISERV
          ON ISERV.ID_SERVICIO = IDS.SERVICIO_ID
        INNER JOIN DB_COMERCIAL.INFO_PUNTO IPUNTO
          ON IPUNTO.ID_PUNTO = ISERV.PUNTO_ID
        INNER JOIN DB_COMERCIAL.INFO_ORDEN_TRABAJO IOT
          ON IOT.ID_ORDEN_TRABAJO = ISERV.ORDEN_TRABAJO_ID
        INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
          ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
        WHERE IPUNTO.ID_PUNTO = Cn_IdPunto
          AND ATS.DESCRIPCION_SOLICITUD = Cv_NombreTipoSolicitud
          AND IDS.ESTADO = Cv_EstadoSolicitud;

    Lr_GetParamSols C_GetParamSols%ROWTYPE;
    Lr_GetAdmiSolPlanif C_GetAdmiSolPlanif%ROWTYPE;
    Ln_IdDetSolPlanif NUMBER;

  BEGIN
    IF C_GetParamSols%ISOPEN THEN
       CLOSE C_GetParamSols;
    END IF;
    FOR I_GetParamSols IN C_GetParamSols(Pv_EstadoAnterior, Pv_EstadoNuevo)
    LOOP
      IF I_GetParamSols.TIPO_SOLICITUD = 'SOLICITUD MIGRACION' THEN

            FOR I_GetSolGestionPorServicio IN C_GetSolGestionPorServicio(Pn_IdServicio,
                                                                         I_GetParamSols.TIPO_SOLICITUD,
                                                                         I_GetParamSols.ESTADO_SOLICITUD_BUSCAR)
            LOOP
                --Se actualiza el estado de la solicitud
                UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
                  SET ESTADO = I_GetParamSols.ESTADO_SOLICITUD_ACTUALIZAR
                WHERE ID_DETALLE_SOLICITUD = I_GetSolGestionPorServicio.ID_DETALLE_SOLICITUD;

                --Se inserta un registro en la INFO_DETALLE_SOL_HIST por el cambio de estado de la solicitud
                INSERT 
                INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST 
                  (
                    ID_SOLICITUD_HISTORIAL,
                    DETALLE_SOLICITUD_ID,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    ESTADO
                  )  
                  VALUES 
                  (
                     DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                     I_GetSolGestionPorServicio.ID_DETALLE_SOLICITUD,
                     substr(SYS_CONTEXT('USERENV','HOST'),0,15),
                     SYSDATE,
                     SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15),
                     I_GetParamSols.ESTADO_SOLICITUD_ACTUALIZAR
                  );


                --Se inserta un registro en la INFO_SERVICIO_HISTORIAL por cada cambio de estado
                INSERT
                INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
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
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Pn_IdServicio,
                    Pv_UsrCreacion,
                    SYSDATE,
                    SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),
                    Pv_EstadoNuevo,
                    'Solicitud de Migracion: Cambio de estado ['||Pv_EstadoAnterior||'] - ['||Pv_EstadoNuevo||']'
                  );

            END LOOP;  
      END IF;
      IF I_GetParamSols.TIPO_SOLICITUD = 'SOLICITUD PREPLANIFICACION' THEN
            OPEN C_GetAdmiSolPlanif;
            FETCH C_GetAdmiSolPlanif INTO Lr_GetAdmiSolPlanif;
            FOR I_GetSolGestionPorPunto IN C_GetSolGestionPorPunto(Pn_IdPunto, 
                                                                   I_GetParamSols.TIPO_SOLICITUD, 
                                                                   I_GetParamSols.ESTADO_SOLICITUD_BUSCAR)
            LOOP
              -- Se finaliza la solicitud de preplanificación
              UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
              SET ESTADO = I_GetParamSols.ESTADO_SOLICITUD_ACTUALIZAR
              WHERE ID_DETALLE_SOLICITUD = I_GetSolGestionPorPunto.ID_DETALLE_SOLICITUD;

              --Crear historial de finalización de la solicitud de preplanificación
              INSERT
              INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                (
                  ID_SOLICITUD_HISTORIAL,
                  DETALLE_SOLICITUD_ID,
                  ESTADO,
                  OBSERVACION,
                  USR_CREACION,
                  FE_CREACION,
                  IP_CREACION
                )
                VALUES
                (
                  DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                  I_GetSolGestionPorPunto.ID_DETALLE_SOLICITUD,
                  I_GetParamSols.ESTADO_SOLICITUD_ACTUALIZAR,
                  'Se finaliza la solicitud de preplanificación por cambio de estado del servicio de Internet de In-Corte a Activo',
                  substr(SYS_CONTEXT('USERENV','HOST'),0,15),
                  SYSDATE,
                  SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                );

                --Crear la solicitud de planificación luego de finalizar la solicitud de preplanificación
                Ln_IdDetSolPlanif := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL;

                INSERT 
                INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD
                  (
                    ID_DETALLE_SOLICITUD,
                    SERVICIO_ID,
                    TIPO_SOLICITUD_ID,
                    USR_CREACION,
                    FE_CREACION,
                    OBSERVACION,
                    ESTADO
                  )
                  VALUES
                  (
                    Ln_IdDetSolPlanif,
                    I_GetSolGestionPorPunto.ID_SERVICIO,
                    Lr_GetAdmiSolPlanif.ID_TIPO_SOLICITUD,      
                    Pv_UsrCreacion,
                    SYSDATE,
                    'Solicitud creada luego de que el servicio de Internet pasa de estado ['||Pv_EstadoAnterior||'] - ['||Pv_EstadoNuevo||']',
                    'PrePlanificada'
                  );

                --Crear historial de la solicitud de planificación
                INSERT
                INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                  (
                    ID_SOLICITUD_HISTORIAL,
                    DETALLE_SOLICITUD_ID,
                    ESTADO,
                    OBSERVACION,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION
                  )
                  VALUES
                  (
                    DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                    Ln_IdDetSolPlanif,
                    'PrePlanificada',
                    'Se crea solicitud de planificacion por cambio de estado del servicio de Internet de ['||Pv_EstadoAnterior
                    ||'] - ['||Pv_EstadoNuevo||']',
                    substr(SYS_CONTEXT('USERENV','HOST'),0,15),
                    SYSDATE,
                    SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                  );

                -- Se actualiza el estado del servicio
                UPDATE DB_COMERCIAL.INFO_SERVICIO
                SET ESTADO = 'PrePlanificada'
                WHERE ID_SERVICIO = I_GetSolGestionPorPunto.ID_SERVICIO;

                --Se ingresa el historial por cambio de estado del servicio de Internet
                INSERT
                INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
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
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    I_GetSolGestionPorPunto.ID_SERVICIO,
                    Pv_UsrCreacion,
                    SYSDATE,
                    SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),
                    'PrePlanificada',
                    'Se cambia el estado del servicio, de Pendiente a Preplanificada, por reactivación de servicio de Internet.'
                  );
            END LOOP;
      END IF;
    END LOOP;
    COMMIT;
  EXCEPTION
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MensajeError := 'Error al intentar actualizar el estado del servicio con id '|| Pn_IdServicio
                        || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'COMEK_TRANSACTION.P_CAMBIO_ESTADO_SERVICIO', 
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_CAMBIO_ESTADO_SERVICIO;
--

  PROCEDURE P_CLIENTE_SIN_DEUDA
    (
      Pv_MensajeError OUT VARCHAR2
    )
  AS
    PRAGMA AUTONOMOUS_TRANSACTION;
    --Cursor para obtener el tipo de solicitud de planificación
    CURSOR C_GetAdmiSolPlanif
      IS
        SELECT ID_TIPO_SOLICITUD
        FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
        WHERE DESCRIPCION_SOLICITUD = 'SOLICITUD PLANIFICACION'
          AND ESTADO = 'Activo';

    --Cursor para obtener todos los clientes que aún tienen solicitudes de preplanificación y que no tienen deudas
    CURSOR C_GetClientesSinDeuda( Cv_NombreTipoSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                  Cv_EstadoSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
      IS
        SELECT DISTINCT IPUNTO.PERSONA_EMPRESA_ROL_ID, SUM(ECR.SALDO) AS SALDO_CLIENTE
	    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
	    INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISERV
	      ON ISERV.ID_SERVICIO = IDS.SERVICIO_ID
	    INNER JOIN DB_COMERCIAL.INFO_PUNTO IPUNTO
	      ON IPUNTO.ID_PUNTO = ISERV.PUNTO_ID
	    INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
	      ON ATS.ID_TIPO_SOLICITUD        = IDS.TIPO_SOLICITUD_ID
	    INNER JOIN DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO ECR
	      ON ECR.PUNTO_ID = IPUNTO.ID_PUNTO
	    WHERE ATS.DESCRIPCION_SOLICITUD = Cv_NombreTipoSolicitud 
	    AND IDS.ESTADO                  = Cv_EstadoSolicitud
	    GROUP BY IPUNTO.PERSONA_EMPRESA_ROL_ID
	    HAVING SUM(ECR.SALDO) <= 0;

    CURSOR C_GetSolicitudesPreplanif( Cn_IdPer DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                      Cv_NombreTipoSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                      Cv_EstadoSolicitud DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE)
      IS
        SELECT IDS.ID_DETALLE_SOLICITUD, ISERV.ID_SERVICIO, ISERV.USR_CREACION, ISERV.IP_CREACION
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO ISERV
          ON ISERV.ID_SERVICIO = IDS.SERVICIO_ID
        INNER JOIN DB_COMERCIAL.INFO_PUNTO IPUNTO
          ON IPUNTO.ID_PUNTO = ISERV.PUNTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
          ON IPER.ID_PERSONA_ROL = IPUNTO.PERSONA_EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
          ON ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID
        WHERE IPUNTO.PERSONA_EMPRESA_ROL_ID = Cn_IdPer
          AND ATS.DESCRIPCION_SOLICITUD = Cv_NombreTipoSolicitud
          AND IDS.ESTADO = Cv_EstadoSolicitud;
    Lr_GetAdmiSolPlanif C_GetAdmiSolPlanif%ROWTYPE;
    Ln_IdDetSolPlanif NUMBER;
    Pv_EstadoPendiente VARCHAR2(9)   := 'Pendiente';
    Pv_EstadoFinalizada VARCHAR2(10) := 'Finalizada';
    Pv_SolPreplanif VARCHAR2(26)     := 'SOLICITUD PREPLANIFICACION';
    Pv_SolPlanif VARCHAR2(23)        := 'SOLICITUD PLANIFICACION';

  BEGIN
    OPEN C_GetAdmiSolPlanif;
    FETCH C_GetAdmiSolPlanif INTO Lr_GetAdmiSolPlanif;

    FOR I_GetClientesSinDeuda IN C_GetClientesSinDeuda(Pv_SolPreplanif, 
                                                       Pv_EstadoPendiente)
    LOOP
	    FOR I_GetSolPreplanif IN C_GetSolicitudesPreplanif(I_GetClientesSinDeuda.PERSONA_EMPRESA_ROL_ID,
                                                           Pv_SolPreplanif, 
                                                           Pv_EstadoPendiente)
        LOOP
              -- Se finaliza la solicitud de preplanificación
              UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
              SET ESTADO = Pv_EstadoFinalizada
              WHERE ID_DETALLE_SOLICITUD = I_GetSolPreplanif.ID_DETALLE_SOLICITUD;

              --Crear historial de finalización de la solicitud de preplanificación
              INSERT
              INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                (
                  ID_SOLICITUD_HISTORIAL,
                  DETALLE_SOLICITUD_ID,
                  ESTADO,
                  OBSERVACION,
                  USR_CREACION,
                  FE_CREACION,
                  IP_CREACION
                )
                VALUES
                (
                  DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                  I_GetSolPreplanif.ID_DETALLE_SOLICITUD,
                  Pv_EstadoFinalizada,
                  'Se finaliza la solicitud de preplanificación por cancelación de deuda',
                  substr(SYS_CONTEXT('USERENV','HOST'),0,15),
                  SYSDATE,
                  SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                );

                --Crear la solicitud de planificación luego de finalizar la solicitud de preplanificación
                Ln_IdDetSolPlanif := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL;

                INSERT 
                INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD
                  (
                    ID_DETALLE_SOLICITUD,
                    SERVICIO_ID,
                    TIPO_SOLICITUD_ID,
                    USR_CREACION,
                    FE_CREACION,
                    OBSERVACION,
                    ESTADO
                  )
                  VALUES
                  (
                    Ln_IdDetSolPlanif,
                    I_GetSolPreplanif.ID_SERVICIO,
                    Lr_GetAdmiSolPlanif.ID_TIPO_SOLICITUD,
                    I_GetSolPreplanif.USR_CREACION,
                    SYSDATE,
                    'Solicitud creada luego de que el cliente canceló su deuda',
                    'PrePlanificada'
                  );

                --Crear historial de la solicitud de planificación
                INSERT
                INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                  (
                    ID_SOLICITUD_HISTORIAL,
                    DETALLE_SOLICITUD_ID,
                    ESTADO,
                    OBSERVACION,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION
                  )
                  VALUES
                  (
                    DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                    Ln_IdDetSolPlanif,
                    'PrePlanificada',
                    'Se crea solicitud de planificacion por cancelación de deuda',
                    substr(SYS_CONTEXT('USERENV','HOST'),0,15),
                    SYSDATE,
                    SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                  );

                -- Se actualiza el estado del servicio
                UPDATE DB_COMERCIAL.INFO_SERVICIO
                SET ESTADO = 'PrePlanificada'
                WHERE ID_SERVICIO = I_GetSolPreplanif.ID_SERVICIO;

                --Se ingresa el historial por cambio de estado del servicio de Internet
                INSERT
                INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
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
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    I_GetSolPreplanif.ID_SERVICIO,
                    I_GetSolPreplanif.USR_CREACION,
                    SYSDATE,
                    SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15),
                    'PrePlanificada',
                    'Se cambia el estado del servicio, de Pendiente a Preplanificada, por cancelación de deuda.'
                  );
		COMMIT;
      END LOOP;
    END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Pv_MensajeError := 'Error al realizar el proceso de solicitudes de preplanificacion de Pendiente a Finalizada por pago de deuda:  - ' 
			           || SQLCODE || ' -ERROR- ' || SQLERRM;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'COMEK_TRANSACTION.P_CLIENTE_SIN_DEUDA', 
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_CLIENTE_SIN_DEUDA;


PROCEDURE P_NOTIFICA_CANCELACION_DEMOS(pv_mensaje OUT VARCHAR2)
IS

  CURSOR cu_demos_activos(cv_tipo_sol VARCHAR2,cv_estado VARCHAR2)
  IS
    SELECT ids.ID_DETALLE_SOLICITUD,
      ids.SERVICIO_ID,
      (select id_punto from DB_INFRAESTRUCTURA.info_punto where id_punto = (
      select punto_id from DB_INFRAESTRUCTURA.info_servicio where id_servicio = ids.SERVICIO_ID)) as ID_PUNTO,      
      (select login from DB_INFRAESTRUCTURA.info_punto where id_punto = (
      select punto_id from DB_INFRAESTRUCTURA.info_servicio where id_servicio = ids.SERVICIO_ID)) as LOGIN,
      (select descripcion_producto from db_infraestructura.admi_producto where id_producto = (
        select producto_id from db_infraestructura.info_servicio where id_servicio = ids.SERVICIO_ID)) as SERVICIO
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids,
      DB_COMERCIAL.INFO_DETALLE_SOL_HIST idsh
    WHERE ids.ID_DETALLE_SOLICITUD = idsh.DETALLE_SOLICITUD_ID
    AND ids.TIPO_SOLICITUD_ID      =
      (SELECT ats.ID_TIPO_SOLICITUD
      FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
      WHERE ats.DESCRIPCION_SOLICITUD = cv_tipo_sol
      )      
  AND idsh.ID_SOLICITUD_HISTORIAL =
    (SELECT MAX(idsh2.ID_SOLICITUD_HISTORIAL)
    FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST idsh2
    WHERE idsh2.DETALLE_SOLICITUD_ID = ids.ID_DETALLE_SOLICITUD
    AND idsh2.ESTADO NOT IN ('Aprobada','EnProceso')
    )
  AND ids.SERVICIO_ID IS NOT NULL
  AND idsh.estado      = cv_estado;
  
  
  --Se obtiene la duracion del Demo
  CURSOR cu_duracion_demo(cv_caracteristica VARCHAR2,cn_detalle_sol_id NUMBER)
  IS
    SELECT idsc.valor
    FROM DB_INFRAESTRUCTURA.INFO_DETALLE_SOL_CARACT idsc,
      DB_INFRAESTRUCTURA.ADMI_CARACTERISTICA ac
    WHERE idsc.CARACTERISTICA_ID = ac.ID_CARACTERISTICA
    AND ac.ID_CARACTERISTICA     =
      (SELECT ac2.ID_CARACTERISTICA
      FROM DB_INFRAESTRUCTURA.ADMI_CARACTERISTICA ac2
      WHERE ac2.DESCRIPCION_CARACTERISTICA = cv_caracteristica
      )
  AND idsc.detalle_solicitud_id = cn_detalle_sol_id;
  
  --Se obtiene la fecha de creacion de la solicitud de demo
  CURSOR cu_creacion_demo(cv_estado VARCHAR2,cn_detalle_sol_id NUMBER)
  IS
    SELECT idsh2.fe_creacion
    FROM DB_INFRAESTRUCTURA.INFO_DETALLE_SOL_HIST idsh2
    WHERE idsh2.id_solicitud_historial = (
    SELECT max(idsh.id_solicitud_historial)
    FROM DB_INFRAESTRUCTURA.INFO_DETALLE_SOL_HIST idsh
    WHERE idsh.estado             = cv_estado
    AND idsh.DETALLE_SOLICITUD_ID = cn_detalle_sol_id);
    
  -- Se obtienen los datos de la solicitud del proceso masivo
  CURSOR cu_proceso_masivo_cab(cn_proceso_mav_id NUMBER)
  IS
    SELECT ipmc.id_proceso_masivo_cab,
      ipmc.tipo_proceso,
      ipmc.empresa_id,
      ipmc.cantidad_servicios,
      ipmc.SOLICITUD_ID,
      ipmc.estado
    FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB ipmc
    WHERE ipmc.ID_PROCESO_MASIVO_CAB = cn_proceso_mav_id;
    
  -- Se obtienen los datos de la solicitud del proceso masivo
  CURSOR cu_proceso_masivo_det(cn_solicitud_id NUMBER)
  IS
    SELECT ipmd2.id_proceso_masivo_det,
      ipmd2.proceso_masivo_cab_id,
      ipmd2.PUNTO_ID,
      ipmd2.SERVICIO_ID,
      ipmd2.SOLICITUD_ID
    FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET ipmd2
    WHERE ipmd2.ID_PROCESO_MASIVO_DET =
      (SELECT MAX(ipmd.ID_PROCESO_MASIVO_DET)
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET ipmd
      WHERE ipmd.solicitud_id = cn_solicitud_id
      AND ipmd.estado in ('Activo','ExcedioTiempo','ErrorReintento','Cancel','ERROR')
      );
      
    --Se obtiene valor para determinar si se envia notificacion 
    CURSOR cu_valor_caract_x_servicio(cn_solicitud_id NUMBER,cv_caracteristica VARCHAR2)
    IS
    select idsc.VALOR 
    from DB_INFRAESTRUCTURA.INFO_DETALLE_SOL_CARACT idsc,DB_INFRAESTRUCTURA.INFO_DETALLE_SOLICITUD ids
    where idsc.DETALLE_SOLICITUD_ID = ids.ID_DETALLE_SOLICITUD
    and idsc.detalle_solicitud_id = cn_solicitud_id
    and idsc.CARACTERISTICA_ID = (select id_caracteristica from ADMI_CARACTERISTICA ac 
    where ac.DESCRIPCION_CARACTERISTICA = cv_caracteristica);
    
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
     
    
    --Se obtiene los contactos comerciales del punto
    CURSOR C_GetFormaContacto(cv_forma_contacto varchar2,cn_punto_id number,cv_tipo_rol varchar2,cv_rol varchar2,cv_estado varchar2)
    IS
    SELECT
      (SELECT ipfc2.valor
      FROM DB_INFRAESTRUCTURA.info_persona_forma_contacto ipfc2
      WHERE ipfc2.persona_id      in (IPER.persona_id)
      AND ipfc2.forma_contacto_id =
        (SELECT dfc.id_forma_contacto
        FROM DB_INFRAESTRUCTURA.admi_forma_contacto dfc
        WHERE dfc.descripcion_forma_contacto = cv_forma_contacto
        )
      ) valor
    FROM DB_COMERCIAL.INFO_PUNTO_CONTACTO IPC,
      DB_INFRAESTRUCTURA.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_INFRAESTRUCTURA.INFO_EMPRESA_ROL IER,
      DB_INFRAESTRUCTURA.ADMI_ROL AR,
      DB_INFRAESTRUCTURA.ADMI_TIPO_ROL ATR
    WHERE IPC.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND IPER.EMPRESA_ROL_ID          = IER.ID_EMPRESA_ROL
    AND IER.ROL_ID                   = AR.ID_ROL
    AND AR.TIPO_ROL_ID               = ATR.ID_TIPO_ROL
    AND IPC.PUNTO_ID                 = cn_punto_id
    AND ATR.DESCRIPCION_TIPO_ROL     = cv_tipo_rol
    AND AR.DESCRIPCION_ROL           = cv_rol
    AND IPER.ESTADO                  = cv_estado;
    
    
    --Se obtienen el vendedor del servicio
    cursor c_getVendedor(cn_servicio number,cv_formaContacto varchar2)
    is
    select ipfc.valor from DB_COMERCIAL.info_servicio ise,DB_COMERCIAL.info_persona ipe,
    DB_COMERCIAL.info_persona_forma_contacto ipfc
    where ise.usr_vendedor = ipe.login
    and ipe.id_persona = ipfc.persona_id
    and ipfc.id_persona_forma_contacto = (select max(ipfc2.id_persona_forma_contacto)
    from db_comercial.INFO_PERSONA_FORMA_CONTACTO ipfc2 where ipfc2.persona_id = (select max(ipe1.id_persona) 
    from DB_COMERCIAL.info_persona ipe1 where ipe1.login = (select ise1.USR_VENDEDOR from DB_COMERCIAL.info_servicio ise1 where ise1.id_servicio = cn_servicio)) 
    and ipfc2.forma_contacto_id = (select afc2.ID_FORMA_CONTACTO 
    from DB_COMERCIAL.ADMI_FORMA_CONTACTO afc2 where afc2.DESCRIPCION_FORMA_CONTACTO = cv_formaContacto))
    and ise.id_servicio = cn_servicio;
    
    
    --Se obtienen el asesor comercial
    cursor c_getAsesorComercial(cn_solicitud number,cv_formaContacto varchar2)
    is        
    select ipfc.valor from db_comercial.info_persona ipe,db_comercial.info_persona_forma_contacto ipfc
    where ipe.id_persona = ipfc.persona_id
    and ipfc.id_persona_forma_contacto = (select max(ipfc2.id_persona_forma_contacto)
    from db_comercial.INFO_PERSONA_FORMA_CONTACTO ipfc2 where ipfc2.persona_id = (select max(ipe1.id_persona) 
    from db_comercial.info_persona ipe1 where ipe1.login = (select ides.usr_creacion from db_comercial.INFO_DETALLE_SOLICITUD ides 
    where ides.ID_DETALLE_SOLICITUD = cn_solicitud)) 
    and ipfc2.forma_contacto_id = (select afc2.ID_FORMA_CONTACTO 
    from db_comercial.ADMI_FORMA_CONTACTO afc2 where afc2.DESCRIPCION_FORMA_CONTACTO = cv_formaContacto));
        
      
  lv_tipo_solicitud              VARCHAR2(20)   := 'DEMOS';
  lv_estado_pma                  VARCHAR2(20)   := 'Activo';
  lv_estado_solicitud            VARCHAR2(20)   := 'Activa';
  lv_caract_duracion_demo        VARCHAR2(30)   := 'Duracion Demo';
  lv_caract_envio_notif          VARCHAR2(30)   := 'Envio de Notificacion';  
  lv_caract_cancel_demo          VARCHAR2(30)   := 'Cancelacion Demo';
  Lv_Remitente                   VARCHAR2(50)   := 'demos@telconet.ec';  
  Lv_Asunto_Notificacion         VARCHAR2(50)   := 'Su Demo esta proximo a expirar';  
  Lv_parametro_demo              VARCHAR2(100)  := 'PARAMETROS PROYECTO DEMOS';
  Lv_parametro_plantilla         VARCHAR2(100)  := 'PLANTILLA_PROXIMO_A_EXPIRAR';    
  Lv_parametro_tiempo_notificar  VARCHAR2(100)  := 'TIEMPO_PARA_NOTIFICAR_DEMO';  
  lv_formaContacto        varchar2(30)   := 'Correo Electronico';
  lv_tipoRol              varchar2(30)   := 'Contacto';
  lv_rol                  varchar2(30)   := 'Contacto Comercial';  
  Lv_Destinatarios        VARCHAR2(1000) := '';  
  Lv_Plantilla_correo     VARCHAR2(4000) := '';
  lv_correo_vendedor      VARCHAR2(100)  := ''; 
  lv_correo_asesor        VARCHAR2(100)  := '';  
  lv_valor_envio_notif    VARCHAR2(30)   := '';
  ln_duracion_demo        NUMBER         :=  0;  
  ld_fe_creacion_demo     DATE;
  ld_fe_fin_demo          DATE;
  ln_dias_transcurridos   NUMBER;
  ln_dias_diff_demo       NUMBER;
  ln_diferencia_dias_demo NUMBER;
  ln_dias_notificar_demo  NUMBER;    
  lr_proceso_masivo_det cu_proceso_masivo_det%ROWTYPE;
  lr_proceso_masivo_cab cu_proceso_masivo_cab%ROWTYPE;
  
  
BEGIN
  
    --Se obtiene la plantilla para la notificacion
    OPEN C_GetParametro(Lv_parametro_demo,Lv_parametro_plantilla);
    FETCH C_GetParametro INTO Lv_Plantilla_correo;    
    CLOSE C_GetParametro;   
    
    --Se obtiene el numero de dias previos a finalizar el demo
    OPEN C_GetParametro(Lv_parametro_demo,Lv_parametro_tiempo_notificar);
    FETCH C_GetParametro INTO ln_dias_notificar_demo;    
    CLOSE C_GetParametro;       
    
  
  --Se recorren todas las solicitudes de Demo que estan Activas
  FOR i IN cu_demos_activos(lv_tipo_solicitud,lv_estado_solicitud)
  LOOP  
    --Se obtiene la fecha de creacion
    OPEN cu_creacion_demo(lv_estado_solicitud,i.ID_DETALLE_SOLICITUD);
    FETCH cu_creacion_demo INTO ld_fe_creacion_demo;
    CLOSE cu_creacion_demo;
    
    --Se obtiene la duracion del demo
    OPEN cu_duracion_demo(lv_caract_duracion_demo,i.ID_DETALLE_SOLICITUD);
    FETCH cu_duracion_demo INTO ln_duracion_demo;
    CLOSE cu_duracion_demo;
    
    --Se calculan los dias transcurridos del Demo
    ln_dias_transcurridos := TRUNC(sysdate) - ld_fe_creacion_demo;      
    
    --Se calcula fecha fin del Demo
    ld_fe_fin_demo := ld_fe_creacion_demo + ln_duracion_demo;
    
    
    --Se valida si ya han transcurrido el tiempo limite del la solicitud de Demo
    IF(ln_dias_transcurridos > ln_duracion_demo) THEN

      --Se obtiene la informacion del proceso masivo det
      OPEN cu_proceso_masivo_det(i.ID_DETALLE_SOLICITUD);
      FETCH cu_proceso_masivo_det INTO lr_proceso_masivo_det;
      CLOSE cu_proceso_masivo_det;
      
      --Se obtiene la informacion del proceso masivo cab
      OPEN cu_proceso_masivo_cab(lr_proceso_masivo_det.proceso_masivo_cab_id);
      FETCH cu_proceso_masivo_cab INTO lr_proceso_masivo_cab;
      CLOSE cu_proceso_masivo_cab;
      
      
      --Se valida si la cabecera esta en estado Activo para pasarla a Pendiente
      IF(lr_proceso_masivo_cab.estado = 'Activo') THEN
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB ipmc
        SET ipmc.estado                  = 'Pendiente'
        WHERE ipmc.ID_PROCESO_MASIVO_CAB = lr_proceso_masivo_det.proceso_masivo_cab_id;
      END IF;
      
      
      --Actualizo a estado Pendiente el proceso masivo detalle
      UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET ipmd
      SET ipmd.estado                  = 'Pendiente'
      WHERE ipmd.ID_PROCESO_MASIVO_DET = lr_proceso_masivo_det.id_proceso_masivo_det;
            
      --Setear la caracteristica de Cancelacion Demo
      UPDATE DB_INFRAESTRUCTURA.INFO_DETALLE_SOL_CARACT idsc
      SET idsc.valor               = 'S'
      WHERE idsc.CARACTERISTICA_ID =
        (SELECT ac.ID_CARACTERISTICA
        FROM DB_INFRAESTRUCTURA.ADMI_CARACTERISTICA ac
        WHERE ac.DESCRIPCION_CARACTERISTICA = lv_caract_cancel_demo
        )
      AND idsc.DETALLE_SOLICITUD_ID = i.ID_DETALLE_SOLICITUD;
        
    END IF;

    --Se realiza operacion para determinar si la solicitud esta proxima a finalizar
    ln_diferencia_dias_demo := ln_duracion_demo - ln_dias_transcurridos;        
    IF((ln_diferencia_dias_demo <= ln_dias_notificar_demo) AND (ln_duracion_demo > ln_dias_transcurridos)) THEN
    
    --Se obtiene valor para determinar si es necesario registrar la SOL para enviarse la notificacion
    open cu_valor_caract_x_servicio(i.ID_DETALLE_SOLICITUD,lv_caract_envio_notif);
    fetch cu_valor_caract_x_servicio into lv_valor_envio_notif;
    close cu_valor_caract_x_servicio;
    
      IF(lv_valor_envio_notif = 'N') THEN

	Lv_Destinatarios := '';
        --Se obtienen los contactos comerciales del punto
        for j in C_GetFormaContacto(lv_formaContacto,i.ID_PUNTO,lv_tipoRol,lv_rol,lv_estado_pma) loop
        
          Lv_Destinatarios := Lv_Destinatarios || j.valor || ',';
        
        end loop;

        --Se obtiene la forma de contacto del vendedor
        open c_getVendedor(i.SERVICIO_ID,lv_formaContacto);
        fetch c_getVendedor into lv_correo_vendedor;
        close c_getVendedor;      
        
        Lv_Destinatarios := Lv_Destinatarios || lv_correo_vendedor || ',';
        
        
        --Se obtiene la forma de contacto del asesor
        open c_getAsesorComercial(i.ID_DETALLE_SOLICITUD,lv_formaContacto);
        fetch c_getAsesorComercial into lv_correo_asesor;
        close c_getAsesorComercial;       
        
        Lv_Destinatarios := Lv_Destinatarios || lv_correo_asesor || ',';
      
        --Se reemplazan valores en la plantilla envio de correo
        Lv_Plantilla_correo := REPLACE(Lv_Plantilla_correo,'<<parametroLogin>>',i.LOGIN);
        Lv_Plantilla_correo := REPLACE(Lv_Plantilla_correo,'<<parametroServicio>>',i.SERVICIO);      
        Lv_Plantilla_correo := REPLACE(Lv_Plantilla_correo,'<<parametroFechaIni>>',to_char(ld_fe_creacion_demo,'dd/mm/yyyy'));
        Lv_Plantilla_correo := REPLACE(Lv_Plantilla_correo,'<<parametroFechaFin>>',to_char(ld_fe_fin_demo,'dd/mm/yyyy')); 
        Lv_Plantilla_correo := REPLACE(Lv_Plantilla_correo,'<<parametroDias>>',ln_duracion_demo);      
        
        
        --Se envia la notificacion el cliente
        UTL_MAIL.SEND (sender     => Lv_Remitente, 
                       recipients => Lv_Destinatarios, 
                       subject    => Lv_Asunto_Notificacion, 
                       MESSAGE    => Lv_Plantilla_correo, 
                       mime_type  => 'text/html; charset=UTF-8');
        
        
        --Se setea caracteristica a 'S' para determinar que la notificacion ya fue enviada
        UPDATE DB_INFRAESTRUCTURA.INFO_DETALLE_SOL_CARACT idsc
        SET idsc.valor               = 'S'
        WHERE idsc.CARACTERISTICA_ID =
          (SELECT ac.ID_CARACTERISTICA
          FROM DB_INFRAESTRUCTURA.
          ADMI_CARACTERISTICA ac
          WHERE ac.DESCRIPCION_CARACTERISTICA = lv_caract_envio_notif
          )
         AND idsc.DETALLE_SOLICITUD_ID = i.ID_DETALLE_SOLICITUD;    

      END IF;
        
    END IF;
    
  END LOOP;
  
  COMMIT;
  
  PV_MENSAJE := 'Proceso realizado con exito!';
  
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  PV_MENSAJE := 'Error: '||SUBSTR(sqlerrm,1,200);

END P_NOTIFICA_CANCELACION_DEMOS;

  FUNCTION F_GENERA_USUARIO(Pv_IdPersona          IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                            Pv_InfoTabla        IN VARCHAR2,
                            Pv_PrefijoEmpresa   IN VARCHAR2,
                            Pv_CaracUsuario     IN VARCHAR2,
                            Pv_NombreTecnico    IN VARCHAR2)
    RETURN VARCHAR2
  IS

    CURSOR C_ObtieneNombres (Cn_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE) IS
      SELECT NOMBRES, APELLIDOS, RAZON_SOCIAL
        FROM DB_COMERCIAL.INFO_PERSONA
       WHERE ID_PERSONA = CN_IdPersona;
    Lr_ObtieneNombres C_ObtieneNombres%ROWTYPE;
    Lv_PrimerNombre    DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE;
    Lv_SegundoNombre   DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE;
    Lv_PrimerApellido  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE;
    Lv_SegundoApellido DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE;
    Ln_NumeroBase      NUMBER := 15;
    Ln_LimiteBucle     NUMBER := 999;
    Lv_LetraPrimNombre VARCHAR2(1);
    Lv_LetraSeguNombre VARCHAR2(2);
    Lv_LetraSeguApelli VARCHAR2(1);
    Lv_Usuario         VARCHAR2(20);
    Lv_UsuarioBucle    VARCHAR2(20);
    Ln_Index           NUMBER := 0;
    Lv_PrimPrefijo     VARCHAR2(1) := NVL(SUBSTR(Pv_PrefijoEmpresa, 1, 1), 'T');
    Lv_SegPrefijo      VARCHAR2(1) := NVL(SUBSTR(Pv_PrefijoEmpresa, 2, 1), 'N');

    --FUNCIÓN QUE OBTIENE EL NÚMERO DE INSTANCIAS EXISTENTES PARA UN USUARIO EN UNA BÚSQUEDA
    FUNCTION F_OBTIENE_INSTANCIAS(Pv_InfoTabla IN VARCHAR2,
                                  Pv_Usuario   IN VARCHAR2)
    RETURN NUMBER
    IS
    --SE AGREGAN CURSORES DE DONDE OBTENER UN USUARIO ÚNICO.
    --CURSOR PARA INFO_PERSONA
    CURSOR C_InfoPersona (Cv_Login VARCHAR2) IS
        SELECT COUNT (*) AS TOTAL
          FROM DB_COMERCIAL.INFO_PERSONA
         WHERE LOGIN = Cv_Login;
    Ln_Instancias  NUMBER := 0;
    
    CURSOR C_InfoServicioProdCaract (Cv_Valor         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
                                     Cv_DescCaract    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                     Cv_NombreTecnico DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
                                     Cv_EstadoActivo  VARCHAR2) IS
        SELECT COUNT(*)
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC,
               DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
               DB_COMERCIAL.ADMI_PRODUCTO AP,
               DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
         WHERE AC.DESCRIPCION_CARACTERISTICA = Cv_DescCaract
            AND AC.ESTADO = Cv_EstadoActivo
            AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
            AND APC.ESTADO = Cv_EstadoActivo
            AND AP.NOMBRE_TECNICO = Cv_NombreTecnico
            AND AP.ESTADO = Cv_EstadoActivo
            AND APC.PRODUCTO_ID = AP.ID_PRODUCTO
            AND APC.ID_PRODUCTO_CARACTERISITICA = ISPC.PRODUCTO_CARACTERISITICA_ID
            AND VALOR = Cv_Valor;
    BEGIN
        IF Pv_InfoTabla = 'INFO_PERSONA' THEN
            OPEN  C_InfoPersona (Pv_Usuario);
            FETCH C_InfoPersona INTO Ln_Instancias;
            CLOSE C_InfoPersona;
        ELSIF Pv_InfoTabla = 'INFO_SERVICIO_PROD_CARACT' THEN
            OPEN  C_InfoServicioProdCaract (Pv_Usuario, Pv_CaracUsuario, Pv_NombreTecnico, 'Activo');
            FETCH C_InfoServicioProdCaract INTO Ln_Instancias;
            CLOSE C_InfoServicioProdCaract;
        END IF;
        RETURN Ln_Instancias;
    END F_OBTIENE_INSTANCIAS;

    /**
    * Funcion que verifica que el nombre de usuario no coincida con una de las expresiones regexp
    * no permitidas almacenada en la base de datos
    *
    * PARAMETROS:
    * @Param v_nombre_usuario    Nombre de Usuario a validar
    */
    FUNCTION F_VALIDA_NOMBRE_USUARIO(v_nombre_usuario IN VARCHAR2)
    RETURN NUMBER
    IS
        v_resultado NUMBER;
        v_id_parametro DB_GENERAL.ADMI_PARAMETRO_CAB.ID_PARAMETRO%TYPE;
    BEGIN
        SELECT id_parametro into v_id_parametro 
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
        WHERE NOMBRE_PARAMETRO = 'NOMBREUSUARIO_SUBCADENAS_NO_PERMITIDAS';
        
        BEGIN
            SELECT 1
            INTO v_resultado
            FROM DB_GENERAL.ADMI_PARAMETRO_DET det
            WHERE parametro_id = v_id_parametro
            AND REGEXP_LIKE(v_nombre_usuario, valor1)
            AND ROWNUM =1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_resultado := 0;
        END;
        
        v_resultado := NVL(v_resultado, 0);
        IF v_resultado = 0 THEN
            return 1;
        ELSE
            return 0;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        return 0;
    END F_VALIDA_NOMBRE_USUARIO;
    
    
  BEGIN
    OPEN C_ObtieneNombres (Pv_IdPersona);
    FETCH C_ObtieneNombres INTO Lr_ObtieneNombres;
    CLOSE C_ObtieneNombres;

    IF Lr_ObtieneNombres.APELLIDOS IS NOT NULL THEN
        --Se obtiene la información de la persona
        Lv_PrimerNombre    := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(
                                TRIM( REPLACE( REPLACE( REPLACE(
                                TRIM( SUBSTR(Lr_ObtieneNombres.NOMBRES,1,99) ),
                                     Chr(9), ' '), Chr(10), ' '), Chr(13), ' ') ) );
        Ln_Index         :=     INSTR(Lv_PrimerNombre,' ');
        IF Ln_Index > 0 THEN
            Lv_SegundoNombre   := SUBSTR(Lv_PrimerNombre, Ln_Index);
        END IF;
        Lv_PrimerNombre    := REPLACE(Lv_PrimerNombre, Lv_SegundoNombre, '');
        Lv_SegundoNombre   := TRIM(Lv_SegundoNombre);
        Lv_PrimerApellido  := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(
                                TRIM( REPLACE( REPLACE( REPLACE(
                                TRIM( SUBSTR(Lr_ObtieneNombres.APELLIDOS,1,99) ),
                                     Chr(9), ' '), Chr(10), ' '), Chr(13), ' ') ) );
        Ln_Index := 0;
        Ln_Index         :=     INSTR(Lv_PrimerApellido,' ');
        IF Ln_Index > 0 THEN
            Lv_SegundoApellido   := SUBSTR(Lv_PrimerApellido, Ln_Index);
        END IF;
        Lv_PrimerApellido    := REPLACE(Lv_PrimerApellido, Lv_SegundoApellido, '');
        Lv_SegundoApellido   := TRIM(Lv_SegundoApellido);

    ELSIF Lr_ObtieneNombres.RAZON_SOCIAL IS NOT NULL THEN
        Lv_PrimerApellido := DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(
                                TRIM( REPLACE( REPLACE( REPLACE(
                                TRIM( SUBSTR(Lr_ObtieneNombres.RAZON_SOCIAL, 1, 99) ),
                                     Chr(9), ' '), Chr(10), ' '), Chr(13), ' ') ) );
        Lv_PrimerApellido := REPLACE(Lv_PrimerApellido,' ', '');
    ELSE
        RETURN '';
    END IF;

    --Primer intento primera letra del primer nombre + primer apellido
    Lv_PrimerApellido := SUBSTR(Lv_PrimerApellido, 1, Ln_NumeroBase);
    Lv_LetraPrimNombre := NVL(SUBSTR(Lv_PrimerNombre, 1, 1), Lv_PrimPrefijo);
    Lv_Usuario := LOWER (Lv_LetraPrimNombre || Lv_PrimerApellido);
    
    IF F_VALIDA_NOMBRE_USUARIO(Lv_Usuario) > 0 
    AND F_OBTIENE_INSTANCIAS(Pv_InfoTabla,Lv_Usuario) = 0 
    THEN
      RETURN Lv_Usuario;
    END IF;
    
    ----------------------------------------------------------------------------

    --Segundo intento: Letra Primer nombre + Letra Segundo Nombre + Apellido
    Lv_LetraSeguNombre := NVL(SUBSTR(Lv_SegundoNombre, 1, 1), Lv_SegPrefijo);
    Lv_Usuario := LOWER (Lv_LetraPrimNombre || Lv_LetraSeguNombre || Lv_PrimerApellido);

    

    IF F_VALIDA_NOMBRE_USUARIO(Lv_Usuario) > 0 
    AND F_OBTIENE_INSTANCIAS(Pv_InfoTabla,Lv_Usuario) = 0 
    THEN
      RETURN Lv_Usuario;
    END IF;

    --Tercer Intento: Letra primer nombre + letra segundo nombre + apellido + letra segundo apellido.
    Lv_LetraSeguApelli := NVL(SUBSTR(Lv_SegundoApellido, 1, 1), 'X');
    Lv_Usuario :=  LOWER(Lv_Usuario || Lv_LetraSeguApelli);
    
    IF F_VALIDA_NOMBRE_USUARIO(Lv_Usuario) > 0 
    AND F_OBTIENE_INSTANCIAS(Pv_InfoTabla,Lv_Usuario) = 0 
    THEN
      RETURN Lv_Usuario;
    END IF;

    /*
      # Intentos intermedios
      - En estos intentos modificamos el nombre de usuario 
        para que cumpla las condiciones establecidas
    */
    -- 1
    Lv_PrimerApellido := SUBSTR(Lv_PrimerApellido, 1, Ln_NumeroBase);
    Lv_LetraPrimNombre := NVL(SUBSTR(Lv_PrimerNombre, 1, 1), Lv_PrimPrefijo);
    Lv_Usuario := LOWER (Lv_LetraPrimNombre || '_' || Lv_PrimerApellido);
    IF F_VALIDA_NOMBRE_USUARIO(Lv_Usuario) > 0 
    AND F_OBTIENE_INSTANCIAS(Pv_InfoTabla,Lv_Usuario) = 0 
    THEN
      RETURN Lv_Usuario;
    END IF;
    
    -- 2
    Lv_LetraSeguNombre := NVL(SUBSTR(Lv_SegundoNombre, 1, 1), Lv_SegPrefijo);
    Lv_Usuario := LOWER (Lv_LetraPrimNombre || '_' || Lv_LetraSeguNombre || '_' || Lv_PrimerApellido);


    IF F_VALIDA_NOMBRE_USUARIO(Lv_Usuario) > 0 
    AND F_OBTIENE_INSTANCIAS(Pv_InfoTabla,Lv_Usuario) = 0 
    THEN
      RETURN Lv_Usuario;
    END IF;
    
    -- 3
    Lv_LetraSeguApelli := NVL(SUBSTR(Lv_SegundoApellido, 1, 1), 'X');
    Lv_Usuario :=  LOWER(Lv_Usuario || '_' || Lv_LetraSeguApelli);
    
    IF F_VALIDA_NOMBRE_USUARIO(Lv_Usuario) > 0 
    AND F_OBTIENE_INSTANCIAS(Pv_InfoTabla,Lv_Usuario) = 0 
    THEN
      RETURN Lv_Usuario;
    END IF;
    
    --------------------------------------------------------

    --Cuarto intento: Se agrega un secuencial al final.
    Lv_Usuario := LOWER (Lv_LetraPrimNombre || Lv_LetraSeguNombre || Lv_PrimerApellido);
    Lv_LetraSeguApelli := NVL(SUBSTR(Lv_SegundoApellido, 1, 1), 'X');
    Lv_Usuario :=  LOWER(Lv_Usuario || Lv_LetraSeguApelli);
    
    /*
      - Si el nombre de usuario sigue generando conflictos procedemos 
        a generar un nombre probablemente no conflictivo
    */
    IF F_VALIDA_NOMBRE_USUARIO(Lv_Usuario) > 0 THEN
        Lv_Usuario := LOWER (Lv_LetraPrimNombre || '_' || Lv_LetraSeguNombre || '_' || Lv_PrimerApellido);
    END IF;
    
    FOR Ln_Indice IN 1..Ln_LimiteBucle
    LOOP
        Lv_UsuarioBucle := Lv_Usuario || Ln_Indice;
        IF F_OBTIENE_INSTANCIAS(Pv_InfoTabla,Lv_UsuarioBucle) = 0 THEN
            RETURN Lv_UsuarioBucle;
        END IF;
    END LOOP;
    RETURN '';
  END F_GENERA_USUARIO;

--
PROCEDURE P_FINALIZAR_SOL_MASIVA_CAB(
    Pv_MsjError OUT VARCHAR2)
AS
  CURSOR C_GetSolsMasivaCab
  IS
    SELECT DISTINCT SOL.ID_DETALLE_SOLICITUD
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL
    INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL
    ON SOL.TIPO_SOLICITUD_ID              = TIPO_SOL.ID_TIPO_SOLICITUD
    WHERE TIPO_SOL.DESCRIPCION_SOLICITUD IN ('CAMBIO PLAN','CANCELACION')
    AND TIPO_SOL.ESTADO                   = 'Activo'
    AND SOL.ESTADO                        = 'Pendiente'
    AND SOL.SERVICIO_ID                  IS NULL
    AND 0                                 =
      (SELECT COUNT(*) AS SOLICITUDES_PENDIENTES
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOLICITUD
      INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO
      ON SOLICITUD.TIPO_SOLICITUD_ID = TIPO.ID_TIPO_SOLICITUD
      INNER JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT
      ON SOLICITUD.ID_DETALLE_SOLICITUD = SOL_CARACT.DETALLE_SOLICITUD_ID
      INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT_REF
      ON SOL_CARACT.CARACTERISTICA_ID                                   = CARACT_REF.ID_CARACTERISTICA
      WHERE SOLICITUD.TIPO_SOLICITUD_ID                                 = TIPO.ID_TIPO_SOLICITUD
      AND TIPO.DESCRIPCION_SOLICITUD                                   IN ('CAMBIO PLAN','CANCELACION')
      AND CARACT_REF.DESCRIPCION_CARACTERISTICA                         = 'Referencia Solicitud'
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(SOL_CARACT.VALOR,'^\d+')),0) = SOL.ID_DETALLE_SOLICITUD
      AND SOLICITUD.ESTADO NOT                                         IN ('Finalizada','Rechazada')
      )
    AND EXISTS
      (SELECT ID_DETALLE_SOLICITUD
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SOL_CARACT
      WHERE COALESCE(TO_NUMBER(REGEXP_SUBSTR(SOL_CARACT.VALOR,'^\d+')),0) = SOL.ID_DETALLE_SOLICITUD
      );
  --
BEGIN
  FOR I_GetSolsMasivaCab IN C_GetSolsMasivaCab
  LOOP
    INSERT
    INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
      (
        ID_SOLICITUD_HISTORIAL,
        DETALLE_SOLICITUD_ID,
        ESTADO,
        FE_CREACION,
        USR_CREACION,
        IP_CREACION,
        OBSERVACION
      )
      VALUES
      (
        DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
        I_GetSolsMasivaCab.ID_DETALLE_SOLICITUD,
        'Finalizada',
        CURRENT_TIMESTAMP,
        'regula_cab_pma',
        '127.0.0.1',
        'Se Finaliza Solicitud de Proceso Masivo'
      );
    UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    SET ESTADO                 = 'Finalizada'
    WHERE ID_DETALLE_SOLICITUD = I_GetSolsMasivaCab.ID_DETALLE_SOLICITUD;
    COMMIT;
  END LOOP;
  --
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  Pv_MsjError := SQLCODE || ' -ERROR- ' || SQLERRM ;
END P_FINALIZAR_SOL_MASIVA_CAB;


  PROCEDURE P_SET_ESTADO_INFO_SERV_CARAC(Pn_IdServicio         IN  NUMBER,
                                         Pv_DescripcionCaract  IN  VARCHAR2,
                                         Pv_NuevoEstado        IN  VARCHAR2,
                                         Pv_UsrModifica        IN  VARCHAR2,
                                         Pv_Mensaje            OUT VARCHAR2)
  AS
  BEGIN
    UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
    SET ESTADO      = Pv_NuevoEstado,
        FE_ULT_MOD  = SYSDATE,
        USR_ULT_MOD = Pv_UsrModifica
    WHERE ID_SERVICIO_PROD_CARACT IN (SELECT ISC.ID_SERVICIO_PROD_CARACT
                                     FROM  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISC
                                     JOIN  DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISC.PRODUCTO_CARACTERISITICA_ID
                                     JOIN  DB_COMERCIAL.ADMI_CARACTERISTICA AC  ON AC.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
                                     WHERE ISC.SERVICIO_ID = Pn_IdServicio 
                                     AND   AC.DESCRIPCION_CARACTERISTICA = Pv_DescripcionCaract
                                     AND   ISC.ESTADO = 'Activo'
                                     AND   AC.ESTADO  = 'Activo');
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Error en  COMEK_TRANSACTION.P_SET_ESTADO_INFO_SERV_CARAC ServId: ' || Pn_IdServicio
                 || 'Error ' || SQLCODE || ' -ERROR- ' || SQLERRM
                 || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_SET_ESTADO_INFO_SERV_CARAC;


    PROCEDURE P_INSERT_SERVICIO_HISTORIAL(
        Pr_servicioHistorial IN INFO_SERVICIO_HISTORIAL%ROWTYPE,
        Lv_MensaError OUT VARCHAR2)
    AS
    BEGIN
      INSERT
      INTO INFO_SERVICIO_HISTORIAL
        (
          ID_SERVICIO_HISTORIAL,
          SERVICIO_ID,
          USR_CREACION,
          FE_CREACION,
          IP_CREACION,
          ESTADO,
          MOTIVO_ID,
          OBSERVACION,
          ACCION
        )
        VALUES
        (
          SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
          Pr_servicioHistorial.SERVICIO_ID,
          Pr_servicioHistorial.USR_CREACION,
          NVL(Pr_servicioHistorial.FE_CREACION, SYSDATE),
          Pr_servicioHistorial.IP_CREACION,
          Pr_servicioHistorial.ESTADO,
          Pr_servicioHistorial.MOTIVO_ID,
          Pr_servicioHistorial.OBSERVACION,
          Pr_servicioHistorial.ACCION
        );
    EXCEPTION
    WHEN OTHERS THEN
      Lv_MensaError := 'COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL '||SQLERRM;
    END P_INSERT_SERVICIO_HISTORIAL;


  PROCEDURE P_UPDATE_INFO_DETALLE_SOL(Pr_InfoDetalleSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                      Pv_Mensaje              OUT VARCHAR2)
  AS
  BEGIN
    UPDATE  DB_COMERCIAL.INFO_DETALLE_SOLICITUD
        SET PRECIO_DESCUENTO      = NVL(Pr_InfoDetalleSolicitud.PRECIO_DESCUENTO,PRECIO_DESCUENTO),
            PORCENTAJE_DESCUENTO  = NVL(Pr_InfoDetalleSolicitud.PORCENTAJE_DESCUENTO,PORCENTAJE_DESCUENTO),
            TIPO_DOCUMENTO        = NVL(Pr_InfoDetalleSolicitud.TIPO_DOCUMENTO,TIPO_DOCUMENTO),
            ESTADO                = NVL(Pr_InfoDetalleSolicitud.ESTADO,ESTADO)
      WHERE ID_DETALLE_SOLICITUD  = Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD;
  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Ocurrio un error al actualizar el registro ' || Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD
                 || ' de DB_COMERCIAL.INFO_DETALLE_SOLICITUD. ' || 'Error ' || SQLCODE || ' -ERROR- ' || SQLERRM
                 || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_UPDATE_INFO_DETALLE_SOL;   


  PROCEDURE P_GENERAR_TOKEN_NETVOICE (Pv_Mensaje OUT VARCHAR2,
                                      Pv_token   OUT CLOB) 
    IS


    CURSOR C_Parametros(Cv_parametro VARCHAR2)
      IS
        SELECT PD.valor1,
          PD.valor2,
          PD.valor3
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB PC,
          DB_GENERAL.ADMI_PARAMETRO_DET PD
        WHERE PD.PARAMETRO_ID   = PC.ID_PARAMETRO
        AND PC.NOMBRE_PARAMETRO = 'PARAMETROS_LINEAS_TELEFONIA'
        AND PD.DESCRIPCION      = Cv_parametro
        AND PC.ESTADO           = 'Activo';
        
    Lv_Metodo        VARCHAR2(10);
    Lv_Version       VARCHAR2(10);
    Lv_Aplicacion    VARCHAR2(50);
    Ln_LongitudReq   NUMBER;
    Ln_LongitudIdeal NUMBER:= 32767;
    Ln_Offset        NUMBER:= 1;
    Ln_Buffer        VARCHAR2(2000);
    Ln_Amount        NUMBER := 2000;
    Lc_Json          CLOB;
    Lhttp_Request    UTL_HTTP.req;
    Lhttp_Response   UTL_HTTP.resp;
    data             VARCHAR2(4000); 
    
    Pv_UserName VARCHAR2(100);
    Pv_Password VARCHAR2(100);
    Pv_URL      VARCHAR2(100);


    BEGIN
    
      OPEN C_Parametros ('WEBSERVICE_GET_TOKEN');
      FETCH C_Parametros INTO Pv_UserName, Pv_Password, Pv_URL;
      CLOSE C_Parametros;

      Lv_Metodo       := 'POST';
      Lv_Version      := ' HTTP/1.1';
      Lv_Aplicacion   := 'application/json';

      Lc_Json         := '{"usuario":"'||Pv_UserName||'","password":"'||Pv_Password||'"}}';
    
      Lhttp_Request := UTL_HTTP.begin_request (Pv_URL,
                                               Lv_Metodo,
                                               Lv_Version);

      UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', Lv_Aplicacion);
      UTL_HTTP.set_header(Lhttp_Request, 'Accept', Lv_Aplicacion);

      Ln_LongitudReq  := DBMS_LOB.getlength(Lc_Json);

      IF Ln_LongitudReq <= Ln_LongitudIdeal THEN
        UTL_HTTP.set_header(Lhttp_Request, 'Content-Length', LENGTH(Lc_Json));
        UTL_HTTP.write_text(Lhttp_Request, Lc_Json);
      ELSE
        UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
        WHILE (Ln_Offset < Ln_LongitudReq) LOOP
          DBMS_LOB.READ(Lc_Json, 
                        Ln_Amount,
                        Ln_Offset,
                        Ln_Buffer);
          UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
          Ln_Offset := Ln_Offset + Ln_Amount;
        END LOOP;
      END IF;

      Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
      utl_http.read_text(Lhttp_Response, data);                         
      apex_json.parse (data);

      Pv_token  :=apex_json.get_varchar2('token');

      if Pv_token is null then
        Pv_Mensaje  :=apex_json.get_varchar2('message');
      else
        Pv_Mensaje:= 'OK';
      end if;      

      UTL_HTTP.end_response(Lhttp_Response);

    EXCEPTION
      WHEN OTHERS THEN
          Pv_Mensaje := 'COMEK_TRANSACTION.ERROR P_GENERAR_TOKEN: ' ||SQLERRM ;
          DBMS_OUTPUT.PUT(Pv_Mensaje);    

  END P_GENERAR_TOKEN_NETVOICE;
  
  

/**
 * Método que consume el WebService de Netvoice para obtener información y poder procesarla. 
 * Since 1.0
 *
 * Se mejora el almacenamiento de la respuesta al WebService luego de realizar la petición, utilizando una variable de tipo CLOB.
 * @author Hector Lozano <hlozano@telconet.ec>
 * @version 1.1 27/12/2019.
 *
 * Se agrega el rango de consumo a la facturacion
 * @author Gustavo Narea <gnarea@telconet.ec>
 * @version 1.2 01/09/2022.
 */

PROCEDURE P_CONSUMO_WS_NETVOICE( Pv_Empresa IN VARCHAR2,
                                 Pv_Mensaje OUT VARCHAR2)
IS
   --Consulto los servicios en estado Activo con la caracteristica ID CUENTA NETVOICE
  CURSOR C_servicio_netvoice(Cv_valor VARCHAR2)
  IS
    SELECT S.ID_SERVICIO,
      S.PUNTO_FACTURACION_ID,
      S.PUNTO_ID,
      PU.LOGIN,
      (SELECT listagg(spc.VALOR,', ') within GROUP(
        ORDER BY spc.VALOR)
        FROM INFO_SERVICIO_PROD_CARACT spc,
          ADMI_PRODUCTO_CARACTERISTICA PC,
          ADMI_CARACTERISTICA c
        WHERE spc.PRODUCTO_CARACTERISITICA_ID = PC.ID_PRODUCTO_CARACTERISITICA
        AND PC.CARACTERISTICA_ID              = c.ID_CARACTERISTICA
        AND c.DESCRIPCION_CARACTERISTICA      = 'NUMERO'
        and spc.ESTADO                        in ('Activo','In-Corte')
        AND SPC.servicio_id                   = S.ID_SERVICIO) NUMEROS
    FROM INFO_SERVICIO S,
      INFO_PUNTO PU,
      ADMI_PRODUCTO P,
      INFO_SERVICIO_PROD_CARACT SPC,
      ADMI_PRODUCTO_CARACTERISTICA PC,
      ADMI_CARACTERISTICA C
    WHERE S.ID_SERVICIO                = SPC.SERVICIO_ID
    AND PU.ID_PUNTO                    = S.PUNTO_ID
    AND S.ESTADO                       = 'Activo'
    AND SPC.ESTADO                     = 'Activo'
    AND S.PRODUCTO_ID                  = P.ID_PRODUCTO
    AND PC.ID_PRODUCTO_CARACTERISITICA = SPC.PRODUCTO_CARACTERISITICA_ID
    AND C.ID_CARACTERISTICA            = PC.CARACTERISTICA_ID
    AND C.DESCRIPCION_CARACTERISTICA   = 'ID CUENTA NETVOICE'
    AND P.NOMBRE_TECNICO               = 'TELEFONIA_NETVOICE'
    AND SPC.VALOR                      = Cv_valor;
  --
  CURSOR C_Parametros(Cv_parametro VARCHAR2)
  IS
    SELECT PD.valor1,
      PD.valor2,
      PD.valor3
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PC,
      DB_GENERAL.ADMI_PARAMETRO_DET PD
    WHERE PD.PARAMETRO_ID   = PC.ID_PARAMETRO
    AND PC.NOMBRE_PARAMETRO = 'PARAMETROS_LINEAS_TELEFONIA'
    AND PD.DESCRIPCION      = Cv_parametro
    AND PC.ESTADO = 'Activo';

  CURSOR C_Parametros_valor1(Cv_parametro VARCHAR2)
  IS
    SELECT PD.valor1
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PC,
      DB_GENERAL.ADMI_PARAMETRO_DET PD
    WHERE PD.PARAMETRO_ID   = PC.ID_PARAMETRO
    AND PC.NOMBRE_PARAMETRO = 'PARAMETROS_LINEAS_TELEFONIA'
    AND PD.DESCRIPCION      = Cv_parametro
    AND PC.ESTADO = 'Activo'
    AND PD.ESTADO = 'Activo';

  CURSOR C_NombreProductoDeServicio(Cn_idServicio NUMBER)
  IS
    SELECT ADPR.DESCRIPCION_PRODUCTO
    FROM DB_COMERCIAL.INFO_SERVICIO INSE
    INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO ADPR ON INSE.PRODUCTO_ID = ADPR.ID_PRODUCTO
    WHERE INSE.ID_SERVICIO = Cn_idServicio;
  
  --
  Lv_Metodo        VARCHAR2(10);
  Lv_Version       VARCHAR2(10);
  Lv_Aplicacion    VARCHAR2(50);
  Ln_LongitudReq   NUMBER;
  Ln_LongitudIdeal NUMBER:= 32767;
  Ln_Offset        NUMBER:= 1;
  Ln_Buffer        VARCHAR2(2000);
  Ln_Amount        NUMBER := 2000;
  Lv_Json          VARCHAR2(32767);
  Lhttp_Request UTL_HTTP.req;
  Lhttp_Response UTL_HTTP.resp;
  data     VARCHAR2(32767);
  Lv_error VARCHAR2(500);
  Ln_total NUMBER;
  j apex_json.t_values;
  Ln_cabProceso NUMBER;
  Lr_servicioHistorial INFO_SERVICIO_HISTORIAL%ROWTYPE;
  Ex_noToken      EXCEPTION;
  Ex_errorService EXCEPTION;
  Lv_MensajeError VARCHAR2(2000);
  Lv_user         VARCHAR2(1000);
  Lv_clave        VARCHAR2(1000);
  Lv_url          VARCHAR2(1000);
  Lv_StatusToken  VARCHAR2(1000);
  Lv_Message      VARCHAR2(1000);
  Ln_procesoDetalle NUMBER;
  --
  Lv_token  clob;
  Lv_mensaje clob;
  --
  Lv_cuentaNetvoice     VARCHAR2(10);
  Lv_detalleFacturacion VARCHAR2(3000);
  Lf_valor              FLOAT;
  Lv_fechafin           VARCHAR2(30);
  Lv_noProcesadas       VARCHAR2(3000);
  Lv_numeros            VARCHAR2(3000);
  Ln_servicio           NUMBER;
  Ln_punto              NUMBER;
  Ln_puntoFact          NUMBER;
  Lv_login              VARCHAR2(100);
  Ln_mes                number;
  Ln_anio               number;
  Lc_Data               CLOB;
  Lv_ParamRangoConsumo  VARCHAR2(100);
  Lv_ProdParametrizado  VARCHAR2(100);
  Lv_RangoConsumo       VARCHAR2(100);
  Lv_FechaInicial       VARCHAR2(100);
  Lv_FechaFinal         VARCHAR2(100);
  Lv_NombreProducto     VARCHAR2(100);
  Ld_FechaInicial       DATE;
  Ld_FechaFinal         DATE;
  Lv_ParamFechaParametrizada VARCHAR2(100);
  Lv_FechaStringInicial       VARCHAR2(100);
  Lv_FechaStringFinal         VARCHAR2(100);
  Lv_FormatoFechaBase         VARCHAR2(100);
  
  --
BEGIN

  P_GENERAR_TOKEN_NETVOICE(Lv_mensaje, Lv_token);

  if Lv_mensaje != 'OK' then
    RAISE  Ex_noToken;
  end if;

  Ln_mes  := EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE,-1));
  Ln_anio := EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE,-1));
  --
  -- Inicializamos la variable Lc_Data.
  DBMS_LOB.createtemporary(Lc_Data, FALSE);
  --
  --obtener los parametros
  OPEN C_Parametros ('WEBSERVICE_FACTURACION');
  FETCH C_Parametros INTO Lv_user, Lv_clave, Lv_url;
  CLOSE C_Parametros;

  --obtener la fecha parametrizada de rango de consumo
  OPEN C_Parametros_valor1 ('PARAM_RANGO_CONSUMO');
  FETCH C_Parametros_valor1 INTO Lv_ParamRangoConsumo;
  CLOSE C_Parametros_valor1;

  OPEN C_Parametros_valor1 ('PARAM_FECHA_CONSUMO_WS');
  FETCH C_Parametros_valor1 INTO Lv_ParamFechaParametrizada;
  CLOSE C_Parametros_valor1;

  OPEN C_Parametros_valor1 ('PARAM_FORMATO_FECHA_BASE');
  FETCH C_Parametros_valor1 INTO Lv_FormatoFechaBase;
  CLOSE C_Parametros_valor1;

  --Procedo a solicitar el request y recibo la informacion
  Lv_Metodo     := 'POST';
  Lv_Version    := ' HTTP/1.1';
  Lv_Aplicacion := 'application/json';
  Lv_Json       := '{ "data": { "anio": "'||Ln_anio ||'", "mes": "'||Ln_mes||'", "origen": "'||Pv_Empresa||
                    '"  },  "op"     : "preprocesado",  "user"   : "usrtelco", "ip"     : "127.0.0.1"}';


  --
  Lhttp_Request := UTL_HTTP.begin_request (Lv_url, Lv_Metodo, Lv_Version);
  --
  UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', Lv_Aplicacion);
  UTL_HTTP.set_header(Lhttp_Request, 'Accept', Lv_Aplicacion);
  UTL_HTTP.set_header(Lhttp_Request, 'Authorization', Lv_token);
  --
  Ln_LongitudReq := DBMS_LOB.getlength(Lv_Json);
  --
  IF Ln_LongitudReq <= Ln_LongitudIdeal THEN
    UTL_HTTP.set_header(Lhttp_Request, 'Content-Length', LENGTH(Lv_Json));
    UTL_HTTP.write_text(Lhttp_Request, Lv_Json);
  ELSE
    UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
    WHILE (Ln_Offset < Ln_LongitudReq)
    LOOP
      DBMS_LOB.READ(Lv_Json, Ln_Amount, Ln_Offset, Ln_Buffer);
      UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
      Ln_Offset := Ln_Offset + Ln_Amount;
    END LOOP;
  END IF;
  --
  Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);

  BEGIN
    LOOP
      UTL_HTTP.read_text(Lhttp_Response, data, 32766);
      DBMS_LOB.writeappend (Lc_Data, LENGTH(data), data);
    END LOOP;
  EXCEPTION
  WHEN UTL_HTTP.end_of_body THEN
    UTL_HTTP.end_response(Lhttp_Response);
  END;
  --
  apex_json.parse (j, Lc_Data);

  --obtengo el total de los registros
  Ln_total := apex_json.get_count(p_path=>'datarespuesta',p_values=>j);

  if Ln_total = 0 then
    Lv_mensaje := apex_json.get_varchar2(p_path=>'msgerroruser',p_values=>j) || ' Código auditoria: ' ||apex_json.get_varchar2(p_path=>'codigoauditoria',p_values=>j);
    RAISE  Ex_errorService;
  end if;  

  --recorro y voy actualizando por cada uno
  FOR i IN 1..Ln_total
  LOOP

    Lv_cuentaNetvoice := apex_json.get_varchar2(p_path=>'datarespuesta[%d].idcuentanetvoice',p0=> i,p_values=>j);
    Lv_detalleFacturacion := apex_json.get_varchar2(p_path=>'datarespuesta[%d].detallefacturacion',p0=> i,p_values=>j);
    Lf_valor := apex_json.get_varchar2(p_path=>'datarespuesta[%d].total',p0=> i,p_values=>j);
    Lv_fechafin := apex_json.get_varchar2(p_path=>'datarespuesta[%d].fechafin',p0=> i,p_values=>j);

    Lv_FechaInicial := apex_json.get_varchar2(p_path=>'datarespuesta[%d].fechainicio',p0=> i,p_values=>j);
    Lv_FechaFinal := apex_json.get_varchar2(p_path=>'datarespuesta[%d].fechafin',p0=> i,p_values=>j);

    Ld_FechaInicial := TO_DATE(Lv_FechaInicial, Lv_ParamFechaParametrizada);
    Ld_FechaFinal := TO_DATE(Lv_FechaFinal, Lv_ParamFechaParametrizada);
    
    Lv_FechaStringInicial := REPLACE(Lv_FormatoFechaBase,'d',TO_CHAR(Ld_FechaInicial, 'dd'));
    Lv_FechaStringInicial := REPLACE(Lv_FechaStringInicial,'m',TRIM(TO_CHAR(Ld_FechaInicial, 'Month','nls_date_language=spanish')));
    Lv_FechaStringInicial := REPLACE(Lv_FechaStringInicial,'y',TO_CHAR(Ld_FechaInicial, 'yyyy'));
    Lv_FechaStringFinal   := REPLACE(Lv_FormatoFechaBase,'d',TO_CHAR(Ld_FechaFinal, 'dd'));
    Lv_FechaStringFinal   := REPLACE(Lv_FechaStringFinal,'m',TRIM(TO_CHAR(Ld_FechaFinal, 'Month','nls_date_language=spanish')));
    Lv_FechaStringFinal   := REPLACE(Lv_FechaStringFinal,'y',TO_CHAR(Ld_FechaFinal, 'yyyy'));

    Ln_servicio := NULL;
    Ln_punto    := NULL; 
    Ln_puntoFact:= NULL; 
    Lv_login    := NULL;
    Lv_numeros  := NULL;

    OPEN C_servicio_netvoice(Lv_cuentaNetvoice);
    FETCH C_servicio_netvoice INTO Ln_servicio, Ln_puntoFact, Ln_punto, Lv_login, Lv_numeros;
    CLOSE C_servicio_netvoice;

    IF Ln_servicio IS NOT NULL THEN

      --obtenemos el nombre del producto de acuerdo al servicio
      OPEN C_NombreProductoDeServicio(Ln_servicio);
      FETCH C_NombreProductoDeServicio INTO Lv_NombreProducto;
      CLOSE C_NombreProductoDeServicio;

      --verificamos si el producto debe tener rango_consumo
      OPEN C_Parametros_valor1('PARAM_PRODUCTO_RANGOFECHA');
      FETCH C_Parametros_valor1 INTO Lv_ProdParametrizado;
      IF C_Parametros_valor1%NOTFOUND THEN
        Lv_ProdParametrizado := NULL;
      ELSE
      	IF Lv_ProdParametrizado<>Lv_NombreProducto THEN
      		Lv_ProdParametrizado := NULL;
        END IF;
      END IF;
      CLOSE C_Parametros_valor1;

      IF Lv_ProdParametrizado IS NOT NULL THEN
        Lv_RangoConsumo := REPLACE(Lv_ParamRangoConsumo, ':FECHA_INICIO', Lv_FechaStringInicial);
        Lv_RangoConsumo := REPLACE(Lv_RangoConsumo, ':FECHA_FIN', Lv_FechaStringFinal);
      ELSE
        Lv_RangoConsumo := NULL;
      END IF;
    --REALIZO LOS INSERT
        INSERT
        INTO DB_FINANCIERO.INFO_CONSUMO_CLOUD_CAB
        (
          ID_CONSUMO_CLOUD_CAB,
          NOMBRE,
          OBSERVACION,
          PUNTO_ID,
          PUNTO_FACTURACION_ID,
          SERVICIO_ID,
          FE_CONSUMO,
          ESTADO,
          USR_CREACION,
          IP_CREACION,
          FE_CREACION, 
          RANGO_CONSUMO
        )
        VALUES
        (
          DB_FINANCIERO.SEQ_INFO_CONSUMO_CLOUD_CAB.NEXTVAL,
          Lv_login,
          '[ Números Telefónicos: '||Lv_numeros||'] ' || Lv_detalleFacturacion,
          Ln_punto,
          Ln_puntoFact,
          Ln_servicio,
          to_date(Lv_fechafin,'DD/MM/YYYY'),
          'Validado',
          'netvoice',
          '127.0.0.1',
          sysdate,
          Lv_RangoConsumo
        );

      INSERT
      INTO DB_FINANCIERO.INFO_CONSUMO_CLOUD_DET
        (
          ID_CONSUMO_CLOUD_DET,
          CONSUMO_CLOUD_CAB_ID,
          CARACTERISTICA_ID,
          VALOR,
          USR_CREACION,
          IP_CREACION,
          FE_CREACION
        )
        VALUES
        (
          DB_FINANCIERO.SEQ_INFO_CONSUMO_CLOUD_DET.NEXTVAL,
          DB_FINANCIERO.SEQ_INFO_CONSUMO_CLOUD_CAB.CURRVAL,
          1096,
          Lf_valor,
          'netvoice',
          '127.0.0.1',
          sysdate
        );
        --
    ELSE
      Lv_noProcesadas := Lv_noProcesadas || ' - ' || Lv_cuentaNetvoice;
    END IF;

  END LOOP;

  if Lv_noProcesadas is not null then
    Pv_Mensaje := 'No procesadas '||Lv_noProcesadas;
    DBMS_OUTPUT.PUT(Lv_noProcesadas);
    UTL_MAIL.SEND (
                   sender     => 'notificaciones_telcos@telconet.ec', 
                   recipients => 'notificaciones@netvoice.ec',
                   subject    => 'Ejecución consumo web service Netvoice', 
                   message    => 'Las siguientes cuentas de netvoices no fueron procesadas en la facturación:<br> <br>'||Lv_noProcesadas||'<br> <br> Telcos ', 
                   mime_type  => 'text/html; charset=UTF-8' );
      
  end if;    
  --Liberamos recursos asociados a variable Lc_Data
  DBMS_LOB.freetemporary(Lc_Data);

EXCEPTION
WHEN Ex_noToken THEN
  Pv_Mensaje := 'Error al generar token '||Lv_mensaje;
  DBMS_OUTPUT.PUT(Pv_Mensaje);  
  UTL_MAIL.SEND (sender     => 'notificaciones_telcos@telconet.ec', 
                 recipients => 'notificaciones@netvoice.ec', 
                 subject    => 'Ejecución consumo web service Netvoice', 
                 message    =>  Pv_Mensaje, 
                 mime_type  => 'text/html; charset=UTF-8' );
  ROLLBACK;  
WHEN Ex_errorService THEN
  Pv_Mensaje := 'Error Service: '||Lv_mensaje;
  DBMS_OUTPUT.PUT(Pv_Mensaje);    
  UTL_MAIL.SEND (sender     => 'notificaciones_telcos@telconet.ec', 
                 recipients => 'notificaciones@netvoice.ec', 
                 subject    => 'Ejecución consumo web service Netvoice', 
                 message    =>  Pv_Mensaje, 
                 mime_type  => 'text/html; charset=UTF-8' );
  ROLLBACK;  
WHEN OTHERS THEN
  Pv_Mensaje := 'Error Procedure : '||SQLERRM;
  DBMS_OUTPUT.PUT(Pv_Mensaje);
  UTL_MAIL.SEND (sender     => 'notificaciones_telcos@telconet.ec', 
                 recipients => 'notificaciones@netvoice.ec', 
                 subject    => 'Ejecución consumo web service Netvoice',
                 message    =>  Pv_Mensaje, 
                 mime_type  => 'text/html; charset=UTF-8' );                 
  ROLLBACK;
  
END P_CONSUMO_WS_NETVOICE; 

  PROCEDURE P_RECHAZA_SERVICIOS(Pv_EstadoActualServicio IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
  AS
    --
    Lv_NombreParamTiempo  VARCHAR2(50) := 'TIEMPOS_RECHAZA_SERVICIOS_DETENIDO';
    Lv_EstadoActivo       VARCHAR2(6)  := 'Activo';
    Lv_EstadoRechazada    VARCHAR2(9)  := 'Rechazada';
    Lv_EstadoAnulado      VARCHAR2(9)  := 'Anulado';
    Lv_UsrCreacionRechaza VARCHAR2(15) := 'rechazo_sistema';
    Lv_UsrCreacionAnula   VARCHAR2(15) := 'anula_sistema';
    Lv_MensajeError       VARCHAR2(4000);
    Lv_Status             VARCHAR2(5);
    Lv_ObservacionGeneral VARCHAR2(4000) := '';
    Lv_ObservacionHtml    VARCHAR2(4000) := '';
    Ln_IdMotivo           NUMBER := 0;
    Lv_InfoTecnica        VARCHAR2(1000);
    Lr_RegServicioPorRechazar DB_COMERCIAL.CMKG_TYPES.Lr_ServiciosPorRechazar;
    Lt_TServiciosPorRechazar  DB_COMERCIAL.CMKG_TYPES.Lt_ServiciosPorRechazar;
    Lo_ServicioHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lo_DetalleSolHistorial    DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lrf_ServiciosPorRechazar SYS_REFCURSOR;
    Ln_TotalRegistros           NUMBER := 0;
    Ln_IndxServiciosPorRechazar NUMBER;
    Lv_Remitente                VARCHAR2(50)  := 'notificaciones_telcos@telconet.ec';
    Lv_Asunto                   VARCHAR2(300) := '';
    Lv_AsuntoVendedor           VARCHAR2(300) := 'Rechazo automatico de Planificacion de Solicitud de Instalacion #';
    Lv_Directorio               VARCHAR2(50)  := 'DIR_PLANIFICACION';
    Lv_FechaArchivo             VARCHAR2(20)  := TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo            VARCHAR2(100) := '';
    Lv_NombreArchivoZip         VARCHAR2(100) := '';
    Lv_PrefijoNombreArchivo     VARCHAR2(100) := 'ReportesServiciosRechazados_';
    Lv_Delimitador              VARCHAR2(1)   := ';';
    Lv_EnviaCorreoConsolidado   VARCHAR2(2)   := 'NO';
    Lf_Archivo utl_file.file_type;
    Lv_Gzip VARCHAR2(100) := '';
    Lcl_PlantillaReporte CLOB;
    Lcl_PlantillaVendedor CLOB;
    Lcl_PlantillaVendedorIni CLOB;
    Le_Exception EXCEPTION;
    Le_Error     EXCEPTION;
    Lv_SufijoCorreoVendedor VARCHAR2(20) := '@telconet.ec';
    CURSOR C_GetParamsTiempoRechazo(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, Cv_EstadoActivo VARCHAR2)
    IS
      SELECT APD.ID_PARAMETRO_DET,
        APD.VALOR1      AS PREFIJO_EMPRESA,
        APD.VALOR2      AS DIAS_RECHAZO,
        APD.EMPRESA_COD AS CODIGO_EMPRESA
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
      ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
      WHERE APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APC.ID_PARAMETRO       = APD.PARAMETRO_ID
      AND APD.ESTADO             = Cv_EstadoActivo
      AND APC.ESTADO             = Cv_EstadoActivo;
    CURSOR C_GetPlantilla(Cv_CodigoPlantilla DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
    IS
      SELECT AP.PLANTILLA
      FROM DB_COMUNICACION.ADMI_PLANTILLA AP 
      WHERE AP.CODIGO = Cv_CodigoPlantilla
      AND AP.ESTADO <> 'Eliminado';
    Lr_GetAliasPlantillaGeneral DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  BEGIN
    Lr_GetAliasPlantillaGeneral  := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RECHZ_SERV_AUT');
    IF C_GetPlantilla%ISOPEN THEN
      CLOSE C_GetPlantilla;
    END IF;
    OPEN C_GetPlantilla('RECHZ_SERV_VEND');
    FETCH C_GetPlantilla INTO Lcl_PlantillaVendedorIni;
    CLOSE C_GetPlantilla;
    SELECT NVL(
                (
                    SELECT ID_MOTIVO
                    FROM DB_GENERAL.ADMI_MOTIVO
                    WHERE NOMBRE_MOTIVO = 'Demora en tiempo de instalación'
                      AND ESTADO = 'Activo'
                ),
                0
            )
    INTO Ln_IdMotivo
    FROM DUAL;
    FOR I_GetParamsTiempoRechazo IN C_GetParamsTiempoRechazo(Lv_NombreParamTiempo, Lv_EstadoActivo)
    LOOP
      IF (I_GetParamsTiempoRechazo.CODIGO_EMPRESA IS NOT NULL AND I_GetParamsTiempoRechazo.PREFIJO_EMPRESA IS NOT NULL 
      AND I_GetParamsTiempoRechazo.DIAS_RECHAZO IS NOT NULL AND Lr_GetAliasPlantillaGeneral.PLANTILLA IS NOT NULL
      AND Lcl_PlantillaVendedorIni IS NOT NULL) THEN
        Lv_ObservacionGeneral   := 'Se procederá con el rechazo de la O/T del cliente en mención, ya que de acuerdo al' 
                                    || ' PROCEDIMIENTO DE INSTALACIONES, éstas han superado los ' 
                                    || I_GetParamsTiempoRechazo.DIAS_RECHAZO 
                                    || ' días de espera debido a que no se ha podido gestionar de manera inmediata por temas'
                                    || ' de postergación directa por parte del cliente, facturación de recursos adicionales'
                                    || ' y obras civiles. Por favor su gentil ayuda' 
                                    || ' reingresando la O/T cuando se defina con el cliente cómo proceder con la instalación.';
        Lv_ObservacionHtml      := 'Se proceder&aacute; con el rechazo de la O/T del cliente en menci&oacute;n, ya que de acuerdo al' 
                                    || ' PROCEDIMIENTO DE INSTALACIONES, &eacute;stas han superado los ' 
                                    || I_GetParamsTiempoRechazo.DIAS_RECHAZO 
                                    || ' d&iacute;as de espera debido a que no se ha podido gestionar de manera inmediata por temas'
                                    || ' de postergaci&oacute;n directa por parte del cliente, facturaci&oacute;n de recursos adicionales'
                                    || ' y obras civiles. Por favor su gentil ayuda' 
                                    || ' reingresando la O/T cuando se defina con el cliente c&oacute;mo proceder con la instalaci&oacute;n.';
        Ln_TotalRegistros       := 0;
        --Se obtiene el listado de servicios en estado Detenido que han cumplido o sobrepasado el tiempo límite
        DB_COMERCIAL.COMEK_CONSULTAS.P_GET_SERVICIOS_POR_RECHAZAR(  I_GetParamsTiempoRechazo.CODIGO_EMPRESA, 
                                                                    Pv_EstadoActualServicio,
                                                                    I_GetParamsTiempoRechazo.DIAS_RECHAZO, 
                                                                    Ln_TotalRegistros,
                                                                    Lrf_ServiciosPorRechazar,
                                                                    Lv_Status,
                                                                    Lv_MensajeError);
        --Se verifica que existan servicios por liberarse por empresa
        IF Ln_TotalRegistros    > 0 THEN
          Lv_NombreArchivo     := Lv_PrefijoNombreArchivo || I_GetParamsTiempoRechazo.PREFIJO_EMPRESA || '_' || Lv_FechaArchivo || '.csv';
          Lv_NombreArchivoZip  := Lv_NombreArchivo || '.gz';
          Lv_Gzip              := 'gzip /backup/reportes/planificacion/' || Lv_NombreArchivo;
          Lv_Asunto            := 'Notificacion Reporte de servicios rechazados ' || I_GetParamsTiempoRechazo.PREFIJO_EMPRESA ;
          Lf_Archivo           := UTL_FILE.fopen(Lv_Directorio,Lv_NombreArchivo,'w',3000);
          Lcl_PlantillaReporte := Lr_GetAliasPlantillaGeneral.PLANTILLA;
          Lcl_PlantillaReporte := REPLACE(Lcl_PlantillaReporte,'{{ TIEMPOPARAMETRO }}', I_GetParamsTiempoRechazo.DIAS_RECHAZO);
          --Cabecera del archivo adjunto con la información de los servicios que serán rechazados
          utl_file.put_line(Lf_Archivo, 
                            'CLIENTE' || Lv_Delimitador || 
                            'LOGIN' || Lv_Delimitador ||
                            'JURISDICCION' || Lv_Delimitador ||
                            'CIUDAD' || Lv_Delimitador ||
                            'PRODUCTO' || Lv_Delimitador ||
                            'LOGIN VENDEDOR' || Lv_Delimitador ||
                            'VENDEDOR' || Lv_Delimitador ||
                            'FECHA ESTADO DETENIDO' || Lv_Delimitador ||
                            'DIAS DETENIDOS' || Lv_Delimitador ||
                            'ESTADO' || Lv_Delimitador);
          LOOP
          FETCH Lrf_ServiciosPorRechazar BULK COLLECT INTO Lt_TServiciosPorRechazar LIMIT 100;
          EXIT WHEN Lt_TServiciosPorRechazar.COUNT = 0;
            Ln_IndxServiciosPorRechazar := Lt_TServiciosPorRechazar.FIRST;
            WHILE (Ln_IndxServiciosPorRechazar IS NOT NULL)
            LOOP
              Lr_RegServicioPorRechazar := Lt_TServiciosPorRechazar(Ln_IndxServiciosPorRechazar);
              Lv_Status                 := '';
              Lv_InfoTecnica            := '';
              Lv_MensajeError           := '';
              BEGIN
                --Se actualiza el estado del servicio a Anulado
                UPDATE DB_COMERCIAL.INFO_SERVICIO
                SET ESTADO                                            = Lv_EstadoAnulado
                WHERE ID_SERVICIO                                     = Lr_RegServicioPorRechazar.ID_SERVICIO;

                IF (Lr_RegServicioPorRechazar.NOMBRE_TECNICO_PRODUCTO = 'INTERNET SMALL BUSINESS' 
                OR Lr_RegServicioPorRechazar.NOMBRE_TECNICO_PRODUCTO = 'TELCOHOME' 
                OR Lr_RegServicioPorRechazar.NOMBRE_PRODUCTO = 'L3MPLS' 
                OR Lr_RegServicioPorRechazar.NOMBRE_PRODUCTO = 'Internet Dedicado') THEN
                  DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.P_LIBERA_FACTIB_SERVICIO(I_GetParamsTiempoRechazo.PREFIJO_EMPRESA, 
                                                                                  Lr_RegServicioPorRechazar.ID_SERVICIO_TECNICO, 
                                                                                  Lr_RegServicioPorRechazar.CODIGO_TIPO_MEDIO, 
                                                                                  Lv_Status, Lv_InfoTecnica, 
                                                                                  Lv_MensajeError);
                ELSIF Lr_RegServicioPorRechazar.NOMBRE_PRODUCTO = 'INTERNET WIFI' THEN
                  DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.P_LIBERA_PUERTO_WIFI(Lr_RegServicioPorRechazar.ID_SERVICIO, 
                                                                              Lr_RegServicioPorRechazar.ID_SERVICIO_TECNICO, 
                                                                              Lr_RegServicioPorRechazar.INTERFACE_ELEMENTO_CONECTOR_ID, 
                                                                              Lr_RegServicioPorRechazar.ID_PRODUCTO, 
                                                                              Lv_Status, 
                                                                              Lv_MensajeError);
                ELSIF Lr_RegServicioPorRechazar.PRODUCTO_ES_CONCENTRADOR = 'SI' THEN
                  Lv_MensajeError := DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.F_GET_SERVICIOS_X_CONCENTRADOR(Lr_RegServicioPorRechazar.ID_SERVICIO);
                END IF;
                IF Lv_MensajeError IS NOT NULL THEN
                  RAISE Le_Error;
                END IF;
                --Se elimina todas las características SERVICIO_MISMA_ULTIMA_MILLA que dependan de este servicio
                DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.P_ELIMINA_DEPENDENCIA_MISMA_UM(Lr_RegServicioPorRechazar.ID_SERVICIO,
                                                                                      Lv_UsrCreacionRechaza,
                                                                                      Lv_Status, 
                                                                                      Lv_MensajeError);
                IF Lv_Status = 'ERROR' THEN
                  RAISE Le_Error;
                END IF;

                --Se agrega el historial con la respectiva información del rechazo del servicio
                INSERT
                INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                  (
                    ID_SERVICIO_HISTORIAL,
                    SERVICIO_ID,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    ESTADO,
                    MOTIVO_ID,
                    OBSERVACION,
                    ACCION
                  )
                  VALUES
                  (
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Lr_RegServicioPorRechazar.ID_SERVICIO,
                    Lv_UsrCreacionRechaza,
                    SYSDATE,
                    '127.0.0.1',
                    Lv_EstadoRechazada,
                    Ln_IdMotivo,
                    Lv_ObservacionGeneral,
                    NULL
                  );

                --Se agrega el historial con la respectiva información de la anulación del servicio
                Lo_ServicioHistorial   := NULL;
                Lv_MensajeError        := '';

                Lo_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                Lo_ServicioHistorial.OBSERVACION           := Lv_ObservacionGeneral;
                Lo_ServicioHistorial.ESTADO                := Lv_EstadoAnulado;
                Lo_ServicioHistorial.USR_CREACION          := Lv_UsrCreacionAnula;
                Lo_ServicioHistorial.IP_CREACION           := '127.0.0.1';
                Lo_ServicioHistorial.SERVICIO_ID           := Lr_RegServicioPorRechazar.ID_SERVICIO;
                Lo_ServicioHistorial.MOTIVO_ID             := Ln_IdMotivo;
                DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lo_ServicioHistorial, Lv_MensajeError);
                
                IF Lv_MensajeError IS NOT NULL THEN 
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'COMEK_TRANSACTION.P_RECHAZA_SERVICIOS', 
                                                        Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                                        SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                END IF;

                --Se actualiza el estado y la observación de la solicitud de planificación del servicio
                UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
                SET ESTADO                 = Lv_EstadoAnulado,
                  OBSERVACION              = Lv_ObservacionGeneral,
                  MOTIVO_ID                = Ln_IdMotivo
                WHERE ID_DETALLE_SOLICITUD = Lr_RegServicioPorRechazar.ID_DETALLE_SOLICITUD;

                --Se agrega el historial de la solicitud con estado rechazada
                INSERT
                INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                  (
                    ID_SOLICITUD_HISTORIAL,
                    DETALLE_SOLICITUD_ID,
                    ESTADO,
                    OBSERVACION,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    MOTIVO_ID
                  )
                  VALUES
                  (
                    DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
                    Lr_RegServicioPorRechazar.ID_DETALLE_SOLICITUD,
                    Lv_EstadoRechazada,
                    Lv_ObservacionGeneral,
                    Lv_UsrCreacionRechaza,
                    SYSDATE,
                    '127.0.0.1',
                    Ln_IdMotivo
                  );

                --Se agrega el historial de la solicitud con estado anulado
                Lo_DetalleSolHistorial := NULL;
                Lv_MensajeError        := '';

                Lo_DetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
                Lo_DetalleSolHistorial.DETALLE_SOLICITUD_ID   := Lr_RegServicioPorRechazar.ID_DETALLE_SOLICITUD;
                Lo_DetalleSolHistorial.ESTADO                 := Lv_EstadoAnulado;
                Lo_DetalleSolHistorial.OBSERVACION            := Lv_ObservacionGeneral;
                Lo_DetalleSolHistorial.USR_CREACION           := Lv_UsrCreacionAnula;
                Lo_DetalleSolHistorial.IP_CREACION            := '127.0.0.1';
                DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Lo_DetalleSolHistorial, Lv_MensajeError);
                
                IF Lv_MensajeError IS NOT NULL THEN 
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'COMEK_TRANSACTION.P_RECHAZA_SERVICIOS', 
                                                        Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                                        SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                END IF;
                
                --Se cambia el estado a las tareas relacionadas a rechazada, anulado y cancelada
                Lv_MensajeError        := '';
                DB_SOPORTE.SPKG_SOPORTE.P_CAMBIAR_ESTADO_TAREA_RECHAZO(Lr_RegServicioPorRechazar.ID_DETALLE_SOLICITUD,
                                    Lv_EstadoRechazada,
                                    Lv_ObservacionGeneral,
                                    Lv_MensajeError);
                                    
                IF Lv_MensajeError IS NOT NULL THEN 
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'COMEK_TRANSACTION.P_RECHAZA_SERVICIOS', 
                                                        Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                                        SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                Lv_MensajeError        := '';
                END IF;  
                                    
                Lv_EnviaCorreoConsolidado := 'SI';
                COMMIT;
                UTL_FILE.put_line(Lf_Archivo, 
                                  Lr_RegServicioPorRechazar.CLIENTE || Lv_Delimitador || 
                                  Lr_RegServicioPorRechazar.LOGIN || Lv_Delimitador || 
                                  Lr_RegServicioPorRechazar.JURISDICCION || Lv_Delimitador || 
                                  Lr_RegServicioPorRechazar.CIUDAD || Lv_Delimitador || 
                                  Lr_RegServicioPorRechazar.NOMBRE_PRODUCTO || Lv_Delimitador || 
                                  Lr_RegServicioPorRechazar.USR_VENDEDOR || Lv_Delimitador || 
                                  Lr_RegServicioPorRechazar.VENDEDOR || Lv_Delimitador || 
                                  Lr_RegServicioPorRechazar.FECHA_DETENIDO || Lv_Delimitador || 
                                  Lr_RegServicioPorRechazar.DIAS_DETENIDO_REPORTE || Lv_Delimitador || 
                                  Lv_EstadoRechazada || Lv_Delimitador );
                --Envío de correo al vendedor
                IF Lr_RegServicioPorRechazar.USR_VENDEDOR IS NOT NULL THEN
                  Lcl_PlantillaVendedor                   := Lcl_PlantillaVendedorIni;
                  Lcl_PlantillaVendedor                   := REPLACE(Lcl_PlantillaVendedor,'{{ CLIENTE }}', Lr_RegServicioPorRechazar.CLIENTE);
                  Lcl_PlantillaVendedor                   := REPLACE(Lcl_PlantillaVendedor,'{{ LOGIN }}', Lr_RegServicioPorRechazar.LOGIN);
                  Lcl_PlantillaVendedor                   := REPLACE(Lcl_PlantillaVendedor,'{{ JURISDICCION }}', 
                                                                     Lr_RegServicioPorRechazar.JURISDICCION);
                  Lcl_PlantillaVendedor                   := REPLACE(Lcl_PlantillaVendedor,'{{ CIUDAD }}', Lr_RegServicioPorRechazar.CIUDAD);
                  Lcl_PlantillaVendedor                   := REPLACE(Lcl_PlantillaVendedor,'{{ PRODUCTO }}', 
                                                                     Lr_RegServicioPorRechazar.NOMBRE_PRODUCTO);
                  Lcl_PlantillaVendedor                   := REPLACE(Lcl_PlantillaVendedor,'{{ FECHA_DETENIDO }}', 
                                                                     Lr_RegServicioPorRechazar.FECHA_DETENIDO);
                  Lcl_PlantillaVendedor                   := REPLACE(Lcl_PlantillaVendedor,'{{ OBSERVACION_SERVICIO }}', Lv_ObservacionHtml);
                  Lcl_PlantillaVendedor                   := REPLACE(Lcl_PlantillaVendedor,'{{ ESTADO_SERVICIO }}', Lv_EstadoRechazada);
                  --Envío de correo al vendedor
                  DB_COMUNICACION.CUKG_TRANSACTIONS.P_SEND_MAIL(  Lv_Remitente, Lr_RegServicioPorRechazar.USR_VENDEDOR || Lv_SufijoCorreoVendedor, 
                                                                  Lv_AsuntoVendedor || Lr_RegServicioPorRechazar.ID_DETALLE_SOLICITUD, 
                                                                  SUBSTR(Lcl_PlantillaVendedor, 1, 32767), 'text/html; charset=UTF-8', 
                                                                  Lv_MensajeError);
                  IF Lv_MensajeError IS NOT NULL THEN 
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'COMEK_TRANSACTION.P_RECHAZA_SERVICIOS', 
                                                          Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                                          SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                    Lv_MensajeError := ''; 
                  END IF;
                END IF;
              EXCEPTION
              WHEN Le_Error THEN
                ROLLBACK;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'COMEK_TRANSACTION.P_RECHAZA_SERVICIOS', 
                                                      Lv_MensajeError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                                      SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                Lv_MensajeError := ''; 
              WHEN OTHERS THEN
                ROLLBACK;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'COMEK_TRANSACTION.P_RECHAZA_SERVICIOS', 
                                                      SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, 
                                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                Lv_MensajeError := ''; 
              END;--Fin de rechazo de un servicio
              Ln_IndxServiciosPorRechazar := Lt_TServiciosPorRechazar.NEXT(Ln_IndxServiciosPorRechazar);
            END LOOP;
          END LOOP;
          CLOSE Lrf_ServiciosPorRechazar;
          UTL_FILE.fclose(Lf_Archivo);
          DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip));

          IF Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS IS NOT NULL THEN
            Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS := REPLACE(Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, ';', ',') || ',';
          ELSE 
            Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS := Lv_Remitente;
          END IF;

          --Envío de correo con el reporte a los alias indicados
          IF Lv_EnviaCorreoConsolidado = 'SI' THEN
            DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, Lr_GetAliasPlantillaGeneral.ALIAS_CORREOS, 
                                                      Lv_Asunto, Lcl_PlantillaReporte, Lv_Directorio, Lv_NombreArchivoZip);
          END IF;
          UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);
        END IF;
      ELSE
        Lv_MensajeError := Lv_MensajeError || ' No existen los parámetros requeridos para realizar el rechazo del servicio';
      END IF;
    END LOOP;
    IF TRIM(Lv_MensajeError) IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;
  EXCEPTION
  WHEN Le_Exception THEN
    --
    ROLLBACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'COMEK_TRANSACTION.P_RECHAZA_SERVICIOS', 
                                            Lv_MensajeError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    --
    ROLLBACK;
    --
    Lv_MensajeError := SQLCODE || ' -ERROR- ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'COMEK_TRANSACTION.P_RECHAZA_SERVICIOS', Lv_MensajeError, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_RECHAZA_SERVICIOS;

END COMEK_TRANSACTION;

/
