/**
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0
 * @since 28/05/2022    
 * Se crea sentencia DDL para reversar creación del paquete FNCK_PAGOS_LINEA  
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
    * @param Pv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Pv_EmpresaCod IN VARCHAR2 código de empresa
    * @param Pv_NombreCliente OUT VARCHAR2 Nombres de cliente
    * @param Pn_Saldo OUT VARCHAR2 Saldo a pagar del cliente
    * @param Pv_NumeroContrato OUT VARCHAR2 Numero de contrato del cliente
    * @param Pv_Status OUT VARCHAR2 estado de respuesta
    * @param Pv_Mensaje OUT VARCHAR2 Devuelve el mensaje de respuesta
    */ 
    PROCEDURE P_CONSULTAR_SALDO_POR_IDENTIF(Pv_Identificacion IN VARCHAR2, 
                                            Pv_EmpresaCod IN VARCHAR2, 
                                            Pv_NombreCliente OUT VARCHAR2,  
                                            Pn_Saldo OUT VARCHAR2,
                                            Pv_NumeroContrato OUT VARCHAR2,
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2);
    
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
    
END FNCK_PAGOS_LINEA;
/

--BODY PACKAGE
create or replace PACKAGE BODY DB_FINANCIERO.FNCK_PAGOS_LINEA AS 
    /**
    * Documentación para P_CONSULTAR_SALDO_POR_IDENTIFICACION
    * Procedimiento que realiza la consulta de saldo por identificacion
    * 
    * @author Javier Hidalgo <jihidalgo@telconet.ec>
    * @version 1.0 28/05/2022
    * 
    * @param Pv_Identificacion IN VARCHAR2 identificación de cliente
    * @param Pv_EmpresaCod IN VARCHAR2 código de empresa
    * @param Pv_Status OUT VARCHAR2 estado
    * @param Pv_Mensaje OUT VARCHAR2 Devuelve el mensaje de respuesta
    * @param Pc_Data OUT CLOB Devuelve data en respuesta
    */ 
    PROCEDURE P_CONSULTAR_SALDO_POR_IDENTIF(Pv_Identificacion IN VARCHAR2, 
                                            Pv_EmpresaCod IN VARCHAR2, 
                                            Pv_NombreCliente OUT VARCHAR2,  
                                            Pn_Saldo OUT VARCHAR2,
                                            Pv_NumeroContrato OUT VARCHAR2,
                                            Pv_Status OUT VARCHAR2, 
                                            Pv_Mensaje OUT VARCHAR2) 
    AS
    Lv_IdPersona          VARCHAR2(50);
    Lv_Identificacion     VARCHAR2(50);
    Lv_RazonSocial        VARCHAR2(500);
    Lv_Nombres            VARCHAR2(500);
    Lv_Apellidos          VARCHAR2(500);
    Ln_Saldo              NUMBER;
    Lnf_SaldoRes          NUMBER;
    Lcl_Query              CLOB;
    Lcl_Select             CLOB;
    Lcl_From               CLOB;
    Lcl_Where              CLOB;
    Lcl_OrderAnGroup       CLOB;
    Pcl_Response           SYS_REFCURSOR;
    Le_Errors              EXCEPTION;
                    
    BEGIN
        IF Pv_Identificacion IS NULL THEN
           Pv_Mensaje := 'El parámetro identificación está vacío';
           RAISE Le_Errors;
        END IF;
    
        IF Pv_EmpresaCod IS NULL THEN
           Pv_Mensaje := 'El parámetro EmpresaCod está vacío';
           RAISE Le_Errors;
        END IF;
        
        Pcl_Response := FNCK_PAGOS_LINEA.F_OBTENER_SALDOS_POR_IDENTIF(Pv_Identificacion, Pv_EmpresaCod);
    
        Lnf_SaldoRes := FNCK_PAGOS_LINEA.F_OBTENER_SUMA_VALOR_PENDIENTE(Pv_Identificacion, Pv_EmpresaCod);
        
        FETCH Pcl_Response INTO Lv_IdPersona, Lv_Identificacion, Lv_RazonSocial, Lv_Nombres, Lv_Apellidos, Ln_Saldo;
                 
        Pn_Saldo := TO_CHAR(ROUND(Ln_Saldo, 4));
        IF Lnf_SaldoRes <> 0 THEN
            Pn_Saldo := TO_CHAR(ROUND(Ln_Saldo - Lnf_SaldoRes, 4));
        END IF;
        
        Pv_NombreCliente := Lv_RazonSocial;
        
        IF LENGTH(Pv_NombreCliente) = 0 THEN
            Pv_NombreCliente := Lv_Nombres || ' ' || Lv_Apellidos;
        END IF;
        
        Pv_NumeroContrato := FNCK_PAGOS_LINEA.F_BUSCAR_NUM_CONTRATO(Pv_Identificacion, Pv_EmpresaCod, 'Activo');
        IF Pv_NumeroContrato IS NULL THEN
            Pv_NumeroContrato := FNCK_PAGOS_LINEA.F_BUSCAR_NUM_CONTRATO(Pv_Identificacion, Pv_EmpresaCod, 'Cancelado');
            IF Pv_NumeroContrato IS NULL THEN
                Pv_NumeroContrato := FNCK_PAGOS_LINEA.F_BUSCAR_NUM_CONTRATO(Pv_Identificacion, Pv_EmpresaCod);
            END IF;
        END IF;
        
        Pv_Status     := 'OK';
        Pv_Mensaje    := 'Transacción exitosa';
    
    EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_PAGOS_LINEA.P_CONSULTAR_SALDO_POR_IDENTIF',
                                          'No se encontró saldo del cliente. Parametros (Identidicacion_cliente: '||Pv_Identificacion||', Codigo_empresa: '
                                          ||Pv_EmpresaCod||')' || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
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

END FNCK_PAGOS_LINEA;
/