CREATE EDITIONABLE PACKAGE               FNKG_CONTABILIZAR_NCI
AS
 /**
  * Documentacion para FNKG_CONTABILIZAR_NCI
  *
  * Paquete que contiene Funciones y Procedimientos utilizados para la contabilizacion de las Notas de Credito Interna
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-10-2016
  */

  /*
  * Documentaci�n para TYPE 'TypeProductosFacturados'.
  * Record que me permite almancernar por producto los valores totales facturados
  */
  TYPE TypeNotaDeCreditoInterna IS RECORD (
        ID_OFICINA                  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        PUNTO_ID                    INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
        ID_DOCUMENTO                INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        FE_EMISION                  INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
        VALOR_TOTAL                 INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
        ID_CUENTA_CONTABLE          ADMI_CUENTA_CONTABLE.ID_CUENTA_CONTABLE%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeOficinasNci'.
  * Record que me permite almancernar por oficina los valores de las NCI
  */
  TYPE TypeOficinasNci IS RECORD (
        OFICINA_ID          DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
        NOMBRE_OFICINA      DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        TOTAL               INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
        ID_CUENTA_CONTABLE  ADMI_CUENTA_CONTABLE.ID_CUENTA_CONTABLE%TYPE
  );

  /*
  * Documentaci�n para TYPE 'TypeOficinasNciTab'.
  * Table para manejo de los arreglos
  */
  TYPE TypeOficinasNciTab IS TABLE OF TypeOficinasNci INDEX BY PLS_INTEGER;

   /**
  * Documentacion para el Procedimiento P_LISTADO_NCI_INDIVIDUAL
  *
  * Procedimiento para obtener el listado de notas de Credito Internas por individual
  *
  * @param Pv_CodEmpresa            IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Id del codigo de la empresa
  * @param Pv_CodigoTipoDocumento   IN   ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Id del codigo de documento a procesar (NCI)
  * @param Pv_IdDocumento           IN   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Id de la Nota de Credito Interna
  * @param Lrf_Listado              OUT   SYS_REFCURSOR, Parametro de Tipo Cursor que contiene las NCI por individual, contiene:
                                          [ID_OFICINA,
                                          PUNTO_ID,
                                          ID_DOCUMENTO,
                                          FE_EMISION,
                                          VALOR_TOTAL,
                                          ID_CUENTA_CONTABLE]
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-10-2016
  */
  PROCEDURE P_LISTADO_NCI_INDIVIDUAL(
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pn_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Lrf_Listado             OUT SYS_REFCURSOR
  );

  /**
  * Documentacion para el procedimiento P_LISTADO_POR_OFICINA
  *
  * Procedimiento para agrupar la data obtenida por oficina para su procesamiento
  *
  * @param Pv_CodEmpresa            IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Id del codigo de la empresa
  * @param Prf_Listado              IN   SYS_REFCURSOR,
  * @param Lr_OficinasFacturado     OUT  TypeOficinasNciTab Oficinas a procesar
  * @param Lr_Documentos            OUT  FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-10-2016
  */
  PROCEDURE P_LISTADO_POR_OFICINA(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Prf_Listado             IN  SYS_REFCURSOR,
    Lr_OficinasFacturado    OUT TypeOficinasNciTab,
    Lr_Documentos           OUT FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab
  );

  /**
  * Documentacion para el procedimiento P_PROCESAR
  *
  * Procedimiento para procesar la informacion de las notas de Credito contablemente
  *
  * @param Prf_Listado              IN  SYS_REFCURSOR,
  * @param Pv_CodEmpresa            IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Id del codigo de la empresa
  * @param Pv_Prefijo               IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Id del prefijo de la empresa
  * @param Pv_TipoProceso           IN   VARCHAR2 Tipo de procesamiento, se envia Individual
  * @param Pv_CodigoTipoDocumento   IN   ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Id del codigo de documento a procesar (NCI)
  * @param Pv_IdDocumento           IN   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Id de la Nota de Credito Interna
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-10-2016
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 14-08-2017 - Se agrega la funcion implementada en NAF 'NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE' para insertar en la tabla
  *                           'MIGRA_ARCGAE' respectivamente.
  *                           Se agrega la funci�n 'NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO' el cual guarda la relaci�n del detalle del
  *                           pago migrado con las tablas del NAF.
  * @author Lui Lindao <llindao@telconet.ec>
  * @version 1.2 08-02-2018 - Se modifica para considerar el uso de centros de costos para registro contable, se modifica tambien el registro de
  *                           documento asociado despues de generarse asiento contable.
  */
  PROCEDURE P_PROCESAR(
      Prf_Listado             IN  SYS_REFCURSOR,
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoProceso          IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
  );

  /**
  * Documentacion para el procedimiento P_CONTABILIZAR
  *
  * Procedimiento para obtener la data y procesarla asientos contables
  *
  * @param Pv_CodEmpresa            IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Id del codigo de la empresa
  * @param Pv_Prefijo               IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Id del prefijo de la empresa
  * @param Pv_CodigoTipoDocumento   IN   ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Id del codigo de documento a procesar (NCI)
  * @param Pv_TipoProceso           IN   VARCHAR2 Tipo de procesamiento, se envia Individual
  * @param Pv_IdDocumento           IN   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Id de la Nota de Credito Interna
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-10-2016
  */
  PROCEDURE P_CONTABILIZAR(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
  );
  --
 /**
  * Documentacion para funcion F_OBTENER_MOTIVO
  *
  * Obtiene Motivo registrado en el documento
  *
  * @param Pn_IdDocumento IN   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Id de la Nota de Credito Interna
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 28-10-2016
  */
  FUNCTION F_OBTENER_MOTIVO(
    Pn_IdDocumento      IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2;

  END FNKG_CONTABILIZAR_NCI;
/

CREATE EDITIONABLE PACKAGE BODY               FNKG_CONTABILIZAR_NCI
AS

 /*
 * Documentaci�n para FUNCION 'F_OBTENER_VALOR_PARAMETRO'.
 * FUNCION QUE OBTIENE PARAMETROS DE ECUANET PARA MIGRACION A COMPA�IA MEGADATOS
 * @author Jimmy Gilces <jgilces@telconet.ec>
 * @version 1.0
 * @since 27/03/2023
 * @Param varchar2 Pv_NombreParametro
 * @Param varchar2 Pv_Parametro
 * @return  VARCHAR2 (VALOR DEL PARAMETRO SOLICITADO)
 */
 FUNCTION F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro IN VARCHAR2,
                                    Pv_Parametro       IN VARCHAR2)
   RETURN VARCHAR2 IS
   CURSOR C_OBTENER_PARAMETRO(Cv_NombreParametro VARCHAR2,
                              Cv_Parametro       VARCHAR2) IS
     select apd.valor2
       from db_general.admi_parametro_cab apc,
            db_general.admi_parametro_det apd
      where apc.id_parametro = apd.parametro_id
        and apc.estado = apd.estado
        and apc.estado = 'Activo'
        and apc.nombre_parametro = Cv_NombreParametro
        and apd.valor1 = Cv_Parametro;
 
   Lv_ValorParametro DB_GENERAL.Admi_Parametro_Det.VALOR2%type;
 BEGIN
   IF C_Obtener_Parametro%ISOPEN THEN
     CLOSE C_Obtener_Parametro;
   END IF;
 
   OPEN C_Obtener_Parametro(Pv_NombreParametro, Pv_Parametro);
   FETCH C_Obtener_Parametro
     INTO Lv_ValorParametro;
   CLOSE C_Obtener_Parametro;
 
   RETURN Lv_ValorParametro;
 END;
 
  --Procedimiento para obtener el listado de notas de Credito Internas por individual
  PROCEDURE P_LISTADO_NCI_INDIVIDUAL(
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pn_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Lrf_Listado             OUT SYS_REFCURSOR
  )
  AS
    Lv_InfoError  VARCHAR2(2000);
  BEGIN
    OPEN Lrf_Listado FOR
      --
      SELECT IOG.ID_OFICINA,
        IDFC.PUNTO_ID,
        IDFC.ID_DOCUMENTO,
        IDFC.FE_EMISION,
        IDFC.VALOR_TOTAL,
        ACC.ID_CUENTA_CONTABLE

      FROM INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
      JOIN ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      --
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
      --
      LEFT JOIN DB_GENERAL.ADMI_MOTIVO AM ON AM.ID_MOTIVO=IDFD.MOTIVO_ID
      --
      JOIN ADMI_CUENTA_CONTABLE ACC ON ACC.VALOR_CAMPO_REFERENCIAL=IDFC.OFICINA_ID
      JOIN ADMI_TIPO_CUENTA_CONTABLE ATCC ON ATCC.ID_TIPO_CUENTA_CONTABLE=ACC.TIPO_CUENTA_CONTABLE_ID

      WHERE
      ATDF.CODIGO_TIPO_DOCUMENTO     = Pv_CodigoTipoDocumento
      AND IEG.COD_EMPRESA            = Pv_CodEmpresa
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Cerrado')
      AND IDFC.ID_DOCUMENTO          = Pn_IdDocumento
      AND IDFC.CONTABILIZADO         IS NULL
      --
      AND ACC.CAMPO_REFERENCIAL      = 'ID_OFICINA'
      AND ACC.OFICINA_ID             = IDFC.OFICINA_ID
      AND ATCC.DESCRIPCION           IN ('OTROS EGRESOS')

      GROUP BY IOG.ID_OFICINA,
      IDFC.PUNTO_ID,
      IDFC.ID_DOCUMENTO,
      IDFC.FE_EMISION,
      ACC.CUENTA,
      IDFC.VALOR_TOTAL,
      ACC.ID_CUENTA_CONTABLE;
      --

      EXCEPTION
        WHEN OTHERS THEN
        Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_LISTADO_NCI_INDIVIDUAL', Lv_InfoError);
  END P_LISTADO_NCI_INDIVIDUAL;

  PROCEDURE P_LISTADO_POR_OFICINA(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Prf_Listado             IN  SYS_REFCURSOR,
    Lr_OficinasFacturado    OUT TypeOficinasNciTab,
    Lr_Documentos           OUT FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab
  )
  AS
    Lv_InfoError             VARCHAR2(2000);
    Cr_Oficinas              SYS_REFCURSOR;
    Cr_Oficina               FNKG_CONTABILIZAR_FACT_NC.TypeoOficinas;
    Lrf_NotaDeCreditoInterna TypeNotaDeCreditoInterna;
    Ln_Total                 INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

  BEGIN
    /*--Proceso:
      --Obtengo las oficinas de la empresa, mediante la funcion
      --Las guardo en el arreglo y como indice
      --Despues de guardar las oficinas empiezo a recorrer el arreglo de oficinas_facturados, que debe estar ordenado por oficina
    */
    --
    FNKG_CONTABILIZAR_FACT_NC.P_OFICINAS_POR_EMPRESA(Pv_CodEmpresa,Cr_Oficinas);

    LOOP
      FETCH Cr_Oficinas into Cr_Oficina;
      EXIT WHEN Cr_Oficinas%NOTFOUND;
      Lr_OficinasFacturado(Cr_Oficina.ID_OFICINA).OFICINA_ID:=Cr_Oficina.ID_OFICINA;
      Lr_OficinasFacturado(Cr_Oficina.ID_OFICINA).NOMBRE_OFICINA:=Cr_Oficina.NOMBRE_OFICINA;
      --Documentos
      Lr_Documentos(Cr_Oficina.ID_OFICINA).OFICINA_ID:=Cr_Oficina.ID_OFICINA;

    END LOOP;

    Ln_Total:=0;
    LOOP
      FETCH Prf_Listado into Lrf_NotaDeCreditoInterna;
      EXIT WHEN Prf_Listado%NOTFOUND;
      --Obtengo valor para acumular
      IF(Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).TOTAL IS NULL) THEN
        Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).TOTAL:=0;
      END IF;

      Ln_Total:=Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).TOTAL;

      IF Lrf_NotaDeCreditoInterna.VALOR_TOTAL>0 THEN
        Ln_Total:=Ln_Total+Lrf_NotaDeCreditoInterna.VALOR_TOTAL;
      END IF;

      --Guardo los valores nuevos acumulados
      Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).TOTAL:=Ln_Total;
      Lr_OficinasFacturado(Lrf_NotaDeCreditoInterna.ID_OFICINA).ID_CUENTA_CONTABLE:=Lrf_NotaDeCreditoInterna.ID_CUENTA_CONTABLE;

      --Guardo los documentos por oficina unicamente
      Lr_Documentos(Lrf_NotaDeCreditoInterna.ID_OFICINA).DOCUMENTOS(Lrf_NotaDeCreditoInterna.ID_DOCUMENTO).ID_DOCUMENTO:=Lrf_NotaDeCreditoInterna.ID_DOCUMENTO;
      Lr_Documentos(Lrf_NotaDeCreditoInterna.ID_OFICINA).DOCUMENTOS(Lrf_NotaDeCreditoInterna.ID_DOCUMENTO).PUNTO_ID:=Lrf_NotaDeCreditoInterna.PUNTO_ID;
      --
    END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
        Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_LISTADO_POR_OFICINA', Lv_InfoError);
  END P_LISTADO_POR_OFICINA;

  FUNCTION F_OBTENER_MOTIVO(
    Pn_IdDocumento      IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2
  AS
    CURSOR C_NombreMotivo
      (Cn_IdDocumento      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
    ) IS
      SELECT
        am.NOMBRE_MOTIVO
      FROM INFO_DOCUMENTO_FINANCIERO_CAB idfc
      LEFT JOIN INFO_OFICINA_GRUPO iog on iog.ID_OFICINA=idfc.OFICINA_ID
      LEFT JOIN INFO_DOCUMENTO_FINANCIERO_DET idfd on idfd.DOCUMENTO_ID=idfc.ID_DOCUMENTO
      LEFT JOIN admi_motivo am on am.id_motivo=idfd.MOTIVO_ID
      LEFT JOIN admi_tipo_documento_financiero atdf on atdf.ID_TIPO_DOCUMENTO=idfc.tipo_documento_id
      WHERE atdf.CODIGO_TIPO_DOCUMENTO = 'NCI'
      AND idfc.id_documento            = Cn_IdDocumento;
    --
    Lv_StringMotivo   VARCHAR2(1000);
    --
    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError      VARCHAR2(2000);
  BEGIN
    IF C_NombreMotivo%ISOPEN THEN
      CLOSE C_NombreMotivo;
    END IF;
    --
    OPEN C_NombreMotivo(Pn_IdDocumento);
    --
    FETCH C_NombreMotivo INTO Lv_StringMotivo;
    --
    CLOSE C_NombreMotivo;
    --
    IF Lv_StringMotivo IS NULL THEN
      Lv_StringMotivo  := '';
    END IF;
    --
    RETURN Lv_StringMotivo;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.F_OBTENER_MOTIVO', Lv_InfoError);
  END F_OBTENER_MOTIVO;

  PROCEDURE P_PROCESAR(
      Prf_Listado             IN  SYS_REFCURSOR,
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoProceso          IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
      )
  AS

    --Asiento contable
    Lv_CodDiario              VARCHAR2(100);
    Lv_NoAsiento              VARCHAR2(1000);
    Lv_UsrCreacion            VARCHAR2(1000);
    Lv_Descripcion            VARCHAR2(240);
    Pv_CampoReferencial       VARCHAR2(100);
    Pv_ValorCampoReferencial  VARCHAR2(100);
    Cr_CtaContable            VARCHAR2(100);
    Cr_NoCta                  VARCHAR2(100);

     --Tipo de record
    Lr_OficinasFacturado      TypeOficinasNciTab;
    Pr_Arreglo                FNKG_CONTABILIZAR_FACT_NC.TypeArreglo;
    Ln_ValorTotal             INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

    Lr_Documentos             FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab;
    Lr_InfoDocumento           FNKG_CONTABILIZAR_FACT_NC.TypeInfoDocumento;
    Lv_NumeroFacturaSri       INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;

    --Tipo para la plantilla
    Lr_Plantilla              FNKG_CONTABILIZAR_FACT_NC.TypePlantillaCab;
    Lr_PlantillaDet           FNKG_CONTABILIZAR_FACT_NC.TypePlantillaDet;

    --Tablas ed contabilidad
    Lr_MigraArcgae            MIGRA_ARCGAE%ROWTYPE;
    Lr_MigraArcgal            MIGRA_ARCGAL%ROWTYPE;
    --
    Pn_Monto                  INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Lv_PlantillaDescripcion   ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE;

    --Recorridos de arreglos
    Ln_OficinaIdx             DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
    Ln_LineaId               NUMBER;

    --Para el manejo de la fecha
    Ld_FeCreacion             DATE;

    --Para manejo de errores
    Pv_MsnError               VARCHAR2(4000);

    --Glosa contable
    Lv_FormatoGlosa           ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_GLOSA%TYPE;
    Lv_FormatoNoAsiento       ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_NO_DOCU_ASIENTO%TYPE;

    --Fechas
    Lv_Anio                   VARCHAR2(1000);
    Lv_Mes                    VARCHAR2(1000);

    --Plantilla
    Cr_PlantillaCab           SYS_REFCURSOR;
    Cr_PlantillaDet           SYS_REFCURSOR;
    Cr_InfoDocumento          SYS_REFCURSOR;
    --
    Le_Exception EXCEPTION;
    Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    Lrf_GetAdmiParametrosDet  SYS_REFCURSOR;
    Lr_GetAdmiParametrosDet   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
    --
    Ln_IdMigracion33 naf47_tnet.migra_arckmm.id_migracion%type;
    Ln_IdMigracion18 naf47_tnet.migra_arckmm.id_migracion%type;
  
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
  BEGIN
    --
    P_LISTADO_POR_OFICINA(Pv_CodEmpresa,Prf_Listado,Lr_OficinasFacturado,Lr_Documentos);
    --Ya tengo las oficinas que se procesaron o se procesaran debo recorrer
    --y enviar los parametros que quien se va a totalizar
    Ln_OficinaIdx := Lr_OficinasFacturado.FIRST;
    LOOP
      
      Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      
      EXIT WHEN Ln_OficinaIdx IS NULL;
      --
      Lv_PlantillaDescripcion:='NOTA DE CREDITO INTERNA INDIVIDUAL';
      --
      FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_CAB(Pv_CodigoTipoDocumento,Lv_PlantillaDescripcion,Pv_CodEmpresa,Cr_PlantillaCab);
      FETCH Cr_PlantillaCab INTO Lr_Plantilla;

      --Obtengo la data de la plantilla
      Lv_CodDiario:= Lr_Plantilla.COD_DIARIO;
      Ln_ValorTotal:=Lr_OficinasFacturado(Ln_OficinaIdx).TOTAL;
      --
      --Cuando el totalizado no existe, no debe crear cabecera
      IF (Ln_ValorTotal>0)THEN
        --
        Lv_NumeroFacturaSri:= '';
        --Parametros necesario de manera externa
        IF Pv_TipoProceso='INDIVIDUAL' THEN
          --Data por individual
          FNKG_CONTABILIZAR_FACT_NC.O_OBTENER_DATA_DOCUMENTO(Pv_IdDocumento,Cr_InfoDocumento);
          FETCH Cr_InfoDocumento INTO Lr_InfoDocumento;
          FNKG_CONTABILIZAR_FACT_NC.P_SPLIT(TO_CHAR(Lr_InfoDocumento.FE_EMISION),'-',Pr_Arreglo);
          Lv_Anio             :=  Pr_Arreglo(0);
          Lv_Mes              :=  Pr_Arreglo(1);
          Ld_FeCreacion       :=  TO_DATE(Lr_InfoDocumento.FE_EMISION,'YYYY-MM-DD');
          Lv_UsrCreacion      :=  Lr_InfoDocumento.USR_CREACION;
          Lv_NoAsiento        :=  Pv_IdDocumento;
          Lv_NumeroFacturaSri :=  Lr_InfoDocumento.NUMERO_FACTURA_SRI;
        END IF;

        --Leyendo la plantilla, segun el proceso
        IF Lr_Plantilla.TABLA_CABECERA='MIGRA_ARCGAE' THEN
          --
          Lv_FormatoGlosa:=Lr_Plantilla.FORMATO_GLOSA;
          Lv_FormatoNoAsiento:=Lr_Plantilla.FORMATO_NO_DOCU_ASIENTO;
          --
          FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_DESCRIPCION(
            Lv_FormatoGlosa,
            TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
            Lr_OficinasFacturado(Ln_OficinaIdx).NOMBRE_OFICINA,
            Lr_InfoDocumento.LOGIN,
            Lv_NumeroFacturaSri,
            Lv_Descripcion
          );

          FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_NO_ASIENTO(
            Lv_FormatoNoAsiento,
            TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
            Pv_IdDocumento,
            Ln_OficinaIdx,
            Lv_NoAsiento
          );
          --
          --
          Lr_MigraArcgae.ID_FORMA_PAGO          := NULL;
          Lr_MigraArcgae.ID_OFICINA_FACTURACION := Ln_OficinaIdx;
          --
          IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
           Lr_MigraArcgae.ID_MIGRACION    := NAF47_TNET.TRANSA_ID.MIGRA_CG ( Lv_EmpresaOrigen );
           Ln_IdMigracion33 := Lr_MigraArcgae.ID_MIGRACION;
           Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CG ( Lv_EmpresaDestino );
          ELSE
           Lr_MigraArcgae.ID_MIGRACION     := NAF47_TNET.TRANSA_ID.MIGRA_CG( Pv_CodEmpresa );
          END IF;
          
          Lr_MigraArcgae.NO_CIA           := Pv_CodEmpresa;
          Lr_MigraArcgae.ANO              :=  Lv_Anio;
          Lr_MigraArcgae.MES              :=  Lv_Mes;
          Lr_MigraArcgae.FECHA            :=  Ld_FeCreacion;
          Lr_MigraArcgae.NO_ASIENTO       :=  SUBSTR(Lv_NoAsiento,1,12);
          Lr_MigraArcgae.DESCRI1          :=  SUBSTR(Lv_Descripcion, 1, 240);
          Lr_MigraArcgae.ESTADO           := 'P';
          Lr_MigraArcgae.AUTORIZADO       := 'N';
          Lr_MigraArcgae.ORIGEN           :=  Pv_Prefijo;
          Lr_MigraArcgae.T_DEBITOS        :=  Ln_ValorTotal;
          Lr_MigraArcgae.T_CREDITOS       :=  Ln_ValorTotal;
          Lr_MigraArcgae.COD_DIARIO       :=  Lv_CodDiario;
          Lr_MigraArcgae.T_CAMB_C_V       := 'C';
          Lr_MigraArcgae.TIPO_CAMBIO      := '1';
          Lr_MigraArcgae.TIPO_COMPROBANTE := 'T';
          Lr_MigraArcgae.ANULADO          := 'N';
          Lr_MigraArcgae.USUARIO_CREACION :=  Lv_UsrCreacion;
          Lr_MigraArcgae.TRANSFERIDO      := 'N';
          Lr_MigraArcgae.FECHA_CREACION   :=  SYSDATE;
          --
          Pv_MsnError := NULL;
          --
          NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Pv_MsnError);
          --
          IF Pv_MsnError IS NOT NULL THEN
            --
            Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAE. - ID_DOCUMENTO( ' ||
                           Pv_IdDocumento || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
            --
            RAISE Le_Exception;
            --
          END IF;
          --
          IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
            DECLARE
             Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
            BEGIN
              select id_oficina INTO Ln_IdOficina
                          from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                         where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                     from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                    where a.id_oficina = Ln_OficinaIdx);
                                                    
              Lr_MigraArcgae.ID_MIGRACION     := Ln_IdMigracion18;
              Lr_MigraArcgae.ID_OFICINA_FACTURACION := Ln_IdOficina;
              Lr_MigraArcgae.NO_CIA           := Lv_EmpresaDestino;
            
              NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae, Pv_MsnError);
          --
              IF Pv_MsnError IS NOT NULL THEN
                --
                Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAE. - ID_DOCUMENTO( ' ||
                               Pv_IdDocumento || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                --
                RAISE Le_Exception;
                --
              END IF;
            
              Lr_MigraArcgae.ID_OFICINA_FACTURACION := Ln_OficinaIdx;
              Lr_MigraArcgae.ID_MIGRACION     := Ln_IdMigracion33;
              Lr_MigraArcgae.NO_CIA           := Lv_EmpresaOrigen;
            END;
          END IF;
          --
          --Leyendo detalle de plantilla, segun proceso
          --Cuando tengo la plantillaDet, busco sus cuentas contable enlazadas
          Ln_LineaId :=  0;

          FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_DET(Lr_Plantilla.ID_PLANTILLA_CONTABLE_CAB,Cr_PlantillaDet);
          LOOP
            FETCH Cr_PlantillaDet INTO Lr_PlantillaDet;
            EXIT WHEN Cr_PlantillaDet%NOTFOUND;
            --
            Lv_FormatoGlosa:=Lr_PlantillaDet.FORMATO_GLOSA;
            --
            FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_DESCRIPCION(
              Lv_FormatoGlosa,
              TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
              Lr_OficinasFacturado(Ln_OficinaIdx).NOMBRE_OFICINA,
              Lr_InfoDocumento.LOGIN,
              Lv_NumeroFacturaSri,
              Lv_Descripcion
            );

            --Valores fijos
            Lr_MigraArcgal.MIGRACION_ID           :=  Lr_MigraArcgae.ID_MIGRACION;
            Lr_MigraArcgal.NO_CIA                 :=  Pv_CodEmpresa;
            Lr_MigraArcgal.ANO                    :=  Lv_Anio;
            Lr_MigraArcgal.MES                    :=  Lv_Mes;
            Lr_MigraArcgal.NO_ASIENTO             :=  SUBSTR(Lv_NoAsiento,1,12);
            Lr_MigraArcgal.NO_LINEA               :=  Ln_LineaId;
            Lr_MigraArcgal.DESCRI                 :=  SUBSTR(Lv_Descripcion, 1, 100);
            Lr_MigraArcgal.COD_DIARIO             :=  Lv_CodDiario;
            Lr_MigraArcgal.MONEDA                 :=  'P';
            Lr_MigraArcgal.TIPO_CAMBIO            :=  '1';
            Lr_MigraArcgal.FECHA                  :=  Ld_FeCreacion;
            Lr_MigraArcgal.TIPO                   :=  Lr_PlantillaDet.POSICION;
            Lr_MigraArcgal.CC_1                   :=  '000';
            Lr_MigraArcgal.CC_2                   :=  '000';
            Lr_MigraArcgal.CC_3                   :=  '000';
            Lr_MigraArcgal.LINEA_AJUSTE_PRECISION :=  'N';
            Lr_MigraArcgal.TRANSFERIDO            :=  'N';

            --Campo referenciales
            IF(Lr_PlantillaDet.TIPO_CUENTA_CONTABLE='CLIENTES' or Lr_PlantillaDet.TIPO_CUENTA_CONTABLE='OTROS EGRESOS') THEN
              Pv_CampoReferencial:='ID_OFICINA';
              Pv_ValorCampoReferencial:=Ln_OficinaIdx;
              Pn_Monto  :=Ln_ValorTotal;
            END IF;

            --Proceso segun el tipo de detalle
            IF(Lr_PlantillaDet.TIPO_DETALLE='FIJO')THEN
              FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_CUENTA_CONTABLE(Pv_CodEmpresa,
                                                                  Lr_PlantillaDet.TIPO_CUENTA_CONTABLE,
                                                                  Pv_CampoReferencial,
                                                                  Pv_ValorCampoReferencial,
                                                                  Ln_OficinaIdx,
                                                                  Cr_CtaContable,
                                                                  Cr_NoCta);
              Ln_LineaId :=  Ln_LineaId+1;
              --Segun el tipo modificamos lo siguiente
              Lr_MigraArcgal.NO_LINEA   :=  Ln_LineaId;
              Lr_MigraArcgal.CUENTA     :=  Cr_CtaContable;
              --
              -- Tambien se valida si cuenta contable recuperar acepta centro de costos
              IF NAF47_TNET.CUENTA_CONTABLE.acepta_cc (Lr_MigraArcgal.NO_CIA, Lr_MigraArcgal.CUENTA) THEN
                -- si cuenta contable maneja centro de costo se busca en la parametrizacion
                --BLOQUE QUE VERIFICA SI EXISTE LA OPCION EN LOS PARAMETROS PARA COLOCAR EL COSTO A LOS PAGOS CON PROVISION INCOBRABLE
                Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(
                                            'SHOW_OPCION_BY_EMPRESA',
                                            'Activo',
                                            'Activo',
                                            Lr_MigraArcgae.ID_OFICINA_FACTURACION,
                                            Lr_MigraArcgae.no_cia,
                                            NULL,
                                            NULL );
                --
                FETCH Lrf_GetAdmiParametrosDet INTO Lr_GetAdmiParametrosDet;
                CLOSE Lrf_GetAdmiParametrosDet;
                --
                -- se verifica que retorne valores
                IF Lr_GetAdmiParametrosDet.ID_PARAMETRO_DET IS NULL THEN
                  --
                  Pv_MsnError := 'No se ha configurado Centro de costo para FormaPago: ' || Lr_MigraArcgae.id_forma_pago || ' y oficina: ' ||
                                 Lr_MigraArcgae.id_oficina_facturacion;
                  --
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                                        'FNKG_CONTABILIZAR_PAGO_MANUAL.CREA_DEBITO_CREDITO',
                                                        Pv_MsnError,
                                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                                        SYSDATE,
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                  --
                  RAISE Le_Exception;
                  --
                END IF;
                --
                Lr_MigraArcgal.Cc_1 := Lr_GetAdmiParametrosDet.VALOR3;
                Lr_MigraArcgal.Cc_2 := Lr_GetAdmiParametrosDet.VALOR4;
                Lr_MigraArcgal.Cc_3 := Lr_GetAdmiParametrosDet.VALOR5;
                --
              END IF;
              --
              Lr_MigraArcgal.CENTRO_COSTO           :=  Lr_MigraArcgal.Cc_1||Lr_MigraArcgal.Cc_2||Lr_MigraArcgal.Cc_3;
              --

              --Insertando
              ---Guardo los montos correspondientes
              FNKG_CONTABILIZAR_FACT_NC.P_POSICION_VALOR(Lr_PlantillaDet.POSICION,Pn_Monto);
              Lr_MigraArcgal.MONTO      :=  Pn_Monto;
              Lr_MigraArcgal.MONTO_DOL  :=  Pn_Monto;
              --
              Pv_MsnError := NULL;
              --
              NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal, Pv_MsnError);
              --
              IF Pv_MsnError IS NOT NULL THEN
                --
                Pv_MsnError := 'Error al insertar el detalle del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAL. - ID_DOCUMENTO( ' ||
                               Pv_IdDocumento || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                --
                RAISE Le_Exception;
                --
              END IF;
              
              IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                                                                        
                  Lr_MigraArcgal.MIGRACION_ID     := Ln_IdMigracion18;
                  Lr_MigraArcgal.NO_CIA := Lv_EmpresaDestino;
                
                  NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal, Pv_MsnError);
              --
                  IF Pv_MsnError IS NOT NULL THEN
                    --
                    Pv_MsnError := 'Error al insertar el detalle del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAL. - ID_DOCUMENTO( ' ||
                               Pv_IdDocumento || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                    --
                    RAISE Le_Exception;
                    --
                  END IF;
                  
                  Lr_MigraArcgal.MIGRACION_ID     := Ln_IdMigracion33;
                  Lr_MigraArcgal.NO_CIA := Lv_EmpresaOrigen;
              END IF;
              --
            END IF;
          END LOOP;

          CLOSE Cr_PlantillaDet;
          --
          --
          -- LO MARCAMOS COMO CONTABILIZADO CUANDO EL PROCESO NO PRESENTA ERRORES.
          IF Pv_MsnError IS NULL THEN
            --
            FNKG_CONTABILIZAR_FACT_NC.P_MARCAR_CONTABILIZADO(Pv_IdDocumento,Pv_TipoProceso);
            --
            Lr_MigraDocumentoAsociado                     := NULL;
            Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := Pv_IdDocumento;
            Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := Lv_CodDiario;
            Lr_MigraDocumentoAsociado.NO_CIA              := Pv_CodEmpresa;
            Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := NULL;
            Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := '8';
            Lr_MigraDocumentoAsociado.ESTADO              := 'M';
            Lr_MigraDocumentoAsociado.USR_CREACION        := Lr_InfoDocumento.USR_CREACION;
            Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
            Lr_MigraDocumentoAsociado.MIGRACION_ID        := Lr_MigraArcgae.ID_MIGRACION;
            Lr_MigraDocumentoAsociado.TIPO_MIGRACION      := 'CG';
            --
            --
            IF Lr_MigraDocumentoAsociado.MIGRACION_ID IS NOT NULL AND Lr_MigraDocumentoAsociado.MIGRACION_ID > 0 THEN
              --
              Pv_MsnError := NULL;
              --
              NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MsnError);
              --
              IF Pv_MsnError IS NOT NULL THEN
                --
                Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento ||
                ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                --
                RAISE Le_Exception;
                --
              END IF;
              
              IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                Lr_MigraDocumentoAsociado.NO_CIA              := Lv_EmpresaDestino;
                Lr_MigraDocumentoAsociado.MIGRACION_ID        := Ln_IdMigracion18;
                
                NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MsnError);
                --
                IF Pv_MsnError IS NOT NULL THEN
                  --
                  Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento ||
                  ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                  --
                  RAISE Le_Exception;
                  --
                END IF;
                
                Lr_MigraDocumentoAsociado.NO_CIA              := Pv_CodEmpresa;
                Lr_MigraDocumentoAsociado.MIGRACION_ID        := Lr_MigraArcgae.ID_MIGRACION;
              END IF;
            --
            ELSE
              --
              Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento ||
              ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
              --
              RAISE Le_Exception;
             --
            END IF;
          --
          END IF;
          --
        END IF;
      ELSE
        --Informe de error en el proceso
        Pv_MsnError := 'No se contabiliza variable Ln_ValorTotal.TOTAL:'||Ln_ValorTotal ||' Ln_OficinaIdx:' ||Ln_OficinaIdx;
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_CONTABILIZAR',Pv_MsnError);
      END IF;
      --Cierro la plantilla
      CLOSE Cr_PlantillaCab;
      --Aumento el indice de las oficinas
      Ln_OficinaIdx := Lr_OficinasFacturado.NEXT(Ln_OficinaIdx);
      --
    END LOOP;
    --
    --Se guarda la transaccion realizada
    COMMIT;
    --
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    Pv_MsnError := Pv_MsnError || ' - Error:' || DBMS_UTILITY.FORMAT_ERROR_STACK || '-' || DBMS_UTILITY.format_call_stack || chr(13) || ' : ' ||
                   DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_NCI.P_PROCESAR',
                                          Pv_MsnError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  WHEN OTHERS THEN
    --
    Pv_MsnError := Pv_MsnError || ' - Error:' || DBMS_UTILITY.FORMAT_ERROR_STACK || '-' || DBMS_UTILITY.format_call_stack || chr(13) || ' : ' ||
                   DBMS_UTILITY.FORMAT_ERROR_STACK;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNKG_CONTABILIZAR_NCI.P_PROCESAR',
                                          Pv_MsnError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  END P_PROCESAR;

  --Contabilizar NCI
  PROCEDURE P_CONTABILIZAR(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento  IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pv_IdDocumento          IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
  )
  AS
    Lrf_Listado                SYS_REFCURSOR;
    --Para manejo de errores
    Lv_MsnError               VARCHAR2(3000);
    --
    Lv_StringMotivo           VARCHAR2(1000);
    --

  BEGIN
    IF Pv_TipoProceso='INDIVIDUAL' THEN
      Lv_StringMotivo  := F_OBTENER_MOTIVO(Pv_IdDocumento);
       --
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_CONTABILIZAR',
      'Data Lv_StringMotivo:'||Lv_StringMotivo || 'Pv_IdDocumento:' ||Pv_IdDocumento);
      --
      P_LISTADO_NCI_INDIVIDUAL(Pv_CodEmpresa,Pv_CodigoTipoDocumento,Pv_IdDocumento,Lrf_Listado);
        --
      P_PROCESAR(
          Lrf_Listado,
          Pv_CodEmpresa,
          Pv_Prefijo,
          Pv_TipoProceso,
          Pv_CodigoTipoDocumento,
          Pv_IdDocumento
          );
      --
    END IF;
    --
    EXCEPTION
      WHEN OTHERS THEN
        Lv_MsnError:='Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13);
        DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('CONTABILIDAD', 'FNKG_CONTABILIZAR_NCI.P_CONTABILIZAR', Lv_MsnError);
  END P_CONTABILIZAR;

END FNKG_CONTABILIZAR_NCI;
/