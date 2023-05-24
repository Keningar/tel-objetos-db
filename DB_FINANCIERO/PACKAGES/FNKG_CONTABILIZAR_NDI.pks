CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_CONTABILIZAR_NDI
AS
/**
  * Documentacion para FNKG_CONTABILIZAR_NDI
  *
  * Paquete que contiene Funciones y Procedimientos utilizados para la contabilizacion de las Notas de Debito Internas
  *    
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 14-11-2016
  */

  /*
  * Documentaci n para TYPE 'TypeNotaDeDebito'.
  * Record que me permite almancernar por producto los valores totales facturados
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 06-01-2017
  * Se modifica para agregar campo banco tipo cuenta
  */
  TYPE TypeNotaDeDebito IS RECORD (
        ID_OFICINA                  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE, 
        PUNTO_ID                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
        ID_DOCUMENTO                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
        FE_EMISION                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_EMISION%TYPE,
        CODIGO_FORMA_PAGO           DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
        DEPOSITADO                  DB_FINANCIERO.INFO_PAGO_DET.DEPOSITADO%TYPE,
        DEPOSITO_PAGO_ID            DB_FINANCIERO.INFO_PAGO_DET.DEPOSITO_PAGO_ID%TYPE,
        PRECIO_VENTA_FACPRO_DETALLE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE,
        CUENTA_CONTABLE_ID          DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE,
        BANCO_TIPO_CUENTA_ID        DB_FINANCIERO.INFO_PAGO_DET.BANCO_TIPO_CUENTA_ID%TYPE
  );

  /*
  * Documentaci n para TYPE 'TypeOficinasNdi'.
  * Record que me permite almancernar por oficina los valores de las NDI
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.0 06-01-2017
  * Se modifica para agregar campo banco tipo cuenta
  */
  TYPE TypeOficinasNdi IS RECORD (
        OFICINA_ID           DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE, 
        NOMBRE_OFICINA       DB_COMERCIAL.INFO_OFICINA_GRUPO.NOMBRE_OFICINA%TYPE,
        CODIGO_FORMA_PAGO    DB_GENERAL.ADMI_FORMA_PAGO.CODIGO_FORMA_PAGO%TYPE,
        DEPOSITADO           DB_FINANCIERO.INFO_PAGO_DET.DEPOSITADO%TYPE,
        TOTAL                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE,
        CUENTA_CONTABLE_ID   DB_FINANCIERO.INFO_PAGO_DET.CUENTA_CONTABLE_ID%TYPE,
        BANCO_TIPO_CUENTA_ID DB_FINANCIERO.INFO_PAGO_DET.BANCO_TIPO_CUENTA_ID%TYPE
  );

  /*
  * Documentaci n para TYPE 'TypeOficinasNdiTab'.
  * Table para manejo de los arreglos
  */
  TYPE TypeOficinasNdiTab IS TABLE OF TypeOficinasNdi INDEX BY PLS_INTEGER;

  /*
  * Documentaci n para TYPE 'TypeMotivos'.
  * Table para manejo de los motivos segun el proceso
  */
  TYPE TypeMotivos IS TABLE OF DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE;

 /**
  * Documentacion para el procedimiento P_LISTADO_NDI
  *
  * Procedimiento para obtener el listado de ndi segun los motivos correspondientes al proceso masivo
  *  
  * @param Pv_CodEmpresa            IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE                         Empresa a procesar
  * @param Pv_FechaProceso          IN   VARCHAR2                                                                 Fecha del proceso  
  * @param Pv_FlatPlantilla         IN   VARCHAR2                                                                 Bandera que indica el tipo de
  *                                                                                                               plantilla a generar
  * @param Pv_CodigoTipoDocumento   IN   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE  Tipo de documento del proceso
  * @param Cr_Listado               OUT  SYS_REFCURSOR                                                            Listado de NDI a procesar
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 07-08-2017 - Se cambia el par metro de entrada 'Lv_ListadoMotivos' a 'Pv_FlatPlantilla'
  *                           Se modifica el query para retornar las NDI que correspondan a los motivos guardados en la tabla
  *                           'DB_GENERAL.ADMI_PARAMETRO_DET' de acuerdo al par metro 'Pv_FlatPlantilla'
  */
  PROCEDURE P_LISTADO_NDI(
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_FechaProceso         IN  VARCHAR2,
      Pv_FlatPlantilla        IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Cr_Listado              OUT SYS_REFCURSOR
  );

 /**
  * Documentacion para el procedimiento P_LISTADO_NDI_INDIVIDUAL
  *
  * Procedimiento para obtener el listado de notas de debito por individual
  *  
  * @param Pv_CodEmpresa            IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE           Empresa a procesar
  * @param Pv_CodigoTipoDocumento   IN   ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE  Tipo de documento del proceso
  * @param Pn_IdDocumento           IN   INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE            Id_Documento a procesar
  * @param Cr_Listado               OUT  SYS_REFCURSOR                                              Listado de NDI a procesar
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 06-01-2017
  * Se modifica para agregar el campo banco tipo cuenta en la consulta que recupera para procesar contabilizaci n
  */
  PROCEDURE P_LISTADO_NDI_INDIVIDUAL(
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pn_IdDocumento          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Cr_Listado              OUT SYS_REFCURSOR
  );

 /**
  * Documentacion para el procedimiento P_LISTADO_POR_OFICINA
  *
  * Procedimiento para agrupar la data obtenida por oficina para su procesamiento
  *  
  * @param Pv_CodEmpresa            IN   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE           Empresa a procesar
  * @param Cr_Listado               IN   SYS_REFCURSOR                                              Listado de NDI a procesar
  * @param Cr_OficinasFacturado     IN   TypeOficinasNdiTab                                         Tipo de documento del proceso
  * @param Pr_Documentos            IN   FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab      Id_Documento a procesar
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0
  */
  PROCEDURE P_LISTADO_POR_OFICINA(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cr_Listado              IN  SYS_REFCURSOR,
    Cr_OficinasFacturado    OUT TypeOficinasNdiTab,
    Pr_Documentos           OUT DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab
  );

 /**
  * Documentacion para el funcion F_VALOR_CARACTERISTICA
  *
  * Funcion para verificar la caracteristica ligada al documento
  *  
  * @param Pn_IdDocumento       IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE    Id_Documento a verificar
  * @param Pv_DescripcionCarac  IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE Caracteristica a buscar                                            Listado de NDI a procesar
  * @param NUMBER               OUT Valor de Multa
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0
  */
  FUNCTION F_VALOR_CARACTERISTICA(
    Pn_IdDocumento      IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_DescripcionCarac IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  RETURN NUMBER;

 /**
  * Documentacion para el funcion F_VERIFICAR_MOTIVO
  *
  * Funcion para verificar si el motivo para el proceso individual existe en el listado de los motivos masivos
  *  
  * @param Pv_ListadoMotivos   IN  TypeMotivos                                  Listado de motivos para el proceso
  * @param Pv_MotivoDocumento  IN  DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE    Motivo a verificar
  * @param VARCHAR2            Bander de coincidencia
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0
  */
  FUNCTION F_VERIFICAR_MOTIVO(
    Pv_ListadoMotivos   IN TypeMotivos,
    Pv_MotivoDocumento  IN DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE)
  RETURN VARCHAR2;

 /**
  * Documentacion para el funcion F_GENERAR_NOMBRE_PLANTILLA
  *
  * Funcion para generar el nombre de la plantilla
  *  
  * @param Pv_CodigoTipoDocumento   IN  ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE  Tipo de documento del proceso
  * @param Pv_TipoProceso           IN  VARCHAR2                                                   Indicador del proceso ejecutado
  * @param Pn_FlatDepositado        IN  VARCHAR2                                                   Variable indicadora del deposito
  * @param Pn_FlatPlantilla         IN  VARCHAR2                                                   Variable indicadora para plantilla
  * @param VARCHAR2                 Nombre de la plantilla
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 08-08-2017 - Se obtiene el nombre de la plantilla mediante par metros guardados en base dependiendo del tipo de proceso, tipo de
  *                           documento y forma de pago.
  *                           Se agrega el par metro 'Pv_CodEmpresa' para realizar la b squeda por C digo de Empresa.
  */
  FUNCTION F_GENERAR_NOMBRE_PLANTILLA(
    Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pn_FlatDepositado       IN  DB_FINANCIERO.INFO_PAGO_DET.DEPOSITADO%TYPE,
    Pn_FlatPlantilla        IN  VARCHAR2,
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  )RETURN VARCHAR2;

 /**
  * Documentacion para P_PROCESAR
  *
  * Procedimiento para procesar la informacion de las notas de debito contablemente
  *    
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * Se habilita el escenario en el cual se debe sumarizar al total de la nota de d bito interna el valor de la multa 
  * para el caso de NDI por  Registro de devolucion de cheque , se modifica asiento contable ya que las NDI sumaran 
  * al total de la NDI el valor de multa.
  * @version 1.1 14-11-2016   
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.2 17-03-2017 - Se quita la funci n SUBSTR de las columnas 'Lr_MigraArcgae.NO_ASIENTO' para que el n mero de asiento generado coincida
  *                           con el formato ingresado en la 'DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB', y se pueda realizar la comparaci n de lo
  *                           guardado en TELCOS+ con lo migrado al NAF por la columna 'FORMATO_NO_DOCU_ASIENTO'.
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.3 08-08-2017 - Se env a el par metro 'Pv_CodEmpresa' a la funci n 'F_GENERAR_NOMBRE_PLANTILLA' para realizar la b squeda por c digo
  *                           de empresa.
  */
  PROCEDURE P_PROCESAR(
      Cr_Listado              IN  SYS_REFCURSOR,
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoProceso          IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_IdDocumento          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pt_Fe_Actual            IN  VARCHAR2,
      Pn_FlatPlantilla        IN  VARCHAR2
  );

  /**
  * Documentacion para el procedimiento F_GENERAR_LISTADO_MOTIVOS
  *
  * Funcion para generar el listado de motivos a procesar
  *  
  * @param F_IdxMasivo     IN   NUMBER      Id del codigo masivo en proceso
  * @param Pv_TipoProceso  IN   VARCHAR2    Indicador del proceso ejecutado  
  * @param TypeMotivos     OUT  TypeMotivos Listado de Motivos asociados al masivo
  *
  * Se agregan motivos no considerados en el proceso masivo
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.1 29-11-2016
  */
  FUNCTION F_GENERAR_LISTADO_MOTIVOS(
      F_IdxMasivo     IN NUMBER,
      Pv_TipoProceso  IN  VARCHAR2
      )
  RETURN TypeMotivos;

 /**
  * Documentacion para el procedimiento P_CONTABILIZAR
  *
  * Procedimiento para obtener la data y procesarla segun el tipo
  *  
  * @param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE              Codigo de Empresa a procesar
  * @param Pv_Prefijo              IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE                  Indicador del proceso ejecutado
  * @param Pv_CodigoTipoDocumento  IN ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE     Tipo de documento del proceso
  * @param Pv_TipoProceso          IN VARCHAR2                                                      Indicador del proceso ejecutado  
  * @param Pn_IdDocumento          IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Id_Documento a verificar
  * @param Pv_FechaProceso         IN VARCHAR2                                                      Fecha a procesar con el masivo
  *
  * @author Gina Villalba <gvillalba@telconet.ec>
  * @version 1.0
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.2 23-04-2018 - Se modifica para contabilizar motivos masivos usando cursor C_TIPO_MOTIVO_MASIVO que recupera los distintos tipos de 
                              de motivos masivos existentes.
                              Se cambia procedimiento que registra errores en tabla DB_FINANCIERO.INFO_ERROR para registrar en DB_GENERAL:INFO_ERROR
                              porque es la tabla de uso generar de errores.
  */
  PROCEDURE P_CONTABILIZAR(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pv_IdDocumento          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_FechaProceso         IN  VARCHAR2
  );
  --
END FNKG_CONTABILIZAR_NDI;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_CONTABILIZAR_NDI
AS
  --
    Gv_ValidaProcesoContable CONSTANT VARCHAR2(32) := 'VALIDACIONES_PROCESOS_CONTABLES';

    Gv_EstadoActivo          CONSTANT VARCHAR2(6)  := 'Activo';
    Gv_EstadoCerrado         CONSTANT VARCHAR2(7)  := 'Cerrado';
    Gv_ContabilizaNdi        CONSTANT VARCHAR2(21) := 'FNKG_CONTABILIZAR_NDI';
    Gv_MotivoContabiliza     CONSTANT VARCHAR2(22) := 'MOTIVOS_CONTABILIZADOS';
    Gv_Masivo                CONSTANT VARCHAR2(22) := 'MASIVO';
  --
  
/*
 * Documentaci n para FUNCION 'F_OBTENER_VALOR_PARAMETRO'.
 * FUNCION QUE OBTIENE PARAMETROS DE ECUANET PARA MIGRACION A COMPA IA MEGADATOS
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

  PROCEDURE P_LISTADO_NDI(
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_FechaProceso         IN  VARCHAR2,
      Pv_FlatPlantilla        IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Cr_Listado              OUT SYS_REFCURSOR
  )
  AS
    Lv_InfoError      VARCHAR2(4000);
    --
  BEGIN
      --
      -- se apertura cursor con sentencia fija
      OPEN Cr_Listado FOR 
        SELECT IOG.ID_OFICINA,
          IDFC.PUNTO_ID,
          IDFC.ID_DOCUMENTO,
          IDFC.FE_EMISION,
          AFP.CODIGO_FORMA_PAGO,
          IPD.DEPOSITADO,
          IPD.DEPOSITO_PAGO_ID,
          SUM(IDFD.PRECIO_VENTA_FACPRO_DETALLE),
          IPD.CUENTA_CONTABLE_ID,
          IPD.BANCO_TIPO_CUENTA_ID
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
        JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IPD.ID_PAGO_DET=IDFD.PAGO_DET_ID
        JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO=IPD.FORMA_PAGO_ID
        JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
        JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
        JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
        LEFT JOIN DB_GENERAL.ADMI_MOTIVO AM ON AM.ID_MOTIVO=IDFD.MOTIVO_ID
        WHERE ATDF.CODIGO_TIPO_DOCUMENTO= Pv_CodigoTipoDocumento
        AND IEG.COD_EMPRESA = Pv_CodEmpresa
       AND IDFC.ESTADO_IMPRESION_FACT IN (Gv_EstadoActivo, Gv_EstadoCerrado)
        AND AM.NOMBRE_MOTIVO IN ( SELECT APD.VALOR1
                                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                       JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ON APD.PARAMETRO_ID = APC.ID_PARAMETRO
                                  WHERE APC.NOMBRE_PARAMETRO = Gv_ValidaProcesoContable
                                  AND APC.ESTADO = Gv_EstadoActivo
                                  AND APD.ESTADO = Gv_EstadoActivo
                                  AND APD.DESCRIPCION = Gv_ContabilizaNdi
                                  AND APD.VALOR2 = Gv_MotivoContabiliza
                                  AND APD.VALOR3 = Gv_Masivo
                                  AND APD.VALOR4 = Pv_FlatPlantilla
                                  AND APD.EMPRESA_COD = Pv_CodEmpresa
                                  )
        AND IDFC.FE_EMISION >= TO_DATE(Pv_FechaProceso||' 00:00:00' ,'dd/mm/yyyy hh24:mi:ss')
        AND IDFC.FE_EMISION <= TO_DATE(Pv_FechaProceso||' 23:59:59' ,'dd/mm/yyyy hh24:mi:ss')
        AND NOT EXISTS (SELECT NULL
                        FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB APCC,
                             NAF47_TNET.MIGRA_ARCGAE AE,
                             NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                        WHERE MDA.TIPO_DOC_MIGRACION = APCC.COD_DIARIO
                        AND MDA.DOCUMENTO_ORIGEN_ID = IDFC.ID_DOCUMENTO
                        AND APCC.TIPO_DOCUMENTO_ID = IDFC.TIPO_DOCUMENTO_ID
                        AND MDA.MIGRACION_ID = AE.ID_MIGRACION
                        AND MDA.NO_CIA = AE.NO_CIA
                        UNION ALL
                        SELECT NULL
                        FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB APCC,
                             NAF47_TNET.MIGRA_ARCKMM MM,
                             NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA
                        WHERE MDA.TIPO_DOC_MIGRACION = APCC.COD_DIARIO
                        AND MDA.DOCUMENTO_ORIGEN_ID = IDFC.ID_DOCUMENTO
                        AND APCC.TIPO_DOCUMENTO_ID = IDFC.TIPO_DOCUMENTO_ID
                        AND MDA.MIGRACION_ID = MM.ID_MIGRACION
                        AND MDA.NO_CIA = MM.NO_CIA
                        )
        GROUP BY IOG.ID_OFICINA,
          IDFC.ID_DOCUMENTO,
          IDFC.FE_EMISION,
          IDFC.PUNTO_ID,
          AFP.CODIGO_FORMA_PAGO,
          IPD.DEPOSITADO,
          IPD.DEPOSITO_PAGO_ID,
          IPD.CUENTA_CONTABLE_ID,
          IPD.BANCO_TIPO_CUENTA_ID;
              
  EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                          'FNKG_CONTABILIZAR_NDI.P_LISTADO_NDI', 
                          Lv_InfoError,
                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                          SYSDATE, 
                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_LISTADO_NDI;

  PROCEDURE P_LISTADO_NDI_INDIVIDUAL(
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pn_IdDocumento          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Cr_Listado              OUT SYS_REFCURSOR
  )
  AS
    Lv_InfoError  VARCHAR2(2000);
  BEGIN
    OPEN Cr_Listado FOR 
      SELECT IOG.ID_OFICINA,
      IDFC.PUNTO_ID,
      IDFC.ID_DOCUMENTO,
      IDFC.FE_EMISION,
      AFP.CODIGO_FORMA_PAGO,
      IPD.DEPOSITADO,
      IPD.DEPOSITO_PAGO_ID,
      SUM(IDFD.PRECIO_VENTA_FACPRO_DETALLE),
      NVL( IPD.CUENTA_CONTABLE_ID,
           (
             SELECT IDGH.CUENTA_CONTABLE_ID
             FROM DB_FINANCIERO.INFO_PAGO_CAB IPC
             JOIN DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL IDGH
             ON IDGH.ID_DEBITO_GENERAL_HISTORIAL = IPC.DEBITO_GENERAL_HISTORIAL_ID
             WHERE IPC.ID_PAGO = IPD.PAGO_ID
           ) )
      AS CUENTA_CONTABLE_ID,
      IPD.BANCO_TIPO_CUENTA_ID
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD ON IDFD.DOCUMENTO_ID=IDFC.ID_DOCUMENTO
      JOIN DB_FINANCIERO.INFO_PAGO_DET IPD ON IPD.ID_PAGO_DET=IDFD.PAGO_DET_ID
      JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON AFP.ID_FORMA_PAGO=IPD.FORMA_PAGO_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID
      JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO IOG ON IOG.ID_OFICINA=IDFC.OFICINA_ID
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=IOG.EMPRESA_ID
      LEFT JOIN DB_GENERAL.ADMI_MOTIVO AM ON AM.ID_MOTIVO=IDFD.MOTIVO_ID
      LEFT JOIN DB_FINANCIERO.ADMI_CUENTA_CONTABLE ACC ON ACC.ID_CUENTA_CONTABLE=IPD.CUENTA_CONTABLE_ID
      LEFT JOIN NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO MDA ON MDA.DOCUMENTO_ORIGEN_ID  = IDFC.ID_DOCUMENTO
      WHERE 
      ATDF.CODIGO_TIPO_DOCUMENTO=Pv_CodigoTipoDocumento
      AND IEG.COD_EMPRESA=Pv_CodEmpresa
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Cerrado')
      AND IDFC.ID_DOCUMENTO=Pn_IdDocumento
      AND (MDA.MIGRACION_ID         IS NULL
      OR MDA.TIPO_DOC_MIGRACION NOT IN
        (SELECT COD_DIARIO
        FROM DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB APCC
        JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_S
        ON APCC.TIPO_DOCUMENTO_ID = ATDF_S.ID_TIPO_DOCUMENTO
        WHERE APCC.EMPRESA_COD           = Pv_CodEmpresa
        AND APCC.ESTADO                  = 'Activo'
        AND ATDF_S.CODIGO_TIPO_DOCUMENTO = Pv_CodigoTipoDocumento
        GROUP BY COD_DIARIO
        ))
      GROUP BY IOG.ID_OFICINA,
      IDFC.ID_DOCUMENTO,
      IDFC.FE_EMISION,
      IDFC.PUNTO_ID,
      AFP.CODIGO_FORMA_PAGO,
      IPD.DEPOSITADO,
      IPD.DEPOSITO_PAGO_ID,
      IPD.CUENTA_CONTABLE_ID,
      IPD.PAGO_ID,
      IPD.BANCO_TIPO_CUENTA_ID;
  
  EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                          'FNKG_CONTABILIZAR_NDI.P_LISTADO_NDI_INDIVIDUAL', 
                          Lv_InfoError,
                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                          SYSDATE, 
                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
  END P_LISTADO_NDI_INDIVIDUAL;

  PROCEDURE P_LISTADO_POR_OFICINA(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Cr_Listado              IN  SYS_REFCURSOR,
    Cr_OficinasFacturado    OUT TypeOficinasNdiTab,
    Pr_Documentos           OUT DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab
  )
  AS
    Cr_Oficinas     SYS_REFCURSOR;
    Cr_Oficina      DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypeoOficinas;
    Cr_NotaDeDebito TypeNotaDeDebito;
    Ln_Total        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;

  BEGIN  
    /*--Proceso:
      --Obtengo las oficinas de la empresa, mediante la funcion
      --Las guardo en el arreglo y como indice
      --Despues de guardar las oficinas empiezo a recorrer el arreglo de oficinas_facturados, que debe estar ordenado por oficina
        --El producto_id debe ir guardado y como indice
    */
    --
    --
    DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_OFICINAS_POR_EMPRESA(Pv_CodEmpresa,Cr_Oficinas);

    LOOP
      FETCH Cr_Oficinas into Cr_Oficina;
      EXIT WHEN Cr_Oficinas%NOTFOUND;
      Cr_OficinasFacturado(Cr_Oficina.ID_OFICINA).OFICINA_ID:=Cr_Oficina.ID_OFICINA;
      Cr_OficinasFacturado(Cr_Oficina.ID_OFICINA).NOMBRE_OFICINA:=Cr_Oficina.NOMBRE_OFICINA;

      --Documentos
      Pr_Documentos(Cr_Oficina.ID_OFICINA).OFICINA_ID:=Cr_Oficina.ID_OFICINA;
    END LOOP;

    Ln_Total:=0;
    LOOP
      FETCH Cr_Listado into Cr_NotaDeDebito;
      EXIT WHEN Cr_Listado%NOTFOUND;

      --Obtengo valor para acumular
      IF(Cr_OficinasFacturado(Cr_NotaDeDebito.ID_OFICINA).TOTAL IS NULL) THEN
        Cr_OficinasFacturado(Cr_NotaDeDebito.ID_OFICINA).TOTAL:=0;
      END IF;  

      Ln_Total:=Cr_OficinasFacturado(Cr_NotaDeDebito.ID_OFICINA).TOTAL;

      IF Cr_NotaDeDebito.PRECIO_VENTA_FACPRO_DETALLE>0 THEN
        Ln_Total:=Ln_Total+Cr_NotaDeDebito.PRECIO_VENTA_FACPRO_DETALLE;
      END IF;

      --Guardo los valores nuevos acumulados
      Cr_OficinasFacturado(Cr_NotaDeDebito.ID_OFICINA).TOTAL:=Ln_Total;

      --Utilizado para el individual
      Cr_OficinasFacturado(Cr_NotaDeDebito.ID_OFICINA).CODIGO_FORMA_PAGO:=Cr_NotaDeDebito.CODIGO_FORMA_PAGO;
      Cr_OficinasFacturado(Cr_NotaDeDebito.ID_OFICINA).DEPOSITADO:=Cr_NotaDeDebito.DEPOSITADO;
      Cr_OficinasFacturado(Cr_NotaDeDebito.ID_OFICINA).CUENTA_CONTABLE_ID:=Cr_NotaDeDebito.CUENTA_CONTABLE_ID;
      Cr_OficinasFacturado(Cr_NotaDeDebito.ID_OFICINA).BANCO_TIPO_CUENTA_ID:=Cr_NotaDeDebito.BANCO_TIPO_CUENTA_ID;

      --Guardo los documentos por oficina unicamente
      Pr_Documentos(Cr_NotaDeDebito.ID_OFICINA).DOCUMENTOS(Cr_NotaDeDebito.ID_DOCUMENTO).ID_DOCUMENTO:=Cr_NotaDeDebito.ID_DOCUMENTO;
      Pr_Documentos(Cr_NotaDeDebito.ID_OFICINA).DOCUMENTOS(Cr_NotaDeDebito.ID_DOCUMENTO).PUNTO_ID:=Cr_NotaDeDebito.PUNTO_ID;
      --
      
    END LOOP;
  END P_LISTADO_POR_OFICINA;

  FUNCTION F_VALOR_CARACTERISTICA(
    Pn_IdDocumento      IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_DescripcionCarac IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
  RETURN NUMBER
  AS
    CURSOR C_ValorCaracteristica 
      (Cn_IdDocumento      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
       Cv_DescripcionCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE
    ) IS 
      SELECT 
      TO_NUMBER(ADC.VALOR, '9999.99') AS VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA ADC
      JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA=ADC.CARACTERISTICA_ID
      WHERE AC.DESCRIPCION_CARACTERISTICA=TRIM(Cv_DescripcionCarac)
      AND ADC.DOCUMENTO_ID=Cn_IdDocumento;  
    --
    Ln_Multa NUMBER:=0;

    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError                VARCHAR2(2000);
  BEGIN 
    IF C_ValorCaracteristica%ISOPEN THEN
      CLOSE C_ValorCaracteristica;
    END IF;
    --
    OPEN C_ValorCaracteristica(Pn_IdDocumento,Pv_DescripcionCarac);
    --
    FETCH C_ValorCaracteristica INTO Ln_Multa;
    --
    CLOSE C_ValorCaracteristica;
    --
    IF Ln_Multa IS NULL THEN
      Ln_Multa  := 0;
    END IF;
    --
    RETURN Ln_Multa;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                        'FNKG_CONTABILIZAR_NDI.F_VALOR_CARACTERISTICA', 
                        Lv_InfoError,
                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                        SYSDATE, 
                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
  END F_VALOR_CARACTERISTICA;

  FUNCTION F_VERIFICAR_MOTIVO(
    Pv_ListadoMotivos   IN TypeMotivos,
    Pv_MotivoDocumento  IN DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE)
  RETURN VARCHAR2
  AS
    idx_Motivos       NUMBER;
    Lv_StringMotivo   VARCHAR2(1000);
    Lv_BanderaMotivo  VARCHAR2(1):='N';

    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError      VARCHAR2(2000);
  BEGIN  
    --Verificacion de motivos del masivo
    FOR idx_Motivos IN Pv_ListadoMotivos.FIRST .. Pv_ListadoMotivos.LAST LOOP
        Lv_StringMotivo := Pv_ListadoMotivos(idx_Motivos);
        --Si encuentra el motivo debo retornar del arreglo
        IF(Lv_StringMotivo=Pv_MotivoDocumento)THEN
          Lv_BanderaMotivo:='S';
        END IF;
        EXIT WHEN Lv_BanderaMotivo = 'S';
    END LOOP;
    RETURN Lv_BanderaMotivo;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                        'FNKG_CONTABILIZAR_NDI.F_VERIFICAR_MOTIVO', 
                        Lv_InfoError,
                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                        SYSDATE, 
                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
  END F_VERIFICAR_MOTIVO;

  FUNCTION F_OBTENER_MOTIVO(
    Pn_IdDocumento      IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN VARCHAR2
  AS
    CURSOR C_NombreMotivo
      (Cn_IdDocumento      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
    ) IS 
      select 
      am.NOMBRE_MOTIVO
      from DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB idfc
      left join DB_FINANCIERO.INFO_OFICINA_GRUPO iog on iog.ID_OFICINA=idfc.OFICINA_ID
      left join DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET idfd on idfd.DOCUMENTO_ID=idfc.ID_DOCUMENTO
      left join DB_FINANCIERO.admi_motivo am on am.id_motivo=idfd.MOTIVO_ID
      left join DB_FINANCIERO.admi_tipo_documento_financiero atdf on atdf.ID_TIPO_DOCUMENTO=idfc.tipo_documento_id
      where atdf.CODIGO_TIPO_DOCUMENTO='NDI'
      and idfc.USR_CREACION<>'telcos_migracion'
      and idfc.id_documento=Cn_IdDocumento;  
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
      Lv_InfoError:=SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                        'FNKG_CONTABILIZAR_NDI.F_OBTENER_MOTIVO', 
                        Lv_InfoError,
                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                        SYSDATE, 
                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
  END F_OBTENER_MOTIVO;

  FUNCTION F_GENERAR_NOMBRE_PLANTILLA(
    Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pn_FlatDepositado       IN  DB_FINANCIERO.INFO_PAGO_DET.DEPOSITADO%TYPE,
    Pn_FlatPlantilla        IN  VARCHAR2,
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  )RETURN VARCHAR2
  AS
    --
    Lv_NombrePlantilla  VARCHAR2(200);
    Lv_InfoError        VARCHAR2(3000);
    --
    --
    --CURSOR QUE RETORNA EL VALOR1 DEPENDIENDO DE LOS PARAMETROS ENVIADOS POR EL USUARIO
    --COSTO QUERY: 10
    CURSOR C_GetNombrePlantilla(Cv_EstadoParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                                Cv_EstadoParametroDet DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                Cv_NombreParameteroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                Cv_Descripcion DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                                Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
                                Cv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                Cv_Valor3 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
                                Cv_Valor4 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE,
                                Cv_Valor5 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
                                Cv_EmpresaCod DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      --
      SELECT APD.ID_PARAMETRO_DET,
        APD.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
      AND APC.ESTADO           = NVL(Cv_EstadoParametroCab, APC.ESTADO )
      AND APD.ESTADO           = NVL(Cv_EstadoParametroDet, APD.ESTADO )
      AND APC.NOMBRE_PARAMETRO = NVL(Cv_NombreParameteroCab, APC.NOMBRE_PARAMETRO )
      AND APD.DESCRIPCION      = NVL(Cv_Descripcion, APD.DESCRIPCION )
      AND APD.VALOR1           = NVL(Cv_Valor1, APD.VALOR1 )
      AND APD.VALOR2           = NVL(Cv_Valor2, APD.VALOR2 )
      AND APD.VALOR3           = NVL(Cv_Valor3, APD.VALOR3)
      AND APD.VALOR4           = NVL(Cv_Valor4, APD.VALOR4)
      AND APD.VALOR5           = NVL(Cv_Valor5, APD.VALOR5)
      AND APD.EMPRESA_COD      = NVL(Cv_EmpresaCod, APD.EMPRESA_COD);
      --
    --
    Lr_GetNombrePlantilla C_GetNombrePlantilla%ROWTYPE;
    Ln_FlatDepositado     VARCHAR2(5);
    --
  BEGIN
    --
    IF Pn_FlatDepositado IS NULL THEN
      --
      Ln_FlatDepositado := 'NULL';
      --
    ELSE
      --
      Ln_FlatDepositado := Pn_FlatDepositado;
      --
    END IF;
    --
    --
    IF C_GetNombrePlantilla%ISOPEN THEN
      CLOSE C_GetNombrePlantilla;
    END IF;
    --
    OPEN C_GetNombrePlantilla('Activo',
                              'Activo',
                              'VALIDACIONES_PROCESOS_CONTABLES',
                              'FNKG_CONTABILIZAR_NDI',
                              NULL,
                              'F_GENERAR_NOMBRE_PLANTILLA',
                              Pv_TipoProceso,
                              Pn_FlatPlantilla,
                              Ln_FlatDepositado,
                              Pv_CodEmpresa);
    --
    FETCH C_GetNombrePlantilla INTO Lr_GetNombrePlantilla;
    --
    CLOSE C_GetNombrePlantilla;
    --
    --
    IF Lr_GetNombrePlantilla.ID_PARAMETRO_DET IS NOT NULL THEN
      --
      Lv_NombrePlantilla := Lr_GetNombrePlantilla.VALOR1;
      --
    END IF;
    --
    --
    RETURN Lv_NombrePlantilla;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_InfoError:=SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                      'FNKG_CONTABILIZAR_NDI.F_GENERAR_NOMBRE_PLANTILLA', 
                      Lv_InfoError,
                      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                      SYSDATE, 
                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END F_GENERAR_NOMBRE_PLANTILLA;


  PROCEDURE P_PROCESAR(
      Cr_Listado              IN  SYS_REFCURSOR,
      Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pv_TipoProceso          IN  VARCHAR2,
      Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
      Pv_IdDocumento          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Pt_Fe_Actual            IN  VARCHAR2,
      Pn_FlatPlantilla        IN  VARCHAR2
      )
  AS

    --Asiento contable
    Lv_CodDiario              VARCHAR2(100);
    Lv_NoAsiento              VARCHAR2(1000);
    Lv_UsrCreacion            VARCHAR2(1000);
    Lv_Descripcion            VARCHAR2(3000);
    Pv_CampoReferencial       VARCHAR2(100);
    Pv_ValorCampoReferencial  VARCHAR2(100);
    Cr_CtaContable            VARCHAR2(100);
    Cr_NoCta                  VARCHAR2(100);

     --Tipo de record
    Cr_OficinasFacturado      TypeOficinasNdiTab;
    Pr_Arreglo                DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypeArreglo;
    Pn_ValorTotal             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Pn_Multa                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Pr_Documentos             DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypeDocumentosFacturadosTab;
    LrInfoDocumento           DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypeInfoDocumento;
    Lv_NumeroFacturaSri       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;

    --Tipo para la plantilla
    Lc_Plantilla              DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypePlantillaCab;
    Lc_PlantillaDet           DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypePlantillaDet;

    --Tablas ed contabilidad
    Lr_MigraArcgae            MIGRA_ARCGAE%ROWTYPE;
    Lr_MigraArcgal            MIGRA_ARCGAL%ROWTYPE;
    --
    Lr_MigraArckmm            MIGRA_ARCKMM%ROWTYPE;
    Lr_MigraArckml            MIGRA_ARCKML%ROWTYPE;
    --
    Pn_Monto                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Lv_PlantillaDescripcion   DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.DESCRIPCION%TYPE;

    --Recorridos de arreglos
    Pn_OficinaIdx             DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
    Ln_DocumentoIdx           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Pn_LineaIdx               NUMBER;

    --Para el manejo de la fecha
    Ld_FeCreacion             DATE;

    --Para manejo de errores
    Pv_MsnError               VARCHAR2(3000);

    --Proceso masivo
    Lr_InfoProcesoMasivoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;

    Lv_FormatoGlosa           DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_GLOSA%TYPE;
    Lv_FormatoNoAsiento       DB_FINANCIERO.ADMI_PLANTILLA_CONTABLE_CAB.FORMATO_NO_DOCU_ASIENTO%TYPE;

    --Fechas
    Lv_Anio                   VARCHAR2(1000);
    Lv_Mes                    VARCHAR2(1000);

    --Plantilla
    Cr_PlantillaCab           SYS_REFCURSOR;
    Cr_PlantillaDet           SYS_REFCURSOR;
    Cr_InfoDocumento          SYS_REFCURSOR;
    --
    Ln_FlatPlantilla          VARCHAR2(1000);
    Ln_FlatDepositado         VARCHAR2(1000);
    --
    LrCuentaContable          DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.TypeCuentaContable;
    LvNoCtaDestino            VARCHAR2(100);
    LvNoCtaCbleDestino        VARCHAR2(100);
    --    
    Le_Exception EXCEPTION;
    Lr_MigraDocumentoAsociado NAF47_TNET.MIGRA_DOCUMENTO_ASOCIADO%ROWTYPE;
    --
    --
    Ln_SecuenciaMapeo NUMBER;
    Ln_IdMigracion18 naf47_tnet.migra_arcgae.id_migracion%type;
    Ln_IdMigracion33 naf47_tnet.migra_arcgae.id_migracion%type;
    
    Lv_EmpresaOrigen db_general.admi_parametro_det.valor2%type;
    Lv_EmpresaDestino db_general.admi_parametro_det.valor2%type;
    Lv_BanderaReplicar db_general.admi_parametro_det.valor2%type;
  BEGIN
      Lv_EmpresaOrigen := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_ORIGEN');
      Lv_EmpresaDestino := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'EMPRESA_DESTINO');
      Lv_BanderaReplicar := F_OBTENER_VALOR_PARAMETRO(Pv_NombreParametro => 'PARAMETROS_ECUANET_MIGRACION', Pv_Parametro => 'APLICA_REPLICA_MIGRACION');
      --
      P_LISTADO_POR_OFICINA(Pv_CodEmpresa,Cr_Listado,Cr_OficinasFacturado,Pr_Documentos);
      --Ya tengo las oficinas que se procesaron o se procesaran debo recorrer 
      --y enviar los parametros que quien se va a totalizar
      Pn_OficinaIdx := Cr_OficinasFacturado.FIRST;
      LOOP
        --
        EXIT WHEN Pn_OficinaIdx IS NULL;
        --Antes de eso debo generar el nombre de la plantilla segun los parametros enviados
        Ln_FlatPlantilla  :=  Cr_OficinasFacturado(Pn_OficinaIdx).CODIGO_FORMA_PAGO;
        Ln_FlatDepositado :=  Cr_OficinasFacturado(Pn_OficinaIdx).DEPOSITADO;
        --
        --Segun el proceso se verifica si posee la caracteristica del cheque protestado
        IF (Pv_TipoProceso='INDIVIDUAL') THEN
          --Unicamente el proceso es individual hago la verificacion de la multa
          Pn_Multa:=F_VALOR_CARACTERISTICA(Pv_IdDocumento,'CHEQUE_PROTESTADO');
        ELSE
          --
          Pn_Multa          := 0;
          Ln_FlatDepositado := NULL;
          Ln_FlatPlantilla  := TRIM(Pn_FlatPlantilla);
          --
        END IF;
        --
        --
        IF Ln_FlatDepositado IS NULL OR Ln_FlatDepositado = 'N' THEN
          --
          Ln_FlatDepositado := 'NULL';
          --
        END IF;
        --
        --
        Lv_PlantillaDescripcion := F_GENERAR_NOMBRE_PLANTILLA( TRIM(Pv_CodigoTipoDocumento),
                                                               TRIM(Pv_TipoProceso),
                                                               TRIM(Ln_FlatDepositado),
                                                               TRIM(Ln_FlatPlantilla),
                                                               Pv_CodEmpresa ); 
        --
        DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_CAB(Pv_CodigoTipoDocumento,Lv_PlantillaDescripcion,Pv_CodEmpresa,Cr_PlantillaCab);
        FETCH Cr_PlantillaCab INTO Lc_Plantilla;

        --Obtengo la data de la plantilla
        Lv_CodDiario:= Lc_Plantilla.COD_DIARIO;
        --El valor Total ya posee incluido el valor de la Multa en las NDI.
        Pn_ValorTotal:=Cr_OficinasFacturado(Pn_OficinaIdx).TOTAL;
        --Cuando el totalizado no existe, no debe crear cabecera
        IF (Pn_ValorTotal>0)THEN
          --
          --
          Lv_NumeroFacturaSri:= '';
          --Parametros necesario de manera externa
          IF Pv_TipoProceso='INDIVIDUAL' THEN
            --Data por individual
            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.O_OBTENER_DATA_DOCUMENTO(Pv_IdDocumento,Cr_InfoDocumento);
            FETCH Cr_InfoDocumento INTO LrInfoDocumento;

            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_SPLIT(TO_CHAR(LrInfoDocumento.FE_EMISION),'-',Pr_Arreglo);
            Lv_Anio             :=  Pr_Arreglo(0);
            Lv_Mes              :=  Pr_Arreglo(1);
            Ld_FeCreacion       :=  TO_DATE(LrInfoDocumento.FE_EMISION,'YYYY-MM-DD');
            Lv_UsrCreacion      :=  LrInfoDocumento.USR_CREACION;
            Lv_NoAsiento        :=  Pv_IdDocumento;
            Lv_NumeroFacturaSri :=  LrInfoDocumento.NUMERO_FACTURA_SRI;
            --
          ELSIF Pv_TipoProceso='MASIVO' THEN

            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_SPLIT(Pt_Fe_Actual,'-',Pr_Arreglo);
            Lv_Anio             :=  Pr_Arreglo(0);
            Lv_Mes              :=  Pr_Arreglo(1);
            Ld_FeCreacion       :=  TO_DATE(Pt_Fe_Actual,'YYYY-MM-DD');
            Lv_UsrCreacion      :=  'telcos';
            Lv_NumeroFacturaSri :=  NULL;
          END IF;
          --Leyendo la plantilla, segun el proceso
          IF Lc_Plantilla.TABLA_CABECERA='MIGRA_ARCGAE' THEN
            --
            Lv_FormatoGlosa:=Lc_Plantilla.FORMATO_GLOSA;
            Lv_FormatoNoAsiento:=Lc_Plantilla.FORMATO_NO_DOCU_ASIENTO;
            --
            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_DESCRIPCION(
              Lv_FormatoGlosa,
              TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
              Cr_OficinasFacturado(Pn_OficinaIdx).NOMBRE_OFICINA,
              LrInfoDocumento.LOGIN,
              Lv_NumeroFacturaSri,
              Lv_Descripcion
            );

            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_NO_ASIENTO(
              Lv_FormatoNoAsiento,
              TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
              Pv_IdDocumento,
              Pn_OficinaIdx,
              Lv_NoAsiento
            );
            --
            --
            Lr_MigraArcgae.ID_FORMA_PAGO          := NULL;
            Lr_MigraArcgae.ID_OFICINA_FACTURACION := Pn_OficinaIdx;
            --
            --*jilces::cambio por nueva compa ia ecuanet, se usa la misma secuencia de megadatos
              --*debido a que en futuro se migrara los registros de ecuanet a megadatos
            IF Pv_CodEmpresa != Lv_EmpresaOrigen THEN
               Lr_MigraArcgae.Id_Migracion     := NAF47_TNET.TRANSA_ID.MIGRA_CG (Pv_CodEmpresa);
            ELSIF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
               Lr_MigraArcgae.Id_Migracion     := NAF47_TNET.TRANSA_ID.MIGRA_CG (Lv_EmpresaOrigen);
               Ln_IdMigracion33 := Lr_MigraArcgae.Id_Migracion;
               Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CG (Lv_EmpresaDestino);
            END IF;
            Lr_MigraArcgae.NO_CIA           :=  Pv_CodEmpresa;
            Lr_MigraArcgae.ANO              :=  Lv_Anio;
            Lr_MigraArcgae.MES              :=  Lv_Mes;
            Lr_MigraArcgae.FECHA            :=  Ld_FeCreacion;
            Lr_MigraArcgae.NO_ASIENTO       :=  Lv_NoAsiento;
            Lr_MigraArcgae.DESCRI1          :=  Lv_Descripcion;
            Lr_MigraArcgae.ESTADO           := 'P';
            Lr_MigraArcgae.AUTORIZADO       := 'N';
            Lr_MigraArcgae.ORIGEN           :=  Pv_Prefijo;
            Lr_MigraArcgae.T_DEBITOS        :=  Pn_ValorTotal;
            Lr_MigraArcgae.T_CREDITOS       :=  Pn_ValorTotal;
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
            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae,Pv_MsnError);
            --
            IF Pv_MsnError IS NOT NULL THEN
              --
              Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAE. - ID_DOCUMENTO( ' || 
                             Pv_IdDocumento || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
              --
              RAISE Le_Exception;
              --
            END IF;
            
            IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                  declare
                   Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
                  begin
                    select id_oficina INTO Ln_IdOficina
                      from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                     where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                 from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                where a.id_oficina = Pn_OficinaIdx);
                 
                   Lr_MigraArcgae.NO_CIA            := Lv_EmpresaDestino;
                   Lr_MigraArcgae.ID_OFICINA_FACTURACION := Ln_IdOficina;
                   Lr_MigraArcgae.Id_Migracion     := Ln_IdMigracion18;
                   
                   NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAE(Lr_MigraArcgae,Pv_MsnError);
                   
                   Lr_MigraArcgae.Id_Migracion     := Ln_IdMigracion33;
                   Lr_MigraArcgae.NO_CIA            := Pv_CodEmpresa;
                   Lr_MigraArcgae.ID_OFICINA_FACTURACION := Pn_OficinaIdx;
                   
                   IF Pv_MsnError IS NOT NULL THEN
              --
              Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAE. - ID_DOCUMENTO( ' || 
                             Pv_IdDocumento || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
              --
              RAISE Le_Exception;
              --
            END IF;
                   
                  end;
                END IF;
            
            --
            --
            --Leyendo detalle de plantilla, segun proceso
            --Cuando tengo la plantillaDet, busco sus cuentas contable enlazadas
            Pn_LineaIdx :=  0;
            --
            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_DET(Lc_Plantilla.ID_PLANTILLA_CONTABLE_CAB,Cr_PlantillaDet);
            

            LOOP
              FETCH Cr_PlantillaDet INTO Lc_PlantillaDet;
              --
              EXIT WHEN Cr_PlantillaDet%NOTFOUND;
              --
              Lv_FormatoGlosa:=Lc_PlantillaDet.FORMATO_GLOSA;
              --
              DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_DESCRIPCION(
                Lv_FormatoGlosa,
                TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
                Cr_OficinasFacturado(Pn_OficinaIdx).NOMBRE_OFICINA,
                LrInfoDocumento.LOGIN,
                Lv_NumeroFacturaSri,
                Lv_Descripcion
              );
              --
              --Valores fijos
              Lr_MigraArcgal.MIGRACION_ID           :=  Lr_MigraArcgae.ID_MIGRACION;
              Lr_MigraArcgal.NO_CIA                 :=  Pv_CodEmpresa;
              Lr_MigraArcgal.ANO                    :=  Lv_Anio;
              Lr_MigraArcgal.MES                    :=  Lv_Mes;
              Lr_MigraArcgal.NO_ASIENTO             :=  SUBSTR(Lv_NoAsiento,1,12);
              Lr_MigraArcgal.NO_LINEA               :=  Pn_LineaIdx;
              Lr_MigraArcgal.TIPO_CAMBIO            :=  '1';
              Lr_MigraArcgal.COD_DIARIO             :=  Lv_CodDiario;
              Lr_MigraArcgal.MONEDA                 :=  'P';
              Lr_MigraArcgal.FECHA                  :=  Ld_FeCreacion;
              Lr_MigraArcgal.CENTRO_COSTO           :=  '000000000';
              Lr_MigraArcgal.TIPO                   :=  Lc_PlantillaDet.POSICION;
              Lr_MigraArcgal.CC_1                   :=  '000';  
              Lr_MigraArcgal.CC_2                   :=  '000';  
              Lr_MigraArcgal.CC_3                   :=  '000';
              Lr_MigraArcgal.LINEA_AJUSTE_PRECISION :=  'N';
              Lr_MigraArcgal.TRANSFERIDO            :=  'N';
              Lr_MigraArcgal.DESCRI                 :=  Lv_Descripcion;

              --Campo referenciales
              --
              IF(Lc_PlantillaDet.TIPO_CUENTA_CONTABLE='CLIENTES') THEN
                Pv_CampoReferencial:='ID_OFICINA';
                Pv_ValorCampoReferencial:=Pn_OficinaIdx;
                Pn_Monto  :=Pn_ValorTotal;
              END IF;

              --Proceso segun el tipo de detalle            
              IF(Lc_PlantillaDet.TIPO_DETALLE='FIJO')THEN
                DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_CUENTA_CONTABLE(Pv_CodEmpresa,
                                                                    Lc_PlantillaDet.TIPO_CUENTA_CONTABLE,
                                                                    Pv_CampoReferencial,
                                                                    Pv_ValorCampoReferencial,
                                                                    Pn_OficinaIdx,
                                                                    Cr_CtaContable,
                                                                    Cr_NoCta);
                --
                Pn_LineaIdx :=  Pn_LineaIdx+1;
                --Segun el tipo modificamos lo siguiente
                Lr_MigraArcgal.NO_LINEA   :=  Pn_LineaIdx;
                Lr_MigraArcgal.CUENTA     :=  Cr_CtaContable;
                --Insertando
                ---Guardo los montos correspondientes
                DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_POSICION_VALOR(Lc_PlantillaDet.POSICION,Pn_Monto);
                Lr_MigraArcgal.MONTO      :=  Pn_Monto;
                Lr_MigraArcgal.MONTO_DOL  :=  Pn_Monto;
                --
                --
                Pv_MsnError := NULL;
                --
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal, Pv_MsnError);
                --
                IF Pv_MsnError IS NOT NULL THEN
                  --
                  Pv_MsnError := 'Error al insertar el detalle del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAL. - ID_DOCUMENTO( ' || 
                                 Pv_IdDocumento || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                  --
                  RAISE Le_Exception;
                  --
                END IF;
                --
                IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN 
                 
                   Lr_MigraArcgal .NO_CIA            := Lv_EmpresaDestino;
                   Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion18;
                   
                   NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCGAL(Lr_MigraArcgal, Pv_MsnError);
                   
                   Lr_MigraArcgal.NO_CIA            := Pv_CodEmpresa;
                   Lr_MigraArcgal.MIGRACION_ID           :=  Ln_IdMigracion33;
                   
                   
                   IF Pv_MsnError IS NOT NULL THEN 
                      Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCGAE. - ID_DOCUMENTO( ' ||  Pv_IdDocumento || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                      RAISE Le_Exception; 
                   END IF; 
               END IF;
                --
              END IF;
            END LOOP;

            CLOSE Cr_PlantillaDet;
            /*
            --Cuando el proceso es "OK" debemos:
              --Crear el proceso masivo si el proceso es MASIVO --> unicamente
              --Marca en la info_doc_fin_cab | CONTABILIZADO ='S' 
              --Crear historial de "Proceso de contabilizacion ok"
            */
            
            --
            IF Pv_MsnError IS NULL THEN
              --Se guarda la transaccion realizada
              --Proceso de actualizar documentos contabilizados
              IF Pv_TipoProceso='INDIVIDUAL' THEN
                DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_MARCAR_CONTABILIZADO(Pv_IdDocumento,Pv_TipoProceso);
                --
                --
                Lr_MigraDocumentoAsociado                     := NULL;
                Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := Pv_IdDocumento;
                Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := Lv_CodDiario;
                Lr_MigraDocumentoAsociado.NO_CIA              := Pv_CodEmpresa;
                Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := NULL;
                Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := '9';
                Lr_MigraDocumentoAsociado.ESTADO              := 'M';
                Lr_MigraDocumentoAsociado.USR_CREACION        := Lv_UsrCreacion;
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
                    Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento
                                   || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                    --
                    RAISE Le_Exception;
                    --
                  END IF;
                  --
                  if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen then 
                   
                     Lr_MigraDocumentoAsociado.NO_CIA            := Lv_EmpresaDestino; 
                     Lr_MigraDocumentoAsociado.MIGRACION_ID           :=  Ln_IdMigracion18;
                     
                     NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MsnError);
                     
                     Lr_MigraDocumentoAsociado.MIGRACION_ID           :=  Ln_IdMigracion33;
                     Lr_MigraDocumentoAsociado.NO_CIA            := Pv_CodEmpresa; 
                     
                     IF Pv_MsnError IS NOT NULL THEN
                    --
                    Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento
                                   || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                    --
                    RAISE Le_Exception;
                    --
                  END IF; 
                  end if;
                  --
                ELSE
                  --
                  Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento ||
                                 ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                  --
                  RAISE Le_Exception;
                  --
                END IF;
                --
                --
              ELSIF Pv_TipoProceso='MASIVO' THEN
                --Lectura del cursor de los facturados
                --Generacion del proceso masivo, se neceita el punto_id | documento_id
                --Registrando el masivo cab

                Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;
                Lr_InfoProcesoMasivoCab.TIPO_PROCESO          := 'ContDoc.:'||Pv_CodigoTipoDocumento;
                Lr_InfoProcesoMasivoCab.IDS_OFICINAS          := Pn_OficinaIdx;
                Lr_InfoProcesoMasivoCab.EMPRESA_ID            := Pv_CodEmpresa;
                Lr_InfoProcesoMasivoCab.ESTADO                := 'Finalizado';
                Lr_InfoProcesoMasivoCab.FE_CREACION           := SYSDATE;
                Lr_InfoProcesoMasivoCab.USR_CREACION          := 'telcos';  
                Lr_InfoProcesoMasivoCab.IP_CREACION           := SYS_CONTEXT('USERENV','IP_ADDRESS',15);
                DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR .INSERT_INFO_PROCESO_MASIVO_CAB(Lr_InfoProcesoMasivoCab,Pv_MsnError);
                
                IF Pv_MsnError != 'OK' THEN
                  RAISE Le_Exception;
                ELSE
                  Pv_MsnError := NULL;
                END IF;
                
                
                
                IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                  Ln_SecuenciaMapeo := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;
                  declare
                   Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
                   Ln_SecuenciaTmp NUMBER := Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB;
                  begin
                    select id_oficina INTO Ln_IdOficina
                      from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                     where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                 from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                where a.id_oficina = Pn_OficinaIdx);
                 
                   Lr_InfoProcesoMasivoCab.EMPRESA_ID            := Lv_EmpresaDestino;
                   Lr_InfoProcesoMasivoCab.IDS_OFICINAS          := Ln_IdOficina;
                   Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB := Ln_SecuenciaMapeo;
                   
                   DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR .INSERT_INFO_PROCESO_MASIVO_CAB(Lr_InfoProcesoMasivoCab,Pv_MsnError);
                   
                   Lr_InfoProcesoMasivoCab.EMPRESA_ID            := Pv_CodEmpresa;
                   Lr_InfoProcesoMasivoCab.IDS_OFICINAS          := Pn_OficinaIdx;
                   Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB := Ln_SecuenciaTmp;
                   
                   IF Pv_MsnError != 'OK' THEN
                      RAISE Le_Exception;
                   ELSE
                      Pv_MsnError := NULL;
                   END IF;
                  end;
                END IF; 

                Ln_DocumentoIdx := Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS.FIRST;
                LOOP
                  BEGIN
                    EXIT WHEN Ln_DocumentoIdx IS NULL;
                    --
                    DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_MARCAR_CONTABILIZADO(Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS(Ln_DocumentoIdx).ID_DOCUMENTO,Pv_TipoProceso);                    
                    --Registrando el masivo det
                    Lr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
                    Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID := Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB;
                    Lr_InfoProcesoMasivoDet.PUNTO_ID              := Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS(Ln_DocumentoIdx).PUNTO_ID;
                    Lr_InfoProcesoMasivoDet.ESTADO                := 'Finalizado';
                    Lr_InfoProcesoMasivoDet.FE_CREACION           := SYSDATE;
                    Lr_InfoProcesoMasivoDet.USR_CREACION          := 'telcos';
                    Lr_InfoProcesoMasivoDet.IP_CREACION           := SYS_CONTEXT('USERENV','IP_ADDRESS',15);
                    Lr_InfoProcesoMasivoDet.OBSERVACION           := 'ID_DOCUMENTO #:' || Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS(Ln_DocumentoIdx).ID_DOCUMENTO;
                    --
                    DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_INFO_PROCESO_MASIVO_DET(Lr_InfoProcesoMasivoDet,Pv_MsnError);
                    --
                    IF Pv_MsnError != 'OK' THEN
                      RAISE Le_Exception;
                    ELSE
                      Pv_MsnError := NULL;
                    END IF;
                    
                    IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                      declare
                       Ln_IdOficina DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%type;
                      begin
                        select id_oficina INTO Ln_IdOficina
                          from DB_COMERCIAL.INFO_OFICINA_GRUPO b
                         where b.NOMBRE_OFICINA = (select replace(A.NOMBRE_OFICINA, 'ECUANET', 'MEGADATOS')
                                                     from DB_COMERCIAL.INFO_OFICINA_GRUPO a
                                                    where a.id_oficina = Pn_OficinaIdx);

                       Lr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
                       Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID := Ln_SecuenciaMapeo;
                       Lr_InfoProcesoMasivoCab.EMPRESA_ID            := Lv_EmpresaDestino;
                       Lr_InfoProcesoMasivoCab.IDS_OFICINAS          := Ln_IdOficina;
                       
                       DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.INSERT_INFO_PROCESO_MASIVO_DET(Lr_InfoProcesoMasivoDet,Pv_MsnError);
                       
                       IF Pv_MsnError != 'OK' THEN
                          RAISE Le_Exception;
                       ELSE
                          Pv_MsnError := NULL;
                       END IF;
                      end;
                    END IF;
                    --
                    Lr_MigraDocumentoAsociado                     := NULL;
                    Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := Ln_DocumentoIdx;
                    Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := Lv_CodDiario;
                    Lr_MigraDocumentoAsociado.NO_CIA              := Pv_CodEmpresa;
                    Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := NULL;
                    Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := '9';
                    Lr_MigraDocumentoAsociado.ESTADO              := 'M';
                    Lr_MigraDocumentoAsociado.USR_CREACION        := Lv_UsrCreacion;
                    Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
                    if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen then
                      Lr_MigraDocumentoAsociado.MIGRACION_ID        := Ln_IdMigracion33;
                    else
                      Lr_MigraDocumentoAsociado.MIGRACION_ID        := Lr_MigraArcgae.ID_MIGRACION;
                    end if;
                    
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
                        Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' ||
                                       Ln_DocumentoIdx || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                        --
                        RAISE Le_Exception;
                        --
                      END IF;
                      
                      IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                       
                         Lr_MigraDocumentoAsociado.NO_CIA            := Lv_EmpresaDestino; 
                         Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion18;
                         
                         NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MsnError);
                         
                         Lr_MigraDocumentoAsociado.NO_CIA            := Pv_CodEmpresa; 
                         Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion33;
                         
                         IF Pv_MsnError IS NOT NULL THEN
                        --
                        Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' ||
                                       Ln_DocumentoIdx || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                        --
                        RAISE Le_Exception;
                        --
                      END IF;
                      END IF; 
                      --
                    ELSE
                      --
                      Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || 
                                     Ln_DocumentoIdx || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                      --
                      RAISE Le_Exception;
                      --
                    END IF;
                    --
                    --
                    Ln_DocumentoIdx:=Pr_Documentos(Pn_OficinaIdx).DOCUMENTOS.next(Ln_DocumentoIdx);
                  EXCEPTION
                  WHEN OTHERS THEN
                    Pv_MsnError:=SUBSTR('Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                      'FNKG_CONTABILIZAR_NDI.P_PROCESAR', 
                                      Pv_MsnError,
                                      NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                      SYSDATE, 
                                      NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                  END;    
                END LOOP;
              END IF;
            END IF;
          ELSIF Lc_Plantilla.TABLA_CABECERA='MIGRA_ARCKMM' AND Pv_TipoProceso='INDIVIDUAL' THEN
            --Proceso para obtener la no_cta, en este caso siempre sera un banco
            --NUMERO CUENTA Y CUENTA CONTABLE DESTINO

            IF Cr_OficinasFacturado(Pn_OficinaIdx).CUENTA_CONTABLE_ID IS NOT NULL THEN
              LrCuentaContable   := DB_FINANCIERO.FNKG_CONTABILIZAR_PAGO_MANUAL.GET_CUENTA_CONTABLE(Cr_OficinasFacturado(Pn_OficinaIdx).CUENTA_CONTABLE_ID);   

            ELSIF Cr_OficinasFacturado(Pn_OficinaIdx).BANCO_TIPO_CUENTA_ID IS NOT NULL THEN
              LrCuentaContable   := DB_FINANCIERO.FNKG_CONTABILIZAR_DEBITOS.F_GET_CUENTA_CONTABLE_POR_TIPO( Cr_OficinasFacturado(Pn_OficinaIdx).BANCO_TIPO_CUENTA_ID,
                                      'ID_GRUPO_DEBITO_DET', 
                                      'BANCOS DEBITOS MD', 
                                      Pv_CodEmpresa);
            END IF;
            LvNoCtaDestino     := LrCuentaContable.NO_CTA;
            LvNoCtaCbleDestino := LrCuentaContable.CUENTA;

            --Formatos de asientos y glosa
            --
            Lv_FormatoGlosa:=Lc_Plantilla.FORMATO_GLOSA;
            Lv_FormatoNoAsiento:=Lc_Plantilla.FORMATO_NO_DOCU_ASIENTO;
            --
            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_DESCRIPCION(
              Lv_FormatoGlosa,
              TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
              Cr_OficinasFacturado(Pn_OficinaIdx).NOMBRE_OFICINA,
              LrInfoDocumento.LOGIN,
              Lv_NumeroFacturaSri,
              Lv_Descripcion
            );

            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_NO_ASIENTO(
              Lv_FormatoNoAsiento,
              TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
              Pv_IdDocumento,
              Pn_OficinaIdx,
              Lv_NoAsiento
            );
            --
            --
            --Proceso para bancos
            Lr_MigraArckmm.ID_FORMA_PAGO          := NULL;
            Lr_MigraArckmm.ID_OFICINA_FACTURACION := Pn_OficinaIdx;
            --
            if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen then
              Lr_MigraArckmm.ID_MIGRACION     := NAF47_TNET.TRANSA_ID.MIGRA_CK( Lv_EmpresaOrigen );
              Ln_IdMigracion33 := Lr_MigraArckmm.Id_Migracion;
              Ln_IdMigracion18 := NAF47_TNET.TRANSA_ID.MIGRA_CK (Lv_EmpresaDestino);
            else
              Lr_MigraArckmm.ID_MIGRACION     := NAF47_TNET.TRANSA_ID.MIGRA_CK( Pv_CodEmpresa );
            end if;
            
            Lr_MigraArckmm.NO_CIA           := Pv_CodEmpresa;
            Lr_MigraArckmm.PROCEDENCIA      := 'C';
            Lr_MigraArckmm.TIPO_DOC         := 'ND';
            Lr_MigraArckmm.NO_CTA           := LvNoCtaDestino;
            Lr_MigraArckmm.NO_DOCU          := Lv_NoAsiento;
            Lr_MigraArckmm.FECHA            := Ld_FeCreacion;
            Lr_MigraArckmm.COMENTARIO       := Lv_Descripcion;
            Lr_MigraArckmm.MONTO            := Pn_ValorTotal;
            Lr_MigraArckmm.ESTADO           := 'P';
            Lr_MigraArckmm.CONCILIADO       := 'N';
            Lr_MigraArckmm.MES              := Lv_Mes;
            Lr_MigraArckmm.ANO              := Lv_Anio;
            Lr_MigraArckmm.IND_OTROMOV      := 'S';
            Lr_MigraArckmm.MONEDA_CTA       := 'P';
            Lr_MigraArckmm.TIPO_CAMBIO      := '1';
            Lr_MigraArckmm.T_CAMB_C_V       := 'C';
            Lr_MigraArckmm.IND_OTROS_MESES  := 'N';
            Lr_MigraArckmm.NO_FISICO        := '';
            Lr_MigraArckmm.ORIGEN           := Pv_Prefijo;
            Lr_MigraArckmm.USUARIO_CREACION := Lv_UsrCreacion;
            Lr_MigraArckmm.FECHA_DOC        := Ld_FeCreacion;
            Lr_MigraArckmm.IND_DIVISION     := 'N';
            Lr_MigraArckmm.FECHA_CREACION   := SYSDATE;
            Lr_MigraArckmm.COD_DIARIO       := Lv_CodDiario;
            --
            Pv_MsnError := NULL;
            --
            NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(Lr_MigraArckmm, Pv_MsnError);
            --
            IF Pv_MsnError IS NOT NULL THEN
              --
              Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCKMM. - ID_DOCUMENTO( ' || 
                             Pv_IdDocumento || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
              --
              RAISE Le_Exception;
              --
            END IF;
            
            IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN  
                 
                   Lr_MigraArckmm.NO_CIA            := Lv_EmpresaDestino; 
                   Lr_MigraArckmm.Id_Migracion     := Ln_IdMigracion18;
                   
                   NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKMM(Lr_MigraArckmm, Pv_MsnError);
                   
                   Lr_MigraArckmm.NO_CIA            := Pv_CodEmpresa; 
                   Lr_MigraArckmm.Id_Migracion     := Ln_IdMigracion33;
            --
            IF Pv_MsnError IS NOT NULL THEN
              --
              Pv_MsnError := 'Error al insertar la cabecera del asiento contable en la tabla NAF47_TNET.MIGRA_ARCKMM. - ID_DOCUMENTO( ' || 
                             Pv_IdDocumento || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
              --
              RAISE Le_Exception;
              --
            END IF;
                   Lr_MigraArckmm.Id_Migracion     := Ln_IdMigracion33;
                   
                   
                END IF;
            --
            --Proceso de detalle
            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_PLANTILLA_DET(Lc_Plantilla.ID_PLANTILLA_CONTABLE_CAB,Cr_PlantillaDet);
            LOOP
              FETCH Cr_PlantillaDet INTO Lc_PlantillaDet;
              EXIT WHEN Cr_PlantillaDet%NOTFOUND;
              --
              Lv_FormatoGlosa:=Lc_PlantillaDet.FORMATO_GLOSA;
              --
              DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_GENERAR_DESCRIPCION(
                Lv_FormatoGlosa,
                TO_CHAR(Ld_FeCreacion,'YYYY-MM-DD'),
                Cr_OficinasFacturado(Pn_OficinaIdx).NOMBRE_OFICINA,
                LrInfoDocumento.LOGIN,
                Lv_NumeroFacturaSri,
                Lv_Descripcion
              );
              --
              Lr_MigraArckml.MIGRACION_ID := Lr_MigraArckmm.ID_MIGRACION;
              Lr_MigraArckml.NO_CIA       := Pv_CodEmpresa;
              Lr_MigraArckml.PROCEDENCIA  := 'C';
              Lr_MigraArckml.TIPO_DOC     := 'ND';
              Lr_MigraArckml.NO_DOCU      := Lv_NoAsiento;
              Lr_MigraArckml.CENTRO_COSTO := '000000000';
              Lr_MigraArckml.MONTO        := Pn_ValorTotal;  
              Lr_MigraArckml.MONTO_DOl    := Pn_ValorTotal;
              Lr_MigraArckml.MONTO_DC     := Pn_ValorTotal;
              Lr_MigraArckml.TIPO_CAMBIO  := '1';
              Lr_MigraArckml.MONEDA       := 'P';
              Lr_MigraArckml.ANO          := Lv_Anio;
              Lr_MigraArckml.MES          := Lv_Mes;
              Lr_MigraArckml.GLOSA        := Lv_Descripcion;
              Lr_MigraArckml.TIPO_MOV     := Lc_PlantillaDet.POSICION;
              Lr_MigraArckml.COD_DIARIO   := Lv_CodDiario;

              --Campo referenciales
              IF(Lc_PlantillaDet.TIPO_CUENTA_CONTABLE='CLIENTES') THEN
                Pv_CampoReferencial:='ID_OFICINA';
                Pv_ValorCampoReferencial:=Pn_OficinaIdx;
              ELSIF(Lc_PlantillaDet.TIPO_CUENTA_CONTABLE='BANCOS') THEN  
                Pv_CampoReferencial:='';
                Pv_ValorCampoReferencial:=Cr_OficinasFacturado(Pn_OficinaIdx).CUENTA_CONTABLE_ID;
              ELSIF(Lc_PlantillaDet.TIPO_CUENTA_CONTABLE='BANCOS DEBITOS MD') AND Cr_OficinasFacturado(Pn_OficinaIdx).CUENTA_CONTABLE_ID IS NULL THEN  
                Pv_CampoReferencial:='ID_GRUPO_DEBITO_DET';
                Pv_ValorCampoReferencial:=Cr_OficinasFacturado(Pn_OficinaIdx).BANCO_TIPO_CUENTA_ID;
              END IF;

              --Definicion del monto
              Pn_Monto  :=Pn_ValorTotal;

              --Obtenemos la cuenta contable
              DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_OBTENER_CUENTA_CONTABLE(Pv_CodEmpresa,
                                                                  Lc_PlantillaDet.TIPO_CUENTA_CONTABLE,
                                                                  Pv_CampoReferencial,
                                                                  Pv_ValorCampoReferencial,
                                                                  Pn_OficinaIdx,
                                                                  Cr_CtaContable,
                                                                  Cr_NoCta);
              Lr_MigraArckml.COD_CONT     := Cr_CtaContable;
              --
              IF Lc_PlantillaDet.POSICION='D' THEN
                Lr_MigraArckml.MODIFICABLE  := 'S';
              ELSE
                Lr_MigraArckml.MODIFICABLE  := 'N';
              END IF;
              --
              Pv_MsnError := NULL;
              --
              IF Lr_MigraArckml.COD_CONT IS NOT NULL THEN
                NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml,Pv_MsnError);
                --
                IF Pv_MsnError IS NOT NULL THEN
                  --
                  Pv_MsnError := 'Error al insertar el detalle del asiento contable en la tabla NAF47_TNET.MIGRA_ARCKML. - ID_DOCUMENTO( ' || 
                                 Pv_IdDocumento || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                  --
                  RAISE Le_Exception;
                  --
                END IF;
                
                IF nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen THEN
                  
                   Lr_MigraArckml.NO_CIA            := Lv_EmpresaDestino;
                   Lr_MigraArckml.MIGRACION_ID           :=  Ln_IdMigracion18;
                   
                   NAF47_TNET.GEK_MIGRACION.P_INSERTA_MIGRA_ARCKML(Lr_MigraArckml,Pv_MsnError);
                   
                   Lr_MigraArckml.MIGRACION_ID           :=  Ln_IdMigracion33;
                   Lr_MigraArckml.NO_CIA            := Pv_CodEmpresa;
                   
                   IF Pv_MsnError IS NOT NULL THEN
                  --
                    Pv_MsnError := 'Error al insertar el detalle del asiento contable en la tabla NAF47_TNET.MIGRA_ARCKML. - ID_DOCUMENTO( ' || 
                                   Pv_IdDocumento || ' ), PROCESO( ' || Pv_TipoProceso || ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                    --
                    RAISE Le_Exception;
                  end if;
               END IF;
                
              END IF;
              --
            END LOOP;

            --Despues de meter los detalles actualizo la cabecera con el valor de la NO_CTA
            Lr_MigraArckmm.NO_CTA := Cr_NoCta;
            --
            DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.UPDATE_MIGRA_ARCKMM(Lv_NoAsiento,
                                                                            Pv_CodEmpresa,
                                                                            Lr_MigraArckmm,
                                                                            Pv_MsnError);
                                                                            
            if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen then
              Lr_MigraArckmm.NO_CIA := Lv_EmpresaDestino;
              Lr_MigraArckmm.Id_Migracion := Ln_IdMigracion18;
              
              DB_FINANCIERO.FNKG_TRANSACTION_CONTABILIZAR.UPDATE_MIGRA_ARCKMM(Lv_NoAsiento,
                                                                            Lv_EmpresaDestino,
                                                                            Lr_MigraArckmm,
                                                                            Pv_MsnError);
              Lr_MigraArckmm.NO_CIA := Pv_CodEmpresa;
              Lr_MigraArckmm.Id_Migracion := Ln_IdMigracion33;
            end if;
            --
            --
            DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_MARCAR_CONTABILIZADO(Pv_IdDocumento,Pv_TipoProceso);
            --
            --
            Lr_MigraDocumentoAsociado                     := NULL;
            Lr_MigraDocumentoAsociado.DOCUMENTO_ORIGEN_ID := Pv_IdDocumento;
            Lr_MigraDocumentoAsociado.TIPO_DOC_MIGRACION  := Lv_CodDiario;
            Lr_MigraDocumentoAsociado.NO_CIA              := Pv_CodEmpresa;
            Lr_MigraDocumentoAsociado.FORMA_PAGO_ID       := NULL;
            Lr_MigraDocumentoAsociado.TIPO_DOCUMENTO_ID   := '9';
            Lr_MigraDocumentoAsociado.ESTADO              := 'M';
            Lr_MigraDocumentoAsociado.USR_CREACION        := Lv_UsrCreacion;
            Lr_MigraDocumentoAsociado.FE_CREACION         := SYSDATE;
            Lr_MigraDocumentoAsociado.MIGRACION_ID        := Lr_MigraArckmm.ID_MIGRACION;
            Lr_MigraDocumentoAsociado.TIPO_MIGRACION      := 'CK';
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
              
              if nvl(Lv_BanderaReplicar,'N') = 'S' AND Pv_CodEmpresa = Lv_EmpresaOrigen then
                Lr_MigraDocumentoAsociado.NO_CIA := Lv_EmpresaDestino;
                Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion18;
                
                NAF47_TNET.GEK_MIGRACION.P_PROCESA_MIGRA_DOC_ASOCIADO(Lr_MigraDocumentoAsociado, 'I', Pv_MsnError);
                
                Lr_MigraDocumentoAsociado.NO_CIA := pv_codempresa;
                Lr_MigraDocumentoAsociado.MIGRACION_ID := Ln_IdMigracion33;
                
                IF Pv_MsnError IS NOT NULL THEN
                --
                   Pv_MsnError := 'Error al insertar el documento migrado en la tabla MIGRA_DOCUMENTO_ASOCIADO. - ID_DOCUMENTO( ' || Pv_IdDocumento ||
                               ' ), MENSAJE_ERROR( ' || Pv_MsnError || ' ).';
                --
                RAISE Le_Exception;
                --
              END IF;
                
              end if;
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
            --
          END IF;
        END IF;  

        --Cierro la plantilla
        CLOSE Cr_PlantillaCab;  

        --Aumento el indice de las oficinas
        Pn_OficinaIdx := Cr_OficinasFacturado.NEXT(Pn_OficinaIdx);
        --
      END LOOP;
    --
    COMMIT;
    --
  EXCEPTION
  --
  WHEN Le_Exception THEN
    --
    Pv_MsnError := SUBSTR(Pv_MsnError || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK,1,4000);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_CONTABILIZAR_NDI.P_PROCESAR', 
                                          Pv_MsnError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  WHEN OTHERS THEN
    --
    Pv_MsnError := SUBSTR(Pv_MsnError || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK,1,4000);
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_CONTABILIZAR_NDI.P_PROCESAR', 
                                          Pv_MsnError,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
    ROLLBACK;
    --
  END P_PROCESAR;

  FUNCTION F_GENERAR_LISTADO_MOTIVOS(
      F_IdxMasivo     IN NUMBER,
      Pv_TipoProceso  IN  VARCHAR2
      )
  RETURN TypeMotivos
  AS
    Lv_InfoError      VARCHAR2(4000);
    Lv_ListadoMotivos TypeMotivos;
  BEGIN
    --Debido a cada iteracion del for de masivo
    IF Pv_TipoProceso='MASIVO' THEN
      IF F_IdxMasivo=1 THEN
        --Listado de motivos de reubicacion de pago
        Lv_ListadoMotivos:=TypeMotivos(
        'Traslado de pago',
        'Traslado, buen historial de pagos',
        'Regularizacion pago no corresponde',
        'Regularizacion debito no corresponde');
      ELSIF F_IdxMasivo=2 THEN
        --Listado de motivos por reversa de pago
        Lv_ListadoMotivos:=TypeMotivos(
        'Error de ingreso de PAGOS',
        'Devolucion a clientes por PAGO',
        'Error de digitaci n en forma de pago',
        'Actualizar Forma de Pago (SAC)',
        'Falta Completar Forma Pago en Telcos+',
        'Error pago cliente HK',
        'Error pago cliente otra empresa',
        'Excepci n a pago con t/c',
        'Sistema subi  el pago al login cancelado y no al activo',
        'Devolucion por doble pago',
        'Banco Reversa Pago',
        'Devolucion por doble pago',
        'Devolucion por cancelacion no procesada',
        'Devolucion por saldo a favor');
      END IF;
    END IF;
    RETURN Lv_ListadoMotivos;
    EXCEPTION
    WHEN OTHERS THEN
      Lv_InfoError:=SUBSTR(DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                        'FNKG_CONTABILIZAR_NDI.F_GENERAR_LISTADO_MOTIVOS', 
                        Lv_InfoError,
                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                        SYSDATE, 
                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
  END F_GENERAR_LISTADO_MOTIVOS;

  PROCEDURE P_CONTABILIZAR(
    Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoTipoDocumento  IN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
    Pv_TipoProceso          IN  VARCHAR2,
    Pv_IdDocumento          IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    Pv_FechaProceso         IN  VARCHAR2
  )
  AS
  --
    --
    CURSOR C_TIPO_MOTIVO_MASIVO (Cv_NombreMotivo VARCHAR2 DEFAULT NULL) IS
      SELECT DISTINCT APD.VALOR4 CODIGO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
           DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.NOMBRE_PARAMETRO = Gv_ValidaProcesoContable
      AND APC.ESTADO = Gv_EstadoActivo
      AND APD.ESTADO = Gv_EstadoActivo
      AND APD.DESCRIPCION = Gv_ContabilizaNdi
      AND APD.VALOR2 = Gv_MotivoContabiliza
      AND APD.VALOR3 = Gv_Masivo
      AND APD.EMPRESA_COD = Pv_CodEmpresa
      AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
      AND APD.VALOR1 = NVL(Cv_NombreMotivo, APD.VALOR1)
      ;

    
    --
    --Variables para FODATEL
    Pt_Fe_Actual              VARCHAR2(100);
    Pt_Fe_Actual_Modificada   VARCHAR2(100);
    --
    Cr_Listado                SYS_REFCURSOR;
    --Para manejo de errores
    Pv_MsnError               VARCHAR2(3000);
    --
    Lv_MotivoMasivo           VARCHAR2(100);
    --
    Pn_FlatPlantilla          VARCHAR2(4);
    --
    Lv_StringMotivo           VARCHAR2(1000);
    --
    Lv_BanderaMotivo          VARCHAR2(1):='N';
    --
    Pr_Arreglo                DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.TypeArreglo;
    --
  BEGIN

    --SE REGISTRAN LOS SIGUIENTES PARAMETROS EN LA TABLA INFO_ERROR dnatha 29/10/2019
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'LOG DE EJECUCION DE PAGOS',
                                          'Ejecucion del proceso FNKG_CONTABILIZAR_DNI.P_CONTABILIZAR con los sgtes parametros... Codigo de empresa: ' || Pv_CodEmpresa || ', prefijo: ' || Pv_Prefijo || ' , codigoTipoDocumento: ' || Pv_CodigoTipoDocumento || ' , tipoProceso: ' || Pv_TipoProceso || ', idDocumento: ' || Pv_IdDocumento || ', fechaProceso: ' || Pv_FechaProceso,
                                          'telcos',
                                          SYSDATE,     
                                          '172.0.0.1');
                                          
    /*Proceso:
      --Para el proceso MASIVO
      ---Utilizamos un for para el recorrido de cada uno de los procesos de la NDI masivo
      ---Agrupamos los valores por oficina

      --Para el proceso INDIVIDUAL
      ---Hay que reconocer que tipo vamos a procesar, CHPRT, REVRET, REVCANJE
      ---Por la forma de pago asociada al pago puedo determinar como obtener la plantilla
      ---Proceso como el masivo
    */
    --Inicializando    
    Pn_FlatPlantilla:='';  
    --Llamo al proceso especifico por Pv_CodigoTipoDocumento
    IF Pv_TipoProceso='MASIVO' THEN
      --Si es el proceso MASIVO, debo verificar que Pv_FechaProceso este llena para procesar segun esa fecha
      IF(Pv_FechaProceso IS NOT NULL) THEN
        Pt_Fe_Actual := Pv_FechaProceso;
      ELSE  
        --Para el proceso masivo es un dia menos 1, ya que se ejecutara en la madrugada del siguiente dia
        SELECT TO_CHAR(sysdate-1,'dd/mm/yyyy')
        INTO Pt_Fe_Actual
        FROM DUAL;
      END IF;
      --
      --FOR idx_Masivo IN 1..2 LOOP
      FOR Lr_TipoMotivo IN C_TIPO_MOTIVO_MASIVO LOOP
        --
        P_LISTADO_NDI( Pv_CodEmpresa, 
                       Pt_Fe_Actual, 
                       Lr_TipoMotivo.Codigo, 
                       Pv_CodigoTipoDocumento, 
                       Cr_Listado);  
        --
        --
        --Se llame el proceso para la generacion de los detalles
        --Se procede a transformar la fecha
        --Fomato de Fecha en P_PROCESAR: yyyy-mm-dd | En proceso IN: dd/mm/yyyy
        --FNKG_CONTABILIZAR_FACT_NC.P_SPLIT(Pt_Fe_Actual,'-',Pr_Arreglo);
        DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_SPLIT(Pt_Fe_Actual,'/',Pr_Arreglo);
        Pt_Fe_Actual_Modificada:=Pr_Arreglo(2)||'-'||Pr_Arreglo(1)||'-'||Pr_Arreglo(0);
        --
        P_PROCESAR(
          Cr_Listado,
          Pv_CodEmpresa,
          Pv_Prefijo,
          Pv_TipoProceso,
          Pv_CodigoTipoDocumento,
          NULL,
          Pt_Fe_Actual_Modificada,
          Pn_FlatPlantilla
        );
      END LOOP;
    
    ELSIF Pv_TipoProceso='INDIVIDUAL' THEN
      Pn_FlatPlantilla := '';
      Lv_StringMotivo  := F_OBTENER_MOTIVO(Pv_IdDocumento);
      --
      IF C_TIPO_MOTIVO_MASIVO%ISOPEN THEN
        CLOSE C_TIPO_MOTIVO_MASIVO;
      END IF;
      --
      OPEN C_TIPO_MOTIVO_MASIVO(Lv_StringMotivo);
      FETCH C_TIPO_MOTIVO_MASIVO INTO Lv_MotivoMasivo;
      IF C_TIPO_MOTIVO_MASIVO%NOTFOUND THEN
        Lv_MotivoMasivo := NULL;
      END IF;
      CLOSE C_TIPO_MOTIVO_MASIVO;
      --
      IF Lv_MotivoMasivo IS NULL THEN
        Lv_BanderaMotivo := 'N';
      ELSE
        Lv_BanderaMotivo := 'S';
      END IF;
      --      
      IF (Lv_BanderaMotivo='N') THEN
        --
        P_LISTADO_NDI_INDIVIDUAL(Pv_CodEmpresa,Pv_CodigoTipoDocumento,Pv_IdDocumento,Cr_Listado);
        --
        P_PROCESAR(
          Cr_Listado,
          Pv_CodEmpresa,
          Pv_Prefijo,
          Pv_TipoProceso,
          Pv_CodigoTipoDocumento,
          Pv_IdDocumento,
          Pt_Fe_Actual,
          NULL
          );
        --
      END IF;
      --
    END IF;
    --
    EXCEPTION
      WHEN OTHERS THEN
        Pv_MsnError:=SUBSTR('Error:'||DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),1,4000);
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                          'FNKG_CONTABILIZAR_NDI.P_CONTABILIZAR', 
                          Pv_MsnError,
                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                          SYSDATE, 
                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
  END P_CONTABILIZAR;

END FNKG_CONTABILIZAR_NDI;
/