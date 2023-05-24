CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_FACTURACION_MENSUAL_TN AS 

/*
* Documentaci�n para TYPE 'TypeClientesFacturar'.
* Record que me permite almancernar la informacion devuelta por el query de los clientes a facturar.
*/
TYPE TypeClientesFacturar IS RECORD (
      empresa_id            INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
      id_oficina            INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      id_persona_rol        INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      persona_id            INFO_PERSONA.ID_PERSONA%TYPE,
      login                 INFO_PUNTO.LOGIN%TYPE,
      empresa_rol_id        INFO_EMPRESA_ROL.ID_EMPRESA_ROL%TYPE,
      rol_id                ADMI_ROL.ID_ROL%TYPE,
      descripcion_rol       ADMI_ROL.DESCRIPCION_ROL%TYPE,
      descripcion_tipo_rol  ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
      id_punto              INFO_PUNTO.ID_PUNTO%TYPE,
      estado                INFO_PUNTO.ESTADO%TYPE,
      es_padre_facturacion  INFO_PUNTO_DATO_ADICIONAL.ES_PADRE_FACTURACION%TYPE,
      gasto_administrativo  INFO_PUNTO_DATO_ADICIONAL.GASTO_ADMINISTRATIVO%TYPE,
      ES_PREPAGO            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ES_PREPAGO%TYPE,
      PAGA_IVA              DB_COMERCIAL.INFO_PERSONA.PAGA_IVA%TYPE
);

/*
* Documentaci�n para TYPE 'T_ClientesFacturar'.
* Record para almacenar la data enviada al BULK.
*/
TYPE T_ClientesFacturar IS TABLE OF TypeClientesFacturar INDEX BY PLS_INTEGER;
  --
  --
  /**
  * Documentacion para type 'TypeServiciosAsociados'
  *
  * Record que me permite almancernar la informacion devuelta de los servicios asociados al punto de facturacion.
  *
  * @version 1.0 Version Inicial
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 14-03-2017 - Se agrega columna 'DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE'
  */
  TYPE TypeServiciosAsociados IS RECORD (
        id_servicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,  
        producto_id           ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
        plan_id               INFO_PLAN_CAB.ID_PLAN%TYPE,
        punto_id              INFO_PUNTO.ID_PUNTO%TYPE,
        cantidad              DB_COMERCIAL.INFO_SERVICIO.CANTIDAD%TYPE,
        precio_venta          DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
        porcentaje_descuento  DB_COMERCIAL.INFO_SERVICIO.PORCENTAJE_DESCUENTO%TYPE,
        valor_descuento       DB_COMERCIAL.INFO_SERVICIO.VALOR_DESCUENTO%TYPE,
        punto_facturacion_id  INFO_PUNTO.ID_PUNTO%TYPE,
        estado                DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
        observacion           DB_COMERCIAL.INFO_SERVICIO.DESCRIPCION_PRESENTA_FACTURA%TYPE,
        frecuencia_producto   DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE
  );
  --
  --
/*
* Documentaci�n para TYPE 'TypeServiciosAsociados'.
* Record para almacenar la data enviada al BULK.
*/
TYPE T_ServiciosAsociados IS TABLE OF TypeServiciosAsociados INDEX BY PLS_INTEGER;

/*
* Documentaci�n para TYPE 'TypeSolicitudes'.
* Record que me permite almancernar la informacion devuelta de las solicitudes asociados al punto de facturacion.
*/
Type TypeSolicitudes IS RECORD (
      id_detalle_solicitud  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
      descripcion_solicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
      estado_solicitud      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE
);


/*
* Documentaci�n para TYPE 'TypeBienServicio'.
* Record que me permite devolver los valores para los acumuladores de bienes y servicios
*/
Type TypeBienServicio IS RECORD (
      TIPO_IMPUESTO     VARCHAR(100),
      IMPUESTO_ID       DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE,
      TIPO              VARCHAR(100),
      TOTAL             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE
);

/*
* Documentaci�n para TYPE 'TypeNumerar'.
* Record que me permite numerar los documentos por oficina
*/
Type TypeNumerar IS RECORD (
      ID_DOCUMENTO        INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      NOMBRE_TIPO_NEGOCIO DB_COMERCIAL.ADMI_TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO%TYPE,
      DESCRIPCION_ROL     DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE,
      OFICINA_ID          DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE
);

--Funcion para la sumatoria del subtotal del documento
FUNCTION F_SUMAR_SUBTOTAL(id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) RETURN NUMBER;

--Funcion para la sumatoria del descuento del documento
FUNCTION F_SUMAR_DESCUENTO(id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) RETURN NUMBER;

--Funcion para la sumatoria del impuesto del documento
FUNCTION P_SUMAR_IMPUESTOS(id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) RETURN NUMBER;

--Funcion para obtener la fecha de activacion de los servicios
FUNCTION GET_FECHA_ACTIVACION(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN  VARCHAR2;

--Funcion para obtener el porcentaje correspondiente al impuesto
FUNCTION F_OBTENER_IMPUESTO(Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) RETURN NUMBER;

--Funcion para verificar el impuesto ligado al producto
FUNCTION F_VERIFICAR_IMPUESTO_PRODUCTO(
    Fn_IdProducto   IN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PRODUCTO_ID%TYPE,
    Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
RETURN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;

  /*
  * Funci�n para verificar el impuesto ligado al plan.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 26-03-201 Se agrega la definici�n de la funci�n F_VERIFICAR_IMPUESTO_PLAN en la cabecera del Paquete.
  *
  * @param   DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE   Fn_IdPlan     Id del plan.
  * Return   DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE
  */
FUNCTION F_VERIFICAR_IMPUESTO_PLAN(Fn_IdPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
RETURN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;

  /**
  * Documentacion para funci�n P_ACTUALIZAR_SERVICIO
  *
  * Funcion para actualizar la informacion relevante al servicio para el conteo
  *
  * @version 1.0 Version Inicial
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 24-10-2018 - Se elimina la actualizacion de los meses restantes segun la frecuencia, 
  * ya que esto debe ejecutarse cuando la Factura se encuentra en estado Activo, ya que esto genera error en la ejecucion
  * del job de conteo de frecuencia ya que no considera la Prefactura y vuelve a dejar el servicio en meses restantes = 0 
  * (Listo para facturar), debido a que cuando las facturas son generadas en Fin de Semana o en Feriado se numeran y
  * envian a autorizar el primer d�a h�bil.
  */
PROCEDURE P_ACTUALIZAR_SERVICIO(
    Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE);

  --
  --
  /**
  * Documentacion para funci�n F_VERIFICAR_CARAC_PERSONA
  *
  * Funcion para verificar si la persona posee la caracteristica de compensacion
  *
  * @version 1.0 Version Inicial
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 13-10-2016 - Se verifica si el usuario debe ser compensado o no usando la funci�n 'FNCK_CONSULTS.F_VALIDA_CLIENTE_COMPENSADO'
  */
  FUNCTION F_VERIFICAR_CARAC_PERSONA(
      Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;  
/**
  * Documentacion para el procedimiento P_GENERAR_FECHA_EMISION
  *
  * @version 1.0 Version Inicial
  * Procedimiento para obtener la fecha de emision dependiendo de la fecha actual
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.1 22-06-2017 - Modificacion del procedimiento para extraer el mes en espa�ol
  */
PROCEDURE P_GENERAR_FECHA_EMISION(
    Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FeEmision OUT VARCHAR2,
    Pv_MesEmision OUT VARCHAR2,
    Pn_MesEmision OUT VARCHAR2,
    Pv_AnioEmision OUT VARCHAR2);

--Procedimiento para obtener el dia de emision para la facturacion segun la empresa
PROCEDURE P_OBTENER_DIA_PARAMETRO(
  Pv_MesEmision IN VARCHAR2,
  Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  Pv_DiaEmision OUT VARCHAR2);
  
--Procedimiento para obtener prefijo de la empresa
PROCEDURE GET_PREFIJO_OFICINA(Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Pv_Prefijo OUT DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                                Pn_Id_Oficina OUT DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE);

--Procedimiento para eliminar los documentos nulos
PROCEDURE P_ELIMINAR_DOC_NULOS(Pn_UsrCreacion IN VARCHAR2);

--Procedimiento para actualizar las solicitud de descuento unico
PROCEDURE UPD_SOL_DESCT_UNICO (Pn_IdDetalleSol IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE);
  --
  --
  /**
  * Documentacion para el procedure GET_SERVICIO_ASOCIADOS
  *
  * Procedimiento para obtener los servicios asociados a los ptos de facturacion
  *
  * @version 1.0 Version Inicial
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 14-03-2017 - Se agrega al SELECT el campo 'iser.frecuencia_producto'
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.2 22-02-2018 - Se Trunca Valor de Precio de Venta del Servicio a 2 decimales debido a errores de cuadratura
  *                           provocado por Precios de Venta a 9 decimales 
  *
  * @author Allan Suarez <arsuarez@telconet.ec>
  * @version 1.3 17-07-2018 - Se agrega condici�n para que no se facturen servicios con caracteristica FACTURACION POR CONSUMO dado que se manejan
  *                           en una facturaci�n diferenciada
  */
  PROCEDURE GET_SERVICIO_ASOCIADOS(
      Pn_PuntoFacturacionId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Prf_Servicios         OUT SYS_REFCURSOR);
  --
 /**
  * Documentacion para el procedure P_CREAR_CABECERA
  *
  * Procedimiento para crear Cabecera del Documento Financiero.
  *  
  * @version 1.0 Version Inicial
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 16-03-2018 - Se Verifica que el Proceso de Facturacion de Telconet no asigna estado al documento
  *                           Inicial Creado. Se agrega el estado Pendiente en la Cabecera del Documento.
  *
  */ 
  PROCEDURE P_CREAR_CABECERA(
    Lr_Punto        IN TypeClientesFacturar,
    Ln_MesEmision   IN VARCHAR2,
    Lv_AnioEmision  IN VARCHAR2,
    Lr_InfoDocumentoFinancieroCab OUT INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE
    );
  --
--Procedimiento para obtener las solicitudes de cancelacion y suspension relacionadas al servicio
PROCEDURE GET_SOLICITUDES_CANCEL_SUSP(Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,Cn_Solicitudes OUT SYS_REFCURSOR);

--Procedimiento para obtener la solicitud de descuento unico asociada al servicio
PROCEDURE GET_SOL_DESCT_UNICO(Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Id_Det_Sol OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                Porcen_Desct OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE);

--Procedimiento para simular la facturacion basica por porcentaje o por valor de descuento segun la informacion del punto
PROCEDURE P_SIMULAR_FACT_MENSUAL(Pn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                  Pn_PorPorcentaje OUT DB_COMERCIAL.INFO_SERVICIO.PORCENTAJE_DESCUENTO%TYPE, 
                                  Pn_PorValor OUT DB_COMERCIAL.INFO_SERVICIO.VALOR_DESCUENTO%TYPE);

--Procedimiento para obtener la sumatoria de bienes o de servicios
PROCEDURE P_OBTENER_SUBTOTALES_BS(
  Pn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT.DOCUMENTO_ID%TYPE,
  Cn_SumatoriaBS OUT SYS_REFCURSOR);
  
/**
* Documentacion para procedure P_ACTUALIZAR_CABECERA
*
* Procedimiento para actualizar cabecera del documento
*
* @author Gina Villalba <gvillalba@telconet.ec>
* @since 1.0
*
* @author Gina Villalba <gvillalba@telconet.ec>
* @version 1.1 - Se agrega el parametro de la compensacion solidario
* @since 30-09-2016
*
*/
PROCEDURE P_ACTUALIZAR_CABECERA(
    Lr_InfoDocumentoFinancieroCab IN OUT INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
    Ln_Subtotal             IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
    Ln_SubtotalConImpuesto  IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
    Ln_SubtotalDescuento    IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
    Ln_ValorTotal           IN INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    Lv_PrefijoEmpresa       IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Ln_IdOficina            IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Lv_FeEmision            IN VARCHAR2,
    Ln_ValorCompensacion    IN INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE
);


  /*
  * Procedimiento para crear el impuesto adicional.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 26-03-201 Se agrega la definici�n del procedimiento P_CREAR_IMPUESTO_ADICIONAL en la cabecera del Paquete.
  *
  * @param   INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE   Pn_IdDocDetalle     Id del detalle del documento.
  * @param   NUMBER                                              Pn_IdImpuesto       Id del impuesto.
  * @param   NUMBER                                              Pn_ValorImpuesto    Valor del impuesto.
  * @param   NUMBER                                              Pn_Porcentaje       Porcentaje de descuento.
  */
PROCEDURE P_CREAR_IMPUESTO_ADICIONAL(
    Pn_IdDocDetalle   IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
    Pn_IdImpuesto     IN NUMBER,
    Pn_ValorImpuesto  IN NUMBER,
    Pn_Porcentaje     IN NUMBER
);


  /*
  * Procedimiento para crear el detalle del documento.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 07-12-2017 Se agrega seteo de campo SERVICIO_ID que hace referencia al servicio a facturar.
  *
  * @author  Telcos
  * @version 1.0  
  * @param   TypeServiciosAsociados                                        Lr_Servicio                   Referencia del servicio facturar.
  * @param   NUMBER                                                        Ln_Porcentaje                 Porcentaje de impuesto.
  * @param   NUMBER                                                        Ln_ValorImpuesto              Valor de impuesto.
  * @param   INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE                         Lr_InfoDocumentoFinancieroCab Cabecera del documento.
  * @param   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE Ln_PorcentajeDescuento        Porcentaje de descuento.
  * @param   NUMBER                                                        Ln_DescuentoFacProDetalle     Descuento correspondiente al detalle.
  * @param   VARCHAR2                                                      Lv_MesEmision                 Mes de emisi�n.
  * @param   VARCHAR2                                                      Lv_AnioEmision                Anio de emisi�n.
  * @param   VARCHAR2                                                      Lv_Observacion                Observaci�n.
  */
PROCEDURE P_CREAR_DETALLE(
    Lr_Servicio                   IN TypeServiciosAsociados,
    Ln_Porcentaje                 IN NUMBER,
    Ln_ValorImpuesto              IN NUMBER,
    Lr_InfoDocumentoFinancieroCab IN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
    Ln_PorcentajeDescuento        IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE,
    Ln_DescuentoFacProDetalle     IN NUMBER,
    Lv_MesEmision                 IN VARCHAR2,
    Lv_AnioEmision                IN VARCHAR2,
    Lv_Observacion                IN DB_COMERCIAL.INFO_SERVICIO.DESCRIPCION_PRESENTA_FACTURA%TYPE,
    Pn_IdDocDetalle		          OUT INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE
);
    --
    --
    --
/*
 * Documentaci�n para FUNCION 'P_NUMERAR_LOTE_POR_OFICINA'.
 *
 * Procedimiento para numerar todo el lote de documentos pendientes
 * Se marca el campo ES_ELECTRONICA:='S' para que se envien al SRI
 *
 * @version 1.0 Version Inicial
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 - Se agrega el usuario de creaci�n 'Pv_UsrCreacion' para verificar por usuario de creaci�n las facturas a numerar
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.2 04-09-2016 - Se a�ade la variable 'Pn_IdDocumento' que contiene el id del documento a procesar
 *
 * PARAMETROS:
 * @param Pv_PrefijoEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (prefijo de la empresa que va a enumerarse)
 * @param Pv_FeEmision               VARCHAR2 (fecha de emisi�n de las facturas a numerar)
 * @param Pv_CodigoTipoDocumento     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE (c�digo del tipo de documento a generar)
 * @param Pv_UsrCreacion             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE (usuario de creaci�n de las facturas)
 * @param Pv_EstadoImpresionFact     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE (estado de las facturas a buscar)
 * @param Pv_EsElectronica           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_ELECTRONICA%TYPE (par�metro que indica si la factura es 
 *                                                                                                    electronica o no)
 * @param Pn_IdDocumento             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE (id del documento a procesar)
 * @return Pv_MsnError               VARCHAR2 (variable que retornar� el mensaje de error en caso de existir )
 */
PROCEDURE P_NUMERAR_LOTE_POR_OFICINA(
      Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_FeEmision           IN VARCHAR2,
      Pv_CodigoTipoDocumento IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_UsrCreacion         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pv_EstadoImpresionFact IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
      Pv_EsElectronica       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_ELECTRONICA%TYPE,
      Pn_IdDocumento         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_MsnError            OUT VARCHAR2 );
  --
  --
  /**
  * Documentacion para procedure P_PROCESAR_INFORMACION
  *
  * Permite procesar la informacion a facturar
  *
  * @param Cn_Puntos_Facturar  IN T_ClientesFacturar  Cursor con los puntos de facturaci�n
  * @param Ln_MesEmision       IN VARCHAR2  Mes de emisi�n en n�meros de la factura a realizar
  * @param Lv_MesEmision       IN VARCHAR2  Mes de emisi�n en letras de la factura a realizar
  * @param Lv_AnioEmision      IN VARCHAR2  A�o de emisi�n de la factura a realizar
  * @param Lv_PrefijoEmpresa   IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE  Prefijo de la empresa la cual realiza el proceso de facturaci�n
  * @param Ln_IdOficina        IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE  Id de la oficina de facturaci�n
  * @param Lv_FeEmision        IN VARCHAR2  Fecha de emisi�n de la factura realizada
  * @param Ln_Porcentaje       IN NUMBER   Porcentaje del iva que se va a calcular
  * @param Ln_RecordCount      IN OUT NUMBER  N�mero de documentos creados.
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @since 1.0
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.1 - Se agrega Ln_BanderaImpuestoAdicional, para el impuesto adicional en este caso el ICE
  * @since 30-09-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 14-10-2016 - Se parametriza la validaci�n de compensaci�n de las facturas al 14% y al 12%.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 14-03-2017 - Cuando el servicio facturado tiene frecuencia mayor que uno se a�ade a la descripci�n del servicio facturado una glosa
  *                           informativa indicado el periodo facturado del servicio.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.4 05-04-2018 - Se agrega validaci�n para que se genere la cabecera de la factura cuando existen servicios a facturar.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.5 01-07-2021 - Se parametriza el valor l�mite de la cantidad de servicios para el detalle de la factura.
  * Costo query C_GetParametroLimite: 3
  *
  * @param Ln_RecordCount IN OUT NUMBER Retorna el conteo para reallizar el commit
  */
  PROCEDURE P_PROCESAR_INFORMACION (
      Cn_Puntos_Facturar  IN T_ClientesFacturar,
      Ln_MesEmision       IN VARCHAR2,
      Lv_MesEmision       IN VARCHAR2,
      Lv_AnioEmision      IN VARCHAR2,
      Lv_PrefijoEmpresa   IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Ln_IdOficina        IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Lv_FeEmision        IN VARCHAR2,
      Ln_Porcentaje       IN NUMBER,
      Ln_RecordCount      IN OUT NUMBER );
  --
  --
  /*
  * Documentaci�n para el procedimiento 'P_FACTURACION_MENSUAL'.
  *
  * Procedimiento para realizar la facturacion mensual de todos los puntos de facturacion
  *
  * @version 1.0 Version Inicial
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 - Se cambia la forma de obtener la fecha de emisi�n, puesto que ahora se obtendr� la fecha de emisi�n del d�a en que se ejecuta el
  *                proceso.
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.2 - Modificacion del procedimiento para extraer el mes en espa�ol
  *
  * PARAMETROS:
  * @param Pn_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  C�digo de la empresa de la cual se va a ejecutar el proceso
  * @param Pv_EsPrepago  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ES_PREPAGO%TYPE  Indica si el cliente es prepago
  */
  PROCEDURE P_FACTURACION_MENSUAL(
      Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_EsPrepago  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ES_PREPAGO%TYPE);
  --
  --
END FNCK_FACTURACION_MENSUAL_TN;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_FACTURACION_MENSUAL_TN
AS

PROCEDURE GET_SERVICIO_ASOCIADOS(
    Pn_PuntoFacturacionId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Prf_Servicios         OUT SYS_REFCURSOR)
AS
  --Listado de Servicios asociados al pto de facturacion
  --Tema de Frecuencias??
  Lv_InfoError VARCHAR2(3000);
BEGIN
  OPEN Prf_Servicios FOR 
    SELECT iser.id_servicio, 
    iser.producto_id, 
    iser.plan_id, 
    iser.punto_id, 
    iser.cantidad, 
    TRUNC(iser.precio_venta,2), 
    NVL(iser.porcentaje_descuento,0) AS  porcentaje_descuento, 
    NVL(iser.valor_descuento,0) AS  valor_descuento, 
    iser.punto_facturacion_id, 
    iser.estado,
    iser.DESCRIPCION_PRESENTA_FACTURA,
    iser.frecuencia_producto
    FROM DB_COMERCIAL.INFO_SERVICIO iser 
    WHERE iser.PUNTO_FACTURACION_ID=Pn_PuntoFacturacionId 
    AND iser.ESTADO='Activo' 
    AND iser.cantidad>0 
    AND iser.ES_VENTA='S' 
    AND iser.precio_venta>0 
    --Modificacion de frecuencias
    AND iser.frecuencia_producto>0
    AND iser.meses_restantes=0
    AND NVL(iser.PRECIO_VENTA*iser.CANTIDAD,0)>=NVL(iser.VALOR_DESCUENTO,0)
    AND iser.producto_id NOT IN (SELECT pro.id_producto 
                                 FROM DB_COMERCIAL.ADMI_PRODUCTO pro
                                 JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA apc ON pro.ID_PRODUCTO = apc.PRODUCTO_ID      
                                 JOIN DB_COMERCIAL.ADMI_CARACTERISTICA          ac  ON ac.ID_CARACTERISTICA = apc.CARACTERISTICA_ID
                                 WHERE ac.DESCRIPCION_CARACTERISTICA='FACTURACION POR CONSUMO'
                                 AND   apc.ESTADO = 'Activo' );
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'GET_SERVICIO_ASOCIADOS', Lv_InfoError);  
END GET_SERVICIO_ASOCIADOS;

PROCEDURE P_ACTUALIZAR_SERVICIO(
    Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
AS
  Lv_InfoError VARCHAR2(3000);
BEGIN  
  --Insertar el historial de renovacion de conteo
  INSERT
  INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
    (
      ID_SERVICIO_HISTORIAL,
      SERVICIO_ID,
      ESTADO,
      OBSERVACION,
      USR_CREACION,
      FE_CREACION,
      ACCION
    )
    VALUES
    (
      DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
      Pn_IdServicio,
      'Activo',
      'Se reinicio el conteo para la facturaci�n',
      'telcos',
      sysdate,
      'reinicioConteo'
    );
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_ACTUALIZAR_SERVICIO', Lv_InfoError);    
END P_ACTUALIZAR_SERVICIO;

PROCEDURE GET_SOLICITUDES_CANCEL_SUSP(
    Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Cn_Solicitudes OUT SYS_REFCURSOR)
AS
  --Verificar las solicitudes de cancelacion o suspension temporal del servicio
  Lv_InfoError VARCHAR2(3000);
BEGIN
  OPEN Cn_Solicitudes FOR 
    SELECT MAX(ids.id_detalle_solicitud) AS  id_detalle_solicitud, 
    ats.descripcion_solicitud, 
    ids.estado AS estado_solicitud 
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
    left join DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats ON ats.id_tipo_solicitud=ids.tipo_solicitud_id 
    WHERE ids.servicio_id=Pn_IdServicio 
    AND (ats.descripcion_solicitud='SOLICITUD CANCELACION' OR ats.descripcion_solicitud='SOLICITUD SUSPENSION TEMPORAL') 
    AND ids.estado='Pendiente' 
    group by ats.descripcion_solicitud,ids.estado;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'GET_SOLICITUDES_CANCEL_SUSP', Lv_InfoError);  
END GET_SOLICITUDES_CANCEL_SUSP;

PROCEDURE GET_SOL_DESCT_UNICO(
    Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Id_Det_Sol OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    Porcen_Desct OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE)
AS
  --Permite obtener la solicitud de descuento unico asociada al servicio
  CURSOR Cn_Solicitud(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT id_detalle_solicitud,
      porcentaje_descuento
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    WHERE id_detalle_solicitud IN
      (SELECT MIN(ids.id_detalle_solicitud)
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
      LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
      ON ats.id_tipo_solicitud     =ids.tipo_solicitud_id
      WHERE ids.servicio_id        =Cn_IdServicio
      AND ats.descripcion_solicitud='SOLICITUD DESCUENTO UNICO'
      AND ids.estado               ='Aprobado'
      AND rownum                   =1
      );
      
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF Cn_Solicitud%ISOPEN THEN
    CLOSE Cn_Solicitud;
  END IF;
  
  OPEN Cn_Solicitud(Pn_IdServicio);
  --
  FETCH Cn_Solicitud INTO Id_Det_Sol, Porcen_Desct;
  --
  IF Id_Det_Sol IS NULL THEN
    Id_Det_Sol := 0;
  END IF;
  --
  IF Porcen_Desct IS NULL THEN
    Porcen_Desct := 0;
  END IF;
  --
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'GET_SOL_DESCT_UNICO', Lv_InfoError);  
END GET_SOL_DESCT_UNICO;

PROCEDURE UPD_SOL_DESCT_UNICO(
    Pn_IdDetalleSol IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
AS
  --Actualiza el estado de la solicitud
  --Crea historial de ejecucion por la Facturacion
BEGIN
  --Finalizo la solicitud actual
  UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
  SET estado                ='Finalizada'
  WHERE id_detalle_solicitud=Pn_IdDetalleSol;
  --Inserto el historia nuevo
  INSERT
  INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
    (
      ID_SOLICITUD_HISTORIAL,
      DETALLE_SOLICITUD_ID,
      ESTADO,
      OBSERVACION,
      USR_CREACION,
      FE_CREACION
    )
    VALUES
    (
      DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
      Pn_IdDetalleSol,
      'Finalizada',
      'Proceso de Facturacion masiva telcos',
      'telcos',
      sysdate
    );
END UPD_SOL_DESCT_UNICO;

PROCEDURE GET_PREFIJO_OFICINA(
    Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo OUT DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pn_Id_Oficina OUT DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE)
AS
  -- Permite obtener el prefijo y la oficina
  CURSOR Cn_EmpresaOficina(Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT ieg.prefijo,
      iog.ID_OFICINA
    FROM DB_COMERCIAL.info_empresa_grupo ieg
    JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO iog
    ON iog.EMPRESA_ID             =ieg.COD_EMPRESA
    AND iog.ES_MATRIZ             ='S'
    AND iog.ES_OFICINA_FACTURACION='S'
    WHERE ieg.COD_EMPRESA         =Cn_EmpresaCod
    AND iog.ESTADO                ='Activo'
    AND rownum                    =1;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  
  IF Cn_EmpresaOficina%ISOPEN THEN
    CLOSE Cn_EmpresaOficina;
  END IF;
  
  OPEN Cn_EmpresaOficina(Pn_EmpresaCod);
  --
  FETCH Cn_EmpresaOficina INTO Pv_Prefijo, Pn_Id_Oficina;
  --
  IF Pv_Prefijo IS NULL THEN
    Pv_Prefijo := '';
  END IF;
  --
  IF Pn_Id_Oficina IS NULL THEN
    Pn_Id_Oficina := 0;
  END IF;
  --
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'GET_PREFIJO_OFICINA', Lv_InfoError); 
END GET_PREFIJO_OFICINA;

FUNCTION F_SUMAR_SUBTOTAL(
    id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_SumarSubtotal (Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS 
    SELECT SUM(PRECIO_VENTA_FACPRO_DETALLE*CANTIDAD)
    FROM INFO_DOCUMENTO_FINANCIERO_DET
    WHERE DOCUMENTO_ID = Cn_IdDocumento;
  --
  Ln_SubtotalCeroImpuesto INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
  
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN 
  IF C_SumarSubtotal%ISOPEN THEN
    CLOSE C_SumarSubtotal;
  END IF;
  --
  OPEN C_SumarSubtotal(id_documento);
  --
  FETCH C_SumarSubtotal INTO Ln_SubtotalCeroImpuesto;
  --
  CLOSE C_SumarSubtotal;
  --
  IF Ln_SubtotalCeroImpuesto IS NULL THEN
    Ln_SubtotalCeroImpuesto  := 0.00;
  END IF;
  --
  RETURN Ln_SubtotalCeroImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'F_SUMAR_SUBTOTAL', Lv_InfoError);   
END F_SUMAR_SUBTOTAL;

FUNCTION F_SUMAR_DESCUENTO(
    id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_SumaDescuento(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS
    SELECT SUM(DESCUENTO_FACPRO_DETALLE)
    FROM INFO_DOCUMENTO_FINANCIERO_DET
    WHERE DOCUMENTO_ID = Cn_IdDocumento;
  --
  Ln_SubtotalDescuento INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE;
  
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
  
BEGIN
  IF C_SumaDescuento%ISOPEN THEN
    CLOSE C_SumaDescuento;
  END IF;
  --
  OPEN C_SumaDescuento(id_documento);
  --
  FETCH C_SumaDescuento INTO Ln_SubtotalDescuento;
  --
  CLOSE C_SumaDescuento;
  --
  IF Ln_SubtotalDescuento IS NULL THEN
    Ln_SubtotalDescuento  := 0.00;
  END IF;
  --
  RETURN Ln_SubtotalDescuento;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'F_SUMAR_DESCUENTO', Lv_InfoError);   
END F_SUMAR_DESCUENTO;

FUNCTION P_SUMAR_IMPUESTOS(
    id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_SumaImpuesto(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS
    SELECT SUM(IDFI.VALOR_IMPUESTO)
    FROM INFO_DOCUMENTO_FINANCIERO_DET IDFD
    JOIN INFO_DOCUMENTO_FINANCIERO_IMP IDFI
    ON IDFI.DETALLE_DOC_ID  =IDFD.ID_DOC_DETALLE
    WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento;
  --
  Ln_SubtotalConImpuesto INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE;
  
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_SumaImpuesto%ISOPEN THEN
    CLOSE C_SumaImpuesto;
  END IF;
  --
  OPEN C_SumaImpuesto(id_documento);
  --
  FETCH C_SumaImpuesto INTO Ln_SubtotalConImpuesto;
  --
  CLOSE C_SumaImpuesto;
  --
  IF Ln_SubtotalConImpuesto IS NULL THEN
    Ln_SubtotalConImpuesto  := 0.00;
  END IF;
  --
  RETURN Ln_SubtotalConImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_SUMAR_IMPUESTOS', Lv_InfoError);  
END P_SUMAR_IMPUESTOS;

PROCEDURE P_ELIMINAR_DOC_NULOS(
    Pn_UsrCreacion IN VARCHAR2)
AS
BEGIN
  DELETE
  FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL
  WHERE DOCUMENTO_ID IN
    (SELECT ID_DOCUMENTO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
    WHERE ESTADO_IMPRESION_FACT IS NULL
    AND USR_CREACION             =Pn_UsrCreacion
    AND ES_AUTOMATICA            ='S'
    AND NUMERO_FACTURA_SRI      IS NULL
    );
  DELETE
  FROM INFO_DOCUMENTO_FINANCIERO_CAB
  WHERE ESTADO_IMPRESION_FACT IS NULL
  AND USR_CREACION             =Pn_UsrCreacion
  AND ES_AUTOMATICA            ='S'
  AND NUMERO_FACTURA_SRI      IS NULL;
END P_ELIMINAR_DOC_NULOS;

FUNCTION GET_FECHA_ACTIVACION(
    Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_FechaActivacion(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) IS
    SELECT MAX (FE_CREACION)
    FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
    WHERE SERVICIO_ID = Cn_IdServicio
    AND (UPPER (DBMS_LOB.SUBSTR( OBSERVACION,4000,1)) = 'SE CONFIRMO EL SERVICIO' OR UPPER (ACCION) = 'CONFIRMARSERVICIO')
    AND ESTADO = 'Activo';
  --
  Lv_FeCreacion VARCHAR2(200);
  
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_FechaActivacion%ISOPEN THEN
    CLOSE C_FechaActivacion;
  END IF;
  --
  OPEN C_FechaActivacion(Fn_IdServicio);
  --
  FETCH C_FechaActivacion INTO Lv_FeCreacion;
  --
  CLOSE C_FechaActivacion;
  --
  IF Lv_FeCreacion IS NULL THEN
    Lv_FeCreacion  := '';
  END IF;
  --
  RETURN Lv_FeCreacion;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'GET_FECHA_ACTIVACION', Lv_InfoError);    
END GET_FECHA_ACTIVACION;

PROCEDURE P_SIMULAR_FACT_MENSUAL(
    Pn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_PorPorcentaje OUT DB_COMERCIAL.INFO_SERVICIO.PORCENTAJE_DESCUENTO%TYPE,
    Pn_PorValor OUT DB_COMERCIAL.INFO_SERVICIO.VALOR_DESCUENTO%TYPE)
AS
  Lv_InfoError VARCHAR2(3000);
  --
  CURSOR Cn_FacturacionMensual
  IS
    SELECT SUM(ROUND((CANTIDAD*PRECIO_VENTA)-((CANTIDAD*PRECIO_VENTA)*NVL(PORCENTAJE_DESCUENTO,0)/100),2)),
      SUM(ROUND((CANTIDAD     *PRECIO_VENTA)-NVL(VALOR_DESCUENTO,0)))
    FROM DB_COMERCIAL.INFO_SERVICIO
    WHERE PUNTO_FACTURACION_ID=Pn_IdPuntoFacturacion
    AND ESTADO                ='Activo'
    AND CANTIDAD              >0
    AND ES_VENTA              ='S'
    AND PRECIO_VENTA          >0
    --Modificacion de frecuencias
    AND frecuencia_producto   >0
    AND meses_restantes       =0;  
BEGIN
  --Con el punto de facturacion hago el query para la sumatoria de los valores de servicios
  OPEN Cn_FacturacionMensual;
  LOOP
    FETCH Cn_FacturacionMensual INTO Pn_PorPorcentaje, Pn_PorValor;
    EXIT
  WHEN Cn_FacturacionMensual%NOTFOUND;
  END LOOP;
  CLOSE Cn_FacturacionMensual;
  
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_SIMULAR_FACT_MENSUAL', Lv_InfoError);    
END P_SIMULAR_FACT_MENSUAL;

FUNCTION F_OBTENER_IMPUESTO(
    Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_ObtenerImpuesto(Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) IS
    SELECT PORCENTAJE_IMPUESTO
    FROM DB_GENERAL.ADMI_IMPUESTO
    WHERE UPPER(TIPO_IMPUESTO)=Cv_TipoImpuesto
    AND ESTADO                ='Activo';
  --
  Ln_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;
  
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_ObtenerImpuesto%ISOPEN THEN
    CLOSE C_ObtenerImpuesto;
  END IF;
  --
  OPEN C_ObtenerImpuesto(Fv_TipoImpuesto);
  --
  FETCH C_ObtenerImpuesto INTO Ln_PorcentajeImpuesto;
  --
  CLOSE C_ObtenerImpuesto;
  --
  IF Ln_PorcentajeImpuesto IS NULL THEN
    Ln_PorcentajeImpuesto  := 0;
  END IF;
  --
  RETURN Ln_PorcentajeImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'F_OBTENER_IMPUESTO', Lv_InfoError);  
END F_OBTENER_IMPUESTO;

FUNCTION F_VERIFICAR_IMPUESTO_PLAN(
    Fn_IdPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
  RETURN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE
IS
  CURSOR C_VerificarImpPlan(Cn_IdPlan DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE) IS
    SELECT IVA
    FROM DB_COMERCIAL.INFO_PLAN_CAB
    WHERE ID_PLAN=Cn_IdPlan;
  --
  Lv_Iva                DB_COMERCIAL.INFO_PLAN_CAB.IVA%TYPE;
  Ln_PorcentajeImpuesto DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_VerificarImpPlan%ISOPEN THEN
    CLOSE C_VerificarImpPlan;
  END IF;
  --
  OPEN C_VerificarImpPlan(Fn_IdPlan);
  --
  FETCH C_VerificarImpPlan INTO Lv_Iva;
  --
  CLOSE C_VerificarImpPlan;
  --
  IF Lv_Iva IS NULL THEN
    Lv_Iva:='N';
  END IF;
  --
  IF Lv_Iva='S' THEN
    Ln_PorcentajeImpuesto:=1;
  ELSIF Lv_Iva='N' THEN
    Ln_PorcentajeImpuesto:=0;
  END IF;
  
  RETURN Ln_PorcentajeImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'F_VERIFICAR_IMPUESTO_PLAN', Lv_InfoError);  
END F_VERIFICAR_IMPUESTO_PLAN;

FUNCTION F_VERIFICAR_IMPUESTO_PRODUCTO(
    Fn_IdProducto   IN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PRODUCTO_ID%TYPE,
    Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  RETURN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE
IS
  CURSOR C_VerificarImpProd(Cn_IdProducto   DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PRODUCTO_ID%TYPE,
                            Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) IS
    SELECT IPI.PORCENTAJE_IMPUESTO
    FROM DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO IPI
    JOIN DB_GENERAL.ADMI_IMPUESTO AI ON AI.ID_IMPUESTO=IPI.IMPUESTO_ID
    WHERE 
    IPI.PRODUCTO_ID=Cn_IdProducto
    AND AI.TIPO_IMPUESTO=Cv_TipoImpuesto;
  --
  Ln_PorcentajeImpuesto    DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;
  
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_VerificarImpProd%ISOPEN THEN
    CLOSE C_VerificarImpProd;
  END IF;
  --
  OPEN C_VerificarImpProd(Fn_IdProducto,Fv_TipoImpuesto);
  --
  FETCH C_VerificarImpProd INTO Ln_PorcentajeImpuesto;
  --
  CLOSE C_VerificarImpProd;
  --
  IF Ln_PorcentajeImpuesto IS NULL THEN
    Ln_PorcentajeImpuesto:=0;
  END IF;
  --
  RETURN Ln_PorcentajeImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'F_VERIFICAR_IMPUESTO_PRODUCTO', Lv_InfoError);  
END F_VERIFICAR_IMPUESTO_PRODUCTO;
  --
  --
  FUNCTION F_VERIFICAR_CARAC_PERSONA(
      Fn_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE
  IS
    CURSOR C_GetInformacionCliente(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT IP.ID_PUNTO,
        IP.SECTOR_ID,
        IPER.ID_PERSONA_ROL,
        IPER.OFICINA_ID,
        IOG.EMPRESA_ID
      FROM DB_COMERCIAL.INFO_PUNTO IP
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
      ON IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      ON IOG.ID_OFICINA = IPER.OFICINA_ID
      WHERE IP.ID_PUNTO = Cn_IdPunto;
    --
    Lr_InformacionCliente C_GetInformacionCliente%ROWTYPE                   := NULL;
    Ln_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE := 0;
    Lv_EsCompensado VARCHAR2(4)                                             := NULL;
    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError VARCHAR2(2000);
  BEGIN
    IF C_GetInformacionCliente%ISOPEN THEN
      CLOSE C_GetInformacionCliente;
    END IF;
    --
    OPEN C_GetInformacionCliente(Fn_IdPunto);
    --
    FETCH C_GetInformacionCliente INTO Lr_InformacionCliente;
    --
    CLOSE C_GetInformacionCliente;
    --
    IF( Lr_InformacionCliente.ID_PERSONA_ROL IS NOT NULL AND Lr_InformacionCliente.ID_PERSONA_ROL > 0 )THEN
      --
      --Si se obtiene la informaci�n del cliente se busca si debe o no compensar al cliente
      Lv_EsCompensado := DB_FINANCIERO.FNCK_CONSULTS.F_VALIDA_CLIENTE_COMPENSADO( Lr_InformacionCliente.ID_PERSONA_ROL, 
                                                                                  Lr_InformacionCliente.OFICINA_ID, 
                                                                                  Lr_InformacionCliente.EMPRESA_ID, 
                                                                                  Lr_InformacionCliente.SECTOR_ID, 
                                                                                  Lr_InformacionCliente.ID_PUNTO );
      --
      IF TRIM(Lv_EsCompensado) IS NOT NULL AND TRIM(Lv_EsCompensado) = 'S' THEN
        --
        Ln_PorcentajeImpuesto := FNCK_FACTURACION_MENSUAL.F_OBTENER_IMPUESTO_POR_DESC('IVA 12%');
        --
      END IF;
      --
    END IF;
    --
    --
    RETURN Ln_PorcentajeImpuesto;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_InfoError := DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_FACTURACION_MENSUAL_TN.F_VERIFICAR_CARAC_PERSONA', 
                                          'Error al obtener si el cliente debe ser compensado' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM || ' - '
                                          || Lv_InfoError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    Ln_PorcentajeImpuesto := 0;
    --
    RETURN Ln_PorcentajeImpuesto;
    --
  END F_VERIFICAR_CARAC_PERSONA;
  --
  --
PROCEDURE P_GENERAR_FECHA_EMISION(
    Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_FeEmision OUT VARCHAR2,
    Pv_MesEmision OUT VARCHAR2,
    Pn_MesEmision OUT VARCHAR2,
    Pv_AnioEmision OUT VARCHAR2)
AS
  Fv_Dia        NUMBER;
  Pv_DiaEmision VARCHAR2(2);
BEGIN

  SELECT TO_NUMBER(TO_CHAR(SYSDATE,'dd')) INTO Fv_Dia FROM DUAL;
  
  --Pregunto por el grupo de fechas establecidos
  --Fechas de proceso unicamente
  IF (Fv_Dia>=1 AND Fv_Dia<=15) THEN
    Pv_FeEmision:=TO_CHAR(SYSDATE,'mm/yyyy');
    Pv_MesEmision:=TO_CHAR(SYSDATE,'MONTH','NLS_DATE_LANGUAGE = SPANISH');
    Pn_MesEmision:=TO_CHAR(SYSDATE,'mm');
    Pv_AnioEmision:=TO_CHAR(SYSDATE,'yyyy');
  ELSIF(Fv_Dia>=23 AND Fv_Dia<=31) THEN
    Pv_FeEmision:=TO_CHAR(LAST_DAY(ADD_MONTHS(add_months(SYSDATE,1),-1))+1,'mm/yyyy');
    Pv_MesEmision:=TO_CHAR(LAST_DAY(ADD_MONTHS(add_months(SYSDATE,1),-1))+1,'MONTH','NLS_DATE_LANGUAGE = SPANISH');
    Pn_MesEmision:=TO_CHAR(LAST_DAY(ADD_MONTHS(add_months(SYSDATE,1),-1))+1,'mm');
    Pv_AnioEmision:=TO_CHAR(LAST_DAY(ADD_MONTHS(add_months(SYSDATE,1),-1))+1,'yyyy');
  END IF;
  
  --Despues de estas definiciones, debo establecer segun el parametro por empresa segun el mes cual es el dia de emision
  P_OBTENER_DIA_PARAMETRO(Pv_MesEmision,Pn_EmpresaCod,Pv_DiaEmision);
  
  --Se reescribe la fecha de emision con el valor del dia obtenido
  Pv_FeEmision:=Pv_DiaEmision||'/'||Pv_FeEmision;
  
  
END P_GENERAR_FECHA_EMISION;

PROCEDURE P_OBTENER_DIA_PARAMETRO(
  Pv_MesEmision IN VARCHAR2,
  Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  Pv_DiaEmision OUT VARCHAR2
)
AS
  --
  Ln_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;
  
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);

  CURSOR C_ObtenerParametro(Cv_MesEmision VARCHAR2, Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
    SELECT LPAD(APD.VALOR2,2,'0') as VALOR2
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
    JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO=APD.PARAMETRO_ID
    WHERE
    APD.EMPRESA_COD=Cn_EmpresaCod
    AND APC.NOMBRE_PARAMETRO='FACTURACION MENSUAL'
    AND APD.DESCRIPCION=TRIM(Cv_MesEmision)
    and APC.ESTADO='Activo';

BEGIN
  IF C_ObtenerParametro%ISOPEN THEN
    CLOSE C_ObtenerParametro;
  END IF;
  --
  OPEN C_ObtenerParametro(Pv_MesEmision,Pn_EmpresaCod);
  --
  FETCH C_ObtenerParametro INTO Pv_DiaEmision;
  --
  CLOSE C_ObtenerParametro;
  --
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_OBTENER_DIA_PARAMETRO', Lv_InfoError); 
END P_OBTENER_DIA_PARAMETRO;


PROCEDURE P_OBTENER_SUBTOTALES_BS(
  Pn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT.DOCUMENTO_ID%TYPE,
  Cn_SumatoriaBS OUT SYS_REFCURSOR)
AS
  Lv_InfoError VARCHAR2(3000);
BEGIN
  OPEN Cn_SumatoriaBS FOR
    SELECT 
    CASE 
    WHEN AI.TIPO_IMPUESTO IS NULL THEN 'PRODUCTOS'
    ELSE AI.TIPO_IMPUESTO
    END AS TIPO_IMPUESTO,
    iddp.IMPUESTO_ID,
    ap.TIPO,
    sum(iddp.VALOR) AS TOTAL
    FROM DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT iddp
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO ap on ap.ID_PRODUCTO=iddp.producto_id
    LEFT JOIN DB_GENERAL.ADMI_IMPUESTO AI ON AI.ID_IMPUESTO=iddp.IMPUESTO_ID AND AI.ESTADO='Activo'
    WHERE 
    iddp.DOCUMENTO_ID=Pn_IdDocumento
    GROUP BY iddp.IMPUESTO_ID,ap.TIPO,AI.TIPO_IMPUESTO
    ORDER BY ap.TIPO;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_OBTENER_SUBTOTALES_BS', Lv_InfoError);  
END P_OBTENER_SUBTOTALES_BS;

PROCEDURE P_CREAR_CABECERA(
    Lr_Punto        IN TypeClientesFacturar,
    Ln_MesEmision   IN VARCHAR2,
    Lv_AnioEmision  IN VARCHAR2,
    Lr_InfoDocumentoFinancieroCab OUT INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE
    )
AS
    Lv_InfoError   VARCHAR2(3000);
    Lr_InfoDocumentoFinancieroHis INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Pv_MsnError                   VARCHAR2(5000);
BEGIN
    Lr_InfoDocumentoFinancieroCab             :=NULL;
    Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO:=SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
    Lr_InfoDocumentoFinancieroCab.OFICINA_ID  :=Lr_Punto.id_oficina;
    Lr_InfoDocumentoFinancieroCab.PUNTO_ID    :=Lr_Punto.id_punto;
    --Modificar a funcion de tipo de documento
    Lr_InfoDocumentoFinancieroCab.TIPO_DOCUMENTO_ID:=1;
    Lr_InfoDocumentoFinancieroCab.ES_AUTOMATICA    :='S';
    Lr_InfoDocumentoFinancieroCab.PRORRATEO        :='N';
    Lr_InfoDocumentoFinancieroCab.REACTIVACION     :='N';
    Lr_InfoDocumentoFinancieroCab.RECURRENTE       :='S';
    Lr_InfoDocumentoFinancieroCab.COMISIONA        :='S';
    Lr_InfoDocumentoFinancieroCab.FE_CREACION      :=sysdate;
    Lr_InfoDocumentoFinancieroCab.USR_CREACION     :='telcos';
    Lr_InfoDocumentoFinancieroCab.ES_ELECTRONICA   :='S';
    Lr_InfoDocumentoFinancieroCab.MES_CONSUMO      :=Ln_MesEmision;
    Lr_InfoDocumentoFinancieroCab.ANIO_CONSUMO     :=Lv_AnioEmision;

    IF Lr_Punto.ES_PREPAGO = 'N' THEN

        Lr_InfoDocumentoFinancieroCab.MES_CONSUMO   := TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM');
        Lr_InfoDocumentoFinancieroCab.ANIO_CONSUMO  := TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYY');

    END IF;
    Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT :='Pendiente';
    FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab,Pv_MsnError);
    --Con la informacion de cabecera se inserta el historial
    Lr_InfoDocumentoFinancieroHis                       :=NULL;
    Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:=SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
    Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
    Lr_InfoDocumentoFinancieroHis.FE_CREACION           :=SYSDATE;
    Lr_InfoDocumentoFinancieroHis.USR_CREACION          :='telcos';
    Lr_InfoDocumentoFinancieroHis.ESTADO                :='Pendiente';
    Lr_InfoDocumentoFinancieroHis.OBSERVACION           :='Se crea la factura, Cliente PAGA IVA: '||Lr_Punto.PAGA_IVA;
    FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Pv_MsnError);
      
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_CREAR_CABECERA', Lv_InfoError);  
END P_CREAR_CABECERA;

PROCEDURE P_CREAR_DETALLE(
    Lr_Servicio                   IN TypeServiciosAsociados,
    Ln_Porcentaje                 IN NUMBER,
    Ln_ValorImpuesto              IN NUMBER,
    Lr_InfoDocumentoFinancieroCab IN INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
    Ln_PorcentajeDescuento        IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE,
    Ln_DescuentoFacProDetalle     IN NUMBER,
    Lv_MesEmision                 IN VARCHAR2,
    Lv_AnioEmision                IN VARCHAR2,
    Lv_Observacion                IN DB_COMERCIAL.INFO_SERVICIO.DESCRIPCION_PRESENTA_FACTURA%TYPE,
    Pn_IdDocDetalle		          OUT INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE
    )
AS
    Lr_InfoDocumentoFinancieroDet INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
    Lr_InfoDocumentoFinancieroImp INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
    Pv_MsnError                   VARCHAR2(5000);
    Lv_FeActivacion               VARCHAR2(100);
    Ln_IdImpuesto                 DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE;
BEGIN
    --Con el precio de venta nuevo procedemos a ingresar los valores del detalle
    Lr_InfoDocumentoFinancieroDet                               := NULL;
    Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE                := SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
    Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID                  := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
    Lr_InfoDocumentoFinancieroDet.PUNTO_ID                      := Lr_Servicio.punto_id;
    Lr_InfoDocumentoFinancieroDet.PLAN_ID                       := Lr_Servicio.plan_id;
    Lr_InfoDocumentoFinancieroDet.CANTIDAD                      := Lr_Servicio.cantidad;
    Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE   := ROUND(Lr_Servicio.precio_venta,2);
    Lr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO   := Ln_PorcentajeDescuento;
    Lr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE      := Ln_DescuentoFacProDetalle;
    Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE          := ROUND(Lr_Servicio.precio_venta,2);
    Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE          := ROUND(Lr_Servicio.precio_venta,2);
    Lr_InfoDocumentoFinancieroDet.FE_CREACION                   := sysdate;
    Lr_InfoDocumentoFinancieroDet.USR_CREACION                  := 'telcos';
    Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                   := Lr_Servicio.producto_id;
    Lr_InfoDocumentoFinancieroDet.SERVICIO_ID                   := Lr_Servicio.id_servicio;
    Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE := Lv_Observacion;
    FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinancieroDet,Pv_MsnError);
    --
    Pn_IdDocDetalle := Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE;
    --
    --Pregunto si se guardo el detalle
    IF Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE>0 THEN
      IF Ln_ValorImpuesto>0 THEN
        --Con los valores de detalle insertado, podemos ingresar el impuesto
        Lr_InfoDocumentoFinancieroImp               :=NULL;
        Lr_InfoDocumentoFinancieroImp.ID_DOC_IMP    :=SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
        Lr_InfoDocumentoFinancieroImp.DETALLE_DOC_ID:=Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE;
        --Modificar funcion del impuesto
        --Obtener por descripcion
        Ln_IdImpuesto                               :=FNCK_FACTURACION_MENSUAL.F_CODIGO_IMPUESTO_X_PORCEN(Ln_Porcentaje);
        Lr_InfoDocumentoFinancieroImp.IMPUESTO_ID   :=Ln_IdImpuesto;
        Lr_InfoDocumentoFinancieroImp.VALOR_IMPUESTO:=Ln_ValorImpuesto;
        Lr_InfoDocumentoFinancieroImp.PORCENTAJE    :=Ln_Porcentaje;
        Lr_InfoDocumentoFinancieroImp.FE_CREACION   :=sysdate;
        Lr_InfoDocumentoFinancieroImp.USR_CREACION  :='telcos';
        FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinancieroImp,Pv_MsnError);
      END IF;  
    END IF;  
    
END P_CREAR_DETALLE;

--Permite crear el detalle de impuesto adicional que corresponde al impuesto adicional calculado
PROCEDURE P_CREAR_IMPUESTO_ADICIONAL(
    Pn_IdDocDetalle   IN INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
    Pn_IdImpuesto     IN NUMBER,
    Pn_ValorImpuesto  IN NUMBER,
    Pn_Porcentaje     IN NUMBER
    )
AS
    Pv_MsnError                   VARCHAR2(5000);
    Lr_InfoDocumentoFinancieroImp INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
BEGIN
    IF Pn_ValorImpuesto>0 THEN
        --Con los valores de detalle insertado, podemos ingresar el impuesto
        Lr_InfoDocumentoFinancieroImp               :=NULL;
        Lr_InfoDocumentoFinancieroImp.ID_DOC_IMP    :=SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
        Lr_InfoDocumentoFinancieroImp.DETALLE_DOC_ID:=Pn_IdDocDetalle;
        Lr_InfoDocumentoFinancieroImp.IMPUESTO_ID   :=Pn_IdImpuesto;
        Lr_InfoDocumentoFinancieroImp.VALOR_IMPUESTO:=Pn_ValorImpuesto;
        Lr_InfoDocumentoFinancieroImp.PORCENTAJE    :=Pn_Porcentaje;
        Lr_InfoDocumentoFinancieroImp.FE_CREACION   :=sysdate;
        Lr_InfoDocumentoFinancieroImp.USR_CREACION  :='telcos';
        FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinancieroImp,Pv_MsnError);
    END IF;  
END P_CREAR_IMPUESTO_ADICIONAL;

PROCEDURE P_ACTUALIZAR_CABECERA(
    Lr_InfoDocumentoFinancieroCab IN OUT INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
    Ln_Subtotal             IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
    Ln_SubtotalConImpuesto  IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
    Ln_SubtotalDescuento    IN INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
    Ln_ValorTotal           IN INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    Lv_PrefijoEmpresa       IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Ln_IdOficina            IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Lv_FeEmision            IN VARCHAR2,
    Ln_ValorCompensacion    IN INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE
    )
AS
    --Variables de la numeracion
    Lrf_Numeracion                FNKG_TYPES.Lrf_AdmiNumeracion;
    Lr_AdmiNumeracion             FNKG_TYPES.Lr_AdmiNumeracion;
    
    Lv_EsMatriz                   INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE;
    Lv_EsOficinaFacturacion       INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE;
    Lv_CodigoNumeracion           ADMI_NUMERACION.CODIGO%TYPE;
    
    Lv_Numeracion                 VARCHAR2(1000);
    Lv_Secuencia                  VARCHAR2(1000);
    
    Pv_MsnError                   VARCHAR2(5000);
BEGIN
    
    --Inicializando
     Lv_EsMatriz            :='S';
     Lv_EsOficinaFacturacion:='S';
     Lv_CodigoNumeracion    :='FACE';
    
    --Actualizo los valores
    Lr_InfoDocumentoFinancieroCab.SUBTOTAL              := ROUND(Ln_Subtotal,2);
    Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CERO_IMPUESTO:= ROUND(Ln_Subtotal,2);
    Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CON_IMPUESTO := ROUND(Ln_SubtotalConImpuesto,2);
    Lr_InfoDocumentoFinancieroCab.SUBTOTAL_DESCUENTO    := ROUND(Ln_SubtotalDescuento,2);
    
    --Compensacion Solidaria
    IF (Ln_ValorCompensacion > 0) THEN
      Lr_InfoDocumentoFinancieroCab.VALOR_TOTAL           := ROUND((Ln_ValorTotal-Ln_ValorCompensacion),2);
      Lr_InfoDocumentoFinancieroCab.DESCUENTO_COMPENSACION:= ROUND(Ln_ValorCompensacion,2);
    ELSE
      Lr_InfoDocumentoFinancieroCab.VALOR_TOTAL           := ROUND(Ln_ValorTotal,2);
    END IF;
    --Actualizo la numeracion y el estado
    /*
      Proceso: 
        1.- Para la empresa MD se da numeracion directamente, en las facturas
        2.- Para la empresa TN se da numeracion pero de PRE-facturas, por medio del TELCOS le da numeracion por oficina
    */
    IF (Lv_PrefijoEmpresa='MD') THEN
      Lrf_Numeracion:=FNCK_CONSULTS.F_GET_NUMERACION(Lv_PrefijoEmpresa,Lv_EsMatriz,Lv_EsOficinaFacturacion,Ln_IdOficina,Lv_CodigoNumeracion);
      --Debo recorrer la numeracion obtenida
      LOOP
        FETCH Lrf_Numeracion INTO Lr_AdmiNumeracion;
        EXIT
      WHEN Lrf_Numeracion%notfound;
        Lv_Secuencia :=LPAD(Lr_AdmiNumeracion.SECUENCIA,9,'0');
        Lv_Numeracion:=Lr_AdmiNumeracion.NUMERACION_UNO || '-'||Lr_AdmiNumeracion.NUMERACION_DOS||'-'||Lv_Secuencia;
      END LOOP;
      --Cierro la numeracion
      CLOSE Lrf_Numeracion;
      Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI   :=Lv_Numeracion;
      
      --Incremento la numeracion
      Lr_AdmiNumeracion.SECUENCIA:=Lr_AdmiNumeracion.SECUENCIA+1;
      FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lr_AdmiNumeracion.ID_NUMERACION,Lr_AdmiNumeracion,Pv_MsnError);
    END IF;  
    
    Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:='Pendiente';
    
    --Para definir la fecha de emision
    Lr_InfoDocumentoFinancieroCab.FE_EMISION           :=TO_DATE(Lv_FeEmision,'dd-mm-yyyy');
     
    --Actualizo los valores de la cabecera
    FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Pv_MsnError);
    
    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsnError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_ACTUALIZAR_CABECERA', Pv_MsnError);  
      
END P_ACTUALIZAR_CABECERA;
--
--
--
PROCEDURE P_NUMERAR_LOTE_POR_OFICINA(
      Pv_PrefijoEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_FeEmision           IN VARCHAR2,
      Pv_CodigoTipoDocumento IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_UsrCreacion         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
      Pv_EstadoImpresionFact IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
      Pv_EsElectronica       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_ELECTRONICA%TYPE,
      Pn_IdDocumento         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pv_MsnError            OUT VARCHAR2 )
    AS
      --Variables de la numeracion
      Lrf_Numeracion FNKG_TYPES.Lrf_AdmiNumeracion                           := NULL;
      Lr_AdmiNumeracion FNKG_TYPES.Lr_AdmiNumeracion                         := NULL;
      Lv_EsMatriz INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE                          := NULL;
      Lv_EsOficinaFacturacion INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE := NULL;
      Lv_CodigoNumeracion ADMI_NUMERACION.CODIGO%TYPE                        := 'FACE';
      Lv_Numeracion VARCHAR2(20)                                             := '';
      Lv_Secuencia  VARCHAR2(20)                                             := '';
      Lr_InfoDocumentoFinancieroCab INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE    := NULL;
      Ln_ContadorCommitParcial NUMBER                                        := 0;
      --
      CURSOR C_GetDocumentosNumerar( Cv_EstadoImpresionFact DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                                     Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                     Cv_CodigoTipoDocumento DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                     Cv_UsrCreacion DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                     Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE )
      IS
        --
        SELECT IDFC.ID_DOCUMENTO,
               IDFC.OFICINA_ID
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
        ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
        WHERE IDFC.ESTADO_IMPRESION_FACT = Cv_EstadoImpresionFact
        AND DB_FINANCIERO.FNCK_CONSULTS.F_GET_PREFIJO_BY_PUNTO(IDFC.PUNTO_ID, NULL) = Cv_PrefijoEmpresa
        AND ATDF.CODIGO_TIPO_DOCUMENTO   = Cv_CodigoTipoDocumento
        AND IDFC.NUMERO_FACTURA_SRI     IS NULL
        AND IDFC.USR_CREACION            = NVL2(Cv_UsrCreacion, TRIM(Cv_UsrCreacion), NVL(TRIM(IDFC.USR_CREACION), TRIM(IDFC.USR_CREACION)))
        AND IDFC.ID_DOCUMENTO            = NVL2(Cn_IdDocumento, Cn_IdDocumento, NVL(IDFC.ID_DOCUMENTO, IDFC.ID_DOCUMENTO))
        ORDER BY IDFC.OFICINA_ID;
      --
    BEGIN
      --
      --Proceso
      --
      IF C_GetDocumentosNumerar%ISOPEN THEN
        --
        CLOSE C_GetDocumentosNumerar;
        --
      END IF;
      --
      FOR I_GetDocumentosNumerar IN C_GetDocumentosNumerar( Pv_EstadoImpresionFact, 
                                                            Pv_PrefijoEmpresa, 
                                                            Pv_CodigoTipoDocumento,  
                                                            Pv_UsrCreacion, 
                                                            Pn_IdDocumento )
      LOOP
        --
        Lrf_Numeracion := FNCK_CONSULTS.F_GET_NUMERACION( Pv_PrefijoEmpresa, 
                                                          Lv_EsMatriz, 
                                                          Lv_EsOficinaFacturacion, 
                                                          I_GetDocumentosNumerar.OFICINA_ID,
                                                          Lv_CodigoNumeracion );
        --
        LOOP
          --
          FETCH Lrf_Numeracion INTO Lr_AdmiNumeracion;
          EXIT WHEN Lrf_Numeracion%NOTFOUND;
          --
          IF TRIM(Lr_AdmiNumeracion.SECUENCIA) IS NOT NULL AND TRIM(Lr_AdmiNumeracion.NUMERACION_UNO) IS NOT NULL 
             AND TRIM(Lr_AdmiNumeracion.NUMERACION_DOS) IS NOT NULL THEN
            --
            Lv_Secuencia  := LPAD(TRIM(Lr_AdmiNumeracion.SECUENCIA),9,'0');
            Lv_Numeracion := TRIM(Lr_AdmiNumeracion.NUMERACION_UNO) || '-' || TRIM(Lr_AdmiNumeracion.NUMERACION_DOS) || '-' || Lv_Secuencia;
            --
          END IF;
          --
        END LOOP;
        --
        --Cierro la numeracion
        CLOSE Lrf_Numeracion;
        --
        IF Lv_Numeracion IS NOT NULL THEN
          --
          Ln_ContadorCommitParcial := Ln_ContadorCommitParcial + 1;
          --
          Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI    := Lv_Numeracion;
          Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT := Pv_EstadoImpresionFact;
          Lr_InfoDocumentoFinancieroCab.ES_ELECTRONICA        := Pv_EsElectronica;
          Lr_InfoDocumentoFinancieroCab.FE_EMISION            := TO_DATE(Pv_FeEmision,'DD-MM-YYYY');
          --
          --Actualizo los valores de la cabecera
          FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(I_GetDocumentosNumerar.ID_DOCUMENTO, Lr_InfoDocumentoFinancieroCab, Pv_MsnError);
          --
          IF TRIM(Pv_MsnError) IS NULL THEN
            --
            --Incremento la numeracion
            Lr_AdmiNumeracion.SECUENCIA := Lr_AdmiNumeracion.SECUENCIA+1;
            --
            FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lr_AdmiNumeracion.ID_NUMERACION,Lr_AdmiNumeracion,Pv_MsnError);
            --
          END IF;
          --
          IF Ln_ContadorCommitParcial > 4999 THEN
            --
            Ln_ContadorCommitParcial := 0;
            --
            COMMIT;
            --
          END IF;
          --
        END IF;
        --
        --
      END LOOP;
      --
      IF C_GetDocumentosNumerar%ISOPEN THEN
        --
        CLOSE C_GetDocumentosNumerar;
        --
      END IF;
      --
      IF Ln_ContadorCommitParcial <= 4999 THEN
        --
        COMMIT;
        --
      END IF;
      --
    EXCEPTION
      --
    WHEN OTHERS THEN
      --
      ROLLBACK;
      --
      Pv_MsnError := DBMS_UTILITY.FORMAT_ERROR_STACK || '-' || DBMS_UTILITY.format_call_stack || chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_NUMERAR_LOTE_POR_OFICINA', Pv_MsnError);
      --
    END P_NUMERAR_LOTE_POR_OFICINA;
--
--
--
--
PROCEDURE P_PROCESAR_INFORMACION (
    Cn_Puntos_Facturar  IN T_ClientesFacturar,
    Ln_MesEmision       IN VARCHAR2,
    Lv_MesEmision       IN VARCHAR2,
    Lv_AnioEmision      IN VARCHAR2,
    Lv_PrefijoEmpresa   IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Ln_IdOficina        IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    Lv_FeEmision        IN VARCHAR2,
    Ln_Porcentaje       IN NUMBER,
    Ln_RecordCount      IN OUT NUMBER
    ) AS
      Lr_Punto                      TypeClientesFacturar;
      Lr_Servicio                   TypeServiciosAsociados;
      Ln_SimularionPorPorcentaje    NUMBER;
      Ln_SimulacionPorValor         NUMBER;
      Ln_DescuentoFacProDetalle     NUMBER;
      Ln_PrecioVentaFacProDetalle   NUMBER;
      Ln_ValorImpuesto              NUMBER;
      Ln_BanderaImpuesto            DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;
      
      Ln_IdDetalleSolicitud         DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
      Ln_PorcentajeDescuento        DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE;
      Ln_Subtotal                   INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
      Ln_SubtotalConImpuesto        INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE;
      Ln_SubtotalDescuento          INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE;
      Ln_ValorTotal                 INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
      Lv_Observacion                DB_COMERCIAL.INFO_SERVICIO.DESCRIPCION_PRESENTA_FACTURA%TYPE;
      
      Lr_InfoDocumentoFinancieroCab INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
      
      Pv_MsnError                   VARCHAR2(5000);
      LV_BanderaPoseeDetalle        VARCHAR2(2);
      Lv_BanderaSolicitud           VARCHAR2(2);
      Lr_Servicios                  T_ServiciosAsociados;
      Lr_Solicitud                  TypeSolicitudes;
      
      Lc_ServiciosFacturar          SYS_REFCURSOR;
      Lc_Solicitud                  SYS_REFCURSOR;
      Ln_SumatoriaBS                SYS_REFCURSOR;
      
      --Mensaje de ERROR para control de la simulacion
      Lv_InfoError                  VARCHAR2(2000);
      Ln_Contador                   NUMBER;
      
      Lr_Sumatoria                  TypeBienServicio;
      
      --Segun la nueva segmentacion de Bienes y Servicios
      Ln_SubtotalServicio           NUMBER;
      Ln_SubtotalBienes             NUMBER;
      Ln_IvaServicio                NUMBER;
      Ln_IvaBienes                  NUMBER;
      
      --Diferencia de sumar hasta los detalles
      Ln_SubtotalFunc               NUMBER;
      Ln_SubtotalDescuentoFunc      NUMBER;
      Ln_SubtotalConImpuestoFunc    NUMBER;
      Ln_ValorTotalFunc             NUMBER;
      
      --Indice del BULK de servicios
      indsx                         NUMBER;

      --
      Ln_BanderaImpuestoAdicional   NUMBER;
      Ln_PorSegunCliente            NUMBER;
      Ln_PorcentajeNuevo            NUMBER;
      Pn_IdDocDetalle		        INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE;
      Ln_PorcentajeImpAdicional	    NUMBER;
      Ln_IdImpuestoImpAdicional	    NUMBER;
      Ln_ValorImpuestoAdicional     NUMBER;
      Ln_AcumValorCompensacion      NUMBER;
      Ln_ValorCompensacion          NUMBER;
      Lv_CodEmpresa                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
      Lv_EstadoActivo               DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE                             := 'Activo';
      Lv_CodTipoDocumento           DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'FAC';
      Lv_Tag                        VARCHAR2(17)                                                            := 'compensacionAl14';
      --
      Lv_NombreParametro           DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'FACTURACION_MASIVA_TN';
      Lv_DescripcionParam          DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE      := 'NUMERO_DETALLES_FACTURA';
      Ln_LimitDet                  NUMBER;
      --
      CURSOR C_GetCodEmpresa(Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                             Cv_EstadoActivo DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE)
      IS
        --
        SELECT COD_EMPRESA
        FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
        WHERE PREFIJO = Cv_PrefijoEmpresa
        AND ESTADO    = Cv_EstadoActivo;
        --

      CURSOR C_GetParametroLimite(Cv_NombreParametro      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                   Cv_DescripcionParametro DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                   Cv_EstadoActivo         DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE,
                                   Cv_EmpresaCod           DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
      IS
        SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
             DB_GENERAL.ADMI_PARAMETRO_DET APD   
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APD.DESCRIPCION      = Cv_DescripcionParametro 
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APD.ESTADO           = Cv_EstadoActivo
        AND APD.EMPRESA_COD      = Cv_EmpresaCod;
        --
      --
  BEGIN
    --
    IF C_GetCodEmpresa%ISOPEN THEN
      CLOSE C_GetCodEmpresa;
    END IF;
    --
    IF C_GetParametroLimite%ISOPEN THEN
      CLOSE C_GetParametroLimite;
    END IF;
    --
    OPEN C_GetCodEmpresa(Lv_PrefijoEmpresa, Lv_EstadoActivo);
    --
    FETCH C_GetCodEmpresa INTO Lv_CodEmpresa;
    --
    CLOSE C_GetCodEmpresa;
    --
    
    --Obtenemos el par�metro de cantidad l�mite para el detalle de factura
    OPEN C_GetParametroLimite(Lv_NombreParametro,Lv_DescripcionParam,Lv_EstadoActivo,Lv_CodEmpresa);
    FETCH C_GetParametroLimite INTO Ln_LimitDet;
    CLOSE C_GetParametroLimite;
    --
    FOR indx IN 1 .. Cn_Puntos_Facturar.COUNT 
    LOOP
      
        --Contador para los commits, a los 5k se ejecuta
        Ln_RecordCount:= Ln_RecordCount + 1;      
        --Recorriendo en la data
        Lr_Punto:=Cn_Puntos_Facturar(indx);
        --Simulacion de facturacion que se puede dar en el punto
        P_SIMULAR_FACT_MENSUAL(Lr_Punto.id_punto,Ln_SimularionPorPorcentaje,Ln_SimulacionPorValor);
        --
        --Se verifica el tema de la compensacion y se busca el IVA al 12%
        --Si el cliente tiene la caracterisca se reescribe el porcentaje
        --Se debe cambiar el porcentaje de todo el proceso al porcentaje nuevo
        /*
        Actualizacion: 
        - Con la caracteristica llenamos el nuevo valor de la cabecera de la compensacion
        - Todos los clientes facturan al 14%
        - Ln_Porcentaje: Posee el porcentaja de impuesto activo
        - Ln_PorcentajeNuevo: Posee el porcentaje de impuesto de compensacion
        - Ln_PorSegunCliente: Porcentaje utilizado para el calculo
        */
        --Obtenemos el impuesto de compensacion, si el cliente tiene la caracteristica
        Ln_PorcentajeNuevo    := F_VERIFICAR_CARAC_PERSONA(Lr_Punto.id_punto);
        
        --Se valida si esta activo el tag de compensar las facturas hechas al 14%
        IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Lv_CodEmpresa, Lv_CodTipoDocumento, Lv_Tag) THEN
          --
          Ln_PorSegunCliente := Ln_Porcentaje;
          --
        ELSE
          --
          --Porcentaje para el cliente dependiendo si debe compensar o no
          IF ( Ln_PorcentajeNuevo > 0 ) THEN
            --
            Ln_PorSegunCliente := Ln_PorcentajeNuevo;
            --
          ELSE
            --
            Ln_PorSegunCliente := Ln_Porcentaje;
            --
          END IF;
          --
        END IF;

        --Inicializa variable compensacion ya que esta aplica a todos los servicios
        Ln_AcumValorCompensacion  :=0;
        Ln_ValorCompensacion      :=0;
        --
        IF (Ln_SimularionPorPorcentaje>0 AND Ln_SimulacionPorValor>0) THEN
          --Inicializo la bandera que se utilizara para los detalles
          LV_BanderaPoseeDetalle:='N';
          
          --Con el pto de facturacion podemos obtener los servicios asociados al punto
          --Creo un BULK COLLECT de los detalles a procesar
          GET_SERVICIO_ASOCIADOS(Lr_Punto.id_punto,Lc_ServiciosFacturar);
          LOOP
            --Inicializo la bandera por cada servicio, como por defecto que se facture todos los servicios
            Lv_BanderaSolicitud:='S';
            
            --Creo cabecera previo al BULK
            --Proceso de crear la cabecera
            
            FETCH Lc_ServiciosFacturar BULK COLLECT INTO Lr_Servicios LIMIT Ln_LimitDet;
            IF Lr_Servicios.COUNT > 0 THEN
              P_CREAR_CABECERA(Lr_Punto,Ln_MesEmision,Lv_AnioEmision,Lr_InfoDocumentoFinancieroCab);
            END IF;
            FOR indsx IN 1 .. Lr_Servicios.COUNT 
            LOOP
              Lr_Servicio:=Lr_Servicios(indsx);
              
              --Actualizo la informacion relevante al servicio para el conteo
              P_ACTUALIZAR_SERVICIO(Lr_Servicio.id_servicio);
              
              --Con los servicios verifico si posee solicitudes
              GET_SOLICITUDES_CANCEL_SUSP(Lr_Servicio.id_servicio,Lc_Solicitud);
              LOOP
                FETCH Lc_Solicitud INTO Lr_Solicitud;
                IF Lc_Solicitud%notfound THEN
                  Lv_BanderaSolicitud:='S';
                END IF;
                EXIT
                WHEN Lc_Solicitud%notfound;
                --Segun el tipo de solicitud verifico si el servicio se facturara o no
                IF Lr_Solicitud.descripcion_solicitud   ='SOLICITUD CANCELACION' THEN
                  Lv_BanderaSolicitud                  :='N';
                ELSIF Lr_Solicitud.descripcion_solicitud='SOLICITUD SUSPENSION TEMPORAL' THEN
                  Lv_BanderaSolicitud                  :='N';
                ELSE
                  Lv_BanderaSolicitud:='S';
                END IF;
              END LOOP;
              --Cierro el cursor de las solicitudes
              CLOSE Lc_Solicitud;
            
              --Dependiendo de la bandera de solicitud hago los sigts pasos
              IF Lv_BanderaSolicitud='S' THEN
                --Inicializo
                Ln_DescuentoFacProDetalle:=0;
                --Con los servicios verifico si posee descuento unico
                
                GET_SOL_DESCT_UNICO(Lr_Servicio.id_servicio,Ln_IdDetalleSolicitud,Ln_PorcentajeDescuento);
                --Si posee porcentaje de descuento, realizo los calculos
                --Debo actualizar la solicitud
                IF Ln_PorcentajeDescuento IS NOT NULL AND Ln_PorcentajeDescuento>0 THEN
                  UPD_SOL_DESCT_UNICO(Ln_IdDetalleSolicitud);
                  Ln_DescuentoFacProDetalle         :=((Lr_Servicio.cantidad*Lr_Servicio.precio_venta)*Ln_PorcentajeDescuento)/100;
                --Verifico si posee descuento fijo por porcentaje o valor; ya que este es el mandatorio  
                ELSIF Lr_Servicio.porcentaje_descuento>0 THEN
                   Ln_DescuentoFacProDetalle        :=((Lr_Servicio.cantidad*Lr_Servicio.precio_venta)*Lr_Servicio.porcentaje_descuento)/100;
                ELSIF Lr_Servicio.valor_descuento  >0 THEN
                  Ln_DescuentoFacProDetalle         :=Lr_Servicio.valor_descuento; 
                ELSE  
                  Ln_DescuentoFacProDetalle:=0;
                END IF;
                
                --Con los valores obtenidos procedo hacer los calculos para cada servicio
                Ln_PrecioVentaFacProDetalle:=0;
                Ln_PrecioVentaFacProDetalle:=(Lr_Servicio.cantidad*Lr_Servicio.precio_venta);
                
                --Calcula el valor del impuesto correspondiente al detalle
                --Verificando si el cliente paga o no iva y eso afecta a sus hijos 
                /*
                Adicional debemos verificar si el producto/plan genera iva:
                  - Producto: Tabla info_producto_impuesto, debe tener registro asociado al producto
                  - Plan: Tabla info_plan_cab, debe tener el campo IVA con el valor "S" -->OJO**
                  - Se estandariza la respuesta de las dos funciones.
                */
                --
                /*
                Actualizacion:
                - Para la compensacion solidaria, se debe sumar unicamente los subtotal y los valores de ice por cada detalle
                - Se acumulan en la variable compensacion
                - Se actualiza en la cabecera
                */
                Ln_BanderaImpuesto:=0;
                IF(Lr_Servicio.plan_id IS NOT NULL AND Lr_Servicio.plan_id>0)THEN
                  Ln_BanderaImpuesto:=F_VERIFICAR_IMPUESTO_PLAN(Lr_Servicio.plan_id);
                ELSIF(Lr_Servicio.producto_id IS NOT NULL AND Lr_Servicio.producto_id>0)THEN  
                  Ln_BanderaImpuesto:=F_VERIFICAR_IMPUESTO_PRODUCTO(Lr_Servicio.producto_id,'IVA');
                END IF;
                --
                Ln_ValorImpuesto         :=0;
                --
                Ln_ValorImpuestoAdicional:=0;
                --
                Ln_BanderaImpuestoAdicional:=F_VERIFICAR_IMPUESTO_PRODUCTO(Lr_Servicio.producto_id,'ICE');
                --
                IF(Ln_BanderaImpuestoAdicional>0) THEN
                --Se obtiene la informacion del impuesto ICE en estado Activo
                  Ln_PorcentajeImpAdicional :=F_OBTENER_IMPUESTO('ICE');
                  Ln_IdImpuestoImpAdicional  :=FNCK_FACTURACION_MENSUAL.F_CODIGO_IMPUESTO('ICE');
                  Ln_ValorImpuestoAdicional :=((Ln_PrecioVentaFacProDetalle-Ln_DescuentoFacProDetalle)*Ln_PorcentajeImpAdicional/100);
                END IF;
                --
                IF (Lr_Punto.PAGA_IVA='S' AND Ln_BanderaImpuesto>0) THEN
                  --Calculo el porcentaje
                  Ln_ValorImpuesto    := ((Ln_PrecioVentaFacProDetalle-Ln_DescuentoFacProDetalle+Ln_ValorImpuestoAdicional)*Ln_PorSegunCliente/100);
                  --
                  IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Lv_CodEmpresa, Lv_CodTipoDocumento, Lv_Tag) THEN
                    --
                    --Acumulado de la variable de compensacion
                    --Solo si el cliente posee el valor de Ln_PorcentajeNuevo ya que se verifica la caracteristica de compensacion
                    IF(Ln_PorcentajeNuevo       > 0) THEN
                      Ln_AcumValorCompensacion := Ln_AcumValorCompensacion + (Ln_PrecioVentaFacProDetalle-Ln_DescuentoFacProDetalle+Ln_ValorImpuestoAdicional);
                    END IF;
                    --
                  END IF;
                  --
                END IF;
                
                --Detalle para la factura
                Lv_Observacion := Lr_Servicio.observacion;
                --
                --Cuando la frecuencia del servicio facturado sea mayor a uno se a�ade la glosa del periodo de facturaci�n a la observaci�n del 
                --detalle facturado
                IF Lr_Servicio.frecuencia_producto IS NOT NULL AND Lr_Servicio.frecuencia_producto > 1 THEN
                  --
                  Lv_Observacion := Lv_Observacion || '. Periodo de Facturaci�n: ' 
                                    || DB_FINANCIERO.FNCK_CONSULTS.F_GET_DESCRIPCION_PERIODO_FACT(Lr_Servicio.frecuencia_producto);
                  --
                END IF;
                
                --Procedure para crear el detalle de los documentos
                P_CREAR_DETALLE(
                  Lr_Servicio,
                  Ln_PorSegunCliente,
                  Ln_ValorImpuesto,
                  Lr_InfoDocumentoFinancieroCab,
                  Ln_PorcentajeDescuento,
                  Ln_DescuentoFacProDetalle,
                  Lv_MesEmision,
                  Lv_AnioEmision,
                  Lv_Observacion,
                  Pn_IdDocDetalle
                  );


                  --Se verifica impuesto adicionales
                  IF (Ln_BanderaImpuestoAdicional>0) THEN
                    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL', 'Pn_IdDocDetalle', Pn_IdDocDetalle);
                    --Se procede a crear el impuesto adicional
                    P_CREAR_IMPUESTO_ADICIONAL(
                        Pn_IdDocDetalle,
                        Ln_IdImpuestoImpAdicional,
                        Ln_ValorImpuestoAdicional,
                        Ln_PorcentajeImpAdicional
                        );
                  END IF;
              ELSE
                Lv_InfoError:='Punto de Facturacion:'||Lr_Punto.id_punto||' No se factura el servicio: '||Lr_Servicio.id_servicio||' Bandera de solicitud:'||Lv_BanderaSolicitud;
                DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL', 'P_PROCESAR_INFORMACION', Lv_InfoError);
              END IF;
                        
            END LOOP;
            
            --FETCH Lc_ServiciosFacturar INTO Lr_Servicios;
            IF Lc_ServiciosFacturar%notfound THEN
              Lv_BanderaSolicitud:='N';
            END IF;
            
            --Totalizo a la salida del BULK
            --Proceso de creacion de documento individual terminado
            /*
              1.- Ejecutar el proceso de fodatel por individual
              2.- Sumarizar subtotal e ivas segun los detalles --> productos --> segun tipo 
              3.- Guardar los valores en sus respectivos campos
            */
            --DB_FINANCIERO.FNCK_FACTURACION_DETALLES.P_FACTURACION_DETALLE(NULL,NULL,NULL,'I',Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO);
            --P_OBTENER_SUBTOTALES_BS(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Ln_SumatoriaBS);
            
            --Actualizo los valores de subtotales mediante los valores desglozados
            Ln_Subtotal:=0;
            Ln_SubtotalDescuento:=0;
            Ln_SubtotalConImpuesto:=0;
            Ln_ValorTotal:=0;
        
            Ln_Subtotal             :=NVL(F_SUMAR_SUBTOTAL(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0);
            Ln_SubtotalConImpuesto  :=NVL(P_SUMAR_IMPUESTOS(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0);
            Ln_SubtotalDescuento    :=NVL(F_SUMAR_DESCUENTO(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0);
            Ln_ValorTotal           :=NVL((Ln_Subtotal-Ln_SubtotalDescuento)+Ln_SubtotalConImpuesto,0);
          
            IF Ln_Subtotal> Ln_SubtotalFunc THEN
              DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL', 'P_FACTURACION_MENSUAL',
                    'Id_Documento:'               || Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO ||
                    'Ln_Subtotal:'                || Ln_Subtotal ||
                    'Ln_SubtotalFunc: '           || Ln_SubtotalFunc ||
                    'Ln_SubtotalConImpuesto:'     || Ln_SubtotalConImpuesto ||
                    'Ln_SubtotalConImpuestoFunc:' || Ln_SubtotalConImpuestoFunc ||
                    'Ln_SubtotalDescuento:'       || Ln_SubtotalDescuento||
                    'Ln_ValorTotal:'              || Ln_ValorTotal||
                    'Ln_ValorTotalFunc:'          || Ln_ValorTotalFunc);
            END IF;
            --
            --
            IF FNCK_COM_ELECTRONICO.F_SHOW_TAG_EMPRESA(Lv_CodEmpresa, Lv_CodTipoDocumento, Lv_Tag) THEN
              --
              --Si el cliente posee el Ln_PorcentajeNuevo correspondiente a la compensacion obtenemos el porcentaje asociado
              IF(Ln_PorcentajeNuevo   > 0 AND Ln_AcumValorCompensacion>0) THEN
                --
                Ln_ValorCompensacion := (Ln_AcumValorCompensacion * (Ln_PorSegunCliente - Ln_PorcentajeNuevo))/100;
                --
              END IF;
              --
            END IF;
            --
            --
            P_ACTUALIZAR_CABECERA(
              Lr_InfoDocumentoFinancieroCab,
              Ln_Subtotal,
              Ln_SubtotalConImpuesto,
              Ln_SubtotalDescuento,
              Ln_ValorTotal,
              Lv_PrefijoEmpresa,
              Ln_IdOficina,
              Lv_FeEmision,
              Ln_ValorCompensacion
            );
            
            EXIT
              WHEN Lc_ServiciosFacturar%notfound;
          END LOOP;  
          
          --Se termina de procesar los servicios
          --Cierro el cursor de los servicios
          CLOSE Lc_ServiciosFacturar;
          
          -- Verifica Incremento el contador, para poder hacer el commit
          IF Ln_RecordCount>=5000 THEN
            COMMIT;
            Ln_RecordCount:=0;
          END IF;
      END IF;
    END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_PROCESAR_INFORMACION', Lv_InfoError);   
    --Salida del BULK
END P_PROCESAR_INFORMACION;

PROCEDURE P_FACTURACION_MENSUAL(
    Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_EsPrepago  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ES_PREPAGO%TYPE)
IS

  --Listados
  Lc_PuntosFacturar     SYS_REFCURSOR;
  
  --Tipos definidos
  Lr_Punto              TypeClientesFacturar;
  
  --Tipos de equivalentes a las tablas
  Ln_Id_Producto                DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
  Lv_PrefijoEmpresa             INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  Ln_IdOficina                  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
  
  --Variables
  Pv_MsnError                 VARCHAR2(5000);
  Ln_Precio                   NUMBER;
  Pn_UsrCreacion              VARCHAR2(20);
  Ln_Porcentaje               NUMBER;
  
  --Log de ejecucion
  Lv_ArchivoNombre            VARCHAR2(2000);
  Log_File                    UTL_FILE.FILE_TYPE;
  
  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
  
  --Tipo para el BULK
  Cn_Puntos_Facturar          T_ClientesFacturar;
  indx                        NUMBER;
  Ln_RecordCount              NUMBER(04):=0;
  
  --Generacion de fecha emision
  Lv_FeEmision                VARCHAR2(20);
  Ln_MesEmision               VARCHAR2(20);
  Lv_MesEmision               VARCHAR2(20);
  Lv_AnioEmision              VARCHAR2(20);
  
  --Cursor para el BULK por limite
  CURSOR C_PuntosFacturar (Cn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                           Cv_EsPrepago  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ES_PREPAGO%TYPE) IS
    SELECT 
    iog.empresa_id, 
    iog.id_oficina, 
    iper.id_persona_rol, 
    iper.persona_id, 
    ipu.login, 
    iper.empresa_rol_id, 
    ier.rol_id, 
    ar.descripcion_rol, 
    atr.descripcion_tipo_rol, 
    ipu.id_punto, 
    ipu.estado, 
    'S' as es_padre_facturacion, 
    'N' as gasto_administrativo,
    iper.ES_PREPAGO,
    per.PAGA_IVA
    FROM DB_COMERCIAL.info_oficina_grupo iog 
    JOIN DB_COMERCIAL.info_persona_empresa_rol iper ON iper.oficina_id=iog.id_oficina 
    JOIN DB_COMERCIAL.info_persona per ON per.id_persona=iper.persona_id 
    JOIN DB_COMERCIAL.info_empresa_rol ier ON ier.id_empresa_rol=iper.empresa_rol_id 
    JOIN DB_GENERAL.admi_rol ar ON ar.id_rol=ier.rol_id 
    JOIN DB_GENERAL.admi_tipo_rol atr ON atr.id_tipo_rol=ar.tipo_rol_id 
    JOIN DB_COMERCIAL.info_punto ipu ON IPU.PERSONA_EMPRESA_ROL_ID=iper.id_persona_rol 
    JOIN DB_COMERCIAL.info_servicio iser ON iser.PUNTO_FACTURACION_ID=ipu.id_punto 
    WHERE iog.empresa_id=Cn_EmpresaCod
    AND ier.empresa_cod=Cn_EmpresaCod
    AND (iper.estado='Activo' OR iper.estado='Modificado') 
    AND iper.ES_PREPAGO=Cv_EsPrepago
    AND EXISTS (
      SELECT null from DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL ipda 
      WHERE ipda.punto_id=ipu.id_punto
      AND ipda.es_padre_facturacion='S' 
    )
    AND atr.descripcion_tipo_rol='Cliente' 
    AND ar.descripcion_rol='Cliente' 
    AND iser.ESTADO='Activo' 
    AND iser.cantidad>0 
    AND iser.ES_VENTA='S' 
    AND iser.precio_venta>0 
    --Modificacion de frecuencias
    AND iser.frecuencia_producto>0
    AND iser.meses_restantes=0
    group by iog.empresa_id, 
    iog.id_oficina, 
    iper.id_persona_rol, 
    iper.persona_id, 
    ipu.login, 
    iper.empresa_rol_id, 
    ier.rol_id, 
    ar.descripcion_rol, 
    atr.descripcion_tipo_rol, 
    ipu.id_punto, 
    ipu.estado,
    iper.ES_PREPAGO,
    per.PAGA_IVA;
  
BEGIN
  
  --Seteamos el porcentaje de IVA
  Ln_Porcentaje:=F_OBTENER_IMPUESTO('IVA') ;
  
  --Seteamos la fecha de emision correspondiente al d�a en que se ejecuta el proceso de facturaci�n
  Lv_FeEmision   := TO_CHAR(SYSDATE,'dd/mm/yyyy');
  Lv_MesEmision  := TO_CHAR(SYSDATE,'MONTH','NLS_DATE_LANGUAGE = SPANISH');
  Ln_MesEmision  := TO_CHAR(SYSDATE,'mm');
  Lv_AnioEmision := TO_CHAR(SYSDATE,'yyyy');
  
  --Seteamos variables para obtener las numeraciones
  GET_PREFIJO_OFICINA(Pn_EmpresaCod,Lv_PrefijoEmpresa,Ln_IdOficina);
  
  --Obtengo los pos a facturar: Para las pruebas se han considerado 10
  --Se llama el cursor del BULK
  OPEN C_PuntosFacturar(Pn_EmpresaCod,Pv_EsPrepago);
  LOOP
    FETCH C_PuntosFacturar BULK COLLECT INTO Cn_Puntos_Facturar LIMIT 5000;
    --Llamada al proceso de escritura
    P_PROCESAR_INFORMACION (
    Cn_Puntos_Facturar,
    Ln_MesEmision,
    Lv_MesEmision,
    Lv_AnioEmision,
    Lv_PrefijoEmpresa,
    Ln_IdOficina,
    Lv_FeEmision,
    Ln_Porcentaje,
    Ln_RecordCount
    );
    --Llamada al proceso de escritura
    EXIT WHEN C_PuntosFacturar%NOTFOUND;
    
  END LOOP;
  CLOSE C_PuntosFacturar;
  if Ln_RecordCount >=0 then
     commit;
  End if;

  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_MENSUAL_TN', 'P_FACTURACION_MENSUAL', Lv_InfoError);    
END P_FACTURACION_MENSUAL;
END FNCK_FACTURACION_MENSUAL_TN;
/