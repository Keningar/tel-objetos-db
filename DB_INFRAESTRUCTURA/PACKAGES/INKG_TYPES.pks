CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_TYPES 
AS

  /*
  * Documentaci�n para TYPE 'Lr_InfoCorreoCliente'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los correos del cliente
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lr_InfoCorreoCliente IS RECORD
  (
    CONTACTO VARCHAR2(4000),
    TIENESEPARADOR PLS_INTEGER
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoCorreoCliente'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los correos del cliente
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lt_InfoCorreoCliente
  IS
    TABLE OF Lr_InfoCorreoCliente INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_PuntoInternetXOlt'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los puntos asociados a un plan de Internet por olt
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lr_PuntoInternetXOlt IS RECORD
  (
    ID_ELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_ELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    ID_PUNTO DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    USR_VENDEDOR_PTO DB_COMERCIAL.INFO_PUNTO.USR_VENDEDOR%TYPE,
    ID_PERSONA_ROL DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    IDENTIFICACION_CLIENTE DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    NOMBRES DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
    APELLIDOS DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
    RAZON_SOCIAL DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
    CLIENTE VARCHAR2(201),
    NOMBRE_JURISDICCION DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
    ID_SERVICIO_INTERNET DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    TIPO_SERVICIO_INTERNET DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE,
    ESTADO_SERVICIO_INTERNET DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    USR_VENDEDOR_SERVICIO_INTERNET DB_COMERCIAL.INFO_SERVICIO.USR_VENDEDOR%TYPE,
    ID_PTO_FACT_SERVICIO_INTERNET DB_COMERCIAL.INFO_SERVICIO.PUNTO_FACTURACION_ID%TYPE,
    ID_UM_SERVICIO_INTERNET DB_COMERCIAL.INFO_SERVICIO_TECNICO.ULTIMA_MILLA_ID%TYPE,
    ID_PLAN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    NOMBRE_PLAN DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
    ID_ITEM_INTERNET DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE,
    ID_PROD_INTERNET DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    DESCRIPCION_PROD_INTERNET DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    ID_ITEM_I_PROTEGIDO DB_COMERCIAL.INFO_PLAN_DET.ID_ITEM%TYPE,
    ESTADO_PLAN_DET_I_PROTEGIDO DB_COMERCIAL.INFO_PLAN_DET.ESTADO%TYPE,
    ID_PROD_I_PROTEGIDO DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    DESCRIPCION_PROD_I_PROTEGIDO DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    VALOR_SPC_SUSCRIBER_ID DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    VALOR_SPC_ANTIVIRUS DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    CANTIDAD_SERVICIOS_ADICIONALES NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_PuntosInternetXOlt'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los puntos asociados a un plan de Internet por olt
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lt_PuntosInternetXOlt
  IS
    TABLE OF Lr_PuntoInternetXOlt INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_ServIProtegidoAdicsXPto'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los servicios adicionales de Internet Protegido asociados a un punto
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lr_ServIProtegidoAdicsXPto IS RECORD
  (
    ID_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_PUNTO DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    ID_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    DESCRIPCION_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    PRECIO_VENTA_SERVICIO DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
    ESTADO_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    CANT_DISPOSITIVOS NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_ServIProtegidoAdicsXPto'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los servicios adicionales de Internet Protegido asociados a un punto
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lt_ServIProtegidoAdicsXPto
  IS
    TABLE OF Lr_ServIProtegidoAdicsXPto INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_InfoServIProtegidoKaspersky'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los nuevos servicios adicionales de Internet Protegido kaspersky
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lr_InfoServIProtegidoKaspersky IS RECORD
  (
    ID_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    DESCRIPCION_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    PRECIO_VENTA_SERVICIO DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
    CANT_DISPOSITIVOS NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoServIProtegidoKaspersky'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los nuevos servicios adicionales de Internet Protegido kaspersky
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lt_InfoServIProtegidoKaspersky
  IS
    TABLE OF Lr_InfoServIProtegidoKaspersky INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_ServicioIProtegidoXActivar'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los servicios de Internet Protegido que ser�n migrados a Kaspersky
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lr_ServicioIProtegidoXActivar IS RECORD
  (
    ID_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    DESCRIPCION_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    ID_ORDEN_TRABAJO DB_COMERCIAL.INFO_ORDEN_TRABAJO.ID_ORDEN_TRABAJO%TYPE,
    CANT_DISPOSITIVOS NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_ServiciosIProtegidoXActivar'.
  * Tabla para almacenar los servicios de Internet Protegido que ser�n migrados a Kaspersky
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lt_ServiciosIProtegidoXActivar
  IS
    TABLE OF Lr_ServicioIProtegidoXActivar INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lt_ArrayOfVarchar'.
  * Tabla para almacenar la data en un array
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lt_ArrayOfVarchar IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_InfoServicioWsGms'.
  *
  * Tipo de datos para la informaci�n necesaria para el env�o al web service de Gms
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lr_InfoServicioWsGms IS RECORD
  (
    Identificacion VARCHAR2(20),
    Email VARCHAR2(100),
    Nombres VARCHAR2(200),
    Apellidos VARCHAR2(200),
    Cantidad NUMBER,
    SuscriberId NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lr_RegistroOltCpm'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los olts que ejecutar�n el cambio de plan masivo
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-12-2019
  */
  TYPE Lr_OltCpm IS RECORD
  (
    ID_ELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_ELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    ESTADO DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO%TYPE,
    NUM_LOGINES NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_OltsCpm'.
  * Tabla para almacenar los olts que ejecutar�n el cambio de plan masivo
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-12-2019
  */
  TYPE Lt_OltsCpm
  IS
    TABLE OF Lr_OltCpm INDEX BY PLS_INTEGER;

 /*
  * Documentaci�n para TYPE 'Lt_ArrayKeyValue'.
  *
  * Tipo de datos para mapear los par�metros enviados en un array asociativo
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 05-12-2019
  */
  TYPE Lt_ArrayKeyValue IS TABLE OF VARCHAR2(500) INDEX BY VARCHAR2(500);

  /*
  * Documentaci�n para TYPE 'Lr_DataPorProcesarCpm'.
  *
  * Tipo de datos para el registro del archivo csv subido en el cambio de plan masivo mapeado con la informaci�n en la base de datos
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lr_DataPorProcesarCpm IS RECORD
  (
    ID_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    PRECIO_VENTA DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
    FRECUENCIA_PRODUCTO DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
    ID_PLAN_NUEVO DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ID_PLAN_VIEJO DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    ID_OLT DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_OLT DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    VALOR_EQUIPO VARCHAR2(500)
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataPorProcesarCpm'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al archivo csv subido en el cambio de plan masivo
  * mapeada con la informaci�n en la base de datos
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-10-2019
  */
  TYPE Lt_DataPorProcesarCpm
  IS
    TABLE OF Lr_DataPorProcesarCpm INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_DataClientesVerificaEquipos'.
  *
  * Tipo de datos de los clientes a los cuales se les verificar� los detalles del plan vs los equipos
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 11-06-2020
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 14-07-2020 Se modifica el tipo de datos para obtener informaci�n adicional del servicio
  */
  TYPE Lr_DataClientesVerificaEquipos IS RECORD
  (
    ID_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    TIPO_ORDEN DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE,
    ESTADO_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    ID_PUNTO DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    CLIENTE VARCHAR2(201),
    NOMBRE_JURISDICCION VARCHAR2(40),
    ID_PLAN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    NOMBRE_PLAN DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
    ID_OLT DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_OLT DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    NOMBRE_MARCA_OLT DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE,
    NOMBRE_MODELO_OLT DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    ID_ONT DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_ONT DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    NOMBRE_MODELO_ONT DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    ID_INTERFACE_ONT DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataClientesVerificaEquipos'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los clientes que pasar�n por el proceso de verificaci�n de equipos
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 11-06-2020
  */
  TYPE Lt_DataClientesVerificaEquipos
  IS
    TABLE OF Lr_DataClientesVerificaEquipos INDEX BY PLS_INTEGER;


  /*
  * Documentaci�n para TYPE 'Lt_SolValidaGestionEquipos'.
  * Tipo de datos de la solicitud v�lida para gestionar equipos Wifi Dual Band y Extender Dual Band
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 12-06-2020
  */
  TYPE Lr_SolValidaGestionEquipos IS RECORD
  (
    ID_DETALLE_SOLICITUD DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    DESCRIPCION_SOLICITUD DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
    ESTADO_SOLICITUD DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
    USR_CREACION DB_COMERCIAL.INFO_DETALLE_SOLICITUD.USR_CREACION%TYPE,
    FE_CREACION DB_COMERCIAL.INFO_DETALLE_SOLICITUD.FE_CREACION%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lr_DataGeneralCliente'.
  *
  * Tipo de datos de los clientes que se usar� para el env�o de correo
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 27-07-2020
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.1 24-09-2020 Se agregan campos necesarios para flujo de W+AP al realizar un cambio de plan que necesite agregar el extender del
  *                         servicio W+AP
  *
  */
  TYPE Lr_DataGeneralCliente IS RECORD
  (
    ID_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    TIPO_ORDEN DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE,
    ESTADO_SERVICIO DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    ID_PUNTO DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    CLIENTE VARCHAR2(201),
    NOMBRE_JURISDICCION VARCHAR2(40),
    TIPO_SERVICIO VARCHAR2(100),
    ID_PLAN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    NOMBRE_PLAN DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
    ID_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    DESCRIPCION_PRODUCTO DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lr_PuntosCorteMasivo'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los puntos consultados desde el corte masivo
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 12-08-2020
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 01-10-2021 Se modifica el tipo de dato ya que al cambiarse la longitud de una de las tablas, podr�a verse afectado este record
  *
  * @author Javier Hidalgo <jihidalgo@telconet.ec>
  * @version 1.1 11-10-2022 Se agregan variables FECHA_ACTIVACION, IDENTIFICACION_CLIENTE, ES_EXCLUIDO
  */
  TYPE Lr_PuntosCorteMasivo
  IS
    RECORD
    (
      ID_PUNTO               NUMBER(38),
      LOGIN                  VARCHAR2(60),
      NOMBRE_CLIENTE         VARCHAR2(250),
      NOMBRE_OFICINA         VARCHAR2(100),
      SALDO                  NUMBER,
      DESCRIPCION_FORMA_PAGO DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
      DESCRIPCION_BANCO      DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,
      DESCRIPCION_CUENTA     DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
      NOMBRE_TIPO_NEGOCIO    VARCHAR2(60),
      ULTIMA_MILLA           VARCHAR2(20),
      FECHA_ACTIVACION       VARCHAR2(100),
      IDENTIFICACION_CLIENTE VARCHAR2(100),
      ES_EXCLUIDO            VARCHAR2(5));

  /*
  * Documentaci�n para TYPE 'Lt_PuntosCorteMasivo'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los puntos que se desea cortar
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 12-08-2018
  */
  TYPE Lt_PuntosCorteMasivo
  IS
    TABLE OF Lr_PuntosCorteMasivo INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_InfoCreacionServicioDb'.
  *
  * Tipo de datos para la informaci�n adicional de creaci�n de un servicio Dual Band
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 28-09-2020
  */
  TYPE Lr_InfoCreacionServicioDb
  IS
    RECORD
    (
      ID_SERVICIO_INTERNET      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      NOMBRE_TECNICO_PROD       DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
      SERVICIO_ES_GRATIS        VARCHAR2(60),
      ESTADO_SERVICIO           VARCHAR2(250),
      OBSERVACION_HISTORIAL     CLOB,
      ACCION_HISTORIAL          VARCHAR2(30),
      OBSERVACION_EJECUTANTE    VARCHAR2(500));

  /*
  * Documentaci�n para TYPE 'Lr_InfoServicioInternet'.
  *
  * Tipo de datos para la informaci�n de un servicio de Internet
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 15-01-2021
  */
  TYPE Lr_InfoServicioInternet
  IS
    RECORD
    (
      ID_SERVICIO               DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
      USR_VENDEDOR_SERVICIO     DB_COMERCIAL.INFO_SERVICIO.USR_VENDEDOR%TYPE,
      PUNTO_FACTURACION_ID      DB_COMERCIAL.INFO_SERVICIO.PUNTO_FACTURACION_ID%TYPE,
      ID_PUNTO                  DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
      LOGIN                     DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      USR_VENDEDOR_PTO          DB_COMERCIAL.INFO_PUNTO.USR_VENDEDOR%TYPE,
      PREFIJO_EMPRESA_VENDEDOR  VARCHAR2(100),
      ESTADO                    DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      ID_PERSONA_ROL            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      ID_PERSONA                DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
      NOMBRE_CLIENTE            VARCHAR2(250)
    );

  /*
  * Documentaci�n para TYPE 'Lr_InfoServicioProdAdicional'.
  *
  * Tipo de datos para la informaci�n del un servicio adicional
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 18-01-2021
  */
  TYPE Lr_InfoServicioProdAdicional
  IS
    RECORD
    (
      ID_PRODUCTO               DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
      NOMBRE_TECNICO_PRODUCTO   DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE,
      DESCRIPCION_PRODUCTO      DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
      PRECIO_VENTA_SERVICIO     DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
      ESTADO_SERVICIO           DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      OBSERVACION_HISTORIAL     DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE,
      ACCION_HISTORIAL          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE,
      ES_VENTA_SERVICIO         DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE,
      CANTIDAD_SERVICIO         DB_COMERCIAL.INFO_SERVICIO.CANTIDAD%TYPE,
      FRECUENCIA_SERVICIO       DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
      MESES_RESTANTES_SERVICIO  DB_COMERCIAL.INFO_SERVICIO.MESES_RESTANTES%TYPE
    );

  /*
  * Documentaci�n para TYPE 'Lr_DataPorProcesarPsm'.
  *
  * Tipo de datos para el registro del archivo csv subido para la genraci�n de scopes y policy
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 03-03-2021
  */
  TYPE Lr_DataPorProcesarPsm IS RECORD
  (
    NOMBRE_POLICY DB_INFRAESTRUCTURA.ADMI_POLICY.NOMBRE_POLICY%TYPE,
    IP DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE,
    LEASE_TIME DB_INFRAESTRUCTURA.ADMI_POLICY.LEASE_TIME%TYPE,
    DNS_NAME DB_INFRAESTRUCTURA.ADMI_POLICY.DNS_NAME%TYPE,
    DNS_SERVERS DB_INFRAESTRUCTURA.ADMI_POLICY.DNS_SERVERS%TYPE,
    GATEWAY DB_INFRAESTRUCTURA.ADMI_POLICY.GATEWAY%TYPE,
    MASCARA DB_INFRAESTRUCTURA.ADMI_POLICY.MASCARA%TYPE,
    DETALLE_VALOR DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO.DETALLE_VALOR%TYPE,
    SUBRED DB_INFRAESTRUCTURA.INFO_SUBRED.SUBRED%TYPE,
    TAGS VARCHAR2(4000),
    IP_INICIAL DB_INFRAESTRUCTURA.INFO_SUBRED.IP_INICIAL%TYPE,
    IP_FINAL DB_INFRAESTRUCTURA.INFO_SUBRED.IP_FINAL%TYPE,
    SUBRED_0 VARCHAR2(200),
    ELEMENTO_ID DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    ESTADO_ELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataPorProcesarPsm'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al archivo csv subido
  * mapeada con la informaci�n en la base de datos
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 03-03-2021
  */
  TYPE Lt_DataPorProcesarPsm
  IS
    TABLE OF Lr_DataPorProcesarPsm INDEX BY PLS_INTEGER; 

  /*
  * Documentaci�n para TYPE 'Lr_DataPorProcesarRutas'.
  *
  * Tipo de datos para el registro del archivo csv subido para la generaci�n de rutas
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 01-06-2021
  */
  TYPE Lr_DataPorProcesarRutas IS RECORD
  (
    NOMBRE_ELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    DESCRIPCION_ELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.DESCRIPCION_ELEMENTO%TYPE,
    NOMBRE_TIPO_ELEMENTO DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE,
    NOMBRE_MODELO_ELEMENTO DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    OBSERVACION VARCHAR2(4000),
    ELEMENTO_INICIO DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    ELEMENTO_FIN DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    NOMBRE_CLASE_TIPO_MEDIO DB_INFRAESTRUCTURA.ADMI_CLASE_TIPO_MEDIO.NOMBRE_CLASE_TIPO_MEDIO%TYPE,
    ELEMENTOS_CONTENIDO CLOB,
    ELEMENTO_ID DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    ESTADO_ELEMENTO DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO%TYPE,
    VALOR2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
    VALOR3 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
    VALOR4 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
    ELEMENTOS_DETALLE CLOB
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataPorProcesarRutas'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al archivo csv subido
  * mapeada con la informaci�n en la base de datos
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 01-06-2021
  */
  TYPE Lt_DataPorProcesarRutas
  IS
    TABLE OF Lr_DataPorProcesarRutas INDEX BY PLS_INTEGER; 

  /*
  * Documentaci�n para TYPE 'Lr_InfoClienteInternetWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente al cliente y su respectivo servicio de Internet asociado
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoClienteInternetWs IS RECORD
  (
    ID_PERSONA_ROL                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    ESTADO_PERSONA_ROL              DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE,
    OFICINA_ID                      DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
    ID_PERSONA                      DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
    IDENTIFICACION_CLIENTE          DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    CLIENTE                         VARCHAR2(201),
    ID_PUNTO                        DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    ID_SERVICIO_INTERNET            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_PRODUCTO_INTERNET            DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    ID_SERVICIO_TECNICO_INTERNET    DB_COMERCIAL.INFO_SERVICIO_TECNICO.ID_SERVICIO_TECNICO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoClienteInternetWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al cliente y al punto de Internet
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoClienteInternetWs
  IS
    TABLE OF Lr_InfoClienteInternetWs INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoClientePuntoWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente al punto que tiene un servicio de Internet 
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoClientePuntoWs IS RECORD
  (
    ID_PUNTO            DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    LOGIN               DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    ESTADO_PUNTO        DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
    DIRECCION           DB_COMERCIAL.INFO_PUNTO.DIRECCION%TYPE,
    LONGITUD            DB_COMERCIAL.INFO_PUNTO.LONGITUD%TYPE,
    LATITUD             DB_COMERCIAL.INFO_PUNTO.LATITUD%TYPE,
    NOMBRE_JURISDICCION DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
    NOMBRE_SECTOR       DB_COMERCIAL.ADMI_SECTOR.NOMBRE_SECTOR%TYPE,
    NOMBRE_CANTON       DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
    TELEFONOS           VARCHAR2(4000),
    CORREOS             VARCHAR2(4000),
    SALDO               NUMBER,
    NOMBRE_TIPO_NEGOCIO DB_COMERCIAL.ADMI_TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoClientePuntoWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al punto que tiene un servicio de Internet
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoClientePuntoWs
  IS
    TABLE OF Lr_InfoClientePuntoWs INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoClienteServicioWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los servicios 
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoClienteServicioWs IS RECORD
  (
    ID_SERVICIO                     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ID_PROD_PLAN_PRODUCTO           DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    CODIGO_PROD_PLAN_PRODUCTO       DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE,
    CODIGO_PLAN                     DB_COMERCIAL.INFO_PLAN_CAB.CODIGO_PLAN%TYPE,
    DESCRIPCION_PROD_PLAN_PRODUCTO  DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    NOMBRE_TIPO_MEDIO               DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO.NOMBRE_TIPO_MEDIO%TYPE,
    ID_PLAN                         DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
    NOMBRE_PLAN                     DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
    ESTADO_SERVICIO                 DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    LOGIN_AUX                       DB_COMERCIAL.INFO_SERVICIO.LOGIN_AUX%TYPE,
    PRECIO                          NUMBER
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoClienteServicioWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los servicios
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoClienteServicioWs
  IS
    TABLE OF Lr_InfoClienteServicioWs INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoDataTecnicaWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a la data t�cnica del servicio de Internet
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoDataTecnicaWs IS RECORD
  (
    ID_SERVICIO                 DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ELEMENTO                    DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    IP_ELEMENTO                 DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE,
    MODELO_ELEMENTO             DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    MARCA_ELEMENTO              DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE,
    INTERFACE_ELEMENTO          DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
    ELEMENTO_CONTENEDOR         DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    ELEMENTO_CONECTOR           DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    INTERFACE_ELEMENTO_CONECTOR DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
    INDICE_CLIENTE              DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    LINE_PROFILE                DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    PERFIL                      DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    SERVICE_PORT                DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    GEMPORT                     DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    TRAFFIC_TABLE               DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    LINE_PROFILE_PROMO          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    GEMPORT_PROMO               DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    TRAFFIC_TABLE_PROMO         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    PERFIL_PROMO                DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    VLAN                        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    IPV4                        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    SERIE_ONT                   DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE,
    MAC_ONT                     DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    MODELO_ONT                  DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
    MARCA_ONT                   DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE,
    APROVISIONAMIENTO           DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO.DETALLE_VALOR%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoDataTecnicaWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a la data t�cnica del servicio de Internet
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoDataTecnicaWs
  IS
    TABLE OF Lr_InfoDataTecnicaWs INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoDataTecnicaWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a la factura
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoFacturaPuntoWs IS RECORD
  (
    ID_DOCUMENTO                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    NUMERO_FACTURA_SRI          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    VALOR_TOTAL                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    ESTADO_IMPRESION_FACT       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    FE_EMISION                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoFacturaPuntoWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a la factura
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoFacturaPuntoWs
  IS
    TABLE OF Lr_InfoFacturaPuntoWs INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoPagoPuntoWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente al pago
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoPagoPuntoWs IS RECORD
  (
    NUMERO_PAGO     DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
    VALOR_TOTAL     DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
    ESTADO_PAGO     DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
    FE_CREACION     DB_FINANCIERO.INFO_PAGO_CAB.FE_CREACION%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoPagoPuntoWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al pago
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoPagoPuntoWs
  IS
    TABLE OF Lr_InfoPagoPuntoWs INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoCasoPuntoWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a casos
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoCasoPuntoWs IS RECORD
  (
    ID_CASO     DB_SOPORTE.INFO_CASO.ID_CASO%TYPE,
    NUMERO_CASO DB_SOPORTE.INFO_CASO.NUMERO_CASO%TYPE,
    CASO        DB_SOPORTE.INFO_CASO.TITULO_INI%TYPE,
    ESTADO      VARCHAR2(15),
    FE_CREACION VARCHAR2(16),
    FE_CIERRE   VARCHAR2(16)
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoCasoPuntoWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a casos
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoCasoPuntoWs
  IS
    TABLE OF Lr_InfoCasoPuntoWs INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoTareaPuntoWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a tareas
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoTareaPuntoWs IS RECORD
  (
    NUMERO_TAREA    DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE,
    TAREA           DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE,
    FE_CREACION     VARCHAR2(16),
    FE_FINALIZACION VARCHAR2(16),
    ESTADO          DB_SOPORTE.INFO_DETALLE_HISTORIAL.ESTADO%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoTareaPuntoWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a tareas
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoTareaPuntoWs
  IS
    TABLE OF Lr_InfoTareaPuntoWs INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoIpPuntoWs'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a ips
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lr_InfoIpPuntoWs IS RECORD
  (
    IP          DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE,
    MAC         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    MASCARA     DB_INFRAESTRUCTURA.INFO_IP.MASCARA%TYPE,
    SCOPE_IP    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    POOL_IP     DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoIpPuntoWs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a ips
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 04-06-2021
  */
  TYPE Lt_InfoIpPuntoWs
  IS
    TABLE OF Lr_InfoIpPuntoWs INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_InfoClienteInternetWsAcs'.
  *
  * Tipo de datos para el retorno de la informaci�n de cliente, servicio de Internet y dem�s data solicitada
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 22-08-2021
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.1 24-10-2021   Se agregan nuevos campos solicitados en fase 2 del proyecto WS ACS
  */
  TYPE Lr_InfoClienteInternetWsAcs IS RECORD
  (
    ID_PERSONA_ROL                  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    IDENTIFICACION_CLIENTE          DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    CLIENTE                         VARCHAR2(201),
    ID_SERVICIO_INTERNET            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    MAC_ONT                         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    ONT_ID                          DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    IP_OLT                          DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE,
    TELEFONOS                       VARCHAR2(4000),
    CORREOS                         VARCHAR2(4000),
    NOMBRE_JURISDICCION             DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
    NOMBRE_MARCA_ELEMENTO           DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE,
    ESTADO_SERVICIO_INTERNET        DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    SERIE_ONT                       DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE,
    NOMBRE_OLT                      DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    INTERFACE_ELEMENTO              DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
    NOMBRE_CANTON                   DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE,
    LOGIN                           DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    LINE_PROFILE                    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE,
    DIRECCION                       DB_COMERCIAL.INFO_PUNTO.DIRECCION%TYPE,
    LONGITUD                        DB_COMERCIAL.INFO_PUNTO.LONGITUD%TYPE,
    LATITUD                         DB_COMERCIAL.INFO_PUNTO.LATITUD%TYPE,
    NOMBRE_TIPO_NEGOCIO             DB_COMERCIAL.ADMI_TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO%TYPE,
    NOMBRE_PLAN                     DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE,
    NOMBRE_PRODUCTO                 DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
    LOGIN_AUX_SERVICIO_INTERNET     DB_COMERCIAL.INFO_SERVICIO.LOGIN_AUX%TYPE,
    VLAN                            DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE
  );

/*
  * Documentaci�n para TYPE 'Lt_InfoClienteInternetWsAcs'.
  *
  * Tabla para almacenar la data enviada con la informaci�n de cliente, punto de Internet y dem�s campos solicitados
  *
  * @author Jes�s Bozada <jbozada@telconet.ec>
  * @version 1.0 21-08-2021
  */
  TYPE Lt_InfoClienteInternetWsAcs
  IS
    TABLE OF Lr_InfoClienteInternetWsAcs INDEX BY PLS_INTEGER;

 /*
  * Documentaci�n para TYPE 'Lr_RptSecureCpe'.
  * Record que me permite devolver los valores para setear columnas de reportes de secure cpe
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 03-09-2021
  */
  TYPE Lr_RptSecureCpe IS RECORD (
          ID_QUERY                   NUMBER,
          LOGIN                      DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,    
          RAZON_SOCIAL               VARCHAR2(500), 
          DESCRIPCION_PRODUCTO       VARCHAR2(500), 
          SERIE                      VARCHAR2(100),
          FE_CREACION                VARCHAR2(100),
          FECHA                      VARCHAR2(100),
          CPE                        VARCHAR2(100),
          PLAN                       VARCHAR2(100)
  );

 /*
  * Documentaci�n para TYPE 'Lt_PuntosCorteMasivo'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los puntos que se desea cortar
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 13-09-2021
  */
  TYPE Lt_RptSecureCpe
  IS
    TABLE OF Lr_RptSecureCpe INDEX BY PLS_INTEGER;  

  /*
  * Documentaci�n para TYPE 'Lr_InfoCortePmEjecutado'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a un proceso de corte ejecutado
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 29-09-2021
  */
  TYPE Lr_InfoCortePmEjecutado IS RECORD
  (
    ID_DETALLE_SOLICITUD            DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    ESTADO_SOL_CORTE                DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
    ESTADO_NUEVO_SOL_CORTE          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
    ID_SOLICITUD_CARACTERISTICA     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE,
    ESTADO_SOL_CARACT_PM_CAB_CORTE  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE,
    ESTADO_NUEVO_SOL_CARACT         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
    ID_PROCESO_MASIVO_CAB           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
    ESTADO_PM_CAB                   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
    ESTADO_NUEVO_PM_CAB             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoCortePmEjecutado'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a un proceso de corte ejecutado
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 29-09-2021
  */
  TYPE Lt_InfoCortePmEjecutado
  IS
    TABLE OF Lr_InfoCortePmEjecutado INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_InfoProcesosCorteDarDeBaja'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a los procesos de corte masivo por lotes que hay que dar de baja
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 29-09-2021
  */
  TYPE Lr_InfoProcesosCorteDarDeBaja IS RECORD
  (
    ID_DETALLE_SOLICITUD            DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    ESTADO_SOL_CORTE                DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
    ESTADO_NUEVO_SOL_CORTE          DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
    ID_SOLICITUD_CARACTERISTICA     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE,
    ESTADO_SOL_CARACT_PM_CAB_CORTE  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE,
    ESTADO_NUEVO_SOL_CARACT         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
    ID_PROCESO_MASIVO_CAB           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
    ESTADO_PM_CAB                   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
    ESTADO_NUEVO_PM_CAB             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
    ID_PROCESO_MASIVO_DET           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE,
    ESTADO_PM_DET                   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE,
    ESTADO_NUEVO_PM_DET             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_InfoProcesosCorteDarDeBaja'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los procesos de corte masivo por lotes que hay que dar de baja
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 29-09-2021
  */
  TYPE Lt_InfoProcesosCorteDarDeBaja
  IS
    TABLE OF Lr_InfoProcesosCorteDarDeBaja INDEX BY PLS_INTEGER;


  /*
  * Documentaci�n para TYPE 'Lr_ReporteCorteMasivoXLotes'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente al corte masivo por lotes que formar� parte del reporte en formato CSV
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 29-09-2021
  */
  TYPE Lr_ReporteCorteMasivoXLotes IS RECORD
  (
    ID_DETALLE_SOLICITUD            DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    ID_SOL_CARACT_ENVIO_REPORTE     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ID_SOLICITUD_CARACTERISTICA%TYPE,
    NUM_PROCESO                     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
    ID_PROCESO_MASIVO_DET           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE,
    LOGIN                           DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
    JURISDICCION                    DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
    VALOR_DEUDA                     NUMBER,
    FORMA_PAGO                      DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
    BANCO_TARJETA                   DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,
    TIPO_CUENTA_TIPO_TARJETA        DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
    ESTADO_CORTE                    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE,
    MOTIVO                          DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.OBSERVACION%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_ReporteCorteMasivoXLotes'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al corte masivo por lotes que formar� parte del reporte en formato CSV
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 29-09-2021
  */
  TYPE Lt_ReporteCorteMasivoXLotes
  IS
    TABLE OF Lr_ReporteCorteMasivoXLotes INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_ReporteCorteMasivoXLotes'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente al proceso masivo a dar de baja
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 07-12-2021
  */
  TYPE Lr_PmCabDetDarBaja IS RECORD
  (
    ID_PROCESO_MASIVO_CAB       DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,        
    TIPO_PROCESO                DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
    ESTADO_NUEVO_PM_CAB         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
    ID_PROCESO_MASIVO_DET       DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE,
    ESTADO_ACTUAL_PM_DET        DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE, 
    ESTADO_NUEVO_PM_DET         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE, 
    OBSERVACION_ACTUAL_PM_DET   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.OBSERVACION%TYPE, 
    OBSERVACION_NUEVA_PM_DET    DB_GENERAL.ADMI_PARAMETRO_DET.OBSERVACION%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_PmCabDetDarBaja'.
  *
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al proceso masivo a dar de baja
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 07-12-2021
  */
  TYPE Lt_PmCabDetDarBaja
  IS
    TABLE OF Lr_PmCabDetDarBaja INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_DataLoginesPorProcesar'.
  *
  * Tipo de datos para el registro de logines subidos en un archivo csv mapeado con la informaci�n en la base de datos
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 17-01-2022
  */
  TYPE Lr_DataLoginesPorProcesar IS RECORD
  (
    LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE
  );

  /*
  * Documentaci�n para TYPE 'Lt_DataPorProcesarCpm'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente a los logines subidos en un archivo csv
  * mapeada con la informaci�n en la base de datos
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 17-01-2022
  */
  TYPE Lt_DataLoginesPorProcesar
  IS
    TABLE OF Lr_DataLoginesPorProcesar INDEX BY PLS_INTEGER;

  /*
  * Documentaci�n para TYPE 'Lr_DataPorProcesarHilos'.
  *
  * Tipo de datos para el registro del archivo csv subido para la generaci�n de hilo
  *
  * @author Anthony Santillan <asantillany@telconet.ec>
  * @version 1.0 01-06-2021
  */
  TYPE Lr_DataPorProcesarHilos IS RECORD
  (
    HILO_ID_CAB DB_INFRAESTRUCTURA.TEMP_HILO_CAB.ID_HILO_CAB%TYPE,  
    ELEMENTO_INTERMEDIO DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE, 
    CASSETTE DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    LOGIN DB_INFRAESTRUCTURA.INFO_PUNTO.LOGIN%TYPE,
    PUERTO_INICIO DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE, 
    PUERTO_FIN DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE, 
    PUERTO_INI_ODF DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE, 
    PUERTO_FIN_ODF DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE, 
    NOMBRE_ODF DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE, 
    PUERTO_EQUIPO DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
    EQUIPO DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,  
    HILO_FIN DB_INFRAESTRUCTURA.ADMI_HILO.NUMERO_HILO%TYPE, 
    COLOR_BUFFER_FIN DB_INFRAESTRUCTURA.ADMI_BUFFER.COLOR_BUFFER%TYPE, 
    COLOR_HILO_FIN DB_INFRAESTRUCTURA.ADMI_HILO.COLOR_HILO%TYPE,  
    NOMBRE_RUTA DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,  
    TIPO_RUTA DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO.NOMBRE_TIPO_ELEMENTO%TYPE, 
    TIPO_FIBRA DB_INFRAESTRUCTURA.ADMI_CLASE_TIPO_MEDIO.NOMBRE_CLASE_TIPO_MEDIO%TYPE
  );
  /*
  * Documentaci�n para TYPE 'Lt_DataPorProcesarHilos'.
  * Tabla para almacenar la data enviada con la informaci�n correspondiente al archivo csv subido
  * mapeada con la informaci�n en la base de datos
  *
  * @author Anthony Santillan <asantillany@telconet.ec>
  * @version 1.0 01-06-2021
  */
  TYPE Lt_DataPorProcesarHilos
  IS
    TABLE OF Lr_DataPorProcesarHilos INDEX BY PLS_INTEGER; 

END INKG_TYPES;
/



