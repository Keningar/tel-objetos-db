CREATE OR REPLACE package            PRKG_CONTROL_PRESUPUESTO IS

  
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

  /**
  * Documentacion para P_INSERTA_DOC_DISTRIBUCION 
  * procedimiento que recupera el codigo de centro de costo en base a arreglo de parametros
  * se lo hace para manejar el entorno de la base de datos en la MIGRACION a la 19C
  * @author llindao <jxzurita@telconet.ec>
  * @version 1.0 05/07/2020
  *
  * @param Pt_DetalleCosto IN Gt_DetalleTipoCosto                Recibe arreglo de parametros
  * @param Pv_CodigoCCosto IN NAF47_TNET.PR_CENTRO_COSTO.CODIGO  Recibe codigo de Centro de costo
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error Retorna mensaje error
  */
  PROCEDURE P_INSERTA_DOC_DISTRIBUCION2 (Pr_DocDistribucion IN NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION%ROWTYPE,
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


END PRKG_CONTROL_PRESUPUESTO;

/


CREATE OR REPLACE package body            PRKG_CONTROL_PRESUPUESTO is
  --
  CONTROL_PRESUPUESTO  CONSTANT VARCHAR2(19) := 'CONTROL_PRESUPUESTO';
  TIPO_CENTRO_COSTO    CONSTANT VARCHAR2(17) := 'TIPO_CENTRO_COSTO';
  CLASE_CENTRO_COSTO   CONSTANT VARCHAR2(18) := 'CLASE_CENTRO_COSTO';
  CONSULTA_POR_NIVEL   CONSTANT VARCHAR2(18) := 'CONSULTA_POR_NIVEL';
  DETALLE_SENTENCIA    CONSTANT VARCHAR2(17) := 'DETALLE_SENTENCIA';
  FILTRO_SENTENCIA_SQL CONSTANT VARCHAR2(20) := 'FILTRO_SENTENCIA_SQL';
  CARACT_PROYECTO      CONSTANT VARCHAR2(20) := 'Relacionar Proyecto';
  DIVISION_REGIONAL    CONSTANT VARCHAR2(17) := 'DIVISION_REGIONAL';
  DIV_REGION_JURISDIC  CONSTANT VARCHAR2(30) := 'DIVISION_REGIONAL_JURISDICCION';
  PROYECTO             CONSTANT VARCHAR2(08) := 'Proyecto';
  VERTICALES           CONSTANT VARCHAR2(13) := 'LINEA_NEGOCIO';

  --
  CURSOR C_ARBOL_COSTO (Cv_NoCia           VARCHAR2,
                        Cv_TipoCentroCosto VARCHAR2 
                        ) IS
    SELECT APD.ID_PARAMETRO_DET AS ID_TIPO_CCOSTO,
           APD.VALOR2 AS DESCRIPCION,
           APD.VALOR3 AS NIVEL,
           APD.VALOR4 AS GENERA_COSTO,
           (SELECT VALOR1
            FROM DB_GENERAL.ADMI_PARAMETRO_DET DS
            WHERE DS.DESCRIPCION = 'DETALLE_SENTENCIA'
            AND DS.VALOR3 = 'CONSULTA_POR_NIVEL'
            AND EXISTS (SELECT NULL 
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                        WHERE APC.NOMBRE_PARAMETRO = 'CONTROL_PRESUPUESTO'
                        AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
            AND DS.VALOR2 = TO_CHAR(APD.ID_PARAMETRO_DET)) AS SENTENCIA_LEE_TIPO,
           APD.EMPRESA_COD,
           VALOR6 AS ULTIMO_NIVEL
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.EMPRESA_COD = Cv_NoCia
    AND APD.DESCRIPCION = TIPO_CENTRO_COSTO
    AND APD.VALOR4 = NAF47_TNET.GEK_VAR.Gr_IndSimple.SI
    AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_DET CCC
                WHERE CCC.DESCRIPCION = CLASE_CENTRO_COSTO
                AND CCC.VALOR3 = Cv_TipoCentroCosto
                AND CCC.VALOR2 = APD.ID_PARAMETRO_DET
                AND CCC.EMPRESA_COD = APD.EMPRESA_COD
                AND CCC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                AND EXISTS (SELECT NULL
                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                            WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                            AND APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO))
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                AND APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO)
    ORDER BY TO_NUMBER(APD.VALOR3) DESC;
  --
  CURSOR C_RECUPERA_COSTO_RESUMEN ( Cn_IdCentroCosto NUMBER,
                                    Cv_Periodo       VARCHAR2) IS
    SELECT ID_COSTO_RESUMEN
    FROM NAF47_TNET.PR_COSTOS_RESUMEN
    WHERE CENTRO_COSTO_ID = Cn_IdCentroCosto
    AND PERIODO = Cv_Periodo;
  --
  --
    CURSOR C_TIPO_CENTRO_COSTO (Cn_TipoCentroCostoId NUMBER,
                                Cv_SentenciaQuery    VARCHAR2) IS
      SELECT APD.ID_PARAMETRO_DET AS ID_TIPO_CCOSTO,
             APD.VALOR2 AS DESCRIPCION,
             APD.VALOR3 AS NIVEL,
             APD.VALOR4 AS GENERA_COSTO,
             APD.EMPRESA_COD,
             (SELECT VALOR1
              FROM DB_GENERAL.ADMI_PARAMETRO_DET DS
              WHERE DS.DESCRIPCION = 'DETALLE_SENTENCIA'
              AND DS.VALOR3 = Cv_SentenciaQuery--'PROCESO_DISTRIBUCION_CCOSTO'
              AND EXISTS (SELECT NULL 
                          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                          WHERE APC.NOMBRE_PARAMETRO = 'CONTROL_PRESUPUESTO'
                          AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
              AND DS.VALOR2 = TO_CHAR(APD.ID_PARAMETRO_DET)) AS Sentencia_Sql
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.ID_PARAMETRO_DET = Cn_TipoCentroCostoId;
  --
  --
  PROCEDURE P_DATOS_CONSULTAS_AUTOMATICOS (Pt_ParametrosUsr   IN Lt_Parametros,
                                           Pn_TipoCentroCosto IN NUMBER,
                                           Pv_TipoSentencia   IN VARCHAR2,
                                           Pt_Resultado       OUT SYS_REFCURSOR,
                                           Pv_MensajeError    IN OUT VARCHAR2) IS
    --
    CURSOR C_DETALLE_SENTENCIA IS
      SELECT DS.ID_PARAMETRO_DET ID_SENTENCIA_SQL,
             DS.VALOR1 SENTENCIA_SQL
      FROM DB_GENERAL.ADMI_PARAMETRO_DET DS
      WHERE DS.DESCRIPCION = DETALLE_SENTENCIA
      AND DS.VALOR3 = Pv_TipoSentencia--'DETALLE_CONTABLE_INVENTARIO'
      AND DS.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO --'Activo'
      AND EXISTS (SELECT NULL 
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO
                  AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO --'Activo'
                  AND APC.ID_PARAMETRO = DS.PARAMETRO_ID)
      AND DS.VALOR2 = TO_CHAR(Pn_TipoCentroCosto);
    --
    CURSOR C_DETALLE_PARAMETROS (Cv_DetalleParametroId VARCHAR2) IS
      SELECT APD.VALOR3 AS NOMBRE_PARAMETRO,
             APD.VALOR5 AS VALOR_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.VALOR2 = Cv_DetalleParametroId
      AND APD.DESCRIPCION = FILTRO_SENTENCIA_SQL
      AND EXISTS (SELECT NULL 
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO
                  AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO --'Activo'
                  AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)
      ORDER BY 1;
    --
    Ln_Indice       NUMBER(3):=0;
    Lr_DetSentencia C_DETALLE_SENTENCIA%ROWTYPE;
    Lr_Parametros   Lt_Parametros;
    --
  BEGIN
    --
    IF C_DETALLE_SENTENCIA%ISOPEN THEN
      CLOSE C_DETALLE_SENTENCIA;
    END IF;
    OPEN C_DETALLE_SENTENCIA;
    FETCH C_DETALLE_SENTENCIA INTO Lr_DetSentencia;
    IF C_DETALLE_SENTENCIA% NOTFOUND THEN
      RETURN;
    END IF;
    CLOSE C_DETALLE_SENTENCIA;
    --
    FOR Lr_ListaParametros IN C_DETALLE_PARAMETROS (Lr_DetSentencia.ID_SENTENCIA_SQL) LOOP
      --
      Ln_Indice := Ln_Indice + 1;
      Lr_Parametros(Ln_Indice) := Lr_ListaParametros.VALOR_PARAMETRO;
      --
    END LOOP;
    --
    FOR I IN 1..Pt_ParametrosUsr.last LOOP
      Ln_Indice := Ln_Indice + 1;
      Lr_Parametros(Ln_Indice) := Pt_ParametrosUsr(I);
    END LOOP;
    --
    CASE 
      WHEN Ln_Indice = 1 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(Ln_Indice);
      WHEN Ln_Indice = 2 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(Ln_Indice);
      WHEN Ln_Indice = 3 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(2),
                                                                            Lr_Parametros(Ln_Indice);
      WHEN Ln_Indice = 4 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(2),
                                                                            Lr_Parametros(3),
                                                                            Lr_Parametros(Ln_Indice);
      WHEN Ln_Indice = 5 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(2),
                                                                            Lr_Parametros(3),
                                                                            Lr_Parametros(4),
                                                                            Lr_Parametros(Ln_Indice);
      WHEN Ln_Indice = 6 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(2),
                                                                            Lr_Parametros(3),
                                                                            Lr_Parametros(4),
                                                                            Lr_Parametros(5),
                                                                            Lr_Parametros(Ln_Indice);
      WHEN Ln_Indice = 7 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(2),
                                                                            Lr_Parametros(3),
                                                                            Lr_Parametros(4),
                                                                            Lr_Parametros(5),
                                                                            Lr_Parametros(6),
                                                                            Lr_Parametros(Ln_Indice);
      WHEN Ln_Indice = 8 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(2),
                                                                            Lr_Parametros(3),
                                                                            Lr_Parametros(4),
                                                                            Lr_Parametros(5),
                                                                            Lr_Parametros(6),
                                                                            Lr_Parametros(7),
                                                                            Lr_Parametros(Ln_Indice);    
      WHEN Ln_Indice = 9 THEN
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(2),
                                                                            Lr_Parametros(3),
                                                                            Lr_Parametros(4),
                                                                            Lr_Parametros(5),
                                                                            Lr_Parametros(6),
                                                                            Lr_Parametros(7),
                                                                            Lr_Parametros(8),
                                                                            Lr_Parametros(Ln_Indice);
      ELSE
        OPEN Pt_Resultado FOR Lr_DetSentencia.Sentencia_Sql using Lr_Parametros(1),
                                                                            Lr_Parametros(2),
                                                                            Lr_Parametros(3),
                                                                            Lr_Parametros(4),
                                                                            Lr_Parametros(5),
                                                                            Lr_Parametros(6),
                                                                            Lr_Parametros(7),
                                                                            Lr_Parametros(8),
                                                                            Lr_Parametros(9),
                                                                            Lr_Parametros(Ln_Indice);
    END CASE;
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_DATOS_CONSULTAS_AUTOMATICOS',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_DATOS_CONSULTAS_AUTOMATICOS;
  --
  --
  --

  FUNCTION F_RECUPERA_CUENTA_CONTABLE ( Pv_TipoCosto    IN VARCHAR2,
                                        Pv_ReferenciaId IN VARCHAR2,
                                        Pv_EmpresaRefId IN VARCHAR2) RETURN VARCHAR2 IS
    --
    CURSOR C_TIPO_COSTO IS
      SELECT RCC.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET RCC
      WHERE RCC.VALOR3 = 'RECUPERA_CUENTA_CONTABLE'
      AND RCC.DESCRIPCION = 'DETALLE_SENTENCIA'
      AND RCC.VALOR2 = Pv_TipoCosto
      AND RCC.EMPRESA_COD = Pv_EmpresaRefId
      AND EXISTS (SELECT NULL 
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                        WHERE APC.NOMBRE_PARAMETRO = 'CONTROL_PRESUPUESTO'
                        AND APC.ID_PARAMETRO = RCC.PARAMETRO_ID);
    --
    Lv_Sentencia DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE;
    Lv_CuentaId  NAF47_TNET.ARCGMS.CUENTA%TYPE;
    Lc_Datos     SYS_REFCURSOR;
    --
  BEGIN
    --
    IF C_TIPO_COSTO%ISOPEN THEN
      CLOSE C_TIPO_COSTO;
    END IF; 
    OPEN C_TIPO_COSTO;
    FETCH C_TIPO_COSTO INTO Lv_Sentencia;
    CLOSE C_TIPO_COSTO;
    --
    FOR Lr_Sentencia IN C_TIPO_COSTO LOOP
      --
      OPEN Lc_Datos FOR Lr_Sentencia.Valor1 USING Pv_ReferenciaId, Pv_EmpresaRefId;
      FETCH Lc_Datos INTO Lv_CuentaId;
      CLOSE Lc_Datos;
      --
    END LOOP;
    --
    RETURN Lv_CuentaId;

  END F_RECUPERA_CUENTA_CONTABLE;
  --
  --
  PROCEDURE P_ARBOL_CENTRO_COSTO ( Pt_Datos        IN NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_Parametros,
                                   Pv_MensajeError IN OUT VARCHAR2) IS
    --
    Lc_Datos SYS_REFCURSOR;
    Lr_Datos NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.TypeRegistroDinamico;
    --
  BEGIN
    -- primer nivel limpia estructura por numero documento y usuario.
    IF Pt_Datos(1).NIVEL = 1 THEN
      --
      DELETE NAF47_TNET.PR_CONFIGURA_DISTRIBUCION A
      WHERE A.NO_DOCU = Pt_Datos(1).NO_DOCUMENTO
      AND A.NO_CIA = Pt_Datos(1).NO_CIA
      AND A.USR_CREACION = USER;
      --
    ELSE
      --
      DELETE NAF47_TNET.PR_CONFIGURA_DISTRIBUCION A
      WHERE A.NO_DOCU = Pt_Datos(1).NO_DOCUMENTO
      AND A.TIPO_CCOSTO_ID = Pt_Datos(1).ID_TIPO_CCOSTO
      AND A.NO_CIA = Pt_Datos(1).NO_CIA
      AND A.USR_CREACION = USER;
      --
    END IF;
    --
    FOR Li_Datos IN 1..Pt_Datos.LAST LOOP
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_ARBOL_CENTRO_COSTO',
                                           'Paramatros [Pt_Datos('||Li_Datos||').SENTENCIA_SQL] = '||Pt_Datos(Li_Datos).SENTENCIA_SQL,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      --
      OPEN Lc_Datos FOR Pt_Datos(Li_Datos).SENTENCIA_SQL;
      LOOP
        FETCH Lc_Datos into Lr_Datos;
        EXIT WHEN Lc_Datos%NOTFOUND;
        --
        INSERT INTO NAF47_TNET.PR_CONFIGURA_DISTRIBUCION 
        (
          NO_CIA,
          NO_DOCU,
          TIPO_CCOSTO_ID,
          COLUMNA_01,
          COLUMNA_02,
          COLUMNA_03,
          COLUMNA_04,
          COLUMNA_05,
          COLUMNA_06,
          SELECCION,
          ESTADO
        )
        VALUES
        (
          Pt_Datos(Li_Datos).NO_CIA,
          Pt_Datos(Li_Datos).NO_DOCUMENTO,
          Pt_Datos(Li_Datos).ID_TIPO_CCOSTO,
          Lr_Datos.COLUMNA_01,
          Lr_Datos.COLUMNA_02,
          Lr_Datos.COLUMNA_03,
          Lr_Datos.COLUMNA_04,
          Lr_Datos.COLUMNA_05,
          Lr_Datos.COLUMNA_06,
          0,
          'Activo'
        );
        --
      END LOOP;
      --
    END LOOP;
    --
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_ARBOL_CENTRO_COSTO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_ARBOL_CENTRO_COSTO;
  --
  --
  FUNCTION F_RECUPERA_CENTRO_COSTO ( Pt_DetalleCosto Gt_DetalleTipoCosto,
                                     Pv_CodigoCCosto NAF47_TNET.PR_CENTRO_COSTO.CODIGO%TYPE,
                                     Pv_NoCia        VARCHAR2) RETURN NUMBER IS
    --
    CURSOR C_RECUPERA_CCOSTO IS
      SELECT ID_CENTRO_COSTO
      FROM NAF47_TNET.PR_CENTRO_COSTO
      WHERE CODIGO = Pv_CodigoCCosto
      AND NO_CIA = Pv_NoCia;
    --
    Ln_CentroCostoId NUMBER := 0;
    Li_DetCCosto     NUMBER := Pt_DetalleCosto.LAST;
    --
  BEGIN
    --
    IF C_RECUPERA_CCOSTO%ISOPEN THEN
      CLOSE C_RECUPERA_CCOSTO;
    END IF;
    OPEN C_RECUPERA_CCOSTO;
    FETCH C_RECUPERA_CCOSTO INTO Ln_CentroCostoId;
    IF C_RECUPERA_CCOSTO%NOTFOUND THEN
      Ln_CentroCostoId := 0;
    END IF;
    CLOSE C_RECUPERA_CCOSTO;
    --
    IF Ln_CentroCostoId != 0 THEN
      RETURN Ln_CentroCostoId;
    END IF;
    --
    Ln_CentroCostoId := NAF47_TNET.SEQ_PR_CENTRO_COSTO.NEXTVAL;
    --
    INSERT INTO NAF47_TNET.PR_CENTRO_COSTO (
      ID_CENTRO_COSTO,
      NO_CIA,
      CODIGO,
      DESCRIPCION,
      ESTADO,
      USR_CREACION,
      FE_CREACION )
    VALUES ( 
      Ln_CentroCostoId,
      Pv_NoCia,
      Pv_CodigoCCosto,
      Pv_CodigoCCosto,
      'Activo',
      user,
      sysdate
    );
    --
    FOR Li_DetCCosto IN REVERSE 1..Pt_DetalleCosto.LAST LOOP
      --
      INSERT INTO NAF47_TNET.PR_CENTRO_COSTO_DETALLE (
        ID_CENTRO_COSTO_DET,
        CENTRO_COSTO_ID,
        TIPO_CENTRO_COSTO,
        REFERENCIA_ID,
        EMPRESA_REFERENCIA_ID,
        ESTADO,
        USR_CREACION,
        FE_CREACION )
      VALUES (
        NAF47_TNET.SEQ_PR_CENTRO_COSTO_DETALLE.NEXTVAL,
        Ln_CentroCostoId,
        Pt_DetalleCosto(Li_DetCCosto).TIPO_CCOSTO_ID,
        Pt_DetalleCosto(Li_DetCCosto).REFERENCIA_ID,
        Pt_DetalleCosto(Li_DetCCosto).NO_CIA,
        'Activo',
        user,
        sysdate);
      --
    END LOOP;
    --
    RETURN Ln_CentroCostoId;
    --
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.F_RECUPERA_CENTRO_COSTO',
                                           SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
      RETURN 0;
  END F_RECUPERA_CENTRO_COSTO;
  --
  --
  PROCEDURE P_INSERTA_DOC_DISTRIBUCION (Pr_DocDistribucion IN NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION%ROWTYPE,
                                        Pv_MensajeError    IN OUT VARCHAR2) IS
  BEGIN
    --
    INSERT INTO NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION (
      ID_DOC_DISTRIBUCION,
      NO_CIA,
      NO_DOCU,
      TIPO_CCOSTO_ID,
      TIPO_CCOSTO_DESCRIPCION,
      REFERENCIA_ID,
      REFERENCIA_DESCRIPCION,
      REFERENCIA_PADRE_ID,
      DETALLE_DISTRIBUCION_ID,
      ORIGEN,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      AUXILIAR
      )
    VALUES (
      NAF47_TNET.SEQ_PR_DOCUMENTO_DISTRIBUCION.NEXTVAL,
      Pr_DocDistribucion.no_cia,
      Pr_DocDistribucion.no_docu,
      Pr_DocDistribucion.tipo_ccosto_id,
      Pr_DocDistribucion.tipo_ccosto_descripcion,
      Pr_DocDistribucion.referencia_id,
      Pr_DocDistribucion.referencia_descripcion,
      Pr_DocDistribucion.referencia_padre_id,
      Pr_DocDistribucion.Detalle_Distribucion_Id,
      Pr_DocDistribucion.origen,
      Pr_DocDistribucion.estado,
      USER,
      SYSDATE,
      Pr_DocDistribucion.Auxiliar
      );
      --
      COMMIT;

      --

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_INSERTA_DOC_DISTRIBUCION',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_INSERTA_DOC_DISTRIBUCION;


  PROCEDURE P_INSERTA_DOC_DISTRIBUCION2 (Pr_DocDistribucion IN NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION%ROWTYPE,
                                        Pv_MensajeError    IN OUT VARCHAR2) IS
  BEGIN
    --
    INSERT INTO NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION (
      ID_DOC_DISTRIBUCION,
      NO_CIA,
      NO_DOCU,
      TIPO_CCOSTO_ID,
      TIPO_CCOSTO_DESCRIPCION,
      REFERENCIA_ID,
      REFERENCIA_DESCRIPCION,
      REFERENCIA_PADRE_ID,
      DETALLE_DISTRIBUCION_ID,
      ORIGEN,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      AUXILIAR
      )
    VALUES (
      NAF47_TNET.SEQ_PR_DOCUMENTO_DISTRIBUCION.NEXTVAL,
      Pr_DocDistribucion.no_cia,
      Pr_DocDistribucion.no_docu,
      Pr_DocDistribucion.tipo_ccosto_id,
      Pr_DocDistribucion.tipo_ccosto_descripcion,
      Pr_DocDistribucion.referencia_id,
      Pr_DocDistribucion.referencia_descripcion,
      Pr_DocDistribucion.referencia_padre_id,
      Pr_DocDistribucion.Detalle_Distribucion_Id,
      Pr_DocDistribucion.origen,
      Pr_DocDistribucion.estado,
      USER,
      SYSDATE,
      Pr_DocDistribucion.Auxiliar
      );
      --
      --COMMIT;

      --

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_INSERTA_DOC_DISTRIBUCION',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_INSERTA_DOC_DISTRIBUCION2;
  --
  --
  PROCEDURE P_INSERTA_RESUMEN_COSTO (Pr_ResumenCosto IN NAF47_TNET.PR_COSTOS_RESUMEN%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2) IS
    --
    Ln_ResumenCostoId  NUMBER := 0;
    --
  BEGIN
    --
    IF NVL(Pr_ResumenCosto.Id_Costo_Resumen,0) != 0 THEN
      Ln_ResumenCostoId := Pr_ResumenCosto.Id_Costo_Resumen;
    ELSE
      Ln_ResumenCostoId := NAF47_TNET.SEQ_PR_COSTOS_RESUMEN.NEXTVAL;
    END IF;
    --
    INSERT INTO NAF47_TNET.PR_COSTOS_RESUMEN (
      ID_COSTO_RESUMEN,
      CENTRO_COSTO_ID,
      PERIODO,
      VALOR_PRESUPUESTO,
      VALOR_COSTO,
      ESTADO,
      USR_CREACION,
      FE_CREACION )
    VALUES ( 
      Ln_ResumenCostoId,
      Pr_ResumenCosto.Centro_Costo_Id,
      Pr_ResumenCosto.Periodo,
      Pr_ResumenCosto.Valor_Presupuesto,
      Pr_ResumenCosto.Valor_Costo,
      'Activo',
      user,
      sysdate
      );
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_INSERTA_RESUMEN_COSTO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_INSERTA_RESUMEN_COSTO;
  --
  --
  PROCEDURE P_INSERTA_COSTO_DETALLE_TRX (Pr_CostosDetalleTrx IN NAF47_TNET.PR_COSTOS_DETALLE_TRX%ROWTYPE,
                                         Pv_MensajeError     IN OUT VARCHAR2) IS
    --
    Ln_IdCostoDetalleTrx NAF47_TNET.PR_COSTOS_DETALLE_TRX.ID_COSTO_DETALLE_TRX%TYPE;
    --
  BEGIN
    -- 
    -- Registro detalle por transaccion
    UPDATE NAF47_TNET.PR_COSTOS_DETALLE_TRX
    SET MONTO_TRANSACCION = NVL(MONTO_TRANSACCION,0) + Pr_CostosDetalleTrx.Monto_Transaccion,
        USR_ULT_MOD = USER,
        FE_ULT_MOD = SYSDATE
    WHERE COSTO_RESUMEN_ID = Pr_CostosDetalleTrx.Costo_Resumen_Id
    AND LLAVE_TRANSACCION = Pr_CostosDetalleTrx.Llave_Transaccion;
    --
    -- Si actualizó entonces termina el proceso
    IF SQL%ROWCOUNT > 0 THEN
      RETURN;
    END IF;
    --
    --
    Ln_IdCostoDetalleTrx := NAF47_TNET.SEQ_PR_COSTOS_DETALLE_TRX.NEXTVAL;
    --
    --
    INSERT INTO NAF47_TNET.PR_COSTOS_DETALLE_TRX (
      ID_COSTO_DETALLE_TRX,
      COSTO_RESUMEN_ID,
      LLAVE_TRANSACCION,
      MONTO_TRANSACCION,
      ESTADO,
      ORIGEN,
      USR_CREACION,
      FE_CREACION )
    VALUES (

      Ln_IdCostoDetalleTrx,
      Pr_CostosDetalleTrx.Costo_Resumen_Id,
      Pr_CostosDetalleTrx.Llave_Transaccion,
      Pr_CostosDetalleTrx.Monto_Transaccion,
      Pr_CostosDetalleTrx.Estado,
      NVL(Pr_CostosDetalleTrx.Origen,'NoDefinido'),
      USER,
      SYSDATE);
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_INSERTA_COSTO_DETALLE_TRX',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_INSERTA_COSTO_DETALLE_TRX;
  --
  --
  PROCEDURE P_REPLICA_DISTRIBUCION_CXP (Pv_NoOrden        IN VARCHAR2,
                                        Pv_NoFactura      IN VARCHAR2,
                                        Pv_NoCia          IN VARCHAR2,
                                        Pn_DetalleCostoId IN OUT VARCHAR2,
                                        Pv_MensajeError   IN OUT VARCHAR2) IS
    --
    CURSOR C_DISTRIBUCION_OC IS
      SELECT PDD.*
      FROM NAF47_TNET.TAPORDEE DEE,
           PR_DOCUMENTO_DISTRIBUCION PDD
      WHERE DEE.NO_CIA = Pv_NoCia
      AND DEE.NO_ORDEN = Pv_NoOrden
      AND PDD.ORIGEN = 'OrdenCompra'
      AND PDD.NO_DOCU = DEE.ID_DOCUMENTO_DISTRIBUCION
      AND PDD.NO_CIA = DEE.NO_CIA;
    --
    Lr_DocDistrib NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION%ROWTYPE;
    Le_Error      EXCEPTION;
    --
  BEGIN
    --
    FOR Lr_Datos IN C_DISTRIBUCION_OC LOOP
      --
      IF NVL(Pn_DetalleCostoId,0) = 0 THEN
        Pn_DetalleCostoId := NAF47_TNET.SEQ_PR_DETALLE_DOC_DISTRIB.NEXTVAL;
      END IF;
      --
      Lr_DocDistrib.No_Cia := Pv_NoCia;
      Lr_DocDistrib.No_Docu := Pv_NoFactura;
      Lr_DocDistrib.Detalle_Distribucion_Id := Pn_DetalleCostoId;
      Lr_DocDistrib.Tipo_Ccosto_Id := Lr_Datos.Tipo_Ccosto_Id;
      Lr_DocDistrib.Tipo_Ccosto_Descripcion := Lr_Datos.Tipo_Ccosto_Descripcion;
      Lr_DocDistrib.Referencia_Id := Lr_Datos.Referencia_Id;
      Lr_DocDistrib.Referencia_Descripcion := Lr_Datos.Referencia_Descripcion;
      Lr_DocDistrib.Referencia_Padre_Id := Lr_Datos.Referencia_Padre_Id;
      Lr_DocDistrib.Origen := 'CuentasPorPagar';
      Lr_DocDistrib.Estado := 'Activo';
      --
      PRKG_CONTROL_PRESUPUESTO.P_INSERTA_DOC_DISTRIBUCION (Lr_DocDistrib,Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        --
        RAISE Le_Error;
        --
      END IF; 
      --
    END LOOP;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_REPLICA_DISTRIBUCION_CXP',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_REPLICA_DISTRIBUCION_CXP',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_REPLICA_DISTRIBUCION_CXP;
  --
  --
  PROCEDURE P_PROCESA_DISTRIBUCION (Pn_Monto        IN NUMBER,
                                    Pn_Cantidad     IN NUMBER,
                                    Pv_Origen       IN VARCHAR2,
                                    Pt_Detalle      IN NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DetalleTipoCosto,
                                    Pv_MensajeError IN OUT VARCHAR2) IS
    --
    Ln_DetalleCosto      NUMBER(6):= 0;
    Ln_CentroCostoPres   NUMBER(9) := 0;
    Ln_ValorDistribucion NUMBER(9,2):= 0;
    Ln_CostoResumen      NUMBER(9,2):= 0;
    Ln_SaldoDistribucion NUMBER(9,2):= 0;
    --
    Lv_CentroCosto       NAF47_TNET.PR_CENTRO_COSTO.CODIGO%TYPE := NULL;
    --
    Lt_DetalleCosto      Gt_DetalleTipoCosto := Gt_DetalleTipoCosto();
    --
    Lr_RefAuxiliar       TypeDetalleTipoCosto;
    Lr_Referencia        TypeDetalleTipoCosto;
    Lr_CostoResumen      NAF47_TNET.PR_COSTOS_RESUMEN%ROWTYPE;
    Lr_CostoDetalleTrx   NAF47_TNET.PR_COSTOS_DETALLE_TRX%ROWTYPE;
    --
    Lc_DatosArbol        SYS_REFCURSOR;
    --
    Le_Error             EXCEPTION;
    --
  BEGIN
    -- se calcula monto a distribuir
    Ln_ValorDistribucion := ROUND((Pn_Monto / Pn_Cantidad),2);
    Ln_SaldoDistribucion := Pn_Monto;
    Ln_CostoResumen := 0;
    --
    FOR Li_Datos IN 1..Pt_Detalle.LAST LOOP
      --
      Lv_CentroCosto := NULL;
      --
      Lt_DetalleCosto := Gt_DetalleTipoCosto();
      --
      FOR Lr_Arbol IN C_ARBOL_COSTO (Pt_Detalle(Li_Datos).NO_CIA, Pt_Detalle(Li_Datos).TIPO_DISTRIBUCION) LOOP
        --
        IF Lr_Arbol.Ultimo_Nivel = 'S' THEN
          Lv_CentroCosto                     := Pt_Detalle(Li_Datos).REFERENCIA_ID;
          Lr_RefAuxiliar.NO_CIA              := Pt_Detalle(Li_Datos).NO_CIA;
          Lr_RefAuxiliar.REFERENCIA_ID       := Pt_Detalle(Li_Datos).REFERENCIA_ID;
          Lr_RefAuxiliar.REFERENCIA_PADRE_ID := Pt_Detalle(Li_Datos).REFERENCIA_PADRE_ID;
          Ln_DetalleCosto := 1;
          --
          Lt_DetalleCosto.EXTEND;
          Lt_DetalleCosto(Ln_DetalleCosto).TIPO_CCOSTO_ID := Lr_Arbol.Id_Tipo_Ccosto;
          Lt_DetalleCosto(Ln_DetalleCosto).NO_CIA := Pt_Detalle(Li_Datos).NO_CIA;
          Lt_DetalleCosto(Ln_DetalleCosto).REFERENCIA_ID := Pt_Detalle(Li_Datos).REFERENCIA_ID;
          --
        ELSE 
          --
          OPEN Lc_DatosArbol FOR Lr_Arbol.Sentencia_Lee_Tipo 
               USING Lr_RefAuxiliar.REFERENCIA_PADRE_ID,
                     Lr_RefAuxiliar.NO_CIA;
          FETCH Lc_DatosArbol INTO Lr_Referencia.NO_CIA,
                                   Lr_Referencia.REFERENCIA_ID,
                                   Lr_Referencia.REFERENCIA_PADRE_ID;
          --
          Lv_CentroCosto := Lr_Referencia.REFERENCIA_ID ||'-'|| Lv_CentroCosto;
          --
          Ln_DetalleCosto := Ln_DetalleCosto + 1;
          Lt_DetalleCosto.EXTEND;
          Lt_DetalleCosto(Ln_DetalleCosto).TIPO_CCOSTO_ID := Lr_Arbol.Id_Tipo_Ccosto;
          Lt_DetalleCosto(Ln_DetalleCosto).NO_CIA := Lr_Referencia.NO_CIA;
          Lt_DetalleCosto(Ln_DetalleCosto).REFERENCIA_ID := Lr_Referencia.REFERENCIA_ID;
          --
          Lr_RefAuxiliar.NO_CIA              := Lr_Referencia.NO_CIA;
          Lr_RefAuxiliar.REFERENCIA_ID       := Lr_Referencia.REFERENCIA_ID;
          Lr_RefAuxiliar.REFERENCIA_PADRE_ID := Lr_Referencia.REFERENCIA_PADRE_ID;
        END IF;
        --
      END LOOP;
      --
      Ln_CentroCostoPres := F_RECUPERA_CENTRO_COSTO(Lt_DetalleCosto, Lv_CentroCosto, Pt_Detalle(Li_Datos).NO_CIA);
      --
      IF Ln_CentroCostoPres = 0 THEN
        Pv_MensajeError := 'No se pudo recuperar código de centro de costo, favor revisar distribución.';
        RAISE Le_Error;
      END IF;
      --
      --
      IF Pt_Detalle(Li_Datos).MONTO != 0 THEN
        Ln_CostoResumen := Pt_Detalle(Li_Datos).MONTO;
      ELSE
        Ln_CostoResumen := ROUND((Ln_ValorDistribucion*Pt_Detalle(Li_Datos).CANTIDAD),2);
      END IF;
      --
      Ln_SaldoDistribucion := Ln_SaldoDistribucion - Ln_CostoResumen;
      --  
      --ultima linea del arreglo se valida que no queden diferencias
      IF Li_Datos = Pt_Detalle.LAST THEN
        --si saldo no es cero se debe restar o sumar el saldo para evitar diferencias
        IF Ln_SaldoDistribucion != 0 THEN
          Ln_CostoResumen := Ln_CostoResumen + Ln_SaldoDistribucion;
        END IF;
      END IF;
      -- se busca registro en costo resumen 
      IF C_RECUPERA_COSTO_RESUMEN%ISOPEN THEN
        CLOSE C_RECUPERA_COSTO_RESUMEN;
      END IF;
      OPEN C_RECUPERA_COSTO_RESUMEN(Ln_CentroCostoPres, Pt_Detalle(Li_Datos).PERIODO);
      FETCH C_RECUPERA_COSTO_RESUMEN INTO Lr_CostoResumen.Id_Costo_Resumen;
      IF C_RECUPERA_COSTO_RESUMEN%NOTFOUND THEN
        Lr_CostoResumen.Id_Costo_Resumen := 0;
      END IF;
      CLOSE C_RECUPERA_COSTO_RESUMEN;
      --
      --
      IF Lr_CostoResumen.Id_Costo_Resumen != 0 THEN
        --
        UPDATE NAF47_TNET.PR_COSTOS_RESUMEN
        SET VALOR_COSTO = NVL(VALOR_COSTO,0) + Ln_CostoResumen,
            USR_ULT_MOD = USER,
            FE_ULT_MOD = SYSDATE
        WHERE CENTRO_COSTO_ID = Ln_CentroCostoPres
        AND PERIODO = Pt_Detalle(Li_Datos).PERIODO;
        --
      ELSE
        --
        Lr_CostoResumen.Id_Costo_Resumen := NAF47_TNET.SEQ_PR_COSTOS_RESUMEN.NEXTVAL;
        --
        Lr_CostoResumen.Centro_Costo_Id   := Ln_CentroCostoPres;
        Lr_CostoResumen.Periodo           := Pt_Detalle(Li_Datos).PERIODO;
        Lr_CostoResumen.Valor_Presupuesto := 0;
        Lr_CostoResumen.Valor_Costo       := Ln_CostoResumen;
        --
        P_INSERTA_RESUMEN_COSTO (Lr_CostoResumen, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      END IF;
      --
      IF Pv_Origen = 'Contabilidad' THEN
        Lr_CostoDetalleTrx.Llave_Transaccion := '<NO_CIA>'||Pt_Detalle(Li_Datos).NO_CIA||'</NO_CIA>'||'<NO_ASIENTO>'||Pt_Detalle(Li_Datos).NO_DOCU||'</NO_ASIENTO>';
      ELSE
        Lr_CostoDetalleTrx.Llave_Transaccion := '<NO_CIA>'||Pt_Detalle(Li_Datos).NO_CIA||'</NO_CIA>'||'<NO_DOCU>'||Pt_Detalle(Li_Datos).NO_DOCU||'</NO_DOCU>';
      END IF;
      Lr_CostoDetalleTrx.Id_Costo_Detalle_Trx :=NAF47_TNET.SEQ_PR_COSTOS_DETALLE_TRX.NEXTVAL;
      Lr_CostoDetalleTrx.Costo_Resumen_Id := Lr_CostoResumen.Id_Costo_Resumen;
      Lr_CostoDetalleTrx.Monto_Transaccion := Ln_CostoResumen;
      Lr_CostoDetalleTrx.Origen := Pv_Origen;
      Lr_CostoDetalleTrx.Estado := 'Activo';
      --
      NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.P_INSERTA_COSTO_DETALLE_TRX (Lr_CostoDetalleTrx,
                                                                       Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;

    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_PROCESA_DISTRIBUCION;
  --
  --
  PROCEDURE P_COSTEO_OC_SERVICIO ( Pv_NoDocu       IN VARCHAR2,
                                   Pv_NoCia        IN VARCHAR2,
                                   Pv_TipoProceso  IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2) IS
    CURSOR C_DOCUMENTO_RELACIONADO IS
      SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             CASE
               WHEN PDD.MONTO > 0 THEN
                 ROUND(((DO.MONTO *((DEE.TOTAL-NVL(DEE.IMP_VENTAS,0))/DEE.TOTAL)) * (PDD.MONTO/DEE.TOTAL)),2)
               ELSE
                 0
             END AS MONTO_DISTRIBUIDO,
             --
             CASE
               WHEN DEE.TIPO_DISTRIBUCION_COSTO = 'Pedido' THEN -- Cuando es Pedido el tipo de distribución a usar Administrativo
                 'Administrativo'
               ELSE
                 DEE.TIPO_DISTRIBUCION_COSTO
             END AS TIPO_DISTRIBUCION_COSTO,
             PDD.*
      FROM NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD,
           NAF47_TNET.TAPORDEE DEE,
           NAF47_TNET.ARCPMD MD,
           NAF47_TNET.CP_DOCUMENTO_ORIGEN DO
      WHERE DO.NO_DOCUMENTO = Pv_NoDocu
      AND DO.COMPANIA = Pv_NoCia
      AND DEE.TIPO_DISTRIBUCION_COSTO != 'Manual'
      AND DEE.ID_DOCUMENTO_DISTRIBUCION = PDD.NO_DOCU
      AND DEE.NO_CIA = PDD.NO_CIA
      AND DO.NO_DOCUMENTO = MD.NO_DOCU
      AND DO.COMPANIA = MD.NO_CIA
      AND DO.NO_DOCUMENTO_ORIGEN = DEE.NO_ORDEN
      AND DO.COMPANIA = DEE.NO_CIA
      UNION
      SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             --
             PDD.MONTO AS MONTO_DISTRIBUIDO,
             'Administrativo' AS TIPO_DISTRIBUCION_COSTO,
             --
             PDD.*
      FROM NAF47_TNET.ARCPMD MD,
           NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD
      WHERE MD.NO_DOCU  = Pv_NoDocu
      AND MD.NO_CIA = Pv_NoCia
      AND PDD.ORIGEN = 'CuentasPorPagar'
      AND PDD.DETALLE_DISTRIBUCION_ID IS NULL
      AND PDD.NO_DOCU = MD.NO_DOCU
      AND PDD.NO_CIA = MD.NO_CIA
      UNION
            SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             --
             DC.MONTO AS MONTO_DISTRIBUIDO,
             'Proyecto' AS TIPO_DISTRIBUCION_COSTO,
             --
             PDD.*
      FROM NAF47_TNET.ARCPMD MD,
           NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD,
           NAF47_TNET.ARCPDC DC
      WHERE MD.NO_DOCU  = Pv_NoDocu
      AND MD.NO_CIA = Pv_NoCia
      AND PDD.ORIGEN = 'CuentasPorPagar'
      AND PDD.NO_DOCU = MD.NO_DOCU
      AND PDD.NO_CIA = MD.NO_CIA
      AND DC.NO_DISTRIBUCION = PDD.ID_DOC_DISTRIBUCION
      AND DC.NO_DOCU = PDD.NO_DOCU
      AND DC.NO_CIA = PDD.NO_CIA;
    --
    Lc_Datos             SYS_REFCURSOR;
    Lr_TipoCentroCosto   C_TIPO_CENTRO_COSTO%ROWTYPE;
    Lr_Datos             TypeDetalleTipoCosto;
    Lt_DetDistribCosto   Gt_DetalleTipoCosto := Gt_DetalleTipoCosto();
    Ln_CantDistribuir    NUMBER(9):= 0;
    Ln_Indice            NUMBER(6):= 0;
    Ln_MontoDistribuir   NUMBER(9,2);
    --
    Le_Error           EXCEPTION;
    --
  BEGIN
    --
    Lt_DetDistribCosto := Gt_DetalleTipoCosto();
    --
    -- se determina la cantida de empleados que van a ser distribuidos
    --
    FOR I IN C_DOCUMENTO_RELACIONADO LOOP
      --
      Ln_MontoDistribuir := I.SUBTOTAL;
      --
      IF C_TIPO_CENTRO_COSTO%ISOPEN THEN
        CLOSE C_TIPO_CENTRO_COSTO;
      END IF;
      OPEN C_TIPO_CENTRO_COSTO (TO_NUMBER(I.TIPO_CCOSTO_ID), 'PROCESO_DISTRIBUCION_CCOSTO');
      FETCH C_TIPO_CENTRO_COSTO INTO Lr_TipoCentroCosto;
      IF C_TIPO_CENTRO_COSTO%NOTFOUND THEN
        Lr_TipoCentroCosto := NULL;
      END IF;
      CLOSE C_TIPO_CENTRO_COSTO;
      --
      IF Lr_TipoCentroCosto.Sentencia_Sql IS NULL THEN
        Pv_MensajeError := 'No se ha definido sentencia de consulta para proceso de datos, favor revisar!!!';
        RAISE Le_Error;
      END IF;
      --

      IF I.REFERENCIA_PADRE_ID IS NOT NULL THEN
        OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Sql 
            USING I.REFERENCIA_ID,
                  I.REFERENCIA_PADRE_ID,
                  I.NO_CIA;
      ELSE
        OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Sql 
            USING I.REFERENCIA_ID,
                  I.NO_CIA;
      END IF;
      --
      --
      LOOP
        FETCH Lc_Datos into Lr_Datos.NO_CIA,
                            Lr_Datos.REFERENCIA_ID,
                            Lr_Datos.REFERENCIA_PADRE_ID,
                            Lr_Datos.CANTIDAD;
        EXIT WHEN Lc_Datos%NOTFOUND;
        --
        Ln_CantDistribuir := Ln_CantDistribuir + Lr_Datos.CANTIDAD;
        --
        Ln_Indice := Ln_Indice + 1;
        Lt_DetDistribCosto.EXTEND;
        Lt_DetDistribCosto(Ln_Indice).PERIODO             := I.PERIODO;
        Lt_DetDistribCosto(Ln_Indice).NO_CIA              := Lr_Datos.NO_CIA;
        Lt_DetDistribCosto(Ln_Indice).NO_DOCU             := Pv_NoDocu;
        Lt_DetDistribCosto(Ln_Indice).TIPO_DISTRIBUCION   := I.TIPO_DISTRIBUCION_COSTO;
        Lt_DetDistribCosto(Ln_Indice).REFERENCIA_ID       := Lr_Datos.REFERENCIA_ID;
        Lt_DetDistribCosto(Ln_Indice).REFERENCIA_PADRE_ID := Lr_Datos.REFERENCIA_PADRE_ID;
        Lt_DetDistribCosto(Ln_Indice).CANTIDAD            := Lr_Datos.CANTIDAD;
        Lt_DetDistribCosto(Ln_Indice).MONTO               := I.MONTO_DISTRIBUIDO;
        --
      END LOOP;
      --
      CLOSE Lc_Datos;
      --
      --
    END LOOP;
    --
    IF Ln_CantDistribuir > 0 THEN
      PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION ( Ln_MontoDistribuir,
                                                        Ln_CantDistribuir,
                                                        'CuentasPorPagar',
                                                        Lt_DetDistribCosto,
                                                        Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_OC_SERVICIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_OC_SERVICIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_COSTEO_OC_SERVICIO;
  --
  --
  PROCEDURE P_COSTEO_PEDIDO_SERVICIO ( Pv_NoDocu       IN VARCHAR2,
                                       Pv_NoCia        IN VARCHAR2,
                                       Pv_TipoProceso  IN VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2) IS
    -- 
    CURSOR C_DOCUMENTO_RELACIONADO IS
      SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             DEE.TIPO_DISTRIBUCION_COSTO,
             DEE.NO_ORDEN,
             DO.MONTO,
             NVL(MD.GRAVADO,0) + NVL(MD.EXCENTOS,0) + NVL(MD.TOT_IMP,0) AS TOTAL,
             CASE 
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0) + NVL(MD.EXCENTOS,0)
               ELSE
                 (NVL(MD.GRAVADO,0) + NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL
      FROM NAF47_TNET.TAPORDEE DEE,
           NAF47_TNET.ARCPMD MD,
           NAF47_TNET.CP_DOCUMENTO_ORIGEN DO
      WHERE DO.NO_DOCUMENTO = Pv_NoDocu
      AND DO.COMPANIA = Pv_NoCia
      AND DEE.TIPO_DISTRIBUCION_COSTO = 'Pedido'
      AND DO.NO_DOCUMENTO = MD.NO_DOCU
      AND DO.COMPANIA = MD.NO_CIA
      AND DO.NO_DOCUMENTO_ORIGEN = DEE.NO_ORDEN
      AND DO.COMPANIA = DEE.NO_CIA;
    --
    CURSOR C_DETALLE_PEDIDO ( Cn_OrdenCompraId NUMBER ) IS
      SELECT VE.NO_CIA,
             VE.DEPTO AS REFERENCIA_ID, 

             IOG.CANTON_ID AS REFERENCIA_PADRE_ID,
             1 AS CANTIDAD,
             SUM(ISD.SUBTOTAL) AS MONTO
      FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
           NAF47_TNET.V_EMPLEADOS_EMPRESAS VE,
           DB_COMPRAS.ADMI_EMPRESA AE,
           DB_COMPRAS.ADMI_DEPARTAMENTO AD,
           DB_COMPRAS.INFO_PEDIDO IP,
           DB_COMPRAS.INFO_PEDIDO_DETALLE IPD,
           DB_COMPRAS.INFO_SOLICITUD_DETALLE ISD,
           DB_COMPRAS.INFO_ORDEN_COMPRA IOC
      WHERE IOC.SECUENCIA = Cn_OrdenCompraId
      AND AE.CODIGO = Pv_NoCia
      AND VE.OFICINA = IOG.ID_OFICINA
      AND IPD.USR_ASIGNADO_ID = VE.NO_EMPLE
      AND AE.CODIGO = VE.NO_CIA
      AND AD.EMPRESA_ID = AE.ID_EMPRESA
      AND IP.DEPARTAMENTO_ID = AD.ID_DEPARTAMENTO
      AND IPD.PEDIDO_ID = IP.ID_PEDIDO
      AND ISD.PEDIDO_DETALLE_ID = IPD.ID_PEDIDO_DETALLE
      AND IOC.ID_ORDEN_COMPRA = ISD.ORDEN_COMPRA_ID
      GROUP BY VE.NO_CIA,
               VE.DEPTO, 
               IOG.CANTON_ID;
    --
    Ln_Indice            NUMBER(6):= 0;
    Ln_Porcentaje        NUMBER;
    Ln_CantDistribuir    NUMBER(6):= 0;
    Ln_SaldoDistribucion NUMBER(9,2):= 0;
    Ln_MontoDistribuir   NUMBER(9,2):= 0;
    --
    Lt_DetDistribCosto Gt_DetalleTipoCosto := Gt_DetalleTipoCosto();
    --
    Le_Error EXCEPTION;
    --
  BEGIN 
    --
    FOR Lr_Datos IN C_DOCUMENTO_RELACIONADO LOOP
      --
      -- la factura abarca el 100% de la oc
      IF Lr_Datos.Total >= Lr_Datos.Monto THEN
        Ln_Porcentaje := 1;
      ELSE -- La factura solo paga una parte de la oc
        Ln_Porcentaje := Lr_Datos.Monto / Lr_Datos.Total;
      END IF;  
      --
      Ln_SaldoDistribucion := ROUND((Lr_Datos.Subtotal * Ln_Porcentaje),2);
      Ln_MontoDistribuir := Ln_MontoDistribuir + Ln_SaldoDistribucion;
      --
      FOR Lr_DetPedido IN C_DETALLE_PEDIDO (Lr_Datos.NO_ORDEN) LOOP
        --
        Ln_Indice := Ln_Indice + 1;
        Ln_CantDistribuir := Ln_CantDistribuir + Lr_DetPedido.CANTIDAD;
        Lt_DetDistribCosto.EXTEND;
        Lt_DetDistribCosto(Ln_Indice).PERIODO             := Lr_Datos.PERIODO;
        Lt_DetDistribCosto(Ln_Indice).NO_CIA              := Lr_DetPedido.NO_CIA;
        Lt_DetDistribCosto(Ln_Indice).NO_DOCU             := Pv_NoDocu;
        Lt_DetDistribCosto(Ln_Indice).TIPO_DISTRIBUCION   := Lr_Datos.Tipo_Distribucion_Costo;
        Lt_DetDistribCosto(Ln_Indice).REFERENCIA_ID       := Lr_DetPedido.REFERENCIA_ID;
        Lt_DetDistribCosto(Ln_Indice).REFERENCIA_PADRE_ID := Lr_DetPedido.REFERENCIA_PADRE_ID;
        Lt_DetDistribCosto(Ln_Indice).CANTIDAD            := Lr_DetPedido.CANTIDAD;
        Lt_DetDistribCosto(Ln_Indice).MONTO               := ROUND(Lr_DetPedido.MONTO * Ln_Porcentaje,2);

        --
        Ln_SaldoDistribucion := Ln_SaldoDistribucion - Lt_DetDistribCosto(Ln_Indice).CANTIDAD;
        --
      END LOOP;
      --
      -- Si saldo dsitribucion tiene valor entonces la distribucion tiene diferencias, saldo dsitribucion debe ser cero siempre
      Lt_DetDistribCosto(Ln_Indice).CANTIDAD := Lt_DetDistribCosto(Ln_Indice).CANTIDAD + Ln_SaldoDistribucion;
      --
    END LOOP;
    --
    --
    IF nvl(Ln_Indice,0) > 0 THEN
      PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION ( Ln_MontoDistribuir,
                                                        Ln_CantDistribuir,
                                                        'CuentasPorPagar',
                                                        Lt_DetDistribCosto,
                                                        Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;    
    --
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_PEDIDO_SERVICIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_PEDIDO_SERVICIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_COSTEO_PEDIDO_SERVICIO;
  --
  --
  PROCEDURE P_COSTEO_PEDIDO_BIENES ( Pv_NoDocu       IN VARCHAR2,
                                     Pv_NoCia        IN VARCHAR2,
                                     Pv_MensajeError OUT VARCHAR2) IS
    --
    CURSOR C_DOCUMENTO IS
      SELECT PL.NO_CIA,
             PL.DEPTO REFERENCIA_ID,
             IOG.CANTON_ID REFERENCIA_PADRE_ID,
             TRIM(TO_CHAR(ME.FECHA,'YYYYMM')) AS PERIODO,
             1 CANTIDAD,
             'Administrativo' AS TIPO_DISTRIBUCION,
             SUM(DC.MONTO*DECODE(DC.TIPO_MOV, 'D', 1, -1)) MONTO  
      FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
           NAF47_TNET.ARPLME PL,
           NAF47_TNET.ARINME ME,
           NAF47_TNET.ARINDC DC
      WHERE DC.NO_DOCU = Pv_NoDocu
      AND DC.NO_CIA = Pv_NoCia
      AND DC.CENTRO_COSTO != '000000000'
      AND PL.OFICINA = IOG.ID_OFICINA
      AND ME.EMPLE_SOLIC = PL.NO_EMPLE
      AND ME.NO_CIA_RESPONSABLE = PL.NO_CIA
      AND DC.NO_DOCU = ME.NO_DOCU
      AND DC.NO_CIA = ME.NO_CIA
      GROUP BY PL.NO_CIA,
               PL.DEPTO,
               IOG.CANTON_ID,
               ME.FECHA;
    --
    Lt_DetDistribCosto Gt_DetalleTipoCosto := Gt_DetalleTipoCosto();
    --
    Ln_Indice          NUMBER(6):= 0;
    Ln_MontoDistribuir NUMBER(12,2):= 0;
    Ln_CantidadDistrib NUMBER(6):= 0;
    --
    Le_Error  EXCEPTION;
    --
  BEGIN
    --
    FOR Lr_Datos IN C_DOCUMENTO LOOP
        --
        Ln_Indice := Ln_Indice + 1;
        --
        Lt_DetDistribCosto.EXTEND;
        Lt_DetDistribCosto(Ln_Indice).PERIODO             := Lr_Datos.PERIODO;
        Lt_DetDistribCosto(Ln_Indice).NO_DOCU             := Pv_NoDocu;
        Lt_DetDistribCosto(Ln_Indice).NO_CIA              := Pv_NoCia;
        Lt_DetDistribCosto(Ln_Indice).REFERENCIA_ID       := Lr_Datos.REFERENCIA_ID;
        Lt_DetDistribCosto(Ln_Indice).REFERENCIA_PADRE_ID := Lr_Datos.REFERENCIA_PADRE_ID;
        Lt_DetDistribCosto(Ln_Indice).CANTIDAD            := Lr_Datos.CANTIDAD;
        Lt_DetDistribCosto(Ln_Indice).TIPO_DISTRIBUCION   := Lr_Datos.TIPO_DISTRIBUCION;
        --
        Ln_MontoDistribuir := NVL(Ln_MontoDistribuir,0) + Lr_Datos.Monto;
        Ln_CantidadDistrib := NVL(Ln_CantidadDistrib,0) + Lr_Datos.CANTIDAD;
        --
    END LOOP;
    --
    --
    IF Ln_Indice > 0 THEN
      PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION ( Ln_MontoDistribuir,
                                                        Ln_CantidadDistrib,
                                                        'Inventarios',
                                                        Lt_DetDistribCosto,
                                                        Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;
    --

  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_PEDIDO_BIENES',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_PEDIDO_BIENES',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_COSTEO_PEDIDO_BIENES;
  --
  --
  PROCEDURE P_DETALLE_CENTRO_COSTO ( Pn_DetalleDistribId IN NUMBER,
                                     Pv_NoDocumento      IN VARCHAR2,
                                     Pv_Origen           IN VARCHAR2,
                                     Pv_NoCia            IN VARCHAR2,
                                     Pn_NumDistribuir    IN OUT NUMBER,
                                     Pt_DistribContable  IN OUT NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DistribContable,
                                     Pv_MensajeError     IN OUT VARCHAR2) IS
    --
    CURSOR C_DISTRIBUCION_CUENTA IS
      SELECT *
      FROM PR_DOCUMENTO_DISTRIBUCION PDD
      WHERE PDD.DETALLE_DISTRIBUCION_ID = Pn_DetalleDistribId
      AND PDD.NO_DOCU = Pv_NoDocumento
      AND PDD.ORIGEN = Pv_Origen
      AND PDD.NO_CIA = Pv_NoCia
      UNION
      SELECT *
      FROM PR_DOCUMENTO_DISTRIBUCION PDD
      WHERE PDD.DETALLE_DISTRIBUCION_ID IS NULL
      AND PDD.NO_DOCU = Pv_NoDocumento
      AND PDD.ORIGEN = Pv_Origen
      AND PDD.NO_CIA = Pv_NoCia;

    --
    Lc_Datos             SYS_REFCURSOR;
    --
    Lr_TipoCentroCosto   C_TIPO_CENTRO_COSTO%ROWTYPE;
    Lr_Datos             TypeDistribContable;
    --  
    Ln_Indice            NUMBER(6) := 0;
    Ln_IndiceAux         NUMBER(6) := 0;
    Lb_Encontro          BOOLEAN := FALSE;
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    Pn_NumDistribuir := 0;
    Pt_DistribContable := NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DistribContable();
    --
    FOR Lr_DistContable IN C_DISTRIBUCION_CUENTA LOOP
      --
      IF C_TIPO_CENTRO_COSTO%ISOPEN THEN
        CLOSE C_TIPO_CENTRO_COSTO;
      END IF;
      OPEN C_TIPO_CENTRO_COSTO (TO_NUMBER(Lr_DistContable.TIPO_CCOSTO_ID),'DISTRIBUCION_CONTABLE');
      FETCH C_TIPO_CENTRO_COSTO INTO Lr_TipoCentroCosto;
      IF C_TIPO_CENTRO_COSTO%NOTFOUND THEN
        Lr_TipoCentroCosto := NULL;
      END IF;
      CLOSE C_TIPO_CENTRO_COSTO;
      --
      IF Lr_TipoCentroCosto.Sentencia_Sql IS NULL THEN
        Pv_MensajeError := 'No se ha definido sentencia de consulta para proceso de datos, favor revisar!!!';
        RAISE Le_Error;
      END IF;
      --
      IF Lr_DistContable.REFERENCIA_PADRE_ID IS NOT NULL THEN
        OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Sql 
            USING Lr_DistContable.REFERENCIA_ID,
                  Lr_DistContable.REFERENCIA_PADRE_ID,
                  Lr_DistContable.NO_CIA;
      ELSE
        OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Sql 
            USING Lr_DistContable.REFERENCIA_ID,
                  Lr_DistContable.NO_CIA;
      END IF;
      --
      --
      LOOP
        FETCH Lc_Datos into Lr_Datos;
        EXIT WHEN Lc_Datos%NOTFOUND;
        --
        Pn_NumDistribuir := Pn_NumDistribuir + Lr_Datos.CANTIDAD;
        --
        Ln_IndiceAux := 1;
        Lb_Encontro := FALSE;
        --
        WHILE Ln_indiceAux <= Ln_Indice AND NOT Lb_Encontro LOOP
          --
          IF Pt_DistribContable(Ln_IndiceAux).CENTRO_COSTO_ID = Lr_Datos.CENTRO_COSTO_ID THEN
            Lb_Encontro := TRUE;
          ELSE
            Ln_indiceAux := Ln_indiceAux + 1;
          END IF;
          --
        END LOOP;
        --
        IF Lb_Encontro THEN
          Pt_DistribContable(Ln_indiceAux).CANTIDAD := Pt_DistribContable(Ln_indiceAux).CANTIDAD + Lr_Datos.CANTIDAD;
        ELSE
          Ln_Indice := Ln_Indice + 1;
          Pt_DistribContable.EXTEND;
          Pt_DistribContable(Ln_Indice).NO_CIA          := Lr_Datos.NO_CIA;
          Pt_DistribContable(Ln_Indice).CC_1            := Lr_Datos.CC_1;
          Pt_DistribContable(Ln_Indice).CC_2            := Lr_Datos.CC_2;
          Pt_DistribContable(Ln_Indice).CC_3            := Lr_Datos.CC_3;
          Pt_DistribContable(Ln_Indice).CENTRO_COSTO_ID := Lr_Datos.CENTRO_COSTO_ID;
          Pt_DistribContable(Ln_Indice).CANTIDAD        := Lr_Datos.CANTIDAD;
        END IF;
        --
      END LOOP;
      --
      CLOSE Lc_Datos;
      --
    END LOOP;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_DETALLE_CENTRO_COSTO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_DETALLE_CENTRO_COSTO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_DETALLE_CENTRO_COSTO;
  --
  --
  PROCEDURE P_COSTEO_ASIENTO_CONTABLE ( Pv_NoDocu      IN VARCHAR2,
                                        Pv_NoCia        IN VARCHAR2,
                                        Pv_MensajeError IN OUT VARCHAR2)  IS
    --
    CURSOR C_DETALLE_ASIENTO IS
      SELECT AL.NO_CIA,
             AL.NO_ASIENTO,
             AL.NO_DISTRIBUCION,
             AL.ANO||LPAD(AL.MES,2,'0') PERIODO,
             'Administrativo' AS TIPO_DISTRIBUCION,
             SUM(AL.MONTO) MONTO
      FROM NAF47_TNET.ARCGAL AL
      WHERE AL.NO_CIA = Pv_NoCia
      AND AL.NO_ASIENTO = Pv_NoDocu
      AND AL.CC_1 != '000'
      AND AL.CC_2 != '000'
      AND AL.CC_3 != '000'
      AND AL.NO_DISTRIBUCION IS NOT NULL
      GROUP BY AL.NO_CIA,
               AL.NO_ASIENTO,
               AL.NO_DISTRIBUCION,
               AL.ANO,
               AL.MES
      UNION
      SELECT AL.NO_CIA,
             AL.NO_ASIENTO,
             AL.NO_DISTRIBUCION,
             AL.ANO||LPAD(AL.MES,2,'0') PERIODO,
             'Proyecto' AS TIPO_DISTRIBUCION,
             SUM(AL.MONTO) MONTO
      FROM NAF47_TNET.ARCGAL AL
      WHERE AL.NO_CIA = Pv_NoCia
      AND AL.NO_ASIENTO = Pv_NoDocu
      AND AL.CC_1 = '000'
      AND AL.CC_2 = '000'
      AND AL.CC_3 = '000'
      AND AL.NO_DISTRIBUCION IS NOT NULL
      GROUP BY AL.NO_CIA,
               AL.NO_ASIENTO,
               AL.NO_DISTRIBUCION,
               AL.ANO,
               AL.MES
      ;
    --
    CURSOR C_DISTRIBUCION_COSTO (Cv_DetalleId NUMBER,
                                 Cv_NoAsiento VARCHAR2,
                                 Cv_NoCia     VARCHAR2) IS
      SELECT *
      FROM NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD
      WHERE PDD.NO_CIA = Cv_NoCia
      AND PDD.NO_DOCU = Cv_NoAsiento
      AND PDD.DETALLE_DISTRIBUCION_ID = Cv_DetalleId
      UNION
      SELECT *
      FROM NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD
      WHERE PDD.NO_CIA = Cv_NoCia
      AND PDD.NO_DOCU = Cv_NoAsiento
      AND PDD.ID_DOC_DISTRIBUCION = Cv_DetalleId
      ;
    --
    Ln_CantDistribuir    NUMBER(6) := 0;
    Ln_Indice            NUMBER(6);
    Ln_ValorDistribucion NUMBER(9,2):= 0;
    --
    Lr_TipoCentroCosto   C_TIPO_CENTRO_COSTO%ROWTYPE;
    Lr_Datos             TypeDetalleTipoCosto;
    --
    Lc_Datos             SYS_REFCURSOR;
    --
    Lt_DetDistribCosto   Gt_DetalleTipoCosto := Gt_DetalleTipoCosto();
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    --
    FOR Lr_DetAsiento IN C_DETALLE_ASIENTO LOOP
      --
      Lt_DetDistribCosto := Gt_DetalleTipoCosto();
      Ln_Indice := 0;
      --
      FOR I IN C_DISTRIBUCION_COSTO (Lr_DetAsiento.No_Distribucion,
                                     Lr_DetAsiento.No_Asiento,
                                     Lr_DetAsiento.No_Cia) LOOP
        --
        IF C_TIPO_CENTRO_COSTO%ISOPEN THEN
          CLOSE C_TIPO_CENTRO_COSTO;
        END IF;
        OPEN C_TIPO_CENTRO_COSTO (TO_NUMBER(I.TIPO_CCOSTO_ID), 'PROCESO_DISTRIBUCION_CCOSTO');
        FETCH C_TIPO_CENTRO_COSTO INTO Lr_TipoCentroCosto;
        IF C_TIPO_CENTRO_COSTO%NOTFOUND THEN
          Lr_TipoCentroCosto := NULL;
        END IF;
        CLOSE C_TIPO_CENTRO_COSTO;
        --
        IF Lr_TipoCentroCosto.Sentencia_Sql IS NULL THEN
          Pv_MensajeError := 'No se ha definido sentencia de consulta para proceso de datos, favor revisar!!!';
          RAISE Le_Error;
        END IF;
        --
        IF I.REFERENCIA_PADRE_ID IS NOT NULL THEN
          OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Sql 
              USING I.REFERENCIA_ID,
                    I.REFERENCIA_PADRE_ID,
                    I.NO_CIA;
        ELSE
          OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Sql 
              USING I.REFERENCIA_ID,
                    I.NO_CIA;
        END IF;
        --
        --
        LOOP
          FETCH Lc_Datos into Lr_Datos.NO_CIA,
                              Lr_Datos.REFERENCIA_ID,
                              Lr_Datos.REFERENCIA_PADRE_ID,
                              Lr_Datos.CANTIDAD;
          EXIT WHEN Lc_Datos%NOTFOUND;
          --
          Ln_CantDistribuir := Ln_CantDistribuir + Lr_Datos.CANTIDAD;
          --
          Ln_Indice := Ln_Indice + 1;
          Lt_DetDistribCosto.EXTEND;
          Lt_DetDistribCosto(Ln_Indice).PERIODO             := Lr_DetAsiento.PERIODO;
          Lt_DetDistribCosto(Ln_Indice).NO_CIA              := Lr_Datos.NO_CIA;
          Lt_DetDistribCosto(Ln_Indice).NO_DOCU             := Pv_NoDocu;
          Lt_DetDistribCosto(Ln_Indice).TIPO_DISTRIBUCION   := Lr_DetAsiento.TIPO_DISTRIBUCION;
          Lt_DetDistribCosto(Ln_Indice).REFERENCIA_ID       := Lr_Datos.REFERENCIA_ID;
          Lt_DetDistribCosto(Ln_Indice).REFERENCIA_PADRE_ID := Lr_Datos.REFERENCIA_PADRE_ID;
          Lt_DetDistribCosto(Ln_Indice).CANTIDAD            := Lr_Datos.CANTIDAD;
          Lt_DetDistribCosto(Ln_Indice).MONTO               := Lr_Datos.MONTO;
          --
        END LOOP;
        --
        CLOSE Lc_Datos;
        --
      END LOOP;
      --
      Ln_ValorDistribucion := Lr_DetAsiento.Monto;
      --
      IF Ln_CantDistribuir > 0 THEN
        PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION ( Ln_ValorDistribucion,
                                                          Ln_CantDistribuir,
                                                          'Contabilidad',
                                                          Lt_DetDistribCosto,
                                                          Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END IF;
      --
    END LOOP;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_ASIENTO_CONTABLE',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_ASIENTO_CONTABLE',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_COSTEO_ASIENTO_CONTABLE;
  --
  --
  PROCEDURE P_DISTRIBUCION_COSTO_FACTURA ( Pv_NoDocu       IN VARCHAR2,
                                           Pv_NoCia        IN VARCHAR2,
                                           Pv_TipoProceso  IN VARCHAR2,
                                           Pv_MensajeError IN OUT VARCHAR2) IS

  CURSOR C_DOCUMENTO_RELACIONADO IS
      SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             CASE
               WHEN PDD.MONTO > 0 THEN
                 ROUND(((DO.MONTO *((DEE.TOTAL-NVL(DEE.IMP_VENTAS,0))/DEE.TOTAL)) * (PDD.MONTO/DEE.TOTAL)),2)
               ELSE
                 0
             END AS MONTO_DISTRIBUIDO,
             --
             CASE
               WHEN DEE.TIPO_DISTRIBUCION_COSTO = 'Pedido' THEN -- Cuando es Pedido el tipo de distribucion a usar Administrativo
                 'Administrativo'
               ELSE
                 DEE.TIPO_DISTRIBUCION_COSTO
             END AS TIPO_DISTRIBUCION_COSTO,
             PDD.*
      FROM NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD,
           NAF47_TNET.TAPORDEE DEE,
           NAF47_TNET.ARCPMD MD,
           NAF47_TNET.CP_DOCUMENTO_ORIGEN DO
      WHERE DO.NO_DOCUMENTO = Pv_NoDocu
      AND DO.COMPANIA = Pv_NoCia
      AND DEE.TIPO_DISTRIBUCION_COSTO != 'Manual'
      AND DEE.ID_DOCUMENTO_DISTRIBUCION = PDD.NO_DOCU
      AND DEE.NO_CIA = PDD.NO_CIA
      AND DO.NO_DOCUMENTO = MD.NO_DOCU
      AND DO.COMPANIA = MD.NO_CIA
      AND DO.NO_DOCUMENTO_ORIGEN = DEE.NO_ORDEN
      AND DO.COMPANIA = DEE.NO_CIA
      UNION
      SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             --
             PDD.MONTO AS MONTO_DISTRIBUIDO,
             'Administrativo' AS TIPO_DISTRIBUCION_COSTO,
             --
             PDD.*
      FROM NAF47_TNET.ARCPMD MD,
           NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD
      WHERE MD.NO_DOCU  = Pv_NoDocu
      AND MD.NO_CIA = Pv_NoCia
      AND PDD.ORIGEN = 'CuentasPorPagar'
      AND PDD.DETALLE_DISTRIBUCION_ID IS NULL
      AND PDD.NO_DOCU = MD.NO_DOCU
      AND PDD.NO_CIA = MD.NO_CIA
      UNION
            SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             --
             DC.MONTO AS MONTO_DISTRIBUIDO,
             'Proyecto' AS TIPO_DISTRIBUCION_COSTO,
             --
             PDD.*
      FROM NAF47_TNET.ARCPMD MD,
           NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD,
           NAF47_TNET.ARCPDC DC
      WHERE MD.NO_DOCU  = Pv_NoDocu
      AND MD.NO_CIA = Pv_NoCia
      AND PDD.ORIGEN = 'CuentasPorPagar'
      AND PDD.NO_DOCU = MD.NO_DOCU
      AND PDD.NO_CIA = MD.NO_CIA
      AND DC.NO_DISTRIBUCION = PDD.ID_DOC_DISTRIBUCION
      AND DC.NO_DOCU = PDD.NO_DOCU
      AND DC.NO_CIA = PDD.NO_CIA
      AND ROWNUM =1;

  Lc_DocRelacionado   C_DOCUMENTO_RELACIONADO%ROWTYPE;
  Lb_Existe BOOLEAN := FALSE;
  BEGIN
    --
    OPEN C_DOCUMENTO_RELACIONADO;
    FETCH C_DOCUMENTO_RELACIONADO INTO Lc_DocRelacionado;
     IF C_DOCUMENTO_RELACIONADO%FOUND THEN
       Lb_Existe :=TRUE;
     END IF;
    CLOSE C_DOCUMENTO_RELACIONADO;

    IF Lb_Existe THEN
      IF Lc_DocRelacionado.Tipo_Distribucion_Costo ='Proyecto' THEN
         P_COSTEO_OC_SERVICIO_PRO ( Pv_NoDocu,
                                    Pv_NoCia,
                                    Pv_TipoProceso,
                                    Pv_MensajeError);

      ELSE

        P_COSTEO_OC_SERVICIO ( Pv_NoDocu,
                               Pv_NoCia,
                               Pv_TipoProceso,
                               Pv_MensajeError);
      END IF; 
    END IF;                         
    --
    --
  END P_DISTRIBUCION_COSTO_FACTURA;
  --
  --
  PROCEDURE P_ASIGNA_COSTEO_BIENES ( Pv_NoDocu       IN VARCHAR2,
                                     Pv_LoginAux      IN VARCHAR2,
                                     Pv_Periodo       IN VARCHAR2,
                                     Pn_Monto         IN NUMBER,
                                     Pv_NoCia         IN VARCHAR2,
                                     Pa_DatosCosteo   IN OUT Gt_DetalleTipoCosto,
                                     Pv_MensajeError  IN OUT VARCHAR2) IS
  --
  CURSOR C_ULTIMO_NIVEL_PROYECTO IS
    SELECT APD.ID_PARAMETRO_DET AS TIPO_CCOSTO_ID,
           APD.VALOR2 AS DESCRIPCION
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.DESCRIPCION = TIPO_CENTRO_COSTO --  parametro tipo de centro de costos 
    AND APD.VALOR7 =  NAF47_TNET.GEK_VAR.Gr_IndSimple.SI-- nivel de asignacion (ultimo Nivel)
    AND APD.EMPRESA_COD = Pv_NoCia
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                WHERE APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO -- dentro de parametro de control de costo
                AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                AND APC.ID_PARAMETRO = APD.PARAMETRO_ID) 
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_DET CCC
                WHERE CCC.DESCRIPCION = CLASE_CENTRO_COSTO -- clase de centro de costos definidos
                AND CCC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                AND CCC.VALOR3 = PROYECTO -- clase proyecto
                AND EXISTS (SELECT NULL
                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCC
                            WHERE APCC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO -- dentro de parametro de control de costo
                            AND APCC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                            AND APCC.ID_PARAMETRO = CCC.PARAMETRO_ID)
                AND CCC.VALOR2 = TO_CHAR(APD.ID_PARAMETRO_DET))
    ORDER BY TO_NUMBER(APD.VALOR3) DESC;  
  --
  CURSOR C_DATOS_COSTEO IS
    SELECT IER.EMPRESA_COD AS NO_CIA,
           TO_NUMBER(ISPC.VALOR) AS PROYECTO_ID,
           AP.LINEA_NEGOCIO AS NOMBRE_VERTICAL,
           --
           ( SELECT APD.ID_PARAMETRO_DET
             FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
             WHERE APD.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
             AND APD.DESCRIPCION = AP.LINEA_NEGOCIO
             AND EXISTS (SELECT NULL
                         FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                         WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                         AND APC.NOMBRE_PARAMETRO = VERTICALES --LINEA_NEGOCIO
                         AND APC.ESTADO = GEK_VAR.Gr_Estado.ACTIVO)) AS VERTICAL_ID,
           --
           (SELECT AR.ID_PARAMETRO_DET
            FROM DB_GENERAL.ADMI_PARAMETRO_DET AR,
                 DB_GENERAL.ADMI_PARAMETRO_DET ARJ,
                 DB_INFRAESTRUCTURA.ADMI_JURISDICCION AJ,
                 DB_INFRAESTRUCTURA.ADMI_CANTON_JURISDICCION ACJ,
                 DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
            WHERE AJ.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
            AND AR.DESCRIPCION = DIVISION_REGIONAL
            AND ARJ.DESCRIPCION = DIV_REGION_JURISDIC
            AND IOG.ID_OFICINA = IPER.OFICINA_ID 
            AND ARJ.VALOR2 = AR.ID_PARAMETRO_DET
            AND AJ.ID_JURISDICCION = ARJ.VALOR3
            AND ACJ.JURISDICCION_ID = AJ.ID_JURISDICCION
            AND IOG.CANTON_ID = ACJ.CANTON_ID
            GROUP BY AR.ID_PARAMETRO_DET
            ) AS REGION_ID
    FROM DB_COMERCIAL.ADMI_PRODUCTO AP,
         DB_COMERCIAL.ADMI_CARACTERISTICA AC,
         DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
         DB_COMERCIAL.INFO_EMPRESA_ROL IER,
         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
         DB_COMERCIAL.INFO_PUNTO IP,
         DB_COMERCIAL.INFO_SERVICIO ISE,
         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC
    WHERE APC.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
    AND ISPC.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
    AND AC.DESCRIPCION_CARACTERISTICA = CARACT_PROYECTO
    AND ISE.LOGIN_AUX = Pv_LoginAux
    AND IER.EMPRESA_COD = Pv_NoCia
    AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
    AND APC.PRODUCTO_ID = AP.ID_PRODUCTO
    AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
    AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND ISE.PUNTO_ID = IP.ID_PUNTO
    AND ISPC.SERVICIO_ID = ISE.ID_SERVICIO
    AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA;
    --
    CURSOR C_DATOS_PROYECTO_VERTICAL (Cn_VerticalId NUMBER,
                                      Cn_ProyectoId NUMBER) IS
      SELECT APC.ID_PROYECTO_CUENTA AS REFERENCIA_ID,
             APC.CUENTA_ID AS CUENTA_CONTABLE_ID
      FROM NAF47_TNET.ADMI_PROYECTO_CUENTA APC
      WHERE APC.VERTICAL_ID  = Cn_VerticalId
      AND APC.PROYECTO_ID = Cn_ProyectoId
      AND APC.NO_CIA_CUENTA = Pv_NoCia
      AND APC.ESTADO = GEK_VAR.Gr_Estado.ACTIVO;
    --
    CURSOR C_DATOS_PROYECTO_REGION ( Cn_ProyectoId NUMBER,
                                     Cn_RegionId   NUMBER) IS
      SELECT APR.ID_PROYECTO_REGION AS REFERENCIA_PADRE_ID
      FROM ADMI_PROYECTO_REGION APR
      WHERE APR.PROYECTO_ID = Cn_ProyectoId
      AND APR.REGION_ID = Cn_RegionId
      AND APR.ESTADO = GEK_VAR.Gr_Estado.ACTIVO;
    --
    Le_Error           EXCEPTION;
    Lr_DatosCosteo     TypeDetalleTipoCosto;
    Ln_Indice          NUMBER(6) := 0;
    --
    Lr_UltimoNivel      C_ULTIMO_NIVEL_PROYECTO%ROWTYPE;
    Lr_ProyectoVertical C_DATOS_PROYECTO_VERTICAL%ROWTYPE;
    Lr_ProyectoRegion   C_DATOS_PROYECTO_REGION%ROWTYPE;
    --
  BEGIN
    --
    Pa_DatosCosteo := Gt_DetalleTipoCosto();
    -- se verifica ultimo nivel de árbol proyecto
    IF C_ULTIMO_NIVEL_PROYECTO%ISOPEN THEN
      CLOSE C_ULTIMO_NIVEL_PROYECTO;
    END IF;
    OPEN C_ULTIMO_NIVEL_PROYECTO;
    FETCH C_ULTIMO_NIVEL_PROYECTO INTO Lr_UltimoNivel;
    IF C_ULTIMO_NIVEL_PROYECTO%NOTFOUND THEN
      Pv_MensajeError := 'No se ha definido nivel de asignación en los tipos de centro de costos por '||PROYECTO;
      RAISE Le_Error;
    END IF;
    CLOSE C_ULTIMO_NIVEL_PROYECTO;
    --
    FOR Lr_DatosCosteo IN C_DATOS_COSTEO LOOP
        --
        --  se determina cual es la referencia id con la que se trabajaria en base a los datos ecuperados de proyecyo y vertical
        IF C_DATOS_PROYECTO_VERTICAL%ISOPEN THEN
          CLOSE C_DATOS_PROYECTO_VERTICAL;
        END IF;
        OPEN C_DATOS_PROYECTO_VERTICAL(Lr_DatosCosteo.Vertical_Id, Lr_DatosCosteo.Proyecto_Id) ;
        FETCH C_DATOS_PROYECTO_VERTICAL INTO Lr_ProyectoVertical;
        IF C_DATOS_PROYECTO_VERTICAL%NOTFOUND THEN
          Pv_MensajeError := 'No se ha definido vertical: '||Lr_DatosCosteo.NOMBRE_VERTICAL||' para proyecto: '||Lr_DatosCosteo.PROYECTO_ID;
          RAISE Le_Error;
        END IF;
        CLOSE C_DATOS_PROYECTO_VERTICAL;  
        --
        --
        IF Lr_ProyectoVertical.Cuenta_Contable_Id IS NULL THEN
          Pv_MensajeError := 'No se ha definido cuenta contable para Proyecto: '||Lr_DatosCosteo.Proyecto_Id||' para vertical: '||Lr_DatosCosteo.NOMBRE_VERTICAL;
          RAISE Le_Error;
        END IF;
        --
        -- Se busca referencia padre
        IF C_DATOS_PROYECTO_REGION%ISOPEN THEN
          CLOSE C_DATOS_PROYECTO_REGION;
        END IF;
        OPEN C_DATOS_PROYECTO_REGION(Lr_DatosCosteo.Proyecto_Id, Lr_DatosCosteo.Region_Id) ;
        FETCH C_DATOS_PROYECTO_REGION INTO Lr_ProyectoRegion;
        IF C_DATOS_PROYECTO_REGION%NOTFOUND THEN
          Pv_MensajeError := 'No se ha definido vertical: '||Lr_DatosCosteo.NOMBRE_VERTICAL||' para proyecto: '||Lr_DatosCosteo.PROYECTO_ID;
          RAISE Le_Error;
        END IF;
        CLOSE C_DATOS_PROYECTO_REGION;      
        --
        Ln_Indice := Ln_Indice + 1;
        Pa_DatosCosteo.EXTEND;

        Pa_DatosCosteo(Ln_Indice).NO_CIA              := Lr_DatosCosteo.No_Cia;
        Pa_DatosCosteo(Ln_Indice).PERIODO             := Pv_Periodo;
        Pa_DatosCosteo(Ln_Indice).NO_DOCU             := Pv_NoDocu;
        Pa_DatosCosteo(Ln_Indice).TIPO_CCOSTO_ID      := Lr_UltimoNivel.TIPO_CCOSTO_ID;
        Pa_DatosCosteo(Ln_Indice).CANTIDAD            := 1;
        Pa_DatosCosteo(Ln_Indice).TIPO_DISTRIBUCION   := PROYECTO;
        Pa_DatosCosteo(Ln_Indice).REFERENCIA_ID       := Lr_ProyectoVertical.Referencia_Id;
        Pa_DatosCosteo(Ln_Indice).CUENTA_CONTABLE_ID  := Lr_ProyectoVertical.Cuenta_Contable_Id;
        Pa_DatosCosteo(Ln_Indice).REFERENCIA_PADRE_ID := Lr_ProyectoRegion.Referencia_Padre_Id;
        --
    END LOOP;
    --
    IF Ln_Indice > 0 THEN
      PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION ( Pn_Monto,
                                                        Ln_Indice,
                                                        'Inventarios',
                                                        Pa_DatosCosteo,
                                                        Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_ASIGNA_COSTEO_BIENES',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_ASIGNA_COSTEO_BIENES',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_ASIGNA_COSTEO_BIENES;

PROCEDURE P_ASIGNA_COSTEO_BIENES_PRO ( Pv_NoDocu       IN VARCHAR2,
                                     Pv_Servicio      IN NUMBER,
                                     Pv_Periodo       IN VARCHAR2,
                                     Pn_Monto         IN NUMBER,
                                     Pv_NoCia         IN VARCHAR2,
                                     Pa_DatosCosteo   IN OUT Gt_DetalleTipoCostoPro,
                                     Pv_MensajeError  IN OUT VARCHAR2) IS
  --
  CURSOR C_ULTIMO_NIVEL_PROYECTO IS
    SELECT APD.ID_PARAMETRO_DET AS TIPO_CCOSTO_ID,
           APD.VALOR2 AS DESCRIPCION
    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APD.DESCRIPCION = TIPO_CENTRO_COSTO --  parametro tipo de centro de costos 
    AND APD.VALOR7 =  NAF47_TNET.GEK_VAR.Gr_IndSimple.SI-- nivel de asignacion (ultimo Nivel)
    AND APD.EMPRESA_COD = Pv_NoCia
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                WHERE APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO -- dentro de parametro de control de costo
                AND APC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                AND APC.ID_PARAMETRO = APD.PARAMETRO_ID) 
    AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_DET CCC
                WHERE CCC.DESCRIPCION = CLASE_CENTRO_COSTO -- clase de centro de costos definidos
                AND CCC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                AND CCC.VALOR3 = PROYECTO -- clase proyecto
                AND EXISTS (SELECT NULL
                            FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCC
                            WHERE APCC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO -- dentro de parametro de control de costo
                            AND APCC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                            AND APCC.ID_PARAMETRO = CCC.PARAMETRO_ID)
                AND CCC.VALOR2 = TO_CHAR(APD.ID_PARAMETRO_DET))
    ORDER BY TO_NUMBER(APD.VALOR3) DESC;  
  --
  CURSOR C_DATOS_COSTEO IS
    SELECT IER.EMPRESA_COD AS NO_CIA,
           AP.ID_PRODUCTO AS PRODUCTO_ID,
           PRO.NOMBRE AS NOMBRE_PROYECTO,
           --
           PRO.ID_PROYECTO AS PROYECTO_ID,
           --
           ( SELECT APD.ID_PARAMETRO_DET
             FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
             WHERE APD.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
             AND APD.DESCRIPCION = AP.LINEA_NEGOCIO
             AND EXISTS (SELECT NULL
                         FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                         WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                         AND APC.NOMBRE_PARAMETRO = VERTICALES --LINEA_NEGOCIO
                         AND APC.ESTADO = GEK_VAR.Gr_Estado.ACTIVO)) AS VERTICAL_ID,
           --
           (SELECT AR.ID_PARAMETRO_DET
            FROM DB_GENERAL.ADMI_PARAMETRO_DET AR,
                 DB_GENERAL.ADMI_PARAMETRO_DET ARJ,
                 DB_INFRAESTRUCTURA.ADMI_JURISDICCION AJ,
                 DB_INFRAESTRUCTURA.ADMI_CANTON_JURISDICCION ACJ,
                 DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
            WHERE AJ.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
            AND AR.DESCRIPCION = DIVISION_REGIONAL
            AND ARJ.DESCRIPCION = DIV_REGION_JURISDIC
            AND IOG.ID_OFICINA = IPER.OFICINA_ID 
            AND ARJ.VALOR2 = AR.ID_PARAMETRO_DET
            AND AJ.ID_JURISDICCION = ARJ.VALOR3
            AND ACJ.JURISDICCION_ID = AJ.ID_JURISDICCION
            AND IOG.CANTON_ID = ACJ.CANTON_ID
            GROUP BY AR.ID_PARAMETRO_DET
            ) AS REGION_ID
    FROM DB_COMERCIAL.ADMI_PRODUCTO AP,
         DB_COMERCIAL.ADMI_CARACTERISTICA AC,
         DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
         DB_COMERCIAL.INFO_EMPRESA_ROL IER,
         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
         DB_COMERCIAL.INFO_PUNTO IP,
         DB_COMERCIAL.INFO_SERVICIO ISE,
         DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISPC,
         NAF47_TNET.ADMI_PROYECTO PRO
    WHERE APC.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
    AND ISPC.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
    AND AC.DESCRIPCION_CARACTERISTICA = CARACT_PROYECTO 
    AND IER.EMPRESA_COD = Pv_NoCia
    AND APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
    AND APC.PRODUCTO_ID = AP.ID_PRODUCTO
    AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
    AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
    AND ISE.PUNTO_ID = IP.ID_PUNTO
    AND ISPC.SERVICIO_ID = ISE.ID_SERVICIO
    AND ISE.ID_SERVICIO = Pv_Servicio
    AND ISPC.PRODUCTO_CARACTERISITICA_ID = APC.ID_PRODUCTO_CARACTERISITICA
    AND PRO.ID_PROYECTO= ISPC.VALOR
    AND ISPC.VALOR !='0';
    --
    CURSOR C_DATOS_PROYECTO_VERTICAL (Cn_VerticalId NUMBER,
                                      Cn_ProyectoId NUMBER) IS
      SELECT APC.ID_PROYECTO_CUENTA AS REFERENCIA_ID,
             APC.CUENTA_ID AS CUENTA_CONTABLE_ID
      FROM NAF47_TNET.ADMI_PROYECTO_CUENTA APC
      WHERE APC.VERTICAL_ID  = Cn_VerticalId
      AND APC.PROYECTO_ID = Cn_ProyectoId
      AND APC.NO_CIA_CUENTA = Pv_NoCia
      AND APC.ESTADO = GEK_VAR.Gr_Estado.ACTIVO;
    --
    CURSOR C_DATOS_PROYECTO_REGION ( Cn_ProyectoId NUMBER,
                                     Cn_RegionId   NUMBER) IS
      SELECT APR.ID_PROYECTO_REGION AS REFERENCIA_PADRE_ID
      FROM ADMI_PROYECTO_REGION APR
      WHERE APR.PROYECTO_ID = Cn_ProyectoId
      AND APR.REGION_ID = Cn_RegionId
      AND APR.ESTADO = GEK_VAR.Gr_Estado.ACTIVO;
    --
    Le_Error           EXCEPTION;
    Lr_DatosCosteo     TypeDetalleTipoCosto;
    Ln_Indice          NUMBER(6) := 0;
    --
    Lr_UltimoNivel      C_ULTIMO_NIVEL_PROYECTO%ROWTYPE;
    Lr_ProyectoVertical C_DATOS_PROYECTO_VERTICAL%ROWTYPE;
    Lr_ProyectoRegion   C_DATOS_PROYECTO_REGION%ROWTYPE;
    --
  BEGIN
    --
    Pa_DatosCosteo := Gt_DetalleTipoCostoPro();
    -- se verifica ultimo nivel de arbol proyecto
    IF C_ULTIMO_NIVEL_PROYECTO%ISOPEN THEN
      CLOSE C_ULTIMO_NIVEL_PROYECTO;
    END IF;
    OPEN C_ULTIMO_NIVEL_PROYECTO;
    FETCH C_ULTIMO_NIVEL_PROYECTO INTO Lr_UltimoNivel;
    IF C_ULTIMO_NIVEL_PROYECTO%NOTFOUND THEN
      Pv_MensajeError := 'No se ha definido nivel de asignacion en los tipos de centro de costos por '||PROYECTO;
      RAISE Le_Error;
    END IF;
    CLOSE C_ULTIMO_NIVEL_PROYECTO;
    --
    FOR Lr_DatosCosteo IN C_DATOS_COSTEO LOOP
        --
        --  se determina cual es la referencia id con la que se trabajaria en base a los datos ecuperados de proyecyo y vertical
        IF C_DATOS_PROYECTO_VERTICAL%ISOPEN THEN
          CLOSE C_DATOS_PROYECTO_VERTICAL;
        END IF;
        OPEN C_DATOS_PROYECTO_VERTICAL(Lr_DatosCosteo.Vertical_Id, Lr_DatosCosteo.Proyecto_Id) ;
        FETCH C_DATOS_PROYECTO_VERTICAL INTO Lr_ProyectoVertical;
        IF C_DATOS_PROYECTO_VERTICAL%NOTFOUND THEN
          Pv_MensajeError := 'No se ha definido vertical: '||Lr_DatosCosteo.VERTICAL_ID||' para proyecto: '||Lr_DatosCosteo.PROYECTO_ID;
          RAISE Le_Error;
        END IF;
        CLOSE C_DATOS_PROYECTO_VERTICAL;  
        --
        --
        IF Lr_ProyectoVertical.Cuenta_Contable_Id IS NULL THEN
          Pv_MensajeError := 'No se ha definido cuenta contable para Proyecto: '||Lr_DatosCosteo.Proyecto_Id||' para vertical: '||Lr_DatosCosteo.VERTICAL_ID;
          RAISE Le_Error;
        END IF;
        --
        -- Se busca referencia padre
        IF C_DATOS_PROYECTO_REGION%ISOPEN THEN
          CLOSE C_DATOS_PROYECTO_REGION;
        END IF;
        OPEN C_DATOS_PROYECTO_REGION(Lr_DatosCosteo.Proyecto_Id, Lr_DatosCosteo.Region_Id) ;
        FETCH C_DATOS_PROYECTO_REGION INTO Lr_ProyectoRegion;
        IF C_DATOS_PROYECTO_REGION%NOTFOUND THEN
          Pv_MensajeError := 'No se ha definido vertical: '||Lr_DatosCosteo.VERTICAL_ID||' para proyecto: '||Lr_DatosCosteo.PROYECTO_ID;
          RAISE Le_Error;
        END IF;
        CLOSE C_DATOS_PROYECTO_REGION;      
        --
        Ln_Indice := Ln_Indice + 1;
        Pa_DatosCosteo.EXTEND;

        Pa_DatosCosteo(Ln_Indice).NO_CIA              := Lr_DatosCosteo.No_Cia;
        Pa_DatosCosteo(Ln_Indice).PERIODO             := Pv_Periodo;
        Pa_DatosCosteo(Ln_Indice).NO_DOCU             := Pv_NoDocu;
        Pa_DatosCosteo(Ln_Indice).TIPO_CCOSTO_ID      := Lr_UltimoNivel.TIPO_CCOSTO_ID;
        Pa_DatosCosteo(Ln_Indice).CANTIDAD            := 1;
        Pa_DatosCosteo(Ln_Indice).TIPO_DISTRIBUCION   := PROYECTO;
        Pa_DatosCosteo(Ln_Indice).REFERENCIA_ID       := Lr_DatosCosteo.Producto_Id;
        Pa_DatosCosteo(Ln_Indice).CUENTA_CONTABLE_ID  := Lr_ProyectoVertical.Cuenta_Contable_Id;
        Pa_DatosCosteo(Ln_Indice).REFERENCIA_PADRE_ID := Lr_ProyectoRegion.Referencia_Padre_Id;
        Pa_DatosCosteo(Ln_Indice).ID_PROYECTO_CUENTA  := Lr_ProyectoVertical.Referencia_Id;
        Pa_DatosCosteo(Ln_Indice).DESCRIPCION         := 'PRODUCTO';
        --
    END LOOP;
    --
    IF Ln_Indice > 0 THEN
      PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION_PRO (Pn_Monto,
                                                           Ln_Indice,
                                                           'Inventarios',
                                                           Pa_DatosCosteo,
                                                           Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_ASIGNA_COSTEO_BIENES',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_ASIGNA_COSTEO_BIENES',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_ASIGNA_COSTEO_BIENES_PRO;

PROCEDURE P_PROCESA_DISTRIBUCION_PRO (Pn_Monto        IN NUMBER,
                                    Pn_Cantidad     IN NUMBER,
                                    Pv_Origen       IN VARCHAR2,
                                    Pt_Detalle      IN NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DetalleTipoCostoPro,
                                    Pv_MensajeError IN OUT VARCHAR2) IS
    --
    Ln_DetalleCosto      NUMBER(6):= 0;
    Ln_CentroCostoPres   NUMBER(9) := 0;
    Ln_ValorDistribucion NUMBER(9,2):= 0;
    Ln_CostoResumen      NUMBER(9,2):= 0;
    Ln_SaldoDistribucion NUMBER(9,2):= 0;
    --
    Lv_CentroCosto       NAF47_TNET.PR_CENTRO_COSTO.CODIGO%TYPE := NULL;
    --
    Lt_DetalleCosto      Gt_DetalleTipoCosto := Gt_DetalleTipoCosto();
    --
    Lr_RefAuxiliar       TypeDetalleTipoCosto;
    Lr_Referencia        TypeDetalleTipoCosto;
    Lr_CostoResumen      NAF47_TNET.PR_COSTOS_RESUMEN%ROWTYPE;
    Lr_CostoDetalleTrx   NAF47_TNET.PR_COSTOS_DETALLE_TRX%ROWTYPE;
    --
    Lc_DatosArbol        SYS_REFCURSOR;
    --
    Le_Error             EXCEPTION;
    --
  BEGIN
    -- se calcula monto a distribuir
    Ln_ValorDistribucion := ROUND((Pn_Monto / Pn_Cantidad),2);
    Ln_SaldoDistribucion := Pn_Monto;
    Ln_CostoResumen := 0;
    --
    FOR Li_Datos IN 1..Pt_Detalle.LAST LOOP
      --
      Lv_CentroCosto := NULL;
      --
      Lt_DetalleCosto := Gt_DetalleTipoCosto();
      --
      FOR Lr_Arbol IN C_ARBOL_COSTO (Pt_Detalle(Li_Datos).NO_CIA, Pt_Detalle(Li_Datos).TIPO_DISTRIBUCION) LOOP
        --Se consulta si es ultimo nivel y que la distribuci\F3n se haya generado hasta
        --el ultimo nivel
        IF Lr_Arbol.Ultimo_Nivel = 'S' AND Pt_Detalle(Li_Datos).DESCRIPCION = 'PRODUCTO' THEN
          Lv_CentroCosto                     := Pt_Detalle(Li_Datos).REFERENCIA_ID;
          Lr_RefAuxiliar.NO_CIA              := Pt_Detalle(Li_Datos).NO_CIA;
          Lr_RefAuxiliar.REFERENCIA_ID       := Pt_Detalle(Li_Datos).ID_PROYECTO_CUENTA; --REFERENCIA_ID;
          Lr_RefAuxiliar.REFERENCIA_PADRE_ID := Pt_Detalle(Li_Datos).REFERENCIA_PADRE_ID;
          Ln_DetalleCosto := 1;
          --
          Lt_DetalleCosto.EXTEND;
          Lt_DetalleCosto(Ln_DetalleCosto).TIPO_CCOSTO_ID := Lr_Arbol.Id_Tipo_Ccosto;
          Lt_DetalleCosto(Ln_DetalleCosto).NO_CIA := Pt_Detalle(Li_Datos).NO_CIA;
          Lt_DetalleCosto(Ln_DetalleCosto).REFERENCIA_ID := Pt_Detalle(Li_Datos).REFERENCIA_ID;
        --solo entran la distribuci\F3n que no son de ultimo nivel
        ELSIF Lr_Arbol.Descripcion != 'PRODUCTO' THEN

          IF Lr_Arbol.Descripcion = 'VERTICAL' THEN 
            OPEN Lc_DatosArbol FOR Lr_Arbol.Sentencia_Lee_Tipo 
                 USING Lr_RefAuxiliar.REFERENCIA_ID,
                       Lr_RefAuxiliar.REFERENCIA_PADRE_ID,
                       Lr_RefAuxiliar.NO_CIA;
            FETCH Lc_DatosArbol INTO Lr_Referencia.NO_CIA,
                                     Lr_Referencia.REFERENCIA_ID,
                                     Lr_Referencia.REFERENCIA_PADRE_ID;
          ELSE
            OPEN Lc_DatosArbol FOR Lr_Arbol.Sentencia_Lee_Tipo 
               USING Lr_RefAuxiliar.REFERENCIA_PADRE_ID,
                     Lr_RefAuxiliar.NO_CIA;
            FETCH Lc_DatosArbol INTO Lr_Referencia.NO_CIA,
                                   Lr_Referencia.REFERENCIA_ID,
                                   Lr_Referencia.REFERENCIA_PADRE_ID;
          END IF;
          --
          IF Ln_DetalleCosto = 0 THEN
            Lv_CentroCosto                     := Pt_Detalle(Li_Datos).REFERENCIA_ID;
          ELSE
            Lv_CentroCosto := Lr_Referencia.REFERENCIA_ID ||'-'|| Lv_CentroCosto;
          END IF;  
          --
          Ln_DetalleCosto := Ln_DetalleCosto + 1;
          Lt_DetalleCosto.EXTEND;
          Lt_DetalleCosto(Ln_DetalleCosto).TIPO_CCOSTO_ID := Lr_Arbol.Id_Tipo_Ccosto;
          Lt_DetalleCosto(Ln_DetalleCosto).NO_CIA := Lr_Referencia.NO_CIA;
          Lt_DetalleCosto(Ln_DetalleCosto).REFERENCIA_ID := Lr_Referencia.REFERENCIA_ID;
          --
          Lr_RefAuxiliar.NO_CIA              := Lr_Referencia.NO_CIA;
          Lr_RefAuxiliar.REFERENCIA_ID       := Lr_Referencia.REFERENCIA_ID;
          Lr_RefAuxiliar.REFERENCIA_PADRE_ID := Lr_Referencia.REFERENCIA_PADRE_ID;
        ELSE
          Lr_RefAuxiliar.NO_CIA              := Pt_Detalle(Li_Datos).NO_CIA;
          Lr_RefAuxiliar.REFERENCIA_ID       := Pt_Detalle(Li_Datos).REFERENCIA_ID;
          Lr_RefAuxiliar.REFERENCIA_PADRE_ID := Pt_Detalle(Li_Datos).REFERENCIA_PADRE_ID;
        END IF;
        --
      END LOOP;
      --
      Ln_CentroCostoPres := F_RECUPERA_CENTRO_COSTO(Lt_DetalleCosto, Lv_CentroCosto, Pt_Detalle(Li_Datos).NO_CIA);
      --
      IF Ln_CentroCostoPres = 0 THEN
        Pv_MensajeError := 'No se pudo recuperar codigo de centro de costo, favor revisar distribucion.';
        RAISE Le_Error;
      END IF;
      --
      --
      IF Pt_Detalle(Li_Datos).MONTO != 0 THEN
        Ln_CostoResumen := Pt_Detalle(Li_Datos).MONTO;
      ELSE
        Ln_CostoResumen := ROUND((Ln_ValorDistribucion*Pt_Detalle(Li_Datos).CANTIDAD),2);
      END IF;
      --
      Ln_SaldoDistribucion := Ln_SaldoDistribucion - Ln_CostoResumen;
      --  
      --ultima linea del arreglo se valida que no queden diferencias
      IF Li_Datos = Pt_Detalle.LAST THEN
        --si saldo no es cero se debe restar o sumar el saldo para evitar diferencias
        IF Ln_SaldoDistribucion != 0 THEN
          Ln_CostoResumen := Ln_CostoResumen + Ln_SaldoDistribucion;
        END IF;
      END IF;
      -- se busca registro en costo resumen 
      IF C_RECUPERA_COSTO_RESUMEN%ISOPEN THEN
        CLOSE C_RECUPERA_COSTO_RESUMEN;
      END IF;
      OPEN C_RECUPERA_COSTO_RESUMEN(Ln_CentroCostoPres, Pt_Detalle(Li_Datos).PERIODO);
      FETCH C_RECUPERA_COSTO_RESUMEN INTO Lr_CostoResumen.Id_Costo_Resumen;
      IF C_RECUPERA_COSTO_RESUMEN%NOTFOUND THEN
        Lr_CostoResumen.Id_Costo_Resumen := 0;
      END IF;
      CLOSE C_RECUPERA_COSTO_RESUMEN;
      --
      --
      IF Lr_CostoResumen.Id_Costo_Resumen != 0 THEN
        --
        UPDATE NAF47_TNET.PR_COSTOS_RESUMEN
        SET VALOR_COSTO = NVL(VALOR_COSTO,0) + Ln_CostoResumen,
            USR_ULT_MOD = USER,
            FE_ULT_MOD = SYSDATE
        WHERE CENTRO_COSTO_ID = Ln_CentroCostoPres
        AND PERIODO = Pt_Detalle(Li_Datos).PERIODO;
        --
      ELSE
        --
        Lr_CostoResumen.Id_Costo_Resumen := NAF47_TNET.SEQ_PR_COSTOS_RESUMEN.NEXTVAL;
        --
        Lr_CostoResumen.Centro_Costo_Id   := Ln_CentroCostoPres;
        Lr_CostoResumen.Periodo           := Pt_Detalle(Li_Datos).PERIODO;
        Lr_CostoResumen.Valor_Presupuesto := 0;
        Lr_CostoResumen.Valor_Costo       := Ln_CostoResumen;
        --
        P_INSERTA_RESUMEN_COSTO (Lr_CostoResumen, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      END IF;
      --
      IF Pv_Origen = 'Contabilidad' THEN
        Lr_CostoDetalleTrx.Llave_Transaccion := '<NO_CIA>'||Pt_Detalle(Li_Datos).NO_CIA||'</NO_CIA>'||'<NO_ASIENTO>'||Pt_Detalle(Li_Datos).NO_DOCU||'</NO_ASIENTO>';
      ELSE
        Lr_CostoDetalleTrx.Llave_Transaccion := '<NO_CIA>'||Pt_Detalle(Li_Datos).NO_CIA||'</NO_CIA>'||'<NO_DOCU>'||Pt_Detalle(Li_Datos).NO_DOCU||'</NO_DOCU>';
      END IF;
      Lr_CostoDetalleTrx.Id_Costo_Detalle_Trx :=NAF47_TNET.SEQ_PR_COSTOS_DETALLE_TRX.NEXTVAL;
      Lr_CostoDetalleTrx.Costo_Resumen_Id := Lr_CostoResumen.Id_Costo_Resumen;
      Lr_CostoDetalleTrx.Monto_Transaccion := Ln_CostoResumen;
      Lr_CostoDetalleTrx.Origen := Pv_Origen;
      Lr_CostoDetalleTrx.Estado := 'Activo';
      --
      NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.P_INSERTA_COSTO_DETALLE_TRX (Lr_CostoDetalleTrx,
                                                                       Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;

    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_PROCESA_DISTRIBUCION_PRO;  


  FUNCTION F_RECUPERA_CUENTA_CONTABLE_PRO ( Pv_TipoCosto    IN VARCHAR2,
                                            Pv_ReferenciaId IN VARCHAR2,
                                            Pv_ReferPadreId IN VARCHAR2,
                                            Pv_EmpresaRefId IN VARCHAR2) RETURN VARCHAR2 IS
    --
    CURSOR C_TIPO_COSTO IS
      SELECT RCC.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET RCC
      WHERE RCC.VALOR3 = 'RECUPERA_CUENTA_CONTABLE'
      AND RCC.DESCRIPCION = 'DETALLE_SENTENCIA'
      AND RCC.VALOR2 = Pv_TipoCosto
      AND RCC.EMPRESA_COD = Pv_EmpresaRefId
      AND EXISTS (SELECT NULL 
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                        WHERE APC.NOMBRE_PARAMETRO = 'CONTROL_PRESUPUESTO'
                        AND APC.ID_PARAMETRO = RCC.PARAMETRO_ID);
    --
    Lv_Sentencia DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE;
    Lv_CuentaId  NAF47_TNET.ARCGMS.CUENTA%TYPE;
    Lc_Datos     SYS_REFCURSOR;
    --
  BEGIN
    --
    IF C_TIPO_COSTO%ISOPEN THEN
      CLOSE C_TIPO_COSTO;
    END IF; 
    OPEN C_TIPO_COSTO;
    FETCH C_TIPO_COSTO INTO Lv_Sentencia;
    CLOSE C_TIPO_COSTO;
    --
    FOR Lr_Sentencia IN C_TIPO_COSTO LOOP
      --
      OPEN Lc_Datos FOR Lr_Sentencia.Valor1 USING Pv_ReferenciaId,Pv_ReferPadreId, Pv_EmpresaRefId;
      FETCH Lc_Datos INTO Lv_CuentaId;
      CLOSE Lc_Datos;
      --
    END LOOP;
    --
    RETURN Lv_CuentaId;

  END F_RECUPERA_CUENTA_CONTABLE_PRO;


  PROCEDURE P_COSTEO_OC_SERVICIO_PRO ( Pv_NoDocu       IN VARCHAR2,
                                       Pv_NoCia        IN VARCHAR2,
                                       Pv_TipoProceso  IN VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2) IS
    CURSOR C_DOCUMENTO_RELACIONADO IS
      SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             CASE
               WHEN PDD.MONTO > 0 THEN
                 ROUND(((DO.MONTO *((DEE.TOTAL-NVL(DEE.IMP_VENTAS,0))/DEE.TOTAL)) * (PDD.MONTO/DEE.TOTAL)),2)
               ELSE
                 0
             END AS MONTO_DISTRIBUIDO,
             --
             CASE
               WHEN DEE.TIPO_DISTRIBUCION_COSTO = 'Pedido' THEN -- Cuando es Pedido el tipo de distribucion a usar Administrativo
                 'Administrativo'
               ELSE
                 DEE.TIPO_DISTRIBUCION_COSTO
             END AS TIPO_DISTRIBUCION_COSTO,
             PDD.*
      FROM NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD,
           NAF47_TNET.TAPORDEE DEE,
           NAF47_TNET.ARCPMD MD,
           NAF47_TNET.CP_DOCUMENTO_ORIGEN DO
      WHERE DO.NO_DOCUMENTO = Pv_NoDocu
      AND DO.COMPANIA = Pv_NoCia
      AND DEE.TIPO_DISTRIBUCION_COSTO != 'Manual'
      AND DEE.ID_DOCUMENTO_DISTRIBUCION = PDD.NO_DOCU
      AND DEE.NO_CIA = PDD.NO_CIA
      AND DO.NO_DOCUMENTO = MD.NO_DOCU
      AND DO.COMPANIA = MD.NO_CIA
      AND DO.NO_DOCUMENTO_ORIGEN = DEE.NO_ORDEN
      AND DO.COMPANIA = DEE.NO_CIA
      UNION
      SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             --
             PDD.MONTO AS MONTO_DISTRIBUIDO,
             'Administrativo' AS TIPO_DISTRIBUCION_COSTO,
             --
             PDD.*
      FROM NAF47_TNET.ARCPMD MD,
           NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD
      WHERE MD.NO_DOCU  = Pv_NoDocu
      AND MD.NO_CIA = Pv_NoCia
      AND PDD.ORIGEN = 'CuentasPorPagar'
      AND PDD.DETALLE_DISTRIBUCION_ID IS NULL
      AND PDD.NO_DOCU = MD.NO_DOCU
      AND PDD.NO_CIA = MD.NO_CIA
      UNION
            SELECT TO_NUMBER(TO_CHAR(MD.FECHA,'YYYYMM')) PERIODO,
             CASE
               WHEN Pv_TipoProceso = 'Procesar' THEN
                 NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0) 
               ELSE
                 (NVL(MD.GRAVADO,0)+ NVL(MD.EXCENTOS,0)) * -1
             END AS SUBTOTAL,
             --
             DC.MONTO AS MONTO_DISTRIBUIDO,
             'Proyecto' AS TIPO_DISTRIBUCION_COSTO,
             --
             PDD.*
      FROM NAF47_TNET.ARCPMD MD,
           NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION PDD,
           NAF47_TNET.ARCPDC DC
      WHERE MD.NO_DOCU  = Pv_NoDocu
      AND MD.NO_CIA = Pv_NoCia
      AND PDD.ORIGEN = 'CuentasPorPagar'
      AND PDD.NO_DOCU = MD.NO_DOCU
      AND PDD.NO_CIA = MD.NO_CIA
      AND DC.NO_DISTRIBUCION = PDD.ID_DOC_DISTRIBUCION
      AND DC.NO_DOCU = PDD.NO_DOCU
      AND DC.NO_CIA = PDD.NO_CIA;
    --
    Lc_Datos             SYS_REFCURSOR;
    Lr_TipoCentroCosto   C_TIPO_CENTRO_COSTO%ROWTYPE;
    Lr_Datos             TypeDetalleTipoCosto;
    Lt_DetDistribCosto   Gt_DetalleTipoCostoPro := Gt_DetalleTipoCostoPro();
    Ln_CantDistribuir    NUMBER(9):= 0;
    Ln_Indice            NUMBER(6):= 0;
    Ln_MontoDistribuir   NUMBER(9,2);
    --
    Le_Error           EXCEPTION;
    --
  BEGIN
    --
    Lt_DetDistribCosto := Gt_DetalleTipoCostoPRo();
    --
    -- se determina la cantida de empleados que van a ser distribuidos
    --
    FOR I IN C_DOCUMENTO_RELACIONADO LOOP
      --
      Ln_MontoDistribuir := I.SUBTOTAL;
      --
      IF C_TIPO_CENTRO_COSTO%ISOPEN THEN
        CLOSE C_TIPO_CENTRO_COSTO;
      END IF;
      OPEN C_TIPO_CENTRO_COSTO (TO_NUMBER(I.TIPO_CCOSTO_ID), 'PROCESO_DISTRIBUCION_CCOSTO');
      FETCH C_TIPO_CENTRO_COSTO INTO Lr_TipoCentroCosto;
      IF C_TIPO_CENTRO_COSTO%NOTFOUND THEN
        Lr_TipoCentroCosto := NULL;
      END IF;
      CLOSE C_TIPO_CENTRO_COSTO;
      --
      IF Lr_TipoCentroCosto.Sentencia_Sql IS NULL THEN
        Pv_MensajeError := 'No se ha definido sentencia de consulta para proceso de datos, favor revisar!!!';
        RAISE Le_Error;
      END IF;
      --

      IF I.REFERENCIA_PADRE_ID IS NOT NULL THEN
        OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Sql 
            USING I.REFERENCIA_ID,
                  I.REFERENCIA_PADRE_ID,
                  I.NO_CIA;
      ELSE
        OPEN Lc_Datos FOR Lr_TipoCentroCosto.Sentencia_Sql 
            USING I.REFERENCIA_ID,
                  I.NO_CIA;
      END IF;
      --
      --
      LOOP
        FETCH Lc_Datos into Lr_Datos.NO_CIA,
                            Lr_Datos.REFERENCIA_ID,
                            Lr_Datos.REFERENCIA_PADRE_ID,
                            Lr_Datos.CANTIDAD;
        EXIT WHEN Lc_Datos%NOTFOUND;
        --
        Ln_CantDistribuir := Ln_CantDistribuir + Lr_Datos.CANTIDAD;
        --
        Ln_Indice := Ln_Indice + 1;
        Lt_DetDistribCosto.EXTEND;
        Lt_DetDistribCosto(Ln_Indice).PERIODO             := I.PERIODO;
        Lt_DetDistribCosto(Ln_Indice).NO_CIA              := Lr_Datos.NO_CIA;
        Lt_DetDistribCosto(Ln_Indice).NO_DOCU             := Pv_NoDocu;
        Lt_DetDistribCosto(Ln_Indice).TIPO_DISTRIBUCION   := I.TIPO_DISTRIBUCION_COSTO;
        Lt_DetDistribCosto(Ln_Indice).REFERENCIA_ID       := Lr_Datos.REFERENCIA_ID;
        Lt_DetDistribCosto(Ln_Indice).REFERENCIA_PADRE_ID := NVL(I.AUXILIAR,Lr_Datos.REFERENCIA_PADRE_ID);--Lr_Datos.REFERENCIA_PADRE_ID;
        Lt_DetDistribCosto(Ln_Indice).CANTIDAD            := Lr_Datos.CANTIDAD;
        Lt_DetDistribCosto(Ln_Indice).MONTO               := I.MONTO_DISTRIBUIDO;
        Lt_DetDistribCosto(Ln_Indice).ID_PROYECTO_CUENTA  := Lr_Datos.REFERENCIA_PADRE_ID;
        Lt_DetDistribCosto(Ln_Indice).DESCRIPCION  :=     Lr_TipoCentroCosto.DESCRIPCION;


        --
      END LOOP;
      --
      CLOSE Lc_Datos;
      --
      --
    END LOOP;
    --
    IF Ln_CantDistribuir > 0 THEN
      PRKG_CONTROL_PRESUPUESTO.P_PROCESA_DISTRIBUCION_PRO ( Ln_MontoDistribuir,
                                                            Ln_CantDistribuir,
                                                            'CuentasPorPagar',
                                                            Lt_DetDistribCosto,
                                                            Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_OC_SERVICIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'PRKG_CONTROL_PRESUPUESTO.P_COSTEO_OC_SERVICIO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_COSTEO_OC_SERVICIO_PRO;

  --
  --
end PRKG_CONTROL_PRESUPUESTO;

/
