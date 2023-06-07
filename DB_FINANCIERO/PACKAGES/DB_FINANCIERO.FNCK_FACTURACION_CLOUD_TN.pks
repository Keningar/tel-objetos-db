CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_FACTURACION_CLOUD_TN AS 

/*
* Documentación para TYPE 'TypeClientesFacturar'.
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
* Documentación para TYPE 'T_ClientesFacturar'.
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
  * @version 1.0 22-03-2018
  * @author Edgar Holguín <eholguin@telconet.ec>
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
        frecuencia_producto   DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
        observacion_consumo   INFO_CONSUMO_CLOUD_CAB.OBSERVACION%TYPE

  );
  --
  --
/*
* Documentación para TYPE 'TypeServiciosAsociados'.
* Record para almacenar la data enviada al BULK.
*/
TYPE T_ServiciosAsociados IS TABLE OF TypeServiciosAsociados INDEX BY PLS_INTEGER;



  --
  /**
  * Documentacion para type 'TypeConsumoDet'
  *
  * Record que me permite almancernar la informacion de los consumos de producto cloud form.
  *
  * @version 1.0 20-03-2018
  * @author Edgar Holguín <eholguin@telconet.ec>
  */
  TYPE TypeConsumoDet IS RECORD (
        id_caracteristica               DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,  
        descripcion_caracteristica      DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
        total                           DB_FINANCIERO.INFO_CONSUMO_CLOUD_DET.VALOR%TYPE
  );
  --
  --
/*
* Documentación para TYPE 'TypeConsumoDet'.
* Record para almacenar la data enviada al BULK.
*/
TYPE T_ConsumoDet IS TABLE OF TypeConsumoDet INDEX BY PLS_INTEGER;


/*
* Documentación para TYPE 'TypeBienServicio'.
* Record que me permite devolver los valores para los acumuladores de bienes y servicios
*/
Type TypeBienServicio IS RECORD (
      TIPO_IMPUESTO     VARCHAR(100),
      IMPUESTO_ID       DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE,
      TIPO              VARCHAR(100),
      TOTAL             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE
);

/*
* Documentación para TYPE 'TypeNumerar'.
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

--Funcion para obtener el porcentaje correspondiente al impuesto
FUNCTION F_OBTENER_IMPUESTO(Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) RETURN NUMBER;

--Funcion para verificar el impuesto ligado al producto
FUNCTION F_VERIFICAR_IMPUESTO_PRODUCTO(
    Fn_IdProducto   IN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PRODUCTO_ID%TYPE,
    Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
RETURN DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;
  --
  
--Procedimiento para obtener prefijo de la empresa
PROCEDURE GET_PREFIJO_OFICINA(Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Pv_Prefijo OUT DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                                Pn_Id_Oficina OUT DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE);
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
  * @version 1.1 22-02-2018 - Se Trunca Valor de Precio de Venta del Servicio a 2 decimales debido a errores de cuadratura
  *                           provocado por Precios de Venta a 9 decimales  
  */
  PROCEDURE GET_SERVICIO_ASOCIADOS(
      Pn_PuntoFacturacionId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Prf_Servicios         OUT SYS_REFCURSOR);

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
* @author Alex Arreaga <atarreaga@telconet.ec>
* @version 1.2 23-05-2019 - Se agrega validación debido a consumo de facturas en cero.
*
* @author Edgar Holguín <eholguin@telconet.ec>
* @version 1.3 03-07-2020 - Se agrega inserción de historial cuando se elimina documento.
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

/**
* Documentacion para procedure P_ACTUALIZA_CONSUMO
*
* Procedimiento que actuatilza el estado en la tabla INFO_CONSUMO_CLOUD_CAB según los valores enviados como parámetros.
*
* @author Edgar Holguín <eholguin@telconet.ec>
* @version 1.0
* @since 27-03-2018
*
*/
PROCEDURE P_ACTUALIZA_CONSUMO(
    Ln_PuntoFacturacionId   IN INFO_CONSUMO_CLOUD_CAB.PUNTO_FACTURACION_ID%TYPE,
    Lv_Estado               IN INFO_CONSUMO_CLOUD_CAB.ESTADO%TYPE
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
  * @param   VARCHAR2                                                      Lv_MesEmision                 Mes de emisión.
  * @param   VARCHAR2                                                      Lv_AnioEmision                Anio de emisión.
  * @param   VARCHAR2                                                      Lv_Observacion                Observación.
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
 * Documentación para FUNCION 'P_NUMERAR_LOTE_POR_OFICINA'.
 *
 * Procedimiento para numerar todo el lote de documentos pendientes
 * Se marca el campo ES_ELECTRONICA:='S' para que se envien al SRI
 *
 * @version 1.0 Version Inicial
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 - Se agrega el usuario de creación 'Pv_UsrCreacion' para verificar por usuario de creación las facturas a numerar
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.2 04-09-2016 - Se añade la variable 'Pn_IdDocumento' que contiene el id del documento a procesar
 *
 * PARAMETROS:
 * @param Pv_PrefijoEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (prefijo de la empresa que va a enumerarse)
 * @param Pv_FeEmision               VARCHAR2 (fecha de emisión de las facturas a numerar)
 * @param Pv_CodigoTipoDocumento     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE (código del tipo de documento a generar)
 * @param Pv_UsrCreacion             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE (usuario de creación de las facturas)
 * @param Pv_EstadoImpresionFact     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE (estado de las facturas a buscar)
 * @param Pv_EsElectronica           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_ELECTRONICA%TYPE (parámetro que indica si la factura es 
 *                                                                                                    electronica o no)
 * @param Pn_IdDocumento             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE (id del documento a procesar)
 * @return Pv_MsnError               VARCHAR2 (variable que retornará el mensaje de error en caso de existir )
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
  * @param Cn_Puntos_Facturar  IN T_ClientesFacturar  Cursor con los puntos de facturación
  * @param Ln_MesEmision       IN VARCHAR2  Mes de emisión en números de la factura a realizar
  * @param Lv_MesEmision       IN VARCHAR2  Mes de emisión en letras de la factura a realizar
  * @param Lv_AnioEmision      IN VARCHAR2  Año de emisión de la factura a realizar
  * @param Lv_PrefijoEmpresa   IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE  Prefijo de la empresa la cual realiza el proceso de facturación
  * @param Ln_IdOficina        IN INFO_OFICINA_GRUPO.ID_OFICINA%TYPE  Id de la oficina de facturación
  * @param Lv_FeEmision        IN VARCHAR2  Fecha de emisión de la factura realizada
  * @param Ln_Porcentaje       IN NUMBER   Porcentaje del iva que se va a calcular
  * @param Ln_RecordCount      IN OUT NUMBER  Número de documentos creados.
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @since 1.0
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.1 - Se agrega Ln_BanderaImpuestoAdicional, para el impuesto adicional en este caso el ICE
  * @since 30-09-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 14-10-2016 - Se parametriza la validación de compensación de las facturas al 14% y al 12%.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 14-03-2017 - Cuando el servicio facturado tiene frecuencia mayor que uno se añade a la descripción del servicio facturado una glosa
  *                           informativa indicado el periodo facturado del servicio.
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.4 15-07-2019 - Se trunca a 300 caracteres la observación del detalle del documento financiero por error en la facturación de servicios
  *                           Cou Telefonía Fija.
  *
  * @author Gustavo Narea <gnarea@telconet.ec>
  * @version 1.5 01-09-2022 - Se quita mes y año de consumo y agrega rango de consumo en facturacion de productos de Cou Telefonía Fija.
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
  * Documentación para el procedimiento '  PROCEDURE P_FACTURACION_CLOUD'.
  *
  * Procedimiento para realiza la facturación de los puntos de facturación de servicios con producto cloud form.
  *
  * @version 1.0 Version Inicial
  * @author Edgar Holguín <eholguin@telconet.ec>
  *
  * PARAMETROS:
  * @param Pn_EmpresaCod  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  Código de la empresa de la cual se va a ejecutar el proceso
  */
  PROCEDURE P_FACTURACION_CLOUD(
      Pv_Producto IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
      Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE);

 /**
 * Documentacion para la funcion F_GET_DESCRIPCION_PROD
 * Función que retorna la descripción del producto enviado como parámetro
 * @param  Fv_IdProducto IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE  Recibe el id del producto a consultar.
 * @return VARCHAR2   Retona la descripción del producto a consultar;
 * @author Edgar Holguín <eholguin@telconet.ec>
 * @version 1.0 20-01-2018
 */

 FUNCTION F_GET_DESCRIPCION_PROD(
   Fv_IdProducto IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE)
 RETURN VARCHAR2;


END FNCK_FACTURACION_CLOUD_TN;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_FACTURACION_CLOUD_TN
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
    SELECT ISER.ID_SERVICIO, 
    ISER.PRODUCTO_ID, 
    ISER.PLAN_ID, 
    ISER.PUNTO_ID, 
    ISER.CANTIDAD, 
    NVL(ROUND(SUM(ICD.VALOR), 2),0) AS PRECIO_VENTA,
    NVL(ISER.PORCENTAJE_DESCUENTO,0) AS  PORCENTAJE_DESCUENTO, 
    NVL(ISER.VALOR_DESCUENTO,0) AS  VALOR_DESCUENTO, 
    ISER.PUNTO_FACTURACION_ID, 
    ISER.ESTADO,
    ISER.DESCRIPCION_PRESENTA_FACTURA,
    ISER.FRECUENCIA_PRODUCTO,
    DBMS_LOB.substr(ICC.OBSERVACION, 4000) OBSERVACION_CONSUMO
    FROM DB_COMERCIAL.INFO_SERVICIO ISER 
    JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC ON APC.PRODUCTO_ID          = ISER.PRODUCTO_ID
    JOIN DB_COMERCIAL.ADMI_CARACTERISTICA          AC  ON AC.ID_CARACTERISTICA     = APC.CARACTERISTICA_ID
    JOIN DB_FINANCIERO.INFO_CONSUMO_CLOUD_CAB      ICC ON ICC.PUNTO_FACTURACION_ID = ISER.PUNTO_FACTURACION_ID
    JOIN   DB_FINANCIERO.INFO_CONSUMO_CLOUD_DET    ICD ON ICC.ID_CONSUMO_CLOUD_CAB = ICD.CONSUMO_CLOUD_CAB_ID
    WHERE ISER.PUNTO_FACTURACION_ID=PN_PUNTOFACTURACIONID 
    AND ISER.ID_SERVICIO = ICC.SERVICIO_ID
    AND ISER.ESTADO='Activo' 
    AND ISER.CANTIDAD>0 
    AND ISER.ES_VENTA='S' 
    AND AC.DESCRIPCION_CARACTERISTICA = 'FACTURACION POR CONSUMO'
    AND ICC.ESTADO = 'Validado'
    AND ICC.FE_CONSUMO >= TRUNC(add_months(sysdate,-1),'MM')
    AND ICC.FE_CONSUMO <=  LAST_DAY(add_months(sysdate,-1))
    GROUP BY  ISER.ID_SERVICIO, 
    ISER.PRODUCTO_ID, 
    ISER.PLAN_ID, 
    ISER.PUNTO_ID, 
    ISER.CANTIDAD, 
    ISER.PORCENTAJE_DESCUENTO, 
    ISER.VALOR_DESCUENTO, 
    ISER.PUNTO_FACTURACION_ID, 
    ISER.ESTADO,
    ISER.DESCRIPCION_PRESENTA_FACTURA,
    ISER.FRECUENCIA_PRODUCTO,
    DBMS_LOB.substr(ICC.OBSERVACION, 4000);
  EXCEPTION
  WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'GET_SERVICIO_ASOCIADOS', Lv_InfoError); 
END GET_SERVICIO_ASOCIADOS;


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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'GET_PREFIJO_OFICINA', Lv_InfoError); 
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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'F_SUMAR_SUBTOTAL', Lv_InfoError);   
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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'F_SUMAR_DESCUENTO', Lv_InfoError);   
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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'P_SUMAR_IMPUESTOS', Lv_InfoError);  
END P_SUMAR_IMPUESTOS;

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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'F_OBTENER_IMPUESTO', Lv_InfoError);  
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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'F_VERIFICAR_IMPUESTO_PLAN', Lv_InfoError);  
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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'F_VERIFICAR_IMPUESTO_PRODUCTO', Lv_InfoError);  
END F_VERIFICAR_IMPUESTO_PRODUCTO;
  --
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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'P_OBTENER_SUBTOTALES_BS', Lv_InfoError);  
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
    Lr_InfoDocumentoFinancieroCab.TIPO_DOCUMENTO_ID      :=1;
    Lr_InfoDocumentoFinancieroCab.ES_AUTOMATICA          :='S';
    Lr_InfoDocumentoFinancieroCab.PRORRATEO              :='N';
    Lr_InfoDocumentoFinancieroCab.REACTIVACION           :='N';
    Lr_InfoDocumentoFinancieroCab.RECURRENTE             :='S';
    Lr_InfoDocumentoFinancieroCab.COMISIONA              :='S';
    Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT  :='Pendiente';
    Lr_InfoDocumentoFinancieroCab.FE_CREACION            :=sysdate;
    Lr_InfoDocumentoFinancieroCab.USR_CREACION           :='telcos_consumo';
    Lr_InfoDocumentoFinancieroCab.ES_ELECTRONICA         :='S';    
    Lr_InfoDocumentoFinancieroCab.MES_CONSUMO            := TO_CHAR(ADD_MONTHS(SYSDATE,-1),'MM');
    Lr_InfoDocumentoFinancieroCab.ANIO_CONSUMO           := TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYY');   

    FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab,Pv_MsnError);
    --Con la informacion de cabecera se inserta el historial
    Lr_InfoDocumentoFinancieroHis                       :=NULL;
    Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:=SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
    Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
    Lr_InfoDocumentoFinancieroHis.FE_CREACION           :=SYSDATE;
    Lr_InfoDocumentoFinancieroHis.USR_CREACION          :='telcos_consumo';
    Lr_InfoDocumentoFinancieroHis.ESTADO                :='Pendiente';
    Lr_InfoDocumentoFinancieroHis.OBSERVACION           :='Se crea la factura, Cliente PAGA IVA: '||Lr_Punto.PAGA_IVA;
    FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Pv_MsnError);
      
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'P_CREAR_CABECERA', Lv_InfoError);  
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
    Lr_InfoDocumentoFinancieroDet.USR_CREACION                  := 'telcos_consumo';
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
    Lr_InfoDocumentoFinancieroHis DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
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
    IF (Lv_PrefijoEmpresa='MD' AND Ln_ValorTotal > 0) THEN
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
    
    IF Ln_ValorTotal > 0 THEN 
        Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:='Pendiente'; 
    ELSE  
        Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:='Eliminado';

        Lr_InfoDocumentoFinancieroHis                       :=NULL;
        Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:=SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
        Lr_InfoDocumentoFinancieroHis.FE_CREACION           :=SYSDATE;
        Lr_InfoDocumentoFinancieroHis.USR_CREACION          := Lr_InfoDocumentoFinancieroCab.USR_CREACION;
        Lr_InfoDocumentoFinancieroHis.ESTADO                :='Eliminado';
        Lr_InfoDocumentoFinancieroHis.OBSERVACION           :='Se elimina documento, valor total no es mayor a 0 ';
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Pv_MsnError);
    END IF;
    
    --Para definir la fecha de emision
    Lr_InfoDocumentoFinancieroCab.FE_EMISION           :=TO_DATE(Lv_FeEmision,'dd-mm-yyyy');
     
    --Actualizo los valores de la cabecera
    FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Pv_MsnError);
    
    EXCEPTION
    WHEN OTHERS THEN
      Pv_MsnError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'P_ACTUALIZAR_CABECERA', Pv_MsnError);  
      
END P_ACTUALIZAR_CABECERA;

--
--
--

PROCEDURE P_ACTUALIZA_CONSUMO(
    Ln_PuntoFacturacionId   IN INFO_CONSUMO_CLOUD_CAB.PUNTO_FACTURACION_ID%TYPE,
    Lv_Estado               IN INFO_CONSUMO_CLOUD_CAB.ESTADO%TYPE
)
AS
  Pv_MsnError VARCHAR2(5000);
BEGIN

  UPDATE DB_FINANCIERO.INFO_CONSUMO_CLOUD_CAB ICLC 
  SET ICLC.ESTADO      = Lv_Estado, 
      ICLC.USR_ULT_MOD = 'telcos_consumo', 
      ICLC.FE_ULT_MOD  = SYSDATE, 
      ICLC.IP_ULT_MOD  =  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')
  WHERE ICLC.ESTADO    = 'Validado'
  AND ICLC.FE_CONSUMO  >= TRUNC(SYSDATE-(EXTRACT(DAY FROM SYSDATE)),'MM')
  AND ICLC.FE_CONSUMO  <=  LAST_DAY(SYSDATE-(EXTRACT(DAY FROM SYSDATE)))
  AND ICLC.PUNTO_FACTURACION_ID = Ln_PuntoFacturacionId;
    
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsnError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'P_ACTUALIZA_CONSUMO', Pv_MsnError);
       
END P_ACTUALIZA_CONSUMO;

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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'P_NUMERAR_LOTE_POR_OFICINA', Pv_MsnError);
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
      Lr_Consumo                    TypeConsumoDet;
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
      Lr_Servicios                  T_ServiciosAsociados;
      Lr_ConsumosCloud              T_ConsumoDet;
      
      Lc_ServiciosFacturar          SYS_REFCURSOR;
      Lc_ConsumosFacturar           SYS_REFCURSOR;
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
      Ln_ValorTotalConsumo          NUMBER;
      Ln_ValorCompensacion          NUMBER;
      Ln_BanderaImpuestoAdicional   NUMBER;
      Ln_PorSegunCliente            NUMBER;
      Ln_PorcentajeImpAdicional	    NUMBER;
      Ln_IdImpuestoImpAdicional	    NUMBER;
      Ln_ValorImpuestoAdicional     NUMBER;
      Pn_IdDocDetalle		        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE;
      Ln_PuntoFacturacionId         DB_FINANCIERO.INFO_CONSUMO_CLOUD_CAB.PUNTO_FACTURACION_ID%TYPE;
      Lv_EstadoProcesado            DB_FINANCIERO.INFO_CONSUMO_CLOUD_CAB.ESTADO%TYPE := 'Procesado';
      Lv_CodEmpresa                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
      Lv_EstadoActivo               DB_COMERCIAL.INFO_EMPRESA_GRUPO.ESTADO%TYPE                             := 'Activo';
      Lv_CodTipoDocumento           DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'FAC';
      Lv_FacturacionRangoFecha      VARCHAR2(200);
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

      --Costo 10
      CURSOR C_Consumo_Cloud(Cn_id_punto NUMBER)
      IS
        SELECT ICLD.RANGO_CONSUMO 
        FROM DB_COMERCIAL.INFO_PUNTO IPU 
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO SER ON IPU.ID_PUNTO = SER.PUNTO_ID
        INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON SER.PRODUCTO_ID  = PRO.ID_PRODUCTO 
        INNER JOIN DB_FINANCIERO.INFO_CONSUMO_CLOUD_CAB ICLD ON ICLD.PUNTO_FACTURACION_ID = SER.PUNTO_FACTURACION_ID 
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APDE ON APDE.VALOR1 = PRO.DESCRIPCION_PRODUCTO
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APCA ON APCA.ID_PARAMETRO = APDE.PARAMETRO_ID
        WHERE 
        ICLD.FE_CONSUMO >= TRUNC(SYSDATE-(EXTRACT(DAY FROM SYSDATE)),'MM')
        AND ICLD.FE_CONSUMO <=  LAST_DAY(SYSDATE-(EXTRACT(DAY FROM SYSDATE)))
        AND APCA.NOMBRE_PARAMETRO = 'PARAMETROS_LINEAS_TELEFONIA'
        AND APDE.DESCRIPCION = 'PARAM_PRODUCTO_RANGOFECHA'
        AND APDE.ESTADO = 'Activo'
        AND ICLD.RANGO_CONSUMO IS NOT NULL
        AND ICLD.ESTADO= 'Validado'
        AND ICLD.SERVICIO_ID = SER.ID_SERVICIO
        AND SER.PUNTO_FACTURACION_ID = Cn_id_punto;
    
      --
  BEGIN

    Ln_ValorCompensacion := 0;
    --
    IF C_GetCodEmpresa%ISOPEN THEN
      CLOSE C_GetCodEmpresa;
    END IF;
    --
    OPEN C_GetCodEmpresa(Lv_PrefijoEmpresa, Lv_EstadoActivo);
    --
    FETCH C_GetCodEmpresa INTO Lv_CodEmpresa;
    --
    CLOSE C_GetCodEmpresa;
    --
    FOR indx IN 1 .. Cn_Puntos_Facturar.COUNT 
    LOOP
      
        --Contador para los commits, a los 5k se ejecuta
        Ln_RecordCount:= Ln_RecordCount + 1;      
        --Recorriendo en la data
        Lr_Punto:=Cn_Puntos_Facturar(indx);
        --
        Ln_PorSegunCliente := Ln_Porcentaje;
          --Con el pto de facturacion podemos obtener los servicios asociados al punto
          --Creo un BULK COLLECT de los detalles a procesar
        GET_SERVICIO_ASOCIADOS(Lr_Punto.id_punto,Lc_ServiciosFacturar);

        --IF Lc_ServiciosFacturar%FOUND THEN
        --Creo cabecera de la factura
        P_CREAR_CABECERA(Lr_Punto,Ln_MesEmision,Lv_AnioEmision,Lr_InfoDocumentoFinancieroCab);

        ---C_CONSUMO_CLOUD
        IF C_Consumo_Cloud%ISOPEN THEN
          CLOSE C_Consumo_Cloud;
        END IF;
        OPEN C_Consumo_Cloud(Lr_Punto.id_punto);
        FETCH C_Consumo_Cloud INTO Lv_FacturacionRangoFecha;
        IF C_Consumo_Cloud%NOTFOUND THEN
          Lv_FacturacionRangoFecha := NULL;
        END IF;
        CLOSE C_Consumo_Cloud;

        IF Lv_FacturacionRangoFecha IS NOT NULL THEN
          Lr_InfoDocumentoFinancieroCab.MES_CONSUMO := NULL;
          Lr_InfoDocumentoFinancieroCab.ANIO_CONSUMO := NULL;
          Lr_InfoDocumentoFinancieroCab.RANGO_CONSUMO := Lv_FacturacionRangoFecha;
          UPDATE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
          SET MES_CONSUMO = NULL,
          ANIO_CONSUMO = NULL,
          RANGO_CONSUMO = Lv_FacturacionRangoFecha 
          WHERE ID_DOCUMENTO = Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
        END IF;

       -- END IF;
        FETCH Lc_ServiciosFacturar BULK COLLECT INTO Lr_Servicios LIMIT 100;
        FOR indsx IN 1 .. Lr_Servicios.COUNT 
        LOOP
          Lr_Servicio:=Lr_Servicios(indsx);
          Ln_DescuentoFacProDetalle:=0;
          Ln_ValorTotalConsumo:=0;

          --Con los valores obtenidos procedo hacer los calculos para cada servicio
          Ln_PrecioVentaFacProDetalle := Lr_Servicio.precio_venta;

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
            Ln_IdImpuestoImpAdicional :=FNCK_FACTURACION_MENSUAL.F_CODIGO_IMPUESTO('ICE');
            Ln_ValorImpuestoAdicional :=((Ln_PrecioVentaFacProDetalle-Ln_DescuentoFacProDetalle)*Ln_PorcentajeImpAdicional/100);
          END IF;
            --
          IF (Lr_Punto.PAGA_IVA='S' AND Ln_BanderaImpuesto>0) THEN
            --Calculo el porcentaje
            Ln_ValorImpuesto    := ((Ln_PrecioVentaFacProDetalle-Ln_DescuentoFacProDetalle+Ln_ValorImpuestoAdicional)*Ln_PorSegunCliente/100);
              --
          END IF;
          
          Lv_Observacion := DB_FINANCIERO.FNCK_FACTURACION_CLOUD_TN.F_GET_DESCRIPCION_PROD(Lr_Servicio.producto_id);
          if Lv_Observacion = 'COU LINEAS TELEFONIA FIJA' then
            Lv_Observacion := SUBSTR('['||Lv_Observacion||'] '||Lr_Servicio.observacion_consumo,0,300);
          else
            Lv_Observacion := Lv_Observacion || 
            '. Facturacion de consumo de recursos: Memoria,disco,procesador. El detalle a revisarlo en el portal de Cloud IAAS Publico.';
          end if;

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
              DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'Pn_IdDocDetalle', Pn_IdDocDetalle);
              --Se procede a crear el impuesto adicional
              P_CREAR_IMPUESTO_ADICIONAL(
                  Pn_IdDocDetalle,
                  Ln_IdImpuestoImpAdicional,
                  Ln_ValorImpuestoAdicional,
                  Ln_PorcentajeImpAdicional
                  );
            END IF;

        END LOOP;

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
          DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'P_PROCESAR_INFORMACION',
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

        Ln_PuntoFacturacionId := Lr_Punto.id_punto;
        P_ACTUALIZA_CONSUMO(Lr_Punto.id_punto,Lv_EstadoProcesado);

        --Se termina de procesar los consumos 
        --Cierro el cursor de los servicios a facturar
        CLOSE Lc_ServiciosFacturar;

        -- Verifica Incremento el contador, para poder hacer el commit
        IF Ln_RecordCount>0 THEN
          COMMIT;
        END IF;
    END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
      ROLLBACK;
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', 'P_PROCESAR_INFORMACION', Lv_InfoError);   
    --Salida del BULK
END P_PROCESAR_INFORMACION;

PROCEDURE P_FACTURACION_CLOUD(
    Pv_Producto IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
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
  CURSOR C_PuntosFacturar (Cn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) IS
    SELECT 
    IOG.EMPRESA_ID, 
    IOG.ID_OFICINA, 
    IPER.ID_PERSONA_ROL, 
    IPER.PERSONA_ID, 
    IPU.LOGIN, 
    IPER.EMPRESA_ROL_ID, 
    IER.ROL_ID, 
    AR.DESCRIPCION_ROL, 
    ATR.DESCRIPCION_TIPO_ROL, 
    SER.PUNTO_FACTURACION_ID, 
    IPU.ESTADO, 
    'S' AS ES_PADRE_FACTURACION, 
    'N' AS GASTO_ADMINISTRATIVO,
    IPER.ES_PREPAGO,
    PERS.PAGA_IVA
    FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG 
    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.OFICINA_ID=IOG.ID_OFICINA 
    JOIN DB_COMERCIAL.INFO_PERSONA PERS ON PERS.ID_PERSONA=IPER.PERSONA_ID 
    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IER.ID_EMPRESA_ROL=IPER.EMPRESA_ROL_ID 
    JOIN DB_GENERAL.ADMI_ROL AR ON AR.ID_ROL=IER.ROL_ID 
    JOIN DB_GENERAL.ADMI_TIPO_ROL ATR ON ATR.ID_TIPO_ROL=AR.TIPO_ROL_ID 
    JOIN DB_COMERCIAL.INFO_PUNTO IPU ON IPU.PERSONA_EMPRESA_ROL_ID=IPER.ID_PERSONA_ROL 
    JOIN DB_COMERCIAL.INFO_SERVICIO SER ON SER.PUNTO_ID= IPU.ID_PUNTO
    JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON SER.PRODUCTO_ID  = PRO.ID_PRODUCTO 
    JOIN DB_FINANCIERO.INFO_CONSUMO_CLOUD_CAB ICLD ON ICLD.PUNTO_FACTURACION_ID = SER.PUNTO_FACTURACION_ID 
    WHERE IOG.EMPRESA_ID=Cn_EmpresaCod
    AND IER.EMPRESA_COD=Cn_EmpresaCod
    AND (IPER.ESTADO='Activo' OR IPER.ESTADO='Modificado') 
    AND ATR.DESCRIPCION_TIPO_ROL='Cliente' 
    AND AR.DESCRIPCION_ROL='Cliente' 
    AND ICLD.ESTADO='Validado'
    AND PRO.DESCRIPCION_PRODUCTO = Pv_Producto
    AND ICLD.FE_CONSUMO >= TRUNC(SYSDATE-(EXTRACT(DAY FROM SYSDATE)),'MM')
    AND ICLD.FE_CONSUMO <=  LAST_DAY(SYSDATE-(EXTRACT(DAY FROM SYSDATE))) 
    GROUP BY IOG.EMPRESA_ID, 
    IOG.ID_OFICINA, 
    IPER.ID_PERSONA_ROL, 
    IPER.PERSONA_ID, 
    IPU.LOGIN, 
    IPER.EMPRESA_ROL_ID, 
    IER.ROL_ID, 
    AR.DESCRIPCION_ROL, 
    ATR.DESCRIPCION_TIPO_ROL, 
    SER.PUNTO_FACTURACION_ID,
    IPU.ESTADO,
    IPER.ES_PREPAGO,
    PERS.PAGA_IVA;
  
BEGIN
  
  --Seteamos el porcentaje de IVA
  Ln_Porcentaje:=F_OBTENER_IMPUESTO('IVA') ;
  
  --Seteamos la fecha de emision correspondiente al día en que se ejecuta el proceso de facturación
  Lv_FeEmision   := TO_CHAR(SYSDATE,'dd/mm/yyyy');
  Lv_MesEmision  := TO_CHAR(SYSDATE,'MONTH','NLS_DATE_LANGUAGE = SPANISH');
  Ln_MesEmision  := TO_CHAR(SYSDATE,'mm');
  Lv_AnioEmision := TO_CHAR(SYSDATE,'yyyy');
  
  --Seteamos variables para obtener las numeraciones
  GET_PREFIJO_OFICINA(Pn_EmpresaCod,Lv_PrefijoEmpresa,Ln_IdOficina);
  
  --Obtengo los pos a facturar: Para las pruebas se han considerado 10
  --Se llama el cursor del BULK
  OPEN C_PuntosFacturar(Pn_EmpresaCod);
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
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FNCK_FACTURACION_CLOUD_TN', '  PROCEDURE P_FACTURACION_CLOUD', Lv_InfoError);    
END P_FACTURACION_CLOUD;


FUNCTION F_GET_DESCRIPCION_PROD(
    Fv_IdProducto IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GetDescripcionProd(Cv_IdProducto IN DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE)
  IS
    SELECT
      AP.DESCRIPCION_PRODUCTO
    FROM
      DB_COMERCIAL.ADMI_PRODUCTO AP
    WHERE
      AP.ID_PRODUCTO = Cv_IdProducto;
  --
  Lc_GetDescripcionProd C_GetDescripcionProd%ROWTYPE;
  --
BEGIN
  --
  IF C_GetDescripcionProd%ISOPEN THEN
    --
    CLOSE C_GetDescripcionProd;
    --
  END IF;
  --
  OPEN C_GetDescripcionProd(Fv_IdProducto);
  --
  FETCH
    C_GetDescripcionProd
  INTO
    Lc_GetDescripcionProd;
  --
  CLOSE C_GetDescripcionProd;
  --
  RETURN Lc_GetDescripcionProd.DESCRIPCION_PRODUCTO;
  --
END F_GET_DESCRIPCION_PROD;

END FNCK_FACTURACION_CLOUD_TN;
/
