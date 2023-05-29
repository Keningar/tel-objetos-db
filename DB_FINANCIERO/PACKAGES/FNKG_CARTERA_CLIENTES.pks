CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_CARTERA_CLIENTES
AS 
  --
  /*
  * Documentación para TYPE 'Lr_InfoAnticiposClienteNDI'.
  *
  * Tipo de datos para el retorno de la informacion correspondiente al reporte de anticipos no asociados a una factura
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 - 04-10-2017
  */
  TYPE Lr_InfoAnticiposClienteNDI
  IS
    RECORD
    (
      ID_PAGO                   DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
      ID_PERSONA_ROL            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
      IDENTIFICACION_CLIENTE    DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
      CLIENTE                   DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      FORMA_PAGO                DB_COMERCIAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
      DESCRIPCION_BANCO         DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,
      DESCRIPCION_CUENTA        DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
      DESCRIPCION_JURISDICCION  DB_INFRAESTRUCTURA.ADMI_JURISDICCION.DESCRIPCION_JURISDICCION%TYPE,
      LOGIN                     DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      DESCRIPCION_PUNTO         DB_COMERCIAL.INFO_PUNTO.DESCRIPCION_PUNTO%TYPE,
      ESTADO_PUNTO              DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
      ESTADO_INTERNET           DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      NUMERO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
      FE_PAGO                   DB_FINANCIERO.INFO_PAGO_CAB.FE_CREACION%TYPE,
      NOMBRE_TIPO_DOCUMENTO     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
      ESTADO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
      ESTADO_PAGO_HISTORIAL     DB_FINANCIERO.INFO_PAGO_HISTORIAL.ESTADO%TYPE,
      VALOR_TOTAL               DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
      TOTAL_PAGOS               NUMBER,
      TOTAL_NDI                 NUMBER,
      TOTAL_NC                  NUMBER,
      SALDO                     NUMBER );
  --
  TYPE C_AnticiposClienteNDI
  IS
    REF
    CURSOR
      RETURN Lr_InfoAnticiposClienteNDI;
  -- 
  --
  /*
  * Documentación para TYPE 'Lr_InfoAnticiposCliente'.
  *
  * Tipo de datos para el retorno de la informacion correspondiente al reporte de anticipos
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 16-11-2016
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.1 17-08-2017 - Cambio de tipo de dato en la variable FORMA_PAGO
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.2 1-12-2017 - Se agrega el campo Ciclo
  */
  TYPE Lr_InfoAnticiposCliente
  IS
    RECORD
    (
      ID_PAGO                   DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
      ID_PERSONA_ROL            DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      NOMBRE_OFICINA            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
      IDENTIFICACION_CLIENTE    DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
      CLIENTE                   DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      FORMA_PAGO                DB_COMERCIAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
      DESCRIPCION_BANCO         DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,
      DESCRIPCION_CUENTA        DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE,
      DESCRIPCION_JURISDICCION  DB_INFRAESTRUCTURA.ADMI_JURISDICCION.DESCRIPCION_JURISDICCION%TYPE,
      LOGIN                     DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      DESCRIPCION_PUNTO         DB_COMERCIAL.INFO_PUNTO.DESCRIPCION_PUNTO%TYPE,
      ESTADO_PUNTO              DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
      ESTADO_INTERNET           DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      NUMERO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
      FE_PAGO                   DB_FINANCIERO.INFO_PAGO_CAB.FE_CREACION%TYPE,
      NOMBRE_TIPO_DOCUMENTO     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
      ESTADO_PAGO               DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE,
      ESTADO_PAGO_HISTORIAL     DB_FINANCIERO.INFO_PAGO_HISTORIAL.ESTADO%TYPE,
      VALOR_TOTAL               DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
      CICLO                     DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE);
  --
  TYPE C_AnticiposCliente
  IS
    REF
    CURSOR
      RETURN Lr_InfoAnticiposCliente;
  -- 
  /*
  * Documentación para TYPE 'Lr_InfoCarteraCliente'.
  * Tipo de datos para el retorno de la informacion correspondiente al reporte, segun la data solictada por el usuario
  *
  * PARAMETROS:
  * @Param int id_documento (numero de tarjeta o cuenta que se desea desencriptar)
  * @return number saldo (saldo del documento)
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.1 16-03-2016
  * since  1.0
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 23-06-2016 - Se agregan las columnas de Usuario de Cobranzas solicitado por TN, y el motivo de rechazo del débito solicitado por 
  *                           MD
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 27-06-2016 - Se agrega la columna que indica la fecha en que fue rechazado el débito bancario al cliente.
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.4 26-07-2016 - Se agrega la columna 'DESCRIPCION_TIPO_ROL' que indica el tipo rol correspondiente al 
  *                           ejemplo Pre-cliente|Cliente|Empleado, etc
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.5 20-10-2016 - Se agregan las columnas 'ID_DOCUMENTO', y 'TRAMITE_LEGAL' para saber si el cliente se encuentra en tramite legal (S)
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.6 17-08-2017 - Cambio de tipo de dato en todas las variables del RECORD para poder reutilizar el type dentro del paquete.
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.7 15-09-2017 - Se agregan las columnas 'TOTAL_PAGOS', 'TOTAL_NC', y 'TOTAL_NDI'.
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.8 1-12-2017 - Se agrega el campo Ciclo
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.9 13-09-2018 - Se agregan las columnas 'NOMBRE_TIPO_NEGOCIO', 'TIEMPO_MESES_CORTE'.
  */
  TYPE Lr_InfoCarteraCliente
  IS
    RECORD
    (
      ID_DOCUMENTO            NUMBER,
      DESCRIPCION_TIPO_ROL    VARCHAR2(1000),
      NOMBRE_REGION           VARCHAR2(1000),
      FECHA_REPORTE           DATE,
      TIPO_IDENTIFICACION     VARCHAR2(1000),
      IDENTIFICACION_CLIENTE  VARCHAR2(1000),
      NOMBRE_CLIENTE          VARCHAR2(1000),
      ESTADO_CLIENTE          VARCHAR2(1000),
      NUMERO_CONTRATO         VARCHAR2(1000),
      FORMA_PAGO              VARCHAR2(1000),
      NOMBRE_OFICINA          VARCHAR2(1000),
      CODIGO_TIPO_NEGOCIO     VARCHAR2(1000),
      NOMBRE_TIPO_NEGOCIO     VARCHAR2(1000),
      LOGIN                   VARCHAR2(1000),
      ESTADO_PUNTO            VARCHAR2(1000),
      ESTADO_INTERNET         VARCHAR2(1000),
      FE_EMISION              DATE,
      FACTURA                 VARCHAR2(1000),
      CICLO                   VARCHAR2(200),
      VALOR_TOTAL             NUMBER,
      DIAS                    NUMBER,
      SALDO                   NUMBER,
      TOTAL_PAGOS             NUMBER,
      TOTAL_NC                NUMBER,
      TOTAL_NDI               NUMBER,
      TELEFONOS               VARCHAR2(4000),
      DIRECCION               VARCHAR2(1000),
      CIUDAD                  VARCHAR2(1000),
      VENDEDOR                VARCHAR2(1000),
      ELEMENTO                VARCHAR2(1000),
      TIPO_MEDIO              VARCHAR2(1000),
      NUMERO_CORTES           VARCHAR2(1000),
      FE_CANCELACION          VARCHAR2(1000),
      FE_CORTE                VARCHAR2(1000),
      FE_ACTIVACION           VARCHAR2(1000),
      DESCRIPCION_BANCO       VARCHAR2(1000),
      DESCRIPCION_CUENTA      VARCHAR2(1000),
      EJECUTIVO_COBRANZAS     VARCHAR2(1000),
      MOTIVO_RECHAZO_DEBITO   VARCHAR2(300),
      FE_RECHAZO_DEBITO       VARCHAR2(300),
      TRAMITE_LEGAL           VARCHAR2(2),
      TIEMPO_MESES_CORTE      VARCHAR2(300)
    );

    TYPE P_ClientesCartera IS REF CURSOR RETURN Lr_InfoCarteraCliente;
  --
  --
  /*
  * Documentación para PROCEDURE 'P_REPORTE_ANTICIPOS_NDI'.
  *
  * Procedure que retorna el listado de los anticipos creados de los clientes para una empresa que no está asociados a una factura
  *
  * PARAMETROS:
  * @param  Pv_CodEmpresa          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (Código de la empresa a realizar el reporte)
  * @param  Pv_FeConsultaHasta     IN VARCHAR2  (Contendrá la fecha hasta la cual se desea consultar los anticipos de los clientes)
  * @return Prf_AnticiposCliente   OUT C_AnticiposCliente  (Cursor con los anticipos de los clientes para el reporte)
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 04-10-2017
  *                           
  * Costo del query - Anticipos: 48252
  *
  */
  PROCEDURE P_REPORTE_ANTICIPOS_NDI(
      Pv_PrefijoEmpresa        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_FeConsultaHasta       IN  VARCHAR2,
      Prf_AnticiposClienteNDI  OUT C_AnticiposClienteNDI);
  --
  --
  /*
  * Documentación para PROCEDURE 'P_REPORTE_ANTICIPOS'.
  *
  * Procedure que retorna el listado de los anticipos creados de los clientes para una empresa.
  *
  * PARAMETROS:
  * @param  Pv_CodEmpresa          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (Código de la empresa a realizar el reporte)
  * @param  Pv_FeConsultaHasta     IN VARCHAR2  (Contendrá la fecha hasta la cual se desea consultar los anticipos de los clientes)
  * @return Prf_AnticiposCliente   OUT C_AnticiposCliente  (Cursor con los anticipos de los clientes para el reporte)
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 16-11-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 05-12-2016 - Se usa la función 'TO_CHAR' para cambiar el formato de SYSDATE a 'DD-MM-YYYY' y así pueda ser evaluado de forma
  *                           correcta para que retorne la información de anticipos.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 13-12-2016 - Se agrega a la función 'F_ESTADO_INTERNET' el parámetro 'Pv_FeConsultaHasta' para obtener el estado del servicio de 
  *                           INTERNET hasta esa fecha.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 13-01-2017 - Se agrega la función 'DB_FINANCIERO.FNCK_CONSULTS.F_ESTADO_PUNTO' para obtener el estado del punto dependiendo de la 
  *                           fecha de consulta del reporte
  * @author Ricardo Coello Quezada <efranco@telconet.ec>
  * @version 1.4 23-06-2017 - Se agrega filtro adicional por descripcion tipo rol: 'Cliente' y 'Pre-cliente'.
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.5 - 07-05-2018 - Se agrega condición para que consulta retorne un solo ciclo de facturación.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.6 - 10-01-2020 - Se agrega filtro de Máxima FE_CREACION en la consulta del estado del Historial de Pago. 
  *                           
  * Costo del query - Anticipos: 116943
  *
  */
  PROCEDURE P_REPORTE_ANTICIPOS(
      Pv_PrefijoEmpresa     IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_FeConsultaHasta    IN  VARCHAR2,
      Prf_AnticiposCliente  OUT C_AnticiposCliente);
  --
  --
  /*
  * Documentación para FUNCION 'F_SALDO_X_PAGO'.
  *
  * Funcion que permite obtener el saldo de un pago o anticipo que no está asociado a una factura
  *
  * PARAMETROS:
  * @param Fn_IdPagoCab       IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE  Id del pago cabecera que se desea obtener el saldo
  * @param Fn_ValorPagoCab    IN DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE  Valor del pago cabecera a obtener
  * @param Fv_FeConsultaHasta IN VARCHAR2  Fecha de consulta hasta cual se desea obtener el saldo
  * @param Fv_TipoConsulta    IN VARCHAR2  Tipo de saldo que se desea obtener
  *
  * @return NUMBER  Saldo del pago o anticipo
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 04-10-2017
  */
  FUNCTION F_SALDO_X_PAGO(
      Fn_IdPagoCab       IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
      Fn_ValorPagoCab    IN DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
      Fv_FeConsultaHasta IN VARCHAR2,
      Fv_TipoConsulta    IN VARCHAR2)
    RETURN NUMBER;
  --
  /*
  * Documentación para FUNCION 'F_SALDO_X_FACTURA'.
  * Funcion que permite obtener el saldo del documento.
  *
  * PARAMETROS:
  * @Param int id_documento (numero de tarjeta o cuenta que se desea desencriptar)
  * @return number saldo (saldo del documento)
  * @author Gina Villalba <gvillalba@telconet.ec>
  * since  1.0
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 19-10-2016 - Se añade parámetro 'Fv_FeConsultaHasta' que contendrá la fecha hasta la cual se desea consultar el saldo de la factura
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 15-09-2017 - Se agrega el parámetro 'Fv_TipoConsulta' para obtener el tipo de consulta o valor a retornar de la función
  */
  FUNCTION F_SALDO_X_FACTURA(
      Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_FeConsultaHasta IN VARCHAR2,
      Fv_TipoConsulta    IN VARCHAR2)
    RETURN NUMBER;
    --

    /*
    * Documentación para FUNCION 'F_NOMBRE_VENDEDOR'.
    * Funcion que permite obtener el nombre del vendedor asociado al punto cliente.
    *
    * PARAMETROS:
    * @Param varchar2 usr_vendedor (login del vendedor)
    * @return varchar2 nombre (nombre completo del vendedor)
    * @author Gina Villalba <gvillalba@telconet.ec>
    * since  1.0
    */
    FUNCTION F_NOMBRE_VENDEDOR(usr_vendedor IN INFO_PUNTO.USR_VENDEDOR%TYPE) RETURN VARCHAR2;

    /*
    * Documentación para FUNCION 'F_CONTRATO_CANCELADO'.
    * Funcion que permite obtener la forma de pago del contrato para los clientes con estado Cancelado
    *
    * PARAMETROS:
    * @Param  varchar2  Fn_IdPersonaRol   (id_persona_rol del cliente)
    * @return varchar2  Fv_FormaPago      (forma de pago asociado al contrato cancelado)
    * @author Gina Villalba <gvillalba@telconet.ec>
    * since  1.0
    */
    FUNCTION F_CONTRATO_CANCELADO(Fn_IdPersonaRol   IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE
    ) RETURN DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE;
  --
  --
  /*
  * Documentación para FUNCION 'F_INFORMACION_CONTRATO'.
  * Funcion que permite obtener las cuentas bancarias asociadas al contrato
  *
  * PARAMETROS:
  * @return VARCHAR2  Fv_TipoInformacion  (tipo de información que se desea consultar)
  * @Param  INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE  Fn_IdPersonaRol  (id_persona_rol del cliente)
  * @return VARCHAR2  Retorna la información solicitada
  * @author Gina Villalba <gvillalba@telconet.ec>
  * since  1.0
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 28-10-2016 - Se añade cursor 'C_TramiteLegal' para obtener si el cliente esta en trámite legal
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.2 13-09-2018 - Se añade cursor 'C_TiempoEsperaMesesCorte' para obtener el tiempo de espera meses corte
  */
  FUNCTION F_INFORMACION_CONTRATO(
      Fv_TipoInformacion IN VARCHAR2,
      Fn_IdPersonaRol    IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE )
    RETURN VARCHAR2;
  --
  --
    /*
    * Documentación para FUNCION 'F_INFORMACION_SERVICIO'.
    * Funcion que permite obtener referente al servicio de internet asociado al punto de facturacion
    *
    * PARAMETROS:
    * @Param  varchar2  Fn_TipoInformacion    (tipo de informacion solicitada del cliente)
    * @Param  varchar2  Fn_IdPuntoFacturacion (punto del facturacion del cliente)
    * @return varchar2 
    *
    * @author  Edgar Holguín <eholguin@telconet.ec>
    * @version 1.1 26-01-2017 Se realiza creación de cursores que ejecutan consultas de elemento, tipo de medio, fecha de activación, fecha de corte, 
    *                         fecha de cancelación, número de cortes, realizando la consulta por producto.
    *                       
    * @author Gina Villalba <gvillalba@telconet.ec>
    * since  1.0
    */
    FUNCTION F_INFORMACION_SERVICIO(Fn_TipoInformacion IN VARCHAR2,
      Fn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
    ) RETURN VARCHAR2;
  --
  --
  /*
  * Documentación para FUNCION 'F_ESTADO_INTERNET'.
  * Funcion que permite obtener el estado del servicio relacionado al internet
  *
  * PARAMETROS:
  * @param Fn_IdPuntoFacturacion IN  VARCHAR2  (Login del punto cliente)
  * @param Fv_FeConsultaHasta    IN  VARCHAR2  (Fecha de consulta del reporte)
  *
  * @return varchar2 estado (estado del servicio relacionado al internet)
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 16-03.2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 13-12-2016 - Se agrega el parámetro 'Fv_FeConsultaHasta' para obtener el estado del servicio de internet que tenía hasta esa fecha de
  *                           consulta.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 13-01-2017 - Se consulta el máximo servicio de internet para obtener el estado del servicio correcto asociado al punto de
  *                           facturación del cliente
  */
  FUNCTION F_ESTADO_INTERNET(
      Fn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Fv_FeConsultaHasta    IN VARCHAR2)
    RETURN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE;
  --
  --
    /*
    * Documentación para FUNCION 'GET_ADITIONAL_DATA_BYPUNTO'.
    * Funcion que permite obtener el listado de telefonos del punto
    *
    * PARAMETROS:
    * @Param varchar2 Fn_IdPunto (login del punto cliente)
    * @Param varchar2 Fv_TipoData (FONO)
    * @return varchar2 telefonos (estado del servicio relacionado al internet)
    * @author Gina Villalba <gvillalba@telconet.ec>
    * @version 1.0 16-03.2016
    *
    * @author Edgar Holguín <eholguin@telconet.ec>
    * @version 1.1 - 28-05-2018 - Se reliza consulta de forma de contacto teléfono adicional sólo cuando no exista a  nivel de cliente o punto.
    */
    FUNCTION GET_ADITIONAL_DATA_BYPUNTO(
      Fn_IdPunto  IN INFO_PUNTO.ID_PUNTO%TYPE,
      Fv_TipoData IN ADMI_FORMA_CONTACTO.CODIGO%TYPE)
    RETURN VARCHAR2;
  --
  --    
  /*
  * Documentación para PROCEDURE 'P_CARTERA_POR_FACTURA'.
  * Procedure que retorna el listado de clientes usados para el reporte de cartera.
  *
  * PARAMETROS:
  * @Param INFO_EMPRESA_GRUPO.PREFIJO%TYPE Pv_Empresa    (Código de la empresa a realizar el reporte)
  * @Param VARCHAR2   Pv_FeConsultaHasta  (Fecha de consulta que se validará contra la fecha de emisión para las NDI o autorización para las
  *                                        FACTURAS)
  * @return P_ClientesCartera              C_GetClientes (Cursor con los clientes del reporte)
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 23-06-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 27-06-2016 - Se agrega columna de 'FE_RECHAZO_DEBITO' el cual contiene la fecha de rechazo del débito del cliente
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.3 26-07-2016 - Se agrega columna 'DESCRIPCION_TIPO_ROL' el cual contiene el tipo rol ejemplo
  *                           Pre-cliente|Cliente|Empleado, etc
  *                         - Se agrega validacion de la FE_AUTORIZACION y FE_EMISION ya que los documentos que no sean
  *                           electronicos no van a poseer esta fecha y se vera afectado el calculo de los dias
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 20-10-2016 - Se agrega parámetro 'Pv_FeConsultaHasta' para saber hasta que fecha se requiere consultar los documentos que se
  *                           mostrarán en el reporte de cartera.
  *                         - Adicional se agregan al reporte los documentos NDI que no tienen ligado un pago inicial en sus detalles
  *                         - Adicional se agrega campo TRAMITE_LEGAL
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 18-11-2016 - Se valida que al traer las Facturas y Facturas Proporcionales verifique con la fecha de consulta enviado en el 
  *                           parámetro 'Pv_FeConsultaHasta', lo siguiente:
  *                           - Que se presente la FAC o FACP si el campo 'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_AUTORIZACION' se encuentra
  *                             dentro del rango de fecha enviado.
  *                           - Que se presente la FAC o FACP si el campo 'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_AUTORIZACION' es 'NULL' y 
  *                             el campo 'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION' se encuentra dentro del rango de fecha enviado.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 13-12-2016 - Se agrega a la función 'F_ESTADO_INTERNET' el parámetro 'Pv_FeConsultaHasta' para obtener el estado del servicio de 
  *                           INTERNET hasta esa fecha.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 13-01-2017 - Se agrega la función 'DB_FINANCIERO.FNCK_CONSULTS.F_ESTADO_PUNTO' para obtener el estado del punto dependiendo de la
  *                           fecha de consulta del reporte
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.5 15-09-2017 - Se agregan las columnas 'totalPagos', 'totalNotasCredito', 'totalNotasDebitoInternas' para obtener un detallado de los
  *                           pagos o notas de debito interna y/o notas de credito obtenidos por cada factura del reporte
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.6 17-10-2017 - Se quitan los valores en cero del reporte de cartera.
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.7 17-01-2018 - Se modifica  para que cálculo de días de referencia se calcule a partir de la fecha enviada como parámetro.
  *
  * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
  * @version 1.8 12-03-2018 - Se modifica para se consulte por FeEmision de la Factura y ya no por FeAutorizacion.
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.9 - 07-05-2018 - Se agrega condición para que consulta retorne un solo ciclo de facturación.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.10 13-09-2018 - Se agregan las columnas 'nombre_tipo_negocio', 'TIEMPO_MESES_CORTE' para obtener un detalle de los
  *                            mismos por cada factura del reporte.
  */
  PROCEDURE P_CARTERA_POR_FACTURA(
      Pv_Empresa         IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_FeConsultaHasta IN VARCHAR2,
      C_GetClientes      OUT P_ClientesCartera);
  --
  --
    /*
     * Documentación para FUNCION 'F_NOMBRE_EJECUTIVO_COBRANZAS'.
     * Funcion que permite obtener el nombre del ejecutivo de cobranzas asociado al punto cliente.
     *
     * PARAMETROS:
     * @Param varchar2 usr_cobranzas (login del ejecutivo de cobranzas)
     * @return varchar2 nombre (nombre completo del ejecutivo de cobranzas)
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.0 23-06-2016
     */
    FUNCTION F_NOMBRE_EJECUTIVO_COBRANZAS(usr_cobranzas IN INFO_PUNTO.USR_COBRANZAS%TYPE) RETURN VARCHAR2;

    /*
     * Documentación para FUNCION 'F_GET_DEBITO'.
     * Funcion que permite obtener información del debito de un cliente.
     *
     * PARAMETROS:
     * @Param integer    Pn_IdPersonaEmpresaRol (idPersonaEmpresaRol del cliente)
     * @Param varchar2   Pv_Columna             (columna a obtener)
     * @Param varchar2   Pv_EstadoDebito        (estado del debito)
     *
     * @return varchar2  Fv_Resutado           (resultado obtenido de la función)
     *
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.0 - 27-06-2016
     */
    FUNCTION F_GET_DEBITO( Pn_IdPersonaEmpresaRol IN INFO_PUNTO.ID_PUNTO%TYPE,
                           Pv_Columna             IN VARCHAR2,
                           Pv_EstadoDebito        IN VARCHAR2 )
    RETURN VARCHAR2;

    /*
     * Documentación para PROCEDURE 'P_EJEC_REP_CART_ANTIC_MD'.
     * Procedimiento que realiza la generacion de los reportes de cartera y anticipo en un archivo CSV.
     * Se realiza la revision y se optimiza el query principal de Cartera (C_ClienteCartera) en conjunto con el DBA.
     * Costo del query C_ClienteCartera: 33275
     *
     * @author Jorge Guerrero <jguerrerop@telconet.ec>
     * @version 1.0 - 08-08-2017
     * @author Edson Franco <efranco@telconet.ec>
     * @version 1.1 - 17-10-2017 - Se cambia a que se muestre el saldo en las columnas que marcan los dias que lleva la cartera vencida.
     * @author Luis Lindao <llindao@telconet.ec>
     * @version 1.2 - 17-10-2017 - se quita join con región y empresa pues Megadatos no tiene registradas todas las regiones
     *
     * @author Anabelle Peñaherrera <apenaherrera@telconet.ec>
     * @version 1.3 12-03-2018 - Se modifica para se consulte por FeEmision de la Factura y ya no por FeAutorizacion.
     *
     * @author Jorge Guerrero <jguerrerop@telconet.ec>
     * @version 1.4 - 1-12-2017 - Se agrega el campo ciclo en el reporte de anticipo y de cartera
     *
     * @author Edgar Holguín <eholguin@telconet.ec>
     * @version 1.5 - 07-05-2018 - Se agrega condición para que consulta retorne un solo ciclo de facturación.
     *
     * @author Edgar Holguín <eholguin@telconet.ec>
     * @version 1.6 - 28-05-2018 - Se agrega registro adicional de detalle de error al generarse una excepción.
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 1.7 - 13-09-2018 - Se agregan las columnas 'nombre_tipo_negocio', 'TIEMPO_MESES_CORTE' para obtener un detalle de los
     *                             mismos por cada factura del reporte. Adicional se cambia el formato 'YYYY-MM-DD' a los campos de FECHA_REPORTE y
     *                             FECHA_EMISION.
     * @author Carlos Caguana <ccaguana@telconet.ec>
     * @version 1.8 - 01-04-20201 - Se agrega el consumo y envio de los archivos al servidor NFS
     */
    PROCEDURE P_EJEC_REP_CART_ANTIC_MD;

    /*
     * Documentación para FUNCTION 'F_FORMAT_TEXT'.
     * PARAMETROS:
     * @Param VARCHAR2    Pv_Text (Texto a ser formateado)
     * Funcion para validar textos, recorta el texto y elimina los caracteres especiales ENTER
     *
     * @author Jorge Guerrero <jguerrerop@telconet.ec>
     * @version 1.0 - 16-08-2017
     */
    FUNCTION F_FORMAT_TEXT(Pv_Text IN VARCHAR2)
    RETURN VARCHAR2;
    --
    --
    /*
     * Documentación para FUNCTION 'F_GET_FORMA_PAGO'.
     * PARAMETROS:
     * @Param DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE   Fn_IdPersonaRol  (Id personaEmpresaRol)
     * @Param DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE   Fn_IdPunto       (Id punto)
     * Funcion para obtener la forma de pago.
     *
     * @author Hector Lozano <hlozano@telconet.ec>
     * @version 1.0 - 12-03-2021 
     */
    FUNCTION F_GET_FORMA_PAGO(Fn_IdPersonaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                              Fn_IdPunto       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
    RETURN VARCHAR2;

    /*
     * Documentación para FUNCTION 'F_HTTPPOSTMULTIPART'.
     * PARAMETROS:
     * @Param VARCHAR2    Fv_UrlMicro (Url del microservicio)
     * @Param VARCHAR2    Fv_FileName (Path del File a enviar)
     * @Param VARCHAR2    Fv_NombreArchivo (Nombre del Archivo)
     * @Param VARCHAR2    Fv_PathAdicional (Path adicional donde se va enviar el archivo)
     * @Param VARCHAR2    Fv_CodigoApp (Codigo del app a enviar el archivo)
     * @Param VARCHAR2    Fv_CodigoPath (Codigo del path a enviar el archivo)
     * Funcion para realizar consumo multipart y envio de archivo al servidor NFS
     *
     * @author Carlos Caguana <ccaguana@telconet.ec>
     * @version 1.0 - 01-04-2021
     */
    FUNCTION F_HTTPPOSTMULTIPART(Fv_UrlMicro VARCHAR2,Fv_FileName VARCHAR2,Fv_NombreArchivo VARCHAR2,Fv_PathAdicional VARCHAR2,Fv_CodigoApp VARCHAR2,Fv_CodigoPath VARCHAR2)
    RETURN VARCHAR2;



   /*
     * Documentación para FUNCTION 'F_CONTAINS'.
     * PARAMETROS:
     * @Param VARCHAR2    PV_TEXTO (texto de la cadena a comparar)
     * @Param VARCHAR2    PV_COMPARAR (texto del contenido a comparar)
     * Funcion que permite saber si una cadena contiene otra cadena
     *
     * @author Carlos Caguana <ccaguana@telconet.ec>
     * @version 1.0 - 08-04-20201
     */
   FUNCTION F_CONTAINS(PV_TEXTO VARCHAR2,PV_COMPARAR VARCHAR2)
   RETURN VARCHAR2;


END FNKG_CARTERA_CLIENTES;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_CARTERA_CLIENTES
AS
  --
  PROCEDURE P_REPORTE_ANTICIPOS_NDI(
      Pv_PrefijoEmpresa        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_FeConsultaHasta       IN  VARCHAR2,
      Prf_AnticiposClienteNDI  OUT C_AnticiposClienteNDI)
  AS
    --
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
    Lv_CodigoAnticipos DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE    := 'CODIGO_ANTICIPOS';
    --
  BEGIN
    --
    OPEN Prf_AnticiposClienteNDI FOR 
    SELECT IPC.ID_PAGO,
      IPER.ID_PERSONA_ROL,
      IOG.NOMBRE_OFICINA,
      IPE.IDENTIFICACION_CLIENTE,
      DB_FINANCIERO.FNCK_CONSULTS.F_GET_NOMBRE_COMPLETO_CLIENTE(IP.ID_PUNTO) AS CLIENTE,
      CASE
        WHEN IPER.ESTADO = 'Cancelado'
        THEN DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_CONTRATO_CANCELADO( IPER.ID_PERSONA_ROL)
        ELSE DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO( IPER.ID_PERSONA_ROL, NULL)
      END                                                                                                         AS FORMA_PAGO,
      DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO( 'DESCRIPCION_BANCO', IPER.ID_PERSONA_ROL)       AS DESCRIPCION_BANCO,
      DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO( 'DESCRIPCION_TIPO_CUENTA', IPER.ID_PERSONA_ROL) AS DESCRIPCION_CUENTA,
      AJ.DESCRIPCION_JURISDICCION,
      IP.LOGIN,
      IP.DESCRIPCION_PUNTO,
      NVL(DB_FINANCIERO.FNCK_CONSULTS.F_ESTADO_PUNTO(IP.ID_PUNTO, Pv_FeConsultaHasta), IP.ESTADO) AS ESTADO_PUNTO,
      DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_ESTADO_INTERNET(IP.ID_PUNTO, Pv_FeConsultaHasta)      AS ESTADO_INTERNET,
      IPC.NUMERO_PAGO,
      IPC.FE_CREACION AS FE_PAGO,
      ATDF.NOMBRE_TIPO_DOCUMENTO,
      IPC.ESTADO_PAGO,
      (SELECT IPH.ESTADO
      FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH
      WHERE IPH.ID_PAGO_HISTORIAL IN
        (SELECT MAX(IPH_S.ID_PAGO_HISTORIAL)
        FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH_S
        WHERE IPH_S.FE_CREACION < NVL2( Pv_FeConsultaHasta, TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY')+1, 
                                        TO_DATE( TO_CHAR( SYSDATE + 1, 'DD-MM-YYYY'), 'DD-MM-YYYY') )
        AND IPH_S.PAGO_ID       = IPC.ID_PAGO
        )
      )AS ESTADO_PAGO_HISTORIAL,
      IPC.VALOR_TOTAL,
      ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_PAGO(IPC.ID_PAGO, IPC.VALOR_TOTAL, Pv_FeConsultaHasta, 'PAG'),2) AS TOTAL_PAGOS,
      ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_PAGO(IPC.ID_PAGO, IPC.VALOR_TOTAL, Pv_FeConsultaHasta, 'ND'),2) AS TOTAL_NDI,
      ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_PAGO(IPC.ID_PAGO, IPC.VALOR_TOTAL, Pv_FeConsultaHasta, 'NC'),2) AS TOTAL_NC,
      ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_PAGO(IPC.ID_PAGO, IPC.VALOR_TOTAL, Pv_FeConsultaHasta, 'saldo'),2) AS SALDO
    FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
    JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
    ON IPC.OFICINA_ID = IOG.ID_OFICINA
    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
    ON IEG.COD_EMPRESA = IOG.EMPRESA_ID
    JOIN DB_COMERCIAL.INFO_PUNTO IP
    ON IPC.PUNTO_ID = IP.ID_PUNTO
    JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION AJ
    ON AJ.ID_JURISDICCION = IP.PUNTO_COBERTURA_ID
    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
    ON IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER
    ON IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
    JOIN DB_COMERCIAL.ADMI_ROL AR
    ON AR.ID_ROL = IER.ROL_ID
    JOIN DB_GENERAL.ADMI_TIPO_ROL ATR
    ON ATR.ID_TIPO_ROL = AR.TIPO_ROL_ID
    JOIN DB_COMERCIAL.INFO_PERSONA IPE
    ON IPER.PERSONA_ID = IPE.ID_PERSONA
    JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    ON IPC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO
    JOIN DB_FINANCIERO.INFO_PAGO_DET IPD
    ON IPD.PAGO_ID = IPC.ID_PAGO
    JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
    ON IDFD.PAGO_DET_ID             = IPD.ID_PAGO_DET
    WHERE IEG.PREFIJO               = Pv_PrefijoEmpresa
    AND ATR.DESCRIPCION_TIPO_ROL   IN ('Cliente','Pre-cliente')
    AND ATDF.CODIGO_TIPO_DOCUMENTO IN
      ( SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
      JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
      ON APC.ID_PARAMETRO      = APD.PARAMETRO_ID
      WHERE APC.ESTADO         = Lv_EstadoActivo
      AND APD.ESTADO           = Lv_EstadoActivo
      AND APC.NOMBRE_PARAMETRO = Lv_CodigoAnticipos )
    AND IPC.PUNTO_ID      IS NOT NULL
    AND IPD.REFERENCIA_ID IS NULL 
    GROUP BY IPC.ID_PAGO,
      IPER.ID_PERSONA_ROL,
      IOG.NOMBRE_OFICINA,
      IPE.IDENTIFICACION_CLIENTE,
      AJ.DESCRIPCION_JURISDICCION,
      IP.LOGIN,
      IP.DESCRIPCION_PUNTO,
      IP.ESTADO,
      IP.ID_PUNTO,
      IPC.NUMERO_PAGO,
      IPC.ESTADO_PAGO,
      IPC.FE_CREACION,
      ATDF.NOMBRE_TIPO_DOCUMENTO,
      IPC.VALOR_TOTAL,
      IPER.ESTADO
    ORDER BY CLIENTE;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_CARTERA_CLIENTES.P_REPORTE_ANTICIPOS_NDI', 
                                          'Error al obtener el listado de anticipos (' || Pv_PrefijoEmpresa || ', ' || Pv_FeConsultaHasta || ') - '
                                          || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_REPORTE_ANTICIPOS_NDI;
  --
  --
  PROCEDURE P_REPORTE_ANTICIPOS(
      Pv_PrefijoEmpresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_FeConsultaHasta    IN VARCHAR2,
      Prf_AnticiposCliente  OUT C_AnticiposCliente)
  AS
    --
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
    Lv_CodigoAnticipos DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE    := 'CODIGO_ANTICIPOS';
    Lv_EstadosFinancieros DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'ESTADOS_FINANCIEROS';
    Lv_NombreTabla DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE             := 'INFO_PAGO_CAB';
    Lv_NombreProcedimiento DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE          := 'P_REPORTE_ANTICIPOS';
    Lv_EstadosIncluidos DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE             := 'IN';
    Lv_EstadosNoIncluidos DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE           := 'NOT IN';
    Lv_NombreDocumentos DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE             := 'ANTICIPOS';
    --
  BEGIN
    --
    OPEN Prf_AnticiposCliente FOR 
    SELECT 
      ANTICIPOS.*,
      (SELECT AC.NOMBRE_CICLO
          FROM DB_COMERCIAL.ADMI_CICLO AC,
               DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IP,
               DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          WHERE IP.PERSONA_EMPRESA_ROL_ID=ANTICIPOS.ID_PERSONA_ROL
          AND ACAR.ID_CARACTERISTICA=IP.CARACTERISTICA_ID
          AND ACAR.DESCRIPCION_CARACTERISTICA='CICLO_FACTURACION'
          AND IP.ESTADO='Activo'
          AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IP.VALOR,'^\d+')),0) = AC.ID_CICLO 
          AND ROWNUM = 1) AS CICLO
    FROM
    (
      SELECT IPC.ID_PAGO,
        IPER.ID_PERSONA_ROL,
        IOG.NOMBRE_OFICINA,
        IPE.IDENTIFICACION_CLIENTE,
        DB_FINANCIERO.FNCK_CONSULTS.F_GET_NOMBRE_COMPLETO_CLIENTE(IP.ID_PUNTO) AS CLIENTE,
        CASE
          WHEN IPER.ESTADO = 'Cancelado'
          THEN DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_CONTRATO_CANCELADO( IPER.ID_PERSONA_ROL)
          ELSE DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO( IPER.ID_PERSONA_ROL, NULL)
        END                                                                                                         AS FORMA_PAGO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO( 'DESCRIPCION_BANCO', IPER.ID_PERSONA_ROL)       AS DESCRIPCION_BANCO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO( 'DESCRIPCION_TIPO_CUENTA', IPER.ID_PERSONA_ROL) AS DESCRIPCION_CUENTA,
        AJ.DESCRIPCION_JURISDICCION,
        IP.LOGIN,
        IP.DESCRIPCION_PUNTO,
        NVL(DB_FINANCIERO.FNCK_CONSULTS.F_ESTADO_PUNTO(IP.ID_PUNTO, Pv_FeConsultaHasta), IP.ESTADO) AS ESTADO_PUNTO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_ESTADO_INTERNET(IP.ID_PUNTO, Pv_FeConsultaHasta)      AS ESTADO_INTERNET,
        IPC.NUMERO_PAGO,
        IPC.FE_CREACION AS FE_PAGO,
        ATDF.NOMBRE_TIPO_DOCUMENTO,
        IPC.ESTADO_PAGO,
        ( SELECT IPH.ESTADO
          FROM DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH
          WHERE IPH.ID_PAGO_HISTORIAL IN  (  
                                          SELECT
                                            MAX(IPH_S.ID_PAGO_HISTORIAL)
                                          FROM
                                            DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH_S
                                          WHERE IPH_S.FE_CREACION < NVL2( Pv_FeConsultaHasta, TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY')+1,
                                                                          TO_DATE( TO_CHAR(SYSDATE+1, 'DD-MM-YYYY'), 'DD-MM-YYYY') )
                                          AND IPH_S.PAGO_ID = IPC.ID_PAGO

                                          AND IPH_S.FE_CREACION = (                                          
                                          SELECT
                                            MAX(IPH_F.FE_CREACION)
                                          FROM
                                            DB_FINANCIERO.INFO_PAGO_HISTORIAL IPH_F
                                          WHERE IPH_F.FE_CREACION < NVL2( Pv_FeConsultaHasta, TO_DATE(Pv_FeConsultaHasta, 'DD-MM-YYYY')+1,
                                                                          TO_DATE( TO_CHAR(SYSDATE+1, 'DD-MM-YYYY'), 'DD-MM-YYYY') )
                                          AND IPH_F.PAGO_ID = IPC.ID_PAGO)
                                          )
        )AS ESTADO_PAGO_HISTORIAL,
        IPC.VALOR_TOTAL
      FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG                    ON IPC.OFICINA_ID             = IOG.ID_OFICINA
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG                    ON IEG.COD_EMPRESA            = IOG.EMPRESA_ID
      JOIN DB_COMERCIAL.INFO_PUNTO IP                             ON IPC.PUNTO_ID               =  IP.ID_PUNTO
      JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION AJ                ON AJ.ID_JURISDICCION         = IP.PUNTO_COBERTURA_ID
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER             ON IP.PERSONA_EMPRESA_ROL_ID  = IPER.ID_PERSONA_ROL
      JOIN DB_COMERCIAL.INFO_EMPRESA_ROL         IER              ON IER.ID_EMPRESA_ROL         = IPER.EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.ADMI_ROL                 AR               ON AR.ID_ROL                  = IER.ROL_ID
      JOIN DB_GENERAL.ADMI_TIPO_ROL              ATR              ON ATR.ID_TIPO_ROL            = AR.TIPO_ROL_ID
      JOIN DB_COMERCIAL.INFO_PERSONA IPE                          ON IPER.PERSONA_ID            = IPE.ID_PERSONA
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF      ON IPC.TIPO_DOCUMENTO_ID      = ATDF.ID_TIPO_DOCUMENTO
      LEFT JOIN DB_FINANCIERO.INFO_PAGO_DET IPD                   ON IPD.PAGO_ID                = IPC.ID_PAGO
      LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD  ON IDFD.PAGO_DET_ID           = IPD.ID_PAGO_DET
      WHERE IEG.PREFIJO                                           = Pv_PrefijoEmpresa
      AND   ATR.DESCRIPCION_TIPO_ROL                              IN ('Cliente','Pre-cliente')
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN   ( 
                                              SELECT
                                                APD.VALOR1
                                              FROM
                                                DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                              JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD
                                              ON
                                                APC.ID_PARAMETRO = APD.PARAMETRO_ID
                                              WHERE
                                                APC.ESTADO             = Lv_EstadoActivo
                                              AND APD.ESTADO           = Lv_EstadoActivo
                                              AND APC.NOMBRE_PARAMETRO = Lv_CodigoAnticipos
                                          )
      AND IPC.PUNTO_ID                IS NOT NULL 
      AND IDFD.DOCUMENTO_ID           IS NULL
      --
      GROUP BY
              IPC.ID_PAGO,
              IPER.ID_PERSONA_ROL,
              IOG.NOMBRE_OFICINA,
              IPE.IDENTIFICACION_CLIENTE,
              AJ.DESCRIPCION_JURISDICCION,
              IP.LOGIN,
              IP.DESCRIPCION_PUNTO,
              IP.ESTADO,
              IP.ID_PUNTO,
              IPC.NUMERO_PAGO,
              IPC.ESTADO_PAGO,
              IPC.FE_CREACION,
              ATDF.NOMBRE_TIPO_DOCUMENTO,
              IPC.VALOR_TOTAL,
              IPER.ESTADO
    ) ANTICIPOS 
    WHERE ANTICIPOS.ESTADO_PAGO_HISTORIAL IN  (
                                                SELECT
                                                  APD.VALOR4
                                                FROM
                                                  DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                                JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD  
                                                ON  APC.ID_PARAMETRO = APD.PARAMETRO_ID
                                                WHERE
                                                  APC.ESTADO             = Lv_EstadoActivo
                                                AND APD.ESTADO           = Lv_EstadoActivo
                                                AND APC.NOMBRE_PARAMETRO = Lv_EstadosFinancieros
                                                AND APD.DESCRIPCION      = Lv_NombreTabla
                                                AND APD.VALOR1           = Lv_NombreProcedimiento
                                                AND APD.VALOR2           = Lv_EstadosIncluidos
                                                AND APD.VALOR3           = Lv_NombreDocumentos
                                          ) 
    AND ANTICIPOS.ESTADO_PAGO NOT IN      (
                                        SELECT
                                          APD.VALOR4
                                        FROM
                                          DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                        JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD  
                                        ON  APC.ID_PARAMETRO = APD.PARAMETRO_ID
                                        WHERE
                                          APC.ESTADO             = Lv_EstadoActivo
                                        AND APD.ESTADO           = Lv_EstadoActivo
                                        AND APC.NOMBRE_PARAMETRO = Lv_EstadosFinancieros
                                        AND APD.DESCRIPCION      = Lv_NombreTabla
                                        AND APD.VALOR1           = Lv_NombreProcedimiento
                                        AND APD.VALOR2           = Lv_EstadosNoIncluidos
                                        AND APD.VALOR3           = Lv_NombreDocumentos
                                      )
    ORDER BY ANTICIPOS.NOMBRE_OFICINA, ANTICIPOS.IDENTIFICACION_CLIENTE;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_CARTERA_CLIENTES.P_REPORTE_ANTICIPOS', 
                                          'Error al obtener el listado de anticipos (' || Pv_PrefijoEmpresa || ', ' || Pv_FeConsultaHasta || ') - '
                                          || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_REPORTE_ANTICIPOS;
  --
  --
  FUNCTION F_SALDO_X_PAGO(
      Fn_IdPagoCab       IN DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
      Fn_ValorPagoCab    IN DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
      Fv_FeConsultaHasta IN VARCHAR2,
      Fv_TipoConsulta    IN VARCHAR2)
    RETURN NUMBER
  IS
    --
    --CURSOR QUE RETORNA INFORMACION DE LOS DETALLES DE PAGO A CONSULTAR
    CURSOR C_GetNDIAsociadasPagos(Cn_IdPagoCab DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE,
                                  Cv_FeConsultaHasta VARCHAR2)
    IS
      --
      SELECT IDFD.DOCUMENTO_ID AS ID_DOCUMENTO,
        IDFC.VALOR_TOTAL AS VALOR_NDI
      FROM DB_FINANCIERO.INFO_PAGO_DET IPD
      JOIN DB_FINANCIERO.INFO_PAGO_CAB IPC
      ON IPC.ID_PAGO = IPD.PAGO_ID
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
      ON IDFD.PAGO_DET_ID = IPD.ID_PAGO_DET
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      ON IDFC.ID_DOCUMENTO = IDFD.DOCUMENTO_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
      WHERE IDFC.ESTADO_IMPRESION_FACT IN
        (SELECT APD.VALOR1
         FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
         JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
         ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
         WHERE APD.ESTADO         = 'Activo'
         AND APC.ESTADO           = 'Activo'
         AND APC.NOMBRE_PARAMETRO = 'REPORTE_CARTERA'
         AND APD.DESCRIPCION      = 'ESTADO_DOCUMENTOS'
         AND APD.VALOR2           = 'FACTURAS')
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN
        (SELECT APD.VALOR1
         FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
         JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
         ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
         WHERE APD.ESTADO         = 'Activo'
         AND APC.ESTADO           = 'Activo'
         AND APC.NOMBRE_PARAMETRO = 'REPORTE_CARTERA'
         AND APD.DESCRIPCION      = 'DOCUMENTOS_ESPECIALES')
      AND IDFD.PAGO_DET_ID IS NOT NULL
      AND IDFC.FE_EMISION < NVL2(Cv_FeConsultaHasta, TO_DATE(Cv_FeConsultaHasta,'DD-MM-YY')+1, TO_DATE(SYSDATE+1,'DD-MM-YY'))
      AND IPD.PAGO_ID = Cn_IdPagoCab;
      --
    --
    Ln_Saldo         NUMBER;
    Lv_MensajeError  VARCHAR2(4000);
    Le_Exception     EXCEPTION;
    Lr_NotaDebito    C_GetNDIAsociadasPagos%ROWTYPE;
    Ln_TotalPago     NUMBER  := 0;
    Ln_TotalND       NUMBER  := 0;
    Ln_TotalNC       NUMBER  := 0;
    --
  BEGIN
    --
    Ln_Saldo := Fn_ValorPagoCab;
    --
    --
    IF C_GetNDIAsociadasPagos%ISOPEN THEN
      CLOSE C_GetNDIAsociadasPagos;
    END IF;
    --
    OPEN C_GetNDIAsociadasPagos(Fn_IdPagoCab, Fv_FeConsultaHasta);
    --
    LOOP
      FETCH
        C_GetNDIAsociadasPagos
      INTO
        Lr_NotaDebito;
      --
      EXIT WHEN C_GetNDIAsociadasPagos%NOTFOUND;
      --
      --
      IF Lr_NotaDebito.ID_DOCUMENTO > 0 THEN
        --
        Ln_TotalND := NVL(Ln_TotalND, 0) + NVL(Lr_NotaDebito.VALOR_NDI, 0);
        --
        DB_FINANCIERO.FNCK_CONSULTS.P_DETALLE_NOTAS_DEBITO(Lr_NotaDebito.ID_DOCUMENTO, NULL, Ln_TotalPago, Ln_TotalND, Ln_TotalNC);
        --
      END IF;
      --
    END LOOP;
    --
    CLOSE C_GetNDIAsociadasPagos;
    --
    --
    IF Fv_TipoConsulta = 'PAG' THEN
      --
      Ln_Saldo := ROUND( NVL(Ln_TotalPago, 0), 2 );
      --
    ELSIF Fv_TipoConsulta = 'NC' THEN
      --
      Ln_Saldo := ROUND( NVL(Ln_TotalNC, 0), 2 );
      --
    ELSIF Fv_TipoConsulta = 'ND' THEN
      --
      Ln_Saldo := ROUND( NVL(Ln_TotalND, 0), 2 );
      --
    ELSE
      --
      Ln_Saldo := ROUND( NVL(Ln_TotalND, 0), 2 ) - ROUND( NVL(Ln_Saldo, 0), 2 ) - ROUND( NVL(Ln_TotalPago, 0), 2 ) - ROUND( NVL(Ln_TotalNC, 0), 2 );
      --
    END IF;
    --
    --
    RETURN Ln_Saldo;
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    Ln_Saldo := 0;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_CONSULTS.F_SALDO_X_PAGO', 
                                          'Error al obtener el saldo del pago (' || Fn_IdPagoCab || ', ' || Fv_FeConsultaHasta || ') - ' 
                                          || Lv_MensajeError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Ln_Saldo;
    --
  WHEN OTHERS THEN
    --
    Ln_Saldo := 0;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_CONSULTS.F_SALDO_X_PAGO', 
                                          'Error al obtener el saldo del pago (' || Fn_IdPagoCab || ', ' || Fv_FeConsultaHasta || ') - ' 
                                          || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Ln_Saldo;
    --
  END;
  --
  --
  FUNCTION F_SALDO_X_FACTURA(
      Fn_IdDocumento     IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_FeConsultaHasta IN VARCHAR2,
      Fv_TipoConsulta    IN VARCHAR2)
    RETURN NUMBER
  IS
    --
    Ln_Saldo        NUMBER;
    Lv_MensajeError VARCHAR2(1000);
    Lex_Exception   EXCEPTION;
    --
  BEGIN
    --
    DB_FINANCIERO.FNCK_CONSULTS.P_SALDO_X_FACTURA_FECHA(Fn_IdDocumento, NULL, Fv_FeConsultaHasta, Fv_TipoConsulta, Ln_Saldo, Lv_MensajeError);
    --
    IF TRIM(Lv_MensajeError) IS NOT NULL THEN
      --
      RAISE Lex_Exception;
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
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_CONSULTS.F_SALDO_X_FACTURA', 
                                          'Error al obtener el saldo de la factura (' || Fn_IdDocumento || ', ' || Fv_FeConsultaHasta || ') - ' 
                                          || Lv_MensajeError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Ln_Saldo;
    --
  WHEN OTHERS THEN
    --
    Ln_Saldo := 0;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_CONSULTS.F_SALDO_X_FACTURA', 
                                          'Error al obtener el saldo de la factura (' || Fn_IdDocumento || ', ' || Fv_FeConsultaHasta || ') - ' 
                                          || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Ln_Saldo;
    --
  END;
  --
  --
FUNCTION F_NOMBRE_VENDEDOR(usr_vendedor IN INFO_PUNTO.USR_VENDEDOR%TYPE) RETURN VARCHAR2 
IS 
  Fn_NombreCompleto INFO_PERSONA.RAZON_SOCIAL%TYPE;
BEGIN
  SELECT 
      CASE
      WHEN razon_social is null then concat(concat(nombres,' '),apellidos)
      ELSE razon_social
      END AS nombre_vendedor
      INTO Fn_NombreCompleto
  FROM INFO_PERSONA
  WHERE LOGIN = usr_vendedor
  AND ROWNUM=1;
  RETURN(Fn_NombreCompleto);
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
  RETURN NULL;
END;
--
FUNCTION F_CONTRATO_CANCELADO(Fn_IdPersonaRol   IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE
) RETURN DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE 
IS 
  Lv_FormaPago DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE;
BEGIN
  SELECT  FNCK_COM_ELECTRONICO.GET_VARCHAR_CLEAN(REPLACE(REPLACE(REPLACE(AFP.DESCRIPCION_FORMA_PAGO, Chr(9), ' '), Chr(10), ' '), Chr(13), ' '))
  INTO Lv_FormaPago
  FROM INFO_CONTRATO IC,
  ADMI_FORMA_PAGO AFP
  WHERE IC.FORMA_PAGO_ID        = AFP.ID_FORMA_PAGO
  AND AFP.ESTADO                = 'Activo'
  AND IC.ESTADO                 = 'Cancelado'
  AND IC.PERSONA_EMPRESA_ROL_ID = Fn_IdPersonaRol
  AND ROWNUM=1;
  RETURN(Lv_FormaPago);
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
  RETURN NULL;
END;
  --
  --
  FUNCTION F_INFORMACION_CONTRATO(
      Fv_TipoInformacion IN VARCHAR2,
      Fn_IdPersonaRol    IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE )
    RETURN VARCHAR2
  IS
  --
  Lv_InformacionBanco VARCHAR2(1000);
  --
  --Cursor para obtener la descripcion del banco
  CURSOR C_DescripcionBanco(Fn_IdPersonaRol   IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
    SELECT 
    ab.descripcion_banco
    FROM db_comercial.info_contrato ic 
    left join db_general.admi_forma_pago afp on afp.ID_FORMA_PAGO=ic.forma_pago_id
    left join db_comercial.info_contrato_forma_pago icfp on icfp.contrato_id=ic.id_contrato
    left join db_general.admi_banco_tipo_cuenta abtc on abtc.id_banco_tipo_cuenta=icfp.banco_tipo_cuenta_id
    left join db_general.admi_banco ab on ab.id_banco=abtc.banco_id 
    WHERE
    ic.estado in ('Activo','Cancelado')
    AND afp.DESCRIPCION_FORMA_PAGO<>'EFECTIVO'
    AND IC.PERSONA_EMPRESA_ROL_ID = Fn_IdPersonaRol;

    --Cursor para obtener la descripcion de la tipo_cuenta
    CURSOR C_DescripcionCuenta(Fn_IdPersonaRol   IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
      SELECT 
      atc.descripcion_cuenta
      FROM db_comercial.info_contrato ic 
      left join db_general.admi_forma_pago afp on afp.ID_FORMA_PAGO=ic.forma_pago_id
      left join db_comercial.info_contrato_forma_pago icfp on icfp.contrato_id=ic.id_contrato
      left join db_general.admi_banco_tipo_cuenta abtc on abtc.id_banco_tipo_cuenta=icfp.banco_tipo_cuenta_id
      left join db_general.admi_banco ab on ab.id_banco=abtc.banco_id 
      left join db_general.admi_tipo_cuenta atc on atc.id_tipo_cuenta= abtc.tipo_cuenta_id
      WHERE
      ic.estado in ('Activo','Cancelado')
      AND afp.DESCRIPCION_FORMA_PAGO<>'EFECTIVO'
      AND IC.PERSONA_EMPRESA_ROL_ID = Fn_IdPersonaRol;

    --Cursor para obtener el tiempo de espera meses corte
    CURSOR C_TiempoEsperaMesesCorte(Fn_IdPersonaRol   IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) IS
      SELECT 
      TO_CHAR(ICDA.TIEMPO_ESPERA_MESES_CORTE)
      FROM DB_COMERCIAL.INFO_CONTRATO IC
      LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_DATO_ADICIONAL ICDA ON ICDA.CONTRATO_ID = IC.ID_CONTRATO
      WHERE
      IC.PERSONA_EMPRESA_ROL_ID = Fn_IdPersonaRol;

    --
    --Cursor para obtener el campo tramite legal
    CURSOR C_TramiteLegal(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                          Cv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                          Cv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                          Cv_DescripcionDetalle DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE)
    IS
      SELECT ICDA.ES_TRAMITE_LEGAL
      FROM DB_COMERCIAL.INFO_CONTRATO IC
      LEFT JOIN DB_COMERCIAL.INFO_CONTRATO_DATO_ADICIONAL ICDA
      ON ICDA.CONTRATO_ID = IC.ID_CONTRATO
      WHERE IC.ESTADO    IN
        (SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
        ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
        WHERE APD.ESTADO         = Cv_EstadoActivo
        AND APC.ESTADO           = Cv_EstadoActivo
        AND APC.NOMBRE_PARAMETRO = Cv_ParametroReporteCartera
        AND APD.DESCRIPCION      = Cv_DescripcionDetalle
        )
    AND IC.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol;
    --
    Lv_EstadoActivo DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                      := 'Activo';
    Lv_ParametroReporteCartera DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'REPORTE_CARTERA';
    Lv_DescripcionDetalle DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE           := 'ESTADO_CONTRATOS';
    --
BEGIN
  IF Fv_TipoInformacion='DESCRIPCION_BANCO' THEN
    --
    IF C_DescripcionBanco%ISOPEN THEN
      CLOSE C_DescripcionBanco;
    END IF;
    --
    OPEN C_DescripcionBanco(Fn_IdPersonaRol);
    --
    FETCH C_DescripcionBanco INTO Lv_InformacionBanco;
    --
    CLOSE C_DescripcionBanco;
    --
  ELSIF Fv_TipoInformacion='DESCRIPCION_TIPO_CUENTA' THEN
    --
    IF C_DescripcionCuenta%ISOPEN THEN
      CLOSE C_DescripcionCuenta;
    END IF;
    --
    OPEN C_DescripcionCuenta(Fn_IdPersonaRol);
    --
    FETCH C_DescripcionCuenta INTO Lv_InformacionBanco;
    --
    CLOSE C_DescripcionCuenta;
    --
  ELSIF Fv_TipoInformacion='TIEMPO_MESES_CORTE' THEN
    --
    IF C_TiempoEsperaMesesCorte%ISOPEN THEN
      CLOSE C_TiempoEsperaMesesCorte;
    END IF;
    --
    OPEN C_TiempoEsperaMesesCorte(Fn_IdPersonaRol);
    --
    FETCH C_TiempoEsperaMesesCorte INTO Lv_InformacionBanco;
    --
    CLOSE C_TiempoEsperaMesesCorte;
    --
  ELSIF Fv_TipoInformacion='TRAMITE_LEGAL' THEN
    --
    IF C_TramiteLegal%ISOPEN THEN
      CLOSE C_TramiteLegal;
    END IF;
    --
    OPEN C_TramiteLegal(Fn_IdPersonaRol, Lv_EstadoActivo, Lv_ParametroReporteCartera, Lv_DescripcionDetalle);
    --
    FETCH C_TramiteLegal INTO Lv_InformacionBanco;
    --
    CLOSE C_TramiteLegal;
    --
  END IF;
  --
  --
  RETURN Lv_InformacionBanco;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  Lv_InformacionBanco := NULL;
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                        'FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO', 
                                        'Error al obtener la información de contrato (' || Fv_TipoInformacion || ', ' || Fn_IdPersonaRol || ') - '
                                        || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                        SYSDATE, 
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  --
  RETURN Lv_InformacionBanco;
  --
END;
--
--
FUNCTION F_INFORMACION_SERVICIO(Fn_TipoInformacion IN VARCHAR2,
    Fn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  ) RETURN VARCHAR2
IS
  --
  Lv_InformacionServicio  VARCHAR2(1000);
  --
  Lv_InfoError            VARCHAR2(4000);

  --Cursor para obtener la información del elemento
  CURSOR C_Elemento(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(IE.NOMBRE_ELEMENTO)
    from db_comercial.INFO_SERVICIO iser
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO IST ON IST.SERVICIO_ID=ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID=iser.PUNTO_FACTURACION_ID
    LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO IE ON IE.ID_ELEMENTO=IST.ELEMENTO_ID
    LEFT JOIN db_comercial.info_plan_det ipd on ipd.plan_id=iser.PLAN_ID
    left join db_comercial.admi_producto ap on ap.id_producto=ipd.producto_id
    where iser.PUNTO_FACTURACION_ID=Cn_IdPuntoFacturacion
    and ap.CODIGO_PRODUCTO='INTD'
    AND ISER.ES_VENTA='S'
    AND ISER.CANTIDAD>0
    AND iser.PRECIO_VENTA>=0
    AND IPDA.ES_PADRE_FACTURACION='S'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL
    AND ROWNUM=1
    GROUP BY IE.NOMBRE_ELEMENTO;


  CURSOR C_ElementoProducto(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(IE.NOMBRE_ELEMENTO)
    FROM      DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO     IST  ON IST.SERVICIO_ID = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID   = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO       IE   ON IE.ID_ELEMENTO  = IST.ELEMENTO_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO             AP   ON AP.ID_PRODUCTO  = ISER.PRODUCTO_ID
    WHERE ISER.PUNTO_FACTURACION_ID  =  Cn_IdPuntoFacturacion
    AND AP.REQUIERE_INFO_TECNICA = 'SI'
    AND ISER.ES_VENTA = 'S'
    AND ISER.CANTIDAD > 0
    AND ISER.PRECIO_VENTA >= 0
    AND IPDA.ES_PADRE_FACTURACION = 'S'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL
    AND ROWNUM=1
    GROUP BY IE.NOMBRE_ELEMENTO;

  --Cursor para obtener el tipo de medio
  CURSOR C_NombreTipoMedio(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(ATM.NOMBRE_TIPO_MEDIO)
    from db_comercial.INFO_SERVICIO iser
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO IST ON IST.SERVICIO_ID=ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID=iser.PUNTO_FACTURACION_ID
    LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO ATM ON ATM.ID_TIPO_MEDIO=IST.ULTIMA_MILLA_ID
    LEFT JOIN db_comercial.info_plan_det ipd on ipd.plan_id=iser.PLAN_ID
    left join db_comercial.admi_producto ap on ap.id_producto=ipd.producto_id
    where iser.PUNTO_FACTURACION_ID=Cn_IdPuntoFacturacion
    and ap.CODIGO_PRODUCTO='INTD'
    AND ISER.ES_VENTA='S'
    AND ISER.CANTIDAD>0
    AND iser.PRECIO_VENTA>=0
    AND IPDA.ES_PADRE_FACTURACION='S'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL
    AND ROWNUM=1
    GROUP BY ATM.NOMBRE_TIPO_MEDIO;

  CURSOR C_NombreTipoMedioProd(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(ATM.NOMBRE_TIPO_MEDIO)
    FROM  DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_TECNICO     IST  ON IST.SERVICIO_ID   = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID     = iser.PUNTO_FACTURACION_ID
    LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO     ATM  ON ATM.ID_TIPO_MEDIO = IST.ULTIMA_MILLA_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO             AP   ON AP.ID_PRODUCTO    = ISER.PRODUCTO_ID
    WHERE ISER.PUNTO_FACTURACION_ID  =  Cn_IdPuntoFacturacion
    AND AP.REQUIERE_INFO_TECNICA = 'SI'
    AND ISER.ES_VENTA = 'S'
    AND ISER.CANTIDAD > 0
    AND ISER.PRECIO_VENTA >= 0
    AND IPDA.ES_PADRE_FACTURACION = 'S'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL
    AND ROWNUM=1
    GROUP BY ATM.NOMBRE_TIPO_MEDIO;


  --Cursor para obtener el numero de veces que el cliente ha sido cortado
  CURSOR C_Cortes(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(count(ISH.ESTADO))
    from db_comercial.INFO_SERVICIO iser
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON ISH.SERVICIO_ID=ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID=iser.PUNTO_FACTURACION_ID
    LEFT JOIN db_comercial.info_plan_det ipd on ipd.plan_id=iser.PLAN_ID
    left join db_comercial.admi_producto ap on ap.id_producto=ipd.producto_id
    where iser.PUNTO_FACTURACION_ID=Cn_IdPuntoFacturacion
    and ap.CODIGO_PRODUCTO='INTD'
    AND ISH.ESTADO='In-Corte'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;


  CURSOR C_CortesProducto(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(count(ISH.ESTADO))
    FROM  DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL   ISH  ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID   = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO             AP   ON AP.ID_PRODUCTO  = ISER.PRODUCTO_ID
    WHERE ISER.PUNTO_FACTURACION_ID = Cn_IdPuntoFacturacion
    AND   ISH.ESTADO                = 'In-Corte'
    AND   ISER.PUNTO_FACTURACION_ID IS NOT NULL;

  --Cursor para obtener la fecha de cancelacion del servicio internet
  CURSOR C_FeCancel(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MAX(ISH.fe_creacion),'YYYY-MM-DD')
    from db_comercial.INFO_SERVICIO iser
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON ISH.SERVICIO_ID=ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID=iser.PUNTO_FACTURACION_ID
    LEFT JOIN db_comercial.info_plan_det ipd on ipd.plan_id=iser.PLAN_ID
    left join db_comercial.admi_producto ap on ap.id_producto=ipd.producto_id
    where iser.PUNTO_FACTURACION_ID=Cn_IdPuntoFacturacion
    and ap.CODIGO_PRODUCTO='INTD'
    AND ISH.ESTADO='Cancel'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;

  CURSOR C_FeCancelProducto(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MAX(ISH.FE_CREACION),'YYYY-MM-DD')
    FROM  DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL   ISH  ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID   = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO             AP   ON AP.ID_PRODUCTO  = ISER.PRODUCTO_ID
    WHERE iser.PUNTO_FACTURACION_ID = Cn_IdPuntoFacturacion
    AND ISH.ESTADO                  = 'Cancel'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;

  --Cursor para obtner la fecha de corte del servicio internet
  CURSOR C_FeCorte(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MAX(ISH.FE_CREACION),'YYYY-MM-DD')
    from db_comercial.INFO_SERVICIO iser
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON ISH.SERVICIO_ID=ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID=iser.PUNTO_FACTURACION_ID
    LEFT JOIN db_comercial.info_plan_det ipd on ipd.plan_id=iser.PLAN_ID
    left join db_comercial.admi_producto ap on ap.id_producto=ipd.producto_id
    where iser.PUNTO_FACTURACION_ID=Cn_IdPuntoFacturacion
    and ap.CODIGO_PRODUCTO='INTD'
    AND ISH.ESTADO='In-Corte'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;

  CURSOR C_FeCorteProducto(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MAX(ISH.FE_CREACION),'YYYY-MM-DD')
    FROM  DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL   ISH  ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID   = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO             AP   ON AP.ID_PRODUCTO  = ISER.PRODUCTO_ID
    WHERE ISER.PUNTO_FACTURACION_ID = Cn_IdPuntoFacturacion
    AND   ISH.ESTADO = 'In-Corte'
    AND   ISER.PUNTO_FACTURACION_ID IS NOT NULL;


  --Cursor para obtener la fecha de activacion del servicio internet
  CURSOR C_FeActivacion(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MIN(ISH.fe_creacion),'YYYY-MM-DD')
    from db_comercial.INFO_SERVICIO iser
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON ISH.SERVICIO_ID=ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID=iser.PUNTO_FACTURACION_ID
    LEFT JOIN db_comercial.info_plan_det ipd on ipd.plan_id=iser.PLAN_ID
    left join db_comercial.admi_producto ap on ap.id_producto=ipd.producto_id
    where iser.PUNTO_FACTURACION_ID=Cn_IdPuntoFacturacion
    and ap.CODIGO_PRODUCTO='INTD'
    AND ISH.ESTADO='Activo'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;  


  CURSOR C_FeActivacionProd(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MIN(ISH.fe_creacion),'YYYY-MM-DD')
    FROM  DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL   ISH  ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID   = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO             AP   ON AP.ID_PRODUCTO  = ISER.PRODUCTO_ID
    WHERE iser.PUNTO_FACTURACION_ID = Cn_IdPuntoFacturacion
    AND ISH.ESTADO = 'Activo'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;  

  --Cursor para obtener el punto de cobertura
  CURSOR C_PuntoDeCobertura(Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT AJ.DESCRIPCION_JURISDICCION 
    from DB_INFRAESTRUCTURA.ADMI_JURISDICCION AJ
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO IP ON IP.PUNTO_COBERTURA_ID=AJ.ID_JURISDICCION
    where IP.ID_PUNTO=Cn_IdPuntoFacturacion;
  --
BEGIN
  IF Fn_TipoInformacion='ELEMENTO' THEN
    --
    IF C_Elemento%ISOPEN THEN
      CLOSE C_Elemento;
    END IF;
    --
    OPEN C_Elemento(Fn_IdPuntoFacturacion);
    --
    FETCH C_Elemento INTO Lv_InformacionServicio;
    --
    CLOSE C_Elemento;

    IF Lv_InformacionServicio IS NULL THEN
      IF C_ElementoProducto%ISOPEN THEN
        CLOSE C_ElementoProducto;
      END IF;
      --
      OPEN C_ElementoProducto(Fn_IdPuntoFacturacion);
      --
      FETCH C_ElementoProducto INTO Lv_InformacionServicio;
      --
      CLOSE C_ElementoProducto;
    END IF;


    --
  ELSIF Fn_TipoInformacion='TIPO_MEDIO' THEN
    --
    IF C_NombreTipoMedio%ISOPEN THEN
      CLOSE C_NombreTipoMedio;
    END IF;
    --
    OPEN C_NombreTipoMedio(Fn_IdPuntoFacturacion);
    --
    FETCH C_NombreTipoMedio INTO Lv_InformacionServicio;
    --
    CLOSE C_NombreTipoMedio;

    IF Lv_InformacionServicio IS NULL THEN
      IF C_NombreTipoMedioProd%ISOPEN THEN
        CLOSE C_NombreTipoMedioProd;
      END IF;
      --
      OPEN C_NombreTipoMedioProd(Fn_IdPuntoFacturacion);
      --
      FETCH C_NombreTipoMedioProd INTO Lv_InformacionServicio;
      --
      CLOSE C_NombreTipoMedioProd;
    END IF;
    --
  ELSIF Fn_TipoInformacion='CORTES' THEN
    --
    IF C_Cortes%ISOPEN THEN
      CLOSE C_Cortes;
    END IF;
    --
    OPEN C_Cortes(Fn_IdPuntoFacturacion);
    --
    FETCH C_Cortes INTO Lv_InformacionServicio;
    --
    CLOSE C_Cortes;

    IF Lv_InformacionServicio = '0' THEN
      IF C_CortesProducto%ISOPEN THEN
        CLOSE C_CortesProducto;
      END IF;
      --
      OPEN C_CortesProducto(Fn_IdPuntoFacturacion);
      --
      FETCH C_CortesProducto INTO Lv_InformacionServicio;
      --
      CLOSE C_CortesProducto;
    END IF;
    --
  ELSIF Fn_TipoInformacion='FE_CANCELACION' THEN
    --
    IF C_FeCancel%ISOPEN THEN
      CLOSE C_FeCancel;
    END IF;
    --
    OPEN C_FeCancel(Fn_IdPuntoFacturacion);
    --
    FETCH C_FeCancel INTO Lv_InformacionServicio;
    --
    CLOSE C_FeCancel;

    IF Lv_InformacionServicio IS NULL THEN
      IF C_FeCancelProducto%ISOPEN THEN
        CLOSE C_FeCancelProducto;
      END IF;
      --
      OPEN C_FeCancelProducto(Fn_IdPuntoFacturacion);
      --
      FETCH C_FeCancelProducto INTO Lv_InformacionServicio;
      --
      CLOSE C_FeCancelProducto;
    END IF;
    --
  ELSIF Fn_TipoInformacion='FE_CORTE' THEN
    --
    IF C_FeCorte%ISOPEN THEN
      CLOSE C_FeCorte;
    END IF;
    --
    OPEN C_FeCorte(Fn_IdPuntoFacturacion);
    --
    FETCH C_FeCorte INTO Lv_InformacionServicio;
    --
    CLOSE C_FeCorte;

    IF Lv_InformacionServicio IS NULL THEN
      IF C_FeCorteProducto%ISOPEN THEN
        CLOSE C_FeCorteProducto;
      END IF;
      --
      OPEN C_FeCorteProducto(Fn_IdPuntoFacturacion);
      --
      FETCH C_FeCorteProducto INTO Lv_InformacionServicio;
      --
      CLOSE C_FeCorteProducto;
    END IF;
    --
  ELSIF Fn_TipoInformacion='FE_ACTIVACION' THEN
    --
    IF C_FeActivacion%ISOPEN THEN
      CLOSE C_FeActivacion;
    END IF;
    --
    OPEN C_FeActivacion(Fn_IdPuntoFacturacion);
    --
    FETCH C_FeActivacion INTO Lv_InformacionServicio;
    --
    CLOSE C_FeActivacion;

    IF Lv_InformacionServicio IS NULL THEN
      IF C_FeActivacionProd%ISOPEN THEN
        CLOSE C_FeActivacionProd;
      END IF;
      --
      OPEN C_FeActivacionProd(Fn_IdPuntoFacturacion);
      --
      FETCH C_FeActivacionProd INTO Lv_InformacionServicio;
      --
      CLOSE C_FeActivacionProd;
    END IF;

    --  
  ELSIF Fn_TipoInformacion='COBERTURA' THEN
    --
    IF C_PuntoDeCobertura%ISOPEN THEN
      CLOSE C_PuntoDeCobertura;
    END IF;
    --
    OPEN C_PuntoDeCobertura(Fn_IdPuntoFacturacion);
    --
    FETCH C_PuntoDeCobertura INTO Lv_InformacionServicio;
    --
    CLOSE C_PuntoDeCobertura;
    --  
  END IF;
  RETURN Lv_InformacionServicio;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_InfoError:='';
    Lv_InfoError:='F_INFORMACION_SERVICIO, Lv_InformacionServicio: '||Lv_InformacionServicio;
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CARTERA CLIENTES', 'FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO', Lv_InfoError);
END;
  --
  --
  FUNCTION F_ESTADO_INTERNET(
        Fn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
        Fv_FeConsultaHasta    IN VARCHAR2)
      RETURN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE
  AS
    --Variable con el estado del servicio
    Lv_EstadoHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ESTADO%TYPE;
    --
    --Variable con el id del historial del servicio
    Ln_IdServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE;
    --
    --Consulta el mínimo historial del servicio de INTERNET dependiendo del plan asociado
    CURSOR C_GetMinHistorialByPlan( Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, 
                                    Cv_Estado DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE, 
                                    Cv_FeConsultaHasta VARCHAR2 )
    IS
      SELECT
        T_HISTORIAL.ID_SERVICIO_HISTORIAL
      FROM
        (
          SELECT
            ISH.ID_SERVICIO_HISTORIAL
          FROM
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
          WHERE
            ISH.SERVICIO_ID =
            (
              SELECT
                MAX(ISER.ID_SERVICIO)
              FROM
                DB_COMERCIAL.INFO_SERVICIO ISER
              LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD
              ON
                IPD.PLAN_ID = ISER.PLAN_ID
              LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP
              ON
                AP.ID_PRODUCTO = IPD.PRODUCTO_ID
              WHERE
                ISER.PUNTO_FACTURACION_ID = Cn_IdPuntoFacturacion
              AND AP.CODIGO_PRODUCTO      = 'INTD'
              AND ISER.ESTADO             = NVL2(Cv_Estado, Cv_Estado, ISER.ESTADO)
            )
        AND ISH.FE_CREACION < NVL2( Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                    CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1 )
        ORDER BY
          ISH.FE_CREACION DESC
        )
        T_HISTORIAL
      WHERE
        ROWNUM = 1;
    --
    --Consulta el mínimo historial del servicio de INTERNET dependiendo del producto asociado
    CURSOR C_GetMinHistorialByProducto( Cn_IdPuntoFacturacion DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, 
                                        Cv_Estado DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE, 
                                        Cv_FeConsultaHasta VARCHAR2 )
    IS
      SELECT
        T_HISTORIAL.ID_SERVICIO_HISTORIAL
      FROM
        (
          SELECT
            ISH.ID_SERVICIO_HISTORIAL
          FROM
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
          WHERE
            ISH.SERVICIO_ID =
            (
              SELECT
                MAX(ISER.ID_SERVICIO)
              FROM
                DB_COMERCIAL.INFO_SERVICIO ISER
              LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP
              ON
                AP.ID_PRODUCTO = ISER.PRODUCTO_ID
              WHERE
                ISER.PUNTO_FACTURACION_ID = Cn_IdPuntoFacturacion
              AND AP.CODIGO_PRODUCTO      = 'INTD'
              AND ISER.ESTADO             = NVL2(Cv_Estado, Cv_Estado, ISER.ESTADO)
            )
        AND ISH.FE_CREACION < NVL2( Cv_FeConsultaHasta, CAST(TO_DATE(Cv_FeConsultaHasta, 'DD-MM-YYYY') AS TIMESTAMP WITH LOCAL TIME ZONE)+1,
                                    CAST(SYSDATE AS TIMESTAMP WITH LOCAL TIME ZONE)+1 )
        ORDER BY
          ISH.FE_CREACION DESC
        ) 
        T_HISTORIAL
      WHERE
        ROWNUM = 1;
    --
    --Consulta para la revision del plan por estado Activo, In-Corte, Cancel, Trasladado
    CURSOR C_GetEstadoByHistorial( Cn_IdServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE )
    IS
      SELECT
        ESTADO
      FROM
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
      WHERE
        ID_SERVICIO_HISTORIAL = Cn_IdServicioHistorial;
    --
  BEGIN
    --
    /*
      Se busca segun el siguiente orden, para planes| para productos debe ser igual:
      1. Activo
      2. In-corte
      3. Cancel
      4. Cualquier estado existente
    */
    --Obtener Historial por los planes del servicio
    IF C_GetMinHistorialByPlan%ISOPEN THEN
      CLOSE C_GetMinHistorialByPlan;
    END IF;
    --
    --Obtener Historial por los productos del servicio
    IF C_GetMinHistorialByProducto%ISOPEN THEN
      CLOSE C_GetMinHistorialByProducto;
    END IF;
    --
    --
    OPEN C_GetMinHistorialByPlan(Fn_IdPuntoFacturacion, 'Activo', Fv_FeConsultaHasta);
    --
    FETCH C_GetMinHistorialByPlan INTO Ln_IdServicioHistorial;
    --
    CLOSE C_GetMinHistorialByPlan;
    --
    IF Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 THEN
      --
      OPEN C_GetMinHistorialByPlan(Fn_IdPuntoFacturacion, 'In-Corte', Fv_FeConsultaHasta);
      --
      FETCH C_GetMinHistorialByPlan INTO Ln_IdServicioHistorial;
      --
      CLOSE C_GetMinHistorialByPlan;
      --
      IF Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 THEN
        --
        OPEN C_GetMinHistorialByPlan(Fn_IdPuntoFacturacion, 'Cancel', Fv_FeConsultaHasta);
        --
        FETCH C_GetMinHistorialByPlan INTO Ln_IdServicioHistorial;
        --
        CLOSE C_GetMinHistorialByPlan;
        --
        IF Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 THEN
          --
          OPEN C_GetMinHistorialByPlan(Fn_IdPuntoFacturacion, NULL, Fv_FeConsultaHasta);
          --
          FETCH C_GetMinHistorialByPlan INTO Ln_IdServicioHistorial;
          --
          CLOSE C_GetMinHistorialByPlan;
          --
          IF Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 THEN --Busqueda por productos
            --
            OPEN C_GetMinHistorialByProducto(Fn_IdPuntoFacturacion, 'Activo', Fv_FeConsultaHasta);
            --
            FETCH C_GetMinHistorialByProducto INTO Ln_IdServicioHistorial;
            --
            CLOSE C_GetMinHistorialByProducto;
            --
            IF Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 THEN --Busqueda por productos
              --
              OPEN C_GetMinHistorialByProducto(Fn_IdPuntoFacturacion, 'In-Corte', Fv_FeConsultaHasta);
              --
              FETCH C_GetMinHistorialByProducto INTO Ln_IdServicioHistorial;
              --
              CLOSE C_GetMinHistorialByProducto;
              --
              IF Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 THEN --Busqueda por productos
                --
                OPEN C_GetMinHistorialByProducto(Fn_IdPuntoFacturacion, 'Cancel', Fv_FeConsultaHasta);
                --
                FETCH C_GetMinHistorialByProducto INTO Ln_IdServicioHistorial;
                --
                CLOSE C_GetMinHistorialByProducto;
                --
                IF Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 THEN --Busqueda por productos cualquier estado
                  --
                  OPEN C_GetMinHistorialByProducto(Fn_IdPuntoFacturacion, NULL, Fv_FeConsultaHasta);
                  --
                  FETCH C_GetMinHistorialByProducto INTO Ln_IdServicioHistorial;
                  --
                  CLOSE C_GetMinHistorialByProducto;
                  --
                END IF;--Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 (Cancel - Producto)
              --
              END IF;--Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 (In-Corte - Producto)
            --
            END IF;--Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 (Activo - Producto)
          --
          END IF;--Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 (Cualquier estado - Plan)
        --
        END IF;--Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 (Cancel - Plan)
      --
      END IF;--Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 (In-Corte - Plan)
      --
    END IF;--Ln_IdServicioHistorial IS NULL OR Ln_IdServicioHistorial = 0 (Activo - Plan)
    --
    --
    IF Ln_IdServicioHistorial IS NOT NULL AND Ln_IdServicioHistorial > 0 THEN
      --
      IF C_GetEstadoByHistorial%ISOPEN THEN
        CLOSE C_GetEstadoByHistorial;
      END IF;
      --
      --
      OPEN C_GetEstadoByHistorial(Ln_IdServicioHistorial);
      --
      FETCH C_GetEstadoByHistorial INTO Lv_EstadoHistorial;
      --
      CLOSE C_GetEstadoByHistorial;
      --
    END IF;
    --
    --
    RETURN Lv_EstadoHistorial;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_EstadoHistorial := '';
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNCK_CONSULTS.P_DOCUMENTOS_RELACIONADOS', 
                                          'Error en FNKG_CARTERA_CLIENTES.F_ESTADO_INTERNET - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                                          || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    RETURN Lv_EstadoHistorial;
    --
  END F_ESTADO_INTERNET;
  --
  --
FUNCTION GET_ADITIONAL_DATA_BYPUNTO(
    Fn_IdPunto  IN INFO_PUNTO.ID_PUNTO%TYPE,
    Fv_TipoData IN ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_DatoContacto(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_TipoData ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  IS
  WITH FORMA_CONTACTO_TELF AS
    (
        SELECT LISTAGG(NVL(CONTACTO, NULL), ',') WITHIN GROUP (ORDER BY NVL(CONTACTO, NULL)) CONTACTO
        FROM (SELECT REGEXP_REPLACE(IPFC.VALOR, '[^[:digit:]|;]', '') CONTACTO
                FROM INFO_PUNTO IP,
                  INFO_PERSONA_EMPRESA_ROL IPER,
                  INFO_PERSONA IPR,
                  INFO_PERSONA_FORMA_CONTACTO IPFC,
                  ADMI_FORMA_CONTACTO AFC
                WHERE IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
                AND IPER.PERSONA_ID             = IPR.ID_PERSONA
                AND IPR.ID_PERSONA              = IPFC.PERSONA_ID
                AND IPFC.FORMA_CONTACTO_ID      = AFC.ID_FORMA_CONTACTO
                AND IPFC.ESTADO                 = 'Activo'
                AND AFC.CODIGO                 IN
                  (SELECT CODIGO FROM ADMI_FORMA_CONTACTO WHERE DESCRIPCION_FORMA_CONTACTO LIKE 'Telefono%')
                AND IP.ID_PUNTO = Cn_IdPunto
                UNION
                SELECT REGEXP_REPLACE(IPFC.VALOR, '[^[:digit:]|;]', '') CONTACTO
                FROM INFO_PUNTO_FORMA_CONTACTO IPFC,
                     ADMI_FORMA_CONTACTO AFC
                WHERE IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
                AND AFC.CODIGO              IN
                  (SELECT CODIGO FROM ADMI_FORMA_CONTACTO WHERE DESCRIPCION_FORMA_CONTACTO LIKE 'Telefono%')
                AND IPFC.ESTADO   = 'Activo'
                AND IPFC.PUNTO_ID = Cn_IdPunto)
    )
    SELECT LISTAGG(REPLACE(REPLACE(CONTACTO, '  ', ''), ' ', ''), ';') WITHIN GROUP (
    ORDER BY CONTACTO) CONTACTO
    FROM FORMA_CONTACTO_TELF;

  CURSOR C_DatoContactoAdicional(Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE, Cv_TipoData ADMI_FORMA_CONTACTO.CODIGO%TYPE)
  IS
  WITH FORMA_CONTACTO_FONO AS
    ( SELECT LISTAGG( NVL(TELEFONO_ENVIO, NULL) , ',') WITHIN GROUP (
      ORDER BY TELEFONO_ENVIO) CONTACTO
      FROM INFO_PUNTO_DATO_ADICIONAL
      WHERE PUNTO_ID = Cn_IdPunto
    )
    SELECT LISTAGG(REPLACE(REPLACE(CONTACTO, '  ', ''), ' ', ''), ';') WITHIN GROUP (
    ORDER BY CONTACTO) CONTACTO
    FROM FORMA_CONTACTO_FONO;
  --
  Lv_Data VARCHAR2(2000) := '';
  --
BEGIN
  --
  IF C_DatoContacto%ISOPEN THEN
    --
    CLOSE C_DatoContacto;
    --
  END IF;

  IF C_DatoContactoAdicional%ISOPEN THEN
    --
    CLOSE C_DatoContactoAdicional;
    --
  END IF;
  --
  OPEN C_DatoContacto( Fn_IdPunto, Fv_TipoData);
  --
  FETCH C_DatoContacto INTO Lv_Data;
  --
    --
  IF Lv_Data IS NULL THEN

    OPEN C_DatoContactoAdicional( Fn_IdPunto, Fv_TipoData);
      --
    FETCH C_DatoContactoAdicional INTO Lv_Data;

    IF Lv_Data IS NULL THEN
      --
      Lv_Data := '';
      --
    END IF;  

  END IF;
  --
  Lv_Data := SUBSTR(Lv_Data,1,1900);

  RETURN Lv_Data;
  --
EXCEPTION
WHEN OTHERS THEN
  FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION ELECTRONICA', 'FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO', SUBSTR(SQLERRM,1,500));
END GET_ADITIONAL_DATA_BYPUNTO;
--
--
PROCEDURE P_CARTERA_POR_FACTURA(
    Pv_Empresa         IN INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_FeConsultaHasta IN VARCHAR2,
    C_GetClientes      OUT P_ClientesCartera)
AS 
  BEGIN
  OPEN C_GetClientes FOR 
    SELECT
    idfc.ID_DOCUMENTO,
    atr.DESCRIPCION_TIPO_ROL,
    ARE.NOMBRE_REGION,
    NVL2(Pv_FeConsultaHasta, TO_DATE(Pv_FeConsultaHasta,'DD-MM-YY'), SYSDATE) as fecha_reporte,
    ipe.tipo_identificacion,
    ipe.identificacion_cliente,
    FNCK_CONSULTS.F_GET_NOMBRE_COMPLETO_CLIENTE(ip.id_punto) as nombre_cliente,
    iper.ESTADO as estado_cliente,
    FNCK_COM_ELECTRONICO.GET_NUM_CONTRATO(iper.ID_PERSONA_ROL,iper.ESTADO) AS NUMERO_CONTRATO,
    CASE
      WHEN iper.ESTADO='Cancelado' THEN FNKG_CARTERA_CLIENTES.F_CONTRATO_CANCELADO(iper.ID_PERSONA_ROL)
      ELSE FNCK_COM_ELECTRONICO.GET_CANTON_FORMA_PAGO(iper.ID_PERSONA_ROL,NULL) 
    END AS FORMA_PAGO,
    iog.nombre_oficina,  
    atn.codigo_tipo_negocio,
    atn.nombre_tipo_negocio,
    ip.login,
    NVL(DB_FINANCIERO.FNCK_CONSULTS.F_ESTADO_PUNTO(IP.ID_PUNTO, Pv_FeConsultaHasta), IP.ESTADO) AS ESTADO_PUNTO,
    FNKG_CARTERA_CLIENTES.F_ESTADO_INTERNET(ip.id_punto, Pv_FeConsultaHasta) AS estado_internet,
    idfc.fe_emision AS FE_EMISION,
    idfc.numero_factura_sri as factura,
    (SELECT AC.NOMBRE_CICLO
      FROM DB_COMERCIAL.ADMI_CICLO AC,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IP,
           DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
      WHERE IP.PERSONA_EMPRESA_ROL_ID=iper.ID_PERSONA_ROL
      AND ACAR.ID_CARACTERISTICA=IP.CARACTERISTICA_ID
      AND ACAR.DESCRIPCION_CARACTERISTICA='CICLO_FACTURACION'
      AND IP.ESTADO='Activo'
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IP.VALOR,'^\d+')),0) = AC.ID_CICLO 
      AND ROWNUM = 1) AS CICLO,
    round(idfc.valor_total,2) as valor_total,
    FNCK_CONSULTS.F_GET_DIFERENCIAS_FECHAS(TO_CHAR(idfc.fe_emision,'DD-MM-YYYY'),NVL(Pv_FeConsultaHasta, TO_CHAR(SYSDATE,'DD-MM-YYYY'))) as dias,
    ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'saldo'),2) as saldo,
    ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'PAG'),2) as TOTAL_PAGOS,
    ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'TOTAL_NC'),2) as TOTAL_NC,
    ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'NDI'),2) as TOTAL_NDI,
    TRIM(SUBSTR(FNKG_CARTERA_CLIENTES.GET_ADITIONAL_DATA_BYPUNTO(ip.id_punto,'FONO'),1,500)) as telefonos,
    FNCK_COM_ELECTRONICO.GET_DIRECCION_ENVIO(ip.id_punto) as direccion,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO('COBERTURA',ip.id_punto) as ciudad,
    FNKG_CARTERA_CLIENTES.F_NOMBRE_VENDEDOR(ip.usr_vendedor) as vendedor,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO('ELEMENTO',ip.id_punto) as elemento,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO('TIPO_MEDIO',ip.id_punto) as tipo_medio,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO('CORTES',ip.id_punto) as numero_cortes,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO('FE_CANCELACION',ip.id_punto) as fe_cancelacion,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO('FE_CORTE',ip.id_punto) as fe_corte,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO('FE_ACTIVACION',ip.id_punto) as fe_activacion,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO('DESCRIPCION_BANCO',iper.ID_PERSONA_ROL) as descripcion_banco,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO('DESCRIPCION_TIPO_CUENTA',iper.ID_PERSONA_ROL) as descripcion_cuenta,
    FNKG_CARTERA_CLIENTES.F_NOMBRE_EJECUTIVO_COBRANZAS(ip.usr_cobranzas) as EJECUTIVO_COBRANZAS,
    FNKG_CARTERA_CLIENTES.F_GET_DEBITO(iper.ID_PERSONA_ROL, 'motivo', 'Rechazado') as MOTIVO_RECHAZO_DEBITO,
    FNKG_CARTERA_CLIENTES.F_GET_DEBITO(iper.ID_PERSONA_ROL, 'feCreacion', 'Rechazado') as FE_RECHAZO_DEBITO,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO('TRAMITE_LEGAL', IPER.ID_PERSONA_ROL) AS TRAMITE_LEGAL,
    FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO('TIEMPO_MESES_CORTE',iper.ID_PERSONA_ROL) as TIEMPO_MESES_CORTE
    from db_financiero.INFO_DOCUMENTO_FINANCIERO_CAB idfc
    join db_financiero.admi_tipo_documento_financiero atdf on atdf.id_tipo_documento=idfc.tipo_documento_id
    join DB_COMERCIAL.info_punto ip on ip.id_punto=idfc.punto_id
    --NUEVO
    JOIN DB_GENERAL.ADMI_SECTOR ASE ON ASE.ID_SECTOR=ip.SECTOR_ID
    JOIN DB_GENERAL.ADMI_PARROQUIA AP ON AP.ID_PARROQUIA=ASE.PARROQUIA_ID
    JOIN DB_GENERAL.ADMI_CANTON AC ON AC.ID_CANTON=AP.CANTON_ID
    JOIN DB_GENERAL.ADMI_PROVINCIA APR ON APR.ID_PROVINCIA=AC.PROVINCIA_ID
    JOIN DB_GENERAL.ADMI_REGION ARE ON ARE.ID_REGION=APR.REGION_ID
    --NUEVO
    join DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper on iper.ID_PERSONA_ROL=ip.PERSONA_EMPRESA_ROL_ID
    join DB_COMERCIAL.INFO_PERSONA ipe on ipe.id_persona=iper.persona_id
    join DB_COMERCIAL.INFO_OFICINA_GRUPO iog on iog.ID_OFICINA=iper.OFICINA_ID
    JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO atn on atn.ID_TIPO_NEGOCIO=ip.TIPO_NEGOCIO_ID
    join DB_COMERCIAL.INFO_EMPRESA_ROL ier on ier.id_empresa_rol=iper.EMPRESA_ROL_ID
    join DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg on ieg.COD_EMPRESA=ier.EMPRESA_COD
    join DB_GENERAL.admi_rol ar on ar.id_rol=ier.ROL_ID
    join DB_GENERAL.admi_tipo_rol atr on atr.ID_TIPO_ROL=ar.TIPO_ROL_ID
    WHERE idfc.estado_impresion_fact IN
  (SELECT APD.VALOR1
  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
  JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
  ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
  WHERE APD.ESTADO         = 'Activo'
  AND APC.ESTADO           = 'Activo'
  AND APC.NOMBRE_PARAMETRO = 'REPORTE_CARTERA'
  AND APD.DESCRIPCION      = 'ESTADO_DOCUMENTOS'
  AND APD.VALOR2           = 'FACTURAS'
  ) AND ( ( atdf.CODIGO_TIPO_DOCUMENTO IN
      (SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
      WHERE APD.ESTADO           = 'Activo'
      AND APC.ESTADO             = 'Activo'
      AND APC.NOMBRE_PARAMETRO   = 'REPORTE_CARTERA'
      AND APD.DESCRIPCION        = 'DOCUMENTOS_NORMALES'
      AND APD.VALOR2             = 'FACTURAS'
      ) 
      AND idfc.FE_EMISION < NVL2(Pv_FeConsultaHasta, TO_DATE(Pv_FeConsultaHasta,'DD-MM-YY')+1, TO_DATE(SYSDATE+1,'DD-MM-YY'))
       )
     OR idfc.ID_DOCUMENTO IN
    (SELECT IDFC_S.ID_DOCUMENTO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_S
    JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD_S
    ON IDFD_S.DOCUMENTO_ID = IDFC_S.ID_DOCUMENTO
    JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_S
    ON ATDF_S.ID_TIPO_DOCUMENTO         = IDFC_S.TIPO_DOCUMENTO_ID
    WHERE IDFC_S.ESTADO_IMPRESION_FACT IN
      (SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
      WHERE APD.ESTADO         = 'Activo'
      AND APC.ESTADO           = 'Activo'
      AND APC.NOMBRE_PARAMETRO = 'REPORTE_CARTERA'
      AND APD.DESCRIPCION      = 'ESTADO_DOCUMENTOS'
      AND APD.VALOR2           = 'FACTURAS'
      )
    AND ATDF_S.CODIGO_TIPO_DOCUMENTO IN
      (SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
      ON APD.PARAMETRO_ID      = APC.ID_PARAMETRO
      WHERE APD.ESTADO         = 'Activo'
      AND APC.ESTADO           = 'Activo'
      AND APC.NOMBRE_PARAMETRO = 'REPORTE_CARTERA'
      AND APD.DESCRIPCION      = 'DOCUMENTOS_ESPECIALES'
      )
    AND IDFD_S.PAGO_DET_ID    IS NULL
    AND IDFC_S.FE_EMISION < NVL2(Pv_FeConsultaHasta, TO_DATE(Pv_FeConsultaHasta,'DD-MM-YY')+1, TO_DATE(SYSDATE+1,'DD-MM-YY'))
    ) ) AND ieg.prefijo        = Pv_Empresa
    group by 
    idfc.ID_DOCUMENTO,
    atr.DESCRIPCION_TIPO_ROL,
    ARE.NOMBRE_REGION,
    ipe.tipo_identificacion,
    ipe.identificacion_cliente,
    iper.ESTADO,
    iog.nombre_oficina,
    atn.codigo_tipo_negocio,
    atn.nombre_tipo_negocio,
    ip.login,
    ip.estado,
    idfc.fe_emision,
    idfc.fe_autorizacion,
    idfc.numero_factura_sri,
    ip.id_punto,
    iper.ID_PERSONA_ROL,
    iper.ESTADO,
    idfc.valor_total,
    idfc.ID_DOCUMENTO,
    ip.usr_vendedor,
    ip.usr_cobranzas,
    ARE.ID_REGION
    HAVING ROUND( DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA( idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'saldo' ), 2 ) <> 0
    ORDER BY ARE.NOMBRE_REGION,iog.nombre_oficina,ipe.identificacion_cliente,idfc.numero_factura_sri;
END P_CARTERA_POR_FACTURA;
--
--
/*
 * Documentación para FUNCION 'F_NOMBRE_EJECUTIVO_COBRANZAS'.
 * Funcion que permite obtener el nombre del ejecutivo de cobranzas asociado al punto cliente.
 *
 * PARAMETROS:
 * @Param varchar2 usr_cobranzas (login del ejecutivo de cobranzas)
 * @return varchar2 nombre (nombre completo del ejecutivo de cobranzas)
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 23-06-2016
 */
FUNCTION F_NOMBRE_EJECUTIVO_COBRANZAS(usr_cobranzas IN INFO_PUNTO.USR_COBRANZAS%TYPE) RETURN VARCHAR2 
IS 
  Fn_NombreCompleto INFO_PERSONA.RAZON_SOCIAL%TYPE;
BEGIN
  SELECT 
      CASE
      WHEN razon_social is null then concat(concat(nombres,' '),apellidos)
      ELSE razon_social
      END AS nombre_ejecutivo_cobranzas
      INTO Fn_NombreCompleto
  FROM INFO_PERSONA
  WHERE LOGIN = usr_cobranzas
  AND ROWNUM=1;
  RETURN(Fn_NombreCompleto);
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
  RETURN NULL;
END;
--
--
--
/*
 * Documentación para FUNCION 'F_GET_DEBITO'.
 * Funcion que permite obtener información del debito de un cliente.
 *
 * PARAMETROS:
 * @Param integer    Pn_IdPersonaEmpresaRol (idPersonaEmpresaRol del cliente)
 * @Param varchar2   Pv_Columna             (columna a obtener)
 * @Param varchar2   Pv_EstadoDebito        (estado del debito)
 *
 * @return varchar2  Fv_Resutado           (resultado obtenido de la función)
 *
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.0 - 27-06-2016
 * @author Edson Franco <efranco@telconet.ec>
 * @version 1.1 - 01-07-2016 - Se quitan unas comillas que hacen que el paquete no compile correctamente.
 */
FUNCTION F_GET_DEBITO( Pn_IdPersonaEmpresaRol IN INFO_PUNTO.ID_PUNTO%TYPE,
                       Pv_Columna             IN VARCHAR2,
                       Pv_EstadoDebito        IN VARCHAR2 )
RETURN VARCHAR2 
IS
--
    --
    Fv_Resutado VARCHAR2(300)                                     := '';
    Ln_IdDebito DB_FINANCIERO.INFO_DEBITO_DET.ID_DEBITO_DET%TYPE  := 0;
    --
--
BEGIN
--
    --
    SELECT NVL(
                  (
                      SELECT MAX(idd.ID_DEBITO_DET)
                      FROM DB_FINANCIERO.INFO_DEBITO_DET idd
                      WHERE idd.PERSONA_EMPRESA_ROL_ID = Pn_IdPersonaEmpresaRol
                        AND idd.ESTADO = Pv_EstadoDebito
                  ), NULL
              ) INTO Ln_IdDebito
    FROM DUAL;
    --
    --
    --
    IF Ln_IdDebito IS NOT NULL THEN
    --
        --
        CASE
        --
            --
            WHEN Pv_Columna = 'motivo' THEN
            --
                --
                SELECT NVL(
                              (
                                  SELECT idd.OBSERVACION_RECHAZO
                                  FROM DB_FINANCIERO.INFO_DEBITO_DET idd
                                  WHERE idd.ID_DEBITO_DET = Ln_IdDebito
                              ), ''
                          ) INTO Fv_Resutado
                FROM DUAL;
                --
            --
            WHEN Pv_Columna = 'feCreacion' THEN
            --
                --
                SELECT NVL(
                              (
                                  SELECT TO_CHAR(idd.FE_ULT_MOD, 'DD/MM/YYYY')
                                  FROM DB_FINANCIERO.INFO_DEBITO_DET idd
                                  WHERE idd.ID_DEBITO_DET = Ln_IdDebito
                              ), 
                              (
                                  SELECT TO_CHAR(idd.FE_CREACION, 'DD/MM/YYYY')
                                  FROM DB_FINANCIERO.INFO_DEBITO_DET idd
                                  WHERE idd.ID_DEBITO_DET = Ln_IdDebito
                              )
                          ) INTO Fv_Resutado
                FROM DUAL;
                --
            --
        --
        END CASE;
        --
    --
    END IF;
    --
    --
    --
    RETURN Fv_Resutado;
    --
--
END;

PROCEDURE P_EJEC_REP_CART_ANTIC_MD
AS

  CURSOR C_RepDisponibles
  IS
    SELECT APD.ID_PARAMETRO_DET,
      APD.PARAMETRO_ID,
      APD.DESCRIPCION,
      APD.EMPRESA_COD,
      APD.ESTADO,
      APD.VALOR1,
      APD.VALOR2,
      APD.VALOR3,
      APD.VALOR4,
      APD.VALOR5
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
      DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
    AND APC.ESTADO             = NVL('Activo', APC.ESTADO )
    AND APD.ESTADO             = NVL('Activo', APD.ESTADO )
    AND APC.NOMBRE_PARAMETRO   = NVL('REPORTE_CARTERA', APC.NOMBRE_PARAMETRO )
    AND APD.DESCRIPCION        = NVL('REPORTES_DISPONIBLES', APD.DESCRIPCION )
    AND APD.VALOR1             = NVL('', APD.VALOR1 )
    AND APD.VALOR2             = NVL('', APD.VALOR2 )
    AND APD.VALOR3             = NVL('', APD.VALOR3)
    AND APD.VALOR4             = NVL('', APD.VALOR4)
    AND APD.VALOR5             = NVL('', APD.VALOR5)
    AND APD.EMPRESA_COD        = NVL(
      (SELECT COD_EMPRESA
        FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO
        WHERE ESTADO = 'Activo'
        AND PREFIJO  = 'MD'
      ), APD.EMPRESA_COD)
    ORDER BY APD.VALOR4;

  CURSOR C_ClienteCartera(Pv_Empresa VARCHAR2,Pv_FeConsultaHasta VARCHAR2)
  IS
    --
    WITH TMP_ESTADO
        AS (SELECT TO_CHAR (APD.VALOR1) AS VAL_ESTADO
            FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                 DB_GENERAL.ADMI_PARAMETRO_CAB APC
            WHERE APD.ESTADO = 'Activo'
            AND APC.ESTADO = 'Activo'
            AND APC.NOMBRE_PARAMETRO = 'REPORTE_CARTERA'
            AND APD.DESCRIPCION = 'ESTADO_DOCUMENTOS'
            AND APD.VALOR2 = 'FACTURAS'
            AND APD.PARAMETRO_ID = APC.ID_PARAMETRO),
        TMP_ESTADO_1
        AS (SELECT TO_CHAR (APD.VALOR1) AS VAL_ESTADO
              FROM    DB_GENERAL.ADMI_PARAMETRO_DET APD
                   JOIN
                      DB_GENERAL.ADMI_PARAMETRO_CAB APC
                   ON APD.PARAMETRO_ID = APC.ID_PARAMETRO
             WHERE     APD.ESTADO = 'Activo'
                   AND APC.ESTADO = 'Activo'
                   AND APC.NOMBRE_PARAMETRO = 'REPORTE_CARTERA'
                   AND APD.DESCRIPCION = 'DOCUMENTOS_NORMALES'
                   AND APD.VALOR2 = 'FACTURAS'),
        TMP_ESTADO_2
        AS (SELECT TO_CHAR (APD.VALOR1) AS VAL_ESTADO
              FROM    DB_GENERAL.ADMI_PARAMETRO_DET APD
                   JOIN
                      DB_GENERAL.ADMI_PARAMETRO_CAB APC
                   ON APD.PARAMETRO_ID = APC.ID_PARAMETRO
             WHERE     APD.ESTADO = 'Activo'
                   AND APC.ESTADO = 'Activo'
                   AND APC.NOMBRE_PARAMETRO = 'REPORTE_CARTERA'
                   AND APD.DESCRIPCION = 'DOCUMENTOS_ESPECIALES'),
        TMP_REGION
        AS (SELECT ASE.EMPRESA_COD, ASE.ID_SECTOR, ARE.ID_REGION, ARE.NOMBRE_REGION
            FROM DB_GENERAL.ADMI_SECTOR ASE
            JOIN DB_GENERAL.ADMI_PARROQUIA AP
            ON AP.ID_PARROQUIA = ASE.PARROQUIA_ID
            JOIN DB_GENERAL.ADMI_CANTON AC
            ON AC.ID_CANTON = AP.CANTON_ID
            JOIN DB_GENERAL.ADMI_PROVINCIA APR
            ON APR.ID_PROVINCIA = AC.PROVINCIA_ID
            JOIN DB_GENERAL.ADMI_REGION ARE
            ON ARE.ID_REGION = APR.REGION_ID)

    SELECT     
        idfc.ID_DOCUMENTO,
        atr.DESCRIPCION_TIPO_ROL,
        ARE.NOMBRE_REGION,
        TRUNC(SYSDATE,'DD') AS fecha_reporte,
        ipe.tipo_identificacion,
        ipe.identificacion_cliente,
        INITCAP (
           CASE
              WHEN ipe.RAZON_SOCIAL IS NOT NULL
              THEN
                 ipe.RAZON_SOCIAL
              WHEN ipe.NOMBRES IS NOT NULL AND ipe.APELLIDOS IS NOT NULL
              THEN
                 ipe.NOMBRES || ' ' || ipe.APELLIDOS
              WHEN ipe.REPRESENTANTE_LEGAL IS NOT NULL
              THEN
                 ipe.REPRESENTANTE_LEGAL
           END)  nombre_cliente,
        iper.ESTADO AS estado_cliente,
        FNCK_COM_ELECTRONICO.GET_NUM_CONTRATO (iper.ID_PERSONA_ROL, iper.ESTADO) AS NUMERO_CONTRATO,
        FNKG_CARTERA_CLIENTES.F_GET_FORMA_PAGO (iper.ID_PERSONA_ROL, ip.id_punto) AS FORMA_PAGO,  
        iog.nombre_oficina,
        atn.codigo_tipo_negocio,
        atn.nombre_tipo_negocio,
        ip.login,
        IP.ESTADO AS ESTADO_PUNTO,
        FNKG_CARTERA_CLIENTES.F_ESTADO_INTERNET (ip.id_punto, Pv_FeConsultaHasta)  AS estado_internet,
        idfc.fe_emision AS FE_EMISION,
        idfc.numero_factura_sri AS factura,
        (select AC.NOMBRE_CICLO
          FROM DB_COMERCIAL.ADMI_CICLO AC,
               DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IP,
               DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
          WHERE IP.PERSONA_EMPRESA_ROL_ID=iper.ID_PERSONA_ROL
          AND ACAR.ID_CARACTERISTICA=IP.CARACTERISTICA_ID
          AND ACAR.DESCRIPCION_CARACTERISTICA='CICLO_FACTURACION'
          AND IP.ESTADO='Activo'
          AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IP.VALOR,'^\d+')),0) = AC.ID_CICLO 
          AND ROWNUM = 1) AS CICLO,
        ROUND (idfc.valor_total, 2) AS valor_total,
        FNCK_CONSULTS.F_GET_DIFERENCIAS_FECHAS (TO_CHAR (idfc.fe_emision, 'DD-MM-YYYY'),TO_CHAR (SYSDATE, 'DD-MM-YYYY')) AS dias,
        ROUND (FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'saldo'),2)  AS saldo,
        ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'PAG'),2) as TOTAL_PAGOS,
        ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'TOTAL_NC'),2) as TOTAL_NC,
        ROUND(FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'NDI'),2) as TOTAL_NDI,
        TRIM (SUBSTR ( FNKG_CARTERA_CLIENTES.GET_ADITIONAL_DATA_BYPUNTO (ip.id_punto, 'FONO'),   1, 500))AS telefonos,
        FNCK_COM_ELECTRONICO.GET_DIRECCION_ENVIO (ip.id_punto) AS direccion,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO ('COBERTURA', ip.id_punto)            AS ciudad,
        FNKG_CARTERA_CLIENTES.F_NOMBRE_VENDEDOR (ip.usr_vendedor) AS vendedor,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO ('ELEMENTO', ip.id_punto)            AS elemento,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO ('TIPO_MEDIO', ip.id_punto)            AS tipo_medio,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO ('CORTES', ip.id_punto)            AS numero_cortes,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO ('FE_CANCELACION', ip.id_punto)            AS fe_cancelacion,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO ('FE_CORTE', ip.id_punto)            AS fe_corte,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_SERVICIO ('FE_ACTIVACION', ip.id_punto)            AS fe_activacion,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_BANCO', iper.ID_PERSONA_ROL)            AS descripcion_banco,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ( 'DESCRIPCION_TIPO_CUENTA', iper.ID_PERSONA_ROL)            AS descripcion_cuenta,
        FNKG_CARTERA_CLIENTES.F_NOMBRE_EJECUTIVO_COBRANZAS (ip.usr_cobranzas)            AS EJECUTIVO_COBRANZAS,
        FNKG_CARTERA_CLIENTES.F_GET_DEBITO (iper.ID_PERSONA_ROL, 'motivo', 'Rechazado')            AS MOTIVO_RECHAZO_DEBITO,
        FNKG_CARTERA_CLIENTES.F_GET_DEBITO (iper.ID_PERSONA_ROL, 'feCreacion', 'Rechazado')            AS FE_RECHAZO_DEBITO,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('TRAMITE_LEGAL', IPER.ID_PERSONA_ROL)            AS TRAMITE_LEGAL,
        FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO('TIEMPO_MESES_CORTE',iper.ID_PERSONA_ROL) AS TIEMPO_MESES_CORTE
    FROM db_financiero.INFO_DOCUMENTO_FINANCIERO_CAB idfc
    JOIN db_financiero.admi_tipo_documento_financiero atdf
    ON atdf.id_tipo_documento = idfc.tipo_documento_id
    JOIN DB_COMERCIAL.info_punto ip
    ON ip.id_punto = idfc.punto_id
    --NUEVO
    JOIN TMP_REGION ARE
    ON ARE.ID_SECTOR = IP.SECTOR_ID
    --NUEVO
    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL iper
    ON iper.ID_PERSONA_ROL = ip.PERSONA_EMPRESA_ROL_ID
    JOIN DB_COMERCIAL.INFO_PERSONA ipe
    ON ipe.id_persona = iper.persona_id
    JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO iog
    ON iog.ID_OFICINA = iper.OFICINA_ID
    JOIN DB_COMERCIAL.ADMI_TIPO_NEGOCIO atn
    ON atn.ID_TIPO_NEGOCIO = ip.TIPO_NEGOCIO_ID
    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ier
    ON ier.id_empresa_rol = iper.EMPRESA_ROL_ID
    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO ieg
    ON ieg.COD_EMPRESA = ier.EMPRESA_COD
    JOIN DB_GENERAL.admi_rol ar
    ON ar.id_rol = ier.ROL_ID
    JOIN DB_GENERAL.admi_tipo_rol atr
    ON atr.ID_TIPO_ROL = ar.TIPO_ROL_ID
    WHERE   IDFC.TIPO_DOCUMENTO_ID in (1,5,9)
    AND EXISTS
      (SELECT 1
         FROM TMP_ESTADO
        WHERE VAL_ESTADO = idfc.estado_impresion_fact)
    AND ( (EXISTS
             (SELECT 1
                FROM TMP_ESTADO_1
               WHERE VAL_ESTADO = atdf.CODIGO_TIPO_DOCUMENTO)
          AND idfc.FE_EMISION < SYSDATE + 1)
        OR (EXISTS
               (SELECT 1
                  FROM TMP_ESTADO_2
                 WHERE VAL_ESTADO = atdf.CODIGO_TIPO_DOCUMENTO)
            AND idfc.FE_EMISION < SYSDATE + 1
            AND EXISTS
                   (SELECT 1
                      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
                     WHERE IDFD.PAGO_DET_ID IS NULL
                           AND IDFD.DOCUMENTO_ID = idfc.ID_DOCUMENTO)))
    AND ieg.prefijo = Pv_Empresa
    GROUP BY IDFC.ID_DOCUMENTO,
         ATR.DESCRIPCION_TIPO_ROL,
         ARE.NOMBRE_REGION,
         IPE.TIPO_IDENTIFICACION,
         IPE.IDENTIFICACION_CLIENTE,
         IPER.ESTADO,
         IOG.NOMBRE_OFICINA,
         ATN.CODIGO_TIPO_NEGOCIO,
         ATN.NOMBRE_TIPO_NEGOCIO,
         IP.LOGIN,
         IP.ESTADO,
         IDFC.FE_EMISION,
         IDFC.FE_AUTORIZACION,
         IDFC.NUMERO_FACTURA_SRI,
         IP.ID_PUNTO,
         IPER.ID_PERSONA_ROL,
         IDFC.VALOR_TOTAL,
         IP.USR_VENDEDOR,
         IP.USR_COBRANZAS,
         IPE.RAZON_SOCIAL,
         IPE.NOMBRES,
         IPE.APELLIDOS,
         IPE.REPRESENTANTE_LEGAL
    HAVING ROUND (FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA (idfc.ID_DOCUMENTO, Pv_FeConsultaHasta, 'saldo'), 2) > 0;

  CURSOR C_Directory(Pv_Directorio VARCHAR2) IS
    SELECT DIRECTORY_PATH
    FROM ALL_DIRECTORIES 
    WHERE UPPER(DIRECTORY_NAME) = Pv_Directorio;

  --Costo 5
  CURSOR C_RUTA_IP 
  IS 
  SELECT VALOR2 FROM db_general.admi_parametro_DET WHERE PARAMETRO_ID = (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'REPORTE_CARTERA'
    ) 
  AND DESCRIPCION = 'RUTA_NFS';   

  --Costo 4
  CURSOR C_RUTA_ARCHIVO_NFS
  IS
  SELECT CODIGO_APP ,CODIGO_PATH 
  FROM DB_FINANCIERO.ADMI_GESTION_DIRECTORIOS
  WHERE APLICACION ='TelcosWeb' AND SUBMODULO ='ReporteCartera' AND EMPRESA ='MD';

  Lv_NomArchivo    VARCHAR2(200) := '';
  Lv_NomArchivoGz  VARCHAR2(300) := '';
  Lv_NomArchivoZip VARCHAR2(300) := '';
  Lv_Prefijo       VARCHAR2(10)  := 'MD';
  Lv_FecReporte    VARCHAR2(50)  := TO_CHAR(SYSDATE,'YYYY-MM-DD');
  Lv_DirCsv        VARCHAR2(500) := 'DIR_REPOSITORIO_ARCHIVO';
  Lv_DirCsvFinal   VARCHAR2(500) := 'DIR_REPCARTERA_ANTICIPO';
  Lv_Delimitador   VARCHAR2(10)  := ';';
  Ln_Dias30        NUMBER        := 0;
  Ln_Dias60        NUMBER        := 0;
  Ln_Dias90        NUMBER        := 0;
  Ln_Dias120       NUMBER        := 0;
  Ln_DiasMas       NUMBER        := 0;
  Lv_Gzip          VARCHAR2(100) := '';
  Lv_FecFiltro     VARCHAR2(100) := '';
  Lv_reponse       VARCHAR2(800) := '';
  Lv_Comparacion   VARCHAR2(10) := '';
  Lv_UrlNfs        VARCHAR2(150) := '';
  Lv_CodigoApp       VARCHAR2(150) := '';
  Lv_CodigoPath        VARCHAR2(150) := '';

  Lrf_ClientesCartera  SYS_REFCURSOR;
  Lrf_ClientesAnticip  SYS_REFCURSOR;
  Lc_Directory         C_Directory%ROWTYPE;

  TYPE Lr_ClientesC IS TABLE OF FNKG_CARTERA_CLIENTES.Lr_InfoCarteraCliente INDEX BY PLS_INTEGER;
  Lr_ClientesCartera Lr_ClientesC;

  TYPE Lr_ClientesA IS TABLE OF FNKG_CARTERA_CLIENTES.Lr_InfoAnticiposCliente INDEX BY PLS_INTEGER;
  Lr_ClientesAnticip Lr_ClientesA;

  LFile_Archivo UTL_FILE.FILE_TYPE;
  Lb_FileOpen   BOOLEAN := FALSE;

BEGIN

  OPEN C_Directory(Lv_DirCsv);
  FETCH C_Directory INTO Lc_Directory;
  CLOSE C_Directory;


  OPEN C_RUTA_IP;
  FETCH C_RUTA_IP INTO Lv_UrlNfs;
  CLOSE C_RUTA_IP;

  OPEN C_RUTA_ARCHIVO_NFS;
  FETCH C_RUTA_ARCHIVO_NFS INTO Lv_CodigoApp,Lv_CodigoPath;
  CLOSE C_RUTA_ARCHIVO_NFS;


  FOR Lc_RepDisponibles IN C_RepDisponibles LOOP
    Lv_NomArchivo    := 'reporte'||Lc_RepDisponibles.VALOR1||Lv_Prefijo||'-'||Lv_FecReporte||'.csv';
    Lv_NomArchivoGz  := Lv_NomArchivo||'.gz';
    Lv_NomArchivoZip := 'reporte'||Lc_RepDisponibles.VALOR1||'Zip'||Lv_Prefijo||'-'||Lv_FecReporte||'.zip';
    Lv_Gzip :='gzip '||Lc_Directory.DIRECTORY_PATH||Lv_NomArchivo;

    LFile_Archivo := NULL;
    Lb_FileOpen  := FALSE;

    BEGIN

    IF TRIM(Lc_RepDisponibles.VALOR1) = 'Cartera' THEN

      OPEN C_ClienteCartera(Lv_Prefijo,Lv_FecFiltro);

      LFile_Archivo := UTL_FILE.FOPEN(Lv_DirCsv,Lv_NomArchivo,'w',3000);

      Lb_FileOpen:=TRUE;

      -- CABECERA DEL REPORTE
      UTL_FILE.PUT_LINE(LFile_Archivo,
          'DESCRIPCION_TIPO_ROL'||Lv_Delimitador||
          'NOMBRE_REGION'||Lv_Delimitador||
          'FECHA_REPORTE'||Lv_Delimitador||
          'TIPO_IDENTIFICACION'||Lv_Delimitador||
          'IDENTIFICACION_CLIENTE'||Lv_Delimitador||
          'NOMBRE_CLIENTE'||Lv_Delimitador||
          'ESTADO_CLIENTE'||Lv_Delimitador||
          'NUMERO_CONTRATO'||Lv_Delimitador||
          'FORMA_PAGO'||Lv_Delimitador||
          'DESCRIPCION_BANCO'||Lv_Delimitador||
          'DESCRIPCION_CUENTA'||Lv_Delimitador||
          'NOMBRE_OFICINA'||Lv_Delimitador||
          'CODIGO_TIPO_NEGOCIO'||Lv_Delimitador||
          'LOGIN'||Lv_Delimitador||
          'ESTADO_LOGIN'||Lv_Delimitador||
          'ESTADO_INTERNET'||Lv_Delimitador||
          'DIRECCION'||Lv_Delimitador||
          'TELEFONOS'||Lv_Delimitador||
          'CIUDAD'||Lv_Delimitador||
          'VENDEDOR'||Lv_Delimitador||
          'ELEMENTO'||Lv_Delimitador||
          'TIPO_MEDIO'||Lv_Delimitador||
          'NUMERO_CORTES'||Lv_Delimitador||
          'FE_ACTIVACION'||Lv_Delimitador||
          'FE_CANCELACION'||Lv_Delimitador||
          'FE_CORTE'||Lv_Delimitador||
          'FECHA_EMISION'||Lv_Delimitador||
          'FACTURA'||Lv_Delimitador||
          'CICLO_FACTURACION'||Lv_Delimitador||
          'VALOR_TOTAL'||Lv_Delimitador||
          'SALDO'||Lv_Delimitador||
          '30_DIAS'||Lv_Delimitador||
          '60_DIAS'||Lv_Delimitador||
          '90_DIAS'||Lv_Delimitador||
          '120_DIAS'||Lv_Delimitador||
          'MAS_DIAS'||Lv_Delimitador||
          'EJECUTIVO_COBRANZAS'||Lv_Delimitador||
          'OBSERVACION_RECHAZO_DEBITO'||Lv_Delimitador||
          'FECHA_RECHAZO_DEBITO'||Lv_Delimitador||
          'TRAMITE_LEGAL'
           );

      IF C_ClienteCartera%ISOPEN THEN

          LOOP
            FETCH C_ClienteCartera BULK COLLECT INTO Lr_ClientesCartera LIMIT 90;
            EXIT WHEN Lr_ClientesCartera.COUNT = 0;

            FOR J IN Lr_ClientesCartera.FIRST .. Lr_ClientesCartera.LAST LOOP

              Ln_Dias30  := 0;
              Ln_Dias60  := 0;
              Ln_Dias90  := 0;
              Ln_Dias120 := 0;
              Ln_DiasMas := 0;

              IF Lr_ClientesCartera(J).DIAS <= 30 THEN
                Ln_Dias30:=Lr_ClientesCartera(J).SALDO;
              ELSIF Lr_ClientesCartera(J).DIAS > 30 AND Lr_ClientesCartera(J).DIAS <= 60 THEN
                Ln_Dias60:=Lr_ClientesCartera(J).SALDO;
              ELSIF Lr_ClientesCartera(J).DIAS > 60 AND Lr_ClientesCartera(J).DIAS <= 90 THEN
                Ln_Dias90:=Lr_ClientesCartera(J).SALDO;
              ELSIF Lr_ClientesCartera(J).DIAS > 90 AND Lr_ClientesCartera(J).DIAS <= 120 THEN
                Ln_Dias120:=Lr_ClientesCartera(J).SALDO;
              ELSIF Lr_ClientesCartera(J).DIAS > 120 THEN
                Ln_DiasMas:=Lr_ClientesCartera(J).SALDO;
              END IF;

              -- CUERPO DEL REPORTE
              UTL_FILE.PUT_LINE(LFile_Archivo,
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).DESCRIPCION_TIPO_ROL)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).NOMBRE_REGION)||Lv_Delimitador||
                TO_CHAR(Lr_ClientesCartera(J).FECHA_REPORTE,'YYYY-MM-DD')||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).TIPO_IDENTIFICACION)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).IDENTIFICACION_CLIENTE)||Lv_Delimitador||
                FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(Lr_ClientesCartera(J).NOMBRE_CLIENTE)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).ESTADO_CLIENTE)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).NUMERO_CONTRATO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).FORMA_PAGO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).DESCRIPCION_BANCO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).DESCRIPCION_CUENTA)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).NOMBRE_OFICINA)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).CODIGO_TIPO_NEGOCIO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).LOGIN)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).ESTADO_PUNTO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).ESTADO_INTERNET)||Lv_Delimitador||
                FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(Lr_ClientesCartera(J).DIRECCION)||Lv_Delimitador||
                Lr_ClientesCartera(J).TELEFONOS||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).CIUDAD)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).VENDEDOR)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).ELEMENTO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).TIPO_MEDIO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).NUMERO_CORTES)||Lv_Delimitador||
                Lr_ClientesCartera(J).FE_ACTIVACION||Lv_Delimitador||
                Lr_ClientesCartera(J).FE_CANCELACION||Lv_Delimitador||
                Lr_ClientesCartera(J).FE_CORTE||Lv_Delimitador||
                TO_CHAR(Lr_ClientesCartera(J).FE_EMISION,'YYYY-MM-DD')||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).FACTURA)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).CICLO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).VALOR_TOTAL)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).SALDO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Ln_Dias30)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Ln_Dias60)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Ln_Dias90)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Ln_Dias120)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Ln_DiasMas)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).EJECUTIVO_COBRANZAS)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).MOTIVO_RECHAZO_DEBITO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).FE_RECHAZO_DEBITO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesCartera(J).TRAMITE_LEGAL)
                 );
            END LOOP;

          END LOOP;

        CLOSE C_ClienteCartera;
      END IF;

      UTL_FILE.FCLOSE(LFile_Archivo);
    END IF;

    IF TRIM(Lc_RepDisponibles.VALOR1) = 'Anticipos' THEN

      DB_FINANCIERO.FNKG_CARTERA_CLIENTES.P_REPORTE_ANTICIPOS(Lv_Prefijo,Lv_FecFiltro,Lrf_ClientesAnticip);

      LFile_Archivo := UTL_FILE.FOPEN(Lv_DirCsv,Lv_NomArchivo,'w',3000);

      Lb_FileOpen:=TRUE;

      -- CABECERA DEL REPORTE
      UTL_FILE.PUT_LINE(LFile_Archivo,
          'BANCO'||Lv_Delimitador||
          'CLIENTE'||Lv_Delimitador||
          'CUENTA'||Lv_Delimitador||
          'ESTADO DEL PAGO'||Lv_Delimitador||
          'ESTADO DEL PUNTO'||Lv_Delimitador||
          'ESTADO INTERNET'||Lv_Delimitador||
          'FECHA DEL PAGO'||Lv_Delimitador||
          'FORMA DE PAGO'||Lv_Delimitador||
          'IDENTIFICACION CLIENTE'||Lv_Delimitador||
          'JURISDICCION'||Lv_Delimitador||
          'LOGIN'||Lv_Delimitador||
          'NOMBRE PUNTO'||Lv_Delimitador||
          'NUMERO DEL PAGO'||Lv_Delimitador||
          'OFICINA'||Lv_Delimitador||
          'TIPO DOCUMENTO'||Lv_Delimitador||
          'VALOR TOTAL'||Lv_Delimitador||
          'CICLO'
           );

      IF Lrf_ClientesAnticip%ISOPEN THEN

          LOOP
            FETCH Lrf_ClientesAnticip BULK COLLECT INTO Lr_ClientesAnticip LIMIT 10000;
            EXIT WHEN Lr_ClientesAnticip.COUNT = 0;

            FOR J IN Lr_ClientesAnticip.FIRST .. Lr_ClientesAnticip.LAST LOOP

              -- CUERPO DEL REPORTE
              UTL_FILE.PUT_LINE(LFile_Archivo,
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).DESCRIPCION_BANCO)||Lv_Delimitador||
                FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(Lr_ClientesAnticip(J).CLIENTE)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).DESCRIPCION_CUENTA)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).ESTADO_PAGO_HISTORIAL)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).ESTADO_PUNTO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).ESTADO_INTERNET)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).FE_PAGO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).FORMA_PAGO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).IDENTIFICACION_CLIENTE)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).DESCRIPCION_JURISDICCION)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).LOGIN)||Lv_Delimitador||
                FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(Lr_ClientesAnticip(J).DESCRIPCION_PUNTO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).NUMERO_PAGO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).NOMBRE_OFICINA)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).NOMBRE_TIPO_DOCUMENTO)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).VALOR_TOTAL)||Lv_Delimitador||
                FNKG_CARTERA_CLIENTES.F_FORMAT_TEXT(Lr_ClientesAnticip(J).CICLO)
                 );
            END LOOP;

          END LOOP;

        CLOSE Lrf_ClientesAnticip;
      END IF;

      UTL_FILE.FCLOSE(LFile_Archivo);
    END IF;

    IF Lb_FileOpen THEN
      Lb_FileOpen:=FALSE;
      DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) );
      Lv_reponse:=F_HTTPPOSTMULTIPART(Lv_UrlNfs,Lc_Directory.DIRECTORY_PATH||Lv_NomArchivoGz,Lv_NomArchivoZip,Lc_RepDisponibles.VALOR1,Lv_CodigoApp,Lv_CodigoPath);
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'JOB',
                                              'FNKG_CARTERA_CLIENTES.P_EJEC_REP_CART_ANTIC_MD',
                                              'Respuesta del NFS '||Lv_reponse,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') ); 

      Lv_Comparacion:=F_CONTAINS(Lv_reponse,'200');

          IF Lv_Comparacion = 'OK'
          THEN
             --  UTL_FILE.FREMOVE(Lv_DirCsv,Lv_NomArchivoGz);
               null;
          ELSE
               UTL_FILE.FCOPY(Lv_DirCsv, Lv_NomArchivoGz, Lv_DirCsvFinal, Lv_NomArchivoZip);
              -- UTL_FILE.FREMOVE(Lv_DirCsv,Lv_NomArchivoGz);
          END IF;

    END IF;

    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'JOB',
                                              'FNKG_CARTERA_CLIENTES.P_EJEC_REP_CART_ANTIC_MD',
                                              'Error en el reporte '||Lv_NomArchivo||':'||SQLCODE ||' ERROR '||SQLERRM||' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                                              ' ERROR_BACKTRACE: '  || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

      IF Lrf_ClientesCartera%ISOPEN OR Lrf_ClientesAnticip%ISOPEN THEN
        UTL_FILE.FCLOSE(LFile_Archivo);
      END IF;
    END;

  END LOOP;

END P_EJEC_REP_CART_ANTIC_MD;

FUNCTION F_FORMAT_TEXT(Pv_Text IN VARCHAR2)
  RETURN VARCHAR2
IS

Lv_Result VARCHAR2(4000) := '';
Ln_Limit  NUMBER         := 2000;
BEGIN

  SELECT SUBSTR(TRIM(REPLACE(REPLACE(REPLACE(PV_TEXT,CHR(10),''),CHR(13),''),';',',')),0,LN_LIMIT)
  INTO Lv_Result
  FROM DUAL;

  RETURN Lv_Result;
EXCEPTION
  WHEN OTHERS THEN
    RETURN Lv_Result;
END F_FORMAT_TEXT;
--
--
FUNCTION F_GET_FORMA_PAGO(Fn_IdPersonaRol  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                          Fn_IdPunto       IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN VARCHAR2
IS

  Ln_CodigoSri DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_SRI%TYPE                           := NULL;
  Lv_CodigoFormaPagoCliente DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE       := '';
  Ln_IdFormaPago DB_FINANCIERO.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE                   := 0;
  Lv_DescripcionFormaPago DB_FINANCIERO.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE := '';
  Lv_TipoFormaPago DB_FINANCIERO.ADMI_FORMA_PAGO.TIPO_FORMA_PAGO%TYPE               := '';
  Lv_FormaPagoObtenidaPor VARCHAR2(10)                                              := '';

BEGIN

  DB_FINANCIERO.FNCK_CONSULTS.P_GET_FORMA_PAGO_CLIENTE(Fn_IdPersonaRol,
                                                       Fn_IdPunto,
                                                       Ln_IdFormaPago,
                                                       Lv_CodigoFormaPagoCliente,
                                                       Lv_DescripcionFormaPago,
                                                       Ln_CodigoSri,
                                                       Lv_TipoFormaPago,
                                                       Lv_FormaPagoObtenidaPor);

  RETURN Lv_DescripcionFormaPago;

EXCEPTION
  WHEN OTHERS THEN
    RETURN Lv_DescripcionFormaPago;
END F_GET_FORMA_PAGO;
--
--
FUNCTION F_HTTPPOSTMULTIPART(Fv_UrlMicro VARCHAR2,Fv_FileName VARCHAR2,Fv_NombreArchivo VARCHAR2,Fv_PathAdicional VARCHAR2,Fv_CodigoApp VARCHAR2,Fv_CodigoPath VARCHAR2)
   RETURN VARCHAR2
AS
   LANGUAGE JAVA
   NAME 'HttpPostMultipart.consumer(java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String,java.lang.String) return java.lang.String';

FUNCTION F_CONTAINS(PV_TEXTO VARCHAR2,PV_COMPARAR VARCHAR2)
   RETURN VARCHAR2
AS
   LANGUAGE JAVA
   NAME 'HttpPostMultipart.containsString(java.lang.String,java.lang.String) return java.lang.String';


END FNKG_CARTERA_CLIENTES;
/
