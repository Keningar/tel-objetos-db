CREATE EDITIONABLE PACKAGE               FNKG_TYPES 
AS


  --
  /*
  * Documentaci�n para TYPE 'Lr_ClienteRptBuro'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a un cliente del reporte de buro
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 07-08-2017
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.1 01-12-2017 Se agrega la Columna de Ciclo

  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.2 02-09-2019 Se agrega la Columna CANCEL_VOLUNTARIA
  */
  TYPE Lr_ClienteRptBuro
  IS
    RECORD
    (
      ID_PERSONA               VARCHAR2(100),
      ID_PUNTO                 VARCHAR2(100),
      TIPO_IDENTIFICACION      VARCHAR2(500),
      TIPO_DOCUMENTO           VARCHAR2(500),
      IDENTIFICACION_CLIENTE   DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
      NOMBRE_CLIENTE           DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      DIRECCION_PUNTO          DB_COMERCIAL.INFO_PERSONA.DIRECCION%TYPE,
      CANTON_PUNTO             VARCHAR2(500),
      TELEFONO_CLIENTE         VARCHAR2(500),
      ACREEDOR                 VARCHAR2(500),
      FECHA_CONCESION          VARCHAR2(500),
      FECHA_VENCIMIENTO        VARCHAR2(500),
      EMAIL_CLIENTE            VARCHAR2(1000),
      NUMERO_CONTRATO          DB_COMERCIAL.INFO_CONTRATO.NUMERO_CONTRATO%TYPE,
      COORDENADAS              VARCHAR2(500),
      FORMA_PAGO               DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
      BANCO_TARJETA            VARCHAR2(500),
      TIPO_CUENTA              VARCHAR2(500),
      RETIRO_EQUIPO            VARCHAR2(500),
      CICLO                    DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE,
      CANCEL_VOLUNTARIA        VARCHAR2(2),
      SALDO                    VARCHAR2(500),
      ESTADO                   DB_COMERCIAL.INFO_PERSONA.ESTADO%TYPE,
      EMPRESA_COD              DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,    
      DIRECCION_CLIENTE        DB_COMERCIAL.INFO_PERSONA.DIRECCION%TYPE    
      );
    --
  TYPE LrF_ClienteRptBuro
  IS
    REF
    CURSOR
      RETURN Lr_ClienteRptBuro;
  --
  /*
  * Documentaci�n para TYPE 'Lr_NotificacionDocumentos'.
  *
  * Tipo de datos para el retorno de la informacion correspondiente a los documentos a notificar a los usuarios
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.0 21-12-2016
  */
  TYPE Lr_NotificacionDocumentos
  IS
    RECORD
    (
      ID_DOCUMENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      CODIGO_TIPO_DOCUMENTO DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      FE_CREACION DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_CREACION%TYPE,
      SUB_TOTAL DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
      SUB_TOTAL_CON_IMPUESTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
      SUB_TOTAL_DESCUENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
      VALOR_TOTAL DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
      DESCRIPCION_PUNTO DB_COMERCIAL.INFO_PUNTO.DESCRIPCION_PUNTO%TYPE,
      LOGIN DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      CLIENTE DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      NOMBRE_OFICINA DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
      VENDEDOR DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      OBSERVACION DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE,
      NUMERO_DOCUMENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
      ESTADO_DOCUMENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE );
    --
  TYPE Lrf_NotificacionDocumentos
  IS
    REF
    CURSOR
      RETURN Lr_NotificacionDocumentos;
  --
  --
/**
* Documentacion para el PKG FNKG_TYPES
* El PKG FNKG_TYPES contendra las variables que sean necesarias a usar en los PKG de consultas o transacciones
* separando procedimientos y funciones de las declaraciones de variables
* @author Alexander Samaniego <awsamaniego@telconet.ec>
* @version 1.0 09-01-2015
* @author Edson Franco <efranco@telconet.ec>
* @version 1.1 29-12-2015 - Se agregan los campos 'PROCESOS_AUTOMATICOS' y 'TIPO_ID' que fueron agregados a la tabla
*                           'ADMI_NUMERACION'
* @author Andres Montero <amontero@telconet.ec>
* @version 1.2 16-04-2016 - Se agregan los campos 'CUENTA_CONTABLE_ID' y 'CONTABILIZADO' que fueron agregados a la tabla
* 'INFO_PAGO_DET'
* @author Gina Villalba <gvillalba@telconet.ec>
* @version 1.3 31-08-2016 - Se agrega el campo 'CODIGO_SRI' que fue agregado a la tabla 'ADMI_FORMA_PAGO'
* @author Edson Franco <efranco@telconet.ec>
* @version 1.4 19-09-2016 - Se agrega el campo 'FE_ORDENAMIENTO' al type 'Lr_InfoDocRelacionados'. Nueva columna que es utilizada para ordenar los
                            documentos relacionados por fecha y hora.
* @author Edson Franco <efranco@telconet.ec>
* @version 1.5 28-09-2016 - Se agrega el campo 'TIPO_FORMA_PAGO' que fue agregado a la tabla 'ADMI_FORMA_PAGO' al TYPE 'Lr_AdmiFormaPago'
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.6 23-03-2021 - Se agrega el campo 'TIPO_PROCESO' que fue agregado a la tabla 'INFO_PAGO_DET' al TYPE 'Lr_InfoPagoDet'
*
* @author Edgar Holguin <eholguin@telconet.ec>
* @version 1.7 17-06-2021 - Se agrega el campo 'REFERENCIA_DET_PAGO_AUT_ID' que fue agregado a la tabla 'INFO_PAGO_DET' al TYPE 'Lr_InfoPagoDet'
*/
--
TYPE Lr_InfoPagoDet
IS
  RECORD
  (
    ID_PAGO_DET             INFO_PAGO_DET.ID_PAGO_DET%TYPE,
    PAGO_ID                 INFO_PAGO_DET.PAGO_ID%TYPE,
    FORMA_PAGO_ID           INFO_PAGO_DET.FORMA_PAGO_ID%TYPE,
    REFERENCIA_ID           INFO_PAGO_DET.REFERENCIA_ID%TYPE,
    VALOR_PAGO              INFO_PAGO_DET.VALOR_PAGO%TYPE,
    BANCO_TIPO_CUENTA_ID    INFO_PAGO_DET.BANCO_TIPO_CUENTA_ID%TYPE,
    NUMERO_REFERENCIA       INFO_PAGO_DET.NUMERO_REFERENCIA%TYPE,
    FE_APLICACION           INFO_PAGO_DET.FE_APLICACION%TYPE,
    ESTADO                  INFO_PAGO_DET.ESTADO%TYPE,
    COMENTARIO              INFO_PAGO_DET.COMENTARIO%TYPE,
    DEPOSITADO              INFO_PAGO_DET.DEPOSITADO%TYPE,
    DEPOSITO_PAGO_ID        INFO_PAGO_DET.DEPOSITO_PAGO_ID%TYPE,
    NUMERO_CUENTA_BANCO     INFO_PAGO_DET.NUMERO_CUENTA_BANCO%TYPE,
    FE_CREACION             INFO_PAGO_DET.FE_CREACION%TYPE,
    FE_ULT_MOD              INFO_PAGO_DET.FE_ULT_MOD%TYPE,
    USR_CREACION            INFO_PAGO_DET.USR_CREACION%TYPE,
    USR_ULT_MOD             INFO_PAGO_DET.USR_ULT_MOD%TYPE,
    BANCO_CTA_CONTABLE_ID   INFO_PAGO_DET.BANCO_CTA_CONTABLE_ID%TYPE,
    FE_DEPOSITO             INFO_PAGO_DET.FE_DEPOSITO%TYPE,
    CUENTA_CONTABLE_ID      INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE,
    CONTABILIZADO           INFO_PAGO_DET.CONTABILIZADO%TYPE,
    TIPO_PROCESO            INFO_PAGO_DET.TIPO_PROCESO%TYPE DEFAULT 'Pago',
    REFERENCIA_DET_PAGO_AUT_ID INFO_PAGO_DET.REFERENCIA_DET_PAGO_AUT_ID%TYPE);
  --
TYPE Lrf_InfoPagoDet
IS
  REF
  CURSOR
    RETURN Lr_InfoPagoDet;
    --
  TYPE Lr_AdmiFormaPago
IS
  RECORD
  (
    ID_FORMA_PAGO           ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
    CODIGO_FORMA_PAGO       ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
    DESCRIPCION_FORMA_PAGO  ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
    ES_DEPOSITABLE          ADMI_FORMA_PAGO.ES_DEPOSITABLE%TYPE,
    ES_MONETARIO            ADMI_FORMA_PAGO.ES_MONETARIO%TYPE,
    ES_PAGO_PARA_CONTRATO   ADMI_FORMA_PAGO.ES_PAGO_PARA_CONTRATO%TYPE,
    ESTADO                  ADMI_FORMA_PAGO.ESTADO%TYPE,
    USR_CREACION            ADMI_FORMA_PAGO.USR_CREACION%TYPE,
    FE_CREACION             ADMI_FORMA_PAGO.FE_CREACION%TYPE,
    USR_ULT_MOD             ADMI_FORMA_PAGO.USR_ULT_MOD%TYPE,
    FE_ULT_MOD              ADMI_FORMA_PAGO.FE_ULT_MOD%TYPE,
    CTA_CONTABLE            ADMI_FORMA_PAGO.CTA_CONTABLE%TYPE,
    VISIBLE_EN_PAGO         ADMI_FORMA_PAGO.VISIBLE_EN_PAGO%TYPE,
    CORTE_MASIVO            ADMI_FORMA_PAGO.CORTE_MASIVO%TYPE,
    CODIGO_SRI              ADMI_FORMA_PAGO.CODIGO_SRI%TYPE,
    TIPO_FORMA_PAGO         ADMI_FORMA_PAGO.TIPO_FORMA_PAGO%TYPE
 );
  --
TYPE Lrf_AdmiFormaPago
IS
  REF
  CURSOR
    RETURN Lr_AdmiFormaPago;
    --
  TYPE Lr_AdmiNumeracion
IS
  RECORD
  (
    ID_NUMERACION        ADMI_NUMERACION.ID_NUMERACION%TYPE,
    EMPRESA_ID           ADMI_NUMERACION.EMPRESA_ID%TYPE,
    OFICINA_ID           ADMI_NUMERACION.OFICINA_ID%TYPE,
    DESCRIPCION          ADMI_NUMERACION.DESCRIPCION%TYPE,
    CODIGO               ADMI_NUMERACION.CODIGO%TYPE,
    NUMERACION_UNO       ADMI_NUMERACION.NUMERACION_UNO%TYPE,
    NUMERACION_DOS       ADMI_NUMERACION.NUMERACION_DOS%TYPE,
    SECUENCIA            ADMI_NUMERACION.SECUENCIA%TYPE,
    FE_CREACION          ADMI_NUMERACION.FE_CREACION%TYPE,
    USR_CREACION         ADMI_NUMERACION.USR_CREACION%TYPE,
    FE_ULT_MOD           ADMI_NUMERACION.FE_ULT_MOD%TYPE,
    USR_ULT_MOD          ADMI_NUMERACION.USR_ULT_MOD%TYPE,
    TABLA                ADMI_NUMERACION.TABLA%TYPE,
    ESTADO               ADMI_NUMERACION.ESTADO%TYPE,
    NUMERO_AUTORIZACION  ADMI_NUMERACION.NUMERO_AUTORIZACION%TYPE,
    PROCESOS_AUTOMATICOS ADMI_NUMERACION.PROCESOS_AUTOMATICOS%TYPE,
    TIPO_ID              ADMI_NUMERACION.TIPO_ID%TYPE);
  --
TYPE Lrf_AdmiNumeracion
IS
  REF
  CURSOR
    RETURN Lr_AdmiNumeracion;
 --
 /*
  * Documentaci�n para TYPE 'T_Numeraciones'.
  * Record para almacenar la data enviada al BULK.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 22-02-2023
  * @since 1.0
  */
 TYPE T_Numeraciones IS TABLE OF Lr_AdmiNumeracion INDEX BY PLS_INTEGER;
 --

  TYPE Lr_AliasPlantilla
IS
  RECORD
  (
    ALIAS_CORREOS VARCHAR2(4000),
    PLANTILLA     VARCHAR2(4000));
-- Utilizado para el cursos que retorna el calculo de la cartera
TYPE Lr_InfoCarteraCliente
IS
  RECORD
  (
    FECHA_REPORTE           DATE,
    TIPO_IDENTIFICACION     INFO_PERSONA.TIPO_IDENTIFICACION%TYPE,
    IDENTIFICACION_CLIENTE  INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
    NOMBRE_CLIENTE          INFO_PERSONA.RAZON_SOCIAL%TYPE,
    LOGIN		    INFO_PUNTO.LOGIN%TYPE,	
    CODIGO_TIPO_NEGOCIO     ADMI_TIPO_NEGOCIO.CODIGO_TIPO_NEGOCIO%TYPE,
    NUMERO_CONTRATO         INFO_CONTRATO.NUMERO_CONTRATO%TYPE,
    NOMBRE_OFICINA	    INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
    ESTADO		    INFO_PUNTO.ESTADO%TYPE,
    FACTURA		    INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    VALOR_TOTAL		    INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    FE_EMISION              INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
    DIAS		    NUMBER,
    CODIGO_FORMA_PAGO	    ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
    SALDO		    NUMBER);
--Utilizado para los documentos relacionados en los SALDOS_X_FACTURA
TYPE Lr_InfoDocRelacionados
IS 
  RECORD
  (
    CODIGO_TIPO_DOCUMENTO VARCHAR2(100),
    NUMERO_PAGO           VARCHAR2(200),
    ESTADO_PAGO           VARCHAR2(100),
    VALOR_PAGO            NUMBER,
    CODIGO_FORMA_PAGO     VARCHAR2(100),
    FE_CREACION           VARCHAR2(100),
    FE_ORDENAMIENTO       VARCHAR2(100),
    NUMERO_REFERENCIA     VARCHAR2(200),
    DESCRIPCION_BANCO     VARCHAR2(3000),
    DESCRIPCION_CONTABLE  VARCHAR2(3000),
    ID_PAGO_DET           NUMBER
  );


  /*
  * Documentaci�n para TYPE 'Lr_Cobranza'.
  * Record que me permite devolver los valores para setear columnas de reportes de cobranzas (pagos, anticipos, etc)
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-09-2015
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 25-10-2016 Se elimina campo no utilizado (NOMBRE_VENDEDOR)
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.2 26-10-2016 Se agrega tipo de dato correspondiente a campos de comentarios.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 11-01-2017 - Se agrega la columna 'NUMERO_COMPROBANTE' la cual ayuda a realizar la cuadratura de los anticipos por parte del usuario
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 03-02-2017 - Se agrega la columna 'DESCRIPCION_CTA_CONTABLE' la cual obtendra la descripci�n de la cuenta contable registrada en el
  *                           detalle del pago en el campo 'DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID'. Adicional se agrega la columna 
  *                           'FECHA_DOCUMENTO' la cual retorna la fecha cuando se ha procesado el d�bito.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.5 15-08-2017 - Se agrega la columna 'FECHA_CREACION_DEBITO' la cual obtendra la fecha de creacion del debito.
  *                           Se agrega la columna 'FECHA_CREACION_DEPOSITO' la cual obtendra la fecha de creacion del deposito.
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.6 23-10-2017
  * Se agrega columna CICLO_FACTURACION  
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.7 1-12-2017
  * Se agrega columna SERVICIOS
  * 
  * @author Angel Reina <areina@telconet.ec>
  * @version 1.7 1-07-2019
  * Se agrega columna TIPO CUENTA (TIPO_CTA, TIPO_CTA_CONTABLE) para los Reporte Financiero - Por tipo de documentos Pago, Pago por Cruce, 
  * Anticipo, Anticipo por Cruce, Anticipo sin Cliente (PAG, PAGC, ANT, ANTC, ANTS)
  *
  */
  TYPE Lr_Cobranza IS RECORD (
          ID_DOCUMENTO               DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE, 
          SERVICIOS                  VARCHAR2(2000),
          ID_DOCUMENTO_DETALLE       DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE, 
          OFICINA_ID                 DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,          
          NUMERO_DOCUMENTO           DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE, 
          VALOR_TOTAL_GLOBAL         DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
          ESTADO_DOCUMENTO_GLOBAL    DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE, 
          COMENTARIO_PAGO            DB_FINANCIERO.INFO_PAGO_CAB.COMENTARIO_PAGO%TYPE,
          FE_CREACION                DB_FINANCIERO.INFO_PAGO_DET.FE_CREACION%TYPE,
          FECHA_CREACION             VARCHAR2(100),
          VALOR_TOTAL                DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
          DEPOSITADO                 DB_FINANCIERO.INFO_PAGO_DET.DEPOSITADO%TYPE,
          BANCO_TIPO_CUENTA_ID       DB_FINANCIERO.INFO_PAGO_DET.BANCO_TIPO_CUENTA_ID%TYPE,
          BANCO_CTA_CONTABLE_ID      DB_FINANCIERO.INFO_PAGO_DET.BANCO_CTA_CONTABLE_ID%TYPE,
          REFERENCIA_ID              DB_FINANCIERO.INFO_PAGO_DET.REFERENCIA_ID%TYPE,
          NUMERO_REFERENCIA          DB_FINANCIERO.INFO_PAGO_DET.NUMERO_REFERENCIA%TYPE,
          NUMERO_CUENTA_BANCO        DB_FINANCIERO.INFO_PAGO_DET.NUMERO_CUENTA_BANCO%TYPE,
          USR_CREACION               DB_FINANCIERO.INFO_PAGO_DET.USR_CREACION%TYPE,
          COMENTARIO_DETALLE_PAGO    DB_FINANCIERO.INFO_PAGO_DET.COMENTARIO%TYPE,
          FE_DEPOSITO                DB_FINANCIERO.INFO_PAGO_DET.FE_DEPOSITO%TYPE,
          FECHA_DEPOSITO             VARCHAR2(100),          
          ID_FORMA_PAGO              DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
          DESCRIPCION_FORMA_PAGO     DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO %TYPE,
          ES_DEPOSITABLE             DB_GENERAL.ADMI_FORMA_PAGO.ES_DEPOSITABLE%TYPE,
          CODIGO_TIPO_DOCUMENTO      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
          NOMBRE_TIPO_DOCUMENTO      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
          ID_PUNTO                   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
          LOGIN                      DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
          NOMBRE_PUNTO               DB_COMERCIAL.INFO_PUNTO.NOMBRE_PUNTO%TYPE,
          DIRECCION                  DB_COMERCIAL.INFO_PUNTO.DIRECCION%TYPE,
          DESCRIPCION_PUNTO          DB_COMERCIAL.INFO_PUNTO.DESCRIPCION_PUNTO%TYPE,           
          ESTADO                     DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE, 
          USR_VENDEDOR               DB_COMERCIAL.INFO_PUNTO.USR_VENDEDOR%TYPE,
          ID_PERSONA                 DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,   
          IDENTIFICACION_CLIENTE     DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,   
          NOMBRE_CLIENTE             DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,         
          APELLIDOS_CLIENTE          DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
          RAZON_SOCIAL_CLIENTE       DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
          DIRECCION_CLIENTE          DB_COMERCIAL.INFO_PERSONA.DIRECCION%TYPE,  
          CICLO_FACTURACION          DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE,
          CALIFICACION_CREDITICIA    DB_COMERCIAL.INFO_PERSONA.CALIFICACION_CREDITICIA%TYPE, 
          FE_PROCESADO               DB_FINANCIERO.INFO_DEPOSITO.FE_PROCESADO%TYPE,
          FECHA_PROCESADO            VARCHAR2(100),
          NO_COMPROBANTE_DEPOSITO    DB_FINANCIERO.INFO_DEPOSITO.NO_COMPROBANTE_DEPOSITO%TYPE,
          FE_CRUCE                   DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE%TYPE,
          FECHA_CRUCE                VARCHAR2(100),
          CUENTA_CONTABLE_ID         DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE,
          BANCO                      DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,
          BANCO_TC                   DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,
          BANCO_EMPRESA              DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE, 
          BANCO_EMPRESA_DEP          DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE,
          BANCO_EMPRESA_DEP_NAF      DB_GENERAL.ADMI_BANCO_CTA_CONTABLE.DESCRIPCION%TYPE,
          TIPO_DOCUMENTO_AUT         DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
          NUMERO_DOCUMENTO_AUT       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
          FECHA_EMISION              VARCHAR2(100),
          USUARIO_CREACION           VARCHAR2(300),
          OFICINA_CLIENTE            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
          NUMERO_COMPROBANTE         VARCHAR2(50),
          DESCRIPCION_CTA_CONTABLE   DB_FINANCIERO.ADMI_CUENTA_CONTABLE.DESCRIPCION%TYPE,
          FECHA_DOCUMENTO            DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.FE_DOCUMENTO%TYPE,
          FECHA_CREACION_DEBITO      DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.FE_CREACION%TYPE,
          FECHA_CREACION_DEPOSITO    DB_FINANCIERO.INFO_DEPOSITO.FE_CREACION%TYPE,
          TIPO_CTA                   DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE DEFAULT NULL,
          TIPO_CTA_CONTABLE          DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE DEFAULT NULL
    );

  /*
  * Documentaci�n para TYPE 'Lr_Pago'.
  * Record que me permite devolver los valores para setear columnas de reportes de cobranzas (ANTS)
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-09-2015
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 26-10-2016 Se agrega tipo de dato correspondiente a campos de comentarios.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 11-01-2017 - Se agrega la columna 'NUMERO_COMPROBANTE' la cual ayuda a realizar la cuadratura de los anticipos por parte del usuario  
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.3 1-12-2017 - Se agrega la columna 'SERVICIOS'
  * 
  * @author Angel Reina <areina@telconet.ec>
  * @version 1.7 1-07-2019
  * Se agrega columna TIPO CUENTA (TIPO_CTA, TIPO_CTA_CONTABLE) para los Reporte Financiero - Por tipo de documentos Pago, Pago por Cruce, 
  * Anticipo, Anticipo por Cruce, Anticipo sin Cliente (PAG, PAGC, ANT, ANTC, ANTS)
  *
  */
  TYPE Lr_Pago IS RECORD (
          ID_DOCUMENTO               DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE, 
          ID_DOCUMENTO_DETALLE       DB_FINANCIERO.INFO_PAGO_DET.ID_PAGO_DET%TYPE, 
          OFICINA_ID                 DB_FINANCIERO.INFO_PAGO_CAB.OFICINA_ID%TYPE,          
          NUMERO_DOCUMENTO           DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE, 
          VALOR_TOTAL_GLOBAL         DB_FINANCIERO.INFO_PAGO_CAB.VALOR_TOTAL%TYPE,
          ESTADO_DOCUMENTO_GLOBAL    DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE, 
          COMENTARIO_PAGO            DB_FINANCIERO.INFO_PAGO_CAB.COMENTARIO_PAGO%TYPE,
          FE_CREACION                DB_FINANCIERO.INFO_PAGO_DET.FE_CREACION%TYPE,
          FECHA_CREACION             VARCHAR2(100),
          VALOR_TOTAL                DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
          DEPOSITADO                 DB_FINANCIERO.INFO_PAGO_DET.DEPOSITADO%TYPE,
          BANCO_TIPO_CUENTA_ID       DB_FINANCIERO.INFO_PAGO_DET.BANCO_TIPO_CUENTA_ID%TYPE,
          BANCO_CTA_CONTABLE_ID      DB_FINANCIERO.INFO_PAGO_DET.BANCO_CTA_CONTABLE_ID%TYPE,
          REFERENCIA_ID              DB_FINANCIERO.INFO_PAGO_DET.REFERENCIA_ID%TYPE,
          NUMERO_REFERENCIA          DB_FINANCIERO.INFO_PAGO_DET.NUMERO_REFERENCIA%TYPE,
          NUMERO_CUENTA_BANCO        DB_FINANCIERO.INFO_PAGO_DET.NUMERO_CUENTA_BANCO%TYPE,
          USR_CREACION               DB_FINANCIERO.INFO_PAGO_DET.USR_CREACION%TYPE,
          COMENTARIO_DETALLE_PAGO    DB_FINANCIERO.INFO_PAGO_DET.COMENTARIO%TYPE,
          FE_DEPOSITO                DB_FINANCIERO.INFO_PAGO_DET.FE_DEPOSITO%TYPE,
          FECHA_DEPOSITO             VARCHAR2(100),          
          ID_FORMA_PAGO              DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
          DESCRIPCION_FORMA_PAGO     DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO %TYPE,
          ES_DEPOSITABLE             DB_GENERAL.ADMI_FORMA_PAGO.ES_DEPOSITABLE%TYPE,
          CODIGO_TIPO_DOCUMENTO      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
          NOMBRE_TIPO_DOCUMENTO      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
          FE_CRUCE                   DB_FINANCIERO.INFO_PAGO_CAB.FE_CRUCE%TYPE,
          FECHA_CRUCE                VARCHAR2(100),
          BANCO                      DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,
          BANCO_TC                   DB_GENERAL.ADMI_BANCO.DESCRIPCION_BANCO%TYPE,
          BANCO_EMPRESA              VARCHAR2(300),
          OFICINA_CLIENTE            DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
          NUMERO_COMPROBANTE         VARCHAR2(50),
          SERVICIOS                  VARCHAR2(2000),
          TIPO_CTA                   DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE DEFAULT NULL,
          TIPO_CTA_CONTABLE          DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE DEFAULT NULL
    );

  /*
  * Documentaci�n para TYPE 'Lr_Facturacion'.
  * Record que me permite devolver los valores para setear columnas de reportes de facturacion (facturas, notas de debito, notas de credito, etc)
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-09-2015
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 12-10-2015 Se actualiza longitud en variable utilizada para visualizaci�n de rpt NDI.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.2 18-10-2015 Se agregan campos para nuevas columnas del reporte financiero.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 22-12-2016 - Se agrega columna de 'DESCUENTO_COMPENSACION'.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.4 10-01-2017 - Se agrega columna de 'FE_ANULACION', la cual es obtenida del historial del documento en estado 'Anulado'
  *
  * Se agrega las columnas VALOR_RETENCION_FTE y VALOR_RETENCION_IVA
  * @author Hector Ortega <haortega@telconet.ec>
  * @version 1.4 29-12-2016
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.5 23-10-2017
  * Se agrega columna CICLO_FACTURACION
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.6 1-12-2017
  * Se agrega columna SERVICIOS
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.7 04-09-2021
  * Se agregan columnas USR_ULT_MOD,FE_ULT_MOD
  */
  TYPE Lr_Facturacion IS RECORD (
          ID_DOCUMENTO               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
          OFICINA_ID                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OFICINA_ID%TYPE,          
          NUMERO_DOCUMENTO           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE, 
          VALOR_TOTAL                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
          ESTADO_DOCUMENTO           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE, 
          ES_AUTOMATICA              VARCHAR2(10), 
          FE_CREACION                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_CREACION%TYPE,
          FECHA_CREACION             VARCHAR2(100),
          FE_EMISION                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
          FECHA_EMISION              VARCHAR2(100),
          FE_AUTORIZACION            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_AUTORIZACION%TYPE,
          FECHA_AUTORIZACION         VARCHAR2(100),
          USR_CREACION               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
          USR_ULT_MOD                VARCHAR2(500),
          FE_ULT_MOD                 VARCHAR2(100), 
          CODIGO_TIPO_DOCUMENTO      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
          NOMBRE_TIPO_DOCUMENTO      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
          ID_PUNTO                   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
          LOGIN                      DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
          NOMBRE_PUNTO               DB_COMERCIAL.INFO_PUNTO.NOMBRE_PUNTO%TYPE,
          DIRECCION                  DB_COMERCIAL.INFO_PUNTO.DIRECCION%TYPE,
          DESCRIPCION_PUNTO          DB_COMERCIAL.INFO_PUNTO.DESCRIPCION_PUNTO%TYPE,           
          ESTADO                     DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE, 
          USR_VENDEDOR               DB_COMERCIAL.INFO_PUNTO.USR_VENDEDOR%TYPE,
          ID_PERSONA                 DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,   
          IDENTIFICACION_CLIENTE     DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,   
          NOMBRE_CLIENTE             DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,         
          APELLIDOS_CLIENTE          DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
          RAZON_SOCIAL_CLIENTE       DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
          DIRECCION_CLIENTE          DB_COMERCIAL.INFO_PERSONA.DIRECCION%TYPE,  
          CICLO_FACTURACION          DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE,
          CALIFICACION_CREDITICIA    DB_COMERCIAL.INFO_PERSONA.CALIFICACION_CREDITICIA%TYPE, 
          NOMBRE_VENDEDOR            DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,
          CODIGO_TIPO_NEGOCIO        DB_COMERCIAL.ADMI_TIPO_NEGOCIO.CODIGO_TIPO_NEGOCIO%TYPE, 
          NOMBRE_OFICINA             DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,          
          SUBTOTAL                   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
          SUBTOTAL_CON_IMPUESTO      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,          
          SUBTOTAL_DESCUENTO         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
          ID_PERSONA_ROL             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
          REFERENCIA_DOCUMENTO_ID    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE,
          IVA                        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
          ICE                        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
          VALOR_REAL                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
          FORMA_PAGO                 VARCHAR2(200),
          TIPO_RESPONSABLE           DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE,
          RESPONSABLE_NC             DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE,
          FACTURA_APLICA             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
          MOTIVO_DOCUMENTO           DB_COMERCIAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
          PAGO_APLICA                DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE,
          FECHA_PAGO_APLICA          VARCHAR2(200),
          COMENTARIO_ND              VARCHAR2(5000),
          MULTA                      DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE,    
          VALOR_RETENCIONES          DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
          OFICINA_FACTURACION        DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
          DESCRIPCION_FACTURA        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE,
          DESCRIPCION_NC             DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.VALOR%TYPE,
          MOTIVO_ANULACION_DOC       DB_COMERCIAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
          SUBTOTAL_IMPUESTO_CAT      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
          SUBTOTAL_IMPUESTO_DOC      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
          SUBTOTAL_IMPUESTO_CER      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
          DESCUENTO_COMPENSACION     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE,
          VALOR_RETENCION_FTE        DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
          VALOR_RETENCION_IVA        DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
          FE_ANULACION               DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.FE_CREACION%TYPE,
          SERVICIOS                  VARCHAR2(2000)

);
  /*
  * Documentaci�n para TYPE 'Lr_RptPagosVendedor'.
  * Record que me permite devolver los valores para setear columnas de reportes de pagos por vendedor
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 01-10-2016
  */
  TYPE Lr_RptPagosVendedor IS RECORD (
          ID_QUERY                   NUMBER,
          VENDEDOR                   VARCHAR2(500), 
          CLIENTE                    VARCHAR2(500), 
          LOGIN                      DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,    
          FECHA_PAGO                 VARCHAR2(100),
          NUMERO_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE, 
          FORMA_PAGO                 DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO %TYPE,  
          ESTADO_PAGO                DB_FINANCIERO.INFO_PAGO_CAB.ESTADO_PAGO%TYPE, 
          VALOR_PAGO                 DB_FINANCIERO.INFO_PAGO_DET.VALOR_PAGO%TYPE,
          CODIGO_TIPO_DOCUMENTO      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
          FACTURA                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
          FECHA_FACTURA              VARCHAR2(100),
          ESTADO_FACTURA             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE
    );

  /**
  * Documentaci�n para TYPE 'Lr_DocumentosRechazados'.
  *
  * Tipo de datos para el retorno de la informacion correspondiente a los documentos rechazados a notificar a los usuarios
  *
  * @author Hector Ortega<haortega@telconet.ec>
  * @version 1.0 23-12-2016
  */
  TYPE Lr_DocumentosRechazados
  IS
    RECORD
    (
      FECHA_CREACION VARCHAR2(100),
      FECHA_EMISION VARCHAR2(100),
      CODIGO_TIPO_DOCUMENTO DB_COMERCIAL.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      NOMBRE_TIPO_DOCUMENTO DB_COMERCIAL.ADMI_TIPO_DOCUMENTO_FINANCIERO.NOMBRE_TIPO_DOCUMENTO%TYPE,
      ID_DOCUMENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      NUMERO_FACTURA_SRI DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
      NOMBRE_OFICINA DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
      OBSERVACION DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.OBSERVACIONES_FACTURA_DETALLE%TYPE,
      CLIENTE DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      PUNTO_CLIENTE DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      VENDEDOR DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      USR_VENDEDOR DB_COMERCIAL.INFO_PUNTO.USR_VENDEDOR%TYPE,
      SUB_TOTAL DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
      SUB_TOTAL_CON_IMPUESTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE,
      SUB_TOTAL_DESCUENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE,
      VALOR_TOTAL DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
      MOTIVO_RECHAZO DB_FINANCIERO.INFO_MENSAJE_COMP_ELEC.INFORMACION_ADICIONAL%TYPE,
      ESTADO_DOCUMENTO DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE
      );

  TYPE Lrf_DocumentosRechazados
  IS
    REF
    CURSOR
      RETURN Lr_DocumentosRechazados;


  /*
  * Documentaci�n para TYPE 'Lr_AdmiFormatoRecaudacion'.
  * Record que ser� utilizado para setear registros del formato de env�o de recaudaci�n
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 20-11-2017
  */
  TYPE Lr_AdmiFormatoRecaudacion IS RECORD (
          TIPO_CAMPO                        DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.TIPO_CAMPO%TYPE,
          CONTENIDO                         DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CONTENIDO%TYPE, 
          LONGITUD                          DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.LONGITUD%TYPE,
          CARACTER_RELLENO                  DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.CARACTER_RELLENO%TYPE,
          POSICION                          DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.POSICION%TYPE,
          ORIENTACION_CARACTER_RELLENO      DB_FINANCIERO.ADMI_FORMATO_RECAUDACION.ORIENTACION_CARACTER_RELLENO%TYPE
    );

  /*
  * Documentaci�n para TYPE 'Lr_ClienteRecaudacion'.
  * Record que ser� utilizado para setear columnas en el archivo formato de env�o de recaudaci�n
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 20-11-2017
  */
  TYPE Lr_ClienteRecaudacion IS RECORD (
          TIPO_IDENTIFICACION        DB_COMERCIAL.INFO_PERSONA.TIPO_IDENTIFICACION%TYPE,     
          IDENTIFICACION_CLIENTE     DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,   
          NOMBRES                    DB_COMERCIAL.INFO_PERSONA.NOMBRES%TYPE,         
          APELLIDOS                  DB_COMERCIAL.INFO_PERSONA.APELLIDOS%TYPE,
          RAZON_SOCIAL               DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
          SALDO                      DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO.SALDO%TYPE
    );


  /**
  * Documentaci�n para TYPE 'Lr_PtosNoFacturados'.
  *
  * Tipo de datos para el retorno de la informaci�n a notificar de los puntos no facturados.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 15-08-2019
  */
  TYPE Lr_PtosNoFacturados
  IS
    RECORD
    (
      PUNTO_CLIENTE              DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      PUNTO_AFECTADO             DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      PRODUCTO                   DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,       
      CLIENTE                    DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      IDENTIFICACION_CLIENTE     DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
      TIPO                       VARCHAR2(100)
      );

  TYPE Lrf_PtosNoFacturados
  IS
    REF
    CURSOR
      RETURN Lr_PtosNoFacturados;


  /**
  * Documentaci�n para TYPE 'Lr_FacturasPto'.
  *
  * Tipo de dato para el retorno de la informaci�n de puntos facturados a marcar.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 15-08-2019
  */
  TYPE Lr_FacturasPto
  IS
    RECORD
    (
      ID_DOCUMENTO   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
    );

  TYPE Lrf_FacturasPto
  IS
    REF
    CURSOR
      RETURN Lr_FacturasPto;


  /**
  * Documentaci�n para TYPE 'Lr_PtosCambioFormaPago'.
  *
  * Tipo de datos para el retorno de la informaci�n a notificar de los puntos que han sufrido cambio de forma de pago.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 13-09-2019
  */
  TYPE Lr_PtosCambioFormaPago
  IS
    RECORD
    (
      LOGIN          DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      FP_ANTERIOR    DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
      FP_ACTUAL      DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
      NUMERO_ACTA    DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST.NUMERO_ACTA%TYPE,       
      FE_ACTIVACION  VARCHAR2(100),
      USUARIO        DB_COMERCIAL.INFO_PERSONA.USR_CREACION%TYPE,
      MOTIVO         DB_COMERCIAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
      ES_FACTURABLE  VARCHAR2(100),
      NUM_FACTURA    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
      FECHA          VARCHAR2(100),
      VALOR          INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
      );

  TYPE Lrf_PtosCambioFormaPago
  IS
    REF
    CURSOR
      RETURN Lr_PtosCambioFormaPago;


  /**
  * Documentaci�n para TYPE 'Lr_ValorTotal'.
  *
  * Tipo de dato para el retorno de la informaci�n del campo valor total mediante bulk collect.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 05-02-2020
  */
  TYPE Lr_ValorTotal
  IS
    RECORD
    (
      VALOR_TOTAL   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
    );

  TYPE Lrf_ValorTotal
  IS
    REF
    CURSOR
      RETURN Lr_ValorTotal;

  /**
  * Documentaci�n para TYPE 'Lr_PtosFacturarInst'.
  *
  * Tipo de datos para el retorno de la informaci�n a notificar de los puntos a facturar.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 11-06-2020
  */
  TYPE Lr_PtosFacturarInst
  IS
    RECORD
    (
      PUNTO_FACTURACION_ID       DB_COMERCIAL.INFO_SERVICIO.PUNTO_FACTURACION_ID%TYPE,
      CLIENTE                    DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      PUNTO_CLIENTE              DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      PRODUCTO                   DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE, 
      PTO_FACTURACION            DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      GASTO_ADMINISTRATIVO       DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL.GASTO_ADMINISTRATIVO%TYPE,
      TIPO_ORDEN                 DB_COMERCIAL.INFO_SERVICIO.TIPO_ORDEN%TYPE,
      PAGA_IVA                   DB_COMERCIAL.INFO_PERSONA.PAGA_IVA%TYPE,
      ESTADO                     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
      ESTADO_HIST                DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ESTADO%TYPE,
      CANTIDAD                   DB_COMERCIAL.INFO_SERVICIO.CANTIDAD%TYPE,
      ES_VENTA                   DB_COMERCIAL.INFO_SERVICIO.ES_VENTA%TYPE,
      CODIGO_TIPO_NEGOCIO        DB_COMERCIAL.ADMI_TIPO_NEGOCIO.CODIGO_TIPO_NEGOCIO%TYPE,
      FRECUENCIA_PRODUCTO        DB_COMERCIAL.INFO_SERVICIO.FRECUENCIA_PRODUCTO%TYPE,
      DESCRIPCION_ROL            DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE,
      PRECIO_VENTA               DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
      PRECIO_INSTALACION         DB_COMERCIAL.INFO_SERVICIO.PRECIO_INSTALACION%TYPE,
      GENERA_FACTURA             VARCHAR2(2)
      );

  TYPE Lrf_PtosFacturarInst
  IS
    REF
    CURSOR
      RETURN Lr_PtosFacturarInst;


  /**
  * Documentaci�n para TYPE 'Lr_DocumentoRegularizaNc'.
  *
  * Tipo de dato para regularizaci�n de notas de cr�dito.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 24-06-2020
  */
  TYPE Lr_DocumentoRegularizaNc
  IS
    RECORD
    (
      ID_DOCUMENTO      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      OFICINA_ID        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OFICINA_ID%TYPE,
      CANTIDAD_NC       NUMBER
      );

  TYPE Lrf_DocumentoRegularizaNc
  IS
    REF
    CURSOR
      RETURN Lr_DocumentoRegularizaNc;

  /*
  * Documentaci�n para TYPE 'Lr_RptRetExistente'.
  * Record que me permite devolver los valores para setear columnas de reporte de retenciones existentes.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 11-08-2021
  *
  */
  TYPE Lr_RptRetExistente IS RECORD (
          IDENTIFICACION_CLIENTE     DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.IDENTIFICACION_CLIENTE%TYPE,
          RAZON_SOCIAL               DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.RAZON_SOCIAL%TYPE, 
          FECHA_AUTORIZACION         DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.FECHA%TYPE,
          NUMERO_REFERENCIA          DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_REFERENCIA%TYPE
    );
  /*
  * Documentaci�n para TYPE 'Lr_RptRetAnulada'.
  * Record que me permite devolver los valores para setear columnas de reporte de retenciones anuladas.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 13-08-2021
  *
  */
  TYPE Lr_RptRetAnulada IS RECORD (
          IDENTIFICACION_CLIENTE     DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.IDENTIFICACION_CLIENTE%TYPE,
          RAZON_SOCIAL               DB_FINANCIERO.INFO_PAGO_AUTOMATICO_CAB.RAZON_SOCIAL%TYPE,
          NUMERO_REFERENCIA          DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.NUMERO_REFERENCIA%TYPE,
          FECHA                      DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.FECHA%TYPE,
          MONTO                      DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.MONTO%TYPE,
          ESTADO                     DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.ESTADO%TYPE,
          FE_CREACION                DB_FINANCIERO.INFO_PAGO_AUTOMATICO_DET.FE_CREACION%TYPE
    );     

END FNKG_TYPES;
/