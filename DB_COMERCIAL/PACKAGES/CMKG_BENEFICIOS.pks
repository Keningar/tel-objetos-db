CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_BENEFICIOS AS 

 /**
  * Documentaci�n para TYPE 'Lr_RegistrosSolicitudes'.
  *  
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 12-03-2021
  */
  TYPE Lr_RegistrosSolicitudes 
  IS RECORD (LOGIN                DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
             ID_DETALLE_SOLICITUD DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
             SERVICIO_ID          DB_COMERCIAL.INFO_DETALLE_SOLICITUD.SERVICIO_ID%TYPE,
             PRECIO_DESCUENTO     DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PRECIO_DESCUENTO%TYPE,
             PORCENTAJE_DESCUENTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE,
             VALOR_DESCUENTO      DB_COMERCIAL.INFO_SERVICIO.VALOR_DESCUENTO%TYPE,
             ESTADO               DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE,
             NOMBRE_MOTIVO        DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE,
             ESTADO_SERVICIO      DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
             CICLO_FACTURACION    VARCHAR2(100));

 /**
  * Documentaci�n para TYPE 'T_RegistrosSolicitudes'.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 12-03-2021
  */                     
  TYPE T_RegistrosSolicitudes IS TABLE OF Lr_RegistrosSolicitudes INDEX BY PLS_INTEGER;
  
 /**
  * Documentacion para la funci�n F_SUM_PRECIO_ITEM_SERV_PLAN
  *
  * Funci�n que obtiene la sumatoria de los precios de los detalles de Productos de un Plan correspondiente a un servicio, 
  * se sumariza los detalles de productos que se encuentren parametrizados
  * por "PARAM_FLUJO_ADULTO_MAYOR" detalle "APLICA_PRODUCTO_DESCUENTO_ADULTO_MAYOR" en S.
  *
  * @param  Fn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @param  Fv_NombreParametro  IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE
  * @param  Fv_Estado           IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
  * @param  Fv_DescParametroDet IN DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE
  *
  * Costo query C_SumPrecioItemServPlan: 8
  *
  * @return Retorna el valor de la sumatoria.
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 16-03-2021
  */
  FUNCTION F_SUM_PRECIO_ITEM_SERV_PLAN(Fn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Fv_NombreParametro  IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                       Fv_Estado           IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                       Fv_DescParametroDet IN DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                       Fv_EmpresaCod       IN DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
  RETURN NUMBER;       

 /**
  * Documentaci�n para procedimiento P_RECALCULO.
  * Procedimiento que permite realizar el rec�lculo de los valores para las solicitudes de Beneficio 3era Edad / Adulto Mayor 
  * � Cliente con Discapacidad. Permite la funcionalidad de ejecuci�n por tipo de proceso ya sea Individual o Masivo.
  * - Individual: Permite procesar el servicio enviado por par�metro la solicitud que posea Adulto Mayor o Dsicapacidad.
  * - Masivo: Permite procesar todas las solicitudes que posea beneficio de Adulto Mayor.
  *
  * Costo query C_Parametros: 3
  * Costo query C_GetParamTipoProceso: 3
  * Costo query C_ObtieneSumProducto: 5
  * Costo query C_GetCaracteristica: 2
  * Costo query C_GetIdCaractSolicitud: 4
  * Costo query Principal (Lv_Consulta): 527
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 12-03-2021
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 26-08-2021 - Se modifica c�digo para validar los beneficios de adulto mayor por flujos de procesos. Se obtiene el
  *                           flujo de proceso a partir del nombre de motivo a procesarse.
  *                           Se realiza el c�lculo del valor descuento por los flujos de adulto mayor para setear los valores en 
  *                           la solicitud.
  *
  * Costo query C_GetParamCategPlanBasico: 3
  * Costo query C_GetTipoCategoriaPlan: 8
  * Costo query Principal (Lv_Consulta): 681
  */   
  PROCEDURE P_RECALCULO(Pv_EmpresaCod     IN DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                        Pv_PrefijoEmpresa IN VARCHAR2,
                        Pv_Usuario        IN VARCHAR2,     
                        Pv_EmailUsuario   IN VARCHAR2,
                        Pn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                        Pv_TipoProceso    IN VARCHAR2,
                        Pv_Mensaje        OUT VARCHAR2,
                        Pv_MsnError       OUT VARCHAR2);

 /**
  * Documentaci�n para procedimiento P_APLICA_RECALCULO.
  * Procedimiento que permite obtener el valor de resultado 'S' o 'N' para aplicar o no el proceso de rec�lculo. 
  * Se realiza validaciones para determinar si los detalles parametrizados por Adulto Mayor ha sido actualizado en la base. 
  * Detalles de par�metros a verificar son: PORCENTAJE_DESC_ADULTO_MAYOR,SALARIO_BASICO_UNIFICADO,PORCENTAJE_VALOR_RESIDENCIAL_BASICO.
  *
  * PARAMETROS:
  * @Param Pv_EmpresaCod      IN DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE 
  * @Param Pv_AplicaRecalculo OUT VARCHAR2
  *
  * Costo query C_Parametros: 3
  * Costo query C_ObtieneValorParamHist: 2
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 11-03-2021
  */   
  PROCEDURE P_APLICA_RECALCULO(Pv_EmpresaCod      IN  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                               Pv_AplicaRecalculo OUT VARCHAR2);
                                                                  
  /**
  * P_INSERT_INFO_SERVICIO_CARACT
  *
  * PROCEDIMIENTO QUE INSERTA EN LA TABLA DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
  *
  * PARAMETROS:
  * @Param Pr_InfoServicioCaract IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE 
  * @Param Pv_MsnError           OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)
  *
  * @author Alex Arreaga  <atarreaga@telconet.ec>
  * @version 1.0 15/03/2021
  */        
  PROCEDURE P_INSERT_INFO_SERVICIO_CARACT(Pr_InfoServicioCaract IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE,
                                          Pv_MsnError           OUT VARCHAR2); 

  /**
  * Documentacion para la funcion F_DESCUENTO_ADULTO_MAYOR
  * Funci�n que obtiene el valor de descuento a otorgarse por Beneficio 3era Edad/ Adulto Mayor
  *
  * @param  Fn_ParamPorcValorResidencial IN NUMBER,
  * @param  Fn_ParamSalarioBasico        IN NUMBER,
  * @param  Fn_ParamPorcDescAdultMayor   IN NUMBER,
  * @param  Fn_SumPrecioItem             IN NUMBER
  *
  * @return Retorna el valor de descuento a otorgarse
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 23-01-2021
  */
  FUNCTION F_DESCUENTO_ADULTO_MAYOR(Fn_ParamPorcValorResidencial IN NUMBER,
                                    Fn_ParamSalarioBasico        IN NUMBER,
                                    Fn_ParamPorcDescAdultMayor   IN NUMBER,
                                    Fn_SumPrecioItem             IN NUMBER)
  RETURN NUMBER;

  /** Documentacion para la funcion F_EDAD_PERSONA
  * Funci�n que obtiene la edad en a�os de una persona
  *
  * @param  Fn_IdPersona IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE  
  *
  * Costo Query C_GetEdadPersona: 3
  * @return Retorna la edad en a�os de una persona
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 22-02-2021
  */
  FUNCTION F_EDAD_PERSONA(Fn_IdPersona IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)                         
  RETURN NUMBER;

  /** Documentacion para la funcion F_PRECIO_PLAN_BASICO.
  * Funci�n que obtiene el valor del plan b�sico para 3era Edad.
  *
  * @param  Fv_DescCaracteristica IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE 
  * @param  Fv_Valor              IN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA.VALOR%TYPE
  *
  * Costo Query C_GetValorPlanBasico: 4
  * @return Retorna el precio del plan.
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 10-08-2021
  */
  FUNCTION F_PRECIO_PLAN_BASICO(Fv_DescCaracteristica IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Fv_Valor              IN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA.VALOR%TYPE,
                                Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)                         
  RETURN NUMBER; 

/*
* Funcion que sirve para obtener la discapacidad de la persona
* @author Jessenia Piloso <jpiloso@telconet.ec>
* @version 1.0 25-01-2023
* 
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE      Fn_IdServicio             id del servicio
* @return VARCHAR2                            Fv_esClienteDiscapacitado identifica si el cliente es Discapacitado
* 
*/
  FUNCTION F_GET_ES_CLIENTE_DISCAPACITADO(
    Fn_IdServicio      IN INFO_SERVICIO.ID_SERVICIO%TYPE,
    Fn_IdPersonaEmpRol  IN INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE)
  RETURN VARCHAR2;


END CMKG_BENEFICIOS;
/
CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_BENEFICIOS AS

  FUNCTION F_SUM_PRECIO_ITEM_SERV_PLAN(Fn_IdServicio       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Fv_NombreParametro  IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                       Fv_Estado           IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                       Fv_DescParametroDet IN DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                       Fv_EmpresaCod       IN DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
  RETURN NUMBER
  IS 
    CURSOR C_SumPrecioItemServPlan (Cn_IdServicio         DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Cv_NombreParametro    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                    Cv_EstadoActivo       DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                    Cv_AplicaProductoDesc DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                    Cv_EmpresaCod         DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS                          
    SELECT ROUND(SUM(PLAND.PRECIO_ITEM),2)
    FROM DB_COMERCIAL.INFO_SERVICIO ISER, DB_COMERCIAL.INFO_PLAN_CAB PLANC,
      DB_COMERCIAL.INFO_PLAN_DET PLAND, DB_COMERCIAL.ADMI_PRODUCTO PROD,
      DB_GENERAL.ADMI_PARAMETRO_CAB APCAB, DB_GENERAL.ADMI_PARAMETRO_DET APDET
    WHERE  ISER.PLAN_ID             = PLANC.ID_PLAN
    AND PLANC.ID_PLAN           = PLAND.PLAN_ID
    AND PLAND.PRODUCTO_ID       = PROD.ID_PRODUCTO
    AND APCAB.NOMBRE_PARAMETRO  = Cv_NombreParametro
    AND APDET.DESCRIPCION       = Cv_AplicaProductoDesc
    AND APCAB.ID_PARAMETRO      = APDET.PARAMETRO_ID
    AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(APDET.VALOR1,'^\d+')),0) = PROD.ID_PRODUCTO
    AND APDET.VALOR2            = 'S'
    AND APCAB.ESTADO            = Cv_EstadoActivo
    AND APDET.ESTADO            = Cv_EstadoActivo
    AND ISER.ID_SERVICIO        = Cn_IdServicio
    AND APDET.EMPRESA_COD       = Cv_EmpresaCod;                             

    Ln_SumPrecioItem                NUMBER:= 0;
    Lv_MsnError                     VARCHAR2 (2000);
    Lv_IpCreacion                   VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Le_Exception                    EXCEPTION;

  BEGIN    
    
    IF C_SumPrecioItemServPlan%ISOPEN THEN
      CLOSE C_SumPrecioItemServPlan;
    END IF;
    OPEN C_SumPrecioItemServPlan(Fn_IdServicio, 
                                 Fv_NombreParametro,
                                 Fv_Estado, 
                                 Fv_DescParametroDet,
                                 Fv_EmpresaCod);
        FETCH C_SumPrecioItemServPlan INTO Ln_SumPrecioItem;
    CLOSE C_SumPrecioItemServPlan; 
    --
    IF Ln_SumPrecioItem IS NULL THEN
      Lv_MsnError := 'Error al obtener la sumatoria. ';
      RAISE Le_Exception;
    END IF; 

    RETURN Ln_SumPrecioItem;

    EXCEPTION
      WHEN Le_Exception THEN 
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_BENEFICIOS.F_SUM_PRECIO_ITEM_SERV_PLAN',
                                             Lv_MsnError,
                                             'DB_COMERCIAL',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      WHEN OTHERS THEN
        Lv_MsnError := 'Error al obtener el valor de la sumatoria. -'
                       || SQLCODE || ' - ERROR_STACK: '
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_BENEFICIOS.F_SUM_PRECIO_ITEM_SERV_PLAN',
                                             Lv_MsnError,
                                             'DB_COMERCIAL',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        Ln_SumPrecioItem := 0;
        RETURN Ln_SumPrecioItem;
        
  END F_SUM_PRECIO_ITEM_SERV_PLAN;
  --
  
  PROCEDURE P_APLICA_RECALCULO(Pv_EmpresaCod      IN  DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                               Pv_AplicaRecalculo OUT VARCHAR2)
  IS
    CURSOR C_Parametros(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                        Cv_DescripParam    DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,  
                        Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                        Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS      
    SELECT DET.VALOR1 
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
      DB_GENERAL.ADMI_PARAMETRO_DET DET
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO             = Cv_EstadoActivo
    AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
    AND DET.DESCRIPCION        = Cv_DescripParam 
    AND DET.ESTADO             = Cv_EstadoActivo
    AND DET.EMPRESA_COD        = Cv_EmpresaCod;

    CURSOR C_ObtieneValorParamHist (Cv_DescripcionParamDet DB_GENERAL.ADMI_PARAMETRO_HIST.DESCRIPCION%TYPE,
                                    Cn_EmpresaCod          DB_GENERAL.ADMI_PARAMETRO_HIST.EMPRESA_COD%TYPE)
    IS
    SELECT VALOR1 
    FROM DB_GENERAL.ADMI_PARAMETRO_HIST 
    WHERE ID_PARAMETRO_HIST IN (SELECT MAX(ID_PARAMETRO_HIST) 
                                FROM DB_GENERAL.ADMI_PARAMETRO_HIST WHERE DESCRIPCION IN (Cv_DescripcionParamDet)
                                AND TRUNC(FE_CREACION_HIST) >= TRUNC(SYSDATE)
                                AND EMPRESA_COD             = Cn_EmpresaCod );

    Lv_NombreParametro          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PARAM_FLUJO_ADULTO_MAYOR';
    Lv_ParamSalarioBaseUnif     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE      := 'SALARIO_BASICO_UNIFICADO';
    Lv_ParamPorcDescResBasico   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE      := 'PORCENTAJE_VALOR_RESIDENCIAL_BASICO';
    Lv_ParamPorcDescAdultoMayor DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE      := 'PORCENTAJE_DESC_ADULTO_MAYOR';
    Lv_EstadoActivo             VARCHAR2(15)                                        := 'Activo';
    
    Lr_SBU                      C_ObtieneValorParamHist%ROWTYPE;
    Lr_PorcValorResid           C_ObtieneValorParamHist%ROWTYPE;
    Lr_PorcDescAdultoMayor      C_ObtieneValorParamHist%ROWTYPE;

    Ln_SalarioBaseUnificado     NUMBER;
    Ln_PorcDescResidBasico      NUMBER;
    Ln_PorcDescAdultoMayor      NUMBER;

  BEGIN
  
    IF C_Parametros%ISOPEN THEN
      CLOSE C_Parametros;
    END IF;

    IF C_ObtieneValorParamHist%ISOPEN THEN
      CLOSE C_ObtieneValorParamHist;
    END IF;

    --Obtenemos los valores de los detalles de la tabla DB_GENERAL.ADMI_PARAMETRO_DET.  
    OPEN  C_Parametros (Lv_NombreParametro, Lv_ParamSalarioBaseUnif, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Ln_SalarioBaseUnificado;
    CLOSE C_Parametros;

    OPEN  C_Parametros (Lv_NombreParametro, Lv_ParamPorcDescResBasico, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Ln_PorcDescResidBasico;
    CLOSE C_Parametros;

    OPEN  C_Parametros (Lv_NombreParametro, Lv_ParamPorcDescAdultoMayor, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Ln_PorcDescAdultoMayor;
    CLOSE C_Parametros;

    --Obtenemos los valores de los detalles de la tabla DB_GENERAL.ADMI_PARAMETRO_HIST.  
    OPEN  C_ObtieneValorParamHist (Lv_ParamSalarioBaseUnif, Pv_EmpresaCod);
    FETCH C_ObtieneValorParamHist INTO Lr_SBU;
    CLOSE C_ObtieneValorParamHist;

    OPEN  C_ObtieneValorParamHist (Lv_ParamPorcDescResBasico, Pv_EmpresaCod);
    FETCH C_ObtieneValorParamHist INTO Lr_PorcValorResid;
    CLOSE C_ObtieneValorParamHist;

    OPEN  C_ObtieneValorParamHist (Lv_ParamPorcDescAdultoMayor, Pv_EmpresaCod);
    FETCH C_ObtieneValorParamHist INTO Lr_PorcDescAdultoMayor;
    CLOSE C_ObtieneValorParamHist;

    --Se realiza la validaci�n si existi� un cambio en la tabla de par�metros historial para obtenter el valor modificado
    --caso contrario se env�a bandera que no existe cambio.
    IF Lr_SBU.VALOR1 IS NOT NULL OR Lr_PorcValorResid.VALOR1 IS NOT NULL OR Lr_PorcDescAdultoMayor.VALOR1 IS NOT NULL THEN
    
        IF (Ln_SalarioBaseUnificado != Lr_SBU.VALOR1                 AND Lr_SBU.VALOR1 IS NOT NULL)             OR
           (Ln_PorcDescResidBasico  != Lr_PorcValorResid.VALOR1      AND Lr_PorcValorResid.VALOR1 IS NOT NULL)  OR
           (Ln_PorcDescAdultoMayor  != Lr_PorcDescAdultoMayor.VALOR1 AND Lr_PorcDescAdultoMayor.VALOR1 IS NOT NULL) 
        THEN
            Pv_AplicaRecalculo := 'S';
        ELSE
            Pv_AplicaRecalculo := 'N';
        END IF;
        
    ELSE
        Pv_AplicaRecalculo := 'N';

    END IF;  

  EXCEPTION
    WHEN OTHERS THEN
      Pv_AplicaRecalculo := 'N';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_BENEFICIOS.P_APLICA_RECALCULO',
                                           'Error al obtener resultado para rec�lculo: ' || SQLCODE || ' - ERROR_STACK: '
                                             || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                                             || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  END P_APLICA_RECALCULO;
  --
  
  PROCEDURE P_RECALCULO(Pv_EmpresaCod     IN DB_COMERCIAL.INFO_EMPRESA_ROL.EMPRESA_COD%TYPE,
                        Pv_PrefijoEmpresa IN VARCHAR2,
                        Pv_Usuario        IN VARCHAR2, 
                        Pv_EmailUsuario   IN VARCHAR2,
                        Pn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                        Pv_TipoProceso    IN VARCHAR2,
                        Pv_Mensaje        OUT VARCHAR2,
                        Pv_MsnError       OUT VARCHAR2)
  IS
    CURSOR C_Parametros(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                        Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                        Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                        Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS      
    SELECT DET.VALOR1 
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
      DB_GENERAL.ADMI_PARAMETRO_DET DET
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO             = Cv_EstadoActivo
    AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
    AND DET.DESCRIPCION        = Cv_Descripcion
    AND DET.ESTADO             = Cv_EstadoActivo
    AND DET.EMPRESA_COD        = Cv_EmpresaCod;      

    CURSOR C_GetParamTipoProceso(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                 Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                 Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                 Cv_ValorParametro  DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                 Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS      
    SELECT DET.VALOR1, DET.VALOR6 
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
      DB_GENERAL.ADMI_PARAMETRO_DET DET
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO             = Cv_EstadoActivo
    AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
    AND DET.DESCRIPCION        = Cv_Descripcion
    AND DET.ESTADO             = Cv_EstadoActivo
    AND DET.VALOR1             = Cv_ValorParametro
    AND DET.EMPRESA_COD        = Cv_EmpresaCod;

    CURSOR C_ObtienePrecioVentaServ (Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
    SELECT ISERV.PRECIO_VENTA, ISERV.CANTIDAD
    FROM DB_COMERCIAL.INFO_SERVICIO ISERV
    WHERE ISERV.ID_SERVICIO    = Cn_IdServicio;  
            
    CURSOR C_GetCaracteristica(Cv_DescCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
    SELECT ID_CARACTERISTICA
    FROM DB_COMERCIAL.ADMI_CARACTERISTICA
    WHERE DESCRIPCION_CARACTERISTICA = Cv_DescCaract; 

    CURSOR C_GetIdCaractSolicitud(Cn_CaractId       DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                  Cn_DetSolicitudId DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
    IS
    SELECT ID_SOLICITUD_CARACTERISTICA
    FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
    WHERE CARACTERISTICA_ID  = Cn_CaractId
    AND DETALLE_SOLICITUD_ID = Cn_DetSolicitudId;  

    CURSOR C_GetParamCategPlanBasico(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                     Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                     Cv_EstadoActivo    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                     Cv_ValorParametro  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
                                     Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE )
    IS      
    SELECT DET.VALOR1, DET.VALOR3
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB, DB_GENERAL.ADMI_PARAMETRO_DET DET
    WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
    AND CAB.ESTADO             = Cv_EstadoActivo
    AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
    AND DET.DESCRIPCION        = Cv_Descripcion
    AND DET.ESTADO             = Cv_EstadoActivo
    AND DET.VALOR3             = Cv_ValorParametro
    AND DET.EMPRESA_COD        = Cv_EmpresaCod;

    CURSOR C_GetTipoCategoriaPlan(Cv_DescripcionCaract VARCHAR2,
                                  Cv_IdServicio        NUMBER)
    IS
    SELECT IPCARACT.VALOR
    FROM DB_COMERCIAL.INFO_SERVICIO ISER, DB_COMERCIAL.INFO_PLAN_CAB IPCAB,
     DB_COMERCIAL.INFO_PLAN_CARACTERISTICA IPCARACT, DB_COMERCIAL.ADMI_CARACTERISTICA AC
    WHERE ISER.PLAN_ID                 = IPCAB.ID_PLAN
     AND IPCARACT.PLAN_ID              = IPCAB.ID_PLAN
     AND IPCARACT.CARACTERISTICA_ID    = AC.ID_CARACTERISTICA
     AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
     AND ISER.ID_SERVICIO              = Cv_IdServicio;

    Lv_NombreParamDisc          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PARAM_FLUJO_SOLICITUD_DESC_DISCAPACIDAD';
    Lv_NombreParametro          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PARAM_FLUJO_ADULTO_MAYOR';
    Lv_ParamMotivoDisc          DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'MOTIVO_DESC_DISCAPACIDAD';
    Lv_ParamPorcDescDisc        DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'PORCENTAJE_DESCUENTO';
    Lv_ParamMotivoAdultoMayor   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'MOTIVO_DESC_ADULTO_MAYOR';
    Lv_ParamCalculoProducto     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'CALCULO_POR_PRODUCTO';
    Lv_ParamSalarioBaseUnif     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'SALARIO_BASICO_UNIFICADO';
    Lv_ParamPorcResidBasico     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'PORCENTAJE_VALOR_RESIDENCIAL_BASICO';
    Lv_ParamPorcDescAdultoMayor DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'PORCENTAJE_DESC_ADULTO_MAYOR';
    Lv_ParamFormDescAdultoMayor DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'FORMULA_DESC_ADULTO_MAYOR';
    Lv_ParamFormPlanBasico      DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'FORMULA_PLAN_BASICO';
    Lv_ParamEstadosSolicitud    DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'ESTADOS_SOLICITUD'; 
    Lv_ParamEstadosServicios    DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'ESTADOS_SERVICIO'; 
    Lv_ParamAplicaProdDesc      DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'APLICA_PRODUCTO_DESCUENTO_ADULTO_MAYOR';
    Lv_ParamMensajeServHist     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'MENSAJE_RECALCULO_HIST'; 
    Lv_ParamPlanesPermitidos    DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE   := 'TIPO_PLAN'; 
    Lv_ParamCodProducto         VARCHAR2(100)                                    := 'CODIGO_PRODUCTO'; 
    Lv_ParamTipoPersona         VARCHAR2(100)                                    := 'TIPO_PERSONA';
    Lv_ParamTipoProceso         VARCHAR2(100)                                    := 'TIPO_PROCESO';
    
    Lv_CaractIdAdultoMayor      DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE :='ID_DET_CARACT_ADULTO_MAYOR'; 
    Lv_CaractValorDescuento     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE :='VALOR_DESCUENTO';
    Lv_CaractDescTotalFact      DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE :='DESCUENTO TOTALIZADO FACT'; 
    Lv_TipoSolicitud            DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE      :='SOLICITUD DESCUENTO'; 
    Ln_IdDetCaractAdultoMayor   DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractValorDescuento   DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    
    Lr_InfoServicio             DB_COMERCIAL.INFO_SERVICIO%ROWTYPE;
    Lr_InfoDetalleSolicitud     DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_DetalleSolHistorial      DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lr_ServicioHistorial        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_InfoDetalleSolCaract     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE;
    Lr_InfoServicioCaract       DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE;
    Lrf_SolicBeneficios         SYS_REFCURSOR;
    Lc_InfoServicio             C_ObtienePrecioVentaServ%ROWTYPE;
    
    Lex_Exception               EXCEPTION;
    Le_Exception                EXCEPTION;
    Lv_EstadoActivo             VARCHAR2(20)   := 'Activo';
    Lv_IpCreacion               VARCHAR2(16)   := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_MsjResultado             VARCHAR2(500);
    Lv_MsnError                 VARCHAR2(500);
    Lv_ValorCalculoProducto     VARCHAR2(200);
    Lv_FormulaAdultoMayor       VARCHAR2(200);
    Lv_FormulaPlanBasico        VARCHAR2(200);
    Lv_ValorMensajeHist         VARCHAR2(500);
    Lv_MensajeHistorial         VARCHAR2(500);
    Lv_Consulta                 VARCHAR2(8000);
    Lv_CadenaQuery              VARCHAR2(8000);
    Lv_CadenaFrom               VARCHAR2(8000);
    Lv_CadenaWhere              VARCHAR2(8000); 
    Lv_MotivoAdultoMayor        VARCHAR2(200); 
    Lv_MotivoDiscapacidad       VARCHAR2(200);
    Lc_TipoProceso              C_GetParamTipoProceso%ROWTYPE;
    Ln_SumPrecioItem            NUMBER;
    Ln_ValorSBU                 NUMBER;
    Ln_ValorPorcResidBasico     NUMBER;
    Ln_ValorPorcDescAdultoMayor NUMBER;
    Ln_ValorTotalDescuento      NUMBER;
    Ln_ValorPorcDescDisc        NUMBER;
    Ln_IdServicioCaract         NUMBER;
    Ln_IdCaractDescTotalFact    NUMBER; 
    Ln_IdDetalleSolCaract       NUMBER; 
    Ln_ValorSolCaract           NUMBER; 
        
    La_RegistrosSolicitudes     T_RegistrosSolicitudes;  
    Ln_Limit                    CONSTANT PLS_INTEGER DEFAULT 5000; 
    Ln_Indx                     NUMBER;
    Ln_Indr                     NUMBER := 0;

    Lv_Directorio               VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador              VARCHAR2(1)     := ';';
    Lv_Remitente                VARCHAR2(100)   := 'telcos@telconet.ec'; 
    Lv_Asunto                   VARCHAR2(300);
    Lv_Cuerpo                   VARCHAR2(9999); 
    Lv_FechaReporte             VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo            VARCHAR2(150);
    Lv_NombreArchivoZip         VARCHAR2(250);
    Lv_Gzip                     VARCHAR2(100);
    Lv_Destinatario             VARCHAR2(500);
    Lc_GetAliasPlantilla        DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo               UTL_FILE.FILE_TYPE;

    Lc_TipoFlujoAdultoMayor       C_GetParamTipoProceso%ROWTYPE; 
    Lc_ParamCategoriaPlanBasico   C_GetParamCategPlanBasico%ROWTYPE; 
    Lv_ParamProcesoRecaculo       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE      := 'RECALCULO';
    Lv_ParamCategoriaPlan         DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'CATEGORIA_PLAN_ADULTO_MAYOR';
    Lv_ParamValorCategoria        DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE      := 'PLAN_BASICO'; 
    Lv_ParamPorcAdultoMayor       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PORCENTAJE_DESC_RESOLUCION_072021_ADULTO_MAYOR';
    Lv_DescCaractPlanAdultoMayor  VARCHAR2(100)                                  := 'TIPO_CATEGORIA_PLAN_ADULTO_MAYOR';
    Lv_TipoCategoriaPlan          VARCHAR2(100);
    Ln_PorcDescResolucion         NUMBER;
    Ln_ValorPlanBasico            NUMBER;
       
  BEGIN
    IF C_Parametros%ISOPEN THEN
      CLOSE C_Parametros;
    END IF;

    IF C_GetParamTipoProceso%ISOPEN THEN
        CLOSE C_GetParamTipoProceso;
    END IF;

    IF C_ObtienePrecioVentaServ%ISOPEN THEN
      CLOSE C_ObtienePrecioVentaServ;
    END IF; 
    
    IF C_GetCaracteristica%ISOPEN THEN
      CLOSE C_GetCaracteristica;
    END IF;

    IF C_GetIdCaractSolicitud%ISOPEN THEN
      CLOSE C_GetIdCaractSolicitud;
    END IF; 

    IF C_GetParamCategPlanBasico%ISOPEN THEN
      CLOSE C_GetParamCategPlanBasico;
    END IF; 
    
    IF C_GetTipoCategoriaPlan%ISOPEN THEN
      CLOSE C_GetTipoCategoriaPlan;
    END IF; 
    --

    OPEN C_Parametros(Lv_NombreParametro, Lv_ParamCalculoProducto, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Lv_ValorCalculoProducto;
      IF C_Parametros%NOTFOUND THEN
        Lv_MsnError := 'Error al recuperar el par�metro c�lculo por producto.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro, Lv_ParamFormPlanBasico, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Lv_FormulaPlanBasico;
      IF C_Parametros%NOTFOUND THEN
        Lv_MsnError := 'Error al recuperar el par�metro de f�rmula plan b�sico.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro, Lv_ParamFormDescAdultoMayor, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Lv_FormulaAdultoMayor;
      IF C_Parametros%NOTFOUND THEN
        Lv_MsnError := 'Error al recuperar el par�metro de f�rmula de adulto mayor.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro, Lv_ParamSalarioBaseUnif, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Ln_ValorSBU;
      IF C_Parametros%NOTFOUND THEN
        Lv_MsnError := 'Error al recuperar el par�metro de salario b�sico unificado.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro, Lv_ParamPorcResidBasico, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Ln_ValorPorcResidBasico;
      IF C_Parametros%NOTFOUND THEN
        Lv_MsnError := 'Error al recuperar el par�metro de porcentaje residencial b�sico.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros; 

    OPEN C_Parametros(Lv_NombreParametro, Lv_ParamPorcDescAdultoMayor, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Ln_ValorPorcDescAdultoMayor;
      IF C_Parametros%NOTFOUND THEN
        Lv_MsnError := 'Error al recuperar el par�metro de porcentaje descuento adulto mayor.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro, Lv_ParamMensajeServHist, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Lv_ValorMensajeHist;
      IF C_Parametros%NOTFOUND THEN
        Lv_MsnError := 'Error al recuperar el mensaje para el historial del servicio.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;  
    
    OPEN C_Parametros(Lv_NombreParametro, Lv_ParamMotivoAdultoMayor, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Lv_MotivoAdultoMayor;
      IF C_Parametros%NOTFOUND THEN
            Lv_MsnError := 'Error al recuperar el par�metro de Beneficio 3era Edad / Adulto Mayor.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;
    
    OPEN C_Parametros(Lv_NombreParamDisc, Lv_ParamMotivoDisc, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Lv_MotivoDiscapacidad;
      IF C_Parametros%NOTFOUND THEN
        Lv_MsnError := 'Error al recuperar el par�metro de Cliente con Discapacidad.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;
    --
    
    OPEN C_GetCaracteristica(Lv_CaractIdAdultoMayor);
    FETCH C_GetCaracteristica INTO Ln_IdDetCaractAdultoMayor;
    CLOSE C_GetCaracteristica;
    
    OPEN C_GetCaracteristica(Lv_CaractValorDescuento);
    FETCH C_GetCaracteristica INTO Ln_IdCaractValorDescuento;
    CLOSE C_GetCaracteristica;

    OPEN C_GetCaracteristica(Lv_CaractDescTotalFact);
    FETCH C_GetCaracteristica INTO Ln_IdCaractDescTotalFact;
    CLOSE C_GetCaracteristica; 
    
    OPEN  C_Parametros(Lv_NombreParamDisc, Lv_ParamPorcDescDisc, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Ln_ValorPorcDescDisc;
    CLOSE C_Parametros; 

    OPEN  C_Parametros(Lv_NombreParametro, Lv_ParamPorcAdultoMayor, Lv_EstadoActivo, Pv_EmpresaCod);
    FETCH C_Parametros INTO Ln_PorcDescResolucion;
    CLOSE C_Parametros; 
    
    OPEN C_GetParamCategPlanBasico(Lv_NombreParametro, Lv_ParamCategoriaPlan, Lv_EstadoActivo, Lv_ParamValorCategoria, Pv_EmpresaCod);
    FETCH C_GetParamCategPlanBasico INTO Lc_ParamCategoriaPlanBasico;
    CLOSE C_GetParamCategPlanBasico;
    --
    --Se valida si el tipo de proceso existe parametrizado.
    IF Pv_TipoProceso IS NOT NULL THEN 
        OPEN C_GetParamTipoProceso(Lv_NombreParametro, Lv_ParamTipoProceso, Lv_EstadoActivo, Pv_TipoProceso, Pv_EmpresaCod);
        FETCH C_GetParamTipoProceso INTO Lc_TipoProceso;
            IF C_GetParamTipoProceso%NOTFOUND THEN
                Lv_MsnError := 'Error al recuperar el par�metro de tipo proceso.';
                RAISE Lex_Exception;  
            END IF;
        CLOSE C_GetParamTipoProceso;
    END IF;
    --

    --Si el servicio no existe y el tipoProceso es Individual se enviar� a la excepci�n controlada.
    IF Pn_IdServicio IS NULL AND Pv_TipoProceso = 'INDIVIDUAL'  THEN
        Lv_MsnError := 'No se encontr� el id del servicio para el tipo de proceso '||Pv_TipoProceso;
        RAISE Lex_Exception; 
    END IF;

    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_RECALCULO');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Pv_EmailUsuario,'notificaciones_telcos@telconet.ec')||',';
    Lv_NombreArchivo     := 'ReporteSolicitudesRecalculadas'||Pv_PrefijoEmpresa||'_'||Lv_FechaReporte||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lv_Asunto            := 'Notificacion REPORTE POR PROCESO DE RECALCULO';

    IF Pv_TipoProceso = 'MASIVO' THEN
        Lfile_Archivo := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

        utl_file.put_line(Lfile_Archivo,'LOGIN' ||Lv_Delimitador
                          ||'VALOR ANTERIOR'    ||Lv_Delimitador
                          ||'VALOR RECALCULADO' ||Lv_Delimitador
                          ||'FECHA PROCESO'     ||Lv_Delimitador
                          ||'CICLO FACTURACION' ||Lv_Delimitador); 
    END IF; 
    --
    Lv_CadenaQuery := 
        'SELECT PTO.LOGIN, SOL.ID_DETALLE_SOLICITUD, SOL.SERVICIO_ID, SOL.PRECIO_DESCUENTO, 
          SOL.PORCENTAJE_DESCUENTO, SERV.VALOR_DESCUENTO, SOL.ESTADO, 
          MOT.NOMBRE_MOTIVO, SERV.ESTADO AS ESTADO_SERVICIO,
          DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_INFO_CLIENTE_CICLOFAC(''CICLO_FACTURACION'',CLIE.ID_PERSONA_ROL) AS CICLO_FACTURACION';     

    Lv_CadenaFrom  := ' FROM DB_COMERCIAL.INFO_PUNTO PTO,'||
                      ' DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL CLIE,'||
                      ' DB_COMERCIAL.INFO_EMPRESA_ROL EMPROL,'||
                      ' DB_COMERCIAL.INFO_PERSONA PERS,'||
                      ' DB_COMERCIAL.INFO_SERVICIO SERV,'||                      
                      ' DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL,'||
                      ' DB_COMERCIAL.ADMI_TIPO_SOLICITUD TSOL,'||
                      ' DB_GENERAL.ADMI_MOTIVO MOT,'||
                      ' DB_COMERCIAL.INFO_PLAN_CAB PLAC,'||
                      ' DB_COMERCIAL.INFO_PLAN_DET PLAD,'||
                      ' DB_COMERCIAL.ADMI_PRODUCTO PROD';

    Lv_CadenaWhere:=  ' WHERE PTO.ID_PUNTO  = SERV.PUNTO_ID 
            AND SERV.ID_SERVICIO            = SOL.SERVICIO_ID 
            AND SOL.TIPO_SOLICITUD_ID       = TSOL.ID_TIPO_SOLICITUD 
            AND TSOL.ESTADO                 = '''||Lv_EstadoActivo||''' 
            AND TSOL.DESCRIPCION_SOLICITUD  = '''||Lv_TipoSolicitud||''' 
            AND PTO.PERSONA_EMPRESA_ROL_ID  = CLIE.ID_PERSONA_ROL 
            AND CLIE.EMPRESA_ROL_ID         = EMPROL.ID_EMPRESA_ROL 
            AND EMPROL.EMPRESA_COD          = '''||Pv_EmpresaCod||''' 
            AND CLIE.PERSONA_ID             = PERS.ID_PERSONA 
            AND SOL.MOTIVO_ID               = MOT.ID_MOTIVO  
            AND SERV.PLAN_ID                = PLAC.ID_PLAN 
            AND PLAC.ID_PLAN                = PLAD.PLAN_ID 
            AND PLAD.PRODUCTO_ID            = PROD.ID_PRODUCTO 
            AND PROD.CODIGO_PRODUCTO       IN (SELECT PD.VALOR1 
                                               FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                               DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                               WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                               AND PC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''         
                                               AND PC.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.DESCRIPCION      = '''||Lv_ParamCodProducto||''')
            AND PLAC.TIPO                  IN (SELECT PD.VALOR1 
                                               FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                               DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                               WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                               AND PC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''         
                                               AND PC.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.DESCRIPCION      = '''||Lv_ParamPlanesPermitidos||''')                             
            AND PERS.TIPO_TRIBUTARIO       IN (SELECT PD.VALOR1 
                                               FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                               DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                               WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                               AND PC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''         
                                               AND PC.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.DESCRIPCION      = '''||Lv_ParamTipoPersona||''')                                                    
            AND UPPER(SERV.ESTADO)         IN (SELECT UPPER(PD.VALOR1)
                                               FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                               DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                               WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                               AND PC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''
                                               AND PC.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.DESCRIPCION      = '''||Lv_ParamEstadosServicios||''')                                   
            AND UPPER(SOL.ESTADO)          IN (SELECT UPPER(PD.VALOR1)
                                               FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                               DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                               WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                               AND PC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''
                                               AND PC.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.ESTADO           = '''||Lv_EstadoActivo||'''
                                               AND PD.DESCRIPCION      = '''||Lv_ParamEstadosSolicitud||''') ';
    -- Si el servicio existe el proceso funciona como tipoProceso Individual. 
    IF Pn_IdServicio IS NOT NULL THEN                                          
       Lv_CadenaWhere := Lv_CadenaWhere
                || ' AND MOT.NOMBRE_MOTIVO IN (SELECT PD.VALOR1 
                                               FROM DB_GENERAL.ADMI_PARAMETRO_DET PD, 
                                                 DB_GENERAL.ADMI_PARAMETRO_CAB PC 
                                               WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID 
                                               AND PC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||''' 
                                               AND PC.ESTADO           = '''||Lv_EstadoActivo||''' 
                                               AND PD.ESTADO           = '''||Lv_EstadoActivo||''' 
                                               AND PD.DESCRIPCION      = '''||Lv_ParamMotivoAdultoMayor||'''
                                               AND PD.VALOR2           = '''||Lv_ParamProcesoRecaculo||'''
                                              UNION ALL  
                                               SELECT PD.VALOR1 
                                               FROM DB_GENERAL.ADMI_PARAMETRO_DET PD, 
                                                 DB_GENERAL.ADMI_PARAMETRO_CAB PC 
                                               WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID 
                                               AND PC.NOMBRE_PARAMETRO = '''||Lv_NombreParamDisc||''' 
                                               AND PC.ESTADO           = '''||Lv_EstadoActivo||''' 
                                               AND PD.ESTADO           = '''||Lv_EstadoActivo||''' 
                                               AND PD.DESCRIPCION      = '''||Lv_ParamMotivoDisc||''' )
                      AND SERV.ID_SERVICIO = '||Pn_IdServicio||'  ';                                        
    
    ELSE
        Lv_CadenaWhere := Lv_CadenaWhere 
            || ' AND MOT.NOMBRE_MOTIVO IN (SELECT PD.VALOR1 
                                           FROM DB_GENERAL.ADMI_PARAMETRO_DET PD,
                                            DB_GENERAL.ADMI_PARAMETRO_CAB PC
                                           WHERE PC.ID_PARAMETRO   = PD.PARAMETRO_ID
                                           AND PC.NOMBRE_PARAMETRO = '''||Lv_NombreParametro||'''
                                           AND PC.ESTADO           = '''||Lv_EstadoActivo||'''
                                           AND PD.ESTADO           = '''||Lv_EstadoActivo||'''
                                           AND PD.DESCRIPCION      = '''||Lv_ParamMotivoAdultoMayor||'''
                                           AND PD.VALOR2           = '''||Lv_ParamProcesoRecaculo||''') '; 
    END IF;
    --
    Lv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere;
    IF Lrf_SolicBeneficios%ISOPEN THEN
      CLOSE Lrf_SolicBeneficios;
    END IF;
    
    La_RegistrosSolicitudes.DELETE();
    
    OPEN Lrf_SolicBeneficios FOR Lv_Consulta;
    LOOP
      FETCH Lrf_SolicBeneficios BULK COLLECT INTO La_RegistrosSolicitudes LIMIT Ln_Limit;
      Ln_Indx := La_RegistrosSolicitudes.FIRST;
      --
      EXIT WHEN La_RegistrosSolicitudes.COUNT = 0;
      --
      WHILE (Ln_Indx IS NOT NULL)  
      LOOP
      --
        BEGIN
            Ln_Indr := Ln_Indr + 1; 
            --
            Lv_MsjResultado     := NULL;
            Lv_MsnError         := NULL;
            Lv_MensajeHistorial := NULL;
            --

            OPEN C_ObtienePrecioVentaServ(La_RegistrosSolicitudes(Ln_Indx).SERVICIO_ID);
                FETCH C_ObtienePrecioVentaServ INTO Lc_InfoServicio;
            CLOSE C_ObtienePrecioVentaServ;

            OPEN C_GetParamTipoProceso(Lv_NombreParametro, Lv_ParamMotivoAdultoMayor, 
                                       Lv_EstadoActivo, La_RegistrosSolicitudes(Ln_Indx).NOMBRE_MOTIVO, Pv_EmpresaCod);
            FETCH C_GetParamTipoProceso INTO Lc_TipoFlujoAdultoMayor;
            CLOSE C_GetParamTipoProceso;
            --
            --Se obtiene el tipo de categor�a en el plan mediante el servicio para validaciones.
            IF Pv_TipoProceso = 'INDIVIDUAL' THEN
                OPEN C_GetTipoCategoriaPlan (Lv_DescCaractPlanAdultoMayor, La_RegistrosSolicitudes(Ln_Indx).SERVICIO_ID);
                FETCH C_GetTipoCategoriaPlan INTO Lv_TipoCategoriaPlan;
                CLOSE C_GetTipoCategoriaPlan; 
            END IF;
            --
    
            IF Lc_TipoFlujoAdultoMayor.valor6 = 'PROCESO_3ERA_EDAD_ADULTO_MAYOR' AND 
                (Pv_TipoProceso = 'INDIVIDUAL' OR Pv_TipoProceso = 'MASIVO') THEN
                --Se obtiene la sumatoria de los precios de los detalles de Productos de un Plan correspondiente a un servicio
                --en base al par�metro 'APLICA_PRODUCTO_DESCUENTO_ADULTO_MAYOR' =>'S' si es motivo por beneficio de Adulto Mayor
                IF Lv_ValorCalculoProducto = 'S' THEN   
                
                    Ln_SumPrecioItem := CMKG_BENEFICIOS.F_SUM_PRECIO_ITEM_SERV_PLAN(La_RegistrosSolicitudes(Ln_Indx).SERVICIO_ID,
                                                                                    Lv_NombreParametro,
                                                                                    Lv_EstadoActivo,
                                                                                    Lv_ParamAplicaProdDesc,
                                                                                    Pv_EmpresaCod);

                ELSE

                    --Obtiene valor de la tabla db_comercial.info_servicio el campo precio_venta. 
                    Ln_SumPrecioItem := ROUND(Lc_InfoServicio.PRECIO_VENTA,2);

            
                END IF; 
                Ln_ValorTotalDescuento := CMKG_BENEFICIOS.F_DESCUENTO_ADULTO_MAYOR(Ln_ValorPorcResidBasico,
                                                                                   Ln_ValorSBU,
                                                                                   Ln_ValorPorcDescAdultoMayor,
                                                                                   Ln_SumPrecioItem);

                Ln_ValorTotalDescuento := ROUND(Ln_ValorTotalDescuento,2);            
            ELSIF Lc_TipoFlujoAdultoMayor.valor6 = 'PROCESO_3ERA_EDAD_RESOLUCION_072021' AND Pv_TipoProceso = 'INDIVIDUAL' THEN 
                --Se realiza el c�lculo del valor de descuento para la solicitud con beneficio 3era Edad Resoluci�n 07-2021, bas�ndose
                --en el precio de plan b�sico adulto mayor tanto para los tipos de categor�as de plan b�sico o comerciales.

                Ln_ValorPlanBasico     := CMKG_BENEFICIOS.F_PRECIO_PLAN_BASICO(Lv_DescCaractPlanAdultoMayor,Lc_ParamCategoriaPlanBasico.VALOR1,Pv_EmpresaCod);
                Ln_ValorTotalDescuento := ROUND(Ln_ValorPlanBasico * (Ln_PorcDescResolucion/100),2); 

            ELSIF Lv_MotivoDiscapacidad = La_RegistrosSolicitudes(Ln_Indx).NOMBRE_MOTIVO THEN
                --C�lculo si el beneficio es discapacidad
                Ln_ValorTotalDescuento := ROUND( ROUND(Lc_InfoServicio.PRECIO_VENTA,2) * (Ln_ValorPorcDescDisc / 100),2);
            
            END IF;
            --    

            IF (Ln_ValorTotalDescuento IS NULL OR Ln_ValorTotalDescuento = 0) THEN
                Lv_MsnError := 'Error al obtener descuento del servicio en el proceso de rec�lculo. Ln_ValorTotalDescuento: ' 
                                    ||Ln_ValorTotalDescuento;
                RAISE Le_Exception;
            END IF; 
            --
            Lv_MensajeHistorial := REPLACE(Lv_ValorMensajeHist, '#DESCANTERIOR', NVL(ROUND(La_RegistrosSolicitudes(Ln_Indx).PRECIO_DESCUENTO,2),0) );
            Lv_MensajeHistorial := REPLACE(Lv_MensajeHistorial, '#DESCACTUAL', Ln_ValorTotalDescuento);

            --
            -- Se verifica si existe caracteristica 'DESCUENTO TOTALIZADO FACT' ligada a la solicitud y se procede actualizar
            -- con el valor correspondiente dependiendo el motivo de beneficio.
            OPEN C_GetIdCaractSolicitud(Ln_IdCaractDescTotalFact, La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD);
            FETCH C_GetIdCaractSolicitud INTO Ln_IdDetalleSolCaract;
            CLOSE C_GetIdCaractSolicitud; 

            IF Ln_IdDetalleSolCaract IS NOT NULL THEN
                IF Lv_MotivoAdultoMayor = La_RegistrosSolicitudes(Ln_Indx).NOMBRE_MOTIVO THEN  
                    Ln_ValorSolCaract := Ln_ValorTotalDescuento;
                ELSIF Lv_MotivoDiscapacidad = La_RegistrosSolicitudes(Ln_Indx).NOMBRE_MOTIVO THEN
                    Ln_ValorSolCaract := ROUND(La_RegistrosSolicitudes(Ln_Indx).PORCENTAJE_DESCUENTO,2);
                END IF;
                
                UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT  
                SET VALOR = Ln_ValorSolCaract, USR_ULT_MOD = Pv_Usuario, FE_ULT_MOD  = SYSDATE
                WHERE ID_SOLICITUD_CARACTERISTICA = Ln_IdDetalleSolCaract;
                
            END IF; 
            --
            --Actualizo valores en la tabla info_Servicio
            Lr_InfoServicio                    := NULL;
            Lr_InfoServicio.VALOR_DESCUENTO    := Ln_ValorTotalDescuento;
            Lr_InfoServicio.DESCUENTO_UNITARIO := Ln_ValorTotalDescuento;
            Lr_InfoServicio.ID_SERVICIO        := La_RegistrosSolicitudes(Ln_Indx).SERVICIO_ID;
    
            DB_COMERCIAL.CMKG_REINGRESO.P_UPDATE_INFO_SERVICIO(Lr_InfoServicio, Lv_MsnError); 

            IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;  
    
            -- Se actualiza los campos para el descuento en la solicitud con beneficio.
            Lr_InfoDetalleSolicitud := NULL;

            IF Lc_TipoFlujoAdultoMayor.valor6 = 'PROCESO_3ERA_EDAD_ADULTO_MAYOR' AND
                (Pv_TipoProceso = 'INDIVIDUAL' OR Pv_TipoProceso = 'MASIVO') THEN
                
                Lr_InfoDetalleSolicitud.PRECIO_DESCUENTO     := Ln_ValorTotalDescuento;
                Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD := La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD; 

            ELSIF Lc_TipoFlujoAdultoMayor.valor6 = 'PROCESO_3ERA_EDAD_RESOLUCION_072021' AND Pv_TipoProceso = 'INDIVIDUAL' THEN 
                --Se setean los valores cuando sea por beneficio de adulto mayor 3era Edad Resoluci�n.

                IF Lv_TipoCategoriaPlan = Lc_ParamCategoriaPlanBasico.VALOR1 THEN
                    Lr_InfoDetalleSolicitud.PRECIO_DESCUENTO     := Ln_ValorTotalDescuento;
                    Lr_InfoDetalleSolicitud.PORCENTAJE_DESCUENTO := Ln_PorcDescResolucion;
                    Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD := La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD; 
                ELSE
                    Lr_InfoDetalleSolicitud.PRECIO_DESCUENTO     :=  Ln_ValorTotalDescuento;
                    Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD :=  La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD; 
                    
                    UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD SET PORCENTAJE_DESCUENTO = NULL 
                    WHERE ID_DETALLE_SOLICITUD = La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD;
                END IF;

            ELSE
                Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD := La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD;
                Lr_InfoDetalleSolicitud.PRECIO_DESCUENTO     := Ln_ValorTotalDescuento;
                 
            END IF; 
    
            DB_COMERCIAL.CMKG_REINGRESO.P_UPDATE_INFO_DETALLE_SOL(Lr_InfoDetalleSolicitud, Lv_MsnError); 

            IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;   
            -- Inserto caracter�stica para la solicitud
            Lr_InfoDetalleSolCaract                      := NULL;
            Lr_InfoDetalleSolCaract.CARACTERISTICA_ID    := Ln_IdCaractValorDescuento;
            Lr_InfoDetalleSolCaract.VALOR                := NVL(ROUND(La_RegistrosSolicitudes(Ln_Indx).PRECIO_DESCUENTO,2),0);
            Lr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID := La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD;  
            Lr_InfoDetalleSolCaract.ESTADO               := 'Activo';  
            Lr_InfoDetalleSolCaract.USR_CREACION         := Pv_Usuario;
    
            DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC(Lr_InfoDetalleSolCaract, Lv_MsnError);
    
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;  
    
            -- Inserto caracter�stica id de adulto mayor para el servicio (ID_DET_CARACT_ADULTO_MAYOR)
            Lr_InfoServicioCaract                            := NULL;
            Lr_InfoServicioCaract.ID_SERVICIO_CARACTERISTICA := DB_COMERCIAL.SEQ_INFO_SERVICIO_CARAC.NEXTVAL;
            Lr_InfoServicioCaract.SERVICIO_ID                := La_RegistrosSolicitudes(Ln_Indx).SERVICIO_ID;
            Lr_InfoServicioCaract.CARACTERISTICA_ID          := Ln_IdDetCaractAdultoMayor;
            Lr_InfoServicioCaract.VALOR                      := La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD;
            Lr_InfoServicioCaract.ESTADO                     := 'Activo';  
            Lr_InfoServicioCaract.OBSERVACION                := 
                'Se crea caracter�stica por proceso de rec�lculo, campo Valor: id solicitud. TipoProceso: '||Pv_TipoProceso;  
            Lr_InfoServicioCaract.USR_CREACION               := Pv_Usuario;
            Lr_InfoServicioCaract.IP_CREACION                := Lv_IpCreacion;
    
            DB_COMERCIAL.CMKG_BENEFICIOS.P_INSERT_INFO_SERVICIO_CARACT(Lr_InfoServicioCaract, Lv_MsnError);
    
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;  
     
            Ln_IdServicioCaract := Lr_InfoServicioCaract.ID_SERVICIO_CARACTERISTICA;
    
            -- Inserto caracter�stica valor descuento para el servicio
            Lr_InfoServicioCaract                                := NULL;
            Lr_InfoServicioCaract.ID_SERVICIO_CARACTERISTICA     := DB_COMERCIAL.SEQ_INFO_SERVICIO_CARAC.NEXTVAL;
            Lr_InfoServicioCaract.SERVICIO_ID                    := La_RegistrosSolicitudes(Ln_Indx).SERVICIO_ID;
            Lr_InfoServicioCaract.CARACTERISTICA_ID              := Ln_IdCaractValorDescuento;
            Lr_InfoServicioCaract.VALOR                          := NVL(ROUND(La_RegistrosSolicitudes(Ln_Indx).PRECIO_DESCUENTO,2),0);
            Lr_InfoServicioCaract.ESTADO                         := 'Activo';
            Lr_InfoServicioCaract.OBSERVACION                    := 
                'Se crea caracter�stica por proceso de rec�lculo, campo Valor: valor anterior descuento. TipoProceso: '||Pv_TipoProceso;
            Lr_InfoServicioCaract.USR_CREACION                   := Pv_Usuario;
            Lr_InfoServicioCaract.IP_CREACION                    := Lv_IpCreacion;
            Lr_InfoServicioCaract.REF_ID_SERVICIO_CARACTERISTICA := Ln_IdServicioCaract;
    
            DB_COMERCIAL.CMKG_BENEFICIOS.P_INSERT_INFO_SERVICIO_CARACT(Lr_InfoServicioCaract, Lv_MsnError);
    
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;  
            -- Inserto historial de rec�lculo de la solicitud
            Lr_DetalleSolHistorial                        := NULL;
            Lr_DetalleSolHistorial.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_DetalleSolHistorial.DETALLE_SOLICITUD_ID   := La_RegistrosSolicitudes(Ln_Indx).ID_DETALLE_SOLICITUD;
            Lr_DetalleSolHistorial.ESTADO                 := La_RegistrosSolicitudes(Ln_Indx).ESTADO;
            Lr_DetalleSolHistorial.OBSERVACION            := Lv_MensajeHistorial;
            Lr_DetalleSolHistorial.USR_CREACION           := Pv_Usuario;
            Lr_DetalleSolHistorial.IP_CREACION            := Lv_IpCreacion;
    
            DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_DETALLE_SOL_HIST(Lr_DetalleSolHistorial, Lv_MsnError);
    
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_Exception;
            END IF;   
    
            -- Inserto historial de rec�lculo del servicio
            Lr_ServicioHistorial                       := NULL;
            Lr_ServicioHistorial.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
            Lr_ServicioHistorial.OBSERVACION           := Lv_MensajeHistorial;
            Lr_ServicioHistorial.ESTADO                := La_RegistrosSolicitudes(Ln_Indx).ESTADO_SERVICIO;
            Lr_ServicioHistorial.USR_CREACION          := Pv_Usuario;
            Lr_ServicioHistorial.IP_CREACION           := Lv_IpCreacion;
            Lr_ServicioHistorial.SERVICIO_ID           := La_RegistrosSolicitudes(Ln_Indx).SERVICIO_ID;
            DB_COMERCIAL.COMEK_TRANSACTION.P_INSERT_SERVICIO_HISTORIAL(Lr_ServicioHistorial, Lv_MsnError);
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;

            COMMIT;

            IF Pv_TipoProceso = 'INDIVIDUAL' THEN
                Pv_Mensaje:= Lv_MensajeHistorial;
            END IF;

            IF Pv_TipoProceso = 'MASIVO' THEN
                UTL_FILE.PUT_LINE(Lfile_Archivo,
                        NVL(La_RegistrosSolicitudes(Ln_Indx).LOGIN, '')                              ||Lv_Delimitador
                        ||NVL(REPLACE(ROUND(La_RegistrosSolicitudes(Ln_Indx).PRECIO_DESCUENTO,2),',','.'), '') ||Lv_Delimitador
                        ||NVL(REPLACE(Ln_ValorTotalDescuento,',','.'), '')                           ||Lv_Delimitador
                        ||NVL(TRUNC(SYSDATE), '')                                                    ||Lv_Delimitador
                        ||NVL(La_RegistrosSolicitudes(Ln_Indx).CICLO_FACTURACION, '')                ||Lv_Delimitador
                );
            END IF;
  
        EXCEPTION
          WHEN Le_Exception THEN
            ROLLBACK;
            Lv_MsjResultado := 'Ocurri� error al generar el proceso de rec�lculo. - TipoProceso: '||Pv_TipoProceso ||' - '||Lv_MsnError;
            Pv_MsnError     := Lv_MsjResultado; 
            Pv_Mensaje      := NULL; 
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_BENEFICIOS.P_RECALCULO', 
                                                 Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'DB_COMERCIAL',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

          WHEN OTHERS THEN
            ROLLBACK;
            Lv_MsjResultado := 'Ocurri� error al generar el proceso de rec�lculo - TipoProceso: '||Pv_TipoProceso;
            Pv_MsnError     := Lv_MsjResultado;
            Pv_Mensaje      := NULL;  
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'CMKG_BENEFICIOS.P_RECALCULO', 
                                                 Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'DB_COMERCIAL',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
                                       
        
        END;
      --  
        Ln_Indx := La_RegistrosSolicitudes.NEXT(Ln_Indx);
        
      END LOOP;
      --
    END LOOP;
    --
    CLOSE Lrf_SolicBeneficios;    
    --
    

    IF Pv_TipoProceso = 'MASIVO' THEN
        UTL_FILE.fclose(Lfile_Archivo);
        dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 
        IF Ln_Indr > 0 THEN 
            DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                      Lv_Destinatario,
                                                      Lv_Asunto, 
                                                      Lv_Cuerpo, 
                                                      Lv_Directorio,
                                                      Lv_NombreArchivoZip);
        END IF;
        UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);  
    END IF;
    --
    
  EXCEPTION
  WHEN Lex_Exception THEN
    ROLLBACK;
    Lv_MsjResultado := 'Ocurri� un error al generar el proceso de rec�lculo. - TipoProceso: '||Pv_TipoProceso||' - '||Lv_MsnError;
    Pv_MsnError     := Lv_MsjResultado;
    Pv_Mensaje      := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_BENEFICIOS.P_RECALCULO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'DB_COMERCIAL',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  WHEN OTHERS THEN
    ROLLBACK;
    Lv_MsjResultado := 'Ocurri� un error al generar el proceso de rec�lculo - TipoProceso: '||Pv_TipoProceso;
    Pv_MsnError     := Lv_MsjResultado;
    Pv_Mensaje      := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_BENEFICIOS.P_RECALCULO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'DB_COMERCIAL',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

  END P_RECALCULO;
  --
  
  PROCEDURE P_INSERT_INFO_SERVICIO_CARACT(Pr_InfoServicioCaract IN DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA%ROWTYPE,
                                          Pv_MsnError           OUT VARCHAR2)
  AS
  BEGIN
    --
    INSERT
    INTO DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA
      (
          ID_SERVICIO_CARACTERISTICA,
          SERVICIO_ID,
          CARACTERISTICA_ID,
          VALOR,
          FE_FACTURACION,
          CICLO_ORIGEN_ID,
          ESTADO,
          OBSERVACION,
          USR_CREACION,
          IP_CREACION,
          FE_CREACION,
          USR_ULT_MOD,
          IP_ULT_MOD,
          FE_ULT_MOD,
          REF_ID_SERVICIO_CARACTERISTICA
      )
      VALUES
      (
        Pr_InfoServicioCaract.ID_SERVICIO_CARACTERISTICA,
        Pr_InfoServicioCaract.SERVICIO_ID,
        Pr_InfoServicioCaract.CARACTERISTICA_ID,
        Pr_InfoServicioCaract.VALOR,
        Pr_InfoServicioCaract.FE_FACTURACION,
        Pr_InfoServicioCaract.CICLO_ORIGEN_ID,
        Pr_InfoServicioCaract.ESTADO,
        Pr_InfoServicioCaract.OBSERVACION,
        Pr_InfoServicioCaract.USR_CREACION,
        Pr_InfoServicioCaract.IP_CREACION,
        SYSDATE,
        Pr_InfoServicioCaract.USR_ULT_MOD,
        Pr_InfoServicioCaract.IP_ULT_MOD,
        Pr_InfoServicioCaract.FE_ULT_MOD,
        Pr_InfoServicioCaract.REF_ID_SERVICIO_CARACTERISTICA
      );
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsnError := 'Error al insertar la caracter�stica - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                         'CMKG_BENEFICIOS.P_INSERT_INFO_SERVICIO_CARACT',
                                         Pv_MsnError,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  
  END P_INSERT_INFO_SERVICIO_CARACT; 
  --

  FUNCTION F_DESCUENTO_ADULTO_MAYOR(Fn_ParamPorcValorResidencial IN NUMBER,
                                    Fn_ParamSalarioBasico        IN NUMBER,
                                    Fn_ParamPorcDescAdultMayor   IN NUMBER,
                                    Fn_SumPrecioItem             IN NUMBER)
  RETURN NUMBER
  IS 
  --Costo:4
  CURSOR C_GetFormulaPlanBasico(Cn_ParamSalarioBasico        NUMBER,
                                Cn_ParamPorcValorResidencial NUMBER,
                                Cv_NombreParametro           DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                Cv_ParamFormulaPlanBasico    DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                Cv_Estado                    VARCHAR2)
  IS
    SELECT (REPLACE(REPLACE(APDET.VALOR1,'SALARIO_BASICO_UNIFICADO',Cn_ParamSalarioBasico),
    'PORCENTAJE_VALOR_RESIDENCIAL_BASICO',Cn_ParamPorcValorResidencial))
     AS FORMULA_PLAN_BASICO
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB, DB_GENERAL.ADMI_PARAMETRO_DET APDET  
    WHERE
    APCAB.ID_PARAMETRO          = APDET.PARAMETRO_ID
    AND APCAB.NOMBRE_PARAMETRO  = Cv_NombreParametro
    AND APDET.DESCRIPCION       = Cv_ParamFormulaPlanBasico
    AND APCAB.ESTADO            = Cv_Estado
    AND APDET.ESTADO            = Cv_Estado;
    
  --Costo: 4  
  CURSOR C_GetFormulaDescAdultoMayor(Cn_ParamSalarioBasico          NUMBER,
                                     Cn_ParamPorcValorResidencial   NUMBER,
                                     Cn_ParamPorcDescAdultMayor     NUMBER,
                                     Cv_NombreParametro             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                     Cv_ParamFormulaDescAdultMayor  DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                     Cv_Estado                      VARCHAR2)
  IS
  SELECT REPLACE(REPLACE(REPLACE(APDET.VALOR1,'SALARIO_BASICO_UNIFICADO',Cn_ParamSalarioBasico),
    'PORCENTAJE_VALOR_RESIDENCIAL_BASICO',Cn_ParamPorcValorResidencial),'PORCENTAJE_DESC_ADULTO_MAYOR',Cn_ParamPorcDescAdultMayor)
     AS FORMULA_DESC_ADULTO_MAYOR
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB, DB_GENERAL.ADMI_PARAMETRO_DET APDET  
    WHERE
    APCAB.ID_PARAMETRO          = APDET.PARAMETRO_ID
    AND APCAB.NOMBRE_PARAMETRO  =  Cv_NombreParametro
    AND APDET.DESCRIPCION       =  Cv_ParamFormulaDescAdultMayor
    AND APCAB.ESTADO            =  Cv_Estado
    AND APDET.ESTADO            =  Cv_Estado;
        
  Lv_NombreParametro              DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PARAM_FLUJO_ADULTO_MAYOR';
  Lv_ParamFormulaPlanBasico       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE:='FORMULA_PLAN_BASICO';
  Lv_ParamFormulaDescAdultMayor   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE:='FORMULA_DESC_ADULTO_MAYOR';  
  Lv_sql                          VARCHAR2(200);
  Lv_FormulaPlanBasico            VARCHAR2(200);
  Lv_FormulaDescAdultoMayor       VARCHAR2(200);
  Ln_ValorFormulaPlanBasico       NUMBER:=0;
  Ln_ValorFormulaDescAdultoMayor  NUMBER:=0;
  Lv_MsnError                     VARCHAR2 (2000);
  Lv_Estado                       VARCHAR2(15):='Activo';
  Lv_IpCreacion                   VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  Le_Exception                    EXCEPTION;

  BEGIN    
    IF (Fn_SumPrecioItem IS NULL OR Fn_SumPrecioItem = 0) THEN
      Lv_MsnError := 'Error al obtener PRECIO del servicio para el calculo del Beneficio 3era Edad/ Adulto Mayor ';
      RAISE Le_Exception;
    END IF; 
    --Formula Plan Basico
    IF C_GetFormulaPlanBasico%ISOPEN THEN
      CLOSE C_GetFormulaPlanBasico;
    END IF;
    OPEN C_GetFormulaPlanBasico (Fn_ParamSalarioBasico,
                                 Fn_ParamPorcValorResidencial,
                                 Lv_NombreParametro, 
                                 Lv_ParamFormulaPlanBasico,
                                 Lv_Estado);
    FETCH C_GetFormulaPlanBasico INTO Lv_FormulaPlanBasico;
    CLOSE C_GetFormulaPlanBasico;
    --
    IF Lv_FormulaPlanBasico IS NULL THEN
      Lv_MsnError := 'Error al obtener FORMULA_PLAN_BASICO para el calculo del Beneficio 3era Edad/ Adulto Mayor ';
      RAISE Le_Exception;
    END IF; 
    --
    --Formula Descuento Adulto Mayor
    IF C_GetFormulaDescAdultoMayor%ISOPEN THEN
      CLOSE C_GetFormulaDescAdultoMayor;
    END IF;
    OPEN C_GetFormulaDescAdultoMayor (Fn_ParamSalarioBasico,
                                      Fn_ParamPorcValorResidencial,
                                      Fn_ParamPorcDescAdultMayor,
                                      Lv_NombreParametro, 
                                      Lv_ParamFormulaDescAdultMayor,
                                      Lv_Estado);
    FETCH C_GetFormulaDescAdultoMayor INTO Lv_FormulaDescAdultoMayor;
    CLOSE C_GetFormulaDescAdultoMayor;
    --
    IF Lv_FormulaDescAdultoMayor IS NULL THEN
      Lv_MsnError := 'Error al obtener FORMULA_DESC_ADULTO_MAYOR para el calculo del Beneficio 3era Edad/ Adulto Mayor ';
      RAISE Le_Exception;
    END IF; 
    --
    --Obtengo el Valor del Plan Basico
    Lv_sql := 'BEGIN :p1 :='|| Lv_FormulaPlanBasico||'; END;';
    EXECUTE IMMEDIATE Lv_sql USING OUT Ln_ValorFormulaPlanBasico;    
    
    IF Fn_SumPrecioItem >= Ln_ValorFormulaPlanBasico THEN
      --
      --Obtengo el Valor del Descuento Adulto Mayor
      Lv_sql := 'BEGIN :p1 :='|| Lv_FormulaDescAdultoMayor||'; END;';
      EXECUTE IMMEDIATE Lv_sql USING OUT Ln_ValorFormulaDescAdultoMayor;    
      --
    ELSIF (Fn_SumPrecioItem < Ln_ValorFormulaPlanBasico) THEN    
       Ln_ValorFormulaDescAdultoMayor:= Fn_SumPrecioItem * (Fn_ParamPorcDescAdultMayor/100);
    END IF;
    
    RETURN Ln_ValorFormulaDescAdultoMayor;

    EXCEPTION
      WHEN Le_Exception THEN
      --          
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_BENEFICIOS.F_DESCUENTO_ADULTO_MAYOR',
                                           Lv_MsnError,
                                           'DB_COMERCIAL',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      WHEN OTHERS THEN
        --
        Lv_MsnError := 'Error al obtener el valor de descuento a otorgarse por Beneficio 3era Edad/ Adulto Mayor -'
                       || SQLCODE || ' - ERROR_STACK: '
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_BENEFICIOS.F_DESCUENTO_ADULTO_MAYOR',
                                             Lv_MsnError,
                                             'DB_COMERCIAL',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        Ln_ValorFormulaDescAdultoMayor:=0;
        RETURN Ln_ValorFormulaDescAdultoMayor;
        --
  END F_DESCUENTO_ADULTO_MAYOR;
  --
  
  FUNCTION F_EDAD_PERSONA(Fn_IdPersona IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
  RETURN NUMBER
  IS 
  --Costo Query:3
  CURSOR C_GetEdadPersona(Cn_IdPersona DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE)
  IS
   SELECT TRUNC(MONTHS_BETWEEN(SYSDATE,FECHA_NACIMIENTO)/12) AS EDAD 
   FROM DB_COMERCIAL.INFO_PERSONA 
   WHERE ID_PERSONA=Cn_IdPersona
   AND FECHA_NACIMIENTO IS NOT NULL AND TIPO_TRIBUTARIO='NAT';    
    
   Lv_NombreParametro      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PARAM_FLUJO_ADULTO_MAYOR';   
   Lv_MsnError             VARCHAR2 (2000);
   Lv_Estado               VARCHAR2(15):='Activo';
   Lv_IpCreacion           VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
   Le_Exception            EXCEPTION;
   Ln_Edad                 NUMBER:=0;
  BEGIN   
    IF (Fn_IdPersona IS NULL) THEN
      Lv_MsnError := 'Error no encontro id de la Persona valido.';
      RAISE Le_Exception;
    END IF; 
    --
    IF C_GetEdadPersona%ISOPEN THEN
      CLOSE C_GetEdadPersona;
    END IF;
    OPEN C_GetEdadPersona (Fn_IdPersona);
    FETCH C_GetEdadPersona INTO Ln_Edad;
    CLOSE C_GetEdadPersona;
    --
    IF Ln_Edad IS NULL THEN
      Lv_MsnError := 'Error al obtener la edad de la Persona.';
      RAISE Le_Exception;
    END IF; 
    --  
   RETURN Ln_Edad;
   
   EXCEPTION
      WHEN Le_Exception THEN
      --          
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'CMKG_BENEFICIOS.F_EDAD_PERSONA',
                                           Lv_MsnError,
                                           'DB_COMERCIAL',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      Ln_Edad:=0;
      RETURN Ln_Edad;
      WHEN OTHERS THEN
        --
        Lv_MsnError := 'Error al obtener la edad de la Persona -'
                       || SQLCODE || ' - ERROR_STACK: '
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_BENEFICIOS.F_EDAD_PERSONA',
                                             Lv_MsnError,
                                             'DB_COMERCIAL',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        Ln_Edad:=0;
        RETURN Ln_Edad;
        --
  END F_EDAD_PERSONA;
  --

  FUNCTION F_PRECIO_PLAN_BASICO(Fv_DescCaracteristica IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Fv_Valor              IN DB_COMERCIAL.INFO_PLAN_CARACTERISTICA.VALOR%TYPE,
                                Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
  RETURN NUMBER
  IS 
  
  CURSOR C_GetPrecioPlanBasico(Cv_DescCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                               Cv_EmpresaCod      DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                               Cv_ValorCaract VARCHAR2,
                               Cv_Estado      VARCHAR2)
  IS
    SELECT SUM(IPDET.PRECIO_ITEM) AS SUM_PRECIO_ITEM_PLAN
    FROM DB_COMERCIAL.INFO_PLAN_CAB IPCAB,
    DB_COMERCIAL.INFO_PLAN_DET IPDET
    WHERE IPCAB.ID_PLAN   = IPDET.PLAN_ID
    AND IPCAB.ESTADO      = Cv_Estado
    AND IPCAB.EMPRESA_COD =Cv_EmpresaCod
    AND IPCAB.FE_CREACION = (SELECT MAX(IPCAB_2.FE_CREACION)   
                             FROM 
                             DB_COMERCIAL.INFO_PLAN_CAB IPCAB_2,
                             DB_COMERCIAL.INFO_PLAN_CARACTERISTICA IPCARACT,
                             DB_COMERCIAL.ADMI_CARACTERISTICA AC
                             WHERE IPCAB_2.ID_PLAN             = IPCARACT.PLAN_ID
                             AND IPCARACT.CARACTERISTICA_ID    = AC.ID_CARACTERISTICA
                             AND AC.DESCRIPCION_CARACTERISTICA = Cv_DescCaracteristica
                             AND IPCARACT.VALOR                = Cv_ValorCaract
                             AND IPCAB_2.ESTADO                = Cv_Estado
                             AND IPCAB_2.EMPRESA_COD           =Cv_EmpresaCod
                            ) ;    
 
   Lv_MsnError             VARCHAR2 (2000);
   Lv_Estado               VARCHAR2(15) := 'Activo';
   Lv_IpCreacion           VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
   Le_Exception            EXCEPTION;
   Ln_PrecioPlanBasico      NUMBER := 0;
   
  BEGIN   
    --
    IF C_GetPrecioPlanBasico%ISOPEN THEN
      CLOSE C_GetPrecioPlanBasico;
    END IF;
    
    OPEN C_GetPrecioPlanBasico (Fv_DescCaracteristica,Cv_EmpresaCod,Fv_Valor, Lv_Estado);
    FETCH C_GetPrecioPlanBasico INTO Ln_PrecioPlanBasico;
    CLOSE C_GetPrecioPlanBasico;
    --
    IF Ln_PrecioPlanBasico IS NULL THEN
      Lv_MsnError := 'Error al obtener el precio del plan b�sico.';
      RAISE Le_Exception;
    END IF; 
    --  
   RETURN Ln_PrecioPlanBasico;

   EXCEPTION
      WHEN Le_Exception THEN
      --          
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_BENEFICIOS.F_PRECIO_PLAN_BASICO',
                                             Lv_MsnError,
                                             'DB_COMERCIAL',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        Ln_PrecioPlanBasico:=0;
        RETURN Ln_PrecioPlanBasico;
      WHEN OTHERS THEN
        --
        Lv_MsnError := 'Error al obtener el precio del plan b�sico -'
                       || SQLCODE || ' - ERROR_STACK: '
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                             'CMKG_BENEFICIOS.F_PRECIO_PLAN_BASICO',
                                             Lv_MsnError,
                                             'DB_COMERCIAL',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        Ln_PrecioPlanBasico:=0;
        RETURN Ln_PrecioPlanBasico;
        --
  END F_PRECIO_PLAN_BASICO;
  --

  /*
* Funcion que sirve para obtener la discapacidad de la persona
* @author Jessenia Piloso <jpiloso@telconet.ec>
* @version 1.0 25-01-2023
* 
* @param  INFO_SERVICIO.ID_SERVICIO%TYPE      Fn_IdServicio             id del servicio
* @return VARCHAR2                            Fv_esClienteDiscapacitado identifica si el cliente es Discapacitado
* 
*/