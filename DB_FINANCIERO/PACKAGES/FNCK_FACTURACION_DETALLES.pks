CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_FACTURACION_DETALLES AS

    TYPE TypeFacturaCab IS RECORD (        
        EMPRESA_ID             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        OFICINA_ID             DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        ID_DOCUMENTO           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        SUBTOTAL               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
        SUBTOTAL_CON_IMPUESTO  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE,
        VALOR_TOTAL            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
    );

    TYPE TypeFactura IS RECORD (
        documento_id                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        id_doc_detalle              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
        plan_id                     DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
        producto_id                 DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
        empresa_id                  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
        oficina_id                  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        precio_venta_facpro_detalle DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE,
        descuento_facpro_detalle    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.DESCUENTO_FACPRO_DETALLE%TYPE,
        impuesto_id                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.IMPUESTO_ID%TYPE,
        porcentaje                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.PORCENTAJE%TYPE,
        valor_impuesto              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.VALOR_IMPUESTO%TYPE
    );

  TYPE TypeDetallePlan IS RECORD (
    producto_id                    DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
    precio_item                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE
  );

  /*
  * Documentación para TYPE 'TypeBienServicio'.
  * Record que me permite devolver los valores para los acumuladores de bienes y servicios
  */
  Type TypeBienServicio IS RECORD (
        TIPO_IMPUESTO     VARCHAR(100),
        IMPUESTO_ID       DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE,
        TIPO              VARCHAR(100),
        TOTAL             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE
  );

  --
--Obtiene el listado de facturas con sus detalles a procesar
PROCEDURE GET_FACTURAS_DETALLAR(Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                Pt_Fe_Emision_Ini IN VARCHAR2,
                Pt_Fe_Emision_Fin IN VARCHAR2,
                Cn_Facturas_Procesar OUT SYS_REFCURSOR);

--Verifica si el detalle a procesar ya existe
FUNCTION F_VALIDAR_DOC_EXISTE(Fn_IdDocDetalle IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
                              Fn_IdImpuesto   IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.IMPUESTO_ID%TYPE
  )
  RETURN NUMBER;

--Obtiene la sumatoria del valor del plan facturado
FUNCTION F_SUMATORIA_PLAN(Fn_IdPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE) RETURN NUMBER;

--Obtiene el detalle de los productos pertenecientes al plan
PROCEDURE GET_DETALLE_PLAN(Fn_IdPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
               Cn_DetallePlan OUT SYS_REFCURSOR);

--
  /**
  * Documentacion para el procedimiento P_FACTURACION_DETALLE
  * Proceso principal para la ejecución de el prorrateo de los productos facturados
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 25-05-2018 - Se modifica para procesar el prorrateo por factura y redondeando a 2 decimales
  *                           para evitar diferencias con respecto a los valores registrados en la cabecera de la factura
  */
  PROCEDURE P_FACTURACION_DETALLE( Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                   Pv_FechaProcesoIni IN VARCHAR2,
                                   Pv_FechaProcesoFin IN VARCHAR2,
                                   Pn_Tipo           IN VARCHAR2,
                                   Pn_IdDocumento    IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
                                  );

--Insertar data
PROCEDURE INSERT_INFO_DOC_DET_PRODUC(Pr_InfoDocumentoDetalleProduct IN  INFO_DOCUMENTO_DETALLE_PRODUCT%ROWTYPE,
             Pv_MsnError  OUT VARCHAR2);

--Obtener los subtotales de bienes o servicios
PROCEDURE P_OBTENER_SUBTOTALES_BS(
        Pn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT.DOCUMENTO_ID%TYPE,
        Cn_SumatoriaBS OUT SYS_REFCURSOR);

--Asignar los valores a los documentos correspondientes
PROCEDURE P_ASIGNAR_VALOR_POR_DETALLE(Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                    Pt_Fe_Emision_Ini IN VARCHAR2,
                    Pt_Fe_Emision_Fin IN VARCHAR2,
                    Pn_DocumentoId IN NUMBER DEFAULT NULL);

END FNCK_FACTURACION_DETALLES;
/
CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_FACTURACION_DETALLES AS
  --
  --

/**
  * Documentacion para el procedimiento GET_FACTURAS_DETALLAR
  * Devuelve el listado de lod documentos a procesar
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 06-02-2018 - Se modifica para considerar parametro Fecha_Contabiliza que indica si la consulta se realiza por
  *                           Fecha_emision o fecha_autorizacion
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.2 05-03-2018 - Se modifica para cambiar DECODE por CASE pues la condicion contraria del DECODE no presenta el resultado requerido
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.3 24-04-2018 - Se corrige formatos de parametros fecha tipo TIMESTAMP porque generarn error al ejecutar JOB
  *
*/
  PROCEDURE GET_FACTURAS_DETALLAR(
              Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
              Pt_Fe_Emision_Ini IN VARCHAR2,
              Pt_Fe_Emision_Fin IN VARCHAR2,
              Cn_Facturas_Procesar OUT SYS_REFCURSOR) AS
    --
    CURSOR C_PARAMETRO_CONTABILIZACION IS
      SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
        DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        INFO_EMPRESA_GRUPO IEG
      WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO
      AND APD.EMPRESA_COD = IEG.COD_EMPRESA
      AND APC.NOMBRE_PARAMETRO = FNKG_VAR.Gv_ValidaProcesoContable
      AND APC.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO
      AND APD.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO
      AND APD.DESCRIPCION      = FNKG_VAR.Gv_ParFechaContabiliza
      AND IEG.PREFIJO          = Pv_PrefijoEmpresa;
    --
    Lv_TipoFechaContable      VARCHAR2(30) := NULL;
    --
  BEGIN
    -- se recupera parametro fecha de contabilziación.
    IF C_PARAMETRO_CONTABILIZACION%ISOPEN THEN
      CLOSE C_PARAMETRO_CONTABILIZACION;
    END IF;
    --
    OPEN C_PARAMETRO_CONTABILIZACION;
    FETCH C_PARAMETRO_CONTABILIZACION INTO Lv_TipoFechaContable;
    CLOSE C_PARAMETRO_CONTABILIZACION;
    --
    IF Lv_TipoFechaContable IS NULL THEN
      Lv_TipoFechaContable := FNKG_VAR.Gv_FechaAutoriza;
    END IF;

    -- Listado de Facturas a dividir
    OPEN Cn_Facturas_Procesar FOR
      SELECT
      IDFD.DOCUMENTO_ID,
      IDFD.ID_DOC_DETALLE,
      IDFD.PLAN_ID,
      IDFD.PRODUCTO_ID,
      IDFD.EMPRESA_ID,
      IDFC.OFICINA_ID,
      ((IDFD.PRECIO_VENTA_FACPRO_DETALLE*IDFD.CANTIDAD)-IDFD.DESCUENTO_FACPRO_DETALLE) AS PRECIO_VENTA_FACPRO_DETALLE,
      IDFD.DESCUENTO_FACPRO_DETALLE,
      IDFI.IMPUESTO_ID,
      IDFI.PORCENTAJE,
      IDFI.VALOR_IMPUESTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
      LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI ON IDFI.DETALLE_DOC_ID=IDFD.ID_DOC_DETALLE
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      JOIN DB_INFRAESTRUCTURA.INFO_PUNTO IP ON IP.ID_PUNTO=IDFC.PUNTO_ID
      WHERE IDFC.LOGIN_MD IS NULL
      AND IDFC.NUMERO_FACTURA_SRI IS NOT NULL
      AND IDFC.ES_AUTOMATICA IN ('S','N')
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP','NC','NCI')
      AND IEG.PREFIJO=PV_PREFIJOEMPRESA
      AND IDFC.FE_AUTORIZACION >= ( CASE WHEN Lv_TipoFechaContable = FNKG_VAR.Gv_FechaAutoriza
                                    THEN TO_TIMESTAMP(Pt_Fe_Emision_Ini||FNKG_VAR.Gv_HoraIniDia, FNKG_VAR.Gv_FmtFechaTime)
                                    ELSE IDFC.FE_AUTORIZACION
                                    END)
      AND IDFC.FE_AUTORIZACION <= (CASE WHEN Lv_TipoFechaContable = FNKG_VAR.Gv_FechaAutoriza
                                   THEN TO_TIMESTAMP(Pt_Fe_Emision_Fin||FNKG_VAR.Gv_HoraFinDia, FNKG_VAR.Gv_FmtFechaTime)
                                   ELSE IDFC.FE_AUTORIZACION
                                   END)
      AND IDFC.FE_EMISION >= ( CASE WHEN Lv_TipoFechaContable = FNKG_VAR.Gv_FechaEmision
                               THEN TO_DATE(Pt_Fe_Emision_Ini||FNKG_VAR.Gv_HoraIniDia, FNKG_VAR.Gv_FmtFechaDate)
                               ELSE IDFC.FE_EMISION
                               END)
      AND IDFC.FE_EMISION <= ( CASE WHEN Lv_TipoFechaContable = FNKG_VAR.Gv_FechaEmision
                               THEN TO_DATE(Pt_Fe_Emision_Fin||FNKG_VAR.Gv_HoraFinDia, FNKG_VAR.Gv_FmtFechaDate)
                               ELSE IDFC.FE_EMISION
                               END)
      AND NOT EXISTS ( SELECT NULL
                       FROM DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT IDDP
                       WHERE IDDP.DETALLE_DOC_ID = IDFI.DETALLE_DOC_ID
                       AND IDDP.IMPUESTO_ID = IDFI.IMPUESTO_ID);
END GET_FACTURAS_DETALLAR;

  /**
  * Documentacion para el procedimiento P_FACTURAS_DISTRIBUIR
  * Proceso principal que recupera dinamicamente los documentos a prorratear 
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 21-06-2018
  *
  * @Param  Pn_IdDocumento       IN NUMBER   Código Documento
  * @Param  Pv_EmpresaId         IN VARCHAR2 Código de Empresa
  * @Param  Pt_Fe_Emision_Ini    IN VARCHAR2 Fecha Inicial a procesar
  * @Param  Pt_Fe_Emision_Fin    IN VARCHAR2 Fecha Final a procesar
  * @Return Pr_Facturas_Procesar IN VARCHAR2 Ref Cursor con listado documentos.
  */
  PROCEDURE P_FACTURAS_DISTRIBUIR( Pn_IdDocumento       IN NUMBER,
                                   Pv_EmpresaId         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pt_Fe_Emision_Ini    IN VARCHAR2,
                                   Pt_Fe_Emision_Fin    IN VARCHAR2,
                                   Pr_Facturas_Procesar OUT SYS_REFCURSOR) AS
    --
    Lv_Consulta               VARCHAR2(32000) := NULL;
    --
    Ld_FechaEmisionIni DATE;
    Ld_FechaEmisionFin DATE;
    --
  BEGIN
    --
    Lv_consulta := 'SELECT IOG.EMPRESA_ID,'||CHR(10);
    Lv_consulta := Lv_consulta || 'IDFC.OFICINA_ID,'||CHR(10);
    Lv_consulta := Lv_consulta || 'IDFC.ID_DOCUMENTO,'||CHR(10);
    Lv_consulta := Lv_consulta || '(IDFC.SUBTOTAL - NVL(IDFC.SUBTOTAL_DESCUENTO,0)) SUBTOTAL,'||CHR(10);
    Lv_consulta := Lv_consulta || 'IDFC.SUBTOTAL_CON_IMPUESTO,'||CHR(10);
    Lv_consulta := Lv_consulta || 'IDFC.VALOR_TOTAL'||CHR(10);
    Lv_consulta := Lv_consulta || 'FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,'||CHR(10);
    Lv_consulta := Lv_consulta || 'DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,'||CHR(10);
    Lv_consulta := Lv_consulta || 'DB_INFRAESTRUCTURA.INFO_PUNTO IP,'||CHR(10);
    Lv_consulta := Lv_consulta || 'DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC'||CHR(10);
    Lv_consulta := Lv_consulta || 'WHERE ';
    --
    IF Pn_IdDocumento IS NOT NULL THEN
      Lv_consulta := Lv_consulta || 'IDFC.ID_DOCUMENTO = :1'||CHR(10); --Pn_IdDocumento
    ELSE
      Ld_FechaEmisionIni := TO_DATE(Pt_Fe_Emision_Ini||' 00:00:00','DD/MM/YYYY HH24:MI:SS');
      Ld_FechaEmisionFin := TO_DATE(Pt_Fe_Emision_Fin||' 23:59:59','DD/MM/YYYY HH24:MI:SS');
      --
      Lv_Consulta := Lv_Consulta||'IDFC.FE_EMISION >= :1 '||CHR(10); --Ld_FechaEmisionIni
      Lv_Consulta := Lv_Consulta||'AND IDFC.FE_EMISION <= :2 '||CHR(10); --Ld_FechaEmisionFin
    END IF;
    --
    Lv_consulta := Lv_consulta || 'AND IDFC.LOGIN_MD IS NULL'||CHR(10);
    Lv_consulta := Lv_consulta || 'AND IDFC.NUMERO_FACTURA_SRI IS NOT NULL'||CHR(10);
    Lv_consulta := Lv_consulta || 'AND IDFC.ES_AUTOMATICA IS NOT NULL'||CHR(10);
    --
    IF Pv_EmpresaId IS NOT NULL THEN
      Lv_consulta := Lv_consulta || 'AND IOG.EMPRESA_ID = :3'||CHR(10); --Pv_EmpresaId
      Lv_consulta := Lv_consulta || 'AND EXISTS (SELECT NULL'||CHR(10);
      Lv_consulta := Lv_consulta || 'FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,'||CHR(10);
      Lv_consulta := Lv_consulta || 'DB_GENERAL.ADMI_PARAMETRO_CAB APC'||CHR(10);
      Lv_consulta := Lv_consulta || 'WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO'||CHR(10);
      Lv_consulta := Lv_consulta || 'AND APC.NOMBRE_PARAMETRO = :4'||CHR(10); --FNKG_VAR.Gv_ValidaProcesoContable
      Lv_consulta := Lv_consulta || 'AND APC.ESTADO = :5'||CHR(10);--FNKG_VAR.Gr_Estado.ACTIVO
      Lv_consulta := Lv_consulta || 'AND APD.ESTADO = :5'||CHR(10);--FNKG_VAR.Gr_Estado.ACTIVO
      Lv_consulta := Lv_consulta || 'AND APD.DESCRIPCION = :6'||CHR(10);--FNKG_VAR.Gv_ParDocumentoDetProduc
      Lv_consulta := Lv_consulta || 'AND APD.VALOR1 = ATDF.CODIGO_TIPO_DOCUMENTO)'||CHR(10);
    END IF;
    --
    Lv_consulta := Lv_consulta || 'AND NOT EXISTS ( SELECT NULL'||CHR(10);
    Lv_consulta := Lv_consulta || 'FROM DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT IDDP'||CHR(10);
    Lv_consulta := Lv_consulta || 'WHERE IDDP.DOCUMENTO_ID = IDFC.ID_DOCUMENTO)'||CHR(10);
    --
    Lv_consulta := Lv_consulta || 'AND IDFC.PUNTO_ID = IP.ID_PUNTO'||CHR(10);
    Lv_consulta := Lv_consulta || 'AND IDFC.OFICINA_ID = IOG.ID_OFICINA'||CHR(10);
    Lv_consulta := Lv_consulta || 'AND IDFC.TIPO_DOCUMENTO_ID = ATDF.ID_TIPO_DOCUMENTO'||CHR(10);
    --
    --DBMS_OUTPUT.PUT_LINE(Lv_Consulta);
    --
    IF Pn_IdDocumento IS NOT NULL THEN
      OPEN Pr_Facturas_Procesar FOR Lv_consulta USING Pn_IdDocumento;
    ELSE
      OPEN Pr_Facturas_Procesar FOR Lv_consulta USING Ld_FechaEmisionIni,
                                                      Ld_FechaEmisionFin,
                                                      Pv_EmpresaId,
                                                      FNKG_VAR.Gv_ValidaProcesoContable,
                                                      FNKG_VAR.Gr_Estado.ACTIVO,
                                                      FNKG_VAR.Gr_Estado.ACTIVO,
                                                      FNKG_VAR.Gv_ParDocumentoDetProduc;
    END IF;

END P_FACTURAS_DISTRIBUIR;

/**
  * Documentacion para el procedimiento GET_PROCESAR_DOCUMENTO
  * Devuelve un unico documento a procesar de manera individual
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  */
PROCEDURE GET_PROCESAR_DOCUMENTO(
          Pn_IdDocumento       IN   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                    Cn_Facturas_Procesar OUT  SYS_REFCURSOR)
AS
    -- Listado de Facturas a dividir
    BEGIN
        OPEN Cn_Facturas_Procesar FOR
            select
            idfd.documento_id,
            idfd.id_doc_detalle,
            idfd.plan_id,
            idfd.producto_id,
            idfd.empresa_id,
            idfc.oficina_id,
            ((idfd.precio_venta_facpro_detalle*idfd.cantidad)-idfd.descuento_facpro_detalle) as precio_venta_facpro_detalle,
            idfd.descuento_facpro_detalle,
            idfi.impuesto_id,
            idfi.porcentaje,
            idfi.valor_impuesto
            from info_documento_financiero_cab idfc
            join info_documento_financiero_det idfd on idfd.documento_id=idfc.id_documento
            left join info_documento_financiero_imp idfi on idfi.detalle_doc_id=idfd.id_doc_detalle
            join info_oficina_grupo iog on iog.id_oficina=idfc.oficina_id
            join info_empresa_grupo ieg on ieg.cod_empresa=iog.empresa_id
            join admi_tipo_documento_financiero atdf on atdf.id_tipo_documento=idfc.tipo_documento_id
            join info_punto ip on ip.id_punto=idfc.punto_id
            where
            idfc.login_md is null
            and idfc.id_documento=Pn_IdDocumento;
END GET_PROCESAR_DOCUMENTO;

/**
  * Documentacion para el procedimiento F_VALIDAR_DOC_EXISTE
  * Verifica si el detalle del documento ya fue procesado
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  */
FUNCTION F_VALIDAR_DOC_EXISTE(Fn_IdDocDetalle IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE,
                              Fn_IdImpuesto   IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.IMPUESTO_ID%TYPE
  )
  RETURN NUMBER
  IS
    Ln_DetalleDocId INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE;
  BEGIN
    SELECT DETALLE_DOC_ID INTO Ln_DetalleDocId
    FROM DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT
    WHERE DETALLE_DOC_ID=Fn_IdDocDetalle
    AND IMPUESTO_ID=Fn_IdImpuesto
    AND ROWNUM=1;

    return(Ln_DetalleDocId);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    return 0;
  END F_VALIDAR_DOC_EXISTE ;

/**
  * Documentacion para el procedimiento F_SUMATORIA_PLAN
  * Devuelve el valor total del plan
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  */
FUNCTION F_SUMATORIA_PLAN(Fn_IdPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
  RETURN NUMBER
  IS
    Ln_Sumatoria INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
  BEGIN
    select sum(precio_item*cantidad_detalle) INTO Ln_Sumatoria
    from info_plan_det
    where plan_id=Fn_IdPlan and estado<>'Eliminado';

    return(Ln_Sumatoria);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    return 0;
  END F_SUMATORIA_PLAN;

/**
  * Documentacion para el procedimiento GET_DETALLE_PLAN
  * Devuelve el detalle del plan a procesar
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  */
PROCEDURE GET_DETALLE_PLAN(Fn_IdPlan IN DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,Cn_DetallePlan OUT SYS_REFCURSOR)
AS
    BEGIN
        OPEN Cn_DetallePlan FOR
            select producto_id, (precio_item*cantidad_detalle) as  precio_item
      from info_plan_det
      where plan_id=Fn_IdPlan and estado<>'Eliminado';
END GET_DETALLE_PLAN;

/**
  * Documentacion para el procedimiento INSERT_INFO_DOC_DET_PRODUC
  * Inserta la data procesada
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  */
PROCEDURE INSERT_INFO_DOC_DET_PRODUC(Pr_InfoDocumentoDetalleProduct IN  INFO_DOCUMENTO_DETALLE_PRODUCT%ROWTYPE,
             Pv_MsnError  OUT VARCHAR2)
IS
BEGIN
  --
  INSERT
  INTO
    INFO_DOCUMENTO_DETALLE_PRODUCT
    (
      ID_ITEM_DETALLE,
      DOCUMENTO_ID,
      DETALLE_DOC_ID,
      EMPRESA_ID,
      OFICINA_ID,
      PLAN_ID,
      PRODUCTO_ID,
      IMPUESTO_ID,
      PORCENTAJE,
      VALOR,
      USR_CREACION,
      FE_CREACION
    )
    VALUES
    (
      Pr_InfoDocumentoDetalleProduct.ID_ITEM_DETALLE,
      Pr_InfoDocumentoDetalleProduct.DOCUMENTO_ID,
      Pr_InfoDocumentoDetalleProduct.DETALLE_DOC_ID,
      Pr_InfoDocumentoDetalleProduct.EMPRESA_ID,
      Pr_InfoDocumentoDetalleProduct.OFICINA_ID,
      Pr_InfoDocumentoDetalleProduct.PLAN_ID,
      Pr_InfoDocumentoDetalleProduct.PRODUCTO_ID,
      Pr_InfoDocumentoDetalleProduct.IMPUESTO_ID,
      Pr_InfoDocumentoDetalleProduct.PORCENTAJE,
      Pr_InfoDocumentoDetalleProduct.VALOR,
      Pr_InfoDocumentoDetalleProduct.USR_CREACION,
      Pr_InfoDocumentoDetalleProduct.FE_CREACION
    );
  --
EXCEPTION
WHEN OTHERS THEN
  Pv_MsnError := SQLERRM||' -> traza: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  ROLLBACK;
  --
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                      'FNCK_FACTURACION_DETALLES.INSERT_INFO_DOC_DET_PRODUC', 
                      Pv_MsnError,
                      SUBSTR(NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV, FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),1,4000),
                      SYSDATE, 
                      NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV, FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1') );
  --
END INSERT_INFO_DOC_DET_PRODUC;

/**
  * Documentacion para el procedimiento P_OBTENER_SUBTOTALES_BS
  * Totaliza los detalles por bienes o servicios
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 13-06-2016 - Se quita el redondeo al calcular los subtotales e ivas de Bienes y Servicios
  */
PROCEDURE P_OBTENER_SUBTOTALES_BS(
  Pn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT.DOCUMENTO_ID%TYPE,
  Cn_SumatoriaBS OUT SYS_REFCURSOR)
AS
BEGIN
  OPEN Cn_SumatoriaBS FOR
    SELECT
    CASE
    WHEN AI.TIPO_IMPUESTO IS NULL THEN 'PRODUCTOS'
    ELSE AI.TIPO_IMPUESTO
    END AS TIPO_IMPUESTO,
    iddp.IMPUESTO_ID,
    ap.TIPO,
    sum(iddp.VALOR) AS TOTAL
    FROM DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT iddp
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO ap on ap.ID_PRODUCTO=iddp.producto_id
    LEFT JOIN DB_GENERAL.ADMI_IMPUESTO AI ON AI.ID_IMPUESTO=iddp.IMPUESTO_ID
    WHERE
    iddp.DOCUMENTO_ID=Pn_IdDocumento
    GROUP BY iddp.IMPUESTO_ID,ap.TIPO,AI.TIPO_IMPUESTO
    ORDER BY ap.TIPO;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA(
        'facturacion@telcos.ec',
        'Error Facturacion Masiva',
        DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),
        'FACE');
END P_OBTENER_SUBTOTALES_BS;

/**
  * Documentacion para la funcion F_CODIGO_IMPUESTO
  * Obtiene el impuesto relacionado al documento, debido a que los impuestos son cambiantes
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 03-06-2016
  */
FUNCTION F_CODIGO_IMPUESTO(
    Fv_TipoImpuesto       IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE,
    Fn_PorcentajeImpuesto IN DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_CodigoImpuesto(
          Cv_TipoImpuesto       DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE,
          Cn_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE
  ) IS
    SELECT ID_IMPUESTO
    FROM DB_GENERAL.ADMI_IMPUESTO
    WHERE UPPER(TIPO_IMPUESTO)=Cv_TipoImpuesto
    AND PORCENTAJE_IMPUESTO=Cn_PorcentajeImpuesto;
  --
  Ln_IdImpuesto DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_CodigoImpuesto%ISOPEN THEN
    CLOSE C_CodigoImpuesto;
  END IF;
  --
  OPEN C_CodigoImpuesto(Fv_TipoImpuesto,Fn_PorcentajeImpuesto);
  --
  FETCH C_CodigoImpuesto INTO Ln_IdImpuesto;
  --
  CLOSE C_CodigoImpuesto;
  --
  IF Ln_IdImpuesto IS NULL THEN
    Ln_IdImpuesto  := 0;
  END IF;
  --
  RETURN Ln_IdImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_InfoError:='Error al obtener Ln_IdImpuesto con : '||Fv_TipoImpuesto;
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION DETALLES', 'FNCK_FACTURACION_DETALLES.F_CODIGO_IMPUESTO', Lv_InfoError);
    DB_FINANCIERO.FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA(
        'facturacion@telcos.ec',
        'Error Facturacion Masiva',
        DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),
        'FACE');
END F_CODIGO_IMPUESTO;

/**
  * Documentacion para el procedimiento P_ACTUALIZAR_CABECERA
  * Actualiza los valores en la cabecera correspondiente a bienes y servicios
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 05-07-2018 - e modifica para aplicar formato fecha a los parametros que pasan como varchar2
  */
PROCEDURE P_ACTUALIZAR_CABECERA(
    Lr_InfoDocumentoFinancieroCab IN OUT INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE,
    Ln_SubtotalServicio     IN NUMBER,
    Ln_IvaServicio          IN NUMBER,
    Ln_SubtotalBienes       IN NUMBER,
    Ln_IvaBienes            IN NUMBER
    )
AS

    Pv_MsnError             VARCHAR2(5000);
BEGIN

    --Ingreso los valores en los nuevos campos
    Lr_InfoDocumentoFinancieroCab.SUBTOTAL_SERVICIOS  :=Ln_SubtotalServicio;
    Lr_InfoDocumentoFinancieroCab.IMPUESTOS_SERVICIOS :=Ln_IvaServicio;
    Lr_InfoDocumentoFinancieroCab.SUBTOTAL_BIENES     :=Ln_SubtotalBienes;
    Lr_InfoDocumentoFinancieroCab.IMPUESTOS_BIENES    :=Ln_IvaBienes;

    --Actualizo los valores de la cabecera
    FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Pv_MsnError);

END P_ACTUALIZAR_CABECERA;

/**
  * Documentacion para el procedimiento P_ASIGNAR_VALOR_POR_DETALLE
  * Obtiene la data a procesar por cabecera
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0 28-12-2015
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 05-07-2018 - e modifica para aplicar formato fecha a los parametros que pasan como varchar2
*/
PROCEDURE P_ASIGNAR_VALOR_POR_DETALLE(Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                    Pt_Fe_Emision_Ini IN VARCHAR2,
                    Pt_Fe_Emision_Fin IN VARCHAR2,
                    Pn_DocumentoId IN NUMBER DEFAULT NULL)
AS
  Ln_SumatoriaBS                SYS_REFCURSOR;
  Ln_SubtotalServicio           NUMBER;
  Ln_SubtotalBienes             NUMBER;
  Ln_IvaServicio                NUMBER;
  Ln_IvaBienes                  NUMBER;
  Lr_Sumatoria                  TypeBienServicio;
  Lr_InfoDocumentoFinancieroCab DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
  Ln_Contador                   NUMBER;

  CURSOR C_PuntosActualizar (Pv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                    Pt_Fe_Emision_Ini IN VARCHAR2,
                    Pt_Fe_Emision_Fin IN VARCHAR2) IS
  select
  idfc.*
  from info_documento_financiero_cab idfc
  join info_oficina_grupo iog on iog.id_oficina=idfc.oficina_id
  join info_empresa_grupo ieg on ieg.cod_empresa=iog.empresa_id
  join admi_tipo_documento_financiero atdf on atdf.id_tipo_documento=idfc.tipo_documento_id
  join info_punto ip on ip.id_punto=idfc.punto_id
  where
  idfc.login_md is null
  and idfc.numero_factura_sri is not null
  and idfc.id_documento = NVL(Pn_DocumentoId, idfc.id_documento)
  and idfc.es_automatica in ('S','N')
  and atdf.codigo_tipo_documento in ('FAC','FACP','NC','NCI')
  and ieg.prefijo=Pv_PrefijoEmpresa
  and idfc.fe_emision >= TO_DATE(Pt_Fe_Emision_Ini||FNKG_VAR.Gv_HoraIniDia,FNKG_VAR.Gv_FmtFechaDate)
  and idfc.fe_emision <= TO_DATE(Pt_Fe_Emision_Fin||FNKG_VAR.Gv_HoraFinDia,FNKG_VAR.Gv_FmtFechaDate);
  --

BEGIN
  Ln_Contador:=0;
  --
  DBMS_OUTPUT.PUT_LINE('Pt_Fe_Emision_Ini: '||Pt_Fe_Emision_Ini||', Pt_Fe_Emision_Fin: '||Pt_Fe_Emision_Fin);
  --
  OPEN C_PuntosActualizar(Pv_PrefijoEmpresa,Pt_Fe_Emision_Ini,Pt_Fe_Emision_Fin);

  LOOP
    FETCH C_PuntosActualizar INTO Lr_InfoDocumentoFinancieroCab;
    --Llamada al proceso de escritura
    EXIT WHEN C_PuntosActualizar%NOTFOUND;

    P_OBTENER_SUBTOTALES_BS(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Ln_SumatoriaBS);

    --Inicializando
    Ln_SubtotalServicio:=0;
    Ln_SubtotalBienes:=0;
    Ln_IvaServicio:=0;
    Ln_IvaBienes:=0;

    --Proceso para asignar los subtotales por tipo
    LOOP
      FETCH Ln_SumatoriaBS INTO Lr_Sumatoria;
      EXIT
      WHEN Ln_SumatoriaBS%notfound;

      IF Lr_Sumatoria.TIPO_IMPUESTO='PRODUCTOS' THEN
        IF Lr_Sumatoria.TIPO='S' THEN
          Ln_SubtotalServicio:=Lr_Sumatoria.TOTAL;
        ELSE
          Ln_SubtotalBienes:=Lr_Sumatoria.TOTAL;
        END IF;
      ELSE --Por ELSE es IVA
        IF Lr_Sumatoria.TIPO='S' THEN
          Ln_IvaServicio:=Lr_Sumatoria.TOTAL;
        ELSE
          Ln_IvaBienes:=Lr_Sumatoria.TOTAL;
        END IF;
      END IF;
    END LOOP;
    CLOSE Ln_SumatoriaBS;
    --Actualizo la cabecera con los valores necesarios para los debitos
    P_ACTUALIZAR_CABECERA(Lr_InfoDocumentoFinancieroCab,Ln_SubtotalServicio,Ln_IvaServicio,Ln_SubtotalBienes,Ln_IvaBienes);

    Ln_Contador:=Ln_Contador+1;
    IF Ln_Contador>=5000 THEN
        COMMIT;
        Ln_Contador:=1;
    END IF;

  END LOOP;
  CLOSE C_PuntosActualizar;

END P_ASIGNAR_VALOR_POR_DETALLE;

  PROCEDURE P_FACTURACION_DETALLE( Pv_PrefijoEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
                                   Pv_FechaProcesoIni IN VARCHAR2,
                                   Pv_FechaProcesoFin IN VARCHAR2,
                                   Pn_Tipo            IN VARCHAR2,
                                   Pn_IdDocumento     IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
                                  ) IS
  --
    -- cursor que recupera detalle de facturas a generar impuestos por productos
    CURSOR C_DETALLE_FACTURA (Cn_IdDocumento NUMBER) IS
      SELECT
      IDFD.ID_DOC_DETALLE,
      IDFD.PLAN_ID,
      IDFD.PRODUCTO_ID,
      ((NVL(IDFD.PRECIO_VENTA_FACPRO_DETALLE,0) * NVL(IDFD.CANTIDAD,0)) - NVL(IDFD.DESCUENTO_FACPRO_DETALLE,0)) AS PRECIO_VENTA_FACPRO_DETALLE,
      IDFD.DESCUENTO_FACPRO_DETALLE,
      IDFI.IMPUESTO_ID,
      IDFI.PORCENTAJE,
      IDFI.VALOR_IMPUESTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
      LEFT JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI ON IDFI.DETALLE_DOC_ID=IDFD.ID_DOC_DETALLE
      WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento
      AND NOT EXISTS ( SELECT NULL
                       FROM DB_FINANCIERO.INFO_DOCUMENTO_DETALLE_PRODUCT IDDP
                       WHERE IDDP.DETALLE_DOC_ID = IDFI.DETALLE_DOC_ID
                       AND IDDP.IMPUESTO_ID = IDFI.IMPUESTO_ID);
    --
    -- Cursor que recupera tipo de fecha de contabilizacion 
    CURSOR C_PARAMETRO_CONTABILIZACION IS
      SELECT APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
        DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        INFO_EMPRESA_GRUPO IEG
      WHERE APD.PARAMETRO_ID = APC.ID_PARAMETRO
      AND APD.EMPRESA_COD = IEG.COD_EMPRESA
      AND APC.NOMBRE_PARAMETRO = FNKG_VAR.Gv_ValidaProcesoContable
      AND APC.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO
      AND APD.ESTADO           = FNKG_VAR.Gr_Estado.ACTIVO
      AND APD.DESCRIPCION      = FNKG_VAR.Gv_ParFechaContabiliza
      AND IEG.PREFIJO          = Pv_PrefijoEmpresa;
    --
    -- cursor que recupera Id de Empresa filtrando por Prefijo
    CURSOR C_EMPRESA IS
      SELECT IEG.COD_EMPRESA
      FROM DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      WHERE IEG.PREFIJO = Pv_PrefijoEmpresa;
    --
    --Lv_TipoFechaContable  VARCHAR2(30) := NULL;
    Lv_FechaProcesoIni    VARCHAR2(15) := Pv_FechaProcesoIni;
    Lv_FechaProcesoFin    VARCHAR2(15) := Pv_FechaProcesoFin;
    Lv_MensajeError       VARCHAR2(3000) := NULL;
    Ln_ImpuestoAcumulado  NUMBER;
    Ln_MontoBaseAcumulado NUMBER;
    Lv_IdEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE := NULL;
    Ln_IdItemDetAuxBas    INFO_DOCUMENTO_DETALLE_PRODUCT.ID_ITEM_DETALLE%TYPE;
    Ln_IdItemDetAuxImp    INFO_DOCUMENTO_DETALLE_PRODUCT.ID_ITEM_DETALLE%TYPE;
    --
    Le_Error              EXCEPTION;    
    --
    --Lc_FacturasProcesar           SYS_REFCURSOR;
    Lr_Factura                    TypeFacturaCab;
    Lr_FacturaDet                 TypeFactura;
    Ln_DetalleDocId               INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE;
    Ln_Sumatoria                  INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Lc_DetallePlan                SYS_REFCURSOR;
    Lr_DetallePlan                TypeDetallePlan;
    Ln_Porcentaje                 NUMBER;
    Ln_PrecioProrrateado          NUMBER;
    Ln_ImpuestoProrrateado        NUMBER;

    Lr_InfoDocumentoDetProd       INFO_DOCUMENTO_DETALLE_PRODUCT%ROWTYPE;
    Ln_Contador                   NUMBER:=0;
    Pv_MsnError                   VARCHAR2(5000);
    Ln_IdImpuesto                 DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE;
    --
    Cr_Facturas_Procesar          SYS_REFCURSOR;

  BEGIN
    --Se modifica por el tipo de llamada para la facturacion mensual
    IF Pn_Tipo='I' THEN
      --GET_PROCESAR_DOCUMENTO(Pn_IdDocumento,Lc_FacturasProcesar);
      Lv_FechaProcesoIni   := NULL;
      Lv_FechaProcesoFin   := NULL;
      Lv_IdEmpresa         := NULL;
    ELSE
      --
      -- Se recupera Código de Empresa 
      IF C_EMPRESA%ISOPEN THEN
        CLOSE C_EMPRESA;
      END IF;
      OPEN C_EMPRESA;
      FETCH C_EMPRESA INTO Lv_IdEmpresa;
      CLOSE C_EMPRESA;
      --
      IF Lv_IdEmpresa IS NULL THEN
        Lv_MensajeError := 'No se encuentra definido código de Empresa para prefijo '||Pv_PrefijoEmpresa;
        RAISE Le_Error;
      END IF;
      --
    END IF;
    --
    P_FACTURAS_DISTRIBUIR( Pn_IdDocumento,
                           Lv_IdEmpresa,
                           Lv_FechaProcesoIni,
                           Lv_FechaProcesoFin,
                           Cr_Facturas_Procesar);
    --

    LOOP
      FETCH Cr_Facturas_Procesar into Lr_Factura;
      EXIT WHEN Cr_Facturas_Procesar%NOTFOUND;
      --
      Ln_IdItemDetAuxImp := NULL;
      Ln_IdItemDetAuxBas := NULL;
      Ln_MontoBaseAcumulado := 0;
      Ln_ImpuestoAcumulado := 0;
      --
      FOR Lr_FacturaDet IN C_DETALLE_FACTURA ( Lr_Factura.Id_Documento ) LOOP

        --Empieza el proceso
        --Verifico si el detalle de la factura ya se migro
        Ln_DetalleDocId := NVL(F_VALIDAR_DOC_EXISTE(Lr_FacturaDet.id_doc_detalle,Lr_FacturaDet.impuesto_id),0);

        --Si no existe lo proceso
        IF Ln_DetalleDocId = 0 THEN
          --Si el plan es mayor a cero, se hace el proceso del plan
          IF Lr_FacturaDet.plan_id > 0 THEN
            --Sumarizado del valor del plan
            Ln_Sumatoria:=NVL(F_SUMATORIA_PLAN(Lr_FacturaDet.plan_id),0);

            --Si la sumatoria es cero, actualizo el valor con uno
            IF Ln_Sumatoria=0 THEN
              Ln_Sumatoria:=1;
            END IF;

            --Se obtiene el impuesto segun el detalle obtenido en el documento
            Ln_IdImpuesto := Lr_FacturaDet.impuesto_id;

            --Detalle del plan
            GET_DETALLE_PLAN(Lr_FacturaDet.plan_id,Lc_DetallePlan);

            LOOP
              FETCH Lc_DetallePlan INTO Lr_DetallePlan;
              EXIT WHEN Lc_DetallePlan%notfound;

              Ln_Porcentaje:=NVL(((Lr_DetallePlan.precio_item*100)/Ln_Sumatoria),0);

              --Desgloce x producto
              Ln_PrecioProrrateado   := ROUND(NVL(((Lr_FacturaDet.precio_venta_facpro_detalle*Ln_Porcentaje)/100),0),2);
              Ln_ImpuestoProrrateado := ROUND(NVL(((Lr_FacturaDet.valor_impuesto*Ln_Porcentaje)/100),0),2);
              --
              Ln_MontoBaseAcumulado := Ln_MontoBaseAcumulado + Ln_PrecioProrrateado;
              Ln_ImpuestoAcumulado  := Ln_ImpuestoAcumulado + Ln_ImpuestoProrrateado;
              --
              --Inserto el detalle de productos
              IF Ln_PrecioProrrateado >= 0 THEN
                Lr_InfoDocumentoDetProd:=null;
                Lr_InfoDocumentoDetProd.id_item_detalle := SEQ_INFO_DOC_DET_PROD.NEXTVAL;
                Lr_InfoDocumentoDetProd.DOCUMENTO_ID    := Lr_Factura.Id_Documento;
                Lr_InfoDocumentoDetProd.DETALLE_DOC_ID  := Lr_FacturaDet.id_doc_detalle;
                Lr_InfoDocumentoDetProd.EMPRESA_ID      := Lr_Factura.Empresa_Id;-- Lr_FacturaDet.empresa_id;
                Lr_InfoDocumentoDetProd.OFICINA_ID      := Lr_Factura.Oficina_Id;-- Lr_FacturaDet.oficina_id;
                Lr_InfoDocumentoDetProd.PLAN_ID         := Lr_FacturaDet.plan_id;
                --Porque estoy prorrateando
                Lr_InfoDocumentoDetProd.PRODUCTO_ID     := Lr_DetallePlan.producto_id;
                Lr_InfoDocumentoDetProd.IMPUESTO_ID     := 0;
                Lr_InfoDocumentoDetProd.PORCENTAJE      := Ln_Porcentaje;
                Lr_InfoDocumentoDetProd.VALOR           := Ln_PrecioProrrateado;
                Lr_InfoDocumentoDetProd.USR_CREACION    := 'telcos';
                Lr_InfoDocumentoDetProd.FE_CREACION     := sysdate;
                --
                INSERT_INFO_DOC_DET_PRODUC(Lr_InfoDocumentoDetProd,Pv_MsnError);
                --
                -- si tiene valor se respalda
                IF Ln_PrecioProrrateado > 0 THEN
                  Ln_IdItemDetAuxBas := Lr_InfoDocumentoDetProd.id_item_detalle;
                END IF;
                --
              END IF;
              --
              IF Ln_ImpuestoProrrateado >= 0 THEN
                Lr_InfoDocumentoDetProd:=null;
                Lr_InfoDocumentoDetProd.ID_ITEM_DETALLE := SEQ_INFO_DOC_DET_PROD.NEXTVAL;
                Lr_InfoDocumentoDetProd.DOCUMENTO_ID    := Lr_Factura.Id_documento;-- Lr_FacturaDet.documento_id;
                Lr_InfoDocumentoDetProd.DETALLE_DOC_ID  := Lr_FacturaDet.id_doc_detalle;
                Lr_InfoDocumentoDetProd.EMPRESA_ID      := Lr_Factura.Empresa_Id;-- Lr_FacturaDet.empresa_id;
                Lr_InfoDocumentoDetProd.OFICINA_ID      := Lr_Factura.Oficina_Id;-- Lr_FacturaDet.oficina_id;
                Lr_InfoDocumentoDetProd.PLAN_ID         := Lr_FacturaDet.plan_id;
                --Porque estoy prorrateando
                Lr_InfoDocumentoDetProd.PRODUCTO_ID     := Lr_DetallePlan.producto_id;
                Lr_InfoDocumentoDetProd.IMPUESTO_ID     := Ln_IdImpuesto;
                Lr_InfoDocumentoDetProd.PORCENTAJE      := Ln_Porcentaje;
                Lr_InfoDocumentoDetProd.VALOR           := Ln_ImpuestoProrrateado;
                Lr_InfoDocumentoDetProd.USR_CREACION    := 'telcos';
                Lr_InfoDocumentoDetProd.FE_CREACION     := sysdate;
                --
                INSERT_INFO_DOC_DET_PRODUC(Lr_InfoDocumentoDetProd,Pv_MsnError);
                --
                -- solo si tiene valor se respalda
                IF Ln_ImpuestoProrrateado > 0 THEN
                  Ln_IdItemDetAuxImp := Lr_InfoDocumentoDetProd.Id_Item_Detalle;
                END IF;
                --
              END IF;
            END LOOP; -- fin ciclo desgloce detalle producto por plan
          END IF;

          --
          --Si el producto es mayor a cero, se hace el proceso por producto
          IF Lr_FacturaDet.producto_id > 0 THEN
            Ln_DetalleDocId:=NVL(F_VALIDAR_DOC_EXISTE(Lr_FacturaDet.id_doc_detalle,0),0);
            -- si no ha sido registrado y monto redondeado es mayor a cero
            IF (Ln_DetalleDocId = 0) AND ROUND(Lr_FacturaDet.precio_venta_facpro_detalle, 2) >= 0 THEN
              Lr_InfoDocumentoDetProd:=null;
              --Inserto el detalle de productos
              Lr_InfoDocumentoDetProd.ID_ITEM_DETALLE := SEQ_INFO_DOC_DET_PROD.NEXTVAL;

              Lr_InfoDocumentoDetProd.DOCUMENTO_ID    := Lr_Factura.Id_Documento;-- Lr_FacturaDet.documento_id;
              Lr_InfoDocumentoDetProd.DETALLE_DOC_ID  := Lr_FacturaDet.id_doc_detalle;
              Lr_InfoDocumentoDetProd.EMPRESA_ID      := Lr_Factura.Empresa_Id;--Lr_FacturaDet.empresa_id;
              Lr_InfoDocumentoDetProd.OFICINA_ID      := Lr_Factura.Oficina_Id;--Lr_FacturaDet.oficina_id;
              Lr_InfoDocumentoDetProd.PLAN_ID         := Lr_FacturaDet.plan_id;
              Lr_InfoDocumentoDetProd.PRODUCTO_ID     := Lr_FacturaDet.producto_id;
              Lr_InfoDocumentoDetProd.IMPUESTO_ID     := 0;
              Lr_InfoDocumentoDetProd.PORCENTAJE      := 100;
              Lr_InfoDocumentoDetProd.VALOR           := ROUND(Lr_FacturaDet.precio_venta_facpro_detalle, 2);
              Lr_InfoDocumentoDetProd.USR_CREACION    := 'telcos';
              Lr_InfoDocumentoDetProd.FE_CREACION     := sysdate;
              --
              INSERT_INFO_DOC_DET_PRODUC(Lr_InfoDocumentoDetProd,Pv_MsnError);
              --
              Ln_MontoBaseAcumulado := Ln_MontoBaseAcumulado + Lr_InfoDocumentoDetProd.VALOR;
              --
              IF ROUND(Lr_FacturaDet.precio_venta_facpro_detalle, 2) > 0 THEN
                Ln_IdItemDetAuxBas := Lr_InfoDocumentoDetProd.ID_ITEM_DETALLE;
              END IF;
              --
            END IF; --fin existe registro detalle producto

            Ln_DetalleDocId:=NVL(F_VALIDAR_DOC_EXISTE(Lr_FacturaDet.id_doc_detalle,Lr_FacturaDet.impuesto_id),0);
            IF  Ln_DetalleDocId = 0  AND ROUND(Lr_FacturaDet.valor_impuesto, 2) >= 0 THEN
              --
              Lr_InfoDocumentoDetProd:=null;
              --Inserto el detalle de productos
              Lr_InfoDocumentoDetProd.ID_ITEM_DETALLE := SEQ_INFO_DOC_DET_PROD.NEXTVAL;

              Lr_InfoDocumentoDetProd.DOCUMENTO_ID    := Lr_Factura.Id_Documento;--Lr_FacturaDet.documento_id;
              Lr_InfoDocumentoDetProd.DETALLE_DOC_ID  := Lr_FacturaDet.id_doc_detalle;
              Lr_InfoDocumentoDetProd.EMPRESA_ID      := Lr_Factura.Empresa_Id;--Lr_FacturaDet.empresa_id;
              Lr_InfoDocumentoDetProd.OFICINA_ID      := Lr_Factura.Oficina_Id; --Lr_FacturaDet.oficina_id;
              Lr_InfoDocumentoDetProd.PLAN_ID         := Lr_FacturaDet.plan_id;
              Lr_InfoDocumentoDetProd.PRODUCTO_ID     := Lr_FacturaDet.producto_id;
              Lr_InfoDocumentoDetProd.IMPUESTO_ID     := Lr_FacturaDet.impuesto_id;
              Lr_InfoDocumentoDetProd.PORCENTAJE      := 100;
              Lr_InfoDocumentoDetProd.VALOR           := ROUND(Lr_FacturaDet.valor_impuesto, 2);
              Lr_InfoDocumentoDetProd.USR_CREACION    := 'telcos';
              Lr_InfoDocumentoDetProd.FE_CREACION     := sysdate;
              --
              INSERT_INFO_DOC_DET_PRODUC(Lr_InfoDocumentoDetProd,Pv_MsnError);
              --
              Ln_ImpuestoAcumulado  := Ln_ImpuestoAcumulado + Lr_InfoDocumentoDetProd.VALOR;
              --
              IF ROUND(Lr_FacturaDet.valor_impuesto, 2) > 0 THEN
                Ln_IdItemDetAuxImp := Lr_InfoDocumentoDetProd.Id_Item_Detalle;
              END IF;
              --
            END IF; --fin existe registro detalle producto impuesto
          END IF; --fin valida desgloce por producto
          --
        END IF; -- fin valida detalle factura procesado
        --
      END LOOP; -- fin ciclo detalle facturas
      --

      -- si existen diferencias en valor impuestos, se suma o resta del ultimo impuesto generado.
      IF Ln_ImpuestoAcumulado != Lr_Factura.Subtotal_Con_Impuesto THEN
        UPDATE INFO_DOCUMENTO_DETALLE_PRODUCT IDDP
        SET IDDP.VALOR = IDDP.VALOR + (Lr_Factura.Subtotal_Con_Impuesto - Ln_ImpuestoAcumulado)
        WHERE IDDP.ID_ITEM_DETALLE = Ln_IdItemDetAuxImp;
      END IF;
      --
      -- si existen diferencias en valor Base, se suma o resta del ultimo registro base generado.
      IF Ln_MontoBaseAcumulado != Lr_Factura.Subtotal THEN
        UPDATE INFO_DOCUMENTO_DETALLE_PRODUCT IDDP
        SET IDDP.VALOR = IDDP.VALOR + (Lr_Factura.Subtotal - Ln_MontoBaseAcumulado)
        WHERE IDDP.ID_ITEM_DETALLE = Ln_IdItemDetAuxBas;
      END IF;
      --
      --Cuando procesa los detalles puede enviar a totalizar pues ha terminado con el documento
      --Incremento el contador, para poder hacer el commit
      Ln_Contador:=Ln_Contador+1;
      IF Ln_Contador>=1000 THEN
        COMMIT;
        Ln_Contador:=1;
      END IF;
      --
    END LOOP; -- fin ciclo facturas

    CLOSE Cr_Facturas_Procesar;
   --Se procede asignar los valores correspondientes de los subotales en las tablas de facturacion
   P_ASIGNAR_VALOR_POR_DETALLE(Pv_PrefijoEmpresa,
                                Pv_FechaProcesoIni,
                                Pv_FechaProcesoFin,
                                Pn_IdDocumento);
    --
    COMMIT;
    --
  EXCEPTION
    WHEN Le_Error THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 
        'Telcos+', 
        'FNCK_FACTURACION_DETALLES.P_FACTURACION_DETALLE', 
        Lv_MensajeError,
        NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV, FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
        SYSDATE, 
        NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV, FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
      --      
    WHEN OTHERS THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 
        'Telcos+', 
        'FNCK_FACTURACION_DETALLES.P_FACTURACION_DETALLE', 
        SUBSTR(SQLERRM||' -> traza: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,4000),
        NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV, FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
        SYSDATE, 
        NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV, FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
      --
  END P_FACTURACION_DETALLE;
  --
END FNCK_FACTURACION_DETALLES;
/

