/**
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0
 * @since 28/05/2022    
 * Se crea sentencia DDL para creación del paquete FNCK_PAGOS_LINEA  
 * del esquema DB_FINANCIERO.
 */
--HEADER PACKAGE
create or replace PACKAGE DB_FINANCIERO.FNCK_PAGOS_LINEA AS 
    /**
    * Documentación para P_CONSULTAR_SALDO_POR_IDENTIFICACION
    * Procedimiento que realiza la consulta de saldo por identificacion
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.1 17/06/2022 - Cambio de parametros de entrada y salida
    *
    * @param Pcl_Request IN CLOB (identificación de cliente y código de empresa)
    * @param Pv_Status OUT VARCHAR2 estado
    * @param Pv_Mensaje OUT VARCHAR2 Devuelve el mensaje de respuesta
    * @param Pcl_Response OUT CLOB Devuelve respuesta con data
    */ 
    PROCEDURE P_CONSULTAR_SALDO_POR_IDENTIF(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB);

    /**
    * Documentacion para la funcion F_OBTENER_SUMA_VALOR_PENDIENTE
    *
    * La funcion retorna la suma de los valores pendientes de un cliente dependiendo de su código de Empresa e  
    * identificación
    *
    * @param Fv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Fv_EmpresaCod IN VARCHAR2 código de empresa
    * return Fn_ValorPendiente NUMBER
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    */
    FUNCTION F_OBTENER_SUMA_VALOR_PENDIENTE(Fv_Identificacion IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2)
    RETURN NUMBER;

    /**
    * Documentacion para la funcion F_BUSCAR_NUM_CONTRATO
    *
    * La funcion retorna el numero de contrato de un cliente dependiendo de su código de Empresa,  
    * identificación, y/o estado del contrato
    *
    * @param Fv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Fv_EmpresaCod IN VARCHAR2 código de empresa
    * @param Fv_Estado IN VARCHAR2 estado de contrato del cliente
    * return Fv_NumeroContrato VARCHAR2
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    */
    FUNCTION F_BUSCAR_NUM_CONTRATO(Fv_Identificacion IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2, Fv_Estado IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2;

    /**
    * Documentacion para la funcion F_OBTENER_SALDOS_POR_IDENTIF
    *
    * La funcion retorna la registros (cursor) de un cliente y su saldo dependiendo de su código de Empresa e  
    * identificación
    *
    * @param Fv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Fv_EmpresaCod IN VARCHAR2 código de empresa
    * return Fc_GetSaldoPendiente SYS_REFCURSOR
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    */
    FUNCTION F_OBTENER_SALDOS_POR_IDENTIF(Fv_Identificacion IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2)
    RETURN SYS_REFCURSOR;

    /**
    * Documentacion para la funcion F_OBTENER_PAGO_LINEA
    *
    * La funcion retorna pago en linea por nombre del canal y numero de referencia  
    *
    * @param Fv_NombreCanal IN VARCHAR2 nombre del canal de pago
    * @param Fv_NumeroRef IN VARCHAR2 numero de referencia de pago
    * return Fc_PagoLinea SYS_REFCURSOR
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 09/06/2022
    */
    FUNCTION F_OBTENER_PAGO_LINEA(Fv_NombreCanal IN VARCHAR2, Fv_NumeroRef IN VARCHAR2)
    RETURN SYS_REFCURSOR;

    /**
    * Documentacion para la funcion F_OBTENER_CANAL_PAGO_LINEA
    *
    * La funcion retorna canal de pago en linea por nombre  
    *
    * @param Fv_NombreCanal IN VARCHAR2 nombre del canal de pago
    * return Fc_CanalPago SYS_REFCURSOR
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 09/06/2022
    */
    FUNCTION F_OBTENER_CANAL_PAGO_LINEA(Fv_NombreCanal IN VARCHAR2)
    RETURN SYS_REFCURSOR;

    /**
    * Documentación para TYPE 'Lr_ParametrosDetalle'.
    *  
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 11/07/2022
    */
    TYPE Lr_ParametrosDetalle IS RECORD (
      ID_PARAMETRO_DET          DB_GENERAL.ADMI_PARAMETRO_DET.ID_PARAMETRO_DET%TYPE,
      PARAMETRO_ID              DB_GENERAL.ADMI_PARAMETRO_DET.PARAMETRO_ID%TYPE,
      DESCRIPCION               DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
      VALOR1                    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
      VALOR2                    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
      VALOR3                    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
      VALOR4                    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE,
      ESTADO                    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
      USR_CREACION              DB_GENERAL.ADMI_PARAMETRO_DET.USR_CREACION%TYPE,
      FE_CREACION               DB_GENERAL.ADMI_PARAMETRO_DET.FE_CREACION%TYPE,
      IP_CREACION               DB_GENERAL.ADMI_PARAMETRO_DET.IP_CREACION%TYPE,
      USR_ULT_MOD               DB_GENERAL.ADMI_PARAMETRO_DET.USR_ULT_MOD%TYPE,
      FE_ULT_MOD                DB_GENERAL.ADMI_PARAMETRO_DET.FE_ULT_MOD%TYPE,
      IP_ULT_MOD                DB_GENERAL.ADMI_PARAMETRO_DET.IP_ULT_MOD%TYPE, 
      VALOR5                    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
      EMPRESA_COD               DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
      VALOR6                    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR6%TYPE,
      VALOR7                    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE,
      OBSERVACION               DB_GENERAL.ADMI_PARAMETRO_DET.OBSERVACION%TYPE);

    /**
    * Documentación para TYPE 'T_ParametrosDetalle'.
    *  
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 11/07/2022
    */                   
    TYPE T_ParametrosDetalle IS TABLE OF Lr_ParametrosDetalle INDEX BY PLS_INTEGER;
    
    /**
    * Documentación para TYPE 'Lr_PuntoCliente'.
    *  
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 11/07/2022
    */
    TYPE Lr_PuntoCliente IS RECORD (
      ID_PUNTO          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE);

    /**
    * Documentación para TYPE 'T_PuntoCliente'.
    *  
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 11/07/2022
    */                   
    TYPE T_PuntoCliente IS TABLE OF Lr_PuntoCliente INDEX BY PLS_INTEGER;

    /**
    * Documentación para TYPE 'Lr_Persona'.
    *  
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 11/07/2022
    */
    TYPE Lr_Persona IS RECORD (
      ID_PERSONA          DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE);
    
    /**
    * Documentación para TYPE 'T_Persona'.
    *  
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 11/07/2022
    */                   
    TYPE T_Persona IS TABLE OF Lr_Persona INDEX BY PLS_INTEGER;

    /**
    * Documentación para P_PROCESAR_PAGO_LINEA
    * Procedimiento que realiza pago en linea
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 01/07/2022
    *
    * @param Pcl_Request IN CLOB
    * @param Pv_Status OUT VARCHAR2 estado
    * @param Pv_Mensaje OUT VARCHAR2 Devuelve el mensaje de respuesta
    * @param Pcl_Response OUT CLOB Devuelve respuesta con data
    */ 
    PROCEDURE P_PROCESAR_PAGO_LINEA(Pcl_Request IN CLOB, 
                                    Pv_Status OUT VARCHAR2, 
                                    Pv_Mensaje OUT VARCHAR2,
                                    Pcl_Response OUT CLOB);

    /**
    * Documentacion para el procedimiento P_VALIDAR_CREDENCIALES
    *
    * El procedimiento valida credenciales de canal de pago y cliente retornando verdadero si son correctas  
    *
    * @param Pcl_Request IN CLOB request
    * @param Pv_Status OUT VARCHAR2 Codigo de respuesta
    * @param Pv_Mensaje OUT VARCHAR2 Mensaje
    * @param Pb_Response OUT BOOLEAN
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 27/06/2022
    */
    PROCEDURE P_VALIDAR_CREDENCIALES(Pcl_Request IN CLOB, 
                                     Pv_Status OUT VARCHAR2, 
                                     Pv_Mensaje OUT VARCHAR2, 
                                     Pb_Response OUT BOOLEAN);

    /**
    * Documentacion para el procedimiento P_VALIDAR_PROCESO
    *
    * El procedimiento valida informacion de acuerdo al proceso de bus de pagos  
    *
    * @param Pcl_Request IN CLOB request
    * @param Pv_Status OUT VARCHAR2 Codigo de respuesta
    * @param Pv_Mensaje OUT VARCHAR2 Mensaje
    * @param Pb_Response OUT BOOLEAN
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 07/07/2022
    */
    PROCEDURE P_VALIDAR_PROCESO(Pcl_Request IN CLOB,
                                     Pv_Status OUT VARCHAR2, 
                                     Pv_Mensaje OUT VARCHAR2, 
                                     Pb_Response OUT BOOLEAN);

    /**
    * Documentacion para el procedimiento P_INSERT_INFO_PAGO_LINEA
    *
    * El procedimiento permite insertar registros en tabla InfoPagoLinea  
    *
    * @param Pr_InfoPagoLinea IN DB_FINANCIERO.INFO_PAGO_LINEA%ROWTYPE data
    * @param Pv_MsnError OUT VARCHAR2 Mensaje de Error
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 06/07/2022
    */
    PROCEDURE P_INSERT_INFO_PAGO_LINEA(
        Pr_InfoPagoLinea    IN  DB_FINANCIERO.INFO_PAGO_LINEA%ROWTYPE,
        Pv_MsnError         OUT VARCHAR2);                                 

    /**
    * Documentacion para la funcion F_OBTENER_MAIL_FONO_POR_IDENT
    *
    * La funcion retorna Mail y/o Telefono del cliente 
    *
    * @param Fv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Fn_NumCarac IN VARCHAR2 Limite de caracteres
    * @param Fv_TipoData IN VARCHAR2 Tipo de Data
    * @param Fv_Todos IN VARCHAR2 Variable Todos
    * @param Fv_MailDefault IN VARCHAR2 Mail default
    * return Fcl_Mail CLOB Mail de Cliente
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 08/07/2022
    */
    FUNCTION F_OBTENER_MAIL_FONO_POR_IDENT(Fv_Identificacion IN VARCHAR2, 
                                            Fn_NumCarac IN NUMBER,
                                            Fv_TipoData IN VARCHAR2,
                                            Fv_Todos IN VARCHAR2,
                                            Fv_MailDefault IN VARCHAR2)
    RETURN CLOB;

    /**
    * Documentación para P_CONCILIAR_PAGO_LINEA
    * Procedimiento que realiza pago en linea
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 01/07/2022
    *
    * @param Pcl_Request IN CLOB
    * @param Pv_Status OUT VARCHAR2 estado
    * @param Pv_Mensaje OUT VARCHAR2 Devuelve el mensaje de respuesta
    * @param Pcl_Response OUT CLOB Devuelve respuesta con data
    */ 
    PROCEDURE P_CONCILIAR_PAGO_LINEA(Pcl_Request IN CLOB, 
                                    Pv_Status OUT VARCHAR2, 
                                    Pv_Mensaje OUT VARCHAR2,
                                    Pcl_Response OUT CLOB);

    /**
    * Documentación para F_REAC_SERVICIO_X_PAGO_LINEA
    * Funcion que realiza reactivacion masiva
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fcl_Request IN CLOB (ID_CANAL_PAGO_LINEA, PREFIJO_EMPRESA_SESSION, ID_EMPRESA, USR_CREACION, ID_PAGO_LINEA)
    * @param RETURN CLOB;
    */ 
    FUNCTION F_REAC_SERVICIO_X_PAGO_LINEA(Fcl_Request IN CLOB) RETURN CLOB;

    /**
    * Documentación para F_OBTENER_PUNTOS_REACTIVAR
    * Funcion que realiza reactivacion masiva
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_Id_Recaudacion IN VARCHAR2  id recaudacion
    * @param Fv_Id_Pago_Linea IN VARCHAR2 pago linea
    * @param Fv_Empresa_Id IN VARCHAR2 id empresa
    * @param RETURN CLOB Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_PUNTOS_REACTIVAR(Fv_Id_Recaudacion IN VARCHAR2,Fv_Id_Pago_Linea IN VARCHAR2, Fv_Empresa_Id IN VARCHAR2) RETURN CLOB;


    /**
    * Documentación para F_OBTENER_SALDOS_PUNTOS_REAC
    * Funcion que sirve para obtener los servicios a reactivar
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_Id_Recaudacion IN VARCHAR2  id recaudacion
    * @param Fv_Id_Pago_Linea IN VARCHAR2 pago linea
    * @param Fv_Empresa_Id IN VARCHAR2 id empresa
    * @param RETURN CLOB Devuelve respuesta con data
    */  
    FUNCTION F_OBTENER_SALDOS_PUNTOS_REAC(Fv_id_Recaudacion IN VARCHAR2, Fv_id_Pago_Linea IN VARCHAR2) RETURN SYS_REFCURSOR ;

    /**
    * Documentación para F_OBTENER_PUNTOS_X_ULT_MILLA
    * Funcion que realiza reactivacion masiva
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_Id_Punto IN VARCHAR2  Id punto
    * @param RETURN CLOB Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_PUNTOS_X_ULT_MILLA(Fv_Id_Punto IN VARCHAR2) RETURN CLOB;

    /**
    * Documentación para F_GUARDAR_PUNTOS_REACT_MASIVO
    * Funcion que guardado en los esquemas de reactivacion masiva
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param fr_request IN CLOB  Id punto
    * @param RETURN NUMBER Devuelve respuesta con el id de reactivacion
    */ 
    FUNCTION F_GUARDAR_PUNTOS_REACT_MASIVO(fr_request IN CLOB)  RETURN NUMBER; 

    /**
    * Documentación para F_REACTIVAR_SERVICIOS_TTCO
    * Funcion para reactivacion TTCO
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_Punto_Reactivar IN VARCHAR2  puntos a reactiva
    * @param Fv_Usr_Creacion IN VARCHAR2 usuarios creacion
    * @param Fv_Cliente_Ip IN VARCHAR2 Ip cliente
    * @param Fv_Proceso IN VARCHAR2 proceso ejecucion
    * @param RETURN boolean estado de la operacion true/false
    */
    FUNCTION F_REACTIVAR_SERVICIOS_TTCO(Fv_Punto_Reactivar IN  varchar2, Fv_Usr_Creacion IN varchar2, Fv_Cliente_Ip  IN varchar2, Fv_Proceso IN varchar2) RETURN boolean;

    /*
    * Documentación para TYPE 'Lr_DocumentosFinancieros'.
    *  
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 11/07/2022
    */
    TYPE Lr_DocumentosFinancieros
    IS
      RECORD
      (
        ID_DOCUMENTO                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE, 
        OFICINA_ID                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OFICINA_ID%TYPE, 
        PUNTO_ID                      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE, 
        TIPO_DOCUMENTO_ID             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE,
        NUMERO_FACTURA_SRI            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE, 
        SUBTOTAL                      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE, 
        SUBTOTAL_CERO_IMPUESTO        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CERO_IMPUESTO%TYPE,
        SUBTOTAL_CON_IMPUESTO         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE, 
        SUBTOTAL_DESCUENTO            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE, 
        VALOR_TOTAL                   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE, 
        ENTREGO_RETENCION_FTE         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ENTREGO_RETENCION_FTE%TYPE, 
        ESTADO_IMPRESION_FACT         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE, 
        ES_AUTOMATICA                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_AUTOMATICA%TYPE, 
        PRORRATEO                     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PRORRATEO%TYPE, 
        REACTIVACION                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PRORRATEO%TYPE, 
        RECURRENTE                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.RECURRENTE%TYPE, 
        COMISIONA                     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.COMISIONA%TYPE, 
        FE_CREACION                   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_CREACION%TYPE, 
        FE_EMISION                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE, 
        USR_CREACION                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE, 
        NUM_FACT_MIGRACION            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUM_FACT_MIGRACION%TYPE,
        OBSERVACION                   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE, 
        REFERENCIA_DOCUMENTO_ID       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.REFERENCIA_DOCUMENTO_ID%TYPE, 
        ES_ELECTRONICA                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ES_ELECTRONICA%TYPE,
        FE_AUTORIZACION               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_AUTORIZACION%TYPE, 
        MES_CONSUMO                   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.MES_CONSUMO%TYPE, 
        ANIO_CONSUMO                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ANIO_CONSUMO%TYPE, 
        RANGO_CONSUMO                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.RANGO_CONSUMO%TYPE,
        DESCUENTO_COMPENSACION        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE,
        SALDO_FACTURA                 NUMBER);

    /*
    * Documentación para TYPE 'T_DocumentosFiancieros'.
    *  
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 11/07/2022
    */
    TYPE T_DocumentosFiancieros IS TABLE OF Lr_DocumentosFinancieros INDEX BY PLS_INTEGER;

    /*
    * Documentación para TYPE 'Lr_InfoCliente'.
    *  
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 11/07/2022
    */
    TYPE Lr_InfoCliente
    IS
    RECORD
    (
      ID_PERSONA_ROL              DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
      ESTADO                      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ESTADO%TYPE,
      ID_EMPRESA_ROL              DB_COMERCIAL.INFO_EMPRESA_ROL.ID_EMPRESA_ROL%TYPE
    );

    /*
    * Documentación para TYPE 'T_InfoCliente'.
    *  
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 11/07/2022
    */
    TYPE T_InfoCliente IS TABLE OF Lr_InfoCliente INDEX BY PLS_INTEGER;

    /**
    * Documentación para F_OBTENER_SALDOS_PUNTOS
    * Procedimiento que realiza la consulta de saldo por id_persona
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_IdPersona IN VARCHAR2  id persona
    * @param Fv_EmpresaCod IN VARCHAR2 codigo empresa
    * @param RETURN SYS_REFCURSOR Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_SALDOS_PUNTOS(Fv_IdPersona IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2)
        RETURN SYS_REFCURSOR;

    /**
    * Documentación para F_OBTENER_FACTURAS_ABIERTAS
    * Procedimiento que realiza la consulta de las facturas abiertas y el saldo por los puntos del cliente
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    * 
    * @param Fv_IdPersona IN VARCHAR2  id persona
    * @param Fv_EmpresaCod IN VARCHAR2 codigo empresa
    * @param RETURN SYS_REFCURSOR Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_FACTURAS_ABIERTAS(Fv_IdPersona IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2)
        RETURN SYS_REFCURSOR;

    /**
    * Documentación para F_VALIDAR_PAGO_EXISTENTE
    * Procedimiento que realiza la validacion de si existe un pago
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    * 
    * @param Fc_request IN CLOB data
    * @param RETURN BOOLEAN Devuelve respuesta
    */  
    FUNCTION F_VALIDAR_PAGO_EXISTENTE(Fc_request IN CLOB)
        RETURN BOOLEAN;

    /**
    * Documentación para F_OBTENER_INFORMACION_CLIENTE
    * Procedimiento que realiza la consulta de la informacion del cliente
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    * 
    * @param Fv_persona_id IN VARCHAR2  id persona
    * @param Fv_EmpresaCod IN VARCHAR2 codigo empresa
    * @param Fv_roles_desc IN VARCHAR2 descripcion del rol
    * @param Fv_estados IN VARCHAR2 estados a evaluar
    * @param RETURN SYS_REFCURSOR Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_INFORMACION_CLIENTE(Fv_persona_id IN VARCHAR2, Fv_roles_desc IN VARCHAR2, Fv_empresa_cod IN VARCHAR2, Fv_estados IN VARCHAR2)
        RETURN SYS_REFCURSOR;

    /**
    * Documentación para F_OBTENER_RECAUDACION_CARACT
    * Procedimiento que realiza la consulta de la caracteristica de la recaudacion
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/202
    *
    * @param Fv_EmpresaCod IN VARCHAR2 codigo empresa
    * @param Fv_CanalRecaudacionId IN NUMBER id canal recaudacion
    * @param Fv_DescripcionCaracteristica IN VARCHAR2 descripcion caracteristica
    * @param Fv_estado IN VARCHAR2 estados 
    * @param RETURN SYS_REFCURSOR Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_RECAUDACION_CARACT(Fv_EmpresaCod IN VARCHAR2, Fv_CanalRecaudacionId IN NUMBER, Fv_DescripcionCaracteristica IN VARCHAR2, Fv_Estado IN VARCHAR2)
        RETURN SYS_REFCURSOR;

    /**
    * Documentación para F_GENERAR_PAGO_ANTICIPO
    * Procedimiento que realiza el pago de anticipo
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    * 
    * @param Fc_request IN CLOB data
    * @param RETURN CLOB Devuelve respuesta con data
    */ 
    FUNCTION F_GENERAR_PAGO_ANTICIPO(Fc_request IN CLOB)
        RETURN CLOB;

    /**
    * Documentacion para la funcion F_LLAMAR_JAR
    *
    * La funcion llama a archivo JAR de reactivacion de puntos RC
    *
    * @param Fv_Servicios IN VARCHAR2 puntos de servicios a reactivar
    * @param Fv_UsrCreacion IN VARCHAR2 usuario de creacion
    * @param Fv_ClienteIp IN VARCHAR2 ip del cliente
    * return Fv_Response VARCHAR2
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 26/07/2022
    */    
    FUNCTION F_LLAMAR_JAR(Fv_Servicios IN VARCHAR2, Fv_UsrCreacion IN VARCHAR2, Fv_ClienteIp IN VARCHAR2)
        RETURN VARCHAR2; 

    /**
   * Documentacion para P_GENERAR_TOKEN
   * Procedimiento que realiza el consumo de ws de generacion de Token.
   *
   * @author Javier Hidalgo <jihidalgo@telconet.ec>
   * @version 1.0 28/07/2022 
   *
   * @param Pv_UserName IN  VARCHAR2,
   * @param Pv_Password IN  VARCHAR2,
   * @param Pv_Name     IN  VARCHAR2,
   * @param Pv_Token    OUT VARCHAR2,
   * @param Pv_Status   OUT VARCHAR2,
   * @param Pv_Message  OUT VARCHAR2
   * @param Pv_MensajeError  OUT VARCHAR2
   */
     PROCEDURE P_GENERAR_TOKEN (Pv_UserName      IN VARCHAR2,
                                Pv_Password      IN VARCHAR2,
                                Pv_URL           IN VARCHAR2,
                                Pv_Name          IN VARCHAR2,
                                Pv_Token        OUT VARCHAR2,
                                Pv_Status       OUT VARCHAR2,
                                Pv_Message      OUT VARCHAR2,
                                Pv_MensajeError OUT VARCHAR2);

END FNCK_PAGOS_LINEA;
/

--BODY PACKAGE
create or replace PACKAGE BODY DB_FINANCIERO.FNCK_PAGOS_LINEA AS 
    /**************************************************************************
    **************************CONSULTAR PAGO***********************************
    **************************************************************************/

    /**
    * Documentación para P_CONSULTAR_SALDO_POR_IDENTIFICACION
    * Procedimiento que realiza la consulta de saldo por identificacion
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.1 17/06/2022 - Cambio de parametros de entrada y salida
    *
    * @param Pcl_Request IN CLOB (identificación de cliente y código de empresa)
    * @param Pv_Status OUT VARCHAR2 estado
    * @param Pv_Mensaje OUT VARCHAR2 Devuelve el mensaje de respuesta
    * @param Pcl_Response OUT CLOB Devuelve respuesta con data
    */ 
    PROCEDURE P_CONSULTAR_SALDO_POR_IDENTIF(Pcl_Request IN CLOB, 
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2,
                                            Pcl_Response OUT CLOB)
    AS
    Lb_ValidaCred         BOOLEAN;
    Lv_IdPersona          VARCHAR2(50);
    Lv_Identificacion     VARCHAR2(50);
    Lv_EmpresaCod         VARCHAR2(50);
    Lv_NumeroContrato     VARCHAR2(50);
    Lv_SaldoTotal         VARCHAR2(50);
    Lv_NombreCliente      VARCHAR2(500);
    Lv_RazonSocial        VARCHAR2(500);
    Lv_Nombres            VARCHAR2(500);
    Lv_Apellidos          VARCHAR2(500);
    Lv_Retorno            VARCHAR2(5);
    Lv_Error              VARCHAR2(500);
    Lv_NumCobros          VARCHAR2(5);
    Lv_TipoProducto       VARCHAR2(50);
    Lv_ValorRetener       VARCHAR2(50);
    Lv_BaseImp            VARCHAR2(50);
    Lv_Secuencial         VARCHAR2(50);
    Lv_PeriodoRec         VARCHAR2(50);
    Ld_Date               DATE;
    Ln_Saldo              NUMBER;
    Lnf_SaldoRes          NUMBER;
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_Where              CLOB;
    Lcl_OrderAnGroup       CLOB;
    Lcl_Response           SYS_REFCURSOR;
    Le_Errors              EXCEPTION;

    BEGIN
        Lv_SaldoTotal := '0';
        Lv_ValorRetener := '0.00';
        Lv_BaseImp := '0.00';
        Lv_NumCobros := '1';

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_CONSULTAR_SALDO_POR_IDENTIF',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        FNCK_PAGOS_LINEA.P_VALIDAR_CREDENCIALES(Pcl_Request, Lv_Retorno, Lv_Error, Lb_ValidaCred);

        IF Lb_ValidaCred THEN
            Lv_Retorno := '000';
            Lv_Error := null;
            Lv_Secuencial := null;

            APEX_JSON.PARSE(Pcl_Request);
            Lv_Identificacion  := APEX_JSON.get_varchar2(p_path => 'identificacionCliente'); 
            Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'codigoExternoEmpresa'); 
            Lv_TipoProducto := APEX_JSON.get_varchar2(p_path => 'tipoProducto'); 

            IF Lv_Identificacion IS NULL THEN
               Pv_Mensaje := 'El parámetro identificación está vacío';
               RAISE Le_Errors;
            END IF;

            IF Lv_EmpresaCod IS NULL THEN
               Pv_Mensaje := 'El parámetro EmpresaCod está vacío';
               RAISE Le_Errors;
            END IF;

            Lcl_Response := FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_POR_IDENTIF(Lv_Identificacion, Lv_EmpresaCod);

            Lnf_SaldoRes := FNCK_PAGOS_LINEA.F_OBTENER_SUMA_VALOR_PENDIENTE(Lv_Identificacion, Lv_EmpresaCod);

            FETCH Lcl_Response INTO Lv_IdPersona, Lv_Identificacion, Lv_RazonSocial, Lv_Nombres, Lv_Apellidos, Ln_Saldo;
            Lv_SaldoTotal := TO_CHAR(ROUND(Ln_Saldo, 4));

            IF Lnf_SaldoRes <> 0 THEN

                Lv_SaldoTotal := TO_CHAR(ROUND(Ln_Saldo - Lnf_SaldoRes, 4));
            END IF;

            Lv_NombreCliente := Lv_RazonSocial;

            IF (LENGTH(Lv_NombreCliente) = 0) OR (Lv_NombreCliente IS NULL) THEN
                Lv_NombreCliente := Lv_Nombres || ' ' || Lv_Apellidos;

            END IF;

            Lv_NumeroContrato := FNCK_PAGOS_LINEA.F_BUSCAR_NUM_CONTRATO(Lv_Identificacion, Lv_EmpresaCod, 'Activo');
            IF Lv_NumeroContrato IS NULL THEN

                Lv_NumeroContrato := FNCK_PAGOS_LINEA.F_BUSCAR_NUM_CONTRATO(Lv_Identificacion, Lv_EmpresaCod, 'Cancelado');
                IF Lv_NumeroContrato IS NULL THEN

                    Lv_NumeroContrato := FNCK_PAGOS_LINEA.F_BUSCAR_NUM_CONTRATO(Lv_Identificacion, Lv_EmpresaCod);
                END IF;
            END IF;

            IF Lv_NumeroContrato IS NULL THEN
                Lv_Retorno := '005';
                Lv_Error := 'Error, el cliente ingresado no tiene contrato.';
                Lv_Identificacion := null;
                Lv_SaldoTotal := '0';

                Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"contrapartida":"' || Lv_Identificacion || '",' ||
                                '"nombreCliente":null,' ||
                                '"saldoAdeudado":"' || Lv_SaldoTotal || '",' ||
                                '"numeroCobros":"' || Lv_NumCobros || '",' ||
                                '"tipoProducto":null,' ||
                                '"numeroContrato":null,' ||
                                '"valorRetener":"' || Lv_ValorRetener || '",' ||
                                '"baseImponible":"' || Lv_BaseImp || '",' ||
                                '"secuencialPagoInterno":null,' ||
                                '"identificacionCliente":null'
                            || '}';

                Pv_Status := 'ERROR';
                Pv_Mensaje := 'No existe numero de contrato';

            ELSE
                Ld_Date := SYSDATE;
                Lv_PeriodoRec := TO_CHAR(Ld_Date, 'YYYY-MM-DD HH:MM:SS');

                Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"contrapartida":"' || Lv_Identificacion || '",' ||
                                '"nombreCliente":"' || Lv_NombreCliente || '",' ||
                                '"saldoAdeudado":"' || Lv_SaldoTotal || '",' ||
                                '"numeroCobros":"' || Lv_NumCobros || '",' ||
                                '"tipoProducto":"' || Lv_TipoProducto || '",' ||
                                '"numeroContrato":"' || Lv_NumeroContrato || '",' ||
                                '"valorRetener":"' || Lv_ValorRetener || '",' ||
                                '"baseImponible":"' || Lv_BaseImp || '",' ||
                                '"periodoRecaudacion":"' || Lv_PeriodoRec || '",' ||
                                '"secuencialPagoInterno":"' || Lv_Secuencial || '",' ||
                                '"identificacionCliente":"' || Lv_Identificacion || '"'
                            || '}';

                Pv_Status     := 'OK';
                Pv_Mensaje    := 'Transacción exitosa';

            END IF;

        ELSE

            Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"contrapartida":"' || Lv_Identificacion || '",' ||
                                '"nombreCliente":null,' ||
                                '"saldoAdeudado":"' || Lv_SaldoTotal || '",' ||
                                '"numeroCobros":"' || Lv_NumCobros || '",' ||
                                '"tipoProducto":null,' ||
                                '"numeroContrato":null,' ||
                                '"valorRetener":"' || Lv_ValorRetener || '",' ||
                                '"baseImponible":"' || Lv_BaseImp || '",' ||
                                '"secuencialPagoInterno":null,' ||
                                '"identificacionCliente":null' 
                            || '}';

            Pv_Status := 'ERROR';
            Pv_Mensaje := 'Credenciales Validadas Incorrectas';

        END IF;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_CONSULTAR_SALDO_POR_IDENTIF',
                                          SUBSTR('RESPONSE:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_CONSULTAR_SALDO_POR_IDENTIF',
                                          'No se encontró saldo del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;

    END P_CONSULTAR_SALDO_POR_IDENTIF;

    /**
    * Documentacion para la funcion F_OBTENER_SUMA_VALOR_PENDIENTE
    *
    * La funcion retorna la suma de los valores pendientes de un cliente dependiendo de su código de Empresa e  
    * identificación
    *
    * @param Fv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Fv_EmpresaCod IN VARCHAR2 código de empresa
    * return Fn_ValorPendiente NUMBER
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    */
    FUNCTION F_OBTENER_SUMA_VALOR_PENDIENTE(Fv_Identificacion IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2)
    RETURN NUMBER
    IS

        CURSOR C_GetValorPendiente(Cv_Identificacion VARCHAR2, Cv_EmpresaCod VARCHAR2)
        IS
            SELECT SUM(pag.valor_pago_linea) AS VALOR_PENDIENTE
            FROM DB_FINANCIERO.info_pago_linea pag
            JOIN DB_COMERCIAL.info_persona per on pag.persona_id = per.id_persona
            WHERE pag.empresa_id = Cv_EmpresaCod
                AND per.identificacion_cliente = Cv_Identificacion
                AND pag.estado_pago_linea = 'Pendiente'; 

        Fn_ValorPendiente NUMBER;           

    BEGIN
        IF C_GetValorPendiente%ISOPEN THEN
            CLOSE C_GetValorPendiente;
        END IF;
        OPEN C_GetValorPendiente(Fv_Identificacion, Fv_EmpresaCod);
        FETCH C_GetValorPendiente INTO Fn_ValorPendiente;
        IF C_GetValorPendiente%ISOPEN THEN
            CLOSE C_GetValorPendiente;
        END IF;
        RETURN NVL(Fn_ValorPendiente, 0);

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_SUMA_VALOR_PENDIENTE',
                                          'No se encontró suma de saldos del cliente. Parametros (Identidicacion_cliente: '||Fv_Identificacion||', Codigo_empresa: '
                                          ||Fv_EmpresaCod||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        Fn_ValorPendiente := 0;
        RETURN Fn_ValorPendiente; 

    END F_OBTENER_SUMA_VALOR_PENDIENTE;

    /**
    * Documentacion para la funcion F_BUSCAR_NUM_CONTRATO
    *
    * La funcion retorna el numero de contrato de un cliente dependiendo de su código de Empresa,  
    * identificación, y/o estado del contrato
    *
    * @param Fv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Fv_EmpresaCod IN VARCHAR2 código de empresa
    * @param Fv_Estado IN VARCHAR2 estado de contrato del cliente
    * return Fv_NumeroContrato VARCHAR2
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    */
    FUNCTION F_BUSCAR_NUM_CONTRATO(Fv_Identificacion IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2, Fv_Estado IN VARCHAR2 DEFAULT NULL)
    RETURN VARCHAR2
    IS   
        Lcl_Query     CLOB;
        Lcl_Select    CLOB;
        Lcl_From      CLOB;
        Lcl_Where     CLOB;
        Lc_Cursor    SYS_REFCURSOR;
        Fv_NumeroContrato VARCHAR2(50);       

    BEGIN
        Lcl_Select  := 'SELECT MAX(con.numero_contrato) AS numeroContrato ';   
        Lcl_From    := 'FROM DB_COMERCIAL.info_contrato con
                            JOIN DB_COMERCIAL.info_persona_empresa_rol rol ON rol.id_persona_rol=con.persona_empresa_rol_id
                            JOIN DB_COMERCIAL.info_empresa_rol emp ON emp.id_empresa_rol=rol.empresa_rol_id
                            JOIN DB_COMERCIAL.info_persona per ON per.id_persona=rol.persona_id ';
        IF Fv_Estado IS NOT NULL THEN
            Lcl_Where := 'WHERE emp.empresa_cod='''||Fv_EmpresaCod||''' AND per.identificacion_cliente='''||Fv_Identificacion||''' AND con.estado='''||Fv_Estado||'''';
        ELSE
            Lcl_Where := 'WHERE emp.empresa_cod='''||Fv_EmpresaCod||''' AND per.identificacion_cliente='''||Fv_Identificacion||'''';
        END IF;

        Lcl_Query := Lcl_Select || Lcl_From || Lcl_Where;    

        IF Lc_Cursor%ISOPEN THEN
            CLOSE Lc_Cursor;
        END IF;
        OPEN Lc_Cursor FOR Lcl_Query;
        FETCH Lc_Cursor INTO Fv_NumeroContrato;
        IF Lc_Cursor%ISOPEN THEN
            CLOSE Lc_Cursor;
        END IF;

        RETURN Fv_NumeroContrato;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_BUSCAR_NUM_CONTRATO',
                                          'No se encontró numero de contrato del cliente. Parametros (Identidicacion_cliente: '||Fv_Identificacion||', Codigo_empresa: '
                                          ||Fv_EmpresaCod||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Fv_NumeroContrato := NULL;
        RETURN Fv_NumeroContrato; 

    END F_BUSCAR_NUM_CONTRATO;

    /**
    * Documentacion para la funcion F_OBTENER_SALDOS_POR_IDENTIF
    *
    * La funcion retorna la registros (cursor) de un cliente y su saldo dependiendo de su código de Empresa e  
    * identificación
    *
    * @param Fv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Fv_EmpresaCod IN VARCHAR2 código de empresa
    * return Fc_GetSaldoPendiente SYS_REFCURSOR
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    */
    FUNCTION F_OBTENER_SALDOS_POR_IDENTIF(Fv_Identificacion IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2)
    RETURN SYS_REFCURSOR
    IS                  
        Fc_GetSaldoPendiente SYS_REFCURSOR;

    BEGIN     
        OPEN Fc_GetSaldoPendiente FOR
            SELECT per.id_persona, per.identificacion_cliente, per.razon_social, per.nombres, per.apellidos, SUM(est.saldo) AS saldo    
            FROM (SELECT
                        ESTADO_CUENTA.PUNTO_ID, SUM(ESTADO_CUENTA.VALOR_TOTAL) SALDO
                        FROM
                        (SELECT

                        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2) as valor_total
                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
                        WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
                        NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado',
                        'Pendiente','Aprobada','Eliminado','ErrorGasto','ErrorDescuento','ErrorDuplicidad') 
                        AND TIPO_DOCUMENTO_ID not in (6,8)
                        UNION ALL
                        SELECT
                        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2)*-1 as valor_total
                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
                        WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
                        NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado') 
                        AND TIPO_DOCUMENTO_ID in (6,8)
                        UNION ALL
                        SELECT
                        DB_FINANCIERO.INFO_PAGO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_PAGO_DET.valor_pago,2)*-1 as valor_pago
                        FROM DB_FINANCIERO.INFO_PAGO_CAB,
                        DB_FINANCIERO.INFO_PAGO_DET
                        WHERE DB_FINANCIERO.INFO_PAGO_CAB.estado_pago NOT IN ('Inactivo', 'Anulado','Asignado')
                        AND DB_FINANCIERO.INFO_PAGO_CAB.id_pago = DB_FINANCIERO.INFO_PAGO_DET.pago_id
                        AND NOT EXISTS( SELECT anto.id_pago
                                        FROM DB_FINANCIERO.INFO_PAGO_CAB anto
                                        WHERE DB_FINANCIERO.INFO_PAGO_CAB.ANTICIPO_ID=anto.ID_PAGO 
                                        AND anto.ESTADO_PAGO='Cerrado'
                                        AND DB_FINANCIERO.INFO_PAGO_CAB.TIPO_DOCUMENTO_ID = 10
                                      )     
                        ) ESTADO_CUENTA
                        GROUP BY ESTADO_CUENTA.PUNTO_ID) est
            JOIN DB_COMERCIAL.info_punto pun on pun.id_punto = est.punto_id
            JOIN DB_COMERCIAL.info_persona_empresa_rol rol on rol.id_persona_rol = pun.persona_empresa_rol_id
            JOIN DB_COMERCIAL.info_empresa_rol emp on emp.id_empresa_rol = rol.empresa_rol_id
            JOIN DB_COMERCIAL.info_persona per on per.id_persona = rol.persona_id  
            WHERE emp.empresa_cod = Fv_EmpresaCod AND per.identificacion_cliente = Fv_Identificacion
            GROUP BY per.id_persona, per.identificacion_cliente, per.razon_social, per.nombres, per.apellidos;

        RETURN Fc_GetSaldoPendiente;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_POR_IDENTIF',
                                          'No se encontró registros del cliente. Parametros (Identidicacion_cliente: '||Fv_Identificacion||', Codigo_empresa: '
                                          ||Fv_EmpresaCod||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Fc_GetSaldoPendiente := NULL;
        RETURN Fc_GetSaldoPendiente; 

    END F_OBTENER_SALDOS_POR_IDENTIF;


    /**************************************************************************
    ****************************GENERAR PAGO***********************************
    **************************************************************************/

    /**
    * Documentacion para la funcion F_OBTENER_PAGO_LINEA
    *
    * La funcion retorna pago en linea por nombre del canal y numero de referencia  
    *
    * @param Fv_NombreCanal IN VARCHAR2 nombre del canal de pago
    * @param Fv_NumeroRef IN VARCHAR2 numero de referencia de pago
    * return Fc_PagoLinea SYS_REFCURSOR
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 09/06/2022
    */
    FUNCTION F_OBTENER_PAGO_LINEA(Fv_NombreCanal IN VARCHAR2, Fv_NumeroRef IN VARCHAR2)
    RETURN SYS_REFCURSOR
    IS
        Fc_PagoLinea        SYS_REFCURSOR;
        Lc_Canal            SYS_REFCURSOR;
        Lv_IdCanal          VARCHAR2(50);
        Lv_FormaPagoId      VARCHAR2(50); 
        Lv_IdTipoCta        VARCHAR2(50);
        Lv_IdCtaCble         VARCHAR2(50);
        Lv_CodigoCanal      VARCHAR2(50);
        Lv_DescCanal        VARCHAR2(100);
        Lv_NombreCanal      VARCHAR2(50);
        Lv_UsuarioCanal     VARCHAR2(50);
        Lv_ClaveCanal       VARCHAR2(50);

    BEGIN     
        Lc_Canal := FNCK_PAGOS_LINEA.F_OBTENER_CANAL_PAGO_LINEA(Fv_NombreCanal);
        FETCH Lc_Canal INTO Lv_IdCanal, Lv_FormaPagoId, Lv_IdTipoCta, Lv_IdCtaCble, Lv_CodigoCanal, 
                            Lv_DescCanal, Lv_NombreCanal, Lv_UsuarioCanal, Lv_ClaveCanal;
        CLOSE Lc_Canal;

        OPEN Fc_PagoLinea FOR
            SELECT PL.*
            FROM DB_FINANCIERO.INFO_PAGO_LINEA PL
            WHERE PL.CANAL_PAGO_LINEA_ID = Lv_IdCanal AND PL.NUMERO_REFERENCIA = Fv_NumeroRef;

        RETURN Fc_PagoLinea;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_PAGO_LINEA',
                                          'No se encontró pago en linea. Parametros (Nombre_canal: '||Fv_NombreCanal||', Numero_referencia: '
                                          ||Fv_NumeroRef||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') ); 

        Fc_PagoLinea := NULL;
        RETURN Fc_PagoLinea; 

    END F_OBTENER_PAGO_LINEA;

    /**
    * Documentacion para la funcion F_OBTENER_CANAL_PAGO_LINEA
    *
    * La funcion retorna canal de pago en linea por nombre  
    *
    * @param Fv_NombreCanal IN VARCHAR2 Nombre de Canal 
    * return Fc_CanalPago SYS_REFCURSOR
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 09/06/2022
    */
    FUNCTION F_OBTENER_CANAL_PAGO_LINEA(Fv_NombreCanal IN VARCHAR2)
    RETURN SYS_REFCURSOR
    IS
        Fc_CanalPago SYS_REFCURSOR;

    BEGIN     
        OPEN Fc_CanalPago FOR
            SELECT ID_CANAL_PAGO_LINEA, FORMA_PAGO_ID, BANCO_TIPO_CUENTA_ID, BANCO_CTA_CONTABLE_ID, CODIGO_CANAL_PAGO_LINEA,
                    DESCRIPCION_CANAL_PAGO_LINEA, NOMBRE_CANAL_PAGO_LINEA, USUARIO_CANAL_PAGO_LINEA, CLAVE_CANAL_PAGO_LINEA   
            FROM DB_FINANCIERO.ADMI_CANAL_PAGO_LINEA 
            WHERE NOMBRE_CANAL_PAGO_LINEA = Fv_NombreCanal AND ESTADO_CANAL_PAGO_LINEA = 'Activo';

        RETURN Fc_CanalPago;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_CANAL_PAGO_LINEA',
                                          'No se encontró registros del canal. Parametros (Nombre_canal: '||Fv_NombreCanal||')' || ' - ' 
                                          || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Fc_CanalPago := NULL;
        RETURN Fc_CanalPago; 

    END F_OBTENER_CANAL_PAGO_LINEA;

    /**
    * Documentación para P_PROCESAR_PAGO_LINEA
    * Procedimiento que realiza pago en linea
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 01/07/2022
    *
    * @param Pcl_Request IN CLOB
    * @param Pv_Status OUT VARCHAR2 estado
    * @param Pv_Mensaje OUT VARCHAR2 Devuelve el mensaje de respuesta
    * @param Pcl_Response OUT CLOB Devuelve respuesta con data
    */ 
    PROCEDURE P_PROCESAR_PAGO_LINEA(Pcl_Request IN CLOB, 
                                    Pv_Status OUT VARCHAR2, 
                                    Pv_Mensaje OUT VARCHAR2,
                                    Pcl_Response OUT CLOB)
    AS
    CURSOR C_GetInfoPersona(Cv_Identificacion VARCHAR2)
        IS SELECT IP.ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA IP WHERE IDENTIFICACION_CLIENTE=Cv_Identificacion; 

    CURSOR C_GetOfiMatriz(Cv_EmpresaCod VARCHAR2)
        IS 
        SELECT 
            OG.ID_OFICINA, OG.NOMBRE_OFICINA, OG.DIRECCION_OFICINA, OG.TELEFONO_FIJO_OFICINA 
        FROM DB_FINANCIERO.INFO_OFICINA_GRUPO OG
        WHERE OG.ES_VIRTUAL = 'N' AND OG.EMPRESA_ID = Cv_EmpresaCod AND OG.ESTADO = 'Activo' 
        AND OG.ES_MATRIZ = 'S' ORDER BY OG.FE_CREACION ASC;

    Li_Limit              CONSTANT PLS_INTEGER DEFAULT 50;

    Lv_Retorno            VARCHAR2(5);
    Lv_Error              VARCHAR2(500);
    Lv_NumPagos           VARCHAR2(5);
    Lb_ValidaCred         BOOLEAN;
    Lv_EmpresaCod         VARCHAR2(50);
    Lv_Identificacion     VARCHAR2(50);
    Lv_Pago               VARCHAR2(50);
    Lv_FechaTransac       VARCHAR2(100);
    Lv_Canal              VARCHAR2(50);
    Lv_SecuencialRec      VARCHAR2(50);
    Lc_PagoLinea          SYS_REFCURSOR;
    Lc_CanalPagoLinea     SYS_REFCURSOR;
    Lcl_ResConsulta       CLOB;
    Lv_Estado             VARCHAR2(5);
    Lv_NumContrato        VARCHAR2(50);
    Lv_Contrato           VARCHAR2(50);
    Lv_TipoDeuda           VARCHAR2(50);
    Lv_FPagoUno           VARCHAR2(50);
    Lv_FPagoDos           VARCHAR2(50);
    Lv_VPagoUno           VARCHAR2(50);
    Lv_VPagoDos           VARCHAR2(50);
    Lv_TipoProd           VARCHAR2(50);
    Lv_Terminal           VARCHAR2(50);
    Lv_Saldo              VARCHAR2(50);
    Lv_NombreCliente      VARCHAR2(500);
    Lrf_AdmiParametroDet  SYS_REFCURSOR;    
    Le_AdmiParametroDet   T_ParametrosDetalle;
    Li_Cont_ParamDet      PLS_INTEGER;
    Lr_InfoPagoLinea              DB_FINANCIERO.INFO_PAGO_LINEA%ROWTYPE;
    Lr_InfoPagoLineaHist          DB_FINANCIERO.INFO_PAGO_LINEA_HISTORIAL%ROWTYPE;
    Ln_PagoSinSaldo       NUMBER;
    Lv_IdPagoLinea        VARCHAR2(50);
    Lv_IdCanalPago        VARCHAR2(50);
    Lv_IdEmpresa          VARCHAR2(50);
    Lv_OficinaId          VARCHAR2(50);
    Lv_IdPersona          VARCHAR2(50);
    Ln_ValorPago          NUMBER;
    Lv_NumeroRef          VARCHAR2(50);
    Lv_EstadoPago         VARCHAR2(50);
    Lv_ComentarioPago     VARCHAR2(500);
    Lv_UsrCreacion        VARCHAR2(50);
    Lv_FechaPago          VARCHAR2(100);
    Lv_UsrUltMod          VARCHAR2(50);
    Lv_FechaUltMod        VARCHAR2(100);
    Lv_UsrElimina         VARCHAR2(50);
    Lv_FechaElimina       VARCHAR2(100);
    Lv_ProMasivoId        VARCHAR2(50);
    Lv_FechaT             VARCHAR2(100);
    Lv_Reversado          VARCHAR2(50);
    Lv_IdOficina          VARCHAR2(50);
    Lv_NombreOficina      VARCHAR2(100);
    Lv_DirOficina         VARCHAR2(500);
    Lv_TelfOficina        VARCHAR2(50);
    Lv_IdCanalPL          VARCHAR2(50);
    Lv_FormaPagoIdPL      VARCHAR2(50);
    Lv_IdTipoCtaPL        VARCHAR2(50);
    Lv_IdCtaCblePL        VARCHAR2(50);
    Lv_CodigoCanalPL      VARCHAR2(50);
    Lv_DescCanalPL        VARCHAR2(100);
    Lv_NombreCanalPL      VARCHAR2(50);
    Lv_UsuarioCanalPL     VARCHAR2(50);
    Lv_ClaveCanalPL       VARCHAR2(50);
    Lv_MsnError           VARCHAR2(500);
    Lv_Comentario         VARCHAR2(3500);
    Lv_FechaCrea          VARCHAR2(50);
    Ld_Date               DATE;
    Lv_MensajeVoucher     VARCHAR2(50);
    Lv_Observacion        VARCHAR2(50);
    Lcl_Mail              CLOB;

    BEGIN
        Lv_Saldo := '0';
        Lv_NumPagos := '1';
        Lv_MensajeVoucher := 'Exito.';
        Lv_Observacion := 'Exito.';

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_PROCESAR_PAGO_LINEA',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        APEX_JSON.PARSE(Pcl_Request);
        Lv_Identificacion  := APEX_JSON.get_varchar2(p_path => 'identificacionCliente'); 


        FNCK_PAGOS_LINEA.P_VALIDAR_CREDENCIALES(Pcl_Request, Lv_Retorno, Lv_Error, Lb_ValidaCred);

        Lrf_AdmiParametroDet := DB_GENERAL.GNRLPCK_UTIL.F_GET_PARAMS_DETS('PARAMETROS_PAGOS_LINEA');

        FETCH Lrf_AdmiParametroDet BULK COLLECT INTO Le_AdmiParametroDet LIMIT Li_Limit;

        Li_Cont_ParamDet := Le_AdmiParametroDet.FIRST;

        WHILE (Li_Cont_ParamDet IS NOT NULL)  
        LOOP
            IF Le_AdmiParametroDet(Li_Cont_ParamDet).VALOR1 = 'PAGO_SIN_SALDO' THEN
              Ln_PagoSinSaldo := Le_AdmiParametroDet(Li_Cont_ParamDet).VALOR2;
            END IF;

            EXIT WHEN Le_AdmiParametroDet(Li_Cont_ParamDet).VALOR1 = 'PAGO_SIN_SALDO';

            Li_Cont_ParamDet:= Le_AdmiParametroDet.NEXT(Li_Cont_ParamDet);
        END LOOP;
        CLOSE Lrf_AdmiParametroDet;

        IF Lb_ValidaCred THEN

            Lv_Retorno := '000';
            Lv_Error := null;

            Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'codigoExternoEmpresa'); 
            Lv_Canal := APEX_JSON.get_varchar2(p_path => 'canal');
            Lv_SecuencialRec := APEX_JSON.get_varchar2(p_path => 'secuencialRecaudador'); 
            Lv_Contrato := APEX_JSON.get_varchar2(p_path => 'numeroContrato');
            Lv_Pago := APEX_JSON.get_varchar2(p_path => 'valorPago');
            Lv_FechaTransac := APEX_JSON.get_varchar2(p_path => 'fechaTransaccion');
            Lv_TipoDeuda := APEX_JSON.get_varchar2(p_path => 'tipoDeuda');
            Lv_FPagoUno := APEX_JSON.get_varchar2(p_path => 'formaPago1');
            Lv_FPagoDos := APEX_JSON.get_varchar2(p_path => 'formaPago2');
            Lv_VPagoUno := APEX_JSON.get_varchar2(p_path => 'valorPago1');
            Lv_VPagoDos := APEX_JSON.get_varchar2(p_path => 'valorPago2');
            Lv_TipoProd := APEX_JSON.get_varchar2(p_path => 'tipoProducto');
            Lv_Terminal := APEX_JSON.get_varchar2(p_path => 'terminal');
            Lv_FechaTransac := TO_CHAR(TO_TIMESTAMP(Lv_FechaTransac, 'YYYY-MM-DD HH24:MI:SS'));

            Lv_Comentario := 'Contrato:'||Lv_Contrato|| ' - Tipo_Deuda:'||Lv_TipoDeuda||' - Forma_Pago1:'||Lv_FPagoUno||
                            ' - Valor_Pago1:'||Lv_VPagoUno||' - Forma_Pago2:'||Lv_FPagoDos||' - Valor_Pago2:'||Lv_VPagoDos||
                            ' - Tipo_Producto:'||Lv_TipoProd||' - Terminal:'||Lv_Terminal;

            IF C_GetOfiMatriz%ISOPEN THEN
                CLOSE C_GetOfiMatriz;
            END IF;
            OPEN C_GetOfiMatriz(Lv_EmpresaCod);
            FETCH C_GetOfiMatriz INTO Lv_IdOficina, Lv_NombreOficina, Lv_DirOficina, Lv_TelfOficina;

            Lc_PagoLinea := FNCK_PAGOS_LINEA.F_OBTENER_PAGO_LINEA(Lv_Canal, Lv_SecuencialRec);
            FETCH Lc_PagoLinea INTO Lv_IdPagoLinea, Lv_IdCanalPago, Lv_IdEmpresa, Lv_OficinaId, Lv_IdPersona, Ln_ValorPago, Lv_NumeroRef, Lv_EstadoPago, Lv_ComentarioPago, 
                                    Lv_UsrCreacion, Lv_FechaPago, Lv_UsrUltMod, Lv_FechaUltMod, Lv_UsrElimina, Lv_FechaElimina, Lv_ProMasivoId, Lv_FechaT, Lv_Reversado;    

            Lc_CanalPagoLinea := FNCK_PAGOS_LINEA.F_OBTENER_CANAL_PAGO_LINEA(Lv_Canal);
            FETCH Lc_CanalPagoLinea INTO Lv_IdCanalPL, Lv_FormaPagoIdPL, Lv_IdTipoCtaPL, Lv_IdCtaCblePL, Lv_CodigoCanalPL, 
                                        Lv_DescCanalPL, Lv_NombreCanalPL, Lv_UsuarioCanalPL, Lv_ClaveCanalPL; 

            FNCK_PAGOS_LINEA.P_CONSULTAR_SALDO_POR_IDENTIF(Pcl_Request, Lv_Estado, Pv_Mensaje, Lcl_ResConsulta);
            APEX_JSON.PARSE(Lcl_ResConsulta);
            Lv_NumContrato := APEX_JSON.get_varchar2(p_path => 'numeroContrato');
            Lv_Saldo := APEX_JSON.get_varchar2(p_path => 'saldoAdeudado');
            Lv_NombreCliente := APEX_JSON.get_varchar2(p_path => 'nombreCliente');

            IF Lc_PagoLinea%FOUND THEN
                Lv_Retorno := '010';
                Lv_Error := 'El secuencial ya ha sido usado anteriormente.';
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Secuencial recaudador ya usado.';

            ELSIF Lv_Estado = 'ERROR'THEN
                Lv_Retorno := '001';
                Lv_Error := 'No encontro informacion del cliente.';
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Informacion del cliente no encontrada.';

            ELSIF Lv_Contrato <> Lv_NumContrato THEN
                Lv_Retorno := '017';
                Lv_Error := 'El contrato del cliente no es el correcto. Contrato correcto: ' || Lv_NumContrato;
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Contrato Incorrecto.';

            ELSIF Ln_PagoSinSaldo IS NOT NULL AND Ln_PagoSinSaldo >= TO_NUMBER(Lv_Saldo, '999999.99') THEN
                Lv_Retorno := '005';
                Lv_Error := 'Cliente no tiene deuda.';
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Cliente sin deuda.';

            ELSIF C_GetOfiMatriz%NOTFOUND THEN
                Lv_Retorno := '017';
                Lv_Error := 'No se encontro informacion de la empresa.';
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Informacion de empresa no encontrada.';

            ELSE
                IF C_GetInfoPersona%ISOPEN THEN
                    CLOSE C_GetInfoPersona;
                END IF;
                OPEN C_GetInfoPersona(Lv_Identificacion);
                FETCH C_GetInfoPersona INTO Lv_IdPersona;

                IF C_GetInfoPersona%NOTFOUND THEN
                    Lv_Retorno := '017';
                    Lv_Error := 'No se encontro informacion del cliente.';
                    Pv_Status := 'ERROR';
                    Pv_Mensaje := 'Informacion del cliente no encontrada.';
                ELSE
                    Ld_Date := SYSDATE;
                    Lv_FechaCrea := TO_CHAR(Ld_Date, 'YYYY-MM-DD HH:MI:SS');

                    Lr_InfoPagoLinea.ID_PAGO_LINEA := DB_FINANCIERO.SEQ_INFO_PAGO_LINEA.NEXTVAL;
                    Lv_IdPagoLinea := Lr_InfoPagoLinea.ID_PAGO_LINEA;
                    Lr_InfoPagoLinea.CANAL_PAGO_LINEA_ID := Lv_IdCanalPL;
                    Lr_InfoPagoLinea.EMPRESA_ID := Lv_EmpresaCod;
                    Lr_InfoPagoLinea.OFICINA_ID := Lv_IdOficina;
                    Lr_InfoPagoLinea.PERSONA_ID := Lv_IdPersona;
                    Lr_InfoPagoLinea.VALOR_PAGO_LINEA := Lv_Pago;
                    Lr_InfoPagoLinea.NUMERO_REFERENCIA := Lv_SecuencialRec;
                    Lr_InfoPagoLinea.ESTADO_PAGO_LINEA := 'Pendiente';
                    Lr_InfoPagoLinea.COMENTARIO_PAGO_LINEA := Lv_Comentario;
                    Lr_InfoPagoLinea.USR_CREACION := 'telcos_pal';
                    Lr_InfoPagoLinea.FE_CREACION := Ld_Date;
                    Lr_InfoPagoLinea.FE_TRANSACCION := Lv_FechaTransac;
                    FNCK_PAGOS_LINEA.P_INSERT_INFO_PAGO_LINEA(Lr_InfoPagoLinea, Lv_MsnError);
                    IF Lv_MsnError IS NOT NULL THEN
                        Lv_Retorno := '003';
                        Lv_Error := Lv_MsnError;
                        Pv_Status := 'ERROR';
                        Pv_Mensaje := 'Error al insertar en InfoPagoLinea: '||Lv_MsnError;

                    ELSE
                        Lr_InfoPagoLineaHist.ID_PAGO_LINEA_HIST := DB_FINANCIERO.SEQ_INFO_PAGO_LINEA_HIST.NEXTVAL;
                        Lr_InfoPagoLineaHist.PAGO_LINEA_ID := Lv_IdPagoLinea;
                        Lr_InfoPagoLineaHist.CANAL_PAGO_LINEA_ID := Lv_IdCanalPL;
                        Lr_InfoPagoLineaHist.EMPRESA_ID := Lv_EmpresaCod;
                        Lr_InfoPagoLineaHist.PERSONA_ID := Lv_IdPersona;
                        Lr_InfoPagoLineaHist.VALOR_PAGO_LINEA := Lv_Pago;
                        Lr_InfoPagoLineaHist.NUMERO_REFERENCIA := Lv_SecuencialRec;
                        Lr_InfoPagoLineaHist.ESTADO_PAGO_LINEA := 'Pendiente';
                        Lr_InfoPagoLineaHist.OBSERVACION := Pcl_Request;
                        Lr_InfoPagoLineaHist.PROCESO := 'procesarPagoAction';
                        Lr_InfoPagoLineaHist.USR_CREACION := 'telcos_pal';
                        Lr_InfoPagoLineaHist.FE_CREACION := Ld_Date;
                        FNCK_TRANSACTION.P_INSERT_INFO_PAGO_HISTORIAL(Lr_InfoPagoLineaHist, Lv_MsnError);
                        IF Lv_MsnError IS NOT NULL THEN
                            Lv_Retorno := '003';
                            Lv_Error := Lv_MsnError;
                            Pv_Status := 'ERROR';
                            Pv_Mensaje := 'Error al insertar en InfoPagoLineaHistorial: '||Lv_MsnError;
                        ELSE
                            COMMIT;
                            FNCK_PAGOS_LINEA.P_CONSULTAR_SALDO_POR_IDENTIF(Pcl_Request, Lv_Estado, Pv_Mensaje, Lcl_ResConsulta);
                            APEX_JSON.PARSE(Lcl_ResConsulta);
                            Lv_Saldo := APEX_JSON.get_varchar2(p_path => 'saldoAdeudado');

                            Lcl_Mail := FNCK_PAGOS_LINEA.F_OBTENER_MAIL_FONO_POR_IDENT(Lv_Identificacion, 500, 
                                                                                        'MAIL', 'PRIMER PUNTO', 'notificaciones_telcos@telconet.ec');

                            Pcl_Response := '{' ||
                                                '"retorno":"' || Lv_Retorno || '",' ||
                                                '"error":null,' ||
                                                '"contrapartida":"' || Lv_Contrato || '",' ||
                                                '"nombreCliente":"' || Lv_NombreCliente || '",' ||
                                                '"fechaTransaccion":"' || Lv_FechaCrea || '",' ||
                                                '"secuencialPagoInterno":' || Lv_IdPagoLinea || ',' ||
                                                '"secuencialEntidadRecaudadora":"' || Lv_SecuencialRec || '",' ||
                                                '"numeroPagos":"' || Lv_NumPagos || '",' ||
                                                '"valorPago":"' || Lv_Pago || '",' ||
                                                '"tipoProducto":"' || Lv_TipoProd || '",' ||
                                                '"observacion":"' || Lv_Observacion || '",' ||
                                                '"mensajeVoucher":"' || Lv_MensajeVoucher || '",' ||
                                                '"correo":"' || Lcl_Mail || '",' ||
                                                '"saldo":"' || Lv_Saldo || '"' 
                                            || '}';

                            Pv_Status     := 'OK';
                            Pv_Mensaje    := 'Transacción exitosa';

                        END IF;
                    END IF;
                END IF;
            END IF;

            IF Lv_Retorno <> '000' THEN
                Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":"' || Lv_Error || '",' ||
                                    '"contrapartida":null,' ||
                                    '"nombreCliente":null,' ||
                                    '"fechaTransaccion":null,' ||
                                    '"secuencialPagoInterno":null,' ||
                                    '"secuencialEntidadRecaudadora":null,' ||
                                    '"numeroPagos":"' || Lv_NumPagos || '",' ||
                                    '"valorPago":null,' ||
                                    '"tipoProducto":null,' ||
                                    '"observacion":null,' ||
                                    '"mensajeVoucher":null,' ||
                                    '"correo":null,' ||
                                    '"saldo":null' 
                                || '}';
            END IF;

        ELSE
            Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"contrapartida":null,' ||
                                '"nombreCliente":null,' ||
                                '"fechaTransaccion":null,' ||
                                '"secuencialPagoInterno":null,' ||
                                '"secuencialEntidadRecaudadora":null,' ||
                                '"numeroPagos":"' || Lv_NumPagos || '",' ||
                                '"valorPago":null,' ||
                                '"tipoProducto":null,' ||
                                '"observacion":null,' ||
                                '"mensajeVoucher":null,' ||
                                '"correo":null,' ||
                                '"saldo":null' 
                            || '}';

            Pv_Status := 'ERROR';
            Pv_Mensaje := 'Credenciales Validadas Incorrectas';

        END IF;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_PROCESAR_PAGO_LINEA',
                                          SUBSTR('RESPONSE:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_PROCESAR_PAGO_LINEA',
                                          'No se realizó pago del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;  

        Pcl_Response := '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '",' ||
                                '"contrapartida":null,' ||
                                '"nombreCliente":null,' ||
                                '"fechaTransaccion":null,' ||
                                '"secuencialPagoInterno":null,' ||
                                '"secuencialEntidadRecaudadora":null,' ||
                                '"numeroPagos":"' || Lv_NumPagos || '",' ||
                                '"valorPago":null,' ||
                                '"tipoProducto":null,' ||
                                '"observacion":null,' ||
                                '"mensajeVoucher":null,' ||
                                '"correo":null,' ||
                                '"saldo":null' 
                            || '}';

    END P_PROCESAR_PAGO_LINEA;

    /**
    * Documentacion para el procedimiento P_VALIDAR_CREDENCIALES
    *
    * El procedimiento valida credenciales de canal de pago y cliente retornando verdadero si son correctas  
    *
    * @param Pcl_Request IN CLOB request
    * @param Pv_Status OUT VARCHAR2 Codigo de respuesta
    * @param Pv_Mensaje OUT VARCHAR2 Mensaje
    * @param Pb_Response OUT BOOLEAN
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 27/06/2022
    */
    PROCEDURE P_VALIDAR_CREDENCIALES(Pcl_Request IN CLOB, Pv_Status OUT VARCHAR2, Pv_Mensaje OUT VARCHAR2, Pb_Response OUT BOOLEAN)
    AS
        CURSOR C_GetInfoPersona(Cv_Identificacion VARCHAR2)
        IS SELECT IP.ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA IP WHERE IDENTIFICACION_CLIENTE=Cv_Identificacion; 

        CURSOR C_GetNumParametros
        IS SELECT COUNT(D.VALOR1) AS CUENTA FROM DB_GENERAL.ADMI_PARAMETRO_CAB C
                        JOIN DB_GENERAL.ADMI_PARAMETRO_DET D ON D.PARAMETRO_ID = C.ID_PARAMETRO
                        WHERE C.PROCESO='CLIENTE_PAGOS_EN_LINEA' AND C.MODULO='FINANCIERO' 
                        AND C.NOMBRE_PARAMETRO='ESTADOS_CLIENTE_CONSULTA_PL' 
                        AND D.DESCRIPCION='ESTADO_CLIENTE_CONSULTA_SALDOS_PL';

        CURSOR C_GetCliente(Cv_IdPersona VARCHAR2, Cv_EmpresaCod VARCHAR2)
        IS 
            SELECT IPER.ID_PERSONA_ROL, IPER.ESTADO, IER.ID_EMPRESA_ROL
            FROM DB_COMERCIAL.INFO_PERSONA IP,
                 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                 DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                 DB_COMERCIAL.ADMI_ROL ROL,
                 DB_COMERCIAL.ADMI_TIPO_ROL TROL
            WHERE IP.ID_PERSONA = IPER.PERSONA_ID
            AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
            AND IER.ROL_ID = ROL.ID_ROL
            AND ROL.TIPO_ROL_ID = TROL.ID_TIPO_ROL
            AND IPER.ESTADO IN (
                SELECT D.VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_CAB C
                JOIN DB_GENERAL.ADMI_PARAMETRO_DET D ON D.PARAMETRO_ID = C.ID_PARAMETRO
                WHERE C.PROCESO='CLIENTE_PAGOS_EN_LINEA' AND C.MODULO='FINANCIERO' 
                AND C.NOMBRE_PARAMETRO='ESTADOS_CLIENTE_CONSULTA_PL' 
                AND D.DESCRIPCION='ESTADO_CLIENTE_CONSULTA_SALDOS_PL')
            AND IPER.PERSONA_ID = Cv_IdPersona
            AND TROL.DESCRIPCION_TIPO_ROL IN ('Cliente','Pre-Cliente')
            AND IER.EMPRESA_COD = Cv_EmpresaCod
            ORDER BY IPER.ESTADO ASC;

        Lv_Identificacion   VARCHAR2(50);
        Lv_EmpresaCod       VARCHAR2(50);
        Lv_Usuario          VARCHAR2(50);
        Lv_Canal            VARCHAR2(50);
        Lv_Clave            VARCHAR2(50);
        Lv_TipoTransaccion  VARCHAR2(50);
        Lc_CanalPago        SYS_REFCURSOR;
        Lc_Parametros       SYS_REFCURSOR;
        Lvr_IdCanal         VARCHAR2(50);
        Lvr_FormaPagoId     VARCHAR2(50); 
        Lvr_IdTipoCta       VARCHAR2(50);
        Lvr_IdCtaCble       VARCHAR2(50);
        Lvr_CodigoCanal     VARCHAR2(50);
        Lvr_DescCanal       VARCHAR2(100);
        Lvr_NombreCanal     VARCHAR2(50);
        Lvr_UsuarioCanal    VARCHAR2(50);
        Lvr_ClaveCanal      VARCHAR2(50);
        Lvr_IdPersona       VARCHAR2(50);
        Lvr_IdPersonaRol    VARCHAR2(50);
        Lvr_EstadoPersona   VARCHAR2(50);
        Lvr_IdEmpresaRol    VARCHAR2(50);
        Ln_Count            NUMBER;

    BEGIN     
        APEX_JSON.PARSE(Pcl_Request);
        Lv_Identificacion  := APEX_JSON.get_varchar2(p_path => 'identificacionCliente'); 
        Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'codigoExternoEmpresa'); 
        Lv_Usuario  := APEX_JSON.get_varchar2(p_path => 'usuario'); 
        Lv_Canal  := APEX_JSON.get_varchar2(p_path => 'canal'); 
        Lv_Clave  := APEX_JSON.get_varchar2(p_path => 'clave'); 
        Lv_TipoTransaccion  := APEX_JSON.get_varchar2(p_path => 'tipoTransaccion'); 
        Pb_Response := true;

        FNCK_PAGOS_LINEA.P_VALIDAR_PROCESO(Pcl_Request, Pv_Status, Pv_Mensaje, Pb_Response);

        IF ((Lv_Identificacion IS NULL) OR (Lv_EmpresaCod IS NULL) OR (Lv_Usuario IS NULL) OR
            (Lv_Canal IS NULL) OR (Lv_Clave IS NULL) OR (Lv_TipoTransaccion IS NULL))
        THEN 
            Pv_Status := '004';
            Pv_Mensaje := 'Error, no se estan definiendo parametros de entrada.';
            Pb_Response := false;

        ELSIF ((Lv_Identificacion = ' ') OR (Lv_EmpresaCod = ' ') OR (Lv_Usuario = ' ') OR
            (Lv_Canal = ' ') OR (Lv_Clave = ' ') OR (Lv_TipoTransaccion = ' '))
        THEN 
            Pv_Status := '015';
            Pv_Mensaje := 'Error, parametros enviados no pueden ser nulos.';
            Pb_Response := false;

        ELSE
            Lc_CanalPago := FNCK_PAGOS_LINEA.F_OBTENER_CANAL_PAGO_LINEA(Lv_Canal);
            FETCH Lc_CanalPago INTO Lvr_IdCanal, Lvr_FormaPagoId, Lvr_IdTipoCta, Lvr_IdCtaCble, Lvr_CodigoCanal, 
                                    Lvr_DescCanal, Lvr_NombreCanal, Lvr_UsuarioCanal, Lvr_ClaveCanal;

            IF Lc_CanalPago%NOTFOUND THEN
                Pv_Status := '004';
                Pv_Mensaje := 'Error, el canal de pagos no existe.';
                Pb_Response := false;

            ELSIF ((Lvr_NombreCanal <> Lv_Canal) OR (Lvr_UsuarioCanal<> Lv_Usuario) OR (Lvr_ClaveCanal <> Lv_Clave)) THEN
                Pv_Status := '018';
                Pv_Mensaje := 'Error, credenciales incorrectas.';
                Pb_Response := false; 

            ELSE
                IF C_GetInfoPersona%ISOPEN THEN
                    CLOSE C_GetInfoPersona;
                END IF;
                OPEN C_GetInfoPersona(Lv_Identificacion);
                FETCH C_GetInfoPersona INTO Lvr_IdPersona;
                IF C_GetInfoPersona%ISOPEN THEN
                    CLOSE C_GetInfoPersona;
                END IF;

                IF Lvr_IdPersona IS NOT NULL THEN
                    IF C_GetCliente%ISOPEN THEN
                        CLOSE C_GetCliente;
                    END IF;
                    OPEN C_GetCliente(Lvr_IdPersona, Lv_EmpresaCod);
                    FETCH C_GetCliente INTO Lvr_IdPersonaRol, Lvr_EstadoPersona, Lvr_IdEmpresaRol;
                    IF C_GetCliente%ISOPEN THEN
                        CLOSE C_GetCliente;
                    END IF;

                    IF C_GetNumParametros%ISOPEN THEN
                        CLOSE C_GetNumParametros;
                    END IF;
                    OPEN C_GetNumParametros;
                    FETCH C_GetNumParametros INTO Ln_Count;
                    IF C_GetNumParametros%ISOPEN THEN
                        CLOSE C_GetNumParametros;
                    END IF;

                    IF Lvr_IdPersonaRol IS NULL AND Ln_Count = 0 THEN
                        Pv_Status := '001';
                        Pv_Mensaje := 'Error, no existe cliente Activo o Cancelado.';
                        Pb_Response := false;
                    END IF;
                ELSE
                    Pv_Status := '001';
                    Pv_Mensaje := 'Error, no existe cliente.';
                    Pb_Response := false;
                END IF;         
            END IF; 
        END IF;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_VALIDAR_CREDENCIALES',
                                          'No se encontró registros. Parametros (Request Validar: '||Pcl_Request||')' || ' - ' 
                                          || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Pb_Response := false;
        Pv_Status := '019';
        Pv_Mensaje := 'Error: '|| SQLERRM;

    END P_VALIDAR_CREDENCIALES;

    /**
    * Documentacion para el procedimiento P_VALIDAR_PROCESO
    *
    * El procedimiento valida informacion de acuerdo al proceso de bus de pagos  
    *
    * @param Pcl_Request IN CLOB request
    * @param Pv_Status OUT VARCHAR2 Codigo de respuesta
    * @param Pv_Mensaje OUT VARCHAR2 Mensaje
    * @param Pb_Response OUT BOOLEAN
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 07/07/2022
    */
    PROCEDURE P_VALIDAR_PROCESO(Pcl_Request IN CLOB,
                                     Pv_Status OUT VARCHAR2, 
                                     Pv_Mensaje OUT VARCHAR2, 
                                     Pb_Response OUT BOOLEAN)
    AS
        Lv_CodProceso       VARCHAR2(50); 
        Lv_Secuencial       VARCHAR2(50);    
        Lv_ValorPago        VARCHAR2(50);
        Lv_Contrato         VARCHAR2(50);
        Lv_FechaTransac     VARCHAR2(100);

    BEGIN     
        APEX_JSON.PARSE(Pcl_Request);
        Lv_CodProceso := APEX_JSON.get_varchar2(p_path => 'tipoTransaccion'); 
        Lv_Secuencial := APEX_JSON.get_varchar2(p_path => 'secuencialRecaudador'); 
        Lv_ValorPago := APEX_JSON.get_varchar2(p_path => 'valorPago'); 
        Lv_FechaTransac := APEX_JSON.get_varchar2(p_path => 'fechaTransaccion');
        Lv_Contrato := APEX_JSON.get_varchar2(p_path => 'numeroContrato'); 

        Pb_Response := true;

        IF Lv_CodProceso = '200' OR Lv_CodProceso = '400' THEN --PROCESAR PAGO  O CONCILIAR

            IF Lv_CodProceso = '200' THEN --PROCESAR PAGO
                IF Lv_Contrato IS NULL
                THEN
                    Pv_Status := '004';
                    Pv_Mensaje := 'Error, no se estan definiendo parametros de entrada.';
                    Pb_Response := false;
                ELSIF Lv_Contrato = ' '
                THEN
                    Pv_Status := '015';
                    Pv_Mensaje := 'Error, parametros enviados no pueden ser nulos.';
                    Pb_Response := false;
                END IF;
            END IF;

            IF ((Lv_Secuencial IS NULL) OR (Lv_ValorPago IS NULL) OR (Lv_FechaTransac IS NULL)) 
            THEN
                Pv_Status := '004';
                Pv_Mensaje := 'Error, no se estan definiendo parametros de entrada.';
                Pb_Response := false;
            ELSIF ((Lv_Secuencial = ' ') OR (Lv_ValorPago = ' ') OR (Lv_FechaTransac = ' ')) 
            THEN
                Pv_Status := '015';
                Pv_Mensaje := 'Error, parametros enviados no pueden ser nulos.';
                Pb_Response := false;
            ELSIF TO_NUMBER(Lv_ValorPago, '999999.99') <= 0 THEN
                Pv_Status := '020';
                Pv_Mensaje := 'Error, saldo no puede ser menor o igual a cero.';
                Pb_Response := false;
            END IF;

        ELSIF (Lv_CodProceso <> '100') AND (Lv_CodProceso <> '200') AND (Lv_CodProceso <> '300') 
                AND (Lv_CodProceso <> '400') AND (Lv_CodProceso <> '500') AND (Lv_CodProceso <> '800')
        THEN  
            Pv_Status := '011';
            Pv_Mensaje := 'Error, Codigo de transaccion no existe.';
            Pb_Response := false;
        END IF;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_VALIDAR_PROCESO',
                                          'No se encontró registros. Parametros (Request Validar: '||Pcl_Request||')' || ' - ' 
                                          || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Pb_Response := false;
        Pv_Status := '019';
        Pv_Mensaje := 'Error: '|| SQLERRM;

    END P_VALIDAR_PROCESO;

    /**
    * Documentacion para el procedimiento P_INSERT_INFO_PAGO_LINEA
    *
    * El procedimiento permite insertar registros en tabla InfoPagoLinea  
    *
    * @param Pr_InfoPagoLinea IN DB_FINANCIERO.INFO_PAGO_LINEA%ROWTYPE data
    * @param Pv_MsnError OUT VARCHAR2 Mensaje de Error
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 06/07/2022
    */
    PROCEDURE P_INSERT_INFO_PAGO_LINEA(
        Pr_InfoPagoLinea    IN  DB_FINANCIERO.INFO_PAGO_LINEA%ROWTYPE,
        Pv_MsnError         OUT VARCHAR2)
    IS
    BEGIN
      --
      INSERT
      INTO
        DB_FINANCIERO.INFO_PAGO_LINEA
        (
          ID_PAGO_LINEA,
          CANAL_PAGO_LINEA_ID,
          EMPRESA_ID,
          OFICINA_ID,
          PERSONA_ID,
          VALOR_PAGO_LINEA,
          NUMERO_REFERENCIA,
          ESTADO_PAGO_LINEA,
          COMENTARIO_PAGO_LINEA,
          USR_CREACION,
          FE_CREACION,
          FE_TRANSACCION
        )
        VALUES
        (
          Pr_InfoPagoLinea.ID_PAGO_LINEA,
          Pr_InfoPagoLinea.CANAL_PAGO_LINEA_ID,
          Pr_InfoPagoLinea.EMPRESA_ID,
          Pr_InfoPagoLinea.OFICINA_ID,
          Pr_InfoPagoLinea.PERSONA_ID,
          Pr_InfoPagoLinea.VALOR_PAGO_LINEA,
          Pr_InfoPagoLinea.NUMERO_REFERENCIA,
          Pr_InfoPagoLinea.ESTADO_PAGO_LINEA,
          Pr_InfoPagoLinea.COMENTARIO_PAGO_LINEA,
          Pr_InfoPagoLinea.USR_CREACION,
          Pr_InfoPagoLinea.FE_CREACION,
          Pr_InfoPagoLinea.FE_TRANSACCION
        );
      --
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_MsnError := SQLERRM;
      FNCK_TRANSACTION.INSERT_ERROR ( 'FNCK_PAGOS_LINEA', 'FNCK_PAGOS_LINEA.P_INSERT_INFO_PAGO_LINEA', SQLERRM ) ;
      --
    END P_INSERT_INFO_PAGO_LINEA;

    /**
    * Documentacion para la funcion F_OBTENER_MAIL_FONO_POR_IDENT
    *
    * La funcion retorna Mail y/o Telefono del cliente 
    *
    * @param Fv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Fn_NumCarac IN VARCHAR2 Limite de caracteres
    * @param Fv_TipoData IN VARCHAR2 Tipo de Data
    * @param Fv_Todos IN VARCHAR2 Variable Todos
    * @param Fv_MailDefault IN VARCHAR2 Mail default
    * return Fcl_Mail CLOB Mail de Cliente
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 08/07/2022
    */
    FUNCTION F_OBTENER_MAIL_FONO_POR_IDENT(Fv_Identificacion IN VARCHAR2, 
                                            Fn_NumCarac IN NUMBER,
                                            Fv_TipoData IN VARCHAR2,
                                            Fv_Todos IN VARCHAR2,
                                            Fv_MailDefault IN VARCHAR2)
    RETURN CLOB
    IS
        CURSOR C_GetInfoPersona(Cv_Identificacion VARCHAR2)
        IS SELECT IP.ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA IP WHERE IP.IDENTIFICACION_CLIENTE=Cv_Identificacion 
            AND IP.ESTADO IN ('Activo', 'Cancelado'); 

        CURSOR C_GetListaPtosCliente(Cv_IdPersona VARCHAR2)
        IS SELECT IP.ID_PUNTO FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
            DB_COMERCIAL.INFO_PUNTO IP
            WHERE IPER.PERSONA_ID = Cv_IdPersona 
            AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL;    

        Li_Limit                    CONSTANT PLS_INTEGER DEFAULT 50;

        Lv_IdPersona                VARCHAR2(50);
        Lv_IdPunto                  VARCHAR2(50);
        Lv_MailFono                 VARCHAR2(1000);
        Lcl_Mail                    CLOB;
        Lb_IsMail                   BOOLEAN;
        Ln_RepMail                  NUMBER;
        Le_PuntoCliente             T_PuntoCliente;
        Li_Cont_PuntoCliente        PLS_INTEGER;
        Le_Persona                  T_Persona;
        Li_Cont_Persona             PLS_INTEGER;

    BEGIN     
        IF C_GetInfoPersona%ISOPEN THEN
            CLOSE C_GetInfoPersona;
        END IF;
        OPEN C_GetInfoPersona(Fv_Identificacion);

        FETCH C_GetInfoPersona BULK COLLECT INTO Le_Persona LIMIT Li_Limit;
        Li_Cont_Persona := Le_Persona.FIRST;

        WHILE (Li_Cont_Persona IS NOT NULL) LOOP

            IF C_GetListaPtosCliente%ISOPEN THEN
                CLOSE C_GetListaPtosCliente;
            END IF;
            OPEN C_GetListaPtosCliente(Le_Persona(Li_Cont_Persona).ID_PERSONA);

            FETCH C_GetListaPtosCliente BULK COLLECT INTO Le_PuntoCliente LIMIT Li_Limit;
            Li_Cont_PuntoCliente := Le_PuntoCliente.FIRST;

            WHILE (Li_Cont_PuntoCliente IS NOT NULL) LOOP
                Lv_MailFono := FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(Le_PuntoCliente(Li_Cont_PuntoCliente).ID_PUNTO, Fv_TipoData);    

                IF Lv_MailFono IS NOT NULL THEN
                    Lv_MailFono := REPLACE(Lv_MailFono, ' ', '');
                    IF LENGTH(Lv_MailFono) <= Fn_NumCarac THEN
                        Lb_IsMail := REGEXP_LIKE (Lv_MailFono, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
                        IF Lb_IsMail THEN
                            Ln_RepMail := INSTR(Lcl_Mail,Lv_MailFono);
                            IF Ln_RepMail IS NULL OR Ln_RepMail = 0 THEN
                                Lcl_Mail := Lcl_Mail || Lv_MailFono || ';';
                            END IF;
                        END IF;
                    END IF;
                    EXIT WHEN Fv_Todos <> 'TODOS';
                END IF;

                Li_Cont_PuntoCliente := Le_PuntoCliente.NEXT(Li_Cont_PuntoCliente);

            END LOOP;

            IF C_GetListaPtosCliente%ISOPEN THEN
                CLOSE C_GetListaPtosCliente;
            END IF;

            Li_Cont_Persona := Le_Persona.NEXT(Li_Cont_Persona);

            EXIT WHEN Fv_Todos <> 'TODOS';
        END LOOP;

        IF C_GetInfoPersona%ISOPEN THEN
            CLOSE C_GetInfoPersona;
        END IF;

        Lcl_Mail := REPLACE(Lcl_Mail, ' ', '');

        IF Lcl_Mail IS NULL OR LENGTH(Lcl_Mail) < 2 AND Fv_TipoData = 'MAIL' THEN
            Lcl_Mail := Fv_MailDefault;
            Lb_IsMail := REGEXP_LIKE (Fv_MailDefault, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');
            IF Lb_IsMail AND Fv_TipoData = 'MAIL' THEN 
                Lcl_Mail := Fv_MailDefault;
            ELSIF Fv_TipoData = 'MAIL' THEN
                Lcl_Mail := 'notificaciones_telcos@telconet.ec';
            END IF;
        END IF;

        RETURN Lcl_Mail;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_MAIL_FONO_POR_IDENT',
                                          'No se encontró registros del mail o fono. Parametros (Identificacion: '||Fv_Identificacion||')' || ' - ' 
                                          || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Lcl_Mail := NULL;
        RETURN Lcl_Mail; 

    END F_OBTENER_MAIL_FONO_POR_IDENT;

    /**************************************************************************
    **************************CONCILIAR PAGO***********************************
    **************************************************************************/

    /**
    * Documentación para P_CONCILIAR_PAGO_LINEA
    * Procedimiento que realiza pago en linea
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 01/07/2022
    *
    * @param Pcl_Request IN CLOB
    * @param Pv_Status OUT VARCHAR2 estado
    * @param Pv_Mensaje OUT VARCHAR2 Devuelve el mensaje de respuesta
    * @param Pcl_Response OUT CLOB Devuelve respuesta con data
    */ 
    PROCEDURE P_CONCILIAR_PAGO_LINEA(Pcl_Request IN CLOB, 
                                    Pv_Status OUT VARCHAR2, 
                                    Pv_Mensaje OUT VARCHAR2,
                                    Pcl_Response OUT CLOB)
    AS
    CURSOR C_GetInfoPersona(Cv_IdPersona VARCHAR2)
        IS SELECT IP.IDENTIFICACION_CLIENTE FROM DB_COMERCIAL.INFO_PERSONA IP WHERE IP.ID_PERSONA=Cv_IdPersona; 

    CURSOR C_GetPrefijoEmpresa(Cv_CodEmpresa VARCHAR2)    
        IS SELECT IEG.PREFIJO FROM DB_FINANCIERO.INFO_EMPRESA_GRUPO IEG WHERE IEG.COD_EMPRESA=Cv_CodEmpresa;

    CURSOR C_GetFormaPago(Cv_IdFormaPago VARCHAR2)
        IS SELECT FP.CODIGO_FORMA_PAGO FROM DB_FINANCIERO.ADMI_FORMA_PAGO FP WHERE FP.ID_FORMA_PAGO = Cv_IdFormaPago;    

    Lv_Retorno            VARCHAR2(5);
    Lv_Error              VARCHAR2(500);
    Lb_ValidaCred         BOOLEAN;
    Lv_Identificacion     VARCHAR2(50);
    Lv_EmpresaCod         VARCHAR2(50);
    Ln_Pago               NUMBER;
    Lv_FechaTransac       VARCHAR2(100);
    Lv_Canal              VARCHAR2(50);
    Lv_SecuencialRec      VARCHAR2(50);
    Lc_PagoLinea          SYS_REFCURSOR;
    Lc_CanalPago          SYS_REFCURSOR;
    Lv_IdentPersona       VARCHAR2(50);
    Lv_Contrato           VARCHAR2(50);
    Lr_InfoPagoLineaHist          DB_FINANCIERO.INFO_PAGO_LINEA_HISTORIAL%ROWTYPE;
    Lv_IdPagoLinea        VARCHAR2(50);
    Lv_IdCanalPago        VARCHAR2(50);
    Lv_IdEmpresa          VARCHAR2(50);
    Lv_OficinaId          VARCHAR2(50);
    Lv_IdPersona          VARCHAR2(50);
    Ln_ValorPago          NUMBER;
    Lv_NumeroRef          VARCHAR2(50);
    Lv_EstadoPago         VARCHAR2(50);
    Lv_ComentarioPago     VARCHAR2(500);
    Lv_UsrCreacion        VARCHAR2(50);
    Lv_FechaPago          VARCHAR2(100);
    Lv_UsrUltMod          VARCHAR2(50);
    Lv_FechaUltMod        VARCHAR2(100);
    Lv_UsrElimina         VARCHAR2(50);
    Lv_FechaElimina       VARCHAR2(100);
    Lv_ProMasivoId        VARCHAR2(50);
    Lv_FechaT             VARCHAR2(100);
    Lv_Reversado          VARCHAR2(50); 
    Lv_MsnError           VARCHAR2(500);
    Lv_FechaCrea          VARCHAR2(50);
    Ld_Date               DATE;
    Lv_Prefijo            VARCHAR2(50);
    Lv_UsuarioCrea        VARCHAR2(50);
    Lv_EsReactivado       VARCHAR2(50);
    Lv_IdProcesoMasivo    VARCHAR2(50);
    Lv_Mensaje            VARCHAR2(50);
    Lvr_IdCanal           VARCHAR2(50);
    Lvr_FormaPagoId       VARCHAR2(50); 
    Lvr_IdTipoCta         VARCHAR2(50);
    Lvr_IdCtaCble         VARCHAR2(50);
    Lvr_CodigoCanal       VARCHAR2(50);
    Lvr_DescCanal         VARCHAR2(100);
    Lvr_NombreCanal       VARCHAR2(50);
    Lvr_UsuarioCanal      VARCHAR2(50);
    Lvr_ClaveCanal        VARCHAR2(50);
    Lv_CodFormaPago       VARCHAR2(50);
    Lcl_Activacion        CLOB;
    Lcl_ActivaResp        CLOB;
    Lcl_Anticipo          CLOB;
    Lcl_AnticipoResp      CLOB;
    Lv_RetornoAnt         VARCHAR2(50);
    Lv_ErrorAnt           VARCHAR2(1000);    
    Lv_Documento          VARCHAR2(50);
    Lv_Cadena             VARCHAR2(50);

    BEGIN

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_CONCILIAR_PAGO_LINEA',
                                          SUBSTR('REQUEST:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        FNCK_PAGOS_LINEA.P_VALIDAR_CREDENCIALES(Pcl_Request, Lv_Retorno, Lv_Error, Lb_ValidaCred);

        IF Lb_ValidaCred THEN

            Lv_Retorno := '000';
            Lv_Error := null;
            Lv_UsuarioCrea := 'telcos_pal';
            Lv_Mensaje := 'Exito.';

            APEX_JSON.PARSE(Pcl_Request);
            Lv_Identificacion  := APEX_JSON.get_varchar2(p_path => 'identificacionCliente'); 
            Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'codigoExternoEmpresa');
            Ln_Pago := APEX_JSON.get_number(p_path => 'valorPago');
            Lv_Canal := APEX_JSON.get_varchar2(p_path => 'canal');
            Lv_SecuencialRec := APEX_JSON.get_varchar2(p_path => 'secuencialRecaudador');
            Lv_FechaTransac := APEX_JSON.get_varchar2(p_path => 'fechaTransaccion');
            Lv_FechaTransac := TO_CHAR(TO_TIMESTAMP(Lv_FechaTransac, 'YYYY-MM-DD HH24:MI:SS'));

            Lc_CanalPago := FNCK_PAGOS_LINEA.F_OBTENER_CANAL_PAGO_LINEA(Lv_Canal);
            FETCH Lc_CanalPago INTO Lvr_IdCanal, Lvr_FormaPagoId, Lvr_IdTipoCta, Lvr_IdCtaCble, Lvr_CodigoCanal, 
                                    Lvr_DescCanal, Lvr_NombreCanal, Lvr_UsuarioCanal, Lvr_ClaveCanal;

            Lc_PagoLinea := FNCK_PAGOS_LINEA.F_OBTENER_PAGO_LINEA(Lv_Canal, Lv_SecuencialRec);
            FETCH Lc_PagoLinea INTO Lv_IdPagoLinea, Lv_IdCanalPago, Lv_IdEmpresa, Lv_OficinaId, Lv_IdPersona, Ln_ValorPago, Lv_NumeroRef, Lv_EstadoPago, Lv_ComentarioPago, 
                                    Lv_UsrCreacion, Lv_FechaPago, Lv_UsrUltMod, Lv_FechaUltMod, Lv_UsrElimina, Lv_FechaElimina, Lv_ProMasivoId, Lv_FechaT, Lv_Reversado;

            IF C_GetFormaPago%ISOPEN THEN
                    CLOSE C_GetFormaPago;
            END IF;
            OPEN C_GetFormaPago(Lvr_FormaPagoId);
            FETCH C_GetFormaPago INTO Lv_CodFormaPago;
            IF C_GetFormaPago%ISOPEN THEN
                    CLOSE C_GetFormaPago;
            END IF;                        

            IF C_GetInfoPersona%ISOPEN THEN
                    CLOSE C_GetInfoPersona;
            END IF;
            OPEN C_GetInfoPersona(Lv_IdPersona);
            FETCH C_GetInfoPersona INTO Lv_IdentPersona;
            IF C_GetInfoPersona%ISOPEN THEN
                    CLOSE C_GetInfoPersona;
            END IF;

            IF Lc_PagoLinea%NOTFOUND THEN
                Lv_Retorno := '017';
                Lv_Error := 'Pago a conciliar no existe.';
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Pago a conciliar no existe.';

            ELSIF (Lv_EstadoPago = 'Reversado') OR (Lv_EstadoPago = 'Eliminado') THEN
                Lv_Retorno := '012';
                Lv_Error := 'El pago '||Lv_NumeroRef||' se encuentra en Estado: '||Lv_EstadoPago;
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Pago Eliminado/Reversado.';

            ELSIF Lv_EstadoPago = 'Conciliado' THEN
                Lv_Retorno := '021';
                Lv_Error := 'El pago '||Lv_NumeroRef||' se encuentra en Estado: '||Lv_EstadoPago;
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Pago ya conciliado.';

            ELSIF Lv_EstadoPago <> 'Pendiente' THEN
                Lv_Retorno := '017';
                Lv_Error := 'El pago '||Lv_NumeroRef||' se encuentra en Estado: '||Lv_EstadoPago;
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Pago no se encuentra Pendiente.';

            ELSIF (Lv_IdEmpresa <> Lv_EmpresaCod) OR (ROUND(Ln_Pago, 2) <> ROUND(Ln_ValorPago, 2)) 
                    OR (Lv_Identificacion <> Lv_IdentPersona)
                    OR (SUBSTR(Lv_FechaPago,1,9) <> SUBSTR(Lv_FechaTransac,1,9)) THEN
                Lv_Retorno := '017';
                Lv_Error := 'El pago contiene datos distintos a los proporcionados.';
                Pv_Status := 'ERROR';
                Pv_Mensaje := 'Datos distintos al pago.';

            ELSE
                Lv_Cadena := '"bancoCtaContableId":"'|| Lvr_IdCtaCble ||'",';

                IF Lvr_IdCtaCble IS NULL THEN
                    Lv_Cadena := '"bancoCtaContableId":null,';
                END IF;

                Lcl_Anticipo := '{' ||
                                    '"codigoFormaPago":"' || Lv_CodFormaPago || '",' ||
                                    '"oficinaId":' || Lv_OficinaId || ',' || Lv_Cadena ||
                                    '"valorPagado":' || Ln_ValorPago || ',' ||
                                    '"bancoTipoCuentaId":' || Lvr_IdTipoCta || ',' ||
                                    '"numeroReferencia":"' || Lv_NumeroRef || '",' ||
                                    '"origenPago":"' || Lvr_DescCanal || '",' ||
                                    '"formaPagoId":' || Lvr_FormaPagoId || ',' ||
                                    '"empresaCod":' || Lv_IdEmpresa || ',' ||
                                    '"canalRecaudacionId":' || Lv_IdCanalPago || ',' ||
                                    '"personaId":' || Lv_IdPersona || ',' ||
                                    '"usrCreacion":"' || Lv_UsuarioCrea || '",' ||
                                    '"recaudacionId":null,' ||
                                    '"recaudacionDetId":null,' ||
                                    '"pagoLineaId":' || Lv_IdPagoLinea || ',' ||
                                    '"comentarioPagoLinea":"' || Lv_ComentarioPago || '",' ||
                                    '"fechaProceso":"' || Lv_FechaTransac || '"' 
                                || '}';

                                --dbms_output.put_line('Req ANTICIPO'||Lcl_Anticipo);

                Lcl_AnticipoResp := FNCK_PAGOS_LINEA.F_GENERAR_PAGO_ANTICIPO(Lcl_Anticipo);   

                --dbms_output.put_line('Res ANTICIPO'||Lcl_AnticipoResp);
                APEX_JSON.PARSE(Lcl_AnticipoResp);
                Lv_RetornoAnt  := APEX_JSON.get_varchar2(p_path => 'retorno'); 

                IF Lv_RetornoAnt = '003' OR Lv_RetornoAnt = '005' THEN
                    Lv_Retorno := '010';
                    Lv_Error := 'El pago no pudo ser conciliado.';
                    Pv_Status := 'ERROR';
                    Pv_Mensaje := 'No se pudo conciliar pago.';
                ELSIF Lv_RetornoAnt = '007' THEN
                    Lv_Documento  := APEX_JSON.get_varchar2(p_path => 'respuesta');
                    Lv_Retorno := '021';
                    Lv_Error := 'El pago ya ha sido conciliado anteriormente. '||Lv_Documento||' Existente.';
                    Pv_Status := 'ERROR';
                    Pv_Mensaje := 'Pago conciliado anteriormente.';
                ELSE
                    Ld_Date := SYSDATE;
                    Lv_FechaCrea := TO_CHAR(Ld_Date, 'YYYY-MM-DD HH:MI:SS');

                    UPDATE DB_FINANCIERO.INFO_PAGO_LINEA IPL
                    SET IPL.ESTADO_PAGO_LINEA = 'Conciliado',
                        IPL.FE_ULT_MOD        = Ld_Date,
                        IPL.USR_ULT_MOD       = Lv_UsuarioCrea
                    WHERE IPL.ID_PAGO_LINEA   = Lv_IdPagoLinea;

                    Lr_InfoPagoLineaHist.ID_PAGO_LINEA_HIST := DB_FINANCIERO.SEQ_INFO_PAGO_LINEA_HIST.NEXTVAL;
                    Lr_InfoPagoLineaHist.PAGO_LINEA_ID := Lv_IdPagoLinea;
                    Lr_InfoPagoLineaHist.CANAL_PAGO_LINEA_ID := Lv_IdCanalPago;
                    Lr_InfoPagoLineaHist.EMPRESA_ID := Lv_IdEmpresa;
                    Lr_InfoPagoLineaHist.PERSONA_ID := Lv_IdPersona;
                    Lr_InfoPagoLineaHist.VALOR_PAGO_LINEA := Ln_ValorPago;
                    Lr_InfoPagoLineaHist.NUMERO_REFERENCIA := Lv_NumeroRef;
                    Lr_InfoPagoLineaHist.ESTADO_PAGO_LINEA := 'Conciliado';
                    Lr_InfoPagoLineaHist.OBSERVACION := Pcl_Request;
                    Lr_InfoPagoLineaHist.PROCESO := 'conciliarPagoAction';
                    Lr_InfoPagoLineaHist.USR_CREACION := Lv_UsuarioCrea;
                    Lr_InfoPagoLineaHist.FE_CREACION := Ld_Date;
                    FNCK_TRANSACTION.P_INSERT_INFO_PAGO_HISTORIAL(Lr_InfoPagoLineaHist, Lv_MsnError);

                    IF Lv_MsnError IS NOT NULL THEN
                        Lv_Retorno := '003';
                        Lv_Error := Lv_MsnError;
                        Pv_Status := 'ERROR';
                        Pv_Mensaje := 'Error al insertar en InfoPagoLineaHistorial: '||Lv_MsnError;
                    ELSE
                        COMMIT;
                        IF C_GetPrefijoEmpresa%ISOPEN THEN
                            CLOSE C_GetPrefijoEmpresa;
                        END IF;
                        OPEN C_GetPrefijoEmpresa(Lv_EmpresaCod);
                        FETCH C_GetPrefijoEmpresa INTO Lv_Prefijo;
                        IF C_GetPrefijoEmpresa%ISOPEN THEN
                            CLOSE C_GetPrefijoEmpresa;
                        END IF;

                        Lcl_Activacion := '{' ||
                                    '"ID_CANAL_PAGO_LINEA":"' || Lv_IdCanalPago || '",' ||
                                    '"PREFIJO_EMPRESA_SESSION":"' || Lv_Prefijo || '",' ||
                                    '"ID_EMPRESA":"' || Lv_IdEmpresa || '",' ||
                                    '"USR_CREACION":"' || Lv_UsuarioCrea || '",' ||
                                    '"ID_PAGO_LINEA":"' || Lv_IdPagoLinea || '"' 
                                || '}';
                        --dbms_output.put_line('Req Activa'||Lcl_Activacion);

                        Lcl_ActivaResp := FNCK_PAGOS_LINEA.F_REAC_SERVICIO_X_PAGO_LINEA(Lcl_Activacion);
                        --dbms_output.put_line('Res Activa'||Lcl_ActivaResp);

                        APEX_JSON.PARSE(Lcl_ActivaResp);
                        Lv_EsReactivado  := APEX_JSON.get_varchar2(p_path => 'IS_REACTIVADO'); 
                        Lv_IdProcesoMasivo  := APEX_JSON.get_varchar2(p_path => 'PROCESO_MASIVO_ID');

                        Lv_Error := 'Reactivacion:'|| Lv_EsReactivado||'/'||Lv_IdProcesoMasivo;

                        Pcl_Response := '{' ||
                                            '"retorno":"' || Lv_Retorno || '",' ||
                                            '"error":null,' ||
                                            '"secuencialRecaudador":"' || Lv_NumeroRef || '",' ||
                                            '"secuencialPagoInterno":' || Lv_IdPagoLinea || ',' ||
                                            '"fechaConciliacion":"' || Lv_FechaCrea || '",' ||
                                            '"fechaTransaccionPago":"' || Lv_FechaPago || '",' ||
                                            '"mensaje":"' || Lv_Mensaje || '"' 
                                        || '}';
                        --dbms_output.put_line(Pcl_Response);
                        Pv_Status     := 'OK';
                        Pv_Mensaje    := 'Transacción exitosa';

                    END IF;     
                END IF;
            END IF;

            IF Lv_Retorno <> '000' THEN
                Pcl_Response := '{' ||
                                        '"retorno":"' || Lv_Retorno || '",' ||
                                        '"error":' || Lv_Error || '",' ||
                                        '"secuencialRecaudador":null,' || 
                                        '"secuencialPagoInterno":null,' || 
                                        '"fechaConciliacion":null,' ||
                                        '"fechaTransaccionPago":null,' ||
                                        '"mensaje": null'  
                                    || '}';
            END IF;

        ELSE
            Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":' || Lv_Error || '",' ||
                                    '"secuencialRecaudador":null,' || 
                                    '"secuencialPagoInterno":null,' || 
                                    '"fechaConciliacion":null,' ||
                                    '"fechaTransaccionPago":null,' ||
                                    '"mensaje": null'  
                                || '}';

            Pv_Status := 'ERROR';
            Pv_Mensaje := 'Credenciales Validadas Incorrectas';

        END IF;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_CONCILIAR_PAGO_LINEA',
                                          SUBSTR('RESPONSE:'||Pcl_Request,1,4000),
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.P_CONCILIAR_PAGO_LINEA',
                                          'No se realizó pago del cliente. Parametros ('||Pcl_Request||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Lv_Retorno := '003';
        Lv_Error := 'Error, Indisponibilidad del sistema. Error - ' || SQLERRM;
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;  

        Pcl_Response := '{' ||
                                    '"retorno":"' || Lv_Retorno || '",' ||
                                    '"error":' || Lv_Error || '",' ||
                                    '"secuencialRecaudador":null,' || 
                                    '"secuencialPagoInterno":null,' || 
                                    '"fechaConciliacion":null,' ||
                                    '"fechaTransaccionPago":null,'||
                                    '"mensaje": null' 
                                || '}';

    END P_CONCILIAR_PAGO_LINEA;

    /**
    * Documentación para F_REAC_SERVICIO_X_PAGO_LINEA
    * Funcion que realiza reactivacion masiva
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fcl_Request IN CLOB (ID_CANAL_PAGO_LINEA, PREFIJO_EMPRESA_SESSION, ID_EMPRESA, USR_CREACION, ID_PAGO_LINEA)
    * @param RETURN CLOB;
    */ 
    FUNCTION F_REAC_SERVICIO_X_PAGO_LINEA(Fcl_Request CLOB) RETURN CLOB
    AS

        lb_IsReactivado boolean := false ;
        lv_IsReactivado varchar2(5) := 'false' ;
        ln_Proceso_Masivo_Id number:= 0;
        lc_data            SYS_REFCURSOR;
        json_RespuestaPuntos  CLOB;
        json_RequestReact CLOB;
        json_ResponseReactPago CLOB;

        lv_PuntosFO varchar2(4000); 
        lv_PuntosCR varchar2(4000);
        lv_PrefijoEmpresaSesion varchar2(10);
        lv_PrefijoEmpresa varchar2(10);
        ln_TotalFO number ;
        ln_TotalCoRa number;
        lv_CodEmpresa number ;
        lv_Id_Canal_Pago_Linea varchar2(20); 
        lv_Id_Empresa varchar2(20);
        lv_Usr_Creacion varchar2(50);
        lv_Id_pago_linea varchar2(50);

        CURSOR C_GetValidaEmpresaFlujo(Cv_Nombre_Parametro VARCHAR2,Cv_valor1 VARCHAR2, Cv_valor2 VARCHAR2)
        IS SELECT PD.parametro_Id, 
                   PD.descripcion, 
                   PD.valor1, 
                   PD.valor2, 
                   PD.valor3, 
                   PD.valor4, 
                   PD.valor5, 
                   PD.estado, 
                   PD.valor6, 
                   PD.valor7, 
                   PD.observacion 
            FROM DB_GENERAL.Admi_Parametro_Det PD,
                    DB_GENERAL.Admi_Parametro_Cab PC
            WHERE PC.id_parametro = PD.parametro_Id
            AND PC.nombre_Parametro = Cv_Nombre_Parametro
            AND PC.estado = 'Activo'
            AND PD.estado = 'Activo' 
            AND PD.valor1 = Cv_valor1
            AND PD.valor2 = Cv_valor2
            AND ROWNUM <=1;

        CURSOR C_GetValidaPrefijo(Cv_Prefijo VARCHAR2)
        IS
            SELECT imp.* 
            FROM DB_COMERCIAL.Info_Empresa_Grupo imp 
            WHERE PREFIJO = Cv_Prefijo;        

        C_GetValidaEmpresaFlujo_rec   C_GetValidaEmpresaFlujo%ROWTYPE;
        C_GetValidaPrefijo_rec C_GetValidaPrefijo%ROWTYPE;

    BEGIN

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_REAC_SERVICIO_X_PAGO_LINEA',
                                          'Inicio funcion . Parametros (ID_CANAL_PAGO_LINEA: '||lv_Id_Canal_Pago_Linea||','
                                                                      ||'PREFIJO_EMPRESA_SESSION:'||lv_PrefijoEmpresaSesion||','
                                                                      ||'ID_EMPRESA:'||lv_Id_Empresa||','
                                                                      ||'USR_CREACION:'||lv_Usr_Creacion||','
                                                                      ||'ID_PAGO_LINEA:'||lv_Id_pago_linea||
                                                                      ')',               
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );   

        APEX_JSON.PARSE(Fcl_Request);
        lv_Id_Canal_Pago_Linea := APEX_JSON.get_varchar2(p_path => 'ID_CANAL_PAGO_LINEA');
        lv_PrefijoEmpresaSesion := APEX_JSON.get_varchar2(p_path => 'PREFIJO_EMPRESA_SESSION');
        lv_Id_Empresa := APEX_JSON.get_varchar2(p_path => 'ID_EMPRESA');
        lv_Usr_Creacion := APEX_JSON.get_varchar2(p_path => 'USR_CREACION');
        lv_Id_pago_linea := APEX_JSON.get_varchar2(p_path => 'ID_PAGO_LINEA');

        json_RespuestaPuntos := FNCK_PAGOS_LINEA.F_OBTENER_PUNTOS_REACTIVAR('',lv_Id_pago_linea,lv_Id_Empresa);

        APEX_JSON.PARSE(json_RespuestaPuntos); 
        ln_TotalFO  := APEX_JSON.get_number(p_path => 'totalFO'); 
        ln_TotalCoRa  := APEX_JSON.get_number(p_path => 'totalCoRa');
        lv_PuntosFO := APEX_JSON.get_varchar2(p_path => 'FO');
        lv_PuntosCR := APEX_JSON.get_varchar2(p_path => 'CR');

        IF ln_TotalFO > 0 THEN 
            IF C_GetValidaEmpresaFlujo%ISOPEN THEN
                CLOSE C_GetValidaEmpresaFlujo;
            END IF;
            OPEN C_GetValidaEmpresaFlujo('EMPRESA_EQUIVALENTE',lv_PrefijoEmpresaSesion,'FO');
            FETCH C_GetValidaEmpresaFlujo INTO  C_GetValidaEmpresaFlujo_rec ;
            IF C_GetValidaEmpresaFlujo%ISOPEN THEN
                CLOSE C_GetValidaEmpresaFlujo;
            END IF;      

            IF C_GetValidaEmpresaFlujo_rec.valor3 IS NOT NULL THEN
                lv_PrefijoEmpresa:=C_GetValidaEmpresaFlujo_rec.valor3;
            END IF; 

            IF C_GetValidaPrefijo%ISOPEN THEN
                CLOSE C_GetValidaPrefijo;
            END IF;
            OPEN C_GetValidaPrefijo(lv_PrefijoEmpresa);
            FETCH C_GetValidaPrefijo INTO  C_GetValidaPrefijo_rec ;
            IF C_GetValidaPrefijo%ISOPEN THEN
                CLOSE C_GetValidaPrefijo;
            END IF;

            IF C_GetValidaPrefijo_rec.COD_EMPRESA IS NOT NULL THEN 
                lv_CodEmpresa := C_GetValidaPrefijo_rec.COD_EMPRESA;
            END IF ;      

            json_RequestReact := '{'
                || '"ID_CANAL_PAGO_LINEA":"'|| lv_Id_Canal_Pago_Linea || '",'
                || '"PREFIJO_EMPRESA":"'|| lv_PrefijoEmpresa || '",'
                || '"ID_EMPRESA":"'|| lv_Id_Empresa || '",'
                || '"VALOR_MONTO_DEUDA":'||0||','
                || '"IDS_PUNTOS":"'|| lv_PuntosFO || '",'
                || '"CANTIDAD_PUNTOS":'|| ln_TotalFO || ','
                || '"USR_CREACION":"'|| lv_Usr_Creacion || '",'
                || '"CLIENTE_IP":"127.0.0.1",'
                || '"PAGO_LINEA_ID":"'|| lv_Id_pago_linea ||'"'
                || 
            '}';   
            /*INI SOLO POR PRUEBA DESA NO USAR*/
            --lb_IsReactivado:=F_REACTIVAR_SERVICIOS_TTCO(lv_PuntosFO,lv_Usr_Creacion,'127.0.0.1','recaudaciones');
            /*FIN SOLO POR PRUEBA DESA NO USAR*/
            ln_Proceso_Masivo_Id := FNCK_PAGOS_LINEA.F_GUARDAR_PUNTOS_REACT_MASIVO(json_RequestReact); 

        END IF;

        IF ln_TotalCoRa > 0 THEN 
            IF C_GetValidaEmpresaFlujo%ISOPEN THEN
                CLOSE C_GetValidaEmpresaFlujo;
            END IF;
            OPEN C_GetValidaEmpresaFlujo('EMPRESA_EQUIVALENTE',lv_PrefijoEmpresaSesion,'CO');
            FETCH C_GetValidaEmpresaFlujo INTO  C_GetValidaEmpresaFlujo_rec ;
            IF C_GetValidaEmpresaFlujo%ISOPEN THEN
                CLOSE C_GetValidaEmpresaFlujo;
            END IF;

            IF C_GetValidaEmpresaFlujo_rec.valor3 IS NOT NULL THEN
                lv_PrefijoEmpresa:=C_GetValidaEmpresaFlujo_rec.valor3;
            END IF;      

            IF C_GetValidaPrefijo%ISOPEN THEN
                CLOSE C_GetValidaPrefijo;
            END IF;
            OPEN C_GetValidaPrefijo(lv_PrefijoEmpresa);
            FETCH C_GetValidaPrefijo INTO  C_GetValidaPrefijo_rec ;
            IF C_GetValidaPrefijo%ISOPEN THEN
                CLOSE C_GetValidaPrefijo;
            END IF;

            IF C_GetValidaPrefijo_rec.COD_EMPRESA IS NOT NULL THEN 
                lv_CodEmpresa := C_GetValidaPrefijo_rec.COD_EMPRESA;
            END IF; 

            json_RequestReact := '{'
                || '"ID_CANAL_PAGO_LINEA":"'|| lv_Id_Canal_Pago_Linea || '",'
                || '"PREFIJO_EMPRESA":"'|| lv_PrefijoEmpresa || '",'
                || '"ID_EMPRESA":"'|| lv_Id_Empresa || '",'
                || '"VALOR_MONTO_DEUDA":'||0||','
                || '"IDS_PUNTOS":"'|| lv_PuntosCR || '",'
                || '"CANTIDAD_PUNTOS":'|| ln_TotalCoRa || ','
                || '"USR_CREACION":"'|| lv_Usr_Creacion || '",'
                || '"CLIENTE_IP":"127.0.0.1",'
                || '"PAGO_LINEA_ID":"'|| lv_Id_pago_linea ||'"'
                || 
            '}';  
            lb_IsReactivado:= FNCK_PAGOS_LINEA.F_REACTIVAR_SERVICIOS_TTCO(lv_PuntosCR,lv_Usr_Creacion,'127.0.0.1','recaudaciones');
            ln_Proceso_Masivo_Id := FNCK_PAGOS_LINEA.F_GUARDAR_PUNTOS_REACT_MASIVO(json_RequestReact); 
        END IF;

        IF ln_Proceso_Masivo_Id > 0 THEN 
            UPDATE DB_FINANCIERO.Info_Pago_Linea
            SET proceso_masivo_id = ln_Proceso_Masivo_Id
            WHERE id_pago_linea = lv_Id_pago_linea; 
            commit;
            lb_IsReactivado := true ;
        END IF; 

        IF lb_IsReactivado THEN 
            lv_IsReactivado := 'true';
        END IF;

        json_ResponseReactPago := '{'
            || '"IS_REACTIVADO":"'|| lv_IsReactivado || '",'
            || '"PROCESO_MASIVO_ID":'|| ln_Proceso_Masivo_Id || 
        '}';


        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_REAC_SERVICIO_X_PAGO_LINEA',
                                          'Fin funcion . Parametros (ID_CANAL_PAGO_LINEA: '||lv_Id_Canal_Pago_Linea||','
                                                                      ||'PREFIJO_EMPRESA_SESSION:'||lv_PrefijoEmpresaSesion||','
                                                                      ||'ID_EMPRESA:'||lv_Id_Empresa||','
                                                                      ||'USR_CREACION:'||lv_Usr_Creacion||','
                                                                      ||'ID_PAGO_LINEA:'||lv_Id_pago_linea||
                                                                      ')',            
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );                        

        RETURN  json_ResponseReactPago; 
    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_REAC_SERVICIO_X_PAGO_LINEA',
                                          'Problemas guardar reactivacion masivo . Parametros (ID_CANAL_PAGO_LINEA: '||lv_Id_Canal_Pago_Linea||','
                                                                                      ||'PREFIJO_EMPRESA_SESSION:'||lv_PrefijoEmpresaSesion||','
                                                                                      ||'ID_EMPRESA:'||lv_Id_Empresa||','
                                                                                      ||'USR_CREACION:'||lv_Usr_Creacion||','
                                                                                      ||'ID_PAGO_LINEA:'||lv_Id_pago_linea||
                                                                                      ')' 
                                                                                      || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        json_ResponseReactPago := null;                              
        RETURN  json_ResponseReactPago;              

    END F_REAC_SERVICIO_X_PAGO_LINEA; 

    /**
    * Documentación para F_OBTENER_PUNTOS_REACTIVAR
    * Funcion que realiza reactivacion masiva
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_Id_Recaudacion IN VARCHAR2  id recaudacion
    * @param Fv_Id_Pago_Linea IN VARCHAR2 pago linea
    * @param Fv_Empresa_Id IN VARCHAR2 id empresa
    * @param RETURN CLOB Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_PUNTOS_REACTIVAR(Fv_Id_Recaudacion VARCHAR2,Fv_Id_Pago_Linea VARCHAR2, Fv_Empresa_Id VARCHAR2)
    RETURN CLOB
    AS 

        TYPE typ_rec   IS RECORD
        (
          PUNTO_ID      VARCHAR2(20),
          SALDO    number
        );
        TYPE t_rec IS TABLE OF typ_rec INDEX BY PLS_INTEGER;
        Le_PuntoCliente             t_rec;
        Li_Cont_PuntoCliente        PLS_INTEGER;
        Fc_GetSaldosPuntos  SYS_REFCURSOR;
        Fc_GetPagosAnticipo SYS_REFCURSOR;
        Vn_Valor_Permisible number ;
        Vn_Saldo            number ;
        json_Response       CLOB;
        json_Response_Puntos_Reac CLOB;
        Li_Limit            CONSTANT PLS_INTEGER DEFAULT 50;

        ln_TotalFO number ;
        ln_TotalCoRa number;

        lv_PuntosFO_Final varchar2(4000); 
        lv_PuntosCR_Final varchar2(4000);
        ln_TotalFO_Final  number :=0 ;
        ln_TotalCoRa_Final number := 0;

        CURSOR C_GetParamActivacion(Cv_Nombre_Parametro VARCHAR2,Cv_Modulo VARCHAR2,Cv_valor VARCHAR2, Cv_id_empresa VARCHAR2)
        IS   SELECT PD.parametro_Id, 
                    PD.descripcion, 
                    PD.valor1, 
                    PD.valor2, 
                    PD.valor3, 
                    PD.valor4, 
                    PD.valor5, 
                    PD.estado, 
                    PD.valor6, 
                    PD.valor7, 
                    PD.observacion 
        FROM DB_GENERAL.Admi_Parametro_Det PD,
                DB_GENERAL.Admi_Parametro_Cab PC
        WHERE PC.id_parametro = PD.parametro_Id
        AND PC.nombre_Parametro = Cv_Nombre_Parametro
        AND PC.modulo = Cv_Modulo
        AND PC.estado = 'Activo'
        AND PD.estado = 'Activo' 
        AND PD.valor1 = Cv_valor
        AND PD.empresa_Cod = Cv_id_empresa
        AND ROWNUM <=1;

        C_GetParamActivacion_rec   C_GetParamActivacion%ROWTYPE;

    BEGIN

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_PUNTOS_REACTIVAR',
                                          'Inicio funcion PUNTOS A REACTIVAR . Parametros (Id_recaudacion: '||Fv_Id_Recaudacion||','||'Id_pago_linea:'||Fv_Id_Pago_Linea||','||'Id_empresa:'||Fv_Empresa_Id  ||')',
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

          IF C_GetParamActivacion%ISOPEN THEN
                    CLOSE C_GetParamActivacion;
                END IF;
                OPEN C_GetParamActivacion('LIMITE_SALDO_REACTIVACION','FINANCIERO','VALOR_PERMISIBLE',Fv_Empresa_Id);
                FETCH C_GetParamActivacion INTO  C_GetParamActivacion_rec ;
                IF C_GetParamActivacion%ISOPEN THEN
                    CLOSE C_GetParamActivacion;
                END IF;
     IF C_GetParamActivacion_rec.valor2 IS NOT NULL THEN 

       Vn_Valor_Permisible := C_GetParamActivacion_rec.valor2;

     END IF;  

    Fc_GetSaldosPuntos :=  F_OBTENER_SALDOS_PUNTOS_REAC(Fv_Id_Recaudacion,Fv_Id_Pago_Linea);


    FETCH Fc_GetSaldosPuntos BULK COLLECT INTO Le_PuntoCliente LIMIT Li_Limit;
            Li_Cont_PuntoCliente := Le_PuntoCliente.FIRST;

     WHILE (Li_Cont_PuntoCliente IS NOT NULL) LOOP        

            IF Le_PuntoCliente(Li_Cont_PuntoCliente).saldo IS NOT NULL THEN
             Vn_Saldo := Le_PuntoCliente(Li_Cont_PuntoCliente).saldo;



              IF Vn_Saldo <= Vn_Valor_Permisible THEN 

               json_response := F_OBTENER_PUNTOS_X_ULT_MILLA(Le_PuntoCliente(Li_Cont_PuntoCliente).punto_id); 

               --WSA VERIFICA RESPUESTA DE VALIDACION
               IF json_response IS NOT NULL THEN

               APEX_JSON.PARSE(json_response); 
               ln_TotalFO  := APEX_JSON.get_number(p_path => 'totalFO'); 
               ln_TotalCoRa  := APEX_JSON.get_number(p_path => 'totalCoRa');


               --WSA COMPRUEBA SI PASO VALIDACION FO 
                 IF  ln_TotalFO > 0 THEN

                    lv_PuntosFO_Final  := lv_PuntosFO_Final||''||Le_PuntoCliente(Li_Cont_PuntoCliente).punto_id || '|'; 
                    ln_TotalFO_Final := ln_TotalFO_Final + 1 ; 
                 END IF; 

                   --WSA COMPRUEBA SI PASO VALIDACION CO 
                 IF ln_TotalCoRa > 0 THEN 

                     lv_PuntosCR_Final  := lv_PuntosCR_Final||''||Le_PuntoCliente(Li_Cont_PuntoCliente).punto_id || '|'; 
                     ln_TotalCoRa_Final := ln_TotalCoRa_Final + 1 ; 

                 END IF;

               END IF;


            END IF;

        END IF; 

              Li_Cont_PuntoCliente := Le_PuntoCliente.NEXT(Li_Cont_PuntoCliente);

    END LOOP; 



      --WSA ELIMINA SIGNO FINAL 
      IF ln_TotalFo_Final > 0 THEN 

             lv_PuntosFO_Final := SUBSTR(lv_PuntosFO_Final, 0, (LENGTH(lv_PuntosFO_Final)-1));

      END IF ;

      --WSA ELIMINA SIGNO FINAL       
      IF ln_TotalCoRa_Final > 0 THEN 

             lv_PuntosCR_Final := SUBSTR(lv_PuntosCR_Final, 0, (LENGTH(lv_PuntosCR_Final)-1));

      END IF ;

             json_Response_Puntos_Reac := '{'
                                  || '"FO":"'|| lv_PuntosFO_Final || '",'
                                  || '"totalFO":'|| ln_TotalFo_Final || ','
                                  || '"CR":"'|| lv_PuntosCR_Final  || '",'
                                  || '"totalCoRa":'|| ln_TotalCoRa_Final
                                  || '}';

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                              'FNCK_PAGOS_LINEA.F_OBTENER_PUNTOS_REACTIVAR',
                                              'Fin funcion PUNTOS A REACTIVAR . Parametros (Id_recaudacion: '||Fv_Id_Recaudacion||','||'Id_pago_linea:'||Fv_Id_Pago_Linea||','||'Id_empresa:'||Fv_Empresa_Id  ||')',
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        RETURN json_Response_Puntos_Reac;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_PUNTOS_REACTIVAR',
                                          'No se encontró registros PUNTOS A REACTIVAR . Parametros (Id_recaudacion: '||Fv_Id_Recaudacion||','||'Id_pago_linea:'||Fv_Id_Pago_Linea||','||'Id_empresa:'||Fv_Empresa_Id  ||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        json_Response_Puntos_Reac := NULL;
        RETURN json_Response_Puntos_Reac;

    END F_OBTENER_PUNTOS_REACTIVAR; 

    /**
    * Documentación para F_OBTENER_SALDOS_PUNTOS_REAC
    * Funcion que sirve para obtener los servicios a reactivar
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_Id_Recaudacion IN VARCHAR2  id recaudacion
    * @param Fv_Id_Pago_Linea IN VARCHAR2 pago linea
    * @param Fv_Empresa_Id IN VARCHAR2 id empresa
    * @param RETURN CLOB Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_SALDOS_PUNTOS_REAC(Fv_id_Recaudacion VARCHAR2, Fv_id_Pago_Linea VARCHAR2)
    RETURN SYS_REFCURSOR
    IS  
        fechaIni TIMESTAMP;
        fechaFin TIMESTAMP; 
        Fc_GetSaldosPuntos SYS_REFCURSOR;
        Lcl_Select CLOB;
        Lcl_Where CLOB;
        Lcl_From CLOB;
        Lcl_Query CLOB;

    BEGIN  

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                              'FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_PUNTOS_REAC',
                                              'Inicio funcion. Parametros (id_recaudacion: '||Fv_id_Recaudacion||', id_pago_linea: '
                                              ||Fv_id_Pago_Linea||')' ,
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Lcl_Select  := 'SELECT est.PUNTO_ID, est.SALDO' ;   
        Lcl_From    := ' FROM (SELECT
                        ESTADO_CUENTA.PUNTO_ID, SUM(ESTADO_CUENTA.VALOR_TOTAL) SALDO
                        FROM
                        (SELECT
                        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2) as valor_total
                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
                        WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
                        NOT IN (''Inactivo'', ''Anulado'',''Anulada'',''Rechazada'',''Rechazado'',
                        ''Pendiente'',''Aprobada'',''Eliminado'',''ErrorGasto'',''ErrorDescuento'',''ErrorDuplicidad'') 
                        AND TIPO_DOCUMENTO_ID not in (6,8)
                        UNION ALL
                        SELECT
                        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2)*-1 as valor_total
                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
                        WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
                        NOT IN (''Inactivo'', ''Anulado'',''Anulada'',''Rechazada'',''Rechazado'',''Pendiente'',''Aprobada'',''Eliminado'') 
                        AND TIPO_DOCUMENTO_ID in (6,8)
                        UNION ALL
                        SELECT
                        DB_FINANCIERO.INFO_PAGO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_PAGO_DET.valor_pago,2)*-1 as valor_pago
                        FROM DB_FINANCIERO.INFO_PAGO_CAB,
                        DB_FINANCIERO.INFO_PAGO_DET
                        WHERE DB_FINANCIERO.INFO_PAGO_CAB.estado_pago NOT IN (''Inactivo'', ''Anulado'',''Asignado'')
                        AND DB_FINANCIERO.INFO_PAGO_CAB.id_pago = DB_FINANCIERO.INFO_PAGO_DET.pago_id
                        AND NOT EXISTS( SELECT anto.id_pago
                                        FROM DB_FINANCIERO.INFO_PAGO_CAB anto
                                        WHERE DB_FINANCIERO.INFO_PAGO_CAB.ANTICIPO_ID=anto.ID_PAGO 
                                        AND anto.ESTADO_PAGO=''Cerrado''
                                        AND DB_FINANCIERO.INFO_PAGO_CAB.TIPO_DOCUMENTO_ID = 10
                                      )     
                        ) ESTADO_CUENTA
                        GROUP BY ESTADO_CUENTA.PUNTO_ID) est
                        JOIN DB_FINANCIERO.Info_Pago_Cab cab on cab.punto_id = est.punto_id';
        IF Fv_id_Recaudacion IS NOT NULL THEN
            Lcl_Where := ' WHERE cab.recaudacion_Id = '''||Fv_id_Recaudacion||'''  AND  cab.punto_Id IS NOT NULL GROUP BY est.PUNTO_ID, est.saldo';
        END IF;

        IF Fv_id_Pago_Linea IS NOT NULL THEN
             Lcl_Where := ' WHERE cab.PAGO_LINEA_ID  = '''||Fv_id_Pago_Linea||'''  AND  cab.punto_Id IS NOT NULL GROUP BY est.PUNTO_ID, est.saldo';
        END IF;

        Lcl_Query := Lcl_Select || Lcl_From || Lcl_Where;    

        fechaIni := SYSTIMESTAMP;

        OPEN Fc_GetSaldosPuntos FOR Lcl_Query;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_PUNTOS_REAC',
                                          'Fin funcion. Parametros (id_recaudacion: '||Fv_id_Recaudacion||', id_pago_linea: '
                                          ||Fv_id_Pago_Linea||')' ,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        RETURN Fc_GetSaldosPuntos;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_PUNTOS_REAC',
                                          'No se encontró registros del cliente. Parametros (id_recaudacion: '||Fv_id_Recaudacion||', id_pago_linea: '
                                          ||Fv_id_Pago_Linea||')' 
                                          || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Fc_GetSaldosPuntos := NULL;
        RETURN Fc_GetSaldosPuntos; 

    END F_OBTENER_SALDOS_PUNTOS_REAC;


    /**
    * Documentación para F_OBTENER_PUNTOS_X_ULT_MILLA
    * Funcion que realiza reactivacion masiva
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_Id_Punto IN VARCHAR2  Id punto
    * @param RETURN CLOB Devuelve respuesta con data
    */
    FUNCTION F_OBTENER_PUNTOS_X_ULT_MILLA(Fv_Id_Punto VARCHAR2)
    RETURN CLOB
    IS 

        lv_Punto_Ultima  VARCHAR2(10);
        ln_Total_Fo  NUMBER:=0 ;
        ln_Total_CoRa NUMBER:=0 ;
        lv_Ultima_Milla_json clob ;

         CURSOR C_GetPagoAnticipo(Pv_Id_Punto VARCHAR2)
             IS    select info.punto_id 
                     from DB_COMERCIAL.Info_Servicio info  
                    where info.estado = 'In-Corte' 
                    and info.punto_id = Pv_Id_Punto;  

           ---WSA SE AGREGA VALIDACION PARA SERVICIOS INAUDIT         
         CURSOR C_GetValidaInAudit(Pv_Id_Punto VARCHAR2)               
            IS    select count(*) as c_InAudit
                from DB_COMERCIAL.Info_Servicio info  
                where info.estado = 'In-Corte' 
                and info.punto_id = Pv_Id_Punto
                and info.id_servicio in ( select infoc.servicio_id 
                                from DB_COMERCIAL.Info_Servicio_Caracteristica infoc 
                                where infoc.estado = 'Activo'
                                and infoc.caracteristica_Id in ( select ac.id_caracteristica 
                                                                from DB_COMERCIAL.Admi_Caracteristica ac
                                                                where ac.descripcion_Caracteristica = 'InAudit'
                                                                and ac.estado = 'Activo'
                                                                )
                ) ;      

         C_GetPagoAnticipo_rec SYS_REFCURSOR;
         C_GetValidaInAudit_rec C_GetValidaInAudit%ROWTYPE;

    BEGIN 
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_PUNTOS_X_ULT_MILLA',
                                          'Inicio funcion . Parametros (id_punto: '||Fv_Id_Punto||')' ,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') ); 

        IF C_GetValidaInAudit%ISOPEN THEN
                    CLOSE C_GetValidaInAudit;
                END IF;
                OPEN C_GetValidaInAudit(Fv_Id_Punto);
                FETCH C_GetValidaInAudit INTO  C_GetValidaInAudit_rec ;
                IF C_GetValidaInAudit%ISOPEN THEN
                    CLOSE C_GetValidaInAudit;
                END IF;

     IF C_GetValidaInAudit_rec.c_InAudit = 0 THEN 

        FOR C_GetPagoAnticipo_rec IN C_GetPagoAnticipo(Fv_Id_Punto)
         LOOP

            lv_Punto_Ultima:= DB_COMERCIAL.TECNK_SERVICIOS.FNC_GET_MEDIO_POR_PUNTO(C_GetPagoAnticipo_rec.punto_id,'INTERNET');

            IF lv_Punto_Ultima IS NOT NULL THEN

              IF lv_Punto_Ultima = 'FO' THEN

                ln_Total_Fo := ln_Total_Fo +1 ; 

              END IF ; 


              IF lv_Punto_Ultima = 'CO' OR  lv_Punto_Ultima = 'RAD' THEN

                ln_Total_CoRa := ln_Total_CoRa +1 ; 

              END IF ;

            END IF;

         END LOOP;

      END IF;

             -- WSA SE MODIFICA JSON RESPUESTA SE ENVIA RESPUESTA VALIDACION Y TIPO
             lv_Ultima_Milla_json := '{'
                                  || '"totalFO":'|| ln_Total_Fo || ','
                                  || '"totalCoRa":'|| ln_Total_CoRa
                                  || '}';

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_PUNTOS_X_ULT_MILLA',
                                          'Fin funcion . Parametros (id_punto: '||Fv_Id_Punto||')' ,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') ); 

    RETURN lv_Ultima_Milla_json;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                      'FNCK_PAGOS_LINEA.F_OBTENER_PUNTOS_X_ULT_MILLA',
                                      'No se encontró registros ultima milla . Parametros (id_punto: '||Fv_Id_Punto||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                      SYSDATE,
                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        lv_Ultima_Milla_json := NULL;
        RETURN lv_Ultima_Milla_json;

    END F_OBTENER_PUNTOS_X_ULT_MILLA;

    /**
    * Documentación para F_GUARDAR_PUNTOS_REACT_MASIVO
    * Funcion que guardado en los esquemas de reactivacion masiva
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param fr_request IN CLOB  Id punto
    * @param RETURN NUMBER Devuelve respuesta con el id de reactivacion
    */   
    FUNCTION F_GUARDAR_PUNTOS_REACT_MASIVO(fr_request CLOB) 
    RETURN NUMBER
    IS
        ln_Proceso_Masivo_Id number;
        lv_Id_Canal_Pago_Linea varchar2(50);
        lv_PrefijoEmpresa varchar2(50);
        lv_Id_Empresa varchar2(50);
        ln_Monto_Deuda number;
        lv_Puntos varchar2(4000);
        ln_Total number;
        lv_Usr_Creacion varchar2(50);
        lv_Cliente_IP varchar2(50);
        lv_Id_pago_linea varchar2(50);
        lv_MsnError VARCHAR2(2000); 
        lv_Servicios_Reactivar varchar2(4000);
        row_info_proceso_masivo DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;   
        row_IdInfoProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE := 0;
        row_info_proceso_masivo_det DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;   
        row_IdInfoProcesoMasivoDet DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE := 0;

    BEGIN 
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_GUARDAR_PUNTOS_REACT_MASIVO',
                                          'Inicio Funcion . Parametros (ID_CANAL_PAGO_LINEA: '||lv_Id_Canal_Pago_Linea||','
                                                                          ||'PREFIJO_EMPRESA:'||lv_PrefijoEmpresa||','
                                                                          ||'ID_EMPRESA:'||lv_Id_Empresa||','
                                                                          ||'VALOR_MONTO_DEUDA:'||ln_Monto_Deuda||','
                                                                          ||'IDS_PUNTOS:'||lv_Puntos||','
                                                                          ||'CANTIDAD_PUNTOS:'||ln_Total||','
                                                                          ||'USR_CREACION:'||lv_Usr_Creacion||','
                                                                          ||'CLIENTE_IP:'||lv_Cliente_IP||','
                                                                          ||'PAGO_LINEA_ID:'||lv_Id_pago_linea||
                                                                                              ')',            
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        APEX_JSON.PARSE(fr_request);
        lv_Id_Canal_Pago_Linea := APEX_JSON.get_varchar2(p_path => 'ID_CANAL_PAGO_LINEA');
        lv_PrefijoEmpresa := APEX_JSON.get_varchar2(p_path => 'PREFIJO_EMPRESA');
        lv_Id_Empresa := APEX_JSON.get_varchar2(p_path => 'ID_EMPRESA');
        ln_Monto_Deuda := APEX_JSON.get_number(p_path => 'VALOR_MONTO_DEUDA');
        lv_Puntos := APEX_JSON.get_varchar2(p_path => 'IDS_PUNTOS');
        ln_Total := APEX_JSON.get_varchar2(p_path => 'CANTIDAD_PUNTOS');
        lv_Usr_Creacion := APEX_JSON.get_varchar2(p_path => 'USR_CREACION');
        lv_Cliente_IP := APEX_JSON.get_varchar2(p_path => 'CLIENTE_IP');
        lv_Id_pago_linea := APEX_JSON.get_varchar2(p_path => 'PAGO_LINEA_ID');

        row_info_proceso_masivo.tipo_proceso := 'ReconectarCliente';
        row_info_proceso_masivo.cantidad_puntos := ln_Total; 
        row_info_proceso_masivo.empresa_id := lv_Id_Empresa; 
        row_info_proceso_masivo.valor_deuda := ln_Monto_Deuda;
        row_info_proceso_masivo.ids_oficinas := null; 

        IF lv_PrefijoEmpresa = 'TTCO' THEN 
            row_info_proceso_masivo.estado := 'Activo';
            row_info_proceso_masivo.usr_ult_mod:= lv_Usr_Creacion;
            row_info_proceso_masivo.fe_ult_mod := sysdate; 
        ELSE
            row_info_proceso_masivo.estado := 'Pendiente';
        END IF ;

        row_info_proceso_masivo.fe_creacion := sysdate;
        row_info_proceso_masivo.usr_creacion := lv_Usr_Creacion;
        row_info_proceso_masivo.ip_creacion := lv_Cliente_IP;
        row_info_proceso_masivo.canal_pago_linea_id := lv_Id_Canal_Pago_Linea;
        row_info_proceso_masivo.pago_id := null; 
        row_info_proceso_masivo.pago_linea_id := lv_Id_pago_linea; 
        row_info_proceso_masivo.recaudacion_id :=null;
        row_info_proceso_masivo.debito_id := null;

        DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.INSERT_PROCESO_MASIVO_CAB(row_info_proceso_masivo, row_IdInfoProcesoMasivoCab, Lv_MsnError);

        FOR lv_punto  in (SELECT regexp_substr(lv_puntos, '[^|]+', 1, LEVEL) as punto
                                 FROM DUAL
                        CONNECT BY regexp_substr(lv_puntos, '[^|]+', 1, LEVEL) IS NOT NULL)             
        LOOP 
            row_info_proceso_masivo_det.punto_id  := lv_punto.punto; 
            row_info_proceso_masivo_det.proceso_masivo_cab_id := row_IdInfoProcesoMasivoCab; 

            IF lv_PrefijoEmpresa = 'TTCO' THEN 
                row_info_proceso_masivo_det.estado := 'Activo';
                row_info_proceso_masivo_det.usr_ult_mod:= lv_Usr_Creacion;
                row_info_proceso_masivo_det.fe_ult_mod := sysdate; 
            ELSE 
                row_info_proceso_masivo_det.estado := 'Pendiente';
            END IF ; 

            row_info_proceso_masivo_det.fe_creacion := sysdate;
            row_info_proceso_masivo_det.usr_creacion := lv_Usr_Creacion;
            row_info_proceso_masivo_det.ip_creacion := lv_Cliente_IP;

            DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.INSERT_PROCESO_MASIVO_DET(row_info_proceso_masivo_det, row_IdInfoProcesoMasivoDet, Lv_MsnError);
        END LOOP; 

        ln_Proceso_Masivo_Id := row_IdInfoProcesoMasivoCab; 


        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_GUARDAR_PUNTOS_REACT_MASIVO',
                                          'Fin funcion . Parametros (ID_CANAL_PAGO_LINEA: '||lv_Id_Canal_Pago_Linea||','
                                                                          ||'PREFIJO_EMPRESA:'||lv_PrefijoEmpresa||','
                                                                          ||'ID_EMPRESA:'||lv_Id_Empresa||','
                                                                          ||'VALOR_MONTO_DEUDA:'||ln_Monto_Deuda||','
                                                                          ||'IDS_PUNTOS:'||lv_Puntos||','
                                                                          ||'CANTIDAD_PUNTOS:'||ln_Total||','
                                                                          ||'USR_CREACION:'||lv_Usr_Creacion||','
                                                                          ||'CLIENTE_IP:'||lv_Cliente_IP||','
                                                                          ||'PAGO_LINEA_ID:'||lv_Id_pago_linea||
                                                                          ')',               
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        RETURN ln_Proceso_Masivo_Id;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                      'FNCK_PAGOS_LINEA.F_GUARDAR_PUNTOS_REACT_MASIVO',
                                      'Problemas al reactivar servicio Masivos . Parametros (ID_CANAL_PAGO_LINEA: '||lv_Id_Canal_Pago_Linea||','
                                                                                          ||'PREFIJO_EMPRESA:'||lv_PrefijoEmpresa||','
                                                                                          ||'ID_EMPRESA:'||lv_Id_Empresa||','
                                                                                          ||'VALOR_MONTO_DEUDA:'||ln_Monto_Deuda||','
                                                                                          ||'IDS_PUNTOS:'||lv_Puntos||','
                                                                                          ||'CANTIDAD_PUNTOS:'||ln_Total||','
                                                                                          ||'USR_CREACION:'||lv_Usr_Creacion||','
                                                                                          ||'CLIENTE_IP:'||lv_Cliente_IP||','
                                                                                          ||'PAGO_LINEA_ID:'||lv_Id_pago_linea||
                                                                                          ')' 
                                                                                          || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                      SYSDATE,
                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        ln_Proceso_Masivo_Id := NULL;
        return ln_Proceso_Masivo_Id; 

    END F_GUARDAR_PUNTOS_REACT_MASIVO;

    /**
    * Documentación para F_REACTIVAR_SERVICIOS_TTCO
    * Funcion para reactivacion TTCO
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    * @param Fv_Punto_Reactivar IN VARCHAR2  puntos a reactiva
    * @param Fv_Usr_Creacion IN VARCHAR2 usuarios creacion
    * @param Fv_Cliente_Ip IN VARCHAR2 Ip cliente
    * @param Fv_Proceso IN VARCHAR2 proceso ejecucion
    * @param RETURN boolean estado de la operacion true/false
    */
    FUNCTION F_REACTIVAR_SERVICIOS_TTCO(Fv_Punto_Reactivar varchar2, Fv_Usr_Creacion varchar2, Fv_Cliente_Ip varchar2, Fv_Proceso varchar2) RETURN boolean
    IS

        CURSOR C_GetServicioYPuntos(Pv_Id_Puntos VARCHAR2)
        IS
            select distinct s.id_servicio
            from DB_COMERCIAL.Info_Servicio s, 
                DB_COMERCIAL.Info_Plan_Cab pc, 
                DB_COMERCIAL.Info_Plan_Det pd, 
                DB_COMERCIAL.Admi_Producto p
            where pc.ID_PLAN = s.plan_Id
            and pd.plan_Id = pc.ID_PLAN
            and p.id_producto = pd.producto_Id
            and s.estado = 'In-Corte'
            and p.nombre_Tecnico = 'INTERNET'
            and s.punto_Id in(Pv_Id_Puntos);

        CURSOR C_GetInfoServicios(Cv_Id_Servicio VARCHAR2)
        IS
            select isr.* 
            from DB_COMERCIAL.Info_Servicio isr 
            where id_servicio = Cv_Id_Servicio;      

        C_GetServicioYPuntos_rec C_GetServicioYPuntos%ROWTYPE; 
        C_GetInfoServicios_rec C_GetInfoServicios%ROWTYPE; 
        lb_Tiene_Servicios boolean :=false;
        lv_Servicios_Reactivar varchar2(4000);
        lv_Entorno varchar2(20):= 'production';  
        lv_Jar_Name varchar2(50):='ttco_reactivacionMasiva.jar'; 
        lv_Ruta_Log varchar2(400):= '/home/telcos/src/telconet/tecnicoBundle/batch/'; 
        lv_Nombre_Log varchar2(20):= 'reactivacionMasiva';
        lv_Ejecutar varchar2(32767);
        lv_Fecha_Doc varchar2(20);
        lv_Comando  varchar2(500):='SIN RESPUESTA';

    BEGIN 
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_REACTIVAR_SERVICIOS_TTCO',
                                          'Inicio funcion . Parametros (Puntos_Reactivar: '||Fv_Punto_Reactivar||','||'Usr_Creacion:'||Fv_Usr_Creacion||','||'Cliente_IP:'||Fv_Cliente_Ip||','||'Proceso:'||Fv_Proceso  ||')' ,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );



        FOR lv_punto  in (SELECT regexp_substr(Fv_Punto_Reactivar, '[^|]+', 1, LEVEL) as punto
                 FROM DUAL
        CONNECT BY regexp_substr(Fv_Punto_Reactivar, '[^|]+', 1, LEVEL) IS NOT NULL)  
        LOOP 

            FOR C_GetServicioYPuntos_rec in  C_GetServicioYPuntos(lv_punto.punto) 
            LOOP
                lv_Servicios_Reactivar := lv_Servicios_Reactivar ||''||C_GetServicioYPuntos_rec.id_servicio ||'|';     
                lb_Tiene_Servicios:=true;

                IF C_GetInfoServicios%ISOPEN THEN
                    CLOSE C_GetInfoServicios;
                END IF;
                OPEN C_GetInfoServicios(C_GetServicioYPuntos_rec.id_servicio);
                FETCH C_GetInfoServicios INTO  C_GetInfoServicios_rec ;
                IF C_GetInfoServicios%ISOPEN THEN
                    CLOSE C_GetInfoServicios;
                END IF;

                IF C_GetInfoServicios_rec.id_servicio IS NOT NULL THEN 
                    UPDATE DB_COMERCIAL.Info_Servicio  
                    SET estado = 'Activo' 
                    WHERE id_servicio = C_GetInfoServicios_rec.id_servicio;
                    commit ;

                    UPDATE DB_COMERCIAL.Info_Punto 
                    SET estado = 'Activo' 
                    WHERE id_punto = C_GetInfoServicios_rec.punto_id;
                    commit ;

                    INSERT
                    INTO DB_COMERCIAL.Info_Servicio_Historial
                    (
                        ID_SERVICIO_HISTORIAL,
                        Observacion, 
                        Servicio_id, 
                        Estado,
                        Accion, 
                        Usr_Creacion,
                        Ip_Creacion,
                        Fe_creacion
                    )
                    VALUES(
                        DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                        'El servicio se reactivo exitosamente',
                        C_GetInfoServicios_rec.id_servicio,
                        'Activo',
                        'reconectarCliente',
                        Fv_Usr_Creacion,
                        '127.0.0.1',
                        sysdate
                    ); 
                    commit ;

                END IF ; 
            END LOOP; 
        END LOOP;  

        IF lb_Tiene_Servicios THEN 
            lv_Servicios_Reactivar := SUBSTR(lv_Servicios_Reactivar, 0, (LENGTH(lv_Servicios_Reactivar)-1));
            lv_Fecha_Doc:=to_date(sysdate,'yyyy-mm-dd') ; 
            lv_Comando:= '/opt/ibm-java-ppc64-71/jre/bin/java -Denviroment=' ||
                                    lv_Entorno ||
                                    ' -jar /home/oracle/scripts/'|| lv_Jar_Name 
                                    ||' '||lv_Servicios_Reactivar ||' '|| Fv_Usr_Creacion||' '||Fv_Cliente_Ip/*||' >> '||lv_Ruta_Log||''||lv_Nombre_Log||'-'||lv_Fecha_Doc||'.txt'*/; 
            --lv_Ejecutar:= NAF47_TNET.javaruncommand(lv_Comando);

            BEGIN
                lv_Ejecutar:= FNCK_PAGOS_LINEA.F_LLAMAR_JAR(lv_Servicios_Reactivar, Fv_Usr_Creacion, Fv_Cliente_Ip);
            EXCEPTION
                WHEN OTHERS THEN
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_REACTIVAR_SERVICIOS_TTCO.JAR',
                                          '(Puntos_Reactivar: '||Fv_Punto_Reactivar||','||'Usr_Creacion:'||Fv_Usr_Creacion||','||'Cliente_IP:'||Fv_Cliente_Ip||','||'Proceso:'||Fv_Proceso  ||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
            END;

        END IF ;

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_REACTIVAR_SERVICIOS_TTCO',
                                          'Fin funcion . Parametros (Puntos_Reactivar: '||Fv_Punto_Reactivar||','||'Usr_Creacion:'||Fv_Usr_Creacion||','||'Cliente_IP:'||Fv_Cliente_Ip||','||'Proceso:'||Fv_Proceso  ||')' ,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        RETURN lb_Tiene_Servicios; 

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_REACTIVAR_SERVICIOS_TTCO',
                                          'Problemas al reactivar servicio TTCO. Parametros (Puntos_Reactivar: '||Fv_Punto_Reactivar||','||'Usr_Creacion:'||Fv_Usr_Creacion||','||'Cliente_IP:'||Fv_Cliente_Ip||','||'Proceso:'||Fv_Proceso  ||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        lb_Tiene_Servicios := NULL;
        RETURN lb_Tiene_Servicios; 

    END F_REACTIVAR_SERVICIOS_TTCO;

    /**
    * Documentación para F_OBTENER_SALDOS_PUNTOS
    * Procedimiento que realiza la consulta de saldo por id_persona
    * 
    * @author William Sanchez <wdsanchez@telconet.ec>
    * @version 1.0 11/07/2022
    * 
    *
    * @param Fv_IdPersona IN VARCHAR2  id persona
    * @param Fv_EmpresaCod IN VARCHAR2 codigo empresa
    * @param RETURN SYS_REFCURSOR Devuelve respuesta con data
    */
    FUNCTION F_OBTENER_SALDOS_PUNTOS(Fv_IdPersona IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2)
    RETURN SYS_REFCURSOR
    IS                  
        Fc_GetSaldosPuntos SYS_REFCURSOR;
        fechaIni TIMESTAMP;
        fechaFin TIMESTAMP; 
    BEGIN    

       fechaIni := SYSTIMESTAMP;
        OPEN Fc_GetSaldosPuntos FOR
        SELECT est.PUNTO_ID
            FROM (SELECT
                       ESTADO_CUENTA.PUNTO_ID, SUM(ESTADO_CUENTA.VALOR_TOTAL) SALDO
                        FROM
                        (SELECT

                        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2) as valor_total
                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
                        WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
                        NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado',
                        'Pendiente','Aprobada','Eliminado','ErrorGasto','ErrorDescuento','ErrorDuplicidad') 
                        AND TIPO_DOCUMENTO_ID not in (6,8)
                        UNION ALL
                        SELECT
                        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.valor_total,2)*-1 as valor_total
                        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
                        WHERE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.estado_impresion_fact
                        NOT IN ('Inactivo', 'Anulado','Anulada','Rechazada','Rechazado','Pendiente','Aprobada','Eliminado') 
                        AND TIPO_DOCUMENTO_ID in (6,8)
                        UNION ALL
                        SELECT
                        DB_FINANCIERO.INFO_PAGO_CAB.punto_id,
                        round(DB_FINANCIERO.INFO_PAGO_DET.valor_pago,2)*-1 as valor_pago
                        FROM DB_FINANCIERO.INFO_PAGO_CAB,
                        DB_FINANCIERO.INFO_PAGO_DET
                        WHERE DB_FINANCIERO.INFO_PAGO_CAB.estado_pago NOT IN ('Inactivo', 'Anulado','Asignado')
                        AND DB_FINANCIERO.INFO_PAGO_CAB.id_pago = DB_FINANCIERO.INFO_PAGO_DET.pago_id
                        AND NOT EXISTS( SELECT anto.id_pago
                                        FROM DB_FINANCIERO.INFO_PAGO_CAB anto
                                        WHERE DB_FINANCIERO.INFO_PAGO_CAB.ANTICIPO_ID=anto.ID_PAGO 
                                        AND anto.ESTADO_PAGO='Cerrado'
                                        AND DB_FINANCIERO.INFO_PAGO_CAB.TIPO_DOCUMENTO_ID = 10
                                      )     
                        ) ESTADO_CUENTA
                        GROUP BY ESTADO_CUENTA.PUNTO_ID) est
            JOIN DB_COMERCIAL.info_punto pun on pun.id_punto = est.punto_id
            JOIN DB_COMERCIAL.info_persona_empresa_rol rol on rol.id_persona_rol = pun.persona_empresa_rol_id
            JOIN DB_COMERCIAL.info_empresa_rol emp on emp.id_empresa_rol = rol.empresa_rol_id
            JOIN DB_COMERCIAL.Admi_Rol rolAdm on rolAdm.ID_ROL = emp.ROL_ID 
            JOIN DB_COMERCIAL.Admi_Tipo_Rol trol on trol.ID_TIPO_ROL = rolAdm.TIPO_ROL_ID
            WHERE trol.descripcion_Tipo_Rol IN ('Cliente','Pre-cliente') 
              and rol.estado IN ('Activo','Activa','Cancelado','Cancelada','PendAprobSolctd','Pend-convertir') 
              and emp.EMPRESA_COD = Fv_EmpresaCod
              and rol.persona_id = Fv_IdPersona
              and est.saldo >  0
              group by est.PUNTO_ID; 

               fechaFin := SYSTIMESTAMP;


        RETURN Fc_GetSaldosPuntos;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_PUNTOS',
                                          'No se encontró registros del cliente. Parametros (persona_id: '||Fv_IdPersona||', Codigo_empresa: '
                                          ||Fv_EmpresaCod||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        Fc_GetSaldosPuntos := NULL;
        RETURN Fc_GetSaldosPuntos; 

    END F_OBTENER_SALDOS_PUNTOS;

    /**
    * Documentación para F_OBTENER_FACTURAS_ABIERTAS
    * Procedimiento que realiza la consulta de las facturas abiertas y el saldo por los puntos del cliente
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    * 
    * @param Fv_IdPersona IN VARCHAR2  id persona
    * @param Fv_EmpresaCod IN VARCHAR2 codigo empresa
    * @param RETURN SYS_REFCURSOR Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_FACTURAS_ABIERTAS(Fv_IdPersona IN VARCHAR2, Fv_EmpresaCod IN VARCHAR2)
    RETURN SYS_REFCURSOR
    IS  
        --tab_points      t_points   :=    t_points();
        puntosFact  VARCHAR2(3000);
        points      NUMBER;
        Fc_GetDocumentosFinancieros SYS_REFCURSOR;
        v_points_cursor SYS_REFCURSOR;

        Le_PuntoCliente             T_PuntoCliente;
        Li_Cont_PuntoCliente        PLS_INTEGER;
        Li_Limit                    CONSTANT PLS_INTEGER DEFAULT 50;
    BEGIN
        v_points_cursor := FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_PUNTOS(Fv_IdPersona, Fv_EmpresaCod);

        FETCH v_points_cursor BULK COLLECT INTO Le_PuntoCliente LIMIT Li_Limit;
        Li_Cont_PuntoCliente := Le_PuntoCliente.FIRST;
        WHILE (Li_Cont_PuntoCliente IS NOT NULL) LOOP

          --tab_points.EXTEND(1);
          --tab_points(tab_points.COUNT) := Le_PuntoCliente(Li_Cont_PuntoCliente).ID_PUNTO;
          
          puntosFact :=  puntosFact || Le_PuntoCliente(Li_Cont_PuntoCliente).ID_PUNTO ||',';

          Li_Cont_PuntoCliente := Le_PuntoCliente.NEXT(Li_Cont_PuntoCliente);
        END LOOP;


        OPEN Fc_GetDocumentosFinancieros FOR 
            SELECT TBL_TEMP_IDFC.ID_DOCUMENTO, TBL_TEMP_IDFC.OFICINA_ID, TBL_TEMP_IDFC.PUNTO_ID, TBL_TEMP_IDFC.TIPO_DOCUMENTO_ID,
                                            TBL_TEMP_IDFC.NUMERO_FACTURA_SRI, TBL_TEMP_IDFC.SUBTOTAL, TBL_TEMP_IDFC.SUBTOTAL_CERO_IMPUESTO,
                                            TBL_TEMP_IDFC.SUBTOTAL_CON_IMPUESTO, TBL_TEMP_IDFC.SUBTOTAL_DESCUENTO, TBL_TEMP_IDFC.VALOR_TOTAL, 
                                            TBL_TEMP_IDFC.ENTREGO_RETENCION_FTE, TBL_TEMP_IDFC.ESTADO_IMPRESION_FACT, TBL_TEMP_IDFC.ES_AUTOMATICA, 
                                            TBL_TEMP_IDFC.PRORRATEO, TBL_TEMP_IDFC.REACTIVACION, TBL_TEMP_IDFC.RECURRENTE, TBL_TEMP_IDFC.COMISIONA, 
                                            TBL_TEMP_IDFC.FE_CREACION, TBL_TEMP_IDFC.FE_EMISION, TBL_TEMP_IDFC.USR_CREACION, TBL_TEMP_IDFC.NUM_FACT_MIGRACION,
                                            TBL_TEMP_IDFC.OBSERVACION, TBL_TEMP_IDFC.REFERENCIA_DOCUMENTO_ID, TBL_TEMP_IDFC.ES_ELECTRONICA,
                                            TBL_TEMP_IDFC.FE_AUTORIZACION, TBL_TEMP_IDFC.MES_CONSUMO, TBL_TEMP_IDFC.ANIO_CONSUMO, TBL_TEMP_IDFC.RANGO_CONSUMO,
                                            TBL_TEMP_IDFC.DESCUENTO_COMPENSACION,
                                            DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA( TBL_TEMP_IDFC.ID_DOCUMENTO, '', 'saldo' ) SALDO_FACTURA
            FROM (

                                            SELECT IDFC.ID_DOCUMENTO, IDFC.OFICINA_ID, IDFC.PUNTO_ID, IDFC.TIPO_DOCUMENTO_ID, IDFC.NUMERO_FACTURA_SRI, IDFC.SUBTOTAL, 
                                                                       IDFC.SUBTOTAL_CERO_IMPUESTO, IDFC.SUBTOTAL_CON_IMPUESTO, IDFC.SUBTOTAL_DESCUENTO, IDFC.VALOR_TOTAL,
                                                                       IDFC.ENTREGO_RETENCION_FTE, IDFC.ESTADO_IMPRESION_FACT, IDFC.ES_AUTOMATICA, IDFC.PRORRATEO, IDFC.REACTIVACION, 
                                                                       IDFC.RECURRENTE, IDFC.COMISIONA, IDFC.FE_CREACION, IDFC.FE_EMISION, IDFC.USR_CREACION, IDFC.NUM_FACT_MIGRACION, 
                                                                       IDFC.OBSERVACION, IDFC.REFERENCIA_DOCUMENTO_ID, IDFC.ES_ELECTRONICA, IDFC.FE_AUTORIZACION, IDFC.MES_CONSUMO, 
                                                                       IDFC.ANIO_CONSUMO, IDFC.RANGO_CONSUMO, IDFC.DESCUENTO_COMPENSACION
                                            FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC,
                                                                       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                                                                       DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
                                            WHERE IDFC.NUMERO_FACTURA_SRI IS NOT NULL
                                                                       AND IDFC.TIPO_DOCUMENTO_ID  = ATDF.ID_TIPO_DOCUMENTO
                                                                       AND IDFC.OFICINA_ID         = IOG.ID_OFICINA
                                                                       AND IOG.EMPRESA_ID          = Fv_EmpresaCod
                                                                       AND IDFC.PUNTO_ID           IN  (SELECT regexp_substr(puntosFact, '[^,]+', 1, LEVEL) as puntos
                                                                                                          FROM DUAL
                                                                                                    CONNECT BY regexp_substr(puntosFact, '[^,]+', 1, LEVEL) IS NOT NULL)
                                                                       AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
                                                                       AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo', 'Activa', 'Courier')
                                            UNION ALL
                                            SELECT IDFC.ID_DOCUMENTO, IDFC.OFICINA_ID, IDFC.PUNTO_ID, IDFC.TIPO_DOCUMENTO_ID, IDFC.NUMERO_FACTURA_SRI, IDFC.SUBTOTAL, 
                                                                        IDFC.SUBTOTAL_CERO_IMPUESTO, IDFC.SUBTOTAL_CON_IMPUESTO, IDFC.SUBTOTAL_DESCUENTO, IDFC.VALOR_TOTAL, 
                                                                        IDFC.ENTREGO_RETENCION_FTE, IDFC.ESTADO_IMPRESION_FACT, IDFC.ES_AUTOMATICA, IDFC.PRORRATEO, IDFC.REACTIVACION, 
                                                                        IDFC.RECURRENTE, IDFC.COMISIONA, IDFC.FE_CREACION, IDFC.FE_EMISION, IDFC.USR_CREACION, IDFC.NUM_FACT_MIGRACION, 
                                                                        IDFC.OBSERVACION, IDFC.REFERENCIA_DOCUMENTO_ID, IDFC.ES_ELECTRONICA, IDFC.FE_AUTORIZACION, IDFC.MES_CONSUMO, 
                                                                        IDFC.ANIO_CONSUMO, IDFC.RANGO_CONSUMO, IDFC.DESCUENTO_COMPENSACION
                                            FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                                                                       DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
                                                                       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                                                                       DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
                                                                       DB_COMERCIAL.ADMI_CARACTERISTICA AC
                                            WHERE IDFC.NUMERO_FACTURA_SRI  IS NOT NULL
                                                                       AND IDC.DOCUMENTO_ID         = IDFC.ID_DOCUMENTO
                                                                       AND IDFC.TIPO_DOCUMENTO_ID   = ATDF.ID_TIPO_DOCUMENTO
                                                                       AND IDFC.OFICINA_ID          = IOG.ID_OFICINA
                                                                       AND IDC.CARACTERISTICA_ID    = AC.ID_CARACTERISTICA   
                                                                       AND IOG.EMPRESA_ID           = Fv_EmpresaCod
                                                                       AND IDFC.PUNTO_ID            IN (SELECT regexp_substr(puntosFact, '[^,]+', 1, LEVEL) as puntosF
                                                                                                          FROM DUAL
                                                                                                    CONNECT BY regexp_substr(puntosFact, '[^,]+', 1, LEVEL) IS NOT NULL) -- PARAMETRO arrayPuntos
                                                                       AND ATDF.CODIGO_TIPO_DOCUMENTO = 'NDI'
                                                                       AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'
                                                                       AND IDC.VALOR = 'S'
                                                                       AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo', 'Activa', 'Courier')
                                            ) TBL_TEMP_IDFC
            ORDER BY TBL_TEMP_IDFC.FE_CREACION ASC, TBL_TEMP_IDFC.TIPO_DOCUMENTO_ID DESC;
        RETURN Fc_GetDocumentosFinancieros;

    EXCEPTION
    WHEN OTHERS THEN
        BEGIN

           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                            'FNCK_PAGOS_LINEA.F_OBTENER_FACTURAS_ABIERTAS',
                                            'No se encontró registros del cliente. Parametros (Fv_EmpresaCod: '||Fv_EmpresaCod||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        RETURN NULL;
    END;

    END F_OBTENER_FACTURAS_ABIERTAS;

    /**
    * Documentación para F_VALIDAR_PAGO_EXISTENTE
    * Procedimiento que realiza la validacion de si existe un pago
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    *
    * @param Fc_request IN CLOB data
    * @param RETURN BOOLEAN Devuelve respuesta
    */  
    FUNCTION F_VALIDAR_PAGO_EXISTENTE(Fc_request IN CLOB)
    RETURN BOOLEAN
    IS
        Ln_CantidadRegistros      NUMBER := 0;
        Lv_EmpresaCod             VARCHAR2(50);
        Lv_IdFormaPago            VARCHAR2(50);
        Lv_NumeroReferencia       VARCHAR2(50);
        Lv_IdBancoTipoCuenta      VARCHAR2(50);
        Lv_IdBancoCtaContable     VARCHAR2(50);
        Lv_FechaDesde             DATE;
        Lv_FechaHasta             DATE;
        Fc_PagoExistente   SYS_REFCURSOR;

    BEGIN
        APEX_JSON.PARSE(Fc_request);
        Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'strEmpresaCod');
        Lv_IdFormaPago  := APEX_JSON.get_varchar2(p_path => 'intIdFormaPago');
        Lv_NumeroReferencia  := APEX_JSON.get_varchar2(p_path => 'strNumeroReferencia');
        Lv_IdBancoTipoCuenta  := APEX_JSON.get_varchar2(p_path => 'intIdBancoTipoCuenta');
        Lv_IdBancoCtaContable  := APEX_JSON.get_varchar2(p_path => 'intIdBancoCtaContable');
        Lv_FechaDesde  := APEX_JSON.get_varchar2(p_path => 'strFechaDesde');
        Lv_FechaHasta  := APEX_JSON.get_varchar2(p_path => 'strFechaHasta');

        OPEN Fc_PagoExistente FOR 
            SELECT COUNT(*)
            FROM
                DB_FINANCIERO.INFO_PAGO_DET ipd
                JOIN DB_FINANCIERO.INFO_PAGO_CAB ipc ON ipd.PAGO_ID = ipc.ID_PAGO
                JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO atdf ON atdf.ID_TIPO_DOCUMENTO = ipc.TIPO_DOCUMENTO_ID
                LEFT JOIN DB_FINANCIERO.INFO_RECAUDACION ir ON ir.ID_RECAUDACION = ipc.RECAUDACION_ID
                LEFT JOIN DB_FINANCIERO.INFO_PAGO_LINEA ipl ON ipl.ID_PAGO_LINEA = ipc.PAGO_LINEA_ID
            WHERE
                ipc.EMPRESA_ID              = Lv_EmpresaCod
                AND ipd.FORMA_PAGO_ID       = Lv_IdFormaPago
                AND ipd.NUMERO_REFERENCIA   = Lv_NumeroReferencia
                AND (Lv_IdBancoTipoCuenta  IS NULL OR ipd.BANCO_TIPO_CUENTA_ID  = Lv_IdBancoTipoCuenta)
                AND (Lv_IdBancoCtaContable IS NULL OR ipd.BANCO_CTA_CONTABLE_ID = Lv_IdBancoCtaContable)
                AND ipc.FE_CREACION >=  TO_DATE(Lv_FechaDesde, 'yyyy-MM-dd')
                AND ipc.FE_CREACION <   TO_DATE(Lv_FechaHasta, 'yyyy-MM-dd') 
            ORDER BY ipc.FE_CREACION DESC;

        FETCH Fc_PagoExistente INTO Ln_CantidadRegistros;

        IF Fc_PagoExistente%NOTFOUND THEN
            CLOSE Fc_PagoExistente;
            RETURN FALSE;
        END IF;  
        CLOSE Fc_PagoExistente;
        IF Ln_CantidadRegistros > 0 THEN
            RETURN TRUE;
        END IF;
        RETURN FALSE;

    EXCEPTION
    WHEN OTHERS THEN
        IF Fc_PagoExistente%ISOPEN THEN
          CLOSE Fc_PagoExistente;
        END IF;   
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_VALIDAR_PAGO_EXISTENTE',
                                          'No se encontró registros del canal. Parametros (Nombre_canal: '
                                          || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

        RETURN FALSE; 

    END F_VALIDAR_PAGO_EXISTENTE;

    /**
    * Documentación para F_OBTENER_INFORMACION_CLIENTE
    * Procedimiento que realiza la consulta de la informacion del cliente
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    * 
    * @param Fv_persona_id IN VARCHAR2  id persona
    * @param Fv_EmpresaCod IN VARCHAR2 codigo empresa
    * @param Fv_roles_desc IN VARCHAR2 descripcion del rol
    * @param Fv_estados IN VARCHAR2 estados a evaluar
    * @param RETURN SYS_REFCURSOR Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_INFORMACION_CLIENTE(Fv_persona_id IN VARCHAR2, Fv_roles_desc IN VARCHAR2, Fv_empresa_cod IN VARCHAR2, Fv_estados IN VARCHAR2)
    RETURN SYS_REFCURSOR
    IS  
      Lcl_Query VARCHAR2(1000);
      Fc_InfoCliente SYS_REFCURSOR;
    BEGIN
        Lcl_Query  := 'SELECT per.ID_PERSONA_ROL, per.ESTADO, er.ID_EMPRESA_ROL n
                    FROM 
                    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL per,
                    DB_COMERCIAL.INFO_EMPRESA_ROL er,
                    DB_GENERAL.ADMI_ROL rol,
                    DB_GENERAL.ADMI_TIPO_ROL trol
                    WHERE 
                    per.EMPRESA_ROL_ID= er.ID_EMPRESA_ROL AND
                    er.ROL_ID = rol.ID_ROL AND
                    rol.TIPO_ROL_ID = trol.ID_TIPO_ROL AND
                    per.PERSONA_ID = ' || Fv_persona_id || ' AND
                    trol.DESCRIPCION_TIPO_ROL IN (' || Fv_roles_desc || ') AND 
                    er.EMPRESA_COD= ' || Fv_empresa_cod || ' AND 
                    per.estado IN (' || Fv_estados || ') ORDER BY per.estado ASC';

        OPEN Fc_InfoCliente FOR Lcl_Query;
        RETURN Fc_InfoCliente;
    EXCEPTION
    WHEN OTHERS THEN
        BEGIN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                        'FNCK_PAGOS_LINEA.F_OBTENER_INFORMACION_CLIENTE',
                                        'No se encontró registros del cliente. Parametros (Fv_EmpresaCod: '|| SQLCODE || ' -ERROR- ' || SQLERRM,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
            RETURN NULL;
        END;

    END F_OBTENER_INFORMACION_CLIENTE;

    /**
    * Documentación para F_OBTENER_RECAUDACION_CARACT
    * Procedimiento que realiza la consulta de la caracteristica de la recaudacion
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    * 
    * @param Fv_EmpresaCod IN VARCHAR2 codigo empresa
    * @param Fv_CanalRecaudacionId IN NUMBER id canal recaudacion
    * @param Fv_DescripcionCaracteristica IN VARCHAR2 descripcion caracteristica
    * @param Fv_estado IN VARCHAR2 estados 
    * @param RETURN SYS_REFCURSOR Devuelve respuesta con data
    */ 
    FUNCTION F_OBTENER_RECAUDACION_CARACT(Fv_EmpresaCod IN VARCHAR2, Fv_CanalRecaudacionId IN NUMBER, Fv_DescripcionCaracteristica IN VARCHAR2, Fv_Estado IN VARCHAR2)
    RETURN SYS_REFCURSOR
    IS
        Fc_Caracteristica SYS_REFCURSOR;

    BEGIN
        OPEN Fc_Caracteristica FOR
          SELECT acrc.VALOR
           FROM   DB_COMERCIAL.ADMI_CARACTERISTICA ac
           JOIN   DB_FINANCIERO.ADMI_CANAL_RECAUDACION_CARACT acrc ON ac.ID_CARACTERISTICA = acrc.CARACTERISTICA_ID
           WHERE  ac.estado                     = Fv_Estado AND
                  ac.descripcion_caracteristica = Fv_DescripcionCaracteristica AND 
                  acrc.canal_recaudacion_id     = Fv_CanalRecaudacionId  AND 
                  acrc.empresa_cod              = Fv_EmpresaCod;

        RETURN Fc_Caracteristica;

    EXCEPTION
    WHEN OTHERS THEN
        BEGIN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                        'FNCK_PAGOS_LINEA.F_OBTENER_CANAL_RECAUDACION_CARACTERISTICA',
                                        'No se encontró registros del cliente. Parametros (Fv_EmpresaCod: '|| SQLCODE || ' -ERROR- ' || SQLERRM,
                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
            RETURN NULL;
        END;                                             
    END F_OBTENER_RECAUDACION_CARACT;

    /**
    * Documentación para F_GENERAR_PAGO_ANTICIPO
    * Procedimiento que realiza el pago de anticipo
    * 
    * @author Erick Melgar <emelgar@telconet.ec>
    * @version 1.0 14/07/2022
    * 
    * @param Fc_request IN CLOB data
    * @param RETURN CLOB Devuelve respuesta con data
    */ 
    FUNCTION F_GENERAR_PAGO_ANTICIPO(Fc_request IN CLOB)
    RETURN CLOB
    IS

      CURSOR C_Tipo_Documento(Rv_TipoDocumento VARCHAR2) IS
        SELECT ID_TIPO_DOCUMENTO 
        FROM Admi_Tipo_Documento_Financiero
        WHERE CODIGO_TIPO_DOCUMENTO = Rv_TipoDocumento;

      CURSOR C_Parametro_Comentario(Rv_OrigenPago VARCHAR2) IS
        SELECT det.VALOR2, det.VALOR3
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB cab, DB_GENERAL.ADMI_PARAMETRO_DET det
        WHERE cab.ID_PARAMETRO = det.PARAMETRO_ID
        AND cab.NOMBRE_PARAMETRO = 'BUSPAGOS' 
        AND cab.ESTADO = 'Activo'
        AND det.ESTADO = 'Activo'
        AND det.VALOR1 = Rv_OrigenPago;


      CURSOR C_Numero_Pago(Rv_EmpresaCod VARCHAR2,
                           Rn_OficinaId  NUMBER,
                           Rv_CodigoNumeracionPago VARCHAR2) IS
        SELECT SECUENCIA, NUMERACION_UNO, NUMERACION_DOS 
        FROM  DB_COMERCIAL.ADMI_NUMERACION
        WHERE EMPRESA_ID = Rv_EmpresaCod
        AND   OFICINA_ID = Rn_OficinaId
        AND   CODIGO     = Rv_CodigoNumeracionPago;

      Le_DocFinanciero            T_DocumentosFiancieros;
      Li_Cont_DocFinanciero       PLS_INTEGER;
      Li_Limit                    CONSTANT PLS_INTEGER DEFAULT 50;
      Le_InfoCliente              T_InfoCliente;
      Li_Cont_InfoCliente         PLS_INTEGER;

      Lv_FormaPago VARCHAR2(50);
      Lv_EmpresaCod VARCHAR2(50);
      Lv_NumeroReferencia VARCHAR2(50);
      Lv_OrigenPago VARCHAR2(50);
      Lv_PersonaId VARCHAR2(50);
      Lv_IdFormaPago VARCHAR2(50);
      Lv_TipoTransaccion VARCHAR2(50);
      Lv_CodigoNumeracionPago VARCHAR2(50);
      Lv_CodigoNumeracionAnticipo VARCHAR2(50); 
      Lv_Comentario         VARCHAR2(100); 
      Lv_ComentarioAnticipo VARCHAR2(100); 
      Lv_Respuesta            VARCHAR2(20);
      Lv_Retorno            VARCHAR2(1000);
      Lv_Error              VARCHAR2(500);
      Lv_Mensaje              VARCHAR2(500);
      Lv_Estado VARCHAR2(50);
      Ln_IdPersonaRol NUMBER;
      Ln_IdEmpresaRol NUMBER;
      Ln_OficinaId NUMBER;
      Ln_ValorPago NUMBER;
      Ln_ValorPagado NUMBER;
      Ln_SaldoFactura NUMBER;
      Ln_CanalRecaudacionId NUMBER;
      Ln_IdBancoCtaContable NUMBER;
      Ln_IdBancoTipoCuenta NUMBER;
      Fc_CanalPago SYS_REFCURSOR;
      Fc_InfoCliente SYS_REFCURSOR;
      Fc_RecaudacionCaract SYS_REFCURSOR;
      Fc_FacturasAbiertas SYS_REFCURSOR;
      Le_Errors              EXCEPTION; 
      Lc_ValidaPagoExisteRequest CLOB;
      Lr_InfoPagoCab  INFO_PAGO_CAB%ROWTYPE;
      Lr_InfoPagoDet  INFO_PAGO_DET%ROWTYPE;
      Lr_InfoPagoCabAnticipo  INFO_PAGO_CAB%ROWTYPE;
      Lr_InfoPagoDetAnticipo  INFO_PAGO_DET%ROWTYPE;
      Lv_Caracteristica DB_FINANCIERO.ADMI_CANAL_RECAUDACION_CARACT.VALOR%TYPE;
      Lr_InfoPagoHist  INFO_PAGO_HISTORIAL%ROWTYPE;
      Lr_InfoPagoHistAnticipo  INFO_PAGO_HISTORIAL%ROWTYPE;
      Lr_InfoDocumentoHistorial  INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
      Lv_EstadoPago VARCHAR2(50);
      Lv_TipoDoc VARCHAR2(50);
      Lv_UsrCreacion VARCHAR2(20);
      Ln_EntityRecacudacion NUMBER;
      Ln_EntityRecDet NUMBER;
      Ln_EntityPagoLinea NUMBER;
      Ln_BanderaPago NUMBER := 0;
      Ln_ValorCabeceraPago NUMBER := 0;
      Ln_CabPagoId NUMBER := 0;
      Ln_CabPagoAnticipoId NUMBER := 0;
      Ln_InfoPagoHistId NUMBER := 0;
      Ln_InfoPagoHistAnticId NUMBER := 0;
      Ln_InfoDocHistId NUMBER := 0;
      Lv_NumeroPago VARCHAR2(1000);
      Lv_NumeroPagoAnticipo VARCHAR2(1000);
      Ln_SecuenciaAsig NUMBER;
      Lv_NumeracionUno VARCHAR2(3); 
      Lv_NumeracionDos VARCHAR2(3);
      Ln_SecuenciaAsigAnt NUMBER;
      Lv_NumeracionUnoAnt VARCHAR2(3); 
      Lv_NumeracionDosAnt VARCHAR2(3);
      Lv_TipoDocumentoAnticipo VARCHAR2(5);
      Lv_ComentarioPagoLinea VARCHAR2(1000);
      Lv_StrTrama VARCHAR2(100);
      Ln_PuntoId NUMBER;
      Ln_CantidadClientes NUMBER;
      Lv_FechaProceso VARCHAR2(100);
      Lv_IdBancoCtaContable VARCHAR2(100);
      Lv_FechaDesde VARCHAR2(100);
      Lv_FechaHasta VARCHAR2(100);
      Ln_Tipo_Documento_Id NUMBER;

    BEGIN
      APEX_JSON.PARSE(Fc_request);
        Lv_FormaPago  := APEX_JSON.get_varchar2(p_path => 'codigoFormaPago');
        Ln_OficinaId  := APEX_JSON.get_number(p_path => 'oficinaId');
        Ln_IdBancoCtaContable  := APEX_JSON.get_number(p_path => 'bancoCtaContableId');
        Ln_ValorPagado  := APEX_JSON.get_number(p_path => 'valorPagado');
        Ln_IdBancoTipoCuenta  := APEX_JSON.get_number(p_path => 'bancoTipoCuentaId');
        Lv_NumeroReferencia  := APEX_JSON.get_varchar2(p_path => 'numeroReferencia');
        Lv_OrigenPago  := APEX_JSON.get_varchar2(p_path => 'origenPago');
        Lv_IdFormaPago  := APEX_JSON.get_varchar2(p_path => 'formaPagoId');
        Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'empresaCod');
        Ln_CanalRecaudacionId  := APEX_JSON.get_number(p_path => 'canalRecaudacionId');
        Lv_PersonaId  := APEX_JSON.get_varchar2(p_path => 'personaId');
        Lv_UsrCreacion := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
        Ln_EntityPagoLinea := APEX_JSON.get_number(p_path => 'pagoLineaId');
        Lv_ComentarioPagoLinea := APEX_JSON.get_varchar2(p_path => 'comentarioPagoLinea');
        Lv_FechaProceso := APEX_JSON.get_varchar2(p_path => 'fechaProceso');

       Lv_Caracteristica := '0';

      IF Lv_FormaPago='REC' THEN 
        Lv_TipoTransaccion := 'Recaudacion';
        Lv_CodigoNumeracionPago := 'PREC';
        Lv_CodigoNumeracionAnticipo := 'AREC';
      ELSIF  Lv_FormaPago='PAL' THEN 
        Lv_TipoTransaccion := 'Pago en línea';
        Lv_CodigoNumeracionPago := 'PPAL';
        Lv_CodigoNumeracionAnticipo := 'APAL';
      ELSE
        Lv_Error := 'No se puede generar pagos o anticipos de la forma de pago ' || Lv_FormaPago;
        Lv_Retorno := '005';
        RAISE Le_Errors;
      END IF;

      Fc_RecaudacionCaract := F_OBTENER_RECAUDACION_CARACT(Lv_EmpresaCod, Ln_CanalRecaudacionId, 'NUMERO DIAS RECAUDACION EXISTENTE', 'Activo');
      FETCH Fc_RecaudacionCaract INTO Lv_Caracteristica;
      CLOSE Fc_RecaudacionCaract;

      Lc_ValidaPagoExisteRequest := '{' ||
                                '"strEmpresaCod":"' || Lv_EmpresaCod || '",' ||
                                '"intIdFormaPago":"' || Lv_IdFormaPago || '",' ||
                                '"numeroReferencia":"' || Lv_NumeroReferencia || '",' ||
                                '"intIdBancoCtaContable":"' || Ln_IdBancoCtaContable || '",' ||
                                '"intIdBancoTipoCuenta":"' || Ln_IdBancoTipoCuenta || '",' ||
                                '"strFechaDesde":"' || TO_CHAR(SYSDATE-NVL(Lv_Caracteristica, 0),'yyyy-MM-dd') || '",' ||
                                '"strFechaHasta":"' || TO_CHAR(SYSDATE,'yyyy-MM-dd') || '"'
                            || '}';


      IF  F_VALIDAR_PAGO_EXISTENTE(Lc_ValidaPagoExisteRequest) THEN 
        Lv_Error := 'Ya se encuentra un pago realizado';
        Lv_Retorno := '007';
        RAISE Le_Errors;
      END IF;

      Lv_Respuesta := '';

      IF Lv_PersonaId IS NOT NULL THEN
          Fc_InfoCliente := F_OBTENER_INFORMACION_CLIENTE(Lv_PersonaId, '''Cliente'',''Pre-cliente''', Lv_EmpresaCod, 
                          ('''Activo'',''Activa'',''Cancelado'',''Cancelada'',''PendAprobSolctd'',''Pend-convertir'''));

            FETCH Fc_InfoCliente BULK COLLECT INTO Le_InfoCliente LIMIT Li_Limit;

            Li_Cont_InfoCliente := Le_InfoCliente.FIRST;

            WHILE (Li_Cont_InfoCliente IS NOT NULL) LOOP
              Ln_IdPersonaRol := Le_InfoCliente(Li_Cont_InfoCliente).ID_PERSONA_ROL;
              Fc_FacturasAbiertas := FNCK_PAGOS_LINEA.F_OBTENER_FACTURAS_ABIERTAS(Lv_PersonaId, Lv_EmpresaCod);

                  FETCH Fc_FacturasAbiertas BULK COLLECT INTO Le_DocFinanciero LIMIT Li_Limit;

                  Li_Cont_DocFinanciero := Le_DocFinanciero.FIRST;

                  WHILE (Li_Cont_DocFinanciero IS NOT NULL) LOOP

                    Ln_SaldoFactura := Le_DocFinanciero(Li_Cont_DocFinanciero).SALDO_FACTURA;

                    IF Ln_ValorPagado > 0 AND Ln_SaldoFactura > 0 THEN

                        Ln_ValorCabeceraPago := 0;
                        Lv_TipoDoc := 'PAG';
                        Lv_EstadoPago := 'Cerrado';

                        -- OBTENER EL TIPO_DOCUMENTO_ID
                        OPEN C_Tipo_Documento(Lv_TipoDoc);
                        FETCH C_Tipo_Documento INTO Ln_Tipo_Documento_Id;
                        IF C_Tipo_Documento%NOTFOUND THEN
                            CLOSE C_Tipo_Documento;
                            Lv_Error := 'No se pudo obtener el tipo de documento';
                            Lv_Retorno := '005';
                            RAISE Le_Errors;
                        END IF;
                        CLOSE C_Tipo_Documento;

                        Ln_PuntoId := Le_DocFinanciero(Li_Cont_DocFinanciero).PUNTO_ID;

                        IF Lv_FormaPago = 'REC' THEN 
                          Lv_Comentario := Lv_TipoTransaccion || ' de ' || Lv_OrigenPago || ', referencia: ' || Lv_NumeroReferencia; 
                        ELSIF Lv_FormaPago = 'PAL' THEN 
                          Lv_StrTrama := SUBSTR(Lv_ComentarioPagoLinea, INSTR(Lv_ComentarioPagoLinea, 'Terminal') + LENGTH('Terminal') + 1);
                          Lv_StrTrama := SUBSTR(Lv_StrTrama, 0, INSTR(Lv_StrTrama, ' - '));

                          OPEN C_Parametro_Comentario(Lv_OrigenPago);
                          FETCH C_Parametro_Comentario INTO Lv_Comentario, Lv_UsrCreacion;

                          IF Lv_Comentario IS NULL THEN
                              Lv_Comentario := '{{tipoTransaccion}} de {{origenPago}}, referencia: {{numeroReferencia}}';
                          END IF;

                          CLOSE C_Parametro_Comentario;

                          Lv_Comentario := REPLACE(Lv_Comentario, '{{tipoTransaccion}}', Lv_TipoTransaccion);
                          Lv_Comentario := REPLACE(Lv_Comentario, '{{origenPago}}', Lv_OrigenPago);
                          Lv_Comentario := REPLACE(Lv_Comentario, '{{numeroReferencia}}', Lv_NumeroReferencia);
                          Lv_Comentario := REPLACE(Lv_Comentario, '{{tipoTc}}', Lv_StrTrama);
                          --dbms_output.put_line('Req ANTICIPO'||Lv_Comentario);

                        END IF;

                        --Obtener la numeracion de la tabla Admi_numeracion
                        Lv_NumeroPago := '';
                        OPEN C_Numero_Pago(Lv_EmpresaCod, Ln_OficinaId, Lv_CodigoNumeracionPago);
                        FETCH C_Numero_Pago INTO Ln_SecuenciaAsig, Lv_NumeracionUno, Lv_NumeracionDos;

                        IF C_Numero_Pago%NOTFOUND THEN
                            CLOSE C_Numero_Pago;
                            Lv_Error := 'No se pudo generar el numero de pago';
                            Lv_Retorno := '005';
                            RAISE Le_Errors;
                        END IF;

                        CLOSE C_Numero_Pago; 

                        Lv_NumeroPago := Lv_NumeracionUno || '-' || Lv_NumeracionDos || '-' || TRIM(TO_CHAR(Ln_SecuenciaAsig, '0000009'));

                        -- Actualizo la numeracion en la tabla
                        UPDATE DB_COMERCIAL.ADMI_NUMERACION
                        SET SECUENCIA = Ln_SecuenciaAsig + 1
                        WHERE EMPRESA_ID = Lv_EmpresaCod
                        AND   OFICINA_ID = Ln_OficinaId
                        AND   CODIGO     = Lv_CodigoNumeracionPago;
                        COMMIT;

                        --INGRESO DE LA CABECERA
                        Ln_CabPagoId := DB_FINANCIERO.SEQ_INFO_PAGO_CAB.NEXTVAL;

                        Lr_InfoPagoCab.ID_PAGO := Ln_CabPagoId;
                        Lr_InfoPagoCab.PUNTO_ID := Le_DocFinanciero(Li_Cont_DocFinanciero).PUNTO_ID;
                        Lr_InfoPagoCab.OFICINA_ID := Ln_OficinaId;
                        Lr_InfoPagoCab.EMPRESA_ID := Lv_EmpresaCod;
                        Lr_InfoPagoCab.NUMERO_PAGO := Lv_NumeroPago;
                        Lr_InfoPagoCab.VALOR_TOTAL := Ln_ValorPagado;
                        Lr_InfoPagoCab.ESTADO_PAGO := Lv_EstadoPago;
                        Lr_InfoPagoCab.COMENTARIO_PAGO := Lv_Comentario;
                        Lr_InfoPagoCab.FE_CREACION := SYSDATE;
                        Lr_InfoPagoCab.USR_CREACION := Lv_UsrCreacion;
                        Lr_InfoPagoCab.TIPO_DOCUMENTO_ID := Ln_Tipo_Documento_Id;--Le_DocFinanciero(Li_Cont_DocFinanciero).TIPO_DOCUMENTO_ID;
                        Lr_InfoPagoCab.RECAUDACION_ID := Ln_EntityRecacudacion;
                        Lr_InfoPagoCab.RECAUDACION_DET_ID := Ln_EntityRecDet;
                        Lr_InfoPagoCab.PAGO_LINEA_ID := Ln_EntityPagoLinea;

                        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_PAGO_CAB(Lr_InfoPagoCab, Lv_Mensaje);

                        IF Lv_Mensaje IS NOT NULL THEN
                            Lv_Error := 'Error al insertar - INFO_PAGO_CAB: ' || Lv_Mensaje;
                            Lv_Retorno := '005';
                            RAISE Le_Errors;
                        END IF;

                        Ln_BanderaPago := 0;
                        -- SE VERIFICA SI EL PAGO YA CUBRE LA FACTURA
                        IF Ln_ValorPagado =  Ln_SaldoFactura THEN
                            --ACTUALIZACION DEL ESTADO DE LA FACTURA (agregar)
                            Ln_ValorPago := Ln_ValorPagado;
                            Ln_ValorPagado := Ln_ValorPagado - Ln_SaldoFactura;
                            Ln_BanderaPago := 1;
                        ELSIF Ln_SaldoFactura < Ln_ValorPagado THEN
                            --ACTUALIZACION DEL ESTADO DE LA FACTURA (agregar)
                            Ln_ValorPago := Ln_SaldoFactura;
                            Ln_ValorPagado := Ln_ValorPagado - Ln_SaldoFactura;
                            Ln_BanderaPago := 2;
                        ELSE
                            Ln_ValorPago := Ln_ValorPagado;
                            Ln_ValorPagado := 0;
                            Ln_BanderaPago := 3;
                        END IF;

                        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                                    'FNCK_PAGOS_LINEA.F_GENERAR_PAGO_ANTICIPO',
                                                    'Se ingresa Historial por cierre de Documento ID_DOCUMENTO= '|| Le_DocFinanciero(Li_Cont_DocFinanciero).ID_DOCUMENTO || ' - ESTADO_IMPRESION_FACT= ' || Le_DocFinanciero(Li_Cont_DocFinanciero).ESTADO_IMPRESION_FACT
                                                    || ' - SALDO_FACTURA= ' || Ln_SaldoFactura || ' - VALOR_PAGO= ' || Ln_ValorPago || ' - SALDO_VALOR_PAGADO= ' || Ln_ValorPagado
                                                    || ' - BANDERA= ' || Ln_BanderaPago ,
                                                    NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

                        -- INSERTAR EN InfoDocumentoHistorial
                        Ln_InfoDocHistId := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
                        Lr_InfoDocumentoHistorial.ID_DOCUMENTO_HISTORIAL := Ln_InfoDocHistId;
                        Lr_InfoDocumentoHistorial.DOCUMENTO_ID := Le_DocFinanciero(Li_Cont_DocFinanciero).ID_DOCUMENTO;
                        Lr_InfoDocumentoHistorial.MOTIVO_ID := NULL;
                        Lr_InfoDocumentoHistorial.FE_CREACION := SYSDATE;
                        Lr_InfoDocumentoHistorial.USR_CREACION := Lv_UsrCreacion;
                        Lr_InfoDocumentoHistorial.ESTADO := Le_DocFinanciero(Li_Cont_DocFinanciero).ESTADO_IMPRESION_FACT;
                        Lr_InfoDocumentoHistorial.OBSERVACION := NULL;

                        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoHistorial, Lv_Mensaje);

                        IF Lv_Mensaje IS NOT NULL THEN
                            Lv_Error := 'Error al insertar - INFO_DOC_FINANCIERO_HST: ' || Lv_Mensaje;
                            Lv_Retorno := '005';
                            RAISE Le_Errors;
                        END IF;

                        -- CREAR DETALLES DEL PAGO
                        Ln_ValorCabeceraPago := Ln_ValorCabeceraPago + Ln_ValorPago;
                        Lr_InfoPagoDet.PAGO_ID := Ln_CabPagoId;
                        Lr_InfoPagoDet.ID_PAGO_DET := DB_FINANCIERO.SEQ_INFO_PAGO_DET.NEXTVAL;
                        Lr_InfoPagoDet.DEPOSITADO := 'N';
                        Lr_InfoPagoDet.FE_DEPOSITO := Lv_FechaProceso;
                        Lr_InfoPagoDet.FE_CREACION := SYSDATE;
                        Lr_InfoPagoDet.USR_CREACION := Lv_UsrCreacion;
                        Lr_InfoPagoDet.FORMA_PAGO_ID := Lv_IdFormaPago;
                        Lr_InfoPagoDet.VALOR_PAGO := Ln_ValorPago;
                        Lr_InfoPagoDet.BANCO_TIPO_CUENTA_ID := Ln_IdBancoTipoCuenta;
                        Lr_InfoPagoDet.BANCO_CTA_CONTABLE_ID := Ln_IdBancoCtaContable;
                        Lr_InfoPagoDet.CUENTA_CONTABLE_ID := Ln_IdBancoCtaContable;
                        Lr_InfoPagoDet.NUMERO_REFERENCIA := Lv_NumeroReferencia;
                        Lr_InfoPagoDet.COMENTARIO := Lv_Comentario;
                        Lr_InfoPagoDet.ESTADO := Lv_EstadoPago;
                        Lr_InfoPagoDet.REFERENCIA_ID := Le_DocFinanciero(Li_Cont_DocFinanciero).ID_DOCUMENTO;

                        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_PAGO_DET(Lr_InfoPagoDet, Lv_Mensaje);

                        IF Lv_Mensaje IS NOT NULL THEN
                            Lv_Error := 'Error al insertar - INFO_PAGO_DET: ' || Lv_Mensaje;
                            Lv_Retorno := '005';
                            RAISE Le_Errors;
                        END IF;

                        -- ACTUALIZACION VALOR TOTAL DE CABECERA
                        UPDATE DB_FINANCIERO.INFO_PAGO_CAB
                        SET VALOR_TOTAL  = Ln_ValorCabeceraPago
                        WHERE ID_PAGO    = Ln_CabPagoId
                        AND   EMPRESA_ID = Lv_EmpresaCod;
                        COMMIT;

                        Lv_Respuesta := Lv_EstadoPago;

                        -- INGRESA HISTORIAL PARA EL ANTICIPO
                        Ln_InfoPagoHistId := DB_FINANCIERO.SEQ_INFO_PAGO_HISTORIAL.NEXTVAL;                      
                        Lr_InfoPagoHist.ID_PAGO_HISTORIAL := Ln_InfoPagoHistId;
                        Lr_InfoPagoHist.PAGO_ID := Ln_CabPagoId;
                        Lr_InfoPagoHist.MOTIVO_ID := NULL;
                        Lr_InfoPagoHist.FE_CREACION := SYSDATE;
                        Lr_InfoPagoHist.USR_CREACION := Lv_UsrCreacion;
                        Lr_InfoPagoHist.ESTADO := Lv_EstadoPago;
                        Lr_InfoPagoHist.OBSERVACION := Lv_Comentario;

                        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_PAGO_HIST(Lr_InfoPagoHist, Lv_Mensaje);

                        IF Lv_Mensaje IS NOT NULL THEN
                            Lv_Error := 'Error al insertar - INFO_PAGO_HIST: ' || Lv_Mensaje;
                            Lv_Retorno := '005';
                            RAISE Le_Errors;
                        END IF;

                    END IF;

                    Li_Cont_DocFinanciero := Le_DocFinanciero.NEXT(Li_Cont_DocFinanciero);
                  END LOOP;

              CLOSE Fc_FacturasAbiertas;

              Li_Cont_InfoCliente := Le_InfoCliente.NEXT(Li_Cont_InfoCliente);
            END LOOP;

        CLOSE Fc_InfoCliente;
      END IF;

      -- CREA ANTICIPO SI ES NECESARIO y SI ENCONTRO EL CLIENTE
    IF Ln_ValorPagado > 0 THEN

        --Obtener la numeracion de la tabla Admi_numeracion
        Lv_NumeroPago := '';
        OPEN C_Numero_Pago(Lv_EmpresaCod, Ln_OficinaId, Lv_CodigoNumeracionAnticipo);
        FETCH C_Numero_Pago INTO Ln_SecuenciaAsigAnt, Lv_NumeracionUnoAnt, Lv_NumeracionDosAnt;

        IF C_Numero_Pago%NOTFOUND THEN
            CLOSE C_Numero_Pago;
            Lv_Error := 'No se pudo obtener el numero de pago';
            Lv_Retorno := '005';
            RAISE Le_Errors;
        END IF;

        CLOSE C_Numero_Pago;

        Lv_NumeroPagoAnticipo := Lv_NumeracionUnoAnt || '-' || Lv_NumeracionDosAnt || '-' || TRIM(TO_CHAR(Ln_SecuenciaAsigAnt, '0000009'));

        -- Actualizo la numeracion en la tabla
        UPDATE DB_COMERCIAL.ADMI_NUMERACION
        SET SECUENCIA = Ln_SecuenciaAsig + 1
        WHERE EMPRESA_ID = Lv_EmpresaCod
        AND   OFICINA_ID = Ln_OficinaId
        AND   CODIGO     = Lv_CodigoNumeracionAnticipo;
        COMMIT;

        Lv_TipoDocumentoAnticipo := 'ANTS';
        -- VALIDACION SI HAY PUNTO
        IF Ln_PuntoId IS NOT NULL THEN
          Lv_TipoDocumentoAnticipo := 'ANT';
        END IF;

        Lv_ComentarioAnticipo := 'Anticipo ' || Lv_TipoDocumentoAnticipo || ' generado por ' || Lv_TipoTransaccion || ' de ' || Lv_OrigenPago || ', referencia ' || Lv_NumeroReferencia;
        Ln_CabPagoAnticipoId := Ln_CabPagoAnticipoId + 1;

        -- OBTENER EL TIPO_DOCUMENTO_ID
        OPEN C_Tipo_Documento(Lv_TipoDocumentoAnticipo);
        FETCH C_Tipo_Documento INTO Ln_Tipo_Documento_Id;
        IF C_Tipo_Documento%NOTFOUND THEN
            CLOSE C_Tipo_Documento;
            Lv_Error := 'No se pudo obtener el tipo de documento';
            Lv_Retorno := '005';
            RAISE Le_Errors;
        END IF;
        CLOSE C_Tipo_Documento;

        --INGRESO DE LA CABECERA ANTICIPO
        Ln_CabPagoAnticipoId := DB_FINANCIERO.SEQ_INFO_PAGO_CAB.NEXTVAL;
        Lr_InfoPagoCabAnticipo.ID_PAGO := Ln_CabPagoAnticipoId;--
        Lr_InfoPagoCabAnticipo.PUNTO_ID := Ln_PuntoId;
        Lr_InfoPagoCabAnticipo.OFICINA_ID := Ln_OficinaId;--
        Lr_InfoPagoCabAnticipo.EMPRESA_ID := Lv_EmpresaCod;--
        Lr_InfoPagoCabAnticipo.NUMERO_PAGO := Lv_NumeroPagoAnticipo; --
        Lr_InfoPagoCabAnticipo.VALOR_TOTAL := Ln_ValorPagado;--
        Lr_InfoPagoCabAnticipo.ESTADO_PAGO := 'Pendiente'; --
        Lr_InfoPagoCabAnticipo.COMENTARIO_PAGO := Lv_ComentarioAnticipo; --
        Lr_InfoPagoCabAnticipo.FE_CREACION := SYSDATE; --
        Lr_InfoPagoCabAnticipo.USR_CREACION := Lv_UsrCreacion;--
        Lr_InfoPagoCabAnticipo.TIPO_DOCUMENTO_ID := Ln_Tipo_Documento_Id;
        Lr_InfoPagoCabAnticipo.RECAUDACION_ID := Ln_EntityRecacudacion;--
        Lr_InfoPagoCabAnticipo.RECAUDACION_DET_ID := Ln_EntityRecDet;--
        Lr_InfoPagoCabAnticipo.PAGO_LINEA_ID := Ln_EntityPagoLinea;--

        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_PAGO_CAB(Lr_InfoPagoCabAnticipo, Lv_Mensaje);

        IF Lv_Mensaje IS NOT NULL THEN
            Lv_Error := 'Error al insertar - INFO_PAGO_CAB Anticipo: ' || Lv_Mensaje;
            Lv_Retorno := '005';
            RAISE Le_Errors;
        END IF;

        -- CREAR DETALLES DEL ANTICIPO
        Lr_InfoPagoDetAnticipo.PAGO_ID := Ln_CabPagoAnticipoId;--
        Lr_InfoPagoDetAnticipo.ID_PAGO_DET := DB_FINANCIERO.SEQ_INFO_PAGO_DET.NEXTVAL;
        Lr_InfoPagoDetAnticipo.DEPOSITADO := 'N';--
        Lr_InfoPagoDetAnticipo.FE_DEPOSITO := Lv_FechaProceso;--
        Lr_InfoPagoDetAnticipo.FE_CREACION := SYSDATE;--
        Lr_InfoPagoDetAnticipo.USR_CREACION := Lv_UsrCreacion;--
        Lr_InfoPagoDetAnticipo.FORMA_PAGO_ID := Lv_IdFormaPago;--
        Lr_InfoPagoDetAnticipo.VALOR_PAGO := Ln_ValorPagado;--
        Lr_InfoPagoDetAnticipo.BANCO_TIPO_CUENTA_ID := Ln_IdBancoTipoCuenta;--
        Lr_InfoPagoDetAnticipo.BANCO_CTA_CONTABLE_ID := Ln_IdBancoCtaContable;---
        Lr_InfoPagoDetAnticipo.CUENTA_CONTABLE_ID := Ln_IdBancoCtaContable;--
        Lr_InfoPagoDetAnticipo.NUMERO_REFERENCIA := Lv_NumeroReferencia;--
        Lr_InfoPagoDetAnticipo.COMENTARIO := Lv_ComentarioAnticipo;--
        Lr_InfoPagoDetAnticipo.ESTADO := 'Pendiente';--

        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_PAGO_DET(Lr_InfoPagoDetAnticipo, Lv_Mensaje);

        IF Lv_Mensaje IS NOT NULL THEN
            Lv_Error := 'Error al insertar - INFO_PAGO_DET Anticipo: ' || Lv_Mensaje;
            Lv_Retorno := '005';
            RAISE Le_Errors;
        END IF;

        COMMIT;

        Lv_Respuesta := Lv_TipoDocumentoAnticipo;

        -- INGRESA HISTORIAL PARA EL ANTICIPO
        Ln_InfoPagoHistAnticId := DB_FINANCIERO.SEQ_INFO_PAGO_HISTORIAL.NEXTVAL;
        Lr_InfoPagoHistAnticipo.ID_PAGO_HISTORIAL := Ln_InfoPagoHistAnticId;--
        Lr_InfoPagoHistAnticipo.PAGO_ID := Ln_CabPagoAnticipoId;
        Lr_InfoPagoHistAnticipo.MOTIVO_ID := NULL;
        Lr_InfoPagoHistAnticipo.FE_CREACION := SYSDATE;
        Lr_InfoPagoHistAnticipo.USR_CREACION := Lv_UsrCreacion;
        Lr_InfoPagoHistAnticipo.ESTADO := 'Pendiente';
        Lr_InfoPagoHistAnticipo.OBSERVACION := Lv_ComentarioAnticipo;

        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_PAGO_HIST(Lr_InfoPagoHistAnticipo, Lv_Mensaje);

        IF Lv_Mensaje IS NOT NULL THEN
            Lv_Error := 'Error al insertar - INFO_PAGO_HIST Anticipo: ' || Lv_Mensaje;
            Lv_Retorno := '005';
            RAISE Le_Errors;
        END IF;

      END IF;

      -- Si es un pago o anticipo de algun cliente se marca como asignado el detalle de retencion
      IF Ln_EntityRecDet IS NOT NULL AND (Lv_Respuesta = 'PAG' OR Lv_Respuesta = 'ANT') THEN
        UPDATE INFO_RECAUDACION_DET
        SET ES_CLIENTE = 'S',
            ASIGNADO   = 'S',
            PERSONA_EMPRESA_ROL_ID = Ln_IdPersonaRol
        WHERE ID_RECAUDACION_DET = Ln_EntityRecDet;

        COMMIT;
      END IF;

      Lv_Error := ' Transaccion exitosa';
      Lv_Retorno := '000';

      RETURN '{' ||
                     '"respuesta":"' || Lv_Respuesta || '",' ||
                      '"retorno":"' || Lv_Retorno || '",' ||
                      '"error":"' || Lv_Error || '"'
                  || '}';                                                                                                                                                                            
    EXCEPTION
      WHEN Le_Errors THEN
        BEGIN

           DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                            'FNCK_PAGOS_LINEA.F_GENERAR_PAGO_ANTICIPO',
                                            'Se presento un error en el pago anticipado. Parametros (Fv_EmpresaCod: '|| SQLCODE || ' -ERROR- ' || SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                RETURN '{' ||
                                '"retorno":"' || Lv_Retorno || '",' ||
                                '"error":"' || Lv_Error || '"'
                            || '}';
        END;
      WHEN OTHERS THEN
        BEGIN

          IF C_Numero_Pago%ISOPEN THEN
            CLOSE C_Numero_Pago;
          END IF;

          IF C_Parametro_Comentario%ISOPEN THEN
            CLOSE C_Parametro_Comentario;
          END IF;

          IF Fc_InfoCliente%ISOPEN THEN
            CLOSE Fc_InfoCliente;
          END IF;

          IF Fc_RecaudacionCaract%ISOPEN THEN
            CLOSE Fc_RecaudacionCaract;
          END IF;

          IF Fc_FacturasAbiertas%ISOPEN THEN
            CLOSE Fc_FacturasAbiertas;
          END IF;

          IF C_Tipo_Documento%ISOPEN THEN
            CLOSE C_Tipo_Documento;
          END IF;

          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                            'FNCK_PAGOS_LINEA.F_GENERAR_PAGO_ANTICIPO',
                                            'INFO: '|| SQLCODE || ' -ERROR- ' || SQLERRM,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
          Lv_Error := 'BUSPAGOS '||' FNCK_PAGOS_LINEA.F_GENERAR_PAGO_ANTICIPO - ' || 'INFO: '|| SQLCODE || ' -ERROR- ' || SQLERRM;
          Lv_Retorno := '003';


          RETURN '{' ||
                          '"retorno":"' || Lv_Retorno || '",' ||
                          '"error":"' || Lv_Error || '"'
                    || '}';
      END;

    END F_GENERAR_PAGO_ANTICIPO;

    /**
    * Documentacion para la funcion F_LLAMAR_JAR
    *
    * La funcion llama a archivo JAR de reactivacion de puntos RC
    *
    * @param Fv_Servicios IN VARCHAR2 puntos de servicios a reactivar
    * @param Fv_UsrCreacion IN VARCHAR2 usuario de creacion
    * @param Fv_ClienteIp IN VARCHAR2 ip del cliente
    * return Fv_Response VARCHAR2
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 26/07/2022
    */
    FUNCTION F_LLAMAR_JAR(Fv_Servicios IN VARCHAR2, Fv_UsrCreacion IN VARCHAR2, Fv_ClienteIp IN VARCHAR2)
    RETURN VARCHAR2
    IS
        Lv_Fecha_Doc    VARCHAR2(20);
        Fv_Response     VARCHAR2(20);
        Lcl_Json        CLOB;
        Lv_UserName     VARCHAR2(30);
        Lv_Password     VARCHAR2(30);
        Lv_URLToken     VARCHAR2(200);
        Lv_Name         VARCHAR2(30);
        Lv_Op           VARCHAR2(100);
        Lv_Token        VARCHAR2(100);
        Lv_StatusToken  VARCHAR2(30);
        Lv_MensajeTk    VARCHAR2(4000);
        Lv_MensajeError VARCHAR2(4000);
        Lv_Metodo        VARCHAR2(10);
        Lv_Version       VARCHAR2(10);
        Lv_Aplicacion    VARCHAR2(50);
        Lv_UrlTelcoTg    VARCHAR2(200);
        Lhttp_Request   UTL_HTTP.req;
        Lhttp_Response  UTL_HTTP.resp;
        Ln_LongitudReq   NUMBER;
        Ln_LongitudIdeal NUMBER:= 32767;
        Ln_Offset        NUMBER:= 1;
        Ln_Buffer        VARCHAR2(2000);
        Ln_Amount        NUMBER := 2000;
        Lv_Status       VARCHAR2(50);
        Le_Error        EXCEPTION;
        data            VARCHAR2(4000);
        Lrf_AdmiParametroDet  SYS_REFCURSOR;    
        Le_AdmiParametroDet   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;

    BEGIN

        Lv_Token        := '';
        Lv_StatusToken  := '';
        Lv_MensajeTk    := '';
        Lv_MensajeError := '';
        Lv_Status       := '';
        Lv_Metodo       := 'POST';
        Lv_Version      := ' HTTP/1.1';
        Lv_Aplicacion   := 'application/json';
        Lv_Fecha_Doc:= TO_DATE(SYSDATE,'yyyy-mm-dd') ;

        Lrf_AdmiParametroDet := DB_GENERAL.GNRLPCK_UTIL.F_GET_PARAMS_DETS('BUS_PAGOS');
        FETCH Lrf_AdmiParametroDet INTO Le_AdmiParametroDet;
        CLOSE Lrf_AdmiParametroDet;

        Lv_UserName     := Le_AdmiParametroDet.valor1;
        Lv_Name         := Le_AdmiParametroDet.valor1;
        Lv_Password     := Le_AdmiParametroDet.valor2; 
        Lv_URLToken     := Le_AdmiParametroDet.valor3;   
        Lv_UrlTelcoTg   := Le_AdmiParametroDet.valor4;   
        Lv_Op           := Le_AdmiParametroDet.valor5;  

        DB_FINANCIERO.FNCK_PAGOS_LINEA.P_GENERAR_TOKEN ( Lv_UserName,
                                                      Lv_Password,                                             
                                                      Lv_URLToken,                                             
                                                      Lv_Name,                                             
                                                      Lv_Token,                                    
                                                      Lv_StatusToken,     
                                                      Lv_MensajeTk,
                                                      Lv_MensajeError                              
                                                    );
        IF Lv_MensajeError IS NOT NULL OR Lv_StatusToken <>'200' THEN
          RAISE Le_Error;
        ELSE            
            Lcl_Json := '{';
            Lcl_Json := Lcl_Json || '"op":"' || Lv_Op ||'",';
            Lcl_Json := Lcl_Json || '"token":"' || Lv_Token ||'",';
            Lcl_Json := Lcl_Json || '"user":"' ||Lv_UserName ||'",';
            Lcl_Json := Lcl_Json || '"data":' ||'{"servicios":"' ||Fv_Servicios ||'",';
            Lcl_Json := Lcl_Json || '"usrCreacion":"' || Fv_UsrCreacion ||'",';
            Lcl_Json := Lcl_Json || '"ipCliente":"' ||Fv_ClienteIp ||'",';
            Lcl_Json := Lcl_Json || '"proceso":"' ||'pago en linea' ||'",';
            Lcl_Json := Lcl_Json || '"fechaProceso":"' ||Lv_Fecha_Doc ||'"},';
            Lcl_Json := Lcl_Json || '"source":'||'{"name":"' ||Lv_Name||'",';
            Lcl_Json := Lcl_Json || '"originID":"' ||'127.0.0.1' ||'",';
            Lcl_Json := Lcl_Json || '"tipoOriginID":"'||'IP' ||'"}';
            Lcl_Json := Lcl_Json ||'}';

            Lhttp_Request := UTL_HTTP.begin_request (Lv_UrlTelcoTg,
                                                     Lv_Metodo,
                                                     Lv_Version);
            DBMS_OUTPUT.PUT_LINE(Lv_UrlTelcoTg);
            UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', Lv_Aplicacion);
            UTL_HTTP.set_header(Lhttp_Request, 'Accept', Lv_Aplicacion);

            Ln_LongitudReq  := DBMS_LOB.getlength(Lcl_Json);

            IF Ln_LongitudReq <= Ln_LongitudIdeal THEN
                UTL_HTTP.set_header(Lhttp_Request, 'Content-Length', LENGTH(Lcl_Json));
                UTL_HTTP.write_text(Lhttp_Request, Lcl_Json);
            ELSE
                UTL_HTTP.set_header(Lhttp_Request, 'Transfer-Encoding', 'chunked');
                WHILE (Ln_Offset < Ln_LongitudReq) LOOP
                  DBMS_LOB.READ(Lcl_Json, 
                                Ln_Amount,
                                Ln_Offset,
                                Ln_Buffer);
                  UTL_HTTP.WRITE_TEXT(Lhttp_Request, Ln_Buffer);
                  Ln_Offset := Ln_Offset + Ln_Amount;
                END LOOP;
            END IF;

            Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
            utl_http.read_text(Lhttp_Response, data);                         
            DBMS_OUTPUT.PUT_LINE(data);
            apex_json.parse (data);

            Lv_Token  :=apex_json.get_varchar2('token');
            Lv_Status :=apex_json.get_varchar2('status');
            Lv_MensajeError:=apex_json.get_varchar2('mensaje');

            UTL_HTTP.end_response(Lhttp_Response);

        END IF;            


        RETURN 'OK: ';

    EXCEPTION
    WHEN Le_Error THEN
        Fv_Response  := 'ERROR';
        RETURN Fv_Response;
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'BUSPAGOS',
                                          'FNCK_PAGOS_LINEA.F_LLAMAR_JAR',
                                          'Error al llamar JAR: Request ('||Lcl_Json||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'telcos'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        Fv_Response  := 'ERROR';
        RETURN Fv_Response;
    END F_LLAMAR_JAR;

    /**
   * Documentacion para P_GENERAR_TOKEN
   * Procedimiento que realiza el consumo de ws de generacion de Token.
   *
   * @author Javier Hidalgo <jihidalgo@telconet.ec>
   * @version 1.0 28/07/2022 
   *
   * @param Pv_UserName IN  VARCHAR2,
   * @param Pv_Password IN  VARCHAR2,
   * @param Pv_Name     IN  VARCHAR2,
   * @param Pv_Token    OUT VARCHAR2,
   * @param Pv_Status   OUT VARCHAR2,
   * @param Pv_Message  OUT VARCHAR2
   * @param Pv_MensajeError  OUT VARCHAR2
   */
    PROCEDURE P_GENERAR_TOKEN (Pv_UserName      IN VARCHAR2,
                               Pv_Password      IN VARCHAR2,
                               Pv_URL           IN VARCHAR2,
                               Pv_Name          IN VARCHAR2,
                               Pv_Token        OUT VARCHAR2,
                               Pv_Status       OUT VARCHAR2,
                               Pv_Message      OUT VARCHAR2,
                               Pv_MensajeError OUT VARCHAR2)IS

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

    BEGIN

      Lv_Metodo       := 'POST';
      Lv_Version      := ' HTTP/1.1';
      Lv_Aplicacion   := 'application/json';

      Lc_Json         := '{"username":"'||Pv_UserName||'","password":"'||Pv_Password||'","source":{"name":"'||Pv_Name||'"'||'}}';
      DBMS_OUTPUT.PUT_LINE(Lc_Json);
      Lhttp_Request := UTL_HTTP.begin_request (Pv_URL,
                                               Lv_Metodo,
                                               Lv_Version);
      DBMS_OUTPUT.PUT_LINE(Pv_URL);
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
      DBMS_OUTPUT.PUT_LINE(data);
      apex_json.parse (data);

      Pv_Token  :=apex_json.get_varchar2('token');
      Pv_Status :=apex_json.get_varchar2('status');
      Pv_Message:=apex_json.get_varchar2('message');

      UTL_HTTP.end_response(Lhttp_Response);

    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        Pv_MensajeError := 'Error UTL_HTTP.end_of_body';
        DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        DBMS_OUTPUT.PUT_LINE('');
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('BUSPAGOS',
                                             'FNCK_PAGOS_LINEA.P_GENERAR_TOKEN',
                                             Pv_MensajeError,
                                             'Error en proceso Generar Token Financiero',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
        
        UTL_HTTP.end_response(Lhttp_Response); 
      WHEN OTHERS THEN
        Pv_MensajeError := 'Error en FNCK_PAGOS_LINEA.P_GENERAR_TOKEN: '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_STACK);
           DBMS_OUTPUT.PUT(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
           DBMS_OUTPUT.PUT_LINE('');
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('BUSPAGOS',
                                              'FNCK_PAGOS_LINEA.P_GENERAR_TOKEN',
                                              Pv_MensajeError,
                                              'Error en proceso Generar Token Financiero',
                                              SYSDATE,
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
            
    END P_GENERAR_TOKEN;

END FNCK_PAGOS_LINEA;
/