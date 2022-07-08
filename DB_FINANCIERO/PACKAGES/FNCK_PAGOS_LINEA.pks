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
    * Documentacion para la funcion F_OBTENER_PAGO_LINEA
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
    PROCEDURE P_VALIDAR_CREDENCIALES(Pcl_Request IN CLOB, Pv_Status OUT VARCHAR2, Pv_Mensaje OUT VARCHAR2, Pb_Response OUT BOOLEAN);
    
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
    EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_PAGOS_LINEA.P_CONSULTAR_SALDO_POR_IDENTIF',
                                          'No se encontró saldo del cliente. Parametros (Identidicacion_cliente: '||Lv_Identificacion||', Codigo_empresa: '
                                          ||Lv_EmpresaCod||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
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
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
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
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
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
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
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
        Lv_CodigoCanal      VARCHAR2(50);
        Lv_NombreCanal      VARCHAR2(50);
        Lv_UsuarioCanal     VARCHAR2(50);

    BEGIN     
        Lc_Canal := FNCK_PAGOS_LINEA.F_OBTENER_CANAL_PAGO_LINEA(Fv_NombreCanal);
        FETCH Lc_Canal INTO Lv_IdCanal, Lv_CodigoCanal, Lv_NombreCanal, Lv_UsuarioCanal;

        OPEN Fc_PagoLinea FOR
            SELECT ID_PAGO_LINEA, PERSONA_ID, VALOR_PAGO_LINEA, FE_CREACION 
            FROM INFO_PAGO_LINEA 
            WHERE CANAL_PAGO_LINEA_ID = Lv_IdCanal AND NUMERO_REFERENCIA = Fv_NumeroRef;

        RETURN Fc_PagoLinea;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
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
    * Documentacion para la funcion F_OBTENER_PAGO_LINEA
    *
    * La funcion retorna canal de pago en linea por nombre  
    *
    * @param Fv_NombreCanal IN VARCHAR2 identificación de cliente
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
            SELECT ID_CANAL_PAGO_LINEA, CODIGO_CANAL_PAGO_LINEA, NOMBRE_CANAL_PAGO_LINEA, USUARIO_CANAL_PAGO_LINEA, CLAVE_CANAL_PAGO_LINEA   
            FROM DB_FINANCIERO.ADMI_CANAL_PAGO_LINEA 
            WHERE NOMBRE_CANAL_PAGO_LINEA = Fv_NombreCanal AND ESTADO_CANAL_PAGO_LINEA = 'Activo';

        RETURN Fc_CanalPago;

    EXCEPTION
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
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

        CURSOR C_GetCliente(Cv_IdPersona VARCHAR2)
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
            AND IPER.PERSONA_ID = Cv_IdPersona;

        Lv_Identificacion   VARCHAR2(50);
        Lv_EmpresaCod       VARCHAR2(50);
        Lv_Usuario          VARCHAR2(50);
        Lv_Canal            VARCHAR2(50);
        Lv_Clave            VARCHAR2(50);
        Lv_TipoTransaccion  VARCHAR2(50);
        Lc_CanalPago        SYS_REFCURSOR;
        Lvr_IdCanal         VARCHAR2(50);
        Lvr_CodigoCanal     VARCHAR2(50);
        Lvr_NombreCanal     VARCHAR2(50);
        Lvr_UsuarioCanal    VARCHAR2(50);
        Lvr_ClaveCanal      VARCHAR2(50);
        Lvr_IdPersona       VARCHAR2(50);
        Lvr_IdPersonaRol    VARCHAR2(50);
        Lvr_EstadoPersona   VARCHAR2(50);
        Lvr_IdEmpresaRol    VARCHAR2(50);

    BEGIN     
        APEX_JSON.PARSE(Pcl_Request);
        Lv_Identificacion  := APEX_JSON.get_varchar2(p_path => 'identificacionCliente'); 
        Lv_EmpresaCod  := APEX_JSON.get_varchar2(p_path => 'codigoExternoEmpresa'); 
        Lv_Usuario  := APEX_JSON.get_varchar2(p_path => 'usuario'); 
        Lv_Canal  := APEX_JSON.get_varchar2(p_path => 'canal'); 
        Lv_Clave  := APEX_JSON.get_varchar2(p_path => 'clave'); 
        Lv_TipoTransaccion  := APEX_JSON.get_varchar2(p_path => 'tipoTransaccion'); 
        Pb_Response := true;

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
            FETCH Lc_CanalPago INTO Lvr_IdCanal, Lvr_CodigoCanal, Lvr_NombreCanal, Lvr_UsuarioCanal, Lvr_ClaveCanal;

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
                    OPEN C_GetCliente(Lvr_IdPersona);
                    FETCH C_GetCliente INTO Lvr_IdPersonaRol, Lvr_EstadoPersona, Lvr_IdEmpresaRol;
                    IF C_GetCliente%ISOPEN THEN
                        CLOSE C_GetCliente;
                    END IF;

                    IF Lvr_IdPersonaRol IS NULL THEN
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
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
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

END FNCK_PAGOS_LINEA;
/