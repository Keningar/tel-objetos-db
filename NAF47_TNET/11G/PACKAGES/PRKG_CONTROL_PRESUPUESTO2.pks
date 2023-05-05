CREATE OR REPLACE package PRKG_CONTROL_PRESUPUESTO2 IS

  
  TYPE TypeParametros IS RECORD (
    NO_DOCUMENTO      NAF47_TNET.TAPORDEE.NO_ORDEN%TYPE,
    NO_CIA            NAF47_TNET.TAPORDEE.NO_CIA%TYPE,
    ID_TIPO_CCOSTO    DB_GENERAL.ADMI_PARAMETRO_DET.ID_PARAMETRO_DET%TYPE,
    NIVEL             DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
    SENTENCIA_SQL     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE);
  --
  TYPE TypeRegistroDinamico IS RECORD (
    COLUMNA_01 VARCHAR2(100),
    COLUMNA_02 VARCHAR2(1000),
    COLUMNA_03 VARCHAR2(1000),
    COLUMNA_04 VARCHAR2(1000),
    COLUMNA_05 VARCHAR2(1000),
    COLUMNA_06 VARCHAR2(1000)
  );
  --
  TYPE TypeDetalleTipoCosto IS RECORD (
    PERIODO             NUMBER(6),
    NO_DOCU             VARCHAR2(12),
    TIPO_CCOSTO_ID      VARCHAR2(12),
    NO_CIA              VARCHAR2(2),
    REFERENCIA_ID       VARCHAR(12),
    REFERENCIA_PADRE_ID VARCHAR(12),
    CANTIDAD            NUMBER(9),
    MONTO               NUMBER DEFAULT 0,
    TIPO_DISTRIBUCION   NAF47_TNET.TAPORDEE.TIPO_DISTRIBUCION_COSTO%TYPE DEFAULT 'Administrativo',
    CUENTA_CONTABLE_ID  NAF47_TNET.ARCGMS.CUENTA%TYPE);
  --
  TYPE TypeDistribContable IS RECORD (
    NO_CIA          NAF47_TNET.ARCGCECO.NO_CIA%TYPE,
    CENTRO_COSTO_ID NAF47_TNET.ARCGCECO.CENTRO%TYPE,
    CC_1            NAF47_TNET.ARCGCECO.CC_1%TYPE,
    CC_2            NAF47_TNET.ARCGCECO.CC_2%TYPE,
    CC_3            NAF47_TNET.ARCGCECO.CC_3%TYPE,
    CANTIDAD        NUMBER(6)
    );
  --
  TYPE TypeDetalleTipoCostoPro IS RECORD (
    PERIODO             NUMBER(6),
    NO_DOCU             VARCHAR2(12),
    TIPO_CCOSTO_ID      VARCHAR2(12),
    DESCRIPCION         VARCHAR2(100),
    NO_CIA              VARCHAR2(2),
    REFERENCIA_ID       VARCHAR(12),
    REFERENCIA_PADRE_ID VARCHAR(12),
    ID_PROYECTO_CUENTA  VARCHAR(12),--para parametro de consulta de vertical
    CANTIDAD            NUMBER(9),
    MONTO               NUMBER DEFAULT 0,
    TIPO_DISTRIBUCION   NAF47_TNET.TAPORDEE.TIPO_DISTRIBUCION_COSTO%TYPE DEFAULT 'Proyecto',
    CUENTA_CONTABLE_ID  NAF47_TNET.ARCGMS.CUENTA%TYPE);
  --
  TYPE Gt_Parametros IS TABLE OF TypeParametros;
  TYPE Gt_DetalleTipoCosto IS TABLE OF TypeDetalleTipoCosto;
  TYPE Gt_DistribContable IS TABLE OF TypeDistribContable;
  TYPE Lt_Parametros IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
  TYPE Gt_DetalleTipoCostoPro IS TABLE OF TypeDetalleTipoCostoPro;
  --
 /**
  * Documentacion para P_DATOS_CONSULTAS_AUTOMATICOS 
  * Procedure que ejecuta consulta dinamica hasta con 10 parametros de los querys configurados en los parametros
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 16/07/2021
  *
  * @param Pt_ParametrosUsr   IN     Recibe array con parametros de usuarios
  * @param Pn_TipoCentroCosto IN     Recibe tipo de centro de costos
  * @param Pv_TipoSentencia   IN     Recibe tipo de sentencia
  * @param Pt_Resultado       IN OUT SYS_REFCURSOR retorna arreglo con el resultado del query
  * @param Pv_MensajeError    IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE P_DATOS_CONSULTAS_AUTOMATICOS (Pt_ParametrosUsr   IN Lt_Parametros,
                                           Pn_TipoCentroCosto IN NUMBER,
                                           Pv_TipoSentencia   IN VARCHAR2,
                                           Pt_Resultado       OUT SYS_REFCURSOR,
                                           Pv_MensajeError    IN OUT VARCHAR2);

 /**
  * Documentacion para F_RECUPERA_CUENTA_CONTABLE 
  * Función que retorna cuenta contable en base a query configurado en parametros.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 16/07/2021
  *
  * @param Pv_TipoCosto    IN VARCHAR2 Recibe tipo de centro de costos
  * @param Pv_ReferenciaId IN VARCHAR2 Recibe código a buscar
  * @param Pv_EmpresaRefId IN VARCHAR2 Recibe código de compañía
  * @return                   VARCHAR2 retorna código de cuenta contable
  */
  FUNCTION F_RECUPERA_CUENTA_CONTABLE ( Pv_TipoCosto    IN VARCHAR2,
                                        Pv_ReferenciaId IN VARCHAR2,
                                        Pv_EmpresaRefId IN VARCHAR2) RETURN VARCHAR2;


 /**
  * Documentacion para P_ARBOL_CENTRO_COSTO 
  * Procedure que genera los niveles de centros de costos por tipo para asignación de distribución.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 05/07/2020
  *
  * @param Pt_Datos        IN     NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_Parametros Recibe arreglo de parametros
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE P_ARBOL_CENTRO_COSTO ( Pt_Datos        IN NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_Parametros,
                                   Pv_MensajeError IN OUT VARCHAR2);
  --
  /**
  * Documentacion para F_RECUPERA_CENTRO_COSTO 
  * Función que recupera el codigo de centro de costo en base a arreglo de parametros
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 05/07/2020
  *
  * @param Pt_DetalleCosto IN Gt_DetalleTipoCosto                Recibe arreglo de parametros
  * @param Pv_CodigoCCosto IN NAF47_TNET.PR_CENTRO_COSTO.CODIGO  Recibe codigo de Centro de costo
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  FUNCTION F_RECUPERA_CENTRO_COSTO ( Pt_DetalleCosto IN Gt_DetalleTipoCosto,
                                     Pv_CodigoCCosto IN NAF47_TNET.PR_CENTRO_COSTO.CODIGO%TYPE,
                                     Pv_NoCia        IN VARCHAR2) RETURN NUMBER;
  --
  /**
  * Documentacion para P_INSERTA_DOC_DISTRIBUCION 
  * procedimiento que recupera el codigo de centro de costo en base a arreglo de parametros
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 05/07/2020
  *
  * @param Pt_DetalleCosto IN Gt_DetalleTipoCosto                Recibe arreglo de parametros
  * @param Pv_CodigoCCosto IN NAF47_TNET.PR_CENTRO_COSTO.CODIGO  Recibe codigo de Centro de costo
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_INSERTA_DOC_DISTRIBUCION (Pr_DocDistribucion IN NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION%ROWTYPE,
                                        Pv_MensajeError    IN OUT VARCHAR2);
  --
  /**
  * Documentacion para P_INSERTA_RESUMEN_COSTO 
  * Procedimiento inserta registro en la tabla PR_COSTOS_RESUMEN
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 05/07/2020
  *
  * @param Pr_ResumenCosto IN NAF47_TNET.PR_COSTOS_RESUMEN%ROWTYPE Recibe arreglo de datos
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_INSERTA_RESUMEN_COSTO (Pr_ResumenCosto IN NAF47_TNET.PR_COSTOS_RESUMEN%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2);


  /**
  * Documentacion para P_INSERTA_COSTO_DETALLE_TRX 
  * Procedimiento inserta registro en la tabla PR_COSTOS_DETALLE_TRX
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 19/08/2020
  *
  * @param Pr_CostosDetalleTrx IN NAF47_TNET.PR_COSTOS_DETALLE_TRX%ROWTYPE Recibe arreglo de datos
  * @param Pv_MensajeError     IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_INSERTA_COSTO_DETALLE_TRX (Pr_CostosDetalleTrx IN NAF47_TNET.PR_COSTOS_DETALLE_TRX%ROWTYPE,
                                         Pv_MensajeError     IN OUT VARCHAR2);

  --
  --  
  /**
  * Documentacion para P_REPLICA_DISTRIBUCION_CXP 
  * Procedimiento replica detalle Distribucion de OC a la factura proveedor que esta relacionada
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/08/2020
  *
  * @param Pv_NoOrden        IN VARCHAR2     Recibe número de OC
  * @param Pv_NoFactura      IN VARCHAR2     Recibe numero Factura a procesar OC
  * @param Pv_NoCia          IN VARCHAR2     Recibe código de empresa
  * @param Pn_DetalleCostoId IN OUT NUMBER   Retorna número detalle id para generar distribución desde la forma
  * @param Pv_MensajeError   IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_REPLICA_DISTRIBUCION_CXP (Pv_NoOrden        IN VARCHAR2,
                                        Pv_NoFactura      IN VARCHAR2,
                                        Pv_NoCia          IN VARCHAR2,
                                        Pn_DetalleCostoId IN OUT VARCHAR2,
                                        Pv_MensajeError   IN OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para P_PROCESA_DISTRIBUCION 
  * Procedimiento realiza distribución y registra en la tabla de costos resumen y costo detalle trx
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 19/08/2020
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 01/01/2021 - Se modifica para considerar costro de facturas sin OC
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 16/07/2021 - Se modifica para considerar todos los casos de costeos y centralizar en un solo proceso
  *
  * @param Pn_Monto        IN NUMBER              Recibe monto total a distribuir
  * @param Pn_Cantidad     IN NUMBER              Recibe cantidad total sobre el cual se va distribuir
  * @param Pt_Detalle      IN Gt_DetalleTipoCosto Recibe arreglo datos con detalle de tipos centros de costos a distribuir
  * @param Pv_MensajeError IN OUT VARCHAR2        Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_PROCESA_DISTRIBUCION (Pn_Monto        IN NUMBER,
                                    Pn_Cantidad     IN NUMBER,
                                    Pv_Origen       IN VARCHAR2,
                                    Pt_Detalle      IN NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DetalleTipoCosto,
                                    Pv_MensajeError IN OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para P_COSTEO_OC_SERVICIO 
  * Procedimiento realiza distribución de costeo de ordenes de compras de Servicios
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 19/08/2020
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 16/07/2021 - Se modifica para considerar proceso centralizado de distribución.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 06/09/2021 - Se corrige para considerar que proceso distribución por pedidos se ejecuta como distribución Administrativa
  *
  * @param Pv_NoDocu       IN VARCHAR2     Recibe documento a distribuir
  * @param Pv_NoCia        IN VARCHAR2     Recibe código de empresa
  * @param Pv_TipoProceso  IN VARCHAR2     Recibe el tipo proceso: Procesar / Reversar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_COSTEO_OC_SERVICIO ( Pv_NoDocu       IN VARCHAR2,
                                   Pv_NoCia        IN VARCHAR2,
                                   Pv_TipoProceso  IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para P_COSTEO_PEDIDO_SERVICIO 
  * Procedimiento realiza distribución de costeo de Pedidos de bienes al despachar articulos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 19/08/2020
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 16/07/2021 - Se modifica para considerar proceso centralizado de distribución.
  *
  * @param Pv_NoDocu       IN NUMBER       Recibe documento a distribuir
  * @param Pv_NoCia        IN NUMBER       Recibe código de empresa
  * @param Pv_TipoProceso  IN VARCHAR2     Recibe el tipo proceso: Procesar / Reversar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_COSTEO_PEDIDO_SERVICIO ( Pv_NoDocu       IN VARCHAR2,
                                       Pv_NoCia        IN VARCHAR2,
                                       Pv_TipoProceso  IN VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para P_COSTEO_PEDIDO_BIENES 
  * Procedimiento realiza distribución y registra en la tabla de costos resumen y costo detalle trx despacho
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 19/08/2020
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 16/07/2021 - Se modifica para considera nuevo proceso de costeo de Proyectos
  *
  * @param Pv_NoDocu          IN Recibe Identificación de documento
  * @param Pv_NoCia           IN Recibe Identificación de compañía
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_COSTEO_PEDIDO_BIENES ( Pv_NoDocu       IN VARCHAR2,
                                     Pv_NoCia        IN VARCHAR2,
                                     Pv_MensajeError OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para P_DETALLE_CENTRO_COSTO 
  * Procedimiento recupera detalle de centros de costos a distribuir
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 04/08/2020
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 28/12/2020 -  Se modifica para acumular la cantidad de empleados por centros de costos pues existen departamentos en más de una localidad.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 01/01/2021 -  Se modifica para considerar costeo de facturas sin OC
  *
  * @param Pn_DetalleDistribId IN VARCHAR2               Recibe código detalle de distribución
  * @param Pv_NoDocumento      IN VARCHAR2               Recibe código de documento a procesar
  * @param Pv_Origen           IN VARCHAR2               Recibe Origen para identificar el tipo de registro a recuperar
  * @param Pv_NoCia            IN VARCHAR2               Recibe código de empresa
  * @param Pn_NumDistribuir    IN OUT NUMBER             retorna cantidad de empleados a distribuir
  * @param Pt_DistribContable  IN OUT Gt_DistribContable Retorna arreglo con detalle de centros de costos y numero empleados
  * @param Pv_MensajeError     IN OUT VARCHAR2           Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_DETALLE_CENTRO_COSTO ( Pn_DetalleDistribId IN NUMBER,
                                      Pv_NoDocumento      IN VARCHAR2,
                                      Pv_Origen           IN VARCHAR2,
                                      Pv_NoCia            IN VARCHAR2,
                                      Pn_NumDistribuir    IN OUT NUMBER,
                                      Pt_DistribContable  IN OUT NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DistribContable,
                                      Pv_MensajeError     IN OUT VARCHAR2);
  --
  --
  /**
  * Documentacion para P_COSTEO_ASIENTO_CONTABLE 
  * Procedimiento realiza distribución y registra en la tabla de costos resumen y costo detalle de assientos contables
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 19/08/2020
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 16/07/2021 - Se modifica para considerar nuevo proceso distribución de proyectos
  *
  * @param Pv_NoDocu          IN Recibe Identificación de documento
  * @param Pv_NoCia           IN Recibe Identificación de compañía
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_COSTEO_ASIENTO_CONTABLE ( Pv_NoDocu      IN VARCHAR2,
                                        Pv_NoCia        IN VARCHAR2,
                                        Pv_MensajeError IN OUT VARCHAR2);

  --
  /**
  * Documentacion para P_DISTRIBUCION_COSTO_FACTURA 
  * Procedimiento genera distribución de costos en la tabla resumen.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 05/07/2020
  *
  * @param Pv_NoDocu       IN VARCHAR2     Recibe Identificación de documento
  * @param Pv_NoCia        IN VARCHAR2     Recibe Identificación de compañía
  * @param Pv_TipoProceso  IN VARCHAR2     Recibe el tipo proceso: Procesar / Reversar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_DISTRIBUCION_COSTO_FACTURA ( Pv_NoDocu       IN VARCHAR2,
                                           Pv_NoCia        IN VARCHAR2,
                                           Pv_TipoProceso  IN VARCHAR2,
                                           Pv_MensajeError IN OUT VARCHAR2);
  /**
  * Documentacion para P_ASIGNA_COSTEO_BIENES 
  * Procedimiento que asigna costeo homogeneo a proyectos y verticaleas asociadas al pedido
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 16/07/2021
  *
  * @param Pv_NoDocu       IN VARCHAR2     Recibe Identificación de documento
  * @param Pv_LoginAux     IN VARCHAR2     Recibe login del servicio asociado al proyecto
  * @param Pv_Periodo      IN VARCHAR2     Recibe periodo a procesar costeo
  * @param Pn_Monto        IN NUMBER       Recibe monto a distribuir
  * @param Pv_NoCia        IN VARCHAR2     Recibe Identificación de compañía
  * @param Pa_DatosCosteo  IN VARCHAR2     Recibe arreglo con los datos a costear
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_ASIGNA_COSTEO_BIENES ( Pv_NoDocu        IN VARCHAR2,
                                     Pv_LoginAux      IN VARCHAR2,
                                     Pv_Periodo       IN VARCHAR2,
                                     Pn_Monto         IN NUMBER,
                                     Pv_NoCia         IN VARCHAR2,
                                     Pa_DatosCosteo   IN OUT Gt_DetalleTipoCosto,
                                     Pv_MensajeError  IN OUT VARCHAR2);

/**
  * Documentacion para P_ASIGNA_COSTEO_BIENES_PRO 
  * Procedimiento que asigna costeo homogeneo a productos, proyectos y verticaleas asociadas al pedido
  * @author banton <banton@telconet.ec>
  * @version 1.0 16/05/2022
  *
  * @param Pv_NoDocu       IN VARCHAR2     Recibe Identificacion de documento
  * @param Pv_Servicio     IN VARCHAR2     Recibe servicio asociado al proyecto
  * @param Pv_Periodo      IN VARCHAR2     Recibe periodo a procesar costeo
  * @param Pn_Monto        IN NUMBER       Recibe monto a distribuir
  * @param Pv_NoCia        IN VARCHAR2     Recibe Identificacion de compania
  * @param Pa_DatosCosteo  IN VARCHAR2     Recibe arreglo con los datos a costear
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  
  PROCEDURE P_ASIGNA_COSTEO_BIENES_PRO ( Pv_NoDocu        IN VARCHAR2,
                                         Pv_Servicio      IN NUMBER,
                                         Pv_Periodo       IN VARCHAR2,
                                         Pn_Monto         IN NUMBER,
                                         Pv_NoCia         IN VARCHAR2,
                                         Pa_DatosCosteo   IN OUT Gt_DetalleTipoCostoPro,
                                         Pv_MensajeError  IN OUT VARCHAR2);                                     
                                     
  /**
  * Documentacion para P_PROCESA_DISTRIBUCION_PRO 
  * Procedimiento genera distribucion de costos en la tabla resumen.
  * @author banton <banton@telconet.ec>
  * @version 1.0 16/05/2022
  *
  * @param Pn_Monto        IN NUMBER              Recibe monto total a distribuir
  * @param Pn_Cantidad     IN NUMBER              Recibe cantidad total sobre el cual se va distribuir
  * @param Pt_Detalle      IN Gt_DetalleTipoCostoPro Recibe arreglo datos con detalle de tipos centros de costos a distribuir
  * @param Pv_MensajeError IN OUT VARCHAR2        Retorna mensaje error Retorna mensaje error
  */
  
  PROCEDURE P_PROCESA_DISTRIBUCION_PRO (Pn_Monto        IN NUMBER,
                                    Pn_Cantidad     IN NUMBER,
                                    Pv_Origen       IN VARCHAR2,
                                    Pt_Detalle      IN NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DetalleTipoCostoPro,
                                    Pv_MensajeError IN OUT VARCHAR2);
                                    
  /**
  * Documentacion para F_RECUPERA_CENTRO_COSTO_PRO 
  * Funcion que retorna cuenta contable en base a query configurado en parametros.
  * @author banton <banton@telconet.ec>
  * @version 1.0 16/05/2022
  *
  * @param Pv_TipoCosto    IN VARCHAR2 Recibe tipo de centro de costos
  * @param Pv_ReferenciaId IN VARCHAR2 Recibe codigo a buscar
  * @param Pv_EmpresaRefId IN VARCHAR2 Recibe codigo de compa?ia
  * @return                   VARCHAR2 retorna codigo de cuenta contable
  */
  
  FUNCTION F_RECUPERA_CUENTA_CONTABLE_PRO ( Pv_TipoCosto    IN VARCHAR2,
                                            Pv_ReferenciaId IN VARCHAR2,
                                            Pv_ReferPadreId IN VARCHAR2,
                                            Pv_EmpresaRefId IN VARCHAR2) RETURN VARCHAR2;
                                            
  
   /**
  * Documentacion para P_COSTEO_OC_SERVICIO 
  * Procedimiento realiza distribucion de costeo de ordenes de compras de Servicios
  * tipo proyecto
  * @author banton <banton@telconet.ec>
  * @version 1.0 19/05/2022
  *
  * @param Pv_NoDocu       IN VARCHAR2     Recibe documento a distribuir
  * @param Pv_NoCia        IN VARCHAR2     Recibe codigo de empresa
  * @param Pv_TipoProceso  IN VARCHAR2     Recibe el tipo proceso: Procesar / Reversar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  
  PROCEDURE P_COSTEO_OC_SERVICIO_PRO ( Pv_NoDocu       IN VARCHAR2,
                                       Pv_NoCia        IN VARCHAR2,
                                       Pv_TipoProceso  IN VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2);                                            


END PRKG_CONTROL_PRESUPUESTO2;

/



/
