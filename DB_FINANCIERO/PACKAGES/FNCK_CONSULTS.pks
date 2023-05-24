CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_CONSULTS
AS

  /**
  * Documentacion para la funcion F_GET_MAX_DOCUMENTO_SERV_PROD
  *
  * La funcion retorna la m�xima factura dependiendo del puntoFacturacionId, puntoId, servicioId, productoId 
  * , y precioVenta ademas del filtro que se env�e a consultar, sean Factura por AnioMes o Rango de Consumo
  * Se considera como prioridad se obtenga la Factura por Servicio facturado, o Factura por Producto y 
  * Precio de Venta asociado , o solo por producto asociado al servicio.
  *
  * @param Fn_PuntoFacturacionId    IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @param Fn_PuntoId               IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE
  * @param Fn_ServicioId            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.SERVICIO_ID%TYPE
  * @param Fn_ProductoId            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE
  * @param Fn_PrecioVenta           IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE
  * @param Fv_Filtro                IN VARCHAR2
  * return Fn_IdDocumento           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-10-2018
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 03-03-2022   Se agrega  condici�n en query que verifica documentos que no posean notas de cr�dito con el valor total del precio 
  *                           de venta del servicio asociado . 
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.2 06-04-2022   Se agrega  correcci�n en query que verifica documentos que no posean notas de cr�dito.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.3 01-06-2022   Se agrega  env�o de par�metro Fn_ServicioId en querys en clausula USING para optimizar tiempo de ejecuci�n de proceso .
  */
  FUNCTION F_GET_MAX_DOCUMENTO_SERV_PROD(
      Fn_PuntoFacturacionId IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
      Fn_PuntoId            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
      Fn_ServicioId         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.SERVICIO_ID%TYPE,      
      Fn_ProductoId         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE,
      Fn_PrecioVenta        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE,     
      Fv_Filtro             IN VARCHAR2)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;

  /**
   * Documentaci�n para F_OBTIENE_IMPUESTOS_RIDE
   * Devuelve un Json con los par�metros (cabecera de impuestos) a llenar en el RIDE.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0 30-12-2017 - Versi�n inicial
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.1 03-01-2018 - Se modifican los subtotales: Se resta del subtotal el valor del descuento.
   */
  FUNCTION F_OBTIENE_IMPUESTOS_RIDE(
    Fn_IdDocumento          IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
    )
  RETURN VARCHAR2;

  /**
   * Funci�n que devuelve si se debe crear una factura de instalaci�n a un punto espec�fico.
   * Si el punto no tiene ninguna factura de instalaci�n (en todos su servicios) se devuelve 'S' porque el punto s� aplica la creaci�n de factura.
   * Si el punto tiene una o m�s facturas se valida:
   *    Si al menos una factura est� Pendiente o Activa, no debe crearse la factura de instalaci�n; devuelve 'N'.
   *    Si al menos una de sus facturas est� Cerrada por pagos, no debe crearse la factura de instalaci�n; devuelve 'N'
   *    Si una o todas sus facturas est�n cerradas por N/C, s� debe crearse la factura de instalaci�n; devuelve 'S'
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 21-11-2018
   *
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 24-01-2019
   * Se agrega validaci�n cuando la factura est� en estado "Cerrado", se debe verificar si fue cerrada por  NC o NCI.
   * Si la factura es cerrada por NC o NCI, significa que s� debe crearse la factura de instalaci�n.
   */
  FUNCTION F_APLICA_CREAR_FACT_INST(Pn_PuntoId DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE) RETURN VARCHAR2;

  --
  /*
  * Documentaci�n para TYPE 'Lr_InfoEmpresaGrupo'.
  *
  * Tipo de datos para el retorno de la informacion correspondiente a la 'DB_COMERCIAL.INFO_EMPRESA_GRUPO'
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 01-12-2016
  */
  TYPE Lr_InfoEmpresaGrupo
  IS
    RECORD
    (
      COD_EMPRESA DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      PREFIJO DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE );
  --
  TYPE C_InfoEmpresaGrupo
  IS
    REF
    CURSOR
      RETURN Lr_InfoEmpresaGrupo;
  --
  /*
  * Documentaci�n para TYPE 'Lr_InfoDocumentosRepetidos'.
  *
  * Tipo de datos para el retorno de la informacion correspondiente a los documentos repetidos a regularizar
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 25-11-2016
  */
  TYPE Lr_InfoDocumentosRepetidos
  IS
    RECORD
    (
      ID_DOCUMENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      OFICINA_ID DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OFICINA_ID%TYPE,
      PUNTO_ID DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE );
  --
  TYPE C_DocumentosRepetidos
  IS
    REF
    CURSOR
      RETURN Lr_InfoDocumentosRepetidos;
  --
  --
  /**
  * Documentacion para la funci�n 'F_GET_TOTAL_FACTURACION'
  *
  * Funci�n que obtiene el total de lo facturado dependiendo de los par�metros enviados por el usuario.
  *
  * @param Fv_PrefijoEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE    Prefijo de la empresa a consultar
  * @param Fd_FechaInicio      IN VARCHAR2    Fecha Inicio de autorizacion
  * @param Fd_FechaFin         IN VARCHAR2    Fecha Fin de autorizacion
  * @param Fv_Categoria    IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE   Se env�a el nombre de la categoria a buscar
  * @param Fv_Grupo    IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE    Se env�a el nombre del grupo de los productos a consultar
  * @param Fv_Subgrupo   IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE   Se env�a el nombre del subgrupo de los productos a consultar
  * @param Fv_EsRecurrente     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.RECURRENTE%TYPE   Campo que indica si la facturaci�n es recurrente
  *
  * @return NUMBER  Retorna la sumatoria de la facturaci�n obtenida
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 06-06-2017
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 28-02-2018 - Se modifica para que en los parametros de Fd_FechaInicio y Fd_FechaFin se consulte por FeEmision
  * de la Factura y ya no por FeAutorizacion.
  */
  FUNCTION F_GET_TOTAL_FACTURACION(
    Fv_PrefijoEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fd_FechaInicio      IN VARCHAR2,
    Fd_FechaFin         IN VARCHAR2,
    Fv_Categoria        IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Fv_Grupo            IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
    Fv_Subgrupo         IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
    Fv_EsRecurrente     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.RECURRENTE%TYPE)
  RETURN NUMBER;
  --
  --
  /**
  * Documentacion para la funci�n 'F_GET_HISTORIAL_PAGO_ANTICIPO'
  *
  * Funci�n que retorna la fecha del historial del pago o anticipo o el estado de un pago o anticipo de una fecha determinada.
  *
  * @param Fn_IdPagoCab          IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  Id de la cabecera del pago
  * @param Fv_EstadoPago         IN DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE  Estado del pago a consultar
  * @param Fv_FechaConsultaDesde IN VARCHAR2  Fecha desde con la cual se va a realizar la consulta del pago
  * @param Fv_FechaConsultaHasta IN VARCHAR2  Fecha hasta con la cual se va a realizar la consulta del pago
  * @param Fv_Filtro             IN VARCHAR2  Valor que se requiere obtener
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 29-03-2017
  */
FUNCTION F_GET_HISTORIAL_PAGO_ANTICIPO(
    Fn_IdPagoCab          IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
    Fv_EstadoPago         IN DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
    Fv_FechaConsultaDesde IN VARCHAR2,
    Fv_FechaConsultaHasta IN VARCHAR2,
    Fv_Filtro             IN VARCHAR2)
  RETURN VARCHAR2;
  --
  --
  /**
  * Documentacion para el procedimiento 'P_VALIDAR_FECHA_DEPOSITO'
  *
  * M�todo que validar� hasta que fecha se podr� ingresar pagos, anticipos y/o procesar dep�sitos
  *
  * @param Pv_FechaValidar        IN VARCHAR2  Fecha contra la cual se va a validar la informaci�n
  * @param Pv_ParametroValidar    IN VARCHAR2  Valor1 del detalle del par�metro 'VALIDACIONES_PROCESOS_CONTABLES'
  * @param Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE  Prefijo de la empresa en sessi�n
  * @param Pv_RespuestaValidacion OUT VARCHAR2  Respuesta de la validacion realizada. Los valores son: 'S' puesto continuar con el proceso, caso
  *                                             contrario 'N'
  * @param Pv_MensajeError        OUT VARCHAR2  Mensaje de error en caso de existir
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 16-03-2017
  */
  PROCEDURE P_VALIDAR_FECHA_DEPOSITO(
      Pv_FechaValidar        IN VARCHAR2,
      Pv_ParametroValidar    IN VARCHAR2,
      Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_RespuestaValidacion OUT VARCHAR2,
      Pv_MensajeError        OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para la funcion F_GET_TIPO_COMPROBANTE_EXP
  * Retorna el tipo de comprobante correspondiente a los documentos financieros.
  * @param Fn_IdEmpresa                 IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @param Fv_FechaInicio               IN VARCHAR2
  * @param Fv_FechaFin                  IN VARCHAR2
  *
  * Costo del query Cursor: C_GetTipoComprobanteExp 4
  *
  * @version 1.0 22-01-2017
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  */
  FUNCTION F_GET_TIPO_COMPROBANTE_EXP(
    Fn_IdEmpresa         IN   INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fn_IdDocumento       IN   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2;
  --
  /**
  * Documentacion para la funcion F_GET_DETALLE_EXPORTACIONES
  * Retorna parametro TIPO_REGI, EXPORTACION_DE, TIP_ING_EXT, ING_EXT_GRAV_OTRO_PAIS que conforman el detalle de las
  * exportaciones del ATS para TN
  * @param Fn_IdEmpresa                 IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @param Fv_FechaInicio               IN VARCHAR2
  * @param Fv_FechaFin                  IN VARCHAR2
  * @version 1.0 29-11-2016
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  */
  FUNCTION F_GET_DETALLE_EXPORTACIONES(
    Fn_IdEmpresa         IN   INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_NombreParametro   IN   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Fv_Valor1            IN   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
  RETURN VARCHAR2;
  --
  /**
  * Documentacion para la funcion F_GET_EXPORTACIONES
  * Retorna el detalle de las exportaciones del ATS para TN
  * @param Fn_IdEmpresa                 IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @param Fv_FechaInicio               IN VARCHAR2
  * @param Fv_FechaFin                  IN VARCHAR2
  * @version 1.0 29-11-2016
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  *  
  * Costo del cursor C_GetExportaciones 607
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 28-02-2018 - Se modifica para que en los parametros de Fv_FechaInicio y Fv_FechaFin se consulte por FeEmision
  * de la Factura y ya no por FeAutorizacion.
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.2 29-08-2019 - Se modifica para agregar datos de impuesto exterior en xml
  */
  FUNCTION F_GET_EXPORTACIONES(
    Fn_IdEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_FechaInicio IN VARCHAR2,
    Fv_FechaFin    IN VARCHAR2)
  RETURN XMLTYPE;
  --
  /**
  * Documentacion para la funcion F_SET_ATTR_PAIS
  * Retorna el pais del cliente
  * Fn_IdPersonaRol      IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE    Recibe la persona empresa rol id
  * Fv_CodeTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE    Recibe codigo tipo documento
  * @version 1.0 26-11-2016
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * Costo del Cursor: C_GetPaisCliente 6
  */
  FUNCTION F_SET_ATTR_PAIS(
    Fn_IdPersonaRol      IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  RETURN DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE;
  --
  /**
  * Documentacion para la funcion F_GET_PARTE_REL_VTAS
  * Retorna SI/NO el cliente est� relacionada unicamente con la empresa TN.
  *
  * @param Fv_IdentCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE Recibe la identificacion del cliente.
  * @param Fn_IdEmpresa    IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE                    Recibe ID de la empresa.
  * return VARCHAR2
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 25-11-2016
  */
  FUNCTION F_GET_PARTE_REL_VTAS(
      Fv_IdentCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
      Fn_IdEmpresa    IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN VARCHAR2;
  --
  /**
  * Documentacion para la funcion GET_COMPENSACIONES
  * Funcion que obtiene las compensaciones para las personas afectadas del terromoto
  * @param Fn_IdEmpresa                 IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @param Fv_FechaInicio               IN VARCHAR2
  * @param Fv_FechaFin                  IN VARCHAR2
  * @param Fv_IdentCliente              IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE
  * @param Fn_codTipoSri                IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_COMP_ATS_SRI%TYPE
  * return XMLTYPE
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 18-09-2016
  * Costo del query cursor: C_Get_CodigoComp 4
  *                         C_Get_MontoComp  40
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 28-02-2018 - Se modifica para que en los parametros de Fv_FechaInicio y Fv_FechaFin se consulte por FeEmision
  * de la Factura y ya no por FeAutorizacion.
  */
  FUNCTION GET_COMPENSACIONES(
    Fn_IdEmpresa    IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_FechaInicio  IN VARCHAR2,
    Fv_FechaFin     IN VARCHAR2,
    Fv_IdentCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fn_codTipoSri   IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_COMP_ATS_SRI%TYPE)
  RETURN XMLTYPE;
  --
  /**
  * Documentacion para la funcion F_GET_FORMA_PAGO_POR_CLIENTE
  * Retorna el codigo sri de forma de pago asociado al cliente.
  *
  * @param Fv_IdentCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE Recibe la identificacion del cliente.
  * return DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 27-10-2016
  *
  * Costo del cursor C_GetFormaPagoPorCliente     12
  *                  C_GetFormaPagoPorPreCliente  12
  */
  FUNCTION F_GET_FORMA_PAGO_POR_CLIENTE(
      Fv_IdentCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE)
  RETURN DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE;
  --
  /**
  * Documentacion para la funcion F_GET_TOTAL_IMPUESTOS
  *
  * La funci�n retorna el total de los impuestos asociado al documento dependiendo del tipo de impuesto:
  * tarifa 0%, iva, ice, reembolsos.
  *
  * @param Fn_IdEmpresa                 IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @param Fv_FechaInicio               IN VARCHAR2
  * @param Fv_FechaFin                  IN VARCHAR2
  * @param Fv_tipoImpuesto              IN VARCHAR2
  * @param Fv_identCliente              IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE
  * @param Fn_codTipoSri                IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_COMP_ATS_SRI%TYPE
  *
  * return VARCHAR2
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 05-09-2016
  *
  * Costo del query de los cursores:  C_Get_BaseImp                 45
  *                                   C_Get_BaseImpReembolso        45
  *                                   C_Get_BaseImpGrav             47
  *                                   C_Get_BaseImpGravReembolso    47
  *                                   C_Get_TotalImpuestos          51
  *                                   C_Get_TotalImpuestosReembolso 47
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 28-02-2018 - Se modifica para que en los parametros de Fv_FechaInicio y Fv_FechaFin se consulte por FeEmision
  * de la Factura y ya no por FeAutorizacion.
  */
  FUNCTION F_GET_TOTAL_IMPUESTOS(
    Fn_IdEmpresa    IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_FechaInicio  IN VARCHAR2,
    Fv_FechaFin     IN VARCHAR2,
    Fn_tipoImpuesto IN VARCHAR2,
    Fv_identCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fn_codTipoSri   IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_COMP_ATS_SRI%TYPE)
  RETURN VARCHAR2;
  --
  /**
  * Documentaci�n para FUNCTION 'F_GET_FECHA_CRUCE_PAGO'.
  *
  * Funci�n que obtiene la fecha de cruce del pago usando el id de la cabecera o el id del detalle del pago
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 12-01-2017
  *
  * PARAMETROS:
  * @param Fn_IdPagoCab IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  (Id de la cabecera del pago)
  * @param Fn_IdPagoDet IN  DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE  (Id del detalle del pago)
  *
  * @return DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE%TYPE
  */
  FUNCTION F_GET_FECHA_CRUCE_PAGO(
      Fn_IdPagoCab IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
      Fn_IdPagoDet IN DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE)
    RETURN DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE%TYPE;
  --
  --
  /**
  * Documentaci�n para el procedure 'P_VALIDADOR_DOCUMENTOS'.
  *
  * Procedimiento que verifica si el c�lculo de impuestos de un documento debe ser regularizado a nivel de cabecera puesto que al redondear los
  * impuestos queda una diferencia que se debe considerar la cual descuadra el valor facturado.
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 24-01-2017
  *
  * PARAMETROS:
  * @param Pn_IdDocumento  IN   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  (Id del documento)
  * @param Pv_Bandera      OUT  VARCHAR2  (Bandera que indica si se debe regularizar la cabecera del documento)
  * @param Pn_Diferencia   OUT  NUMBER  (Diferencia que debe ser sumada al impuesto para ser regularizado)
  */
  PROCEDURE P_VALIDADOR_DOCUMENTOS(
      Pn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_Bandera     OUT VARCHAR2,
      Pn_Diferencia  OUT NUMBER );
  --
  --
  /**
  * Documentaci�n para FUNCTION 'F_GET_FECHA_HISTORIAL'.
  *
  * Funci�n que obtiene la fecha del historial que se desea buscar
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 10-01-2017
  *
  * PARAMETROS:
  * @param Fn_IdDocumento     IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  (Id del documento del cual se va a obtener la fecha
  *                                                                                               del historial)
  * @param Fv_EstadoDocumento IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE  (Estado del documento a buscar)
  * @param Fv_FiltroBusqueda  IN  VARCHAR2  (Indica la fecha que se desea buscar, es decir si es la m�xima fecha del historial 'MAX', o la m�nima
  *                                          fecha 'MIN', o si se desea la fecha m�xima con motivo 'MAX_MOTIVO' o minima con motivo 'MIN_MOTIVO')
  *
  * @return DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.FE_CREACION%TYPE
  *
  * Se reemplaza la inserci�n del error por dbms_output.put_line,
  * para evitar error ORA-14551: cannot perform a DML operation inside a query.
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.1 20-01-2017
  */
  FUNCTION F_GET_FECHA_HISTORIAL(
    Fn_IdDocumento     IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_EstadoDocumento IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    Fv_FiltroBusqueda  IN  VARCHAR2)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.FE_CREACION%TYPE;
  --
  --
  /**
  * Documentaci�n para FUNCTION 'F_GET_EMPRESA_ELECTRONICAS'.
  *
  * Funci�n que obtiene las empresas que usan documentos electronicos
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 01-12-2016
  *
  * PARAMETROS:
  * @param Fv_Estado              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE  (Estado 'Activo' de las empresas que se desea buscar)
  * @param Fv_FacturaElectronica  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.FACTURA_ELECTRONICO%TYPE  (Par�metro que indica si la empresa usa documentos
  *                                                                                              electr�nicos)
  *
  * @return Lr_AdmiNumeracion
  */
  FUNCTION F_GET_EMPRESA_ELECTRONICAS(
    Fv_Estado              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE,
    Fv_FacturaElectronica  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.FACTURA_ELECTRONICO%TYPE)
    RETURN DB_FINANCIERO.FNCK_CONSULTS.C_InfoEmpresaGrupo;
  --
  --
  /**
  * Documentaci�n para FUNCTION 'F_GET_ADMI_NUMERACION'.
  *
  * Funci�n que obtiene la numeraci�n respectiva con la cual se numerar�n los documentos que ser�n enviados al SRI
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 01-12-2016
  *
  * PARAMETROS:
  * @param Fv_EstadoActivo          IN  DB_COMERCIAL.ADMI_NUMERACION.ESTADO%TYPE  (Estado 'Activo' de la numeraci�n a buscar)
  * @param Fv_CodEmpresa            IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (C�digo de la empresa a regularizar)
  * @param Fv_IntIdOficina          IN  DB_COMERCIAL.ADMI_NUMERACION.OFICINA_ID%TYPE  (Oficina a la que pertenece la numeraci�n)
  * @param Fv_NumeracionUno         IN  DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_UNO%TYPE  (Primer secuencial de la numeraci�n a buscar)
  * @param Fv_NumeracionDos         IN  DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_DOS%TYPE  (Segundo secuencial de la numeraci�n a buscar)
  * @param Fv_CodigoNumeracion      IN  DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE  (C�digo de la numeraci�n a buscar)
  * @param Fv_EsOficinaFacturacion  IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE  (Par�metro que indica si es oficina de
  *                                                                                                   facturaci�n)
  * @param Fv_EsMatriz              IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE  (Par�metro que indica si la oficina es MATRIZ)
  * @param Fv_PrefijoEmpresa        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE  (Par�metro que indica el prefijo de la empresa)
  *
  * @return Lr_AdmiNumeracion
  */
  FUNCTION F_GET_ADMI_NUMERACION(
    Fv_EstadoActivo          IN  DB_COMERCIAL.ADMI_NUMERACION.ESTADO%TYPE,
    Fv_CodEmpresa            IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fn_IntIdOficina          IN  DB_COMERCIAL.ADMI_NUMERACION.OFICINA_ID%TYPE,
    Fv_NumeracionUno         IN  DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_UNO%TYPE,
    Fv_NumeracionDos         IN  DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_DOS%TYPE,
    Fv_CodigoNumeracion      IN  DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE,
    Fv_EsOficinaFacturacion  IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE,
    Fv_EsMatriz              IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE,
    Fv_PrefijoEmpresa        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
    RETURN DB_FINANCIERO.FNKG_TYPES.Lr_AdmiNumeracion;
  --
  --
  /**
  * Documentaci�n para FUNCTION 'F_GET_DOCUMENTOS_REPETIDOS'.
  *
  * Funci�n que obtiene los documentos que tienen el secuencial repetido y que van a ser regularizados
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 25-11-2016
  *
  * PARAMETROS:
  * @param Fv_CodEmpresa         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (C�digo de la empresa a regularizar)
  * @param Fv_EstadoActivo       IN  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE  (Estado 'Activo' del par�metro)
  * @param Fv_NombreParametro    IN  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE  (Nombre del par�metro cabecera)
  * @param Fv_DescripcionDetalle IN  DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE  (Descripci�n de los detalles)
  * @param Fv_ValorDocumentos    IN  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE  (Filtro para obtener los detalles respectivos)
  * @param Fv_NumeroFacturaSri   IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE  (Numero de factura SRI a buscar)
  * @param Fn_IdDocumento        IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  (Id del documento que se requiere buscar)
  *
  * @return C_DocumentosRepetidos
  */
  FUNCTION F_GET_DOCUMENTOS_REPETIDOS(
    Fv_CodEmpresa         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_EstadoActivo       IN  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
    Fv_NombreParametro    IN  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Fv_DescripcionDetalle IN  DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
    Fv_ValorDocumentos    IN  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    Fv_NumeroFacturaSri   IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    Fn_IdDocumento        IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN C_DocumentosRepetidos;
  --
  /**
  * Documentaci�n para PROCEDURE 'P_DESCARTA_PAGO_LINEA'.
  *
  * Procedure que regulariza los pagos en linea que se quedan en estado Pendiente, los mismos
  * para darse de baja deben tener un tiempo m�nimo de 24 horas.

  * COSTO QUERY del Cursor C_GetPagoPendiente: 836
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 11-11-2016
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.1 01-12-2016 - Se corrige el cursor 'C_GetPagoPendiente' para que reciba la fecha que a partir de aquella
  *                           se descarten los pagos en linea.
  *
  * PARAMETROS:
  * @param Pn_EmpresaId         IN   DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE          Id de la Empresa
  * @param Pt_FechaPlDescartar  IN   TIMESTAMP                                              Fecha a descartar
  * @param Pv_EstadoPl          IN   DB_FINANCIERO.INFO_PAGO_LINEA.ESTADO_PAGO_LINEA%TYPE   Estado del pago en linea
  * @param Pv_MsnResult         OUT  VARCHAR2                                               (Mensaje)
  * @param Pv_MessageError      OUT  VARCHAR2                                               (Mensaje de error en caso de
  *                                                                                         existir)
  */
  PROCEDURE P_DESCARTA_PAGO_LINEA(
    Pv_EmpresaId        IN  DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE,
    Pt_FechaPlDescartar IN  TIMESTAMP,
    Pv_EstadoPl         IN  DB_FINANCIERO.INFO_PAGO_LINEA.ESTADO_PAGO_LINEA%TYPE,
    Pv_MsnResult        OUT VARCHAR2,
    Pv_MessageError     OUT VARCHAR2);
  --
  /**
  * Documentaci�n para PROCEDURE 'P_SALDO_X_FACTURA_FECHA'.
  *
  * Procedure que obtiene el saldo de factura hasta la fecha que se desea consultar
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 21-10-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 22-11-2016 - Se corrige el cursor 'C_GetSumTotalNotasCredito' para que considere en la sumatoria a las Notas de Cr�dito No
  *                           Electr�nicas, para ello se verifica que el campo 'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION' se encuentre
  *                           dentro del rango de fecha solicitado por el usuario.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 10-01-2017 - Se modifica casteo del par�metro 'Pv_FeConsultaHasta' cuando la variable tiene un valor espec�fico para obtener una
  *                           mejor interpretaci�n de los ambientes que invocan la funci�n. El casteo realizado es:
  *                           'CAST(TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 15-09-2017 - Se agrega el par�metro 'Pv_TipoConsulta' para obtener el tipo de consulta o valor a retornar del procedimiento
  *
  * PARAMETROS:
  * @param Pn_IdDocumento      IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  (Id del documento que se desea consultar)
  * @param Pn_ReferenciaId     IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE  (Id de la referencia del documento)
  * @param Pv_FeConsultaHasta  IN  VARCHAR2  (Fecha hasta la cual se desea consultar el saldo)
  * @param Pv_TipoConsulta     IN VARCHAR2  (Tipo de consulta que se requiere obtener)
  * @param Pn_Saldo            OUT NUMBER  (Valor del saldo)
  * @param Pv_MessageError     OUT VARCHAR2  (Mensaje de error en caso de existir)
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.4 11-09-2018 - Se redondea a dos decimales los valores para el c�lculo del Saldo,obteniendo un saldo redondeado con dos decimales.

  */
  PROCEDURE P_SALDO_X_FACTURA_FECHA(
      Pn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pn_ReferenciaId    IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
      Pv_FeConsultaHasta IN VARCHAR2,
      Pv_TipoConsulta    IN VARCHAR2,
      Pn_Saldo           OUT NUMBER,
      Pv_MessageError    OUT VARCHAR2);
  --
  --
  /**
  * Documentaci�n para la funci�n 'F_GET_SECUENCIAL_DOCUMENTO'.
  *
  * Funci�n que obtiene los secuenciales de un documento electr�nico desglosandolo de su n�mero de documento (CAMPO: NUMERO_FACTURA_SRI)
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 31-01-2017
  *
  * PARAMETROS:
  * @param Fn_IdDocumento       IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  (Id del documento)
  * @param Fv_NumeroFacturaSri  IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE  (Numero de factura SRI)
  * @param Fv_TipoSecuencial    IN  VARCHAR2  (Tipo de secuencial requerido)
  * @return VARCHAR2  (Secuencial obtenido de la funci�n)
  */
  FUNCTION F_GET_SECUENCIAL_DOCUMENTO(
      Fn_IdDocumento      IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_NumeroFacturaSri IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
      Fv_TipoSecuencial   IN VARCHAR2 )
    RETURN VARCHAR2;
  --
  --
  /**
  * Documentacion para la funci�n F_GET_FORMA_PAGO_CLIENTE
  *
  * La funci�n retorna un VARCHAR2 con la letra 'S' si el cliente debe ser compensado y 'N' o NULL si fuese el caso contrario
  *
  * COSTO QUERY del Cursor C_GetFormaPagoPunto: 7
  * COSTO QUERY del Cursor C_GetFormaPagoContrato: 3
  * COSTO QUERY del Cursor C_GetFormaPagoPersonaRol: 3
  *
  * @param Pn_IdPersonaRol          IN   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE  Id del cliente de la tabla INFO_PERSONA_EMPRESA_ROL
  * @param Pn_IdPunto               IN   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  Id del punto del cliente
  * @param Pn_IdFormaPago           OUT  DB_FINANCIERO.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE Id de la forma de pago
  * @param Pn_CodigoFormaPago       OUT  DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE  Codigo de la forma de pago
  * @param Pv_DescripcionFormaPago  OUT  DB_FINANCIERO.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE  Descripci�n de la forma de pago
  * @param Pn_CodigoSri             OUT  DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE   Codigo del SRI
  * @param Pv_TipoFormaPago         OUT  DB_FINANCIERO.ADMI_FORMA_PAGO.TIPO_FORMA_PAGO%TYPE  Tipo de la forma de pago
  * @param Pv_FormaPagoObtenidaPor  OUT  VARCHAR2  Retorna un texto indicando por cual filtro fue obtenida la forma de pago, es decir 'CONTRATO',
  *                                                'PERSONA' o 'PUNTO'
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 14-10-2016
  */
  PROCEDURE P_GET_FORMA_PAGO_CLIENTE(
      Pn_IdPersonaRol         IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Pn_IdFormaPago          OUT DB_FINANCIERO.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
      Pv_CodigoFormaPago      OUT DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
      Pv_DescripcionFormaPago OUT DB_FINANCIERO.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
      Pv_CodigoSri            OUT DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE,
      Pv_TipoFormaPago        OUT DB_FINANCIERO.ADMI_FORMA_PAGO.TIPO_FORMA_PAGO%TYPE,
      Pv_FormaPagoObtenidaPor OUT VARCHAR2 );
  --
  /**
  * Documentacion para la funci�n F_VALIDA_CLIENTE_COMPENSADO
  *
  * La funci�n retorna un VARCHAR2 con la letra 'S' si el cliente debe ser compensado y 'N' o NULL si fuese el caso contrario
  *
  * @param  Fn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE  Id del cliente de la tabla INFO_PERSONA_EMPRESA_ROL
  * @param  Fn_OficinaId  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE  Id de la oficina a la cual pertenece el cliente
  * @param  Fn_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE  Codigo de la empresa a la cual pertenece el cliente
  * @param  Fn_IdSectorPunto  DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE  Id del sector al cual pertenece el cliente
  *
  * @return  VARCHAR2  Retorna un mensaje de error en caso de existir.
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 27-09-2016
  */
  FUNCTION F_VALIDA_CLIENTE_COMPENSADO(
      Fn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fn_OficinaId DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Fn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
      Fn_IdSectorPunto DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE,
      Fn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE )
    RETURN VARCHAR2;
  --
  --
  /**
  * Documentacion para la funci�n F_GET_TABLA_NAF_PLANTILLA_CAB
  *
  * La funci�n retorna el nombre de la tabla cabecera a la cual es migrado la informaci�n al NAF
  *
  * @param Fv_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (C�digo de la empresa)
  * @param Fn_FormaPagoId         IN DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE  (Id de la forma de pago)
  * @param Fv_CodigoTipoDocumento IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE  (Codigo del tipo de documento)
  * @param Fv_TipoProceso         IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TIPO_PROCESO%TYPE  (Tipo de proceso que se realiza)
  * @param Fv_Estado              IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.ESTADO%TYPE  (Estado de la plantilla contable cabecera)
  *
  * @return DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TABLA_CABECERA%TYPE  (Nombre de la tabla cabecera a la cual fue migrada la informaci�n al NAF)
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 03-02-2017
  */
  FUNCTION F_GET_TABLA_NAF_PLANTILLA_CAB(
      Fv_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Fn_FormaPagoId         IN DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
      Fv_CodigoTipoDocumento IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Fv_TipoProceso         IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TIPO_PROCESO%TYPE,
      Fv_Estado              IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.ESTADO%TYPE)
    RETURN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TABLA_CABECERA%TYPE;
  --
  --
  /**
  * Documentaci�n para PROCEDURE 'P_DOCUMENTOS_RELACIONADOS'.
  *
  * Funci�n que obtiene los documentos relacionados como pagos, notas de cr�ditos y notas de d�bito
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 15-09-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 21-10-2016 - Se agrega par�metro 'Pv_FeConsultaHasta' para consultar los documentos relacionados al documento hasta la fecha
  *                           enviada.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 18-11-2016 - Se valida que al traer las Notas de Cr�dito y Notas de Cr�dito Internas verifique con la fecha de consulta enviado en
  *                           el par�metro 'Pv_FeConsultaHasta', lo siguiente:
  *                           - Que se presente la NC si el campo 'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_AUTORIZACION' se encuentra dentro
  *                             del rango de fecha enviado.
  *                           - Que se presente la NC o NCI si el campo 'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_AUTORIZACION' es 'NULL' y el
  *                             campo 'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION' se encuentra dentro del rango de fecha enviado.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 20-12-2016 - Se modifica casteo del par�metro 'Pv_FeConsultaHasta' para obtener una mejor interpretaci�n de los ambientes que
  *                           invocan la funci�n. El casteo realizado es: 'CAST(Pv_FeConsultaHasta AS TIMESTAMP WITH LOCAL TIME ZONE)'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 10-01-2017 - Se modifica casteo del par�metro 'Pv_FeConsultaHasta' cuando la variable tiene un valor espec�fico para obtener una
  *                           mejor interpretaci�n de los ambientes que invocan la funci�n. El casteo realizado es:
  *                           'CAST(TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)'
  *
  * PARAMETROS:
  * @param DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Pn_IdFactura IN ( El id del documento al que se le quiere buscar los
  *                                                                                          documentos relacionados )
  * @param VARCHAR2  Pv_FeConsultaHasta  IN ( Fecha de consulta hasta donde se desea buscar los documentos relacionados al documento )
  * @param SYS_REFCURSOR  Pr_Documentos  OUT  ( Cursor con los documentos obtenidos de la consulta )
  */
  PROCEDURE P_DOCUMENTOS_RELACIONADOS(
      Pn_IdFactura       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_FeConsultaHasta IN VARCHAR2,
      Pr_Documentos      OUT SYS_REFCURSOR );
  --
  --
  /**
  * Documentacion para la funcion F_GET_MAX_DOCUMENTO
  *
  * La funcion retorna la m�xima factura dependiendo del puntoFacturacionId, puntoId y productoId del servicio, y el filtro que se env�e a consultar
  *
  * @param Fn_PuntoFacturacionId    IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @param Fn_PuntoId               IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE
  * @param Fn_ProductoId            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE
  * @param Fv_Filtro                IN VARCHAR2
  * return Fn_IdDocumento           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 17-08-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 12-10-2016 - Se cambia la funci�n para que retorne el primer registro de la consulta obtenida como tabla temporal en los cursores
  *                           'C_MaxDocumentoByMesAnioConsumo' y 'C_MaxDocumentoByRangoConsumo'
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.2 10-05-2018 - Se agrega Verificacion de que no exista NC o NCI Aplicada sobre la Factura.
  */
  FUNCTION F_GET_MAX_DOCUMENTO(
    Fn_PuntoFacturacionId IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
    Fn_PuntoId            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
    Fn_ProductoId         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE,
    Fv_Filtro             IN VARCHAR2)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  --
  --
  /**
  * Documentacion para el procedimiento FINP_PAGOPORANULAR
  *
  * EL procedimiento verifica que un documento pueda hacer anulado
  * Los tipos de documentos permitidos son 2 => Pagos, 3 => Anticipo, 4 => Anticipo sin cliente, 10 => Anticpo por cruce, 11 => Pago por cruce
  * El procedimiento tambien valida que un tipo de pago pueda ser anulado solo en el mes vigente o anular pagos del mes anterior hasta el quinto dia
  * del mes vigente
  *
  * @param Pn_IdPago    IN  INFO_PAGO_CAB.ID_PAGO%TYPE Recibe el IdPago
  * @param Pn_Resultado OUT INT Devuelve 1 si esta Ok en caso contrario 0
  * @param Pv_MsnError  OUT VARCHAR2 Devuelve el mensaje de error si existe algun conflicto
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.1 01-07-2014
  *
  * @Version 1.2 06-08-2014
  * @Code : 2
  * Se corrige la validacion que permite anular los pagos dentro del mes vigente, y pagos del mes anterior
  * hasta el quinto dia del mes en vigecia.
  * URL Referencia : https://bugtracker.zoho.com/portal/telcosis#buginfo/245613000001674083/245613000001745001
  *
  * @Version 1.3 16-06-2016  Andres Montero <amontero@telconet.ec>
  * @Code : 3
  * Se agrega cursor y validacion de anulacion de pago por empresa
  *
  * @Version 1.4 10-01-2017  Ricardo Coello Quezada <rcoello@telconet.ec>
  * @Code : 4
  * Se requiere que el valor permisible para anular los pagos (No de dias) sea mediante parametro previamente configurado.
  *
  * @Version 1.5 10-02-2017  Ricardo Coello Quezada <rcoello@telconet.ec>
  * @Code : 5
  * Se corrige implementaci�n de los d�as permisibles ya que se valido �nicamente cuando el mes es "12"
  * por el tema del cambio del a�o y no se valido para cuando sea diferente de "12"
  *
  * @Version 1.6 02-03-2017  Ricardo Coello Quezada <rcoello@telconet.ec>
  * @Code : 6
  * Se corrige implementaci�n de los d�as permisibles, se realiza nueva logica para permitir anular pagos de meses atras.
  * * Costo del query Cursor: C_GetInfoPagosCabDet 15
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.7 10-03-2017 - Se parametriza para TN los d�as permitidos para poder anular un pago.
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.8 15-09-2017 - Se agrega validacion para las empresas que CONTABILIZAN, en el caso de contabilizar se anula
  * el pago el mismo dia que se cre�.
  *
  * Costo del query Cursor: C_GetPagosMD: 15, C_GetPagosTN: 15, Lc_GetContabilizacionEmpresa: 5,
  *
  */
  PROCEDURE FINP_PAGOPORANULAR(
      Pn_IdPago    IN  INFO_PAGO_CAB.ID_PAGO%TYPE,
      Pn_Resultado OUT INT,
      Pv_MsnError  OUT VARCHAR2);
  --
  FUNCTION GET_EMPRESA_DATA(
      Pn_IdEmpresa      IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Estado         IN INFO_EMPRESA_GRUPO.ESTADO%TYPE,
      Pv_DocElectronico IN VARCHAR2)
    RETURN XMLTYPE;
  --
  /*Inicio de ATS*/
  /**
* Documentacion para la funcion GET_VALOR_RETENCIONBYDOC
*
* La funci�n retorna el valor retenido de la fuente e iva por documento.
*
* @param Pn_IdDocumento               IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
* @param Pv_TipoRetencion             IN VARCHAR2
*
* return INFO_PAGO_DET.VALOR_PAGO%TYPE
*
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.0 05-09-2016
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1 10-07-2019 - Se modifica querys de recuperacion para eliminar los valores fijos y leer desde parametrizacion de retenciones
*
* Costo del query de los cursores:  C_GetValorRetencionByDoc      10
*/
  FUNCTION GET_VALOR_RETENCIONBYDOC(
      Pn_IdDocumento   IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_TipoRetencion IN VARCHAR2)
    RETURN INFO_PAGO_DET.VALOR_PAGO%TYPE;
  /**/
    /**
* Documentacion para el procedimiento GET_NUM_ESTABLECIMIENTOS
* La funcion retorna el numero de establecimientos de la empresa.
*
* @param INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE IN Pn_IdEmpresa   Recibe el ID de la empresa
* @param VARCHAR2                            IN Pv_FechaInicio Recibe la fecha de Inicio de la consulta
* @param VARCHAR2                            IN Pv_FechaFin    Recibe la fecha fin de la consulta
* return NUMBER                                 Retorna el numero de establecimientos de la empresa.
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 18-08-2014
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.1 12-12-2016 - Se actualiza filtro de busqueda FE_EMISION a FE_AUTORIZACION.
* Costo del query del cursor C_GetNumEstablecimientos 356
*
* @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
* @version 1.2 28-02-2018 - Se modifica para que en los parametros de Pv_FechaInicio y Pv_FechaFin se consulte por FeEmision
* de la Factura y ya no por FeAutorizacion.
*/
  FUNCTION GET_NUM_ESTABLECIMIENTOS(
      Pn_IdEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_FechaInicio IN VARCHAR2,
      Pv_FechaFin    IN VARCHAR2)
    RETURN NUMBER;
  /**/
  /**
* Documentacion para el procedimiento GET_VENTAS_ESTABLECIMIENTOS
* La funcion retorna la suma del total de ventas por establecimientos de la empresa
*
* @param INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE IN Pn_IdEmpresa         Recibe el ID de la empresa
* @param VARCHAR2                            IN Pv_FechaInicio       Recibe la fecha de Inicio de la consulta
* @param VARCHAR2                            IN Pv_FechaFin          Recibe la fecha fin de la consulta
* @param DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS    IN Pv_Pais              Recibe Pais de origen del ATS
* @param VARCHAR2                            IN Pv_EncerarTotales    Recibe SI/NO encera totales en detalle de ventas
* return XMLTYPE                                Devuelve un XMLELEMENT segmentando los establecimientos y el total de sus ventas
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 18-08-2014
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.1 12-12-2016 - Se agrega filtro de Pais de origen del ATS, descuento por compensacion, iva compensado.
*                           Cambio de filtro de busqueda FE_EMISION a FE_AUTORIZACION.
*
* Costo del cursor:  C_GetVentasEstab 356
*
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.2 13-02-2017 - Se realiza correcion y ajustes al valor de compensacion de Facturas y Notas de credito dentro
*                           del cursor C_GetVentasEstab.
*
* Costo del cursor:  C_GetVentasEstab 368
*
* @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
* @version 1.3 28-02-2018 - Se modifica para que en los parametros de Pv_FechaInicio y Pv_FechaFin se consulte por FeEmision
* de la Factura y ya no por FeAutorizacion.
*/
  FUNCTION GET_VENTAS_ESTABLECIMIENTOS(
      Pn_IdEmpresa      IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_FechaInicio    IN VARCHAR2,
      Pv_FechaFin       IN VARCHAR2,
      Pv_Pais           IN DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE,
      Pv_EncerarTotales IN VARCHAR2)
    RETURN XMLTYPE;
  /**/
  /**
* Documentacion para el procedimiento GET_TOTAL_VENTAS
* La funcion retorna la suma del total de ventas sin segmentar por establecimientos.
*
* @param INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE         IN Pn_IdEmpresa    Recibe el ID de la empresa
* @param VARCHAR2                                    IN Pv_FechaInicio  Recibe la fecha de Inicio de la consulta
* @param VARCHAR2                                    IN Pv_FechaFin     Recibe la fecha fin de la consulta
* return INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE    Retorna el valor total de ventas de la empresa.
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 18-08-2014
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.1 12-12-2016 - Se actualiza filtro de busqueda FE_EMISION a FE_AUTORIZACION.
*                           Se agrega filtro Pais de origen del ATS, obtener total de ventas 'Ecuador'.
* Costo del query del cursor GetTotalVentas: 635
*
* @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
* @version 1.2 28-02-2018 - Se modifica para que en los parametros de Pv_FechaInicio y Pv_FechaFin se consulte por FeEmision
* de la Factura y ya no por FeAutorizacion.
*/
  FUNCTION GET_TOTAL_VENTAS(
      Pn_IdEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_FechaInicio IN VARCHAR2,
      Pv_FechaFin    IN VARCHAR2,
      Pv_Pais        IN DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE)
    RETURN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
  /**/
  /**
* Documentacion para el procedimiento GET_NUM_AUTORIZACION
* La funcion retorna el numero de autorizacion de una factura anulada.
*
* @param INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE                       IN Pn_IdEmpresa           Recibe el ID de la empresa
* @param ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE IN Pn_CodigoTipoDocumento Recibe el tipo de codigo del documento
* @param VARCHAR2                                                  IN Pv_Secuencia           Recibe la secuencia de la factura
* return ADMI_NUMERACION_HISTO.NUMERO_AUTORIZACION%TYPE                                      Retorna el numero de autorizacion de la factura.
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 18-08-2014
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.1 12-12-2016 - Se actualiza filtro de busqueda FE_EMISION a FE_AUTORIZACION.
*                           Se agrega filtro Pais de origen del ATS, obtener total de ventas 'Ecuador'.
* Costo del query del cursor C_GetNumAutorizacionMD: 6
*                            C_GetNumAutorizacionTN: 6
*/
  FUNCTION GET_NUM_AUTORIZACION(
      Pn_IdEmpresa           IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pn_CodigoTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_Secuencia           IN VARCHAR2)
    RETURN ADMI_NUMERACION_HISTO.NUMERO_AUTORIZACION%TYPE;
  /**/
  /**
* Documentacion para el procedimiento GET_DOC_ANULADOS
* La funcion retorna el numero de autorizacion de una factura anulada.
*
* @param INFO_EMPRESA_GRUPO.COD_EMPRESA%TYP IN Pn_IdEmpresa   Recibe el ID de la empresa
* @param VARCHAR2                           IN Pv_FechaInicio Recibe la fecha de inicio para la consulta de los documentos anulados
* @param VARCHAR2                           IN Pv_FechaFin    Recibe la fecha fin para la consulta de los documentos anulados
* return ADMI_NUMERACION_HISTO.NUMERO_AUTORIZACION%TYPE       Retorna UN XMLELEMENT de los documentos anulados
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 18-08-2014
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.1 12-12-2016 - Se agrego el numero de autorizacion y se realizo el cambio de filtro de busqueda FE_EMISION
*                           a FE_AUTORIZACION.
* Costo del query del cursor: C_GetDocsAnulados 232
*
* @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
* @version 1.2 28-02-2018 - Se modifica para que en los parametros de Pv_FechaInicio y Pv_FechaFin se consulte por FeEmision
* de la Factura y ya no por FeAutorizacion.
*/
  FUNCTION GET_DOC_ANULADOS(
      Pn_IdEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_FechaInicio IN VARCHAR2,
      Pv_FechaFin    IN VARCHAR2)
    RETURN XMLTYPE;
  /**/
  /**
* Documentacion para el procedimiento GET_ATS
* Procedimiento genera el ATS
*
* @param INFO_EMPRESA_GRUPO.COD_EMPRESA%TYP     IN  Pn_IdEmpresa    Recibe el ID de la empresa
* @param VARCHAR2                               IN  Pv_FechaInicio  Recibe la fecha de inicio para la generacion del ATS
* @param VARCHAR2                               IN  Pv_FechaFin     Recibe la fecha fin  para la generacion del ATS
* @param CLOB                                   OUT Pxml_Ats        Retorna el ATS en formato CLOB
* @param NUMBER                                 OUT Pn_Tamanio      Retorna el tamanio del ATS
* @param @param INFO_EMPRESA_GRUPO.PREFIJO%TYPE OUT Pv_PreEmpresa   Retorna el prefijo de la empresa
* @param VARCHAR2                               OUT Pv_MessageError Retorna un un mensaje de error
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 18-08-2014
* @version 1.1 10-11-2014
* @version 1.2 07-09-2015
* @since   1.1
* @author Ricardo Coello Quezada <rcoello@telconet.ec>
* @version 1.3 12-12-2016 - Se actualiza el xml para que soporte los nuevos tags de acuerdo a la ficha tecnica de 07/2016.
*                           Se agrega reembolsos y detalle de exportaciones solo para TN.
*                           Se agrega compensacion solidaria para aquellos clientes afectados por el terromoto.
*                           Se actualiza procedimientos en general, se cambia filtro de busqueda de FE_EMISION a
*                           FE_AUTORIZACION, se agrega filtro de busqueda por pais de origen del ATS Ecuador.
*
* @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
* @version 1.4 28-02-2018 - Se modifica para que en los parametros de Pv_FechaInicio y Pv_FechaFin se consulte por FeEmision
* de la Factura y ya no por FeAutorizacion.
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.5 29-08-2019 - Se modifica para eliminar datos de compensaciones en archivo XML
*/
  PROCEDURE GET_ATS(
      Pn_IdEmpresa     IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_FechaInicio   IN  VARCHAR2,
      Pv_FechaFin      IN  VARCHAR2,
      Pxml_Ats         OUT CLOB,
      Pn_Tamanio       OUT NUMBER,
      Pv_PreEmpresa    OUT INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_MessageError  OUT VARCHAR2);
  --
  /*Fin de ATS*/
  FUNCTION F_GET_ERROR_REPETIDO(
    Fv_Mensaje IN VARCHAR2)
  RETURN BOOLEAN;
  --
  FUNCTION FUN_COUNT_COMPROBANTES(
      Fn_IdEstado     IN INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
      Fn_IdOficina    IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Fv_CodDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Fv_FechaInicio  IN VARCHAR2,
      Fv_FechaFin     IN VARCHAR2) RETURN NUMBER;
  --
  FUNCTION F_GET_ADMI_PARAMETROS_DET(
      Fv_NombreParameteroCab IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
      Fv_EstadoParametroCab  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
      Fv_EstadoParametroDet  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
      Fv_Valor1              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
      Fv_Valor2              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
      Fv_Valor3              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
      Fv_Valor4              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE )
    RETURN SYS_REFCURSOR;
    --
  FUNCTION F_GET_ALIAS_PLANTILLA(
      Fv_CodigoPlantilla IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
    RETURN FNKG_TYPES.Lr_AliasPlantilla;
    --
  PROCEDURE P_SEND_MAIL(
      Pv_From       IN  VARCHAR2,
      Pv_To         IN  VARCHAR2,
      Pv_Subject    IN  VARCHAR2,
      Pv_Message    IN  VARCHAR2,
      Pv_MimeType   IN  VARCHAR2,
      Pv_MsnError   OUT VARCHAR2);
    --
  FUNCTION F_GET_HISTORIAL_DOC(
      Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_EstadoHistorial IN INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE)
    RETURN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    --
  FUNCTION F_GET_FACT_CAB_BY_NC(
      Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    --
  FUNCTION F_GET_FORMA_PAGO(
      Fn_IdFormaPago     IN ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
      Fv_CodigoFormaPago IN ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE)
    RETURN FNKG_TYPES.Lrf_AdmiFormaPago;
    --
  FUNCTION F_GET_INFO_PAGO_CAB(
      Fn_IdPago IN INFO_PAGO_CAB.ID_PAGO%TYPE)
    RETURN INFO_PAGO_CAB%ROWTYPE;
    --
  FUNCTION F_GET_INFO_PAGO_DET(
      Fn_IdPagoDet IN INFO_PAGO_DET.ID_PAGO_DET%TYPE,
      Fn_IdPago    IN INFO_PAGO_CAB.ID_PAGO%TYPE,
      Fv_Estado    IN INFO_PAGO_DET.ESTADO%TYPE)
    RETURN FNKG_TYPES.Lrf_InfoPagoDet;
    --
  FUNCTION F_GET_NUMERACION(
      Fv_PrefijoEmpresa       IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Fv_EsMatriz             IN INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE,
      Fv_EsOficinaFacturacion IN INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE,
      Fn_IdOficina            IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Fv_CodigoNumeracion     IN ADMI_NUMERACION.CODIGO%TYPE)
    RETURN FNKG_TYPES.Lrf_AdmiNumeracion;
    --
  FUNCTION F_GET_ADMI_MOTIVO(
      Fn_IdMotivo IN ADMI_MOTIVO.ID_MOTIVO%TYPE)
    RETURN ADMI_MOTIVO%ROWTYPE;
  --
  FUNCTION F_GET_TIPO_DOC_FINANCIERO(
      Fn_IdTipoDocFinan     IN ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
      Fv_CodigoTipoDocFinan IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE )
    RETURN ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
    --
  FUNCTION F_GET_INFO_DOC_FINANCIERO_CAB(
      Fn_IdDocumento           IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fn_ReferenciaDocumentoId IN INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE)
    RETURN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    --
  FUNCTION F_GET_INFO_DOC_FINANCIERO_DET(
      Fn_IdDocDetalle IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
      Fn_DocumentoId  IN INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE)
    RETURN SYS_REFCURSOR;
  --
  FUNCTION F_GET_INFO_DOC_FINANCIERO_IMP(
      Fn_IdDocImp     IN INFO_DOCUMENTO_FINANCIERO_IMP.ID_DOC_IMP%TYPE,
      Fn_DetalleDocId IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
    RETURN SYS_REFCURSOR;
  --
  FUNCTION F_GET_INFO_DOC_FINANCIERO_HST(
      Fn_IdDocHistorial IN INFO_DOCUMENTO_HISTORIAL.ID_DOCUMENTO_HISTORIAL%TYPE,
      Fn_IdDocumento    IN INFO_DOCUMENTO_HISTORIAL.DOCUMENTO_ID%TYPE )
    RETURN SYS_REFCURSOR;
  --
  FUNCTION F_GET_INFO_PUNTO(
      Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
      Fn_Login   IN INFO_PUNTO.LOGIN%TYPE)
    RETURN INFO_PUNTO%ROWTYPE;
  --
  FUNCTION F_GET_PREFIJO_BY_PUNTO(
      Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
      Fn_Login   IN INFO_PUNTO.LOGIN%TYPE)
    RETURN INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  --
  FUNCTION F_GET_NOMBRE_COMPLETO_CLIENTE(
    Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2;
  --
  FUNCTION F_GET_INFO_PERSONA_FORMA_CONT(
    Fv_Codigo IN ADMI_FORMA_CONTACTO.CODIGO%TYPE,
    Fv_Login  IN INFO_PERSONA.LOGIN%TYPE)
  RETURN VARCHAR2;
  --
  FUNCTION F_CLOB_REPLACE(
      Fc_String  IN CLOB,
      Fv_Search  IN VARCHAR,
      Fc_Replace IN CLOB )
    RETURN CLOB;
  --
  FUNCTION F_GET_DIFERENCIAS_FECHAS(
    Fv_FechaInicio IN VARCHAR2,
    Fv_FechaFin    IN VARCHAR2)
  RETURN NUMBER;
  --
  FUNCTION F_GET_SALDO_DISPONIBLE_BY_NC(
      Fn_IdDocumento           IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER;
  --
  FUNCTION F_GET_VALOR_SIMULADO_NC(
    Fn_IdDocumento         IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_PorcentajeServicio  IN VARCHAR2,
    Fn_Porcentaje          IN NUMBER,
    Fv_ProporcionalPorDias IN VARCHAR2,
    Fv_FechaInicio         IN VARCHAR2,
    Fv_FechaFin            IN VARCHAR2,
    Fv_ValorOriginal       IN VARCHAR2)
  RETURN NUMBER;
  --
  FUNCTION F_GET_PREF_EMPRESA_BY_OFICINA(
    Fn_IdOficina IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE)
  RETURN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  --
  FUNCTION F_CAMBIO_ESTADO_PERMITIDO(
    Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_EstadoActual    IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    Fv_EstadoNuevo     IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    Fn_IdOficina       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fn_IdTipoDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE,
    Fv_NombreParametro IN VARCHAR2,
    Fv_EstadoParamCab  IN VARCHAR2,
    Fv_EstadoParamDet  IN VARCHAR2)
  RETURN BOOLEAN;
  --
  FUNCTION F_EXISTE_ADMI_PARAMETROS_DET(
    Fv_NombreParameteroCab IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Fv_EstadoParametroCab  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
    Fv_EstadoParametroDet  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
    Fv_Valor1              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
    Fv_Valor2              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    Fv_Valor3              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
    Fv_Valor4              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE)
  RETURN BOOLEAN;
  --
  FUNCTION F_GET_PREFIJO_EMPRESA(
      Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  --
  FUNCTION F_GET_NOMBRE_CANTON(
    Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE;
  --
  FUNCTION F_TRUNC_BY_DELIMETER(
    Fv_String               IN VARCHAR2,
    Fv_DelimitadorTruncar   IN VARCHAR2,
    Fn_NumeroTruncar        IN NUMBER)
  RETURN VARCHAR2;


  /**
  * Documentaci�n para F_GET_BANCO
  * Retorna descripcion del banco.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 12-09.2016
  *
  * @param Fn_BancoCtaContableId NUMBER Recibe el ID de la cuenta contable asociada al banco
  * @return VARCHAR2
  *
  * Se reemplaza la inserci�n del error por dbms_output.put_line,
  * para evitar error ORA-14551: cannot perform a DML operation inside a query.
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.1 20-01-2017
  */

  FUNCTION F_GET_BANCO(
    Fn_BancoCtaContableId NUMBER)
  RETURN VARCHAR2 ;



  /**
  * Documentaci�n para F_GET_BANCO_EMPRESA

  * Retorna descripcion y la cuenta contable del banco.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 12-09.2016
  *
  * @param Fn_BancoCtaContableId IN DB_FINANCIERO.INFO_PAGO_DET.BANCO_CTA_CONTABLE_ID%TYPE  (Recibe el Id del banco cuenta contable asociada)
  * @param Fn_CuentaContableId   IN DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE  (Recibe el Id de la cuenta contable)
  *
  * @return DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE  (Descripci�n de la cuenta contable)
  *
  * Se reemplaza la inserci�n del error por dbms_output.put_line, para evitar error ORA-14551: cannot perform a DML operation inside a query.
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.1 20-01-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 03-02-2017 - Se agrega el par�metro 'Fn_CuentaContableId' a la funci�n para buscar la descripci�n de la cuenta contable en la tabla
  *                          'DB_FINANCIERO.ADMI_CUENTA_CONTABLE'. Adicional se cambia la b�squeda del par�metro 'Fn_BancoCtaContableId' para que
  *                          consulte la descripci�n del banco cuenta contable en la tabla 'DB_GENERAL.ADMI_BANCO_CTA_CONTABLE'.
  */
  FUNCTION F_GET_BANCO_EMPRESA(
      Fn_BancoCtaContableId IN DB_FINANCIERO.INFO_PAGO_DET.BANCO_CTA_CONTABLE_ID%TYPE,
      Fn_CuentaContableId   IN DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE )
    RETURN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE;

  /**
  * Documentaci�n para F_GET_BANCO_EMPRESA_DEP
  * Retorna descripcion y la cuenta contable del banco.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 12-09.2016
  *
  * @param Fn_DepositoCtaContableId Recibe el ID de la cuenta contable asociada a un deposito
  * @return VARCHAR2
  *
  * Se reemplaza la inserci�n del error por dbms_output.put_line,
  * para evitar error ORA-14551: cannot perform a DML operation inside a query.
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.1 20-01-2017
  */

  FUNCTION F_GET_BANCO_EMPRESA_DEP(
    Fn_DepositoCtaContableId    NUMBER)
  RETURN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE;


  /**
  * Documentaci�n para F_GET_BANCO_EMPRESA_DEP_NAF
  * Retorna descripcion y la cuenta contable del banco.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 12-09.2016
  *
  * @param Fn_DepositoBancoNafId Recibe el ID de la cuenta contable asociada a un deposito bco naf
  * @return VARCHAR2
  *
  * Se reemplaza la inserci�n del error por dbms_output.put_line,
  * para evitar error ORA-14551: cannot perform a DML operation inside a query.
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.1 20-01-2017
  */
  FUNCTION F_GET_BANCO_EMPRESA_DEP_NAF(
    Fn_DepositoBancoNafId    NUMBER)
  RETURN DB_GENERAL.ADMI_BANCO_CTA_CONTABLE.DESCRIPCION%TYPE;

  /**
   * Documentaci�n para GET_INFORMACION_CARACTERISTICA
   * Retorna el valor de la caracteristica asociada al documento
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09.2016
   *
   * @param Fn_IdDocumento NUMBER Recibe el ID del documento
   * @param Fv_Caracteristica Recibe la descripcion de la caracteristica
   * @return VARCHAR2
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.1 20-01-2017
   */
  FUNCTION F_GET_VALOR_CARACTERISTICA(
    Fn_IdDocumento NUMBER,
    Fv_Caracteristica VARCHAR2)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE;

  /**
   * Documentaci�n para F_GET_DOCUMENTO_APLICA
   * Retorna el n�mero de documento al que aplica una NC
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09.2016
   *
   * @param Fn_ReferenciaDocumentoId NUMBER Recibe el ID del documento al cual aplica
   * @return VARCHAR2
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.1 20-01-2017
   *
   * @author Edgar Holgu�n <eholguin@telconet.ec>
   * @version 1.2 29-06-2017 Se realiza correcci�n para que consulte por el campo ID_DOCUMENTO
   */
  FUNCTION F_GET_DOCUMENTO_APLICA(
    Fn_ReferenciaDocumentoId NUMBER)
  RETURN VARCHAR2;


  /**
   * Documentaci�n para F_GET_MOTIVO_DOCUMENTO
   * Retorna el motivo asociado al documento
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09.2016
   *
   * @param Fn_IdDocumento NUMBER Recibe el ID del documento
   * @return VARCHAR2
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.1 20-01-2017
   */
  FUNCTION F_GET_MOTIVO_DOCUMENTO(
    Fn_IdDocumento NUMBER)
  RETURN VARCHAR2;

  /**
   * Documentaci�n para F_GET_PAGOS_APLICA_ND
   * Retorna el n�mero de pago al que aplica una ND
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09.2016
   *
   * @param Fn_IdDocumento NUMBER Recibe el ID del documento (Nota de debito)
   * @return VARCHAR2
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.1 20-01-2017
   */
  FUNCTION F_GET_PAGOS_APLICA_ND(
    Fn_IdDocumento NUMBER)
  RETURN VARCHAR2;


  /**
   * Documentaci�n para F_GET_VALOR_RETENCIONES
   * Retorna Devuelve la suma de valores de pagos que sean forma de pago Retencion 8% o 2% y esten en estado Cerrado y Activo
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09-2016
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.1 26-10-2016 Se agrega redondeo a dos decimales en el resultado de la consulta.
   *
   * @param Fn_IdDocumento NUMBER Recibe el ID del documento (Nota de debito)
   * @param Fv_CodigosFormaPago VARCHAR2 Codigos de las formas de pago de la cual se quiere obtener la suma
   * @param Fv_DescripcionFormaPago VARCHAR2 Descripcion de la forma de pago de la cual se quiere obtener la suma.
   * @return INFO_PAGO_DET.VALOR_PAGO%TYPE
   *
   * Se agrega parametros de codigo y descripci�n de forma de pago
   * se convierte el query de est�tico a din�mico.
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.2 29-12-2016 .
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.3 20-01-2017
   */
  FUNCTION F_GET_VALOR_RETENCIONES(
    Fn_IdDocumento NUMBER,
    Fv_CodigosFormaPago VARCHAR2,
    Fv_DescripcionFormaPago VARCHAR2)
  RETURN DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE;

  /**
   * Documentaci�n para F_GET_COMENTARIO_ND
   * Retorna comentario de pago(s) al que aplica una ND
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09.2016
   *
   * @param Fn_IdDocumento NUMBER Recibe el ID del documento (Nota de debito)
   * @return VARCHAR2
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.1 20-01-2017
   */

  FUNCTION F_GET_COMENTARIO_ND(
    Fn_IdDocumento NUMBER)
  RETURN VARCHAR2;

  /**
   * Documentaci�n para F_GET_VALOR_IMPUESTO
   * Retorna el valor del impuesto asociada al documento y al tipo de documento.
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09.2016
   *
   * @param Fn_IdDocumento NUMBER Recibe el ID del documento
   * @param Fv_TipoImpuesto Recibe el codigo de tipo de impuesto
   * @return VARCHAR2
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.1 20-01-2017
   */
  FUNCTION F_GET_VALOR_IMPUESTO(
    Fn_IdDocumento NUMBER,
    Fv_TipoImpuesto VARCHAR2)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE;

  /**
   * Documentaci�n para F_GET_DESCRIPCION_FACTURA
   * Retorna la observacion asociada al historial activo del  documento .
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09-2016
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.1 24-10-2016 -Se agrega par�metro de entrada Fv_UsrCreacion, se elimina discriminaci�n por estado Activo.
   *
   * @param Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el ID del documento
   * @return VARCHAR2
   * @param Fv_UsrCreacion DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE Recibe el usr_creacion del documento.
   * @return VARCHAR2
   */
  FUNCTION F_GET_DESCRIPCION_FACTURA(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_UsrCreacion IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE;


  /**
   * Documentaci�n para F_GET_FORMA_PAGO_CONTRATO
   * Retorna la forma de pago asociada al contrato
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09.2016
   *
   * @param Fn_IdPersonaEmpresaRol NUMBER Recibe el ID persona empresa rol
   * @return VARCHAR2
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.1 20-01-2017
   */

  FUNCTION F_GET_FORMA_PAGO_CONTRATO(
    Fn_IdPersonaEmpresaRol    NUMBER)
  RETURN DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE;

  /**
   * Documentaci�n para F_GET_FECHA_PAGOS_APLICA_ND
   * Retorna fecha del pago al que aplica una ND
   *
   * @author Edgar Holguin <eholguin@telconet.ec>
   * @version 1.0 12-09.2016
   *
   * @param Fn_IdDocumento NUMBER Recibe el ID del documento (Nota de debito)
   * @return VARCHAR2
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.1 20-01-2017
   */
  FUNCTION F_GET_FECHA_PAGOS_APLICA_ND(
    Fn_IdDocumento NUMBER)
  RETURN VARCHAR2;

 /**
  * Documentaci�n para F_GET_BANCO_TC
  * Retorna descripcion del banco.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 29-09.2016
  *
  * @param Fn_BancoTipoCtaId NUMBER Recibe el ID del tipo cuenta asociada al banco
  * @return VARCHAR2
  *
  * Se reemplaza la inserci�n del error por dbms_output.put_line,
  * para evitar error ORA-14551: cannot perform a DML operation inside a query.
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.1 20-01-2017
  */

  FUNCTION F_GET_BANCO_TC(
    Fn_BancoTipoCtaId NUMBER)
  RETURN VARCHAR2 ;

  --
  PROCEDURE P_GET_ALIAS_PLANTILLA(
      Pv_CodigoPlantilla IN  DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
      Pv_Alias           OUT CLOB,
      Pv_Plantilla       OUT CLOB,
      Pv_MessageError    OUT VARCHAR2 );
  --
  --
  /**
  * Documentacion para el procedimiento P_DETALLE_NOTAS_DEBITO
  * El procedimiento P_DETALLE_NOTAS_DEBITO obtiene todos los documentos enlazados a las notas de debito segun los pagos obtenidos
  * Este procedimiento es recursivo debido a eso el uso de variables IN/OUT para acumular valores
  *
  * @param  Pn_IdDocumento     IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Recibe el id de la factura
  * @param  Pv_FeConsultaHasta IN  VARCHAR2  Fecha hasta la cual se requiere consultar los detalles de las notas de d�bito
  * @param  Ln_TotalPago       IN OUT NUMBER  Retorna el total acumulado de pagos
  * @param  Ln_TotalND         IN OUT NUMBER  Retorna el total acumulado de notas de debito
  * @param  Ln_TotalNC         IN OUT NUMBER  Retorna el total acumulado de notas de credito
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 24-02-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 15-09-2016 - Se modifica el m�todo para usar la funci�n 'P_DOCUMENTOS_RELACIONADOS' que est� dentro del package
  *                           'DB_FINANCIERO.FNCK_CONSULTS'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 21-10-2016 - Se modifica l procedimiento para que reciba como par�metro la fecha hasta la cual se requiere consultar los detalles
  *                           de la nota de d�bito
  */
  PROCEDURE P_DETALLE_NOTAS_DEBITO(
      Pn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_FeConsultaHasta IN VARCHAR2,
      Pn_TotalPago       IN OUT NUMBER,
      Pn_TotalND         IN OUT NUMBER,
      Pn_TotalNC         IN OUT NUMBER);
  --
  --
  /**
  * Documentacion para el procedimiento P_SALDO_X_FACTURA
  * El procedimiento P_SALDO_X_FACTURA obtiene el saldo de la factura a consultar, considerando pagos, nc, nd, dev, nci, ndi
  *
  * @param  Pn_IdDocumento  IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE               Recibe el id de la factura
  * @param  Pn_ReferenciaId IN  INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE    Recibe el id referencia del documento
  * @param  Pn_Saldo        OUT NUMBER                                                        Retorna el saldo
  * @param  Pv_MessageError OUT VARCHAR2                                                      Retorna un mensaje de error en caso de existir
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 09-01-2015                                                     Retorna un mensaje de error en caso de existir
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 21-10-2016 - Se agrega NULL como par�metro de 'FeConsultaHasta' a la funcion 'P_DETALLE_NOTAS_DEBITO' que es utilizada en este
  *                           procedimiento
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.2 10-09-2018 - Se redondea a dos decimales los valores para el c�lculo del Saldo,obteniendo un saldo redondeado con dos decimales.
  */
  PROCEDURE P_SALDO_X_FACTURA(
      Pn_IdDocumento  IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pn_ReferenciaId IN INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
      Pn_Saldo        OUT NUMBER,
      Pv_MessageError OUT VARCHAR2);
    --
  PROCEDURE P_APLICA_NOTA_CREDITO(
      Pn_IdDocumento            IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pn_RefereneciaDocumentoId IN  INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
      Pn_OficinaId              IN  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pv_MessageError           OUT VARCHAR2 );
  --
  PROCEDURE P_SPLIT_CLOB(
      Pc_String       IN  CLOB,
      Pv_Delimitador  IN  VARCHAR2,
      Prf_Results     OUT SYS_REFCURSOR,
      Pv_MessageError OUT VARCHAR2);
  --
  PROCEDURE P_CREA_NOTA_CREDITO(
      Pn_IdDocumento            IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pn_TipoDocumentoId        IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_Observacion            IN INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
      Pn_IdMotivo               IN ADMI_MOTIVO.ID_MOTIVO%TYPE,
      Pv_UsrCreacion            IN INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pv_Estado                 IN INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE,
      Pv_ValorOriginal          IN VARCHAR2,
      Pv_PorcentajeServicio     IN VARCHAR2,
      Pn_Porcentaje             IN NUMBER,
      Pv_ProporcionalPorDias    IN VARCHAR2,
      Pv_FechaInicio            IN VARCHAR2,
      Pv_FechaFin               IN VARCHAR2,
      Pn_IdOficina              IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pn_IdEmpresa              IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pn_ValorTotal             OUT INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
      Pn_IdDocumentoNC          OUT INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_ObservacionCreacion    OUT VARCHAR2,
      Pbool_Done                OUT BOOLEAN,
      Pv_MessageError           OUT VARCHAR2);

  --
  PROCEDURE P_CREA_NOTA_CREDITO_MASIVA(
      Pc_String           IN CLOB,
      Pv_Delimitador      IN VARCHAR2,
      Pv_Observacion      IN INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
      Pn_IdMotivo         IN ADMI_MOTIVO.ID_MOTIVO%TYPE,
      Pv_UsrCreacion      IN INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pv_Estado           IN INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE,
      Pv_TipoNotaCredito  IN VARCHAR2,
      Pn_IdOficina        IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pn_IdEmpresa        IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pn_Porcentaje       IN NUMBER,
      Pv_FechaInicio      IN VARCHAR2,
      Pv_FechaFin         IN VARCHAR2,
      Pv_MsnResult       OUT VARCHAR2,
      Pv_MessageError    OUT VARCHAR2);
  --
  --
/*
 * Documentaci�n para FUNCION 'F_GET_INFORMACION_PUNTO'.
 * Funcion que obtiene informaci�n del punto del cliente
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 15-05-2016 - Se agrega que busque todos los telefonos de contacto de la persona en los puntos de estado 'Activo', 'Cancelado' o
 *                           'Trasladado'
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.2 02-09-2016 - Se agrega la columna de 'emailPtoPersona' que retorna todos los email de todos los puntos de una persona
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.4 26-07-2016 - Se cambia la forma de consultar la forma de pago, y se a�aden nuevas consultas que son: 'coordenadas', 'bancoTarjeta',
 *                           'tipoCuentaBancoTarjeta', 'retiroEquipo'
 *
 * @author Edgar Holgu�n <eholguin@telconet.ec>
 * @version 1.5 02-09-2019 - Se agrega columna CANCELACION VOLUNTARIA para indicar si cliente factur� por dicho rubro.
 *
 * PARAMETROS:
 * @Param DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE          Fn_IdPersona     (id_persona del cliente)
 * @Param DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE                Fv_EstadoPunto   (estado del punto del cliente)
 * @Param DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Fv_EmpresaCod    (empresa del punto del cliente)
 * @Param VARCHAR2                                           Fv_Filtro        (es el filtro de lo que se desea buscar)
 * @return VARCHAR2                                          Fv_Resultado     (valor de la forma de contacto)
 */
FUNCTION F_GET_INFORMACION_PUNTO(
    Fn_IdPersona    DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    Fv_EstadoPunto  DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
    Fv_EmpresaCod   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_Filtro       VARCHAR2 )
RETURN VARCHAR2;
--
--
/*
 * Documentaci�n para FUNCION 'F_GET_NOMBRE_APELLIDOS_PERSONA'.
 * Funcion que obtiene informaci�n del nombre del cliente
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 09-06-2016 - Se corrige para que tome Razon Social cuando sea 'RUC' el tipo de identificacion y para 'CED' y 'PAS' tome los nombres
 *                           y apellidos de la persona.
 *
 * PARAMETROS:
 * @Param DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE          Fn_IdPersona     (id_persona del cliente)
 * @return VARCHAR2                                          Fv_Resultado     (valor de la forma de contacto)
 */
FUNCTION F_GET_NOMBRE_APELLIDOS_PERSONA(
    Fn_IdPersona    DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE )
RETURN VARCHAR2;
--
--
/*
 * Documentaci�n para PROCEDURE 'P_GET_REPORTE_BURO'.
 * PROCEDURE que obtiene la informacion necesaria para el reporte de buro
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 15-05-2016 - Se agrega que busque todos los telefonos de contacto de la persona en los puntos de estado 'Activo', 'Cancelado' o
 *                           'Trasladado'
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.2 02-09-2016 - Se agrega la los puntos en estado 'In-Corte'
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.3 26-07-2016 - Se agregan nuevos campos que corresponden a: Coordenadas del punto, Direcci�n Cliente, Banco y Tipo de cuenta del cu�l
 *                           se le debita al cliente en caso de que su forma de pago sea diferente de 'EFECTIVO', y finalmente se agrega el estado de
 *                           la solicitud de Retiro de Equipos
 *
 * PARAMETROS:
 * @Param DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Pn_EmpresaCod            (empresa del punto del cliente)
 * @Param VARCHAR2                                           Pv_TipoClientes          (tipo de clientes)
 * @Param VARCHAR2                                           Pv_ValorClientesBuenos   (valor de clientes buenos)
 * @Param VARCHAR2                                           Pv_ValorClientesMalos    (valor de clientes malos)
 * @return SYS_REFCURSOR                                     C_Clientes               (cursor con los clientes del reporte)
 */
PROCEDURE P_GET_REPORTE_BURO(
    Pv_EmpresaCod          IN  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
    Pv_TipoClientes        IN  VARCHAR2,
    Pv_ValorClientesBuenos IN  VARCHAR2,
    Pv_ValorClientesMalos  IN  VARCHAR2,
    C_Clientes             OUT SYS_REFCURSOR );
--
--
/*
 * Documentaci�n para FUNCION 'F_REEMPLAZAR_CARACTERES_ESP'.
 * Funcion que reemplaza caracteres especiales no permitidos de una cadena
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 *
 * PARAMETROS:
 * @return VARCHAR2 Fv_Cadena     (Contiene la cadena que se va a reemplazar caracteres especiales)
 * @return VARCHAR2 Fv_Resultado  (Cadena sin los caracteres especiales)
 */
FUNCTION F_REEMPLAZAR_CARACTERES_ESP( Fv_Cadena VARCHAR2 )
RETURN VARCHAR2;
--
--
/*
 * Documentaci�n para FUNCION 'F_GET_INFO_EMPRESA'.
 * Funcion que obtiene la informacion de la empresa
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 *
 * PARAMETROS:
 * @return VARCHAR2 Fv_CodEmpresa  (Codigo de la empresa a consultar)
 * @return VARCHAR2 Fv_Resultado   (Nombre de la empresa que est� realizando la consulta)
 */
FUNCTION F_GET_INFO_EMPRESA( Fv_CodEmpresa VARCHAR2 )
RETURN VARCHAR2;
--
--
--
  /**
  * Documentacion para el procedimiento P_GET_INFO_SERVICIO_A_FACTURAR
  *
  * El procedimiento P_GET_INFO_SERVICIO_A_FACTURAR realiza la consulta de la informaci�n de un servicio que se va a facturar
  *
  * @param  Pn_IdServicio            IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE         Recibe el IdServicio del cual se va a obtener la
  *                                                                                          informaci�n para la factura
  *
  * @param  Pv_EmpresaCod            OUT DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE      Retorna el c�digo de la empresa
  * @param  Pv_PrefijoEmpresa        OUT DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE        Retorna el prefijo de la empresa
  * @param  Pn_OficinaId             OUT DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE     Retorna el id de la oficina a la cual pertenece el
  *                                                                                          cliente
  * @param  Pn_IdPunto               OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE               Retorna el id del punto del cual se va a facturar
  * @param  Pn_PlanId                OUT DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE             Retorna el id del plan, si el servicio esta asociado a
  *                                                                                          un plan
  * @param  Pn_ProductoId            OUT DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE         Retorna el id del producto, si el servicio esta asociado
  *                                                                                          a un producto
  * @param  Pn_IdPuntoFacturacion    OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE               Retorna el id del punto_facturacion del servicio donde
  *                                                                                          se debe crear la cabecera de la factura
  * @param  Pv_Compensacion          OUT VARCHAR2                                            Retorna un string indicando si es compensado el servicio
  * @param  Pv_PagaIva               OUT VARCHAR2                                            Retorna un string indicando si el cliente paga iva
  *
  * @param  Pv_MessageError          OUT VARCHAR2                                            Retorna un mensaje de error si existe
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 12-12-2015
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 21-09-2016 - Se agregan nuevos campos que debe retornar la funci�n los cuales son 'Pv_PrefijoEmpresa', 'Pv_IdPuntoFacturacion',
  *                           'Pv_Compensacion' y 'Pv_PagaIva'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 08-02-2017 - Se elimina la validaci�n por empresa al momento de consultar si el cliente debe compensar, para que MD tambi�n compense
  */
  PROCEDURE P_GET_INFO_SERVICIO_A_FACTURAR(
      Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Pv_EmpresaCod OUT DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
      Pv_PrefijoEmpresa OUT DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pn_OficinaId OUT DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pn_IdPuntoFacturacion OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Pn_IdPunto OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Pn_PlanId OUT DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
      Pn_ProductoId OUT DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
      Pv_Compensacion OUT VARCHAR2,
      Pv_PagaIva OUT VARCHAR2,
      Pv_MessageError OUT VARCHAR2 );
--
--
--
/*
 * Documentaci�n para FUNCION 'F_GET_INFORMACION_PUNTO_CLOB'.
 * Funcion que obtiene informaci�n del punto del cliente pero retorna un CLOB debido a la cantidad de informaci�n que se requiere retornar
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 07-06-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 24-06-2016 - Se valida que no retorne emails y telefonos repetidos.
 *
 * PARAMETROS:
 * @Param DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE          Fn_IdPersona     (id_persona del cliente)
 * @Param DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE                Fv_EstadoPunto   (estado del punto del cliente)
 * @Param DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Fv_EmpresaCod    (empresa del punto del cliente)
 * @Param VARCHAR2                                           Fv_Filtro        (es el filtro de lo que se desea buscar)
 * @return CLOB                                              Fv_Resultado     (valor de la forma de contacto)
 */
FUNCTION F_GET_INFORMACION_PUNTO_CLOB(
    Fn_IdPersona    DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    Fv_EstadoPunto  DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
    Fv_EmpresaCod   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_Filtro       VARCHAR2 )
RETURN CLOB;
--
--
--
/*
 * Documentaci�n para FUNCION 'F_BUSCAR_CADENA_REPETIDAS'.
 *
 * Funcion que busca cadenas repetidas
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 24-06-2016
 *
 * PARAMETROS:
 * @return VARCHAR2 Fv_CadenaInicial  (Contiene la cadena en la que se va a buscar)
 * @return VARCHAR2 Fv_CadenaABuscar  (Contiene la cadena que se desea buscar)
 * @return VARCHAR2 Fv_Resultado      (Cadena sin los caracteres especiales)
 */
FUNCTION F_BUSCAR_CADENA_REPETIDAS( Fv_CadenaInicial CLOB, Fv_CadenaABuscar VARCHAR2 )
RETURN VARCHAR2;
--
--
/**
 * Documentaci�n para FUNCION 'P_GET_FECHAS_DIAS_PERIODO'.
 *
 * Funci�n que obtiene las fechas inicial y final del periodo a facturar, y adicional retornan la cantidad de d�as entre las fechas obtenidas y la
 * fecha en que se activ� el servicio
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 19-07-2016
 *
 * PARAMETROS:
 * @param NUMBER    PIn_EmpresaCod            IN    (Contiene el c�digo de la empresa)
 * @param VARCHAR2  PIv_FechaActivacion       IN    (Contiene la fecha de activaci�n del servicio)
 * @param VARCHAR2  POd_FechaInicioPeriodo    OUT   (Cadena con la fecha inicial del periodo)
 * @param VARCHAR2  POd_FechaFinPeriodo       OUT   (Cadena con la fecha final del periodo)
 * @param NUMBER    POn_CantidadDiasTotalMes  OUT   (N�mero con la cantidad de d�as del periodo)
 * @param NUMBER    POn_CantidadDiasRestantes OUT   (N�mero con la cantidad de d�as a facturar)
 */
PROCEDURE P_GET_FECHAS_DIAS_PERIODO(  PIn_EmpresaCod            IN  NUMBER,
                                      PIv_FechaActivacion       IN  VARCHAR2,
                                      POd_FechaInicioPeriodo    OUT VARCHAR2,
                                      POd_FechaFinPeriodo       OUT VARCHAR2,
                                      POn_CantidadDiasTotalMes  OUT NUMBER,
                                      POn_CantidadDiasRestantes OUT NUMBER );
  --
  --

 /**
  * Documentaci�n para F_GET_DESCRIPCION_FACTURA_DET
  * Retorna la observacion asociada al primer detalle del  documento .
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 17-10-2016
  *
  * @param  Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el ID del documento
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE Retorna descripci�n del primer detalle de la factura.
  */
  FUNCTION F_GET_DESCRIPCION_FACTURA_DET(
      Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE;
  --
  --

 /**
  * Documentaci�n para F_GET_MOTIVO_POR_ESTADO
  * Retorna el motivo de anulaci�n asociado al documento en estado Anulado
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 18-10-2016
  *
  * @param  Fn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el ID del documento
  * @param  Fv_EstadoDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE Recibe el estado del documento
  * @param  Fv_EstadoHistorial IN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE Recibe el estado del historial del documento
  * @return DB_COMERCIAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE  Retorna nombre del motivo.
  *
  * Se reemplaza la inserci�n del error por dbms_output.put_line,
  * para evitar error ORA-14551: cannot perform a DML operation inside a query.
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.1 20-01-2017
  */
  FUNCTION F_GET_MOTIVO_POR_ESTADO(
      Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_EstadoDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
      Fv_EstadoHistorial IN INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE)
    RETURN DB_COMERCIAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE;
  --
  --

 /**
  * Documentaci�n para F_GET_SUBTOTAL_IMPUESTO
  * Retorna el subtotal con impuesto asociado al documento y al porcentaje de impuesto IVA enviados como par�metros.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 18-10-2016
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 26-10-2016 Se agrega redondeo a dos decimales en el resultado de la consulta.
  *
  * @param Fn_IdDocumento        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el ID del documento
  * @param Fn_PorcentajeImpuesto DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.PORCENTAJE Recibe el porcentaje de impuesto a consultar
  * @return NUMBER
   *
   * Se reemplaza la inserci�n del error por dbms_output.put_line,
   * para evitar error ORA-14551: cannot perform a DML operation inside a query.
   *
   * @author Hector Ortega <haortega@telconet.ec>
   * @version 1.2 20-01-2017
  */
  FUNCTION F_GET_SUBTOTAL_IMPUESTO(
      Fn_IdDocumento        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fn_PorcentajeImpuesto IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.PORCENTAJE%TYPE,
      Fv_TipoImpuesto       IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;

  /**
  * Documentacion para la funcion F_GET_DIFERENCIA_MESES_FECHAS
  * La funcion F_GET_DIFERENCIA_MESES_FECHAS Obtiene la diferencia en meses entre fechas
  *
  * @param  Fv_IdPersona    IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE Recibe Id de la persona
  * @param  Fv_CodEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Recibe codigo de la empresa
  * @param  Fv_TipoConsulta IN VARCHAR2 Recibe el tipo de Consulta que se realiza por (Activacion o Corte)
  * @return FLOAT           Retorna la diferencia en meses entre la fecha de Activacion o la fecha de Ultimo Corte y el Sysdate
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 06-12-2016
  */
  FUNCTION F_GET_DIFERENCIA_MESES_FECHAS(
    Fn_IdPersona    IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    Fv_CodEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_TipoConsulta IN VARCHAR2
    )
  RETURN FLOAT;
  --
  --
  /**
  * Documentaci�n para FUNCTION 'F_GET_NUMERO_COMPROBANTE'.
  *
  * Funci�n que obtiene el numero de comprobante que ayuda a realizar la cuadratura de los pagos y anticipos parte del usuario de cobranzas
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 01-12-2016
  *
  * PARAMETROS:
  * @param Fn_IdPagoDet       IN  DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE  (Id del detalle del pago)
  * @param Fv_CodigoFormaPago IN  DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE  (C�digo de la forma de pago)
  * @param Fv_InsertarError   IN VARCHAR2 (Permite indicar si se desea o no insertar un error dentro de la funci�n)
  * @return VARCHAR2
  *
  * Se agrega el parametro FvInsertaError que permitir� ingresar o presentar el
  * error generado dentro de la funci�n.
  *
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.1 20-01-2017
  */
  FUNCTION F_GET_NUMERO_COMPROBANTE(
      Fn_IdPagoDet       IN DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
      Fv_CodigoFormaPago IN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
      Fv_InsertarError   IN VARCHAR2 DEFAULT 'S')
    RETURN VARCHAR2;
  --
  --
  /**
  * Documentaci�n para F_GET_SUBTOTAL_CERO_IMPUESTO
  * Retorna el subtotal con cero impuesto asociado al documento enviado como par�metro.
  * Costo: 11
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 19-01-2017
  *
  * @param Fn_IdDocumento        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el ID del documento
  * @return NUMBER
  */
  FUNCTION F_GET_SUBTOTAL_CERO_IMPUESTO(
      Fn_IdDocumento        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
  --
  --
  /*
  * Documentaci�n para FUNCION 'F_ESTADO_PUNTO'.
  *
  * Funcion que permite obtener el estado del punto de facturaci�n
  *
  * PARAMETROS:
  * @param Fn_IdPuntoFacturacion IN  VARCHAR2  (Login del punto cliente)
  * @param Fv_FeConsultaHasta    IN  VARCHAR2  (Fecha de consulta del reporte)
  *
  * @return DB_COMERCIAL.INFO_PUNTO_HISTORIAL.VALOR%TYPE (Estado del punto)
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 13-01-2017
  */
  FUNCTION F_ESTADO_PUNTO(
      Fn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Fv_FeConsultaHasta    IN VARCHAR2)
    RETURN DB_COMERCIAL.INFO_PUNTO_HISTORIAL.VALOR%TYPE;
  --
  --
  /*
  * Documentaci�n para FUNCION 'F_GET_DESCRIPCION_PERIODO_FACT'.
  *
  * Funci�n que retorna la descripci�n del periodo facturado cuando la frecuencia de los servicios es mayor a 1
  *
  * PARAMETROS:
  * @param Fn_FrecuenciaProducto IN  DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE  Frecuencia del producto facturado.
  *
  * @return VARCHAR2  Descripci�n del periodo facturado
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 15-03-2017
  */
  FUNCTION F_GET_DESCRIPCION_PERIODO_FACT(
      Fn_FrecuenciaProducto IN  DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE)
    RETURN VARCHAR2;
  --
  --

  /**
   * Funci�n que verifica si es posible ejecutar el job que crea comprobantes electr�nicos.
   * Devuelve 1 si es posible ejecutar el job de comprobantes, 0 si no es posible ejecutar el job de comprobantes.
   * @param  Pv_NombreParametro IN  VARCHAR2 => Nombre del PARAMETRO a buscar.
   * @return NUMBER
   *
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 27-08-2018
   * Versi�n inicial.
   */
  FUNCTION F_GET_EJECUCION_COMPROBANTES(Pv_NombreParametro IN VARCHAR2 DEFAULT 'PROCESOS_FACTURACION_MASIVA')
  RETURN NUMBER;

  /**
   * Funci�n que verifica si el Job enviado por par�metro se encuentra en el estado proporcionado por par�metro.
   * Devuelve 1 si existe seg�n los par�metros proporcionados, 0 si no existe el registro.
   * @param  Pv_NombreJob IN  VARCHAR2 => Nombre del job a buscar.
   * @param  Pv_EstadoJob IN  VARCHAR2 => Estado del job a buscar.
   * @return NUMBER
   *
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 21-08-2018
   * Versi�n inicial.
   */
  FUNCTION F_GET_ESTADO_EJECUCION_JOB(Pv_NombreJob IN VARCHAR2,
                                      Pv_EstadoJob IN VARCHAR2 DEFAULT 'RUNNING')
  RETURN NUMBER;

  /*
  * Documentaci�n para PROCEDURE 'P_ESTADO_CTA_CLIENTE'.
  * Procedure que me permite obtener lista de pagos por vendedor seg�n filtros enviados como par�metros.
  *
  * PARAMETROS:
  * @Param varchar2       Pv_EmpresaCod  C�digo de la empresa en sesion
  * @Param number         Pn_PersonaId  (Id del cliente)
  * @Param varchar2       Pv_FechaCreacionDesde (rango inicial para consulta por fecha de creaci�n del documento)
  * @Param varchar2       Pv_FechaCreacionHasta (rango final para consulta por fecha de creaci�n del documento)
  * @param number         Pn_TotalRegistros  OUT  ( Total de registros obtenidos de la consulta )
  * @param SYS_REFCURSOR  Pr_Documentos      OUT  ( Cursor con los documentos obtenidos de la consulta )
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 04-10-2017
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.1 23-10-2017 - Se incluye al query del estado de cuenta del cliente llamada a los siguientes metodos:
  * Donde 'F_GET_PAGO_DEPENDIENTE'comprueba si un Pago o Ant depende de un Padre (tiene dependencia),
  * Donde 'F_GET_SALDO_X_FACTURA' permite obtener el saldo del documento: FAC o FACP.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.2 01-03-2018 - Se cambia Filtro de FeCreacion a FeEmision y se Agregan al Grid FeEmision, FeAutorizacion
  * 
  */

  PROCEDURE P_ESTADO_CTA_CLIENTE(
    Pv_EmpresaCod                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pn_PersonaId                    IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.PERSONA_ID%TYPE,
    Pv_FechaEmisionDesde            IN  VARCHAR2,
    Pv_FechaEmisionHasta            IN  VARCHAR2,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Documentos                   OUT SYS_REFCURSOR
  );

  /**
  * Documentacion para la funci�n 'F_GET_PAGO_DEPENDIENTE'
  *
  * Funci�n que retorna TRUE si el pago tiene dependencia sobre otros documentos en la 'INFO_PAGO_HISTORIAL',
  * en el caso de que sea True cambia el color de fondo de la fila del pago dependiente en el grid, si solo
  * a las empresas que CONTABILIZA. Para ello se verifica los detalles del par�metro cabecera que es
  * 'PROCESO CONTABILIZACION EMPRESA' en la tabla 'DB_GENERAL.ADMI_PARAMETRO_DET' y se verifica la columna
  * 'VALOR2' si est� seteado con el valor de 'S'.
  *
  * @param Fv_EmpresaId           IN  DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE, Codigo de la empresa
  * @param Fv_CodigoTipoDocumento IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE, Codigo del tipo de documento.
  * @param Fn_IdPunto             IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, Id del punto.
  * @param Fn_IdPago              IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO, Id del pago.
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 23-10-2017
  */
FUNCTION F_GET_PAGO_DEPENDIENTE(
    Fv_EmpresaId           IN  DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE,
    Fv_CodigoTipoDocumento IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fn_IdPunto             IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Fn_IdPago              IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE
    )
  RETURN VARCHAR2;

  /**
  * Documentacion para la funci�n 'F_GET_PAGO_DEPENDIENTE'
  *
  * Funcion que permite obtener el saldo del documento: FAC o FACP.
  *
  * @param Fv_EmpresaId           IN  DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE, Codigo de la empresa
  * @param Fv_CodigoTipoDocumento IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE, Codigo del tipo de documento.
  *
  * @author Ricardo Coello Quezada <rcoello@telconet.ec>
  * @version 1.0 24-10-2017
  */
  FUNCTION F_GET_SALDO_X_FACTURA(
    Fn_IdDocumento          IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_CodigoTipoDocumento  IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE
    )
  RETURN NUMBER;
  --
  /**
  * Documentacion para la funci�n 'F_GET_CUENTA_BANCARIA'
  *
  * Funcion que permite obtener el cuenta bancaria por id cuenta contable o id banco tipo cuenta
  * @param  Pn_IdCuentaContable IN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.ID_CUENTA_CONTABLE%TYPE  recibe c�digo de cuenta contable
  * @param  Pn_IdBancoTipoCta   IN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE recibe c�digo banco tipo cuenta
  * @param  Pv_NoCia            IN DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE               recibe c�digo de la empresa
  * @return                     FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable               retorna datos de cuenta contable
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 20-01-2018
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 11-01-2019 - Se agrega campo centro de costo en los cursores que recuperan datos de cuentas contables
  */
  FUNCTION F_GET_CUENTA_BANCARIA ( Pn_IdCuentaContable IN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.ID_CUENTA_CONTABLE%TYPE,
                                   Pn_IdBancoTipoCta   IN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE,
                                   Pv_NoCia            IN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.NO_CIA%TYPE
                                 )
                                 RETURN FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
  --

  /**
  * Documentaci�n para F_GET_CTA_CONTABLE
  *
  * Funci�n permite obtener la descripci�n del tipo de cuenta apartir del banco cuenta contable.
  * @param Pn_BancoCtaContableId IN DB_GENERAL.ADMI_BANCO_CTA_CONTABLE.ID_BANCO_CTA_CONTABLE%TYPE recibe c�digo banco cuenta contable
  * costo 3
  * @author Angel Reina <areina@telconet.ec>
  * @version 1.0 25-06.2019
  *
  */
  
  FUNCTION F_GET_CTA_CONTABLE(Pn_BancoCtaContableId IN DB_GENERAL.ADMI_BANCO_CTA_CONTABLE.ID_BANCO_CTA_CONTABLE%TYPE)
    RETURN DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE;
  --

  /**
  * Documentaci�n para F_GET_TIPO_CUENTA
  *
  * Funcion que permite obtener la descripci�n del tipo de cuenta apartir de banco tipo cuenta.
  * @param Pn_BancoTipoCtaId IN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE recibe c�digo banco tipo cuenta
  * costo 2
  * @author Angel Reina <areina@telconet.ec>
  * @version 1.0 25-06.2019
  */
  
  FUNCTION F_GET_TIPO_CTA(Pn_BancoTipoCtaId IN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE)
    RETURN DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE;
  --
  /**
  * Documentaci�n para F_GET_FORMATO_FECHA
  *
  * Funci�n que permite convertir fecha con formato D�a-Mes-A�o a formato A�o-Mes-D�a
  * @param  Fv_Fecha IN VARCHAR2  recibe string de fecha
  * @return VARCHAR2              retorna fecha en formato A�o-Mes-D�a
  * costo 2
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 01-05-2021
  */
  FUNCTION F_GET_FORMATO_FECHA(Fv_Fecha IN VARCHAR2)
  RETURN VARCHAR2;
  --
  /**
  * Documentaci�n para F_GET_EMPRESA
  *
  * Funci�n que permite obtener el c�digo de empresa enviando como par�metro el Id Documento Financiero.
  * @param  Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  recibe Id Documento Financiero
  * @return VARCHAR2                                                                          retorna C�digo de Empresa
  * costo 4 
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 01-05-2021
  */
  FUNCTION F_GET_EMPRESA(Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2;
  --
  --
 /**
  * Documentaci�n para F_GET_USR_ULT_MOD
  * Retorna el usuario de creaci�n del ultimo historial asociado  documento .
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 04-10-2021
  *
  * @param  Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el ID del documento
  */
  FUNCTION F_GET_USR_ULT_MOD(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE;
  --
  --
 /**
  * Documentaci�n para F_GET_FE_ULT_MOD
  * Retorna la fecha de creaci�n del ultimo historial asociado  documento .
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 04-10-2021
  *
  * @param  Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el ID del documento
  */
  FUNCTION F_GET_FE_ULT_MOD(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2;

END FNCK_CONSULTS;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_CONSULTS AS
  -- declaracion de constantes
  VALIDA_PROCESOS_CONTABLES CONSTANT VARCHAR2(31) := 'VALIDACIONES_PROCESOS_CONTABLES';
  ANTICIPO_NOTA_CREDITO     CONSTANT VARCHAR2(33) := 'CONTABILIZA_ANTICIPO_NOTA_CREDITO';
  ESTADO_ACTIVO             CONSTANT VARCHAR2(06) := 'Activo';
  --
FUNCTION F_GET_MAX_DOCUMENTO_SERV_PROD(
      Fn_PuntoFacturacionId IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
      Fn_PuntoId            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
      Fn_ServicioId         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.SERVICIO_ID%TYPE,      
      Fn_ProductoId         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE,
      Fn_PrecioVenta        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE,     
      Fv_Filtro             IN VARCHAR2)
      RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE      
  IS    
    CURSOR C_GetInfoDocFinancieroCab(Cn_IdDocumentoFinanacieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      --
      SELECT *
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
      WHERE ID_DOCUMENTO = Cn_IdDocumentoFinanacieroCab;
   
    Ln_IdDocumentoFinanciero       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE := 0;
    Fr_InfoDocumentoFinancieroCab  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE := NULL;           
    Lv_Query1                      CLOB;
    Lv_Query2                      CLOB;
    Lc_MaxDocumentoByMesAnio       SYS_REFCURSOR;
    Lc_MaxDocumentoByRango         SYS_REFCURSOR;
  BEGIN
    --    
    Lv_Query1 := '
      SELECT TABLA_ORD_MES_ANIO_CONSUMO.ID_DOCUMENTO AS LN_ID_DOCUMENTO
      FROM
        (SELECT IDFC.ID_DOCUMENTO
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
        ON IDFC.ID_DOCUMENTO        = IDFD.DOCUMENTO_ID
        WHERE IDFC.PUNTO_ID         = :Fn_PuntoFacturacionId
        AND IDFD.PUNTO_ID           = :Fn_PuntoId ';
    
    IF Fn_ServicioId IS NOT NULL THEN     
      --
      Lv_Query1 := Lv_Query1 || ' AND IDFD.SERVICIO_ID = :Fn_ServicioId ';
      -- 
    ELSIF Fn_ProductoId IS NOT NULL AND Fn_PrecioVenta IS NOT NULL THEN
      --    
      Lv_Query1 := Lv_Query1 || ' AND IDFD.PRODUCTO_ID = :Fn_ProductoId AND IDFD.PRECIO_VENTA_FACPRO_DETALLE= :Fn_PrecioVenta ';      
      -- 
    ELSE
      --
      Lv_Query1 := Lv_Query1 || ' AND IDFD.PRODUCTO_ID = :Fn_ProductoId ';      
      --
    END IF;    
    -- 
    Lv_Query1 := Lv_Query1 || ' AND IDFC.TIPO_DOCUMENTO_ID IN
          (SELECT ATDF.ID_TIPO_DOCUMENTO
          FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
          WHERE ATDF.ESTADO               = ''Activo''
          AND ATDF.CODIGO_TIPO_DOCUMENTO IN (''FAC'', ''FACP'')
          )
      AND IDFC.ANIO_CONSUMO          IS NOT NULL
      AND IDFC.MES_CONSUMO           IS NOT NULL
      AND IDFC.ESTADO_IMPRESION_FACT IN
        (SELECT APD.DESCRIPCION
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
        WHERE APC.NOMBRE_PARAMETRO = ''ESTADOS_FACTURAS_VALIDAS''
        AND APC.ESTADO             = ''Activo''
        AND APD.ESTADO             = ''Activo''
        )
      AND NOT EXISTS (SELECT 1 
                       FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC,
                       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET NCD,
                       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDNC
                       WHERE NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                       AND NC.TIPO_DOCUMENTO_ID         = ATDNC.ID_TIPO_DOCUMENTO
                       AND NC.ID_DOCUMENTO              = NCD.DOCUMENTO_ID
                       AND ATDNC.ESTADO                 = ''Activo''
                       AND ATDNC.CODIGO_TIPO_DOCUMENTO IN (''NC'', ''NCI'')
                       AND NC.ESTADO_IMPRESION_FACT     = ''Activo''
                       AND NC.PUNTO_ID                 = :Fn_PuntoFacturacionId
                       AND NCD.PUNTO_ID                = :Fn_PuntoId  ';
                       
    IF Fn_ServicioId IS NOT NULL THEN     
      --
      Lv_Query1 := Lv_Query1 || ' AND NCD.SERVICIO_ID = :Fn_ServicioId  AND NCD.PRECIO_VENTA_FACPRO_DETALLE = (SELECT SER.PRECIO_VENTA FROM DB_COMERCIAL.INFO_SERVICIO SER  WHERE SER.ID_SERVICIO = :Fn_ServicioId) ';
      -- 
    ELSIF Fn_ProductoId IS NOT NULL AND Fn_PrecioVenta IS NOT NULL THEN
      --    
      Lv_Query1 := Lv_Query1 || ' AND NCD.PRODUCTO_ID = :Fn_ProductoId AND NCD.PRECIO_VENTA_FACPRO_DETALLE= :Fn_PrecioVenta ';      
      -- 
    ELSE
      --
      Lv_Query1 := Lv_Query1 || ' AND NCD.PRODUCTO_ID = :Fn_ProductoId ';      
      --
    END IF;                                                         
      --                       
    Lv_Query1 := Lv_Query1 || '                ) 
      ORDER BY TO_NUMBER(IDFC.ANIO_CONSUMO, ''9999'') DESC,
        TO_NUMBER(IDFC.MES_CONSUMO, ''99'') DESC
        ) TABLA_ORD_MES_ANIO_CONSUMO
      WHERE ROWNUM = 1
             ';
 --
 --
 Lv_Query2 := '
        SELECT TABLA_ORD_RANGO_CONSUMO.ID_DOCUMENTO
        FROM
          (SELECT IDFC.ID_DOCUMENTO
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
          JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
          ON IDFC.ID_DOCUMENTO = IDFD.DOCUMENTO_ID
          JOIN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
          ON IDC.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
          JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
          ON AC.ID_CARACTERISTICA     = IDC.CARACTERISTICA_ID
          WHERE IDFC.PUNTO_ID         = :Fn_PuntoFacturacionId
          AND IDFD.PUNTO_ID           = :Fn_PuntoId ';
          
    IF Fn_ServicioId IS NOT NULL THEN     
      --
      Lv_Query2 := Lv_Query2 || ' AND IDFD.SERVICIO_ID = :Fn_ServicioId ';
      -- 
    ELSIF Fn_ProductoId IS NOT NULL AND Fn_PrecioVenta IS NOT NULL THEN
      --    
      Lv_Query2 := Lv_Query2 || ' AND IDFD.PRODUCTO_ID = :Fn_ProductoId AND IDFD.PRECIO_VENTA_FACPRO_DETALLE= :Fn_PrecioVenta ';      
      -- 
    ELSE
      --
      Lv_Query2 := Lv_Query2 || ' AND IDFD.PRODUCTO_ID = :Fn_ProductoId ';      
      --
    END IF;    
    -- 
    Lv_Query2 := Lv_Query2 || ' AND IDFC.TIPO_DOCUMENTO_ID IN
            (SELECT ATDF.ID_TIPO_DOCUMENTO
            FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
            WHERE ATDF.ESTADO               = ''Activo''
            AND ATDF.CODIGO_TIPO_DOCUMENTO IN (''FAC'', ''FACP'')
            )
        AND IDFC.RANGO_CONSUMO         IS NOT NULL
        AND IDFC.MES_CONSUMO           IS NULL
        AND IDFC.ANIO_CONSUMO          IS NULL
        AND IDFC.ESTADO_IMPRESION_FACT IN
          (SELECT APD.DESCRIPCION
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
          ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
          WHERE APC.NOMBRE_PARAMETRO = ''ESTADOS_FACTURAS_VALIDAS''
          AND APC.ESTADO             = ''Activo''
          AND APD.ESTADO             = ''Activo''
          )
        AND AC.DESCRIPCION_CARACTERISTICA = ''FE_RANGO_FINAL''
        AND NOT EXISTS (SELECT 1 
                       FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC,
                       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET NCD,
                       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDNC
                       WHERE NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                       AND NC.TIPO_DOCUMENTO_ID         = ATDNC.ID_TIPO_DOCUMENTO
                       AND NC.ID_DOCUMENTO              = NCD.DOCUMENTO_ID
                       AND ATDNC.ESTADO                 = ''Activo''
                       AND ATDNC.CODIGO_TIPO_DOCUMENTO IN (''NC'', ''NCI'')
                       AND NC.ESTADO_IMPRESION_FACT     = ''Activo''
                       AND NC.PUNTO_ID                 = :Fn_PuntoFacturacionId
                       AND NCD.PUNTO_ID                = :Fn_PuntoId  ';
                       
      IF Fn_ServicioId IS NOT NULL THEN     
      --
      Lv_Query2 := Lv_Query2 || ' AND NCD.SERVICIO_ID = :Fn_ServicioId AND NCD.PRECIO_VENTA_FACPRO_DETALLE = (SELECT SER.PRECIO_VENTA FROM DB_COMERCIAL.INFO_SERVICIO SER  WHERE SER.ID_SERVICIO = :Fn_ServicioId) ';
      -- 
    ELSIF Fn_ProductoId IS NOT NULL AND Fn_PrecioVenta IS NOT NULL THEN
      --    
      Lv_Query2 := Lv_Query2 || ' AND NCD.PRODUCTO_ID = :Fn_ProductoId AND NCD.PRECIO_VENTA_FACPRO_DETALLE= :Fn_PrecioVenta ';      
      -- 
    ELSE
      --
      Lv_Query2 := Lv_Query2 || ' AND NCD.PRODUCTO_ID = :Fn_ProductoId ';      
      --
    END IF;                                                         
      --                       
    Lv_Query2 := Lv_Query2 || '  ) 
        ORDER BY TO_DATE(IDC.VALOR, ''DD-MM-YYYY'') DESC
          ) TABLA_ORD_RANGO_CONSUMO
        WHERE ROWNUM = 1
           ';
    CASE
      --
    WHEN Fv_Filtro = 'mesAnioConsumo' THEN
      IF Lc_MaxDocumentoByMesAnio%ISOPEN THEN
        CLOSE Lc_MaxDocumentoByMesAnio;
      END IF;
      --     
      IF Fn_ServicioId IS NOT NULL THEN     
      --
         OPEN Lc_MaxDocumentoByMesAnio FOR Lv_Query1 USING Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ServicioId,
      Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ServicioId, Fn_ServicioId;
      -- 
      ELSIF Fn_ProductoId IS NOT NULL AND Fn_PrecioVenta IS NOT NULL THEN
      --    
         OPEN Lc_MaxDocumentoByMesAnio FOR Lv_Query1 USING Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId,Fn_PrecioVenta,
      Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId, Fn_PrecioVenta;
      -- 
      ELSE
      --
       OPEN Lc_MaxDocumentoByMesAnio FOR Lv_Query1 USING Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId,
      Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId;    
      --
      END IF;    
      --
      --
      FETCH Lc_MaxDocumentoByMesAnio INTO Ln_IdDocumentoFinanciero;
      --
      IF Lc_MaxDocumentoByMesAnio%ISOPEN THEN
        CLOSE Lc_MaxDocumentoByMesAnio;
      END IF;
      --
    WHEN Fv_Filtro = 'rangoConsumo' THEN
      --
      IF Lc_MaxDocumentoByRango%ISOPEN THEN
        CLOSE Lc_MaxDocumentoByRango;
      END IF;
      --     
       --     
      IF Fn_ServicioId IS NOT NULL THEN     
      --
         OPEN Lc_MaxDocumentoByRango FOR Lv_Query2  USING Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ServicioId,
      Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ServicioId, Fn_ServicioId;
      -- 
      ELSIF Fn_ProductoId IS NOT NULL AND Fn_PrecioVenta IS NOT NULL THEN
      --    
         OPEN Lc_MaxDocumentoByRango FOR Lv_Query2  USING Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId,Fn_PrecioVenta,
      Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId, Fn_PrecioVenta;
      -- 
      ELSE
      --
       OPEN Lc_MaxDocumentoByRango FOR Lv_Query2  USING Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId,
      Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId;    
      --
      END IF;    
      --
      --
      FETCH Lc_MaxDocumentoByRango INTO Ln_IdDocumentoFinanciero;
      --
      IF Lc_MaxDocumentoByRango%ISOPEN THEN
        CLOSE Lc_MaxDocumentoByRango;
      END IF;
      --
    END CASE;
    --
    IF Ln_IdDocumentoFinanciero IS NOT NULL AND Ln_IdDocumentoFinanciero > 0 THEN
      --
      IF C_GetInfoDocFinancieroCab%ISOPEN THEN
        CLOSE C_GetInfoDocFinancieroCab;
      END IF;
      --
      OPEN C_GetInfoDocFinancieroCab(Ln_IdDocumentoFinanciero);
      --
      FETCH C_GetInfoDocFinancieroCab INTO Fr_InfoDocumentoFinancieroCab;
      --
      IF C_GetInfoDocFinancieroCab%ISOPEN THEN
        CLOSE C_GetInfoDocFinancieroCab;
      END IF;
      --
    END IF;
    --
    RETURN Fr_InfoDocumentoFinancieroCab;    
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS3.F_GET_MAX_DOCUMENTO_SERV_PROD',
                                          'No se encontr� documento financiero. Parametros (Punto Facturacion: '||Fn_PuntoFacturacionId||', Punto: '
                                          ||Fn_PuntoId||', Servicio: '||Fn_ServicioId||', Producto: '||Fn_ProductoId||', Precio: ' || Fn_PrecioVenta ||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    Fr_InfoDocumentoFinancieroCab := NULL;
    --
    RETURN Fr_InfoDocumentoFinancieroCab;    
    --    
  END F_GET_MAX_DOCUMENTO_SERV_PROD;  
  --
  --
  FUNCTION F_GET_TOTAL_FACTURACION(
    Fv_PrefijoEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fd_FechaInicio      IN VARCHAR2,
    Fd_FechaFin         IN VARCHAR2,
    Fv_Categoria        IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    Fv_Grupo            IN DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
    Fv_Subgrupo         IN DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
    Fv_EsRecurrente     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.RECURRENTE%TYPE)
  RETURN NUMBER
  IS
    --
    Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE           := 'Activo';
    Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'DASHBOARD_COMERCIAL';
    Lv_Modulo           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE           := 'COMERCIAL';
    Lv_Proceso          DB_GENERAL.ADMI_PARAMETRO_CAB.PROCESO%TYPE          := 'REPORTES';
    Lv_ValorFacturas    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'CODIGO_FACTURAS';
    Lv_ValorEstados     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := 'ESTADO_FACTURAS_ACTIVAS';
    Lv_Query            CLOB;
    Lc_TotalFacturado   SYS_REFCURSOR;
    Le_Exception        EXCEPTION;
    Lv_MensajeError     VARCHAR2(4000);
    Ln_Resultado        NUMBER;
    --
  BEGIN
    --
    IF TRIM(Fv_PrefijoEmpresa) IS NOT NULL AND TRIM(Fd_FechaInicio) IS NOT NULL AND TRIM(Fd_FechaFin) IS NOT NULL THEN
      --
      --SE OBTIENE EL VALOR TOTAL DE LA FACTURACION DENTRO DE UN RANGO DE TIEMPO
      --COSTO QUERY: 293
      Lv_Query := 'SELECT ROUND(SUM(TBL_FACTURACION.VALOR_TOTAL), 2) AS VALOR_FACTURA ' ||
                  'FROM ( ' ||
                  '       SELECT IDFC.VALOR_TOTAL,
                                 IDFC.ID_DOCUMENTO
                          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                          JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
                          ON IDFD.DOCUMENTO_ID                                                          = IDFC.ID_DOCUMENTO
                          WHERE DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDFC.PUNTO_ID, NULL) = :Fv_PrefijoEmpresa
                          AND IDFC.FE_EMISION >= CAST(TO_DATE(:Fd_FechaInicio, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE)
                          AND IDFC.FE_EMISION < CAST(TO_DATE(:Fd_FechaFin, ''DD/MM/YY'') AS TIMESTAMP WITH LOCAL TIME ZONE)
                          AND IDFC.NUMERO_FACTURA_SRI                                                  IS NOT NULL
                          AND IDFC.TIPO_DOCUMENTO_ID                                                   IN
                            (SELECT ATDF.ID_TIPO_DOCUMENTO
                            FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                            WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN
                              (SELECT APD.DESCRIPCION
                              FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                              JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
                              ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
                              WHERE APD.ESTADO         = :Lv_EstadoActivoParametro1
                              AND APC.ESTADO           = :Lv_EstadoActivoParametro2
                              AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro1
                              AND APC.MODULO           = :Lv_Modulo1
                              AND APC.PROCESO          = :Lv_Proceso1
                              AND APD.VALOR1           = :Lv_ValorFacturas
                              )
                            )
                          AND IDFC.ESTADO_IMPRESION_FACT IN
                            (SELECT APD.DESCRIPCION
                            FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                            JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
                            ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
                            WHERE APD.ESTADO         = :Lv_EstadoActivoParametro3
                            AND APC.ESTADO           = :Lv_EstadoActivoParametro4
                            AND APC.NOMBRE_PARAMETRO = :Lv_NombreParametro2
                            AND APC.MODULO           = :Lv_Modulo2
                            AND APC.PROCESO          = :Lv_Proceso2
                            AND APD.VALOR1           = :Lv_ValorEstados
                            )
                          AND IDFC.RECURRENTE   = NVL(:Fv_EsRecurrente, IDFC.RECURRENTE) ';
      --
      --
      IF TRIM(Fv_Categoria) IS NOT NULL OR TRIM(Fv_Grupo) IS NOT NULL OR TRIM(Fv_Subgrupo) IS NOT NULL THEN
        --
        Lv_Query := Lv_Query || 'AND IDFD.PRODUCTO_ID IN ( ';
        --
        IF TRIM(Fv_Categoria) IS NOT NULL THEN
          --
          Lv_Query := Lv_Query || 'SELECT AP.ID_PRODUCTO
                                   FROM DB_COMERCIAL.ADMI_PRODUCTO AP
                                   JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
                                   ON AP.ID_PRODUCTO = APC.PRODUCTO_ID
                                   JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
                                   ON AC.ID_CARACTERISTICA           = APC.CARACTERISTICA_ID
                                   WHERE AC.ESTADO                   = :Lv_EstadoActivoCaracteristica
                                   AND AC.DESCRIPCION_CARACTERISTICA = :Fv_Categoria
                                   AND AP.EMPRESA_COD                =
                                     (SELECT COD_EMPRESA
                                     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
                                     WHERE IEG.PREFIJO = :Lv_PrefijoEmpresaEmpresaGrupo
                                     AND IEG.ESTADO    = :Lv_EstadoActivoEmpresaGrupo
                                     )
                                   GROUP BY AP.ID_PRODUCTO ';
          --
        END IF;
        --
        --
        IF TRIM(Fv_Grupo) IS NOT NULL THEN
          --
          Lv_Query := Lv_Query || 'SELECT AP.ID_PRODUCTO
                                   FROM DB_COMERCIAL.ADMI_PRODUCTO AP
                                   WHERE AP.EMPRESA_COD =
                                     (SELECT COD_EMPRESA
                                      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
                                      WHERE IEG.PREFIJO = :Lv_PrefijoEmpresaEmpresaGrupo
                                      AND IEG.ESTADO    = :Lv_EstadoActivoEmpresaGrupo
                                      )
                                   AND AP.GRUPO = :Fv_Grupo
                                   GROUP BY AP.ID_PRODUCTO ';
          --
        END IF;
        --
        --
        IF TRIM(Fv_Subgrupo) IS NOT NULL THEN
          --
          Lv_Query := Lv_Query || 'SELECT AP.ID_PRODUCTO
                                   FROM DB_COMERCIAL.ADMI_PRODUCTO AP
                                   WHERE AP.EMPRESA_COD =
                                     (SELECT COD_EMPRESA
                                     FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
                                     WHERE IEG.PREFIJO = :Lv_PrefijoEmpresaEmpresaGrupo
                                     AND IEG.ESTADO    = :Lv_EstadoActivoEmpresaGrupo
                                     )
                                   AND AP.SUBGRUPO = :Fv_Subgrupo
                                   GROUP BY AP.ID_PRODUCTO ';
          --
        END IF;
        --
        --
        Lv_Query := Lv_Query || ') ';
        --
        --
      END IF;
      --
      --
      Lv_Query := Lv_Query || 'GROUP BY IDFC.ID_DOCUMENTO,
                                        IDFC.VALOR_TOTAL
                               ) TBL_FACTURACION ';
      --
      --
      IF TRIM(Fv_Categoria) IS NOT NULL THEN
        --
        OPEN Lc_TotalFacturado FOR Lv_Query USING Fv_PrefijoEmpresa,
                                                  Fd_FechaInicio,
                                                  Fd_FechaFin,
                                                  Lv_EstadoActivo,
                                                  Lv_EstadoActivo,
                                                  Lv_NombreParametro,
                                                  Lv_Modulo,
                                                  Lv_Proceso,
                                                  Lv_ValorFacturas,
                                                  Lv_EstadoActivo,
                                                  Lv_EstadoActivo,
                                                  Lv_NombreParametro,
                                                  Lv_Modulo,
                                                  Lv_Proceso,
                                                  Lv_ValorEstados,
                                                  Fv_EsRecurrente,
                                                  Lv_EstadoActivo,
                                                  Fv_Categoria,
                                                  Fv_PrefijoEmpresa,
                                                  Lv_EstadoActivo;
        --
      ELSIF TRIM(Fv_Grupo) IS NOT NULL THEN
        --
        OPEN Lc_TotalFacturado FOR Lv_Query USING Fv_PrefijoEmpresa,
                                                  Fd_FechaInicio,
                                                  Fd_FechaFin,
                                                  Lv_EstadoActivo,
                                                  Lv_EstadoActivo,
                                                  Lv_NombreParametro,
                                                  Lv_Modulo,
                                                  Lv_Proceso,
                                                  Lv_ValorFacturas,
                                                  Lv_EstadoActivo,
                                                  Lv_EstadoActivo,
                                                  Lv_NombreParametro,
                                                  Lv_Modulo,
                                                  Lv_Proceso,
                                                  Lv_ValorEstados,
                                                  Fv_EsRecurrente,
                                                  Fv_PrefijoEmpresa,
                                                  Lv_EstadoActivo,
                                                  Fv_Grupo;
        --
      ELSIF TRIM(Fv_Subgrupo) IS NOT NULL THEN
        --
        OPEN Lc_TotalFacturado FOR Lv_Query USING Fv_PrefijoEmpresa,
                                                  Fd_FechaInicio,
                                                  Fd_FechaFin,
                                                  Lv_EstadoActivo,
                                                  Lv_EstadoActivo,
                                                  Lv_NombreParametro,
                                                  Lv_Modulo,
                                                  Lv_Proceso,
                                                  Lv_ValorFacturas,
                                                  Lv_EstadoActivo,
                                                  Lv_EstadoActivo,
                                                  Lv_NombreParametro,
                                                  Lv_Modulo,
                                                  Lv_Proceso,
                                                  Lv_ValorEstados,
                                                  Fv_EsRecurrente,
                                                  Fv_PrefijoEmpresa,
                                                  Lv_EstadoActivo,
                                                  Fv_Subgrupo;
        --
      ELSE
        --
        OPEN Lc_TotalFacturado FOR Lv_Query USING Fv_PrefijoEmpresa,
                                                  Fd_FechaInicio,
                                                  Fd_FechaFin,
                                                  Lv_EstadoActivo,
                                                  Lv_EstadoActivo,
                                                  Lv_NombreParametro,
                                                  Lv_Modulo,
                                                  Lv_Proceso,
                                                  Lv_ValorFacturas,
                                                  Lv_EstadoActivo,
                                                  Lv_EstadoActivo,
                                                  Lv_NombreParametro,
                                                  Lv_Modulo,
                                                  Lv_Proceso,
                                                  Lv_ValorEstados,
                                                  Fv_EsRecurrente;
        --
      END IF;
      --
      FETCH Lc_TotalFacturado INTO Ln_Resultado;
      --
      CLOSE Lc_TotalFacturado;
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado los par�metros adecuados para realizar la consulta - Prefijo(' || Fv_PrefijoEmpresa || '), FeInicio( '
                         || Fd_FechaInicio || '), FeFin( ' || Fd_FechaFin || ').';
      --
      RAISE Le_Exception;
      --
    END IF;
    --
    --
    RETURN Ln_Resultado;
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    Ln_Resultado := 0;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_TOTAL_FACTURACION',
                                          Lv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Ln_Resultado;
    --
  WHEN OTHERS THEN
    --
    Ln_Resultado := 0;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_TOTAL_FACTURACION',
                                          'Error obtener la consulta - ' || SQLCODE || ' - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Ln_Resultado;
    --
  END F_GET_TOTAL_FACTURACION;
  --
  --
  FUNCTION F_GET_HISTORIAL_PAGO_ANTICIPO(
    Fn_IdPagoCab          IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
    Fv_EstadoPago         IN DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
    Fv_FechaConsultaDesde IN VARCHAR2,
    Fv_FechaConsultaHasta IN VARCHAR2,
    Fv_Filtro             IN VARCHAR2)
  RETURN VARCHAR2
  IS
    --
    --CURSOR QUE RETORNA LA INFORMACION HISTORICA DEL PAGO
    --COSTO DEL QUERY: 5
    CURSOR C_GetInfoPagoHistorial(Cn_IdPagoCab DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                                  Cv_FechaConsultaDesde VARCHAR2,
                                  Cv_FechaConsultaHasta VARCHAR2)
    IS
      --
      SELECT
        IPC.ID_PAGO,
        IPH.ESTADO AS ESTADO_PAGO_HISTORIAL,
        IPC.ESTADO_PAGO,
        IPH.FE_CREACION AS FE_CREACION_HISTORIAL,
        IPC.FE_CREACION AS FE_CREACION_PAGO,
        IPC.FE_ULT_MOD,
        IPC.FE_CRUCE
      FROM
        DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH
      JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC
      ON
        IPC.ID_PAGO = IPH.PAGO_ID
      WHERE
        IPH.ID_PAGO_HISTORIAL =
        (
          SELECT
            MAX(ID_PAGO_HISTORIAL)
          FROM
            DB_FINANCIERO.INFO_PAGO_HISTORIAL
          WHERE
            FE_CREACION >= CAST(TO_DATE(Cv_FechaConsultaDesde, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
          AND FE_CREACION < CAST(TO_DATE(Cv_FechaConsultaHasta, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1
          AND PAGO_ID   = Cn_IdPagoCab
        );
      --
    --
    --CURSOR QUE RETORNA LA INFORMACION DEL PAGO
    --COSTO DEL QUERY: 3
    CURSOR C_GetInfoPago(Cn_IdPagoCab DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                         Cv_FechaConsultaDesde VARCHAR2,
                         Cv_FechaConsultaHasta VARCHAR2)
    IS
      --
      SELECT
        IPC.ID_PAGO,
        NULL AS ESTADO_PAGO_HISTORIAL,
        IPC.ESTADO_PAGO,
        NULL AS FE_CREACION_HISTORIAL,
        IPC.FE_CREACION AS FE_CREACION_PAGO,
        IPC.FE_ULT_MOD,
        IPC.FE_CRUCE
      FROM
        DB_FINANCIERO.INFO_PAGO_CAB IPC
      WHERE
        IPC.ID_PAGO         = Cn_IdPagoCab
        AND IPC.FE_CREACION >= CAST(TO_DATE(Cv_FechaConsultaDesde, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
        AND IPC.FE_CREACION < CAST(TO_DATE(Cv_FechaConsultaHasta, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1;
      --
    --
    Lv_Query                  VARCHAR2(4000);
    Lv_MensajeError           VARCHAR2(4000);
    Lv_Resultado              VARCHAR2(30);
    Lex_Exception             EXCEPTION;
    Lrf_GetInfoPagoHistorial  C_GetInfoPagoHistorial%ROWTYPE;
    --
  BEGIN
    --
    --SE VERIFICA SI SE ENVIARON TODOS LOS PARAMETROS PARA REALIZAR LA RESPECTIVA CONSULTA
    IF TRIM(Fv_FechaConsultaDesde) IS NOT NULL AND TRIM(Fv_FechaConsultaHasta) IS NOT NULL AND Fn_IdPagoCab IS NOT NULL AND Fn_IdPagoCab > 0
       AND TRIM(Fv_EstadoPago) IS NOT NULL THEN
      --
      --SE REALIZA LA CONSULTA DEL HISTORIAL DEL PAGO
      IF C_GetInfoPagoHistorial%ISOPEN THEN
        CLOSE C_GetInfoPagoHistorial;
      END IF;
      --
      OPEN C_GetInfoPagoHistorial( Fn_IdPagoCab, Fv_FechaConsultaDesde, Fv_FechaConsultaHasta );
      --
      FETCH C_GetInfoPagoHistorial INTO Lrf_GetInfoPagoHistorial;
      --
      CLOSE C_GetInfoPagoHistorial;
      --
      IF C_GetInfoPagoHistorial%ISOPEN THEN
        CLOSE C_GetInfoPagoHistorial;
      END IF;
      --
      --SE VERIFICA SI SE HA ENCONTRADO HISTORIAL DEL PAGO
      IF Lrf_GetInfoPagoHistorial.ID_PAGO IS NULL  THEN
        --
        -- EN CASO DE NO ENCONTRAR HISTORIAL DEL PAGO SE CONSULTA LA INFORMACION DEL PAGO CREADO
        IF C_GetInfoPago%ISOPEN THEN
          CLOSE C_GetInfoPago;
        END IF;
        --
        OPEN C_GetInfoPago( Fn_IdPagoCab, Fv_FechaConsultaDesde, Fv_FechaConsultaHasta );
        --
        FETCH C_GetInfoPago INTO Lrf_GetInfoPagoHistorial;
        --
        CLOSE C_GetInfoPago;
        --
        IF C_GetInfoPago%ISOPEN THEN
          CLOSE C_GetInfoPago;
        END IF;
        --
      END IF;
      --
      --SE VERIFICA QUE SE HAYA ENCONTRADO INFORMACION DEL PAGO
      IF Lrf_GetInfoPagoHistorial.ID_PAGO IS NOT NULL AND Lrf_GetInfoPagoHistorial.ID_PAGO > 0 THEN
        --
        /**
         * CUANDO EL PAGO SE ENCUENTRA EN ESTADO 'Pendiente'
         * - Fv_Filtro = 'ESTADO': SE RETORNA COMO ESTADO DEL PAGO 'Pendiente' PUESTO QUE NO HA SUFRIDO VARIACION EN EL TIEMPO
         * - Fv_Filtro = 'HISTORIAL': SE RETORNA COMO FECHA DE HISTORIAL DEL PAGO LA FECHA DE CREACION DEL PAGO
         */
        IF TRIM(Fv_EstadoPago) = 'Pendiente' AND Lrf_GetInfoPagoHistorial.FE_CREACION_PAGO IS NOT NULL THEN
          --
          IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
            --
            Lv_Resultado := TRIM(Fv_EstadoPago);
            --
          ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
            --
            Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_CREACION_PAGO), 'DD/MM/YY');
            --
          END IF;
          --
        --
        /**
         * CUANDO EL PAGO SE ENCUENTRA EN ESTADO 'Cerrado' O 'Anulado'
         * - Fv_Filtro = 'ESTADO': SE RETORNA EL ESTADO DEL HISTORIAL SI LA FECHA DE CREACION DEL HISTORIAL ES MAYOR O IGUAL QUE LA FECHA DE ULTIMA
         *                         MODIFICACION DEL PAGO, CASO CONTRARIO SI LA FECHA DE ULTIMA MODIFICACION SE ENCUENTRA DENTRO DEL RANGO CONSULTADO
         *                         SE RETORNA EL ESTADO ACTUAL DEL PAGO, FINALMENTE SI SE ENCONTRO HISTORIAL DENTRO DEL RANGO DE FECHAS CONSULTADO
         *                         SE RETORNA EL ESTADO DEL HISTORIAL ENCONTRADO.
         * - Fv_Filtro = 'HISTORIAL': SE RETORNA LA FECHA DEL HISTORIAL SI LA FECHA DE CREACION DEL HISTORIAL ES MAYOR O IGUAL QUE LA FECHA DE ULTIMA
         *                            MODIFICACION DEL PAGO, CASO CONTRARIO SI LA FECHA DE ULTIMA MODIFICACION SE ENCUENTRA DENTRO DEL RANGO
         *                            CONSULTADO SE RETORNA LA FECHA DE ULTIMA MODIFICACION DEL PAGO, FINALMENTE SI SE ENCONTRO HISTORIAL DENTRO DEL
         *                            RANGO DE FECHAS CONSULTADO SE RETORNA LA FECHA DEL HISTORIAL ENCONTRADO.
         */
        ELSIF TRIM(Fv_EstadoPago) = 'Cerrado' OR TRIM(Fv_EstadoPago) = 'Anulado' THEN
          --
          IF Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL IS NOT NULL AND Lrf_GetInfoPagoHistorial.FE_ULT_MOD IS NOT NULL
             AND Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL >= Lrf_GetInfoPagoHistorial.FE_ULT_MOD THEN
            --
            IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
              --
              Lv_Resultado := NVL(TRIM(Lrf_GetInfoPagoHistorial.ESTADO_PAGO_HISTORIAL), NULL);
              --
            ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
              --
              Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL), 'DD/MM/YY');
              --
            END IF;
            --
          ELSIF Lrf_GetInfoPagoHistorial.FE_ULT_MOD IS NOT NULL
             AND Lrf_GetInfoPagoHistorial.FE_ULT_MOD >= CAST(TO_DATE(Fv_FechaConsultaDesde, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
             AND Lrf_GetInfoPagoHistorial.FE_ULT_MOD < CAST(TO_DATE(Fv_FechaConsultaHasta, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1 THEN
            --
            IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
              --
              Lv_Resultado := NVL(TRIM(Lrf_GetInfoPagoHistorial.ESTADO_PAGO), NULL);
              --
            ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
              --
              Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_ULT_MOD), 'DD/MM/YY');
              --
            END IF;
            --
          ELSIF Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL IS NOT NULL AND Lrf_GetInfoPagoHistorial.ESTADO_PAGO_HISTORIAL IS NOT NULL THEN
            --
            IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
              --
              Lv_Resultado := Lrf_GetInfoPagoHistorial.ESTADO_PAGO_HISTORIAL;
            --
            ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
              --
              Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL), 'DD/MM/YY');
              --
            END IF;
            --
          END IF;
          --
        --ELSIF TRIM(Fv_EstadoPago) = 'Cerrado' OR TRIM(Fv_EstadoPago) = 'Anulado' THEN
        /**
         * CUANDO EL PAGO SE ENCUENTRA EN ESTADO 'Asignado'
         * - Fv_Filtro = 'ESTADO': SE RETORNA EL ESTADO DEL HISTORIAL SI LA FECHA DE CREACION DEL HISTORIAL ES MAYOR O IGUAL QUE LA FECHA DE CRUCE
         *                         DEL PAGO.
         *                         CASO CONTRARIO SE RETORNA EL ESTADO DEL HISTORIAL SI LA FECHA DE CREACION DEL HISTORIAL ES MAYOR O IGUAL
         *                         QUE LA FECHA DE ULTIMA MODIFICACION DEL PAGO.
         *                         CASO CONTRARIO SI LA FECHA DE CRUCE SE ENCUENTRA DENTRO DEL RANGO CONSULTADO SE RETORNA EL ESTADO ACTUAL DEL PAGO.
         *                         CASO CONTRARIO SI LA FECHA DE ULTIMA MODIFICACION SE ENCUENTRA DENTRO DEL RANGO CONSULTADO SE RETORNA EL ESTADO
         *                         ACTUAL DEL PAGO.
         *                         FINALMENTE SI SE ENCONTRO HISTORIAL DENTRO DEL RANGO DE FECHAS CONSULTADO SE RETORNA EL ESTADO DEL HISTORIAL
         *                         ENCONTRADO.
         * - Fv_Filtro = 'HISTORIAL': SE RETORNA LA FECHA DEL HISTORIAL SI LA FECHA DE CREACION DEL HISTORIAL ES MAYOR O IGUAL QUE LA FECHA DE CRUCE
         *                            DEL PAGO.
         *                            CASO CONTRARIO SE RETORNA LA FECHA DEL HISTORIAL SI LA FECHA DE CREACION DEL HISTORIAL ES MAYOR O IGUAL QUE LA
         *                            FECHA DE MODIFICACION DEL PAGO.
         *                            CASO CONTRARIO SI LA FECHA DE CRUCE SE ENCUENTRA DENTRO DEL RANGO CONSULTADO SE RETORNA LA FECHA DE CRUCE DEL
         *                            PAGO.
         *                            CASO CONTRARIO SI LA FECHA DE ULTIMA MODIFICACION SE ENCUENTRA DENTRO DEL RANGO CONSULTADO SE RETORNA LA FECHA
         *                            DE ULTIMA MODIFICACION DEL PAGO.
         *                            FINALMENTE SI SE ENCONTRO HISTORIAL DENTRO DEL RANGO DE FECHAS CONSULTADO SE RETORNA LA FECHA DEL HISTORIAL
         *                            ENCONTRADO.
         */
        ELSIF TRIM(Fv_EstadoPago) = 'Asignado' THEN
          --
          IF Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL IS NOT NULL AND Lrf_GetInfoPagoHistorial.FE_CRUCE IS NOT NULL
             AND Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL >= Lrf_GetInfoPagoHistorial.FE_CRUCE THEN
            --
            IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
              --
              Lv_Resultado := NVL(TRIM(Lrf_GetInfoPagoHistorial.ESTADO_PAGO_HISTORIAL), NULL);
              --
            ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
              --
              Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL), 'DD/MM/YY');
              --
            END IF;
            --
          ELSIF Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL IS NOT NULL AND Lrf_GetInfoPagoHistorial.FE_ULT_MOD IS NOT NULL
             AND Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL >= Lrf_GetInfoPagoHistorial.FE_ULT_MOD THEN
            --
            IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
              --
              Lv_Resultado := NVL(TRIM(Lrf_GetInfoPagoHistorial.ESTADO_PAGO_HISTORIAL), NULL);
              --
            ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
              --
              Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL), 'DD/MM/YY');
              --
            END IF;
            --
          ELSIF Lrf_GetInfoPagoHistorial.FE_CRUCE IS NOT NULL
             AND Lrf_GetInfoPagoHistorial.FE_CRUCE >= CAST(TO_DATE(Fv_FechaConsultaDesde, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
             AND Lrf_GetInfoPagoHistorial.FE_CRUCE < CAST(TO_DATE(Fv_FechaConsultaHasta, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1 THEN
            --
            IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
              --
              Lv_Resultado := NVL(TRIM(Lrf_GetInfoPagoHistorial.ESTADO_PAGO), NULL);
              --
            ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
              --
              Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_CRUCE), 'DD/MM/YY');
              --
            END IF;
            --
          ELSIF Lrf_GetInfoPagoHistorial.FE_ULT_MOD IS NOT NULL
             AND Lrf_GetInfoPagoHistorial.FE_ULT_MOD >= CAST(TO_DATE(Fv_FechaConsultaDesde, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)
             AND Lrf_GetInfoPagoHistorial.FE_ULT_MOD < CAST(TO_DATE(Fv_FechaConsultaHasta, 'DD/MM/YY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1 THEN
            --
            IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
              --
              Lv_Resultado := NVL(TRIM(Lrf_GetInfoPagoHistorial.ESTADO_PAGO), NULL);
              --
            ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
              --
              Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_ULT_MOD), 'DD/MM/YY');
              --
            END IF;
            --
          ELSIF Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL IS NOT NULL AND Lrf_GetInfoPagoHistorial.ESTADO_PAGO_HISTORIAL IS NOT NULL THEN
            --
            IF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'ESTADO' THEN
              --
              Lv_Resultado := Lrf_GetInfoPagoHistorial.ESTADO_PAGO_HISTORIAL;
              --
            ELSIF TRIM(Fv_Filtro) IS NOT NULL AND TRIM(Fv_Filtro) = 'HISTORIAL' THEN
              --
              Lv_Resultado := TO_CHAR(TRUNC(Lrf_GetInfoPagoHistorial.FE_CREACION_HISTORIAL), 'DD/MM/YY');
              --
            END IF;
            --
          END IF;
          --
        END IF;--ELSIF TRIM(Fv_EstadoPago) = 'Asignado' THEN
        --
      END IF;--IF Lrf_GetInfoPagoHistorial.ID_PAGO IS NOT NULL AND Lrf_GetInfoPagoHistorial.ID_PAGO > 0 THEN
      --
      --
      RETURN Lv_Resultado;
      --
    ELSE
      --
      Lv_MensajeError := 'No se ha enviado todos los par�metros correspondientes para la b�squeda del historial del pago. Fv_FechaConsultaDesde('
                         || Fv_FechaConsultaDesde || ') Fv_FechaConsultaHasta(' || Fv_FechaConsultaHasta || '), Fn_IdPagoCab(' || Fn_IdPagoCab
                         || '), Fv_EstadoPago(' || Fv_EstadoPago || ')';
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    Lv_Resultado := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_HISTORIAL_PAGO_ANTICIPO',
                                          Lv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lv_Resultado;
    --
  WHEN OTHERS THEN
    --
    Lv_Resultado := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_HISTORIAL_PAGO_ANTICIPO',
                                          'Error al obtener el historial del pago - ' || SQLCODE || ' - ERROR_STACK: '
                                          || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lv_Resultado;
    --
  END F_GET_HISTORIAL_PAGO_ANTICIPO;
  --
  --
  PROCEDURE P_VALIDAR_FECHA_DEPOSITO(
      Pv_FechaValidar        IN VARCHAR2,
      Pv_ParametroValidar    IN VARCHAR2,
      Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_RespuestaValidacion OUT VARCHAR2,
      Pv_MensajeError        OUT VARCHAR2)
  IS
    --
    Lv_NombreParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'VALIDACIONES_PROCESOS_CONTABLES';
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
    Ld_FechaAValidar DATE;
    Lr_GetAdmiParamtrosDet DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
    Le_Exception EXCEPTION;
    --
  BEGIN
    --
    --Busca el dia hasta el cual se podr� ingresar pagos, anticipos y/o procesar dep�sitos
    Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_NombreParametroCab,
                                                                       Lv_EstadoActivo,
                                                                       Lv_EstadoActivo,
                                                                       NULL,
                                                                       Pv_ParametroValidar,
                                                                       NULL,
                                                                       Pv_PrefijoEmpresa);
    --
    FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
    --
    CLOSE Lrf_GetAdmiParamtrosDet;
    --
    --Si la variable no es nula existe parametro no permitido mapeado
    IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND TRIM(Lr_GetAdmiParamtrosDet.VALOR1) IS NOT NULL THEN
      --
      IF TRIM(Pv_FechaValidar) IS NOT NULL THEN
        --
        --Se calcula hasta que fecha se podr� generar el pago, anticipo o deposito creado. Para ello se le suma un mes a la fecha enviada como
        --par�metro 'Pv_FechaValidar'.
        Ld_FechaAValidar := TO_DATE( Pv_FechaValidar, 'DD-MM-YYYY' ) + Lr_GetAdmiParamtrosDet.VALOR1;
        --
        --
        --Se verifica si la fecha actual es menor o igual a la fecha permitida para poder continuar con el proceso.
        IF TRUNC(SYSDATE) <= Ld_FechaAValidar THEN
          --
          Pv_RespuestaValidacion := 'S';
          --
        ELSE
          --
          Pv_RespuestaValidacion := 'N';
          --
        END IF;
        --
      ELSE
        --
        Pv_MensajeError := 'No se ha enviado la fecha para validar el pago, anticipo o proceso de deposito';
        --
        RAISE Le_Exception;
        --
      END IF;
      --
    ELSE
      --
      --En caso de no encontrar el par�metro de validaci�n el proceso debe continuar puesto que no aplica para todas las empresas
      Pv_RespuestaValidacion := 'S';
      --
    END IF;
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    Pv_RespuestaValidacion := 'N';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_VALIDAR_FECHA_DEPOSITO',
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    Pv_RespuestaValidacion := 'N';
    --
    Pv_MensajeError := 'Error al validar la fecha del pago, anticipo o deposito creado - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK
                       || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_VALIDAR_FECHA_DEPOSITO',
                                          Pv_MensajeError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_VALIDAR_FECHA_DEPOSITO;
  --
  --
  FUNCTION F_GET_TIPO_COMPROBANTE_EXP(
    Fn_IdEmpresa         IN   INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fn_IdDocumento       IN   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2
  IS
  --
  CURSOR C_GetTipoComprobanteExp( Cn_IdEmpresa            INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Cn_IdDocumento          INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                  Cv_NombreParametroCab   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_Valor1               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
  IS
  SELECT    CASE WHEN (  SELECT COUNT(1)
                          FROM INFO_DOCUMENTO_FINANCIERO_DET FE,
                                 DB_COMERCIAL.ADMI_PRODUCTO AP
                         WHERE FE.PRODUCTO_ID              = AP.ID_PRODUCTO
                         AND   FE.DOCUMENTO_ID             = IDFC.ID_DOCUMENTO
                         AND   AP.CODIGO_PRODUCTO          IN ('REMB', 'FINA')
                         AND AP.DESCRIPCION_PRODUCTO       IN ('REMBOLSO DE GASTO','REEMBOLSO DE GASTOS')) >= 1

                 THEN ( SELECT FNCK_CONSULTS.F_GET_DETALLE_EXPORTACIONES( Cn_IdEmpresa, Cv_NombreParametroCab, Cv_Valor1 ) FROM DUAL )
                 WHEN ( ATDF.CODIGO_TIPO_COMP_ATS_SRI = '18')
                 THEN LPAD(ATDF.CODIGO_TIPO_COMPROB_SRI, 2, '0')
                 ELSE LPAD(ATDF.CODIGO_TIPO_COMP_ATS_SRI, 2, '0')
            END CODIGO_COMP_SRI
  FROM  INFO_DOCUMENTO_FINANCIERO_CAB   IDFC,
        ADMI_TIPO_DOCUMENTO_FINANCIERO  ATDF
  WHERE IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
  AND   IDFC.ID_DOCUMENTO           = Cn_IdDocumento ;
  --
  Lv_NombreParametrCab  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE;
  Lv_Valor1             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
  Lv_TipoComprobanteExp VARCHAR2(50) := NULL ;
  --
  BEGIN
  --
  Lv_NombreParametrCab  := 'TIPO_COMPROBANTE_REEMBOLSO';
  Lv_Valor1             := 'REEMB';
  --
  IF C_GetTipoComprobanteExp%ISOPEN THEN
    CLOSE C_GetTipoComprobanteExp;
  END IF;
  --
  OPEN C_GetTipoComprobanteExp( Fn_IdEmpresa, Fn_IdDocumento, Lv_NombreParametrCab,
                                Lv_Valor1 );
  --
  FETCH C_GetTipoComprobanteExp INTO Lv_TipoComprobanteExp;
  --
  CLOSE C_GetTipoComprobanteExp;
  --
  RETURN Lv_TipoComprobanteExp;
  --
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_TIPO_COMPROBANTE_EXP',
                                          'Error al obtener la informaci�n del tipo de comprobante de exportacion ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  --
  END F_GET_TIPO_COMPROBANTE_EXP;
  --
  --
  FUNCTION F_GET_DETALLE_EXPORTACIONES(
    Fn_IdEmpresa         IN   INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_NombreParametro   IN   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Fv_Valor1            IN   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
  RETURN VARCHAR2
  IS
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_Valor2               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE := '';
  --
  BEGIN
  --
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Fv_NombreParametro,
                                                                      'Activo',
                                                                      'Activo',
                                                                      Fv_Valor1,
                                                                      NULL,
                                                                      'NULL',
                                                                      Fn_IdEmpresa);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
     Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
      --
      Lv_Valor2 := Lr_GetAdmiParamtrosDet.VALOR2;
      --
  END IF;
  --
  RETURN Lv_Valor2;
  --
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_DETALLE_EXPORTACIONES',
                                          'Error al obtener la informaci�n del detalle de exportaciones' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  --
  END F_GET_DETALLE_EXPORTACIONES;
  --
  FUNCTION F_GET_EXPORTACIONES(
    Fn_IdEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_FechaInicio IN VARCHAR2,
    Fv_FechaFin    IN VARCHAR2)
  RETURN XMLTYPE
  IS
  CURSOR C_GetExportaciones(Cn_IdEmpresa        INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                            Ct_FechaInicio      TIMESTAMP,
                            Ct_FechaFin         TIMESTAMP,
                            Cv_Pais             DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE,
                            Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                            Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
   SELECT XMLAGG(XMLELEMENT("detalleExportaciones" ,
                    XMLFOREST( TMP.CODIGO_SRI_EXP "tpIdClienteEx" ),
                    XMLFOREST( DB_GENERAL.GNRLPCK_UTIL.F_REGEX_BY_PARAM( Cn_IdEmpresa, SUBSTR( FNCK_COM_ELECTRONICO.F_GET_VARCHAR_VALID_XML_VALUE( TMP.IDENTIFICACION_CLIENTE )  , 0, 13 ) ,'VALIDA_VALOR_TAG_XML_ATS','EXPRESION_REGULAR') "idClienteEx" ),
                    XMLFOREST( FNCK_CONSULTS.F_GET_PARTE_REL_VTAS( TMP.IDENTIFICACION_CLIENTE, Cn_IdEmpresa ) "parteRelExp"  ),
                    XMLFOREST( FNCK_CONSULTS.F_GET_DETALLE_EXPORTACIONES( Cn_IdEmpresa, 'TIPO_DE_TRIBUTARIO_ATS', TMP.TIPO_TRIBUTARIO )  "tipoCli" ),
                    XMLFOREST( DECODE( FNCK_COM_ELECTRONICO.F_GET_VARCHAR_VALID_XML_VALUE( TMP.RAZON_SOCIAL ) , '', DB_GENERAL.GNRLPCK_UTIL.F_REGEX_BY_PARAM( Cn_IdEmpresa, FNCK_COM_ELECTRONICO.F_GET_VARCHAR_VALID_XML_VALUE( TMP.NOMBRES || TMP.APELLIDOS ), 'VALIDA_VALOR_TAG_XML_ATS', 'EXPRESION_REGULAR') ,
                                       DB_GENERAL.GNRLPCK_UTIL.F_REGEX_BY_PARAM( Cn_IdEmpresa , FNCK_COM_ELECTRONICO.F_GET_VARCHAR_VALID_XML_VALUE( TMP.RAZON_SOCIAL ), 'VALIDA_VALOR_TAG_XML_ATS', 'EXPRESION_REGULAR') ) "denoExpCli" ),
                    XMLFOREST( FNCK_CONSULTS.F_GET_DETALLE_EXPORTACIONES( Cn_IdEmpresa, 'EXPORTACIONES_ATS_TN', 'TIPO_REGI')  "tipoRegi" ),
                    XMLFOREST( (SELECT AP.CODIGO_PAIS_ATS_EXPORTACION FROM DB_GENERAL.ADMI_PAIS AP WHERE AP.NOMBRE_PAIS = TMP.PAIS )   "paisEfecPagoGen" ),
                    XMLFOREST( (SELECT AP.CODIGO_PAIS_ATS_EXPORTACION FROM DB_GENERAL.ADMI_PAIS AP WHERE AP.NOMBRE_PAIS = TMP.PAIS )  "paisEfecExp" ),
                    XMLFOREST( FNCK_CONSULTS.F_GET_DETALLE_EXPORTACIONES( Cn_IdEmpresa, 'EXPORTACIONES_ATS_TN', 'EXPORTACION_DE')    "exportacionDe" ),
                    XMLFOREST( FNCK_CONSULTS.F_GET_DETALLE_EXPORTACIONES( Cn_IdEmpresa, 'EXPORTACIONES_ATS_TN', 'TIP_ING_EXT')   "tipIngExt" ),
                    XMLFOREST( TMP.GRAVA_OTRO_PAIS  "ingExtGravOtroPais" ),                    
                    XMLFOREST( TMP.RETENCION_EXTERIOR "impuestoOtroPais" ),
                    XMLFOREST( TMP.CODIGO_COMP_SRI "tipoComprobante" ),
                    XMLFOREST( TO_CHAR(TMP.FECHA_EMISION, 'DD/MM/YYYY') "fechaEmbarque" ),
                    XMLFOREST( NVL( TRIM(TO_CHAR( ROUND( NVL( TMP.SUBTOTAL, 0.00 ) ,2 ) ,'9999999999990D99')) , '0.00')   "valorFOB" ),
                    XMLFOREST( NVL( TRIM(TO_CHAR( ROUND( NVL( TMP.SUBTOTAL, 0.00 ) ,2 ) ,'9999999999990D99')) , '0.00')  "valorFOBComprobante" ),
                    XMLFOREST( TMP.ESTABLECIMIENTO "establecimiento" ),
                    XMLFOREST( TMP.PUNTO_EMISION "puntoEmision" ),
                    XMLFOREST( TMP.SECUENCIAL "secuencial" ),
                    XMLFOREST( TMP.NUMERO_AUTORIZACION "autorizacion" ),
                    XMLFOREST( TO_CHAR(TMP.FECHA_EMISION, 'DD/MM/YYYY') "fechaEmision" )
                    )
                )
  FROM (
      SELECT
          ATI.CODIGO_SRI_EXP ,
          ATDF.CODIGO_TIPO_COMP_ATS_SRI CODIGO_SRI,
          IPR.IDENTIFICACION_CLIENTE,
          FNCK_CONSULTS.F_GET_TIPO_COMPROBANTE_EXP(Cn_IdEmpresa, IDFC.ID_DOCUMENTO) CODIGO_COMP_SRI,
          LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0) ESTABLECIMIENTO,
          LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) +1, (INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 2) - INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1)) - 1), 1, 3), 3, 0) PUNTO_EMISION,
          LPAD(SUBSTR(IDFC.NUMERO_FACTURA_SRI, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 2) + 1, 9), 9, 0) SECUENCIAL,
          IDFC.NUMERO_AUTORIZACION NUMERO_AUTORIZACION,
          IDFC.FE_EMISION FECHA_EMISION,
          NVL( ROUND( NVL( IDFC.SUBTOTAL, 0.00) , 2), 0 ) SUBTOTAL,
          IPR.TIPO_TRIBUTARIO TIPO_TRIBUTARIO,
          IPR.RAZON_SOCIAL RAZON_SOCIAL,
          IPR.NOMBRES NOMBRES,
          IPR.APELLIDOS APELLIDOS,
          FNCK_CONSULTS.F_SET_ATTR_PAIS(IP.PERSONA_EMPRESA_ROL_ID ) PAIS,
          CASE 
            WHEN FNCK_CONSULTS.GET_VALOR_RETENCIONBYDOC(IDFC.ID_DOCUMENTO, 'EXT') = 0 THEN
              'NO'
            ELSE
              'SI'
           END GRAVA_OTRO_PAIS,
          CASE 
            WHEN FNCK_CONSULTS.GET_VALOR_RETENCIONBYDOC(IDFC.ID_DOCUMENTO, 'EXT') = 0 THEN
              NULL
            ELSE
              FNCK_CONSULTS.GET_VALOR_RETENCIONBYDOC(IDFC.ID_DOCUMENTO, 'EXT')
           END RETENCION_EXTERIOR,
          'EXPORTACION' EXPORTACION
        FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
          INFO_OFICINA_GRUPO IOG,
          INFO_PUNTO IP,
          INFO_PERSONA_EMPRESA_ROL IPER,
          INFO_PERSONA IPR,
          ADMI_TIPO_IDENTIFICACION ATI,
          ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
        WHERE IDFC.OFICINA_ID           = IOG.ID_OFICINA
        AND IOG.EMPRESA_ID              = LPAD(NVL( Cn_IdEmpresa , IOG.EMPRESA_ID), 2, 0)
        AND IDFC.PUNTO_ID               = IP.ID_PUNTO
        AND IP.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
        AND IPER.PERSONA_ID             = IPR.ID_PERSONA
        AND IPR.TIPO_IDENTIFICACION     = ATI.ID_TIPO_IDENTIFICACION
        AND ATI.DESCRIPCION             = 'PASAPORTE'
        AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
        AND ATDF.CODIGO_TIPO_DOCUMENTO  IN ('FAC','FACP', 'NC')
        AND IDFC.ESTADO_IMPRESION_FACT  IN (SELECT APD.VALOR1
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                            AND   APD.VALOR2           =  'SI'
                                            AND   APD.ESTADO           =  Cv_EstadoActivo
                                            AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
        AND IDFC.NUM_FACT_MIGRACION     IS NULL
        AND IDFC.FE_EMISION             >= Ct_FechaInicio
        AND IDFC.FE_EMISION             <= Ct_FechaFin
        AND  FNCK_CONSULTS.F_SET_ATTR_PAIS(IP.PERSONA_EMPRESA_ROL_ID ) <> Cv_Pais
    ) TMP
  GROUP BY TMP.EXPORTACION;
  --
  CURSOR GetFechaInicio( Cv_FechaInicio VARCHAR2 )
  IS
   SELECT CAST(TO_DATE( Cv_FechaInicio || ' 00:00:00', 'DD-MM-YYYY HH24:MI:SS') AS TIMESTAMP WITH LOCAL TIME ZONE)
      FROM dual;
  --
  CURSOR GetFechaFin( Cv_FechaFin VARCHAR2 )
  IS
    SELECT CAST(TO_DATE( Cv_FechaFin || ' 23:59:59', 'DD-MM-YYYY HH24:MI:SS') AS TIMESTAMP WITH LOCAL TIME ZONE)
      FROM dual;
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_Pais                 DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE                 := '';
  Lxml_Exportaciones      XMLTYPE                                               := NULL;
  Lt_FechaInicio          TIMESTAMP (6);
  Lt_FechaFin             TIMESTAMP (6);
  Lv_EstadoActivo         DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';
  Lv_NombreParametro      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE   := 'ESTADOS_DF_ATS';
  --
  BEGIN
  --
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('PAIS_ORIGEN_ATS',
                                                                     'Activo',
                                                                     'Activo',
                                                                     'PAIS_ATS',
                                                                      NULL,
                                                                     'NULL',
                                                                     Fn_IdEmpresa);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  --
  Lv_Pais := Lr_GetAdmiParamtrosDet.VALOR2;
  --
  --Realizo el castero de la fechaInicio a TIMESTAMP
  IF GetFechaInicio%ISOPEN THEN
    CLOSE GetFechaInicio;
  END IF;
  --
  OPEN GetFechaInicio( Fv_FechaInicio );
  --
  FETCH GetFechaInicio INTO Lt_FechaInicio;
  --
  CLOSE GetFechaInicio;
  --
  --Realizo el castero de la fechaFin a TIMESTAMP
  IF GetFechaFin%ISOPEN THEN
    CLOSE GetFechaFin;
  END IF;
  --
  OPEN GetFechaFin( Fv_FechaFin );
  --
  FETCH GetFechaFin INTO Lt_FechaFin;
  --
  CLOSE GetFechaFin;

  IF C_GetExportaciones%ISOPEN THEN
  CLOSE C_GetExportaciones;
  END IF;
  --
  OPEN C_GetExportaciones(Fn_IdEmpresa, Lt_FechaInicio, Lt_FechaFin, Lv_Pais,
                          Lv_EstadoActivo, Lv_NombreParametro);
  --
  FETCH C_GetExportaciones INTO Lxml_Exportaciones;
  --
  CLOSE C_GetExportaciones;
  --
  RETURN Lxml_Exportaciones;
  --
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_EXPORTACIONES',
                                          'Error al obtener la informaci�n de exportaciones' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  --
  END F_GET_EXPORTACIONES;
  --
  FUNCTION F_SET_ATTR_PAIS(
    Fn_IdPersonaRol      IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  RETURN DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE
  IS
    --
    CURSOR C_GetPaisCliente(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
    IS
      SELECT
        AP.NOMBRE_PAIS
      FROM INFO_PERSONA_EMPRESA_ROL IPER,
        INFO_PERSONA IPR
      LEFT JOIN DB_GENERAL.ADMI_PAIS AP
      ON AP.ID_PAIS           = IPR.PAIS_ID
      WHERE IPER.PERSONA_ID   = IPR.ID_PERSONA
      AND IPER.ID_PERSONA_ROL = Cn_IdPersonaRol;
    --
    Ln_NombrePais DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE  := '';
    --
  BEGIN
    --
    IF C_GetPaisCliente%ISOPEN THEN
      CLOSE C_GetPaisCliente;
    END IF;
    --
    OPEN C_GetPaisCliente( Fn_IdPersonaRol );
    --
    FETCH C_GetPaisCliente INTO Ln_NombrePais;
    --
    CLOSE C_GetPaisCliente;
    --
    IF Ln_NombrePais IS NULL THEN
      --
      Ln_NombrePais := 'ECUADOR';
      --
    END IF;
    --
    RETURN Ln_NombrePais;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('ATS', 'FNCK_CONSULTS.F_SET_ATTR_PAIS', SQLERRM);
    --
    RETURN NULL;
    --
  END F_SET_ATTR_PAIS;
  --
  FUNCTION F_GET_PARTE_REL_VTAS(
      Fv_IdentCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
      Fn_IdEmpresa    IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN VARCHAR2
  IS
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  --
  Lv_ParteRelVtas         VARCHAR2(2) := '';
  --
  BEGIN
  --
  Lv_ParteRelVtas := 'NO';
  --
  IF Fv_IdentCliente IS NOT NULL THEN
    --
    Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('EMPRESAS_RELACIONADAS_TN',
                                                                       'Activo',
                                                                       'Activo',
                                                                       'EMPRESA_RELACIONADA',
                                                                        Fv_IdentCliente,
                                                                       'NULL',
                                                                       Fn_IdEmpresa);
    --
    FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
    --
    CLOSE Lrf_GetAdmiParamtrosDet;
    --
    IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
       Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
        --
        Lv_ParteRelVtas := 'SI';
        --
    END IF;
  --
  END IF;
  --
  RETURN Lv_ParteRelVtas;
  --
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_PARTE_REL_VTAS',
                                          'Error al obtener la informaci�n de empresas relacionadas ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  --
  END F_GET_PARTE_REL_VTAS;
  --
  FUNCTION GET_COMPENSACIONES(
    Fn_IdEmpresa    IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_FechaInicio  IN VARCHAR2,
    Fv_FechaFin     IN VARCHAR2,
    Fv_IdentCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fn_codTipoSri   IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_COMP_ATS_SRI%TYPE)
  RETURN XMLTYPE
  IS
  --
  CURSOR C_GetComp( Cv_TipoComp   DB_GENERAL.ADMI_IMPUESTO.CODIGO_SRI%TYPE,
                    Cn_MontoComp  INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE)
  IS
    SELECT XMLELEMENT("compensacion", XMLFOREST(Cv_TipoComp "tipoCompe"),
           XMLFOREST(TRIM( TO_CHAR( NVL(Cn_MontoComp , 0.00) , '9999999990D00')) "monto"))
    FROM DUAL;
  --
  CURSOR C_Get_CodigoComp(Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE,
                          Cv_Estado       DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE)
  IS
    SELECT AI.CODIGO_ATS
    FROM DB_GENERAL.ADMI_IMPUESTO AI
    WHERE AI.TIPO_IMPUESTO = Cv_TipoImpuesto
    AND   AI.ESTADO        = Cv_Estado;
  --
  CURSOR C_Get_MontoComp( Cn_IdEmpresa        INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                          Ct_FechaInicio      TIMESTAMP,
                          Ct_FechaFin         TIMESTAMP,
                          Cv_identCliente     DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                          Cn_codTipoSri       ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_COMP_ATS_SRI%TYPE,
                          Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                          Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
    SELECT TRIM( TO_CHAR( NVL( SUM( ROUND( NVL( IDFC.DESCUENTO_COMPENSACION, 0.00 )  , 4)) , 0.00) , '9999999990D00')) COMPENSACION
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
      INFO_OFICINA_GRUPO IOG,
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR
    WHERE IDFC.OFICINA_ID             = IOG.ID_OFICINA
    AND IOG.EMPRESA_ID                = LPAD(NVL(Cn_IdEmpresa, IOG.EMPRESA_ID), 2, 0)
    AND IDFC.PUNTO_ID                 = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID               = IPR.ID_PERSONA
    AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP', 'NC')
    AND IDFC.ESTADO_IMPRESION_FACT    IN (SELECT APD.VALOR1
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                            AND   APD.VALOR2           =  'SI'
                                            AND   APD.ESTADO           =  Cv_EstadoActivo
                                            AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
    AND IDFC.NUM_FACT_MIGRACION       IS NULL
    AND IDFC.FE_EMISION               >= Ct_FechaInicio
    AND IDFC.FE_EMISION               <= Ct_FechaFin
    AND IPR.IDENTIFICACION_CLIENTE    = Cv_identCliente
    AND ATDF.CODIGO_TIPO_COMP_ATS_SRI = Cn_codTipoSri;
  --
  CURSOR GetFechaInicio( Cv_FechaInicio VARCHAR2 )
  IS
    SELECT CAST(TO_DATE( Cv_FechaInicio || ' 00:00:00', 'DD-MM-YYYY HH24:MI:SS') AS TIMESTAMP WITH LOCAL TIME ZONE)
      FROM dual;
  --
  CURSOR GetFechaFin( Cv_FechaFin VARCHAR2 )
  IS
    SELECT CAST(TO_DATE( Cv_FechaFin || ' 23:59:59', 'DD-MM-YYYY HH24:MI:SS') AS TIMESTAMP WITH LOCAL TIME ZONE)
      FROM dual;
  --
  LXML_Compensacion   XMLTYPE                                                   := NULL;
  Ln_TipoImpuesto     DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE               := 'COM';
  Lv_Estado           DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE                      := 'Activo';
  Lv_tipoComp         DB_GENERAL.ADMI_IMPUESTO.CODIGO_SRI%TYPE                  := '';
  Ln_MontoComp        INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE := 0.00;
  Lv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
  Lv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'ESTADOS_DF_ATS';
  Lt_FechaInicio      TIMESTAMP (6);
  Lt_FechaFin         TIMESTAMP (6);
  --
  BEGIN
  --
  --Realizo el castero de la fechaInicio a TIMESTAMP
  IF GetFechaInicio%ISOPEN THEN
    CLOSE GetFechaInicio;
  END IF;
  --
  OPEN GetFechaInicio( Fv_FechaInicio );
  --
  FETCH GetFechaInicio INTO Lt_FechaInicio;
  --
  CLOSE GetFechaInicio;
  --
  --Realizo el castero de la fechaFin a TIMESTAMP
  IF GetFechaFin%ISOPEN THEN
    CLOSE GetFechaFin;
  END IF;
  --
  OPEN GetFechaFin( Fv_FechaFin );
  --
  FETCH GetFechaFin INTO Lt_FechaFin;
  --
  CLOSE GetFechaFin;
  --
  --
  IF C_Get_CodigoComp%ISOPEN THEN
    --
    CLOSE C_Get_CodigoComp;
    --
  END IF;
  --
  IF C_Get_MontoComp%ISOPEN THEN
    --
    CLOSE C_Get_MontoComp;
    --
  END IF;
  --
  OPEN C_Get_CodigoComp(Ln_TipoImpuesto, Lv_Estado);
  --
  FETCH C_Get_CodigoComp INTO Lv_tipoComp;
  --
  CLOSE C_Get_CodigoComp;
  --
  OPEN C_Get_MontoComp(Fn_IdEmpresa, Lt_FechaInicio, Lt_FechaFin, Fv_IdentCliente,
                       Fn_codTipoSri, Lv_EstadoActivo, Lv_NombreParametro);
  --
  FETCH C_Get_MontoComp INTO Ln_MontoComp;
  --
  CLOSE C_Get_MontoComp;
  --
  IF C_GetComp%ISOPEN THEN
    CLOSE C_GetComp;
  END IF;
  --
  OPEN C_GetComp(Lv_tipoComp, Ln_MontoComp);
  --
  FETCH C_GetComp INTO LXML_Compensacion;
  --
  CLOSE C_GetComp;
  --
  RETURN LXML_Compensacion;
  --
  EXCEPTION
  WHEN OTHERS THEN

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.GET_COMPENSACIONES',
                                          'Error al obtener la informaci�n de compensaciones ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  END GET_COMPENSACIONES;
  --
  FUNCTION F_GET_FORMA_PAGO_POR_CLIENTE(
    Fv_IdentCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE)
  RETURN DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE
  IS
  --
  CURSOR C_GetFormaPagoPorCliente(Cv_identCliente DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE )
    IS
    SELECT AFP.CODIGO_SRI
      FROM INFO_PERSONA IP
    JOIN INFO_PERSONA_EMPRESA_ROL IPER  ON IPER.PERSONA_ID            = IP.ID_PERSONA
    JOIN INFO_CONTRATO IC               ON IC.PERSONA_EMPRESA_ROL_ID  = IPER.ID_PERSONA_ROL
    JOIN ADMI_FORMA_PAGO AFP            ON AFP.ID_FORMA_PAGO          = IC.FORMA_PAGO_ID
    WHERE IP.IDENTIFICACION_CLIENTE     = Cv_identCliente
    AND   ROWNUM                        = 1
    ORDER BY IC.ID_CONTRATO DESC;
  --
  CURSOR C_GetFormaPagoPorPreCliente(Cv_identCliente DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE )
    IS
    SELECT AFP.CODIGO_SRI
      FROM INFO_PERSONA IP
    JOIN INFO_PERSONA_EMPRESA_ROL                 IPER  ON IPER.PERSONA_ID              = IP.ID_PERSONA
    JOIN DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO IPEFP ON IPEFP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    JOIN ADMI_FORMA_PAGO AFP                            ON AFP.ID_FORMA_PAGO            = IPEFP.FORMA_PAGO_ID
    WHERE IP.IDENTIFICACION_CLIENTE = Cv_identCliente
    AND   ROWNUM                    = 1
    ORDER BY IPEFP.ID_DATOS_PAGO DESC;
  --
  Lv_CodigoSri             DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE := NULL;
  --
  BEGIN
  --
    IF Fv_IdentCliente IS NOT NULL THEN
      --
      IF C_GetFormaPagoPorCliente%ISOPEN THEN
      --
      CLOSE C_GetFormaPagoPorCliente;
      --
      END IF;
      --
      OPEN C_GetFormaPagoPorCliente(Fv_IdentCliente);
      --
      FETCH C_GetFormaPagoPorCliente INTO Lv_CodigoSri;
      --
      CLOSE C_GetFormaPagoPorCliente;
      --
      IF Lv_CodigoSri IS NULL THEN
        --
        IF C_GetFormaPagoPorPreCliente%ISOPEN THEN
          CLOSE C_GetFormaPagoPorPreCliente;
        END IF;
        --
        OPEN C_GetFormaPagoPorPreCliente(Fv_IdentCliente);
        --
        FETCH C_GetFormaPagoPorPreCliente INTO Lv_CodigoSri;
        --
        CLOSE C_GetFormaPagoPorPreCliente;
        --
        IF Lv_CodigoSri IS NULL THEN
          Lv_CodigoSri := '20';
        END IF;
        --
      END IF;
    END IF;
  --
  RETURN Lv_CodigoSri;
  --
  EXCEPTION
  WHEN OTHERS THEN
    --

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_FORMA_PAGO_POR_CLIENTE',
                                          'Error al obtener la informaci�n de forma de pago por cliente ' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  --
  END F_GET_FORMA_PAGO_POR_CLIENTE;
  --
  FUNCTION F_GET_TOTAL_IMPUESTOS(
    Fn_IdEmpresa    IN DB_FINANCIERO.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_FechaInicio  IN VARCHAR2,
    Fv_FechaFin     IN VARCHAR2,
    Fn_tipoImpuesto IN VARCHAR2,
    Fv_identCliente IN DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    Fn_codTipoSri   IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_COMP_ATS_SRI%TYPE)
  RETURN VARCHAR2
  IS
  --
  --Cursor de tarifa 0%
  CURSOR C_Get_BaseImp(Cn_IdEmpresa       INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                       Ct_FechaInicio     TIMESTAMP,
                       Ct_FechaFin        TIMESTAMP,
                       Cv_identCliente    DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                       Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                       Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)


  IS
    WITH TMP_CODIGO_FAC AS ( SELECT ATDF.CODIGO_TIPO_COMP_ATS_SRI
                              FROM ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                            WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('FACP', 'FAC')
                            GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI ),
         TMP_CODIGO_NC  AS ( SELECT ATDF.CODIGO_TIPO_COMP_ATS_SRI
                              FROM ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                            WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('NC')
                            GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI )
    SELECT
        DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, ( SELECT TMP_CODIGO_FAC.CODIGO_TIPO_COMP_ATS_SRI FROM TMP_CODIGO_FAC ) , TRIM( TO_CHAR( NVL( ROUND(SUM( (( NVL(IDFD.CANTIDAD, 0.00) * NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0.00) ) - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0.00) )), 4 ) , 0.00) , '9999999990D00')) ) FAC,
        DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, ( SELECT TMP_CODIGO_NC.CODIGO_TIPO_COMP_ATS_SRI FROM TMP_CODIGO_NC   ), TRIM( TO_CHAR(  NVL( ROUND(SUM( (( NVL(IDFD.CANTIDAD, 0.00) * NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0.00) ) - NVL(IDFD.DESCUENTO_FACPRO_DETALLE, 0.00) )), 4 ) , 0.00) , '9999999990D00')) ) NC
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_OFICINA_GRUPO IOG,
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
      INFO_DOCUMENTO_FINANCIERO_DET IDFD
    LEFT JOIN INFO_DOCUMENTO_FINANCIERO_IMP IDFI ON IDFD.ID_DOC_DETALLE = IDFI.DETALLE_DOC_ID
    WHERE IDFC.OFICINA_ID             = IOG.ID_OFICINA
    AND IDFC.ID_DOCUMENTO             = IDFD.DOCUMENTO_ID
    AND IOG.EMPRESA_ID                = LPAD(NVL( Cn_IdEmpresa , IOG.EMPRESA_ID), 2, 0)
    AND IDFC.PUNTO_ID                 = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID               = IPR.ID_PERSONA
    AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP', 'NC')
    AND IDFC.ESTADO_IMPRESION_FACT    IN (SELECT APD.VALOR1
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                            AND   APD.VALOR2           =  'SI'
                                            AND   APD.ESTADO           =  Cv_EstadoActivo
                                            AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
    AND IDFC.NUM_FACT_MIGRACION       IS NULL
    AND IDFC.FE_EMISION               >= Ct_FechaInicio
    AND IDFC.FE_EMISION               <= Ct_FechaFin
    AND IDFI.DETALLE_DOC_ID           IS NULL
    AND IPR.IDENTIFICACION_CLIENTE    = Cv_identCliente
    AND NVL(IDFD.PRODUCTO_ID,0)       NOT IN (SELECT AP.ID_PRODUCTO
                                               FROM ADMI_PRODUCTO AP
                                              WHERE AP.CODIGO_PRODUCTO    IN ('REMB', 'FINA')
                                              AND AP.DESCRIPCION_PRODUCTO IN ('REMBOLSO DE GASTO','REEMBOLSO DE GASTOS'))
    GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI;
  --
  --Cursor de tarifa 0% reembolso
  CURSOR C_Get_BaseImpReembolso(Cn_IdEmpresa        INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Ct_FechaInicio      TIMESTAMP,
                                Ct_FechaFin         TIMESTAMP,
                                Cv_identCliente     DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
    SELECT
        TO_CHAR( NVL( ROUND( SUM( (( NVL(IDFD.CANTIDAD, 0.00) * NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0.00) ) - NVL(IDFD.DESCUENTO_FACPRO_DETALLE,0.00)) ), 4 ) , 0.00) , '9999999990D00') BASE_IMP_REEMBOLSO
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_OFICINA_GRUPO IOG,
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
      INFO_DOCUMENTO_FINANCIERO_DET IDFD
    LEFT JOIN INFO_DOCUMENTO_FINANCIERO_IMP IDFI ON IDFD.ID_DOC_DETALLE = IDFI.DETALLE_DOC_ID
    WHERE IDFC.OFICINA_ID             = IOG.ID_OFICINA
    AND IDFC.ID_DOCUMENTO             = IDFD.DOCUMENTO_ID
    AND IOG.EMPRESA_ID                = LPAD(NVL( Cn_IdEmpresa , IOG.EMPRESA_ID), 2, 0)
    AND IDFC.PUNTO_ID                 = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID               = IPR.ID_PERSONA
    AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP', 'NC')
    AND IDFC.ESTADO_IMPRESION_FACT    IN (SELECT APD.VALOR1
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                            AND   APD.VALOR2           =  'SI'
                                            AND   APD.ESTADO           =  Cv_EstadoActivo
                                            AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
    AND IDFC.NUM_FACT_MIGRACION       IS NULL
    AND IDFC.FE_EMISION               >= Ct_FechaInicio
    AND IDFC.FE_EMISION               <= Ct_FechaFin
    AND IDFI.DETALLE_DOC_ID           IS NULL
    AND IPR.IDENTIFICACION_CLIENTE    = Cv_identCliente
    AND NVL(IDFD.PRODUCTO_ID,0)       IN (SELECT AP.ID_PRODUCTO
                                            FROM ADMI_PRODUCTO AP
                                          WHERE AP.CODIGO_PRODUCTO    IN ('REMB', 'FINA')
                                          AND AP.DESCRIPCION_PRODUCTO IN ('REMBOLSO DE GASTO','REEMBOLSO DE GASTOS'));
  --
  CURSOR C_Get_BaseImpGrav(Cn_IdEmpresa       INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                           Ct_FechaInicio     TIMESTAMP,
                           Ct_FechaFin        TIMESTAMP,
                           Cv_identCliente    DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                           Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                           Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
  WITH TMP_CODIGO_FAC AS (SELECT ATDF.CODIGO_TIPO_COMP_ATS_SRI
                            FROM ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                          WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('FACP', 'FAC')
                          GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI),
       TMP_CODIGO_NC  AS (SELECT ATDF.CODIGO_TIPO_COMP_ATS_SRI
                            FROM ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                          WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('NC')
                          GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI)
  SELECT     DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, ( SELECT TMP_CODIGO_FAC.CODIGO_TIPO_COMP_ATS_SRI FROM TMP_CODIGO_FAC ) , TRIM( TO_CHAR( NVL( ROUND( SUM( (( NVL( IDFD.CANTIDAD, 0.00 )  * NVL( IDFD.PRECIO_VENTA_FACPRO_DETALLE ,0.00 ) ) - NVL( IDFD.DESCUENTO_FACPRO_DETALLE, 0.00 ) )), 4 ) , 0.00) , '9999999990D00')) ) FAC,
             DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, ( SELECT TMP_CODIGO_NC.CODIGO_TIPO_COMP_ATS_SRI FROM TMP_CODIGO_NC   ) , TRIM( TO_CHAR( NVL( ROUND( SUM( (( NVL( IDFD.CANTIDAD, 0.00)   * NVL( IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0.00 ) ) - NVL( IDFD.DESCUENTO_FACPRO_DETALLE, 0.00 ) )), 4 ) , 0.00) , '9999999990D00'))  ) NC
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      INFO_OFICINA_GRUPO IOG,
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
      ADMI_IMPUESTO AI
    WHERE IDFC.OFICINA_ID             = IOG.ID_OFICINA
    AND IDFC.ID_DOCUMENTO             = IDFD.DOCUMENTO_ID
    AND IDFD.ID_DOC_DETALLE           = IDFI.DETALLE_DOC_ID
    AND IDFI.IMPUESTO_ID              = AI.ID_IMPUESTO
    AND IOG.EMPRESA_ID                = LPAD(NVL( Cn_IdEmpresa , IOG.EMPRESA_ID), 2, 0)
    AND IDFC.PUNTO_ID                 = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID               = IPR.ID_PERSONA
    AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP', 'NC')
    AND IDFC.ESTADO_IMPRESION_FACT    IN (SELECT APD.VALOR1
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                            AND   APD.VALOR2           =  'SI'
                                            AND   APD.ESTADO           =  Cv_EstadoActivo
                                            AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
    AND IDFC.NUM_FACT_MIGRACION       IS NULL
    AND IDFC.FE_EMISION               >= Ct_FechaInicio
    AND IDFC.FE_EMISION               <= Ct_FechaFin
    AND IPR.IDENTIFICACION_CLIENTE    = Cv_identCliente
    AND AI.TIPO_IMPUESTO              =  'IVA'
    AND NVL(IDFD.PRODUCTO_ID,0)       NOT IN (SELECT AP.ID_PRODUCTO
                                               FROM ADMI_PRODUCTO AP
                                              WHERE AP.CODIGO_PRODUCTO    IN ('REMB', 'FINA')
                                              AND AP.DESCRIPCION_PRODUCTO IN ('REMBOLSO DE GASTO','REEMBOLSO DE GASTOS'))
    GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI;
  --
  CURSOR C_Get_BaseImpGravReembolso(Cn_IdEmpresa        INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Ct_FechaInicio      TIMESTAMP,
                                    Ct_FechaFin         TIMESTAMP,
                                    Cv_identCliente     DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                    Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                    Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
  SELECT TRIM( TO_CHAR( NVL( ROUND( SUM( ( ( NVL( IDFD.CANTIDAD, 0.00 )  * NVL( IDFD.PRECIO_VENTA_FACPRO_DETALLE, 0.00 ) ) - NVL( IDFD.DESCUENTO_FACPRO_DETALLE, 0.00 ) ) ), 4 ) , 0.00) , '9999999990D00')) BASE_GRAV_REEMB
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      INFO_OFICINA_GRUPO IOG,
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR,
      ADMI_IMPUESTO AI,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE IDFC.ID_DOCUMENTO           = IDFD.DOCUMENTO_ID
    AND IDFD.ID_DOC_DETALLE           = IDFI.DETALLE_DOC_ID
    AND IDFI.IMPUESTO_ID              = AI.ID_IMPUESTO
    AND IDFC.OFICINA_ID               = IOG.ID_OFICINA
    AND IOG.EMPRESA_ID                = LPAD(NVL( Cn_IdEmpresa , IOG.EMPRESA_ID), 2, 0)
    AND IDFC.PUNTO_ID                 = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID               = IPR.ID_PERSONA
    AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP', 'NC')
    AND IDFC.ESTADO_IMPRESION_FACT    IN (SELECT APD.VALOR1
                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                            AND   APD.VALOR2           =  'SI'
                                            AND   APD.ESTADO           =  Cv_EstadoActivo
                                            AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
    AND IDFC.NUM_FACT_MIGRACION       IS NULL
    AND IDFC.FE_EMISION               >= Ct_FechaInicio
    AND IDFC.FE_EMISION               <= Ct_FechaFin
    AND IPR.IDENTIFICACION_CLIENTE    =  Cv_identCliente
    AND AI.TIPO_IMPUESTO              =  'IVA'
    AND NVL(IDFD.PRODUCTO_ID,0)       IN (SELECT AP.ID_PRODUCTO
                                            FROM ADMI_PRODUCTO AP
                                          WHERE AP.CODIGO_PRODUCTO    IN ('REMB', 'FINA')
                                          AND AP.DESCRIPCION_PRODUCTO IN ('REMBOLSO DE GASTO','REEMBOLSO DE GASTOS'));
  --
  CURSOR C_Get_TotalImpuestos(Cn_IdEmpresa        INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Ct_FechaInicio      TIMESTAMP,
                              Ct_FechaFin         TIMESTAMP,
                              Cv_tipoImpuesto     VARCHAR2,
                              Cv_identCliente     DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                              Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                              Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
  WITH TMP_CODIGO_FAC AS (SELECT ATDF.CODIGO_TIPO_COMP_ATS_SRI
                            FROM ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                          WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('FACP', 'FAC')
                          GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI),
       TMP_CODIGO_NC  AS (SELECT ATDF.CODIGO_TIPO_COMP_ATS_SRI
                            FROM ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
                          WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('NC')
                          GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI)
    SELECT
    DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, ( SELECT TMP_CODIGO_FAC.CODIGO_TIPO_COMP_ATS_SRI FROM TMP_CODIGO_FAC ) , TRIM( TO_CHAR( NVL( ROUND( SUM( NVL( IDFI.VALOR_IMPUESTO, 0.00 ) ) , 4 ) , 0.00 ) , '9999999990D00')) ) IMP_FAC,
    DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, ( SELECT TMP_CODIGO_NC.CODIGO_TIPO_COMP_ATS_SRI FROM TMP_CODIGO_NC   ),  TRIM( TO_CHAR( NVL( ROUND( SUM( NVL( IDFI.VALOR_IMPUESTO, 0.00 ) ) , 4 ) , 0.00 ) , '9999999990D00')) ) IMP_NC
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      INFO_OFICINA_GRUPO IOG,
      DB_GENERAL.ADMI_IMPUESTO AI,
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE IDFC.OFICINA_ID           = IOG.ID_OFICINA
    AND IDFD.ID_DOC_DETALLE         = IDFI.DETALLE_DOC_ID
    AND IDFC.ID_DOCUMENTO           = IDFD.DOCUMENTO_ID
    AND IDFI.IMPUESTO_ID            = AI.ID_IMPUESTO
    AND IOG.EMPRESA_ID              = LPAD(NVL( Cn_IdEmpresa , IOG.EMPRESA_ID), 2, 0)
    AND IDFC.PUNTO_ID               = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID             = IPR.ID_PERSONA
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP', 'NC')
    AND IDFC.ESTADO_IMPRESION_FACT IN (SELECT APD.VALOR1
                                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                             DB_GENERAL.ADMI_PARAMETRO_DET APD
                                        WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                        AND   APD.VALOR2           =  'SI'
                                        AND   APD.ESTADO           =  Cv_EstadoActivo
                                        AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
    AND IDFC.NUM_FACT_MIGRACION    IS NULL
    AND IDFC.FE_EMISION            >= Ct_FechaInicio
    AND IDFC.FE_EMISION            <= Ct_FechaFin
    AND AI.TIPO_IMPUESTO           = Cv_tipoImpuesto
    AND IPR.IDENTIFICACION_CLIENTE = Cv_identCliente
    AND NVL(IDFD.PRODUCTO_ID,0)    NOT IN (SELECT AP.ID_PRODUCTO
                                            FROM ADMI_PRODUCTO AP
                                          WHERE AP.CODIGO_PRODUCTO    IN ('REMB', 'FINA')
                                          AND AP.DESCRIPCION_PRODUCTO IN ('REMBOLSO DE GASTO','REEMBOLSO DE GASTOS'))
    GROUP BY ATDF.CODIGO_TIPO_COMP_ATS_SRI;
  --
  CURSOR C_Get_TotalImpuestosReembolso(Cn_IdEmpresa       INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Ct_FechaInicio     TIMESTAMP,
                                       Ct_FechaFin        TIMESTAMP,
                                       Cv_tipoImpuesto    VARCHAR2,
                                       Cv_identCliente    DB_FINANCIERO.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                       Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                       Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
  SELECT
     TRIM( TO_CHAR( NVL( ROUND( SUM( NVL( IDFI.VALOR_IMPUESTO, 0.00 ) ) , 4 ) , 0.00 ) , '9999999990D00'))  IMP_REEMBOLSO
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
      INFO_OFICINA_GRUPO IOG,
      DB_GENERAL.ADMI_IMPUESTO AI,
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE IDFC.ID_DOCUMENTO         = IDFD.DOCUMENTO_ID
    AND IDFD.ID_DOC_DETALLE         = IDFI.DETALLE_DOC_ID
    AND IDFC.OFICINA_ID             = IOG.ID_OFICINA
    AND IDFI.IMPUESTO_ID            = AI.ID_IMPUESTO
    AND IOG.EMPRESA_ID              = LPAD(NVL( Cn_IdEmpresa , IOG.EMPRESA_ID), 2, 0)
    AND IDFC.PUNTO_ID               = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID             = IPR.ID_PERSONA
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO  IN ('FAC','FACP', 'NC')
    AND IDFC.ESTADO_IMPRESION_FACT  IN (SELECT APD.VALOR1
                                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                             DB_GENERAL.ADMI_PARAMETRO_DET APD
                                        WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                        AND   APD.VALOR2           =  'SI'
                                        AND   APD.ESTADO           =  Cv_EstadoActivo
                                        AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
    AND IDFC.NUM_FACT_MIGRACION     IS NULL
    AND IDFC.FE_EMISION             >= Ct_FechaInicio
    AND IDFC.FE_EMISION             <= Ct_FechaFin
    AND AI.TIPO_IMPUESTO            = Cv_tipoImpuesto
    AND NVL(IDFD.PRODUCTO_ID,0)     IN (SELECT AP.ID_PRODUCTO
                                          FROM ADMI_PRODUCTO AP
                                        WHERE AP.CODIGO_PRODUCTO    IN ('REMB', 'FINA')
                                        AND AP.DESCRIPCION_PRODUCTO IN ('REMBOLSO DE GASTO','REEMBOLSO DE GASTOS'))
    AND IPR.IDENTIFICACION_CLIENTE  = Cv_identCliente;
  --
  CURSOR GetFechaInicio( Cv_FechaInicio VARCHAR2 )
  IS
    SELECT CAST(TO_DATE( Cv_FechaInicio || ' 00:00:00', 'DD-MM-YYYY HH24:MI:SS') AS TIMESTAMP WITH LOCAL TIME ZONE)
      FROM dual;
  --
  CURSOR GetFechaFin( Cv_FechaFin VARCHAR2 )
  IS
    SELECT CAST(TO_DATE( Cv_FechaFin || ' 23:59:59', 'DD-MM-YYYY HH24:MI:SS') AS TIMESTAMP WITH LOCAL TIME ZONE)
      FROM dual;
  --
  Lv_Impuesto                   VARCHAR2(500)                := NULL;
  Lr_BaseImpGrav                C_Get_BaseImpGrav%ROWTYPE    := NULL;
  Lr_TotalImp                   C_Get_TotalImpuestos%ROWTYPE := NULL;
  Lr_BaseImp                    C_Get_BaseImp%ROWTYPE        := NULL;
  Ln_ContBaseImpGrav            NUMBER(1);
  Ln_ContTotalImp               NUMBER(1);
  Ln_ContBaseImp                NUMBER(1);
  Lt_FechaInicio                TIMESTAMP (6);
  Lt_FechaFin                   TIMESTAMP (6);
  Lv_EstadoActivo               DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE            := 'Activo';
  Lv_NombreParametro            DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE  := 'ESTADOS_DF_ATS';
  --
BEGIN
  --
  Ln_ContBaseImpGrav            :=  0;
  Ln_ContTotalImp               :=  0;
  Ln_ContBaseImp                :=  0;
  --
  IF Fn_tipoImpuesto IS NOT NULL THEN
    --
    --Realizo el castero de la fechaInicio a TIMESTAMP
    IF GetFechaInicio%ISOPEN THEN
      CLOSE GetFechaInicio;
    END IF;
    --
    OPEN GetFechaInicio( Fv_FechaInicio );
    --
    FETCH GetFechaInicio INTO Lt_FechaInicio;
    --
    CLOSE GetFechaInicio;
    --
    --Realizo el castero de la fechaFin a TIMESTAMP
    IF GetFechaFin%ISOPEN THEN
      CLOSE GetFechaFin;
    END IF;
    --
    OPEN GetFechaFin( Fv_FechaFin );
    --
    FETCH GetFechaFin INTO Lt_FechaFin;
    --
    CLOSE GetFechaFin;
    --
    IF (Fn_tipoImpuesto = 'IVA') OR (Fn_tipoImpuesto = 'ICE') THEN
      --
      IF Fn_codTipoSri = '41' THEN
        --
        IF C_Get_TotalImpuestosReembolso%ISOPEN THEN
          CLOSE C_Get_TotalImpuestosReembolso;
        END IF;
        --
        OPEN C_Get_TotalImpuestosReembolso(Fn_IdEmpresa, Lt_FechaInicio, Lt_FechaFin, Fn_tipoImpuesto, Fv_identCliente,
                                           Lv_EstadoActivo, Lv_NombreParametro);
        FETCH C_Get_TotalImpuestosReembolso INTO Lv_Impuesto;
        CLOSE C_Get_TotalImpuestosReembolso;
        --
      ELSE
        --
        IF C_Get_TotalImpuestos%ISOPEN THEN
          CLOSE C_Get_TotalImpuestos;
        END IF;
        --
        OPEN C_Get_TotalImpuestos(Fn_IdEmpresa, Lt_FechaInicio, Lt_FechaFin, Fn_tipoImpuesto, Fv_identCliente,
                                  Lv_EstadoActivo, Lv_NombreParametro);
        --
        LOOP
            --
            FETCH C_Get_TotalImpuestos INTO Lr_TotalImp;
            --
            EXIT WHEN C_Get_TotalImpuestos%NOTFOUND;
            --
            Ln_ContTotalImp := Ln_ContTotalImp + 1;
            --
            IF  (Fn_codTipoSri = '18' AND Ln_ContTotalImp = 1) THEN
              --
              Lv_Impuesto   :=  Lr_TotalImp.IMP_FAC;
              --
              EXIT;
              --
            ELSIF (Fn_codTipoSri = '04' AND Ln_ContTotalImp = 2 ) THEN
              --
              Lv_Impuesto   :=  Lr_TotalImp.IMP_NC;
              --
              EXIT;
              --
            END IF;
            --
        END LOOP;
        --
        CLOSE C_Get_TotalImpuestos;
        --
        --Aparece el valor de NC en el primer registro
        IF Lv_Impuesto IS NULL AND  Fn_codTipoSri = '04' AND Ln_ContTotalImp  = 1 THEN
          --
          Lv_Impuesto :=  Lr_TotalImp.IMP_NC;
          --
        END IF;
        --
        Lr_TotalImp     := NULL;
        Ln_ContTotalImp := 0;
        --
      END IF;
      --
    ELSIF(Fn_tipoImpuesto = 'BIG') THEN
      --
      IF Fn_codTipoSri = '41' THEN
        --
        IF C_Get_BaseImpGravReembolso%ISOPEN THEN
          CLOSE C_Get_BaseImpGravReembolso;
        END IF;
        --
        OPEN C_Get_BaseImpGravReembolso(Fn_IdEmpresa, Lt_FechaInicio, Lt_FechaFin, Fv_identCliente,
                                        Lv_EstadoActivo, Lv_NombreParametro);
        FETCH C_Get_BaseImpGravReembolso INTO Lv_Impuesto;
        CLOSE C_Get_BaseImpGravReembolso;
        --
      ELSE
        --
        IF C_Get_BaseImpGrav%ISOPEN THEN
          CLOSE C_Get_BaseImpGrav;
        END IF;
        --
        OPEN C_Get_BaseImpGrav(Fn_IdEmpresa,  Lt_FechaInicio, Lt_FechaFin, Fv_identCliente,
                               Lv_EstadoActivo, Lv_NombreParametro);
        --
        LOOP
            --
            FETCH C_Get_BaseImpGrav INTO Lr_BaseImpGrav;
            --
            EXIT WHEN C_Get_BaseImpGrav%NOTFOUND;
            --
            Ln_ContBaseImpGrav := Ln_ContBaseImpGrav + 1;
            --
            IF  (Fn_codTipoSri = '18' AND Ln_ContBaseImpGrav = 1) THEN
              --
              Lv_Impuesto   :=  Lr_BaseImpGrav.FAC;
              --
              EXIT;
              --
            ELSIF (Fn_codTipoSri = '04' AND Ln_ContBaseImpGrav = 2 ) THEN
              --
              Lv_Impuesto   :=  Lr_BaseImpGrav.NC;
              --
              EXIT;
              --
            END IF;
            --
        END LOOP;
        --
        CLOSE C_Get_BaseImpGrav;
        --
        --Aparece el valor de NC en el primer registro
        IF Lv_Impuesto        IS NULL AND  Fn_codTipoSri = '04' AND Ln_ContBaseImpGrav  = 1 THEN
          --
          Lv_Impuesto :=  Lr_BaseImpGrav.NC;
          --
        END IF;
        --
        Lr_BaseImpGrav     := NULL;
        Ln_ContBaseImpGrav := 0;
        --
      END IF;
      --
    ELSIF(Fn_tipoImpuesto = 'BI') THEN
      --
      IF Fn_codTipoSri = '41' THEN
        --
        IF C_Get_BaseImpReembolso%ISOPEN THEN
          CLOSE C_Get_BaseImpReembolso;
        END IF;
        --
        OPEN C_Get_BaseImpReembolso(Fn_IdEmpresa,  Lt_FechaInicio, Lt_FechaFin, Fv_identCliente, Lv_EstadoActivo,
                                    Lv_NombreParametro);
        FETCH C_Get_BaseImpReembolso INTO Lv_Impuesto;
        CLOSE C_Get_BaseImpReembolso;
        --
      ELSE
        --
        IF C_Get_BaseImp%ISOPEN THEN
          CLOSE C_Get_BaseImp;
        END IF;
        --
        OPEN C_Get_BaseImp(Fn_IdEmpresa, Lt_FechaInicio, Lt_FechaFin, Fv_identCliente, Lv_EstadoActivo,
                          Lv_NombreParametro);
        --
        LOOP
            --
            FETCH C_Get_BaseImp INTO Lr_BaseImp;
            --
            EXIT WHEN C_Get_BaseImp%NOTFOUND;
            --
            Ln_ContBaseImp := Ln_ContBaseImp + 1;
            --
            IF  (Fn_codTipoSri = '18' AND Ln_ContBaseImp = 1) THEN
              --
              Lv_Impuesto   :=  Lr_BaseImp.FAC;
              --
              EXIT;
              --
            ELSIF (Fn_codTipoSri = '04' AND Ln_ContBaseImp = 2 ) THEN
              --
              Lv_Impuesto   :=  Lr_BaseImp.NC;
              --
              EXIT;
              --
            END IF;
            --
        END LOOP;
        --
        CLOSE C_Get_BaseImp;
        --
      END IF;
      --
    END IF;
  END IF;
  --
  RETURN Lv_Impuesto;
  --
  EXCEPTION
  WHEN OTHERS THEN
    FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.F_GET_TOTAL_IMPUESTOS', SQLERRM);
  --
  END F_GET_TOTAL_IMPUESTOS;
  --
  FUNCTION F_GET_FECHA_CRUCE_PAGO(
      Fn_IdPagoCab IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
      Fn_IdPagoDet IN DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE)
    RETURN DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE%TYPE
  IS
    --
    -- CURSOR QUE OBTIENE LA FECHA DE CRUCE CUANDO ENVIAN EL ID_PAGO DE LA CABECERA DEL PAGO
    CURSOR C_GetFechaCruceByIdPagoCab(Cn_IdPagoCab DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE)
    IS
      --
      SELECT
        IPC.FE_CRUCE
      FROM
        DB_FINANCIERO.INFO_PAGO_CAB IPC
      WHERE
        IPC.ID_PAGO = Cn_IdPagoCab;
    --
    -- CURSOR QUE OBTIENE LA FECHA DE CRUCE CUANDO ENVIAN EL ID_PAGO_DET DEL DETALLE DEL PAGO
    CURSOR C_GetFechaCruceByIdPagoDet(Cn_IdPagoDet DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE)
    IS
      --
      SELECT
        IPC.FE_CRUCE
      FROM
        DB_FINANCIERO.INFO_PAGO_DET IPD
      JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC
      ON
        IPD.PAGO_ID = IPC.ID_PAGO
      WHERE
        IPD.ID_PAGO_DET = Cn_IdPagoDet;
    --
    Lt_FeCruceDocumento DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE%TYPE;
    --
  BEGIN
    --
    -- SE CONSULTA LA FECHA DE CRUCE, SI SE ENVIA EL ID DEL DETALLE DEL PAGO
    IF Fn_IdPagoDet IS NOT NULL AND Fn_IdPagoDet > 0 THEN
      --
      IF C_GetFechaCruceByIdPagoDet%ISOPEN THEN
        --
        CLOSE C_GetFechaCruceByIdPagoDet;
        --
      END IF;
      --
      OPEN C_GetFechaCruceByIdPagoDet(Fn_IdPagoDet);
      --
      FETCH C_GetFechaCruceByIdPagoDet INTO Lt_FeCruceDocumento;
      --
      CLOSE C_GetFechaCruceByIdPagoDet;
      --
    --
    -- SE CONSULTA LA FECHA DE CRUCE, SI SE ENVIA EL ID DEL PAGO
    ELSIF Fn_IdPagoCab IS NOT NULL AND Fn_IdPagoCab > 0 THEN
      --
      IF C_GetFechaCruceByIdPagoCab%ISOPEN THEN
        --
        CLOSE C_GetFechaCruceByIdPagoCab;
        --
      END IF;
      --
      OPEN C_GetFechaCruceByIdPagoCab(Fn_IdPagoCab);
      --
      FETCH C_GetFechaCruceByIdPagoCab INTO Lt_FeCruceDocumento;
      --
      CLOSE C_GetFechaCruceByIdPagoCab;
      --
    END IF;
    --
    --
    RETURN Lt_FeCruceDocumento;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lt_FeCruceDocumento := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_FECHA_CRUCE_PAGO',
                                          'No se pudo obtener la fecha de cruce del pago' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lt_FeCruceDocumento;
    --
  END F_GET_FECHA_CRUCE_PAGO;
  --
  --
  PROCEDURE P_VALIDADOR_DOCUMENTOS(
      Pn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_Bandera     OUT VARCHAR2,
      Pn_Diferencia  OUT NUMBER )
  IS
    --
    --CURSOR QUE RETORNA LA SUMA TOTAL DEL TIPO DE IMPUESTO A CONSULTAR QUE PUEDE SER IVA O ICE
    --COSTO QUERY: 13
    CURSOR C_GetSumaImpuestos(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                              Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    IS
      --
      SELECT
        SUM(NVL(IDFI.VALOR_IMPUESTO, 0)) AS TOTAL
      FROM
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI
      ON
        IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
      JOIN DB_GENERAL.ADMI_IMPUESTO AI
      ON
        AI.ID_IMPUESTO = IDFI.IMPUESTO_ID
      WHERE
        IDFD.DOCUMENTO_ID  = Cn_IdDocumento
      AND AI.TIPO_IMPUESTO = Cv_TipoImpuesto;
    --
    Lrf_GetSumaImpuestos C_GetSumaImpuestos%ROWTYPE;
    Lv_TipoImpuestoIva DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE                             := 'IVA';
    Lv_TipoImpuestoIce DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE                             := 'ICE';
    Ln_ValorTotalIva DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE           := 0;
    Ln_ValorTotalIce DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE           := 0;
    Ln_ValorTotalImpuestos DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE     := 0;
    Ln_ValorTotalImpRedondeado DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE := 0;
    Ln_DiferenciaImpuestos DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE     := 0;
    --
  BEGIN
    --
    IF C_GetSumaImpuestos%ISOPEN THEN
      CLOSE C_GetSumaImpuestos;
    END IF;
    --
    --
    OPEN C_GetSumaImpuestos(Pn_IdDocumento, Lv_TipoImpuestoIva);
    --
    FETCH C_GetSumaImpuestos INTO Lrf_GetSumaImpuestos;
    --
    CLOSE C_GetSumaImpuestos;
    --
    --
    Ln_ValorTotalIva := NVL(Lrf_GetSumaImpuestos.TOTAL, 0);
    --
    --
    Lrf_GetSumaImpuestos := NULL;
    --
    --
    OPEN C_GetSumaImpuestos(Pn_IdDocumento, Lv_TipoImpuestoIce);
    --
    FETCH C_GetSumaImpuestos INTO Lrf_GetSumaImpuestos;
    --
    CLOSE C_GetSumaImpuestos;
    --
    --
    Ln_ValorTotalIce := NVL(Lrf_GetSumaImpuestos.TOTAL, 0);
    --
    --
    Ln_ValorTotalImpuestos     := NVL(Ln_ValorTotalIva, 0) + NVL(Ln_ValorTotalIce, 0);
    Ln_ValorTotalImpRedondeado := ROUND(NVL(Ln_ValorTotalIva, 0), 2) + ROUND(NVL(Ln_ValorTotalIce, 0), 2);
    Ln_DiferenciaImpuestos     := NVL(Ln_ValorTotalImpRedondeado, 0) - NVL(Ln_ValorTotalImpuestos, 0);
    --
    --
    IF Ln_DiferenciaImpuestos >= 0.005 AND Ln_DiferenciaImpuestos < 0.01 THEN
      --
      Pn_Diferencia := Ln_DiferenciaImpuestos;
      Pv_Bandera    := 'S';
      --
    ELSE
      --
      Pv_Bandera    := 'N';
      Pn_Diferencia := 0;
      --
    END IF;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Pv_Bandera    := 'N';
    Pn_Diferencia := 0;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_VALIDADOR_DOCUMENTOS',
                                          'Error en FNCK_CONSULTS.P_VALIDADOR_DOCUMENTOS - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                          ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_VALIDADOR_DOCUMENTOS;
  --
  --
  FUNCTION F_GET_FECHA_HISTORIAL(
      Fn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_EstadoDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
      Fv_FiltroBusqueda  IN VARCHAR2)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.FE_CREACION%TYPE
  IS
    --
    Lt_FeHistorial DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.FE_CREACION%TYPE;
    Lv_Query VARCHAR2(1500);
    Lc_GetFechaHistorial SYS_REFCURSOR;
    --
  BEGIN
    --
    Lv_Query := 'SELECT IDH.FE_CREACION '
                 || 'FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH '
                 || 'WHERE IDH.ID_DOCUMENTO_HISTORIAL = ( SELECT ';
    --
    --
    IF TRIM(Fv_FiltroBusqueda) IS NOT NULL AND (TRIM(Fv_FiltroBusqueda) = 'MAX' OR TRIM(Fv_FiltroBusqueda) = 'MAX_MOTIVO') THEN
      --
      Lv_Query := Lv_Query || ' MAX(IDH_S.ID_DOCUMENTO_HISTORIAL) ';
      --
    ELSIF TRIM(Fv_FiltroBusqueda) IS NOT NULL AND (TRIM(Fv_FiltroBusqueda) = 'MIN' OR TRIM(Fv_FiltroBusqueda) = 'MIN_MOTIVO') THEN
      --
      Lv_Query := Lv_Query || ' MIN(IDH_S.ID_DOCUMENTO_HISTORIAL) ';
      --
    END IF;
    --
    --
    Lv_Query := Lv_Query || ' FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH_S '
                         || ' WHERE IDH_S.DOCUMENTO_ID = ' || Fn_IdDocumento
                         || ' AND IDH_S.ESTADO         = ''' || Fv_EstadoDocumento || '''';
    --
    --
    IF TRIM(Fv_FiltroBusqueda) IS NOT NULL AND (TRIM(Fv_FiltroBusqueda) = 'MIN_MOTIVO' OR TRIM(Fv_FiltroBusqueda) = 'MAX_MOTIVO') THEN
      --
      Lv_Query := Lv_Query || ' AND IDH_S.MOTIVO_ID IS NOT NULL ';
      --
    END IF;
    --
    --
    Lv_Query := Lv_Query || ' ) ';
    --
    --
    OPEN Lc_GetFechaHistorial FOR Lv_Query;
    LOOP
      --
      FETCH Lc_GetFechaHistorial INTO Lt_FeHistorial;
      EXIT
      WHEN Lc_GetFechaHistorial%NOTFOUND;
      --
    END LOOP;
    --
    --
    RETURN Lt_FeHistorial;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lt_FeHistorial := NULL;
    --
    DBMS_OUTPUT.PUT_LINE('F_GET_FECHA_HISTORIAL'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    --
    RETURN Lt_FeHistorial;
      --
  END F_GET_FECHA_HISTORIAL;
  --
  --
  FUNCTION F_GET_EMPRESA_ELECTRONICAS(
    Fv_Estado              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE,
    Fv_FacturaElectronica  IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.FACTURA_ELECTRONICO%TYPE)
  RETURN DB_FINANCIERO.FNCK_CONSULTS.C_InfoEmpresaGrupo
  IS
    --
    Lrf_InfoEmpresaGrupo DB_FINANCIERO.FNCK_CONSULTS.C_InfoEmpresaGrupo;
    --
  BEGIN
    --
    OPEN Lrf_InfoEmpresaGrupo FOR
      SELECT COD_EMPRESA, PREFIJO
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
      WHERE ESTADO            = Fv_Estado
      AND FACTURA_ELECTRONICO = Fv_FacturaElectronica;
    --
  RETURN Lrf_InfoEmpresaGrupo;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lrf_InfoEmpresaGrupo := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_EMPRESA_ELECTRONICAS',
                                          'No se pudo obtener las empresas que usan documentos electronicos' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lrf_InfoEmpresaGrupo;
    --
  END F_GET_EMPRESA_ELECTRONICAS;
  --
  --
  FUNCTION F_GET_ADMI_NUMERACION(
    Fv_EstadoActivo          IN  DB_COMERCIAL.ADMI_NUMERACION.ESTADO%TYPE,
    Fv_CodEmpresa            IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fn_IntIdOficina          IN  DB_COMERCIAL.ADMI_NUMERACION.OFICINA_ID%TYPE,
    Fv_NumeracionUno         IN  DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_UNO%TYPE,
    Fv_NumeracionDos         IN  DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_DOS%TYPE,
    Fv_CodigoNumeracion      IN  DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE,
    Fv_EsOficinaFacturacion  IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE,
    Fv_EsMatriz              IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE,
    Fv_PrefijoEmpresa        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
  RETURN DB_FINANCIERO.FNKG_TYPES.Lr_AdmiNumeracion
  IS
    --
    --OBTIENE LA NUMERACION POR EMPRESA, OFICINA DE FACTURACION, SI ES MATRIZ Y EL CODIGO DE NUMERACION FACE
    CURSOR C_GetAdmiNumeracionAdicional(Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Cv_EsOficinaFacturacion DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE,
                                        Cv_EsMatriz DB_COMERCIAL.INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE,
                                        Cv_EstadoActivo DB_COMERCIAL.ADMI_NUMERACION.ESTADO%TYPE,
                                        Cv_CodigoNumeracion DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE)
    IS
      --
      SELECT AN.ID_NUMERACION,
        AN.EMPRESA_ID,
        AN.OFICINA_ID,
        AN.DESCRIPCION,
        AN.CODIGO,
        AN.NUMERACION_UNO,
        AN.NUMERACION_DOS,
        AN.SECUENCIA,
        AN.FE_CREACION,
        AN.USR_CREACION,
        AN.FE_ULT_MOD,
        AN.USR_ULT_MOD,
        AN.TABLA,
        AN.ESTADO,
        AN.NUMERO_AUTORIZACION,
        AN.PROCESOS_AUTOMATICOS,
        AN.TIPO_ID
      FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      JOIN DB_COMERCIAL.ADMI_NUMERACION AN
      ON IOG.ID_OFICINA = AN.OFICINA_ID
      WHERE IOG.EMPRESA_ID           = Cv_CodEmpresa
      AND IOG.ES_OFICINA_FACTURACION = Cv_EsOficinaFacturacion
      AND IOG.ES_MATRIZ              = Cv_EsMatriz
      AND AN.CODIGO                  = Cv_CodigoNumeracion
      AND AN.ESTADO                  = Cv_EstadoActivo
      AND IOG.ESTADO                 = Cv_EstadoActivo
      AND ROWNUM                     = 1;
    --
    --OBTIENE NUMERACION POR EMPRESA, OFICINA, SECUENCIAL UNO, SECUENCIAL DOS Y CODIGO DE NUMERACION FACE
    CURSOR C_GetAdmiNumeracionGeneral(Cv_EstadoActivo DB_COMERCIAL.ADMI_NUMERACION.ESTADO%TYPE,
                                      Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Cv_IntIdOficina DB_COMERCIAL.ADMI_NUMERACION.OFICINA_ID%TYPE,
                                      Cv_NumeracionUno DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_UNO%TYPE,
                                      Cv_NumeracionDos DB_COMERCIAL.ADMI_NUMERACION.NUMERACION_DOS%TYPE,
                                      Cv_CodigoNumeracion DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE)
    IS
      --
      SELECT AN.ID_NUMERACION,
        AN.EMPRESA_ID,
        AN.OFICINA_ID,
        AN.DESCRIPCION,
        AN.CODIGO,
        AN.NUMERACION_UNO,
        AN.NUMERACION_DOS,
        AN.SECUENCIA,
        AN.FE_CREACION,
        AN.USR_CREACION,
        AN.FE_ULT_MOD,
        AN.USR_ULT_MOD,
        AN.TABLA,
        AN.ESTADO,
        AN.NUMERO_AUTORIZACION,
        AN.PROCESOS_AUTOMATICOS,
        AN.TIPO_ID
      FROM DB_COMERCIAL.ADMI_NUMERACION AN
      WHERE AN.ESTADO         = Cv_EstadoActivo
        AND AN.EMPRESA_ID     = Cv_CodEmpresa
        AND AN.OFICINA_ID     = Cv_IntIdOficina
        AND AN.NUMERACION_UNO = Cv_NumeracionUno
        AND AN.NUMERACION_DOS = Cv_NumeracionDos
        AND AN.CODIGO         = Cv_CodigoNumeracion
        AND ROWNUM = 1;
    --
    Lr_AdmiNumeracionDocumento DB_FINANCIERO.FNKG_TYPES.Lr_AdmiNumeracion;
    --
  BEGIN
    --
    IF C_GetAdmiNumeracionGeneral%ISOPEN THEN
      --
      CLOSE C_GetAdmiNumeracionGeneral;
      --
    END IF;
    --
    --OBTIENE LA NUMERACION DEPENDIENDO DE LA OFICINA, EMPRESA, SECUENCIAL UNO, SECUENCIAL DOS Y CODIGO DE NUMERACION FACE
    OPEN C_GetAdmiNumeracionGeneral(Fv_EstadoActivo,
                                    Fv_CodEmpresa,
                                    Fn_IntIdOficina,
                                    Fv_NumeracionUno,
                                    Fv_NumeracionDos,
                                    Fv_CodigoNumeracion);
    --
    FETCH C_GetAdmiNumeracionGeneral INTO Lr_AdmiNumeracionDocumento;
    --
    CLOSE C_GetAdmiNumeracionGeneral;
    --
    --
    --SI NO ENCUENTRA NUMERACION INGRESA A BUSCAR POR EL M�TODO ADICIONAL SI LA EMPRESA ES DIFERENTE DE TN
    IF Lr_AdmiNumeracionDocumento.ID_NUMERACION IS NULL AND TRIM(Fv_PrefijoEmpresa) <> 'TN' THEN
      --
      IF C_GetAdmiNumeracionAdicional%ISOPEN THEN
        --
        CLOSE C_GetAdmiNumeracionAdicional;
        --
      END IF;
      --
      OPEN C_GetAdmiNumeracionAdicional(Fv_CodEmpresa,
                                        Fv_EsOficinaFacturacion,
                                        Fv_EsMatriz,
                                        Fv_EstadoActivo,
                                        Fv_CodigoNumeracion);
      --
      FETCH C_GetAdmiNumeracionAdicional INTO Lr_AdmiNumeracionDocumento;
      --
      CLOSE C_GetAdmiNumeracionAdicional;
      --
    END IF;
    --
    --
    RETURN Lr_AdmiNumeracionDocumento;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lr_AdmiNumeracionDocumento := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_ADMI_NUMERACION',
                                          'No se pudo obtener la numeracion para los documentos' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lr_AdmiNumeracionDocumento;
    --
  END F_GET_ADMI_NUMERACION;
  --
  --
  FUNCTION F_GET_DOCUMENTOS_REPETIDOS(
    Fv_CodEmpresa         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_EstadoActivo       IN  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
    Fv_NombreParametro    IN  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Fv_DescripcionDetalle IN  DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
    Fv_ValorDocumentos    IN  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    Fv_NumeroFacturaSri   IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    Fn_IdDocumento        IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN C_DocumentosRepetidos
  IS
    --
    Lrf_DocumentosRepetidos C_DocumentosRepetidos;
    --
  BEGIN
    --
    --COSTO DEL QUERY: 16
    OPEN Lrf_DocumentosRepetidos FOR
      SELECT IDFC.ID_DOCUMENTO, IDFC.OFICINA_ID, IDFC.PUNTO_ID
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      ON IOG.ID_OFICINA = IDFC.OFICINA_ID AND IOG.EMPRESA_ID = Fv_CodEmpresa
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
      WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN
      (SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
      WHERE APD.ESTADO           = Fv_EstadoActivo
      AND APC.ESTADO             = Fv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO   = Fv_NombreParametro
      AND APD.DESCRIPCION        = Fv_DescripcionDetalle
      AND APD.VALOR2             = Fv_ValorDocumentos
      )
    AND IDFC.NUMERO_FACTURA_SRI = Fv_NumeroFacturaSri
    AND IDFC.ID_DOCUMENTO <> NVL2(Fn_IdDocumento, Fn_IdDocumento,
     (SELECT MIN(IDFC_S.ID_DOCUMENTO)
     FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_S
     JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG_S
     ON IOG_S.ID_OFICINA = IDFC_S.OFICINA_ID AND IOG_S.EMPRESA_ID = Fv_CodEmpresa
     JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_S
     ON ATDF_S.ID_TIPO_DOCUMENTO = IDFC_S.TIPO_DOCUMENTO_ID
     WHERE IDFC_S.NUMERO_FACTURA_SRI = Fv_NumeroFacturaSri
     AND ATDF_S.CODIGO_TIPO_DOCUMENTO IN
      (SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
      WHERE APD.ESTADO           = Fv_EstadoActivo
      AND APC.ESTADO             = Fv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO   = Fv_NombreParametro
      AND APD.DESCRIPCION        = Fv_DescripcionDetalle
      AND APD.VALOR2             = Fv_ValorDocumentos
      ) ) );
    --
  RETURN Lrf_DocumentosRepetidos;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lrf_DocumentosRepetidos := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_REGULARIZAR_NUM_FACTURA_SRI',
                                          'No se pudo obtener los documentos repetidos' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lrf_DocumentosRepetidos;
    --
  END F_GET_DOCUMENTOS_REPETIDOS;
  --
  --
  PROCEDURE P_DESCARTA_PAGO_LINEA(
    Pv_EmpresaId        IN  DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE,
    Pt_FechaPlDescartar IN  TIMESTAMP,
    Pv_EstadoPl         IN  DB_FINANCIERO.INFO_PAGO_LINEA.ESTADO_PAGO_LINEA%TYPE,
    Pv_MsnResult        OUT VARCHAR2,
    Pv_MessageError     OUT VARCHAR2)
  IS
    --
    CURSOR C_GetPagoPendiente(Cn_EmpresaId DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE, Ct_FechaPlDescartar TIMESTAMP,
                              Cv_EstadoPl  DB_FINANCIERO.INFO_PAGO_LINEA.ESTADO_PAGO_LINEA%TYPE)
    IS
      SELECT IPL.ID_PAGO_LINEA,
             IPL.PERSONA_ID,
             IP.NOMBRES,
             IP.APELLIDOS,
             IPL.EMPRESA_ID,
             IPL.CANAL_PAGO_LINEA_ID,
             ACPL.DESCRIPCION_CANAL_PAGO_LINEA,
             IPL.VALOR_PAGO_LINEA,
             IPL.NUMERO_REFERENCIA,
             IPL.FE_CREACION,
             IPL.ESTADO_PAGO_LINEA
      FROM DB_FINANCIERO.INFO_PAGO_LINEA IPL,
        DB_FINANCIERO.INFO_PERSONA IP,
        DB_FINANCIERO.ADMI_CANAL_PAGO_LINEA ACPL
      WHERE IPL.PERSONA_ID        = IP.ID_PERSONA
      AND IPL.CANAL_PAGO_LINEA_ID = ACPL.ID_CANAL_PAGO_LINEA
      AND IPL.FE_CREACION         <  Ct_FechaPlDescartar
      AND IPL.FE_ULT_MOD          IS NULL
      AND IPL.ESTADO_PAGO_LINEA   = Cv_EstadoPl
      AND IPL.EMPRESA_ID          = Cn_EmpresaId
      ORDER BY IPL.FE_CREACION DESC;
    --
    Lv_MsnError             VARCHAR2(2000);
    Lv_MessageError         VARCHAR2(2000);
    Lc_GetAliasPlantilla    FNKG_TYPES.Lr_AliasPlantilla;
    Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
    Lr_PagoPendiente        C_GetPagoPendiente%ROWTYPE := NULL;
    Lr_InfoPagoLineaHist    INFO_PAGO_LINEA_HISTORIAL%ROWTYPE;
    Lcl_MessageMail         CLOB;
    Lcl_TablePagoPendiente  CLOB;
    Ln_CounterPagoPendiente NUMBER := 0;
    Ln_CounterUpdate        NUMBER := 0;
    Lb_BanderaUpdate        BOOLEAN;
    Le_Exception            EXCEPTION;
    --
  BEGIN
    --Obtiene Pagos en l�nea en estado Pendiente que tengan mas de 24 horas.
    IF C_GetPagoPendiente%ISOPEN THEN
      CLOSE C_GetPagoPendiente;
    END IF;
    --
    DBMS_LOB.CREATETEMPORARY(Lcl_TablePagoPendiente, TRUE);
    --
    OPEN C_GetPagoPendiente( Pv_EmpresaId, Pt_FechaPlDescartar, Pv_EstadoPl );
    --
    LOOP
      --
      FETCH C_GetPagoPendiente INTO Lr_PagoPendiente;
      --
      EXIT
    WHEN C_GetPagoPendiente%NOTFOUND;
      --
      IF Lr_PagoPendiente.ID_PAGO_LINEA                IS NOT NULL AND
         Lr_PagoPendiente.DESCRIPCION_CANAL_PAGO_LINEA IS NOT NULL AND
         Lr_PagoPendiente.VALOR_PAGO_LINEA             IS NOT NULL AND
         Lr_PagoPendiente.NUMERO_REFERENCIA            IS NOT NULL THEN
        --
        UPDATE DB_FINANCIERO.INFO_PAGO_LINEA IPL
        SET IPL.ESTADO_PAGO_LINEA = 'Eliminado',
            IPL.FE_ULT_MOD        = SYSDATE ,
            IPL.USR_ULT_MOD       = 'telcos'
        WHERE IPL.ID_PAGO_LINEA   = Lr_PagoPendiente.ID_PAGO_LINEA;
        --
        --Insertamos en la historial INFO_PAGO_HISTORIAL.
          Lr_InfoPagoLineaHist.ID_PAGO_LINEA_HIST  := DB_FINANCIERO.SEQ_INFO_PAGO_LINEA_HIST.nextval;
          Lr_InfoPagoLineaHist.PAGO_LINEA_ID       := Lr_PagoPendiente.ID_PAGO_LINEA;
          Lr_InfoPagoLineaHist.CANAL_PAGO_LINEA_ID := Lr_PagoPendiente.CANAL_PAGO_LINEA_ID;
          Lr_InfoPagoLineaHist.EMPRESA_ID          := Lr_PagoPendiente.EMPRESA_ID;
          Lr_InfoPagoLineaHist.PERSONA_ID          := Lr_PagoPendiente.PERSONA_ID;
          Lr_InfoPagoLineaHist.VALOR_PAGO_LINEA    := Lr_PagoPendiente.VALOR_PAGO_LINEA;
          Lr_InfoPagoLineaHist.NUMERO_REFERENCIA   := Lr_PagoPendiente.NUMERO_REFERENCIA;
          Lr_InfoPagoLineaHist.ESTADO_PAGO_LINEA   := 'Eliminado';
          Lr_InfoPagoLineaHist.OBSERVACION         := 'Pago en linea Descartado por la ejecucion del job que regulariza'
                                                       ||' los Pagos en Linea que se quedan en estado Pendiente'
                                                       || Lr_PagoPendiente.ID_PAGO_LINEA;
          Lr_InfoPagoLineaHist.PROCESO             := 'JOB - DESCARTA_PAGOS_EN_LINEA_MD';
          Lr_InfoPagoLineaHist.USR_CREACION        := 'telcos';
          Lr_InfoPagoLineaHist.FE_CREACION         := SYSDATE;
          --Inserta el pago en linea con su estado eliminado
          FNCK_TRANSACTION.P_INSERT_INFO_PAGO_HISTORIAL(Lr_InfoPagoLineaHist, Lv_MsnError);
          --
        IF SQL%ROWCOUNT > 0 THEN
          --
          COMMIT;
          --
          Ln_CounterUpdate := Ln_CounterUpdate + 1;
          Lb_BanderaUpdate := FALSE;
          --
        ELSE
          --
          Lv_MessageError  := ' Ocurri� un error al tratar de actualizar el estado del pago: ' ||
                              Lr_PagoPendiente.ID_PAGO_LINEA ;
          Lb_BanderaUpdate := TRUE;
          --
        END IF;
        --
        IF NOT Lb_BanderaUpdate THEN
          --Concatena las fila del pago actualizado.
          DBMS_LOB.APPEND(Lcl_TablePagoPendiente, '<tr><td> '
                          || Lr_PagoPendiente.NOMBRES
                          || ' </td><td> '
                          || Lr_PagoPendiente.APELLIDOS
                          || ' </td><td> '
                          || Lr_PagoPendiente.DESCRIPCION_CANAL_PAGO_LINEA
                          || ' </td><td> '
                          || Lr_PagoPendiente.VALOR_PAGO_LINEA
                          || ' </td><td> '
                          || Lr_PagoPendiente.NUMERO_REFERENCIA
                          || ' </td><td> '
                          || Lr_PagoPendiente.FE_CREACION
                          || ' </td><td> Eliminado </td></tr>');
        ELSE
          --Concatena las fila del pago pendiente no actualizado.
          DBMS_LOB.APPEND(Lcl_TablePagoPendiente, '<tr>'
                          || Lv_MessageError || '</tr>');
          --
          Lb_BanderaUpdate := FALSE;
          --
        END IF;
        --
      END IF;
      --
    END LOOP;
    --
    CLOSE C_GetPagoPendiente;
    --
    IF Ln_CounterUpdate > 0 THEN
      --
      Lrf_GetAdmiParamtrosDet := NULL;
      --Verifica que pueda enviar correo
      Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('ENVIO_CORREO_PL', 'Activo',
                                                                         'Activo', 'DESCARTAR_PL',
                                                                         'SI', NULL, NULL);
      --
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --VERIFICA SI ESTA ACTIVADO PARA ENVIAR CORREO
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
        --
        Lrf_GetAdmiParamtrosDet := NULL;
        --
        Lr_GetAdmiParamtrosDet := NULL;
        --Obtiene los parametros para el envio de correo
        Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('ENVIO_CORREO_PL', 'Activo', 'Activo',
                                                                           'DESCARTAR_PL_FROM_SUBJECT', NULL, NULL, NULL);
        --
        FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
        --
        CLOSE Lrf_GetAdmiParamtrosDet;
        --
        Lc_GetAliasPlantilla := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('DESCARTAR_PL');
        --
        IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
           Lc_GetAliasPlantilla.PLANTILLA          IS NOT NULL AND
           Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL AND
           Lc_GetAliasPlantilla.ALIAS_CORREOS      IS NOT NULL THEN
          --
          Lcl_MessageMail := F_CLOB_REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{ plDescartados | raw }}',
                                           Lcl_TablePagoPendiente);
          --Envia correo
          FNCK_CONSULTS.P_SEND_MAIL(Lr_GetAdmiParamtrosDet.VALOR2, Lc_GetAliasPlantilla.ALIAS_CORREOS,
                                    Lr_GetAdmiParamtrosDet.VALOR3, SUBSTR(Lcl_MessageMail, 1, 32767),
                                    'text/html; charset=UTF-8', Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN
            --
            Pv_MsnResult := 'No se pudo notificar por correo - ' || Lv_MsnError;
            --
          ELSE
            --
            Pv_MsnResult     := 'Se notific� por correo y se dieron de baja ' || Ln_CounterUpdate ||
                                ' pago(s) en estado pendiente que superaron el tiempo maximo de 24 horas.';
            Ln_CounterUpdate := 0;
            --
          END IF;
          --
        END IF; --Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET ...
        --
        DBMS_LOB.FREETEMPORARY(Lcl_TablePagoPendiente);
        Lcl_TablePagoPendiente := '';
        --
      END IF; --Lrf_GetAdmiParamtrosDet
      --
    ELSE
      --
      Pv_MsnResult := 'No existen pagos en estado pendiente que hayan superado el tiempo maximo de 24 horas.';
      --
    END IF; --Ln_CounterPagoPendiente
    --
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MessageError := 'Error en FNCK_CONSULTS.P_DESCARTA_PAGO_LINEA - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK
                        || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 'FNCK_CONSULTS.P_DESCARTA_PAGO_LINEA', Pv_MessageError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_DESCARTA_PAGO_LINEA;
  --
  --
  PROCEDURE P_SALDO_X_FACTURA_FECHA(
      Pn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pn_ReferenciaId    IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
      Pv_FeConsultaHasta IN VARCHAR2,
      Pv_TipoConsulta    IN VARCHAR2,
      Pn_Saldo           OUT NUMBER,
      Pv_MessageError    OUT VARCHAR2)
  IS
    --
    CURSOR C_GetFacturaByNC(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                            Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                            Cv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                            Cv_DocumentosNormales DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                            Cv_EstadosDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                            Cv_Facturas DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT IDFC.ID_DOCUMENTO,
        IDFC.VALOR_TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC
      LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      ON NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
      LEFT JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      ON ATDF.ID_TIPO_DOCUMENTO       = IDFC.TIPO_DOCUMENTO_ID
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN
        (SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
        WHERE APD.ESTADO         = Cv_EstadoActivo
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
        AND APD.DESCRIPCION      = Cv_DocumentosNormales
        AND APD.VALOR2           = Cv_Facturas
        )
    AND ATDF.ESTADO                 = Cv_EstadoActivo
    AND IDFC.ESTADO_IMPRESION_FACT IN
      (SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
      WHERE APD.ESTADO         = Cv_EstadoActivo
      AND APC.ESTADO           = Cv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
      AND APD.DESCRIPCION      = Cv_EstadosDocumentos
      AND APD.VALOR2           = Cv_Facturas
      )
    AND NC.ID_DOCUMENTO = Cn_IdDocumento;
    --
    CURSOR C_GetFactura(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                        Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                        Cv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                        Cv_EstadosDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                        Cv_Facturas DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE)
    IS
      SELECT IDFC.ID_DOCUMENTO,
        IDFC.VALOR_TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      WHERE IDFC.ESTADO_IMPRESION_FACT IN
        (SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
        WHERE APD.ESTADO         = Cv_EstadoActivo
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
        AND APD.DESCRIPCION      = Cv_EstadosDocumentos
        AND APD.VALOR2           = Cv_Facturas
        )
    AND IDFC.ID_DOCUMENTO = Cn_IdDocumento;
    --
    CURSOR C_GetSumTotalNotasCredito(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                     Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                     Cv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                     Cv_DocumentosNormales DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                     Cv_EstadosDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                     Cv_NotasCredito DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                     Cv_FeConsultaHasta VARCHAR2)
    IS
      --
      SELECT SUM(NVL2(IDFC_S.VALOR_TOTAL, IDFC_S.VALOR_TOTAL, 0)) VALOR_TOTAL
      FROM
        (SELECT MAX(IDH.ID_DOCUMENTO_HISTORIAL) AS ID_DOCUMENTO_HISTORIAL,
          IDH.DOCUMENTO_ID
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        JOIN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
        ON IDH.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
        JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
        ON ATDF.ID_TIPO_DOCUMENTO          = IDFC.TIPO_DOCUMENTO_ID
        WHERE IDFC.REFERENCIA_DOCUMENTO_ID = Cn_IdDocumento
        AND ATDF.CODIGO_TIPO_DOCUMENTO     IN
        (SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
        WHERE APD.ESTADO         = Cv_EstadoActivo
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
        AND APD.DESCRIPCION      = Cv_DocumentosNormales
        AND APD.VALOR2           = Cv_NotasCredito
        )
        AND ATDF.ESTADO                    = Cv_EstadoActivo
        AND IDH.ESTADO                     IN
        (SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
        WHERE APD.ESTADO         = Cv_EstadoActivo
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
        AND APD.DESCRIPCION      = Cv_EstadosDocumentos
        AND APD.VALOR2           = Cv_NotasCredito
        )
        AND IDH.FE_CREACION                < NVL2( Cv_FeConsultaHasta,
                                                   CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE) + 1,
                                                   CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE) + 1 )
        GROUP BY IDH.DOCUMENTO_ID
        ) TBL_NOTAS_CREDITO
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH_S
      ON IDH_S.ID_DOCUMENTO_HISTORIAL = TBL_NOTAS_CREDITO.ID_DOCUMENTO_HISTORIAL
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_S
      ON IDFC_S.ID_DOCUMENTO = IDH_S.DOCUMENTO_ID
      WHERE IDH_S.ESTADO     = Cv_EstadoActivo;
    --
    CURSOR C_GetPagos(Cn_IdReferencia INFO_PAGO_DET.REFERENCIA_ID%TYPE,
                      Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                      Cv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                      Cv_EstadosDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                      Cv_Pagos DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                      Cv_FeConsultaHasta VARCHAR2)
    IS
      SELECT IPD.ID_PAGO_DET,
        IPD.VALOR_PAGO,
        IPC.ESTADO_PAGO
      FROM DB_FINANCIERO.INFO_PAGO_DET IPD,
        DB_FINANCIERO.INFO_PAGO_CAB IPC
      WHERE IPC.ID_PAGO    = IPD.PAGO_ID
      AND IPC.ESTADO_PAGO IN
        (SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
        WHERE APD.ESTADO         = Cv_EstadoActivo
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
        AND APD.DESCRIPCION      = Cv_EstadosDocumentos
        AND APD.VALOR2           = Cv_Pagos
        )
      AND IPD.REFERENCIA_ID = Cn_IdReferencia
      AND (  (IPD.FE_CREACION < NVL2(Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                     CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1) AND IPC.FE_CRUCE IS NULL AND IPC.FE_ULT_MOD IS NULL)
             OR (IPD.FE_CREACION < NVL2(Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                        CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1) AND IPC.FE_CRUCE IS NULL
                 AND IPC.FE_ULT_MOD > NVL2(Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                           CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1) AND IPC.ESTADO_PAGO = 'Anulado' )
             OR (IPD.FE_CREACION < NVL2(Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                        CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1) AND IPC.FE_CRUCE IS NULL
                 AND IPC.FE_ULT_MOD < NVL2(Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                           CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1) AND IPC.ESTADO_PAGO IN ('Pendiente', 'Cerrado'))
             OR (IPC.FE_CRUCE < NVL2(Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                     CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1) ) );
    --
    CURSOR C_GetSumTotalNotaDebito(Cn_IdPagotDet INFO_PAGO_DET.ID_PAGO_DET%TYPE,
                                   Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                   Cv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                   Cv_DocumentosNormales DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                   Cv_EstadosDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                   Cv_NotasDebito DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                   Cv_FeConsultaHasta VARCHAR2)
    IS
      SELECT SUM(NVL2(IDFC.VALOR_TOTAL, IDFC.VALOR_TOTAL, 0)) VALOR_TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      WHERE IDFD.DOCUMENTO_ID         = IDFC.ID_DOCUMENTO
      AND IDFC.ESTADO_IMPRESION_FACT IN
        (SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
        WHERE APD.ESTADO         = Cv_EstadoActivo
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
        AND APD.DESCRIPCION      = Cv_EstadosDocumentos
        AND APD.VALOR2           = Cv_NotasDebito
        )
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.ESTADO                 = Cv_EstadoActivo
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN
      (SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
      WHERE APD.ESTADO         = Cv_EstadoActivo
      AND APC.ESTADO           = Cv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
      AND APD.DESCRIPCION      = Cv_DocumentosNormales
      AND APD.VALOR2           = Cv_NotasDebito
      )
    AND IDFD.PAGO_DET_ID = Cn_IdPagotDet
    AND IDFC.FE_EMISION  < NVL2(Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1);
    --
    CURSOR C_GetListadoNotaDebito(Cn_IdPagotDet INFO_PAGO_DET.ID_PAGO_DET%TYPE,
                                  Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                  Cv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_DocumentosNormales DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                  Cv_EstadosDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                  Cv_NotasDebito DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                  Cv_FeConsultaHasta VARCHAR2)
    IS
      SELECT IDFC.ID_DOCUMENTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      WHERE IDFD.DOCUMENTO_ID         = IDFC.ID_DOCUMENTO
      AND IDFC.ESTADO_IMPRESION_FACT IN
        (SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
        WHERE APD.ESTADO         = Cv_EstadoActivo
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
        AND APD.DESCRIPCION      = Cv_EstadosDocumentos
        AND APD.VALOR2           = Cv_NotasDebito
        )
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.ESTADO                 = Cv_EstadoActivo
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN
      (SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
      WHERE APD.ESTADO         = Cv_EstadoActivo
      AND APC.ESTADO           = Cv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
      AND APD.DESCRIPCION      = Cv_DocumentosNormales
      AND APD.VALOR2           = Cv_NotasDebito
      )
    AND IDFD.PAGO_DET_ID = Cn_IdPagotDet
    AND IDFC.FE_EMISION  < NVL2(Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1);
    --
    Lr_GetFactura C_GetFacturaByNC%ROWTYPE                                         := NULL;
    Lr_GetSumTotalNotaCredito C_GetSumTotalNotasCredito%ROWTYPE                    := NULL;
    Lr_GetSumTotalNotaDebito C_GetSumTotalNotaDebito%ROWTYPE                       := NULL;
    Lr_NotaDebito C_GetListadoNotaDebito%ROWTYPE                                   := NULL;
    Ln_TotalPago NUMBER                                                            := 0;
    Ln_TotalND   NUMBER                                                            := 0;
    Ln_TotalNC   NUMBER                                                            := 0;
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                      := 'Activo';
    Lv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'REPORTE_CARTERA';
    Lv_DocumentosNormales DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE           := 'DOCUMENTOS_NORMALES';
    Lv_EstadosDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE            := 'ESTADO_DOCUMENTOS';
    Lv_Facturas DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                          := 'FACTURAS';
    Lv_NotasCredito DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                      := 'NOTAS_CREDITO';
    Lv_Pagos DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                             := 'PAGOS';
    Lv_NotasDebito DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                       := 'NOTAS_DEBITO';
    --
  BEGIN
    --
    -- Si el Pn_ReferenciaId no es nulo obtiene la factura por la nota de credito con el campo referencia_documento_id
    IF Pn_IdDocumento IS NULL AND Pn_ReferenciaId IS NOT NULL AND Pn_ReferenciaId > 0 THEN
      --
      IF C_GetFacturaByNC%ISOPEN THEN
        --
        CLOSE C_GetFacturaByNC;
        --
      END IF;
      --
      OPEN C_GetFacturaByNC(Pn_ReferenciaId, Lv_EstadoActivo, Lv_ParametroReporteCartera, Lv_DocumentosNormales, Lv_EstadosDocumentos, Lv_Facturas);
      --
      FETCH C_GetFacturaByNC INTO Lr_GetFactura;
      --
      CLOSE C_GetFacturaByNC;
      --
      --Obtiene la factura por su id de documento
    ELSIF Pn_IdDocumento IS NOT NULL AND Pn_IdDocumento > 0 THEN
      --
      IF C_GetFactura%ISOPEN THEN
        --
        CLOSE C_GetFactura;
        --
      END IF;
      --
      OPEN C_GetFactura(Pn_IdDocumento, Lv_EstadoActivo, Lv_ParametroReporteCartera, Lv_EstadosDocumentos, Lv_Facturas);
      --
      FETCH C_GetFactura INTO Lr_GetFactura;
      --
      CLOSE C_GetFactura;
      --
    END IF;-- IF Pn_IdDocumento IS NULL AND Pn_ReferenciaId IS NOT NULL AND Pn_ReferenciaId > 0
    --
    --
    IF Lr_GetFactura.ID_DOCUMENTO IS NOT NULL AND Lr_GetFactura.ID_DOCUMENTO > 0 THEN
      --
      -- Obtiene el total de las notas de cr�dito y notas de cr�dito internas
      IF C_GetSumTotalNotasCredito%ISOPEN THEN
        --
        CLOSE C_GetSumTotalNotasCredito;
        --
      END IF;
      --
      OPEN C_GetSumTotalNotasCredito(Lr_GetFactura.ID_DOCUMENTO,
                                     Lv_EstadoActivo,
                                     Lv_ParametroReporteCartera,
                                     Lv_DocumentosNormales,
                                     Lv_EstadosDocumentos,
                                     Lv_NotasCredito,
                                     Pv_FeConsultaHasta);
      --
      FETCH C_GetSumTotalNotasCredito INTO Lr_GetSumTotalNotaCredito;
      --
      CLOSE C_GetSumTotalNotasCredito;
      --
      --
      Ln_TotalPago := 0;
      Ln_TotalND   := 0;
      Ln_TotalNC   := 0;
      --
      --
      -- Itera los pados de la factura para restar el valor total de la factura con el valor total de la nota de credito y restarlo al total de
      -- pagos y sumarle las notas de debito
      FOR I_GetPagos IN C_GetPagos(Lr_GetFactura.ID_DOCUMENTO,
                                   Lv_EstadoActivo,
                                   Lv_ParametroReporteCartera,
                                   Lv_EstadosDocumentos,
                                   Lv_Pagos,
                                   Pv_FeConsultaHasta)
      LOOP
        --
        IF I_GetPagos.ESTADO_PAGO <> 'Asignado' THEN
          --
          Ln_TotalPago := NVL(Ln_TotalPago, 0) + NVL(I_GetPagos.VALOR_PAGO, 0);
          --
        END IF;
        --
        --
        IF I_GetPagos.ID_PAGO_DET IS NOT NULL AND I_GetPagos.ID_PAGO_DET > 0 THEN
          --
          -- Obtiene el total de las notas de d�bito(ND), notas de debito internas(NDI) y devoluciones(DEV)
          IF C_GetSumTotalNotaDebito%ISOPEN THEN
            --
            CLOSE C_GetSumTotalNotaDebito;
            --
          END IF;
          --
          OPEN C_GetSumTotalNotaDebito(I_GetPagos.ID_PAGO_DET,
                                       Lv_EstadoActivo,
                                       Lv_ParametroReporteCartera,
                                       Lv_DocumentosNormales,
                                       Lv_EstadosDocumentos,
                                       Lv_NotasDebito,
                                       Pv_FeConsultaHasta);
          --
          FETCH C_GetSumTotalNotaDebito INTO Lr_GetSumTotalNotaDebito;
          --
          CLOSE C_GetSumTotalNotaDebito;
          --
          --
          Ln_TotalND := NVL(Ln_TotalND, 0) + NVL(Lr_GetSumTotalNotaDebito.VALOR_TOTAL, 0);
          --
          --
          --Obtener el listado de ND, NDI y DEV, para verificar los pagos de las mismas
          IF C_GetListadoNotaDebito%ISOPEN THEN
            --
            CLOSE C_GetListadoNotaDebito;
            --
          END IF;
          --
          OPEN C_GetListadoNotaDebito(I_GetPagos.ID_PAGO_DET,
                                      Lv_EstadoActivo,
                                      Lv_ParametroReporteCartera,
                                      Lv_DocumentosNormales,
                                      Lv_EstadosDocumentos,
                                      Lv_NotasDebito,
                                      Pv_FeConsultaHasta);
          --
          LOOP
            --
            FETCH C_GetListadoNotaDebito INTO Lr_NotaDebito;
            --
            EXIT
            --
          WHEN C_GetListadoNotaDebito%NOTFOUND;
            --
            IF Lr_NotaDebito.ID_DOCUMENTO IS NOT NULL AND Lr_NotaDebito.ID_DOCUMENTO > 0 THEN
              --
              DB_FINANCIERO.FNCK_CONSULTS.P_DETALLE_NOTAS_DEBITO(Lr_NotaDebito.ID_DOCUMENTO,
                                                                 Pv_FeConsultaHasta,
                                                                 Ln_TotalPago,
                                                                 Ln_TotalND,
                                                                 Ln_TotalNC);
              --
            END IF;
            --
          END LOOP;-- C_GetListadoNotaDebito
          --
          CLOSE C_GetListadoNotaDebito;
          --
        END IF;-- I_GetPagos.ID_PAGO_DET IS NOT NULL AND I_GetPagos.ID_PAGO_DET > 0
        --
      END LOOP;-- FOR I_GetPagos
      --
      --
      IF Pv_TipoConsulta = 'saldo' THEN
        --
        Pn_Saldo := ROUND(NVL(Lr_GetFactura.VALOR_TOTAL,0), 2)- ROUND(NVL(Lr_GetSumTotalNotaCredito.VALOR_TOTAL,0), 2)- ROUND(NVL(Ln_TotalPago,0), 2) 
                    + ROUND(NVL(Ln_TotalND,0), 2) - ROUND(NVL(Ln_TotalNC,0), 2);
        --
      ELSIF Pv_TipoConsulta = 'PAG' THEN
        --
        Pn_Saldo := ROUND(NVL(Ln_TotalPago,0), 2);
        --
      ELSIF Pv_TipoConsulta = 'NC' THEN
        --
        Pn_Saldo := ROUND(NVL(Lr_GetSumTotalNotaCredito.VALOR_TOTAL,0), 2);
        --
      ELSIF Pv_TipoConsulta = 'NDI' THEN
        --
        Pn_Saldo := ROUND(NVL(Ln_TotalND,0), 2);
        --
      ELSIF Pv_TipoConsulta = 'NC_NDI' THEN
        --
        Pn_Saldo := ROUND(NVL(Ln_TotalNC,0), 2);
        --
      ELSIF Pv_TipoConsulta = 'TOTAL_NC' THEN
        --
        Pn_Saldo := ROUND(NVL(Lr_GetSumTotalNotaCredito.VALOR_TOTAL,0), 2) + ROUND(NVL(Ln_TotalNC,0), 2);
        --
      ELSE
        --
        Pn_Saldo := ROUND(NVL(Lr_GetFactura.VALOR_TOTAL,0), 2) - ROUND(NVL(Lr_GetSumTotalNotaCredito.VALOR_TOTAL,0), 2) 
                    - ROUND(NVL(Ln_TotalPago,0), 2) + ROUND(NVL(Ln_TotalND,0), 2)- ROUND(NVL(Ln_TotalNC,0), 2);
        --
      END IF;
      --
    END IF;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Pn_Saldo        := 0;
    Pv_MessageError := 'Error en FNCK_CONSULTS.P_SALDO_X_FACTURA - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_SALDO_X_FACTURA_FECHA',
                                          Pv_MessageError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_SALDO_X_FACTURA_FECHA;
  --
  --
  FUNCTION F_GET_SECUENCIAL_DOCUMENTO(
      Fn_IdDocumento      IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_NumeroFacturaSri IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
      Fv_TipoSecuencial   IN VARCHAR2 )
    RETURN VARCHAR2
  AS
    --
    --CURSOR QUE OBTIENE EL NUMERO DE SRI CUANDO SE LE ENVIA EL ID DEL DOCUMENTO
    --COSTO QUERY: 3
    CURSOR C_GetNumeroFacturaSri(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      --
      SELECT
        NUMERO_FACTURA_SRI
      FROM
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
      WHERE
        ID_DOCUMENTO = Cn_IdDocumento;
      --
    --
    Lv_Secuencial       VARCHAR2(15) := NULL;
    Lv_NumeroFacturaSri DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
    --
  BEGIN
    --
    IF TRIM(Fv_NumeroFacturaSri) IS NOT NULL THEN
      --
      Lv_NumeroFacturaSri := Fv_NumeroFacturaSri;
      --
    ELSIF Fn_IdDocumento IS NOT NULL AND Fn_IdDocumento > 0 THEN
      --
      IF C_GetNumeroFacturaSri%ISOPEN THEN
        CLOSE C_GetNumeroFacturaSri;
      END IF;
      --
      --
      OPEN C_GetNumeroFacturaSri(Fn_IdDocumento);
      --
      FETCH C_GetNumeroFacturaSri INTO Lv_NumeroFacturaSri;
      --
      CLOSE C_GetNumeroFacturaSri;
      --
    END IF;
    --
    --
    IF TRIM(Lv_NumeroFacturaSri) IS NOT NULL THEN
      --
      IF TRIM(Fv_TipoSecuencial) IS NOT NULL AND TRIM(Fv_TipoSecuencial) = 'ESTABLECIMIENTO' THEN
        --
        Lv_Secuencial := SUBSTR(Lv_NumeroFacturaSri, 0, ( INSTR(Lv_NumeroFacturaSri, '-', 1, 1) - 1 ) );
        --
      ELSIF TRIM(Fv_TipoSecuencial) IS NOT NULL AND TRIM(Fv_TipoSecuencial) = 'PUNTO_EMISION' THEN
        --
        Lv_Secuencial := SUBSTR(Lv_NumeroFacturaSri, ( INSTR(Lv_NumeroFacturaSri, '-', 1, 1) + 1 ), ( INSTR(Lv_NumeroFacturaSri, '-', 1, 2)
                         - INSTR( Lv_NumeroFacturaSri, '-', 1, 1) - 1));
        --
      ELSIF TRIM(Fv_TipoSecuencial) IS NOT NULL AND TRIM(Fv_TipoSecuencial) = 'SECUENCIAL' THEN
        --
        Lv_Secuencial := SUBSTR(Lv_NumeroFacturaSri, ( INSTR(Lv_NumeroFacturaSri, '-', 1, 2) + 1 ), LENGTH(Lv_NumeroFacturaSri));
        --
      END IF;
      --
    END IF;
    --
    RETURN Lv_Secuencial;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_Secuencial := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_SECUENCIAL_DOCUMENTO',
                                          'Error al obtener el secuencial del documento' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lv_Secuencial;
    --
  END F_GET_SECUENCIAL_DOCUMENTO;
  --
  --
  PROCEDURE P_GET_FORMA_PAGO_CLIENTE(
      Pn_IdPersonaRol         IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Pn_IdPunto              IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Pn_IdFormaPago          OUT DB_FINANCIERO.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
      Pv_CodigoFormaPago      OUT DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
      Pv_DescripcionFormaPago OUT DB_FINANCIERO.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
      Pv_CodigoSri            OUT DB_FINANCIERO.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE,
      Pv_TipoFormaPago        OUT DB_FINANCIERO.ADMI_FORMA_PAGO.TIPO_FORMA_PAGO%TYPE,
      Pv_FormaPagoObtenidaPor OUT VARCHAR2 )
  AS
    --
    CURSOR C_GetFormaPagoPunto(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                               Cv_EstadoActivo DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE,
                               Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      --
      SELECT AFP.ID_FORMA_PAGO,
        AFP.CODIGO_FORMA_PAGO,
        AFP.DESCRIPCION_FORMA_PAGO,
        AFP.CODIGO_SRI,
        AFP.TIPO_FORMA_PAGO
      FROM DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC
      JOIN DB_FINANCIERO.ADMI_FORMA_PAGO AFP
      ON AFP.CODIGO_FORMA_PAGO      = TO_CHAR(IPC.VALOR)
      WHERE ID_PUNTO_CARACTERISTICA =
        (SELECT MAX(IPC_S.ID_PUNTO_CARACTERISTICA)
        FROM DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC_S
        JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
        ON IPC_S.CARACTERISTICA_ID        = AC.ID_CARACTERISTICA
        WHERE AC.ESTADO                   = Cv_EstadoActivo
        AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
        AND IPC_S.ESTADO                  = Cv_EstadoActivo
        AND IPC_S.PUNTO_ID                = Cn_IdPunto
        );
    --
    CURSOR C_GetFormaPagoContrato(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                  Cv_EstadoActivo DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE)
    IS
      --
      SELECT AFP.ID_FORMA_PAGO,
        AFP.CODIGO_FORMA_PAGO,
        AFP.DESCRIPCION_FORMA_PAGO,
        AFP.CODIGO_SRI,
        AFP.TIPO_FORMA_PAGO
      FROM DB_COMERCIAL.INFO_CONTRATO IC,
        DB_GENERAL.ADMI_FORMA_PAGO AFP
      WHERE IC.FORMA_PAGO_ID        = AFP.ID_FORMA_PAGO
      AND AFP.ESTADO                = Cv_EstadoActivo
      AND IC.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
      AND IC.ID_CONTRATO            =
        (SELECT MAX(ID_CONTRATO)
        FROM DB_COMERCIAL.INFO_CONTRATO
        WHERE PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
        );
    --
    CURSOR C_GetFormaPagoPersonaRol(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                    Cv_EstadoActivo DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE)
    IS
      --
      SELECT AFP.ID_FORMA_PAGO,
        AFP.CODIGO_FORMA_PAGO,
        AFP.DESCRIPCION_FORMA_PAGO,
        AFP.CODIGO_SRI,
        AFP.TIPO_FORMA_PAGO
      FROM DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO IPFP,
        DB_GENERAL.ADMI_FORMA_PAGO AFP
      WHERE IPFP.FORMA_PAGO_ID        = AFP.ID_FORMA_PAGO
      AND AFP.ESTADO                  = Cv_EstadoActivo
      AND IPFP.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
      AND IPFP.ID_DATOS_PAGO          =
        (SELECT MAX(ID_DATOS_PAGO)
        FROM DB_COMERCIAL.INFO_PERSONA_EMP_FORMA_PAGO
        WHERE PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
        );
    --
    Lv_EstadoActivo DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE                                  := 'Activo';
    Lv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'FORMA_PAGO';
    Lr_AdmiFormaPago C_GetFormaPagoPersonaRol%ROWTYPE                                             := NULL;
    --
  BEGIN
    --
    IF Pn_IdPunto IS NOT NULL AND Pn_IdPunto > 0 THEN
      --
      Pv_FormaPagoObtenidaPor := 'PUNTO';
      --
      --
      IF C_GetFormaPagoPunto%ISOPEN THEN
        --
        CLOSE C_GetFormaPagoPunto;
        --
      END IF;
      --
      OPEN C_GetFormaPagoPunto(Pn_IdPunto, Lv_EstadoActivo, Lv_DescripcionCaracteristica);
      --
      FETCH C_GetFormaPagoPunto INTO Lr_AdmiFormaPago;
      --
      CLOSE C_GetFormaPagoPunto;
      --
    END IF;
    --
    --
    IF Lr_AdmiFormaPago.ID_FORMA_PAGO IS NULL THEN
      --
      IF Pn_IdPersonaRol IS NOT NULL AND Pn_IdPersonaRol > 0 THEN
        --
        Pv_FormaPagoObtenidaPor := 'CONTRATO';
        --
        --
        IF C_GetFormaPagoContrato%ISOPEN THEN
          --
          CLOSE C_GetFormaPagoContrato;
          --
        END IF;
        --
        OPEN C_GetFormaPagoContrato(Pn_IdPersonaRol, Lv_EstadoActivo);
        --
        FETCH C_GetFormaPagoContrato INTO Lr_AdmiFormaPago;
        --
        CLOSE C_GetFormaPagoContrato;
        --
        --
        IF Lr_AdmiFormaPago.ID_FORMA_PAGO IS NULL THEN
          --
          Pv_FormaPagoObtenidaPor := 'PERSONA';
          --
          --
          IF C_GetFormaPagoPersonaRol%ISOPEN THEN
            --
            CLOSE C_GetFormaPagoPersonaRol;
            --
          END IF;
          --
          OPEN C_GetFormaPagoPersonaRol(Pn_IdPersonaRol, Lv_EstadoActivo);
          --
          FETCH C_GetFormaPagoPersonaRol INTO Lr_AdmiFormaPago;
          --
          CLOSE C_GetFormaPagoPersonaRol;
          --
        END IF;
        --
      END IF;
      --
    END IF;
    --
    --
    IF Lr_AdmiFormaPago.ID_FORMA_PAGO IS NOT NULL THEN
      --
      Pn_IdFormaPago          := Lr_AdmiFormaPago.ID_FORMA_PAGO;
      Pv_CodigoFormaPago      := Lr_AdmiFormaPago.CODIGO_FORMA_PAGO;
      Pv_DescripcionFormaPago := Lr_AdmiFormaPago.DESCRIPCION_FORMA_PAGO;
      Pv_CodigoSri            := Lr_AdmiFormaPago.CODIGO_SRI;
      Pv_TipoFormaPago        := Lr_AdmiFormaPago.TIPO_FORMA_PAGO;
      --
    END IF;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Pn_IdFormaPago          := 0;
    Pv_CodigoFormaPago      := '';
    Pv_DescripcionFormaPago := '';
    Pv_CodigoSri            := '';
    Pv_TipoFormaPago        := '';
    Pv_FormaPagoObtenidaPor := '';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_GET_FORMA_PAGO_CLIENTE',
                                          'No se pudo obtener la forma de pago del cliente('|| Pn_IdPersonaRol ||'), punto (' ||Pn_IdPunto||') - '
                                          || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_GET_FORMA_PAGO_CLIENTE;
  --
  --
  FUNCTION F_VALIDA_CLIENTE_COMPENSADO(
      Fn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      Fn_OficinaId DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Fn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
      Fn_IdSectorPunto DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE,
      Fn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE )
    RETURN VARCHAR2
  AS
    --
    CURSOR C_GetCompensacionTN( Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                Cn_OficinaId DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                                Cv_EstadoActivo DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC.ESTADO%TYPE,
                                Cv_ValorCaracteristica DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE,
                                Cv_DescripcionCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE )
    IS
      --
      SELECT NVL(
        (SELECT IPC.VALOR
        FROM DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA IPC
        WHERE IPC.PUNTO_ID        = Cn_IdPuntoFacturacion
        AND IPC.ESTADO            = Cv_EstadoActivo
        AND IPC.CARACTERISTICA_ID =
          (SELECT AC.ID_CARACTERISTICA
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
          WHERE AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCarac
          AND AC.ESTADO                       = Cv_EstadoActivo
          )
        ), NVL(
        (SELECT IPERC.VALOR
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC
        WHERE IPERC.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol
        AND IPERC.ESTADO                   = Cv_EstadoActivo
        AND IPERC.VALOR                    = Cv_ValorCaracteristica
        AND IPERC.CARACTERISTICA_ID        =
          (SELECT AC.ID_CARACTERISTICA
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
          WHERE AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCarac
          AND AC.ESTADO                       = Cv_EstadoActivo
          )
        ),
        (SELECT
          CASE IOG.NOMBRE_OFICINA
            WHEN NULL
            THEN 'N'
            ELSE 'S'
          END
        FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
        WHERE IOG.ID_OFICINA    = Cn_OficinaId
        AND IOG.NOMBRE_OFICINA IN
          (SELECT VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_DET
          WHERE ESTADO     = Cv_EstadoActivo
          AND EMPRESA_COD  = Cn_EmpresaCod
          AND PARAMETRO_ID =
            (SELECT ID_PARAMETRO
            FROM DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE ESTADO         = Cv_EstadoActivo
            AND NOMBRE_PARAMETRO = Cv_NombreParametro
            )
          )
        ) ) )
      FROM DUAL;
      --
      CURSOR C_GetCompensacionMD( Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                                  Cv_EstadoActivo DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC.ESTADO%TYPE,
                                  Cn_IdSectorPunto DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE,
                                  Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE )
      IS
        --
        SELECT NVL(
          (SELECT
            CASE AC.NOMBRE_CANTON
              WHEN NULL
              THEN 'N'
              ELSE 'S'
            END
          FROM DB_GENERAL.ADMI_SECTOR ASEC
          JOIN DB_GENERAL.ADMI_PARROQUIA AP
          ON AP.ID_PARROQUIA = ASEC.PARROQUIA_ID
          JOIN DB_GENERAL.ADMI_CANTON AC
          ON AC.ID_CANTON       = AP.CANTON_ID
          WHERE ASEC.ID_SECTOR  = Cn_IdSectorPunto
          AND AC.NOMBRE_CANTON IN
            (SELECT VALOR1
            FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO     = Cv_EstadoActivo
            AND EMPRESA_COD  = Cn_EmpresaCod
            AND PARAMETRO_ID =
              (SELECT ID_PARAMETRO
              FROM DB_GENERAL.ADMI_PARAMETRO_CAB
              WHERE ESTADO         = Cv_EstadoActivo
              AND NOMBRE_PARAMETRO = Cv_NombreParametro
              )
            )
          ), 'N' )
        FROM DUAL;
        --
        Lv_EstadoActivo DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC.ESTADO%TYPE                        := 'Activo';
        Lv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                         := 'CANTONES_OFICINAS_COMPENSADAS';
        Lv_CaracContribucionSolidaria DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE := 'CONTRIBUCION_SOLIDARIA';
        Lv_ValorCaracteristica DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC.VALOR%TYPE                  := 'S';
        Lv_Compensacion VARCHAR2(2)                                                                    := 'N';
        --
      BEGIN
        --
        IF Fn_EmpresaCod = 10 THEN
          --
          IF C_GetCompensacionTN%ISOPEN THEN
            --
            CLOSE C_GetCompensacionTN;
            --
          END IF;
          --
          OPEN C_GetCompensacionTN( Fn_IdPersonaRol,
                                    Fn_OficinaId,
                                    Fn_EmpresaCod,
                                    Lv_EstadoActivo,
                                    Lv_ValorCaracteristica,
                                    Lv_CaracContribucionSolidaria,
                                    Lv_NombreParametro,
                                    Fn_IdPuntoFacturacion );
          --
          FETCH C_GetCompensacionTN INTO Lv_Compensacion;
          --
          CLOSE C_GetCompensacionTN;
          --
        ELSE
          --
          IF C_GetCompensacionMD%ISOPEN THEN
            --
            CLOSE C_GetCompensacionMD;
            --
          END IF;
          --
          OPEN C_GetCompensacionMD(Fn_EmpresaCod, Lv_EstadoActivo, Fn_IdSectorPunto, Lv_NombreParametro);
          --
          FETCH C_GetCompensacionMD INTO Lv_Compensacion;
          --
          CLOSE C_GetCompensacionMD;
          --
        END IF;
        --
        --
        RETURN Lv_Compensacion;
        --
      EXCEPTION
      WHEN OTHERS THEN
        --
        Lv_Compensacion := NULL;
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                              'FNCK_CONSULTS.F_VALIDA_CLIENTE_COMPENSADO',
                                              'Error al obtener si el cliente debe ser compensado' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
        RETURN Lv_Compensacion;
        --
      END F_VALIDA_CLIENTE_COMPENSADO;
  --
  --
  FUNCTION F_GET_TABLA_NAF_PLANTILLA_CAB(
      Fv_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Fn_FormaPagoId         IN DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
      Fv_CodigoTipoDocumento IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Fv_TipoProceso         IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TIPO_PROCESO%TYPE,
      Fv_Estado              IN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.ESTADO%TYPE)
    RETURN DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TABLA_CABECERA%TYPE
  AS
    --
    --CURSOR QUE RETORNE EL NOMBRE DE LA TABLA CABECERA CON LA CUAL SE MIGRA LA INFORMACION AL NAF
    --COSTO QUERY: 7
    CURSOR C_GetTablaCabeceraPlantilla(Cv_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Cn_FormaPagoId DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
                                       Cv_CodigoTipoDocumento DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                       Cv_TipoProceso DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TIPO_PROCESO%TYPE,
                                       Cv_Estado DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.ESTADO%TYPE)
    IS
      --
      SELECT
        APC.TABLA_CABECERA
      FROM
        DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB APC
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      ON
        ATDF.ID_TIPO_DOCUMENTO = APC.TIPO_DOCUMENTO_ID
      WHERE
        APC.EMPRESA_COD              = Cv_EmpresaCod
      AND APC.FORMA_PAGO_ID          = Cn_FormaPagoId
      AND ATDF.CODIGO_TIPO_DOCUMENTO = Cv_CodigoTipoDocumento
      AND APC.TIPO_PROCESO           = Cv_TipoProceso
      AND APC.ESTADO                 = Cv_Estado;
      --
    --
    Lv_TablaCabecera DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.TABLA_CABECERA%TYPE;
    --
  BEGIN
    --
    IF C_GetTablaCabeceraPlantilla%ISOPEN THEN
      --
      CLOSE C_GetTablaCabeceraPlantilla;
      --
    END IF;
    --
    OPEN C_GetTablaCabeceraPlantilla(Fv_EmpresaCod, Fn_FormaPagoId, Fv_CodigoTipoDocumento, Fv_TipoProceso, Fv_Estado);
    --
    FETCH C_GetTablaCabeceraPlantilla INTO Lv_TablaCabecera;
    --
    CLOSE C_GetTablaCabeceraPlantilla;
    --
    --
    RETURN Lv_TablaCabecera;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_TablaCabecera := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_TABLA_NAF_PLANTILLA_CAB',
                                          'Error al obtener la tabla cabecera a la cual es migrada la informacion al NAF' || ' - ' || SQLCODE ||
                                          ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lv_TablaCabecera;
    --
  END F_GET_TABLA_NAF_PLANTILLA_CAB;
  --
  --
  FUNCTION F_GET_MAX_DOCUMENTO(
      Fn_PuntoFacturacionId IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
      Fn_PuntoId            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
      Fn_ProductoId         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE,
      Fv_Filtro             IN VARCHAR2)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE
  IS
    --
    Fr_InfoDocumentoFinancieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE := NULL;
    --
    CURSOR C_MaxDocumentoByMesAnioConsumo(Cn_PuntoFacturacionId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                                          Cn_PuntoId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
                                          Cn_ProductoId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE)
    IS
      SELECT TABLA_ORD_MES_ANIO_CONSUMO.ID_DOCUMENTO
      FROM
        (SELECT IDFC.ID_DOCUMENTO
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
        ON IDFC.ID_DOCUMENTO        = IDFD.DOCUMENTO_ID
        WHERE IDFC.PUNTO_ID         = Cn_PuntoFacturacionId
        AND IDFD.PUNTO_ID           = Cn_PuntoId
        AND IDFD.PRODUCTO_ID        = Cn_ProductoId
        AND IDFC.TIPO_DOCUMENTO_ID IN
          (SELECT ATDF.ID_TIPO_DOCUMENTO
          FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
          WHERE ATDF.ESTADO               = 'Activo'
          AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC', 'FACP')
          )
      AND IDFC.ANIO_CONSUMO          IS NOT NULL
      AND IDFC.MES_CONSUMO           IS NOT NULL
      AND IDFC.ESTADO_IMPRESION_FACT IN
        (SELECT APD.DESCRIPCION
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
        WHERE APC.NOMBRE_PARAMETRO = 'ESTADOS_FACTURAS_VALIDAS'
        AND APC.ESTADO             = 'Activo'
        AND APD.ESTADO             = 'Activo'
        )
      AND NOT EXISTS (SELECT 1 
                       FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC,
                       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET NCD,
                       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDNC
                       WHERE NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                       AND NC.TIPO_DOCUMENTO_ID         = ATDNC.ID_TIPO_DOCUMENTO
                       AND NC.ID_DOCUMENTO              = NCD.DOCUMENTO_ID
                       AND ATDNC.ESTADO                 = 'Activo'
                       AND ATDNC.CODIGO_TIPO_DOCUMENTO IN ('NC', 'NCI')
                       AND NC.ESTADO_IMPRESION_FACT     = 'Activo'
                       AND NC.PUNTO_ID                 = Cn_PuntoFacturacionId
                       AND NCD.PUNTO_ID                = Cn_PuntoId
                       AND NCD.PRODUCTO_ID             = Cn_ProductoId
                      ) 
      ORDER BY TO_NUMBER(IDFC.ANIO_CONSUMO, '9999') DESC,
        TO_NUMBER(IDFC.MES_CONSUMO, '99') DESC
        ) TABLA_ORD_MES_ANIO_CONSUMO
      WHERE ROWNUM = 1;
      --
      CURSOR C_MaxDocumentoByRangoConsumo(Cn_PuntoFacturacionId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                                          Cn_PuntoId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
                                          Cn_ProductoId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE)
      IS
        SELECT TABLA_ORD_RANGO_CONSUMO.ID_DOCUMENTO
        FROM
          (SELECT IDFC.ID_DOCUMENTO
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
          JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
          ON IDFC.ID_DOCUMENTO = IDFD.DOCUMENTO_ID
          JOIN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
          ON IDC.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
          JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
          ON AC.ID_CARACTERISTICA     = IDC.CARACTERISTICA_ID
          WHERE IDFC.PUNTO_ID         = Cn_PuntoFacturacionId
          AND IDFD.PUNTO_ID           = Cn_PuntoId
          AND IDFD.PRODUCTO_ID        = Cn_ProductoId
          AND IDFC.TIPO_DOCUMENTO_ID IN
            (SELECT ATDF.ID_TIPO_DOCUMENTO
            FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
            WHERE ATDF.ESTADO               = 'Activo'
            AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC', 'FACP')
            )
        AND IDFC.RANGO_CONSUMO         IS NOT NULL
        AND IDFC.MES_CONSUMO           IS NULL
        AND IDFC.ANIO_CONSUMO          IS NULL
        AND IDFC.ESTADO_IMPRESION_FACT IN
          (SELECT APD.DESCRIPCION
          FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
          JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
          ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
          WHERE APC.NOMBRE_PARAMETRO = 'ESTADOS_FACTURAS_VALIDAS'
          AND APC.ESTADO             = 'Activo'
          AND APD.ESTADO             = 'Activo'
          )
        AND AC.DESCRIPCION_CARACTERISTICA = 'FE_RANGO_FINAL'
        AND NOT EXISTS (SELECT 1 
                       FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NC,
                       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET NCD,
                       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDNC
                       WHERE NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                       AND NC.TIPO_DOCUMENTO_ID         = ATDNC.ID_TIPO_DOCUMENTO
                       AND NC.ID_DOCUMENTO              = NCD.DOCUMENTO_ID
                       AND ATDNC.ESTADO                 = 'Activo'
                       AND ATDNC.CODIGO_TIPO_DOCUMENTO IN ('NC', 'NCI')
                       AND NC.ESTADO_IMPRESION_FACT     = 'Activo'
                       AND NC.PUNTO_ID                 = Cn_PuntoFacturacionId
                       AND NCD.PUNTO_ID                = Cn_PuntoId
                       AND NCD.PRODUCTO_ID             = Cn_ProductoId
                      ) 
        ORDER BY TO_DATE(IDC.VALOR, 'DD-MM-YYYY') DESC
          ) TABLA_ORD_RANGO_CONSUMO
        WHERE ROWNUM = 1;
    --
    CURSOR C_GetInfoDocFinancieroCab(Cn_IdDocumentoFinanacieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      --
      SELECT *
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
      WHERE ID_DOCUMENTO = Cn_IdDocumentoFinanacieroCab;
    --
    Ln_IdDocumentoFinanciero DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE := 0;
    --
  BEGIN
    --
    CASE
      --
    WHEN Fv_Filtro = 'mesAnioConsumo' THEN
      --
      IF C_MaxDocumentoByMesAnioConsumo%ISOPEN THEN
        CLOSE C_MaxDocumentoByMesAnioConsumo;
      END IF;
      --
      OPEN C_MaxDocumentoByMesAnioConsumo(Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId);
      --
      FETCH C_MaxDocumentoByMesAnioConsumo INTO Ln_IdDocumentoFinanciero;
      --
      IF C_MaxDocumentoByMesAnioConsumo%ISOPEN THEN
        CLOSE C_MaxDocumentoByMesAnioConsumo;
      END IF;
      --
    WHEN Fv_Filtro = 'rangoConsumo' THEN
      --
      IF C_MaxDocumentoByRangoConsumo%ISOPEN THEN
        CLOSE C_MaxDocumentoByRangoConsumo;
      END IF;
      --
      OPEN C_MaxDocumentoByRangoConsumo(Fn_PuntoFacturacionId, Fn_PuntoId, Fn_ProductoId);
      --
      FETCH C_MaxDocumentoByRangoConsumo INTO Ln_IdDocumentoFinanciero;
      --
      IF C_MaxDocumentoByRangoConsumo%ISOPEN THEN
        CLOSE C_MaxDocumentoByRangoConsumo;
      END IF;
      --
    END CASE;
    --
    IF Ln_IdDocumentoFinanciero IS NOT NULL AND Ln_IdDocumentoFinanciero > 0 THEN
      --
      IF C_GetInfoDocFinancieroCab%ISOPEN THEN
        CLOSE C_GetInfoDocFinancieroCab;
      END IF;
      --
      OPEN C_GetInfoDocFinancieroCab(Ln_IdDocumentoFinanciero);
      --
      FETCH C_GetInfoDocFinancieroCab INTO Fr_InfoDocumentoFinancieroCab;
      --
      IF C_GetInfoDocFinancieroCab%ISOPEN THEN
        CLOSE C_GetInfoDocFinancieroCab;
      END IF;
      --
    END IF;
    --
    RETURN Fr_InfoDocumentoFinancieroCab;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.F_GET_MAX_DOCUMENTO',
                                          'No se encontr� documento financiero. Parametros (Punto Facturacion: '||Fn_PuntoFacturacionId||', Punto: '
                                          ||Fn_PuntoId||', Producto: '||Fn_ProductoId||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    Fr_InfoDocumentoFinancieroCab := NULL;
    --
    RETURN Fr_InfoDocumentoFinancieroCab;
    --
  END F_GET_MAX_DOCUMENTO;
--
--
PROCEDURE FINP_PAGOPORANULAR(
    Pn_IdPago    IN  INFO_PAGO_CAB.ID_PAGO%TYPE,
    Pn_Resultado OUT INT,
    Pv_MsnError  OUT VARCHAR2)
IS
  --
  CURSOR C_GetInfoPagosCabDet(Cn_IdPago                INFO_PAGO_CAB.ID_PAGO%TYPE,
                              Ct_FechaDesde            TIMESTAMP,
                              Ct_FechaHasta            TIMESTAMP )
  IS
    SELECT PC.ID_PAGO,
      PD.ID_PAGO_DET,
      PD.REFERENCIA_ID,
      PC.TIPO_DOCUMENTO_ID
    FROM INFO_PAGO_DET PD,
      INFO_PAGO_CAB PC
    WHERE PD.PAGO_ID          = PC.ID_PAGO
    AND PC.TIPO_DOCUMENTO_ID IN (2, 3, 4, 10, 11)
    --valida que permita buscar los anticipos 3,4,10 solo en estado pendiente, y los pagos 2, 11 entre estado pendiente y cerrado.
    AND PC.ESTADO_PAGO       IN ('Pendiente', DECODE(PC.TIPO_DOCUMENTO_ID, 2,'Cerrado', 11, 'Cerrado', 'Pendiente'))
    --valida que el pago no sea un deposito
    AND NOT EXISTS
      (SELECT NULL
      FROM INFO_PAGO_DET D
      WHERE D.PAGO_ID  = PC.ID_PAGO
      AND D.DEPOSITADO = 'S'
      )
    -- verifica que el pago no este relacionado a una nota de debito
  AND NOT EXISTS
    (SELECT NULL
    FROM INFO_DOCUMENTO_FINANCIERO_DET IFD,
      INFO_DOCUMENTO_FINANCIERO_CAB IFC
    WHERE IFD.DOCUMENTO_ID             = IFC.ID_DOCUMENTO
    AND IFC.ESTADO_IMPRESION_FACT NOT IN ('Rechazado', 'Anulado')
    AND IFD.PAGO_DET_ID                = PD.ID_PAGO_DET
    )
  AND PC.FE_CREACION                 >= Ct_FechaDesde
  AND PC.FE_CREACION                 <= Ct_FechaHasta
  AND PC.ID_PAGO                      = Cn_IdPago;
  --
  --CURSOR QUE RETORNA LA INFORMACION DEL PAGO QUE SE PUEDE ANULAR PARA TN SI SE ENCUENTRA DENTRO DEL RANGO DE DIAS PERMITIDOS
  --COSTO DEL QUERY: 15
  CURSOR C_GetInfoPagosCabDetTn(Cn_IdPago INFO_PAGO_CAB.ID_PAGO%TYPE, Cn_NumeroDeDiasAnularPago NUMBER)
  IS
    --
    SELECT PC.ID_PAGO,
      PD.ID_PAGO_DET,
      PD.REFERENCIA_ID,
      PC.TIPO_DOCUMENTO_ID,
      CONCAT(to_char(PC.fe_creacion,'DD/MM/YYYY'),' 23:59:59') fe_creacion
    FROM INFO_PAGO_DET PD,
      INFO_PAGO_CAB PC
    WHERE PD.PAGO_ID          = PC.ID_PAGO
    AND PC.TIPO_DOCUMENTO_ID IN (2, 3, 4)
    --valida que permita buscar los anticipos 3,4 solo en estado pendiente, y los pagos 2 entre estado pendiente y cerrado.
    AND PC.ESTADO_PAGO       IN ('Pendiente', DECODE(PC.TIPO_DOCUMENTO_ID, 2,'Cerrado', 'Pendiente'))
    --valida que el pago no sea un deposito
    AND NOT EXISTS
      (SELECT NULL
      FROM INFO_PAGO_DET D
      WHERE D.PAGO_ID  = PC.ID_PAGO
      AND D.DEPOSITADO = 'S'
      )
    -- verifica que el pago no este relacionado a una nota de debito
  AND NOT EXISTS
    (SELECT NULL
    FROM INFO_DOCUMENTO_FINANCIERO_DET IFD,
      INFO_DOCUMENTO_FINANCIERO_CAB IFC
    WHERE IFD.DOCUMENTO_ID             = IFC.ID_DOCUMENTO
    AND IFC.ESTADO_IMPRESION_FACT NOT IN ('Rechazado', 'Anulado')
    AND IFD.PAGO_DET_ID                = PD.ID_PAGO_DET
    )
  AND CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE) <= CAST(PC.FE_CREACION AS TIMESTAMP WITH LOCAL TIME ZONE) + NVL(Cn_NumeroDeDiasAnularPago, 0)
  AND PC.ID_PAGO                        = Cn_IdPago;
  --
  CURSOR GetFechaDesde(Cn_NumeroDeDias NUMBER)
  IS
    SELECT CAST(TRUNC(SYSDATE) - ( Cn_NumeroDeDias )   AS TIMESTAMP WITH TIME ZONE)
      FROM DUAL;
  --
   CURSOR GetFechaHasta
  IS
    SELECT CAST(SYSDATE AS  TIMESTAMP WITH TIME ZONE)
      FROM DUAL;
  --
  -- CONTABILIZACION MD - RETORNA LA INFORMACION DEL PAGO QUE SE PUEDE ANULAR, ESTE PAGO DEBE SER ANULADO EL MISMO DIA QUE FUE CREADO
  --
  CURSOR C_GetPagosMD(Cn_IdPago                INFO_PAGO_CAB.ID_PAGO%TYPE)
  IS
    SELECT PC.ID_PAGO,
      PD.ID_PAGO_DET,
      PD.REFERENCIA_ID,
      PC.TIPO_DOCUMENTO_ID
    FROM INFO_PAGO_DET PD,
      INFO_PAGO_CAB PC
    WHERE PD.PAGO_ID          = PC.ID_PAGO
    AND PC.TIPO_DOCUMENTO_ID IN (2, 3, 4, 10, 11)
    --valida que permita buscar los anticipos 3,4,10 solo en estado pendiente, y los pagos 2, 11 entre estado pendiente y cerrado.
    AND PC.ESTADO_PAGO       IN ('Pendiente', DECODE(PC.TIPO_DOCUMENTO_ID, 2,'Cerrado', 11, 'Cerrado', 'Pendiente'))
    --valida que el pago no sea un deposito
    AND NOT EXISTS
      (SELECT NULL
      FROM INFO_PAGO_DET D
      WHERE D.PAGO_ID  = PC.ID_PAGO
      AND D.DEPOSITADO = 'S'
      )
    -- verifica que el pago no este relacionado a una nota de debito
  AND NOT EXISTS
    (SELECT NULL
    FROM INFO_DOCUMENTO_FINANCIERO_DET IFD,
      INFO_DOCUMENTO_FINANCIERO_CAB IFC
    WHERE IFD.DOCUMENTO_ID             = IFC.ID_DOCUMENTO
    AND IFC.ESTADO_IMPRESION_FACT NOT IN ('Rechazado', 'Anulado')
    AND IFD.PAGO_DET_ID                = PD.ID_PAGO_DET
    )
    -- verifico que la fecha del pago creado sea mayor al truncado del sysdate.
    -- el pago debe ser anulado el mismo dia que fue creado.
  AND PC.FE_CREACION                   > CAST( TRUNC( SYSDATE ) AS TIMESTAMP WITH LOCAL TIME ZONE)
  AND PC.ID_PAGO                       = Cn_IdPago;
  --
  -- CONTABILIZACION TN - RETORNA LA INFORMACION DEL PAGO QUE SE PUEDE ANULAR, ESTE PAGO DEBE SER ANULADO EL MISMO DIA QUE FUE CREADO
  --
  CURSOR C_GetPagosTN( Cn_IdPago INFO_PAGO_CAB.ID_PAGO%TYPE )
  IS
    --
    SELECT PC.ID_PAGO,
      PD.ID_PAGO_DET,
      PD.REFERENCIA_ID,
      PC.TIPO_DOCUMENTO_ID,
      CONCAT(to_char(PC.fe_creacion,'DD/MM/YYYY'),' 23:59:59') fe_creacion
    FROM INFO_PAGO_DET PD,
      INFO_PAGO_CAB PC
    WHERE PD.PAGO_ID          = PC.ID_PAGO
    AND PC.TIPO_DOCUMENTO_ID IN (2, 3, 4)
    --valida que permita buscar los anticipos 3,4 solo en estado pendiente, y los pagos 2 entre estado pendiente y cerrado.
    AND PC.ESTADO_PAGO       IN ('Pendiente', DECODE(PC.TIPO_DOCUMENTO_ID, 2,'Cerrado', 'Pendiente'))
    --valida que el pago no sea un deposito
    AND NOT EXISTS
      (SELECT NULL
      FROM INFO_PAGO_DET D
      WHERE D.PAGO_ID  = PC.ID_PAGO
      AND D.DEPOSITADO = 'S'
      )
    -- verifica que el pago no este relacionado a una nota de debito
  AND NOT EXISTS
    (SELECT NULL
    FROM INFO_DOCUMENTO_FINANCIERO_DET IFD,
      INFO_DOCUMENTO_FINANCIERO_CAB IFC
    WHERE IFD.DOCUMENTO_ID             = IFC.ID_DOCUMENTO
    AND IFC.ESTADO_IMPRESION_FACT NOT IN ('Rechazado', 'Anulado')
    AND IFD.PAGO_DET_ID                = PD.ID_PAGO_DET
    )
  AND PC.FE_CREACION   > CAST(TRUNC( SYSDATE ) AS TIMESTAMP WITH LOCAL TIME ZONE)
  AND PC.ID_PAGO                       = Cn_IdPago;
  --
  -- Retorna registro si la empresa contabiliza.
  CURSOR Lc_GetContabilizacionEmpresa( Cv_NomParametroCabecera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                         Cv_EstadoActivo         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                         Cv_Valor1               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                         Cv_Valor2               DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE   )
    IS
    SELECT ID_PARAMETRO_DET
    FROM DB_GENERAL.ADMI_PARAMETRO_DET
    WHERE PARAMETRO_ID =
      (SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE ESTADO         = Cv_EstadoActivo
      AND NOMBRE_PARAMETRO = Cv_NomParametroCabecera
      )
    AND ESTADO              = Cv_EstadoActivo
    AND VALOR1              = Cv_Valor1
    AND VALOR2              = Cv_Valor2;
  --
  Lc_InfoPagosDet             C_GetInfoPagosCabDet%ROWTYPE;
  Lc_InfoPagosDetTn           C_GetInfoPagosCabDetTn%ROWTYPE;
  Lc_InfoPagosTN              C_GetPagosTN%ROWTYPE;
  Lc_InfoPagosMD              C_GetPagosMD%ROWTYPE;
  --
  Lv_PrefijoEmpresa           DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  Lrf_GetAdmiParametrosDet    SYS_REFCURSOR;
  Lr_GetAdmiParametrosDet     DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_NombreParametroCabecera  VARCHAR2(50);
  Lv_EstadoActivo             VARCHAR2(50);
  Lv_Valor1                   VARCHAR2(50);
  Ln_NumeroDeDiasAnularPago   NUMBER;
  Lt_FechaDesde               TIMESTAMP (6);
  Lt_FechaHasta               TIMESTAMP (6);
  Lv_NombreParametroContab    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROCESO CONTABILIZACION EMPRESA';
  Lv_EstadoActivoContab       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE           := 'Activo';
  Lv_Valor1Contab             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           := NULL;
  Lv_Valor2Contab             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           := 'S';
  Lv_IdParametroDet           DB_GENERAL.ADMI_PARAMETRO_DET.ID_PARAMETRO_DET%TYPE := NULL;
  --
BEGIN
  --
  Lv_NombreParametroCabecera := 'NUMERO_DE_DIAS_ANULAR_PAGOS';
  Lv_EstadoActivo            := 'Activo';
  Lv_Valor1                  := 'NUMERO_DIAS_AP';
  Ln_NumeroDeDiasAnularPago  := 1;
  --


  --
  SELECT emp.PREFIJO into Lv_PrefijoEmpresa
  FROM INFO_PAGO_CAB pcab
  JOIN INFO_EMPRESA_GRUPO emp ON pcab.empresa_id=emp.cod_empresa
  WHERE id_pago=Pn_IdPago;
  --
  Pn_Resultado :=0;
  --
  Lrf_GetAdmiParametrosDet := NULL;
  Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_NombreParametroCabecera,
                                                                                    Lv_EstadoActivo,
                                                                                    Lv_EstadoActivo,
                                                                                    Lv_Valor1,
                                                                                    NULL,
                                                                                    NULL,
                                                                                    Lv_PrefijoEmpresa);
  --
  FETCH Lrf_GetAdmiParametrosDet INTO Lr_GetAdmiParametrosDet;
  --
  CLOSE Lrf_GetAdmiParametrosDet;
  --
  IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET > 0
     AND Lr_GetAdmiParametrosDet.VALOR2 IS NOT NULL THEN
    --
    Ln_NumeroDeDiasAnularPago := Lr_GetAdmiParametrosDet.VALOR2;
    --
  END IF;
  --
  --Proceso de contabilizacion empresa.
  --Asgino Prefijo empresa a parametro de busqueda por contabilizacion empresa.
    Lv_Valor1Contab := Lv_PrefijoEmpresa;
  --
  IF Lc_GetContabilizacionEmpresa%ISOPEN THEN
    CLOSE Lc_GetContabilizacionEmpresa;
  END IF;
  --
  OPEN Lc_GetContabilizacionEmpresa(Lv_NombreParametroContab,
                                    Lv_EstadoActivoContab,
                                    Lv_Valor1Contab,
                                    Lv_Valor2Contab);
  --
  FETCH Lc_GetContabilizacionEmpresa INTO Lv_IdParametroDet;
  --
  CLOSE Lc_GetContabilizacionEmpresa;

  --
  IF Lv_PrefijoEmpresa = 'MD' THEN
    --
    IF Lv_IdParametroDet IS NULL THEN
        --
        Ln_NumeroDeDiasAnularPago := NVL(Ln_NumeroDeDiasAnularPago, 5);
        --
        IF GetFechaDesde%ISOPEN THEN
          CLOSE GetFechaDesde;
        END IF;
        --
        IF GetFechaHasta%ISOPEN THEN
          CLOSE GetFechaHasta;
        END IF;
        --
        --Obtengo la fecha desde a partir del numero de dias para anular el pago.
        OPEN GetFechaDesde( Ln_NumeroDeDiasAnularPago);
        FETCH GetFechaDesde INTO Lt_FechaDesde;
        CLOSE GetFechaDesde;
        --
        OPEN  GetFechaHasta;
        FETCH GetFechaHasta INTO Lt_FechaHasta;
        CLOSE GetFechaHasta;
        --
        IF C_GetInfoPagosCabDet%ISOPEN THEN
          CLOSE C_GetInfoPagosCabDet;
        END IF;
        --
        OPEN C_GetInfoPagosCabDet(Pn_IdPago,
                                  Lt_FechaDesde,
                                  Lt_FechaHasta);
        --
        FETCH C_GetInfoPagosCabDet INTO Lc_InfoPagosDet;
        --
        IF C_GetInfoPagosCabDet%FOUND THEN
          Pn_Resultado := 1;
        END IF;
        --
    ELSE
        --
        -- MD contabiliza
        --
        IF C_GetPagosMD%ISOPEN THEN
          CLOSE C_GetPagosMD;
        END IF;
        --
        OPEN C_GetPagosMD(Pn_IdPago);
        --
        FETCH  C_GetPagosMD INTO Lc_InfoPagosMD;
        --
        IF C_GetPagosMD%FOUND THEN
          Pn_Resultado := 1;
        END IF;
        --
    END IF;
    --
  ELSE
    --
    IF Lv_IdParametroDet IS NULL THEN
    --
        IF C_GetInfoPagosCabDetTn%ISOPEN THEN
          CLOSE C_GetInfoPagosCabDetTn;
        END IF;
        --
        OPEN C_GetInfoPagosCabDetTn(Pn_IdPago, Ln_NumeroDeDiasAnularPago);
        --
        FETCH C_GetInfoPagosCabDetTn INTO Lc_InfoPagosDetTn;
        --
        IF C_GetInfoPagosCabDetTn%FOUND THEN
          Pn_Resultado := 1;
        END IF;
    --
    ELSE
    --
    -- TN contabiliza
    --
      IF C_GetPagosTN%ISOPEN THEN
        CLOSE C_GetPagosTN;
      END IF;
      --
      OPEN C_GetPagosTN(Pn_IdPago);
      --
      FETCH C_GetPagosTN INTO Lc_InfoPagosTN;
      --
      IF C_GetPagosTN%FOUND THEN
        Pn_Resultado := 1;
      END IF;
    --
    END IF;
    --
  END IF;
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_MsnError := 'Error en FNCK_CONSULTA.FINP_PAGOPORANULAR - ' || SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ANULACION DE PAGOS', 'FNCK_CONSULTS.FINP_PAGOPORANULAR', Pv_MsnError);
END FINP_PAGOPORANULAR;
--
/**
  * Documentacion para el procedimiento GET_EMPRESA_DATA
  * Retorna un XMLFOREST con el nombre, razion social y ruc de la empresa
  * @param Pn_IdEmpresa       IN Pn_IdEmpresa      INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Recibe el ID de la empresa
  * @param Pv_Estado          IN Pv_Estado         INFO_EMPRESA_GRUPO.ESTADO%TYPE recibe el es estado
  * @param Pv_DocElectronico  IN Pv_DocElectronico VARCHAR2 recibe el tipo de documento electronico, ATS(Anexo Transaccional)
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 18-08-2014
  */
FUNCTION GET_EMPRESA_DATA(
    Pn_IdEmpresa      IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Estado         IN INFO_EMPRESA_GRUPO.ESTADO%TYPE,
    Pv_DocElectronico IN VARCHAR2)
  RETURN XMLTYPE
IS
  --
  CURSOR C_Get_Empresa_Data(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                            Cv_Estado INFO_EMPRESA_GRUPO.ESTADO%TYPE,
                            Cv_DocElectronico VARCHAR2)
  IS
    SELECT DECODE(Cv_DocElectronico , 'ATS',
    XMLForest(TRIM(SUBSTR(IEG.RUC, 1, 13)) "IdInformante",
    TRIM(SUBSTR(REGEXP_REPLACE(IEG.RAZON_SOCIAL,'[^[:alnum:]]', ''), 1, 300)) "razonSocial"),
     XMLForest(SUBSTR(TRIM(REGEXP_REPLACE(IEG.RAZON_SOCIAL,'[^[:alnum:]]', '')), 1, 300) "razonSocial",
    SUBSTR(TRIM(REGEXP_REPLACE(IEG.RAZON_SOCIAL,'[^[:alnum:]]', '')), 1, 300) "nombreComercial",
    SUBSTR(IEG.RUC, 1, 13) "ruc"))
    FROM INFO_EMPRESA_GRUPO IEG
    WHERE IEG.ESTADO    = Cv_Estado
    AND IEG.COD_EMPRESA = LPAD(NVL(Cn_IdEmpresa, IEG.COD_EMPRESA), 2, 0);
  --
  LXML_Get_Empresa_Data XMLTYPE;
  --
BEGIN
  --
  --
  IF C_Get_Empresa_Data%ISOPEN THEN
    --
    CLOSE C_Get_Empresa_Data;
    --
  END IF;
  --
  OPEN C_Get_Empresa_Data(Pn_IdEmpresa, Pv_Estado, Pv_DocElectronico);
  --
  FETCH C_Get_Empresa_Data INTO LXML_Get_Empresa_Data;
  --
  CLOSE C_Get_Empresa_Data;
  --
  RETURN LXML_Get_Empresa_Data;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.GET_EMPRESA_DATA', SQLERRM);
END GET_EMPRESA_DATA;
/*Inicio de ATS*/
FUNCTION GET_VALOR_RETENCIONBYDOC( Pn_IdDocumento   IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                   Pv_TipoRetencion IN VARCHAR2) RETURN INFO_PAGO_DET.VALOR_PAGO%TYPE IS
  --
  Cl_NombreParametro CONSTANT VARCHAR2(17) := 'CODIGOS_RETENCION';
  --
  CURSOR C_GetValorRetencionByDoc(Cn_IdDocumento   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                  Cv_TipoRetencion DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE)

  IS
    SELECT SUM(IPD.VALOR_PAGO)
    FROM DB_FINANCIERO.INFO_PAGO_CAB IPC,
         DB_FINANCIERO.INFO_PAGO_DET IPD
    WHERE IPC.NUM_PAGO_MIGRACION IS NULL
    AND IPD.REFERENCIA_ID = Cn_IdDocumento
    AND IPC.ID_PAGO = IPD.PAGO_ID
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                     DB_GENERAL.ADMI_PARAMETRO_DET APD
                WHERE APC.NOMBRE_PARAMETRO = Cl_NombreParametro
                AND APD.DESCRIPCION = Cv_TipoRetencion --Cl_ParametroRetFte
                AND APC.ESTADO = FNKG_VAR.Gr_Estado.ACTIVO
                AND APD.ESTADO = FNKG_VAR.Gr_Estado.ACTIVO
                AND APD.VALOR1 = IPD.FORMA_PAGO_ID
                AND APD.PARAMETRO_ID = APC.ID_PARAMETRO);
  --
  Ln_ValorRet INFO_PAGO_DET.VALOR_PAGO%TYPE := 0;
  Lv_TipoRetencion  VARCHAR2(18) := 'RETENCION_FUENTE';
  --
BEGIN
  --
  IF Pv_TipoRetencion IS NULL THEN
    RETURN Ln_ValorRet;
  END IF;
  --
  CASE 
    WHEN Pv_TipoRetencion = 'RTF' THEN
      Lv_TipoRetencion := 'RETENCION_FUENTE';
    WHEN Pv_TipoRetencion = 'IVA' THEN
      Lv_TipoRetencion := 'RETENCION_IVA';
    ELSE
      Lv_TipoRetencion := 'RETENCION_EXTERIOR';
  END CASE;
  --
  IF C_GetValorRetencionByDoc%ISOPEN THEN
    CLOSE C_GetValorRetencionByDoc;
  END IF;
  --
  OPEN C_GetValorRetencionByDoc(Pn_IdDocumento, Lv_TipoRetencion);
  FETCH C_GetValorRetencionByDoc INTO Ln_ValorRet;
  CLOSE C_GetValorRetencionByDoc;
  --
  IF Ln_ValorRet IS NULL THEN
    Ln_ValorRet  := 0.00;
  END IF;
  --
  RETURN Ln_ValorRet;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.GET_VALOR_RETENCIONBYDOC', SQLERRM);
END GET_VALOR_RETENCIONBYDOC;
--
FUNCTION GET_NUM_ESTABLECIMIENTOS(
    Pn_IdEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaInicio IN VARCHAR2,
    Pv_FechaFin    IN VARCHAR2)
  RETURN NUMBER
  --
IS
  --
  CURSOR C_GetNumEstablecimientos(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Cv_FechaInicio IN VARCHAR2, Cv_FechaFin IN VARCHAR2)
  IS
    SELECT COUNT(TMP_TABLE.ESTAB)
    FROM
      (SELECT LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0) ESTAB
      FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        INFO_OFICINA_GRUPO IOG,
        INFO_EMPRESA_GRUPO IEG,
        INFO_PUNTO IP,
        INFO_PERSONA_EMPRESA_ROL IPER,
        INFO_PERSONA IPR,
        ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      WHERE IDFC.OFICINA_ID                                                                                            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID                                                                                               = IEG.COD_EMPRESA
      AND IEG.COD_EMPRESA                                                                                              = LPAD(NVL(Cn_IdEmpresa, IEG.COD_EMPRESA),2,0)
      AND IDFC.PUNTO_ID                                                                                                = IP.ID_PUNTO
      AND IP.PERSONA_EMPRESA_ROL_ID                                                                                    = IPER.ID_PERSONA_ROL
      AND IPER.PERSONA_ID                                                                                              = IPR.ID_PERSONA
      AND IDFC.TIPO_DOCUMENTO_ID                                                                                      IN (1, 5, 6)
      AND IDFC.TIPO_DOCUMENTO_ID                                                                                       = ATDF.ID_TIPO_DOCUMENTO
      AND IDFC.ESTADO_IMPRESION_FACT                                                                                  IN ('Activo','Activa','Courier','Cerrado','Cerrada')
      AND LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0) IS NOT NULL
      AND IDFC.FE_EMISION                                                                                        >= TO_DATE(Cv_FechaInicio
        || ' 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
      AND IDFC.FE_EMISION <= TO_DATE(Cv_FechaFin
        || ' 23:59:59', 'DD-MM-YYYY HH24:MI:SS')
      GROUP BY LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0)
      ) TMP_TABLE;
  --
  Ln_NumEstablecimiento NUMBER := 0;
  --
BEGIN
  --
  IF C_GetNumEstablecimientos%ISOPEN THEN
    CLOSE C_GetNumEstablecimientos;
  END IF;
  --
  OPEN C_GetNumEstablecimientos(Pn_IdEmpresa, Pv_FechaInicio, Pv_FechaFin);
  --
  FETCH C_GetNumEstablecimientos INTO Ln_NumEstablecimiento;
  --
  CLOSE C_GetNumEstablecimientos;
  --
  RETURN Ln_NumEstablecimiento;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.GET_NUM_ESTABLECIMIENTOS', SQLERRM);
  --
END GET_NUM_ESTABLECIMIENTOS;
--
FUNCTION GET_VENTAS_ESTABLECIMIENTOS(
    Pn_IdEmpresa      IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaInicio    IN VARCHAR2,
    Pv_FechaFin       IN VARCHAR2,
    Pv_Pais           IN DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE,
    Pv_EncerarTotales IN VARCHAR2)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetVentasEstab(Cn_IdEmpresa        INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                          Ct_FechaInicio      TIMESTAMP,
                          Ct_FechaFin         TIMESTAMP,
                          Cv_Pais             DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE,
                          Cv_EncerarTotales   VARCHAR2,
                          Cv_EstadoActivo     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                          Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
  IS
    SELECT XMLAGG(XMLELEMENT("ventaEst",
    XMLFOREST( TMP_TABLE.ESTAB "codEstab"),
    XMLFOREST( DECODE(Cv_EncerarTotales, 'SI', '0.00', 'NO', TRIM(TO_CHAR(ROUND((SUM(NVL(TMP_TABLE.FAC, 0)) - SUM(NVL(TMP_TABLE.NC, 0))) ,2) , '9999999990D00')) ) "ventasEstab",
               DECODE(Cv_EncerarTotales, 'SI', '0.00', 'NO', TRIM(TO_CHAR(ROUND((SUM(NVL(TMP_TABLE.FAC_DESCUENTO_COMPENSACION, 0)) - SUM(NVL(TMP_TABLE.NC_DESCUENTO_COMPENSACION, 0))) ,2), '9999999990D00')) )"ivaComp"
            )))
    FROM
      (SELECT LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0) ESTAB,
        DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, 18, SUM( ROUND(NVL(IDFC.SUBTOTAL, 0),  4) )               - SUM(ROUND(NVL(IDFC.SUBTOTAL_DESCUENTO, 0),  4))) FAC,
        DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, 4,  SUM( ROUND(NVL(IDFC.SUBTOTAL, 0),  4) )               - SUM(ROUND(NVL(IDFC.SUBTOTAL_DESCUENTO, 0),  4))) NC,
        DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, 18, SUM( ROUND(NVL( IDFC.DESCUENTO_COMPENSACION  , 0), 4) )  ) FAC_DESCUENTO_COMPENSACION,
        DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, 4,  SUM( ROUND(NVL( IDFC.DESCUENTO_COMPENSACION  , 0), 4) )  ) NC_DESCUENTO_COMPENSACION
      FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        INFO_OFICINA_GRUPO IOG,
        INFO_EMPRESA_GRUPO IEG,
        INFO_PUNTO IP,
        ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      WHERE IDFC.OFICINA_ID                                                                                            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID                                                                                               = IEG.COD_EMPRESA
      AND IEG.COD_EMPRESA                                                                                              = LPAD(NVL(Cn_IdEmpresa, IEG.COD_EMPRESA),2,0)
      AND IDFC.PUNTO_ID                                                                                                = IP.ID_PUNTO
      AND IDFC.TIPO_DOCUMENTO_ID                                                                                       = ATDF.ID_TIPO_DOCUMENTO
      AND ATDF.CODIGO_TIPO_DOCUMENTO                                                                                   IN ('FAC','FACP', 'NC')
      AND IDFC.ESTADO_IMPRESION_FACT                                                                                   IN (SELECT APD.VALOR1
                                                                                                                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                                                                                                 DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                                                                                            WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
                                                                                                                            AND   APD.VALOR2           =  'SI'
                                                                                                                            AND   APD.ESTADO           =  Cv_EstadoActivo
                                                                                                                            AND   APC.NOMBRE_PARAMETRO =  Cv_NombreParametro)
      AND LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0) IS NOT NULL
      AND IDFC.FE_EMISION                                                                                             >= Ct_FechaInicio
      AND IDFC.FE_EMISION                                                                                             <= Ct_FechaFin
      AND  FNCK_CONSULTS.F_SET_ATTR_PAIS(IP.PERSONA_EMPRESA_ROL_ID )                                                  = Cv_Pais
      GROUP BY LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0),
        ATDF.CODIGO_TIPO_COMP_ATS_SRI
      ) TMP_TABLE
  GROUP BY TMP_TABLE.ESTAB;
  --
  CURSOR GetFechaInicio( Cv_FechaInicio VARCHAR2 )
  IS
    SELECT CAST(TO_DATE( Cv_FechaInicio || ' 00:00:00', 'DD-MM-YYYY HH24:MI:SS') AS TIMESTAMP WITH LOCAL TIME ZONE)
      FROM dual;
  --
  CURSOR GetFechaFin( Cv_FechaFin VARCHAR2 )
  IS
    SELECT CAST(TO_DATE( Cv_FechaFin || ' 23:59:59', 'DD-MM-YYYY HH24:MI:SS') AS TIMESTAMP WITH LOCAL TIME ZONE)
      FROM dual;
  --
  Lv_EstadoActivo       DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
  Lv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'ESTADOS_DF_ATS';
  Lt_FechaInicio        TIMESTAMP (6);
  Lt_FechaFin           TIMESTAMP (6);
  Lxml_TotalVentasEstab XMLTYPE := NULL;
  --
BEGIN
  --
  --Realizo el castero de la fechaInicio a TIMESTAMP
  IF GetFechaInicio%ISOPEN THEN
    CLOSE GetFechaInicio;
  END IF;
  --
  OPEN GetFechaInicio( Pv_FechaInicio );
  --
  FETCH GetFechaInicio INTO Lt_FechaInicio;
  --
  CLOSE GetFechaInicio;
  --
  --Realizo el castero de la fechaFin a TIMESTAMP
  IF GetFechaFin%ISOPEN THEN
    CLOSE GetFechaFin;
  END IF;
  --
  OPEN GetFechaFin( Pv_FechaFin );
  --
  FETCH GetFechaFin INTO Lt_FechaFin;
  --
  CLOSE GetFechaFin;
  --
  --
  IF C_GetVentasEstab%ISOPEN THEN
    CLOSE C_GetVentasEstab;
  END IF;
  --
  OPEN C_GetVentasEstab(Pn_IdEmpresa, Lt_FechaInicio, Lt_FechaFin, Pv_Pais, Pv_EncerarTotales, Lv_EstadoActivo,
                        Lv_NombreParametro);
  --
  FETCH C_GetVentasEstab INTO Lxml_TotalVentasEstab;
  --
  CLOSE C_GetVentasEstab;
  --
  RETURN Lxml_TotalVentasEstab;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.GET_VENTAS_ESTABLECIMIENTOS', SQLERRM);
  --
END GET_VENTAS_ESTABLECIMIENTOS;
--
FUNCTION GET_TOTAL_VENTAS(
    Pn_IdEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaInicio IN VARCHAR2,
    Pv_FechaFin    IN VARCHAR2,
    Pv_Pais        IN DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE)
  RETURN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE
IS
  --
  CURSOR GetTotalVentas(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Cv_FechaInicio IN VARCHAR2, Cv_FechaFin IN VARCHAR2,
                        Cv_Pais      DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE)
  IS
    SELECT ROUND((SUM(TMP_TABLE.FC) - SUM(TMP_TABLE.NC)), 2) TOTAL
    FROM
      (SELECT DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI,4, 0, NVL(ROUND(IDFC.SUBTOTAL, 4), 0) - NVL(ROUND(IDFC.SUBTOTAL_DESCUENTO, 4), 0)) FC,
        DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI,4, NVL(ROUND(IDFC.SUBTOTAL, 4), 0)          - NVL(ROUND(IDFC.SUBTOTAL_DESCUENTO, 4), 0), 0) NC
      FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        INFO_OFICINA_GRUPO IOG,
        INFO_EMPRESA_GRUPO IEG,
        INFO_PUNTO IP,
        INFO_PERSONA_EMPRESA_ROL IPER,
        INFO_PERSONA IPR,
        ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        ADMI_TIPO_IDENTIFICACION ATI
      WHERE IDFC.OFICINA_ID           = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID              = IEG.COD_EMPRESA
      AND IEG.COD_EMPRESA             = LPAD(NVL(Cn_IdEmpresa, IEG.COD_EMPRESA),2,0)
      AND IDFC.PUNTO_ID               = IP.ID_PUNTO
      AND IP.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
      AND IPER.PERSONA_ID             = IPR.ID_PERSONA
      AND IDFC.TIPO_DOCUMENTO_ID     IN (1, 5, 6)
      AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
      AND ATI.ID_TIPO_IDENTIFICACION  = IPR.TIPO_IDENTIFICACION
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier','Cerrado','Cerrada')
      AND IDFC.FE_EMISION             >= TO_DATE(Cv_FechaInicio
        || ' 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
      AND IDFC.FE_EMISION             <= TO_DATE(Cv_FechaFin
        || ' 23:59:59', 'DD-MM-YYYY HH24:MI:SS')
      AND  FNCK_CONSULTS.F_SET_ATTR_PAIS(IP.PERSONA_EMPRESA_ROL_ID ) = Cv_Pais
      ) TMP_TABLE;
  --
  Ln_TotalVentas INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
  --
BEGIN
  --
  --
  IF GetTotalVentas%ISOPEN THEN
    CLOSE GetTotalVentas;
  END IF;
  --
  OPEN GetTotalVentas(Pn_IdEmpresa, Pv_FechaInicio, Pv_FechaFin, Pv_Pais);
  --
  FETCH GetTotalVentas INTO Ln_TotalVentas;
  --
  CLOSE GetTotalVentas;
  --
  RETURN Ln_TotalVentas;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.GET_TOTAL_VENTAS', SQLERRM);
  --
END GET_TOTAL_VENTAS;
--
FUNCTION GET_NUM_AUTORIZACION(
    Pn_IdEmpresa           IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pn_CodigoTipoDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_Secuencia           IN VARCHAR2
    )
  RETURN ADMI_NUMERACION_HISTO.NUMERO_AUTORIZACION%TYPE
IS
  --
  CURSOR C_GetNumAutorizacionMD(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Cn_CodigoTipoDocumento ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                Cv_Secuencia VARCHAR2 )
  IS
    SELECT ANH.NUMERO_AUTORIZACION
    FROM INFO_OFICINA_GRUPO IOG,
      ADMI_NUMERACION AN,
      ADMI_NUMERACION_HISTO ANH
    WHERE IOG.EMPRESA_ID           = LPAD(NVL(Cn_IdEmpresa, IOG.EMPRESA_ID), 2, 0)
    AND IOG.ES_MATRIZ              = 'S'
    AND IOG.ES_OFICINA_FACTURACION = 'S'
    AND IOG.ESTADO                 = 'Activo'
    AND IOG.ID_OFICINA             = AN.OFICINA_ID
    AND AN.ID_NUMERACION           = ANH.NUMERACION_ID
    AND AN.CODIGO                  = Cn_CodigoTipoDocumento
    AND Cv_Secuencia              >= ANH.SECUENCIA_INICIO
    AND Cv_Secuencia              <= ANH.SECUENCIA_FIN;
  --
    CURSOR C_GetNumAutorizacionTN(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Cn_CodigoTipoDocumento ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                  Cv_Secuencia VARCHAR2 )
  IS
    SELECT ANH.NUMERO_AUTORIZACION
    FROM INFO_OFICINA_GRUPO IOG,
      ADMI_NUMERACION AN,
      ADMI_NUMERACION_HISTO ANH
    WHERE IOG.EMPRESA_ID           = LPAD(NVL(Cn_IdEmpresa, IOG.EMPRESA_ID), 2, 0)
    AND IOG.ES_OFICINA_FACTURACION = 'S'
    AND IOG.ESTADO                 = 'Activo'
    AND IOG.ID_OFICINA             = AN.OFICINA_ID
    AND AN.ID_NUMERACION           = ANH.NUMERACION_ID
    AND AN.CODIGO                  = Cn_CodigoTipoDocumento
    AND Cv_Secuencia              >= ANH.SECUENCIA_INICIO
    AND Cv_Secuencia              <= ANH.SECUENCIA_FIN;
  --
  Ln_NumAutorizacion NUMBER := 0;
  --
BEGIN
  --
  IF Pn_IdEmpresa IS NOT NULL THEN
      --
      IF Pn_IdEmpresa     = 18 THEN
          --
          IF C_GetNumAutorizacionMD%ISOPEN THEN
            CLOSE C_GetNumAutorizacionMD;
          END IF;
          --
          OPEN C_GetNumAutorizacionMD(Pn_IdEmpresa, Pn_CodigoTipoDocumento, Pv_Secuencia);
          --
          FETCH C_GetNumAutorizacionMD INTO Ln_NumAutorizacion;
          --
          CLOSE C_GetNumAutorizacionMD;
          --
      ELSIF Pn_IdEmpresa  = 10 THEN
          --
          IF C_GetNumAutorizacionTN%ISOPEN THEN
            CLOSE C_GetNumAutorizacionTN;
          END IF;
          --
          OPEN C_GetNumAutorizacionTN(Pn_IdEmpresa, Pn_CodigoTipoDocumento, Pv_Secuencia);
          --
          FETCH C_GetNumAutorizacionTN INTO Ln_NumAutorizacion;
          --
          CLOSE C_GetNumAutorizacionTN;
          --
      END IF;
      --
  END IF;
  --
  RETURN Ln_NumAutorizacion;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.GET_NUM_AUTORIZACION', SQLERRM);
  --
END GET_NUM_AUTORIZACION;
--
FUNCTION GET_DOC_ANULADOS(
    Pn_IdEmpresa   IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaInicio IN VARCHAR2,
    Pv_FechaFin    IN VARCHAR2)
  RETURN XMLTYPE
IS
  --
  CURSOR C_GetDocsAnulados(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Cv_FechaInicio VARCHAR2, Cv_FechaFin VARCHAR2)
  IS
    SELECT XMLAGG(XMLELEMENT("detalleAnulados",
    XMLFOREST(LPAD(DECODE(ATDF.CODIGO_TIPO_COMP_ATS_SRI, 18, 1, 4), 2, 0) "tipoComprobante") ,
    XMLFOREST(LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0) "establecimiento"),
    XMLFOREST(LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) +1, (INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 2) - INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1)) - 1), 1, 3), 3, 0) "puntoEmision"),
    XMLFOREST(LPAD(SUBSTR(IDFC.NUMERO_FACTURA_SRI, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 2) + 1, 9), 9, 0) "secuencialInicio"),
    XMLFOREST(LPAD(SUBSTR(IDFC.NUMERO_FACTURA_SRI, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 2) + 1, 9), 9, 0) "secuencialFin"),
    XMLFOREST( TRIM( TO_CHAR( NVL(IDFC.NUMERO_AUTORIZACION, '000') )) "autorizacion" )) )
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_OFICINA_GRUPO IOG,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE IDFC.OFICINA_ID           = IOG.ID_OFICINA
    AND IOG.EMPRESA_ID              = LPAD(NVL(Cn_IdEmpresa, IOG.EMPRESA_ID), 2, 0)
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND IDFC.TIPO_DOCUMENTO_ID     IN (1, 5, 6)
    AND IDFC.ESTADO_IMPRESION_FACT IN ('Anulado','Anulada')
    AND IDFC.NUM_FACT_MIGRACION    IS NULL
    AND IDFC.NUMERO_FACTURA_SRI IS NOT NULL
    AND LPAD(SUBSTR(SUBSTR(IDFC.NUMERO_FACTURA_SRI, 1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-', 1, 1) - 1), 1, 3), 3, 0)  IS NOT NULL --ESTAB NO NULO
    AND IDFC.FE_EMISION            >= TO_DATE(Cv_FechaInicio
      || ' 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
    AND IDFC.FE_EMISION            <= TO_DATE(Cv_FechaFin
      || ' 23:59:59', 'DD-MM-YYYY HH24:MI:SS');
  --
  Lxml_DocsAnulados XMLTYPE := NULL;
  --
BEGIN
  --
  IF C_GetDocsAnulados%ISOPEN THEN
    CLOSE C_GetDocsAnulados;
  END IF;
  --
  OPEN C_GetDocsAnulados(Pn_IdEmpresa, Pv_FechaInicio, Pv_FechaFin);
  --
  FETCH C_GetDocsAnulados INTO Lxml_DocsAnulados;
  --
  CLOSE C_GetDocsAnulados;
  --
  RETURN Lxml_DocsAnulados;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.GET_DOC_ANULADOS', SQLERRM);
  --
END GET_DOC_ANULADOS;
/**/
PROCEDURE GET_ATS(
    Pn_IdEmpresa    IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FechaInicio  IN  VARCHAR2,
    Pv_FechaFin     IN  VARCHAR2,
    Pxml_Ats        OUT CLOB,
    Pn_Tamanio      OUT NUMBER,
    Pv_PreEmpresa   OUT INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_MessageError OUT VARCHAR2)
IS
  --
    CURSOR C_GetAts(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, Cv_FechaInicio VARCHAR2, Cv_FechaFin VARCHAR2,
                  Cv_Pais DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE, Cv_EncerarTotales VARCHAR2)
  IS
  SELECT
XMLELEMENT("iva" ,
  XMLELEMENT( "TipoIDInformante" , 'R'), FNCK_CONSULTS.GET_EMPRESA_DATA(Cn_IdEmpresa, 'Activo', 'ATS'),
  XMLELEMENT( "Anio" , TO_CHAR(TO_DATE(Cv_FechaInicio,'DD-MM-YYYY'),'YYYY')),
  XMLELEMENT( "Mes"  , TO_CHAR(TO_DATE(Cv_FechaInicio,'DD-MM-YYYY'),'MM')),
  XMLELEMENT( "numEstabRuc" , LPAD(FNCK_CONSULTS.GET_NUM_ESTABLECIMIENTOS(Cn_IdEmpresa, Cv_FechaInicio, Cv_FechaFin), 3, 0)),
  XMLELEMENT( "totalVentas" , DECODE(Cv_EncerarTotales, 'SI', '0.00', 'NO', TRIM(TO_CHAR(FNCK_CONSULTS.GET_TOTAL_VENTAS(Cn_IdEmpresa, Cv_FechaInicio, Cv_FechaFin, Cv_Pais), '9999999990D00')))),
  XMLELEMENT( "codigoOperativo" , 'IVA'),
  XMLELEMENT( "compras" , ''),
  XMLELEMENT( "ventas" ,
          XMLAGG(XMLELEMENT("detalleVentas" ,
                    XMLFOREST(TMP_GROUP.CODIGO_SRI_CLI "tpIdCliente" ),
                    XMLFOREST( NVL( SUBSTR( replace( regexp_replace( TMP_GROUP.IDENTIFICACION_CLIENTE , '( *[[:punct:]])', '' ) , ' ', '' ) , 0, 13 ),'9999999999999' ) "idCliente" ),
                    XMLFOREST( FNCK_CONSULTS.F_GET_PARTE_REL_VTAS( TMP_GROUP.IDENTIFICACION_CLIENTE, Cn_IdEmpresa ) "parteRelVtas"  ),
                    DECODE( TMP_GROUP.CODIGO_SRI_CLI , '06' , XMLFOREST( NVL( TMP_GROUP.TIPO_TRIBUTARIO,'01') "tipoCliente" ), ''),
                    DECODE( TMP_GROUP.CODIGO_SRI_CLI , '06' , XMLFOREST( DECODE( regexp_replace( TMP_GROUP.RAZON_SOCIAL , '( *[[:punct:]])', '' ), null,
                    replace(  REGEXP_REPLACE( regexp_replace( TMP_GROUP.NOMBRES || TMP_GROUP.APELLIDOS, '( *[[:punct:]])', '' ) , '([�|�])', 'N') , ' ', '' ), regexp_replace( TMP_GROUP.RAZON_SOCIAL , '( *[[:punct:]])', '' ) ) "denoCli" ), ''),
                    XMLFOREST(TMP_GROUP.CODIGO_COMP_SRI "tipoComprobante" ),
                    XMLFOREST('E' "tipoEmision"),
                    XMLFOREST(TMP_GROUP.NUMEROS_FAC "numeroComprobantes" ),
                    XMLFOREST('0.00' "baseNoGraIva" ),
                    XMLFOREST( NVL( FNCK_CONSULTS.F_GET_TOTAL_IMPUESTOS(Cn_IdEmpresa ,Cv_FechaInicio , Cv_FechaFin ,'BI', TMP_GROUP.IDENTIFICACION_CLIENTE, TMP_GROUP.CODIGO_COMP_SRI ),'0.00') "baseImponible" ),
                    XMLFOREST( TRIM(TO_CHAR(
                    NVL( FNCK_CONSULTS.F_GET_TOTAL_IMPUESTOS(Cn_IdEmpresa ,Cv_FechaInicio , Cv_FechaFin ,'BIG',TMP_GROUP.IDENTIFICACION_CLIENTE, TMP_GROUP.CODIGO_COMP_SRI ),'0.00') , '9999999990D00')) "baseImpGrav" ),
                    XMLFOREST( NVL( FNCK_CONSULTS.F_GET_TOTAL_IMPUESTOS(Cn_IdEmpresa ,Cv_FechaInicio , Cv_FechaFin , 'IVA', TMP_GROUP.IDENTIFICACION_CLIENTE, TMP_GROUP.CODIGO_COMP_SRI ),'0.00') "montoIva" ),
                    XMLFOREST( NVL(FNCK_CONSULTS.F_GET_TOTAL_IMPUESTOS(Cn_IdEmpresa ,Cv_FechaInicio , Cv_FechaFin ,'ICE',TMP_GROUP.IDENTIFICACION_CLIENTE, TMP_GROUP.CODIGO_COMP_SRI ),'0.00') "montoIce" ),
                    XMLFOREST( TRIM(TO_CHAR( TMP_GROUP.RETENCION_IVA, '9999999990D00')) "valorRetIva"),
                    XMLFOREST( TRIM(TO_CHAR( TMP_GROUP.RETENCION, '9999999990D00')) "valorRetRenta"),
                    DECODE(TMP_GROUP.CODIGO_COMP_SRI, '04', '', XMLELEMENT("formasDePago", XMLFOREST(TMP_GROUP.FORMA_PAGO_CODIGO_SRI "formaPago")))
                        )
                  )
              ),
              XMLELEMENT("ventasEstablecimiento", FNCK_CONSULTS.GET_VENTAS_ESTABLECIMIENTOS(Cn_IdEmpresa, Cv_FechaInicio, Cv_FechaFin, Cv_Pais, Cv_EncerarTotales)),
              XMLELEMENT("exportaciones", FNCK_CONSULTS.F_GET_EXPORTACIONES(Cn_IdEmpresa, Cv_FechaInicio, Cv_FechaFin )),
              XMLELEMENT("anulados", FNCK_CONSULTS.GET_DOC_ANULADOS(Cn_IdEmpresa, Cv_FechaInicio, Cv_FechaFin))) ATS
FROM
  (SELECT TMP.CODIGO_SRI_CLI,
    TMP.IDENTIFICACION_CLIENTE IDENTIFICACION_CLIENTE,
    TMP.REMBOLSO AS CODIGO_COMP_SRI ,
    COUNT(TMP.NUMERO_FACTURA_SRI) NUMEROS_FAC,
    SUM(ROUND(TMP.SUBTOTAL, 4)) SUBTOTAL,
    SUM(ROUND(TMP.SUBTOTAL_DESCUENTO, 4)) DESCUENTO,
    SUM(TMP.RETENCION) RETENCION,
    SUM(TMP.RETENCION_IVA) RETENCION_IVA,
    DECODE(TMP.TIPO_TRIBUTARIO ,'NAT','01','JUR','02') TIPO_TRIBUTARIO,
    TMP.RAZON_SOCIAL RAZON_SOCIAL,
    TMP.NOMBRES,
    TMP.APELLIDOS,
    TMP.FORMA_PAGO_CODIGO_SRI
  FROM
    (SELECT TRIM(LPAD(ATI.CODIGO_SRI, 2, '0')) CODIGO_SRI_CLI,
      ATDF.CODIGO_TIPO_COMP_ATS_SRI CODIGO_SRI,
      IPR.IDENTIFICACION_CLIENTE,
      LPAD(ATDF.CODIGO_TIPO_COMP_ATS_SRI, 2, '0') CODIGO_COMP_SRI,
       CASE WHEN ( SELECT COUNT(1) FROM INFO_DOCUMENTO_FINANCIERO_DET FE
                  where FE.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
                  AND NVL( FE.PRODUCTO_ID , 0) IN (886,763) ) >= 1
           THEN '41' ELSE LPAD(ATDF.CODIGO_TIPO_COMP_ATS_SRI, 2, '0')
      END REMBOLSO,
      IDFC.NUMERO_FACTURA_SRI,
      NVL(ROUND(IDFC.SUBTOTAL, 4), 0) SUBTOTAL,
      NVL(ROUND(IDFC.SUBTOTAL_DESCUENTO, 4), 0) SUBTOTAL_DESCUENTO,
      NVL(FNCK_CONSULTS.GET_VALOR_RETENCIONBYDOC(IDFC.ID_DOCUMENTO, 'RTF'), 0) RETENCION,
      NVL(FNCK_CONSULTS.GET_VALOR_RETENCIONBYDOC(IDFC.ID_DOCUMENTO, 'IVA'), 0) RETENCION_IVA,
      IPR.TIPO_TRIBUTARIO TIPO_TRIBUTARIO,
      IPR.RAZON_SOCIAL RAZON_SOCIAL,
      IPR.NOMBRES NOMBRES,
      IPR.APELLIDOS APELLIDOS,
      FNCK_CONSULTS.F_GET_FORMA_PAGO_POR_CLIENTE( IDENTIFICACION_CLIENTE ) FORMA_PAGO_CODIGO_SRI
    FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_OFICINA_GRUPO IOG,
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR,
      ADMI_TIPO_IDENTIFICACION ATI,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
  WHERE IDFC.OFICINA_ID             = IOG.ID_OFICINA
    AND IOG.EMPRESA_ID              = LPAD(NVL(Cn_IdEmpresa, IOG.EMPRESA_ID), 2, 0)
    AND IDFC.PUNTO_ID               = IP.ID_PUNTO
    AND IP.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID             = IPR.ID_PERSONA
    AND IPR.TIPO_IDENTIFICACION     = ATI.ID_TIPO_IDENTIFICACION
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND IDFC.TIPO_DOCUMENTO_ID     IN (1, 5, 6)
    AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier','Cerrado','Cerrada')
    AND IDFC.NUM_FACT_MIGRACION    IS NULL
    AND IDFC.FE_EMISION            >=  TO_DATE(Cv_FechaInicio
      || ' 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
    AND IDFC.FE_EMISION            <=  TO_DATE(Cv_FechaFin
      || ' 23:59:59', 'DD-MM-YYYY HH24:MI:SS')
    AND  FNCK_CONSULTS.F_SET_ATTR_PAIS(IP.PERSONA_EMPRESA_ROL_ID ) = Cv_Pais
      ) TMP
  GROUP BY TMP.CODIGO_SRI_CLI,
    TMP.CODIGO_SRI,
    TMP.IDENTIFICACION_CLIENTE,
    TMP.CODIGO_COMP_SRI,
    TMP.TIPO_TRIBUTARIO,
    TMP.RAZON_SOCIAL,
    TMP.NOMBRES,
    TMP.APELLIDOS,
    TMP.FORMA_PAGO_CODIGO_SRI,
    TMP.REMBOLSO
  ) TMP_GROUP;
  --
  CURSOR C_GetPrefijoEmpresa(Cn_IdEmpresa INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT PREFIJO
    FROM INFO_EMPRESA_GRUPO
    WHERE ESTADO    = 'Activo'
    AND COD_EMPRESA = Cn_IdEmpresa;
  --
  LXML_Ats                XMLTYPE                               := NULL;
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_Pais                 DB_GENERAL.ADMI_PAIS.NOMBRE_PAIS%TYPE := '';
  Lv_EncerarTotalesAts    VARCHAR2(25)                          := '';
  Lv_EncerarTotales       VARCHAR2(25)                          := '';
  Lv_EnceraTotales        VARCHAR2(2)                           := '';
  --
BEGIN
  --
  IF C_GetAts%ISOPEN THEN
    CLOSE C_GetAts;
  END IF;
    --
    --Recupero Pais de origen del ATS
    Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('PAIS_ORIGEN_ATS', 'Activo',
                                                                       'Activo', 'PAIS_ATS',
                                                                       NULL, 'NULL', Pn_IdEmpresa);
    --
    FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
    --
    CLOSE Lrf_GetAdmiParamtrosDet;
    --
    IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
       Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
        --
        Lv_Pais := Lr_GetAdmiParamtrosDet.VALOR2;
        --
    END IF;
   ---
   Lrf_GetAdmiParamtrosDet := NULL;
   --
   IF     Pn_IdEmpresa = '10' THEN
    --
      Lv_EncerarTotalesAts := 'ENCERAR_TOTALES_ATS_TN';
      Lv_EncerarTotales    := 'ENCERAR_TOTALES_TN';
    --
   ELSIF  Pn_IdEmpresa = '18'  THEN
    --
      Lv_EncerarTotalesAts := 'ENCERAR_TOTALES_ATS_MD';
      Lv_EncerarTotales    := 'ENCERAR_TOTALES_MD';
    --
   END IF;
   --Recupero si se necesita encerar totales en el detalle de Ventas.
   Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(  Lv_EncerarTotalesAts, 'Activo',
                                                                       'Activo', Lv_EncerarTotales,
                                                                       NULL, 'NULL', 'NULL');
    --
    FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
    --
    CLOSE Lrf_GetAdmiParamtrosDet;
    --
    IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
       Lr_GetAdmiParamtrosDet.VALOR2           IS NOT NULL THEN
        --
        Lv_EncerarTotales := Lr_GetAdmiParamtrosDet.VALOR2;
        --
    END IF;
   --
  OPEN C_GetAts(Pn_IdEmpresa, Pv_FechaInicio, Pv_FechaFin, Lv_Pais, Lv_EncerarTotales);
  --
  FETCH C_GetAts INTO LXML_Ats;
  --
  CLOSE C_GetAts;
  --
  IF C_GetPrefijoEmpresa%ISOPEN THEN
    CLOSE C_GetPrefijoEmpresa;
  END IF;
  --
  OPEN C_GetPrefijoEmpresa(Pn_IdEmpresa);
  --
  FETCH C_GetPrefijoEmpresa INTO Pv_PreEmpresa;
  --
  CLOSE C_GetPrefijoEmpresa;
  --
  Pxml_Ats := LXML_Ats.GETCLOBVAL();
  --
  Pn_Tamanio := ROUND(LENGTHB(Pxml_Ats)/(1024*1024), 2);
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_MessageError := SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR('TELCOS - ATS', 'FNCK_CONSULTS.GET_ATS', Pv_MessageError);
  --
END GET_ATS;
--
/*Fin ATS*/
--
/**
* Documentacion para la funcion F_GET_ERROR_REPETIDO
* Funcion que obtiene un boolean consultando un mensaje de error
*
* @param  Fv_Mensaje    Recibe el mensaje a buscar
* @retrun Lb_Repite     Retorna TRUE en caso de que el mensaje de error ya exista y FALSO en caso de que no exista
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 06-05-2015
*/
FUNCTION F_GET_ERROR_REPETIDO(
    Fv_Mensaje IN VARCHAR2)
  RETURN BOOLEAN
IS
  --
  CURSOR C_GetErrorRepetido(Cv_Mensaje VARCHAR2 )
  IS
    SELECT
      'EXISTE'
    FROM
      INFO_ERROR
    WHERE
      DETALLE_ERROR = Cv_Mensaje;
  --
  Lb_Repite BOOLEAN := FALSE;
  --
  Lv_Existe VARCHAR2(6);
  --
BEGIN
  --
  IF C_GetErrorRepetido%ISOPEN THEN
    CLOSE C_GetErrorRepetido;
  END IF;
  --
  OPEN C_GetErrorRepetido(Fv_Mensaje);
  --
  FETCH
    C_GetErrorRepetido
  INTO
    Lv_Existe;
  --
  IF Lv_Existe = 'EXISTE' THEN
    Lb_Repite := TRUE;
  END IF;
  --
  RETURN Lb_Repite;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_ERROR_REPETIDO', 'FNCK_CONSULTS.F_GET_ERROR_REPETIDO', 'ERROR_STACK: ' ||
                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_ERROR_REPETIDO;

    FUNCTION F_APLICA_CREAR_FACT_INST(Pn_PuntoId DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE)
    RETURN VARCHAR2
    AS
        CURSOR C_FacturasInstXPunto (Cn_PuntoId         DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                     Cv_ContratoDigital DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                     Cv_ContratoFisico  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                     Cv_EstadoActivo    VARCHAR2,
                                     Cv_EstadoPendiente VARCHAR2,
                                     Cv_EstadoCerrado   VARCHAR2,
                                     Cv_ValorS          VARCHAR2,
                                     Cn_TipoDocumento   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE) IS
            SELECT
                CAB.ID_DOCUMENTO,
                CAB.ESTADO_IMPRESION_FACT,
                CAB.VALOR_TOTAL
            FROM
                DB_COMERCIAL.INFO_SERVICIO ISER,
                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB CAB,
                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET DET,
                DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
                DB_COMERCIAL.ADMI_CARACTERISTICA AC
            WHERE
                CAB.ID_DOCUMENTO = IDC.DOCUMENTO_ID
                AND CAB.ID_DOCUMENTO = DET.DOCUMENTO_ID
                AND DET.SERVICIO_ID = ISER.ID_SERVICIO
                AND ISER.PUNTO_ID = Cn_PuntoId
                AND IDC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
                AND AC.DESCRIPCION_CARACTERISTICA IN (Cv_ContratoDigital,Cv_ContratoFisico)
                AND AC.ESTADO = Cv_EstadoActivo
                AND IDC.VALOR = Cv_ValorS
                AND IDC.ESTADO = Cv_EstadoActivo
                AND CAB.ESTADO_IMPRESION_FACT in(Cv_EstadoPendiente,Cv_EstadoActivo,Cv_EstadoCerrado)
                AND CAB.TIPO_DOCUMENTO_ID = Cn_TipoDocumento;

        CURSOR C_GetTotalPagos (Cn_DocumentoId   DB_FINANCIERO.INFO_PAGO_DET.REFERENCIA_ID%TYPE,
                                Cv_EstadoCerrado DB_FINANCIERO.INFO_PAGO_DET.ESTADO%TYPE,
                                Cv_EstadoActivo  DB_FINANCIERO.INFO_PAGO_DET.ESTADO%TYPE) IS
          SELECT NVL(SUM(VALOR_PAGO), 0)
            FROM DB_FINANCIERO.INFO_PAGO_DET
           WHERE REFERENCIA_ID = Cn_DocumentoId
             AND ESTADO IN (Cv_EstadoCerrado,Cv_EstadoActivo);

        Lv_CreaFactura    VARCHAR2(1) := 'N';
        Ln_NumeroFacturas NUMBER      := 0;

        --Costo del query 5
        CURSOR C_GetTieneNC (Cn_FacturaId       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                             Cv_EstadoAprobada  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE DEFAULT 'Aprobada',
                             Cv_EstadoActivo    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE DEFAULT 'Activo',
                             Cv_CodTipoDocNC    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE DEFAULT 'NC',
                             Cv_CodTipoDocNCI   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE DEFAULT 'NCI')
        IS
            SELECT SUM(CAB.VALOR_TOTAL)
              FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB CAB,
                   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
             WHERE CAB.REFERENCIA_DOCUMENTO_ID = Cn_FacturaId
               AND CAB.ESTADO_IMPRESION_FACT IN (Cv_EstadoAprobada,Cv_EstadoActivo)
               AND CAB.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO
               AND ATDF.CODIGO_TIPO_DOCUMENTO IN (Cv_CodTipoDocNC, Cv_CodTipoDocNCI);

        Ln_ValorTotalxNCs   NUMBER := 0;

    BEGIN
        FOR Lr_FacturasInstXPunto IN C_FacturasInstXPunto (Cn_PuntoId         => Pn_PuntoId,
                                                           Cv_ContratoDigital => 'POR_CONTRATO_DIGITAL',
                                                           Cv_ContratoFisico  => 'POR_CONTRATO_FISICO',
                                                           Cv_EstadoActivo    => 'Activo',
                                                           Cv_EstadoPendiente => 'Pendiente',
                                                           Cv_EstadoCerrado   => 'Cerrado',
                                                           Cv_ValorS          => 'S',
                                                           Cn_TipoDocumento   => 1)
        LOOP
            Ln_ValorTotalxNCs := 0;
            Ln_NumeroFacturas := Ln_NumeroFacturas + 1;
            --Si tiene al menos una factura en estado Pendiente o Activo, no es necesario crear otra factura de instalaci�n para el mismo punto.
            IF Lr_FacturasInstXPunto.ESTADO_IMPRESION_FACT IN ('Pendiente','Activo') THEN
                Lv_CreaFactura := 'N';
                EXIT;
            --Si tiene al menos una factura en estado Cerrado
            ELSE
                --Se obtiene el total de las notas de cr�dito para saber si est� cerrada por NC
                OPEN  C_GetTieneNC (Cn_FacturaId  => Lr_FacturasInstXPunto.ID_DOCUMENTO);
                FETCH C_GetTieneNC INTO Ln_ValorTotalxNCs;
                CLOSE C_GetTieneNC;

                --SI EL TOTAL DE NOTAS DE CR�DITO (NC, NCI) ES MAYOR O IGUAL AL TOTAL DE LA FACTURA, S� DEBE CREAR OTRA FACTURA.
                IF NVL(Ln_ValorTotalxNCs, 0) >= Lr_FacturasInstXPunto.VALOR_TOTAL THEN
                    Lv_CreaFactura := 'S';
                    CONTINUE;
                END IF;
                Lv_CreaFactura := 'N';
                EXIT;
            END IF;
        END LOOP;

        IF C_FacturasInstXPunto%ISOPEN THEN
            CLOSE C_FacturasInstXPunto;
        END IF;

        --Si no se obtiene ninguna factura, se sobreescribe la bandera para que se genere la factura.
        IF Ln_NumeroFacturas <= 0 THEN
            Lv_CreaFactura := 'S';
        END IF;

        RETURN Lv_CreaFactura;
    EXCEPTION
        WHEN OTHERS THEN
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Facturas de instalaci�n',
                                          'FNCK_CONSULTS.F_APLICA_CREAR_FACT_INST',
                                          'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                          ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RETURN 'N';
    END F_APLICA_CREAR_FACT_INST;

--
/**
* Documentacion para la funcion FUN_COUNT_COMPROBANTES
* Funcion que obtiene el total por estados y tipo de documentos de los comprobantes agrupados por mes.
*
* @param  INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE IN  Fn_IdEstado        Reibe el id estado
* @param  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE       IN  Fn_IdOficina       Recibe la id oficina
* @param  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE IN Fv_CodDocumento Recibe el tipo de documento FAC, FACP, NC
* @param  VARCHAR2                                 IN  Fv_FechaInicio     Recibe la fecha de inicio de la busqueda
* @param  VARCHAR2                                 IN  Fv_FechaFin        Recibe la fecha fin de la busqueda
* @return NUMBER                                       Retorna el total de un estado de las facturas electronicas
*                                                      agrupadas por mes
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 10-11-2014
*/
FUNCTION FUN_COUNT_COMPROBANTES(
                      Fn_IdEstado     IN INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
                      Fn_IdOficina    IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                      Fv_CodDocumento IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                      Fv_FechaInicio  IN VARCHAR2,
                      Fv_FechaFin     IN VARCHAR2)
RETURN NUMBER
IS
  --
  CURSOR C_GetCountComprobantes(
    Cn_IdEstado       INFO_COMPROBANTE_ELECTRONICO.ESTADO%TYPE,
    Cn_IdOficina      INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Cv_CodDocumento   ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Cv_FechaInicio    VARCHAR2,
    Cv_FechaFin       VARCHAR2)
  IS
    SELECT
      COUNT(1) TOTAL
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_COMPROBANTE_ELECTRONICO ICE,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATD
    WHERE
      IDFC.ID_DOCUMENTO        = ICE.DOCUMENTO_ID
    AND IDFC.TIPO_DOCUMENTO_ID = ATD.ID_TIPO_DOCUMENTO
    AND ATD.ESTADO             = 'Activo'
    AND ATD.CODIGO_TIPO_DOCUMENTO  = NVL2(Cv_CodDocumento, Cv_CodDocumento, ATD.CODIGO_TIPO_DOCUMENTO)
    AND ICE.ESTADO                 = NVL2(Cn_IdEstado, Cn_IdEstado, ICE.ESTADO)
    AND IDFC.OFICINA_ID            = NVL2(Cn_IdOficina, Cn_IdOficina, IDFC.OFICINA_ID)
    AND ICE.FE_CREACION           >= NVL2(Cv_FechaInicio , TO_DATE(
      Cv_FechaInicio , 'DD-MM-YYYY HH24:MI:SS'), ICE.FE_CREACION)
    AND ICE.FE_CREACION           <= NVL2(Cv_FechaFin, TO_DATE(Cv_FechaFin,
      'DD-MM-YYYY HH24:MI:SS'), ICE.FE_CREACION);
  --
  Ln_TotalRegistros NUMBER := 0;
  --
BEGIN
  --
  IF C_GetCountComprobantes%ISOPEN THEN
    CLOSE C_GetCountComprobantes;
  END IF;
  --
  OPEN C_GetCountComprobantes(Fn_IdEstado,
                              Fn_IdOficina,
                              Fv_CodDocumento,
                              Fv_FechaInicio,
                              Fv_FechaFin);
  FETCH C_GetCountComprobantes INTO Ln_TotalRegistros;
  --
  CLOSE C_GetCountComprobantes;
  --
  RETURN Ln_TotalRegistros;
    --
  EXCEPTION
  WHEN OTHERS THEN
    FNCK_TRANSACTION.INSERT_ERROR('RESUMEN FACTURACION ELECTRONICA', 'FNCK_CONSULTS.FUN_COUNT_COMPROBANTES', SQLERRM);
END FUN_COUNT_COMPROBANTES;
--
/**
* Documentacion para la funcion F_GET_ADMI_PARAMETROS_DET
* Funcion que obtiene los parametros del detalle de la tabla ADMI_PARAMETRO_DET, para hacer uso de los NVL es necesario que
* el valor de los campos VALOR1..VALOR4 se inserten con la palabra 'NULL'
*
* @param  Fv_NombreParameteroCab IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE Recibe el codigo de la cabecera del parametro
* @param  Fv_EstadoParametroCab  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE           Recibe el estado de la cabecera del paramtero
* @param  Fv_EstadoParametroDet  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE           Recibe el estado del detalle del paramtero
* @param  Fv_Valor1              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           Recibe un valor segun la configuracion de nuestro paramtero
* @param  Fv_Valor2              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           Recibe un valor segun la configuracion de nuestro paramtero
* @param  Fv_Valor3              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE           Recibe un valor segun la configuracion de nuestro paramtero
* @param  Fv_Valor4              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE           Recibe un valor segun la configuracion de nuestro paramtero
* @return SYS_REFCURSOR          Devuelve el detalle de los parametros
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_ADMI_PARAMETROS_DET(
    Fv_NombreParameteroCab IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Fv_EstadoParametroCab  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
    Fv_EstadoParametroDet  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
    Fv_Valor1              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
    Fv_Valor2              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    Fv_Valor3              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
    Fv_Valor4              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE )
  RETURN SYS_REFCURSOR
IS
  --
  Lr_AdmiParamtrosDet SYS_REFCURSOR;
  --
BEGIN
  OPEN Lr_AdmiParamtrosDet FOR SELECT APD.*
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                     DB_GENERAL.ADMI_PARAMETRO_DET APD
                                WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                                AND APC.ESTADO = NVL(Fv_EstadoParametroCab, APC.ESTADO )
                                AND APD.ESTADO = NVL(Fv_EstadoParametroDet, APD.ESTADO )
                                AND APC.NOMBRE_PARAMETRO  = NVL(Fv_NombreParameteroCab, APC.NOMBRE_PARAMETRO )
                                AND APD.VALOR1 = NVL(Fv_Valor1, APD.VALOR1 )
                                AND APD.VALOR2 = NVL(Fv_Valor2, APD.VALOR2 )
                                AND APD.VALOR3 = NVL(Fv_Valor3, APD.VALOR3)
                                AND APD.VALOR4 = NVL(Fv_Valor4, APD.VALOR4);
  --
  RETURN Lr_AdmiParamtrosDet;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_ADMI_PARAMETROS_DET',
                                'FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_ADMI_PARAMETROS_DET;
--
/**
* Documentacion para la funcion F_GET_ALIAS_PLANTILLA
* Funcion que obtiene los alias y la plantilla recibiendo como parametro el codigo con el que guardamos la plantilla
*
* @param  Fv_CodigoPlantilla IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE      Recibe el codigo de la plantilla
* @return FNKG_TYPES.Lr_AliasPlantilla                                          Retorna un record con los correos y la plantilla de correo
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_ALIAS_PLANTILLA(
    Fv_CodigoPlantilla IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
  RETURN FNKG_TYPES.Lr_AliasPlantilla
IS
  --
  CURSOR C_GetAliasPlantilla(Cv_CodigoPlantilla
    DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE)
  IS
    SELECT
      LISTAGG (TRIM(AA.VALOR), ';') WITHIN GROUP (
    ORDER BY
      AA.VALOR) CORREOS,
      DBMS_LOB.SUBSTR(AP.PLANTILLA, LENGTH(AP.PLANTILLA), 1) PLANTILLA
    FROM
      DB_COMUNICACION.ADMI_PLANTILLA AP,
      DB_COMUNICACION.INFO_ALIAS_PLANTILLA IAP,
      DB_COMUNICACION.ADMI_ALIAS AA
    WHERE
      AP.CODIGO = Cv_CodigoPlantilla
    AND AP.ID_PLANTILLA = IAP.PLANTILLA_ID
    AND IAP.ALIAS_ID    = AA.ID_ALIAS
    AND IAP.ESTADO <> 'Eliminado'
    AND AP.ESTADO <> 'Eliminado'
    AND AA.ESTADO <> 'Eliminado'
    GROUP BY
      DBMS_LOB.SUBSTR(AP.PLANTILLA, LENGTH(AP.PLANTILLA), 1);
  --
  Lc_GetAliasPlantilla C_GetAliasPlantilla%ROWTYPE;
  --
BEGIN
  --
  IF C_GetAliasPlantilla%ISOPEN THEN
    --
    CLOSE C_GetAliasPlantilla;
    --
  END IF;
  --
  OPEN C_GetAliasPlantilla(Fv_CodigoPlantilla);
  --
  FETCH
    C_GetAliasPlantilla
  INTO
    Lc_GetAliasPlantilla;
  --
  CLOSE C_GetAliasPlantilla;
  --
  RETURN Lc_GetAliasPlantilla;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_ALIAS_PLANTILLA',
                                'FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_ALIAS_PLANTILLA;
--
/**
* Documentacion para el procedimiento P_SEND_MAIL
* El procedimiento hace uso del procedimiento UTL_MAIL.SEND para el envio de correo
*
* @param  Pv_From         IN  VARCHAR2  Recibe el usuario que envia el correo
* @param  Pv_To           IN  VARCHAR2  Recibe el/los usuario(s) que reciben el correo
* @param  Pv_Subject      IN  VARCHAR2  Recibe el subject del correo
* @param  Pv_Message      IN  VARCHAR2  Recibe el cuerpo del mensaje
* @param  Pv_MimeType     IN  VARCHAR2  Recibe el charset en el que se envia el correo
* @param  Pv_MsnError     OUT VARCHAR2  Retorna un mensaje de error
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
PROCEDURE P_SEND_MAIL(
    Pv_From         IN  VARCHAR2,
    Pv_To           IN  VARCHAR2,
    Pv_Subject      IN  VARCHAR2,
    Pv_Message      IN  VARCHAR2,
    Pv_MimeType     IN  VARCHAR2,
    Pv_MsnError     OUT VARCHAR2)
IS
  --
BEGIN
  --
  UTL_MAIL.SEND (SENDER => Pv_From, RECIPIENTS => Pv_To, SUBJECT => Pv_Subject,
  MESSAGE => Pv_Message, MIME_TYPE => Pv_MimeType );
  --
EXCEPTION
WHEN OTHERS THEN
  --
  Pv_MsnError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  --
  FNCK_TRANSACTION.INSERT_ERROR('P_SEND_MAIL', 'FNCK_CONSULTS.P_SEND_MAIL', Pv_MsnError);
  --
END P_SEND_MAIL;
--
/**
* Documentacion para la funcion F_GET_HISTORIAL_DOC
* Funcion que obtiene la cabecera del documento financiero del cual se busca el historial
*
* @param  Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el Id Documento
* @param  Fv_EstadoHistorial IN INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE            Recibe el estado del historial del documento financiero
* @return INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE                                 Retorna la cabecera de la INFO_DOCUMENTO_FINANCIERO_CAB
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_HISTORIAL_DOC(
    Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_EstadoHistorial IN INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE)
  RETURN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE
IS
  --
  CURSOR C_GetHistorial(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, Cv_EstadoHistorial
    INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE)
  IS
    SELECT
      IDFC.*
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      INFO_DOCUMENTO_HISTORIAL IDH
    WHERE
      IDFC.ID_DOCUMENTO   = IDH.DOCUMENTO_ID
    AND IDH.ESTADO        = Cv_EstadoHistorial
    AND IDFC.ID_DOCUMENTO = Cn_IdDocumento;
  --
  Lc_GetHistorial C_GetHistorial%ROWTYPE;
  --
BEGIN
  --
  IF C_GetHistorial%ISOPEN THEN
    --
    CLOSE C_GetHistorial;
    --
  END IF;
  --
  OPEN C_GetHistorial(Fn_IdDocumento, Fv_EstadoHistorial);
  --
  FETCH
    C_GetHistorial
  INTO
    Lc_GetHistorial;
  --
  CLOSE C_GetHistorial;
  --
  RETURN Lc_GetHistorial;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_HISTORIAL_DOC',
                                'FNCK_CONSULTS.F_GET_HISTORIAL_DOC',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_HISTORIAL_DOC;
--
/**
* Documentacion para la funcion F_GET_FACT_CAB_BY_NC
* Funcion que obtiene la cabecera de la factura enviando como parametro el id de la nota de credito
*
* @param  Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Recibe el Id Documento de la nota de credito
* @return INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE                                 Retorna la cabecera de la INFO_DOCUMENTO_FINANCIERO_CAB de factura
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_FACT_CAB_BY_NC(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE
IS
  --
  CURSOR C_GetFactByNC(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      IDFC.*
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB NC
    LEFT JOIN INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    ON
      NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
    WHERE
      NC.ID_DOCUMENTO = Cn_IdDocumento;
  --
  Lc_GetFactByNC C_GetFactByNC%ROWTYPE;
  --
BEGIN
  --
  IF C_GetFactByNC%ISOPEN THEN
    --
    CLOSE C_GetFactByNC;
    --
  END IF;
  --
  OPEN C_GetFactByNC(Fn_IdDocumento);
  --
  FETCH
    C_GetFactByNC
  INTO
    Lc_GetFactByNC;
  --
  CLOSE C_GetFactByNC;
  --
  RETURN Lc_GetFactByNC;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_FACT_CAB_BY_NC',
                                'FNCK_CONSULTS.F_GET_FACT_CAB_BY_NC',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_FACT_CAB_BY_NC;
--
/**
* Documentacion para la funcion F_GET_FORMA_PAGO
* la funcion F_GET_FORMA_PAGO retorna las formas de oagi en estado activo
*
* @param  Fn_IdFormaPago     IN ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE      Recibe el id de la forma de pago
* @param  Fv_CodigoFormaPago IN ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE  Recibe el codigo de la forma de pago
* @return FNKG_TYPES.Lrf_AdmiFormaPago                                  Retorna un refcursor con las formas de pago
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_FORMA_PAGO(
    Fn_IdFormaPago     IN ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
    Fv_CodigoFormaPago IN ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE)
  RETURN FNKG_TYPES.Lrf_AdmiFormaPago
IS
  --
  Lr_GetFormaPago FNKG_TYPES.Lrf_AdmiFormaPago;
  --
BEGIN
  --
  OPEN Lr_GetFormaPago FOR SELECT *
                            FROM ADMI_FORMA_PAGO
                            WHERE ESTADO = 'Activo'
                            AND ID_FORMA_PAGO = NVL(Fn_IdFormaPago, ID_FORMA_PAGO)
                            AND CODIGO_FORMA_PAGO = NVL(Fv_CodigoFormaPago, CODIGO_FORMA_PAGO);
  --
  RETURN Lr_GetFormaPago;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('APLICAR NC',
                                'FNCK_CONSULTS.F_GET_FORMA_PAGO',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_FORMA_PAGO;
--
/**
* Documentacion para la funcion F_GET_INFO_PAGO_CAB
* la funcion F_GET_INFO_PAGO_CAB retorna un registro con la informacion de la tabla INFO_PAGO_CAB
*
* @param  Fn_IdPago IN INFO_PAGO_CAB.ID_PAGO%TYPE   Recibe el id del pago
* @return INFO_PAGO_CAB%ROWTYPE                     Retorna la cabecera de la INFO_PAGO_CAB
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_INFO_PAGO_CAB(
    Fn_IdPago IN INFO_PAGO_CAB.ID_PAGO%TYPE)
  RETURN INFO_PAGO_CAB%ROWTYPE
IS
  --
  CURSOR C_GetInfoPagoCab (Cn_IdPago INFO_PAGO_CAB.ID_PAGO%TYPE)
  IS
    SELECT
      *
    FROM
      INFO_PAGO_CAB
    WHERE
      ID_PAGO = Cn_IdPago;
  --
  Lc_GetInfoPagoCab C_GetInfoPagoCab%ROWTYPE;
  --
BEGIN
  --
  IF C_GetInfoPagoCab%ISOPEN THEN
    --
    CLOSE C_GetInfoPagoCab;
    --
  END IF;--C_GetInfoPagoCab
  --
  OPEN C_GetInfoPagoCab(Fn_IdPago);
  --
  FETCH
    C_GetInfoPagoCab
  INTO
    Lc_GetInfoPagoCab;
  --
  CLOSE C_GetInfoPagoCab;
  --
  RETURN Lc_GetInfoPagoCab;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_INFO_PAGO_CAB',
                                'FNCK_CONSULTS.F_GET_INFO_PAGO_CAB',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_INFO_PAGO_CAB;
--
/**
* Documentacion para la funcion F_GET_INFO_PAGO_DET
* la funcion F_GET_INFO_PAGO_DET retorna los detalles de la INFO_PAGO_CAB
*
* @param  Fn_IdPagoDet IN INFO_PAGO_DET.ID_PAGO_DET%TYPE        Recibe el Id Pago Det
* @param  Fn_IdPago    IN INFO_PAGO_CAB.ID_PAGO%TYPE            Recibe el Id Pago de la cabcera INFO_PAGO_CAB
* @param  Fv_Estado    IN INFO_PAGO_DET.ESTADO%TYPE             Recibe le estado del pago
* @return FNKG_TYPES.Lrf_InfoPagoDet                            Retorna un ref cursor con los registros de la tabla INFO_PAGO_DET
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*
* @author Jos� Candelario <jcandelario@telconet.ec>
* @version 1.1 15-12-2020 Se recrea el query de forma dinamica para evitar costos altos al usar nvl en query anterior.
*/
FUNCTION F_GET_INFO_PAGO_DET(
    Fn_IdPagoDet IN INFO_PAGO_DET.ID_PAGO_DET%TYPE,
    Fn_IdPago    IN INFO_PAGO_CAB.ID_PAGO%TYPE,
    Fv_Estado    IN INFO_PAGO_DET.ESTADO%TYPE)
  RETURN FNKG_TYPES.Lrf_InfoPagoDet
IS
  --
  LrfInfoPagDet SYS_REFCURSOR;
  Lv_Query      VARCHAR2(3200);
  Lv_Select     VARCHAR2(3200);
  Lv_From       VARCHAR2(3200);
  Lv_Where      VARCHAR2(3200);
  --
BEGIN
  --
  Lv_Select := ' SELECT * '; 
  Lv_From   := ' FROM DB_FINANCIERO.INFO_PAGO_DET ';
  Lv_Where  := ' WHERE 1 = 1 ';

  IF Fn_IdPagoDet IS NOT NULL AND Fn_IdPagoDet > 0 THEN
    Lv_Where  := Lv_Where || ' AND ID_PAGO_DET = '|| Fn_IdPagoDet;  
  END IF;
  
  IF Fn_IdPago IS NOT NULL AND Fn_IdPago > 0  THEN
    Lv_Where  := Lv_Where ||  ' AND PAGO_ID = ' || Fn_IdPago;  
  END IF;
  
  IF TRIM(Fv_Estado) IS NOT NULL THEN
    Lv_Where  := Lv_Where ||  ' AND ESTADO = '''||Fv_Estado||'''' ;  
  END IF;
  
  Lv_Query := Lv_Select || Lv_From || Lv_Where;
  
  OPEN LrfInfoPagDet FOR Lv_Query;
  --
  RETURN LrfInfoPagDet;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_INFO_PAGO_DET',
                                'FNCK_CONSULTS.F_GET_INFO_PAGO_DET',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_INFO_PAGO_DET;
--
/**
* Documentacion para la funcion F_GET_NUMERACION
* la funcion F_GET_NUMERACION retorna los registros de la tabla ADMI_NUMERACION
*
* @param  Fv_PrefijoEmpresa       IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE                    Recibe le prefijo de la empresa
* @param  Fv_EsMatriz             IN INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE                  Recibe el valor (S|N)
* @param  Fv_EsOficinaFacturacion IN INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE     Recibe el valor (S|N)
* @param  Fn_IdOficina            IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE                 Recibe le id oficina
* @param  Fv_CodigoNumeracion     IN ADMI_NUMERACION.CODIGO%TYPE                        Recibe el codigo de numeracion
* @return FNKG_TYPES.Lrf_AdmiNumeracion                                                 Retorna los registros de la tabla ADMI_NUMERACION
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_NUMERACION(
    Fv_PrefijoEmpresa       IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Fv_EsMatriz             IN INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE,
    Fv_EsOficinaFacturacion IN INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE,
    Fn_IdOficina            IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fv_CodigoNumeracion     IN ADMI_NUMERACION.CODIGO%TYPE)
  RETURN FNKG_TYPES.Lrf_AdmiNumeracion
IS
  --
  Lrf_GetAdmiNumeracion FNKG_TYPES.Lrf_AdmiNumeracion;
  --
BEGIN
  --
  OPEN Lrf_GetAdmiNumeracion FOR SELECT AN.*
                                FROM ADMI_NUMERACION AN,
                                    INFO_OFICINA_GRUPO IOG,
                                    INFO_EMPRESA_GRUPO IEG
                                WHERE AN.EMPRESA_ID = IEG.COD_EMPRESA
                                AND AN.OFICINA_ID = IOG.ID_OFICINA
                                AND IEG.PREFIJO   = NVL( Fv_PrefijoEmpresa, IEG.PREFIJO)
                                AND IEG.ESTADO    = 'Activo'
                                AND IOG.ESTADO    = 'Activo'
                                AND IOG.ES_MATRIZ = NVL( Fv_EsMatriz, IOG.ES_MATRIZ)
                                AND IOG.ES_OFICINA_FACTURACION = NVL(Fv_EsOficinaFacturacion, IOG.ES_OFICINA_FACTURACION)
                                AND IOG.ID_OFICINA = NVL(Fn_IdOficina, IOG.ID_OFICINA)
                                AND AN.CODIGO     = NVL(Fv_CodigoNumeracion, AN.CODIGO);
  --
  RETURN Lrf_GetAdmiNumeracion;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_NUMERACION',
                                'FNCK_CONSULTS.F_GET_NUMERACION',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_NUMERACION;
--
/**
* Documentacion para la funcion F_GET_ADMI_MOTIVO
* la funcion F_GET_ADMI_MOTIVO obtiene un registro de la tabla ADMI_MOTIVO segun el ID_MOTIVO enviado como parametro
*
* @param  Fn_IdMotivo         IN ADMI_MOTIVO.ID_MOTIVO%TYPE Recibe el ID_MOTIVO a consultar
* @return ADMI_MOTIVO%ROWTYPE                    Retorna un registro con la informacion de la ADMI_MOTIVO
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 20-01-2015
*/
FUNCTION F_GET_ADMI_MOTIVO(
    Fn_IdMotivo IN ADMI_MOTIVO.ID_MOTIVO%TYPE)
  RETURN ADMI_MOTIVO%ROWTYPE
IS
  --
  CURSOR C_GetAdmiMotivo(Cn_IdMotivo ADMI_MOTIVO.ID_MOTIVO%TYPE)
  IS
    SELECT
      *
    FROM
      ADMI_MOTIVO
    WHERE
      ID_MOTIVO = Cn_IdMotivo;
  --
  Lc_GetAdmiMotivo C_GetAdmiMotivo%ROWTYPE;
  --
BEGIN
  --
  IF C_GetAdmiMotivo%ISOPEN THEN
    --
    CLOSE C_GetAdmiMotivo;
    --
  END IF;
  --
  OPEN C_GetAdmiMotivo(Fn_IdMotivo);
  --
  FETCH
    C_GetAdmiMotivo
  INTO
    Lc_GetAdmiMotivo;
  --
  CLOSE C_GetAdmiMotivo;
  --
  RETURN Lc_GetAdmiMotivo;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_NUMERACION',
                                'FNCK_CONSULTS.F_GET_NUMERACION',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_ADMI_MOTIVO;
/**
* Documentacion para la funcion F_GET_TIPO_DOC_FINANCIERO
* la funcion F_GET_TIPO_DOC_FINANCIERO obtiene un registro de la tabla ADMI_TIPO_DOCUMENTO_FINANCIERO
*
* @param  Fn_IdTipoDocFinan     IN ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE        Recibe el id del tipo de documento financiero
* @param  Fv_CodigoTipoDocFinan IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE    Recibe el codigo del tipo de documento
* @return ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE                                                Retorna el registro ADMI_TIPO_DOCUMENTO_FINANCIERO
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_TIPO_DOC_FINANCIERO(
    Fn_IdTipoDocFinan     IN ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
    Fv_CodigoTipoDocFinan IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE )
  RETURN ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE
IS
  --
  CURSOR C_GetTipoDocFinanciero(Cn_IdTipoDocFinan
    ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE,
    Cv_CodigoTipoDocFinan
    ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  IS
    --
    SELECT
      *
    FROM
      ADMI_TIPO_DOCUMENTO_FINANCIERO
    WHERE
      ESTADO                  = 'Activo'
    AND ID_TIPO_DOCUMENTO     = NVL(Cn_IdTipoDocFinan, ID_TIPO_DOCUMENTO)
    AND CODIGO_TIPO_DOCUMENTO = NVL(Cv_CodigoTipoDocFinan, CODIGO_TIPO_DOCUMENTO);
  --
  Lc_GetTipoDocFinanciero C_GetTipoDocFinanciero%ROWTYPE;
  --
BEGIN
  --
  IF C_GetTipoDocFinanciero%ISOPEN THEN
    --
    CLOSE C_GetTipoDocFinanciero;
    --
  END IF;
  --
  OPEN C_GetTipoDocFinanciero(Fn_IdTipoDocFinan, Fv_CodigoTipoDocFinan);
  --
  FETCH
    C_GetTipoDocFinanciero
  INTO
    Lc_GetTipoDocFinanciero;
  --
  CLOSE C_GetTipoDocFinanciero;
  --
  RETURN Lc_GetTipoDocFinanciero;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_TIPO_DOC_FINANCIERO',
                                'FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_TIPO_DOC_FINANCIERO;
--
/**
* Documentacion para la funcion F_GET_INFO_DOC_FINANCIERO_CAB
* la funcion F_GET_INFO_DOC_FINANCIERO_CAB obtiene un registro de INFO_DOCUMENTO_FINANCIERO_CAB, recibiendo el id del documento o el id referencia del
* documento
*
* @param  Fn_IdDocumento           IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE               Recibe el id documento
* @param  Fn_ReferenciaDocumentoId IN INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE    Recibe el id referencia del documento
* @return INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE                                                     Retorna un registro con la informacion de
                                                                                                    INFO_DOCUMENTO_FINANCIERO_CAB
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_INFO_DOC_FINANCIERO_CAB(
    Fn_IdDocumento           IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fn_ReferenciaDocumentoId IN INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE)
  RETURN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE
IS
  --
  CURSOR C_GetInfoDocFinanCab(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, Cn_ReferenciaDocumentoId
    INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE)
  IS
    SELECT
      IDFC.*
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    WHERE
      IDFC.ID_DOCUMENTO = Cn_IdDocumento
  UNION ALL
  SELECT
    IDFC.*
  FROM
    INFO_DOCUMENTO_FINANCIERO_CAB IDFC
  WHERE
    IDFC.REFERENCIA_DOCUMENTO_ID = Cn_ReferenciaDocumentoId;
  --
  Lc_GetInfoDocFinanCab C_GetInfoDocFinanCab%ROWTYPE;
  --
BEGIN
  --
  IF C_GetInfoDocFinanCab%ISOPEN THEN
    --
    CLOSE C_GetInfoDocFinanCab;
    --
  END IF;
  --
  OPEN C_GetInfoDocFinanCab(Fn_IdDocumento, Fn_ReferenciaDocumentoId);
  --
  FETCH
    C_GetInfoDocFinanCab
  INTO
    Lc_GetInfoDocFinanCab;
  --
  CLOSE C_GetInfoDocFinanCab;
  --
  RETURN Lc_GetInfoDocFinanCab;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_INFO_DOC_FINANCIERO_CAB',
                                'FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_INFO_DOC_FINANCIERO_CAB;
--
/**
* Documentacion para la funcion F_GET_INFO_DOC_FINANCIERO_DET
* la funcion F_GET_INFO_DOC_FINANCIERO_DET obtiene los detalles de la tabla INFO_DOCUMENTO_FINANCIERO_CAB
*
* @param  Fn_IdDocDetalle IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE  Recibe el id detalle del documento
* @param  Fn_DocumentoId  IN INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE    Recibe el documento id
* @return SYS_REFCURSOR                                                         Retorna un refcursor ya que el query es dinamico
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_INFO_DOC_FINANCIERO_DET(
    Fn_IdDocDetalle IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
    Fn_DocumentoId  IN INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE)
  RETURN SYS_REFCURSOR
IS
  --
  Lv_Sql VARCHAR2(100) := 'SELECT * FROM INFO_DOCUMENTO_FINANCIERO_DET WHERE '
  ;
  Lv_Where_IdDocDetalle VARCHAR2(35) := 'ID_DOC_DETALLE = :intDocumento';
  Lv_Where_DocumentoId  VARCHAR2(35) := 'DOCUMENTO_ID = :intDocumento';
  Lsrf_InfoDocFinancieroDet SYS_REFCURSOR;
  Ln_Documento INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE := 0;
  --
BEGIN
  --
  IF Fn_IdDocDetalle IS NOT NULL THEN
    --
    Lv_Sql       := Lv_Sql || Lv_Where_IdDocDetalle;
    Ln_Documento := Fn_IdDocDetalle;
    --
  ELSE
    --
    Lv_Sql       := Lv_Sql || Lv_Where_DocumentoId;
    Ln_Documento := Fn_DocumentoId;
    --
  END IF;
  --
  OPEN Lsrf_InfoDocFinancieroDet FOR Lv_Sql USING Ln_Documento;
  --
  RETURN Lsrf_InfoDocFinancieroDet;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_INFO_DOC_FINANCIERO_DET',
                                'FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_DET',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_INFO_DOC_FINANCIERO_DET;
--
/**
* Documentacion para la funcion F_GET_INFO_DOC_FINANCIERO_IMP
* la funcion F_GET_INFO_DOC_FINANCIERO_IMP mediante query dinamico obtiene el impuesto del detalle que se envia a buscar
*
* @param  Fn_IdDocImp     IN INFO_DOCUMENTO_FINANCIERO_IMP.ID_DOC_IMP%TYPE      Recibe el ID_DOC_IMP
* @param  Fn_DetalleDocId IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE  Recibe el ID_DOC_DETALLE
* @return SYS_REFCURSOR                                                         Retorna los impuesto del detalle enviado
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_INFO_DOC_FINANCIERO_IMP(
    Fn_IdDocImp     IN INFO_DOCUMENTO_FINANCIERO_IMP.ID_DOC_IMP%TYPE,
    Fn_DetalleDocId IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  RETURN SYS_REFCURSOR
IS
  --
  Lv_Sql                VARCHAR2(100)                            := 'SELECT * FROM INFO_DOCUMENTO_FINANCIERO_IMP WHERE ';
  Lv_Where_IdDocImp     VARCHAR2(45)                             := 'ID_DOC_IMP = :intIdDocImp ';
  Lv_Where_DetalleDocId VARCHAR2(45)                             := 'DETALLE_DOC_ID = :intDetalleDocId';
  Ln_IdDocumento INFO_DOCUMENTO_FINANCIERO_DET.DOCUMENTO_ID%TYPE := 0;
  Lsrf_InfoDocFinancieroImp SYS_REFCURSOR;
  --
BEGIN
  --
  IF Fn_IdDocImp IS NOT NULL THEN
    --
    Lv_Sql         := Lv_Sql || Lv_Where_IdDocImp;
    Ln_IdDocumento := Fn_IdDocImp;
    --
  ELSE
    --
    Lv_Sql         := Lv_Sql || Lv_Where_DetalleDocId;
    Ln_IdDocumento := Fn_DetalleDocId;
    --
  END IF;
  --
  OPEN Lsrf_InfoDocFinancieroImp FOR Lv_Sql USING Ln_IdDocumento;
  --
  RETURN Lsrf_InfoDocFinancieroImp;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_INFO_DOC_FINANCIERO_IMP',
                                'FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_IMP',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_INFO_DOC_FINANCIERO_IMP;
--
/**
* Documentacion para la funcion F_GET_INFO_DOC_FINANCIERO_HST
* la funcion F_GET_INFO_DOC_FINANCIERO_HST mediante query obtiene el historial de un documento financiero
*
* @param  Fn_IdDocHistorial     IN INFO_DOCUMENTO_FINANCIERO_IMP.ID_DOC_IMP%TYPE      Recibe el ID_DOCUMENTO_HISTORIAL
* @param  Fn_IdDocumento        IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE  Recibe el DOCUMENTO_ID
* @return SYS_REFCURSOR                                                               Retorna el historial del documento consultado
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_INFO_DOC_FINANCIERO_HST(
    Fn_IdDocHistorial IN INFO_DOCUMENTO_HISTORIAL.ID_DOCUMENTO_HISTORIAL%TYPE,
    Fn_IdDocumento    IN INFO_DOCUMENTO_HISTORIAL.DOCUMENTO_ID%TYPE)
  RETURN SYS_REFCURSOR
IS
  --
  Lv_Sql                  VARCHAR2(100) := 'SELECT * FROM INFO_DOCUMENTO_HISTORIAL WHERE ';
  Lv_Where_IdDocHistorial VARCHAR2(45)  := 'ID_DOCUMENTO_HISTORIAL = :intIdDocHistorial ';
  Lv_Where_DocumentoId VARCHAR2(45)     := 'DOCUMENTO_ID = :intDocumentoId';
  Ln_IdDocumento INFO_DOCUMENTO_HISTORIAL.ID_DOCUMENTO_HISTORIAL%TYPE := 0;
  Lsrf_InfoDocFinancieroHst SYS_REFCURSOR;
  --
BEGIN
  --
  IF Fn_IdDocHistorial IS NOT NULL THEN
    --
    Lv_Sql         := Lv_Sql || Lv_Where_IdDocHistorial;
    Ln_IdDocumento := Fn_IdDocHistorial;
    --
  ELSE
    --
    Lv_Sql         := Lv_Sql || Lv_Where_DocumentoId;
    Ln_IdDocumento := Fn_IdDocumento;
    --
  END IF;
  --
  OPEN Lsrf_InfoDocFinancieroHst FOR Lv_Sql USING Ln_IdDocumento;
  --
  RETURN Lsrf_InfoDocFinancieroHst;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_INFO_DOC_FINANCIERO_HST',
                                'FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_HST',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_INFO_DOC_FINANCIERO_HST;
--
/**
* Documentacion para la funcion F_GET_INFO_PUNTO
* la funcion F_GET_INFO_PUNTO obtiene la informacion del punto que se requiera buscar
*
* @param  Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE  Recibe el ID_PUNTO
* @param  Fn_Login   IN INFO_PUNTO.LOGIN%TYPE     Recibe el LOGIN
* @return INFO_PUNTO%ROWTYPE                      Retorna un registro con la informacion del punto
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_INFO_PUNTO(
    Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fn_Login   IN INFO_PUNTO.LOGIN%TYPE)
  RETURN INFO_PUNTO%ROWTYPE
IS
  --
  CURSOR C_GetInfoPunto(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cn_Login
    INFO_PUNTO.LOGIN%TYPE)
  IS
    SELECT
      *
    FROM
      INFO_PUNTO IP
    WHERE
      IP.ID_PUNTO = Cn_IdPunto
  UNION ALL
  SELECT
    *
  FROM
    INFO_PUNTO IP
  WHERE
    IP.LOGIN = Cn_Login;
  --
  Lc_GetInfoPunto C_GetInfoPunto%ROWTYPE;
  --
BEGIN
  --
  IF C_GetInfoPunto%ISOPEN THEN
    --
    CLOSE C_GetInfoPunto;
    --
  END IF;
  --
  OPEN C_GetInfoPunto(Fn_IdPunto, Fn_Login);
  --
  FETCH
    C_GetInfoPunto
  INTO
    Lc_GetInfoPunto;
  --
  RETURN Lc_GetInfoPunto;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_INFO_PUNTO',
                                'FNCK_CONSULTS.F_GET_INFO_PUNTO',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_INFO_PUNTO;
--
/**
* Documentacion para la funcion F_GET_PREFIJO_BY_PUNTO
* Retorna el prefijo de la empresa segun el punto, se deja el parametro Fn_Login para
* posible consulta por el login del punto.
*
* @param  Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE  Recibe el ID_PUNTO
* @param  Fn_Login   IN INFO_PUNTO.LOGIN%TYPE     Recibe el LOGIN
* @return INFO_EMPRESA_GRUPO.PREFIJO%TYPE         Retorna el prefijo de la empresa
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 27-06-2016
*/
FUNCTION F_GET_PREFIJO_BY_PUNTO(
    Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fn_Login   IN INFO_PUNTO.LOGIN%TYPE)
  RETURN INFO_EMPRESA_GRUPO.PREFIJO%TYPE
IS
  --
  CURSOR C_GetPrefijoEmpresa(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT IEG.PREFIJO
    FROM INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_OFICINA_GRUPO IOG,
      INFO_EMPRESA_GRUPO IEG
    WHERE IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND IPER.OFICINA_ID             = IOG.ID_OFICINA
    AND IOG.EMPRESA_ID              = IEG.COD_EMPRESA
    AND ID_PUNTO                    = Cn_IdPunto;
  --
  Lv_Prefijo INFO_EMPRESA_GRUPO.PREFIJO%TYPE := '';
  --
BEGIN
  --
  IF C_GetPrefijoEmpresa%ISOPEN THEN
    --
    CLOSE C_GetPrefijoEmpresa;
    --
  END IF;
  --
  OPEN C_GetPrefijoEmpresa(Fn_IdPunto);
  --
  FETCH C_GetPrefijoEmpresa INTO Lv_Prefijo;
  --
  RETURN Lv_Prefijo;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_PREFIJO_BY_PUNTO',
                                'FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO',
                                'ERROR_STACK: '
                                || DBMS_UTILITY.FORMAT_ERROR_STACK
                                || ' ERROR_BACKTRACE: '
                                || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  RETURN Lv_Prefijo;
  --
END F_GET_PREFIJO_BY_PUNTO;
/**
* Documentacion para la funcion F_GET_NOMBRE_COMPLETO_CLIENTE
* la funcion F_GET_NOMBRE_COMPLETO_CLIENTE obtiene el nombre completo del cliente
*
* @param  Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE  Recibe el ID_PUNTO
* @return VARCHAR2                                Retorna la razon social, nombre o representante legal del cliente
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_NOMBRE_COMPLETO_CLIENTE(
    Fn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GetNombreCompletoCliente(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT
      IPR.*
    FROM
      INFO_PUNTO IP,
      INFO_PERSONA_EMPRESA_ROL IPER,
      INFO_PERSONA IPR
    WHERE
      IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND IPER.PERSONA_ID         = IPR.ID_PERSONA
    AND IP.ID_PUNTO             = Cn_IdPunto;
  --
  Lc_GetNombreCompletoCliente C_GetNombreCompletoCliente%ROWTYPE;
  Lv_NombreCompletoCliente INFO_PERSONA.RAZON_SOCIAL%TYPE := '';
  --
BEGIN
  --
  IF C_GetNombreCompletoCliente%ISOPEN THEN
    --
    CLOSE C_GetNombreCompletoCliente;
    --
  END IF;
  --
  OPEN C_GetNombreCompletoCliente(Fn_IdPunto);
  --
  FETCH
    C_GetNombreCompletoCliente
  INTO
    Lc_GetNombreCompletoCliente;
  --
  CLOSE C_GetNombreCompletoCliente;
  --
  IF Lc_GetNombreCompletoCliente.RAZON_SOCIAL IS NOT NULL THEN
    --
    Lv_NombreCompletoCliente := Lc_GetNombreCompletoCliente.RAZON_SOCIAL;
    --
  ELSIF Lc_GetNombreCompletoCliente.NOMBRES IS NOT NULL AND
    Lc_GetNombreCompletoCliente.APELLIDOS   IS NOT NULL THEN
    --
    Lv_NombreCompletoCliente := Lc_GetNombreCompletoCliente.NOMBRES || ' ' ||
    Lc_GetNombreCompletoCliente.APELLIDOS;
    --
  ELSIF Lc_GetNombreCompletoCliente.REPRESENTANTE_LEGAL IS NOT NULL THEN
    --
    Lv_NombreCompletoCliente := Lc_GetNombreCompletoCliente.REPRESENTANTE_LEGAL;
    --
  END IF;
  --
  RETURN INITCAP(Lv_NombreCompletoCliente);
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_NOMBRE_COMPLETO_CLIENTE',
                                'FNCK_CONSULTS.F_GET_NOMBRE_COMPLETO_CLIENTE',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_NOMBRE_COMPLETO_CLIENTE;
--
/**
* Documentacion para la funcion F_GET_INFO_PERSONA_FORMA_CONT
* la funcion F_GET_INFO_PERSONA_FORMA_CONT obtiene los valores de la forma contacto concatenados por ;
*
* @param  Fv_Codigo IN ADMI_FORMA_CONTACTO.CODIGO%TYPE  Recibe el codigo de la forma de contacto a buscar
* @param  Fv_Login  IN INFO_PERSONA.LOGIN%TYPE          Recibe el login de la persona
* @return VARCHAR2                                      Retorna los valores de la forma contacto concatenados por ;
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_INFO_PERSONA_FORMA_CONT(
    Fv_Codigo IN ADMI_FORMA_CONTACTO.CODIGO%TYPE,
    Fv_Login  IN INFO_PERSONA.LOGIN%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GetInfoPersonaFormaCont(Cv_Codigo ADMI_FORMA_CONTACTO.CODIGO%TYPE,
    Cv_Login INFO_PERSONA.LOGIN%TYPE)
  IS
    SELECT
      LISTAGG(IPFC.VALOR, ';') WITHIN GROUP (
    ORDER BY
      IPFC.VALOR ) VALOR
    FROM
      INFO_PERSONA IPER,
      INFO_PERSONA_FORMA_CONTACTO IPFC,
      ADMI_FORMA_CONTACTO AFC
    WHERE
      IPER.ID_PERSONA         = IPFC.PERSONA_ID
    AND AFC.ID_FORMA_CONTACTO = IPFC.FORMA_CONTACTO_ID
    AND IPFC.ESTADO           = 'Activo'
    AND IPFC.VALOR           IS NOT NULL
    AND AFC.CODIGO            = NVL(Cv_Codigo, AFC.CODIGO)
    AND LOWER(IPER.LOGIN)     = LOWER(Cv_Login);
  --
  Lc_GetInfoPersonaFormaCont C_GetInfoPersonaFormaCont%ROWTYPE;
  --
BEGIN
  --
  IF C_GetInfoPersonaFormaCont%ISOPEN THEN
    --
    CLOSE C_GetInfoPersonaFormaCont;
    --
  END IF;
  --
  OPEN C_GetInfoPersonaFormaCont(Fv_Codigo, Fv_Login);
  --
  FETCH
    C_GetInfoPersonaFormaCont
  INTO
    Lc_GetInfoPersonaFormaCont;
  --
  CLOSE C_GetInfoPersonaFormaCont;
  --
  RETURN Lc_GetInfoPersonaFormaCont.VALOR;
  --
END F_GET_INFO_PERSONA_FORMA_CONT;
--
/**
* Documentacion para la funcion F_CLOB_REPLACE
* la funcion F_CLOB_REPLACE realiza el replace entre CLOB'S
*
* @param  Fc_String  IN CLOB      Recibe el CLOB al cual se requiere hacer un replace
* @param  Fv_Search  IN VARCHAR   Recibe string a buscar en el CLOB
* @param  Fc_Replace IN CLOB      Recibe el CLOB con el que se hara el replace
* @return CLOB                    Retorna el CLOB al cual se ha hecho el replace
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_CLOB_REPLACE(
    Fc_String  IN CLOB,
    Fv_Search  IN VARCHAR,
    Fc_Replace IN CLOB )
  RETURN CLOB
IS
  --
  Ln_PlsInteger PLS_INTEGER;
BEGIN
  Ln_PlsInteger   := INSTR(Fc_String, Fv_Search);
  IF Ln_PlsInteger > 0 THEN
    RETURN SUBSTR(Fc_String, 1, Ln_PlsInteger-1) || Fc_Replace || SUBSTR(
    Fc_String, Ln_PlsInteger                 + LENGTH(Fv_Search));
  END IF;
  RETURN Fc_String;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_CLOB_REPLACE',
                                'FNCK_CONSULTS.F_CLOB_REPLACE',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_CLOB_REPLACE;
--
/**
* Documentacion para la funcion F_GET_DIFERENCIAS_FECHAS
* la funcion F_GET_DIFERENCIAS_FECHAS Obtiene la diferencia entre fechas
*
* @param  Fv_FechaInicio IN VARCHAR2    Recibe la fecha de inicio
* @param  Fv_FechaFin    IN VARCHAR2    Recibe la fecha fin
* @return NUMBER                        Retorna la diferencia de fechas
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_DIFERENCIAS_FECHAS(
    Fv_FechaInicio IN VARCHAR2,
    Fv_FechaFin    IN VARCHAR2)
  RETURN NUMBER
IS
  --
  Ln_Diferencia NUMBER := 0;
  --
BEGIN
  --
  Ln_Diferencia := ABS((TO_DATE(Fv_FechaFin, 'DD-MM-YYYY') - TO_DATE(Fv_FechaInicio, 'DD-MM-YYYY'))) + 1;
  --
  RETURN Ln_Diferencia;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_DIFERENCIAS_FECHAS',
                                'FNCK_CONSULTS.F_GET_DIFERENCIAS_FECHAS',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_DIFERENCIAS_FECHAS;
/**
* Documentacion para la funcion F_GET_SALDO_DISPONIBLE_BY_NC
* la funcion F_GET_SALDO_DISPONIBLE_BY_NC
*
* @param  Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Obtiene el saldo disponible de una factura
* por las notas de credito relacionadas en estado Activo
* @return NUMBER                                                            Retorna el saldo disponible
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_SALDO_DISPONIBLE_BY_NC(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_GetSaldoDisponibleByNc(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      (ROUND(NVL(IDFC.VALOR_TOTAL, 0), 2) - ROUND(SUM(NVL(IDFC_NC.VALOR_TOTAL, 0
      )), 2)) VALOR_TOTAL
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    LEFT JOIN INFO_DOCUMENTO_FINANCIERO_CAB IDFC_NC
    ON
      IDFC_NC.REFERENCIA_DOCUMENTO_ID  = IDFC.ID_DOCUMENTO
    AND IDFC_NC.ESTADO_IMPRESION_FACT IN ('Activo')
    LEFT JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    ON
      ATDF.ID_TIPO_DOCUMENTO       = IDFC.TIPO_DOCUMENTO_ID
    AND ATDF.ESTADO                = 'Activo'
    AND ATDF.CODIGO_TIPO_DOCUMENTO = 'NC'
    WHERE
      IDFC.ID_DOCUMENTO = Cn_IdDocumento
    GROUP BY
      ROUND(NVL(IDFC.VALOR_TOTAL, 0), 2);
  --
  Lc_GetSaldoDisponibleByNc C_GetSaldoDisponibleByNc%ROWTYPE;
  --
BEGIN
  --
  IF C_GetSaldoDisponibleByNc%ISOPEN THEN
    CLOSE C_GetSaldoDisponibleByNc;
  END IF;
  --
  OPEN C_GetSaldoDisponibleByNc(Fn_IdDocumento);
  --
  FETCH
    C_GetSaldoDisponibleByNc
  INTO
    Lc_GetSaldoDisponibleByNc;
  --
  CLOSE C_GetSaldoDisponibleByNc;
  --
  RETURN ROUND(NVL(Lc_GetSaldoDisponibleByNc.VALOR_TOTAL, 0), 2);
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_SALDO_DISPONIBLE_BY_NC',
                                'FNCK_CONSULTS.F_GET_SALDO_DISPONIBLE_BY_NC',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END F_GET_SALDO_DISPONIBLE_BY_NC;
--
/**
* Documentacion para la funcion F_GET_VALOR_SIMULADO_NC
* la funcion F_GET_VALOR_SIMULADO_NC Simula la creacion de una nota de credito y devuelve el valor total
*
* @param Fn_IdDocumento         IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Obtiene el id factura
* @param Fv_PorcentajeServicio  IN VARCHAR2                                         Obtiene un Y o N para realizar la NC por % del servicio
* @param Fn_Porcentaje          IN NUMBER                                           Obtiene el porcentaje del servicio
* @param Fv_ProporcionalPorDias IN VARCHAR2                                         Obtiene un Y o N para realizar la NC por proporcional por dias
* @param Fv_FechaInicio         IN VARCHAR2                                         Obtiene la fecha de inicio
* @param Fv_FechaFin            IN VARCHAR2                                         Obtiene la fecha fin
* @param Fv_ValorOriginal       IN VARCHAR2                                         Obtiene un Y o N para realizar la NC por valor original
* @return NUMBER                                                                    Retorna el valor de la nc simulada segun los parametros de entrada
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
FUNCTION F_GET_VALOR_SIMULADO_NC(
    Fn_IdDocumento         IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_PorcentajeServicio  IN VARCHAR2,
    Fn_Porcentaje          IN NUMBER,
    Fv_ProporcionalPorDias IN VARCHAR2,
    Fv_FechaInicio         IN VARCHAR2,
    Fv_FechaFin            IN VARCHAR2,
    Fv_ValorOriginal       IN VARCHAR2)
  RETURN NUMBER
IS
  --
  CURSOR C_GetInfoDocFinancieroDet(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      *
    FROM
      INFO_DOCUMENTO_FINANCIERO_DET
    WHERE
      DOCUMENTO_ID = Cn_IdDocumento;
  --
  CURSOR C_GetAdmiProducto(Cn_IdProducto ADMI_PRODUCTO.ID_PRODUCTO%TYPE)
  IS
    SELECT
      *
    FROM
      ADMI_PRODUCTO
    WHERE
      ID_PRODUCTO = Cn_IdProducto;
  --
  CURSOR C_GetInfoPlanCab(Cn_IdPlan INFO_PLAN_CAB.ID_PLAN%TYPE)
  IS
    SELECT
      *
    FROM
      INFO_PLAN_CAB
    WHERE
      ID_PLAN = Cn_IdPlan;
  --
  CURSOR C_GetInfoProductoImpuesto(Cn_IdProducto ADMI_PRODUCTO.ID_PRODUCTO%TYPE, Cv_Estado ADMI_PRODUCTO.ESTADO%TYPE)
  IS
    SELECT
      *
    FROM
      DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO
    WHERE
      PRODUCTO_ID = Cn_IdProducto
    AND ESTADO    = Cv_Estado;
  --
  CURSOR C_GetAdmiImpuesto(Cn_IdImpuesto ADMI_IMPUESTO.ID_IMPUESTO%TYPE, Cv_TipoImpuesto ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  IS
    SELECT
      *
    FROM
      ADMI_IMPUESTO
    WHERE
      ID_IMPUESTO     = NVL(Cn_IdImpuesto, ID_IMPUESTO)
    AND TIPO_IMPUESTO = NVL(Cv_TipoImpuesto, TIPO_IMPUESTO);
  --
  Lc_GetAdmiProducto            C_GetAdmiProducto%ROWTYPE;
  Lc_GetInfoProductoImpuesto    C_GetInfoProductoImpuesto%ROWTYPE;
  Lc_GetAdmiImpuesto            C_GetAdmiImpuesto%ROWTYPE;
  Lc_GetInfoPlanCab             C_GetInfoPlanCab%ROWTYPE;
  Lv_Prorratea                  VARCHAR2(1);
  Ln_Impuesto                   NUMBER := 0;
  Ln_SubTotal                   NUMBER := 0;
  Ln_ValorProrrateo             NUMBER := 0;
  Ln_Descuento                  NUMBER := 0;
  Ln_SumSubTotal                NUMBER := 0;
  --
  Lv_FechaInicioPeriodo    VARCHAR2(25) := '';
  Lv_FechaFinPeriodo       VARCHAR2(25) := '';
  Ln_CantidadDiasTotalMes  NUMBER       := 30;
  Ln_CantidadDiasRestantes NUMBER       := 0;
  --
BEGIN
  --Permite simular la NC por % del servicio
  IF UPPER(TRIM(Fv_PorcentajeServicio)) = 'Y' AND NVL(UPPER(TRIM(Fv_ProporcionalPorDias)), 'N') = 'N' AND NVL(UPPER(TRIM(Fv_ValorOriginal)), 'N') = 'N' THEN
    --
    Ln_ValorProrrateo := ROUND((NVL(Fn_Porcentaje, 0) / 100), 2);
  --Permite simular la NC por proporcional por dias
  ELSIF UPPER(TRIM(Fv_ProporcionalPorDias)) = 'Y' AND NVL(UPPER(TRIM(Fv_ValorOriginal)), 'N') = 'N' AND NVL(UPPER(TRIM(Fv_PorcentajeServicio)), 'N') = 'N' THEN
    --
    FNCK_CONSULTS.P_GET_FECHAS_DIAS_PERIODO(FNCK_CONSULTS.F_GET_EMPRESA(Fn_IdDocumento), FNCK_CONSULTS.F_GET_FORMATO_FECHA(Fv_FechaInicio), Lv_FechaInicioPeriodo, 
                                            Lv_FechaFinPeriodo, Ln_CantidadDiasTotalMes, Ln_CantidadDiasRestantes);    
    Ln_ValorProrrateo := NVL(FNCK_CONSULTS.F_GET_DIFERENCIAS_FECHAS(Fv_FechaInicio, Fv_FechaFin), 0) / Ln_CantidadDiasTotalMes;

  --Permite simular la NC por valor original
  ELSIF UPPER(TRIM(Fv_ValorOriginal)) = 'Y' AND NVL(UPPER(TRIM(Fv_PorcentajeServicio)), 'N') = 'N' AND NVL(UPPER(TRIM(Fv_ProporcionalPorDias)), 'N') = 'N' THEN
    --
    Ln_ValorProrrateo := 1;
    --
  END IF;
  --
  --Itera el detalle de la factura
  FOR I_GetInfoDocFinancieroDet IN C_GetInfoDocFinancieroDet(Fn_IdDocumento)
  LOOP
    --Pregunta que sea producto
    IF I_GetInfoDocFinancieroDet.PRODUCTO_ID IS NOT NULL OR I_GetInfoDocFinancieroDet.PRODUCTO_ID  <> 0 THEN
      --
      Lv_Prorratea := 'S';
      --
      IF C_GetAdmiProducto%ISOPEN THEN
        --
        CLOSE C_GetAdmiProducto;
        --
      END IF; --C_GetAdmiProducto
      --
      OPEN C_GetAdmiProducto(I_GetInfoDocFinancieroDet.PRODUCTO_ID);
      --
      FETCH
        C_GetAdmiProducto
      INTO
        Lc_GetAdmiProducto;
      --
      CLOSE C_GetAdmiProducto;
      --
      IF Lc_GetAdmiProducto.NOMBRE_TECNICO = 'OTROS' THEN
        --
        Lv_Prorratea := 'N';
        --
      END IF; --Lc_GetAdmiProducto.NOMBRE_TECNICO
      --
    END IF; --I_GetInfoDocFinancieroDet.PRODUCTO_ID
    --
    Ln_SubTotal  := 0;
    Ln_Descuento := 0;
    --Si no prorratea el subtotal y el descuento son los mismos, caso contrario se recalcula el subtotal y el descuento
    IF Lv_Prorratea = 'N' THEN
      --
      Ln_SubTotal   := NVL(I_GetInfoDocFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE, 0);
      Ln_Descuento  := NVL(I_GetInfoDocFinancieroDet.DESCUENTO_FACPRO_DETALLE, 0);
      --
    ELSE
      --
      Ln_SubTotal   := ROUND((NVL(I_GetInfoDocFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE, 0) * Ln_ValorProrrateo), 2);
      Ln_Descuento  := ROUND((NVL(I_GetInfoDocFinancieroDet.DESCUENTO_FACPRO_DETALLE, 0) * Ln_ValorProrrateo), 2);
      --
    END IF; --Lv_Prorratea
    --
    Ln_Impuesto := 0;
    --
    Ln_SubTotal := (Ln_SubTotal * NVL(I_GetInfoDocFinancieroDet.CANTIDAD, 0)) - Ln_Descuento;
    --Pregunta que sea producto
    IF I_GetInfoDocFinancieroDet.PRODUCTO_ID IS NOT NULL OR I_GetInfoDocFinancieroDet.PRODUCTO_ID  <> 0 THEN
      --Si es un producto itera los impuesto relacionados a este producto
      FOR I_GetInfoProductoImpuesto IN C_GetInfoProductoImpuesto(I_GetInfoDocFinancieroDet.PRODUCTO_ID, 'Activo')
      LOOP
        --
        IF C_GetAdmiImpuesto%ISOPEN THEN
          --
          CLOSE C_GetAdmiImpuesto;
          --
        END IF; --C_GetAdmiImpuesto
        --
        OPEN C_GetAdmiImpuesto(I_GetInfoProductoImpuesto.IMPUESTO_ID, NULL);
        --
        FETCH
          C_GetAdmiImpuesto
        INTO
          Lc_GetAdmiImpuesto;
        --
        CLOSE C_GetAdmiImpuesto;
        --
        Ln_Impuesto := (Ln_SubTotal * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100;
        --
      END LOOP; --I_GetInfoProductoImpuesto
      --
    END IF; --I_GetInfoDocFinancieroDet.PRODUCTO_ID
    --
    IF I_GetInfoDocFinancieroDet.PLAN_ID IS NOT NULL OR I_GetInfoDocFinancieroDet.PLAN_ID  <> 0 THEN
      --C_GetInfoPlanCab
      IF C_GetInfoPlanCab%ISOPEN THEN
        --
        CLOSE C_GetInfoPlanCab;
        --
      END IF; --C_GetAdmiImpuesto
      --
      OPEN C_GetInfoPlanCab(I_GetInfoDocFinancieroDet.PLAN_ID);
      --
      FETCH
        C_GetInfoPlanCab
      INTO
        Lc_GetInfoPlanCab;
      --
      CLOSE C_GetInfoPlanCab;
      --
      IF Lc_GetInfoPlanCab.IVA = 'S' THEN
        --
        IF C_GetAdmiImpuesto%ISOPEN THEN
          --
          CLOSE C_GetAdmiImpuesto;
          --
        END IF; --C_GetAdmiImpuesto
        --
        OPEN C_GetAdmiImpuesto(NULL, 'IVA');
        --
        FETCH
          C_GetAdmiImpuesto
        INTO
          Lc_GetAdmiImpuesto;
        --
        CLOSE C_GetAdmiImpuesto;
        --
        Ln_Impuesto := (Ln_SubTotal * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100;
        --
      END IF; --Lc_GetInfoPlanCab
      --
    END IF;
    --
    Ln_SumSubTotal := Ln_SumSubTotal + (ROUND(NVL(Ln_SubTotal, 0), 2) + ROUND(NVL(Ln_Impuesto, 0), 2));
    --
  END LOOP;
  --
  RETURN Ln_SumSubTotal;
  --
END F_GET_VALOR_SIMULADO_NC;
--
/**
* Documentacion para la funcion F_GET_PREF_EMPRESA_BY_OFICINA
* la funcion F_GET_PREF_EMPRESA_BY_OFICINA obtiene el prefijo de la empresa enviando como parametro el ID_OFICINA
*
* @param Fn_IdOficina IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE    Recibe le ID de la oficina
* @return DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE                      Retorna el prefijo de la empresa
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 27-04-2016
*/
FUNCTION F_GET_PREF_EMPRESA_BY_OFICINA(
    Fn_IdOficina IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE)
  RETURN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE
IS
  --
  CURSOR C_GetPrefijoEmpresa( Cn_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE)
  IS
    SELECT PREFIJO
    FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
      DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
    WHERE IOG.EMPRESA_ID = IEG.COD_EMPRESA
    AND IOG.ID_OFICINA   = Cn_IdOficina;
  --
  Lv_Prefio VARCHAR2(10) := '';
  --
BEGIN
  --
  IF C_GetPrefijoEmpresa%ISOPEN THEN
    --
    CLOSE C_GetPrefijoEmpresa;
    --
  END IF;
  --
  OPEN C_GetPrefijoEmpresa(Fn_IdOficina);
  --
  FETCH C_GetPrefijoEmpresa INTO Lv_Prefio;
  --
  CLOSE C_GetPrefijoEmpresa;
  --
  RETURN Lv_Prefio;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_PREF_EMPRESA_BY_OFICINA',
                                'FNCK_CONSULTS.F_GET_PREF_EMPRESA_BY_OFICINA',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
  RETURN '';
  --
END F_GET_PREF_EMPRESA_BY_OFICINA;
--
/**
* Documentacion para la funcion F_CAMBIO_ESTADO_PERMITIDO
* la funcion F_CAMBIO_ESTADO_PERMITIDO Retorna un boolean TRUE cuando el cambio de estado de un documento financiero no es permitido.
* Segun los parametros enviados consulta en las tablas de parametros ADMI_PARAMETRO_CAB, ADMI_PARAMETRO_DET los parametros no permitidos
* mapeados en los campos VALOR2 y VALOR3 segun el prefijo de la empresa.
*
* @param Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE            Recibe el Id del documento
* @param Fv_EstadoActual    IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE   Recibe el estado actual del documento
* @param Fv_EstadoNuevo     IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE   Recibe el estado a actualizar para el documento
* @param Fn_IdOficina       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE            Recibe el Id oficina del documento
* @param Fn_IdTipoDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE       Recibe el Id del tipo de documento
* @param Fv_NombreParametro IN VARCHAR2                                                   Recibe el nombre del parametro el cual contiene el mapeo de
                                                                                          estados no permitidos
* @param Fv_EstadoParamCab  IN VARCHAR2                                                   Recibe el estado de la cabecera del parametro
* @param Fv_EstadoParamDet  IN VARCHAR2                                                   Recibe el estado del detalle del parametro
* @return BOOLEAN                                                                         Retorna un TRUE cuando el parametro no esta permitido,
                                                                                          FALSE caso contrario
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 27-04-2016
*/
FUNCTION F_CAMBIO_ESTADO_PERMITIDO(
    Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_EstadoActual    IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    Fv_EstadoNuevo     IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    Fn_IdOficina       IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Fn_IdTipoDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE,
    Fv_NombreParametro IN VARCHAR2,
    Fv_EstadoParamCab  IN VARCHAR2,
    Fv_EstadoParamDet  IN VARCHAR2)
  RETURN BOOLEAN
IS
  --
  Lr_AdmiTipoDocFinanciero ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
  Lr_GetAdmiParamtrosDet DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lv_Prefijo DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  Ln_Boolean BOOLEAN;
  --
BEGIN
  --
  Ln_Boolean := FALSE;
  --
  --Busca prefijo empresa
  Lv_Prefijo := FNCK_CONSULTS.F_GET_PREF_EMPRESA_BY_OFICINA(Fn_IdOficina);
  --
  --Busca tipo documento
  Lr_AdmiTipoDocFinanciero := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(Fn_IdTipoDocumento, NULL);
  --
  Lrf_GetAdmiParamtrosDet := NULL;
  --
  --Busca el mapeo de los parametros
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Fv_NombreParametro,
                                                                     Fv_EstadoParamCab,
                                                                     Fv_EstadoParamDet,
                                                                     Lr_AdmiTipoDocFinanciero.CODIGO_TIPO_DOCUMENTO,
                                                                     Fv_EstadoActual,
                                                                     Fv_EstadoNuevo,
                                                                     Lv_Prefijo);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  --Si la variable no es nula existe parametro no permitido mapeado
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
    --
    Ln_Boolean := TRUE;
    --
  END IF;
  --
  RETURN Ln_Boolean;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_CAMBIO_ESTADO_PERMITIDO',
                                'FNCK_CONSULTS.F_CAMBIO_ESTADO_PERMITIDO',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
  RETURN TRUE;
END F_CAMBIO_ESTADO_PERMITIDO;
--
/**
* Documentacion para la funcion F_EXISTE_ADMI_PARAMETROS_DET
* Retorna TRUE si existe el registro en la tabla ADMI_PARAMETRO_DET
*
* @param  Fv_NombreParameteroCab IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE Recibe el codigo de la cabecera del parametro
* @param  Fv_EstadoParametroCab  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE           Recibe el estado de la cabecera del paramtero
* @param  Fv_EstadoParametroDet  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE           Recibe el estado del detalle del paramtero
* @param  Fv_Valor1              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE           Recibe un valor segun la configuracion del paramtero
* @param  Fv_Valor2              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           Recibe un valor segun la configuracion del paramtero
* @param  Fv_Valor3              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE           Recibe un valor segun la configuracion del paramtero
* @param  Fv_Valor4              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE           Recibe un valor segun la configuracion del paramtero
*
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 24-06-2016
*
*/
FUNCTION F_EXISTE_ADMI_PARAMETROS_DET(
    Fv_NombreParameteroCab IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
    Fv_EstadoParametroCab  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
    Fv_EstadoParametroDet  IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
    Fv_Valor1              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
    Fv_Valor2              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    Fv_Valor3              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
    Fv_Valor4              IN DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE)
  RETURN BOOLEAN
IS
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR                        := NULL;
  Lr_GetAdmiParamtrosDet DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE := NULL;
  Lbool_Existe BOOLEAN                                         := FALSE;
  --
BEGIN
  --
  Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Fv_NombreParameteroCab, Fv_EstadoParametroCab, Fv_EstadoParametroDet, Fv_Valor1, Fv_Valor2, Fv_Valor3, Fv_Valor4);
  --
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  --
  CLOSE Lrf_GetAdmiParamtrosDet;
  --
  IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
    --
    Lbool_Existe := TRUE;
    --
  END IF;
  --
  RETURN Lbool_Existe;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_CONSULTS', 'FNCK_CONSULTS.F_EXISTE_ADMI_PARAMETROS_DET', SQLERRM);
  --
  RETURN Lbool_Existe;
  --
END F_EXISTE_ADMI_PARAMETROS_DET;
--
/**
* Documentacion para la funcion F_GET_PREFIJO_EMPRESA
* Retorna el prefijo de la empresa recibiendo el COD_EMPRESA de la estructura INFO_EMPRESA_GRUPO
*
* @param Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Recibe el COD_EMPRESA
*
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 24-06-2016
*
*/
FUNCTION F_GET_PREFIJO_EMPRESA(
    Fv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  RETURN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE
IS
  --
  CURSOR C_GetEmpresa(Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT PREFIJO
    FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
    WHERE COD_EMPRESA = Cv_CodEmpresa;
  --
  Lv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE := '';
  --
BEGIN
  --
  IF C_GetEmpresa%ISOPEN THEN
    CLOSE C_GetEmpresa;
  END IF;
  --
  OPEN C_GetEmpresa(Fv_CodEmpresa);
  --
  FETCH C_GetEmpresa INTO Lv_CodEmpresa;
  --
  CLOSE C_GetEmpresa;
  --
  RETURN Lv_CodEmpresa;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_CONSULTS', 'FNCK_CONSULTS.F_GET_PREFIJO_EMPRESA', SQLERRM);
  --
  RETURN Lv_CodEmpresa;
  --
END F_GET_PREFIJO_EMPRESA;
--
/**
* Documentacion para la funcion F_GET_NOMBRE_CANTON
* Retorna el nombre del canton del punto
*
* @param Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE Recibe el id del punto
*
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 24-06-2016
*
*/
FUNCTION F_GET_NOMBRE_CANTON(
    Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE
IS
  --
  CURSOR C_GetCanton(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    SELECT AC.NOMBRE_CANTON
    FROM DB_COMERCIAL.INFO_PUNTO IP,
      DB_GENERAL.ADMI_SECTOR AST,
      DB_GENERAL.ADMI_PARROQUIA APQ,
      DB_GENERAL.ADMI_CANTON AC
    WHERE AC.ID_CANTON   = APQ.CANTON_ID
    AND APQ.ID_PARROQUIA = AST.PARROQUIA_ID
    AND AST.ID_SECTOR    = IP.SECTOR_ID
    AND IP.ID_PUNTO      = Cn_IdPunto;
  --
  Lv_NombreCanton DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE := '';
  --
BEGIN
  --
  IF C_GetCanton%ISOPEN THEN
    CLOSE C_GetCanton;
  END IF;
  --
  OPEN C_GetCanton(Fn_IdPunto);
  --
  FETCH C_GetCanton INTO Lv_NombreCanton;
  --
  CLOSE C_GetCanton;
  --
  RETURN Lv_NombreCanton;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_CONSULTS', 'FNCK_CONSULTS.F_GET_NOMBRE_CANTON', SQLERRM);
  --
  RETURN Lv_NombreCanton;
  --
END F_GET_NOMBRE_CANTON;
--
/**
* Documentacion para la funcion F_TRUNC_BY_DELIMETER
* Trunca una cadena segun un delimitador
*
* @param Fv_String               IN VARCHAR2    Recibe la cadena a truncar
* @param Fv_DelimitadorTruncar   IN VARCHAR2    Recibe el delimitador por el cual se truncara la cadena
* @param Fn_NumeroTruncar        IN NUMBER      Recibe el numero a truncar
*
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 04-07-2016
*
*/
FUNCTION F_TRUNC_BY_DELIMETER(
    Fv_String             IN VARCHAR2,
    Fv_DelimitadorTruncar IN VARCHAR2,
    Fn_NumeroTruncar      IN NUMBER)
  RETURN VARCHAR2
IS
  --
  Ln_NumeroDelimitador NUMBER         := 0;
  Ln_NumeroTruncar     NUMBER         := 0;
  Lv_StringTruncada    VARCHAR2(2000) := '';
BEGIN
  SELECT REGEXP_COUNT(Fv_String, Fv_DelimitadorTruncar)
  INTO Ln_NumeroDelimitador
  FROM DUAL;
  Ln_NumeroTruncar   := Fn_NumeroTruncar;
  IF Fn_NumeroTruncar > Ln_NumeroDelimitador THEN
    Ln_NumeroTruncar := Ln_NumeroDelimitador;
  END IF;
  --
  SELECT SUBSTR(Fv_String, 1 ,INSTR(Fv_String, Fv_DelimitadorTruncar, 1, Ln_NumeroTruncar)-1)
  INTO Lv_StringTruncada
  FROM DUAL;
  --
  RETURN Lv_StringTruncada;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_CONSULTS', 'FNCK_CONSULTS.F_TRUNC_BY_DELIMETER', SQLERRM);
  --
  RETURN Fv_String;
  --
END F_TRUNC_BY_DELIMETER;
/**
* Documentacion para el procedimiento P_GET_ALIAS_PLANTILLA
* El procedimiento P_GET_ALIAS_PLANTILLA obtiene la plantilla y los correos asociados a esta
*
* @param Pv_CodigoPlantilla    IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE    Recibe el codigo de la plantilla a buscar
* @param Pv_Alias              OUT CLOB                                         Retorna el Alias de la plantilla
* @param Pv_Plantilla          OUT CLOB                                         Retorna la plantilla
* @param Pv_MessageError       OUT VARCHAR2                                     Retorna un mensaje de error en caso de existir uno
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
PROCEDURE P_GET_ALIAS_PLANTILLA(
    Pv_CodigoPlantilla    IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_Alias              OUT CLOB,
    Pv_Plantilla          OUT CLOB,
    Pv_MessageError       OUT VARCHAR2)
IS
  --
  Lc_GetAliasPlantilla  FNKG_TYPES.Lr_AliasPlantilla;
  Lb_Plantilla          CLOB;
  Lb_Alias              CLOB;
  --
BEGIN
  --
  Lc_GetAliasPlantilla  := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla);
  --
  Pv_Plantilla          := Lc_GetAliasPlantilla.PLANTILLA;
  Pv_Alias              := Lc_GetAliasPlantilla.ALIAS_CORREOS;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  Pv_MessageError := 'Error en FNCK_CONSULTS.P_GET_ALIAS_PLANTILLA - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  FNCK_TRANSACTION.INSERT_ERROR('P_GET_ALIAS_PLANTILLA',
                                'FNCK_CONSULTS.P_GET_ALIAS_PLANTILLA',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END P_GET_ALIAS_PLANTILLA;
  --
  --
  PROCEDURE P_DETALLE_NOTAS_DEBITO(
      Pn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_FeConsultaHasta IN VARCHAR2,
      Pn_TotalPago       IN OUT NUMBER,
      Pn_TotalND         IN OUT NUMBER,
      Pn_TotalNC         IN OUT NUMBER)
  IS
    --
    Cr_Listado SYS_REFCURSOR;
    Lr_Listado DB_FINANCIERO.FNKG_TYPES.Lr_InfoDocRelacionados;
    Lv_MessageError VARCHAR2(1000) := '';
    --
  BEGIN
    --Proceso:
    DB_FINANCIERO.FNCK_CONSULTS.P_DOCUMENTOS_RELACIONADOS(Pn_IdDocumento, Pv_FeConsultaHasta, Cr_Listado);
    LOOP
      FETCH Cr_Listado INTO Lr_Listado;
      EXIT
    WHEN Cr_Listado%NOTFOUND;
      IF(Lr_Listado.CODIGO_TIPO_DOCUMENTO    = 'PAG' OR Lr_Listado.CODIGO_TIPO_DOCUMENTO = 'PAGC' OR Lr_Listado.CODIGO_TIPO_DOCUMENTO = 'ANT'
         OR Lr_Listado.CODIGO_TIPO_DOCUMENTO = 'ANTC') THEN
        Pn_TotalPago                        := NVL(Pn_TotalPago, 0) + NVL(Lr_Listado.VALOR_PAGO, 0);
      ELSIF(Lr_Listado.CODIGO_TIPO_DOCUMENTO ='ND' OR Lr_Listado.CODIGO_TIPO_DOCUMENTO ='NDI' OR Lr_Listado.CODIGO_TIPO_DOCUMENTO = 'DEV') THEN
        Pn_TotalND                          := NVL(Pn_TotalND, 0) + NVL(Lr_Listado.VALOR_PAGO, 0);
        DB_FINANCIERO.FNCK_CONSULTS.P_DETALLE_NOTAS_DEBITO(Lr_Listado.ID_PAGO_DET, Pv_FeConsultaHasta, Pn_TotalPago, Pn_TotalND, Pn_TotalNC);
      ELSIF(Lr_Listado.CODIGO_TIPO_DOCUMENTO = 'NC' OR Lr_Listado.CODIGO_TIPO_DOCUMENTO = 'NCI') THEN
        Pn_TotalNC                          := NVL(Pn_TotalNC, 0) + NVL(Lr_Listado.VALOR_PAGO, 0);
      END IF;
    END LOOP;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MessageError := 'Error en FNCK_CONSULTS.P_DETALLE_NOTAS_DEBITO - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_DETALLE_NOTAS_DEBITO',
                                          Lv_MessageError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_DETALLE_NOTAS_DEBITO;
  --
  --
  --
PROCEDURE P_SALDO_X_FACTURA(
    Pn_IdDocumento  IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pn_ReferenciaId IN  INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
    Pn_Saldo        OUT NUMBER,
    Pv_MessageError OUT VARCHAR2)
IS
  --
  CURSOR C_GetFactByNC(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      IDFC.*
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB NC
    LEFT JOIN INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    ON
      NC.REFERENCIA_DOCUMENTO_ID = IDFC.ID_DOCUMENTO
    LEFT JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC', 'FACP')
    AND ATDF.ESTADO = 'Activo'
    WHERE
      IDFC.ESTADO_IMPRESION_FACT IN ('Activo', 'Cerrado')
    AND NC.ID_DOCUMENTO           = Cn_IdDocumento;
  --
  CURSOR C_GetFactura(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      IDFC.*
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    WHERE
      IDFC.ESTADO_IMPRESION_FACT IN ('Activo', 'Cerrado')
    AND IDFC.ID_DOCUMENTO         = Cn_IdDocumento;
  --
  CURSOR C_GetNotaCredito(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      SUM(NVL2(IDFC.VALOR_TOTAL, IDFC.VALOR_TOTAL, 0)) VALOR_TOTAL
    FROM
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE
      IDFC.TIPO_DOCUMENTO_ID         = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.CODIGO_TIPO_DOCUMENTO  IN ('NC', 'NCI')
    AND ATDF.ESTADO                  = 'Activo'
    AND IDFC.ESTADO_IMPRESION_FACT  IN ('Activo')
    AND IDFC.REFERENCIA_DOCUMENTO_ID = Cn_IdDocumento;
  --
  CURSOR C_GetPagos(Cn_IdReferencia INFO_PAGO_DET.REFERENCIA_ID%TYPE)
  IS
    SELECT
      IPD.ID_PAGO_DET,
      IPD.VALOR_PAGO
    FROM
      INFO_PAGO_DET IPD,
      INFO_PAGO_CAB IPC
    WHERE
      IPC.ID_PAGO         = IPD.PAGO_ID
    AND IPC.ESTADO_PAGO  IN ('Pendiente', 'Cerrado')
    AND IPD.REFERENCIA_ID = Cn_IdReferencia;
  --
  CURSOR C_GetNotaDebito(Cn_IdPagotDet INFO_PAGO_DET.ID_PAGO_DET%TYPE)
  IS
    SELECT
      SUM(NVL2(IDFC.VALOR_TOTAL, IDFC.VALOR_TOTAL, 0)) VALOR_TOTAL
    FROM
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE
      IDFD.DOCUMENTO_ID             = IDFC.ID_DOCUMENTO
    AND IDFC.ESTADO_IMPRESION_FACT  IN ('Activo', 'Cerrado')
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.ESTADO                 = 'Activo'
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('ND', 'NDI', 'DEV')
    AND IDFD.PAGO_DET_ID            = Cn_IdPagotDet;
  --
  CURSOR C_GetListadoNotaDebito(Cn_IdPagotDet INFO_PAGO_DET.ID_PAGO_DET%TYPE)
  IS
    SELECT
      IDFC.ID_DOCUMENTO
    FROM
      INFO_DOCUMENTO_FINANCIERO_DET IDFD,
      INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE
      IDFD.DOCUMENTO_ID             = IDFC.ID_DOCUMENTO
    AND IDFC.ESTADO_IMPRESION_FACT  IN ('Activo', 'Cerrado')
    AND IDFC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
    AND ATDF.ESTADO                 = 'Activo'
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('ND', 'NDI', 'DEV')
    AND IDFD.PAGO_DET_ID            = Cn_IdPagotDet;
  --
  Lc_GetFactura         INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lc_GetNotaCredito     C_GetNotaCredito%ROWTYPE;
  Lc_GetPagos           C_GetPagos%ROWTYPE;
  Lc_GetNotaDebito      C_GetNotaDebito%ROWTYPE;
  Lc_NotaDebito         C_GetListadoNotaDebito%ROWTYPE;
  --
  Lr_GetAdmiFormaPago   FNKG_TYPES.Lr_AdmiFormaPago;
  Lrf_GetAdmiFormaPago  FNKG_TYPES.Lrf_AdmiFormaPago;
  Ln_TotalPago          NUMBER := 0;
  Ln_TotalND            NUMBER := 0;
  Ln_TotalNC            NUMBER := 0;
  --
BEGIN
  --
  Lc_GetFactura := NULL;
  --Si el Pn_IdDocumento no es nulo obtiene la factura por la nota de credito con el campo referencia_documento_id
  IF Pn_IdDocumento IS NULL THEN
    --
    IF C_GetFactByNC%ISOPEN THEN
      --
      CLOSE C_GetFactByNC;
      --
    END IF;
    --
    OPEN C_GetFactByNC(Pn_ReferenciaId);
    --
    FETCH
      C_GetFactByNC
    INTO
      Lc_GetFactura;
    --
    CLOSE C_GetFactByNC;
    --
  ELSE
    --Obtiene la factura por su id documento
    IF C_GetFactura%ISOPEN THEN
      --
      CLOSE C_GetFactura;
      --
    END IF;
    --
    OPEN C_GetFactura(Pn_IdDocumento);
    --
    FETCH
      C_GetFactura
    INTO
      Lc_GetFactura;
    --
    CLOSE C_GetFactura;
    --
  END IF;--IF Pn_IdDocumento
  --
  Lc_GetNotaCredito := NULL;
  --Obtiene el total de las nota de credito
  IF C_GetNotaCredito%ISOPEN THEN
    --
    CLOSE C_GetNotaCredito;
    --
  END IF;
  --
  OPEN C_GetNotaCredito(Lc_GetFactura.ID_DOCUMENTO);
  --
  FETCH
    C_GetNotaCredito
  INTO
    Lc_GetNotaCredito;
  --
  CLOSE C_GetNotaCredito;
  --
  Ln_TotalPago := 0;
  Ln_TotalND   := 0;
  Ln_TotalNC   := 0;
  --Itera los pados de la factura para restar el valor total de la factura con el valor total de la nota de credito
  -- y restarlo al total de pagos y sumarle las notas de debito
  FOR I_GetPagos IN C_GetPagos(Lc_GetFactura.ID_DOCUMENTO)
  LOOP
    --
    Ln_TotalPago := Ln_TotalPago + NVL(I_GetPagos.VALOR_PAGO, 0);
    --
    IF C_GetNotaDebito%ISOPEN THEN
      --
      CLOSE C_GetNotaDebito;
      --
    END IF;
    --
    OPEN C_GetNotaDebito(I_GetPagos.ID_PAGO_DET);
    --
    FETCH
      C_GetNotaDebito
    INTO
      Lc_GetNotaDebito;
    --
    CLOSE C_GetNotaDebito;
    --
    Ln_TotalND := Ln_TotalND + NVL(Lc_GetNotaDebito.VALOR_TOTAL, 0);
    --
    --Obtener el listado de ND, para verificar los pagos de las mismas
    IF C_GetListadoNotaDebito%ISOPEN THEN
      --
      CLOSE C_GetListadoNotaDebito;
      --
    END IF;
    --
    OPEN C_GetListadoNotaDebito(I_GetPagos.ID_PAGO_DET);
    --
    LOOP
      FETCH
        C_GetListadoNotaDebito
      INTO
        Lc_NotaDebito;
      --
      EXIT WHEN C_GetListadoNotaDebito%NOTFOUND;
      --
      P_DETALLE_NOTAS_DEBITO(Lc_NotaDebito.ID_DOCUMENTO, NULL, Ln_TotalPago, Ln_TotalND, Ln_TotalNC);
      --
    END LOOP;
    --
    CLOSE C_GetListadoNotaDebito;
    --
  END LOOP;--I_GetPagos
  --
  --Ln_TotalNC del proceso interno
  Pn_Saldo := ROUND(NVL(Lc_GetFactura.VALOR_TOTAL, 0), 2) - ROUND(NVL(Lc_GetNotaCredito.VALOR_TOTAL, 0), 2) - ROUND(NVL(Ln_TotalNC,0), 2) 
              - ROUND(NVL(Ln_TotalPago,0), 2) + ROUND(NVL(Ln_TotalND,0), 2);

  --
EXCEPTION
WHEN OTHERS THEN
  --
  Pv_MessageError := 'Error en FNCK_CONSULTS.P_SALDO_X_FACTURA - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  FNCK_TRANSACTION.INSERT_ERROR('SALDO_X_FACTURA',
                                'FNCK_CONSULTS.P_SALDO_X_FACTURA',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END P_SALDO_X_FACTURA;
--
/**
* Documentacion para el procedimiento P_APLICA_NOTA_CREDITO
* El procedimiento P_APLICA_NOTA_CREDITO genera los ANTC y NDI que se requieran al aplicar la Nota de Credito
* Este proceso es llamado del trigger AFTER_DML_INFO_COMP_ELEC
*
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1 02-10-2018 - Se modifica para inicializar a nulo el campo deposito_pago_id al generar ANTC porque se adhiere a la contabilizaci�n 
*                           del dep�sito generando descuadre entre lo depositado y contabilizado.
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.2 23-03-2021 - Se agrega proceso de contabilizaci�n de ANTC
*
* @param  Pn_IdDocumento            IN    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE               Recibe el id documento de la nota de credito
* @param  Pn_RefereneciaDocumentoId IN    INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE    Recibe el referencia documento id de la nc(FAC ID)
* @param  Pn_OficinaId              IN    INFO_OFICINA_GRUPO.ID_OFICINA%TYPE                            Recibe el id oficina
* @param  Pv_MessageError           OUT   VARCHAR2                                                      Retorna un mensaje de error en caso de existir
*/
PROCEDURE P_APLICA_NOTA_CREDITO(
    Pn_IdDocumento            IN    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pn_RefereneciaDocumentoId IN    INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
    Pn_OficinaId              IN    INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Pv_MessageError           OUT   VARCHAR2)
IS
  --
  CURSOR C_GetDetallePagosFactura(Cn_IdDocumento
    INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  IS
    SELECT
      IPD.ID_PAGO_DET ID_PAGO_DET,
      NVL(IPD.PAGO_ID, 0) ID_PAGO,
      NVL(IPD.VALOR_PAGO, 0) VALOR_PAGO,
      NVL(IDFD.PAGO_DET_ID, 0 ) REFERENCIA_ND,
      IDFC.ESTADO_IMPRESION_FACT ESTADO_IMPRESION_FACT
    FROM
      INFO_PAGO_DET IPD
    LEFT JOIN INFO_DOCUMENTO_FINANCIERO_DET IDFD
    ON
      IPD.ID_PAGO_DET = IDFD.PAGO_DET_ID
    LEFT JOIN INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    ON
      IDFC.ID_DOCUMENTO = IDFD.DOCUMENTO_ID
    WHERE
      IPD.REFERENCIA_ID = Cn_IdDocumento
    ORDER BY NVL(IPD.VALOR_PAGO, 0) DESC;
  --
  -- Costo: 4
  CURSOR C_VALIDA_CONTABILIZA_ANTICIPO (Cv_EmpresaId VARCHAR2) IS
    SELECT APD.VALOR1 AS CONTABILIZA_ANTICIPO
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.EMPRESA_COD = Cv_EmpresaId
    AND APD.DESCRIPCION = ANTICIPO_NOTA_CREDITO
    AND APD.ESTADO = ESTADO_ACTIVO
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                AND APC.NOMBRE_PARAMETRO = VALIDA_PROCESOS_CONTABLES
                AND APC.ESTADO = ESTADO_ACTIVO) ;
  --
  Lr_InfoDocumentoFinancieroCab     INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lr_InfoDocumentoFinancieroNc      INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lr_InfoDocumentoFinancieroDet     INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
  Lr_InfoDocumentoFinCab            INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lr_InfoDocumentoFinanCabUpdate    INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lr_InfoDocumentoHistorial         INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
  Lr_AdmiTipoDocFinanciero          ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
  Lr_GetAdmiParamtrosDet            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lr_InfoPagoCab                    INFO_PAGO_CAB%ROWTYPE;
  Lr_InfoPagoHist                   INFO_PAGO_HISTORIAL%ROWTYPE;
  Lr_ParContable                    C_VALIDA_CONTABILIZA_ANTICIPO%ROWTYPE;

  Lrf_GetAdmiFormaPago              FNKG_TYPES.Lrf_AdmiFormaPago;
  Lr_GetAdmiFormaPago               FNKG_TYPES.Lr_AdmiFormaPago;
  Lrf_GetInfoPagoDet                FNKG_TYPES.Lrf_InfoPagoDet;
  Lr_GetInfoPagoDet                 FNKG_TYPES.Lr_InfoPagoDet;
  Lrf_GetAdmiNumeracion             FNKG_TYPES.Lrf_AdmiNumeracion;
  Lr_GetAdmiNumeracion              FNKG_TYPES.Lr_AdmiNumeracion;
  Lc_GetAliasPlantilla              FNKG_TYPES.Lr_AliasPlantilla;

  Lrf_GetAdmiParamtrosDet           SYS_REFCURSOR;

  Lv_MessageMail                    VARCHAR2(2000);
  Lv_TablaAnticipos                 VARCHAR2(2000);
  Lv_MsnError                       VARCHAR2(2000);
  Lv_NumeracionDocumento            VARCHAR2(20);
  Lv_Correos                        VARCHAR2(2000) := '';
  Ln_Saldo                          NUMBER := 0;
  Ln_TotalNC                        NUMBER :=0;
  Ln_ValorNuevo                     NUMBER :=0;
  Ln_Flag                           NUMBER := 0;

  Ln_SecuenciaInfoDocFinCab         INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE := 0;
  Ln_IdPagoDet                      INFO_PAGO_DET.ID_PAGO_DET%TYPE;
  Lex_Exception                     EXCEPTION;
  --
BEGIN
  --
  --Consulta si la nota de credito ya fui aplicada
  Lr_InfoDocumentoFinancieroCab := FNCK_CONSULTS.F_GET_HISTORIAL_DOC(Pn_IdDocumento, 'Aplicada');
  --Entra si la nota de credito no ha sido aplicada
  IF Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO IS NULL THEN
    --
    Lr_InfoDocumentoFinancieroCab := NULL;
    --Obtiene la factura con el id de la nota de credito
    Lr_InfoDocumentoFinancieroCab := FNCK_CONSULTS.F_GET_FACT_CAB_BY_NC(Pn_IdDocumento);
    --
    Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL    := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL ;
    Lr_InfoDocumentoHistorial.DOCUMENTO_ID              := Pn_IdDocumento;
    Lr_InfoDocumentoHistorial.MOTIVO_ID                 := NULL;
    Lr_InfoDocumentoHistorial.FE_CREACION               := SYSDATE;
    Lr_InfoDocumentoHistorial.USR_CREACION              := USER;
    Lr_InfoDocumentoHistorial.ESTADO                    := 'Aplicada';
    Lr_InfoDocumentoHistorial.OBSERVACION               := 'Se aplic� la Nota de Credito a la Fact # ' || Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI;
    --
    --Inserta el historial de la nota de credito
    FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoHistorial, Lv_MsnError);
    --Si existe error levanta la excepcion
    IF Lv_MsnError IS NOT NULL THEN
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    Lr_InfoDocumentoFinancieroNc := NULL;
    --Consulta la nota de credito
    Lr_InfoDocumentoFinancieroNc := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento, NULL);
    --Obtiene el saldo de la factura
    FNCK_CONSULTS.P_SALDO_X_FACTURA(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO, NULL, Ln_Saldo, Lv_MsnError);
    --
    IF Lv_MsnError IS NOT NULL THEN
      --
      RAISE Lex_Exception;
      --
    END IF;
    --Si el saldo de la factura es menor a cero cierra la factura y termina el proceso
    IF Ln_Saldo <= 0 THEN
      --
      Lr_InfoDocumentoFinanCabUpdate.ESTADO_IMPRESION_FACT := 'Cerrado';
      --Actualiza el estado de la factura
      FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO, Lr_InfoDocumentoFinanCabUpdate, Lv_MsnError);
      --
      IF Lv_MsnError IS NOT NULL THEN
        --
        RAISE Lex_Exception;
        --
      END IF;
      --
      Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL    := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL ;
      Lr_InfoDocumentoHistorial.DOCUMENTO_ID              := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
      Lr_InfoDocumentoHistorial.MOTIVO_ID                 := NULL;
      Lr_InfoDocumentoHistorial.FE_CREACION               := SYSDATE;
      Lr_InfoDocumentoHistorial.USR_CREACION              := USER;
      Lr_InfoDocumentoHistorial.ESTADO                    := 'Cerrado';
      Lr_InfoDocumentoHistorial.OBSERVACION               := 'CerradoNc';
      --Inserta el historial de la factura CerradoNc
      FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoHistorial, Lv_MsnError);
      --
      IF Lv_MsnError IS NOT NULL THEN
        --
        RAISE Lex_Exception;
        --
      END IF;
      --
    END IF;-- IF Ln_Saldo
    --Si el saldo de la factura es menor a cero se procede generar las NDI y los ANTC
    IF Ln_Saldo < 0 THEN
      --
      Ln_TotalNC        := ABS(Ln_Saldo);
      --
      Lv_TablaAnticipos := NULL;
      --Itera los pagos de la factura
      FOR I_GetDetallePagosFactura IN C_GetDetallePagosFactura(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO)
      LOOP
        --
        Ln_ValorNuevo := 0;
        --Entra si el pago no tien nota de debito
        IF ((I_GetDetallePagosFactura.REFERENCIA_ND      <> 0 AND I_GetDetallePagosFactura.ESTADO_IMPRESION_FACT <> 'Activo') OR
          ( I_GetDetallePagosFactura.REFERENCIA_ND        = 0 AND I_GetDetallePagosFactura.ESTADO_IMPRESION_FACT IS NULL )) THEN
          --
          Lr_GetInfoPagoDet  := NULL;
          Lrf_GetInfoPagoDet := NULL;
          --Obtiene el detalle del pago
          Lrf_GetInfoPagoDet := FNCK_CONSULTS.F_GET_INFO_PAGO_DET(I_GetDetallePagosFactura.ID_PAGO_DET, NULL, NULL);
          --
          LOOP --Lrf_GetInfoPagoDet
            --
            FETCH
              Lrf_GetInfoPagoDet
            INTO
              Lr_GetInfoPagoDet;
            --
            EXIT
          WHEN Lrf_GetInfoPagoDet%NOTFOUND;
            --
          END LOOP; --LOOP Lrf_GetInfoPagoDet
          --
          CLOSE Lrf_GetInfoPagoDet;
          --
          IF Ln_TotalNC <= Lr_GetInfoPagoDet.VALOR_PAGO THEN
            --
            Ln_ValorNuevo := Ln_TotalNC;
            --
            Ln_Flag := 1;
            --
          ELSE
            Ln_ValorNuevo := Lr_GetInfoPagoDet.VALOR_PAGO;
            --
            Ln_TotalNC := Ln_TotalNC - Lr_GetInfoPagoDet.VALOR_PAGO;
            --
            Ln_Flag :=0;
            --
          END IF; --Ln_TotalNC
          --
          Lr_GetAdmiFormaPago := NULL;
          --
          Lrf_GetAdmiFormaPago := NULL;
          --Obtiene la forma de pago CR, cruce
          Lrf_GetAdmiFormaPago := FNCK_CONSULTS.F_GET_FORMA_PAGO(NULL, 'CR');
          --
          LOOP --Lrf_GetAdmiFormaPago
            --
            FETCH
              Lrf_GetAdmiFormaPago
            INTO
              Lr_GetAdmiFormaPago;
            --
            EXIT
          WHEN Lrf_GetAdmiFormaPago%NOTFOUND;
            --
          END LOOP; --LOOP Lrf_GetAdmiFormaPago
          --
          CLOSE Lrf_GetAdmiFormaPago;
          --
        END IF; --IF I_GetDetallePagosFactura
        --
        Lr_GetAdmiNumeracion := NULL;
        --
        Lrf_GetAdmiNumeracion := NULL;
        --Obtiene la numeracion de los ANTC
        Lrf_GetAdmiNumeracion := FNCK_CONSULTS.F_GET_NUMERACION(NULL, NULL, NULL, Pn_OficinaId, 'ANTC');
        --
        LOOP --Lrf_GetAdmiNumeracion
          --
          FETCH
            Lrf_GetAdmiNumeracion
          INTO
            Lr_GetAdmiNumeracion;
          --
          EXIT
        WHEN Lrf_GetAdmiNumeracion%NOTFOUND;
          --
        END LOOP; --LOOP Lrf_GetAdmiNumeracion
        --
        CLOSE Lrf_GetAdmiNumeracion;
        --Obtiene la cabecera del pago
        Lr_InfoPagoCab              := FNCK_CONSULTS.F_GET_INFO_PAGO_CAB(I_GetDetallePagosFactura.ID_PAGO);
        --
        -- se verifica recupera parametro de contabilizaci�n de anticipo
        IF C_VALIDA_CONTABILIZA_ANTICIPO%ISOPEN THEN
          CLOSE C_VALIDA_CONTABILIZA_ANTICIPO;
        END IF;
        --
        OPEN C_VALIDA_CONTABILIZA_ANTICIPO(Lr_InfoPagoCab.EMPRESA_ID);
        FETCH C_VALIDA_CONTABILIZA_ANTICIPO INTO Lr_ParContable;
        IF C_VALIDA_CONTABILIZA_ANTICIPO%NOTFOUND THEN
          Lr_ParContable.Contabiliza_Anticipo := 'NO';
        END IF;
        CLOSE C_VALIDA_CONTABILIZA_ANTICIPO;
        --
        --
        Lr_InfoPagoCab.ID_PAGO      := SEQ_INFO_PAGO_CAB.NEXTVAL;
        --
        Lr_InfoPagoCab.ESTADO_PAGO  := 'Pendiente';
        --
        Lr_InfoPagoCab.FE_CREACION  := SYSDATE;
        --
        Lr_InfoPagoCab.FE_CRUCE     := NULL;
        --
        Lr_InfoPagoCab.USR_CRUCE    := NULL;
        --
        Lv_NumeracionDocumento      := NULL;
        --
        Lv_NumeracionDocumento      := Lr_GetAdmiNumeracion.NUMERACION_UNO || '-' ||
                                       Lr_GetAdmiNumeracion.NUMERACION_DOS || '-' || LPAD(
                                       Lr_GetAdmiNumeracion.SECUENCIA, 7, '0');
        --
        Lr_GetAdmiNumeracion.SECUENCIA := Lr_GetAdmiNumeracion.SECUENCIA + 1;
        --Actualiza la numeracion de los ANTC
        FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lr_GetAdmiNumeracion.ID_NUMERACION, Lr_GetAdmiNumeracion, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        Lr_InfoPagoCab.NUMERO_PAGO := TRIM(Lv_NumeracionDocumento);
        --
        Lr_AdmiTipoDocFinanciero:= NULL;
        --Obtien el id tipo documento ANTC
        Lr_AdmiTipoDocFinanciero := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(NULL, 'ANTC');
        --
        Lr_InfoPagoCab.TIPO_DOCUMENTO_ID := Lr_AdmiTipoDocFinanciero.ID_TIPO_DOCUMENTO;
        --
        Lr_InfoPagoCab.VALOR_TOTAL       := ROUND(NVL(Ln_ValorNuevo, 0), 2);
        --
        Lr_InfoPagoCab.COMENTARIO_PAGO   := 'Generado por N/C ' ||
                                            Lr_InfoDocumentoFinancieroNc.NUMERO_FACTURA_SRI || '. ' ||
                                            Lr_InfoPagoCab.COMENTARIO_PAGO;
        --
        Lr_InfoPagoCab.ANTICIPO_ID       := NULL;
        --Concatena los ANTC
        Lv_TablaAnticipos := Lv_TablaAnticipos || '<tr><td align = "center"> '
                                               || Lv_NumeracionDocumento || ' </td><td colspan="3" align = "center"> '
                                               || ROUND(NVL(Ln_ValorNuevo, 0), 2) || ' </td></tr>';
        --Clona el pago por ANTC
        FNCK_TRANSACTION.INSERT_INFO_PAGO_CAB(Lr_InfoPagoCab, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --Se crea HISTORIAL del ANTC
        Lr_InfoPagoHist                   :=NULL;
        --
        Lr_InfoPagoHist.ID_PAGO_HISTORIAL :=SEQ_INFO_PAGO_HISTORIAL.NEXTVAL;
        --
        Lr_InfoPagoHist.PAGO_ID           :=Lr_InfoPagoCab.ID_PAGO;
        --
        Lr_InfoPagoHist.FE_CREACION       :=SYSDATE;
        --
        Lr_InfoPagoHist.USR_CREACION      :=Lr_InfoDocumentoFinancieroNc.USR_CREACION;
        --
        Lr_InfoPagoHist.ESTADO            :='Pendiente';
        --
        Lr_InfoPagoHist.OBSERVACION       :='ANTC, Generado por N/C '|| Lr_InfoDocumentoFinancieroNc.NUMERO_FACTURA_SRI;
        --
        FNCK_TRANSACTION.INSERT_INFO_PAGO_HIST(Lr_InfoPagoHist, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        Lrf_GetInfoPagoDet := NULL;
        --
        Lr_GetInfoPagoDet := NULL;
        --Obtiene el detalle del pago
        Lrf_GetInfoPagoDet := FNCK_CONSULTS.F_GET_INFO_PAGO_DET(I_GetDetallePagosFactura.ID_PAGO_DET, NULL, NULL);
        --
        LOOP --Lrf_GetInfoPagoDet
          --
          FETCH
            Lrf_GetInfoPagoDet
          INTO
            Lr_GetInfoPagoDet;
          --
          EXIT
        WHEN Lrf_GetInfoPagoDet%NOTFOUND;
          --
        END LOOP; --LOOP Lrf_GetInfoPagoDet
        --
        CLOSE Lrf_GetInfoPagoDet;
        --
        Ln_IdPagoDet                    := Lr_GetInfoPagoDet.ID_PAGO_DET;
        --
        Lr_GetInfoPagoDet.ID_PAGO_DET   := SEQ_INFO_PAGO_DET.NEXTVAL;
        --
        Lr_GetInfoPagoDet.ESTADO        := 'Pendiente';
        --
        Lr_GetInfoPagoDet.FE_CREACION   := SYSDATE;
        --
        Lr_GetInfoPagoDet.VALOR_PAGO    := ROUND(NVL(Ln_ValorNuevo, 0), 2);
        --
        Lr_GetInfoPagoDet.DEPOSITADO    := 'S';
        --
        Lr_GetInfoPagoDet.REFERENCIA_ID := NULL;
        --
        Lr_GetInfoPagoDet.PAGO_ID       := Lr_InfoPagoCab.ID_PAGO;
        --
        Lr_GetInfoPagoDet.COMENTARIO    := 'Generado por N/C ' || Lr_InfoDocumentoFinancieroNc.NUMERO_FACTURA_SRI || '. '
                                           || Lr_GetInfoPagoDet.COMENTARIO;
        --
        Lr_GetInfoPagoDet.FORMA_PAGO_ID := Lr_GetAdmiFormaPago.ID_FORMA_PAGO;
        --
	-- llindao: se marca el ANTC mediante parametro si la empresa contabiliza
        IF NVL(Lr_ParContable.Contabiliza_Anticipo,'NO') = 'SI' THEN
          Lr_GetInfoPagoDet.TIPO_PROCESO := 'AnticipoNotaCredito';
        ELSE
          Lr_GetInfoPagoDet.TIPO_PROCESO := 'Pago';
        END IF;
        -- llindao: Documento generado por NDI no puede heredar el id deposito pago porque la contabilizaci�n considera como parte del dep�sito
        IF Lr_GetInfoPagoDet.DEPOSITO_PAGO_ID IS NOT NULL THEN
          Lr_GetInfoPagoDet.DEPOSITO_PAGO_ID := NULL;
        END IF;

        --Clona el detalle del pago
        FNCK_TRANSACTION.INSERT_INFO_PAGO_DET(Lr_GetInfoPagoDet, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        --
        -- llindao: si esta habilitado el parametro para la empresa se contabiliza ANTC
        IF NVL(Lr_ParContable.Contabiliza_Anticipo,'NO') = 'SI' THEN
          -- Se agrega c�digo para contabilizar ANTC.
          BEGIN
            fnkg_contabilizar_pago_manual.procesar_pago_anticipo_manual ( Lr_InfoPagoCab.EMPRESA_ID,
                                                                          Lr_GetInfoPagoDet.ID_PAGO_DET,
                                                                          'NO',
                                                                          Lv_MsnError);
            -- 
            Lv_MsnError := NULL;
            --
          EXCEPTION
            WHEN OTHERS THEN
              Lv_MsnError := NULL;
          END;
          --
        END IF;
        --
        --
        --GENERACION DE NOTA DE DEBITO
        Lr_GetAdmiNumeracion := NULL;
        --
        Lrf_GetAdmiNumeracion := NULL;
        --Obtiene la numeracion de NDI
        Lrf_GetAdmiNumeracion := FNCK_CONSULTS.F_GET_NUMERACION(NULL, NULL, NULL, Pn_OficinaId, 'NDI');
        --
        LOOP --Lrf_GetAdmiNumeracion
          --
          FETCH
            Lrf_GetAdmiNumeracion
          INTO
            Lr_GetAdmiNumeracion;
          --
          EXIT
        WHEN Lrf_GetAdmiNumeracion%NOTFOUND;
          --
        END LOOP; --LOOP Lrf_GetAdmiNumeracion
        --
        CLOSE Lrf_GetAdmiNumeracion;
        --
        Lv_NumeracionDocumento := NULL;
        --
        Lv_NumeracionDocumento := Lr_GetAdmiNumeracion.NUMERACION_UNO || '-' ||
                                  Lr_GetAdmiNumeracion.NUMERACION_DOS || '-' || LPAD(Lr_GetAdmiNumeracion.SECUENCIA, 7, '0');
        --
        Lr_GetAdmiNumeracion.SECUENCIA := Lr_GetAdmiNumeracion.SECUENCIA + 1;
        --Actualiza la numeracion para la NDI
        FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lr_GetAdmiNumeracion.ID_NUMERACION, Lr_GetAdmiNumeracion, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        Lr_AdmiTipoDocFinanciero:= NULL;
        --Obtiene le tipo de documento NDI
        Lr_AdmiTipoDocFinanciero := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(NULL, 'NDI');
        --
        Lr_InfoDocumentoFinCab                          := NULL;
        Ln_SecuenciaInfoDocFinCab                       := SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
        Lr_InfoDocumentoFinCab.ID_DOCUMENTO             := Ln_SecuenciaInfoDocFinCab;
        Lr_InfoDocumentoFinCab.OFICINA_ID               := Lr_InfoPagoCab.OFICINA_ID;
        Lr_InfoDocumentoFinCab.PUNTO_ID                 := Lr_InfoPagoCab.PUNTO_ID ;
        Lr_InfoDocumentoFinCab.TIPO_DOCUMENTO_ID        := Lr_AdmiTipoDocFinanciero.ID_TIPO_DOCUMENTO ;
        Lr_InfoDocumentoFinCab.NUMERO_FACTURA_SRI       := TRIM(Lv_NumeracionDocumento) ;
        Lr_InfoDocumentoFinCab.SUBTOTAL                 := ROUND(NVL(Ln_ValorNuevo, 0), 2);
        Lr_InfoDocumentoFinCab.SUBTOTAL_CERO_IMPUESTO   := 0;
        Lr_InfoDocumentoFinCab.SUBTOTAL_CON_IMPUESTO    := 0;
        Lr_InfoDocumentoFinCab.SUBTOTAL_DESCUENTO       := 0;
        Lr_InfoDocumentoFinCab.VALOR_TOTAL              := ROUND(NVL(Ln_ValorNuevo, 0), 2);
        Lr_InfoDocumentoFinCab.ENTREGO_RETENCION_FTE    := NULL ;
        Lr_InfoDocumentoFinCab.ESTADO_IMPRESION_FACT    := 'Cerrado';
        Lr_InfoDocumentoFinCab.ES_AUTOMATICA            := 'S';
        Lr_InfoDocumentoFinCab.PRORRATEO                := 'N';
        Lr_InfoDocumentoFinCab.REACTIVACION             := 'N';
        Lr_InfoDocumentoFinCab.RECURRENTE               := 'N';
        Lr_InfoDocumentoFinCab.COMISIONA                := 'N';
        Lr_InfoDocumentoFinCab.FE_CREACION              := SYSDATE;
        Lr_InfoDocumentoFinCab.FE_EMISION               := SYSDATE;
        Lr_InfoDocumentoFinCab.USR_CREACION             := USER;
        Lr_InfoDocumentoFinCab.SUBTOTAL_ICE             := 0;
        Lr_InfoDocumentoFinCab.NUM_FACT_MIGRACION       := NULL;
        Lr_InfoDocumentoFinCab.OBSERVACION              := 'Generado por NDI automatica' ;
        Lr_InfoDocumentoFinCab.REFERENCIA_DOCUMENTO_ID  := NULL;
        Lr_InfoDocumentoFinCab.LOGIN_MD                 := NULL;
        Lr_InfoDocumentoFinCab.ES_ELECTRONICA           := 'N';
        Lr_InfoDocumentoFinCab.NUMERO_AUTORIZACION      := NULL;
        Lr_InfoDocumentoFinCab.FE_AUTORIZACION          := NULL;
        Lr_InfoDocumentoFinCab.CONTABILIZADO            := NULL;
        --Crea la cabecera de la nota de Debito
        FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB( Lr_InfoDocumentoFinCab, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE                := SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
        Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID                  := Ln_SecuenciaInfoDocFinCab;
        Lr_InfoDocumentoFinancieroDet.PLAN_ID                       := NULL;
        Lr_InfoDocumentoFinancieroDet.PUNTO_ID                      := Lr_InfoPagoCab.PUNTO_ID;
        Lr_InfoDocumentoFinancieroDet.CANTIDAD                      := 1;
        Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE   := ROUND(NVL(Ln_ValorNuevo, 0), 2);
        Lr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO   := 0;
        Lr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE      := 0;
        Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE          := 0;
        Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE          := 0;
        Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE := 'Generado por NDI automatica: ' || Lr_GetInfoPagoDet.COMENTARIO;
        Lr_InfoDocumentoFinancieroDet.FE_CREACION                   := SYSDATE;
        Lr_InfoDocumentoFinancieroDet.FE_ULT_MOD                    := NULL;
        Lr_InfoDocumentoFinancieroDet.USR_CREACION                  := USER;
        Lr_InfoDocumentoFinancieroDet.USR_ULT_MOD                   := NULL;
        Lr_InfoDocumentoFinancieroDet.EMPRESA_ID                    := Lr_InfoPagoCab.EMPRESA_ID;
        Lr_InfoDocumentoFinancieroDet.OFICINA_ID                    := Lr_InfoPagoCab.OFICINA_ID;
        Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                   := NULL;
        Lr_InfoDocumentoFinancieroDet.MOTIVO_ID                     := NULL;
        Lr_InfoDocumentoFinancieroDet.PAGO_DET_ID                   := Ln_IdPagoDet;
        --Crea el detalle de la nota de Debito
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinancieroDet, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        EXIT
      WHEN Ln_Flag = 1;
        --
      END LOOP; -- LOOP I_GetDetallePagosFactura
      --
    END IF; --Ln_Saldo
    --
    Lrf_GetAdmiParamtrosDet := NULL;
    --Verifica que pueda enviar correo
    Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('ENVIO_CORREO', 'Activo', 'Activo', 'APLICAR_NC', 'SI', NULL, NULL);
    --
    FETCH
      Lrf_GetAdmiParamtrosDet
    INTO
      Lr_GetAdmiParamtrosDet;
    --
    CLOSE Lrf_GetAdmiParamtrosDet;
    --VERIFICA SI ESTA ACTIVADO PARA ENVIAR CORREO
    IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
      --
      Lrf_GetAdmiParamtrosDet := NULL;
      --
      Lr_GetAdmiParamtrosDet := NULL;
      --Obtiene los parametros para el envio de correo
      Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('ENVIO_CORREO', 'Activo', 'Activo', 'APLICAR_NC_FROM_SUBJECT', NULL, NULL, NULL);
      --
      FETCH
        Lrf_GetAdmiParamtrosDet
      INTO
        Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --
      IF Lr_GetAdmiParamtrosDet.VALOR4 = 'SI' THEN
        --
            Lv_Correos := ';' || FNCK_CONSULTS.F_GET_INFO_PERSONA_FORMA_CONT('MAIL', TRIM(Lr_InfoDocumentoFinancieroNc.USR_CREACION));
        --
      END IF; --Lr_GetAdmiParamtrosDet.VALOR4
      --Obtiene la plantilla y los alias anexados a la plantilla
      Lc_GetAliasPlantilla := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('APLICA_NC');
      --Se reemplaza el numero de la factura
      Lv_MessageMail := REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{ strNumeroFactura }}', Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI);
      --Se reemplaza por el numero de nota de credito
      Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ strNumeroNotaCredito }}', Lr_InfoDocumentoFinancieroNc.NUMERO_FACTURA_SRI);
      --Se reemplaza por la tabla generada por los anticipos
      IF Lv_TablaAnticipos IS NOT NULL THEN
        --
        Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ tableAnticipos }}', '<table class = "cssTable"  align="center">' ||
                                                                          '<tr><th colspan="4">Anticipos Generados</th>' ||
                                                                          '</tr> {{ rowAnticipos }} </table>');
        --
        Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ rowAnticipos }}', Lv_TablaAnticipos);
        --
      ELSE
        --
        Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ tableAnticipos }}', '');
        --
        Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ rowAnticipos }}', '');
        --
      END IF;

      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lc_GetAliasPlantilla.PLANTILLA           IS NOT NULL AND
         Lr_GetAdmiParamtrosDet.VALOR2            IS NOT NULL AND Lc_GetAliasPlantilla.ALIAS_CORREOS       IS NOT NULL AND
         Lr_GetAdmiParamtrosDet.VALOR3            IS NOT NULL THEN
         --Envia el correo
         FNCK_CONSULTS.P_SEND_MAIL(Lr_GetAdmiParamtrosDet.VALOR2 ,
                                   Lc_GetAliasPlantilla.ALIAS_CORREOS || TRIM(Lv_Correos),
                                   Lr_GetAdmiParamtrosDet.VALOR3,
                                   Lv_MessageMail,
                                   'text/html; charset=UTF-8',
                                   Lv_MsnError ) ;
         --
         IF Lv_MsnError IS NOT NULL THEN
           --
           RAISE Lex_Exception;
           --
         END IF;
         --
       END IF; --Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET..
      --
    END IF;--Lrf_GetAdmiParamtrosDet
    --
  END IF;--Lr_InfoDocumentoFinancieroCab
  --

  --
EXCEPTION
WHEN Lex_Exception THEN
  --
  Pv_MessageError := Lv_MsnError || ' ' || SQLERRM;
  FNCK_TRANSACTION.INSERT_ERROR('P_APLICA_NOTA_CREDITO', 'FNCK_CONSULTS.P_APLICA_NOTA_CREDITO', Pv_MessageError);
  --
WHEN OTHERS THEN
  --
  Pv_MessageError := Lv_MsnError || ' ERROR_STACK: ' ||
                     DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  FNCK_TRANSACTION.INSERT_ERROR('P_APLICA_NOTA_CREDITO', 'FNCK_CONSULTS.P_APLICA_NOTA_CREDITO', Pv_MessageError);
  --
  --
END P_APLICA_NOTA_CREDITO;
--
/**
* Documentacion para el procedimiento P_SPLIT_CLOB
* El procedimiento P_SPLIT_CLOB realiza el split de un CLOB retornando su resultado como un REF CURSOR
*
* @param  Pc_String         IN  CLOB          Recibe le CLOB al cual se requiere hacer un split
* @param  Pv_Delimitador    IN  VARCHAR2      Recibe el delimitador para hacer el split
* @param  Prf_Results       OUT SYS_REFCURSOR Retorna un REF CURSOR con la informacion
* @param  Pv_MessageError   OUT VARCHAR2      Retorna un mensaje de error si existe
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
PROCEDURE P_SPLIT_CLOB(
    Pc_String      IN CLOB,
    Pv_Delimitador IN VARCHAR2,
    Prf_Results OUT SYS_REFCURSOR,
    Pv_MessageError OUT VARCHAR2)
IS
  --
BEGIN
  --
  OPEN Prf_Results FOR SELECT REGEXP_SUBSTR(DBMS_LOB.SUBSTR( Pc_String, 32767,
  1 ),'[^' || Pv_Delimitador || ']+', 1, LEVEL) VALOR FROM DUAL CONNECT BY
  REGEXP_SUBSTR(DBMS_LOB.SUBSTR( Pc_String, 32767, 1 ), '[^' || Pv_Delimitador
  || ']+', 1, LEVEL) IS NOT NULL;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('P_SPLIT_CLOB',
                                'FNCK_CONSULTS.P_SPLIT_CLOB',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
END P_SPLIT_CLOB;
--
/**
* Documentacion para el procedimiento P_CREA_NOTA_CREDITO
* El procedimiento P_CREA_NOTA_CREDITO crea una nota de credito por un porcentaje de la factura, proporcional por dias o valor original
*
* @param  Pn_IdDocumento            IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE             Recibe el ID_DOCUMENTO
* @param  Pn_TipoDocumentoId        IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE   Recibe el CODIGO_TIPO_DOCUMENTO
* @param  Pv_Observacion            IN  INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE              Recibe la OBSERVACION
* @param  Pn_IdMotivo               IN  ADMI_MOTIVO.ID_MOTIVO%TYPE                                  Recibe el ID_MOTIVO
* @param  Pv_UsrCreacion            IN  INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE             Recibe el USR_CREACION
* @param  Pv_Estado                 IN  INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE                        Recibe el ESTADO
* @param  Pv_ValorOriginal          IN  VARCHAR2                                                    Recibe un Y o N para hacer la NC por valor original
* @param  Pv_PorcentajeServicio     IN  VARCHAR2                                                    Recibe un Y o N para hacer la NC por % del servicio
* @param  Pn_Porcentaje             IN  NUMBER                                                      Recibe el porcentaje
* @param  Pv_ProporcionalPorDias    IN  VARCHAR2                                                    Recibe un Y o N para hacer la NC por proporcional por dias
* @param  Pv_FechaInicio            IN  VARCHAR2                                                    Recibe la fecha de inicio
* @param  Pv_FechaFin               IN  VARCHAR2                                                    Recibe la fecha fin
* @param  Pn_IdOficina              IN  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE                          Recibe la ID_OFICINA
* @param  Pn_IdEmpresa              IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE                         Recibe el COD_EMPRESA
* @param  Pn_ValorTotal             OUT INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE              Retorna el toral de la nota  de credito
* @param  Pn_IdDocumentoNC          OUT INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE             Retorna el ID de la nota de credito
* @param  Pv_ObservacionCreacion    OUT VARCHAR2                                                    Retorna la observacion del proceso de creacion de la NC
* @param  Pbool_Done                OUT BOOLEAN                                                     Retorna TRUE si se hizo la NC, FALSE en caso de no hacerse la NC
* @param  Pv_MessageError           OUT VARCHAR2                                                    Recibe un mensaje de error en caso de existir
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
* @author Edgar Holguin <eholguin@telconet.ec>
* @version 1.0 29-09-2018 Se agrega funcionalidad para crear notas de cr�dito por medio de solicitudes.
*
* @author Alex Arreaga <atarreaga@telconet.ec>
* @version 1.2 29-10-2020 - Se agrega funcionalidad para crear notas de cr�dito por medio de solicitudes para proceso 
*                           de reubicaci�n. Se valida para cambiar a estado finalizado las solicitudes por reubicaci�n y 
*                           realize la clonaci�n de caracter�sticas de la solicitud a la Nc.
* Costo query C_GetParamSolicitud: 5
* Costo query C_GetSolicitudNcReub: 15
*/
PROCEDURE P_CREA_NOTA_CREDITO(
      Pn_IdDocumento            IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pn_TipoDocumentoId        IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_Observacion            IN  INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
      Pn_IdMotivo               IN  ADMI_MOTIVO.ID_MOTIVO%TYPE,
      Pv_UsrCreacion            IN  INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pv_Estado                 IN  INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE,
      Pv_ValorOriginal          IN  VARCHAR2,
      Pv_PorcentajeServicio     IN  VARCHAR2,
      Pn_Porcentaje             IN  NUMBER,
      Pv_ProporcionalPorDias    IN  VARCHAR2,
      Pv_FechaInicio            IN  VARCHAR2,
      Pv_FechaFin               IN  VARCHAR2,
      Pn_IdOficina              IN  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pn_IdEmpresa              IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pn_ValorTotal             OUT INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
      Pn_IdDocumentoNC          OUT INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_ObservacionCreacion    OUT VARCHAR2,
      Pbool_Done                OUT BOOLEAN,
      Pv_MessageError           OUT VARCHAR2)
IS
  --
  CURSOR 
    C_GetMotivoNc(Cn_IdMotivo DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE)
  IS
    SELECT AM.NOMBRE_MOTIVO
    FROM   DB_GENERAL.ADMI_MOTIVO  AM 
    WHERE  AM.ID_MOTIVO  =  Cn_IdMotivo      
    AND    AM.ESTADO     =  'Activo';

  CURSOR C_GetNombreTecnico(Cn_IdProducto
    DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE)
  IS
    SELECT
      NOMBRE_TECNICO
    FROM
      DB_COMERCIAL.ADMI_PRODUCTO
    WHERE
      NOMBRE_TECNICO = 'OTROS'
    AND ID_PRODUCTO  = Cn_IdProducto;
  --
  CURSOR C_GetImpuestoPlan(Cv_TipoImpuesto
    DB_COMERCIAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  IS
    SELECT
      *
    FROM
      DB_COMERCIAL.ADMI_IMPUESTO
    WHERE
      TIPO_IMPUESTO = Cv_TipoImpuesto;
  --
  CURSOR C_GetPlan(Cn_IdPlan DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
  IS
    SELECT
      *
    FROM
      DB_COMERCIAL.INFO_PLAN_CAB
    WHERE
      ID_PLAN = Cn_IdPlan;
  --
  CURSOR C_GetImpuestoProducto(Cn_IdProducto
    DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PRODUCTO_ID%TYPE)
  IS
    SELECT
      *
    FROM
      DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO
    WHERE
      PRODUCTO_ID = Cn_IdProducto
    AND ESTADO    = 'Activo';
  --
  CURSOR C_Getimpuesto (Cn_IdImpuesto
    DB_COMERCIAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE )
  IS
    SELECT
      ID_IMPUESTO,
      PORCENTAJE_IMPUESTO
    FROM
      DB_COMERCIAL.ADMI_IMPUESTO
    WHERE
      ID_IMPUESTO = Cn_IdImpuesto;
  --
CURSOR C_GetNotaCreditoNoActiva(Cn_IdDocumento
  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
IS
  SELECT
    'TRUE' TIENE_NC_PENDIENTE_APROBADA, ESTADO_IMPRESION_FACT
  FROM
    INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
    ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
  WHERE
    IDFC.TIPO_DOCUMENTO_ID         = ATDF.ID_TIPO_DOCUMENTO
  AND ATDF.ESTADO                  = 'Activo'
  AND ATDF.CODIGO_TIPO_DOCUMENTO   = 'NC'
  AND IDFC.ESTADO_IMPRESION_FACT  IN ('Pendiente', 'Aprobada')
  AND IDFC.REFERENCIA_DOCUMENTO_ID = Cn_IdDocumento;

  CURSOR C_CaractSolicitudNc( Cn_IdDocumento   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE ,
                              Cv_EstadoDoc     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                              Cv_TipoSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE)
  IS
    SELECT 
       AC1.DESCRIPCION_CARACTERISTICA AS CARACT_PORCENTAJE,
       IDSC1.VALOR AS VALOR_PORCENTAJE,
       IDSCARAC.CARACTERISTICA AS CARACT_VALOR,
       IDSCARAC.PORCENTAJE AS VALOR_CARACT,
       IDSCARAC.CARACTERISTICA_ID AS CARACTERISTICA
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    JOIN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC   ON IDFC.ID_DOCUMENTO         = IDC.DOCUMENTO_ID
    JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD         IDS   ON IDS.ID_DETALLE_SOLICITUD  = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0)
    JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD            ATS   ON ATS.ID_TIPO_SOLICITUD     = IDS.TIPO_SOLICITUD_ID
    JOIN DB_COMERCIAL.INFO_DETALLE_SOL_CARACT        IDSC1 ON IDS.ID_DETALLE_SOLICITUD  = IDSC1.DETALLE_SOLICITUD_ID
    JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC1   ON AC1.ID_CARACTERISTICA     = IDSC1.CARACTERISTICA_ID   
    JOIN (SELECT IDSC2.ID_SOLICITUD_CARACTERISTICA,
                 AC2.DESCRIPCION_CARACTERISTICA AS CARACTERISTICA, 
                 IDSC2.VALOR AS PORCENTAJE, 
                 IDSC2.CARACTERISTICA_ID  AS CARACTERISTICA_ID
          FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC2
          JOIN DB_COMERCIAL.ADMI_CARACTERISTICA  AC2 ON AC2.ID_CARACTERISTICA = IDSC2.CARACTERISTICA_ID
         ) IDSCARAC
         ON IDSCARAC.ID_SOLICITUD_CARACTERISTICA = IDSC1.DETALLE_SOL_CARACT_ID
    WHERE IDFC.ID_DOCUMENTO           = Cn_IdDocumento
    AND   IDFC.ESTADO_IMPRESION_FACT  = Cv_EstadoDoc
    AND   ATS.DESCRIPCION_SOLICITUD   = Cv_TipoSolicitud;

    CURSOR C_ProductoPlanIdNc( Cn_NombreParametro   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE ,
                               Cv_EstadoParametro   DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                               Cv_CaracteristicaId  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE)
    IS
      SELECT DET.VALOR4,DET.VALOR5
      FROM   DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      JOIN   DB_GENERAL.ADMI_PARAMETRO_DET DET ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE  CAB.NOMBRE_PARAMETRO = Cn_NombreParametro
      AND    CAB.ESTADO           = Cv_EstadoParametro
      AND    DET.VALOR3           = TO_CHAR(Cv_CaracteristicaId);


    CURSOR C_GetCaracteristicaDocumentoId (Cn_IdDocumento           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                                           Cv_DescCaracteristica    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                           Cv_EstadoInfoDocCaract   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE)
    IS
      SELECT 
        IDC.ID_DOCUMENTO_CARACTERISTICA
      FROM
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA  AC ON AC.ID_CARACTERISTICA  = IDC.CARACTERISTICA_ID
      WHERE
          IDC.DOCUMENTO_ID              = Cn_IdDocumento
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescCaracteristica
      AND IDC.ESTADO                    = Cv_EstadoInfoDocCaract;


    CURSOR C_GetSolicitudNc (Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                             Cv_DescripcionSolicitud      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                             Cv_EstadoSolicitud           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                             Cn_IdDocumento               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT 
        IDS.ID_DETALLE_SOLICITUD
      FROM
           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB CAB
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC  ON CAB.ID_DOCUMENTO         = IDC.DOCUMENTO_ID
      JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD         IDS  ON IDS.ID_DETALLE_SOLICITUD = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0)
      JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD            ATS  ON ATS.ID_TIPO_SOLICITUD    = IDS.TIPO_SOLICITUD_ID
      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC   ON AC.ID_CARACTERISTICA     = IDC.CARACTERISTICA_ID
      WHERE
          AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND ATS.DESCRIPCION_SOLICITUD     = Cv_DescripcionSolicitud
      AND IDS.ESTADO                    = Cv_EstadoSolicitud
      AND IDC.DOCUMENTO_ID              = Cn_IdDocumento;

    --
    CURSOR C_GetParamSolicitud(Cv_NombreParamCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                               Cv_UsrCreacion    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
                               Cv_Estado         DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                               Cv_EmpresaCod     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
    IS 
      SELECT APD.DESCRIPCION, APD.VALOR1, APD.VALOR2, APD.VALOR3
      FROM
        DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE 
        APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APC.MODULO       = 'FINANCIERO'
        AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
        AND APD.VALOR3       = Cv_UsrCreacion
        AND APD.ESTADO       = Cv_Estado
        AND APD.EMPRESA_COD  = Cv_EmpresaCod;
    --
    CURSOR C_GetSolicitudNcReub(Cv_DescripcionCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Cv_DescripcionSolicitud      DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                Cv_EstadoSolicitud           DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
                                Cn_IdDocumento               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) 
    IS 
      SELECT 
        IDS.ID_DETALLE_SOLICITUD
      FROM 
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD  IDS,
        DB_COMERCIAL.ADMI_TIPO_SOLICITUD     ATS,
        DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC,
        DB_COMERCIAL.ADMI_CARACTERISTICA     AC
      WHERE
        IDS.ID_DETALLE_SOLICITUD        = IDSC.DETALLE_SOLICITUD_ID
      AND IDS.TIPO_SOLICITUD_ID         = ATS.ID_TIPO_SOLICITUD
      AND ATS.DESCRIPCION_SOLICITUD     = Cv_DescripcionSolicitud  
      AND IDS.ESTADO                    = Cv_EstadoSolicitud 
      AND IDSC.CARACTERISTICA_ID        = AC.ID_CARACTERISTICA
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
      AND IDSC.VALOR IN (SELECT IDC_FACT.VALOR
                         FROM 
                           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_FACT,
                           DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_FACT,
                           DB_COMERCIAL.ADMI_CARACTERISTICA AC_FACT
                         WHERE 
                             IDFC_FACT.ID_DOCUMENTO             = IDC_FACT.DOCUMENTO_ID
                         AND IDC_FACT.CARACTERISTICA_ID         = AC_FACT.ID_CARACTERISTICA
                         AND AC_FACT.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaracteristica
                         AND IDFC_FACT.ID_DOCUMENTO             = Cn_IdDocumento
                        );
  --
  Lv_Prorratea          VARCHAR2(1);
  --
  Ln_SumaSubtotal       NUMBER := 0;
  Ln_SumaDescuento      NUMBER := 0;
  Ln_SumaImpuesto       NUMBER := 0;
  Ln_ValorTotal         NUMBER := 0;
  Ln_ValorProrrateo     NUMBER := 0;
  Ln_ValorNcSimulado    NUMBER := 0;
  Ln_SaldoDisponible    NUMBER := 0;
  Lv_NcCancelacion      VARCHAR2(1):= 'N';
  --
  Ln_IdDocumento                INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
  Lv_NumeroFacturaSri           INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
  Ln_IdDocDetalle               INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE;
  Ln_IdDocImp                   INFO_DOCUMENTO_FINANCIERO_IMP.ID_DOC_IMP%TYPE;
  Lr_InfoDocumentoFinanCab      INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lsrf_InfoDocumentoFinanDet    SYS_REFCURSOR;
  Lsrf_InfoDocumentoFinanImp    SYS_REFCURSOR;
  Lr_InfoDocumentoFinanDet      INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
  Lr_InfoDocumentoFinanImp      INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
  Lr_InfoDocumentoFinanHst      INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
  --
  Lc_Plan                   C_GetPlan%ROWTYPE;
  Lc_ImpuestoPlan           C_GetImpuestoPlan%ROWTYPE;
  Lc_ImpuestoProducto       C_GetImpuestoProducto %ROWTYPE;
  Lc_Impuesto               C_Getimpuesto%ROWTYPE;
  Lc_GetNotaCreditoNoActiva C_GetNotaCreditoNoActiva%ROWTYPE;
  Lc_NombreTecnico          C_GetNombreTecnico%ROWTYPE;
  Lc_ProductoPlanIdNc       C_ProductoPlanIdNc%ROWTYPE;
  Lc_MotivoCancel           C_GetMotivoNc%ROWTYPE;
  Lc_CaracteristicaDocId    C_GetCaracteristicaDocumentoId%ROWTYPE;
  Lc_GetSolicitudNc         C_GetSolicitudNc%ROWTYPE;
  Lv_EstadoDocumento        VARCHAR2(100);
  Lv_TipoCreacion           VARCHAR2(100);
  Lv_DescCacteristicaNc     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE       := 'SOLICITUD NOTA CREDITO';
  Lv_TipoSolicitud          DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE            := 'SOLICITUD NOTA CREDITO';
  Lv_ParamFactDetallada     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                    := 'FACTURACION SOLICITUD DETALLADA';
  Lv_EstadoActivo           DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                              := 'Activo';
  Lv_EstadoProcesado        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE                := 'Procesado';
  Lv_EstadoSolPendiente     DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE                        := 'Pendiente';
  Lv_EstadoSolFinalizado    DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE                        := 'Finalizado';
  Lr_UsrCancelacion         DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.USR_CREACION%TYPE          := 'telcos_cancel';
  Lv_NombreMotivo           DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE                              := '';
  Lr_InfoDocCaractNc        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE                         ;
  Lr_InfoDetSolicitudNc     DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE                            ;
  Lv_MsjErrorUpd            VARCHAR2(100)                                                          := '';
  --
  Lv_NombreParamCab         VARCHAR2(100)                                                          := 'PROCESO_REUBICACION';
  Lv_DescCaractFact         VARCHAR2(100)                                                          := 'SOLICITUD_FACT_REUBICACION'; 
  Lc_ValorParametro         C_GetParamSolicitud%ROWTYPE; 
  Lr_InfoDetSolHistorial    DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
  --
  Lex_Exception EXCEPTION;
  Lv_MsnError   VARCHAR2 (2000);
  --
  Lv_FechaInicioPeriodo    VARCHAR2(25) := '';
  Lv_FechaFinPeriodo       VARCHAR2(25) := '';
  Ln_CantidadDiasTotalMes  NUMBER       := 30;
  Ln_CantidadDiasRestantes NUMBER       := 0;
  --
BEGIN
  --
  Pbool_Done    := FALSE;
  Lv_Prorratea  := 'S';
  --
  IF C_GetParamSolicitud%ISOPEN THEN
      CLOSE C_GetParamSolicitud;
  END IF;

  OPEN C_GetParamSolicitud(Lv_NombreParamCab, Pv_UsrCreacion, Lv_EstadoActivo, Pn_IdEmpresa);
    FETCH C_GetParamSolicitud INTO Lc_ValorParametro;
  CLOSE C_GetParamSolicitud;
  --
  IF Lc_ValorParametro.VALOR1 IS NOT NULL AND Lc_ValorParametro.VALOR2 IS NOT NULL THEN 
    Lv_DescCacteristicaNc := Lc_ValorParametro.VALOR1; -- V1:DescripcionCaracteristica  
    Lv_TipoSolicitud      := Lc_ValorParametro.VALOR2; -- V2:TipoSolicitud
  END IF;
  --
  IF UPPER(TRIM(Pv_ProporcionalPorDias)) = 'N' AND NVL(UPPER(TRIM(Pv_ValorOriginal)), 'N') = 'N' AND NVL(UPPER(TRIM(Pv_PorcentajeServicio)), 'N') = 'N' THEN
    IF Pn_IdMotivo IS NOT NULL THEN
      IF C_GetMotivoNc%ISOPEN THEN
        CLOSE C_GetMotivoNc;
      END IF;

      OPEN C_GetMotivoNc(Pn_IdMotivo);
       FETCH C_GetMotivoNc
         INTO Lc_MotivoCancel;
      CLOSE C_GetMotivoNc;

      Lv_NombreMotivo := Lc_MotivoCancel.NOMBRE_MOTIVO;

      IF Lv_NombreMotivo = 'Cancelacion Voluntaria'  THEN
        Lv_NcCancelacion := 'S';
      END IF;

    END IF;


    IF C_CaractSolicitudNc%ISOPEN THEN
      CLOSE C_CaractSolicitudNc;
    END IF;


    IF C_GetCaracteristicaDocumentoId%ISOPEN THEN
      CLOSE C_GetCaracteristicaDocumentoId;
    END IF;

    OPEN C_GetCaracteristicaDocumentoId(Pn_IdDocumento,Lv_DescCacteristicaNc,Lv_EstadoActivo);
     FETCH C_GetCaracteristicaDocumentoId
       INTO Lc_CaracteristicaDocId;
    CLOSE C_GetCaracteristicaDocumentoId;

    Lr_InfoDocCaractNc.ID_DOCUMENTO_CARACTERISTICA := Lc_CaracteristicaDocId.ID_DOCUMENTO_CARACTERISTICA;
    Lr_InfoDocCaractNc.ESTADO                      := Lv_EstadoProcesado;
    Lr_InfoDocCaractNc.FE_ULT_MOD                  := SYSDATE;
    Lr_InfoDocCaractNc.USR_ULT_MOD                 := Lr_UsrCancelacion;



    IF C_GetSolicitudNc%ISOPEN THEN
      CLOSE C_GetSolicitudNc;
    END IF;

    OPEN C_GetSolicitudNc(Lv_DescCacteristicaNc, Lv_TipoSolicitud, Lv_EstadoSolPendiente,Pn_IdDocumento);
     FETCH C_GetSolicitudNc
       INTO Lc_GetSolicitudNc;
    CLOSE C_GetSolicitudNc;

    Lr_InfoDetSolicitudNc.ID_DETALLE_SOLICITUD := Lc_GetSolicitudNc.ID_DETALLE_SOLICITUD;
    Lr_InfoDetSolicitudNc.ESTADO               := Lv_EstadoSolFinalizado;

  END IF;
  --Pregunta si la variable no es nula
  IF Pn_IdDocumento IS NOT NULL THEN
    --
    IF C_GetNotaCreditoNoActiva%ISOPEN THEN
      --
      CLOSE C_GetNotaCreditoNoActiva;
      --
    END IF;
    --Obtiene notas de credito en estado Pendiente o Aprobada
    OPEN C_GetNotaCreditoNoActiva(Pn_IdDocumento);
    --
    FETCH
      C_GetNotaCreditoNoActiva
    INTO
      Lc_GetNotaCreditoNoActiva;
    --
    CLOSE C_GetNotaCreditoNoActiva;
    --Si no tiene NC en estado Pendiente o Aprobada puede generar la NC
    IF Lc_GetNotaCreditoNoActiva.TIENE_NC_PENDIENTE_APROBADA IS NULL THEN
      IF Lv_NcCancelacion = 'N'  THEN
      --
        Ln_ValorNcSimulado := FNCK_CONSULTS.F_GET_VALOR_SIMULADO_NC(Pn_IdDocumento,
                                                                    Pv_PorcentajeServicio,
                                                                    Pn_Porcentaje,
                                                                    Pv_ProporcionalPorDias,
                                                                    Pv_FechaInicio,
                                                                    Pv_FechaFin,
                                                                    Pv_ValorOriginal);
        --
        Ln_SaldoDisponible := FNCK_CONSULTS.F_GET_SALDO_DISPONIBLE_BY_NC(Pn_IdDocumento);
      END IF;
      --Entra si el valor simulado de la NC es menor o igual al saldo disponible o si en solicitud de cancelacion
      IF (Ln_ValorNcSimulado <= Ln_SaldoDisponible) OR (Lv_NcCancelacion = 'S') THEN
        --Permite realizar NC por % del servicio
        IF UPPER(TRIM(Pv_PorcentajeServicio)) = 'Y' AND NVL(UPPER(TRIM(Pv_ProporcionalPorDias)), 'N') = 'N' AND NVL(UPPER(TRIM(Pv_ValorOriginal)), 'N') = 'N' THEN
          --
          Ln_ValorProrrateo := ROUND((NVL(Pn_Porcentaje, 0) / 100), 2);
          --
          Lv_TipoCreacion   := 'PORCENTAJE DEL SERVICIO';
        --Permite realizar NC por valor proporcional por dias
        ELSIF UPPER(TRIM(Pv_ProporcionalPorDias)) = 'Y' AND NVL(UPPER(TRIM(Pv_ValorOriginal)), 'N') = 'N' AND NVL(UPPER(TRIM(Pv_PorcentajeServicio)), 'N') = 'N' THEN
          --
          FNCK_CONSULTS.P_GET_FECHAS_DIAS_PERIODO(Pn_IdEmpresa, FNCK_CONSULTS.F_GET_FORMATO_FECHA(Pv_FechaInicio), Lv_FechaInicioPeriodo, 
                                                  Lv_FechaFinPeriodo, Ln_CantidadDiasTotalMes, Ln_CantidadDiasRestantes);    
          Ln_ValorProrrateo := NVL(FNCK_CONSULTS.F_GET_DIFERENCIAS_FECHAS(Pv_FechaInicio, Pv_FechaFin), 0) / Ln_CantidadDiasTotalMes;
          --
          Lv_TipoCreacion   := 'PROPORCIONAL POR DIAS';
        --Permite realizar NC por valor original de la factura
        ELSIF UPPER(TRIM(Pv_ValorOriginal)) = 'Y' AND NVL(UPPER(TRIM(Pv_ProporcionalPorDias)), 'N') = 'N' AND NVL(UPPER(TRIM(Pv_PorcentajeServicio)), 'N') = 'N' THEN
          --
          Ln_ValorProrrateo := 1;
          --
          Lv_TipoCreacion   := 'VALOR ORIGINAL';
          --
        ELSIF UPPER(TRIM(Pv_ValorOriginal)) = 'N' AND NVL(UPPER(TRIM(Pv_ProporcionalPorDias)), 'N') = 'N' AND NVL(UPPER(TRIM(Pv_PorcentajeServicio)), 'N') = 'N' THEN
          --
          Ln_ValorProrrateo := 1;
          --
          Lv_TipoCreacion   := 'DETALLE';
        END IF;
        --Busca la cabecera de la factura
        Lr_InfoDocumentoFinanCab := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento, NULL);
        --
        Ln_IdDocumento                                   := Lr_InfoDocumentoFinanCab.ID_DOCUMENTO;
        Lv_NumeroFacturaSri                              := Lr_InfoDocumentoFinanCab.NUMERO_FACTURA_SRI;
        Lr_InfoDocumentoFinanCab.ID_DOCUMENTO            := SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
        Pn_IdDocumentoNC                                 := Lr_InfoDocumentoFinanCab.ID_DOCUMENTO;
        Lr_InfoDocumentoFinanCab.TIPO_DOCUMENTO_ID       := Pn_TipoDocumentoId;
        Lr_InfoDocumentoFinanCab.REFERENCIA_DOCUMENTO_ID := Ln_IdDocumento;
        Lr_InfoDocumentoFinanCab.FE_CREACION             := SYSDATE;
        Lr_InfoDocumentoFinanCab.USR_CREACION            := Pv_UsrCreacion;
        Lr_InfoDocumentoFinanCab.FE_EMISION              := SYSDATE;
        Lr_InfoDocumentoFinanCab.FE_AUTORIZACION         := NULL;
        Lr_InfoDocumentoFinanCab.NUMERO_FACTURA_SRI      := NULL;
        Lr_InfoDocumentoFinanCab.NUMERO_AUTORIZACION     := NULL;
        Lr_InfoDocumentoFinanCab.MES_CONSUMO             := NULL;
        Lr_InfoDocumentoFinanCab.ANIO_CONSUMO            := NULL;
        Lr_InfoDocumentoFinanCab.ESTADO_IMPRESION_FACT   := Pv_Estado;
        Lr_InfoDocumentoFinanCab.OBSERVACION             := Pv_Observacion;
        Lr_InfoDocumentoFinanCab.SUBTOTAL_CERO_IMPUESTO  := 0;
        Lr_InfoDocumentoFinanCab.ENTREGO_RETENCION_FTE   := NULL;
        Lr_InfoDocumentoFinanCab.ES_AUTOMATICA           := 'N';
        Lr_InfoDocumentoFinanCab.PRORRATEO               := 'N';
        Lr_InfoDocumentoFinanCab.REACTIVACION            := 'N';
        Lr_InfoDocumentoFinanCab.RECURRENTE              := 'N';
        Lr_InfoDocumentoFinanCab.COMISIONA               := 'N';
        Lr_InfoDocumentoFinanCab.SUBTOTAL_ICE            := 0;
        Lr_InfoDocumentoFinanCab.NUM_FACT_MIGRACION      := NULL;
        Lr_InfoDocumentoFinanCab.ES_ELECTRONICA          := 'S';
        Lr_InfoDocumentoFinanCab.NUMERO_AUTORIZACION     := NULL;
        Lr_InfoDocumentoFinanCab.FE_AUTORIZACION         := NULL;
        Lr_InfoDocumentoFinanCab.CONTABILIZADO           := NULL;
        --Inserta la cabecera de la NC
        FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinanCab, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        IF Lv_TipoCreacion  != 'DETALLE' THEN
        --Busca los detalles de la factura, para crear los detalles de la NC
        Lsrf_InfoDocumentoFinanDet := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_DET( NULL, Ln_IdDocumento);
        --
        LOOP
          --
          FETCH
            Lsrf_InfoDocumentoFinanDet
          INTO
            Lr_InfoDocumentoFinanDet;
          --
          EXIT
        WHEN Lsrf_InfoDocumentoFinanDet%NOTFOUND;
          --
          Lv_Prorratea := 'S';
          --
          Ln_IdDocDetalle                                        := Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE;
          Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE                := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
          Lr_InfoDocumentoFinanDet.DOCUMENTO_ID                  := Lr_InfoDocumentoFinanCab.ID_DOCUMENTO;
          Lr_InfoDocumentoFinanDet.PORCETANJE_DESCUENTO_FACPRO   := 0;
          Lr_InfoDocumentoFinanDet.VALOR_FACPRO_DETALLE          := 0;
          Lr_InfoDocumentoFinanDet.COSTO_FACPRO_DETALLE          := 0;
          Lr_InfoDocumentoFinanDet.OBSERVACIONES_FACTURA_DETALLE := NULL;
          Lr_InfoDocumentoFinanDet.FE_CREACION                   := SYSDATE;
          Lr_InfoDocumentoFinanDet.FE_ULT_MOD                    := NULL;
          Lr_InfoDocumentoFinanDet.USR_ULT_MOD                   := NULL;
          Lr_InfoDocumentoFinanDet.MOTIVO_ID                     := Pn_IdMotivo;
          Lr_InfoDocumentoFinanDet.PAGO_DET_ID                   := NULL;
          Lr_InfoDocumentoFinanDet.USR_CREACION                  := Pv_UsrCreacion;
          Lr_InfoDocumentoFinanDet.OFICINA_ID                    := Pn_IdOficina;
          Lr_InfoDocumentoFinanDet.EMPRESA_ID                    := Pn_IdEmpresa;
          --Pregunta si el registro es un producto
          IF Lr_InfoDocumentoFinanDet.PRODUCTO_ID IS NOT NULL OR Lr_InfoDocumentoFinanDet.PRODUCTO_ID  <> 0 THEN
            --
            IF C_GetNombreTecnico%ISOPEN THEN
              --
              CLOSE C_GetNombreTecnico;
              --
            END IF; --C_GetNombreTecnico
            --
            OPEN C_GetNombreTecnico(Lr_InfoDocumentoFinanDet.PRODUCTO_ID);
            --
            FETCH
              C_GetNombreTecnico
            INTO
              Lc_NombreTecnico;
            --
            CLOSE C_GetNombreTecnico;
            --
            IF UPPER(Lc_NombreTecnico.NOMBRE_TECNICO) = 'OTROS' THEN
              Lv_Prorratea                           := 'N';
            END IF;
            ---
          END IF; --Lr_InfoDocumentoFinanDet.PRODUCTO_ID IS NOT NULL OR Lr_InfoDocumentoFinanDet.PRODUCTO_ID <> 0
          --
          IF Lv_Prorratea  <> 'N' THEN
            --
            Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE := ROUND((Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Ln_ValorProrrateo), 2);
            Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE    := ROUND((Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE * Ln_ValorProrrateo) , 2);
            --
          END IF; --Lv_Prorratea
          --
          --Inserta un registro al detalle de la NC
          FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinanDet, Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN
            --
            RAISE Lex_Exception;
            --
          END IF;
          --Pregunta si el registro es un prodcuto
          IF Lr_InfoDocumentoFinanDet.PRODUCTO_ID IS NOT NULL OR Lr_InfoDocumentoFinanDet.PRODUCTO_ID  <> 0 THEN
            --
            Ln_SumaSubtotal  := Ln_SumaSubtotal + (Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Lr_InfoDocumentoFinanDet.CANTIDAD);
            Ln_SumaDescuento := Ln_SumaDescuento + Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE;
            --Busca los impuestos segun el registro de detalle
            Lsrf_InfoDocumentoFinanImp := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_IMP( NULL, Ln_IdDocDetalle);
            --
            LOOP
              --
              FETCH
                Lsrf_InfoDocumentoFinanImp
              INTO
                Lr_InfoDocumentoFinanImp;
              --
              EXIT
            WHEN Lsrf_InfoDocumentoFinanImp%NOTFOUND;
              --
              IF C_Getimpuesto%ISOPEN THEN
                CLOSE C_Getimpuesto;
              END IF;
              --
              OPEN C_Getimpuesto (Lr_InfoDocumentoFinanImp.IMPUESTO_ID);
              --
              FETCH
                C_Getimpuesto
              INTO
                Lc_Impuesto;
              --
              CLOSE C_Getimpuesto;
              --
              Ln_IdDocImp                               := Lr_InfoDocumentoFinanImp.ID_DOC_IMP;
              Lr_InfoDocumentoFinanImp.ID_DOC_IMP       := SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
              Lr_InfoDocumentoFinanImp.DETALLE_DOC_ID   := Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE;
              Lr_InfoDocumentoFinanImp.IMPUESTO_ID      := Lc_Impuesto.ID_IMPUESTO ;
              Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO   := ROUND(((((Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Lr_InfoDocumentoFinanDet.CANTIDAD) - Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE) * Lc_Impuesto.PORCENTAJE_IMPUESTO) / 100), 2);
              Lr_InfoDocumentoFinanImp.PORCENTAJE       := Lc_Impuesto.PORCENTAJE_IMPUESTO;
              Lr_InfoDocumentoFinanImp.FE_CREACION      := SYSDATE;
              Lr_InfoDocumentoFinanImp.FE_ULT_MOD       := NULL;
              Lr_InfoDocumentoFinanImp.USR_CREACION     := Pv_UsrCreacion;
              Lr_InfoDocumentoFinanImp.USR_ULT_MOD      := NULL;
              Ln_SumaImpuesto                           := Ln_SumaImpuesto + Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO;
              --
              FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinanImp, Lv_MsnError);
              --
              IF Lv_MsnError IS NOT NULL THEN
                --
                RAISE Lex_Exception;
                --
              END IF;
              --
            END LOOP; --Lsrf_InfoDocumentoFinanImp
            --
          ELSE -- IF PLAN
            --Entra cuando el registro del detalle sea un Plan
            --
            IF C_GetPlan%ISOPEN THEN
              CLOSE C_GetPlan;
            END IF;
            --
            OPEN C_GetPlan(Lr_InfoDocumentoFinanDet.PLAN_ID);
            --
            FETCH
              C_GetPlan
            INTO
              Lc_Plan;
            --
            CLOSE C_GetPlan;
            --
            Ln_SumaSubtotal := Ln_SumaSubtotal + (Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Lr_InfoDocumentoFinanDet.CANTIDAD);
            --
            Ln_SumaDescuento := Ln_SumaDescuento + Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE;
            --
            IF Lc_Plan.IVA = 'S' THEN
              --
              IF C_GetImpuestoPlan%ISOPEN THEN
                CLOSE C_GetImpuestoPlan;
              END IF;
              --
              OPEN C_GetImpuestoPlan('IVA');
              --
              FETCH
                C_GetImpuestoPlan
              INTO
                Lc_ImpuestoPlan;
              --
              CLOSE C_GetImpuestoPlan;
              --
              Lr_InfoDocumentoFinanImp.ID_DOC_IMP       := SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
              Lr_InfoDocumentoFinanImp.DETALLE_DOC_ID   := Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE;
              Lr_InfoDocumentoFinanImp.IMPUESTO_ID      := Lc_ImpuestoPlan.ID_IMPUESTO ;
              Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO   := ROUND(((((Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Lr_InfoDocumentoFinanDet.CANTIDAD)
                                                         - Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE) * Lc_ImpuestoPlan.PORCENTAJE_IMPUESTO) / 100), 2);
              Lr_InfoDocumentoFinanImp.PORCENTAJE       := Lc_ImpuestoPlan.PORCENTAJE_IMPUESTO;
              Lr_InfoDocumentoFinanImp.FE_CREACION      := SYSDATE;
              Lr_InfoDocumentoFinanImp.FE_ULT_MOD       := NULL;
              Lr_InfoDocumentoFinanImp.USR_CREACION     := Pv_UsrCreacion;
              Lr_InfoDocumentoFinanImp.USR_ULT_MOD      := NULL;
              Ln_SumaImpuesto                           := Ln_SumaImpuesto + Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO;
              --
              FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinanImp, Lv_MsnError);
              --
              IF Lv_MsnError IS NOT NULL THEN
                --
                RAISE Lex_Exception;
                --
              END IF;
              --
            END IF;
            --
          END IF;
          --
        END LOOP; --Lsrf_InfoDocumentoFinanDet

        ELSE  --   Lv_TipoCreacion -- 'DETALLE'

       --Busca las caracteristicas asociadas a la solicitud de NC del documento, para crear los detalles de la NC

	    FOR Lc_GetFacturasCaractNc IN C_CaractSolicitudNc( Pn_IdDocumento, 
		                                               Lv_EstadoActivo,
		                                               Lv_TipoSolicitud)
            --
            LOOP

              IF C_ProductoPlanIdNc%ISOPEN THEN    
                CLOSE C_ProductoPlanIdNc;
              END IF;

              OPEN C_ProductoPlanIdNc(Lv_ParamFactDetallada,Lv_EstadoActivo,Lc_GetFacturasCaractNc.CARACTERISTICA);
               FETCH C_ProductoPlanIdNc 
                 INTO Lc_ProductoPlanIdNc;
              CLOSE C_ProductoPlanIdNc;
              --
              --
              Lv_Prorratea := 'S';
              --
              
              Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE                := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
              Lr_InfoDocumentoFinanDet.DOCUMENTO_ID                  := Lr_InfoDocumentoFinanCab.ID_DOCUMENTO;
              Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE   := ROUND(NVL(TO_NUMBER(Lc_GetFacturasCaractNc.VALOR_CARACT),0), 2);
              Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE      := 0;
              Lr_InfoDocumentoFinanDet.PORCETANJE_DESCUENTO_FACPRO   := 0;
              Lr_InfoDocumentoFinanDet.VALOR_FACPRO_DETALLE          := 0;
              Lr_InfoDocumentoFinanDet.COSTO_FACPRO_DETALLE          := 0;
              Lr_InfoDocumentoFinanDet.OBSERVACIONES_FACTURA_DETALLE := NULL;
              Lr_InfoDocumentoFinanDet.FE_CREACION                   := SYSDATE;
              Lr_InfoDocumentoFinanDet.FE_ULT_MOD                    := NULL;
              Lr_InfoDocumentoFinanDet.USR_ULT_MOD                   := NULL;
              Lr_InfoDocumentoFinanDet.MOTIVO_ID                     := Pn_IdMotivo;
              Lr_InfoDocumentoFinanDet.PAGO_DET_ID                   := NULL;
              Lr_InfoDocumentoFinanDet.USR_CREACION                  := Pv_UsrCreacion;
              Lr_InfoDocumentoFinanDet.OFICINA_ID                    := Pn_IdOficina;
              Lr_InfoDocumentoFinanDet.EMPRESA_ID                    := Pn_IdEmpresa;
              Lr_InfoDocumentoFinanDet.CANTIDAD                      := 1;
              --Pregunta si el registro es un producto
              IF Lc_ProductoPlanIdNc.VALOR4 IS NOT NULL OR TO_NUMBER(Lc_ProductoPlanIdNc.VALOR4)  <> 0 THEN
                --
                IF C_GetNombreTecnico%ISOPEN THEN
                  --
                  CLOSE C_GetNombreTecnico;
                  --
                END IF; --C_GetNombreTecnico
                --
                OPEN C_GetNombreTecnico(TO_NUMBER(Lc_ProductoPlanIdNc.VALOR4));
                --
                FETCH
                  C_GetNombreTecnico
                INTO
                  Lc_NombreTecnico;
                --
                CLOSE C_GetNombreTecnico;
                --
                IF UPPER(Lc_NombreTecnico.NOMBRE_TECNICO) = 'OTROS' THEN
                  Lv_Prorratea                           := 'N';
                END IF;

                Lr_InfoDocumentoFinanDet.PRODUCTO_ID := TO_NUMBER(Lc_ProductoPlanIdNc.VALOR4); 
                ---
              END IF;

              IF Lc_ProductoPlanIdNc.VALOR5 IS NOT NULL AND TO_NUMBER(Lc_ProductoPlanIdNc.VALOR5) > 0 THEN
                Lr_InfoDocumentoFinanDet.PLAN_ID := TO_NUMBER(Lc_ProductoPlanIdNc.VALOR5);
              END IF; 
              --
              --Inserta un registro al detalle de la NC
              FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinanDet, Lv_MsnError);
              --
              IF Lv_MsnError IS NOT NULL THEN
                --
                RAISE Lex_Exception;
                --
              END IF;
              --Pregunta si el registro es un prodcuto
              IF Lc_ProductoPlanIdNc.VALOR4 IS NOT NULL OR TO_NUMBER(Lc_ProductoPlanIdNc.VALOR4)  <> 0 THEN
                --
                Ln_SumaSubtotal  := Ln_SumaSubtotal + (Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Lr_InfoDocumentoFinanDet.CANTIDAD);
                Ln_SumaDescuento := 0;
                --Busca el impuesto seg�n el producto

		IF C_GetImpuestoProducto%ISOPEN THEN
		  CLOSE C_GetImpuestoProducto;
		END IF;
	        --
		OPEN C_GetImpuestoProducto(TO_NUMBER(Lc_ProductoPlanIdNc.VALOR4));
		--
		FETCH
		  C_GetImpuestoProducto
		INTO
		  Lc_ImpuestoProducto;
                  --
                  --
                  IF C_Getimpuesto%ISOPEN THEN
                    CLOSE C_Getimpuesto;
                  END IF;
                  --
                  OPEN C_Getimpuesto (Lc_ImpuestoProducto.IMPUESTO_ID);
                  --
                  FETCH
                    C_Getimpuesto
                  INTO
                    Lc_Impuesto;
                  --
                  CLOSE C_Getimpuesto;
                  --
                 
                  Lr_InfoDocumentoFinanImp.ID_DOC_IMP       := SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
                  Lr_InfoDocumentoFinanImp.DETALLE_DOC_ID   := Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE;
                  Lr_InfoDocumentoFinanImp.IMPUESTO_ID      := Lc_Impuesto.ID_IMPUESTO ;
                  Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO   := ROUND(((((Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Lr_InfoDocumentoFinanDet.CANTIDAD) - Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE) * Lc_Impuesto.PORCENTAJE_IMPUESTO) / 100), 2);
                  Lr_InfoDocumentoFinanImp.PORCENTAJE       := Lc_Impuesto.PORCENTAJE_IMPUESTO;
                  Lr_InfoDocumentoFinanImp.FE_CREACION      := SYSDATE;
                  Lr_InfoDocumentoFinanImp.FE_ULT_MOD       := NULL;
                  Lr_InfoDocumentoFinanImp.USR_CREACION     := Pv_UsrCreacion;
                  Lr_InfoDocumentoFinanImp.USR_ULT_MOD      := NULL;
                  Ln_SumaImpuesto                           := Ln_SumaImpuesto + Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO;
                  --
                  FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinanImp, Lv_MsnError);
                  --
                  IF Lv_MsnError IS NOT NULL THEN
                    --
                    RAISE Lex_Exception;
                    --
                  END IF;
                  --

                --
              ELSE -- IF PLAN
                --Entra cuando el registro del detalle sea un Plan
                --

                IF C_GetPlan%ISOPEN THEN
                  CLOSE C_GetPlan;
                END IF;
                --
                OPEN C_GetPlan(TO_NUMBER(Lc_ProductoPlanIdNc.VALOR5));
                --
                FETCH
                  C_GetPlan
                INTO
                  Lc_Plan;
                --
                CLOSE C_GetPlan;
                --
                Ln_SumaSubtotal := Ln_SumaSubtotal + (Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Lr_InfoDocumentoFinanDet.CANTIDAD);
                --
                Ln_SumaDescuento := Ln_SumaDescuento + Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE;
                --
                IF Lc_Plan.IVA = 'S' THEN
                  --
                  IF C_GetImpuestoPlan%ISOPEN THEN
                    CLOSE C_GetImpuestoPlan;
                  END IF;
                  --
                  OPEN C_GetImpuestoPlan('IVA');
                  --
                  FETCH
                    C_GetImpuestoPlan
                  INTO
                    Lc_ImpuestoPlan;
                  --
                  CLOSE C_GetImpuestoPlan;
                  --
                  Lr_InfoDocumentoFinanImp.ID_DOC_IMP       := SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
                  Lr_InfoDocumentoFinanImp.DETALLE_DOC_ID   := Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE;
                  Lr_InfoDocumentoFinanImp.IMPUESTO_ID      := Lc_ImpuestoPlan.ID_IMPUESTO ;
                  Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO   := ROUND(((((Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE * Lr_InfoDocumentoFinanDet.CANTIDAD)
                                                             - Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE) * Lc_ImpuestoPlan.PORCENTAJE_IMPUESTO) / 100), 2);
                  Lr_InfoDocumentoFinanImp.PORCENTAJE       := Lc_ImpuestoPlan.PORCENTAJE_IMPUESTO;
                  Lr_InfoDocumentoFinanImp.FE_CREACION      := SYSDATE;
                  Lr_InfoDocumentoFinanImp.FE_ULT_MOD       := NULL;
                  Lr_InfoDocumentoFinanImp.USR_CREACION     := Pv_UsrCreacion;
                  Lr_InfoDocumentoFinanImp.USR_ULT_MOD      := NULL;
                  Ln_SumaImpuesto                           := Ln_SumaImpuesto + Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO;
                  --
                  FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinanImp, Lv_MsnError);
                  --
                  IF Lv_MsnError IS NOT NULL THEN
                    --
                    RAISE Lex_Exception;
                    --
                  END IF;
                  --
                END IF;
                --
              END IF;
              --
            END LOOP; 

        END IF; -- Lv_TipoCreacion
        --
        Lr_InfoDocumentoFinanCab.SUBTOTAL              := ROUND(Ln_SumaSubtotal, 2);
        Lr_InfoDocumentoFinanCab.SUBTOTAL_CON_IMPUESTO := ROUND(Ln_SumaImpuesto, 2);
        Lr_InfoDocumentoFinanCab.SUBTOTAL_DESCUENTO    := ROUND(Ln_SumaDescuento, 2);
        Lr_InfoDocumentoFinanCab.VALOR_TOTAL           := ROUND(((Ln_SumaSubtotal - Ln_SumaDescuento) + Ln_SumaImpuesto), 2);
        Pn_ValorTotal                                  := ROUND(((Ln_SumaSubtotal - Ln_SumaDescuento) + Ln_SumaImpuesto), 2);
        --Actualiza el los valores totales de la cabecera
        FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinanCab.ID_DOCUMENTO, Lr_InfoDocumentoFinanCab, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoFinanHst.DOCUMENTO_ID           := Lr_InfoDocumentoFinanCab.ID_DOCUMENTO;
        Lr_InfoDocumentoFinanHst.MOTIVO_ID              := Pn_IdMotivo;
        Lr_InfoDocumentoFinanHst.FE_CREACION            := SYSDATE;
        Lr_InfoDocumentoFinanHst.USR_CREACION           := Pv_UsrCreacion;
        Lr_InfoDocumentoFinanHst.ESTADO                 := Pv_Estado;
        Lr_InfoDocumentoFinanHst.OBSERVACION            := 'Se creo la nota de credito por proceso masivo a la factura ' || Lv_NumeroFacturaSri;
        --
        FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinanHst, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        Pv_ObservacionCreacion := 'La nota nota de credito fue creada con exito';
        Pbool_Done             := TRUE;
        --

        IF Lv_TipoCreacion = 'DETALLE'  AND Lc_CaracteristicaDocId.ID_DOCUMENTO_CARACTERISTICA IS NOT NULL THEN
        --
          -- Actaualizo el estado de la caracteristica del documento a Procesado
          DB_FINANCIERO.FNCK_TRANSACTION.P_UPDATE_INFO_DOCUMENTO_CARACT(Lr_InfoDocCaractNc,Lv_MsjErrorUpd);

          -- Actaualizo el estado de la solicitud de Nc a Finalizado.
          DB_COMERCIAL.COMEK_TRANSACTION.P_UPDATE_INFO_DETALLE_SOL(Lr_InfoDetSolicitudNc,Lv_MsjErrorUpd);

          COMMIT;

        END IF;
        --
        IF Lc_ValorParametro.VALOR3 IS NOT NULL AND Lc_ValorParametro.VALOR3 = 'telcos_reubica' THEN
            --
            --Actualiza descripci�n de la Nota de Credito de Reubicaci�n.
            Lr_InfoDocumentoFinanDet.OBSERVACIONES_FACTURA_DETALLE := 'Reubicaci�n';
            DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.UPDATE_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinanCab.ID_DOCUMENTO,
                                                                              Lr_InfoDocumentoFinanDet,
                                                                              Lv_MsnError);
            --
            IF C_GetSolicitudNcReub%ISOPEN THEN
                CLOSE C_GetSolicitudNcReub;
            END IF;

            OPEN C_GetSolicitudNcReub(Lv_DescCaractFact, Lv_TipoSolicitud, Lv_EstadoSolPendiente, Pn_IdDocumento);
                FETCH C_GetSolicitudNcReub INTO Lc_GetSolicitudNc;
            CLOSE C_GetSolicitudNcReub;

            IF Lc_GetSolicitudNc.ID_DETALLE_SOLICITUD IS NOT NULL THEN 
                Lr_InfoDetSolicitudNc.ID_DETALLE_SOLICITUD := Lc_GetSolicitudNc.ID_DETALLE_SOLICITUD;
                Lr_InfoDetSolicitudNc.ESTADO               := Lv_EstadoSolFinalizado;
                  
                -- Actualizo el estado de la solicitud de Nc a Finalizado.
                DB_COMERCIAL.COMEK_TRANSACTION.P_UPDATE_INFO_DETALLE_SOL(Lr_InfoDetSolicitudNc,Lv_MsjErrorUpd);

                --Clono las caracter�sticas de la INFO_DETALLE_SOL_CARACT a la Nota de Cr�dito.
                DB_FINANCIERO.FNCK_TRANSACTION.P_CLONAR_CARACT_NC_REUB(Lc_GetSolicitudNc.ID_DETALLE_SOLICITUD,Lr_InfoDocumentoFinanCab.ID_DOCUMENTO,Lv_MsjErrorUpd);
                
                Lr_InfoDetSolHistorial                        := NULL;
                Lr_InfoDetSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
                Lr_InfoDetSolHistorial.DETALLE_SOLICITUD_ID   := Lc_GetSolicitudNc.ID_DETALLE_SOLICITUD;
                Lr_InfoDetSolHistorial.ESTADO                 := 'Finalizada';
                Lr_InfoDetSolHistorial.OBSERVACION            := 'Se finaliza la solicitud';
                Lr_InfoDetSolHistorial.USR_CREACION           := Pv_UsrCreacion;
                Lr_InfoDetSolHistorial.IP_CREACION            := '127.0.0.1';
        
                DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Lr_InfoDetSolHistorial, Lv_MsjErrorUpd);
                
            END IF;

            COMMIT;
        END IF;
        --
      ELSE --ELSE Ln_ValorNcSimulado <= Ln_SaldoDisponible
        --
        Pv_ObservacionCreacion := 'No se pudo crear la nota de credito, el valor total de la nueva nota de credito ($'|| Ln_ValorNcSimulado
                                  || ') supera el saldo disponible ($' || Ln_SaldoDisponible || ')';
        --
      END IF; --Ln_ValorNcSimulado <= Ln_SaldoDisponible
      --
    ELSE --Lc_GetNotaCreditoNoActiva
      --Setea el comentario en Lv_EstadoDocumento segun el estado de la NC
      IF Lc_GetNotaCreditoNoActiva.ESTADO_IMPRESION_FACT = 'Pendiente' THEN
        --
        Lv_EstadoDocumento := 'solicite la aprobacion';
        --
      END IF;
      --
      IF Lc_GetNotaCreditoNoActiva.ESTADO_IMPRESION_FACT = 'Aprobada' THEN
        --
        Lv_EstadoDocumento := 'espere la autorizacion por parte del SRI';
        --
      END IF;
      --
      Pv_ObservacionCreacion := 'Esta factura tiene una nota de credito en estado ' || Lc_GetNotaCreditoNoActiva.ESTADO_IMPRESION_FACT
                                || ', por favor ' || Lv_EstadoDocumento || '  para proceder a crear una nueva Nota de Credito';
      --
    END IF; --Lc_GetNotaCreditoNoActiva
    --
  ELSE --ELSE Pn_IdDocumento
    --
    Pv_ObservacionCreacion := 'No se creo la NC ya que no se envio un ID de factura';
    --
  END IF; --Pn_IdDocumento
  --
EXCEPTION
WHEN Lex_Exception THEN
  --
  Pv_MessageError := Lv_MsnError || ' ' || Lv_TipoCreacion || ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  FNCK_TRANSACTION.INSERT_ERROR('P_CREA_NOTA_CREDITO', 'FNCK_CONSULTS.P_CREA_NOTA_CREDITO', Pv_MessageError);
  --
WHEN OTHERS THEN
--
Pv_MessageError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
--
END P_CREA_NOTA_CREDITO;
--
/**
* Documentacion para el procedimiento P_CREA_NOTA_CREDITO
* El procedimiento P_CREA_NOTA_CREDITO crea una nota de credito por un porcentaje de la factura, proporcional por dias o valor original
*
* @param  Pc_String          IN CLOB                                                Recibe el string con los ID Facturas
* @param  Pv_Delimitador     IN VARCHAR2                                            Recibe el delimitador
* @param  Pv_Observacion     IN INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE      Recibe la observacion
* @param  Pn_IdMotivo        IN ADMI_MOTIVO.ID_MOTIVO%TYPE                          Recibe el id motivo
* @param  Pv_UsrCreacion     IN INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE     Recibe el usuario que va ha crear las NC
* @param  Pv_Estado          IN INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE                Recibe el estado en el que se crearan las NC
* @param  Pv_TipoNotaCredito IN VARCHAR2                                            Recibe el tipo de NC, Valor %, Valor Proporcional, Valor Original
* @param  Pn_IdOficina       IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE                  Recibe el id oficina
* @param  Pn_IdEmpresa       IN INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE                 Recibe el id de la empresa
* @param  Pn_Porcentaje      IN NUMBER                                              Recibe el valor %
* @param  Pv_FechaInicio     IN VARCHAR2                                            Recibe la fecha de inicio
* @param  Pv_FechaFin        IN VARCHAR2                                            Recibe la fecha fin
* @param  Pv_MsnResult      OUT VARCHAR2                                            Retorna un mensaje de confirmacion habiendo terminado el proceso
* @param  Pv_MessageError   OUT VARCHAR2                                            Retorna un mensaje de error en caso de existir uno
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
*/
PROCEDURE P_CREA_NOTA_CREDITO_MASIVA(
    Pc_String          IN  CLOB,
    Pv_Delimitador     IN  VARCHAR2,
    Pv_Observacion     IN  INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
    Pn_IdMotivo        IN  ADMI_MOTIVO.ID_MOTIVO%TYPE,
    Pv_UsrCreacion     IN  INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
    Pv_Estado          IN  INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE,
    Pv_TipoNotaCredito IN  VARCHAR2,
    Pn_IdOficina       IN  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Pn_IdEmpresa       IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pn_Porcentaje      IN  NUMBER,
    Pv_FechaInicio     IN  VARCHAR2,
    Pv_FechaFin        IN  VARCHAR2,
    Pv_MsnResult       OUT VARCHAR2,
    Pv_MessageError    OUT VARCHAR2)
IS
  --
  Lrf_Results               SYS_REFCURSOR;
  Lrf_GetAdmiParamtrosDet   SYS_REFCURSOR;

  Lr_GetAdmiParamtrosDet    DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lr_InfoPunto              INFO_PUNTO%ROWTYPE;
  Lr_InfoDocumentoFinanCab  INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Lr_AdmiTipoDocFinanciero  ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
  Lr_AdmiMotivo             ADMI_MOTIVO%ROWTYPE;

  Lv_MsnError               VARCHAR2(2000);
  Lv_Correos                VARCHAR2(2000) := '';
  Lv_ObservacionTipoNc      VARCHAR2(100);
  Lv_Field                  VARCHAR2(200);
  Lv_Singular               VARCHAR2(50);
  Lv_Observacion            VARCHAR2(3000);

  Lv_MessageMail            CLOB;
  Lv_TableNotaCredito       CLOB;

  Ln_Counter                NUMBER := 0;
  Ln_CounterMail            NUMBER := 0;
  Ln_CounterNcCreadas       NUMBER := 0;
  Lbool_Done                BOOLEAN;
  Lbool_TipoNcExiste        BOOLEAN;
  Lc_GetAliasPlantilla      FNKG_TYPES.Lr_AliasPlantilla;
  Lex_Exception             EXCEPTION;
  Ln_ValorTotal             INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
  Ln_IdDocumentoNC          INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
  --
BEGIN
  --
  CASE --Pv_TipoNotaCredito
    WHEN TRIM(UPPER(Pv_TipoNotaCredito)) = 'VALOR_ORIGINAL' THEN
      --
      Lbool_TipoNcExiste := TRUE;
      --
    WHEN TRIM(UPPER(Pv_TipoNotaCredito)) = 'PORCENTAJE_SERVICIO' THEN
      --
      Lbool_TipoNcExiste := TRUE;
      --
    WHEN TRIM(UPPER(Pv_TipoNotaCredito)) = 'PROPORCIONAL_DIAS' THEN
      --
      Lbool_TipoNcExiste := TRUE;
      --
    ELSE
      --
      Lbool_TipoNcExiste := FALSE;
      --
    END CASE; --Pv_TipoNotaCredito
  --Valida que el tipo de nota de credito enviada a crear exista
  IF Lbool_TipoNcExiste = TRUE THEN
    --Convierte el string en un ref_cursor
    FNCK_CONSULTS.P_SPLIT_CLOB(Pc_String, Pv_Delimitador, Lrf_Results, Lv_MsnError);
    --Obtiene el record del motivo
    Lr_AdmiMotivo := FNCK_CONSULTS.F_GET_ADMI_MOTIVO(Pn_IdMotivo);
    --
    Lr_AdmiTipoDocFinanciero:= NULL;
    --Obtiene el id tipo documento ANTC
    Lr_AdmiTipoDocFinanciero := FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(NULL, 'NC');
    --
    DBMS_LOB.CREATETEMPORARY(Lv_TableNotaCredito, TRUE);
    --Itera el ref_cursor con los ID Facturas
    LOOP
      --
      FETCH
        Lrf_Results
      INTO
        Lv_Field;
      EXIT
    WHEN Lrf_Results%NOTFOUND;
      --
      Lr_InfoDocumentoFinanCab    := NULL;
      --Obtiene el record de la cabecera de la factura
      Lr_InfoDocumentoFinanCab    := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(TO_NUMBER(Lv_Field), NULL);
      --
      Lr_InfoPunto                := NULL;
      --Obtiene el record del punto
      Lr_InfoPunto                := FNCK_CONSULTS.F_GET_INFO_PUNTO(Lr_InfoDocumentoFinanCab.PUNTO_ID, NULL);
      --
      Lv_Observacion              := '';
      Ln_ValorTotal               := 0;
      Lbool_Done                  := FALSE;
      --Permite la creacion de la NC segun un tipo enviado como parametro
      CASE --Pv_TipoNotaCredito
      WHEN TRIM(UPPER(Pv_TipoNotaCredito)) = 'VALOR_ORIGINAL' THEN
        --
        Lv_ObservacionTipoNc := 'Valor Original';
        FNCK_CONSULTS.P_CREA_NOTA_CREDITO(TO_NUMBER(Lv_Field),
                                          Lr_AdmiTipoDocFinanciero.ID_TIPO_DOCUMENTO,
                                          TRIM( Pv_Observacion ),
                                          Pn_IdMotivo,
                                          TRIM(Pv_UsrCreacion),
                                          TRIM(Pv_Estado),
                                          'Y',
                                          'N',
                                          Pn_Porcentaje,
                                          'N',
                                          Pv_FechaInicio,
                                          Pv_FechaFin,
                                          Pn_IdOficina,
                                          Pn_IdEmpresa,
                                          Ln_ValorTotal,
                                          Ln_IdDocumentoNC,
                                          Lv_Observacion,
                                          Lbool_Done,
                                          Lv_MsnError);
        --
      WHEN TRIM(UPPER(Pv_TipoNotaCredito)) = 'PORCENTAJE_SERVICIO' THEN
        --
        Lv_ObservacionTipoNc              := 'Porcentaje del Servicio: ' || Pn_Porcentaje || '%';
        --
        FNCK_CONSULTS.P_CREA_NOTA_CREDITO(TO_NUMBER(Lv_Field),
                                          Lr_AdmiTipoDocFinanciero.ID_TIPO_DOCUMENTO,
                                          TRIM( Pv_Observacion ),
                                          Pn_IdMotivo,
                                          TRIM(Pv_UsrCreacion),
                                          TRIM(Pv_Estado),
                                          'N',
                                          'Y',
                                          Pn_Porcentaje ,
                                          'N',
                                          Pv_FechaInicio,
                                          Pv_FechaFin,
                                          Pn_IdOficina,
                                          Pn_IdEmpresa,
                                          Ln_ValorTotal,
                                          Ln_IdDocumentoNC,
                                          Lv_Observacion,
                                          Lbool_Done,
                                          Lv_MsnError);
        --
      WHEN TRIM(UPPER(Pv_TipoNotaCredito)) = 'PROPORCIONAL_DIAS' THEN
        --
        Lv_ObservacionTipoNc              := 'Proporcional por dias del ' || Pv_FechaInicio || ' al ' || Pv_FechaFin;
        --
        FNCK_CONSULTS.P_CREA_NOTA_CREDITO(TO_NUMBER(Lv_Field),
                                          Lr_AdmiTipoDocFinanciero.ID_TIPO_DOCUMENTO,
                                          TRIM( Pv_Observacion ),
                                          Pn_IdMotivo,
                                          TRIM(Pv_UsrCreacion),
                                          TRIM(Pv_Estado),
                                          'N',
                                          'N',
                                          Pn_Porcentaje,
                                          'Y',
                                          Pv_FechaInicio,
                                          Pv_FechaFin,
                                          Pn_IdOficina,
                                          Pn_IdEmpresa,
                                          Ln_ValorTotal,
                                          Ln_IdDocumentoNC,
                                          Lv_Observacion,
                                          Lbool_Done,
                                          Lv_MsnError);
        --
      END CASE; --Pv_TipoNotaCredito
      --
      IF Lv_MsnError IS NOT NULL THEN
        --
        FNCK_TRANSACTION.P_DELETE_DOCUMENTO_FINANCIERO(Ln_IdDocumentoNC, Lv_Observacion);
        --
        Lv_Observacion := 'No se creo la nota de credito ' || Lv_MsnError || ' ' || Lv_Observacion;
        --
        Ln_CounterNcCreadas := Ln_CounterNcCreadas - 1;
        --
      ELSE
        --
        Ln_CounterMail := Ln_CounterMail + 1;
        --
      END IF;
      --
      IF Lbool_Done = TRUE THEN
        --
        Ln_CounterNcCreadas := Ln_CounterNcCreadas + 1;
        --
      END IF; --Lbool_Done
      --
      Ln_Counter := Ln_Counter + 1;
      --Concatena las filas segun notas de credito creadas
      DBMS_LOB.APPEND(Lv_TableNotaCredito, '<tr><td> '
                      || Ln_Counter
                      || ' </td><td> '
                      || Lr_InfoPunto.LOGIN
                      || ' </td><td> '
                      || Lr_InfoDocumentoFinanCab.NUMERO_FACTURA_SRI
                      || ' </td><td  align="center"> $ '
                      || ROUND(Lr_InfoDocumentoFinanCab.VALOR_TOTAL, 2)
                      || ' </td><td>Pendiente hasta su aprobacion</td><td align="center" > $ '
                      || NVL(Ln_ValorTotal, 0) || ' </td>' || '<td> Pendiente </td> <td>'
                      || Lv_Observacion || ' </td></tr>');
      --
      IF Ln_CounterMail >= 100 THEN
        --
        COMMIT;
        --
        Ln_CounterMail          := 0;
        Lrf_GetAdmiParamtrosDet := NULL;
        --Verifica que pueda enviar correo
        Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('ENVIO_CORREO', 'Activo', 'Activo', 'CREAR_NC', 'SI', NULL, NULL);
        --
        FETCH
          Lrf_GetAdmiParamtrosDet
        INTO
          Lr_GetAdmiParamtrosDet;
        --
        CLOSE Lrf_GetAdmiParamtrosDet;
        --VERIFICA SI ESTA ACTIVADO PARA ENVIAR CORREO
        IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
          --
          IF Lr_GetAdmiParamtrosDet.VALOR4 = 'SI' THEN
            --
            Lv_Correos:= ';' || FNCK_CONSULTS.F_GET_INFO_PERSONA_FORMA_CONT('MAIL', TRIM(Pv_UsrCreacion));
            --
          END IF; --Lr_GetAdmiParamtrosDet.VALOR4
          --
          Lrf_GetAdmiParamtrosDet := NULL;
          --
          Lr_GetAdmiParamtrosDet  := NULL;
          --Obtiene los parametros para el envio de correo
          Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('ENVIO_CORREO', 'Activo', 'Activo', 'CREAR_NC_FROM_SUBJECT', NULL, NULL, NULL);
          --
          FETCH
            Lrf_GetAdmiParamtrosDet
          INTO
            Lr_GetAdmiParamtrosDet;
          --
          CLOSE Lrf_GetAdmiParamtrosDet;
          --
          Lc_GetAliasPlantilla := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('CREA_NC');
          --
          IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lc_GetAliasPlantilla.PLANTILLA           IS NOT NULL AND
             Lr_GetAdmiParamtrosDet.VALOR2            IS NOT NULL AND Lc_GetAliasPlantilla.ALIAS_CORREOS       IS NOT NULL AND
             Lr_GetAdmiParamtrosDet.VALOR3            IS NOT NULL THEN
            --
            Lv_MessageMail := REPLACE(TRIM(Lc_GetAliasPlantilla.PLANTILLA), '{{ strObservacion }}', TRIM(Pv_Observacion));
            Lv_MessageMail := REPLACE(TRIM(Lv_MessageMail), '{{ strMotivo }}', TRIM(Lr_AdmiMotivo.NOMBRE_MOTIVO));
            Lv_MessageMail := REPLACE(TRIM(Lv_MessageMail), '{{ strTipoNotaCredito }}', TRIM(Lv_ObservacionTipoNc));
            Lv_MessageMail := F_CLOB_REPLACE(Lv_MessageMail, '{{ ncCreadas | raw }}', Lv_TableNotaCredito);
            --Envia correo
            FNCK_CONSULTS.P_SEND_MAIL(Lr_GetAdmiParamtrosDet.VALOR2,
                                      Lc_GetAliasPlantilla.ALIAS_CORREOS || TRIM(Lv_Correos),
                                      Lr_GetAdmiParamtrosDet.VALOR3,
                                      SUBSTR(Lv_MessageMail, 1, 32767),
                                      'text/html; charset=UTF-8', Lv_MsnError);
            --
            IF Lv_MsnError IS NOT NULL THEN
              --
              Pv_MsnResult := 'No se pudo notificar por correo - ' || Lv_MsnError;
              --
            END IF;
            --
          END IF; --Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET ...
          --
          DBMS_LOB.FREETEMPORARY(Lv_TableNotaCredito);
          Lv_TableNotaCredito := '';
          DBMS_LOB.CREATETEMPORARY(Lv_TableNotaCredito, TRUE);
          --
        END IF; --Lrf_GetAdmiParamtrosDet
        --
      END IF; --Ln_CounterMail
      --
    END LOOP; -- Lrf_Results
    --Entra para hacer commit cuando el contador no ha llegado a 100
    IF Ln_CounterMail > 0 THEN
      --
      COMMIT;
      --
      Ln_CounterMail          := 0;
      Lrf_GetAdmiParamtrosDet := NULL;
      --Verifica que pueda enviar correo
      Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('ENVIO_CORREO', 'Activo', 'Activo', 'CREAR_NC', 'SI', NULL, NULL);
      --
      FETCH
        Lrf_GetAdmiParamtrosDet
      INTO
        Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --VERIFICA SI ESTA ACTIVADO PARA ENVIAR CORREO
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL THEN
        --
        IF Lr_GetAdmiParamtrosDet.VALOR4 = 'SI' THEN
          --
          Lv_Correos:= ';' || FNCK_CONSULTS.F_GET_INFO_PERSONA_FORMA_CONT('MAIL', TRIM(Pv_UsrCreacion));
          --
        END IF; --Lr_GetAdmiParamtrosDet.VALOR4
        --
        Lrf_GetAdmiParamtrosDet   := NULL;
        --
        Lr_GetAdmiParamtrosDet    := NULL;
        --Obtiene los parametros para el envio de correo
        Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET('ENVIO_CORREO', 'Activo', 'Activo', 'CREAR_NC_FROM_SUBJECT', NULL, NULL, NULL);
        --
        FETCH
          Lrf_GetAdmiParamtrosDet
        INTO
          Lr_GetAdmiParamtrosDet;
        --
        CLOSE Lrf_GetAdmiParamtrosDet;
        --Obtiene la plantilla y los alias anexados a la plantilla
        Lc_GetAliasPlantilla                       := FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('CREA_NC');
        --
        IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND Lc_GetAliasPlantilla.PLANTILLA IS NOT NULL AND
           Lr_GetAdmiParamtrosDet.VALOR2            IS NOT NULL AND Lc_GetAliasPlantilla.ALIAS_CORREOS IS NOT NULL AND
           Lr_GetAdmiParamtrosDet.VALOR3            IS NOT NULL THEN
          --Se reemplaza el numero de la factura
          Lv_MessageMail := REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{ strObservacion }}', Pv_Observacion);
          Lv_MessageMail := REPLACE(Lv_MessageMail, '{{ strMotivo }}', Lr_AdmiMotivo.NOMBRE_MOTIVO);
          Lv_MessageMail := REPLACE(TRIM(Lv_MessageMail), '{{ strTipoNotaCredito }}', TRIM(Lv_ObservacionTipoNc));
          Lv_MessageMail := F_CLOB_REPLACE(Lv_MessageMail, '{{ ncCreadas | raw }}', Lv_TableNotaCredito);
          --Envia el correo
          FNCK_CONSULTS.P_SEND_MAIL(Lr_GetAdmiParamtrosDet.VALOR2,
                                    Lc_GetAliasPlantilla.ALIAS_CORREOS || Lv_Correos,
                                    Lr_GetAdmiParamtrosDet.VALOR3,
                                    SUBSTR(Lv_MessageMail, 1, 32767),
                                    'text/html; charset=UTF-8', Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN
            --
            Pv_MsnResult := 'No se pudo notificar por correo - ' || Lv_MsnError;
            --
          END IF;
          --
        END IF; --Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET ...
        --
      END IF;--Lrf_GetAdmiParamtrosDet
      --
    END IF;  --Ln_CounterMail
    --
    IF Ln_CounterNcCreadas = 1 THEN
      --Setea en Pv_MsnResult un mensaje de confirmacion segun el numero de NC creadas
      Pv_MsnResult := 'Se creo una nota de credito ';
      --
    ELSE
      --
      Pv_MsnResult := 'Se crearon ' || Ln_CounterNcCreadas || ' Notas de credito ';
      --
    END IF;
    --
  ELSE --Lbool_TipoNcExiste
  --
    Pv_MsnResult := 'El tipo de nota de credito enviado a crear no existe.';
  --
  END IF; --Lbool_TipoNcExiste
  --
EXCEPTION
WHEN OTHERS THEN
  --Setea en Lv_Singular en caso de que se haya creado alguna NC
  IF Ln_CounterNcCreadas = 1 THEN
    --
    Lv_Singular := 'Se creo una nota de credito ';
    --
  ELSE
    --
    Lv_Singular := 'Se crearon ' || Ln_CounterNcCreadas || ' Notas de credito ';
    --
  END IF;
  --Realiza en commit para las NC que se crearon y se quedaron en memoria
  IF Ln_CounterNcCreadas > 0 THEN
    --
    COMMIT;
    --
    Pv_MessageError := Lv_Singular || ', pero existio un error. ERROR_STACK: ' ||
                       DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' ';
    --
  END IF;
  --
  ROLLBACK;
  --
  Pv_MessageError := Pv_MessageError || 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  --
END P_CREA_NOTA_CREDITO_MASIVA;
--
--

--
--
/*
 * Documentaci�n para FUNCION 'F_GET_INFORMACION_PUNTO'.
 * Funcion que obtiene informaci�n del punto del cliente
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 15-05-2016 - Se agrega que busque todos los telefonos de contacto de la persona en los puntos de estado 'Activo', 'Cancelado' o
 *                           'Trasladado'
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.2 02-06-2016 - Se agrega la columna de 'emailPtoPersona' que retorna todos los email de todos los puntos de una persona
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.3 24-06-2016 - Se corrige que no se tomen en cuenta los estados de las formas de contacto al consultar los tel�fonos o emails
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.4 26-07-2016 - Se cambia la forma de consultar la forma de pago, y se a�aden nuevas consultas que son: 'coordenadas', 'bancoTarjeta' y
 *                           'tipoCuentaBancoTarjeta'
 *
 * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
 * @version 1.5 07-07-2016
 * Para data de clientes INCORTE para efecto de contabilizar los d�as vencidos se tomara en cuenta la fecha de la �ltima factura
 * perteneciente al Punto.
 * Para data de clientes TRASLADADO con deuda, en fecha de concesi�n y a efectos de contabilizar los d�as de vencido se debe considerar la fecha
 * de la �ltima factura.
 * Para Data de Clientes ANULADO/ELIMINADO se amplia el reporte de buro incluyendo los clientes con punto en estado eliminado, en fecha de
 * concesi�n y a efectos de contabilizar los d�as de vencido se debe considerar la fecha de la �ltima factura
 * Para Data de clientes CANCELADOS con Deuda, en fecha de concesi�n y a efectos de contabilizar los d�as de vencido se debe considerar la
 * fecha de CANCELACION  del servicio, de no registrar informaci�n de la fecha de cancelaci�n, la fecha de la �ltima factura y/o nota de debito.
 *
 * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
 * @version 1.6 19-01-2017
 * Debido a los cambios en el valor a sumarizar en la fecha de concesi�n, se solicita que se cree un par�metro para el manejo de los d�as a sumar
 * a dicha fecha por estado:
 *   Cancelado
 *   Trasladado
 *   Anulado
 *   Eliminado
 *
 * @author Edgar Holguin <eholguin@telconet.ec>
 * @version 1.7 31-08-2017 Se corrige formato de fecha al obtener fecha de concesion para reporte de buro.
 * @author Edgar Holguin <eholguin@telconet.ec>
 * @version 1.8 12-09-2017 Se agrega excepcion para manejar una consulta adicional para obtener fecha de concesion.
 * @author Edgar Holguin <eholguin@telconet.ec>
 * @version 1.9 23-01-2018 Se estandariza formato de campo fecha de concesi�n presentado en el reporte.
 * @author Edgar Holgu�n <eholguin@telconet.ec>
 * @version 2.0 - 07-05-2018 - Se agrega condici�n para que consulta retorne un solo ciclo de facturaci�n.
 *
 * PARAMETROS:
 * @Param DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE          Fn_IdPersona     (id_persona del cliente)
 * @Param DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE                Fv_EstadoPunto   (estado del punto del cliente)
 * @Param DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Fv_EmpresaCod    (empresa del punto del cliente)
 * @Param VARCHAR2                                           Fv_Filtro        (es el filtro de lo que se desea buscar)
 * @return VARCHAR2                                          Fv_Resultado     (valor de la forma de contacto)
 */
FUNCTION F_GET_INFORMACION_PUNTO( Fn_IdPersona   DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                  Fv_EstadoPunto DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
                                  Fv_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Fv_Filtro      VARCHAR2 )
RETURN VARCHAR2
IS
--
    CURSOR C_CicloCliente(Pn_IdPersona NUMBER)
    IS
      SELECT AC.NOMBRE_CICLO,IPERC.FE_CREACION
        FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
             DB_COMERCIAL.ADMI_CARACTERISTICA ACAR,
             DB_FINANCIERO.ADMI_CICLO AC
        WHERE IPER.PERSONA_ID              =Pn_IdPersona
        AND IPER.ID_PERSONA_ROL            =IPERC.PERSONA_EMPRESA_ROL_ID
        AND IPERC.CARACTERISTICA_ID        =ACAR.ID_CARACTERISTICA
        AND ACAR.DESCRIPCION_CARACTERISTICA='CICLO_FACTURACION'
        AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0) = AC.ID_CICLO
        AND ACAR.ESTADO             = 'Activo'
        AND ROWNUM = 1
        order by IPERC.FE_CREACION desc;
    --
    Fv_Resultado            VARCHAR2(3000) := '';
    Fn_IdPunto              NUMBER;
    Fv_Observacion          CLOB := '';
    Fv_Codigo               VARCHAR2(100) := '';
    Fv_Estado               VARCHAR2(50) := '';
    Fv_FechaTmp             VARCHAR2(50) := '';
    Ln_NumDias              NUMBER;
    Ln_IdPersonaRol         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE;
    Lv_EstadoPersonaRol     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE;
    Lr_CicloCliente         C_CicloCliente%ROWTYPE;
    --
--
BEGIN
--
    --
    IF Fv_Filtro != 'fechaVencimiento' AND Fv_Filtro != 'fechaConcesion' THEN
    --
        --
        SELECT NVL(
                      (
                          SELECT MAX(ip.ID_PUNTO) AS ID_PUNTO
                          FROM DB_COMERCIAL.INFO_PUNTO ip
                          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                          ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                          JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                          ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                          JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                          ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                          JOIN DB_COMERCIAL.INFO_PERSONA ipe
                          ON ipe.ID_PERSONA = iper.PERSONA_ID
                          WHERE ipe.ID_PERSONA = Fn_IdPersona
                            AND ieg.COD_EMPRESA = Fv_EmpresaCod
                            AND ip.ESTADO = Fv_EstadoPunto
                      ), 0
                   ) INTO Fn_IdPunto FROM DUAL;
        --
    --
    ELSIF Fv_Filtro = 'fechaConcesion' AND Fv_EstadoPunto = 'In-Corte' THEN
    --
        --
        SELECT NVL(
                      (
                          SELECT MAX(iser.PUNTO_FACTURACION_ID) AS ID_PUNTO
                          FROM DB_COMERCIAL.INFO_PUNTO ip
                          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                          ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                          JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                          ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                          JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                          ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                          JOIN DB_COMERCIAL.INFO_PERSONA ipe
                          ON ipe.ID_PERSONA = iper.PERSONA_ID
                          JOIN DB_COMERCIAL.INFO_SERVICIO iser
                          ON iser.PUNTO_ID = ip.ID_PUNTO
                          WHERE ipe.ID_PERSONA = Fn_IdPersona
                            AND ieg.COD_EMPRESA = Fv_EmpresaCod
                            AND ip.ESTADO = Fv_EstadoPunto
                      ), 0
                   ) INTO Fn_IdPunto FROM DUAL;
        --
    --
    END IF;
    --
    --
    CASE
    --
        --
        WHEN Fv_Filtro = 'formaPago' OR Fv_Filtro = 'bancoTarjeta' OR Fv_Filtro = 'tipoCuentaBancoTarjeta' THEN
        --
            --
            SELECT iper.ID_PERSONA_ROL, iper.ESTADO
            INTO Ln_IdPersonaRol, Lv_EstadoPersonaRol
            FROM DB_COMERCIAL.INFO_PUNTO ip
            JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
            ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
            WHERE ip.ID_PUNTO = Fn_IdPunto;
            --
            --
            --
            IF Fv_Filtro = 'formaPago' THEN
            --
                --
                IF Lv_EstadoPersonaRol = 'Cancelado' THEN
                --
                    --
                    Fv_Resultado := FNKG_CARTERA_CLIENTES.F_CONTRATO_CANCELADO(Ln_IdPersonaRol);
                    --
                --
                ELSE
                --
                    --
                    Fv_Resultado := FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(Ln_IdPersonaRol, NULL);
                    --
                --
                END IF;
                --
            --
            ELSIF Fv_Filtro = 'bancoTarjeta' THEN
            --
                --
                Fv_Resultado := FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO('DESCRIPCION_BANCO', Ln_IdPersonaRol);
                --
            --
            ELSIF Fv_Filtro = 'tipoCuentaBancoTarjeta' THEN
            --
                --
                Fv_Resultado := FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO('DESCRIPCION_TIPO_CUENTA', Ln_IdPersonaRol);
                --
            --
            END IF;
            --
        --
        WHEN Fv_Filtro = 'coordenadas' THEN
        --
            --
            SELECT CASE WHEN TRIM(ip.LATITUD) IS NOT NULL THEN TO_CHAR(ip.LATITUD, '990.999999')||' '||TO_CHAR(ip.LONGITUD, '990.999999')
                   ELSE ''
                   END
            INTO Fv_Resultado
            FROM DB_COMERCIAL.INFO_PUNTO ip
            WHERE ip.ID_PUNTO = Fn_IdPunto;
            --
        --
        WHEN Fv_Filtro = 'retiroEquipo' THEN
        --
            --
            SELECT NVL(
                          (
                              SELECT CASE WHEN ids2.ESTADO = 'Finalizada' THEN 'RETIRADO'
                                     ELSE 'PENDIENTE'
                                     END
                              FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids2
                              WHERE ids2.ID_DETALLE_SOLICITUD = (
                                                                  SELECT MAX(ids.ID_DETALLE_SOLICITUD)
                                                                  FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
                                                                  JOIN DB_COMERCIAL.INFO_SERVICIO iser
                                                                  ON iser.ID_SERVICIO = ids.SERVICIO_ID
                                                                  JOIN DB_COMERCIAL.INFO_PUNTO ip
                                                                  ON iser.PUNTO_ID = ip.ID_PUNTO
                                                                  JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
                                                                  ON ats.ID_TIPO_SOLICITUD = ids.TIPO_SOLICITUD_ID
                                                                  WHERE ip.ID_PUNTO = Fn_IdPunto
                                                                    AND ats.DESCRIPCION_SOLICITUD = 'SOLICITUD RETIRO EQUIPO'
                                                                )
                          ),
                          'NO TIENE SOLICITUD DE RETIRO DE EQUIPO'
                      )
            INTO Fv_Resultado
            FROM DUAL;
            --

        --
        WHEN Fv_Filtro = 'cancelacionVoluntaria' THEN
        --
            --
            SELECT NVL(
                          (
                              SELECT CASE WHEN COUNT(CAB.ID_DOCUMENTO) > 0 THEN 'Si'
                                     ELSE 'No'
                                     END
                              FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  CAB                              
                              JOIN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON  ATDF.ID_TIPO_DOCUMENTO    = CAB.TIPO_DOCUMENTO_ID
                              JOIN  DB_COMERCIAL.INFO_PUNTO                      IPT  ON  IPT.ID_PUNTO              = CAB.PUNTO_ID
                              JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL        IPER ON  IPER.ID_PERSONA_ROL       = IPT.PERSONA_EMPRESA_ROL_ID
                              JOIN  DB_COMERCIAL.INFO_EMPRESA_ROL                IER  ON  IER.ID_EMPRESA_ROL        = IPER.EMPRESA_ROL_ID
                              JOIN  DB_COMERCIAL.INFO_EMPRESA_GRUPO              IEG  ON  IEG.COD_EMPRESA           = IER.EMPRESA_COD
                              JOIN  DB_COMERCIAL.INFO_PERSONA                    IPE  ON  IPE.ID_PERSONA            = IPER.PERSONA_ID
                              WHERE IPE.NUMERO_CONADIS IS NULL
                              AND   ATDF.CODIGO_TIPO_DOCUMENTO = 'FAC'
                              AND   CAB.USR_CREACION           = 'telcos_cancel_volun'
                              AND   CAB.ES_AUTOMATICA          = 'S'
                              AND   IPE.ID_PERSONA             = Fn_IdPersona
                              AND   IEG.COD_EMPRESA            = Fv_EmpresaCod            
                              AND   CAB.ESTADO_IMPRESION_FACT IN (
                                                                    SELECT APD.DESCRIPCION
                                                                    FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                                    JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                                                    ON     APD.PARAMETRO_ID       = APC.ID_PARAMETRO
                                                                    WHERE  APC.NOMBRE_PARAMETRO   = 'ESTADOS_FACTURAS_VALIDAS'
                                                                    AND    APC.ESTADO             = 'Activo'
                                                                    AND    APD.ESTADO             = 'Activo'
                                                                   )
                          ),
                          'No'
                      )
            INTO Fv_Resultado
            FROM DUAL;
            --
        --
        WHEN Fv_Filtro = 'direccion' THEN
        --
            --
            SELECT NVL(
                        (
                            SELECT ip.DIRECCION
                            FROM DB_COMERCIAL.INFO_PUNTO ip
                            WHERE ip.ID_PUNTO = Fn_IdPunto
                        ), ''
                      ) INTO Fv_Resultado FROM DUAL;
            --
            --
            Fv_Resultado := FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(Fv_Resultado);
            --
        --
        WHEN Fv_Filtro = 'numeroContrato' THEN
        --
            --
            SELECT NVL(
                        (
                            SELECT ic.NUMERO_CONTRATO
                            FROM DB_COMERCIAL.INFO_CONTRATO ic
                            WHERE ic.ID_CONTRATO = (
                                                      SELECT MAX(ic2.ID_CONTRATO)
                                                      FROM DB_COMERCIAL.INFO_CONTRATO ic2
                                                      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper2
                                                      ON ic2.PERSONA_EMPRESA_ROL_ID = iper2.ID_PERSONA_ROL
                                                      JOIN DB_COMERCIAL.INFO_PUNTO ip2
                                                      ON ip2.PERSONA_EMPRESA_ROL_ID = iper2.ID_PERSONA_ROL
                                                      WHERE ip2.ID_PUNTO = Fn_IdPunto
                                                        AND ic2.ESTADO = 'Activo'
                                                    )
                        ), ''
                      ) INTO Fv_Resultado FROM DUAL;
            --
            --
            IF Fv_Resultado IS NULL THEN
            --
                --
                SELECT NVL(
                            (
                                SELECT ic.NUMERO_CONTRATO
                                FROM DB_COMERCIAL.INFO_CONTRATO ic
                                WHERE ic.ID_CONTRATO = (
                                                          SELECT MAX(ic2.ID_CONTRATO)
                                                          FROM DB_COMERCIAL.INFO_CONTRATO ic2
                                                          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper2
                                                          ON ic2.PERSONA_EMPRESA_ROL_ID = iper2.ID_PERSONA_ROL
                                                          JOIN DB_COMERCIAL.INFO_PUNTO ip2
                                                          ON ip2.PERSONA_EMPRESA_ROL_ID = iper2.ID_PERSONA_ROL
                                                          WHERE ip2.ID_PUNTO = Fn_IdPunto
                                                            AND ic2.ESTADO = 'Cancelado'
                                                        )
                            ), ''
                          ) INTO Fv_Resultado FROM DUAL;
                --
            --
            END IF;
            --
            Fv_Resultado := FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(Fv_Resultado);
            --
        --
        WHEN Fv_Filtro = 'canton' THEN
        --
            --
            SELECT NVL(
                        (
                            SELECT ac.NOMBRE_CANTON
                            FROM DB_GENERAL.ADMI_CANTON ac
                            WHERE ac.ID_CANTON =
                              (
                                  SELECT ap.CANTON_ID
                                  FROM DB_GENERAL.ADMI_PARROQUIA ap
                                  WHERE ap.ID_PARROQUIA =
                                      (
                                            SELECT ase.PARROQUIA_ID
                                            FROM DB_GENERAL.ADMI_SECTOR ase
                                            WHERE ase.ID_SECTOR = (
                                                                      SELECT ip.SECTOR_ID
                                                                      FROM DB_COMERCIAL.INFO_PUNTO ip
                                                                      WHERE ip.ID_PUNTO = Fn_IdPunto
                                                                  )
                                       )
                               )
                        ), ''
                      ) INTO Fv_Resultado FROM DUAL;
            --
            --
            Fv_Resultado := FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(Fv_Resultado);
            --
        --
        WHEN Fv_Filtro = 'punto' THEN
        --
            --
            Fv_Resultado := ''||Fn_IdPunto||'';
            --
        --
        WHEN Fv_Filtro = 'telefono' THEN
        --
            --
            SELECT NVL(
                          (
                              SELECT ipfc.VALOR
                              FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO ipfc
                              JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc
                              ON afc.ID_FORMA_CONTACTO = ipfc.FORMA_CONTACTO_ID
                              WHERE ipfc.PUNTO_ID = Fn_IdPunto
                                AND ipfc.ESTADO = 'Activo'
                                AND afc.CODIGO IN ('MCLA', 'MMOV', 'MCNT', 'TMOV', 'TFIJ', 'TTRA')
                                AND ROWNUM = 1
                          ), ''
                      ) INTO Fv_Resultado FROM DUAL;
            --
            --
            --
            IF TRIM(Fv_Resultado) IS NULL THEN
            --
                --
                SELECT NVL(
                              (
                                  SELECT ipda.TELEFONO_ENVIO
                                  FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL ipda
                                  WHERE ipda.PUNTO_ID = Fn_IdPunto
                              ),
                              ''
                          ) INTO Fv_Resultado FROM DUAL;
                --
            --
            END IF;
            --
            --
            --
            IF TRIM(Fv_Resultado) IS NULL THEN
            --
                --
                SELECT NVL(
                              (
                                  SELECT ipfc.VALOR
                                  FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc
                                  JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc
                                  ON afc.ID_FORMA_CONTACTO = ipfc.FORMA_CONTACTO_ID
                                  WHERE ipfc.PERSONA_ID = Fn_IdPersona
                                    AND ipfc.ESTADO = 'Activo'
                                    AND afc.CODIGO IN ('MCLA', 'MMOV', 'MCNT', 'TMOV', 'TFIJ', 'TTRA')
                                    AND ROWNUM = 1
                              ), ''
                          ) INTO Fv_Resultado FROM DUAL;
                --
            --
            END IF;
            --
            --
            --
            Fv_Resultado := FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(Fv_Resultado);
            --
        --
        WHEN Fv_Filtro = 'email' THEN
        --
            SELECT  NVL(
                        FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(Fn_IdPunto, 'MAIL'),'') INTO Fv_Resultado
            FROM DUAL;
            --
            --
            IF TRIM(Fv_Resultado) IS NULL THEN
            --
                SELECT NVL(
                          (
                              SELECT ipfc.VALOR
                              FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO ipfc
                              JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc
                              ON afc.ID_FORMA_CONTACTO = ipfc.FORMA_CONTACTO_ID
                              WHERE ipfc.PUNTO_ID = Fn_IdPunto
                                AND ipfc.ESTADO = 'Activo'
                                AND afc.CODIGO IN ('MAIL')
                                AND ROWNUM = 1
                          ), ''
                      ) INTO Fv_Resultado FROM DUAL;
            --
            --
            END IF;
            --
            --
            --
            IF TRIM(Fv_Resultado) IS NULL THEN
            --
                --
                SELECT NVL(
                              (
                                  SELECT ipda.EMAIL_ENVIO
                                  FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL ipda
                                  WHERE ipda.PUNTO_ID = Fn_IdPunto
                              ),
                              ''
                          ) INTO Fv_Resultado FROM DUAL;
                --
            --
            END IF;
            --
            --
            --
            IF TRIM(Fv_Resultado) IS NULL THEN
            --
                --
                SELECT NVL(
                              (
                                  SELECT ipfc.VALOR
                                  FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc
                                  JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc
                                  ON afc.ID_FORMA_CONTACTO = ipfc.FORMA_CONTACTO_ID
                                  WHERE ipfc.PERSONA_ID = Fn_IdPersona
                                    AND ipfc.ESTADO = 'Activo'
                                    AND afc.CODIGO IN ('MAIL')
                                    AND ROWNUM = 1
                              ), ''
                          ) INTO Fv_Resultado FROM DUAL;
                --
            --
            END IF;
            --
        --
        WHEN Fv_Filtro = 'ciclo' THEN
            OPEN C_CicloCliente(Fn_IdPersona);
            FETCH C_CicloCliente INTO Lr_CicloCliente;
            CLOSE C_CicloCliente;

            Fv_Resultado:=Lr_CicloCliente.NOMBRE_CICLO;

        WHEN Fv_Filtro = 'fechaConcesion' OR Fv_Filtro = 'fechaVencimiento' THEN
        --
            --
            IF TRIM(Fv_EstadoPunto) = 'Cancelado' THEN
            --

                --
                Fv_Observacion := '%Se cancelo el Servicio%';
                Fv_Estado      := 'Cancel';
                --
                --
                --
                SELECT NVL(
                            (
                                SELECT TO_CHAR(ish.FE_CREACION, 'DD/MM/YYYY')
                                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ish
                                WHERE ish.ID_SERVICIO_HISTORIAL =
                                  (
                                    SELECT MAX(ish5.ID_SERVICIO_HISTORIAL)
                                    FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ish5
                                    JOIN DB_COMERCIAL.INFO_SERVICIO iser5
                                    ON iser5.ID_SERVICIO = ish5.SERVICIO_ID
                                    WHERE (ish5.OBSERVACION LIKE Fv_Observacion OR ish5.ESTADO = Fv_Estado)
                                      AND iser5.ID_SERVICIO =
                                        (
                                            SELECT MAX(iser2.ID_SERVICIO)
                                            FROM DB_COMERCIAL.INFO_SERVICIO iser2
                                            JOIN DB_COMERCIAL.INFO_PUNTO ip2
                                            ON iser2.PUNTO_ID = ip2.ID_PUNTO
                                            JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper2
                                            ON iper2.ID_PERSONA_ROL = ip2.PERSONA_EMPRESA_ROL_ID
                                            JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier2
                                            ON ier2.ID_EMPRESA_ROL = iper2.EMPRESA_ROL_ID
                                            JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg2
                                            ON ieg2.COD_EMPRESA = ier2.EMPRESA_COD
                                            JOIN DB_COMERCIAL.INFO_PERSONA ipe2
                                            ON ipe2.ID_PERSONA = iper2.PERSONA_ID
                                            WHERE ipe2.ID_PERSONA = Fn_IdPersona
                                              AND ieg2.COD_EMPRESA = Fv_EmpresaCod
                                              AND ip2.ESTADO = Fv_EstadoPunto
                                              AND iser2.PLAN_ID =
                                              (
                                                  SELECT MAX(ipc3.ID_PLAN)
                                                  FROM DB_COMERCIAL.INFO_SERVICIO iser3
                                                  JOIN DB_COMERCIAL.INFO_PLAN_CAB ipc3
                                                  ON iser3.PLAN_ID = ipc3.ID_PLAN
                                                  JOIN DB_COMERCIAL.INFO_PLAN_DET ipd3
                                                  ON ipd3.PLAN_ID = ipc3.ID_PLAN
                                                  JOIN DB_COMERCIAL.ADMI_PRODUCTO ap3
                                                  ON ap3.ID_PRODUCTO = ipd3.PRODUCTO_ID
                                                  JOIN DB_COMERCIAL.INFO_PUNTO ip3
                                                  ON ip3.ID_PUNTO = iser3.PUNTO_ID
                                                  WHERE ip3.ID_PUNTO IN (
                                                                            SELECT ip6.ID_PUNTO
                                                                            FROM DB_COMERCIAL.INFO_PUNTO ip6
                                                                            JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper6
                                                                            ON iper6.ID_PERSONA_ROL = ip6.PERSONA_EMPRESA_ROL_ID
                                                                            JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier6
                                                                            ON ier6.ID_EMPRESA_ROL = iper6.EMPRESA_ROL_ID
                                                                            JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg6
                                                                            ON ieg6.COD_EMPRESA = ier6.EMPRESA_COD
                                                                            JOIN DB_COMERCIAL.INFO_PERSONA ipe6
                                                                            ON ipe6.ID_PERSONA = iper6.PERSONA_ID
                                                                            WHERE ipe6.ID_PERSONA = Fn_IdPersona
                                                                              AND ieg6.COD_EMPRESA = Fv_EmpresaCod
                                                                              AND ip6.ESTADO = Fv_EstadoPunto
                                                                        )
                                                    AND ap3.NOMBRE_TECNICO = 'INTERNET'
                                                    AND iser3.PLAN_ID IS NOT NULL
                                               )
                                              OR iser2.PRODUCTO_ID =
                                                (
                                                      SELECT MAX(ap4.ID_PRODUCTO)
                                                      FROM DB_COMERCIAL.INFO_SERVICIO iser4
                                                      JOIN DB_COMERCIAL.ADMI_PRODUCTO ap4
                                                      ON ap4.ID_PRODUCTO = iser4.PRODUCTO_ID
                                                      JOIN DB_COMERCIAL.INFO_PUNTO ip4
                                                      ON ip4.ID_PUNTO = iser4.PUNTO_ID
                                                      WHERE ip4.ID_PUNTO IN (
                                                                                SELECT ip7.ID_PUNTO
                                                                                FROM DB_COMERCIAL.INFO_PUNTO ip7
                                                                                JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper7
                                                                                ON iper7.ID_PERSONA_ROL = ip7.PERSONA_EMPRESA_ROL_ID
                                                                                JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier7
                                                                                ON ier7.ID_EMPRESA_ROL = iper7.EMPRESA_ROL_ID
                                                                                JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg7
                                                                                ON ieg7.COD_EMPRESA = ier7.EMPRESA_COD
                                                                                JOIN DB_COMERCIAL.INFO_PERSONA ipe7
                                                                                ON ipe7.ID_PERSONA = iper7.PERSONA_ID
                                                                                WHERE ipe7.ID_PERSONA = Fn_IdPersona
                                                                                  AND ieg7.COD_EMPRESA = Fv_EmpresaCod
                                                                                  AND ip7.ESTADO = Fv_EstadoPunto
                                                                            )
                                                        AND ap4.NOMBRE_TECNICO = 'INTERNET'
                                                        AND iser4.PRODUCTO_ID IS NOT NULL
                                                  )
                                         )
                                 )
                            ), ''
                        ) INTO Fv_FechaTmp FROM DUAL;
                --
                --
                IF Fv_FechaTmp IS NULL THEN
                 --
                     SELECT NVL(
                              (
                                  SELECT TO_CHAR(idfc.FE_EMISION, 'DD/MM/YYYY')
                                  FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc
                                  WHERE idfc.ID_DOCUMENTO =
                                    (
                                        SELECT MAX(idfc2.ID_DOCUMENTO)
                                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc2
                                        WHERE idfc2.PUNTO_ID IN (
                                                                    SELECT ip.ID_PUNTO
                                                                    FROM DB_COMERCIAL.INFO_PUNTO ip
                                                                    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                                                    ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                                                                    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                                                    ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                                                    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                                                                    ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                                                                    JOIN DB_COMERCIAL.INFO_PERSONA ipe
                                                                    ON ipe.ID_PERSONA = iper.PERSONA_ID
                                                                    WHERE ipe.ID_PERSONA = Fn_IdPersona
                                                                      AND ieg.COD_EMPRESA = Fv_EmpresaCod
                                                                      AND ip.ESTADO = Fv_EstadoPunto
                                                                )
                                          AND idfc2.ESTADO_IMPRESION_FACT IN ('Activo','Cerrado')
                                          AND idfc2.TIPO_DOCUMENTO_ID IN (9)
                                    )
                              ), ''
                          ) INTO Fv_FechaTmp FROM DUAL;
                         --
                --
                END IF;
            --
            END IF;
            --
            --
            --
            IF Fv_FechaTmp IS NULL THEN
            --
                --
                SELECT NVL(
                              (
                                  SELECT TO_CHAR(idfc.FE_EMISION, 'DD/MM/YYYY')
                                  FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc
                                  WHERE idfc.ID_DOCUMENTO =
                                    (
                                        SELECT MAX(idfc2.ID_DOCUMENTO)
                                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc2
                                        WHERE idfc2.PUNTO_ID IN (
                                                                    SELECT ip.ID_PUNTO
                                                                    FROM DB_COMERCIAL.INFO_PUNTO ip
                                                                    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                                                    ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                                                                    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                                                    ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                                                    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                                                                    ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                                                                    JOIN DB_COMERCIAL.INFO_PERSONA ipe
                                                                    ON ipe.ID_PERSONA = iper.PERSONA_ID
                                                                    WHERE ipe.ID_PERSONA = Fn_IdPersona
                                                                      AND ieg.COD_EMPRESA = Fv_EmpresaCod
                                                                      AND ip.ESTADO = Fv_EstadoPunto
                                                                )
                                          AND idfc2.ESTADO_IMPRESION_FACT = 'Activo'
                                          AND idfc2.TIPO_DOCUMENTO_ID IN (1, 5)
                                    )
                              ), ''
                          ) INTO Fv_FechaTmp FROM DUAL;
                --
                --
                IF TRIM(Fv_FechaTmp) IS NULL THEN
                --
                    --
                    SELECT NVL(
                                  (
                                      SELECT TO_CHAR(idfc.FE_EMISION, 'DD/MM/YYYY')
                                      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc
                                      WHERE idfc.ID_DOCUMENTO =
                                        (
                                              SELECT MAX(idfc2.ID_DOCUMENTO)
                                              FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc2
                                              WHERE idfc2.PUNTO_ID IN (
                                                                          SELECT ip.ID_PUNTO
                                                                          FROM DB_COMERCIAL.INFO_PUNTO ip
                                                                          JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                                                          ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                                                                          JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                                                          ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                                                          JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                                                                          ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                                                                          JOIN DB_COMERCIAL.INFO_PERSONA ipe
                                                                          ON ipe.ID_PERSONA = iper.PERSONA_ID
                                                                          WHERE ipe.ID_PERSONA = Fn_IdPersona
                                                                            AND ieg.COD_EMPRESA = Fv_EmpresaCod
                                                                            AND ip.ESTADO = Fv_EstadoPunto
                                                                      )
                                                AND idfc2.ESTADO_IMPRESION_FACT = 'Cerrado'
                                                AND idfc2.TIPO_DOCUMENTO_ID IN (1, 5)
                                          )
                                  ), ''
                              ) INTO Fv_FechaTmp FROM DUAL;
                    --
                --
                END IF;
                --
                --
                IF ( TRIM(Fv_EstadoPunto) = 'Cancelado' OR TRIM(Fv_EstadoPunto) = 'Trasladado'
                     OR TRIM(Fv_EstadoPunto) = 'Anulado' OR TRIM(Fv_EstadoPunto) = 'Eliminado' ) AND Fv_FechaTmp IS NOT NULL THEN
                --
                    --Obtengo el Parametro del Numero de dias a sumar a la Fecha de Concesion,
                    --si no existe parametro se manda cero como numero de dias a sumarse
                    SELECT NVL(
                               (SELECT PD.VALOR1
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                JOIN DB_GENERAL.ADMI_PARAMETRO_DET PD ON PC.ID_PARAMETRO=PD.PARAMETRO_ID
                                WHERE NOMBRE_PARAMETRO = 'REPORTE_BURO_DIAS_A_SUMAR_FECHACONCESION'
                                AND PD.DESCRIPCION = Fv_EstadoPunto), 0
                              ) INTO Ln_NumDias FROM DUAL;


                    BEGIN
                      SELECT NVL( TO_CHAR((SELECT TO_DATE(SUBSTR(Fv_FechaTmp,0,10),'YYYY-MM-DD') + Ln_NumDias FROM DUAL),'DD/MM/YYYY'), '' ) INTO Fv_FechaTmp FROM DUAL;
                    EXCEPTION WHEN OTHERS THEN
                      SELECT NVL( TO_CHAR((SELECT TO_DATE(Fv_FechaTmp,'dd-mm-yyyy') + Ln_NumDias FROM DUAL),'DD/MM/YYYY'), '' ) INTO Fv_FechaTmp FROM DUAL;
                    END;
                --
                END IF;
                --
            --
            END IF;
            --
            --
            --
            Fv_Resultado := ''||Fv_FechaTmp;
            --
            --
            --
    --
    END CASE;
    --
    --
    RETURN Fv_Resultado;
    --
--
END;
--
--
/*
 * Documentaci�n para FUNCION 'F_GET_NOMBRE_APELLIDOS_PERSONA'.
 * Funcion que obtiene informaci�n del nombre del cliente
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 09-06-2016 - Se corrige para que tome Razon Social cuando sea 'RUC' el tipo de identificacion y para 'CED' y 'PAS' tome los nombres
 *                           y apellidos de la persona.
 *
 * PARAMETROS:
 * @Param DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE          Fn_IdPersona     (id_persona del cliente)
 * @return VARCHAR2                                          Fv_Resultado     (valor de la forma de contacto)
 */
FUNCTION F_GET_NOMBRE_APELLIDOS_PERSONA( Fn_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE )
RETURN VARCHAR2
IS
--
    --
    Fv_Resultado VARCHAR2(300) := '';
    --
--
BEGIN
--
    --
    SELECT NVL(
                  (
                      SELECT CASE
                                WHEN ipe.TIPO_IDENTIFICACION = 'CED' THEN
                                    NVL( TRIM((CONCAT(ipe.NOMBRES, CONCAT(' ', ipe.APELLIDOS)))), TRIM(ipe.RAZON_SOCIAL) )
                                WHEN ipe.TIPO_IDENTIFICACION = 'RUC' THEN
                                    NVL( TRIM(ipe.RAZON_SOCIAL), TRIM((CONCAT(ipe.NOMBRES, CONCAT(' ', ipe.APELLIDOS)))) )
                                ELSE
                                    NVL( TRIM((CONCAT(ipe.NOMBRES, CONCAT(' ', ipe.APELLIDOS)))), TRIM(ipe.RAZON_SOCIAL) )
                             END AS NOMBRE_CLIENTE
                      FROM DB_COMERCIAL.INFO_PERSONA ipe
                      WHERE ipe.ID_PERSONA = Fn_IdPersona
                  ), ''
               ) INTO Fv_Resultado FROM DUAL;
    --
    RETURN FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(Fv_Resultado);
    --
--
END;
--
--
/*
 * Documentaci�n para PROCEDURE 'P_GET_REPORTE_BURO'.
 * PROCEDURE que obtiene la informacion necesaria para el reporte de buro
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 15-05-2016 - Se agrega que busque todos los telefonos de contacto de la persona en los puntos de estado 'Activo', 'Cancelado' o
 *                           'Trasladado'
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.2 02-09-2016 - Se agregan los puntos en estado 'In-Corte'
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.3 26-07-2016 - Se agregan nuevos campos que corresponden a: Coordenadas del punto, Direcci�n Cliente, Banco y Tipo de cuenta del cu�l
 *                           se le debita al cliente en caso de que su forma de pago sea diferente de 'EFECTIVO', y finalmente se agrega el estado de
 *                           la solicitud de Retiro de Equipos
 *
 * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
 * @version 1.4 06-12-2016 - Se solicitan Validaciones en la generacion del Reporte de Buro:
 * ACTIVOS: solicito que dentro del reporte, para los clientes activos, se tenga las siguientes consideraciones.
 * 1.- Punto activo (no debe tener adicional un punto cancelado, trasladado o in-corte con deuda)
 * 2.- Ser cliente por un periodo mayor a seis meses.
 * 3.- NO registrar suspensi�n (Masivo o Manual) de servicio en los �ltimos seis meses.
 *
 * @author Jorge Guerrero <jguerrerop@telconet.ec>
 * @version 1.5 01-12-2017 - Se agrega la columna del Ciclo de Facturaci�n
 *
 * @author Edgar Holgu�n <eholguin@telconet.ec>
 * @version 1.6 02-09-2019 - Se agrega columna CANCELACION VOLUNTARIA para indicar si cliente factur� por dicho rubro.
 * PARAMETROS:
 * @Param DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Pn_EmpresaCod            (empresa del punto del cliente)
 * @Param VARCHAR2                                           Pv_TipoClientes          (tipo de clientes)
 * @Param VARCHAR2                                           Pv_ValorClientesBuenos   (valor de clientes buenos)
 * @Param VARCHAR2                                           Pv_ValorClientesMalos    (valor de clientes malos)
 * @return SYS_REFCURSOR                                     C_Clientes               (cursor con los clientes del reporte)
 */
PROCEDURE P_GET_REPORTE_BURO(
    Pv_EmpresaCod          IN  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
    Pv_TipoClientes        IN  VARCHAR2,
    Pv_ValorClientesBuenos IN  VARCHAR2,
    Pv_ValorClientesMalos  IN  VARCHAR2,
    C_Clientes             OUT SYS_REFCURSOR )
AS
--
    --
    Pv_Query VARCHAR2(9000) := '';
    Pv_From  VARCHAR2(4000) := '';
--
BEGIN
--
    --
    IF Pv_TipoClientes = 'ClieBuenosActivos' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb12
                    WHERE
                         FNCK_CONSULTS.F_GET_DIFERENCIA_MESES_FECHAS(vcrb12.ID_PERSONA,'||Pv_EmpresaCod||','||q'['PorActivacion']'||') >= 6
                         AND
                         (
                           FNCK_CONSULTS.F_GET_DIFERENCIA_MESES_FECHAS(vcrb12.ID_PERSONA,'||Pv_EmpresaCod||','||q'['PorUltCorte']'||') = 0
                           OR FNCK_CONSULTS.F_GET_DIFERENCIA_MESES_FECHAS(vcrb12.ID_PERSONA,'||Pv_EmpresaCod||','||q'['PorUltCorte']'||') >=6
                         )
                         AND vcrb12.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) = 1
                                              )
                      AND vcrb12.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb12.SALDO > '||Pv_ValorClientesBuenos
                      ||q'[ AND vcrb12.ESTADO = 'Activo' ]'||'
                      AND vcrb12.ID_PERSONA NOT IN (
                                                      SELECT vcrb16.ID_PERSONA
                                                      FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb16
                                                      WHERE vcrb16.ID_PERSONA IN (
                                                                                    SELECT vcrb2.ID_PERSONA
                                                                                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                                                    WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                                                    GROUP BY vcrb2.ID_PERSONA
                                                                                    HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                                                  )
                                                        AND vcrb16.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                        AND vcrb16.SALDO > '||Pv_ValorClientesMalos
                                                        ||q'[ AND vcrb16.ESTADO IN ('Cancelado', 'Trasladado', 'In-Corte','Anulado','Eliminado') ]'||'
                                                    )';
        --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosCancelados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb14
                    WHERE vcrb14.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) = 1
                                              )
                      AND vcrb14.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb14.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb14.ESTADO = 'Cancelado' ]';
        --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosTrasladados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb14
                    WHERE vcrb14.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) = 1
                                              )
                      AND vcrb14.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb14.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb14.ESTADO = 'Trasladado' ]';
        --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosEliminados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb14
                    WHERE vcrb14.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) = 1
                                              )
                      AND vcrb14.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb14.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb14.ESTADO = 'Eliminado' ]';
    --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosAnulados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb14
                    WHERE vcrb14.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) = 1
                                              )
                      AND vcrb14.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb14.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb14.ESTADO = 'Anulado' ]';
    --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosCortados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb14
                    WHERE vcrb14.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) = 1
                                              )
                      AND vcrb14.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb14.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb14.ESTADO = 'In-Corte' ]';
        --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosPrioridadCancelados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb13
                    WHERE vcrb13.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                )
                      AND vcrb13.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb13.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb13.ESTADO = 'Cancelado' ]';
        --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosPrioridadTrasladados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb15
                    WHERE vcrb15.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                )
                      AND vcrb15.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb15.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb15.ESTADO = 'Trasladado' ]'||'
                      AND vcrb15.ID_PERSONA NOT IN (
                                                      SELECT vcrb16.ID_PERSONA
                                                      FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb16
                                                      WHERE vcrb16.ID_PERSONA IN (
                                                                                    SELECT vcrb2.ID_PERSONA
                                                                                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                                                    WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                                                    GROUP BY vcrb2.ID_PERSONA
                                                                                    HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                                                  )
                                                        AND vcrb16.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                        AND vcrb16.SALDO > '||Pv_ValorClientesMalos
                                                        ||q'[ AND vcrb16.ESTADO = 'Cancelado' ]'||'
                                                    )';
       --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosPrioridadEliminados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb15
                    WHERE vcrb15.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                )
                      AND vcrb15.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb15.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb15.ESTADO = 'Eliminado' ]'||'
                      AND vcrb15.ID_PERSONA NOT IN (
                                                      SELECT vcrb16.ID_PERSONA
                                                      FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb16
                                                      WHERE vcrb16.ID_PERSONA IN (
                                                                                    SELECT vcrb2.ID_PERSONA
                                                                                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                                                    WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                                                    GROUP BY vcrb2.ID_PERSONA
                                                                                    HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                                                  )
                                                        AND vcrb16.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                        AND vcrb16.SALDO > '||Pv_ValorClientesMalos
                                                        ||q'[ AND vcrb16.ESTADO IN ('Cancelado', 'Trasladado') ]'||'
                                                    )';
        --
    --
    ELSIF Pv_TipoClientes = 'ClieMalosPrioridadAnulados' THEN
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb15
                    WHERE vcrb15.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                )
                      AND vcrb15.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb15.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb15.ESTADO = 'Anulado' ]'||'
                      AND vcrb15.ID_PERSONA NOT IN (
                                                      SELECT vcrb16.ID_PERSONA
                                                      FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb16
                                                      WHERE vcrb16.ID_PERSONA IN (
                                                                                    SELECT vcrb2.ID_PERSONA
                                                                                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                                                    WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                                                    GROUP BY vcrb2.ID_PERSONA
                                                                                    HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                                                  )
                                                        AND vcrb16.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                        AND vcrb16.SALDO > '||Pv_ValorClientesMalos
                                                        ||q'[ AND vcrb16.ESTADO IN ('Cancelado', 'Trasladado', 'Eliminado') ]'||'
                                                    )';
    --
    ELSE
    --
        --
        Pv_From := 'SELECT *
                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb15
                    WHERE vcrb15.ID_PERSONA IN (
                                                  SELECT vcrb2.ID_PERSONA
                                                  FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                  WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                  GROUP BY vcrb2.ID_PERSONA
                                                  HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                )
                      AND vcrb15.EMPRESA_COD = '||Pv_EmpresaCod||'
                      AND vcrb15.SALDO > '||Pv_ValorClientesMalos
                      ||q'[ AND vcrb15.ESTADO = 'In-Corte' ]'||'
                      AND vcrb15.ID_PERSONA NOT IN (
                                                      SELECT vcrb16.ID_PERSONA
                                                      FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb16
                                                      WHERE vcrb16.ID_PERSONA IN (
                                                                                    SELECT vcrb2.ID_PERSONA
                                                                                    FROM DB_FINANCIERO.VISTA_CLIENTES_REPORTE_BURO vcrb2
                                                                                    WHERE vcrb2.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                                                    GROUP BY vcrb2.ID_PERSONA
                                                                                    HAVING COUNT(vcrb2.ID_PERSONA) >= 2
                                                                                  )
                                                        AND vcrb16.EMPRESA_COD = '||Pv_EmpresaCod||'
                                                        AND vcrb16.SALDO > '||Pv_ValorClientesMalos
                                                        ||q'[ AND vcrb16.ESTADO IN ('Cancelado', 'Trasladado', 'Eliminado','Anulado') ]'||'
                                                    )';
        --
    --
    END IF;
    --
    --SE CONSTRUYE QUERY
    --
    Pv_Query:= 'SELECT TRIM(cb.ID_PERSONA) AS ID_PERSONA, '
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'punto')) AS ID_PUNTO, ]'
     ||'TRIM(cb.TIPO_IDENTIFICACION) AS TIPO_IDENTIFICACION,
     TRIM(cb.TIPO_DOCUMENTO) TIPO_DOCUMENTO,
     TRIM(cb.IDENTIFICACION_CLIENTE) AS IDENTIFICACION_CLIENTE,
     TRIM(cb.NOMBRE_CLIENTE) AS NOMBRE_CLIENTE, '
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'direccion')) AS DIRECCION_PUNTO, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'canton')) AS CANTON_PUNTO, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'telefono')) AS TELEFONO_CLIENTE, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFO_EMPRESA(]'||Pv_EmpresaCod||q'[)) AS ACREEDOR, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'fechaConcesion')) AS FECHA_CONCESION, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'fechaVencimiento')) AS FECHA_VENCIMIENTO, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'email')) AS EMAIL_CLIENTE, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'numeroContrato')) AS NUMERO_CONTRATO, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'coordenadas')) AS COORDENADAS, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'formaPago')) AS FORMA_PAGO, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'bancoTarjeta')) AS BANCO_TARJETA, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'tipoCuentaBancoTarjeta')) AS TIPO_CUENTA, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'retiroEquipo')) AS RETIRO_EQUIPO, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'ciclo')) AS CICLO, ]'
     ||q'[ TRIM(FNCK_CONSULTS.F_GET_INFORMACION_PUNTO(cb.ID_PERSONA, cb.ESTADO, ]'||Pv_EmpresaCod||q'[, 'cancelacionVoluntaria')) AS CANCEL_VOLUNTARIA, ]'
     ||'TRIM(cb.SALDO) AS SALDO,
     TRIM(cb.ESTADO) AS ESTADO,
     TRIM(cb.EMPRESA_COD) AS EMPRESA_COD,
     (
        SELECT ipe.DIRECCION
        FROM DB_COMERCIAL.INFO_PERSONA ipe
        WHERE ipe.ID_PERSONA = cb.ID_PERSONA
     ) AS DIRECCION_CLIENTE
     FROM ('||Pv_From||') cb
     ORDER BY cb.ID_PERSONA, cb.ESTADO';
    --
    --
    --SE EJECTUA QUERY y SE LO GUARDA EN CURSOR c_clientes
    --
    OPEN C_Clientes FOR Pv_Query;
    --
--
END P_GET_REPORTE_BURO;
--
--
/*
 * Documentaci�n para FUNCION 'F_REEMPLAZAR_CARACTERES_ESP'.
 * Funcion que reemplaza caracteres especiales no permitidos de una cadena
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 *
 * PARAMETROS:
 * @return VARCHAR2 Fv_Cadena     (Contiene la cadena que se va a reemplazar caracteres especiales)
 * @return VARCHAR2 Fv_Resultado  (Cadena sin los caracteres especiales)
 */
FUNCTION F_REEMPLAZAR_CARACTERES_ESP( Fv_Cadena VARCHAR2 )
RETURN VARCHAR2
AS
--
    --
    Fv_Resultado VARCHAR2(300);
    --
--
BEGIN
--
    --
    Fv_Resultado := Fv_Cadena;
    Fv_Resultado := REPLACE(Fv_Resultado,'�','N');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','n');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','a');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','A');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','e');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','E');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','i');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','I');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','o');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','O');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','u');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','U');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','a');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','a');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','e');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','e');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','i');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','i');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','o');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','o');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','u');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','A');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','A');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','E');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','E');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','I');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','I');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','O');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','O');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','U');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','U');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','c');
    Fv_Resultado := REPLACE(Fv_Resultado,'�','c');
    Fv_Resultado := REPLACE(Fv_Resultado,'.','');
    Fv_Resultado := REPLACE(Fv_Resultado,'(','');
    Fv_Resultado := REPLACE(Fv_Resultado,')','');
    Fv_Resultado := REPLACE(Fv_Resultado,',','');
    Fv_Resultado := REPLACE(Fv_Resultado,'-','');
    Fv_Resultado := REPLACE(Fv_Resultado,';','');
    Fv_Resultado := REPLACE(Fv_Resultado,':','');
    Fv_Resultado := REPLACE(Fv_Resultado,'_','');
    --
    --
    RETURN Fv_Resultado;
    --
--
END F_REEMPLAZAR_CARACTERES_ESP;
--
--
/*
 * Documentaci�n para FUNCION 'F_GET_INFO_EMPRESA'.
 * Funcion que obtiene la informacion de la empresa
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 14-03-2016
 *
 * PARAMETROS:
 * @return VARCHAR2 Fv_CodEmpresa  (Codigo de la empresa a consultar)
 * @return VARCHAR2 Fv_Resultado   (Nombre de la empresa que est� realizando la consulta)
 */
FUNCTION F_GET_INFO_EMPRESA( Fv_CodEmpresa VARCHAR2 )
RETURN VARCHAR2
AS
--
    --
    Fv_Resultado VARCHAR2(300);
    --
--
BEGIN
--
    --
    SELECT NVL(
                  (
                      SELECT TRIM(ieg.NOMBRE_EMPRESA)
                      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                      WHERE ieg.COD_EMPRESA = Fv_CodEmpresa
                  ), ''
               ) INTO Fv_Resultado FROM DUAL;
    --
    --
    RETURN FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(Fv_Resultado);
    --
--
END F_GET_INFO_EMPRESA;
  --
  --
  PROCEDURE P_GET_INFO_SERVICIO_A_FACTURAR(
      Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      Pv_EmpresaCod OUT DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
      Pv_PrefijoEmpresa OUT DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pn_OficinaId OUT DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pn_IdPuntoFacturacion OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Pn_IdPunto OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Pn_PlanId OUT DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
      Pn_ProductoId OUT DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
      Pv_Compensacion OUT VARCHAR2,
      Pv_PagaIva OUT VARCHAR2,
      Pv_MessageError OUT VARCHAR2 )
  IS
    --
    CURSOR C_InformacionServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT IER.EMPRESA_COD,
        IPER.OFICINA_ID,
        IP.ID_PUNTO,
        ISER.PLAN_ID,
        ISER.PRODUCTO_ID,
        ISER.PUNTO_FACTURACION_ID,
        IPE.PAGA_IVA,
        IPER.ID_PERSONA_ROL,
        IP.SECTOR_ID,
        IEG.PREFIJO
      FROM DB_COMERCIAL.INFO_SERVICIO ISER
      JOIN DB_COMERCIAL.INFO_PUNTO IP
      ON IP.ID_PUNTO = ISER.PUNTO_ID
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
      ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_PERSONA IPE
      ON IPE.ID_PERSONA = IPER.PERSONA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER
      ON IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      ON IEG.COD_EMPRESA = IER.EMPRESA_COD
      WHERE ISER.ID_SERVICIO = Cn_IdServicio;
    --
    Lc_InformacionServicio C_InformacionServicio%ROWTYPE;
    Ln_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE;
    Ln_IdSectorPunto DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE;
    --
  BEGIN
    --
    IF C_InformacionServicio%ISOPEN THEN
      CLOSE C_InformacionServicio;
    END IF;
    --
    OPEN C_InformacionServicio(Pn_IdServicio);
    --
    FETCH C_InformacionServicio INTO Lc_InformacionServicio;
    --
    Pv_EmpresaCod         := Lc_InformacionServicio.EMPRESA_COD;
    Pv_PrefijoEmpresa     := Lc_InformacionServicio.PREFIJO;
    Pn_OficinaId          := Lc_InformacionServicio.OFICINA_ID;
    Pn_IdPunto            := Lc_InformacionServicio.ID_PUNTO;
    Pn_PlanId             := Lc_InformacionServicio.PLAN_ID;
    Pn_ProductoId         := Lc_InformacionServicio.PRODUCTO_ID;
    Pn_IdPuntoFacturacion := Lc_InformacionServicio.PUNTO_FACTURACION_ID;
    Pv_PagaIva            := Lc_InformacionServicio.PAGA_IVA;
    Ln_IdPersonaRol       := Lc_InformacionServicio.ID_PERSONA_ROL;
    Ln_IdSectorPunto      := Lc_InformacionServicio.SECTOR_ID;
    Pv_Compensacion       := DB_FINANCIERO.FNCK_CONSULTS.F_VALIDA_CLIENTE_COMPENSADO( Ln_IdPersonaRol,
                                                                                      Pn_OficinaId,
                                                                                      Pv_EmpresaCod,
                                                                                      Ln_IdSectorPunto,
                                                                                      Pn_IdPuntoFacturacion );
    --
    --
    IF C_InformacionServicio%ISOPEN THEN
      CLOSE C_InformacionServicio;
    END IF;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Pv_MessageError := 'Error al obtener la informaci�n del servicio a facturar';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_GET_INFO_SERVICIO_A_FACTURAR',
                                          'Error al obtener la informaci�n del servicio a facturar' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_GET_INFO_SERVICIO_A_FACTURAR;
  --
  --
/*
 * Documentaci�n para FUNCION 'F_GET_INFORMACION_PUNTO_CLOB'.
 * Funcion que obtiene informaci�n del punto del cliente pero retorna un CLOB debido a la cantidad de informaci�n que se requiere retornar
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 07-06-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 24-06-2016 - Se valida que no retorne emails y telefonos repetidos.
 *
 * PARAMETROS:
 * @Param DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE          Fn_IdPersona     (id_persona del cliente)
 * @Param DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE                Fv_EstadoPunto   (estado del punto del cliente)
 * @Param DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE   Fv_EmpresaCod    (empresa del punto del cliente)
 * @Param VARCHAR2                                           Fv_Filtro        (es el filtro de lo que se desea buscar)
 * @return CLOB                                              Fv_Resultado     (valor de la forma de contacto)
 */
FUNCTION F_GET_INFORMACION_PUNTO_CLOB(  Fn_IdPersona   DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                        Fv_EstadoPunto DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
                                        Fv_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Fv_Filtro      VARCHAR2 )
RETURN CLOB
IS
--
    --
    Fv_Resultado        CLOB := '';
    Fn_IdPunto          NUMBER;
    Fn_BuscarRepetidos  NUMBER;
    Fv_Observacion      CLOB := '';
    Fv_Codigo           VARCHAR2(100) := '';
    Fv_Estado           VARCHAR2(50) := '';
    Fv_FechaTmp         VARCHAR2(50) := '';
    --
--
BEGIN
--
    --
    CASE
    --
        --
        WHEN Fv_Filtro = 'telfPtoPerson' THEN
        --
            --
            FOR Le_Telefonos IN (
                                    SELECT ipfc.VALOR
                                    FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO ipfc
                                    JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc
                                    ON afc.ID_FORMA_CONTACTO = ipfc.FORMA_CONTACTO_ID
                                    JOIN DB_COMERCIAL.INFO_PUNTO ip
                                    ON ip.ID_PUNTO = ipfc.PUNTO_ID
                                    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                    ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                                    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                    ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                                    ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                                    JOIN DB_COMERCIAL.INFO_PERSONA ipe
                                    ON ipe.ID_PERSONA = iper.PERSONA_ID
                                    WHERE ipe.ID_PERSONA = Fn_IdPersona
                                      AND ieg.COD_EMPRESA = Fv_EmpresaCod
                                      AND ip.ESTADO IN ('Activo', 'Cancelado', 'Trasladado', 'In-Corte')
                                      AND ipfc.ESTADO = 'Activo'
                                      AND afc.CODIGO IN ('TFIJ', 'MCLA', 'MMOV', 'MCNT', 'TTRA', 'TMOV')
                                )
            LOOP
            --
                --
                IF TRIM(Le_Telefonos.VALOR) IS NOT NULL THEN
                --
                    --
                    Le_Telefonos.VALOR := FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(TRIM(Le_Telefonos.VALOR));
                    --
                    --
                    --
                    Fn_BuscarRepetidos := FNCK_CONSULTS.F_BUSCAR_CADENA_REPETIDAS(Fv_Resultado, Le_Telefonos.VALOR);
                    --
                    --
                    --
                    IF Fn_BuscarRepetidos = 0 THEN
                    --
                        --
                        Fv_Resultado := TRIM(Le_Telefonos.VALOR)||'; '||Fv_Resultado;
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
            --
            FOR Le_Telefonos IN (
                                    SELECT ipda.TELEFONO_ENVIO
                                    FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL ipda
                                    JOIN DB_COMERCIAL.INFO_PUNTO ip
                                    ON ip.ID_PUNTO = ipda.PUNTO_ID
                                    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                    ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                                    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                    ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                                    ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                                    JOIN DB_COMERCIAL.INFO_PERSONA ipe
                                    ON ipe.ID_PERSONA = iper.PERSONA_ID
                                    WHERE ipe.ID_PERSONA = Fn_IdPersona
                                      AND ieg.COD_EMPRESA = Fv_EmpresaCod
                                      AND ip.ESTADO IN ('Activo', 'Cancelado', 'Trasladado', 'In-Corte')
                                )
            LOOP
            --
                --
                IF TRIM(Le_Telefonos.TELEFONO_ENVIO) IS NOT NULL THEN
                --
                    --
                    Le_Telefonos.TELEFONO_ENVIO := FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(TRIM(Le_Telefonos.TELEFONO_ENVIO));
                    --
                    --
                    --
                    Fn_BuscarRepetidos := FNCK_CONSULTS.F_BUSCAR_CADENA_REPETIDAS(Fv_Resultado, Le_Telefonos.TELEFONO_ENVIO);
                    --
                    --
                    --
                    IF Fn_BuscarRepetidos = 0 THEN
                    --
                        --
                        Fv_Resultado := TRIM(Le_Telefonos.TELEFONO_ENVIO)||'; '||Fv_Resultado;
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
            --
            FOR Le_Telefonos IN (
                                    SELECT ipfc.VALOR
                                    FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc
                                    JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc
                                    ON afc.ID_FORMA_CONTACTO = ipfc.FORMA_CONTACTO_ID
                                    WHERE ipfc.PERSONA_ID = Fn_IdPersona
                                      AND ipfc.ESTADO = 'Activo'
                                      AND afc.CODIGO IN ('TFIJ', 'MCLA', 'MMOV', 'MCNT', 'TTRA', 'TMOV')
                                )
            LOOP
            --
                --
                IF TRIM(Le_Telefonos.VALOR) IS NOT NULL THEN
                --
                    --
                    Le_Telefonos.VALOR := FNCK_CONSULTS.F_REEMPLAZAR_CARACTERES_ESP(TRIM(Le_Telefonos.VALOR));
                    --
                    --
                    --
                    Fn_BuscarRepetidos := FNCK_CONSULTS.F_BUSCAR_CADENA_REPETIDAS(Fv_Resultado, Le_Telefonos.VALOR);
                    --
                    --
                    --
                    IF Fn_BuscarRepetidos = 0 THEN
                    --
                        --
                        Fv_Resultado := TRIM(Le_Telefonos.VALOR)||'; '||Fv_Resultado;
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
        WHEN Fv_Filtro = 'emailPtoPersona' THEN
        --
            --
            FOR Le_Email IN (
                                SELECT ipfc.VALOR
                                FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO ipfc
                                JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc
                                ON afc.ID_FORMA_CONTACTO = ipfc.FORMA_CONTACTO_ID
                                JOIN DB_COMERCIAL.INFO_PUNTO ip
                                ON ip.ID_PUNTO = ipfc.PUNTO_ID
                                JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                                JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                                ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                                JOIN DB_COMERCIAL.INFO_PERSONA ipe
                                ON ipe.ID_PERSONA = iper.PERSONA_ID
                                WHERE ipe.ID_PERSONA = Fn_IdPersona
                                  AND ieg.COD_EMPRESA = Fv_EmpresaCod
                                  AND ipfc.ESTADO = 'Activo'
                                  AND afc.CODIGO IN ('MAIL')
                            )
            LOOP
            --
                --
                IF TRIM(Le_Email.VALOR) IS NOT NULL THEN
                --
                    --
                    Fn_BuscarRepetidos := FNCK_CONSULTS.F_BUSCAR_CADENA_REPETIDAS(Fv_Resultado, TRIM(Le_Email.VALOR));
                    --
                    --
                    --
                    IF Fn_BuscarRepetidos = 0 THEN
                    --
                        --
                        Fv_Resultado := TRIM(Le_Email.VALOR)||'; '||Fv_Resultado;
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
            --
            FOR Le_Email IN (
                                SELECT ipda.EMAIL_ENVIO
                                FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL ipda
                                JOIN DB_COMERCIAL.INFO_PUNTO ip
                                ON ip.ID_PUNTO = ipda.PUNTO_ID
                                JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
                                ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
                                JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
                                ON ier.ID_EMPRESA_ROL = iper.EMPRESA_ROL_ID
                                JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
                                ON ieg.COD_EMPRESA = ier.EMPRESA_COD
                                JOIN DB_COMERCIAL.INFO_PERSONA ipe
                                ON ipe.ID_PERSONA = iper.PERSONA_ID
                                WHERE ipe.ID_PERSONA = Fn_IdPersona
                                  AND ieg.COD_EMPRESA = Fv_EmpresaCod
                                  AND ipda.PUNTO_ID = Fn_IdPunto
                            )
            LOOP
            --
                --
                IF TRIM(Le_Email.EMAIL_ENVIO) IS NOT NULL THEN
                --
                    --
                    Fn_BuscarRepetidos := FNCK_CONSULTS.F_BUSCAR_CADENA_REPETIDAS(Fv_Resultado,TRIM(Le_Email.EMAIL_ENVIO));
                    --
                    --
                    --
                    IF Fn_BuscarRepetidos = 0 THEN
                    --
                        --
                        Fv_Resultado := TRIM(Le_Email.EMAIL_ENVIO)||'; '||Fv_Resultado;
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
            --
            FOR Le_Email IN (
                                SELECT ipfc.VALOR
                                FROM DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO ipfc
                                JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO afc
                                ON afc.ID_FORMA_CONTACTO = ipfc.FORMA_CONTACTO_ID
                                WHERE ipfc.PERSONA_ID = Fn_IdPersona
                                  AND ipfc.ESTADO = 'Activo'
                                  AND afc.CODIGO IN ('MAIL')
                            )
            LOOP
            --
                --
                IF TRIM(Le_Email.VALOR) IS NOT NULL THEN
                --
                    --
                    Fn_BuscarRepetidos := FNCK_CONSULTS.F_BUSCAR_CADENA_REPETIDAS(Fv_Resultado, TRIM(Le_Email.VALOR));
                    --
                    --
                    --
                    IF Fn_BuscarRepetidos = 0 THEN
                    --
                        --
                        Fv_Resultado := TRIM(Le_Email.VALOR)||'; '||Fv_Resultado;
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
    --
    END CASE;
    --
    --
    RETURN Fv_Resultado;
    --
--
END;
--
--
--
/*
 * Documentaci�n para FUNCION 'F_BUSCAR_CADENA_REPETIDAS'.
 *
 * Funcion que busca cadenas repetidas
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 24-06-2016
 *
 * PARAMETROS:
 * @return VARCHAR2 Fv_CadenaInicial  (Contiene la cadena en la que se va a buscar)
 * @return VARCHAR2 Fv_CadenaABuscar  (Contiene la cadena que se desea buscar)
 * @return VARCHAR2 Fv_Resultado      (Cadena sin los caracteres especiales)
 */
FUNCTION F_BUSCAR_CADENA_REPETIDAS( Fv_CadenaInicial CLOB, Fv_CadenaABuscar VARCHAR2 )
RETURN VARCHAR2
AS
--
    --
    Fv_Resultado NUMBER;
    --
--
BEGIN
--
    --
    SELECT NVL( (SELECT INSTR(Fv_CadenaInicial, Fv_CadenaABuscar) FROM DUAL), 0) INTO Fv_Resultado FROM DUAL;
    --
    --
    --
    RETURN Fv_Resultado;
    --
--
END F_BUSCAR_CADENA_REPETIDAS;
--
--
/**
 * Documentaci�n para FUNCION 'P_GET_FECHAS_DIAS_PERIODO'.
 *
 * Funci�n que obtiene las fechas inicial y final del periodo a facturar, y adicional retornan la cantidad de d�as entre las fechas obtenidas y la
 * fecha en que se activ� el servicio
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 19-07-2016
 *
 * PARAMETROS:
 * @param NUMBER    PIn_EmpresaCod            IN    (Contiene el c�digo de la empresa)
 * @param VARCHAR2  PIv_FechaActivacion       IN    (Contiene la fecha de activaci�n del servicio)
 * @param VARCHAR2  POd_FechaInicioPeriodo    OUT   (Cadena con la fecha inicial del periodo)
 * @param VARCHAR2  POd_FechaFinPeriodo       OUT   (Cadena con la fecha final del periodo)
 * @param NUMBER    POn_CantidadDiasTotalMes  OUT   (N�mero con la cantidad de d�as del periodo)
 * @param NUMBER    POn_CantidadDiasRestantes OUT   (N�mero con la cantidad de d�as a facturar)
 */
PROCEDURE P_GET_FECHAS_DIAS_PERIODO(  PIn_EmpresaCod            IN  NUMBER,
                                      PIv_FechaActivacion       IN  VARCHAR2,
                                      POd_FechaInicioPeriodo    OUT VARCHAR2,
                                      POd_FechaFinPeriodo       OUT VARCHAR2,
                                      POn_CantidadDiasTotalMes  OUT NUMBER,
                                      POn_CantidadDiasRestantes OUT NUMBER )
IS
--
    --
    Ln_DiaActivacionServicio  NUMBER := 0;
    Lv_DiaInicialPeriodo      VARCHAR2(3);
    Lv_DiaFinalPeriodo        VARCHAR2(3);
    Ln_MesesASumarFeInicial   NUMBER := 0;
    Ln_MesesASumarFeFinal     NUMBER := 0;
    --
--
BEGIN
--
    --
    SELECT apd.VALOR1, apd.VALOR2 INTO Lv_DiaInicialPeriodo, Lv_DiaFinalPeriodo
    FROM DB_GENERAL.ADMI_PARAMETRO_DET apd
    WHERE apd.PARAMETRO_ID = (
                                SELECT ID_PARAMETRO
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                                WHERE ESTADO = 'Activo'
                                  AND NOMBRE_PARAMETRO = 'PERIODO_FACTURACION'
                             )
      AND apd.EMPRESA_COD = PIn_EmpresaCod;
    --
    --
    --
    SELECT TO_NUMBER(TO_CHAR(TO_DATE(PIv_FechaActivacion,'YYYY-MM-DD'),'dd')) INTO Ln_DiaActivacionServicio
    FROM DUAL;
    --
    --
    --
    IF TO_NUMBER(Lv_DiaInicialPeriodo) > 0 THEN
    --
        --
        IF TO_NUMBER(Lv_DiaFinalPeriodo) > 0 THEN
        --
            --
            IF TO_NUMBER(Lv_DiaFinalPeriodo) >= Ln_DiaActivacionServicio THEN
            --
                --
                Ln_MesesASumarFeInicial := -1;
                Ln_MesesASumarFeFinal   := 0;
                --
            --
            ELSE
            --
                --
                Ln_MesesASumarFeInicial := 0;
                Ln_MesesASumarFeFinal   := 1;
                --
            --
            END IF;
            --
        --
        END IF;
        --
        --
        --
        SELECT CONCAT( (SELECT TO_CHAR(ADD_MONTHS(TO_DATE(PIv_FechaActivacion,'YYYY-MM-DD'), Ln_MesesASumarFeInicial),'YYYY')
                        FROM DUAL),
               CONCAT('-', CONCAT((SELECT TO_CHAR(ADD_MONTHS(TO_DATE(PIv_FechaActivacion,'YYYY-MM-DD'), Ln_MesesASumarFeInicial),'MM')
                                   FROM DUAL),
               CONCAT('-', Lv_DiaInicialPeriodo))))
        INTO POd_FechaInicioPeriodo
        FROM DUAL;
        --
        --
        --
        IF Ln_MesesASumarFeInicial = 0 AND Ln_MesesASumarFeFinal = 0 THEN
        --
            --
            SELECT TO_CHAR(LAST_DAY(TO_DATE(PIv_FechaActivacion, 'YYYY-MM-DD')), 'YYYY-MM-DD')
            INTO POd_FechaFinPeriodo
            FROM DUAL;
            --
        --
        ELSE
        --
            --
            SELECT CONCAT( (SELECT TO_CHAR(ADD_MONTHS(TO_DATE(PIv_FechaActivacion,'YYYY-MM-DD'), Ln_MesesASumarFeFinal),'YYYY')
                            FROM DUAL),
                   CONCAT('-', CONCAT((SELECT TO_CHAR(ADD_MONTHS(TO_DATE(PIv_FechaActivacion,'YYYY-MM-DD'), Ln_MesesASumarFeFinal),'MM')
                                       FROM DUAL),
                   CONCAT('-', Lv_DiaFinalPeriodo))))
            INTO POd_FechaFinPeriodo
            FROM DUAL;
        --
        END IF;
        --
        --
        --
        IF POd_FechaFinPeriodo IS NOT NULL AND POd_FechaInicioPeriodo IS NOT NULL THEN
        --
            --
            SELECT ( TO_DATE(POd_FechaFinPeriodo, 'YYYY-MM-DD') - TO_DATE(POd_FechaInicioPeriodo, 'YYYY-MM-DD') )
            INTO POn_CantidadDiasTotalMes
            FROM DUAL;
            --
            --
            --
            --
            SELECT ( TO_DATE(POd_FechaFinPeriodo, 'YYYY-MM-DD') - TO_DATE(PIv_FechaActivacion, 'YYYY-MM-DD') )
            INTO POn_CantidadDiasRestantes
            FROM DUAL;
            --
            --
            --
            POn_CantidadDiasTotalMes  := POn_CantidadDiasTotalMes + 1;
            POn_CantidadDiasRestantes := POn_CantidadDiasRestantes + 1;
            --
        --
        END IF;
        --
    --
    END IF;
    --
--
END P_GET_FECHAS_DIAS_PERIODO;
--
  FUNCTION F_GET_BANCO(
    Fn_BancoCtaContableId NUMBER)
  RETURN VARCHAR2
    --
  IS
      --
    CURSOR Lc_GetBanco(Cn_BancoCtaContableId NUMBER)
    IS
      SELECT  AB.DESCRIPCION_BANCO
      FROM    DB_GENERAL.ADMI_BANCO AB,
              DB_GENERAL.ADMI_BANCO_CTA_CONTABLE ABCC ,
              DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC
      WHERE   ABCC.BANCO_TIPO_CUENTA_ID = ABTC.ID_BANCO_TIPO_CUENTA AND
              AB.ID_BANCO = ABTC.BANCO_ID  AND
              ABCC.ID_BANCO_CTA_CONTABLE=Cn_BancoCtaContableId;
      --
       Lv_GetBanco DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE;
      --
  BEGIN
      --
    IF Lc_GetBanco%ISOPEN THEN
        --
      CLOSE Lc_GetBanco;
        --
    END IF;
      --
    OPEN Lc_GetBanco(Fn_BancoCtaContableId);
    --
    FETCH
      Lc_GetBanco
    INTO
      Lv_GetBanco;
    --
    CLOSE Lc_GetBanco;

    IF Lv_GetBanco IS NULL THEN
      Lv_GetBanco  := '';
    END IF;
    --
    RETURN Lv_GetBanco;
    --
    EXCEPTION
    WHEN OTHERS THEN
    --
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('F_GET_BANCO', 'FNKG_REPORTES_COBRANZAS.F_GET_BANCO', SQLERRM);
    --
  END F_GET_BANCO;
  --
  --
  FUNCTION F_GET_BANCO_EMPRESA(
      Fn_BancoCtaContableId IN DB_FINANCIERO.INFO_PAGO_DET.BANCO_CTA_CONTABLE_ID%TYPE,
      Fn_CuentaContableId   IN DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE )
    RETURN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE
  IS
    --
    --CURSOR QUE RETORNA EL BANCO CUENTA CONTABLE
    --COSTO QUERY: 1
    CURSOR C_GetBancoCtaContable(Cn_BancoCtaContableId DB_FINANCIERO.INFO_PAGO_DET.BANCO_CTA_CONTABLE_ID%TYPE)
    IS
      --
      SELECT
        ABCC.DESCRIPCION
        ||' '
        ||ABCC.NO_CTA
      FROM
        DB_GENERAL.ADMI_BANCO_CTA_CONTABLE ABCC
      WHERE
        ABCC.ID_BANCO_CTA_CONTABLE = Cn_BancoCtaContableId;
    --
    --CURSOR QUE RETORNA LA CUENTA CONTABLE
    --COSTO QUERY: 2
    CURSOR C_GetCuentaContable(Cn_CuentaContableId DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE)
    IS
      --
      SELECT
        ACC.DESCRIPCION
        ||' '
        ||ACC.NO_CTA
      FROM
        DB_FINANCIERO.ADMI_CUENTA_CONTABLE ACC
      WHERE
        ACC.ID_CUENTA_CONTABLE = Cn_CuentaContableId;
      --
    --
    Lv_BancoCuentaContable DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE;
      --
  BEGIN
    --
    IF Fn_BancoCtaContableId IS NOT NULL AND Fn_BancoCtaContableId > 0 THEN
      --
      IF C_GetBancoCtaContable%ISOPEN THEN
      --
        CLOSE C_GetBancoCtaContable;
      --
      END IF;
      --
      OPEN C_GetBancoCtaContable(Fn_BancoCtaContableId);
        --
      FETCH C_GetBancoCtaContable INTO Lv_BancoCuentaContable;
      --
      CLOSE C_GetBancoCtaContable;
      --
    ELSIF Fn_CuentaContableId IS NOT NULL AND Fn_CuentaContableId > 0 THEN
      --
      IF C_GetCuentaContable%ISOPEN THEN
      --
        CLOSE C_GetCuentaContable;
      --
      END IF;
      --
      OPEN C_GetCuentaContable(Fn_CuentaContableId);
        --
      FETCH C_GetCuentaContable INTO Lv_BancoCuentaContable;
      --
      CLOSE C_GetCuentaContable;
      --
    END IF;
    --
    --
    RETURN Lv_BancoCuentaContable;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_BancoCuentaContable := NULL;
    --
    DBMS_OUTPUT.PUT_LINE('F_GET_BANCO_EMPRESA'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    --
    RETURN Lv_BancoCuentaContable;
    --
  END F_GET_BANCO_EMPRESA;


  FUNCTION F_GET_BANCO_EMPRESA_DEP(
    Fn_DepositoCtaContableId    NUMBER)
  RETURN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE
  IS
    --
    CURSOR Lc_GetBanco(Cn_DepositoCtaContableId NUMBER)
    IS
      SELECT  ACC.DESCRIPCION||' '||ACC.NO_CTA
      FROM    DB_FINANCIERO.ADMI_CUENTA_CONTABLE ACC
      WHERE   ACC.ID_CUENTA_CONTABLE = Cn_DepositoCtaContableId;
      --
    Lv_GetBanco  DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE;
      --
  BEGIN
      --
    IF Lc_GetBanco%ISOPEN THEN
      --
      CLOSE Lc_GetBanco;
      --
    END IF;
      --
    OPEN Lc_GetBanco(Fn_DepositoCtaContableId);
      --
    FETCH Lc_GetBanco INTO Lv_GetBanco;
      --
    CLOSE Lc_GetBanco;

    IF Lv_GetBanco IS NULL THEN
      Lv_GetBanco  := '';
    END IF;
      --
    RETURN Lv_GetBanco;
      --
    EXCEPTION
    WHEN OTHERS THEN
      --
    DBMS_OUTPUT.PUT_LINE('F_GET_BANCO_EMPRESA_DEP'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_BANCO_EMPRESA_DEP;


  FUNCTION F_GET_BANCO_EMPRESA_DEP_NAF(
    Fn_DepositoBancoNafId    NUMBER)
  RETURN DB_GENERAL.ADMI_BANCO_CTA_CONTABLE.DESCRIPCION%TYPE
  IS
    CURSOR Lc_GetBanco(Cn_DepositoBancoNafId NUMBER)
    IS
      SELECT  ABCC.DESCRIPCION||' '||ABCC.NO_CTA
      FROM    DB_GENERAL.ADMI_BANCO_CTA_CONTABLE ABCC
      WHERE   ABCC.ID_BANCO_CTA_CONTABLE = Cn_DepositoBancoNafId;
      --
      Lv_GetBanco  DB_GENERAL.ADMI_BANCO_CTA_CONTABLE.DESCRIPCION%TYPE;
      --
  BEGIN
      --
    IF Lc_GetBanco%ISOPEN THEN
      --
    CLOSE Lc_GetBanco;
      --
    END IF;
    --
    OPEN Lc_GetBanco(Fn_DepositoBancoNafId);
    --
    FETCH Lc_GetBanco INTO Lv_GetBanco;
    --
    CLOSE Lc_GetBanco;
    IF Lv_GetBanco IS NULL THEN
      Lv_GetBanco  := '';
    END IF;
    --
    RETURN Lv_GetBanco;
    --
    EXCEPTION
    WHEN OTHERS THEN
      --
    DBMS_OUTPUT.PUT_LINE('F_GET_BANCO_EMPRESA_DEP_NAF'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_BANCO_EMPRESA_DEP_NAF;

  FUNCTION F_GET_VALOR_CARACTERISTICA(
    Fn_IdDocumento    NUMBER,
    Fv_Caracteristica VARCHAR2 )
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE
  IS
    CURSOR Lc_GetCaracteristica(Cn_IdDocumento NUMBER, Cv_Caracteristica VARCHAR2)
    IS
      SELECT IDC.VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
           DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
           DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE IDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
      AND AC.ID_CARACTERISTICA          =IDC.CARACTERISTICA_ID
      AND IDFC.ID_DOCUMENTO             = Cn_IdDocumento
      AND AC.ESTADO                     = 'Activo'
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica;
  --
    Lv_GetCaracteristica DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE;
  --
  BEGIN
  --
    IF Lc_GetCaracteristica%ISOPEN THEN
    --
      CLOSE Lc_GetCaracteristica;
    --
    END IF;
  --
    OPEN Lc_GetCaracteristica(Fn_IdDocumento,Fv_Caracteristica);
  --
    FETCH Lc_GetCaracteristica INTO Lv_GetCaracteristica;
  --
    CLOSE Lc_GetCaracteristica;

    IF Lv_GetCaracteristica IS NULL THEN
      Lv_GetCaracteristica  := '';
    END IF;
  --
    RETURN Lv_GetCaracteristica;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_VALOR_CARACTERISTICA '||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
  --
  END F_GET_VALOR_CARACTERISTICA;


  FUNCTION F_GET_DOCUMENTO_APLICA(
    Fn_ReferenciaDocumentoId NUMBER)
  RETURN VARCHAR2
  IS
  --
    CURSOR Lc_GetDocumentoAplica(Cn_ReferenciaDocumentoId NUMBER)
    IS
      SELECT IDFC.NUMERO_FACTURA_SRI
      FROM   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      WHERE  IDFC.ID_DOCUMENTO = Cn_ReferenciaDocumentoId;
  --
      Lv_getDocumentoAplica DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
  --
  BEGIN
  --
    IF Lc_GetDocumentoAplica%ISOPEN THEN
    --
      CLOSE Lc_GetDocumentoAplica;
    --
    END IF;
  --
    OPEN Lc_GetDocumentoAplica(Fn_ReferenciaDocumentoId);
  --
    FETCH Lc_GetDocumentoAplica INTO Lv_getDocumentoAplica;
  --
    CLOSE Lc_GetDocumentoAplica;
  --
    IF Lv_getDocumentoAplica IS NULL THEN
      Lv_getDocumentoAplica  := '';
    END IF;
  RETURN Lv_getDocumentoAplica;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_DOCUMENTO_APLICA '||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
  --
  END F_GET_DOCUMENTO_APLICA;

  FUNCTION F_GET_MOTIVO_DOCUMENTO(
    Fn_IdDocumento NUMBER)
  RETURN VARCHAR2
  IS
  --
    CURSOR Lc_GetMotivoDocumento(Cn_IdDocumento NUMBER)
    IS
      SELECT AM.NOMBRE_MOTIVO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD,
           DB_COMERCIAL.ADMI_MOTIVO AM
      WHERE IDFD.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
      AND IDFC.ID_DOCUMENTO   = Cn_IdDocumento
      AND AM.ID_MOTIVO        = IDFD.MOTIVO_ID;
  --
    Lv_GetMotivoDocumento DB_COMERCIAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE;
  --
  BEGIN
  --
    IF Lc_GetMotivoDocumento%ISOPEN THEN
    --
      CLOSE Lc_GetMotivoDocumento;
    --
    END IF;
  --
    OPEN Lc_GetMotivoDocumento(Fn_IdDocumento);
  --
    FETCH Lc_GetMotivoDocumento INTO Lv_GetMotivoDocumento;
  --
    CLOSE Lc_GetMotivoDocumento;

    IF Lv_GetMotivoDocumento IS NULL THEN
      Lv_GetMotivoDocumento  := '';
    END IF;
  --
  RETURN Lv_GetMotivoDocumento;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_MOTIVO_DOCUMENTO'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
  --
  END F_GET_MOTIVO_DOCUMENTO;

  FUNCTION F_GET_PAGOS_APLICA_ND(
    Fn_IdDocumento NUMBER)
  RETURN VARCHAR2
  IS
  --
    CURSOR Lc_GetPagosAplicaNd(Cn_IdDocumento NUMBER)
    IS
      SELECT LISTAGG (TRIM(IPC.NUMERO_PAGO), '|') WITHIN GROUP (
      ORDER BY IPC.NUMERO_PAGO ) NUMERO_PAGO
      FROM INFO_DOCUMENTO_FINANCIERO_DET IDFD ,
           INFO_PAGO_CAB IPC ,
           INFO_PAGO_DET IPD
      WHERE IDFD.PAGO_DET_ID=IPD.ID_PAGO_DET
      AND IPD.PAGO_ID       = IPC.ID_PAGO
      AND IDFD.DOCUMENTO_ID = Cn_IdDocumento;
  --
    Lv_GetPagosAplicaNd VARCHAR2(1000);
  --
BEGIN
  --
  IF Lc_GetPagosAplicaNd%ISOPEN THEN
    --
    CLOSE Lc_GetPagosAplicaNd;
    --
  END IF;
  --
  OPEN Lc_GetPagosAplicaNd(Fn_IdDocumento);
  --
  FETCH Lc_GetPagosAplicaNd INTO Lv_GetPagosAplicaNd;
  --
  CLOSE Lc_GetPagosAplicaNd;
  --
  IF Lv_GetPagosAplicaNd IS NULL THEN
    Lv_GetPagosAplicaNd  := '';
  END IF;
  RETURN Lv_GetPagosAplicaNd;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_PAGOS_APLICA_ND'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
  --
  END F_GET_PAGOS_APLICA_ND;


  FUNCTION F_GET_VALOR_RETENCIONES(
    Fn_IdDocumento NUMBER,
    Fv_CodigosFormaPago VARCHAR2,
    Fv_DescripcionFormaPago VARCHAR2)
  RETURN DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE
  IS

    Lf_GetValorRetenciones INFO_PAGO_DET.VALOR_PAGO%TYPE:=0;
    Lrf_GetValorRetenciones SYS_REFCURSOR;
    Lv_Query VARCHAR2(3000);
  BEGIN

    IF Fn_IdDocumento IS NOT NULL THEN
     Lv_Query := 'SELECT ROUND(SUM(NVL(IPD.VALOR_PAGO,0)), 2)
                  FROM DB_FINANCIERO.INFO_PAGO_DET IPD,
                       DB_GENERAL.ADMI_FORMA_PAGO AFP
                  WHERE IPD.REFERENCIA_ID      = '||Fn_IdDocumento ||'
                  AND   IPD.FORMA_PAGO_ID      =  AFP.ID_FORMA_PAGO
                  AND   IPD.ESTADO             IN (''Cerrado'',''Activo'')';

    IF Fv_CodigosFormaPago IS NOT NULL THEN
      Lv_Query := Lv_Query ||' AND AFP.CODIGO_FORMA_PAGO IN ('|| Fv_CodigosFormaPago ||')';
    END IF;

    IF Fv_DescripcionFormaPago IS NOT NULL THEN
      Lv_Query := Lv_Query ||' AND AFP.DESCRIPCION_FORMA_PAGO LIKE '''|| Fv_DescripcionFormaPago ||'%''';
    END IF;

    IF Lrf_GetValorRetenciones%ISOPEN THEN
      CLOSE Lrf_GetValorRetenciones;
    END IF;

    OPEN Lrf_GetValorRetenciones FOR Lv_Query;
    FETCH Lrf_GetValorRetenciones INTO Lf_GetValorRetenciones;
    CLOSE Lrf_GetValorRetenciones;

    END IF;

    IF Lf_GetValorRetenciones IS NULL THEN
      Lf_GetValorRetenciones:=0;
    END IF;

    RETURN Lf_GetValorRetenciones;

  EXCEPTION
  WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('F_GET_VALOR_RETENCIONES'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      Lf_GetValorRetenciones :=null;
      RETURN Lf_GetValorRetenciones;

  END F_GET_VALOR_RETENCIONES;

  FUNCTION F_GET_COMENTARIO_ND(
    Fn_IdDocumento NUMBER)
  RETURN VARCHAR2
  IS
  --
    CURSOR Lc_GetComentarioPagoNd(Cn_IdDocumento NUMBER)
    IS
      SELECT TRIM(IDFD.OBSERVACIONES_FACTURA_DETALLE)
      FROM INFO_DOCUMENTO_FINANCIERO_DET IDFD
      LEFT JOIN INFO_PAGO_DET IPD ON IDFD.PAGO_DET_ID = IPD.ID_PAGO_DET
      LEFT JOIN INFO_PAGO_CAB IPC ON IPD.PAGO_ID      = IPC.ID_PAGO
      WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento;
  --
    Lv_GetComentarioPagoNd VARCHAR2(5000);
  --
  BEGIN
  --
    IF Lc_GetComentarioPagoNd%ISOPEN THEN
    --
      CLOSE Lc_GetComentarioPagoNd;
    --
    END IF;
  --
    OPEN Lc_GetComentarioPagoNd(Fn_IdDocumento);
  --
    FETCH Lc_GetComentarioPagoNd INTO Lv_GetComentarioPagoNd;
  --
    CLOSE Lc_GetComentarioPagoNd;
  --
    IF Lv_GetComentarioPagoNd IS NULL THEN
      Lv_GetComentarioPagoNd  := '';
    END IF;
    RETURN Lv_GetComentarioPagoNd;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_COMENTARIO_ND'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
  --
  END F_GET_COMENTARIO_ND;
  --
  --
  PROCEDURE P_DOCUMENTOS_RELACIONADOS(
      Pn_IdFactura       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_FeConsultaHasta IN VARCHAR2,
      Pr_Documentos OUT SYS_REFCURSOR )
  IS
    --
    Lv_MessageError VARCHAR2(1000) := '';
    --
  BEGIN
    --
    --Listado de Pagos asociados a la factura
    OPEN Pr_Documentos FOR SELECT ATDF.CODIGO_TIPO_DOCUMENTO, IPC.NUMERO_PAGO, IPC.ESTADO_PAGO, IPD.VALOR_PAGO, AFP.CODIGO_FORMA_PAGO,
    CASE
    WHEN IPC.FE_CRUCE IS NULL THEN
      TO_CHAR(IPD.FE_CREACION,'dd/MM/yyyy')
    ELSE
      TO_CHAR(IPC.FE_CRUCE,'dd/MM/yyyy')
    END
  AS
    FE_CREACION,
    CASE
    WHEN IPC.FE_CRUCE IS NULL THEN
      IPD.FE_CREACION
    ELSE
      IPC.FE_CRUCE
    END
  AS
    FE_ORDENAMIENTO,
    CASE
    WHEN IPD.NUMERO_REFERENCIA IS NULL THEN
      IPD.NUMERO_CUENTA_BANCO
    ELSE
      IPD.NUMERO_REFERENCIA
    END
  AS
    NUMERO_REFERENCIA, AB.DESCRIPCION_BANCO, ABB.DESCRIPCION_BANCO
  AS
    DESCRIPCION_CONTABLE, IPD.ID_PAGO_DET
  FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
  LEFT JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IPC.ID_PAGO = IPD.PAGO_ID
  LEFT JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IPC.TIPO_DOCUMENTO_ID
  LEFT JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON IPD.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO
  LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC ON ABTC.ID_BANCO_TIPO_CUENTA = IPD.BANCO_TIPO_CUENTA_ID
  LEFT JOIN DB_GENERAL.ADMI_BANCO AB ON AB.ID_BANCO = ABTC.BANCO_ID
  LEFT JOIN DB_GENERAL.ADMI_BANCO_CTA_CONTABLE ABCCC ON ABCCC.ID_BANCO_CTA_CONTABLE = IPD.BANCO_CTA_CONTABLE_ID
  LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTCC ON ABTCC.ID_BANCO_TIPO_CUENTA = ABCCC.BANCO_TIPO_CUENTA_ID
  LEFT JOIN DB_GENERAL.ADMI_BANCO ABB ON ABB.ID_BANCO = ABTCC.BANCO_ID
  WHERE IPC.ESTADO_PAGO NOT IN
    (SELECT VALOR3
    FROM DB_GENERAL.ADMI_PARAMETRO_DET
    WHERE PARAMETRO_ID =
      (SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE ESTADO         = 'Activo'
      AND NOMBRE_PARAMETRO = 'ESTADOS_FINANCIEROS'
      )
    AND ESTADO              = 'Activo'
    AND DESCRIPCION         = 'INFO_PAGO_CAB'
    AND VALOR1              = 'P_DOCUMENTOS_RELACIONADOS'
    AND VALOR2              = 'NOT IN'
    ) AND IPD.REFERENCIA_ID = Pn_IdFactura
    AND IPD.FE_CREACION < NVL2( Pv_FeConsultaHasta, CAST(TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1 )
    UNION
    --Notas de Debito
    SELECT ATDF.CODIGO_TIPO_DOCUMENTO,
      IDFC.NUMERO_FACTURA_SRI,
      IDFC.ESTADO_IMPRESION_FACT,
      IDFD.PRECIO_VENTA_FACPRO_DETALLE,
      '',
      TO_CHAR(IDFC.FE_EMISION,'dd/MM/yyyy') AS FE_CREACION,
      IDFC.FE_EMISION                       AS FE_ORDENAMIENTO,
      '',
      '',
      '',
      IDFC.ID_DOCUMENTO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
    ON IDFC.ID_DOCUMENTO = IDFD.DOCUMENTO_ID
    JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    ON ATDF.ID_TIPO_DOCUMENTO       = IDFC.TIPO_DOCUMENTO_ID
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN
      (SELECT VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE ESTADO         = 'Activo'
        AND NOMBRE_PARAMETRO = 'CODIGOS_FINANCIEROS'
        )
      AND ESTADO      = 'Activo'
      AND DESCRIPCION = 'ADMI_TIPO_DOCUMENTO_FINANCIERO'
      AND VALOR1      = 'P_DOCUMENTOS_RELACIONADOS'
      AND VALOR2      = 'IN'
      AND VALOR3      = 'LISTA_DEBITOS'
      )
    AND IDFC.ESTADO_IMPRESION_FACT NOT IN
      (SELECT VALOR3
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE ESTADO         = 'Activo'
        AND NOMBRE_PARAMETRO = 'ESTADOS_FINANCIEROS'
        )
      AND ESTADO      = 'Activo'
      AND DESCRIPCION = 'INFO_DOCUMENTO_FINANCIERO_CAB'
      AND VALOR1      = 'P_DOCUMENTOS_RELACIONADOS'
      AND VALOR2      = 'NOT IN'
      )
    AND IDFD.PAGO_DET_ID IN
      (SELECT ID_PAGO_DET
      FROM DB_FINANCIERO.INFO_PAGO_DET
      WHERE REFERENCIA_ID = Pn_IdFactura
      )
    AND IDFC.FE_EMISION < NVL2( Pv_FeConsultaHasta, CAST(TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1 )
    UNION
    --Notas de Credito y Notas de Cr�dito Internas
    SELECT ATDF.codigo_tipo_documento,
      IDFC.NUMERO_FACTURA_SRI,
      IDFC.ESTADO_IMPRESION_FACT,
      IDFC.VALOR_TOTAL,
      '',
      TO_CHAR(IDFC.FE_EMISION,'dd/MM/yyyy') AS FE_CREACION,
      IDFC.FE_EMISION                       AS FE_ORDENAMIENTO,
      '',
      '',
      '',
      IDFC.ID_DOCUMENTO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
    LEFT JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    ON ATDF.ID_TIPO_DOCUMENTO           = IDFC.TIPO_DOCUMENTO_ID
    WHERE IDFC.REFERENCIA_DOCUMENTO_ID  = Pn_IdFactura
    AND IDFC.ESTADO_IMPRESION_FACT NOT IN
      (SELECT VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE PARAMETRO_ID =
        (SELECT ID_PARAMETRO
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE ESTADO         = 'Activo'
        AND NOMBRE_PARAMETRO = 'ESTADOS_FINANCIEROS'
        )
      AND ESTADO      = 'Activo'
      AND DESCRIPCION = 'INFO_DOCUMENTO_FINANCIERO_CAB'
      AND VALOR1      = 'P_DOCUMENTOS_RELACIONADOS'
      AND VALOR2      = 'NOT IN'
      AND VALOR3      = 'NOTAS_CREDITO'
      )
    AND
      (
        (
          IDFC.FE_AUTORIZACION < NVL2( Pv_FeConsultaHasta, CAST(TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                       CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1 )
        )
      OR
        (
          IDFC.FE_EMISION < NVL2( Pv_FeConsultaHasta, CAST(TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                  CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1 )
          AND IDFC.FE_AUTORIZACION IS NULL
        )
      )
    ORDER BY FE_ORDENAMIENTO;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MessageError := 'Error en FNCK_CONSULTS.P_DOCUMENTOS_RELACIONADOS - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_CONSULTS.P_DOCUMENTOS_RELACIONADOS',
                                          Lv_MessageError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_DOCUMENTOS_RELACIONADOS;
  --
  --
  FUNCTION F_GET_VALOR_IMPUESTO(
    Fn_IdDocumento  NUMBER,
    Fv_TipoImpuesto VARCHAR2)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE
  --
  IS
  --
    CURSOR Lc_GetValorImpuesto(Cn_IdDocumento NUMBER, Cv_TipoImpuesto VARCHAR2)
    IS
      SELECT ROUND(SUM(NVL(IDFI.VALOR_IMPUESTO,0)),2) AS IMPUESTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD,
           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI,
           DB_GENERAL.ADMI_IMPUESTO AI
      WHERE IDFC.ID_DOCUMENTO = Cn_IdDocumento
      AND AI.TIPO_IMPUESTO    = Cv_TipoImpuesto
      AND IDFD.DOCUMENTO_ID   = IDFC.ID_DOCUMENTO
      AND IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
      AND AI.ID_IMPUESTO      = IDFI.IMPUESTO_ID;
  --
    Lf_GetValorImpuesto DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE;
  --
  BEGIN
  --
    IF Lc_GetValorImpuesto%ISOPEN THEN
    --
      CLOSE Lc_GetValorImpuesto;
    --
    END IF;
  --
    OPEN Lc_GetValorImpuesto(Fn_IdDocumento,Fv_TipoImpuesto);
  --
    FETCH Lc_GetValorImpuesto INTO Lf_GetValorImpuesto;
  --
    CLOSE Lc_GetValorImpuesto;
    IF Lf_GetValorImpuesto IS NULL THEN
      Lf_GetValorImpuesto  := 0.00;
    END IF;
  --
    RETURN Lf_GetValorImpuesto;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_VALOR_IMPUESTO '||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
  --
  END F_GET_VALOR_IMPUESTO;


  FUNCTION F_GET_DESCRIPCION_FACTURA(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_UsrCreacion IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE
  IS
    --
    CURSOR Lc_GetDescripcion(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                             Cv_UsrCreacion DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE) IS

      SELECT IDH.OBSERVACION
      FROM   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
             DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
      WHERE  IDH.DOCUMENTO_ID   = IDFC.ID_DOCUMENTO
      AND    IDFC.ID_DOCUMENTO  = Cn_IdDocumento
      AND    IDH.USR_CREACION   = Cv_UsrCreacion
      AND    IDFC.ES_AUTOMATICA = 'N'
      AND    ROWNUM             = 1;
    --
     Lv_GetDescripcion DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE;
    --
  BEGIN
  --
    IF Lc_GetDescripcion%ISOPEN THEN
    --
      CLOSE Lc_GetDescripcion;
    --
    END IF;
  --
    OPEN Lc_GetDescripcion(Fn_IdDocumento,Fv_UsrCreacion);
  --
    FETCH
      Lc_GetDescripcion
    INTO
      Lv_GetDescripcion;
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
    DBMS_OUTPUT.PUT_LINE('F_GET_DESCRIPCION_FACTURA'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_DESCRIPCION_FACTURA;

  FUNCTION F_GET_FORMA_PAGO_CONTRATO(Fn_IdPersonaEmpresaRol    NUMBER)
    RETURN DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE
  IS
    --
    CURSOR Lc_GetFormaPago(Cn_IdPersonaEmpresaRol NUMBER)
    IS
      SELECT AFP.DESCRIPCION_FORMA_PAGO
      FROM   DB_COMERCIAL.INFO_CONTRATO IC
      JOIN   DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IC.PERSONA_EMPRESA_ROL_ID=IPER.ID_PERSONA_ROL
      JOIN   DB_GENERAL.ADMI_FORMA_PAGO AFP ON IC.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO
      WHERE  IC.ESTADO='Activo' AND IPER.ID_PERSONA_ROL=Cn_IdPersonaEmpresaRol;
    --
    Lv_GetFormaPago  DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE;
    --
  BEGIN
    --
    IF Lc_GetFormaPago%ISOPEN THEN
      --
      CLOSE Lc_GetFormaPago;
      --
    END IF;
    --
    OPEN Lc_GetFormaPago(Fn_IdPersonaEmpresaRol);
    --
    FETCH Lc_GetFormaPago INTO Lv_GetFormaPago;
    --
    CLOSE Lc_GetFormaPago;
    IF Lv_GetFormaPago IS NULL THEN
      Lv_GetFormaPago  := '';
    END IF;
    --
    RETURN Lv_GetFormaPago;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DBMS_OUTPUT.PUT_LINE('F_GET_FORMA_PAGO_CONTRATO'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_FORMA_PAGO_CONTRATO;

  FUNCTION F_GET_FECHA_PAGOS_APLICA_ND(
    Fn_IdDocumento NUMBER)
  RETURN VARCHAR2
  IS
  --
    CURSOR Lc_GetFechaPagosAplicaNd(Cn_IdDocumento NUMBER)
    IS
      SELECT LISTAGG (TO_CHAR(IPC.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS'), '|') WITHIN GROUP (
      ORDER BY IPC.NUMERO_PAGO ) NUMERO_PAGO
      FROM INFO_DOCUMENTO_FINANCIERO_DET IDFD ,
           INFO_PAGO_CAB IPC ,
           INFO_PAGO_DET IPD
      WHERE IDFD.PAGO_DET_ID=IPD.ID_PAGO_DET
      AND IPD.PAGO_ID       = IPC.ID_PAGO
      AND IDFD.DOCUMENTO_ID = Cn_IdDocumento;
  --
    Lv_getFechaPagosAplicaNd VARCHAR2(1000);
  --
  BEGIN
  --
    IF Lc_GetFechaPagosAplicaNd%ISOPEN THEN
    --
      CLOSE Lc_GetFechaPagosAplicaNd;
    --
    END IF;
  --
    OPEN Lc_GetFechaPagosAplicaNd(Fn_IdDocumento);
  --
    FETCH Lc_GetFechaPagosAplicaNd INTO Lv_getFechaPagosAplicaNd;
  --
    CLOSE Lc_GetFechaPagosAplicaNd;
  --
    IF Lv_getFechaPagosAplicaNd IS NULL THEN
      Lv_getFechaPagosAplicaNd  := '';
    END IF;
    RETURN Lv_getFechaPagosAplicaNd;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_FECHA_PAGOS_APLICA_ND'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
  --
  END F_GET_FECHA_PAGOS_APLICA_ND;
  --
  --
  FUNCTION F_GET_BANCO_TC(
    Fn_BancoTipoCtaId NUMBER)
  RETURN VARCHAR2
    --
  IS
      --
    CURSOR Lc_GetBanco(Cn_BancoTipoCtaId NUMBER)
    IS
      SELECT  AB.DESCRIPCION_BANCO
      FROM    DB_GENERAL.ADMI_BANCO AB,
              DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC
      WHERE   AB.ID_BANCO = ABTC.BANCO_ID  AND
              ABTC.ID_BANCO_TIPO_CUENTA  =Cn_BancoTipoCtaId;
      --
       Lv_GetBanco DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE;
      --
  BEGIN
      --
    IF Lc_GetBanco%ISOPEN THEN
        --
      CLOSE Lc_GetBanco;
        --
    END IF;
      --
    OPEN Lc_GetBanco(Fn_BancoTipoCtaId);
    --
    FETCH
      Lc_GetBanco
    INTO
      Lv_GetBanco;
    --
    CLOSE Lc_GetBanco;

    IF Lv_GetBanco IS NULL THEN
      Lv_GetBanco  := '';
    END IF;
    --
    RETURN Lv_GetBanco;
    --
    EXCEPTION
    WHEN OTHERS THEN
    --
    DBMS_OUTPUT.PUT_LINE('F_GET_BANCO_TC'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_BANCO_TC;
  --
  --

  FUNCTION F_GET_DESCRIPCION_FACTURA_DET(
      Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE
  IS
    --
    CURSOR Lc_GetDescripcion(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT NVL(IDFD.OBSERVACIONES_FACTURA_DETALLE,'')
      FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
      WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento
      AND ROWNUM              = 1;
    --
    Lv_GetDescripcion DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE;
    --
  BEGIN
    --
    IF Lc_GetDescripcion%ISOPEN THEN
      --
      CLOSE Lc_GetDescripcion;
      --
    END IF;
    --
    OPEN Lc_GetDescripcion(Fn_IdDocumento);
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
    DBMS_OUTPUT.PUT_LINE('F_GET_DESCRIPCION_FACTURA_DET'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_DESCRIPCION_FACTURA_DET;
  --
  --
  FUNCTION F_GET_MOTIVO_POR_ESTADO(
      Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_EstadoDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
      Fv_EstadoHistorial IN INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE)
    RETURN DB_COMERCIAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE
  IS
    --
    CURSOR Lc_GetMotivoDocumento(Cn_IdDocumento     INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                 Cv_EstadoDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                                 Cv_EstadoHistorial INFO_DOCUMENTO_HISTORIAL.ESTADO%TYPE)
    IS
      SELECT NVL(AM.NOMBRE_MOTIVO,'')
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH ON IDFC.ID_DOCUMENTO = IDH.DOCUMENTO_ID
      JOIN DB_GENERAL.ADMI_MOTIVO AM                  ON IDH.MOTIVO_ID     = AM.ID_MOTIVO
      WHERE IDH.DOCUMENTO_ID         = Cn_IdDocumento
      AND IDFC.ESTADO_IMPRESION_FACT = Cv_EstadoDocumento
      AND IDH.ESTADO                 = Cv_EstadoHistorial
      AND IDH.MOTIVO_ID             IS NOT NULL;
    --
    Lv_GetMotivoDocumento DB_COMERCIAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE;
    --
  BEGIN
    --
    IF Lc_GetMotivoDocumento%ISOPEN THEN
      --
      CLOSE Lc_GetMotivoDocumento;
      --
    END IF;
    --
    OPEN Lc_GetMotivoDocumento(Fn_IdDocumento,Fv_EstadoDocumento,Fv_EstadoHistorial);
    --
    FETCH Lc_GetMotivoDocumento INTO Lv_GetMotivoDocumento;
    --
    CLOSE Lc_GetMotivoDocumento;
    --
    RETURN Lv_GetMotivoDocumento;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DBMS_OUTPUT.PUT_LINE('F_GET_MOTIVO_POR_ESTADO'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_MOTIVO_POR_ESTADO;
  --
  --
  FUNCTION F_GET_SUBTOTAL_IMPUESTO(
      Fn_IdDocumento        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fn_PorcentajeImpuesto IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.PORCENTAJE%TYPE,
      Fv_TipoImpuesto       IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE
  IS
    --
    CURSOR Lc_GetSubtotalImpuesto(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                  Cn_PorcentajeImpuesto DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.PORCENTAJE%TYPE,
                                  Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    IS
      SELECT ROUND(SUM((NVL(IDFD.CANTIDAD,0)*NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE,0))- NVL(IDFD.DESCUENTO_FACPRO_DETALLE,0)),2)
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID   = IDFC.ID_DOCUMENTO
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI ON IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
      JOIN DB_GENERAL.ADMI_IMPUESTO AI                      ON AI.ID_IMPUESTO      = IDFI.IMPUESTO_ID
      WHERE IDFC.ID_DOCUMENTO = Cn_IdDocumento
      AND IDFI.PORCENTAJE     = Cn_PorcentajeImpuesto
      AND AI.TIPO_IMPUESTO    = Cv_TipoImpuesto;
    --
    Ln_GetSubtotalImpuesto DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
    --
  BEGIN
    --
    IF Lc_GetSubtotalImpuesto%ISOPEN THEN
      --
      CLOSE Lc_GetSubtotalImpuesto;
      --
    END IF;
    --
    OPEN Lc_GetSubtotalImpuesto(Fn_IdDocumento,Fn_PorcentajeImpuesto,Fv_TipoImpuesto);
    --
    FETCH Lc_GetSubtotalImpuesto INTO Ln_GetSubtotalImpuesto;
    --
    CLOSE Lc_GetSubtotalImpuesto;
    --
    RETURN Ln_GetSubtotalImpuesto;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DBMS_OUTPUT.PUT_LINE('F_GET_SUBTOTAL_IMPUESTO'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_SUBTOTAL_IMPUESTO;

  /**
  * Documentacion para la funcion F_GET_DIFERENCIA_MESES_FECHAS
  * La funcion F_GET_DIFERENCIA_MESES_FECHAS Obtiene la diferencia en meses entre fechas
  *
  * @param  Fv_IdPersona    IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE Recibe Id de la persona
  * @param  Fv_CodEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Recibe codigo de la empresa
  * @param  Fv_TipoConsulta IN VARCHAR2 Recibe el tipo de Consulta que se realiza por (Activacion o Corte)
  * @return FLOAT           Retorna la diferencia en meses entre la fecha de Activacion o la fecha de Ultimo Corte y el Sysdate
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 06-12-2016
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 01-09-2017 Se omite insert de error debido a que no se puede realizar operaci�n dml en una consulta.
  */
  FUNCTION F_GET_DIFERENCIA_MESES_FECHAS(
    Fn_IdPersona    IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    Fv_CodEmpresa   IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Fv_TipoConsulta IN VARCHAR2
    )
  RETURN FLOAT
  IS

  CURSOR C_GetFechaActivacionCliente(Cn_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                     Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT TO_CHAR(MIN(HIST.FE_CREACION),'DD-MM-YY')
    FROM
      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL HIST,
      DB_COMERCIAL.INFO_SERVICIO SERV,
      DB_COMERCIAL.INFO_PUNTO PTO,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEMPROL,
      DB_COMERCIAL.INFO_EMPRESA_ROL EMPROL,
      DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP,
      DB_COMERCIAL.INFO_PERSONA PER
    WHERE HIST.ESTADO          = 'Activo'
    AND EMP.COD_EMPRESA        = Cv_CodEmpresa
    AND PER.ID_PERSONA         = Cn_IdPersona
    AND PEMPROL.PERSONA_ID     = PER.ID_PERSONA
    AND PEMPROL.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
    AND PEMPROL.EMPRESA_ROL_ID = EMPROL.ID_EMPRESA_ROL
    AND EMPROL.EMPRESA_COD     = EMP.COD_EMPRESA
    AND PTO.ID_PUNTO           = SERV.PUNTO_ID
    AND SERV.ID_SERVICIO       = HIST.SERVICIO_ID;
  --
  CURSOR C_GetFechaUltCorteCliente(Cn_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                   Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT TO_CHAR(MAX(HIST.FE_CREACION),'DD-MM-YY')
    FROM
      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL HIST,
      DB_COMERCIAL.INFO_SERVICIO SERV,
      DB_COMERCIAL.INFO_PUNTO PTO,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PEMPROL,
      DB_COMERCIAL.INFO_EMPRESA_ROL EMPROL,
      DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP,
      DB_COMERCIAL.INFO_PERSONA PER
    WHERE HIST.ESTADO          = 'In-Corte'
    AND EMP.COD_EMPRESA        = Cv_CodEmpresa
    AND PER.ID_PERSONA         = Cn_IdPersona
    AND PEMPROL.PERSONA_ID     = PER.ID_PERSONA
    AND PEMPROL.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
    AND PEMPROL.EMPRESA_ROL_ID = EMPROL.ID_EMPRESA_ROL
    AND EMPROL.EMPRESA_COD     = EMP.COD_EMPRESA
    AND PTO.ID_PUNTO           = SERV.PUNTO_ID
    AND SERV.ID_SERVICIO       = HIST.SERVICIO_ID;
  --
  Lt_FechaActivacion VARCHAR2(10);
  Lt_FechaUltCorte   VARCHAR2(10);
  Ln_DiferenciaMeses NUMBER := 0;
  --
  BEGIN
  IF Fv_TipoConsulta = 'PorActivacion' THEN
    IF C_GetFechaActivacionCliente%ISOPEN THEN
      CLOSE C_GetFechaActivacionCliente;
    END IF;

    OPEN C_GetFechaActivacionCliente(Fn_IdPersona,Fv_CodEmpresa);
    FETCH C_GetFechaActivacionCliente INTO Lt_FechaActivacion;
    IF Lt_FechaActivacion IS NOT NULL THEN
      Ln_DiferenciaMeses := MONTHS_BETWEEN(TO_DATE(SYSDATE,'DD-MM-YY'),TO_DATE(Lt_FechaActivacion,'DD-MM-YY'));
    END IF;
    CLOSE C_GetFechaActivacionCliente;

  ELSIF Fv_TipoConsulta = 'PorUltCorte' THEN
    IF C_GetFechaUltCorteCliente%ISOPEN THEN
      CLOSE C_GetFechaUltCorteCliente;
    END IF;

    OPEN C_GetFechaUltCorteCliente(Fn_IdPersona,Fv_CodEmpresa);
    FETCH C_GetFechaUltCorteCliente INTO Lt_FechaUltCorte;
    IF Lt_FechaUltCorte IS NOT NULL THEN
       Ln_DiferenciaMeses := MONTHS_BETWEEN(TO_DATE(SYSDATE,'DD-MM-YY'),TO_DATE(Lt_FechaUltCorte,'DD-MM-YY'));
    END IF;
    CLOSE C_GetFechaUltCorteCliente;

  END IF;
  --
  RETURN Ln_DiferenciaMeses;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
  --
  IF (C_GetFechaActivacionCliente%ISOPEN) THEN
    CLOSE C_GetFechaActivacionCliente;
  END IF;
  IF (C_GetFechaUltCorteCliente%ISOPEN) THEN
    CLOSE C_GetFechaUltCorteCliente;
  END IF;
  RETURN NULL;

  END F_GET_DIFERENCIA_MESES_FECHAS;
  --
  --
  FUNCTION F_GET_NUMERO_COMPROBANTE(
      Fn_IdPagoDet       IN DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE,
      Fv_CodigoFormaPago IN DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
      Fv_InsertarError   IN VARCHAR2 DEFAULT 'S')
    RETURN VARCHAR2
  IS
    --
    -- CURSOR QUE RETORNA EL NUMERO DE DOCUMENTO DEL HISTORIAL DEL DEBITO ASOCIADO AL DETALLE DEL PAGO
    CURSOR C_GetNumeroDocumento(Cn_IdPagoDet DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE)
    IS
      --
      SELECT
        IDGH.NUMERO_DOCUMENTO
      FROM
        DB_FINANCIERO.INFO_PAGO_DET IPD
      JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC
      ON
        IPD.PAGO_ID = IPC.ID_PAGO
      JOIN DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL IDGH
      ON
        IDGH.ID_DEBITO_GENERAL_HISTORIAL = IPC.DEBITO_GENERAL_HISTORIAL_ID
      WHERE
        IPD.ID_PAGO_DET = Cn_IdPagoDet;
    --
    -- CURSOR QUE RETORNA EL NUMERO DE COMPROBANTE DEL DEPOSITO ASOCIADO AL DETALLE DEL PAGO
    CURSOR C_GetComprobanteDeposito(Cn_IdPagoDet DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE)
    IS
      --
      SELECT
        IDE.NO_COMPROBANTE_DEPOSITO
      FROM
        DB_FINANCIERO.INFO_PAGO_DET IPD
      JOIN DB_FINANCIERO.INFO_DEPOSITO IDE
      ON
        IPD.DEPOSITO_PAGO_ID = IDE.ID_DEPOSITO
      AND IPD.DEPOSITADO     = 'S'
      WHERE
        IPD.ID_PAGO_DET = Cn_IdPagoDet;
    --
    -- CURSOR QUE RETORNA EL NUMERO DE REFERENCIA O NUMERO DE CUENTA DEL BANCO ASOCIADO AL DETALLE DEL PAGO
    CURSOR C_GetReferenciaNumCtaBanco(Cn_IdPagoDet DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE)
    IS
      --
      SELECT
        NVL(IPD.NUMERO_REFERENCIA, IPD.NUMERO_CUENTA_BANCO)
      FROM
        DB_FINANCIERO.INFO_PAGO_DET IPD
      WHERE
        IPD.ID_PAGO_DET = Cn_IdPagoDet;
    --
    Lv_NumeroComprobante VARCHAR2(50);
    --
  BEGIN
    --
    -- CUANDO LA FORMA DE PAGO ES DEBITO SE DEBE CONSULTAR EL NUMERO DEL DOCUMENTO DEL HISTORIAL DEL DEBITO ASOCIADO AL DETALLE DEL PAGO
    IF TRIM(Fv_CodigoFormaPago) IS NOT NULL AND TRIM(Fv_CodigoFormaPago) = 'DEB' THEN
      --
      IF C_GetNumeroDocumento%ISOPEN THEN
        CLOSE C_GetNumeroDocumento;
      END IF;
      --
      --
      OPEN C_GetNumeroDocumento(Fn_IdPagoDet);
      --
      FETCH C_GetNumeroDocumento INTO Lv_NumeroComprobante;
      --
      CLOSE C_GetNumeroDocumento;
      --
    ELSE
      --
      -- PARA LAS DEMAS FORMAS DE PAGO SE DEBE OBTENER EL COMPROBANTE DEL DEPOSITO SI EL DETALLE DEL PAGO FUE DEPOSITADO
      IF C_GetComprobanteDeposito%ISOPEN THEN
        CLOSE C_GetComprobanteDeposito;
      END IF;
      --
      --
      OPEN C_GetComprobanteDeposito(Fn_IdPagoDet);
      --
      FETCH C_GetComprobanteDeposito INTO Lv_NumeroComprobante;
      --
      CLOSE C_GetComprobanteDeposito;
      --
      -- SI NO SE ENCUENTRA COMPROBANTE DE DEPOSITO, SE DEBE BUSCAR EL NUMERO DE REFERENCIA O NUMERO DE CUENTA DEL BANCO ASOCIADO AL DETALLE DEL PAGO
      IF TRIM(Lv_NumeroComprobante) IS NULL THEN
        --
        IF C_GetReferenciaNumCtaBanco%ISOPEN THEN
          CLOSE C_GetReferenciaNumCtaBanco;
        END IF;
        --
        --
        OPEN C_GetReferenciaNumCtaBanco(Fn_IdPagoDet);
        --
        FETCH C_GetReferenciaNumCtaBanco INTO Lv_NumeroComprobante;
        --
        CLOSE C_GetReferenciaNumCtaBanco;
        --
      END IF;
      --
    END IF;
    --
    --
    RETURN Lv_NumeroComprobante;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_NumeroComprobante := NULL;
    --
    IF Fv_InsertarError = 'S' THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                            'FNCK_CONSULTS.F_GET_NUMERO_COMPROBANTE',
                                            'Error en FNCK_CONSULTS.F_GET_NUMERO_COMPROBANTE - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                            ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    ELSE
      DBMS_OUTPUT.PUT_LINE('F_GET_NUMERO_COMPROBANTE'||
                           ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                           ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END IF;

    --
    RETURN Lv_NumeroComprobante;
    --
  END F_GET_NUMERO_COMPROBANTE;
  --
  --

  FUNCTION F_GET_SUBTOTAL_CERO_IMPUESTO(
      Fn_IdDocumento        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE
  IS
    --
    CURSOR Lc_GetSubtotalImpuesto(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT    ROUND(SUM((NVL(IDFD.CANTIDAD,0)*NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE,0))- NVL(IDFD.DESCUENTO_FACPRO_DETALLE,0)),2)
      FROM      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID   = IDFC.ID_DOCUMENTO
      WHERE     NOT EXISTS (
                            SELECT *
                            FROM   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI
                            WHERE  IDFI.DETALLE_DOC_ID = IDFD.ID_DOC_DETALLE
                           )
      AND       IDFC.ID_DOCUMENTO = Cn_IdDocumento;
    --
    Ln_GetSubtotalImpuesto DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
    --
  BEGIN
    --
    IF Lc_GetSubtotalImpuesto%ISOPEN THEN
      --
      CLOSE Lc_GetSubtotalImpuesto;
      --
    END IF;
    --
    OPEN Lc_GetSubtotalImpuesto(Fn_IdDocumento);
    --
    FETCH Lc_GetSubtotalImpuesto INTO Ln_GetSubtotalImpuesto;
    --
    CLOSE Lc_GetSubtotalImpuesto;
    --
    RETURN Ln_GetSubtotalImpuesto;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DBMS_OUTPUT.PUT_LINE('FNCK_CONSULTS.F_GET_SUBTOTAL_CERO_IMPUESTO, ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_SUBTOTAL_CERO_IMPUESTO;
  --
  --
  FUNCTION F_ESTADO_PUNTO(
      Fn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Fv_FeConsultaHasta    IN VARCHAR2)
    RETURN DB_COMERCIAL.INFO_PUNTO_HISTORIAL.VALOR%TYPE
  AS
    --
    -- CURSOR QUE RETORNA EL ESTADO DEL PUNTO DEPENDIENDO DEL HISTORIAL DEL PUNTO
    CURSOR C_GetEstadoPunto( Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                             Cv_FeConsultaHasta VARCHAR2,
                             Cv_ValorPunto DB_COMERCIAL.INFO_PUNTO_HISTORIAL.VALOR%TYPE )
    IS
      --
      SELECT
        CASE
          WHEN (NVL(INSTR(VALOR,'|'), 0) - NVL(INSTR(VALOR,'ACTUAL:')+7, 0)) > 0 THEN
            TRIM(SUBSTR(VALOR, INSTR(VALOR, 'ACTUAL:')+7, (NVL(INSTR(VALOR,'|'), 0) - NVL(INSTR(VALOR,'ACTUAL:')+7, 0))))
          ELSE
            TRIM(SUBSTR(VALOR, INSTR(VALOR, 'ACTUAL:')+7, LENGTH(VALOR)))
        END AS ESTADO
      FROM
        DB_COMERCIAL.INFO_PUNTO_HISTORIAL IPH
      WHERE
        IPH.ID_PUNTO_HISTORIAL =
        (
          SELECT
            MAX(IPH_S.ID_PUNTO_HISTORIAL)
          FROM
            DB_COMERCIAL.INFO_PUNTO_HISTORIAL IPH_S
          WHERE
            IPH_S.PUNTO_ID = Cn_IdPuntoFacturacion
          AND IPH_S.VALOR LIKE Cv_ValorPunto
          AND IPH_S.FE_CREACION < NVL2( Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                        CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1 )
        );
    --
    Lv_EstadoPunto DB_COMERCIAL.INFO_PUNTO_HISTORIAL.VALOR%TYPE;
    Lv_ValorPunto DB_COMERCIAL.INFO_PUNTO_HISTORIAL.VALOR%TYPE := '%ESTADO%';
    --
  BEGIN
    --
    -- SE CONSULTA EL ESTADO DEL PUNTO MEDIANTE EL CURSOR C_GetEstadoPunto
    IF C_GetEstadoPunto%ISOPEN THEN
      --
      CLOSE C_GetEstadoPunto;
      --
    END IF;
    --
    --
    OPEN C_GetEstadoPunto(Fn_IdPuntoFacturacion, Fv_FeConsultaHasta, Lv_ValorPunto);
    --
    FETCH
      C_GetEstadoPunto
    INTO
      Lv_EstadoPunto;
    --
    CLOSE C_GetEstadoPunto;
    --
    --
    RETURN Lv_EstadoPunto;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_EstadoPunto := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CARTERA_CLIENTES.F_ESTADO_PUNTO',
                                          'Error al consultar el estado del punto - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                          ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lv_EstadoPunto;
    --
  END F_ESTADO_PUNTO;
  --
  --
  FUNCTION F_GET_DESCRIPCION_PERIODO_FACT(
      Fn_FrecuenciaProducto IN  DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE)
    RETURN VARCHAR2
  AS
    --
    Lv_DescripcionPeriodoFacturado VARCHAR2(100) := NULL;
    --
  BEGIN
    --
    IF Fn_FrecuenciaProducto IS NOT NULL AND Fn_FrecuenciaProducto > 0 THEN
      --
      SELECT
        CONCAT( CONCAT( INITCAP(TRIM(TO_CHAR( SYSDATE, 'MONTH','NLS_DATE_LANGUAGE=SPANISH'))),
                        CONCAT( ' ', TRIM(TO_CHAR(SYSDATE, 'YYYY')))),
                CONCAT( ' - ', CONCAT( INITCAP(TRIM( TO_CHAR(ADD_MONTHS(SYSDATE, Fn_FrecuenciaProducto), 'MONTH', 'NLS_DATE_LANGUAGE=SPANISH'))),
                                       CONCAT( ' ', TRIM(TO_CHAR(ADD_MONTHS(SYSDATE, Fn_FrecuenciaProducto), 'YYYY'))) ) ) )
      INTO
        Lv_DescripcionPeriodoFacturado
      FROM
        DUAL;
      --
    END IF;
    --
    --
    RETURN Lv_DescripcionPeriodoFacturado;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_DescripcionPeriodoFacturado := NULL;
    --
    DBMS_OUTPUT.PUT_LINE('FNCK_CONSULTS.F_GET_DESCRIPCION_PERIODO_FACT - Error al retornar la descripcion del periodo facturado - ERROR_STACK: '
                         || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    --
    RETURN Lv_DescripcionPeriodoFacturado;
    --
  END F_GET_DESCRIPCION_PERIODO_FACT;

  FUNCTION F_GET_EJECUCION_COMPROBANTES(Pv_NombreParametro IN VARCHAR2 DEFAULT 'PROCESOS_FACTURACION_MASIVA')
    RETURN NUMBER
  AS
    Lrf_AdmiParametroDet     SYS_REFCURSOR;
    Lr_AdmiParametroDet      DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    Ln_PuedeEjecutarse       NUMBER := 1;
  BEGIN
    --OBTENGO LOS PAR�METROS CON LAS EMPRESAS QUE APLICAN AL PROCESO DEL JOB.
        Lrf_AdmiParametroDet := DB_GENERAL.GNRLPCK_UTIL.F_GET_PARAMS_DETS(Pv_NombreParametro);
        LOOP
            FETCH Lrf_AdmiParametroDet INTO Lr_AdmiParametroDet;
            EXIT WHEN Lrf_AdmiParametroDet%NOTFOUND;

            --SE VALIDA SI EXISTE UNA INSTANCIA EN EJECUCI�N DEL JOB EN EL PAR�METRO.
            IF DB_FINANCIERO.FNCK_CONSULTS.F_GET_ESTADO_EJECUCION_JOB(Pv_NombreJob => Lr_AdmiParametroDet.VALOR1) = 1 THEN
                --SI EL JOB DEL PAR�METRO SE EST� EJECUTANDO, NO PUEDE EJECUTARSE EL JOB DE COMPROBANTES
                Ln_PuedeEjecutarse := 0;
            END IF;
        END LOOP;
        CLOSE Lrf_AdmiParametroDet;
    -- SI NO FINALIZA ANTES, ES PORQUE SE PUEDE EJECUTAR EL JOB
    RETURN Ln_PuedeEjecutarse;
  END F_GET_EJECUCION_COMPROBANTES;

  FUNCTION F_GET_ESTADO_EJECUCION_JOB(Pv_NombreJob IN VARCHAR2,
                                      Pv_EstadoJob IN VARCHAR2 DEFAULT 'RUNNING')
    RETURN NUMBER
  AS
    CURSOR C_ObtieneJobsPorEstado (Cv_NombreJob VARCHAR2, Cv_EstadoJob VARCHAR2) IS
      SELECT ASRJ.JOB_NAME, ASJ.STATE
        FROM ALL_SCHEDULER_RUNNING_JOBS ASRJ,
             ALL_SCHEDULER_JOBS ASJ
       WHERE UPPER(ASRJ.JOB_NAME) LIKE Cv_NombreJob
         AND ASRJ.JOB_NAME = ASJ.JOB_NAME
         AND ASJ.STATE = Pv_EstadoJob;
    Lv_CaracterPorcentaje VARCHAR2(1) := '%';
    Ln_ExisteJob          NUMBER := 0;
  BEGIN
    FOR Lr_Jobs IN C_ObtieneJobsPorEstado (Cv_NombreJob => Lv_CaracterPorcentaje || UPPER(Pv_NombreJob) || Lv_CaracterPorcentaje,
                                           Cv_EstadoJob => UPPER(Pv_EstadoJob))
    LOOP
        Ln_ExisteJob := 1;
    END LOOP;
    RETURN Ln_ExisteJob;
  END F_GET_ESTADO_EJECUCION_JOB;

  PROCEDURE P_ESTADO_CTA_CLIENTE(
    Pv_EmpresaCod                   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pn_PersonaId                    IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.PERSONA_ID%TYPE,
    Pv_FechaEmisionDesde            IN  VARCHAR2,
    Pv_FechaEmisionHasta            IN  VARCHAR2,
    Pn_TotalRegistros               OUT NUMBER,
    Pc_Documentos                   OUT SYS_REFCURSOR
  )
  IS

    Lv_QueryFechasA     CLOB;

    Lv_QueryFechasB     CLOB;

    Lv_QuerySelectA     CLOB;
    --
    Lv_QueryFromA       CLOB;

    Lv_QuerySelectB     CLOB;
    --
    Lv_QueryFromB       CLOB;
    --
    Lv_QueryCount       CLOB;

    Lv_QueryUnion       CLOB;

    Lv_LimitAllColumns  CLOB;

    Lv_QueryAllColumns  CLOB;

  --
  BEGIN

     Lv_QueryFechasA := ' ';
     Lv_QueryFechasB := ' ';

    IF Pv_FechaEmisionDesde IS NOT NULL AND  Pv_FechaEmisionHasta IS  NOT NULL THEN
      Lv_QueryFechasA := '  AND IDFC.FE_EMISION BETWEEN TO_DATE('''||Pv_FechaEmisionDesde||''',''DD/MM/YY'')
                                                     AND TO_DATE('''||Pv_FechaEmisionHasta||''',''DD/MM/YY'')' ;

      Lv_QueryFechasB := '  AND IPC.FE_CREACION BETWEEN TO_DATE('''||Pv_FechaEmisionDesde||''',''DD/MM/YY'')
                                                    AND TO_DATE('''||Pv_FechaEmisionHasta||''',''DD/MM/YY'')' ;
    END IF;
    Lv_QueryCount      :='SELECT ID_DOCUMENTO ';
    Lv_QuerySelectA    :='SELECT * FROM (SELECT ROWNUM ID_QUERY,
                                 IDFC.ID_DOCUMENTO AS ID_DOCUMENTO,
                                 IDFC.PUNTO_ID,
                                 IDFC.OFICINA_ID,
                                 IDFC.NUMERO_FACTURA_SRI,
                                 IDFC.TIPO_DOCUMENTO_ID,
                                 IDFC.VALOR_TOTAL,
                                 CASE
                                   WHEN IDFC.FE_AUTORIZACION IS NULL THEN IDFC.FE_EMISION
                                   ELSE IDFC.FE_AUTORIZACION
                                 END AS FE_CREACION,                                 

                                 TO_CHAR(IDFC.FE_CREACION, ''DD/MM/YYYY HH24:MI'') AS FEC_CREACION,
                                 TO_CHAR(IDFC.FE_EMISION, ''DD/MM/YYYY HH24:MI'') AS FEC_EMISION,
                                 TO_CHAR(IDFC.FE_AUTORIZACION, ''DD/MM/YYYY HH24:MI'') AS FEC_AUTORIZACION,
                                 IDFC.USR_CREACION,
                                 '''' AS REFERENCIA,
                                 '''' AS CODIGO_FORMA_PAGO,
                                 IDFC.ESTADO_IMPRESION_FACT,
                                 '''' AS NUMERO_REFERENCIA,
                                 '''' AS NUMERO_CUENTA_BANCO,
                                 IDFC.REFERENCIA_DOCUMENTO_ID AS REFERENCIA_ID,
                                 CASE
                                 WHEN IEG.PREFIJO=''MD'' THEN NULL
                                 ELSE IDFC.NUM_FACT_MIGRACION
                                 END AS MIGRACION,
                                 0 AS REF_ANTICIPO_ID,
                                 ATDF.CODIGO_TIPO_DOCUMENTO,
                                 ATDF.MOVIMIENTO,
                                 '''' AS PAGO_TIENE_DEPENDENCIA,
                                 DB_FINANCIERO.FNCK_CONSULTS.F_GET_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, ATDF.CODIGO_TIPO_DOCUMENTO ) AS SALDO_ACT_DOCUMENTO ';

       Lv_QueryFromA  := ' FROM   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                           JOIN   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
                           JOIN   DB_COMERCIAL.INFO_OFICINA_GRUPO              IOG  ON IOG.ID_OFICINA         = IDFC.OFICINA_ID
                           JOIN   DB_COMERCIAL.INFO_EMPRESA_GRUPO              IEG  ON IOG.EMPRESA_ID         = IEG.COD_EMPRESA
                           WHERE  IDFC.ESTADO_IMPRESION_FACT NOT IN (''Inactivo'', ''Anulado'',''Anulada'',''Rechazada'',
                                                                     ''Pendiente'',''Eliminado'',''Rechazado'',''Aprobada'') '|| Lv_QueryFechasA ||'
                           AND    EXISTS  (
                                                   SELECT 1
                                                   FROM   INFO_PUNTO P,
                                                          INFO_PERSONA_EMPRESA_ROL IPER,
                                                          INFO_EMPRESA_ROL ER
                                                   WHERE  ER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID
                                                   AND    P.PERSONA_EMPRESA_ROL_ID=IPER.ID_PERSONA_ROL
                                                   AND    ER.EMPRESA_COD  = '||Pv_EmpresaCod||'
                                                   AND    IPER.PERSONA_ID = '||Pn_PersonaId ||'
                                                   AND    P.ID_PUNTO      = IDFC.PUNTO_ID
                                                 ) ORDER BY ID_DOCUMENTO )';
       Lv_QueryUnion   :=' UNION ALL ';

       Lv_QuerySelectB :=' SELECT * FROM (SELECT ROWNUM ID_QUERY,
                                    IPD.ID_PAGO_DET AS ID_DOCUMENTO,
                                    IPC.PUNTO_ID,
                                    IPC.OFICINA_ID,
                                    IPC.NUMERO_PAGO,
                                    IPC.TIPO_DOCUMENTO_ID,
                                    IPD.VALOR_PAGO,
                                    CASE
                                      WHEN IPC.FE_CRUCE IS NULL THEN IPC.FE_CREACION
                                      ELSE IPC.FE_CRUCE
                                    END AS FE_CREACION,
                                    CASE
                                      WHEN IPC.FE_CRUCE IS NULL THEN TO_CHAR(IPC.FE_CREACION , ''DD/MM/YYYY HH24:MI'')
                                      ELSE TO_CHAR(IPC.FE_CRUCE  , ''DD/MM/YYYY HH24:MI'')
                                    END AS FEC_CREACION,
                                    '''' AS FEC_EMISION,
                                    '''' AS FEC_AUTORIZACION,
                                    IPC.USR_CREACION,
                                    '''' AS NUMERO_FACTURA_SRI,
                                    AFP.CODIGO_FORMA_PAGO,
                                    IPC.ESTADO_PAGO,
                                    IPD.NUMERO_REFERENCIA,
                                    IPD.NUMERO_CUENTA_BANCO,
                                    IPD.REFERENCIA_ID,
                                    CASE
                                    WHEN IEG.PREFIJO=''MD'' THEN NULL
                                    ELSE IPC.NUM_PAGO_MIGRACION
                                    END AS MIGRACION,
                                    IPC.ANTICIPO_ID  AS REF_ANTICIPO_ID,
                                    ATDF.CODIGO_TIPO_DOCUMENTO,
                                    ATDF.MOVIMIENTO,
                                    DB_FINANCIERO.FNCK_CONSULTS.F_GET_PAGO_DEPENDIENTE( IPC.EMPRESA_ID, ATDF.CODIGO_TIPO_DOCUMENTO, IPC.PUNTO_ID, IPC.ID_PAGO) AS PAGO_TIENE_DEPENDENCIA,
                                    0 AS SALDO_ACT_DOCUMENTO ';
       Lv_QueryFromB  := ' FROM   DB_FINANCIERO.INFO_PAGO_CAB IPC
                           JOIN   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IPC.TIPO_DOCUMENTO_ID
                           JOIN   DB_FINANCIERO.INFO_PAGO_DET                  IPD  ON IPC.ID_PAGO            = IPD.PAGO_ID
                           JOIN   DB_GENERAL.ADMI_FORMA_PAGO                   AFP  ON IPD.FORMA_PAGO_ID      = AFP.ID_FORMA_PAGO
                           JOIN   DB_COMERCIAL.INFO_OFICINA_GRUPO              IOG  ON IOG.ID_OFICINA         = IPC.OFICINA_ID
                           JOIN   DB_COMERCIAL.INFO_EMPRESA_GRUPO              IEG  ON IOG.EMPRESA_ID         = IEG.COD_EMPRESA
                           WHERE  IPC.ESTADO_PAGO NOT IN (''Inactivo'', ''Anulado'',''Asignado'') '|| Lv_QueryFechasB || '
                           AND    EXISTS  (
                                              SELECT 1
                                              FROM INFO_PUNTO P,
                                                   INFO_PERSONA_EMPRESA_ROL IPER,
                                                   INFO_EMPRESA_ROL ER
                                              WHERE ER.ID_EMPRESA_ROL        = IPER.EMPRESA_ROL_ID
                                                AND P.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                                                AND ER.EMPRESA_COD           = '||Pv_EmpresaCod||'
                                                AND IPER.PERSONA_ID          = '||Pn_PersonaId||'
                                                AND P.ID_PUNTO               = IPC.PUNTO_ID
                                          ) ORDER BY ID_DOCUMENTO ';


   Lv_LimitAllColumns := ' ) ';

   Lv_QueryAllColumns := 'SELECT * FROM ('|| Lv_QuerySelectA || Lv_QueryFromA || Lv_QueryUnion || Lv_QuerySelectB
                                          || Lv_QueryFromB || Lv_LimitAllColumns||') TB ORDER BY TB.FE_CREACION ';


   DBMS_OUTPUT.PUT_LINE(Lv_QueryAllColumns);

   Lv_QueryCount      :=  Lv_QueryCount  || ' FROM ('||Lv_QuerySelectA || Lv_QueryFromA || Lv_QueryUnion || Lv_QuerySelectB ||
                          Lv_QueryFromB  || Lv_LimitAllColumns|| ')';



  OPEN Pc_Documentos FOR Lv_QueryAllColumns;

  Pn_TotalRegistros := FNKG_REPORTE_FINANCIERO.F_GET_COUNT_REFCURSOR(Lv_QueryCount);
  --
  --
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR(
                                                  'FNCK_CONSULTS',
                                                  'FNCK_CONSULTS.P_ESTADO_CTA_CLIENTE',
                                                  ' ERROR '||SQLERRM||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                  ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                 );
      --
  END P_ESTADO_CTA_CLIENTE;
  --
  FUNCTION F_GET_PAGO_DEPENDIENTE(
    Fv_EmpresaId           IN  DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE,
    Fv_CodigoTipoDocumento IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Fn_IdPunto             IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Fn_IdPago              IN  DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE
    )
  RETURN VARCHAR2
  IS
  CURSOR C_GetPagosPorDependienciaHisto(Cn_IdPago              DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                                        Cn_IdPunto             DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                        Cv_EmpresaId           DB_FINANCIERO.INFO_PAGO_LINEA.EMPRESA_ID%TYPE,
                                        Cv_NombreMotivo        DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
                                        Cv_EstadoMotivo        DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE)
  IS
    SELECT COUNT(IPH.ID_PAGO_HISTORIAL)
    FROM DB_FINANCIERO.INFO_PAGO_CAB IPC,
         DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH,
         DB_GENERAL.ADMI_MOTIVO AM
    WHERE IPC.ID_PAGO    = IPH.PAGO_ID
    AND   IPH.MOTIVO_ID  = AM.ID_MOTIVO
    AND   IPC.ID_PAGO    = Cn_IdPago
    AND   IPC.PUNTO_ID   = Cn_IdPunto
    AND   IPC.EMPRESA_ID = Cv_EmpresaId
    AND   IPH.MOTIVO_ID  = ( SELECT AM.ID_MOTIVO
                              FROM DB_GENERAL.ADMI_MOTIVO AM
                              WHERE AM.NOMBRE_MOTIVO = Cv_NombreMotivo
                              AND   AM.ESTADO        = Cv_EstadoMotivo);
  --
  CURSOR C_GetPrefijoEmpresa(Cn_IdPago DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE)
  IS
    SELECT EMP.PREFIJO
    FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP ON IPC.empresa_id=EMP.cod_empresa
    WHERE IPC.id_pago = Cn_IdPago;
  --
  Lrf_GetAdmiParamtrosDet SYS_REFCURSOR;
  Lr_GetAdmiParamtrosDet  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_NombreParametroCab   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'PROCESO CONTABILIZACION EMPRESA';
  Lv_EstadoActivo         DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
  Lv_PrefijoEmpresa       DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  --
  Lv_NombreMotivo         DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE                 := 'ANULACION_DEPENCIA';
  Lv_EstadoMotivo         DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE                        := 'Activo';
  Ln_CountPagoDependiente NUMBER                                                    := 0;
  Lv_PagoTieneDependiente VARCHAR2(1)                                               := 'N' ;
  --
  BEGIN
  --
  IF Fv_CodigoTipoDocumento  = 'PAG'  OR  Fv_CodigoTipoDocumento = 'PAGC' OR
     Fv_CodigoTipoDocumento  = 'ANT'  OR  Fv_CodigoTipoDocumento = 'ANTC' OR
     Fv_CodigoTipoDocumento  = 'ANTS' THEN

      --
      IF C_GetPrefijoEmpresa%ISOPEN THEN
        CLOSE C_GetPrefijoEmpresa;
      END IF;
      --
      OPEN C_GetPrefijoEmpresa(Fn_IdPago);
      --
      FETCH C_GetPrefijoEmpresa INTO Lv_PrefijoEmpresa;
      --
      CLOSE C_GetPrefijoEmpresa;
      --
      --
      --Busca el dia hasta el cual se podr� ingresar pagos, anticipos y/o procesar dep�sitos
      Lrf_GetAdmiParamtrosDet := FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_NombreParametroCab,
                                                                         Lv_EstadoActivo,
                                                                         Lv_EstadoActivo,
                                                                         Lv_PrefijoEmpresa,
                                                                         NULL,
                                                                         NULL,
                                                                         NULL);
      --
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      --
      CLOSE Lrf_GetAdmiParamtrosDet;
      --
      --Si la variable no es nula existe parametro no permitido mapeado
      IF Lr_GetAdmiParamtrosDet.ID_PARAMETRO_DET IS NOT NULL AND
         TRIM(Lr_GetAdmiParamtrosDet.VALOR2)     IS NOT NULL AND
         TRIM(Lr_GetAdmiParamtrosDet.VALOR2)     = 'S'       THEN
          --
            IF C_GetPagosPorDependienciaHisto%ISOPEN THEN
              CLOSE C_GetPagosPorDependienciaHisto;
            END IF;
            --
            OPEN C_GetPagosPorDependienciaHisto( Fn_IdPago, Fn_IdPunto, Fv_EmpresaId,
                                                 Lv_NombreMotivo, Lv_EstadoMotivo);
            --
            FETCH C_GetPagosPorDependienciaHisto INTO Ln_CountPagoDependiente;
            --
            CLOSE C_GetPagosPorDependienciaHisto;
            --
            IF Ln_CountPagoDependiente > 0 THEN
              --
              Lv_PagoTieneDependiente := 'S';
              --
            END IF;
          --
      END IF;
  END IF;
  --
  RETURN Lv_PagoTieneDependiente;
  --
  EXCEPTION
    WHEN OTHERS THEN
      --
      FNCK_TRANSACTION.INSERT_ERROR('F_GET_PAGO_DEPENDIENTE',
                                    'FNCK_CONSULTS.F_GET_PAGO_DEPENDIENTE',
                                    'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN NULL;
  --
END F_GET_PAGO_DEPENDIENTE;
--
FUNCTION F_GET_SALDO_X_FACTURA(
    Fn_IdDocumento          IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Fv_CodigoTipoDocumento  IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE
    )
  RETURN NUMBER
    IS
      --
      Ln_Saldo        NUMBER;
      Lv_MsnError     VARCHAR2(1000);
      Lex_Exception   EXCEPTION;
      --
    BEGIN
      --
      Ln_Saldo        := 0;
      --
      IF Fv_CodigoTipoDocumento  = 'FAC'  OR  Fv_CodigoTipoDocumento = 'FACP' THEN
        --
        DB_FINANCIERO.FNCK_CONSULTS.P_SALDO_X_FACTURA(Fn_IdDocumento, NULL, Ln_Saldo, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;
        --
        Ln_Saldo := NVL( Ln_Saldo, 0);
        --
        IF Ln_Saldo > 0 THEN
          --
          Ln_Saldo := ROUND( Ln_Saldo, 2);
          --
        END IF;
        --
      END IF;
      --
      RETURN Ln_Saldo;
      --
    EXCEPTION
      WHEN Lex_Exception THEN
        --
        Ln_Saldo := 0;
        --
        FNCK_TRANSACTION.INSERT_ERROR('F_GET_SALDO_X_FACTURA',
                                      'FNCK_CONSULTS.F_GET_SALDO_X_FACTURA',
                                      'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        --
        RETURN Ln_Saldo;
        --
      WHEN OTHERS THEN
        --
        Ln_Saldo := 0;
        --
        FNCK_TRANSACTION.INSERT_ERROR('F_GET_SALDO_X_FACTURA',
                                      'FNCK_CONSULTS.F_GET_SALDO_X_FACTURA',
                                      'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RETURN Ln_Saldo;
        --
  END F_GET_SALDO_X_FACTURA;

  FUNCTION F_OBTIENE_IMPUESTOS_RIDE(
    Fn_IdDocumento          IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
    )
  RETURN VARCHAR2
    IS
    CURSOR C_OBTIENE_VALORES(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS
    SELECT
         TRIM(TO_CHAR(SUM(NVL(IMP.VALOR_IMPUESTO, 0)),'99999999990D99')) "VALOR",
        IMP.IMPUESTO_ID ,
        IMPUESTO.PRIORIDAD "PRIORIDAD",
        IMPUESTO.PORCENTAJE_IMPUESTO
    FROM
        INFO_DOCUMENTO_FINANCIERO_CAB CAB,
        INFO_DOCUMENTO_FINANCIERO_DET DET,
        INFO_DOCUMENTO_FINANCIERO_IMP IMP,
        DB_GENERAL.ADMI_IMPUESTO IMPUESTO
    WHERE
        ID_DOCUMENTO = Cn_IdDocumento
        AND   DET.DOCUMENTO_ID = CAB.ID_DOCUMENTO
        AND   DET.ID_DOC_DETALLE = IMP.DETALLE_DOC_ID
        AND   IMP.IMPUESTO_ID = IMPUESTO.ID_IMPUESTO
    GROUP BY
        IMP.IMPUESTO_ID,
        IMPUESTO.PRIORIDAD,
        IMPUESTO.PORCENTAJE_IMPUESTO
    ORDER BY IMPUESTO.PRIORIDAD;
    Lv_Retorno VARCHAR2(300) := '';
    Lr_InfoDocumentoFinanCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Ln_BaseImponibleIva    NUMBER:= 0;
    Lv_BanderaImpuesto VARCHAR2(1) := 'N';
    Lb_BanderaIce      VARCHAR2(1) := 'N';
  BEGIN
    Lr_InfoDocumentoFinanCab := FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Fn_IdDocumento, NULL);
    Lv_Retorno := '{"Pv_Subtotal":"'
        || TRIM(TO_CHAR(NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL - NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL_DESCUENTO, 0), 0),
                        '99999999990D99')) || '",' ;
    FOR FILAS IN C_OBTIENE_VALORES(Fn_IdDocumento)
    LOOP
        Lv_BanderaImpuesto := 'S';
        IF(FILAS.PRIORIDAD = 1) THEN
            Lv_Retorno := Lv_Retorno || '"Pv_Ice":":' || FILAS.VALOR || '",';
            Ln_BaseImponibleIva := NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL, 0) + FILAS.VALOR;
            Lb_BanderaIce   := 'S';
        END IF;
        IF(FILAS.PRIORIDAD = 2) THEN
            IF Lb_BanderaIce = 'N' THEN
                Ln_BaseImponibleIva := NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL, 0);
            END IF;
            Lv_Retorno := Lv_Retorno || '"Pv_Iva":"' || FILAS.VALOR || '",';
            Lv_Retorno := Lv_Retorno || '"Pv_PorcentajeIva":"' || FILAS.PORCENTAJE_IMPUESTO || ' %",';
        END IF;
    END LOOP;
    IF Lv_BanderaImpuesto = 'N' THEN
        IF Lr_InfoDocumentoFinanCab.SUBTOTAL_CERO_IMPUESTO IS NOT NULL THEN
            Lv_Retorno:= Lv_Retorno ||  '"Pv_SubtotalCeroImpuesto":"' ||
                         TRIM(TO_CHAR(NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL_CERO_IMPUESTO - NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL_DESCUENTO, 0),
                                      0),'99999999990D99')) || '",';
        ELSE
            Lv_Retorno:= Lv_Retorno ||  '"Pv_SubtotalCeroImpuesto":"'
                                    || TRIM(TO_CHAR(NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL - NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL_DESCUENTO, 0), 0),
                                            '99999999990D99')) || '",';
        END IF;
        Lv_Retorno := Lv_Retorno || '"Pv_SubtotalIva":0.00",';
    ELSE
        Lv_Retorno := Lv_Retorno || '"Pv_SubtotalIva":"' || TRIM(TO_CHAR(NVL(Ln_BaseImponibleIva - NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL_DESCUENTO, 0),
                                                                 0),'99999999990D99')) || '",';
        Lv_Retorno:= Lv_Retorno ||  '"Pv_SubtotalCeroImpuesto":"0.00",';
    END IF;
    Lv_Retorno := Lv_Retorno || '"Pv_Descuento":"' || TRIM(TO_CHAR(NVL(Lr_InfoDocumentoFinanCab.SUBTOTAL_DESCUENTO, 0),'99999999990D99')) || '",';
    Lv_Retorno := Lv_Retorno || '"Pv_ValorPagar":"' || TRIM(TO_CHAR(NVL(Lr_InfoDocumentoFinanCab.VALOR_TOTAL, 0),'99999999990D99')) || '"}';
    RETURN Lv_Retorno;
  END F_OBTIENE_IMPUESTOS_RIDE;
  --
  FUNCTION F_GET_CUENTA_BANCARIA ( Pn_IdCuentaContable IN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.ID_CUENTA_CONTABLE%TYPE,
                                   Pn_IdBancoTipoCta   IN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE,
                                   Pv_NoCia            IN DB_FINANCIERO.ADMI_CUENTA_CONTABLE.NO_CIA%TYPE
                                 )
                                 RETURN FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable IS
    CURSOR C_CUENTA_CONTABLE IS
      SELECT NO_CIA,
        NO_CTA,
        CUENTA,
        TABLA_REFERENCIAL,
        CAMPO_REFERENCIAL,
        VALOR_CAMPO_REFERENCIAL,
        NOMBRE_OBJETO_NAF,
        CENTRO_COSTO
      FROM DB_FINANCIERO.ADMI_CUENTA_CONTABLE
      WHERE ID_CUENTA_CONTABLE = Pn_IdCuentaContable;
    --
    -- cursor que recupera cuenta bancaria en base a banco tipo cuenta
    CURSOR C_BANCO_TIPO_CUENTA IS
      SELECT NO_CIA,
        NO_CTA,
        CUENTA,
        TABLA_REFERENCIAL,
        CAMPO_REFERENCIAL,
        VALOR_CAMPO_REFERENCIAL,
        NOMBRE_OBJETO_NAF,
        CENTRO_COSTO
      FROM DB_FINANCIERO.ADMI_CUENTA_CONTABLE ACC
      WHERE ACC.VALOR_CAMPO_REFERENCIAL = Pn_IdBancoTipoCta
      AND ACC.NO_CIA = Pv_NoCia
      AND ACC.TABLA_REFERENCIAL = 'ADMI_BANCO_TIPO_CUENTA'
      AND ACC.CAMPO_REFERENCIAL = 'ID_BANCO_TIPO_CUENTA';
    --
    Lr_CuentaBancaria FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    --
  BEGIN
    --
    IF Pn_IdCuentaContable IS NOT NULL THEN
      IF C_CUENTA_CONTABLE%ISOPEN THEN
        CLOSE C_CUENTA_CONTABLE;
      END IF;
      OPEN C_CUENTA_CONTABLE;
      FETCH C_CUENTA_CONTABLE INTO Lr_CuentaBancaria;
      CLOSE C_CUENTA_CONTABLE;

    ELSIF Pn_IdBancoTipoCta IS NOT NULL THEN
      IF C_BANCO_TIPO_CUENTA%ISOPEN THEN
        CLOSE C_BANCO_TIPO_CUENTA;
      END IF;
      OPEN C_BANCO_TIPO_CUENTA;
      FETCH C_BANCO_TIPO_CUENTA INTO Lr_CuentaBancaria;
      CLOSE C_BANCO_TIPO_CUENTA;

    END IF;
  --
    RETURN Lr_CuentaBancaria;
  --
  END;
  --


  FUNCTION F_GET_CTA_CONTABLE(Pn_BancoCtaContableId IN DB_GENERAL.ADMI_BANCO_CTA_CONTABLE.ID_BANCO_CTA_CONTABLE%TYPE)
    RETURN DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE
    --
  IS
    --
    CURSOR C_GetTipoCta(Cn_BancoTipoCuentaId DB_GENERAL.ADMI_BANCO_CTA_CONTABLE.ID_BANCO_CTA_CONTABLE%TYPE)
    IS
      SELECT ATC.DESCRIPCION_CUENTA
        FROM DB_GENERAL.ADMI_BANCO_CTA_CONTABLE ABCC
        LEFT JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC ON ABTC.ID_BANCO_TIPO_CUENTA = ABCC.BANCO_TIPO_CUENTA_ID
        LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA ATC ON ATC.ID_TIPO_CUENTA = ABTC.TIPO_CUENTA_ID
        WHERE ABCC.ID_BANCO_CTA_CONTABLE = Cn_BancoTipoCuentaId;

      --
      Lc_GetTipoCuenta DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE;
       
      --
  BEGIN
      --
    IF C_GetTipoCta%ISOPEN THEN
        --
      CLOSE C_GetTipoCta;
        --
    END IF;
      --
    OPEN C_GetTipoCta(Pn_BancoCtaContableId);
    --
    FETCH
      C_GetTipoCta
    INTO
      Lc_GetTipoCuenta;
    --
    CLOSE C_GetTipoCta;

    IF Lc_GetTipoCuenta IS NULL THEN                
      Lc_GetTipoCuenta := '';
    END IF;
    --
    RETURN Lc_GetTipoCuenta;        
    EXCEPTION
      WHEN OTHERS THEN
      --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('F_GET_CTA_CONTABLE', 'FNKG_REPORTES_COBRANZAS.F_GET_CTA_CONTABLE', SQLERRM);
    --
  END F_GET_CTA_CONTABLE;
  --

  FUNCTION F_GET_TIPO_CTA(Pn_BancoTipoCtaId IN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE)
    RETURN DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE
    --
  IS
    --
    CURSOR C_GetTipoCta(Cn_BancoTipoCuentaId DB_GENERAL.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE)
    IS

      SELECT ATC.DESCRIPCION_CUENTA
        FROM DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC
        LEFT JOIN DB_GENERAL.ADMI_TIPO_CUENTA ATC ON ATC.ID_TIPO_CUENTA = ABTC.TIPO_CUENTA_ID
        WHERE ABTC.ID_BANCO_TIPO_CUENTA = Cn_BancoTipoCuentaId;

      --
    Lv_GetTipoCuenta DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE;
    --
  BEGIN
    --
    IF C_GetTipoCta%ISOPEN THEN
      --
      CLOSE C_GetTipoCta;
      --
    END IF;
    --
    OPEN C_GetTipoCta(Pn_BancoTipoCtaId);
    --
    FETCH
      C_GetTipoCta
    INTO
      Lv_GetTipoCuenta;
    --
    CLOSE C_GetTipoCta;
    --
    
    IF Lv_GetTipoCuenta IS NULL THEN
      Lv_GetTipoCuenta  := '';
    END IF;
    --
    RETURN Lv_GetTipoCuenta;
    --
    EXCEPTION
      WHEN OTHERS THEN
      --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('F_GET_TIPO_CTA', 'FNKG_REPORTES_COBRANZAS.F_GET_TIPO_CTA', SQLERRM);
    --
  END F_GET_TIPO_CTA;
  --
  --
  FUNCTION F_GET_FORMATO_FECHA(Fv_Fecha IN VARCHAR2)
  RETURN VARCHAR2
  IS
    --
    CURSOR C_Convertir_Fecha(Cv_Fecha IN VARCHAR2)
    IS
      WITH DATA AS ( SELECT TO_CHAR(TO_DATE(Cv_Fecha, 'DD-MM-YYYY'), 'DD-MM-YYYY') fecha FROM dual)
      SELECT SUBSTR(fecha, Instr(fecha, '-', -1, 1) +1) || '-' ||
             SUBSTR(fecha, 4, Instr(fecha, '-', -1, 1) -4) || '-' ||
             SUBSTR(fecha, 1, Instr(fecha, '-', -1, 1) -4)  fechaConvertida
      FROM DATA;
  --
  Lv_FechaConvertida VARCHAR2(25):='';
  --
  BEGIN
    --
    IF C_Convertir_Fecha%ISOPEN THEN
      CLOSE C_Convertir_Fecha;
    END IF;
    --
    OPEN C_Convertir_Fecha(Fv_Fecha);
      FETCH C_Convertir_Fecha INTO Lv_FechaConvertida;
    CLOSE C_Convertir_Fecha;

    --
    RETURN Lv_FechaConvertida;
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_FORMATO_FECHA',
                                'FNCK_CONSULTS.F_GET_FORMATO_FECHA',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
  RETURN Lv_FechaConvertida;
  --
  END F_GET_FORMATO_FECHA;
  --
  --
  FUNCTION F_GET_EMPRESA(Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2
  IS
    --
    CURSOR C_GetEmpresa(Cn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT IOG.EMPRESA_ID 
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
             DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      WHERE IDFC.OFICINA_ID   = IOG.ID_OFICINA
        AND IDFC.ID_DOCUMENTO = Cn_IdDocumento;
  --
  Lv_CodEmpresa VARCHAR2(5):='';
  --
  BEGIN
    --
    IF C_GetEmpresa%ISOPEN THEN
      CLOSE C_GetEmpresa;
    END IF;
    --
    OPEN C_GetEmpresa(Fn_IdDocumento);
      FETCH C_GetEmpresa INTO Lv_CodEmpresa;
    CLOSE C_GetEmpresa;
    --
    RETURN Lv_CodEmpresa;
    --
  EXCEPTION
  WHEN OTHERS THEN
  --
  FNCK_TRANSACTION.INSERT_ERROR('F_GET_EMPRESA',
                                'FNCK_CONSULTS.F_GET_EMPRESA',
                                'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  --
  RETURN Lv_CodEmpresa;
  --
  END F_GET_EMPRESA;
  --
  --
  FUNCTION F_GET_USR_ULT_MOD(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE
  IS
    --
    CURSOR Lc_GetUsrUltMod(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS
      SELECT IDH.USR_CREACION AS USR_ULT_MOD
      FROM   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
      WHERE  IDH.ID_DOCUMENTO_HISTORIAL   = (SELECT MAX(IDH.ID_DOCUMENTO_HISTORIAL)
      FROM   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
      WHERE  IDH.DOCUMENTO_ID   = Cn_IdDocumento);
    --
     Lv_GetUsrUltMod DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.USR_CREACION%TYPE;
    --
  BEGIN
  --
    IF Lc_GetUsrUltMod%ISOPEN THEN
    --
      CLOSE Lc_GetUsrUltMod;
    --
    END IF;
  --
    OPEN Lc_GetUsrUltMod(Fn_IdDocumento);
  --
    FETCH
      Lc_GetUsrUltMod
    INTO
      Lv_GetUsrUltMod;
  --
    CLOSE Lc_GetUsrUltMod;

    IF Lv_GetUsrUltMod IS NULL THEN
      Lv_GetUsrUltMod  := '';
    END IF;
  --
    RETURN Lv_GetUsrUltMod;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_USR_ULT_MOD'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_USR_ULT_MOD;

  FUNCTION F_GET_FE_ULT_MOD(
    Fn_IdDocumento IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2
  IS
    --
    CURSOR Lc_GetFeUltMod(Cn_IdDocumento INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS
      SELECT  TO_CHAR(IDH.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS') AS FE_ULT_MOD   
      FROM   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
      WHERE  IDH.ID_DOCUMENTO_HISTORIAL   = (SELECT MAX(IDH.ID_DOCUMENTO_HISTORIAL)
      FROM   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL IDH
      WHERE  IDH.DOCUMENTO_ID   = Cn_IdDocumento);
    --
     Lv_GetFeUltMod VARCHAR2(100) := '';
    --
  BEGIN
  --
    IF Lc_GetFeUltMod%ISOPEN THEN
    --
      CLOSE Lc_GetFeUltMod;
    --
    END IF;
  --
    OPEN Lc_GetFeUltMod(Fn_IdDocumento);
  --
    FETCH
      Lc_GetFeUltMod
    INTO
      Lv_GetFeUltMod;
  --
    CLOSE Lc_GetFeUltMod;

    IF Lv_GetFeUltMod IS NULL THEN
      Lv_GetFeUltMod  := '';
    END IF;
  --
    RETURN Lv_GetFeUltMod;
  --
  EXCEPTION
  WHEN OTHERS THEN
  --
    DBMS_OUTPUT.PUT_LINE('F_GET_FE_ULT_MOD'||
                         ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                         ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN NULL;
    --
  END F_GET_FE_ULT_MOD;
END FNCK_CONSULTS;
/