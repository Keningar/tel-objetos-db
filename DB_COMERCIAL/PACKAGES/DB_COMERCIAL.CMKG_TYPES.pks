CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_TYPES 
AS
--
  /**
  * Documentacion para el PKG CMKG_TYPES
  * El PKG CMKG_TYPES contendra las variables que sean necesarias a usar en los PKG de consultas o transacciones
  * separando procedimientos y funciones de las declaraciones de variables
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 15-12-2016
  */
  --

  /*
  * Documentación para TYPE 'Lr_RptClientesFacturas'.
  * Record que me permite devolver los valores para setear columnas del reporte de clientes con sus primeras facturas
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 15-12-2016
  */
  TYPE Lr_RptClientesFacturas IS RECORD (
          ID_QUERY                   NUMBER,
          ID_CLIENTE                 DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,   
          ESTADO                     DB_COMERCIAL.INFO_PERSONA.ESTADO%TYPE,   
          CLIENTE                    VARCHAR2(500), 
          IDENTIFICACION             DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,    
          NUMERO_EMP_PUB             DB_COMERCIAL.INFO_CONTRATO.NUMERO_CONTRATO_EMP_PUB%TYPE,
          USR_APROBACION             DB_COMERCIAL.INFO_CONTRATO.USR_APROBACION%TYPE,
          ESTADO_CONTRATO            DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE,
          DESCRIPCION_CUENTA         DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
          FE_APROBACION              VARCHAR2(100),
          FE_CREACION_PER            VARCHAR2(100),
          USR_CREACION               DB_COMERCIAL.INFO_PERSONA.USR_CREACION%TYPE,
          DIRECCION                  DB_COMERCIAL.INFO_PERSONA.DIRECCION%TYPE,
          ID_ROL                     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
          LOGIN                      DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
          FE_CREACION_PTO            VARCHAR2(100),
          ID_PUNTO                   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
          USR_VENDEDOR               DB_COMERCIAL.INFO_PUNTO.USR_VENDEDOR%TYPE,
          ID_SERVICIO                DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
          ESTADO_ROL                 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO.ESTADO%TYPE, 
          SERVICIO                   VARCHAR2(1000),  
          FE_PREPLANIFICACION        VARCHAR2(100),
          FE_ACTIVACION              VARCHAR2(100),
          ESTADO_IMPRESION_FACT      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
          NUMERO_FACTURA_SRI         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
          VALOR_TOTAL                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
          FE_EMISION                 VARCHAR2(100),
          TOTAL_PAGOS                DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
          OFICINA_VENDEDOR           DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
          OFICINA_PTO_COBERTURA      DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE
    );

  /*
  * Documentación para TYPE 'Lr_AliasPlantilla'.
  * Record que me permite devolver los valores para setear datos correspondientes a la plantilla de correo a utilizar.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 15-12-2016
  */

  TYPE Lr_AliasPlantilla IS RECORD(
    ALIAS_CORREOS VARCHAR2(4000),
    PLANTILLA     VARCHAR2(4000)
    );

  /**
   * Record necesario en los parámetros para la creación de solicitudes de instalación.
   * @author Luis Cabrera <lcabrera@telconet.ec>
   * @version 1.0
   * @since 23-11-2018
   * @author Katherine Yager <kyager@telconet.ec>
   * @version 1.1 14-09-2019 - Se agrega la columna 'PORCENTAJE', 'PERIODOS', 'APLICA_PROMO'
   */
  TYPE Lr_SolicitudInstalacion IS RECORD (
        ID_TIPO_SOLICITUD         DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ID_TIPO_SOLICITUD%TYPE,
        DESCRIPCION_SOLICITUD     DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
        PUNTO_ID                  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
        ID_SERVICIO               DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
        NOMBRE_PLAN               DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
        DESC_CARACT_CONTRATO      DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
        ID_CARACT_TIPO_CONTRATO   DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
        ID_CARACT_FE_VIGENCIA     DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
        OBSERVACION_SOLICITUD     DB_COMERCIAL.INFO_DETALLE_SOLICITUD.OBSERVACION%TYPE,
        MOTIVO_ID                 DB_COMERCIAL.INFO_DETALLE_SOLICITUD.MOTIVO_ID%TYPE,
        COD_EMPRESA               DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        FORMA_PAGO                VARCHAR2(100),
        FECHA_VIGENCIA_FACT       VARCHAR2(25),
        VALOR_INSTALACION         NUMBER,
        USR_CREACION              VARCHAR2(20),
        PORCENTAJE                DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.PORCENTAJE%TYPE,
        PERIODOS                  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.PERIODO%TYPE,
        APLICA_PROMO              VARCHAR2(100)
    );

  --
  --
  /*
  * Documentación para TYPE 'Lr_DetalladoServicios'.
  *
  * Record que permite el detallado de los servicios que serán exportados en un excel
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 05-07-2017
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 25-07-2017 - Se agrega las columnas 'SUBTOTAL_CON_DESCUENTO' y 'SUBTOTAL'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 01-09-2017 - Se agrega la columna 'MOTIVO_CANCELADO'
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 13-10-2017 - Se agrega la columna 'ACCION', 'MOTIVO_CANCELACION' y 'MOTIVO_PADRE_CANCELACION'
  */
  TYPE Lr_DetalladoServicios IS RECORD (
    NOMBRE_OFICINA                DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
    CATEGORIA                     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    GRUPO                         DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
    SUBGRUPO                      DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
    DESCRIPCION_PRODUCTO          DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    CLIENTE                       DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    LOGIN                         DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    USR_VENDEDOR                  DB_COMERCIAL.INFO_SERVICIO.USR_VENDEDOR%TYPE,
    ID_SERVICIO                   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    PRODUCTO_ID                   DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE,
    ESTADO                        DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    DESCRIPCION_PRESENTA_FACTURA  DB_COMERCIAL.INFO_SERVICIO.DESCRIPCION_PRESENTA_FACTURA%TYPE,
    FE_CREACION                   VARCHAR2(50),
    FE_HISTORIAL                  VARCHAR2(50),
    FRECUENCIA_PRODUCTO           DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
    ES_VENTA                      DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE,
    MRC                           NUMBER,
    PRECIO_VENTA                  DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
    CANTIDAD                      DB_COMERCIAL.INFO_SERVICIO.CANTIDAD%TYPE,
    DESCUENTO                     DB_COMERCIAL.INFO_SERVICIO.DESCUENTO_UNITARIO%TYPE,
    PRECIO_INSTALACION            DB_COMERCIAL.INFO_SERVICIO.PRECIO_INSTALACION%TYPE,
    SUBTOTAL_CON_DESCUENTO        NUMBER,
    SUBTOTAL                      NUMBER,
    VALOR_INSTALACION_MENSUAL     NUMBER,
    VALOR_TOTAL                   NUMBER,
    ACCION                        DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ACCION%TYPE,
    MOTIVO_CANCELACION            DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_CANCELACION%TYPE,
    MOTIVO_PADRE_CANCELACION      DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_PADRE_CANCELACION%TYPE
  );
  --
  --
  /*
  * Documentación para TYPE 'Lr_ServiciosCrm'.
  *
  * Record que permite el detallado de los servicios relacionados con propuestas de TelcoCRM 
  * que serán exportados en un excel
  *
  * @author Kevin Baque <kbaque@telconet.ec>
  * @version 1.0 21-09-2020
  */
TYPE Lr_ServiciosCrm IS RECORD (
    NOMBRE_OFICINA                DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
    CATEGORIA                     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
    GRUPO                         DB_COMERCIAL.ADMI_PRODUCTO.GRUPO%TYPE,
    SUBGRUPO                      DB_COMERCIAL.ADMI_PRODUCTO.SUBGRUPO%TYPE,
    DESCRIPCION_PRODUCTO          DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    CLIENTE                       DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    LOGIN                         DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    USR_VENDEDOR                  DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.USR_VENDEDOR%TYPE,
    ID_SERVICIO                   DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    PRODUCTO_ID                   DB_COMERCIAL.INFO_SERVICIO.PRODUCTO_ID%TYPE,
    ESTADO                        DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ESTADO%TYPE,
    DESCRIPCION_PRESENTA_FACTURA  DB_COMERCIAL.INFO_SERVICIO.DESCRIPCION_PRESENTA_FACTURA%TYPE,
    FE_CREACION                   VARCHAR2(50),
    DIAS_ACUMULADO_CREACION       VARCHAR2(4000),
    FE_ESTADO                     VARCHAR2(4000),
    DIAS_ACUMULADO_ESTADO         VARCHAR2(4000),
    USR_ESTADO                    VARCHAR2(4000),
    DEPARTAMENTO_ESTADO           VARCHAR2(4000),
    PROPUESTA                     VARCHAR2(4000),
    FRECUENCIA_PRODUCTO           DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
    ES_VENTA                      DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE,
    MRC                           NUMBER,
    PRECIO_VENTA                  DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
    CANTIDAD                      DB_COMERCIAL.INFO_SERVICIO.CANTIDAD%TYPE,
    DESCUENTO                     DB_COMERCIAL.INFO_SERVICIO.DESCUENTO_UNITARIO%TYPE,
    PRECIO_INSTALACION            DB_COMERCIAL.INFO_SERVICIO.PRECIO_INSTALACION%TYPE,
    SUBTOTAL_CON_DESCUENTO        NUMBER,
    SUBTOTAL                      NUMBER,
    VALOR_INSTALACION_MENSUAL     NUMBER,
    VALOR_TOTAL                   NUMBER,
    ACCION                        DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.ACCION%TYPE,
    MOTIVO_CANCELACION            DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_CANCELACION%TYPE,
    MOTIVO_PADRE_CANCELACION      DB_COMERCIAL.INFO_DASHBOARD_SERVICIO.MOTIVO_PADRE_CANCELACION%TYPE
  );
  --
  --

  /**
  * Documentación para TYPE 'T_ServiciosCrm'.
  * Record para almacenar la data enviada al BULK.
  *
  * @author Kevin Baque <kbaque@telconet.ec>
  * @version 1.0 21-09-2020
  */
  TYPE T_ServiciosCrm IS TABLE OF Lr_ServiciosCrm INDEX BY PLS_INTEGER;
  --
  --
  /*
  * Documentación para TYPE 'Lt_ArrayAsociativo'.
  *
  * Tipo de datos para mapear los parámetros enviados en un array asociativo
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 07-09-2017
  */
  TYPE Lt_ArrayAsociativo IS TABLE OF VARCHAR2(300) INDEX BY VARCHAR2(30);

  /*
  * Documentación para TYPE 'Lr_ServiciosPorRechazar'.
  *
  * Tipo de datos para el retorno de la información correspondiente a los servicios detenidos por más de 30 días
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 08-11-2018
  */
  TYPE Lr_ServiciosPorRechazar IS RECORD
  (
    ID_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_SERVICIO_TECNICO DB_COMERCIAL.INFO_SERVICIO_TECNICO.ID_SERVICIO_TECNICO%TYPE,
    INTERFACE_ELEMENTO_CONECTOR_ID DB_COMERCIAL.INFO_SERVICIO_TECNICO.INTERFACE_ELEMENTO_CONECTOR_ID%TYPE,
    EMPRESA_COD DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
    JURISDICCION DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
    CIUDAD DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
    CODIGO_TIPO_MEDIO DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.CODIGO_TIPO_MEDIO%TYPE,
    USR_VENDEDOR DB_COMERCIAL.INFO_SERVICIO.USR_VENDEDOR%TYPE,
    VENDEDOR VARCHAR2(200),
    CLIENTE VARCHAR2(200),
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    ID_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    NOMBRE_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    NOMBRE_TECNICO_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
    PRODUCTO_ES_CONCENTRADOR DB_COMERCIAL.ADMI_PRODUCTO.ES_CONCENTRADOR%TYPE,
    ID_DETALLE_SOLICITUD DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    FECHA_DETENIDO VARCHAR2(20),
    DIAS_DETENIDO FLOAT,
    DIAS_DETENIDO_REPORTE NUMBER 
  );

  /*
  * Documentación para TYPE 'Lt_ServiciosPorRechazar'.
  * Tabla para almacenar la data enviada con la información correspondiente a los servicios por rechazar
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 09-11-2018
  */
  TYPE Lt_ServiciosPorRechazar
  IS
    TABLE OF Lr_ServiciosPorRechazar INDEX BY PLS_INTEGER;


   /*
  * Documentación para TYPE 'Lr_PuntoResumen'.
  *
  * Tipo de datos para el retorno de la información resumida de un punto
  *
  * @author David De La Cruz <ddeleacruz@telconet.ec>
  * @version 1.0 27-01-2022
  */
  TYPE Lr_PuntoResumen IS RECORD
  (
    ID_PUNTO DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    ESTADO DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
    NOMBRE_PUNTO DB_COMERCIAL.INFO_PUNTO.NOMBRE_PUNTO%TYPE,
    DIRECCION DB_COMERCIAL.INFO_PUNTO.DIRECCION%TYPE,
    LONGITUD DB_COMERCIAL.INFO_PUNTO.LONGITUD%TYPE,
    LATITUD DB_COMERCIAL.INFO_PUNTO.LATITUD%TYPE,
    ID_SECTOR DB_GENERAL.ADMI_SECTOR.ID_SECTOR%TYPE,
    NOMBRE_SECTOR DB_GENERAL.ADMI_SECTOR.NOMBRE_SECTOR%TYPE,
    ID_PARROQUIA DB_GENERAL.ADMI_PARROQUIA.ID_PARROQUIA%TYPE,
    NOMBRE_PARROQUIA DB_GENERAL.ADMI_PARROQUIA.NOMBRE_PARROQUIA%TYPE,
    ID_CANTON DB_GENERAL.ADMI_CANTON.ID_CANTON%TYPE,
    NOMBRE_CANTON DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
    ID_PROVINCIA DB_GENERAL.ADMI_PROVINCIA.ID_PROVINCIA%TYPE,
    NOMBRE_PROVINCIA DB_GENERAL.ADMI_PROVINCIA.NOMBRE_PROVINCIA%TYPE
  );

  /*
   * Documentacion para TYPE 'Ltr_Punto'.
   * Record que me permite obtener los registros de puntos
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 03-01-2022
   *
   */
  TYPE Ltr_Punto IS TABLE OF Lr_PuntoResumen INDEX BY binary_integer;   

  /*
   * Documentacion para TYPE 'Ltr_Servicio'.
   * Record que me permite obtener los registros de servicios
   * @author David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0
   * @since 03-01-2022
   *
   */
  TYPE Ltr_Servicio IS TABLE OF DB_COMERCIAL.INFO_SERVICIO%ROWTYPE INDEX BY binary_integer;  

  --
  --
  /*
  * Documentación para TYPE 'Lr_ServiciosPersona'.
  *
  * Record que permite el detallado de los servicios relacionados al Cliente/PreCliente 
  * que serán exportados en un excel
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.0 02-12-2022
  */
TYPE Lr_ServiciosPersona IS RECORD (
    ID_PERSONA                         DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    TIPO_IDENTIFICACION                DB_COMERCIAL.INFO_PERSONA.TIPO_IDENTIFICACION%TYPE,
    NUMERO_IDENTIFICACION              DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    NOMBRES                            DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    APELLIDOS                          DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    RAZON_SOCIAL                       DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    NOMBRE_COMPLETO                    VARCHAR2(200), 
    NACIONALIDAD                       VARCHAR2(50),
    DIRECCION                          DB_COMERCIAL.INFO_PERSONA.DIRECCION%TYPE,
    GENERO                             DB_COMERCIAL.INFO_PERSONA.GENERO%TYPE,
    DISCAPACIDAD                       VARCHAR2(10),
    REPRESENTANTE_LEGAL                DB_COMERCIAL.INFO_PERSONA.REPRESENTANTE_LEGAL%TYPE,
    ORIGEN_INGRESOS                    VARCHAR2(200),
    ID_PUNTO                           DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    COORDENADA_LATITUD_PUNTO           DB_COMERCIAL.INFO_PUNTO.LATITUD%TYPE,
    COORDENADA_LONGITUD_PUNTO          DB_COMERCIAL.INFO_PUNTO.LONGITUD%TYPE,
    PROVINCIA_PUNTO                    DB_GENERAL.ADMI_PROVINCIA.NOMBRE_PROVINCIA%TYPE,
    CIUDAD_PUNTO                       DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
    CANTON_PUNTO                       DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
    PARROQUIA_PUNTO                    DB_GENERAL.ADMI_PARROQUIA.NOMBRE_PARROQUIA%TYPE,
    SECTOR_PUNTO                       DB_GENERAL.ADMI_SECTOR.NOMBRE_SECTOR%TYPE,
    TIPO_UBICACION_PUNTO               DB_COMERCIAL.ADMI_TIPO_UBICACION.DESCRIPCION_TIPO_UBICACION%TYPE,
    NOMBRE_PLAN                        VARCHAR2(500),
    ESTADO_PUNTO                       DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
    DESCRIPCION_FORMA_PAGO             DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
    SERVICIO                           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_CONTRATO                        DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.CONTRATO_ID%TYPE
  );
  --
  --

  /**
  * Documentación para TYPE 'T_ServiciosPersona'.
  * Record para almacenar la data enviada al BULK.
  *
  * @author Jessenia Piloso <jpiloso@telconet.ec>
  * @version 1.0 02-12-2022
  */
  TYPE T_ServiciosPersona IS TABLE OF Lr_ServiciosPersona INDEX BY PLS_INTEGER;
END CMKG_TYPES;
/

