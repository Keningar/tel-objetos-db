  
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
  */
  PROCEDURE  P_VALIDA_FACTURAS(Pcl_Request IN CLOB, Pv_Mensaje OUT VARCHAR2, Pv_Status OUT VARCHAR2);

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
    
    --Costo query 138
    CURSOR C_GetSaldoPuntos(Cv_IdPersonaRol NUMBER) IS  
      SELECT SUM(VISTA.SALDO)
      FROM  DB_COMERCIAL.INFO_PUNTO IP,
        DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO VISTA 
      WHERE IP.PERSONA_EMPRESA_ROL_ID = Cv_IdPersonaRol
      AND IP.ID_PUNTO                 = VISTA.PUNTO_ID ; 
      
    --Costo query 6    
    CURSOR C_GetParametroDet(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                             Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT DET.VALOR1, DET.VALOR2, DET.VALOR3
        FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
          DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
        AND DET.DESCRIPCION      = Cv_DescripcionDetParam
        AND DET.ESTADO           = Cv_EstadoActivo
        AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND CAB.ESTADO           = Cv_EstadoActivo
        AND DET.EMPRESA_COD      = Cv_EmpresaCod;    
    
    Lv_CodEmpresa           VARCHAR2(50);
    Ln_IdPersona            NUMBER;
    Ln_IdPersonaRol         NUMBER;
    Ln_SaldoTotal           NUMBER;
    Lc_MensajeValidaSaldo   C_GetParametroDet%ROWTYPE;
    Le_Errors               EXCEPTION;
    Lv_NombreParamCabFp     VARCHAR2(100) := 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS';
    Lv_ParamMsjValidaSaldo  VARCHAR2(100) := 'MENSAJES_VALIDACION_SALDO';
    Lv_EstadoActivo         VARCHAR2(100) := 'Activo';

  BEGIN

    APEX_JSON.PARSE(Pcl_Request); 
    
    Lv_CodEmpresa := APEX_JSON.get_varchar2(p_path => 'idEmpresa'); 
    Ln_IdPersona  := APEX_JSON.get_number(p_path => 'idPersona'); 
    
    IF Lv_CodEmpresa IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_CodEmpresa esta vacío';
      RAISE Le_Errors;
    END IF;
    
    IF Ln_IdPersona IS NULL THEN
      Pv_Mensaje := 'El parámetro Ln_IdPersona esta vacío';
      RAISE Le_Errors;
    END IF;
    
    IF C_GetPersEmpRol%ISOPEN THEN
      CLOSE C_GetPersEmpRol;
    END IF;
    
    IF C_GetSaldoPuntos%ISOPEN THEN
      CLOSE C_GetSaldoPuntos;
    END IF;
    
    IF C_GetParametroDet%ISOPEN THEN
      CLOSE C_GetParametroDet;
    END IF;
    
    OPEN  C_GetPersEmpRol(Ln_IdPersona, 'Cliente', Lv_CodEmpresa ); 
    FETCH C_GetPersEmpRol INTO Ln_IdPersonaRol;  
    CLOSE C_GetPersEmpRol; 
    
    OPEN  C_GetParametroDet(Lv_NombreParamCabFp, Lv_ParamMsjValidaSaldo, Lv_EstadoActivo, Lv_CodEmpresa ); 
    FETCH C_GetParametroDet INTO Lc_MensajeValidaSaldo;  
    CLOSE C_GetParametroDet;
    
    IF Ln_IdPersonaRol IS NOT NULL THEN
        OPEN C_GetSaldoPuntos(Ln_IdPersonaRol); 
        FETCH C_GetSaldoPuntos INTO Ln_SaldoTotal;  
        CLOSE C_GetSaldoPuntos ; 

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
                                  Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
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
        AND DET.EMPRESA_COD      = Cv_EmpresaCod;    

    --Costo query 6    
    CURSOR C_GetParametroDet(Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                             Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                             Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                             Cv_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT DET.VALOR1, DET.VALOR2, DET.VALOR3, DET.VALOR4, DET.VALOR5
        FROM DB_GENERAL.ADMI_PARAMETRO_DET DET,
          DB_GENERAL.ADMI_PARAMETRO_CAB CAB
        WHERE CAB.ID_PARAMETRO   = DET.PARAMETRO_ID
        AND DET.DESCRIPCION      = Cv_DescripcionDetParam
        AND DET.ESTADO           = Cv_EstadoActivo
        AND CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND CAB.ESTADO           = Cv_EstadoActivo
        AND DET.EMPRESA_COD      = Cv_EmpresaCod;       

    --Costo query 13
    CURSOR C_GetFacturasRecurrentes(Cv_EmpresaCod          VARCHAR2, 
                                    Cv_IdPersonaRol        NUMBER, 
                                    Cn_CantidadDocs        NUMBER,
                                    Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                    Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                    Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE )
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
                                              AND DET.EMPRESA_COD      = Cv_EmpresaCod)
            AND IDFC.RECURRENTE = 'S' 
            ORDER BY IDFC.FE_CREACION DESC 
          ) TABLA WHERE ROWNUM <= Cn_CantidadDocs ; 

    --Costo query 13      
    CURSOR C_GetCantFactRecurrentes(Cv_EmpresaCod          VARCHAR2, 
                                    Cv_IdPersonaRol        NUMBER, 
                                    Cn_CantidadDocs        NUMBER,
                                    Cv_NombreParametro     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                    Cv_DescripcionDetParam DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                    Cv_EstadoActivo        DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE  )
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
                                              AND DET.EMPRESA_COD      = Cv_EmpresaCod)
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
    Lv_NombreParamCabFp         VARCHAR2(100) := 'PARAM_FLUJO_VALIDACIONES_FORMAS_PAGOS';
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

  BEGIN

    APEX_JSON.PARSE(Pcl_Request); 

    Lv_CodEmpresa := APEX_JSON.get_varchar2(p_path => 'idEmpresa'); 
    Ln_IdPersona  := APEX_JSON.get_number(p_path => 'idPersona'); 
    
    IF Lv_CodEmpresa IS NULL THEN
      Pv_Mensaje := 'El parámetro Lv_CodEmpresa esta vacío';
      RAISE Le_Errors;
    END IF;
    
    IF Ln_IdPersona IS NULL THEN
      Pv_Mensaje := 'El parámetro Ln_IdPersona esta vacío';
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
    
    OPEN  C_GetParametroDet(Lv_NombreParamCabFp, Lv_ParamMsjValidaFact, Lv_EstadoActivo, Lv_CodEmpresa); 
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
    
        OPEN  C_GetParamDetExcluyeFP(Lv_NombreParamCabFp, Lv_DescDetParamExcFP, Lv_EstadoActivo, 
                                      Lc_GetContratoPorPersEmpRol.FORMA_PAGO_ID, Lv_CodEmpresa); 
        FETCH C_GetParamDetExcluyeFP INTO Lc_GetParamDetExcluyeFP;  
        CLOSE C_GetParamDetExcluyeFP;  

        IF Lc_GetParamDetExcluyeFP.VALOR2 IS NOT NULL THEN 
            Pv_Status    := 'OK';
            Pv_Mensaje   := 'Transacción exitosa';
        ELSE 
          --Se obtiene la cantidad parametrizada de validación facturas recurrentes. 
          OPEN  C_GetParametroDet(Lv_NombreParamCabFp, Lv_DesDetParamValidaFact, Lv_EstadoActivo, Lv_CodEmpresa); 
          FETCH C_GetParametroDet INTO Lc_ValidacionFactura;  
          CLOSE C_GetParametroDet;   
  
          --Obtiene la cantidad de facturas recurrentes del cliente
          OPEN  C_GetCantFactRecurrentes(Lv_CodEmpresa, Ln_IdPersonaRol, Lc_ValidacionFactura.VALOR2, 
                                        Lv_NombreParamCabFp, Lv_DesDetParamTipoDoc, Lv_EstadoActivo); 
          FETCH C_GetCantFactRecurrentes INTO Ln_CantidadFacturas;  
          CLOSE C_GetCantFactRecurrentes;   
  
          IF Ln_CantidadFacturas >= Lc_ValidacionFactura.VALOR2 AND Ln_CantidadFacturas != 0 THEN
            --Se recorre las facturas a revisar
            FOR Facturas IN C_GetFacturasRecurrentes(Lv_CodEmpresa, Ln_IdPersonaRol, Lc_ValidacionFactura.VALOR2, 
                                                    Lv_NombreParamCabFp, Lv_DesDetParamTipoDoc, Lv_EstadoActivo) LOOP
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


END FNCK_VALIDACIONES_FORMA_PAGO; 
 
/
