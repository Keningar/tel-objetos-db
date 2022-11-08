CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_TYPES_DOCUMENTOS 
AS

    /*
     * Documentacion para TYPE 'Lr_DocFinancieroCab'.
     * Record que me permite obtener el registro de la cabecera de un documento financiero
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 18-11-2021
     *
     */
    TYPE Lr_DocFinancieroCab IS RECORD (
      Id_Documento          Info_Documento_Financiero_Cab.Id_Documento%TYPE,
      Numero_Factura_Sri    Info_Documento_Financiero_Cab.Numero_Factura_Sri%TYPE,
      Tipo_Documento_Id     Info_Documento_Financiero_Cab.Tipo_Documento_Id%TYPE,
      Valor_Total           Info_Documento_Financiero_Cab.Valor_Total%TYPE,
      Fe_Creacion           Estado_Cuenta_Cliente.Fe_Creacion%TYPE,
      Fec_Creacion          Estado_Cuenta_Cliente.Fec_Creacion%TYPE,
      Fec_Emision           Estado_Cuenta_Cliente.Fec_Emision%TYPE,
      Fec_Autorizacion      Estado_Cuenta_Cliente.Fec_Autorizacion%TYPE,
      Punto_Id              Info_Documento_Financiero_Cab.Punto_Id%TYPE,
      Oficina_Id            Info_Documento_Financiero_Cab.Oficina_Id%TYPE,
      Referencia            Estado_Cuenta_Cliente.Referencia%TYPE,
      Codigo_Forma_Pago     Estado_Cuenta_Cliente.Codigo_Forma_Pago%TYPE,
      Numero_Referencia     Info_Pago_Det.Numero_Referencia%TYPE,
      Numero_Cuenta_Banco   Info_Pago_Det.Numero_Cuenta_Banco%TYPE,
      Referencia_Id         Info_Pago_Det.Referencia_Id%TYPE,
      Codigo_Tipo_Documento Admi_Tipo_Documento_Financiero.Codigo_Tipo_Documento%TYPE,
      Movimiento            Admi_Tipo_Documento_Financiero.Movimiento%TYPE);

    /*
     * Documentacion para TYPE 'Ltr_DocFinancieroCab'.
     * Record que me permite obtener los registros de las cabeceras de documentos financieros
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 18-11-2021
     *
     */
    TYPE Ltr_DocFinancieroCab IS TABLE OF Lr_DocFinancieroCab INDEX BY binary_integer;
    
    /*
     * Documentacion para TYPE 'Lr_DocFinAnticPago'.
     * Record que me permite obtener el registro de un anticipo o pago asociado a un documento financiero
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 18-11-2021
     *
     */
    TYPE Lr_DocFinAnticPago IS RECORD (
      Id_Documento          Info_Documento_Financiero_Cab.Id_Documento%TYPE,
      Numero_Factura_Sri    Info_Documento_Financiero_Cab.Numero_Factura_Sri%TYPE,
      Tipo_Documento_Id     Info_Documento_Financiero_Cab.Tipo_Documento_Id%TYPE,
      Codigo_Tipo_Documento Admi_Tipo_Documento_Financiero.Codigo_Tipo_Documento%TYPE,
      Movimiento            Admi_Tipo_Documento_Financiero.Movimiento%TYPE,
      Valor_Total           Info_Documento_Financiero_Cab.Valor_Total%TYPE,
      Fe_Creacion           Estado_Cuenta_Cliente.Fe_Creacion%TYPE,
      Fec_Creacion          Estado_Cuenta_Cliente.Fec_Creacion%TYPE,
      Fec_Emision           Estado_Cuenta_Cliente.Fec_Emision%TYPE,
      Fec_Autorizacion      Estado_Cuenta_Cliente.Fec_Autorizacion%TYPE,
      Punto_Id              Info_Documento_Financiero_Cab.Punto_Id%TYPE,
      Oficina_Id            Info_Documento_Financiero_Cab.Oficina_Id%TYPE,
      Referencia            Estado_Cuenta_Cliente.Referencia%TYPE,
      Codigo_Forma_Pago     Estado_Cuenta_Cliente.Codigo_Forma_Pago%TYPE,
      Numero_Referencia     Info_Pago_Det.Numero_Referencia%TYPE,
      Numero_Cuenta_Banco   Info_Pago_Det.Numero_Cuenta_Banco%TYPE,
      Referencia_Id         Info_Pago_Det.Referencia_Id%TYPE,
      Comentario            Info_Pago_Det.Comentario%TYPE);
      
    /*
     * Documentacion para TYPE 'Ltr_DocFinAnticPago'.
     * Record que me permite obtener los registros de los anticipos o pagos asociados a documentos financieros
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 18-11-2021
     *
     */
    TYPE Ltr_DocFinAnticPago IS TABLE OF Lr_DocFinAnticPago INDEX BY binary_integer;
    
    /*
     * Documentacion para TYPE 'Lr_DocFinancieroOg'.
     * Record que me permite obtener el registro de un documento financiero en OG
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 18-11-2021
     *
     */
    TYPE Lr_DocFinancieroOg IS RECORD (
      Id_Documento          Info_Documento_Financiero_Cab.Id_Documento%TYPE,
      Numero_Factura_Sri    Info_Documento_Financiero_Cab.Numero_Factura_Sri%TYPE,
      Tipo_Documento_Id     Info_Documento_Financiero_Cab.Tipo_Documento_Id%TYPE,
      Codigo_Tipo_Documento Admi_Tipo_Documento_Financiero.Codigo_Tipo_Documento%TYPE,
      Movimiento            Admi_Tipo_Documento_Financiero.Movimiento%TYPE,
      Valor_Total           Info_Documento_Financiero_Cab.Valor_Total%TYPE,
      Fe_Creacion           Estado_Cuenta_Cliente.Fe_Creacion%TYPE,
      Punto_Id              Info_Documento_Financiero_Cab.Punto_Id%TYPE,
      Oficina_Id            Info_Documento_Financiero_Cab.Oficina_Id%TYPE,
      Referencia            Estado_Cuenta_Cliente.Referencia%TYPE,
      Codigo_Forma_Pago     Estado_Cuenta_Cliente.Codigo_Forma_Pago%TYPE,
      Numero_Referencia     Info_Pago_Det.Numero_Referencia%TYPE,
      Numero_Cuenta_Banco   Info_Pago_Det.Numero_Cuenta_Banco%TYPE,
      Referencia_Id         Info_Pago_Det.Referencia_Id%TYPE);
      
    /*
     * Documentacion para TYPE 'Ltr_DocFinancieroOg'.
     * Record que me permite obtener los registros de los documentos financieros en OG
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 18-11-2021
     *
     */
    TYPE Ltr_DocFinancieroOg IS TABLE OF Lr_DocFinancieroOg INDEX BY binary_integer;
    
    /*
     * Documentacion para TYPE 'Lr_AnticipoPago'.
     * Record que me permite obtener el registro de un anticipo o pago
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 18-11-2021
     *
     */
    TYPE Lr_AnticipoPago IS RECORD (
      Id_Pago               Info_Pago_Cab.Id_Pago%TYPE,
      Numero_Pago           Info_Pago_Cab.Numero_Pago%TYPE,
      Tipo_Documento_Id     Admi_Tipo_Documento_Financiero.Id_Tipo_Documento%TYPE,
      Codigo_Tipo_Documento Admi_Tipo_Documento_Financiero.Codigo_Tipo_Documento%TYPE,
      Movimiento            Admi_Tipo_Documento_Financiero.Movimiento%TYPE,
      Valor_Total           Info_Pago_Cab.Valor_Total%TYPE,
      Fe_Creacion           Info_Pago_Cab.Fe_Creacion%TYPE,
      Punto_Id              Info_Pago_Cab.Punto_Id%TYPE,
      Oficina_Id            Info_Pago_Cab.Oficina_Id%TYPE,
      Id_Recaudacion        Info_Recaudacion.Id_Recaudacion%TYPE);
      
    /*
     * Documentacion para TYPE 'Ltr_AnticipoPago'.
     * Record que me permite obtener los registros de anticipos o pagos
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 18-11-2021
     *
     */
    TYPE Ltr_AnticipoPago IS TABLE OF Lr_AnticipoPago INDEX BY binary_integer;
    
    /*
     * Documentacion para TYPE 'Ltr_InfoDocRelacionado'.
     * Record que me permite obtener los registros de documentos relacionados
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 19-11-2021
     *
     */
    TYPE Ltr_InfoDocRelacionado IS TABLE OF FNKG_TYPES.Lr_InfoDocRelacionados INDEX BY binary_integer;

    /*
     * Documentacion para TYPE 'Lr_EstadoCuenta'.
     * Record que me permite obtener el registro del estado de cuenta
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 19-11-2021
     *
     */
    TYPE Lr_EstadoCuenta IS RECORD (
      Id_Documento          VARCHAR2(50),
      Valor_Ingreso         NUMBER,
      Valor_Egreso          NUMBER,
      Valor_Acumulado       NUMBER,
      Fecha_Creacion        TIMESTAMP,
      Fecha_Emision         TIMESTAMP,
      Fecha_Autorizacion    TIMESTAMP,
      Codigo_Tipo_Documento VARCHAR2(4),
      Login                 VARCHAR2(60),
      Nombre_Oficina        VARCHAR2(100),
      Referencia            VARCHAR2(50),
      Codigo_Forma_Pago     VARCHAR2(4),
      Numero                VARCHAR2(80),
      Observacion           CLOB,
      Es_Suma_Valor_Total   VARCHAR2(1),
      Movimiento            Admi_Tipo_Documento_Financiero.Movimiento%TYPE,
      Pago_Tiene_Depend     VARCHAR2(3),
      Saldo_Actual_Doc      NUMBER);
      
    /*
     * Documentacion para TYPE 'Ltr_EstadoCuenta'.
     * Record que me permite obtener los registros del estado de cuenta
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 19-11-2021
     *
     */
    TYPE Ltr_EstadoCuenta IS TABLE OF Lr_EstadoCuenta INDEX BY binary_integer; 
    
    /*
     * Documentacion para TYPE 'Lr_AnticNoAplic'.
     * Record que me permite obtener el registro del anticipo no aplicado o pendiente
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 22-11-2021
     *
     */
    TYPE Lr_AnticNoAplic IS RECORD (
      Id_Documento          Info_Documento_Financiero_Cab.Id_Documento%TYPE,
      Numero_Factura_Sri    Info_Documento_Financiero_Cab.Numero_Factura_Sri%TYPE,
      Estado_Impresion_Fact Info_Documento_Financiero_Cab.Estado_Impresion_Fact%TYPE,
      Precio                VARCHAR2(30),
      Fecha_Creacion        TIMESTAMP,
      Numero_Referencia     Info_Pago_Det.Numero_Referencia%TYPE,
      Descripcion_Banco     DB_GENERAL.Admi_Banco.Descripcion_Banco%TYPE,
      Descripcion_Contable  DB_GENERAL.Admi_Banco.Descripcion_Banco%TYPE,
      Codigo_Tipo_Documento Admi_Tipo_Documento_Financiero.Codigo_Tipo_Documento%TYPE,
      Codigo_Forma_Pago     Estado_Cuenta_Cliente.Codigo_Forma_Pago%TYPE);
    
    /*
     * Documentacion para TYPE 'Ltr_AnticNoAplic'.
     * Record que me permite obtener los registros de anticipos no aplicados o pendientes
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 22-11-2021
     *
     */
    TYPE Ltr_AnticNoAplic IS TABLE OF Lr_AnticNoAplic INDEX BY binary_integer; 
    
    /*
     * Documentacion para TYPE 'Lr_AnticGenerado'.
     * Record que me permite obtener el registro del anticipo generado
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 22-11-2021
     *
     */
    TYPE Lr_AnticGenerado IS RECORD (
      Codigo_Tipo_Documento Admi_Tipo_Documento_Financiero.Codigo_Tipo_Documento%TYPE,
      Numero_Pago           Info_Pago_Cab.Numero_Pago%TYPE,
      Estado_Pago           Info_Pago_Cab.Estado_Pago%TYPE,
      Valor_Pago            Info_Pago_Det.Valor_Pago%TYPE,
      Codigo_Forma_Pago     Estado_Cuenta_Cliente.Codigo_Forma_Pago%TYPE,
      Fecha_Creacion        VARCHAR2(30),
      Numero_Referencia     Info_Pago_Det.Numero_Referencia%TYPE,
      Descripcion_Banco     DB_GENERAL.Admi_Banco.Descripcion_Banco%TYPE,
      Descripcion_Contable  DB_GENERAL.Admi_Banco.Descripcion_Banco%TYPE,
      Id_Pago_Det           Info_Pago_Det.Id_Pago_Det%TYPE
      );
    
    /*
     * Documentacion para TYPE 'Ltr_AnticGenerado'.
     * Record que me permite obtener los registros de anticipos generados
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 22-11-2021
     *
     */
    TYPE Ltr_AnticGenerado IS TABLE OF Lr_AnticGenerado INDEX BY binary_integer;
    
    /*
     * Documentacion para TYPE 'Lr_DocEstadoCuenta'.
     * Record que me permite obtener el registro de un documento para estado de cuenta
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 24-11-2021
     *
     */
    TYPE Lr_DocEstadoCuenta IS RECORD (
      idConsulta            NUMBER,
      Id_Documento          Info_Documento_Financiero_Cab.Id_Documento%TYPE,
      Punto_Id              Info_Documento_Financiero_Cab.Punto_Id%TYPE,
      Oficina_Id            Info_Documento_Financiero_Cab.Oficina_Id%TYPE,
      Numero_Factura_Sri    Info_Documento_Financiero_Cab.Numero_Factura_Sri%TYPE,
      Tipo_Documento_Id     Info_Documento_Financiero_Cab.Tipo_Documento_Id%TYPE,
      Valor_Total           Info_Documento_Financiero_Cab.Valor_Total%TYPE,
      Fe_Creacion           Estado_Cuenta_Cliente.Fe_Creacion%TYPE,
      Fec_Creacion          Estado_Cuenta_Cliente.Fec_Creacion%TYPE,
      Fec_Emision           Estado_Cuenta_Cliente.Fec_Emision%TYPE,
      Fec_Autorizacion      Estado_Cuenta_Cliente.Fec_Autorizacion%TYPE,
      Usr_Creacion          Info_Documento_Financiero_Cab.Usr_Creacion%TYPE,
      Referencia            Estado_Cuenta_Cliente.Referencia%TYPE,
      Codigo_Forma_Pago     Estado_Cuenta_Cliente.Codigo_Forma_Pago%TYPE,
      Estado_Impresion_Fact Info_Documento_Financiero_Cab.Estado_Impresion_Fact%TYPE,
      Numero_Referencia     Info_Pago_Det.Numero_Referencia%TYPE,
      Numero_Cuenta_Banco   Info_Pago_Det.Numero_Cuenta_Banco%TYPE,
      Referencia_Id         Info_Pago_Det.Referencia_Id%TYPE,
      Migracion             Info_Documento_Financiero_Cab.Num_Fact_Migracion%TYPE,
      Ref_Anticipo_Id       Info_Pago_Cab.Anticipo_Id%TYPE,
      Codigo_Tipo_Documento Admi_Tipo_Documento_Financiero.Codigo_Tipo_Documento%TYPE,
      Movimiento            Admi_Tipo_Documento_Financiero.Movimiento%TYPE,
      Pago_Tiene_Depend     VARCHAR2(3),
      Saldo_Actual_Doc      NUMBER);
      
    /*
     * Documentacion para TYPE 'Ltr_DocEstadoCuenta'.
     * Record que me permite obtener los registros de documentos para estado de cuenta
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 22-11-2021
     *
     */
    TYPE Ltr_DocEstadoCuenta IS TABLE OF Lr_DocEstadoCuenta INDEX BY binary_integer;
    
    /*
     * Documentacion para TYPE 'Lr_DocumentoCabecera'.
     * Record que me permite obtener el registro de un documento cabecera
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 29-11-2021
     *
     */
    TYPE Lr_DocumentoCabecera IS RECORD (
      Id_Documento            Info_Documento_Financiero_Cab.Id_Documento%TYPE,
      Oficina_Id              Info_Documento_Financiero_Cab.Oficina_Id%TYPE,
      Nombre_Oficina          Db_Comercial.Info_Oficina_Grupo.Nombre_Oficina%TYPE,
      Punto_Id                Info_Documento_Financiero_Cab.Punto_Id%TYPE,
      Tipo_Documento_Id       Info_Documento_Financiero_Cab.Tipo_Documento_Id%TYPE,
      Nombre_Tipo_Documento   Admi_Tipo_Documento_Financiero.Nombre_Tipo_Documento%TYPE,
      Numero_Factura_Sri      Info_Documento_Financiero_Cab.Numero_Factura_Sri%TYPE,
      Subtotal                Info_Documento_Financiero_Cab.Subtotal%TYPE,      
      Subtotal_Cero_Impuesto  Info_Documento_Financiero_Cab.Subtotal_Cero_Impuesto%TYPE,
      Subtotal_Con_Impuesto   Info_Documento_Financiero_Cab.Subtotal_Con_Impuesto%TYPE,
      Subtotal_Descuento      Info_Documento_Financiero_Cab.Subtotal_Descuento%TYPE,  
      Subtotal_Ice            Info_Documento_Financiero_Cab.Subtotal_Ice%TYPE,  
      Subtotal_Servicios      Info_Documento_Financiero_Cab.Subtotal_Servicios%TYPE,  
      Impuestos_Servicios     Info_Documento_Financiero_Cab.Impuestos_Servicios%TYPE,  
      Subtotal_Bienes         Info_Documento_Financiero_Cab.Subtotal_Bienes%TYPE,  
      Impuestos_Bienes        Info_Documento_Financiero_Cab.Impuestos_Bienes%TYPE, 
      Descuento_Compensacion  Info_Documento_Financiero_Cab.Descuento_Compensacion%TYPE, 
      Establecimiento         Info_Documento_Financiero_Cab.Establecimiento%TYPE, 
      Emision                 Info_Documento_Financiero_Cab.Emision%TYPE,
      Secuencia               Info_Documento_Financiero_Cab.Secuencia%TYPE,
      Valor_Total             Info_Documento_Financiero_Cab.Valor_Total%TYPE,
      Entrego_Retencion_Fte   Info_Documento_Financiero_Cab.Entrego_Retencion_Fte%TYPE,
      Estado_Impresion_Fact   Info_Documento_Financiero_Cab.Estado_Impresion_Fact%TYPE,  
      Es_Automatica           Info_Documento_Financiero_Cab.Es_Automatica%TYPE,  
      Prorrateo               Info_Documento_Financiero_Cab.Prorrateo%TYPE, 
      Reactivacion            Info_Documento_Financiero_Cab.Reactivacion%TYPE, 
      Recurrente              Info_Documento_Financiero_Cab.Recurrente%TYPE, 
      Comisiona               Info_Documento_Financiero_Cab.Comisiona%TYPE,
      Num_Fact_Migracion      Info_Documento_Financiero_Cab.Num_Fact_Migracion%TYPE,   
      Observacion             Info_Documento_Financiero_Cab.Observacion%TYPE, 
      Referencia_Documento_Id Info_Documento_Financiero_Cab.Referencia_Documento_Id%TYPE, 
      Login_Md                Info_Documento_Financiero_Cab.Login_Md%TYPE, 
      Es_Electronica          Info_Documento_Financiero_Cab.Es_Electronica%TYPE, 
      Rango_Consumo           Info_Documento_Financiero_Cab.Rango_Consumo%TYPE, 
      Fe_Emision              Info_Documento_Financiero_Cab.Fe_Emision%TYPE, 
      Numero_Autorizacion     Info_Documento_Financiero_Cab.Numero_Autorizacion%TYPE, 
      Fe_Autorizacion         Info_Documento_Financiero_Cab.Fe_Autorizacion%TYPE, 
      Contabilizado           Info_Documento_Financiero_Cab.Contabilizado%TYPE, 
      Mes_Consumo             Info_Documento_Financiero_Cab.Mes_Consumo%TYPE, 
      Anio_Consumo            Info_Documento_Financiero_Cab.Anio_Consumo%TYPE, 
      Fe_Creacion             Info_Documento_Financiero_Cab.Fe_Creacion%TYPE, 
      Usr_Creacion            Info_Documento_Financiero_Cab.Usr_Creacion%TYPE);
      
    /*
     * Documentacion para TYPE 'Ltr_DocumentoDetalle'.
     * Record que me permite obtener los registros de documentos cabecera
     * @author David De La Cruz <ddelacruz@telconet.ec>
     * @version 1.0
     * @since 29-11-2021
     *
     */
    TYPE Ltr_DocumentoCabecera IS TABLE OF Lr_DocumentoCabecera INDEX BY binary_integer; 

END FNKG_TYPES_DOCUMENTOS;
/