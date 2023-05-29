CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO AS
 
  /**
  * Documentación para P_VALIDA_SALDO
  * Procedimiento para validar el saldo de la persona.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idEmpresa           := Id de Empresa,
  *   idPersona           := Id de persona
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 09/11/2021
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 16/12/2022 - Se modifica la forma de obtener el saldo mediante la llamada a función 'F_GET_SALDO_CLIENTE'.
  *                           Se agrega parámetro de tipo de proceso para validación.
  */
  PROCEDURE  P_VALIDA_SALDO(Pcl_Request IN CLOB, Pv_Mensaje OUT VARCHAR2, Pv_Status OUT VARCHAR2);
   
  /**
  * Documentación para P_VALIDA_FACTURAS
  * Procedimiento para validar facturas recurrentes de la persona.
  *
  * @param Pcl_Request    IN   CLOB Recibe json request
  * [
  *   idEmpresa           := Id de Empresa,
  *   idPersona           := Id de persona
  * ]
  * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
  * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 12/11/2021
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 20/04/2022 - Se modifica validación para que la cantidad de facturas del cliente sea ">=" 
  *                           al valor de cantidad de facturas parametrizada. 
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.2 16/12/2022 - Se agrega parámetro de tipo de proceso para validación.
  */
  PROCEDURE  P_VALIDA_FACTURAS(Pcl_Request IN CLOB, Pv_Mensaje OUT VARCHAR2, Pv_Status OUT VARCHAR2);

  /**
  * Documentación para F_VALIDA_CLIENTE.
  * Procedimiento encargado de validar mediante el IdPersona si es un cliente.
  *
  * Costo query C_GetPersEmpRol: 6
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 16/12/2022
  *
  * @param Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE
  * @param Fv_CodEmpresa IN VARCHAR2
  * @return NUMBER Retorna el IdPersonaRol del cliente
  */ 
  FUNCTION F_VALIDA_CLIENTE(Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                            Fv_CodEmpresa IN VARCHAR2)
  RETURN NUMBER; 
  
  /**
  * Documentación para F_GET_SALDO_CLIENTE.
  * Procedimiento encargado de obtener el saldo por cliente.
  *
  * Costo query C_GetSaldoCliente: 99
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 16/12/2022
  *
  * @param Fn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE
  * @return NUMBER Retorna valor de saldo del cliente
  */ 
  FUNCTION F_GET_SALDO_CLIENTE(Fn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  RETURN NUMBER; 
  
  /**
  * Documentación para P_GET_CANT_FACT_VENCIDAS.
  * Procedimiento encargado de validar y obtener las facturas vencidas por cliente.
  *
  * Costo query C_GetCantFactCliente: 11
  * Costo query C_GetIdCicloCliente: 4
  * Costo query C_GetDiaInicioCiclo: 1
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 16/12/2022
  *
  * @param Fn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE
  * @param Pv_CodEmpresa   IN VARCHAR2
  * @param Pv_TipoProceso  IN VARCHAR2
  * @param Pn_CantFacturas OUT NUMBER
  */ 
  
  PROCEDURE P_GET_CANT_FACT_VENCIDAS(Pn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                     Pv_CodEmpresa   IN VARCHAR2, 
                                     Pv_TipoProceso  IN VARCHAR2,
                                     Pn_CantFacturas OUT NUMBER);
          
  /**
  * Documentación para P_VALIDA_PRODUCTO_ADICIONAL.
  * Procedimiento encargado de la validación de contratación por producto adicional.
  * Se valida el saldo del cliente, y facturas vencidas por cliente mediante la fecha de su ciclo de facturación.
  *
  * Costo query C_GetServicioInternet: 10
  * Costo query C_GetContratoPorPersEmpRol: 6
  * Costo query C_GetDetParametro: 3
  * Costo query C_GetListaDatos: 3
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 16/12/2022
  *
  * @param Pcl_Request IN CLOB Recibe json request
  * [
  *   codEmpresa := Id de Empresa
  *   idPersona  := Id de persona
  *   idPunto    := Id de punto
  * ]
  * @param Pv_Status   OUT VARCHAR2
  * @param Pv_Mensaje  OUT VARCHAR2
  */ 
  PROCEDURE P_VALIDA_PRODUCTO_ADICIONAL(Pcl_Request IN CLOB,
                                        Pv_Status   OUT VARCHAR2,
                                        Pv_Mensaje  OUT VARCHAR2);  
  
  /**
  * Documentación para P_VALIDA_CAMBIO_PLAN_UP.
  * Procedimiento encargado de la validación de contratación por cambio de plan upgrade.
  * Se valida el saldo del cliente, y facturas vencidas por cliente mediante la fecha de su ciclo de facturación.
  *
  * Costo query C_GetDetParametro: 3
  * Costo query C_GetValorCambioPlanF: 3
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 21/12/2022
  *
  * @param Pcl_Request IN CLOB Recibe json request
  * [
  *   codEmpresa       := Id de Empresa
  *   idPersona        := Id de persona
  *   precioPlanActual := Precio plan actual
  *   idPlanCabNuevo   := Id plan nuevo
  * ]
  * @param Pv_Status   OUT VARCHAR2
  * @param Pv_Mensaje  OUT VARCHAR2
  */                                         
  PROCEDURE P_VALIDA_CAMBIO_PLAN_UP(Pcl_Request IN CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2);



  /**
  * Documentación para PROCEDURE 'P_VALIDA_PERFIL_POR_USUARIO'.
  *
  * Procedimiento que permite validar que el usrCreacion (login) posea algún perfil de los parametrizados para el proceso Punto Adicional.
  * Se devuelve como mensaje el valor de "SI" en caso de existir algún perfil, caso contrario se devuelve como mensaje el valor "NO".
  *
  * Costo query C_GetPerfilPorUsr: 7
  *
  * @author Jefferson Carrillo <jacarrillo@telconet.ec>
  * @version 1.0 07/02/2023
  *
  * @param Pcl_Request IN CLOB Recibe json request
  * [
  *   idEmpresa    := Id de Empresa
  *   usrCreacion  := usuario de creación (login)
  *   tipoProceso  := tipo de proceso
  * ]
  * @param Pv_Status   OUT VARCHAR2
  * @param Pv_Mensaje  OUT VARCHAR2
  */                                           
  PROCEDURE P_VALIDA_PERFIL_POR_USUARIO(Pcl_Request IN CLOB,
                                        Pv_Status   OUT VARCHAR2,
                                        Pv_Mensaje  OUT VARCHAR2);   

  /**
  * Documentación para la función F_GET_VALOR_PLAN_POR_EMPRESA.
  * Función que retorna el valor de un plan.
  *
  * Costo del Query C_getValorPlan: 4
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 25-04-2023
  *
  * @param  Fn_IdPlan     DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE => Id del plan.
  * @param  Fv_CodEmpresa VARCHAR2 => Id de la empresa.
  * @return VALOR_PLAN  Retorna valor del plan
  */                                      
  FUNCTION F_GET_VALOR_PLAN_POR_EMPRESA(Fn_IdPlan     IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
                                        Fv_CodEmpresa IN VARCHAR2)
  RETURN NUMBER;                                      


END FNCK_VALIDACIONES_FORMA_PAGO;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO AS


  PROCEDURE P_VALIDA_SALDO(Pcl_Request IN CLOB, Pv_Mensaje OUT VARCHAR2, Pv_Status OUT VARCHAR2)
  AS 
    --Costo query 6
    CURSOR C_GetPersEmpRol(Cn_IdPersona NUMBER, Cv_DescRol VARCHAR2, Cv_EmpresaCod VARCHAR2) IS                      
      SELECT IPER.ID_PERSONA_ROL
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
      DB_GENERAL.ADMI_ROL AROL,
      DB_GENERAL.ADMI_TIPO_ROL ATROL
      WHERE IPER.EMPRESA_ROL_ID      = IER.ID_EMPRESA_ROL 
      AND IER.ROL_ID                 = AROL.ID_ROL 
      AND AROL.TIPO_ROL_ID           = ATROL.ID_TIPO_ROL 
      AND IPER.PERSONA_ID            = Cn_IdPersona 
      AND ATROL.DESCRIPCION_TIPO_ROL = Cv_DescRol 
      AND IPER.ESTADO                IN ('Activo')
      AND IER.EMPRESA_COD            = Cv_EmpresaCod ; 
      
    --Costo query 6    
    CURSOR C_GetParametroDet(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                             Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                             Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT DET.VALOR1, DET.VALOR2, DET.VALOR3
        FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
          DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
        AND DET.DESCRIPCION      = Cv_DescripcionDetParam
        AND DET.ESTADO           = Cv_EstadoActivo
        AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND CAB.ESTADO           = Cv_EstadoActivo
        AND DET.EMPRESA_COD      = Cv_EmpresaCod
        AND DET.VALOR7           = Cv_TipoProceso;    
    
    Lv_CodEmpresa           VARCHAR2(50);
    Ln_IdPersona            NUMBER;
    Ln_IdPersonaRol         NUMBER;
    Ln_SaldoTotal           NUMBER;
    Lc_MensajeValidaSaldo   C_GetParametroDet%ROWTYPE;
    Le_Errors               EXCEPTION;
    Lv_NombreParamCabCliente VARCHAR2(100) := 'PARAM_CLIENTE_VALIDACIONES';
    Lv_ParamMsjValidaSaldo  VARCHAR2(100) := 'MENSAJES_VALIDACION_SALDO';
    Lv_EstadoActivo         VARCHAR2(100) := 'Activo';
    Lv_TipoProceso          VARCHAR2(100);

  BEGIN

    APEX_JSON.PARSE(Pcl_Request); 
    
    Lv_CodEmpresa  := APEX_JSON.get_varchar2(p_path => 'idEmpresa'); 
    Ln_IdPersona   := APEX_JSON.get_number(p_path => 'idPersona'); 
    Lv_TipoProceso := APEX_JSON.get_varchar2(p_path => 'tipoProceso');
    
    IF Lv_CodEmpresa IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_CodEmpresa esta vacío';
      RAISE Le_Errors;
    END IF;
    
    IF Ln_IdPersona IS NULL THEN
      Pv_Mensaje := 'El parámetro Ln_IdPersona esta vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_TipoProceso IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_TipoProceso esta vacío';
      RAISE Le_Errors;
    END IF;
    
    IF C_GetPersEmpRol%ISOPEN THEN
      CLOSE C_GetPersEmpRol;
    END IF;
    
    IF C_GetParametroDet%ISOPEN THEN
      CLOSE C_GetParametroDet;
    END IF;
    
    OPEN  C_GetPersEmpRol(Ln_IdPersona, 'Cliente', Lv_CodEmpresa ); 
    FETCH C_GetPersEmpRol INTO Ln_IdPersonaRol;  
    CLOSE C_GetPersEmpRol; 
    
    OPEN  C_GetParametroDet(Lv_NombreParamCabCliente, Lv_ParamMsjValidaSaldo, Lv_EstadoActivo, Lv_CodEmpresa, Lv_TipoProceso); 
    FETCH C_GetParametroDet INTO Lc_MensajeValidaSaldo;  
    CLOSE C_GetParametroDet;
    
    IF Ln_IdPersonaRol IS NOT NULL THEN
        Ln_SaldoTotal := DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.F_GET_SALDO_CLIENTE(Ln_IdPersonaRol);

        IF Ln_SaldoTotal > 0 AND Ln_SaldoTotal IS NOT NULL THEN
            Pv_Mensaje := REPLACE(Lc_MensajeValidaSaldo.valor1, 'Ln_SaldoTotal', Ln_SaldoTotal);
            RAISE Le_Errors;
        END IF;  
    END IF; 
    
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacción exitosa.';

  EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
      WHEN OTHERS THEN
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;
  END P_VALIDA_SALDO;


  PROCEDURE P_VALIDA_FACTURAS(Pcl_Request IN CLOB, Pv_Mensaje OUT VARCHAR2, Pv_Status OUT VARCHAR2)
  AS 

    --Costo query 6
    CURSOR C_GetPersEmpRol(Cn_IdPersona NUMBER, Cv_DescRol VARCHAR2, Cv_EmpresaCod VARCHAR2) IS                      
      SELECT IPER.ID_PERSONA_ROL
        FROM 
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AROL,
        DB_GENERAL.ADMI_TIPO_ROL ATROL
        WHERE IPER.EMPRESA_ROL_ID      = IER.ID_EMPRESA_ROL 
        AND IER.ROL_ID                 = AROL.ID_ROL 
        AND AROL.TIPO_ROL_ID           = ATROL.ID_TIPO_ROL 
        AND IPER.PERSONA_ID            = Cn_IdPersona 
        AND ATROL.DESCRIPCION_TIPO_ROL = Cv_DescRol 
        AND IPER.ESTADO                IN ('Activo')
        AND IER.EMPRESA_COD            = Cv_EmpresaCod ; 

      --Costo query 3
    CURSOR C_GetContratoPorPersEmpRol(Cv_IdPersonaRol NUMBER, Cv_EstadoContrato VARCHAR2) IS  
      SELECT IC.ID_CONTRATO, IC.FORMA_PAGO_ID  
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_CONTRATO IC
      WHERE IPER.ID_PERSONA_ROL = IC.PERSONA_EMPRESA_ROL_ID
      AND IC.ESTADO             = Cv_EstadoContrato
      AND IPER.ID_PERSONA_ROL   = Cv_IdPersonaRol ; 

    --Cursor que obtiene parámetro forma de pago que se excluyen en la validación en facturas. 
    --Costo query 6    
    CURSOR C_GetParamDetExcluyeFP(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                  Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                  Cv_Valor2              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                  Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                  Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT DET.VALOR1, DET.VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
          DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
        AND DET.DESCRIPCION      = Cv_DescripcionDetParam
        AND DET.ESTADO           = Cv_EstadoActivo
        AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND CAB.ESTADO           = Cv_EstadoActivo
        AND DET.VALOR2           IN (Cv_Valor2)
        AND DET.EMPRESA_COD      = Cv_EmpresaCod
        AND DET.VALOR7           = Cv_TipoProceso;    

    --Costo query 6    
    CURSOR C_GetParametroDet(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                             Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                             Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT DET.VALOR1, DET.VALOR2, DET.VALOR3, DET.VALOR4, DET.VALOR5
        FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
          DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
        AND DET.DESCRIPCION      = Cv_DescripcionDetParam
        AND DET.ESTADO           = Cv_EstadoActivo
        AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND CAB.ESTADO           = Cv_EstadoActivo
        AND DET.EMPRESA_COD      = Cv_EmpresaCod
        AND DET.VALOR7           = Cv_TipoProceso;       

    --Costo query 13
    CURSOR C_GetFacturasRecurrentes(Cv_EmpresaCod          VARCHAR2, 
                                    Cv_IdPersonaRol        NUMBER, 
                                    Cn_CantidadDocs        NUMBER,
                                    Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                    Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                    Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                    Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT TABLA.ID_DOCUMENTO, TABLA.REFERENCIA_DOCUMENTO_ID, TABLA.NUMERO_FACTURA_SRI, TABLA.PUNTO_ID
      FROM (
          SELECT IDFC.ID_DOCUMENTO, IDFC.REFERENCIA_DOCUMENTO_ID, IDFC.NUMERO_FACTURA_SRI, IDFC.PUNTO_ID 
            FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
              DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
              DB_COMERCIAL.INFO_PUNTO IP,
              DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
              DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
            WHERE IPER.ID_PERSONA_ROL      = IP.PERSONA_EMPRESA_ROL_ID
            AND IDFC.PUNTO_ID              = IP.ID_PUNTO
            AND IDFC.NUMERO_FACTURA_SRI    IS NOT NULL
            AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
            AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
            AND IOG.EMPRESA_ID             = Cv_EmpresaCod
            AND IPER.ID_PERSONA_ROL        = Cv_IdPersonaRol
            AND ATDF.CODIGO_TIPO_DOCUMENTO IN (SELECT DET.VALOR1
                                              FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
                                                DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                                              WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
                                              AND DET.DESCRIPCION      = Cv_DescripcionDetParam
                                              AND DET.ESTADO           = Cv_EstadoActivo
                                              AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                                              AND CAB.ESTADO           = Cv_EstadoActivo
                                              AND DET.EMPRESA_COD      = Cv_EmpresaCod
                                              AND DET.VALOR7           = Cv_TipoProceso)
            AND IDFC.RECURRENTE = 'S' 
            ORDER BY IDFC.FE_CREACION DESC 
          ) TABLA WHERE ROWNUM <= Cn_CantidadDocs ; 

    --Costo query 13      
    CURSOR C_GetCantFactRecurrentes(Cv_EmpresaCod          VARCHAR2, 
                                    Cv_IdPersonaRol        NUMBER, 
                                    Cn_CantidadDocs        NUMBER,
                                    Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                    Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                    Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                    Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT COUNT(TABLA.ID_DOCUMENTO)
      FROM (
          SELECT IDFC.ID_DOCUMENTO
            FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
              DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
              DB_COMERCIAL.INFO_PUNTO IP,
              DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
              DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
            WHERE IPER.ID_PERSONA_ROL      = IP.PERSONA_EMPRESA_ROL_ID
            AND IDFC.PUNTO_ID              = IP.ID_PUNTO
            AND IDFC.NUMERO_FACTURA_SRI    IS NOT NULL
            AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
            AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
            AND IOG.EMPRESA_ID             = Cv_EmpresaCod
            AND IPER.ID_PERSONA_ROL        = Cv_IdPersonaRol
            AND ATDF.CODIGO_TIPO_DOCUMENTO IN (SELECT DET.VALOR1
                                              FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
                                                DB_GENERAL.ADMI_PARAMETRO_CAB CAB
                                              WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
                                              AND DET.DESCRIPCION      = Cv_DescripcionDetParam
                                              AND DET.ESTADO           = Cv_EstadoActivo
                                              AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
                                              AND CAB.ESTADO           = Cv_EstadoActivo
                                              AND DET.EMPRESA_COD      = Cv_EmpresaCod
                                              AND DET.VALOR7           = Cv_TipoProceso)
            AND IDFC.RECURRENTE = 'S' 
            ORDER BY IDFC.FE_CREACION DESC 
          ) TABLA WHERE ROWNUM <= Cn_CantidadDocs ;  

    --Costo query 6
    CURSOR C_GetPagos(Cv_ReferenciaId NUMBER)
    IS
      SELECT IPD.ID_PAGO_DET, IPD.FORMA_PAGO_ID
      FROM DB_FINANCIERO.INFO_PAGO_DET IPD
      WHERE IPD.REFERENCIA_ID = Cv_ReferenciaId; 

    Lv_CodEmpresa               VARCHAR2(50);
    Ln_IdPersona                NUMBER;
    Ln_IdPersonaRol             NUMBER;
    Ln_CantidadFacturas         NUMBER; 
    Ln_contador                 NUMBER := 0; 
    Le_Errors                   EXCEPTION;

    Lv_EstadoContrato           VARCHAR2(100) := 'Activo';
    Lv_NombreParamCabCliente    VARCHAR2(100) := 'PARAM_CLIENTE_VALIDACIONES';
    Lv_DescDetParamExcFP        VARCHAR2(100) := 'EXCLUSION_FORMA_PAGO_VALIDA_FACT';
    Lv_DesDetParamValidaFact    VARCHAR2(100) := 'VALIDACION_FACTURAS';
    Lv_ParamMsjValidaFact       VARCHAR2(100) := 'MENSAJES_VALIDACION_FACT';
    Lv_DesDetParamTipoDoc       VARCHAR2(100) := 'TIPO_DOCUMENTO';
    Lv_EstadoActivo             VARCHAR2(100) := 'Activo';
    Lv_FormaPago                VARCHAR2(100);
    Lc_GetParamDetExcluyeFP     C_GetParamDetExcluyeFP%ROWTYPE; 
    Lc_MensajeValidaFact        C_GetParametroDet%ROWTYPE;
    Lc_ValidacionFactura        C_GetParametroDet%ROWTYPE;        
    Lc_GetContratoPorPersEmpRol C_GetContratoPorPersEmpRol%ROWTYPE;
    Lv_TipoProceso              VARCHAR2(100);

  BEGIN

    APEX_JSON.PARSE(Pcl_Request); 

    Lv_CodEmpresa  := APEX_JSON.get_varchar2(p_path => 'idEmpresa'); 
    Ln_IdPersona   := APEX_JSON.get_number(p_path => 'idPersona'); 
    Lv_TipoProceso := APEX_JSON.get_varchar2(p_path => 'tipoProceso');
    
    IF Lv_CodEmpresa IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_CodEmpresa esta vacío';
      RAISE Le_Errors;
    END IF;
    
    IF Ln_IdPersona IS NULL THEN
      Pv_Mensaje := 'El parámetro Ln_IdPersona esta vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_TipoProceso IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_TipoProceso esta vacío';
      RAISE Le_Errors;
    END IF;
    
    IF C_GetPersEmpRol%ISOPEN THEN
      CLOSE C_GetPersEmpRol;
    END IF;
    
    IF C_GetContratoPorPersEmpRol%ISOPEN THEN
      CLOSE C_GetContratoPorPersEmpRol;
    END IF;
    
    IF C_GetParamDetExcluyeFP%ISOPEN THEN
      CLOSE C_GetParamDetExcluyeFP;
    END IF;
    
    IF C_GetCantFactRecurrentes%ISOPEN THEN
      CLOSE C_GetCantFactRecurrentes;
    END IF;
    
    IF C_GetParametroDet%ISOPEN THEN
      CLOSE C_GetParametroDet;
    END IF;
    
    
    OPEN  C_GetPersEmpRol(Ln_IdPersona, 'Cliente', Lv_CodEmpresa); 
    FETCH C_GetPersEmpRol INTO Ln_IdPersonaRol;  
    CLOSE C_GetPersEmpRol; 
    
    OPEN  C_GetParametroDet(Lv_NombreParamCabCliente, Lv_ParamMsjValidaFact, Lv_EstadoActivo, Lv_CodEmpresa, Lv_TipoProceso); 
    FETCH C_GetParametroDet INTO Lc_MensajeValidaFact;  
    CLOSE C_GetParametroDet;
    
    IF Ln_IdPersonaRol IS NULL THEN
        Pv_Status  := 'OK';
        Pv_Mensaje := Lc_MensajeValidaFact.valor4;
    END IF; 
    
    IF Ln_IdPersonaRol IS NOT NULL THEN
        --Se obtiene el contrato del cliente
        OPEN  C_GetContratoPorPersEmpRol(Ln_IdPersonaRol, Lv_EstadoContrato); 
        FETCH C_GetContratoPorPersEmpRol INTO Lc_GetContratoPorPersEmpRol;  
        CLOSE C_GetContratoPorPersEmpRol; 
    
        --Se valida si posee contrato activo
        IF Lc_GetContratoPorPersEmpRol.ID_CONTRATO IS NULL THEN
            Pv_Mensaje := Lc_MensajeValidaFact.valor5;
            RAISE Le_Errors;
        END IF;
    
        OPEN  C_GetParamDetExcluyeFP(Lv_NombreParamCabCliente, Lv_DescDetParamExcFP, Lv_EstadoActivo, 
                                      Lc_GetContratoPorPersEmpRol.FORMA_PAGO_ID, Lv_CodEmpresa, Lv_TipoProceso); 
        FETCH C_GetParamDetExcluyeFP INTO Lc_GetParamDetExcluyeFP;  
        CLOSE C_GetParamDetExcluyeFP;  

        IF Lc_GetParamDetExcluyeFP.VALOR2 IS NOT NULL THEN 
            Pv_Status    := 'OK';
            Pv_Mensaje   := 'Transacción exitosa';
        ELSE 
          --Se obtiene la cantidad parametrizada de validación facturas recurrentes. 
          OPEN  C_GetParametroDet(Lv_NombreParamCabCliente, Lv_DesDetParamValidaFact, Lv_EstadoActivo, Lv_CodEmpresa, Lv_TipoProceso); 
          FETCH C_GetParametroDet INTO Lc_ValidacionFactura;  
          CLOSE C_GetParametroDet;   
  
          --Obtiene la cantidad de facturas recurrentes del cliente
          OPEN  C_GetCantFactRecurrentes(Lv_CodEmpresa, Ln_IdPersonaRol, Lc_ValidacionFactura.VALOR2, 
                                        Lv_NombreParamCabCliente, Lv_DesDetParamTipoDoc, Lv_EstadoActivo, Lv_TipoProceso); 
          FETCH C_GetCantFactRecurrentes INTO Ln_CantidadFacturas;  
          CLOSE C_GetCantFactRecurrentes;   
  
          IF Ln_CantidadFacturas >= Lc_ValidacionFactura.VALOR2 AND Ln_CantidadFacturas != 0 THEN
            --Se recorre las facturas a revisar
            FOR Facturas IN C_GetFacturasRecurrentes(Lv_CodEmpresa, Ln_IdPersonaRol, Lc_ValidacionFactura.VALOR2, 
                                                    Lv_NombreParamCabCliente, Lv_DesDetParamTipoDoc, Lv_EstadoActivo, Lv_TipoProceso) LOOP
                Ln_contador := Ln_contador +1;
    
                --Se recorre los pagos de la factura
                FOR Pagos IN C_GetPagos(Facturas.ID_DOCUMENTO) LOOP
    
                    IF Pagos.FORMA_PAGO_ID = Lc_GetContratoPorPersEmpRol.FORMA_PAGO_ID THEN
                        Pv_Status    := 'OK';
                        Pv_Mensaje   := 'Transacción exitosa';
                        EXIT;     
                    END IF;
    
                END LOOP;

                EXIT WHEN Pv_Status = 'OK';
    
            END LOOP;

            IF Pv_Status IS NULL THEN
                Pv_Mensaje := REPLACE(Lc_MensajeValidaFact.valor3, 'Ln_CantidadFacturas', Ln_CantidadFacturas);
                RAISE Le_Errors;
            END IF;

          ELSE
              Pv_Status    := 'OK';
              Pv_Mensaje   := 'Transacción exitosa';      
          END IF; 
          
        END IF;

    END IF;

  EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
      WHEN OTHERS THEN
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;
  END P_VALIDA_FACTURAS;
  --

  FUNCTION F_VALIDA_CLIENTE(Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                            Fv_CodEmpresa IN VARCHAR2)
  RETURN NUMBER                              
  IS
    --
    CURSOR C_GetPersEmpRol(Cn_IdPersona  DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE, 
                           Cv_DescRol    VARCHAR2, 
                           Cv_EmpresaCod VARCHAR2) 
    IS                      
      SELECT IPER.ID_PERSONA_ROL
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AROL,
        DB_GENERAL.ADMI_TIPO_ROL ATROL
      WHERE IPER.EMPRESA_ROL_ID      = IER.ID_EMPRESA_ROL 
      AND IER.ROL_ID                 = AROL.ID_ROL 
      AND AROL.TIPO_ROL_ID           = ATROL.ID_TIPO_ROL
      AND IPER.ESTADO                IN ('Activo')
      AND IPER.PERSONA_ID            = Cn_IdPersona 
      AND ATROL.DESCRIPCION_TIPO_ROL = Cv_DescRol 
      AND IER.EMPRESA_COD            = Cv_EmpresaCod;
    
    Ln_IdPersonaRol NUMBER; 
    
    --
  BEGIN
    --
    IF C_GetPersEmpRol%ISOPEN THEN
        CLOSE C_GetPersEmpRol;
    END IF;
    
    OPEN C_GetPersEmpRol(Fn_IdPersona,'Cliente',Fv_CodEmpresa);
    FETCH C_GetPersEmpRol INTO Ln_IdPersonaRol;      
    CLOSE C_GetPersEmpRol;

    RETURN Ln_IdPersonaRol;

  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNCK_VALIDACIONES_FORMA_PAGO', 
                                         'DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.F_VALIDA_CLIENTE', 
                                         'ERROR_STACK: '||DBMS_UTILITY.FORMAT_ERROR_STACK||' ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'DB_FINANCIERO',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    RETURN NULL;
    
  END F_VALIDA_CLIENTE;
  --
  
  FUNCTION F_GET_SALDO_CLIENTE(Fn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  RETURN NUMBER                              
  IS
    --
    CURSOR C_GetSaldoCliente(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) 
    IS  
      SELECT SUM(VECR.SALDO)
      FROM DB_COMERCIAL.INFO_PUNTO IP,
        DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO VECR 
      WHERE IP.ID_PUNTO             = VECR .PUNTO_ID 
      AND IP.PERSONA_EMPRESA_ROL_ID = Cn_IdPersonaRol; 
    
    Ln_Saldo NUMBER;  
    --
  BEGIN
    --
    IF C_GetSaldoCliente%ISOPEN THEN
        CLOSE C_GetSaldoCliente;
    END IF;
    
    OPEN C_GetSaldoCliente(Fn_IdPersonaRol);
    FETCH C_GetSaldoCliente INTO Ln_Saldo;
    CLOSE C_GetSaldoCliente;

    RETURN Ln_Saldo;

  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNCK_VALIDACIONES_FORMA_PAGO', 
                                         'DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.F_GET_SALDO_CLIENTE', 
                                         'ERROR_STACK: '||DBMS_UTILITY.FORMAT_ERROR_STACK||' ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'DB_FINANCIERO',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    RETURN NULL;
    
  END F_GET_SALDO_CLIENTE;
  --
  
  PROCEDURE P_GET_CANT_FACT_VENCIDAS(Pn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                     Pv_CodEmpresa   IN VARCHAR2, 
                                     Pv_TipoProceso  IN VARCHAR2,
                                     Pn_CantFacturas OUT NUMBER)
  IS
    --
    CURSOR C_GetCantFactCliente(Cn_IdPersonaRol        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                Cv_Estado              DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE, 
                                Cd_FechaInicio         DATE,
                                Cd_FechaFin            DATE) 
    IS  
      SELECT COUNT(IDFC.ID_DOCUMENTO) 
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      WHERE IPER.ID_PERSONA_ROL      = IP.PERSONA_EMPRESA_ROL_ID
      AND IDFC.PUNTO_ID              = IP.ID_PUNTO
      AND IDFC.NUMERO_FACTURA_SRI    IS NOT NULL
      AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
      AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID             = Cv_EmpresaCod
      AND IPER.ID_PERSONA_ROL        = Cn_IdPersonaRol
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN (SELECT APD.VALOR1
                                         FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                           DB_GENERAL.ADMI_PARAMETRO_DET APD
                                         WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
                                         AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                                         AND APD.DESCRIPCION      = Cv_DescripcionDetParam
                                         AND APD.EMPRESA_COD      = Cv_EmpresaCod
                                         AND APD.ESTADO           = Cv_Estado
                                         AND APC.ESTADO           = Cv_Estado
                                         AND APD.VALOR7           = Cv_TipoProceso)
      AND ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, '', 'saldo'), 2) > 0
      AND IDFC.FE_EMISION NOT BETWEEN Cd_FechaInicio AND Cd_FechaFin;

    CURSOR C_GetIdCicloCliente(Cn_IdPersonaRol DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE) 
    IS  
      SELECT CI.ID_CICLO 
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, 
        DB_COMERCIAL.ADMI_CARACTERISTICA CA,
        DB_FINANCIERO.ADMI_CICLO CI
      WHERE IPER.ID_PERSONA_ROL                                    = Cn_IdPersonaRol  
      AND IPERC.PERSONA_EMPRESA_ROL_ID                             = IPER.ID_PERSONA_ROL
      AND IPERC.CARACTERISTICA_ID                                  = CA.ID_CARACTERISTICA
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPERC.VALOR,'^\d+')),0) = CI.ID_CICLO
      AND CA.DESCRIPCION_CARACTERISTICA                            = 'CICLO_FACTURACION'  
      AND IPERC.ESTADO                                             = 'Activo'; 

    CURSOR C_GetDiaInicioCiclo(Cn_IdCiclo NUMBER) 
    IS  
      SELECT TO_CHAR(FE_INICIO,'DD') as DIA_INICIO
      FROM DB_FINANCIERO.ADMI_CICLO
      WHERE ID_CICLO = Cn_IdCiclo; 
    
    Ln_IdCiclo               NUMBER;
    Ln_CantFacturas          NUMBER;
    Lv_FechaInicioActual     VARCHAR2(100);
    Lv_FechaFinActual        VARCHAR2(100);
    Lv_MesActual             VARCHAR2(10)  := TO_CHAR(SYSDATE,'MM');
    Lv_AnioActual            VARCHAR2(10)  := TO_CHAR(SYSDATE,'YYYY');
    Lv_NombreParamCabCliente VARCHAR2(100) := 'PARAM_CLIENTE_VALIDACIONES';
    Lv_DescDetParamTipoDoc   VARCHAR2(100) := 'TIPO_DOCUMENTO';
    Lv_EstadoActivo          VARCHAR2(20)  := 'Activo';
    Ld_FechaInicio           DATE;
    Ld_FechaFin              DATE;
    Lc_Ciclo                 C_GetDiaInicioCiclo%ROWTYPE; 
    
    --
  BEGIN
    --
    IF C_GetCantFactCliente%ISOPEN THEN
        CLOSE C_GetCantFactCliente;
    END IF;
    
    IF C_GetIdCicloCliente%ISOPEN THEN
        CLOSE C_GetIdCicloCliente;
    END IF;
    
    IF C_GetDiaInicioCiclo%ISOPEN THEN
        CLOSE C_GetDiaInicioCiclo;
    END IF;

    OPEN C_GetIdCicloCliente(Pn_IdPersonaRol);
    FETCH C_GetIdCicloCliente INTO Ln_IdCiclo;      
    CLOSE C_GetIdCicloCliente;
    
    OPEN C_GetDiaInicioCiclo(Ln_IdCiclo);
    FETCH C_GetDiaInicioCiclo INTO Lc_Ciclo;      
    CLOSE C_GetDiaInicioCiclo;
    
    Lv_FechaInicioActual := Lc_Ciclo.DIA_INICIO||'/'||Lv_MesActual||'/'||Lv_AnioActual;
    Ld_FechaInicio       := TO_DATE(Lv_FechaInicioActual,'DD/MM/YYYY');
    Lv_FechaFinActual    := TO_CHAR(ADD_MONTHS(Ld_FechaInicio,1)-1,'DD/MM/YYYY');
    Ld_FechaFin          := TO_DATE(Lv_FechaFinActual,'DD/MM/YYYY');
    
    OPEN C_GetCantFactCliente(Pn_IdPersonaRol,Lv_NombreParamCabCliente,Lv_DescDetParamTipoDoc,Pv_CodEmpresa,
                              Lv_EstadoActivo,Pv_TipoProceso,Ld_FechaInicio,Ld_FechaFin);
    FETCH C_GetCantFactCliente INTO Ln_CantFacturas; 
    CLOSE C_GetCantFactCliente;
    
    Pn_CantFacturas := Ln_CantFacturas;

  EXCEPTION
  WHEN OTHERS THEN
    Pn_CantFacturas := NULL;
    
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNCK_VALIDACIONES_FORMA_PAGO', 
                                         'DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.P_GET_CANT_FACT_VENCIDAS', 
                                         'ERROR_STACK: '||DBMS_UTILITY.FORMAT_ERROR_STACK||' ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'DB_FINANCIERO',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_GET_CANT_FACT_VENCIDAS;
  --

  PROCEDURE P_VALIDA_PRODUCTO_ADICIONAL(Pcl_Request IN CLOB,
                                        Pv_Status   OUT VARCHAR2,
                                        Pv_Mensaje  OUT VARCHAR2)
  IS
    --
    CURSOR C_GetServicioInternet(Cn_IdPunto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                 Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_DescripcionParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                 Cv_TipoProceso      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE) 
    IS  
      SELECT ISER.ID_SERVICIO
      FROM DB_COMERCIAL.INFO_SERVICIO ISER,
        DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO AP 
      WHERE AP.CODIGO_PRODUCTO = 'INTD'
      AND AP.ID_PRODUCTO       = IPD.PRODUCTO_ID
      AND IPD.PLAN_ID          = ISER.PLAN_ID
      AND ISER.PUNTO_ID        = Cn_IdPunto
      AND UPPER(ISER.ESTADO)   IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                   FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                     DB_GENERAL.ADMI_PARAMETRO_DET APD
                                   WHERE APD.PARAMETRO_ID     = APC.ID_PARAMETRO
                                   AND APD.ESTADO           = 'Activo'
                                   AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                                   AND APD.DESCRIPCION      = Cv_DescripcionParam
                                   AND APC.ESTADO           = 'Activo'
                                   AND APD.VALOR7           = Cv_TipoProceso); 
                                   
    CURSOR C_GetContratoPorPersEmpRol(Cv_IdPersonaRol     DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                                      Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                      Cv_DescripcionParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                      Cv_TipoProceso      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE) 
    IS  
      SELECT IC.ID_CONTRATO 
      FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_CONTRATO IC
      WHERE IPER.ID_PERSONA_ROL = IC.PERSONA_EMPRESA_ROL_ID
      AND IPER.ID_PERSONA_ROL   = Cv_IdPersonaRol     
      AND UPPER(IC.ESTADO)      IN (SELECT UPPER(APD.VALOR1) AS VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                      DB_GENERAL.ADMI_PARAMETRO_DET APD
                                    WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                    AND APD.ESTADO           = 'Activo'
                                    AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                                    AND APD.DESCRIPCION      = Cv_DescripcionParam
                                    AND APC.ESTADO           = 'Activo'
                                    AND APD.VALOR7           = Cv_TipoProceso);
                                 
        
    CURSOR C_GetDetParametro(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                             Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                             Cv_Estado              DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
        DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APD.DESCRIPCION      = Cv_DescripcionDetParam
      AND APD.EMPRESA_COD      = Cv_EmpresaCod
      AND APD.ESTADO           = Cv_Estado
      AND APC.ESTADO           = Cv_Estado
      AND APD.VALOR7           = Cv_TipoProceso;   

    CURSOR C_GetListaDatos(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                           Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                           Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                           Cv_Estado              DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                           Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT LISTAGG(APD.VALOR1,',') WITHIN GROUP (ORDER BY APD.FE_CREACION) AS DATOS
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
        DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APD.DESCRIPCION      = Cv_DescripcionDetParam
      AND APD.EMPRESA_COD      = Cv_EmpresaCod
      AND APD.ESTADO           = Cv_Estado
      AND APC.ESTADO           = Cv_Estado
      AND APD.VALOR7           = Cv_TipoProceso;  
    
    Le_Errors                   EXCEPTION;
    Ln_IdPersona                NUMBER;
    Ln_IdPunto                  NUMBER;
    Ln_IdPersonaRol             NUMBER;
    Ln_IdContrato               NUMBER;
    Ln_Servicio                 NUMBER;
    Ln_Saldo                    NUMBER;
    Ln_CantFactVencidasCliente  NUMBER;
    Lv_CodEmpresa               VARCHAR2(10);
    Lv_TipoProceso              VARCHAR2(100);
    Lv_NombreParamCabCliente    VARCHAR2(100) := 'PARAM_CLIENTE_VALIDACIONES';
    Lv_DescParamMsjValidaProd   VARCHAR2(800) := 'MSJ_VALIDACION_PROD_ADICIONAL'; 
    Lv_DescParamMsjServicioInt  VARCHAR2(800) := 'MSJ_SERVICIO_INTERNET';
    Lv_DescParamMsjContrato     VARCHAR2(800) := 'MSJ_CONTRATO';
    Lv_DescParamDeuda           VARCHAR2(100) := 'VALOR_DEUDA';
    Lv_DescParamCantFactVenc    VARCHAR2(100) := 'CANTIDAD_FACT_VENCIDAS';
    Lv_DescParamEstadoOS        VARCHAR2(100) := 'ESTADO_SERVICIO';
    Lv_DescParamEstadoContrato  VARCHAR2(100) := 'ESTADO_CONTRATO';
    Lv_EstadoActivo             VARCHAR2(20)  := 'Activo';
    Lv_EstadoServicio           VARCHAR2(4000);
    Lv_EstadoContrato           VARCHAR2(4000);
    Lc_MsjValidaProd            C_GetDetParametro%ROWTYPE;
    Lc_CantLimiteFactVencidas   C_GetDetParametro%ROWTYPE;
    Lc_ValorDeuda               C_GetDetParametro%ROWTYPE;
    Lc_MsjServicioInt           C_GetDetParametro%ROWTYPE;
    Lc_MsjContrato              C_GetDetParametro%ROWTYPE;
    
    --
  BEGIN
    --
    APEX_JSON.PARSE(Pcl_Request); 
    
    Lv_CodEmpresa  := APEX_JSON.get_varchar2(p_path => 'idEmpresa'); 
    Ln_IdPersona   := APEX_JSON.get_number(p_path => 'idPersona'); 
    Ln_IdPunto     := APEX_JSON.get_number(p_path => 'idPunto');
    Lv_TipoProceso := APEX_JSON.get_varchar2(p_path => 'tipoProceso');
    
    IF Lv_CodEmpresa IS NULL THEN
        Pv_Mensaje := 'El parámetro Lv_CodEmpresa esta vacío';
        RAISE Le_Errors;
    END IF;
    
    IF Ln_IdPersona IS NULL THEN
        Pv_Mensaje := 'El parámetro Ln_IdPersona esta vacío';
        RAISE Le_Errors;
    END IF;
    
    IF Ln_IdPunto IS NULL THEN
        Pv_Mensaje := 'El parámetro Ln_IdPunto esta vacío';
        RAISE Le_Errors;
    END IF;

    IF Lv_TipoProceso IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_TipoProceso esta vacío';
      RAISE Le_Errors;
    END IF;
    --
    
    IF C_GetServicioInternet%ISOPEN THEN
        CLOSE C_GetServicioInternet;
    END IF;
    
    IF C_GetContratoPorPersEmpRol%ISOPEN THEN
        CLOSE C_GetContratoPorPersEmpRol;
    END IF;
    
    IF C_GetDetParametro%ISOPEN THEN
        CLOSE C_GetDetParametro;
    END IF;

    IF C_GetListaDatos%ISOPEN THEN
        CLOSE C_GetListaDatos;
    END IF;
    
    OPEN  C_GetDetParametro(Lv_NombreParamCabCliente,Lv_DescParamMsjValidaProd,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
    FETCH C_GetDetParametro INTO Lc_MsjValidaProd;
    CLOSE C_GetDetParametro;
    
    OPEN  C_GetDetParametro(Lv_NombreParamCabCliente,Lv_DescParamMsjContrato,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
    FETCH C_GetDetParametro INTO Lc_MsjContrato;
    CLOSE C_GetDetParametro;
    
    OPEN  C_GetDetParametro(Lv_NombreParamCabCliente,Lv_DescParamMsjServicioInt,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
    FETCH C_GetDetParametro INTO Lc_MsjServicioInt;
    CLOSE C_GetDetParametro; 
    
    Ln_IdPersonaRol := DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.F_VALIDA_CLIENTE(Ln_IdPersona,Lv_CodEmpresa); 
    
    IF Ln_IdPersonaRol IS NOT NULL THEN

      OPEN  C_GetListaDatos(Lv_NombreParamCabCliente,Lv_DescParamEstadoContrato,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
      FETCH C_GetListaDatos INTO Lv_EstadoContrato;
      CLOSE C_GetListaDatos;
      
      OPEN  C_GetContratoPorPersEmpRol(Ln_IdPersonaRol,Lv_NombreParamCabCliente,Lv_DescParamEstadoContrato,Lv_TipoProceso); 
      FETCH C_GetContratoPorPersEmpRol INTO Ln_IdContrato;
      CLOSE C_GetContratoPorPersEmpRol;
      
      IF Ln_IdContrato IS NULL THEN 
          Pv_Mensaje := REPLACE(Lc_MsjContrato.VALOR1,'ESTADO_CONTRATO',Lv_EstadoContrato);
          RAISE Le_Errors;
      END IF;
      
      OPEN  C_GetDetParametro(Lv_NombreParamCabCliente,Lv_DescParamDeuda,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
      FETCH C_GetDetParametro INTO Lc_ValorDeuda;
      CLOSE C_GetDetParametro;
      
      OPEN  C_GetDetParametro(Lv_NombreParamCabCliente,Lv_DescParamCantFactVenc,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
      FETCH C_GetDetParametro INTO Lc_CantLimiteFactVencidas;
      CLOSE C_GetDetParametro;

      OPEN  C_GetListaDatos(Lv_NombreParamCabCliente,Lv_DescParamEstadoOS,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
      FETCH C_GetListaDatos INTO Lv_EstadoServicio;
      CLOSE C_GetListaDatos;
      
      OPEN C_GetServicioInternet(Ln_IdPunto,Lv_NombreParamCabCliente,Lv_DescParamEstadoOS,Lv_TipoProceso);
      FETCH C_GetServicioInternet INTO Ln_Servicio;
      CLOSE C_GetServicioInternet; 
      
      IF Ln_Servicio IS NULL THEN 
          Pv_Mensaje := REPLACE(Lc_MsjServicioInt.VALOR1,'ESTADO_SERV',Lv_EstadoServicio);
          RAISE Le_Errors;
      END IF;

      Ln_Saldo := DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.F_GET_SALDO_CLIENTE(Ln_IdPersonaRol);
      
      DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.P_GET_CANT_FACT_VENCIDAS(Ln_IdPersonaRol, 
                                                                          Lv_CodEmpresa, 
                                                                          Lv_TipoProceso, 
                                                                          Ln_CantFactVencidasCliente); 
      
      /* Se valida que el cliente posea deuda mayor al valor parametrizado de deuda.
        Se valida la cantidad de facturas vencidas del cliente con la cantidad límite de facturas parametrizada */
      IF Ln_Saldo > Lc_ValorDeuda.VALOR1 AND (Ln_CantFactVencidasCliente > Lc_CantLimiteFactVencidas.VALOR1) THEN
          Pv_Mensaje := Lc_MsjValidaProd.VALOR1
                        ||' '||REPLACE(Lc_MsjValidaProd.VALOR2,'SALDO',Ln_Saldo)
                        ||' '||REPLACE(Lc_MsjValidaProd.VALOR3,'CANTFAC',Ln_CantFactVencidasCliente);
          RAISE Le_Errors;
      END IF;

    END IF;
    
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacción exitosa';
    
  EXCEPTION
  WHEN Le_Errors THEN
        Pv_Status := 'ERROR';
  WHEN OTHERS THEN
    Pv_Status  := 'ERROR';
    Pv_Mensaje := SQLERRM;
    
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNCK_VALIDACIONES_FORMA_PAGO', 
                                         'DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.P_VALIDA_PRODUCTO_ADICIONAL', 
                                         'ERROR_STACK: '||DBMS_UTILITY.FORMAT_ERROR_STACK||' ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'DB_FINANCIERO',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_VALIDA_PRODUCTO_ADICIONAL;
  --
  
  PROCEDURE P_VALIDA_CAMBIO_PLAN_UP(Pcl_Request IN CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2)
  IS
    --
    CURSOR C_GetDetParametro(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                             Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                             Cv_Estado              DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
        DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APD.DESCRIPCION      = Cv_DescripcionDetParam
      AND APD.EMPRESA_COD      = Cv_EmpresaCod
      AND APD.ESTADO           = Cv_Estado
      AND APC.ESTADO           = Cv_Estado
      AND APD.VALOR7           = Cv_TipoProceso; 

    CURSOR C_GetValorCambioPlanF(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE, 
                                 Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                 Cv_Estado              DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE)
    IS
      SELECT APD.*
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
        DB_GENERAL.ADMI_PARAMETRO_DET APD 
      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND APD.DESCRIPCION      = Cv_DescripcionDetParam
      AND APD.EMPRESA_COD      = Cv_EmpresaCod
      AND APD.ESTADO           = Cv_Estado
      AND APC.ESTADO           = Cv_Estado;                                 
    
    Le_Errors                   EXCEPTION;
    Ln_IdPersona                NUMBER;
    Ln_ValorPlanActual          NUMBER;
    Ln_IdPlanCabNuevo           NUMBER;
    Ln_ValorPlanNuevo           NUMBER;
    Ln_IdPersonaRol             NUMBER;
    Ln_Servicio                 NUMBER;
    Ln_Saldo                    NUMBER;
    Ln_CantFactVencidasCliente  NUMBER;
    Lv_CodEmpresa               VARCHAR2(10);
    Lv_TipoProceso              VARCHAR2(100);
    Lv_NombreParamCabCliente    VARCHAR2(100) := 'PARAM_CLIENTE_VALIDACIONES';
    Lv_DescParamMsjCambioPlanUp VARCHAR2(800) := 'MSJ_VALIDACION_CAMBIO_PLAN_UPGRADE'; 
    Lv_DescParamDeuda           VARCHAR2(100) := 'VALOR_DEUDA';
    Lv_DescParamCantFactVenc    VARCHAR2(100) := 'CANTIDAD_FACT_VENCIDAS';
    Lv_EstadoActivo             VARCHAR2(20)  := 'Activo';
    Lv_AplicaValidacionPlanUp   VARCHAR2(2)   := 'NO';
    Lc_MsjValidaCambioPlan      C_GetDetParametro%ROWTYPE;
    Lc_CantLimiteFactVencidas   C_GetDetParametro%ROWTYPE;
    Lc_ValorDeuda               C_GetDetParametro%ROWTYPE;
    Lv_NomParamCambioPlanTarea  VARCHAR2(100) := 'USR_CAMBIO_PLAN_TAREA_AUTO';
    Lv_DescParamCambioPlanF     VARCHAR2(100) := 'VALOR_TOP_DOWN_CAMBIO_PLAN_F_A1';
    Lc_ValorParamCambioPlanUp   C_GetValorCambioPlanF%ROWTYPE; 
    
    --
  BEGIN
    --
    APEX_JSON.PARSE(Pcl_Request); 
    
    Lv_CodEmpresa      := APEX_JSON.get_varchar2(p_path => 'idEmpresa'); 
    Ln_IdPersona       := APEX_JSON.get_number(p_path => 'idPersona'); 
    Ln_ValorPlanActual := APEX_JSON.get_number(p_path => 'precioPlanActual');
    Ln_IdPlanCabNuevo  := APEX_JSON.get_number(p_path => 'idPlanCabNuevo');
    Lv_TipoProceso     := APEX_JSON.get_varchar2(p_path => 'tipoProceso');
    
    IF Lv_CodEmpresa IS NULL THEN
        Pv_Mensaje := 'El parámetro Lv_CodEmpresa esta vacío';
        RAISE Le_Errors;
    END IF;
    
    IF Ln_IdPersona IS NULL THEN
        Pv_Mensaje := 'El parámetro Ln_IdPersona esta vacío';
        RAISE Le_Errors;
    END IF;
    
    IF Ln_ValorPlanActual IS NULL THEN
        Pv_Mensaje := 'El parámetro Ln_ValorPlanActual esta vacío';
        RAISE Le_Errors;
    END IF;
    
    IF Ln_IdPlanCabNuevo IS NULL THEN
        Pv_Mensaje := 'El parámetro Ln_IdPlanCabNuevo esta vacío';
        RAISE Le_Errors;
    END IF;

    IF Lv_TipoProceso IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_TipoProceso esta vacío';
      RAISE Le_Errors;
    END IF;
    --
    
    IF C_GetDetParametro%ISOPEN THEN
        CLOSE C_GetDetParametro;
    END IF;

    IF C_GetValorCambioPlanF%ISOPEN THEN
        CLOSE C_GetValorCambioPlanF;
    END IF;
    
    --Se obtiene valor parametrizado por cambio de plan upgrade
    OPEN  C_GetValorCambioPlanF(Lv_NomParamCambioPlanTarea,Lv_DescParamCambioPlanF,Lv_CodEmpresa,Lv_EstadoActivo); 
    FETCH C_GetValorCambioPlanF INTO Lc_ValorParamCambioPlanUp;
    CLOSE C_GetValorCambioPlanF;
    
    Ln_ValorPlanNuevo := DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.F_GET_VALOR_PLAN_POR_EMPRESA(Ln_IdPlanCabNuevo, Lv_CodEmpresa);
    
    --Se valida plan nuevo, plan actual y valor de definición upgrade para determinar si cumple como cambio de plan upgrade
    IF (Ln_ValorPlanNuevo - Ln_ValorPlanActual) >= Lc_ValorParamCambioPlanUp.VALOR1 THEN 
        Lv_AplicaValidacionPlanUp := 'SI';
    END IF;
    
    IF Lv_AplicaValidacionPlanUp = 'SI' THEN 
        Ln_IdPersonaRol := DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.F_VALIDA_CLIENTE(Ln_IdPersona,Lv_CodEmpresa); 
        
        IF Ln_IdPersonaRol IS NOT NULL THEN 

          OPEN  C_GetDetParametro(Lv_NombreParamCabCliente,Lv_DescParamMsjCambioPlanUp,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
          FETCH C_GetDetParametro INTO Lc_MsjValidaCambioPlan;
          CLOSE C_GetDetParametro;
          
          OPEN  C_GetDetParametro(Lv_NombreParamCabCliente,Lv_DescParamDeuda,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
          FETCH C_GetDetParametro INTO Lc_ValorDeuda;
          CLOSE C_GetDetParametro;
          
          OPEN  C_GetDetParametro(Lv_NombreParamCabCliente,Lv_DescParamCantFactVenc,Lv_CodEmpresa,Lv_EstadoActivo,Lv_TipoProceso); 
          FETCH C_GetDetParametro INTO Lc_CantLimiteFactVencidas;
          CLOSE C_GetDetParametro;
          
          Ln_Saldo := DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.F_GET_SALDO_CLIENTE(Ln_IdPersonaRol);
          
          DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.P_GET_CANT_FACT_VENCIDAS(Ln_IdPersonaRol, 
                                                                              Lv_CodEmpresa, 
                                                                              Lv_TipoProceso, 
                                                                              Ln_CantFactVencidasCliente); 

          /* Se valida que el cliente posea deuda mayor al valor parametrizado de deuda.
            Se valida la cantidad de facturas vencidas del cliente con la cantidad límite de facturas parametrizada */
          IF Ln_Saldo > Lc_ValorDeuda.VALOR1 AND (Ln_CantFactVencidasCliente > Lc_CantLimiteFactVencidas.VALOR1) THEN
              Pv_Mensaje := Lc_MsjValidaCambioPlan.VALOR1
                            ||' '||REPLACE(Lc_MsjValidaCambioPlan.VALOR2,'SALDO',Ln_Saldo)
                            ||' '||REPLACE(Lc_MsjValidaCambioPlan.VALOR3,'CANTFAC',Ln_CantFactVencidasCliente);
              RAISE Le_Errors;
          END IF;

        END IF;  
    
    END IF;
    
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacción exitosa';
    
  EXCEPTION
  WHEN Le_Errors THEN
        Pv_Status := 'ERROR';
  WHEN OTHERS THEN
    Pv_Status  := 'ERROR';
    Pv_Mensaje := SQLERRM;
    
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNCK_VALIDACIONES_FORMA_PAGO', 
                                         'DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.P_VALIDA_CAMBIO_PLAN_UP', 
                                         'ERROR_STACK: '||DBMS_UTILITY.FORMAT_ERROR_STACK||' ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'DB_FINANCIERO',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_VALIDA_CAMBIO_PLAN_UP;
  --

    PROCEDURE P_VALIDA_PERFIL_POR_USUARIO(Pcl_Request IN CLOB,
                                        Pv_Status   OUT VARCHAR2,
                                        Pv_Mensaje  OUT VARCHAR2)
  IS
  --
    CURSOR C_GetPerfilPorUsr(Cv_Login               VARCHAR2,
                             Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                             Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                             Cv_Estado              DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_TipoProceso         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE)
    IS
      SELECT COUNT(SP.ID_PERFIL) 
      FROM DB_SEGURIDAD.SIST_PERFIL     SP,
       DB_SEGURIDAD.SEGU_PERFIL_PERSONA SPP,
       DB_SEGURIDAD.INFO_PERSONA        IP
      WHERE SP.ID_PERFIL   = SPP.PERFIL_ID
      AND SPP.PERSONA_ID   = IP.ID_PERSONA
      AND IP.LOGIN         = Cv_Login
      AND SP.NOMBRE_PERFIL IN (SELECT APD.VALOR1
                               FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                DB_GENERAL.ADMI_PARAMETRO_DET APD
                               WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
                               AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
                               AND APD.DESCRIPCION      = Cv_DescripcionDetParam
                               AND APD.EMPRESA_COD      = Cv_EmpresaCod
                               AND APD.ESTADO           = Cv_Estado
                               AND APC.ESTADO           = Cv_Estado
                               AND APD.VALOR7           = Cv_TipoProceso);
      

    Le_Errors                EXCEPTION;
    Lv_IpCreacion            VARCHAR2(16)  := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_NombreParamCabCliente VARCHAR2(100) := 'PARAM_CLIENTE_VALIDACIONES';
    Lv_DesDetParamPerfil     VARCHAR2(100) := 'PERFIL';
    Lv_EstadoActivo          VARCHAR2(100) := 'Activo';
    Lv_ExistePerfil          VARCHAR2(2)   := 'NO';
    Lv_Login                 VARCHAR2(500);
    Lv_TipoProceso           VARCHAR2(500);
    Lv_CodEmpresa            VARCHAR2(10);
    Ln_Valor                 NUMBER;

  BEGIN
    
    APEX_JSON.PARSE(Pcl_Request); 

    Lv_CodEmpresa  := APEX_JSON.get_varchar2(p_path => 'idEmpresa'); 
    Lv_Login       := APEX_JSON.get_varchar2(p_path => 'usrCreacion'); 
    Lv_TipoProceso := APEX_JSON.get_varchar2(p_path => 'tipoProceso');
    
    IF Lv_CodEmpresa IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_CodEmpresa esta vacío';
      RAISE Le_Errors;
    END IF;
    
    IF Lv_Login IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_Login esta vacío';
      RAISE Le_Errors;
    END IF;

    IF Lv_TipoProceso IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_TipoProceso esta vacío';
      RAISE Le_Errors;
    END IF;
    --

    IF C_GetPerfilPorUsr%ISOPEN THEN
      CLOSE C_GetPerfilPorUsr;
    END IF;

    OPEN C_GetPerfilPorUsr(
            Lv_Login,
            Lv_NombreParamCabCliente,
            Lv_DesDetParamPerfil,
            Lv_CodEmpresa,
            Lv_EstadoActivo,
            Lv_TipoProceso);

    FETCH C_GetPerfilPorUsr INTO Ln_Valor;
    CLOSE C_GetPerfilPorUsr;

    IF Ln_Valor > 0 THEN 
        Lv_ExistePerfil := 'SI';
    END IF;

    Pv_Status  := 'OK';
    Pv_Mensaje := Lv_ExistePerfil; 

  EXCEPTION
  WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
  WHEN OTHERS THEN 
    Pv_Status  := 'ERROR';
    Pv_Mensaje := SQLERRM;
    
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'DB_FINANCIERO.FNCK_VALIDACIONES_FORMA_PAGO.P_VALIDA_PERFIL_POR_USUARIO', 
                                         'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         'DB_FINANCIERO',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));                                     

  END P_VALIDA_PERFIL_POR_USUARIO; 
  --

  FUNCTION F_GET_VALOR_PLAN_POR_EMPRESA(Fn_IdPlan     IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE, 
                                        Fv_CodEmpresa IN VARCHAR2)
  RETURN NUMBER 
  IS
    CURSOR C_getValorPlan(Cn_IdPlan     NUMBER,
                          Cv_CodEmpresa VARCHAR2) 
    IS
      SELECT SUM(ipd.CANTIDAD_DETALLE*ipd.PRECIO_ITEM) VALOR_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB  IPC,
        DB_COMERCIAL.INFO_PLAN_DET  IPD 
      WHERE IPD.PLAN_ID   = IPC.ID_PLAN
      AND IPC.ID_PLAN     = Cn_IdPlan
      AND IPC.EMPRESA_COD = Cv_CodEmpresa
      AND IPC.ESTADO      = 'Activo'
      AND IPD.ESTADO      = 'Activo';
    
    Ln_ValorPlan DB_COMERCIAL.INFO_PLAN_DET.PRECIO_ITEM%TYPE := 0;
     
  BEGIN
      
    IF C_getValorPlan%ISOPEN THEN
      CLOSE C_getValorPlan;
    END IF;
        
    OPEN  C_getValorPlan(Fn_idPlan,Fv_CodEmpresa);
    FETCH C_getValorPlan INTO Ln_ValorPlan;
    CLOSE C_getValorPlan;
    
    RETURN Ln_ValorPlan;

  END F_GET_VALOR_PLAN_POR_EMPRESA;
  --

END FNCK_VALIDACIONES_FORMA_PAGO;
/
